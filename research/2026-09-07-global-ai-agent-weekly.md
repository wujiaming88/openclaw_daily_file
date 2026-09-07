# 全球 AI Agent 周报研究母稿｜2026-09-07

> **用途：** 供后续选题、核查、写作和删改的研究母稿，不是面向读者的成文。  
> **严格窗口：** 2026-08-31 00:00—2026-09-06 24:00（Asia/Shanghai）。旧闻只作背景并标明。  
> **证据纪律：** A=官方 release/spec/docs；B=厂商 benchmark/经营披露/项目自测；C=可靠媒体、官方社媒、合作方、近似快照；D=preprint/未双源线索。partial、strict、binary 及不同 harness/预算/scaffold 不混比；stars 不是用户数，ARR 不是客户 ROI。

## 一、TOP5 候选与排序结论

综合“工程影响力 × 采用信号 × 生态位置 × 可靠性突破 × 新颖度”排序：

1. **E01 OpenClaw v2026.9.1/v2026.9.2**
2. **E02 Dify v1.17.0**
3. **E03 GPT-6 Astra computer use**
4. **E04 Claude Fable 5.1 后台 computer use**
5. **E05 Salesforce 2026 Editions / native multi-agent**

**排序说明：** 不调整预设重点。OpenClaw、Dify 排在模型发布之前，是因为两者同时改变恢复、制品、上下文、升级和权限默认值，工程外溢更广；Astra/Fable 新颖度更高，但 benchmark 仍以厂商披露为主；Salesforce 的生态位置与采购信号最强，但独立 ROI 最弱。

