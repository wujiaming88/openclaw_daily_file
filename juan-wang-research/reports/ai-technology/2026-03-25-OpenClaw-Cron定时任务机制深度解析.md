# OpenClaw 定时任务（Cron）机制深度解析

> **研究员**: 黄山 (wairesearch)
> **日期**: 2026-03-25
> **来源**: 官方文档 + 源码分析（gateway-cli-CuZs0RlJ.js）

---

## 一、架构概览

### 1.1 Cron 在 OpenClaw 中的位置

```
┌──────────────────────────────────────────────────┐
│                 OpenClaw Gateway                   │
│                                                    │
│  ┌────────────┐  ┌────────────┐  ┌─────────────┐ │
│  │ Channel    │  │ Heartbeat  │  │ Cron        │ │
│  │ Manager    │  │ Runner     │  │ Scheduler   │ │
│  │            │  │            │  │             │ │
│  │ Telegram   │  │ 定时心跳    │  │ 定时任务    │ │
│  │ WhatsApp   │  │ 主session  │  │ 独立session │ │
│  │ Discord    │  │            │  │             │ │
│  │ ...        │  │            │  │             │ │
│  └────────────┘  └─────┬──────┘  └──────┬──────┘ │
│                        │                 │         │
│                        ▼                 ▼         │
│  ┌─────────────────────────────────────────────┐  │
│  │          Agent Runtime (Pi Engine)          │  │
│  │     runEmbeddedPiAgent / runCliAgent        │  │
│  └─────────────────────────────────────────────┘  │
│                        │                           │
│  ┌─────────────────────▼───────────────────────┐  │
│  │          Session Store + Transcripts        │  │
│  │     ~/.openclaw/agents/<id>/sessions/       │  │
│  └─────────────────────────────────────────────┘  │
│                                                    │
│  ┌─────────────────────────────────────────────┐  │
│  │          Cron Store                         │  │
│  │     ~/.openclaw/cron/jobs.json              │  │
│  │     ~/.openclaw/cron/runs/<jobId>.jsonl     │  │
│  └─────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

**核心定位**: Cron 是 Gateway 进程的**内置调度器**，不是 OS crontab，不是外部服务。它运行在 Gateway 的 Node.js 事件循环中，和 Channel、Heartbeat 共享同一个进程。

### 1.2 和 Heartbeat 的关系

| 维度 | Heartbeat | Cron |
|------|-----------|------|
| 运行位置 | 主 session | 主 session 或独立 session |
| 触发精度 | 大约每 N 分钟（有漂移） | 精确时间（cron 表达式） |
| 上下文 | 完整主 session 对话历史 | 独立 session = 空白上下文 |
| 用途 | 批量周期检查（邮件、日历等） | 精确定时任务（日报、提醒） |
| 模型 | 跟随主 session | 可独立指定 |
| 成本 | 一次 turn 可检查多项 | 每个 job 是一次独立 turn |

**Cron 和 Heartbeat 可以协作**：Cron 的 `main session` 模式通过向 Heartbeat 注入系统事件来工作，本质是"给心跳一个提醒"。

---

## 二、数据模型

### 2.1 Job 结构

从源码和文档提取的完整 Job 数据模型：

```typescript
interface CronJob {
  // === 标识 ===
  id: string;                    // UUID，创建时生成
  name: string;                  // 任务名称
  description?: string;          // 可选描述
  
  // === 调度 ===
  schedule: {
    kind: "at" | "every" | "cron";
    at?: string;                 // ISO 8601 时间戳（kind=at）
    atMs?: number;               // 解析后的毫秒时间戳
    everyMs?: number;            // 间隔毫秒数（kind=every）
    expr?: string;               // cron 表达式（kind=cron）
    tz?: string;                 // IANA 时区（kind=cron）
    staggerMs?: number;          // 自定义错峰窗口
    anchorMs?: number;           // every 的锚定时间
  };
  
  // === 执行目标 ===
  sessionTarget: "main" | "isolated";
  agentId?: string;              // 指定 Agent（默认用 default agent）
  sessionKey?: string;           // 目标 session key
  wakeMode: "now" | "next-heartbeat";
  
