# 研究报告：OpenClaw Session 架构设计全景解析

> 研究员：黄山 (wairesearch) · 日期：2026-03-16

## 执行摘要

Session 是 OpenClaw 的**核心状态载体**——它将无状态的 LLM 变成有状态的持久助手。本报告从架构设计、数据模型、生命周期、管理机制、上下文优化五个维度，对 OpenClaw Session 系统进行全面解析。

核心结论：OpenClaw 采用**单 Gateway 进程拥有所有 Session 状态**的中心化设计，通过 SessionKey 路由 + SessionId 指向 JSONL Transcript 的双层模型，实现了跨渠道对话连续性、自动压缩、记忆持久化和多 Agent 隔离。

---

## 1. 架构概览

### 1.1 三层架构中的 Session 位置

```
┌─────────────────────────────────────────────────┐
│        Messaging Surfaces (消息表面层)            │
│  WhatsApp · Telegram · Discord · Slack · Signal  │
└────────────────────┬────────────────────────────┘
                     │ 入站消息
                     ▼
┌─────────────────────────────────────────────────┐
│             Gateway (网关层)                      │
│  ┌──────────┐  ┌─────────────┐  ┌────────────┐  │
│  │ Channel  │  │  Session    │  │  Command   │  │
│  │ Bridges  │→ │  Manager   │→ │  Queue     │  │
│  └──────────┘  └─────────────┘  └────────────┘  │
│                       ↕                          │
│              sessions.json (状态)                 │
│              *.jsonl (Transcript)                 │
└────────────────────┬────────────────────────────┘
                     │ 序列化后的 Agent 运行
                     ▼
┌─────────────────────────────────────────────────┐
│          Agent Runtime (运行时层)                 │
│  Prompt Assembly → LLM → Tool Execution → Reply  │
└─────────────────────────────────────────────────┘
```

### 1.2 核心设计原则

| 原则 | 说明 |
|------|------|
| **单一数据源** | Gateway 是唯一 Session 状态拥有者，UI 客户端必须查询 Gateway |
| **双层持久化** | sessions.json（元数据）+ JSONL（对话记录）分离 |
| **路由-隔离分离** | SessionKey 负责路由，SessionId 负责隔离 |
| **渠道无关** | 同一个 Session 可以跨 WhatsApp/Telegram/Discord 连续对话 |
| **进程内队列** | 无外部依赖的纯 TypeScript 序列化，保证每 Session 同时只有一个 Agent 运行 |

---

## 2. 数据模型

### 2.1 SessionKey（会话键）—— 路由标识

SessionKey 是逻辑标识，决定"这条消息属于哪个对话桶"。

```
# 直接聊天 (DM)
agent:<agentId>:main                                    # dmScope=main (默认)
agent:<agentId>:dm:<peerId>                             # dmScope=per-peer
agent:<agentId>:<channel>:dm:<peerId>                   # dmScope=per-channel-peer
agent:<agentId>:<channel>:<accountId>:dm:<peerId>       # dmScope=per-account-channel-peer

# 群组聊天
agent:<agentId>:<channel>:group:<id>                    # 普通群组
agent:<agentId>:<channel>:group:<id>:topic:<threadId>   # Telegram 论坛话题

# 其他
cron:<job.id>                                           # 定时任务
hook:<uuid>                                             # Webhook
agent:<agentId>:subagent:<uuid>                         # 子 Agent
agent:<agentId>:subagent:<uuid>:subagent:<uuid>         # 嵌套子 Agent (depth 2)
```

**DM 路由策略 (`session.dmScope`)**：

| 策略 | 行为 | 适用场景 |
|------|------|----------|
| `main` | 所有 DM 共享一个 Session | 个人使用，跨设备连续 |
| `per-peer` | 按发送者隔离 | 多用户但跨渠道统一 |
| `per-channel-peer` | 按渠道+发送者隔离 | 多用户收件箱（推荐） |
| `per-account-channel-peer` | 按账户+渠道+发送者隔离 | 多账户多用户 |

