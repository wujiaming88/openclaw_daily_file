# Part 1：项目概览与定位

## 基本信息

- **项目名称**：Hermes Agent
- **开发团队**：Nous Research（Hermes、Nomos、Psyche 模型的创建者）
- **发布时间**：2026 年 2 月 24 日
- **开源协议**：MIT
- **GitHub**：https://github.com/NousResearch/hermes-agent
- **官网**：https://hermes-agent.nousresearch.com
- **技术栈**：Python（核心）+ Node.js（部分工具）
- **定位**：自我进化的 AI Agent —— "The agent that grows with you"

## 核心愿景

Hermes Agent 不是 IDE 绑定的编码副驾驶，也不是单一 API 的聊天包装器。它是一个**自主 Agent**，具备：
- 内置学习循环（从经验中创建技能、使用中改进技能）
- 跨会话持久记忆
- 主动知识持久化
- 搜索自身历史对话
- 逐步深化的用户模型

## 与 OpenClaw 的关系

从代码结构和功能特性来看，Hermes Agent 与 OpenClaw 有极高的相似度：
- 相同的 Gateway 架构（多平台消息网关）
- 相同的 Agent 概念（SOUL.md、MEMORY.md、AGENTS.md）
- 相同的 Skills 系统（agentskills.io 标准）
- 提供 `hermes claw migrate` 命令，可从 OpenClaw 迁移配置
- **结论**：Hermes Agent 是 OpenClaw 的品牌重塑/重大分支，由 Nous Research 接手并大幅扩展

## 目标用户

1. **个人开发者** — 需要全天候运行的 AI 助手
2. **AI 研究者** — RL 训练、轨迹生成
3. **团队/企业** — 多平台部署、多 Agent 协作
4. **模型训练者** — 生成 tool-calling 训练数据

## 关键数据

| 指标 | 数值 |
|------|------|
| 内置工具数 | 47-48 个 |
| 工具集 | 40 个 |
| 支持平台 | 14+ (Telegram/Discord/Slack/WhatsApp/Signal/Matrix/Mattermost/Email/SMS/DingTalk/飞书/企业微信/Home Assistant/Webhook) |
| 终端后端 | 6 种 (Local/Docker/SSH/Daytona/Modal/Singularity) |
| 测试用例 | 3,000+ |
| 核心代码 | run_agent.py ~9,200 行, cli.py ~8,500 行, gateway/run.py ~7,500 行 |
