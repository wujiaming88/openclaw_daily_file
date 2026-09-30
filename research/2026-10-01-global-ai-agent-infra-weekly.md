# 全球 AI Agent 基础设施研究周报 · 第 15 期（2026-09-24 ~ 2026-09-30）（研究母稿）

- run_id: `agent-infra-20261001T060000+0800-fdf1d555`
- 冻结窗口: `2026-09-24 00:00:00 +0800 ~ 2026-09-30 24:00:00 +0800`（UTC `2026-09-23T16:00Z ~ 2026-09-30T16:00Z`，不含 10-01）
- 覆盖模块: 模块1 Harness / Agent OS 控制层、模块2 Runtime / Session / State 执行层、模块3 Sandbox / Computer Use / Browser 执行环境层、模块4 Tool Gateway / Protocol / Integration、模块5 Identity / Auth / Permission、模块6 Context / Memory / Knowledge、模块7 Observability / Eval / Guardrails、模块8 Managed Agent Platform / Enterprise Control Plane（8/8）
- 覆盖平台: 7 个云厂 / 平台（AWS Bedrock AgentCore、Google Gemini Enterprise Agent Platform、Microsoft Foundry、阿里云百炼 / Model Studio、火山引擎 Ark / Coze、腾讯云智能体平台、Databricks）（7/7）
- 来源计数口径: 以「互不重复的一手来源」计数，含官方文档 / 发布页、GitHub release 与 commit API 直查、具名媒体；GitHub stars、forks 与 release 时间戳均为 2026-10-01 取得时快照，非窗口内增速。分模块计数见各模块与「覆盖审计与局限」。
- 证据口径: 逐主张按 A（可核原始事实）/ B（具名披露或研究结果）/ C（有限范围的独立佐证）/ D（欠证或争议）分级采用；紧邻数字标注归属、期间与口径；厂商自述未独立核实者显式标注。

## 本周总览与跨模块判断

1. **托管 harness 正面开战，控制层价值从「框架库」迁到「托管 runtime + 治理 + 观测」。** OpenAI 9/10 公测 Agents API（托管 Codex harness：会话编排、上下文自动压缩、恢复、自选沙箱），9/29（DevDay 2026）再把 computer use 接进 Agents API 并发布 always-on agent 产品 Dots；LangChain 9/24 Interrupt NYC 推出 Managed Deep Agents（`/v1/deepagents` 托管 runtime）与 Sandboxes GA；AWS 9 月为 AgentCore harness 补交互式 shell 与 lifecycle hooks，并上线由 OpenAI 驱动、跑在 AWS 治理边界内的 Bedrock Managed Agents（预览，9/29）；Databricks 9/29 用 `databricks-agentbricks` CLI 把脚手架→本地跑→部署→托管 memory/sessions/tools→MLflow tracing 串成一条已认证命令。

2. **skill 升为一等控制面、且正成为治理与遥测的公共维度。** LangSmith 新 Context Hub 对 AGENTS.md / skills / policies 做版本化；AWS 把 agent skills 做成可批量版本治理资产（`aws agent-toolkit check-skill-updates` / `update-skill --all`，9/30）并在 Marketplace 支持技能计量计费（9/30）；Langfuse 上线 skills 基础管理与草稿变更追踪（v4.46.0 / v4.48.0）；OpenTelemetry GenAI 语义约定新增 `gen_ai.skill.*` 工具 span 属性（9/29）；OpenViking v0.4.22 把 Skill 整包纳入 context database 索引并在会话开始注入 Skill 目录。跨厂商同时把「skill」从产品概念抬为标识与遥测维度。

3. **Memory 从「向量检索 API」走向「Context Database」。** 火山引擎 OpenViking v0.4.22（9/28）把「Memory + Knowledge RAG + Skills」收进一个文件系统式 context database；Mem0 v2.2.1（9/25）与 Cognee v1.6.2（9/29）同期收敛到同一主题——「不许静默丢数据、不许错打分」；Graphiti 把知识图谱接到 MCP SDK 2.x 并按 `group_id` 做多租户路由（9/25）；MCP 正成为记忆 / 知识 / 技能的统一接入协议，`.agents/skills` 目录约定在多个项目间趋同。

4. **工具授权下移到「网关 + 目录 + 逐 agent 身份」，并暴露委派链的信任根风险。** Postman Fabric Gateway 正式 GA（9/29）做协议无关的 agentic 控制面；AWS / 微软 / Google 三云路线趋同（协议无关网关 + 注册目录 + 逐 agent 身份）；微软把 agent 当「有 owner、有生命周期、可 block / 删除 / 恢复」的第一类主体（Foundry 自动建专属 Entra 身份，M365 Agent Registry 提供治理动作）；同周 MCP 官方 Python SDK 被披露 OAuth 凭据窃取高危漏洞（GHSA-qx49-fqc8-xw99，9/28 公告），说明「授权服务器发现」这一跳不校验即全链失守。

5. **观测治理落到共同硬指标：成本 / token 口径与「策略执行对用户可见」。** Langfuse 连续修 Anthropic 1 小时缓存写计费、OpenAI cache-write token 计费、失败 / 取消的生成不再推断 usage；Firecrawl 把 cached 与 reasoning token 纳入遥测；Google 9/29 给语义治理策略加自定义拒绝消息（≤1000 字符）；AWS 用 lifecycle hooks 提供同步 allow / deny 与 Consent Portal；Arize Phoenix 把 bash 工具非零退出标为 span error；CodeMender v0.10.0 增加 SARIF 导出与按严重度 CI 门禁。同时 OTel 导出器 `otlp-proto-http 1.45` 兼容问题被 Langfuse、Braintrust、Phoenix 同期撞上，标准版本漂移已成全行业集成风险。

6. **执行体商品化 vs 自托管供给：同一问题出现两种答案。** OpenAI Dots（9/29）把「自带云电脑 + 自带浏览器 + 24/7 生命周期 + 身份」打包为产品；开源侧 trueforge、ZCode（Z.ai 官方开源 coding harness）、hermes-agent v2026.9.24 在同一窗口发布，OpenClaw 则以 v2026.9.6 / v2026.9.7 把外部 harness 接成可选 runtime、并补齐备份回滚与重启恢复。差异点收敛为「状态所有权与数据主权」，而非能力有无。

## 模块1 Harness / Agent OS 控制层

### 本周模块结论

- **托管 Harness 正面开战**：OpenAI 9/10 公测 Agents API（把 Codex harness 变成托管服务：会话编排、上下文自动压缩、恢复，自选沙箱），9/29 再把 computer use 接进 Agents API；LangChain 9/24 Interrupt NYC 推出 Managed Deep Agents（`/v1/deepagents` 托管 runtime）与 Sandboxes GA；AWS 9 月给 AgentCore harness 加交互式 shell 与 lifecycle hooks。控制层的价值正从「框架库」迁到「托管 runtime + 治理 + 观测」。
- **AGENTS.md / skills 升为一等控制面**：LangSmith 新 Context Hub 专门对 AGENTS.md / skills / policies 做版本化；AWS AgentCore Evaluations 的 `Builtin.SkillSelectionAccuracy` 与 `Builtin.SkillInstructionFollowing` 两个 skill 级评估器官方列在 8 月（背景，非本周，经更正）；OpenClaw 的 workspace / skills 抽象与之一致。
- **编排层趋同，差异移到「长时执行三件套」**：持久会话 + 检查点、沙箱代码执行、评估 / 观测成为共同卖点（LangGraph checkpointer、Claude Managed Agents、MS Agent Framework 1.0 GA）。纯编排图已非护城河。
- **OpenClaw 参照意义**：本周 72 小时内连发 9.6 / 9.7，9.7 接入 OpenAI Agents API 与 Sign in with ChatGPT（Beta），9.6 给 remote workspace 补 Files / Memory / Skills 与 restart recovery——与云厂「托管 harness + 恢复 + 技能」同框；OpenClaw 的差异点是自托管、多渠道、本地模型，而非托管沙箱。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | v2026.9.6（9/24 07:21+0800）、v2026.8.33（9/29）、v2026.9.7（9/30 12:44+0800）连发；9.7 接 OpenAI Agents API | docs.openclaw.ai/releases、gh api releases | 是 |
| OpenAI Agents SDK / Responses / Agents API | 9/25 图像编码修复；9/29 Agents API 加 computer use，同日 GPT-6.1 Sol + Ultrafast | developers.openai.com/api/docs/changelog | 是 |
| Anthropic Claude Agent SDK / MCP / Managed Agents | 9/24 拒答计费恢复、合规 API 调整；9/28 Claude Sonnet 5.5；9/30 Sonnet 4.5 弃用 | platform.claude.com release notes | 是 |
| LangChain / LangGraph / LangSmith | 9/24 Interrupt NYC：LangSmith Engine、SmithDB、Managed Deep Agents、Sandboxes GA、Context Hub、LLM Gateway | langchain.com/blog/interrupt-2026-overview | 是 |
| Google ADK / A2A | 本周无重大公开动态（背景：ADK 2.0 于 2026-06-30，平台已更名 Gemini Enterprise Agent Platform） | adk.dev、docs.cloud.google.com release notes | 否（背景） |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 本周未取得重大动态（背景：1.0 GA 2026-04-02） | learn.microsoft.com/agent-framework | 否（背景） |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 本周未取得重大动态（背景：DAIS 2026 于 6 月发布 Agent Bricks） | databricks.com/product/artificial-intelligence/agent-bricks | 否（背景） |
| 动态池 CrewAI AMP/Studio、Dify、n8n/Flowise | 本周未取证到平台化 / runtime / observability 级动态，暂不写 | — | 否 |

### 深度笔记

#### OpenClaw（Agent OS / Gateway / cron / tool runtime / plugin & skills）

- 本周动态：72 小时内连发三版。**v2026.9.6**（发布 2026-09-23T23:21Z，北京时间 9/24 07:21，落在窗口内）引入托管更新结果可视化、**重启恢复**（未完成对话从已保存进度继续）、完整 30 天 Usage 报表、**remote workspace 新增 Files / Memory / Skills**、GitHub reader（公开讨论与 diff 紧贴聊天）、实时会议纪要；并新增 Claude Opus 5.5、GPT-6 Sol / Luna、Grok 4.7 模型支持；规模 2,614 PR + 178 direct commits + 350 contributors。**v2026.8.33**（9/29 03:12Z）为旧线维护发版（gateway-only extended-stable≈LTS，含安全汇总与模型目录更新：Meta Muse Spark 1.3、Anthropic Fable 5.1、OpenAI GPT-6 Astra、GPT-5.6 Sol / Terra / Luna 家族）。**v2026.9.7**（9/30 04:44Z，北京时间 9/30 12:44，窗口内）是重头：接入 **OpenAI Agents API** 作为可选 runtime（`/providers/openai/runtimes`）——在持久托管 Linux workspace 中跑 chat，支持 web search、OpenClaw 工具、文件传输；自托管 Agents API 执行需自有 controller 与匹配 workspace 路径、**不支持文件传输**；另有 60 秒提交截止、token usage 上报、临时服务器错误重试、live web search；同时上线 **Sign in with ChatGPT（Beta）**；更新备份 / 回滚保护与繁忙对话响应优化；规模 2,818 PR + 518 direct commits + 344 contributors。安全侧明确提示：多 agent 共用一个 Gateway 时，省略的可见性设置会让带 session 工具的 agent 读取其他 agent（含其他用户）的对话，需显式收窄；互不信任用户应分 Gateway。
- 关键数据：v2026.9.6 = 2,614 PR / 350 贡献者（2026-09-23T23:21Z）；v2026.9.7 = 2,818 PR / 518 commits / 344 贡献者（2026-09-30T04:44Z）；Agents API 自托管提交截止 60s。
- 原文链接：https://docs.openclaw.ai/releases/2026.9.7 、https://docs.openclaw.ai/releases/2026.9.6 、https://github.com/openclaw/openclaw/releases
- 影响判断：OpenClaw 本周把「外部 harness 当一等 runtime 接入」落地——Agents API 成为可选的执行后端，等于把控制权在「自托管 harness」与「云托管 harness」之间做了可切换设计；重启恢复 + remote workspace Memory / Skills 直接对标云厂的长时执行与上下文管理。风险点在于多 agent Gateway 的会话可见性默认值，本周原文明确要求升级前收窄，属实质治理动作。
- 价值链位置：运行时 / Harness 段。OpenClaw 位于「模型与算法→运行时 / Harness」交界，本周既向下兼容多模型（Opus 5.5 / GPT-6 / Grok 4.7），又向上承接云厂商用 harness（OpenAI Agents API），价值与议价落在「谁掌握会话 / 技能的持久化与恢复」——OpenClaw 用自托管 + 多渠道守住这一层，把模型与云 harness 都变成可替换件。

#### OpenAI Agents SDK / Responses API / Agents API

- 本周动态：9 月动作密集。**9/10** Agents API 进公测——托管 Codex harness，OpenAI 负责会话编排、上下文自动压缩与恢复；durable sessions、流式进度、自带工具与 MCP；沙箱可选 OpenAI 托管、自有基础设施或合作方（Blaxel、Cloudflare、Daytona、DigitalOcean、E2B、Modal、Oracle、Runloop、Vercel）；官方称使用 Agents API 无额外费用，仅按 token 与工具付费；harness 由开源 Codex 代码库驱动（github.com/openai/codex）。**9/25** 修复 GPT-6 Sol / Luna 图像编码 bug（影响视觉任务与 computer use）。**9/29** 同日三连：给 Agents API 加 **computer use**（OpenAI 托管浏览器内完成任务，网站访问审批与登录由应用处理）；发布 **GPT-6.1 Sol**（`gpt-6.1-sol`，≤272K 输入 $2 in / $0.10 cached / $2.50 cache write / $10 out，支持 Multi-agent beta，可在单次 Responses 请求中委派子 agent）；GPT-6 Astra 加 **Ultrafast mode**（`service_tier:"ultrafast"`，全局处理 + 美国数据驻留，EU 不支持）。早期 9/3 已给 Responses API 加 async tool calling、mid-turn steering、mid-conversation reasoning effort；9/15 加 API key 创建治理（组织 / 项目级）。
- 关键数据：GPT-6.1 Sol $2 / $10 每 1M token（≤272K 输入）；GPT-6 Sol $2 / $10、Luna $0.10 / $0.50（9/22 降价 50%）；Ultrafast 仅全球 + 美国驻留。
- 原文链接：https://developers.openai.com/api/docs/changelog （正文 .md 已读）、https://openai.com/index/introducing-the-agents-api/ 、https://openai.com/index/introducing-gpt-6-sol-and-luna/
- 影响判断：OpenAI 把「harness 即产品」讲得最直白——模型升级同时维护 harness，开发者按版本获得能力，等于把 harness 锁进模型订阅。computer use 进 Agents API 后，浏览器型 agent 的默认底座被 OpenAI 收编；沙箱合作方名单显示它选择做控制面而非全自建算力。
- 价值链位置：运行时 / Harness + 协议与工具。OpenAI 同时占住模型、harness、沙箱编排三层，把第三方沙箱变供给方；议价向上集中在「托管 harness + 会话恢复」，下游工具 / 沙箱商品化。

#### Anthropic Claude Agent SDK / MCP / Claude Managed Agents

- 本周动态：窗口内的平台级动作集中在 **模型 + 治理**，而非策略面。**9/28** 发布 **Claude Sonnet 5.5**（`claude-sonnet-5-5`），同日公布 5 处破坏性变更：关掉前置思考要用 `thinking:{"type":"between_tools"}`（`high` 及以下 effort），强制工具调用（`tool_choice` 为 `any` / `tool`）返回 400；thinking block 与模型 / 会话绑定，且**只在该账号或关联账号内生效**——跨账号传输时 API 会在模型看到前丢弃该 block 而请求仍成功，早期模型 block 不受影响。**9/30** 宣布弃用 Claude Sonnet 4.5（`claude-sonnet-4-5-20250929`），API 退休日 **2026-11-30**，建议迁移到 Sonnet 5.5。**9/24** 恢复对 `stop_details.category` 为 `bio` / `frontier_llm` / `reasoning_extraction`（误报量低的类别）**零输出前拒答的计费**（中途拒答此前已计费），其他类别仍不计费、fallback credit 不变；同日 Compliance API 本地会话端点对 Microsoft 365（Excel / PowerPoint / Word / Outlook，`product_surface` 以 `office_agents` 开头）转正式版，且 Activity Feed **不再返回文件名、项目文档名与产物标题**（历史记录同样被清空），需持 `read:compliance_user_data` scope 的 Compliance Access Key 才能按 ID 反查。Claude Code 客户端本周仍在连发（v2.1.283→286，9/25–9/30）。
- 关键数据：Sonnet 4.5 退休 2026-11-30；Claude Code v2.1.286（2026-09-30T19:10Z）。
- 原文链接：https://platform.claude.com/docs/en/release-notes/overview （.md 正文已读）、gh api repos/anthropics/claude-code/releases
- 影响判断：Anthropic 本周把「agent 可移植性 / 合规」而非新编排能力放在前面——thinking block 账号绑定、Compliance API 收紧元数据，都是企业治理动作。对于多 provider 客户端，Sonnet 5.5 的 5 处破坏性变更意味着模型切换层要按模型分派 `thinking` / `tool_choice`。局限：Claude Managed Agents 的组件级细节本周未取得新的窗口内官方条目（release notes 中相关条目多为 8 月），本次不作本周主张。
- 价值链位置：模型与算法 + 运行时 / Harness。Anthropic 在 harness（Managed Agents）与 SDK 已布局，本周发力点回到模型与合规治理，等于把差异化锚在「模型 + 可审计」，runtime 侧交由客户与云伙伴（Bedrock / Google Cloud / Microsoft Foundry 同步上线 Sonnet 5.5）。议价落在模型与合规 API，而非编排层。

#### LangChain / LangGraph / LangSmith

- 本周动态：**9/24 Interrupt NYC** 落地一批发布（官方博客口径「本周」）。① **LangSmith Engine v2**：在平台内自动跑 agent 改进闭环——新增 **Red Teaming**（用生产 trace 与仓库生成假设、验证尚未在生产暴露的问题）、扩展问题类型（错误率 / 延迟 / 成本趋势、重复工具调用、过长轨迹）、并可在 LangSmith Deployment 上**自动测试候选修复**（先用问题输入复现，再在更广评测集上找能解决的补丁，人工一键开 PR）；官方称 5 月上线以来 Engine 已分析 **超 6000 万条 trace**、诊断数万个问题；自有部署版下一版支持 Engine 的 BYOK。② **Managed Deep Agents v0.8**：新增**用户级记忆**（与 agent 级记忆分层、运行时不跨层复制、可分层设访问策略）与 agent / 用户双形态凭据；Slack 通道支持文件传输，新增 **HTTP 通道**（任意能发 JSON webhook 的服务）；内置 web search（由 Parallel 提供，免自建 key）。③ **LangSmith Trajectories** 与 fine-tuning 相关更新。
- 关键数据：Engine 自 5 月上线累计分析 >60M traces；Managed Deep Agents v0.8。
- 原文链接：https://www.langchain.com/blog/langsmith-engine-agents-fine-tuning-trajectories （另读 interrupt-2026-overview）
- 影响判断：LangChain 明确把自己定位成「agent 工程平台」，本周补的是**运行时可观测 + 评测 + 身份范围记忆**三件套，而不是新的编排语法——说明纯图编排已商品化，钱在「运行 + 观测 + 治理」。Red Teaming 让 Engine 从被动看 trace 变成主动找问题，等于把「评估」环节产品化。Managed Deep Agents 的「agent 级 memory / 用户级 memory 分层 + 自带通道（Slack / HTTP）」几乎是会话 + 多渠道 + 记忆模型的托管版，是可对标的竞争形态。
- 价值链位置：平台与工具链（runtime + observability / eval）。LangChain 从框架（LangGraph）升到托管 runtime 与观测平台，价值向上集中到「trace / 评测数据」这一独占资产；向下把沙箱、web search、通道标准化为自带件，伙伴（Parallel 等）被降为供给方。

#### Google ADK / A2A

- 本周动态：**本周无重大公开动态**。背景（非本周）：Python ADK 1.0.0 稳定版 2025-05 发布，ADK 2.0 于 2026-06-30 在 adk.dev/2.0 发布；平台侧 Vertex AI 已更名 **Gemini Enterprise Agent Platform**，ADK 作为其开源开发框架（Python / 其他语言），A2A 为 agent 间协议。
- 关键数据：—（本周窗口内未取得）。
- 原文链接：https://adk.dev/ 、https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes （本周条目为模型与治理类，非 ADK 本体）
- 影响判断：ADK 的重心已并入 Gemini Enterprise Agent Platform 的「开发框架」位，本周无新编排能力发布。局限：未在本周取得 ADK 仓库 / 文档的具体 release，故不写本周主张。
- 价值链位置：运行时 / Harness（框架位）。位置待明确——ADK 与平台绑定较深，其独立议价能力取决于 A2A 协议的外部采纳度，本周未取得新证据。

#### Microsoft Agent Framework / Semantic Kernel / AutoGen

- 本周动态：**本周未取得重大公开动态**。背景（非本周）：Microsoft Agent Framework（Semantic Kernel + AutoGen 合并）已于 **2026-04-02** 达 1.0 GA（Python 与 .NET）；本窗口前最近的官方汇总为 2026-09-09 发布的《What's new in Microsoft Foundry: July and August 2026》，其中 **Hosted Agents、Voice Live 集成、Toolboxes 均转 GA**，Foundry 提供托管 agent runtime；Claude 托管部署在 Azure 侧新增结构化输出、Web search、Web fetch、MCP connector、Tool search；Model Router 扩充区域与模型池；Python / JS SDK 稳定在 2.5.0、Java 2.4.0，.NET 3.0.0 仍为预览。
- 关键数据：Hosted Agents GA 于 2026-07-09（官方博客口径）；Python / JS SDK 2.5.0、Java 2.4.0（2026-08 底）。
- 原文链接：https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-july-august-2026/
- 影响判断：Microsoft 的 agent runtime（Hosted Agents）已在 7 月 GA，本周处于发布间歇；其「框架开源 + Foundry 托管 + Copilot Studio 低代码」三层结构已成型。局限：窗口内未取得 9 月下半月官方条目，按「本周无重大公开动态」处理。
- 价值链位置：平台与工具链。Microsoft 靠 Azure / Entra / M365 分发把 agent 平台下沉到既有企业身份与办公场景，议价落在「身份 + 合规 + 分发」，编排框架开源化并被托管层吸收。

#### Databricks Mosaic AI Agent Framework / Agent Bricks（背景）

- 本周动态：**本周未取得重大公开动态**（本模块口径）。背景（非本周）：Agent Bricks 于 2026-06 DAIS（Data + AI Summit）发布为统一 agent 平台，主打统一开发 / 管理 / 治理企业 agent、抑制 agent 泛滥；底层依赖 Mosaic AI Model Serving 与 AI Gateway。（注：平台层在本窗口内实有 9/29 发布，详见模块 8。）
- 关键数据：—（本模块口径本周未取得；平台层 9/29 数据见模块 8）。
- 原文链接：https://www.databricks.com/product/artificial-intelligence/agent-bricks （本周未取得新条目）
- 影响判断：Databricks 的差异化在「数据 + 治理」而非 runtime 性能。局限：本模块未取得窗口内官方发布，位置判断维持「平台与工具链中偏数据治理」。
- 价值链位置：平台与工具链（数据治理侧）。位置待明确。

