# Harness Engineering 深度分析报告

> **研究员**: 黄山 (wairesearch)
> **日期**: 2026-03-26
> **版本**: v1.0
> **分类**: AI Agent 架构 / 软件工程范式

---

## 执行摘要

**Harness Engineering（线束工程）** 是 2026 年 AI Agent 领域最重要的新兴工程范式。它的核心命题是：

> **Agent = Model + Harness**
> 模型提供智能，线束让智能可用。

这个概念由 OpenAI 在 2026 年 2 月正式提出，随后 Anthropic、LangChain、Martin Fowler 等行业领袖迅速跟进。Harness Engineering 正在重新定义"软件工程师"的角色——从**写代码的人**转变为**设计 Agent 运行环境的人**。

**核心发现**：

1. OpenAI 团队用 3 名工程师 + Codex Agent，5 个月内生成 100 万行代码，**零行手写代码**
2. 工程师的角色从"代码作者"变为"环境设计师"——设计约束、反馈循环和上下文工程
3. Harness 不是框架的替代品，而是**框架之上的运行时层**——框架决定怎么构建 Agent，Harness 决定 Agent 怎么运行
4. OpenAI 和 Anthropic 分别从"编码代理"和"长时运行代理"两个方向验证了 Harness 模式的有效性

---

## 第一章：起源与定义

### 1.1 术语溯源

"Harness"一词来自马具——缰绳、鞍具、嚼子——将一匹强壮且快速的马引导向有用的方向。马不选择去哪，骑手通过线束来操控。这个隐喻精确映射到 Agent 优先的软件开发：

- **马 = AI 模型**：强大、快速，但不知道该往哪走
- **线束 = Harness**：你构建的一切，用来引导它
- **骑手 = 人类工程师**：通过线束来操控

术语的正式使用可追溯到两个来源：

| 时间 | 来源 | 贡献 |
|------|------|------|
| 2025 年 | Mitchell Hashimoto | 在博客中首次使用"Engineer the Harness"描述 AI 辅助开发模式 |
| 2025 年 11 月 | Anthropic | 发布《Effective Harnesses for Long-Running Agents》，将 Harness 概念应用于长时运行代理 |
| 2026 年 2 月 | OpenAI (Ryan Lopopolo) | 发布《Harness Engineering: Leveraging Codex in an Agent-First World》，正式命名该学科 |
| 2026 年 3 月 | Martin Fowler / Thoughtworks | 发表分析文章，从软件工程视角解读 |
| 2026 年 3 月 | LangChain | 发布《The Anatomy of an Agent Harness》，系统化定义组件模型 |
| 2026 年 3 月 | arXiv 论文 | 学术界正式化 Harness Engineering 概念 |

### 1.2 正式定义

综合多方来源，Harness Engineering 有三个层次的定义：

**狭义定义（LangChain）**：

> Harness 是除了模型本身以外的所有代码、配置和执行逻辑。包括系统提示词、工具/技能/MCP、基础设施（文件系统、沙箱、浏览器）、编排逻辑（子代理、切换、路由）、钩子/中间件（压缩、延续、lint 检查）。

**工程定义（OpenAI）**：

> Harness Engineering 是设计约束、反馈循环、文档结构、代码检查规则、可观测性管道和生命周期管理系统的学科，使 AI 编码代理能够在规模上可靠运行。

**架构定义（Cobus Greyling）**：

> Harness 不是 Agent。它是治理 Agent 运行方式的软件系统。它管理完整生命周期——工具、记忆、重试、人类审批、上下文工程、子代理——让模型专注于推理。

### 1.3 Harness vs 相关概念

| 概念 | 关注点 | 问题 |
|------|--------|------|
| **Prompt Engineering** | 如何与模型对话 | 怎么写好提示词？ |
| **Context Engineering** | 如何管理模型的输入 | 给模型看什么信息？ |
| **Framework** | 如何构建 Agent | 用什么架构组装 Agent？ |
| **Harness Engineering** | 如何让 Agent 可靠运行 | Agent 在什么环境中工作？ |

关键区分：**框架告诉开发者如何组织应用，线束告诉 Agent 如何安全运行。** 用框架时，开发者写编排逻辑；用线束时，模型制定计划，线束确保它不偏离轨道。

---

## 第二章：核心组件模型

### 2.1 六大组件（综合 LangChain + Anthropic + OpenAI）

