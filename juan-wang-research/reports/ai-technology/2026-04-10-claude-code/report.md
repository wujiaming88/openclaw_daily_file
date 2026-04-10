# Claude Code 深度研究报告：解剖 512K 行的 Agentic Coding Tool

> **研究员**：黄山（wairesearch）| **日期**：2026-04-10 | **版本**：1.0

---

## 执行摘要

Claude Code 是 Anthropic 的旗舰 AI 编码 Agent，其核心不是模型本身，而是一个精心设计的 **Agent Harness**——模型和真实世界之间的一切。2026 年 3 月的 npm source map 泄露事件揭示了 512,000 行 TypeScript 的完整架构：Bun 运行时、React+Ink 终端 UI、46,000 行的 QueryEngine 核心、三层上下文压缩、Deny-first 权限管道、Coordinator/Worker/Mailbox 多 Agent 模式。其设计哲学可以用一句话概括：**"Less Scaffolding, More Model"**——信任模型的推理能力，而非构建复杂的编排系统。

---

## 一、技术栈与规模

| 组件 | 选型 |
|------|------|
| 运行时 | Bun（非 Node.js） |
| 语言 | TypeScript strict，~512K 行 |
| 终端 UI | React + Ink |
| Schema 验证 | Zod v4（全链路） |
| 模型 | Claude Opus 4.6 / Sonnet 4.6 / Haiku |
| 构建 | Bun compile-time flags，108 个 feature flag |

**为什么用 Bun？** 启动速度、打包效率，以及 compile-time dead code elimination——让 108 个未发布功能（KAIROS、VOICE_MODE、DAEMON 等）完全从生产包中消除。

**为什么用 React + Ink？** 将 Web 组件化模式搬到终端——状态管理、重渲染、可组合组件。大胆但有效。

---

## 二、核心架构

### 2.1 Agent Harness

> "Claude Code provides the tools, context management, and execution environment that turn a language model into a capable coding agent."

```
┌─────────────────────────────────────┐
│  入口：CLI / VS Code / JetBrains    │
│  / Desktop / Web / iOS / Slack      │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│       Agent Harness                  │
│  ┌─────────────────────────────┐    │
│  │ QueryEngine.ts (46K 行)     │    │
│  │ API调用/流式/缓存/上下文预算  │    │
│  └─────────────────────────────┘    │
│  ┌──────────┬────────┬─────────┐   │
│  │工具系统   │权限系统 │会话管理   │   │
│  │40+工具   │Deny→Ask│JSONL    │   │
│  │独立门控   │→Allow  │快照/回退  │   │
│  └──────────┴────────┴─────────┘   │
│  ┌──────────────────────────────┐   │
│  │  多Agent: Coordinator/Worker │   │
│  │  Mailbox + 原子认领          │   │
│  └──────────────────────────────┘   │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  执行环境：Local / Cloud VM         │
│  + MCP Servers + Chrome Extension   │
└─────────────────────────────────────┘
```

### 2.2 Master Loop——极简主义

Claude Code 的核心是一个简单的 while 循环，**没有**意图分类器、没有任务路由器、没有 RAG、没有 DAG、没有规划/执行分离：

```
Your Prompt → Claude Reasons → Tool Call?
  YES → Execute Tool → Feed Result → Loop Back
  NO  → Text Response (Done)
```

### 2.3 8 个核心工具

| 工具 | 用途 |
|------|------|
| **Bash** | 万能适配器（git/npm/docker/curl...） |
| **Read** | 读文件 |
| **Edit** | diff-based 编辑 |
| **Write** | 创建/覆写文件 |
| **Grep** | ripgrep 搜索 |
| **Glob** | 文件模式匹配 |
| **Task** | 生成子 Agent |
| **TodoWrite** | 任务追踪 |

加上 MCP 和扩展后实际达 40+ 工具，但核心就是这 8 个。

---

## 三、QueryEngine——46K 行的核心大脑

