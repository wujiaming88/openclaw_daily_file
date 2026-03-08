# OpenClaw 多Agent协作深度研究：任务编排与通信机制解析

> **核心问题**：OpenClaw 采用"主Agent + N个子Agent"模式时，如何解决任务编排和Agent间通信问题？

---

## 摘要

OpenClaw 提供了两套互补的多Agent协作机制：

1. **现有机制**：`sessions_spawn` + `sessions_send` 子代理模式（树状层级通信）
2. **未来机制**：Agent Teams RFC（扁平化团队协作，开发中）

本报告基于官方文档和GitHub源码讨论，深入分析两种模式的设计理念、实现原理、适用场景与最佳实践。

---

## 第一部分：问题定义

### 1.1 多Agent协作的核心挑战

```
┌─────────────────────────────────────────────────────────────┐
│                    多Agent协作核心挑战                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   1. 任务编排                                               │
│      • 任务如何分解？                                        │
│      • 谁负责任务分配？                                      │
│      • 如何处理任务依赖？                                    │
│      • 如何跟踪任务状态？                                    │
│                                                             │
│   2. Agent间通信                                            │
│      • 父子Agent如何通信？                                   │
│      • 同级Agent能否直接通信？                               │
│      • 消息如何路由？                                        │
│      • 如何避免通信死锁？                                    │
│                                                             │
│   3. 状态共享                                               │
│      • 如何共享上下文？                                      │
│      • 如何避免状态冲突？                                    │
│      • 如何保持一致性？                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 OpenClaw 的设计约束

| 约束 | 说明 |
|------|------|
| **会话隔离** | 每个Agent有独立会话、工作区、记忆 |
| **工具权限** | 子代理默认无会话工具 |
| **嵌套深度** | 最多2层嵌套（maxSpawnDepth: 2） |
| **通道绑定** | 支持线程绑定（Discord） |

---

## 第二部分：现有机制——子代理模式

### 2.1 架构模型

```
┌─────────────────────────────────────────────────────────────┐
│                    sessions_spawn 子代理模式                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                      ┌─────────────┐                        │
│                      │  Main Agent │                        │
│                      │   (主代理)   │                        │
│                      └──────┬──────┘                        │
│                             │                               │
│              sessions_spawn │                               │
│                             ▼                               │
│         ┌───────────────────┴───────────────────┐          │
│         │                   │                   │          │
│    ┌────▼────┐         ┌────▼────┐         ┌────▼────┐     │
│    │SubAgent │         │SubAgent │         │SubAgent │     │
│    │   #1    │         │   #2    │         │   #3    │     │
│    └────┬────┘         └────┬────┘         └────┬────┘     │
│         │                   │                   │          │
│         │    announce       │    announce       │          │
│         └───────────────────┴───────────────────┘          │
│                             │                               │
│                             ▼                               │
│                      ┌─────────────┐                        │
│                      │  Requester  │                        │
│                      │   Channel   │                        │
│                      └─────────────┘                        │
│                                                             │
│   特点：                                                    │
│   • 树状层级结构                                            │
│   • 子代理只能与父代理通信                                   │
│   • 子代理之间不能直接通信                                   │
│   • 完成后通过 announce 回传结果                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 核心工具

#### sessions_spawn —— 派生子代理

```typescript
// 工具接口
interface SessionsSpawnParams {
  task: string;           // 任务描述（必需）
  label?: string;         // 标签（用于日志/UI）
  agentId?: string;       // 目标Agent ID（需在白名单中）
  model?: string;         // 覆盖模型
  thinking?: string;      // 覆盖thinking级别
  runTimeoutSeconds?: number;  // 超时（秒）
  thread?: boolean;       // 请求线程绑定
  mode?: "run" | "session";  // 默认run
  cleanup?: "delete" | "keep";  // 清理策略
  sandbox?: "inherit" | "require";  // 沙箱策略
  attachments?: Array<{   // 内联文件附件
    name: string;
    content: string;
    encoding?: "utf8" | "base64";
    mimeType?: string;
  }>;
}

// 返回值
interface SessionsSpawnResult {
  status: "accepted";
  runId: string;
  childSessionKey: string;  // 格式: agent:<agentId>:subagent:<uuid>
}
```

