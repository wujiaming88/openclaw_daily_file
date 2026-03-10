# OpenClaw 多Agent记忆系统与上下文共享研究报告

> 研究日期：2026-03-10
> 研究员：黄山 (wairesearch)
> 数据来源：OpenClaw 官方文档（本地 `/usr/lib/node_modules/openclaw/docs/`）

---

## 执行摘要

OpenClaw 采用**文件即记忆**（File-as-Memory）的设计哲学，以纯 Markdown 文件作为记忆的唯一事实来源。在多Agent场景中，每个Agent拥有**完全隔离**的工作空间（workspace）、会话存储（sessions）和认证配置（auth-profiles），默认不共享任何上下文。

上下文共享通过三种机制实现：
1. **共享文件系统**（最重要）— Agent 通过读写共享目录交换信息
2. **会话间消息**（`sessions_send`）— Agent 间直接发送消息
3. **子Agent通告**（Subagent Announce）— 子Agent完成后自动将结果通告回父会话

---

## 一、记忆系统架构

### 1.1 记忆的存储形式

OpenClaw 的记忆**不是数据库**，而是纯 Markdown 文件，存储在 Agent 的工作空间中：

```
~/.openclaw/workspace-<agentId>/
├── MEMORY.md                    ← 精选的长期记忆（核心记忆）
├── memory/
│   ├── 2026-03-10.md            ← 每日记忆日志（仅追加）
│   ├── 2026-03-09.md
│   └── ...
├── AGENTS.md                    ← Agent操作指南
├── SOUL.md                      ← 人设、语气
├── USER.md                      ← 用户信息
├── IDENTITY.md                  ← Agent身份
├── TOOLS.md                     ← 本地工具笔记
└── HEARTBEAT.md                 ← 心跳检查清单
```

**设计哲学**：
- **Markdown 是唯一事实来源** — 模型只"记住"写入磁盘的内容
- **人类可审查** — 所有记忆都可以直接阅读和编辑
- **Git 友好** — 推荐用私有 Git 仓库备份

### 1.2 记忆的两个层级

| 层级 | 文件 | 加载时机 | 用途 |
|------|------|---------|------|
| **长期记忆** | `MEMORY.md` | 每次主私聊会话开始 | 决策、偏好、持久事实 |
| **每日记忆** | `memory/YYYY-MM-DD.md` | 会话开始时读取今天+昨天 | 日常笔记、运行上下文 |

⚠️ **重要限制**：`MEMORY.md` **仅在主私聊会话加载**，群组上下文中不加载。

### 1.3 向量记忆搜索

OpenClaw 在 Markdown 文件上构建**向量索引**，支持语义搜索：

```
索引存储：~/.openclaw/memory/<agentId>.sqlite
```

**搜索方式**：混合搜索（BM25 关键词 + 向量语义）

| 组件 | 作用 | 权重（默认） |
|------|------|-------------|
| **向量相似度** | 语义匹配，措辞不同也能找到 | 70% |
| **BM25 关键词** | 精确匹配 ID、代码符号、错误字符串 | 30% |

**嵌入提供商**（按优先级）：
1. 本地模型（`node-llama-cpp` + GGUF，默认 `embeddinggemma-300M`）
2. OpenAI（`text-embedding-3-small`）
3. Gemini（`gemini-embedding-001`）

**工具接口**：
- `memory_search` — 语义搜索，返回片段 + 文件路径 + 行号
- `memory_get` — 按路径读取记忆文件内容

### 1.4 自动记忆刷新（Memory Flush）

当会话**接近上下文窗口上限**时，OpenClaw 会在压缩（compaction）之前触发一次**静默的 Agent 回合**，提醒模型将重要信息写入磁盘：

```
触发条件：contextTokens > contextWindow - reserveTokensFloor - softThresholdTokens
默认 softThresholdTokens = 4000
```

**流程**：
1. 检测到上下文即将满 → 触发刷新
2. 发送静默提示："将持久笔记写入 memory/YYYY-MM-DD.md"
3. 模型写入记忆 → 回复 `NO_REPLY`（用户不可见）
4. 然后执行压缩（summarize 旧消息）
5. 后续回合看到：压缩摘要 + 最近消息

