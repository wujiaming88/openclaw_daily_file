# 全球 AI Agent 基础设施研究周报 · 第 11 期

- **本期时间窗**：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）
- **研究对象**：Agent Harness 八层能力栈，以及 AWS、Google、Microsoft、阿里云、火山/字节、腾讯云、Databricks 七个平台控制面
- **证据口径**：只有发布时间、迁移截止时间或提交时间可确认落入窗口的官方公告、文档、release、commit 才计为本周动态；窗口外信息只作背景。GitHub stars/forks 为 2026-08-27 快照，不代表周增量。
- **执行说明**：首轮四线并发中 A/C/D 因超大 API 输出触发上下文溢出，按安全协议拆成六个模块恢复任务；全部有效分片保留，最终 4/4 研究线、8/8 模块和 7/7 平台矩阵通过文件门控。

## 执行摘要

本周 Agent 基础设施的主线不是“谁又多了一个 Agent builder”，而是**谁能声明并执行清晰的运行边界**。Microsoft 用不自动迁移的 Hosted Agents backend 退场，强制确定每 session sandbox、durable files、per-agent identity 与多协议 endpoint 的 Runtime ABI；Google 把 Antigravity coding agent 纳入 Gemini Enterprise 的 license、预算、browser/MCP policy 与集中审计；OpenClaw 以 external supervisor、restart handoff、SQLite backup/restore、durable channel ingress 和插件供应链校验，把本地优先 Agent OS 推向可被企业控制面接管的阶段。

第二条主线是**Identity 与 Gateway 从“有 OAuth”升级为组织级授权和运行时策略边界**。Claude Enterprise-managed authorization 以 XAA/ID-JAG 绕过逐用户 consent ceremony，让企业 IdP 成为 app-to-app/agent-to-app 的中央授权点；Clerk、Nango、Microsoft Foundry、Google Agent Gateway 等分别补 custom scope、MCP client identity、tool-level policy、mTLS/DPoP、读写属性与审计链。工具协议本身则通过 MCP 2026-07-28 Tasks extension、MCP Python SDK 2.1.0 的资源限制和错误脱敏，以及 AWS/Foundry managed MCP gateway，进入“长任务、凭据与治理正确性”阶段。

第三条主线是**Memory 从对话 API 升级为团队与企业事件的 Context control plane**。AWS AgentCore Memory 允许最大 100 KB JSON 业务事件直接进入四类长期记忆策略；OpenViking v0.4.16 把 user-scoped memory policy、remote Skills、durable async ingestion 与 Context Compilation 合流；TencentDB Agent Memory v2.0.1 则将团队 Memory/Skill/Wiki/CodeGraph 扩展到 Codex、OpenCode、DSH、WorkBuddy，并修复 binding 与多 Agent 隔离。与此同时，OpenTelemetry GenAI semantic conventions、Phoenix、Braintrust、Coze Loop 与 FailproofAI 将观测面从 trace 展示推向 trajectory evaluation、policy enforcement 和运行时治理。

## 本周 TOP 5

1. **Google Antigravity 纳入 Gemini Enterprise（8/21）**：coding agent 首次被完整并入 license、pooled quota、overage、预算、sandbox/browser/MCP policy、集中 audit 与多 IDE 分发，标志“开发者 Agent”被企业控制面系统性收编。
2. **Microsoft Hosted Agents 旧 backend 停止支持（8/20）**：不自动迁移迫使客户接受新的 session sandbox、durable files、专属 Entra identity 与 Responses/Invocations/Activity/A2A 多协议 Runtime ABI，短期迁移成本高、长期锁定也更强。
3. **OpenClaw 2026.8.1-beta.3（8/24）**：external supervisor、verified restart handoff、SQLite backup/restore、durable ingress、secret host binding 与 89 个官方插件完整性回读，把个人 Agent OS 推入可治理、可恢复、可外部监管的新阶段。
4. **Claude Enterprise-managed MCP authorization / XAA / ID-JAG（8/24）**：企业 IdP 可以集中授权 MCP connector，用户无需逐个 OAuth consent；身份从“谁登录了客户端”上移为“组织是否允许此 Agent 代表此用户访问此资源”。
5. **Memory 进入结构化事件与团队资产时代**：AWS JSON event ingestion、OpenViking user policy/remote Skills 与 TencentDB Agent Memory 的团队 ACL/binding 同周出现，竞争点从召回率转为 provenance、ownership、policy inheritance、删除 lineage 与多 Agent 隔离。

## GitHub 热度补漏

本期先执行九组查询：`agent memory github`、`agent context database github`、`agent knowledge graph github`、`AI agent RAG memory skills github`、`MCP gateway github`、`agent auth permission OAuth MCP github`、`browser agent runtime github`、`agent observability eval github`、`agent harness runtime github`。Brave 首个查询后触发 429，其余使用工作区 Tavily/Serper 降级；所有候选均回到官方原文或 GitHub 直查。

- **补入深写**：TencentDB-Agent-Memory、OpenViking、agent-browser、SmolVM、FailproofAI、OpenTelemetry GenAI conventions、agentgateway。
- **高热但本周静默/边界**：Browser4、Kuadrant MCP Gateway 0.9、DeepSeek Harness 首发、Memvid、Graphiti、Firecrawl、Crawl4AI；时间窗外更新不包装成本周新闻。
- **过滤**：awesome-list、教程/课程、纯应用模板、泛榜单及没有原文/日期可复核的二手线索。
- **获取失败但已保留痕迹**：Acontext 官方仓库未验证；agentacct 未找到可可靠核验的本窗材料；AWS 个别月度 release notes 无逐条日期，均未强行归入本周。

---
# 模块 1：Harness / Agent OS 控制层（A1 恢复分片 001）

- 本期时间窗：2026-08-20 00:00 至 2026-08-26 24:00（Asia/Shanghai）。
- 证据口径：仅把官方页面、release 或 commit 的时间落在窗口内者计为“本周动态”；有动态对象已读取官方原文全文。窗口外最近 release 只用于静默背景，不冒充本周新闻。

## 深度笔记（一）：OpenClaw

- **本周动态：** OpenClaw 于上海时间 8 月 24 日 12:40 发布 `2026.8.1-beta.3`，这不是普通模型适配版本，而是一次覆盖 Agent OS 控制面、运行状态、扩展供应链与人机运维面的集中升级。控制层最强信号有四个。第一，新增 `OPENCLAW_SUPERVISOR_MODE=external`，让 OCM 等外部生命周期所有者接管 Gateway，同时保留“经验证的重启与延迟行为”，阻断原生 service mutation 和 self-update，并提供版本化、原子化 restart-handoff consume contract；这等于把 Gateway 从单机 daemon 推向可被企业控制面安全托管的进程。第二，SQLite backup 新增 global/per-agent 的 create、list、verify、restore，且 restore 仅允许 fresh target，使 session/checkpoint 状态有了可验证迁移边界。第三，shared channel-plugin ingress monitor 统一 durable admission、polling、pruning、claim identity validation、adoption handoff 和 shutdown，并迁移 IRC、Synology Chat、Google Chat，说明“多渠道入口”开始共享严格生命周期而不是各插件自管。第四，Control UI 将 verified model setup 连到 Custodian 与可选渠道设置，cron Quick Create 可选 agent-turn model；同时 Codex/Claude session 可通过 paired-node terminal resume，子 Agent terminal yield 立即结算且保留 requester ownership。安全面还新增 shared-store secret 的 exact HTTPS host binding，使未绑定 sentinel substitution 在明文出站前 fail closed；任意可执行插件源需显式 `--force`，而 89 个官方 npm 插件均在 beta.3 被回读核验完整性。路线判断：OpenClaw 正把本地优先 Agent OS 做成可外部监管、可备份恢复、可跨渠道持续运行、可管理插件供应链的完整控制层，而非只提供 agent loop。
- **关键数据：** `v2026.8.1-beta.3`；发布时间 `2026-08-24T04:40:41Z`（上海 12:40）；89 个官方 npm 插件完成 beta selector 与 tarball integrity 回读；`@openclaw/codex@2026.8.1-beta.3` 固定携带 `@openai/codex@0.149.1`。来源：GitHub release/Atom（2026-08-24）、官方 CHANGELOG（2026-08-24）。
- **原文链接：** https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.3 ；https://github.com/openclaw/openclaw/releases.atom ；https://raw.githubusercontent.com/openclaw/openclaw/v2026.8.1-beta.3/CHANGELOG.md
- **影响判断：** 相比以 SDK 为中心的竞品，OpenClaw 的领先点是把 Gateway、session、cron、channels、skills/plugins、Control UI 和本地状态迁移串成一个 OS 级面；本周 external supervisor 与 verified restart handoff 又补上企业控制面接管边界。风险也相应扩大：beta 的发行面极宽，必须继续强化公开稳定 API、状态迁移契约、插件权限审计与兼容矩阵，否则功能宽度会转化为升级复杂度。

## OpenClaw 参照（初步）

1. 将 external supervisor、restart handoff 与 SQLite fresh-target restore 抽成版本化公共运维契约，并配套 upgrade/rollback SLA。
2. 把 secret host binding、插件 provenance、revision-bound MCP grants 统一进入“能力授权图”，让每次外部写入可解释、可撤销、可审计。
3. 继续坚持 requester ownership 与 durable ingress，但对跨 Gateway/跨节点 session migration 加入端到端不变量测试。
# 模块 1：Harness / Agent OS 控制层（A1 恢复分片 002）

## 深度笔记（二）：Anthropic Claude Agent SDK / MCP

- **本周动态：** Anthropic 的 Python 包本周只有 `0.2.142`、`0.2.143`、`0.2.144` 三次 bundled Claude CLI 跟版，真正基础设施级变化集中在 TypeScript SDK `0.3.238`、`0.3.239`、`0.3.246`、`0.3.247`，并与 MCP Python SDK `2.1.0` 的成熟化形成呼应。Claude SDK 把长任务与重连语义进一步显式化：`task_started` 增加 `is_backgrounded` 与 `spawn_depth`；跨 session peer message 被接收策略拒绝时，`command_lifecycle` 不再静默消失而是给出终态 `refused`；host 重复 `initialize` 后会收到 `background_tasks_changed` 的 live snapshot，让重连控制面重新发现仍在运行的工作。`perTaskStopAffordance` 又将 `interrupt()` 从“杀掉当前 turn 及所有后台任务”细分为仅中断当前 turn、让后台 agents/workflows 继续；`user_message_uuid` 则把首个 assistant/stream event 或 error result 精确连回触发它的用户消息。成本治理也进入协议：`modelUsage[*].costBasis` 标注 `list | managed | unknown`，host-managed provider 可在 managed settings 提供 `modelPricing`，且 0.3.239 会把 US-only inference 的 1.1× data-residency multiplier 纳入 `total_cost_usd`。MCP Python SDK `2.1.0` 则收紧 4 MiB 请求体限制到 SSE 与 OAuth endpoint，意外 handler exception 只在 server 侧记录 traceback、客户端仅见类型化错误；同时修复 2026-07-28 notification POST 应返回 202、旧 session 忽略新 cache-hint 字段等跨版本语义。路线判断：Claude Agent SDK 正将 Claude Code 进程协议产品化为“可重连、可后台运行、可按 task 停止、可精确归因成本”的 harness；MCP 则从连接协议走向有资源上限、错误保密和版本兼容的生产底座。
- **关键数据：** TypeScript `0.3.238`（上海 2026-08-21 04:33）、`0.3.239`（8 月 22 日 03:55）、`0.3.246`（8 月 26 日 06:31）、`0.3.247`（8 月 27 日 07:06，上海时间仍落 8 月 27，严格不计本窗动态）；Python `0.2.144`（上海 8 月 26 日 06:47）；MCP Python SDK `2.1.0`（上海 8 月 25 日 03:00）；SSE/OAuth request-body limit 为 4 MiB；US-only inference multiplier 为 1.1×。日期来源均为 GitHub releases Atom，能力来源为各 release 原文。
- **原文链接：** https://github.com/anthropics/claude-agent-sdk-typescript/releases/tag/v0.3.238 ；https://github.com/anthropics/claude-agent-sdk-typescript/releases/tag/v0.3.239 ；https://github.com/anthropics/claude-agent-sdk-typescript/releases/tag/v0.3.246 ；https://github.com/anthropics/claude-agent-sdk-typescript/releases.atom ；https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.144 ；https://github.com/modelcontextprotocol/python-sdk/releases/tag/v2.1.0
- **影响判断：** 最值得 OpenClaw 对标的不是模型能力，而是 interruption scope、reconnect discovery、message-to-result correlation 和 cost basis 这四种控制面语义。OpenClaw 已有更宽的 Gateway/session/channel 面，但应将“中断当前 turn 而保留后台 work”“拒绝也必须落终态”“重连后输出 live tasks snapshot”固化为跨 runtime 的统一契约；MCP 侧还应明确 request size limit、异常脱敏与协议版本兼容矩阵。

## 静默边界说明

- MCP 规范仓库本周无新正式 revision；最新正式规范仍为 `2026-07-28`（背景，非本周）。本周计入的是 MCP Python SDK `2.1.0` 的实现与兼容性演进，不能写成“协议新版本发布”。
# 模块 1：Harness / Agent OS 控制层（A1 恢复分片 003）

## 深度笔记（三）：LangChain / LangGraph / LangSmith

- **本周动态：** LangGraph Python 主仓在窗口内没有新正式 release（feed 最近更新为 8 月 19 日 UTC，上海已在窗口前），但 LangGraph JS SDK 与 LangChain core 给出两组清晰的控制层修复。`@langchain/langgraph-sdk@1.9.31` 修复 reload 后已解决 interrupt 被重新展示：此前下一次 submit 会 replay 旧 `input.requested`，导致已经回答过的 HITL 表单再次出现；新版以 command 被接受后 response 的 `applied_through_seq` 为 cutoff，持续过滤历史 interrupt。这个小 patch 实际触及 durable human-in-the-loop 的核心不变量——恢复不能把已经完成的审批重新变成待办。随后 `@langchain/langgraph-sdk@1.10.0` 在 thread-stream run start 增加 LangSmith replica routing，显示 LangGraph 的执行入口正在与 LangSmith 多副本控制面结合；同时移除 core SDK 未使用的 Svelte/Vue optional peers，减少供应链扫描误报。LangChain `1.3.17` 则修复 custom HITL rejection reason 的 framing，使“拒绝”不仅是布尔决策，而能以可供后续 agent 理解的结构进入控制流。LangSmith Cloud 8 月 17—24 日 changelog 进一步显示 thread 正升级为一等治理对象：annotation queue API 支持 RUN 与 THREAD 混合项；thread evaluator 可用真实 conversation 测试并要求 trace count ≥2；在线 evaluator failure 会落 error 而不是静默缺反馈。路线判断：LangChain 体系本周没有大而新的 planner，而是在把 sequence cutoff、HITL rejection、thread routing、thread evaluation 做成一致的 durable workflow 语义；LangGraph 执行与 LangSmith 托管治理继续合流。
- **关键数据：** `@langchain/langgraph-sdk@1.9.31` 发布于 `2026-08-20T21:53:53Z`（上海 8 月 21 日 05:53）；`1.10.0` 发布于 `2026-08-26T21:31:17Z`（上海 8 月 27 日 05:31，严格超出本窗，故仅作边界背景，不计本周动态）；`langchain==1.3.17` 发布于 `2026-08-25T02:40:54Z`（上海 10:40）；LangSmith Cloud changelog 标注 August 17-24, 2026。来源：GitHub release Atom/原页与 LangSmith 官方 changelog。
- **原文链接：** https://github.com/langchain-ai/langgraphjs/releases/tag/%40langchain%2Flanggraph-sdk%401.9.31 ；https://github.com/langchain-ai/langchain/releases/tag/langchain%3D%3D1.3.17 ；https://docs.langchain.com/langsmith/changelog ；边界背景：https://github.com/langchain-ai/langgraphjs/releases/tag/%40langchain%2Flanggraph-sdk%401.10.0
- **影响判断：** `applied_through_seq` 的价值高于普通 UI bug：它为“恢复后哪些控制事件已生效”给出可计算边界。OpenClaw 应对 approval、tool interruption、subagent completion、channel ingress acknowledgement 采用同类 monotonic sequence/cursor，不依赖界面状态推断；同时可借鉴 LangSmith 将 THREAD 作为评测、审阅和权限治理的独立资源，但避免把运行时完全锁定到单一托管控制面。

## 边界与静默说明

- LangGraph Python 本周无正式新版本；最近 `langgraph-sdk==0.4.3` 的 feed 时间为 2026-08-19 UTC（上海 8 月 20 日 02:05）但该聚合 release 的具体有效发布时间和变化跨越多个旧版本，未将其当作本周新的控制层发布，以免日期误判。
- LangGraph JS `1.10.0` 的 UTC 日期为 8 月 26，但上海时间已是 8 月 27，严格排除在本周动态之外，仅用作下一期观察背景。
# 模块 1：Harness / Agent OS 控制层（A1 恢复分片 004）

## 深度笔记（四）：Google ADK / A2A

- **本周动态：** Google 同周发布 ADK JS `2.0.0` 与 ADK Python `2.8.0`，形成从开发范式到生产约束的双重跃迁。JS 2.0 的核心是“Agent 即 Workflow Node”：移除 `LLMAgentWrapper`，让 `BaseAgent` 继承 `BaseNode`，因此 agent 原生获得 `rerunOnResume`、`waitForOutput`、`retryConfig`、`timeout`、input/output/state schema；旧 `SequentialAgent`、`ParallelAgent`、`LoopAgent` 开始弃用，bare Workflow 可直接成为 root。新 workflow engine 具备 graph/node registry、Function/Tool node、ParallelWorker/JoinNode、dynamic `ctx.runNode()`、LLM-agent-as-node、node-as-tool、task mode、NodeErrorEvent、OpenTelemetry tracing，并把 HITL confirmation 绑定到具体 action、credential response 绑定到发起 request。Python 2.8.0 则强化跨 Agent 与运行时治理：`RemoteA2aAgent` 支持 native task mode、auth scheme/credential 与 registry auth resolution；`ADK_MAX_LLM_CALLS` 可限制最大模型调用；ParallelAgent 支持 sub-agent escalation；live session 使用 resumption handle；函数 response 与对应 call/invocation 重新精确配对，修复 resume 误判、重复执行、重复 OAuth prompt、parallel sub-agent failure 丢失等问题。安全上，relayed agent output 会被 fence，防止伪装成 instruction；GitHub event workflow 防 prompt injection；API registry credentials 只发 Google API endpoint；legacy session unpickling 受限。A2A 规范仓库本周没有新版本，最新仍是 5 月的 1.0.1；本周信号来自 ADK 对 A2A task/auth/HITL 边界的实现深化。路线判断：Google 正以统一 graph runtime 替换传统固定编排类，并把 ADK 与 A2A、Vertex Agent Engine、Model Armor、OTel、Memory Bank 收敛成跨本地开发与云托管的完整 harness。
- **关键数据：** ADK JS `main-v2.0.0` GitHub 发布时间 `2026-08-21T15:08:34Z`（上海 8 月 21 日 23:08），release 正文标注 2026-08-20；ADK Python `v2.8.0` 发布时间 `2026-08-26T23:25:15Z`（上海 8 月 27 日 07:25），但 release 正文明确版本日期为 `2026-08-25`。为避免时区争议，本报告将 2.8.0 标为“官方版本日期落窗、GitHub publish 时刻越过上海窗口 7 小时 25 分”的边界动态；主汇总应显式保留该限定。实验 telemetry 默认关闭，需 `ADK_EXPERIMENTAL_TELEMETRY=true` 或 RunConfig opt-in。
- **原文链接：** https://github.com/google/adk-js/releases/tag/main-v2.0.0 ；https://github.com/google/adk-js/releases.atom ；https://github.com/google/adk-python/releases/tag/v2.8.0 ；https://github.com/google/adk-python/releases.atom ；A2A 静默证据：https://github.com/a2aproject/A2A/releases.atom
- **影响判断：** Agent-as-node 是本周控制层最强范式信号之一：图节点不再只是包裹 agent 的外部壳，agent 与 deterministic workflow 共用 retry、timeout、schema、resume、trace 语义。OpenClaw 可借鉴统一 `agent turn / tool / function / subagent / workflow` 的 execution-node interface，但应保留其跨渠道、跨 runtime、本地优先优势；同时必须像 ADK 一样把 action-confirmation、credential-response、function-response 与发起请求做不可混淆的强绑定。

## 时间边界审计

- Python 2.8.0 存在“release notes 日期 8 月 25、GitHub 发布 UTC 8 月 26 23:25（上海已 8 月 27）”的冲突。状态表应写“边界动态”，不把 GitHub 发布时间错误换算为窗内。
# 模块 1：Harness / Agent OS 控制层（A1 恢复分片 005）

## 深度笔记（五）：Microsoft Agent Framework / Semantic Kernel / AutoGen

- **本周动态：** Microsoft Agent Framework（MAF）`.NET 1.19.0` 是本周微软线的主信号，集中解决 durable session、托管长任务、协议收敛与拦截扩展。版本新增 session-persisted chat client routing，使恢复后的 session 不会因进程重启或拓扑变化而随意切换 client；新增 Azure Blob Storage session persistence，并让 Foundry hosted agent state 持久化。更重要的是，Foundry Hosted Agents 支持 resilient long-running 与 steerable 模式，MAF 的 MCP long-running task 也以 breaking change 迁移到 MCP `2026-07-28` Tasks extension，说明微软不再维护私有长任务语义，而转向标准任务协议。`agent-hooks interception contract` 成为一等实验特性，为安全检查、审计、策略注入提供统一切点；A2A streaming artifact updates、AG-UI context forwarding 与 Harness file tool snake_case 描述也被修复，打通 agent-to-agent、agent-to-UI、agent-to-tool 三条协议面。该版本另有 feature-usage bitmask、compaction provider/chat reducer 文档澄清，以及 ReasoningSummary resume passthrough。Semantic Kernel 本周无 release（最近 .NET 1.80.0 为上海 8 月 18 日），AutoGen releases 更长期静默（最近 2025-09-30），因此微软的 harness 创新重心已经明显转移到 Agent Framework，而 SK 更像 connector/kernel 维护线、AutoGen 进入遗留与迁移背景。
- **关键数据：** MAF `dotnet-1.19.0` 发布于 `2026-08-22T12:48:00Z`（上海 8 月 22 日 20:48）；Semantic Kernel 最新 release feed 为 `dotnet-1.80.0`，`2026-08-18T15:12:30Z`（窗口前）；AutoGen 最新为 `python-v0.7.5`，`2025-09-30T06:18:26Z`。来源：各 GitHub release Atom 与 MAF release 全文。
- **原文链接：** https://github.com/microsoft/agent-framework/releases/tag/dotnet-1.19.0 ；https://github.com/microsoft/agent-framework/releases.atom ；https://github.com/microsoft/semantic-kernel/releases.atom ；https://github.com/microsoft/autogen/releases.atom
- **影响判断：** MAF 的方向不是再造 agent loop，而是把 session routing、state store、cloud hosted runtime、MCP Tasks、A2A、AG-UI 与 hooks 组合成企业控制层。OpenClaw 的 external supervisor、SQLite snapshot 和 channel ingress 在本地/边缘侧更完整，但应对标 MAF 的 pluggable persistence、session-persisted routing 与标准 Tasks extension；尤其要避免 runtime fallback 在恢复后改变 provider/client 而破坏确定性。

## 静默背景

- **Semantic Kernel：** 本周无新 release；不将 8 月 18 日版本重复包装为本周动态。
- **AutoGen：** 本周无 release，且官方 feed 最近更新时间停在 2025 年 9 月。模块判断应把 AutoGen 视为 Microsoft Agent Framework 的历史背景，不与 MAF 并列为同等活跃主线。
# 模块 1：Harness / Agent OS 控制层（主会话补片 006）

## 本周模块结论

- **Harness 的共同主线已从“怎样规划”转为“怎样恢复、授权、重连和归因”。** OpenClaw 把 external supervisor、verified restart handoff、SQLite backup/restore 与 durable channel ingress 做成 Agent OS 运维面；Claude Agent SDK 把后台任务、精确中断、重连任务快照与成本口径放进协议；Microsoft Agent Framework 则把 session routing、Blob persistence 与 MCP Tasks 串到托管 runtime。
- **Graph/Workflow 正在与 Agent 统一执行语义。** Google ADK JS 2.0 让 Agent 原生成为 Workflow Node，共享 retry、timeout、schema、resume 与 OTel；LangGraph 的 `applied_through_seq` 修复证明 HITL 恢复需要单调、可计算的事件生效边界。
- **安全不变量开始进入 SDK 状态层。** OpenAI Agents SDK 的最新稳定版仍停在窗口前，但其 guardrail-rejected tool output 从 replay/persisted state 中真正清除、checkpoint usage 隔离等修复仍是本期必须跟踪的紧邻背景；本周未发现新的 Python/JS release，故不冒充本周动态。
- **OpenClaw 的宽度领先，但企业化竞争点正在收窄到契约。** 竞品正把 session persistence、background task discovery、tool approval、A2A/MCP task、cost basis 与 trace lineage 做成稳定 API；OpenClaw 下一步不是继续堆入口，而是把这些能力变成可验证、可迁移、可回滚的公共契约。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态：2026.8.1-beta.3 | https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.3（上海 8/24） | 是 |
| OpenAI Agents SDK / Responses API | 本周静默；最近 v0.22.0 / JS v0.17.0 均为上海 8/19，窗口前 | https://github.com/openai/openai-agents-python/releases.atom；https://github.com/openai/openai-agents-js/releases.atom | 否（背景补写） |
| Anthropic Claude Agent SDK / MCP | 有动态：TS 0.3.238/0.3.239/0.3.246；MCP Python SDK 2.1.0 | 对应 GitHub release 原页，8/21—8/26 | 是 |
| LangChain / LangGraph / LangSmith | 有动态：JS SDK 1.9.31、LangChain 1.3.17、LangSmith thread/eval changelog | https://docs.langchain.com/langsmith/changelog 等 | 是 |
| Google ADK / A2A | 有动态：ADK JS 2.0；Python 2.8.0 为时区边界项；A2A 规范静默 | https://github.com/google/adk-js/releases/tag/main-v2.0.0 | 是 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 有动态：MAF .NET 1.19.0；SK/AutoGen 静默 | https://github.com/microsoft/agent-framework/releases/tag/dotnet-1.19.0 | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 控制层静默；平台存量能力与本周信号放模块8 | Databricks 官方平台文档/模块8矩阵 | 否 |
| CrewAI | 有版本活动，但基础设施信号中等 | https://github.com/crewAIInc/crewAI/releases/tag/1.15.17（8/20 UTC） | 否 |
| Dify | 有 1.17.0，但由模块8/工具治理按需引用 | https://github.com/langgenius/dify/releases/tag/1.17.0（8/25） | 否 |
| n8n / Flowise | 普通 workflow/runtime 维护，未核到需深写的 Harness 级强信号 | 官方 releases | 否 |