### E01｜OpenClaw 2026.9.1/9.2
- **F01：** 9.1 引入共享 Gateway 个人技能库、升级失败回滚、配置 CAS、per-agent worktree；9.2 将长 transcript 处理移出 Gateway event loop，使 active/queued/delegated reply 跨重启恢复，并加入热配置、Swarm、connected accounts 和跨 Agent session access。
- **D01：** 约 389k stars / 81.7k forks（2026-09-07 页面快照口径）。
- **J01：** 从助手框架转向可恢复、可协作、可升级的 Agent OS。
- **L01：** stars 仅为近似热度；Swarm 默认开启、session visibility 与 agent-to-agent access 扩大，升级后需重新做权限评审。
- **S01：** [v2026.9.1](https://github.com/openclaw/openclaw/releases/tag/v2026.9.1)；[v2026.9.2](https://github.com/openclaw/openclaw/releases/tag/v2026.9.2)。**A/B**。

### E02｜Dify v1.17.0
- **F02：** 加入 E2B 云沙箱、Home Snapshot、workspace Skills 的 draft→publish→version、按有效窗口分级压缩、Loop/Iteration 内 Human Input 暂停恢复和 provider-neutral tracing，并接入 Phoenix/LangSmith、Azure Key Vault/KMS、Turnstile、TiDB hybrid search。
- **D02：** 约 154k stars / 24.4k forks。
- **J02：** 从低代码画布进入“可发布制品 + 长时恢复 + 企业运行治理”的平台阶段。
- **L02：** 数据库迁移、env 改名、compose 合并、执行上限变化及 Snapshot 秘密泄露使其不适合无评审滚动升级；stars 非部署数。
- **S02：** [v1.17.0](https://github.com/langgenius/dify/releases/tag/1.17.0)。**A/B**。

### E03｜OpenAI GPT-6 Astra
- **F03：** 9 月 3 日进入 ChatGPT、Codex、Responses API、Azure 和 AWS Bedrock；把 computer use、web/file search、hosted shell、code interpreter、apply patch、MCP、skills 与跨窗口旧工具输出检索放入统一执行栈。
- **D03：** 1.05M context，最大 922K 输入/128K 输出；标准 API 每百万 token $10 输入/$50 输出。厂商报 OSWorld 2.0 72.6% partial、约 40 分钟/任务，前代 65.7%、约 75 分钟；内部安全集不期望结果 2.4%，加 AutoReview 1.8%。
- **J03：** 独立浏览器 Agent 被吸收进通用工作模型/工作台，竞争转为长任务目标保持、审计、恢复和成功任务总成本。
- **L03：** benchmark/安全集缺本周独立复现；**72.6% partial 不得与 strict 比**；Enterprise 发布时默认关闭，复杂桌面任务仍不能无监督。
- **S03：** [OpenAI](https://openai.com/index/gpt-6-astra/)；[API 文档](https://developers.openai.com/api/docs/models/gpt-6-astra)；[CNBC](https://www.cnbc.com/2026/09/03/open-ai-astra-gpt-6-cyber.html)。**A/B/C**。

### E04｜Claude Fable 5.1 / 后台 computer use
- **F04：** 9 月 1 日发布 Fable/Mythos 5.1；9 月 2 日宣布 macOS Cowork/Claude Code 可后台点击、键入和打开应用，用户前台可继续工作。
- **D04：** 厂商报 OSWorld 2.0 77.9% partial / 41.7% strict、AutomationBench 31.4%；典型 token 负载估计便宜 25%，高 agentic 负载最多约 45%。
- **J04：** 后台执行是并行工作台的体验突破，也使动作日志、暂停、撤销、白名单和确认成为一等能力。
- **L04：** partial/strict 仅可分别陈列，不与 Astra 或其他 harness 排榜；降本与 benchmark 为厂商估计；Anthropic 明示仍可能绕过 approvals/auto-mode classifiers，后台隔离实现未完整披露。
- **S04：** [Anthropic](https://www.anthropic.com/claude-fable-and-mythos-5-1)；[release notes](https://support.claude.com/en/articles/12138966-release-notes)；[官方 X](https://x.com/claudeai/status/2095226833293685100)；[9to5Mac](https://9to5mac.com/2026/09/02/anthropic-upgrades-claude-codes-computer-use-to-run-in-the-background-on-mac/)。**A/B/C**。

### E05｜Salesforce 2026 Editions / Multi-Agent
- **F05：** 9 月 3 日推出 Core/Advanced/Max，将 Agentforce、Slack/Slackbot、Tableau Next、数据安全和 Premier Success Plan 合并采购；native multi-agent orchestration GA，含 Superagent、Connected Subagents 及 MCP/A2A 边界。
- **D05：** $195/$395/$550 每用户/月；Flex Credits 50万/100万/275万。官方称 Max 价值增加近 60%；内部测试称超过 7 个 subagents 更常出现 intent collision/结果劣化。
- **J05：** Agent 正进入标准席位、credits、数据安全和采购体系；多 Agent 的关键是身份、上下文交接和归因链。
- **L05：** “价值增加”和 7-subagent 阈值均为厂商口径；credits 使 TCO 随行为变化，无独立客户 ROI/事故率证据。
- **S05：** [2026 Editions](https://www.salesforce.com/news/stories/salesforce-simplifies-editions-2026/)；[多 Agent 架构](https://www.salesforce.com/blog/3-signs-youve-outgrown-a-single-agent/)；[档位交叉确认](https://www.salesforceben.com/salesforce-announces-3-replacement-editions-bundling-ai-slack-and-security/)。**A/B/C**。

## 二、三条主线

### P1 产品：独立 Agent → 通用工作台 / Agent OS / 后台执行

**事件：E03、E04、E01、E06、E23。** Astra 将 Browser/OS/shell/Office 纳入 ChatGPT/Codex/API；Fable 将 computer use 移到 macOS 后台；OpenClaw 汇入协作、恢复和 connected accounts；Devin Desktop 以 Local/Worktree/Cloud 取代 Cascade；Cursor 将云控制面与客户 worker 执行面拆开。关系不是单纯“工具更多”，而是入口变成承载模型、状态、权限、工具和产物的工作台。后台并行和远程执行提高可用性，却减少实时可见度，因此回放、暂停、差异预览、审批及数据流声明应成为产品门槛。

### P2 工程：长时恢复 / 制品 / 上下文 / 权限与外部控制面

**事件：E01、E02、E07、E08、E09、E10、E19、E30。** reply recovery、Snapshot/HITL resume、durable facts/context compaction、数据恢复、memory scope/provenance、模型外 gateway/identity/sandbox/audit、sandbox 负向修复和 MCP context 隔离共同处理一个问题：任务如何跨故障、压缩、会话和组织边界持续，并保持可追溯。MCP/A2A 解决“怎么接”，控制面解决“谁可用何种权限接”；policy 是否真正加载，必须靠启动断言和负向测试验证。

### P3 商业化：席位 / credits / ARR / ROI 证据不足

**事件：E05、E11、E12、E03、E04、E27、E28。** Salesforce 用席位与 credits 套餐化；Sierra 自报 2 亿美元 ARR；Harvey 用持续监管扫描进入垂直工作流；OpenAI/Anthropic 公布 token/cache 价格；Microsoft/ServiceNow 把 Agent 嵌入流程、权限与治理平台。市场从购买模型访问转向购买工作席位、行为额度和业务结果。但 ARR 是厂商收入，不是客户 ROI；token 价不是成功任务总成本。仍缺独立可复现的净节省、错误返工、人工接管、事故和组织变更成本。

## 三、可追溯事件账本（E/F/D/J/L/S）

> 每行严格对应同号 **F（事实）/D（数据）/J（判断）/L（限制）/S（来源）**；TOP5 已在上一节展开。无数字也是 D 的明确缺口，不以旧数补本周。

| E | F / D | J | L | S |
|---|---|---|---|---|
| E06 | **F06** Devin Desktop Next v3.9.1018 移除 Cascade，Devin Local 唯一化，Local/Worktree/Cloud 顶层化；**D06** 稳定版仍为 8/21 v3.8.20。 | **J06** IDE 收敛为 Agent 运行位置与审阅控制台。 | **L06** 仅 Next，不能写成稳定版全量上线。 | **S06** [Next](https://docs.devin.ai/desktop/changelog-next)、[Stable](https://docs.devin.ai/desktop/changelog) |
| E07 | **F07** ADK Go v2.3.0 修 HITL resume、confirmation source、A2A metadata/card source，加入 durable facts/compaction/OTel；**D07** 约 8.6k stars。 | **J07** 长时恢复与来源绑定进入 SDK 基础层。 | **L07** 仅 Go，不泛化 Python/JS；压缩需回放。 | **S07** [v2.3.0](https://github.com/google/adk-go/releases/tag/v2.3.0) |
| E08 | **F08** Manus 9/1 恢复独立运营，部分用户需备份恢复；已有云 sandbox/My Computer/Browser/connectors/Plan/Branch；**D08** 无恢复成功率、SLA、用户数和价格。 | **J08** 长期上下文、凭据、任务状态连续性是护城河。 | **L08** 独立运营仅官方一手；合同主体、RTO/RPO 未披露。 | **S08** [公告](https://manus.im/blog/manus-resumes-independent-operations)、[My Computer](https://manus.im/desktop) |
| E09 | **F09** Mem0 多 scope/actor attribution/异步写；OpenViking 统一 `viking://` 与分层召回；**D09** 两者报多项 memory 分数和 token/latency 降幅。 | **J09** memory 成为独立数据库和安全域。 | **L09** 项目自测；旧 26k 与当前 6.7k—6.96k token 单位不同，不比较。 | **S09** [Mem0](https://mem0.ai/blog/state-of-ai-agent-memory-2026)、[OpenViking](https://github.com/volcengine/OpenViking) |
| E10 | **F10** Microsoft AGT 与 Google Agent Platform 提供模型外 policy/identity/sandbox/audit/eval；**D10** 前者 public preview，后者无本周明确 GA/价格。 | **J10** 生产授权与追责必须在模型之外。 | **L10** “覆盖 OWASP”是项目自报；preview 可 breaking。 | **S10** [Microsoft](https://github.com/microsoft/agent-governance-toolkit)、[Google](https://docs.cloud.google.com/gemini-enterprise-agent-platform/overview) |
| E11 | **F11** Sierra 8/31 任命 CFO，并自报企业覆盖；**D11** 7 季度 1 亿、9 季度 2 亿美元 ARR。 | **J11** 长程 revenue Agent 出现强商业信号。 | **L11** 公司/创始人同源，未审计，无客户名单、净留存或客户 ROI。 | **S11** [Sierra](https://sierra.ai/blog/julia-brau-donnelly-joins-sierra) |
| E12 | **F12** Harvey Horizon Scanning EA，接入 Fable 5.1 与 DeepL；**D12** 12,000+来源、100+司法辖区，合作方报采用和翻译量。 | **J12** 法律 Agent 从一次分析走向持续监测—判断—行动。 | **L12** 数据全在美国处理、无 regional processing；数字为厂商/合作方口径，政策建议须律师审批。 | **S12** [Horizon](https://www.harvey.ai/blog/horizon-scanning-in-harvey)、[Fable](https://www.harvey.ai/blog/fable-5-1-in-harvey) |
| E13 | **F13** CrewAI 1.15.19/20 增 client/遥测，修 provider/memory/structured output，hook deny 全路径传播并升级安全依赖；**D13** 约 58k stars。 | **J13** 企业 guardrail 与运行可靠性加强。 | **L13** 遥测合规；紧随补丁提示回归。 | **S13** [1.15.19](https://github.com/crewAIInc/crewAI/releases/tag/1.15.19)、[1.15.20](https://github.com/crewAIInc/crewAI/releases/tag/1.15.20) |
| E14 | **F14** browser-use 0.13.9/10 修浏览器、WebSocket、标签、文件、Cloud API、MCP 错误语义与供应链；**D14** 约 112k stars。 | **J14** 浏览器工程转向可复现发布与真实失败语义。 | **L14** exact pin 可能冲突宿主依赖。 | **S14** [0.13.9](https://github.com/browser-use/browser-use/releases/tag/0.13.9)、[0.13.10](https://github.com/browser-use/browser-use/releases/tag/0.13.10) |
| E15 | **F15** AutoGPT beta v0.7.4 加 expert 隔离、activity、连接/套餐边界及 library agent 安装；**D15** 约 186k stars。 | **J15** 平台身份和连接权限更可见。 | **L15** beta、计费耦合、自装 Agent 扩大供应链面。 | **S15** [v0.7.4](https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.7.4) |
| E16 | **F16** Hermes v0.21.0 加群聊/peer、durable cron/notepad、可纠偏委派和 MCP 控制台；**D16** 默认 250 iterations/10 并发，约 238k stars。 | **J16** 多 Agent 由隐形管线变为可见协作。 | **L16** 大变更量为项目口径；并发、记忆、MCP 放大权限和成本。 | **S16** [v0.21.0](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.8.31) |
| E17 | **F17** OpenCode v1.18.29 修 GPT/Codex OAuth 模型过滤、Astra 可见性和 quota reset；**D17** 约 205,289 stars。 | **J17** provider 能力协商不能依赖版本字符串。 | **L17** stars 近似；更新下载可被轮询放大。 | **S17** [v1.18.29](https://github.com/anomalyco/opencode/releases/tag/v1.18.29) |
| E18 | **F18** Cline Desktop v0.0.23 用 shared Hub 托管 Skills/MCP 生命周期并忽略 workspace 插件目录；**D18** 约 67,587 stars。 | **J18** 跨客户端插件控制面成形。 | **L18** 控制面集中扩大插件供应链风险。 | **S18** [v0.0.23](https://github.com/cline/cline/releases/tag/desktop-v0.0.23) |
| E19 | **F19** Gemini CLI v0.58.0 堵容器 socket/CLI、Mach/XPC/共享内存逃逸面，修 AllowedPathChecker 未加载和 A2A 残留；**D19** 约 106,837 stars。 | **J19** 安全从“有 sandbox”进入“验证策略已生效”。 | **L19** sandbox 不消除网络、密钥、挂载风险。 | **S19** [release](https://github.com/google-gemini/gemini-cli/releases/tag/v0.58.0)、[PR28935](https://github.com/google-gemini/gemini-cli/pull/28935) |
| E20 | **F20** Claude Code v2.1.263 只称 bug fixes/reliability，提供 12 个签名/校验资产；**D20** 约 144,275 stars。 | **J20** 交付可靠性有信号，透明度不足。 | **L20** 不得推断未写明的新功能。 | **S20** [v2.1.263](https://github.com/anthropics/claude-code/releases/tag/v2.1.263) |
| E21 | **F21** Codex CLI 0.153.4 令 Astra 成 bundled default，并按异步工具存在性启用 guidance；**D21** 约 121,979 stars。 | **J21** 模型、工具、订阅权限需运行时握手。 | **L21** 默认模型变更影响质量、延迟和成本。 | **S21** [release](https://github.com/openai/codex/releases/tag/rust-v0.153.4)、[PR42874](https://github.com/openai/codex/pull/42874) |
| E22 | **F22** LangGraph/LlamaIndex/OpenAI Agents SDK/OpenHands 本周静默；AutoGen maintenance；MetaGPT/SuperAGI/Aider/Roo 长期或阶段性无正式版；**D22** AutoGen 最新 2025-09，MetaGPT 2025-03，SuperAGI 2024-01，Aider 2025-08，Roo 2026-05。 | **J22** 生命周期状态必须进入采购评分。 | **L22** 单周静默不等于停止开发；maintenance/长期停版风险更高。 | **S22** [AutoGen](https://github.com/microsoft/autogen)、[MetaGPT](https://github.com/FoundationAgents/MetaGPT/releases)、[SuperAGI](https://github.com/TransformerOptimus/SuperAGI/releases)、[Aider](https://api.github.com/repos/Aider-AI/aider/releases?per_page=5)、[Roo](https://api.github.com/repos/RooCodeInc/Roo-Code/releases?per_page=5) |
| E23 | **F23** Cursor 自托管保留云端 loop/planning，客户 worker 执行文件/终端/computer use/MCP；**D23** 每用户 200、每团队 1000 workers。 | **J23** 控制面/执行面拆分是企业部署范式。 | **L23** 非零数据出网，artifact 默认 Cursor S3；客户负责镜像、密钥、隔离。 | **S23** [公告](https://cursor.com/changelog/self-hosted-machines)、[文档](https://cursor.com/docs/cloud-agent/self-hosted) |
| E24 | **F24** Replit Agent 可加 custom events 并分析 funnel；数据库每日 full restore point；**D24** 访客数为近似，无连续 PITR。 | **J24** coding Agent 延伸至上线后增长闭环。 | **L24** PII/secret/event schema 风险；启用需重发，部分 artifact 不支持。 | **S24** [changelog](https://docs.replit.com/updates/2026/09/04/changelog)、[Analytics](https://docs.replit.com/features/publishing/project-analytics) |
| E25 | **F25** Qwen 官方 X 索引出现 CommerceAgentBench 线索，框架支持 Browser/Code/RAG/MCP；**D25** 不采具体分数。 | **J25** 商业任务评测值得跟踪。 | **L25** 无论文/仓库正文和第二来源，“最强”未验证；框架无本周版本。 | **S25** [官方 X](https://x.com/Alibaba_Qwen)、[Qwen-Agent](https://github.com/QwenLM/Qwen-Agent) |
| E26 | **F26** Comet/Genspark/Kimi/AutoGLM 本周静默；Mariner 已于 2026-05 关闭独立入口；**D26** 无本周价格、客户或任务成功率。 | **J26** 固定对象需保留静默与终止，不用旧能力凑动态。 | **L26** Comet/Genspark 403，不能完全排除未索引小版本。 | **S26** [Comet](https://www.perplexity.ai/comet)、[Genspark](https://www.genspark.ai/)、[Kimi](https://www.kimi.com/)、[AutoGLM](https://github.com/zai-org/Open-AutoGLM)、[Mariner](https://labs.google.com/mariner/landing) |
| E27 | **F27** Microsoft 以应用保存规则、workflow 确定性迁移、Agent 推理、高风险人审构成混合流程；**D27** NFL 为案例但无成本/事故率/ROI。 | **J27** 路线是治理平台化而非最大自治。 | **L27** 许可和部署复杂度分散于多产品。 | **S27** [Microsoft](https://www.microsoft.com/en-us/microsoft-365/blog/2026/09/03/ppcc-2026-bringing-ai-and-your-business-processes-together/) |
| E28 | **F28** Experian/ServiceNow 以 gateway、IAM、日志、adversarial compliance test、deterministic+HITL 运行；**D28** 无量化 ROI。 | **J28** 受监管 Agent 采用依赖模型外控制与测试晋级。 | **L28** 本周为深访工程细节，正式合作是旧闻；架构主要自述。 | **S28** [深访](https://siliconangle.com/2026/09/04/experian-expands-into-ai-agents-with-servicenow-partnership/) |
| E29 | **F29** Glean、Coze 本周静默；**D29** Glean 81% token 降幅/78% preference 是 8/26 旧闻与厂商自测。 | **J29** 企业雷达不能把窗口外营销重新包装。 | **L29** changelog 索引弱，旧 benchmark 无独立复现。 | **S29** [Glean 旧闻](https://www.glean.com/press/glean-takes-on-enterprise-ais-biggest-bottlenecks-context-gaps-rising-costs-and-ai-sprawl)、[Coze](https://www.coze.cn/) |
| E30 | **F30** MCP core spec 本周无更新；context-mode 将原始工具结果放入 sandbox，仅返回摘要；**D30** 作者自报 315KB→5.4KB（98%）。 | **J30** MCP 负责互操作，不负责强制授权。 | **L30** 98% 未复现，hook/规则漂移仍是弱点。 | **S30** [MCP](https://modelcontextprotocol.io/specification/2026-07-28)、[context-mode](https://github.com/mksglu/context-mode) |
| E31 | **F31** OSWorld 2.0 有 108 workflows/31环境/平均300+ steps/27 checkpoints；**D31** 原论文最强 binary 20.6%/partial 54.8%，本周作者谈话新数待配置复核。 | **J31** 评测进入小时级动态状态与安全副作用。 | **L31** 版本、harness、binary/partial 不混比。 | **S31** [精读](https://snorkel.ai/blog/osworld-2-0-why-computer-use-agents-fail-most-tasks/)、[代码](https://github.com/xlang-ai/OSWorld-V2) |
| E32 | **F32** SWE-bench Multimodal v2 从 517 筛为 480 个可复现视觉任务并重建 grading；**D32** 普通本地评测建议约120GB/16GB/8CPU。 | **J32** UI coding/computer use 有更贴近真实的基础评测。 | **L32** 单分数不代表权限/安全/采用；mini-SWE-agent 1.x/2.x 不必然可比。 | **S32** [Multimodal](https://swebench.com/multimodal)、[仓库](https://github.com/SWE-bench/SWE-bench) |
| E33 | **F33** SWE-bench 普通榜、WebArena、GAIA、τ-bench 本周无可审计正式更新；**D33** 第三方“96%”及 τ→τ³ 摘要不采。 | **J33** 高分必须携带 scaffold、budget、pass@k、污染与版本。 | **L33** 不跨 benchmark 代际和运行配置比较。 | **S33** [SWE-bench](https://www.swebench.com/)、[WebArena](https://webarena.dev/)、[GAIA](https://huggingface.co/gaia-benchmark)、[τ-bench](https://github.com/sierra-research/tau-bench) |
| E34 | **F34** 本周安全研究覆盖多 Agent、memory poisoning、hooks、累计不可逆预算和 collusion；**D34** CAPTURE adaptive 24.7%，HookPry 1,000 runs 全 compromise，风险预算最多超48倍等。 | **J34** 威胁由单次注入扩到 hooks、memory、跨 principal 与 fleet 累计风险。 | **L34** 多为 preprint/under review/workshop或窄实验，不能外推生产发生率。 | **S34** [SoK](https://arxiv.org/abs/2609.00595)、[CAPTURE](https://arxiv.org/abs/2609.02265)、[HookPry](https://arxiv.org/abs/2609.03884)、[Budget](https://arxiv.org/abs/2609.00275)、[Monitoring](https://arxiv.org/abs/2609.03035) |

## 四、雷达归档视图

### 4.1 开源生态雷达
- **高频推进：** E01 OpenClaw、E02 Dify、E07 ADK Go、E13 CrewAI、E14 browser-use、E15 AutoGPT beta、E16 Hermes。
- **CLI/宿主可靠性：** E17 OpenCode、E18 Cline、E19 Gemini CLI、E20 Claude Code、E21 Codex CLI。
- **静默但继续观察：** LangGraph、LlamaIndex、OpenAI Agents SDK、OpenHands。
- **生命周期风险：** AutoGen maintenance；MetaGPT、SuperAGI、Aider 长期不发正式版；Roo Code 阶段性静默。采购时维护状态与依赖适配权重不得被累计 stars 覆盖。

### 4.2 Agent 产品雷达
- **强动态：** E03 Astra、E04 Fable 后台、E08 Manus、E23 Cursor、E24 Replit、E06 Devin Next。
- **研究线索：** E25 Qwen CommerceAgentBench，只列待精读。
- **静默：** Comet、Genspark、Kimi、AutoGLM。
- **终止/迁移：** Project Mariner 独立产品关闭，后续迁移到 Gemini Agent/Chrome auto-browse 雷达。

### 4.3 企业 / 协议 / 评测 / 安全雷达
- **企业：** E05 Salesforce 套餐与多 Agent；E27 Microsoft 混合流程；E12 Harvey 持续法律扫描；E11 Sierra ARR 自报；E28 ServiceNow/Experian 受监管工程；Glean/Coze 静默。
- **协议与工程：** MCP core 静默但生态扩张；E09 memory/context、E10 外部控制面、E30 context-mode。
- **评测：** E31 OSWorld 长程动态任务、E32 Multimodal v2；SWE-bench 普通榜/WebArena/GAIA/τ-bench 静默。
- **安全：** E34 仅作 preprint 风险雷达，不以实验攻击率替代生产数据。

## 五、写作与采购可用判断

1. **能力协商：** 模型、工具、宿主和订阅权限做运行时握手，拒绝版本正则和隐式工具假设。
2. **长时任务：** 验证 checkpoint、跨重启恢复、幂等、部分结果保存、上下文来源和失败后状态损坏率。
3. **sandbox：** 要求“注册断言 + 负向测试 + 逃逸面清单”，覆盖 socket、daemon CLI、IPC、共享内存、symlink、网络和宿主挂载。
4. **外部控制面：** 每个 Agent 独立 identity、短时 scoped credentials、参数级 policy、不可绕过 HITL、tamper-evident audit，并记录 delegating human、policy version、verdict、tool result 和 memory write。
5. **不可逆动作：** 按主体做跨时间累计预算，不只逐动作确认；发送、删除、支付前显示对象、身份、金额/内容和差异。
6. **benchmark：** 固定模型快照、Agent/scaffold、容器、成本、rollout/retry、轨迹和安全干预；同时报告 strict/binary、partial、HITL、恢复、状态损坏和成本。
7. **商业采购：** 把 seat、credits、token/cache、工具调用、截图、重试、人工和事故成本合成“成功任务总成本”；要求客户级净收益而不是 ARR 或厂商“价值增加”。

## 六、研究门控摘要

- **候选观察点：54；固定/实质对象主题覆盖：52；有料：30；静默：21；背景：1。** C 组 12 个候选观察点并入 10 个固定对象，故两种合计不同。
- **正文精读：约119 篇/页；采用来源：96（四组口径相加，跨组未全局去重）。**
- A/B/C/D 分别精读约 **35 / 42 / 16 / 26**；采用来源 **7 / 60 / 20 / 9**。
- 父会话已用 `web_fetch` 对 [OpenClaw v2026.9.2](https://github.com/openclaw/openclaw/releases/tag/v2026.9.2)、[Dify v1.17.0](https://github.com/langgenius/dify/releases/tag/1.17.0)、[Gemini CLI v0.58.0](https://github.com/google-gemini/gemini-cli/releases/tag/v0.58.0)、[GPT-6 Astra](https://openai.com/index/gpt-6-astra/)、[Salesforce 2026 Editions](https://www.salesforce.com/news/stories/salesforce-simplifies-editions-2026/) 完成五项抽检：均 HTTP 200，关键版本/数据吻合。
- 详细账本见 `shared/artifacts/weekly-agent/research-gate-2026-09-07.md`。

## 七、未关闭缺口

1. OpenAI/Anthropic、Mem0/OpenViking、Salesforce、Sierra 等关键数字缺独立复现或审计。
2. 企业客户级 ROI、人工接管率、失败恢复成本、生产 SLA 和提示注入成功率普遍缺失。
3. Qwen CommerceAgentBench 缺论文/仓库正文及第二来源；不报分数。
4. Comet/Genspark 遭 403，Coze/Glean 索引弱；不能完全排除未索引小版本。
5. GitHub 匿名 API 限流使部分 stars/forks 仅为近似；Aider/Roo 当期计数未引用。
6. 安全论文多为 preprint；实验数字仅用于威胁建模，不可直接转写为现实事故概率。
