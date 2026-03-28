# OpenClaw 多 Agent 配置与通信机制深度研究

> 基于 OpenClaw 最新文档和源码分析，梳理多 Agent 的配置方法、通信机制、典型架构模式。

---

## 第一章：核心概念

### 1.1 什么是"一个 Agent"

在 OpenClaw 中，一个 Agent 是一个**完全隔离的 AI 大脑**：

| 组成 | 说明 | 路径 |
|------|------|------|
| **Workspace** | 工作空间（AGENTS.md / SOUL.md / USER.md / TOOLS.md 等 7 文件） | `~/.openclaw/workspace-<agentId>` |
| **AgentDir** | 认证配置、模型注册 | `~/.openclaw/agents/<agentId>/agent/` |
| **Session Store** | 会话历史 + 路由状态 | `~/.openclaw/agents/<agentId>/sessions/` |
| **Auth Profiles** | 模型认证（API Key 等） | `~/.openclaw/agents/<agentId>/agent/auth-profiles.json` |
| **Skills** | 私有技能（`workspace/skills/`）+ 共享技能（`~/.openclaw/skills/`） | 按优先级合并 |

**关键隔离原则**：
- Auth Profiles **不**在 Agent 间共享（需手动复制）
- Session Store 完全隔离（Agent A 看不到 Agent B 的对话历史）
- Workspace 是默认 cwd，但**不是硬沙箱**（绝对路径可逃逸，除非开启 Sandbox）

### 1.2 单 Agent 模式（默认）

不做任何配置时，OpenClaw 运行单 Agent：
- `agentId` 默认为 `main`
- Session Key 为 `agent:main:main`
- Workspace 为 `~/.openclaw/workspace`

### 1.3 多 Agent 模式

通过 `agents.list[]` 声明多个 Agent，通过 `bindings[]` 路由消息：

```json5
{
  agents: {
    list: [
      { id: "main", default: true, workspace: "~/.openclaw/workspace-main" },
      { id: "sales", workspace: "~/.openclaw/workspace-sales" },
      { id: "support", workspace: "~/.openclaw/workspace-support" }
    ]
  },
  bindings: [
    { agentId: "sales", match: { channel: "telegram", peer: { kind: "group", id: "-100xxx" } } },
    { agentId: "support", match: { channel: "feishu", accountId: "support-bot" } }
  ]
}
```

---

## 第二章：路由机制（消息如何到达正确的 Agent）

### 2.1 路由优先级（从高到低）

每条入站消息，OpenClaw 按以下顺序匹配**唯一一个 Agent**：

| 优先级 | 匹配规则 | 说明 |
|--------|---------|------|
| 1 | **peer 精确匹配** | binding 中指定 `peer.kind` + `peer.id`（DM/群组/频道） |
| 2 | **parentPeer 匹配** | 线程继承父级路由 |
| 3 | **guildId + roles** | Discord 角色路由 |
| 4 | **guildId** | Discord 服务器级路由 |
| 5 | **teamId** | Slack 团队级路由 |
| 6 | **accountId** | 按渠道账号路由 |
| 7 | **channel 通配** | `accountId: "*"` 匹配该渠道所有账号 |
| 8 | **default Agent** | `agents.list[].default: true`，否则列表第一个，最终回退到 `main` |

**核心规则**：
- 同层多个 binding 匹配时，**配置顺序先者胜**
- 一个 binding 包含多个匹配字段时，**所有字段必须同时满足**（AND 语义）
- peer 绑定永远胜过 channel 通配（把 peer 绑定放在前面）

### 2.2 Bindings 配置格式

```json5
{
  bindings: [
    // 精确到群组
    {
      agentId: "support",
      match: {
        channel: "telegram",
        peer: { kind: "group", id: "-1001234567890" }
      }
    },
    // 精确到 DM 用户
    {
      agentId: "vip-agent",
      match: {
        channel: "whatsapp",
        peer: { kind: "direct", id: "+8613800138000" }
      }
    },
    // 按账号路由
    {
      agentId: "sales",
      match: { channel: "feishu", accountId: "sales-bot" }
    },
    // channel 通配
    {
      agentId: "main",
      match: { channel: "telegram", accountId: "*" }
    }
  ]
}
```

### 2.3 Session Key 格式

