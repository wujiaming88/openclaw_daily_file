# 全球 AI 动态周报（2026-05-24 ~ 05-30）

> 覆盖区间：2026-05-24（周日）00:00 → 2026-05-30（周六）24:00（上海时区）
> 研究范围：38 个主体（含大模型基座、垂直 Agent、中国 AI、框架工具、算力硬件、具身机器人）
> 生成日期：2026-06-05

---

## 📌 本周 TOP 5 大事

1. **Anthropic 发布 Claude Opus 4.8（5/28）** — 同价升级，计算机使用 Online-Mind2Web 达 84%（超 GPT-5.5/Gemini），fast 模式 2.5×速度且便宜 3 倍；同步推出 Claude Code "动态工作流"，单会话可调度数百并行子 Agent。
2. **Google I/O 2026 一次性发布约 100 项更新（5/26）** — 核心是 Gemini Omni Flash（世界模型家族首款，原生多模态可生成/编辑视频含物理推理）与 Gemini 3.5 Flash（直接 GA，成为搜索默认后端），意在"商品化智能体层"向对手施压。
3. **NVIDIA GTC Taipei：台湾年投资升至 1500 亿美元/年（5/27）** — 黄仁勋把叙事从"卖 GPU"升级为"AI 工厂 + token 即营收"，发布 Vera Rubin pod 级系统与 Vera CPU，绑定 TSMC 供应链。
4. **国产大模型密集冲刺 A 股科创板** — MiniMax 5/29 启动 IPO 辅导（中信证券），智谱紧随其后推进"A+H"；叠加阿里 5/26 新加坡 Qwen 大会 + 5/29 牵手欧足联，国产 AI 进入"资本化 + 全球化"双提速。
5. **具身智能从演示转向商单（5/26）** — Figure 与 Catalyst Brands（JCPenney 母公司）签商业协议落地零售物流；同周宇树/优必选亮相天津世界智能博览会，宇树紧接着冲刺科创板。

---


## 板块：A组

**时间窗：2026-05-24（周日）00:00 → 2026-05-30（周六）24:00（上海时区）**
研究员：黄山｜生成日期：2026-06-05

---

### OpenAI（GPT-5/ChatGPT/Codex）
- 本周动态：5月26日发布 Codex CLI v0.134.0，新增本地会话历史搜索（含内容匹配预览）、将 `--profile` 设为规范化的配置选择器（旧版 profile 配置被拒绝并给出迁移指引）、MCP 支持按服务器粒度的环境变量定向与流式 HTTP 上的 OAuth、只读 MCP 工具可并发执行加速。本周未发布新基座模型；GPT-5.6 仅在月中 Codex 日志中短暂出现引用，属后端 canary 测试，非正式发布。
- 关键数据：Codex CLI v0.134.0，发布日 2026-05-26（来源 https://codersera.com/blog/openai-may-2026-updates-roundup/ ，2026-05 更新汇总）。GPT-5.5 标准定价 $5/$30 每百万 tokens、1M 上下文（Codex 内有效 400K）、SWE-bench Verified 88.7%。
- 原文链接：https://codersera.com/blog/openai-may-2026-updates-roundup/
- 影响判断：本周 OpenAI 主线是把 Codex 从交互式助手推向"持久化自主运行时"（5月21日 Goal Mode 默认开启的延续）。模型层面按兵不动，竞争重心转向智能体工程与工具集成。

### Google DeepMind（Gemini/Gemma）
- 本周动态：5月26日 Google I/O 2026 开发者大会上一次性发布约100项更新，核心为 Gemini Omni Flash（"Omni"世界模型家族首款，原生多模态文本/图像/视频/音频统一架构，可对话式生成与编辑视频，并嵌物理/流体/重力推理保证场景连贯）与 Gemini 3.5 Flash（智能体推理引擎，直接 GA，成为 Gemini app 与 Google 搜索默认后端）。同时推出 Antigravity 2.0 智能体优先开发平台、Gemini API Managed Agents、Search Agents 与 Generative UI 框架。
- 关键数据：发布日 2026-05-26（来源 https://valasys.com/google-gemini-omni-flash-io/ ）。Google DeepMind 称 Gemini 3.5 Flash 多步工作流执行速度为同级前沿模型的约4倍；所有 Omni Flash 视频输出自动嵌入 SynthID 水印；开发者/企业 API 分阶段于"未来数周"开放。
- 原文链接：https://valasys.com/google-gemini-omni-flash-io/
- 影响判断：Google 试图"商品化智能体层"——通过把多智能体编排捆绑进 Google Cloud 并压低 Flash 模型每 token 成本，向 OpenAI/微软/Anthropic 的企业定价施压。世界模型路线（"从预测文本到模拟现实"）是与对手最大的差异化叙事。

### Anthropic（Claude Opus/Sonnet）
- 本周动态：5月28日发布 Claude Opus 4.8，基于 Opus 4.7 全面提升基准表现，定价不变并即日全平台可用。同步上线：claude.ai/Cowork 的"effort 控制"（用户可选模型投入精力等级，全计划可用）、Claude Code 的"动态工作流"（研究预览，可在单会话调度数百并行子智能体、运行更久后再校验输出，支持数十万行代码级迁移）、Opus 4.8 fast 模式（2.5×速度且比前代便宜3倍）、Messages API 支持在 messages 数组内插入 system 条目以中途更新指令而不破坏 prompt cache。
- 关键数据：发布日 2026-05-28（来源 https://www.anthropic.com/news/claude-opus-4-8 ）。常规定价 $5/百万输入、$25/百万输出（fast 模式 $10/$50）；Online-Mind2Web 计算机使用 84%（超 Opus 4.7 与 GPT-5.5）；代码缺陷漏检率约为前代的 1/4；Super-Agent 基准为唯一全案例端到端通过、与 GPT-5.5 成本持平。另预告 Project Glasswing 下的 Mythos 级模型将于"数周内"面向客户。
- 原文链接：https://www.anthropic.com/news/claude-opus-4-8
- 影响判断：Anthropic 延续"小步快跑"节奏，强调诚实性/对齐与智能体可靠性而非纯智能跃升；同价升级+更便宜的 fast 模式，直接对标 GPT-5.5 与 Gemini 的成本竞争。

