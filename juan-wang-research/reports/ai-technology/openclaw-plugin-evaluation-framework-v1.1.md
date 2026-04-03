# OpenClaw 插件评估框架设计方案 v1.1

> **项目代号**: ClawGuard
> **作者**: 黄山 (wairesearch)
> **日期**: 2026-04-03
> **版本**: v1.1（迭代优化版，基于 v1.0 反馈）
> **变更**: MVP迭代开发、静态分析重新设计、插桩细化、AI生成评测集、本地文件输出优先

---

## 核心变更说明（v1.0 → v1.1）

| # | 问题 | v1.0 做法 | v1.1 改进 |
|---|------|-----------|-----------|
| 1 | 开发方式 | 大而全的一次性设计 | **MVP 4阶段迭代，每阶段独立可运行** |
| 2 | 静态分析 | 直接出结论 | **先结构化采集数据 → 交 OpenClaw Agent 分析** |
| 3 | 插桩方式 | 抽象描述 | **基于 OpenClaw Hook 系统，具体到代码级** |
| 4 | 评测集 | 预定义 YAML | **AI 读取插件代码动态生成针对性用例** |
| 5 | 数据收集 | 上报服务端 | **本地 JSONL 文件优先，静态+动态合并送 LLM-Judge** |

---

## 第一章：MVP 迭代开发路线图

### 1.1 第一性原理：为什么要 MVP 迭代？

传统框架的陷阱：设计完整再实现 → 3个月后才能跑起来 → 发现大量假设是错的 → 推倒重来。

ClawGuard 的原则：**每个 MVP 必须可独立运行、产生真实价值**，下一阶段在上一阶段基础上叠加。

### 1.2 四阶段 MVP

```
MVP-1 (Week 1-2)          MVP-2 (Week 3-4)         MVP-3 (Week 5-7)         MVP-4 (Week 8-10)
┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│ 静态结构化采集    │  →   │ AI驱动静态分析   │  →   │ 动态插桩+评测集  │  →   │ LLM-Judge综合评分│
│                  │      │                  │      │                  │      │                  │
│ • 插件结构解析   │      │ • OpenClaw Agent │      │ • Hook插桩注入   │      │ • 静态+动态合并  │
│ • manifest读取   │      │   分析结构数据   │      │ • AI生成评测集   │      │ • LLM综合评分   │
│ • 依赖图         │      │ • 输出结构化报告 │      │ • JSONL本地输出  │      │ • 最终认证等级  │
│ • 原始数据JSON   │      │ • 人工可读报告   │      │ • 评测数据分析   │      │ • 完整报告      │
└──────────────────┘      └──────────────────┘      └──────────────────┘      └──────────────────┘
     ↑ 独立可用                  ↑ 独立可用                ↑ 独立可用                ↑ 完整流程
  结构数据JSON文件            静态分析报告MD            动态评测报告MD           综合评分报告MD
```

### 1.3 各阶段交付标准

#### MVP-1：结构化数据采集
- ✅ `clawguard extract <plugin-path>` 输出 `plugin-data.json`
- ✅ 包含：manifest、capability列表、hook列表、依赖、文件树、代码指标
- ✅ 无需 AI，纯程序运行

#### MVP-2：AI 静态分析
- ✅ `clawguard analyze <plugin-data.json>` 调用 OpenClaw Agent 输出 `static-report.md`
- ✅ 包含：安全、设计原则、Token预估分析
- ✅ MVP-1 输出作为输入

#### MVP-3：动态评测
- ✅ `clawguard bench <plugin-path>` 完成插桩+评测+数据收集
- ✅ 本地输出 `eval-data.jsonl` + `dynamic-report.md`
- ✅ AI 生成评测集

#### MVP-4：综合评分
- ✅ `clawguard score <static-report.md> <dynamic-report.md>` 输出最终认证报告
- ✅ LLM-Judge 给出评分 + 认证等级

---

## 第二章：静态分析层（重新设计）

### 2.1 设计思路：数据先行，AI 后析

**v1.0 问题**：直接让 AI 扫代码 → AI 容易幻觉、遗漏、不可复现

**v1.1 方案**：先用程序将插件"结构化"成干净的数据格式 → 再交给 OpenClaw Agent 做语义分析

```
插件源码
   │
   ▼
┌──────────────────────────────┐
│   Step 1: 结构化采集器        │  ← 纯程序，无 AI
│   (Structural Extractor)     │
└──────────────┬───────────────┘
               │ plugin-data.json
               ▼
┌──────────────────────────────┐
│   Step 2: OpenClaw Agent     │  ← AI 分析结构化数据
│   (Static Analysis Agent)   │
└──────────────┬───────────────┘
               │ static-report.md
               ▼
            静态分析报告
```

