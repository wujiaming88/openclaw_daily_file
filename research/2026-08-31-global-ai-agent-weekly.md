# 全球 AI Agent 研究周报母稿｜2026-08-31

**覆盖时间：2026-08-24 00:00—2026-08-30 24:00（Asia/Shanghai）**  
**核验日：2026-08-31**

## 执行摘要

本周 Agent 生态的重心没有落在新的单点 benchmark 冠军，而落在五个更接近生产的变量：**独立身份、隔离执行、状态恢复、可归因证据和业务计费单元**。产品从“用户发一句、Agent 回一次”转向由事件触发、跨会话运行、跨团队协同的长期数字主体；工程上则开始承认模型不是可信计算基，授权、sandbox、MCP、日志、checkpoint 与预算必须由确定性控制面落实。

经典 SWE-bench、WebArena、GAIA、τ-bench 本周均无官方可靠性数字突破。真正值得跟踪的是 Dify、Claude Code、Codex、OpenClaw、OpenHands、browser-use 等运行时如何补权限和恢复语义，以及 Glean、ServiceNow、Salesforce、Sierra 如何把身份、审计和计费嵌入企业系统。与此同时，Instinct 的邮件、OTP、留存与越权争议提醒行业：**完成率越高，高权限误操作的代价越大**。

## TOP5

