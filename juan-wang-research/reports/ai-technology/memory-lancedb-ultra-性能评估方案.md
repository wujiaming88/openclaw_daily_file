# memory-lancedb-ultra 端到端性能影响评估方案

> 目标：量化插件对 OpenClaw Agent 请求链路的延迟、token、成本、质量影响，输出可对比的基线数据。

---

## 1. 测试模型：插件在请求链路中的切入点

```
用户消息到达
    │
    ▼
[测量点 A] ── 请求接收时间戳
    │
    ▼
before_agent_start hook ──────────── [插件切入点 1: Auto-Recall]
    ├── stripSystemMessage()           │ CPU: 正则清洗
    ├── Embedder.embed(prompt)         │ 网络: embedding API 调用
    ├── db.search(vector, 20, 0.3)     │ I/O: LanceDB 向量搜索
    └── formatRelevantMemoriesContext() │ CPU: 格式化 + 转义
    │
    ▼
[测量点 B] ── Auto-Recall 完成
    │
    ▼
LLM 推理（system prompt + 注入记忆 + 用户消息）
    │
    ▼
[测量点 C] ── LLM 首 token / 完成
    │
    ▼
agent_end hook ──────────────────── [插件切入点 2: Auto-Capture]
    ├── 消息提取 + 清洗                 │ CPU
    ├── shouldCapture() 过滤            │ CPU
    ├── Embedder.embed() × N           │ 网络: N 次 embedding
    ├── db.search() × N (去重)          │ I/O: N 次向量搜索
    └── db.store() × N                 │ I/O: N 次写入
    │
    ▼
[测量点 D] ── 响应完全交付
```

---

## 2. 四个测量维度

### 维度 1: 延迟影响 (Latency Impact)

| 指标 | 计算方式 | 基线对照 |
|------|---------|---------|
| **P50/P95/P99 Auto-Recall 延迟** | 测量点 B - A | 插件禁用时为 0 |
| **P50/P95/P99 Auto-Capture 延迟** | 测量点 D - C | 插件禁用时为 0 |
| **E2E 延迟增量** | (D-A)_插件启用 - (D-A)_插件禁用 | 绝对差值 |
| **首 token 延迟影响 (TTFT)** | 测量点 C(首token) - A | 核心用户感知指标 |
| **LLM 推理时间增量** | C_启用 - C_禁用 | 因注入记忆导致 prompt 变长 |

### 维度 2: Token 消耗影响 (Token Impact)

| 指标 | 计算方式 | 说明 |
|------|---------|------|
| **注入记忆 token 数** | count_tokens(prependContext) | 每次 Auto-Recall 注入的额外 token |
| **System prompt 膨胀率** | (sys_prompt_启用 / sys_prompt_禁用) - 1 | 百分比增长 |
| **Embedding API 调用次数/对话** | recall(1) + capture(0-3) | 每次对话的 embedding 开销 |
| **Embedding token 消耗** | input_chars / 4 (估算) | embedding 模型的 token 用量 |
| **LLM input token 增量** | input_tokens_启用 - input_tokens_禁用 | 因记忆注入增加的 LLM input |

### 维度 3: 成本影响 (Cost Impact)

| 指标 | 计算方式 | 说明 |
|------|---------|------|
| **Embedding 成本/对话** | API 调用次数 × 单价 | Doubao ~¥0.004/对话 |
| **LLM 增量成本/对话** | 注入 token × LLM input 单价 | Opus: $15/M input tokens |
| **月度总增量成本** | 日均对话数 × 单对话增量 × 30 | 多租户需乘租户数 |
| **缓存命中影响** | cache_read_tokens 变化 | 记忆注入可能破坏 prompt cache |

### 维度 4: 质量影响 (Quality Impact)

| 指标 | 计算方式 | 说明 |
|------|---------|------|
| **记忆命中率** | 有效召回次数 / 总召回次数 | Auto-Recall 返回非空结果的比例 |
| **记忆相关性** | avg(similarity_score) 过滤 > 0.3 | 召回记忆的平均相关度 |
| **噪声比** | 不相关记忆数 / 总召回数 | 人工标注或 LLM-as-Judge |
| **回答准确率提升** | A/B 对比评分 | 有/无记忆时回答质量对比 |

