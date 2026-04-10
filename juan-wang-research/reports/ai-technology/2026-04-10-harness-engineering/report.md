# Harness Engineering 双雄研读报告：OpenAI vs Anthropic 的 Agent 工程哲学

> **研究员**：黄山（wairesearch）| **日期**：2026-04-10 | **版本**：1.0

---

## 执行摘要

2026 年 2-3 月，OpenAI 和 Anthropic 先后发布了关于 **Harness Engineering** 的深度工程文章。OpenAI 的 Ryan Lopopolo 讲述了用 Codex **0 行手写代码构建百万行产品**的 5 个月实验；Anthropic 的 Prithvi Rajasekaran 展示了受 **GAN 启发的 Generator-Evaluator 三 Agent 架构**如何让 Claude 构建完整应用。两篇文章从不同角度回答了同一个核心问题：**当 Agent 写代码时，人类工程师到底在做什么？** 答案是：构建 Harness——工具、约束、反馈循环和环境设计。

---

## 一、两篇文章概览

| | OpenAI | Anthropic |
|--|--------|-----------|
| **标题** | Harness Engineering: Leveraging Codex in an Agent-First World | Harness Design for Long-Running Application Development |
| **作者** | Ryan Lopopolo | Prithvi Rajasekaran (Labs) |
| **发布** | 2026-02-11 | 2026-03-24 |
| **核心实验** | 5 个月、0 行手写代码、100 万行产品 | GAN 式三 Agent 构建完整应用 |
| **关键模型** | GPT-5 (Codex) | Claude Opus/Sonnet 4.5 → 4.6 |
| **URL** | openai.com/index/harness-engineering | anthropic.com/engineering/harness-design-long-running-apps |

---

## 二、OpenAI：人类掌舵，Agent 执行

### 2.1 实验设计

一个极端约束：**"No manually-written code"**——100% 由 Codex 生成。

- **规模**：100 万行代码、1,500 PR、3→7 人团队
- **效率**：3.5 PR/工程师/天，估计 10 倍提速
- **产品**：有内部日活用户的真实产品

### 2.2 核心发现

#### ① AGENTS.md 是地图，不是百科全书

一个巨大的指令文件会失败。正确做法：**~100 行导航 + docs/ 深层文档 + CI 验证时效性**。

#### ② 渐进式披露（Progressive Disclosure）

Agent 从小而稳定的入口开始，被教会"去哪里找更多信息"。

#### ③ 仓库 = Agent 的全部世界

> "不在 context 中的东西等于不存在。"

Slack 讨论、脑中决策必须推入仓库版本化。

#### ④ 约束是乘数

```
每个业务域：Types → Config → Repo → Service → Runtime → UI
只能向前依赖，自定义 linter 强制执行
```

> "在人类工作流中这些规则显得迂腐。对 Agent，它们是乘数。"

#### ⑤ 垃圾回收式技术债管理

初期每周五 20% 时间手动清理"AI slop" → 不可持续。

解法：编码"黄金原则"+ 定期 Codex 后台扫描 + 自动修复 PR。

> "技术债务像高利贷——小额持续偿还好过一次性大清理。"

#### ⑥ 端到端自主

最终达到一次提示完成：复现 bug → 录视频 → 修复 → 验证 → 开 PR → 响应反馈 → 合并。仅在需要判断时升级给人。

---

## 三、Anthropic：GAN 启发的对抗式 Harness

### 3.1 两个失败模式

**失败模式 1：上下文焦虑**
- 模型接近上下文上限时**过早收尾**
- Sonnet 4.5 严重；Compaction 不够，需要 **Context Reset**（全清 + 结构化交接）
- Opus 4.5/4.6 基本消除了这个问题

**失败模式 2：自我评估偏差**
- Agent 评估自己的工作时**总给好评**，即使质量平庸
- 设计任务尤其严重（无二元验证标准）
- **解法**：分离做事者和评判者——灵感来自 GAN

### 3.2 前端设计实验

四个评分维度（重点加权 Design Quality 和 Originality，惩罚 AI slop）：

| 维度 | 权重 | 说明 |
|------|------|------|
| Design Quality | **高** | 是否形成独特氛围和身份？ |
| Originality | **高** | 有自定义决策还是模板默认？ |
| Craft | 低 | 技术执行力 |
| Functionality | 低 | 可用性 |

- Evaluator 用 **Playwright MCP 实际操作页面**（不是看截图）
- 5-15 轮迭代，每轮 Generator 决定：细化 or 彻底转向
- 完整运行最长 4 小时

**惊人案例**：荷兰艺术博物馆网站第 10 轮迭代，Generator 推翻前 9 轮作品，创造了一个 CSS 3D 透视的空间展览体验——**前所未见的创造性飞跃**。

### 3.3 全栈三 Agent 架构

```
Planner（1-4 句 → 完整产品规格，鼓励野心）
    ↓
Generator（按 Sprint 实现，每个 Sprint 前与 Evaluator 协商合同）
    ↓
Evaluator（Playwright 实际操作应用，逐条验证合同，低于阈值 → Sprint 失败）
```

#### Sprint 合同机制（关键创新）

Sprint 开始前 Generator 和 Evaluator **协商"完成"的定义**。Sprint 3 单独就有 27 个验证条件。

#### 对比实验结果

| | Solo | 三 Agent Harness |
|--|------|-----------------|
| 时间/成本 | 20min / $9 | 6hr / $200 |
| 功能范围 | 基础 | 16 功能、10 Sprint、含 AI |
| 游戏可玩 | ❌ | ✅ |
| 设计质量 | 空间浪费 | 全视口、一致视觉 |