所有触碰模型 API 的逻辑集中在一个文件中：

- **LLM API 调用**：发送请求、流式接收
- **上下文预算管理**：实时 token 追踪
- **自愈查询循环**：接近上限 → 自动压缩 → 继续工作（不崩溃）
- **重试与限速**：rate limit 处理、自动重试
- **Anthropic Prompt Caching**：缓存集成

**为什么一个文件？** 重试、限速、预算、流式错误需要统一推理，分散会导致不一致。

---

## 四、三层上下文压缩

Claude Code 为长会话设计了工业级压缩策略：

| 层级 | 触发条件 | 方式 | API 成本 |
|------|---------|------|---------|
| **MicroCompact** | 工具输出过旧 | 本地裁剪 | 零 |
| **AutoCompact** | ~98% 上下文上限 | 预留 13K buffer + 20K 摘要 + 断路器(3次失败停止) | 中 |
| **Full Compact** | 手动或极端情况 | 全对话压缩 + 重注入最近文件(5K/文件) + 计划/技能 | 高 |

**核心洞察**：不做压缩的 Agent 工具在规模上必然失败。三层方案是从设计之初就为会话持久性考虑的，不是后补的。

---

## 五、权限与安全——Deny-First

### 5.1 规则管道
```
工具调用 → Deny 检查 → Ask 检查 → Allow 检查
```
**Deny 永远优先**——模型无法通过修辞说服绕过安全检查。

### 5.2 三级权限

| 级别 | 操作 | 处理 |
|------|------|------|
| Auto-approved | 只读（读文件、搜索） | 静默放行 |
| Prompt | 受控修改（编辑、部分 shell） | 提示或 Auto Mode 分类 |
| Block | 高风险（系统修改、数据外泄） | 必须人工审批 |

### 5.3 Auto Mode 分类器
- 独立 Sonnet 4.6 实例运行
- 输入：用户请求 + 工具调用
- **刻意不看**模型的散文输出 → 防止模型"说服"分类器

---

## 六、多 Agent 编排——Mailbox 模式

### 6.1 Coordinator/Worker 架构
Worker 执行到危险操作 → 发请求到 Coordinator Mailbox → 等待审批/拒绝

### 6.2 关键机制
- **原子认领**：防止两个 Worker 同时处理同一审批
- **共享内存**：所有 Agent 维持一致上下文
- **深度限制 depth=1**：子 Agent 不能再生子 Agent

### 6.3 内置子 Agent

| 名称 | 模型 | 用途 |
|------|------|------|
| Explore | Haiku | 快速只读代码探索 |
| Plan | 继承 | 计划模式研究 |
| General-purpose | 继承 | 复杂多步任务 |

---

## 七、记忆系统

| 机制 | 作者 | 内容 | 加载 |
|------|------|------|------|
| **CLAUDE.md** | 用户 | 指令和规则 | 每次会话开始 |
| **Auto Memory** | Claude | 学到的模式和偏好 | 前 200 行或 25KB |

CLAUDE.md 支持多层级（组织/项目/用户/本地）、@import 语法、path-scoped rules（`.claude/rules/`）。

---

## 八、可扩展性——四层扩展机制

| 机制 | 用途 | 加载时机 |
|------|------|---------|
| **CLAUDE.md** | 事实、规则 | 每次会话 |
| **Skills** | 流程、领域知识 | 按需（零 token 直到使用） |
| **Hooks** | 生命周期自动化（20+ 事件） | 事件触发 |
| **MCP** | 外部工具/数据源 | 工具搜索（按需发现） |

### Skills 系统
- 遵循 agentskills.io 开放标准
- 支持自动发现（Claude 匹配 description）+ 手动 `/skill-name`
- 支持子 Agent 执行（`context: fork`）

### Hooks 系统
- 20+ 生命周期事件
- 三种类型：shell command / HTTP / LLM prompt
- 示例：阻止 `rm -rf`、每次编辑后自动格式化