---

## 3. 测试方案设计

### 3.1 环境准备

```bash
# 测试环境隔离
export TEST_WORKSPACE="/tmp/memory-perf-test"
export TEST_LANCEDB_PATH="${TEST_WORKSPACE}/lancedb"
mkdir -p ${TEST_WORKSPACE}

# 两套配置：A 组（启用插件）和 B 组（禁用插件）
# A 组: autoRecall=true, autoCapture=true
# B 组: 插件完全禁用（或 autoRecall=false, autoCapture=false）
```

### 3.2 测试用例集

```yaml
# test-cases.yaml
test_suites:

  # ---- Suite 1: 冷启动基准 (空记忆库) ----
  cold_start:
    description: "记忆库为空时的基线开销"
    memory_count: 0
    cases:
      - id: CS-001
        prompt: "你好，今天天气怎么样？"
        expect_recall: 0  # 空库，应无召回
      - id: CS-002
        prompt: "帮我分析一下微服务架构的优缺点"
        expect_recall: 0
      - id: CS-003
        prompt: "记住我的邮箱是 test@example.com"
        expect_capture: 1  # 应触发存储

  # ---- Suite 2: 小规模记忆 (100 条) ----
  small_memory:
    description: "100 条记忆时的性能表现"
    memory_count: 100
    seed_data: "fixtures/100-memories.jsonl"
    cases:
      - id: SM-001
        prompt: "我之前说过喜欢什么水果？"
        expect_recall: ">0"
        expect_relevant: true
      - id: SM-002
        prompt: "帮我写一个 Python 脚本"
        expect_recall: ">=0"  # 可能匹配也可能不匹配
      - id: SM-003
        prompt: "我的项目用什么技术栈？"
        expect_recall: ">0"

  # ---- Suite 3: 中等规模 (1K 条) ----
  medium_memory:
    description: "1000 条记忆时的性能表现"
    memory_count: 1000
    seed_data: "fixtures/1k-memories.jsonl"
    cases:
      - id: MM-001
        prompt: "我之前说过喜欢什么水果？"
      - id: MM-002
        prompt: "总结一下我最近的学习进展"
      - id: MM-003
        prompt: "我的团队成员有哪些？"

  # ---- Suite 4: 大规模 (10K 条) ----
  large_memory:
    description: "10000 条记忆时的性能退化测试"
    memory_count: 10000
    seed_data: "fixtures/10k-memories.jsonl"
    cases:
      - id: LM-001
        prompt: "我之前说过喜欢什么水果？"
      - id: LM-002
        prompt: "帮我回顾一下上个月的工作"
      - id: LM-003
        prompt: "我在哪些项目上花了最多时间？"

  # ---- Suite 5: 高频连续对话 ----
  burst_mode:
    description: "连续 20 条消息模拟高频对话"
    memory_count: 500
    burst_count: 20
    interval_ms: 500
    cases:
      - id: BM-001
        prompts:
          - "你好"
          - "记住我喜欢咖啡"
          - "我的项目叫什么？"
          - "帮我查一下之前的技术选型"
          # ... 共 20 条
```

### 3.3 测试脚本