#### 热点补漏：truefoundry/trueforge

- 本周动态：自述为「The open-source agent harness - the runtime layer that turns an LLM into a working agent」，仓库创建于 2026-07-23。窗口内确有发版：**2026-09-30T13:03Z（北京时间 9/30 21:03）同批发布 3 个包**——`@truefoundry/trueforge@0.3.1`（核心）、`@truefoundry/trueforge-ui@0.4.1`、`@truefoundry/trueforge-assistant-ui-runtime@0.2.1`。核心包 0.3.1 的 release body 仅一行说明：把前端内 assistant-ui-runtime 的 **Chat History 不可变会话（immutable-session）修复**与 **`mcp.auth_required` 重复消息修复**打进打包前端。仓库 2026-09-30T21:02Z 仍有 push。
- 关键数据：stars 6,031（2026-10-01 直查快照，无跨期基线故不计周增速）；窗口内 release 3 个，均为 2026-09-30T13:03Z。
- 原文链接：https://github.com/truefoundry/trueforge 、gh api repos/truefoundry/trueforge/releases
- 影响判断：本窗口内只有 patch 级发版，能力信号弱——真正可读的是它的**定位主张**（「开源 agent harness」）。这与 OpenAI Agents API、LangChain Managed Deep Agents 同期出现，说明 harness 层除了云厂托管供给，也出现了自托管开源供给。局限：0.3.1 为 patch，无大版本与能力清单，不足以支撑「能力追赶云厂」之类主张。
- 价值链位置：运行时 / Harness 段的开源供给方。价值与议价落在「能否自托管并接管会话 / 工具执行」，本周证据仅够证明该项目在维护，不够证明其竞争力。

#### 热点补漏：zai-org/ZCode（Z.ai 官方开源 coding harness）

- 本周动态：核实热度补漏中「Z.ai 开源 coding harness（二手目录页线索）」——一手仓库为 **`zai-org/ZCode`**，Apache-2.0，仓库创建 **2026-09-20**，初始提交 `feat: open source`（2026-09-20T21:14Z）。唯一 release **v3.14.3 于 2026-09-24T10:54Z 发布（北京时间 9/24 18:54，落在窗口内）**，同日 `feat: update v3.14.3` 提交；仓库 2026-09-29 仍有 push。stars 7,252。
- 关键数据：v3.14.3 published_at 2026-09-24T10:54:12Z；Apache-2.0；7,252 stars（2026-10-01 快照）。
- 原文链接：https://github.com/zai-org/ZCode （含 releases 与 commits API）
- 影响判断：Z.ai 走的是「模型厂开源自家 harness 绑定自家模型」的路径（ZCode 面向其 GLM 系模型），与 OpenAI 开源 Codex 驱动 Agents API 属同一打法：harness 成为模型的分发渠道。局限：第三方与二手目录（flowtivity、LinkedIn 帖）称其含多 agent 编排与 1M token 上下文，**本次未在官方 release body 中核实**，仅作线索不采信。
- 价值链位置：运行时 / Harness，模型厂垂直整合位。议价锚在其绑定的自研模型，而非 harness 本身的可移植性。

#### 热点补漏：NousResearch/hermes-agent

- 本周动态：核实 v2026.9.24——确认落在窗口内。**v0.21.5（tag `v2026.9.24`）于 2026-09-24T10:09Z 发布（北京时间 9/24 18:09）**，且非 prerelease。release body 明示这是 **patch 汇总版**：自 v0.21.4 起窗口含 **1,610 个非合并提交、4,828 个变更文件（+164,132 / −149,440）、460 个已合并 PR、475 个已关闭 issue**，完整 curated notes 推迟到 v0.22.0。body 列出的窗口内工作包括：Desktop **插件 SDK 波次**（composer draft API、session-list 与 row-decoration 插槽、侧栏导航偏好、model-pill 标签提供者、typed settings / skills / toolsets / profiles 桥、**沙箱化 embed 原语**、外观设置插槽、插件后端公开事件桥）、Desktop 新增 Simple / Advanced 界面模式、**Connectors 页取代 MCP tab**（含新装插件 MCP server 的 「Connect now」）、主机多路复用下按 profile 独立 stop / start / restart 与 `gateway.standalone` 选项、CLI / TUI **live dock 展示常驻 `/goal` 与排队 prompt**、webhook 投递镜像进目标聊天会话、catalog 加入 GPT-6 Sol / Terra / Luna 与 Claude Opus 5.5。stars 250,327。
- 关键数据：v2026.9.24 published 2026-09-24T10:09:38Z；窗口 1,610 commits / 460 PRs。
- 原文链接：https://github.com/NousResearch/hermes-agent/releases/tag/v2026.9.24 （gh api release body 全文已读）
- 影响判断：hermes-agent 的形态与 OpenClaw 高度同构（Gateway / profile 多路复用、skills / toolsets、MCP connectors、插件 SDK、常驻 goal 与排队 prompt），本周的重点是把**插件与连接器面产品化**并把沙箱化 embed 作为原语。局限：热度补漏线索称该版含「桌面浏览器驱动」，**本次在 release body 中未见该表述**（body 只提 hosted `-desktop` 镜像上的 Bot Screen），故不据此写浏览器 / computer-use 主张；完整功能落在 v0.22.0，本期只能按 patch 汇总限述。
- 价值链位置：运行时 / Harness（自托管 agent OS）+ 工具网关。插件 SDK 与 Connectors 页把「工具 / 技能的接入面」变成生态入口，议价落在插件目录与 profile 隔离能力。

（另：热度补漏提名的 DeepSeek 开源 harness 属 2026-08-13 报道，**窗口外**，仅背景，不补入。）

### 模块洞察（模块1）

这层正在**云厂收编**：本周最强信号不是新框架，而是三家同时把「harness 变成托管服务」——OpenAI Agents API 公测并加 computer use、LangChain Managed Deep Agents v0.8、AWS AgentCore harness 加交互式 shell 与生命周期钩子；编排框架退居第二，竞争点移到「持久会话 / 检查点 + 沙箱代码执行 + 技能与上下文治理 + 观测评测」。自托管与开源自托管侧（OpenClaw、hermes-agent、trueforge、ZCode）与云托管 harness 同框。OpenClaw 的对照价值在于以自托管方式提供同构能力（重启恢复、remote workspace Memory / Skills、重启后恢复未完成工作、接入外部 harness 作可选 runtime），但在托管沙箱与评估体系上仍需外部件补位。

## 模块2 Runtime / Session / State 执行层

### 本周模块结论

- **最强信号（修订后）：OpenAI Dots（9/29）把「always-on + 自带云电脑 + 自带浏览器 + 24/7 生命周期 + 身份」做成产品级打包**，这是本周 runtime 层最强的商品化信号；其次才是三云厂的运行时治理能力（AgentCore harness shell / hooks、Foundry long-running agent 套件、OpenClaw v2026.9.7 备份回滚与重启恢复）。
- **竞争焦点已从「能否拉起容器」转向长时 / 有状态会话的生命周期与故障恢复**：OpenClaw v2026.9.7（09-30）把 OpenAI Agents API runtime、更新前自动备份 + 回滚、重启后续接纳入 gateway 核心；Anthropic 09-28 发布 Claude Sonnet 5.5，并把 thinking 块绑定到会话与账号；Microsoft Foundry 9 月文档把 long-running agent 的「崩溃恢复 / 状态管理 / steer」做成成套 how-to。
- **竞争格局：云厂卖「托管控制面 + 治理」，模型厂开始直接卖「常驻执行体」，开源侧在补多 profile 生命周期与状态恢复。** AWS / Google / Azure 三家把 runtime 做成「Agent 托管控制面 + 会话 / 内存 / 可观测」整包；国内阿里云百炼 09-24 上线「高代码应用」（Python 项目结构直部 AI 后端，内置运维 / 日志），是本周国内最明确的 runtime 侧动作；腾讯云 ADP 侧仅模型下线切换，无 runtime 级新品。
- **OpenClaw 参照意义（更新）**：OpenClaw 的 session / cron / Gateway 与 Dots 的「常驻云电脑」是同构问题；外部对手补的正是 OpenClaw 已有的「重启恢复、更新回滚、memory / session 状态」能力。OpenClaw 的差异价值在于自托管与数据主权，而非能力有无；需持续跟踪其恢复语义（幂等、断点续跑）。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 9 月 release notes 新增 harness 交互式 shell（WebSocket）、lifecycle hooks、自定义 OpenAI 兼容端点、Consent Portal；新版 Runtime GA 在 09-18（窗口外） | docs.aws.amazon.com/bedrock-agentcore/.../release-notes.html | 是 |
| Google Vertex AI Agent Engine | 09-28 Vertex AI release notes 仅 Workbench 容器补丁；generative-ai notes 最新条目停在 05-26；本周无 Agent Engine / Managed Agents 重大动态 | docs.cloud.google.com/vertex-ai/docs/release-notes | 限述 |
| Microsoft Foundry Hosted Agents | 9 月文档集齐 long-running agent 预览（任务状态、崩溃恢复、steer、断线重连）；GA 预告在 9 月下旬 | learn.microsoft.com/en-us/azure/foundry/whats-new-foundry | 是 |
| 阿里云百炼 Model Studio | 09-24 上线高代码应用；09-23 工作流 Dify 导入 / 文件问答升级（窗口边界一天之差） | help.aliyun.com/zh/model-studio/application-release-notes | 是 |
| 火山方舟 Ark / Coze | 本周无重大公开动态（coze-studio 最新 release v0.5.1，2026-02-05） | gh api coze-dev/coze-studio | 否 |
| 腾讯云智能体平台 ADP | 09-27 生效 DeepSeek-V4-Flash 0731 下线切换通知；无 runtime 级新品 | cloud.tencent.com/announce/detail/2451 | 限述 |
| OpenClaw sessions / cron / Gateway | v2026.9.7（09-30，Agents API runtime + 更新备份回滚 + 重启恢复）；v2026.8.33（09-29，extended-stable）；v2026.9.6（09-23T23:21Z≈09-24 07:21+0800） | github.com/openclaw/openclaw/releases | 是 |
| E2B / Modal / Daytona | 本周未见官方 runtime / 长任务发布动态 | 搜索（serper） | 否 |
| OpenAI Dots（always-on agent） | 09-29 发布；自带云电脑与浏览器、24/7、4,000+ 应用集成、Pro / Enterprise 滚动 | openai.com/index/introducing-dots/ | 是 |
| NousResearch/hermes-agent | v2026.9.24（09-24T10:09Z，窗口内）；460 PR rollup、profile stop / start / restart、沙箱化嵌入原语 | github releases | 是 |

### 深度笔记

#### OpenClaw sessions / cron / Gateway runtime

- 本周动态：OpenClaw 于 09-30 发布 v2026.9.7（tag 时间 2026-09-30T04:44:14Z），官方摘要明确四项与执行层直接相关的能力：① 新增 OpenAI **Agents API** 运行时（docs.openclaw.ai/providers/openai/runtimes）与 Sign in with ChatGPT（Beta）；② 更新安全——升级前备份每份状态与 agent 数据库、回滚时恢复（见 v2026.9.7 release notes 与 GitHub Releases 摘要）；③ 高负载下响应更快、长对话更稳；④ 「重启后继续手上的活」的恢复帮助。规模为 2,818 PR / 518 direct commits / 344 contributors。另有 v2026.8.33（09-29，gateway-only extended-stable≈LTS，含安全汇总与模型目录更新：Meta Muse Spark 1.3、Anthropic Fable 5.1、OpenAI GPT-6 Astra、GPT-5.6 Sol / Terra / Luna 家族），以及 v2026.9.6（2026-09-23T23:21:10Z，按 +0800 落在窗口首日清晨）。
- 关键数据：2,818 PR / 518 commits / 344 contributors；tag v2026.9.7 published 2026-09-30T04:44:14Z。
- 原文链接：https://docs.openclaw.ai/releases/2026.9.7 、https://github.com/openclaw/openclaw/releases （gh api 认证 GET）
- 影响判断：OpenClaw 本周把「更新可回滚 + 重启可续接 + 接入 OpenAI Agents API runtime」三件事同时补齐，等于把自托管 gateway 的可靠性叙事向云厂 hosted runtime 收敛。连带意义：多 runtime 混跑（本地 gateway + 云托管 Agents API）的会话 / 状态一致性将成为选型比较点。
- 价值链位置：位于 Agent 执行层最上游（会话 / 调度 / 状态宿主），向下传导到工具与模型调用，议价落在「状态所有权与可迁移性」。未披露：Agents API 运行时的具体托管区域与计费（未取得）。

#### AWS Bedrock AgentCore Runtime

- 本周动态：AgentCore 官方 release notes 的 「September 2026」段列出 harness（托管 agent 运行时）新增：**持久交互式 shell（终端）**——在 harness 同一隔离 microVM 内以 WebSocket 运行，保留环境变量 / 工作目录 / 命令历史 / 运行进程，可重连 detached shell 并回放最多 **256 KB** 输出，单会话最多 **10 个** shell，入口为 `InvokeAgentRuntimeCommandShell`；**lifecycle hooks**——在 before_invocation / before_tool_call / after_tool_call / after_invocation 挂 AWS Lambda（同步 allow / deny，可中断调用或跳过工具）或 SNS / EventBridge（非阻塞通知）；**自定义 OpenAI 兼容端点**（模型配置新增 `apiBase`，把直接 OpenAI 请求路由到自建网关 / 代理 / 自托管或区域端点）；**AgentCore Identity Consent Portal**（面向终端用户的同意门户，把用户导向 `portalUrl` 审批 agent 代其访问资源，需配以 JWT 入站认证为来源的 AgentCore Gateway，且身份提供方许可 scope 含 `openid`）。此外 **Evaluations 支持 TypeScript 框架**（Strands Agents、LangGraph、OpenAI Agents、Vercel AI SDK）。需注意：窗口内的确切发布日未见标注，release notes 仅按月归组；另，**新一代 AgentCore Runtime 的 GA 公告为 09-18（窗口外）**，其卖点是弹性内存回收（按实际用量而非峰值计费）与快照式冷启动，P75 冷启动 1.9–2.0 秒（镜像 200MB–2GB）对比 V1 的 5.4–30 秒，覆盖 us-east-1 / us-east-2 / us-west-2 / eu-west-1 / ap-northeast-1，创建 / 更新 runtime 时设 `platformVersion: V2`。**更正**：AgentCore Evaluations 的 `Builtin.SkillSelectionAccuracy` / `Builtin.SkillInstructionFollowing` 两个 skill 级评估器官方列在 **8 月**（背景，非本周）。
- 关键数据：P75 冷启动 1.9–2.0s vs V1 5.4–30s；重连回放缓冲 256 KB、单会话最多 10 shell；起手需直连 `InvokeAgentRuntimeCommandShell` WebSocket API（CLI 与高层 SDK shell helper 暂不支持 harness target）；2026-06-05 前部署的 agent 需重新部署才能用 shell。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html 、https://aws.amazon.com/about-aws/whats-new/2026/09/new-agentcore-runtime-generally-available/
- 影响判断：交互式 shell + lifecycle hooks 把「可长期运行且可被治理」的 runtime 推进一步——hooks 提供了发布 / 工具级准入闸门（同步 allow / deny），是 hosted runtime 少见的安全治理原语；shell 让 agent 拥有真实终端。对自建 agent runtime 的性价比空间形成直接压缩。
- 价值链位置：执行层（隔离 microVM + 托管控制面），价值落点在「可治理的长时执行」；议价来自与 Bedrock / Gateway / Identity 的绑定。局限：上述 9 月条目确切日期未在源页披露，按「本月」限述。

#### 阿里云百炼 Model Studio（高代码应用）

- 本周动态：百炼「应用功能动态」页在 09-24 新增**「高代码应用」**（新的应用类型）：支持基于 Python 项目结构直接部署 AI 后端服务，平台内置自动化运维、可观测性与日志服务等企业级能力（文档 https://help.aliyun.com/zh/model-studio/rich-code-application）。该页 09-23 另有工作流「Dify 一键导入」、智能体文件问答升级、回复自动切换更优模型、知识库创建 / 调试多项优化（22–23 日，窗口外一天）。技术含义：从「零代码智能体编排」延伸到「可托管的自定义代码后端」，即把 runtime 抽象成能承接任意 Python 服务的宿主；商业上对应把客户从「调模型 API」锁到「代码 + 运维 + 可观测」整套平台。
- 关键数据：发布日期 2026-09-24；功能名「高代码应用」。
- 原文链接：https://help.aliyun.com/zh/model-studio/application-release-notes 、https://help.aliyun.com/zh/model-studio/rich-code-application
- 影响判断：这是本周国内平台在 runtime 侧最实的一步，直接对标 Foundry / AWS 的「托管 agent 后端」。连带影响：国内客户的自定义 Python 后端有本地化托管选项后，「自托管 gateway vs 平台托管」的成本对比会变化。
- 价值链位置：执行 / 托管层偏下游（贴近应用交付），价值落在运维与可观测的打包；议价依赖阿里云生态整合。未披露：计费方式、资源规格上限、冷启动指标（源页未给出）。

#### Microsoft Foundry Hosted Agents

- 本周动态：Foundry 官方 what's-new 与 agents 文档在 8–9 月集中上线 **long-running agent（预览）** 一整套：long-running agent API 参考、崩溃弹性（deploy-resilient-agent）、任务状态管理（manage-task-state）、崩溃后恢复（recover-long-running-work）、断线重连流式输出（stream-with-reconnect）、对进行中回合的 steer、human-in-the-loop 审批。另有 agent optimizer、autopilot lifecycle、私有 skill catalog、toolbox 网络隔离、hosted agents 的 BYO registry、autopilot 生命周期与成本 / token 用量等文档。第三方汇总（Medium，作者 Dave Rendon，约 2026-09-30）称 rubric evaluator、trace / 合成数据集生成与 agent optimizer 的 **GA 定在 2026 年 9 月下旬**——该 GA 时间点属二手转述，本次未取得微软方 GA 原文（记为局限）。
- 关键数据：文档集条目数 ≥20（long-running / optimizer / autopilot 类）；GA 时间「late September 2026」为第三方转述；页面 ms.date 2026-09-01、updated_at 2026-09-09。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry
- 影响判断：Foundry 把「长时 agent 的状态与恢复」做成第一批公民 API（而非让开发者自己拼），这会把自建 runtime 的隐性成本显性化。其与 AWS 本周的 lifecycle hooks / Consent Portal 形成同构竞争：**把长时执行与人工审批做成平台原语**。
- 价值链位置：执行层 + 治理层（托管 runtime + 评估 / 优化）；价值落点在状态所有权与合规治理。局限：GA 时间点为第三方转述，窗口内未见一手发布日期。

#### OpenAI Dots（always-on agent）

- 本周动态：OpenAI 于 **2026-09-29**（DevDay 2026）发布官方博文《Introducing dots》（https://openai.com/index/introducing-dots/）。Dots 被定义为「always-on agents」，关键执行层细节：**自带云电脑（own cloud computer）与自带浏览器（own browser）**，由 GPT-6 Astra 驱动，可 24/7 朝用户目标持续工作；用户可随时打开其电脑「检视工作」（inspect its work，即可观测 / 可回放的最小承诺）；可多项目并行推进而不必分线程；可通过插件生态连接 4,000+ 应用；入口覆盖 ChatGPT、Slack、Teams；先向 Pro / Business Premium / Enterprise 分市场滚动，并预告「specialist dots」带独立身份（identity）用于访问管理、IT 配发硬件、与企业系统对接。多家外媒同日报道（Reuters / NYT / TechCrunch / The Guardian；Guardian 标题提及发布前的安全顾虑）。
- 关键数据：4,000+ 应用集成；发布日 2026-09-29；受众 Pro / Business Premium / Enterprise。正文取到约 3.8KB/8.7KB。
- 原文链接：https://openai.com/index/introducing-dots/ 、https://www.reuters.com/business/openai-takes-meta-with-always-on-dots-agent-enterprise-ai-push-2026-09-29/
- 影响判断：这是本周最强「runtime 商品化」信号——模型厂直接把「持久云电脑 + 持久浏览器 + 24h 生命周期 + 身份」打包成消费级产品，等于把 E2B / Modal / Browserbase 的能力收进自家套餐，并叠加身份治理。对自托管 session / state / cron 方案的连带影响最直接：差异点只剩「数据主权与自托管」。
- 价值链位置：横跨 Runtime（云电脑生命周期）与 Sandbox / Browser（执行环境），并向上绑定模型与身份；价值与议价落在「目标状态与身份所有权」。未披露：云电脑的隔离技术、区域、配额与计费；Recap 页动态渲染 + 429 致正文未取全。

#### NousResearch hermes-agent v2026.9.24（模块2 交叉）

- 本周动态：hermes-agent 于 **2026-09-24T10:09:38Z（＝2026-09-24 18:09 +0800，窗口内）** 发布 v0.21.5（标签 v2026.9.24），为一枚 patch / rollup：自 v0.21.4 以来约 **460 个已合并 PR**、**1,610 个非 merge 提交**、4,828 个改动文件（+164,132 / −149,440）、475 个关闭 issue。执行层相关（release notes 明列）：Desktop 插件 SDK 波次含**沙箱化嵌入原语（sandboxed embed primitive）**与插件后端公共事件桥；**host multiplexer 下按 profile 的 stop / start / restart**，并有 `gateway.standalone` 让某 profile 退出多路复用；CLI / TUI 的 live dock 显示常驻 `/goal` 与排队提示；webhook 投递镜像到目标 chat 会话；hosted `-desktop` 镜像上的 Bot Screen；新增 GPT-6 Sol / Terra / Luna 与 Claude Opus 5.5 目录支持。官方称该窗口的完整整理笔记推迟到 v0.22.0。
- 关键数据：460 merged PR / 1,610 non-merge commits / 4,828 files；tag v2026.9.24 published 2026-09-24T10:09:38Z。
- 原文链接：https://github.com/NousResearch/hermes-agent/releases/tag/v2026.9.24
- 影响判断：hermes 本周动作集中在「多 profile 生命周期管理（stop / start / restart）与插件沙箱边界」，与 OpenClaw 的 profile / session 治理可比，是开源对照样本。
- 价值链位置：执行层 + 插件面（自托管 harness），价值落在多租户 profile 的隔离与运维。局限：该 release 明确「未在此完整整理」，细节以 v0.22.0 为准；本条按 release notes 实际披露范围限述。

### 解决方案五要素（尽量补，未披露写「未披露」）

