# OpenClaw 任务执行机制深度解析

> 从消息到达到回复交付的完整链路：状态流转、生命周期、队列调度、通知机制

---

## 1. 全景架构：一条消息的完整旅程

```
用户发送消息（Telegram/WhatsApp/Discord/飞书/...）
    │
    ▼
╔══════════════════════════════════════════════════════╗
║              Gateway 接收层                           ║
║  ┌───────────────────────────────────────────────┐   ║
║  │ Channel Plugin (Telegram/WhatsApp/Feishu/...) │   ║
║  │  • 消息解析（文本/媒体/贴纸/定位）             │   ║
║  │  • 消息去重（短期缓存，防重连重发）            │   ║
║  │  • 消息分片合并（Telegram 长消息/媒体组）       │   ║
║  │  • 频率抑制（同一发送者快速连发合并）           │   ║
║  └───────────────┬───────────────────────────────┘   ║
╚══════════════════│═══════════════════════════════════╝
                   │
                   ▼
╔══════════════════════════════════════════════════════╗
║              路由 & 鉴权层                            ║
║  ┌───────────────────────────────────────────────┐   ║
║  │  1. DM 策略检查（pairing/allowlist/open）      │   ║
║  │  2. 群组激活检查（@提及/关键词/配置）          │   ║
║  │  3. Agent 路由（bindings 匹配）                │   ║
║  │  4. Session Key 解析                           │   ║
║  │  5. 命令检测（/reset /new /model 等）          │   ║
║  │  6. 命令权限验证                               │   ║
║  └───────────────┬───────────────────────────────┘   ║
╚══════════════════│═══════════════════════════════════╝
                   │
                   ├── 是 Slash 命令？──▶ 命令处理器（不走 Agent Loop）
                   │
                   ▼
╔══════════════════════════════════════════════════════╗
║              消息队列层 (Command Queue)               ║
║  ┌───────────────────────────────────────────────┐   ║
║  │  入站消息防抖 (debounce)                       │   ║
║  │  ├─ 同一发送者连续消息合并（默认 2s 窗口）     │   ║
║  │  └─ 媒体/附件立即投递，命令绕过防抖            │   ║
║  │                                                │   ║
║  │  队列模式判定:                                  │   ║
║  │  ├─ collect (默认): 合并为单次 followup turn    │   ║
║  │  ├─ steer: 注入当前运行（下一个工具边界后）    │   ║
║  │  ├─ followup: 排队等当前 turn 结束             │   ║
║  │  ├─ steer-backlog: steer + 保留 followup       │   ║
║  │  └─ interrupt (legacy): 中断当前，跑最新消息   │   ║
║  │                                                │   ║
║  │  溢出策略 (cap=20 默认):                        │   ║
║  │  ├─ old: 丢弃最旧                              │   ║
║  │  ├─ new: 丢弃最新                              │   ║
║  │  └─ summarize: 摘要已丢弃消息                  │   ║
║  └───────────────┬───────────────────────────────┘   ║
╚══════════════════│═══════════════════════════════════╝
                   │
                   ▼
╔══════════════════════════════════════════════════════╗
║              并发控制层 (Lane System)                 ║
║  ┌───────────────────────────────────────────────┐   ║
║  │  Session Lane: session:<key>                   │   ║
║  │  ├─ 每个 session 串行（同一时间只有一个 run）  │   ║
║  │  └─ 防止 session 文件/日志竞争                 │   ║
║  │                                                │   ║
║  │  Global Lane:                                  │   ║
║  │  ├─ main (默认并发=4，入站+心跳)              │   ║
║  │  ├─ cron (隔离，不阻塞入站)                   │   ║
║  │  └─ subagent (默认并发=8，不阻塞入站)         │   ║
║  │                                                │   ║
║  │  配置: agents.defaults.maxConcurrent           │   ║
║  └───────────────┬───────────────────────────────┘   ║
╚══════════════════│═══════════════════════════════════╝
                   │
                   ▼
╔══════════════════════════════════════════════════════╗
║              Agent Run 执行层                        ║
║  （下一节详细展开）                                   ║
╚══════════════════════════════════════════════════════╝
```

---

## 2. Agent Run 生命周期（核心）

### 2.1 Run 状态机