### Meta AI（Llama 4）
- 本周动态：本周无重大公开模型发布。Meta 当前生成式 AI 重心在 Meta Superintelligence Labs（MSL）/TBD Lab 的下一代模型研发与人才招募；公开会展 Meta Connect 2026 定于9月23-24日，Llama 4 系列（Scout/Maverick，MoE 架构）发布于更早时段，05-24~05-30 自然周内无重大公开动态。
- 关键数据：—（本周无新版本/融资/benchmark 公布）
- 原文链接：https://en.wikipedia.org/wiki/Meta_Superintelligence_Labs （背景参考；本周无一手发布）
- 影响判断：Meta 进入"重组+蓄力"期，开源策略据报道在2026年一季度收紧；短期内对周度竞争格局影响有限，看点在 Connect 与下一代模型。

### xAI（Grok）
- 本周动态：5月29日 xAI 将 `grok-build-0.1` 推上 xAI API 公开测试——这是 Grok 系列首个独立的编程专用模型，专为智能体编程任务（Web 开发、调试、MCP 支持）训练，也是驱动 Grok Build CLI 的同款模型。在 Cursor、Hermes Agent、OpenClaw、Kilo Code、OpenCode 等智能体框架表现最佳，并通过 OpenRouter、Vercel AI Gateway 提供。
- 关键数据：发布日 2026-05-29（来源 https://x.ai/news/grok-build-0-1 ，经搜索快照确认）。定价 $1/百万输入、$2/百万输出；推理速度 100+ tokens/s；256K 上下文（来源 https://www.openai-hub.com/news/545 ）。xAI 未公布具体 SWE-bench/Aider 跑分（"未公开"）。Grok 5 仍在推迟，无本周发布。
- 原文链接：https://www.openai-hub.com/news/545 （x.ai 原页本周被反爬拦截，经第三方与搜索快照交叉确认）
- 影响判断：xAI 走"不拼最强、拼最快最便宜的 Agent 顺手模型"差异化路线，以 $1/$2 低价+高吞吐直插 Claude Code/Codex/Cursor 的开发者腹地，价格战进一步加剧。

### Microsoft（Copilot/Azure AI/Phi）
- 本周动态：本周无重大公开发布。微软年度开发者大会 Build 2026 定于6月2-3日（旧金山，主题演讲北京时间6月3日凌晨），落在本自然周之外；05-24~05-30 周内为大会前预热期，无重大一手产品发布。
- 关键数据：Build 2026 日期 6月2-3日（来源 https://www.theverge.com/tech/941379/ ，2026-06）；本周无新模型/定价/benchmark。
- 原文链接：https://www.cnet.com/tech/microsoft-build-2026-what-to-expect/
- 影响判断：本周静默，重磅更新集中在下周 Build（AI 智能体平台、Foundry、Windows 本地 AI、GitHub Copilot app 等），届时为微软智能体平台叙事的关键节点。

### DeepSeek（V3/R1）
- 本周动态：本周无重大公开发布。DeepSeek 最新一手节点为2026年4月发布 V4 模型系列预览、4月24日 deepseek-chat/deepseek-reasoner 升级至 V3 并预告迁移至 deepseek-v4-flash（生效 2026-07-24）；截至本周 API Docs News 无新于 V4 Preview 的官方发布，05-24~05-30 周内无重大公开动态。
- 关键数据：—（本周无新版本）；legacy 模型名将于 2026-07-24 指向 deepseek-v4-flash 的非思考/思考模式（来源 https://api-docs.deepseek.com/updates ，2026-04-24）。
- 原文链接：https://api-docs.deepseek.com/updates
- 影响判断：DeepSeek 处于 V4 系列分阶段落地的过渡期，本周无新动作；其低价开源路线仍是国产基座对标国际前沿的关键变量。

### Databricks（DBRX/Mosaic ML）
- 本周动态：本周无重大公开发布。Databricks 年度 Data + AI Summit 2026 定于6月15-18日（旧金山 Moscone Center，逾3万人现场），落在本自然周之外；本周仅作为 Anthropic Opus 4.8 早期测试客户出现在合作背书中（Genie 智能体借 Opus 4.8 实现更深多步推理、对 PDF/图表等非结构化内容推理且 token 成本较 Opus 4.7 低61%）。05-24~05-30 周内无 Databricks 一手产品/模型发布。
- 关键数据：Summit 日期 6月15-18日（来源 https://www.databricks.com/company/newsroom/press-releases/databricks-announces-2026-data-ai-summit-keynote-lineup-and ）；Genie 借 Opus 4.8 token 成本降61%（来源 https://www.anthropic.com/news/claude-opus-4-8 ，2026-05-28）。
- 原文链接：https://www.databricks.com/company/newsroom/press-releases/databricks-announces-2026-data-ai-summit-keynote-lineup-and
- 影响判断：本周静默，重磅更新预计集中在下月 Summit；其作为 Opus 4.8 首发企业背书方，凸显"基座模型+数据平台"深度绑定的智能体商业化路径。