### 1.5 会话记忆搜索（实验性）

可选择索引**会话对话记录**（JSONL），通过 `memory_search` 搜索：

```json5
{
  agents: {
    defaults: {
      memorySearch: {
        experimental: { sessionMemory: true },
        sources: ["memory", "sessions"]
      }
    }
  }
}
```

---

## 二、多Agent架构

### 2.1 Agent 隔离模型

每个 Agent 是一个**完全独立的大脑**：

```
~/.openclaw/
├── agents/
│   ├── main/
│   │   ├── agent/auth-profiles.json    ← 独立认证
│   │   └── sessions/                   ← 独立会话
│   ├── wairesearch/
│   │   ├── agent/auth-profiles.json
│   │   └── sessions/
│   └── waicode/
│       ├── agent/auth-profiles.json
│       └── sessions/
├── workspace/                          ← main 的工作空间
├── workspace-wairesearch/              ← wairesearch 的工作空间
└── workspace-waicode/                  ← waicode 的工作空间
```

**隔离维度**：

| 维度 | 隔离程度 |
|------|---------|
| 工作空间（文件/记忆） | ✅ 完全隔离 |
| 会话存储 | ✅ 完全隔离 |
| 认证配置 | ✅ 完全隔离 |
| 模型选择 | ✅ 可独立配置 |
| 工具权限 | ✅ 可独立配置 |
| 沙箱隔离 | ✅ 可独立配置 |
| Skills | ⚠️ 共享 `~/.openclaw/skills`，可用 workspace 下 `skills/` 覆盖 |

### 2.2 消息路由（Binding）

入站消息通过 **binding** 规则路由到目标 Agent：

```json5
{
  bindings: [
    { agentId: "main", match: { channel: "telegram", peer: { kind: "dm", id: "8577482651" } } },
    { agentId: "wairesearch", match: { channel: "telegram", peer: { kind: "dm", id: "other_id" } } },
  ]
}
```

**路由优先级**（最具体的优先）：
1. `peer` 精确匹配（DM/群组/频道 ID）
2. `guildId`（Discord）/ `teamId`（Slack）
3. `accountId` 匹配
4. 渠道级匹配
5. 回退到默认 Agent

### 2.3 子Agent（Subagent）

子Agent 是从父 Agent 中生成的**后台 Agent 运行**：

```
会话键格式：agent:<agentId>:subagent:<uuid>
```

**关键特性**：

| 特性 | 说明 |
|------|------|
| 会话隔离 | 独立的上下文和 token 使用 |
| 非阻塞 | 立即返回 runId |
| 通告机制 | 完成后自动将结果发布到父会话 |
| 工具限制 | 默认**无** sessions 工具（不能生成子子agent） |
| 上下文注入 | 仅 `AGENTS.md` + `TOOLS.md`（无 SOUL/IDENTITY/USER） |
| 自动归档 | 默认 60 分钟后归档 |

---

## 三、多Agent上下文共享机制

### 3.1 机制一：共享文件系统（推荐主要方式）

**原理**：多个 Agent 通过读写同一个目录来交换信息。

```
shared/                          ← 共享目录（任意位置，需各Agent可访问）
├── tasks/current.md             ← 协调者写入任务
├── status/
│   ├── wairesearch/current.md   ← 研究员写进度
│   └── waicode/current.md       ← 开发者写进度
└── artifacts/
    └── TASK-001/
        └── report.md            ← 产出文件
```

**优势**：
- 简单、直观、可审查
- Git 友好，可版本控制
- Agent 可以异步读写
- 支持任意复杂的数据结构

**限制**：
- 需要手动协调写入时序
- 没有内置的文件锁机制
- 跨机器需要额外的同步方案

**实现方式**：
- 各 Agent 的 workspace 设为不同路径，但共享一个公共子目录
- 或通过绝对路径访问共享目录（非沙箱模式下）

### 3.2 机制二：会话间消息（sessions_send）

**原理**：Agent 之间通过 `sessions_send` 工具直接发送消息。