**跨渠道身份链接**：

```json5
{
  session: {
    identityLinks: {
      alice: ["telegram:123456789", "discord:987654321012345678"]
    }
  }
}
```

这使得同一个人在 Telegram 和 Discord 上共享同一个 DM Session。

### 2.2 SessionId（会话ID）—— 物理标识

每个 SessionKey 指向一个当前 SessionId，对应一个 JSONL Transcript 文件。

```
SessionKey: agent:main:main
  └── SessionId: abc123-def456 
       └── 文件: ~/.openclaw/agents/main/sessions/abc123-def456.jsonl
```

**SessionKey 和 SessionId 的关系**：
- SessionKey 是稳定的路由地址（不变）
- SessionId 在每次重置时重新生成（/new、每日重置、空闲过期）
- 一个 SessionKey 在其生命周期内可以有多个 SessionId

### 2.3 SessionEntry（会话条目）—— 元数据模型

存储在 `sessions.json` 中，是 Session 的运行时状态快照：

```typescript
type SessionEntry = {
  // 标识
  sessionId: string;              // 当前 Transcript 文件 ID
  sessionFile?: string;           // 可选的显式文件路径覆盖
  
  // 时间
  updatedAt: number;              // 最后活动时间戳
  
  // 元数据
  chatType: "direct" | "group" | "room";
  provider?: string;              // 渠道提供商
  subject?: string;               // 群组主题
  displayName?: string;           // 显示名称
  room?: string;                  // 房间名
  space?: string;                 // 空间名
  
  // 来源追踪
  origin?: {
    label: string;                // 人类可读标签
    provider: string;             // 渠道 ID
    from: string;                 // 入站路由 ID
    to: string;                   // 出站路由 ID
    accountId?: string;           // 多账户时的账户 ID
    threadId?: string | number;   // 线程/话题 ID
  };
  
  // 开关
  thinkingLevel?: string;
  verboseLevel?: string;
  reasoningLevel?: string;
  elevatedLevel?: string;
  sendPolicy?: "allow" | "deny";
  
  // 模型选择
  providerOverride?: string;
  modelOverride?: string;
  authProfileOverride?: string;
  
  // Token 统计
  inputTokens?: number;
  outputTokens?: number;
  totalTokens?: number;
  contextTokens?: number;
  
  // 压缩状态
  compactionCount?: number;
  memoryFlushAt?: number;
  memoryFlushCompactionCount?: number;
  
  // 路由
  lastChannel?: string;
  lastTo?: string;
};
```

### 2.4 Transcript（对话记录）—— JSONL 树形结构

Transcript 是 Session 的完整历史，使用 JSONL 格式，具有**树形结构**：

```jsonl
// 第一行：Session 头
{"type":"session","id":"abc123","cwd":"/workspace","timestamp":1710000000}

// 后续行：树形条目 (id + parentId)
{"type":"message","id":"e1","parentId":null,"message":{"role":"user","content":"你好"}}
{"type":"message","id":"e2","parentId":"e1","message":{"role":"assistant","content":"你好！"}}
{"type":"message","id":"e3","parentId":"e2","message":{"role":"user","content":"帮我写代码"}}
{"type":"message","id":"e4","parentId":"e3","message":{"role":"toolResult","toolCallId":"tc1","content":"..."}}
{"type":"compaction","id":"e5","parentId":"e4","summary":"...","firstKeptEntryId":"e3","tokensBefore":45000}
{"type":"custom_message","id":"e6","parentId":"e5","customType":"openclaw.sessions_yield","content":"...","display":false}
```

**条目类型**：