### 2.2 Step 1：结构化采集器

#### 2.2.1 采集内容

```typescript
// plugin-data.json 完整结构
interface PluginStructuredData {
  meta: {
    id: string;
    version: string;
    name: string;
    description: string;
    author: string;
    license: string;
    extractedAt: string;
  };

  manifest: {
    // openclaw.plugin.json 原始内容
    raw: Record<string, unknown>;
    // 解析结果
    capabilities: string[];         // ['text-inference', 'speech', ...]
    hooks: string[];                // ['before_prompt_build', 'message:received', ...]
    tools: { name: string; description: string; schema: object }[];
    configSchema: object | null;
    requiredPermissions: string[];  // ['exec', 'fs.read', 'network', ...]
  };

  dependencies: {
    production: { name: string; version: string; isPrivate: boolean }[];
    development: { name: string; version: string }[];
    knownVulnerabilities: { pkg: string; severity: string; cve: string }[];
    totalTransitive: number;
  };

  codeMetrics: {
    fileCount: number;
    totalLines: number;
    languageBreakdown: Record<string, number>;
    entryPoints: string[];
    hasTests: boolean;
    testCoverage: number | null;
    hasTypeScript: boolean;
    bundleSize: number;           // bytes
    estimatedLoadTime: number;    // ms
  };

  apiUsage: {
    // 静态分析 API 调用情况
    registeredCapabilities: {
      method: string;             // 'registerProvider', 'registerChannel', etc.
      location: string;           // 文件:行号
    }[];
    hooksUsed: {
      event: string;              // 'before_prompt_build', etc.
      location: string;
      isDeprecated: boolean;
    }[];
    externalNetworkCalls: {
      url: string | 'dynamic';    // 静态可提取的URL
      location: string;
      method: string;
    }[];
    fileSystemAccess: {
      operation: 'read' | 'write' | 'exec';
      path: string | 'dynamic';
      location: string;
    }[];
  };

  promptInjection: {
    // 检测系统提示注入点
    systemPromptHooks: string[];  // 注入系统提示的 Hook 列表
    estimatedTokensInjected: number;
    dynamicContentPatterns: {
      pattern: string;            // 正则
      location: string;
      cacheBreaking: boolean;     // 是否破坏 Prompt Cache
    }[];
    staticTokenCount: number;     // 静态部分 Token 数
    dynamicTokenRatio: number;    // 动态内容占比 0-1
  };

  securitySignals: {
    // 原始安全信号（不做判断，只收集事实）
    hardcodedStrings: { value: string; location: string; entropy: number }[];
    evalUsage: { location: string; isDynamic: boolean }[];
    shellCommands: { cmd: string | 'dynamic'; location: string }[];
    networkEgress: boolean;
    privateDataAccess: boolean;   // 访问 SSH keys, API keys, wallet 等
    externalDataIngestion: boolean; // 处理外部不可信内容
    lethalTrifecta: boolean;      // 三者同时满足
  };

  readme: {
    exists: boolean;
    length: number;
    hasInstallInstructions: boolean;
    hasApiDocs: boolean;
    hasExamples: boolean;
  };
}
```

#### 2.2.2 采集工具实现（MVP-1 核心代码）