```
                    ┌──────────┐
                    │  QUEUED  │ ← dispatchInboundMessage 入队
                    └────┬─────┘
                         │ lane 获得执行权
                         ▼
                    ┌──────────┐
                    │ STARTING │ ← agentCommand() 开始
                    │          │   解析模型/session/workspace
                    └────┬─────┘
                         │
                         ▼
    ┌────────────────────────────────────────────┐
    │              RUNNING (Agent Loop)           │
    │                                             │
    │  ┌─────────────────────────────────────┐   │
    │  │     Context Assembly (上下文组装)     │   │
    │  │  1. 加载 session transcript          │   │
    │  │  2. 组装 system prompt               │   │
    │  │     ├─ 基础 prompt                   │   │
    │  │     ├─ Skills prompt                 │   │
    │  │     ├─ Bootstrap context (workspace)  │   │
    │  │     ├─ Plugin hooks 注入             │   │
    │  │     │   (before_prompt_build)        │   │
    │  │     └─ System events 注入            │   │
    │  │  3. Token 预算计算 + 修剪            │   │
    │  └──────────────┬──────────────────────┘   │
    │                 ▼                           │
    │  ┌─────────────────────────────────────┐   │
    │  │     Model Inference (LLM 推理)       │   │
    │  │  • 流式输出 (streaming deltas)       │   │
    │  │  • 工具调用请求                       │   │
    │  │  • 推理内容 (reasoning/thinking)      │   │
    │  └──────────────┬──────────────────────┘   │
    │                 │                           │
    │        ┌────────┴────────┐                 │
    │        │                  │                 │
    │        ▼                  ▼                 │
    │   纯文本回复          工具调用              │
    │        │           ┌──────┴──────┐         │
    │        │           ▼              │         │
    │        │    ┌─────────────┐      │         │
    │        │    │ Tool Execute │      │         │
    │        │    │  read/write/ │      │         │
    │        │    │  exec/edit/  │      │         │
    │        │    │  web_search/ │      │         │
    │        │    │  message/... │      │         │
    │        │    └──────┬──────┘      │         │
    │        │           │              │         │
    │        │           ▼              │         │
    │        │    工具结果返回给 LLM     │         │
    │        │           │              │         │
    │        │           ▼              │         │
    │        │    更多工具调用？         │         │
    │        │      是 ──────────────────┘         │
    │        │      否                             │
    │        │           │                         │
    │        ◄───────────┘                         │
    │                 │                            │
    └────────────────┬────────────────────────────┘
                     │
           ┌─────────┴──────────┐
           │                     │
           ▼                     ▼
    ┌──────────┐          ┌──────────┐
    │ COMPLETED │          │  ERROR   │
    │ (正常结束) │          │ (异常)   │
    └────┬─────┘          └────┬─────┘
         │                     │
         ▼                     ▼
    ┌──────────────────────────────┐
    │     Post-Run Processing      │
    │  1. 持久化 transcript        │
    │  2. 更新 session store       │
    │  3. Plugin: agent_end hook   │
    │  4. 检查 auto-compaction     │
    │  5. 检查 memory flush        │
    │  6. 处理 followup 队列       │
    │  7. 发送 announce (如子agent) │
    └──────────────────────────────┘
```

### 2.2 RPC 入口与 Wait 机制

```
caller                     Gateway                    Agent Runtime
  │                           │                            │
  │─── agent(params) ────────▶│                            │
  │                           │── validate + resolve ──────│
  │                           │── persist session meta ────│
  │◀── { runId, acceptedAt }──│                            │
  │                           │── agentCommand() ─────────▶│
  │                           │                            │── runEmbeddedPiAgent()
  │                           │                            │     │
  │─── agent.wait(runId) ────▶│                            │     │
  │                           │── waitForAgentJob(runId) ──│     │
  │                           │    (等待 lifecycle end)     │     │
  │                           │                            │     │── stream: lifecycle/start
  │                           │                            │     │── stream: assistant (deltas)
  │                           │                            │     │── stream: tool (events)
  │                           │                            │     │── stream: assistant (deltas)
  │                           │                            │     │── stream: lifecycle/end
  │                           │                            │     │
  │◀── { status, reply } ────│◀────────────────────────────│
  │                           │                            │
```

**关键语义**：
- `agent` RPC 立即返回 `{ runId, acceptedAt }`，不阻塞
- `agent.wait` 服务端等待，重连不丢失
- `agent.wait` 超时（默认 30s）只是停止等待，**不停止 run**
- Agent runtime 超时（默认 48h）才会真正 abort run