路由确定 Agent 后，消息落入对应的 Session：

| 场景 | Session Key 格式 |
|------|-----------------|
| DM（直接消息） | `agent:<agentId>:main` |
| 群组 | `agent:<agentId>:<channel>:group:<id>` |
| 频道 | `agent:<agentId>:<channel>:channel:<id>` |
| 话题/线程 | `agent:<agentId>:telegram:group:<chatId>:topic:<topicId>` |
| Sub-agent | `agent:<agentId>:subagent:<uuid>` |
| Cron | `cron:<jobId>:run:<uuid>` |

---

## 第三章：Agent 间通信机制

OpenClaw 提供**四种** Agent 间通信方式：

### 3.1 sessions_send（同步/异步消息传递）

**场景**：Agent A 需要 Agent B 执行一个任务并返回结果。

```
Agent A 调用 sessions_send:
  → 消息注入 Agent B 的 session
  → Agent B 执行任务
  → 结果返回 Agent A

支持同步等待（timeoutSeconds > 0）和异步（timeoutSeconds = 0）
```

**参数**：
- `sessionKey`：目标 session（可以是 session key 或 sessionId）
- `message`：要发送的消息
- `timeoutSeconds`：0 = fire-and-forget，> 0 = 等待回复

**关键特性**：
- 支持**乒乓回复**：发送后双方可以多轮交互（最多 `maxPingPongTurns` 轮，默认 5）
- 回复 `REPLY_SKIP` 终止乒乓
- 循环结束后有 **announce 步骤**：目标 Agent 可以向其渠道发送最终消息
- 消息标记 `provenance.kind = "inter_session"`，可区分 Agent 间消息和用户消息

**配置**：
```json5
{
  session: {
    agentToAgent: {
      maxPingPongTurns: 5  // 0-5，默认 5
    }
  }
}
```

### 3.2 sessions_spawn（派生子 Agent）

**场景**：当前 Agent 需要后台执行一个独立任务，完成后自动汇报。

```
Main Agent 调用 sessions_spawn:
  → 创建隔离 session: agent:<agentId>:subagent:<uuid>
  → 子 Agent 后台执行（非阻塞）
  → 完成后自动 announce 回父 Agent 的渠道
```

**参数**：
- `task`（必填）：任务描述
- `agentId`：可指定不同 Agent 执行（需在 allowAgents 中）
- `model` / `thinking`：可覆盖模型和推理级别
- `runTimeoutSeconds`：超时时间
- `thread`：是否绑定到渠道线程（Discord 支持）
- `mode`：`run`（一次性）或 `session`（持久化）
- `sandbox`：`inherit` 或 `require`（要求沙箱）

**关键特性**：
- **非阻塞**：立即返回 `{ status: "accepted", runId, childSessionKey }`
- **自动汇报**：完成后 announce 到父级渠道
- 子 Agent **默认没有 session tools**（不能 spawn 更多子 Agent）
- 子 Agent 只注入 `AGENTS.md` + `TOOLS.md`（不注入 SOUL.md 等其他文件）
- 自动归档：`archiveAfterMinutes` 默认 60 分钟

### 3.3 嵌套 Sub-Agents（编排者模式）

**场景**：需要一个编排者 Agent 来管理多个工作者 Agent。

```
Main Agent
  └── sessions_spawn → Orchestrator (depth 1)
        ├── sessions_spawn → Worker A (depth 2)
        ├── sessions_spawn → Worker B (depth 2)
        └── sessions_spawn → Worker C (depth 2)
```

**启用**：
```json5
{
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 2,        // 允许嵌套（默认 1，最大 5）
        maxChildrenPerAgent: 5,  // 每个 Agent 最多 5 个子 Agent
        maxConcurrent: 8         // 全局并发上限
      }
    }
  }
}
```

**深度级别与权限**：

| 深度 | Session Key | 角色 | 拥有的 Session Tools |
|------|------------|------|---------------------|
| 0 | `agent:<id>:main` | Main Agent | 全部 |
| 1 | `agent:<id>:subagent:<uuid>` | 编排者（当 maxSpawnDepth ≥ 2） | `sessions_spawn`, `subagents`, `sessions_list`, `sessions_history` |
| 1 | `agent:<id>:subagent:<uuid>` | 叶子（当 maxSpawnDepth = 1） | 无 session tools |
| 2 | `agent:<id>:subagent:<uuid>:subagent:<uuid>` | 叶子工作者 | 无（永远不能再 spawn） |