**关键行为**：

| 行为 | 说明 |
|------|------|
| **非阻塞** | 立即返回 `{ status: "accepted", runId }` |
| **会话隔离** | 子代理在独立会话中运行 |
| **工具限制** | 子代理默认无会话工具（防止递归派生） |
| **自动归档** | 60分钟后自动归档 |

#### sessions_send —— 向其他会话发消息

```typescript
interface SessionsSendParams {
  sessionKey: string;     // 目标会话key（必需）
  message: string;        // 消息内容（必需）
  timeoutSeconds?: number;  // 等待超时（0=fire-and-forget）
}

interface SessionsSendResult {
  runId: string;
  status: "accepted" | "ok" | "timeout" | "error";
  reply?: string;  // 如果等待完成
  error?: string;
}
```

**通信模式**：

```
┌─────────────────────────────────────────────────────────────┐
│                    sessions_send 通信模式                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   timeoutSeconds = 0 (Fire-and-forget):                     │
│   ┌──────────┐                    ┌──────────┐              │
│   │ Requester │ ──── message ────►│  Target  │              │
│   └──────────┘                    └──────────┘              │
│   立即返回 { status: "accepted" }                            │
│                                                             │
│   timeoutSeconds > 0 (Wait for reply):                      │
│   ┌──────────┐                    ┌──────────┐              │
│   │ Requester │ ──── message ────►│  Target  │              │
│   │           │ ◄──── reply ─────│          │              │
│   └──────────┘                    └──────────┘              │
│   返回 { status: "ok", reply: "..." }                       │
│                                                             │
│   Ping-Pong 模式（最多5轮）:                                 │
│   ┌──────────┐                    ┌──────────┐              │
│   │ Agent A  │ ◄─── ping-pong ───►│ Agent B  │              │
│   └──────────┘                    └──────────┘              │
│   通过 REPLY_SKIP 终止                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### sessions_list / sessions_history —— 会话管理

```typescript
// 列出会话
sessions_list({
  kinds?: ["main", "group", "cron", "hook", "node", "other"],
  limit?: number,
  activeMinutes?: number,  // 只显示N分钟内活跃的
  messageLimit?: number    // 包含最后N条消息
});

// 获取历史
sessions_history({
  sessionKey: string,
  limit?: number,
  includeTools?: boolean  // 是否包含工具调用
});
```

### 2.3 Announce 机制

**核心概念**：子代理完成后，通过 announce 步骤将结果报告回请求者通道。

```
┌─────────────────────────────────────────────────────────────┐
│                    Announce 流程                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   1. 子代理执行任务                                          │
│      └─► 产生 assistant reply 或 toolResult                 │
│                                                             │
│   2. Announce 步骤触发                                      │
│      ├─► 如果 assistant reply 为空 → 使用最新 toolResult    │
│      └─► 如果 reply == ANNOUNCE_SKIP → 静默                 │
│                                                             │
│   3. 结果规范化                                              │
│      {                                                      │
│        Status: "completed" | "failed" | "timeout",         │
│        Result: "...",                                       │
│        Notes: "runtime: 45s, tokens: 12k",                 │
│        sessionKey: "agent:main:subagent:abc123",           │
│        transcriptPath: "/path/to/transcript.jsonl"         │
│      }                                                      │
│                                                             │
│   4. 投递到请求者通道                                        │
│      └─► 通过 message 工具发送到原频道                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**源码关键点**（来自 GitHub Issue #30581）：

```typescript
// Announce 结果处理
interface AnnounceResult {
  Status: "completed successfully" | "failed" | "timed out";
  Result: string;  // assistant reply 或最新 toolResult
  Notes: string;   // 运行统计
}

// 多子代理场景的处理
// 问题：最后一个完成的子代理的 announce 可能被静默丢弃
// 原因：之前的 announce 包含"wait for remaining results"指令
// 解决：确保所有 announce 都被正确处理
```