## OpenAI Agents SDK / Responses API（静默背景，严格不计本周）

- **最近背景：** OpenAI Agents SDK Python `v0.22.0` 与 JS `v0.17.0` 都在 `2026-08-19` 发布，早于本期 8 月 20 日起点，因此本期状态必须写“静默”。但两版揭示的控制层不变量仍值得保留作竞争判断：被 agent output guardrail 拒绝的终端 function-tool 输出不再保留于 SDK 自有的 replay/persisted state；JS 对无法证明 pending terminal output 属于哪个 response 的序列化 approval checkpoint 选择 fail closed，并提醒该机制不能撤销外部工具副作用或删除应用自有副本。Python 还让非流式 Responses 的 `failed`/`incomplete` 终态抛 `ModelBehaviorError`，隔离独立 `RunState` checkpoint 的 usage accounting、保留 nested-agent 聚合，并把 `handoff(agent)` 展开到生成图。路线判断：OpenAI 正把 Responses API 上层 SDK 从轻量编排器推进为带持久状态、guardrail、成本与图可视化的生产 Harness，但本周没有新 release，不能把 8 月 19 日修复写成 8 月 20—26 日事件。
- **关键数据：** Python `v0.22.0` 发布时间 `2026-08-19T13:44:38Z`；JS `v0.17.0` 发布时间 `2026-08-19T14:38:44Z`，均在上海时间 8 月 19 日晚；本期无更晚 release。来源为两个官方 Atom feed 与 release 全文。
- **原文链接：** https://github.com/openai/openai-agents-python/releases/tag/v0.22.0 ；https://github.com/openai/openai-agents-js/releases/tag/v0.17.0
- **影响判断：** OpenClaw 应把“策略拒绝的数据不得进入 transcript、memory、checkpoint、backup”和“审批 checkpoint 所属 response 无法证明时 fail closed”作为端到端安全测试；同时必须明确工具外部副作用与内部 replay redaction 是两个不同责任域。

## 静默对象补充

- **Databricks：** 本周未核到 Mosaic AI Agent Framework / Agent Bricks 的独立控制层新版本；其平台化能力与矩阵结论放在模块8，避免跨模块重复。
- **CrewAI / Dify / n8n / Flowise：** 已扫描 release。CrewAI 1.15.17、Dify 1.17.0虽落入窗口，但本期 TOP 信号更集中于 durable state、身份、sandbox 与治理；普通 workflow/connector/平台维护不占用深写篇幅。

## 模块洞察

- **Harness 控制层正在标准化“可恢复执行契约”，而非 planner 算法。** 任务中断与后台继续、重连发现、审批事件游标、session-persisted routing、Agent-as-node、MCP Tasks、成本口径与状态备份，正在成为跨供应商标准件；实现仍碎片化，谁能给出开放且可验证的契约，谁更可能成为下一代 Agent OS。

## OpenClaw 参照（行动项）

1. 把 turn/task/workflow/subagent 统一为带 `state + cursor + parent lineage + interrupt scope + cost basis` 的 execution node。
2. 为 approval、tool result、channel ingress、subagent completion 建立单调 sequence/cursor，避免恢复后重复授权或重复执行。
3. 将 external supervisor、backup/restore、plugin provenance 与 secret host binding 汇入机器可读运维/安全 posture，并提供 upgrade/rollback SLA。
# 研究线 B｜模块 2 总览：Runtime / Session / State

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）
- 核验原则：窗口内动态以官方原文为准；GitHub 项目直查仓库、release/changelog；窗口外只作背景。

## 本周模块结论

- **托管 Runtime 的竞争已从“能否托管一次调用”转向 session、隔离、持久文件与迁移契约。** Microsoft 在 8 月 20 日正式停止旧 Hosted Agents preview backend 支持，未自动迁移；新后端以每 session 独立 sandbox、跨 turn/idle 保持的 `$HOME` 与 `/files`、15 分钟默认 idle timeout、专属 Entra identity 和独立 endpoint 为核心。这是本周最硬的生命周期事件。
- **OpenClaw 的状态层进入“可靠性与可恢复性”密集修补期。** 2026.8.1-beta.2/3 同周覆盖 SQLite 快照、共享状态损坏恢复、session 隔离、Gateway 重连顺序、cron preflight 与一次性任务 lifecycle claim race，说明个人 Agent OS 与云 Runtime 面临同类分布式状态问题。
- **Google 把 Runtime 与 sandbox/API 控制面进一步合并。** Managed Agents API 文档在 8 月 21 日更新：Agents API 配环境与网络白名单，Interactions API 承担运行时交互，每个 Antigravity agent 默认进入无外网、无凭证隔离 sandbox；这是“配置即 Agent”路线，而非单纯部署 SDK 包。
- **本周没有证据表明 E2B、Modal、Daytona 在 Runtime/长任务维度发布同量级正式更新。** 它们继续提供背景竞争压力，但本周更强信号来自云厂生命周期迁移与 OpenClaw 自身可靠性。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 静默；persistent Runtime Instances 为 8 月 7 日背景 | https://aws.amazon.com/blogs/aws/runtime-instances-persistent-compute-for-production-ai-agents-on-amazon-bedrock-agentcore/ | 否 |
| Google Vertex AI Agent Engine / Managed Agents API | 有动态；官方文档 8 月 21 日更新 | https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents | 是 |
| Microsoft Foundry Hosted Agents / Agent Service | 有动态；旧 preview backend 8 月 20 日停止支持 | https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview | 是 |
| 阿里云百炼 / Model Studio / PAI | 有动态（安全控制面旁证）；ASC 文档 8 月 21 日更新并覆盖 PAI/百炼 | https://www.alibabacloud.com/help/en/asc/user-guide/agent-risk-detection-overview | 是 |
| 火山 Ark / Coze / Coze Studio | 静默 | https://docs.volcengine.com/docs/6662/107386?lang=zh | 否 |
| 腾讯智能体平台 / 元器 / CloudBase AI Toolkit | 静默 | https://cloud.tencent.com/product/tcb | 否 |
| OpenClaw sessions / cron / Gateway | 有动态；2026.8.1-beta.2/3 | https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.3 | 是 |
| E2B | 静默（Runtime 维度） | https://github.com/e2b-dev/infra/releases | 否 |
| Modal | 静默（Runtime 维度） | https://modal.com/docs | 否 |
| Daytona | 静默（Runtime 维度） | https://www.daytona.io/changelog | 否 |

### 静默对象背景
AWS 8 月 7 日已用 Runtime Instances 把 AgentCore 从最长 8 小时 microVM session 扩展到面向多日任务、GPU 与同机多 Agent 的持久托管计算；火山、腾讯以及 E2B/Modal/Daytona 本周未核出窗口内同级发布，不能用既有产品能力冒充新动态。

## 模块洞察
- Runtime 层正在被云厂收编为“session sandbox + identity + durable filesystem + protocol endpoint”的组合品；真正的锁定点不再是模型，而是状态迁移、生命周期语义和可恢复性。

## OpenClaw 参照
- OpenClaw 已有 sessions、cron、Gateway 与 SQLite 状态核心，产品形态比单纯 Agent API 更接近完整 Runtime；但应借鉴 Foundry，把 **session 隔离、文件持久性、idle/TTL、版本迁移、专属身份与 endpoint 契约**做成可查询的一等资源，而不只散落在执行逻辑与修复项中。
# 研究线 B｜模块 2 深度笔记（一）：Microsoft + Google

## Microsoft Foundry Hosted Agents / Agent Service

- **本周动态：**窗口第一天（8 月 20 日）是 Foundry Hosted Agents 旧版 public preview hosting backend 的停止支持日期，且官方明确说旧部署**不会自动迁移**，必须重新部署。新模型不是一次换包，而是 Runtime 契约重写：计算由请求触发自动 provision，默认 idle timeout 为 15 分钟；每个 session 获得独立 sandbox，并让 `$HOME` 与 `/files` 在多轮及 idle 期间持续存在；部署创建时即分配专属 Entra identity，替代共享 project managed identity；调用从带 `agent_reference` 的共享 project endpoint 改为每 Agent 独立 URL，如 `{project_endpoint}/agents/{name}/endpoint/protocols/openai/responses`。协议面从 Responses 扩展到 Invocations、Activity、A2A，一个 Agent 可同时暴露多个协议；agent/version/session/file 操作都有完整 REST 生命周期。依赖门槛也具体化为 `azure-ai-projects>=2.3.0`、`azd>=1.23.0`，并以 `azure-ai-agentserver-responses`、`azure-ai-agentserver-invocations` 替换 LangGraph/Agent Framework 专用 adapter。商业判断是 Microsoft 用强制迁移消除早期框架耦合，把 Agent 托管收敛成“协议服务器 + 专属身份 + session sandbox”平台，牺牲 preview 兼容性换取长期控制面一致性。
- **关键数据：**旧 backend 支持截止 2026-08-20；默认 idle timeout 15 分钟；Python core 包 `azure-ai-agentserver-core 2.0.0b1`，.NET core `1.0.0-beta.21`，Responses/Invocations `.NET 1.0.0-beta.1`；来源均为 Microsoft Learn（文档日期 2026-08-06，页面更新元数据 2026-08-18，截止事件发生于本周）。
- **原文链接：**https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview
- **影响判断：**这把 Hosted Agents 从“托管框架 adapter”升级为真正 runtime ABI。对平台用户的短期影响是不可回避的重部署、RBAC 重绑与 endpoint 修改；长期则获得更清晰的 session、文件、身份和多协议边界。OpenClaw 可直接借鉴 migration checklist 与 endpoint/version 资源模型，尤其避免状态 schema 演进依赖隐式升级。

## Google Vertex AI Agent Engine / Managed Agents API

- **本周动态：**Google 官方 Managed Agents API overview 标记“Last updated 2026-08-21 UTC”，把托管 Agent 的架构边界写得非常明确：Agents API 是 control plane，用配置创建 Agent、挂载外部数据源、定义 network allowlist，并把配置应用到 sandbox；Interactions API 是 data plane，承担对已部署 Agent 的运行时交互。每个 Agent 由 Antigravity harness 驱动，在独立 sandbox 中推理、规划、调用 skills、执行代码、检索网页和读写文件。默认安全姿态是**没有外部系统、网络或凭证访问**；任何外联必须由开发者显式配置，并要求最小权限、短期 token、可信 MCP/tool source 与生产前隔离测试。外部 Cloud Storage 文件可按需加载进容器文件系统，结果可写回。这个变化/文档落点的重要性在于，Google 正把“agent definition”从 Python 部署包继续上移为 config-driven、REST-first 资源，并把 sandbox policy 纳入同一控制面；这与 Agent Engine 的 SDK/runtime 路线形成双轨：成熟团队仍可部署自带 runtime，标准自治任务则可直接定义受控 Antigravity Agent。
- **关键数据：**官方页面更新 2026-08-21 UTC；两类核心接口为 Agents API 与 Interactions API；默认外网/外部系统/凭证访问均关闭；来源：Google Cloud 官方文档。
- **原文链接：**https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents ｜ https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- **影响判断：**Google 的差异化不是只卖容器，而是把 harness、skills、sandbox、network allowlist 与交互 API 打包。其风险是 Antigravity 配置式路线可能限制自定义 runtime；其优势是安全默认值和平台治理一致。OpenClaw 若接入云执行，可采用“双轨”：本地/自托管完整 Gateway 与远程 config-defined worker，后者默认 deny-network、按任务显式授权。
# 研究线 B｜模块 2 深度笔记（二）：OpenClaw + 阿里云

## OpenClaw sessions / cron / Gateway runtime

- **本周动态：**OpenClaw 在窗口内发布 `2026.8.1-beta.2` 与 8 月 24 日的 `2026.8.1-beta.3`，Runtime 信号不是单一新功能，而是对 session/state/Gateway 恢复语义的一轮系统性加固。beta.2 的完整 release notes包括：SQLite snapshot verification 移到独立进程，避免 worker thread 关闭文件时丢掉 Gateway 的 POSIX WAL lock；读写损坏证实后只逐出精确的 cached SQLite owner，使修复后的 DB 无需 Gateway restart 即恢复；Gateway replacement WebSocket 重置 event-sequence baseline，防止跨连接代际做错误 gap recovery；Claude CLI 卡死后从 turn 前 checkpoint fork，以保留 native cache 且不重复 pending prompt；cron local-provider preflight 区分 bounded timeout 与具体嵌套错误；session mutation、草稿附件、Talk 媒体等进一步按逻辑 session/Gateway 隔离。beta.3 的 highlights又加入明确的外部 Gateway lifecycle supervision、紧凑且验证过的 SQLite backup/fresh-target restore、paired Chrome session 的 Puppeteer-compatible CDP relay；发布证据称 89 个官方 npm plugins 均完成 beta.3 read-back，`@openclaw/codex` 固定托管 `@openai/codex@0.149.1`。这显示 OpenClaw 已从“本地助手”跨入状态型 control/runtime：竞争力是端侧完整性，短板则是这些保障仍以大量修复项出现，尚需收敛为可声明 SLA、checkpoint 与 migration contract。
- **关键数据：**`2026.8.1-beta.3` 发布于 2026-08-24；89 个官方 npm 插件回读校验；Codex runtime `0.149.1`；GitHub 直查约 387.7k stars / 81.4k forks（2026-08-27 查询快照，动态计数）；来源：GitHub release/repository。
- **原文链接：**https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2 ｜ https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.3 ｜ https://github.com/openclaw/openclaw
- **影响判断：**cron、sessions 和 Gateway 形成的是“长期在线个人 runtime”，其故障模型已经与云端 durable agent 同构。下一步应把 backup/restore、session checkpoint、claim conflict、cron exactly-once/at-least-once 语义公开化，并提供状态健康指标；这将是 OpenClaw 相较纯 SDK harness 的长期护城河。

## 阿里云百炼 / Model Studio / PAI（Runtime 安全控制面旁证）

- **本周动态：**阿里云 Agent Security Center 的官方文档在 8 月 21 日更新，虽然它不是百炼 Runtime 新版本，却是本周可核实的生产基础设施信号：安全中心把 Agent 生命周期分成模型交互、知识/记忆、运行环境/工具、配置/组件、身份/凭证五域，并明确覆盖 PAI、Bailian（百炼）、Dify、AgentKit、AgentRun 等平台。运行环境层检测未开启 sandbox isolation、未授权 tool invocation、命令/代码注入、SQL injection、SSRF、越权对象访问、恶意代码与 MCP/tool poisoning；配置层检查 model/MCP/API tool 是否使用 HTTPS、Gateway 强 token、session 隔离、全局 Elevated tool、plugin/skills watcher、日志/session 敏感信息过滤等。更值得注意的是，官方列出“Alibaba Cloud Standard - OpenClaw Security Baseline”，包括 Gateway 不绑定 `0.0.0.0`、不存明文密码、共享 DM session 隔离、sandbox、强 token、禁用全局 elevated、plugin allowlist 等。技术商业判断：阿里没有在本周发布新的 durable runtime，但正在从计算托管向“跨平台 Agent Security posture management”切入，以扫描和基线把百炼/PAI 及第三方 Agent 纳入控制面；这可成为企业采用入口，也弥补其 Runtime 产品叙事不如 AWS/Microsoft 清晰的短板。
- **关键数据：**5 个安全域；页面更新时间 2026-08-21；覆盖 PAI、Bailian、Dify、AgentKit、AgentRun；来源：Alibaba Cloud 官方文档。
- **原文链接：**https://www.alibabacloud.com/help/en/asc/user-guide/agent-risk-detection-overview
- **影响判断：**阿里把 Runtime 的价值从“运行成功”扩展为“配置可审计”，并直接把 OpenClaw 纳入基线对象，说明 OpenClaw 已成为云安全厂商真实威胁模型的一部分。OpenClaw 应把这些检查映射为机器可读 `doctor/security posture` 输出，既减少误配置，也可与云 CSPM/ASC 对接形成企业分发通道。
# 研究线 B｜模块 3 总览：Sandbox / Computer Use / Browser

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）

## 本周模块结论

- **Anthropic 把 Computer Use/Browser Use 从模型能力升级为稳定的跨云工具 ABI。** 8 月 20 日，`computer_toolset_20260801` 与 `browser_toolset_20260801` 在 Google Cloud 上可用，覆盖 Fable 5、Mythos 5、Opus 5、Sonnet 5、Opus 4.8；它们与 Claude API 使用相同 `tools` entry，形成跨托管面的请求一致性。
- **OpenAI 本周完成 Assistants API 退场。** 8 月 26 日关闭 Assistants API，Code Interpreter 用户必须迁移到已达 feature parity 的 Responses API；这是执行环境的 API 代际收敛，而不是新 sandbox 性能发布。
- **开源 sandbox/browser 补漏比商业云更有工程密度。** agent-browser `v0.35.0/0.35.1` 加入企业私有 CA 的隔离 NSS trust store、安全 OIDC skill、stream URL/ref 修复；SmolVM 在一周内快速推进到 `v1.13.0`，引入 desktop/VNC、嵌套 checkpoint、fork hardening、软件 WebGL、loopback/egress 安全等。
- **Google Managed Agents 与 Code Execution 显示 sandbox 产品开始分层。** 前者是带 harness 的自治容器，默认 deny-network；后者是任意框架可调用的无网代码 sandbox，支持亚秒创建、100MB I/O、最长 14 天可配置 TTL。平台开始同时提供“agent-native sandbox”和“raw execution substrate”。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| E2B | 静默 | https://github.com/e2b-dev/infra/releases | 否 |
| Browserbase / Stagehand | 静默；Stagehand v4 为 8 月 10 日背景 | https://www.browserbase.com/changelog/stagehand-v4 | 否 |
| Daytona | 静默 | https://www.daytona.io/changelog | 否 |
| Modal | 静默 | https://modal.com/docs/guide/sandbox | 否 |
| OpenAI Computer Use / Browser / Code Interpreter | 有动态；Assistants API 8 月 26 日关闭 | https://developers.openai.com/api/docs/assistants/tools/code-interpreter | 是 |
| Anthropic Computer Use / Browser Use | 有动态；8 月 20 日跨云可用 | https://platform.claude.com/docs/en/release-notes/overview | 是 |
| AWS AgentCore Browser / Code Interpreter | 静默 | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html | 否 |
| Azure Browser Automation / Code Interpreter / Playwright Workspaces | 静默 | https://learn.microsoft.com/en-us/azure/foundry-classic/agents/whats-new | 否 |
| Google Code Execution / Managed Agents sandbox | 有动态；Managed Agents 文档 8 月 21 日更新 | https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents | 是 |

## 补漏状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| agent-browser | 有动态；v0.35.0/0.35.1（8/24、8/26） | https://agent-browser.dev/changelog | 是 |
| SmolVM（smol-machines/smolvm） | 有动态；v1.9.x—v1.13.0 密集发布 | https://github.com/smol-machines/smolvm/releases | 是 |
| Browser4 | 静默/未证实窗口内 release | 热扫线索止于 8 月 19 日 | 否 |

### 静默对象背景
E2B、Browserbase/Stagehand、Daytona、Modal、AWS AgentCore Browser/Code Interpreter 与 Azure Playwright/Browser Automation 都已有可用执行环境，但本周未核出正式原文级重大发布；Stagehand v4（8 月 10 日）及 AWS 既有区域扩展只能作背景。

## 模块洞察
- Sandbox 层正在分化成三类标准件：无网代码执行器、带浏览器/桌面的交互环境、内嵌 harness 的自治 sandbox；真正竞争点从“有隔离”转向网络/凭证默认权限、checkpoint/fork、可观测流与跨云工具 ABI。

## OpenClaw 参照
- OpenClaw 的 browser control 与 host tool execution 应继续解耦：把本地 browser session、远程 CDP、raw code sandbox、持久 VM 作为不同 execution provider；统一暴露 TTL、network policy、mount、checkpoint、stream 和 audit 字段，避免工具层把执行环境差异藏掉。
# 研究线 B｜模块 3 深度笔记（一）：Anthropic + OpenAI

## Anthropic Computer Use / Browser Use

- **本周动态：**Anthropic 在 8 月 20 日将 `computer_toolset_20260801` 与 `browser_toolset_20260801` 带到 Google Cloud，支持 Claude Fable 5、Mythos 5、Opus 5、Sonnet 5 与 Opus 4.8，且请求形状与 Claude API 的 `tools` entry 相同。窗口前一天（8 月 19 日，作为紧邻背景而非本周事件）Computer Use 已用 `computer_toolset_20260801` 在 Claude API 脱离 beta：不需 beta header，支持单 turn 多个 batch actions、默认启用 `zoom`、并通过 `configs` 对 toolset member 做配置；同时首发 `browser_toolset_20260801`。Browser Use 与整桌面 screenshot/click 不同，它工作在应用托管的 browser viewport，直接读取 accessibility tree、elements、forms 和 tabs，并增加 element refs、form input、tab management、download reporting 与 opt-in file upload。官方定价文档还说明声明 Computer toolset 默认成员会增加约 4,500 input tokens（不同模型约 4,520—4,590），禁用 `zoom` 可减少约 410 tokens；工具本身按标准 tool use 计费。技术判断：Anthropic 正把 computer/browser 操作定义成模型与执行器之间的版本化 ABI，并通过同一 schema 跨 Claude API/Vertex 分发；商业上这降低企业跨云迁移成本，也把“浏览器由客户托管、模型负责决策”的责任边界写清。
- **关键数据：**Google Cloud 上线日期 2026-08-20；5 个模型家族；toolset IDs 为 `computer_toolset_20260801`、`browser_toolset_20260801`；定义开销约 4.5k input tokens，禁用 zoom 约减 410；来源：Anthropic 官方 release notes/pricing。
- **原文链接：**https://platform.claude.com/docs/en/release-notes/overview ｜ https://platform.claude.com/docs/en/about-claude/pricing
- **影响判断：**这是比单个 CUA benchmark 更重要的基础设施信号：执行器供应商可以围绕稳定 action/config schema 做兼容层。OpenClaw 可考虑为 browser/computer tool provider 增加显式 toolset version 与 capability negotiation，使本地 Chrome、远程 sandbox 和云 CUA 可互换且不丢安全选项。

## OpenAI Computer Use / Browser / Code Interpreter

- **本周动态：**OpenAI 官方 Code Interpreter 文档明确：在 Responses API 达到功能对等后，Assistants API 于 2026 年 8 月 26 日关闭，要求现有集成迁移。这一事件直接影响基于 Assistants `assistant/thread/run` 和 `tool_resources.code_interpreter.file_ids` 的执行环境：旧 Code Interpreter 以 thread 为 session 边界，费用为每 session **$0.03**，默认活跃 1 小时；同一 assistant 在两个 thread 并发调用会创建两个计费 session。旧接口支持最大 512MB 文件，能返回 stdout/stderr、图像与生成文件，并通过 Run Steps 暴露 code input/output logs。关闭日落在本期最后一天，因此属于明确本周基础设施变化。技术判断是 OpenAI 不再维持 Assistants 独立状态机，而把 Code Interpreter/Computer Use 等工具集中到 Responses API 的统一事件与工具模型；这能减少双栈开发，但迁移者必须重新校验 session 重用、文件归属、计费和可观测日志语义，不能只替换 endpoint。商业上，API 收敛会把生态创新集中于 Responses，但也暴露 OpenAI 对 preview/legacy 生命周期的强控制。
- **关键数据：**Assistants API shutdown 2026-08-26；旧 Code Interpreter $0.03/session；默认 session 1 小时；单文件最大 512MB；来源：OpenAI 官方开发者文档（2026-08-27 抓取）。
- **原文链接：**https://developers.openai.com/api/docs/assistants/tools/code-interpreter ｜ https://developers.openai.com/platform/assistants/migration
- **影响判断：**对任何 OpenClaw OpenAI adapter，必须确认没有把 Assistants thread 当成 durable session 后端；应将长期 session/state 留在 OpenClaw，自身只把 Responses tool runtime 当执行器。这样即便供应商再次换 API，用户状态、cron 与审计链不随之迁移。
# 研究线 B｜模块 3 深度笔记（二）：Google sandbox + agent-browser

## Google Code Execution / Managed Agents sandbox

- **本周动态：**Google Managed Agents API overview 于 8 月 21 日更新，确认每个 Antigravity Agent 运行在隔离 sandbox；Agents API 可定义环境、挂载外部数据源和 network allowlist，Interactions API 负责 runtime 交互。默认 sandbox 不访问外部系统、网络或凭证，Cloud Storage 文件按需进入容器文件系统并可写回；外联及 MCP/API 凭证均需开发者显式提供。与此并列的 Code Execution 则是更底层、模型和框架无关的执行器：官方称 sandbox 能在 1 秒内创建并执行代码，单请求/响应总文件 I/O 上限 100MB，执行状态最长保持 14 天且 TTL 可配置；它提供 create/get/list/execute 操作，stdout、stderr 和生成文件均返回，默认有限文件系统且无网络。预装库版本具体到 numpy 2.1.3、pandas 2.2.3、TensorFlow 2.20.0、scikit-learn 1.6.1、OpenCV 4.11.0.86 等，但不能自行安装库。技术路线判断：Google 同时卖“高层自治 agent sandbox”和“低层无网 code sandbox”，前者强化配置式 Agent，后者作为通用 substrate；这比只把 Python REPL 嵌入模型 API 更有生命周期与治理边界。
- **关键数据：**Managed Agents 页面更新 2026-08-21 UTC；Code Execution 创建/执行 `<1s`；I/O 100MB；state TTL 最长 14 天且可配；主要库版本见官方原文；来源：Google Cloud 文档。
- **原文链接：**https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents ｜ https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/code-execution-overview
- **影响判断：**Google 的无网默认值强于许多“云浏览器即开即用”的产品，但不可安装库会限制动态 coding agent。OpenClaw 可把它作为高安全 code executor，同时保留 E2B/Daytona/SmolVM 等可自定义环境；路由时按网络、依赖安装、TTL 和数据驻留选择，而非只按价格。