```
┌──────────────────────────────────────────────────────┐
│                    HARNESS                             │
│                                                        │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ 1. 工具集成层 │  │ 2. 记忆与状态 │  │ 3. 上下文工程 │ │
│  │  Tool Layer  │  │Memory & State│  │   Context     │ │
│  └─────────────┘  └──────────────┘  └──────────────┘ │
│                                                        │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ 4. 规划与分解 │  │ 5. 验证与护栏 │  │ 6. 模块化扩展 │ │
│  │  Planning    │  │ Verification │  │ Extensibility│ │
│  └─────────────┘  └──────────────┘  └──────────────┘ │
│                                                        │
│                  ┌─────────┐                           │
│                  │  MODEL  │                           │
│                  └─────────┘                           │
└──────────────────────────────────────────────────────┘
```

#### 组件 1：工具集成层（Tool Integration Layer）

连接模型与外部 API、数据库、代码执行环境和自定义工具。

- **Bash + 代码执行**：通用工具原语，让模型自主设计临时工具
- **MCP（Model Context Protocol）**：标准化工具接口
- **文件系统**：最基础的 Harness 原语——Agent 的工作台

> "与其强迫用户为每个可能的动作构建工具，不如给 Agent 一个通用工具：Bash。" —— LangChain

#### 组件 2：记忆与状态管理（Memory & State）

多层记忆：工作上下文 → 会话状态 → 长期记忆，跨上下文窗口持久化。

- **AGENTS.md / CLAUDE.md**：启动时注入的记忆文件
- **progress.txt**：跨会话的进度追踪（Anthropic 方案）
- **Git 历史**：天然的版本化记忆系统

#### 组件 3：上下文工程（Context Engineering）

动态策划每次模型调用中出现的信息。不是静态提示词模板，而是基于当前任务状态的**主动上下文选择**。

- **渐进式披露**：AGENTS.md 是目录，不是百科全书
- **上下文压缩（Compaction）**：智能卸载和总结已有上下文
- **工具输出裁剪**：大输出只保留头尾 token，全文写入文件系统

#### 组件 4：规划与分解（Planning & Decomposition）

引导模型通过结构化任务序列，而非一次性尝试所有事情。

- **特性列表**（Anthropic）：将大目标分解为 200+ 个可验证的小特性
- **执行计划**（OpenAI）：版本化的计划文件，含进度和决策日志
- **增量进步**：每次会话只处理一个特性

#### 组件 5：验证与护栏（Verification & Guardrails）

验证检查、格式验证、安全过滤。自我修正循环。

- **机械化不变量**：自定义 linter + CI 强制执行架构约束
- **端到端测试**：浏览器自动化验证（不只是单元测试）
- **Agent-to-Agent Review**：Agent 互相审查代码

#### 组件 6：模块化与可扩展性（Modularity & Extensibility）

可插拔组件，可独立启用、禁用或替换。

- **技能系统**：按需加载能力，避免上下文膨胀
- **子代理生成**：专门化的子任务委托
- **Provider 无关设计**：可切换模型而无需重建系统

---

## 第三章：OpenAI 实验——从零到百万行代码

### 3.1 实验概况

| 维度 | 数据 |
|------|------|
| **起始时间** | 2025 年 8 月 |
| **持续时间** | 5 个月 |
| **团队规模** | 3 → 7 名工程师 |
| **代码规模** | ~100 万行 |
| **PR 数量** | ~1,500 个 |
| **人均日 PR** | 3.5 个 |
| **手写代码** | 0 行 |
| **预估节省** | 10x 时间 |
| **使用模型** | Codex（GPT-5 驱动） |

### 3.2 核心理念：人类操控，Agent 执行

```
传统开发：
  人类 → 写代码 → 测试 → 部署

Harness 开发：
  人类 → 设计环境 → 描述意图 → 构建反馈循环
    ↓
  Agent → 写代码 → 自我审查 → 互相审查 → 迭代 → 合并
```

关键原则：**当出错时，修复方案几乎从不是"再努力一点"。** 而是问："缺少什么能力？如何让它对 Agent 既可读又可执行？"

### 3.3 知识管理架构

```
AGENTS.md               ← 目录页（~100 行）
ARCHITECTURE.md          ← 顶层领域地图
docs/
├── design-docs/         ← 索引化、已验证的架构决策
├── exec-plans/
│   ├── active/          ← 进行中的计划
│   ├── completed/       ← 已完成的计划
│   └── tech-debt-tracker.md
├── generated/
│   └── db-schema.md
├── product-specs/
├── references/          ← 外部库文档（为 LLM 重新格式化）
├── DESIGN.md
├── FRONTEND.md
├── PLANS.md
├── QUALITY_SCORE.md
├── RELIABILITY.md
└── SECURITY.md
```

