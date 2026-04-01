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

---

## 6A. 定时任务执行机制深度解析

> 本节补充 Heartbeat、Cron、Webhook 三种自动化触发方式的完整内部执行链路。

### 6A.1 Cron Scheduler 内部架构

#### 定时器与调度循环

```
Gateway 启动
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│  Cron Scheduler 初始化                                    │
│  1. 加载 jobs.json (持久化存储)                           │
│  2. runMissedJobs() — 启动追赶                           │
│     ├─ 收集 nextRunAtMs ≤ now 的所有 job                 │
│     ├─ 按 nextRunAtMs 排序                               │
│     ├─ 立即执行 ≤ maxMissedJobsPerRestart                │
│     └─ 超出的延迟执行（防止过载）                         │
│  3. armTimer() — 设置下一个唤醒                           │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │  setTimeout()   │  ← MAX_TIMER_DELAY_MS = 60s
        │  (JS 定时器)    │     如果下次唤醒 > 60s，
        │                 │     分多次 60s 跳转
        └────────┬───────┘
                 │ 定时器到期
                 ▼
┌─────────────────────────────────────────────────────────┐
│  Timer Tick 处理                                         │
│                                                          │
│  1. locked(() => {                                       │
│       ── normalizeJobTickState() ──                      │
│       │  • 禁用的 job: 清除 nextRunAtMs/runningAtMs    │
│       │  • 卡住的 job: runningAtMs > STUCK_RUN_MS      │
│       │    → 清除 runningAtMs（解除死锁）               │
│       │                                                  │
│       ── collectDueJobs(now) ──                          │
│       │  • 过滤 enabled && nextRunAtMs <= now            │
│       │  • 过滤 !runningAtMs（跳过正在运行的）          │
│       │  • MIN_REFIRE_GAP_MS = 2s（防止连续触发）       │
│       │                                                  │
│       ── 标记 runningAtMs = now ──                       │
│       ── 持久化 jobs.json ──                             │
│     })                                                   │
│                                                          │
│  2. 并发执行到期 jobs:                                    │
│     pool = min(maxConcurrentRuns, dueJobs.length)        │
│     await Promise.all(pool.map(executeJob))              │
│                                                          │
│  3. locked(() => {                                       │
│       ── applyOutcomeToStoredJob() ──                    │
│       │  • 更新 lastRunAtMs, lastStatus                 │
│       │  • 管理 consecutiveErrors 计数                   │
│       │  • 重新计算 nextRunAtMs                          │
│       ── 持久化 jobs.json ──                             │
│     })                                                   │
│                                                          │
│  4. sweepCronRunSessions()                               │
│     • 在 locked() 外执行（避免锁顺序反转）              │
│     • MIN_SWEEP_INTERVAL_MS = 5min（自限频）             │
│     • 清理过期的 cron run sessions                       │
│                                                          │
│  5. armTimer() — 设置下一个唤醒                           │
│     • nextWakeAtMs = min(所有 enabled job 的 nextRunAtMs) │
└─────────────────────────────────────────────────────────┘
```

#### 三种调度类型的时间计算

```
┌─────────────────────────────────────────────────────────┐
│ computeJobNextRunAtMs(job, now)                          │
│                                                          │
│ ┌───────────┐                                           │
│ │ "at"       │ 一次性                                    │
│ │            │ → schedule.atMs (ISO时间戳转换)            │
│ │            │ → 如果已执行过: 返回 null（不再调度）      │
│ └───────────┘                                           │
│                                                          │
│ ┌───────────┐                                           │
│ │ "every"    │ 固定间隔                                  │
│ │            │ → anchor = lastRunAtMs ?? createdAtMs      │
│ │            │ → nextRun = anchor + schedule.intervalMs   │
│ │            │ → 如果 nextRun <= now: 立即执行            │
│ └───────────┘                                           │
│                                                          │
│ ┌───────────┐                                           │
│ │ "cron"     │ Cron 表达式 (5/6 字段 + IANA 时区)       │
│ │            │ → 解析 cron 表达式计算下次触发时间         │
│ │            │ → + stagger offset (确定性偏移)           │
│ │            │                                           │
│ │  Stagger:  │ resolveStableCronOffsetMs(jobId)          │
│ │            │ = SHA256(jobId) % staggerMs               │
│ │            │ → 0~5min 窗口内的确定性偏移               │
│ │            │ → LRU 缓存，避免重复 hash 计算            │
│ │            │ → 目的: 整点任务分散执行，减少负载尖峰     │
│ │            │ → 注意: 固定小时表达式不受 stagger 影响    │
│ └───────────┘                                           │
└─────────────────────────────────────────────────────────┘
```

#### Isolated Agent Turn 执行详情