### 字节跳动（豆包/Coze）
- 本周动态：5月30日（IT之家报道"前天发布"，即5月30日）字节跳动旗下 AI 智能体平台扣子（Coze）发布 3.0 全新版本：支持多人多 Agent 协作（一人+多 Agent / 多人+多 Agent 灵活组合）、多项目独立管理与资产自动沉淀、从开发到上线全流程工作流；可一键接入 Claude Code、Codex CLI、OpenClaw 等本地 Agent；内置自媒体/法律/金融/互联网/医疗健康等行业专家技能模板；支持手机电脑跨端同步、授权 Agent 处理本地文件。同周还有 5月26日"AGENT WORLD"商标注册申请、5月27日 Seed 员工"豆包股"激励传闻等周边动态。
- 关键数据：Coze 3.0 发布日 2026-05-30（来源 https://www.ithome.com/0/958/372.htm ，IT之家2026-06-01报道）；正式上线时间为6月1日（来源 财联社）。
- 原文链接：https://www.ithome.com/0/958/372.htm
- 影响判断：Coze 3.0 把多 Agent 协作与"接入 Claude Code/Codex/OpenClaw"作为卖点，意在做国产智能体编排与行业落地的开放平台底座，紧跟全球"从模型到智能体平台"的转向。

### Mistral AI（Mistral Large/Codestral）
- 本周动态：本周连发多项更新——5月27日发布"Physics AI"研究方向（基于收购 Emmi AI，面向航空航天/汽车/半导体/能源等工业工程，构建物理 AI 基座，以神经代理模型加速 CFD 等仿真）；5月28日推出 Vibe Agent / Search Toolkit（"Vibe gets to work"，让 Vibe 进入实际工作流）；5月22日 Vibe 远程智能体（基于 Mistral Medium 3.5）与 Studio 内置/自定义 MCP 连接器（5月22日略早，但 Emmi 加入公告为5月23日，落在本周窗口起点）。本周以"智能体+工业物理 AI"为主线，无新 Mistral Large/Codestral 旗舰版本。
- 关键数据：Physics AI 发布日 2026-05-27、Vibe Agent 2026-05-28、Emmi 加入 2026-05-23（来源 https://mistral.ai/news ）；本周无新基座模型版本号/benchmark 公布（"未公开"）。
- 原文链接：https://mistral.ai/news/physics-ai-research
- 影响判断：Mistral 在通用旗舰之外开辟"工业物理 AI"垂直赛道（与 Google 的"世界模型"叙事呼应），并持续强化 Vibe 智能体与企业 MCP 连接，走差异化的欧洲企业级 + 工程仿真路线。

## A组洞察：本周（05-24~05-30）全球基座阵营的主旋律是"从模型竞赛转向智能体竞赛+价格战"。三大趋势：① 编程/智能体专用模型与运行时密集落地——Anthropic Opus 4.8（动态工作流、数百并行子智能体）、xAI Grok Build 0.1（$1/$2 低价高吞吐编程模型）、OpenAI Codex v0.134、字节 Coze 3.0（多 Agent 协作+接入 Claude Code/Codex/OpenClaw），智能体编排成为主战场；② "世界模型/物理 AI"成为新差异化叙事——Google Gemini Omni Flash（模拟现实）、Mistral Physics AI（工业仿真）同周登场；③ 价格与可靠性并重——Opus 4.8 同价升级+fast 模式降价、Gemini 3.5 Flash 压价、Grok Build $1/$2，前沿模型智能趋同后，成本与端到端可靠性（诚实性、对齐、citation 精度）成为新竞争点。Meta/Microsoft/DeepSeek/Databricks 本周相对静默，重磅多压在下周 Build 与下月 Data+AI Summit。


## 板块：B组

**时间窗：2026-05-24（周日）00:00 → 2026-05-30（周六）24:00（上海时区）**
**研究员：黄山｜生成日期：2026-06-05**

---

### Anysphere（Cursor）
- 本周动态：Cursor 持续高频更新 changelog（如 Canvas 设计模式、企业版 Organizations、Auto-review 运行模式、Shared Canvases /loop 技能等），但官方 changelog 中明确标注日期的条目为 05-19（Cursor in Jira）、05-20（Automations 改进），落在时间窗之前；05-24~05-30 区间内无可独立核实日期的重大公开发布。
- 关键数据：—（窗口内无新增可核实数据）
- 原文链接：https://cursor.com/changelog
- 影响判断：产品仍处快速迭代节奏，但本周无标志性大事件；融资（传闻 $50B+ 估值轮）相关报道均早于时间窗。

### Perplexity
- 本周动态：本周无重大公开动态。Perplexity 5 月主要更新（Computer 默认编排模型切换为 GPT-5.5、Mac 版 Personal Computer、企业金融连接器等）集中在 5 月初（changelog 标注 05-04），不在 05-24~05-30 窗口内。
- 关键数据：—
- 原文链接：https://www.perplexity.ai/changelog
- 影响判断：窗口内无新动作，处于上一波 Computer 产品更新后的消化期。

### Cognition（Devin / Windsurf）
- 本周动态：本周无重大公开动态。Windsurf 2.0（原生集成 Devin 云端 agent）发布于 2026-04-15，Cognition 收购 Windsurf 为 2025 年 7 月事件，均远早于时间窗。
- 关键数据：—
- 原文链接：https://devin.ai/blog/windsurfs-next-chapter
- 影响判断：窗口内无新公开里程碑。