```typescript
// src/extractor/index.ts
import { parse } from '@typescript-eslint/parser';
import { readFileSync, readdirSync, statSync } from 'fs';
import { execSync } from 'child_process';

export async function extractPluginData(pluginPath: string): Promise<PluginStructuredData> {
  const manifest = readManifest(pluginPath);
  const codeMetrics = analyzeCodeMetrics(pluginPath);
  const apiUsage = analyzeAPIUsage(pluginPath);      // 基于 AST
  const securitySignals = extractSecuritySignals(pluginPath);  // 基于 AST + 正则
  const promptInjection = analyzePromptInjection(pluginPath, apiUsage);
  const dependencies = analyzeDependencies(pluginPath);

  return { meta, manifest, dependencies, codeMetrics, apiUsage, promptInjection, securitySignals, readme };
}

// Token 注入预估：遍历 Hook 代码，统计字符串模板大小
function analyzePromptInjection(pluginPath: string, apiUsage: ApiUsage): PromptInjectionData {
  const systemHooks = apiUsage.hooksUsed.filter(h =>
    ['before_prompt_build', 'agent:bootstrap', 'before_model_resolve'].includes(h.event)
  );

  let totalTokens = 0;
  const dynamicPatterns = [];

  for (const hook of systemHooks) {
    const code = readHookCode(pluginPath, hook.location);
    const templates = extractTemplateLiterals(code);

    for (const tpl of templates) {
      const staticPart = tpl.replace(/\$\{[^}]+\}/g, '');
      const staticTokens = estimateTokenCount(staticPart);
      const dynamicVars = (tpl.match(/\$\{[^}]+\}/g) || []);

      totalTokens += staticTokens;

      // 检测缓存破坏模式
      for (const varExpr of dynamicVars) {
        const isCacheBreaking =
          /Date|Time|timestamp|random|uuid|messageId|msg_id/i.test(varExpr);
        if (isCacheBreaking) {
          dynamicPatterns.push({
            pattern: varExpr,
            location: hook.location,
            cacheBreaking: true,
          });
        }
      }
    }
  }

  return {
    systemPromptHooks: systemHooks.map(h => h.event),
    estimatedTokensInjected: totalTokens,
    dynamicContentPatterns: dynamicPatterns,
    staticTokenCount: totalTokens,
    dynamicTokenRatio: dynamicPatterns.length > 0 ? 0.3 : 0,  // 有动态内容估算30%
  };
}
```

### 2.3 Step 2：OpenClaw Agent 静态分析

#### 2.3.1 分析 Agent 设计

这是一个专用的 OpenClaw Agent，读取 `plugin-data.json`，输出结构化分析报告。

```
# SKILL.md（静态分析 Agent 的 Skill）
---
name: clawguard-static-analyzer
description: 分析 OpenClaw 插件的结构化数据，输出静态安全和质量报告
---

你是 OpenClaw 插件安全评审专家。
给你一份插件的结构化数据（plugin-data.json），请从以下维度分析：

1. **安全风险**
   - 基于 securitySignals 和 apiUsage 判断风险级别
   - 重点关注 lethalTrifecta，以及网络/文件权限的合理性
   - 硬编码凭证、eval 使用、Shell 注入风险

2. **设计原则合规性**
   - 能力注册是否符合 OpenClaw 设计原则
   - Hook 使用是否合理（是否用了 deprecated hooks）
   - 权限声明是否最小化

3. **Token 经济性**
   - 系统提示注入了多少 Token
   - 是否存在缓存破坏模式
   - 对用户成本的影响估算

4. **代码质量**
   - 测试覆盖率
   - 文档完整性
   - 依赖安全性

请以固定 JSON 格式输出，后跟 Markdown 详细报告。
```

#### 2.3.2 Agent 输出格式

```json
{
  "staticAnalysisResult": {
    "scores": {
      "SEC": { "score": 72, "level": "MEDIUM", "topIssues": ["lethal-trifecta-detected", "lodash-cve"] },
      "DESIGN": { "score": 85, "level": "GOOD", "topIssues": ["deprecated-hook-before_agent_start"] },
      "TOKEN_ECONOMY": { "score": 60, "level": "CONCERN", "topIssues": ["cache-breaking-timestamp-injection"] },
      "QUALITY": { "score": 78, "level": "GOOD", "topIssues": ["no-tests-found"] }
    },
    "vetoes": [],
    "recommendations": [
      "升级 lodash 到 4.17.21+",
      "将动态时间戳从 before_prompt_build 移至用户消息",
      "迁移 before_agent_start → before_model_resolve"
    ]
  }
}
```

---

## 第三章：插桩注入（细化到代码级）

### 3.1 插桩机制：基于 OpenClaw Hook 系统

**关键发现**：OpenClaw 社区的 knostic/openclaw-telemetry 项目已经验证：

> "Auto-instrumentation not possible: OpenLLMetry/IITM breaks named exports due to ESM/CJS module isolation. **All telemetry is captured via hooks, not direct SDK instrumentation**."

因此，ClawGuard 的插桩方案是：**注册一个专用的 `clawguard-probe` 插件，挂载在被测插件同一个 OpenClaw 实例上，通过 Hook 系统采集遥测数据。**

### 3.2 插桩架构

```
OpenClaw 实例（评测环境）
├── 被测插件（plugin-under-test）
│   ├── 正常执行
│   └── 触发各类 Hook 事件
│
└── clawguard-probe（插桩探针插件）
    ├── 监听所有 Hook 事件
    ├── 采集遥测数据
    └── 写入 eval-data.jsonl（本地文件）
```