### 2.4 任务编排模式

#### 模式一：协调者-专家模式（最可靠）

```
┌─────────────────────────────────────────────────────────────┐
│                    协调者-专家模式                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   配置示例：                                                │
│                                                             │
│   // 协调者配置                                             │
│   {                                                         │
│     id: "coordinator",                                      │
│     systemPrompt: `                                         │
│       你分解传入任务并通过 sessions_send 委派给专家代理。     │
│       你拥有 MEMORY.md。                                    │
│       汇总结果后再存储。                                     │
│       永不递归——如果专家把任务返回给你，汇总并关闭。          │
│     `,                                                      │
│     tools: ["sessions_send", "sessions_list",               │
│             "memory_search", "read", "write"]               │
│   }                                                         │
│                                                             │
│   // 专家配置                                               │
│   {                                                         │
│     id: "research-specialist",                              │
│     systemPrompt: `                                         │
│       你处理协调者委派的研究任务。                           │
│       完成任务，返回简洁摘要，然后停止。                     │
│     `,                                                      │
│     tools: ["web_search", "read", "write"],                 │
│     memory: { enabled: false }  // 关键：无状态             │
│   }                                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**关键约束**：
1. 专家无状态（`memory.enabled: false`）
2. 协调者永不递归接受任务
3. 防止无限循环

#### 模式二：并行派发模式

```typescript
// 并行派发多个子代理
async function parallelDispatch(tasks: string[]) {
  const results = [];
  
  // 同时派发所有任务
  const spawns = tasks.map(task => 
    sessions_spawn({ task, label: `parallel-${task.slice(0,10)}` })
  );
  
  // 等待所有结果
  for (const spawn of spawns) {
    // 通过 sessions_list 监控状态
    // 或等待 announce 通知
  }
  
  return results;
}
```

**问题**：多个并行子代理的 announce 可能竞争
**解决**：使用共享状态文件协调

#### 模式三：共享状态文件模式

```
共享工作区/
├── goal.md          # 当前任务和分解
├── plan.md          # 执行计划和子任务分配
├── status.md        # 子任务状态（pending/in-progress/completed）
└── log.md           # 追加式执行日志
```

**工作流**：
1. 协调者写入 `goal.md` 和 `plan.md`
2. 子代理读取并更新 `status.md`
3. 所有代理追加写入 `log.md`
4. 协调者监控并聚合

### 2.5 嵌套深度控制

```
┌─────────────────────────────────────────────────────────────┐
│                    嵌套深度限制                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Depth 0: agent:<id>:main                                  │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                    Main Agent                        │   │
│   │              (可派生子代理)                           │   │
│   └──────────────────────────┬──────────────────────────┘   │
│                              │                              │
│   Depth 1: agent:<id>:subagent:<uuid>                       │
│   ┌──────────────────────────┴──────────────────────────┐   │
│   │                   Sub-Agent                          │   │
│   │        (仅当 maxSpawnDepth >= 2 时可派生)             │   │
│   └──────────────────────────┬──────────────────────────┘   │
│                              │                              │
│   Depth 2: agent:<id>:subagent:<uuid>:subagent:<uuid>       │
│   ┌──────────────────────────┴──────────────────────────┐   │
│   │                 Sub-Sub-Agent                        │   │
│   │               (永远不能派生)                          │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**配置**：
```json5
{
  agents: {
    defaults: {
      subagents: {
        maxSpawnDepth: 2,         // 允许两层嵌套
        maxChildrenPerAgent: 5,   // 每代理最多5个活跃子代理
        maxConcurrent: 8,         // 全局并发上限
        runTimeoutSeconds: 900    // 超时设置
      }
    }
  }
}
```

### 2.6 现有机制的局限性

| 局限 | 说明 |
|------|------|
| **无法同级通信** | 子代理之间不能直接通信，必须通过父代理中转 |
| **状态不共享** | 每个子代理有独立上下文，无法共享进度 |
| **依赖管理困难** | 无法表达任务依赖关系，需手动协调 |
| **实时性差** | 只有完成后才能 announce，无法实时同步 |