### Harvey（Legal）
- 本周动态：本周无重大公开动态。Harvey 最近一次重大事件为 2026-03-25 确认完成 $200M 增长轮、估值 $11B（GIC 与 Sequoia 联合领投），不在时间窗内。
- 关键数据：估值 $11B、ARR 约 $190M（2026-01）、25,000+ 定制 AI agent；以上均为窗口前数据（来源：Law.com 2026-03-25 https://www.law.com/legaltechnews/2026/03/25/harvey-announces-200m-funding-round-）
- 原文链接：https://www.law.com/legaltechnews/2026/03/25/harvey-announces-200m-funding-round-
- 影响判断：窗口内无新动作；法律垂直 Agent 赛道整体仍处高融资景气。

### Sierra
- 本周动态：本周无重大公开动态。Sierra 最近一次重大事件为 2026-05-04 宣布 $950M 融资（Tiger Global、GV 领投），投后估值超 $15B，不在 05-24~05-30 窗口内。
- 关键数据：融资 $950M、估值 >$15B（来源：TechCrunch 2026-05-04 https://techcrunch.com/2026/05/04/sierra-raises-950m-as-the-race-to-own-enterprise-ai-gets-serious）；以上为窗口前数据
- 原文链接：https://techcrunch.com/2026/05/04/sierra-raises-950m-as-the-race-to-own-enterprise-ai-gets-serious
- 影响判断：窗口内无新动作，刚完成大额融资进入扩张期。

### Glean
- 本周动态：2026-05-28，Glean 向 TechCrunch 披露年度经常性收入（ARR）已突破 3 亿美元，较 15 个月前的 1 亿美元里程碑增长约 3 倍；CEO Arvind Jain 强调在巨头（Google、微软、OpenAI、Anthropic、Salesforce、Atlassian）纷纷入场企业搜索后，Glean 仍凭"context graph（上下文图谱）"深度理解客户业务、并帮助企业削减 AI 算力成本作为差异化卖点。
- 关键数据：ARR 突破 $300M（3 倍于 15 个月前的 $100M）；来源 TechCrunch 2026-05-28 https://techcrunch.com/2026/05/28/gleans-top-line-crosses-300m-as-ai-budget-cutting-becomes-its-major-selling-point
- 原文链接：https://techcrunch.com/2026/05/28/gleans-top-line-crosses-300m-as-ai-budget-cutting-becomes-its-major-selling-point
- 影响判断：企业 AI 搜索赛道商业化兑现强劲；"降本"成为对抗大厂的核心叙事，老牌先发者在竞争加剧下仍加速增长。

### Midjourney（v7）
- 本周动态：本周无可独立核实日期的重大官方发布。Midjourney 5 月节奏围绕 V8 系列（V8.1 于 2026-04-30 发布，主打 4–5 倍速度提升）、改进版 Conversation Mode、--no 参数及后续 V8.2 等；社区/第三方在 5 月底至 6 月初有"V8.2 + 6 月预告"汇总视频，但 V8.2 在 05-24~05-30 窗口内的确切官方发布日期未公开核实。注：V7 早已于 2025-04-03 发布、2025-06-17 转为默认。
- 关键数据：V8.1 渲染速度约为旧版 4–5 倍（来源：Midjourney 官方文档 https://docs.midjourney.com/hc/en-us/articles/32199405667853-Version，发布 2026-04-30，窗口前）
- 原文链接：https://docs.midjourney.com/hc/en-us/articles/32199405667853-Version
- 影响判断：产品迭代极快但本周无窗口内确证的标志性发布；主线已从 V7 推进至 V8 系列。

### 阿里云（通义千问 Qwen / 夸克 AI）
- 本周动态：① 2026-05-26，阿里云在新加坡举办首届国际通义千问大会（Qwen Conference），面向全球客户发布升级版模型、AI 基础设施、AI-native 平台与 AI agent 系列产品，并启动为本地 1000+ 中小企业与学生培训生成式/agentic AI 技能的生态计划；② 2026-05-29 晚（布达佩斯），阿里巴巴与欧足联（UEFA）、UC3 宣布达成多年战略合作，成为欧冠等三大男足俱乐部赛事（2027/28~2032/33 共 6 届）及 2028 欧洲杯的官方独家 AI、云计算及电商合作伙伴，将以千问大模型支持球迷互动与内容管理。（注：旗舰模型 Qwen3.7-Max、真武 M890 AI 芯片等密集发布在 5/20 杭州阿里云峰会，窗口前一日）
- 关键数据：合作覆盖 2027/28 赛季起 6 届欧足联男子俱乐部赛事 + 2028 欧洲杯（来源：新浪财经 2026-05-30 https://finance.sina.com.cn/tech/2026-05-30/doc-inhzrvnv7096469.shtml）；新加坡大会培训规模 1000+ 中小企业与学生（来源：Media OutReach 2026-05-26 https://www.media-outreach.com/news/singapore/2026/05/26/466902/）
- 原文链接：https://www.alibabacloud.com/en/press-room/alibaba-cloud-unveil-advanced-agentic-ai-ecosystem
- 影响判断：阿里 AI 全球化与品牌曝光双线推进；以体育顶级 IP + 海外大会强化 Qwen 的国际心智，配合 C 端"千问"App 形成"模型出海 + 入口卡位"组合拳。