| 类型 | 说明 | 进入模型上下文? |
|------|------|----------------|
| `message` | 用户/助手/工具结果消息 | ✅ |
| `custom_message` | 扩展注入的消息 | ✅（可以对 UI 隐藏） |
| `custom` | 扩展状态 | ❌ |
| `compaction` | 压缩摘要 | ✅（替代旧消息） |
| `branch_summary` | 分支摘要 | ✅ |

---

## 3. 生命周期

### 3.1 完整生命周期图

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  创建        │───▶│  活跃使用     │───▶│  上下文管理   │───▶│  过期/重置    │
│ (首条消息)   │    │ (对话+工具)   │    │ (剪枝+压缩)  │    │ (新 SessionId)│
└─────────────┘    └──────┬───────┘    └──────┬───────┘    └──────────────┘
                          │                    │
                   ┌──────▼───────┐    ┌──────▼───────┐
                   │  队列管理     │    │  记忆刷新     │
                   │ (序列化运行)  │    │ (压缩前写盘)  │
                   └──────────────┘    └──────────────┘
```

### 3.2 创建阶段

**触发**：入站消息到达，SessionKey 解析后没有找到有效的 SessionId。

**流程**：
1. Channel Bridge 归一化消息（发送者、内容、附件、线程上下文）
2. Session Manager 根据 `dmScope` 规则解析 SessionKey
3. 检查 sessions.json 中是否有该 Key 的有效 Entry
4. 如果不存在或已过期 → 创建新的 SessionId + Transcript 文件
5. 写入 Session 头到 JSONL

**实现位置**: `src/auto-reply/reply/session.ts` → `initSessionState()`

### 3.3 活跃使用阶段

**Agent 循环 (Agent Loop)** 是核心执行路径：

```
入站消息 → Command Queue 序列化 → Prompt Assembly → LLM 推理 → 工具执行 → 流式回复 → 持久化
```

**命令队列（Command Queue）保证**：
- **每个 SessionKey 同一时间只有一个 Agent 运行**（session lane, concurrency=1）
- 全局并发上限由 `agents.defaults.maxConcurrent`（默认 4）控制
- 子 Agent 通道独立（concurrency=8）
- Cron 通道独立，不阻塞入站

**队列模式**：

| 模式 | 行为 |
|------|------|
| `collect`（默认） | 合并排队消息为单个后续轮次 |
| `steer` | 注入当前运行，取消待执行工具调用 |
| `followup` | 等待当前运行结束后排队 |
| `steer-backlog` | 引导当前运行 + 保留后续 |

### 3.4 上下文管理阶段

当对话累积到接近上下文窗口时，触发两级优化：

**第一级：Session 剪枝（Pruning）—— 临时、非破坏性**
```
触发: 每次 LLM 调用前
范围: 仅修剪旧的 toolResult 消息（用户/助手消息永不修剪）
持久化: ❌ 仅内存中操作，不重写 JSONL
模式: cache-ttl（Anthropic 缓存 TTL 感知）
策略: 
  - 软修剪: 大工具结果保留头尾 + 省略号（>4000 chars）
  - 硬清除: 用 "[Old tool result content cleared]" 替换
保护: 最后 3 个 assistant 消息之后的工具结果不剪枝
```

**第二级：压缩（Compaction）—— 持久化**
```
触发: contextTokens > contextWindow - reserveTokens
行为: 较旧对话总结为紧凑摘要条目
持久化: ✅ 写入 JSONL
效果: 未来回合 = [压缩摘要] + [最近消息]
```

**压缩前记忆刷新**：
```
Session 接近压缩阈值
  → 触发静默 Agent 轮次
  → 模型将重要上下文写入 memory/YYYY-MM-DD.md
  → 模型回复 NO_REPLY（用户不可见）
  → 压缩安全进行（重要信息已落盘）
