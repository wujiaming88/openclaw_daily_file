# Part 1：项目概览与技术栈

## 基本信息

- **产品名称**：Claude Code
- **开发团队**：Anthropic
- **产品类型**：Agentic Coding Tool（闭源商业产品）
- **发布渠道**：Terminal CLI / VS Code / JetBrains / Desktop App / Web / iOS
- **代码规模**：~512,000 行 TypeScript（2026年3月源码泄露事件确认）
- **入口文件**：785KB（单文件）
- **文件数量**：~1,900 个源文件
- **开源状态**：闭源（Agent SDK 部分开放）

## 技术栈

| 组件 | 技术选型 | 备注 |
|------|---------|------|
| **运行时** | Bun（非 Node.js） | 更快的启动速度和执行效率 |
| **语言** | TypeScript（strict 模式） | 512K 行 |
| **终端 UI** | React + Ink | 组件化终端渲染，状态管理 |
| **Schema 验证** | Zod v4 | 全链路 schema 验证 |
| **模型** | Claude Opus 4.6 / Sonnet 4.6 | Auto Mode 用 Sonnet 做分类 |
| **构建** | Bun compile-time flags | 死代码消除，108 个 feature flag |

### 技术选型分析

**Bun 而非 Node.js**：追求启动速度和打包效率，Bun 的 compile-time dead code elimination 让 108 个未发布功能模块完全从生产包中移除。

**React + Ink 做终端 UI**：这是一个大胆选择。CLI 工具传统上用字符串拼接，而 Claude Code 使用 React 组件模式做终端 UI——状态管理、重渲染、可组合组件全部照搬 Web React 的模式。

**Zod v4 全链路**：每个工具的输入输出都有 Zod schema 验证，这在 Agent 系统中至关重要——防止模型幻觉产生的畸形工具调用传播到下游。

## 发展历程

| 时间 | 事件 |
|------|------|
| 2025 年 | Claude Code 首次发布（CLI） |
| 2026-02-18 | Opus/Sonnet 4.6 发布，四项 API 功能 GA |
| 2026-03 | Auto Mode 发布；npm source map 源码泄露事件 |
| 2026-04 | VS Code/JetBrains/Desktop/Web 多端覆盖 |

## 产品定位

Claude Code 定位为**全能编码 Agent**，而非简单的 chat wrapper。官方描述：
> "reads your codebase, edits files, runs commands, and integrates with your development tools"

核心能力：
1. 理解整个代码库
2. 跨多文件编辑
3. 执行 shell 命令
4. 集成开发工具链
5. 多 Agent 协作
6. CI/CD 自动化
7. 定时任务调度

## 可用环境

| 环境 | 特点 |
|------|------|
| Terminal CLI | 全功能命令行 |
| VS Code | 内联 diff、@mentions、Plan review |
| JetBrains | IntelliJ/PyCharm/WebStorm 插件 |
| Desktop App | 独立应用，多会话并行，定时任务 |
| Web | 浏览器端，无需本地安装，远程执行 |
| iOS App | 移动端任务管理 |
| Chrome | 调试 Web 应用 |
| Slack | @Claude 发起任务 |