OpenAI 仓库中有 **88 个 AGENTS.md 文件**，每个主要子系统一个，保持指令的本地性和最小化。

### 3.4 架构强制执行

```
每个业务域内的依赖方向：

  Types → Config → Repo → Service → Runtime → UI

横切关注点（auth, connectors, telemetry, feature flags）
仅通过 Providers 接口进入。其他方式一律禁止。
```

这种架构通常在团队达到几百人时才实施。在 Agent 优先开发中，它是**早期前提条件**——约束就是速度。

### 3.5 "稀缺性逆转"

| 传统开发 | Agent 优先开发 |
|----------|---------------|
| 计算便宜 | 计算便宜 |
| 人的注意力**适度稀缺** | 人的注意力**极度稀缺** |
| 瓶颈 = 复杂度 | 瓶颈 = 人类 QA 能力 |
| 等待便宜，纠错贵 | **等待昂贵，纠错便宜** |

---

## 第四章：Anthropic 方案——长时运行 Agent 的线束

### 4.1 核心问题

> 想象一个由轮班工程师组成的软件项目，每个新工程师到岗时对上一班发生的事情**毫无记忆**。

长时运行 Agent 的核心挑战：必须在离散会话中工作，每个新会话以**零记忆**开始。

### 4.2 两部分解决方案

```
Session 1: 初始化 Agent
  ├── 创建 init.sh（开发环境启动脚本）
  ├── 创建 claude-progress.txt（进度追踪文件）
  ├── 创建 feature_list.json（200+ 特性列表，全部标记 "passes: false"）
  └── 初始 git commit

Session 2~N: 编码 Agent
  ├── pwd → 读取 progress.txt → 读取 git log
  ├── 启动开发服务器 → 运行基础验证
  ├── 选择最高优先级的未完成特性
  ├── 实现 + 端到端测试（Puppeteer 浏览器自动化）
  ├── git commit + 更新 progress.txt
  └── 仅在通过测试后标记 "passes: true"
```

### 4.3 失败模式与修复

| 失败模式 | 原因 | 线束修复 |
|----------|------|----------|
| Agent 过早宣布项目完成 | 缺乏全局任务视野 | 特性列表文件，每个特性有 passes 状态 |
| 环境留下 bug 或未记录进度 | 无跨会话状态传递 | progress.txt + git commit 日志 |
| 特性标记完成但未真正测试 | 缺乏端到端验证 | 强制浏览器自动化测试 |
| Agent 花时间弄清如何运行应用 | 缺乏标准启动流程 | init.sh 脚本 |

### 4.4 关键洞见

Anthropic 的灵感来源：**有效的软件工程师每天都在做什么**——记录进度、增量交付、留下清晰的交接文档。Harness Engineering 本质上是将**优秀工程实践编码到系统中**。

---

## 第五章：LangChain 组件模型——从模型视角推导 Harness

### 5.1 核心公式

```
Agent = Model + Harness
如果你不是模型，你就是线束的一部分。
```

### 5.2 推导路径：期望行为 → Harness 设计

LangChain 的方法论是从**期望的 Agent 行为**反向推导 Harness 需求：

| 期望行为 | Harness 特性 |
|----------|-------------|
| 持久化存储，跨会话工作 | 文件系统抽象 + 工具 |
| 自主解决问题 | Bash + 代码执行（通用工具） |
| 安全执行，规模化 | 沙箱隔离 + 权限控制 |
| 记住之前的工作 | AGENTS.md 记忆文件 + 搜索工具 |
| 长时间不退化 | 上下文压缩 + 工具输出裁剪 + 技能渐进式加载 |
| 长周期自主完成复杂任务 | Ralph Loop + 计划文件 + 自我验证 |

### 5.3 Ralph Loop（拉尔夫循环）

```
while task_not_complete:
    agent.run(task_prompt, fresh_context_window)
    # Agent 读取文件系统中的状态
    # Agent 执行工作
    # Agent 将进度写入文件系统
    # Harness 拦截退出尝试
    # 重新注入原始 prompt 到新的上下文窗口
```

这是 Harness 的核心模式之一：**利用文件系统桥接上下文窗口的断裂**。

### 5.4 模型训练与 Harness 的耦合

> 今天的 Agent 产品（Claude Code、Codex）是在模型和 Harness 在循环中训练的。这帮助模型提升了 Harness 设计者认为应该原生擅长的操作。

这创造了一个反馈循环：发现有用的原语 → 加入 Harness → 用于训练下一代模型 → 模型在该 Harness 中变得更强。

但这有副作用——**过拟合**。例如 Codex 的 `apply_patch` 工具：更换补丁逻辑会导致模型性能下降，真正智能的模型不应该受限于此。

