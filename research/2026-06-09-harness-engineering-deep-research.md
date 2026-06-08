# Harness Engineering 深度研究报告

> AI 编码 Agent 的"框架/约束系统工程"——一个正在成型的工程范式

**研究员**：黄山（System Architect & Technology Researcher）
**日期**：2026-06-09
**类型**：团队资料库 / 可能对外发布的深度研究
**方法**：一手原文精读（OpenAI 1 篇 + Anthropic 2 篇）+ 二手权威（LangChain / Thoughtworks / HumanLayer 等）交叉验证 + GitHub 数据实测 + 社区讨论扫描

---

## 摘要（TL;DR）

- **一句话定义**：Harness（马具/挽具）= AI Agent 系统里**除模型权重之外的一切**——提示词、工具、环境/沙箱、状态管理、验证反馈、编排逻辑。业界共识公式：**Agent = Model + Harness**（LangChain 提出）。
- **核心论点**：harness **不让模型更聪明**，而是给模型建一个「闭环工作系统」。同一个模型（如 Opus 4.5）在裸环境 vs 完整 harness 下，产出可以从"核心功能跑不起来"跃迁到"完全可玩"——Anthropic 实测，区别只在 harness。
- **为什么 2025–2026 爆火**：模型能力（SWE-bench Verified ~50–60%）与真实任务可靠性之间存在巨大"能力鸿沟（Capability Gap）"；当三家前沿实验室（OpenAI/Anthropic/LangChain）在 2025 年底–2026 年初几乎同时正式命名并系统化这一实践后，它从零散技巧上升为有名字的工程范式。
- **判断**：harness engineering 大概率会成为"后提示词时代"AI 编码工程的核心实践层，但它**不是一个稳定收敛的术语**——目前对"harness 与 context engineering 谁包含谁"业界存在明确分歧（详见关系网章节）。它本质是把"资深工程师的隐性经验"外部化、显式化、可机械执行化。

---

## 1. 概念本质：什么是 harness / harness engineering

### 1.1 词源与定义

"Harness" 字面是马具/挽具——套在马身上、把马的力量导向有用方向的装置。这个隐喻精准：**模型是马（力量/智能），harness 是挽具（让力量产生有用功）**。课程站 Lecture 01 用了"良驹也需要好鞍具（tack）"的同义比喻。

业界最干净的定义来自 LangChain 的 Vivek Trivedy（《The Anatomy of an Agent Harness》）：

> **Agent = Model + Harness。如果你不是模型，你就是 harness。**
> harness 是"模型本身之外的每一段代码、配置和执行逻辑"。

具体包含：系统提示词；工具/Skills/MCP 及其描述；捆绑的基础设施（文件系统、沙箱、浏览器）；编排逻辑（子 agent 派生、交接、模型路由）；钩子/中间件（压缩、续跑、lint 检查等确定性执行）。

**术语归属的考据**（多源存在差异，如实标注）：
- HumanLayer 称 "harness engineering" 一词由 **Viv（Vivek Trivedy）** 提出。
- 同一篇文章又引 **Mitchell Hashimoto** 的定义："每当发现 agent 犯了一个错，就花时间工程化一个解决方案，让 agent 永远不再犯同样的错。"
- 另有 nyosegawa 的博客称"最初定义"来自 Mitchell Hashimoto（持续改进 AGENTS.md + 让 agent 自验证的工具链）。
- 结论：**这是一个 2025 年底自下而上涌现、尚无单一权威首创者的术语**，不同来源给的"起源"不一致——本身就是新概念的特征。

### 1.2 它解决什么问题：能力鸿沟与验证鸿沟

课程 Lecture 01 给出了最系统的问题框架（与 OpenAI/Anthropic 原文互证）：

- **Capability Gap（能力鸿沟）**：最强编码 agent 在 SWE-bench Verified 上约 50–60% 通过率，但那是"精选的、有清晰 issue 描述和现成测试"的任务。换成日常需求（模糊规格、没有测试、业务规则隐含散落），通过率进一步暴跌。
- **Verification Gap（验证鸿沟）**：agent 对自己输出的信心 vs 实际正确性之间的差距。"我做完了"但其实没做完——这是最常见的失败模式。