---

## 3. 事件流与通知机制

### 3.1 三条事件流

Agent Run 过程中发射三种事件流：

```
┌──────────────────────────────────────────────────────┐
│                    Event Streams                      │
│                                                       │
│  ┌─────────────────┐                                 │
│  │  lifecycle       │ 生命周期事件                     │
│  │  ├─ phase:start  │ run 开始                        │
│  │  ├─ phase:update │ 中间状态更新                     │
│  │  ├─ phase:end    │ run 正常结束                     │
│  │  └─ phase:error  │ run 异常结束                     │
│  └─────────────────┘                                 │
│                                                       │
│  ┌─────────────────┐                                 │
│  │  assistant       │ 模型输出流                       │
│  │  ├─ text delta   │ 文本增量（流式）                │
│  │  ├─ text_end     │ 文本块结束                      │
│  │  ├─ block_final  │ 最终块                          │
│  │  └─ reasoning    │ 推理内容（如启用）              │
│  └─────────────────┘                                 │
│                                                       │
│  ┌─────────────────┐                                 │
│  │  tool            │ 工具调用事件                     │
│  │  ├─ tool_start   │ 工具开始（工具名+参数）         │
│  │  ├─ tool_update  │ 中间输出                        │
│  │  └─ tool_end     │ 工具完成（结果摘要）            │
│  └─────────────────┘                                 │
└──────────────────────────────────────────────────────┘
```

### 3.2 通知投递链

```
Agent Run 产生事件
    │
    ▼
subscribeEmbeddedPiSession
    │  桥接 pi-agent-core 事件到 OpenClaw 事件
    │
    ├──▶ emitAgentEvent() ──▶ Gateway WebSocket 客户端
    │                          ├─ Control UI (实时更新)
    │                          ├─ TUI (终端界面)
    │                          └─ macOS App
    │
    ├──▶ Channel Delivery Pipeline
    │    ├─ Block Streaming (分块流式发送)
    │    │   ├─ 按 text_end 或 message_end 切分
    │    │   ├─ 分块大小: 800-1200 chars (可配)
    │    │   ├─ 优先在段落/换行处切分
    │    │   └─ Coalesce: 空闲期合并小块
    │    │
    │    ├─ Channel-specific Chunking
    │    │   ├─ Telegram: 4096 chars/消息
    │    │   ├─ WhatsApp: ~64KB/消息
    │    │   ├─ Discord: 2000 chars/消息
    │    │   ├─ Slack: 40000 chars/消息
    │    │   └─ 飞书: 卡片模式/文本模式
    │    │
    │    ├─ Reply Threading (回复串联)
    │    │   ├─ replyToMode: auto/always/never
    │    │   └─ 渠道特定线程 ID 解析
    │    │
    │    └─ Outbound Delivery
    │        ├─ 发送到用户会话
    │        ├─ 发送到群组
    │        └─ 发送到指定渠道 (message tool)
    │
    └──▶ System Events Queue
         ├─ 入队到 session 的系统事件
         └─ 下次 run 时通过 drainFormattedSystemEvents 注入
```

### 3.3 System Events（运行时系统事件）

System Events 是 OpenClaw 在 Agent 运行间传递状态变化的机制：

```typescript
// 事件队列（按 sessionKey 隔离）
const queues = new Map<string, {
  queue: Array<{ text: string; ts: number; contextKey?: string }>;
  lastText: string | null;  // 去重用
}>();

// 每个 session 最多 20 条
const MAX_EVENTS = 20;
```

**事件类型**：

| 事件 | 触发条件 | 示例 |
|------|---------|------|
| Exec completed | 命令执行完成 | `Exec completed (abc12345, code 0) :: output` |
| Model switched | /model 切换 | `Switched to gpt-4o` |
| Fast mode | /fast 切换 | `Fast mode enabled.` |
| Elevated | 权限提升 | `Elevated to operator.` |
| Reasoning | 推理模式切换 | `Reasoning enabled.` |
| Subagent started | 子 Agent 启动 | `Started isolated session main:qa. Streaming...` |
| Channel event | 渠道事件 | `Slack channel created: #general.` |