Terminal Bench 2.0 排行榜验证了 Harness 的重要性：**Opus 4.6 在 Claude Code 中的得分远低于在其他 Harness 中**。仅通过优化 Harness 就能从 Top 30 提升到 Top 5。

---

## 第六章：Martin Fowler 视角——行业影响分析

### 6.1 Harness 是新的服务模板？

大多数组织只有两三个主要技术栈。Martin Fowler 设想了一个未来：**团队从一组 Harness 中选择来启动新项目**，就像今天的服务模板（Golden Path）一样。

但同样面临服务模板的老问题：分叉 (fork) 和同步 (sync) 的挑战。

### 6.2 运行时约束换来 AI 自主性

早期 AI 编程的炒作假设 LLM 给我们无限的灵活性——任何语言、任何模式。但 OpenAI 的实验表明：**增加信任和可靠性需要约束解空间**。

这意味着放弃"生成任何东西"的灵活性，换取**可维护、可信任的 Agent 生成代码**。

### 6.3 技术栈收敛

随着编码从"敲代码"变为"指导代码生成"，AI 可能推动我们走向**更少的技术栈**。团队会选择有好 Harness 可用的栈，优先考虑"AI 友好性"。

### 6.4 两个世界：AI 前 vs AI 后

| 维度 | AI 前的应用 | AI 后的应用 |
|------|------------|------------|
| 代码生成 | 人类手写 | Agent 生成 |
| 架构约束 | 通常推迟 | 早期前提 |
| 文档 | 经常过时 | 机械验证，持续维护 |
| Harness 适配 | 需要改造（可能不值得） | 从头设计 |

对旧代码库改造 Harness 就像在从未用过静态分析工具的代码库上运行分析——会被警报淹没。

---

## 第七章：Harness Engineering 与 OpenClaw 的映射

从 Harness Engineering 的六大组件视角审视 OpenClaw：

| Harness 组件 | OpenClaw 对应 | 成熟度 |
|-------------|-------------|-------|
| **工具集成层** | Tool Policy + MCP + Exec + Skills | ⭐⭐⭐⭐⭐ 完善 |
| **记忆与状态** | MEMORY.md + LCM (Lossless Context Management) + Session Store | ⭐⭐⭐⭐ 良好 |
| **上下文工程** | AGENTS.md + SOUL.md + Skills 渐进式加载 + Compaction | ⭐⭐⭐⭐ 良好 |
| **规划与分解** | Sub-agents + ACP + sessions_spawn + task delegation | ⭐⭐⭐⭐ 良好 |
| **验证与护栏** | Tool Policy + Sandbox + Exec Approvals + Elevated Mode | ⭐⭐⭐⭐⭐ 完善 |
| **模块化扩展** | Skills (ClawHub) + Hooks + Cron + Channel Plugins | ⭐⭐⭐⭐⭐ 完善 |

### 7.1 OpenClaw 的 Harness 优势

1. **Skills = 渐进式上下文注入**：完美实现了"不要一次性加载所有工具"的 Harness 原则
2. **LCM = 上下文压缩**：Lossless Context Management 提供了对话历史的无损压缩
3. **ACP = Agent 编排**：支持 Claude Code / Codex / Pi 等多种 Agent 运行时
4. **Sandbox = 安全执行**：Docker 隔离的代码执行环境
5. **Multi-Agent = 专家分工**：协调者-专家模式天然适配 Harness 架构

### 7.2 与 OpenAI 方法的差异

| OpenAI 方法 | OpenClaw 方法 |
|------------|-------------|
| AGENTS.md 作为目录 | AGENTS.md + SOUL.md + MEMORY.md + TOOLS.md 多文件体系 |
| 自定义 linter 强制架构 | Tool Policy + Exec Approvals 强制安全 |
| Agent-to-Agent Review | Sub-agent 模式 + sessions_send |
| 仓库内知识库 | Workspace + Skills + Memory 三层知识体系 |
| Codex 单一模型 | Provider 无关，支持多模型切换 |

---

## 第八章：实践指南——最小可行 Harness 清单

基于所有来源的综合，一个 **Minimum Viable Harness** 应包含：

### Tier 1：必须有（Day 1）

- [ ] **AGENTS.md 入口点**：小而精的目录，指向更深的文档
- [ ] **可复现的开发环境**：一条命令启动，每个工作树隔离
- [ ] **CI 中的机械不变量**：架构边界、格式化、数据验证、依赖规则
- [ ] **安全护栏**：最小权限凭证、受控出口、审计日志、回滚手册