### 3.3 可用 Hook 事件（来自官方文档）

| Hook 事件 | 触发时机 | 采集目标 |
|-----------|----------|----------|
| `message:received` | 收到用户消息 | 输入内容、时间戳 |
| `message:preprocessed` | 媒体/链接理解完成后 | 最终发送给 Agent 的内容 |
| `message:sent` | 消息发出 | 输出内容、是否成功 |
| `agent:bootstrap` | Bootstrap 文件注入前 | 注入文件列表、上下文大小 |
| `session:compact:before` | LCM 压缩前 | 当前 Token 数 |
| `session:compact:after` | LCM 压缩后 | 压缩效果、Token 节省 |
| `session:patch` | Session 属性变更 | 模型切换、配置变更 |
| `command:new` / `command:reset` | 会话命令 | 会话边界 |

**LLM 级遥测**（通过 `llm.usage` 事件，参考 knostic/openclaw-telemetry）：

| 事件 | 内容 |
|------|------|
| `llm.usage` | model、inputTokens、outputTokens、cacheReadTokens、costUsd、durationMs |
| `tool.start` | toolName、params、sessionKey |
| `tool.end` | toolName、success、durationMs、error |

### 3.4 clawguard-probe 插件实现

#### 3.4.1 目录结构

```
clawguard-probe/
├── openclaw.plugin.json    # 探针插件 manifest
├── src/
│   ├── index.ts            # 插件入口，注册 hooks
│   ├── hooks/
│   │   ├── message.ts      # 消息 Hook
│   │   ├── llm.ts          # LLM Hook
│   │   ├── tool.ts         # 工具 Hook
│   │   └── session.ts      # 会话 Hook
│   └── writer.ts           # JSONL 文件写入器
└── package.json
```

#### 3.4.2 探针插件核心代码

```typescript
// src/index.ts
import type { OpenClawPluginDefinition } from 'openclaw/plugin-sdk/plugin-entry';
import { createWriter } from './writer';
import { messageHooks } from './hooks/message';
import { llmHooks } from './hooks/llm';
import { toolHooks } from './hooks/tool';
import { sessionHooks } from './hooks/session';

const plugin: OpenClawPluginDefinition = {
  id: 'clawguard-probe',
  name: 'ClawGuard Evaluation Probe',
  register(api) {
    // 不注册任何能力，纯 hook-only 插件
    // 安全：只读，不修改任何 OpenClaw 行为

    const writer = createWriter({
      outputPath: process.env.CLAWGUARD_OUTPUT || './clawguard-eval-data.jsonl',
      runId: process.env.CLAWGUARD_RUN_ID || `run-${Date.now()}`,
      targetPlugin: process.env.CLAWGUARD_TARGET_PLUGIN || 'unknown',
    });

    // 注册所有 Hook
    api.hook('message:received', messageHooks.onReceived(writer));
    api.hook('message:preprocessed', messageHooks.onPreprocessed(writer));
    api.hook('message:sent', messageHooks.onSent(writer));
    api.hook('agent:bootstrap', sessionHooks.onBootstrap(writer));
    api.hook('session:compact:before', sessionHooks.onCompactBefore(writer));
    api.hook('session:compact:after', sessionHooks.onCompactAfter(writer));
    api.hook('llm:usage', llmHooks.onUsage(writer));     // 如果 OpenClaw 暴露
    api.hook('tool:end', toolHooks.onEnd(writer));
  },
};

export default plugin;
```

#### 3.4.3 JSONL 事件格式（本地文件）

每行一个 JSON 事件，追加写入：

```jsonl
{"type":"run.start","runId":"run-1712138400000","targetPlugin":"my-plugin@1.2.3","ts":1712138400000}
{"type":"session.bootstrap","runId":"...","bootstrapFiles":["SOUL.md","MEMORY.md"],"injectCount":2,"ts":1712138401000}
{"type":"message.in","runId":"...","caseId":"case-001","contentLength":45,"ts":1712138402000}
{"type":"llm.usage","runId":"...","caseId":"case-001","model":"claude-sonnet-4","inputTokens":1240,"outputTokens":380,"cacheReadTokens":900,"cacheHit":true,"costUsd":0.0042,"latencyMs":2100,"ts":1712138404100}
{"type":"tool.call","runId":"...","caseId":"case-001","toolName":"web_search","latencyMs":850,"success":true,"ts":1712138405000}
{"type":"message.out","runId":"...","caseId":"case-001","success":true,"totalLatencyMs":3200,"ts":1712138405200}
{"type":"run.end","runId":"...","totalCases":20,"successCount":18,"failCount":2,"totalCostUsd":0.124,"ts":1712138500000}
```

