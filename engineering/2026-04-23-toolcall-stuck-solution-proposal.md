# Tool Call 无 Tool Result 导致 Session Stuck：解决方案提案（v2）

> **作者**：小帅（Team Commander）  
> **日期**：2026-04-23（v2 更新）  
> **状态**：Proposal  
> **优先级**：P0（影响所有用户的核心可靠性问题）  
> **基于**：OpenClaw 2026.4.12 源码（GitHub main `6b126cd`）+ 社区调研

---

## 1. 问题定义

### 1.1 现象

Session 在 LLM 发出 `tool_call` 后卡死，无法接收新消息，用户只能手动 `/kill` 或 `/reset`。

### 1.2 协议约束

LLM 对话协议的不可违反约束：**每个 tool_call 必须有且仅有一个对应的 tool_result。** 缺少 tool_result 时，对话状态非法，LLM 无法继续推理。

### 1.3 丢失 tool_result 的 5 种根因

| # | 根因 | 触发条件 |
|---|------|---------|
| R1 | 工具进程崩溃/被 OOM kill | 大文件处理、内存不足 |
| R2 | 工具执行永不返回 | 网络请求挂起、死循环、外部 API 无响应 |
| R3 | Gateway 在工具执行期间重启 | 手动重启、崩溃恢复 |
| R4 | Sandbox 超时但结果未回传 | 沙箱杀进程后 Gateway 未收到通知 |
| R5 | 工具调用格式错误导致 executor 静默失败 | LLM 生成非法参数 |

---

## 2. OpenClaw 已有防护机制（源码实证）

### 2.1 Transcript Repair — 合成缺失 Tool Result

**源码位置**：`src/agents/session-transcript-repair.ts`

OpenClaw 已经实现了 `repairToolUseResultPairing` 函数，在构建 LLM 上下文时自动修复缺失的 tool result：

```typescript
// src/agents/session-transcript-repair.ts (L178-L192)
function makeMissingToolResult(params: {
  toolCallId: string;
  toolName?: string;
}) {
  return {
    role: "toolResult",
    toolCallId: params.toolCallId,
    toolName: params.toolName ?? "unknown",
    content: [{
      type: "text",
      text: "[openclaw] missing tool result in session history; " +
            "inserted synthetic error result for transcript repair."
    }],
    isError: true,
    timestamp: Date.now(),
  };
}
```

`repairToolUseResultPairing` 完整能力：
- ✅ 缺失 tool result → 注入合成 error result
- ✅ 重复 tool result → 去重
- ✅ 孤立 tool result（无匹配 tool_call）→ 丢弃
- ✅ 位移的 tool result（不紧跟 assistant）→ 重排到正确位置
- ✅ 已 abort/error 的 assistant turn → 跳过合成，保留已有真实 result

### 2.2 Transcript Policy — 按 Provider 控制启用范围

**源码位置**：`src/agents/transcript-policy.ts`

```typescript
// 默认策略
const DEFAULT_TRANSCRIPT_POLICY = {
  repairToolUseResultPairing: true,    // 重排/移动 repair 默认开
  allowSyntheticToolResults: false,    // 但合成缺失 result 默认关
};

// 仅 Google 和 Anthropic 启用合成
...(isGoogle || isAnthropic ? { allowSyntheticToolResults: true } : {})

// Anthropic API 判定（包含 Bedrock）
function isAnthropicApi(modelApi?: string | null): boolean {
  return modelApi === "anthropic-messages" || modelApi === "bedrock-converse-stream";
}
```

**Provider 覆盖矩阵**：

| Provider | repair（重排） | 合成缺失 result | 原因 |
|----------|--------------|----------------|------|
| Google/Gemini | ✅ | ✅ | Gemini 严格要求 tool_call/result 配对 |
| Anthropic（含 Bedrock） | ✅ | ✅ | Anthropic 严格要求配对 |
| OpenAI | ❌ | ❌ | OpenAI 对 transcript 格式更宽松 |
| Mistral | ❌ (仅 id sanitize) | ❌ | — |
| 其他 | ✅ (默认) | ❌ | — |