## agent-browser（补漏）

- **本周动态：**agent-browser 在 8 月 24 日发布 `v0.35.0`，8 月 26 日发布 `v0.35.1`。v0.35.0 的核心不是普通 selector 更新，而是企业网络与身份边界：`--ca-cert <path>`、`AGENT_BROWSER_CA_CERT` 或 MCP/config 的 `caCert` 可为本地 Linux Chromium 导入 PEM/DER 私有代理 CA，放在隔离 NSS trust store 中，不会关闭 hostname、证书有效期或其他 CA 验证；相同证书在 session 中复用 Chromium，`--no-ca-cert` 可清除。它还内置 protected Vercel deployments skill，指导使用短期 Trusted Sources OIDC、授权 automation bypass 与 dashboard-only 配置的人类 handoff。v0.35.1 修复主 frame URL 流在 document/History API/fragment navigation 和 active-tab 切换后的跟踪，并在 URL 导航后使 snapshot refs 失效、每次 diff 重置 ref 编号，避免 Agent 把旧 ref 点到新页面元素；同时完善 Windows ARM64 launcher fallback。GitHub 直查搜索快照约 41.4k stars、2.7k forks。判断：agent-browser 正从“快的 Rust CLI”演进为有 session、trust store、stream、auth handoff 和 stale-ref safety 的浏览器 runtime，直接进入 Browserbase/Stagehand 所在的基础设施层。
- **关键数据：**v0.35.0（2026-08-24）、v0.35.1（2026-08-26）；约 41.4k stars / 2.7k forks（2026-08-27 GitHub 查询快照）；来源：官方 changelog、GitHub repository。
- **原文链接：**https://agent-browser.dev/changelog ｜ https://github.com/vercel-labs/agent-browser
- **影响判断：**私有 CA 与 stale-ref invalidation 都是生产 Agent 浏览器的硬需求，前者决定企业代理可用性，后者决定错误点击风险。OpenClaw 当前 browser skill 应优先吸收这两类 capability，并把 CA、session pinning、ref generation 和 URL generation 纳入审计记录。
# 研究线 B｜模块 3 深度笔记（三）：SmolVM + TOP5 候选

## SmolVM（smol-machines/smolvm，补漏）

- **本周动态：**SmolVM 在本周形成罕见的高频 release 串，并于 8 月 26 日发布 `v1.13.0`。窗口内版本链把它从便携 microVM CLI 推向 agent sandbox substrate：`v1.10.x` 加入 S3/任意 rclone remote volumes、Windows 10/WHP 修复、VPN/TUN 所需 guest IPv4/IPv6 policy routing；`v1.11.x` 把 remote volume 贯通 ephemeral run、embedded spec 和 API exec；`v1.12.0` 加入 opt-in virtio-gpu scanout、host-side VNC、virtio-input，使 VM 能跑交互 Linux desktop，同时 harden forked workload 与 transactional batch fork；`v1.13.0` 给 desktop recipe 的 guest Chromium wrapper 打开 software WebGL，支持 nested machine checkpoints，修正 default local egress 对 host loopback 的暴露，增加 `SECURITY.md`，并修复损坏 image archive cache 与旧 pack layer 解包。仓库自述每 workload 独立 guest kernel，基于 macOS Hypervisor.framework、Linux KVM、Windows WHP + libkrun，默认网络关闭，支持 host allowlist，宣称冷启动 `<200ms`；但也坦承本地 CLI/VMM、宿主 OS 与 hypervisor 都属于 TCB，release 目前没有签名或 provenance attestation。GitHub 直查搜索快照约 5.8k stars、273 forks。技术判断：SmolVM 把 checkpoint/fork、desktop/browser、远程存储与跨平台 VM 打成一个轻量本地原语，对 E2B/Daytona 的差异是可嵌入、可离线和硬件隔离；商业短板是多租户控制面与供应链签名仍不成熟。
- **关键数据：**`v1.13.0` 发布 2026-08-26；约 5.8k stars / 273 forks（2026-08-27 查询快照）；官方自述 cold boot `<200ms`，默认 4 vCPU/8GiB 弹性内存；来源：GitHub releases/repository。
- **原文链接：**https://github.com/smol-machines/smolvm/releases/tag/v1.13.0 ｜ https://github.com/smol-machines/smolvm/releases ｜ https://github.com/smol-machines/smolvm
- **影响判断：**Nested checkpoint、batch fork 与 desktop/VNC 的组合很适合“先准备黄金环境，再分叉多个 Agent 尝试”的并行搜索/编码。OpenClaw 可以把 SmolVM 作为本地高隔离 sandbox provider 候选，但接入前必须补 release checksum 强制、镜像 provenance、host mount/SSH-agent 权限提示和并发资源配额。

## Browser4 补漏结论
- 热扫只确认其约 1.1k stars 且最后更新时间落在 8 月 19 日（窗口外），后续未核到 8 月 20—26 的官方 release/基础设施级公告，因此本期不深写、不用旧活动充数。

## 研究线 B 提交给主编的 TOP5 候选建议

1. **Microsoft Hosted Agents 旧 backend 于 8 月 20 日强制退场**：Runtime ABI 从框架 adapter 改为 session sandbox + durable filesystem + per-agent Entra identity + 多协议 endpoint，迁移影响明确且基础设施信号最强。
2. **Anthropic Computer/Browser toolset 跨到 Google Cloud**：版本化工具 ABI 在多云使用相同 `tools` entry，可能成为 CUA 执行器与模型之间的事实接口层。
3. **OpenClaw 2026.8.1-beta.2/3 状态可靠性升级**：SQLite WAL/backup/restore、session 隔离、Gateway reconnect、cron lifecycle 同周收敛，显示 Agent OS 的核心竞争已经进入 durable runtime。
4. **SmolVM 一周内推进 desktop/VNC + fork/checkpoint + remote volumes**：开源本地硬件隔离 sandbox 正追近商业云的 Agent workload 需求，且带来 OpenClaw 本地执行机会。
5. **OpenAI Assistants API 8 月 26 日关闭**：Code Interpreter 从旧 thread/run 状态机迁入 Responses，生态必须重新验证 session、文件、计费与 tracing 语义；代表工具执行 API 的平台收敛。

### 备选
- agent-browser v0.35.x（企业私有 CA + stale ref/stream safety）可在文章更偏 browser runtime 时替代第 5；Google Managed Agents/Code Execution 双层 sandbox 可在文章更偏云平台矩阵时进入 TOP5。
## 模块4：Tool Gateway / Protocol / Integration（分片 001）

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）
- 本分片对象：MCP

### 深度笔记

#### MCP：新路线图把协议从“工具调用格式”推进到异步消息、工作负载身份与渐进式发现
- **本周动态**：MCP Core Maintainers 于本期发布新版路线图，官方 Roadmap 页面标记最后更新为 **2026-08-22**。路线图明确了未来 6—12 个月五个优先区：Agentic Messaging Primitives、HTTP-Native Transport Unification and Hardening、Agent Identity and Enterprise-Ready Security、Improved Primitives、Improved SDK Developer Experience。具体而言，Tasks、`subscriptions/listen`、progress notifications 将接受组合性审查，并补 server-initiated events/webhooks，目标是让分钟级任务、流式结果与中途 steering 不再依赖客户端轮询；transport 计划探索 HTTP/2 over stdio，使本地与远程服务器尽量共享 Streamable HTTP 模型；缓存将从 `ttlMs`/`cacheScope` 延展至 ETag；身份方向将以 DPoP、Workload Identity Federation、ID-JAG 和 RFC 8693 token exchange 处理 agent 自身身份、用户委托与子 agent 权限收窄；工具层则拟重塑 `tools/call` 的 `content` / `structuredContent` 契约，并启动 progressive discovery，避免连接百工具服务器时一开始就把全部 catalog 塞进模型上下文。官方博客同时复盘 2026-07-28 版已经去除协议级 session 与初始化握手，加入 `server/discover`、可缓存 list result，并把 Tasks 转成正式 extension。技术路线很清楚：MCP 不再满足于“统一 function calling schema”，而是在吸收 HTTP 运维、异步作业、服务发现、工作负载身份和大型目录治理，向真正的 agent-to-tool control protocol 演化。
- **关键数据**：Roadmap 最后更新 2026-08-22；规划期 6—12 个月；5 个优先区；既有基础来自 2026-07-28 specification release。来源：官方 Roadmap 与官方博客（本期 web_fetch 全文）。
- **原文链接**：https://modelcontextprotocol.io/development/roadmap ；https://blog.modelcontextprotocol.io/posts/mcp-roadmap/
- **影响判断**：MCP 的竞争边界正在越过工具描述，直接进入 durable task、event delivery、agent identity 与 gateway catalog governance；这也缩小了它与 A2A 在“长任务消息”层的功能间距。对 OpenClaw，最值得跟进的是 progressive discovery、Tasks/事件组合以及 workload identity/delegation：前者可降低 tool schema 上下文税，后两者可把 Gateway 的长任务与代理授权从实现约定升级为协议兼容层。
## 模块4：Tool Gateway / Protocol / Integration（分片 002）

- 时间窗：2026-08-20—2026-08-26（Asia/Shanghai）
- 本分片对象：A2A

### 静默背景

#### A2A
- **本周状态：静默**。检索 A2A 官方站、Google Developers Blog 与 `a2aproject/A2A` 官方 releases，未发现时间窗内新的 specification release 或官方重大公告。GitHub Releases 页面显示最新协议 tag 仍为 **v1.0.1（2026-05-26）**，仅修复 HTTP binding 优先使用 `application/a2a+json`、transcoding error 与 TaskStatus 值；v1.0.0 发布于 2026-03-12。因此不得把 8 月 17 日 Google “zero-trust AI agents”文章或 8 月 5 日 Langflow A2A 支持写成本周 A2A 协议动态。
- **最近背景（非本周）**：A2A v1.0 已把应用协议定义与 transport mapping 分离，加入 `tasks/list` 的过滤/分页、gRPC 原生多租户 scope，并把 OAuth 2.0 流程现代化为 device code / PKCE，说明 A2A 的重心是跨 agent 的 task lifecycle、发现与互操作，而不是工具目录调用。
- **证据源**：https://github.com/a2aproject/A2A/releases （官方 releases，全页 web_fetch，2026-08-27 查）；https://a2a-protocol.org/latest/community/ （官方社区入口）。
- **竞争判断**：本周 MCP 路线图把 Tasks、server-initiated events、streaming 与 steering 推上优先级，开始侵入 A2A 擅长的异步 agent communication 区域。两协议短期仍互补——MCP 偏 agent-to-tool/context，A2A 偏 opaque agent-to-agent task——但 gateway 产品会越来越需要双协议路由、统一 identity 和 trace，而不能只做 MCP proxy。
## 模块4：Tool Gateway / Protocol / Integration（分片 003）

- 时间窗：2026-08-20—2026-08-26（Asia/Shanghai）
- 本分片对象：Composio、Arcade

### 静默背景

#### Composio
- **本周状态：静默**。官方站搜索命中的最近一篇工具层文章《AI agent observability for the tool layer》发布日期为 **2026-08-19**，比窗口早一天；官方 GitHub Releases 页面也未能确认窗口内有基础设施级正式 release，因此不把它写成本周动态。
- **最近背景（非本周）**：该文把 tool gateway 的价值从“连接 API”提升到 execution boundary observability：日志至少记录 HTTP status、timestamp、user identity、connected-account ID、success/denied/error/timeout；凭据在隔离 runtime 内解密注入，不进入 LLM context；denied call 以一等事件进入 audit trail；SCIM 2.0 可把 Okta/Entra/Google Workspace 目录组映射到团队。官方披露平台月处理 **3 亿+ tool calls、覆盖 1,000+ apps**，Enterprise metadata TTL 可配 **7 天至 1 年**，并支持 self-hosting。虽然是窗外背景，但它说明 managed integration 平台竞争点已经从 connector 数量迁移到 identity-anchored audit、policy enforcement 与 credential isolation。
- **证据源**：https://composio.dev/content/ai-agent-observability-tool-layer （官方全文，发布日期 2026-08-19）；https://github.com/ComposioHQ/composio/releases （官方 releases，2026-08-27 查）。

#### Arcade
- **本周状态：静默**。检索 Arcade 官方文档、博客入口与 `ArcadeAI/arcade-mcp` Releases；后者明确显示暂无 releases，未确认 2026-08-20~26 有新的正式版本或官方重大公告。热扫所述“per-action authorization”未找到时间窗内 Arcade 官方原文，不能作为本周事实。
- **最近背景（非本周）**：Arcade 文档持续提供带用户授权的自定义 MCP tools、auth provider 与 OAuth 接入，产品边界聚焦“tool execution + user auth”。这类 runtime 的差异化不在 MCP transport 本身，而在凭据托管、用户级 consent、调用级 policy 和审计是否落在执行路径；这也是其与 Composio、Nango 的主要交叉地带。
- **证据源**：https://docs.arcade.dev/en/build/create-tools/tool-basics/create-tool-auth ；https://github.com/ArcadeAI/arcade-mcp/releases 。
- **OpenClaw参照**：OpenClaw Gateway 若接第三方 connector，不能只记录 tool name/result；至少应把会话、发起用户/agent、credential reference、上游 HTTP outcome、policy decision 关联起来，并把凭据严格隔离于模型上下文与记忆层。
## 模块4：Tool Gateway / Protocol / Integration（分片 004）

- 时间窗：2026-08-20—2026-08-26（Asia/Shanghai）
- 本分片对象：Nango、Pipedream Connect

### 深度笔记

#### Nango：把“工具网关”扩成 auth + tool calls + durable sync + trigger 的统一 integration runtime
- **本周动态**：Nango 于 **2026-08-20** 发布官方比较文章，重点并非单一版本发布，而是公开了一套更完整的 agent integration 产品边界：每个客户的集成需要完成四件事——用户认证、暴露 tool calls、持续同步 RAG 数据、响应上游变化。Nango 声称其代码优先平台覆盖 **900+ APIs、6,000+ pre-built tools**，自定义 tools、durable syncs 与 webhooks 跑在同一 runtime；工具可以经 MCP 或 REST 暴露。官方示例使用 Streamable HTTP 连接 `https://api.nango.dev/mcp`，后端传 Nango secret key、`connection-id` 与 `provider-config-key`，runtime 再挂载对应客户凭据，模型不接触 provider token。同步层支持每页保存 checkpoint、失败后续跑、full/incremental 两类 deletion detection，最快 **30 秒**调度，并辅以 provider webhook 与 polling trigger；每次执行在隔离 Lambda 环境，官方称 action execution latency **<50ms**，并提供 structured logs、OpenTelemetry export、自托管与 BYOC。文章还提出 function builder skill：coding agent 读取 API 文档、写 integration、在真实 connection 上运行并根据 API error 修复后再部署。路线判断上，Nango 正把 MCP endpoint 降为接口之一，把竞争护城河放在 per-user credential、同步状态、事件、可编辑代码与部署闭环——这是比“连接器目录”更厚的 integration runtime。
- **关键数据**：文章发布日期 2026-08-20；900+ APIs；6,000+ tools；sync 最快 30 秒；action execution latency 官方称 <50ms。来源均为 Nango 官方文章及其所链官方文档，2026-08-27 web_fetch 全文核验。
- **原文链接**：https://nango.dev/blog/best-embedded-integrations-platform-for-ai-agents/ 
- **影响判断**：这给工具层增加了常被忽略的“读侧”：实时 tool call 适合动作与小查询，但大范围 RAG 依赖有 checkpoint、重试、删除传播和权限保存的 durable sync。对 OpenClaw，Tool Gateway 若只支持 MCP call，仍缺 connector state 与 freshness；可优先把 Nango 一类服务作为外接 integration substrate，而不必自行维护数百 OAuth 变体。

#### Pipedream Connect：本周由 Nango 官方竞品研究提供可核验侧写，未见自身重大发布
- **本周状态：弱动态/侧写，不作为独立发布**。同一篇 Nango 文章基于截至 2026 年 8 月的官方文档对比 Pipedream Connect：其公开目录为 **3,000+ APIs、10,000+ tools**，具 MCP server、embeddable auth、Connect API proxy，可用平台 OAuth client 或自有 client，并能以 Node.js 写私有 custom component；但 RAG sync 需要开发者用 workflow 自组，而非原生 managed sync primitive，且 embedded agent 调用时后端需为 action 的 `configuredProps` 自行供值。Pipedream 本周未检出自身官方重大公告，因此这些数据只作当前能力背景，不标成新品。
- **原文链接**：https://nango.dev/blog/best-embedded-integrations-platform-for-ai-agents/ （竞品官方的可核验对比，非 Pipedream 一手发布）
- **竞争判断**：Pipedream 以最大目录、proxy 与 workflow 见长，Nango 则用 durable sync、代码可编辑、自托管/BYOC 与 coding-agent build loop 做差异化；二者表明 integration 平台已分化为“广覆盖动作市场”与“可治理数据/动作 runtime”两条路线。
## 模块4：Tool Gateway / Protocol / Integration（分片 005）

- 时间窗：2026-08-20—2026-08-26（Asia/Shanghai）
- 本分片对象：AWS AgentCore Gateway

### 深度笔记

#### AWS AgentCore Gateway：与 JFrog 打通 OBO 身份传播，证明 gateway 的核心是“第二跳”授权
- **本周动态**：JFrog 于 **2026-08-21** 发布由 JFrog 与 AWS 架构师共同撰写的完整方案，演示将 JFrog Artifactory MCP server 注册为 Amazon Bedrock AgentCore Gateway target，并通过 AgentCore Identity 执行 **OAuth 2.0 Token Exchange（RFC 8693）**。Agent 以用户 JWT 调 Gateway；Gateway 验证入站 token，再将其交换为 JFrog 签发的短期 token，使下游调用仍以登录用户身份记账，而不是共享 service account。文章把 Gateway 定义为单一 managed MCP endpoint，可聚合 Lambda、OpenAPI/Smithy API、其他 MCP server，并提供 tool creation、tool search、inbound/outbound auth、CloudWatch observability。官方方案比较三种“第二跳”身份方法：header whitelisting 只有在目标可信任且链路防伪时才成立；three-legged OAuth 可保留用户身份但要求第二次登录；OBO 无第二次登录且适配 token-based target，但双方必须预设 trust。配置层面，AgentCore credential provider 指定 `TOKEN_EXCHANGE`，target 使用 `listingMode: DYNAMIC`，让工具发现也携带用户 token，而非复用可能越权的 cached tool list。文章特别警告：若省略 `onBehalfOfTokenExchangeConfig`，创建阶段不报错，却会在每次 tool call 时表现为通用 internal error；JFrog 侧还要求 access token 包含可映射的简单 claim，URL-shaped namespaced claim 不能直接套模板。它把身份传播从架构原则落到了 gateway target 的具体字段与失败模式。
- **关键数据**：官方合作文章日期 2026-08-21；采用 RFC 8693；JFrog 前提为 EnterpriseX 或更高；示例 minted JFrog token `expires_in` 为 86,400 秒（示例配置值，不等于强制默认）。AWS 8 月 release notes 还记录 AgentCore Gateway 已具按 caller/target/tool/model 维度的 customer-configurable rate limit、Requests/Tokens/Connections 三类 metric、最具体规则优先、多个限制 AND、`rate=0` 紧急封锁与约 30 秒传播；但 release notes 未逐项标日，故这里只作当月能力背景，不把其发布日期强行归入本窗口。
- **原文链接**：https://jfrog.com/blog/amazon-bedrock-agentcore-gateway-jfrog-artifactory/ ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- **影响判断**：AgentCore 展示了云厂 gateway 的真正企业价值：协议转换只是入口，关键是入站身份验证、第二跳 credential brokerage、动态发现、policy/rate limit、审计的统一边界。对 OpenClaw，外部 MCP server 连接若降格为共享密钥，会同时丢失最小权限、用户级审计和泄露隔离；应把 on-behalf-of/token exchange 作为 Gateway 身份演进的高优先级参照，并明确缓存工具目录时的用户权限一致性。
## 模块4：Tool Gateway / Protocol / Integration（分片 006）

- 时间窗：2026-08-20—2026-08-26（Asia/Shanghai）
- 本分片对象：Google Agent Gateway、Microsoft Foundry Toolbox

### 深度笔记

#### Microsoft Foundry Toolbox：本周把自定义 Code Interpreter 纳入统一 MCP endpoint 与 Entra identity passthrough
- **本周动态**：Microsoft Learn 于 **2026-08-21** 发布、并在 **8 月 24 日**更新“Configure a custom code interpreter for agents”。该方案让 Azure Container Apps Dynamic Sessions 中的自定义 Python 环境直接暴露 MCP server，支持自选 packages、container image、compute 与 Container Apps environment；Microsoft 明确推荐将它装入 Foundry Toolbox，以统一 credential management、versioning 与 policy enforcement。示例先用 `MCPToolboxTool` 把 session-pool `mcpServerEndpoint` 加进一个版本化 toolbox，再通过固定形态的 `/toolboxes/{name}/versions/{version}/mcp?api-version=v1` 暴露 MCP-compatible endpoint。随后使用 `remote-tool` project connection 和 `user-entra-token`（audience `https://ai.azure.com`）传递调用者身份，Hosted Agent、Microsoft Agent Framework 等均可消费。重要细节是：不能误用 Dynamic Sessions 的 `poolManagementEndpoint`；工具 runtime 是 sandboxed Container Apps session；预览功能无 SLA，不建议生产。结合 Toolbox 官方架构，它把 MCP、A2A、OpenAPI、Web Search、Code Interpreter、Browser Automation、Work IQ/Fabric IQ、Skills 等装进 Build/Discover/Consume/Govern 生命周期，并以 `tool_search` / `call_tool` 两个 meta-tools 避免数百工具淹没上下文。微软下的棋不是又造一个 tool API，而是将异构工具、执行环境、identity passthrough 与策略包装为可跨 framework 复用的 MCP control plane。
- **关键数据**：文档 `ms.date` 2026-08-21，`updated_at` 2026-08-24；Azure CLI ≥2.60.0、Python ≥3.12；preview、无 SLA；Toolbox 支持 MCP/A2A/OpenAPI/Code Interpreter/Browser Automation 等，tool search 仅暴露 2 个 meta-tools。来源：Microsoft Learn 官方全文。
- **原文链接**：https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/custom-code-interpreter ；https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/toolbox-overview
- **影响判断**：Microsoft 把“tool gateway”和“sandbox resource”通过 MCP endpoint 合并治理，且明确做用户 Entra identity passthrough。对 OpenClaw，可参照 toolbox 的 version promotion、meta-tool discovery 和跨 runtime endpoint；尤其应避免每个 agent 独立保存工具密钥与 schema。

### 静默背景

#### Google Agent Gateway
- **本周状态：静默**。Google Gemini Enterprise Agent Platform 官方 release notes 在本窗口只有 **2026-08-21 Grok 4.6 Preview in Model Garden**，与 Agent Gateway 无关；没有检出 Agent Gateway 新功能。最近 gateway 相关公开更新在窗口外：2026-06-24 Model Armor for Agent Gateway GA；2026-06-29 semantic governance policy Preview；2026-08-15 policy engine Cloud Monitoring metrics Preview。因此不把后者冒充本周 gateway 发布。
- **当前能力背景（非本周）**：Google Agent Gateway 是 agent/tool traffic 的网络治理点；semantic policy 可在 runtime 拦截 tool calls，以 trusted user intent 与自然语言 business rules 做 ALLOW/DENY，并按工具/参数粒度 scope；Model Armor 覆盖 gateway 中的 prompt/response 内容安全。其差异化更像“AI-aware network/policy enforcement point”，而 Microsoft Toolbox 更像“versioned tool catalog + MCP endpoint”。
- **证据源**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes （官方全文，2026-08-27 查）。
## 模块4：Tool Gateway / Protocol / Integration（分片 007）

- 时间窗：2026-08-20—2026-08-26（Asia/Shanghai）
- 本分片对象：agentgateway、Kuadrant MCP Gateway 0.9

### 深度笔记

#### agentgateway 1.4.0：全量跟进 MCP 2026-07-28，并补企业托管授权、token exchange 与高危漏洞修复
- **本周动态**：开源项目 agentgateway 于 **2026-08-25 02:31 UTC（上海 10:31）**发布 **v1.4.0**。官方 release 宣称完整支持 MCP 2026-07-28：同时代理 stateful/stateless server、关闭 SEP-2575 stateless conformance gap、现代请求跳过 synthetic initialize、通过 MCP `_meta` 传播 trace context，并支持多 target subscriptions/listen、opaque resource URI multiplexing 与基础 MCP Apps。企业身份是本版更强信号：新增 MCP Enterprise-Managed Authorization（Cross App Access / ID-JAG），让企业 IdP 在 client 与 MCP server 间 broker access，不必每个 downstream app 再做一次用户 OAuth；后端认证可用 RFC 8693 token exchange 与 RFC 7523 JWT bearer grant，并增加 Entra ID、Descope、authentik provider 适配。standalone 模式将 LLM、MCP、generic routes、UI 统一到同一 listener/port，配置可存 SQLite 或 Postgres，并提供独立 Helm chart；Kubernetes 侧支持 Gateway API v1.6。

  安全上，本版修复 **GHSA-mvgg-jvj2-4frq，High 8.1**：stateful MCP session 可能跨 route 并覆盖 authorization policy。另一个关键修正是 policy 读取大 body 时的截断语义：1.4 中 `request.body` 一旦超过默认 **2MB** buffer 就不可用，另用 `request.truncatedBody` 明示截断，避免授权规则误以为检查了完整 body；官方仍提示压缩与截断可造成 bypass，策略必须 fail-safe。MCP guardrail 拒绝现在以 HTTP 200 + JSON-RPC error 返回，符合协议但会破坏只按 HTTP status 告警的旧客户端。