### 智谱（GLM / 智谱清言）
- 本周动态：窗口内属于关键决策的临界期——多家媒体披露公司用于披露 H 股募资使用进度的时间节点为 2026-05-29（截至该日港股 IPO 净额约 49 亿港元中已用约 20.58 亿、余约 28.39 亿港元）；正式"拟发行 A 股并在科创板上市、拟募资不超过 150 亿元"的董事会决议与港交所公告落在 2026-06-01（窗口后一日）。故窗口内（05-24~05-30）无独立的重大产品/融资公开发布，A 股科创板计划本身为窗口外事件。
- 关键数据：拟科创板募资 ≤150 亿元（基座大模型 120 亿 + MaaS 平台 20 亿 + 补流 10 亿）；港股已用资金截至 2026-05-29 约 20.58 亿港元（来源：虎嗅 2026-06-02 https://www.huxiu.com/article/4863969.html；新浪财经 2026-06-01 https://finance.sina.com.cn/wm/2026-06-01/doc-inhzxrnc4967768.shtml）。以上披露主体事件在窗口边缘/之后
- 原文链接：https://finance.sina.com.cn/wm/2026-06-01/doc-inhzxrnc4967768.shtml
- 影响判断：智谱推进"A+H"双资本平台，资金重投基座模型；事件虽紧贴窗口但主体公告在 6/1，本周窗口内无确证大事件。

### 月之暗面（Kimi K2）
- 本周动态：本周无重大公开动态。5 月相关事件集中在月初——5 月初媒体披露拟以投前估值约 180 亿美元、推进新一轮约 10 亿美元融资（前一轮逾 7 亿美元、136 亿元人民币融资为国内大模型最大单笔），并传出考虑赴港 IPO；最新模型 Kimi K2.6 于 2026-04-21 发布开源，均不在 05-24~05-30 窗口内。
- 关键数据：拟融资约 $10 亿、投前估值约 $180 亿（约 1200 亿元人民币）；来源为 5 月初报道（新浪财经 2026-05-07 https://finance.sina.com.cn/stock/t/2026-05-07/doc-inhwzrtp2947696.shtml），窗口前
- 原文链接：https://finance.sina.com.cn/stock/t/2026-05-07/doc-inhwzrtp2947696.shtml
- 影响判断：窗口内无新动作；估值与 IPO 叙事仍在发酵，处于上一轮融资消息后的窗口空档。

### MiniMax（海螺 / abab）
- 本周动态：2026-05-29，MiniMax Group Inc. 与中信证券签署辅导协议，正式启动 A 股 IPO 辅导备案，拟冲刺上海证券交易所科创板（律所为通商、会计师为安永华明）；中国证监会官网披露该备案。继 1 月港股上市后，启动"A+H"双平台布局，与智谱并称"大模型双雄会师 A 股"。（公司随后于 5/31 在港交所公告确认探究发行 A 股建议）
- 关键数据：辅导协议签署日 2026-05-29；辅导机构中信证券（来源：证券时报 https://www.stcn.com/article/detail/3936167.html；东方财富 2026-05-31 https://wap.eastmoney.com/a/202605313755197369.html）
- 原文链接：https://www.stcn.com/article/detail/3936167.html
- 影响判断：国产大模型公司密集冲刺 A 股科创板，资本路径从港股延伸到境内；MiniMax 借多模态（海螺视频/音频）与 M 系列模型的商业化进展支撑估值与上市叙事。

### 腾讯（混元 / 元宝）
- 本周动态：本周无重大公开产品发布。5 月腾讯 AI 焦点集中在月初/中——混元 3.0（HY3）在 OpenRouter 周调用量登顶（5/7 披露 3.66 万亿 Token）、Q1 财报（5/14 前后）及股东大会上马化腾回应"AI 是否落后"等，均不在 05-24~05-30 窗口内；更大尺寸旗舰模型据称仍在训练中。
- 关键数据：混元 3.0 总参数 2950 亿/激活 210 亿、256K 上下文、首响应提速 54%；元宝 MAU 约 5735 万（2026-03，QuestMobile）；2025 年混元+元宝投入 180 亿元、2026 预计翻倍至 360 亿元+（来源：界面新闻 2026-05-13 https://www.jiemian.com/article/14420872.html）。以上均为窗口前数据
- 原文链接：https://www.jiemian.com/article/14420872.html
- 影响判断：窗口内无新里程碑；腾讯仍处"重建混元、先服务内部生态、缓称王"的追赶阶段，等待下一代旗舰模型验证。

## B组洞察
本周（05-24~05-30）垂直 Agent 西方阵营整体进入"融资后消化期"——Cursor/Perplexity/Cognition/Harvey/Sierra 的大事件均落在窗口之前，唯一确证的窗口内硬新闻是 Glean ARR 突破 3 亿美元（15 个月 3 倍增长），印证"企业 AI 搜索/上下文图谱 + 帮客户降本"已成可兑现的商业主线、且老牌先发者在巨头围攻下仍加速。中国阵营则明显进入"资本化窗口"：MiniMax 5/29 启动 A 股科创板辅导、智谱紧随其后（6/1 公告）推进"A+H"，国产大模型从拼模型转向拼资本平台与全球化卡位（阿里 5/26 新加坡 Qwen 大会 + 5/29 牵手欧足联）。一句话趋势：西方比"赚钱效率"、中国比"上市与出海速度"，二者共同指向 AI 商业化与资本化的双重提速。


## 板块：C组

**时间窗：2026-05-24（周日）→ 2026-05-30（周六）｜上海时区｜研究员：黄山**

---

