# OpenClaw Agent-to-Agent 架构原理研究报告

> 研究员: 黄山 (wairesearch) | 日期: 2026-03-10

## 执行摘要

OpenClaw 的 Agent-to-Agent (A2A) 通信是一个**多层次、策略驱动**的架构，包含三种核心交互模式：**同级 Agent 直接通信 (sessions_send)**、**父子 Sub-agent 委派 (sessions_spawn)**、以及**外部 ACP 运行时集成**。整个系统以 Session 为核心抽象单元，通过 Gateway 进程内的队列调度和策略引擎实现安全、隔离的 Agent 间协作。

---

## 1. 架构全景

```
┌──────────────────────────────────────────────────────┐
│                    Gateway Process                    │
│                                                      │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐       │
│  │ Agent A  │    │ Agent B  │    │ Agent C  │       │
│  │ (main)   │    │ (coding) │    │ (alerts) │       │
│  │          │    │          │    │          │       │
│  │ workspace│    │ workspace│    │ workspace│       │
│  │ sessions │    │ sessions │    │ sessions │       │
│  │ auth     │    │ auth     │    │ auth     │       │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘       │
│       │               │               │              │
│  ┌────┴───────────────┴───────────────┴────┐        │
│  │         Session Router / Dispatcher      │        │
│  │  ┌─────────────┐  ┌──────────────────┐  │        │
│  │  │ A2A Policy  │  │ Visibility Guard │  │        │
│  │  │ Engine      │  │                  │  │        │
│  │  └─────────────┘  └──────────────────┘  │        │
│  └─────────────────────────────────────────┘        │
│       │               │               │              │
│  ┌────┴────┐    ┌─────┴─────┐   ┌─────┴─────┐      │
│  │subagent │    │  A2A Send │   │  ACP       │      │
│  │ lane    │    │  lane     │   │  backend   │      │
│  └─────────┘    └───────────┘   └───────────┘      │
└──────────────────────────────────────────────────────┘
```

---

## 2. 三种 Agent-to-Agent 交互模式

### 2.1 模式一：同级 Agent 直接通信 (`sessions_send`)

**场景**：Agent A 需要向 Agent B 发送消息并等待回复。

**配置要求**：

```json5
{
  tools: {
    agentToAgent: {
      enabled: true,        // 默认 false，必须显式开启
      allow: ["agentA", "agentB"]  // 白名单
    }
  }
}
```

**通信流程**：

```
Agent A                          Gateway                        Agent B
   │                               │                               │
   │── sessions_send(key,msg) ────>│                               │
   │                               │── 策略检查 (A2A Policy) ──>  │
   │                               │── 注入 A2A 消息上下文 ──────>│
   │                               │── 启动 Agent B 的 run ──────>│
   │                               │<── Round 1 Reply ────────────│
   │                               │                               │
   │                               │── Ping-Pong Loop ──────────> │
   │                               │   (最多 maxPingPongTurns)    │
   │                               │   任一方回复 REPLY_SKIP 终止 │
   │                               │                               │
   │                               │── A2A Announce Step ────────>│
   │                               │   (ANNOUNCE_SKIP 可跳过)     │
   │<── { status, reply } ────────│                               │
```

**关键实现细节**（来自源码 `sessions-send-helpers.d.ts`）：

| 函数 | 作用 |
|------|------|
| `buildAgentToAgentMessageContext()` | 构建首轮消息的上下文注入 |
| `buildAgentToAgentReplyContext()` | 构建 Ping-Pong 轮次的上下文 |
| `buildAgentToAgentAnnounceContext()` | 构建 Announce 步骤上下文 |
| `isReplySkip()` / `isAnnounceSkip()` | 检测终止信号 |
| `resolvePingPongTurns()` | 从配置解析最大轮数（0-5, 默认5） |

**Ping-Pong 协议**：
- Round 2+ 在 requester 和 target 之间交替进行
- 任一方回复 `REPLY_SKIP` 即终止循环
- 最大轮次由 `session.agentToAgent.maxPingPongTurns` 控制
- 循环结束后执行 Announce Step（仅 target agent）

**消息溯源**：
- 跨 Session 消息标记为 `message.provenance.kind = "inter_session"`
- 这让 transcript 读取者能区分路由来的 agent 指令和外部用户输入

### 2.2 模式二：父子委派 (`sessions_spawn` — Sub-agent)

**场景**：Agent 将子任务委派给后台运行的 Sub-agent。

**Session Key 结构**：

```
深度 0: agent:<agentId>:main                           ← 主 Agent
深度 1: agent:<agentId>:subagent:<uuid>                ← Sub-agent
深度 2: agent:<agentId>:subagent:<uuid>:subagent:<uuid> ← Sub-sub-agent
```