- **关键数据**：v1.4.0，2026-08-25；安全通告 CVSS/Severity 8.1 High；body 默认 buffer 2MB；Gateway API v1.6。来源：官方 GitHub Releases 页面与页面原始时间标签。
- **原文链接**：https://github.com/agentgateway/agentgateway/releases
- **影响判断**：这是本期最强独立开源 gateway 信号：标准兼容、身份 broker、policy/guardrail、trace、Kubernetes/standalone 运维同时推进。更重要的是其漏洞揭示“有状态 session 与 route auth policy 绑定”是网关特有攻击面；OpenClaw 若做多租户 MCP routing，应把 session-route-policy 不可变绑定、超大请求策略 fail-closed 与 JSON-RPC 层错误指标列入安全测试。

### 窗外强背景（不计本周动态）

#### Kuadrant MCP Gateway 0.9
- **状态：窗外背景**。官方公告日期为 **2026-08-14**，不在本期，尽管热扫命中，必须排除出“本周动态”。0.9 仍值得作为竞品基线：router 对每次 `tools/call` 发结构化 audit log，带 JWT `sub`、tool/server、status、request/session ID，且 early rejection 也落账；这样补足 Envoy/Istio 只能看到 HTTP path/status、看不到 JSON-RPC method/tool 的盲区。它继续 alpha 级 2026 stateless protocol，支持 streamed request body、按版本 ProtocolHandler、cache-scope metadata；并加入 graceful SIGTERM、CA cert 校验、registration prefix uniqueness 与 pinned GitHub Actions。项目仍为 tech preview。
- **原文链接**：https://kuadrant.io/blog/mcp-gateway-0.9/ （官方，2026-08-14）；https://github.com/Kuadrant/mcp-gateway/releases/tag/v0.9.0
- **判断**：agentgateway 已在本周走到全协议+EMA+token exchange，Kuadrant 0.9 则强调 Kubernetes/mesh 内 MCP-aware audit；两者共同证明通用 HTTP proxy 不足以承担 MCP governance，因为工具名、session、JSON-RPC error 与 policy context 都藏在应用层语义里。
## 模块4：Tool Gateway / Protocol / Integration（模块汇总）

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）

### 本周模块结论

- **协议与网关正在合流**：MCP 2026-08-22 新路线图把 Tasks/events、HTTP-native transport、workload identity/delegation、tool result 契约与 progressive discovery列为核心；agentgateway v1.4.0 随即把新版协议、EMA/ID-JAG、RFC 8693 token exchange、trace 和 guardrails落到可部署网关。
- **“第二跳身份”成为企业工具层胜负手**：AWS AgentCore Gateway + JFrog 的 OBO 实作与 Microsoft Toolbox 的 user Entra token passthrough都说明，仅验证 agent→gateway 不够，gateway→tool 必须保留用户身份、最小权限和可审计性。
- **Integration runtime 超越 connector catalog**：Nango 本周把 auth、MCP/REST tools、durable RAG sync、checkpoint/delete propagation、webhook/trigger、isolated execution统一起来；工具层开始覆盖“动作 + 数据新鲜度 + 身份 + 事件”。
- **安全风险转移到 session/policy 绑定与协议语义**：agentgateway 8.1 高危修复表明 stateful session 可跨 route 污染 auth policy；通用 L7 proxy又看不见 JSON-RPC 中的 tool/session/error，MCP-aware audit与 fail-safe policy成为标准件。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP | 有动态：新版路线图，2026-08-22 | https://modelcontextprotocol.io/development/roadmap | 是 |
| A2A | 静默；最新协议 release仍为 v1.0.1（2026-05-26） | https://github.com/a2aproject/A2A/releases | 否 |
| Composio | 静默；最近工具层观测文章 2026-08-19，窗外 | https://composio.dev/content/ai-agent-observability-tool-layer | 否 |
| Arcade | 静默；未核实窗口内官方发布 | https://github.com/ArcadeAI/arcade-mcp/releases | 否 |
| Nango | 有动态：2026-08-20 官方 agent/RAG integration runtime比较与能力披露 | https://nango.dev/blog/best-embedded-integrations-platform-for-ai-agents/ | 是 |
| Pipedream Connect | 弱动态/竞品侧写；无自身重大公告 | 同上（Nango官方竞品研究，非一手发布） | 否 |
| AWS AgentCore Gateway | 有动态：2026-08-21 JFrog OBO token exchange实作 | https://jfrog.com/blog/amazon-bedrock-agentcore-gateway-jfrog-artifactory/ | 是 |
| Google Agent Gateway | 静默；窗口内 release notes无 gateway更新 | https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes | 否 |
| Microsoft Foundry Toolbox/MCP endpoint | 有动态：2026-08-21/24 custom code interpreter + Toolbox MCP endpoint | https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/custom-code-interpreter | 是 |

### 补漏状态

| 对象 | 状态 | 证据源 | 处理 |
|---|---|---|---|
| agentgateway | 有动态：v1.4.0，2026-08-25 | https://github.com/agentgateway/agentgateway/releases | 深写，TOP候选 |
| Kuadrant MCP Gateway 0.9 | 窗外：2026-08-14 | https://kuadrant.io/blog/mcp-gateway-0.9/ | 仅背景，不计本周 |
| TrueFoundry MCP Gateway | 未找到足够强且可确认的本期官方发布 | — | 过滤 |
| MCPJungle / mcphub / jarvis-registry | 热扫只有更新时间/热度，未确认基础设施级 release | — | 过滤，避免以 commit噪声充新闻 |

### 静默背景摘要

- A2A 本期无协议发布；但 MCP 把异步 Tasks/events推上路线图，两者边界开始靠近。
- Composio 最近窗外信号强调 identity-anchored audit、denied-call logging与 credential isolation；Arcade继续聚焦授权工具执行。
- Google Agent Gateway本周无发布，其既有差异化仍是 semantic governance + Model Armor 的 AI-aware network policy。
- Kuadrant 0.9虽窗外，但结构化 `tools/call` audit解释了为何 Envoy/Istio HTTP telemetry不足以单独治理 MCP。

### 模块洞察

- **工具层正从“标准化工具描述”升级为“协议感知的企业执行边界”**：连接只是最低门槛，下一阶段标准件是渐进式发现、异步 task/event、用户/工作负载身份委托、第二跳 token exchange、tool-aware policy/audit、版本化目录，以及与 durable sync/trigger 的统一。

### OpenClaw 战略参照

1. **优先做 progressive tool discovery**：借鉴 MCP roadmap 与 Microsoft Toolbox 的 `tool_search`/`call_tool` meta-tool，减少工具 schema 对 context/token 的侵占并提高选择准确率。
2. **补第二跳身份委托**：参考 AgentCore OBO、agentgateway EMA/ID-JAG/RFC 8693和 Entra passthrough，避免 external MCP connector使用共享长效密钥；至少保留 user/agent/delegation chain。
3. **强化 session-route-policy 不变量**：针对 agentgateway 8.1漏洞，测试 stateful MCP session不得跨租户/route重绑定 authorization policy；大 body、压缩和 JSON-RPC HTTP 200 error均要 fail-safe并可观测。
4. **把 tool audit与模型 trace关联**：记录 session、发起身份、tool/server、credential reference、policy decision、上游 status/error，且 denied/early rejection同样落账。
5. **生态上优先集成而非复制 connector维护**：可对接 Nango/Composio/Pipedream，OpenClaw集中打造 Gateway/session/policy体验；其中 RAG freshness要求 durable sync/checkpoint/delete传播，不能靠即时 tool call替代。

### TOP候选（模块内）

1. **agentgateway v1.4.0**：本期最完整的可部署信号；新版 MCP、EMA/token exchange、trace、guardrail与高危 session/auth修复同时出现。
2. **MCP 新路线图**：决定未来 6—12个月协议重心，尤其异步事件、agent identity/delegation和 progressive discovery，格局影响最大。
3. **AWS AgentCore Gateway × JFrog OBO**：把用户身份穿透第二跳的企业授权难题做成可复现实作。
4. **Microsoft Foundry Toolbox custom Code Interpreter**：把 sandbox runtime装入版本化、可治理、跨 framework的 MCP endpoint。
5. **Nango agent/RAG integration runtime**：显示 gateway市场将向 auth + action + sync + trigger一体化延伸。

### 来源清单（本模块实际读取）

1. MCP官方 Roadmap
2. MCP官方新版路线图博客
3. A2A官方 GitHub Releases
4. Composio官方 tool-layer observability全文（窗外背景）
5. Arcade官方文档与 GitHub Releases
6. Nango官方 embedded integrations全文
7. AWS AgentCore官方 release notes
8. JFrog×AWS AgentCore Gateway联合技术全文
9. Google Gemini Enterprise Agent Platform官方 release notes
10. Microsoft Foundry custom code interpreter官方文档
11. Microsoft Foundry Toolbox官方概览
12. agentgateway官方 GitHub Releases
13. Kuadrant MCP Gateway 0.9官方博客（窗外背景）
# 研究线 C2｜模块 5：Identity / Auth / Permission（总览与云厂）

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）
- 核验原则：窗口内动态必须读官方原文；文档更新时间可作为能力在本周进入/重写公开基线的证据，但不擅自等同于产品 GA；窗口外信息只作背景。

## 本周模块结论

- **企业 Agent 授权出现两条同时收敛的标准路线。** 一条是 Claude Enterprise-managed auth（EMA）于 8 月 24 日 GA，以 Cross App Access（XAA）和 Identity Assertion JWT Authorization Grant（ID-JAG）把企业 IdP 的用户断言直接交换成 MCP access token，取消逐连接器 OAuth 同意页面；另一条是 Clerk 于 8 月 21 日发布 custom OAuth scopes，让 MCP 服务把 `messages:read`、`tools:execute` 等动作/资源权限公开到 OAuth metadata 并在 API 侧执行。前者解决集中开通与离职撤权，后者解决最小权限，但两者都不能单独替代调用级风控。
- **云厂正把“Agent 是谁”从共享 service account 提升为一等主体。** Microsoft 本周更新 Foundry Agent Identity 文档，明确 agent identity blueprint、独立 service principal、attended OBO 与 unattended client credentials；Google 本周更新 Agent Identity 基线，以每 Agent SPIFFE ID、24 小时 X.509、mTLS+DPoP 双重绑定、PAB/VPC-SC/审计构成强身份链。相比纯 OAuth token vault，这是更靠近工作负载身份的控制面。
- **token 托管正在从“安全保存”升级为“不可见、可撤销、可归因”。** Google 在 Agent Gateway 解密用户凭证、Agent 不接触 raw credential；Microsoft 由 Agent Service 自动执行 token exchange；Composio/Nango 则把 vault、refresh、失败恢复、API key scopes 与 MCP 工具权限商品化。真正的安全边界应在执行/网关层，而不是靠提示词禁止泄露。
- **本周未核出 AWS AgentCore Identity、Arcade、Pipedream 的窗口内同级身份发布。** AWS 8 月 release notes 的强权限信号偏 Gateway rate limit/Policy，不应冒充 Identity 新功能；Arcade 的 per-action authorization 文章为 6 月背景，Pipedream 本周缺少可靠官方更新。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Identity | 静默（Identity 维度）；8 月 release notes 未核到窗口内 Identity 项 | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html | 否 |
| Microsoft Entra Agent Identity / Foundry | 有动态；概念文档 `ms.date=2026-08-21`，8 月 25 日更新 | https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity | 是 |
| Google Agent Identity / Gateway / Gemini Enterprise auth | 有动态；官方页 2026-08-21 更新 | https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/agent-identity-overview | 是 |
| Arcade Auth / tool permission | 静默；per-action authorization 为 6 月背景 | https://www.arcade.dev/blog/enterprise-managed-authorization-per-action-authorization-ai-agents/ | 否 |
| Composio Auth | 有动态；窗口内发布 enterprise teams MCP auth 深度指南 | https://composio.dev/content/mcp-authentication-enterprise-teams | 是 |
| Nango OAuth / token management | 有动态；8 月 24 日 connection recovery webhook，8 月 25 日 Management MCP 扩至 14 tools 且 API-key scope 匹配 | https://nango.dev/docs/updates/changelog | 是 |
| Pipedream Connect managed auth | 静默/未核出可靠窗口内公告 | https://pipedream.com/docs/connect | 否 |

## 深度笔记

### Microsoft Entra Agent Identity / Foundry

- **本周动态：** Microsoft 于 8 月 21 日标注并在 8 月 25 日更新 Foundry Agent Identity 概念页，把 Agent 的身份模型写成可操作的企业控制面。Foundry 自动创建 `agent identity blueprint` 与 agent identity；前者是某一类 Agent 的治理模板，可统一套 Conditional Access、撤销同类 Agent、管理生命周期，后者是在 Entra 中代表运行实例的专门 service principal。工具调用时，Agent Service 先用 blueprint 凭据向 Entra 证明托管服务有权代表该类 Agent，再为特定 agent identity 取得 token，最后按下游 audience（如 Storage、Graph、Key Vault）交换 scoped access token，并把它交给 MCP server 或 A2A endpoint。开发者不接触 token。文档区分 attended 模式（OAuth 2.0 OBO，权限受用户授权和用户自身权限双重约束）与 unattended 模式（client credentials，完全由 Agent 自身 RBAC/Graph app permission/策略约束）。生产发布会创建 distinct identity，获得独立权限和审计轨迹；开发阶段则共享 project identity，降低身份泛滥，但也扩大同项目横向权限面。生产推荐 blueprint 与 project managed identity 建 federated credential，不存 client secret。
- **关键数据：** 文档日期 2026-08-21、更新时间 2026-08-25；列出 5 个常用下游 audience；三类 blueprint 凭据为 client secret、X.509 certificate、federated credential。来源：官方概念页。
- **原文链接：** https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity
- **影响判断：** Microsoft 的关键领先点不是再造 OAuth，而是把“Agent 类别—Agent 实例—用户委托—下游 audience”串成 Entra 对象图，适合海量创建、销毁与审计。风险点是开发阶段共享 identity 可能掩盖单 Agent 越权，发布时还必须重配 RBAC；OpenClaw 可借鉴其蓝图/实例双层模型，但应默认区分每个 Agent、每个用户 session 与每次 tool call 的归因。

### Google Agent Identity / Gateway / Gemini Enterprise auth

- **本周动态：** Google Cloud Agent Identity 官方页于 8 月 21 日更新，公开基线比传统 service account 更强：每个 Agent 获得唯一 SPIFFE ID 与自动托管 X.509 证书，默认不可被 impersonate，也不能由开发者生成长期 service-account key。访问 Google Cloud 时，access token 绑定 Agent 的 X.509；直连 API 使用 mTLS，经 Agent Gateway 则叠加 DPoP，形成面向网关后链路的 proof-of-possession。访问第三方工具时，Agent Identity auth manager 承担集中 vault/broker，支持 3-legged OAuth（代表用户）、2-legged OAuth（Agent 自身）、API key 与不推荐的 basic auth；它自动发起用户登录/同意、持有与撤销 token。与 Gemini Enterprise connector 和 Agent Gateway 配合时，用户凭证由 auth manager 加密、只在 gateway 解密，Agent 永远看不到 raw credential。治理上同时接 IAM allow/deny、Principal Access Boundary、VPC Service Controls 与 audit logs；代用户行动时，日志同时显示 Agent 与用户身份。
- **关键数据：** 每 Agent X.509 有效期 24 小时并自动更新；身份格式为 `spiffe://TRUST_DOMAIN/resources/SERVICE/RESOURCE_PATH`；支持 4 类外部认证模型；官方页最后更新 2026-08-21。来源：Google 官方文档。
- **原文链接：** https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/agent-identity-overview
- **影响判断：** Google 把 token theft 风险从“加密存储”推进到“证书绑定、不可重放”，并把 credential exposure 从 LLM 上下文结构性移除；这比单纯 scope 控制更接近零信任 Agent runtime。OpenClaw 若只在 Gateway 保存静态 token，将在 workload identity、proof-of-possession 和 agent+user 双主体审计上落后；可以先实现短期会话凭证与网关内注入，再逐步引入 per-agent attestation。

## 云厂 Identity/Auth 列可直接引用

| 平台 | Identity / Auth（本周 C2 结论） |
|---|---|
| AWS | AgentCore Identity 提供 inbound/outbound auth 与 token vault（背景）；本周 Identity 静默。窗口内权限信号主要在 Gateway 按 JWT claim/IAM principal/tool/model 限流，不等同于身份发布。 |
| Google | 本周更新每 Agent SPIFFE/X.509 身份，mTLS+DPoP token binding；auth manager 托管 3LO/2LO/API key，Gateway 解密凭证，Agent 不见 raw token；IAM/PAB/VPC-SC/双主体审计。 |
| Microsoft | 本周明确 Agent Identity blueprint + per-agent service principal；支持用户 OBO 与 unattended client credentials，按 audience 换取 scoped token，生产 Agent 独立 RBAC 与 audit trail。 |
| 阿里云 | 本 C2 未发现窗口内独立 Agent Identity 新动态；应以现有 RAM/STS/百炼连接权限为背景，并在矩阵标“本周无身份层强信号”。 |
| 火山/字节 | 本 C2 未发现窗口内独立 Agent Identity 新动态；以现有平台账号、连接器授权为背景，细粒度 Agent 主体公开度仍弱。 |
| 腾讯云 | 本 C2 未发现窗口内独立 Agent Identity 新动态；以 CAM/临时凭证及平台授权背景填写，不宣称新发布。 |
| Databricks | 本 C2 未发现窗口内 Identity 新动态；以 Unity Catalog、service principal/OAuth 与 Agent Framework 治理背景填写。 |
# 研究线 C2｜模块 5 深写：Claude Enterprise-managed auth / XAA / ID-JAG + Clerk scopes

## 深度笔记

### Claude Enterprise-managed auth（EMA）/ XAA / ID-JAG

- **本周动态：** Anthropic 于 2026-08-24 将 Claude MCP connector 的 enterprise-managed auth（EMA）推至 GA。窗口内可读到的 WorkOS 官方实现解读给出了完整协议链：Claude Team/Enterprise 管理员在 IdP 集中配置连接器后，终端用户不再逐个完成浏览器 OAuth 跳转与 consent；Claude 在用户 SSO 时取得企业 IdP 签发的 Identity Assertion JWT Authorization Grant（ID-JAG），再把 assertion 以 `urn:ietf:params:oauth:grant-type:jwt-bearer` 发送到 MCP server 的 token endpoint，换取 scoped access token。该模式属于 Cross App Access（XAA）：它把“允许哪个企业应用代表哪个员工访问什么 MCP resource”的决策前移到 IdP 管理面。GA 首发 IdP 为 Okta；连接器覆盖新增 Datadog、Notion、Slack，并延续 Asana、Atlassian、Canva、Figma、Granola、Linear、Supabase等，Claude chat、Claude Code、Cowork 一致可用。WorkOS 引述 Ramp：2,000 名员工可在首日经 Okta 自动开通而无需额外授权步骤。
- **实现细节与边界：** MCP authorization server 必须在 RFC 8414 metadata 的 `grant_types_supported` 公告 JWT bearer grant，并预先认可固定 `client_id`；EMA 不支持 DCR，因为 IdP assertion 已写入固定 client ID，运行时动态注册的 ID 无法匹配。token 请求可带 RFC 8707 `resource` 绑定 MCP URL；服务端必须维护 per-tenant trusted issuer allowlist，不能因为 JWT 签名有效就接受任意企业 IdP。原 consent 页收集的 workspace、account、scope 决策必须迁移到 claims mapping；用户映射应优先稳定 `sub`，对存量账户才回退 email，否则可能静默生成重复身份。authless MCP server 不返回 401，无法触发 assertion exchange，因此不适用。由于 Claude 可用 IdP refresh token 静默取得新 assertion，MCP access token 可以采用更短寿命，降低离职用户持有旧 token 的窗口。
- **安全判断：** EMA 显著减少 PAT 分发、共享 token、逐用户 OAuth 批准与离职撤权遗漏，但它主要解决**连接器级、企业集中授权**，并不自动解决 prompt injection 驱动的危险 tool call。若 scope/claim 过宽，一个“已被允许连接”的 Agent 仍可能删除资源或跨 workspace 操作；还需每次调用的 action/resource policy、风险操作 step-up/HITL、deny log 和 payload redaction。ID-JAG 同时带来新的配置风险：issuer allowlist、audience/resource 校验或 `sub` 映射错误，会造成跨租户接受、token 重放或身份错绑。
- **关键数据：** GA 日期 2026-08-24；首发 1 个 IdP（Okta）；GA 新增 3 个 connector（Datadog、Notion、Slack）；案例规模 2,000 employees；token endpoint grant 为 `urn:ietf:params:oauth:grant-type:jwt-bearer`。来源：WorkOS 官方博客（2026-08-26 页面，明确引用 Anthropic 8 月 24 日 GA）。
- **原文链接：** https://workos.com/blog/enterprise-managed-auth-ga-mcp-server-builders
- **影响判断：** XAA/ID-JAG 可能成为企业 MCP 的“silent SSO delegation”层，和标准互动式 OAuth 并存。MCP server 厂商若只实现 DCR+authorization_code，将无法进入大规模企业自动开通路径；但若只实现 EMA 而无调用级授权，则只是把宽权限更快铺到更多员工。OpenClaw 应优先支持 JWT bearer/ID-JAG-compatible broker、固定 client identity、issuer allowlist、resource/audience binding，并把 enterprise connector policy 与 per-action permission 分层。

### Clerk custom OAuth scopes

- **本周动态：** Clerk 于 2026-08-21发布 custom OAuth scopes，明确把能力对准 MCP client 访问 API 的细粒度授权。开发者可在 Clerk Dashboard 定义与 API action/resource 对应的 scope，例如 `messages:read`、`tools:execute`、`resources/files:read`、`mcp_all`；再按 OAuth application 只授予所需 scope。同时，Clerk 把“哪些 scope 允许分配”和“哪些 scope 在 OAuth metadata 中对 MCP client 可发现”分开配置。API 端仍需验证 Clerk access token 并显式检查 granted scopes；发布本身不会自动替业务代码执行授权。
- **安全判断：** 这项更新补上许多 MCP 实现的核心缺口：只要 bearer token 有效就放行全部 tools。把 tool/resource 映射到 scope，可在 discovery、consent、token 与执行检查之间建立一致契约，也便于最小权限和审计。但 scope 是静态粗粒度声明，不应被误解成完整 policy engine：`tools:execute` 仍过宽，不能表达“仅允许 Slack `post_message`、禁止 `delete_channel`”“金额低于 1,000 美元”“仅允许当前 workspace”等属性/上下文条件。示例中的 `mcp_all` 更应视为兼容性逃生口，不宜默认授予；否则会重建全能 token。服务端必须 fail closed，拒绝 token 中缺失或未知 scope，并记录 denied calls。
- **关键数据：** 发布日期 2026-08-21；官方给出 4 个 scope 示例；配置入口为 OAuth applications 的 Scopes tab。来源：Clerk 官方 changelog。
- **原文链接：** https://clerk.com/changelog/2026-08-21-custom-oauth-scopes
- **影响判断：** Clerk 把 MCP Auth 从“登录成功”推进到“工具能力可声明、可发现、可校验”，对 Auth0/WorkOS/Descope 等身份平台形成产品压力。OpenClaw 的 tool manifest 可引入标准 scope 字段，并让 Gateway 在 tool call 前强制校验；随后再叠加 ABAC/ReBAC、HITL 与临时授权，避免 scope explosion 或全能 scope。

## 两条路线的互补关系

| 层次 | Claude EMA / XAA / ID-JAG | Clerk custom scopes | 仍需补齐 |
|---|---|---|---|
| 谁授权 | 企业管理员通过 IdP 集中开通 | OAuth app 被配置/获授 scope | 最终用户意图与高风险动作确认 |
| 谁行动 | ID-JAG claims 绑定员工与 tenant | access token scopes 约束能力 | Agent 本体 identity、session、调用来源 |
| token | assertion 换短期 access token；可无浏览器交互 | OAuth access token，API 自行验 scope | token proof-of-possession、泄露检测、轮换 |
| MCP | enterprise connector silent auth | metadata 可发现 scopes | per-tool/per-resource runtime policy |
| 审计 | IdP/issuer/subject 可归因 | granted scope 可记录 | denied call、参数与结果 redaction、全链 trace |

## OpenClaw 参照

1. **身份三元组：** 每次工具调用同时绑定 `human_user + agent_instance + client/application`，而不是只记录 Telegram/Slack 用户或一个共享 Gateway token。
2. **两阶段授权：** 连接器接入阶段支持 OAuth/OIDC、EMA/XAA/ID-JAG 等企业批量开通；执行阶段由 Gateway 根据 tool、action、resource、tenant、risk 重新授权，不能把 connector connected 当成所有动作获批。
3. **凭证不可见：** refresh/access token 只存于 Gateway credential broker，并在 outbound request 最后一跳注入；不得进入 prompt、tool args、session transcript、trace 或模型可读 error。
4. **默认最小 scope：** skills/plugins 声明所需 scopes；安装时可见、调用时校验；禁止默认 `mcp_all`/wildcard，危险 scope 需显式批准与短 TTL。
5. **审计与撤销：** 记录 allow/deny、用户、Agent、客户端、tool、resource、scope、policy version；支持按用户、Agent、connector、tenant 即时撤销，并让长任务下一次 tool call 失效而非等 session 结束。
# 研究线 C2｜模块 5 深写：Composio 与 Nango

## 深度笔记

### Composio Auth

