# 研究计划：Claude Code 深度研究

## 研究目标
结合源码分析、官方文档、社区研究，深入分析 Claude Code 的架构、核心流程、重点特性和关键能力实现

## 信息来源
1. **官方文档**：https://code.claude.com/docs/
2. **泄露源码分析**：2026年3月泄露的 512K 行 TypeScript（npm source map 事件）
3. **社区分析**：WaveSpeedAI、FlorianBruniaux/claude-code-ultimate-guide 等
4. **Anthropic 工程博客**：harness 设计、auto mode 等

## 子课题

### 1. 项目概览与技术栈（已完成大部分）
- 基本信息、发展历程、技术选型
- Bun + React/Ink + Zod v4 + TypeScript

### 2. 核心架构：Agent Harness（3-4 次搜索）
- 入口层（CLI/VS Code/Desktop/Web/JetBrains）
- QueryEngine（46K 行核心）
- 工具系统（40+ 工具、权限门控）
- 多 Agent 编排（Coordinator/Worker/Mailbox 模式）

### 3. 上下文管理与压缩（2-3 次搜索）
- 三层压缩：MicroCompact / AutoCompact / Full Compact
- 会话状态跟踪
- 输出截断与 token 管理
- CLAUDE.md 机制

### 4. 权限与安全模型（2-3 次搜索）
- 三级权限：Auto-approved / Prompt / Block
- Auto Mode 的 Sonnet 4.6 分类器
- Deny-first 规则管道
- 沙箱与容器安全

### 5. 重点特性与能力实现（3-4 次搜索）
- MCP 集成（工具搜索、动态发现）
- Skills/自定义命令
- Hooks 系统
- Sub-agents 多 Agent 协作
- Agent SDK
- GitHub Actions / CI/CD 集成
- 定时任务（Cloud/Desktop）
- Remote Control / Channels

### 6. 遥测与工程实践（1-2 次搜索）
- 挫败感指标、continue 计数器
- 108 个 Feature Flag
- 编译期死代码消除
- Undercover Mode

## 预估搜索次数：12-16 次
## 产出：6 个 part 文件 + 1 个完整 report.md
