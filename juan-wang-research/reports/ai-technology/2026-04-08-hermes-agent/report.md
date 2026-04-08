# Hermes Agent 深度研究：会自我进化的 AI Agent

> **研究员**：黄山（wairesearch）| **日期**：2026-04-08 | **版本**：1.0

---

## 执行摘要

Hermes Agent 是 Nous Research 于 2026 年 2 月 24 日发布的开源 AI Agent 框架，定位为"与你一起成长的 Agent"。它不是 IDE 绑定的编码副驾驶，而是一个可以永久驻留在你服务器上、跨会话持续学习的自主 Agent。核心亮点包括：闭环学习循环、三层记忆系统、14+ 平台网关、6 种终端后端、18+ 模型供应商支持、以及基于 GEPA 的自进化能力。截至 2026 年 4 月，GitHub 已获 23,000+ stars，MIT 开源许可。

---

## 一、项目背景

### 1.1 团队

Hermes Agent 由 **Nous Research** 开发——这是训练了 Hermes、Nomos、Psyche 等知名开源模型的 AI 研究实验室。"由模型训练者打造 Agent"是其核心叙事：同一个团队既理解模型的能力边界，又在构建使用模型的工具。

### 1.2 与 OpenClaw 的关系

从架构、功能到代码结构，Hermes Agent 与 OpenClaw 高度相似：
- 相同的 Gateway 多平台消息网关
- 相同的 SOUL.md / MEMORY.md / AGENTS.md 概念
- 相同的 Skills 系统（agentskills.io 标准）
- 内置 `hermes claw migrate` 一键迁移命令

**结论**：Hermes Agent 本质上是 OpenClaw 的品牌重塑与重大扩展分支，由 Nous Research 接手后融入了其模型训练和 RL 研究能力。

### 1.3 关键数据

| 指标 | 数值 |
|------|------|
| 发布日期 | 2026-02-24 |
| GitHub Stars | 23,000+ |
| 内置工具 | 47 个，40 个工具集 |
| 支持平台 | 14+（Telegram/Discord/Slack/WhatsApp/Signal/Matrix/飞书/企业微信/钉钉等） |
| 终端后端 | 6 种（Local/Docker/SSH/Daytona/Modal/Singularity） |
| 模型供应商 | 18+（OpenRouter 200+ 模型） |
| 测试用例 | 3,000+ |
| 开源协议 | MIT |

---

## 二、核心架构

### 2.1 三层架构

```
┌─────────────────────────────────────┐
│           入口层                      │
│  CLI / Gateway / ACP / Batch Runner │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│        核心层：AIAgent               │
│  ┌──────────┬───────────┬────────┐  │
│  │ Prompt   │ Provider  │ Tool   │  │
│  │ Builder  │ Router    │ Dispatch│  │
│  │          │ (18+ 供应商)│ (47工具)│  │
│  └──────────┴───────────┴────────┘  │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  存储层：SQLite + FTS5 全文搜索       │
│  后端层：6 终端 + 5 浏览器 + MCP     │
└─────────────────────────────────────┘
```

### 2.2 三种 API 模式

Hermes Agent 通过统一的内部消息格式支持三种 API 后端：

| 模式 | 适用供应商 | 特点 |
|------|-----------|------|
| chat_completions | OpenAI 兼容端点、OpenRouter | 最通用 |
| codex_responses | OpenAI Codex/Responses API | 原生 Responses 格式 |
| anthropic_messages | Anthropic Claude | 原生适配，支持 prompt caching |

### 2.3 Agent 循环

每轮推理遵循严格流程：

1. 追加用户消息 → 构建系统提示词
2. 检查上下文压缩需求（>50% 窗口触发）
3. 可中断的 API 调用（后台线程 + 中断事件监听）
4. 解析响应 → 有工具调用则并发执行 → 循环
5. 文本响应 → 持久化会话 → 刷新记忆 → 返回

**迭代预算管理**：默认 90 次迭代，70% 时提醒整理工作，90% 时警告立即完成，100% 强制停止。父子 Agent 共享预算。

---

## 三、闭环学习循环 —— 核心差异化

这是 Hermes Agent 与所有竞品的最大区别点：**它是唯一内置闭环学习循环的 Agent**。