- **OpenClaw v2026.9.7**：怎么搭＝自托管 gateway，升级前自动备份「每份状态与 agent 数据库」，失败可回滚；交付给谁＝个人 / 团队自托管用户；什么代价＝未披露（开源 / 自托管，本期未取得计费口径）；踩了什么坑＝从 2026.9.5 升级路径有专门修复，说明跨版本迁移曾出问题；能否复制＝开源可复制。
- **AWS AgentCore harness**：怎么搭＝在 AgentCore 隔离 microVM 内以 `InvokeAgentRuntimeCommandShell` over WebSocket 开交互式 shell，或挂 Lambda / SNS / EventBridge lifecycle hooks；交付给谁＝企业 agent 团队（可挂 Consent Portal 面向终端用户）；什么代价＝未披露（release notes 未给该功能的独立定价）；踩了什么坑＝官方注明 AgentCore CLI 与高层 SDK shell helpers 当时不支持 harness target，且 2026-06-05 前部署的 agent 需重新部署才能用 shell；能否复制＝平台托管，不可自托管复制。
- **阿里云百炼高代码应用**：怎么搭＝按 Python 项目结构部署 AI 后端服务，平台内置自动化运维、可观测性、日志；交付给谁＝需自定义代码逻辑的企业开发者；什么代价＝未披露；踩了什么坑＝未披露；能否复制＝平台托管，不可复制。

### 模块洞察（模块2）

Runtime 层的分水岭已从「跑得起来」转为「断得了、接得回、管得住」——备份回滚、崩溃恢复、会话 / 状态绑定与 lifecycle 治理成为本周四个平台的共同动作，自托管 gateway 与云托管 runtime 的差异正被压缩到「状态所有权」这一项；而 OpenAI Dots 显示模型厂正把常驻执行体直接做成产品。

### 本模块缺口与局限

- AWS AgentCore 9 月 release notes 各条目未标注确切发布日期，仅按月归组；除新版 Runtime GA（09-18，窗口外）外，其余条目能否计入本期窗口存疑，已按「本月」限述。
- Microsoft Foundry 评估 / optimizer 的 「late September GA」为第三方（Medium）转述，未取得微软一手 GA 原文。
- 火山方舟 / Coze、E2B、Modal、Daytona、Browserbase / Stagehand、Google Agent sandbox 本周未见窗口内官方动态，按「本周无重大公开动态」处理，未编造。
- OpenAI DevDay Recap 页为动态渲染，正文仅取到摘要段；computer use 的隔离技术、配额与定价未披露。
- 搜索适配器：serper 为主；tavily 处于冷却（>1400s）未复用；内置 web_search（brave）一度 429。

## 模块3 Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论

- **本周最强信号来自模型厂而非沙箱厂：OpenAI 在 DevDay 2026（9/29–9/30）把 computer use 收进 Agents API**，让「托管 agent 直接操作软件」成为 API 级能力；**Anthropic 于 09-28 发布 Claude Sonnet 5.5，明确弃用旧 computer use 工具版本 `computer_20251124`（Claude API / Google Cloud），改用 `computer_toolset_20260801` toolset**。两家在同周把「计算机操作」从演示推向版本化接口，且都以「工具集版本 + 会话绑定」控制执行边界。OpenAI 更把浏览器直接内置为 Dots 的自带执行环境。
- **竞争格局：** 专业浏览器 / 沙箱厂商本周无窗口内发布——Browserbase（Stagehand v4 为 08-10）、Azure Playwright Workspaces Remote MCP Server（09-17，窗口外）、AWS AgentCore Browser / Code Interpreter、E2B / Modal / Daytona 均未见窗口内动态。窗口内话语权明显向模型厂与云厂整包倾斜；hermes-agent 的沙箱化嵌入原语是开源侧少数相关动作。
- **OpenClaw 参照意义**：computer use 的接口版本化（能力集 toolset + 会话 / 账号绑定）提示执行环境要按「可回放、可观测、可治理」设计；OpenClaw 的 browser 工具链应关注与 toolset 版本绑定的兼容策略，并建立模型侧 toolset 版本探测与降级。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenAI Computer Use / Agents API | DevDay 2026：Agents API 新增 computer use；同场发布 Dots agent 产品、GPT-6.1 Sol | openai.com/index/devday-2026-recap/；theverge；cnbc | 是 |
| Anthropic Computer Use | 09-28 Sonnet 5.5 弃用 `computer_20251124`，需 `computer_toolset_20260801`；09-22 Opus 5.5 同类变更（窗口外） | platform.claude.com/docs/en/release-notes/overview | 是 |
| Azure Browser Automation / Playwright Workspaces | Remote MCP Server 公告为 09-17（窗口外）；本周无新增 | techcommunity.microsoft.com | 限述 |
| AWS AgentCore Browser / Code Interpreter | 本周无窗口内独立发布；9 月 runtime 侧新增见模块2 | docs.aws.amazon.com | 否 |
| Google Code Execution / Agent sandbox | 窗口内 Vertex release notes 仅 Workbench 补丁；Code Execution on Agent Engine 首发为 2025-09 | docs.cloud.google.com | 否 |
| Browserbase / Stagehand | 最新 release 停在 2026-08-28；本周无动态 | gh api browserbase/stagehand | 否 |
| E2B / Daytona / Modal | 本周未见官方发布 / 新版动态 | 搜索（serper） | 否 |

### 深度笔记

#### OpenAI Computer Use（Agents API）

- 本周动态：OpenAI 于 9/29–9/30 举行 DevDay 2026，官方 Recap 称「超过 20 项重大发布」，核心之一是 **Agents API 现支持 computer use**，开发者可构建直接与软件交互完成任务的 agent；同场还有可承担「持续职责」的 agent、把 ChatGPT 开放为人类与 agent 协作的共享界面（面向 12 亿周活），以及 **GPT-6.1 Sol**（OpenAI 称在 agentic coding 与 computer use 上显著增强，token 价约为 Astra 的 1/5）。此外 09-29 更新的 GPT-6 Sol / Luna 页给出 API 降价 50%（Sol $4→$2 / $20→$10；Luna $0.20→$0.10 / $1.20→$0.50 每百万 token）。
- 关键数据：1.2B 周活（官方披露，未独立核实）；GPT-6 Sol 输入 $2 / 输出 $10 每百万 token；15 小时内多源报道。
- 原文链接：https://openai.com/index/devday-2026-recap/ 、https://openai.com/index/introducing-gpt-6-sol-and-luna/ 、https://www.theverge.com/.../openai-devday-2026-biggest-news-announcements
- 影响判断：computer use 进入 Agents API 意味着「浏览器 / 桌面操作」从第三方 SDK 转入模型厂托管栈，专业浏览器厂商的差异化被压缩到合规、可观测与反爬细分。若上游把计算机操作连带会话状态一起托管，自托管 agent 的接口兼容成本上升。
- 价值链位置：执行环境层上游（模型 + 托管 runtime 提供动作原语），价值向下游传导到工具编排与合规；议价落在「动作数据与人工接管点」。未披露：computer use 的具体沙箱隔离技术、配额与定价（Recap 页为动态渲染，本次未取全）。

#### Anthropic Computer Use（Claude Sonnet 5.5）

- 本周动态：Claude Platform release notes 记载 **09-28 发布 Claude Sonnet 5.5**（`claude-sonnet-5-5`），同时公布五处兼容性破坏点，其中与执行环境直接相关的是：**在 Claude API 与 Google Cloud 上，旧 `computer_20251124` computer use 工具不再被接受**（Opus 5.5 于 09-22 已要求改用 `computer_toolset_20260801`，Amazon Bedrock 上旧版仍可用）；此外 thinking 块绑定「产出它的账号 / 会话」，跨账号发送会被丢弃；`thinking:{"type":"between_tools"}` 取代 `"disabled"`；强制工具调用（`tool_choice` any / tool）返回 400。09-30 另宣布弃用 Sonnet 4.5（11-30 退休）；09-24 恢复对部分类别前置拒绝的计费、Compliance API session 端点转正并收紧 Activity Feed 字段（不再返回文件名 / 标题）。
- 关键数据：工具版本标识 `computer_20251124`（停用）→ `computer_toolset_20260801`；Sonnet 4.5 退休日 2026-11-30。
- 原文链接：https://platform.claude.com/docs/en/release-notes/overview
- 影响判断：Anthropic 用「toolset 版本 + 账号绑定 thinking」把 computer use 的执行语义收紧，减少跨会话重放与提示注入面；代价是旧集成需迁移。模型侧工具版本迁移会周期性地打破自托管 agent 的工具兼容，需建立版本探测与降级路径。
- 价值链位置：执行环境层的接口 / 语义层（模型厂商定义动作协议），价值落点在协议控制权；议价来自模型能力绑定。局限：computer use 的官方技术白皮书细节本周未取得。

### 模块洞察（模块3）

本周执行环境层的竞争主导权进一步向模型厂集中——computer use 被「工具集版本化 + Agents API 托管」，专业沙箱 / 浏览器厂商进入跟随期；hermes-agent 的沙箱化嵌入原语与 Dots 的内置浏览器，则分别代表开源侧与模型厂侧对「执行环境边界」的两种回答。

## 模块4 Tool Gateway / Protocol / Integration 工具层

### 本周模块结论

- **最强信号：标准化工具网关从「协议层」进入「产品化 GA + 安全欠账清算」阶段。** 本周 Postman 以 Fabric Gateway 正式 GA，把「Agent 访问 API / MCP server / 工具」的发现、策略与审计收敛到一个协议无关控制面（2026-09-29，businesswire / helpnetsecurity）；同时官方 MCP Python SDK 被披露高危 OAuth 凭据窃取漏洞（GHSA-qx49-fqc8-xw99，2026-09-28 公告），说明「标准化网关」在收敛连接的同时，把认证信任边界变成了新的集中风险点。
- **竞争格局：云厂把「网关 + 目录 + 身份」三件套一次性打包。** 微软 Foundry 用 Toolbox 的「单一托管 MCP 端点」代理工具接入与鉴权；Google Gemini Enterprise Agent Platform 用 Agent Gateway + Agent Registry + Agent Identity（SPIFFE / mTLS / DPoP）；AWS AgentCore 用 Gateway + 跨账户平台账号模式。三家路线趋同：**协议无关网关 + 注册目录 + 逐 Agent 身份**，而独立网关厂商（Postman、truefoundry、Speakeasy、MintMCP）抢占「跨云统一治理」空位。
- **OpenClaw 参照意义：**（1）工具接入层应收敛为「单一网关端点 + 目录」，把「哪个工具可见 / 可被调用」从提示词搬到策略层；（2）MCP Python SDK OAuth 漏洞直接命中任何「用 SDK 自建 MCP client 且连接不完全受控 server」的形态，自建 client 必须核到 1.30.0 / 2.2.0 并补 `issuer=` 校验；（3）Google 文档明确「A2A 直连 Gemini Enterprise 不经 Agent Gateway」→ 网关策略有旁路，多入口工具治理需同样显式登记「哪些路径不受策略约束」。

### 固定对象状态表（模块4）

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP 协议本身 | 2026-07-28 规范（无状态核心 / 扩展框架）进入 9 月生态消化期；官方 Python SDK 曝 OAuth 凭据窃取高危漏洞，09-28 发布安全公告 | blog.modelcontextprotocol.io / GHSA-qx49-fqc8-xw99 / thehackernews / cycode | 是 |
| MCP server/client/gateway | 安全与 auth 进展为主：企业 MCP gateway 概念密集讨论（truefoundry / Speakeasy / MintMCP）；恶意 server 指向伪造授权端点成为实证攻击面 | truefoundry / cycode / anaconda | 是 |
| A2A | 已归 Linux Foundation AAIF（2026-08 中旬，窗口外）；本周无新规范版本（最新 release v1.0.1，2026-05-28）；Google 文档澄清 A2A 直连 Gemini Enterprise 不走 Agent Gateway | GH API a2aproject/A2A / Google docs / dataphoenix | 是 |
| Google Agent Gateway | 文档更新为 Agent Platform 治理主组件；Scale AI 参考架构（09-22）与三方报道（09-30）确认其在 A2A + MCP 架构中的位置与旁路限制 | docs.cloud.google.com / dataphoenix | 是 |
| Composio | 本周无重大公开动态；9 月上旬内容营销（对比 Pipedream、MCP 集成） | composio.dev | 否（状态记录） |
| Arcade | 本周无重大公开动态；被定位为「带逐用户 auth 与 MCP gateway 的 actions runtime」 | mintmcp / nango（9 月上旬） | 否（状态记录） |
| Nango | 本周无重大公开动态；持续输出 agent API 集成对比文（09-14 等，窗口外） | nango.dev | 否（状态记录） |
| Pipedream Connect | 本周无重大公开动态；被列为「托管 auth + 大量预建工具」集成层 | nango / zapier compare（9 月中） | 否（状态记录） |
| AWS AgentCore Gateway | 官方博客「多账户 Agent + Gateway + MCP」（约 09-24/25）；Netskope 联合治理文章（约 09-27，Cloudflare 拦截未取全文） | aws.amazon.com/blogs | 是 |
| Microsoft Toolbox / MCP-compatible endpoint | Foundry 文档（ms.date 2026-09-25）确立工具箱 = 单一托管 MCP 端点；09-29 更新工具箱鉴权文档（OAuth 身份透传） | learn.microsoft.com | 是 |

### 深度笔记

#### MCP（协议本身 + 官方 Python SDK 安全缺陷）

- 本周动态：进入 9 月，MCP 2026-07-28 规范（GH release 2026-07-28 发布）成为生态「消化」对象：核心从有状态握手改为**无状态核心**——删除 initialize / initialized 与 `Mcp-Session-Id`，每次 JSON-RPC 请求自包含，能力查询改为按需 `server/discover` RPC；新增 `Mcp-Method` / `Mcp-Name` 头供网关按操作路由；长任务改为 Tasks 扩展（`CreateTaskResult` + `taskId` + `tasks/get` / `tasks/update`，状态含 working / input_required / completed / failed / cancelled），对话内富 UI 改为 MCP Apps 扩展（`_meta.ui.resourceUri` → `ui://` 资源、沙箱 iframe + postMessage JSON-RPC）；授权侧 RC 引入 **OAuth 2.1 + OIDC 要求** 及 Enterprise-Managed Authorization（EMA）扩展；Roots / Sampling / Logging 拟弃用，配套 SEP-2596（最短 12 个月弃用窗口 + 公开弃用登记表）。真正在窗口内落地的「硬事件」是安全侧：官方 Python SDK 被披露授权服务器校验缺失，攻击者控制的 MCP server 可把 client secret、authorization code 与 PKCE 验证值诱导发送到攻击者 token 端点，进而换取真实服务访问令牌；影响 1.x 的 1.9.1–1.29.1 与 2.x 的 2.0.0–2.1.1，修复于 1.30.0 / 2.2.0（2026-09-07 发布，但当时仅以「行为变更」列入 release notes，09-28 才发布安全公告）；评分高危 7.5（无人值守的机器对机器 provider）/ 6.5（交互式 provider），截至 09-29 未分配 CVE。修复不够彻底：`ClientCredentialsOAuthProvider`、`PrivateKeyJWTOAuthProvider` 还须显式传 `issuer=` 才真正生效，被弃用的 `RFC7523OAuthClientProvider` 无此选项须迁移。
- 关键数据：影响版本 1.9.1–1.29.1 / 2.0.0–2.1.1；修复版本 1.30.0、2.2.0（GH API published_at 2026-09-07）；评分 7.5 / 6.5；公告 GHSA-qx49-fqc8-xw99（2026-09-28）；MCP 规范版本 2026-07-28。
- 原文链接：https://github.com/modelcontextprotocol/python-sdk/security/advisories/GHSA-qx49-fqc8-xw99 、https://thehackernews.com/2026/09/official-mcp-python-sdk-flaw-can-let.html （2026-09-28 前后）、https://github.com/modelcontextprotocol/modelcontextprotocol/releases/tag/2026-07-28 、https://aaif.io/blog/mcp-2026-07-28-whats-changing-and-how-to-migrate
- 影响判断：MCP 无状态化把「会话粘性」从协议层移到网关与显式 handle，直接利好网关类产品（按 `Mcp-Method` 头路由、无粘性横向扩展）；但同周的安全公告说明，协议把授权「委托给实现」后，SDK 级实现缺陷会横向污染全部下游。对自建 MCP client 的连带影响：须先升级到 1.30.0 / 2.2.0 且补 `issuer=`，并轮换可能泄露的 client secret、撤销 token、清理旧 OAuth 客户端注册。
- 价值链位置：MCP 位于「Agent ↔ 工具 / 数据」连接层的协议底座；传导方向是「协议标准化 → SDK / 网关实现 → 企业治理采购」。价值与议价落点正从「协议免费标准」转向「实现可信度与治理层」——谁能证明端点可信、授权可审计，谁掌握议价权。

#### A2A（Google / Gemini Enterprise / 跨 Agent 协议）

- 本周动态：协议本体本周无新规范版本（GitHub 最新 release v1.0.1，2026-05-28，窗口外）。本周可核的新动态集中在治理层与注册路径：Google 文档明确「策略随注册路径而异」——直接注册到 Gemini Enterprise 的 A2A agent，其流量**不经 Agent Gateway**，网关策略对该路径不生效；从 Agent Registry 导入的 agent，治理策略只对「与已配置网关关联的注册表内 agent」生效；Gemini Enterprise agent 之间、以及 agent 与 MCP 数据连接器之间的直连通信也**不触发**网关策略执行（dataphoenix.info 2026-09-30 明确引用 Google 文档）。Scale AI 于 2026-09-22（窗口外）发布与 Google Cloud 的参考架构：以 A2A + MCP 作为互操作接口、Google Agent Registry 做发现，工作负载跑在客户自己的 GCP 项目 / VPC / 加密密钥内；该文未给出客户部署、定价或 benchmark。
- 关键数据：A2A 最新 release v1.0.1（published_at 2026-05-28，GH API）；A2A 于 2026-08 中旬成为 Linux Foundation / AAIF 托管项目（与 MCP 同属一个中立治理体，窗口外）。
- 原文链接：https://dataphoenix.info/news/scale-google-cloud-enterprise-agent-architecture
- 影响判断：最重要的不是「新增协议能力」，而是**治理覆盖不齐**这一被文档化的事实——多入口注册会让同一组织内的 agent 流量一部分受策略约束、一部分旁路。任何多入口的 agent / 工具接入都应显式维护「哪些路径经网关、哪些不经」的清单，否则审计与越权防护存在结构性盲区。
- 价值链位置：A2A 位于 agent↔agent 互操作层，压在 MCP（agent↔工具）之上；价值与议价落点在注册与治理（Agent Registry / Agent Gateway），而非协议文本本身。

#### AWS AgentCore Gateway + Identity

- 本周动态：AWS 官方博客「Build a multi-account AI agent with AgentCore Gateway and MCP」（搜索显示约 2026-09-24/25）给出「中心平台账号 + 业务线（LOB）账号」模式：各 LOB 把自身数据与工具以 MCP server 暴露，平台账号的 AgentCore Gateway 为 agent 提供统一端点做工具发现与调用、安全收敛。入门指南文（约 09-27）概述 AgentCore Identity 的职责：控制「谁可调用 agent」与「agent 可代表用户访问什么」，经 IAM 或 OAuth 实现，可与 Amazon Cognito 等 provider 配合。Coding-agents 示例仓（约 09-28）显示用户经 Cognito 登录后身份随工作流进入 OpenTelemetry，CloudWatch 可按人 / 按 agent 展示用量。Netskope 联合治理文章（约 09-27）把 AgentCore Gateway 描述为「托管 MCP tool server，处理入站授权与出站凭据」。
- 关键数据：本对象仅能采用标题 / 摘要层可核对的定位表述，不写具体数值（博客正文 HTML 取得时 Response body incomplete，仅得到导航层；Netskope 页被 Cloudflare 拦截）。
- 原文链接：https://aws.amazon.com/blogs/machine-learning/build-a-multi-account-ai-agent-with-agentcore-gateway-and-mcp/ （正文未取全，记为局限）
- 影响判断：AWS 的路线是「网关承担入站授权 + 出站凭据」的托管中间人模型，把凭据从 agent 代码挪到平台层，并用跨账户把 LOB 工具统一进一个端点。连带影响：接入 AWS 工具时应走 Gateway 托管凭据，而非在 agent 内直存密钥；同时「凭据集中」意味着网关本身成为高价值攻击目标。
- 价值链位置：位于云内 agent↔工具连接层，价值落点在「MCP 工具统一端点 + 托管凭据」；传导方向是从 IAM 生态向 agent 运行时下沉；位置基本明确，商业条款未披露。

#### Google Agent Gateway（Gemini Enterprise Agent Platform）

- 本周动态：官方文档把 Agent Gateway 定位为 Agent Platform 的「关键执行组件」，是所有 agentic 交互（用户↔agent、agent↔工具、agent↔agent）的网络出入口。治理四件套：**Agent Identity**（为每个 agent 分配唯一 SPIFFE ID 作数字签名，用于认证 / 访问控制 / 审计；默认由 Context-Aware Access 以 mTLS + DPoP 做端到端加密认证）、**Agent Registry**（已批准 agent / 工具 / MCP server / 端点目录，网关据此校验权限）、**Policies**（IAM Unified Access Policies 默认全拒、需显式授权；Model Armor 实时扫描用户 prompt 与工具响应，拦 prompt injection / 敏感数据泄露 / 有害内容；Semantic Governance Policies 用自然语言规则阻止不安全工具组合；自定义授权引擎经 Service Extensions 委派三方决策）、**Agent Gateway**（mTLS 终止、协议转换 MCP / REST / gRPC、策略执行），并输出 Agent Observability 遥测到 Cloud Logging / Trace。
- 关键数据：「默认拒绝、显式 IAM 授权」；SPIFFE ID + mTLS + DPoP；支持协议 MCP / A2A / REST / gRPC；OAuth 2.0 握手由 Agent Identity Auth Manager 简化。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview （文档页，搜索显示约 09-27 更新；页面无显式发布日期，按「文档更新」而非「新闻」处理）
- 影响判断：这是本周云厂中治理要素最完整的一套（身份 + 目录 + 默认拒绝策略 + 执行 + 可观测闭环），把零信任（mTLS / DPoP / SPIFFE）直接落到 agent 运行时；但其对 A2A 直连的旁路说明该闭环并非全覆盖。
- 价值链位置：位于 agentic 流量的必经网络层，价值落点在策略执行与遥测；议价权取决于企业能否接受「默认拒绝」带来的接入摩擦。

#### Microsoft Toolbox / MCP-compatible endpoint（Foundry）

- 本周动态：Foundry Agent Service 概览（ms.date 2026-09-25，updated_at 2026-09-25，属窗口内文档更新）把 **Toolboxes** 确立为核心组件：把 web search、file search、code interpreter、MCP servers、自定义函数等工具「一次性策管」，经**单一托管 MCP 端点**共享给任意 agent / 运行时，集中处理认证、治理与版本；Identity & Security 组件为 Entra 身份 + RBAC + 内容过滤 + 虚拟网络隔离；发布侧可经 Microsoft Teams、Copilot 与 **Entra Agent Registry**。工具箱鉴权文档（updated_at 2026-09-29）给出「两个身份」模型：**agent→toolbox 边界**用 agent 自身身份（只守工具箱入口），**tool→data 边界**由 Foundry 提供代表登录用户的凭据（OAuth 授权或 audience 特定 Entra access token），下游按该用户权限与敏感度标签返回数据；认证类型含匿名、共享凭据、服务身份、登录用户身份四类；Foundry 负责 token 获取 / 交换 / 刷新 / 注入与**逐用户 token 隔离**、consent 生命周期（如 AADSTS65001）与 401/403 重试；代码侧用 `FoundryToolbox`（Python）/ `AddFoundryToolboxes`（.NET）。
- 关键数据：4 种认证类型；「两个身份」模型；工具箱鉴权文档 updated_at 2026-09-29；概览 ms.date 2026-09-25。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/tool-authentication 、https://learn.microsoft.com/en-us/azure/foundry/agents/overview
- 影响判断：微软把「逐用户令牌隔离」这一最易自建出错的安全管道收进平台（自建需按 user+tenant 正确分区 token cache，错则静默把 A 用户的下游访问暴露给 B 用户），对多用户 SaaS 型 agent 是强卖点。连带影响：工具鉴权应作为「连接属性」而非 agent 代码，可显著降低 per-tool 重实现与越权风险。
- 价值链位置：Toolbox 位于 agent↔工具连接层的托管实现，价值落点在「认证 + 逐用户隔离」的免自建，议价权来自与 Entra / Foundry 生态的绑定深度。