五大真实失败模式（Lecture 01，与两篇 Anthropic 原文高度一致）：
1. **需求模糊** → agent 只能猜（"加个搜索功能"近乎没有信息量）。
2. **隐式约定没写下来** → agent 无从遵守（团队用 SQLAlchemy 2.0，agent 默认写 1.x）。
3. **环境不完整** → agent 把宝贵 context 烧在 pip/Node 版本冲突上。
4. **没有验证手段** → agent"感觉对了"就宣称完成。
5. **跨会话状态丢失** → 每个新会话从零重新探索；超过 30 分钟的任务失败率陡增。

### 1.3 为什么 2025–2026 突然成为热词

几个力量叠加：
- **模型够强了，瓶颈右移**：当 Opus 4.5 / GPT-5 Codex 已足够聪明，可靠性瓶颈从"模型不够强"转移到"环境/反馈/状态没设计好"。OpenAI 原文的结论句很直白："我们最难的挑战现在集中在**设计环境、反馈循环和控制系统**。"
- **三大实验室同期正式命名**：OpenAI《Harness engineering》、Anthropic 两篇 harness 文章、LangChain《Anatomy of an Agent Harness》在 2025 末–2026 初密集发布，把零散技巧抬升为有名字的范式。
- **长程自主任务成为新战场**：agent 要跑数小时甚至数天、跨多个 context window，这暴露了"单 prompt 搞不定"的结构性问题，harness 成为唯一解。
- **Thoughtworks Technology Radar 收录**"Harness Engineering"，标志其进入主流工程话语。

---

## 2. 一手权威来源解读（必读原文核心提炼）

### 2.1 OpenAI《Harness engineering: leveraging Codex in an agent-first world》

**这是本主题的旗舰一手文献，也是"harness engineering"作为标题被前沿实验室正式背书的标志。**

**实验设定**：OpenAI 一个团队做了 5 个月实验——**0 行人工手写代码**，从一个空 git 仓库开始，所有代码（应用逻辑、测试、CI、文档、可观测性、内部工具）全部由 Codex（GPT-5）写。结果：约**100 万行代码**，约 **1,500 个 PR**，团队从 3 人增长到 7 人，人均 **3.5 PR/天**（且吞吐随团队扩大而上升）。产品有内部日活用户和外部 alpha 测试者。估算约为手写的 **1/10 时间**。核心哲学：**Humans steer, agents execute（人掌舵，agent 执行）；no manually-written code（不手写代码）**。

**核心论点（提炼）**：

1. **工程师角色被重定义**：早期进展慢不是因为 Codex 不行，而是"环境定义不足（environment underspecified）"。工程师的主要工作变成"让 agent 能干活"——每次失败问的不是"再试一次"，而是"**缺了什么能力，怎么让它对 agent 既可见（legible）又可强制（enforceable）**"。

2. **仓库知识即系统的唯一真相源（system of record）**：
   - "一个大 AGENTS.md"的做法**失败**了：挤占 context、太多指导=没有指导、瞬间腐烂、难以校验。
   - 改用：**AGENTS.md 当目录（~100 行的 map），不当百科全书**；真相存在结构化 `docs/` 目录。设计文档编目并带验证状态；架构文档给出域和分层地图；质量文档给每个域打分。
   - **计划是一等公民**：轻量计划用于小改动，复杂工作用 execution plans（带进度和决策日志，checked into repo）。
   - **机械强制**：专用 linter 和 CI 校验知识库是否最新、交叉链接、结构正确；一个"doc-gardening" agent 定期扫描过时文档并开修复 PR。
   - 关键理念叫 **progressive disclosure（渐进式披露）**：agent 从小而稳的入口开始，被教去哪里找下一步，而不是一上来被淹没。

3. **Agent legibility（对 agent 的可读性）是终极目标**："从 agent 视角看，它运行时拿不到的东西=不存在"。存在 Google Docs、聊天记录、人脑里的知识对系统不可见。所以要不断把 context 推进 repo。倾向"无聊的"技术（API 稳定、训练集里有、可组合）；有时让 agent 重新实现一个子集比依赖不透明的上游库更划算（举例：自己实现 map-with-concurrency 而非引 p-limit）。