**Announce 链**：
```
Worker (depth 2) 完成 → announce 给 Orchestrator (depth 1)
Orchestrator 汇总结果 → announce 给 Main (depth 0)
Main 收到结果 → 推送给用户
```

**级联停止**：停止 depth-1 编排者会自动停止其所有 depth-2 子 Agent。

### 3.4 Broadcast Groups（广播组）

**场景**：一条消息需要**多个 Agent 同时处理**（不是路由到一个，而是全部执行）。

```json5
{
  broadcast: {
    strategy: "parallel",  // 或 "sequential"
    "120363403215116621@g.us": ["code-reviewer", "security-scanner", "test-generator"],
    "+15555550123": ["assistant", "logger"]
  }
}
```

**关键特性**：
- 目前仅 **WhatsApp** 支持（Telegram/Discord 计划中）
- `parallel`（默认）：所有 Agent 同时处理
- `sequential`：按数组顺序依次处理
- 每个 Agent 完全隔离（独立 session、独立 workspace、看不到彼此的回复）
- **广播优先级高于 bindings**
- 建议不超过 10 个 Agent（性能考虑）

### 3.5 共享文件系统（间接通信）

Agent 可以通过文件系统间接通信：

```
Agent A 写入 → shared/data/report.json
Agent B 读取 ← shared/data/report.json
```

**前提**：两个 Agent 能访问同一个文件路径（共享 workspace 或使用绝对路径）。沙箱模式下需要配置 `docker.binds` 挂载共享目录。

### 3.6 四种通信方式对比

| 方式 | 方向 | 同步/异步 | 隔离级别 | 适用场景 |
|------|------|----------|---------|---------|
| **sessions_send** | A ↔ B | 支持两种 | Session 隔离 | 任务委派 + 结果返回 |
| **sessions_spawn** | A → B（announce 回来） | 异步 | 完全隔离 | 后台任务、并行研究 |
| **嵌套 Sub-agents** | Main → 编排者 → 工作者 | 异步 | 完全隔离 | 复杂编排、多步骤任务 |
| **Broadcast** | 一对多（同时执行） | 并行/顺序 | 完全隔离 | 多视角分析、团队审查 |
| **共享文件** | 间接 | 异步 | 依赖文件权限 | 数据共享、状态传递 |

---

## 第四章：Per-Agent 安全与工具配置

### 4.1 Per-Agent Tool Policy

每个 Agent 可以有不同的工具权限：

```json5
{
  agents: {
    list: [
      {
        id: "main",
        // 全部权限
      },
      {
        id: "support",
        tools: {
          allow: ["read", "message", "web_search", "web_fetch"],
          deny: ["exec", "write", "edit", "apply_patch", "browser"]
        }
      },
      {
        id: "coding",
        tools: {
          profile: "coding"  // 使用预设 profile
        }
      }
    ]
  }
}
```

**Tool Policy 优先级链**（逐层收窄，不能回授）：

```
1. Tool Profile        → tools.profile 或 agents.list[].tools.profile
2. Provider Profile    → tools.byProvider[provider].profile
3. Global Policy       → tools.allow / tools.deny
4. Provider Policy     → tools.byProvider[provider].allow/deny
5. Agent Policy        → agents.list[].tools.allow/deny
6. Agent Provider      → agents.list[].tools.byProvider[provider].allow/deny
7. Sandbox Policy      → tools.sandbox.tools
8. Subagent Policy     → tools.subagents.tools
```

**Tool Groups（快捷方式）**：

| Group | 展开为 |
|-------|--------|
| `group:runtime` | exec, bash, process |
| `group:fs` | read, write, edit, apply_patch |
| `group:sessions` | sessions_list, sessions_history, sessions_send, sessions_spawn, session_status |
| `group:memory` | memory_search, memory_get |
| `group:ui` | browser, canvas |
| `group:automation` | cron, gateway |
| `group:messaging` | message |

### 4.2 Per-Agent Sandbox