  // === 载荷 ===
  payload: {
    kind: "systemEvent" | "agentTurn";
    text?: string;               // systemEvent 的文本
    message?: string;            // agentTurn 的 prompt
    model?: string;              // 模型覆盖
    thinking?: string;           // 推理等级覆盖
    timeoutSeconds?: number;     // 超时覆盖
    lightContext?: boolean;      // 轻量启动上下文
    fallbacks?: string[];        // 模型降级链
    allowUnsafeExternalContent?: boolean;  // 外部 hook 内容安全
  };
  
  // === 投递 ===
  delivery?: {
    mode: "announce" | "webhook" | "none";
    channel?: string;            // telegram/whatsapp/discord/slack/...
    to?: string;                 // 频道内目标
    accountId?: string;          // 多账号场景
    bestEffort?: boolean;        // 投递失败不影响 job 状态
  };
  
  // === 生命周期 ===
  enabled: boolean;
  createdAtMs: number;
  deleteAfterRun?: boolean;      // at 类型默认 true
  
  // === 运行时状态 ===
  state: {
    nextRunAtMs?: number;        // 下次执行时间
    lastRunAtMs?: number;        // 上次执行时间
    lastStatus?: "ok" | "error" | "skipped";
    lastError?: string;
    runningAtMs?: number;        // 正在执行标记
    consecutiveErrors?: number;  // 连续错误计数
    scheduleErrorCount?: number; // 调度计算错误计数
  };
  
  // === 告警 ===
  failureAlert?: {
    after?: number;              // 连续失败 N 次后告警
    cooldownMs?: number;
    channel?: string;
    to?: string;
    mode?: "webhook";
    accountId?: string;
  } | false;
}
```

### 2.2 存储

```
~/.openclaw/cron/
├── jobs.json              ← Job store（所有 job 的 JSON）
└── runs/
    ├── <jobId-1>.jsonl    ← Job 1 的运行历史（JSONL 追加）
    ├── <jobId-2>.jsonl    ← Job 2 的运行历史
    └── ...
```

- **jobs.json**: Gateway 启动时加载到内存，变更时原子写回磁盘。手动编辑需停止 Gateway。
- **runs/*.jsonl**: 每次执行后追加一行 JSON。自动裁剪（默认 2MB / 2000 行）。
- **Session 记录**: 独立 job 的 session 存在 `~/.openclaw/agents/<agentId>/sessions/sessions.json`，key 格式 `<agentId>:cron:<jobId>:run:<uuid>`，默认 24h 后自动清理。

---

## 三、调度器原理（源码级）

### 3.1 定时器模型

OpenClaw 的 Cron 不是轮询模型，而是**事件驱动 + setTimeout 精确唤醒**：

```
                    ┌─────────────────────────┐
                    │     Gateway 启动         │
                    └────────┬────────────────┘
                             │
                             ▼
                    ┌─────────────────────────┐
                    │  loadCronStore()         │
                    │  加载 jobs.json 到内存   │
                    └────────┬────────────────┘
                             │
                             ▼
                    ┌─────────────────────────┐
                    │  recomputeNextRuns()     │
                    │  计算每个 job 的 nextRunAtMs │
                    └────────┬────────────────┘
                             │
                             ▼
                    ┌─────────────────────────┐
                    │  runMissedJobs()         │
                    │  补跑重启期间错过的 job   │
                    └────────┬────────────────┘
                             │
                             ▼
                    ┌─────────────────────────┐
            ┌─────►│  armTimer()              │◄──────────────┐
            │      │  找到最近的 nextRunAtMs   │               │
            │      │  设置 setTimeout(delay)  │               │
            │      └────────┬────────────────┘               │
            │               │                                 │
            │               ▼  (delay 到期)                    │
            │      ┌─────────────────────────┐               │
            │      │  onTimer()              │               │
            │      │  锁定 → 重新加载 store   │               │
            │      │  collectRunnableJobs()  │               │
            │      └────────┬────────────────┘               │
            │               │                                 │
            │               ▼                                 │
            │      ┌─────────────────────────┐               │
            │      │  标记 runningAtMs       │               │
            │      │  persist() 写盘         │               │
            │      └────────┬────────────────┘               │
            │               │                                 │
            │               ▼                                 │
            │      ┌─────────────────────────┐               │
            │      │  并发执行 due jobs       │               │
            │      │  (maxConcurrentRuns=1)  │               │
            │      └────────┬────────────────┘               │
            │               │                                 │
            │               ▼                                 │
            │      ┌─────────────────────────┐               │
            │      │  applyOutcomeToStoredJob │               │
            │      │  更新 state, 重算 next   │               │
            │      │  persist() 写盘         │               │
            │      └────────┬────────────────┘               │
            │               │                                 │
            │               ▼                                 │
            │      ┌─────────────────────────┐               │
            │      │  sweepCronRunSessions() │               │
            │      │  清理过期 session        │               │
            │      └────────┬────────────────┘               │
            │               │                                 │
            └───────────────┘  armTimer() 重新设定             │