4. **强制架构与品味（enforce invariants, not implementations）**：
   - 围绕刚性架构模型构建：每个业务域分固定层级（Types → Config → Repo → Service → Runtime → UI），依赖方向严格单向，跨切面关注点（auth/telemetry/feature flags）只能через 单一 Providers 接口进入。
   - 用**自定义 linter + 结构测试**机械强制；自定义 lint 的错误消息里**注入修复指令到 agent 的 context**。
   - "集中强制边界，本地允许自治"——像管理大型工程平台组织。

5. **吞吐量改变合并哲学**：最小化阻塞性合并门禁、PR 短命、测试 flake 用重跑而非无限阻塞。"在 agent 吞吐远超人类注意力的系统里，纠错很便宜，等待很昂贵。"（注：HN 上对此有争议，见社区章节）

6. **熵与垃圾回收**：Codex 会复制 repo 里已有的（哪怕次优的）模式 → 漂移。早期人工每周五花 20% 清"AI slop"，不可扩展。改为把"golden principles"编码进 repo + 后台 Codex 任务定期扫描偏差、更新质量分、开重构 PR（多数 1 分钟内可审、自动合并）。比喻：技术债像高息贷款，持续小额偿还优于积累后集中爆发。

7. **自主性递增**：repo 最近跨过一个阈值——给一个 prompt，Codex 能端到端：验证当前状态 → 复现 bug → 录制失败视频 → 实现修复 → 驱动应用验证 → 录制修复视频 → 开 PR → 响应反馈 → 检测并修复构建失败 → 仅在需要判断时上报人类 → 合并。**但明确警告：这高度依赖该 repo 的特定结构和工具，不应假设可泛化。**

**应用可读性的具体手段**（很实操）：让 app 可按 git worktree 启动（每个改动一个实例）；把 Chrome DevTools Protocol 接入 agent runtime，做 DOM 快照/截图/导航的 skill；可观测性栈（日志/指标/trace）对 Codex 暴露，agent 用 LogQL 查日志、PromQL 查指标 → "确保服务启动 <800ms""4 条关键链路无 span 超 2s"这类 prompt 变得可执行。单次 Codex run 常工作 6 小时以上（趁人睡觉时）。

### 2.2 Anthropic《Effective harnesses for long-running agents》

**核心问题**：长程 agent 必须在离散会话中工作，每个新会话从零记忆开始。比喻："像轮班制软件项目，每个新工程师上班时都对上一班毫无记忆。"

**两个典型失败模式**（即使有 compaction 也不够）：
1. **试图一口气做完（one-shot）** → context 用尽时功能半成品且无文档，下一会话只能猜。
2. **过早宣称完成（declare victory）** → 后期 agent 看到有进展就说完事了。

**两部分解决方案**（基于 Claude Agent SDK）：
- **Initializer agent**：首次会话用专门 prompt 建环境——`init.sh` 脚本、`claude-progress.txt` 进度日志、首次 git commit。
- **Coding agent**：后续每次会话只做**增量进展**，并留下结构化交接。原文注：两者只是初始 prompt 不同，系统提示/工具/harness 完全相同。

**四大具体机制**（问题→initializer→coding agent）：
1. **Feature list**：initializer 把 prompt 展开为全面需求文件（claude.ai 克隆例里 **200+ 功能**），初始全标 failing。**用 JSON 不用 Markdown**——模型更不容易乱改 JSON。强词令："删除或修改测试是不可接受的"。
2. **Incremental progress**：一次只做一个 feature；改动后用描述性 commit 提交 git + 写进度文件，留"clean state"（可合并到 main，也能用 git 回滚坏改动）。
3. **Testing（端到端）**：Claude 会做单测/curl 但不检查端到端。给 Puppeteer MCP 后让它像真人用浏览器验证，性能显著提升（但看不到浏览器原生 alert 弹窗等局限）。
4. **Getting up to speed**：每会话 pwd → 读 progress+git log → 读 feature list 选最高优先未完成项 → 跑 init.sh 做基础 e2e。

**未来问题**：单一通用 agent vs 多 agent（专门 testing/QA/cleanup agent）哪个更好？未知。

### 2.3 Anthropic《Harness design for long-running application development》

这是 2.2 的进阶篇（作者 Prithvi Rajasekaran，Anthropic Labs），引入 **GAN 启发的多 agent 架构**。