**Spawn 流程**：

```
Main Agent                    Gateway                     Sub-agent
    │                            │                            │
    │── sessions_spawn(task) ──>│                            │
    │<── { accepted, runId } ───│                            │
    │   (非阻塞，立即返回)       │                            │
    │                            │── 创建隔离 Session ──────>│
    │                            │── 注入 System Prompt ────>│
    │                            │── 注入 AGENTS.md/TOOLS.md>│
    │                            │   (不含 SOUL/IDENTITY等)  │
    │                            │── 启动 Agent Run ────────>│
    │                            │                            │
    │                            │    ... 执行任务 ...        │
    │                            │                            │
    │                            │<── Run 完成 ──────────────│
    │                            │── captureCompletionReply()│
    │                            │── Announce Step ─────────>│
    │                            │<── Announce 回复 ─────────│
    │                            │                            │
    │<── 任务完成事件注入 ───────│                            │
    │   (AgentInternalEvent)     │                            │
```

**Announce 链（嵌套场景）**：

```
Depth-2 Worker 完成
    └── announce → Depth-1 Orchestrator (内部注入, deliver=false)
         └── 综合结果后完成
              └── announce → Main Agent (外部投递, deliver=true)
                   └── 投递给用户
```

**核心数据结构**（`SubagentRunRecord`）：

```typescript
{
  runId: string;
  childSessionKey: string;
  requesterSessionKey: string;
  task: string;
  spawnMode: "run" | "session";
  outcome: { status: "ok" | "error" | "timeout" | "unknown" };
  frozenResultText?: string;       // 缓存的最终输出
  wakeOnDescendantSettle?: boolean; // 等待子任务完成后重新唤醒
}
```

**工具策略（按深度）**：

| 深度 | 场景 | 可用 Session 工具 |
|------|------|-------------------|
| 1 (maxSpawnDepth=1) | 叶子节点 | 无 |
| 1 (maxSpawnDepth≥2) | 编排者 | `sessions_spawn`, `subagents`, `sessions_list`, `sessions_history` |
| 2 | 叶子工作者 | 无，且永远不可 spawn |

### 2.3 模式三：ACP 外部运行时

**场景**：调用外部编码工具（Codex、Claude Code 等）。

**Session Key**：`agent:<agentId>:acp:<uuid>`

与 Sub-agent 的关键区别：

| 维度 | Sub-agent | ACP |
|------|-----------|-----|
| 运行时 | OpenClaw 原生 | 外部 ACP 后端（如 acpx） |
| 沙箱 | 可继承/强制 | 仅主机运行，沙箱会话不可 spawn |
| 工具 | OpenClaw 工具集 | 外部 harness 自带 |
| 线程绑定 | 支持 | 支持（Discord/Telegram） |
| 管理命令 | `/subagents` | `/acp` |

---

## 3. 安全与访问控制架构

### 3.1 策略引擎分层

```
┌─────────────────────────────────────────┐
│ Layer 1: A2A Policy (agentToAgent)      │
│   enabled: bool + allow: string[]       │
│   → 控制哪些 Agent 可以互相通信         │
├─────────────────────────────────────────┤
│ Layer 2: Session Visibility Guard       │
│   visibility: self | tree | agent | all │
│   → 控制 Agent 能看到哪些 Session       │
├─────────────────────────────────────────┤
│ Layer 3: Sandbox Clamp                  │
│   沙箱环境下强制降级 visibility          │
│   → spawned-only 或 all                 │
├─────────────────────────────────────────┤
│ Layer 4: Tool Policy                    │
│   allow/deny 列表层层收紧               │
│   → 从 global → agent → sandbox → sub  │
├─────────────────────────────────────────┤
│ Layer 5: Spawn Allowlist                │
│   subagents.allowAgents: string[]       │
│   → 控制可以 spawn 哪些 Agent ID        │
└─────────────────────────────────────────┘
```

### 3.2 Session Visibility 详解

```typescript
type SessionToolsVisibility = "self" | "tree" | "agent" | "all";
```

- **self**: 只能看到当前 Session
- **tree**: 当前 Session + 由它 spawn 的子 Session（默认值）
- **agent**: 当前 Agent ID 下的所有 Session
- **all**: 跨 Agent 访问（需配合 A2A Policy）

沙箱环境下自动降级：即使配置了 `visibility: "all"`，沙箱 Session 也会被钳制为 `tree`。

### 3.3 认证隔离

```
~/.openclaw/agents/<agentId>/agent/auth-profiles.json
```

- 每个 Agent 独立的认证存储
- Sub-agent 的认证通过 Agent ID 解析
- 主 Agent 的 profile 作为 fallback 合并（不覆盖子 Agent 的同名 profile）

---

## 4. 并发与调度

