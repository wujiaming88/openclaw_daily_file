# 全球 AI Agent 基础设施研究周报

> 本期时间窗：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）  
> 研究框架：Agent Harness 八层能力栈  
> 研究方法：固定对象全量过筛 + GitHub 热度补漏 + 有动态对象原文全文核验

## 执行摘要

本周最清晰的变化，不是某个 Agent 模型再变强，而是 **Agent Harness 的生产化边界正在被重新定义**：运行时开始支持 14 天级持久会话与专用计算；授权从单次 API 请求升级到可读取完整行为轨迹的 temporal policy；Agent 获得独立企业身份；Memory 从向量检索 API 升级为能组装上下文、自动提交会话、管理 lineage/ACL 的 Context Database；企业平台则把 Runtime、Gateway、Identity、Sandbox、Observability 串成控制面。

## 本周 TOP 5

1. **AWS AgentCore 把长周期 Runtime 与轨迹级治理连成闭环。** Runtime Instances GA 提供最长 14 天 session、专用 EC2/GPU/内存优化计算；同周 temporal policy、Gateway 多维限流和 GovCloud 能力补齐，意味着 Agent 平台从“托管容器”进入“行为策略 + 成本 + 生命周期”联动阶段。
2. **OpenViking v0.4.13 把 Memory 推向 Context Database。** 服务端 context assembly、Session Auto Commit v2、经验 lineage、OIDC/LDAP、Redis QueueFS 与 OpenClaw Experience Memory tools 同期出现，Memory/Knowledge/Skills/Session 正被收束为一层可远程治理的状态服务。
3. **Agent Identity 成为企业一等安全主体。** Microsoft Entra Agent ID + Dataverse agent users 进入 public preview；AWS temporal policy、Auth0/Okta XAA、WorkOS auth.md/ID-JAG、Clerk CIMD 与 Descope 双层身份模型同时推进，身份栈开始分化为“客户端是谁、Agent 是谁、代表谁、可做什么、如何撤销”。
4. **Databricks 用 PGlite + Electric + Lakebase 重构 Agent state。** 每个 sandbox 拥有本地事务数据库，再同步到中心可治理记录，形成区别于通用云 Agent Platform 的“数据即运行状态”路线。
5. **工具网关从连接器升级为治理强制点。** AWS Gateway rate limit、MCP ’26 迁移讨论、Arcade actions runtime、Composio/Nango 等工具层的演进共同表明：Gateway 的价值不再只是路由工具，而是身份、配额、策略、审计与凭据隔离的集中边界。

## GitHub 热度补漏摘要

本期按九个方向扫描：agent memory、agent context database、agent knowledge graph、AI agent RAG memory skills、MCP gateway、agent auth permission OAuth MCP、browser agent runtime、agent observability eval、agent harness runtime。GitHub Search API 第九次查询触发 403，已降级由模块研究线通过官方仓库与 release 补查。

- **明确补入/深查：** OpenViking、Cognee、supermemory、Crawl4AI、gbrain、TencentDB-Agent-Memory、agentmemory，以及 TrueFoundry MCP Gateway、OpenClaw browser/sandbox security 等模块型候选。
- **进入正文动态：** OpenViking、Cognee、supermemory、gbrain、TrueFoundry MCP Gateway；Crawl4AI 与 TencentDB-Agent-Memory 因时间窗内无合格动态，按静默/窗口后更新处理；agentmemory 因搜索限额导致无法唯一核验，标获取失败。
- **明确过滤：** awesome-list、best-of/排行榜、教程合集、纯应用模板、单一 workflow demo，以及只有窗口外动态的项目。
- 完整扫描记录：`hot-scan-2026-08-13.md`。

---

---

# 模块 1｜Harness / Agent OS 控制层

> 时间窗：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）。窗口外信息只作背景，不计本周动态。检索与原文核验于 2026-08-13 完成。

## 本周模块结论