**两个新问题**：
1. **Context anxiety（上下文焦虑）**：模型接近自以为的 context 上限时会草草收尾。**Context reset（清空重启 + 结构化交接）优于 compaction**，因为 compaction 保留连续性但不给干净状态，焦虑仍在。Sonnet 4.5 焦虑明显，所以 reset 必要；Opus 4.5 几乎自行消除了该行为，于是该 harness 干脆丢掉 reset。（这是个重要洞见：**随模型变强，harness 的某些部件会被模型吸收掉**）
2. **自评不可靠**：agent 评价自己产出时总会自夸。解：**把做事的 agent 和评判的 agent 分开**——调一个独立、挑剔的 evaluator 比让 generator 自批判容易得多。

**三 agent 架构**：
- **Planner**：把 1–4 句 prompt 扩展成完整产品规格（只管高层设计/产品上下文，不接管细节实现——避免错误级联。
- **Generator**：按 sprint 工作，一次一个 feature（React+Vite+FastAPI+SQLite/PostgreSQL），每 sprint 末自评后交 QA。
- **Evaluator**：用 Playwright MCP 像真人一样点击运行中的应用，测 UI/API/数据库，按硬阈值评分，任一项不达标则 sprint 失败并给详细反馈。
- **Sprint contract**：每 sprint 前 generator 与 evaluator 先协商"什么叫 done"，通过文件通信。

**关键实测数据（课程反复引用的那个实验）**：同一 prompt（做 2D 复古游戏编辑器）、同一模型 Opus 4.5：
| Harness | 时长 | 成本 | 结果 |
|---|---|---|---|
| Solo（裸） | 20 分钟 | $9 | 游戏核心功能不能用 |
| Full harness | 6 小时 | $200 | 完全可玩，16 功能/10 sprint |

**这是本主题最有力的实证**：贵 20 倍，但从"不能用"到"能用"是质变；模型没变，变的是 harness。附带设计质量洞见：把"设计是否漂亮"转为可评分准则（design quality / originality / craft / functionality），加权原创性可推动模型跳出"AI slop"。

### 2.4 Awesome Harness Engineering 仓库（GitHub 实测）

**数据（本报告生成时 GitHub API 实测，2026-06-09）**：
- `walkinglabs/awesome-harness-engineering`：**⭐ 3,026 stars**，234 forks，创建于 2026-03-29，最近 push 2026-05-22。
- `walkinglabs/learn-harness-engineering`（课程仓库本体）：**⭐ 8,008 stars**，829 forks，创建于 2026-03-29，持续更新（最近 push 2026-06-08）。

**两个仓同天创建，说明 walkinglabs 是有意地同时做"课程 + 资源集"双轮。3 个月内 8000 star 增长迅猛，说明主题有真实热度。**

**仓库定位与范围**（原文）：“harness engineering 位于 context engineering、evaluation、observability、orchestration、safe autonomy 和软件架构的交叉点”。明确排除"通用 agent 工具"，只收 harness 设计/上下文/评估/运行时控制等可靠性原语。

**收录分区**（反映了主题的知识版图）：Courses & Learning · Foundations · Context/Memory/Working State · Constraints/Guardrails/Safe Autonomy · Specs/Agent Files/Workflow · Evals & Observability · Benchmarks · Runtimes/Harnesses/Reference Implementations。

**值得注意的收录项**（超出课程站本身的广度）：
- LangChain《The Anatomy of an Agent Harness》（Agent=Model+Harness）
- Thoughtworks/Martin Fowler《Harness Engineering》（context engineering + 架构约束 + 垃圾回收）
- HumanLayer《Skill Issue: Harness Engineering for Coding Agents》
- Inngest《Your Agent Needs a Harness, Not a Framework》
- 一篇学术 position paper：《Harness Engineering for Language Agents》（preprints.org）提出 **control–agency–runtime (CAR)** 分解和 **HarnessCard** 结构化报告格式——表明学界已开始把 harness 层当一级研究对象。
- 还收了大量 benchmark（AgentBench/GAIA/Terminal-Bench 2.0/AppWorld 等），强调"用来比较 harness 质量而非仅仅模型质量"。

---

## 3. 核心机制拆解（是什么 + 怎么做 + 为什么）

