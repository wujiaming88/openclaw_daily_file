# 全球 AI Agent 基础设施研究周报 · 第 1 期

> 覆盖区间：2026-06-11（周四）00:00 → 2026-06-17（周三）24:00（上海时区）
> 生成日期：2026-06-18（周四）｜聚焦：Agent 基础设施（运行时 / 编排层 / 框架托管），非应用层、非全行业泛报
> 覆盖对象：11/11（A 组 3 云厂 100% + 字节 Coze 必覆盖；n8n 作动态对象池纳入）

---

## 📌 本期 TOP 5（按对基础设施格局的信号价值排序）

1. **AWS AgentCore harness 正式 GA + Managed Knowledge Base + 原生 Web Search（6/17 AWS Summit New York）** — 三大云厂里本周信息量最大的一家。harness GA 把开发门槛从"写编排循环"降到"写配置"，model-agnostic 且支持会话中途切换 provider 不丢 context，叠加托管 RAG 与"零数据外流"Web 搜索，把竞争推进到"知识接入+持续改进+边缘治理"的全栈深水区。
2. **Anthropic Claude Fable 5 / Mythos 5 发布（6/12）** — "模型即长程 agent 引擎"叙事的新高度：长任务记忆增益约 Opus 4.8 的 3 倍，Stripe 用其在 5000 万行 Ruby 代码库一天完成本需两个月的全库迁移；定价 $10/$50 每百万 token，叠加 30 天强制留存新政，直接拉高 Claude Agent SDK 长程场景天花板。
3. **Databricks Agent Bricks 升级为综合性开发者 Agent 平台（DAIS 2026，6/16）** — 平台已构建 10 万+ agents、年处理超 1 quadrillion tokens，新增 Kimi 支持并与 SpaceX 合作把 Grok 原生接入；"any model + any harness"中立编排 + 数据治理护城河，标志数据湖仓厂商正式转型企业 Agent 平台厂商。
4. **Google Gemini Enterprise 商业化落地提速 + ADK 2.0 Workflow Runtime** — 本周"产品静默、商业活跃"：Macy's 4 周建成对话式 AI、Randstad onboarding 快 3 倍、A2A 已 150 家组织 production 路由真实任务；ADK 2.0 新增图执行引擎与 Task API，对标 AWS Strands 导出与微软 MAF Workflow。
5. **字节 Coze 3.0 + 开源 Coze Loop 高强度迭代** — 中国 Agent 平台做"开放编排中枢"的关键信号：扣子 3.0（6/1 上线）把 Claude Code/Codex CLI/OpenClaw 纳入同一协作空间；Coze Loop 本周补齐 trajectory/webhook/feedback 等企业级评测运维能力，"社区版引流 + 企业版变现"双轨落地。

---

## A 组｜三大云厂 Agent 托管平台

### Amazon Bedrock AgentCore (AWS)

- **本周动态**：本周是AgentCore近期最密集的发布周——核心引爆点是 **2026-06-17 AWS Summit New York**（VP of Agentic AI 的 Swami Sivasubramanian 做 keynote）。本周AgentCore的更新围绕"让agent知道更多、改进更快、管控更稳"三条主线展开（原文：connecting AI agents to organizational, web, and paid knowledge; helping teams find and fix what's going wrong in production; and enforcing controls that scale as agents grow more capable）。重磅落地项有四：①**AgentCore harness 正式GA**（6/17）——这是把"agent的身体"做成托管能力：harness负责跑 orchestration loop、执行工具、管理context window、跨轮持久化state、失败恢复、会话隔离。开发者不再手写循环，而是用**配置**定义agent的model/tools/skills/instructions，AgentCore自动组装并运行，"分钟级"产出生产级agent，自带独立隔离环境（filesystem+shell）、跨会话memory、AWS策展skills目录、web browsing。关键差异化：harness与model解耦——可任选模型并在**会话中途切换provider而不丢context**（如一个模型做规划、另一个写代码）；需要自定义编排时一条CLI命令即可导出为**Strands-based代码**（Claude Agent SDK导出目标"coming soon"）。已在所有 AgentCore 可用的 AWS Commercial Regions 上线。②**Amazon Bedrock Managed Knowledge Base**——托管RAG管线，含native data connectors、Smart Parsing（多格式自动数据准备）、Agentic Retriever（复杂多步查询），全部与 **AgentCore Gateway** 集成。③**Web Search on AgentCore**——全托管web搜索工具，让agent基于当前、带引用的web知识作答，且**零数据外流（zero data egress）**于客户安全AWS环境内。④**AWS WAF 新增 AI traffic monetization**——内容方可对访问其内容/API的AI bot与agent定价、计量、收款（边缘侧授权）。整体路线判断：AWS正把AgentCore从"原语集合"推向"端到端托管agent平台"，harness GA是把开发门槛从"写编排循环"降到"写配置"的关键一跃，model-agnostic + 中途切换provider是直接对标对手锁定的杀招。
- **关键数据**：harness GA 日期 = 2026-06-17（来源：https://aws.amazon.com/about-aws/whats-new/2026/06/amazon-bedrock-agentcore-harness-generally-available/ ，2026-06-17）；AgentCore model-agnostic 支持 OpenAI/Gemini/Claude/Nova/Llama/Mistral（来源：https://aws.amazon.com/bedrock/agentcore/faqs/ ）；可用区域=所有 AWS Commercial Regions where AgentCore is available（来源同harness公告）。
- **原文链接**：https://aws.amazon.com/blogs/aws/top-announcements-of-the-aws-summit-in-new-york-2026/ ；https://aws.amazon.com/blogs/machine-learning/new-in-amazon-bedrock-agentcore-build-agents-with-broader-knowledge-and-continuous-learning/ ；https://aws.amazon.com/about-aws/whats-new/2026/06/amazon-bedrock-agentcore-harness-generally-available/
- **影响判断**：这是三大云厂里本周信息量最大的一家。harness GA + Managed Knowledge Base + 原生Web Search 把"知识接入—编排—持续改进"补成闭环，直接抬高Google/Microsoft的对标门槛；"零数据外流"web search与WAF的AI内容计费是企业合规与内容经济两个新战场的卡位信号。

