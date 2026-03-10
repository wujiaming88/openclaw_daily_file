# OpenClaw Gateway 架构深度研究报告

> 研究员: 黄山 (wairesearch) | 日期: 2026-03-10

## 执行摘要

OpenClaw Gateway 是一个**单进程、事件驱动**的 AI Agent 运行时网关。它在一个进程内同时承载 WebSocket 控制面、HTTP API、多渠道消息连接、Agent 推理循环、插件系统和 Docker 沙箱编排。Gateway 是整个 OpenClaw 系统的**唯一中枢**——所有消息、所有 Agent 运行、所有工具调用都通过它路由和调度。

---

## 1. 架构全景

```
                    ┌─────────────────────────┐
                    │      外部世界            │
                    │                          │
                    │  WhatsApp  Telegram      │
                    │  Discord   Slack         │
                    │  Signal    iMessage      │
                    │  Google Chat  Teams      │
                    │  IRC  Matrix  Nostr ...  │
                    └─────────┬───────────────┘
                              │ 消息入站
                              ▼
┌──────────────────────────────────────────────────────────────┐
│                      Gateway Process                          │
│                     (单进程, 单端口)                           │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                  HTTP + WebSocket Server                  │ │
│  │                  (默认 127.0.0.1:18789)                  │ │
│  │                                                           │ │
│  │  WebSocket 端点:                                         │ │
│  │  ├── Operator 连接 (CLI/macOS/Web UI)                   │ │
│  │  └── Node 连接 (iOS/Android/Headless)                   │ │
│  │                                                           │ │
│  │  HTTP 端点:                                              │ │
│  │  ├── /v1/chat/completions (OpenAI 兼容)                 │ │
│  │  ├── /v1/responses (Responses API)                      │ │
│  │  ├── /__openclaw__/tools/invoke (工具调用)               │ │
│  │  ├── /__openclaw__/canvas/ (Canvas 宿主)                │ │
│  │  ├── /__openclaw__/a2ui/ (A2UI 宿主)                   │ │
│  │  ├── /hooks/* (Webhook 入口)                            │ │
│  │  ├── Control UI (配置管理界面)                           │ │
│  │  └── Plugin HTTP 路由                                   │ │
│  └──────────────────────┬──────────────────────────────────┘ │
│                         │                                     │
│  ┌──────────────────────┴──────────────────────────────────┐ │
│  │              Inbound Message Router                       │ │
│  │                                                           │ │
│  │  1. DM Policy 检查 (pairing/allowlist/open/disabled)    │ │
│  │  2. Group Policy 检查 (allowlist + mention gating)       │ │
│  │  3. Agent Binding 路由 (peer > guild > account > default)│ │
│  │  4. Session Key 解析                                     │ │
│  │  5. 消息入队                                             │ │
│  └──────────────────────┬──────────────────────────────────┘ │
│                         │                                     │
│  ┌──────────────────────┴──────────────────────────────────┐ │
│  │              Command Queue (多 Lane 调度)                 │ │
│  │                                                           │ │
│  │  ┌──────────┐  ┌──────────────┐  ┌─────────┐           │ │
│  │  │ main     │  │  subagent    │  │  cron   │           │ │
│  │  │ lane     │  │  lane        │  │  lane   │           │ │
│  │  │ (并发:4) │  │  (并发:8)    │  │         │           │ │
│  │  └────┬─────┘  └──────┬───────┘  └────┬────┘           │ │
│  │       │               │               │                  │ │
│  │  ┌────┴───────────────┴───────────────┴────┐            │ │
│  │  │      Per-Session Lane (并发:1)          │            │ │
│  │  │      保证同一 Session 串行执行          │            │ │
│  │  └─────────────────────┬───────────────────┘            │ │
│  └────────────────────────┼────────────────────────────────┘ │
│                           │                                   │
│  ┌────────────────────────┴────────────────────────────────┐ │
│  │                Agent Loop (推理循环)                      │ │
│  │                                                           │ │
│  │  Intake → Context Assembly → Model Inference              │ │
│  │    → Tool Execution → Streaming → Persistence             │ │
│  │                                                           │ │
│  │  ┌──────────────┐  ┌──────────┐  ┌─────────────────┐   │ │
│  │  │ System Prompt │  │  Model   │  │   Tool          │   │ │
│  │  │ Builder      │  │ Provider │  │   Execution     │   │ │
│  │  │              │  │ + Auth   │  │   Engine        │   │ │
│  │  │ SOUL.md      │  │ Profile  │  │                 │   │ │
│  │  │ AGENTS.md    │  │ Rotation │  │  Host / Sandbox │   │ │
│  │  │ Skills       │  │          │  │                 │   │ │
│  │  │ Bootstrap    │  │ Failover │  │  exec/read/     │   │ │
│  │  │ Plugin hooks │  │ Chain    │  │  write/browser  │   │ │
│  │  └──────────────┘  └──────────┘  └─────────────────┘   │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                               │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              支撑系统                                     │ │
│  │                                                           │ │
│  │  ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │ │
│  │  │  Plugin    │ │ Session  │ │ Memory   │ │ Sandbox  │ │ │
│  │  │  Registry  │ │ Store    │ │ Index    │ │ Manager  │ │ │
│  │  │  (jiti)    │ │ (JSON)   │ │ (SQLite) │ │ (Docker) │ │ │
│  │  └────────────┘ └──────────┘ └──────────┘ └──────────┘ │ │
│  │  ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │ │
│  │  │  Config    │ │ Cron     │ │ Heartbeat│ │ Hook     │ │ │
│  │  │  Watcher   │ │ Scheduler│ │ Timer    │ │ Manager  │ │ │
│  │  │  (热重载)  │ │          │ │          │ │          │ │ │
│  │  └────────────┘ └──────────┘ └──────────┘ └──────────┘ │ │
│  └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

---

## 2. WebSocket 协议层

### 2.1 连接握手流程

```
Client                              Gateway
  │                                    │
  │  ← event:connect.challenge ────── │  (nonce + timestamp)
  │                                    │
  │ ── req:connect ──────────────────> │
  │    minProtocol: 3                  │
  │    maxProtocol: 3                  │
  │    role: "operator" | "node"       │
  │    scopes: [...]                   │
  │    auth: { token: "..." }          │
  │    device: {                       │
  │      id, publicKey,                │
  │      signature (v3: 绑定           │
  │        platform + deviceFamily),   │
  │      nonce                         │
  │    }                               │
  │                                    │
  │  ← res:hello-ok ─────────────────  │
  │    protocol: 3                     │
  │    policy: { tickIntervalMs }      │
  │    snapshot: { presence, health }  │
  │    auth: { deviceToken? }          │
  │                                    │
  │  ← event:presence ───────────────  │
  │  ← event:tick ───────────────────  │
  │                                    │
  │  正常通信...                        │