**注入流程**：
```
事件发生 → enqueueSystemEvent(text, { sessionKey })
    │  自动去重（连续相同文本不重复入队）
    │
    ▼
下次 Agent Run 前 → drainFormattedSystemEvents(sessionKey)
    │  一次性取出所有事件
    │  格式化为 "System: [时间] 事件文本"
    │  注入到 System Prompt 末尾
    │
    ▼
Agent 看到事件并做出响应
```

---

## 4. Plugin Hook 生命周期

### 4.1 完整 Hook 链（按执行顺序）

```
消息到达
    │
    ▼
[gateway_start]                    ← Gateway 启动时（一次性）
    │
    ▼
[message_received]                 ← 消息接收（所有消息）
    │
    ▼
[session_start]                    ← Session 首次使用
    │
    ▼
[before_model_resolve]             ← 模型解析前（可覆盖 provider/model）
    │                                 ⚠️ 无 messages，仅用于确定性模型选择
    ▼
[before_prompt_build]              ← Prompt 构建前（可注入上下文）
    │  返回值:
    │  ├─ prependContext      → 每轮动态文本（注入到消息前）
    │  ├─ systemPrompt        → 替换 system prompt
    │  ├─ prependSystemContext → 追加到 system prompt 前部
    │  └─ appendSystemContext  → 追加到 system prompt 后部
    │
    ▼
[before_agent_start]               ← Agent 开始前（兼容 hook）
    │  同上返回值
    │
    ▼
─── Agent Loop 开始 ───
    │
    ├─ LLM 推理
    │
    ├─ [before_tool_call]          ← 工具调用前
    │    返回 { block: true } → 阻止工具执行
    │
    ├─ Tool 执行
    │
    ├─ [after_tool_call]           ← 工具调用后
    │
    ├─ [tool_result_persist]       ← 工具结果持久化前
    │    同步转换 tool result（写入 transcript 前最后机会）
    │
    ├─ （循环直到无更多工具调用）
    │
─── Agent Loop 结束 ───
    │
    ▼
[before_compaction]                ← 压缩前（如果触发）
    │
    ▼
[after_compaction]                 ← 压缩后
    │
    ▼
[agent_end]                        ← Agent 完成
    │  参数: { success, messages, usage }
    │
    ▼
[message_sending]                  ← 消息发送前
    │  返回 { cancel: true } → 取消发送
    │
    ▼
[message_sent]                     ← 消息已发送
    │
    ▼
[session_end]                      ← Session 结束（idle/reset）
    │
    ▼
[gateway_stop]                     ← Gateway 停止时（一次性）
```

### 4.2 Hook 优先级与终止规则

```
同一事件的多个 Hook 按注册顺序执行：

Hook A ──▶ Hook B ──▶ Hook C
   │          │          │
   │   before_tool_call:
   │   { block: true } ────▶ 终止！后续 Hook 不执行
   │
   │   message_sending:
   │   { cancel: true } ────▶ 终止！消息不发送
   │
   │   注意:
   │   { block: false } ──── 无操作（不清除先前的 block）
   │   { cancel: false } ─── 无操作（不清除先前的 cancel）
```

---

## 5. Session 状态管理

### 5.1 Session 生命周期

```
                   ┌───────────────┐
                   │  NOT EXISTS   │
                   └───────┬───────┘
                           │ 首次消息到达
                           │ (initSessionState)
                           ▼
                   ┌───────────────┐
           ┌──────│    ACTIVE      │◀─────────────────┐
           │      │  (正常对话)     │                   │
           │      └───────┬───────┘                   │
           │              │                            │
           │   ┌──────────┴──────────────┐            │
           │   │                          │            │
           │   ▼                          ▼            │
    ┌──────────────┐              ┌──────────────┐    │
    │ COMPACTING   │              │   FLUSHING   │    │
    │ (上下文压缩)  │              │ (记忆刷写)   │    │
    │              │              │ (NO_REPLY)   │    │
    └──────┬───────┘              └──────┬───────┘    │
           │                             │            │
           └─────────────┬──────────────┘            │
                         │                            │
                         ▼                            │
              ┌─────────────────────┐                │
              │  是否需要 followup?  │                │
              │  队列中有消息？      │                │
              └────┬────────┬───────┘                │
                   │        │                         │
                   ▼ 是     ▼ 否                      │
              下一个 run ──────────────────────────────┘
                                  │
                                  ▼
                         Session 空闲
                                  │
                   ┌──────────────┴──────────────┐
                   │                              │
                   ▼                              ▼
           ┌──────────────┐              ┌──────────────┐
           │ DAILY RESET  │              │ IDLE RESET   │
           │ (默认 4:00AM) │              │ (配置的空闲) │
           └──────┬───────┘              └──────┬───────┘
                  │                             │
                  └─────────────┬───────────────┘
                                │
                                ▼
                   ┌───────────────────┐
                   │  新 sessionId      │
                   │  旧 transcript     │
                   │  归档/保留         │
                   └───────────────────┘
```