#### 3.4.4 插桩安装步骤（评测 SOP）

```bash
# 1. 安装探针插件（仅评测环境）
openclaw plugins install ./clawguard-probe

# 2. 配置评测参数
export CLAWGUARD_OUTPUT=./eval-data/my-plugin-eval.jsonl
export CLAWGUARD_RUN_ID=eval-$(date +%Y%m%d-%H%M%S)
export CLAWGUARD_TARGET_PLUGIN=my-plugin@1.2.3

# 3. 启动 OpenClaw（带探针）
openclaw gateway

# 4. 执行评测集（见第四章）
clawguard run-bench ./test-cases.json

# 5. 卸载探针（评测完成）
openclaw plugins uninstall clawguard-probe
```

---

## 第四章：评测集（AI 生成）

### 4.1 设计思路：为什么用 AI 生成评测集？

| 方式 | 优点 | 缺点 |
|------|------|------|
| **手写程序生成** | 可复现、确定性 | 覆盖不了语义场景、大量 hardcode |
| **人工编写** | 质量高 | 耗时、维护成本高、覆盖面窄 |
| **AI 生成** ✅ | 针对性强、覆盖面广、可迭代 | 需要验证、可能重复 |

核心逻辑：**AI 读取插件的 manifest + SKILL.md + 代码摘要 → 理解插件意图 → 生成针对这个插件功能的测试用例**

### 4.2 评测集生成器（AI 驱动）

#### 4.2.1 生成器 Agent 设计

```
输入：
- plugin-data.json（结构化插件数据）
- 插件核心代码摘要（关键函数、主要逻辑）
- 评测维度模板（标准维度）

输出：
- test-cases.json（可执行的评测用例集）
```

#### 4.2.2 生成 Prompt 设计

```typescript
const testGenPrompt = `
你是 OpenClaw 插件测试专家。请根据以下插件信息生成评测用例。

## 插件信息
名称: {{plugin.name}}
描述: {{plugin.description}}
能力: {{manifest.capabilities}}
Hook列表: {{manifest.hooks}}
主要功能（代码摘要）:
{{codeSummary}}

## 评测维度要求

### 维度1：基础功能（5个用例）
- 覆盖插件的核心使用场景
- 每个用例包含：输入、期望行为、验证方式
- 至少1个正常流程，1个边界条件

### 维度2：性能压力（3个用例）
- 高频连续调用（repeat: 10）
- 大输入场景
- 并发场景

### 维度3：上下文影响（3个用例）
- 验证插件注入的上下文是否合理
- 多轮对话中上下文的稳定性
- 与其他功能的干扰测试

### 维度4：异常处理（3个用例）
- 无效输入
- 网络超时（如插件依赖外部服务）
- 权限不足场景

### 维度5：可靠性（pass^k）（2个用例）
- 选取核心场景，重复执行 k=5 次
- 用于计算 pass^5 可靠性分数

## 输出格式

以 JSON 格式输出，严格遵守以下 schema：