```

### 2.2 帧类型

| 类型 | 方向 | 格式 |
|------|------|------|
| `req` | Client → Gateway | `{ type:"req", id, method, params }` |
| `res` | Gateway → Client | `{ type:"res", id, ok, payload\|error }` |
| `event` | Gateway → Client | `{ type:"event", event, payload, seq?, stateVersion? }` |

### 2.3 核心 RPC 方法

| 方法 | 作用 |
|------|------|
| `connect` | 握手 + 认证 |
| `agent` | 启动 Agent 运行 |
| `agent.wait` | 等待运行完成 |
| `chat.send` | 发送消息 |
| `chat.history` | 获取聊天历史 |
| `health` | 健康检查 |
| `status` | 系统状态 |
| `config.get/apply/patch` | 配置管理 |
| `sessions.*` | Session 管理 |
| `secrets.resolve` | 密钥解析 |

### 2.4 设备配对与信任

```
新设备首次连接
    │
    ├── 本地连接 (loopback/tailnet) → 可自动批准
    │
    └── 远程连接 → 需要显式批准
         │
         ▼
    配对批准后颁发 deviceToken
    后续连接使用 token + 签名验证
    签名 v3 绑定 platform + deviceFamily
    元数据变更需要重新配对
```

---

## 3. 多 Lane 队列调度系统

这是 Gateway 最核心的调度引擎之一。

### 3.1 双层队列架构

```
入站消息到达
    │
    ▼