**关键发现**：我们使用 `amazon-bedrock/global.anthropic.claude-opus-4-6-v1`，走 `bedrock-converse-stream` API，属于 Anthropic 分支，**已经启用了合成 tool result repair**。

### 2.3 Tool Loop Detection — 循环检测与熔断

**源码位置**：`src/agents/tool-loop-detection.ts`  
**文档**：`docs/tools/loop-detection.md`

已有内建的工具调用循环检测：

```json5
{
  tools: {
    loopDetection: {
      enabled: false,           // 默认关闭
      historySize: 30,
      warningThreshold: 10,
      criticalThreshold: 20,
      globalCircuitBreakerThreshold: 30,
      detectors: {
        genericRepeat: true,     // 重复相同 tool+params
        knownPollNoProgress: true, // 已知轮询无进展
        pingPong: true,          // 交替乒乓模式
      },
    },
  },
}
```

### 2.4 Agent Timeout 与 LLM Idle Timeout

**文档**：`docs/concepts/agent-loop.md`

```
Agent 总超时：agents.defaults.timeoutSeconds（默认 172800s = 48h）
LLM 空闲超时：agents.defaults.llm.idleTimeoutSeconds（未设时默认 120s）
```

### 2.5 Command Queue Lane 并发控制

**源码位置**：`src/process/command-queue.ts`

- 每个 session 一个 lane，保证同一 session 同时只有一个 agent run
- 全局 lane 控制总并发（main 默认 4，subagent 默认 8）
- 支持 `GatewayDrainingError`（重启时拒绝新任务）

---

## 3. 已有防护的盲区分析

### 3.1 Transcript Repair 的触发时机限制

Repair 只在**构建 LLM 上下文时**触发（即下一次 LLM 调用的 `sanitizeSessionHistory` 阶段），不是实时的。

| 场景 | Repair 是否有效 | 原因 |
|------|---------------|------|
| Gateway 重启后 | ✅ | session 重新加载 → 新消息触发 rebuild → repair |
| 工具崩溃后用户发新消息 | ✅ | 新消息触发新 turn → rebuild → repair |
| **工具执行永不返回（R2）** | ❌ | session 卡在等 tool result，不会触发 rebuild |
| **工具进程崩溃但 session 还在等（R1）** | ❌ | 同上，需要外部触发才能恢复 |

**结论**：Repair 解决的是"transcript 中已有的缺失"，不解决"正在等待中的缺失"。

### 3.2 Agent Timeout 太长

默认 48 小时 = 工具挂了要等 48 小时才超时。实际上任何工具调用超过几分钟都大概率是卡了。

### 3.3 无单个工具级别超时

Agent 有总超时，LLM 有 idle timeout，但**单个工具调用没有独立超时**。一个 `web_fetch` 挂了，要等 agent 总超时（48h）才会终止。

### 3.4 Loop Detection 默认关闭

工具循环检测已内建，但默认关闭，需要手动开启。

---

## 4. 解决方案

### 4.1 第一档：配置调优（立即可做，零代码改动）

#### 4.1.1 调低 Agent Timeout

```json5
{
  agents: {
    defaults: {
      timeoutSeconds: 1800,  // 48h → 30min
    },
  },
}
```

**效果**：session 最多卡 30 分钟（而非 48 小时）后自动终止。  
**风险**：极长的合法任务可能被误杀。可按 agent 单独覆盖。  
**ROI**：★★★★★（零成本，立即生效）

#### 4.1.2 显式设置 LLM Idle Timeout

```json5
{
  agents: {
    defaults: {
      llm: {
        idleTimeoutSeconds: 90,  // LLM 流式 90s 无 token → 断流
      },
    },
  },
}
```