```

配置：
```json5
{
  agents: {
    defaults: {
      compaction: {
        reserveTokensFloor: 20000,
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 4000,
          prompt: "Write any lasting notes to memory/; reply with NO_REPLY"
        }
      }
    }
  }
}
```

### 3.5 过期与重置阶段

**三种过期机制**：

| 机制 | 触发条件 | 默认值 |
|------|----------|--------|
| **每日重置** | 上次更新早于最近的凌晨重置时间 | 凌晨 4:00（Gateway 本地时间） |
| **空闲重置** | 超过 idleMinutes 无活动 | 关闭（可选） |
| **手动重置** | `/new` 或 `/reset` 命令 | 随时可用 |

当同时配置每日和空闲重置时，**先到者**触发新 Session。

**按类型覆盖**：
```json5
{
  session: {
    reset: { mode: "daily", atHour: 4, idleMinutes: 120 },
    resetByType: {
      dm: { mode: "idle", idleMinutes: 240 },
      group: { mode: "idle", idleMinutes: 120 },
      thread: { mode: "daily", atHour: 4 }
    },
    resetByChannel: {
      discord: { mode: "idle", idleMinutes: 10080 }  // 7 天
    }
  }
}
```

**重置效果**：
- 为该 SessionKey 生成新的 SessionId
- 旧 Transcript 文件保留在磁盘上
- sessions.json 中的 Entry 更新为新 SessionId
- Token 计数器清零

### 3.6 子 Agent Session 生命周期

```
Main Session
  ├── sessions_spawn("研究任务") 
  │     └── agent:<agentId>:subagent:<uuid>
  │           ├── 独立 SessionId + Transcript
  │           ├── 独立上下文窗口 + Token
  │           ├── 受限工具集（无 session 工具）
  │           ├── 完成后 → announce 结果回主 Session
  │           └── archiveAfterMinutes（默认 60）后自动归档
  │
  └── sessions_yield("等待结果")
        → 结束当前轮次，释放资源
        → 子 Agent announce 唤醒后继续
```

**嵌套层级**：

| 深度 | Session Key 模式 | 角色 | 可以 spawn? |
|------|------------------|------|------------|
| 0 | `agent:<id>:main` | 主 Agent | 总是 |
| 1 | `agent:<id>:subagent:<uuid>` | 编排者/工作者 | 仅当 maxSpawnDepth≥2 |
| 2 | `agent:<id>:subagent:<uuid>:subagent:<uuid>` | 叶子工作者 | 永不 |

---

## 4. 管理机制

### 4.1 发送策略（Send Policy）

按渠道/聊天类型阻止投递：

```json5
{
  session: {
    sendPolicy: {
      rules: [
        { action: "deny", match: { channel: "discord", chatType: "group" } },
        { action: "deny", match: { keyPrefix: "cron:" } }
      ],
      default: "allow"
    }
  }
}
```

运行时覆盖（仅所有者）：`/send on` | `/send off` | `/send inherit`

### 4.2 工具策略（Tool Policy）

Session 中可用的工具由多层策略决定：

```
全局 profile → 每 Agent profile → 全局 deny → 每 Agent deny 
  → 全局 allow → 每 Agent allow → Provider 策略 → 默认