#### 动态池：Postman Fabric Gateway（强信号，补入）

- 本周动态：Postman 于 **2026-09-29** 宣布 Fabric Gateway **正式 GA**，定位为「协议无关的 agentic 世界控制面」，统一治理 AI agent、LLM 与 MCP server 如何发现并访问 API、工具及其他 agent，提供集中策略与监督。第三方报道称其面向 agent / API / MCP 的统一策略与治理。局限：businesswire 新闻稿被 403 拦截、helpnetsecurity 正文抽取失败，仅取得标题 / 摘要级信息，**定价、配额、支持的协议清单等未披露 / 未取得**，本对象不做数值推断。
- 关键数据：GA 日期 2026-09-29；其余未披露。
- 原文链接：https://www.helpnetsecurity.com/2026/09/29/postman-fabric-gateway/ 、https://www.businesswire.com/news/home/20260929329910/en/ （403，均未取到正文，记为局限）
- 影响判断：API 工具厂商切入 agent 治理层，说明「网关」正从协议实现变成独立产品品类，并可能被既有 API 平台凭企业关系快速收割。连带影响：工具治理层的外部选项增多，自建网关的差异化需要落在与自身运行时 / 权限模型的紧耦合上。
- 价值链位置：控制面位于 API / 工具发现与调用的中枢；位置基本明确，商业条款待明确。

#### 动态池：Composio / Arcade / Nango / Pipedream Connect

- 本周动态：**本周无重大公开动态。** 四者本周可核对的均为 9 月上中旬（窗口外）内容营销与对比文，定位稳定：Nango = 编码 agent 跨 1000+ API 生成自定义工具 + 内建 MCP server + 白标逐用户 auth；Composio = 托管 tool-calling（管理 1000+ 应用认证 + 远程沙箱）；Arcade = MCP / actions runtime，围绕逐用户 auth + MCP gateway + 身份集成；Pipedream Connect = 托管 auth 集成层（约 2,800–3,000 应用、约万级预建工具）。
- 关键数据：Nango 1000+ API；Pipedream 约 2,800+ API / 约 10,000 预建工具（nango.dev 2026-09-14，窗口外）。
- 原文链接：https://nango.dev/blog/best-mcp-servers-for-agent-api-integrations/ （窗口外，仅作定位参考）
- 影响判断：长尾连接层玩家本周静默，与云厂网关 GA / 文档更新形成「平台化 vs 长尾连接」分工；无新披露，本周不做趋势外推。
- 价值链位置：位于 agent↔SaaS 长尾连接层，价值落点在连接数量与托管 auth；位置待明确（本周无新披露）。

#### 社区 / 开源：agentic-community/mcp-gateway-registry

- 本周动态：GitHub 直查显示该仓 `pushed_at` = 2026-09-29、`updated_at` = 2026-09-30、stars = 951（取得时快照）。自述为「企业级 MCP Gateway & Registry」，集中 AI 开发工具，提供**安全 OAuth 认证**、动态工具发现、面向自主 AI agent 与编码助手的统一访问，并支持 **Keycloak / Entra 集成**，目标是「把散乱的 MCP server 治理为可审计的工具访问」。属**社区开源信号**（非厂商正式公告），本周有代码推送落在窗口内。
- 关键数据：stars 951（2026-10-01 取得快照；无跨期基线，不计算周增速）；pushed_at 2026-09-29。
- 原文链接：https://github.com/agentic-community/mcp-gateway-registry
- 影响判断：开源侧已出现与云厂同构的「网关 + 登录 + OAuth + 目录」实现，说明「受治理的工具访问」已从厂商叙事变成社区默认预期。若自建工具网关，可参考其 Keycloak / Entra 集成路径与 OAuth 授权模式。
- 价值链位置：位于 agent↔MCP server 的接入与治理层，价值落点在「自托管、可审计、可对接企业 IdP」；位置基本明确。

#### 社区 / 开源：docker/mcp-gateway

- 本周动态：最新 release v0.44.1 `published_at` = **2026-09-23**（窗口外一天），说明含「重复 prompt / resource URI 注册前拒绝」等 MCP 网关行为修正。本周（09-24 起）未见新 release；仅作为 MCP 网关生态的近期背景记录，**不写入「本周动态」**。
- 关键数据：v0.44.1（2026-09-23，窗口外）。
- 原文链接：https://github.com/docker/mcp-gateway/releases/tag/v0.44.1
- 影响判断：Docker 官方网关持续迭代，与社区 / 云厂网关形成多供给格局。
- 价值链位置：位于容器化 MCP server 的连接与注册层；位置基本明确，本周无增量。

#### 观察：MCP 规范仓库 discussion #804（Gateway-Based Authorization Model）

- 本周动态：该提案 `created_at` = 2025-06-20，`state` = **closed**，仅 `updated_at` = 2026-09-25 落在窗口内——即为一次**已关闭提案的窗口内后续讨论 / 更新**，**不构成 MCP 新规范动向**，仅作观察池记录，不得作为「网关授权模型已被规范采纳」的证据。
- 关键数据：#804，closed，updated_at 2026-09-25。
- 原文链接：https://github.com/modelcontextprotocol/modelcontextprotocol/discussions/804
- 影响判断：MCP 侧「网关化授权」目前仍是提案层讨论而非规范条款；正式授权方向以 2026-07-28 的 OAuth 2.1 / OIDC 要求与 EMA 扩展为准。不要把社区提案当作已成文的规范依据。
- 价值链位置：位于 MCP 授权治理的设计讨论层；位置待明确（提案已关闭，走向不明）。

### 模块洞察（模块4）

**一句话趋势判断：工具网关本周完成「从协议概念到 GA 产品、从连接功能到安全信任边界」的双重跃迁——云厂以「网关 + 目录 + 逐 agent 身份」三件套收口（AWS / 微软 / Google 路线趋同），平台商以协议无关控制面抢跨云治理；而 MCP Python SDK 的 OAuth 漏洞提醒：网关在收敛连接的同时也集中了信任风险，「实现可信度」成为新的议价与准入门槛。**

## 模块5 Identity / Auth / Permission 权限层

### 本周模块结论

- **最强信号：Agent 身份从「应用注册的附属物」正式升格为独立可治理对象。** 微软本周把 agent 当成「有 owner、有生命周期、可被 block / 删除 / 恢复的第一类主体」——Foundry 为每个 Hosted agent 自动创建专属 Entra 身份（2026-09-25 文档），Microsoft 365 admin center 提供 Agent Registry 的 install / activate / block / delete / 恢复窗口 30 天 / 指派新 owner 等治理动作（ms.date 2026-09-23、updated_at 2026-09-26），并新增 Agent ID Administrator 角色管理 agent 身份生命周期。这标志权限层从「给人设计」转向「给非人类主体设计」。
- **竞争格局：三云在身份层收敛到同一套要素——独立身份 + 短时凭据 + 逐用户委派 + 审计。** Microsoft = Entra Agent ID（owner / RBAC / 条件访问）+ Toolbox 逐用户 token 隔离；Google = Agent Identity（SPIFFE ID + mTLS + DPoP）+ 默认拒绝 IAM + 审计日志；AWS = AgentCore Identity（IAM / OAuth、Cognito、身份随工作流进 OpenTelemetry）。差异在治理落点：微软强在 owner / 生命周期，Google 强在零信任密码学，AWS 强在云内 IAM 集成。
- **OpenClaw 参照意义：**（1）「谁代表谁行动」必须在架构上分成两个身份（agent 自身身份 vs 代表用户的委派身份），并把逐用户 token 隔离做成平台能力而非 agent 代码；（2）越权防护的实证风险已量化——第三方调研称约 88.4% 企业在过去 12 个月遭遇过 AI agent 安全事件，最常见是数据泄露（约 50.1%）与恶意输入操纵（约 49.6%），且 82.7% 的管理者对「防未授权访问」有信心但同样约九成被攻破，说明「信心—现实」缺口大（该数据为厂商委托调研，仅作方向性参考）；（3）MCP Python SDK 漏洞说明委派链的每一跳（授权服务器发现）都必须校验，缺一跳即全链失守。

### 固定对象状态表（模块5）

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| Microsoft Entra Agent ID / Foundry agent identity | 窗口内密集更新：Foundry 概览（09-25）、Toolbox 鉴权（09-29）、M365 admin center agent 治理动作（09-23/26）、Entra Agent ID 生命周期策略、Agent ID Administrator 角色 | learn.microsoft.com | 是 |
| Microsoft Agent 365 / Agent Registry | 中央注册表 + 生命周期 + 条件访问；第三方称 「Copilot Autopilot 集成 Entra 身份治理」于 09-25 发布 | learn.microsoft.com / yahoo（NIST 稿） | 是 |
| Google Agent Identity / Gateway / Gemini Enterprise auth | Agent Identity 为每 agent 配 SPIFFE ID（mTLS+DPoP），与 Agent Registry / Gateway 协同；网关默认拒绝 IAM UAP、Model Armor、语义策略 | docs.cloud.google.com | 是 |
| AWS AgentCore Identity | IAM / OAuth 控制「谁可调用 agent / agent 可访问什么」，可配 Cognito；身份进入 OpenTelemetry 供 CloudWatch 按人 / 按 agent 计量 | builder.aws.com / aws-samples | 是 |
| Arcade Auth / tool permission | 本周无重大公开动态；定位为逐用户 auth + MCP gateway + 身份集成的 actions runtime | mintmcp / nango（9 月上旬，窗口外） | 否 |
| Composio Auth | 本周无重大公开动态；管理 1000+ 应用认证 + token 自动刷新 | composio.dev（9 月上旬，窗口外） | 否 |
| Nango OAuth / token management | 本周无重大公开动态；白标逐用户 auth + token 管理 | nango.dev（9 月中，窗口外） | 否 |
| Pipedream Connect managed auth | 本周无重大公开动态；托管 auth 集成层 | nango / zapier（9 月中，窗口外） | 否 |

### 深度笔记

#### Microsoft Entra Agent ID / Foundry agent identity / Agent 365

- 本周动态：微软在窗口内把「agent 身份治理」补成完整链路。Foundry 侧：每个部署到 Foundry 项目的 **Hosted agent 自动获得专属 Microsoft Entra ID（agent identity）与专属端点**，无需共享凭据；Agent Service 概览把 Identity & Security 列为一级组件（Entra 身份 + RBAC + 内容过滤 + VNet 隔离）。权限层：M365 admin center 的 Agent Registry 提供 install / uninstall、activate（限定用户或组实例化）、block / unblock（全组织禁用）、delete / restore / permanently delete（**30 天恢复窗口**）、start / stop（针对 Foundry agent 的底层 Azure 基础设施）、assign / add / remove owner（处理无主 agent）、publish to store / reject submission 等治理动作，并配合 Entra ID Governance 的**生命周期策略**在规模上治理 Entra Agent IDs。角色层：Entra 内置角色新增 / 强化 「Agent ID Administrator」，管理 agent 身份、agent identity blueprint principal 等的全生命周期。第三方（yahoo 稿，约 09-27）称微软于 **2026-09-25** 发布 「Copilot Autopilot」并集成 Entra 身份治理。
- 关键数据：恢复窗口 30 天；Foundry 概览 ms.date 2026-09-25；agent 治理动作文档 ms.date 2026-09-23 / updated_at 2026-09-26；Toolbox 鉴权 updated_at 2026-09-29；Copilot Autopilot 09-25（第三方报道）。
- 原文链接：https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-actions 、https://learn.microsoft.com/en-us/azure/foundry/agents/overview
- 影响判断：微软把 agent 当成与人类用户并列的「第一类身份」纳入既有 IAM 治理面（owner、生命周期、条件访问、审计），使「撤销 / 停用 / 交接」成为可操作动作而非事后补救。连带影响：agent 实体应自带 owner、生命周期状态与可撤销凭据；「无主 agent」是与「无主服务账号」同级的治理风险。
- 价值链位置：位于企业 IAM ↔ agent 运行时的交界，价值落点在「把 agent 纳入既有身份治理栈」的迁移成本优势；议价权来自 Entra / M365 的存量覆盖面。

#### Google Agent Identity / Gateway / Gemini Enterprise auth

- 本周动态：Google 把身份做成零信任密码学基座——**Agent Identity 为每个 agent 分配唯一 SPIFFE ID**（作数字签名，用于认证 / 访问控制 / 审计），默认由 Context-Aware Access 以 **mTLS + DPoP** 做端到端加密认证；与 Agent Registry（已批准 agent / 工具 / MCP server 目录）、Agent Gateway（执行点）协同：网关先用 Registry 校验权限，再执行 IAM Unified Access Policies（**默认全拒、需显式授权**）、Model Armor（实时扫 prompt 与工具响应，拦 prompt injection / 敏感数据泄露）、Semantic Governance Policies（自然语言业务规则阻止危险工具组合）、自定义授权引擎（经 Service Extensions 委派三方决策）；Agent Identity Auth Manager 简化 agent 与工具间的 OAuth 2.0 握手；全部交互经 Agent Observability + Cloud Audit Logs 留痕。治理旁路（对权限层关键）：直接注册到 Gemini Enterprise 的 A2A agent 不经 Agent Gateway，其策略与审计不生效；跨 agent、agent↔MCP 连接器直连亦不触发网关策略。
- 关键数据：SPIFFE ID + mTLS + DPoP；默认拒绝 IAM UAP；支持 MCP / A2A / REST / gRPC；Google IAM Agent Identity 文档（搜索显示约 09-24/25 更新）。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview 、https://docs.cloud.google.com/iam/docs/agent-identity-overview
- 影响判断：把 agent 身份做成「密码学可验证 + 默认拒绝 + 全量审计」是企业最严格的姿态，但旁路路径意味着**审计完整性取决于注册路径的纪律**。授权默认拒绝 + 逐请求身份签名是可直接借鉴的强模型；同时必须维护「哪些入口不进策略 / 审计」的显式清单。
- 价值链位置：位于零信任身份层与网关执行层的结合处，价值落点在「策略执行 + 可审计」；议价权来自 GCP 企业安全栈的整合度。

#### AWS AgentCore Identity（含 AgentCore Gateway 凭据托管）

- 本周动态：AWS 侧 AgentCore Identity 的职责被公开定位为「控制谁可调用 agent、以及 agent 可代表用户访问什么」，通过 IAM 或 OAuth 实现，并可与 Amazon Cognito 等身份 provider 配合；配套示例（coding agents on AgentCore，约 09-28）显示用户经 Cognito 登录后**身份随工作负载进入 OpenTelemetry**，CloudWatch 可按人、按 agent 展示用量；AgentCore Gateway 作为托管 MCP tool server 同时承担**入站授权与出站凭据**处理（Netskope 联合治理文章描述，页面被 Cloudflare 拦截未取全文）。多账户博客（约 09-24/25）给出「中心平台账号 + LOB 账号」模式，平台账号 Gateway 提供统一工具发现端点。
- 关键数据：本对象本周未取得可核的具体数字（正文获取失败），记为缺口；具体参数（支持的身份类型清单、token 有效期、审计字段）未取得，不作数值推断。
- 原文链接：https://builder.aws.com/content/3JuZJFm3sOphgJS2oFHu1xq7D3b/amazon-bedrock-agentcore-a-beginners-guide 、https://github.com/aws-samples/sample-amazon-bedrock-agentcore-coding-agents
- 影响判断：AWS 的差异化是「用现成 IAM / OAuth / Cognito 生态承接 agent 身份」，对企业已有 AWS 治理栈最省迁移；但本周公开材料多为教程 / 示例级，缺少正式产品公告支撑强结论。接 AWS 时应复用其 IAM / OAuth 而非自建身份，凭据交由 Gateway 托管。
- 价值链位置：位于云内身份层，价值落点在「复用既有 IAM」的迁移成本；商业条款与具体能力边界待明确（本周无正式公告级材料）。

#### MCP 授权与委派链（OAuth 2.1 / PKCE / EMA / 委派）

- 本周动态：本周权限层最硬的事件是 **MCP Python SDK 授权服务器校验缺失漏洞**，其本质是「委派链上的一跳未校验」。机制：MCP client 登录时先向所连 server 询问其授权服务器地址，受影响版本未始终校验该答案，恶意 server 可把 client secret、authorization code 与 PKCE 验证值诱导发往攻击者控制的 token 端点；PKCE 本是防止授权码被复用的保护，交出其 proof key 即同时失效。影响面按 provider 分层：`OAuthClientProvider`、`ClientCredentialsOAuthProvider`、`PrivateKeyJWTOAuthProvider`、以及已弃用的 1.x `RFC7523OAuthClientProvider`；仅当应用以 SDK 作 **HTTP MCP client**、连接受不完全控制的 server、且持有真实服务凭据时受影响；用 SDK 建的 MCP server、本地 stdio client、自带 token 的 client 不受影响。修复版本 1.30.0 / 2.2.0 改为「先算出期望的授权服务器，再拒绝任何命名不同者」；但机器对机器两 provider 还需显式传 `issuer=`；升级后需清理旧的 OAuth 客户端注册（旧注册不与授权服务器绑定），若可能已连接不可信 server 须轮换 client secret 并撤销 token。协议方向：MCP 2026-07-28 RC 已把 **OAuth 2.1 + OIDC 列为要求**，并引入 Enterprise-Managed Authorization（EMA）扩展，把授权从「每用户交互式同意」扩到「企业集中托管」；业界文章同期讨论 OAuth 2.1 / PKCE / 客户端凭据在多用户与自主 agent 场景下的分流。
- 关键数据：影响 1.9.1–1.29.1 / 2.0.0–2.1.1；修复 1.30.0（Sept 7）/ 2.2.0（Sept 7）；评分 7.5 / 6.5；公告 2026-09-28，截至 09-29 无 CVE；EMA 为 RC 新增。
- 原文链接：https://thehackernews.com/2026/09/official-mcp-python-sdk-flaw-can-let.html 、https://github.com/modelcontextprotocol/python-sdk/security/advisories/GHSA-qx49-fqc8-xw99 、https://aembit.io/blog/mcp-oauth-2-1-pkce-and-the-future-of-ai-authorization/
- 影响判断：这起事件的普遍教训是——**授权服务器发现（authorization server discovery）是委派链的信任根，缺校验即等于把所有下游令牌的获取权交给对手**；且「补一个 `issuer=` 参数」这种修复方式说明协议 / 实现层的安全边界仍在快速演进、易漏。任何自建 OAuth 客户端都要把「期望 issuer 白名单 + 拒绝重定向」作为强制校验，并把「升级 SDK」与「轮换凭据 + 清理旧注册」当作一套动作同时执行。
- 价值链位置：位于 MCP 委派链的认证跳，价值落点在「协议要求（OAuth 2.1 / OIDC / EMA）→ SDK 实现正确性 → 企业凭据托管」；议价权正从「能连通」转向「能证明每次委派可验证」。

#### 集成商托管 Auth（Arcade / Composio / Nango / Pipedream Connect）

- 本周动态：**本周无重大公开动态。** 四者的权限层共性（逐用户 OAuth、token 托管与自动刷新、白标授权界面）在本周均无新披露，可核内容集中在 9 月上中旬（窗口外）对比文。Arcade 被定位为「逐用户 auth + MCP gateway + 身份集成」的 actions runtime；Composio 管理 1000+ 应用认证并自动刷新 token；Nango 提供白标逐用户 auth + token 管理；Pipedream Connect 提供托管 auth 集成层。
- 关键数据：Composio 1000+ 应用认证；Pipedream 约 2,800+ API / 约 10,000 工具（窗口外，nango / composio 9 月）。
- 原文链接：https://nango.dev/blog/best-mcp-servers-for-agent-api-integrations/ （窗口外，仅作定位）
- 影响判断：集成商本周静默；其「托管 auth」能力与云厂平台化的逐用户 token 隔离正面重叠，长期看平台商可能吃掉中长尾。若需快速覆盖大量 SaaS，可借集成商托管 auth 起步，但要把「凭据所有权与可迁移性」作为选型硬指标。
- 价值链位置：位于 agent↔SaaS 的授权与令牌托管层，价值落点在连接广度与 token 生命周期管理；位置待明确（本周无新披露）。

#### 动态池与监管责任（Auth0 / WorkOS / Clerk / Descope / Permit.io / Aserto；NIST / FTC）

- 本周动态：**指定的动态池厂商（Auth0、WorkOS、Clerk、Descope、Permit.io、Aserto）本周未见面向 AI Agent / MCP / tool permission 的明确发布**，按规则不写其通用 IAM 新闻。权限层的「规则侧」动态来自监管与责任：NIST 的 AI Agent Standards Initiative（2026-02-17 启动）以「agent security、agent identity and authorization、open-source agent protocols」三支柱推进，AI Agent Security RFI 3 月截止、5 月发布回应分析，但 agent 专项 overlay 原计划 2026 H2 且**NIST 尚未正式承诺**，第三方分析（Cloud Security Alliance，2026-03）认为成型标准最早 2027；FTC 主席 Andrew Ferguson 于 **2026-09-25** 在 Austin 的 Reuters Momentum AI 明确「开发者对 agent 行为负全责」，并驳斥「自主行动者」免责抗辩。第三方调研（AvePoint 委托 Osterman，750 名 IT 负责人）称 88.4% 企业在过去 12 个月遭遇 AI agent 相关安全事件，最常见为数据泄露 50.1% 与恶意 / 不可信输入操纵 49.6%，且 82.7% 管理者对防未授权访问有信心——注意该数据为厂商委托、存在利好其治理产品的动机，仅作方向性参考。
- 关键数据：NIST 三支柱 + 2027 最早成型（CSA，2026-03）；FTC 表态 2026-09-25；AvePoint 88.4% / 50.1% / 49.6% / 82.7%（厂商委托调研，750 人）。
- 原文链接：https://www.yahoo.com/news/politics/articles/three-months-nist-federal-ai-154844664.html （约 2026-09-27）
- 影响判断：责任在向「开发者 / 部署者」收拢，而可依据的技术标准尚未落地，形成「高合规压力 + 低标准供给」的窗口期；「审计可追溯（谁批准了这次行动）」因此成为本期的实际刚需而非合规点缀。应在设计期就保留「每次 agent 行动可追溯到授权人 / 授权策略」的审计链。
- 价值链位置：监管位于权限层的「规则外生约束」位置，传导方向是从合规要求倒逼技术审计能力；价值落点在「可证明的授权与审计」；标准尚未成型，具体合规落点待明确。