**效果**：防止 LLM API 流式挂起（社区报告的最高频 stuck 模式）。  
**风险**：慢模型（如本地推理或 reasoning 模型）可能被误杀。已有逻辑：`resolveQaLiveTurnTimeoutMs` 会为 Claude Opus 等模型自动调高上限。  
**ROI**：★★★★★（零成本，解决最高频 stuck）

#### 4.1.3 开启 Tool Loop Detection

```json5
{
  tools: {
    loopDetection: {
      enabled: true,
      warningThreshold: 10,
      criticalThreshold: 20,
      globalCircuitBreakerThreshold: 30,
    },
  },
}
```

**效果**：防止工具调用死循环（如反复重试同一个失败的 tool）。  
**风险**：极低。合法的重复调用（如轮询进度）由 `knownPollNoProgress` 检测器智能区分。  
**ROI**：★★★★（零成本，防循环）

### 4.2 第二档：外围 Watchdog（1-2 天可做，不改核心代码）

用 cron 定期扫描 active session，检测并恢复 stuck：

```bash
#!/bin/bash
# session-watchdog.sh — 每 5 分钟运行
STUCK_THRESHOLD=1800  # 30 分钟无活动

openclaw session list --json 2>/dev/null | jq -r '
  .[] | select(.status == "running") |
  select((now - (.lastActivity / 1000)) > '"$STUCK_THRESHOLD"') |
  "\(.id) \(.sessionKey) \(.lastActivity)"
' | while read -r sid skey last; do
  echo "[WATCHDOG $(date)] Stuck: $skey (session $sid, last activity $(date -d @$((last/1000))))"
  # 可选：自动 kill
  # openclaw session kill "$sid"
  # 通知
  openclaw message send --channel telegram --target 8577482651 \
    --message "⚠️ Stuck session 检测: $skey，超过 ${STUCK_THRESHOLD}s 无活动"
done
```

**效果**：提供可见性 + 可选自动恢复。  
**风险**：低。可以先只告警不自动 kill，观察一段时间再开启自动恢复。  
**ROI**：★★★★（低成本，覆盖所有 stuck 场景的事后检测）

### 4.3 第三档：源码级改进（需提 PR）

#### 4.3.1 工具级超时（核心缺失项）

**现状**：Agent 有总超时，LLM 有 idle timeout，但单个工具调用无独立超时。

**方案**：在工具执行入口包一层 `Promise.race`：

```typescript
// 概念代码 — 基于 src/agents 的工具执行路径
async function executeToolWithTimeout(
  toolName: string,
  params: Record<string, unknown>,
  options: { timeoutMs: number }
): Promise<ToolResult> {
  const { timeoutMs } = options;
  
  return Promise.race([
    actualToolExecution(toolName, params),
    new Promise<never>((_, reject) =>
      setTimeout(() => reject(new ToolTimeoutError(toolName, timeoutMs)), timeoutMs)
    ),
  ]).catch((error) => {
    if (error instanceof ToolTimeoutError) {
      return makeMissingToolResult({
        toolCallId: currentCallId,
        toolName,
        // 复用已有的 makeMissingToolResult，只改文案
      });
    }
    throw error;
  });
}
```

**改动影响面**：
- 改动点：工具执行调度入口（`runEmbeddedPiAgent` 中的 tool dispatch）
- 复用：直接复用已有的 `makeMissingToolResult` 函数
- 新增配置：`agents.defaults.tools.timeoutSeconds`（默认 300s）
- 可选按工具配置：`tools.timeouts.exec: 600, tools.timeouts.web_fetch: 120`

**ROI**：★★★★★（改动小，解决根本问题 R1/R2/R4）

#### 4.3.2 扩大合成 Tool Result 的 Provider 覆盖

**现状**：只有 Google 和 Anthropic 启用了 `allowSyntheticToolResults: true`。