### 5.2 Session Reset 触发条件

| 触发方式 | 时机 | 行为 |
|---------|------|------|
| **手动 /new** | 用户命令 | 新 sessionId，可选保存记忆 |
| **手动 /reset** | 用户命令 | 新 sessionId，清除上下文 |
| **Daily Reset** | 默认 4:00 AM 本地时间 | 下一条消息触发新 sessionId |
| **Idle Reset** | `session.reset.idleMinutes` 超时 | 下一条消息触发新 sessionId |
| **Daily + Idle** | 两者都配置时 | 先到先触发 |
| **Thread Fork Guard** | 父 session > 100K tokens | 新线程从空白开始 |

### 5.3 Session Store 字段

```typescript
interface SessionEntry {
  // 标识
  sessionId: string;          // 当前 transcript 文件名
  sessionFile?: string;       // 可选的 transcript 路径覆盖
  chatType: "direct" | "group" | "room";

  // 时间戳
  updatedAt: number;          // 最后活动时间
  memoryFlushAt?: number;     // 最后记忆刷写时间

  // 模型/推理
  providerOverride?: string;
  modelOverride?: string;
  authProfileOverride?: string;

  // 开关
  thinkingLevel?: string;
  verboseLevel?: string;
  reasoningLevel?: string;
  elevatedLevel?: string;
  sendPolicy?: "allow" | "deny";

  // Token 计数（尽力而为）
  inputTokens: number;
  outputTokens: number;
  totalTokens: number;
  contextTokens: number;

  // 压缩
  compactionCount: number;
  memoryFlushCompactionCount?: number;

  // 路由
  lastChannel?: string;
  lastTo?: string;
  displayName?: string;
}
```

---

## 6. 七种任务触发方式

### 6.1 对比矩阵

| 触发方式 | 入口 | Session | 模型 | 隔离 | 通知 |
|---------|------|---------|------|------|------|
| **用户消息** | Channel Plugin | 主 session | 默认 | 否 | 回复到原会话 |
| **Heartbeat** | Gateway 定时器 | 主 session | 可覆盖 | 否 | 按 target 配置 |
| **Cron Job** | Gateway 定时器 | `cron:<jobId>` 隔离 | 可覆盖 | 是 | announce/webhook/none |
| **Webhook** | HTTP POST | `hook:<uuid>` | 可覆盖 | 是 | 按配置 |
| **Sub-agent** | sessions_spawn | `agent:<id>:subagent:<uuid>` | 可覆盖 | 是 | announce 到请求者 |
| **ACP Session** | sessions_spawn(acp) | `acp:<uuid>` | 外部 | 是 | thread/announce |
| **CLI Agent** | `openclaw agent` | CLI session | 可指定 | 否 | stdout |

### 6.2 各触发方式的执行流

#### 用户消息（标准流）
```
Channel Plugin → processInboundMessage()
    → inboundDebouncer.enqueue()          // 防抖
    → dispatchInboundMessage()            // 路由
    → resolveAgentRoute()                 // Agent 绑定
    → commandQueue.enqueue()              // 入队
    → agentCommand()                      // 执行
    → runEmbeddedPiAgent()                // Agent Loop
    → deliverOutboundPayloads()           // 投递回复
```

#### Heartbeat（心跳）
```
定时器到期（默认 30min）
    → 检查主 session 是否忙碌（忙则跳过）
    → 注入 HEARTBEAT.md 读取指令
    → 在主 session 中执行 Agent Turn
    → 响应规则:
       ├─ HEARTBEAT_OK → 静默（不通知）
       └─ 其他内容 → 按 target 投递
           ├─ last → 最近活跃渠道
           ├─ none → 不投递
           └─ channel → 指定渠道
```