```json5
{
  agents: {
    list: [
      {
        id: "main",
        sandbox: { mode: "off" }              // 不沙箱
      },
      {
        id: "public",
        sandbox: {
          mode: "all",                         // 全部 session 沙箱
          scope: "agent",                      // 每个 agent 一个容器
          docker: {
            setupCommand: "apt-get update && apt-get install -y git"
          }
        },
        tools: {
          allow: ["read"],
          deny: ["exec", "write", "edit"]
        }
      }
    ]
  }
}
```

**Sandbox mode 选项**：
- `off`：不沙箱
- `non-main`：非 main session 沙箱（注意：基于 session key，不是 agent id）
- `all`：所有 session 都沙箱

**Sandbox scope 选项**：
- `session`：每个 session 一个容器
- `agent`：每个 agent 一个容器
- `shared`：所有 agent 共享一个容器

### 4.3 Session Tools 可见性

控制 Agent 能看到哪些 session：

```json5
{
  tools: {
    sessions: {
      visibility: "tree"  // "self" | "tree" | "agent" | "all"
    }
  }
}
```

| 级别 | 可见范围 |
|------|---------|
| `self` | 只看到自己的 session |
| `tree` | 自己 + 自己 spawn 的子 session（默认） |
| `agent` | 同一 agentId 下的所有 session |
| `all` | 所有 session（跨 Agent 需要 agentToAgent 配置） |

---

## 第五章：典型多 Agent 架构模式

### 5.1 模式一：单入口路由（CEO 模式）

```
              用户（飞书/钉钉/Telegram）
                      │
                      ▼
              ┌───────────────┐
              │  CEO Agent    │  ← default: true
              │  (路由中枢)    │
              └───┬───┬───┬───┘
                  │   │   │
        spawn     │   │   │    spawn
        ┌─────────┘   │   └─────────┐
        ▼             ▼             ▼
   ┌─────────┐  ┌─────────┐  ┌─────────┐
   │ Sales   │  │ Support │  │ Content │
   │ Agent   │  │ Agent   │  │ Agent   │
   └─────────┘  └─────────┘  └─────────┘
```

**适用场景**：OPC 数字员工平台、个人助理团队

**核心逻辑**：CEO Agent 是唯一入口，理解用户意图后通过 `sessions_spawn` 或 `sessions_send` 分派给专业 Agent。

**配置**：

```json5
{
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 1,
        maxChildrenPerAgent: 5,
        model: "anthropic/claude-sonnet-4-5"  // 子 Agent 用便宜模型
      }
    },
    list: [
      {
        id: "ceo",
        default: true,
        name: "CEO",
        model: "anthropic/claude-sonnet-4-5",
        workspace: "~/.openclaw/workspace-ceo"
      },
      {
        id: "sales",
        name: "销售助理",
        workspace: "~/.openclaw/workspace-sales",
        tools: {
          allow: ["read", "write", "web_search", "web_fetch", "message"],
          deny: ["exec", "browser", "group:automation"]
        }
      },
      {
        id: "support",
        name: "客服助理",
        workspace: "~/.openclaw/workspace-support",
        tools: {
          allow: ["read", "web_search", "message"],
          deny: ["exec", "write", "edit", "browser"]
        }
      },
      {
        id: "content",
        name: "内容运营",
        workspace: "~/.openclaw/workspace-content",
        tools: {
          allow: ["read", "write", "web_search", "web_fetch"],
          deny: ["exec", "browser", "group:automation"]
        }
      }
    ]
  },
  // 所有消息先到 CEO
  bindings: [
    { agentId: "ceo", match: { channel: "feishu", accountId: "*" } },
    { agentId: "ceo", match: { channel: "telegram", accountId: "*" } }
  ]
}
```

**CEO Agent 的 AGENTS.md 关键部分**：

```markdown
你是团队主管，负责：
1. 理解用户意图，判断应该哪个员工处理
2. 使用 sessions_spawn 派发任务：
   - 销售相关 → agentId: "sales"
   - 客服问题 → agentId: "support"
   - 内容创作 → agentId: "content"
3. 简单问题自己直接回答，不需要派发
4. 收到子 Agent 结果后，用用户能理解的语言转述
```

**优点**：
- 用户只需要和一个 Agent 对话
- CEO 可以协调多个 Agent 协作
- 每个专业 Agent 有独立的知识和权限

**缺点**：
- CEO 是单点，所有消息都经过它（延迟 + 成本）
- CEO 的意图识别准确率决定体验上限