┌──────────────────────────────────────────┐
│  Layer 1: Per-Session Lane               │
│  并发: 1（同一 Session 严格串行）         │
│                                           │
│  session:agent:main:whatsapp:dm:+1555... │
│  session:agent:main:telegram:dm:123...   │
│  session:agent:coding:subagent:uuid...   │
│  session:cron:daily-report               │
└──────────────────────┬───────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────┐
│  Layer 2: Global Lane (并发控制)          │
│                                           │
│  ┌─────────┐  ┌──────────┐  ┌─────────┐ │
│  │  main   │  │ subagent │  │  cron   │ │
│  │  并发:4 │  │  并发:8  │  │  独立   │ │
│  └─────────┘  └──────────┘  └─────────┘ │
│                                           │
│  main lane 的并发由                       │
│  agents.defaults.maxConcurrent 控制       │
└──────────────────────────────────────────┘
```

### 3.2 消息队列模式

| 模式 | 行为 |
|------|------|
| `collect`（默认） | 合并等待中的消息为单次 followup |
| `steer` | 注入当前运行中（工具边界后生效） |
| `followup` | 当前运行完成后排队执行 |
| `steer-backlog` | steer + 保留消息供 followup |
| `interrupt`（旧版） | 中止当前运行，执行最新消息 |

### 3.3 队列溢出策略

```json5
messages: {
  queue: {
    mode: "collect",
    debounceMs: 1000,    // 等待安静期
    cap: 20,             // 队列上限
    drop: "summarize"    // 溢出策略: old | new | summarize
  }
}
```

`summarize` 模式会将被丢弃的消息生成要点列表，作为合成 prompt 注入。

---

## 4. Agent Loop（推理循环）

### 4.1 完整生命周期

```
用户消息
    │
    ▼
┌─ 1. Intake ─────────────────────────────────────┐
│  · 验证参数                                       │
│  · 解析 Session (sessionKey/sessionId)            │
│  · 持久化 Session 元数据                          │
│  · 返回 { runId, acceptedAt }（立即响应）         │
└──────────────────────┬───────────────────────────┘
                       │
                       ▼
┌─ 2. Context Assembly ───────────────────────────┐
│  · 解析工作区 + 创建 Skills 快照                  │
│  · 构建 System Prompt:                            │
│    ├── 基础 prompt                                │
│    ├── SOUL.md / AGENTS.md / IDENTITY.md          │
│    ├── USER.md / TOOLS.md / BOOTSTRAP.md          │
│    ├── Skills prompt                              │
│    └── Plugin hooks (before_prompt_build)         │
│  · 加载 Session 历史                              │
│  · 检查上下文窗口 + 预压缩记忆刷写               │
│  · 获取写锁 + 打开 SessionManager                │
└──────────────────────┬───────────────────────────┘
                       │
                       ▼
┌─ 3. Model Resolution ──────────────────────────┐
│  · Plugin hook: before_model_resolve             │
│  · 解析 Auth Profile（OAuth > API Key）          │
│  · Session 粘性：同 Session 复用 Auth Profile    │
│  · 如失败 → Auth Profile 轮转                    │
│  · 如全部失败 → Model Fallback 链               │
└──────────────────────┬──────────────────────────┘
                       │
                       ▼
┌─ 4. Model Inference ───────────────────────────┐
│  · pi-agent-core 运行时                          │
│  · 流式输出 assistant delta 事件                 │
│  · 超时控制（默认 600s）                         │
│  · AbortSignal 支持取消                          │
└──────────────────────┬──────────────────────────┘
                       │
                       ▼
┌─ 5. Tool Execution ────────────────────────────┐
│  · Plugin hook: before_tool_call                 │
│  · 工具策略检查 (allow/deny)                     │
│  · 执行位置:                                     │
│    ├── 主机直接执行（sandbox off）               │
│    ├── Docker 容器执行（sandbox on）             │
│    └── Elevated 主机执行（绕过沙箱）             │
│  · Plugin hook: after_tool_call                  │
│  · 结果大小裁剪 + 图片处理                      │
│  · 回到 Model Inference（循环直到完成）          │
└──────────────────────┬──────────────────────────┘
                       │
                       ▼