```python
#!/usr/bin/env python3
"""
memory-lancedb-ultra 性能基准测试
用法: python benchmark.py --config test-cases.yaml --output results/
"""

import json
import time
import subprocess
import statistics
import os
from dataclasses import dataclass, field, asdict
from typing import Optional

@dataclass
class TestResult:
    case_id: str
    prompt: str
    plugin_enabled: bool
    
    # 延迟指标 (ms)
    e2e_latency_ms: float = 0
    ttft_ms: float = 0  # Time To First Token
    recall_latency_ms: float = 0
    capture_latency_ms: float = 0
    llm_latency_ms: float = 0
    
    # Token 指标
    input_tokens: int = 0
    output_tokens: int = 0
    injected_memory_tokens: int = 0
    cache_read_tokens: int = 0
    cache_write_tokens: int = 0
    
    # 记忆指标
    recall_count: int = 0
    recall_avg_score: float = 0
    capture_count: int = 0
    embedding_calls: int = 0
    
    # 成本指标
    embedding_cost: float = 0
    llm_input_cost: float = 0
    llm_output_cost: float = 0
    total_cost: float = 0
    
    # 元数据
    memory_count: int = 0
    timestamp: str = ""
    error: Optional[str] = None


def run_single_test(
    prompt: str,
    agent_id: str,
    plugin_enabled: bool,
    memory_count: int
) -> TestResult:
    """执行单次测试，收集所有指标"""
    
    result = TestResult(
        case_id="",
        prompt=prompt,
        plugin_enabled=plugin_enabled,
        memory_count=memory_count,
        timestamp=time.strftime("%Y-%m-%dT%H:%M:%S")
    )
    
    # ── 方法 1: CLI 单轮执行 + 日志解析 ──
    # 使用 openclaw agent 命令执行单轮对话
    start_time = time.perf_counter()
    
    env = os.environ.copy()
    if not plugin_enabled:
        # 通过环境变量或配置禁用插件
        env["OPENCLAW_DISABLE_PLUGINS"] = "memory-lancedb-ultra"
    
    proc = subprocess.run(
        [
            "openclaw", "agent",
            "--agent", agent_id,
            "--prompt", prompt,
            "--json",  # 如果支持 JSON 输出
            "--no-stream",  # 禁用流式，方便计时
        ],
        capture_output=True,
        text=True,
        env=env,
        timeout=120
    )
    
    end_time = time.perf_counter()
    result.e2e_latency_ms = (end_time - start_time) * 1000
    
    # ── 解析日志提取细分指标 ──
    # 从 Gateway 日志和插件日志中提取
    parse_gateway_logs(result)
    parse_plugin_logs(result)
    parse_llm_usage(result, proc.stdout)
    
    return result


def parse_gateway_logs(result: TestResult):
    """
    从 Gateway 日志提取时间线
    
    关键日志行（需在插件代码中添加或从现有日志解析）:
    - "memory-lancedb-ultra: injecting N memories into context"
    - "memory-lancedb-ultra: auto-captured N memories"
    - "memory-lancedb-ultra: stats recorded source=auto recallCount=N hitTokens=N"
    """
    log_file = f"/tmp/openclaw/openclaw-{time.strftime('%Y-%m-%d')}.log"
    if not os.path.exists(log_file):
        return
    
    with open(log_file, 'r') as f:
        for line in f:
            try:
                entry = json.loads(line)
                if entry.get("component") == "memory-lancedb-ultra":
                    if entry.get("type") == "cache_read":
                        result.injected_memory_tokens = entry.get("saveToken", 0)
                        result.embedding_calls += 1
            except json.JSONDecodeError:
                continue


def parse_plugin_logs(result: TestResult):
    """从插件日志提取召回/存储统计"""
    # 插件通过 api.logger.info 输出的结构化日志
    # 格式: "memory-lancedb-ultra: stats recorded source=tool recallCount=5 hitTokens=1200"
    pass


def parse_llm_usage(result: TestResult, stdout: str):
    """从 LLM 响应中提取 usage 数据"""
    try:
        response = json.loads(stdout)
        usage = response.get("usage", {})
        result.input_tokens = usage.get("input_tokens", 0)
        result.output_tokens = usage.get("output_tokens", 0)
        result.cache_read_tokens = usage.get("cache_read_input_tokens", 0)
        result.cache_write_tokens = usage.get("cache_creation_input_tokens", 0)
    except (json.JSONDecodeError, AttributeError):
        pass


def run_benchmark_suite(
    suite_name: str,
    cases: list,
    agent_id: str,
    memory_count: int,
    repeats: int = 5
) -> dict:
    """运行一组测试用例，每个用例重复 N 次取统计值"""
    
    all_results = []
    
    for case in cases:
        for plugin_enabled in [True, False]:  # A/B 对照
            case_results = []
            
            for i in range(repeats):
                result = run_single_test(
                    prompt=case["prompt"],
                    agent_id=agent_id,
                    plugin_enabled=plugin_enabled,
                    memory_count=memory_count
                )
                result.case_id = f"{case['id']}_{'ON' if plugin_enabled else 'OFF'}_{i}"
                case_results.append(result)
                
                # 避免速率限制
                time.sleep(2)
            
            # 计算统计值
            summary = compute_statistics(case["id"], plugin_enabled, case_results)
            all_results.append(summary)
    
    return {
        "suite": suite_name,
        "memory_count": memory_count,
        "repeats": repeats,
        "results": all_results
    }


def compute_statistics(case_id: str, plugin_enabled: bool, results: list) -> dict:
    """计算一组结果的统计值"""
    
    latencies = [r.e2e_latency_ms for r in results]
    input_tokens_list = [r.input_tokens for r in results]
    
    return {
        "case_id": case_id,
        "plugin_enabled": plugin_enabled,
        "samples": len(results),
        "latency": {
            "p50_ms": statistics.median(latencies),
            "p95_ms": sorted(latencies)[int(len(latencies) * 0.95)] if len(latencies) >= 20 else max(latencies),
            "p99_ms": sorted(latencies)[int(len(latencies) * 0.99)] if len(latencies) >= 100 else max(latencies),
            "mean_ms": statistics.mean(latencies),
            "stdev_ms": statistics.stdev(latencies) if len(latencies) > 1 else 0,
        },
        "tokens": {
            "input_mean": statistics.mean(input_tokens_list),
            "injected_memory_mean": statistics.mean([r.injected_memory_tokens for r in results]),
            "cache_read_mean": statistics.mean([r.cache_read_tokens for r in results]),
        },
        "memory": {
            "recall_count_mean": statistics.mean([r.recall_count for r in results]),
            "recall_avg_score_mean": statistics.mean([r.recall_avg_score for r in results if r.recall_avg_score > 0] or [0]),
            "embedding_calls_mean": statistics.mean([r.embedding_calls for r in results]),
        }
    }
```