```

### 3.2 关键常量

```javascript
MAX_TIMER_DELAY_MS = 60_000;       // 最大 setTimeout 间隔 60 秒
MIN_REFIRE_GAP_MS = 2_000;         // 两次执行最小间隔 2 秒
STUCK_RUN_MS (未显式定义，代码检查)  // 判断卡住的运行标记
MAX_SCHEDULE_ERRORS = 3;            // 连续调度计算错误 3 次自动禁用
DEFAULT_MAX_MISSED_JOBS_PER_RESTART // 重启后最大补跑数量
```

**为什么 MAX_TIMER_DELAY_MS 是 60 秒？**

Node.js 的 `setTimeout` 对超长延迟有精度问题。OpenClaw 的做法是：即使下一个 job 要 3 小时后执行，也最多设 60 秒的 timer。timer 到期后：
1. 重新加载 store（检查是否有新 job）
2. 检查是否有 due job
3. 如果没有，重新 arm 下一个 60 秒
4. 如果有 job 正在执行（`state.running = true`），切换到 `armRunningRecheckTimer`

### 3.3 isJobDue 判断逻辑

```javascript
function isJobDue(job, nowMs, opts) {
  // 正在运行的不重复执行
  if (typeof job.state.runningAtMs === "number") return false;
  // 强制执行模式
  if (opts.forced) return true;
  // 正常判断：启用 + 有计划执行时间 + 当前时间已过
  return job.enabled 
    && typeof job.state.nextRunAtMs === "number" 
    && nowMs >= job.state.nextRunAtMs;
}
```

### 3.4 nextRunAtMs 计算

三种调度类型的计算方式：

**at（一次性）**：
```javascript
// 直接解析 ISO 时间戳为毫秒
atMs = parseAbsoluteTimeMs(schedule.at);
// 支持相对时间如 "20m"
// 已执行过且成功 → 返回 undefined（不再执行）
```

**every（固定间隔）**：
```javascript
// 从上次执行时间推算
nextFromLastRun = lastRunAtMs + everyMs;
// 如果超过当前时间，用锚定时间重新计算
anchorMs = schedule.anchorMs ?? createdAtMs ?? nowMs;
```

**cron（表达式）**：
```javascript
// 使用 croner 库解析 cron 表达式
// 5 字段（标准）或 6 字段（含秒）
// 支持 IANA 时区
// 加上 stagger 偏移
nextRunAtMs = cronNextTime + staggerOffset;
```

### 3.5 错峰机制（Stagger）

**问题**：大量 Gateway 在同一时间（整点）触发 job，造成 LLM API 负载尖峰。

**解决**：对整点触发的 cron 表达式，自动添加确定性偏移。

```javascript
function resolveStableCronOffsetMs(jobId, staggerMs) {
  if (staggerMs <= 1) return 0;
  // 用 jobId 的 SHA256 hash 取模，生成确定性偏移
  const offset = crypto.createHash("sha256")
    .update(jobId)
    .digest()
    .readUInt32BE(0) % staggerMs;
  return offset;
}
```

特性：
- 默认窗口 5 分钟（对 `0 * * * *` 这类整点表达式）
- `0 7 * * *` 这类固定时间不 stagger
- 偏移基于 jobId 的 hash，**确定性**——同一个 job 每次偏移相同
- 可通过 `--exact` 强制精确触发（`staggerMs = 0`）
- 可通过 `--stagger 30s` 自定义窗口

### 3.6 并发控制

```javascript
// 默认 maxConcurrentRuns = 1（串行执行）
const concurrency = Math.min(
  resolveRunConcurrency(state),    // 配置值
  Math.max(1, dueJobs.length)      // 不超过 due job 数量
);

