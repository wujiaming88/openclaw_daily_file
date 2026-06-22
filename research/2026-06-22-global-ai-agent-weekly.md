# 全球 AI Agent 赛道周报 · 第 3 期（2026-06-15 ~ 2026-06-21）

> **覆盖区间**：2026-06-15（周一）00:00 ~ 2026-06-21（周日）24:00（上海时区）
> **覆盖范围**：4 大板块 28 个 Agent 对象（编码 Agent/CLI · 通用框架 · 垂直企业 · 浏览器操作+中国）
> **时间窗声明**：仅收录区间内真实公开动态；区间外信息标注"（背景，非本周）"；无动态对象明确标注，不以旧闻凑数、不编造。
> **质量门控**：覆盖 28/28（100%）· 原文抽查 5/5 通过 · 三维度（学术/工程/商业化）到位 · 关键数据均附源 URL+日期、重要数据交叉验证。

---

## 📌 本周一句话

> 编码 Agent 赛道在资本（SpaceX 600 亿收 Cursor、Cognition 260 亿估值）、经济学（Anthropic 暂停 Agent SDK 计费拆分）、技术路线（智谱 ZCode 自研内核、Anthropic 自托管沙箱）三条线同时进入"生产级深水区"——竞争焦点从"模型能力"全面转向"模型 × 工具 × 算力 × 数据 × 治理"的全栈较量。

---

## 🔥 本周 TOP 5