\`\`\`json
{
  "meta": {
    "targetPlugin": "{{plugin.id}}",
    "generatedAt": "{{timestamp}}",
    "generatedBy": "clawguard-testgen-v1",
    "totalCases": 16
  },
  "cases": [
    {
      "id": "case-001",
      "dimension": "basic-functionality",
      "name": "用例名称（中文）",
      "description": "测试什么场景",
      "input": "发送给 OpenClaw 的具体消息内容",
      "repeat": 1,
      "timeout_ms": 10000,
      "assertions": {
        "should_succeed": true,
        "should_use_plugin": true,
        "max_latency_ms": 5000,
        "max_input_tokens": 3000,
        "response_contains": ["期望包含的关键词"],
        "response_not_contains": ["不应包含的内容"]
      },
      "notes": "评测要点说明"
    }
  ]
}
\`\`\`

请确保：
1. 用例具体可执行（input 是真实可发给 OpenClaw 的消息）
2. assertions 可被程序验证
3. 覆盖上述5个维度
4. pass^k 用例的 repeat >= 5
`;
```

#### 4.2.3 生成流程实现

```typescript
// src/testgen/generator.ts
export async function generateTestCases(pluginData: PluginStructuredData): Promise<TestSuite> {
  // 1. 提取代码摘要（关键函数签名 + 注释，控制在 2000 tokens 内）
  const codeSummary = await extractCodeSummary(pluginData);

  // 2. 调用 OpenClaw Agent 生成用例
  const session = await spawnTestGenAgent({
    model: 'claude-sonnet-4',  // 快速生成
    task: renderPrompt(testGenPrompt, { ...pluginData, codeSummary }),
  });

  // 3. 解析 JSON 输出
  const testSuite = parseTestSuiteFromResponse(session.result);

  // 4. 验证用例合法性（格式校验）
  validateTestSuite(testSuite);

  // 5. 写入文件
  writeFileSync('./test-cases.json', JSON.stringify(testSuite, null, 2));

  return testSuite;
}
```

#### 4.2.4 生成示例（某搜索插件的用例）

```json
{
  "meta": {
    "targetPlugin": "web-search-plus@2.1.0",
    "totalCases": 16
  },
  "cases": [
    {
      "id": "case-001",
      "dimension": "basic-functionality",
      "name": "基础搜索功能",
      "input": "帮我搜索最新的 OpenClaw 发布日志",
      "repeat": 1,
      "assertions": {
        "should_succeed": true,
        "should_use_plugin": true,
        "max_latency_ms": 8000,
        "max_input_tokens": 4000,
        "response_contains": ["版本", "更新", "发布"]
      }
    },
    {
      "id": "case-014",
      "dimension": "reliability-pass-k",
      "name": "核心功能可靠性（pass^5）",
      "input": "搜索今天的科技新闻头条",
      "repeat": 5,
      "assertions": {
        "should_succeed": true,
        "all_repeats_must_succeed": true,
        "latency_variance_max_percent": 30
      }
    }
  ]
}
```

---

## 第五章：数据收集与 LLM-Judge（本地文件优先）

### 5.1 数据流：从采集到报告

```
静态分析                          动态评测
plugin-data.json                eval-data.jsonl
static-report.md                    │
        │                           │
        └───────────┬───────────────┘
                    │ 合并
                    ▼
        ┌───────────────────────┐
        │  combined-input.md    │
        │                       │
        │ ## 静态分析结果        │
        │ [来自 static-report]  │
        │                       │
        │ ## 动态评测数据        │
        │ [来自 eval-data 汇总] │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │   LLM-Judge Agent     │
        │   (综合评分)           │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │   final-report.md     │
        │   + score.json        │
        └───────────────────────┘