### 3.4 种子数据生成

```python
#!/usr/bin/env python3
"""生成测试用种子记忆数据"""

import json
import random
import uuid
from datetime import datetime, timedelta

CATEGORIES = ["preference", "fact", "decision", "entity", "other"]

TEMPLATES = {
    "preference": [
        "用户喜欢使用 {tech} 进行开发",
        "用户偏好 {style} 风格的代码",
        "用户习惯在 {time} 工作",
    ],
    "fact": [
        "用户的项目使用 {tech} 技术栈",
        "用户的团队有 {num} 人",
        "用户在 {city} 工作",
    ],
    "decision": [
        "决定从 {tech_a} 迁移到 {tech_b}",
        "选择使用 {tool} 作为 CI/CD 工具",
        "规定代码审查至少需要 {num} 个 Approval",
    ],
    "entity": [
        "团队成员 {name} 负责 {area}",
        "用户的邮箱是 {email}",
        "项目仓库地址 github.com/{org}/{repo}",
    ],
    "other": [
        "上次讨论了 {topic}",
        "用户提到想学习 {tech}",
        "项目计划在 {month} 完成 {milestone}",
    ],
}

TECH = ["Python", "Go", "Rust", "TypeScript", "Java", "React", "Vue", "K8s", "Docker"]
CITIES = ["上海", "北京", "深圳", "杭州", "新加坡"]
NAMES = ["张三", "李四", "王五", "赵六", "Alice", "Bob"]

def generate_memory(category: str, base_date: datetime) -> dict:
    template = random.choice(TEMPLATES[category])
    text = template.format(
        tech=random.choice(TECH),
        tech_a=random.choice(TECH),
        tech_b=random.choice(TECH),
        style=random.choice(["函数式", "面向对象", "声明式"]),
        time=random.choice(["早上", "深夜", "下午"]),
        num=random.randint(2, 15),
        city=random.choice(CITIES),
        tool=random.choice(["GitHub Actions", "GitLab CI", "Jenkins"]),
        name=random.choice(NAMES),
        area=random.choice(["前端", "后端", "运维", "测试"]),
        email=f"test{random.randint(1,99)}@example.com",
        org="myorg",
        repo=f"project-{random.randint(1,10)}",
        topic=random.choice(["微服务架构", "性能优化", "安全加固"]),
        month=random.choice(["4月", "5月", "6月"]),
        milestone=random.choice(["MVP", "Beta", "GA"]),
    )
    
    created_at = base_date - timedelta(days=random.randint(0, 90))
    date_prefix = created_at.strftime("[%Y年%m月%d日]")
    
    return {
        "id": str(uuid.uuid4()),
        "text": f"{date_prefix} {text}",
        "importance": round(random.uniform(0.3, 1.0), 2),
        "category": category,
        "createdAt": int(created_at.timestamp() * 1000),
    }

def generate_fixtures(count: int, output_path: str):
    base_date = datetime.now()
    with open(output_path, 'w') as f:
        for i in range(count):
            category = random.choice(CATEGORIES)
            memory = generate_memory(category, base_date)
            f.write(json.dumps(memory, ensure_ascii=False) + '\n')
    print(f"Generated {count} memories → {output_path}")

if __name__ == "__main__":
    generate_fixtures(100, "fixtures/100-memories.jsonl")
    generate_fixtures(1000, "fixtures/1k-memories.jsonl")
    generate_fixtures(10000, "fixtures/10k-memories.jsonl")
```