// worker 池模式并发执行
const workers = Array.from({ length: concurrency }, async () => {
  for (;;) {
    const index = cursor++;
    if (index >= dueJobs.length) return;
    results[index] = await runDueJob(dueJobs[index]);
  }
});
await Promise.all(workers);
```

**默认串行**是有意设计：避免多个 job 同时抢占 LLM API quota。

### 3.7 锁机制

```javascript
// 文件级互斥锁，防止 store 并发写入
const storeLocks = new Map();

async function locked(state, fn) {
  const storePath = state.deps.storePath;
  const storeOp = storeLocks.get(storePath) ?? Promise.resolve();
  // 等待前一个操作和全局 store 锁都完成
  const next = Promise.all([
    resolveChain(state.op),
    resolveChain(storeOp)
  ]).then(fn);
  state.op = resolveChain(next);
  storeLocks.set(storePath, resolveChain(next));
  return await next;
}
```

所有 store 变更都在 `locked()` 内执行，保证：
- 不会丢失 job 状态更新
- 不会并发写坏 jobs.json

---

## 四、执行模式详解

### 4.1 Main Session 模式

```
Cron Timer 到期
    │
    ▼
enqueueSystemEvent(text, { sessionKey, contextKey: "cron:<jobId>" })
    │
    ▼ (如果 wakeMode="now")
runHeartbeatOnce({ reason: "cron:<jobId>" })
    │
    ▼
Heartbeat Runner 处理
    │
    ▼
Agent 在主 session 中看到：
  "System: [09:00 UTC] Reminder: check the cron docs draft"
    │
    ▼
Agent 在主 session 上下文中响应
```

**特点**：
- 不创建新 session，不消耗额外 token（批量进入 heartbeat）
- Agent 有完整的主 session 对话历史
- 如果主 session 正忙（有请求在处理），会等待（最多 2 分钟），超时后降级为 `requestHeartbeatNow`（排队）

### 4.2 Isolated Session 模式

```
Cron Timer 到期
    │
    ▼
runCronIsolatedAgentTurn({
  job, message, abortSignal
})
    │
    ├── 解析 Agent ID（job.agentId → default agent）
    ├── 构建 Agent 配置（合并 agent defaults + overrides）
    ├── 创建 session entry（cron:<jobId>:run:<uuid>）
    ├── 解析模型（payload.model → session override → agent default）
    ├── 解析 thinking level
    ├── 解析 delivery target
    ├── 构建 prompt: "[cron:<jobId> <name>] <message>\n<timeLine>"
    │
    ▼
runEmbeddedPiAgent({
  sessionId, agentId, provider, model,
  trigger: "cron",
  senderIsOwner: true,      // cron 任务以 owner 权限运行
  bootstrapContextMode,      // lightContext → "lightweight"
  bootstrapContextRunKind: "cron",
  disableMessageTool,        // 如果有 delivery，禁用 message tool
  requireExplicitMessageTarget,
  ...
})
    │
    ▼
Agent 执行（工具调用、网络搜索等）
    │
    ▼
检查输出：如果只是确认性回复（"on it"、"sure"），
自动追加第二轮 prompt 要求完成实际任务
    │
    ▼ (delivery.mode = "announce")
deliverOutboundPayloads → Channel Adapter → Telegram/WhatsApp/...
    │
    ▼
Post main-session summary（简要通知主 session）
    │
    ▼
记录 run log → runs/<jobId>.jsonl
清理 session（根据 sessionRetention）
```

**关键细节**：

1. **每次运行是全新 session**——没有对话历史，空白上下文
2. **Prompt 前缀**：`[cron:<jobId> <name>]`，Agent 知道自己在执行 cron 任务
3. **lightContext**：设置后不注入 SOUL.md、MEMORY.md 等 bootstrap 文件，适合轻量任务
4. **防空回复**：源码中有 `isLikelyInterimCronMessage` 检查，如果 Agent 只回复了"好的"之类的确认，自动追加第二轮 prompt 强制完成任务
5. **delivery 和 message tool 互斥**：如果配置了 delivery（自动投递），会禁用 message tool，防止重复发送

### 4.3 模型解析优先级

Isolated job 的模型解析经过 5 层 fallback：

```
1. payload.model         ← job 级覆盖（最高优先级）
2. hooks.gmail.model     ← gmail hook 专用
3. session.modelOverride ← session 级覆盖
4. agent.model           ← agent 配置
5. agents.defaults.model ← 全局默认
```

---

## 五、重试与容错

### 5.1 错误分类

```javascript
// 瞬态错误（可重试）
const TRANSIENT_PATTERNS = {
  rate_limit:   /(rate[_ ]limit|too many requests|429|resource exhausted)/i,
  overloaded:   /\b529\b|\boverloaded\b|high demand|capacity exceeded/i,
  network:      /(network|econnreset|econnrefused|fetch failed|socket)/i,
  timeout:      /(timeout|etimedout)/i,
  server_error: /\b5\d{2}\b/
};