### 3.4 Opus 4.6 的颠覆

用 Opus 4.6 复现实验后：**单 Agent 的输出质量接近三 Agent 系统**。

> "Opus 4.6 不需要外部评估器来保持正轨。"

这引出核心问题：**当模型足够好时，harness 应该如何演化？**

---

## 四、深度对比分析

### 4.1 哲学差异

| | OpenAI | Anthropic |
|--|--------|-----------|
| **隐喻** | Agent 是新员工 | GAN 的对抗训练 |
| **核心主张** | 纪律在脚手架 | 分离做事和判断 |
| **人类角色** | 架构师/环境设计师 | 品味校准者/标准制定者 |

### 4.2 长会话策略差异

| | OpenAI | Anthropic |
|--|--------|-----------|
| 上下文管理 | 仓库文档化 + 渐进披露 | Context Reset 或 SDK 压缩 |
| 状态持久化 | 仓库即状态 | 结构化交接产物 |
| 会话长度 | Codex 单次运行 6+ 小时 | 全 harness 运行 6 小时 |

### 4.3 质量保证策略差异

| | OpenAI | Anthropic |
|--|--------|-----------|
| 审查 | Agent 互审 + Ralph Wiggum 循环 | 独立 Evaluator + Sprint 合同 |
| 自评态度 | 鼓励自审+互审 | 明确认为自评不可靠 |
| 执行机制 | 自定义 linter + CI | 合同阈值 + Playwright QA |

### 4.4 对待 AI Slop

| | OpenAI | Anthropic |
|--|--------|-----------|
| 问题描述 | 复制已有模式导致漂移 | 倾向安全/平庸设计 |
| 解法 | 黄金原则 + 自动扫描修复 | 评分标准惩罚 + 评估器反馈 |

---

## 五、共识与共鸣

两篇文章虽视角不同，但在五个核心观点上高度一致：

### ① Harness 是真正的工程难点
> OpenAI: "纪律体现在脚手架而非代码"
> Anthropic: "Harness design 是前沿 agentic coding 的关键"

### ② 约束 > 指令
机械执行的规则 > 散文式的提示。Linter > AGENTS.md。合同阈值 > "请写好代码"。

### ③ 环境决定上限
Agent 的能力上限不是模型智能，而是其运行环境的规范程度。

### ④ 分离关注点
OpenAI 分离人类掌舵/Agent 执行；Anthropic 分离生成/评判。

### ⑤ 迭代而非完美
OpenAI："修正便宜，等待昂贵"；Anthropic：5-15 轮迭代，允许失败和转向。

---

## 六、互补价值

两篇文章回答了不同但互补的问题：

| OpenAI 回答 | Anthropic 回答 |
|------------|---------------|
| 如何让工程团队以 Agent-first 运作？ | 如何让 Agent 在长会话中保持高质量？ |
| 如何管理百万行 Agent 代码库？ | 如何把主观品质变成可评分的？ |
| 如何持续维护而非一次性构建？ | 如何让 Agent 突破"安全但平庸"？ |
| 人类工程师新角色是什么？ | 模型变强后 harness 如何演化？ |

---

## 七、对从业者的启示

### 7.1 给 AI 工程师的

1. **投资环境设计 > 投资提示词优化**
2. **用机械约束替代自然语言指令**——linter、schema、阈值
3. **分离生成和评估**——即使简单的 Agent 也受益于独立审查
4. **仓库是 Agent 的唯一真相来源**——推入一切、版本化一切
5. **设计"垃圾回收"机制**——技术债持续偿还

### 7.2 给技术管理者的

1. **Agent-first 团队的角色转变**：工程师 → 环境设计师/品味校准者
2. **Agent 吞吐远超人类时，传统审查流程成为瓶颈** → 需要 Agent 互审
3. **成本-质量权衡**：Solo $9 vs Harness $200 → 看需求，不是所有任务都需要三 Agent
4. **模型在变强**：Opus 4.6 让三 Agent 系统变得不必要 → harness 设计要跟随模型进化

### 7.3 给架构师的

1. **严格架构是 Agent 生产力的先决条件，不是奢侈品**
2. **"无聊技术"对 Agent 更友好**——可组合、API 稳定、训练集丰富
3. **渐进式披露**：地图 + 指针 > 百科全书
4. **Sprint 合同模式**值得在任何多 Agent 系统中采用

---

## 八、一句话总结

> **OpenAI 告诉我们如何让 Agent 团队持续运转，Anthropic 告诉我们如何让 Agent 突破品质天花板。合在一起，它们定义了 2026 年 Harness Engineering 的两大支柱：环境工程 + 对抗式反馈。**

---

## 参考来源

1. [OpenAI: Harness Engineering — Leveraging Codex in an Agent-First World](https://openai.com/index/harness-engineering/) (2026-02-11)
2. [Anthropic: Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps) (2026-03-24)
3. [Anthropic: Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)（前作）
4. [OpenAI: Unrolling the Codex Agent Loop](https://openai.com/index/unrolling-the-codex-agent-loop/) (2026-01-23)
5. [OpenAI: Unlocking the Codex Harness — App Server](https://openai.com/index/unlocking-the-codex-harness/) (2026-02-04)
6. [Understanding Data: Generator-Evaluator Harness Design](https://understandingdata.com/posts/generator-evaluator-harness-design/)
7. [GitHub: awesome-harness-engineering](https://github.com/walkinglabs/awesome-harness-engineering)