### Codex CLI（OpenAI编程Agent）
- 本周动态：5月29日发布 Codex app 26.527，"Computer Use"（计算机操作能力）正式支持 Windows 平台，并新增 Windows 移动端访问。
- 关键数据：版本 26.527，发布日期 2026-05-29（来源：OpenAI Codex Changelog）。SWE-bench 方面，OpenAI 已宣布停止报告 SWE-bench Verified（因发现前沿模型存在训练数据污染），转向 Scale AI 的 SWE-Bench Pro。
- 原文链接：https://developers.openai.com/codex/changelog
- 影响判断：Computer Use 落地 Windows 标志着编程Agent从纯代码编辑走向跨应用桌面自动化，扩大了企业级用户覆盖面。

### OpenCode（开源AI编程Agent）
- 本周动态：5月30日发布 v1.15.13（opencode-agent），持续高频迭代，核心改进涉及工作区管理、会话迁移、AWS Bedrock OpenAI模型支持、技能发现与基于文件的Agent加载等（部分功能在随后6月版本合入）。
- 关键数据：v1.15.13 发布于 2026-05-30 23:40（来源：GitHub anomalyco/opencode releases）。
- 原文链接：https://github.com/anomalyco/opencode/releases
- 影响判断：保持近乎每日发版的快节奏，多Provider兼容（Bedrock/Copilot/SAP AI Core）持续强化，巩固其作为终端开源编程Agent的地位。

### OpenClaw（Agent OS）
- 本周动态：5月30日发布快照（snapshot），主打 beta 编排原语（orchestration primitives）、更严格的输入校验、可见的子Agent状态（subagent state）、插件信任面（plugin trust surfaces）与频道投递修复，推动个人Agent向可靠的"操作基础设施"演进。
- 关键数据：5月30日快照（来源：openclaw.com.au/updates）；2026.5.20 于5月21日成为最新稳定版（含语音跟随、捆绑Policy插件、per-agent本地模型精简模式、xAI设备码OAuth等）。
- 原文链接：https://openclaw.com.au/updates
- 影响判断：把"可重启、可检查、有边界、显式"作为Agent栈的设计原则，强调编排与可观测性，定位为生产级个人Agent OS。

### Hermes Agent（Nous Research，自进化Agent）
- 本周动态：本周处于爆发式增长期，多篇深度技术评测（5月25日 Petronella、5月下旬 Medium "Hermes Agent Advanced" 等）密集发布，聚焦其自进化技能、MCP、子Agent与生产化能力；被广泛称为"2026年增长最快的开源AI Agent框架"。
- 关键数据：上市不足3个月即获 135,000+ GitHub Stars（来源：Medium @jahangir80842，2026-05；称"3个月内"）；支持20+消息平台，MIT许可。配套自进化仓库 hermes-agent-self-evolution（DSPy+GEPA，ICLR 2026 Oral）。
- 原文链接：https://github.com/NousResearch/hermes-agent
- 影响判断：内置"学习闭环"（从经验创建技能并持续改进）是其差异化核心；增速反映开发者对"自托管+跨会话记忆+自进化"Agent范式的强烈需求。

### Google ADK（Agent Development Kit）
- 本周动态：时间窗内（05-24~05-30）无新版本发布。最近的相邻动态为5月20日 Google Cloud 发布的 ADK 推广视频（"从想法到生产级Agent"），以及随后6月4日发布的 v2.2.0（默认模型改为 gemini-3-flash-preview，含破坏性变更）。
- 关键数据：v2.2.0 发布于 2026-06-04（窗口外，来源：GitHub google/adk-python releases）；窗口内未见正式 release。
- 原文链接：https://github.com/google/adk-python/releases
- 影响判断：ADK 持续从"开发工具包"向"Agent执行框架"演进，强调可观测性与企业级编排；本周为相对平静期。

### Claude Code（Anthropic）
- 本周动态：5月28日 Anthropic 发布 Claude Opus 4.8（"温和但切实的提升"），并随之在 Claude Code 中推出"动态工作流"（Dynamic Workflows）——可为大规模任务（如代码迁移）并行派生数百个子Agent（parallel sub-agents），5月29–30日多篇实操指南密集发布。本月初 Code w/ Claude 大会推出的 Managed Agents（自托管沙箱、MCP隧道、Dreaming、记忆公测）持续扩展。
- 关键数据：Claude Opus 4.8 发布于 2026-05-28（来源：Simon Willison's Weblog）；动态工作流文章 2026-05-29/30（来源：MindStudio Blog）。
- 原文链接：https://simonwillison.net/2026/May/28/claude-opus-4-8/
- 影响判断：从单Agent编码迈向"数百并行子Agent"的编排范式，配合Opus 4.8，把大规模代码迁移/重构推向可规模化自动化，强化Claude Code在Agentic编程的领先位置。

### Dify
- 本周动态：时间窗内（05-24~05-30）无新版本发布。最近相邻版本为 5月19日的 v1.14.2（补丁版：安全加固、工作流/知识库可靠性、HITL恢复后追踪修复、Agent基础工作）。
- 关键数据：v1.14.2 发布于 2026-05-19（窗口外，来源：GitHub langgenius/dify releases）；窗口内未见正式 release。
- 原文链接：https://github.com/langgenius/dify/releases
- 影响判断：处于版本间的稳定期，重心放在企业级安全隔离（租户级敏感端点、工具凭证安全）与工作流可靠性打磨。