综合三家原文 + LangChain/Thoughtworks 框架，harness 的关键组成可拆为六个机制。

### 3.1 环境设计（Environment / Sandbox）
- **是什么**：agent 能安全行动、观察结果、推进的隔离环境。
- **怎么做**：沙箱隔离执行（可 allow-list 命令 + 网络隔离）；预装运行时/CLI/浏览器；OpenAI 的"按 git worktree 启动、每改动一实例"；init.sh 脚本。
- **为什么**：模型不能自配置执行环境；"环境定义不足"是 OpenAI 发现的首要减速原因。

### 3.2 状态管理（Context/Memory across sessions）
- **是什么**：跨会话桥接记忆，解决"每次从零开始"。
- **怎么做**：文件系统是最基础原语（LangChain 论点）；git 加版本；progress 文件 + feature list JSON；AGENTS.md 注入；**context reset vs compaction** 两条路线（Anthropic）。
- **为什么**：上下文窗口有限、复杂项目无法在单窗口完成；且存在 context rot（Chroma 研究：上下文越长推理越差）。

### 3.3 验证系统（Verification / full-pipeline tests / self-reflection）
- **是什么**：让 agent 能自检产出是否真正可用，堡住 verification gap。
- **怎么做**：端到端浏览器测试（Puppeteer/Playwright MCP）；Definition of Done（可命令验证的完成条件）；GAN 式 generator/evaluator 分离；self-verify 后才能标 passing。
- **为什么**：agent 天生"感觉对了就说完"，且自评偏宽松。

### 3.4 控制系统（Explicit rules & boundaries）
- **是什么**：显式规则与边界，限制 agent 行为。
- **怎么做**：AGENTS.md/CLAUDE.md；自定义 linter + 结构测试强制架构不变量；错误消息里注入修复指令（"正面的 prompt injection"）；Thoughtworks 的 **guides（前馈）vs sensors（反馈）** 两分法。
- **为什么**：agent 无社会问责、无组织记忆、不知哪个约定是"承重的"；约束=速度不衰减。

### 3.5 可观测性（Observable & debuggable runtime）
- **是什么**：让运行时状态对 agent 可见可调试。
- **怎么做**：日志/指标/trace 对 agent 暴露（LogQL/PromQL）；CDP 接入做 DOM 快照截图；OpenTelemetry GenAI 语义约定；agenttrace/AgentOps 等 trace 审计工具。
- **为什么**："agent 运行时拿不到的东西=不存在"；有了可观测性，"启动<800ms"这类目标变可执行。

### 3.6 防止过早宣称完成（Stop declaring victory early）
- **是什么**：专治"agent 看到有进展就说完事"和 context anxiety。
- **怎么做**：feature list 列出全部未完项（JSON 不易被乱改）；一次只做一个 feature；强词令禁止删改测试；Ralph Loop（钩子拦截退出意图、重注入原 prompt 到新窗口）强制继续；context reset 给干净状态。
- **为什么**：这是 Anthropic/walkinglabs 都点名的最顶级失败模式之一。

---

## 4. 业界实践与产品

- **Codex（OpenAI）**：harness 表现为 repo-as-spec + 自定义 linter/结构测试 + 可观测性栈 + Ralph Loop 式 agent-to-agent review。模型与 Codex harness 紧耦合（apply_patch 工具）。
- **Claude Code / Claude Agent SDK（Anthropic）**：initializer+coding agent、context reset、Skills（渐进式披露）、CLAUDE.md、frontend-design skill。SDK 被称为"通用 agent harness"。
- **LangChain / deepagents**：把 harness engineering 当研发领域，声称仅改 harness 就把 Terminal-Bench 2.0 从 Top 30 提到 Top 5。
- **Cursor / Windsurf / Trae**：课程列为可选实战 agent，主要是用户侧 harness（规则文件 + 验证）。
- **开源 harness/脚手架**：OpenHands（context condensation、prompt injection 缓解）、Inngest（state/retry/trace 当一等基设）、Stripe minions（pre-push hooks、blueprints）、OpenCode（为 Codex 模型加 apply_patch 工具）。标准化努力：AGENTS.md / agent.md / GitHub Spec Kit / 12-Factor Agents。
- **关键实证**：ETH Zurich 研究测了 138 个 agentfile——LLM 生成的反而拖慢性能且贵 20%+，人写的仅提升约 4%。说明 harness 不是"堆指令"，而是精心节制（与 HumanLayer"less is more"、OpenAI"context 是稀缺资源"互证）。