### 4.1 队列架构

```
Gateway Process
├── 主队列 (main lane)
│   └── 用户消息处理
├── subagent lane
│   ├── maxConcurrent: 8 (默认)
│   └── maxChildrenPerAgent: 5 (默认)
└── ACP lane
    └── maxConcurrentSessions: 8 (默认)
```

### 4.2 生命周期管理

```
Created → Started → Running → Ended
                                 │
                    ┌────────────┤
                    ▼            ▼
              Announce      Auto-Archive
              (push-back)   (archiveAfterMinutes: 60)
                    │
                    ▼
              Delivered to Requester
```

**级联停止**：停止编排者会自动级联停止所有子任务。

---

## 5. 内部事件系统

完成事件（`AgentInternalEvent`）通过 `formatAgentInternalEventsForPrompt()` 注入到父 Agent 的 prompt 中：

```typescript
type AgentTaskCompletionInternalEvent = {
  type: "task_completion";
  source: "subagent" | "cron";
  childSessionKey: string;
  announceType: string;
  taskLabel: string;
  status: "ok" | "timeout" | "error" | "unknown";
  result: string;          // announce 步骤的回复
  statsLine?: string;      // runtime/tokens/cost 统计
  replyInstruction: string; // 指导父 Agent 如何处理
};
```

Announce payload 包含：
- 运行时间
- Token 使用量（input/output/total）
- 成本估算（如配置了模型定价）
- sessionKey、sessionId、transcript 路径

---

## 6. 配置参考

### 最小化 A2A 配置

```json5
{
  // 同级 Agent 通信
  tools: {
    agentToAgent: {
      enabled: true,
      allow: ["main", "coding", "research"]
    }
  },

  // Ping-Pong 轮数
  session: {
    agentToAgent: {
      maxPingPongTurns: 3  // 0-5, 默认5
    }
  },

  // Sub-agent 配置
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 2,         // 允许嵌套（默认1）
        maxChildrenPerAgent: 5,   // 每个 Agent 最大子任务
        maxConcurrent: 8,         // 全局并发上限
        runTimeoutSeconds: 900,   // 超时
        archiveAfterMinutes: 60   // 自动归档
      }
    }
  },

  // Session 可见性
  tools: {
    sessions: {
      visibility: "tree"  // self | tree | agent | all
    }
  }
}
```

---

## 7. 架构设计亮点

### 7.1 Push-Based Completion（推送式完成通知）

Sub-agent 完成后**主动推送**结果到父 Agent，而非轮询。这从根本上避免了：
- 忙等待浪费 token
- 超时判断不准确
- 复杂的轮询逻辑

### 7.2 Frozen Result + Wake 机制

```typescript
frozenResultText?: string;           // 冻结结果缓存
wakeOnDescendantSettle?: boolean;    // 子孙完成后唤醒
fallbackFrozenResultText?: string;   // 跨 wake 重启的 fallback
```

当编排者的 run 在子任务完成前结束时，系统会：
1. 冻结当前结果
2. 设置 `wakeOnDescendantSettle = true`
3. 子任务完成后自动唤醒编排者
4. 若唤醒后回复 NO_REPLY，使用 `fallbackFrozenResultText`

### 7.3 幂等投递

```
announce-idempotency.ts
```

Announce 投递使用幂等 key，确保：
- Gateway 重启后不会重复投递
- 网络问题重试不会产生重复消息

### 7.4 深度感知的工具策略

系统根据 Session 深度自动调整工具权限，编排者有完整的子任务管理能力，而叶子节点严格受限，防止失控的任务扩散。

---

## 8. 总结

OpenClaw 的 A2A 架构是一个**精心设计的分层系统**：

| 层次 | 机制 | 作用 |
|------|------|------|
| 通信层 | sessions_send / sessions_spawn | Agent 间消息传递 |
| 策略层 | A2A Policy + Visibility Guard | 安全访问控制 |
| 调度层 | Queue Lane + Concurrency | 资源管理 |
| 生命周期 | Announce + Auto-archive | 结果回收与清理 |
| 容错层 | Frozen Result + Wake + Idempotency | 可靠性保证 |

核心设计原则是：**默认隔离，显式开启，最小权限**。Agent 之间默认完全隔离，必须通过配置显式允许通信，且每层策略只能收紧、不能放松上层的限制。

---

## 参考来源

1. OpenClaw 源码 — `/usr/lib/node_modules/openclaw/dist/plugin-sdk/agents/`
2. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/concepts/multi-agent.md`
3. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/tools/subagents.md`
4. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/tools/agent-send.md`
5. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/tools/acp-agents.md`
6. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/concepts/session-tool.md`
7. OpenClaw 配置 Schema — `config-DiiPndBn.js` (Zod schema definitions)