### MCP 集成
- **工具搜索**（关键创新）：会话开始只加载工具名，按需发现 schema
- 三种传输：HTTP / stdio / SSE
- 建议 ≤5-6 个 MCP server

---

## 九、搜索策略演进

| 阶段 | 方案 | 结果 |
|------|------|------|
| 早期 | Voyage embeddings (RAG) | 需要索引同步，安全风险 |
| 当前 | ripgrep (agentic search) | **更简单、更安全、无索引** |

**"Search, Don't Index"** —— 用 token 换简单和安全。

---

## 十、遥测与隐藏功能

### 遥测信号
- **挫败感指标**：追踪用户骂人频率（先行 UX 指标）
- **Continue 计数器**：追踪 "continue" 输入频率（Agent 卡顿代理指标）

### Feature Flags
- 108 个 compile-time flag，通过 Bun 死代码消除
- 已知隐藏模块：KAIROS、VOICE_MODE、DAEMON
- Undercover Mode（防代号泄漏）——讽刺地在泄露中被发现

---

## 十一、产品覆盖面

| 环境 | 用途 |
|------|------|
| Terminal CLI | 全功能命令行 |
| VS Code / Cursor | IDE 内联 diff、@mentions |
| JetBrains | IntelliJ/PyCharm/WebStorm |
| Desktop App | 独立应用、多会话、定时任务 |
| Web | 浏览器端、远程执行 |
| iOS App | 移动端 |
| Chrome 扩展 | 调试 Web 应用 |
| Slack | @Claude 发起任务 |
| GitHub Actions | CI/CD 自动化 |
| Channels | Telegram/Discord/iMessage 推送到会话 |
| Agent SDK | Python/TypeScript 可编程库 |
| Remote Control | 浏览器远程控制本地会话 |

---

## 十二、关键洞察总结

### 1. Harness > Model
> "The model is the easy part. Making it do things reliably for more than five minutes — that's where the engineering lives."

### 2. 安全机制与推理完全分离
权限管道不看模型输出、Auto Mode 分类器刻意不看散文、Deny 规则无视模型论证。

### 3. 三层压缩是生存必需品
不压缩的 Agent 工具在长会话中必然崩溃。MicroCompact/AutoCompact/Full Compact 是从设计之初就内建的。

### 4. 简单循环 + 好工具 > 复杂编排
8 个核心工具 + while 循环 > DAG + RAG + 分类器。相信模型推理。

### 5. 可组合的扩展层
CLAUDE.md → Skills → Hooks → MCP → Sub-agents → Agent SDK，从简单到复杂，按需叠加。

---

## 参考来源

1. [Claude Code 官方文档](https://code.claude.com/docs/en/overview)
2. [How Claude Code Works](https://code.claude.com/docs/en/how-claude-code-works)
3. [Claude Code Memory (CLAUDE.md)](https://code.claude.com/docs/en/memory)
4. [Skills System](https://code.claude.com/docs/en/skills)
5. [Hooks Reference](https://code.claude.com/docs/en/hooks)
6. [Sub-agents](https://code.claude.com/docs/en/sub-agents)
7. [MCP Integration](https://code.claude.com/docs/en/mcp)
8. [Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview)
9. [GitHub Actions](https://code.claude.com/docs/en/github-actions)
10. [Channels](https://code.claude.com/docs/en/channels)
11. [WaveSpeedAI: Claude Code Architecture Deep Dive](https://wavespeed.ai/blog/posts/claude-code-architecture-leaked-source-deep-dive/)
12. [WaveSpeedAI: Claude Code Agent Harness](https://wavespeed.ai/blog/posts/claude-code-agent-harness-architecture/)
13. [FlorianBruniaux/claude-code-ultimate-guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide)
14. [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
15. [Anthropic: Claude Code Auto Mode](https://www.anthropic.com/engineering/claude-code-auto-mode)
16. [Latent Space Podcast: Claude Code](https://www.latent.space/p/claude-code)