### Scale AI（SEAL）
- 本周动态：时间窗内无重大独立公开发布。SEAL（Scale Evaluation & Alignment Lab）持续运营其 SWE-Bench Pro 排行榜（1,865个长程任务/41个真实仓库），并因 OpenAI 宣布停用 SWE-bench Verified（训练数据污染）而受益、被更多前沿模型评测引用；相邻动态为5月22日 DeepLearning.AI 对 SEAL 排行榜的科普传播。
- 关键数据：SWE-Bench Pro 公开集 731 任务/总计 1,865 任务（来源：scale.com/leaderboard/swe_bench_pro_public，经 Morph 引用）；窗口内未见 Scale 官方新公告。
- 原文链接：https://scale.com/blog/leaderboard
- 影响判断：随着 Verified 因污染退场，SEAL 的"私有不可作弊数据集"评测方法论价值上升，第三方权威评测地位进一步巩固。

### Cohere（Command R+）
- 本周动态：时间窗内无新模型发布。最近重磅为5月20日发布的 Command A+（窗口外）：218B 稀疏MoE（25B激活）、Apache 2.0 许可、最低2张H100可跑、48语言/128K上下文、原生引用 grounding，定位主权/本地化企业级Agent。
- 关键数据：Command A+ 发布于 2026-05-20（窗口外，来源：codersera / Las Vegas Sun）；218B参数、25B激活、Apache 2.0。窗口内未公开新动态。
- 原文链接：https://lasvegassun.com/news/2026/may/20/cohere-releases-command-a-an-open-source-enterpris
- 影响判断：Command A+ 是 Cohere 首个真正 Apache 2.0 的前沿级模型，对"开放企业模型"格局形成冲击；本周为发布后的消化期。

### SSI（Safe Superintelligence，SSI-1）
- 本周动态：时间窗内无官方公开动态。SSI 保持一贯的低调"直达超级智能"路线，无产品发布、无公开博客。相邻背景：估值约320亿美元、累计融资超30亿美元，Ilya Sutskever 任CEO；近期有早期工程师 Shahar Papini 离职创办 AI 验证公司 Attestable。
- 关键数据：估值约 $32B、融资 >$3B（来源：Calcalist；具体日期未在窗口内）；窗口内 SSI 无公开信息。
- 原文链接：https://www.calcalistech.com/ctechnews/article/sjik6rzdwl
- 影响判断：SSI 维持"无产品周期、不受短期商业压力干扰"的纯研究姿态，公开信息稀少属常态；其动向主要通过人才流动间接可见。

## C组洞察：
本周AI Agent生态呈现"编排深化、跨端落地、评测重构"三条主线：① 编排范式跃迁——Claude Code 推动"数百并行子Agent"动态工作流、OpenClaw 强化编排原语与可观测性，Agent正从单体走向可规模化的多Agent协同；② 跨端与跨Provider落地——Codex Computer Use 登陆 Windows、OpenCode 持续扩展 Bedrock/Copilot 多Provider兼容，编程Agent从代码编辑走向桌面级自动化与厂商无锁定；③ 自进化与评测信任重构——Hermes 以"内置学习闭环"成为增长最快开源框架（135K+ Stars），而 SWE-bench Verified 因污染退场、Scale SEAL 的不可作弊私有评测价值上升。整体看，框架层竞争焦点已从"能否调用工具"转向"能否可靠编排、跨会话进化、并被可信评测"。


## 板块：D组

> 时间窗：2026-05-24（周日）00:00 → 2026-05-30（周六）24:00（上海时区）
> 研究员：黄山 | 生成日期：2026-06-05

---

### NVIDIA（GPU/CUDA/Blackwell）
- 本周动态：5月27日 GTC Taipei 2026 主题演讲，黄仁勋宣布将在台湾每年投资额从约100亿提升至最高1500亿美元、年底动工"Constellation"新园区，并发布面向"智能体时代"的 Vera Rubin pod 级系统与 Vera CPU。
- 关键数据：台湾年投资将达 1500亿美元/年（vs 4–5年前的100–150亿）；新园区可容纳4000名员工、2030年启用；上季营收创纪录 816亿美元、本季指引 910亿美元（来源：https://www.cnbc.com/2026/05/27/nvidia-taiwan-investment-150-billion-spending.html，2026-05-27）。
- 原文链接：https://www.cnbc.com/2026/05/27/nvidia-taiwan-investment-150-billion-spending.html ；https://siliconangle.com/2026/06/01/five-thoughts-nvidia-ceo-jensen-huangs-gtc-taipei-2026-keynote/
- 影响判断：NVIDIA 把叙事从"卖GPU"升级为"AI工厂基础设施 + 智能体token经济"，并以巨额台湾投资绑定TSMC供应链；Vera Rubin 强调每瓦token吞吐即营收，重塑数据中心采购的经济学逻辑。

### AWS（Bedrock/Trainium/SageMaker）
- 本周动态：5月27日 Amazon Bedrock 扩展 Service Quotas 支持；5月28日 Business Insider 独家披露 AWS 正洽谈将 SpaceX（已收购xAI、更名SpaceXAI）最新 Grok 模型上线 Bedrock，模型已交付AWS、上线在即。
- 关键数据：Grok 上线 Bedrock 的具体时间未公开；AWS 称 Bedrock 为"近十年增长最快的服务之一"，目标打造"全球最大推理引擎"（来源：https://www.businessinsider.com/amazon-spacex-grok-models-ai-offering-bedrock-2026-5，2026-05-28）。
- 原文链接：https://www.businessinsider.com/amazon-spacex-grok-models-ai-offering-bedrock-2026-5 ；https://aws.amazon.com/about-aws/whats-new/2026/5/amazon-bedrock-service-quotas/（2026-05-27）
- 影响判断：AWS 持续把 Bedrock 做成"全模型超市"（Anthropic/Meta/Cohere/OpenAI + 拟加Grok），与微软、Oracle 在多模型托管上正面竞争；Grok 借 Bedrock 触达海量企业客户，亦服务于 SpaceX IPO 前的商业化叙事。