- **本周动态：** Composio 在窗口内发布面向 enterprise teams 的 MCP authentication 深度指南，把其 managed auth 产品边界描述为“每用户身份映射 + encrypted vault + runtime token injection + action policy + 审计/撤销”。官方强调 MCP OAuth 2.1 transport authorization 本身不负责生产级多租户 identity mapping 和 credential lifecycle：落地仍需把 SSO（Okta/Entra/Google Workspace，经 SAML/OIDC）用户映射到独立 connected accounts；由 Composio auth gateway 验 IdP token，再在请求路径解析对应用户凭据。token 在 AES-256 encrypted vault 中按租户/用户隔离，仅在 isolated runtime 内解密并注入上游 HTTP 请求，不进入 Agent application code 或 LLM context。Composio 宣称 action-level restrictions 会在模型参与前执行，例如允许 Slack `post_message` 但阻止 `delete_channel`，并记录成功与 denied calls 的 user/team/tool/action/outcome。SCIM 2.0 负责入离职：用户停用触发 connected account 撤销与 active session 终止。
- **关键数据：** 1,000+ integrations；AES-256 vault；SOC 2 Type II、ISO/IEC 27001:2022；官方案例称 11x 在 Outlook、Salesforce、People Data Labs、Calendly 集成上节省约 380 engineering hours，并关联 $4.2M enterprise deals（均为供应商自报，应在成文时标注）。来源：Composio 官方文章。
- **原文链接：** https://composio.dev/content/mcp-authentication-enterprise-teams
- **影响判断：** Composio 的强点是把“token 不见模型”做成架构属性，而非提示词承诺，并把 denied audit、SCIM 与 action policy接入连接器目录；这直接瞄准 Agent 越权和 token 泄露两类生产事故。弱点是文章带明显营销属性，诸如“每次工具调用完整记录/instant revoke”仍需客户在实际套餐、retention、self-hosting 边界中核验。OpenClaw 可接 Composio 作为外部 credential broker，但不能把全局安全交给单一 SaaS，应保留本地 tool policy、最小化返回 payload 和独立审计。

### Nango OAuth / token management

- **本周动态：** Nango 于 8 月 24 日补上 OAuth connection refresh 的恢复闭环：此前 refresh 失败会发送 webhook；由于失败可能瞬态且 Nango 会继续重试，现在一旦在此前失败后恢复，会再发 `"success": true` webhook，使平台能自动清除异常标记。对长期运行 Agent 来说，这比“失败一次即永久降级”更贴近真实 token lifecycle，但也要求消费者不要因恢复 webhook 放弃对异常频率和潜在 token 撤销的调查。8 月 25 日，Nango 将 Management MCP server 从日志工具扩至 14 个工具，覆盖 integration create/update/delete、connection 查询、connect-session 创建、authenticated proxy request、functions 与 docs；除 docs 外，每个工具都要求匹配 API key scope。这既是工具层发布，也是明确的权限边界：管理面 MCP 可执行删除 integration 与代凭据调用外部 API，scope 配错会把 Nango 自身变成高价值横向移动入口。
- **账户控制面补充：** 8 月 21 日新增 account-level APIs，可由代码创建/删除 environment 与 Environment API keys，并引入 account-scoped API key；8 月 20 日要求已启用 2FA 的账户在修改/重置密码时再次输入 TOTP。这组更新共同表明 Nango 在从 OAuth library 演进为可由 Agent 操作的 integration control plane，因此 API key 的 scope、环境隔离与高风险工具确认比单纯 token refresh 更重要。
- **关键数据：** 8 月 25 日 Management MCP 共 14 tools；8 月 24 日新增 recovery webhook `success:true`；8 月 21 日新增 2 类 account-level 能力（environment management、account API keys）；8 月 20 日 password change/reset 增加 TOTP。来源：Nango 官方 changelog。
- **原文链接：** https://nango.dev/docs/updates/changelog
- **影响判断：** Nango 本周展示了 token 托管最容易被忽略的一面：可观测的 refresh failure/recovery 与管理面权限。Management MCP 让 Agent 能自助修复 integration，但 `integrations_delete`、`proxy_request` 等不宜仅靠长期 API key scope；建议叠加短期 token、per-tool allowlist、参数策略、HITL 与 audit。OpenClaw 若接入 Nango，应该使用最小环境 key，把只读诊断与变更/删除拆成不同凭据，并对 recovery webhook 做幂等状态机。

## 静默对象与竞争判断

- **AWS AgentCore Identity：** 本周未核到 Identity 独立发布。8 月 release notes 的 Gateway configurable rate limits 可按 JWT `sub`、IAM source identity、target、tool、model 限流，并支持 rate=0 emergency block，但这是流量/隔离策略，不应误报为 Identity 新功能。背景能力包括 OAuth、API key、outbound credential provider 与 CloudTrail/KMS 等。
- **Arcade Auth：** 本周无重大公开动态。6 月背景文章已经明确 EMA/client credentials 属 connection-level，仍需 per-action、来源感知授权；该判断与本周 Claude EMA GA 形成重要补充，但发布日期不在本周。
- **Pipedream Connect managed auth：** 本周未从官方 changelog/文档核出同级发布；保留其 managed auth/connect token 背景，不用社区问答凑动态。

## 模块洞察

- Identity/Auth 层正在分化为四个标准件：**Agent workload identity、企业 IdP delegation、credential broker/vault、runtime action authorization**。OAuth/OIDC 只覆盖其中一部分；谁能把四层与 audit/revocation 串起来，谁才会成为企业 Agent 的真正控制面。

## TOP 候选（模块 5）

1. **Claude EMA GA / XAA / ID-JAG（强烈建议总榜 TOP 5）**：首次把企业 IdP 集中授权直接带进主流 Claude MCP connector，改变 MCP server 的 grant、client registration、claims 与 onboarding 设计。
2. **Google Agent Identity 更新（总榜候补）**：SPIFFE/X.509 + mTLS/DPoP + Gateway credential isolation，代表 Agent workload identity 的技术上限。
3. **Microsoft Foundry Agent Identity 明确化（总榜候补）**：蓝图/实例、OBO/自有权限和 per-agent audit 构成企业目录治理模板。
4. **Clerk custom OAuth scopes（模块级强候选）**：把 MCP action/resource scope 变成可配置与可发现产品能力，但仍需 runtime enforcement。
5. **Nango Management MCP scoped tools + refresh recovery（模块级候选）**：揭示 integration control plane 自身成为高权限 MCP 后的新风险与治理要求。
# 研究线 C2｜模块 5 动态池状态与安全覆盖审计

## 动态池状态表

| 对象 | 本周状态 | 判断 |
|---|---|---|
| Auth0 | 静默 | 未核到 2026-08-20~26 独立 Agent/MCP auth 产品发布；XAA 相关开发内容可作生态背景，不凑本周动态。 |
| WorkOS | 有动态（生态/实现解读） | 8 月 26 日发布 Claude EMA GA 对 MCP server 的 JWT bearer/ID-JAG 改造指南；作为 Anthropic 事件的技术交叉证据深写，不重复算两条新闻。 |
| Clerk | 有动态 | 8 月 21 日 custom OAuth scopes，明确面向 MCP clients，已深写。 |
| Descope | 静默 | 未核到窗口内明确 Agent/MCP 身份产品发布。 |
| Permit.io | 静默 | 8 月 10/11 日 MCP control-plane 治理文章在窗口外，仅作背景。 |
| Aserto | 静默 | 未核到窗口内明确 Agent/MCP permission 发布。 |

## OAuth / OIDC / MCP Auth 与风险审计

| 检查项 | 本周证据与结论 | OpenClaw 最低要求 |
|---|---|---|
| OAuth/OIDC | EMA 使用 JWT bearer assertion exchange；Microsoft 支持 OBO/client credentials；Google/Composio 支持 3LO/2LO 与 SAML/OIDC identity mapping。 | 统一 authorization broker；严格 issuer/audience/resource/PKCE/state 校验；区分用户委托与 Agent 自有权限。 |
| MCP auth | Claude EMA 取消逐用户 consent；Clerk scope 可由 metadata 发现；Nango Management MCP 以 scoped API key 控 tool。 | MCP transport auth 只作为入口；Gateway 对每次 `tools/call` 再做 action/resource policy。 |
| token 托管 | Google Gateway、Composio isolated runtime 均让 Agent/LLM 不见 raw token；Microsoft 托管交换；Nango管理 refresh/recovery。 | 密钥仅在 broker 解密、最后一跳注入；prompt、日志、trace、错误输出一律 redaction。 |
| 用户授权 | EMA 由企业管理员/IdP 集中开通；3LO仍保留用户 consent；Microsoft OBO 同时受用户许可约束。 | 审计中保留管理员 policy 与用户 delegation 两条来源；高风险动作不能因 admin 预授权而跳过用户确认。 |
| tool permission | Clerk custom scopes、Composio action policy、Nango per-tool key scope。 | tool manifest 声明最小 scope；默认 deny；wildcard scope 禁止默认；参数与资源级 ABAC。 |
| 审计 | Google 记录 agent+user；Microsoft distinct identity；Composio含 denied calls；Nango提供管理日志/MCP。 | 每条调用记录 human、agent、client、tenant、tool、resource、policy、allow/deny，敏感参数哈希/脱敏。 |
| 越权 | 风险来自 shared dev identity、过宽 `tools:execute`/`mcp_all`、管理 MCP delete/proxy、claim mapping 与跨 tenant issuer。 | per-agent/session 隔离；issuer allowlist；resource binding；危险动作 HITL/step-up；即时 revoke。 |
| 泄露 | bearer token 可被重放；Google mTLS+DPoP 给出更强范式；Composio以结构隔离 token。 | 优先短 TTL 与 proof-of-possession；检测异常重放；禁止模型读取 credential；最小化 tool result 数据。 |

## 缺口与不确定性

- Claude EMA 的直接 Anthropic公告在本轮检索中未稳定命中，GA 与协议细节以窗口内 WorkOS 官方实现解读核验；主稿若需最高等级双源，建议补抓 Anthropic connector developer docs/Claude release note。
- Composio 发布页未在正文抽取中显示明确发布日期，搜索索引显示“8 days ago”且落在窗口内；其数字/能力均为供应商自报，建议成文标注，避免把营销案例当独立验证。
- AWS 8 月 release notes 页面按月汇总但条目未逐项显示日期，故只用来判断能力存在，不把无法定位到本周的条目计作 Identity 动态。
- Pipedream、Auth0、Descope、Permit、Aserto 本轮未发现窗口内强信号；结论为“无重大公开动态”，不是断言没有任何提交或文档小改。
## 模块6 Context / Memory / Knowledge（D1恢复）

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）
- 统计口径：GitHub stars/forks 为 2026-08-27 10:18 CST 直查快照；“本周动态”只采用窗口内 commit/release/官方原文。

### 深度笔记：OpenViking

- **本周动态**：OpenViking 本周不是普通维护，而是在把“Context Database”由检索组件推向可运营的 Agent 基础设施。GitHub 窗口内提交密集；8 月 26 日提交 `b1780a4` 新增 memory extraction operation outcomes 指标，使记忆抽取成功/失败开始可计量；同日 `9952ce1` 修复 content write 时缺失文件创建，另有 parser 对空 Understanding 文件的拒绝与 resource target 语义澄清。这组变化说明其工程重点已进入写入可靠性、抽取质量与资源语义，而非只宣传 memory/RAG。仓库官方定位是 self-evolving Context Database，以统一 Agent Memory、Knowledge RAG 与 Skills 为目标；截至直查为 33,597 stars / 2,555 forks / 515 open issues，且本周持续 push，属于本模块最强开源信号。路线判断：OpenViking 正尝试用文件系统/URI 统一异质上下文，再叠加分层投递与自演进，竞争对象已不只是向量库，而是 Mem0 类记忆 API、知识库与技能目录的组合。
- **关键数据**：33,597 stars、2,555 forks、515 open issues；仓库创建 2026-01-05；本周证据提交 2026-08-26。数据源：https://api.github.com/repos/volcengine/OpenViking （2026-08-27）；https://github.com/volcengine/OpenViking/commit/b1780a4d39730b3f481599884280f840c5ab9f44 （2026-08-26）；https://github.com/volcengine/OpenViking/commit/9952ce1ec644d05a8a03b074c5089c91dff406eb （2026-08-26）。
- **原文链接**：https://github.com/volcengine/OpenViking ；https://api.github.com/repos/volcengine/OpenViking/commits?since=2026-08-19T16:00:00Z&until=2026-08-26T16:00:00Z&per_page=30
- **影响判断 / OpenClaw参照**：OpenClaw 可把 Context 层从“会话摘要+文件搜索”提升为具有统一命名、生命周期、分层加载与 extraction metrics 的独立服务；短期值得参考其 URI/文件范式和抽取结果指标，但需警惕 AGPL-3.0 的产品集成边界以及把 memory、knowledge、skill 合并后权限域被模糊。

### 深度笔记：TencentDB-Agent-Memory（热扫补入）

- **本周动态**：该仓库本周对 OpenClaw/DSH 适配出现直接而具体的修正。8 月 25 日提交 `06414ac` 在 OpenClaw 启动时记录 hook-policy 状态，把记忆注入是否受策略约束变成可观察事件；同日/26 日的 `90a3d37`、`c0cf94f` 修复 DSH runtime-context 被误写入 L0、继而污染 L1 的问题，明确把 runtime snapshot 识别为 harness metadata 而非用户消息。这不是外围宣传，而是长记忆系统最关键的“写入边界”治理：若未区分系统运行上下文与用户事实，持久记忆会发生递归污染。官方描述已从单用户 memory API 上移到 team-level memory hub，将 conversations、docs、code 变成 Chat Memory、Skill、LLM-Wiki、Code-Graph 四类可治理、共享并装备到多个 agent/framework 的资产。仓库直查 24,698 stars / 2,269 forks / 718 open issues，默认分支为 `feat/server_team`，团队级控制面意图强烈。
- **关键数据**：24,698 stars、2,269 forks、718 open issues；8 月 25—26 日有 OpenClaw hook policy、DSH runtime-context/L0 污染修复。来源：https://api.github.com/repos/TencentCloud/TencentDB-Agent-Memory （2026-08-27）；https://github.com/TencentCloud/TencentDB-Agent-Memory/commit/06414ac10766b9bd61e4a69f3cf0ea414afb6d4f （2026-08-25）；https://github.com/TencentCloud/TencentDB-Agent-Memory/commit/c0cf94f7e0e27dbb916a35d4fafb66fe4b04ed67 （2026-08-26）。
- **原文链接**：https://github.com/TencentCloud/TencentDB-Agent-Memory ；https://api.github.com/repos/TencentCloud/TencentDB-Agent-Memory/commits?since=2026-08-19T16:00:00Z&until=2026-08-26T16:00:00Z&per_page=30
- **影响判断 / OpenClaw参照**：这是对 OpenClaw 最直接的外部参照之一：memory write path 必须携带 provenance（user/system/runtime/tool）、策略状态和层级，且在 L0 入库前过滤 runtime snapshot。OpenClaw 若开放 memory provider 接口，应把 hook-policy、污染检测、可撤销写入和团队空间 ACL 设为契约，而不是交由每个插件自行约定。
### 深度笔记：Mem0

- **本周动态**：Mem0 本周的强信号是从“通用 memory API”向各 Agent Harness 的原生 MemoryStore/插件分发。官方 release 原文列出 `mem0-strands` 初版：接入 Strands Agents MemoryManager，每轮自动 recall 并注入 prompt；`add_messages()` 把原始对话交给 Mem0 服务端 extraction（`infer=True`），而 `add()` 支持 verbatim fact（`infer=False`）；命名空间必须至少提供 `user_id/agent_id/run_id/app_id` 之一，并阻止 platform-only `app_id` 与 self-hosted config 混用。另一个 `@mem0/deepseek-plugin` 初版注册 `search_memory` / `add_memory` 两个 agent-callable tools，并以 `source: DEEPSEEK_HARNESS` 记录来源；但 auto-capture/auto-recall 仍只是 developer preview。仓库本周还新增 Vercel Marketplace managed integration 页面、将 Pydantic 配置改为 `extra="forbid"`，显示托管分发和输入边界同步加强。截至 8 月 27 日直查 64,130 stars / 7,505 forks。
- **关键数据**：64,130 stars、7,505 forks、694 open issues；`search_memory` 默认 limit=10；Strands entity scope 至少 1 个；Vercel Marketplace 文档提交 2026-08-24。来源：https://api.github.com/repos/mem0ai/mem0 （2026-08-27）；https://github.com/mem0ai/mem0/releases （2026-08-27 读取）；https://github.com/mem0ai/mem0/commit/39bc02330563764e7d4465f1ecff5f002d94da1a （2026-08-24）。
- **原文链接**：https://github.com/mem0ai/mem0/releases ；https://github.com/mem0ai/mem0
- **影响判断 / OpenClaw参照**：Memory 的竞争接口正在从独立 CRUD API 迁移到 Harness lifecycle：自动召回、写入模式、scope、来源 telemetry 都要成为原生契约。OpenClaw 应区分“显式 tool recall”与“自动 prompt injection”，并为每次注入保留 memory IDs、source、scope 和撤销能力；否则便利性会放大提示词污染和跨 agent 串读风险。

### 深度笔记：Cognee

- **本周动态**：Cognee 8 月 26 日发布预发布版 `v1.5.3.dev1`，主题为 integrations、safety checks、search improvements。它新增 Linear agent integration、GitHub App organization connector，把 issue/repo/组织事件接入可持续知识图；新增 config preflight / doctor CLI，在服务启动前检查配置；默认检索切到 keyword+vector hybrid；operation records 进入 activity feed，并提供 brains-summary/dataset WebSocket。安全侧，run-subscription WebSocket 加入认证与 guard，per-plugin agent identity provisioning 为不同自动化提供独立身份/凭据，删除文档时同步清理 session info。性能侧把典型单文件 S3 ingestion 调用从约 13 次降到 4 次。值得注意的迁移风险是 Postgres graph adapter 被重写并移动至 `postgres_demo`，旧导入/配置可能破坏；MCP workspace UI 被移除。官方主页同时明确有 OpenClaw 插件，并把接口压缩为 remember/recall/forget/improve，说明 Cognee 正把知识图引擎包装成可治理、可观测的 memory platform，而非停留在 GraphRAG 工具箱。
- **关键数据**：版本 `v1.5.3.dev1`，发布日期 2026-08-26；典型 S3 calls 约 13→4；官方主页在本期热扫快照约 30.2k stars（GitHub API随后限流，精确 forks 未能同批复核，故不写精确值）。来源：https://github.com/topoteretes/cognee/releases （2026-08-26 release）；https://github.com/topoteretes/cognee （2026-08-27）。
- **原文链接**：https://github.com/topoteretes/cognee/releases ；https://github.com/topoteretes/cognee
- **影响判断 / OpenClaw参照**：Cognee 给 OpenClaw 的启发不只是图检索，而是把 plugin identity、tenant/dataset isolation、operation feed 和 authenticated subscriptions 一并做成 Memory 控制面。OpenClaw 若接入 Cognee，应优先验证默认自动反馈的成本、跨租户隔离后端组合，以及预发布版 Postgres adapter 的稳定性，不能把 demo graph backend 当生产默认。
### 深度笔记：supermemory

- **本周动态**：**本周无重大正式 release**；仓库 8 月 20、23—26 日有日常提交，但公开 commits 页未给出足以定性的基础设施级变更。必须纠正：self-hosted `0.0.8` 的 GitHub 时间为 2026-08-17 18:39Z（上海 8 月 18 日），早于窗口，不是本周发布，仅作近两周背景。该窗外版本修复从 `0.0.7-rc.x` 升到 `0.0.7` 时 migration adoption 误删 pgvector embedding columns，导致文档仍可见而旧文档检索归零；0.0.8 停止触碰这些列，启动时检测“文本尚存但向量缺失”的行并后台重嵌入，测试矩阵也用真实 vectors 验证升级存活。它说明 memory store 的升级安全、自动愈合和本地运维是关键竞争点，但不得列入本周 TOP。官方还提供 OpenClaw 插件并自报 95% Recall@15、99.4% context reduction、约 50ms profiles；均未独立复现。
- **关键数据**：29,090 stars（GitHub HTML 直查，2026-08-27）；0.0.8 发布时间 2026-08-17 18:39Z（窗外）；lite 上限 10,000 documents；自报 95% Recall@15 / 99.4% context reduction / ~50ms profile。来源：https://github.com/supermemoryai/supermemory/releases/tag/server-v0.0.8 ；https://github.com/supermemoryai/supermemory 。
- **原文链接**：https://github.com/supermemoryai/supermemory/releases ；https://github.com/supermemoryai/supermemory
- **影响判断 / OpenClaw参照**：持久记忆最危险的故障往往不是宕机，而是“数据看似存在、召回悄然归零”。OpenClaw 的 memory migration 应引入真实向量 fixture、升级前后 recall canary、backfill 进度与告警，并把供应商许可上限纳入插件启用提示；自动修复也必须可暂停、限流和审计。

### 深度笔记：Letta（当前实现为 letta-code）

- **本周动态**：旧 `letta-ai/letta` 已明确只作 landing page，当前源码转移到 `letta-ai/letta-code`；窗口内 release 链推进到 `v0.31.0`。`v0.31.1` 的时间为 2026-08-26 19:56Z，即上海 8 月 27 日 03:56，已越过窗口，只作边界外记录。与记忆知识层直接相关的变化包括：等待 MemFS sync 后再执行 memory commands，避免读到未同步状态；缩窄 memory sync skill trigger；重写 MemFS repository repair 指引；支持从 attached shared memory 加载 skills；reflection 集成前 refresh memory；修复 compaction 后 client context 恢复、自动 full-summarization fallback 保留 custom prompt；新增 scheduled staleness watcher，并在 `v0.31.1` 修复 scoped managed workloads。Letta 的架构选择与独立 memory API 不同：MemFS 用 git 追踪包括 memory blocks 在内的全部 context，agent 可重写 memory、skills、prompts，甚至通过 mods 改 harness；这把记忆变为 agent identity 和长期行为的一部分，也把版本控制、同步冲突、权限与自修改安全推到核心。
- **关键数据**：窗口内 release 至 `v0.31.0`（2026-08-26 06:50Z）；`v0.31.1` 为上海 8/27、窗外，不计本周。旧 server 最新页面所示 `0.16.7` 为 2026-03-31，**非本周**，不作为动态。来源：https://github.com/letta-ai/letta-code/releases （2026-08-27读取）；https://github.com/letta-ai/letta-code （2026-08-27）；https://github.com/letta-ai/letta （迁移说明）。
- **原文链接**：https://github.com/letta-ai/letta-code/releases ；https://github.com/letta-ai/letta-code ；https://github.com/letta-ai/letta
- **影响判断 / OpenClaw参照**：Letta 显示 Memory 与 Skills 正汇合为可版本化的 agent context filesystem。OpenClaw 若采用相似方向，应保留 git-like diff/rollback 与 memory provenance，但默认禁止 agent 无审批改写系统权限、hook 或 harness；shared memory skill 加载尤其要有签名/来源信任与租户隔离。
### 深度笔记：Zep / Graphiti

- **本周动态**：**本周无重大公开 release**。此前所见 `graphiti-core 0.29.0` 的精确 GitHub 时间为 2026-04-27，明显在窗口外，不能作为本周发布；仅作架构背景：combined node+edge extraction 用一次 LLM call 覆盖原两次结构抽取，可多 episodes batching，时间戳 `valid_at/invalid_at` 拆成独立步骤。窗口内仓库仍有 attribute-preservation 修复等日常提交，但未发现新的 release/官方基础设施公告。官方继续区分 Zep 托管 context infrastructure 与 Graphiti OSS framework：前者主打治理与低延迟，后者需自建图数据库与运维。
- **关键数据**：30,324 stars（GitHub HTML直查 2026-08-27）；0.29.0 发布时间 2026-04-27（窗外）；Zep 自报 sub-200ms。来源：https://github.com/getzep/graphiti/releases （本期 release 页面）；https://github.com/getzep/graphiti （2026-08-27）。
- **原文链接**：https://github.com/getzep/graphiti/releases ；https://github.com/getzep/graphiti
- **影响判断 / OpenClaw参照**：Agent memory 的成本瓶颈正在从 vector search 转到“每轮事实结构化所需 LLM calls”。OpenClaw 可借鉴 episode provenance、双时间 validity 和可选 combined extraction，但上线前应以冲突事实/时序问答评测质量损失；迁移时 0/1-based 改动尤其容易造成静默错配。

### 深度笔记：Firecrawl

- **本周动态**：**本周无新的正式 release**；GitHub commits 页显示 8 月 20—26 持续活跃，但没有可核验的窗口内版本公告。必须纠正：`v2.11.0` 精确发布时间是 2026-06-19，属于窗外背景，不能列本周 TOP。该版本曾把外部知识摄取推向“Context API + 治理入口”：Research Index 覆盖 300万+ arXiv papers 及关联 GitHub issues、merged PRs、READMEs并日更；官方称在 arXivQA recall 上比下一家高 18%（供应商自测）。`redactPII` 可在 scrape/batch/crawl/parse/extract 返回前移除姓名、邮箱、电话、地址、secrets；旧 `pii` format 被拒绝。`deterministicJson` 针对 schema/site 生成并缓存 extractor，重复抓取不必每次跑 LLM。Browser session 返回 `cdpUrl`，可由 Playwright/Puppeteer 接管。监控新增 goal judging、字段级 JSON diff、webhook delivery status；PDF cap 30→50MB。API 还提供 core endpoints 的 keyless access，并通过 `WWW-Authenticate: Bearer` 让 agent client 发现凭据方案。该版本也修复大量依赖安全公告、crawl/batch cancellation backlog、monitor webhook duplication 与 LLM extractor 大输入 stall。
- **关键数据**：172,849 stars（GitHub HTML直查 2026-08-27）；v2.11.0 发布时间 2026-06-19（窗外）；背景数据 Research Index 300万+ papers、daily refresh、自报 arXivQA recall +18%。来源：https://github.com/firecrawl/firecrawl/releases （v2.11.0）；https://github.com/firecrawl/firecrawl （2026-08-27）。
- **原文链接**：https://github.com/firecrawl/firecrawl/releases ；https://github.com/firecrawl/firecrawl
- **影响判断 / OpenClaw参照**：知识摄取正在变成“搜索—解析—脱敏—结构化—监控变化”的持续管线，而不只是 crawler。OpenClaw 的 web/knowledge ingestion 可借鉴 PII pre-return redaction、deterministic extractor cache、field diff 与 source provenance；但 keyless access 要有严格额度、网络出口和数据分类策略，CDP URL 更必须当高敏凭据处理。
### 深度笔记：Crawl4AI