**建议**：将默认策略改为 `allowSyntheticToolResults: true`，或至少覆盖 OpenAI。

```typescript
// src/agents/transcript-policy.ts
const DEFAULT_TRANSCRIPT_POLICY = {
  repairToolUseResultPairing: true,
  allowSyntheticToolResults: true,  // 改为默认开启
};
```

**风险评估**：低。合成的 result 带 `isError: true` 标记，LLM 会正确理解为错误状态。OpenAI 对 transcript 格式较宽松，不太可能因为多一个 error tool_result 而拒绝请求。

**ROI**：★★★（改一行代码，补齐 OpenAI 等 provider 的覆盖）

---

## 5. 社区方案参考

### 5.1 行业普遍现状

Tool call stuck 是 AI Agent 领域的普遍问题，没有框架完美解决。

### 5.2 各框架方案对比

| 框架 | 核心方案 | OpenClaw 是否已有 |
|------|---------|-----------------|
| **OpenAI Assistants** | Run 10min 硬超时 → `expired` | ✅ 有 agent timeout（但默认 48h） |
| **LangChain/LangGraph** | `handle_tool_error` + `RetryPolicy` + 条件边降级 | 部分（有 loop detection，无 per-tool retry） |
| **AutoGen** | `CancellationToken` + 可配超时 | 部分（有 AbortSignal，无 per-tool timeout） |
| **Anthropic Claude API** | `is_error` 协议字段 | ✅ 有 `isError: true` |
| **Dify** | 四种策略（error/retry/fail-branch/default-value） | 部分（有 error，无 default-value） |
| **MemGPT/Letta** | 持久化 + 心跳检测 | 部分（有持久化，无心跳） |

### 5.3 值得借鉴的思路

| 思路 | 来源 | 适合 OpenClaw 的落地方式 |
|------|------|----------------------|
| Per-tool 声明式超时 | LangGraph RetryPolicy | 配置 `tools.timeouts.<toolName>` |
| Default Value 模式 | Dify | 非关键工具超时返回默认值而非 error |
| Circuit Breaker | 分布式系统经典 | 已有 `globalCircuitBreakerThreshold`，建议开启 |
| 心跳进度报告 | MemGPT | 长期考虑，短期不需要 |
| CancellationToken | AutoGen/Semantic Kernel | 已有 AbortSignal 基础 |

---

## 6. 行动计划

### 立即执行（今天）

| # | 动作 | 方式 | 预期效果 |
|---|------|------|---------|
| 1 | Agent timeout 48h → 1800s | 改配置 | stuck 最长 30 分钟 |
| 2 | 显式设 LLM idle timeout 90s | 改配置 | 防 LLM 流挂起 |
| 3 | 开启 Tool Loop Detection | 改配置 | 防工具死循环 |

### 本周

| # | 动作 | 方式 | 预期效果 |
|---|------|------|---------|
| 4 | 部署 Watchdog 脚本 | cron | stuck 自动检测 + 告警 |
| 5 | 手动恢复 SOP | 文档 | 标准化排查流程 |

### 手动恢复 SOP（Stuck Session 排查与恢复标准操作流程）

#### Step 1：确认 stuck

```bash
# 查看所有 session 状态
openclaw session list --json | jq '.[] | select(.status == "running") | {id, sessionKey, lastActivity, updatedAt}'

# 看哪个 session 长时间无活动
# lastActivity 距当前时间 > 10 分钟且 status=running → 疑似 stuck
```

#### Step 2：查看日志确认卡在哪

```bash
# 实时日志
openclaw logs --follow

# 搜索 tool 相关错误
openclaw logs | grep -i "tool\|timeout\|error\|stuck\|abort" | tail -30
```

**常见卡点判断**：
- 日志有 `tool start` 无 `tool end` → 工具执行挂起
- 日志有 `stream start` 无 token 输出 → LLM 流挂起
- 日志无任何输出 → session lane 被占，可能死锁