---

## 4. 更精确的测量方案：侵入式埋点

上面的方案依赖外部计时和日志解析，精度有限。如果可以修改插件源码（你维护 fork），推荐在关键路径上埋点：

### 4.1 插件内埋点方案

```typescript
// 在 index.ts 中添加
function createTimer() {
  const start = process.hrtime.bigint();
  return {
    elapsed(): number {
      return Number(process.hrtime.bigint() - start) / 1e6; // ms
    }
  };
}

// before_agent_start hook 中
api.on("before_agent_start", async (event, ctx) => {
  const timer = createTimer();
  const metrics: Record<string, number> = {};
  
  // 1. 清洗
  const t0 = timer.elapsed();
  const query = stripSystemMessage(event.prompt);
  metrics.strip_ms = timer.elapsed() - t0;
  
  // 2. Embedding
  const t1 = timer.elapsed();
  const vector = await embeddings.embed(query);
  metrics.embed_ms = timer.elapsed() - t1;
  
  // 3. 搜索
  const t2 = timer.elapsed();
  const results = await db.search(vector, 20, 0.3);
  metrics.search_ms = timer.elapsed() - t2;
  
  // 4. 格式化
  const t3 = timer.elapsed();
  const context = formatRelevantMemoriesContext(...);
  metrics.format_ms = timer.elapsed() - t3;
  
  // 5. 总延迟
  metrics.total_ms = timer.elapsed();
  metrics.recall_count = results.length;
  metrics.injected_chars = context.length;
  
  // 输出结构化指标
  api.logger.info(JSON.stringify({
    event: "memory_recall_metrics",
    sessionKey: ctx.sessionKey,
    ...metrics
  }));
  
  return { prependContext: context };
});
```

### 4.2 Gateway 侧追踪

利用 OpenClaw 的 hooks 系统捕获完整时间线：

```json5
// openclaw.json
{
  hooks: {
    // 命令级追踪：记录每次 Agent Turn 的完整 usage
    "message:received": {
      handler: "log",
      config: {
        fields: ["sessionKey", "timestamp", "messageLength"]
      }
    },
    "message:sent": {
      handler: "log",
      config: {
        fields: ["sessionKey", "timestamp", "usage", "model", "latencyMs"]
      }
    }
  }
}
```

### 4.3 Embedding API 层追踪

在 Embedder 中添加调用计数器和延迟追踪：