// 永久错误（不重试）
// - 认证失败（invalid API key, unauthorized）
// - 配置/验证错误
// - 其他非瞬态错误
```

### 5.2 重试策略

**一次性任务（at）**：
```
瞬态错误 → 最多重试 3 次
退避间隔: 30s → 60s → 300s
永久错误 → 立即禁用
成功或 skip → 禁用（或删除，如果 deleteAfterRun=true）
```

**循环任务（cron/every）**：
```
任何错误 → 指数退避后在下个计划时间重试
退避间隔: 30s → 60s → 300s → 900s → 3600s
Job 保持 enabled
下次成功后退避自动重置
```

### 5.3 退避实现

```javascript
const DEFAULT_BACKOFF_SCHEDULE_MS = [
  30_000,      // 30 秒
  60_000,      // 1 分钟
  300_000,     // 5 分钟
  900_000,     // 15 分钟
  3_600_000    // 60 分钟（上限）
];

function errorBackoffMs(consecutiveErrors, scheduleMs) {
  const idx = Math.min(
    consecutiveErrors - 1,
    scheduleMs.length - 1
  );
  return scheduleMs[Math.max(0, idx)];
}
```

### 5.4 Gateway 重启补跑

```javascript
async function runMissedJobs(state, opts) {
  // 1. 收集重启期间错过的 job
  const missed = collectRunnableJobs(state, now, {
    skipAtIfAlreadyRan: true,       // at 类型如果已执行过，不重复
    allowCronMissedRunByLastRun: true // 用 lastRunAtMs 判断是否错过
  });
  
  // 2. 按 nextRunAtMs 排序
  const sorted = missed.toSorted((a, b) => 
    (a.state.nextRunAtMs ?? 0) - (b.state.nextRunAtMs ?? 0)
  );
  
  // 3. 限制并发（防止重启后瞬间负载过高）
  const startupCandidates = sorted.slice(0, maxImmediate);
  const deferred = sorted.slice(maxImmediate);
  // deferred 的 job 在正常调度循环中执行
  
  // 4. 串行执行（补跑不并行）
  for (const candidate of plan.candidates) {
    outcomes.push(await runStartupCatchupCandidate(state, candidate));
  }
}
```

### 5.5 卡住检测

```javascript
// 在每次 timer tick 中检查
if (typeof runningAt === "number" && nowMs - runningAt > STUCK_RUN_MS) {
  // 清除卡住的运行标记
  job.state.runningAtMs = undefined;
  // 允许 job 在下次 tick 中重新调度
}
```

### 5.6 调度计算错误

```javascript
// cron 表达式解析失败等
if (errorCount >= MAX_SCHEDULE_ERRORS) {  // 3 次
  job.enabled = false;   // 自动禁用
  enqueueSystemEvent(
    `⚠️ Cron job "${job.name}" has been auto-disabled after ${errorCount} errors`
  );
}
```

---

## 六、投递机制

### 6.1 三种投递模式

```
announce（默认）
──────────────────────────────
Agent 输出 → Channel Adapter → 目标频道/用户
           → Main session 简要通知
           
说明：
- 直接通过渠道适配器投递，不经过主 Agent
- HEARTBEAT_OK 类回复不投递
- 如果 Agent 已通过 message tool 发送到同一目标，跳过（防重复）
- 目标不存在 + bestEffort=false → job 失败


webhook
──────────────────────────────
Agent 输出 → HTTP POST → delivery.to (URL)
           
说明：
- 不做频道投递
- 不发主 session 通知
- Bearer token 认证（cron.webhookToken）