### Tier 2：应该有（Week 1）

- [ ] **Agent 可读性钩子**：结构化日志 + 可查询的追踪/指标
- [ ] **明确的评估门**：完成标准、回归测试、安全检查
- [ ] **进度追踪文件**：跨会话的状态传递机制
- [ ] **渐进式知识库**：设计文档、执行计划、技术债务追踪

### Tier 3：最好有（Month 1）

- [ ] **Agent-to-Agent Review**：自动化代码审查
- [ ] **可观测性堆栈**：Agent 可直接查询日志和指标
- [ ] **文档园丁 Agent**：定期清理过时文档
- [ ] **自定义 Linter**：错误信息中嵌入修复指令

---

## 第九章：未来趋势与预判

### 9.1 框架层的消融

Cobus Greyling 的观察：框架层正在分裂。

```
传统架构：
  SDK → Framework → Application

Harness 时代：
  SDK → Framework → Application
                       ↕
            ┌──────────────────┐
            │     HARNESS      │ ← 新层
            │  (运行时治理)      │
            └──────────────────┘
```

框架的 80% 功能（Agent 定义、消息路由、任务生命周期）正在被模型吸收。剩下的 20%（持久化、确定性重放、成本控制、可观测性、错误恢复）正是 Harness 提供的。

### 9.2 模型训练与 Harness 的共同进化

```
发现有用原语 → 加入 Harness → 训练模型 → 模型变强
     ↑                                      │
     └──────────────────────────────────────┘
```

这意味着 **Harness 设计者实际上在影响下一代模型的训练方向**。

### 9.3 Harness Engineer 新角色

| 传统角色 | Harness 时代对应 |
|----------|-----------------|
| 后端工程师 | Harness 设计师 + 约束工程师 |
| 前端工程师 | Agent 可读性工程师 |
| DevOps | Agent 可观测性工程师 |
| QA 工程师 | 验证循环设计师 |
| 技术文档 | 知识库架构师 |

### 9.4 Prompt Engineering → Context Engineering → Harness Engineering

这三个学科的演进关系：

```
2023: Prompt Engineering    → 如何与模型对话
2024: Context Engineering   → 给模型什么信息
2025: Harness Engineering   → 模型在什么环境中工作
2026: ??? Engineering       → 模型如何自我改进运行环境
```

---

## 第十章：关键洞见总结

### 10.1 十大核心原则

1. **Agent = Model + Harness** —— 如果你不是模型，你就是线束
2. **地图，不是手册** —— AGENTS.md 是目录，不是百科全书
3. **约束即速度** —— 架构约束是 Agent 高速开发的前提
4. **机械执行优于文档约定** —— 能写成 linter 的规则就不要只写成文档
5. **等待昂贵，纠错便宜** —— Agent 吞吐量远超人类注意力时，快速修复优于长时间阻塞
6. **仓库是唯一的真相来源** —— Agent 看不到的东西等于不存在
7. **渐进式披露** —— 小入口点 + 按需深入，不要一次性塞满
8. **增量进步** —— 每次只做一件事，做完就提交
9. **无聊的技术更好** —— 可组合、API 稳定、训练集覆盖率高
10. **人类的品味持续反馈** —— Review 意见、重构 PR、Bug 都是 Harness 改进的信号

### 10.2 一句话总结

> **2025 年是 AI Agent 证明它们能写代码的一年。2026 年是行业认识到 Agent 不是难点——Harness 才是。**

---

## 参考来源

1. OpenAI. "Harness Engineering: Leveraging Codex in an Agent-First World." 2026-02. https://openai.com/index/harness-engineering/
2. Anthropic. "Effective Harnesses for Long-Running Agents." 2025-11. https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
3. LangChain (Vivek Trivedy). "The Anatomy of an Agent Harness." 2026-03. https://blog.langchain.com/the-anatomy-of-an-agent-harness/
4. Martin Fowler / Birgitta Böckeler. "Harness Engineering." 2026-03. https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html
5. GTCode. "Harness Engineering: The Discipline of Building Systems That Make AI Agents Work." 2026-03. https://gtcode.com/articles/harness-engineering/
6. Cobus Greyling. "The Rise of AI Harness Engineering." Medium, 2026-03. https://cobusgreyling.medium.com/the-rise-of-ai-harness-engineering-5f5220de393e
7. Deepak Bhaskaran. "Harness Engineering." Medium, 2026-03. https://medium.com/@deepak.bhaskaran/harness-engineering-d50960e497d0

---

*报告由 wairesearch (黄山) 生成 | 2026-03-26*