#### Step 3：恢复操作

```bash
# 方式 1：kill 指定 session（推荐，精准）
openclaw session kill <session-id>

# 方式 2：用户侧发 /kill 命令（如果消息通道还能用）
/kill

# 方式 3：重置 session（丢失当前会话历史）
/reset

# 方式 4：重启 Gateway（最后手段，影响所有 session）
openclaw gateway restart
```

#### Step 4：检查残留

```bash
# 检查 .lock 文件残留
find ~/.openclaw -name "*.lock" -mmin +30 -ls

# 如有过期 lock，手动清理
find ~/.openclaw -name "*.lock" -mmin +30 -delete

# 确认 session 已恢复
openclaw session list
```

#### Step 5：记录事故

记录到运维日志：
- 时间
- 卡死的 session（id + agent）
- 卡死原因（工具挂起 / LLM 挂起 / 其他）
- 恢复方式
- 是否需要后续改进

#### 速查决策树

```
session 无响应
  │
  ├─ 能发消息？ → 发 /kill
  │
  ├─ 不能发消息？
  │   ├─ 知道 session id → openclaw session kill <id>
  │   └─ 不知道 → openclaw session list 找到后 kill
  │
  ├─ kill 无效？
  │   ├─ 检查 .lock 残留 → 清理
  │   └─ 仍无效 → openclaw gateway restart
  │
  └─ 频繁发生？
      ├─ 检查 agent timeout 配置
      ├─ 开启 loop detection
      └─ 部署 watchdog 脚本
```

### 提 PR（推动源码改进）

| # | 动作 | 改动量 | 优先级 |
|---|------|--------|--------|
| 6 | 工具级超时（`Promise.race` 包装） | ~50 行 | P0 |
| 7 | `allowSyntheticToolResults` 默认开启 | 1 行 | P1 |
| 8 | Per-tool 超时配置 | ~100 行 | P2 |

---

## 7. 附录：关键源码文件索引

| 文件 | 功能 |
|------|------|
| `src/agents/session-transcript-repair.ts` | Transcript repair：合成缺失 tool result、去重、重排 |
| `src/agents/transcript-policy.ts` | Provider 策略：控制哪些 provider 启用哪些 repair |
| `src/agents/tool-loop-detection.ts` | 工具循环检测：重复模式检测 + 熔断 |
| `src/process/command-queue.ts` | 命令队列：session lane 并发控制 |
| `docs/concepts/agent-loop.md` | Agent Loop 生命周期文档 |
| `docs/reference/transcript-hygiene.md` | Transcript 修复策略文档 |
| `docs/tools/loop-detection.md` | 工具循环检测配置文档 |

---

## 8. 参考来源

| # | 来源 | 说明 |
|---|------|------|
| 1 | OpenClaw GitHub main (`6b126cd`) | 源码分析 |
| 2 | OpenClaw 2026.4.12 dist + 文档 | 本机安装版本对照 |
| 3 | `docs/concepts/agent-loop.md` | Agent Loop 超时机制 |
| 4 | `docs/reference/transcript-hygiene.md` | Provider 修复策略 |
| 5 | `docs/tools/loop-detection.md` | 循环检测配置 |
| 6 | OpenAI Forum: Assistant runs 10min limit | 社区反馈 |
| 7 | LangChain/LangGraph: RetryPolicy | 声明式重试 |
| 8 | AutoGen GitHub Issues #5272, #6202 | 工具超时问题 |
| 9 | Anthropic Messages API: `is_error` | 协议设计 |
| 10 | Dify Blog: Error Handling v0.14.0 | 四种策略 |

---

*v2 更新说明：基于 OpenClaw GitHub 最新源码（`6b126cd`）重写，修正了 v1 中"OpenClaw 没有防护"的错误判断，明确了已有机制和真正的盲区，方案聚焦在配置调优 + 补齐工具级超时。*