---

### 5.2 模式二：直接路由（专线模式）

```
              用户（多个群/渠道）
              │        │        │
              ▼        ▼        ▼
          飞书群A   飞书群B  Telegram
              │        │        │
              ▼        ▼        ▼
         ┌────────┐┌────────┐┌────────┐
         │ Sales  ││Support ││ Main   │
         │ Agent  ││ Agent  ││ Agent  │
         └────────┘└────────┘└────────┘
```

**适用场景**：每个 Agent 有明确的渠道/群组归属

**配置**：

```json5
{
  agents: {
    list: [
      { id: "sales", workspace: "~/.openclaw/workspace-sales" },
      { id: "support", workspace: "~/.openclaw/workspace-support" },
      { id: "main", default: true, workspace: "~/.openclaw/workspace-main" }
    ]
  },
  bindings: [
    // 销售群 → 销售 Agent
    {
      agentId: "sales",
      match: { channel: "feishu", peer: { kind: "group", id: "oc_sales_group_id" } }
    },
    // 客服群 → 客服 Agent
    {
      agentId: "support",
      match: { channel: "feishu", peer: { kind: "group", id: "oc_support_group_id" } }
    },
    // 其他 → main
    { agentId: "main", match: { channel: "feishu", accountId: "*" } }
  ]
}
```

**优点**：
- 零延迟路由（不经过中间 Agent）
- 每个 Agent 专注一个领域
- 配置简单，性能最优

**缺点**：
- Agent 间不自动协作
- 用户需要去对应的群找对应的 Agent

---

### 5.3 模式三：编排者模式（Orchestrator）

```
              用户
                │
                ▼
         ┌─────────────┐
         │   Main      │
         │   Agent     │
         └──────┬──────┘
                │ spawn
                ▼
         ┌─────────────┐
         │ Orchestrator │  (depth 1, 有 session tools)
         │  Sub-Agent   │
         └──┬───┬───┬──┘
            │   │   │   spawn
            ▼   ▼   ▼
         ┌───┐┌───┐┌───┐
         │ W1││ W2││ W3│  (depth 2, 叶子工作者)
         └───┘└───┘└───┘
```

**适用场景**：复杂任务需要拆分为多个并行子任务

**配置**：

```json5
{
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 2,         // 启用嵌套
        maxChildrenPerAgent: 5,
        maxConcurrent: 8,
        runTimeoutSeconds: 900,
        model: "anthropic/claude-haiku-3-5"  // 工作者用便宜模型
      }
    },
    list: [
      {
        id: "main",
        default: true,
        model: "anthropic/claude-sonnet-4-5",
        workspace: "~/.openclaw/workspace-main"
      }
    ]
  }
}
```

**Main Agent 的 AGENTS.md**：

```markdown
当遇到复杂任务时，使用以下模式：

1. spawn 一个编排者子 Agent（它会获得 session tools）
2. 编排者负责拆分任务、spawn 工作者、汇总结果
3. 你只需要等待编排者的最终报告

示例：
sessions_spawn({
  task: "研究任务：调研 React vs Vue vs Svelte，编排 3 个工作者分别调研，最终汇总对比报告",
  model: "anthropic/claude-sonnet-4-5"  // 编排者用好模型
})
```

**优点**：
- 支持高度并行
- 任务拆分和汇总由 LLM 完成（灵活）
- 工作者可以用便宜模型

**缺点**：
- 成本高（每层都有自己的 context）
- 调试复杂

---

### 5.4 模式四：广播团队（Broadcast）

```
              用户发送一条消息
                      │
                      ▼
         ┌────────────────────────┐
         │     Broadcast Group     │
         └────┬───┬───┬───┬──────┘
              │   │   │   │
              ▼   ▼   ▼   ▼
           ┌───┐┌───┐┌───┐┌───┐
           │ A ││ B ││ C ││ D │  全部同时处理
           └───┘└───┘└───┘└───┘
              │   │   │   │
              ▼   ▼   ▼   ▼
           回复1 回复2 回复3 回复4
```

**适用场景**：Code Review 团队、多语言支持、多视角分析

**配置**：