### 3.1 五个环节

```
┌──────────────────────────────────────────┐
│                学习循环                    │
│                                          │
│  ① 自主技能创建                            │
│    └→ 完成复杂任务后自动总结为 SKILL.md      │
│                                          │
│  ② 技能使用中自我改进                       │
│    └→ 使用中发现更好方法 → 自动更新          │
│                                          │
│  ③ 记忆周期性自省                          │
│    └→ Agent 被 nudge 主动持久化知识          │
│                                          │
│  ④ 跨会话搜索                             │
│    └→ FTS5 全文搜索 + LLM 摘要             │
│                                          │
│  ⑤ 用户建模                              │
│    └→ Honcho 辩证建模，逐步深化             │
└──────────────────────────────────────────┘
```

### 3.2 三层记忆系统

| 层级 | 机制 | 容量 | 用途 |
|------|------|------|------|
| L1: 工作记忆 | 对话上下文 | 模型窗口 | 当前对话 |
| L2: 持久记忆 | MEMORY.md + USER.md | ~1,300 tokens | 关键事实常驻 |
| L3: 历史搜索 | SQLite FTS5 | 无限 | 按需回忆 |

**外部记忆插件**（8 个）：Honcho、OpenViking、Mem0、Hindsight、Holographic、RetainDB、ByteRover、Supermemory

### 3.3 技能系统

- **渐进式加载**：Level 0（列表 ~3k tokens）→ Level 1（完整内容）→ Level 2（参考文件）
- **条件激活**：主工具不可用时自动启用降级技能
- **Agent 自创建**：完成复杂任务后自动生成可复用技能
- **开放标准**：兼容 agentskills.io，已被 GitHub Copilot、OpenAI Codex、Claude Code 采纳

---

## 四、部署灵活性

### 4.1 六种终端后端

| 后端 | 场景 | 亮点 |
|------|------|------|
| Local | 本地开发 | 零配置 |
| Docker | 隔离执行 | 只读根文件系统、全 capabilities drop |
| SSH | 远程沙箱 | Agent 和自身代码隔离 |
| Singularity | HPC 集群 | 无 root 权限 |
| Modal | 无服务器 | 空闲休眠、按需唤醒 |
| Daytona | 云工作区 | 持久远程开发环境 |

**无服务器持久化**是亮点：Modal 和 Daytona 提供"休眠-唤醒"模式，Agent 空闲时几乎零成本。

### 4.2 14+ 平台网关

单一后台进程连接所有平台。Discord 和飞书/Lark 功能最完整（语音/图片/文件/线程/反应/打字中/流式全支持）。

安全模型：默认拒绝所有未知用户，支持白名单和 DM 配对（一次性密码学随机码，1小时过期）。