---

## 第三部分：未来机制——Agent Teams RFC

### 3.1 RFC 概述

**RFC-0001: Agent Teams** 是 OpenClaw 的重大功能提案，旨在解决现有子代理模式的局限。

**核心改进**：

| 改进 | 说明 |
|------|------|
| **同级通信** | 队友可以直接通信 |
| **共享任务列表** | 支持依赖关系 |
| **实时消息** | Mailbox 机制 |
| **协调模式** | Normal / Delegate 两种模式 |

### 3.2 架构模型

```
┌─────────────────────────────────────────────────────────────┐
│                    Agent Teams 架构                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Team: "pr-142-review"                                     │
│   ├── Lead: 协调、综合、报告                                 │
│   ├── Teammate: security-reviewer                          │
│   ├── Teammate: performance-analyst                        │
│   └── Teammate: test-coverage-checker                      │
│                                                             │
│   共享状态:                                                 │
│   ├── tasks.json (任务列表 + 依赖)                          │
│   └── mailbox/ (Agent间消息)                                │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                    Team Lead                         │   │
│   │   ┌─────────────────────────────────────────────┐   │   │
│   │   │              Shared Task List                │   │   │
│   │   │  ┌─────────┬─────────┬─────────┐            │   │   │
│   │   │  │ Task-1  │ Task-2  │ Task-3  │            │   │   │
│   │   │  │completed│in-prog  │blocked  │            │   │   │
│   │   │  └─────────┴─────────┴─────────┘            │   │   │
│   │   └─────────────────────────────────────────────┘   │   │
│   └──────────────────────────┬──────────────────────────┘   │
│                              │                              │
│         ┌────────────────────┼────────────────────┐        │
│         │                    │                    │        │
│   ┌─────▼─────┐        ┌─────▼─────┐        ┌─────▼─────┐  │
│   │Teammate 1 │◄──────►│Teammate 2 │◄──────►│Teammate 3 │  │
│   │  security │        │   perf    │        │   test    │  │
│   └───────────┘        └───────────┘        └───────────┘  │
│         │                    │                    │        │
│         └────────────────────┴────────────────────┘        │
│                              │                              │
│                        Mailbox                              │
│                   (Agent间异步消息)                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 核心概念

#### Team（团队）

```typescript
interface Team {
  teamId: string;          // UUID
  teamName: string;        // 人类可读名称
  lead: SessionKey;        // Team Lead 会话
  teammates: Teammate[];   // 队友列表
  taskList: TaskList;      // 共享任务列表
  mailbox: Mailbox;        // 消息邮箱
  coordinationMode: "normal" | "delegate";
}
```

#### Task List（任务列表）

```typescript
interface Task {
  taskId: string;
  title: string;
  description: string;
  status: "pending" | "blocked" | "claimed" | "in-progress" | "completed" | "failed";
  dependsOn: string[];     // 依赖的任务ID
  assignee?: string;       // 分配给哪个队友
  priority: "low" | "normal" | "high" | "critical";
  metadata?: Record<string, unknown>;
}
```

**依赖解析**：

```typescript
// 检查是否被阻塞
function isBlocked(task: Task, allTasks: Map<string, Task>): boolean {
  for (const depId of task.dependsOn) {
    const dep = allTasks.get(depId);
    if (!dep || dep.status !== "completed") {
      return true;
    }
  }
  return false;
}

// 任务完成时自动解锁依赖任务
function onTaskComplete(completedTaskId: string, team: Team): string[] {
  const unblocked: string[] = [];
  
  for (const task of team.tasks.values()) {
    if (task.status === "blocked" && !isBlocked(task, team.tasks)) {
      task.status = "pending";
      unblocked.push(task.taskId);
    }
  }
  
  // 广播解锁通知
  if (unblocked.length > 0) {
    broadcast(team, `Tasks unblocked: ${unblocked.join(", ")}`);
  }
  
  return unblocked;
}
```

#### Mailbox（邮箱）

```typescript
interface Mailbox {
  // 点对点消息
  sendMessage(params: {
    teamId: string;
    to: string;  // teammateId
    message: string;
    priority?: "normal" | "urgent";
    waitForReply?: boolean;
  }): Promise<MessageResult>;
  