---

### Microsoft Foundry Agent Service (Azure AI Foundry)

- **本周动态**：本周窗口内（6/11–6/17）微软的"重磅级"发布主要发生在Build 2026之后的常规节奏里——注意：**Microsoft Build 2026本身是6月2–3日（背景，非本周）**，本周是其后续GA/preview的落地与文档化。①**Benchmarks in Microsoft Foundry（preview）正式上线**（Azure Charts记录 2026-06-15 13:00 UTC，社区博客约6/13发布）——这是把"标准化模型与agent质量检查"做进Foundry：开发者可挑选推理类基准（如 GPQA Diamond、MuSR）针对某个agent（及其版本）运行，在更换底层模型/系统提示/工具集时把基准分当作"稳定标尺"作横向对比；从agent详情页的Evaluation标签可打开同一向导并scope到该agent（来源：techcommunity.microsoft.com benchmarks-in-microsoft-foundry-preview 文章）。②**A Guided Tour of the New Microsoft Foundry Labs**（Azure Charts记录 2026-06-15 23:41 UTC）——Foundry Labs作为实验性能力的入口被重新梳理。③本周内仍在兑现Build 2026承诺的关键节点：**hosted agents的Tracing与Evaluation"将于2026年6月晚些时候GA"**（来源：devblogs Foundry agent-service-build2026），即本窗口正处于该GA落地前夕；**incoming A2A**（agent对外暴露A2A端点）处于public preview。背景补充（非本周，6/8）：Foundry的agent安全能力在Microsoft Defender for Cloud中正过渡到 **Microsoft Agent 365** license（Azure Updates记录 2026-06-08）。技术路线判断：微软的差异化在"开放信任栈"——Build 2026推出的开源评测ASSERT、开放标准Agent Control Specification(ACS)、Rubric评估器，加上本周的Benchmarks(preview)，构成"policy→evaluation→runtime control→production confidence"闭环；同时Microsoft Agent Framework(MAF) 已GA(1.0，4月)，本周GitHub仍在主推 **Foundry Hosted Agents（"2行代码部署托管")**、Workflow图编排、A2A/Azure Functions/Durable Task hosting，跨Python与.NET双栈、支持Foundry/Azure OpenAI/OpenAI/GitHub Copilot SDK。整体看微软把"可信、可观测、跨框架"作为对AWS/Google的卡位点。
- **关键数据**：Benchmarks(preview) 上线 = 2026-06-15 13:00 UTC（来源：https://azurecharts.com/updates?search=1&service=147 ）；Foundry Labs guided tour = 2026-06-15 23:41 UTC（同上）；hosted agents Tracing/Eval GA = "later in June 2026"（来源：https://devblogs.microsoft.com/foundry/agent-service-build2026/ ）；MAF GitHub 提供 Python+.NET 双栈、Foundry Hosted Agents "2行代码"部署（来源：https://github.com/microsoft/agent-framework ）；Star数=未能从页面文本提取（需直查stargazers页）。
- **原文链接**：https://azurecharts.com/updates?search=1&service=147 ；https://devblogs.microsoft.com/foundry/agent-service-build2026/ ；https://github.com/microsoft/agent-framework ；https://learn.microsoft.com/en-us/azure/foundry-classic/agents/whats-new
- **影响判断**：微软本周无"惊雷级"独立大发布，但Benchmarks(preview)把"agent质量可量化、可回归"做进托管平台，正面回应企业"agent上线后好坏无从判断"的痛点；叠加6月晚些时候hosted agent Tracing/Eval GA，微软在"可观测+可评测"这条线上对AWS AgentCore Observability、Google Agent评估形成正面竞争。注意classic Agents已宣布2027-03-31退役，迁移压力是客户侧近期变量。

---

### Google Vertex AI Agent Engine + Agent Builder + ADK / Gemini Enterprise Agent Platform (Google Cloud)