```

| Profile | 包含工具 |
|---------|----------|
| `minimal` | 仅 session_status |
| `coding` | 文件、运行时、会话、记忆、image |
| `messaging` | message、sessions_list/history/send、session_status |
| `full` | 无限制 |

### 4.3 沙箱隔离

沙箱 Session 的可见性控制：

```json5
{
  agents: {
    defaults: {
      sandbox: {
        sessionToolsVisibility: "spawned"  // 或 "all"
      }
    }
  }
}
```

- `spawned`（默认）：只能看到自己 spawn 的子 Session
- `all`：可以看到所有 Session

### 4.4 监控与诊断

| 命令 | 用途 |
|------|------|
| `/status` | 当前 Session 状态（Token、模型、开关） |
| `/context list` | 上下文组成和大小 |
| `/context detail` | 详细分解（每个工具 schema 大小等） |
| `/compact` | 手动压缩 |
| `/new` / `/reset` | 重置 Session |
| `/stop` | 中止当前运行 + 停止子 Agent |
| `openclaw status` | CLI 查看所有 Session |
| `openclaw sessions --json` | 导出 Session 列表 |

### 4.5 Transcript 清理（Hygiene）

在每次 LLM 调用前，按提供商应用内存中修正：

| 提供商 | 修正内容 |
|--------|----------|
| OpenAI | 仅图片清理 |
| Google/Gemini | 工具调用 ID 清理 + 结果配对 + 轮次排序 |
| Anthropic | 结果配对 + 连续用户轮次合并 |
| Mistral | 工具调用 ID 严格规范（9字符字母数字） |

这些修正**仅在内存中**，不重写磁盘 Transcript。

---

## 5. 磁盘布局

```
~/.openclaw/
├── openclaw.json                           ← 配置文件
├── agents/
│   └── <agentId>/
│       ├── sessions/
│       │   ├── sessions.json               ← SessionKey → Entry 映射
│       │   ├── <sessionId>.jsonl           ← Transcript 文件
│       │   ├── <sessionId>-topic-<threadId>.jsonl  ← Telegram 话题
│       │   └── <sessionId>.deleted.<ts>    ← 归档的子 Agent Transcript
│       └── auth/                           ← 认证 profiles
├── workspace/                              ← 默认工作空间
│   ├── MEMORY.md                           ← 长期记忆
│   ├── memory/
│   │   └── YYYY-MM-DD.md                   ← 每日记忆
│   ├── SOUL.md                             ← 人格
│   ├── AGENTS.md                           ← 操作指令
│   └── ...
└── memory/
    └── <agentId>.sqlite                    ← 向量记忆索引