```
Agent A → sessions_send(sessionKey="agent:wairesearch:main", message="请调研 X")
Agent B 收到消息 → 处理 → 回复
```

**适用场景**：
- 简短的即时通信
- 任务派发和状态查询
- 需要确认的交互

**限制**：
- 默认情况下子Agent **没有** sessions 工具
- 需要知道目标 Agent 的 sessionKey
- 消息不持久化为文件（在会话历史中）

### 3.3 机制三：子Agent通告（Announce）

**原理**：子Agent 完成后，自动将结果**通告**回请求者的聊天渠道。

**通告流程**：
1. 父 Agent 通过 `sessions_spawn` 启动子 Agent
2. 子 Agent 执行任务
3. 子 Agent 完成 → 运行通告步骤
4. 通告消息发布到父 Agent 的聊天渠道

**通告内容**（标准化模板）：
- `Status`: success / error / timeout / unknown
- `Result`: 通告步骤的摘要内容
- `Notes`: 错误详情和上下文
- 统计行：运行时间、token 使用量、估计成本
- `sessionKey` + `sessionId` + 对话记录路径

**父Agent后续访问**：
```
sessions_history(sessionKey=子agent的sessionKey)  → 获取完整历史
```

### 3.4 机制四：Agent-to-Agent 消息（需显式启用）

```json5
{
  tools: {
    agentToAgent: {
      enabled: false,  // 默认关闭！
      allow: ["home", "work"]
    }
  }
}
```

⚠️ 这个功能默认**关闭**，需要显式开启并设置允许列表。

### 3.5 机制五：额外记忆路径（memorySearch.extraPaths）

Agent 可以索引工作空间之外的 Markdown 文件：

```json5
{
  agents: {
    defaults: {
      memorySearch: {
        extraPaths: ["../shared-notes", "/srv/team-docs/overview.md"]
      }
    }
  }
}
```

多个 Agent 可以配置相同的 `extraPaths`，从而**共享记忆搜索**。

---

## 四、上下文管理机制

### 4.1 上下文组成

每次模型调用，上下文包含：

```
┌─────────────────────────────────────┐
│  系统提示词（System Prompt）          │ ← OpenClaw 构建
│  ├── 工具列表 + Schema              │
│  ├── Skills 列表（元数据）           │
│  ├── 运行时信息                      │
│  └── 项目上下文（注入的工作区文件）    │
│      ├── AGENTS.md                   │
│      ├── SOUL.md                     │
│      ├── USER.md                     │
│      ├── IDENTITY.md                 │
│      ├── TOOLS.md                    │
│      └── MEMORY.md（仅主私聊）       │
├─────────────────────────────────────┤
│  对话历史（或压缩摘要+近期消息）      │
├─────────────────────────────────────┤
│  工具调用/结果 + 附件                │
└─────────────────────────────────────┘
```

### 4.2 上下文生命周期

```
新会话 ──────────────────────────────────────────── 上下文增长
    │                                                   │
    │  消息/工具结果不断积累                              │
    │                                                   │
    ▼ 接近阈值                                          ▼
记忆刷新（静默写入 memory/）                         自动压缩
    │                                                   │
    │  先持久化重要信息                                  │  总结旧消息
    │                                                   │
    ▼                                                   ▼
压缩后：摘要 + 最近消息（上下文缩小） ──── 继续对话...
```

### 4.3 会话重置策略

| 方式 | 说明 |
|------|------|
| `/new` 或 `/reset` | 手动创建新会话 ID |
| 每日重置 | 默认凌晨 4:00 本地时间 |
| 空闲过期 | `session.reset.idleMinutes` 配置 |

---

## 五、对比分析

### 5.1 与其他多Agent框架的记忆系统对比