### 模块洞察（模块5）

**一句话趋势判断：权限层本周从「给 agent 发个令牌」升级为「把 agent 当作与人类并列、可登记 / 可撤销 / 可追责的第一类身份来治理」——三云在「独立身份 + 短时凭据 + 逐用户委派 + 审计」上收敛，微软以 owner / 生命周期治理动作最具体、Google 以零信任密码学最严格、AWS 以复用既有 IAM 最省迁移；同时 MCP SDK 委派链漏洞与「开发者负全责」的监管表态共同指向同一结论：授权与审计必须逐跳可验证，任何一跳缺失都会把整个委派链变成攻击面。**

## 模块6 Context / Memory / Knowledge 记忆知识层

### 本周模块结论

1. **「Context Database」概念被头部玩家坐实为产品形态：** 字节火山引擎 OpenViking v0.4.22（09-28）把「Memory + Knowledge RAG + Skills」收进一个文件系统式 context database，本周新增 Cluster / Account 两级运行时配置、整包 Skill 索引与 `add_skill` MCP 工具、记忆插件在会话开始注入 Skill 目录。记忆层不再只是「向量检索 API」，而是**同时承载上下文、知识、技能库**的持久层——这正是「Memory 从 API 走向 Context Database」的直接证据。
2. **记忆层的竞争焦点从「能不能记住」转向「失败是否可见、结果是否可验证」：** Mem0 v2.2.1（09-25）修的是「向量库拒收却被当作 ADD 成功」、Turbopuffer / S3 Vectors 打分口径；Cognee v1.6.2（09-29）修的是 embedding 静默截断、按模型 token 上限切块、错误暴露真实原因。两家同期收敛到**同一主题：不许静默丢数据**。
3. **外部知识摄取层从「抓取工具」升级为「知识资产 + 资本叙事」：** Firecrawl 官网 blog 日期 09-22 的《Alexandria 与 $75M B 轮》仍是本模块窗口内最强商业信号（属邻期，本文按窗口规则处理），其窗口内动作集中在**安全边界与成本遥测**（跨域 next URL 泄漏 API key、safeFetch 私有目标拦截、prompt-injection guard 计费）。
4. **OpenClaw 参照意义：** OpenViking 的「会话开始注入 Skill 目录 + 整包索引 + `skills/find` 返回单条最佳命中」是一套可直接对标的**技能库承载范式**；Cognee / Mem0 的「失败可见化」清单可作为记忆 / 索引层自查项。此外 OpenViking v0.4.22 明确把 `peer_role: "person"` 迁移为 `sender`（#5355），是本团队实例升级时必须处理的迁移点。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有窗口内动态（v0.4.22 09-28；sdk/go/v0.0.4 09-29） | GitHub release + 全文 | 是 |
| Mem0 | 有窗口内动态（v2.2.1/ts-v3.3.1 09-25；v2.2.0 等 09-23 晚在窗内） | GitHub release + commits | 是 |
| Cognee | 有窗口内动态（v1.6.1 09-24；v1.6.2 09-29） | GitHub release + 全文 | 是 |
| supermemory | 有窗口内动态（09-25~09-30 多条提交；无新 release） | GitHub commits | 是 |
| Letta | 本周无重大公开动态（窗口内 0 提交，最新 push 09-10） | GitHub commits/pushed_at | 是（限述） |
| Zep / Graphiti（合并追踪） | Graphiti 有动态（MCP SDK 2.x 等）；Zep 主仓窗口内 0 提交 | GitHub commits | 是 |
| Firecrawl | 有窗口内动态（安全修复 + 遥测，密集提交） | GitHub commits + 官方 blog | 是 |
| Crawl4AI | 弱动态（窗口内仅 1 条 README/cloud 提交；v0.9.4 在窗口前） | GitHub commits/releases | 是（限述） |

**观察池**（强观察，非固定对象）：本周未展开，均在正文中按需提及（LightRAG / GraphRAG / LangMem / Onyx 等）；未发现需补入正文的强信号。（热度补漏另提名 agentmemory、okf-agent-memory、ai-memory 等，未直查前不写入正文。）

### 深度笔记

#### OpenViking（volcengine/OpenViking，Context Database for AI Agents，必覆盖）

- 本周动态：窗口内两个正式发布——**v0.4.22（2026-09-28T05:56:50Z）**与 **sdk/go/v0.0.4（2026-09-29T09:09:19Z）**，并伴随 09-29、09-30 两天的高频提交（`feat(search): keywords 搜索类型`、`feat(retrieval): 事件时间衰减排序`、全局召回统一候选精排、`feat(installer) 默认安装 CLI 并从 openviking.ai/install 下载`、`feat(mcp): 补齐 ACL 操作与安全的用户目录查询`）。已读 v0.4.22 release 正文全文，其定位是「自演进 Context Database：统一 Agent Memory、Knowledge RAG 与 Skills」。核心内容：①**运行时配置与 Account 隔离**——新增 Cluster / Account 两级配置 API（`GET/PATCH /api/v1/admin/configuration` 与 `/accounts/{id}/configuration`），无需改 `ov.conf` 或重启，Account 可独立配置 VLM / Query Planner / Embedding / 远端 VectorDB / 飞书凭证；②**Skill 检索与分发**——Skill **整包**参与索引，`skills/find` 与 `search(mode="context")` 每个 Skill 只返回一条最佳命中，MCP 新增 `add_skill`，各 memory 插件在**会话开始注入 Skill 目录**并附带 `openviking-skills`；③检索存储——本地向量 cosine 分数归一化到 `[0,1]`，新增 **openGauss DataVec** 向量后端与 **Jev rerank** provider；④可观测——新增 QueueFS 处理耗时与 asyncio executor 指标、observer API 支持 `?format=json`。破坏性变更中与 OpenClaw 直接相关的是 **#5355：`--peer-role person` / `OPENVIKING_PEER_ROLE=person` 报错，须改用 `sender`**。
- 关键数据：GitHub 39,055★ / 3,063 forks / 708 open issues / pushed `2026-09-30T14:55:21Z`（gh api，2026-10-01 取得，为快照非增速）；v0.4.22 published `2026-09-28T05:56:50Z`；sdk/go/v0.0.4 published `2026-09-29T09:09:19Z`（内容为 ls 目录摘要 / 概览控制参数、ListPage / TreePage 分页 #5434）。
- 原文链接：https://github.com/volcengine/OpenViking/releases/tag/v0.4.22 、https://github.com/volcengine/OpenViking/releases/tag/sdk/go/v0.0.4 （均全文已读）
- 影响判断：本周最重的一条是**把「技能库」正式纳入 context database 的管辖范围**（整包索引 + 会话开始注入 Skill 目录 + `add_skill`）。这意味着记忆层的边界从「记住用户」扩张到「分发 Agent 能力」，Memory API 与 Skill registry 正在合流为一个 **Context/Skill Datastore**。对 OpenClaw：其「技能目录注入 + 每 Skill 单条最佳命中」是可直接对标的技能检索设计；而 `peer_role` 由 `person` 改为 `sender` 是本团队实例升级时的**强制迁移点**。
- 价值链位置：位于模型 / 向量库之上、Agent Harness 之下的 **Context 中间层**。向上依赖 Embedding / VLM / 向量库（本周新增 openGauss DataVec、Jev rerank 即横向扩展后端），向下向 agent runtime 提供记忆、知识、技能三类上下文。议价落点在于**用「统一文件系统 + 技能分发」制造迁移成本**，把记忆与技能同时锁定在同一存储语义内。传导方向：后端可替换性变强（多向量库 / rerank），前端粘性变强（技能整包索引）。

#### Mem0（mem0ai/mem0，The Memory Layer for AI Agents）

- 本周动态：窗口内两个发布批次——**09-23T19:03~19:13Z 一批**（`v2.2.0`、`ts-v3.3.0`、`openclaw-v1.2.1`、`opencode-v0.4.1`、`pi-agent-v0.3.2`、`deepseek-plugin-v0.3.2`；UTC 窗口起于 09-23T16:00Z，故均在窗内）与 **v2.2.1 + ts-v3.3.1（2026-09-25T17:35:20Z / 17:36:35Z）**。已读 v2.2.1 正文，清一色是「**不许静默丢数据 / 错打分**」：①`add()` 不再把被向量库拒收的记录当作成功 ADD 上报，只有真正写入的记录才进 history、实体链接与返回值，全部落空则抛 `VectorStoreError`（#7066）；②恢复 `Memory` / `AsyncMemory` 的 context-manager 协议（#7354）；③Bedrock 的 Anthropic 路径改为取第一个含文本的 Converse content block，修 Claude 推理模型先出 `reasoningContent` 导致的 `KeyError`（#6369）；④Turbopuffer 过滤器改为应用**全部**算子（此前只读 gte / lte，其余被静默丢弃，现不支持算子抛 `ValueError`，#6564）；⑤Turbopuffer `euclidean_squared` 分数改 `1/(1+distance)`（旧公式 `1-distance` 会为负并颠倒排序，#6559）；⑥S3 Vectors 打分改为 metric-aware（#6547）。窗口内还含 **User Profiles v1** SDK 方法与文档（#7340，09-23T18:41Z）与 Hermes Mem0 插件迁移（#7372）。
- 关键数据：GitHub 66,383★ / 7,819 forks / 773 open issues / pushed `2026-09-30T10:03:23Z`；`v2.2.1` published `2026-09-25T17:35:20Z`、`ts-v3.3.1` `2026-09-25T17:36:35Z`、`v2.2.0` `2026-09-23T19:03:48Z`、`openclaw-v1.2.1` `2026-09-23T19:11:05Z`。
- 原文链接：https://github.com/mem0ai/mem0/releases/tag/v2.2.1 （正文全文已读）
- 影响判断：Mem0 本周不谈新能力，只谈**「记忆写入的诚实性」**——这恰好是 RAG / 记忆层最危险的隐性缺陷（调用方以为记住了，实际没入库）。值得注意的是其发布矩阵里存在 **`openclaw-v1.2.1` 集成包**，说明 Mem0 已把 OpenClaw 作为一类分发目标。对 OpenClaw：这是一份现成的「记忆故障模式清单」（拒收即失败、打分随 distance_metric 变化、推理模型的 content block 顺序）。
- 价值链位置：位于 **Agent Framework 与应用之间的记忆中间层**；上游对接向量库（Turbopuffer、S3 Vectors、pgvector 等）与 LLM（Bedrock / Anthropic / OpenAI），下游以 SDK 形式嵌入 agent 框架（含 OpenClaw、OpenCode、pi）。议价落点在于**「多后端适配 + 多框架开箱集成」**：它不绑定自家存储，而是靠接入广度获取位置。

#### Cognee（topoteretes/cognee，open-source AI memory platform）

- 本周动态：窗口内两连发——**v1.6.1「Google Sync & Visualization」（2026-09-24T17:50:38Z）**与 **v1.6.2「Embedding reliability & Slack history」（2026-09-29T22:00:46Z）**，正文均已读。v1.6.1：新增 **Google Drive OAuth 连接器**、**Gmail 与共享盘同步**（含 UI 进度）、Google 连接器打包进 SDK；`/visualize/json` 改为**分块流式**返回以支持大子图；GLiNER 安装移出事件循环并首用时自动装 CPU Torch；**chunk 现在携带文档 external_metadata 并在 hybrid（语义 + 关键词）检索中回传**；provenance 作用域收紧到调用者可读数据集。破坏性变更：**dlt 升为核心依赖**（CSV loader 不再按需导入）。v1.6.2：**Slack 会话历史导入与持续同步**；**按各 embedding 模型的 token 上限切块**（消除静默截断）、token 计数改用各 provider 的 tokenizer 并计入模型自身 special tokens、fastembed 批量按最长文本 padding；**Skills 目录迁移到 `.agents/skills`** 并加 Windows 链接 hook；**从 settings 移除 `env_file`**；embedding 错误暴露真实原因并快速失败。
- 关键数据：GitHub 31,244★ / 3,143 forks / 447 open issues / pushed `2026-09-30T20:43:36Z`；`v1.6.1` published `2026-09-24T17:50:38Z`、`v1.6.2` `2026-09-29T22:00:46Z`；v1.6.2 依赖变更含 `dlt>=1.9.0,<2`、`ladybug==0.19.0`。
- 原文链接：https://github.com/topoteretes/cognee/releases/tag/v1.6.1 、https://github.com/topoteretes/cognee/releases/tag/v1.6.2 （均全文已读）
- 影响判断：Cognee 两周连续做**「外部知识摄取 + 摄取正确性」**：Google / Slack 连接器扩的是「知识从哪来」，token 上限切块与 metric-aware 检索修的是「知识有没有被悄悄截断」。**Skills 目录迁到 `.agents/skills`** 与 OpenViking、OpenClaw 的 skill 目录趋同，说明「`.agents/skills` 作为跨工具技能存放约定」正在形成事实标准。
- 价值链位置：处在**多源知识摄取（SaaS 连接器）→ 图 / 向量记忆 → 检索**的纵向链条；上游是 Google / Slack 等外部数据源与 embedding 模型，下游是 agent 应用。价值与议价落点在于**连接器覆盖面 + 摄取保真度**；传导方向上，它把「知识库建设成本」从用户侧转嫁到平台侧。

#### supermemory（supermemoryai/supermemory，Memory & context engine）

- 本周动态：窗口内**无新 release**（最新为 `server-v0.0.8`，published 2026-08-17T18:39:22Z，窗口外；其正文为修复「从 0.0.7 rc 升级会静默清空 pgvector 检索向量」的紧急补丁）。窗口内 11 条提交集中在**供应链安全与 MCP 可观测**：`fix(docs): remove vulnerable ZIP extractor and patch tar via Mintlify (#1727)`、连续多条 `patch high severity transitive dependencies`（chatapp / mcp / raycast / python-sdk，09-29T22:26~22:28Z）、`Instrument MCP server with metadata-only PostHog analytics (#1712)` 与 `feat(mcp): group PostHog MCP tool calls by conversation id (#1718)`、`fix(memory-graph): distinguish document links from derives relations (#1701, 09-25)`、`docs: explain advanced PDF extraction availability`。周内无面向公众的产品发布公告。
- 关键数据：GitHub 31,040★ / 2,725 forks / 118 open issues / pushed `2026-09-30T22:00:27Z`（快照）；最新 release `server-v0.0.8` published `2026-08-17T18:39:22Z`（窗口外）。本次未取得：窗口内官方 blog / changelog 的产品级公告（官网未逐页核对），故本条以仓库级证据为主。
- 原文链接：https://github.com/supermemoryai/supermemory/commits （窗口内提交已直查）
- 影响判断：supermemory 本周是**维护周**——把精力放在依赖漏洞修补与 MCP 侧仅元数据埋点（`metadata-only PostHog`，不采内容），而非能力扩张。「memory-graph 区分 document link 与 derives 关系」这一条值得注意：**记忆图谱的关系语义正在被要求可区分、可解释**，否则下游推理会把「引用」误当「派生」。
- 价值链位置：自托管优先的记忆 / 上下文引擎（lite 版 10,000 文档上限），上游对接 embedding（内置 ONNX native runtime）与向量存储，下游以 MCP 暴露给 agent。议价落点在于**「本地可跑 + 二进制内嵌推理」的低依赖部署**。
- 解决方案五要素：能力 / 形态＝记忆与上下文引擎，含本地 console 与记忆图谱；定价＝自托管 lite 许可上限 10,000 文档（据 0.0.8 release 正文），云端未在本次取证范围内；其余（SLA / 交付 / 支持）未披露。

#### Letta（letta-ai/letta，stateful agents platform）

- 本周动态：**本周无重大公开动态**。`gh api` 查询窗口内 commits 返回空数组；仓库最新 `pushed_at = 2026-09-10T17:59:08Z`（窗口前）；最新 release 为 `0.16.8`（2026-05-14，窗口外）。仅记录状态，不编造动态。
- 关键数据：GitHub 24,985★ / 2,637 forks / `open_issues_count = 0` / pushed `2026-09-10T17:59:08Z`。注：`open_issues_count` 返回 0 与项目规模不符，疑为接口口径问题，**不据此判断社区活跃度**。
- 原文链接：https://github.com/letta-ai/letta （commits/pushed_at 已直查）
- 影响判断：Letta（原 MemGPT）连续数周静默，其「有状态 agent + 自编辑记忆」的路线本周无新证据；在 OpenViking / Mem0 / Cognee 密集迭代的对照下，**记忆层头部叙事正从「agent 自省式记忆」转向「可运维的 context datastore」**。
- 价值链位置：定位在 agent 运行时 / 状态层（stateful agent server），向上依赖模型，向下为应用提供长期记忆 API。窗口内无可观察的新增议价动作，位置待明确。

#### Zep / Graphiti（getzep/zep 与 getzep/graphiti，合并追踪）

- 本周动态：**双仓分化**。①`getzep/graphiti`（实时知识图谱）窗口内有实质提交：**`upgrade mcp_server to MCP SDK 2.x (#1921, 2026-09-25T19:06:56Z)`**、**`route MCP tools to the graph of the requested group_id (#1926, 2026-09-25T23:14:51Z)`**（按请求的 group_id 路由到对应图谱，即**多租户 / 多图谱隔离的 MCP 化**）、`Update anyio to 4.14.2+`、把 Copilot 代码评审改为按需触发；窗口内**无新 release**（最新 `v0.30.2` published 2026-09-08，窗口外）。②`getzep/zep` 主仓窗口内 commits 为空，最新 release `zep-ingest-v0.3.0`（2026-08-28，窗口外）。
- 关键数据：`getzep/graphiti` 31,327★ / 3,214 forks / 443 open issues / pushed `2026-09-30T08:02:29Z`；`getzep/zep` 4,940★ / 653 forks / 39 open issues / pushed `2026-09-30T21:55:26Z`。
- 原文链接：https://github.com/getzep/graphiti/commits （窗口内提交已直查）
- 影响判断：Graphiti 本周关键动作是**把知识图谱接到 MCP 2.x 并按 `group_id` 隔离路由**——即让「agent 通过 MCP 访问知识图谱」成为标准接入面，并在协议层做租户隔离。这与 OpenViking 的 `add_skill` MCP 化、supermemory 的 MCP 埋点同向：**MCP 正在成为记忆 / 知识层的统一接入协议，而隔离（group_id / ACL / 账号）成为其头等工程问题**。
- 价值链位置：位于**知识图谱记忆层**，上游依赖时序图数据库与 LLM 抽取，下游经 MCP / SDK 供 agent 检索；Zep 主仓（企业记忆服务）本周无新证据。议价落点在于**「实时图谱 + MCP 接入 + 多租户隔离」**的组合，位置清晰但本周增量有限。

#### Firecrawl（firecrawl/firecrawl，web data API for AI agents）

- 本周动态：窗口内**无新 release**（最新 `v2.11.0` published 2026-06-19T15:09:30Z，窗口外），动态集中在密集提交，两条主线。①**安全 / 信任边界**：`fix(python-sdk): stop sending the API key to cross-host next URLs (#4861, 09-30)`，并把分页 next URL **pin 到 api_url origin**（Elixir / Java / Rust / Go / JS **五语言 SDK 同步**，#4866~4870）；`fix(api): reject private targets before proxy dispatch in safeFetch (#4864)`（SSRF 防护前置到代理派发前）；`fix(playwright): report the URL the browser actually landed on (#4862)`；`feat(api): link keyless prompts to opaque per-identity /k links (#4856)`。②**成本与遥测**：`feat(telemetry): record cached and reasoning tokens on AI SDK generate spans (#4816)`；`tag branding / prompt-injection-guard / crawl-prompt LLM spans with job ids (#4814)`；`fix(cost-tracking): record branding LLM calls and price all models in use (#4818)`；`fix(api): don't bill the prompt injection guard when it fails open (#4747, 09-23T17:21Z，窗内)`；`disable LLM telemetry for zero data retention scrapes (#4822)`。另有 `feat(alexandria): enrichment settings (#4845)`。官方 blog 窗口内有一篇 **09-24《The Best Free Web Search APIs for AI Agents in 2026》**（推 Firecrawl keyless：零配置、1,000 免费 credits / 月）。
- 关键数据：GitHub 187,133★ / 9,994 forks / 504 open issues / pushed `2026-09-30T22:01:28Z`；最新 release `v2.11.0` published `2026-06-19T15:09:30Z`（窗口外）。Alexandria + $75M B 轮为 09-22（**窗口外**，按邻期处理）。
- 原文链接：https://github.com/firecrawl/firecrawl/commits 、https://www.firecrawl.dev/blog/best-free-web-search-apis （09-24 博文正文已读）
- 影响判断：Firecrawl 本周把力气花在**凭据泄漏与 SSRF 边界**（五语言同步 pin next-URL origin，＝ API key 不再随跨域分页外泄）和**把 prompt-injection guard / branding / crawl-prompt 的 LLM 调用纳入用量与成本遥测**（含 cached、reasoning token）。抓取层正被要求同时充当**安全执行面**与**成本可计量面**；「prompt injection guard 失败时不计费」体现其对可计费口径的审慎。keyless + 每身份 opaque 链接则把匿名流量做成可归因对象。
- 价值链位置：上游是互联网与站点，下游是 agent 的 web 数据面。议价落点在于**「抓取 + 检索 + 结构化抽取」一体化 API 的计费面**，以及 Alexandria 知识库的资产化（本周为其 enrichment 配置加功能）。

#### Crawl4AI（unclecode/crawl4ai，open-source web crawler for LLMs）

- 本周动态：**弱动态（限述）**。窗口内仅 1 条提交：`README: two ways to use Crawl4AI, the library and the cloud, with the launch banner`（2026-09-25T06:35:50Z）——把 README 改为「**库 and 云（Crawl4AI Cloud with one key）**」两条使用路径并挂发布横幅。**v0.9.4 的 published 时间为 2026-09-23T12:14:55Z，早于窗口起点 16:00Z，属窗口外**；其 release 正文仅含 pip / docker 安装说明，细节指向 CHANGELOG。
- 关键数据：GitHub 84,577★ / 8,749 forks / 217 open issues / pushed `2026-09-25T06:37:14Z`；`v0.9.4` published `2026-09-23T12:14:55Z`（**窗口外**）。
- 原文链接：https://github.com/unclecode/crawl4ai/commits/main 、https://github.com/unclecode/crawl4ai/releases/tag/v0.9.4 （正文已读，窗口外仅作背景）
- 影响判断：Crawl4AI 窗口内的信号是**商业形态**而非技术能力——README 主推托管云，与 Firecrawl 的 keyless / 云 API 同向，说明**开源抓取库正把托管云作为主变现路径**。技术上窗口内无新增证据，**不以窗口外的 v0.9.4 表述本周动态**。
- 价值链位置：开源抓取 / 清洗层，上游网站、下游 LLM / agent；新增 Cloud 路径表明其议价落点从「库」向「托管服务」迁移。定价 / 交付细节未披露。

### 模块洞察（模块6）