```
runCronIsolatedAgentTurn(job, runId)
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│ 1. Agent 解析                                            │
│    agentId = job.payload.agentId ?? defaultAgentId        │
│    加载 agent config                                      │
│                                                          │
│ 2. Session 创建                                          │
│    sessionKey = "cron:<jobId>:run:<uuid>"                 │
│    全新隔离 session，无历史上下文                          │
│                                                          │
│ 3. 模型解析链                                            │
│    job.payload.model                                      │
│    → agents.defaults.subagents.model                     │
│    → hooks.gmail.model (如来自 Gmail)                    │
│    → agents.list[agentId].model                          │
│    → agents.defaults.model.primary                       │
│                                                          │
│ 4. 思考级别解析                                          │
│    job.payload.thinking                                   │
│    → hooks.gmail.thinking                                │
│    → model catalog defaults                              │
│    → 如果模型不支持 xhigh，自动降级                      │
│                                                          │
│ 5. 安全包装                                              │
│    if (!allowUnsafeExternalContent) {                     │
│      prompt = wrapWithSafetyBoundary(job.payload.command)│
│    }                                                      │
│    // 防止外部 hook 内容（如 Gmail 邮件体）               │
│    // 的 prompt injection                                 │
│                                                          │
│ 6. 投递上下文解析                                        │
│    target = job.payload.delivery                          │
│    ├─ channel: 目标渠道 (telegram/whatsapp/last/...)     │
│    ├─ to: 目标 ID                                        │
│    └─ accountId: 多账号时指定                             │
│    工具策略:                                              │
│    ├─ requireExplicitMessageTarget = true                 │
│    └─ disableMessageTool = !delivery.enabled              │
│                                                          │
│ 7. Session 预持久化                                      │
│    写入 session entry (model, provider, systemSent)       │
│    注册 run context 用于日志                               │
│                                                          │
│ 8. 执行                                                  │
│    result = runWithModelFallback({                        │
│      prompt: 包装后的命令,                                │
│      model: 解析后的模型,                                 │
│      thinking: 解析后的级别,                              │
│      abortSignal: AbortController (超时控制)              │
│    })                                                     │
│                                                          │
│ 9. 中间确认检测                                          │
│    if (isLikelyInterimCronMessage(result)) {             │
│      // Agent 只是说"好的我来做" 但没有实际完成            │
│      // → 重新 prompt 要求完成任务                       │
│    }                                                      │
│                                                          │
│ 10. 投递                                                 │
│     ├─ announce:                                         │
│     │  → 直接发送到目标渠道                               │
│     │  → 同时在主 session 写入摘要                        │
│     │  → 去重: 如果 isolated run 已经发过同目标，跳过    │
│     ├─ webhook:                                          │
│     │  → HTTP POST 到配置的 URL                          │
│     │  → payload: { jobId, status, result, usage }       │
│     └─ none:                                             │
│        → 仅记录到 run log，不对外投递                     │
│                                                          │
│ 11. 返回                                                 │
│     { sessionId, sessionKey, status, error }              │
└─────────────────────────────────────────────────────────┘
```

#### 重试与退避策略

```
┌─────────────────────────────────────────────────────────┐
│ 错误分类:                                                │
│                                                          │
│ TRANSIENT_PATTERNS (正则匹配):                           │
│   rate_limit | overloaded | network | timeout |          │
│   server_error | 5xx                                     │
│                                                          │
│ Permanent errors (其他所有):                              │
│   auth_error | validation_error | ...                    │
│                                                          │
│ ─── One-shot Job ("at" 类型) ───                         │
│                                                          │
│   Transient: 最多 3 次重试                                │
│     attempt 1 → wait 30s → retry                         │
│     attempt 2 → wait 1min → retry                        │
│     attempt 3 → wait 5min → retry                        │
│     attempt 4 → 放弃，标记失败                            │
│                                                          │
│   Permanent: 立即禁用 job                                 │
│                                                          │
│ ─── Recurring Job ("every"/"cron" 类型) ───              │
│                                                          │
│   Transient: 指数退避 + 正常调度继续                       │
│     error 1  → backoff 30s  → 正常下次调度               │
│     error 2  → backoff 1min → 正常下次调度               │
│     error 3  → backoff 5min                              │
│     error 4  → backoff 15min                             │
│     error 5+ → backoff 60min (上限)                      │
│     success  → 重置 consecutiveErrors = 0                │
│                                                          │
│   Permanent: 立即禁用 job                                 │
│                                                          │
│ ─── Schedule Compute Error ───                           │
│   (Cron 表达式解析失败等)                                  │
│   scheduleErrorCount++                                    │
│   if (≥ MAX_SCHEDULE_ERRORS = 3) {                       │
│     禁用 job                                              │
│     enqueueSystemEvent("Cron job disabled: ...")         │
│     requestHeartbeat() // 通知用户                        │
│   }                                                      │
└─────────────────────────────────────────────────────────┘
```