- **本周动态**：本窗口内（6/11–6/17）Google的"产品级release notes"在Vertex AI官方页面上**无新增条目**（gen-AI release notes最近一条为5/26 Extensions弃用，再上为4月，本周静默）；但**生态与商业化侧在本周非常活跃**，主战场是 **Google Cloud London Summit 2026（约6/16–6/17）** 与持续的客户落地：①**Macy's "Ask Macy's" AI Agent**——基于 Gemini Enterprise 在"4周"内构建上线的对话式AI（来源：Google Cloud Press Corner，2026-06-17 LONDON/PRNewswire 稿，新方案为含Myprotein在内品牌带来"significant performance uplift"）。②**Randstad Digital × Google Cloud**（2026-06-11）——用 Gemini Enterprise 让工程师**onboard速度最高快3倍**。③**Smals（比利时公共部门）**（2026-06-11）——用Google公有云强化IT基础设施。④背景（非本周，但本周仍在Marketplace推进）：**Oracle AI Database Agent for Gemini Enterprise** 进入preview（Cloud Next 2026公布，Google Marketplace上架）。产品架构层面需厘清：Google已把原"Vertex AI / Agent Builder"统一演进为 **Gemini Enterprise Agent Platform**（Cloud Next 2026，2026-04发布，背景），围绕 **Build / Scale / Govern / Optimize** 四支柱组织：Build含ADK、Agent Studio、Agent Garden、Managed Agents API（config-driven、REST-first、托管sandbox）；Scale含Agent Runtime（亚秒级冷启动、长时运行agent）、Sessions、Memory Bank、Code Execution；Govern含Agent Registry、Agent Identity、Agent Gateway+Model Armor、Governance Policies、AI威胁扫描；Optimize含Agent evaluation（Multi-Turn AutoRaters、Online Evaluation）、Unified Trace Viewer、prompt优化。开发框架侧 **ADK** 仍在快速迭代——GitHub google/adk-python README显示已进入 **2.0（含BREAKING CHANGES）**，新增 **Workflow Runtime**（图执行引擎：routing/fan-out-in/loops/retry/state/human-in-the-loop/嵌套workflow）与 **Task API**（结构化agent-to-agent委派），发布节奏"约双周一次"，Apache 2.0、Python 3.10+。A2A协议背景：A2A已从最初50+伙伴扩展到"150家组织在production路由真实任务"（来源：thenextweb Cloud Next报道，背景）。技术/商业路线判断：Google本周打法是"用客户logo和落地速度（4周建Macy's、3倍onboarding）讲商业化故事"，而非发新组件，反映其Gemini Enterprise Agent Platform已过"发布期"进入"采用证明期"。
- **关键数据**：Macy's "Ask Macy's"=4周构建、Gemini Enterprise驱动（来源：https://www.googlecloudpresscorner.com ，2026-06-17）；Randstad Digital onboarding"最高快3倍"（来源：同上，2026-06-11）；A2A=150家组织production（来源：https://thenextweb.com/news/google-cloud-next-ai-agents-agentic-era ，背景）；Agent Engine定价=2026-01-28起 Sessions/Memory Bank/Code Execution开始计费、Runtime已降价（来源：https://docs.cloud.google.com/vertex-ai/generative-ai/docs/release-notes ，背景2025-12-16）；ADK已至2.0含Workflow Runtime+Task API（来源：https://github.com/google/adk-python ）。
- **原文链接**：https://www.googlecloudpresscorner.com ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/overview ；https://github.com/google/adk-python ；https://docs.cloud.google.com/vertex-ai/generative-ai/docs/release-notes
- **影响判断**：Google本周"产品静默、商业活跃"，与AWS Summit NY的"产品轰炸"形成鲜明对比——说明Google把Cloud Next 2026的平台红利转化为客户落地（零售Macy's、人力Randstad、公共部门Smals、伙伴Oracle），用"4周/3倍"这类可量化ROI对冲AWS的功能密度。ADK 2.0的Workflow Runtime+Task API是开发者侧对标AWS Strands导出、微软MAF Workflow的关键一手。

---

## 本组洞察（三大云厂格局变化）

本周最强信号来自**AWS的"功能轰炸"对Google"商业静默"的镜像对比**：AWS Summit New York（6/17）一口气把 AgentCore harness GA、Managed Knowledge Base、原生Web Search（零数据外流）、WAF AI内容计费四件套打包推出，把竞争焦点从"能不能托管agent"推进到"知识接入+持续改进+边缘治理"的全栈深水区；Google则反其道而行，本周不发新组件，转而用 Macy's（4周上线）、Randstad（onboarding快3倍）等客户logo证明 Gemini Enterprise Agent Platform 的落地ROI；微软居中，以 Benchmarks(preview)+即将GA的hosted agent Tracing/Eval 卡位"可信·可评测"。三家路线已清晰分化：**AWS拼组件密度与model-agnostic中途切换、Google拼商业落地与A2A生态(150家production)、微软拼开放信任栈(ASSERT/ACS/Rubric/Benchmarks)**。共同趋势是"harness/runtime托管化+知识接入+可观测评测"正成为三家标配战场，agent平台竞争正式进入"生产可靠性与治理"的下半场。

---

---

## B 组｜模型厂商 Agent 平台 + 通用框架

### OpenAI Responses API + Agents SDK（含Swarm谱系演进、AgentKit）