**一句话趋势判断：记忆 / 知识层本周的竞争主线是「把 context 做成可运维的持久层」——OpenViking 用运行时配置 + 账号隔离 + 技能整包索引把 Context Database 产品化，Mem0 / Cognee 用「失败可见化 + 按模型 token 上限切块」消除静默丢数据，Firecrawl / Crawl4AI 把 web 摄取层推成安全可计量的云 API；而 MCP 正成为记忆 / 知识 / 技能的统一接入协议（OpenViking `add_skill`、Graphiti MCP SDK 2.x + group_id 路由、supermemory MCP 埋点），叠加 `.agents/skills` 目录约定在 OpenViking / Cognee / OpenClaw 间趋同，预示「记忆 + 技能」正在合流为 Agent 的基础上下文资产。**

## 模块7 Observability / Eval / Guardrails 可观测治理层

### 本周模块结论

1. **LLM / Agent 可观测平台开始接管「技能与治理」，超出单纯 trace 面板：** Langfuse 在 v4.46.0（09-25）新增 **skills 基础管理**、v4.48.0（09-30）支持技能草稿变更与按 hash 取文件内容；AWS 在同一周上线 **Agent Toolkit 批量技能更新 / 版本检查**（09-30）与 Marketplace 计量 agent skill（09-30）。观测 / 平台层正在把 **Agent 的 skill 资产**纳入治理面。
2. **成本与 token 口径成为本周共同战场：** Langfuse 连续修 `price Anthropic 1-hour cache writes at the 1-hour rate`、`price OpenAI cache-write tokens`、`stop inferring usage for failed/cancelled generations`；Phoenix 修 `bash tool spans as errors on non-zero exit`；Firecrawl（模块6）记录 cached / reasoning token。**缓存写与推理 token 的计费口径**已被一致认为必须显式区分，否则面板不可比。
3. **平台级 guardrails / 评测出现明确新动作：** Google Gemini Enterprise Agent Platform 09-29 新增 **semantic governance 策略的自定义拒绝消息**（`agentResponseCustomization.denialMessage`，多策略拒绝时合并去重），09-24 CodeMender v0.10.0 增加 SARIF 导出与 **severity-based CI gating**；AWS 09-29 上线 **Bedrock Managed Agents（由 OpenAI 驱动、预览）**，内建「在 AWS 身份 / 权限 / 治理控制下运行」。治理正从「事后看 trace」转向「策略级 allow / deny + 用户可见拒绝理由」。
4. **OpenClaw 参照意义：** LangSmith 的「agent addressing（可寻址 run / agent 句柄）」与 OTel 导出补全，是 agent trace 可回放 / 可追责的基础原语；Langfuse 移除 trace playback 则提示**回放尚未稳定**，不宜过度承诺。可将「缓存写 / 推理 token 分列计费」与「失败 / 取消的生成不计 usage」直接纳入本团队成本口径。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 有窗口内动态（py-sdk 0.14.1 09-25、0.14.2 09-30） | GitHub release + body | 是 |
| Langfuse | 有窗口内动态（v4.44.0~v4.48.0，≥6 个发布） | GitHub release + body | 是 |
| Helicone | 本周无重大公开动态（窗口内 0 提交，最新 push 09-16） | GitHub commits/pushed_at | 是（限述） |
| AgentOps | 本周无重大公开动态（窗口内 0 提交，最新 push 06-25） | GitHub commits/pushed_at | 是（限述） |
| Braintrust | 有窗口内动态（py-sdk v0.43.0 09-28 + 多集成提交） | GitHub commits/releases | 是 |
| Arize Phoenix | 有窗口内动态（phoenix-otel 0.17.2 09-28；phoenix-mcp 4.3.14 09-29；密集提交） | GitHub release/commits | 是 |
| Coze Loop | 弱动态（窗口内 1 条提交 09-28；无新 release） | GitHub commits | 是（限述） |
| OTel for Agents / tracing 标准 | 有窗口内动态（genai 仓 `gen_ai.skill.*` 属性提交 09-29） | GitHub commits | 是 |
| AWS（agent observability/eval/guardrails） | 有窗口内动态（Agent Toolkit 技能批量更新 09-30；Bedrock Managed Agents 09-29；S3 Vectors pre-filter 09-30） | What's New RSS | 是 |
| Google（agent observability/eval/guardrails） | 有窗口内动态（09-29 语义治理自定义拒绝消息；09-24 CodeMender v0.10.0） | 官方 release notes | 是 |
| Azure（Foundry observability/eval） | 取证受限（What's New 仍为 August 2026） | 官方页 | 是（记缺口） |

### 深度笔记

#### LangSmith（LangChain，AI agent evals & observability）

- 本周动态：窗口内两个 SDK 发布——**v0.14.1（2026-09-25T17:37:45Z）**与 **v0.14.2（2026-09-30T14:40:45Z）**，正文均已读。v0.14.2：**新增 `ls.address` 句柄用于 agent addressing**（Python #3581 + JS #3604）、补齐 OTel 导出中缺失的 **tool name / call_id / tool definitions**（#3592）、**只有主写副本保留原始 run id**（#3623，跨副本 trace 一致性）、包装型 HTTP 错误时保留响应体（#3611）。v0.14.1：`trace ClaudeSDKClient.receive_messages()`（#3576）、修复 OTel 导出缺失的 **tool_call_id 与 tool_definitions**（#3584）、sandbox 校验 service URL 用户 token 与代理回调（#3593）、`list_runs` / `list_threads` 返回附件（#3590）。
- 关键数据：`langchain-ai/langsmith-sdk` 1,064★ / 241 open issues / pushed `2026-09-30T20:05:34Z`；`v0.14.1` published 2026-09-25T17:37:45Z、`v0.14.2` 2026-09-30T14:40:45Z。本次未取得：LangSmith 平台侧（SaaS）窗口内官方发布说明或定价变更。
- 原文链接：https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.14.2 、https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.14.1 （body 已读）
- 影响判断：LangSmith 本周两条主线——**「可寻址」（`ls.address` 给 agent/run 稳定句柄）与「可复现」（主写副本保原始 run id、OTel tool 元数据补全）**。把 agent 做成可寻址对象，是 Agent 从「一次调用」变成「可长期追踪实体」的前提；而「仅主写副本保留 run id」直指分布式 trace 的 id 漂移问题。
- 价值链位置：位于 Agent 应用与 LLM 之间的 **trace/eval SaaS 层**；上游强绑定 LangChain / LangGraph 生态与各家模型，下游面向工程团队的评估、调试与合规。议价落点在于**生态耦合 + 评估结果口径一致性**。

#### Langfuse（langfuse/langfuse，open-source LLM engineering platform）

- 本周动态：窗口内**至少 6 个正式发布**：**v4.44.0（09-24T09:07:02Z）**、v4.45.0/1/2（09-24）、**v4.46.0（09-25T14:20:07Z）**、**v4.47.0（09-29T08:25:01Z）**、**v4.48.0（09-30T10:12:22Z）**（已读四份 release 正文）。主线：①**AI Gateway**——`relay Anthropic Messages with usage telemetry`、`capture Anthropic Messages content in full mode`、`set trace environment from langfuse-environment header`、`capture full-mode inputs up to 5 MiB and mark omitted inputs`；②**写入性能**——`add the ClickHouse Native write strategy`、`prepare JS events and encode batches through NAPI`、`isolated OTEL replay integration harness`；③**成本 / token 口径**——`price Anthropic 1-hour cache writes at the 1-hour rate`、`price OpenAI cache-write tokens`、`stop inferring usage for failed and cancelled AI gateway generations`、新增 Claude Sonnet 5.5 / GPT-6.1 Sol / GPT-6 Astra Ultrafast 定价；④**新产品面**——v4.46.0 **`feat(skills): basic skill management`**，v4.48.0 **`skills: track draft changes and fetch file contents by hash`**；⑤**移除功能**——v4.46.0 **`fix(web): remove the trace playback feature`**；⑥evaluation——`label experiment query outcomes for SLOs`、`link decision-model evaluators to their scores by evaluator ID`、conversation-signals 模板。
- 关键数据：GitHub 35,241★ / 3,892 forks / 984 open issues / pushed `2026-09-30T21:38:24Z`；release 时间戳见上。
- 原文链接：https://github.com/langfuse/langfuse/releases/tag/v4.48.0 、https://github.com/langfuse/langfuse/releases/tag/v4.47.0 、https://github.com/langfuse/langfuse/releases/tag/v4.46.0 （正文均全文已读）
- 影响判断：Langfuse 本周的重点是**「网关 + 存储 + 计费」三件基础设施事**，而非面板花样——AI Gateway 收编 Anthropic 缓存 / 推理计费口径、ClickHouse Native 写入提升吞吐。最值得注意的是 **skills 管理进入可观测平台**（草稿变更追踪、按 hash 取文件），以及**主动移除 trace playback**：说明「轨迹回放」尚无稳定产品形态，观测层的下一战场是**技能与治理对象**。
- 价值链位置：开源 LLM / Agent 可观测平台（自托管 + 云），上游对接模型与 AI Gateway，下游服务工程团队；议价落点在于**开源许可 + OTel 兼容 + 计费精度**。

#### Helicone（Helicone/helicone，LLM observability gateway）

- 本周动态：**本周无重大公开动态**。`gh api` 窗口内 commits 返回 **0 条**；仓库最新 `pushed_at = 2026-09-16T19:29:27Z`（窗口前），即本周无代码推进。上周（09-16）曾有「平台管理员接管与 HQL 跨租户绕过」修复（邻期信号，非本周）。
- 关键数据：GitHub 6,190★ / 678 forks / 163 open issues / pushed `2026-09-16T19:29:27Z`。本次未取得：窗口内官方 blog / changelog 产品公告。
- 原文链接：https://github.com/Helicone/helicone （commits/pushed_at 已直查）
- 影响判断：作为 LLM 网关型观测工具，Helicone 本周静默；在 Langfuse 密集发版的对照下，其**产品节奏明显偏慢**，可能转向以安全修复为主的维护态。**不据静默判断其退场**。
- 价值链位置：位于应用与模型之间的**代理 / 网关层**（据此采集 trace 与计费），上游模型商、下游工程团队；本周无新议价动作，位置待明确。

#### AgentOps（AgentOps-AI/agentops，agent observability SDK）

- 本周动态：**本周无重大公开动态**。`gh api` 窗口内 commits 返回 **0 条**；最新 `pushed_at = 2026-06-25T08:25:03Z`；最新 release `0.4.21` published 2025-08-29。仓库自 6 月起基本无公开推进。
- 关键数据：GitHub 5,857★ / 637 forks / 191 open issues / pushed `2026-06-25T08:25:03Z`；最新 release `0.4.21`（2025-08-29）。
- 原文链接：https://github.com/AgentOps-AI/agentops （commits/pushed_at/releases 已直查）
- 影响判断：AgentOps 已连续多月无公开动态，其「agent session 回放与分析」的位置正被 LangSmith / Langfuse / Phoenix 与云厂平台同时挤压。**本次仅记录静默事实**，不推断其是否停止运营。
- 价值链位置：agent 专用可观测 SDK 层，上游 agent 框架、下游工程团队；窗口内无可观察动作，位置待明确。

#### Braintrust（braintrustdata，AI evals & observability）

- 本周动态：窗口内有 SDK 发布 **`py-sdk-v0.43.0`（2026-09-28T21:38:24Z）**，正文已读：`fix(anthropic): capture usage and refusal metadata (#800)`（采集**用量与拒答元数据**）、`feat: add span customizers (#788)`、`fix: Lazy load integration modules (#795)`、`fix(otel): send lazily resolved API key with opentelemetry-exporter-otlp-proto-http 1.45 (#811)`、`fix(claude-agent-sdk): preserve partial-mode usage (#810)`。窗口内其余提交是**框架集成广度**：`span customizer enhancements (#824)`、`agentscope` TeamPipeline 回复流追踪、`pipecat` observer frame ID 限界、`agno` 取消阶段元数据、`dspy` LM history token 指标、`claude-agent-sdk` verbatim prompt 模式、`livekit` STT 用量指标、`openai` 归一化 iterable tools 元数据、`anthropic` 内联 MCP tool blocks。本次未取得：平台侧（SaaS）窗口内官方发布说明或定价。
- 关键数据：`braintrustdata/braintrust-sdk-python` **仅 20★** / 80 open issues / pushed `2026-09-30T07:56:07Z`。注：其分发不依赖 GitHub 星标，**不据星标判断市场地位**；`py-sdk-v0.43.0` published 2026-09-28T21:38:24Z。
- 原文链接：https://github.com/braintrustdata/braintrust-sdk-python/releases/tag/py-sdk-v0.43.0 （正文已读）
- 影响判断：Braintrust 本周体现两条策略：**用「框架集成广度」抢 agent 观测入口**（同时覆盖 Claude Agent SDK、DSPy、Agno、Pipecat、LiveKit、AgentScope，含语音 STT 用量），以及**把「拒答 / 部分模式用量」纳入评估维度**——拒答（refusal）与部分完成的 usage 从此可被评估与计费核对，这对合规审查与成本对账是刚需。
- 价值链位置：AI eval/observability SaaS，上游各家模型与 agent 框架，下游工程团队；议价落点在于**评估工作流 + 多框架集成面**，GitHub 非其主要分发渠道。

#### Arize Phoenix（Arize-ai/phoenix，open-source AI observability & evaluation）

- 本周动态：窗口内发布 **`arize-phoenix-otel v0.17.2`（2026-09-28T20:58:45Z）**（正文已读：修复 `register()` 在 `opentelemetry-exporter-otlp-proto-http 1.45` 下的崩溃）与 **`@arizeai/phoenix-mcp@4.3.14` + `phoenix-client@7.15.0` + `phoenix-cli@1.18.6`（2026-09-29T19:17Z）**。密集提交中两条与 agent 治理直接相关：**`feat(agents): mark bash tool spans as errors on non-zero exit codes (#16597, 09-28)`**（把 bash 工具非零退出标为 span error）与 **`feat(harbor): bake Claude Code and Codex into the task image behind root-only permissions (#16571, 09-30)`**（评测沙箱镜像内置 Claude Code / Codex，仅 root 权限可用）。其余为 `project annotation config helpers`、experiment token detail charts、GraphQL 查询新增 `sequence_number/sort_dir`、`Trace hybrid search with Qdrant` 文档、prompt-version tag helpers。
- 关键数据：GitHub 11,666★ / 1,174 forks / 1,049 open issues / pushed `2026-09-30T21:55:59Z`；`arize-phoenix-otel-v0.17.2` published 2026-09-28T20:58:45Z、`phoenix-mcp@4.3.14` 2026-09-29T19:17:12Z。
- 原文链接：https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-otel-v0.17.2 、https://github.com/Arize-ai/phoenix/commits （提交已直查）
- 影响判断：Phoenix 本周三件事——**OTel 导出器版本兼容修复**（与 Langfuse、Braintrust 同期撞到 `otlp-proto-http 1.45`，说明 OTel SDK 版本漂移是全行业共同的集成风险）、**MCP/CLI 持续迭代**（观测平台 MCP 化）、**评测 harness 内嵌真实编码 agent**（Harbor 装 Claude Code/Codex）。「bash 非零退出记 error」是把**工具调用失败**纳入 trace 错误语义，直接服务于 agent 可追责。
- 价值链位置：开源 AI 观测与评估平台，上游 OTel/模型/agent 框架，下游工程团队；议价落点在于**开源可自托管 + MCP 接入 + 评估库**。

#### Coze Loop（coze-dev/coze-loop，字节 Coze 的 Agent 全生命周期平台）

- 本周动态：**弱动态（限述）**。窗口内仅 **1 条提交**：`[fix][evaluation] clean up runs rejected before dispatch (#677)`（2026-09-28T11:38:21Z）——清理**派发前被拒绝的评测 run** 的残留。窗口内**无新 release**。上周（09-17~09-23）曾有 trace 存储 / 检索的密集工程化（单 CK 查询、logid 检索、root_step 修复），本周节奏明显放缓。
- 关键数据：GitHub 5,754★ / 798 forks / 87 open issues / pushed `2026-09-30T03:55:32Z`。本次未取得：窗口内 Coze Loop 官方中文产品公告。
- 原文链接：https://github.com/coze-dev/coze-loop/commits （窗口内提交已直查）
- 影响判断：「清理派发前被拒绝的评测 run」仍是**评测生命周期一致性**问题（run 在进入执行前被拒后不得留下悬挂状态），与上周 root_step 缺失同属「评测 / 轨迹状态机边界」。本周无新增能力信号，**仅记录维持性修复**。
- 价值链位置：字节 Coze 生态的 Agent 开发-评测-监控一体化平台，上游 Coze / 火山引擎，下游企业开发者；窗口内无新议价动作，位置待明确。

#### OpenTelemetry for Agents / tracing 标准

- 本周动态：`open-telemetry/semantic-conventions-genai`（GenAI 语义约定独立仓，2026-05-05 创建）窗口内有实质提交：**`Add gen_ai.skill.* attributes to the execute tool span (#498, 2026-09-29T18:12:41Z)`**——把 **`gen_ai.skill.*` 属性加入工具执行 span**，即把「技能」作为语义约定的一等遥测维度；另有依赖维护（`Update dependency mistralai to v3`、锁文件维护、python-security 组升级）。窗口内**无 release**（releases API 返回空）。
- 关键数据：该仓 400★ / 195 open issues / pushed `2026-09-30T18:21:25Z`；`#498` 提交时间 2026-09-29T18:12:41Z。主线仓 `open-telemetry/semantic-conventions` 上一版仍为 v1.44.0（窗口外，未在本窗口核对新 release）。
- 原文链接：https://github.com/open-telemetry/semantic-conventions-genai/commits （窗口内提交已直查）
- 影响判断：`gen_ai.skill.*` 是本周**最容易被忽略但跨厂商影响最大**的标准动作——当 skill 成为 span 属性，观测平台（Langfuse 的 skills 管理、Phoenix 的工具 span 语义）、agent 平台（AWS Agent Toolkit skills）与 context database（OpenViking 技能库）就能在同一语义下对齐「技能级」遥测。**「skill」正从产品概念升级为遥测标准维度**。
- 价值链位置：位于**跨厂商遥测标准层**，上游由各 agent / LLM 运行时产出 span，下游被所有观测平台消费；议价落点是**互操作性的公共品**，不直接变现但决定各家面板可比性。

#### AWS（agent observability / evaluation / governance / skills）

- 本周动态：窗口内多条与 agent 基础设施相关的 What's New（pubDate 均已核）：①**AWS CLI 支持 Agent Toolkit 技能的批量更新与版本检查**（`aws agent-toolkit check-skill-updates`、`update-skill --all`，`2026-09-30T20:16:00Z`）——把 agent skills 作为可版本治理的资产，覆盖 Kiro / Claude Code / Codex / Cursor；②**Amazon Bedrock Managed Agents（BMA，由 OpenAI 驱动）预览**（`2026-09-29T21:10:00Z`）——基于定制版 OpenAI Agents API，AWS-native，复用既有身份 / 权限 / 治理控制；③**AWS Marketplace 计量 agent skill 正式可用**（`2026-09-30T05:00:00Z`）——AI 引导卖家完成 usage-based 计费集成并在生产前跑端到端测试；④**End User Messaging 与 SES 提供 AWS MCP Server 的 AI agent skills**（`2026-09-25T07:00:00Z`）；⑤**Amazon S3 Vectors 新增元数据预过滤**（`2026-09-30T20:00:00Z`，选择性过滤下召回提升至多 5x，新增 `$startsWith`）；⑥CloudWatch Logs 自动索引高频查询字段（`2026-09-29T08:00:00Z`）。
- 关键数据：各条 pubDate 取自 AWS What's New RSS；S3 Vectors 预过滤宣称「元数据选择性过滤下返回至多 5x 更多匹配向量」（**厂商口径，未独立核实**）。
- 原文链接：https://aws.amazon.com/about-aws/whats-new/2026/09/aws-cli-agent-toolkit-update-skill/ 、https://aws.amazon.com/about-aws/whats-new/2026/09/s3-vectors-introduces-metadata-pre-filtering/ （RSS 条目已读）
- 影响判断：AWS 本周把 **「agent skill」确立为平台级可治理资产**（批量更新、版本检查、计量技能），并上线 **Bedrock Managed Agents**（OpenAI 驱动但跑在 AWS 治理边界内）。这与上周 CloudWatch Omni GA 连成一条线：**AWS 正把 harness + skills + observability + governance 整体平台化**，把开源可观测 / 框架能力收编进云控制台。
- 价值链位置：云平台层，向下吞并 agent runtime、技能分发、可观测与治理；上游模型（含 OpenAI）、下游企业开发者。议价落点在于**身份 / 权限 / 计费 / 合规的一体化绑定**。

#### Google（Gemini Enterprise Agent Platform，governance / eval）

- 本周动态：官方 release notes 窗口内条目（已读）：**09-29 语义治理策略的自定义拒绝消息**——可在 policy 上配置固定 Denial message（≤1,000 字符，`agentResponseCustomization.denialMessage`），多策略同时拒绝时引擎合并去重、无配置者回退通用消息；**09-28** Provisioned Throughput 支持变更订单范围 / 延长期限，Gemini 3 模型经 Interactions API 预览支持；**09-25** 一条 Feature（**正文未取得**，不作描述）；**09-24** **Gemini 3.8 Live GA**（语音质量、模型可靠性、**agent 编排**改进）与 **CodeMender v0.10.0**（impact-aware PR delta scanning `--diff/--staged`、**SARIF v2.1.0 导出与按严重度 CI gating `--fail-on`**、自适应混合深度扫描、`CM_HOME` 自定义工作区、多项修复）。09-21 CodeMender v0.9.0（交互式 HTML 安全报告、扩展 C#/Rust/Kotlin/Ruby/PHP 扫描、按轮延迟指标）；09-18 xAI Grok 4.6 GA；09-22 Meta Muse Spark 1.3 进预览（agentic 工作流推理模型、内置 MCP 工具调用、1M token 长上下文）。
- 关键数据：条目日期与功能名取自官方 release notes 页；**09-25 条目正文提取为空，记局限**；拒绝消息 ≤1000 字符。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- 影响判断：Google 本周模块7相关动作聚焦**「治理可见化 + 安全门禁」**：semantic governance 的**自定义拒绝消息**让策略拒绝对终端用户可解释（与 AWS AgentCore Consent Portal 同属「治理对用户可见」），CodeMender 的 **SARIF + 按严重度 CI gating** 把 agentic 安全修复接进 CI/CD 门禁——**guardrails 正从运行时拦截扩展到流水线门禁**。
- 价值链位置：云平台层（Gemini Enterprise Agent Platform 已取代旧 Vertex 生成式页面作为更新入口），上游模型，下游企业开发者；议价落点在于**治理策略与安全工具链的绑定**。

#### Azure（Microsoft Foundry，observability / evaluation）

- 本周动态：**取证受限，记缺口而非静默**。官方 What's New 页当前取得的是 **「What's new for August 2026」**（front matter `ms.date: 2026-09-01`、`updated_at: 2026-09-09`），**未见 September 2026 条目**；相关分类为 "Observability and evaluation"（如 "Evaluate conversations with the Microsoft Foundry SDK"），属 8 月批次。
- 关键数据：页面标题月份 = August 2026，`ms.date` 2026-09-01、`updated_at` 2026-09-09。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry （已读）
- 影响判断：**不能据此判断 Microsoft 本周在 agent 可观测 / 评测层无动态**——本次仅证明官方 What's New 页尚未发布 9 月批次。这是**取证缺口**，需下游按限述处理。
- 价值链位置：云平台层（Foundry），本周无新增可观察动作，位置待明确。