#### Session 清理（Reaper）

```
sweepCronRunSessions()  ← 每次 timer tick 后调用
    │
    ├─ 自限频: 距上次 sweep < 5min → 跳过
    │
    ├─ 遍历 session store:
    │  └─ 匹配 key 格式 "cron:<jobId>:run:<uuid>"
    │     └─ updatedAt + retentionMs < now → 标记清理
    │        retentionMs = cron.sessionRetention (默认 24h)
    │
    ├─ 归档 transcript 文件
    │  └─ 移到归档目录
    │
    ├─ 清理过期归档
    │  └─ 归档时间 + retentionMs < now → 删除
    │
    └─ 返回 { swept, pruned }

Run Log 清理:
    文件: ~/.openclaw/cron/runs/<jobId>.jsonl
    ├─ 超过 maxBytes (默认 2MB) → 截断
    └─ 保留最新 keepLines (默认 2000) 行
```

#### 持久化与文件布局

```
~/.openclaw/
├── cron/
│   ├── jobs.json                      ← Job 定义 + 状态
│   │   {
│   │     "<jobId>": {
│   │       id, schedule, payload, enabled,
│   │       nextRunAtMs,              // 下次执行时间
│   │       runningAtMs,              // 正在运行标记
│   │       lastRunAtMs,              // 上次执行时间
│   │       lastStatus,               // "ok" | "error"
│   │       consecutiveErrors,        // 连续错误计数
│   │       scheduleErrorCount,       // 调度计算错误计数
│   │       createdAtMs,              // 创建时间
│   │     }
│   │   }
│   └── runs/
│       └── <jobId>.jsonl             ← 运行历史日志
│           每行: { runId, startedAt, endedAt, status, error?, usage? }
│
└── agents/<agentId>/sessions/
    └── <cron:jobId:run:uuid>.jsonl   ← 隔离 session transcript
```

---

### 6A.2 Heartbeat 执行详情

```
Gateway Heartbeat 定时器
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│ Heartbeat 检查                                           │
│                                                          │
│ 1. 触发间隔:                                             │
│    agents.defaults.heartbeat.every (默认 30min)           │
│    Anthropic OAuth/setup-token: 默认 60min               │
│                                                          │
│ 2. 前置检查:                                             │
│    ├─ activeHours 窗口检查（如配置）                      │
│    ├─ 主 session 是否忙碌？                               │
│    │   └─ 忙碌 → 跳过，下次重试                          │
│    └─ 上次心跳是否太近？                                  │
│                                                          │
│ 3. Prompt 构建:                                          │
│    默认 prompt:                                           │
│    "Read HEARTBEAT.md if it exists (workspace context).  │
│     Follow it strictly. Do not infer or repeat old tasks │
│     from prior chats. If nothing needs attention,        │
│     reply HEARTBEAT_OK."                                  │
│    可通过 heartbeat.prompt 自定义                          │
│                                                          │
│ 4. 在主 Session 中执行 Agent Turn                        │
│    ├─ 有完整 session 上下文                               │
│    ├─ 可访问工具                                          │
│    └─ lightContext 选项（减少注入的上下文量）              │
│                                                          │
│ 5. 响应处理:                                             │
│    response.startsWith("HEARTBEAT_OK")?                   │
│    ├─ 是 + 剩余 ≤ ackMaxChars (默认 300):               │
│    │   → 静默（NO_REPLY 语义）                           │
│    │   → showOk=true 才会展示                             │
│    │                                                      │
│    └─ 否（有实质内容）:                                   │
│        → 按 target 投递:                                  │
│          ├─ "last" → 最近活跃的渠道/联系人                │
│          ├─ "none" → 不投递（仅日志）                     │
│          ├─ 指定 channel + to → 精确投递                  │
│          └─ directPolicy: allow|block → DM 控制          │
│                                                          │
│ 6. 配置优先级:                                           │
│    agents.defaults.heartbeat  (基础)                      │
│    → agents.list[].heartbeat  (Agent 级覆盖)             │
│    → channels.defaults.heartbeat                         │
│    → channels.<channel>.heartbeat                        │
│    → channels.<channel>.accounts.<id>.heartbeat          │
│                                                          │
│ 7. 可见性控制:                                           │
│    showOk: 是否展示 HEARTBEAT_OK 响应                     │
│    showAlerts: 是否展示告警                                │
│    useIndicator: 是否使用 typing 指示器                   │
└─────────────────────────────────────────────────────────┘
```

**Heartbeat vs Cron 执行差异**：

