# 全球 AI Agent 基础设施研究周报 · 第 10 期

- **本期时间窗**：2026-08-13 00:00—2026-08-19 24:00（Asia/Shanghai）
- **研究对象**：Agent Harness 八层能力栈，以及 AWS、Google、Microsoft、阿里云、火山/字节、腾讯云、Databricks 七个平台控制面
- **证据口径**：只有发布时间或提交时间可确认落入窗口的原始公告、文档、release、commit 才计为本周动态；窗口外信息只作背景。GitHub stars/forks 为 2026-08-20 快照，不代表周增量。

## 执行摘要

本周 Agent 基础设施的竞争，不是“再造一个 Agent 框架”，而是把 **恢复、权限、执行、记忆与治理**做成可验证的系统契约：Harness 控制层集中补 checkpoint、resume、approval 与父子执行链；Sandbox 开始在宿主侧强制网络出口；MCP 工具层从协议接通进入凭据绑定、session routing 与 SSRF 防护；Identity 从 OAuth scope 走向 actor delegation 与参数级一次性批准；Memory 则被两次“向量静默丢失”事故推入数据库可靠性阶段；Observability 开始把人工批准与工具轨迹纳入完整 trace。

七个平台中，Microsoft 本周给出的控制面最完整：Foundry 将 Hosted Agents、Responses API、Toolbox、Entra identity、VM-isolated session sandbox、state/checkpoint/approval store 与 observability 串为一体。AWS 的存量模块面最广但本周缺少可定位日期的新公告；Google 的强信号主要在 ADK 2.7.0；火山/字节借 OpenViking 从 Context DB 向 Session/Plugin/Workspace 上探；Databricks 通过现场 grounded eval 证明 Harness 工程本身可带来 30.4 个百分点的同模型差距；阿里云和腾讯云在公开材料中对 Agent 专属 identity、统一 gateway、sandbox 与 eval control plane 的证据仍相对薄弱。

## 本周 TOP 5

1. **OpenViking 0.4.14/0.4.15：Context Database 进入可写工作区，同时暴露静默向量损坏风险。** Session、MCP `tree/write/edit`、Agent Plugins 与 Memory V3 合流；紧急修复则证明索引完整性、依赖锁定和可重建能力已是 Memory 的首要门槛。
2. **Microsoft Foundry：企业 Agent 控制面开始成套交付。** Hosted Agent 的 per-session state、VM 隔离、专属 Entra identity、Toolbox MCP endpoint 与 Agent Framework 的 checkpoint/approval store 同周对齐。
3. **ToolHive + WorkOS：Agent 授权从“有 token”升级为“可验证委托链 + 当次行为批准”。** RFC 8693 `actor_token`、audience、`may_act`、SSRF 与参数哈希绑定的一次性 step-up approval，补上 OAuth scope 无法证明当下用户意图的空档。
4. **E2B + browser-use：执行环境的竞争转向强制边界与状态可靠性。** E2B 将 SOCKS5 出口代理放在宿主侧且先过 allow/deny；browser-use 0.13.8 则补齐远程下载、storage state、MCP 错误和跨 Agent 状态污染。
5. **Langfuse + Phoenix + Braintrust：治理进入 approval-aware trace 与 trajectory gate。** 审批链、机器可读 decision、轨迹评分、CI 门禁和生产失败回灌数据集，开始组成 Agent 上生产的闭环。

## GitHub 热度补漏

本期在正式研究前执行了九组查询：`agent memory github`、`agent context database github`、`agent knowledge graph github`、`AI agent RAG memory skills github`、`MCP gateway github`、`agent auth permission OAuth MCP github`、`browser agent runtime github`、`agent observability eval github`、`agent harness runtime github`。按 Harness 模块复核仓库定位、stars/forks、窗口内 commits、release 正文与提交原页。

- **补入深写**：OpenViking、Cognee、supermemory、ToolHive、mcp-gateway-registry、E2B、browser-use、Langfuse、Arize Phoenix、Composio。
- **高热但窗口静默**：Crawl4AI、Mem0、Graphiti、agent-browser、Daytona、AgentOps；均保留雷达，不包装成本周新闻。
- **过滤**：awesome-list、教程/课程、产品示例、纯应用模板，以及未完成原文和时间窗核验的候选。
- **时区排除**：Cognee v1.5.0.dev3、Langfuse v4.15.0 与 E2B 2.41/2.42 均在上海时区 8 月 20 日发布，明确留待下期。

---
## 模块 1：Harness / Agent OS 控制层

- 本期时间窗：Asia/Shanghai 2026-08-13 00:00 至 2026-08-19 24:00。
- 证据口径：只把发布时间换算后落在窗口内的公告、release 或 commit 计为本周动态；窗口外内容只作背景。GitHub 匿名 REST API 在本轮已触发限流，故不编造 stars/forks，版本与发布时间改由 release 原页及 HTML `datetime` 直查。

## 本周模块结论

- 本周主线不是再造一种 planner，而是把 **session、checkpoint、resume、approval、tool result 与用量核算**做成可恢复、可审计的控制层语义：OpenAI、Anthropic、Google、Microsoft 同周在这些边界上密集修补。
- MCP/A2A 正从“能接通”进入“生命周期与权限正确”：Claude Agent SDK 直接采用 MCP 2.x 内存传输，ADK 修 A2A 恢复与对端元数据边界，Microsoft 将 approval 持久化进 Foundry state store。
- OpenClaw 2026.8.1-beta.2 的差异化仍是完整 Agent OS：Gateway、跨渠道 durable ingress、子 Agent completion push、Control UI scope、SQLite checkpoint 与原生 CLI session resume 同一发行面推进；相对 SDK 型竞品覆盖面领先，但需要继续收敛公开稳定 API 与版本级能力说明。

## 固定对象状态表