### 1. SpaceX 600 亿美元全股票收购 Cursor 母公司 Anysphere ｜ 2026-06-16
SpaceX（xAI 母公司）在 IPO 数日后宣布以 **600 亿美元全股票**收购 Anysphere，当日 SpaceX 市值一度冲至 **2.97 万亿美元**、超越亚马逊成全球第五大公司；交易不动用 IPO 募资，预计 2026 Q3 完成。SpaceX 在招股书中称 Cursor 逾 **100 万开发者**的编码请求与设计决策数据可改进 Grok 模型。PitchBook 分析师认为交易无法缩小 xAI 与 Anthropic/OpenAI 的模型差距，但"获得开发者比赢得模型竞赛更快变现"。
↳ **为什么重要**：前沿模型巨头通过收购直接获得"开发者每日信赖的工具+数据飞轮"，验证"拥有分发入口比赢模型竞赛更快变现"的逻辑，是编码 Agent 赛道资本整合的里程碑。
[The Guardian](https://www.theguardian.com/science/2026/jun/16/spacex-ai-coding-anysphere-cursor-amazon-market-valuation-xai) · [CNBC](https://www.cnbc.com/video/2026/06/16/spacex-to-buy-cursor-ai-parent-company-anysphere-in-60-billion-deal.html)

### 2. Cognition 完成超 10 亿美元融资、估值 260 亿美元 ｜ 2026-06-17
Devin 母公司 Cognition 完成超 **10 亿美元**新一轮融资、估值达 **260 亿美元**（较 9 月翻倍有余），Lux Capital、General Catalyst、8VC 领投，Founders Fund 等参投。最硬的数据：**收入运行率从去年 5 月的 3,700 万美元飙升至 4.92 亿美元**（约 13 倍），客户含 Goldman Sachs、Mercedes-Benz 及美国政府多部门；CEO Scott Wu 称公司 90%+ 内部代码已由 Devin 编写。同期 Devin Desktop 获 NVIDIA 加入多 Agent 研究预览。
↳ **为什么重要**：3,700 万→4.92 亿美元是 2026 年最猛的应用层 Agent 营收曲线之一，估值翻倍验证"AI 软件工程师"品类的资本热度。
[Economic Times / Bloomberg](https://economictimes.indiatimes.com/tech/funding/ai-coding-startup-cognition-raises-1-billion-at-26-billion-value/articleshow/131354428.cms) · [Devin Desktop](https://devin.ai/desktop)

### 3. Anthropic 紧急暂停 Agent SDK 计费拆分 ｜ 2026-06-15
Anthropic 原计划于 6/15 将 Claude Agent SDK、claude -p（headless）、GitHub Actions、经 ACP 认证的第三方 App（Zed/JetBrains 等）用量从 Pro/Max/Team/Enterprise 订阅池剥离、改按标准 API 费率独立计费，以终结"订阅补贴 Agent 用量 **15–30×**"的结构。但 6/15 当天 Anthropic 确认**暂停该变更、维持现状**，称将"重新设计以更好支持用户用订阅构建"。
↳ **为什么重要**：Agent 算力的定价模型尚未稳定——机器速度的 token 消耗与人类速度的订阅定价之间存在结构性矛盾，"all-you-can-eat 订阅能否撑过 Agent 时代"成为全行业共性张力。
[Ars Technica](https://arstechnica.com/ai/2026/06/anthropic-pauses-token-based-billing-for-its-claude-agent-sdk/) · [Digital Applied](https://www.digitalapplied.com/blog/anthropic-claude-credit-overhaul-june-15-2026)

### 4. 智谱 GLM-5.2 + ZCode 3.0 自研 Agent 内核（MIT 开源）｜ 2026-06-13 落地 6/16-20
智谱推出 **GLM-5.2**（总参数约 753B、MoE/DSA、1M 上下文、MIT 开源上线 Hugging Face）与 **ZCode 3.0**——后者全面切换**自研 ZCode Agent 内核**，放弃此前套用 Claude Code/Cline 的第三方实现，宣布"后续不再内置其他 Agent 适配"。官方 benchmark：**SWE-Bench Pro 62.1**（前代 58.4）、Terminal Bench 2.1 81.0、AIME 2026 99.2。公告明确影射 Anthropic 收紧访问："前沿智能不应被少数规则随时收回"。
↳ **为什么重要**：国产编码 Agent 从"套壳 Claude Code"走向"模型+Agent 垂直整合"（iOS 式闭环），并把"开源"从技术选择抬升为企业级"业务连续性/自主可控"叙事。
[DataLearner](https://www.datalearner.com/ai-models/pretrained-models/glm-5-2) · [Hugging Face](https://huggingface.co/zai-org/GLM-5.2)

### 5. Harvey 突破 3 亿美元 ARR + 开源法律 Agent 基准 LAB ｜ 2026-06-16
法律 AI Harvey 披露已突破 **3 亿美元 ARR**（去年 8 月还是 1 亿、3 倍增长）、**960 名员工、2,000 家客户、月处理约 13 万亿 tokens**，累计融资 12 亿美元、估值 110 亿美元。同期开源 **Legal Agent Benchmark（LAB）**——首个衡量 AI Agent 真实法律任务的开源基准，覆盖 **1,200+ 任务、24 个执业领域、75,000+ 评分标准**。CEO 抛出"我花了 10 亿美元买 token，ROI 在哪？"的"Token 清算"行业之问。
↳ **为什么重要**：垂直 Agent 商业化标杆，开源 LAB 是从"应用层"向"研究机构"卡位的战略动作，"Token 清算"点出长程 Agent 工作流的核心矛盾——谁能证明每 token 的 ROI 谁就赢。
[Sourcery](https://www.sourcery.vc/p/breaking-harvey-co-founder-and-head) · [Harvey LAB](https://www.harvey.ai/blog/introducing-harveys-legal-agent-benchmark)

---

## 🧭 三大维度趋势

### 学术研究
- **Agent 自进化进入主流框架与产品**：Google ADK 2.3.0 引入 **GEPARootAgentOptimizer**（GEPA 类自动优化器），Hermes 的 hermes-agent-self-evolution 用 **DSPy + GEPA（ICLR 2026 Oral）** 自动进化 skills/prompt——无需 GPU、单次约 $2-10。prompt/agent 自动优化从研究走向工程一等公民。
- **垂直领域专属基准成卡位工具**：Harvey 开源 **LAB**（1,200+ 任务/24 领域/75,000+ 评分标准），方法论借鉴 SWE-bench/Terminal Bench，把竞争对手都拉进自己的评测标准。国产模型（GLM-5.2 SWE-Bench Pro 62.1、Kimi K2.7）则普遍存在"自报基准、缺独立第三方复现"的短板（K2.6 曾有 15-20pp 宣传-实测差距）。

### Agent 工程
- **企业级安全治理成框架原语**：OpenAI Agents SDK 0.17.6 新增**工具输入预审批护栏**、Google ADK 2.3.0 全面 **mTLS + E2B 远程沙箱**、Anthropic **自托管沙箱**公开测试、Codex CLI **Noise 端到端加密 relay**——"把执行环境还给客户、把智能环留在云端"成为企业生产范式。
- **自研 Agent 内核 vs 开放生态两条路线分化**：智谱 ZCode 3.0 走"模型+自研内核闭环"（弃 Claude Code 适配），Kimi/OpenCode 走"专用模型+兼容 Claude Code/Cline 开放生态"；LangGraph 1.2.6 深化 v3 streaming + RemoteGraph 做生产级分布式运行时。

### 商业化与落地
- **应用层 Agent 集体跨过"基础设施门槛"**：Cognition 收入运行率 3,700 万→4.92 亿美元、Harvey ARR 3 亿、Replit ~1.5 亿、Sierra >1.5 亿同步进入陡峭营收曲线，估值随之翻倍。OpenAI 拿下三星全球级部署（Codex 全球周活 >500 万）。
- **地缘政治成为 Agent 资产硬约束**：Meta 对 Manus 的 20 亿美元收购在中国发改委监管下被强制拆解、原投资人计划 20 亿原价回购，标志中美 AI 资产跨境流动全面政治化。

---

## 📚 赛道深度正文

> 全量深度笔记，每个有动态对象 ≥200 字含具体数据与原文链接；已进 TOP5 的对象正文同样完整保留。

### 💻 板块一：编码 Agent / CLI

### Claude Code（Anthropic）★

- **本周动态**：本周Claude Code最重磅动作是正式推出 **Artifacts（制品）功能**（面向Claude Team / Enterprise订阅用户）。该功能把一次Claude Code会话的工作产物转化为"实时、可交互、可分享"的自定义HTML网页——可以是仪表盘、应用设计稿或内部小工具，团队成员能在同一URL上实时看到Claude自主或在用户指导下工作时页面的更新。技术上它是**无状态画布（stateless canvas）**：官方文档直言"An artifact is a capture of work, not an application（制品是工作的快照，而非应用）"。每个Artifact是单个自包含HTML页面，渲染上限16 MiB，被严格CSP包裹——**屏蔽所有外部网络请求**（不能加载外部脚本/字体/样式，fetch/XHR/WebSocket全禁），所有CSS/JS必须内联，图片须用data URI嵌入。默认私有、仅同组织认证成员可见、不能公开到互联网，管理员有org级开关、RBAC与留存策略+合规API。Claude Code创建者Boris Cherny在X发文称已用它做"代码可视化讲解、系统图、动画预览、数据分析与团队共享仪表盘"，称其为"game changer"。同期GitHub release高频迭代（6/15~6/20几乎每日发版）：6/15加入`Tool(param:value)`权限规则语法（如`Agent(model:opus)`屏蔽Opus子Agent）、嵌套`.claude/skills`目录加载、auto模式下子Agent spawn现在先经分类器评估再启动（堵住越权漏洞）；6/17加入`/config key=value`即时设置语法、Bun运行时升级至1.4、子Agent面板优化（空闲30s自动隐藏）；6/19**强化auto模式安全**：破坏性git命令（`git reset --hard`、`git clean -fd`、`git stash drop`）在用户未要求丢弃本地改动时被拦截，`terraform/pulumi/cdk destroy`非指定stack时被阻止。技术路线判断：Anthropic在"安全自治（auto mode护栏）+ 企业协作（Artifacts）"两条线同时加码，刻意与OpenAI的"持久后端"路线区隔，主打**临时、高安全的技术工作流**，不碰后端持久化。
- **关键数据**：
  - Artifacts渲染上限 16 MiB｜单HTML自包含、CSP禁外部请求 — 来源 https://venturebeat.com/data/anthropics-claude-code-artifacts-update-brings-live-shared-dashboards-and-interactive-workspaces-to-enterprises （2026-06-19报道）；官方文档 https://code.claude.com/docs/en/artifacts
  - GitHub release迭代日期：6/15、6/16、6/17、6/19、6/20均有发版 — 来源 https://github.com/anthropics/claude-code/releases （2026-06-22读取）
  - Bun运行时升级至1.4（6/17）— 同上release页
- **原文链接**：
  - https://github.com/anthropics/claude-code/releases
  - https://venturebeat.com/data/anthropics-claude-code-artifacts-update-brings-live-shared-dashboards-and-interactive-workspaces-to-enterprises
  - https://claude.com/blog/artifacts-in-claude-code （官方博客）
- **影响判断**：Artifacts把CLI编码Agent从"产代码"升级为"产可分享的实时工作界面"，直击"工程师向非技术stakeholder汇报"的摩擦点，是Agent产品向"协作层/工作面"上探的标志。与OpenAI Codex的"Sites"功能形成两周内的针锋相对，说明编码Agent竞争焦点正从模型能力转向"企业工作面争夺战"。auto模式破坏性命令护栏的持续加码，则是自治Agent走向生产环境的必要信号。

---

### OpenAI Codex / Codex CLI ★

- **本周动态**：本周Codex三条线（app/mobile/CLI）齐进。**6/18 Codex app 26.616** 推出 **Record & Replay**（macOS）——把一次"演示过的工作流"录制成可复用skill（初期不含EEA/英国/瑞士，需开启Computer Use），并新增自动化运行历史的批量操作、以及**本地与远程主机间的thread handoff**（可把一个会话迁移到连接主机上的同名项目继续，Codex能代为协调交接）。**6/16** Codex app能力扩展至**EEA/英国/瑞士**：Computer Use（macOS/Windows）、Codex Chrome扩展、Memories（这些地区默认关闭）、Chronicle（ChatGPT Pro的macOS研究预览，从近期屏幕上下文构建记忆）。**6/15** ChatGPT iOS 1.2026.160：加入工作区文件浏览器、目录选择器、diff展开/折叠、MCP审批选项、消息中LaTeX渲染。**CLI侧（GitHub openai/codex）**：6/18发布**0.141.0**（稳定），核心是**远程执行器改用经认证、端到端加密的Noise relay通道**（#26242/#26245），跨平台远程执行保留执行器原生工作目录与shell，选定执行器插件可按线程激活其stdio MCP服务器，MCP默认工具超时提升至300秒（#28234）；6/19-6/21持续发0.142.0-alpha系列（alpha.2~alpha.10）。背景（非本周但相关）：6/2上线的 **Sites** 功能——OpenAI托管的网站/仪表盘/内部工具/Web应用，支持D1关系数据库与R2对象存储等持久后端，走"PaaS"路线，与Anthropic无状态Artifacts形成对照。技术路线判断：Codex正全力押注"**多端协同+远程执行+企业治理**"——Noise加密relay、跨主机handoff、access token、Bedrock接入，均指向"在企业基础设施里大规模、可审计地跑Agent"。
- **关键数据**：
  - Codex app 26.616（2026-06-18，Record & Replay）｜26.609（6/11）｜26.608（6/9）— 来源 https://developers.openai.com/codex/changelog
  - CLI 0.141.0 稳定版（2026-06-18），含Noise relay #26242/#26245、MCP工具超时→300s #28234；0.142.0-alpha.2~alpha.10（6/18-6/21预发布）— 来源 https://github.com/openai/codex/releases
  - ChatGPT iOS 1.2026.160（2026-06-15）— 同changelog
  - 模型背景：GPT-5.3-Codex与GPT-5.2已于5/26弃用，现役GPT-5.5/5.4/5.4 mini — changelog
- **原文链接**：
  - https://developers.openai.com/codex/changelog
  - https://github.com/openai/codex/releases
- **影响判断**：Record & Replay把"人类演示→可复用Agent技能"的录制范式带入主流编码Agent，是降低Agent定制门槛的关键一步；Noise端到端加密relay + 跨主机handoff则是Codex在"企业级远程Agent执行"上的硬基建投入。Codex的"Migrate to Codex"导入Claude Code/Cowork配置（6/9）+ Sites的PaaS化，显示OpenAI意图直接抢夺Anthropic开发者与企业工作面，两家进入贴身肉搏的产品节奏。

---

### OpenClaw（Agent OS）★

- **本周动态**：OpenClaw本周保持其标志性的"高频滚动发布"节奏，**6/21**发出新的pre-release（覆盖`v2026.6.9-beta.1..HEAD`共109个合并PR）。本期非单一爆点功能，而是围绕"**Agent运行时可靠性、安全边界、渠道交付**"的系统性硬化。要点：①**Agent回合与会话状态更可靠**——保留待处理的子Agent完成通知、保持聊天历史transcript非空、维持media index对齐、重启休眠的follow-up drain、一致解析compaction模型别名（#94349/#92383/#94257/#95039/#90885）；②**Codex与审批流增强**——Codex app-server SecretRefs、线程上下文、有界回合文本、路由审批上下文、类型化SDK审批/会话helper（#94324/#94756等），显示OpenClaw作为"Agent OS"深度集成Codex作为后端执行器；③**渠道交付更丰富**——Telegram/Discord/Slack保留更丰富的进度/推理/线程输出，处理结构化发送错误，支持Slack快捷方式（#94891/#94856/#78536）；④**安全与网络边界**——SSH隧道preflight限定loopback、移除device-backed节点配对、doctor暴露易失SQLite状态、拒绝不安全的chat/tool/package/response长度（#94607/#95066/#95078）；⑤**新CLI/状态工作流**——从chat重命名会话(`/name`)、显式compact会话、显示会话时长、消息发送/轮询的dry-run预览（#88581/#88988/#94684）；⑥**cron安全**——递归错误backoff遵守配置下限、隐式隔离投递要求显式目标、默认cron runMode改为"due"而非"force"（#94453）。背景：最新stable为v2026.6.1（6/3 tagged）。技术路线判断：OpenClaw不追单点功能噱头，而是把"自治Agent长期稳定运行+企业级安全治理+多渠道一致交付"做成护城河——这与业界（微软把Agent治理视为Zero Trust问题、Databricks强调治理与评估）的方向一致。
- **关键数据**：
  - 本期pre-release（2026-06-21）覆盖109个合并PR（v2026.6.9-beta.1..HEAD）— 来源 https://github.com/openclaw/openclaw/releases （2026-06-22读取）
  - 最新stable v2026.6.1（2026-06-03 tagged）— 来源 https://fast.io/resources/openclaw-changelog-guide/ （2周前，需交叉验证）
  - cron默认runMode：force→due（#94453）— release页
- **原文链接**：
  - https://github.com/openclaw/openclaw/releases
  - https://releasebot.io/updates/openclaw （二手聚合）
- **影响判断**：OpenClaw代表"Agent OS"路线——不是单个编码Agent，而是承载多Agent、多渠道、多模型的运行时底座。本周对Codex后端的深度集成（SecretRefs/审批上下文）说明它定位为"编排层"，把Claude Code/Codex等当作可插拔执行器。其对会话状态完整性、安全边界、cron安全的持续投入，是"让Agent能7×24无人值守可靠运行"的关键工程，这正是自治Agent从demo走向生产的胜负手。

---

### Hermes Agent（Nous Research，自进化）★

- **本周动态**：本周Hermes有两条重磅in-window动态。**(1) 6/19发布 Hermes Agent v0.17.0（v2026.6.19）"The Reach Release"**：自v0.16.0以来约**1,475 commits、~800 merged PRs、1,693文件变更、235,390行新增、245位社区贡献者、300+ issue关闭**。核心亮点：①新增**iMessage通道**（基于Photon托管线路池，`hermes photon login`即用，无需Mac中继/BlueBubbles桥，定位为BlueBubbles继任者）；②加入**Raft agent网络**（作为外部Agent通过wake-channel桥接，隐私契约设计——wake载荷仅含元数据不含消息体）；③**后台/异步子Agent**——`delegate_task(background=true)`派发后台子Agent并立即返回handle，完成时结果作为新turn重新进入对话；④**image_generate支持图生图编辑**（image-to-image，不止从零生成）；⑤**Automation Blueprints**——无需学cron语法，按名选自动化、Hermes追问所需参数，一份蓝图在dashboard/CLI/messenger多端原生渲染；⑥**接入Cursor的Composer模型**——`grok-composer-2.5-fast`进入xAI OAuth模型选择器（上下文窗口校准至完整200k），用xAI Grok订阅即可驱动Composer；⑦**memory工具重大升级**——新增operations数组，对最终字符预算原子化应用add/replace/remove批量编辑；⑧dashboard全功能profile构建器+安全登录、Skills Hub浏览器重构（含安全扫描）、curator成本优化（默认不再每次跑LLM consolidation）。**(2) 自进化仓库 hermes-agent-self-evolution（约6/17更新）**：用 **DSPy + GEPA（Genetic-Pareto Prompt Evolution，ICLR 2026 Oral，MIT许可）** 自动进化优化Hermes的skills/工具描述/系统prompt/代码——**无需GPU训练，全靠API调用，单次优化约$2-10**。GEPA读取执行trace理解"为何失败"而非"是否失败"，再提出定向改进，产出PR交人工审核。Phase 1（SKILL.md进化）已实现，Phase 2-5规划中。约束门：全测试套件100%通过、Skills≤15KB、工具描述≤500字符、语义不漂移、所有变更必经人工PR审核绝不直接commit。eval数据可用合成数据或真实session history（含Claude Code、Copilot、Hermes）。
- **关键数据**：
  - v0.17.0：~1,475 commits / ~800 PRs / 1,693文件 / 235,390插入 / 50,730删除 / 245贡献者 / 300+ issue（2026-06-19）— 来源 https://github.com/nousresearch/hermes-agent/releases
  - v0.16.0：874 commits / 542 PRs / 399 issue（含2 P0/62 P1/16安全）/ 170贡献者（2026-06-05，桌面应用首发，背景）— 同上
  - grok-composer-2.5-fast上下文窗口200k — release页
  - 自进化：DSPy+GEPA，单次优化$2-10，无GPU；约束Skills≤15KB/工具描述≤500字符 — 来源 https://github.com/NousResearch/hermes-agent-self-evolution
- **原文链接**：
  - https://github.com/nousresearch/hermes-agent/releases
  - https://github.com/NousResearch/hermes-agent-self-evolution
  - https://www.turingpost.com/p/hermes （二手对比）
- **影响判断**：Hermes是"自进化Agent"路线的最激进实践——把GEPA这类前沿prompt进化研究（ICLR 2026 Oral）直接产品化为"无需GPU、$2-10一次"的技能自我优化管道，且坚持"人工PR审核、绝不直接commit"的安全护栏，是"自改进+可控"平衡的范本。v0.17.0单版本1400+ commits的迭代密度+开源+多渠道触达，显示Nous在用极致开源速度与"自托管/数据隐私"叙事对抗闭源大厂。自进化能从Claude Code/Copilot的真实session history学习，预示跨Agent经验迁移将成新战场。

---

### Cursor（Anysphere）

- **本周动态**：本周Cursor有"资本+产品"双爆点。**(1) 6/16 SpaceX以600亿美元全股票收购Cursor母公司Anysphere**——本周编码Agent赛道最大事件。SpaceX（xAI母公司）IPO数日后宣布该协议，当日SpaceX市值一度冲至2.97万亿美元、超越亚马逊成全球第五大公司。交易以股票支付、不动用IPO募资，预计2026 Q3完成。背景：SpaceX 4月已锁定"600亿收购或100亿合作"二选一期权。分析师观点分化：PitchBook的Harrison Rolfes认为交易无法"缩小xAI与Anthropic/OpenAI模型差距"，但获得Cursor逾100万开发者"是比赢得模型竞赛更快的企业AI营收路径"；SpaceX在招股书称Cursor开发者数据（编码请求、设计决策）可改进Grok。Anysphere背后有a16z、Thrive、Nvidia、Google。**(2) 产品侧6/18多项更新**：①**Automations增强**——`/automate`技能（自然语言即配置触发器/指令/工具）、Slack emoji触发、5个新GitHub触发器、自动化computer use工具（云Agent自产demo）；②**云环境配置+云子Agent**——`/in-cloud`独立VM起云子Agent、`/babysit`远程迭代准备PR、本地与云会话handoff；③**Bugbot提速**——现由Composer 2.5驱动，平均审查从~5分钟降至~90秒、便宜~22%、每次多发现10% bug（0.62 vs 0.56）；④**Cursor SDK**——自定义工具、auto-review、JSONL store、无限嵌套子Agent。背景（非本周）：6/16 keynote传出Origin代码平台、>1.5万亿参数自研模型、Cursor Mobile（二手abit.ee/YouTube，未取到一手，标争议）。技术路线判断：Cursor正从"AI编辑器"转向"agentic云端编排平台"，加上SpaceX算力后盾补齐最大短板。
- **关键数据**：
  - 收购额600亿美元全股票，2026 Q3完成；SpaceX市值峰值2.97万亿超亚马逊2.65万亿 — 来源 https://www.theguardian.com/science/2026/jun/16/spacex-ai-coding-anysphere-cursor-amazon-market-valuation-xai （2026-06-16）；CNBC交叉验证 https://www.cnbc.com/video/2026/06/16/spacex-to-buy-cursor-ai-parent-company-anysphere-in-60-billion-deal.html
  - Cursor用户>100万开发者 — Guardian同文
  - Bugbot：~90s（原~5min）、便宜~22%、每次0.62 bug（原0.56），Composer 2.5驱动 — 来源 https://cursor.com/changelog （2026-06-18）
  - Origin/1.5T模型/Cursor Mobile（6/16 keynote，二手未一手验证，标争议）
- **原文链接**：
  - https://cursor.com/changelog
  - https://www.theguardian.com/science/2026/jun/16/spacex-ai-coding-anysphere-cursor-amazon-market-valuation-xai
- **影响判断**：SpaceX收购Cursor是编码Agent赛道资本整合里程碑——前沿模型巨头（xAI/Grok）通过收购直接获得"开发者每日信赖的工具+数据飞轮"，验证"拥有分发入口比赢模型竞赛更快变现"。叠加Cursor向云Agent编排转型，2026下半年编码Agent竞争将是"模型×工具×算力×数据"的全栈较量。

---

### Cognition（Devin / Windsurf）

- **本周动态**：本周Cognition主打"安全审查"与"产品整合"。**(1) 6/18发布 Security in Devin Review**：在Devin Review中为每个PR增加安全审查，声称能捕捉模式匹配扫描器遗漏的**auth bypass与逻辑缺陷**。其差异化在于"理解整个代码库"：每个发现按严重程度分类、标CWE ID、基于真实代码库，且不止报警还直接写fix并开为merge-ready PR。能捕获三类模式匹配扫描器遗漏的漏洞：破损授权（如密码修改端点因缺失token静默创建guest session导致账户接管）、业务逻辑缺陷（退款超额、折扣可重复使用）、链式发现（单独低危组合成关键路径）。**(2) Windsurf正式更名为 Devin Desktop**（公告6/2，本周持续迭代）：本周发版 v3.2.19/v3.2.23（6/18）、v3.2.16（6/16，新增**Devin插件系统**扩展Devin Local，企业preview/opt-in）。背景：6/12起Devin移除Claude Fable 5访问（因Anthropic公告及美国政府指令），保留Opus 4.8与GPT-5.5。技术路线判断：Cognition将Windsurf完全收编进Devin品牌（一个IDE+Agent Command Center管理本地/云Agent舰队），并把"代码审查（尤其安全）"作为核心差异化点，走"Agent不只写代码，还验证代码"的路线。
- **关键数据**：
  - Devin Desktop最新 v3.2.19（2026-06-18）；v3.2.16（6/16，Devin插件系统）；累计122个发布 — 来源 https://www.havoptic.com/tools/windsurf （2026-06-22读取）
  - Security in Devin Review发布 2026-06-18 — 来源 https://devin.ai/blog/security-in-devin-review
  - Devin移除Claude Fable 5访问（2026-06-12起）— 来源 https://devin.ai/blog/
- **原文链接**：
  - https://devin.ai/blog/security-in-devin-review
  - https://devin.ai/blog/
  - https://www.havoptic.com/tools/windsurf （Devin Desktop changelog）
- **影响判断**：在AI生代码扩大攻击面的背景下，"安全审查内建PR流程"是编码Agent从"产代码"走向"保产质"的关键一步。Cognition把Windsurf收编进Devin、并以全仓理解的深度审查与GitHub扫描器差异化，是其在"企业级代码质量/安全"细分赛道的明确押注。Fable 5下架事件则揭示模型供应受监管/地缘政治影响的新变量。

---

### OpenCode（SST / Anomaly）

- **本周动态**：OpenCode（主维护于github.com/sst/opencode，已迁至anomalyco/opencode组织）本周保持高频immutable release（6/13、14、17、21均有发版），主调为**多模型接入+MCP健壮性+桌面端打磨**。要点：①**6/21**：尊重配置的agent step limits（到极限强制输出最终文本而非中途失败）、为GLM-5.2增加high/max thinking变体、修复Devstral模型检测、停止包裹follow-up消息以保prompt缓存有效；②**6/17**：OpenAI兼容provider接受之前验证失败的MCP工具schema、Cloudflare AI Gateway修复、会话timeline加载提速；③**6/10**（较大版）：fff-backed文件搜索提速、Cohere North/MiniMax M3 thinking/Claude Fable reasoning支持、WSL-backed桌面支持、会话从context-overflow恢复。背景数据：二手源称OpenCode约**160,000 GitHub Stars、7.5M月活开发者**（需一手核实）。技术路线判断：OpenCode走"终端原生、模型中立、MCP优先"的开源路线，不绑定单一模型供应商，本周大量MCP兼容性修复体现其"做好Agent与工具生态连接层"的定位。
- **关键数据**：
  - 本周release日期：6/13、6/14、6/17、6/21（immutable）— 来源 https://github.com/sst/opencode/releases （2026-06-22读取，重定向至anomalyco/opencode）
  - GLM-5.2 high/max thinking变体（6/21 #32446）— 同release页
  - 约160,000 Stars / 7.5M月活开发者（二手，未一手验证）— https://byteiota.com/opencode-open-source-ai-coding-agent-guide-2026/
- **原文链接**：
  - https://github.com/sst/opencode/releases
- **影响判断**：OpenCode代表编码Agent的"开源中立"阵营——与闭源大厂的纵向整合（Cursor被SpaceX收、Windsurf被Cognition收）形成对比，其价值在于"不锁定任何模型/厨商"。本周密集的MCP兼容性打磨+多新模型（GLM-5.2/Cohere North/MiniMax M3）接入，表明其定位为"模型与工具的中立连接层"，在大厂生态圈地运动中是重要的开源变量。

---

## 🎯 本组洞察

本周编码Agent赛道出现三个拐点信号：**①资本整合加速**——SpaceX 600亿收购Cursor（6/16）是标志性事件，验证"拥有开发者入口+数据飞轮比赢模型竞赛更快变现"，叠加Windsurf被Cognition收编为Devin Desktop，赛道正从"百花齐放"进入"巨头站队"；**②竞争焦点从模型能力转向"企业工作面争夺"**——Anthropic Artifacts（无状态画布）vs OpenAI Sites（PaaS持久后端）的两周内针锋相对，说明"代码之上的协作与分享层"成为新战场；**③安全与自治同步加码**——Claude Code的auto模式破坏性命令拦截、Codex的Noise加密relay、Devin的安全审查、OpenClaw的边界硬化、Hermes的"人工PR审核不直接commit"，集体指向"自治Agent走向生产环境"的必要护栏。最具前瞻信号是Hermes的**自进化管道（GEPA, ICLR 2026 Oral）**——把prompt/技能/代码的进化优化降至"无GPU、$2-10一次"且能从Claude Code/Codex的真实session学习，预示**"跨Agent经验迁移+自动技能进化"将是下一个技术拐点**。一句话：编码Agent正从"更好的代码生成器"进化为"可自改进、可协作、可治理的生产力平台"，2026下半年是全栈能力（模型×工具×算力×数据×安全）的决战。


---

### 🧩 板块二：通用 / 自主 Agent 框架

### LangChain / LangGraph
- 本周动态：LangGraph 在本周窗口内持续高频迭代。GitHub releases 显示 **langgraph 1.2.6 于 2026-06-18 20:58 发布**（PR #8139），核心是两条回归修复：①修复嵌套 subgraph 未能继承父 checkpoint_ns 的回归（该回归始于 1.2.3，PR #8053）；②修复 v3 stream abort 时未取消正在运行的 subgraph（closes #8029, PR #8057），并附带依赖升级（tornado 6.5.5→6.5.6）与 README 结构标准化。配套 **langgraph-cli 0.4.30 于 2026-06-16 19:46 发布**（PR #8101），新功能为"支持兼容的 API version 区间"（feat(cli): support compatible api version ranges, #8023）。从提交流可见 LangGraph 1.2.x 系列正密集围绕 **v3 streaming（SSE/WebSocket 传输）、RemoteGraph 远程图、子Agent命名（lc_agent_name）** 三条主线推进——这恰是 context engineering + 子Agent编排的工程化落地：v3 流式原语、消息与 tool-call 投影（projections）、流重连加固（harden streaming reconnects）都指向把 LangGraph 做成生产级分布式 Agent 运行时。值得注意 CLI 还新增"部署时追踪 ADK/其他库使用"（#7939），显示 LangChain 在生态竞品兼容上的姿态。整体属"稳态高频维护+流式架构深化"，非里程碑式大版本，但工程密度极高。
- 关键数据：langgraph 1.2.6（2026-06-18，来源 https://github.com/langchain-ai/langgraph/releases ）；langgraph-cli 0.4.30（2026-06-16，同源）；本窗口前序版本 1.2.5（2026-06-12）。
- 原文链接：https://github.com/langchain-ai/langgraph/releases
- 影响判断：LangGraph 已从"图编排库"演进为面向生产的分布式 Agent 运行时，v3 流式+RemoteGraph+子Agent命名是关键信号。高频 patch 节奏（一周两版）说明其商业化 LangGraph Platform 对稳定性的强需求，赛道仍由其领跑工程标准。

### Microsoft AutoGen
- 本周动态：**本周无重大公开动态。** 核查 microsoft/autogen GitHub releases，最新稳定版仍为 **python-v0.7.5，发布时间 2025-09-30**（非本窗口；为 2025 年旧版），本周（2026-06-15~21）该仓库无新 release。原因判断：微软已将 AutoGen 的研究路线与 Semantic Kernel 合并为统一的 **Microsoft Agent Framework**，AutoGen 原仓库进入低频维护/收敛状态，新特性开发主战场已迁移。0.7.5 版内容（背景，非本周）主要是 GPT-5 reasoning_effort 参数支持、Anthropic thinking 模式、GraphFlow 环检测修复、RedisMemory 线性记忆等。本周该项目无可计入"本周动态"的实质性更新。
- 关键数据：python-v0.7.5（2025-09-30，来源 https://github.com/microsoft/autogen/releases ）——本窗口外。
- 原文链接：https://github.com/microsoft/autogen/releases
- 影响判断：AutoGen 作为独立框架的迭代已明显停滞，重心转入 Microsoft Agent Framework。对采用方是重要信号：新项目应评估迁移路径，AutoGen 单飞时代趋于结束。

### CrewAI
- 本周动态：CrewAI 本周处于 **v1.14.8 预发布密集迭代期**。GitHub releases 显示 **2026-06-18 当天连发多个 pre-release**：v1.14.8a1（23:42，新增 "single agent action to Flow definitions"、在定义加载期校验 Flow CEL 表达式、新增 Datadog 集成指南与可导入运维仪表盘）、v1.14.8a（17:46，为 each.do 步骤增加可选 if 表达式、修复 JSON crew 问题）、及更早的 v1.14.7 系列收尾。本周技术主线高度聚焦 **"JSON-first crews / FlowDefinition"**——即让用户无需写 Python 代码、纯靠 JSON/声明式定义来定义并运行 Flow（Implement Flow definition run tools without Python code、Add experimental `crewai run --definition` for flows、Introduce JSON first crews）。同时实现 **DMN 模式（决策建模标记法）支持**、script/code block action、crew composite action、表达式驱动的人类反馈（Drive human feedback from the flow definition）。配套 ZIP 部署回退、可插拔后端（memory/knowledge/rag/flow pluggable backends）。这标志 CrewAI 正从"代码框架"向"低代码/声明式 Agent 编排平台"转型，对标企业级可视化编排。
- 关键数据：v1.14.8a1（2026-06-18）、v1.14.8a（2026-06-18），均 pre-release，来源 https://github.com/crewAIInc/crewAI/releases ；上一稳定版 v1.14.7（2026-06-11，同源）。
- 原文链接：https://github.com/crewAIInc/crewAI/releases
- 影响判断：JSON-first/FlowDefinition 是 CrewAI 商业化关键押注——降低使用门槛、瞄准企业低代码市场，与 Dify/n8n 类可视化平台正面竞争。声明式定义+DMN+Datadog 运维仪表盘=明确的企业级落地信号。

### Google ADK (Agent Development Kit)
- 本周动态：ADK 本周在 **2.x 与 1.x 双线发布**。重磅是 **adk-python v2.3.0（tag 标 2026-06-17，release 页 2026-06-18 18:45）**，特性密集：①新增 **GEPARootAgentOptimizer**（GEPA 类自动优化器，指向 prompt/agent 自进化方向）；②**Gemma4 在 Gemini 中的支持**（gemma4: support Gemma4）；③**E2BEnvironment 远程沙箱工作区**（integrations: Add E2BEnvironment for remote sandbox workspaces）——补齐安全代码执行；④AgentRegistry 客户端 mTLS 支持、McpToolset 迁移到 AsyncAuthorizedSession 支持 mTLS（企业安全强化）；⑤Gemini Live 3.1 输入转写差异化处理、Live API 翻译配置；⑥为 Anthropic/OpenAI 模型上报 cached token 计数；⑦实验性 Antigravity SDK agent wrapper。同日另发 **v1.35.1（2026-06-15）**，为 1.x 维护分支修流式与 grounding_metadata 问题（确保 final partial=False 帧总被产出）。注意 2.2.0（背景，非本周，2026-06-04）已将 LlmAgent 默认模型从 gemini-2.5-flash 改为 **gemini-3-flash-preview**——本周 2.3.0 延续该 Gemini 3 时代基线。
- 关键数据：adk-python v2.3.0（tag 2026-06-17 / 发布 2026-06-18，来源 https://github.com/google/adk-python/releases ）；v1.35.1（2026-06-15，同源）；默认模型 gemini-3-flash-preview（自 2.2.0, 2026-06-04，同源）。
- 原文链接：https://github.com/google/adk-python/releases
- 影响判断：ADK 2.3.0 的 GEPA 自优化器 + E2B 远程沙箱 + 全面 mTLS 是三大信号：Google 在押注"Agent自进化+企业安全执行"。1.x/2.x 双线维护说明已有大量生产用户需平滑迁移，ADK 正快速成为 Gemini 3 时代的官方 Agent 标准栈。

### OpenAI Agents SDK / Swarm
- 本周动态：OpenAI Agents SDK（Swarm 的官方后继生产框架）本周发布 **v0.17.6（2026-06-19 06:03）**，两个核心新特性指向"安全/治理"主线：①**add pre-approval tool input guardrails（PR #3487）**——在工具调用前对输入做预审批护栏，是 Agent 工具调用安全控制的关键能力；②**add SDK-only custom data for tool outputs（PR #3486）**——允许工具输出携带仅 SDK 可见的自定义数据（随后 #3657 强制其遵守严格 JSON 兼容契约）。另修复 handoff 工具名空白告警抑制（#3652）。结合本窗口前序版本 v0.17.5（2026-06-11）的 sandbox 错误可重试性暴露、tool-end hook 结果类型化，可见 OpenAI 正密集打磨 **sandbox 沙箱执行 + 工具护栏 + tracing 可观测性** 三大企业级支柱。该 SDK 已支撑 Realtime 语音 Agent、MCP、多种 session 后端（SQLite/Redis/MongoDB），是 OpenAI"把 Agent 能力产品化"的官方载体。本周节奏为稳态高频 patch（每周一版），无大版本但治理能力持续加码。
- 关键数据：v0.17.6（2026-06-19，来源 https://github.com/openai/openai-agents-python/releases ）；v0.17.5（2026-06-11，同源）；GitHub Stars 27,306（2026-06-22，来源 https://api.github.com/repos/openai/openai-agents-python ）。
- 原文链接：https://github.com/openai/openai-agents-python/releases
- 影响判断：pre-approval tool input guardrails 是重要信号——OpenAI 在把"工具调用安全/人审"做成框架原语，呼应企业对 Agent 可控性的核心诉求。Swarm→Agents SDK 的产品化路径已成熟，是 OpenAI 生态锁定的关键一环。

### Dify
- 本周动态：**本周无重大公开 release。** 核查 langgenius/dify GitHub releases 与 tags：最新稳定版为 **v1.14.2（2026-05-19）**，在本窗口（06-15~21）之前；2.0.0-beta.1/beta.2 等 tag 对应 commit 实为 2025-09 的历史提交（非本周）。但需注意：该仓库 **pushed_at = 2026-06-22**，main 分支本周仍高频活跃（持续向 2.0 演进：queue-based GraphEngine、RAG 2、@langgenius/dify-ui 设计系统迁移），只是未在本窗口打正式 release tag。背景（v1.14.x 系列，非本周）主线为：HITL（human-in-the-loop）工作流稳定性、租户隔离安全加固、RAG/知识库可靠性、可观测性（Langfuse v3/Phoenix）、GraphEngine 最小 worker 数提升。本周该项目对外无可计入"本周动态"的正式版本。
- 关键数据：最新稳定版 v1.14.2（2026-05-19，来源 https://github.com/langgenius/dify/releases ）；GitHub Stars 146,075（2026-06-22，来源 https://api.github.com/repos/langgenius/dify ）——本组 Stars 最高；forks 22,974。
- 原文链接：https://github.com/langgenius/dify/releases
- 影响判断：Dify 以 14.6 万 Stars 稳居本组开源人气第一，是低代码 Agent/LLMOps 平台的事实标准之一。本周虽无 release，但 main 分支向 2.0（队列化图引擎+RAG2）演进信号强烈，下一个大版本值得紧盯。

### LlamaIndex Agents
- 本周动态：**本周无重大公开 release。** 核查 run-llama/llama_index：最新 tag 为 **v0.14.22**，其 release commit 日期为 **2026-05-14**（github-actions[bot] "Release 0.14.22 #21667"），在本窗口之前；GitHub releases 页顶部"2026-03-16"等为聚合 changelog 视图，非本周新版。该仓库 pushed_at = 2026-06-20（main 仍活跃，但本周未打新 tag）。背景（v0.14.22 及近期，非本周）llama-index-core 主线：**Multimodal synthesis 多模态合成（#21374）**、IngestionPipeline 多进程缓存写入保留、Memory 对 DocumentBlock 的 token 估算修复、FunctionTool 的 contextvars 传播修复（async 工具调用正确性）。LlamaIndex 的 Agent 能力（Workflows、FunctionAgent、AgentWorkflow）仍以 RAG-centric 编排为差异化定位。本周无可计入"本周动态"的正式版本。
- 关键数据：最新版 v0.14.22（release commit 2026-05-14，来源 https://api.github.com/repos/run-llama/llama_index/commits/77b78b507b975d9caa9e035df76a19ee4f76b0c5 ）；GitHub Stars 50,259（2026-06-22，来源 https://api.github.com/repos/run-llama/llama_index ）。
- 原文链接：https://github.com/run-llama/llama_index/releases
- 影响判断：LlamaIndex 保持 5 万 Stars 的 RAG+Agent 双栖定位，发版节奏放缓（约月度）。多模态合成是其押注方向。本周静默，与高频迭代的 LangGraph/ADK/CrewAI 形成节奏对比。

---


## 本组 GitHub Stars 速览（均为 2026-06-22 实时，来源 api.github.com/repos/*）
| 框架 | Stars | Forks | 本周release | 最新版/日期 |
|---|---|---|---|---|
| Dify | 146,075 | 22,974 | 否 | v1.14.2 (05-19) |
| Microsoft AutoGen | 59,112 | 8,921 | 否 | v0.7.5 (2025-09-30) |
| CrewAI | 54,096 | 7,577 | 是(预发布) | v1.14.8a1 (06-18) |
| LlamaIndex | 50,259 | 7,603 | 否 | v0.14.22 (05-14) |
| LangGraph | 35,375 | 5,935 | 是 | 1.2.6 (06-18) |
| OpenAI Agents SDK | 27,306 | 4,214 | 是 | v0.17.6 (06-19) |
| Google ADK (python) | 20,212 | 3,601 | 是 | v2.3.0 (06-17) |

---

## 本组洞察（Agent框架赛道趋势/拐点信号）
本周窗口呈现清晰的"两极分化"拐点：**官方/大厂栈高频冲刺，社区框架分化。** 三大趋势：①**官方 SDK 阵营（LangGraph 1.2.6、OpenAI Agents SDK 0.17.6、Google ADK 2.3.0）本周全部发版且节奏极密（周更甚至日更）**，主线高度趋同——流式运行时(v3 streaming)、企业安全(mTLS/工具预审批护栏/远程沙箱E2B)、可观测性(OTel)，标志赛道从"能跑通"进入"生产级可控"深水区。②**Agent自进化首次进入主流框架**：ADK 2.3.0 引入 GEPARootAgentOptimizer，把 prompt/agent 自动优化做成一等公民，是方法论层面的拐点信号。③**社区框架走向声明式低代码**：CrewAI 全力押注 JSON-first/FlowDefinition（无需写Python），向 Dify 类可视化平台靠拢；而 AutoGen 已停滞(并入 Microsoft Agent Framework)、Dify/LlamaIndex 本周静默，说明"纯代码框架"红利见顶，下一战场是"声明式编排 + 自进化 + 企业治理"三位一体。Gemini 3 时代(ADK 默认 gemini-3-flash-preview)与 GPT-5 时代基线已落定，框架竞争重心从"接什么模型"转向"如何安全、可观测、可自优化地编排"。

---

### 🏢 板块三：垂直 / 企业 Agent 产品

### Perplexity（Comet / 搜索Agent）
- **本周动态**：本周Perplexity的核心动态是为其自主Agent "Computer" 推出全新记忆系统 **Brain**（约6月18-19日，Decrypt等报道为"3天前"，研究预览阶段）。Brain并非传统意义上记住用户姓名/偏好的记忆，而是**面向"工作"的记忆**：每次Computer完成任务后，Brain把本次任务写入一张"上下文图(context graph)"，记录用了哪些连接器(connectors)、哪些信息源靠谱、用户做了哪些纠正、什么方法失败了；然后**默认在隔夜对该图做合成(synthesize)，更新一份"个人LLM wiki"，在下一个任务启动前预加载进Computer的沙箱**。每条记忆都可回溯到来源session/文件，强调透明与可控。Perplexity自报内部指标：在Computer已处理过的重复任务上，**答案正确率+25%、召回+16%、上下文密集型任务成本-13%**（注：均为内部数字，非第三方benchmark）。Brain目前面向Max($200/月)与Enterprise Max订阅者开放研究预览，记忆入口在侧边栏"Customize"。Decrypt评论指出这本质是把OpenClaw/Hermes等开源Agent早已用markdown+SQLite做的"持久记忆"能力，带进了主流闭源生态——差异在于Brain运行在Perplexity自有基础设施上，用户拿到的是透明度而非数据所有权，且Brain只让Computer在"做过的任务"上更强，并不提升底层模型智能，跨域泛化仍是未解问题。背景：Comet浏览器已于2025年7月上线、2026年3月上iOS，Computer Agent定位"让AI跑数月级而非分钟级任务"。
- **关键数据**：Brain内部指标 正确率+25% / 召回+16% / 成本-13%（来源：Decrypt 2026-06-19 https://decrypt.co/371584/perplexity-ai-agent-brain）；Max定价$200/月（同上）。
- **原文链接**：https://decrypt.co/371584/perplexity-ai-agent-brain ；官方博客 https://www.perplexity.ai/hub/blog/self-improving-memory-for-agents （Cloudflare拦截未能读取全文）
- **影响判断**：Agent记忆从"记用户"转向"记工作"是垂直Agent提效的关键拐点——重复性企业工作流(竞品监控/周报/研究)是最先受益场景。这是Perplexity把Computer从"通用助手"推向"企业级可复利Agent"的明确信号，也把"记忆即护城河"竞争带入闭源大厂阵营。

---

### Harvey（法律AI）
- **本周动态**：本周Harvey动态密集，核心是**"Token清算(Token Reckoning)"叙事 + LAB基准的持续发酵**。6月16日，Harvey联合创始人兼总裁Gabe Pereyra与应用研究负责人Niko Grupen做客"Sourcery with Molly O'Shea"播客（同日CEO Winston Weinberg的token用量数据也被Business Insider报道）。关键披露：①**规模数据**——本月Harvey已突破 **$300M ARR**（去年8月还是$100M，3倍增长）、**960名员工、2,000家客户、累计处理约13万亿(13T) tokens**；累计融资**$1.2B**，最近一轮由Sequoia与GIC联合领投$200M、估值**$11B**(2026年3月)。②**LAB基准**——几周前Harvey开源了 **Legal Agent Benchmark (LAB)**，首个衡量AI Agent真实法律任务表现的开源基准，覆盖**1,200+任务、24个执业领域、75,000+评分标准**，方法论借鉴SWE-bench/Terminal Bench；本周配套发布OpenAI/Anthropic/DeepMind的初始排行榜结果。Harvey把竞争对手都拉进自己的评测标准，逻辑是法律行业**因利益冲突(conflict)被迫多模型**(代理OpenAI就不能把数据发给Anthropic模型)，Harvey价值在于其上的路由与编排层。③**Token经济学**——单条assistant查询可花$20，10万份合同审查可花$2万；Weinberg抛出"我刚花了10亿美元买token，我的ROI在哪？"的行业之问，预言AI消费定价会像律师"6分钟计费"一样走向可审计的按token计费。④**架构演进**——过去6个月Harvey完成从"聊天式产品"到"云端Agent"的重大迁移，自研沙箱基础设施名为**Spectre**，重做按案件的伦理墙(ethical walls)。
- **关键数据**：$300M ARR(本月,从去年8月$100M)、960员工、2000客户、~13T tokens/月(1月为1T)、累计融资$1.2B、估值$11B(2026-03,$200M轮Sequoia+GIC领投)。来源：Sourcery 2026-06-16 https://www.sourcery.vc/p/breaking-harvey-co-founder-and-head ；Business Insider 2026-06 https://www.businessinsider.com/harvey-ceo-ai-token-usage-2026-6 。（注：另有arturmarkus.com称"$5B估值Series E"，与$11B口径冲突，应为过时/失实信息，以$11B多源口径为准。）
- **原文链接**：https://www.sourcery.vc/p/breaking-harvey-co-founder-and-head ；https://www.businessinsider.com/harvey-ceo-ai-token-usage-2026-6 ；LAB开源 https://www.harvey.ai/blog/introducing-harveys-legal-agent-benchmark
- **影响判断**：Harvey是本组商业化最强标的——$300M ARR + 3倍增速 + 2000客户证明法律AI已从"试用"跨入"基础设施"。开源LAB是从"应用层"向"研究机构"卡位的战略动作。"Token清算"叙事点出整个应用层Agent的核心矛盾：长程Agent工作流token成本爆炸，谁能证明每token的ROI谁就赢——垂直玩家天然有优势。这是2026年企业Agent商业化的关键拐点信号。

---

### Sierra（客服Agent）
- **本周动态**：本周Sierra无重大产品/融资发布，主要动态是**思想领导力内容**与企业级合规进展。①6月15日Sierra发布博客《How customer teams became agent builders》，是其"Discovering what's possible with AI for CX"系列的一部分。核心讲述其3月推出的 **Ghostwriter**（"创建并优化其他Agent的Agent"，无需代码/点击即可让support leads、运营经理、QA团队直接塑造客户体验）三个月来的落地效果：从公司对话日志/通话记录/工单/培训文档中自动挖掘"已存在的好Agent"并构建；配套 **Explorer**（优化Agent的Agent，持续分析客户对话，发现掉线点、未处理好的问题、CSAT下滑）。文中引用客户高管(Delan Diaz、Mary Orrell)证言强调"迭代速度"——过去需多团队数天/数周协调的改进现在可实时完成。Sierra把这定位为比单一产品功能更大的转变："最懂客户的人现在能自己塑造体验"。②背景合规：6月10日Sierra获 **FedRAMP High 认证**（面向美国联邦机构云服务的最高标准，刚好在本周窗口前一天）。③背景：4月Sierra收购法国YC背景初创Fragment；5月完成$950M融资、估值$15.8B（数月前一轮$350M/$100亿估值）；客户覆盖财富20强多数企业；2月"年度回顾"称ARR超$150M。
- **关键数据**：ARR>$150M(2026-02口径)；最近融资$950M/估值$15.8B(2026-05)；FedRAMP High认证(2026-06-10)。来源：Sierra博客 https://sierra.ai/blog ；Voiceflow行业分析 https://www.voiceflow.com/blog/sierra-ai 。（本周窗口内无新融资/估值更新。）
- **原文链接**：https://sierra.ai/blog/how-customer-teams-became-software-builders ；https://sierra.ai/blog
- **影响判断**：Sierra本周叙事("Outcomemaxxing"+客户自建Agent)与Harvey的"Token清算"形成有趣呼应——都在把焦点从"消耗/token"转向"结果/ROI"。Ghostwriter让非技术业务人员直接构建Agent，是客服Agent从"交付项目"走向"自助平台"的产品化拐点，对扩张毛利与客户黏性是关键。

---

### Glean（企业知识Agent）
- **本周动态**：本周Glean核心公开动态是6月16日SiliconANGLE/theCUBE在"AWS Marketplace Series"中对Glean合作伙伴副总裁Zubin Irani的专访（偏渠道/营销性质，非硬新闻发布）。要点：①**定位演进**——Glean从企业搜索起家，正转型为"企业级自主Agent与AI业务解决方案的领先开发者"，强调构建可调用广泛组织数据源的"横向(horizontal)"Agent；其agentic开发平台已通过AWS Marketplace分发，深度集成Amazon Bedrock，支持开放模型选择(为不同任务选不同模型)。②**客户ROI案例(有料)**——某医疗客户用Glean处理RFP：过去每月约处理10个RFP、中标率约10%，现在借AI每月可在全国范围找到100个RFP，单个处理时间从40小时压缩到2-3小时。③**产品节奏**——2月Glean已扩展其AI"同事"Glean Assistant能力(实时语音支持、品牌内容生成、主动模板、敏感任务的agent sandbox)；Irani透露"我们每月都出新产品/功能，但更关注'做事(doing)'——拿到正确信息后如何去执行，有很强的新版本即将发布"。
- **关键数据**：医疗客户RFP案例 10→100个/月、处理40h→2-3h、中标率~10%（来源：SiliconANGLE 2026-06-16 https://siliconangle.com/2026/06/16/glean-enterprise-data-ai-value-awsmarketplaceseries/）。本周窗口内无新融资数据公开。
- **原文链接**：https://siliconangle.com/2026/06/16/glean-enterprise-data-ai-value-awsmarketplaceseries/
- **影响判断**：Glean的战略主线清晰——从"找信息(search)"向"做事情(action/agents)"迁移，借AWS Marketplace渠道放量。RFP案例是典型的"可量化ROI"落地证据，正好契合本组"Outcome/ROI"主旋律。但本周缺乏硬发布，更多是渠道造势，需关注Irani暗示的"即将发布的强版本"。

---

### Manus（通用自主Agent）
- **本周动态**：本周Manus是本组最大的**商业/地缘新闻焦点**——Meta对Manus的$20亿收购正在被强制拆解(unwind)。背景：Manus(母公司Butterfly Effect)2025年中将团队迁至新加坡，2025年12月宣布被Meta以$20亿收购；但因中国国家发改委(NDRC)以国家安全/技术出口管制为由，约两个月前(2026年4月27日)否决该交易并下令拆分。本周窗口内的关键进展：①**Meta完成运营分离**——6月11日彭博报道Meta已切断Manus对其内部系统的访问、停止两公司间数据共享，员工不再能用Manus工具做内部项目(TechCrunch 6月13日跟进)。②**原始投资人计划$20亿回购(6月18日,The Information/路透)**——Manus早期中国背景投资人计划以Meta当初支付的$20亿原价把公司买回；早前5月报道联合创始人曾讨论从外部投资人募资约$10亿来赎回，可能铺路"中国合资结构"并最终在香港上市(今年MiniMax、Zhipu等中国AI公司已掀起港股上市潮)。③**投资人退出状态**——加州Benchmark等已拿到收购对价；亚洲背景投资人(腾讯、HSG红杉中国、真格)表示将配合拆分(华尔街日报)。④**工程侧仍在出货**——即便在拆分中，Manus仍持续发布新功能，本期上线了与 **Similarweb** 和 **Shopify** 的集成(connector)。⑤定价(背景)：Free $0(300每日刷新credits,Manus 1.6 Lite)、Pro $20-200/月、Team $20/席/月起。地缘背景：中国同期扩大对AI研究者/高管出境限制，并收紧Moonshot、StepFun、字节等接受美资需政府批准。
- **关键数据**：收购价/回购价$20亿(2025-12宣布;2026-06-18回购计划)；拟募资约$10亿赎回(2026-05);NDRC否决日2026-04-27。来源：TechCrunch 2026-06-13 https://techcrunch.com/2026/06/13/meta-reportedly-moves-to-unwind-2b-manus-deal-after-beijings-demand/ ；Reuters 2026-06-18 https://www.reuters.com/world/asia-pacific/manus-original-investors-plan-buy-back-ai-firm-meta-2-billion-information-2026-06-18/ ；Bloomberg/WSJ转引。
- **原文链接**：https://techcrunch.com/2026/06/13/meta-reportedly-moves-to-unwind-2b-manus-deal-after-beijings-demand/ ；Manus×Shopify连接器 https://manus.im/blog/manus-shopify-connector
- **影响判断**：这是本组最具地缘信号意义的事件——一桩"中国AI明星公司海外退出"的标志性交易在监管夹击下崩解，凸显中美AI资产跨境流动的政治化。对Manus本身：被Meta整合不成、又面临回购，产品连续性与团队稳定性存疑；但其仍持续出货connector说明产品团队在运转。值得持续追踪回购是否落地及港股上市路径。


---

### Devin（Cognition）
- **本周动态**：本周Devin母公司Cognition迎来**重磅融资**且产品持续迭代，是本组商业化第二强标的。①**$10亿融资/$260亿估值(本周内,约6月17日周三宣布)**——Cognition完成超$10亿新一轮融资，估值达**$260亿**，由Lux Capital、General Catalyst、8VC联合领投，Ribbit Capital、Atreides Management、Peter Thiel的Founders Fund等参投；估值较9月上一轮**翻倍有余**。最关键的硬数据：**收入运行率(revenue run rate)从去年5月的$3,700万飙升至$4.92亿**(约13倍增长)，客户包括Goldman Sachs、Mercedes-Benz及美国政府多个部门。累计融资已超$25亿。CEO Scott Wu称公司90%以上内部代码现由Devin自己编写；强调多模型组合策略(自有模型+OpenAI+Anthropic路由)优于单一模型。背景：去年7月Cognition在Google以$24亿拿走Windsurf顶尖人才/授权后，收购了Windsurf剩余资产；融资谈判受SpaceX拟$600亿收购Cursor消息提振。②**产品:Devin Desktop(约6月20日)**——NVIDIA加入Cognition关于Devin Desktop多Agent支持的研究预览。Devin Desktop定位"管理本地+云端Agent舰队的统一界面"，含完整IDE、基于**Agent Client Protocol(ACP)**的跨模型/跨Agent能力、Spaces(跨Agent共享上下文与Git worktree)、Supercomplete、Fast Context(毫秒级定位代码)、免费无限使用SWE-1.6模型；自述1M+用户、4000+企业客户(由Windsurf升级而来,OTA更新继承计划/扩展/设置)。
- **关键数据**：融资>$10亿/估值$260亿(2026-06-17宣布,较9月翻倍)；收入运行率$4.92亿(对比去年5月$3,700万)；累计融资>$25亿；Devin写公司90%+内部代码；1M+用户/4000+企业客户。来源：Economic Times/Bloomberg 2026-06-17 https://economictimes.indiatimes.com/tech/funding/ai-coding-startup-cognition-raises-1-billion-at-26-billion-value/articleshow/131354428.cms ；Devin Desktop官方 https://devin.ai/desktop
- **原文链接**：https://economictimes.indiatimes.com/tech/funding/ai-coding-startup-cognition-raises-1-billion-at-26-billion-value/articleshow/131354428.cms ；https://devin.ai/desktop
- **影响判断**：$3,700万→$4.92亿的运行率增长是2026年最猛的应用层Agent营收曲线之一，估值翻倍验证"AI软件工程师"品类的资本热度(对比SpaceX拟$600亿收Cursor)。Devin Desktop+ACP+NVIDIA研究预览显示Cognition在押注"多Agent编排"作为下一战场。多模型路由策略与Harvey如出一辙——垂直Agent公司正集体走向"模型中立的编排层"。


---

### Replit Agent
- **本周动态**：本周Replit的核心在窗口动态是**6月17日(周三)发布"Replit is now available in Claude"——与Anthropic Claude的深度集成**。要点：①**Design in Claude, Build in Replit**——用户可在 **Claude Design** 用自然语言设计品牌化应用，设计完成后直接发送到Replit继续构建、打磨、发布，全程自然语言、无复制粘贴/上下文切换。②**Delegate Any Task to Replit**——Claude可通过官方Replit Connector把任意通用开发任务交给Replit(搭后端、做功能、迭代现有项目)，二者协同。这是把Replit的"构建/部署执行层"嵌入Claude的"对话/设计入口"，抢占vibe coding工作流的上游。背景:本周前后Replit产品迭代极密集——6月10日发布Agent Customization(Custom Instructions+Skills，让Agent跨项目记住团队规范)、6月10日Databricks集成升级(U2M连接器公开预览)、6月9日Package Firewall(与Socket合作,每天拦截约8000个恶意包)、6月4日Shopify店面构建、6月3日SEO Agent、6月1日Microsoft Fabric集成(含开源SDK Rayfin)、5月21日企业版自助购买。
- **关键数据**：ARR约$150M(约一年内从几百万增长)、用户超4000万、Series D $4亿/估值约$90亿(2026-03,较此前$30亿估值翻三倍)、累计融资约$922M(Tracxn口径)、覆盖85%财富500强。来源：MEXC/TechCrunch转引 https://blog.mexc.com/finance/replit-ipo-2026-valuation-competitors-how-to-invest/ ；Tracxn ；Replit官方博客 https://replit.com/blog/replit-claude (2026-06-17)。（注：ARR $150M与估值$90亿为3月前后数据，本周窗口内无新财务披露。）
- **原文链接**：https://replit.com/blog/replit-claude ；https://replit.com/blog
- **影响判断**：Replit×Claude集成是vibe coding赛道"入口之争"的关键落子——Anthropic把Replit作为其Design入口的默认执行后端，等于双方在用户工作流上互相导流。结合Shopify/Databricks/Microsoft Fabric/Package Firewall等高频集成，Replit的策略很清晰：从"在线IDE"升级为"AI原生应用工厂+企业级安全治理层"，用集成密度和安全合规建护城河。

---


#### 板块洞察（垂直/企业 Agent 商业化拐点）
本周C组释放出垂直/企业Agent商业化的几个清晰拐点信号：

**1. "Token清算"成为行业共识级议题。** Harvey CEO的"我花了10亿美元买token，ROI在哪？"与Sierra的"Outcomemaxxing(不看消耗看结果)"形成共振——2026年中，企业Agent的竞争焦点正从"能力/规模"急速转向"每token的可证明ROI"。垂直玩家因能按任务/案件量化产出，在这场"ROI审计战"中天然占优。

**2. 营收曲线验证"应用层Agent已跨过基础设施门槛"。** Cognition收入运行率$3700万→$4.92亿(13x)、Harvey ARR $300M(3x增速)、Replit ARR ~$150M、Sierra ARR>$150M——多个垂直Agent公司同步进入"陡峭营收曲线"，估值随之翻倍($260亿Cognition、$110亿Harvey、$158亿Sierra)。资本对"垂直Agent=新一类工程/服务产能"的定价已确立。

**3. "多模型中立编排层"成为垂直公司的共同架构选择。** Harvey(因利益冲突被迫多模型)、Cognition(自有模型+OpenAI+Anthropic路由)、Glean(AWS Bedrock开放模型)殊途同归——垂直Agent公司不押注单一基座模型，而是把价值沉淀在"路由+编排+领域数据+合规"层。这是对抗"被基座大厂吞噬"的核心防御。

**4. 入口与执行层的"互相嵌入"竞赛升温。** Replit×Claude、Devin Desktop×ACP×NVIDIA、Perplexity Brain——大家都在抢"Agent工作流的上下文/记忆/编排"位置。记忆(Brain)、协议(ACP)、集成密度(Replit)成为新护城河要素。

**5. 地缘政治成为Agent资产的硬约束。** Meta-Manus $20亿交易在中国监管下崩解、原投资人$20亿回购，标志中美AI资产跨境流动全面政治化——这是2026年企业Agent全球化绕不开的新变量。

---

### 🌐 板块四：浏览器 / 计算机操作 Agent + 中国 Agent

### OpenAI Operator / ChatGPT Agent

- **本周动态**：本周 OpenAI 在浏览器/计算机操作 Agent 的"产品形态"上无独立大版本更新，但围绕 Agent 能力的**企业落地与外围设置**密集推进。核心背景须先澄清：Operator 独立预览站已被关停，其浏览器驱动能力整体并入 **ChatGPT Agent 模式**，开发者侧则通过 Agents SDK/API 的 **computer-use 工具**获得同等能力（OpenAI 帮助中心页面本周内仍在更新，明确"Operator 网站不再可用，功能已并入 ChatGPT agent 模式，仅付费档可用，支持 Web/iOS/Android/macOS/Windows"）。本周实际发生的相关动态有三条：①**6月21日**官宣**三星电子（Samsung Electronics）**全球部署 ChatGPT Enterprise + Codex——韩国全员 + 全球 DX（Device eXperience）事业部全员，OpenAI 称这是其"史上最大规模企业部署之一"，覆盖研发、制造、营销、产品等；披露 **Codex 全球周活已超 500 万**，**韩国区 Codex 周活自2月1日以来增长近 800%**。②**6月18日**发布"企业用量分析与支出管控"（new usage analytics + spend controls for enterprises），直接服务于 Agent/Codex 规模化后的成本治理。③帮助中心新增 **Lockdown Mode**：开启后限制实时联网浏览、deep research、**agent mode**、文件下载等网络化能力——是 Agent 安全侧的收紧。综合判断：OpenAI 的 Agent 战略本周重心从"能力炫技"转向"企业级治理 + 大客户渗透"，Codex（编码 Agent）成为对企业渗透的尖刀，而浏览器操作 Agent 处于能力沉淀期。
- **关键数据**：Codex 全球周活 >500万；韩国区 Codex 周活自2026-02-01增长近800%（来源：openai.com/index/samsung-electronics-chatgpt-codex-deployment/，2026-06-21）；三星部署官宣日 2026-06-21；企业支出管控发布 2026-06-18（openai.com/news/）；computer-use 内部基准 WebVoyager 87%、WebArena 58.1%（背景，非本周；来源 firecrawl.dev/blog/best-browser-agents）。
- **原文链接**：https://openai.com/index/samsung-electronics-chatgpt-codex-deployment/ ; https://openai.com/news/ ; https://help.openai.com/en/articles/6825453-chatgpt-release-notes ; https://help.openai.com/ru-ru/articles/11752874-chatgpt-agent（Operator并入说明）
- **影响判断**：①三星全球级部署是 Agent/编码Agent 企业渗透的标志性拐点——"全员可用"而非"限定团队"，验证 Agent 正从试点转入生产工作流。②Lockdown Mode 与企业支出管控同周出现，说明 Agent 规模化后"安全 + 成本"成为头部厂商必须先解决的护栏，这是赛道成熟的信号。

---

### Anthropic Computer Use

- **本周动态**：本周 Anthropic 没有发布新的 Computer Use 模型版本，但有两件与 Agent 工程/商业化直接相关的大事。①**6月15日：暂停 Agent SDK 计费拆分**。Anthropic 原计划于 6/15 将 **Claude Agent SDK、claude -p（headless）、Claude Code GitHub Actions、经 ACP 认证的第三方 App（Zed/JetBrains 等）**的用量从 Pro/Max/Team/Enterprise 订阅池中剥离，改为按标准 API 费率计费的"独立月度美元额度、不可结转"。该计划原本是要终结"订阅补贴 Agent 用量 15–30×"的结构（一个 $20/月 Pro 用户理论上可跑出 $300–600 的 API 等值算力）。但 6/15 当天 Anthropic 在帮助中心确认**暂停该变更、维持现状**，称将"重新设计以更好支持用户用订阅构建 Claude"，未来变更会提前通知。Ars Technica、Axios 等多家报道交叉验证。②**自托管沙箱（self-hosted sandboxes）进入公开测试 + MCP 隧道进入研究预览**：Agent 编排/上下文/纠错循环留在 Anthropic 基础设施，工具执行可迁移到用户自有基础设施或 Cloudflare/Daytona/Modal/Vercel 等托管沙箱——直接服务于企业级 Computer Use/Agent 的数据隔离与合规。③Claude Code 本周高频迭代（2.1.178→2.1.185），含 agent teams 简化、嵌套 skills、auto 模式安全（阻断破坏性 git/terraform destroy 命令）等。
- **关键数据**：订阅补贴 Agent 用量约 15–30×（来源 Zed Industries 博客，2026-05-14）；暂停日 2026-06-15；原计划生效日 2026-06-15（来源：digitalapplied.com/blog/anthropic-claude-credit-overhaul-june-15-2026，更新于2026-06-16；arstechnica.com 2026-06）；Claude Code 本周版本 2.1.178–2.1.185（releasebot.io/updates/anthropic，首见日2026-06-19~21）。
- **原文链接**：https://www.digitalapplied.com/blog/anthropic-claude-credit-overhaul-june-15-2026 ; https://arstechnica.com/ai/2026/06/anthropic-pauses-token-based-billing-for-its-claude-agent-sdk/ ; https://releasebot.io/updates/anthropic ; https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan
- **影响判断**：①"暂停计费拆分"是本周 Agent 经济学的核心信号——印证 Ina Fried（Axios）的判断："'all-you-can-eat' 订阅可能撑不过 Agent 时代"。Anthropic 进退反复，说明 Agent 算力的定价模型尚未稳定，是整个赛道的结构性张力。②自托管沙箱公开测试是 Computer Use 走向企业生产的关键基建——把"执行环境"还给客户、把"智能环"留在云端，是兼顾合规与能力的折中范式。

---

### Google Project Mariner

- **本周动态**：与 OpenAI Operator 同构，Project Mariner 作为独立项目已于 **2026-05-04 关停**，其浏览器/网页任务自动化能力整体并入 **Gemini Agent** 及其他 Gemini/Google AI 产品（Android Authority、Search Engine Journal 交叉验证）。因此本周"Project Mariner"无独立产品动态，须以承接它的 Gemini Agent / Gemini in Chrome 为观察口。本周该线的真实动态集中在**浏览器侧 Agent 的消费级铺开**：①**Gemini in Chrome for Android 的 "Auto Browse"** 据多家媒体（digitbin 等，2026-06-18 前后）报道将于 **6月底**面向美国 Android 12+/≥4GB RAM 用户铺开，让助手"一键唤起侧边栏"并能**自动化常规网页任务（如停车预订、修改订单），无需离开 Chrome**——这是 Mariner 能力下沉到 Chrome 的直接产物。②Gemini 订阅页（gemini.google/subscriptions）本周仍在更新，Pro/Ultra 强调 "agentic capabilities"、Deep Search、Gemini 3 Pro/3.1 Pro 接入。③开发者侧：Gemini Code Assist IDE 扩展与 Gemini CLI 对个人/AI Pro/AI Ultra 档**自 6月18日起停止服务请求**（developers.google.com release notes），属 Agent 工具链的档位调整。综合判断：Google 的浏览器操作 Agent 已从"独立实验项目"过渡到"嵌入 Chrome 的默认能力"，路线是用 Chrome+Android 的分发优势把 Agent 变成"系统级默认"，而非独立App。
- **关键数据**：Project Mariner 关停日 2026-05-04（来源 androidauthority.com via searchenginejournal.com，2026-06-18报道）；Gemini in Chrome for Android Auto Browse 预计6月底铺开、限美国 Android 12+/≥4GB RAM（digitbin.com，2026-06-18前后）；Gemini Code Assist 个人档停服 2026-06-18（developers.google.com）；Gemini Enterprise 3.5 Flash toggle 2026-06-16后下线（docs.cloud.google.com）。
- **原文链接**：https://www.searchenginejournal.com/the-search-mirror-personal-intelligence-and-agentic-browsing/578430/ ; https://www.digitbin.com/gemini-chrome-android-auto-browse/ ; https://developers.google.com/gemini-code-assist/resources/release-notes ; https://gemini.google/subscriptions/
- **影响判断**：①三家头部（OpenAI/Google/各自）不约而同把"独立浏览器Agent项目"关停并入主力助手（Operator→ChatGPT Agent、Mariner→Gemini Agent），是2026年浏览器操作Agent的明确拐点信号——"独立产品"形态被证伪，"嵌入主力助手/浏览器"成为共识路线。②Google 借 Chrome/Android 分发把 Auto Browse 做成系统默认，是其相对 OpenAI 最大的结构性优势。

---

### 字节 Coze / 扣子

- **本周动态**：本周扣子/Coze **无重大公开产品发布**。核查多方信源：①开源版 **coze-studio** GitHub 最新正式 release 仍为 **v0.5.1（2026-02-05）**，本周（6/15–6/21）无新 tag/release，仅有日常 PR 合并（模型管理、知识库 OpenAPI、SQL 注入修复等小迭代），未发本周版本。②扣子的通用 Agent 平台"扣子空间（Coze Space）"为 **2026-04-19 发布**（36氪报道，首日用户破50万、平台已有超200万个AI应用），属本期区间外旧闻，仅作背景。③本周与字节相关的可见报道（36氪《13410亿，字节跳动的万亿野心》，2026-06-22）为产业综述，提及扣子作为字节 Agent 棋子的战略定位（先海外试验田、再国内复制；豆包大模型为底座），但无扣子本周具体动态。综合判断：扣子当前处于"4月大版本（扣子空间）后的消化期"，本周字节 Agent 线的公开声量集中在豆包App整合（猫箱/星绘并入）、AI硬件（眼镜/视频通话）等外围，而非扣子本体。须等官方公众号/官网后续发布确认。
- **关键数据**：coze-studio 开源最新版 v0.5.1（github.com/coze-dev/coze-studio/releases，2026-02-05，本周无新版）；扣子空间发布日 2026-04-19、首日用户>50万、平台AI应用>200万个（36kr.com/p/3257876933275904，背景非本周）；字节2024资本开支约800亿元、2025计划约1600亿元（The Information via 36氪，背景）。
- **原文链接**：https://github.com/coze-dev/coze-studio/releases ; https://36kr.com/p/3328673657579777 ; https://36kr.com/p/3257876933275904
- **影响判断**：①扣子本周静默，反映字节 Agent 节奏是"大版本脉冲+长消化"，与 OpenAI/Anthropic 的高频迭代形成对比。②真正值得跟踪的是字节"先海外后国内、产品经理批量复制"的打法，扣子是这套打法在 Agent 赛道的载体，短期声量低不代表战略降级。

---

### 智谱 AutoGLM

- **本周动态**：智谱本周是中国Agent阵营**声量最大**的一家，核心是 **GLM-5.2 旗舰开源模型 + ZCode 3.0 自研Agent内核**的"双发布"在本周内完成落地。时间线：**6月13日**晚智谱同日推出 GLM-5.2（面向 GLM Coding Plan 全量用户 Lite/Pro/Max/团队版开放）与 ZCode 3.0（全面切换**自研 ZCode Agent 内核**，放弃此前套用 Claude Code/Cline 的第三方Agent实现，官方称"长程推理、工具调用、大型工程执行链路整体效果已显著优于第三方Agent"，并宣布"后续不再内置/维护其他Agent适配"——即从"兼容Claude生态"转向"GLM+ZCode自有闭环"）。**6月16-20日（本周内）** API 与 MIT 开源权重落地：模型已上线 **Hugging Face（zai-org/GLM-5.2，MIT License）**、Z.ai Chat、GLM Coding Plan 与 Z.ai API，并支持 20+ 第三方 coding 工具。技术规格：safetensors 元数据显示**总参数约 753.33B**（MoE/DSA 路线，激活参数未公开），**上下文 1M tokens、最大输出 128K**，含 IndexShare 稀疏注意力（1M长度下复用索引器降 FLOPs）、MTP speculative decoding。官方 benchmark：**SWE-Bench Pro 62.1（GLM-5.1 为 58.4）、Terminal Bench 2.1(Terminus-2) 81.0（前代 63.5）、AIME 2026 99.2、GPQA Diamond 91.2、HLE 40.5**。智谱在公告中明确把开源当政治牌打："在一些前沿模型突然变得不可用的时刻……前沿智能不应被少数规则随时收回"——直指上周 Anthropic 收紧高端模型访问的背景。关于 **AutoGLM**（智谱的手机/浏览器GUI操作Agent）本体，本周无独立大版本公告，智谱本周Agent叙事的重心在 GLM-5.2 基座 + ZCode 编码Agent，而非 GUI 操作 Agent。
- **关键数据**：GLM-5.2 发布日 2026-06-13；API+开源权重落地 6月16-20（本周内，huggingface.co/zai-org/GLM-5.2，MIT）；总参数 ~753.33B（HF safetensors 元数据）；上下文 1M / 输出 128K；SWE-Bench Pro 62.1、Terminal Bench 2.1 81.0、AIME 2026 99.2、GPQA Diamond 91.2、HLE 40.5（官方模型卡，via datalearner.com 2026-06-18）；API 定价 输入 $1.4/M、缓存输入 $0.26/M、输出 $4.4/M（Z.ai Developer Docs）；ZCode 应用内 150% 配额加成；高峰期额度系数3倍/非高峰2倍（知乎口径）。
- **原文链接**：https://www.datalearner.com/ai-models/pretrained-models/glm-5-2 ; https://huggingface.co/zai-org/GLM-5.2 ; https://www.aitoollab.cn/articles/glm-52-zcode-3-release-analysis-202606/ ; https://zhuanlan.zhihu.com/p/2050158905360135402
- **影响判断**：①ZCode 3.0 自研Agent内核是关键信号——国产编码Agent从"套壳Claude Code"走向"模型+Agent垂直整合"，类比 iOS 封闭生态，换取体验一致性与针对GLM的链路优化。②MIT 开源 + 自研Agent + 1M上下文的组合，在本周 Anthropic/OpenAI 收紧访问的对照下，把"开源"从技术选择抬升为企业级"业务连续性/自主可控"选择，是中国Agent最强的差异化叙事。③真正待验证的是 1M 上下文"可用性"与独立第三方复现 benchmark。

---

### 月之暗面 Kimi Agent

- **本周动态**：月之暗面本周的本期区间内核心动态是 **Kimi K2.7 Code 高速版（2026-06-15）正式上线**——这是 6月12日发布并开源 K2.7 Code 编程大模型后的紧接动作，落在本周窗口内。高速版要点：与标准版**架构/参数完全相同，仅在推理引擎与服务部署层做专项加速**，输出速度提升至约**6倍**；典型编程任务（输入长度中位数）平均**180 token/s**，短上下文轻量任务峰值接近 **260 token/s**；API 标识 **kimi-k2.7-code-highspeed**，API 资费为标准版**2倍**，在 Kimi Code Plan 内消耗配额为标准版**3倍**；Kimi Code Plan 用户可经"抢先体验计划"（kimi.com/code/beta）率先使用，**2026年7月起 Allegretto 及以上会员**陆续获权限。背景（6/12发布的 K2.7 Code 本体，非本周但紧密关联）：1万亿参数 MoE（每Token激活32B、384专家、61层、MLA注意力）、256K上下文、MoonViT 视觉编码器支持图像/视频、Modified MIT 开放权重；强制思考模式（不可关；API关闭则报错，Kimi Code 自动回退 K2.6）；推理token消耗较 K2.6 **降约30%**、MCP 工具调用 Atlas 76.0(+9.5%)/Mark Verified 81.1(+11.4%)；定价输入¥6.5/M、输出¥27/M。Agent 侧：配套 **Kimi Code**（CLI + Agent + MCP，对标 Claude Code 国产替代，kimi.com/code）已上线，兼容 Claude Code/Cline/Roo Code。文末与智谱口径如出一辙地强调"前沿AI应开放普适、不应成为少数群体专享资源"——同样影射 Anthropic 收紧访问。注意：K2.7 Code **全部为月之暗面自有专有基准**，无 SWE-bench Verified 等第三方标准成绩，K2.6 曾有"宣称80% vs 实测60-65%"的15-20pp差距，须等独立复现。
- **关键数据**：K2.7 Code 高速版上线 2026-06-15（ai.zol.com.cn/1199/11999575.html，2026-06-16）；6倍速、180 token/s（中位）、峰值~260 token/s；高速版API=标准版2倍、配额3倍；K2.7 Code 发布/开源 2026-06-12；1T参数/激活32B/256K上下文；token降30%、MCP Atlas 76.0、Kimi Code Bench v2 62.0(+21.8%)；定价输入¥6.5/M·输出¥27/M（≈$0.95/$4.00），缓存命中输入¥1.3/M（aitoollab.cn 2026-06-13）。
- **原文链接**：https://ai.zol.com.cn/1199/11999575.html ; https://www.aitoollab.cn/articles/kimi-k2-7-code-open-source-1t-coding-model-benchmark-202606/ ; https://zhuanlan.zhihu.com/p/2049934593588044237 ; https://www.kimi.com/code
- **影响判断**：①Kimi 路线与智谱形成镜像对照——Kimi 走"专用模型+开放生态（兼容 Claude Code/Cline）"的安卓式路线，智谱走"模型+自研Agent闭环"的iOS式路线，两种范式本周同台，是国产编码Agent路线分化的标志。②高速版180 token/s把"AI写码接近人类阅读速度"变成现实，推理速度成为Agent体验的新竞争维度（而非仅准确率）。③自报基准+无第三方复现是国产模型共同短板，营销可信度待验证。

---

### 阿里 Qwen Agent

- **本周动态**：阿里通义本周区间内的核心动态是 **2026-06-16 发布 Qwen-Robot 系列具身智能大模型**——这是千问大模型家族**首个完整的具身智能模型体系**，标志阿里 Agent 战略从"数字世界Agent"向"物理世界AI（Physical AI）/ 具身智能体"延伸（量子位、新浪财经、X 多源交叉验证发布日 6/16）。三大模型："手"=**Qwen-RobotManip**（视觉-语言-动作 VLA 操作模型，采用 **80 维统一动作表征**解决跨设备/跨场景适配痛点，依相对位置而非绝对坐标运算，累计 **>38000 小时**语料预训练且**全程开源数据、未用私有采集数据**，在全球权威真机评测 **RoboChallenge Table30 v1** 中 "Lira"/"Atlas" 两版本**包揽榜单前两名**，可完成拧水龙头、插网线、双臂倒薯条等30项真实任务）；"脚"=**Qwen-RobotNav**（视觉-语言-导航 VLN，基于 Qwen-VL，整合5大任务于统一框架，任务自适应观察机制，原生兼容多种智能体框架，搭载宇树 Go2 四足机器人可语音指令自主巡逻/寻物）；"大脑"=**Qwen-RobotWorld**（世界模型，推演动作轨迹、生成海量视频训练数据缓解数据短缺）。三模型支持独立或协同部署，形成感知-决策-执行闭环。另：本周阿里云官网/百炼平台在持续主推 **Qwen3.7 系列**（"面向智能体时代"，编程/办公自动化/长周期自主执行），百炼内置 Agent 工具链、支持 MCP 托管、新用户赠超 7000 万 tokens——但 Qwen3.7 非本周首发，属在售旗舰。Qwen Agent 框架本体本周无独立大版本公告。
- **关键数据**：Qwen-Robot 系列发布日 2026-06-16（qbitai.com/2026/06/435873.html、finance.sina.com.cn 2026-06-16，X 同日，三源一致）；RobotManip 80维统一动作表征、>38000小时开源数据预训练、RoboChallenge Table30 v1 前两名、30项真实任务；百炼新用户赠 >7000万 tokens（aliyun.com/product/bailian，2026-06-19前后）；Qwen3.6-plus 默认百万 token 上下文（知乎综述 2026-06-17）。
- **原文链接**：https://www.qbitai.com/2026/06/435873.html ; https://finance.sina.com.cn/wm/2026-06-16/doc-inicqsxv4438421.shtml ; https://www.93913.com/122354.html ; https://www.aliyun.com/product/tongyi
- **影响判断**：①Qwen-Robot 是本组唯一把 Agent 从"屏幕/浏览器操作"推向"物理世界操作"的动态——80维统一动作表征 + 全开源数据 + RoboChallenge 登顶，是中国厂商在具身 Agent 赛道的实质卡位。②"全程开源数据、未用私有采集数据却拿真机评测第一"是强信号：阿里在用"开源基线"打法复制其在 LLM 上的开源策略，向具身智能迁移。③与字节(豆包整合)、智谱/Kimi(编码Agent)路线对比，阿里是头部里最早系统性押注具身 Agent 的一家。

---


#### 板块洞察（浏览器操作+中国 Agent 拐点）

本周浏览器/计算机操作Agent + 中国Agent赛道呈现三个清晰拐点信号：

**① "独立浏览器Agent项目"形态被集体证伪。** OpenAI Operator → ChatGPT Agent、Google Project Mariner → Gemini Agent，两大巨头不约而同关停独立项目、把浏览器操作能力并入主力助手/浏览器（Google更借Chrome+Android把"Auto Browse"做成系统默认）。"独立产品"路线退场，"嵌入主力入口"成为共识——浏览器操作Agent的竞争焦点从"能力炫技"转向"分发渠道 + 企业治理（安全/成本护栏，如OpenAI同周推Lockdown Mode与企业支出管控）"。

**② Agent经济学的定价模型尚未稳定，是全球共性张力。** Anthropic 6/15 紧急"暂停"Agent SDK计费拆分，印证"all-you-can-eat订阅撑不过Agent时代"——机器速度的token消耗与人类速度的订阅定价之间的结构性矛盾，头部厂商仍在反复试探，未有定论。

**③ 中国Agent本周声量集中爆发在"编码Agent + 具身Agent"，且高度共享"开源对冲"叙事。** 智谱(GLM-5.2+ZCode自研内核, MIT开源)、月之暗面(K2.7 Code高速版6倍速, Modified MIT)、阿里(Qwen-Robot全开源数据登顶RoboChallenge)三家本周均有实质动态，且智谱/Kimi公告口径惊人一致地影射"Anthropic收紧高端模型访问"，把"开源"从技术选择上升为"业务连续性/自主可控"的政治-商业选择。路线已分化：智谱=模型+自研Agent闭环(iOS式)、Kimi=专用模型+开放生态(安卓式)、阿里=向物理世界具身Agent延伸。值得警惕的共同短板：国产编码模型基准多为自报、缺独立第三方复现(K2.6曾有15-20pp宣传-实测差距)，"可用性"待验证。相比之下字节扣子本周静默，处于4月扣子空间大版本后的消化期。

---

## 📋 关于本周报

- **数据口径**：所有"本周"均指 2026-06-15 ~ 2026-06-21（上海时区）完整一周。版本号、融资额、估值、benchmark、Stars、发布日期等关键数据均标注来源 URL 与日期；查不到如实标"未公开/未一手验证"。
- **来源说明**：优先官方博客/论文/GitHub release/官方公告等一手来源；二手报道用于交叉验证并标注。GitHub Stars 经 api.github.com 实时读取（2026-06-22）。
- **覆盖说明**：4 组 28 对象全覆盖；有动态对象附原文链接+深度笔记，本周静默对象明确标注原因。
- **下期预告**：持续追踪 SpaceX-Cursor 交割进展、Cognition 多 Agent 编排（Devin Desktop+ACP）、Anthropic 计费模型再设计、智谱/Kimi 国产编码 Agent 第三方基准复现、Manus 回购与港股上市路径。