  // 广播消息
  broadcast(params: {
    teamId: string;
    message: string;
    priority?: "normal" | "urgent";
    excludeSelf?: boolean;
  }): Promise<BroadcastResult>;
}
```

### 3.4 新工具集

| 工具 | 功能 |
|------|------|
| `team_create` | 创建团队 |
| `team_status` | 获取团队状态 |
| `teammate_spawn` | 派生队友 |
| `teammate_message` | 发送点对点消息 |
| `teammate_broadcast` | 广播消息 |
| `teammate_shutdown` | 关闭队友 |
| `task_add` | 添加任务 |
| `task_claim` | 认领任务 |
| `task_complete` | 完成任务 |
| `task_list` | 列出任务 |

### 3.5 协调模式

#### Normal Mode（普通模式）

```
Lead 可以:
• 派生队友
• 认领并执行任务
• 参与实现

适用场景：Lead 想参与实现的同时协调
```

#### Delegate Mode（委托模式）

```
Lead 只能:
• 派生队友
• 管理任务（添加、优先级、分配）
• 消息队友
• 不能认领任务
• 不能使用实现工具

适用场景：复杂项目，Lead 专注于大图景协调
```

### 3.6 使用示例

```typescript
// 1. 创建团队
const team = await team_create({
  teamName: "pr-142-security-review",
  description: "Comprehensive security review of PR #142",
  maxTeammates: 3,
  coordinationMode: "normal"
});

// 2. 添加任务
await task_add({
  teamId: team.teamId,
  title: "Analyze authentication flow",
  priority: "high"
});

await task_add({
  teamId: team.teamId,
  title: "Implement rate limiting",
  dependsOn: ["task-001"],  // 依赖前一个任务
  priority: "high"
});

// 3. 派生队友
await teammate_spawn({
  teamId: team.teamId,
  role: "security-reviewer",
  task: "Analyze PR #142 for security vulnerabilities...",
  model: "anthropic/claude-sonnet-4-5"
});

await teammate_spawn({
  teamId: team.teamId,
  role: "implementer",
  task: "Implement fixes based on security findings...",
  model: "anthropic/claude-sonnet-4-5"
});

// 4. 队友通信
await teammate_message({
  teamId: team.teamId,
  to: "implementer",
  message: "Found critical vulnerability in auth flow, see task-001"
});

// 5. 监控状态
const status = await team_status({
  teamId: team.teamId,
  includeTaskList: true
});
```

---

## 第四部分：两种机制对比

### 4.1 架构对比

| 维度 | sessions_spawn | Agent Teams |
|------|---------------|-------------|
| **结构** | 树状层级 | 扁平团队 |
| **通信** | 仅父子 | 任意队友 |
| **状态** | 独立 | 共享任务列表 |
| **依赖** | 手动协调 | 内置支持 |
| **实时性** | announce 后 | 实时消息 |
| **成熟度** | 已发布 | RFC阶段 |

### 4.2 适用场景对比

```
┌─────────────────────────────────────────────────────────────┐
│                    场景选择决策树                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   需要同级Agent通信？                                        │
│        │                                                    │
│   ┌────┴────┐                                               │
│   ▼         ▼                                               │
│  是        否                                                │
│   │         │                                               │
│   │         └─► 使用 sessions_spawn                         │
│   │              • 简单任务派发                              │
│   │              • 独立子任务                                │
│   │              • 无需协调                                  │
│   │                                                        │
│   └─► Agent Teams 可用？                                    │
│        │                                                    │
│   ┌────┴────┐                                               │
│   ▼         ▼                                               │
│  是        否                                                │
│   │         │                                               │
│   │         └─► 使用 sessions_spawn + 共享文件              │
│   │              • 文件协调                                  │
│   │              • 状态同步                                  │
│   │                                                        │
│   └─► 使用 Agent Teams                                      │
│        • 复杂依赖                                           │
│        • 实时协作                                           │
│        • 多角色协调                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.3 实现复杂度对比