---

## 5. 概念关系网（harness 在 Agent 技术栈里的位置）

**这是本报告最需要"不装有统一答案"的地方——业界定义明确冲突：**

- **harness vs prompt engineering**：共识——prompt 是"问什么"，只是 harness 的一个子集/入口。
- **harness vs context engineering（冲突点）**：
  - **HumanLayer / Thoughtworks 观点**：harness engineering 是 context engineering 的**子集**（"为 coding agent 做用户 harness 是一种特定形式的 context engineering"）。
  - **Rick Hightower 观点（相反）**：context engineering 是 harness engineering 的**子集**（"模型是 CPU，harness 是 OS"；context 只管单次推理看到什么，harness 管跨多次推理的可靠性）。
  - **黄山判断**：两者高度重叠、边界未定。较合理的理解：context engineering 偏"单次推理填什么进窗口"，harness engineering 偏"包裹模型的整个运行时系统（含 context 策略、工具、验证、状态、编排）"。谁包含谁取决于定义者把"context"画多大。
- **harness vs agent framework/orchestration（LangGraph 等）**：Inngest 的标题就是"Your Agent Needs a Harness, Not a Framework"——harness 更偏"state/retry/trace/concurrency 当一等基设"，framework 偏预设的控制流。Many Hands Engineering 则把 harness 看作 framework 之下的"terrain（地形）"层。
- **harness vs MCP/ACP（协议层）**：MCP 是 harness 里接入工具的**协议原语**（一个部件），不是 harness 本身。但多源提醒 MCP 是 prompt injection 向量（工具描述进系统提示）、工具太多会拖慢上下文。

**位置总结**：prompt ⊂ context engineering ∩ harness engineering（二者交集大、子集关系有争）；协议层（MCP/ACP）和编排框架（LangGraph）是 harness 可选用的**部件**；harness 是把这些部件 + 环境 + 验证 + 状态缝合成"闭环工作系统"的上层实践。

---

## 6. walkinglabs 课程评测

**walkinglabs 是谁**：公开信息有限，从 GitHub 看是一个以课程/资源集为主的组织账号（未查到背后具体个人/公司身份，如实标注）。产出两个应用仓：learn-（课程，8k star）+ awesome-（资源集，3k star）。

**课程结构**（从站点 + 404 泄露的 hash map 重建）：理论 lectures + 实战 projects + copy-ready 资源库。lectures 至少覆盖：
- L01 Why Capable Agents Still Fail（能力鸿沟/验证鸿沟/五层防御）
- L02 What a Harness Actually Is（"repo IS the spec"）
- L03 Why the Repository Must Become the System of Record
- L04 Why One Giant Instruction File Fails
- L05 Why Long-Running Tasks Lose Continuity
- L06 Why Initialization Needs Its Own Phase
- L07 Why Agents Overreach and Under-Finish
- L08 Why Feature Lists Are Harness Primitives
- L09 Why Agents Declare Victory Too Early
- L10 Why End-to-End Testing Changes Results（以及更多）
projects 包括 Project 01 Baseline vs Minimal Harness 直到 Complete Harness（Capstone）；资源库提供 minimal harness pack（AGENTS.md / feature_list.json / claude-progress.md 模板）和生产级 harness skill。有中/英/阿拉伯等多语言版。

**质量判断**（黄山译读 L01 后）：
- **优点**：理论框架清晰且可教学——把三家原文的零散论点提炼为"五层防御 + 诊断循环 + Definition of Done"体系；比喻贴切；每课带 code/checklist/练习。是目前中文世界少见的系统化 harness 教程。
- **独到之处**：把“失败时先查 harness 不是换模型”提炼为口号；把 failure 归因到五层之一。
- **局限**：本质是三家原文的**优秀二次提炼/教学化**，原创技术贡献有限；部分数据（如30 分钟任务失败率陡增、~60% context 效率提升）未标明独立出处，宜当课程例证而非硬指标。
- **社区反响**：8k star/3 个月；dev.to/各语言博客有转述提炼；上过 HN。