```json5
{
  agents: {
    list: [
      { id: "reviewer", name: "Code Reviewer", workspace: "~/workspace-reviewer" },
      { id: "security", name: "Security Auditor", workspace: "~/workspace-security" },
      { id: "tester", name: "Test Generator", workspace: "~/workspace-tester" }
    ]
  },
  broadcast: {
    strategy: "parallel",
    "120363403215116621@g.us": ["reviewer", "security", "tester"]
  }
}
```

**优点**：
- 一条消息，多个专家同时分析
- 每个 Agent 完全独立（不干扰）
- 配置极其简单

**缺点**：
- 目前仅 WhatsApp 支持
- Agent 间看不到彼此回复（by design）
- Agent 数量多时响应慢

---

### 5.5 模式五：按渠道分工 + 按模型分级

```
              用户
            ┌──┴──┐
            │     │
         飞书   Telegram
            │     │
            ▼     ▼
        ┌──────┐┌──────┐
        │快速  ││深度  │
        │Sonnet││Opus  │
        │日常  ││复杂  │
        └──────┘└──────┘
```

**配置**：

```json5
{
  agents: {
    list: [
      {
        id: "fast",
        name: "日常助手",
        model: "anthropic/claude-sonnet-4-5",
        workspace: "~/.openclaw/workspace-fast"
      },
      {
        id: "deep",
        name: "深度分析",
        model: "anthropic/claude-opus-4-6",
        workspace: "~/.openclaw/workspace-deep"
      }
    ]
  },
  bindings: [
    { agentId: "fast", match: { channel: "feishu" } },
    { agentId: "deep", match: { channel: "telegram" } }
  ]
}
```

**变体——同渠道按用户分**：

```json5
{
  bindings: [
    // VIP 用户 → Opus
    {
      agentId: "deep",
      match: { channel: "feishu", peer: { kind: "direct", id: "vip_user_id" } }
    },
    // 其他 → Sonnet
    { agentId: "fast", match: { channel: "feishu", accountId: "*" } }
  ]
}
```

---

### 5.6 模式六：混合模式（实际生产推荐）

实际生产中通常是多种模式的组合：

```
              用户（飞书）
              │        │
              ▼        ▼
           DM       客服群
              │        │
              ▼        ▼
        ┌─────────┐ ┌─────────┐
        │  CEO    │ │ Support │  ← 直接路由（模式二）
        │  Agent  │ │ Agent   │
        └────┬────┘ └─────────┘
             │
             │ spawn（模式一/三）
        ┌────┼────┐
        ▼    ▼    ▼
      Sales Content Research
```

**配置**：

```json5
{
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 1,
        maxChildrenPerAgent: 5,
        model: "anthropic/claude-sonnet-4-5"
      }
    },
    list: [
      {
        id: "ceo",
        default: true,
        model: "anthropic/claude-sonnet-4-5",
        workspace: "~/.openclaw/workspace-ceo",
        subagents: {
          allowAgents: ["sales", "content", "research"]  // 可 spawn 哪些 Agent
        }
      },
      {
        id: "support",
        model: "anthropic/claude-haiku-3-5",  // 客服用便宜模型
        workspace: "~/.openclaw/workspace-support",
        tools: {
          allow: ["read", "web_search", "message"],
          deny: ["exec", "write", "browser"]
        },
        sandbox: { mode: "all", scope: "agent" }
      },
      {
        id: "sales",
        workspace: "~/.openclaw/workspace-sales",
        tools: {
          allow: ["read", "write", "web_search", "message"],
          deny: ["exec", "browser"]
        }
      },
      {
        id: "content",
        workspace: "~/.openclaw/workspace-content"
      },
      {
        id: "research",
        workspace: "~/.openclaw/workspace-research"
      }
    ]
  },
  bindings: [
    // 客服群 → 直接到 Support Agent
    {
      agentId: "support",
      match: { channel: "feishu", peer: { kind: "group", id: "support_group_id" } }
    },
    // 其他 → CEO Agent
    { agentId: "ceo", match: { channel: "feishu", accountId: "*" } }
  ]
}
```

---

## 第六章：配置最佳实践

### 6.1 Agent 创建快速路径

```bash
# 方式一：CLI 向导
openclaw agents add sales
openclaw agents add support

# 方式二：手动创建
mkdir -p ~/.openclaw/workspace-sales
echo "你是销售助理..." > ~/.openclaw/workspace-sales/AGENTS.md
echo "专业、积极" > ~/.openclaw/workspace-sales/SOUL.md

# 验证
openclaw agents list --bindings
openclaw channels status --probe
```

