# OpenClaw ACP 深度研究报告

> **版本**: v1.0
> **日期**: 2026-03-23
> **作者**: 黄山 (wairesearch) · 卷王小组
> **研究范围**: ACP 协议规范 + OpenClaw ACP 实现 + 架构演进计划

---

## 目录

1. [ACP 是什么：从协议到价值](#1-acp-是什么从协议到价值)
2. [协议架构与核心概念](#2-协议架构与核心概念)
3. [OpenClaw 的 ACP 实现](#3-openclaw-的-acp-实现)
4. [ACP vs Sub-agents：何时用哪个](#4-acp-vs-sub-agents何时用哪个)
5. [核心场景与用法](#5-核心场景与用法)
6. [架构演进：从当前到 Holy Grail](#6-架构演进从当前到-holy-grail)
7. [最佳实践](#7-最佳实践)
8. [安全模型与限制](#8-安全模型与限制)
9. [生态全景](#9-生态全景)
10. [对 SaaS 平台的启示](#10-对-saas-平台的启示)

---

## 1. ACP 是什么：从协议到价值

### 1.1 定义

**Agent Client Protocol (ACP)** 是一个标准化的通信协议，定义了**代码编辑器/IDE（Client）**与**AI 编码代理（Agent）**之间的交互方式。

一句话理解：**ACP 之于 AI 编码代理，就像 LSP 之于语言服务器。**

| 类比 | 标准化的问题 | 解决方式 |
|------|-------------|---------|
| **LSP** | 每个编辑器要为每种语言写专用集成 | 统一语言服务协议 |
| **MCP** | 每个 Agent 要为每个数据源写专用集成 | 统一工具/数据访问协议 |
| **ACP** | 每个编辑器要为每个 AI Agent 写专用集成 | 统一 Agent-编辑器通信协议 |

### 1.2 ACP 解决的核心问题

**没有 ACP 之前：**

```
Zed 编辑器 ──专用集成──→ Codex
Zed 编辑器 ──专用集成──→ Claude Code
Zed 编辑器 ──专用集成──→ Gemini CLI
VS Code   ──专用集成──→ Codex
VS Code   ──专用集成──→ Claude Code
...

N 个编辑器 × M 个 Agent = N×M 个专用集成
```

**有 ACP 之后：**

```
Zed 编辑器 ──ACP──┐
VS Code   ──ACP──┤
JetBrains ──ACP──┤──→ 任何 ACP 兼容 Agent
Terminal  ──ACP──┤
OpenClaw  ──ACP──┘

N 个 Client + M 个 Agent = N+M 个实现
```

### 1.3 ACP 的三层价值

| 层级 | 价值 | 说明 |
|------|------|------|
| **互操作性** | 编辑器和 Agent 解耦 | 任何 ACP Client 可以连接任何 ACP Agent |
| **UX 标准化** | 流式输出、工具调用、权限审批统一 | 用户在不同编辑器中获得一致的 Agent 交互体验 |
| **生态效应** | 开发者自由选择 | 不被特定编辑器或 Agent 锁定 |

### 1.4 ACP 与 MCP 的关系

ACP 和 MCP 是**互补**关系，不是竞争：

| 维度 | MCP | ACP |
|------|-----|-----|
| **解决什么** | Agent 能访问什么数据和工具 | Agent 在工作流中的位置 |
| **通信方向** | Agent → 外部服务/数据源 | Editor ↔ Agent |
| **类比** | USB 接口（连接外设） | 显示协议（连接显示器） |

典型协作场景：

```
用户 ──ACP──→ Agent ──MCP──→ 数据库/API/文件系统
        ↑                      ↑
   交互协议               工具访问协议
```

---

## 2. 协议架构与核心概念

### 2.1 通信模型

ACP 基于 **JSON-RPC 2.0** 协议，支持两种消息类型：

- **Methods（方法）**：请求-响应模式，期望返回结果或错误
- **Notifications（通知）**：单向消息，无需响应（用于流式更新）

### 2.2 传输层

| 场景 | 传输方式 | 说明 |
|------|---------|------|
| **本地 Agent** | JSON-RPC over stdio | Agent 作为编辑器的子进程运行 |
| **远程 Agent** | HTTP / WebSocket | Agent 托管在云端或远程服务器（规范进行中） |

### 2.3 核心交互流程

```
Phase 1: 初始化
  Client → Agent: initialize (版本协商 + 能力交换)
  Client → Agent: authenticate (如果 Agent 需要认证)

Phase 2: 会话建立
  Client → Agent: session/new (创建新会话)
  或
  Client → Agent: session/load (恢复已有会话)

Phase 3: 对话轮次（可重复）
  Client → Agent: session/prompt (发送用户消息)
  Agent → Client: session/update (流式进度通知，多次)
    ├── 文本块（agent/user/thought）
    ├── 工具调用和更新
    ├── 执行计划
    └── 模式变更
  Agent → Client: session/request_permission (请求权限审批)
  Client → Agent: session/cancel (中断处理，可选)
  Agent → Client: session/prompt response (轮次结束 + 停止原因)
```

### 2.4 Agent 端方法

| 方法 | 类型 | 说明 |
|------|------|------|
| `initialize` | 必选 | 版本协商和能力交换 |
| `authenticate` | 必选 | Agent 认证（如需要） |
| `session/new` | 必选 | 创建新会话 |
| `session/prompt` | 必选 | 发送用户 prompt |
| `session/load` | 可选 | 恢复已有会话（需 `loadSession` 能力） |
| `session/set_mode` | 可选 | 切换 Agent 操作模式 |
| `session/cancel` | 通知 | 取消正在进行的操作 |

### 2.5 Client 端方法

| 方法 | 类型 | 说明 |
|------|------|------|
| `session/request_permission` | 必选 | 请求工具调用权限 |
| `fs/read_text_file` | 可选 | 读取文件内容 |
| `fs/write_text_file` | 可选 | 写入文件内容 |
| `terminal/create` | 可选 | 创建终端 |
| `terminal/output` | 可选 | 获取终端输出 |
| `terminal/kill` | 可选 | 终止终端命令 |

### 2.6 设计原则

1. **MCP 友好**：基于 JSON-RPC，尽量复用 MCP 类型定义
2. **UX 优先**：面向 Agent 交互的 UX 挑战设计，文本格式默认 Markdown
3. **信任模型**：假设用户信任所使用的 Agent，Agent 通过 Client 访问本地文件和 MCP 服务

---

## 3. OpenClaw 的 ACP 实现

### 3.1 OpenClaw 在 ACP 生态中的双重角色

OpenClaw 同时扮演 **ACP Agent** 和 **ACP Client** 两个角色：

**作为 ACP Agent（被连接）：**

```
Zed / VS Code / JetBrains
        │
        │ ACP over stdio
        ↓
  openclaw acp (ACP Bridge)
        │
        │ WebSocket
        ↓
  OpenClaw Gateway (会话路由)
        │
        ↓
  OpenClaw Agent (LLM + Tools)
```

**作为 ACP Client（去连接）：**

```
用户 → OpenClaw Agent
          │
          │ sessions_spawn(runtime: "acp")
          ↓
    ACP Session Manager
          │
          │ acpx backend
          ↓
    Codex / Claude Code / Gemini CLI / OpenCode / Kimi CLI
```

### 3.2 ACP Bridge 模式（OpenClaw 作为 Agent）

`openclaw acp` 命令启动一个 ACP Bridge，通过 stdio 对接 IDE，通过 WebSocket 对接 Gateway：

```bash
# 基本用法
openclaw acp

# 连接远程 Gateway
openclaw acp --url wss://gateway-host:18789 --token-file ~/.openclaw/gateway.token

# 绑定特定会话
openclaw acp --session agent:main:main
```

**兼容性矩阵：**

| ACP 功能 | 状态 | 说明 |
|---------|------|------|
| `initialize`, `newSession`, `prompt`, `cancel` | ✅ 已实现 | 核心桥接流程 |
| `listSessions`, slash commands | ✅ 已实现 | 通过 `available_commands_update` 通告 |
| `loadSession` | ⚠️ 部分 | 重放文本历史，不含工具/系统历史 |
| Prompt content (text, resource, images) | ⚠️ 部分 | 文本/资源展平，图片转附件 |
| Session modes | ⚠️ 部分 | 支持 thought level, reasoning, elevated 等 |
| Tool streaming | ⚠️ 部分 | 包含 I/O 和文件位置，无终端/diff |
| 每会话 MCP 服务 | ❌ 不支持 | 需在 Gateway/Agent 级别配置 |
| 客户端文件系统方法 | ❌ 不支持 | Bridge 不调用 `fs/*` 方法 |

**在 Zed 中配置：**

```json
{
  "agent_servers": {
    "OpenClaw ACP": {
      "type": "custom",
      "command": "openclaw",
      "args": ["acp"],
      "env": {}
    }
  }
}
```

### 3.3 ACP Runtime 模式（OpenClaw 作为 Client）

这是 OpenClaw 最常用的 ACP 模式——通过 `sessions_spawn` 或 `/acp spawn` 启动外部编码 Agent：

**支持的 Agent（acpx 内置）：**

| Agent | 命令 | 典型用途 |
|-------|------|---------|
| `pi` | Pi Agent | 通用 AI 助手 |
| `claude` | Claude Code | 代码生成和重构 |
| `codex` | Codex CLI | OpenAI 编码代理 |
| `opencode` | OpenCode | 开源编码代理 |
| `gemini` | Gemini CLI | Google 编码代理 |
| `kimi` | Kimi CLI | 月之暗面编码代理 |

**核心配置：**

```json
{
  "acp": {
    "enabled": true,
    "backend": "acpx",
    "defaultAgent": "codex",
    "allowedAgents": ["pi", "claude", "codex", "opencode", "gemini", "kimi"],
    "maxConcurrentSessions": 8,
    "stream": {
      "coalesceIdleMs": 300,
      "maxChunkChars": 1200
    },
    "runtime": {
      "ttlMinutes": 120
    }
  }
}
```

### 3.4 ACP 会话生命周期

```
创建 → 空闲 → 运行中 → 空闲 → ... → 关闭
              ↓            ↓
           取消中 →→→ 空闲/错误
```

**会话状态机：**

| 状态 | 含义 | 可转换到 |
|------|------|---------|
| `creating` | 正在初始化 | `idle` |
| `idle` | 等待输入 | `running`, `closed` |
| `running` | 正在处理 prompt | `idle`, `cancelling` |
| `cancelling` | 正在取消 | `idle`, `error` |
| `error` | 出错 | `idle`, `closed` |
| `closed` | 已关闭 | （终态） |

**运行状态机：**

| 状态 | 含义 | 可转换到 |
|------|------|---------|
| `queued` | 排队等待 | `running`, `cancelled` |
| `running` | 执行中 | `completed`, `failed`, `cancelled` |
| `completed` | 完成 | （终态） |
| `failed` | 失败 | （终态） |
| `cancelled` | 已取消 | （终态） |

---

## 4. ACP vs Sub-agents：何时用哪个

### 4.1 核心区别

| 维度 | ACP 会话 | Sub-agent |
|------|---------|-----------|
| **运行时** | 外部 Agent 进程（如 Codex、Claude Code） | OpenClaw 内部 Agent |
| **Session Key** | `agent:<id>:acp:<uuid>` | `agent:<id>:subagent:<uuid>` |
| **执行环境** | 主机进程（非沙箱） | 可沙箱化 |
| **用途** | 调用专业编码工具 | 委派子任务（研究、分析等） |
| **持久性** | 支持持久会话 + 线程绑定 | 通常一次性运行 |
| **命令族** | `/acp ...` | `/subagents ...` |
| **工具接口** | `sessions_spawn(runtime: "acp")` | `sessions_spawn`（默认） |

### 4.2 选择矩阵

| 场景 | 推荐 | 原因 |
|------|------|------|
| 让 Codex 修复 bug | ✅ ACP | 需要专业编码 Agent 的能力 |
| 让 Claude Code 重构模块 | ✅ ACP | 需要持久的编码会话 |
| 搜索和总结信息 | ✅ Sub-agent | OpenClaw 内部工具即可 |
| 并行执行多个研究任务 | ✅ Sub-agent | 轻量、隔离、自动汇报 |
| 在 Discord 线程中持续编码 | ✅ ACP | 线程绑定 + 持久会话 |
| 需要沙箱隔离执行 | ✅ Sub-agent | ACP 不支持沙箱 |
| IDE 中使用 OpenClaw | ✅ ACP Bridge | 标准 ACP 接口 |

### 4.3 嵌套与组合

```
Main Agent (OpenClaw)
  ├── Sub-agent: 研究任务 (OpenClaw 内部)
  ├── Sub-agent: 数据分析 (OpenClaw 内部)
  └── ACP Session: Codex (外部编码 Agent)
       └── 在独立进程中运行，通过 acpx 通信
```

Sub-agent 支持嵌套（`maxSpawnDepth: 2`），ACP 不支持嵌套但支持持久会话。

---

## 5. 核心场景与用法

### 5.1 场景一：聊天中一键启动编码代理

**自然语言触发：**

```
用户：帮我用 Codex 修复这个 bug
```

OpenClaw 自动识别并路由到 ACP：

```json
{
  "task": "修复 src/utils/parser.ts 中的空指针异常",
  "runtime": "acp",
  "agentId": "codex",
  "mode": "run"
}
```

### 5.2 场景二：持久线程绑定编码会话

**在 Discord/Telegram 中：**

```
/acp spawn codex --mode persistent --thread auto --cwd /workspace/my-project
```

效果：
1. 创建新线程（或绑定当前线程）
2. 后续线程内消息自动路由到 Codex
3. Codex 的输出流式返回到线程
4. 会话持久化，可跨多次交互

### 5.3 场景三：恢复之前的编码会话

```json
{
  "task": "继续修复剩余的测试失败",
  "runtime": "acp",
  "agentId": "codex",
  "resumeSessionId": "<previous-session-id>"
}
```

使用场景：
- 从笔记本切换到手机继续工作
- 恢复因网关重启中断的会话
- 从 CLI 交互式会话切换到无头模式

### 5.4 场景四：配置持久绑定的专属工作空间

将 Discord 频道或 Telegram 话题永久绑定到特定 Agent：

```json
{
  "agents": {
    "list": [
      {
        "id": "codex",
        "runtime": {
          "type": "acp",
          "acp": {
            "agent": "codex",
            "backend": "acpx",
            "mode": "persistent",
            "cwd": "/workspace/repo-a"
          }
        }
      }
    ]
  },
  "bindings": [
    {
      "type": "acp",
      "agentId": "codex",
      "match": {
        "channel": "discord",
        "accountId": "default",
        "peer": { "kind": "channel", "id": "222222222222222222" }
      },
      "acp": { "label": "codex-main" }
    },
    {
      "type": "acp",
      "agentId": "codex",
      "match": {
        "channel": "telegram",
        "accountId": "default",
        "peer": { "kind": "group", "id": "-1001234567890:topic:42" }
      }
    }
  ]
}
```

效果：
- `#codex-main` 频道中的所有消息自动路由到 Codex
- Telegram 话题 42 中的消息路由到绑定的 Codex 会话
- `/new` 和 `/reset` 在绑定内重置会话但保持绑定

### 5.5 场景五：IDE 集成（Zed/JetBrains）

在 IDE 中使用 OpenClaw 作为 ACP Agent：

```json
{
  "agent_servers": {
    "OpenClaw ACP": {
      "type": "custom",
      "command": "openclaw",
      "args": [
        "acp",
        "--url", "wss://gateway-host:18789",
        "--token-file", "~/.openclaw/gateway.token",
        "--session", "agent:design:main"
      ]
    }
  }
}
```

在 IDE 的 Agent 面板中选择 "OpenClaw ACP" 即可开始对话。

---

## 6. 架构演进：从当前到 Holy Grail

### 6.1 当前架构

```
OpenClaw Gateway
  │
  ├── 正常会话路由（main, group, cron, hook）
  │
  ├── Sub-agent 运行时
  │     └── 内部 Agent 进程
  │
  └── ACP 运行时
        ├── ACP Session Manager (内存状态)
        ├── Session Metadata (存储在 SessionEntry.acp)
        └── acpx Backend Plugin
              └── acpx CLI → Codex/Claude/Gemini 进程
```

**当前局限：**

- ACP 状态存储在通用 Session JSON 中（非专用存储）
- 流式输出有三条独立管线（main/subagent/acp），行为不一致
- 崩溃恢复依赖内存状态，重启后可能丢失绑定
- 幂等性保证不足，可能出现重复输出

### 6.2 Holy Grail 目标架构

OpenClaw 团队规划了三大架构重构计划：

#### 计划一：统一流式管线

**目标：** 一条共享的流式处理管线服务所有运行时（main、subagent、ACP）。

```
Runtime Adapters (main/subagent/acp)
  │  发射标准化事件
  ↓
Shared Stream Assembler (合并、去重、分块)
  │
  ↓
Shared Channel Projector (频道特定格式化)
  │
  ↓
Shared Delivery Ledger (幂等发送、检查点、重放)
  │
  ↓
Outbound Channel Adapter (物理发送)
```

**标准事件合约：**

| 事件 | 含义 |
|------|------|
| `turn_started` | 轮次开始 |
| `text_delta` | 文本增量 |
| `block_final` | 块最终版本 |
| `tool_started` | 工具调用开始 |
| `tool_finished` | 工具调用完成 |
| `status` | 状态变更 |
| `turn_completed` | 轮次完成 |
| `turn_failed` | 轮次失败 |
| `turn_cancelled` | 轮次取消 |

**收益：** 统一修 bug，统一行为，统一崩溃恢复。

#### 计划二：ACP 控制平面（Holy Grail）

**目标：** 将 ACP 从"插件级功能"提升为"核心控制平面"。

**核心设计：**

```
ACP Session Manager (单例，每 session 一个 Actor)
  │
  ├── ACP SQLite Store (WAL 模式)
  │     ├── acp_sessions     (会话状态)
  │     ├── acp_runs          (运行状态)
  │     ├── acp_bindings      (线程绑定)
  │     ├── acp_events        (事件日志，追加写)
  │     ├── acp_delivery_checkpoint (投递检查点)
  │     └── acp_idempotency   (幂等键)
  │
  ├── Per-Session Actor (序列化命令执行)
  │     ├── submit / cancel / close 串行处理
  │     ├── 运行时 handle 管理
  │     └── 事件有序写入
  │
  └── Runtime Backend (可插拔)
        └── acpx (第一个后端)
```

**关键不变量：**

1. 每个 ACP 线程绑定必须引用有效的 ACP 会话记录
2. 每个 ACP 会话有显式生命周期状态
3. spawn + bind + 初始 enqueue 是原子操作
4. 命令重试是幂等的（不产生重复运行或输出）
5. 绑定线程的输出是 ACP 运行事件的投影，而非临时副作用

**核心运行时合约：**

```typescript
interface AcpRuntime {
  ensureSession(input): Promise<AcpRuntimeHandle>;
  submit(input): Promise<{ runtimeRunId: string }>;
  stream(input): Promise<void>;
  cancel(input): Promise<void>;
  close(input): Promise<void>;
  health?(): Promise<{ ok: boolean; details?: string }>;
}
```

#### 计划三：持久绑定（Discord 频道 + Telegram 话题）

**目标：** 将临时线程绑定扩展为可配置的持久对话绑定。

**两种绑定类型：**

| 类型 | 存储 | 生命周期 | 用途 |
|------|------|---------|------|
| **持久绑定** | 配置文件 `bindings[]` | 启动时恢复 | 命名工作空间频道/话题 |
| **临时绑定** | 内存 | 空闲/最大年龄过期 | 临时 spawn |

**配置优先级：**

```
bindings[].acp.* (绑定级覆盖)
  ↓
agents.list[].runtime.acp.* (Agent 级默认)
  ↓
acp.* (全局默认)
```

### 6.3 实施路线图

| 阶段 | 内容 | 状态 |
|------|------|------|
| Phase 0 | ADR + Schema 冻结 | 已完成部分 |
| Phase 1 | 控制平面基础（Manager + Actor + SQLite） | 规划中 |
| Phase 2 | 核心路由和生命周期集成 | 规划中 |
| Phase 3 | acpx 后端适配器/插件 | 已完成（当前实现） |
| Phase 4 | 投递投影和频道 UX（Discord 优先） | 进行中 |
| Phase 5 | 迁移和切换 | 规划中 |
| Phase 6 | 加固、SLO、规模限制 | 规划中 |

已完成的重构（Addendum）：
- ✅ 集中化 ACP dispatch 策略评估
- ✅ ACP 命令处理器按子命令领域拆分
- ✅ ACP Session Manager 按职责拆分

---

## 7. 最佳实践

### 7.1 配置最佳实践

**1. 始终显式设置 `acp.allowedAgents`**

```json
{
  "acp": {
    "allowedAgents": ["codex", "claude"]
  }
}
```

不要使用通配符，仅允许需要的 Agent。

**2. 设置合理的并发限制**

```json
{
  "acp": {
    "maxConcurrentSessions": 4
  }
}
```

每个 ACP 会话是一个独立进程，消耗 CPU 和内存。

**3. 配置权限模式**

```bash
# 推荐：自动批准所有操作（无头模式必须）
openclaw config set plugins.entries.acpx.config.permissionMode approve-all

# 如果需要限制，使用 deny 而非 fail
openclaw config set plugins.entries.acpx.config.nonInteractivePermissions deny
```

**4. 为 ACP Agent 配置独立工作空间**

```json
{
  "agents": {
    "list": [
      {
        "id": "codex",
        "workspace": "~/.openclaw/workspace-codex",
        "runtime": {
          "type": "acp",
          "acp": {
            "agent": "codex",
            "cwd": "/workspace/my-project"
          }
        }
      }
    ]
  }
}
```

### 7.2 运维最佳实践

**1. 使用 `/acp doctor` 检查健康状态**

```text
/acp doctor
```

验证后端插件安装、配置、版本匹配。

**2. 使用 `/acp status` 监控会话**

```text
/acp status
/acp sessions
```

**3. 设置流式输出参数避免频道限流**

```json
{
  "acp": {
    "stream": {
      "coalesceIdleMs": 300,
      "maxChunkChars": 1200
    }
  }
}
```

**4. 处理权限错误**

| 症状 | 原因 | 修复 |
|------|------|------|
| `AcpRuntimeError: Permission prompt unavailable` | `permissionMode` 阻止了写/执行 | 设置 `permissionMode=approve-all` |
| ACP 会话提前结束 | 权限被 `nonInteractivePermissions=fail` 阻止 | 改为 `deny`（优雅降级） |

### 7.3 使用模式最佳实践

**1. 一次性任务用 `mode: "run"`**

```json
{
  "task": "修复这个 bug",
  "runtime": "acp",
  "agentId": "codex",
  "mode": "run"
}
```

**2. 多轮交互用持久会话 + 线程绑定**

```text
/acp spawn codex --mode persistent --thread auto
```

**3. 不要在沙箱会话中启动 ACP**

ACP 在主机进程运行，沙箱会话中的 ACP spawn 会被拒绝。如需隔离，使用 Sub-agent。

**4. 优先使用自然语言触发**

直接告诉 Agent：

```
帮我用 Claude Code 重构 src/utils/ 目录
```

OpenClaw 会自动选择 `runtime: "acp"` 并路由到正确的 Agent。

---

## 8. 安全模型与限制

### 8.1 安全边界

| 维度 | ACP 会话 | Sub-agent |
|------|---------|-----------|
| **执行环境** | 主机进程 | 可选沙箱 |
| **文件访问** | Agent 的 `cwd` 目录 | 受沙箱策略限制 |
| **网络访问** | 完全访问 | 可限制 |
| **权限模型** | `permissionMode` + `nonInteractivePermissions` | 工具策略 |

### 8.2 关键限制

1. **无沙箱支持**：ACP 会话始终在主机运行。沙箱会话不能 spawn ACP。
2. **单向信任**：ACP Agent（如 Codex）有完全的文件系统和执行权限（取决于 `permissionMode`）。
3. **进程资源**：每个 ACP 会话是独立进程，需注意 `maxConcurrentSessions`。
4. **崩溃恢复**：当前实现中，网关重启可能丢失 ACP 会话状态（Holy Grail 计划通过 SQLite 解决）。
5. **IDE Bridge 限制**：
   - `loadSession` 不重建工具调用历史
   - 不支持每会话 MCP 服务
   - 不支持客户端文件系统方法
   - 使用统计是近似值

---

## 9. 生态全景

### 9.1 ACP 兼容 Agent（30+）

| 类别 | Agent | 说明 |
|------|-------|------|
| **大厂 Agent** | Codex CLI (OpenAI), Claude Agent (Anthropic), Gemini CLI (Google), GitHub Copilot | 主流 AI 厂商的编码代理 |
| **IDE 内置** | Junie (JetBrains), Cursor, Augment Code | IDE 集成的 AI 助手 |
| **开源 Agent** | Goose, Cline, OpenHands, OpenCode, AutoDev | 社区驱动的编码代理 |
| **专业 Agent** | Factory Droid, Docker cagent, Stakpak | 特定领域的编码代理 |
| **平台 Agent** | OpenClaw, Kimi CLI, Qwen Code, Mistral Vibe, Blackbox AI | AI 平台的编码代理 |

### 9.2 ACP 客户端

| 客户端 | 类型 | ACP 支持 |
|--------|------|---------|
| **Zed** | 代码编辑器 | 原生支持，ACP 发起者 |
| **JetBrains IDE** | IDE 系列 | AI Assistant 原生支持 |
| **VS Code** | 代码编辑器 | 通过扩展支持 |
| **OpenClaw** | Agent 平台 | 双重角色（Agent + Client） |
| **acpx** | CLI 工具 | ACP 会话管理器 |

### 9.3 SDK 和库

| 语言 | 库 | 状态 |
|------|-----|------|
| TypeScript | `@anthropic-ai/agent-client-protocol` | 官方 |
| Python | `agent-client-protocol` | 官方 |
| Java | ACP Java SDK | 官方 |
| Kotlin | ACP Kotlin SDK | 官方 |
| Rust | ACP Rust SDK | 官方 |

---

## 10. 对 SaaS 平台的启示

### 10.1 ACP 在多租户 SaaS 中的架构考量

**当前限制：**

- ACP 会话在主机进程运行，无法沙箱隔离
- 每个 Gateway 的 `maxConcurrentSessions` 是全局共享的
- ACP Agent 有完全的文件系统访问权限

**推荐架构：**

```
租户 A → Gateway A → ACP Session Manager A → acpx → Codex (cwd: /workspace/tenant-a)
租户 B → Gateway B → ACP Session Manager B → acpx → Codex (cwd: /workspace/tenant-b)
```

- 每个租户独立 Gateway（已是当前推荐）
- 每个租户独立 `cwd`，物理隔离工作空间
- 通过 `maxConcurrentSessions` 限制每个租户的 ACP 资源

### 10.2 可落地的 ACP 功能

| 功能 | 价值 | 优先级 |
|------|------|--------|
| **一键编码**：用户在飞书说"帮我修复 bug"，Agent 调用 Codex | 核心差异化能力 | 🔴 高 |
| **持久工作空间**：绑定飞书话题到特定编码项目 | 团队协作 | 🟡 中 |
| **会话恢复**：中断的编码任务可以从断点继续 | 用户体验 | 🟡 中 |
| **IDE 集成**：通过 ACP Bridge 连接 Zed/JetBrains | 开发者体验 | 🟢 低（面向开发者） |

### 10.3 风险与缓解

| 风险 | 缓解措施 |
|------|---------|
| ACP 进程泄露/僵尸 | 设置 `runtime.ttlMinutes`，监控 `ps aux \| grep acpx` |
| 资源耗尽 | 严格设置 `maxConcurrentSessions` |
| 工作空间污染 | 每个租户独立 `cwd` + 定期清理 |
| 权限过大 | 生产环境使用 `permissionMode: approve-reads` + `nonInteractivePermissions: deny` |
| 崩溃丢失状态 | 等待 Holy Grail 架构的 SQLite 持久化（或自建恢复机制） |

---

## 参考来源

| 来源 | URL/路径 |
|------|---------|
| ACP 官方网站 | https://agentclientprotocol.com/ |
| ACP GitHub | https://github.com/agentclientprotocol/agent-client-protocol |
| OpenClaw ACP 文档 | /usr/lib/node_modules/openclaw/docs/tools/acp-agents.md |
| OpenClaw ACP CLI 文档 | /usr/lib/node_modules/openclaw/docs/cli/acp.md |
| OpenClaw Sub-agents 文档 | /usr/lib/node_modules/openclaw/docs/tools/subagents.md |
| ACP Thread Bound 计划 | /docs/experiments/plans/acp-thread-bound-agents.md |
| 统一流式重构计划 | /docs/experiments/plans/acp-unified-streaming-refactor.md |
| 持久绑定计划 | /docs/experiments/plans/acp-persistent-bindings-discord-channels-telegram-topics.md |
| ACP 命令授权提案 | /docs/experiments/proposals/acp-bound-command-auth.md |
| Session 工具文档 | /docs/concepts/session-tool.md |

---

> **文档结束**
> 卷王小组 · wairesearch · 2026-03-23