### 模块洞察（模块7）

**一句话趋势判断：可观测治理层本周出现「skill 成为治理与遥测一等对象」的跨厂商共振——OTel 新增 `gen_ai.skill.*` span 属性、Langfuse 上线 skills 管理、AWS 把 agent skills 做成可批量版本治理的资产、OpenViking 把技能整包纳入 context database；与此同时成本口径（缓存写 / 推理 token）与治理可见性（自定义拒绝理由、工具失败记 error、CI severity 门禁）成为共同硬指标，而 OTel 导出器 `otlp-proto-http 1.45` 兼容问题被 Langfuse、Braintrust、Phoenix 同期撞上，暴露出标准版本漂移已是全行业集成风险。**

## 模块8 Managed Agent Platform / Enterprise Control Plane 平台层

### 本周模块结论

- **AWS 在「运行效率」上给出本周最硬的数字**：新一代 AgentCore Runtime 已可用，弹性内存回收（按实际用量而非峰值计费）+ 快照式冷启动，P75 冷启动 **1.9–2.0 秒**（镜像 200MB–2GB），对比 V1 的 5.4–30 秒；覆盖 us-east-1 / us-east-2 / us-west-2 / eu-west-1 / ap-northeast-1；创建 / 更新 runtime 时设 `platformVersion: V2`（GA 公告 9/18，窗口前）。另有 9 月新增交互式 shell、生命周期钩子、Consent Portal、TS 评估。
- **平台层拼的是「七个面」而非模型**：Runtime/Session、Memory/Context、Gateway/Tools、Identity/Auth、Sandbox/Browser/Code、Observability/Eval——AWS 本周在 Harness / Identity / Evaluations 三条同时补齐（交互式 shell、Consent Portal、TS 评估），Google 补治理策略（拒绝消息定制、语义治理），Microsoft 维持 Hosted Agents GA 后的平台面。
- **国内三家的窗口内公开动态偏少**：阿里云百炼窗口内未见产品级发布（仅记忆库文档 9/28 更新、应用功能动态 9/17）；火山方舟 Agent Plan 描述文档 ~9/28 更新（全模态 + 专属 Harness + 积分计费，文档更新不等于产品发布）；腾讯云 ADP 本周未取得窗口内条目。三家仍以「低代码平台 + 知识库 + 渠道分发」为主，托管 harness 与沙箱治理弱于 AWS / OpenAI。但国内本周更强的是**开源底座**（火山 OpenViking 上下文数据库）与**模型货架**（阿里 9/24 决策模型）。
- **OpenClaw 参照意义**：矩阵中「Identity/Auth」「Observability/Eval」是 OpenClaw 相对薄弱面（无托管身份编排、无内置评估器体系），而「Runtime/Session（cron/sessions/恢复）」与「Gateway/Tools（渠道 + 工具策略）」是强项。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | Runtime V2 GA（9/18，窗口前）；9 月新增交互式 shell / 生命周期钩子 / Consent Portal / TS 评估 | whats-new 2026/09、AgentCore release notes | 是 |
| Google Vertex AI / Gemini Enterprise Agent Platform | 9/28 拒绝消息定制、Interactions API 支持 Gemini 3（预览）；9/24 Gemini 3.8 Live GA；9/22 Muse Spark 1.3 预览 | docs.cloud.google.com release-notes | 是 |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | 窗口内未取得官方条目；背景：Hosted Agents / Voice Live / Toolboxes GA（7/9 起） | devblogs.microsoft.com/foundry | 限述 |
| 阿里云百炼 / Model Studio / PAI | 窗口内未取得产品级发布；9/24 上架 decision-model-preview；记忆库文档 9/28 更新、长期记忆下线（9/10） | help.aliyun.com 应用功能动态 / 记忆库概览 | 限述 |
| 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking | Agent Plan 文档 ~9/28 更新；窗口内未取得发布级公告；开源侧 OpenViking v0.4.22（9/28）、sdk/go/v0.0.4（9/29） | volcengine.com/docs/ark、docs.coze.cn、GitHub | 限述 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 本周未取得窗口内条目（检索命中页为 2025-08 / 2026-06 内容） | cloud.tencent.com/document/product/1759 | 否 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | **推翻「本周未取得」初判**：9/29 Agent Bricks CLI Beta；同日 GPT-6.1 Sol 上 Unity Gateway、Databricks Apps 水平扩展 GA | docs.databricks.com release-notes/product/2026/september | 是 |

### 深度笔记

#### AWS Bedrock AgentCore

- 本周动态：官方 9 月发布说明（**按月归档，未标具体日**，故无法确认全部落在 9/24–30 窗口内，按限述处理）列出三条 Harness 能力与两条治理能力。**Harness 交互式 shell**：支持通过 WebSocket 的持久交互式 shell，与 harness agent 跑在同一隔离 microVM 会话内，保留环境变量、工作目录、命令历史与运行中进程；可重连已脱离的 shell 并回放最多 **256 KB** 缓冲输出，单个 harness 会话最多开 **10 个**独立 shell，托管默认环境与自定义容器内均可用；起手需直连 `InvokeAgentRuntimeCommandShell` WebSocket API（CLI 与高层 SDK shell helper 暂不支持 harness target）。**Harness 自定义 OpenAI 兼容端点**：OpenAI 模型配置新增可选 `apiBase`，把直接 OpenAI 请求路由到自建网关 / 代理 / 自托管或区域端点。**Harness 生命周期钩子**：支持 `before_invocation`、`before_tool_call`、`after_tool_call`、`after_invocation` 四个边界；Lambda target 返回同步 `allow` / `deny` 可中止调用或跳过工具调用，SNS / EventBridge target 收非阻塞通知；`InvokeHarness` 为每个触发的钩子发 `hookEvent`。**AgentCore Identity Consent Portal**：托管门户，把终端用户导向 `portalUrl` 审批 agent 代其访问资源；需配一个以 JWT 入站认证为来源的 AgentCore Gateway，且身份提供方许可 scope 含 `openid`；用 create / get / list / update / delete consent-portal 操作管理。**Evaluations 支持 TypeScript 框架**：Strands Agents、LangGraph、OpenAI Agents、Vercel AI SDK。此外，**窗口前**（9/18）新一代 AgentCore Runtime 已 GA：弹性内存回收 + 快照式冷启动，P75 冷启动 1.9–2.0s（镜像 200MB–2GB）对比 V1 的 5.4–30s，`platformVersion: V2`。**更正**：AgentCore Evaluations 的 `Builtin.SkillSelectionAccuracy` / `Builtin.SkillInstructionFollowing` 两个 skill 级评估器官方列在 **8 月**（背景，非本周）。
- 关键数据：P75 冷启动 1.9–2.0s vs V1 5.4–30s；4 个 runtime 区域 + ap-northeast-1；shell 回放 256 KB、每会话 ≤10 shell；拒绝消息 ≤1000 字符（Google 侧）。
- 原文链接：https://aws.amazon.com/about-aws/whats-new/2026/09/new-agentcore-runtime-generally-available/ 、https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- 影响判断：AWS 把 Harness 从「跑 agent 的容器」推进到「可交互、可挂钩、可审批」的控制面——shell 让 agent 拥有真实终端，生命周期钩子给了**同步 allow / deny 的策略闸门**（对标本地工具策略 / 审批），Consent Portal 把 OAuth 同意托给云。这三点直接压缩了自建 agent runtime 的性价比空间。
- 价值链位置：平台与工具链（Runtime/Harness + Identity + Eval）。价值向上集中到「runtime 效率 + 治理钩子 + 身份」；沙箱供给与模型被降为可替换件，议价落在运行时与策略控制面。

#### Google Vertex AI / Gemini Enterprise Agent Platform

- 本周动态：**9/29** 语义治理策略支持**自定义拒绝消息**（`agentResponseCustomization.denialMessage`，最长 1000 字符；同一请求触发多条策略时合并去重，未配置者回退通用消息）——把「策略拒答」从开发者日志变成面向终端用户的产品行为。**9/28** Provisioned Throughput 支持在自助控制台改订单范围或续期（supersede and replace）；**Interactions API 预览支持 Gemini 3 模型**。**9/24** **Gemini 3.8 Live GA**（语音质量、模型可靠性、agent 编排改进）；Meta **Muse Spark 1.3** 进预览（面向 agentic 工作流的推理模型，内置 MCP 工具调用、1M token 长上下文）；CodeMender v0.10.0（`--diff` / `--staged` 增量扫描、SARIF 导出与 CI 门禁、`CM_HOME` 自定义工作目录）。**9/21** CodeMender v0.9.0（交互式 HTML 安全报告、扩展 C#/Rust/Kotlin/Ruby/PHP 扫描、按轮延迟指标）。**9/18** xAI Grok 4.6 GA。
- 关键数据：拒绝消息 ≤1000 字符；Muse Spark 1.3 = 1M token 上下文 + MCP。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- 影响判断：Google 本周把 agent 平台的重心放在**治理与模型货架**——语义治理拒绝消息是「可对用户解释的策略执行」，Gemini 3 / Live / 第三方模型（Muse Spark、Grok）同台，走的是「模型无关 + 治理内建」的开放货架路线。限制：release notes 对 9/22、9/25 两条只列 Feature 未给正文（抓取截断），本次不据此展开。
- 价值链位置：平台与工具链（治理 / 模型货架）。价值落在「策略与合规执行面 + 模型分发」；runtime 与沙箱细节本周未更新，议价集中在治理层与模型供给。

#### Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK

- 本周动态：**本周无重大公开动态**。Microsoft Foundry 官方 「What's new」 月刊页面最新一期仍为 **2026 年 8 月**（页面 `ms.date` 2026-09-01、`updated_at` 2026-09-09），窗口内未取得 9 月条目。可读的窗口前（背景，非本周）体系显示 Foundry Agent Service 已把「长时执行」做成一整套：新文档含 **long-running agent API（预览）**、**long-running agent resilience（预览）**、**crash-resilient 长时 agent 部署**、**崩溃后恢复长时工作**、**长时 agent 状态管理**、**stream with reconnect**、**steer in-flight turn**、**human-in-the-loop 审批步骤**、**private skill catalog**、**hosted agents 的 BYO registry**、**toolbox 网络隔离**、**autopilot 生命周期与成本 / token 用量**；模型侧新增 Grok、MAI-Thinking-1，并有 Model Router 评测指引与 Azure OpenAI Responses API 的多 agent 编排文档。
- 关键数据：本期页面窗口内条目 —（未取得）；来源页面已读，含 New/Updated articles 全列表。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry
- 影响判断：Microsoft 的 agent 平台面在 7—8 月已完成「长时 agent 韧性 + 状态 + HITL 审批 + 技能目录 + 工具箱隔离」的成体系铺垫，本周处于发布间歇，格局判断不变。其与 AWS 本周的 lifecycle hooks / Consent Portal 形成同构竞争：**把长时执行与人工审批做成平台原语**。局限：官方月刊按整月归档，无法排除 9 月条目尚未上线；故按「本周无重大公开动态」限述，不用 8 月内容充当本周动态。
- 价值链位置：平台与工具链（托管 runtime + HITL + 技能目录）。议价落在 Azure / Entra / M365 的身份与办公分发，而非编排框架本身。

#### 阿里云百炼 / Model Studio / PAI

- 本周动态：窗口内**未见平台级（Agent 运行时 / 网关 / 身份）功能发布**。可核实的窗口内只有模型货架动作：**2026-09-24 上架 `decision-model-preview`**（面向高频业务判断的结构化决策模型，可依文本或业务状态并行完成分类、是非判断与评分，并返回**概率分布与置信度**，官方列出的场景含工单分流、内容审核、**智能体路由**与结果校验）。平台功能更新页最新条目为 **8 月 4 日**（模型升级通知），应用功能动态页最新可见条目为 **2026 年 2 月**。背景（非本周）：**智能体托管运行时 API**（平台托管会话与工具执行）于 **6 月 29 日**上线；记忆库商业化 7 月 21 日；长期记忆 2.0 API 于 1 月 31 日上线。
- 关键数据：decision-model-preview 上架日 2026-09-24（华北2·北京）。
- 原文链接：https://help.aliyun.com/zh/model-studio/newly-released-models 、https://help.aliyun.com/zh/model-studio/model-release-notes
- 影响判断：百炼窗口内是「模型货架更新」而非平台能力更新——决策模型直指**智能体路由 / 结果校验**这一控制面环节，但以模型形式提供，而非平台原语。其托管 agent runtime 早在 6 月已上线，本周无增量，说明阿里把节奏放在模型与降价而非 harness 治理。局限：帮助中心页面为动态渲染，应用功能动态页最新可见为 2 月，不排除渲染不全；已按「未取得窗口内平台发布」记录。
- 价值链位置：平台与工具链（模型货架 + 托管 agent 渐进补齐）。议价落在模型供给与价格，runtime / 治理面弱于 AWS / OpenAI。

#### 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking

- 本周动态：窗口内**未见发布级产品公告**；方舟文档 `agent-plan-personal-plan-overview`、`agent-plan-personal-openviking` 等页约 9/23—9/29 有更新，但**文档更新不等于产品发布**，不作为本周动态。窗口内真正可核实的增量在**开源侧**：`volcengine/OpenViking`（自述 「Self-evolving Context Database for AI Agents. Unify Agent Memory, Knowledge RAG and Skills.」）**v0.4.22 于 2026-09-28、`sdk/go/v0.0.4` 于 2026-09-29 发布**，9/30 仍有提交（含 `feat(mcp): 补齐 ACL 操作与安全的用户目录查询`、`feat: add Jev choice-based reranking`）；stars 39,055。
- 关键数据：OpenViking v0.4.22 published 2026-09-28T05:56Z、sdk/go/v0.0.4 2026-09-29T09:09Z；39,055 stars（2026-10-01 快照）。
- 原文链接：https://github.com/volcengine/OpenViking 、https://www.volcengine.com/docs/ark/agent-plan-personal-openviking （releases/commits API 已读；方舟文档页提取失败，记为局限）
- 影响判断：字节把 **agent 上下文 / 记忆**做成开源数据库（记忆 + 知识 RAG + 技能统一进虚拟档案系统），再接进方舟 Agent Plan 的 Coding / Agent 套餐，形成「开源抢开发者 + 云托管变现」的组合。与 AWS 把 memory 做成托管服务不同，字节选择开源底座。局限：Coze / Coze Studio / Coze Loop 窗口内未取得发布级条目，其托管 harness 与沙箱治理本周无新增证据。
- 价值链位置：平台与工具链 + 上下文 / 记忆层（开源）。价值锚在「上下文数据库」这一独占数据层，议价来自记忆 / 技能的沉淀而非运行时性能。

#### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit

- 本周动态：**本周无重大公开动态**。腾讯云智能体开发平台（ADP）官方「产品动态」页（cloud.tencent.com/document/product/1759/104191，检索标注更新于 2026-09-18，即窗口前）**最新可见条目仍为 2025-08**，内容为「变量与记忆」模块（含 `SYS.Memory` 长期记忆）、Multi-Agent 工作流编排与 Plan-and-Execute 协同、应用评测升级（裁判模型 / 规则 / 代码三种评分）、模型广场、企业管理 / 工作空间权限分层、微信小程序发布渠道等。窗口内（9/24—9/30）未取得发布级条目；检索无窗口内公告命中。
- 关键数据：—（窗口内未取得）。
- 原文链接：https://cloud.tencent.com/document/product/1759/104191
- 影响判断：ADP 的能力面（长期记忆、多 agent 编排、评测、渠道发布）在 2025-08 已铺开，但公开更新节奏明显慢于 AWS / Google；渠道分发（微信生态）是其相对 AWS 的差异化。局限：该页本次抓取 rawLength 偏小（2,744），不能完全排除渲染未取全，故按「窗口内未取得条目」限述，不据此断言腾讯本周完全无动作。
- 价值链位置：平台与工具链（低代码 + 渠道分发）。议价落在微信 / 企微渠道与企业权限分层，托管 harness 与沙箱治理本周无证据。

#### Databricks Mosaic AI Agent Framework / Agent Bricks

- 本周动态：窗口内确有发布，**推翻此前「本周未取得」的初判**。Databricks 官方 September 2026 release notes 列明：**9 月 29 日 Agent Bricks CLI 进入 Beta**——`databricks-agentbricks` 命令行工具用于在 Databricks 上构建并部署自定义代码 agent：从内置框架模板脚手架建项目、本地运行、再部署到 Databricks agent runtime，**托管 memory、sessions、tools，并预接 MLflow tracing，全部在一条已认证命令内完成**。同日另有：**OpenAI GPT-6.1 Sol 上线 Unity Gateway**（经 Foundation Model APIs 访问）、**Databricks Apps 水平扩展 GA**（单 URL 多实例、零停机部署、尽力会话亲和）。9 月 30 日：Lakeflow Jobs 表更新触发器支持 OpenSharing 对象与 system tables GA、Query tags GA。9 月 28 日：Workday Activity Logging connector（Beta）。
- 关键数据：Agent Bricks CLI Beta 日期 2026-09-29；GPT-6.1 Sol 上 Unity Gateway 2026-09-29。
- 原文链接：https://docs.databricks.com/aws/en/release-notes/product/2026/september 、https://docs.databricks.com/aws/en/agents/custom-agents/agent-bricks-cli
- 影响判断：Databricks 把 Agent Bricks 从「低代码构建」扩到**代码优先 CLI**，并把 managed memory / sessions / tools / tracing 打包成一条命令——这是平台层竞争落到「能否一条命令交付可观测的长时 agent」的直接证据。其差异点仍是**数据与治理（Unity Gateway / MLflow / 权限）**，而不是运行时性能。sessions + tools + tracing 由平台自动接好，正是自托管方案需要自己搭的部分。
- 价值链位置：平台与工具链（数据 / 治理侧 + agent runtime 入口）。价值锚在 Unity Catalog / MLflow 等既有数据资产，agent runtime 作为其上层的分发面。

### 模块洞察（模块8）

托管 agent 平台的本周分水岭在**「一条命令的交付完整度」**：AWS 给 Harness 补交互 shell、生命周期钩子（同步 allow / deny）与 Consent Portal；Databricks 用 `databricks-agentbricks` 把脚手架→本地跑→部署→托管 memory / sessions / tools→MLflow tracing 串成一条认证命令；Microsoft 的长时 agent 韧性 / 状态 / HITL 已在 7—8 月成体系、本周间歇；Google 加码**策略治理的用户可见性**（自定义拒绝消息）与模型货架。相比之下国内三家本周更强的是**开源底座**（火山 OpenViking 的上下文数据库 v0.4.22 / sdk 0.0.4）与**模型货架**（阿里 9/24 决策模型直供智能体路由），平台治理面更新较少。对 OpenClaw 的对照结论不变：Runtime/Session 与 Gateway/Tools 是强项，Identity/Auth 与 Observability/Eval 是矩阵中的薄弱面。

## 云厂能力矩阵

说明：仅按本次已取证内容填写；无证据的单元格写「本次未取证」，不编造。单元格内「（背景）」表示来源为窗口前资料，仅作能力位置参照，不算本周动态。

| 平台 | Runtime/Session | Memory/Context | Gateway/Tools | Identity/Auth | Sandbox/Browser/Code | Observability/Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS Bedrock AgentCore | microVM 隔离会话 + 持久交互 shell（回放 256KB、每会话≤10 shell）；Runtime V2 快照冷启动（背景+9月条目） | 本次已读条目未取证（本次未取证） | AgentCore Gateway（JWT 入站）；生命周期钩子 before/after_tool_call 可 allow/deny；自定义 OpenAI 兼容 `apiBase` | AgentCore Identity + Consent Portal（终端用户审批 `portalUrl`，需 `openid` scope） | 托管默认环境与自定义容器；交互式 shell 执行（浏览器未取证） | AgentCore Evaluations 支持 TS 框架（Strands/LangGraph/OpenAI Agents/Vercel AI SDK） | 9 月条目：交互 shell、生命周期钩子、Consent Portal、TS 评估（按月归档，未标日期） |
| Google Vertex AI / Gemini Enterprise Agent Platform | Interactions API 预览支持 Gemini 3（9/28）；runtime 细节本次未取证 | Muse Spark 1.3 内置 1M token 上下文（9/24，预览） | Muse Spark 1.3 内置 MCP 工具调用（9/24） | 本次未取证 | CodeMender v0.10.0（`--diff/--staged` 扫描、SARIF、CI 门禁） | 本次未取证 | 9/29 语义治理支持自定义拒绝消息（≤1000 字符，多条策略合并去重） |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | long-running agent API、resilience、状态管理、stream with reconnect、steer turn（背景 8 月刊） | 长时 agent 任务状态管理（背景） | Toolboxes（含网络隔离）、Tool search、MCP connector、OpenAPI/web search/code interpreter（背景） | Entra/CMK 等（背景，本次未单独取证） | Code Interpreter、hosted agent 本地运行（背景） | Agent optimizer（成本/token）、azd CLI 评测、Agent Monitoring Dashboard、合成评测集（背景） | 本期窗口内无条目；官方月刊最新为 2026 年 8 月 |
| 阿里云百炼 / Model Studio / PAI | 智能体托管运行时 API（背景 6/29，平台托管会话与工具执行） | 记忆库商业化（背景 7/21）、长期记忆 2.0 API（背景 1/31） | 知识库/MCP 统一为工具（Agent 2.0，背景） | API Key 加密存储、业务空间专属域名、分账（背景） | 本次未取证 | 新版应用评测（背景，2026-02 页） | 9/24 上架 `decision-model-preview`（返回概率分布/置信度，列明智能体路由场景） |
| 火山·字节 Ark / Coze / Coze Studio / Coze Loop / OpenViking | 方舟 Agent Plan（全模态 + 专属 Harness + 积分计费，文档 ~9/28 更新，非发布公告） | OpenViking 上下文数据库（记忆+RAG+技能，窗口内发版） | OpenViking 补 MCP ACL 操作与安全用户目录查询（9/30 提交） | 本次未取证 | 本次未取证 | Coze Loop 本次未取得窗口内条目 | OpenViking v0.4.22（9/28）、sdk/go/v0.0.4（9/29） |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | Multi-Agent 模式与工作流编排（背景 2025-08；托管 runtime 未取证） | 「变量与记忆」含 `SYS.Memory` 长期记忆（背景 2025-08） | 工作流工具节点、模型广场第三方模型接入（背景） | 企业管理 + 工作空间权限分层（背景） | 本次未取证 | 应用评测升级：裁判模型/规则/代码三种评分（背景） | 本周无重大公开动态（产品动态页最新可见条目为 2025-08） |
| Databricks Mosaic AI Agent Framework / Agent Bricks | Databricks agent runtime，**托管 sessions**（9/29 CLI 一条命令接入） | **托管 memory**（9/29） | **托管 tools**（9/29）；Unity Gateway 供模型 | 本次未取证（Unity Gateway 模型访问已取证，身份面未取证） | 自定义代码 agent 脚手架/本地运行；Databricks Apps 水平扩展 GA（9/29） | **MLflow tracing 预接**（9/29） | 9/29 Agent Bricks CLI Beta + GPT-6.1 Sol 上 Unity Gateway |