### 4.3 安装

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```
一行命令，自动处理所有依赖。支持 Linux、macOS、WSL2。

---

## 五、自进化系统（GEPA）

Nous Research 还开源了 **hermes-agent-self-evolution** —— 用进化算法自动优化 Agent 自身：

- **引擎**：DSPy + GEPA（遗传-帕累托提示词进化），ICLR 2026 Oral 论文
- **原理**：读取执行轨迹理解失败原因 → 提出针对性变异 → 评估 → 选择最优
- **成本**：~$2-10 每次优化，无需 GPU
- **安全**：所有变更必须通过完整测试套件 + 人工 PR 审查

当前 Phase 1（SKILL.md 优化）已实现，计划扩展到工具描述、系统提示词、工具实现代码。

---

## 六、竞品对比

### 6.1 两个物种

| 物种 | 代表 | 特点 |
|------|------|------|
| 会话型 Agent | Claude Code、Cursor | 会话内能力强，跨会话弱 |
| 持久型 Agent | Hermes Agent、OpenClaw | 永久驻留、持续学习 |

### 6.2 对比矩阵

| 维度 | Hermes Agent | Claude Code | Cursor |
|------|-------------|-------------|--------|
| 开源 | ✅ MIT | ❌ | ❌ |
| 自学习 | ✅ 闭环循环 | ❌ | ❌ |
| 持久记忆 | ✅ 三层 | 有限 | 有限 |
| 多平台 | 14+ | CLI | IDE |
| 模型锁定 | 无（18+ 供应商） | Anthropic | 多模型 |
| 代码产出质量 | 好 | 优秀 | 优秀 |
| 成本 | $5 VPS 起 | 按 token | 订阅制 |
| 数据隐私 | ✅ 完全自托管 | 数据发送 Anthropic | 数据发送服务商 |

### 6.3 Hermes Agent 的独特优势

1. **模型训练 + Agent 飞轮** — 同团队训练模型+做 Agent
2. **RL 训练集成** — 直接生成训练数据反哺模型
3. **自进化** — GEPA 进化算法优化自身
4. **极致成本** — 无服务器休眠，$5/月起
5. **零锁定** — MIT 许可 + 18+ 供应商 + 完全自托管

---

## 七、生态系统

### 7.1 社区项目

| 项目 | 描述 | 成熟度 |
|------|------|--------|
| hermes-workspace (500+ ⭐) | Web 工作区 GUI | production |
| mission-control (3,700+ ⭐) | 多 Agent 编排仪表盘 | production |
| wondelai/skills (380+ ⭐) | 跨平台技能库 | beta |
| hermes-skill-factory | 自动生成技能 | beta |
| autonovel | 自主长篇小说写作 | official |

### 7.2 agentskills.io

由 Anthropic 发起、Nous Research 深度参与的开放技能标准，已被 GitHub Copilot、OpenAI Codex、Claude Code 原生支持。Hermes Agent 是最完整的实现之一。

---

## 八、风险与局限

1. **代码产出质量**：第三方评测显示，Claude Code 和 Cursor 在代码质量上仍有优势
2. **前身关系**：与 OpenClaw 的分支关系可能带来社区分裂
3. **运维成本**：自托管 Agent 需要维护服务器，不适合纯 SaaS 用户
4. **Python 生态**：Python 原生虽然灵活，但在某些场景下性能不及 Node.js
5. **自进化仍在早期**：GEPA Phase 2-5 尚在计划中

---

## 九、总结与建议

Hermes Agent 代表了 AI Agent 发展的一个重要方向：**从工具到伙伴的转变**。它不是让你每次都从头开始的临时工具，而是一个持续学习、不断改进的长期伙伴。

### 适用场景

| 场景 | 推荐度 |
|------|--------|
| 需要完全数据自主权 | ⭐⭐⭐⭐⭐ |
| 需要多平台 7×24 运行 | ⭐⭐⭐⭐⭐ |
| 预算敏感（$5/月起） | ⭐⭐⭐⭐⭐ |
| AI 研究 / RL 训练 | ⭐⭐⭐⭐⭐ |
| 纯编码效率追求 | ⭐⭐⭐（Claude Code 更优） |
| 不想运维服务器 | ⭐⭐（SaaS 方案更合适） |

### 一句话总结

> Hermes Agent 是目前最完整的开源持久型 AI Agent 框架，它的闭环学习循环和自进化能力代表了 Agent 从"无状态工具"向"有记忆伙伴"演进的前沿。

---

## 参考来源

1. [GitHub: NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
2. [Hermes Agent 官方文档](https://hermes-agent.nousresearch.com/docs/)
3. [Hermes Agent 架构文档](https://hermes-agent.nousresearch.com/docs/developer-guide/architecture)
4. [Hermes Agent 记忆系统](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory)
5. [Hermes Agent 技能系统](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills)
6. [hermes-agent-self-evolution (GEPA)](https://github.com/NousResearch/hermes-agent-self-evolution)
7. [awesome-hermes-agent 社区资源](https://github.com/0xNyk/awesome-hermes-agent)
8. [agentskills.io 开放标准](https://agentskills.io/specification)
9. [UBOS: Nous Research Unveils Hermes Agent](https://ubos.tech/news/nous-research-unveils-hermes-agent-multi%E2%80%91level-memory-ai-with-remote-terminal-access/)
10. [The New Stack: OpenClaw vs Hermes Agent](https://thenewstack.io/persistent-ai-agents-compared/)
11. [OpenAIToolsHub: Hermes AI Agent Review](https://www.openaitoolshub.org/en/blog/hermes-agent-ai-review)