#### Cron Job（定时任务）
```
Gateway 定时器 tick
    → 收集到期的 jobs
    → 标记 running
    → 并发执行（≤ maxConcurrentRuns）
    │
    ├─ main 模式:
    │  └─ enqueueSystemEvent() → 下次主 session turn 处理
    │
    └─ isolated 模式:
       └─ runCronIsolatedAgentTurn()
           ├─ 创建 session: cron:<jobId>:run:<uuid>
           ├─ 模型链: job.model > subagent.model > agent.model > global
           ├─ 思考级别: job.thinking > global
           ├─ 执行 Agent Turn
           └─ 投递:
               ├─ announce → 指定渠道 + 主 session 摘要
               ├─ webhook → HTTP POST
               └─ none → 仅记录
```

#### Sub-agent（子 Agent）
```
父 Agent 调用 sessions_spawn({ task, runtime: "subagent" })
    │
    ▼
创建隔离 session: agent:<agentId>:subagent:<uuid>
    │
    ├─ 非阻塞: 立即返回 { runId, childSessionKey }
    │
    ├─ 执行 Agent Turn（独立工具集，无 session tools）
    │
    └─ 完成后:
       ├─ Announce Step (子 Agent 自己的 turn):
       │  ├─ 包含: 原始请求 + 执行结果 + 统计信息
       │  ├─ 输出 ANNOUNCE_SKIP → 静默
       │  └─ 其他 → 发送到请求者的会话渠道
       │
       └─ 自动归档 (archiveAfterMinutes, 默认 60min)
```

---

## 7. 错误恢复与重试

### 7.1 模型层重试

```
runWithModelFallback()
    │
    ├─ 尝试 primary model
    │   ├─ 成功 → 返回
    │   └─ 失败 → 检查错误类型
    │       ├─ Context overflow → auto-compaction → 重试
    │       ├─ Auth 失败 → 轮换 auth profile → 重试
    │       ├─ Rate limit → 等待 + 重试
    │       └─ 其他 → 尝试 fallback models
    │
    ├─ 尝试 fallback[0]
    │   ├─ 成功 → 返回（通知用户已 fallback）
    │   └─ 失败 → 继续
    │
    ├─ 尝试 fallback[1] ...
    │
    └─ 全部失败 → 返回错误
```

### 7.2 Cron Job 重试策略

```
One-shot (一次性):
  transient error → 最多 3 次重试
    └─ 退避: 30s → 1min → 5min
  permanent error → 立即禁用

Recurring (周期性):
  transient error → 指数退避 + 下次调度
    └─ 退避: 30s → 1min → 5min → 15min → 60min
  permanent error → 立即禁用
  success → 重置错误计数
```

### 7.3 消息投递重试

```
deliverOutboundPayloads()
    │
    ├─ Channel API 调用
    │   ├─ 成功 → 完成
    │   ├─ 速率限制 → 等待 Retry-After → 重试
    │   ├─ 网络错误 → 指数退避 → 重试
    │   └─ 永久错误 (403/404) → 放弃 + 日志
    │
    └─ Sub-agent announce:
        ├─ 直接投递优先 (stable idempotency key)
        ├─ 失败 → 队列路由 fallback
        └─ 指数退避重试
```

---

## 8. Auto-Compaction 与 Memory Flush

### 8.1 压缩触发条件

```
Agent Turn 完成后:
    │
    ├─ contextTokens > (contextWindow - reserveTokens)?
    │   └─ 是 → 触发 threshold maintenance compaction
    │
    ├─ 模型返回 context overflow error?
    │   └─ 是 → 触发 overflow recovery compaction
    │
    └─ 用户手动 /compact?
        └─ 是 → 触发 manual compaction
```

### 8.2 Memory Flush（预压缩记忆刷写）

```
Agent Turn 期间:
    │
    ├─ contextTokens 接近 compaction 阈值？
    │   └─ (contextWindow - reserveTokens - softThresholdTokens)
    │
    ├─ 尚未做过 flush（本轮 compaction cycle）？
    │
    └─ 两者都满足 → 触发 silent memory flush turn
        ├─ 注入 prompt: "将重要信息写入 memory/ 目录"
        ├─ 使用 NO_REPLY 静默执行
        ├─ Agent 将关键上下文写入 workspace
        └─ 完成后更新 memoryFlushAt
```

---

## 9. 完整时序图：一条 Telegram 消息的旅程