| 维度 | sessions_spawn | Agent Teams |
|------|---------------|-------------|
| **配置复杂度** | 低 | 中 |
| **学习曲线** | 平缓 | 较陡 |
| **调试难度** | 低 | 中 |
| **错误处理** | 简单 | 复杂 |
| **扩展性** | 有限 | 强 |

---

## 第五部分：最佳实践

### 5.1 使用 sessions_spawn 的最佳实践

#### 1. 协调者-专家模式

```json5
// 协调者配置
{
  id: "coordinator",
  systemPrompt: `
    你是一个任务协调者。
    
    规则：
    1. 分解任务，通过 sessions_spawn 派发
    2. 汇总结果，写入 MEMORY.md
    3. 永不接受从专家返回的任务——汇总并关闭
    4. 监控子代理状态，处理超时
  `,
  tools: {
    allow: ["sessions_spawn", "sessions_list", "memory_search", "read", "write"]
  }
}

// 专家配置
{
  id: "specialist",
  systemPrompt: `
    你是一个专家代理。
    
    规则：
    1. 完成分配的任务
    2. 返回简洁结果
    3. 不要派发子任务
  `,
  tools: {
    allow: ["exec", "read", "write", "edit"]
  },
  memory: { enabled: false }
}
```

#### 2. 并行任务处理

```typescript
// 派发多个并行子代理
async function parallelTasks(tasks: Task[]) {
  // 同时派发
  const spawns = tasks.map(t => 
    sessions_spawn({ task: t.description, label: t.id })
  );
  
  // 使用 sessions_list 监控
  const monitor = setInterval(async () => {
    const sessions = await sessions_list({ kinds: ["other"] });
    const active = sessions.filter(s => 
      s.key.startsWith("agent:main:subagent:")
    );
    console.log(`Active: ${active.length}`);
  }, 5000);
  
  // 等待所有完成（通过 announce）
  // ...
}
```

#### 3. 共享状态协调

```markdown
<!-- status.md 示例 -->
# 任务状态

## Task-1: 数据收集
- 状态: completed
- 负责人: researcher-1
- 结果: 见 /output/data.json

## Task-2: 数据分析
- 状态: in-progress
- 负责人: analyst-1
- 开始时间: 2026-03-08 14:00

## Task-3: 报告生成
- 状态: blocked
- 依赖: Task-2
```

### 5.2 防止常见失败模式

#### 无限递归循环

**症状**：协调者 → 专家 → 协调者 → ...

**解决**：

```json5
// 配置阻止
{
  agents: {
    list: [{
      id: "specialist",
      tools: {
        deny: ["sessions_send"]  // 专家不能发消息给协调者
      }
    }]
  }
}

// 或在提示中强制
systemPrompt: `
  永不将任务返回给协调者。
  如果需要更多信息，返回结构化请求。
`
```

#### 共享状态死锁

**症状**：Agent A 等待 Agent B，Agent B 等待 Agent A

**解决**：

```typescript
// 使用超时
sessions_spawn({
  task: "...",
  runTimeoutSeconds: 300  // 5分钟超时
});

// 定期检查
setInterval(() => {
  sessions_list({ activeMinutes: 10 }).then(sessions => {
    const stuck = sessions.filter(s => s.abortedLastRun);
    // 处理卡住的会话
  });
}, 60000);
```

#### Announce 竞争

**症状**：多个子代理的 announce 丢失

**解决**：

```typescript
// 使用共享文件协调 announce
// 每个子代理完成后写入完成状态
await write({
  path: "status/complete-${taskId}.md",
  content: `Completed at ${new Date().toISOString()}`
});

// 协调者轮询检查
while (true) {
  const completed = await read({ path: "status/" });
  if (allTasksComplete(completed)) break;
  await sleep(5000);
}
```