| 对象 | 本周状态 | 证据源（日期均为上海时区） | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态 | [2026.8.1-beta.2](https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2)，2026-08-15 13:36 | 是 |
| OpenAI Agents SDK / Responses API | 有动态 | [Agents SDK v0.22.0](https://github.com/openai/openai-agents-python/releases/tag/v0.22.0)，2026-08-19 21:44 | 是 |
| Anthropic Claude Agent SDK / MCP | 有动态 | [Claude Agent SDK v0.2.140](https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.140)，2026-08-19 04:58 | 是 |
| LangChain / LangGraph / LangSmith | 静默（控制层重大动态） | [LangGraph releases](https://github.com/langchain-ai/langgraph/releases)；最近列出的 1.2.11 发布于上海 2026-08-11，窗口外 | 否 |
| Google ADK | 有动态 | [ADK Python v2.7.0](https://github.com/google/adk-python/releases/tag/v2.7.0)，2026-08-14 06:18 | 是 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 有动态 | [Agent Framework Python 1.14.0](https://github.com/microsoft/agent-framework/releases/tag/python-1.14.0)，2026-08-14 10:08 | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 静默（产品发布）/有评测信号 | [Grounded Reasoning Cup 原文](https://www.databricks.com/blog/evaluating-ai-agents-live-grounded-reasoning-cup)，窗口内页面；未发现 Agent Framework/Bricks 新版本公告 | 否（模块8深写） |
| CrewAI（动态池） | 静默 | [CrewAI releases](https://github.com/crewAIInc/crewAI/releases)，未核验到窗口内基础设施级公告 | 否 |
| Dify（动态池） | 静默 | [Dify releases](https://github.com/langgenius/dify/releases)，未核验到窗口内 runtime/control-plane 级公告 | 否 |
| n8n（动态池） | 静默 | [n8n releases](https://github.com/n8n-io/n8n/releases)，普通 workflow 更新不纳入 | 否 |
| Flowise（动态池） | 静默 | [Flowise releases](https://github.com/FlowiseAI/Flowise/releases)，未核验到窗口内基础设施级公告 | 否 |

## 深度笔记

### OpenClaw

- **本周动态：** OpenClaw 在 8 月 15 日发布 2026.8.1-beta.2，原始 release 展示的不是单点模型适配，而是 Agent OS 控制面的系统性收敛。子 Agent 侧，Codex fan-out 在子任务成功 terminal yield 后立即结算，并保持 requester ownership，使结果可靠回推父会话；同时明确 native subagent 应使用 `sessions_yield` 接收后续完成事件。状态侧，SQLite snapshot verification 被移到独立进程，避免 worker 关闭文件时破坏 Gateway 的 POSIX WAL 锁；共享状态读写损坏则只驱逐已证实损坏的缓存 owner，避免整网关重启。权限侧，Control UI 对新线程、checkpoint、分享、Agents、Skills 与 Skill Workshop 的写操作按 Gateway method catalog 和 operator scopes 动态门控，异步命令在执行前还会重新核对 scope，并绑定原始 Gateway，防止重连后把写操作投向替代连接。渠道侧，Telegram durable ingress 在 replay 时保留 control-lane ownership。路线判断：OpenClaw 正把“聊天机器人框架”推向多用户、多渠道、可恢复、带原生运维面的 Agent OS；优势是控制面宽度和本地/私有部署自主性，代价是发行面很大，beta 变更需要更清晰的稳定性等级与兼容契约。
- **关键数据：** 版本 `2026.8.1-beta.2`；GitHub HTML 发布时间 2026-08-15T05:36:23Z（上海 13:36）；原始 release 包含 issue/PR 级变更链接。stars/forks 因匿名 API 403 未记录，避免使用搜索转述。
- **原文链接：** https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2 （2026-08-15）；交叉入口 https://github.com/openclaw/openclaw/releases （2026-08-20 查阅）。
- **影响判断：** OpenClaw 已把 session ownership、durable ingress、checkpoint、Gateway 授权与 UI 运维串成闭环，这比仅提供 run loop 的 SDK 更接近真正 OS。下一步应把这些语义抽成稳定、可测试、可观测的公共控制面接口，并为跨版本状态迁移提供明确 SLA。

### OpenAI Agents SDK / Responses API

- **本周动态：** Agents SDK Python v0.22.0 于 8 月 19 日发布，官方将其定义为“substantial runtime hardening”。最关键变化是被 agent output guardrail 拒绝的终端 function-tool 输出，不再进入可重放与持久化 SDK state，堵住“展示层拦截但 replay 仍带敏感结果”的隐蔽泄漏；非流式 Responses 若终态为 `failed` 或 `incomplete`，`get_response` 现在抛 `ModelBehaviorError`，应用不再把异常终态误当成功返回。`RunState` 独立 checkpoint 的 usage 计数被隔离，同时保留 nested-agent 聚合，说明成本核算已经进入恢复点语义。显式传入 `openai_client` 时若仍同时给 provider 的 organization/project，SDK 会拒绝冲突配置，调用方须把这些值移到 `AsyncOpenAI` 客户端。生成的 graph 也会展开 `handoff(agent)` 注册对象。路线判断：OpenAI 正把 Responses API 上方 SDK 从轻量 handoff helper，推进为具备持久状态、guardrail、图可视化和准确计量的生产 harness；本周没有单独 Responses API 产品公告，不能把 SDK 修复外推成 API 新定价或新 SLA。
- **关键数据：** v0.22.0；发布时间 2026-08-19T13:44:38Z（上海 21:44）；release 列出 18 个变更/文档与贡献项；定价、客户与 benchmark 本次未公开。
- **原文链接：** https://github.com/openai/openai-agents-python/releases/tag/v0.22.0 （2026-08-19）；完整差异 https://github.com/openai/openai-agents-python/compare/v0.21.1...v0.22.0 。
- **影响判断：** blocked tool output 从 replay state 中真正删除，是企业审计和数据最小化的重要语义；checkpoint usage 隔离则直接改善多 Agent 成本归因。OpenClaw 可对照增加“被策略拒绝的数据不得进入 transcript/memory/backup”的端到端不变量测试。

### Anthropic Claude Agent SDK / MCP

- **本周动态：** Claude Agent SDK Python v0.2.140 在 8 月 19 日发布，核心是 MCP 2.x 与嵌套 Agent 可观测性。依赖范围扩为 `mcp>=1.23.0,<3.0.0`，in-process MCP server 不再走自制 JSON-RPC dispatch，而使用 MCP 自身 in-memory transport，因此手工构造的 `mcp.server.Server` 可以原样传递 resources、prompts 与所有 result content types，MCP 2.x 还支持 interrupt 时取消工具。`forward_subagent_text` 让子 Agent 的 text 与 thinking block 进入主 stream；`get_subagent_messages*` 恢复 `parent_tool_use_id`，并新增 `parent_agent_id`，为嵌套执行树建立可追踪父子关系。失败处理从裸 `exit code 1` 升级为结构化 `ResultError`，携带 subtype、errors、result、`api_error_status`、`terminal_reason`、`session_id` 与原始字典。权限回调 `can_use_tool` 也扩展至 `query()` 和字符串 prompt，CLI 通过保持 stdin 开放来发送 control-protocol permission request。路线判断：Anthropic 在把 Claude Code 的成熟 session/control protocol 逐步产品化为 SDK，而 MCP 成为工具与权限的原生总线。
- **关键数据：** v0.2.140；发布时间 2026-08-18T20:58:34Z（上海 2026-08-19 04:58）；bundled Claude CLI 2.1.235；PyPI 安装版本 `claude-agent-sdk==0.2.140`；未公布定价或客户。
- **原文链接：** https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.140 （2026-08-19）；PyPI https://pypi.org/project/claude-agent-sdk/0.2.140/ 。
- **影响判断：** 采用 MCP 官方 transport 而不是自行模拟协议，可显著减少协议漂移；结构化 terminal error 和父子 Agent linkage 让托管平台能按失败类型重试、计费与审计。OpenClaw 应优先保证 MCP 版本兼容矩阵、tool cancellation 及 parent-child trace 与 Claude SDK 对等。

### Google ADK

- **本周动态：** ADK Python v2.7.0 于 8 月 14 日进入窗口，官方称其为 correctness release，共 212 项变化。模型能力从“按 model id 猜测”改为模型自报 capability，只有模型真实支持时才把 output schema 与 tools 配对；tool function response 可把图片及其他 media 原样送回 Gemini，也覆盖 Anthropic、LiteLLM、Apigee 和 OCI provider。会话历史完整保留 Gemini thought signatures、server-side tool-call parts 和并行 function call 的每个结果，避免 resume/replay 后语义漂移。控制层新增 root `LlmAgent` native task mode，MCP Toolset 的 elicitation callback、复用 server tool list、HTTP trace debugging，以及 Jinja2 指令模板（`use_jinja2=True`，可遍历 session state 并通过 `artifact()` 加载制品）；异步 runtime 可非阻塞加载 skills。安全/正确性修复还包括限制网络取得的 A2A agent card RPC 目标、忽略不安全 peer event metadata、OAuth token exchange timeout、artifact 路径穿越防护、Cloud Run sandbox 超时、HITL 恢复注入 transfer tool。`pyarrow` 移出 gcp extra，安装体积约减少 50MB，BigQuery analytics 用户需显式安装新 extra。
- **关键数据：** v2.7.0；发布日期 2026-08-13（GitHub 发布时间上海 2026-08-14 06:18）；212 changes；`google-adk[gcp]` 约减少 50MB；artifact 单文件限制 20MB；未披露价格/客户。
- **原文链接：** https://github.com/google/adk-python/releases/tag/v2.7.0 （2026-08-14）；提交清单与 compare 链接见 release 原文。
- **影响判断：** ADK 已从 Gemini 专用开发包走向多模型、A2A/MCP、skill、task、eval 与托管部署共用的控制层；最大信号是“capability discovery + history fidelity”，即 harness 不再靠模型名硬编码。OpenClaw 的模型 registry 也应公开 capability schema，并对 replay 所需的 provider-specific opaque parts 做保真保存。

### Microsoft Agent Framework / Semantic Kernel / AutoGen

- **本周动态：** Microsoft Agent Framework Python 1.14.0 于 8 月 14 日发布，是本周最明显的“框架与托管控制面合流”。`AgentFrameworkWorkflow` 新增 checkpoint creation/resume；`BackgroundAgentsProvider.release_session()` 可安全取消工作并释放每 session runtime state；Foundry hosting 引入 provider-based state stores，覆盖 agent session、checkpoint 与 function approval，并迁移至 Agent Server Responses 2.x storage model。AG-UI 修复 approval resume、interruption recovery 与 replay 的 occurrence-safe 语义；Foundry hosted-agent session ID 与 conversation continuation ID 被分离，避免把服务端会话与客户端续聊指针混为一谈。新增实验性 `AGENT-HOOKS-0.1` enforcement middleware、OpenAI 请求准备/响应解析 hooks 和 Mistral 原生 client；Durable Task/Azure Functions 被拆到独立 extension repo，核心仍 re-export 公共符号。安全方面拒绝 Windows junction skill discovery、转发 Azure AI Search query-source identity、对 GitHub Copilot 的“本 session 批准”缩小到当前工具。Semantic Kernel/AutoGen 本周未发现独立重大公告，其能力正被 Agent Framework 主仓的统一 session/workflow/hosting 面吸收。
- **关键数据：** Python 1.14.0；release 标注 2026-08-13，GitHub 发布时间 2026-08-14T02:08:06Z（上海 10:08）；Agent Server 依赖升级到 2.1 beta line；未披露价格/客户。
- **原文链接：** https://github.com/microsoft/agent-framework/releases/tag/python-1.14.0 （2026-08-14）；Durable 扩展 https://github.com/microsoft/agent-framework-durable-extension 。
- **影响判断：** Microsoft 的路线是以 Agent Framework 统一 AutoGen/Semantic Kernel 的开发范式，并让 Foundry 承接持久化、身份与托管。对 OpenClaw 的威胁不在单个 planner，而在企业采购、Entra 身份和 Responses-compatible hosted agent 的组合；机会是保持本地优先与跨云，同时兼容其 checkpoint/approval 协议边界。

## 静默对象补充

- **LangChain / LangGraph / LangSmith：** 本周未核验到窗口内控制层重大正式发布；release 页展示的 LangGraph 1.2.11 发布时间为上海 8 月 11 日，严格排除。背景上其 checkpoint、cron、trace policy 仍是生产图编排基线，但本期不以窗口外版本凑数。
- **Databricks Mosaic AI Agent Framework / Agent Bricks：** 未发现窗口内框架/Bricks 新组件公告；窗口内 Grounded Reasoning Cup 给出 harness 评测强信号，放模块8深写。
- **CrewAI / Dify / n8n / Flowise：** 已逐项扫描；未核验到同时满足“窗口内 + 平台/runtime/observability/enterprise deployment”标准的强信号，普通 workflow、模板和应用连接器更新不纳入。

## 模块洞察

- **Harness 控制层正在标准化“恢复与治理语义”，但实现仍碎片化。** checkpoint/resume、tool approval、嵌套 Agent lineage、provider capability、MCP/A2A 生命周期已成为共同标准件；云厂 SDK倾向把它们绑定托管平台，而 OpenClaw 的机会是以开放 Gateway 和本地可控状态层提供跨模型、跨渠道的 Agent OS 参照实现。

## OpenClaw 参照（行动项）

1. 建立 provider capability schema，替代按模型名推断 tool/schema/media/reasoning 能力，并为 opaque provider history 做 replay fidelity 测试。
2. 把“guardrail 拒绝的数据不得落 transcript、memory、checkpoint、backup”设为端到端安全不变量，补齐可验证 redaction evidence。
3. 将 parent-agent / parent-tool-use lineage、结构化 terminal error、checkpoint usage 隔离统一进 tracing API，便于托管、重试、成本与审计。


---

## 2. Runtime / Session / State 执行层

- **严格时间窗**：Asia/Shanghai 2026-08-13 00:00 至 2026-08-19 24:00；窗口外信息仅作背景，不计“本周动态”。

### 本周模块结论
- 本周可核验的强信号来自 Microsoft：Foundry Agent Service 在 8 月 13 日更新的官方总览中，把 Prompt agents、Hosted agents 与直接 Responses API 明确拆成持久托管、容器托管和临时 agent 三种运行形态；session-level state persistence、每 session 容器伸缩、专属 Entra identity 已成为 Hosted Agent 的标准能力组合。
- Google 本周主要更新 Agent Platform Workbench 镜像与安全依赖，而非 Agent Engine/Managed Agents API 的生命周期能力；国内三家云公开渠道未发现落入窗口且可由原文确认的 runtime/session 重大变化。AWS AgentCore release notes 有多项 August 条目但页面不标逐项日期，无法证明落入本窗口，故不强行计入。
- OpenClaw、E2B、Modal、Daytona 本周没有可严格归入“长任务/托管 runtime”的公开发布；E2B 的有效信号是 sandbox 网络出口控制，移至模块 3 深写。

### 固定对象状态表

| 对象 | 本周状态 | 证据源（读取/核验日期） | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 静默（August 条目缺逐项日期，不能证明在窗） | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html （读取 2026-08-20） | 否 |
| Google Vertex AI Agent Engine / Managed Agents API | 静默；仅 Workbench 镜像动态 | https://docs.cloud.google.com/vertex-ai/docs/release-notes （条目 2026-08-16） | 否 |
| Microsoft Foundry Hosted Agents / Agent Service | 有动态 | https://learn.microsoft.com/en-us/azure/foundry/agents/overview （ms.date 2026-08-13） | 是 |
| 阿里云百炼 / Model Studio / PAI Agent 托管 | 静默 | https://help.aliyun.com/zh/model-studio/single-agent-application （读取 2026-08-20） | 否 |
| 火山 Ark / Coze / Coze Studio | 静默 | https://www.volcengine.com/ （读取 2026-08-20） | 否 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 静默 | https://cloud.tencent.com/document/product/1759/104191 （公开动态截至 2026-03） | 否 |
| OpenClaw sessions / cron / Gateway runtime | 有动态：2026.8.1-beta.2；控制层详见模块 1，本模块补充 runtime 影响 | https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2 （上海 2026-08-15） | 模块1深写 |
| E2B | 动态归模块 3 | https://github.com/e2b-dev/E2B/commit/6824cdf3134345d93f710da7667a7028796f5628 （2026-08-19） | 模块3 |
| Modal | 静默 | https://modal.com/blog （读取 2026-08-20；最近可见文章 2026-08-04） | 否 |
| Daytona | 静默 | https://github.com/daytonaio/daytona （hot scan：窗内 0 commits，最近 release 2026-06-23） | 否 |

### 深度笔记

#### Microsoft Foundry Hosted Agents / Agent Service
- **本周动态**：Microsoft 于 2026-08-13 更新 Foundry Agent Service 官方总览，把运行时产品边界写得非常清楚：Prompt agent 由平台托管 instructions、model 和 tools；Hosted agent 可交付容器镜像或源码 `.zip`，后者由 Foundry 构建镜像；第三种是应用自行调用 Responses API 的 ephemeral agent，不在 Foundry 中创建持久 agent 资源。Hosted agent 支持 Agent Framework、LangGraph、OpenAI Agents SDK、Anthropic Agent SDK、GitHub Copilot SDK 或自定义代码，并提供 managed endpoint、自动伸缩、每 agent 专属 Entra identity、**session-level state persistence** 与端到端可观测。官方对伸缩语义进一步写明为“按 session 和请求量伸缩容器实例”，成本模型则是模型/工具按调用计费再叠加 container compute。网络隔离方面，Hosted agent 的每个 session 运行于 VM-isolated sandbox，并可接入客户 VNet；会话状态也可落在客户自有 Cosmos DB。技术上这不是又一种 agent SDK，而是把 agent definition、session state、identity、sandbox、toolbox MCP endpoint 和发布版本统一成托管生命周期。商业上，Microsoft 正用“框架无关 + Azure 身份/网络/治理”降低企业从自托管容器迁移的阻力，并用 Prompt/Hosted/Ephemeral 三档覆盖不同控制权需求。
- **关键数据**：官方文档 `ms.date=2026-08-13`；Hosted agent 支持 5 类点名框架/SDK外加自定义代码；两种交付物（container image / `.zip`）；成本三部分为 inference、tool usage、container compute。来源：https://learn.microsoft.com/en-us/azure/foundry/agents/overview ，2026-08-13。
- **原文链接**：https://learn.microsoft.com/en-us/azure/foundry/agents/overview
- **影响判断**：托管 Agent runtime 的竞争单位已从“可部署一个容器”变为“能否同时管理 session state、隔离、身份和工具治理”。OpenClaw 的 Gateway/sessions/cron 在跨渠道长任务与本地控制上仍有差异化，但若面向 Azure 企业部署，需要补齐显式的 per-session 资源隔离、持久状态后端契约、自动伸缩指标与专属 workload identity 映射。

### 静默对象背景与竞争判断
- **AWS AgentCore Runtime**：官方 August 页面目前列出 Instances compute type（客户账户内 AWS 托管 EC2、最长 14 天 persistent session、GPU、shared instance）以及数据面 1,000 TPS、new session 25 TPS 等信息，但页面没有逐条发布日期；因无法证明在 8/13–8/19 发布，本期不计动态。它仍代表“长 session + 自有账户数据面 + capacity provider”的云原生路线。来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html 。
- **Google**：Vertex release notes 在 8/16 只有 Agent Platform Workbench 镜像/依赖安全更新，没有 Agent Engine/Managed Agents API 的 session、state 或生命周期新品。来源：https://docs.cloud.google.com/vertex-ai/docs/release-notes 。
- **阿里云、火山/Coze、腾讯云**：逐一检查公开产品页、帮助文档与产品动态页，未发现窗口内可核验的 runtime/session 重大公告；维持各自一站式应用构建/模型调用/发布能力的存量竞争判断，不以旧文冒充本周新闻。
- **OpenClaw**：2026.8.1-beta.2 已由 release 原页时间确认于上海 8 月 15 日发布，包含 SQLite snapshot verification、Gateway supervision、durable ingress 与 session ownership 等强 runtime 信号；为避免跨模块重复，完整深写放在模块 1，本模块只记录其对持久会话与恢复语义的影响。来源：https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2 。
- **Modal / Daytona**：Modal 博客最近可见 8/4，Daytona hot scan 窗内 0 commit，故无动态；E2B 本周 BYOP 属执行环境网络边界而非长任务生命周期，见模块 3。

### 模块洞察
- **洞察**：Runtime 正被云厂收编成“agent 类型 + session 状态 + 容器隔离 + workload identity + 计量伸缩”的成套控制面；单纯提供长进程已不够，决定企业迁移成本的是状态与身份能否跨版本、跨工具、跨网络边界稳定延续。
- **OpenClaw 参照**：应把 session durability、cron/异步作业、Gateway recovery 的优势产品化为可测量 SLO，同时定义 session-to-sandbox、session-to-identity、session-to-state-store 的一等映射；这是与 Foundry Hosted Agents 对标时最直接的补课项。


---

## 3. Sandbox / Computer Use / Browser 执行环境层

- **严格时间窗**：Asia/Shanghai 2026-08-13 00:00 至 2026-08-19 24:00；窗口外信息只作背景。

### 本周模块结论
- 本周最强的 sandbox 信号不是新增一种“浏览器 agent”，而是执行边界工程化：E2B 在 8/19 引入 BYOP SOCKS5 出口代理，并把代理放在宿主侧、allow/deny 之后且 fail-closed；这使企业可把 agent 流量纳入既有审计、静态出口 IP、合规与数据防泄漏基础设施。
- browser-use 0.13.8（8/17）集中修复远程下载完成回调、storage state、跨 agent 可变状态、DOM 可见性、MCP 错误语义，并首次加入 OpenClaw skill 支持；高热开源 browser runtime 正从“能跑 demo”转向可靠状态机与多模型兼容。
- Azure Browser Automation 的官方正文位于窗口前（8/5），本周没有新品；AWS、Google、OpenAI、Anthropic、Browserbase、Daytona、Modal 也未找到严格窗口内可核验的重大公开发布，全部如实记静默。

### 固定对象状态表

| 对象 | 本周状态 | 证据源（发布日期） | 是否深写 |
|---|---|---|---|
| E2B | 有动态：BYOP egress proxy | https://github.com/e2b-dev/E2B/commit/6824cdf3134345d93f710da7667a7028796f5628 （2026-08-19） | 是 |
| Browserbase / Stagehand | 静默；Stagehand v4 在 8/10，窗外 | https://browserbase.com/changelog （2026-08-10，背景） | 否 |
| Daytona | 静默 | https://github.com/daytonaio/daytona （hot scan：窗内 0 commits） | 否 |
| Modal | 静默 | https://modal.com/blog （最近可见 2026-08-04） | 否 |
| OpenAI Computer Use / Browser / Code Interpreter | 静默 | https://developers.openai.com/api/docs/guides/tools-computer-use （读取 2026-08-20） | 否 |
| Anthropic Computer Use | 静默 | https://support.claude.com/en/articles/12138966-release-notes （最近相关条目 2026-08-06） | 否 |
| AWS AgentCore Browser / Code Interpreter | 静默（August release notes 无逐项日期） | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html | 否 |
| Azure Browser Automation / Code Interpreter / Playwright Workspaces | 静默；BAT 正文 8/5，窗外 | https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/browser-automation （2026-08-05） | 否 |
| Google Code Execution / Managed Agents sandbox | 静默 | https://docs.cloud.google.com/vertex-ai/docs/release-notes （2026-08-16 仅 Workbench 镜像） | 否 |
| browser-use（补漏） | 有动态：0.13.8 | https://github.com/browser-use/browser-use/releases/tag/0.13.8 （2026-08-17） | 是 |

### 深度笔记

#### E2B：自带出口代理（BYOP）
- **本周动态**：E2B 在 2026-08-19 的 commit `6824cdf` 为 Sandbox Network 增加 `egressProxy?: SandboxEgressProxyOpts`，允许用户提供 `host:port` 形式的 SOCKS5 代理以及可选 RFC 1929 username/password。关键设计不是“支持代理”四个字，而是控制位置：TCP 隧道在 **host 侧**发生，且先执行 `allowOut` / `denyOut` 和 per-host rules，再把剩余连接转发到代理；sandbox 内没有代理进程，运行代码看不到代理、也不能绕过。代理不可达或协议不符时连接 fail closed，不回退直连。hostname 在拨号时重解析并将结果 pin 到该连接，解析为私网/内部地址会在 sandbox 创建前拒绝；API 返回的 `SandboxEgressProxyInfo` 不含 password。能力覆盖 E2B Cloud 与 BYOC，但基于开源 `e2b-dev/infra` 自建部署会拒绝该参数。限制同样明确：只隧道 TCP，DNS 与 QUIC/HTTP3 等 UDP 流量仍按原路径离开。商业上，这是 E2B 对企业代理池、地域出口、审计网关与合规网络的直接适配；技术上，它把 egress policy 与 egress transport 解耦，优于在容器内注入环境变量代理，因为后者可被 agent 代码读取或篡改。
- **关键数据**：commit 日期 2026-08-19；代理协议 SOCKS5；用户名/密码上限各 255 bytes；仅 TCP，UDP/DNS/QUIC 不隧道；适用 E2B Cloud/BYOC、不适用开源 infra 自建。来源：https://github.com/e2b-dev/E2B/commit/6824cdf3134345d93f710da7667a7028796f5628 。GitHub hot scan 快照（2026-08-20）：13,476 stars、1,001 forks、窗口内 16 commits。
- **原文链接**：https://github.com/e2b-dev/E2B/commit/6824cdf3134345d93f710da7667a7028796f5628
- **影响判断**：企业购买 sandbox 的决策正从冷启动/价格转向“流量能否被强制纳管”。E2B 的宿主侧、策略后、失败关闭模型值得 OpenClaw sandbox/browser 路由直接借鉴；但 UDP 未纳管必须在安全文档中显式标注，敏感场景应禁 QUIC 并指定受控 DNS，而不能把 BYOP 等同于全流量隧道。

#### browser-use 0.13.8（GitHub 热度补漏）
- **本周动态**：browser-use 于 2026-08-17 发布 0.13.8，并一并标记 Browser Harness 0.1.9。此版不是单一大功能，而是生产可靠性密集修复：remote-browser downloads 现在触发 complete callback；传入内存 dict 的 `storage_state` cookies 会正确应用；每个 `MessageManager` 使用独立 state，修复 mutable default 导致跨 agent 状态污染；空 action list、预算警告除零、空 Bedrock Claude 响应、异步 callback error、PIL GIF 资源泄漏均增加防护。DOM 层修复 paint-order-occluded 文本泄露给 LLM、trailing newline 分块边界与 stacking context 类型；MCP 侧给只读工具写入 `readOnlyHint`，并把 `CallToolResult.isError` 映射为 failed `ActionResult`。模型兼容上恢复 Anthropic 将 tool args 序列化为文本时的参数、读取 Groq structured tool output，并更新 Cerebras/Bedrock 模型标识；同时默认 `ChatBrowserUse` 为 `bu-2-0-mini-preview`。更值得本报告关注的是首方 OpenClaw skill support：browser-use 开始直接进入 Agent OS 技能分发路径。商业路线显示其在用开源 SDK/Harness 做兼容层，再以 hosted agent API / Cloud v4 承接托管执行。
- **关键数据**：版本 0.13.8、Browser Harness 0.1.9；GitHub hot scan 2026-08-20 快照为 109,783 stars、12,070 forks、窗口内 28 commits；release 正文列出 30+ 项变更。来源：https://github.com/browser-use/browser-use/releases/tag/0.13.8 ，2026-08-17；仓库：https://github.com/browser-use/browser-use 。
- **原文链接**：https://github.com/browser-use/browser-use/releases/tag/0.13.8
- **影响判断**：browser runtime 的护城河越来越像分布式状态机：远端下载、cookie/credential state、可见 DOM、模型 tool-call 差异和失败语义缺一不可。对 OpenClaw 而言，首方 skill 接入是现成生态机会；同时应建立兼容矩阵与回归集，覆盖下载完成、storage state、MCP error、隐藏 DOM 文本和多模型结构化调用，而不只验证页面能否点击。

### 静默对象背景与竞争判断
- **Browserbase / Stagehand**：官方 changelog 的 Stagehand v4 发布于 8/10，早于窗口；本期不计动态。其“面向 browser agents 的 SDK + cloud sessions/observability”仍是 browser-use 的主要商业化对手。来源：https://browserbase.com/changelog 。
- **Azure BAT**：8/5 原文确认 BAT 是由 GA 的 Playwright Workspaces 承载的 MCP 工具，支持 isolated session、Live View、take control、observability，private website browsing 为 private preview，事件类型含 `browser_automation_preview_call`，Python SDK要求 `azure-ai-projects>=2.0.0`；但日期在窗外，只作能力背景。来源：https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/browser-automation 。
- **AWS AgentCore Browser / Code Interpreter**：检查官方 release notes，August 条目缺逐项日期，未能证明有窗口内发布；不以搜索摘要推断。来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html 。
- **Google**：8/16 只见 Agent Platform Workbench CUDA 12.9.2、依赖安全补丁与 JupyterLab 4 等镜像更新，没有 Managed Agents sandbox/code execution 的新生命周期能力。来源：https://docs.cloud.google.com/vertex-ai/docs/release-notes 。
- **OpenAI / Anthropic / Daytona / Modal**：逐一检查官方工具文档、release notes、GitHub 与博客，未发现窗口内可核验的重大 sandbox/computer-use 发布；Anthropic 最近相关 release note 为 8/6，Modal 最近可见博客为 8/4，均排除。

### 模块洞察
- **洞察**：Sandbox/Browser 层正在从“远程起一个 Chrome/容器”升级为可审计执行平面，竞争焦点转向 host-enforced egress、session state 隔离、完整失败语义、人工接管和 replay/observability；开源 browser-use 在兼容性上领先，云厂则靠身份、网络与治理收编。
- **OpenClaw 参照**：优先引入 E2B 式宿主侧 egress policy→proxy 顺序与 fail-closed 契约，并对 UDP/QUIC/DNS 明示控制边界；同时利用 browser-use 0.13.8 的首方 skill，把它作为可插拔 browser runtime，但须保留 OpenClaw 自身的审批、secret host binding、session tracing 与用户可接管能力。


---

## 4. Tool Gateway / Protocol / Integration 工具层

- 严格时间窗：Asia/Shanghai 2026-08-13 00:00 至 2026-08-19 24:00。

### 本周模块结论
- 最强信号不是再增加一批 function calling 封装，而是工具层开始形成“统一 MCP 入口 + 会话态路由 + 动态工具发现 + 集中凭据注入 + 网络出口防护”的生产栈。Microsoft Foundry Toolbox、Composio Tool Router 与 mcp-gateway-registry 分别从云控制面、开发者 SDK、开源企业网关三个方向逼近同一架构。
- 安全边界已从“谁能调用工具”扩展到“工具返回的 URL 能否被执行端抓取”。Composio 0.17.0 与 mcp-gateway-registry 1.29.0 都把 API 返回 URL、重定向、DNS rebinding、元数据地址和凭据注入绑定纳入 SSRF/数据外泄防线。
- MCP 协议本身与 A2A 本周未发现窗口内可核验的新规范版本；不能用 2026-07-28 MCP 或 2026-04 的 A2A 1.0 旧闻凑数。A2A 8 月 17 日二手报道未取得可读的一手公告，因此不计动态。
- OpenClaw 参照：应把 session-scoped tool router、tool search/call_tool 双元工具、toolbox 版本固定与 egress policy 作为 Gateway 演进方向；尤其应确保远端工具返回的下载/上传 URL 与每次 redirect 都重做 SSRF 校验。

### 固定对象状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| MCP 协议 | 静默；最新规范仍为 2026-07-28（背景，非本周） | https://modelcontextprotocol.io/specification/draft/basic/authorization（核验 2026-08-20） | 否 |
| A2A | 获取不足；未取得 8/17 所称治理变化的一手全文，旧的 1.0/150 组织公告为 2026-04-09 | https://www.linuxfoundation.org/press/a2a-protocol-surpasses-150-organizations-lands-in-major-cloud-platforms-and-sees-enterprise-production-use-in-first-year（2026-04-09，背景） | 否 |
| Composio | 有动态：@composio/core 0.17.0 | https://github.com/ComposioHQ/composio/releases/tag/%40composio/core%400.17.0（2026-08-19） | 是 |
| Arcade | 静默；窗口内仓库样本主要为依赖/发布流水线，未见工具网关能力变化 | https://github.com/ArcadeAI/arcade-mcp（核验 2026-08-20） | 否 |
| Nango | 静默；可检索 changelog 最近显著 MCP 项在 8/3 或更早 | https://nango.dev/docs/updates/changelog（核验 2026-08-20） | 否 |
| Pipedream Connect | 静默；未检出窗口内官方 changelog 项 | https://pipedream.com/docs/changelog（核验 2026-08-20） | 否 |
| AWS AgentCore Gateway | 获取到 8 月 release notes 新能力但条目无日级发布日期，无法证明落在严格窗口，故不计“本周动态” | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html（核验 2026-08-20） | 否 |
| Google Agent Gateway | 本周工具网关本体无重大公开动态；8/15 是语义治理监控，归权限层 | https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes（2026-08-15） | 否 |
| Microsoft Toolbox / MCP-compatible endpoint | 有动态：完整创建、版本、消费和 auth 契约文档窗口内更新 | https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/toolbox（ms.date 2026-08-17，updated 2026-08-18） | 是 |

### 动态池 / 补漏状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| mcp-gateway-registry | 有动态：1.29.0 | https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.29.0（2026-08-14，hot scan 换算） | 是 |
| Microsoft mcp-gateway | 弱动态：修复 adapter proxy stream consumption；属实现修复，不升级为重点产品发布 | https://github.com/microsoft/mcp-gateway/commit/59201a91f0c033dab7259f7c3c27be15353dafa4（窗口内提交） | 否 |
| ToolHive | 有强动态但主要价值为 MCP 身份与安全强制，归模块 5 深写 | https://github.com/stacklok/toolhive/releases/tag/v0.44.0（2026-08-19） | 模块5 |
| Smithery / Zapier MCP / 官方 SaaS MCP / OpenAPI-to-MCP / A2A-MCP gateway | 未检出达到“基础设施级 + 一手原文 + 窗口内”的强信号 | 本轮 web-search-plus 扫描，2026-08-20 | 否 |

### 深度笔记

#### Composio
- 本周动态：Composio 在 8 月 19 日发布 TypeScript 核心包 `@composio/core@0.17.0`。最重要的 minor change 是 OpenAI 与 Anthropic provider 的 tool-call helper 现在可通过调用方提供的 Tool Router session 执行，session meta-tools 在 provider 参数归一化后仍保留会话上下文；旧的 user-ID 直连执行路径继续兼容。接口层面，覆盖 `executeToolCall` / `handleToolCalls` 的自定义 provider 子类可能需要适配新的 session target 参数。该变化把“每用户连接、动态工具发现、远端 MCP endpoint、跨轮复用”从平台概念落到 provider helper 的实际执行链，避免工具在框架适配处丢失 session scope。更关键的 patch 是把 SSRF 守卫从用户输入 URL 扩到 API 响应 URL：工具下载的 `s3Url`、预签名上传 `new_presigned_url`、Tool Router session 的 `RemoteFile.buffer/blob/text/save` 与 `upload_url` 都拒绝 private、loopback、link-local 目标，并逐跳复核 redirect。安全边界仍有明确缺口：Edge Worker 无法 DNS resolve，session 文件传输在 edge runtime 不执行同等阻断。路线判断上，Composio 正从“预集成工具目录”转为 session-aware action runtime；竞争焦点不只是 1000+ toolkit 数量，而是 session 身份、文件通道与 provider adapter 是否在整条链路保持一致。
- 关键数据：GitHub 快照 29,787 stars / 4,720 forks、窗口内 42 commits（hot scan，2026-08-20）；仓库自述 1000+ toolkits、Node 22+、Python 3.10+（https://github.com/ComposioHQ/composio，读取 2026-08-20）。
- 原文链接：https://github.com/ComposioHQ/composio/releases/tag/%40composio/core%400.17.0 （2026-08-19）；https://github.com/ComposioHQ/composio （读取 2026-08-20）。
- 影响判断：OpenClaw 若让一个长期 session 使用多套远端工具，必须把“用户身份—connected account—工具搜索—文件上传下载”绑定为同一 execution context，而不能只在最外层存 user_id。Composio 同时证明 SSRF 必须覆盖工具返回值，不仅覆盖用户参数。

#### Microsoft Foundry Toolbox / MCP-compatible endpoint
- 本周动态：Microsoft 在 `ms.date=2026-08-17`、8 月 18 日更新的官方指南中，把 Toolbox 的生产契约完整公开：一个版本化 toolbox 可聚合 MCP、OpenAPI、A2A、Web Search、Azure AI Search、Code Interpreter、File Search、Browser Automation、Fabric IQ、Work IQ、skills 与 tool search，并通过单一 managed endpoint 给 hosted agent 或任意 MCP-compatible runtime 消费。管理面覆盖 Python/REST/.NET/JavaScript/Foundry Toolkit；.NET coherent preview 包明确为 `2.1.0-beta.4`，统一 Foundry CLI 要求 `azd 1.25+`。REST 创建版本使用 `POST {project_endpoint}/toolboxes/{name}/versions?api-version=v1`，Bearer token scope 是 `https://ai.azure.com/.default`。Toolbox 采用不可变版本、测试后提升 default 的发布方式；tool search 用 `tool_search` 和 `call_tool` 两个 meta-tools，避免把数百个 schema 塞进上下文。安全上，开发者、agent managed identity、OAuth end user 都需 Foundry User RBAC；连接可选 `oauth2`、`user-entra-token`、`project-managed-identity`、`agentic-identity` 等，YAML 只引用 connection name、不嵌密钥；MCP 工具还能配置 `require_approval`。官方也明确警告非 Foundry 工具的数据可能离开 Foundry compliance boundary。
- 关键数据：支持 12 类可装入 toolbox 的条目（按官方 feature table计：MCP、Web Search、Azure AI Search、Code Interpreter、File Search、OpenAPI、A2A、Browser Automation、Fabric IQ、Work IQ、Tool Search、Skills）；.NET SDK `2.1.0-beta.4`；`azd >=1.25`；REST `api-version=v1`。来源均为 https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/toolbox（2026-08-17/18）。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/toolbox；背景架构：https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/toolbox-overview。
- 影响判断：Microsoft 正把工具连接从 agent-local 配置收编为企业级 control-plane resource，且用 MCP-compatible endpoint 保持 runtime 中立。OpenClaw 可借鉴 version promotion、connection reference、tool search、approval policy，但要避免把外部 SaaS 数据边界隐藏在“统一 endpoint”之后。

#### mcp-gateway-registry 1.29.0
- 本周动态：开源企业 MCP 网关 `mcp-gateway-registry` 于 8 月 14 日发布 1.29.0，核心不是简单 registry UI，而是重做可复用 outbound egress 与 header/credential boundary。版本默认在 auth-server 和 registry 容器设置 `AWS_EC2_METADATA_DISABLED=true`，阻断 boto3 经 EC2 IMDS 回退拿凭据；Helm 可显式 opt-out，但 Terraform/ECS 推荐 task role。统一 fail-closed URL guard 能识别 decimal/octal/hex/short-form IPv4、IPv4-mapped/NAT64/6to4/Teredo IPv6，AWS/Alibaba metadata endpoint 即使 operator allowlist 也硬拒绝；连接时 pin 已解析公网 IP、redirect 再验证，以防 DNS rebinding。凭据只在“已验证且 identity 匹配的实际 `/mcp`/`/sse`/query URL”上解密注入，输出 projection 递归去除 token、encrypted secret 与 rating PII。功能层还加入 `EMBEDDINGS_AUTH_MODE=idp`：用 OAuth2 client credentials 从 Keycloak/Entra/Okta/Auth0/PingFederate 获取并缓存 bearer token，替代静态 embeddings API key；并支持 Entra v1 `api://<app-id>/<scope>` 透传和 audience normalization。这个 release 显示 MCP gateway 已兼具 API gateway、credential broker、registry、semantic tool search 与 audit/telemetry，而不是轻量反向代理。
- 关键数据：1.29.0；hot scan 快照 867 stars / 222 forks、窗口内 45 commits（2026-08-20）；IdP token timeout 默认 30 秒；`EMBEDDINGS_RESPONSE_FORMAT` 支持 `openai`/`raw_array`；IMDS fallback 默认 disabled。来源：https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.29.0（2026-08-14）。
- 原文链接：https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.29.0。
- 影响判断：企业 MCP gateway 的护城河正在转为“凭据只在正确目的地解密 + 统一出口策略 + registry 生命周期”，而非单纯 tool catalog。OpenClaw Gateway 若开放第三方 MCP，应实现同等级的 DNS/redirect/metadata 防线，并把 tool identity 与目标 URL 做强绑定。

#### AWS AgentCore Gateway（仅作观察，不计窗口动态）
- 状态说明：AWS 8 月 release notes 已展示 Gateway customer-configurable rate limits、AWS Agent Registry 新 `agent-registry` namespace 与 Web Search connector 扩区，但官方页面没有给每个条目的具体发布日期，搜索也无法把它们可靠定位到 8/13—8/19，因此严格按周报规则不列为“有动态”。值得下期继续核验：rate limit 支持 JWT `$.context.jwt.sub`、`iam.sourceIdentity`、target/tool/model dimension，RPS/RPM、TPM 和 connection 三种 metric，多规则 AND、最具体匹配、`rate=0` emergency block，且 transient enforcement error fail-open；这些细节若确认日期，将是强工具治理信号。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html（读取 2026-08-20）。

### 模块洞察
- 工具层正在从“协议标准化”进入“执行边界标准化”：MCP 是统一入口，但真正的生产差异已转向 session routing、tool discovery、版本治理、凭据注入、审批和 egress/SSRF 防护。OpenClaw 的机会是保持 runtime 中立，同时把这些控制面能力做到 Gateway 原生，而不是依赖每个 skill 自己补安全。

---

## 5. Identity / Auth / Permission 权限层

- 严格时间窗：Asia/Shanghai 2026-08-13 00:00 至 2026-08-19 24:00。

### 本周模块结论
- 本周最强身份信号来自开源 ToolHive：RFC 8693 `actor_token`、external `may_act` delegation、token/DCR endpoint SSRF、Google tokeninfo audience 校验同时落地，说明 Agent 权限模型开始从“持有 OAuth token”升级为可验证委托链。
- WorkOS 把高风险 tool permission 的缺口讲透：长时 access/refresh token 证明“曾授权”但不证明“批准本次删除/转账”。其 8/17 方案用 5 分钟一次性审批、用户+工具+参数 hash 绑定、原子 consume、浏览器 step-up 与完整 audit 弥补 MCP 客户端对 RFC 9470 中途再认证支持不足。
- Google 8/15 给 semantic governance policy engine 增加内建监控，使 ALLOW/DENY、policy latency、error 与 token cost 可观测；这不是新身份协议，但补齐了 tool permission 的运营审计面。Google Agent Identity 本身本周无新发布，现有 SPIFFE/mTLS/DPoP/auth manager 能力仅作背景。
- OpenClaw 参照：权限检查不应只发生在连接 MCP server 时；必须在每次高风险 tool call 上绑定 trusted user intent、具体参数与一次性批准，并把 agent identity、end-user identity、policy verdict、token acquisition/revocation 串进同一审计事件。

### 固定对象状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 静默；8 月 release notes 未提供可定位到严格窗口的 Identity 日级条目，Private Key JWT 为 7 月旧闻 | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html（核验 2026-08-20） | 否 |
| Microsoft Entra Agent Identity / Foundry identity | 有关联动态：Foundry Toolbox 8/17 文档明确 agent identity、end-user OAuth passthrough、RBAC 与 connection auth 类型；身份产品本体无独立发布 | https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/toolbox（2026-08-17/18） | 是（与Toolbox合并） |
| Google Agent Identity / Gateway / Gemini Enterprise auth | 有动态：8/15 semantic governance policy metrics；Agent Identity 本体无新发布 | https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes（2026-08-15） | 是 |
| Arcade Auth / tool permission | 静默；窗口内未见可深写的 auth/permission 新能力 | https://github.com/ArcadeAI/arcade-mcp（核验 2026-08-20） | 否 |
| Composio Auth | 有关联动态：0.17.0 session context 贯通并修复响应 URL SSRF；无独立 OAuth 产品发布 | https://github.com/ComposioHQ/composio/releases/tag/%40composio/core%400.17.0（2026-08-19） | 是（模块4详写） |
| Nango OAuth / token management | 静默；未检出窗口内官方发布 | https://nango.dev/docs/updates/changelog（核验 2026-08-20） | 否 |
| Pipedream Connect managed auth | 静默；未检出窗口内官方发布 | https://pipedream.com/docs/changelog（核验 2026-08-20） | 否 |

### 动态池 / 补漏状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| ToolHive | 有动态：v0.43.0 + v0.44.0 | https://github.com/stacklok/toolhive/releases/tag/v0.43.0（2026-08-15）；https://github.com/stacklok/toolhive/releases/tag/v0.44.0（2026-08-19） | 是 |
| WorkOS | 有动态：面向 MCP 高风险工具的 step-up + 参数绑定审批参考实现 | https://workos.com/blog/step-up-authentication-ai-agents（2026-08-17） | 是 |
| Auth0 | 静默；Auth for MCP GA 是 2026-05-06，窗口外 | https://auth0.com/blog/auth0-auth-for-mcp-servers-generally-available/（背景） | 否 |
| Clerk | 静默；未发现窗口内 Agent/MCP 权限信号 | https://clerk.com/changelog/2025-03-7-clerk-agent-toolkit（背景，非本周） | 否 |
| Descope | 静默；现有 MCP Authorization 文档无窗口内发布证据 | https://docs.descope.com/mcp（核验 2026-08-20） | 否 |
| Permit.io | 静默；检索到 Agent/MCP 定位但无可核验窗口内原文发布 | https://www.permit.io/tags/ai-identity（核验 2026-08-20） | 否 |
| Aserto | 静默；未检出窗口内明确 Agent/MCP 信号 | 本轮 web-search-plus 扫描，2026-08-20 | 否 |

### 权限层专项检查

| 检查项 | 本周证据与判断 |
|---|---|
| OAuth / OIDC / MCP auth | ToolHive 落地 RFC 8693 actor delegation、DCR confidential clients、Google tokeninfo audience；WorkOS 使用 MCP Protected Resource Metadata、JWKS issuer/audience 校验并讨论 RFC 9470。 |
| Token 托管 | Google Agent Identity auth manager（背景）托管 API key、2-legged/3-legged OAuth 与 end-user token；ToolHive/mcp-gateway-registry 强调 token endpoint 出口隔离。 |
| 用户授权 | WorkOS 将批准从“首次 OAuth consent”细化到高风险工具的当次浏览器重认证与明确批准。 |
| Tool permission | Foundry Toolbox 有 `require_approval`；Google semantic policy 对 agent request/tool call 返回 ALLOW/DENY；WorkOS 以 sensitive tool allowlist + 参数绑定做 action-level permission。 |
| 审计日志 | Google policy metrics可按 verdict/status/request_type 监控；Agent Identity audit 能同时记录 agent/user（背景）；WorkOS 方案要求记录 approval 全生命周期与 authenticatedAt。 |
| 越权 / 数据泄露 | ToolHive 拒绝 Authorization/Cookie passthrough、限制 may_act、拦 token/DCR SSRF；Composio 防 API-response URL SSRF；Foundry 明示非 Foundry 工具可能越出 compliance boundary。 |

### 深度笔记

#### ToolHive v0.43.0 / v0.44.0
- 本周动态：ToolHive 在 8 月 15 日与 19 日连续发布 v0.43.0、v0.44.0，把 MCP delegated authorization 与供应链/网络安全一起推进。v0.43.0 支持 confidential client dynamic client registration，并让 RFC 8693 delegate clients 真正可达可用；同时 MCP Virtual Server 明确拒绝把 `Authorization`、`Cookie` 放进 passthroughHeaders，OAuth callback listener 只绑定 loopback，Cedar URI entity ID 改为无碰撞形式。网络侧 private-IP guard 扩到 6to4/Teredo，CI 则停用持久 git credential、将 actions pin 到 commit SHA、缩小 release app token、把 zizmor 变成 blocking，并记录 certificate ref/runner 供 skill verification。v0.44.0 进一步支持 RFC 8693 `actor_token`，收紧外部 `may_act` delegation；token 与 DCR endpoint 都先做 SSRF 检查，Google tokeninfo introspection 强制要求 audience，避免“签名有效但发给另一个 resource”的 token confusion。安全边界的含义是：Agent 可以代表用户/上游 actor，但 delegation chain、audience、资源、目的地址与可转发 header 必须同时成立；只校验 bearer token 存在远远不够。一个保留风险是 v0.44.0 暂时“push skills unsigned until keyless signing lands”，意味着技能供应链的签名闭环仍未完成。
- 关键数据：hot scan 快照 2,026 stars / 281 forks、窗口内 41 commits（2026-08-20）；版本 v0.43.0（8/15）、v0.44.0（8/19）。来源：https://github.com/stacklok/toolhive/releases/tag/v0.43.0 与 https://github.com/stacklok/toolhive/releases/tag/v0.44.0。
- 原文链接：https://github.com/stacklok/toolhive/releases/tag/v0.43.0；https://github.com/stacklok/toolhive/releases/tag/v0.44.0。
- 影响判断：ToolHive 把 MCP auth 从“OAuth 接上了”推进到 delegation semantics 与 credential egress protection，是本周权限层最扎实的工程信号。OpenClaw 应对 session delegation 建模 actor/subject/resource/audience，而不是把一枚用户 token 传到底；同时禁止任意 skill/MCP server透传 Cookie 或 Authorization。

#### WorkOS：面向 AI Agent 的 step-up authentication
- 本周动态：WorkOS 8 月 17 日发布的参考实现直指 Agent 权限核心：一枚有效一小时、refresh token 更长的 OAuth 凭据只能证明用户曾授权客户端，不能证明用户同意在本次 tool call 中删除生产环境。标准 RFC 9470 允许 resource server 返回 `401 insufficient_user_authentication` 与 `max_age` 触发再认证，但官方坦承两端现实不足：多数 MCP client 不理解 mid-session challenge，WorkOS Connect `/oauth2/authorize` 也尚未文档化 `max_age`，所以方案采用 out-of-band browser approval。敏感工具首次调用创建 5 分钟 TTL 的 approval；记录严格绑定 `userId + tool + SHA-256(args) + status + expiresAt`，浏览器通过 AuthKit `checkRecentAuth` 做 step-up，并在 server action 再检查一次，之后数据库以原子条件更新把 approved 变为 consumed，保证 single-use。Agent 只得到 approval ID 和链接，从不接触认证凭据；重试必须携带相同工具参数。示例要求 Node.js 22.11+、`@workos-inc/authkit-nextjs 4.2.0+`、MCP server v2（2026-07-28 spec），并建议仅对删除数据、移动资金、修改访问权、触达客户等动作触发，避免 approval fatigue。该路线实质是把 tool permission 从 scope 粒度升级到 action+arguments+fresh-human-intent 粒度。
- 关键数据：approval TTL 5 分钟；`maxAge` 示例 0 或 120 秒；Node.js 22.11+；AuthKit Next.js 4.2.0+；参数哈希 SHA-256。来源：https://workos.com/blog/step-up-authentication-ai-agents（2026-08-17）。
- 原文链接：https://workos.com/blog/step-up-authentication-ai-agents。
- 影响判断：这是对 MCP/OAuth 权限空档非常实用的补丁，也揭示单靠 scopes 不足以约束自主 Agent。OpenClaw 可将 approval 设计为 Gateway 原语：批准必须绑定 session、用户、tool、canonical args、时效和一次性 nonce，执行/拒绝/过期均进入审计日志；长期应兼容 RFC 9470 客户端内 step-up。

#### Google Gemini Enterprise：semantic governance policy metrics
- 本周动态：Google 在 8 月 15 日将 semantic governance policy engine 的内建 Cloud Monitoring metrics 以 Preview 形式发布。引擎现在对每个检查过的 agent request 自动输出 request 与 evaluation 两层指标：`request_count` 可按 HTTP method、status code、semantic status、`request_type`（LLM/TOOL/OTHER/UNKNOWN）切片；`request_latencies` 衡量治理引擎附加时延；`evaluation_count` / `evaluation_latencies` 按最终 `ALLOW`/`DENY`；`evaluation_token_count` 按 INPUT/OUTPUT/THINKING 记录策略评估成本。指标可通过 Metrics Explorer、Cloud Monitoring v3 API、PromQL 访问并设 alert，例如 DENY spike、MODEL_ERROR rate、P99 latency SLO。权限意义在于，语义策略不再是不可见的 LLM judge，而成为可运营、可审计的 runtime control。边界也必须说清：这些是聚合/时间序列指标，不等同逐次不可抵赖审计日志；ALLOW/DENY 质量仍取决于 policy prompt 与模型，且 token cost/latency 可能让团队降低覆盖率。
- 关键数据：5 个内建 metric；两层采集；`final_verdict` 两值 ALLOW/DENY；发布阶段 Preview。来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes（2026-08-15）与 https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/policies/monitor-semantic-governance（读取 2026-08-20）。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes；https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/policies/monitor-semantic-governance。
- 影响判断：Google 正把“用户意图—tool call—组织规则”放进执行路径，并给策略本身加 SLO。OpenClaw 的 tool permission 若引入语义判定，也应同时暴露 deterministic rule 命中、模型判定、人工批准与最终执行四层 trace，避免只留下一个模糊 DENY。

#### Microsoft Foundry identity（随 Toolbox 文档落地）
- 本周动态：8/17—18 的 Toolbox 指南明确三类 principal：创建/更新 toolbox 的 developer、运行时调用工具的 agent managed identity、仅在 OAuth/UserEntraToken flow 中需要的 end user，三者都要按场景授予 Foundry User RBAC。connection auth type 覆盖 `none`、`custom-keys`、`api-key`、`oauth2`、`user-entra-token`、`project-managed-identity`、`agentic-identity`；YAML 只保存 connection name，避免把 client secret/API key散落到工具定义。MCP 工具还有 `require_approval`，toolbox 可在统一 endpoint 处做 credential injection、token refresh、RAI guardrail 与版本治理。安全限制是 RBAC 的 Foundry User 粒度本身较粗，真正 per-tool/per-user 权限还要依赖 downstream OAuth scope、approval 与具体 tool policy；外部工具数据可能离开 Foundry compliance boundary。
- 关键数据与原文：https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/toolbox（ms.date 2026-08-17，updated 2026-08-18）。
- 影响判断：Microsoft 的方向是让 agent identity 和 end-user delegated identity在统一工具控制面相遇。OpenClaw 可借鉴 connection reference 和 identity passthrough，但不应把“能连接 toolbox”误当“能调用全部工具”，需保留每工具策略与用户批准。

#### Google Agent Identity（背景，非本周）
- 状态说明：本周未见 Agent Identity 本体新发布。现有官方架构值得作为竞争基线：每 agent 唯一 SPIFFE ID 与自动轮换 X.509（24 小时），Google API 使用证书绑定 token，跨 Agent Gateway 使用 mTLS + DPoP 双重 proof-of-possession；auth manager 托管 API key、2-legged/3-legged OAuth 与 end-user token，原始 credential 在 gateway 解密、agent 不可见；IAM deny、PAB、VPC Service Controls 与 audit log 可同时归因 agent/user。来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/agent-identity-overview（读取 2026-08-20，背景）。

### 模块洞察
- 权限层正从“OAuth 登录 + scope”升级为三段式控制：强 agent workload identity、可追踪的 user delegation、每次高风险 action 的参数级 policy/approval。真正短板仍是标准客户端对 step-up、一次性授权和跨代理委托链支持不齐；短期需要 Gateway 编排，长期才可能协议化。

---

## 6. Context / Memory / Knowledge 记忆知识层

- 时间窗：2026-08-13 00:00 至 2026-08-19 24:00（Asia/Shanghai）。GitHub stars/forks 为 2026-08-20 快照，不代表周增量。

### 本周模块结论
- 本周最强信号不是“多一个 Memory API”，而是数据正确性与升级可恢复性成为竞争核心：OpenViking v0.4.15 与 supermemory server 0.0.8 都在修复“内容仍在、向量静默消失”的高危故障。
- OpenViking v0.4.14 已从 RAG/记忆后端向可写 `viking://` Agent 工作区推进，MCP、Session、插件、资源同步与 Memory V3 被收敛为一套 Context Database 控制面。
- Cognee v1.5.0 把竞争焦点拉到大规模图迁移：100k 节点/边夜间基准、批量 rekey/restore、跨 Letta/Zep 迁移教程，说明可迁移性正在成为企业采购门槛。
- Letta Agents SDK 把持久身份、记忆、会话和跨机器执行统一进同一 TypeScript SDK；对 OpenClaw 的直接启发是把 memory identity 与 session/runtime 绑定，而不是仅提供检索工具。

### 固定对象状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态：v0.4.14 / v0.4.15 | https://github.com/volcengine/OpenViking/releases/tag/v0.4.14（2026-08-17）；https://github.com/volcengine/OpenViking/releases/tag/v0.4.15（2026-08-18） | 是 |
| Mem0 | 静默：18 commits 主要为文档/示例；最近 release v2.0.18 在 8/11，窗口外 | https://github.com/mem0ai/mem0；https://github.com/mem0ai/mem0/releases | 否 |
| Cognee | 有动态：v1.5.0 | https://github.com/topoteretes/cognee/releases/tag/v1.5.0（release note 标 2026-08-15；上海发布日 8/16） | 是 |
| supermemory | 有动态：server 0.0.7 / 0.0.8 | https://github.com/supermemoryai/supermemory/releases/tag/server-v0.0.7（上海 2026-08-15）；https://github.com/supermemoryai/supermemory/releases/tag/server-v0.0.8（上海 2026-08-17） | 是 |
| Letta | 有动态：Letta Agents SDK | https://www.letta.com/blog/introducing-the-letta-agent-sdk/（2026-08-17） | 是 |
| Zep / Graphiti | 静默：窗口内 9 commits 多为 CLA 机器人，最近 release v0.29.3 为 7/27 | https://github.com/getzep/graphiti；https://github.com/getzep/graphiti/releases | 否 |
| Firecrawl | 静默：未核验到窗口内基础设施级发布；窗口内博客为内容营销，不作为产品动态 | https://github.com/mendableai/firecrawl/releases；https://www.firecrawl.dev/blog | 否 |
| Crawl4AI | 静默：窗口内 0 commits，最近 release v0.9.2 为 2026-07-15 | https://github.com/unclecode/crawl4ai；https://github.com/unclecode/crawl4ai/releases | 否 |

### 强观察池状态

| 对象 | 本周状态 | 判断 |
|---|---|---|
| LightRAG | 静默/无强信号 | 未发现窗口内足以升级为 Agent memory 产品化的原始发布，不深写。 |
| Microsoft GraphRAG | 静默/无强信号 | 未发现窗口内基础设施级强信号。 |
| LlamaIndex | 静默/无强信号 | 未发现窗口内 memory/knowledge 组件重大原始发布。 |
| LangMem / LangGraph Store | 静默/无强信号 | 本周未见独立的 store/memory 基础设施发布。 |
| Onyx | 静默/无强信号 | 未发现窗口内强信号。 |
| Haystack | 静默/无强信号 | 未发现窗口内 Agent memory 产品化强信号。 |
| Jina Reader | 静默/无强信号 | 未发现窗口内重大采集 API 更新。 |
| Unstructured | 静默/无强信号 | 未发现窗口内重大摄取层发布。 |
| Chroma / Qdrant / Milvus / Weaviate | 静默/无强信号 | 未发现窗口内明确从向量库升级为 Agent memory 产品的强信号；不把通用数据库更新塞入本模块。 |

### 深度笔记

#### OpenViking
- 本周动态：v0.4.14（8/17）包含 82 个提交，把 `viking://` 从只读知识入口推进成 Agent 可写工作区：MCP 新增 `tree`、`write`、`edit`，`write` 支持创建/覆盖/追加，`edit` 在匹配缺失或歧义时保持文件不变，`wait=true` 可等待语义与向量索引刷新。新版提供 Agent Plugins 1.0 包、精确绑定 `@deepseek-ai/dsh 0.1.0-rc.6` 的 DSH memory plugin，并给 DeerFlow、TRAE/TRAE CN 增加自动捕获、召回和 Session commit 接入。Session 可设事件标签并动态更新/关闭 auto-commit；Memory V3 成为唯一抽取链路，SessionCommit 默认并发从 4 升至 8，Python 嵌入式客户端、Qdrant 与 openGauss 后端被移除，MCP Streamable HTTP 改为无状态以适配多实例和负载均衡。紧接着 v0.4.15 披露 v0.4.14 的 xxhash 未锁版本可装入 4.x，使 local VectorDB/cuVS 新向量写入失败且错误不上抛，形成“任务完成、原文存在、召回缺失”的静默数据损坏；受影响内容需重建向量。这是高质量的事故透明度，但也暴露 memory substrate 对依赖锁定、写后读校验和可恢复索引账本的刚性需求。
- 关键数据：30,253 stars / 2,338 forks、窗口内 64 commits（GitHub API 热扫快照 2026-08-20：https://api.github.com/repos/volcengine/OpenViking）；v0.4.14 含 82 commits（https://github.com/volcengine/OpenViking/releases/tag/v0.4.14，2026-08-17）。
- 原文链接：https://github.com/volcengine/OpenViking/releases/tag/v0.4.14；https://github.com/volcengine/OpenViking/releases/tag/v0.4.15；交叉证据 PR：https://github.com/volcengine/OpenViking/pull/3995。
- 影响判断：OpenViking 正把 Memory、Knowledge、Skills、Session 与 MCP workspace 组合为 Context Database，而非单点向量检索。OpenClaw 可借鉴其 hook 前召回、失败写入重放、actor/workspace scope 与 trace_id；同时必须优先补齐“索引写入确认 + 后台校验/重建”，避免同类静默召回失败。

#### Cognee
- 本周动态：Cognee v1.5.0 的主题是“大规模迁移与图可靠性”，而非表层 API 扩充。Ladybug graph adapter 将 fork re-key 改为集合操作，edge identity 查询分块，re-embed、rekey restore 由逐条调用改为批处理，并修复并发 upsert 首批次竞态。release-test CI 会用固定旧版 Cognee 构造两个 production-shaped datasets，跑完整迁移链并验证 dataset scope split 与 `rekey_fork_document_ids`；夜间还跑 100k-node/-edge 的《战争与和平》large-mock benchmark。版本新增从 Letta/MemGPT、Zep 迁移到 Cognee 的教程和样例 dump，并开放 `LLM_TEMPERATURE`、`LLM_SEED` 以提升抽取复现性；OTLP 日志改成批量导出且尊重 tracing-off 开关。兼容口径为 Python >=3.10,<3.15，Ladybug 固定到 0.19.0，官方称无用户侧 breaking change。商业判断上，Cognee 正通过“可从竞争对手迁入 + 生产形态迁移验证”降低替换成本，竞争对象不再只是 RAG 引擎，而是企业知识图谱的长期数据托管权。
- 关键数据：30,132 stars / 2,938 forks、窗口内至少 100 commits（API 单仓 100 条上限；GitHub API 热扫 2026-08-20：https://api.github.com/repos/topoteretes/cognee）；100k 节点/边夜间基准、2-dataset 迁移测试（https://github.com/topoteretes/cognee/releases/tag/v1.5.0，2026-08-15）。
- 原文链接：https://github.com/topoteretes/cognee/releases/tag/v1.5.0；仓库：https://github.com/topoteretes/cognee。
- 影响判断：企业 Memory 的锁定点正在从 API 变成迁移链和图 ID 一致性。OpenClaw 若建立长期知识层，应把 schema/version migration、可重复抽取参数和跨后端回归集列为一等能力，而不是仅对接向量数据库。

#### supermemory
- 本周动态：server 0.0.7（上海 8/15）把 self-host “lite”正式限定为最多 10,000 documents，额度由 API 强制并在启动时显示；新增本地 Memory 控制台（实时计数、近期 documents/memories、container tags、交互式 memory graph）、`supermemory-server doctor`，以及约 3 秒启动——embedding model 改为后台惰性加载。原生 ONNX embedding runtime 重新随二进制分发，官方称约比 WASM 快 12 倍且更省内存；旧 0.0.5 store 可自动迁移，多实例各自持有 workflow engine，Ctrl-C 会排空在途任务并 snapshot。随后 0.0.8 发布紧急补丁：0.0.7 RC store 升级到 0.0.7 时 migration adoption 会剪掉 pgvector embedding columns，导致旧文档仍列出却无搜索结果，新文档正常。0.0.8 启动时检测“文本尚存、向量缺失”的行并后台重嵌入，测试 fixture 也开始播种真实向量并断言升级后存活。连续两版说明 self-host memory 已进入运维产品阶段，但也显示 migration test 若不包含真实向量，极易漏掉最危险的数据面回归。
- 关键数据：28,966 stars / 2,524 forks、窗口内 21 commits（GitHub API 热扫 2026-08-20：https://api.github.com/repos/supermemoryai/supermemory）；10,000 documents；约 3 秒启动；原生 embedding 官方称约 12x WASM（https://github.com/supermemoryai/supermemory/releases/tag/server-v0.0.7，上海 2026-08-15）。
- 原文链接：https://github.com/supermemoryai/supermemory/releases/tag/server-v0.0.7；https://github.com/supermemoryai/supermemory/releases/tag/server-v0.0.8；交叉问题单：https://github.com/supermemoryai/supermemory/issues/1524。
- 影响判断：supermemory 的护城河正在从托管 API 下沉到单二进制、自诊断、迁移、自愈。对 OpenClaw 最实际的参照是给 memory backend 增加 doctor、数据版本、向量完整率与后台 backfill 状态，而不是把“写入成功”当成可召回成功。

#### Letta
- 本周动态：Letta 于 8/17 发布 `@letta-ai/letta-agent-sdk`，这是面向 stateful/persistent agents 的 TypeScript SDK。核心抽象不是一次 run，而是带 identity、long-term experience、memory 的 agent：同一 `LettaAgentClient` 可连接 Letta Cloud、自托管 App Server 或本机后端；agent 可在不同机器间继续同一会话和状态。API 示例通过 `createAgent` 创建持久 agent，再用 `resumeSession(agentId, {computer, cwd})` 把它接到已登记 laptop、VM、container 或 managed sandbox；WebSocket 接口可流式展示 reasoning/tool activity 并处理 approval。SDK 支持 agent 在本机工作时向云端派生并发 conversation，也能把重复工作写成 TypeScript program、定时自动化或 event handler。安全边界上，低敏凭据可放到本地 computer，高敏凭据保留为服务端 MCP tools，agent 可调用但不能修改。它同时支持本地 agent loop 与服务端托管 loop，形成“agent in a sandbox”和“agent with a sandbox”的统一接口。
- 关键数据：正式日期 2026-08-17（页面结构化 `datePublished` 与页面日期交叉核验）；安装命令 `npm install @letta-ai/letta-agent-sdk`。原文：https://www.letta.com/blog/introducing-the-letta-agent-sdk/。
- 原文链接：https://www.letta.com/blog/introducing-the-letta-agent-sdk/；源码：https://github.com/letta-ai/letta-agent-sdk；文档：https://docs.letta.com/agent-sdk/。
- 影响判断：Letta 将 memory 从可插拔组件上升为 agent identity 的组成部分，并以跨机器 session 证明状态与执行位置可以解耦。OpenClaw 已有 sessions/Gateway 优势，可进一步定义稳定 agent identity、跨节点 resume、共享/私有 memory scope，以及“服务端秘密不暴露给本地执行器”的权限模型。

### 静默对象补充判断
- Mem0：本周官网新增 8/14、8/17、8/18 概念文章，首页列 150,000+ developers，并宣称 SOC 2 Type 1、HIPAA、GDPR、Kubernetes/private cloud/air-gapped 与全量读写审计；但这不是窗口内可核验的产品/API 发布，故状态仍为静默。来源：https://mem0.ai/（抓取发布时间 2026-08-19；GitHub 快照 63,622 stars / 7,444 forks）。
- Zep/Graphiti：30,106 stars / 3,044 forks；窗口 9 commits 多为 CLA bot，不能用机械提交量伪装产品更新。来源：https://github.com/getzep/graphiti（2026-08-20 快照）。
- Crawl4AI：78,718 stars / 8,158 forks，但严格窗口 0 commits，最近 release v0.9.2 在 7/15；如实记录为“高热存量、窗口静默”。来源：https://github.com/unclecode/crawl4ai（2026-08-20 快照）。

### 模块洞察
- Memory 正从“向量库前的一层 API”升级为带 Session、身份范围、迁移、索引校验、自愈和可观测性的 Context Database；本周两起静默丢向量修复说明，下一阶段赢家首先必须是可靠的数据系统，其次才是更聪明的召回算法。

### OpenClaw 参照
- 近期优先级：为 memory 写链路增加 write-after-read/向量计数校验、异步 backfill、doctor 与升级前后真实向量 fixture。
- 中期能力：参考 OpenViking/Letta，把 session commit、actor/workspace scope、跨节点 resume 和 memory identity 纳入 Gateway 原生协议。
- 生态机会：以 MCP/Skill 兼容 OpenViking、Mem0、Cognee、supermemory 等后端，但保留统一审计、删除确认、权限范围与故障降级语义，避免被单一 Context DB 锁定。


---

## 7. Observability / Eval / Guardrails 可观测治理层

- 时间窗：2026-08-13 00:00 至 2026-08-19 24:00（Asia/Shanghai）。

### 本周模块结论
- Agent observability 正从“LLM span 看板”升级为 approval-aware execution record：Langfuse v4.13.0 能跨人工批准串起完整 turn，Phoenix v20.2.0 把 gated tool 的批准决策结构化输出。
- Eval 正从离线 prompt 分数走向 trajectory 与发布治理：Braintrust 本周方法论把 tool selection、arguments、dependency order、final state、repeat trials、CI gate 与 production-to-dataset 闭环串成一套工程标准。
- LangSmith v0.11.0 暴露另一条关键底线：trace 自身必须是秘密安全的，尤其 MCP server credentials 不能进入 metadata；可观测性不能成为凭据泄露面。
- 云厂本周未见落窗的 agent observability/eval/guardrails 重大原始发布；不能用 8/6 的 AWS AgentCore 旧闻或常驻产品页凑数。OpenClaw 应把审批事件、工具策略结果、最终外部状态和凭据脱敏纳入同一 trace schema。

### 固定对象状态表

| 对象 | 本周状态 | 证据源（日期） | 是否深写 |
|---|---|---|---|
| LangSmith | 有动态：SDK v0.11.0 / v0.11.1 | https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.11.0（上海 2026-08-14）；https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.11.1（上海 2026-08-19 23:46） | 是 |
| Langfuse | 有动态：v4.13.0 | https://github.com/langfuse/langfuse/releases/tag/v4.13.0（2026-08-18 UTC；上海 8/18） | 是 |
| Helicone | 静默：未见窗口内重大原始发布 | https://github.com/Helicone/helicone/releases | 否 |
| AgentOps | 静默：窗口 0 commits，默认分支最后 pushed 6/25 | https://github.com/AgentOps-AI/agentops | 否 |
| Braintrust | 有动态：Agent testing 指南 | https://www.braintrust.dev/articles/how-to-test-ai-agents（2026-08-16） | 是 |
| Arize Phoenix | 有动态：v20.2.0 / v20.3.0 | https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.2.0（2026-08-13）；https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.3.0（2026-08-16） | 是 |
| Coze Loop | 静默/未核验到重大 release | https://github.com/coze-dev/coze-loop | 否 |
| OpenTelemetry for Agents / tracing standards | 静默：未发现窗口内 GenAI/Agent semantic conventions 重大发布 | https://opentelemetry.io/blog/2025/ai-agent-observability/（背景，非本周） | 否 |
| AWS agent observability/eval/simulation/guardrails | 静默 | https://aws.amazon.com/bedrock/guardrails/；窗口搜索最近强信号为 8/6，已排除 | 否 |
| Google agent observability/eval/simulation/guardrails | 静默 | https://cloud.google.com/blog/products/ai-machine-learning/google-named-a-leader-in-the-forrester-wave-ai-platforms（常驻/窗口日期未核验，不计动态） | 否 |
| Azure agent observability/eval/simulation/guardrails | 静默 | https://azure.microsoft.com/en-us/products/ai-foundry/observability（常驻产品页，不计动态） | 否 |

### 深度笔记

#### LangSmith
- 本周动态：LangSmith SDK v0.11.0（8/14 上海）最重要的 observability 变化不是新图表，而是 trace 数据安全。Python 与 JavaScript Anthropic wrapper 同时开始 mask MCP server credentials，并停止把 `mcp_servers` 录入 run metadata；这直接回应 Agent trace 可能把工具网关秘密、URL 或认证材料持久化的问题。版本还更新有漏洞的 aiohttp、cryptography 与 JS 依赖；Sandbox 增加 Context Hub mount helper、Python/JS proxy rule 环境变量支持，并通过性能修改默认在 patch 时不重发 run inputs、zstd 单 worker、直接调用 pydantic-core serializer 降低高吞吐 tracing 成本。v0.11.1（8/19 23:46 上海）继续修复 Python/JS transient WebSocket upgrade 重试，新增 `generate_download_url`，并修正 pytest suite 未完整执行时的报告准确性。技术路线判断：LangSmith 正把 tracing、sandbox 与 context asset 运行面融合；但最值得行业复制的是“默认不采集秘密”，因为 Agent observability 的输入比传统 APM 更可能含工具凭据和用户授权上下文。
- 关键数据：Python SDK 0.11.0、0.11.1；JS 0.8.11/0.8.12（https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.11.1）；v0.11.0 GitHub 时间 2026-08-14 12:56 UTC，v0.11.1 为 2026-08-19 15:46 UTC（页面 `relative-time` 直查）。
- 原文链接：https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.11.0；https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.11.1。
- 影响判断：OpenClaw 的 tool/session trace 应采用 allowlist，而非“先全量采集后脱敏”；MCP URL、headers、token、sandbox env、文件内容需分级。另一方面，Context Hub mount、下载 URL 与 sandbox trace 汇合，说明 observability 厂商正在向 Agent control plane 侧延伸。

#### Langfuse
- 本周动态：Langfuse v4.13.0 的核心是“跨审批完整追踪”。in-app-agent 能将一个 agent turn 在 approval 前后维持为完整 trace，而不是人工批准导致 run 断裂；stream boundary 上记录 model calls，message feedback 评分则归到 approval-chain 的 root run，令最终评分与整个决策链对齐。其他控制面变化包括 model routes 允许 admin auth、按 observation attributes 匹配 pricing tiers、custom SSO picture claim 映射，以及 export sources 按 deployment capability 提供。可靠性方面，ClickHouse 瞬态资源错误不再暂停 monitors，BullMQ recurring cron 改为 atomic job schedulers；这对于持续在线评分和告警很关键。开源仓库至少 100 个窗口内 commits（API 取数上限）显示高迭代密度。商业路线判断：Langfuse 不再只是通用 LLM observability，而是将 approval、feedback、pricing、SSO 和 monitor 组合成 Agent 治理控制面；approval root run 是把 human-in-the-loop 纳入可审计执行链的关键数据模型。
- 关键数据：v4.13.0；33,408 stars / 3,595 forks；窗口内至少 100 commits（GitHub API 热扫 2026-08-20：https://api.github.com/repos/langfuse/langfuse）；发布时间 2026-08-18T13:30:35Z（GitHub 页面结构化时间）。
- 原文链接：https://github.com/langfuse/langfuse/releases/tag/v4.13.0；完整差异：https://github.com/langfuse/langfuse/compare/v4.12.0...v4.13.0。
- 影响判断：审批不能只是 UI 按钮，必须成为 trace 中可关联、可评分、可审计的事件。OpenClaw 应把 approval request/decision、策略命中、执行前后参数摘要、操作者与 root session/run 统一关联，并保持流式模型调用边界。

#### Braintrust
- 本周动态：Braintrust 8/16 发布的实操指南系统化定义 Agent 测试：由于同一任务可有多条正确路径，exact match 不适合评估；应分别检查 tool selection、arguments、structured output、response quality，再在完整 trajectory 上检查 required/prohibited tools、dependency order、final external state 与 step count。每个 scorer 输出 0–1，阈值决定通过，`trial_count` 用于重复运行衡量一致性。指南提出四层体系：single-step eval、trajectory eval、CI regression、production monitoring；GitHub Action 可对 PR 与 baseline experiment 比较并以分数阈值阻断合并，线上 scorer 异步执行不增加请求延迟，低分 trace 经人工复核后进入 dataset，形成 production failure → regression case 闭环。其客户证据包括 Notion 让 70 名工程师共享评估流程，并声称 frontier model 发布数小时内即可上线；另列 Stripe、Vercel、Instacart、Zapier、Ramp。免费计划含每月 1 GB processed data、10,000 scores，且 users/projects/datasets/playgrounds/experiments 不限。
- 关键数据：scorer 0–1；Notion 70 engineers；免费 1 GB processed data/月、10,000 scores/月（https://www.braintrust.dev/articles/how-to-test-ai-agents，2026-08-16）。
- 原文链接：https://www.braintrust.dev/articles/how-to-test-ai-agents；CI action 说明由原文链接至 https://www.braintrust.dev/docs/evaluate/run-in-ci。
- 影响判断：Braintrust 的价值信号是把 eval 从研究评分变成发布门禁和事故学习系统。OpenClaw 可直接建立高风险工具 trajectory suite：不仅判断文本答案，还要验证工具顺序、参数权限、最终状态、重复运行稳定性，并把真实失败一键固化为回归样本。

#### Arize Phoenix
- 本周动态：Phoenix v20.2.0（8/13）让 gated PXI tools 发出 machine-readable approval decision，而非仅依赖 UI/文本日志；这使 approval 可被下游 evaluator、policy engine 和审计系统可靠查询。同版修正内置 model token prices，避免成本指标因价格表过期而失真。v20.3.0（8/16）新增 traces expression filter DSL，使团队能用表达式在大量 trace 中筛选复杂行为，而不仅是固定字段过滤。GitHub release 网页正文抽取不完整，因此又以页面 `og:description`、tag commit 时间与仓库 tag 交叉验证：v20.2.0 tag commit 为 2026-08-13T13:30:59-07:00，v20.3.0 为 2026-08-15T23:02:04-07:00；两者均落上海窗口。商业/技术判断：Phoenix 正将 observability 查询语言与 guardrail decision event 合并，形成“可观测 + 可治理”数据底座；机器可读审批尤其适用于自治 Agent 的工具门控。
- 关键数据：11,118 stars / 1,067 forks、窗口内 41 commits（GitHub API 热扫 2026-08-20：https://api.github.com/repos/Arize-ai/phoenix）；版本 20.2.0、20.3.0。
- 原文链接：https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.2.0；https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.3.0；tags：https://github.com/Arize-ai/phoenix/tags。
- 影响判断：Phoenix 证明 approval 应是一等 telemetry，而 DSL 则让 incident/eval 团队能快速把行为模式变成筛选条件。OpenClaw 可定义统一 `approval.decision`、policy、actor、resource、reason、expiry span attributes，并为 session trace 提供安全表达式查询。

### 静默对象补充判断
- Helicone：release 页当前公开列表仍以 2025.08.x 与 v1.0.0 Docker 旧版本为主，窗口内未发现重大原始发布；不将官网常驻 AI Gateway 能力当本周动态。来源：https://github.com/Helicone/helicone/releases。
- AgentOps：5,787 stars / 612 forks，窗口内 0 commits，默认分支最后 pushed 2026-06-25；已有 replay、cost tracking、self-host 与 OpenAI/CrewAI/AG2/Agno/LangGraph 集成是背景，不计本周。来源：https://github.com/AgentOps-AI/agentops（2026-08-20 快照）。
- Coze Loop：仓库定位覆盖全链路 observability/evaluation，但本轮未从公开原始 release 证据核验到窗口内重大版本，状态记静默而非推断动态。来源：https://github.com/coze-dev/coze-loop。
- OpenTelemetry for Agents：未发现 8/13–8/19 的 Agent/GenAI semantic conventions 重大发布；2025 年 Agent observability 博客只作标准化背景，不计本周。来源：https://opentelemetry.io/blog/2025/ai-agent-observability/。
- AWS / Google / Azure：窗口搜索未发现日期和原文均满足的 agent observability/eval/simulation/guardrails 新发布。AWS 搜索最近强信号为 8/6 AgentCore 行为/成本控制，早于窗口，明确排除；Google/Azure 常驻产品页仅说明既有能力，不能包装成周动态。

### 模块洞察
- 可观测治理层正在从“记录模型调用”标准化为“记录完整 Agent 决策链”：审批、策略、工具轨迹、外部最终状态、在线评分与发布门禁开始共享同一 telemetry；同时 credential-safe tracing 成为生产化底线。

### OpenClaw 参照
- Trace schema：把 session/run/span、tool call、approval、policy decision、human actor、external final state 和 feedback score 建立稳定父子关系。
- 安全：默认不记录 MCP credentials、headers、sandbox env 与敏感工具输出；对 trace 导出做字段 allowlist、租户隔离与审计。
- Eval：建设 trajectory regression，覆盖工具选择/参数/顺序/权限/最终状态与多次运行一致性；生产失败可一键沉淀为 dataset case，并允许质量阈值阻断 skill/plugin 发布。


---

## 模块 8：Managed Agent Platform / Enterprise Control Plane

- 本期时间窗：Asia/Shanghai 2026-08-13 00:00 至 2026-08-19 24:00。
- 判定原则：平台存量能力用于矩阵，但只有窗口内原始公告、文档更新、release 或活动结果进入“本周动态”。特别排除 AWS temporal policies（官方页日期 2026-08-06）、Google 8 月 10 日平台评价公告等窗口外信息。

## 本周模块结论

- Microsoft 本周信号最完整：Foundry Agent Service 的 8 月 13 日新概览与 Agent Framework 1.14.0 同步把 prompt agent、Hosted agent、Responses API、Toolbox、Entra identity、session checkpoint 与 approval store 拼成一个控制面。
- 火山/字节的强信号来自 OpenViking v0.4.14/v0.4.15：Context Database 已不只是 RAG 组件，而在向 Session、MCP 可写工作区、Agent Plugins、云服务/自托管双形态扩张；同时“向量静默未落库”紧急修复提醒 memory 控制面必须提供数据完整性证据。
- Databricks 的 Grounded Reasoning Cup 用真实、隐藏语料的现场赛证明：同模型团队间可差 30.4 个百分点，企业 Agent 平台的竞争焦点是 parsing、retrieval、tool use、verification、parallelism 和 retry scaffolding 的系统工程，而不只是模型目录。
- 七平台都已覆盖矩阵，但本周 AWS、Google、腾讯云没有可核验窗口内重大平台发布，严格标静默；阿里云窗口内文章是社区部署蓝图而非 GA 公告，信号强度低于正式产品发布。

## 固定平台状态表

| 平台 | 本周状态 | 证据源（原始全文） | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 静默 | [AgentCore overview](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html)；[temporal policies](https://aws.amazon.com/about-aws/whats-new/2026/08/temporal-policies-agentcore/) 实际为 2026-08-06，窗口外 | 否 |
| Google Vertex AI / Gemini Enterprise | 静默 | [Google Cloud weekly announcements](https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud)，窗口内未见平台级新公告；ADK 2.7.0 属模块1 | 否 |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | 有动态 | [Foundry Agent Service overview](https://learn.microsoft.com/en-us/azure/foundry/agents/overview)，文档日期 2026-08-13；[Agent Framework 1.14.0](https://github.com/microsoft/agent-framework/releases/tag/python-1.14.0)，2026-08-14 上海 | 是 |
| 阿里云百炼 / Model Studio / PAI | 有弱动态（部署蓝图） | [PAI & EAS global scaling](https://www.alibabacloud.com/blog/scaling-genai-globally-with-alibaba-cloud-platform-for-ai-pai-%26-eas_603465)，2026-08-18；非产品 GA 公告 | 是 |
| 火山 Ark / Coze / Coze Studio / Coze Loop / OpenViking | 有动态 | [OpenViking v0.4.14](https://github.com/volcengine/OpenViking/releases/tag/v0.4.14)，2026-08-17；[v0.4.15](https://github.com/volcengine/OpenViking/releases/tag/v0.4.15)，2026-08-18 | 是 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 静默 | [腾讯云智能体平台](https://cloud.tencent.com/product/agent)；[CloudBase](https://cloud.tencent.com/product/tcb)，未核验到窗口内基础设施级公告 | 否 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 有动态（评测/采用信号） | [Grounded Reasoning Cup](https://www.databricks.com/blog/evaluating-ai-agents-live-grounded-reasoning-cup)，2026-08-18 | 是 |

## 7 平台能力矩阵（用于总报告）

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Runtime/Harness；serverless、session isolation、异步 Agent | short/long-term Memory，可跨 Agent 共享并学习 experience | Gateway 将 API/Lambda/MCP server 统一为 MCP endpoint；Registry | AgentCore Identity 对接 Cognito/Okta/Entra/Auth0；Policy 以 Cedar/自然语言拦截 tool call | microVM Harness、Browser、Code Interpreter（Python/JS/TS） | OTEL Observability、Evaluations、Optimization A/B | **静默**；8/6 temporal policy/rate limit 在窗口外，不纳入本周 |
| Google | ADK + Agent Platform/Vertex managed runtime；ADK session/task/live | Vertex AI Memory Bank、context cache、企业数据连接 | MCP Toolset、A2A、Apigee AI Gateway | Google Cloud IAM/agent identity、OAuth；ADK 可注入 MemoryBank credential | Cloud Run sandbox、代码执行/托管工具 | ADK eval、BigQuery Agent Analytics、Cloud trace/monitoring | ADK 2.7.0 有强 SDK 信号，但平台层本周静默 |
| Microsoft | Foundry prompt agent、Hosted agent、Responses API；session state persistence/autoscale | built-in memory、Azure AI Search/Cosmos BYO state | Toolboxes 暴露单一 managed MCP endpoint；web/file/code/MCP/OpenAPI/functions | 每 Agent 专属 Entra identity、RBAC、managed identity、OAuth OBO | Hosted session VM-isolated sandbox、BYO VNet、Code Interpreter | tracing、metrics、eval、Application Insights、Agent Optimizer | **Foundry 文档+Framework 1.14.0：Responses 2.x state store、checkpoint/approval 持久化** |
| 阿里云 | 百炼/Model Studio Agent 应用；PAI-EAS 托管推理与 autoscale | 知识库/RAG；AnalyticDB PostgreSQL vector | Model Studio tools/API；LangChain 对接；企业连接器 | RAM、EAS token、KMS；本周文章强调 token rotation | PAI-DSW/EAS container 与 GPU，非专用 browser control plane | ARMS、PAI 监控评测能力 | **8/18 PAI-EAS+Global Accelerator 部署蓝图**，但非 GA 公告 |
| 火山/字节 | Ark/Coze runtime；OpenViking Session、auto-commit；Coze Studio | OpenViking Context DB、Memory V3、Skills/Knowledge/RAG | Coze tools/plugins；OpenViking MCP tree/write/edit 与 Agent Plugins 1.0 | API key、用户 scope、删除即撤销；私有 Git token 与 URL 绑定 | Coze code/plugin execution；未见统一 browser 产品证据 | Coze Loop tracing/eval；OpenViking trace_id、stats/debug | **OpenViking v0.4.14/15：可写 context workspace + harness 插件 + 向量完整性修复** |
| 腾讯云 | 智能体平台/元器托管发布；CloudBase AI Toolkit 面向应用开发 | 知识库、CloudBase 数据与云函数上下文 | 元器插件/工具；CloudBase tools/MCP 生态 | 腾讯云 CAM、应用身份/密钥；公开细粒度 Agent identity 证据较弱 | CloudBase 云函数/容器；统一 browser/code sandbox 证据不足 | 平台运营/日志能力；独立 agent eval control plane 公开证据较弱 | **静默**；不以旧文章或应用案例凑数 |
| Databricks | Mosaic AI Agent Framework/Agent Bricks、Model Serving | Lakehouse/Unity Catalog、Vector Search、企业文档 grounded context | Unity Catalog functions/tools、MCP/外部工具生态 | Unity Catalog 权限、service principal、审计 | notebook/serverless compute；专用 browser control plane 不是优势 | MLflow tracing/eval、Agent Evaluation、OfficeQA/Pro | **Grounded Reasoning Cup：63.3%冠军、同模型差30.4点，证明全栈 harness 优化价值** |

### 矩阵证据说明

- AWS 各组件与 integrations 直接来自 AgentCore 官方 overview，包含 Harness、Runtime、Memory、Gateway、Identity、Browser、Code Interpreter、Observability、Evaluations、Optimization、Policy、Registry 的逐项定义；价格口径仅为 consumption-based、无 upfront/minimum，具体单价本周无新调整。
- Microsoft 各栏来自 2026-08-13 Foundry overview，明确 managed MCP Toolbox、Entra/OBO、Hosted session VM isolation、BYO VNet、tracing/eval/optimizer 与两类 agent 的成本项。
- Google/腾讯/阿里/火山/Databricks 的无动态栏用于能力基线，不能解读为本周发布；本周强信号列严格区分 SDK、社区文章、正式 release 与评测活动。

## 深度笔记

### Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK

- **本周动态：** Microsoft 在窗口首日更新 Foundry Agent Service 总览，并以 Agent Framework Python 1.14.0 将开发框架和托管面接上。Foundry 现在明确给出三条路径：无代码基础设施的 prompt agent、用 Agent Framework/LangGraph/OpenAI Agents SDK/Anthropic Agent SDK/GitHub Copilot SDK 或自定义代码打包的 Hosted agent，以及不创建持久资源、直接通过项目 endpoint 调 Responses API 的 ephemeral agent。Hosted agent 可交付 container image 或源码 zip，由 Foundry 构建，获得 managed endpoint、按 session/request 自动扩缩、专属 Entra identity、session-level state persistence 与端到端 observability。Toolbox 把 web/file search、code interpreter、MCP、function、OpenAPI 等工具统一在可版本化的 managed MCP endpoint 后，并支持 key、Entra managed identity、OAuth OBO。框架 1.14.0 同时将 Foundry Hosted Agents 迁移至 Agent Server Responses 2.x storage model，为 session/checkpoint/function approval 增加 provider-based state stores，并补齐 AG-UI approval resume。路线判断：Microsoft 正用 Responses-compatible data plane + Entra/Toolbox/Registry control plane，把 Copilot Studio、M365 分发和代码型 Agent 汇到同一企业治理面。
- **关键数据：** overview `ms.date=2026-08-13`、`updated_at=2026-08-19T22:12Z`；Agent Framework Python 1.14.0 GitHub 发布时间上海 2026-08-14 10:08；Hosted agent 成本由 inference + tool usage + container compute 构成，官方本页未给具体单价。
- **原文链接：** https://learn.microsoft.com/en-us/azure/foundry/agents/overview （2026-08-13）；https://github.com/microsoft/agent-framework/releases/tag/python-1.14.0 （2026-08-14）。
- **影响判断：** Microsoft 的护城河是 identity、M365 distribution 和企业采购面，而非单一编排算法。OpenClaw 若要进入企业，应提供可与 Entra/OBO、managed MCP toolbox 和 registry 对接的标准接口，同时保持自托管 Gateway 对状态、密钥和升级节奏的控制权。

### 阿里云百炼 / Model Studio / PAI

- **本周动态：** 8 月 18 日 Alibaba Cloud 社区发布 PAI + Elastic Algorithm Service（EAS）全球部署蓝图。它不是正式 GA 或定价公告，证据等级应低一档，但展示了阿里云把 Agent/GenAI serving 做成企业 control plane 的底座方式：模型权重放 OSS，PAI Model Gallery 或 DSW 准备模型，EAS 通过 JSON 描述实例、GPU、CUDA、streaming 与 autoscaling，再用 Global Accelerator 把全球用户路由到承载 VPC。示例配置是 Qwen2.5-7B-Instruct、A10 GPU、CUDA 12.1、`min_replica=1`、`max_replica=5`、GPU utilization target 70%，通过 SSE 暴露流式 endpoint，并用 `PaiEasChatEndpoint` 接入 LangChain。高级路径包括 AnalyticDB for PostgreSQL vector RAG、PAI-Blade 的 FP16/INT8/层融合（文中声称 throughput 最多 2x）以及 Function Compute 3.0 在 EAS scale-to-zero 时承接冷启动流量。文章还明确建议用 ARMS 验证扩容、KMS 轮换 EAS token，并警告大陆与国际区 feature parity。路线判断：阿里云仍以“模型/推理/数据/网络”底座驱动，而百炼 Agent control plane 的 identity、tool governance、evaluation 公开细节不如 Microsoft/AWS 完整。
- **关键数据：** 文章日期 2026-08-18；示例 1–5 replicas、70% GPU 阈值、A10/CUDA 12.1、512 max tokens；PAI-Blade “up to 2x”来自该社区原文，未找到独立 benchmark，须视为厂商生态作者主张而非保证；未公布本周新价格/客户。
- **原文链接：** https://www.alibabacloud.com/blog/scaling-genai-globally-with-alibaba-cloud-platform-for-ai-pai-%26-eas_603465 （2026-08-18）；产品入口 https://www.alibabacloud.com/en/product/machine-learning 。
- **影响判断：** 对跨境企业，推理 endpoint 的网络、GPU autoscale 与数据驻留同样属于 Agent 平台竞争；但这篇内容不能证明百炼新增了 Agent runtime。OpenClaw 可借鉴其“本地/区域 Gateway + 全球加速 + 观测阈值”的部署模板，并避免将社区示例数字包装成正式 SLA。

### 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking

- **本周动态：** 火山体系本周最硬证据来自 OpenViking。v0.4.14（8 月 17 日，82 commits）把 `viking://` 推成 Agent 可写工作区：MCP 新增 `tree/write/edit`，`wait=true` 可等待语义与向量索引刷新；Agent Plugins 1.0 包提供 manifest、零 npm runtime dependency 的 stdio-to-HTTP MCP proxy 与 memory Skill；DeepSeek Harness 插件实现自动 recall、Session capture、失败写入 replay 和路径保护，并精确绑定 `@deepseek-ai/dsh 0.1.0-rc.6`。Session 默认标签和 auto-commit policy 可动态修改，Memory V3 成为唯一抽取链路，SessionCommit worker 并发从 4 提升到 8，Streamable HTTP 改无状态以适配负载均衡。紧接着 v0.4.15 修复未锁定 xxhash 导致全新安装取到 4.x 后，local VectorDB/cuVS 新向量写入失败但任务仍显示成功的问题；受影响数据需重建向量。这一事件同时是产品进展与治理警报：context control plane 不只要“召回率”，还要写入确认、索引完整性、重建与错误传播。Coze/Ark/Coze Studio/Coze Loop 本周未核验到同等级新公告，不能把 OpenViking release 外推成整个火山平台 GA。
- **关键数据：** v0.4.14 发布 2026-08-17、82 commits；v0.4.15 发布 2026-08-18；DSH 依赖 rc.6，Node.js `^22.19.0 or >=24`；SessionCommit 默认并发 4→8；hot scan 快照 OpenViking 30,253 stars/2,338 forks、窗口内 64 commits（2026-08-20 GitHub API 快照）。
- **原文链接：** https://github.com/volcengine/OpenViking/releases/tag/v0.4.14 （2026-08-17）；https://github.com/volcengine/OpenViking/releases/tag/v0.4.15 （2026-08-18）；仓库 https://github.com/volcengine/OpenViking 。
- **影响判断：** 火山正在用开源 Context DB 抢占跨 harness 标准层，再反哺 Coze/Ark 生态，路线比单纯云内 memory API 更开放。OpenClaw 应考虑官方 OpenViking memory plugin，但接入前必须要求 write acknowledgement、向量计数/校验、重建工具和依赖锁定，避免“源文本成功、向量静默缺失”。

### Databricks Mosaic AI Agent Framework / Agent Bricks

- **本周动态：** Databricks 8 月 18 日公布首届 Grounded Reasoning Cup 全文，虽然不是 Agent Bricks 新版本，却提供了平台采用与 evaluation control plane 的强证据。11 支美加高校队伍在约两个月内基于 OfficeQA 优化 Agent，比赛前 36 小时才拿到新语料 OfficeQA Pro V2，并进行六轮、每轮 15 分钟/15 题的现场测试。Stanford 以 63.3% accuracy 获胜，比平均队伍高约 22 点、比 frontier-agent offline baseline 高约 35 点；18.8% 问题无人解决。同模型团队最高与最低分差 30.4 点，直接说明 harness 比模型选择更能解释生产性能。Stanford 将错误模式沉淀为约 100+ skills，并在准确率 verifier 与速度之间动态切换；UMass 每题并行跑 3 个 Agent 再验证，正确答案平均 4 分钟，对比全队平均 8 分 30 秒；Yale 用四臂并行与 meta-verifier。Databricks 的路线是把 OfficeQA/MLflow evaluation、Lakehouse 文档 parsing、retrieval 和 Agent Bricks 优化闭环结合，以可复现 enterprise grounded reasoning 拉开与通用云 Agent builder 的差异。
- **关键数据：** 11 teams；新 corpus 提前 36h；6×15 分钟 rounds、每轮 15 questions；冠军 63.3%；平均约 41%；18.8% 全队未解；同模型差 30.4 points；Stanford ~100+ skills；UMass 4:00 vs 8:30、36 个 speed bonuses；以上均来自 2026-08-18 Databricks 原文。未公布本周 Agent Bricks 定价。
- **原文链接：** https://www.databricks.com/blog/evaluating-ai-agents-live-grounded-reasoning-cup （2026-08-18）；OfficeQA Pro V2 链接由原文内联。
- **影响判断：** Databricks 正把“企业数据上的 grounded eval”变成 control-plane 销售语言，其优势在数据治理、评测与优化闭环。OpenClaw 应借鉴 held-out corpus、现场时限、端到端 submission success 和同模型 harness ablation，而不是只测单轮答案质量。

## 静默平台补充

- **AWS Bedrock AgentCore：** 本周无重大公开动态。官方 overview 显示其能力面目前最完整，甚至新增 Registry、Payments、Optimization 等层，但本轮搜索命中的 temporal policy/rate limiting 公告实际日期为 8 月 6 日，严格排除。该功能可作背景：Cedar/自然语言 policy 可在 Gateway 拦截每个 tool call，temporal policy 会考虑 session 先前动作，但不是本周新闻。
- **Google Vertex AI / Gemini Enterprise：** 本周平台层无重大公开动态；ADK 2.7.0 是强开发框架信号，已在模块1深写。Google weekly announcements 的 8/10–8/14 段未出现 Agent Platform GA/定价级发布，不能用 hackathon 或一般 Gemini 集成代替平台更新。
- **腾讯云智能体平台 / 元器 / CloudBase AI Toolkit：** 本周未核验到基础设施级正式公告。能力基线仍偏应用构建、知识库、插件和 CloudBase serverless；相较 AWS/Microsoft，公开材料对 per-agent identity、managed MCP gateway、isolated browser/code sandbox、统一 evaluation control plane 的说明较弱，这是矩阵中的真实证据缺口，不等同于断言产品不存在。

## 模块洞察

- **Enterprise Control Plane 正由“模型托管门户”升级为资源治理系统。** Microsoft/AWS 已显式覆盖 runtime、toolbox/gateway、identity、sandbox、trace/eval/optimizer；火山以 OpenViking 从 context 层向 session/plugin/control 面上探；Databricks则以数据与可泛化评测建立差异化。短板集中在跨平台身份、可移植 session state、memory 数据完整性证明和工具调用的时序策略。

## OpenClaw 参照

1. **机会：** 将 Gateway、sessions/cron、skills/plugins、browser/node 与多渠道能力包装成可审计 enterprise control plane，而不只是本地 assistant；补 Registry、版本化发布和组织级资源审批视图。
2. **补课：** 对标 Microsoft 的 per-agent identity/OBO 与 AWS 的 temporal policy，建立“用户—Agent—session—tool call”授权链、时序规则和集中 rate limit。
3. **领先点：** OpenClaw 的渠道 ingress、原生会话恢复、本地 Gateway 与节点执行覆盖了云厂通常拆散的模块；应通过 OTEL trace、held-out end-to-end eval 与 memory integrity checks 把领先点量化。
4. **生态策略：** 支持 OpenViking/MLflow/Foundry Toolbox/AgentCore Gateway 作为可插拔后端，同时确保 transcript、secret、approval 与 backup 的主权边界仍由 OpenClaw operator 控制。


---

## 质量门控与发布结论

- **模块覆盖**：8/8，全部包含模块结论、固定对象状态、深度笔记或静默说明、模块洞察。
- **平台矩阵**：7/7，AWS、Google、Microsoft、阿里云、火山/字节、腾讯云、Databricks 全覆盖 Runtime、Memory、Gateway、Identity、Sandbox、Observability。
- **GitHub 热度补漏**：已完成，OpenViking、Cognee、supermemory、Crawl4AI 全部纳入；动态与静默严格区分。
- **原文深度抽查**：OpenViking、Microsoft Foundry、ToolHive、E2B、Langfuse 5/5 URL 可定位原文，事实与时间窗一致。
- **判断质量**：8/8 模块均有趋势判断；TOP 5 按基础设施格局价值排序，而非新闻热度。
- **数据可信**：关键版本、日期、stars/forks、benchmark 与客户数据均附原始链接或明确标注“未公开/背景”。
- **Identity 专项**：OAuth/OIDC/MCP auth、token 托管、用户授权、tool permission、审计、越权与数据泄露均已覆盖。
- **OpenClaw 参照**：已提出 provider capability schema、敏感数据不落盘、宿主侧 egress、参数级 approval、memory integrity、approval-aware trace、enterprise registry 等行动项。

### 对 OpenClaw 的优先建议

1. **先补安全与一致性不变量**：被 guardrail 拒绝的数据不得落 transcript/memory/checkpoint；工具返回 URL 与每次 redirect 必须重做 SSRF 校验；高风险批准绑定用户、session、tool、canonical args、TTL 与一次性 nonce。
2. **把 Session 做成跨模块主键**：统一 parent-agent lineage、sandbox、identity、state store、memory scope、usage 与 trace，形成可迁移、可恢复、可审计的 Agent OS 契约。
3. **把 Memory 当数据库运营**：提供 doctor、写后读/向量计数校验、迁移 fixture、后台 backfill 与重建状态，避免“写入成功但不可召回”。
4. **用端到端 Eval 证明领先**：围绕工具顺序、权限、最终外部状态、重复稳定性和 held-out corpus 建 trajectory regression，并允许质量阈值阻断 skill/plugin 发布。