- 本周最强信号不是“又多一个 Agent 框架”，而是 **RunState / checkpoint / resume / approval / trace policy** 正成为 Harness 的共同控制面：OpenAI Agents SDK 0.20.0、LangGraph 1.2.11/Checkpoint 4.2.0 与 OpenClaw 2026.6.34 都在补长期执行的可靠恢复与安全边界。
- OpenAI 把 durable pending input、原子 session mutation、具体 invocation 绑定审批与 MCP v1/v2 兼容一次性交付，表明 Responses API 谱系正从模型调用封装升级为可暂停、可恢复、可审计的运行控制层。
- 开源侧 CrewAI 连续版本把 Flow 结果、耗时、HITL、失败事件和 skill 使用纳入遥测，说明“编排 DSL”已不够，平台化竞争进入运行证据与企业控制面。
- OpenClaw 参照：其 session/channel 恢复、Gateway、插件与原生子代理已形成更完整的个人/团队 Agent OS；下一步应把审批绑定、RunState 输入队列、节点级 trace policy 做成稳定公共契约，而不只依靠内部事件与日志。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态 | [v2026.6.34，2026-08-08](https://github.com/openclaw/openclaw/releases/tag/v2026.6.34) | 是 |
| OpenAI Agents SDK / Responses API | 有动态 | [Agents SDK v0.20.0，2026-08-11](https://github.com/openai/openai-agents-python/releases/tag/v0.20.0) | 是 |
| Anthropic Claude Agent SDK / MCP | 有动态（维护型） | [v0.2.135/0.2.136，2026-08-10/11](https://github.com/anthropics/claude-agent-sdk-python/releases) | 是 |
| LangChain / LangGraph / LangSmith | 有动态 | [LangGraph releases，窗口内 1.2.11 / checkpoint 4.2.0](https://github.com/langchain-ai/langgraph/releases) | 是 |
| Google ADK | 静默 | [ADK Python releases；最近明确日期版本 2.6.2 为 2026-08-03，窗口外](https://github.com/google/adk-python/releases) | 否 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 有动态 | [Agent Framework releases，窗口内 .NET 1.17.0](https://github.com/microsoft/agent-framework/releases) | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 有动态（平台/状态基础设施） | [Electric 加入 Databricks，2026-08-11](https://www.databricks.com/blog/electric-joins-databricks-bring-wasm-postgres-ai-agent-sandboxes) | 是 |

## 动态池状态表

| 对象 | 本周状态 | 证据源 | 是否补入深写 |
|---|---|---|---|
| CrewAI AMP / Studio | 有动态 | [CrewAI releases，窗口内 1.15.8—1.15.14](https://github.com/crewAIInc/crewAI/releases) | 是 |
| Dify Agent Runtime | 静默 | [Dify releases；最新可核日期 1.16.1 为 2026-07-28，窗口外](https://github.com/langgenius/dify/releases) | 否 |
| n8n | 静默（未发现窗口内基础设施级公告） | [GitHub releases](https://github.com/n8n-io/n8n/releases) | 否 |
| Flowise | 静默（未发现窗口内基础设施级公告） | [GitHub releases](https://github.com/FlowiseAI/Flowise/releases) | 否 |

## 深度笔记

### OpenClaw

- **本周动态：**OpenClaw 在 8 月 8 日发布扩展稳定线 `2026.6.34`，重点不是添加表层功能，而是集中硬化 Agent OS 的恢复语义与边界。官方完整 release 明确列出：session 写入保留、provider fallback、stream progress、stdio failure 在异常时不再静默终止活动任务；pending channel work 可在恢复后继续、ack 幂等，Discord gateway burst 有界；SQLite checkpoint、workspace read、Gateway 进程信号、plugin HTTP response 对瞬态宿主故障更耐受。控制层安全方面，browser/sandbox/exec/MCP/secret resolution 拒绝不安全输入，owner-only 操作继续受保护，账户 URL/摘要不泄露凭据；Codex 原生子代理会保留 parent app-server subscription，并识别 multi-agent V2 子活动直至 yielded completion 回传请求方。发布还给出 Plugin SDK 迁移方向：旧 `before_agent_start`、根级 SDK import 和若干 env-var 描述符将移除，插件应迁往现代 hook stages、聚焦 subpath import 与 manifest setup descriptor。这是典型“Agent OS 基础设施版本”：把 session、channel、subagent、gateway、plugin 的失败恢复收束成可预期生命周期，而非增加又一个 planner。
- **关键数据：**版本 `2026.6.34`；25 个 merged PR；npm 与 amd64/arm64 容器（default/slim/browser）；release commit `5c38f996…`；截至 2026-08-13 GitHub API 直查约 386,091 stars / 81,150 forks（仓库元数据会持续变化）。来源：[release 原文，2026-08-08](https://github.com/openclaw/openclaw/releases/tag/v2026.6.34)、[仓库 API](https://api.github.com/repos/openclaw/openclaw)。
- **原文链接：**https://github.com/openclaw/openclaw/releases/tag/v2026.6.34
- **影响判断：**OpenClaw 的差异化仍是把消息通道、定时任务、session、工具和子代理放进同一 Gateway 生命周期；这比“SDK 内一次 run”更像 Agent OS。威胁是云厂与模型厂正把 resume/approval/trace 做成显式 API，OpenClaw 应将现有恢复能力产品化为稳定、可测试的状态机与审计事件。

### OpenAI Agents SDK / Responses API

- **本周动态：**8 月 11 日 Python Agents SDK `v0.20.0` 是一次控制层升级。默认模型改为 `gpt-5.6-luna`，但真正重要的是 `RunState.add_input()`：应用可以在 resumed model call 前暂存 durable user input，并保留 guardrail、持久化和序列化支持。Session 层同时补上 mutation 原子性、compaction 取消后的 history 恢复、limited session 中孤儿 tool output 清理、custom session 的 run context 传递；审批不再只是布尔开关，而是绑定到 concrete invocation，并修复携带 context 的 resume 不遵守批准、二次 interrupt 后 guardrail 结果丢失等问题。MCP 本地连接覆盖 Python SDK v1/v2 的 stdio、SSE、Streamable HTTP；自定义 HTTP auth/client factory 需使用对应 major 的 HTTP type，否则可暂 pin `mcp<2`。Sandbox mount 新增 credential-exposure 显式确认并保持 redacted error contract，RunState resume 也保留 local shell output。路线非常清楚：OpenAI 不只提供 Responses 模型接口，而是在 SDK 中建立跨暂停、恢复、审批、工具和沙箱的一致运行状态。
- **关键数据：**`v0.20.0` 发布于 2026-08-11；截至 2026-08-13 API 直查约 28,587 stars / 4,483 forks；MCP v1/v2 均支持；默认模型 `gpt-5.6-luna`。来源：[release 原文](https://github.com/openai/openai-agents-python/releases/tag/v0.20.0)、[仓库 API](https://api.github.com/repos/openai/openai-agents-python)。
- **原文链接：**https://github.com/openai/openai-agents-python/releases/tag/v0.20.0
- **影响判断：**“待处理输入 + 可恢复审批 + durable session”让 SDK 更接近通用 Harness，而非轻量 helper。对 OpenClaw 的直接启发是：把用户在任务暂停期间新增的消息建模为持久输入队列，并把每次工具批准绑定到调用身份、参数摘要和恢复 checkpoint，避免批准被重放到另一次调用。

### Anthropic Claude Agent SDK / MCP

- **本周动态：**Claude Agent SDK 本周属于高频维护而非架构发布。官方 GitHub release 在 8 月 10—11 日连续给出 `v0.2.135`、`v0.2.136`，后者将 bundled Claude CLI 更新至 `2.1.228`；8 月 12 日 UTC 的 `v0.2.137` 已越过本报告上海时区截止点，故不计本周。单条 release 信息量有限，但它反映 Anthropic 的 Agent SDK 发行方式：SDK 与 Claude CLI 的运行能力紧密捆绑，用快速小版本吸收 CLI 执行层变化，而 MCP 仍作为工具互操作底座。本周未发现 Anthropic 官方博客中新的 Computer Use、remote MCP 或企业治理大公告，因此不能把日常打包更新夸大成范式变化。竞争上，这种“CLI 驱动 Agent SDK”能快速把 coding-agent 能力下沉给开发者，但状态、审批与企业审计契约的公开细粒度暂不如 OpenAI 本周 release 清晰。
- **关键数据：**`v0.2.135`（2026-08-10）、`v0.2.136`（2026-08-11），bundled Claude CLI `2.1.228`；截至 API 限流前直查仓库约 7,870 stars / 1,217 forks。来源：[官方 releases](https://github.com/anthropics/claude-agent-sdk-python/releases)、[v0.2.136](https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.136)。
- **原文链接：**https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.136
- **影响判断：**这是维护强度信号，不是新控制面信号。OpenClaw 若承接 Claude Agent SDK，应锁定 SDK/CLI 兼容矩阵，并将 CLI 子进程升级与 session checkpoint 解耦，避免快速版本节奏破坏长任务恢复。

### LangChain / LangGraph / LangSmith

- **本周动态：**LangGraph 在窗口内的 release 页面显示主包推进至 `1.2.11`，并联动 `checkpoint 4.2.0`、`checkpoint-postgres 3.1.2`、`checkpoint-sqlite 3.1.1`。关键变化包括 `add_node` 暴露 `trace_policy`，让开发者按节点选择追踪策略；checkpoint 增加 opt-in `omit_expired` 跳过过期行，并修复 delta channel history 中 plain-value seed 的写入收集及 Postgres 历史遍历。Postgres/SQLite 运行同一 conformance suite，说明 LangGraph 正把“可恢复执行”从单一实现特性收束为跨存储后端契约。CLI 侧还允许 prebuilt image 用于 `langgraph deploy`。这些并非耀眼的新 Agent 模板，却是生产 Harness 更关键的工程：节点级可观测开销控制、过期 checkpoint 清理、不同持久层语义一致。LangSmith 本周未见单独重大公告，但 trace policy 明显把编排图与观测控制进一步耦合。
- **关键数据：**LangGraph `1.2.11`；checkpoint `4.2.0`；checkpoint-postgres `3.1.2`；checkpoint-sqlite `3.1.1`。来源：[官方 releases（窗口内发布记录）](https://github.com/langchain-ai/langgraph/releases)。
- **原文链接：**https://github.com/langchain-ai/langgraph/releases
- **影响判断：**LangGraph 的护城河正在从“画图编排”迁往 checkpoint 协议与部署/追踪契约。OpenClaw 可借鉴节点/工具级 `trace_policy` 和过期状态读取策略；同时应强调自己跨 channel、cron、human interaction 的 OS 级状态，避免在纯 graph DSL 上正面同质化。

### Microsoft Agent Framework / Semantic Kernel / AutoGen

- **本周动态：**Microsoft Agent Framework 的窗口内 .NET `1.17.0` release 将 Durable Task 与 Azure Functions integrations 从核心包中抽离，并修复 handoff orchestration 不响应用户输入、declarative workflow 遇到 agent error 时未失败的问题。虽然 release 页面同时展示了 7 月 30 日 Python `1.13.0` 的大量内容（窗口外，只作背景），本周动作仍值得关注：抽离 durable/Functions 集成是在划清 Harness core 与托管执行适配层边界，减少核心编排对云运行时的耦合；对 declarative workflow 的错误传播修复则使工作流失败语义更接近生产状态机。背景上，1.13.0 已引入 reusable session stores、完整 Foundry Responses session 持久化、可 replay checkpoint、Foundry Toolbox async credentials 和 MCP skill archive progressive disclosure，本周抽包意味着这些能力开始按 core / hosting / durable integration 分层稳定，而不是继续堆进单体框架。Semantic Kernel、AutoGen 本周未发现独立基础设施级公告，主线已明显汇聚至 Agent Framework。
- **关键数据：**.NET release `1.17.0`；3 类核心变更：抽离 Durable Task/Azure Functions integrations、修复 Handoff 输入、错误 agent 使 declarative workflow fail。来源：[官方 release 原文](https://github.com/microsoft/agent-framework/releases)。
- **原文链接：**https://github.com/microsoft/agent-framework/releases
- **影响判断：**Microsoft 正把 Agent Framework 做成 Foundry/Copilot 之间的通用 Harness，同时保持托管 runtime 适配可插拔。OpenClaw 的架构参照是继续保持 core 与 channel/plugin/host integrations 的清晰边界，并确保错误、HITL、handoff 在所有适配器里共享同一状态语义。

### Databricks Mosaic AI Agent Framework / Agent Bricks

- **本周动态：**8 月 11 日 Databricks 宣布 Electric 团队加入，目标是把 WASM Postgres 带入 AI agent sandbox。官方原文给出的架构是：每个 agent 在 sandbox/browser/device 内运行 PGlite，获得进程内、超低延迟本地 context；Electric sync engine 把分布式状态持续同步回中心 Lakebase，使并行 agent 共享最新视图并避免重复、陈旧或冲突动作。PGlite 在 12 个月内从每周 100 万下载增长至 1300 万。对 Agent Bricks/Framework 而言，这不是新增 planner，而是补齐“每个执行单元的本地事务状态 + 中心治理状态”数据平面；Lakebase 提供生产 Postgres 与廉价 durable object storage，PGlite 提供边缘/sandbox 内数据库，sync 连接两者。它使 Databricks 的数据治理优势从知识检索进一步延伸到 agent 工作状态与协作状态。
- **关键数据：**PGlite 周下载量 12 个月从 1M 增至 13M；公告日期 2026-08-11；组件为 PGlite（WASM Postgres）、Electric sync、Lakebase Postgres。来源：[Databricks 官方公告](https://www.databricks.com/blog/electric-joins-databricks-bring-wasm-postgres-ai-agent-sandboxes)、[Electric 创始人说明](https://electric.ax/blog/2026/08/11/electric-joining-databricks)。
- **原文链接：**https://www.databricks.com/blog/electric-joins-databricks-bring-wasm-postgres-ai-agent-sandboxes
- **影响判断：**Databricks 下的是“Agent state is data infrastructure”这步棋，绕开通用编排框架红海。OpenClaw 可考虑把 session/workspace 的局部 SQLite 状态与团队级中心状态同步抽象化，尤其支持离线 sandbox 与多子代理并行合并，而不是只依赖共享文件。

### CrewAI（动态池补入）

- **本周动态：**CrewAI 在窗口内连续发布 `1.15.8` 至 `1.15.14` 一组版本，具备明确基础设施意义：Flow 新增 outcome、duration、HITL signals 报告，边界 hook 中止时仍发 `FlowStartedEvent`，失败时发 `FlowFailedEvent`，并把 span export 限制到自有 tracer provider；skill 使用与 interception-hook dispatch 纳入 telemetry，skills 支持 progressive disclosure；增加 `WaitTool` 暂停长任务，并拆分 coding agent 与 runtime context、加入 project ID，把 OSS 使用关联到 enterprise account。另有依赖安全修补（torch 2.13.0、gitpython 3.1.58、h2 4.4.1、aiohttp/cryptography advisories）。这组更新显示 CrewAI 正从“多 Agent 编排库”向 AMP 的运营面收敛：统一事件、失败证据、技能发现、项目归属和长任务等待，都是企业平台需要的控制数据。
- **关键数据：**窗口内版本 `1.15.8—1.15.14`；新增 Flow outcome/duration/HITL、FlowFailedEvent、WaitTool、skill telemetry、project ID。来源：[CrewAI 官方 releases](https://github.com/crewAIInc/crewAI/releases)。
- **原文链接：**https://github.com/crewAIInc/crewAI/releases
- **影响判断：**CrewAI 的竞争重点已从 agent persona 转向 runtime telemetry 与 AMP 连接。OpenClaw 应保持事件模型供应商中立，并提供 project/tenant attribution、HITL latency 与 task outcome 等标准字段，避免企业观测只能靠插件拼接。

## 静默对象简注

- **Google ADK：**本周未发现落在窗口内的明确正式 release；最近有明确日期的 `2.6.2` 为 8 月 3 日（窗口外）。背景上 ADK 2.x 已覆盖 workflow resumability、ManagedAgent、Agent Identity 和 sandbox，但本期不拿旧闻凑数。
- **Dify Agent Runtime：**最近正式 `1.16.1` 为 7 月 28 日（窗口外）；其 sandbox proxy/token auth 属重要背景，但不计本周。
- **n8n / Flowise：**逐一扫描 release 与官方检索，未发现窗口内达到 runtime、observability、enterprise deployment 门槛的强动态。

## 模块洞察

- **Harness 控制层正在标准化为“可恢复状态机 + 精确审批 + 节点级追踪 + 运行身份”四件套。**开源框架仍各有 DSL，但真正可迁移的标准件已经从 prompt/agent abstraction 下沉到 checkpoint、resume、tool invocation identity 与 trace contract；OpenClaw 的机会是把跨通道、定时、子代理的 OS 级生命周期优势，封装成同样清晰的公共契约。


---

# 2. Runtime / Session / State 执行层

> 时间窗：2026-08-06 00:00 至 2026-08-12 24:00（Asia/Shanghai）。检索与核验于 2026-08-13 完成；窗口外信息仅作背景，不计入本周动态。

## 本周模块结论
- AWS 把 AgentCore Runtime 从最长 8 小时的 serverless microVM 扩展到最长 14 天的 EC2 Instances，并允许 GPU、共享实例与客户账户内数据驻留，是本周最清晰的“Agent 从调用变成长驻进程”信号。
- OpenClaw v2026.6.34 的主线不是新增功能，而是 session 写入、provider fallback、流进度、SQLite checkpoint、Gateway/渠道恢复的系统性加固；这说明个人/多渠道 Agent 的生产瓶颈已从模型能力转向状态一致性与故障恢复。
- E2B SDK 本周集中统一 Python 控制面和 sandbox 数据面的传输栈，并在 MCP Gateway 启动失败时自动回收新建 sandbox，体现托管执行平台开始补齐资源生命周期原子性。
- Google、Microsoft 与国内三家云在窗口内未检出可由官方原文确认的 runtime/session 重大发布；竞争暂由 AWS 的长时持久计算领先，但 Google 已具备 Runtime、Sessions、Memory Bank、Sandbox 的完整产品骨架。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 有动态 | [AWS What’s New，2026-08-06](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-bedrock-agentcore-runtime-instances-generally-available/)；[官方 release notes，2026-08](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html) | 是 |
| Google Vertex AI Agent Engine / Managed Agents API | 静默 | [Gemini Enterprise Agent Platform 文档，核验 2026-08-13](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale) | 否 |
| Microsoft Foundry Hosted Agents / Agent Service | 静默 | [Hosted Agents 迁移文档，2026-07-21（背景）](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview) | 否 |
| 阿里云百炼 / Model Studio / PAI Agent 托管 | 静默 | [Model Studio 功能更新，核验 2026-08-13](https://help.aliyun.com/zh/model-studio/model-release-notes) | 否 |
| 火山方舟 Ark / Coze / Coze Studio Runtime | 静默 | [Coze Studio 部署文档，核验 2026-08-13](https://www.volcengine.com/docs/6662/1756919) | 否 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 静默 | [CloudBase AI Toolkit CHANGELOG，核验 2026-08-13](https://docs.cloudbase.net/ai/CHANGELOG) | 否 |
| OpenClaw sessions / cron / Gateway runtime | 有动态 | [v2026.6.34 release，2026-08-08](https://github.com/openclaw/openclaw/releases/tag/v2026.6.34)；[GitHub API，核验 2026-08-13](https://api.github.com/repos/openclaw/openclaw) | 是 |
| E2B / Modal / Daytona（托管执行与生命周期） | 有动态（E2B）；Modal/Daytona 静默 | [E2B 2.38.3，2026-08-10](https://github.com/e2b-dev/E2B/releases/tag/e2b%402.38.3)；[Python SDK 2.38.0，2026-08-10](https://github.com/e2b-dev/E2B/releases/tag/%40e2b/python-sdk%402.38.0) | 是（E2B） |

## 深度笔记

### AWS Bedrock AgentCore Runtime
- 本周动态：AWS 于 8 月 6 日将 AgentCore **Runtime Instances** 推至 GA。它不是简单把容器配额调大，而是引入 capacity provider：客户指定操作系统、允许的 EC2 实例类型、网络和存储，AgentCore 负责 provisioning、patching、scaling 与 teardown；agent 仍用相同部署/调用接口。与默认 serverless microVM 的最长 **8 小时** session 相比，Instances 支持最长 **14 天**持久 session，覆盖 GPU accelerated、memory optimized、compute optimized 实例，多 agent 还可共享一台实例。官方 release notes 进一步明确：计算运行在客户自己 AWS 账户内，数据留在账户内，可使用 Savings Plans 与 On-Demand Capacity Reservations，首发支持 Linux x86_64/arm64。同期 Runtime 数据面共享配额由 200 TPS 提升至 **1,000 TPS/account**，新 session 创建统一为 **25 TPS/account**。路线判断很明确：AWS 正把 Agent runtime 切成“突发型无服务器执行”和“持续型专属实例”两档，用统一 lifecycle API 吸收过去需要 EKS/EC2 自建的长任务、GPU 与状态驻留场景。
- 关键数据：session 14 天（Instances）/8 小时（microVM）；9 个首发区域；数据面 1,000 TPS（原 200）；新 session 25 TPS/account；来源：[AWS What’s New，2026-08-06](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-bedrock-agentcore-runtime-instances-generally-available/)、[AgentCore release notes，2026-08](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html)。
- 原文链接：[AWS What’s New](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-bedrock-agentcore-runtime-instances-generally-available/)；[官方 release notes](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html)。
- 影响判断：Agent 的生命周期上限被显式产品化后，长时研究、代码构建、数据流水线不必再伪装成一串短请求。对 OpenClaw 的参照是：现有 session/cron/Gateway 可作为控制面，但若要承载企业级长任务，应补一个可插拔 capacity-provider 抽象，将任务状态与 microVM、EC2、Kubernetes 或第三方 sandbox 解耦，并暴露统一租约、续期、配额和成本指标。

### Google Vertex AI Agent Engine / Managed Agents API
- 本周动态：本周无重大公开动态。官方现行信息架构已将产品重组为 Gemini Enterprise Agent Platform，并清晰列出 Agent Runtime、Sessions、Memory Bank、Sandbox、Agent Gateway 与评估模块；这是近期竞争背景而非本周发布。其价值在于 Google 已把 session 从 SDK 附属状态提升为可通过控制台/API 管理且可用 IAM Conditions 控制访问的资源，但窗口内未发现新的 GA、区域、价格或 API 变更，故不以文档页面更新冒充新闻。
- 关键数据：—。
- 原文链接：[Agent Platform Scale 文档](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale)。
- 影响判断：Google 的强项是模块齐全和 IAM 原生，弱点是本周缺少像 AWS 14 天实例那样清晰的 runtime 规格跃迁。OpenClaw 可借鉴其将 sessions 独立成一等资源、与 memory 分层并施加条件式访问控制的设计。

### Microsoft Foundry Hosted Agents / Agent Service
- 本周动态：本周无重大公开动态。近两周外背景是 Microsoft 要求旧 Hosted Agents preview backend 的部署迁移到新版，旧部署支持截至 2026-08-20；该通知发布于 7 月 21 日，不计入本周动态。窗口内未检出可确认的新 runtime 规格、session 生命周期或托管价格变化。
- 关键数据：旧 backend 支持截止 2026-08-20（背景，来源：[迁移文档，2026-07-21](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview)）。
- 原文链接：[Hosted Agents 迁移文档](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/migrate-hosted-agent-preview)。
- 影响判断：强制 backend 迁移表明 Hosted Agents 仍在快速收敛运行时契约。对 OpenClaw 的提醒是 runtime schema 与 state migration 必须版本化，并为长任务提供旧版本兼容期和可验证的迁移工具。

### 阿里云百炼 / Model Studio / PAI Agent 托管
- 本周动态：本周无重大公开动态。已核验百炼/Model Studio 功能更新页与 Agent 应用文档，窗口内未找到明确指向 session、异步任务、cron 或托管 runtime 生命周期的官方发布；不采用搜索摘要中的泛化“Agent 平台升级”描述。
- 关键数据：—。
- 原文链接：[Model Studio 功能更新](https://help.aliyun.com/zh/model-studio/model-release-notes)；[应用类型文档](https://www.alibabacloud.com/help/zh/model-studio/application-introduction)。
- 影响判断：国内模型平台仍较多强调应用构建与模型服务，runtime 的持久 session、恢复语义和租约规格公开度不及 AWS。OpenClaw 若对接百炼，应把模型 API 与执行 runtime 分离，避免把模型可用性误当作任务可恢复性。

### 火山方舟 Ark / Coze / Coze Studio Runtime
- 本周动态：本周无重大公开动态。官方可确认的现有能力包括 Coze Studio 应用可部署到函数服务并连接火山方舟模型，但窗口内未找到 runtime/session 生命周期层面的新版本、GA 或配额公告。ArkClaw 相关 4 月材料属于旧背景，不纳入本周。
- 关键数据：—。
- 原文链接：[Coze Studio 函数服务部署文档](https://www.volcengine.com/docs/6662/1756919)。
- 影响判断：火山/字节的优势仍在 Agent 应用与开源平台联动，执行层公开规格不足。OpenClaw 可关注其托管 OpenClaw 路径，但应要求明确 session 数据归属、失败重放、容器隔离和长期任务计费边界。

### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit
- 本周动态：本周无重大公开动态。CloudBase CHANGELOG 显示既有 2.0.0 能支持 LangChain、LangGraph、CrewAI，并可把 Agent 运行在云函数或云托管，但版本日期为 2026-01-02，属于背景。窗口内未发现新的 session/state/cron 发布。
- 关键数据：CloudBase AI Toolkit 2.0.0（背景，2026-01-02）；来源：[官方 CHANGELOG](https://docs.cloudbase.net/ai/CHANGELOG)。
- 原文链接：[CloudBase AI Toolkit CHANGELOG](https://docs.cloudbase.net/ai/CHANGELOG)。
- 影响判断：双运行载体提供部署便利，但尚未看到统一 session contract。OpenClaw 与 CloudBase 集成时可把云函数用于短任务、云托管用于 Gateway 常驻，并自行维护跨载体 checkpoint 与幂等投递。

### OpenClaw sessions / cron / Gateway runtime
- 本周动态：OpenClaw 于 8 月 8 日发布 extended-stable **v2026.6.34**，完整记录覆盖 25 个 merged PR。发布重点是运行态可靠性而非功能堆叠：retained session writes、provider fallback、stream progress 与 stdio failure 不再静默终止活动任务；pending channel work 可在 recovery 后恢复，ack 变为幂等；SQLite checkpoints、workspace reads、Gateway process signalling 与 plugin HTTP response 对瞬时主机故障更耐受。安全侧同时封堵 sandboxed browser route、DNS target、custom browser origin、loopback provider endpoint 的不安全访问路径。GitHub API 直查在 8 月 13 日显示约 **386,091 stars / 81,150 forks**，窗口内 commits API 返回上限 100 条，说明活跃度很高（“100”仅为本次分页返回量，不等同完整提交数）。这批改动透露 OpenClaw 的 runtime 定位：不是单一云容器，而是跨 channel、provider、host 与 plugin 的持久 Gateway；其竞争壁垒会取决于 session 写入原子性、恢复协议和 delivery evidence，而不只是 cron 数量。
- 关键数据：v2026.6.34，2026-08-08；25 merged PR；约 386,091 stars、81,150 forks（[GitHub API，2026-08-13](https://api.github.com/repos/openclaw/openclaw)）。
- 原文链接：[v2026.6.34 release](https://github.com/openclaw/openclaw/releases/tag/v2026.6.34)；[GitHub repo API](https://api.github.com/repos/openclaw/openclaw)。
- 影响判断：本周修复正中长期 Agent 的真实故障面，尤其“状态已写但回复未送达”“channel 重连后重复确认”“流中断被误判完成”。下一步应把这些恢复语义升级为公开的 session state machine：明确 queued/running/yielded/finalizing/delivered/failed，各迁移附幂等键与 checkpoint；同时借鉴 AWS 把 compute lease 做成可替换后端。

### E2B（Modal / Daytona 对照）
- 本周动态：E2B 在 8 月 7—10 日连续发布 SDK，最新 JS **e2b@2.38.3** 在 MCP Gateway 启动失败时会杀掉刚创建的 sandbox，并把失败提升为 `SandboxError` / `SandboxException`，附带 `Failed to start MCP gateway: <stderr>`，修复了控制面失败后计算资源泄漏这一典型生命周期漏洞。Python SDK **2.38.0** 则将 sandbox lifecycle/list/template/volume 控制面、envd 文件传输与 health check 逐步统一到基于 Rust reqwest/hyper 的 pyqwest transport；连接池从 per-thread/per-event-loop 改为 process-wide per proxy，并把 `request_timeout` 统一为整次 API/传输 deadline。流式下载默认总时长仍可不设上限，但有每 chunk 重置的 60 秒 idle read timeout；连接失败默认重试 3 次。GitHub API 直查为约 **13,369 stars / 985 forks**，窗口内 17 个 commits。Modal 仓库窗口内活跃但无可核验的产品 release；Daytona 无窗口内 commit/release，故仅 E2B 深写。
- 关键数据：e2b@2.38.3、Python SDK 2.38.0（2026-08-10）；stream idle timeout 60 秒；`E2B_CONNECTION_RETRIES` 默认 3；约 13,369 stars/985 forks、窗口内 17 commits（[GitHub API，2026-08-13](https://api.github.com/repos/e2b-dev/E2B)）。
- 原文链接：[e2b@2.38.3](https://github.com/e2b-dev/E2B/releases/tag/e2b%402.38.3)；[Python SDK 2.38.0](https://github.com/e2b-dev/E2B/releases/tag/%40e2b/python-sdk%402.38.0)；[GitHub API](https://api.github.com/repos/e2b-dev/E2B)。
- 影响判断：自动回收失败 sandbox 是小改动，却体现“创建 sandbox + 启动工具网关”应被视为一个事务。OpenClaw 若把 E2B/Modal/Daytona 作为执行后端，应在 Gateway 侧实现 create→bootstrap→health→admit 的两阶段流程，只有健康检查通过才把 session 标为 running；任何失败都执行幂等 teardown，并记录可审计 stderr。

## 数据来源与核验说明
- 官方原文：AWS What’s New/开发文档、Google Cloud 文档、Microsoft Learn、阿里云/火山/腾讯云官方文档、GitHub Releases。
- GitHub 数字均通过仓库 API 于 2026-08-13 直查；数字会持续变化，仅代表核验时快照。
- 关键 AWS session 时长与运行形态由 What’s New 和 release notes 两个官方页面交叉核验；OpenClaw/E2B 版本与变更由 release 原文和 GitHub API 交叉核验。

## 模块洞察
- Runtime / Session / State 正从“无服务器 API 调用”分化为短突发 microVM 与长驻专属实例两档；真正的标准件不再只是容器，而是带租约、checkpoint、幂等恢复、可观测配额和故障回收的 **session lifecycle contract**。AWS 正在云厂收编这一层，OpenClaw 则在跨渠道状态恢复上具备差异化，但需要把隐含恢复语义产品化、后端抽象化。


---

# 3. Sandbox / Computer Use / Browser 执行环境层

> 时间窗：2026-08-06 00:00 至 2026-08-12 24:00（Asia/Shanghai）。窗口外资料仅作背景，不计入本周动态。

## 本周模块结论
- Browserbase 在 8 月 10 日发布 Stagehand v4，把 agent 执行逻辑放进浏览器扩展以降低 CDP 往返和竞态，并声称相较 Playwright 快 2 倍、token 低约 80%；browser agent SDK 正从“给测试框架加自然语言”转向 agent-native runtime。
- E2B 的本周更新虽属 patch，却直接处理 MCP Gateway bootstrap 失败后的 sandbox 泄漏，并统一跨线程/事件循环的传输与超时语义，说明 sandbox 竞争进入资源回收、传输稳定性和生命周期原子性阶段。
- OpenClaw extended-stable 同期强化 browser/sandbox/exec/MCP 的输入与网络边界，显示自托管 Agent OS 的执行安全正在从工具 allowlist 走向 DNS、origin、loopback 与路由级的纵深防御。
- OpenAI、Anthropic、AWS、Azure、Google 的现有能力均可核验，但窗口内未检出新的 computer-use/sandbox 发布；云厂的共同形态已是“模型动作循环 + 隔离浏览器/容器 + session state”，差异集中在回放、策略、网络与运行时可定制性。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| E2B | 有动态 | [e2b@2.38.3，2026-08-10](https://github.com/e2b-dev/E2B/releases/tag/e2b%402.38.3)；[Python SDK 2.38.0，2026-08-10](https://github.com/e2b-dev/E2B/releases/tag/%40e2b/python-sdk%402.38.0) | 是 |
| Browserbase / Stagehand | 有动态 | [Browserbase Changelog，2026-08-10](https://www.browserbase.com/changelog)；[Stagehand GitHub，核验 2026-08-13](https://github.com/browserbase/stagehand) | 是 |
| Daytona | 静默 | [GitHub releases，核验 2026-08-13](https://github.com/daytonaio/daytona/releases) | 否 |
| Modal | 静默 | [Modal client GitHub，核验 2026-08-13](https://github.com/modal-labs/modal-client) | 否 |
| OpenAI Computer Use / Browser / Code Interpreter | 静默 | [Computer use 官方文档，核验 2026-08-13](https://developers.openai.com/api/docs/guides/tools-computer-use) | 否 |
| Anthropic Computer Use | 静默 | [Claude release notes，2026-08-06（本周条目非 Computer Use）](https://support.claude.com/en/articles/12138966-release-notes) | 否 |
| AWS AgentCore Browser / Code Interpreter | 静默 | [Code Interpreter 文档，核验 2026-08-13](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html) | 否 |
| Azure Browser Automation / Code Interpreter / Playwright Workspaces | 静默 | [Playwright Workspaces 文档，核验 2026-08-13](https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/overview-what-is-microsoft-playwright-workspaces) | 否 |
| Google Code Execution / Managed Agents Sandbox | 静默 | [Code Execution 文档，核验 2026-08-13](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/code-execution-overview) | 否 |

## 深度笔记

### E2B
- 本周动态：E2B 在本周发布 JS **e2b@2.38.1/2.38.2/2.38.3** 与 Python SDK **2.37.1/2.38.0**。2.38.3 最关键的执行环境变化是：创建 sandbox 后若 MCP Gateway 启动失败，SDK 会立即 kill 新 sandbox，并把裸 command-exit error 转换为带 stderr 的 `SandboxError`（JS）或 `SandboxException`（Python）。这使“计算环境创建 + agent 工具入口 bootstrap”具有接近事务的失败回滚语义，避免孤儿 sandbox 持续计费或残留可访问面。Python 2.38.0 则把 lifecycle/list/templates/volumes 控制面和 envd 文件/健康检查流量统一到 pyqwest（Rust reqwest/hyper）传输，单个模块 client 可跨线程和 event loop，共享 process-wide/per-proxy 连接池。非流式请求的 timeout 改成全调用 deadline；流式下载默认无总期限，但 60 秒 idle timeout 每个 chunk 重置。技术路线判断：E2B 不只卖“能跑代码的容器”，而是在把 sandbox、MCP gateway、文件传输、PTY/RPC 和健康检查收敛为一致的 agent computer 生命周期。
- 关键数据：e2b@2.38.3、Python SDK 2.38.0，均发布于 2026-08-10；stream idle timeout 60 秒；连接失败默认重试 3 次；GitHub 约 13,369 stars / 985 forks，窗口内 commits API 返回 17 条（[GitHub API，2026-08-13](https://api.github.com/repos/e2b-dev/E2B)）。
- 原文链接：[e2b@2.38.3 release](https://github.com/e2b-dev/E2B/releases/tag/e2b%402.38.3)；[Python SDK 2.38.0 release](https://github.com/e2b-dev/E2B/releases/tag/%40e2b/python-sdk%402.38.0)；[仓库 API](https://api.github.com/repos/e2b-dev/E2B)。
- 影响判断：对 OpenClaw 而言，第三方 sandbox 不应仅暴露 `create/exec/kill`，还应定义 bootstrap health gate、失败自动回收、错误类型和 stderr 证据。建议在 tool runtime 中增加 sandbox lease id 与 teardown receipt，并把 MCP server 启动和权限策略校验纳入 session admission；只有全部成功才允许模型看到工具。

### Browserbase / Stagehand
- 本周动态：Browserbase Changelog 标注 **2026-08-10** 推出 Stagehand v4。官方称 Playwright 是为测试设计，而 v4 是 browser agents 的 SDK：改进 context management、self-healing actions 与 iframe 支持，并把 Stagehand 作为 extension 放进浏览器。这样做把部分 agent 运行逻辑移近页面，减少远端 SDK—CDP—浏览器之间的 round trip，也降低潜在 CDP race condition。Browserbase 给出的内部 benchmark 是 **2× Playwright 速度、约 80% token 节省**；这是厂商自测，未见独立 benchmark，需保留口径。窗口内对应 GitHub 仓库有 16 个 commits，8 月 13 日 API 直查约 **23,924 stars / 1,647 forks**，但 v4 尚未在抓取到的 GitHub Releases 列表形成同日正式 tag，因此产品 changelog 与开源 release 节奏存在差异。路线意义大于版本号：Browserbase 正把 context extraction、恢复动作、iframe 与浏览器内执行打包为 runtime primitive，而不再只提供远程 Chromium。
- 关键数据：Stagehand v4 发布日 2026-08-10；官方自测 2× faster、约 80% more token efficient；GitHub 约 23,924 stars/1,647 forks、窗口内 16 commits（[GitHub API，2026-08-13](https://api.github.com/repos/browserbase/stagehand)）。benchmark 仅有厂商单源，未独立复现。
- 原文链接：[Browserbase Changelog](https://www.browserbase.com/changelog)；[Stagehand GitHub](https://github.com/browserbase/stagehand)；[GitHub API](https://api.github.com/repos/browserbase/stagehand)。
- 影响判断：v4 把 browser agent 的“手”下沉到浏览器进程，而模型和策略仍可在远端，可能形成 browser-side runtime 标准件。OpenClaw 的 Browser Control 当前优势是跨 profile/session 的统一控制；应借鉴 extension-side execution 降低动作延迟，但不能只追速度，需保留 domain policy、下载隔离、session replay、动作证据与高风险点击确认。

### Daytona
- 本周动态：本周无重大公开动态。GitHub releases 最新可见正式版本仍为 v0.190.0（2026-06-23，背景），本次窗口查询未检出 release 或 commit；仓库约 72,023 stars / 5,666 forks（8 月 13 日首次 API 快照）。该数字仅说明存量社区热度，不构成本周发布。
- 关键数据：v0.190.0（背景，2026-06-23）；约 72,023 stars/5,666 forks（核验快照）。
- 原文链接：[Daytona releases](https://github.com/daytonaio/daytona/releases)；[GitHub API](https://api.github.com/repos/daytonaio/daytona)。
- 影响判断：Daytona 的 cloud workspace/sandbox 定位仍与 E2B 直接重叠，但本周缺少可验证的新 lifecycle 信号。OpenClaw 可保持适配器层，不应绑定其当前 API 作为唯一执行契约。

### Modal
- 本周动态：本周无重大公开动态。`modal-labs/modal-client` 窗口内有 29 个 commits，但没有可由官方 changelog/release 原文确认的 sandbox、long-running job 或 agent task 产品级发布，因此不以 commit 活跃度替代发布结论。仓库本次 API 快照约 501 stars/114 forks；这不是 Modal 平台整体采用量。
- 关键数据：窗口内 29 commits；约 501 stars/114 forks（仅 client repo，GitHub API 2026-08-13）。
- 原文链接：[Modal client GitHub](https://github.com/modal-labs/modal-client)；[GitHub API](https://api.github.com/repos/modal-labs/modal-client)。
- 影响判断：Modal 的差异仍是 serverless container/GPU 与 scale-to-zero，而非 browser-native observability。对 OpenClaw 更适合作为批量代码/GPU 后端，浏览器任务则需要另配 replay、domain policy 和 session artifact 层。

### OpenAI Computer Use / Browser / Code Interpreter
- 本周动态：本周无重大公开动态。官方现行 Computer Use 文档确认三种 harness：Responses API 内建 `computer` tool、自定义 Playwright/Selenium/VNC/MCP harness、以及把视觉与 DOM 操作混合的 code-execution harness；文档明确建议隔离 browser/VM、高影响动作 human-in-the-loop、页面内容视为不可信输入。窗口内搜索到的 8 月 6 日 ChatGPT 更新为模型可靠性条目，未确认 computer use 执行环境新增能力，故不深写为动态。
- 关键数据：示例 viewport 1280×720；其余无本周新数据。
- 原文链接：[OpenAI Computer Use guide](https://developers.openai.com/api/docs/guides/tools-computer-use)。
- 影响判断：OpenAI 明确把“模型动作协议”和“执行 harness”解耦，为 Browserbase、OpenClaw 或自建 VM 留出位置。OpenClaw 应坚持 execution-side policy，而不能假设模型拒绝即可阻止 prompt injection 或高风险动作。

### Anthropic Computer Use
- 本周动态：本周无 Computer Use 重大公开动态。Claude release notes 的 8 月 6 日条目是 Enterprise skill/plugin security scanning beta，不是 Computer Use；搜索摘要把旧 computer-use 能力拼接到本周日期，已通过官方全文排除。最近相关产品背景仍是 3 月的 Cowork/Claude Code computer use research preview，不纳入本周。
- 关键数据：—。
- 原文链接：[Claude release notes](https://support.claude.com/en/articles/12138966-release-notes)。
- 影响判断：这是“不得由搜索摘要下结论”的典型案例。OpenClaw 的周更情报应把对象级日期与段落绑定，避免页面整体更新时间造成旧条目误报。

### AWS AgentCore Browser / Code Interpreter
- 本周动态：本周无该子模块重大公开动态。现行官方文档确认 Code Interpreter 是 containerized sandbox，支持 Python/JavaScript/TypeScript、CloudTrail、session properties 和 network modes；inline upload 最大 100 MB，经 terminal/S3 可到 5 GB，默认执行 15 分钟、可延长到 8 小时。这些是现有规格，不是窗口内新发布。8 月 AgentCore 的本周主动态是 Runtime Instances，已归模块 2。
- 关键数据：inline 100 MB、S3 5 GB；默认 15 分钟、最长 8 小时（官方文档，核验 2026-08-13）。
- 原文链接：[AgentCore Code Interpreter](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html)。
- 影响判断：AWS 的优势是 execution role、CloudTrail 与 VPC/网络模式形成企业边界。OpenClaw 的 code tool 若面向企业，应提供类似的 per-session execution identity、网络模式和操作审计，而非仅依赖宿主机用户权限。

### Azure Browser Automation / Code Interpreter / Playwright Workspaces
- 本周动态：本周无重大公开动态。Playwright Workspaces 仍定位为托管 E2E 测试：测试代码留在 client/CI，浏览器交互在 Azure 云端，支持 Linux/Windows、多个现代浏览器、并行远程浏览器与区域内数据驻留；官方文档元数据日期在 2025 年，不计入本周。窗口内未发现 Agent Service Browser Automation 或 Code Interpreter 的新 GA/preview。
- 关键数据：—。
- 原文链接：[Playwright Workspaces overview](https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/overview-what-is-microsoft-playwright-workspaces)。
- 影响判断：Azure 的 browser 基础设施仍带明显测试平台血统，缺少 Browserbase 那样 agent context/self-healing/runtime 叙事。OpenClaw 若对接它，应自行补 session replay 与 agent policy，并保留代码在本地的合规优势。

### Google Code Execution / Managed Agents Sandbox
- 本周动态：本周无可确认的新发布。Google 当前 Code Execution 可在 **1 秒内**创建并执行，单次 request/response 文件输入输出总计上限 **100 MB**，sandbox state 可保持最长 **14 天**且 TTL 可配置；默认 limited filesystem、无网络，并支持 create/get/list/execute 及跨多次执行保留 state。文档还表明 Agent 可运行在任意位置，不必部署到 Google Agent Platform。这些规格用于赛道横向对照，未找到明确窗口发布日期，故不冒充本周新闻。
- 关键数据：启动/执行 under 1 second；I/O 100 MB；state/TTL 最长 14 天（[官方文档，核验 2026-08-13](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/code-execution-overview)）。
- 原文链接：[Google Code Execution](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/code-execution-overview)。
- 影响判断：Google 把长 TTL 的 stateful sandbox 独立于 agent hosting，是很强的模块化信号。OpenClaw 可参考“agent anywhere, sandbox managed”的边界，将 code execution 作为远程能力并通过 session id 续接，而不是与 Gateway 进程共命运。

## GitHub / Web 热度补漏

### OpenClaw browser / sandbox security（补漏对象）
- 本周动态：Hot scan 的 browser agent runtime 查询未出现高热、窗口内有 release 且可达到正文标准的新 sandbox 项目；`frago` 仅 60 stars，其他多为低星原型，均过滤。反而固定名单外的 OpenClaw v2026.6.34 在本模块有明确基础设施信号：sandboxed browser routes、trusted DNS targets、custom browser origins 与 loopback provider endpoints 拒绝不安全访问路径；browser、sandbox、exec、MCP 与 secret-resolution 输入错误不再导致 host process 崩溃。这一 extended-stable 发布于 8 月 8 日，属于窗口内官方 release，故作为补漏深写而非依赖热搜摘要。
- 关键数据：v2026.6.34；25 merged PR；发布 2026-08-08；约 386,091 stars/81,150 forks（[GitHub API，2026-08-13](https://api.github.com/repos/openclaw/openclaw)）。
- 原文链接：[OpenClaw v2026.6.34](https://github.com/openclaw/openclaw/releases/tag/v2026.6.34)。
- 影响判断：browser agent 的安全边界不能停留在“是否允许 browser 工具”，还要约束 DNS 解析结果、origin、loopback、代理和 sandbox route。OpenClaw 本周领先点是把这些 host-level 边界纳入维护版；下一步应将拒绝事件结构化进 trace/replay，便于企业审计“模型想访问什么、策略为何拦截”。

## 数据来源与核验说明
- 所有“有动态”对象均读取官方 changelog/release 全文；GitHub stars/forks/releases/commit window 由 GitHub API 或官方 Releases 直查。
- Browserbase 的 2×/80% 为厂商 benchmark，已明确标为单源、未独立复现；不将其当作跨平台客观结论。
- Anthropic 搜索摘要与官方全文不一致时，以按日期分段的官方 release notes 为准；未确认信息不写入动态。
- GitHub API 后续查询触发 403，已使用本轮限流前取得的直查快照；无法再次刷新者均标注核验时间，不补造数据。

## 模块洞察
- Sandbox / Browser 层正在同时发生两种标准化：上层是模型无关的动作/工具协议，下层是带 state、回放、网络策略、身份与原子回收的托管 computer。Browserbase 代表 agent-native 浏览器内 runtime，E2B 代表通用 sandbox 生命周期，云厂则依靠 IAM/审计收编企业场景；OpenClaw 的机会是以 Gateway 统一多后端并保留用户可控边界，但必须把网络策略、lease/cleanup 和 replay evidence 提升为一等能力。


---

## 4. Tool Gateway / Protocol / Integration 工具层

**统计窗口：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）**

### 本周模块结论
- 本周最强基础设施信号来自 AWS：AgentCore Gateway 把限流从传统 API 网关的“接口级配额”推进到按 OAuth/IAM 主体、目标类型、推理 token 与长连接并发进行控制，工具网关正在成为 Agent 成本、可用性与多租户公平性的统一执行点。
- Arcade 围绕 7 月 28 日 MCP 大版本发布迁移指南，明确新规范的无状态化、refresh-token 安全缺口修补、扩展机制与破坏性变更；新闻发生在本周，但协议发布本身属于背景、非本周。其商业路线是让 runtime 双栈兼容新旧协议，把迁移复杂度转化为托管网关价值。
- Composio 与 Nango 本周都把竞争焦点从“连接器数量”上移到执行边界：身份绑定、凭据注入、工具白名单/撤销、租户隔离、审计和部署边界。协议兼容正快速商品化，真正的差异转向治理与可取证性。
- 对 OpenClaw 而言，机会不是再造连接器目录，而是在现有 Gateway/tool runtime 上补齐主体级配额、协议版本协商、连接级权限、审批、可导出审计，并允许接入 Arcade、Composio、Nango、Pipedream 等外部执行平面。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP | 静默（7 月 28 日规范大版本仅作背景） | Arcade 对本次规范变更的本周迁移说明，2026-08-11：https://www.arcade.dev/blog/complete-guide-mcp-26/ | 否（在 Arcade 中分析） |
| A2A | 静默 | 官方站点及 Google 官方域窗口检索未发现重大公开动态，检索截至 2026-08-13 | 否 |
| Composio | 有动态 | 官方安全平台综述，2026-08-10：https://composio.dev/content/best-ai-security-platforms | 是 |
| Arcade | 有动态 | 官方《Complete Guide to MCP ’26》，2026-08-11：https://www.arcade.dev/blog/complete-guide-mcp-26/ | 是 |
| Nango | 有动态 | 官方安全工具调用平台评测（材料审阅日期 2026-08-07）：https://nango.dev/blog/best-secure-api-integration-platforms-ai-agents | 是 |
| Pipedream Connect | 静默 | 官方博客及文档窗口检索未发现重大公开动态，检索截至 2026-08-13 | 否 |
| AWS AgentCore Gateway | 有动态 | AWS What’s New，2026-08-06：https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/ | 是 |
| Google Agent Gateway | 静默 | 官方 release notes 显示 Agent Gateway GA 为 2026-06-18，非本周：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes | 否 |
| Microsoft Toolbox / MCP-compatible endpoint | 静默 | 本周未发现新增发布；7 月 28 日 .NET MCP Skills 内容仅为背景：https://devblogs.microsoft.com/agent-framework/discover-agent-skills-from-mcp-servers-in-net/ | 否 |

### 动态池状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| TrueFoundry MCP Gateway | 有动态（赛道盘点/产品定位信号） | 官方博客《10 Best MCP Gateways in 2026》，页面更新线索 2026-08-11：https://www.truefoundry.com/blog/best-mcp-gateways | 是 |
| Smithery | 静默 | Arcade 收购公告为 2026-08-05，早于窗口，不计本周：https://www.arcade.dev/blog/smithery-joins-arcade | 否 |
| Zapier MCP / 官方 SaaS MCP server / OpenAPI-to-MCP 项目 | 静默 | 窗口检索未发现达到基础设施级阈值的官方新发布 | 否 |

### 深度笔记

#### AWS AgentCore Gateway
- 本周动态：AWS 在 8 月 6 日为 Amazon Bedrock AgentCore 增加两项控制，其中直接落在工具网关层的是 AI traffic rate limiting。它不是只对某条 HTTP API 设置统一 QPS，而是让 Gateway owner 按 OAuth 或 AWS IAM 所表达的用户/用户组身份制定规则，并跨 Gateway 所连接的三类目标——tools、models、agents——执行配额。官方明确列出三种计量维度：请求数适用于全部 target type；token 数适用于 inference target；concurrent connections 用于限制长时间存活的并发 session。由此可以同时解决下游服务保护、成本封顶与多租户公平分配。同期发布的 temporal policies 属于相邻的授权控制：可根据 session 内先前动作强制工作流顺序、要求当前参数精确匹配前序工具输出、在高权限动作前要求人工批准，并约束数据新鲜度。两者合在一起，说明 Agent gateway 已从协议转换器演化为带状态策略、主体识别和资源治理的执行控制面；AWS 正把传统 API gateway 的成熟运营能力改造成适配 tool/model/agent 混合流量的托管产品。
- 关键数据：发布日期 2026-08-06；限流覆盖 3 类目标（tools/models/agents）；支持 requests、inference tokens、concurrent connections 3 类度量；身份作用域为 OAuth 或 AWS IAM。来源：https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/（2026-08-06）。
- 原文链接：https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/
- 影响判断：这会提高企业对统一 Agent gateway 的预期基线：仅有 MCP/OpenAPI 转换已不够，必须同时提供身份维度限流、推理成本控制、长连接保护和跨调用策略。OpenClaw 可借鉴其“主体 × 目标 × 度量”策略模型，在 Gateway 层为 session、工具和外部模型设置统一预算，并让审批结果成为后续工具调用的可验证前置条件。

#### Arcade
- 本周动态：Arcade 于 8 月 11 日发布《Complete Guide to MCP ’26》，针对 MCP 在 7 月 28 日发布的“大版本”给出迁移说明。必须区分时间：MCP 规范变化是背景、非本周；本周动态是 Arcade 将这些变化产品化为迁移指南与 runtime 兼容承诺。官方列出的关键变化包括协议转向 stateless、修补 refresh-token gap、引入官方 extensions，以及会影响 server/client 的 breaking changes。无状态化移除对 session ID 的依赖后，可更自然地做 round-robin load balancing 与 scale-to-zero serverless；代价是 client、harness 与 server 都要处理新的握手/能力信息和上线首日流量行为。Arcade 称其 runtime 可在首日同时“speaks both versions”，并在底层 transport 变化时保持 authorization、security、governance 不变，让客户不必协调 server 与 client 一次性切换。官方还称 MCP 官方 SDK 已超过 9700 万次月下载，但该数字由 Arcade 引述，未在本次核验中获得第二独立官方来源，因此只作为厂商口径。路线判断上，Arcade 正将协议升级风险、双栈兼容和授权稳定性打包为 runtime 的购买理由。
- 关键数据：文章发布日期 2026-08-11；MCP 规范大版本日期 2026-07-28（背景，非本周）；Arcade 口径称官方 SDK 月下载量超过 9700 万次；指南分为 explainer、how-to 和 Arcade 双协议 runtime 三部分。来源：https://www.arcade.dev/blog/complete-guide-mcp-26/（2026-08-11）。
- 原文链接：https://www.arcade.dev/blog/complete-guide-mcp-26/
- 影响判断：MCP 进入生产期后，版本协商、双栈兼容、迁移与负载均衡会比“能否连上 server”更重要。OpenClaw 应明确记录 MCP protocol version 与 capabilities，建立兼容性测试矩阵和灰度迁移机制；同时可把 Arcade 作为外部授权执行层接入，而不把 OAuth token 暴露给模型或普通 session。

#### Composio
- 本周动态：Composio 8 月 10 日发布 AI security 平台综述，把自家 MCP Gateway 明确定位为“agent access & tool security”层，而不是单纯连接器集合。其官方表述给出一组值得跟踪的企业控制：为不同团队创建独立 MCP endpoint；按 toolkit 与 action 粒度限制工具面；支持 SSO、SCIM；记录 execution audit logs。文章认为 Agent 的风险已从坏回答扩展为数据库写入、OAuth 请求和外部系统动作，因此 gateway 必须控制“哪些工具可访问、哪些动作可执行、用户如何认证”。同一官方资料进一步描述 Gateway 可记录 user、team、tool、action、result，但不保存 request/response content；这在隐私最小化方面有优势，却也意味着完整事故取证需要应用侧另存必要上下文。Composio 的路线很清楚：用大量预置集成做获客基础，把企业价值上移到动态工具路由、团队隔离、身份生命周期与审计。值得注意的是这是一篇厂商自述和竞品综述，不应把其对市场成熟度的判断当作独立评测；但产品能力描述仍构成本周官方定位变化的有效信号。
- 关键数据：文章 schema 标示发布日期 2026-08-10；官方资料称 MCP Gateway 面向 1,000+ app integrations，并支持 SAML、OIDC、SCIM、团队级 endpoint 及 action-level restriction。来源：https://composio.dev/content/best-ai-security-platforms（2026-08-10）；产品背景：https://composio.dev/content/mcp-connectors（2026-08-05，窗口外一天，仅作背景）。
- 原文链接：https://composio.dev/content/best-ai-security-platforms
- 影响判断：连接器目录会逐渐同质化，企业采购将看主体绑定、工具裁剪、审计语义和数据留存边界。OpenClaw 若接入 Composio，应把其 endpoint 当作受治理的外部工具域，同时在本地保留 session/审批/调用因果链，弥补上游不保存 payload 带来的取证缺口。

#### Nango
- 本周动态：Nango 本周发布面向安全 Agent tool calling 的六平台比较，并明确说明其材料在 2026 年 8 月 7 日完成账户测试、公开文档与仓库审阅。文章将一次工具调用拆成两个安全边界：模型决定请求什么动作，integration runtime 选择客户 connection 并把 credential 注入 API call；任一边界错误都可能泄露 token、执行过宽动作或串租户。Nango 据此用 connection identity、credential boundary、token lifecycle、tool scope、tenant boundary、execution evidence、governance、deployment 等维度比较 Nango、Arcade、Paragon、Composio、Pipedream Connect、Zapier MCP。对自家产品，官方称支持 900+ APIs、6,000+ 预制 tool calls，OAuth/API key/JWT/ID-JAG/MCP Auth，凭据以 AES-256-GCM 静态加密，并支持 connection-scoped MCP、逐连接撤销、request-level logs、部分计划下 OpenTelemetry export，以及 cloud/self-hosting/Enterprise BYOC。更重要的赛道信号是：其评测承认所有平台在托管执行路径上都能让 provider credential 避开模型上下文，差异已转向 acting identity、凭据是否可离开平台、工具能否细粒度暴露、以及调用后留下什么证据。
- 关键数据：审阅日期 2026-08-07；Nango 官方口径 900+ APIs、6,000+ 预制 tool calls；比较 6 个平台；静态加密 AES-256-GCM；支持 request-level logs 和特定计划 OpenTelemetry export。来源：https://nango.dev/blog/best-secure-api-integration-platforms-ai-agents（页面检索日期显示 2026-08-08，正文材料截止 2026-08-07）。
- 原文链接：https://nango.dev/blog/best-secure-api-integration-platforms-ai-agents
- 影响判断：Nango 把“工具网关”与“嵌入式集成平台”合并，尤其适合多租户 SaaS Agent；其自我比较带有商业偏向，目录数字也不可与其他厂商直接横比。OpenClaw 可学习 connection 作为一级资源的模型：每次工具调用显式绑定 principal、tenant、connection、scope 与 revocation state，并把调用 trace 导出到统一观测层。

#### TrueFoundry MCP Gateway（动态池补入）
- 本周动态：TrueFoundry 在本周更新的《10 Best MCP Gateways in 2026》中，把 MCP Gateway 定义为 agent 与多个 MCP server/tool 之间的集中控制层，职责包括 authentication、authorization、routing、observability、rate limiting、auditing 和 policy enforcement。这篇文章虽属于厂商主导的市场盘点、其横向性能数字缺少可复现实验细节，不能视为中立 benchmark，但它清晰反映出动态池竞争方向：企业不再满足于“托管一个 MCP server”，而是要求 server group 隔离、容器化部署、统一 AI/MCP gateway、guardrail、fallback、load balancing、rate limit、监控与计费。TrueFoundry 对自家产品声称在负载下可实现 sub-3ms latency，并以 in-memory authentication/rate limiting 避免数据库查询；同时给出约 350 RPS/core 的口径。其差异化是将 LLM 流量与 MCP tool 流量纳入同一个 control plane，而非为工具单独建立孤岛。这与 AWS 本周限流动作互相印证：MCP gateway 正在复刻并扩展成熟 API/AI gateway 的运营控制。
- 关键数据：厂商口径 sub-3ms latency、约 350 RPS/core；能力包括 MCP Server Groups、容器化 server 部署、统一 observability/billing、rate limiting、fallback、load balancing。来源：https://www.truefoundry.com/blog/best-mcp-gateways（页面本周更新线索为 2026-08-11；性能数据未经独立复测）。
- 原文链接：https://www.truefoundry.com/blog/best-mcp-gateways
- 影响判断：动态池正在分成两派：Composio/Nango/Pipedream 侧重预制 SaaS 工具和代管 auth，TrueFoundry/云厂侧重治理任意 MCP server 与统一流量控制。OpenClaw 更适合保持协议与执行平面开放，在自身 Gateway 做统一策略和审计，并通过适配器接入两类供应商，避免被单一连接器目录锁定。

### 静默对象简记
- **MCP**：本周没有把 7 月 28 日规范发布冒充新动态；其无状态化、refresh-token 修补与 extensions 只作为 Arcade 本周迁移指南的背景。
- **A2A**：官方站点与 Google 官方渠道在窗口内未发现基础设施级新发布；继续观察它与 MCP 的职责分层——A2A 管 agent-to-agent 协作，MCP 管 agent-to-tool/context。
- **Pipedream Connect**：本周无重大公开动态。现有定位仍是 external-user managed auth、托管工具执行、广覆盖 action catalog 与 MCP/workflow 组合；需持续关注 Workday 收购后的路线和审计能力。
- **Google Agent Gateway**：本周无重大公开动态；官方 release notes 所示 GA 日期为 6 月 18 日，不能计入本周。
- **Microsoft Toolbox / MCP endpoint**：本周无重大公开动态；现有方向是让 Hosted Agent 通过单一 MCP endpoint 发现并调用 Toolbox 工具，7 月 28 日 .NET Agent Skills 集成只作背景。

### 模块洞察
- **工具协议已进入“标准化接口、分化控制面”阶段：MCP/A2A 负责互操作，真正可收费且决定生产可用性的价值正集中到身份绑定、无状态扩缩、主体级限流、授权/审批、审计与多租户隔离；云厂正收编流量治理，集成平台则争夺连接和凭据执行边界。**

### OpenClaw 参照
1. **补主体级配额**：在 Gateway 中采用 `principal/tenant × target(tool/model/agent) × metric(request/token/concurrency)` 的统一策略模型，避免只按 tool 名或 session 做粗粒度限制。
2. **建立 MCP 版本与能力协商层**：保存协议版本、extensions、client/server capabilities，提供双栈代理、兼容性测试和分阶段切换，降低规范破坏性升级对 skills 与外部 server 的冲击。
3. **把 connection 变成一级安全对象**：每次调用绑定 user/service identity、tenant、credential connection、scope、revocation state；模型只接触工具 schema 与结果，不接触 provider token。
4. **补齐因果审计与审批证明**：记录 session、模型决策、工具参数摘要、审批人/审批结果、上游 gateway execution ID 和最终结果；对外部网关不留 payload 的场景，本地保留最小必要取证数据。
5. **坚持开放执行平面**：对 Arcade、Composio、Nango、Pipedream Connect、AWS AgentCore Gateway 提供可插拔 adapter；OpenClaw 保留统一 policy/observability，供应商承担连接器、OAuth 和托管执行，从而避免目录锁定并缩短接入时间。


---

## Identity / Auth / Permission 权限层

> 研究时间窗：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）。“本周”仅指该窗口；窗口外内容只作背景，不计入本周动态。

### 本周模块结论
- **授权开始从“单次请求判定”升级为“轨迹判定”。** AWS AgentCore 在 8 月 6 日发布 temporal policies：在 Gateway 边界基于会话历史、动作顺序、跨工具数据一致性、累计金额与人类批准事件做确定性授权，补上了传统 OAuth/IAM 只回答“这一调用是否允许”、却看不见整段 Agent 行为的问题。
- **Agent 正式成为可治理的独立主体。** Microsoft Entra Agent ID 与 Dataverse agent users 在 8 月 6 日进入 public preview：每个 Agent 可有独立非人身份、最小权限安全角色、生命周期所有者与可归因审计记录，不再共用人类或应用身份。
- **MCP Auth 正在分层标准化。** Clerk 以 CIMD beta 解决“客户端软件是谁”；WorkOS 明确 DCR/CIMD 只解决客户端身份，auth.md + ID-JAG 才进一步回答“代表谁、可做什么、如何撤销”；Auth0/Okta XAA 则把跨应用授权收回企业 IdP。OAuth/OIDC 没有消失，而是上移为身份断言、token exchange、资源指示器和企业策略控制面。
- **OpenClaw 参照：** 应把“用户身份 × Agent 身份 × 会话/任务委托上下文”作为每次 tool call 的统一授权输入；把 token broker/relay 与模型上下文隔离；并在 Gateway 增加 deny-by-default 的轨迹策略、一次性批准消费、预算上限及结构化审计。OpenClaw 已有 sessions、Gateway、工具确认等基础，但仍需统一 identity principal、scope/audience/resource 绑定和跨工具的策略状态。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity / Policy | 有动态 | [AWS temporal policies（2026-08-06）](https://aws.amazon.com/blogs/machine-learning/securing-ai-agents-with-temporal-policies-in-amazon-bedrock-agentcore/)；[AWS AgentCore 新能力（2026-08-06）](https://aws.amazon.com/blogs/machine-learning/control-agent-behaviors-and-cost-beyond-a-single-action-new-capabilities-in-amazon-bedrock-agentcore/) | 是 |
| Microsoft Entra Agent Identity / Foundry identity | 有动态 | [Entra Agent ID for Dataverse（2026-08-06）](https://www.microsoft.com/en-us/power-platform/blog/2026/08/06/microsoft-entra-agent-id-for-dataverse/) | 是 |
| Google Agent Identity / Gateway / Gemini Enterprise auth | 静默 | [Google Cloud weekly updates](https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud)；窗口内未核验到新的 Agent Identity/Auth 产品发布 | 否 |
| Arcade Auth / tool permission | 有动态（路线信号） | [Glimmer Makes Intelligence Cheap. Authorization Isn't.（2026-08-10）](https://www.arcade.dev/blog/meta-glimmer-agentic-model-authorization/) | 是 |
| Composio Auth | 静默 | 官方博客与产品公开面检索；窗口内未核验到 auth/permission 基础设施级发布 | 否 |
| Nango OAuth / token management | 静默 | 官方公开面检索；窗口内未核验到 OAuth/token management 基础设施级发布 | 否 |
| Pipedream Connect managed auth | 静默 | 官方公开面检索；窗口内未核验到 managed auth 基础设施级发布 | 否 |

### 动态池状态表（仅 Agent / MCP 信号）

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| Auth0 / Okta | 有动态 | [Auth0 XAA（2026-08-06）](https://auth0.com/blog/xaa-protocol-auth0-ai-agents/) | 是 |
| WorkOS | 有动态 | [DCR/CIMD/auth.md（2026-08-12）](https://workos.com/blog/mcp-client-identity-dcr-cimd-auth-md)；[scheduled agent token（2026-08-12）](https://workos.com/blog/background-agent-third-party-access-no-session-pipes) | 是 |
| Clerk | 有动态 | [CIMD beta（2026-08-06）](https://clerk.com/changelog/2026-08-06-client-id-metadata-documents) | 是 |
| Descope | 有动态 | [Claude Agent SDK + Descope（2026-08-11）](https://www.descope.com/blog/post/secure-ai-agent-claude-descope) | 是 |
| Permit.io / Aserto | 静默 | 官方公开面检索；窗口内未核验到明确 Agent/MCP 权限发布 | 否 |

### 深度笔记

#### AWS AgentCore Identity / Policy
- 本周动态：AWS 在 8 月 6 日把 AgentCore Policy 从单次、无状态授权扩展到 **temporal policies**。策略在 AgentCore Gateway 外围运行，读取当前请求及同一 trajectory 的先前事件，可强制工具顺序、要求当前输入与先前工具输出完全一致、检查数据新鲜度、累计会话金融敞口、消费一次性人类批准，并在长时间无人参与后逐步收紧权限。其安全意义在于：即使提示注入诱导模型伪造客户 ID，或 Agent 将一次批准复用于多笔高风险交易，模型也看不到策略逻辑、不能改状态存储，Gateway 仍可拒绝。规则 deny-by-default，且 forbid 优先于 permit；策略决策带完整上下文日志。会话通过 `x-amzn-bedrock-agentcore-policy-session-id` 标识，并与最终用户身份组合隔离；轨迹最大回看 24 小时，修改策略会使现有 policy sessions 失效。底层 Dogwood 基于 Cedar，增加时间窗、前置步骤、速率限制和升级触发器，以 Apache 2.0 发布规范及参考实现。同期 Gateway rate limiting 可按 OAuth/IAM 身份限制每秒/分钟请求、模型 token 和连接时长，且无需改 Agent 代码。路线判断：AWS 正把 identity、policy、Gateway 和行为状态合并为基础设施强制点，授权对象已从 API 请求扩展到整段 Agent trajectory。
- 关键数据：发布时间 2026-08-06；trajectory look-back 最大 24 小时；官方示例单会话累计交易上限 60,000 美元、单笔超过 25,000 美元需逐笔批准；Dogwood Apache 2.0；速率限制支持请求数、模型 token、连接时长及秒/分钟窗口。来源：[技术详解](https://aws.amazon.com/blogs/machine-learning/securing-ai-agents-with-temporal-policies-in-amazon-bedrock-agentcore/)、[发布综述](https://aws.amazon.com/blogs/machine-learning/control-agent-behaviors-and-cost-beyond-a-single-action-new-capabilities-in-amazon-bedrock-agentcore/)，均为 2026-08-06。
- 原文链接：https://aws.amazon.com/blogs/machine-learning/securing-ai-agents-with-temporal-policies-in-amazon-bedrock-agentcore/ ；https://aws.amazon.com/blogs/machine-learning/control-agent-behaviors-and-cost-beyond-a-single-action-new-capabilities-in-amazon-bedrock-agentcore/
- 影响判断：这是本周最强权限层信号：静态 RBAC/ABAC 无法表达“先查后写”“值必须继承”“一次批准只消费一次”。OpenClaw 可借鉴其 Gateway 外置策略与 session trajectory，但要避免把 24 小时窗口误当长期审计保存；策略状态和审计证据应分层存储。

#### Microsoft Entra Agent ID / Dataverse agent users
- 本周动态：Microsoft 8 月 6 日宣布 Entra Agent ID 与 Dataverse agent users 进入 public preview。管理员为 Agent 建立专属 Entra agent identity，再在目标 Dataverse 环境创建与之关联的 agent user，使其成为环境内安全主体并绑定专用、最小权限 Dataverse security role。官方强调五项能力：独立认证、只授权任务所需权限、区分人类/传统应用/Agent 的职责、将数据读取与修改归因到具体 Agent、以及覆盖创建—更新—退役的生命周期治理。销售开发 Agent 示例中，角色可以只允许读取/更新合格 lead、创建 activity、记录 outreach outcome，而禁止无关表或敏感字段。上线建议也不是“给 token 即可”，而是先在非生产环境定义所需数据与操作、测试允许和拒绝路径、验证审计/监控可见性，并记录业务 owner、安全 owner、用途和退役流程。路线判断：Microsoft 将 Agent 身份落入企业现有 Entra + Dataverse 安全模型，形成可盘点、可分权、可归责的非人主体，而非另造孤立的 Agent IAM。
- 关键数据：public preview；发布日期 2026-08-06；定价、区域和生产许可未在公告中给出，官方明确要求采用前核验 availability、licensing、regional support。来源：[Microsoft Power Platform Blog](https://www.microsoft.com/en-us/power-platform/blog/2026/08/06/microsoft-entra-agent-id-for-dataverse/)。
- 原文链接：https://www.microsoft.com/en-us/power-platform/blog/2026/08/06/microsoft-entra-agent-id-for-dataverse/
- 影响判断：Entra 的优势是把 Agent 纳入既有企业治理和数据权限边界；但此次原文聚焦 Dataverse，而非证明 Foundry 所有 Agent runtime 已统一覆盖。OpenClaw 若接企业目录，应保留独立 Agent principal 与 owner/retirement 元数据，不能只记录发起用户。

#### Arcade Auth / tool permission
- 本周动态：Arcade 8 月 10 日的文章并非新 API/版本发布，而是明确强化其产品路线：当本地可运行的 Agent 模型使“智能”趋于廉价，差异化将转向模型行动时的身份、权限、策略、执行可靠性与审计。Arcade 将自己定位为 enterprise AI agents 的 actions runtime，控制“模型尝试行动的那一刻”：判断使用谁的身份、在外部系统执行、集中治理并留下 audit trail。文章以“能否发邮件、访问 Salesforce、改生产系统、以谁身份行动、什么动作需人签字”为核心问题，说明其竞争位不是通用 IdP 或纯 MCP 路由，而是工具执行面的授权强制点。需要注意，这篇文章主要是架构/市场判断，不能据此宣称 8 月 10 日新增了 token vault、权限交集或具体集成；它验证的是 Arcade 本周持续押注身份与 policy 内建的 action runtime。
- 关键数据：发布日期/最后更新 2026-08-10；文中引用 Meta Glimmer 30B 参数及单消费级 GPU 本地运行（属于其论证背景，不是 Arcade 产品数据）。来源：[Arcade 原文](https://www.arcade.dev/blog/meta-glimmer-agentic-model-authorization/)。
- 原文链接：https://www.arcade.dev/blog/meta-glimmer-agentic-model-authorization/
- 影响判断：Arcade 与 AWS 的共同判断是授权必须靠近执行点；前者强调模型/框架无关的 action runtime，后者依托云 Gateway。OpenClaw 的工具调用层天然靠近执行点，应把授权与审计变成 runtime 契约，而不是由 skill 提示词自律。

#### Auth0 / Okta XAA
- 本周动态：Auth0 8 月 6 日发布 XAA（Cross App Access）采用方案，面向持有企业数据的 Resource App/API/MCP server。XAA 是 MCP Enterprise-Managed Authorization 的基础：请求方 Agent 先向客户自己的企业 IdP 请求针对资源应用的短期签名 **ID-JAG**，Auth0 验证来源及自身角色/组织规则后换发标准短期 access token，资源 API 沿用已有 token 校验，无需理解 XAA。相较员工逐应用 OAuth consent，企业 IT 可在 IdP 统一看见、调整和撤销 app-to-app 关系；禁用用户或改变 Agent 权限后，可阻止跨资源应用续取访问。Auth0 宣称 Resource App 侧可通过控制台声明式配置启用，不改应用层代码。边界必须写清：文章开头明确 Anthropic、Asana、Canva、Cloudflare、Cursor、Datadog、Docker、Figma、VS Code、Zoom 等生态集成预计 **2026-08-24** 才进入 Okta Integration Network，属于时间窗后的未来能力，绝不能写成已上线；Requesting App 的 Token Vault 原生支持也写的是预计 8 月 31 日。
- 关键数据：发布 2026-08-06；Okta 宣布的生态伙伴“over 25”；ID-JAG 为短期签名断言；所列 OIN 生态集成预计 2026-08-24，Requesting App 原生支持预计 2026-08-31。来源：[Auth0 官方原文](https://auth0.com/blog/xaa-protocol-auth0-ai-agents/)。
- 原文链接：https://auth0.com/blog/xaa-protocol-auth0-ai-agents/
- 影响判断：XAA 把“谁批准 Agent 访问”从员工点击同意转回企业 IdP，是集中撤销和离职处置的重要方向。但可用性声明含明显未来日期，现阶段应把“Resource App 配置能力”与“完整请求方生态上线”分开评估。

#### WorkOS：CIMD/auth.md 与 scheduled-agent token
- 本周动态：WorkOS 8 月 12 日用两篇原文同时回答入口身份和出站凭据。第一篇比较 DCR、CIMD 与 auth.md：DCR/CIMD 都只证明“哪一软件在调用”，CIMD 以带路径的 HTTPS URL 作为 `client_id`，服务端抓取元数据并核验 `client_id`、`redirect_uri`，避免每个授权服务器预发 secret；但 URL 控制不等于信誉，仍需未知域告警、publisher allowlist、敏感 scope 管理员批准及 SSRF 防护。auth.md 则在 PRM、OAuth Authorization Server Metadata、ID-JAG、JWT bearer exchange、RFC 7009 撤销和 Security Event Token 之上表达“代表谁、可做什么”；强调 trust list、`aud/exp/iat/jti/auth_time` 校验、首次账号绑定 step-up、过期认证拒绝、每次状态变化审计。第二篇解决 6am 无浏览器/无登录 session 的 scheduled agent：Pipes 把用户 grant 存成 durable connected account，worker 凭自身 WorkOS API key + user ID 获取每连接的 scoped credential；OAuth refresh 自动完成，`missing_scopes` 用于运行前判断。更安全的 Relay（early access）代替 Agent 调上游并注入 token，使 provider token 不进入不可信 runtime；限定 HTTPS 与 provider allowlist，5 MB body、30 秒超时，剥离 Cookie/转发/控制头，并为授权缺失返回 402。删除 connected account 会删 WorkOS 保存的 access/refresh token，但原文明确不等于撤销 provider 侧已泄漏 bearer token。
- 关键数据：两篇均发布 2026-08-12；MCP 2026-07-28 spec 已弃用 DCR、最早移除有至少 12 个月过渡（背景）；Relay early access、最大 body 5 MB、上游超时 30 秒；ID-JAG 示例建议 `jti` 防重放，默认认证最大年龄一小时，首次 claim code 示例 600 秒。来源：[MCP client identity](https://workos.com/blog/mcp-client-identity-dcr-cimd-auth-md)、[scheduled agent access](https://workos.com/blog/background-agent-third-party-access-no-session-pipes)。
- 原文链接：https://workos.com/blog/mcp-client-identity-dcr-cimd-auth-md ；https://workos.com/blog/background-agent-third-party-access-no-session-pipes
- 影响判断：WorkOS 把长期运行 Agent 的关键风险说得最清楚：用户不在线不应退化成共享 service account；凭据托管也不应默认把 token 暴露给 Agent。OpenClaw 的 cron/后台 session 可采用 connected-account + relay 模式，并将用户委托、scope、audience、到期时间固化到任务元数据。

#### Clerk CIMD beta
- 本周动态：Clerk 8 月 6 日在 OAuth provider 中推出 Client ID Metadata Documents beta。兼容客户端直接以 HTTPS URL 作为 `client_id`，Clerk 获取其 metadata document 并验证客户端身份与 redirect URI，因此 MCP 等公共 OAuth 客户端无需预发 client ID/secret，也无需 DCR。控制面新增 CIMD Clients：管理员可按 Client ID URL 显式允许并选择 scopes、允许有建议 scope 的常见客户端、查看 admission status 与 metadata fetch health、刷新元数据、删除/阻止客户端，以及决定未知客户端是否可连接。开启 `Advertise CIMD support` 后会在 authorization server metadata 发布支持；若同时开启 `Only allow pre-registered clients to connect`，则 OAuth 仅允许已审核客户端。该能力是 beta，需联系支持按 workspace 开启。它解决的是 MCP 客户端身份和准入，不解决 Agent 代表哪个用户、任务级委托或运行时 tool permission，需与 OIDC/OAuth delegation/FGA 组合。
- 关键数据：beta；发布日期 2026-08-06；需 support enablement；不需要预发 client ID、client secret 或 DCR。来源：[Clerk changelog](https://clerk.com/changelog/2026-08-06-client-id-metadata-documents)。
- 原文链接：https://clerk.com/changelog/2026-08-06-client-id-metadata-documents
- 影响判断：CIMD 降低开放 MCP 客户端接入的注册运维成本，但也把安全压力转移到远程元数据抓取、域信誉与管理员准入。OpenClaw 若支持 CIMD，应同时实现 SSRF 防护、redirect 精确匹配、缓存健康度、未知客户端默认拒绝和 scope 审批。

#### Descope Agentic Identity Hub + Claude Agent SDK
- 本周动态：Descope 8 月 11 日给出 Claude Agent SDK 的完整身份分层样例。入站侧，Agent 经 DCR + PKCE 登录获得 Descope session token，后续每次 MCP tool call 携带 Bearer JWT，FastMCP/Descope provider 先验 token 与 scope；出站侧，MCP server 按 JWT 中 `user_id` 从 Descope Connections vault 获取 WeatherAPI 静态 key、Google Calendar OAuth token或 Notion DCR OAuth token。凭据只在 MCP server 运行时取用，不进入 Agent、repo 或模型上下文；未连接时工具返回 authorization link。示例为三个工具分别设 `mcp:calendar.read`、`mcp:weather_key.read`、`mcp:notion.write` mandatory scopes，并把 Google 限为 `calendar.readonly`；Descope 自动刷新用户 token，并为每位授权用户产生独立 agentic identity。原文也强调集中 audit logging，可追踪哪个用户运行哪个工具。路线判断：Descope 将“入站 Agent 认证”与“出站用户委托凭据”明确隔离，再在 MCP 工具边界做 scope enforcement，直接降低硬编码密钥、共享 token 和提示注入读取凭据的风险。
- 关键数据：发布 2026-08-11；Python 3.11+ 示例；三种连接（API key、Google OAuth、Notion DCR）；三个 mandatory MCP scopes；Google scope 为 `https://www.googleapis.com/auth/calendar.readonly`。来源：[Descope 官方教程](https://www.descope.com/blog/post/secure-ai-agent-claude-descope)。
- 原文链接：https://www.descope.com/blog/post/secure-ai-agent-claude-descope
- 影响判断：这是一份教程而非新 GA 公告，但提供了可复用的生产安全模式：认证 Agent、识别最终用户、按用户取密钥、按工具验 scope、凭据不入 LLM。OpenClaw 的 tool runtime 可直接参照该双层模型，并补上高风险写操作的 HITL 与调用参数审计。

### 静默固定对象简记
- **Google Agent Identity / Gateway / Gemini Enterprise auth：** 本周官方更新页出现 Apigee AI Gateway、MCP tool filtering、quota 等治理内容，但可核验条目主要属于 8 月 3—7 汇总或 8 月 13 未来活动，未发现窗口内明确发布新的 Agent Identity/Auth 产品能力，故不以旧闻或活动预告凑数。背景上 Google 已把 MCP 方法/工具名提升为可路由、限流、审计的 HTTP headers，并采用 RFC 9207 issuer verification、RFC 8707 resource indicators，但相关文章日期为 8 月 5，窗口外。
- **Composio Auth：** 本周无重大公开动态。其既有定位仍是 per-user connected accounts、managed OAuth、session/MCP 工具接入；本周未核验到新的 token 隔离、企业策略或审计发布。
- **Nango OAuth/token management：** 本周无重大公开动态。既有能力偏每连接 OAuth/API-key 凭据、刷新、proxy/sync/action/MCP；Agent 身份与用户/任务权限交集仍需调用方承担。
- **Pipedream Connect managed auth：** 本周无重大公开动态。既有 Connect 面向嵌入式集成与 managed auth；窗口内未核验到新的 Agent/MCP 细粒度授权或审计能力。

### 权限层能力覆盖核验

| 维度 | 本周最强证据 | 仍存缺口 |
|---|---|---|
| OAuth / OIDC / MCP auth | CIMD、DCR/PKCE、PRM、Authorization Server Metadata、ID-JAG、XAA | 客户端身份、用户委托、Agent 身份仍分散在不同标准/产品 |
| Token 托管 | WorkOS Pipes/Relay、Descope Connections；Auth0 Token Vault 请求方支持仍为未来日期 | provider 侧彻底撤销、泄漏 token 响应和跨 vault 可移植性不统一 |
| 用户授权与撤销 | XAA 企业 IdP 集中治理；auth.md claim/step-up/revoke/events | 员工 consent 与 IT policy 冲突时的通用语义仍在演进 |
| Tool permission | AWS temporal policy、Dataverse security roles、Descope mandatory scopes | 跨工具数据流、任务目的和一次性权限尚无通用互操作标准 |
| 审计 | Entra 独立归因、AWS 带上下文决策日志、WorkOS/Descope 状态与工具日志 | 跨 Gateway/IdP/tool/provider 的统一 trace schema 不成熟 |
| 越权/泄露防护 | Gateway 外置策略、resource indicator、token relay、凭据不入 LLM、最小 scope | prompt injection 下的语义级授权、provider bearer token 泄漏处置仍需纵深防御 |

### 模块洞察
- **Identity/Auth/Permission 正从“OAuth token plumbing”演进为 Agent Harness 的独立控制层：客户端身份（CIMD）、用户/企业委托（ID-JAG/XAA）、非人 Agent principal（Entra）、凭据代理（Pipes/Connections）与轨迹级执行授权（AgentCore temporal policies）正在形成分层栈；标准化已启动，但端到端审计与跨产品策略互操作仍碎片化。**

### OpenClaw 参照（可执行优先级）
1. **P0：统一授权上下文。** 每个 tool call 强制携带 `user_principal`、`agent_principal`、`tenant`、`session/task_id`、`audience/resource`、`scopes`、`delegation_expiry`，缺项默认拒绝；cron/background run 不因“无人在线”自动升格为 service account。
2. **P0：token 不进入模型上下文。** 引入 per-user connected account + broker/relay；工具执行器持短期、受众绑定 token，prompt、skill、日志默认不可见 provider credential；提供 provider 侧 revoke playbook，而不只删本地 vault。
3. **P1：Gateway 轨迹策略。** 支持先读后写、输出到输入一致性、预算累计、互斥动作、数据新鲜度、一次性 HITL approval consumption、无人参与后的权限衰减；策略引擎与 Agent 代码隔离。
4. **P1：MCP Auth 兼容与硬化。** 支持 PRM/OAuth metadata、PKCE、resource indicators、issuer verification，并评估 CIMD；URL metadata 抓取必须做 HTTPS、私网/loopback 阻断、大小/超时/重定向限制、精确 redirect 匹配和管理员 allowlist。
5. **P1：结构化审计。** 记录身份链、策略版本、token audience/scope（不记 token）、工具参数摘要、批准事件、决策理由、上游响应与撤销事件，并用统一 trace ID 串起 Gateway—tool—provider。

---

## 6. Context / Memory / Knowledge 记忆知识层

> 时间窗：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）。GitHub 数据为 2026-08-13 10:00 左右直查快照；窗口内提交按 commit timestamp 核验。

### 本周模块结论
- 最强信号来自 OpenViking v0.4.13：它不再只是“记忆检索库”，而是把服务端 context assembly、Session Auto Commit、经验 lineage、企业认证和分布式队列一起纳入 Context Database，且直接增加 OpenClaw Experience Memory tools。
- Mem0、Cognee 分别沿“多后端通用 Memory SDK”和“知识图谱检索/摄取可靠性”推进；supermemory 则用 Company Brain 的 $100/月 Max 档位把团队共享记忆下沉到中端商业套餐，开源与商业分化更加清晰。
- Firecrawl 把约 4,300 万论文摘要索引与 citation-graph 检索纳入统一客户端；知识摄取入口正在从 crawl/scrape 升级为垂直研究检索。Letta 与 Crawl4AI 本周未检出重大公开更新，不以旧闻补位。
- 对 OpenClaw 的直接参照是：优先验证 OpenViking Experience Memory/服务端 context mode；同时把“记忆来源、版本、权限、调用轨迹”作为核心协议，而不是只保存向量片段。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态 | [v0.4.13](https://github.com/volcengine/OpenViking/releases/tag/v0.4.13)，2026-08-06；GitHub API，2026-08-13 | 是 |
| Mem0 | 有动态 | [v2.0.18](https://github.com/mem0ai/mem0/releases/tag/v2.0.18)，2026-08-11；GitHub API，2026-08-13 | 是 |
| Cognee | 有动态 | [v1.4.2](https://github.com/topoteretes/cognee/releases/tag/v1.4.2)，2026-08-08；GitHub API，2026-08-13 | 是 |
| supermemory | 有动态 | [Company Brain Max commit](https://github.com/supermemoryai/supermemory/commit/59b148e5b2d4f5b4e27c9a6351fb3a0224ed76f2)，2026-08-10；GitHub API，2026-08-13 | 是 |
| Letta | 静默 | [仓库](https://github.com/letta-ai/letta)，GitHub API 窗口内 0 commits，2026-08-13 | 否 |
| Zep / Graphiti | 有动态 | [FactResult provenance commit](https://github.com/getzep/graphiti/commit/401c59a65bdeb22a44136901ff30231e6998a7fe)，2026-08-10；GitHub API | 是 |
| Firecrawl | 有动态 | [Research API commit](https://github.com/firecrawl/firecrawl/commit/8373dab922de2faf666e2c7ce3c6c3a8076b83b3)，2026-08-12；GitHub API | 是 |
| Crawl4AI | 静默 | [仓库](https://github.com/unclecode/crawl4ai)，GitHub API 窗口内 0 commits，2026-08-13 | 否 |
| gbrain（核验） | 有动态 | [官方仓库](https://github.com/garrytan/gbrain)，页面 2026-08-13 抓取、搜索结果显示窗口末更新 | 是（补漏） |
| TencentDB-Agent-Memory（核验） | 静默/窗口后更新 | [官方仓库](https://github.com/TencentCloud/TencentDB-Agent-Memory)，2026-08-13 抓取；搜索显示约 17 小时前更新，已越过窗口 | 否（补漏核验） |
| agentmemory（核验） | 获取失败 | Brave 429；GitHub API 403 rate limit，2026-08-13 | 否 |

### 深度笔记

#### OpenViking
- 本周动态：OpenViking 8 月 6 日发布 v0.4.13，变化不是单一检索优化，而是把 Context Database 向生产级 Agent 状态层推进。`/search` 新增 `mode="context"`，由服务端完成 recall planning、分类配额、token budget、detail tier 降级、跨轮去重与可选 LLM digest，直接返回可注入模型的上下文；这把原本分散在各 Harness 客户端里的“拼上下文”逻辑收回数据库层。Session Auto Commit v2 可按 pending token、消息数、空闲时间、保留消息数和最小提交间隔触发，经验记忆新增 trajectory lineage、outcome 聚合和 snapshot refinement。企业侧新增 OIDC/LDAP、Redis QueueFS（standalone/Cluster/Sentinel）、只读副本 watch 开关及启动恢复 sweep。知识摄取新增 `no_split`、`vectors_only` 与火山方舟音视频理解。最关键的是官方为 OpenClaw 增加 Experience Memory tools/skill，并改进插件 CI 发布与 SecretRef 安全边界。这说明 OpenViking 在下的棋是把 memory、knowledge、skills、session commit 和企业部署统一为可远程调用的状态服务，而非再做一个向量数据库封装。
- 关键数据：v0.4.13；28,300 stars / 2,230 forks；窗口内 71 commits（GitHub API，2026-08-13）；ExternalParse 默认并发 4、keep-alive 默认 5 秒（[release](https://github.com/volcengine/OpenViking/releases/tag/v0.4.13)，2026-08-06）。
- 原文链接：[v0.4.13 完整说明](https://github.com/volcengine/OpenViking/releases/tag/v0.4.13)；[版本比较](https://github.com/volcengine/OpenViking/compare/v0.4.12...v0.4.13)。
- 影响判断：Context assembly 和 session commit 下沉后，Harness 可减少重复实现并统一审计。OpenClaw 应优先做真实负载 A/B：原生 memory_search 与 OpenViking context mode 在召回质量、token 成本、跨轮去重上的差异，同时保留可替换的 memory provider 接口，避免被单一后端绑定。

#### Mem0
- 本周动态：Mem0 在窗口内发布 Python v2.0.18、TypeScript v3.1.6，并延续 v2.0.17 的 agent-scoped extraction 配置。v2.0.18 修复 recent-conversation buffer 的 scope key：`user_id`、`agent_id`、`run_id` 中 `%`、`&`、`=` 现在会 percent-escape，避免不同身份组合产生歧义键；已有普通 ID 不迁移，特殊字符 ID 会一次性重建 buffer，已存 memories 不受影响。PGVector 的 `in/nin` 过滤值若不是 list 现在直接抛 `ValueError`，修复字符串被逐字符拆成 `ANY(...)` 的危险行为。Oracle AI Vector Search 的 `index_accuracy=0` 被正确拒绝，初始化失败时释放由 Mem0 创建的连接或连接池。TS v3.1.6 还新增 Oracle vector store，支持 pooled connections、HNSW/IVF、六种距离度量、JSON payload filtering。本周另有安全提交一次修补 4 个 pnpm workspace 中 8 个 HIGH、18 个 MEDIUM 漏洞。路线很明确：Mem0 正在用稳定的多数据库适配、身份 scope 与 SDK 一致性巩固“通用 memory API”位置，而不是绑定某个图数据库或云。
- 关键数据：63,142 stars / 7,364 forks；窗口内 14 commits；Python v2.0.18、TS v3.1.6（GitHub API 与 [release](https://github.com/mem0ai/mem0/releases/tag/v2.0.18)，2026-08-11）；安全提交称修补 8 HIGH + 18 MEDIUM（[commit](https://github.com/mem0ai/mem0/commit/4debc58a83377b18be81ae1e5969a300736b2fac)，2026-08-07）。
- 原文链接：[Python v2.0.18](https://github.com/mem0ai/mem0/releases/tag/v2.0.18)；[TS v3.1.6](https://github.com/mem0ai/mem0/releases/tag/ts-v3.1.6)。
- 影响判断：scope-key 修复说明记忆隔离的风险往往藏在组合键和过滤器，而非模型层。OpenClaw 的多 agent/session memory namespace 应加入特殊字符、跨租户、filter type 的系统性 fuzz test，并在 trace 中记录最终 scope key（脱敏后）。

#### Cognee
- 本周动态：Cognee 8 月 8 日发布 v1.4.2，重点是搜索相关性和大规模摄取可靠性。新增可选 dataset indexing mode：先按主题聚类一个 dataset，再为每个 cluster 生成短 overview，让检索先获得集合级上下文；管理界面新增开始、暂停和重跑索引的控制，便于避开高峰与恢复失败任务。官方称大文件上传支持自动重试/恢复、降低内存占用，并更一致地保留 tags、source、timestamps；同时修复重复结果、畸形输入导致的 ingestion crash 和管理 UI 状态不同步。仓库提交进一步显示修复 nested DB sessions 导致的连接池死锁、请求取消时使 PG session 失效，并在 8 月 10 日把 1.4.2 装入 MCP image。与单纯“图谱记忆”相比，这次更新强化了可运营性：索引作业有生命周期、失败可恢复、MCP 镜像跟随正式版，说明 Cognee 正把知识图谱引擎包装成可长期运行的 Agent memory service。
- 关键数据：v1.4.2；29,982 stars / 2,915 forks；窗口内 28 commits（GitHub API，2026-08-13）；兼容 Python >=3.10,<3.15、FastAPI >=0.116.2,<1.0.0、LanceDB >=0.24.3,<1.0.0（[release](https://github.com/topoteretes/cognee/releases/tag/v1.4.2)，2026-08-08）。
- 原文链接：[v1.4.2](https://github.com/topoteretes/cognee/releases/tag/v1.4.2)；[MCP image commit](https://github.com/topoteretes/cognee/commit/4b9dd362625dfd3621c344e571a86f5bc7a55ee8)。
- 影响判断：dataset overview 是“先压缩集合，再检索实体”的 context engineering 路线，但官方未给出可复核 benchmark，效果仍需实测。OpenClaw 可借鉴索引 job 的暂停/恢复/状态暴露，而不应直接采信“更相关”营销表述。

#### supermemory
- 本周动态：supermemory 本周没有正式 release，但 8 月 10 日的官方提交把 Company Brain 从只售 Scale/Enterprise 下沉到 Max 档。Max 定价 `$100/mo`，含 `$130` monthly usage credits、Unlimited seats、Slack agent 与 shared memory、auto top-up 和 spend caps；Scale 保持 `$399/mo`，含 `$600` credits，并增加 GitHub、S3、Web Crawler connectors、restricted access、container tags、User Insights 与 dedicated support。代码还明确：试用运行在 Scale，转 Max 会保留 agent、shared memory、unlimited seats，但失去上述高级 connectors 和治理能力；月 credits 使用超过约 `$400` 时 Scale 更划算。同周仓库修复 memory graph 对过期记忆状态的显示、Included Memories 含逗号/换行时被错误拆分，以及分页参数校验。这个变化的基础设施意义在于，团队共享记忆本身已成为中端标配，而数据连接器、细粒度访问控制和洞察被留作高价差异化，商业化边界非常清楚。
- 关键数据：28,880 stars / 2,511 forks；窗口内 14 commits（GitHub API，2026-08-13）；Max $100/月含 $130 credits，Scale $399/月含 $600 credits（[commit](https://github.com/supermemoryai/supermemory/commit/59b148e5b2d4f5b4e27c9a6351fb3a0224ed76f2)，2026-08-10）。
- 原文链接：[Company Brain Max commit](https://github.com/supermemoryai/supermemory/commit/59b148e5b2d4f5b4e27c9a6351fb3a0224ed76f2)；[expired memory fix](https://github.com/supermemoryai/supermemory/commit/74b2201eebe9ff44f37bc985682888dceb509cd2)。
- 影响判断：Memory SaaS 的收费单位正从“请求量”扩展到团队、连接器、ACL 和洞察。OpenClaw 若建设托管 memory，应将基础共享与高级治理分层，但自托管用户仍应拥有完整数据导出和可验证删除能力。

#### Letta
- 本周动态：本周无重大公开动态。GitHub API 对 `letta-ai/letta` 在规定时间窗返回 0 条 commit，未发现窗口内 release；因此不使用其“persistent agents / stateful context”既有能力充当本周新闻。
- 关键数据：24,218 stars / 2,576 forks（GitHub API，2026-08-13）。
- 原文链接：[官方仓库](https://github.com/letta-ai/letta)。
- 影响判断：保持观察其持久 Agent 状态模型与 memory blocks，但本期不作趋势外推。

#### Zep / Graphiti
- 本周动态：Graphiti 8 月 10 日对 `FactResult` 增加 `source_node_uuid`、`target_node_uuid` 与 `episodes`，并在 edge processing 时从 `EntityEdge` 透传，episode 缺失则返回空数组。改动规模不大，却直接提升事实结果的 provenance：调用方不仅拿到事实文本和有效/失效时间，还能定位源实体、目标实体及支撑 episode。对 temporal knowledge graph 而言，这正是从“能召回”到“可解释、可回溯”的必要字段。窗口内仓库只有 3 条 commit、无正式 release，因此应把它视为接口可追责性增量，而不是产品大版本。Zep 商业服务本周未检出独立重大公告，故与 Graphiti 合并记录，避免重复夸大。
- 关键数据：29,866 stars / 3,022 forks；窗口内 3 commits（GitHub API，2026-08-13）。
- 原文链接：[FactResult commit](https://github.com/getzep/graphiti/commit/401c59a65bdeb22a44136901ff30231e6998a7fe)（2026-08-10）；[官方仓库](https://github.com/getzep/graphiti)。
- 影响判断：provenance 字段应成为 Memory API 的标准返回，而非调试附加物。OpenClaw 的长期记忆结果也应能追到原 message/session/tool output，并携带有效期与撤销状态。

#### Firecrawl
- 本周动态：Firecrawl 8 月 12 日提交统一客户端与 Research API 文档/准确性更新：常规 `search` 可在一次调用中搜索并 scrape，结果按 `.web/.news/.images/.developer` 分组；`categories:['research']` 被明确限定为约 14 个学术域名的网站过滤器，并不等于论文索引。真正的 `app.research` 面向约 4,300 万篇论文摘要，约 90% 为 PubMed、bioRxiv、medRxiv 等生物医学/生命科学，加上 arXiv 的物理、数学、计算机科学内容；提供 `searchPapers`、按 PMID/PMCID/DOI/arXiv ID 取论文、query-directed passages，以及沿 citation graph、按 intent 重排的 similar papers。另有 `research.searchGithub` 检索 GitHub issue/PR 历史和 README。本周其他提交还修复 DNS 失败 scrape 不计费、自托管 FoundationDB 初始化幂等和 pnpm audit。Firecrawl 正从网页采集 API 扩展为“外部知识入口 + 垂直索引”，会与传统搜索/RAG ingestion 边界重叠。
- 关键数据：166,469 stars / 9,355 forks；窗口内 22 commits（GitHub API，2026-08-13）；约 43M abstracts、约 90% biomedical/life sciences、research 网站过滤约 14 domains（[commit](https://github.com/firecrawl/firecrawl/commit/8373dab922de2faf666e2c7ce3c6c3a8076b83b3)，2026-08-12）。
- 原文链接：[Research API commit](https://github.com/firecrawl/firecrawl/commit/8373dab922de2faf666e2c7ce3c6c3a8076b83b3)；[DNS billing fix](https://github.com/firecrawl/firecrawl/commit/5b21116fd818283e0d4dfc5b23f754ed0b128361)。
- 影响判断：OpenClaw research 工具可接入其论文/引用图能力，但必须在 UI/trace 中区分普通 web domain filter 与 paper index，避免用户误判证据覆盖；43M 规模与 90% 学科结构也应显式提示偏差。

#### Crawl4AI
- 本周动态：本周无重大公开动态。GitHub API 在窗口内返回 0 条 commit，未检出本周 release；不使用既有 LLM-friendly crawling 能力凑数。
- 关键数据：77,949 stars / 8,061 forks（GitHub API，2026-08-13）。
- 原文链接：[官方仓库](https://github.com/unclecode/crawl4ai)。
- 影响判断：继续作为高热自托管摄取层观察；与 Firecrawl 的差异仍主要在自托管控制和托管搜索/索引能力，而非本周新增功能。

#### gbrain（热度补漏）
- 本周动态：热扫要求核验的 gbrain 确认是 `garrytan/gbrain`，定位为 OpenClaw/Hermes 的“brain layer”，官方仓库在窗口末保持活跃。README 明确把搜索、synthesis、graph traversal、gap analysis 合成一体：页面写入时无 LLM 调用地抽取 entity refs 与 typed edges；查询返回带 citation 的综合答案，并显式指出知识缺口。作者披露其生产实例含 155,795 pages、24,589 people、5,340 companies、66 cron jobs；BrainBench 在 240-page 合成 rich-prose corpus 上报告 P@5 49.1%、R@5 97.9%，相对 graph-disabled variant 的 P@5 提升 31.4 points。团队版按登录 scope 隔离，并声称对 search/list/lookup/multi-source reads fuzz test 为 zero leaks。由于这些 benchmark 与运行规模主要是项目方自报，本期将其作为强观察信号而非独立验证结论。其价值在于把 Memory 从“历史对话片段”明确分层为世界知识 brain 与 operational agent memory。
- 关键数据：155,795 pages、24,589 people、5,340 companies、66 crons；P@5 49.1%、R@5 97.9%、+31.4 P@5；240-page corpus（均为[官方 README](https://github.com/garrytan/gbrain)，2026-08-13 抓取，自报，待独立复现）。GitHub stars/forks 因 API 403 未获得可靠快照，标记获取失败。
- 原文链接：[官方仓库/完整 README](https://github.com/garrytan/gbrain)；[gbrain-evals](https://github.com/garrytan/gbrain-evals)。
- 影响判断：gbrain 对 OpenClaw 的启发是把“检索结果”升级成带缺口声明的 synthesis，并把 overnight consolidation 作为后台作业；风险是自主浓缩可能固化错误，必须保留 citation、版本和可撤销链路。

#### TencentDB-Agent-Memory 与 agentmemory 核验
- 本周动态：TencentDB-Agent-Memory 官方仓库已核验，当前定位是团队级 Memory Hub，把 conversation、docs、code 转成 Chat Memory、Skill、LLM-Wiki、CodeGraph 四类资产，并提供 owner/version/status/visibility/usage/agent binding；权限包含 private、team、restricted（User/Role/Agent ACL）和 agent 定向装备。Chat Memory 采用 L0 Conversation→L1 Atom→L2 Scenario→L3 Core/Persona，检索用 BM25+vector+RRF 并受 item/character/timeout budget 约束。搜索结果显示该仓库约在 8 月 13 日更新，越过本期截止线，因此只做核验、不能列为本周动态。`agentmemory` 名称无法在限额前唯一解析：Brave 返回 429，GitHub API 返回 403；遵循规则标“获取失败”，不猜测其项目归属。
- 关键数据：四类资产、四层 Chat Memory、三类核心可见性 + agent 定向装备（[官方仓库](https://github.com/TencentCloud/TencentDB-Agent-Memory)，2026-08-13 抓取）；stars/forks 获取失败（API 403）。
- 原文链接：[TencentDB-Agent-Memory](https://github.com/TencentCloud/TencentDB-Agent-Memory)。
- 影响判断：腾讯方案把 memory 资产治理与 Agent loadout 绑定，说明企业 Memory 的壁垒正在从召回算法转向 ACL、版本和团队流转。OpenClaw 可借鉴 asset binding，但需避免把私有 memory 因团队管理员权限而隐式暴露。

### 模块洞察
- Memory 正从“向量检索 API”升级为带 session commit、context assembly、provenance、ACL、后台演化和团队资产流转的 Context Database；开源在核心引擎上领先，云厂/商业产品则围绕连接器与治理收编价值。


---

## 7. Observability / Eval / Guardrails 可观测治理层

> 时间窗：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）。开源仓库以 GitHub API/本地 git log 直查；搜索/API 限流处明确标注。

### 本周模块结论
- 本周最强产品信号是 Langfuse v4.10.0：单 trace observation 上限提高到 20k，dashboard/monitor 过滤器和 evaluator v4 迁移同步增强；可观测产品正在为真正长链 Agent 执行做容量与运营化准备。
- 最强安全信号来自 LangSmith SDK 和 OpenTelemetry：前者默认遮蔽 Anthropic wrapper trace 中 MCP server credentials，后者把 `AWSAccessKeyId`、`Signature` 恢复到默认敏感 query 参数列表；“trace 不能泄密”正成为治理底线。
- Coze Loop 把 evaluation sandbox run mode 和失败路径指标纳入开源实现；Phoenix v20.1.0 增加 trace transfer、OAuth2 JWT client assertion 并更新 eval 图表，评估与可观测逐渐和执行环境、身份体系相连。
- 云厂方面，AWS 在 Agent Toolkit 的 Cognito skill 中明确把 IAM guardrails 与 CloudTrail audit 串联；Google/Azure 在本窗口未检出可全文核验的新公告，不能据聚合页摘要强行写成动态。对 OpenClaw，应优先补统一 trace schema、secret-redaction、eval dataset/experiment 与 policy decision audit。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 有动态 | [MCP credential masking](https://github.com/langchain-ai/langsmith-sdk/commit/095b3e2f)，2026-08-12；git log | 是 |
| Langfuse | 有动态 | [v4.10.0](https://github.com/langfuse/langfuse/releases/tag/v4.10.0)，2026-08-12；GitHub API | 是 |
| Helicone | 静默 | [仓库](https://github.com/Helicone/helicone)，GitHub API 窗口内 0 commits | 否 |
| AgentOps | 静默 | [仓库](https://github.com/AgentOps-AI/agentops)，GitHub API 窗口内 0 commits | 否 |
| Braintrust | 有动态（SDK 维护） | [scorer metadata commit](https://github.com/braintrustdata/braintrust-sdk-javascript/commit/375d74c67d7d1648f34db5b9dcf2928fb9633cd4)，2026-08-12；GitHub API | 是 |
| Arize Phoenix | 有动态 | [v20.1.0 commit](https://github.com/Arize-ai/phoenix/commit/ae40421fc)，2026-08-12；本地 git log；[仓库](https://github.com/Arize-ai/phoenix) | 是 |
| Coze Loop | 有动态 | [sandbox run mode](https://github.com/coze-dev/coze-loop/commit/13d47669)，2026-08-10；本地 git log | 是 |
| OpenTelemetry for Agents / tracing standards | 有动态（安全语义） | [sensitive query params](https://github.com/open-telemetry/semantic-conventions/commit/efafcad)，2026-08-10；本地 git log | 是 |
| AWS agent observability/eval/guardrails | 有动态 | [Cognito aws-auth skill](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-auth-agent-skill/)，2026-08-07 | 是 |
| Google agent observability/eval/guardrails | 静默 | [Google Cloud What's New](https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud)，窗口搜索仅命中聚合页，2026-08-13 核验 | 否 |
| Azure agent observability/eval/guardrails | 获取失败/无可核验新公告 | [Azure Updates](https://azure.microsoft.com/en-us/updates)，搜索仅返回动态聚合摘要，未取得窗口内独立原文 | 否 |

### 深度笔记

#### LangSmith
- 本周动态：LangSmith SDK 8 月 12 日同时在 JavaScript 与 Python wrapper 修复 Anthropic `mcp_servers` trace 泄密风险。官方 JS 原文测试显示：`authorization_token` 在上传 run 前替换为 `SECRET_PLACEHOLDER`，未来出现的未显式 allowlist 字段如 `future_secret` 也默认遮蔽；与此同时不修改调用方传给 Anthropic API 的原始参数，保证业务请求仍能正常鉴权。测试覆盖 system prompt、null、nested array、空列表及非数组等边界。Python 后续提交进一步停止在 Anthropic run metadata 中记录 `mcp_servers`。同周 SDK 发布 Python 0.10.18、JS 0.8.10，并更新 aiohttp、cryptography 与 JS 依赖。这组改动的意义远超普通 bugfix：MCP 把远程工具 URL、token 和 server metadata 带进模型调用，一旦 observability 默认全量捕获输入，就可能把横向移动凭据写入第三方 trace。LangSmith 选择“允许的非敏感字段保留、其余默认遮蔽”的 fail-closed 策略，代表 Agent tracing 开始承担安全控制面职责。
- 关键数据：Python SDK 0.10.18、JS 0.8.10（[git log/仓库](https://github.com/langchain-ai/langsmith-sdk)，2026-08-11）；遮蔽测试 4 类畸形输入边界（[commit](https://github.com/langchain-ai/langsmith-sdk/commit/095b3e2f)，2026-08-12）。stars/forks 未作为核心项目数据披露（SDK 仓库并非 LangSmith 产品热度代表）。
- 原文链接：[JS credential masking](https://github.com/langchain-ai/langsmith-sdk/commit/095b3e2f)；[Python masking](https://github.com/langchain-ai/langsmith-sdk/commit/9c140ef0)；[stop metadata recording](https://github.com/langchain-ai/langsmith-sdk/commit/bbc6d561)。
- 影响判断：OpenClaw 的 tool/MCP trace 必须在序列化前做 schema-aware redaction，而非事后删日志；未知字段默认敏感更安全。还应测试嵌套 SecretRef、headers、signed URL、tool result 中回显 token 的情况。

#### Langfuse
- 本周动态：Langfuse 8 月 12 日发布 v4.10.0，是本周可观测产品中最完整的版本信号。trace 可加载 observation 上限提高到 20k，并修复树外 peek observation 的解析；dashboard widget 与 monitor 表单获得全部 filter options 和 value suggestions，evaluation v4 升级 UX 被简化，score SQL 改为按 experiment events 过滤。平台也为 agent 增加 Cursor Cloud environment，修复其启动时 Docker socket 可达性，并把 structured tool failure 标记为 `ERROR`。v4.8.0 还增加“对整段 conversation 一次性 approve tool”的交互，修复 Anthropic cache token alias 到 canonical usage buckets 的 OTel 映射；v4.9.0 支持在 trace chat view 渲染 OpenAI Responses API input。路线判断：Langfuse 正从 LLM 请求日志转向长链 Agent 的 execution analytics，把 trace 容量、工具错误、权限确认、费用/usage 和 evaluator 迁移同时纳入一个开源控制面。
- 关键数据：v4.10.0；32,990 stars / 3,552 forks；窗口内 API 返回 100 commits（`per_page=100`，故实际可能 ≥100）；单 trace observation load cap 20k（[release](https://github.com/langfuse/langfuse/releases/tag/v4.10.0)，2026-08-12）。
- 原文链接：[v4.10.0](https://github.com/langfuse/langfuse/releases/tag/v4.10.0)；[v4.8.0](https://github.com/langfuse/langfuse/releases/tag/v4.8.0)；[v4.9.0](https://github.com/langfuse/langfuse/releases/tag/v4.9.0)。
- 影响判断：长时 Agent 产生上万 observation 已成为真实产品约束。OpenClaw 需要 trace pagination/streaming、采样与分层存储，否则完整可回放与成本可控不可兼得；structured tool failure 应有统一 error taxonomy。

#### Helicone
- 本周动态：本周无重大公开动态。GitHub API 对 `Helicone/helicone` 在窗口内返回 0 条 commit，未检出本周 release；不以历史的 LLM proxy/observability 能力充当新闻。
- 关键数据：6,059 stars / 650 forks（GitHub API，2026-08-13）。
- 原文链接：[官方仓库](https://github.com/Helicone/helicone)。
- 影响判断：继续观察其 gateway-first 可观测路线，本期不作强结论。

#### AgentOps
- 本周动态：本周无重大公开动态。GitHub API 对 `AgentOps-AI/agentops` 在窗口内返回 0 条 commit，未检出窗口内正式 release。
- 关键数据：5,768 stars / 612 forks（GitHub API，2026-08-13）。
- 原文链接：[官方仓库](https://github.com/AgentOps-AI/agentops)。
- 影响判断：其 agent session/replay 定位仍相关，但本期没有足够新证据进入 TOP 信号。

#### Braintrust
- 本周动态：Braintrust JavaScript SDK 在 8 月 12 日提交中让 scorer 接收 `id` 与 `tags`，窗口内共 11 条 commit。它不是重大发布，但改善了评估结果与样本/实验元数据的关联：scorer 若拿不到稳定标识和标签，很难进行按场景、租户、版本或风险等级切片，也难复现某一失败簇。仓库 API 快照仅 28 stars / 8 forks，是因为被核验的是 `braintrust-sdk`/JS SDK 开源仓库，不能拿它代表 Braintrust 商业平台采用度。本期谨慎归类为“SDK 维护动态”，不夸大为平台级发布；官方博客/产品公告未检出窗口内可全文核验的大动作。
- 关键数据：窗口内 11 commits；目标 SDK repo 28 stars / 8 forks（GitHub API，2026-08-13）。
- 原文链接：[scorer id/tags commit](https://github.com/braintrustdata/braintrust-sdk-javascript/commit/375d74c67d7d1648f34db5b9dcf2928fb9633cd4)；[SDK 仓库](https://github.com/braintrustdata/braintrust-sdk)。
- 影响判断：OpenClaw eval event 需把 run/session/agent/tool/skill version 与业务 tags 作为一等字段，才能形成可行动的失败切片，而非只有平均分。

#### Arize Phoenix
- 本周动态：Phoenix 在 8 月 12 日发布 `arize-phoenix 20.1.0`。本地 git log 直查显示该版本附近新增 `POST /traces/transfer`、OAuth2 登录的 JWT client assertion、评估指标图布局与控件优化，并将 OpenAI reasoning models 路由到 Responses API client；同时更新内置模型 token prices。Phoenix 官方 README 把产品明确定位为基于 OpenTelemetry 的 tracing、LLM eval、versioned datasets、experiments、prompt management 和 replay，并提供 Remote MCP `/mcp` 端点，让 Claude Code、Cursor 等直接查询 traces/datasets/experiments。由于 release 页面正文仅显示签名信息，本期每个功能都以对应 commit log/仓库原文为证，不推断未公开细节。路线判断：Phoenix 正将“人看的 observability UI”扩展成“Agent 可通过 MCP 自助诊断”的工程系统，而 trace transfer 与 OAuth client assertion 则补齐跨环境迁移和企业认证。
- 关键数据：arize-phoenix 20.1.0（[release commit](https://github.com/Arize-ai/phoenix/commit/ae40421fc)，2026-08-12）；功能 commit 见原文。stars/forks 因 GitHub API 当时 403 未取得可靠快照，标记获取失败。
- 原文链接：[官方仓库/能力说明](https://github.com/Arize-ai/phoenix)；[trace transfer](https://github.com/Arize-ai/phoenix/commit/5c38cc7ff)；[JWT client assertion](https://github.com/Arize-ai/phoenix/commit/3b277cffa)；[eval chart](https://github.com/Arize-ai/phoenix/commit/39740fa8b)。
- 影响判断：OpenClaw 可借鉴 Remote MCP for observability，让诊断 agent 查询自身 trace/eval，但必须通过 tenant ACL 和只读工具限制，避免“可观测入口”变成数据外泄入口。

#### Coze Loop
- 本周动态：Coze Loop 本周连续推进 evaluation：8 月 10 日增加 sandbox run mode，8 月 11 日做 evaluation maintain upgrade；此前 8 月 7 日让 sandbox agent 在无 callback 的失败路径也发出 metric，并修复 invoke id；trace 侧预留 cached ingest。官方 README 将其能力分成 Prompt development、Evaluation（dataset/evaluator/experiment）和 Observation（SDK trace/trace data），支持 OpenAI 与火山方舟等模型。sandbox run mode 的 diff 页面未完整呈现业务语义，但仓库目录变化覆盖 eval target、experiment、evaluation set、open API 与 agent studio RPC，可确认它把隔离执行作为评估运行方式纳入后端，而非仅 UI 开关。对企业评估而言，这是重要方向：不可信 evaluator/target 或带工具调用的 agent eval 不应直接运行在控制平面进程里。
- 关键数据：窗口内 5 条相关 commits（本地 git log，2026-08-13）；具体 stars/forks 因 API rate limit 未可靠取得，标记获取失败。
- 原文链接：[sandbox run mode](https://github.com/coze-dev/coze-loop/commit/13d47669)（2026-08-10）；[官方仓库](https://github.com/coze-dev/coze-loop)；[failure metric](https://github.com/coze-dev/coze-loop/commit/e30f3dd0)。
- 影响判断：OpenClaw 的 eval runner 应复用 sandbox 层并记录镜像、依赖、网络权限和工具 allowlist；否则离线评估可能比生产运行更危险，也难复现。

#### OpenTelemetry for Agents / tracing standards
- 本周动态：OpenTelemetry Semantic Conventions 本周没有可证实的专属 Agent 大版本，但出现与 Agent tracing 直接相关的安全修复：8 月 10 日将 `AWSAccessKeyId` 与 `Signature` 恢复到默认敏感 query parameter 列表，要求默认以 `REDACTED` 替换；列表同时覆盖 `X-Amz-Signature`、`X-Amz-Credential`、`X-Amz-Security-Token`、Azure `sig` 与 `X-Goog-Signature`，并说明 key 应大小写敏感匹配。仓库还把 session/thread 定义迁移到 schema v2，更新 v1.60.0 规范链接。对 Agent 来说，browser/tool/MCP 调用大量携带 signed URL，若 span 默认记录完整 URL，就可能在 trace backend 留下可重放凭据。本周 LangSmith 的 MCP token masking 与 OTel 的 signed-query redaction形成独立双源，指向同一治理底线。
- 关键数据：窗口内直查 10 条近期 commits；敏感参数新增/恢复 2 个 key（[commit](https://github.com/open-telemetry/semantic-conventions/commit/efafcad)，2026-08-10）。stars/forks 因 API 403 未可靠获取。
- 原文链接：[sensitive query commit](https://github.com/open-telemetry/semantic-conventions/commit/efafcad)；[Semantic Conventions 仓库](https://github.com/open-telemetry/semantic-conventions)。
- 影响判断：OpenClaw 应优先采用 OTel-compatible span 模型，但在其上扩展 agent/session/tool/approval/policy 字段；URL、MCP token、OAuth header、tool arguments 的红线字段应在 exporter 前统一净化。

#### AWS 云厂治理能力
- 本周动态：AWS 8 月 7 日宣布 Amazon Cognito 成为 Agent Toolkit for AWS 的核心 `aws-auth` skill。它覆盖 user pool/app client、managed login、OAuth 2.0、token management、JWT authorizers、passkey/WebAuthn、threat protection、Lambda triggers 与 identity pools；与 AWS MCP Server 配对时，coding agents 通过 AWS CLI 执行动作，同时受 IAM-based guardrails 约束并写入 CloudTrail audit logging，也可独立通过 CLI 工作。严格说，这条更新主要属于 Identity/Tooling，但它把 guardrail 与审计落到 agent 执行链，因此是本模块本周可核验的 AWS 治理信号。它不是独立 eval/trace 产品发布，也不能据此声称 AgentCore Observability 新增功能。
- 关键数据：覆盖 8 类认证/安全能力（按官方列举归类）；发布日期 2026-08-07（[AWS 原文](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-auth-agent-skill/)）。
- 原文链接：[AWS What's New](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-auth-agent-skill/)；[Agent Toolkit](https://aws.amazon.com/products/developer-tools/agent-toolkit-for-aws/)。
- 影响判断：治理价值在“执行前 IAM 约束 + 执行后 CloudTrail 审计”的闭环。OpenClaw approvals/permissions 应同样产出不可抵赖的 policy decision 与 tool execution audit，而非只留聊天文本。

#### Google 与 Azure 云厂治理能力
- 本周动态：Google 搜索仅命中 8 月 12 日 What's New 聚合页条目，未取得可独立全文核验的 Agent observability/evaluation 新公告；Azure 搜索只返回动态 Azure Updates 聚合页摘要“Observability in Foundry”，无法确认具体发布日期、GA/preview 状态和字段变化。按“有动态必须读原文全文”铁律，Google 标静默、Azure 标获取失败/无可核验新公告，不将摘要写成事实。两家既有 Vertex AI/Foundry tracing、evaluation 和内容安全能力仅可作背景，本期不冒充新增。
- 关键数据：—（未取得窗口内可核验原文）。
- 原文链接：[Google Cloud What's New](https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud)；[Azure Updates](https://azure.microsoft.com/en-us/updates)。
- 影响判断：云厂动态页的客户端渲染和聚合摘要会造成证据歧义；主报告若需要平台矩阵，可写既有能力，但“本周强信号”栏必须留空或标获取失败。

### 模块洞察
- Agent 可观测层正在从“记录 LLM 请求”演化为覆盖长链 trace、工具权限、secret redaction、sandbox eval、数据集实验和审计证据的生产治理层；标准化首先发生在 OTel 语义与安全净化，产品竞争则转向容量、回放和闭环优化。

### OpenClaw 参照
- 统一 `session → agent run → model/tool/MCP/approval/policy` span 层级，并兼容 OTel exporter；长任务采用分页、采样和冷存储，而非无限堆在单 trace。
- 在 trace 入库前执行 fail-closed secret redaction：未知 MCP 字段、signed URL、OAuth header、SecretRef 与 tool output 回显均默认敏感；保留脱敏规则版本供审计。
- 建立 eval dataset/experiment/scorer 原语，并把 scorer 的 id/tags、agent/skill/model/tool version、sandbox image 与网络策略一同记录，实现可复现和按风险切片。
- approvals 与 tool policy decision 写成结构化、可查询且不可悄然改写的 audit event；诊断 MCP 只读、按租户授权，避免 observability 反向成为越权通道。


---

# 模块 8｜Managed Agent Platform / Enterprise Control Plane

> 时间窗：2026-08-06 00:00—2026-08-12 24:00（Asia/Shanghai）。窗口外信息只作能力基线或背景，不计本周动态。检索与原文核验于 2026-08-13 完成。

## 本周模块结论

- **AWS 是本周最强平台信号。**AgentCore 同周交付 Instances 持久计算、最长 14 天 session、Gateway caller/tool/model 维度限流、temporal policy，以及 GovCloud 中 Memory/Policy/Harness 补齐；其六层能力已从“组件齐全”进入策略联动与规模配额阶段。
- **Databricks 从治理控制面向执行状态面扩张。**Electric/PGlite + Lakebase sync 把每个 agent sandbox 的本地 Postgres 与中心 durable/governed state 连起来，形成区别于传统云 Agent Platform 的“数据即运行状态”路线。
- **腾讯云本周出现面向 OpenClaw 等 Harness 的商业化入口。**TokenHub Coding Plan 用 OpenAI/Anthropic 兼容协议、订阅请求配额和专属 Base URL 直接覆盖 OpenClaw、Claude Code、Cursor 等工具，但仍偏模型流量入口，不等于完整企业 Agent control plane。
- OpenClaw 参照：平台竞争已从提供模型/API 走向“Runtime + Gateway policy + Identity + Registry + Observability”的闭环。OpenClaw 在跨 channel、cron、session 与自托管方面有 OS 级优势，但需要补 tenant/policy/rate-limit、可验证 agent identity、集中 registry 与 fleet dashboard 才能进入企业控制面竞争。

## 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 有动态 | [Runtime Instances GA，2026-08-06](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-bedrock-agentcore-runtime-instances-generally-available/)；[temporal policy/rate limiting，2026-08-06](https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/) | 是 |
| Google Vertex AI / Gemini Enterprise Agent Platform | 静默 | [官方 release notes；最近更新 2026-08-04，窗口外](https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes) | 否 |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | 静默 | [Foundry 迁移/能力文档，2026-06-19，背景](https://learn.microsoft.com/en-us/azure/foundry/how-to/navigate-from-classic) | 否 |
| 阿里云百炼 / Model Studio / PAI | 静默 | [百炼应用功能动态；2026 年窗口内无新增条目](https://help.aliyun.com/zh/model-studio/application-release-notes) | 否 |
| 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking | 静默/部分获取失败 | [Coze Pro 产品页抓取失败；官网基线](https://www.volcengine.com/product/coze-pro) | 否 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 有动态（商业入口） | [TokenHub Coding Plan，更新 2026-08-12](https://cloud.tencent.com/document/product/1823/130092)；[模型价格，更新 2026-08-12](https://cloud.tencent.com/document/product/1823/130055) | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 有动态 | [Electric 加入 Databricks，2026-08-11](https://www.databricks.com/blog/electric-joins-databricks-bring-wasm-postgres-ai-agent-sandboxes) | 是 |

## 平台六层能力矩阵（初步）

> 说明：矩阵是截至本期的能力基线，“本周强信号”严格只填窗口内事件；“部分/弱”表示虽有相关产品，但尚未看到统一控制面或一等 Agent API。GA/Preview 状态以所引官方文档为准。

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | **强**：AgentCore serverless microVM 最长 8h；Instances 最长 14 天、GPU/内存/计算优化 EC2、capacity provider | **强**：短期/长期 Memory；GovCloud 已补齐 | **强**：AgentCore Gateway、MCP、Registry；caller/target/tool/model 维度 RPS/RPM/TPM/connection 限流 | **强**：IAM/OAuth scope、AgentCore Identity；temporal policy 支持序列、参数来源、HITL、freshness | **强**：Browser、Code Interpreter、microVM/Instances | **强**：CloudWatch/OTel、Evaluations/Optimizations、Policy/Guardrails | Instances GA；temporal policy + rate limit；GovCloud 补齐 Harness/Memory/Policy |
| Google | **强**：Agent Runtime，sub-second cold start、多日 workflow、Sessions、Managed Agents API | **强**：Memory Bank、Memory Profiles、RAG Engine/Vector Search | **强**：Agent Gateway、Registry、MCP/A2A、Native Integrations | **强**：每 agent cryptographic identity、granular policy、审计 | **强**：hardened Workspaces、Code Execution、computer-use/browser sandbox | **强**：Simulation、Evaluation、Observability、Unified Trace Viewer、Optimizer、安全发现 | 无（最近 8/4 CodeMender sandbox 更新在窗口外） |
| Microsoft | **强**：Foundry Agents v2、Hosted Agents GA、multi-agent workflows Preview、Conversations/Responses | **中强**：Agent Memory Preview、Foundry IQ/Work IQ/Fabric IQ | **强**：1,400+ Tool Catalog、MCP/API Management、Foundry Tools | **强**：Entra Agent ID、RBAC、Purview/Defender、Foundry Control Plane Preview | **中**：Hosted Agents/Local CodeAct/Playwright 等能力分散，统一 sandbox 面不如 AWS/Google 清晰 | **强**：Operate/Tracing、OTel、eval、continuous red teaming、fleet health/cost/risk | 无；8/26 Assistants API sunset 为既定迁移背景，非本周公告 |
| 阿里云 | **中**：百炼 Agent 2.0、Workflow、Responses API background task、PAI/高代码部署 | **中强**：知识库、长期记忆 2.0/用户画像 | **中强**：MCP 市场与托管、自定义 MCP、插件/工作流 | **中**：RAM/业务空间/服务关联角色；缺少公开的一等 agent delegated identity | **中弱**：Python 代码解释器/高代码运行环境；统一 browser/computer-use sandbox 不清晰 | **中**：应用观测接 OpenTelemetry、新版评测集 | 无重大公开动态 |
| 火山/字节 | **中强**：Ark/Coze/Coze Studio 承载 bot/workflow；产品边界多线 | **强**：OpenViking 将 Memory/Knowledge/Skills 收束为 Context Database | **中强**：Coze 插件/工作流/MCP 生态 | **中弱**：云 IAM 与平台权限存在，但统一 agent identity/delegation 公开面不足 | **中**：Coze/Ark 执行与代码能力存在；统一企业 sandbox/browser 控制面待核 | **强（单项）**：Coze Loop eval/trace；跨 Ark/Coze 统一 fleet control plane 仍不清晰 | 无重大公开动态；Coze Pro 原页本次抓取失败 |
| 腾讯云 | **中**：智能体开发平台/元器/CloudBase AI Toolkit；TokenHub 提供模型入口 | **中**：LKE/知识引擎与平台知识库；统一 long-term memory API 信号弱 | **中**：CloudBase/技能/模型兼容 API；统一 Agent Gateway 信号弱 | **中弱**：CAM/API Key 为主，agent delegated identity/细粒度 tool permission 待补 | **中弱**：开发/云函数能力可承载执行，统一 managed browser/code sandbox 不清晰 | **中弱**：平台日志/监控分散，统一 agent eval/fleet governance 公开面不足 | Coding Plan 明确接入 OpenClaw 等 Harness，40/200 元订阅，兼容 OpenAI/Anthropic |
| Databricks | **中强**：Mosaic AI Agent Framework/Agent Bricks/Model Serving；Lakebase 承载应用状态 | **强**：Lakehouse/RAG/Lakebase；新增 PGlite local context + Electric sync | **强**：Unity AI Gateway GA、MCP/skills/models/external agents 统一目录和流量治理 | **强**：Unity Catalog identity/permissions/lineage/audit | **中强**：本周明确把 PGlite 带进 agent sandbox，但通用 browser/computer-use 面仍弱 | **强**：MLflow/Agent Evaluation/Unity Gateway 用量、成本、PII/guardrail | Electric/PGlite + Lakebase 将 sandbox 本地状态与中心治理状态同步 |

## 深度笔记

### AWS Bedrock AgentCore

- **本周动态：**AWS 在 8 月 6 日同时推进运行层和策略层。AgentCore Runtime Instances GA 让客户在自己账户中的 AWS 托管 EC2 上运行 agent：capacity provider 指定 OS、允许的 instance types、网络和存储，支持 GPU、memory-optimized、compute-optimized，AgentCore 负责 provision、patch、scale、lifecycle；session 最长 14 天，而 serverless microVM 路径最长 8 小时。首发覆盖 us-east-1、us-east-2、us-west-2、ap-south-1、ap-southeast-1、ap-southeast-2、ap-northeast-1、eu-central-1、eu-west-1，Linux `x86_64`/`arm64`，可共享实例协作，并可使用 Savings Plans/ODCR。策略侧新增 temporal policy：授权判断能读取 session 中此前 action，强制 workflow sequencing、工具参数必须匹配前序输出、privileged action 前 HITL、数据 freshness。Gateway 限流可按 JWT claim、IAM sourceIdentity、target/tool/model 建维度，支持 RPS/RPM、TPM 和 connection，新配置 30 秒内传播；多 limit 采用 AND，最具体规则优先，`rate=0` 可紧急封禁，瞬态 enforcement error 选择 fail-open。官方 August release notes 还显示 GovCloud `us-gov-west-1` 补齐 Memory、Policy、Harness，并把 data-plane quota 从 200 TPS 提至 1,000 TPS、new session 统一为 25 TPS。这已是 Runtime、Gateway、Identity/Policy、Memory、Harness、Observability 的平台级闭环。
- **关键数据：**session 14 天 vs microVM 8 小时；9 个首发 Region；data-plane 1,000 TPS（此前 200）；new session 25 TPS；rate-limit 传播 30 秒；支持 requests/tokens/connections 三类 metric。来源：[Runtime Instances GA，2026-08-06](https://aws.amazon.com/about-aws/whats-new/2026/08/aws-bedrock-agentcore-runtime-instances-generally-available/)、[temporal policy/rate limiting，2026-08-06](https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/)、[August release notes](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html)。
- **原文链接：**https://aws.amazon.com/about-aws/whats-new/2026/08/aws-bedrock-agentcore-runtime-instances-generally-available/ ；https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/ ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- **影响判断：**AWS 已越过“托管 agent container”阶段，开始解决长任务专用硬件、session 历史授权、下游公平性和 GovCloud 合规。对 OpenClaw 最重要的参照不是搬到 EC2，而是把现有 session history 变为 policy 可查询事实：工具审批应能表达“先读后写”“参数来自哪一步”“何时必须人工确认”，Gateway 还需 tenant/user/tool 级预算与并发上限。

### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit

- **本周动态：**腾讯云 8 月 12 日更新 TokenHub Coding Plan，首次把 OpenClaw 与 CodeBuddy、Claude Code、OpenCode、Cline、Cursor、Codex、Kilo 等列为直接支持的 AI coding 工具。产品采用订阅请求配额：Lite 40 元/月，约 1,200 次/5 小时、9,000 次/周、18,000 次/订阅月；Pro 200 元/月，对应约 6,000、45,000、90,000 次。腾讯明确一次用户问题通常触发多次模型调用，简单任务约消耗 5—15 次、复杂任务 15—30 次或更多。接入层同时提供 OpenAI 兼容 `https://api.lkeap.cloud.tencent.com/coding/v3` 与 Anthropic 兼容 `/coding/anthropic`，专属 `sk-sp-` key 与普通后付费 key 不互通；产品禁止非交互式 API/批量 backend 调用。可选 `tc-code-latest` 自动路由、Kimi-K2.5、GLM-5 等，MiniMax-M2.5 于 8 月 7 日下线，Kimi-K2.5 计划 8 月 31 日下线。交叉核验的 8 月 12 日模型价格页显示 TokenHub 已统一多厂模型、缓存价格和广州/新加坡区域，但这仍是模型流量与商业计划层强信号，而非 Runtime、Memory、Identity、Sandbox、Observability 六层齐备的 enterprise control plane。
- **关键数据：**40/200 元每月；Lite 18,000 次/月、Pro 90,000 次/月；简单问题约 5—15 model calls、复杂问题 15—30+；OpenAI/Anthropic 双兼容 Base URL；MiniMax-M2.5 于 2026-08-07 下线。来源：[Coding Plan，更新 2026-08-12](https://cloud.tencent.com/document/product/1823/130092)、[TokenHub 模型价格，更新 2026-08-12](https://cloud.tencent.com/document/product/1823/130055)。
- **原文链接：**https://cloud.tencent.com/document/product/1823/130092 ；https://cloud.tencent.com/document/product/1823/130055
- **影响判断：**腾讯选择先通过兼容协议和订阅把主流 Harness 变成分发入口，商业转化快，但企业 Agent 治理仍需补 agent identity、tool permission、sandbox 与跨工具 trace。对 OpenClaw，这是明确生态机会：可做 TokenHub provider 的一键配置与配额仪表盘；同时要清楚标注其禁止自动化 backend/batch 的套餐边界，不能把交互订阅误用为无人值守 cron/agent fleet 的通用推理容量。

### Databricks Mosaic AI Agent Framework / Agent Bricks

- **本周动态：**8 月 11 日 Databricks 宣布 Electric 团队加入，并明确将 WASM Postgres 带到 AI agent sandbox。PGlite 足够小，可直接在 agent process、sandbox、browser tab 或终端设备运行，为每个 agent 提供本地事务数据库和低延迟 context；Electric real-time sync 再把这些分布式局部状态同步到中心 Lakebase，形成共享、最新且可治理的 definitive record。官方解释了 agent 与传统应用的差异：agent 在运行时决定查询、每秒多次更新 context、在 sandbox 内远离云数据库，并且常以多 agent 并行，需要避免重复、陈旧和冲突工作。PGlite 的每周下载量 12 个月从 100 万增至 1300 万。与 8 月 4 日（窗口外背景）的 Unity AI Gateway GA 结合看，Databricks 的 control plane 路线逐渐完整：Unity Catalog/Gateway 管 identity、permissions、lineage、audit、cost、PII/rate-limit，Lakebase/Electric 管 durable 与 local state，Agent Bricks/Framework 管应用构建与评测。本周新增的是此前相对薄弱的 sandbox 内状态与同步数据平面。
- **关键数据：**公告日期 2026-08-11；PGlite 周下载 1M→13M/12 个月；组件为 PGlite + Electric sync + Lakebase。背景交叉源：Unity AI Gateway 官方称已有 thousands of customers、过去一年超过 1 quadrillion tokens，经客户案例 Zepto 报告 >100B tokens/月；该 GA 公告日期 8 月 4 日，属窗口外背景，不计本周。来源：[Databricks/Electric](https://www.databricks.com/blog/electric-joins-databricks-bring-wasm-postgres-ai-agent-sandboxes)、[Electric founder post](https://electric.ax/blog/2026/08/11/electric-joining-databricks)、[Unity AI Gateway GA（背景）](https://www.databricks.com/blog/unity-ai-gateway-generally-available)。
- **原文链接：**https://www.databricks.com/blog/electric-joins-databricks-bring-wasm-postgres-ai-agent-sandboxes
- **影响判断：**Databricks 没有追随 AWS/Google 复制所有 managed agent primitives，而是从企业数据治理反推 agent state architecture，差异化强。OpenClaw 可借鉴“每 sandbox 本地库 + 中心同步”的离线优先模式，把 session、memory、artifact 和子代理状态从共享目录升级为可合并、可审计、可设保留期的数据层。

## 静默平台简注与能力基线

### Google Gemini Enterprise Agent Platform

- 本周无重大公开动态。官方 release notes 最近条目为 8 月 4 日 CodeMender process-level sandbox/auto-update/token stats，早于窗口；不计本周。能力基线来自官方平台概览：Agent Runtime 支持 sub-second cold start 和多日流程，Memory Bank、Agent Gateway/Registry/Identity、hardened workspace/code execution、Simulation/Evaluation/Observability/Optimizer 六层齐全，是当前与 AWS 最接近的全栈控制面。
- 来源：[平台概览](https://docs.cloud.google.com/gemini-enterprise-agent-platform/overview)、[release notes](https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes)、[发布总览（背景，2026-04-22）](https://cloud.google.com/blog/products/ai-machine-learning/introducing-gemini-enterprise-agent-platform)。

### Microsoft Foundry / Copilot Studio / M365 Agent SDK
- 本周无重大公开动态。当前迁移背景是 Assistants API 将于 8 月 26 日 sunset，客户需迁往 Responses API / Foundry Agents v2；新平台已有 Hosted Agents GA、Agent Memory Preview、multi-agent workflow Preview、1,400+ tools、Foundry Control Plane Preview，Operate 区承载 tracing、quota、compliance 与 admin。该截止日为既定背景，不能冒充本周发布。
- 来源：[迁移文档](https://learn.microsoft.com/en-us/azure/foundry/how-to/navigate-from-classic)、[Foundry stack 背景](https://azure.microsoft.com/en-us/blog/microsoft-foundry-scale-innovation-on-a-modular-interoperable-and-secure-agent-stack/)。

### 阿里云百炼 / Model Studio / PAI

- 本周无重大公开动态。官方应用功能动态的 2026 年最新明确 Agent 相关条目集中在 1—2 月：长期记忆 2.0、异步 workflow、新版 evaluation；产品页目前强调百余模型、MCP 托管、Agent/Workflow、CLI 与 Skills。能力较完整但统一的 agent identity、gateway policy 与 fleet control plane 公开面仍弱于 AWS/Google。
- 来源：[应用功能动态](https://help.aliyun.com/zh/model-studio/application-release-notes)、[百炼产品页](https://www.aliyun.com/product/bailian)。

### 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking

- 本周未检出符合窗口的官方重大平台公告；Coze Pro 官方产品页本次 web_fetch 提取失败，已按规则标注获取失败而非据此判定产品无能力。基线判断：Ark/Coze 提供构建与运行，OpenViking 强化 Context Database，Coze Loop 强化 eval/trace；问题仍是这些模块是否形成统一企业 identity、gateway policy、registry 与 fleet dashboard。
- 来源：[Coze Pro（获取失败）](https://www.volcengine.com/product/coze-pro)、[OpenViking](https://github.com/volcengine/OpenViking)。

## 模块洞察

- **Managed Agent Platform 正从“六个功能都有”进入“六层策略联动”。**AWS 用 temporal authorization、Gateway rate limits 与长周期 compute 抢先把联动做成服务；Google 的六层覆盖最均衡；Microsoft 依靠 Entra/Defender/Purview 做企业治理；Databricks则以 Unity + Lakebase/Electric 从数据与状态切入。中国平台本周更多仍是模型/工具商业入口，统一 agent identity、策略网关和 fleet observability 是最明显缺口。

## OpenClaw 战略参照

1. **领先点：**OpenClaw 原生拥有跨消息通道、cron、session、Gateway、skills/plugins 与 subagents 的统一个人/团队 OS 体验，云平台通常仍需拼接前台入口。
2. **必须补课：**参考 AWS temporal policy，把 session 历史、tool output provenance、HITL 与 freshness 变成 policy engine 可消费的结构化事实；参考 Google/AWS 增加 agent identity、registry、tenant/user/tool 级 rate limit 和 fleet health/cost dashboard。
3. **生态机会：**腾讯 TokenHub 已明确把 OpenClaw 列为支持工具，可做合规的一键 provider 接入与用量展示；Databricks PGlite/Electric 路线可启发 OpenClaw 的 local-first session DB 与团队同步；AWS/Google 的 MCP/OTel 控制面可作为企业部署适配目标，而不必自建所有云基础设施。


---

## 跨模块结论与 OpenClaw 路线建议

1. **优先补企业授权上下文。** 每个 tool call 都应携带用户、Agent、租户、session/task、resource/audience、scope、委托到期时间；缺项默认拒绝。cron/background run 不能因无人在线而自动退化为共享 service account。
2. **把 session history 升级为可验证的策略事实。** 参考 AWS temporal policy，支持先读后写、输出到输入一致性、预算累计、一次性 HITL 消费、freshness 与长时间无人参与后的权限衰减。
3. **建立可替换的 Context Database 接口。** 用真实负载比较 OpenClaw 原生 memory 与 OpenViking context mode；统一 provenance、版本、ACL、保留期、撤销与可验证删除。
4. **Gateway 增加配额与凭据隔离。** 实现 tenant/user/tool/model 级 request/token/concurrency limits；引入 connected-account + broker/relay，使 provider token 不进入模型上下文、skill 或普通日志。
5. **把 OTel trace 提升为 fleet 控制面。** 统一串联 Gateway、模型、工具、sandbox、memory、policy decision、approval 与上游 provider，补齐健康、成本、风险、回放与评测面板。

## 质量门控自检

- ① 模块覆盖：**8/8 通过**。
- ② 平台矩阵：**7/7 通过**（AWS、Google、Microsoft、阿里云、火山/字节、腾讯云、Databricks）。
- ③ GitHub 热度补漏：**通过**；九方向已扫描，补入与过滤对象均有记录，OpenViking / Cognee / supermemory / Crawl4AI 未遗漏。
- ④ 原文深度：**通过**；抽查 AWS AgentCore、OpenViking、Microsoft Entra Agent ID、Databricks Electric、WorkOS 五个有料对象，URL、日期、原文内容与结论对应。
- ⑤ 判断质量：**通过**；八个模块均有模块洞察，TOP 5 按基础设施格局信号价值排序。
- ⑥ 数据可信：**通过**；关键数字附来源和日期，GitHub 数据直查；获取失败与项目方自报数据已显式标注。
- ⑦ Identity/Auth/Permission：**通过**；覆盖 OAuth/OIDC/MCP auth、token 托管、用户授权、tool permission、审计、越权和数据泄露防护。
- ⑧ OpenClaw 参照：**通过**；已给出 Harness、Runtime、Gateway、Identity、Memory、Observability 的机会、威胁与补课建议。