### 6.2 模型分级策略

```json5
{
  agents: {
    defaults: {
      model: { primary: "anthropic/claude-sonnet-4-5" },  // 全局默认
      subagents: {
        model: "anthropic/claude-haiku-3-5"  // 子 Agent 默认便宜
      }
    },
    list: [
      { id: "ceo", model: "anthropic/claude-sonnet-4-5" },   // CEO 用 Sonnet
      { id: "research", model: "anthropic/claude-opus-4-6" },  // 研究用 Opus
      { id: "support", model: "anthropic/claude-haiku-3-5" },  // 客服用 Haiku
    ]
  }
}
```

### 6.3 安全分级策略

```json5
{
  agents: {
    list: [
      {
        id: "main",
        sandbox: { mode: "off" },        // 信任：主 Agent 不沙箱
        // tools: 全部开放
      },
      {
        id: "support",
        sandbox: { mode: "all", scope: "agent" },  // 半信任：沙箱 + 限制工具
        tools: {
          allow: ["read", "web_search", "message"],
          deny: ["group:runtime", "group:fs", "group:ui"]
        }
      },
      {
        id: "public",
        sandbox: { mode: "all", scope: "session" },  // 不信任：严格沙箱
        tools: {
          allow: ["read"],
          deny: ["exec", "write", "edit", "apply_patch", "browser", "message"]
        }
      }
    ]
  }
}
```

### 6.4 共享 vs 隔离决策表

| 需求 | 方案 |
|------|------|
| Agent 间共享知识 | 共享目录（`shared/knowledge/`）或 `sessions_send` 传递 |
| Agent 间共享认证 | 复制 `auth-profiles.json`（不要共用 agentDir！） |
| Agent 间共享 Skills | 放到 `~/.openclaw/skills/`（全局共享目录） |
| Agent 间完全隔离 | 默认行为（不同 workspace + agentDir + session store） |
| Agent 间通信 | `sessions_send` / `sessions_spawn` |

---

## 第七章：总结

### 多 Agent 能力矩阵

| 能力 | 配置方式 | 一句话说明 |
|------|---------|----------|
| **声明 Agent** | `agents.list[]` | 每个 Agent 有独立 workspace/session/auth |
| **路由消息** | `bindings[]` | 按 peer > account > channel > default 匹配 |
| **派发任务** | `sessions_spawn` | 非阻塞，子 Agent 完成后自动汇报 |
| **同步通信** | `sessions_send` | 支持等待回复 + 乒乓多轮 |
| **嵌套编排** | `maxSpawnDepth: 2` | Main → 编排者 → 工作者 三级结构 |
| **广播处理** | `broadcast{}` | 一条消息多个 Agent 同时处理（WhatsApp） |
| **工具权限** | `agents.list[].tools` | Per-Agent allow/deny，逐层收窄 |
| **沙箱隔离** | `agents.list[].sandbox` | Per-Agent 沙箱模式和范围 |
| **Session 可见性** | `tools.sessions.visibility` | 控制 Agent 能看到哪些 session |
| **模型分级** | `agents.list[].model` | Per-Agent 不同模型（成本优化） |

### 架构选型速查

| 场景 | 推荐架构 | 理由 |
|------|---------|------|
| OPC 数字员工平台 | 模式一（CEO）+ 模式二（直接路由）混合 | CEO 处理 DM，专线处理专业群 |
| 代码审查团队 | 模式四（广播） | 多角度同时审查 |
| 复杂研究任务 | 模式三（编排者） | 拆分并行 + 汇总 |
| 多用户共享 Gateway | 模式二（直接路由） | 每人一个 Agent，按 peer 路由 |
| 多渠道分工 | 模式五（渠道分级） | 不同渠道不同模型/Agent |
| 生产系统 | 模式六（混合） | 组合多种模式 |

---

*文档由 wairesearch (黄山) 生成 | 2026-03-28*
*基于 OpenClaw 最新官方文档（v2026.3.22+）*
*来源：channel-routing.md, multi-agent.md, subagents.md, multi-agent-sandbox-tools.md, session-tool.md, broadcast-groups.md*