- **本周动态**：本周OpenAI侧Agent基础设施的可见动态集中在三条线。①**openai-agents-python v0.17.5 于2026-06-11发布**（GitHub release页确认，UTC 06-11 04:11），延续"约周更"节奏。本次为纯维护性版本：核心修复包括 `fix: expose sandbox error retryability`(#3581)、把 tool-end hook 结果类型化为 object(#3518)、`SpeechGroupSpanData __slots__` 采用 tuple 形式(#3534)、Modal sandbox extra 升级到 1.4.3(#3538)；其余为文档/测试改进（新增 MongoDB session 示例、MCP 参数 docstring 修订、`_openai_retry` 覆盖率从77%→95%）。无新组件 GA，无 API 破坏性变更，说明 SDK 已进入稳定打磨期，重心在 sandbox 沙箱、MCP 传输与 Realtime 语音的可靠性。②**平台侧**：6/11 ChatGPT/Codex 大版本（Codex app 26.609 / CLI 0.140.0）落地，新增 rate-limit reset banking、Developer mode（受控 Chrome DevTools Protocol 访问做性能剖析与网络/控制台调试）、`/init` 生成 AGENTS.md 脚手架、Enterprise 版 Windows 上的 Computer Use；6/16 Codex app 能力扩展至 EEA/UK/瑞士（含 macOS/Windows Computer Use、Chrome 扩展、Memories、Chronicle 研究预览）。③**模型与API**：Responses API 持续作为主力调用面，GPT-5.5（复杂推理/编码）与 GPT-5.4 mini/nano 经 Responses API + Client SDK 提供；6/12 ChatGPT 端正式下线 GPT-5.2（Instant/Thinking/Pro）并迁移至 GPT-5.5。Assistants API 仍处于"2026年内弃用、由 Responses API 吸收全部能力"的既定路线（背景）。技术/商业判断：OpenAI 的 Agent 战略已明显从"开发者 SDK 原语"上移到"产品化 Codex + Responses API 托管面"，Computer Use 的区域合规扩张（EEA/UK/瑞士）是本周最具商业意义的信号——把桌面操作能力推向受监管市场。
- **关键数据**：openai-agents-python v0.17.5 发布于 2026-06-11（https://github.com/openai/openai-agents-python/releases ，06-11 04:11 UTC）；Codex CLI rust-v0.140.0、Codex app 26.609 于 2026-06-15 前后（https://releasebot.io/updates/openai ）；GPT-5.2 于 2026-06-12 在 ChatGPT 下线（同源）。Stars/营收本周未在官方源公开 → 未公开。
- **原文链接**：https://github.com/openai/openai-agents-python/releases ；https://releasebot.io/updates/openai ；https://developers.openai.com/api/docs/models
- **影响判断**：①SDK 进入稳定期、平台层（Codex+Responses）成为创新主战场，预示 OpenAI 把"Agent 基础设施"定义为托管产品而非纯库。②Computer Use 向欧洲受监管区扩张，是与 Anthropic Computer Use 正面竞争的合规护城河动作。③Assistants→Responses 的统一仍在推进，开发者迁移压力将在 2026 下半年集中释放。

---

### Anthropic Claude Agent SDK + MCP（MCP协议演进、Claude Agent SDK release、Computer Use进展）

- **本周动态**：本周Anthropic侧是B组最重磅的一周，主线是**6/12 同时发布 Claude Fable 5 与 Claude Mythos 5**（Anthropic 官方 news，原文见下）。Fable 5 是“Mythos 级、面向通用安全使用”的旗舰模型，号称在几乎全部能力基准上 SOTA，软件工程、知识工作、视觉、科研均领先；定价 **$10/百万输入 token、$50/百万输出 token**，不到 Claude Mythos Preview 的一半。对 Agent 基础设施的直接含义：①**长任务自主性大幅提升**——官方称 Fable 5 能比以往任何 Claude 模型工作更久，在带文件型持久记忆的长任务中表现提升是 Opus 4.8 的三倍；早期客户 Stripe 报告 Fable 5 在 5000 万行 Ruby 代码库中一天完成本需团队两个月的全库迁移，直接利好 Claude Agent SDK 的长程 agentic 场景。②**Computer Use/视觉**：Fable 5 成为视觉新 SOTA，可从截图重建 Web app 源码、用纯视觉极简 harness 通关 Pokémon FireRed，意味着 Computer Use 类 agent 的脚手架需求下降。③**新数据留存政策**：对 Mythos 级模型一二三方流量强制 30 天留存（不用于训练，仅用于防御新型 jailbreak/跨请求攻击），这是 agent 部署侧合规的新变量。安全侧 Fable 5 引入分类器，命中网络安全/生物化学/蒸馏类请求时自动回退至 Opus 4.8，官方称 >95% 会话不触发回退；Mythos 5 仅限 Project Glasswing 网络防御伙伴（与美政府合作）。订阅制 6/12–6/22 免费含 Fable 5，6/23 起需用量额度。**Claude Agent SDK（Python）本周高频迭代**：GitHub release 显示 06-11/06-12(×3)/06-13/06-15/06-16/06-17 多次发版，其中 **v0.2.101 于 2026-06-13 发布**（PyPI claude-agent-sdk 0.2.101，捆绑 Claude CLI 2.1.177），核心是把 system/task_updated 终态事件类型化为 TaskUpdatedMessage（含 task_id/patch/status/session_id/uuid），修复后台任务在无 TaskNotificationMessage 时消费者挂起的问题，并新增 TERMINAL_TASK_STATUSES 便于活动任务记账(#1016)——表明 SDK 正强化“后台/长时 agent 任务”的可靠生命周期管理。MCP 侧本周无重大协议版本跳变，MCP Apps（向 Claude/ChatGPT 等宿主交付交互式 UI）持续为生态背景（背景，非本周）。
- **关键数据**：Fable 5 / Mythos 5 发布 2026-06-12，定价 $10/$50 每百万 token；claude-agent-sdk v0.2.101 发布 2026-06-13，捆绑 Claude CLI 2.1.177；>95% 会话无安全回退、长任务记忆增益约 Opus 4.8 的 3 倍。来源：https://www.anthropic.com/news/claude-fable-5-mythos-5 、https://github.com/anthropics/claude-agent-sdk-python/releases 、https://pypi.org/project/claude-agent-sdk/0.2.101/ 。GitHub Stars 本周未在官方源核实 → 未公开。
- **原文链接**：https://www.anthropic.com/news/claude-fable-5-mythos-5 ；https://github.com/anthropics/claude-agent-sdk-python/releases
- **影响判断**：①Fable 5 把“模型即长程 agent 引擎”的叙事推到新高度，记忆/视觉/自主性提升将直接拉高 Claude Agent SDK 在编码与科研 agent 的天花板。②30 天强制留存政策是企业 agent 部署的新合规摩擦点，可能影响金融/医疗客户选型。③SDK 高频迭代聚焦后台任务生命周期，印证 Anthropic 把“可靠长时运行”作为对抗 OpenAI Codex 托管化的差异点。

---

### LangChain / LangGraph / LangSmith Deployment（LangGraph Platform 托管化、LangSmith 可观测、Deployment 形态）

- **本周动态**：LangChain 生态本周三条线同时推进。①**开源版本**：GitHub release 显示 **langgraph 1.2.5 于 2026-06-12 发布**（#8062），主要为修复类（merge lc_versions config metadata #8052、空 thread 上 deltaChannel 的 updateState bug #8011，并将 Python 类型检查迁到 ty）；**langgraph-cli 0.4.30 于 2026-06-16 发布**（#8101，新增“兼容 API 版本区间”支持 #8023）；cli 0.4.29（06-11，支持以 HTTPS 跑 dev server 传 certfile/cert key #8031）。sdk-py 近期密集引入 v3 streaming primitives、WebSocket 流传输、RemoteGraph v3 streaming（多为 6月初，背景）。②**平台/产品化**：官方博客本周重点是 **LangSmith Fleet（前身为 Agent Builder）的推出**，配套 6/16 发文《Why Fleet Has Both General Purpose Chat and Specialized Agents》；LangSmith 线近期还推出 LangSmith Engine（5/13）、“给 agent 配专属计算机”沙箱能力（6/5）、《How We Made Coding Agent Spend Predictable》（6/15，成本可预测）、《How to Choose the Right Sandbox for Your Agent》（6/12）——主线是把 LangSmith 从“可观测/评估”升级为“agent engineering platform + Deployment”一站式。③**安全事件**：Check Point 本周披露 LangGraph 三个已修复漏洞构成的 RCE 链：CVE-2025-67644（SQLite checkpoint 的 SQL 注入，CVSS 7.3，<3.0.1）+ CVE-2026-28277（msgpack 不安全反序列化，CVSS 6.8，langgraph<1.0.10）可链式达成远程代码执行，另有 CVE-2026-27022（Redis checkpoint RediSearch 查询注入，CVSS 6.5）。**仅影响使用 SQLite/Redis checkpointer 且暴露 get_state_history() 的自托管部署；LangChain 托管平台（LangSmith Deployment）不受影响**。④**客户案例**：6/12 发布 Box AI 案例（企业内容平台用 Deep Agents 走向 AI-native）、6/3 Harmonic 用 Deep Agents 重构 Scout 并借 LangSmith 将留存率提升 4 倍。技术/商业判断：LangChain 正把重心从开源框架转向“托管平台（LangSmith Deployment/Fleet）+ 可观测 + 成本控制”的商业化闭环，且用“托管版不受 RCE 影响”作为推动客户从自托管迁往托管的有力话术。
- **关键数据**：langgraph 1.2.5 发布 2026-06-12、langgraph-cli 0.4.30 发布 2026-06-16（https://github.com/langchain-ai/langgraph/releases ）；CVE-2025-67644 CVSS 7.3 / CVE-2026-28277 CVSS 6.8 / CVE-2026-27022 CVSS 6.5（https://thehackernews.com/2026/06/langgraph-flaw-chain-exposes-self.html ，2026-06）；Harmonic 留存率 4x（LangChain 博客 6/3）。Stars/营收本周未公开。
- **原文链接**：https://github.com/langchain-ai/langgraph/releases ；https://www.langchain.com/blog ；https://thehackernews.com/2026/06/langgraph-flaw-chain-exposes-self.html
- **影响判断**：①LangSmith Fleet/Engine + Deployment 标志 LangChain 完成从“开源库”到“agent engineering platform”的商业定位转型，与 LangGraph Platform 托管化互补。②RCE 漏洞链是本周生态负面信号，但反而强化了“用托管版规避自托管安全负担”的商业逻辑。③Box AI/Harmonic 等企业 logo 落地，表明 Deep Agents + LangSmith 在企业级 agent 落地上势头稳固。

---

### CrewAI AMP（CrewAI平台化进展、Enterprise版、CrewAI Studio）

- **本周动态**：CrewAI 本周核心动态是**开源框架 v1.14.7 于 2026-06-11 发布**（GitHub release，UTC 06-11 17:13，经数个 rc/alpha 收敛而来）。本次为本周期最重要的功能版本，方向明确指向"企业平台化 + 多后端可插拔"：①**可插拔默认后端**——memory/knowledge/rag/flow 均支持 pluggable default backends，locking backend 可覆盖，意味着企业可把记忆/知识/RAG 接到自有基础设施；②**对话式 Flow**——新增 chat API for conversational flows、conversational flow traces、`handle_turn`，把 CrewAI 从"任务编排"扩展到"对话式 agent"；③**企业数据栈集成**——新增原生 Snowflake Cortex LLM provider、Databricks 集成指南、Snowflake 集成指南，直击企业数据平台；④**Flow DSL 重构**——把 flow.py 拆分为 DSL/definition/runtime，FlowDefinition 由 DSL 元数据构建，flow 条件求值改为按事件无状态，提升并发隔离与可维护性；⑤可观测——surface 真实 finish_reason/sampling params/response.id 到 LLM events，更新 OpenTelemetry collector 文档。**企业版（AMP/Agent Control Plane）**：5/28 版本新增 Agent Control Plane (ACP, Beta) 文档与导航、企业版分类化 release notes、Skills Repository（5/21 引入，后移至 experimental + CREWAI_EXPERIMENTAL gate），并强化 StdioTransport 防环境变量泄露、checkpoint 序列化健壮性——这些是 CrewAI 平台化（AMP/ACP）持续推进的具体抓手（部分为背景）。安全侧本版解决 aiohttp/docling/docling-core 的 pip-audit CVE。技术/商业判断：CrewAI 正沿"开源 framework → Enterprise AMP/Agent Control Plane"双层路线推进，本周 Snowflake/Databricks 原生集成是把多 agent 系统嵌入企业数据栈的关键卡位，Agent Control Plane 是其对标 LangSmith Deployment 的托管/治理平面。
- **关键数据**：crewAI v1.14.7 发布 2026-06-11（https://github.com/crewAIInc/crewAI/releases ）；新增 Snowflake Cortex LLM provider、Databricks 集成、chat API for conversational flows（同源 release notes）；ACP(Beta) 文档于 5/28 版本加入（同源，背景）。GitHub Stars/Enterprise 营收/客户 logo 本周未在官方源核实 → 未公开。第三方称"65% 企业已用 AI agent、81% 已规模化或扩张"（agilesoftlabs 博客 6月，非官方，仅供参考）。
- **原文链接**：https://github.com/crewAIInc/crewAI/releases
- **影响判断**：①v1.14.7 的可插拔后端 + Snowflake/Databricks 原生集成，是 CrewAI 把企业数据栈作为护城河的明确信号。②对话式 Flow（chat API）扩展了 CrewAI 的产品边界，从批处理任务走向交互式 agent。③Agent Control Plane (ACP) 持续 Beta 推进，显示 CrewAI 正补齐"托管+治理"平面以对标 LangSmith Deployment 与 OpenAI/Anthropic 的托管化。

---

## 本组洞察

本周B组四大对象共同指向一个清晰主线：**Agent 基础设施正从"开源 SDK 原语"全面转向"托管平台 + 治理平面"的商业化竞赛**。OpenAI 用 Codex+Responses API 把创新上移到托管产品层、SDK 进入稳定期；Anthropic 用 Fable 5 把"模型即长程 agent 引擎"推到新高度，并以 SDK 后台任务可靠性 + 30 天强制留存政策构筑长时运行差异；LangChain 完成从"开源库"到"agent engineering platform"（LangSmith Fleet/Engine/Deployment）的定位转型，并借自托管 RCE 漏洞链反向强化托管版价值；CrewAI 则沿"开源 framework → Enterprise AMP/Agent Control Plane"双层路线，用 Snowflake/Databricks 原生集成卡位企业数据栈。**协议生态层面**，MCP 已成既定底座（OpenAI/Anthropic SDK 均深度内建），本周无协议跳变但 MCP Apps/A2A 仍是生态焦点；**框架托管化**已是不可逆趋势——四家无一例外都在把"可靠长时运行 + 可观测 + 合规治理"作为托管平台的核心卖点，纯开源库的商业天花板正被快速压缩。

---

---

## C 组｜数据 / 开源 / 中国 Agent 平台

### Databricks Mosaic AI Agent Framework / Agent Bricks
- 本周动态：本期最大事件——Databricks 在 **Data + AI Summit 2026（DAIS，6月16日旧金山开幕）** 官方博客发布《Agent Bricks: Data + AI Summit 2026》，宣布将 Agent Bricks 从"实验性 agent 搭建工具"全面扩展为**面向开发者的综合性 Agent 平台（developer agent platform）**。原文关键数据与摘录：自去年 DAIS 首发以来，平台上已构建 **10万+（100k+）agents**，每年处理 **超过 1 quadrillion（千万亿）tokens**；客户包括 AstraZeneca、7-Eleven、Fox Corporation、Block 等已在 Agent Bricks 上发布生产级 agent。Databricks 提出核心论点"the missing 99%"：真正的 agent 主循环只占工作量的 1%，其余 99% 是 token 容量、部署、安全、评测、监控、上下文、共享等"隐藏技术债"。平台围绕三大支柱重构：①**Choice（选择）**——单一平台内集成全部前沿闭源与开源模型，原生纳入安全边界，新增 **Kimi** 支持，并宣布与 **SpaceX 合作把 Grok 模型原生接入 Databricks**（除已有 OpenAI、Anthropic、Gemini、Qwen 外）；支持任意 agent harness，包括开源框架 LangGraph、Agno、CrewAI 以及 Claude Code SDK、OpenAI Agent SDK，并提供其上周末刚开源的 meta-harness **Omnigent** 的托管版用于编排多 harness；②**Context（上下文）**——研究团队在 agentic search、memory scaling、可编程 scratchpad（Memex）、评测（MemAlign）、grounded reasoning（OfficeQA benchmark）等方向落地；用 RL 训练出在 Genie 相关任务上"质量更高且每查询成本远低于 Opus/Sonnet"的自定义数据 agent；③**Control（控制）**——针对 agent 误删代码库、prompt injection 泄密、成本爆炸（员工"tokenmaxing"）等风险提供安全部署与成本控制。技术/商业判断：Databricks 的差异化在于"数据+AI 统一治理"——agent 既消费数据（工具/上下文）又生产数据（输出/动作/推理轨迹/记忆），全部需治理与分析，这是其相对纯 agent 框架厂商的护城河。配套生态信号强烈：Monte Carlo 已推出对 Agent Bricks 的零插桩原生可观测性（同时支持 Knowledge Assistant 托管模板与 Mosaic AI Agent Framework 自定义 agent）。
- 关键数据：100k+ agents 已构建、1 quadrillion+ tokens/年（https://www.databricks.com/blog/agent-bricks-dais-2026 ，2026-06-16/17）；新增 Kimi 模型支持、与 SpaceX 合作接入 Grok（同上）；Omnigent meta-harness 上周末开源（同上）；Monte Carlo 原生可观测性（https://montecarlo.ai/blog-agent-bricks-support ，2026-06-16前后）。
- 原文链接：https://www.databricks.com/blog/agent-bricks-dais-2026 （已 web_fetch 全文）；产品页 https://www.databricks.com/product/artificial-intelligence/agent-bricks
- 影响判断：①Databricks 正式从"数据湖仓厂商"转型为"企业 Agent 平台厂商"，与 Snowflake、微软 Fabric 等正面竞争 agent 基础设施层；②"any model + any harness"的中立编排策略 + 原生 MCP 支持，意在做企业 agent 的"控制平面"而非锁定某框架；③与 SpaceX/xAI 的 Grok 合作是模型供给侧的重要信号，表明前沿模型正快速向企业数据平台聚合。

---

### Dify（langgenius/dify · 开源 LLM 应用/Agent 平台）
- 本周动态：本周 Dify 无大版本发布（最近稳定版仍是 **v1.14.2，2026-05-19**），但 GitHub 主干处于"密集开发期"——本周（06-11→06-18）main 分支提交量被 API 上限 100 截断（即 ≥100 commits/周），强烈信号表明一个**全新 "Agent App / Agent v2" 产品线正在合入**。从本周 commit 流可清晰读出技术路线：①新增 Agent App 后端（"feat: stream Agent App backend deltas"、"feat: app deploy #35670"）；②"Agent v2"运行时（"feat(agent): wire knowledge base retrieval into runtime"、"feat(agent): add Agent Stub drive commands"）；③**Agent roster 可观测性 API**（"feat: add agent roster observability APIs"、"sync generated observability contracts"）；④Service API 的 OpenAPI 契约完善、LLM 轮询（polling）支持（"feat(api): LLM polling support"）；⑤i18n 多语言持续同步。也就是说，Dify 正从"workflow/chatflow 编排平台"向"原生多 Agent（roster）+ 内建可观测性"演进，对标 Coze 的多 Agent 协作与 Coze Loop 的评测/监控能力。生态侧本周一条具体落地：日本理光（Ricoh）将基于 Dify 的 Self-MoA 文档阅读 workflow 加入其本地部署 LLM Kit（On-Prem LLM Kit），印证 Dify 在日本企业私有化市场的渗透。背景（非本周）：Dify 仓库描述已更新为 "Production-ready platform for agentic workflow development"，定位明确转向 agentic。
- 关键数据：GitHub Stars **145,640**、Forks 22,904（https://github.com/langgenius/dify ，2026-06-18 直查）；最新发布 v1.14.2（https://github.com/langgenius/dify/releases ，2026-05-19）；本周 main commits ≥100（API 直查截断，2026-06-18）；理光 On-Prem LLM Kit 集成（https://jp.ibtimes.com/ricoh-adds-self-moa-document-reading-workflow-prem-llm-kit-101703 ，约2026-06-17）。
- 原文链接：https://github.com/langgenius/dify （Stars/commits 直查）；https://github.com/langgenius/dify/releases
- 影响判断：①Dify 用 14.5万 Stars 维持开源 LLM 应用平台头把交椅，但本周"无发版、重开发"说明下一代 Agent 产品仍在路上，面对 Coze 3.0 已上线的多 Agent 协作存在追赶压力；②"Agent roster + 内建可观测性"是把 Coze Loop/LangSmith 类能力收编进核心平台的策略，意在让开源用户少装一层；③理光案例显示其商业化主战场之一在日本/亚太私有化部署。

### 字节 Coze / 扣子（ByteDance · 国内 coze.cn + 海外 coze.com）
- 本周动态：本周覆盖区间内 Coze 无新的大版本发布，但其**开源运维平台 Coze Loop 处于高强度活跃开发**——GitHub coze-dev/coze-loop 本周（06-11→06-17）合入 7 个 commits，方向集中在企业级评测/运维能力：新增 **trajectory（轨迹）OpenAPI**（#552）、**metadata 系统标签**（#548）、**实验 webhook 通知**（#544）、**feedback 反馈指标**（#543），并修复了"Redis 抖动导致实验调度失败后卡死"的稳定性问题（#550）。这与 Coze 的商业化主线一致：Coze Loop 是原付费"企业罗盘"的开源版，主打 Agent 全生命周期评测/Trace/监控，本周更新明显在补齐企业生产环境所需的可观测与通知能力。对照之下，**核心开源仓库 coze-studio 本周无提交**（最后 push 停在 2026-04-20），最新 release 仍为 **v0.5.1（2026-02-05）**，开源主仓进入维护节奏。背景（非本周，6月初）：扣子于 **2026-06-01 正式上线 3.0**，三端（手机 iOS/Android、桌面 Mac/Windows、网页 coze.cn）全量更新，定位从"智能体构建工具"升级为"开放、协同、全栈式 AI 应用开发平台"，核心是**多人 + 多 Agent 协作**——可在"项目空间"召集不同 Agent 协同从想法到交付；并支持把本地 **Claude Code、Codex CLI、OpenClaw** 一键接入同一项目空间协作，亦可新建运行在扣子云电脑上的"云端 Agent"长期在线；提供金融/自媒体/医疗/法律/科研等行业技能包、一键加载、多端同步（财联社 2026-06-01）。出海侧：海外版 coze.com 本周无重大公开动态可证实，标"未公开"。
- 关键数据：coze-studio Stars **21,000**、Forks 3,054，最新 release v0.5.1（2026-02-05），本周 0 commits（https://github.com/coze-dev/coze-studio ，2026-06-18 直查）；coze-loop Stars **5,528**、Forks 764，本周 7 commits（https://github.com/coze-dev/coze-loop ，2026-06-18 直查）；扣子 3.0 上线 2026-06-01（https://www.cls.cn/detail/2387208 ，财联社，背景非本周）。
- 原文链接：https://github.com/coze-dev/coze-loop （本周 commits 直查）；https://github.com/coze-dev/coze-studio ；扣子 3.0 https://www.53ai.com/news/coze/2026060185314.html
- 影响判断：①本周 Coze 的"重心"在企业级运维（Coze Loop 评测/Trace/webhook），而非开源主仓功能更新，反映字节"社区版引流 + 企业版变现"的双轨打法正落到运维层；②coze-studio 主仓本周静默 + 上一发版停在 2 月，说明字节把产品创新主要放在闭源在线版（扣子 3.0）而非开源版，开源更像生态卡位；③Coze 3.0 把 Claude Code/Codex CLI/OpenClaw 纳入同一协作空间，是"中国 Agent 平台做开放编排中枢"的关键信号，对 Dify 多 Agent 路线形成正面压力。

### n8n（n8n-io/n8n · 开源 workflow/Agent 自动化）
- 本周动态（动态对象池·本周有发版故纳入）：n8n 本周保持高频迭代，覆盖区间内连续发布多个版本，其中重点是 **2.27.0（2026-06-16）** 大版本与随后的 2.26.4/2.26.5/2.26.6、2.27.1（均 06-15→06-17）补丁。2.27.0 引入一次**数据库迁移**（为 execution_entity 表加索引，大实例迁移可能耗时数分钟、过程中数据库仍可用），并包含多项修复：API 将条件凭据字段由"禁止"改为"可选"、把 task-runner-launcher 升级到 1.4.7 以清除 stdlib CVE、为客户端 OAuth 流加入 RFC 8707 resource 参数、允许使用私有凭据发布 workflow、"computer use"在客户端停止时的断连状态修复等。后续补丁多为安全与稳定性：1.123.56/1.123.57 修复 hono、vue-i18n、@grpc/grpc-js 等依赖的多个安全问题；2.27.1 调整 COOP 响应头默认值并修复数据库连接恢复期间的查询挂起。整体看本周 n8n 以**安全加固 + 企业稳定性**为主线，未见重大融资或全新 AI 产品发布。背景（非本周）：n8n 主打"fair-code"工作流自动化 + 原生 AI，400+ 集成。
- 关键数据：GitHub Stars **192,968**、Forks 58,639（https://github.com/n8n-io/n8n ，2026-06-18 直查）；2.27.0 发布 2026-06-16、2.26.6 发布 2026-06-17（https://github.com/n8n-io/n8n/releases ，直查）。
- 原文链接：https://github.com/n8n-io/n8n/releases
- 影响判断：①n8n 以近 19.3万 Stars 稳居开源自动化/Agent IDE 体量第一，本周节奏说明其已进入"企业级安全合规打磨"阶段而非概念扩张；②"computer use"相关修复显示其在持续做 agent 操作电脑类能力；③对中国 Agent 平台（Coze）与 Dify 而言，n8n 代表西方开源自动化生态的成熟度标杆。

---

## 本组洞察（开源 vs 闭源 / 中国 Agent 平台出海格局）
1. **本周主轴是"Agent 平台化 + 可观测性下沉"**：Databricks 把 Agent Bricks 升级为"开发者 Agent 平台"并喊出"missing 99%"（基础设施才是真问题）；Dify 主干密集合入 Agent v2 + roster 可观测性；Coze Loop 本周补 trajectory/评测/webhook。三方不约而同把"评测/监控/治理"做进核心平台——agent 竞争正从"能不能搭"转向"能不能在生产环境安全可控地跑"。
2. **开源 vs 闭源的分工愈发清晰**：字节把创新放在闭源在线版（扣子 3.0，6/1 上线多人多 Agent 协作），开源 coze-studio 主仓本周静默、发版停在 2 月——开源是"生态卡位"，闭源是"商业变现"。Databricks 则走"托管平台 + 开源 harness（Omnigent）"混合路线。纯开源阵营里 Dify（14.5万★）与 n8n（19.3万★）仍靠社区体量领跑。
3. **中国 Agent 平台出海/开放编排是关键变量**：Coze 3.0 把 Claude Code、Codex CLI、OpenClaw 等第三方/开源 Agent 纳入同一"项目空间"协作，是中国平台争做"Agent 开放编排中枢"的明确信号，与 Databricks 的"any model + any harness"中立编排殊途同归——谁能成为多 Agent 的"控制平面"，谁就掌握下一阶段入口。海外版 coze.com 本周无可证实公开动态，出海进展仍待观察。
4. **数据/版本可信度备注**：Coze 官方 release_note 页面为 JS 渲染、本次未能抓到结构化正文，国内动态以财联社/53AI 等二手源 + GitHub 一手直查交叉验证；Stars/commits 均为 2026-06-18 GitHub API 实时直查。