### Azure（Azure AI/OpenAI Service）
- 本周动态：本周窗口内（05-24~05-30）微软未见以该精确日期标注的 Azure AI/OpenAI Service 重大独立发布；当月（5月）Foundry 侧更新集中在 GPT Realtime 2.0（preview）、GPT Realtime Translate、GPT Realtime Whisper 等实时语音/翻译/转录概念文档，但官方文档时间戳为5月18日及月度汇总，落在本窗口之前。
- 关键数据：未公开（无落在05-24~05-30精确日期的Azure官方发布数据）。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry-classic/openai/whats-new ；https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-may-2026/
- 影响判断：Azure 本周云业务无确证的窗口内单点大新闻，节奏更多体现为5月整月的实时多模态模型（Realtime 2.0/Translate/Whisper）铺开；与AWS本周的"抢模型"动作相比，微软侧更偏产品文档与能力沉淀。

### 宇树科技 Unitree（H1/G1）
- 本周动态：5月28日—30日，宇树携人形机器人亮相天津"世界智能博览会2026"（World Intelligence Expo 2026），其人形机器人现场进行拳击对抗（出拳、踢腿、摔倒后恢复等高动态动作）成为embodied AI展区焦点；展会5月28日开幕、5月30日向公众开放，逾700家展商参展。
- 关键数据：展会展区总面积13万平方米、含具身智能等7大展区（来源：https://eng.yidaiyilu.gov.cn/p/0O3RTJ32.html，2026-05-29；https://www.globaltimes.cn/page/202605/1362322.shtml，2026-05-30）。注：宇树科创板IPO过会发生在6月1日，落在本窗口之外，故不计入本周动态。
- 原文链接：https://eng.yidaiyilu.gov.cn/p/0O3RTJ32.html ；https://www.globaltimes.cn/page/202605/1362322.shtml
- 影响判断：宇树以高动态运动控制能力（拳击/平衡恢复）持续强化"运动控制最强"的品牌标签，为紧随其后的科创板上市造势；但其短板仍在"具身大脑"，运动表演式曝光多于产业级闭环落地。

### 优必选 UBTech（Walker S）
- 本周动态：5月28日开幕的天津"世界智能博览会2026 / 世界智能产业博览会"上，优必选展出 Walker S2 工业人形机器人，与宇树 G1 同台成为展会人形机器人代表机型；本届展会首次为人形机器人与AI单设展馆。
- 关键数据：Walker S2 此前披露月产能超300台、2025年产能破1000台、交付超500台，计划2026年将年产能提升至万台规模（来源：https://pdf.dfcfw.com/pdf/H3_AP202512281809997870_1.pdf，2025-12-28，为窗口前背景数据）。本窗口内无新增官方数字，记为"—"。
- 原文链接：https://www.instagram.com/reel/DY7sBoFAGHp/ ；https://eng.yidaiyilu.gov.cn/p/0O3RTJ32.html
- 影响判断：优必选延续"工业落地"路线，以 Walker S2 在制造/物流场景的量产叙事区别于偏表演的同业；天津展会主要是品牌与产业能力展示，本周窗口内无重大新签约或新品发布的确证公开信息。

### Figure AI（Figure 02）
- 本周动态：5月26日，Figure 宣布与零售控股集团 Catalyst Brands（旗下含 JCPenney、Aéropostale、Brooks Brothers）签署商业协议，将 Figure 人形机器人部署至其分销与物流网络，首站落地内华达州 Reno 配送物流中心，自动化供应链中体力密集型任务。
- 关键数据：部署规模/机器人数量/合同金额未公开；该协议为 Figure 与 Brookfield 旗下组合公司的首个商业落地（Brookfield 同为双方共同投资人）（来源：https://www.figure.ai/news/figure-signs-agreement-with-catalyst-brands，2026-05-26；https://corporate.jcpenney.com/2026/05/26/catalyst-brands-taps-figure-ai-for-humanoid-automation/，2026-05-26）。
- 原文链接：https://www.figure.ai/news/figure-signs-agreement-with-catalyst-brands
- 影响判断：Figure 把商业化重心压在零售/物流仓配场景，借共同投资人 Brookfield 打通"组合公司"渠道，验证人形机器人作为控股集团增长引擎的"playbook"；从技术演示（50小时无干预分拣）转向真实商单，是其本周最具含金量的进展。

## D组洞察
本周（05-24~05-30）出现"算力底座"与"具身落地"两条主线的同频共振：NVIDIA 在 GTC Taipei 把叙事升级为"AI工厂 + token即营收"的智能体经济，并以1500亿美元/年绑定台湾供应链；云侧 AWS 持续以多模型超市（拟加Grok）扩张 Bedrock 推理版图，Azure 本周相对低调。与此同时，具身智能进入"商单与资本"验证期——Figure 拿下 Catalyst Brands 零售物流商单，中国宇树/优必选在天津世界智能博览会高调亮相、宇树紧接着冲刺科创板上市。趋势判断：2026 年中，人形机器人正从"运动表演/技术演示"快速切换到"产业订单 + 公开市场定价"，而上游算力厂商则把"每瓦token吞吐"确立为新的经济与采购标尺。