- **本周动态**：Crawl4AI 固定对象直查显示当前最新版本为 `v0.9.2`，但其官方 release 原文明确标注 **July 2026**，在本期窗口外，因此不能把它写成本周发布。本周仓库仍有活动，但未发现窗口内新的正式 release/基础设施级公告；状态记为“静默（有日常活动）”。最近背景是 v0.9.2 修复 `MemoryAdaptiveDispatcher.run_urls_stream()` 在流被关闭/取消后任务和 browser pages 继续运行的泄漏：现在会 cancel+await 全部 in-flight tasks、drain queued URLs，并新增回归测试验证 session count 归零；另修复 Docker Monitor WebSocket 在 JWT auth 下 500、Playwright headless shell 打包、GPU Docker build。更早 v0.9.0 强调 Docker API secure-by-default。仓库页面直查快照为 79,476 stars，显示其仍是开源知识摄取的高热标准件，但本期无可深写的新发布。
- **关键数据**：79,476 stars（GitHub HTML 直查，2026-08-27）；最新 v0.9.2 为 July 2026（窗外）；本期正式 release 数 0。来源：https://github.com/unclecode/crawl4ai ；https://github.com/unclecode/crawl4ai/blob/main/docs/blog/release-v0.9.2.md 。
- **原文链接**：https://github.com/unclecode/crawl4ai/releases ；https://github.com/unclecode/crawl4ai/blob/main/docs/blog/release-v0.9.2.md
- **影响判断 / OpenClaw参照**：虽无本周强动态，但其 stream-close cleanup 对 OpenClaw 的 crawler/browser tool 很实用：取消必须传导到任务、队列、页面与 session 四层，并以“session count 回零”做确定性测试；仅关闭 async generator 并不等于资源释放。

### 补漏深度笔记：memvid

- **本周动态**：**本周无重大公开动态**。memvid `v2.0.140` 精确发布时间为 2026-05-27，属于窗外背景；该旧版本修复 sustained put+commit 导致 embedded WAL 扩容后 checksum mismatch/稀疏文件越过 EOF 的严重可靠性问题。根因是 WAL 区域右移并更新 `data_end/footer_offset` 后，`cached_payload_end` 未同步移动，`rebuild_indexes` 在旧 offset 写入、覆盖 live WAL records；修复恢复 `cached_payload_end >= wal_offset + wal_size` invariant，并增加跨多次 WAL growth 的 regression test。另修复每次 `put()` 重建 Tantivy index 时 temp working directory 泄漏（Windows 尤其明显），调整对象释放顺序以先释放 writer/handles、最后 drop TempDir。它的单文件 `.mv2`、append-only Smart Frames、time-travel/branch 模型为离线/可携带 agent memory 提供不同于服务式 DB 的路线。精确日期已复核，因此不进入本周 TOP。
- **关键数据**：16,450 stars（GitHub HTML 直查，2026-08-27）；v2.0.140 发布时间 2026-05-27（窗外）；回归覆盖 multiple WAL growth cycles。供应商另自报 0.025ms P50/0.075ms P99 与 LoCoMo +35%，未独立复现。来源：https://github.com/memvid/memvid/releases ；https://github.com/memvid/memvid 。
- **原文链接**：https://github.com/memvid/memvid/releases ；https://github.com/memvid/memvid
- **影响判断 / OpenClaw参照**：单文件 memory capsule 很适合 agent 迁移、备份、branch 与审计，但 WAL/索引一致性是硬门槛。OpenClaw 若采用 portable memory，应有 crash injection、增长边界、checksum、index rebuild 与时间旅行测试；任何供应商 benchmark 需复现实验后再作为选型依据。
### 补漏深度笔记：memsearch

- **本周动态**：Zilliz `memsearch 0.4.19` 于 8 月 23 日发布，本周正式把 DeepSeek Harness 加入跨 Agent memory。release 包含 DSH plugin 文档、read-only `.memsearch` browser、collapsible review dock、skill-candidate review UI，以及后台维护 `PROJECT.md/USER.md` 和 skill distillation；前序 0.4.18 加入 DSH auto summarize。其差异化是“Markdown source of truth + Milvus shadow index”：记忆文件人类可读、可编辑、可版本化，向量/稀疏索引可重建；跨 Claude Code、Codex、DSH、OpenClaw、OpenCode 共享。对 OpenClaw 的安装需显式开启 `allowConversationAccess` 与 `allowPromptInjection`，这也暴露了 memory 插件真实权限面。项目 2,515 stars，虽低于固定头部，但本周 release、OpenClaw适配、procedural memory（skills distillation）三项同时成立，属于强补漏。
- **关键数据**：v0.4.19 发布 2026-08-23 01:24Z；2,515 stars（GitHub HTML直查 2026-08-27）；默认 ONNX bge-m3 首次约 558MB。来源：https://github.com/zilliztech/memsearch/releases/tag/v0.4.19 ；https://github.com/zilliztech/memsearch 。
- **原文链接**：https://github.com/zilliztech/memsearch/releases ；https://github.com/zilliztech/memsearch
- **影响判断 / OpenClaw参照**：Markdown authoritative store、索引可丢弃重建是可解释性与恢复性的好基线；但自动 prompt injection 与 conversation access 必须分别授权，并提供注入预览、证据、scope、关闭开关。skill distillation 应采用候选—人工复核—安装流程，不宜让模型直接把观察提升为可执行技能。

### 补漏深度笔记：memmy-agent

- **本周动态**：Memmy 在窗口内连续发布 `v1.1.0`（8 月 25 日上海时区）与 `v1.1.1`（8 月 26 日）。v1.1.0 新增 project-scoped World Models，把 general rules/safety 与 workspace environment profile、project contract、domain knowledge 分层；Codex、Claude Code、Cursor、OpenCode、OpenClaw、DSH、Hermes 可在 session boundary 加载 scoped context，并在 compaction 后刷新。User Memory 会确认重复稳定事实、应用显式更正、避免回声式捕获，并可显示 recall evidence。长 tool turn 可中段 compaction，同时保留当前轮 tool results 与完整 transcript；加载上限从 8MB 提高至128MB。v1.1.1 进一步让 retrieval layers 可显式配置（含 bounded observation/session behavior），恢复 local embedding selection，并加入 durable project binding 的 headless Goal。其本地优先 shared memory hub 定位很强，但已同时扩展到 runtime、browser、channels，边界比纯 memory provider 更宽。
- **关键数据**：v1.1.0 2026-08-24 17:38Z（上海 8/25）；v1.1.1 2026-08-26 13:56Z（上海 8/26）；transcript limit 8MB→128MB。来源：https://github.com/MemTensor/memmy-agent/releases/tag/v1.1.0 ；https://github.com/MemTensor/memmy-agent/releases/tag/v1.1.1 。
- **原文链接**：https://github.com/MemTensor/memmy-agent/releases ；https://github.com/MemTensor/memmy-agent
- **影响判断 / OpenClaw参照**：World Model 的 rules/project/profile 分层比把所有事实塞入统一向量库更适合 OpenClaw；尤其 explicit correction、重复确认、recall evidence 值得借鉴。风险是“共享所有 agent 历史”容易跨项目泄露，必须默认按 workspace/source/user namespace 隔离，历史导入要逐源同意且可删除。

### 补漏筛选说明

- `memvid v2.0.140` 的精确 release 时间直查为 **2026-05-27**，故已从“本周强候选”降级为窗外背景，不进入TOP。
- `Acontext`：候选 URL 两种大小写均 404，未在限时降级链中找到可核验官方仓库，记“获取失败/不纳入事实”。
- `memmy-agent` 已纠正仓库为 `MemTensor/memmy-agent`；错误猜测 URL 未作为结论依据。
## 模块6 汇总结论与审计

### 本周模块结论

- **Memory 正从独立 CRUD API 变成 Harness 生命周期契约。** Mem0 在 Strands 中实现每轮自动 recall/injection、服务端 extraction、verbatim write 与 user/agent/run/app scope；Letta 将 memory、skills、prompt 放进可同步的 MemFS；memsearch 则把 Markdown 设为权威源、索引降为可重建 shadow。这一层的竞争焦点已从“能否向量检索”移到“何时写、写什么、注入什么、如何追溯和撤回”。
- **团队资产化与跨 Agent 共享是本周最强第二主线。** TencentDB-Agent-Memory 把 conversation/docs/code 组织为 Chat Memory、Skill、LLM-Wiki、Code-Graph，并直接修复 OpenClaw hook-policy 可见性和 DSH runtime snapshot 污染 L0/L1；Memmy 的 World Models 分离 general rules 与 project profile/contract/domain knowledge。共享价值上升的同时，workspace/source/user 隔离、provenance 与显式同意成为硬门槛。
- **知识图与“Context Database”正在争夺统一上层。** OpenViking 用 memory/resources/skills 统一语义并为 extraction outcomes 加指标；Cognee 以 remember/recall/forget/improve、hybrid search、operation feed、plugin identity、authenticated subscriptions 包装图/向量/会话栈。胜负不会只由召回 benchmark 决定，而由迁移安全、权限、运维、可观测与 Harness 原生集成决定。
- **外部知识摄取本周没有可核验的新正式版本。** Firecrawl、Crawl4AI 仓库活跃但最新被读到的重大 release 均在窗口外；不以旧闻凑数。近期背景仍提示 PII redaction、deterministic extraction、取消传导、持续变化监控会成为摄取层标准能力。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 / 日期 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态：密集 commits；memory extraction outcome metrics、写入/解析可靠性 | GitHub commits 2026-08-20~26；repo API 8/27 | 是 |
| Mem0 | 有动态：mem0-strands 与 DeepSeek plugin 初版；Vercel managed integration | GitHub releases 8/24；commit 8/24 | 是 |
| Cognee | 有动态：v1.5.3.dev1 pre-release | GitHub release 8/26 | 是 |
| supermemory | 静默：本周有 commits，无正式强发布；0.0.8 为 8/18 窗外 | commits 8/20,23-26；release exact date | 否（背景说明） |
| Letta | 有动态：letta-code 至 v0.31.0；MemFS/skills/reflection/compaction | releases，窗口截止 8/26 24:00 CST | 是 |
| Zep / Graphiti | 静默：本周仅维护；0.29.0 是 4/27 窗外 | commits；release exact date | 否（背景说明） |
| Firecrawl | 静默：本周 commits 活跃，v2.11.0 是 6/19 窗外 | commits 8/20-26；release exact date | 否（背景说明） |
| Crawl4AI | 静默：最新 v0.9.2 为 July 2026 窗外 | 官方 release 原文 | 否（背景说明） |

### 热扫补漏状态

| 对象 | 结论 | 证据 |
|---|---|---|
| TencentDB-Agent-Memory | 强补入；团队级资产层，OpenClaw/DSH 写入边界修复 | commits 8/25-26；24,701 stars |
| memsearch | 强补入；v0.4.19、DSH、skills-from-memory、OpenClaw | release 8/23；2,515 stars |
| memmy-agent | 强补入；v1.1.0/1.1.1、World Models、retrieval layers | releases 8/25-26 CST；1,019 stars |
| memvid | 不补入本周；v2.0.140 为 5/27 | release exact date |
| Acontext | 获取失败；猜测仓库 URL 404，未纳入事实 | GitHub 404 |

### 模块洞察

- **Context/Memory 层正在标准化“控制面”，而非标准化某一种数据库。** 权威存储可能是 Context DB、temporal graph、Markdown/git、单文件 capsule 或托管 API，但生产必需的共同契约正在收敛：来源标记、实体/项目 scope、显式/自动召回模式、写入策略、纠错/删除、版本迁移、注入证据、指标与权限隔离。

### OpenClaw 参照（优先级）

1. **P0 写入污染防线**：在 memory write 前强制 provenance=`user|assistant|system|runtime|tool`，默认排除 runtime snapshot、system prompt、tool secrets；借鉴 TencentDB 的 L0/L1 污染修复。
2. **P0 注入可观察与可撤销**：自动注入须记录 memory IDs、score、scope、provider、token cost、why-selected，并支持单次拒绝/长期删除；conversation access 与 prompt injection 分权授权。
3. **P1 分层与版本化**：把 user facts、project contract、episodic journal、procedural skills 分层；Markdown/git 可作权威可审阅源，向量/图索引作为可重建派生层。
4. **P1 迁移门控**：使用真实 vectors/graph facts fixture 做 upgrade canary，验证文档可见不等于 recall 正常；支持 backfill 进度、限流、rollback。
5. **P1 skill distillation 安全**：只生成候选，经过 review/signature 后安装；不得把记忆中的恶意指令直接提升为可执行 skill。

### TOP候选（仅模块6，按基础设施信号价值）

1. **TencentDB-Agent-Memory：写入污染与团队资产控制面**——直接触达 OpenClaw/DSH 的真实边界问题，兼具高热度与团队治理路线。
2. **Cognee v1.5.3.dev1：Memory 平台控制面**——hybrid default、operation feed、plugin identity、WebSocket auth、ingestion 13→4，信号完整但为 pre-release。
3. **Mem0 Harness-native integrations**——Strands 自动 recall/injection 与 scope 契约，显示 memory API 开始嵌进 Harness 标准接口。
4. **OpenViking extraction metrics + 写入可靠性**——Context Database 从概念走向可运营性，且 33.6k stars、活跃密集。
5. **Memmy World Models / retrieval layers**——跨 Agent shared context 分层与 evidence/correction 机制强，但项目规模仍小、需继续验证。

### 数据可信与缺口

- stars 均为 2026-08-27 GitHub repo API 或 HTML 直查快照；精确 forks 在匿名 API 限流后仅可靠取得 OpenViking 2,555、Mem0 7,505、TencentDB 2,269，其余不猜测。
- 对所有写作中引用的 release 已二次核对 exact datetime；据此将 supermemory 0.0.8、Graphiti 0.29.0、Firecrawl 2.11.0、memvid 2.0.140 降为窗外背景，并将 Letta v0.31.1 标为上海 8/27 窗外。
- Acontext 获取失败；未找到可核验官方仓库。固定对象无遗漏，静默对象均明示。
# 模块7 Observability / Eval / Guardrails（恢复 D2）— 总结与状态表

- 时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）
- 核验时间：2026-08-27 10:17 CST；星期四。

## 本周模块结论

- **最强标准信号来自 OpenTelemetry，而不是某一家观测后台。** OTel 官方已将 GenAI、Agent、MCP 语义约定迁入独立 `semantic-conventions-genai` 仓库；本周 8 月 20、21、22 日仍有提交。规范已覆盖 `create_agent`、`invoke_agent`、`invoke_workflow`、`plan`、`execute_tool`，以及 MCP client/server span、W3C Trace Context、duration metrics 和 `gen_ai.evaluation.result`。但仓库整体仍标记 **Development**，不能宣称字段已冻结或正式 release。
- **可观测正从“看 trace”进入“闭环治理”。** Coze Loop 把 sandbox-agent 单 turn 从首次调度到终态、跨重试与异步回调的端到端时间做成指标，并修复错误码与 Processing 计数；FailproofAI 则把观测直接接到 PreToolUse 阶段的 allow/deny/instruct policy。前者让 eval 运行可靠可量化，后者让治理发生在动作执行前。
- **成本/推理细粒度成为共同数据面。** Braintrust 补齐 LangChain/LangGraph reasoning token 指标，Phoenix 20.4.0 同步 LiteLLM reasoning token 费率，Langfuse 修复 OTel attribute mapping 的 prototype-chain clobbering；它们共同说明“token 总数”已不够，生产系统开始要求推理 token、缓存 token、模态 token和成本映射的一致性。
- **云厂继续收编完整质量闭环。** Microsoft Foundry 文档本周更新，形成 evaluation + monitoring + OTel tracing，且支持持续/定时评估与 scheduled red teaming；AWS 本周强调 AgentCore Policy + Bedrock Guardrails 的逐工具调用判定；Google Agent Platform 的公开面是 Trace/Logging/Monitoring + Evaluation Service/Example Store/Feedback Service。独立工具仍领先开放性，云厂领先原生身份、告警和平台内治理闭环。

## 固定对象状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| LangSmith | 静默 | 官方 Studio 文档仅检索到维护更新，无本周独立基础设施发布；https://docs.langchain.com/langsmith/studio | 否 |
| Langfuse | 有动态 | GitHub commit：OTel attribute mapping 安全修复，2026-08-26；https://github.com/langfuse/langfuse/commit/1c5df63be9c5bbe6e36bd02628c538b0793bdfa9 | 是 |
| Helicone | 弱动态 | GitHub commit：pass-through billing 显式 allowlist，2026-08-25；https://github.com/Helicone/helicone/commit/4b81bc714b1a7432c01620890dafc4b0f93a3660 | 否 |
| AgentOps | 静默 | GitHub commits API 本窗返回空数组；https://api.github.com/repos/AgentOps-AI/agentops/commits?since=2026-08-19T16:00:00Z&until=2026-08-26T16:00:00Z | 否 |
| Braintrust | 有动态 | reasoning token metric、AI SDK generateImage instrumentation，2026-08-24/26；https://github.com/braintrustdata/braintrust-sdk-javascript/commit/a47a41ef71d4f6b5639e9878dbed81ead0cb7c4a | 是 |
| Arize Phoenix | 有动态 | Phoenix 20.4.0 release commit、reasoning token rates，2026-08-26；https://github.com/Arize-ai/phoenix/commit/a015c6f69ccb23f1eb2d2a31a25097b42f9dba00 | 是 |
| Coze Loop | 有动态 | sandbox-agent turn-level E2E metrics 与 error_code，2026-08-25/26；https://github.com/coze-dev/coze-loop/commit/c4d09670af9f5c369f63b6f61cbbb6378d00a7d2 | 是 |
| OpenTelemetry for Agents | 有动态 | 官方独立规范仓库 8/20、21、22 有提交；规范仍 Development；https://github.com/open-telemetry/semantic-conventions-genai/commits/main/ | 是 |
| AWS observability/eval/guardrails | 有动态 | AgentCore Gateway + Policy + Bedrock Guardrails 官方博客，约 2026-08-22；https://aws.amazon.com/blogs/machine-learning/govern-ai-agent-tool-access-with-amazon-bedrock-agentcore-gateway/ | 是（云厂合并） |
| Google observability/eval/guardrails | 静默/平台基线 | 官方 Agent Platform scale 文档；未核实本窗独立发布；https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale | 否 |
| Azure/Microsoft observability/eval/guardrails | 有动态（文档） | Foundry Observability 文档 `updated_at=2026-08-26`；https://learn.microsoft.com/en-us/azure/foundry/concepts/observability | 是（云厂合并） |

## 补漏对象状态表

| 对象 | 本周状态 | 证据源 | 处理 |
|---|---|---|---|
| FailproofAI | 有动态/强候选 | GitHub 页面标示约 5 天前更新；官方 README 明示 12 harness、40 policies、OpenClaw；https://github.com/FailproofAI/failproofai | 深写 |
| Laminar | 活跃但无已核实基础设施级发布 | https://github.com/lmnr-ai/lmnr/commits/main/ | 静默记录 |
| OpenLIT | 本周活跃 | 8/24、8/26 commits；https://github.com/openlit/openlit/commits/main/ | 趋势补写 |
| Logfire | 未核实本窗重大发布 | https://github.com/pydantic/logfire | 静默记录 |
| TraceRoot | 本周高度活跃 | 8/25、8/26 大量 commits；https://github.com/traceroot-ai/traceroot/commits/main/ | 观察，未深写功能（commit 标题提取不足） |
| agentacct | 获取失败 | 搜索未找到可可靠核验的官方本窗材料 | 明确缺口 |

## 静默对象

- **LangSmith**：本周未发现基础设施级公开发布；近期基线仍是 Studio 把 agent 可视化调试、tracing、evaluation 与 prompt engineering 合到同一 IDE。
- **AgentOps**：固定仓库本窗无 commit；不以旧产品能力充本周动态。
- **Google**：本周没有核实到独立发布，平台基线仍覆盖 Cloud Trace、Logging、Monitoring、Evaluation Service、Example Store 与 Feedback Service。
- **Laminar / Logfire**：有持续产品或仓库活动迹象，但未获得可归因于本窗的重大版本/公告原文，避免深写。
- **Helicone**：本窗只核实到 pass-through billing 的权限/allowlist 修复，属治理相关工程动态，但不足以列为模块头条。
# 模块7深写（1/4）：OpenTelemetry GenAI semantic conventions

## OpenTelemetry for Agents / GenAI conventions

- **本周动态**：OpenTelemetry 官方 GenAI 页面已明确标注旧页面“Moved”，将 GenAI 语义约定迁入独立的 `open-telemetry/semantic-conventions-genai` 仓库；GitHub commits 页面显示本期时间窗内 8 月 20、21、22 日均有提交。这不是“规范已 GA”，恰恰相反：独立仓库 README 对 events、exceptions、metrics、model spans、agent spans 统一标注 **Development**。迁仓的意义是让高变化率的 GenAI/Agent/MCP schema 与核心 semantic conventions 解耦、单独迭代和版本化。第三方 TrueFoundry 8 月 21 日的逐项核对也明确指出，当天仍无该独立仓库的正式 release，因此生产采用应锁定所用 commit/字段集，而不能笼统声称“符合 OTel GenAI 标准”。

  对 Agent Harness 最重要的变化，是规范对象已超越单次 LLM call：agent spans 定义 `create_agent`、远程/本地 `invoke_agent`、`invoke_workflow`、`plan`、`execute_tool`；`gen_ai.agent.id/name/version` 与 provider、requested/response model、conversation、prompt version、reasoning level、usage 等字段形成跨平台 vocabulary。MCP 也成为一等公民：规范建议在 JSON-RPC `params._meta` 中注入 `traceparent`、`tracestate`、`baggage`，从而让 MCP client span 成为 server span 父级，不被 HTTP retry 或 stream multiplexing 打断；另定义 `mcp.client.operation.duration`、`mcp.server.operation.duration` 及 session duration。对工具调用，若外层 GenAI instrumentation 已建立 `execute_tool` span，MCP instrumentation 应优先补充 MCP 属性而非重复建 span，直接回应“双重埋点”问题。

  评价与数据治理边界也写得很清楚。`gen_ai.client.inference.operation.details` 可携带 chat history、输入输出、tool definitions 等，但 requirement level 是 **Opt-In**，且官方提醒 events 并非所有语言都支持；`gen_ai.evaluation.result` 只为 evaluator 的 score/label/explanation/response correlation 提供承载格式，OTel 本身并不执行评价。这意味着 OTel 能成为跨 Langfuse、Phoenix、Braintrust、云厂后台的交换层，却不会替代评价器、red team、policy engine 或敏感数据策略。

- **关键数据**：本窗 commits 日期 3 天（8/20、8/21、8/22，GitHub commits 页面，2026-08-27 核验）；规范状态 Development；agent operation 至少覆盖 create/invoke/workflow/plan/execute_tool 五类；MCP context keys 包括 `traceparent`、`tracestate`、`baggage`。来源：
  - https://opentelemetry.io/docs/specs/semconv/gen-ai/
  - https://github.com/open-telemetry/semantic-conventions-genai/commits/main/
  - https://raw.githubusercontent.com/open-telemetry/semantic-conventions-genai/main/docs/gen-ai/README.md
  - https://raw.githubusercontent.com/open-telemetry/semantic-conventions-genai/main/docs/gen-ai/gen-ai-agent-spans.md
  - https://raw.githubusercontent.com/open-telemetry/semantic-conventions-genai/main/docs/gen-ai/mcp.md
  - https://raw.githubusercontent.com/open-telemetry/semantic-conventions-genai/main/docs/gen-ai/gen-ai-events.md
  - 交叉核验：https://www.truefoundry.com/blog/opentelemetry-genai-semantic-conventions （2026-08-21）
- **影响判断**：这是一条比某个可观测产品 UI 更新更强的基础设施信号：Agent trace 的最小互操作语义正形成。但 Development 状态、语言 SDK覆盖差异与 opt-in 内容意味着现在应“兼容+版本锁定”，而不是押注字段永不变化。供应商护城河将从私有埋点格式移向数据治理、评价闭环、查询体验和 policy enforcement。

## 对 OpenClaw 的直接参照

1. **建立 OTel-native 事件映射层**：把 OpenClaw session/turn/tool/subagent/approval/cron/Gateway 事件映射到 `invoke_agent`、`invoke_workflow`、`plan`、`execute_tool`，保留 `session_id`、`agent_id` 与 tool call correlation；字段 schema 必须版本化。
2. **为 MCP 贯通 trace context**：OpenClaw MCP client/server 或 gateway 转发时，按 OTel 建议在 `params._meta` 传播 W3C context，并避免与外层 tool span 重复建 span。这样一次跨进程工具调用可从用户消息追到远端工具。
3. **默认结构可观测、内容 opt-in**：token、latency、error、tool name、approval decision 默认可采；prompt/output/tool arguments/result 默认不外发，按工作区策略做 redact、采样、驻留和保留周期。
4. **evaluation 与 policy 解耦但相关联**：评价结果可用 `gen_ai.evaluation.result` 附着到 response/trace；执行前 allow/deny 则仍由 OpenClaw 原生审批/权限或外部 policy engine完成，不能把观测误当防护。
# 模块7深写（2/4）：Coze Loop + FailproofAI

## Coze Loop

- **本周动态**：Coze Loop 在 8 月 25 日把 sandbox agent evaluation 的“单 turn 从首次入调度到终态”纳入端到端指标，新建 `e2e_started.counter`、`e2e_finished.counter`、`e2e_duration.timer`，tag 新增 `turn_id`，且 duration 横跨失败重试与 async callback re-entry。实现明确规定 started 只在 `RetryTimes==0` 且非异步回调重进时触发，finished 只在成功或最终不再重试时触发。该提交同时修复了一个严重时间单位错误：`event.CreateAt` 是 Unix 秒，却被当作 Unix 毫秒，导致约 `1.78e12 ms` 的荒谬耗时；修复为 `time.Unix(sec, 0)`。新增 6 个函数均声称达到 100% 覆盖。

  8 月 26 日继续补 `error_code` tag，并修复 error wrapping 后真实错误码丢失的问题：抽码按 StatusError、target run result、evaluator results 三段回落。另一个修复针对 sweep/zombie：此前提前把 `items_result.status` 写 Fail，后续 stats delta 的旧新状态都为 Fail，导致 Processing 永远不减、UI 失败行像仍在运行；现在状态统一由 run log 落地，形成 `{Processing:-1, Fail:+1}`。这不是炫目的前台功能，却是 eval infra 是否可用于 SLO、告警和容量判断的根基。