```

### 5.2 本地文件输出规范

#### 5.2.1 目录结构

```
.clawguard/
├── runs/
│   └── {plugin-id}-{timestamp}/
│       ├── plugin-data.json      # MVP-1: 结构化数据
│       ├── static-report.md      # MVP-2: 静态分析报告
│       ├── test-cases.json       # MVP-3: AI生成评测集
│       ├── eval-data.jsonl       # MVP-3: 动态评测原始数据
│       ├── dynamic-report.md     # MVP-3: 动态分析报告
│       ├── combined-input.md     # MVP-4: 合并输入（给 LLM-Judge）
│       ├── final-report.md       # MVP-4: 最终报告（人工可读）
│       └── score.json            # MVP-4: 机器可读评分结果
└── latest -> runs/{最新运行}     # 软链接
```

#### 5.2.2 动态数据分析器（JSONL → 结构化报告）

```typescript
// src/analyzer/dynamic.ts
export function analyzeDynamicData(jsonlPath: string): DynamicReport {
  const events = readJsonl(jsonlPath);

  // ===== 延迟分析 =====
  const llmEvents = events.filter(e => e.type === 'llm.usage');
  const latencies = llmEvents.map(e => e.latencyMs).sort((a, b) => a - b);
  const latencyReport = {
    p50: percentile(latencies, 50),
    p95: percentile(latencies, 95),
    p99: percentile(latencies, 99),
    baseline: getBaselineLatency(),   // 无插件时的基线
    overhead: calculateOverhead(),    // 插件引入的额外延迟
  };

  // ===== Token 与成本 =====
  const tokenReport = {
    totalInputTokens: sum(llmEvents, 'inputTokens'),
    totalOutputTokens: sum(llmEvents, 'outputTokens'),
    totalCacheReadTokens: sum(llmEvents, 'cacheReadTokens'),
    totalCostUsd: sum(llmEvents, 'costUsd'),
    avgCostPerTask: avg(llmEvents, 'costUsd'),
    costPerInputKToken: calculateCostPerKToken(),
  };

  // ===== 缓存命中率影响 =====
  const cacheReport = {
    baselineHitRate: getBaselineCacheRate(),
    withPluginHitRate: llmEvents.filter(e => e.cacheHit).length / llmEvents.length,
    delta: withPluginHitRate - baselineHitRate,
    impactLevel: classifyImpact(delta),
    cacheBreakingCauses: getCacheBreakingCauses(events),  // 从静态分析中关联
  };

  // ===== 效果分析 =====
  const messageEvents = events.filter(e => e.type === 'message.out');
  const effectReport = {
    taskCompletionRate: messageEvents.filter(e => e.success).length / messageEvents.length,
    passAtK: calculatePassAtK(events, 5),   // pass^5
    errorRate: messageEvents.filter(e => !e.success).length / messageEvents.length,
    gracefulFailureRate: calculateGracefulFailures(events),
  };

  // ===== Bootstrap 影响 =====
  const bootstrapEvents = events.filter(e => e.type === 'session.bootstrap');
  const bootstrapReport = {
    avgInjectCount: avg(bootstrapEvents, 'injectCount'),
    filesInjected: [...new Set(bootstrapEvents.flatMap(e => e.bootstrapFiles))],
    estimatedTokenOverhead: estimateBootstrapTokens(bootstrapEvents),
  };

  return { latencyReport, tokenReport, cacheReport, effectReport, bootstrapReport };
}
```

### 5.3 LLM-Judge：合并静态+动态数据评分

#### 5.3.1 Judge 输入构建（combined-input.md）

```typescript
function buildCombinedInput(staticReport: string, dynamicReport: DynamicReport): string {
  return `
# ClawGuard 插件综合评估输入

## 一、静态分析结果
${staticReport}

## 二、动态评测数据汇总

### 2.1 延迟分析
- P50 延迟: ${dynamicReport.latencyReport.p50}ms
- P95 延迟: ${dynamicReport.latencyReport.p95}ms
- P99 延迟: ${dynamicReport.latencyReport.p99}ms
- 相比基线额外开销: ${dynamicReport.latencyReport.overhead}ms

### 2.2 Token 与成本
- 平均每次任务输入 Token: ${dynamicReport.tokenReport.avgInputPerTask}
- 总成本: $${dynamicReport.tokenReport.totalCostUsd.toFixed(4)}
- 每任务成本: $${dynamicReport.tokenReport.avgCostPerTask.toFixed(4)}

### 2.3 缓存命中率影响
- 基线命中率: ${(dynamicReport.cacheReport.baselineHitRate * 100).toFixed(1)}%
- 安装插件后命中率: ${(dynamicReport.cacheReport.withPluginHitRate * 100).toFixed(1)}%
- 变化: ${(dynamicReport.cacheReport.delta * 100).toFixed(1)}%
- 影响等级: ${dynamicReport.cacheReport.impactLevel}
- 缓存破坏原因: ${dynamicReport.cacheReport.cacheBreakingCauses.join(', ')}

### 2.4 效果评测
- 任务完成率: ${(dynamicReport.effectReport.taskCompletionRate * 100).toFixed(1)}%
- pass^5 可靠性: ${(dynamicReport.effectReport.passAtK * 100).toFixed(1)}%
- 错误率: ${(dynamicReport.effectReport.errorRate * 100).toFixed(1)}%
- 优雅失败率: ${(dynamicReport.effectReport.gracefulFailureRate * 100).toFixed(1)}%

### 2.5 上下文影响
- 平均 Bootstrap 注入文件数: ${dynamicReport.bootstrapReport.avgInjectCount}
- 注入的 Token 开销: ~${dynamicReport.bootstrapReport.estimatedTokenOverhead} tokens
`;
}
```

#### 5.3.2 LLM-Judge Prompt（综合评分）

```typescript
const judgePrompt = `
你是 OpenClaw 插件认证委员会的首席评审员。

根据以下综合评估数据，对插件进行最终评分。

{{combinedInput}}

## 评分任务

请对以下 6 个维度分别打分（0-100），并给出最终综合评分：

| 维度 | 权重 | 评分依据来源 |
|------|------|-------------|
| SEC（安全） | 25% | 静态分析安全信号 + 动态异常率 |
| PERF（性能） | 15% | 动态延迟数据 |
| COST（成本） | 15% | Token消耗 + 缓存命中率影响 |
| DESIGN（设计） | 15% | 静态分析设计原则合规性 |
| EFFECT（效果） | 20% | 任务完成率 + 输出质量 |
| STABLE（稳定） | 10% | pass^k + 错误率 |

## 硬性否决条件（任意触发 → 自动 Rejected）
- SEC 分数 < 40（存在 Critical 安全漏洞未修复）
- STABLE 分数 < 30（pass^5 < 30%，不可靠）
- 动态评测中出现 Gateway 崩溃或 OOM

## 认证等级
- 🥇 Gold：综合 ≥ 85
- 🥈 Silver：综合 75-84
- 🥉 Bronze：综合 65-74
- ❌ Rejected：< 65 或触发否决条件

请以以下 JSON 格式输出，然后给出 Markdown 详细评审报告：

\`\`\`json
{
  "scores": {
    "SEC": { "score": 0, "reasoning": "" },
    "PERF": { "score": 0, "reasoning": "" },
    "COST": { "score": 0, "reasoning": "" },
    "DESIGN": { "score": 0, "reasoning": "" },
    "EFFECT": { "score": 0, "reasoning": "" },
    "STABLE": { "score": 0, "reasoning": "" }
  },
  "weighted_total": 0,
  "certification": "gold|silver|bronze|rejected",
  "vetoes": [],
  "top_issues": [],
  "recommendations": []
}
\`\`\`
`;
```

---

## 第六章：完整流程串联（MVP-4 全流程）

### 6.1 一键运行命令

```bash
# 完整评估（四个 MVP 串行执行）
clawguard eval ./my-plugin --output ./.clawguard/runs/

