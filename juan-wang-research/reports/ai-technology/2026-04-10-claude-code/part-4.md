# Part 4：重点特性与能力实现

## 一、Skills 系统（自定义技能）

### 概念
Skills 是可复用的指令包，遵循 agentskills.io 开放标准。每个 Skill 是一个包含 SKILL.md 的目录。

### 与 CLAUDE.md 的关键区别

| | CLAUDE.md | Skills |
|---|----------|--------|
| 加载时机 | 每次会话开始 | 按需加载（使用时才消耗 token） |
| 内容类型 | 事实、规则 | 步骤、流程、领域知识 |
| 触发方式 | 自动 | `/skill-name` 手动 或 Claude 自动匹配 |

### 技能存储层级
1. Enterprise（组织级，managed settings）
2. Personal（`~/.claude/skills/`）
3. Project（`.claude/skills/`）
4. Plugin（插件分发）

### 高级功能
- **调用控制**：`disable-model-invocation: true` 防止 Claude 自动触发
- **子 Agent 执行**：`context: fork` 在独立上下文中运行
- **动态上下文注入**：运行时注入上下文
- **支持文件**：templates/、examples/、scripts/

### 内置技能
`/simplify`、`/batch`、`/debug`、`/loop`、`/claude-api` 等

---

## 二、Hooks 系统（生命周期钩子）

Hooks 是 Claude Code 最强大的可扩展性机制之一——在 Agent 生命周期的特定点执行自定义 shell 命令、HTTP 请求或 LLM 提示。

### 事件类型（20+ 种）

| 频率 | 事件 | 说明 |
|------|------|------|
| 每会话一次 | SessionStart / SessionEnd | 会话开始/结束 |
| 每轮一次 | UserPromptSubmit / Stop / StopFailure | 提交/完成/失败 |
| 每次工具调用 | PreToolUse / PostToolUse | 工具使用前/后 |
| 权限相关 | PermissionRequest / PermissionDenied | 权限请求/拒绝 |
| 子 Agent | SubagentStart / SubagentStop | 子 Agent 启停 |
| 任务 | TaskCreated / TaskCompleted | 任务创建/完成 |
| 上下文 | PreCompact / PostCompact | 压缩前/后 |
| 文件/配置 | FileChanged / ConfigChange / CwdChanged | 文件/配置/目录变化 |
| MCP | Elicitation / ElicitationResult | MCP 用户输入 |

### 钩子类型
- **Command**：shell 命令（通过 stdin 接收 JSON）
- **HTTP**：POST 到 HTTP 端点
- **Prompt**：LLM 提示

### 实际应用
- 每次文件编辑后自动格式化
- 阻止危险的 `rm -rf` 命令
- 提交前自动运行 lint
- 审计日志记录所有文件变更

---

## 三、Sub-agents 系统（子 Agent）

### 内置子 Agent

| 名称 | 模型 | 权限 | 用途 |
|------|------|------|------|
| **Explore** | Haiku（快速） | 只读 | 代码库探索和搜索 |
| **Plan** | 继承主会话 | 只读 | 计划模式下的研究 |
| **General-purpose** | 继承主会话 | 全部 | 复杂多步任务 |
| Claude Code Guide | Haiku | — | Claude Code 使用指南 |

### 自定义子 Agent
- **独立上下文窗口**：保护主会话不被探索内容淹没
- **工具限制**：可限制子 Agent 能使用的工具
- **独立权限模式**：子 Agent 可有更宽松/更严格的权限
- **持久记忆**：`~/.claude/agent-memory/` 跨会话积累学习
- **模型选择**：可为子 Agent 指定不同模型（如用 Haiku 降成本）

### Agent Teams（团队模式）
- 多个 Agent 并行工作，相互通信
- 与 Sub-agents 的区别：Sub-agents 在单会话内，Teams 跨会话协调

---

## 四、MCP 集成

### 工具搜索机制（关键创新）
- 会话开始时**只加载工具名称**，不加载完整 schema
- 任务需要时才通过搜索发现相关工具
- **只有实际使用的工具**才进入上下文 → 低 token 开销

### 三种传输模式
| 模式 | 适用 |
|------|------|
| HTTP（推荐） | 远程服务器 |
| stdio | 本地进程 |
| SSE | 流式事件 |

### 实际限制
- 建议最多 5-6 个活跃 MCP 服务器（每个启动子进程）
- 默认输出 25K token 上限
- 第三方 MCP 服务器可能是 prompt injection 向量

---

## 五、Agent SDK

Claude Agent SDK 将 Claude Code 的能力变成可编程库：

- **双语言**：Python + TypeScript
- **内置工具**：Read/Write/Edit/Bash/Glob/Grep/WebSearch/WebFetch 等
- **Hooks API**：PreToolUse/PostToolUse/Stop 等回调函数
- **支持多云**：Anthropic API / Amazon Bedrock / Google Vertex AI / Azure AI Foundry

---

## 六、GitHub Actions / CI/CD 集成

- `@claude` 在 PR/Issue 中提及即可触发
- 自动代码审查、实现功能、修复 bug
- 遵循 CLAUDE.md 规范
- 代码在 GitHub runners 上执行（安全）
- 支持定时任务（cron schedule）

---

## 七、Channels（消息通道，Research Preview）

- 将外部事件推送到运行中的 Claude Code 会话
- 支持 Telegram、Discord、iMessage
- 双向：Claude 可以在通道中回复
- **与 OpenClaw Gateway 的区别**：Channels 推送到已运行的会话，不是独立的消息网关

---

## 八、定时任务

| 类型 | 运行位置 | 特点 |
|------|---------|------|
| Cloud Scheduled Tasks | Anthropic 托管 VM | 电脑关机也能运行 |
| Desktop Scheduled Tasks | 本地机器 | 直接访问本地文件 |
| `/loop` | CLI 会话内 | 快速轮询 |