---

## 第六部分：配置参考

### 6.1 子代理配置

```json5
{
  agents: {
    defaults: {
      subagents: {
        // 嵌套深度
        maxSpawnDepth: 2,
        
        // 每代理最大子代理数
        maxChildrenPerAgent: 5,
        
        // 全局并发上限
        maxConcurrent: 8,
        
        // 默认超时
        runTimeoutSeconds: 900,
        
        // 自动归档时间（分钟）
        archiveAfterMinutes: 60,
        
        // 子代理工具配置
        tools: {
          // 默认允许的工具
          allow: ["read", "write", "edit", "exec", "web_search"],
          // 默认拒绝的工具
          deny: ["sessions_spawn", "sessions_send", "message"]
        }
      }
    }
  }
}
```

### 6.2 Agent-to-Agent 配置

```json5
{
  tools: {
    agentToAgent: {
      // 启用Agent间通信
      enabled: true,
      
      // 允许通信的Agent白名单
      allow: ["main", "research", "coding"],
      
      // Ping-Pong 最大轮次
      maxPingPongTurns: 5
    }
  }
}
```

### 6.3 多Agent路由配置

```json5
{
  agents: {
    list: [
      {
        id: "main",
        default: true,
        workspace: "~/.openclaw/workspace-main"
      },
      {
        id: "research",
        workspace: "~/.openclaw/workspace-research"
      },
      {
        id: "coding",
        workspace: "~/.openclaw/workspace-coding"
      }
    ]
  },
  
  // 绑定规则（按优先级排序）
  bindings: [
    {
      agentId: "coding",
      match: { channel: "discord", accountId: "coding" }
    },
    {
      agentId: "research",
      match: { channel: "telegram", accountId: "research" }
    },
    {
      agentId: "main",
      match: { channel: "*" }  // 默认
    }
  ]
}
```

---

## 第七部分：总结

### 7.1 核心答案

**问题**：OpenClaw 如何解决任务编排和Agent间通信？

**答案**：

| 维度 | 当前方案 | 未来方案（RFC） |
|------|----------|-----------------|
| **任务编排** | 协调者模式 + 共享文件 | Team + Task List |
| **Agent间通信** | sessions_send（仅父子） | Mailbox（任意队友） |
| **状态共享** | 文件系统 | 内置共享状态 |
| **依赖管理** | 手动协调 | 内置依赖解析 |

### 7.2 选择指南

```
简单独立任务 ──────────► sessions_spawn
        │
        │ 需要协调
        ▼
协调者-专家模式 ─────────► sessions_spawn + sessions_send
        │
        │ 需要同级通信
        ▼
共享文件模式 ───────────► sessions_spawn + 文件状态
        │
        │ Agent Teams 发布后
        ▼
Agent Teams ─────────────► team_* + task_* + teammate_*
```

### 7.3 关键洞察

1. **现有机制够用但不完美**
   - sessions_spawn 适合简单派发
   - 复杂协作需要手动协调
   - 同级通信是主要痛点

2. **Agent Teams 是正确方向**
   - 扁平化团队结构
   - 共享状态 + 依赖管理
   - 实时消息通信

3. **设计哲学**
   - 会话隔离保证安全
   - 工具权限控制能力边界
   - 文件系统作为后备协调层

---

## 参考文献

1. OpenClaw Session Tools Documentation - https://docs.openclaw.ai/concepts/session-tool
2. OpenClaw Sub-Agents Documentation - https://docs.openclaw.ai/tools/subagents
3. OpenClaw Multi-Agent Routing - https://docs.openclaw.ai/concepts/multi-agent
4. RFC: Agent Teams - GitHub Discussion #10036
5. OpenClaw Session Management - https://docs.openclaw.ai/concepts/session
6. Multi-agent coordination patterns - LumaDock Tutorial

---

**报告编号**: 2026-03-08-OpenClaw多Agent协作研究  
**研究团队**: 卷王小组  
**版本**: v1.0  
**生成时间**: 2026年3月8日