```

---

## 6. 架构亮点与设计权衡

### 6.1 亮点

| 设计决策 | 好处 |
|----------|------|
| **单 Gateway 拥有所有状态** | 无分布式一致性问题，简单可靠 |
| **JSONL 树形结构** | 仅追加写入，天然支持分支和压缩 |
| **SessionKey 路由规则可配** | 同一套代码支持个人用、多用户收件箱、群组 |
| **双层优化（剪枝+压缩）** | 临时优化不丢数据，持久优化有摘要 |
| **压缩前记忆刷新** | 不丢失关键上下文，自动化记忆管理 |
| **进程内队列无外部依赖** | 部署简单，无 Redis/RabbitMQ 等依赖 |
| **渠道无关设计** | DM 可跨渠道连续对话 |

### 6.2 权衡

| 权衡 | 说明 |
|------|------|
| **单进程限制** | Gateway 重启会丢失排队任务和子 Agent 的 announce |
| **文件系统存储** | 不适合超大规模部署，但对自托管场景足够 |
| **无分布式** | 不能水平扩展 Gateway（一个主机一个 Gateway） |
| **Transcript 仅追加** | 文件会增长，依赖压缩来控制大小 |
| **记忆双写** | Agent 必须主动写文件才能"记住"，被动对话不自动持久化 |

### 6.3 ACP Session 扩展（未来方向）

OpenClaw 正在将 ACP（Agent Coding Protocol）Session 提升为一等控制面：

- 独立的 SQLite 存储（WAL 模式）
- 每 Session 一个 Actor 模型（序列化命令）
- 事务性 spawn + bind + enqueue
- 幂等命令 + 投递检查点
- 状态机：`creating → idle → running → idle → closed`

这将使 Session 管理从当前的"文件系统为主"进化为"数据库为主"。

---

## 7. 配置速查

### 7.1 Session 核心配置

```json5
{
  session: {
    // DM 路由策略
    dmScope: "main",  // main | per-peer | per-channel-peer | per-account-channel-peer
    
    // 跨渠道身份链接
    identityLinks: {
      alice: ["telegram:123", "discord:456"]
    },
    
    // 重置策略
    reset: {
      mode: "daily",        // daily | idle
      atHour: 4,            // 每日重置时间
      idleMinutes: 120      // 空闲超时
    },
    
    // 按类型覆盖
    resetByType: {
      dm: { mode: "idle", idleMinutes: 240 },
      group: { mode: "idle", idleMinutes: 120 }
    },
    
    // 主键名称
    mainKey: "main",
    
    // 存储路径（支持 {agentId} 模板）
    store: "~/.openclaw/agents/{agentId}/sessions/sessions.json",
    
    // 发送策略
    sendPolicy: {
      rules: [],
      default: "allow"
    }
  }
}
```

### 7.2 Agent 运行时配置

```json5
{
  agents: {
    defaults: {
      // 全局并发
      maxConcurrent: 4,
      
      // 超时
      timeoutSeconds: 600,
      
      // 压缩
      compaction: {
        reserveTokensFloor: 20000,
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 4000
        }
      },
      
      // 上下文剪枝
      contextPruning: {
        mode: "cache-ttl",  // off | cache-ttl
        ttl: "5m"
      },
      
      // 子 Agent
      subagents: {
        maxSpawnDepth: 2,
        maxChildrenPerAgent: 5,
        maxConcurrent: 8,
        archiveAfterMinutes: 60,
        runTimeoutSeconds: 900
      }
    }
  }
}
```

### 7.3 队列配置

```json5
{
  messages: {
    queue: {
      mode: "collect",       // collect | steer | followup | steer-backlog
      debounceMs: 1000,
      cap: 20,
      drop: "summarize",     // old | new | summarize
      byChannel: {
        discord: "collect"
      }
    }
  }
}
```

---

## 8. 总结

OpenClaw 的 Session 系统是一个**精心设计的有状态 Agent 运行时**，核心特征：

1. **路由灵活** — SessionKey 规则支持从个人助手到多用户收件箱的各种场景
2. **存储简洁** — sessions.json + JSONL 双层模型，无外部数据库依赖
3. **上下文高效** — 剪枝（临时）+ 压缩（持久）+ 记忆刷新 三级优化
4. **隔离完善** — 子 Agent Session 独立隔离，工具策略分层控制
5. **生命周期完整** — 创建 → 使用 → 优化 → 过期，全自动管理
6. **扩展性强** — ACP 控制面正在将架构推向数据库级可靠性

对于自托管 AI 助手场景，这是一个**实用主义的优秀设计**——在简洁性和功能性之间取得了很好的平衡。

---

## 参考来源

1. OpenClaw 官方文档 - [会话管理](https://docs.openclaw.ai/concepts/session)
2. OpenClaw 官方文档 - [Agent 循环](https://docs.openclaw.ai/concepts/agent-loop)
3. OpenClaw 官方文档 - [压缩](https://docs.openclaw.ai/concepts/compaction)
4. OpenClaw 官方文档 - [会话剪枝](https://docs.openclaw.ai/concepts/session-pruning)
5. OpenClaw 官方文档 - [会话管理深入了解](https://docs.openclaw.ai/reference/session-management-compaction)
6. OpenClaw 官方文档 - [记忆](https://docs.openclaw.ai/concepts/memory)
7. OpenClaw 官方文档 - [命令队列](https://docs.openclaw.ai/concepts/queue)
8. OpenClaw 官方文档 - [子 Agent](https://docs.openclaw.ai/tools/subagents)
9. OpenClaw 官方文档 - [配置](https://docs.openclaw.ai/gateway/configuration)
10. OpenClaw 官方文档 - [对话记录清理](https://docs.openclaw.ai/reference/transcript-hygiene)
11. OpenClaw 源码 - `src/config/sessions.ts`, `src/auto-reply/reply/session.ts`
12. OpenClaw 源码 - ACP 控制面计划文档
13. Reference Architecture: OpenClaw (robotpaper.ai, 2026-02)
14. OpenClaw 插件 SDK 类型定义