---

## 7. 社区讨论与舂点

- **HN**：OpenAI 原文上过首页。主要质疑：3.5 PR/人/天的吞吐是否真等于"软件变好"？最小化门禁/允许 flake 是否在低吞吐环境下不负责任。learn- 仓也上过 HN。
- **博客圈**：Addy Osmani、Louis Bouchard、Rick Hightower、nyosegawa、Birgitta Böckeler（Thoughtworks）都写了专文；多人把 Ralph Loop / context rot / “model is CPU, harness is OS” 作为核心意象。
- **X/YouTube**：Viv（Vtrivedy10）被多源引为术语提出者；有"Context vs Harness vs Software Engineering"播客、"对抗式开发 harness"视频。
- **批评/张力**：ETH Zurich 研究被部分人拿来证明"CLAUDE.md 无用"；Medium《The Harness Gap》提出"2025 AI 代码产出 +59% 但团队交付 -7%"的反思。

---

## 8. 趋势判断与洞见（黄山）

1. **会成为核心范式，但是“过渡期范式”**。harness 本质是在补模型的不足（状态、验证、长程连贯性）。LangChain 明言：随模型变强，harness 的一部分会被模型吸收（Opus 4.5 自行消除 context anxiety 就是铁证）。但像 prompt engineering 一样，总会有下一层需要工程化的东西。

2. **底层逻辑：把资深工程师的隐性经验外部化**。Thoughtworks 说得最透：人类工程师自带“隐式 harness”（社会问责、组织记忆、对复杂度的厌恶）；harness engineering 就是把这些显式化、可机械执行化。

3. **对开发者意味着职能迁移**：从“写代码”转为“设计环境、指定意图、建反馈循环”（OpenAI 原话）。纪律从代码转移到脚手架。需要新技能：写 Definition of Done、设计可验证套件、维护 AGENTS.md、诊断失败归因。

4. **会不会与 context engineering / agent framework 收敛为同一件事？**部分收敛，但不会完全合一。目前连术语定义都未统一（context 与 harness 谁包含谁有争）。黄山倾向：harness 是更大的“运行时系统”概念，context engineering 是其中的“工作记忆管理”子领域；framework（LangGraph）是 harness 可选的编排实现。

5. **未来 1–2 年走势预测**：
   - **harness 模板化/平台化**（Thoughtworks 预言）：企业会出现绑定技术栈的“harness templates”。
   - **harness 质量度量工具**出现（类似 code coverage / mutation testing 之于测试）。
   - **多 agent 并行 + trace 自愈合**（LangChain/Addy 点名的 open problem）：agent 分析自己的 trace 发现并修复 harness 级失败；just-in-time 动态组装工具/context。
   - **benchmark 从比模型转为比 harness**（Terminal-Bench 2.0 已证：同模型换 harness 能从 #33 到 #5）。

**一句话总结**：harness engineering 是“后提示词时代”把 agentic coding 从“可玩”推向“可靠”的工程实践；它尚未收敛为统一标准，但核心理念（Agent=Model+Harness、失败先查 harness、repo 即真相、验证闭环、防止过早宣胜）已被三大实验室独立验证，可信度高。

---

## 附：主要来源（均已原文/实测交叉验证）

**一手**：OpenAI《Harness engineering: leveraging Codex》· Anthropic《Effective harnesses for long-running agents》· Anthropic《Harness design for long-running application development》· walkinglabs Learn Harness Engineering 站 + L01 · awesome-harness-engineering 仓（GitHub API 实测 star 数）。

**二手权威**：LangChain《The Anatomy of an Agent Harness》· Thoughtworks/Martin Fowler《Harness engineering for coding agent users》· HumanLayer《Skill Issue》· Inngest《Harness, Not a Framework》· Rick Hightower《Model is CPU, Harness is OS》· nyosegawa best-practices · Addy Osmani《Agent Harness Engineering》· ETH Zurich agentfile 研究。

**存疑/未謁实**：walkinglabs 背后主体身份；“harness engineering”术语首创归属（Viv vs Mitchell Hashimoto 说法不一）；课程里部分量化数据（~60% context 效率、>30min 失败率）未标明独立出处。

