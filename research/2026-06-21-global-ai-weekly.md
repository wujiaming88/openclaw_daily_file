# 全球 AI 动态周报 · 第 4 期（2026-06-14 ~ 06-20）

> **覆盖区间**　2026-06-14（周日）00:00 → 06-20（周六）24:00｜上海时区
> **覆盖范围**　38 个 AI 主体 · 6 大赛道 · 50+ 信息源 · 实质覆盖 38/38（100%）
> 全部信息严格限定在上述自然周内；窗口外动态仅作背景标注，不计入"本周动态"。
> **四维质量门控**：①覆盖 38/38（100%）②原文抽查 5/5 URL 真实 ③每对象洞察 + 六组主线趋势到位 ④关键数据多源交叉验证（GitHub Stars 实时核对、关键数字附源 URL+日期）。

---

## 🔥 本周 TOP 5 大事

### 1. SpaceX 600 亿美元全股票收购 Anysphere（Cursor）｜2026-06-16
SpaceX 宣布以 **600 亿美元全股票**收购 AI 编码工具 Cursor 的母公司 Anysphere，交易预计 2026 Q3 完成。SpaceX 早在 4 月就锁定 option（年内 600 亿收购或付 100 亿建合作），本周正式行权全资吞并。战略意图清晰：SpaceX 旗下 xAI 需补齐"AI 写代码"短板，并将在 Cursor 上发布自有模型与 xAI 编码 agent"Grok Build"（双方已联合训练数月）。Cursor 坐拥**超 100 万开发者、约 20 亿美元年化营收**，此前增长瓶颈正是算力不足，而 SpaceX 作为数据中心持有者恰好补上。
↳ **为什么重要**：头部独立 Agent 产品被超大平台全资吞并，标志"独立编码工具→巨头算力+模型闭环"的整合拐点（继 Cognition 收编 Windsurf 后又一例），中立第三方编码工具阵营进一步收缩，对 Anthropic/OpenAI 是直接竞争升级信号。
[Guardian 报道](https://www.theguardian.com/science/2026/jun/16/spacex-ai-coding-anysphere-cursor-amazon-market-valuation-xai)

### 2. Anthropic Fable 5 / Mythos 5 发布三天即被美国出口管制下线｜2026-06-12
Anthropic 6 月 9 日发布 Mythos 级旗舰 Fable 5 / Mythos 5（位于 Opus 级之上的新 tier），6 月 12 日应美国政府出口管制指令请求 AWS 对所有非美籍用户撤销访问，三天内被迫下线（Opus 4.8 等其他模型不受影响）。与此同时，Microsoft 公开考虑把中国 DeepSeek V4 嵌入 Copilot Cowork 降本。
↳ **为什么重要**：地缘政治首次直接掐断前沿模型商业化——"超 Opus 级"能力已触及国家安全红线，而成本现实又迫使西方平台向中国开源模型"用脚投票"。监管红线与成本压力在本周激烈碰撞，是整个前沿 AI 出海的重大监管信号。
[InfoQ 报道](https://venturebeat.com/technology/anthropic-ships-major-claude-design-overhaul-with-design-system-imports-code-round-trips-and-a-fix-for-its-token-burning-problem)\n
### 3. Microsoft Copilot Cowork 全球 GA + 按量计费｜2026-06-16
Microsoft Copilot Cowork（M365 内端到端执行复杂长时多工具任务的 agentic 系统）全球 GA，经三个月 Frontier 预览后**超半数 Fortune 500 已在使用**。最大变革是计费——从固定每席位转向**用量计费**，以 Copilot Credits 计价，PayGo 为 **$0.01/credit**，每任务价格由模型使用/上下文检索/工具调用/运行时四要素决定。微软内部 125 次测试称比 Claude Cowork 平均便宜 30-40%（均用 Opus 4.8）。自研 Cowork 1 降本模型将于数周内发布。
↳ **为什么重要**：标志整个行业从"每席位固定订阅"转向"agentic 按量付费"，与 GitHub Copilot token 计费、Anthropic Claude Cowork 形成全球共振，是 2026 年商业模式拐点。
[Microsoft 365 Blog](https://www.microsoft.com/en-us/microsoft-365/blog/2026/06/16/copilot-cowork-is-now-generally-available/)

### 4. 智谱 GLM-5.2 开源（MIT）：与 Opus 4.8 差距压到 1-4%｜2026-06-13/17
智谱 6 月 13 日宣布新旗舰 **GLM-5.2** 面向 GLM Coding Plan 全量开放，6 月 17 日按 **MIT 协议全量开源**。技术亮点：1M 无损上下文；Code Arena 取得"全球可用模型第一"；FrontierSWE 仅比 Claude Opus 4.8 低 1%、超 GPT-5.5；Terminal-Bench 2.1 得 81.0（前代 63.5）；Day 0 适配华为昇腾等 **8 款国产算力平台**。时机敏感——选在 Anthropic Fable 5/Mythos 5 被强制下线次日开放，精准卡位竞品停服窗口。资本面：科创板 IPO 辅导 11 天进入验收，股价较发行价涨超 1200%。
↳ **为什么重要**：把开源模型与闭源旗舰差距压到 1-4%，刷新国产开源天花板；"开源+MIT+国产芯片 Day0 适配"是地缘技术博弈下的教科书级借势。
[东方财富/澎湃](https://finance.eastmoney.com/a/202606173774299794.html)

### 5. NVIDIA 250 亿美元史上最大债券发行（30 年期）｜2026-06-15/18
NVIDIA 为 2021 年以来首次高评级债券定价，因认购火爆（订单约 850 亿、超额认购逾 3 倍）从原计划 200 亿上调至 **250 亿美元**，分 7 档期最长至 **2056 年（30 年期）**。NVIDIA 并不缺钱（净债务为负 400 亿、上季 FCF 486 亿），借债意图是为 **1240 亿美元前向采购承诺**锁定低成本长期资本，并在不稀释股东前提下同步支撑增长与 800 亿回购。CFO 确认下一代平台 Vera Rubin 已为 Q3 满产准备就绪。
↳ **为什么重要**：30 年期债券是债券市场对"AI 基础设施是数十年级长周期建设"的金融化下注，也是 bear case 的镜像——若需求降温，在 capex 顶部发的长债会很难看。
[tikr 分析](https://www.tikr.com/blog/nvidia-just-raised-25-billion-in-its-biggest-bond-deal-ever-heres-what-it-signals-for-2026)

---

## 🧭 三条主线趋势

**主线一 · 定价范式集体拐点：从"席位订阅"转向"按量计费/按结果计费"。**
Microsoft Copilot Cowork GA 改用 Copilot Credits（$0.01/credit）按量计费；Harvey CEO 自白 token 用量 5 个月暴涨 12 倍（1T→12T/月）并抛出"我花 10 亿买 token，ROI 在哪"的拷问；Sierra 提出"outcomemaxxing"（以结果而非消耗衡量）；月之暗面 K2.7 Code 主打 token 消耗 -30%；国内豆包/MiniMax/智谱/Kimi/阿里云集体收紧免费额度。agentic AI 的算力成本无法用固定席位价覆盖，"补贴换生态"时代在中美同步落幕，行业进入"按任务分级路由、成本可解释"的成熟期。

**主线二 · 竞争焦点从"模型能力"上移到"Agent 工程化与企业工作面"。**
三大云本周不约而同押注 agent 运维治理层而非模型本身：AWS Summit 纽约主推 AgentCore 从预览走向企业级 + AWS Context 知识图谱；Azure/Microsoft Foundry 连发 Benchmarks/Rubric Evaluators/USR 用户模拟器/Enterprise RL；编码侧 Claude Code 发 Artifacts 对位 OpenAI Codex Sites，竞争从"代码质量"上移到"如何把 agent 产出呈现给整个组织"。可靠性、安全基建、开放标准（MCP 已成事实标准）、渠道覆盖、企业工作面成为五大卡位维度——智能上限差距在缩小，工程化与生态卡位差距在拉大。

**主线三 · 地缘技术博弈重塑节奏，具身智能成中国大厂新战场。**
Anthropic Fable 5 被出口管制三天下线、Microsoft 转而考虑 DeepSeek V4，监管红线与成本现实激烈碰撞；智谱借窗口期 MIT 开源 GLM-5.2 + 国产芯片 Day0 适配，"开放度"成为对冲不确定性的武器。同时阿里发首个具身大模型 Qwen-Robot 系列（>38,100 小时语料、兼容 15 个本体）、腾讯 Robotics X+混元开源 HyVLA-0.5，两大厂同周押注"语言模型作物理世界工具"的具身范式；硬件侧宇树 73 天闪电过会（420 亿发行市值）、优必选 U1 预售 17 天近 5000 台，中国具身赛道进入"量产/上市双竞赛"的规模化验证期。

---

## 🧠 赛道深度正文 · A 组｜大模型基座（10）

### 1. OpenAI（GPT-5/ChatGPT/Codex）
- **本周动态**：本周OpenAI的公开动态集中在Codex产品线的高频迭代，以及GPT-5.6旗舰即将发布的密集预热。①**Codex app 26.616（2026-06-18发布，官方changelog）**：新增 **Record & Replay**（macOS功能，把一次演示过的工作流转成可复用skill，初期排除EEA/UK/瑞士，需开启Computer Use）；automation运行历史新增批量操作；新增本地与远程主机之间的 **thread handoff**（线程跨主机交接，Codex可自动协调）；改进Browser Use的可见标签路由持久化。②**Codex功能向EEA/UK/瑞士开放（2026-06-16）**：Computer Use在这些地区的macOS/Windows上线、Codex Chrome扩展、Memories（默认关闭）、Chronicle（ChatGPT Pro的opt-in研究预览）。③**ChatGPT for iOS 1.2026.160（2026-06-15）**：新增workspace文件浏览器、目录选择器、diff展开/折叠、MCP审批选项、Codex消息LaTeX渲染。④**GPT-5.6预热**：多家媒体（TechTimes 6-16、AIWeekly 6-18）报道首席科学家称GPT-5.6是"meaningful leap"，按约六周旗舰节奏（5.4→3/5、5.5→4/23）推算6月底发布，Codex后端已现"kindle-alpha"候选版本；传闻API定价约为Anthropic Claude Fable 5的三分之一。技术/商业判断：OpenAI正把Codex作为agentic coding的护城河（自称数百万活跃Codex用户），以"周级"产品迭代+激进定价压制竞品，GPT-5.6将统一驱动ChatGPT/Copilot/Atlas浏览器。
- **关键数据**：Codex app 26.616发布日 2026-06-18（developers.openai.com/codex/changelog）；Codex EEA/UK/瑞士开放 2026-06-16（同上）；ChatGPT iOS 1.2026.160 2026-06-15（同上）；GPT-5.6"六周节奏"推算+三分之一定价为**传闻/未officially确认**（techtimes.com 2026-06-16, aiweekly.co 2026-06-18）。
- **原文链接**：https://developers.openai.com/codex/changelog ；https://openai.com/research/index/release/ ；https://www.techtimes.com/articles/318492/20260616/gpt-56-openai-chief-scientist-calls-it-meaningful-leap-june-launch-nears.htm
- **影响判断**：Codex的周级迭代+Computer Use/Record&Replay体现OpenAI从"模型"向"自动化操作系统"转型，护城河从模型能力转向工作流锁定。GPT-5.6若按期发布且定价仅为对手1/3，将进一步挤压Anthropic在编码市场的份额，是agentic coding价格战的关键拐点。

---

### 2. Google DeepMind（Gemini/Gemma）
- **本周动态**：本周DeepMind没有发布新旗舰，但有两条与本周区间相关的实质动态。①**Gemma 4 上线 Amazon Bedrock（AWS Weekly Roundup, 2026-06-15）**：Gemma 4家族三个变体在Bedrock可用——Gemma 4 31B（dense稠密架构，256K token上下文窗口，面向推理与编码）、Gemma 4 26B-A4B（MoE混合专家架构，面向成本/延迟敏感场景）、Gemma 4 E2B（最小变体，低延迟交互）。Gemma 4本体4月2日已发布，本周是云分发渠道扩张。②**Gemini Code Assist停服节点（2026-06-18）**：Gemini Code Assist IDE扩展与Gemini CLI在个人版/Google AI Pro/Ultra层级自该日起停止服务请求，属产品线收编。③**Gemini 3.5 Pro持续跳票**：Pichai在5月19日活动上称"give us until next month"（即6月），但截至6月中仍未发布；Polymarket交易员共识押注6月30日发布；传闻规格2M token上下文、Deep Think推理、约$15/$60每百万token。背景（非本周）：DiffusionGemma（26B、Apache 2.0、文本生成快4倍）于6月10-11日发布，刚好在本周区间前。技术判断：DeepMind旗舰发布节奏明显落后OpenAI/Anthropic（后两者已周级/双周迭代），Gemini 3.5 Pro跳票暴露Google在前沿模型竞速中的工程化交付压力，但其开源Gemma线（含扩散式DiffusionGemma）保持活跃，走"闭源旗舰+开源生态"双轨。
- **关键数据**：Gemma 4 Bedrock三变体规格 31B/256K、26B-A4B MoE、E2B（aws.amazon.com 2026-06-15）；Gemini Code Assist停服 2026-06-18（developers.google.com）；Gemini 3.5 Pro规格2M上下文/$15/$60为**传闻未确认**（growwingassistant.com 2026-06-19, polymarket 6-18）。
- **原文链接**：https://aws.amazon.com/blogs/aws/aws-weekly-roundup-aws-finops-agent-in-preview-gemma-4-on-bedrock-kiro-pro-max-and-more-june-15-2026/ ；https://developers.google.com/gemini-code-assist/resources/release-notes
- **影响判断**：Gemini 3.5 Pro一再跳票是本周最值得关注的负面信号——在OpenAI GPT-5.6、Anthropic Mythos级别密集出货的背景下，Google旗舰交付滞后可能侵蚀其在企业API市场的份额。Gemma上Bedrock则是Google开源生态借第三方云抢占开发者心智的务实一招。

---

### 3. Anthropic（Claude Opus/Sonnet）
- **本周动态**：Anthropic本周动作密集，是A组本周最活跃对象之一。①**Claude Design大改版（2026-06-17, VentureBeat/CNET确认，官方Wednesday发布）**：从4月的"research preview"（首周破百万用户但token消耗惊人，PCWorld评测者25分钟烧光Pro周额度80%）升级为"设计系统合规层"。三大新能力：(a)**Design System导入**——可从GitHub仓库/设计文件/原始上传导入企业设计系统，Claude据此构建并自动校正至合规，新增admin角色可锁定标准系统；(b)**与Claude Code双向打通**——`/design-sync`把本地代码库设计系统导入Design，`/design`命令让开发者在Code终端内创建编辑同步，意在消灭设计-工程交接断层；(c)**token经济性修复**——Design现与chat/Cowork/Code共享额度池（而非独立小池），并降低单轮平均token消耗。②**九个新导出伙伴**：Adobe、Base44、Canva、Gamma、Lovable、Miro、Replit、Vercel、Wix，定位Design为创意"起点hub"。③**Fable 5/Mythos 5出口管制暂停**：6月9日发布Mythos级旗舰Fable 5/Mythos 5（位于Opus级之上的新tier），6月12日Anthropic应美国政府出口管制指令请求AWS对所有用户撤销访问，三天内被迫下线（InfoQ 6-16, AWS Roundup确认；Opus 4.8等其他模型不受影响）。④**研究披露**：约40万次Claude Code会话分析显示领域专业度（而非编码熟练度）是成功主因；Claude Code用户平均每周使用20小时。背景动态：Claude Opus 4.8于5月28日发布含"dynamic workflows"（单会话数百并行子agent）。技术/商业判断：Anthropic正执行AI业最激进的产品扩张，从"对话助手"转向"嵌入企业全栈的worker"（Design+Code+Cowork+Managed Agents统一底模+共享上下文）。
- **关键数据**：Claude Design破百万用户首周（venturebeat 2026-06-17）；9个导出伙伴（同上）；开源替代Open Design 8周内57,400 GitHub stars/310贡献者/259 skills/142设计系统（venturebeat引Augment Code）；Fable 5/Mythos 5发布6-9、出口管制下线6-12（infoq 2026-06-16）；Claude Code用户周均20小时、40万会话研究（anthropic.com research）。
- **原文链接**：https://venturebeat.com/technology/anthropic-ships-major-claude-design-overhaul-with-design-system-imports-code-round-trips-and-a-fix-for-its-token-burning-problem ；https://www.cnet.com/tech/services-and-software/anthropic-claude-code-design-june-2026-news/
- **影响判断**：①Claude Design的"设计系统合规层"定位是真正的拐点——把生成式设计从"惊艳demo"转为企业品牌合规基础设施，admin锁定是直击企业采购的杀手锏。②Fable 5被出口管制三天下线是地缘政治首次直接掐断前沿模型商业化的标志性事件，预示Mythos级"超Opus"能力已触及国家安全红线，对整个前沿AI出海是重大监管信号。

---

### 4. Meta AI（Llama 4）
- **本周动态**：Meta本周无新模型发布，动态以战略与组织危机叙事为主。①**CNBC深度报道（2026-06-14）**：花$14B+引入Alexandr Wang及Scale AI核心工程师一年后，Meta"重回AI地图"但仍远落后OpenAI/Anthropic/Google。Wang的标志性成果是4月交付的**Muse Spark**模型——Meta首次进入专有基础模型、首次偏离严格开源(开放权重)路线。报道核心论点：Zuckerberg现在的任务是把模型"卖出去"，需证明能吸引付费用户而非仅用于强化广告主业；分析师(William Blair)称"Meta需要更多采用与商业化的证据点"，且截至2026年6月Meta在广告之外尚未从AI赚到钱。②**组织动荡**：多家媒体(36kr、FourWeekMBA、Pragmatic Engineer 6/12-16)报道Meta Superintelligence Labs内部"GULAG"式反弹——6月12日一名员工劫持了数千人观看的内部直播演示；4,500+工程师被强制投入数据标注以产出高质量RLHF（疑为在建的编码LLM）；同日(6/12周六)Facebook/Instagram再发SEV0全面宕机。背景(非本周)：Llama 4于2025年4月发布"fell flat"，未能打动开发者，促使Zuckerberg重新考虑AI路线。技术/商业判断：Meta正从开源Llama路线转向专有Muse Spark闭源路线，但代价是工程组织撕裂与主业可靠性下降。
- **关键数据**：Scale AI交易$14B+/49%股份/6,500工程师（cnbc 6-14, fourweekmba）；Muse Spark 2026-04交付（cnbc.com）；截至2026年6月AI广告外零营收（techtimes 6-16）；6/12内部直播被劫持+FB/IG SEV0宕机（pragmaticengineer 6-15）。
- **原文链接**：https://www.cnbc.com/2026/06/14/meta-hired-alexandr-wang-to-build-ai-its-zuckerbergs-job-to-sell-it.html ；https://newsletter.pragmaticengineer.com/p/why-is-meta-destroying-its-engineering
- **影响判断**：Meta本周的故事是"重金买来的AI仍需证明商业价值"。从开源Llama到专有Muse Spark的路线转向，叠加组织内乱与基础设施宕机，揭示Meta在AI竞速中以组织健康为代价换取速度，其能否商业化是2026下半年关键观察点。

---

### 5. xAI（Grok）
- **本周动态**：xAI本周以"企业分发"为主线密集出货。①**Grok登陆Databricks（2026-06-18，x.ai官方+Musk本人X贴文宣布）**：Grok模型原生可用于Databricks Agent Bricks（Databricks的开发者agent平台），在2026 Data+AI Summit现场宣布。意义：Databricks Lakehouse上的企业团队现在"一键"即可用Grok驱动生产级AI agent，agent可直接对Lakehouse中结构化/非结构化数据推理而无需经外部管道；Databricks确认采用零数据保留端点，xAI不保留提交数据、Databricks不用客户数据训练基础模型——对企业数据治理是实质保证。②**Grok Imagine Video 1.5 GA（2026-06-16，x.ai）**：视频生成模型在Imagine API正式可用，质量提升且速度更快，同步推出Video 1.5 Fast到grok.com/imagine及iOS/Android。③**Composer 2.5上线Grok Build**：快速SOTA模型，擅长长任务与复杂指令遵循；xAI还加入Smart Turn端到端轮次检测。技术细节：旗舰grok-4.3为推理模型，1M token上下文，知识截止2025年12月，定价$1.25/百万输入token、$2.50/百万输出token；编码变体grok-build-0.1为$1.00输入/$2.00输出。企业云布局：Grok已先后登陆Oracle Cloud(2025-06)、Azure AI Foundry(2025-09)、Amazon Bedrock、现Databricks。技术/商业判断：xAI本周的关键词是"分发而非能力"——通过覆盖主流云/数据平台移除企业采用摩擦。
- **关键数据**：grok-4.3定价$1.25/$2.50每百万token、1M上下文、知识截止2025-12（basenor.com引x.ai 2026-06-18）；grok-build-0.1 $1.00/$2.00；Grok Databricks 2026-06-18、Grok Imagine Video 1.5 GA 2026-06-16（x.ai）；x.ai首页称日处理300M+查询/150K GPU（x.ai 6-18，单一来源）。
- **原文链接**：https://www.basenor.com/blogs/news/xai-grok-lands-on-databricks-at-the-2026-data-ai-summit ；https://x.ai/news/grok-databricks（直连被反爬阻断，经basenor交叉）
- **影响判断**：Grok从"消费级聊天机器人"转为"企业开发者在数据工作流中随手可用的模型"，是xAI商业化的关键转向。但能否在Databricks/Bedrock等平台上对Claude/Gemini抢到实质份额仍是悬念——基础设施已铺好，采用率待验证。背景隐忧：Grok本月仍面临深度伪造相关法律审查(Wikipedia)。

---

### 6. Microsoft（Copilot/Azure AI/Phi）
- **本周动态**：本周Microsoft头条是**Copilot Cowork全球GA（2026-06-16，官方Microsoft 365 Blog）**。这是M365内一个执行复杂、长时、多工具任务的agentic系统——用户定义任务，Cowork端到端执行并返回完成结果(而非草稿)。①**采用数据**：经三个月Frontier预览，超半数Fortune 500已在使用，客户含Accenture、Capital Group、Koch、Zurich Insurance等；官方称是Frontier史上增长最快的功能、用户满意度最高的Copilot/agent体验之一。②**计费革命**：从固定每席位转向**用量计费**，以Copilot Credits计价，PayGo为**$0.01/credit**；每任务价格由四要素决定(模型使用/上下文检索/工具调用/运行时)；需M365 Copilot USL(约$30/用户/月)。Microsoft内部测试称Copilot Cowork比Claude Cowork(用M365连接器)平均便宜30-40%(均用Opus 4.8，125次测试)。③**多模型**：GA时跑Anthropic模型(Opus 4.8、Sonnet 4.6)，Frontier中可用GPT-5.5；自研**Cowork 1**(微调模型，大幅降本)将于数周内发布。④**成本治理**：默认关闭，admin控制开启/预算/告警；租户/组/用户三级支出上限；PayGo与P3(预付折扣)两种付费。⑤**插件**：9个伙伴插件已上线(Harvey、LSEG、Miro、monday.com、Moodys、Morningstar、S&P等)，Adobe/Atlassian/Box/Canva/Databricks即将到来。⑥**DeepSeek探索**：据Axios(6-16)/Computerworld，Microsoft正探索微调版**DeepSeek V4**或其他开源模型作为低成本替代。背景：Build 2026(6/2)推出MAI-Code-1编码模型(已入Copilot/VS Code)，MAI模型还将上Fireworks/Baseten/OpenRouter。技术/商业判断：Microsoft把agentic AI从"订阅制"推向"按量付费"，是行业定价范式拐点。
- **关键数据**：Copilot Cowork GA 2026-06-16、PayGo $0.01/credit、M365 Copilot USL约$30/用户/月（microsoft.com 6-16, memeburn）；比Claude Cowork便宜30-40%（微软内部125次测试，microsoft.com 6-16）；超半数Fortune 500采用（同上）；探索DeepSeek V4（axios 6-16, computerworld）；Frontier用户7/1前免计费宽限。
- **原文链接**：https://www.microsoft.com/en-us/microsoft-365/blog/2026/06/16/copilot-cowork-is-now-generally-available/ ；https://www.axios.com/2026/06/16/microsoft-copilot-cowork-tokenmaxxing-cowork
- **影响判断**：①Copilot Cowork的用量计费(Copilot Credits)标志整个行业从"每席位固定订阅"转向"agentic按量付费"，与GitHub Copilot token计费、Anthropic Claude Cowork形成共振，是2026年商业模式拐点。②自研Cowork 1+探索DeepSeek V4降本，显示Microsoft既想减少对Anthropic/OpenAI的模型依赖，又在用"便宜30-40%"直接对标Claude Cowork——平台方与模型供应商的竞合张力加剧。

---

### 7. DeepSeek（V3/R1/V4）
- **本周动态**：DeepSeek本周无全新旗舰发布，但因两条事件成为本周焦点。①**被Microsoft选为Copilot Cowork降本候选（2026-06-16，Axios/Computerworld）**：Microsoft明确表示正探索微调版**DeepSeek V4**或其他开源模型，作为Anthropic/OpenAI模型的低成本替代，用于驱动Copilot Cowork。这是西方头部平台首次公开考虑将中国开源模型嵌入旗舰企业产品的标志性信号。②**DeepSeek V4 Pro持续霸榜算法/数学基准**：据CodingFleet对比(6-16)与OpenRouter数据，V4 Pro(2026-04-24发布，1.6T总参/49B激活MoE，1M上下文，MIT许可)在**LiveCodeBench达93.5%(全球第一，开源闭源通吃)**、Codeforces 3206、HMMT 2026 95.2%、GPQA Diamond 90.1%、SWE-bench Verified 80.6%(开源最高，与Gemini 3.1 Pro并列)；OpenRouter实测本周仍是高流量模型(30分钟内59,848次请求，日成功410万+次)。定价$0.435/百万输入、$0.87/百万输出——比GLM-5.2便宜约5倍，比Claude便宜约28倍(同等SWE-bench表现)。③**arXiv发布V4系列preview论文**(arXiv:2606.19348，llm-stats 6-20标注)。背景(非本周)：V4 Pro 4月24日发布、V4 Flash同日。技术/商业判断：DeepSeek的"极致性价比+MIT开源+双模式API(OpenAI+Anthropic兼容)"组合，使其成为全球成本敏感型工作负载与高量API管道的默认选择，正在从"中国之光"变为"全球基础设施层"。
- **关键数据**：V4 Pro 1.6T/49B激活、1M上下文、$0.435/$0.87每百万token（openrouter.ai 2026-06-20实时；codingfleet 6-16）；LiveCodeBench 93.5%全球第一、SWE-bench Verified 80.6%、GPQA 90.1%（codingfleet引DeepSeek model card）；OpenRouter 30分钟59,848请求/日410万成功（openrouter.ai 6-20）；Microsoft探索DeepSeek V4（axios 6-16）。注：55.4% SWE-bench Pro为厂商口径、未经Scale独立验证。
- **原文链接**：https://openrouter.ai/deepseek/deepseek-v4-pro ；https://codingfleet.com/blog/glm-5-2-vs-deepseek-v4-pro/ ；https://www.axios.com/2026/06/16/microsoft-copilot-cowork-tokenmaxxing-cowork
- **影响判断**：Microsoft公开把DeepSeek V4列为Copilot Cowork降本候选，是中国开源模型进入西方旗舰企业产品供应链的破冰信号——尽管面临地缘政治审查(对比Anthropic Fable 5被出口管制下线)，纯粹的成本/性能优势正迫使西方平台方"用脚投票"。DeepSeek的价格屠夫角色是2026年LLM API价格崩塌的核心推手。

---

### 8. Databricks（DBRX/Mosaic ML）
- **本周动态**：Databricks本周的核心动作是**2026 Data+AI Summit（旧金山，6月）密集发布**，本组覆盖区间内最相关的是模型生态扩张。①**xAI Grok原生登陆Databricks Agent Bricks（2026-06-18，x.ai+Databricks联合宣布，Musk本人X贴）**：Grok模型现可在Agent Bricks(Databricks的开发者agent平台)中直接选用，agent能对Lakehouse中企业自有结构化/非结构化数据推理而无需经外部管道；采用零数据保留端点，xAI不留存提交数据、Databricks不用客户数据训练基础模型——企业数据治理保证。这延续了Databricks"多模型中立平台"战略(此前已集成Anthropic Claude、Google Gemini、OpenAI、Meta Llama等)。②**Gemma 4等第三方模型**也在本周通过Bedrock等渠道与Databricks生态交叉。背景(非本周)：Databricks自有DBRX、Mosaic ML训练栈、以及估值方面2025年底融资后估值已达千亿美元级别(具体本周数字未公开)。技术/商业判断：Databricks不押注单一自有模型，而是把自己定位为"企业数据所在地的模型中立编排层"——谁能贴着企业数据干活，谁就赢。Grok入驻是这一战略的最新落子，xAI借Databricks触达Fortune 500数据团队，Databricks借Grok丰富模型货架，双赢。
- **关键数据**：Grok登陆Databricks Agent Bricks 2026-06-18（basenor引x.ai/Databricks）；零数据保留端点（同上）；Databricks自有模型/估值本周**无新公开数字**。
- **原文链接**：https://www.basenor.com/blogs/news/xai-grok-lands-on-databricks-at-the-2026-data-ai-summit ；https://x.ai/news/grok-databricks（直连反爬，经basenor交叉）
- **影响判断**：Databricks本周展现的是"数据引力"战略的胜利——当模型逐渐商品化，掌握企业数据所在地(Lakehouse)的平台方拥有最强议价权。Grok、Claude、Gemini争相入驻Agent Bricks，印证Databricks已成为企业级agentic AI的关键分发枢纽，这对纯模型厂商是长期的渠道依赖风险。

---

### 9. 字节跳动（豆包/Coze）
- **本周动态**：字节本周核心动态是**豆包正式启动商业化灰度测试（2026-06-17，社区反馈/80aj报道）**。①**分级会员体系**：豆包对部分用户灰度内测分级会员订阅，分"标准版""加强版""高级版"三档，权益预计涵盖模型调用次数、上下文窗口长度、响应速度、高级模型使用权等差异化服务。这标志头部大模型应用从"免费抢占市场"加速转向"多元化商业变现"。背景铺垫：6月3日豆包已公告将推专业版(针对专业人群生产力需求)，日常功能仍在一定额度内免费。②**行业共振**：本周同期MiniMax(6/2致歉)、智谱、Kimi、阿里云相继收紧免费用量、切换Token计费，国内大模型集体撕掉"畅享无限"标签，结束"补贴换生态"时代。③**舆论梗**："豆包每天收入不足百万"成网络热梗，侧面反映市场对大模型商业化的高度关注。④**Doubao-Seed-2.0**为最新通用模型(2026年2月发布)，Lite适配通用生产、Mini专为高并发优化，视觉推理/时序运动感知/指令遵循显著提升，复杂Agent能力达业界第一梯队；豆包DAU 2026春节后达2亿(36kr, 5天前)。技术/商业判断：字节凭流量分发优势在国内AI应用层断层领先(DAU 2亿)，但此前营收变现克制；本周商业化灰度是从"规模"转向"盈利"的关键一步。
- **关键数据**：豆包分级会员标准/加强/高级三档（80aj 2026-06-17）；豆包DAU 2亿(2026春节后，36kr)；Doubao-Seed-2.0 2026年2月发布(zhihu 6-17)；专业版6月3日公告(sohu)。注：具体订阅价格/营收数字本周未公开。
- **原文链接**：https://www.80aj.com/2026/06/17/bytedance-doubag-membership-test/ ；https://36kr.com/p/3838454229027072
- **影响判断**：豆包商业化灰度是国内AI应用"烧钱换增长"时代落幕的标志性事件。拥有2亿DAU与最强流量分发渠道的字节带头收费，极可能引发文心、通义等跟随效应，加速终结国内AI"全免费"时代，行业进入存量竞争与变现下半场。能否教育C端付费意愿是最大挑战。

---

### 10. Mistral AI（Mistral Large/Codestral）
- **本周动态**：Mistral本周头条是**寻求约€30亿($35亿)新融资、估值近€200亿($232亿)（Bloomberg 2026-06-12首报，SiliconANGLE/Yahoo/经济时报本周密集跟进）**。①**融资条款**：估值较9个月前(2025年9月由ASML领投的€17亿轮)近乎翻倍；当时估值€11.7B，本轮€20B；公司已于2026年3月获$830M债务融资用于数据中心；据FourWeekMBA，这家三岁法国公司刚跨过$400M ARR。现有投资人含ASML、Nvidia、Salesforce Ventures等。②**Physics AI新战略**：融资正值Mistral宣布进军工业工程AI——开发"physics AI"软件套件，让工程师快速生成产品设计变体并在仿真中测试；5月收购初创Emmi(专做physics AI模型工具，架构不同于标准LLM，优化求解偏微分方程，用于计算流体力学等)；已发表多篇physics AI论文(含聚变研究应用)，可能开源部分模型。③**产品线**：最新开源模型Mistral Medium 3.5(4月发布，128B参数，部分编码基准超3倍体量模型)；付费云服务含AI助手Mistral Vibe(原Le Chat，5月底更名)、agent开发平台Studio；Pro订阅$14.99/月。技术/商业判断：Mistral正从"欧洲开源LLM冠军"向"工业/物理AI+主权AI"差异化突围，避开与OpenAI/Anthropic的通用模型正面消耗战。
- **关键数据**：融资€3B/估值€20B($23.2B)（bloomberg/siliconangle 2026-06-12）；前轮€1.7B由ASML领投、估值€11.7B(2025-09)；$830M债务融资(2026-03)；ARR约$400M（fourweekmba）；Pro订阅$14.99/月(wikipedia)；Mistral Medium 3.5 128B(2026-04)。
- **原文链接**：https://siliconangle.com/2026/06/12/mistral-reportedly-seeking-3-5b-funding-round-amid-physics-ai-push/ ；https://finance.yahoo.com/sectors/technology/articles/mistral-ai-weighs-funding-23bn-091700112.html
- **影响判断**：①估值9个月翻倍至€20B，印证欧洲主权AI叙事的资本热度，但TFN等已质疑"现在要证明它"——$400M ARR对€20B估值是50倍PS，泡沫风险显现。②Physics AI转向是聪明的差异化——避开通用LLM红海，切入工业工程/仿真这一OpenAI/Anthropic尚未深耕的垂直，但本周即遭遇Bezos的Prometheus(本周融$12B)正面竞争同一赛道，欧洲冠军的物理AI叙事面临强敌。

---

## 本组洞察（A组｜大模型基座 趋势/拐点/底层逻辑）

**1. 定价范式拐点：从"席位订阅"集体转向"按量计费(token/credit)"。** 本周最强信号是Microsoft Copilot Cowork GA改用Copilot Credits($0.01/credit)按量计费，与GitHub Copilot token计费、Anthropic Claude Cowork、国内豆包/MiniMax/智谱/Kimi/阿里云集体收紧免费额度形成全球共振。agentic AI的算力成本无法用固定席位价覆盖，"补贴换生态"时代在中美同步落幕——这是本周横跨A组多对象的最深层拐点。

**2. 模型商品化加速，"分发渠道/数据引力"成为新护城河。** xAI Grok本周登陆Databricks(并已覆盖Oracle/Azure/Bedrock)、Gemma 4上Bedrock、Microsoft探索DeepSeek V4——模型本身正被快速商品化，谁贴着企业数据(Databricks Lakehouse)、谁掌握分发入口(M365/云平台)，谁就掌握议价权。纯模型厂商面临长期渠道依赖风险。

**3. 地缘政治首次直接掐断前沿模型商业化。** Anthropic Fable 5/Mythos 5(超Opus级)6月9日发布、6月12日即被美国出口管制指令逼迫AWS全面下线，三天夭折。与此同时Microsoft公开考虑把中国DeepSeek V4嵌入旗舰产品。监管红线与成本现实在本周激烈碰撞——"超能力前沿模型"已触及国家安全阈值，而成本压力又迫使西方平台向中国开源模型"用脚投票"。

**4. 旗舰交付出现分化：高频迭代者vs跳票者。** OpenAI(Codex周级迭代+GPT-5.6将至)、Anthropic(Design大改+Mythos级)、xAI(Grok多平台铺货)处于高频出货状态；而Google Gemini 3.5 Pro一再跳票(Pichai"再给一个月")、Meta重金买来Muse Spark仍需证明商业价值并陷组织内乱。交付节奏正成为前沿竞速的分水岭。

**5. 差异化突围与垂直深耕成为"非头部"生存法则。** Mistral转向Physics AI(工业/仿真)、DeepSeek专注极致性价比+算法/数学霸榜、Databricks做模型中立编排层——在OpenAI/Anthropic/Google三强通用模型消耗战之外，二线玩家纷纷选择垂直赛道或基础设施层避开正面战场。但Mistral的physics AI本周即遭Bezos的Prometheus($12B)正面狙击，差异化赛道也在迅速变红。

**6. 商业模式与估值张力凸显。** Mistral $400M ARR撑€20B估值(50倍PS)、豆包"日入不足百万"成梗、Meta"AI广告外零营收"——本周多个对象暴露"高估值/高投入 vs 实际变现"的张力，2026下半年商业化兑现能力将成为资本与市场的核心拷问。

---

## 🤖 赛道深度正文 · B 组｜垂直 Agent 产品 + 中国公司（12）

### 1. Anysphere（Cursor）

- **本周动态**：本周Anysphere爆出年度级别重磅事件——6月16日(周二)SpaceX宣布以**600亿美元全股票**方式收购Cursor母公司Anysphere，交易预计2026年Q3完成。这是本周B组最大新闻。SpaceX早在2026年4月就已锁定option：要么年内以600亿收购、要么支付100亿美元建立合作(背景，非本周)。本周正式行权全资收购。战略意图清晰：SpaceX旗下xAI需要补齐"AI写代码"这块短板——该领域已被Anthropic(Claude Code)和OpenAI(Codex)验证为强商业化场景。SpaceX将很快在Cursor上发布自有AI模型及xAI的编码agent"Grok Build"(双方已联合训练数月)。收购逻辑：Cursor坐拥**超100万开发者用户**、约**20亿美元年化营收(ARR)**，PitchBook分析师Harrison Rolfes点评"拥有专业开发者每天信赖的工具，是比赢得模型竞赛更快的通往企业AI营收的路径"。此前制约Cursor增长的是算力不足，而SpaceX作为数据中心持有者恰好能补上。除收购外，Cursor产品侧本周持续高频迭代：6月18日发布Cursor Automations改进(新增/automate技能、Slack emoji触发器、5个新GitHub触发器、computer use工具)；Bugbot现由Composer 2.5驱动，评审时间从~5分钟降至~90秒(快3倍+)、成本降22%、多发现10%bug(0.62 vs 0.56/次)；还发布了云环境一键setup(<10分钟)、/in-cloud云子agent、SDK自定义工具与嵌套子agent等。
- **关键数据**：
  - 收购对价 $60B 全股票 — Guardian 2026-06-16 / Reuters 2026-06-16 / Bloomingbit 2026-06-16
  - Cursor用户 >100万 — Guardian 2026-06-16；ARR ~$20亿 — Economic Times 2026-06-16
  - SpaceX市值一度$2.97万亿超亚马逊($2.65万亿)成全球第五，IPO首日(6/16)开盘涨13% — Guardian 2026-06-16
  - Bugbot评审~90秒(原~5分钟)、成本-22%、bug检出+10%(0.62/次) — cursor.com/changelog 2026-06
  - 交易Q3 2026完成，全股票不动用IPO募资 — Guardian 2026-06-16
- **原文链接**：
  - https://www.theguardian.com/science/2026/jun/16/spacex-ai-coding-anysphere-cursor-amazon-market-valuation-xai （已读全文）
  - https://cursor.com/changelog （已读全文，含06-18-26等多条dated entry）
- **影响判断**：这是AI编码赛道的结构性拐点——头部独立Agent产品被超大平台(SpaceX/xAI)全资吞并，标志"独立编码工具→巨头算力+模型闭环"的整合开始。Cursor用算力换增长、xAI用现成开发者入口换企业营收，双赢但也意味着中立第三方编码工具阵营进一步收缩(继Windsurf被Cognition收编后)。对Anthropic/OpenAI是直接竞争升级信号。

---

### 2. Cognition（Devin / Windsurf）

- **本周动态**：本周Cognition以产品迭代为主，无重大融资/收购级新闻。核心进展是Windsurf(已于6月2日正式更名Devin Desktop)的**3.2系列**于6月16日发布，重点强化Devin Local：①新增devin插件系统(企业预览、opt-in)用于扩展Devin Local；②子agent现可直接调用MCP工具；③团队可通过CLI权限作用域强制终端allow/deny列表。Agent/Editor模式新增Cmd+.快捷键切换。6月18日两次补丁修复MCP registry解析(兼容旧schema)及skill文件加载bug。产品定位日益清晰：Devin Desktop=有人监督的IDE界面(原Windsurf)，Devin Cloud=自主远程agent(原Devin)，二者通过Agent Client Protocol(ACP)打通，用Spaces共享Git worktree上下文。官网数据显示Devin Desktop已有**100万+用户、4000+企业客户**，免费提供"全球最快编码模型"SWE-1.6。另据devin.ai/desktop页面，**NVIDIA已加入Cognition的Devin Desktop多agent支持研究预览**(本周新增)。背景补充(非本周)：Cognition在5月27日完成**超10亿美元融资、估值260亿美元**，较2025年9月的102亿翻倍以上，由Lux Capital/General Catalyst/8VC领投。
- **关键数据**：
  - Windsurf 3.2系列 2026-06-16；补丁 2026-06-18 — releasebot.io/updates/windsurf
  - Devin Desktop 100万+用户、4000+企业客户、SWE-1.6 — devin.ai/desktop 2026-06
  - (背景)$1B融资/$26B估值 2026-05-27 — Economic Times / The AI Software Report；估值轨迹：$2B(2024.4)→$4B(2025.3)→$10.2B(2025.9)→$26B(2026.5) — newmarketpitch.com
- **原文链接**：
  - https://releasebot.io/updates/windsurf （已读全文，含3.2系列6/16、6/18补丁等dated entry）
  - https://devin.ai/desktop/ （已读全文）
- **影响判断**：Cognition本周延续"Windsurf→Devin Desktop"品牌整合后的产品打磨，NVIDIA加入多agent预览是值得关注的信号——芯片巨头入局编码agent生态，预示算力方与Agent工具方的深度绑定(与SpaceX收Cursor异曲同工)。Cascade将于7月1日EOL，迫使存量用户迁移至Devin Local，是一次有风险的强制升级。

---

### 3. Perplexity

- **本周动态**：本周Perplexity的主线新闻仍是**IPO时间表**——CEO Aravind Srinivas对CNBC重申公司计划**2028年上市**，且"无论Anthropic或OpenAI的IPO结果如何"都坚持该时点(注：CNBC原始报道为6月9日，属上周边缘；本周6/14-20多家媒体PYMNTS/QZ/The Daily Star转载跟进，发酵延续至本周)。公司发言人Shevelenko补充："通过始终将2028作为最早IPO日期，Perplexity得以构建健康、高增长的业务。"管理层有意释放"行业领袖"姿态，称"这些IPO成功对整个AI行业很重要"。本周Perplexity在产品/重大发布层面无确凿的本周内官方新动作被检索到(Comet浏览器等为更早发布)。需注意：IPO表态本质是预期管理而非本周实质事件，故Perplexity本周可归为"无重大产品级公开动态，仅有IPO口径的媒体发酵"。
- **关键数据**：
  - 计划2028年IPO(最早日期) — CNBC 2026-06-09(原始)/QZ 2026-06-09/PYMNTS 本周转载
  - 关键数字(估值/营收)本周未公开新增 — —
- **原文链接**：
  - https://qz.com/perplexity-ipo-2028-anthropic-openai-ceo-060926 （IPO口径来源）
- **影响判断**：在Anthropic/OpenAI据传备战IPO的大环境下，Perplexity反其道坚持2028、强调"可持续优先于速度"，是一种差异化的资本叙事——既给投资人耐心信号，也暗示其当前营收/盈利尚未到上市窗口。与同期发酵的内容出版商版权纠纷一并看，Perplexity正处在"增长vs合规"的张力期。

---

### 4. Harvey（Legal AI）

- **本周动态**：本周Harvey有两条实质动态。①**Token用量爆炸式增长公开**：CEO Winston Weinberg在6月16日(周二)发布的"Sourcery with Molly O'Shea"播客中披露，公司1月还是每月1万亿tokens，5月已飙至**每月12-13万亿tokens(约12倍增长)**，Harvey发言人向Business Insider确认该口径指5月。Weinberg直言"用量变得疯狂"，并提出深刻的"billable hours problem"洞察：企业很快会面临"我花了10亿美元买tokens，ROI在哪"的拷问；他主张"不要让前沿智能跑每一个任务，太贵了——控制权变更审查值得用，初稿摘要不值得"，预示按任务分级路由模型将成行业刚需。②**开源LAB(Legal Agent Benchmark)**：Harvey几周前开源了首个测量AI agent在真实法律任务上表现的基准(本周经Sourcery长文深度报道发酵)。背景(非本周)：Harvey 3月以110亿美元估值融资2亿(红杉/GIC联合领投)，累计融资超12亿美元，年化营收超2亿美元；近期还作为agent+插件登陆Microsoft 365 Copilot。
- **关键数据**：
  - Token用量：1月1T/月 → 5月12-13T/月(~12X) — Business Insider 2026-06-16(podcast)
  - (背景)估值$11B、3月融资$2亿、累计融资>$12亿、ARR>$2亿 — sourcery.vc/startupfortune 本周报道
  - LAB开源(首个真实法律任务agent基准) — sourcery.vc 2026-06-18
- **原文链接**：
  - https://www.businessinsider.com/harvey-ceo-ai-token-usage-2026-6 （已读全文）
- **影响判断**：Harvey的"token经济学"自白是本周应用层AI最重要的信号之一——它公开承认无节制烧token不可持续，billable hours类比直指"AI支出ROI核算"这一全行业即将撞上的墙。这与同期Coinbase/Uber"反tokenmaxxing"潮流共振，标志AI应用从"堆算力跑分"转向"按任务分级、成本可解释"的成熟期。Harvey开源LAB也是争夺法律AI评测话语权的卡位动作。

---

### 5. Sierra

- **本周动态**：本周Sierra无融资/收购级大新闻，以官方博客内容运营+品牌叙事为主。6月15日发布博文《How customer teams became agent builders》，核心论点："离客户最近的人最有上下文来改进体验，现在他们正成为构建agent的人"——延续Sierra"让业务团队而非工程师直接搭建客服agent"的产品哲学。6月12日发《Discovering what's possible with AI for CX》系列。再往前6月10日宣布通过**FedRAMP High认证**(美国联邦机构云服务最高标准，是打入政府市场的关键资质)；6月3日发表《Outcomemaxxing》提出"未来应用AI不以消耗量(consumption)衡量，而以达成的结果(outcomes)衡量"——这与同期Harvey的token反思形成有趣对照，是Sierra"按结果计费(outcome-based pricing)"商业模式的理论包装。背景(非本周)：Sierra 5月以**158亿美元估值融资9.5亿美元**(此前350M@$10B)，年化营收(ARR)超1.5亿美元，服务超40%的财富50强，按结果而非席位计费；CEO为前Salesforce联席CEO、现OpenAI董事长Bret Taylor。早前收购Fragment(法国YC)/Receptive AI(语音)/Opera Tech均为2026年3-4月(背景，非本周)。
- **关键数据**：
  - FedRAMP High认证 2026-06-10 — sierra.ai/blog
  - "Outcomemaxxing"理念 2026-06-03 — sierra.ai/blog
  - (背景)估值$15.8B、5月融资$950M、ARR>$150M、服务40%+财富50强 — voiceflow/developmentcorporate 本周报道
- **原文链接**：
  - https://sierra.ai/blog （已读全文，含6/15、6/12、6/10等dated entry）
- **影响判断**：Sierra本周虽无爆点，但FedRAMP High和"outcomemaxxing"两条线索揭示其战略纵深：一边用合规资质撬开政府/金融等高壁垒市场，一边用"按结果计费"理念占领定价话语权高地。在客服AI赛道(对手Decagon/Fin/Salesforce Fin)价格战白热化背景下，Sierra"纯结果计费+企业级合规"是差异化护城河，但"outcome定义可协商、转人工也可能触发计费"也埋下客户信任风险。

---

### 6. Glean

- **本周动态**：本周Glean有一条实质动态：6月16日通过BusinessWire发布《Glean Expands Financial Services MCP Ecosystem to Bring Trusted Market Intelligence Into Enterprise Context》——扩展面向金融服务业的MCP(Model Context Protocol)生态，将可信的市场情报接入企业上下文。这延续Glean"企业搜索→企业AI agent平台"的转型主线：Glean Assistant让每位员工拥有植根于公司数据(通过Glean Enterprise Graph)的AI助手，Glean Agents让团队用自然语言创建/管理AI agent。同日SiliconANGLE/theCUBE发布对Glean合作副总裁Zubin Irani的深度访谈(AWS Marketplace Series)，披露关键落地案例：某医疗客户用AI将每月处理RFP从~10个提升到~100个、单个处理时间从40小时压缩到2-3小时。Irani透露"有相当强的新版本即将发布"，强调行业正从"获取正确信息"转向"执行动作(doing)"。背景(非本周)：2月Glean曾扩展Glean Assistant能力(实时语音、品牌内容生成、agent沙箱等)；Forrester Q4 2025报告指出Glean连接器生态较窄、深层上下文信号富集能力相对有限是其短板。
- **关键数据**：
  - 金融服务MCP生态扩展 2026-06-16 — BusinessWire(标题已确认，正文403)/SiliconANGLE 2026-06-16
  - 医疗客户RFP案例：10→100个/月、40h→2-3h、win rate~10% — SiliconANGLE 2026-06-16
  - 基于AWS Bedrock、AWS Marketplace分发 — SiliconANGLE 2026-06-16
- **原文链接**：
  - https://siliconangle.com/2026/06/16/glean-enterprise-data-ai-value-awsmarketplaceseries/ （已读全文）
- **影响判断**：Glean本周动作聚焦"垂直行业MCP生态+从搜索到执行"，金融服务MCP扩展是其向高价值垂直场景纵深的关键一步。MCP作为连接企业数据与agent的标准协议，Glean抢先在金融领域建生态，是争夺"企业AI数据层"话语权的卡位。但其连接器生态偏窄的短板若不补齐，面对Dust等"agent优先"对手可能在"执行动作"维度落后。

---

### 7. Midjourney（v7）

- **本周动态**：本周Midjourney发生重要版本演进——官方updates页面发布**《Draft mode for V8.1 and new feature previews》**，标志Midjourney主力已从v7迭代至**V8.1**(v7now为背景旧版)。两大更新：①**Draft mode(草稿模式)**：每次生成**24张**低分辨率/低质量图片，对满意的点"Vary"再渲染全质量全分辨率；草稿任务仅消耗V8.1标准任务一半的fast hours(尽管出24张！)；点菜单栏⚡按钮开启。②**--preview参数**：新机制允许用户在prompt中加--preview测试最新模型早期版本(可能不够polished、不保证长期稳定运行)，首次测试中个性化(personalization)和moodboards差异明显。此外本周多家媒体(explainx.ai 6/18)报道Midjourney即将发布**首款硬件**——指向架构可视化、空间设计、现场演出、城市公共空间等"屏幕作为妥协容器"的场景，若硬件成立将把创意AI拉向当前browser-and-API模式无法跟随的方向。
- **关键数据**：
  - V8.1 Draft mode：单次24张、消耗减半fast hours — updates.midjourney.com 2026-06(本周)
  - --preview早期模型测试参数 — updates.midjourney.com 2026-06(本周)
  - 首款硬件预热(未发布) — explainx.ai 2026-06-18
- **原文链接**：
  - https://updates.midjourney.com/draft-mode-for-v8-1-and-new-feature-previews/ （已读全文）
- **影响判断**：Midjourney本周两个动作信号清晰：①Draft mode + 减半算力消耗，是用"快速批量试错(24张/次)"重构创作工作流，降低探索成本、绑定用户习惯；②--preview开放早期模型测试，是把社区变成模型迭代的众测引擎，强化其Discord社区飞轮。硬件预热则暴露Midjourney不甘于做"API供应商"、欲掌控创意AI的物理呈现入口的野心——这是与纯软件生图对手(SD/DALL-E)拉开身位的差异化赌注。

---

### 9. 智谱（GLM / 清言）

- **本周动态**：本周智谱是B组中国公司里最大爆点——6月13日17:21宣布新一代旗舰模型**GLM-5.2**面向GLM Coding Plan全量用户开放(覆盖Lite/Pro/Max及团队版)，6月17日正式上线并按**MIT协议全量开源**(权重上Hugging Face与ModelScope，API上BigModel与Z.ai)。技术亮点：①专为长程任务打造，**1M无损上下文**；②强化Coding能力——在百万用户盲测的前端开发评估系统**Code Arena上取得"全球可用模型第一"**；③在FrontierSWE、Terminal-Bench等权威评测中与海外头部Claude Opus 4.8差距收窄至**1%-4%**，是排名最高的开源模型(FrontierSWE仅比Opus 4.8低1%、超过GPT-5.5；Terminal-Bench 2.1得分81.0，较前代GLM-5.1的63.5大涨17.5个百分点)；④Day 0适配华为昇腾、平头哥、摩尔线程、寒武纪、昆仑芯、沐曦、海光、壁仞等**8款国产算力平台**。同步配套**ZCode 3.0**编程工具全面切换自研Agent内核。时机极敏感：6月12日Anthropic应美政府出口管制令对所有非美籍用户紧急下线Claude Fable 5和Mythos 5两款旗舰，智谱选在6月13日17:21开放GLM-5.2，被解读为"借竞品停服恐慌抢开发者忠诚度"。资本面：6月17日科创板IPO辅导状态变更为"辅导验收"，从6月6日备案到验收仅11天(辅导券商国泰海通)；股价方面智谱(02513.HK)5日涨44%、较IPO发行价116.2港元涨超1200%，市值超6850亿港元。
- **关键数据**：
  - GLM-5.2：1M无损上下文、MIT开源、Day0适配8款国产芯片 — 东方财富/澎湃 2026-06-17
  - Code Arena全球可用模型第一；FrontierSWE比Opus 4.8低1%、超GPT-5.5；Terminal-Bench 2.1得81.0(前代63.5) — 东方财富 2026-06-17
  - 科创板IPO辅导11天进入验收(6/6备案→6/17验收) — 福布斯中国 2026-06-17
  - 股价5日涨44%、较发行价涨1200%、市值>6850亿港元 — 东方财富 2026-06-17
- **原文链接**：
  - https://finance.eastmoney.com/a/202606173774299794.html （已读全文，澎湃新闻源）
- **影响判断**：GLM-5.2是本周全球开源模型最重磅发布，三重意义：①技术上把开源模型与闭源旗舰(Opus 4.8)差距压到1-4%，刷新国产开源天花板；②战略上"开源+MIT+国产芯片Day0适配"打"自主可控"牌，精准卡位Anthropic被美政府强制断供的窗口期，是地缘技术博弈下的教科书级借势；③资本上以技术确定性对冲IPO/解禁敏感期的不确定性。智谱已成为今年中国AI应用股标杆，GLM-5.2是其"技术-商业-资本"三线协同的关键落子。

---

### 8. 阿里云（Qwen / 夸克AI）

- **本周动态**：本周阿里有两条重磅本周动态。①**首个具身智能大模型Qwen-Robot系列发布(6月16日)**：通义实验室推出千问家族首个完整具身智能模型系列，含三大模型——VLA操作模型**Qwen-RobotManip**(规范状态-动作空间+相机坐标系末端执行器增量位姿，基于完全由开源数据构建的**>38,100小时**语料库做大规模多机型训练，兼容单臂/双臂/灵巧手/移动平台等**15个机器人本体**)、VLN移动模型**Qwen-RobotNav**(统一指令跟随、点/目标导航、目标追踪、自动驾驶等任务)、世界模型**Qwen-RobotWorld**(自然语言动作接口预测符合物理规律的未来状态，跨操作/驾驶/导航场景)。三模型"为机器人装上灵巧的手、认路的脚、会思考的大脑"，可单独部署也可协同运转，且均提供语言优先接口、可被通用Qwen模型作为物理世界工具动态调用。这标志阿里从"聊天机器人"向"物理世界AI(Physical AI)"的战略转向。②**高考志愿填报Agent(6月10日上线)**：千问推出覆盖查分→选校→填报→录取跟进全周期服务，面向1290万高考群体免费开放。千问事业群总裁吴嘉定调"高考是AI办事这条路的自然延伸、Agent能力的阶段性跨越——在高压、低容错率场景跑通，后续延伸到更多复杂决策场景就有了基础"。6月初千问App已宣布向第三方Agent和Skill开放，瑞幸/肯德基/蜜雪冰城/东方航空首批测试。背景(非本周)：5月20日发布Qwen3.7-Max，Arena盲测总榜国产第一、超Kimi-K2.6/DeepSeek-v4-pro/GLM-5.1。
- **关键数据**：
  - Qwen-Robot三模型(Manip/Nav/World)，Manip训练语料>38,100小时、兼容15个本体 — IT之家 2026-06-16
  - 高考Agent全周期服务、高考群体1290万、九成有需求、2025填报市场付费规模10.9亿(预计2027达12.2亿) — 新浪/每经 2026-06-16
  - (背景)Qwen3.7-Max Arena国产第一 — IT之家 2026-05-20
- **原文链接**：
  - https://www.ithome.com/0/964/748.htm （已读全文，Qwen-Robot）
  - https://news.sina.com.cn/c/2026-06-16/doc-inicprne6423461.shtml （已读全文，高考Agent）
- **影响判断**：阿里本周两线并进，信号清晰：①Qwen-Robot是阿里押注"具身智能/Physical AI"的战略级落子——用"语言优先接口+可被通用Qwen调用"的设计，把机器人能力变成大模型的"物理世界工具"，是国产厂商在具身智能商业化临界点的卡位；②高考Agent是阿里验证"从会聊天到能办事"Agent落地能力的高压试验场，本质是争夺AI时代用户入口与教育长周期数据。两者共同指向阿里"通用大模型→Agent→具身/物理世界"的能力外延逻辑。

---

### 10. 月之暗面（Kimi K2）

- **本周动态**：本周月之暗面动作密集。①**Kimi K2.7 Code编程大模型发布并开源(6月12日)**：这是Kimi迄今最智能的编程模型，架构沿用K2.6的MoE设计——总参数**1T(1万亿)**、激活参数**32B**、384个专家每次选8个+1个共享专家、上下文长度**256K**。相比K2.6显著提升长上下文编程指令遵循能力(Kimi Code Bench v2提升21.8%)、长程编程任务性能，并通过"过度思考抑制"技术大幅改善长程任务中的过度思考倾向，**平均token消耗减少30%**；支持文本/图片/视频多模态输入、思考模式、对话与Agent任务。②**Kimi K2.7 Code高速版上线(6月15日)**：与普通版同模型，输出速度约为普通版的**5-6倍**，常规编程场景约**180 Tokens/s**、短上下文场景可达**260 Tokens/s**；价格为普通版2倍——1M tokens标准输入/输出分别13元/54元，命中缓存输入2.6元；向Kimi Code Beta成员、API开发者、Business用户开放。
- **关键数据**：
  - K2.7 Code：1T总参/32B激活/384选8专家/256K上下文，token消耗-30%，Code Bench v2 +21.8% — 新浪/IT之家 2026-06-15，搜狐 2026-06-12
  - 高速版：5-6倍速、180 Tokens/s(常规)、260 Tokens/s(短上下文)、价格2倍(13元/54元per 1M) — 新浪科技 2026-06-15
  - 发布日 2026-06-12，高速版 2026-06-15 — IT之家
- **原文链接**：
  - https://finance.sina.com.cn/tech/digi/2026-06-15/doc-inicpewk6604233.shtml （已读全文）
- **影响判断**：Kimi K2.7 Code与同期智谱GLM-5.2形成"国产开源编程模型双发"格局(均6月中旬、均1M级长上下文/编程导向)，标志中国大模型公司集体押注"编程Agent"这一最具商业化确定性的场景。月之暗面的差异化打法是"token消耗-30%+高速版"——既降推理成本又给延迟敏感场景溢价选项，是在算力受限下务实的工程化路线。1T参数MoE开源也持续抬高国产开源模型规模上限。

---

### 11. MiniMax（海螺 / abab）

- **本周动态**：本周MiniMax核心动态是**视频模型Hailuo(海螺)2.3发布 + Media Agent升级**(官网News，发布于本周6月20日前后)。Hailuo 2.3在Hailuo 02基础上升级动态表现力：①肢体动作更复杂流畅、精确度与可控性更好；②大动态运镜下光线方向、明暗过渡、色调近乎实拍；③风格化增强(动漫/插画/水墨/游戏CG等特殊画风支持更佳)；④人物微表情与物体运动指令响应提升。商业策略亮眼——"再次刷新全球视频模型效果成本纪录"，保持Hailuo 02既有价格"加量不加价"，并提供**Hailuo 2.3 Fast**(生成更快、定价更低，批量创作最高降本**50%**)；发布期间每日提供免费试用额度。同时**Hailuo Video Agent正式升级为全模态Media Agent**(全球同步上线)：自动匹配多模态模型、"一键成片"、支持上传图片/视频/音频自由定制，后续版本将实现"对话即创作"。资本面背景(非本周)：5月29-31日MiniMax与中信证券签A股IPO辅导协议、董事会决议拟发行人民币股份登陆科创板("A+H"平台)；6月1日发布新模型M3(编程/智能体能力提升)但同日把计费从"按次调用"改"按token消耗"且取消低价套餐引发争议；港股(0100.HK)经历较大波动、面临7月解禁压力。
- **关键数据**：
  - Hailuo 2.3发布、保持Hailuo 02价格"加量不加价"、Fast版批量降本最高50% — minimaxi.com/news 2026-06(本周)
  - Media Agent全球上线、一键成片、全模态 — minimaxi.com/news 2026-06(本周)
  - (背景)5/29签A股IPO辅导、6/1 M3模型+计费改按token — thepaper/ofweek/gplp 本周报道
- **原文链接**：
  - https://www.minimaxi.com/news/minimax-hailuo-23 （已读全文）
- **影响判断**：MiniMax本周以视频模型守住核心优势——Hailuo系列是其全球化最强抓手，"刷新效果成本纪录+加量不加价+Fast降本50%"直击全球创作者性价比痛点，是在算力受限下用工程效率换市场份额的典型打法。Media Agent从"视频Agent"升级为"全模态Media Agent"，押注"对话即创作"的下一代内容生产范式。但资本面(半年内港股募完又冲A股、计费争议、解禁压力)暴露其对资金的强渴求，技术叙事与资本焦虑并存。

---

### 12. 腾讯（混元 / 元宝）

- **本周动态**：本周腾讯有两条实质本周动态。①**元宝接入ima知识库(6月15日)**：腾讯AI助手"元宝"正式接入ima知识库，AI搜索从"通用问答"迈入"专业深水区"。ima知识号已覆盖金融、法律、医疗、教育等**20余个行业**、海量专业文件，内容被引用**超1.4亿次**。打通后用户搜索可直接调用ima公开知识库，获得更精准、可溯源回答(点信源引用卡片跳转ima原文、一键加入个人知识库)。战略上这是腾讯"全域高质量信源"布局的关键一环——此前元宝已接入微信公众号、腾讯新闻、同程旅行等，ima补齐"硬核专业文献"拼图。更重要的是ima采用"一次沉淀、多端调用"架构，除元宝外已接入workbuddy、QClaw等多款产品，成为腾讯生态内各Agent产品可随时调用的"知识上下文"。②**混元团队联合Robotics X开源具身智能模型HyVLA-0.5(6月15日)**：腾讯Robotics X、福田实验室与混元团队联合发布面向真实世界机器人操作的端到端具身智能模型Hy-Embodied-0.5-VLA(简称HyVLA-0.5)，基于自研亚毫米级高精度指套式UMI数据采集软硬件+真机强化学习。背景(非本周)：混元80B总参/13B激活的混合推理模型(2025年6月)；混元3D 2.1、HunyuanVideo-1.5等开源系列。
- **关键数据**：
  - 元宝接入ima：覆盖20+行业、内容引用超1.4亿次、多端(workbuddy/QClaw)调用 — 网易/163 2026-06-15
  - HyVLA-0.5端到端具身VLA模型、亚毫米级UMI数据采集、真机强化 — 网易/163 2026-06-15
  - 发布日均 2026-06-15
- **原文链接**：
  - https://www.163.com/dy/article/KVFRBF1A051100B9.html （已读全文，元宝接入ima）
- **影响判断**：腾讯本周策略"务实且犀利"——不迷信参数规模，而死磕应用场景与数据壁垒。①元宝+ima揭示腾讯AI搜索护城河逻辑：在算力算法趋同阶段，独家优质语料库才是真壁垒，"一次沉淀多端调用"的液态数据架构是腾讯生态协同的底层杀招；②HyVLA-0.5则显示腾讯在具身智能上与阿里Qwen-Robot同周正面竞争(均6月中旬具身模型)，且走"自研数据采集硬件+真机强化"的硬核路线。腾讯打法的精髓是把庞大内容/产品生态转化为AI竞争的结构性优势。

---

## 📊 本组洞察（B组：垂直Agent产品 + 中国公司）

**1. 编码Agent成为全球与中国共同的"主战场"，整合与开源两路并进。**
本周最密集的动态全部指向AI编码：海外侧SpaceX以600亿美元全资收购Cursor、xAI将推Grok Build，标志"独立编码工具被巨头算力+模型闭环吞并"的整合拐点(继Cognition收编Windsurf后又一例)；中国侧智谱GLM-5.2与月之暗面Kimi K2.7 Code同周(6/12-17)开源1M级长上下文编程模型，GLM-5.2更把与Claude Opus 4.8差距压到1-4%。两条路线——海外靠资本整合、中国靠开源突围——共同确认"编程"是当前AI最具商业化确定性的场景。

**2. "Token经济学"反思全面爆发，行业从"tokenmaxxing"转向"outcomemaxxing"。**
Harvey CEO自白token用量5个月暴涨12倍(1T→12T/月)并抛出"我花了10亿美元买token，ROI在哪"的billable hours拷问；Sierra同步提出"outcomemaxxing"(以结果而非消耗衡量)理论；月之暗面K2.7 Code主打"token消耗-30%"；MiniMax Hailuo 2.3"加量不加价"+Fast降本50%。这是应用层AI集体撞上"成本可解释性"墙的信号——成熟期标志是"按任务分级路由模型、为延迟/质量差异化定价"。

**3. 具身智能(Physical AI)成为中国大厂同期卡位的新战场。**
6月16日阿里发首个具身大模型Qwen-Robot系列(Manip/Nav/World三模型、>38,100小时语料、兼容15个本体)，6月15日腾讯Robotics X+混元开源HyVLA-0.5(自研UMI硬件+真机强化)。两大厂同周押注具身智能，且都采用"语言模型作为物理世界工具/底座"的范式，标志中国AI从"数字世界"向"物理世界"外延的战略转向，正处商业化临界点的集体卡位。

**4. 地缘技术博弈直接重塑竞争节奏——开放度成为对冲不确定性的武器。**
6月12日Anthropic应美政府出口管制令对所有非美籍用户紧急下线Claude Fable 5/Mythos 5两款旗舰，智谱次日17:21开放GLM-5.2、按MIT全量开源并Day0适配8款国产芯片，精准卡位竞品停服恐慌窗口。"开源+自主可控"既是技术路线，也是地缘博弈下中国公司争夺开发者忠诚度、对冲资本不确定性(智谱/MiniMax均冲科创板IPO)的战略武器。

**5. "数据/内容生态壁垒"成为算力算法趋同后的真护城河。**
腾讯元宝+ima(20+行业、1.4亿次引用、多端调用)、Glean金融服务MCP生态、阿里高考Agent沉淀教育数据，三者共同揭示：当模型能力趋同，独家优质语料库+生态协同才是差异化壁垒。"一次沉淀、多端调用"的数据液态流动架构(腾讯)与"垂直行业MCP生态"(Glean)是两种典型打法。

**6. 资本市场与技术发布深度耦合，IPO敏感期成密集发布催化剂。**
智谱(科创板辅导11天进验收、股价较发行价涨1200%)、MiniMax(半年内港股募完又冲A股、计费争议)、Perplexity(坚持2028 IPO)、SpaceX(IPO首日市值超亚马逊后火速收购Cursor)——本周资本动作与技术发布高度同频，印证"用技术确定性对冲资本不确定性"已成大模型公司的标准操作。

---

*报告完成时间：2026-06-21 | 研究员：黄山 | 数据截止：2026-06-20*

---

## 🛠️ 赛道深度正文 · C 组｜Agent 框架工具 + 其他参与者（10）

### 1. OpenClaw（Agent OS）
- 本周动态：本周是 OpenClaw 的高频迭代周。GitHub 官方 release 页显示 **v2026.6.8** 在本周内发布（窗口内主版本），并在 6-21 紧接推出 **v2026.6.9**（窗口边缘）。据第三方技术博客（efficient coder / xugj520）拆解，**2026.6.8 合并了 160+ PR、240+ 直接 commit**，是一次"地基加固型"而非"功能爆炸型"版本，主线三块：①**消息富文本化**——Telegram / WhatsApp 渠道不再发送单调纯文本，开始支持表格、项目符号列表、可展开引用块（expandable blockquote），并修复换行/缩进保留问题（诗歌、代码块、格式化文本在聊天中正确呈现）；底层投递逻辑加固，降低网络波动/平台限流导致的失败。②**Agent 执行鲁棒性**——修复多步任务中 DM 投递到错误会话的问题；媒体生成（图片/音频）中途失速/失败减少；**子任务 abort 信号检测**（主任务被用户打断时子任务正确停止，避免算力浪费）；会话历史不一致时自动回退恢复。③**恢复链路**——retries / terminal outcomes / compaction 后 usage 统计 / session history repair / reply reconciliation，让中断或部分完成的 turn 更可靠地推进到可见的最终结果。官方 6-21 release highlights 还提到 Codex App Server 启动/恢复硬化、managed plugin 更新修复。技术路线判断：OpenClaw 走的是"个人 AI 助理 OS + 全渠道接入"路线（支持 WhatsApp/Telegram/Slack/Discord/飞书/微信/QQ 等十余渠道），本周迭代重心从"加功能"转向"可靠投递 + 中断恢复"，这是产品从 demo 走向日常生产可用的典型信号。
- 关键数据：GitHub Stars **379,678**、Forks 79,484（api.github.com，2026-06-21）；latest release **v2026.6.9**，published 2026-06-21T01:44Z（api.github.com）；2026.6.8 含 160+ PR / 240+ commit（xugj520.cn，4 days ago≈6-17）
- 原文链接：https://github.com/openclaw/openclaw/releases ；https://www.xugj520.cn/en/archives/openclaw-2026-6-8-release-updates.html ；https://api.github.com/repos/openclaw/openclaw
- 影响判断：38万 Stars 量级使其成为开源 Agent OS 赛道头部之一。本周"消息富文本+中断恢复"是把 Agent 从"能跑"推向"能托付日常任务"的关键工程拐点——可靠性而非智能上限，正成为 Agent 落地的真实瓶颈。

---

### 2. Dify
- 本周动态：**本周无窗口内正式 release**。GitHub releases/latest 仍停在 **v1.14.2**（published 2026-05-19，窗口外），tags 列表最新为 **2.0.0-beta.2 / 2.0.0-beta.1**（2.0 大版本进行中，beta 阶段）。v1.14.2 为补丁版（背景，非本周）：聚焦安全加固（租户隔离 app trace-config / FilePreview 文本提取、工具凭证仅限 workspace admin/owner）、工作流可靠性（HITL workflow resume 后恢复 tracing、减少 message-update 数据库往返）、RAG/知识库稳定性（允许 LLM 节点访问检索到的知识文件、修复 pipeline 模板渲染）。本周代码仓仍活跃（pushed_at 2026-06-21），说明 2.0 开发在持续推进，但未对外发正式版本。技术路线判断：Dify 定位"production-ready agentic workflow 开发平台"，正处于 1.x→2.0 的架构换代窗口期，beta 多次迭代表明 2.0 引入较大改动（agent 能力、workflow 引擎重构），团队选择 beta 充分验证而非仓促 GA，符合企业级平台的稳健策略。
- 关键数据：GitHub Stars **145,973**、Forks 22,956（api.github.com，2026-06-21）；latest stable v1.14.2（2026-05-19）；最新 tag 2.0.0-beta.2（GitHub tags API）
- 原文链接：https://github.com/langgenius/dify/releases ；https://api.github.com/repos/langgenius/dify
- 影响判断：14.6万 Stars 的低代码 Agent 平台头部。本周静默但 2.0 beta 推进，是"大版本换代前的蓄力期"信号；下个窗口若 2.0 GA 将是 C 组重点观察点。

---

### 3. Hermes Agent（自进化，增长最快）
- 本周动态：Nous Research 于 **6-19 发布 Hermes Agent v0.17.0（内部版本号 v2026.6.19），代号"The Reach Release"**——这是窗口内一次重磅大版本。官方 release note 量级惊人：自 v0.16.0 起 **~1,475 commits、~800 merged PR、1,693 文件变更、235,390 行新增、50,730 行删除、300+ issue 关闭、245 名社区贡献者**。主线"扩大触达半径"：①**新增 iMessage 渠道**——基于 Photon Spectrum 托管线路池，`hermes photon login` 设备码认证即可收发 iMessage，**无需 Mac 中继、无需 BlueBubbles 桥接**，明确定位为 BlueBubbles 的继任者（免费起步、零自托管）；②**接入 Raft agent 网络**——作为外部 agent 通过 wake-channel bridge 接入 raft.build，隐私按合约设计（wake payload 仅携带 event ID/时间戳等元数据，绝不含消息正文）；③**桌面应用大幅增强**——可重绑快捷键、原生 OS 通知（按类型开关）、子agent 实时 watch-window（把委派 agent 的活动流式进独立窗格）、composer 模型选择器；④**后台子agent**、图像生成支持编辑、Cursor Composer 模型可通过 xAI Grok 订阅接入；⑤dashboard 全新 profile builder + 安全登录、Skills Hub 浏览器重构、memory 工具大升级、curator 不再对每次例行运行消耗 aux-model 预算（省成本）。技术路线判断：Hermes 走"自进化个人 AI 员工"路线（持久记忆+自主技能创建），姊妹项目 hermes-agent-self-evolution（ICLR 2026 Oral, MIT）用 DSPy+GEPA 针对 benchmark 优化技能/prompt/agent 自身代码。本周重心是"渠道扩张+桌面深化+成本优化"，从能力扩张转向触达面与可运营性。
- 关键数据：GitHub Stars **198,344**、Forks 35,180（api.github.com，2026-06-21）；v0.17.0 自上版 ~1,475 commits/~800 PR/235k 行新增（GitHub release，2026-06-19）；支持 400+ 模型via Nous Portal（ai.cc，背景）
- 原文链接：https://github.com/NousResearch/hermes-agent/releases/tag/v2026.6.19 ；https://blogs.nvidia.com/blog/rtx-ai-garage-hermes-agent-dgx-spark/
- 影响判断：19.8万 Stars + 245 贡献者的单版本贡献规模，印证其"增长最快"标签。本周 iMessage/Raft 渠道扩张是把"个人 AI 员工"从极客圈推向普通用户的关键一步——渠道即分发，Hermes 正用渠道覆盖正面对标 OpenClaw。

---

### 4. Claude Code
- 本周动态：本周 Claude Code 有重磅产品发布 + 高频版本迭代。①**Artifacts for Claude Code（6-18 发布，面向 Claude Team & Enterprise 计划）**——把 Claude Code 会话工作转成"实时、可交互、可分享的自定义 HTML 网页"。用户可接入实时代码与多数据源，生成一个可发给队友的交互 URL（仪表盘/应用设计/内部工具）；网页在 agent 自主或受控工作时**原地实时刷新**（图表与文本即时更新于同一 URL），每次更新发布新版本历史，队友可回滚或追踪 agent 进度（桌面/移动端）。VentureBeat 评其为"动态翻译层"——工程师无需再外接数据源或临时基础设施，AI 直接用现有 repo/监控工具/对话推理生成专用网页。文中点明这是对 **OpenAI 两周前 Codex "Sites" 功能的对位回应**：OpenAI 走 PaaS（生成可持久的全栈 web 应用，输出 Cloudflare Worker 兼容 ES 模块），Anthropic 走"无状态画布"（stateless canvas）。②**CLI 高频迭代**：changelog 显示 v2.1.183（6-19）、v2.1.185（6-20）窗口内连发。v2.1.183 强化 auto 模式安全——破坏性 git 命令（`git reset --hard`、`git checkout -- .`、`git clean -fd`、`git stash drop`）在用户未要求时被阻断，`git commit --amend` 在非本会话 agent 提交时阻断，`terraform/pulumi/cdk destroy` 除非指定 stack 否则阻断；新增模型弃用警告、attribution.sessionUrl 设置、修复 subagent WebSearch 返回空、修复仅返回 thinking block 时静默完成的问题（现会重新 prompt 一次）。③传闻中的 **ultracode** 设置（effort 菜单，xhigh effort + Claude 自动决定何时用 workflow）。技术路线判断：Claude Code 正从"终端编码 agent"向"团队协作工作面"扩张，Artifacts 直击"工程师与非技术 stakeholder 之间的鸿沟"。
- 关键数据：Artifacts 发布 2026-06-18（VentureBeat / claude.com/blog/artifacts-in-claude-code）；CLI v2.1.185（2026-06-20）、v2.1.183（2026-06-19）（code.claude.com changelog）
- 原文链接：https://venturebeat.com/data/anthropics-claude-code-artifacts-update-brings-live-shared-dashboards-and-interactive-workspaces-to-enterprises ；https://code.claude.com/docs/en/changelog
- 影响判断：Artifacts vs Codex Sites 是 Anthropic 与 OpenAI 在"企业 AI 工作面"赛道的正面对决拐点。编码 agent 的竞争已从"代码质量"上移到"如何把 agent 产出呈现给整个组织"——谁掌握工作面，谁掌握企业入口。

---

### 5. Codex CLI（SWE-bench #1）
- 本周动态：OpenAI Codex CLI 本周保持极高发布频率。GitHub releases 显示窗口内稳定版 **rust-v0.141.0（6-18 04:43）** 发布，随后 6-19 当天连发 4 个 pre-release（0.142.0-alpha.4/5/6，及 6-20 的 alpha.7），日更节奏罕见。rust-v0.141.0 New Features 主线在"远程执行 + 插件生态"：①**远程执行器改用经认证的端到端加密 Noise relay 通道**（#26242/#26245）；②**跨平台远程执行保留执行器原生工作目录与 shell**，含跨 app-server/exec-server 边界的文件系统权限路径（多 PR）；③**选定执行器插件可按线程激活其 stdio MCP server**，插件发现新增"created-by-me marketplace"与按 auth 定制的精选目录（plugin discovery 生态化）；④app-server 客户端可列出直接子线程、关联外部 agent 导入结果、读取/兑换 rate-limit reset credits；⑤Realtime 客户端可显式追加语音、控制 Codex 响应如何进入对话；⑥TUI 输入提示可在静默后自动解析（带可暂停倒计时）。结合上周 Codex "Sites"（企业级 web 应用托管）发布，本周补的是底层执行基建（加密远程执行、插件市场）。技术路线判断：Codex 走"远程/沙箱执行 + MCP 插件市场 + 企业托管"全栈路线，SWE-bench #1 的实力正被转化为产品化纵深——从"会写代码"到"安全地远程跑代码并托管产物"。
- 关键数据：GitHub Stars **92,334**（api.github.com，2026-06-21）；stable rust-v0.141.0 published 2026-06-18T04:43Z；pre-release 0.142.0-alpha.7 (2026-06-20)（GitHub releases）
- 原文链接：https://github.com/openai/codex/releases
- 影响判断：日更级发布节奏 + 加密远程执行 + 插件市场，显示 OpenAI 在编码 agent 上投入极重。"Noise 加密 relay + 跨平台远程执行"是把 agent 推向企业生产环境的安全基建拐点，与 Claude Code 形成基建（OpenAI）vs 工作面（Anthropic）的差异化竞争。

---

### 6. Google ADK（Agent Development Kit）
- 本周动态：Google ADK-Python 于 **6-18 发布 v2.3.0**（内部 commit 标 2026-06-17，窗口内）。这是一次 feature 密集的版本，主线围绕"企业化 + 多模型 + 沙箱集成"：①**核心迁移到 enterprise parameters**（core 与 CLI 全面企业参数化）；②**AgentRegistry client 新增 mTLS 支持**（双向 TLS，企业安全）；③**GCS first-party toolset** 接入 ADK 集成；④**E2BEnvironment**——为远程沙箱工作区新增集成（远程代码执行环境）；⑤**Gemma4 在 Gemini 中获支持**、Gemini Live 3.1 模型的输入转录差异化处理（live 多模态）；⑥**GEPARootAgentOptimizer**（GEPA 优化器，与 Hermes 自进化项目同源的 GEPA 技术）；⑦ContextCacheConfig 新增 create_http_options（缓存创建超时）、load_web_page 加请求超时、adk run CLI 加 log_level；⑧labs 实验性 **Antigravity SDK agent wrapper**；⑨GCPSkillRegistry 中 Vertex AI 客户端惰性初始化。技术路线判断：ADK 走"代码优先（code-first）的企业级 agent 开发与部署"路线，本周 v2.3.0 大量企业特性（mTLS、enterprise parameters、GCS toolset、E2B 沙箱）显示 Google 在把 ADK 定位为 Vertex AI 生态的企业 agent 标准框架，同时通过 Gemma4/Gemini Live 3.1 绑定自家模型，GEPA 优化器引入则跟进 agent 自优化前沿。
- 关键数据：GitHub Stars **20,200**、Forks 3,600（api.github.com，2026-06-21）；v2.3.0 published 2026-06-18T18:45Z（commit date 2026-06-17）（GitHub releases）
- 原文链接：https://github.com/google/adk-python/releases/tag/v2.3.0 ；https://api.github.com/repos/google/adk-python
- 影响判断：2万 Stars 相对 OpenClaw/Hermes 量级较小，但背靠 Google/Vertex AI 生态，企业市场分量重。v2.3.0 的 mTLS+E2B 沙箱+企业参数化，是 ADK 向"受监管企业生产环境"靠拢的明确信号，与 LangGraph/Dify 争夺企业 agent 平台标准。

---

### 7. OpenCode
- 本周动态：OpenCode（开源终端编码 agent，repo 已迁至 **anomalyco/opencode**，sst/opencode 重定向至此）本周保持高频小步快跑，窗口内连发多个 patch：**v1.17.5（6-13）、v1.17.6（6-13）、v1.17.7（6-14）、v1.17.8（6-17）**，6-21 续发 v1.17.9。以 v1.17.8 为例，主线在 **MCP（Model Context Protocol）生态完善与稳定性**：①OpenAI 兼容 provider 现接受此前校验失败的 MCP tool schema；②无声明 schema properties 的 MCP 工具现可用于期待 object properties 的 provider；③长时运行 MCP 工具在报告进度时保持 timeout 存活；④MCP OAuth 回调 server 在授权完成/取消后正确关闭；⑤MCP 工具失败现暴露 server 原始错误文本而非通用失败；⑥Cloudflare AI Gateway 正确接收配置的 API key。桌面端新增 Home tab 切换、更快的文件/文件夹选择器；session timeline 加载更快无闪烁。技术路线判断：OpenCode 走"开源、provider 中立、终端优先"路线（README 支持十余种语言，社区驱动），本周几乎全部精力投入 MCP 互操作性与 provider 兼容性——这是开源工具对抗 Claude Code/Codex 闭源生态的核心策略：用开放标准（MCP）和多 provider 支持换取生态位。
- 关键数据：GitHub Stars **176,677**、Forks 21,533（api.github.com anomalyco/opencode，2026-06-21）；窗口内 release v1.17.5~v1.17.8（2026-06-13~06-17）（GitHub releases）
- 原文链接：https://github.com/anomalyco/opencode/releases/tag/v1.17.8 ；https://github.com/anomalyco/opencode
- 影响判断：17.6万 Stars 使其成为开源编码 agent 头部（远超已归档的旧 opencode-ai/opencode 13k）。本周聚焦 MCP 兼容性，押注"开放标准 + provider 中立"对抗闭源巨头——MCP 正成为编码 agent 互操作的事实标准，OpenCode 是这一趋势的关键受益者与推动者。

---

### 8. Scale AI（SEAL）
- 本周动态：本周 Scale AI 无新产品/SEAL 榜单发布，但围绕"Meta $14.3B 入股一周年"出现重要复盘报道。Forbes（6-16）刊文《Why Meta Paid $14.3B For Scale AI And Alexandr Wang's Data Empire》深度复盘：Meta 一年前以 **$14.3B 收购 Scale AI 49% 股权**（无投票权），并将创始人 **Alexandr Wang** 招入新设的 Superintelligence Lab 领军。文章核心观点犀利："这 $14.3B 买的不是模型，而是 AI 经济中资本无法制造的稀缺资源——高质量训练数据"；尽管市场普遍视该交易为"失败"（Meta 股价下跌、内部士气低落、AI 部门被戏称'gulag/古拉格'），Forbes 认为 Scale 实则在"安静地经营着科技业最赚钱的应用 AI 业务"。同期 TechCrunch（6-12）报道 Meta AI 部门"灵魂被碾碎的古拉格"、应用 AI 团队濒临反抗（援引 Wired）。Scale 的 SEAL（Safety, Evaluation and Alignment Lab）作为其评估榜单品牌本周无新榜单。技术/商业判断：Scale 价值锚点是"数据标注+模型评估"这一卖铲人位置，Meta 入股使其深度绑定 Meta 超智能战略，但也丧失了对其他大厂客户的中立性（OpenAI/Google 等转向自建或竞品），这是 Scale 当前最大战略风险。
- 关键数据：Meta 入股 $14.3B 换 49% 股权（Forbes，2026-06-16）；交易完成 2025-06（Business Standard）；本周无 SEAL 新榜单
- 原文链接：https://www.forbes.com/sites/jonmarkman/2026/06/16/why-meta-paid-143b-for-scale-ai-and-alexandr-wangs-data-empire ；https://techcrunch.com/2026/06/12/metas-months-old-ai-unit-is-a-soul-crushing-gulag-say-the-engineers-stuck-inside-it
- 影响判断：本周虽无产品动态，但"$14.3B 一周年复盘"集中暴露了"数据卖铲人深度绑定单一巨头"的战略隐患。Scale 的处境是 AI 数据层中立性危机的缩影——当卖铲人站队，其他淘金者必然另寻铲子。

### 9. Cohere（Command R+ / Command A+）
- 本周动态：**本周无窗口内重大公开动态**。Cohere 最近一次重磅是 **Command A+（command-a-plus-05-2026）于 5-20 发布**（背景，非本周）——其"最快最强"的开源企业级模型，MoE（专家混合）架构，速度为前代两倍、更低延迟更高准确率，主打复杂推理/多模态/多语言 agentic 任务，**最低仅需 2 张 H100 GPU** 即可运行，定位"主权关键基础设施"（sovereign critical infrastructure），现已通过标准 API 对所有用户开放、企业可私有部署。同期还发布开发者首款模型 North Mini Code。本周（6-14~6-20）官方 changelog 与博客无新版本/新融资公开。背景数据：Cohere 据 IntuitionLabs（2-21）报道 ARR 约 **$240M**，North agent 平台 + 潜在 2026 IPO 路径。技术/商业判断：Cohere 坚守"企业级 + 数据主权 + 私有部署"差异化定位，避开消费级模型军备竞赛，本周静默符合其"重大版本后消化期"节奏，重心应在企业落地与可能的 IPO 筹备。
- 关键数据：Command A+ 发布 2026-05-20（cohere.com/blog/command-a-plus，背景）；ARR ~$240M（IntuitionLabs，2026-02-21）；本周无新发布
- 原文链接：https://cohere.com/blog/command-a-plus ；https://docs.cohere.com/changelog
- 影响判断：本周无动态本身是信号——Cohere 选择在 Command A+ 后专注企业交付而非持续刷版本，押注"主权 AI/私有部署"的差异化赛道，与刷榜的消费级玩家分道扬镳。下个观察点是 IPO 进展。

### 10. SSI（Safe Superintelligence / SSI-1）
- 本周动态：**本周无窗口内官方公开动态**（SSI 一贯极度保密，无产品、无博客、无社媒更新）。最近相关报道为 StartupHub（6-06，窗口外背景）：SSI 自 2024-06 成立以来已**累计融资约 $60 亿、估值 $320 亿**，是史上估值最高却无商业产品的 AI 实验室；Sutskever 2024-05 离开 OpenAI（曾任首席科学家），一个月后与 Daniel Gross（前 Apple AI 负责人）、Daniel Levy（前 OpenAI 研究员）共同创立 SSI，唯一使命"造出首个安全的超级智能"，并公开承诺在使命达成前不做任何商业产品。2025-07 Gross 离职加入 Meta 超智能实验室后，Sutskever 接任 CEO。另据 Calcalist 报道，早期工程师 Shahar Papini 已离开 SSI，联合创办 AI 验证创业公司 Attestable（融资 $18.5M）——侧面反映 SSI 人才流动。SSI 在 Palo Alto 与特拉维夫双地办公，团队约 20 人，强调"超越规模暴力堆叠（brute-force scaling）"的全新 AGI 路径。所谓 "SSI-1" 产品本周无任何官方确认或发布。技术判断：SSI 的"直射式（straight-shot）"无产品策略使其本质上对短期周报"不可观测"——它的动态只会在重大融资或最终成果时爆发。
- 关键数据：累计融资 ~$60亿、估值 ~$320亿（StartupHub，2026-06-06，背景）；团队约20人（Wikipedia）；本周无公开动态
- 原文链接：https://www.startuphub.ai/ai-news/ai-figures/2026/figure-ilya-sutskever-ssi-financial-breakdown-2026-06-06 ；https://ssi.inc
- 影响判断：SSI 的"沉默"本身即其策略——$320亿估值完全建立在 Sutskever 声誉与未公开研究方向上。本周无动态是常态而非异常；真正值得警惕的是早期工程师流出（Papini→Attestable），这是观察 SSI 内部健康度的稀缺信号。

---

## 本组洞察（C组：Agent框架工具 + 其他参与者）

**1. 编码 agent 竞争从"代码质量"上移到"工作面争夺"——这是本周最大拐点。** Claude Code 发布 Artifacts（实时交互可分享网页），直接对位 OpenAI 两周前的 Codex "Sites"。两者哲学分野清晰：OpenAI 走 PaaS（可持久全栈应用，Cloudflare Worker 兼容），Anthropic 走"无状态画布"（stateless canvas）。竞争焦点已不是"谁代码写得好"，而是"谁能把 agent 产出呈现给整个组织、占据企业工作入口"。谁掌握工作面，谁掌握企业级分发。

**2. "可靠性/可运营性"正取代"智能上限"成为 Agent 落地的真实瓶颈。** OpenClaw 2026.6.8 把重心从加功能转向消息富文本投递+中断恢复；Codex 补加密远程执行（Noise relay）+插件市场；OpenCode 全力做 MCP 兼容性；ADK 加 mTLS+企业参数化+E2B 沙箱。四者不约而同地把工程精力投向"安全、稳定、可托付"——Agent 已过了 demo 期，正在跨越"能跑"到"敢托付生产"的鸿沟。

**3. MCP（Model Context Protocol）已成为 Agent 互操作的事实标准。** 本周 OpenCode 几乎整版投入 MCP schema 兼容/OAuth/超时修复，Codex 推 stdio MCP server 按线程激活+插件市场，OpenClaw 此前也深度集成 MCP。开放标准正成为开源工具（OpenCode）对抗闭源巨头（Claude Code/Codex）的核心武器，也是巨头之间互通的最大公约数。

**4. "渠道即分发"——个人 AI 助理赛道靠覆盖面定生死。** Hermes v0.17.0 "Reach Release" 新增 iMessage（弃 BlueBubbles 中继）+Raft 网络，OpenClaw 强化 Telegram/WhatsApp 富文本。两大头部（Hermes 19.8万 Stars / OpenClaw 38万 Stars）正用渠道覆盖正面厮杀——能力趋同后，触达用户的渠道广度成为胜负手。

**5. "其他参与者"三家折射 AI 资本与战略的三种极端。** Scale AI（数据卖铲人深度绑定 Meta，丧失中立性，$14.3B 一周年遭质疑）、Cohere（避开军备竞赛，押注主权AI/私有部署/IPO）、SSI（$320亿估值、零产品、纯信仰，对周报"不可观测"）。三者共同说明：2026 年 AI 竞争已分化为"应用基建层""企业差异化层""超智能信仰层"三条互不交叉的赛道，资本逻辑各异。

**底层逻辑总结**：本周 C 组的主旋律是 **Agent 从"智能竞赛"转向"工程化与生态化竞赛"**。版本号高频迭代（Codex 日更、OpenClaw/Hermes 周更大版本）背后，是各家在可靠性、安全基建、开放标准、渠道覆盖、企业工作面五个维度的全面卡位。智能上限的差距在缩小，工程化与生态卡位的差距在拉大——这才是 2026 年中 Agent 赛道的真实战场。

---

## ⚡ 赛道深度正文 · D 组｜算力云硬件 + 具身机器人（6）

### NVIDIA（GPU / CUDA / Blackwell）
- **本周动态**：本周NVIDIA最重磅动作是**史上最大规模债券发行**。6月15日，NVIDIA为2021年以来首次高评级债券定价，原计划200亿美元，因认购火爆（订单约850亿美元、超额认购逾3倍）上调至**250亿美元**，交易于6月18日完成；当日股价收于210.69美元（+2.95%），逼近历史高位（来源：tikr引用Bloomberg/Yahoo Finance，2026-06-15/18）。债券分7个档期，最长期限到**2056年（30年期）**——这是对"AI基础设施是数十年级长周期建设而非短期周期"的押注。值得注意的是NVIDIA并不缺钱：即便完成此次募资，公司净债务仍为**负400亿美元**（现金多于债务），上季度自由现金流达486亿美元。借债的真实意图是：①锁定低成本长期资本为前向供应承诺融资——CFO Colette Kress两周前在美银科技大会披露公司已有"约**1240亿美元**采购承诺"；②在不稀释股东的前提下同时支撑增长与股东回报（5月18日已授权**800亿美元回购**并将股息提至每股每年1美元）。路线层面，Kress确认下一代数据中心平台**Vera Rubin"已为Q3准备就绪"并进入满产**，并把Blackwell+Rubin框定为2025–2027横跨约**1万亿美元**的机会。NVIDIA当前市值5.1万亿美元，却以NTM P/E约21.2倍交易，低于博通(26x)与AMD(61x)，估值折价主因：中国出口管制未决（指引假设数据中心对华营收为零）+ 超大规模厂商自研芯片威胁GPU。
- **关键数据**：250亿美元债券（原20B上调），订单约850亿美元，7档期至2056年——https://www.tikr.com/blog/nvidia-just-raised-25-billion-in-its-biggest-bond-deal-ever-heres-what-it-signals-for-2026 （2026-06-15/18）；1240亿美元前向承诺、800亿回购、Vera Rubin满产——同上引用Colette Kress（2026-06）；上季度营收816亿(+85%YoY)、FCF 486亿——同上（2026-05-20财报）。
- **原文链接**：https://www.tikr.com/blog/nvidia-just-raised-25-billion-in-its-biggest-bond-deal-ever-heres-what-it-signals-for-2026
- **影响判断**：250亿债券+850亿订单是债券市场对AI长周期的"用脚投票"，30年期限是强信号；但同一交易也是bear case的镜像——若AI需求降温，在capex顶部发的长债会"老化得很难看"。背景（非本周）：Vera Rubin、GTC 2026、Computex的RTX Spark均在本周区间之外发布。

---

### AWS（Bedrock / Trainium / SageMaker）
- **本周动态**：本周是AWS的"大周"——**6月17日AWS Summit纽约站**（Javits中心），由Agentic AI副总裁Swami Sivasubramanian做主题演讲，密集发布一批面向"agentic AI生产化"的能力。核心发布包括：①**Amazon Bedrock AgentCore新能力**：连接AI agent到组织内/网页/付费知识源，生产环境问题诊断与修复，以及随agent能力增长可扩展的管控（含Bedrock Managed系列）；②**AWS Context（即将推出）**：全新服务，自动把现有数据关系映射成知识图谱并提供agentic搜索，让组织内AI agent在运行时访问受治理的数据关系、业务规则与领域知识；③**AWS Continuum**：全新AI原生安全服务；④**Nova模型定制**：可在SageMaker AI中为企业用例定制Amazon Nova模型；⑤**AWS Graviton5正式GA**：面向agentic AI时代的专用CPU性能；⑥**AI Agents and Tools进入AWS Marketplace**、**Amazon S3 Vectors**（被Reddit社区列为三大发布之一）；⑦**AWS DevOps Agent**新增发布管理能力（上线前评估代码变更、自主发布测试，预览）。此外本周早些时候（6月15日Weekly Roundup）还有：**AWS FinOps Agent预览、Gemma 4上线Bedrock、Kiro Pro Max**等。整体主线非常清晰：从模型层（Nova定制、Gemma 4、此前GPT-5.5/5.4+Codex上Bedrock）到agent运行时（AgentCore GA化、VPC/PrivateLink/CloudFormation支持）到数据治理（AWS Context知识图谱）到底层算力（Graviton5、Trainium2），AWS把"企业agent从实验走向生产、跑关键业务流程"作为压舱石叙事。
- **关键数据**：Graviton5 GA、Nova可定制、AWS Context/Continuum为新服务——https://www.aboutamazon.com/news/aws/aws-summit-nyc-2026-ai-agents （2026-06-17）；三大发布AgentCore/Marketplace Agents/S3 Vectors——https://www.reddit.com/r/aws/comments/1m40puq/ （2026-06-17）；FinOps Agent预览/Gemma 4/Kiro Pro Max——https://aws.amazon.com/blogs/aws/aws-weekly-roundup-aws-finops-agent-in-preview-gemma-4-on-bedrock-kiro-pro-max-and-more-june-15-2026/ （2026-06-15）。具体Trainium出货量/定价本周未公开。
- **原文链接**：https://aws.amazon.com/blogs/aws/top-announcements-of-the-aws-summit-in-new-york-2026/ ；https://www.aboutamazon.com/news/aws/aws-summit-nyc-2026-ai-agents ；https://aws.amazon.com/blogs/aws/aws-weekly-roundup-aws-finops-agent-in-preview-gemma-4-on-bedrock-kiro-pro-max-and-more-june-15-2026/
- **影响判断**：AWS本周把战略重心从"提供模型"明确转向"提供agent运行时+数据治理底座"，AgentCore从预览走向企业级（VPC/PrivateLink）是关键拐点信号——它不与OpenAI/Anthropic比模型，而是争夺"谁来托管和治理企业agent"这一更黏的层。Graviton5与Trainium的同步推进显示AWS继续以自研硅片对冲对NVIDIA的依赖。

---

### Azure（Azure AI / OpenAI Service，独立追踪云业务）
- **本周动态**：本周Azure侧最值得记录的是**Microsoft Foundry（原Azure AI Foundry/Azure OpenAI演进而来）的密集功能迭代**，主线是"agent可观测、可评测、可治理"。据azurecharts更新流，本周区间(6/14–6/20)内Foundry官方博客/Azure Updates连发多条：6月15日**Benchmarks in Microsoft Foundry（预览）**——标准化的模型与agent质量检查；6月15日"A Guided Tour of the New Microsoft Foundry Labs"与"Intelligent sampling"生产trace采样；6月17日"Build an Automated SLA Risk Agent with Routines"、"How to Score a User Simulator: USR-8"用户模拟器评分；6月18日**"Outcome-driven learning systems: Enterprise RL with OpenEnv and Foundry"**（企业级强化学习）与"Auto-Generated Rubric Evaluators"自动评分器；6月19日"Cross-Region Model Connectivity Options"跨区域模型连接。背景（非本周但紧邻）：6月9日**Claude Fable 5上线Foundry**、6月3日Build 2026系列（Foundry Managed Compute、Agent Optimizer、Toolboxes/Routines、Foundry IQ GA）、6月2日MAI-Image-2.5/MAI-Transcribe-1.5进目录。需特别注意品牌动向：微软已将"Azure AI Foundry"逐步更名/整合为**"Microsoft Foundry"（即Azure AI Inference）**，从旧Azure OpenAI SDK迁移到新Foundry endpoint，这是本季度开发者侧的实质迁移成本。云业务独立信号：本周区间内Azure未发布独立的重大OpenAI新模型上线公告（上一波GPT-5.5为4月24日GA），本周以"评测/RL/路由/跨区"等工程治理能力为主。
- **关键数据**：Benchmarks(preview) 6/15、Enterprise RL with OpenEnv 6/18、Cross-Region Connectivity 6/19——https://azurecharts.com/updates?search=1&service=147 ；Claude Fable 5上线 6/9（背景）——同上。本周无新增独立营收/PTU定价数字公开。
- **原文链接**：https://azurecharts.com/updates?search=1&service=147 （Foundry更新聚合流，含6/15–6/19各条原文链接）
- **影响判断**：Azure本周没有"重磅新模型"，但功能流清晰指向一个判断：竞争焦点已从"上架哪个模型"转向"如何让企业把agent放心跑到生产"——Benchmarks、Rubric Evaluators、USR用户模拟器、Enterprise RL(OpenEnv)构成一套"agent质量/学习闭环"工具链。这与AWS本周AgentCore的方向高度同构，说明三大云本周不约而同把"agent运维与治理层"作为主战场。品牌从Azure AI Foundry收敛为Microsoft Foundry，是微软统一AI开发入口的长期动作。

---

### 宇树 Unitree（H1 / G1）
- **本周动态**：本周(6/14–6/20)宇树**无独立的重大新公开事件**，处于IPO静默推进期，原因具体：其科创板IPO关键节点都落在本周区间之前——6月1日上交所上市委审议**过会**，6月2日"闪电"**提交注册**（从3月20日受理到过会仅73天，刷新2026年科创板最快纪录、预先审阅机制第二单）。本周区间内主要是港股/二级市场对宇树概念的持续发酵（如6月18日AASTOCKS等仍在复盘其股东结构）。把紧邻背景讲清楚以便理解本周语境：本次IPO拟募资**42.02亿元**，发行不低于4044.64万股（≥10%），对应发行市值约**420亿元**；募资近一半（智能机器人模型研发项目20.2亿元）押注"具身大脑"，意图从"会跳舞"转向"能干活"。财务：2023–2025营收1.59亿/3.93亿/16.99亿元，净利润-0.11亿/0.95亿/2.78亿元，2025年扣非净利5.91亿元(+652.78%)，主营毛利率连升至60.13%，核心部组件自研率>90%。2025年人形机器人出货**超5500台**（不含轮式），全球第一；2026目标1–2万台。产品矩阵：全尺寸H1/H2 + 中小型G1/R1。"大脑"布局：2025/9开源UnifoLM-WMA-0(世界模型)，2026/1开源UnifoLM-VLA-0(VLA)，2026/5/25测试发布WVLA2.0并落地G1会议室自主整理。另一紧邻背景（6月2日，区间外）：黄仁勋宣布英伟达将与宇树联手推出新一代人形参考设计**H2Plus**（搭载NVIDIA高算力平台，下半年上市）。
- **关键数据**：IPO募资42.02亿、发行市值约420亿、2025出货>5500台全球第一——https://finance.sina.com.cn/stock/zqgd/2026-06-03/doc-iniaarqw2591829.shtml （2026-06-03，背景）；财务与毛利60.13%——https://www.guancha.cn/economy/2026_06_01_819094.shtml （2026-06-01，背景）；股东结构(王兴兴23.82%/美团9.65%/红杉7.11%)——https://www.aastocks.com/tc/stocks/news/aafn-news/NOW.1527051/2 （2026-06-18）。
- **原文链接**：https://m.thepaper.cn/newsDetail_forward_33282602 ；https://www.guancha.cn/economy/2026_06_01_819094.shtml ；https://finance.sina.com.cn/stock/zqgd/2026-06-03/doc-iniaarqw2591829.shtml
- **影响判断**：宇树本周虽无新动作，但它是观察整条具身赛道的"上市样本"——极速过会+420亿发行市值，是资本对中国机器人硬件制造力的极度认可；但募资近半投"大脑"也暴露其短板：研发费用占营收比已降至8.53%（低于优必选25.4%），数据飞轮几乎空白，科研客户占人形收入73.6%意味着失败/成功数据不回流。硬件强、模型中、数据弱的"不平衡三角"是其IPO后最大风险，窗口期不会太长。

---

### 优必选 UBTech（Walker S）
- **本周动态**：本周(6/14–6/20)优必选(09880.HK)最大看点是**消费级超仿生人形机器人U1系列预售在本周内持续刷新里程碑**。U1自6月2日在京东"优世界"自营旗舰店开启预售（3000元定金锁单），订单一路上涨：6月8日超2700台、6月12日晚约3800–4000台、**截至6月18日预售已超4600台**（17天近5000台）。对比2025年优必选全尺寸人形机器人全年仅售1079台，这是里程碑式突破。U1将于**6月30日正式上市**。产品规格（官方）：身高183cm、重42kg、88个总自由度、搭载"养成系情感大模型"、支持多维度外观定制（男女款、女款可定制妆容）、可连Wi-Fi、续航2–4小时、仅限成年人购买，定位"情感陪伴消费品"（不做家务、只做陪伴），精准切都市孤独人群与泛二次元消费者。资本反应：消息期间优必选单日股价涨幅超6%，供应链股（绿的谐波、鸣志电器、昊志机电等）同步上涨。B端方面，工业机型Walker S2自2025年11月开启量产交付，2025年人形订单超14亿元（覆盖航空/汽车/3C/物流/半导体五大场景，客户含比亚迪、富士康、空客等），2026年规划工业人形万台产能。CEO周剑曾预估2026年出货约5000台、增长400%。
- **关键数据**：U1预售6/18超4600台 vs 2025全年1079台；规格183cm/42kg/88自由度/续航2-4h——https://www.163.com/dy/article/KVNTP7HC0550WHYR.html （2026-06-18）；预售6天破2110台(6/8)、10天破3800台(6/12)——https://ai.zol.com.cn/1198/11980561.html （2026-06）；2025订单>14亿、2026万台产能——https://www.sznews.com/news/content/2026-03/05/content_31964657.htm （2026-03-05，背景）。
- **原文链接**：https://www.163.com/dy/article/KVNTP7HC0550WHYR.html ；https://ai.zol.com.cn/1198/11980561.html
- **影响判断**：U1是优必选战略重心的关键信号——从"B端工业Walker"主动切入"C端情感消费品"，本周预售4600+台是中国全尺寸人形机器人C端化的首个规模化验证点。但需冷静：续航仅2-4小时、功能限于陪聊交互，业内普遍判断U1更像"高端情感玩具/品牌占位与资本叙事"，工业Walker S系列仍是营收主力。真正考验在6/30发布后的交付兑现与复购。

---

### Figure AI（Figure 02）
- **本周动态**：**本周(6/14–6/20)Figure AI无重大公开动态**，原因具体：①Figure官网News页本周区间内无新条目（最近发布节点为3月9日，再往前是2025年11月；本周无更新）；②公司上一波密集动作集中在本周区间之外——4月29–30日"Ramping Figure 03 Production"（BotQ工厂从1台/天提速到**1台/小时**、已交付**超350台**第三代人形机器人Figure 03）、4月13日TIME专访（Adcock称目标2026年实现家庭自主作业）、3月25日Figure 03亮相白宫(梅拉尼娅活动)。需说明的是，本组指定追踪型号为"Figure 02"，但Figure的产品重心自2025年10月9日Figure 03发布后已全面转向03（02此前用于BMW工厂，"Figure 02 Supports 30k+ Vehicles at BMW"），02本周无独立新闻。本周Figure未发布融资、新品、benchmark或部署公告。背景数据（非本周）：BotQ初期产线设计年产能**12,000台**；公司估值约**390亿美元**(2025年9月轮，投资方含NVIDIA/Intel Capital/T-Mobile/Salesforce等)；2025年初已与OpenAI终止合作转向自研Helix VLA模型，Helix 02于2026年1月发布(可完成4分钟端到端洗碗机装卸的全身自主loco-manipulation)。
- **关键数据**：BotQ 1台/小时、已交付>350台Figure 03、年产能12,000台——https://www.figure.ai/news/ramping-figure-03-production （2026-04-29，背景）；估值约390亿美元——https://techmarketbriefs.com/pre-ipo/figure-ai/ （2026-04-28，背景）。本周无新增数字公开。
- **原文链接**：https://www.figure.ai/news （本周无新条目）；https://www.figure.ai/news/ramping-figure-03-production （背景，4/29）
- **影响判断**：Figure本周静默，符合其"重大发布集中在产品里程碑节点、平时低频"的节奏。真正信号是产能曲线（1台/天→1台/小时仅用4个月），若该速率持续，Figure将是西方阵营最先逼近"万台级年产"的人形玩家，与中国宇树/优必选的量产竞赛形成跨太平洋对照。指定型号Figure 02已进入"工厂存量部署"阶段，叙事焦点完全让位给Figure 03。

---

## 本组洞察（趋势 / 拐点 / 底层逻辑）

**1. 三大云本周"不约而同"押注agent运维治理层，而非模型本身。** 这是本周最强的同构信号：AWS Summit纽约(6/17)主推**AgentCore**从预览走向企业级(VPC/PrivateLink)+AWS Context知识图谱；Azure/Microsoft Foundry本周连发**Benchmarks(预览)、Rubric Evaluators、USR用户模拟器、Enterprise RL(OpenEnv)**一整套agent质量/学习闭环工具；NVIDIA则用**250亿美元史上最大债券**为这场长周期军备竞赛锁定弹药。底层逻辑：当模型能力趋同、价格战白热化，竞争壁垒正从"谁的模型强"迁移到"谁能让企业把agent放心跑到生产并持续治理"——这是更黏、更难被替代的一层。

**2. 拐点信号：NVIDIA 30年期债券=对AI基础设施"数十年级建设"的金融化下注。** 一家净债务为负400亿、上季度FCF 486亿的公司主动借250亿（认购850亿、超3倍），核心不是缺钱，而是把"1240亿前向采购承诺"用长债匹配，并同步800亿回购。这是把"AI capex超级周期"写进资产负债表久期的标志性动作——也是bear case的镜像：30年债在capex顶部发行，需求一旦降温会很难看。下一验证点是8月底Q2 FY2027财报的数据中心与中国口径。

**3. 中国具身赛道进入"量产/上市双竞赛"的规模化验证期。** 宇树73天闪电过会(420亿发行市值)+优必选U1预售17天近5000台(vs 2025全年1079台)，两条线同时点火：宇树代表"硬件强、模型中、数据弱"的科研平台型路径(研发占营收比已降至8.53%)，优必选U1代表"B端工业Walker打底、C端情感消费品做叙事"的双线打法。德意志银行已把2026全球人形出货预测从1.75万台大幅上调至近5万台、中国约4万台。但共同隐忧一致：续航(2-4h)、功能单一、数据飞轮缺失——量产是"入场券"而非"终点"。

**4. 中美人形机器人量产竞赛跨太平洋对照。** 西方阵营Figure用4个月把BotQ从1台/天拉到1台/小时(年产能设计1.2万台)，节奏低频但产能曲线陡峭；中国阵营则以"价格炸弹+供应链垂直整合(自研率>90%)+资本市场叙事"快速铺量。两种路径的胜负手都不在硬件，而在"数据飞轮+世界模型"——谁先让机器人在真实闭环场景里持续迭代，谁就赢得"从会动到能干活"的下半场。

---
*D组研究完成 · 6对象逐一覆盖 · 数据均附来源URL与日期 · 区间外旧闻已明确标注"（背景，非本周）"*

---

## 📋 关于本周报

- **数据口径**：覆盖区间 2026-06-14 00:00 ~ 2026-06-20 24:00（上海时区）完整自然周，窗口外动态仅作背景标注。
- **覆盖**：38 个 AI 主体，实质覆盖 38/38（100%）。
- **质量门控**：四维全过（覆盖率 38/38 · 原文抽查 5/5 URL 真实 · 每对象洞察+六组主线趋势 · GitHub Stars 等关键数据实时交叉验证）。
- **来源说明**：官方博客/论文/GitHub release/官方公告优先，关键数据均附来源 URL 与日期；查不到的如实标注'未公开'，绝不编造。
- **下期预告**：持续追踪 GPT-5.6/Gemini 3.5 Pro 发布、智谱/MiniMax 科创板 IPO 进展、三大云 agent 治理层竞争、中国具身量产兑现。