none
──────────────────────────────
Agent 输出 → 仅记录在 session transcript
           
说明：
- 不投递，不通知
- 适合纯后台任务（写文件、更新数据库等）
```

### 6.2 投递目标格式

| 频道 | 目标格式 | 示例 |
|------|---------|------|
| Telegram | chat_id 或 chat_id:topic:topic_id | `-1001234567890:topic:123` |
| WhatsApp | 电话号码 | `+15551234567` |
| Discord | `channel:<id>` 或 `user:<id>` | `channel:C1234567890` |
| Slack | `channel:<id>` 或 `user:<id>` | `channel:C1234567890` |

### 6.3 delivery 和 message tool 的互斥

```javascript
function resolveCronToolPolicy(params) {
  return {
    // 如果有 delivery，要求 message tool 指定明确目标
    requireExplicitMessageTarget: params.deliveryRequested 
      && params.resolvedDelivery.ok,
    // 如果 delivery 由 cron 系统负责，禁用 message tool
    disableMessageTool: params.deliveryContract === "cron-owned" 
      ? true 
      : params.deliveryRequested
  };
}
```

这避免了一个常见问题：Agent 在 cron 任务中自己用 `message` 工具发了消息，然后 cron 的 announce 又发了一遍。

---

## 七、Session 生命周期管理

### 7.1 Session 创建

```
独立 job 执行 → 创建 session entry:
  key: "<agentId>:cron:<jobId>:run:<uuid>"
  label: "Cron: <job name>"
  sessionId: uuid
  
基础 session key: "<agentId>:cron:<jobId>" （长期存在）
运行 session key: "<agentId>:cron:<jobId>:run:<uuid>" （临时）
```

### 7.2 Session Reaper（自动清理）

```javascript
// 默认保留 24 小时
const DEFAULT_RETENTION_MS = 24 * 3600 * 1000;

// 最小扫描间隔 5 分钟（避免频繁 IO）
const MIN_SWEEP_INTERVAL_MS = 5 * 60 * 1000;

async function sweepCronRunSessions(params) {
  // 1. 节流：距上次扫描不到 5 分钟则跳过
  if (now - lastSweepAtMs < MIN_SWEEP_INTERVAL_MS) return;
  
  // 2. 遍历 session store
  for (const key of Object.keys(store)) {
    // 只清理 run session（包含 :run: 的 key）
    if (!isCronRunSessionKey(key)) continue;
    
    // 3. 超过保留期的删除
    if ((entry.updatedAt ?? 0) < cutoff) {
      delete store[key];
      pruned++;
    }
  }
  
  // 4. 归档 transcript 文件
  archiveRemovedSessionTranscripts(...)
  
  // 5. 清理过期归档
  cleanupArchivedSessionTranscripts(...)
}
```

### 7.3 Run Log 裁剪

```javascript
// 每次 run 追加后检查文件大小
// 默认: maxBytes=2MB, keepLines=2000
// 超过 maxBytes → 只保留最新 keepLines 行
```

---

## 八、完整执行流程（时序图）

以一个典型的 isolated cron job 为例：

```
时间轴
──────────────────────────────────────────────────────────────

[T-60s]  armTimer() 设置 60s setTimeout
              │