```
时间 →

User          Telegram        Gateway         Queue          Agent Runtime      LLM Provider
  │               │               │              │                │                │
  │──"你好"──────▶│               │              │                │                │
  │               │──webhook────▶│              │                │                │
  │               │               │              │                │                │
  │               │               │─去重检查────│              │                │
  │               │               │─防抖窗口────│              │                │
  │               │               │─DM策略检查──│              │                │
  │               │               │─路由解析────│              │                │
  │               │               │              │                │                │
  │               │               │─enqueue─────▶│              │                │
  │               │               │              │─获取lane──────│              │
  │               │               │              │                │                │
  │               │◀─typing────── │              │                │                │
  │               │               │              │                │                │
  │               │               │              │──agentCmd────▶│                │
  │               │               │              │                │                │
  │               │               │              │                │─load session──│
  │               │               │              │                │─build prompt──│
  │               │               │              │                │─plugin hooks──│
  │               │               │              │                │                │
  │               │               │              │                │──inference────▶│
  │               │               │              │                │                │
  │               │               │              │                │◀─stream delta──│
  │               │◀─delta msg────│◀─stream──────│◀─assistant────│                │
  │               │               │              │                │                │
  │               │               │              │                │◀─tool_call─────│
  │               │               │              │                │─execute tool───│
  │               │               │              │                │─tool result────│
  │               │               │              │                │──inference────▶│
  │               │               │              │                │                │
  │               │               │              │                │◀─final reply───│
  │               │◀─final msg────│◀─deliver─────│◀─lifecycle/end│                │
  │               │               │              │                │                │
  │               │               │              │─persist────────│                │
  │               │               │              │─agent_end hook─│                │
  │               │               │              │─check compact──│                │
  │               │               │              │─drain followup─│                │
  │◀──回复────────│               │              │                │                │
  │               │               │              │                │                │
```

---

## 10. 配置速查

### 10.1 队列配置

```json5
{
  messages: {
    queue: {
      mode: "collect",        // collect|steer|followup|steer-backlog|interrupt
      debounceMs: 1000,       // 防抖窗口
      cap: 20,                // 最大排队数
      drop: "summarize",      // 溢出策略: old|new|summarize
      byChannel: {
        discord: "collect",
        telegram: "collect",
      }
    },
    inbound: {
      debounceMs: 2000,       // 入站消息防抖
      byChannel: {
        whatsapp: 5000,
        slack: 1500,
      }
    }
  }
}
```

### 10.2 并发配置

```json5
{
  agents: {
    defaults: {
      maxConcurrent: 4,        // main lane 并发数
      timeoutSeconds: 172800,  // Agent 运行超时 (48h)
      subagents: {
        maxConcurrent: 8,      // subagent lane 并发数
        archiveAfterMinutes: 60,
        runTimeoutSeconds: 0,  // 0=无超时
      }
    }
  }
}
```

### 10.3 压缩配置

```json5
{
  agents: {
    defaults: {
      compaction: {
        enabled: true,
        reserveTokensFloor: 20000,
        timeoutSeconds: 900,   // 15min
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 4000,
          // prompt 和 systemPrompt 有默认值
        }
      }
    }
  }
}
```

### 10.4 Session Reset 配置

```json5
{
  session: {
    reset: {
      daily: true,             // 每日重置
      dailyHour: 4,            // 默认 4:00 AM（本地时间）
      idleMinutes: 0,          // 0=禁用空闲重置
    },
    parentForkMaxTokens: 100000,
    dmScope: "per-channel-peer",
  }
}
```

---

## 11. 关键设计原则总结

| 原则 | 实现 |
|------|------|
| **Session 串行** | 每个 sessionKey 同时只有一个 Agent Run，通过 session lane 保证 |
| **全局并发控制** | main/cron/subagent 三条独立 lane，互不阻塞 |
| **非阻塞入口** | `agent` RPC 立即返回 runId，`agent.wait` 是独立的等待操作 |
| **优雅降级** | 模型 fallback chain → auth profile 轮换 → 最终报错 |
| **静默执行** | NO_REPLY 约定：memory flush、heartbeat 等不产生用户可见输出 |
| **事件驱动** | Plugin hooks 在关键点提供拦截/注入机会，不改核心代码 |
| **持久化分层** | SessionStore (可变元数据) + Transcript (追加日志) 双层 |
| **渠道无关** | 核心逻辑不依赖具体渠道，Channel Plugin 负责适配 |

---

*报告由 wairesearch (黄山) 基于官方文档 + 源码分析编写 | 2026-04-01*