缺口与原因：① AWS 条目按整月归档且未标具体日，无法逐条确认落在 9/24—9/30；② Microsoft / 阿里 / 腾讯 三家的官方页为动态渲染或有分页，本次以已读页面范围为准；③ Google 的 runtime 与观测面本周无窗口内条目；④ 阿里 PAI、腾讯 CloudBase AI Toolkit、火山 Coze Studio / Loop 本次未取得窗口内独立条目，故未单列判断。

## TOP 5 候选与依据

按「对 Agent Harness 基础设施格局的信号价值」排序。

**1. OpenAI Agents API 加 computer use + always-on agent 产品 Dots（9/29，DevDay 2026）**

- 依据：同周把「托管 harness」从运行 agent 推到操作软件（Agents API computer use）与常驻执行体（Dots 自带云电脑 + 自带浏览器 + 4,000+ 应用集成 + 未来 specialist dots 带独立身份）；同时给出 GPT-6.1 Sol 与 GPT-6 Sol / Luna 降价 50% 的定价面。
- 信号价值：模型厂一次性占住模型、harness、沙箱编排与身份四层，把 E2B / Modal / Browserbase 等第三方沙箱 / 浏览器厂商降为供给方，是本周最强的「执行体商品化」信号。
- 来源：https://openai.com/index/devday-2026-recap/ 、https://openai.com/index/introducing-dots/ 、https://developers.openai.com/api/docs/changelog 、https://www.reuters.com/business/openai-takes-meta-with-always-on-dots-agent-enterprise-ai-push-2026-09-29/ （局限：Recap 页动态渲染，隔离技术 / 配额 / 计费未披露）

**2. MCP 官方 Python SDK OAuth 凭据窃取漏洞（GHSA-qx49-fqc8-xw99，9/28 公告）**

- 依据：影响 1.x 的 1.9.1–1.29.1 与 2.x 的 2.0.0–2.1.1，修复于 1.30.0 / 2.2.0（9/7），评分 7.5 / 6.5；根因是「授权服务器发现」这一跳未校验，恶意 MCP server 可获取 client secret、authorization code 与 PKCE 验证值。叠加同期的 MCP 2026-07-28 无状态化（`Mcp-Method` 路由、OAuth 2.1 + OIDC 要求、EMA 扩展）。
- 信号价值：工具连接层在快速收敛的同时，把信任链的集中风险暴露在 SDK 实现层；「实现可信度」直接变成治理采购的准入门槛，且修复需连做「升级 + 轮换凭据 + 清理旧注册」。
- 来源：https://github.com/modelcontextprotocol/python-sdk/security/advisories/GHSA-qx49-fqc8-xw99 、https://thehackernews.com/2026/09/official-mcp-python-sdk-flaw-can-let.html 、https://aaif.io/blog/mcp-2026-07-28-whats-changing-and-how-to-migrate

**3. AWS AgentCore Harness 交互式 shell + lifecycle hooks + Consent Portal（9 月条目；新版 Runtime GA 9/18）**

- 依据：把「同步 allow / deny 的策略闸门」与「终端用户同意门户」做成托管 runtime 原语（`before_tool_call` / `after_tool_call` 等四边界挂 Lambda 或 SNS/EventBridge），并给出 P75 冷启动 1.9–2.0s vs V1 5.4–30s 的硬数字。
- 信号价值：云厂把「可长期运行且可被治理」标准化，直接压缩自建 agent runtime 的性价比空间；对自托管工具策略 / 审批模型是最直接的对标对象。
- 来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html 、https://aws.amazon.com/about-aws/whats-new/2026/09/new-agentcore-runtime-generally-available/ （局限：9 月条目未标具体日，按「本月」限述）

**4. Microsoft Entra Agent ID / Agent 365 把 agent 做成第一类身份（9/23—9/29 密集文档）**

- 依据：Foundry 为每个 Hosted agent 自动创建专属 Entra 身份与端点；M365 Agent Registry 提供 install / activate / block / delete / restore（30 天）/ 指派 owner 等治理动作；Entra 新增 / 强化 Agent ID Administrator 角色与生命周期策略。
- 信号价值：权限层从「给人设计」转向「给非人类主体设计」，并把「无主 agent」提升为与「无主服务账号」同级风险；与 Google（SPIFFE + mTLS + DPoP）和 AWS（IAM / Cognito）共同形成三云身份收敛。
- 来源：https://learn.microsoft.com/en-us/microsoft-365/admin/manage/agent-actions 、https://learn.microsoft.com/en-us/azure/foundry/agents/overview 、https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview

**5. 火山引擎 OpenViking v0.4.22：Context Database 把「记忆 + 知识 RAG + 技能」收进同一存储语义（9/28）**

- 依据：Skill 整包参与索引、`skills/find` 每条只回一条最佳命中、MCP 新增 `add_skill`、会话开始注入 Skill 目录；新增 Cluster/Account 两级运行时配置、openGauss DataVec 与 Jev rerank 后端；并伴随 `.agents/skills` 目录约定在多个项目间趋同。
- 信号价值：记忆层边界从「记住用户」扩到「分发 agent 能力」，Memory API 与 Skill registry 合流；叠加 OTel `gen_ai.skill.*`、Langfuse skills 管理、AWS Agent Toolkit 技能治理，形成「skill 升为一等控制面」的跨模块共振。
- 来源：https://github.com/volcengine/OpenViking/releases/tag/v0.4.22 、https://github.com/topoteretes/cognee/releases/tag/v1.6.2 、https://github.com/open-telemetry/semantic-conventions-genai/commits

**备选与说明**：LangChain 的 Managed Deep Agents v0.8（用户级 / agent 级记忆分层 + HTTP 通道 + Red Teaming 闭环）、Databricks Agent Bricks CLI Beta（一条命令串齐托管 memory / sessions / tools 与 MLflow tracing）、Google Agent Gateway（身份 + 目录 + 默认拒绝 + 可观测闭环）、Postman Fabric Gateway GA（协议无关 agentic 控制面）均具强信号价值，但论「对 Harness 基础设施格局」的阻断性弱于上五条；本周另无「重大无源 / 虚假内容」或「核心矛盾」触发，TOP 5 足额，无需少数列处理。

## 本周对 OpenClaw 的参照意义

1. **外部 harness 已成为可切换的一等 runtime，会话 / 状态一致性是新的选型比较点。** OpenClaw v2026.9.7 把 OpenAI Agents API 接成可选 runtime（持久托管 Linux workspace、60 秒提交截止、token usage 上报、临时错误重试），与自托管 harness 形成可切换设计；而 Agents API 自托管执行需自有 controller 与匹配 workspace 路径、且**不支持文件传输**。多 runtime 混跑时的会话与状态归属需作为明确设计约束。依据：https://docs.openclaw.ai/releases/2026.9.7

2. **「断得了、接得回」已是平台基线，OpenClaw 已有对应能力、需守住。** OpenClaw v2026.9.7 的更新前备份 + 回滚、重启后续接、remote workspace Memory / Skills，与 AWS lifecycle hooks / Consent Portal、Foundry long-running agent 韧性套件、Databricks 一条命令托管 memory/sessions/tools 同框；差异点集中在自托管与数据主权。依据：https://docs.openclaw.ai/releases/2026.9.7 、https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry

3. **MCP client 安全必须立即核到 1.30.0 / 2.2.0，且连做「升级 + 轮换凭据 + 清理旧 OAuth 注册」。** 若自建 MCP client 连接受不完全控制的 server，需补 `issuer=` 校验（`ClientCredentialsOAuthProvider` / `PrivateKeyJWTOAuthProvider` 需显式传），并将「期望 issuer 白名单 + 拒绝重定向」作为强制校验。依据：https://github.com/modelcontextprotocol/python-sdk/security/advisories/GHSA-qx49-fqc8-xw99

4. **工具策略与审批已有可直接对标的外部形态。** AgentCore `before_tool_call` / `after_tool_call` 的同步 allow / deny、Consent Portal 的终端用户审批、Google 语义治理的默认拒绝 IAM UAP 与自定义拒绝消息（≤1000 字符），与 OpenClaw 的工具策略 / 审批模型属同一语义层；显式登记「哪些入口不当策略 / 审计」是必要动作（Google 的 A2A 直连旁路是反面例证）。依据：https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview

5. **记忆与索引层建议按「失败可见化」自查。** Mem0 v2.2.1（拒收即抛 `VectorStoreError`、打分随 distance_metric 变化、推理模型 content block 顺序）与 Cognee v1.6.2（按模型 token 上限切块、错误暴露真实原因）提供了一份现成清单；且 Mem0 发布矩阵中存在 `openclaw-v1.2.1` 集成包，说明外部记忆层已把 OpenClaw 作为分发目标。依据：https://github.com/mem0ai/mem0/releases/tag/v2.2.1 、https://github.com/topoteretes/cognee/releases/tag/v1.6.2

6. **技能库承载范式可直接对标，且存在一个强制迁移点。** OpenViking 的「会话开始注入 Skill 目录 + 整包索引 + 每 Skill 单条最佳命中」可与 OpenClaw 的 skills 抽象对照；同时 OpenViking v0.4.22 已把 `peer_role: "person"` 迁移为 `sender`（#5355），属依赖方升级时必须处理的破坏性变更；`.agents/skills` 目录约定正在趋同。依据：https://github.com/volcengine/OpenViking/releases/tag/v0.4.22

7. **成本口径需与平台对齐：缓存写 / 推理 token 分列计费、失败 / 取消的生成不计 usage。** Langfuse v4.44–4.48 连续修 Anthropic 1 小时缓存写、OpenAI cache-write token 定价与失败 / 取消生成的 usage 推断；Braintrust 把拒答与部分模式用量纳入采集；Firecrawl 记录 cached / reasoning token。依据：https://github.com/langfuse/langfuse/releases/tag/v4.48.0 、https://github.com/braintrustdata/braintrust-sdk-python/releases/tag/py-sdk-v0.43.0

8. **computer use 的 toolset 版本化需要探测与降级路径。** Anthropic Sonnet 5.5（9/28）在 Claude API 与 Google Cloud 上停用 `computer_20251124`、需改 `computer_toolset_20260801`（Opus 5.5 于 9/22 已要求，Bedrock 上旧版仍可用），与 OpenAI 把 computer use 收进 Agents API，同属「模型侧接口版本会周期性打破自托管 agent 兼容」的风险。依据：https://platform.claude.com/docs/en/release-notes/overview

9. **矩阵中的短板与环境安全默认值需正视。** 平台矩阵显示 Identity/Auth 与 Observability/Eval 是相对薄弱面（无托管身份编排、无内置评估器体系，而 AWS 已有 Agent Toolkit 技能治理、OTel 已有 `gen_ai.skill.*`）；另外 OpenClaw v2026.9.7 原文明确提示：多 agent 共用 Gateway 时省略的可见性设置会让带 session 工具的 agent 读取其他 agent（含其他用户）的对话，需显式收窄；互不信任用户应分 Gateway。依据：https://docs.openclaw.ai/releases/2026.9.7 、https://github.com/open-telemetry/semantic-conventions-genai/commits

## 覆盖审计与局限

### 覆盖度

- **模块覆盖：8/8**。模块1（Harness / Agent OS 控制层）、模块2（Runtime / Session / State）、模块3（Sandbox / Computer Use / Browser）、模块4（Tool Gateway / Protocol / Integration）、模块5（Identity / Auth / Permission）、模块6（Context / Memory / Knowledge）、模块7（Observability / Eval / Guardrails）、模块8（Managed Agent Platform / Enterprise Control Plane）均含模块结论、固定对象状态表、深度笔记与模块洞察。
- **平台覆盖：7/7**。AWS Bedrock AgentCore、Google Gemini Enterprise Agent Platform、Microsoft Foundry、阿里云百炼 / Model Studio、火山引擎 Ark / Coze、腾讯云智能体平台、Databricks 均进入矩阵与模块 8 笔记。
- **热度补漏：9 个方向全部执行完成**（agent memory / context database / knowledge graph / RAG memory skills / MCP gateway / auth permission OAuth MCP / browser agent runtime / observability eval / agent harness runtime）。入口实况：内置 `web_search`（brave）首批并行调用触发 429 限流；改用固定适配器单发完成 9 方向；tavily 处于 provider cooldown，本阶段未用其 raw_content。搜索结果多数 `date=null`，均作线索，未直接支撑正文主张。

### 固定对象实际扫描结果

- **模块6：8/8 逐一扫描**。有窗口内动态并深写 5（OpenViking、Mem0、Cognee、supermemory、Firecrawl）；弱动态限述 1（Crawl4AI）；无动态限述记录 2（Letta、Zep 主仓）+ Graphiti 有动态。
- **模块7：9/9 项逐一扫描**（含 AWS / Google / Azure 三个子对象，共 11 子对象）。有窗口内动态并深写 7（LangSmith、Langfuse、Braintrust、Arize Phoenix、OTel for Agents、AWS、Google）；弱动态限述 1（Coze Loop）；无动态限述 2（Helicone、AgentOps）；取证受限记缺口 1（Azure）。
- **模块4：12 项；模块5：8 项（含状态记录项）**：模块4 深写 6（MCP、A2A、AWS AgentCore Gateway、Google Agent Gateway、Microsoft Toolbox、Postman）+ 集成商 4（状态记录）+ 社区开源 3；模块5 深写 3 云厂身份 + MCP 授权链 + 监管，集成商 4（状态记录）。
- **模块1：本周深写 7**（OpenClaw、OpenAI Agents API、Anthropic、LangChain、trueforge、ZCode、hermes-agent）+ 背景限述 3（Google ADK、Microsoft Agent Framework、Databricks Agent Framework）；**模块8：深写 7**（AWS、Google、Microsoft、阿里云、火山·字节、腾讯云、Databricks）；**模块2：深写 5 + 补遗 1**；**模块3：深写 2 + 交叉 1**。
- **去重后固定对象总数：14**（模块1 固定 7 + 热点补漏 3；模块8 固定 7；去重后口径）；另模块2/3/4/5/6/7 各自另有固定对象集（见各状态表）。

### 缺口与原因（汇总，不遗漏）

- **AWS AgentCore 9 月 release notes 未标逐条日期**，仅按月归组；除新版 Runtime GA（9/18，窗口外）外，其余条目能否计入本期窗口存疑，已按「本月」限述。
- **AWS 相关正文获取受限**：多账户博客正文 HTML 不完整（仅导航层）、Netskope 页被 Cloudflare 拦截、cycode / helpnetsecurity / businesswire 被 403 或抽取失败；相关对象仅用标题 / 摘要层可核对信息。
- **Microsoft Foundry 官方月刊最新为 2026 年 8 月**（`ms.date` 2026-09-01、`updated_at` 2026-09-09），窗口内无条目；评估 / optimizer 的「late September GA」为第三方（Medium）转述，未取得微软一手原文。
- **Azure 可观测 / 评测面为取证缺口而非静默**：官方 What's New 仍为 August 2026，不能据此判断 Microsoft 本周无可观测 / 评测层动态。
- **Google release notes 09-25 条目正文提取为空**，本次不作任何描述（另 9/22 条目亦仅列 Feature）。
- **阿里云帮助中心为动态渲染**，应用功能动态页最新可见为 2026-02，不排除渲染未全；**腾讯云 ADP 产品动态页本次 rawLength 偏小（2,744）**，不能完全排除渲染未取全，故按「窗口内未取得条目」限述，不据此断言无动作。
- **火山方舟 `agent-plan-*` 文档页提取失败**（仅搜索线索，未采用为动态）；Coze Studio / Coze Loop 窗口内无发布级条目。
- **OpenAI DevDay Recap 页动态渲染**，正文仅取到摘要段；Dots 云电脑隔离 / 区域 / 配额 / 计费未披露；computer use 的隔离技术、配额与定价未披露（与 429 有关）。
- **MCP 2026-07-28 规范细节经二次文章取得**（RC 描述），未逐条读规范原文；规范发布日 2026-07-28 在窗口外，作背景而非本周动态。
- **厂商自述未独立核实**：AWS S3 Vectors「选择性过滤下至多 5x 召回」为官方自述；Firecrawl 免费额度 / Token 效率为其官方 blog 口径；OpenAI 12 亿周活为官方披露未独立核实；AvePoint 调研（88.4% / 50.1% / 49.6% / 82.7%）为厂商委托调研（750 人），存在利好其治理产品的动机，仅作方向性参考。
- **窗口外项已隔离**：DeepSeek 开源 harness（2026-08-13）、Crawl4AI v0.9.4（09-23T12:14Z < 窗口起点 16:00Z）、Firecrawl Alexandria + $75M B 轮（09-22）、docker/mcp-gateway v0.44.1（09-23）、Azure Playwright Remote MCP（09-17）、A2A v1.0.1（05-28）、AgentCore Runtime GA（09-18）、Opus 5.5 computer use 变更（09-22）、Scale AI 参考架构（09-22）——仅作背景，不计本周动态。
- **本周无重大公开动态的固定对象**：Google ADK / A2A（协议本体）、Microsoft Agent Framework、Databricks Mosaic Agent Framework（本模块口径）、火山方舟 / Coze、E2B / Modal / Daytona、Browserbase / Stagehand、AWS AgentCore Browser / Code Interpreter、Google Code Execution、Letta、Zep 主仓、Helicone、AgentOps、Auth0 / WorkOS / Clerk / Descope / Permit.io / Aserto、CrewAI AMP/Studio、Dify、n8n/Flowise。
- **未取得 ≠ 静默 / 不存在**：上述「未取得」仅表示本次未读得支撑证据，不作「未公开」「无动作」或「零宗」的断言；取证失败已在各模块显式标注。
- **单源已读与归属边界**：大量条目为单源官方页 / 单仓 release；「可核原事实」按实际支持范围单源采用，不影响事件其余合格内容；转载同稿与同一研究未计作独立来源。
- **GitHub stars / forks / open issues 与 release 时间戳均为 2026-10-01 取得时快照**，无跨期基线，**不计算周增速**，不代表市场地位（Braintrust SDK 仅 20★ 即为例证；Letta `open_issues_count = 0` 疑为接口口径问题，未据此推论）。
- **搜索适配器局限**：serper 为主；tavily 处于 cooldown（>1400s）未复用；内置 web_search（brave）一度 429；搜索结果日期字段大量缺失。
- **未展开的观察池**：LightRAG / GraphRAG / LangMem / Onyx 等未展开；热度补漏提名的 agentmemory、okf-agent-memory、ai-memory、vercel-labs/agent-browser、MCP #804 提案等未直查前不得写入正文。

## 来源与证据边界

### 来源清单（按模块，互不重复）

- **官方文档 / 发布页**：docs.openclaw.ai/releases/2026.9.6 与 2026.9.7；developers.openai.com/api/docs/changelog；openai.com/index/introducing-the-agents-api/ 、introducing-gpt-6-sol-and-luna/ 、devday-2026-recap/ 、introducing-dots/；platform.claude.com/docs/en/release-notes/overview；langchain.com/blog/interrupt-2026-overview 与 langsmith-engine-agents-fine-tuning-trajectories；adk.dev；learn.microsoft.com（foundry/whats-new-foundry、agents/overview、agents/how-to/tools/tool-authentication、microsoft-365/admin/manage/agent-actions、agent-framework）；docs.aws.amazon.com/bedrock-agentcore/.../release-notes.html 与 aws.amazon.com/about-aws/whats-new（AgentCore Runtime、Agent Toolkit、S3 Vectors）；docs.cloud.google.com（gemini-enterprise-agent-platform/release-notes、govern/gateways/agent-gateway-overview、iam/docs/agent-identity-overview）；help.aliyun.com（model-studio 应用功能动态 / 模型发布 / 记忆库 / rich-code-application）；cloud.tencent.com/document/product/1759/104191 与 announce/detail/2451；docs.databricks.com/aws/en/release-notes/product/2026/september 与 agents/custom-agents/agent-bricks-cli；docs.coze.cn。
- **GitHub API 直查（release / commit / repo 元数据）**：openclaw/openclaw、anthropics/claude-code、modelcontextprotocol/python-sdk（GHSA-qx49-fqc8-xw99）、modelcontextprotocol/modelcontextprotocol（2026-07-28、discussions/804）、a2aproject/A2A、agentic-community/mcp-gateway-registry、docker/mcp-gateway、truefoundry/trueforge、zai-org/ZCode、NousResearch/hermes-agent、volcengine/OpenViking、coze-dev/coze-studio、coze-dev/coze-loop、mem0ai/mem0、topoteretes/cognee、supermemoryai/supermemory、letta-ai/letta、getzep/graphiti 与 getzep/zep、firecrawl/firecrawl、unclecode/crawl4ai、langchain-ai/langsmith-sdk、langfuse/langfuse、Helicone/helicone、AgentOps-AI/agentops、braintrustdata/braintrust-sdk-python、Arize-ai/phoenix、open-telemetry/semantic-conventions-genai、browserbase/stagehand、aws-samples/sample-amazon-bedrock-agentcore-coding-agents。
- **具名媒体 / 第三方**：thehackernews.com（09-28）、dataphoenix.info（09-30，Scale + Google）、yahoo 新闻（NIST 稿，约 09-27）、builder.aws.com、aembit.io、aaif.io、cycode.com（403/CF）、helpnetsecurity.com（抽取失败）、businesswire.com（403）、nango.dev（窗口外）、composio.dev（窗口外）、Reuters / NYT / TechCrunch / The Guardian / The Verge / CNBC（DevDay 与 Dots）、Medium（Dave Rendon，约 09-30）、AWS What's New RSS、Firecrawl 官方 blog（09-24）。

### 证据分级与限述边界

- 本期内大量条目为**单源官方发布 / 版本记录**（release notes、API changelog、gh api），按可核原事实在其实际支持范围内采用，未另凑媒体背书。
- 厂商自述类（冷启动指标、召回提升、下载量、周活、免额度、ROI 类调研）均已紧邻标注归属与「未独立核实」，**不作为强投资 / 因果 / 全行业结论的唯一支柱**。
- 日期与窗口判定：所有 release / commit 时间戳已按 UTC 边界逐个判定（窗口 = UTC `2026-09-23T16:00Z ~ 2026-09-30T16:00Z`）；越窗者在正文显式标注为背景。
- 产品宣布 / 文档更新 ≠ 实测效果 ≠ 客户采用；试点 ≠ 规模部署；采购 ≠ 收入。演示、预览（preview / beta）与 GA 已在正文区分。
- 未取得独立二源、部分页面打不开、个别动态未取全，均已在对应对象的「局限」与后部「覆盖审计与局限」分别标注，**不据此阻断整刊，也不冒称零宗、未公开或核验成功**。
- 本轮**未触发任何必要阻断**：未出现仍拟发布的重大无源 / 虚假或误导内容，未出现无法透明限述 / 隔离的核心矛盾，无隐私 / 保密 / 发布授权未决，且已有可用可信内容形成真实、明确局限的报告。故研究内容准出为可进入编辑的 PASS，上述局限计入 WARNING。