| 维度 | Heartbeat | Cron (isolated) |
|------|-----------|-----------------|
| **Session** | 主 session（有完整上下文） | 隔离 session（无历史） |
| **定时精度** | 近似（忙则跳过+重试） | 精确（stagger 最多 5min） |
| **上下文** | 有完整对话历史+workspace | 仅 job payload 命令 |
| **模型** | 默认或 heartbeat.model | job 级可覆盖 |
| **重试** | 无（跳过即丢失） | 指数退避重试 |
| **通知** | HEARTBEAT_OK 静默 | announce/webhook/none |
| **用途** | 巡检、提醒、上下文感知任务 | 精确定时、后台任务、隔离执行 |

---

### 6A.3 Webhook 执行详情

```
外部系统
    │
    ▼
POST /hooks/wake
POST /hooks/agent
POST /hooks/<name>  (mapped)
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│ Webhook Ingress                                          │
│                                                          │
│ 1. 认证:                                                │
│    ├─ Authorization: Bearer <token>                      │
│    ├─ x-openclaw-token: <token>                         │
│    └─ ❌ ?token= 查询参数 → 400 拒绝                    │
│    失败: 401 + IP 级速率限制 (429 + Retry-After)         │
│                                                          │
│ 2. 路由:                                                │
│                                                          │
│    ┌─── /hooks/wake ───┐                                │
│    │ 轻量唤醒:          │                                │
│    │ • 入队系统事件到主 session                           │
│    │ • mode: "now" → 立即心跳                            │
│    │ • mode: "next-heartbeat" → 下次心跳处理             │
│    │ • 返回 200                                          │
│    └────────────────────┘                                │
│                                                          │
│    ┌─── /hooks/agent ───┐                               │
│    │ 隔离执行:           │                                │
│    │ • 解析 agentId (allowedAgentIds 白名单)             │
│    │ • sessionKey:                                        │
│    │   ├─ 默认: hooks.defaultSessionKey                  │
│    │   ├─ 请求覆盖: 需 allowRequestSessionKey=true       │
│    │   └─ 前缀限制: allowedSessionKeyPrefixes            │
│    │ • 安全包装:                                          │
│    │   ├─ 默认: 用 safety boundary 包裹 message          │
│    │   └─ allowUnsafeExternalContent=true: 跳过          │
│    │ • 执行 isolated agent turn                          │
│    │ • 主 session 写入摘要                                │
│    │ • deliver=true: 按 channel/to 投递                  │
│    │ • 返回 200 (异步执行已接受)                          │
│    └────────────────────┘                                │
│                                                          │
│    ┌─── /hooks/<name> ───┐                              │
│    │ Mapped Hook:         │                              │
│    │ • hooks.mappings 路由                                │
│    │ • hooks.presets (如 "gmail")                         │
│    │ • match.source 基于 payload 路由                     │
│    │ • transform.module 自定义 JS/TS 转换                │
│    │ • 转换为 wake 或 agent action 后执行                │
│    └────────────────────┘                                │
│                                                          │
│ 3. 安全:                                                │
│    ├─ hooks.token ≠ gateway.auth.token（分离凭证）       │
│    ├─ 推荐: 专用 hook agent + 严格 tools.profile         │
│    ├─ hook payload 视为不可信内容                          │
│    └─ IP 级认证失败速率限制                               │
└─────────────────────────────────────────────────────────┘
```

---

### 6A.4 三种自动化方式的选择决策树

```
                    需要自动化执行？
                         │
              ┌──────────┴──────────┐
              │                      │
        内部定时触发？           外部系统触发？
              │                      │
              │                      ▼
              │                  Webhook
              │                  /hooks/wake 或 /hooks/agent
              │
        ┌─────┴─────┐
        │             │
   需要上下文？    需要精确定时？
   需要巡检？      需要隔离？
        │             │
        ▼             ▼
    Heartbeat      Cron Job
    (主session)    (隔离session)

组合使用最佳实践:
┌─────────────────────────────────────────────────┐
│ Heartbeat: 每 30min 巡检                         │
│   → 读取 HEARTBEAT.md 检查清单                   │
│   → 检查系统状态、待处理事项                      │
│   → 利用完整上下文做感知判断                      │
│                                                  │
│ Cron (isolated): 每天 9:00 生成日报               │
│   → 精确定时，不依赖 session 状态                 │
│   → announce 到 Telegram                         │
│   → 即使 session 忙碌也不跳过                     │
│                                                  │
│ Cron (main): 每小时检查 CI 状态                   │
│   → 注入系统事件到主 session                      │
│   → 下次心跳或用户消息时 Agent 看到并处理         │
│   → 不产生独立 session 开销                       │
│                                                  │
│ Webhook: GitHub push → 触发代码审查               │
│   → 外部 CI 完成后 POST /hooks/agent             │
│   → 隔离执行，结果投递到团队频道                  │
└─────────────────────────────────────────────────┘
```

---

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