# 等价于以下分步操作：
clawguard extract ./my-plugin              # MVP-1 → plugin-data.json
clawguard analyze plugin-data.json         # MVP-2 → static-report.md
clawguard gen-tests plugin-data.json       # MVP-3 → test-cases.json
clawguard bench ./my-plugin test-cases.json # MVP-3 → eval-data.jsonl + dynamic-report.md
clawguard score static-report.md dynamic-report.md  # MVP-4 → final-report.md + score.json
```

### 6.2 最终输出文件

```
.clawguard/runs/my-plugin-20260403-094000/
├── plugin-data.json          # 原始结构化数据
├── static-report.md          # 静态分析报告（人工可读）
├── test-cases.json           # AI生成的评测用例集
├── eval-data.jsonl           # 动态评测原始遥测数据
├── dynamic-report.md         # 动态分析报告
├── combined-input.md         # LLM-Judge 输入（调试用）
├── final-report.md           # 最终综合报告 ⭐
└── score.json                # 机器可读评分结果 ⭐
```

### 6.3 score.json 格式

```json
{
  "plugin": "my-plugin@1.2.3",
  "evaluatedAt": "2026-04-03T09:40:00Z",
  "clawguardVersion": "0.1.0",
  "scores": {
    "SEC": 78,
    "PERF": 72,
    "COST": 60,
    "DESIGN": 85,
    "EFFECT": 88,
    "STABLE": 76
  },
  "weightedTotal": 76.3,
  "certification": "silver",
  "vetoes": [],
  "passedMinimumThresholds": true,
  "topIssues": [
    "cache-breaking-timestamp-injection (COST -15pts)",
    "lethal-trifecta-present (SEC warning)"
  ],
  "recommendations": [
    "将动态时间戳从 before_prompt_build 移至用户消息",
    "升级 lodash@4.17.21+"
  ],
  "badge": "https://clawguard.dev/badge/silver",
  "reportPath": "./final-report.md"
}
```

---

## 附录：关键技术决策说明

### A. 为什么不用 OpenTelemetry SDK 做插桩？

社区实测发现：OpenClaw 的 ESM/CJS 模块隔离导致 OpenLLMetry 无法自动 patch named exports。**Hook 系统是唯一可靠的插桩路径**，且不需要修改 OpenClaw 源码。

### B. 为什么 AI 生成评测集比程序生成更好？

测试用例需要"理解插件语义"——搜索插件的测试用例和图片生成插件的完全不同。程序无法理解语义，只能生成通用模板。AI 读取插件 manifest + 代码摘要后，能生成针对该插件功能的具体用例。

### C. 为什么本地文件优先？

1. **零依赖**：不需要部署服务端，任何人 clone 即用
2. **可调试**：每一步的中间产物都可查看
3. **可集成**：JSONL + Markdown 可被任何工具消费
4. **渐进式**：本地验证后，后续可自然扩展为远程上报

---

> **文档版本**: v1.1.0
> **基于 v1.0 反馈**: MVP迭代、静态分析重设计、插桩细化、AI生成评测、本地优先
> **作者**: 黄山 (wairesearch)