[T-0s]   setTimeout 到期
              │
              ▼
         onTimer()
              │
              ├─ locked() 获取锁
              ├─ ensureLoaded(forceReload=true)  ← 重新从磁盘加载 jobs.json
              ├─ collectRunnableJobs(nowMs)       ← 找出 due 的 job
              │   └─ isRunnableJob(): enabled && !running && nowMs >= nextRunAtMs
              ├─ 标记 job.state.runningAtMs = now
              ├─ persist()                        ← 写盘（防止重启后重复执行）
              └─ 释放锁
              │
              ▼
         runDueJob()
              │
              ├─ emit("started")
              ├─ executeJobCoreWithTimeout()
              │   ├─ 如果有 timeoutSeconds → 设置 AbortController
              │   └─ executeJobCore()
              │       ├─ job.sessionTarget === "isolated"?
              │       │   └─ runIsolatedAgentJob()
              │       │       └─ runCronIsolatedAgentTurn()
              │       │           ├─ 解析 agentId、模型、thinking
              │       │           ├─ 创建 session entry
              │       │           ├─ 构建 prompt
              │       │           ├─ runEmbeddedPiAgent()  ← 实际 Agent 执行
              │       │           │   ├─ LLM API 调用
              │       │           │   ├─ 工具调用（web_search, exec, ...）
              │       │           │   └─ 生成回复
              │       │           ├─ 检查是否空回复 → 追加第二轮
              │       │           └─ 投递（announce/webhook/none）
              │       └─ 返回 { status, summary, sessionId }
              │
              ▼
         locked() 获取锁
              │
              ├─ ensureLoaded(forceReload=true)
              ├─ applyOutcomeToStoredJob()
              │   ├─ 更新 lastRunAtMs, lastStatus
              │   ├─ 清除 runningAtMs
              │   ├─ 如果成功: 清除 consecutiveErrors
              │   ├─ 如果失败: consecutiveErrors++, 计算退避
              │   ├─ 如果 at 类型成功: 禁用或删除
              │   └─ recomputeNextRunAtMs()
              ├─ persist()
              └─ 释放锁
              │
              ▼
         sweepCronRunSessions()  ← 清理过期 session
              │
              ▼
         armTimer()  ← 重新设置下一个 timer
```

---

## 九、配置参考

### 9.1 完整配置

```json5
{
  cron: {
    enabled: true,                       // 启用/禁用整个调度器
    store: "~/.openclaw/cron/jobs.json", // job store 路径
    maxConcurrentRuns: 1,                // 最大并发执行数
    
    retry: {
      maxAttempts: 3,                    // 一次性任务最大重试
      backoffMs: [60000, 120000, 300000], // 一次性任务退避
      retryOn: ["rate_limit", "overloaded", "network", "server_error"]
    },
    
    sessionRetention: "24h",             // 运行 session 保留时间
    
    runLog: {
      maxBytes: "2mb",                   // 运行日志最大大小
      keepLines: 2000                    // 裁剪后保留行数
    },
    
    webhookToken: "xxx",                 // webhook 认证 token
    
    failureAlert: {                      // 全局失败告警（可选）
      enabled: true,
      after: 3,                          // 连续失败 3 次后告警
      cooldownMs: 3600000,               // 告警冷却 1 小时
      channel: "telegram",
      to: "123456789"
    }
  }
}
```

### 9.2 环境变量

| 变量 | 说明 |
|------|------|
| `OPENCLAW_SKIP_CRON=1` | 禁用 cron 调度器 |

---

## 十、设计亮点与注意事项

### 10.1 设计亮点

| 设计 | 说明 |
|------|------|
| **事件驱动定时器** | 不轮询，用 setTimeout 精确唤醒，60s 最大间隔保证精度 |
| **确定性错峰** | SHA256(jobId) % staggerMs，同一 job 每次偏移相同 |
| **防空回复** | 自动检测 "on it" 类确认回复，追加第二轮 prompt |
| **delivery 互斥** | 配置了 announce 就禁用 message tool，防重复 |
| **写前标记** | 执行前先写 runningAtMs 到磁盘，防重启后重复执行 |
| **重启补跑** | Gateway 重启后自动检测并补跑错过的 job |
| **锁序安全** | session reaper 在 cron locked() 之外运行，避免死锁 |
| **owner 权限** | cron 任务以 `senderIsOwner: true` 运行，有完整工具访问 |

### 10.2 注意事项

| 事项 | 说明 |
|------|------|
| **单进程** | Cron 运行在 Gateway 进程内，Gateway 停了 cron 就停了 |
| **默认串行** | maxConcurrentRuns=1，多个 job 同时 due 会排队 |
| **独立 session 无历史** | 每次运行是空白上下文，不记得上次运行的内容 |
| **store 手动编辑需停 Gateway** | jobs.json 在内存中有副本，运行时编辑会被覆盖 |
| **stagger 不可预测** | 偏移由 jobId hash 决定，无法提前知道具体偏移量 |
| **at 类型默认删除** | 一次性任务成功后自动删除，需要 `deleteAfterRun: false` 保留 |
| **LLM 超时** | 默认使用 agent 级别超时，可通过 `timeoutSeconds` 覆盖 |


> 📝 研究完成于 2026-03-25，黄山 (wairesearch)