```typescript
// embedder.ts 增强
class Embedder {
  private callCount = 0;
  private totalLatencyMs = 0;
  
  async embed(text: string): Promise<number[]> {
    this.callCount++;
    const start = performance.now();
    const result = await this._embed(text);
    this.totalLatencyMs += performance.now() - start;
    return result;
  }
  
  getMetrics() {
    return {
      callCount: this.callCount,
      totalLatencyMs: this.totalLatencyMs,
      avgLatencyMs: this.callCount > 0 ? this.totalLatencyMs / this.callCount : 0,
    };
  }
  
  resetMetrics() {
    this.callCount = 0;
    this.totalLatencyMs = 0;
  }
}
```

---

## 5. 输出报告格式

### 5.1 延迟对比表

```markdown
| 测试场景 | 记忆数 | 插件状态 | E2E P50 | E2E P95 | TTFT P50 | Recall 延迟 | Capture 延迟 |
|---------|--------|---------|---------|---------|----------|------------|-------------|
| 冷启动   | 0      | OFF     | 850ms   | 1200ms  | 320ms    | -          | -           |
| 冷启动   | 0      | ON      | 1050ms  | 1500ms  | 520ms    | 180ms      | 0ms         |
| 小规模   | 100    | OFF     | 850ms   | 1200ms  | 320ms    | -          | -           |
| 小规模   | 100    | ON      | 1150ms  | 1800ms  | 550ms    | 280ms      | 450ms       |
| 中规模   | 1K     | OFF     | 850ms   | 1200ms  | 320ms    | -          | -           |
| 中规模   | 1K     | ON      | 1250ms  | 2100ms  | 580ms    | 350ms      | 480ms       |
| 大规模   | 10K    | OFF     | 850ms   | 1200ms  | 320ms    | -          | -           |
| 大规模   | 10K    | ON      | 1500ms  | 2800ms  | 650ms    | 600ms      | 520ms       |
```

### 5.2 Token/成本对比表

```markdown
| 场景 | 插件状态 | Input Tokens | 注入记忆 Tokens | Cache Read | Embedding 调用 | 增量成本/对话 |
|------|---------|-------------|----------------|------------|---------------|-------------|
| 100条 | OFF    | 3200        | 0              | 2800       | 0             | $0          |
| 100条 | ON     | 4500        | 1300           | 1200       | 1-4           | ~$0.02      |
| 1K条  | OFF    | 3200        | 0              | 2800       | 0             | $0          |
| 1K条  | ON     | 4800        | 1600           | 800        | 1-4           | ~$0.03      |
```

### 5.3 缓存命中影响

```markdown
| 场景 | 插件状态 | cache_read_tokens | cache_write_tokens | 命中率 | 说明 |
|------|---------|-------------------|--------------------|----|------|
| 连续对话 | OFF | 28000 | 3500 | 89% | 稳定的 system prompt |
| 连续对话 | ON  | 8000  | 24000 | 25% | 每次注入不同记忆，prefix 变化 |
```

### 5.4 记忆规模 vs 搜索延迟曲线

```
搜索延迟 (ms)
    │
700 ┤                                            ╱
    │                                          ╱
500 ┤                                      ╱
    │                              ╱╱╱╱╱
300 ┤                    ╱╱╱╱╱╱╱╱╱
    │          ╱╱╱╱╱╱╱╱╱
200 ┤    ╱╱╱╱╱
    │╱╱╱
100 ┤
    │
    └──┬──────┬──────┬──────┬──────┬──── 记忆数量
      100    500    1K     5K    10K
```

---

## 6. 关键实验设计

### 实验 1: Auto-Recall 对 Prompt Cache 的影响

**假设**：Auto-Recall 注入的 `<relevant-memories>` 块每次内容不同，导致 Anthropic prompt cache 失效。

**方法**：
1. 发送相同消息 10 次，记录每次的 `cache_read_input_tokens`
2. A 组：插件启用（注入不同记忆）
3. B 组：插件禁用

**预期**：
- B 组：第 2 次开始 cache_read > 0
- A 组：每次 cache_read ≈ 0（因为 prependContext 每次不同）