- **关键数据**：3 个新 E2E 指标；新增 `turn_id`；6 个新函数 100% coverage（项目提交自述）；错误 duration 曾约 `1.78e12 ms`。来源：
  - https://github.com/coze-dev/coze-loop/commit/c4d09670af9f5c369f63b6f61cbbb6378d00a7d2 （2026-08-25）
  - https://github.com/coze-dev/coze-loop/commit/a1ae5fa85372479f2e3bc8d20b0b25e28641e8f5 （2026-08-26）
- **影响判断**：Coze Loop 正把 evaluation 当成长期运行的分布式任务系统，而非一次性的 LLM-as-judge 表单。turn、retry、async callback、zombie、错误分类被统一进指标后，评测吞吐和可靠性才真正可运营；对同类产品的压力是：只展示 trace 树、不对 eval pipeline 自身做 SRE，已不足以服务大规模 agent regression。

## FailproofAI

- **本周动态**：热度扫描与官方 GitHub 页面显示 FailproofAI 本周更新，README 将定位从单纯观测直接推进到“observability and enforcement for AI agent harnesses”。它声称通过 hook 覆盖 12 个 harness：10 个 coding CLI，以及 Hermes、OpenClaw 两个 chat/assistant gateway；用统一 event、policy 与 session history 捕获运行，并在危险 tool call 执行前阻断。产品给出 40 条 built-in policy，示例包括 API key 泄漏、读取 `.env`、重复 tool loop、sudo、破坏性 SQL、Terraform/Kubernetes 写操作、`rm -rf`、force push/direct push main。policy decision 不是只有 allow/deny，还包括 `instruct(message)`——放行但把约束注入 agent 下一轮上下文。

  本地侧无需账号，以 `localhost:8020` 展示模型调用、工具调用、hook decision、block 原因，并提供离线 audit 从历史风险模式建议策略；云端侧声称支持并行 sub-agent lanes、model/tool/hook p50/p95/p99、per-model cost/context window、SQL over traces、外部 evaluation scoring、scheduled audit 与 Slack/email/signed-webhook alerts。这里应保留两项审慎限定：其“zero latency”属于项目自述，未见独立 benchmark；许可证是 MIT + Commons Clause，内部/个人免费，但商业转售自身需另行许可，不能等同无条件 Apache/MIT。
- **关键数据**：12 个 harness、40 条 policies、本地 dashboard 端口 8020；3 种 policy decision；云端宣称 p50/p95/p99。来源：
  - https://github.com/FailproofAI/failproofai （2026-08-27 核验，页面显示约 5 天前更新）
  - https://raw.githubusercontent.com/FailproofAI/failproofai/main/README.md
  - https://docs.befailproof.ai/policies/builtin
- **影响判断**：这是本周最强的 OpenClaw 直接参照候选。它证明 observability 与 guardrail 正在 harness hook 层融合：同一份 tool event 既进入 trace，也成为执行前 policy input。OpenClaw 若只把 approval 当交互弹窗、把 telemetry 当事后日志，会被这类“observe → audit → policy → block”闭环拉开。

## 对 OpenClaw 的参照

- 把当前 approval/security hooks 抽象为稳定的 `PreToolUse`/`PostToolUse` 事件契约，并输出 allow/deny/instruct/review 四态；第三方可观测产品只读结构数据，policy engine 才有执行权。
- 仿照 Coze Loop 对 subagent/cron turn 建立跨 retry 的 E2E 指标，明确区分 attempt latency 与 logical-turn latency；zombie/timeout/cancel 必须落终态，避免监控“永久进行中”。
- 可借鉴 FailproofAI 作为外部集成而非内置全部能力，但应核验其 hook 权限、数据外发、许可证、延迟和 policy bypass 边界后再推荐生产使用。
# 模块7深写（3/4）：Phoenix / Braintrust / Langfuse

## Arize Phoenix

- **本周动态**：Phoenix 于 8 月 26 日合入 `arize-phoenix 20.4.0` release commit，并同步更新 Kustomize 与 Helm 版本；同日 cost tracking 修复将 LiteLLM reasoning token rates 正确映射为 reasoning token prices。对 agent observability 而言，这解决的是“总 completion token 已收费，但思考 token 成本拆分不可见/错配”的 FinOps 问题。Phoenix 本周还保持高提交活跃，但本笔记只把明确 release 与 cost mapping 视为可报告动态，不把普通 UI 修复拔高为行业事件。
- **关键数据**：版本 20.4.0；日期 2026-08-26。来源：
  - https://github.com/Arize-ai/phoenix/commit/a015c6f69ccb23f1eb2d2a31a25097b42f9dba00
  - https://github.com/Arize-ai/phoenix/commit/49cf5a722c77ee4569ee01c8f30c39f6b6779bec
  - https://github.com/Arize-ai/phoenix/commit/b0c1e60c5f4551279ecff9ac84ab780a5981ccab
- **影响判断**：reasoning-model 时代，观测后台的价值正在延伸到 cost manifest 的时效与准确性。Phoenix 的开源、自托管与 OTel 谱系仍是其差异化，但对用户而言，成本字段必须与 provider/LiteLLM 定价同步，才可用于预算门控而非仅展示。

## Braintrust

- **本周动态**：Braintrust JavaScript SDK 8 月 24 日为 LangChain/LangGraph span 增加 reasoning token metric。提交解释 `UsageMetadata.output_token_details.reasoning` 原本没有被读取，`completion_tokens` 虽覆盖花费，却丢失 thinking breakdown；修复映射为 `completion_reasoning_tokens`，并明确零值也记录。变更快照涉及 10 个文件新增 30 行，项目测试自述为 1,648 tests passed，另完成 typings、lint、E2E 相关校验。8 月 26 日又加入 AI SDK `generateImage` instrumentation，把 observability 扩到图像生成调用。
- **关键数据**：1,648 tests passed；10 文件、30 行 snapshot 增量；日期 8/24、8/26。来源：
  - https://github.com/braintrustdata/braintrust-sdk-javascript/commit/a47a41ef71d4f6b5639e9878dbed81ead0cb7c4a
  - https://github.com/braintrustdata/braintrust-sdk-javascript/commit/99c48c96738c8c7e8438f0dea412d0487f6c8eae
- **影响判断**：Braintrust 的路线是把 eval-first 产品向多框架、跨模态 production instrumentation 推进。reasoning token 的独立 metric 可用于模型迁移、成本/质量回归和 prompt 改动诊断；它与 OTel 最新 `gen_ai.usage.reasoning.output_tokens` 方向一致，但实际字段命名/导出兼容仍需用户逐版本核验。

## Langfuse

- **本周动态**：Langfuse 8 月 26 日修复 OTel attribute mapping 的 prototype-chain clobbering，并处理 nested attribute path 冲突。该修复不应被包装成“新评估产品”，但对接收外部 OTLP telemetry 的多租户后台非常关键：如果把不可信 attribute path 直接映射到 JavaScript object，原型链污染可能破坏对象结构甚至形成安全风险。同期 trace UI 也加强 observation error/status message 呈现，但本周真正值得写的是 ingestion 安全边界，而非界面变化。
- **关键数据**：commit 1 个核心 OTel 安全修复，2026-08-26。来源：
  - https://github.com/langfuse/langfuse/commit/1c5df63be9c5bbe6e36bd02628c538b0793bdfa9
  - https://github.com/langfuse/langfuse/commit/89045dd03ce2a7219b979ef622ae0039f2c99eff
- **影响判断**：OTel 互操作扩大了 ingest 面，也扩大了攻击面。对所有 agent observability 后台，attribute cardinality、路径冲突、prototype pollution、内容脱敏与租户隔离会成为与 trace UX 同等重要的产品能力。

## 模块交叉判断

Phoenix、Braintrust、Langfuse 三条工程线看似零散，实际上都指向同一层标准化：**OTel/框架埋点负责统一“发生了什么”，后台竞争转向数据是否安全摄入、是否能精确解释 reasoning/cached/multimodal usage、是否能把这些指标连接到 eval 与预算决策。**
# 模块7深写（4/4）：AWS / Google / Microsoft 云厂治理面

## AWS / Google / Microsoft

- **本周动态**：AWS 本周官方文章将 AgentCore Gateway 的 tool access 与 AgentCore Policy、Amazon Bedrock Guardrails 连接起来。搜索与官方页面核验到的核心是：Policy 在动作执行前对“谁可调用哪个 tool、在什么条件下调用”做确定性控制；2026 年 7 月交付的 Bedrock Guardrails 集成可在 Cedar policy 中表达内容约束。同期 AWS cloud migration 案例明确写出 guardrail trace 进入 AgentCore Observability 并与 tool-call audit trail 合流。AWS 本周强信号不是“又一个 dashboard”，而是 identity/policy/guardrail/trace 同处工具执行边界。

  Google 本期未核实到时间窗内独立发布，因此按“平台基线”而非本周新闻记录。Gemini Enterprise Agent Platform 的 scale 文档公开把 production quality loop 定义为 Example Store + Evaluation Service，用于 test、monitor、trace agent behavior，并提供 Cloud Trace、Cloud Logging、built-in/custom metrics 与 alerts；Feedback Service 将用户定性反馈和 system events/telemetry 一起追踪。平台安全表显示 Agent evaluation 支持 VPC Service Controls、CMEK、data residency at rest、HIPAA，但 Access Transparency 与 Access Approval 在 evaluation 一列为 No，属于治理矩阵需要保留的限制。

  Microsoft Foundry Observability 文档元数据显示 `updated_at: 2026-08-26`。官方把能力归为三件套：Evaluation、Monitoring、Tracing。built-in evaluators 覆盖 coherence/fluency、groundedness/relevance、hate/unfairness、violence、protected materials，以及 agent-specific tool call accuracy 与 task completion；Azure Monitor Application Insights 提供 token、latency、error、quality dashboard 与 alerts；tracing 基于 OpenTelemetry，并点名 LangChain、LangGraph、OpenAI Agents SDK、Microsoft Agent Framework。生产阶段支持 sampled continuous evaluation、scheduled evaluation、scheduled red teaming、质量/有害内容阈值告警。定价说明特别提醒：agents playground evaluations 默认对所有 Foundry projects 开启且按 consumption billing；用户须在 metrics 中取消所有 evaluator 才能关闭。

- **关键数据**：Microsoft 3 核心能力、4 类 post-production 机制；Foundry 文档更新时间 2026-08-26；Google evaluation 的 VPC SC/CMEK/data residency/HIPAA=Yes，而 Access Transparency/Approval=No。来源：
  - AWS：https://aws.amazon.com/blogs/machine-learning/govern-ai-agent-tool-access-with-amazon-bedrock-agentcore-gateway/ （本周官方文章）
  - AWS 案例：https://aws.amazon.com/blogs/machine-learning/scaling-cloud-migrations-with-agentic-ai-on-amazon-bedrock-agentcore/
  - Google：https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale
  - Microsoft：https://learn.microsoft.com/en-us/azure/foundry/concepts/observability （updated 2026-08-26）
- **影响判断**：云厂正在把 observability 从可选外围工具变成 agent control plane 的默认闭环：trace 触发 evaluator，evaluator 进入 monitor/alert，policy/guardrail 决定动作能否发生。独立产品的机会仍在跨云、开源自托管和更快适配框架；威胁是云厂把身份、网络隔离、账单、审计与评估打包后，单纯 trace viewer 很难单独出售。

## 云厂状态简表（仅模块7）

| 平台 | Trace/Monitor | Eval | Guardrails/Policy | 本周判断 |
|---|---|---|---|---|
| AWS AgentCore | Observability + tool-call audit/guardrail trace | 平台能力存在，本条未核实新 eval 发布 | AgentCore Policy + Bedrock Guardrails/Cedar | 有强信号：动作前治理与 trace 合流 |
| Google Agent Platform | Cloud Trace/Logging/metrics/alerts + Feedback | Evaluation Service + Example Store | 平台安全控制；evaluation 部分治理项仍有 No | 本周静默，作为成熟基线 |
| Microsoft Foundry | OTel + App Insights dashboards/alerts | built-in/custom、continuous/scheduled、agent-specific | safety evaluator + scheduled red team + alerts | 文档本周更新，闭环最完整清晰 |

## 模块洞察

- **一句话**：Agent observability 正标准化为 OTel 语义数据面，evaluation 正产品化为持续反馈环，而 guardrails 正下沉到 tool execution 的同步 policy plane；三者不再是三个孤立市场。

## TOP 候选（供总稿排序）

1. **OpenTelemetry GenAI 独立规范仓库持续迭代**：跨厂商结构语义的标准件信号最强；但仍 Development，是“方向已定、接口未冻”。
2. **FailproofAI 把 OpenClaw 等 12 harness 的观测与执行前 enforcement 合一**：对 OpenClaw 参照直接，代表从事后 trace 向实时 control 转型。
3. **Coze Loop turn-level E2E evaluation metrics**：跨重试、异步回调、zombie/error code 的 eval SRE 化，说明评测自身成为生产系统。
4. **Microsoft Foundry evaluation-monitoring-OTel tracing 闭环**：云厂把 continuous/scheduled eval、scheduled red team、alerts 收进控制面。
5. **Reasoning-token 可观测性同时进入 Braintrust/Phoenix**：成本与质量解释从总 token 升级到 thinking breakdown，形成多供应商共振。

## 补漏但不入 TOP

- OpenLIT 8/24、8/26 仓库活跃且坚持 OTel-native；未提取出可验证的单一 release 功能，故只作为标准生态旁证。
- TraceRoot 8/25、8/26 高频提交，但 commits 页面标题提取不足，避免根据活跃度虚构功能。
- Laminar、Logfire 本期没有核实到足够强的时间窗内发布；agentacct 未找到可靠官方材料。
# 恢复任务 A2｜模块 8：Managed Agent Platform / Enterprise Control Plane

- 本期时间窗：2026-08-20 00:00—2026-08-26 24:00（Asia/Shanghai）。
- 执行口径：只有窗口内官方公告、官方文档更新、GitHub release 或明确到期事件计入“本周动态”；平台存量能力用于七列矩阵。搜索摘要只作线索，有动态对象均已阅读全文。
- 输入复用：Runtime / Sandbox 列优先复用研究线 B 已核验的 Microsoft Hosted Agents、Google Managed Agents / Code Execution、阿里云 Agent Security Center 资料，再以平台官方总览交叉校准。

## 本周模块结论

- **AWS 用 Memory 把平台输入从“对话”扩到任意业务事件。** AgentCore Memory 的 `CreateEvent` 本周新增 JSON payload，单 payload 最大 100 KB，行为事件、活动日志和系统事件可直接进入 semantic、user preference、summarization、episodic 四种长期记忆策略，无需伪装成聊天消息。这是企业平台把 operational data 纳入 Agent context plane 的明确信号。
- **Google 把 coding agent 收进统一企业订阅与管理面。** 8 月 21 日，Antigravity 进入符合条件的 Gemini Enterprise Standard、Plus、Standard Emerging Market 订阅；管理员可在同一 console 管 spend、安全、可观测与用量，并控制 workspace sandbox、browser/MCP access、audit logging。相比单纯 Managed Agents API，这是“用户、许可证、预算和审计”层面的平台化。
- **Microsoft 以一次不自动迁移的 backend 退场，强制确定 Hosted Agent runtime ABI。** 8 月 20 日旧 preview backend 停止支持，新模型明确为每 session 隔离 sandbox、跨 turn/idle 持久 `$HOME` 与 `/files`、专属 Entra identity、独立 endpoint 和多协议服务。这是本周对存量用户影响最直接的 control-plane 事件。
- **中国平台的强信号集中在治理与团队记忆，而非新模型。** 阿里 Agent Security Center 把 PAI/百炼/OpenClaw 等纳入五域姿态检测；火山 OpenViking v0.4.16 加用户级 memory policy、可持久后台任务与远程 Skill；腾讯 TencentDB Agent Memory v2.0.1 把团队 Memory/Skill/Wiki/CodeGraph 扩到 Codex、OpenCode、DSH、WorkBuddy，并修复多 Agent 记忆隔离。
- **Databricks 本周平台层信号偏网络治理。** 8 月 20 日 Inbound Private Link Beta 扩到 account-level Genie One、account console、Governance Hub、account APIs 和 custom/stable URL，以一个 General Access endpoint 跨 workspace/region 承载 UI/API；这是 Agent Bricks 外围企业 control plane 加固，不是新 Agent runtime 发布。

## 固定平台状态表