| 维度 | OpenClaw | LangGraph | CrewAI | AutoGen |
|------|----------|-----------|--------|---------|
| **记忆存储** | Markdown 文件 | 内存/数据库 | 内存/向量DB | 内存 |
| **持久化** | ✅ 原生 (文件) | 需配置 | 需配置 | 需配置 |
| **人类可读** | ✅ 完全 | ❌ | ❌ | ❌ |
| **Git 友好** | ✅ | ❌ | ❌ | ❌ |
| **向量搜索** | ✅ 混合搜索 | 取决于集成 | ✅ | 取决于集成 |
| **Agent间共享** | 文件系统+消息 | 共享状态图 | 共享记忆 | 群聊 |
| **自动记忆保存** | ✅ Memory Flush | ❌ | ❌ | ❌ |

### 5.2 上下文共享方式对比

| 方式 | 延迟 | 持久性 | 复杂度 | 适用场景 |
|------|------|--------|--------|---------|
| **共享文件系统** | 中 | ✅ 高 | 低 | 大量结构化数据、研究报告、代码 |
| **sessions_send** | 低 | ⚠️ 会话内 | 中 | 即时通信、任务派发 |
| **子Agent通告** | 高 | ⚠️ 会话内 | 低 | 后台任务结果报告 |
| **extraPaths** | 低 | ✅ 高 | 低 | 共享知识库、团队文档 |

---

## 六、架构亮点与局限

### 亮点

1. **文件即记忆** — 透明、可审查、可版本控制，人类随时可以直接编辑
2. **自动记忆刷新** — 在上下文压缩前自动持久化重要信息，减少信息丢失
3. **混合搜索** — BM25 + 向量的组合兼顾精确匹配和语义匹配
4. **完全隔离的多Agent** — 安全边界清晰，不会意外泄露
5. **灵活的嵌入选择** — 支持本地/远程/多提供商切换

### 局限

1. **Agent间共享需要手动协调** — 没有内置的"共享记忆空间"原语
2. **子Agent上下文受限** — 只注入 AGENTS.md + TOOLS.md，不继承父Agent的完整人设
3. **文件系统缺乏并发控制** — 多Agent同时写入同一文件可能冲突
4. **会话记忆搜索是实验性的** — 尚未稳定
5. **记忆刷新是尽力而为的** — 依赖模型配合输出 NO_REPLY
6. **Agent-to-Agent 通信默认关闭** — 需要显式配置

---

## 七、建议

### 对于多Agent团队架构

1. **使用共享目录作为主要通信方式**
   - 设计清晰的目录结构（tasks/、status/、artifacts/）
   - 用 Git 跟踪变更

2. **配置 extraPaths 共享知识库**
   - 让所有 Agent 索引同一个知识目录
   - 适合共享文档、规范、API 文档

3. **子Agent 用于并行任务**
   - 为子Agent 设置更便宜的模型
   - 利用通告机制自动收集结果

4. **在 MEMORY.md 中维护团队协作协议**
   - 包括共享目录结构、文件命名规范、状态报告格式

### 对于记忆系统优化

1. **启用混合搜索** — 同时覆盖精确和语义查询
2. **定期整理 MEMORY.md** — 保持核心记忆精炼
3. **利用 memory flush** — 确保重要上下文不会在压缩时丢失
4. **考虑启用 session memory（实验性）** — 跨会话搜索历史对话

---

## 参考来源

1. `/usr/lib/node_modules/openclaw/docs/zh-CN/concepts/memory.md` — 记忆系统核心文档
2. `/usr/lib/node_modules/openclaw/docs/zh-CN/concepts/multi-agent.md` — 多Agent路由
3. `/usr/lib/node_modules/openclaw/docs/zh-CN/concepts/context.md` — 上下文构建
4. `/usr/lib/node_modules/openclaw/docs/zh-CN/concepts/agent-workspace.md` — 工作空间布局
5. `/usr/lib/node_modules/openclaw/docs/zh-CN/concepts/compaction.md` — 压缩机制
6. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/subagents.md` — 子Agent系统
7. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/multi-agent-sandbox-tools.md` — 多Agent沙箱与工具
8. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/agent-send.md` — Agent发送命令
9. `/usr/lib/node_modules/openclaw/docs/zh-CN/reference/session-management-compaction.md` — 会话管理深入
10. `/usr/lib/node_modules/openclaw/docs/zh-CN/experiments/research/memory.md` — 工作区记忆 v2 研究笔记