**验证代码**：
```bash
# 发送 10 次相同消息，收集 usage
for i in $(seq 1 10); do
  openclaw agent --prompt "你好" --json 2>/dev/null | \
    jq '{run: '$i', cache_read: .usage.cache_read_input_tokens, cache_write: .usage.cache_creation_input_tokens, input: .usage.input_tokens}'
  sleep 3
done
```

### 实验 2: 记忆数量 vs 搜索延迟的拐点

**假设**：IVF_FLAT 索引在某个数据量后搜索延迟快速增长。

**方法**：
1. 初始化空库
2. 每次写入 100 条记忆
3. 每 100 条执行 10 次 search，记录延迟
4. 直到 50K 条

**验证代码**：
```bash
# 通过 CLI 执行搜索并计时
for count in 100 500 1000 2000 5000 10000 20000 50000; do
  # 种子数据到 $count 条
  seed_memories $count
  
  # 执行 10 次搜索
  for i in $(seq 1 10); do
    time openclaw ltm search "用户偏好" --limit 20
  done 2>&1 | grep real | awk '{print "'$count'", $2}'
done
```

### 实验 3: Auto-Capture 的 Token 浪费率

**假设**：Auto-Capture 存储了大量无意义记忆（因 MEMORY_TRIGGERS 未使用）。

**方法**：
1. 启用 autoCapture，进行 100 轮正常对话
2. 导出所有存储的记忆
3. 人工标注每条记忆的有效性（有效/无效/噪声）
4. 计算有效存储率

```bash
# 导出所有记忆
openclaw ltm list | jq -c '.[] | {text, category}' > captured-memories.jsonl

# 统计
total=$(wc -l < captured-memories.jsonl)
echo "Total captured: $total"
# 然后人工标注...
```

---

## 7. 自动化持续追踪

### 7.1 Cron 定时基准测试

```json5
// openclaw.json - 每天跑一次基准
{
  cron: {
    jobs: [
      {
        id: "memory-perf-benchmark",
        schedule: { cron: "0 3 * * *" },  // 每天 3:00 AM
        payload: {
          agentId: "qa-benchmark",
          command: "运行 memory-lancedb-ultra 性能基准测试，将结果写入 shared/artifacts/perf-benchmarks/",
          model: "claude-sonnet-4-20250514",  // 用便宜模型跑基准
          delivery: { mode: "announce" }
        }
      }
    ]
  }
}
```

### 7.2 关键告警阈值

```yaml
# alerts.yaml
alerts:
  - name: memory_recall_slow
    condition: "recall_p95_ms > 500"
    severity: warning
    message: "Auto-Recall P95 延迟超过 500ms"
    
  - name: memory_recall_very_slow
    condition: "recall_p95_ms > 1000"
    severity: critical
    message: "Auto-Recall P95 延迟超过 1s，考虑禁用或优化索引"
    
  - name: cache_hit_degraded
    condition: "cache_hit_rate < 0.5 AND plugin_enabled"
    severity: warning
    message: "Prompt cache 命中率低于 50%，记忆注入可能破坏缓存"
    
  - name: memory_count_high
    condition: "memory_count > 10000"
    severity: info
    message: "记忆数量超过 10K，建议评估搜索性能"
```

---

## 8. 执行计划

| 阶段 | 内容 | 耗时 | 产出 |
|------|------|------|------|
| **Day 1** | 环境搭建 + 种子数据生成 + 基础脚本 | 0.5 天 | fixtures/*.jsonl + benchmark.py |
| **Day 2** | Suite 1-4 基准测试（冷启动→大规模） | 1 天 | 延迟/Token 基线数据 |
| **Day 3** | 实验 1-3（Cache 影响 + 拐点 + 浪费率） | 1 天 | 关键结论 |
| **Day 4** | 侵入式埋点（如果有 fork）+ 精细测量 | 0.5 天 | 细分延迟数据 |
| **Day 5** | 报告撰写 + 优化建议 | 0.5 天 | 最终评估报告 |

总计 **3-4 天**可完成完整评估。

---

*方案由 wairesearch (黄山) 设计 | 2026-03-31*