| 平台 | 本周状态 | 官方原文（日期） | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 有动态 | [AgentCore Memory JSON payload](https://aws.amazon.com/about-aws/whats-new/2026/08/agentcore-memory-json-payloads/)（2026-08-20） | 是 |
| Google Vertex AI / Gemini Enterprise Agent Platform | 有动态 | [Expanding Google Antigravity for enterprise customers](https://cloud.google.com/blog/products/ai-machine-learning/expanding-google-antigravity-for-enterprise-customers)（2026-08-21）；[Managed Agents](https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents)（更新 2026-08-21） | 是 |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | 有动态（到期/迁移） | [Migrate hosted agents](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview)（旧 backend 支持至 2026-08-20） | 是 |
| 阿里云百炼 / Model Studio / PAI | 有动态（安全控制面） | [Agent Risk Detection and Prevention](https://www.alibabacloud.com/help/en/asc/user-guide/agent-risk-detection-overview)（更新 2026-08-21） | 是 |
| 火山 Ark / Coze / Coze Studio / Coze Loop / OpenViking | 有动态 | [OpenViking v0.4.16](https://github.com/volcengine/OpenViking/releases/tag/v0.4.16)（本周 release，窗口内；官方 tag/全文已核） | 是 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 有动态（腾讯云开源记忆组件） | [TencentDB Agent Memory v2.0.1](https://github.com/TencentCloud/TencentDB-Agent-Memory/releases/tag/v2.0.1)（2026-08-25） | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 有动态（企业网络控制面） | [Inbound Private Link expansion](https://www.databricks.com/blog/inbound-private-link-now-supports-account-level-genie-one-account-console-and-custom-urls)（2026-08-20） | 是 |

> 结论：7/7 均有窗口内可核验信号，但强度不同。AWS/Google/Microsoft/火山/腾讯是 Agent 平台核心层变化；阿里是跨平台安全控制面；Databricks 是 Agent 产品外围的企业网络治理，不应夸大为 Agent Bricks 新版本。
# 模块 8｜七平台能力矩阵（7/7）

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Harness + serverless Runtime；异步 Agent、session isolation；Runtime Instances 可承载更长期 persistent compute（存量） | short/long-term Memory，可跨 Agent 共享并学习 experience | Gateway 把 API、Lambda、既有 MCP server 统一成 MCP tools；Registry 管 agent/tool/skill | AgentCore Identity 对接 Cognito、Okta、Entra、Auth0；Policy 在 Gateway 拦截 tool call | 每 Harness session 隔离 microVM，可 BYO image；托管 Browser；Code Interpreter 支持 Python/JS/TS | OTEL-compatible Observability；Evaluations 基于 session/trace/span；Optimization 以 trace 建议 + versioned bundle + A/B | **8/20 Memory `CreateEvent` 接受最大 100 KB JSON，四类 extraction strategy 均可直接从非对话事件生成长期记忆** |
| Google | ADK + Agent Runtime；sub-second cold starts、long-running agent；Managed Agents 的 Agents API/Interactions API；Sessions | Memory Bank 跨 session 记忆，RAG Engine/Vector Search；外部 Cloud Storage 可挂载到 Agent sandbox | Agent Gateway 统一 client→agent 与 agent→anywhere；MCP/A2A/REST/gRPC；Registry 默认阻断未注册远端资源 | 每 Agent managed identity；IAM/IAP；mTLS、DPoP、OAuth 2.0；Gateway 可按 tool 名和读/写属性授权 | Managed Agents 每 Agent 独立 Linux sandbox、默认无网无凭证；Code Execution 无网、100 MB I/O、最长 14 天 TTL | Unified Trace Viewer；Cloud Logging/Trace；multi-turn autoraters、online evaluation、simulation；Gateway 网络层 telemetry | **8/21 Antigravity 纳入 Gemini Enterprise 订阅：统一 license、pooled quota/overage、预算、sandbox/browser/MCP policy、单开关审计；Managed Agents 文档同日更新** |
| Microsoft | prompt agent、Hosted agent、Responses API；新 Hosted backend 每 session 独立、自动 provision/deprovision，默认 idle 15 分钟 | built-in memory；session-level state；可 BYO Azure AI Search/Cosmos DB conversation state | Toolboxes 把 web/file/code/MCP/OpenAPI/function 汇成 managed MCP endpoint，集中 auth/version/governance | 每 Agent 专属 Entra identity；RBAC、managed identity、OAuth OBO；M365/Teams/Entra Registry 分发 | Hosted session VM-isolated sandbox，`$HOME`/`/files` 跨 turn/idle；BYO VNet；Code Interpreter | end-to-end trace、metrics、evaluations、Application Insights；Agent Optimizer | **8/20 旧 Hosted backend 停止支持且不自动迁移；新 ABI 采用专属 endpoint、专属身份、session sandbox 与 Responses/Invocations/Activity/A2A 多协议** |
| 阿里云 | 百炼 / Model Studio Agent 应用；PAI-EAS 托管模型与服务，ASC 横向扫描 PAI、百炼、AgentKit、AgentRun | 百炼知识库/RAG；ASC 检测知识/记忆投毒与权限过宽 | Model Studio / PAI tools、API、MCP；ASC 检查 MCP/API tool HTTPS、tool poisoning、未授权调用 | RAM/AKSK/KMS 等云身份底座；ASC 检测明文凭证、弱口令、Gateway 强 token、Agent identity spoofing | PAI-DSW/EAS container/GPU；本周未见专用 browser 控制面；ASC 检查 sandbox isolation、code/SQL injection、SSRF | ARMS/PAI 监控；ASC 提供五域风险检测、基线与实时防护；独立 agent eval 平台公开证据仍弱 | **8/21 ASC 文档落地五安全域，并直接提供 Alibaba Cloud Standard - OpenClaw Security Baseline，平台从托管扩到跨 Agent posture management** |
| 火山/字节 | Ark/Coze runtime；OpenViking Session、VikingBot、可持久异步 resource tasks、长程 Context Compilation | OpenViking Context DB 统一 memory/resources/skills；用户级 `memory_policy`；跨 session 更新 | Coze tools/plugins；OpenViking MCP、DSH stdio MCP proxy、远程 Skill、TOS/Lark connectors | API key / user scope；管理员按用户设置 memory policy；`viking://~` 按已认证调用方解析 | Coze code/plugin execution；OpenViking 不等同专用 browser；统一云 browser 公开证据仍不足 | Coze Loop tracing/eval；OpenViking task context/queue stats、request error detail、read tracking | **OpenViking v0.4.16：remote Skills、user-scoped memory policy、durable async ingestion、Context Compilation、VectorDB 4xx 正确返回** |
| 腾讯云 | 腾讯云智能体平台/元器/CloudBase 托管与发布；TencentDB Agent Memory 以 Proxy 方式接 coding agents | 智能体知识库/长期记忆；TencentDB Agent Memory 的 Chat Memory、Skill、Wiki、CodeGraph，团队资产和分层 L0-L3 | 元器插件/工具、CloudBase tools；Memory Proxy 兼容 Anthropic/OpenAI 协议；Knowledge `/v3/tools/*` | CAM/应用密钥；Memory Hub 提供 System Admin、Team Admin/Member、Owner，private/team/restricted/User/Role/Agent ACL | CloudBase function/container；公开资料对统一 browser/code sandbox 仍弱 | 智能体平台评测/日志为存量；Memory Hub 有处理状态与用量；统一 agent tracing/eval 控制面证据仍弱 | **8/25 TencentDB Agent Memory v2.0.1 新增 Codex/OpenCode/DSH/WorkBuddy，持久 session binding、按权限跨会话搜索，并修复多 Agent 记忆串场/空召回** |
| Databricks | Custom Agents on Databricks Apps；Agent Bricks Knowledge Assistant/Supervisor；Model Serving endpoint | Lakehouse/Unity Catalog、AI Search/Vector Search、企业文档 grounded context；Supervisor default storage 存临时变换/checkpoint/metadata | Unity AI Gateway + MCP；managed MCP 覆盖 Genie/AI Search/SQL/UC functions；外部 MCP/OAuth/UC connections | Unity Catalog grants、service principals；Supervisor end user 需对每个 subagent/tool 显式权限；context-based ingress 按 identity/network/destination | Supervisor 内置 locked-down serverless code sandbox，Python/SQL/shell，无公网、只读获批 UC tables/volumes；专用 browser 非优势 | MLflow Tracing、Agent Evaluation、offline/online monitoring、human feedback/LLM judges | **8/20 Inbound Private Link Beta 扩到 account-level Genie One、Governance Hub、console/APIs/custom URL；一个 General Access endpoint 可跨 region/workspace，context-based ingress 统一 public/private policy** |

## 矩阵证据边界

- AWS、Google、Microsoft 的六能力面均能从官方平台总览得到直接产品定义，成熟度最高；“本周强信号”只引用 8/20—26 事件。
- 阿里、腾讯部分栏位是公开能力缺口，不等于断言产品不存在。尤其专用 browser sandbox、per-agent identity、统一 trace/eval，在现有官方材料中没有 AWS/Google/Microsoft 同等粒度的证据。
- 火山的本周核心证据来自 OpenViking 开源 release，不能外推为 Ark/Coze 全平台 GA；腾讯同理，TencentDB Agent Memory v2.0.1 是腾讯云开源组件，不等同智能体平台全量托管上线。
- Databricks Inbound Private Link 是平台治理信号；它提升 Genie One/治理控制面的私网可达性，但不是 Agent Bricks runtime 更新。
# 模块 8 深度笔记（一）｜AWS + Google

## AWS Bedrock AgentCore

- **本周动态：**AWS 在 8 月 20 日让 AgentCore Memory 的 `CreateEvent` API 接受 JSON payload。此前长期记忆抽取主要面向多轮 conversation；现在开发者可将 behavioral events、activity logs、system events 等结构化数据直接传入 extraction pipeline，单 payload 最大 100 KB，无需把业务事件改写成虚假的 user/assistant message。官方明确 JSON 与 conversation 同等处理，并覆盖四种长期记忆策略：semantic、user preference、summarization、episodic；功能在所有已支持 AgentCore Memory 的区域可用，且与既有能力兼容。技术上，这把 Agent Memory 的输入边界从 transcript 扩成 enterprise event bus：订单状态、产品使用、审批结果、故障或策略执行都可能成为可巩固记忆。商业上，AWS 正在把 AgentCore 的完整栈——Harness、Runtime、Memory、Gateway、Identity、Browser/Code Interpreter、Observability/Evaluations/Optimization、Policy/Registry——通过数据闭环粘合，而不是只卖部署环境。
- **关键数据：**发布时间 2026-08-20；JSON payload 上限 100 KB；4 种 extraction strategies；官方称所有 AgentCore Memory 支持区域当天可用。价格无本周新调整，平台仍为 consumption-based、无 upfront/minimum。
- **原文链接：**https://aws.amazon.com/about-aws/whats-new/2026/08/agentcore-memory-json-payloads/ （2026-08-20）；能力基线：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html 。
- **影响判断：**这类非对话 ingestion 是 Managed Agent Platform 与普通聊天记忆 API 的分界线：平台开始把“企业发生了什么”纳入 Agent 可学习的 state。风险也同步放大——JSON schema、事件真伪、PII、撤销和 revision lineage 必须治理，否则脏业务数据会被四种策略自动固化。OpenClaw 若接 Memory backend，应让 cron/tool/session 事件可结构化写入，但必须保存 source、actor、consent、TTL 和可删除 lineage。

## Google Vertex AI / Gemini Enterprise Agent Platform

- **本周动态：**Google 8 月 21 日宣布 Antigravity 进入符合条件的 Gemini Enterprise app Standard、Plus 和 Standard Emerging Market 订阅，并把 agentic coding 的 license、预算、安全、审计和使用指标合入 Gemini Enterprise admin console。管理员可设月度 project budget cap；团队共享 pooled token quota，配额耗尽时可选择 overage 并设 monthly spend cap；usage metrics覆盖 token consumption、API calls 和 developer activity。治理面可限制 workspace sandboxing、browser 与 MCP server access，并以单一开关开启包含 prompt、agent response 与 metadata 的中央 audit logging；身份面原生支持 Workforce Identity Federation 和 Application Default Credentials。IDE 分发同时覆盖 VS Code、Visual Studio preview、JetBrains preview、Zed preview、Antigravity 2.0 desktop 与 CLI。
- **平台拼图：**本周更新的 Managed Agents 文档把高层 agent definition 做成 config-driven、REST-first 资源：Agents API 负责配置与 network allowlist，Interactions API 承担运行交互，每个 Antigravity agent 默认运行在无外网、无外部系统、无凭证的隔离 sandbox。平台总览则明确 Build/Scale/Govern/Optimize 四柱：Agent Runtime、Sessions、Memory Bank、Code Execution；Agent Registry、Agent Identity、Agent Gateway；多轮 autoraters、online evaluation、simulation、Unified Trace Viewer。Agent Gateway 对 runtime 流量自动介入，可代理 MCP/A2A/REST/gRPC，配 mTLS/DPoP、IAM/IAP、Model Armor 和 semantic governance，默认阻断未注册远端 MCP/tool；一实例上限 5,000 个 Registry resources。
- **关键数据：**官方博客 `datePublished=2026-08-21`；3 类符合条件订阅；预算 caps、pooled quotas、optional overage；Gateway 单实例最多治理 5,000 registry resources。Google 未在正文给新增单独价格。
- **原文链接：**https://cloud.google.com/blog/products/ai-machine-learning/expanding-google-antigravity-for-enterprise-customers （2026-08-21）；https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents （更新 2026-08-21）；https://docs.cloud.google.com/gemini-enterprise-agent-platform/overview ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview 。
- **影响判断：**Google 本周不是简单增加一个 coding client，而是将 coding agent 纳入企业 license/FinOps/security/telemetry 控制面，并用相同身份和政策跨桌面、CLI、IDE。对 OpenClaw 的威胁在于企业客户可用一个采购面完成“开发者入口 + runtime + gateway + identity + audit”；机会则是 OpenClaw 作为多渠道/self-hosted ingress，可对接 Google Agent Gateway/Managed Agent worker，同时保留 transcript、渠道身份与本地执行主权。
# 模块 8 深度笔记（二）｜Microsoft + 阿里云

## Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK

- **本周动态：**8 月 20 日是 Foundry Hosted Agents 初版 public-preview hosting backend 的最后支持日，且旧部署不会自动迁移。迁移不是 endpoint 改名，而是托管契约重写：平台按请求自动 provision compute，并在 idle timeout 后 deprovision（默认 15 分钟）；每个 session 获得独立 sandbox，`$HOME` 与 `/files` 在多轮和 idle 期间持续存在；每个 Agent 在创建时获得专属 Entra identity，替代共享 project managed identity；调用从共享 project endpoint + body 中 `agent_reference` 改为 `{project_endpoint}/agents/{name}/endpoint/protocols/openai/responses` 一类专属 URL。协议库取代框架 adapter，Responses、Invocations、Activity、A2A 可由同一 Agent 暴露，REST 完整覆盖 agent/version/session/file 生命周期；旧 capability host 也被移除，由平台自动供给基础设施。
- **平台拼图：**Foundry 总览把 prompt agent、Hosted agent 和直接 Responses API 分为三条产品路径。Toolbox 可把 web/file search、code interpreter、MCP、OpenAPI 与 functions 汇成单一、版本化 managed MCP endpoint，支持 key、Entra managed identity 与 OAuth OBO。Hosted agent 能交付 container image 或源码 zip，后者由 Foundry build；获得自动扩缩、session state、专属身份、BYO VNet、VM-isolated session sandbox、trace/eval/Application Insights/Optimizer，并可发布到 Teams、M365 Copilot 和 Entra Agent Registry。
- **关键数据：**旧 backend 截止 2026-08-20；默认 idle timeout 15 分钟；`azure-ai-projects>=2.3.0`、`azd>=1.23.0`；Python `azure-ai-agentserver-core 2.0.0b1`；.NET core `1.0.0-beta.21`，Responses/Invocations `1.0.0-beta.1`。迁移文档 `ms.date=2026-08-06`、`updated_at=2026-08-18`，但停止支持事件发生在本周。
- **原文链接：**https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview （截止 2026-08-20）；https://learn.microsoft.com/en-us/azure/foundry/agents/overview （2026-08-13，更新至 8/19）。
- **影响判断：**Microsoft 正把 Hosted Agent 定义成“session sandbox + durable files + identity + protocol server”，并用强制迁移消除旧框架 adapter。短期是明确的重部署/RBAC/endpoint 迁移成本；长期则形成稳定 runtime ABI。OpenClaw 应把自己的 Gateway/session/agent endpoint 版本和状态 schema 做成显式迁移对象，避免只依赖兼容修复。

## 阿里云百炼 / Model Studio / PAI

- **本周动态：**阿里云 Agent Security Center 官方文档在 8 月 21 日更新，提供了本周比新模型更重要的 control-plane 证据：平台把 Agent 生命周期风险拆成 model interaction、knowledge and memory、runtime environment and tools、configuration and components、identity and credentials 五域，并横向覆盖 PAI、Bailian/百炼、Dify、AgentKit、AgentRun 等。它检测 direct/indirect/recursive prompt injection、jailbreak、敏感数据外泄、goal hijacking、RAG/Vector DB poisoning、知识权限过宽；在工具执行层识别未授权调用、command/code/SQL injection、SSRF、object-level 越权、恶意代码、MCP/tool poisoning 与 Skills 文件风险；在配置层检查 model/MCP/API tool 未使用 HTTPS、证书校验关闭、明文 AKSK、Gateway 无强 token、DM/group session 未隔离、全局 Elevated tool、Skills watcher 和 plugin allowlist 等。
- **OpenClaw 明确信号：**文档直接列出 “Alibaba Cloud Standard - OpenClaw Security Baseline”，检查 Gateway 不绑定 `0.0.0.0`、不存明文密码、日志/session 敏感信息过滤、共享 DM session 隔离、sandbox、禁用全局 Elevated、禁动态 Skills watcher、强 token、反向代理、plugin allowlist、配置目录权限、弱口令与未授权访问；还说明通过版本比对发现 OpenClaw 已知漏洞。这证明 OpenClaw 已被云安全产品视为企业生产资产，而非社区边缘工具。
- **关键数据：**官方文档更新时间 2026-08-21；5 个安全域；公开点名 PAI、Bailian、Dify、AgentKit、AgentRun；OpenClaw baseline 至少覆盖 service configuration 与 identity authentication 两类。未公布本周新增 ASC 定价或客户数。
- **原文链接：**https://www.alibabacloud.com/help/en/asc/user-guide/agent-risk-detection-overview （更新 2026-08-21）。
- **影响判断：**阿里本周没有证明百炼出现新 durable runtime，但它在争夺“跨 Agent 平台安全姿态管理”控制点：企业可先通过发现/扫描纳管，再导入云安全服务。对 OpenClaw，这是认可也是压力；最佳回应不是回避扫描，而是输出机器可读 security posture、baseline mapping、remediation status 与证据，主动接入 CSPM/ASC 生态。
# 模块 8 深度笔记（三）｜火山/字节 + 腾讯云

## 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking

- **本周动态：**火山体系最强的可核原文是 OpenViking `v0.4.16`。它把 Context Database 从存储/召回组件继续推向 Agent 平台的共享控制层：VikingBot 可发现、缓存、执行远端 OpenViking 托管的 Skills；Context Compilation 增加 source materialization、读取链路追踪，以及 LLM Wiki、知识图谱、日报、知识蒸馏等适合长程 Agent loop 的复用工作流。管理员可为每个用户设置 `memory_policy`，限定允许抽取的 Memory 类型；老 Session 若没显式策略，会在下一次 commit 继承新策略。`add-resource wait=false` 的源数据准备转入可持久后台任务，保留任务归属，并新增 context count、queued upload stats；VectorDB 4xx 不再被吞掉。
- **身份、工具与可观测细节：**新 `viking://~` 按已认证调用方映射 user root；服务端入口统一规范化 URI，管理员请求也可展开 current-user alias。TOS 连接器凭证保持 request-scoped，不进入 parser/queued job；DSH tools 通过共享 stdio MCP proxy 暴露；L0/L1 semantic sidecar 变为受保护 OKF metadata；Web Studio 遵守 Task API limit 并在 request logs 显示错误详情。跨 session Memory 更新/部分删除、非法 tag 过滤、账号删除后的持久文件清理也被加固。release 同时移除实验性 Resource Relations API，是明确的升级兼容点。
- **关键数据：**版本 `v0.4.16`；memory policy 管理 API 为 `GET/PATCH /api/v1/admin/accounts/{account_id}/users/{user_id}/settings`；`memory_policy=null` 清除用户 override；Git tag `v0.4.16` 已官方仓库直查。官方 release 页面未稳定展示时间戳，按本期 release 排序与 tag 活动确认位于 8/20—26；不臆造具体日时。
- **原文链接：**https://github.com/volcengine/OpenViking/releases/tag/v0.4.16 （窗口内官方 release）；https://github.com/volcengine/OpenViking 。
- **影响判断：**OpenViking 的路线不只是“更好的 RAG”，而是把记忆政策、Skill 分发、异步 ingestion、用户路径和任务 telemetry 合到 Context control plane。它为火山/字节提供了跨 harness 的开放入口，但不可把开源 release 外推为 Ark/Coze 全平台 GA。OpenClaw 可接入 OpenViking，同时要求 write acknowledgement、task ownership、memory policy inheritance 和 deletion lineage 对齐自己的 user/session 权限。

## 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit

- **本周动态：**腾讯云官方仓库 TencentDB Agent Memory 于 8 月 25 日发布 `v2.0.1`，把团队级 memory control plane 扩到更多 coding-agent 入口：新增 OpenCode、DeepSeek Harness（DSH）、Codex CLI、WorkBuddy，所有客户端通过 Proxy 获得 team memory、Skill 和 knowledge 注入；不需要每个框架分别实现插件/MCP。会话内可重置 team/Agent/task binding，直接创建或更新任务；binding 持久化，重启不丢，切换 Agent 后 memory/Skill 跟随切换。版本还加入按权限的跨会话语义 + 关键字搜索、单层 memory 覆盖编辑、Skill 在线编辑与立即可检索，并修复多 Agent 场景空召回、资产解绑无效和历史回放误判。
- **平台拼图：**v2.0.0 的存量架构将经验资产化为 Chat Memory、Skill、Wiki、CodeGraph 四类；Memory Hub 管 owner/version/status/visibility/usage/binding，权限分 private、team、restricted（User/Role/Agent ACL）和 agent 定向装配。Chat Memory 由 L0 conversation → L1 atom → L2 scenario → L3 persona 分层；retrieval 组合 BM25 + vector + RRF，并以数量、字符预算、timeout 限流。Memory Proxy 同时兼容 Anthropic/OpenAI 协议，`x-tdai-user-key` 经 `/v3/meta/auth/verify` 换 user_id。项目 README 报告 PersonaMem 从 48% 到 76%（相对 +59%），但这是项目自报 benchmark，未找到独立复现，应保留厂商口径标签。
- **关键数据：**v2.0.1 日期 2026-08-25；新增 4 个客户端入口；4 类 memory assets；3 级主要 visibility + agent 定向 ACL；自报 PersonaMem 48%→76%（+59% relative）。
- **原文链接：**https://github.com/TencentCloud/TencentDB-Agent-Memory/releases/tag/v2.0.1 （2026-08-25）；https://github.com/TencentCloud/TencentDB-Agent-Memory （能力基线）。
- **影响判断：**腾讯的差异化是把 Memory 从个人 API 变成团队资产与 Agent loadout，而本周修复“串场/空召回”说明多 Agent 权限和 binding 才是难点。它尚不能证明腾讯智能体平台拥有 AWS/Google 同等完整的 runtime/gateway/sandbox/trace plane，但给腾讯矩阵补上了强 Memory/Identity 资产层。OpenClaw 可评估 Proxy 接入，但必须验证 prompt injection 位置、context budget、ACL 与自身 channel user identity 的映射，避免团队记忆跨群/私聊泄漏。
# 模块 8 深度笔记（四）｜Databricks + 综合洞察

## Databricks Mosaic AI Agent Framework / Agent Bricks

- **本周动态：**Databricks 8 月 20 日宣布 Inbound Private Link 在 AWS Enterprise tier 与 Azure Premium tier进入 Beta 扩展：除 workspace 外，现可私网访问 account-level Genie One、account console、Governance Hub 和 account-level APIs，并支持 custom URLs 与 Managed Disaster Recovery stable URLs。一个任意区域的 shared General Access endpoint 可承载所有 workspace/account-level UI 与 API，不再按 region/workspace 各建一个 endpoint；性能型 service-direct endpoint 与 classic compute SCC relay 仍需按区域配置。访问策略统一进 context-based ingress，可按 caller identity、network source（公网 IP 或 registered endpoint）和 destination 做 allow/deny，account-level resources 使用新的 account-policy。既有 Private Access Settings 与 IP allowlist 可并存，任何一侧 deny 都会拒绝。
- **Agent 平台关联：**这不是 Agent Bricks runtime 更新，但 Genie One、Governance Hub 和 account API 都是企业 Agent control plane 的管理入口，私网化与跨区域 endpoint 直接影响受监管客户能否采用。存量 Agent 平台中，Supervisor Agent 可编排 Genie、agent endpoint、Unity Catalog function、MCP server 与 custom agent；每个 end user 必须显式拥有目标 subagent/tool 权限。内置 code execution 使用 locked-down serverless sandbox，支持 Python/SQL/shell、完全阻断 internet egress，只读访问明确加入且终端用户有权限的 Unity Catalog tables/volumes。Unity AI Gateway 统一治理 MCP/tool，Unity Catalog 管权限和 credential；MLflow 提供 tracing、evaluation、offline/online monitor 与 human feedback。
- **关键数据：**官方博客日期 2026-08-20；Beta 覆盖 AWS Enterprise / Azure Premium；1 个 shared General Access endpoint 可跨 region/workspace 服务 UI/API；Supervisor 最多可选择 50 个 agent/tools；code sandbox 无公网、只读获批 UC 资产。后两项是能力基线，不是本周新增。
- **原文链接：**https://www.databricks.com/blog/inbound-private-link-now-supports-account-level-genie-one-account-console-and-custom-urls （2026-08-20）；https://docs.databricks.com/aws/en/agents/custom-agents/build-agents ；https://docs.databricks.com/aws/en/agents/agent-bricks/multi-agent-supervisor ；https://docs.databricks.com/aws/en/agents/mcp-tools/ 。
- **影响判断：**Databricks 的 control-plane 护城河仍是 Unity Catalog/AI Gateway/MLflow 与企业数据平面同域治理，而不是 browser/runtime 广度。本周 Private Link 将这个优势延伸到 account-level Genie 与治理入口，降低强隔离客户部署阻力；但不要包装成 Agent Bricks 新 feature。OpenClaw 可把 Databricks 当 governed data/tool backend，通过 MCP/agent endpoint 接入，而不是复制 Lakehouse 权限系统。

## 静默背景与能力缺口说明

本周 7/7 都有窗口内可核事件，因此没有整个平台“静默”；但以下子产品保持静默，不能把同集团其他组件的变化外推：

- **AWS：**Runtime/Browser/Code Interpreter/Gateway/Identity 本周未核到同级发布；强信号集中 Memory JSON ingestion。AgentCore Runtime Instances 是 8 月 7 日背景，不算本周。
- **Google：**Memory Bank、Agent Evaluation 本周无独立发布；强信号是 Antigravity 企业订阅/治理与 Managed Agents 文档更新。8 月 20 日 Grok 4.1 shutdown 是 7 月 8 日已公告的模型生命周期，不列平台 TOP。
- **Microsoft：**本周事件是旧 Hosted backend 截止；Toolbox、Optimizer、Copilot/M365 publishing 属平台基线。它是“迁移完成日”，不是临时宣称新 GA。
- **阿里云：**百炼/PAI 未见新 durable session 或专用 browser sandbox 公告；本周强信号是 ASC 跨平台 posture control。
- **火山/字节：**Ark、Coze、Coze Studio、Coze Loop 未核到与 OpenViking v0.4.16 同级窗口内公告；矩阵不得把 OpenViking capability 全量当成 Coze 云产品能力。
- **腾讯云：**智能体开发平台、元器、CloudBase 未核到本周同级 runtime/gateway/sandbox 发布；v2.0.1 是 TencentDB Agent Memory 开源层信号。
- **Databricks：**Agent Bricks/MLflow 本周无独立 agent release；Private Link 是企业网络与政策边界增强。

## 模块洞察

- **Managed Agent Platform 已从“模型 + builder”升级为七种资源的治理系统：**Agent/session、memory event、tool/gateway、agent identity、sandbox/network、trace/eval、registry/budget。AWS/Google/Microsoft 已能把六能力列显式产品化；中国平台本周从安全 posture 与团队 Memory 两条路径补控制面；Databricks继续以数据权限和私网治理差异化。
- **本周共同关键词是“边界可声明”。** AWS 声明 JSON event 的输入边界；Google 声明 subscription/spend/browser/MCP/audit 边界；Microsoft 声明 session/identity/protocol ABI；火山和腾讯声明 user/team memory policy；Databricks声明 identity/network/destination ingress。平台竞争正从 capability checklist 转到 policy + lifecycle contract。
# 模块 8｜OpenClaw 参照、TOP 候选与来源账本

## OpenClaw 战略参照

1. **把 Runtime contract 产品化。** 对标 Microsoft 新 Hosted backend，把 OpenClaw 的 session isolation、workspace/files persistence、idle/TTL、checkpoint/restore、agent endpoint/protocol version 和 migration status 变成可查询资源。当前 2026.8.1 beta 对 SQLite、Gateway reconnect、cron claim race 的修复很强，但企业需要稳定契约，而非从 release notes 拼 SLA。
2. **增加结构化事件记忆入口。** 借鉴 AWS JSON payload，允许 cron、tool call、approval、channel interaction、failure/recovery 以 typed event 写入 Memory；每条必须带 source、actor、session、consent、TTL、revision/deletion lineage，避免把日志无条件固化为长期记忆。
3. **把 Gateway 升级成 identity-aware policy enforcement point。** Google 已把 agent identity、Registry、MCP attributes、read/write permission、mTLS/DPoP、Model Armor 与 semantic governance压在 Gateway；OpenClaw需要“用户—渠道—Agent—session—tool—resource”授权链、未注册工具默认拒绝、读写分级和时序 policy。
4. **将安全基线变成可导出的证据。** 阿里 ASC 已公开扫描 OpenClaw 的 Gateway bind、强 token、sandbox、shared DM isolation、Elevated、Skills watcher、plugin allowlist、日志敏感信息等。OpenClaw 应输出机器可读 posture report、baseline ID、pass/fail/evidence/remediation，并提供 ASC/CSPM 映射，而不是只给人读的 doctor 文本。
5. **Memory 必须做团队边界而不只做召回。** OpenViking user policy 与 TencentDB Memory 的 private/team/restricted/Agent ACL 表明，memory 的真正企业壁垒是 ownership、version、binding、policy inheritance、跨 session 删除和错误传播。OpenClaw 的多渠道用户身份映射尤其要防止私聊/群聊/工作区之间串场。
6. **保留自托管入口，外接云控制面。** OpenClaw 的优势是 channel ingress、本地 Gateway、sessions/cron、browser/node 统一；可把 AgentCore、Google Managed Agents、Foundry、Databricks MCP/Agent service 当远程 worker/tool/data backend，但 transcript、secret、approval、backup 和 routing policy 的最终主权应由 operator 控制。

## 本模块 TOP 候选（按 Agent Harness 基础设施格局价值）

1. **Google Antigravity 纳入 Gemini Enterprise（8/21）**：coding agent 第一次被如此完整地并入 license、pooled quota、overage、budget、sandbox/browser/MCP policy、audit 和多 IDE 分发；代表“开发者 Agent → 企业控制面”收编。
2. **Microsoft Hosted Agents 旧 backend 截止（8/20）**：强制迁移确定 session sandbox + durable files + per-agent Entra + dedicated multi-protocol endpoint 的 runtime ABI，存量影响和长期锁定都强。
3. **AWS AgentCore Memory JSON ingestion（8/20）**：Memory 输入从 conversation 变成任意 structured enterprise events，推动 Agent 平台连接 operational data，但也把 provenance/PII/撤销提升为一等治理问题。
4. **OpenViking v0.4.16（窗口内）**：user-scoped memory policy、remote Skills、durable async ingestion、Context Compilation 与错误传播，将 Context DB 推向跨 harness control plane。
5. **TencentDB Agent Memory v2.0.1（8/25）**：团队 Memory/Skill/Wiki/CodeGraph 横跨 Codex、OpenCode、DSH、WorkBuddy，且直接处理 persistent binding 与多 Agent 隔离，代表中国开源路线从“个人记忆”转向“团队资产”。

**备选：**阿里 Agent Security Center 的 OpenClaw baseline（平台安全治理价值高）；Databricks account-level Private Link（企业采用价值高但 Agent 专属性较弱）。

## 来源账本（去重 18 个官方 URL）

1. https://aws.amazon.com/about-aws/whats-new/2026/08/agentcore-memory-json-payloads/ — 2026-08-20
2. https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html — 平台能力基线，2026-08-27 抓取
3. https://cloud.google.com/blog/products/ai-machine-learning/expanding-google-antigravity-for-enterprise-customers — 2026-08-21
4. https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents — 更新 2026-08-21
5. https://docs.cloud.google.com/gemini-enterprise-agent-platform/overview — 2026-08-27 抓取
6. https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview — 2026-08-27 抓取
7. https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes — 2026-08-27 抓取
8. https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview — 支持截止 2026-08-20
9. https://learn.microsoft.com/en-us/azure/foundry/agents/overview — ms.date 2026-08-13，updated_at 2026-08-19
10. https://www.alibabacloud.com/help/en/asc/user-guide/agent-risk-detection-overview — 更新 2026-08-21
11. https://github.com/volcengine/OpenViking/releases/tag/v0.4.16 — 窗口内 release
12. https://github.com/volcengine/OpenViking — 2026-08-27 抓取
13. https://github.com/TencentCloud/TencentDB-Agent-Memory/releases/tag/v2.0.1 — 2026-08-25
14. https://github.com/TencentCloud/TencentDB-Agent-Memory — 2026-08-27 抓取
15. https://www.databricks.com/blog/inbound-private-link-now-supports-account-level-genie-one-account-console-and-custom-urls — 2026-08-20
16. https://docs.databricks.com/aws/en/agents/custom-agents/build-agents — 2026-08-27 抓取
17. https://docs.databricks.com/aws/en/agents/agent-bricks/multi-agent-supervisor — 2026-08-27 抓取
18. https://docs.databricks.com/aws/en/agents/mcp-tools/ — 2026-08-27 抓取

## 门控自检

- Managed Agent Platform 模块：1/1 完成。
- 平台矩阵：AWS / Google / Microsoft / 阿里云 / 火山或字节 / 腾讯云 / Databricks = **7/7**。
- 七列：Runtime / Memory / Gateway / Identity / Sandbox / Observability / 本周强信号 = **7/7 列完整**。
- 有动态对象：7；全文已读：7/7；静默子产品均补存量背景与明确边界。
- OpenClaw 参照：6 条；TOP 候选：5 + 2 备选。
- 已区分正式产品公告、文档更新、迁移截止、开源 release 与外围网络治理，未用时间窗外旧闻充数。