1. **C04 Perplexity Portable Computer：本地优先的完整 Agent 栈。** orchestrator、subagents、harness、tools、connectors 与 OS sandbox 都在本地；能力不足时先做 PII 检查，再展示即将上云的最小上下文并逐步征得同意。厂商自评 Local Knowledge Work Bench 为82.6%/85.4%，Terminal Bench 2.1 纯本地59.6%，云 adviser 后73.0%，但仍需独立复现。[官方研究](https://www.perplexity.ai/hub/blog/a-local-first-agent-for-private-and-cost-effective-knowledge-work)
2. **D02 Glean 独立 Agent + AI Gateway：企业 Agent 身份控制面成形。** 每个 independent agent 拥有 profile、scoped service credentials、permissions、audit trail 与 memory；AI Gateway 统一模型、工具/MCP 与安全策略。厂商称78%客户采用 MCP/API，并报告自测平均查询成本0.58美元对2.98美元，但任务集未公开。[官方发布](https://www.glean.com/blog/proactive-ai-for-enterprises)
3. **B05 Dify v1.17.0：一体化补齐 Agent 生产栈。** E2B 云沙箱、Home Snapshot、工作区 Skills、分层上下文压缩、循环内 HITL、统一 tracing、Turnstile 与 KMS 同时落地，把低代码画布推进到隔离执行与治理平台。[Release](https://github.com/langgenius/dify/releases/tag/1.17.0)
4. **A01 Claude Code：最小权限与长任务运行时同步加固。** v2.1.248 引入 restricted mode；v2.1.251 增加模型切换 hook、prompt-cache 成本可视化、spend limit，并集中修复 symlink TOCTOU、插件路径穿越、MCP handshake、多 Agent 消息与沙箱输出替换问题。[v2.1.251](https://github.com/anthropics/claude-code/releases/tag/v2.1.251)
5. **D16 MalPR-Bench：评测从“拦截”升级为“可归因诊断”。** 89个恶意 PR、50个良性对照、44个仓库、8个语言家族；31个 held-out 恶意 PR 上，相近 blocking totals 下目标漏洞识别相差1.38倍，12个生产漏洞上的 attributable block 为10/12对4/12，即2.5倍。[论文](https://arxiv.org/html/2608.25730v1)

**候补：** A08 Cline 的25GB transcript 事件放大事故与64MiB日志上限；B01 OpenClaw 跨 Gateway 重启恢复 Beta；C10 Instinct 高权限误操作；D04 ServiceNow L1 AI Specialist GA。

## 三条主线

### 产品主线：Agent 从对话功能变成长期数字主体

Glean（D02）给 independent agent 配置独立身份、凭证、权限、审计和记忆；OpenAI（C01）把 Scheduled tasks 接入 webhook，并用 permission-aware Admin plugin 执行权限化动作；ServiceNow（D04）把 L1 AI Specialist 分配到明确角色；Salesforce（D05）让 Claude 继承 CRM 权限和业务规则；Cursor（A04）则把 Cloud Agent 的入口从既有 repo 改成 idea→Origin repo→preview→deploy。共同变化是 Agent 不再只是 UI 上的“助手”，而是具有事件入口、执行状态、业务记录与责任边界的数字主体。

### 工程主线：模型移出可信计算基，运行时负责边界与证据

Perplexity（C04）的本地 OS sandbox 与逐步上云、Claude Code（A01）的 restricted mode/TOCTOU 修复、Codex（A02）的 Guardian/MCP结果拦截、Dify（B05）的 E2B/KMS、OpenClaw（B01）的 checkpoint/worker 终态、Cline（A08）的 state-only event 与有界日志，指向同一原则：模型可以规划，但 filesystem、network、credential、budget、approval、resume 与 audit 必须由确定性运行时强制执行。

### 商业化主线：从 token 计价转向结果、工作单元和策略化路由

Sierra（D01）强调按结果计费；ServiceNow（D04）按每个被分配并尝试处理的 incident 消耗15 assists；Glean（D02）用自动路由与组织/部门/用户/Agent 用量上限控制模型成本；Replit（A10）把模型/effort 自动路由设为 Enterprise 默认；Harvey（D03）则通过千人级全所部署证明垂直流程与实施服务的价值。市场正在从“模型调用多少”转向“任务是否完成、由谁完成、失败与人工兜底如何归因”。

## 编码 Agent 与开源运行时（A/B）

### 编码 Agent 深度事件

- **A01 Claude Code：** v2.1.245—2.1.251；restricted mode、模型切换 hooks、prompt-cache 成本、spend limit，以及 symlink TOCTOU、插件路径穿越、Workflow 越界读取、沙箱输出替换等修复。GitHub API核验快照143,478 stars/22,948 forks，后续共享出口复核遇rate limit。[v2.1.248](https://github.com/anthropics/claude-code/releases/tag/v2.1.248) [v2.1.251](https://github.com/anthropics/claude-code/releases/tag/v2.1.251)
- **A02 OpenAI Codex CLI：** 0.150.0—0.151.0 增加task互联、Interrupt/MCP hooks、权限模式和MCP结果进模型前拦截；修复不可信项目注入、`/cd`沙箱、stale Guardian、remote executor path、permission profile与nested token预算。[Changelog](https://developers.openai.com/codex/changelog) [0.151.0](https://github.com/openai/codex/releases/tag/rust-v0.151.0)
- **A03 Gemini CLI：** v0.57.0/v0.58 preview改善IDE/A2A、Seatbelt对Docker sockets/binaries隔离、symlink ignore与write policy；nightly修MCP OAuth metadata SSRF并让workspace trust fail-closed。preview不等于stable。[v0.57.0](https://github.com/google-gemini/gemini-cli/releases/tag/v0.57.0)
- **A04 Cursor：** Cloud Agents支持无外部SCM从零开始，自动建立Origin repo、浏览器preview并接Vercel；便利增加，也放大平台锁定、凭证和数据驻留风险。[官方更新](https://cursor.com/changelog/start-from-scratch)
- **A06 OpenCode：** v1.18.22—1.18.25新增Azure CLI/Entra ID，并修Cloudflare Gateway、Bedrock cache/reasoning与兼容参数。API快照202,612 stars/26,354 forks；多云中立换来provider/config矩阵。[Releases](https://github.com/anomalyco/opencode/releases)
- **A08 Cline：** 状态事件内嵌完整transcript导致16GB机器出现25GB进程；SDK v0.0.81改为state-only、messages按需取，v0.0.79把event log限制64MiB并prune/vacuum。[v0.0.81](https://github.com/cline/cline/releases/tag/sdk/sdk/v0.0.81) [v0.0.79](https://github.com/cline/cline/releases/tag/sdk/sdk/v0.0.79)
- **A10 Replit Agent：** Auto模型/effort路由成为Enterprise默认，管理员控制allowed model；Growth Skills连接CRM、支付与分析。风险是可复现性、成本归因与OAuth scope。[Changelog](https://docs.replit.com/updates/2026/08/28/changelog.md)

### 编码 Agent 静默/观察

- **A05 Devin/Windsurf：** 最新stable v3.8.20为8月21日，早于窗口。[Changelog](https://docs.devin.ai/desktop/changelog)
- **A07 Aider：** 最新release v0.86.0为2025-08-09。[Releases](https://github.com/Aider-AI/aider/releases)
- **A09 Roo Code：** 最新release v3.54.0为2026-05-15。[Releases](https://github.com/RooCodeInc/Roo-Code/releases)
- **A11 GitHub Copilot/SWE-bench：** 窗口内无可核验显著新增；当前leaderboard不能证明上榜日期。[Copilot](https://github.blog/changelog/label/copilot/) [SWE-bench](https://www.swebench.com/)
- **A12 候选扫描：** 固定对象已覆盖窗口内主要编码Agent release、IDE与云端动态；没有用社区传闻或无时间戳排名补造额外候选。

### 开源框架深度事件

- **B01 OpenClaw（Beta）：** `v2026.9.1-beta.1`让长任务跨Gateway重启保留checkpoint，修worker admission、dead-worker终态和配置代际；1,520 unique PR中仅2个属当前比较区间，正式v2026.8.1于8月31日越窗。[Release](https://github.com/openclaw/openclaw/releases/tag/v2026.9.1-beta.1)
- **B02 LangGraph/LangChain：** 第一方`langchain.mcp` Alpha把MCP server变为`create_agent`工具，elicitation映射`interrupt()`并由checkpointer恢复。风险是Alpha、协议代际与缓存语义。[Release](https://github.com/langchain-ai/langchain/releases/tag/langchain%3D%3D1.4.0a2)
- **B04 CrewAI：** 1.15.18将conversational flows提升stable，增加router response format/state shape并修resume、工具结果与遥测语义。[Release](https://github.com/crewAIInc/crewAI/releases/tag/1.15.18)
- **B05 Dify：** v1.17.0带来E2B、本地/云sandbox、Home Snapshot、Skills版本生命周期、分层压缩、循环内HITL、统一tracing、Turnstile、KMS和所有权/SSRF加固。[Release](https://github.com/langgenius/dify/releases/tag/1.17.0)
- **B07 Google ADK：** v2.8.0增加A2A认证、Model Armor、Data Agent、Live VIDEO、MCP OTel、自定义评测与调用上限；v1.39.1回补Host/origin/path、stdio opt-in、容器隔离和unpickle allow-list。[v2.8.0](https://github.com/google/adk-python/releases/tag/v2.8.0)
- **B08 OpenAI Agents SDK：** 无正式release，但主干修approved tools/handoff恢复、流式tool call合并与PyPI发布链；需故障注入验证副作用至多一次。[Commits](https://github.com/openai/openai-agents-python/commits/main?since=2026-08-24&until=2026-08-30)
- **B09 browser-use：** Cloud API v4收敛run/session/workspace/browser资源；支持queue、interrupt、CDP。关闭客户端不等于停止计费，下载URL60秒过期。[API v4](https://docs.browser-use.com/cloud/api-v4)
- **B10 OpenHands：** v1.16.0增加Linux desktop、Automation phase、LLM switching、Canvas Extensions，并把skills改为显式allow-list；自托管Canvas可关telemetry。[Release](https://github.com/OpenHands/OpenHands/releases/tag/v1.16.0)
- **B11 AutoGPT：** beta v0.7.3加入expert team、Needs-You；本地默认9B Q4，context提高至262,144。release body日期与feed冲突，保留争议；资源与遥测风险高。[Release](https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.7.3)
- **B14 Hermes Agent：** v0.20.6汇总约525 PR、1,313 commits、1,557 files，加入真实Chromium profile、SSH fleet、50+ MCP、keychain与压缩。名为patch但变化巨大，完整说明延至v0.21.0。[Release](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.8.27)

### 开源项目静默

- **B03 AutoGen：** 窗口内无release。[Releases](https://github.com/microsoft/autogen/releases)
- **B06 LlamaIndex Agents：** 最新v0.14.24为8月19日。[Releases](https://github.com/run-llama/llama_index/releases)
- **B08-S Swarm：** 无窗口内release/main提交。[Atom](https://github.com/openai/swarm/commits/main.atom)
- **B12 MetaGPT：** 无窗口内release/main提交。[Atom](https://github.com/FoundationAgents/MetaGPT/commits/main.atom)
- **B13 SuperAGI：** 无窗口内release/main提交。[Atom](https://github.com/TransformerOptimus/SuperAGI/commits/main.atom)

## 浏览器、通用自主与企业 Agent（C/D）

### 浏览器与通用自主 Agent

- **C01 OpenAI Operator/ChatGPT Agent：** Scheduled tasks支持webhook触发与分享，接收成员用自身权限创建副本；Admin plugin把成员/组、访问、额度与审批映射为permission-aware工具。OpenAI内部IT案例称约解决45%工单量，仅代表内部案例。[Admin plugin](https://openai.com/index/introducing-admin-plugin/)
- **C02 Anthropic Computer Use：** Cowork/Claude Code session endpoints出beta，Compliance API覆盖更多Agent transcript；personal/service keys与主体身份绑定，可限workspace且离职失效。computer/browser use GA是8月19日背景。[Release notes](https://platform.claude.com/docs/en/release-notes/overview)
- **C04 Perplexity Portable Computer：** 本地运行orchestrator、subagents、harness、models、tools、connectors与isolated sandbox；sandbox不可用时关闭工具。上云前选取最小上下文、做PII检查并逐步展示/批准；云adviser无本地工具权限。厂商自评Local Knowledge Work 82.6%/85.4%、Terminal Bench本地59.6%→混合73.0%，约0.415美元/rollout，需独立复现。首发Linux且至少24GB VRAM。[官方研究](https://www.perplexity.ai/hub/blog/a-local-first-agent-for-private-and-cost-effective-knowledge-work)
- **C05 Manus：** 8月25日恢复入口开放，受监管拆分影响的部分用户可恢复预先备份数据；未披露开放格式、完整tool trajectory、恢复成功率、丢失率和人数。[官方说明](https://manus.im/blog/a-note-to-our-users)
- **C06 Genspark：** 8月27日案例显示从Super Agent展示转向slides/docs/images/video/code/design一体化工作空间，但无量化与权限证据。[案例](https://www.genspark.ai/blog/from-scattered-tools-to-one-platform)
- **C09 AutoGLM/GLM：** GLM-5.3-Flash于8月26日发布，原生视觉形成code-browser-GUI反馈闭环；320B总参数、18B激活、1M context、MIT。官方自评Terminal Bench2.1 84.3、DeepSWE 63.4、AutomationBench 48.8，未独立复现。限时input 0.075美元/MTok、output 0.25；runtime安全未说明。[Release notes](https://docs.z.ai/release-notes/new-released)
- **C10 Instinct：** Terms明确断开connector后仍可使用已索引数据，除非另行删除；可代表用户购买、共享支付信息并进入有约束力协议。用户报告断连后邮件摘要、OTP读取、邮件prompt injection和未经确认发信。支付、发信、验证码、删除、签约必须硬性step-up confirmation。[Terms](https://instinct.co/terms) [TechCrunch](https://techcrunch.com/2026/08/24/instincts-powerful-ai-assistant-is-raising-privacy-and-security-concerns/)

### 浏览器/通用 Agent 静默

- **C03 Project Mariner：** 本周无动态，项目已于5月退出。[Landing](https://labs.google.com/mariner/landing)
- **C07 Kimi Agent：** 官网/blog/Kimi Work/Code/API无窗口内Agent公告。[官网](https://www.kimi.com/)
- **C08 Qwen Agent：** 无窗口内自身发布；Perplexity采用Qwen不重复归因。[Repo](https://github.com/QwenLM/Qwen-Agent)

### 企业产品与生产落地

- **D01 Sierra：** 首尔办公室；厂商称覆盖领先银行三分之一和Fortune50的40%，Singtel 10周上线/解决率70%+，Next 6周覆盖83国/48语言，BBVA 30天上线Horizon。缺样本量、错误升级率与结果归因。[官方发布](https://sierra.ai/blog/sierra-launches-in-korea)
- **D02 Glean：** Independent agent拥有profile、scoped credentials、permissions、audit trail与memory；AI Gateway统一模型、tools/MCP和策略，40+模型自动路由并分层限额。厂商称78%客户采用MCP/API，自测成本0.58美元对2.98美元；缺第三方复现，多项仍Beta。[官方发布](https://www.glean.com/blog/proactive-ai-for-enterprises)
- **D03 Harvey：** Jackson Lewis向1,100+律师全所部署，Nelson Mullins覆盖1,300+律师/顾问/专业人员；依赖Legal Engineering共建流程，但无活跃率、ROI、返工与合同金额。[Jackson Lewis](https://www.harvey.ai/blog/jackson-lewis-deploys-harvey-firmwide) [Nelson Mullins](https://www.harvey.ai/blog/nelson-mullins-deploys-harvey-across-all-practices)
- **D04 ServiceNow：** 首个L1 Service Desk AI Specialist GA；Autopilot可直接关闭，Copilot人工审核；每个被分配且尝试处理的incident消耗15 assists。官方建议上线前做5—10个不同事件与边界测试。[官方说明](https://www.servicenow.com/community/servicenow-otto-articles/introducing-the-autonomous-workforce-ai-specialists-as-your-new/ta-p/3591289)
- **D05 Salesforce Agentforce/Claudeforce：** Salesforce in Claude插件含37 skills，selected pilot开放、9月open beta；Headless360经MCP暴露数据、workflow与治理，动作沿用CRM权限/业务规则。继承权限也会复制过宽授权。[Claudeforce](https://www.salesforce.com/claudeforce/)
- **D06 Microsoft Copilot Agents：** 分层架构把前门、长任务、低代码治理、只读分析、定制runtime与持续协调拆开；新harness统一identity、instructions、knowledge、tools/skills、model、connected agents、memory和Evaluate/Monitor。新旧harness不可迁移。[架构](https://www.microsoft.com/insidetrack/blog/start-light-scale-intentionally-choosing-the-right-microsoft-agent-architecture/)
- **D07 Coze/扣子（静默）：** 窗口命中多为用户模板/画廊，非官方release或治理变更；公开changelog索引弱。[中国站](https://www.coze.cn/)

## 协议、记忆、治理与评测（D08—D17）

- **D08 MCP：** 成立Enterprise Interest Group，13名来自银行、零售、集成、身份与医疗组织的参与者评审企业requirement gaps；Registry生产支持Cargo。工作组不等于标准已解，delegation token、on-behalf-of chain、rotation、audit schema、server signing与数据驻留仍缺规范。[Enterprise IG](https://github.com/modelcontextprotocol/modelcontextprotocol/commit/ca4ab3027f7c844cd3039c956438d72e8253f7f5)
- **D09 Memory/context engineering：** LinkedIn招聘Agent公开conversation、episodic、semantic、procedural四层记忆，近实时ingestion/retrieval和离线consolidation处理去重、陈旧、冲突与来源；未公开规模、准确率、TTL与删除。[深访](https://stackoverflow.blog/2026/08/25/inside-linkedin-s-cognitive-memory-agent/)
- **D10 Sandbox/permission/identity/audit：** 厂商指南提出短生命周期sandbox、default-deny egress、集中tool registry、确定性mediator、多租户隔离和AIBOM；普通Docker共享内核不是强边界。audit log是enforcement证据，不是enforcement本身。[原文](https://predictionguard.com/blog/ai-agent-sandbox-best-practices)
- **D11 SWE-bench：** 窗口无官方dataset、harness、leaderboard或release更新。[Repo](https://github.com/SWE-bench/SWE-bench/commits/main)
- **D12 OSWorld：** 仅新增Qwen-CUA引用，不是任务或分数更新。[Commit](https://github.com/xlang-ai/OSWorld/commit/fc31a9049664292fcb35d6e501ee1dc839f2cf6d)
- **D13 WebArena：** 窗口无任务、镜像、脚本、榜单或release变更。[Repo](https://github.com/web-arena-x/webarena)
- **D14 GAIA：** 未确认窗口内任务、评分规则或官方leaderboard变更。[Benchmark](https://huggingface.co/gaia-benchmark)
- **D15 τ-bench：** 窗口无task、policy、user simulator或scorer变化。[Repo](https://github.com/sierra-research/tau-bench)
- **D16 MalPR-Bench/PRGuard：** 89恶意PR+50良性对照、44仓库、8语言；只有verdict、identification、evidence同时正确才算attributable block。31个held-out上目标漏洞识别1.38倍，absence-type 3倍；12个生产漏洞上可归因阻止10/12对4/12。样本较小且grader含LLM+人工，尚无独立复现。[论文](https://arxiv.org/html/2608.25730v1)
- **D17 Agentic Security：** 论文把系统定义为随机LLM policies + deterministic mediator；模型规划，mediator在执行前强制scope、budget、severity、audit，原始证据写artifact store，短生命周期phase agents减少证据丢失。部分机制仍planned。[论文](https://arxiv.org/html/2608.21423v1)

## 开源生态雷达

| 方向 | 本周代表 | 成熟信号 | 主要缺口 |
|---|---|---|---|
| 状态恢复 | OpenClaw、Agents SDK、Codex | checkpoint、handoff、dead-worker终态、root goal预算 | 外部副作用幂等、重复投递 |
| 隔离执行 | Dify、Perplexity、Claude Code、Gemini CLI | E2B/OS sandbox、restricted/fail-closed、socket隔离 | 供应链、网络策略、硬件/成本 |
| MCP/工具治理 | LangChain、Hermes、MCP Enterprise IG | 第一方adapter、50+ vendor MCP、企业工作组 | 身份委托、签名、审计schema、撤权 |
| 资源模型 | browser-use、OpenHands、AutoGPT | run/session/workspace/browser、Canvas、Needs-You | 计费生命周期、迁移和兼容 |
| 可观测性 | Cline、Claude Code、Dify | state-only event、有界日志、cache/cost、统一tracing | transcript敏感、日志爆炸、证据篡改 |
| 本地模型 | Perplexity、AutoGPT、GLM | 27B/9B默认路径、视觉反馈、低价 | 资源成本、独立复现、安全runtime |

## Agent 产品雷达

| 产品类型 | 代表 | 本周判断 |
|---|---|---|
| 编码Agent | Claude Code、Codex、Gemini CLI、Cline | 功能竞争让位给权限、路径、状态、预算和远程执行语义 |
| 云开发Agent | Cursor、Replit | 从已有repo进入idea-to-deploy，控制面与artifact plane合并 |
| 浏览器/通用Agent | Perplexity、OpenAI、Anthropic、Instinct | 本地优先和企业控制面是正向路线；OTP/支付/留存是红线 |
| 企业横向Agent | Glean、ServiceNow、Salesforce、Microsoft | 独立身份、角色、审批、审计、bounded tools成为采购核心 |
| 垂直Agent | Sierra、Harvey | 真实部署扩大，但结果归因、质量和ROI仍不透明 |
| 开源平台 | Dify、OpenHands、OpenClaw、Hermes | 运行时平台化加速，同时扩大升级和供应链风险 |

## 研究判断

1. Agent最小治理单元应是“身份 + 委托凭证 + 策略决策 + 工具调用 + 证据链”。
2. 高权限Agent核心安全KPI不是平均完成率，而是未经授权动作率；登录、OTP、支付、发信、删除、签约须分项统计。
3. 结果计费必须建立attribution graph，拆分模型、Agent、人工、重试与失败。
4. 经典benchmark静默不等于行业停滞；本周真正前进的是runtime、identity、sandbox、MCP、memory和evaluation definition。
5. 开源release必须审正文和比较区间；Hermes大patch、AutoGPT日期冲突、OpenClaw retained-seed都说明headline会夸大增量。

## 下周观察点

- OpenClaw跨重启恢复是否进入稳定版并公开重复投递测试。
- Dify E2B、Home Snapshot、Skills与KMS是否出现生产迁移、安全和成本反馈。
- Perplexity是否开源benchmark/sandbox与PII漏检数据，Windows版是否如期。
- MCP Enterprise IG是否产出身份委托、审计、provenance或签名草案。
- Glean、Salesforce、ServiceNow是否披露客户、错误升级率、人工兜底和ROI。
- Claude Code/Codex/Gemini CLI安全修复是否回归，nested Agent预算是否可观测。
- Instinct是否把支付、OTP、发信和断连数据删除改为硬控制。
- MalPR-Bench能否公开完整数据并进入主流代码Agent评测。

## 覆盖与研究门控

- A组：12条目，7有料，5静默/观察，38个来源。
- B组：15固定对象，10有料，5静默，39个来源。
- C组：10条目，7有料，3静默/退出，30个来源。
- D组：17条目，11有料，6静默/观察，35个来源。
- 合计54条目口径、35个有料动态、19个静默/观察；四组来源计数合计142，跨组URL可能重复。
- 固定对象逐一核验，实质覆盖率100%；有料对象有原文/交叉来源，静默对象给出核验范围或时间原因。
- 随机深核5项：Claude Code v2.1.251、Dify v1.17.0、Instinct Terms、Glean proactive AI、MalPR-Bench，均成功打开原文并核对正文。Perplexity官方页受CDN 403，已以官方索引和交叉来源核验并保留限制。