┌─ 6. Streaming + Reply ─────────────────────────┐
│  · Block Streaming: 按块发送（text_end/message_end）│
│  · Preview Streaming: 预览消息实时更新            │
│  · 人类节奏模拟（humanDelay, 可选）              │
│  · NO_REPLY 过滤                                  │
│  · 消息工具去重                                   │
└──────────────────────┬──────────────────────────┘
                       │
                       ▼
┌─ 7. Persistence ───────────────────────────────┐
│  · 写入 Transcript JSONL（追加式）               │
│  · 更新 sessions.json 元数据                     │
│  · Plugin hooks: agent_end                       │
│  · 自动压缩检查                                  │
│  · 记忆索引同步（后台异步）                      │
└─────────────────────────────────────────────────┘
```

### 4.2 两阶段响应

Agent 运行是**异步**的：

```
Client → req:agent(message)
    ↓
Gateway → res:agent { runId, status: "accepted" }   ← 立即返回
    ↓
Gateway → event:agent(stream: "assistant", delta)    ← 流式推送
Gateway → event:agent(stream: "tool", event)         ← 工具事件
    ↓
Gateway → event:agent(stream: "lifecycle", "end")    ← 最终完成
```

---

## 5. 多端口复用

Gateway 在**同一个端口**上同时服务：

```
:18789
  ├── WebSocket (ws://)
  │   ├── Operator 连接
  │   └── Node 连接
  │
  ├── HTTP API
  │   ├── POST /v1/chat/completions    ← OpenAI 兼容
  │   ├── POST /v1/responses           ← Responses API
  │   ├── POST /__openclaw__/tools/invoke ← 工具调用
  │   └── POST /hooks/*                ← Webhook
  │
  ├── Static Assets
  │   ├── /__openclaw__/canvas/        ← Canvas 宿主
  │   ├── /__openclaw__/a2ui/          ← A2UI
  │   └── Control UI                   ← 管理界面
  │
  └── Plugin 注册的自定义路由
```

---

## 6. 沙箱编排

### 6.1 三种粒度

```
sandbox.scope:

"session"  → 每个 Session 独立容器
             ┌───────────┐ ┌───────────┐ ┌───────────┐
             │ Session A │ │ Session B │ │ Session C │
             │ Container │ │ Container │ │ Container │
             └───────────┘ └───────────┘ └───────────┘

"agent"    → 每个 Agent 一个容器
             ┌─────────────────────────┐ ┌──────────────┐
             │ Agent: main             │ │ Agent: work  │
             │ (所有 main session 共享)│ │              │
             └─────────────────────────┘ └──────────────┘

"shared"   → 所有沙箱 Session 共享一个容器
             ┌─────────────────────────────────────┐
             │          Shared Container            │
             │  (所有 Agent 的所有 Session)          │
             └─────────────────────────────────────┘
```

### 6.2 工作区访问模式

| 模式 | 挂载 | 可写工具 |
|------|------|---------|
| `none`（默认） | 沙箱隔离工作区 | ✅ 沙箱内 |
| `ro` | 主机工作区只读挂载 `/agent` | ❌ 禁用 write/edit |
| `rw` | 主机工作区读写挂载 `/workspace` | ✅ 主机文件 |

---

## 7. 配置热重载

### 7.1 重载模式

```
文件变更 (watcher, debounce 300ms)
    │
    ▼
┌──────────────────────────────────┐
│  hybrid 模式（默认）              │
│                                   │
│  安全变更? ──Yes──> 热应用        │
│      │                            │
│      No                           │
│      │                            │
│      ▼                            │
│  自动重启 Gateway                 │
└──────────────────────────────────┘
```

### 7.2 热应用 vs 需要重启

| 可热应用（无停机） | 需要重启 |
|-------------------|----------|
| channels.* | gateway.* (端口/绑定/认证/TLS) |
| agents.* / models.* | discovery |
| hooks / cron | plugins |
| session / messages | canvasHost |
| tools / browser / skills | |
| ui / logging / bindings | |

---

## 8. 安全架构

### 8.1 安全模型

```
┌─────────────────────────────────────────────────┐
│          个人助手信任模型                          │
│                                                   │
│  一个 Gateway = 一个信任边界 = 一个操作者         │
│                                                   │
│  ⚠️ 不是多租户安全边界                            │
│  ⚠️ 多用户 → 多 Gateway（独立主机/用户）          │
│                                                   │
│  ┌──────────────────────────────────────────┐    │
│  │ Layer 1: 网络绑定                         │    │
│  │   默认 loopback (127.0.0.1)               │    │
│  │   非本地绑定必须配置认证                  │    │
│  ├──────────────────────────────────────────┤    │
│  │ Layer 2: Gateway 认证                     │    │
│  │   Token / Password + Rate Limit           │    │
│  ├──────────────────────────────────────────┤    │
│  │ Layer 3: 设备配对                         │    │
│  │   Challenge-Response + 签名验证           │    │
│  │   设备元数据绑定 (platform+deviceFamily)  │    │
│  ├──────────────────────────────────────────┤    │
│  │ Layer 4: 渠道访问控制                     │    │
│  │   DM Policy (pairing/allowlist/open)      │    │
│  │   Group Policy + Mention Gating           │    │
│  ├──────────────────────────────────────────┤    │
│  │ Layer 5: 工具策略                         │    │
│  │   allow/deny 列表 (global→agent→sandbox)  │    │
│  │   Elevated 白名单                         │    │
│  ├──────────────────────────────────────────┤    │
│  │ Layer 6: 沙箱隔离                         │    │
│  │   Docker 容器化工具执行                   │    │
│  └──────────────────────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

### 8.2 认证速率限制

```
连续认证失败 → 速率限制 → 429 + Retry-After
配置 RPC 写操作 → 3次/60秒/设备 → UNAVAILABLE + retryAfterMs
```

---

## 9. Model Failover 机制

```
请求到达
    │
    ▼
┌── Stage 1: Auth Profile 轮转 ──────────────────┐
│                                                   │
│  选择顺序:                                        │
│  1. 显式配置 auth.order[provider]                │
│  2. 配置的 profiles                              │
│  3. 存储的 profiles                              │
│                                                   │
│  同 provider 内轮转:                              │
│  · OAuth 优先于 API Key                          │
│  · 最久未用优先（round-robin）                   │
│  · Session 粘性（复用直到失败/冷却/过期）        │
│                                                   │
│  失败处理:                                        │
│  · 冷却期 → 移到队尾                             │
│  · 所有 profile 失败 → 进入 Stage 2              │
└──────────────────────┬───────────────────────────┘
                       │ 全部失败
                       ▼
┌── Stage 2: Model Fallback 链 ──────────────────┐
│                                                   │
│  agents.defaults.model:                          │
│    primary: "anthropic/claude-sonnet-4-5"        │
│    fallbacks: ["openai/gpt-5.2"]                 │
│                                                   │
│  Primary 全部 profile 失败                       │
│  → 尝试 fallbacks[0] 的所有 profile              │
│  → 尝试 fallbacks[1] ...                         │
│  → 全部失败 → 返回错误                           │
└─────────────────────────────────────────────────┘
```

---

## 10. 流式传输双层架构

```
Model 输出 (token deltas)
    │
    ├─── Layer 1: Block Streaming (渠道消息) ────────────┐
    │    · 按块发送实际渠道消息                           │
    │    · EmbeddedBlockChunker:                          │
    │      min/maxChars + breakPreference                 │
    │      (paragraph > newline > sentence > whitespace)  │
    │    · 代码围栏感知：不在围栏内断裂                   │
    │    · Coalescing: 合并短块，减少消息碎片             │
    │    · Human Delay: 随机暂停模拟人类节奏              │
    │                                                     │
    ├─── Layer 2: Preview Streaming (实时预览) ──────────┐
    │    · 临时预览消息 + 编辑更新                        │
    │    · Telegram: sendMessage + editMessageText        │
    │    · Discord: send + edit                           │
    │    · Slack: native streaming API                    │
    │    · 模式: off / partial / block / progress         │
    │                                                     │
    └─── 两层互斥: block streaming 开启时跳过 preview    │
```

---

## 11. 持久化双层架构

```
~/.openclaw/agents/<agentId>/sessions/
├── sessions.json           ← Layer 1: 元数据存储
│   · Session Key → Entry 映射
│   · 小型、可变、可安全编辑/删除
│   · 追踪: sessionId, 最后活跃, toggles,
│     token 计数, thinking/verbose 级别
│   · 维护: pruneAfter(30d), maxEntries(500),
│     rotateBytes(10mb), maxDiskBytes
│
└── <sessionId>.jsonl       ← Layer 2: 对话 Transcript
    · 追加式、树形结构 (id + parentId)
    · 存储: 对话 + 工具调用 + 压缩摘要
    · 用于重建模型上下文
    · 不可直接编辑（由系统管理）
```

---

## 12. 自动化子系统

### 12.1 Heartbeat

```json5
agents: {
  defaults: {
    heartbeat: {
      every: "30m",        // 检查间隔
      target: "last",      // 投递目标
      directPolicy: "allow"
    }
  }
}
```

Gateway 定期触发 Agent 运行，Agent 检查 `HEARTBEAT.md` 中的任务。

### 12.2 Cron

```json5
cron: {
  enabled: true,
  maxConcurrentRuns: 2,    // 独立 lane，不阻塞 main
  sessionRetention: "24h"  // 自动清理完成的 session
}
```

### 12.3 Hooks

```json5
hooks: {
  enabled: true,
  token: "shared-secret",
  path: "/hooks",
  mappings: [{
    match: { path: "gmail" },
    action: "agent",
    agentId: "main",
    deliver: true
  }]
}
```

---

## 13. 设计亮点总结

| 设计原则 | 实现方式 |
|----------|----------|
| **单进程全能** | 一个进程 = WS + HTTP + 所有渠道 + Agent + 工具 + 插件 |
| **单端口复用** | WebSocket + HTTP API + UI + Canvas 共用一个端口 |
| **双层队列** | Per-Session 串行 + Global Lane 并发控制 = 安全 + 高效 |
| **两阶段响应** | 立即 accepted + 异步流式推送 = 永不阻塞客户端 |
| **热重载** | hybrid 模式自动判断热应用 vs 重启 = 零停机配置变更 |
| **优雅降级** | Auth 轮转 → Model Fallback → 错误返回 = 最大可用性 |
| **个人助手信任** | 一个 Gateway = 一个信任边界，简单但明确的安全模型 |
| **沙箱三粒度** | session/agent/shared 按需选择隔离级别 |
| **流式双层** | Block Streaming（消息）+ Preview Streaming（预览）互斥 |
| **插件进程内** | jiti 加载 TypeScript，零 IPC 开销，9 种扩展点 |

---

## 参考来源

1. OpenClaw 文档 — `docs/concepts/architecture.md`
2. OpenClaw 文档 — `docs/gateway/index.md` (Gateway Runbook)
3. OpenClaw 文档 — `docs/gateway/configuration.md`
4. OpenClaw 文档 — `docs/gateway/protocol.md` (WebSocket 协议)
5. OpenClaw 文档 — `docs/concepts/queue.md` (Command Queue)
6. OpenClaw 文档 — `docs/concepts/agent-loop.md` (Agent Loop)
7. OpenClaw 文档 — `docs/gateway/sandboxing.md`
8. OpenClaw 文档 — `docs/concepts/streaming.md`
9. OpenClaw 文档 — `docs/gateway/openai-http-api.md`
10. OpenClaw 文档 — `docs/gateway/security/index.md`
11. OpenClaw 文档 — `docs/concepts/model-failover.md`
12. OpenClaw 文档 — `docs/gateway/health.md`
13. 源码类型 — `dist/plugin-sdk/gateway/` (协议、认证、调度模块)
