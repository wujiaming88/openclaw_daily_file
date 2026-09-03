# 全球 AI Agent 基础设施研究周报（研究母稿）

- **本期时间窗**：2026-08-27 00:00—2026-09-02 24:00（Asia/Shanghai）
- **研究截止**：2026-09-03（周四）
- **研究口径**：窗口外内容仅作背景；本周动态必须可由官方公告、官方文档、GitHub release/commit 或一手产品页核验。GitHub stars 为抓取日快照，不代表周增量。
- **研究主线**：按 Agent Harness 八模块组织，而非按厂商流水账。

## 总结：本周的变化是“可恢复边界”开始成为基础设施产品

本周没有出现一个足以覆盖全行业的新协议发布，但四个强信号把下一代 Harness 的边界画得更清楚：

1. **OpenClaw v2026.8.2** 将后台 session、Gateway、浏览器 relay、cloud workspace、升级恢复、工具权限和 MCP 响应上限放进同一套 Agent OS 维护面；Agent 开始从聊天界面变成可迁移、可恢复、可治理的长期进程。
2. **OpenViking v0.4.17** 以 92 个 commit 对齐 Python/Go/TypeScript SDK，新增 `read_content`、MCP 图片/音频 block、一次性 TOS 导入、session/memory 可靠性修复和 memory-extraction 指标；Context Database 正在从“向量召回库”走向带 URI、Session、Skill、权限和可观测性的上下文控制面。
3. **Langfuse v4.26.0 + v3.225.7** 把 evaluator trace、API spec preview、OTel 摄入修复以及 JWT/API key/凭证保护放在同一条质量与安全链上；Agent eval 不再是离线报表，而是生产 trace 的可追溯分支。
4. **Crawl4AI v0.9.3** 以安全修复为主（PDF 路径任意文件写入、SSRF、DoS 与 Playground XSS），提醒“外部知识摄取”本身就是 Agent Harness 的高风险执行环境，不能只按爬虫功能评估。

横向看，云厂已经把 Runtime、Session、Memory、Identity、Sandbox、Tool Gateway、Observability 组合成平台能力；开源项目则在可组合性、快速迭代和开发者可见性上领先。竞争焦点由“谁有更多工具”转为 **谁能让一次长任务在正确的身份、正确的边界和正确的证据链内恢复**。

## 1. Harness / Agent OS 控制层

### 本周模块结论

- OpenClaw 的更新把长期运行、后台 session、浏览器 relay、升级/迁移恢复和工具权限收进统一控制平面，是本周最接近“Agent OS”定义的公开信号。
- 主流 SDK、ADK 和编排框架本周以存量能力为主；它们提供 graph、checkpoint、tool call 和 tracing，但还没有形成跨供应商可迁移的 Harness ABI。
- 控制层正在从“prompt + tool loop”变成 session、placement、policy、state migration 和 recovery 的组合契约。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态 | [v2026.8.2 release](https://github.com/openclaw/openclaw/releases/tag/v2026.8.2)，2026-09-01 | 是 |
| OpenAI Agents SDK / Responses API | 本周未核到同等级 release | [Agents SDK](https://github.com/openai/openai-agents-python/releases) | 否 |
| Anthropic Claude Agent SDK / MCP | 本周未核到窗口内强 release | [Claude SDK releases](https://github.com/anthropics/claude-agent-sdk-typescript/releases) | 否 |
| LangChain / LangGraph / LangSmith | 本周未核到平台级强信号 | [LangGraph](https://github.com/langchain-ai/langgraphjs/releases) | 否 |
| Google ADK / A2A | 本周未核到新协议发布 | [ADK](https://github.com/google/adk-python/releases) / [A2A](https://a2a-protocol.org/latest/specification/) | 否 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 本周未核到新平台级 release | [Agent Framework](https://github.com/microsoft/agent-framework/releases) | 否 |
| Databricks Mosaic AI / Agent Bricks | 本周未核到窗口内强 release | [Agent Framework](https://docs.databricks.com/) | 否 |
| CrewAI AMP / Studio、Dify、n8n、Flowise | 有持续维护，未核到本周基础设施级强信号 | 各项目官方 release | 否 |

### 深度笔记

#### OpenClaw v2026.8.2

本次 release（2026-09-01）不是单一 UI 迭代，而是对 Agent OS 控制面的一次横向加固。它允许从 New Session 在不离开当前页面的情况下启动后台 session，并保留 local、cloud 或 paired-device placement；完成后可从通知打开。Cloud workspace 可复用 prepared project snapshot，并在启动前验证 workspace hash，随后保留 Daytona-backed project 的 stop、snapshot、restart 周期。Gateway 断开时，支持的 macOS/Linux Chrome extension 可以唤醒配对的本地 relay；standalone relay 既能与 Gateway 共享浏览器，也能在 Gateway 断开时继续向其他 CDP client 提供服务。

状态与安全边界也更明确：unsandboxed session 默认可与同一 agent 的其他 session 互见（含保留的 cron session），共享部署需要将 `tools.sessions.visibility` 收窄到 `tree` 或 `self`；sandbox 和 cross-agent 限制仍有效。升级流程保留更新前配置，session migration 未完成时不再声称成功，并支持 `openclaw update cleanup --dry-run` 预览迁移备份的清理。工作区权限变更会作用于 active run，同时保留 cloud worker 的 session tool policy，避免改变执行位置时扩大权限。

Control plane 的另一个细节是 MCP HTTP/SSE oversized response 在解析前被拒绝，避免将超大响应变成内存和上下文攻击；插件 approval presentation 可描述外部验证选项，但 approval identity、authorization、timeout 和最终决定仍由 OpenClaw 保留。release 页面还记录了私有诊断脱敏、session migration、SQLite/agent database owner 协调等修复。关键数字和组件均来自 release 原文；GitHub 仓库页说明 Gateway 是 sessions、tools、events、channels 的本地 control plane（[仓库](https://github.com/openclaw/openclaw)，抓取 2026-09-03）。

**影响判断**：OpenClaw 的领先点是把 Gateway、session、cron、browser relay、workspace、plugin 和 policy 放在一个可操作的控制面；短板是一些 contract 仍主要存在 release note，而不是跨版本稳定的公开 ABI。对竞争平台而言，后台 session placement、权限不扩张和可恢复升级会成为企业验收项；对 OpenClaw 自身，应继续将 session visibility、checkpoint、TTL、迁移回滚和审计事件正式化。

#### 其他控制层对象：静默也有信息量

OpenAI Responses/Agents、Claude Agent SDK、LangGraph、Google ADK、Microsoft Agent Framework、Databricks Agent Bricks 本期没有被核实到足以改变格局的窗口内官方 release，不能用窗口外版本凑数。它们的存量能力仍代表竞争基线：Responses/Agents 强在统一 tool loop 与托管工具；Claude SDK/MCP 强在 background task、tool schema 与 enterprise connector；LangGraph 强在 graph checkpoint/store；ADK/A2A 强在 Agent 与 workflow 节点组合和跨 Agent task；Microsoft 以 Foundry Agent Service 把 prompt/hosted agent、toolbox、observability、identity 收进托管面；Databricks 以治理数据和评测/部署闭环差异化。

### 模块洞察

控制层正在标准化为 **session lifecycle + placement + policy + recovery**，但跨框架的迁移 ABI 仍未形成；OpenClaw 的机会是把这些不变量写成可查询契约，而不是仅停留在实现细节。

## 2. Runtime / Session / State 执行层

### 本周模块结论

- 生产 Runtime 的最小单位从一次 API 调用变成 session、workspace、identity、文件系统和 endpoint 的联合生命周期。
- 云厂提供 managed runtime、session、memory 和异步任务，但发布节奏本周相对静默；OpenClaw 的本地/云/配对设备 placement 体现了另一种可迁移 runtime 路线。
- 任何平台如果不能说明 idle、TTL、checkpoint、恢复、取消、跨 turn 文件和审计语义，都还只是托管 API，不是完整 Agent Runtime。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 存量能力，未核到窗口内强发布 | [AgentCore](https://aws.amazon.com/bedrock/agentcore/) | 否 |
| Google Vertex AI Agent Engine / Managed Agents | 存量能力，未核到窗口内强发布 | [Agent Platform scale](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale) | 否 |
| Microsoft Foundry Hosted Agents / Agent Service | 文档在 2026-08-27 更新，能力基线有变化 | [Foundry overview](https://learn.microsoft.com/en-us/azure/foundry/agents/overview) | 是（基线） |
| 阿里云百炼 / Model Studio / PAI | 未核到窗口内强发布 | [Model Studio](https://help.aliyun.com/zh/model-studio/) | 否 |
| 火山 Ark / Coze / Coze Studio | OpenViking 有动态，托管 runtime 未核到同级发布 | [Ark](https://www.volcengine.com/product/ark) | 否 |
| 腾讯云智能体/元器/CloudBase AI Toolkit | 未核到窗口内强发布 | [TI 平台](https://cloud.tencent.com/product/ti) | 否 |
| OpenClaw sessions / cron / Gateway | 有动态 | [v2026.8.2 release](https://github.com/openclaw/openclaw/releases/tag/v2026.8.2) | 是 |
| E2B / Modal / Daytona | 未核到窗口内强发布 | 官方 docs/releases | 否 |

### 深度笔记

#### OpenClaw：从 session 到可迁移执行 placement

v2026.8.2 将 background session 的启动入口、placement 选择、completion notice 和 session tabs/windows/splits 统一起来；这说明 session 不只是 transcript，而是具有执行位置、生命周期和可见性的运行实体。Prepared cloud projects 在工作区 hash 验证后再启动，且保留 stop/snapshot/restart 周期，降低云 workspace 与本地状态不一致的风险。Gateway recovery、session migration、active-run tool policy 与浏览器 relay wake-up 又把断线恢复、执行边界和外部设备整合进 runtime contract。

#### Microsoft Foundry：托管 Runtime 的平台基线

Microsoft 官方文档（`updated_at=2026-08-27`）将 Foundry Agent Service 定义为 managed platform for building, deploying and scaling agents。Agent Runtime 负责 host/scale prompt agent 与 hosted agent、管理 conversation、tool call 和 lifecycle；prompt agent 由配置驱动，hosted agent 将用户代码作为 container 交给托管 endpoint。文档同时列出 Toolbox 的 MCP endpoint、集中认证/治理/版本化，Observability 的 tracing/metrics/evaluation/Application Insights，以及 Entra identity、RBAC、content filters、VNet isolation。它说明 runtime 与 tool gateway/identity/eval 已不是单独产品。该页为官方文档更新，不把它误写成新 release。

#### 云平台 baseline

AWS AgentCore 页面将自身定位为“build, connect and optimize agents”，强调 any framework、any model、security built in；Google Gemini Enterprise Agent Platform 的官方 scale 文档将 Agent Runtime、Sessions、Memory Bank、Evaluation Service、Code Execution/Computer Use、IAM agent identity、Cloud Trace/Logging/Monitoring 放在同一 managed platform，且列出 VPC Service Controls、CMEK、data residency、HIPAA 等企业边界。两者是本期矩阵基线，并非窗口内新闻。

### 模块洞察

Runtime 正在商品化为 session + identity + filesystem + endpoint + observability 的生命周期服务；OpenClaw 可用本地 Gateway/cron 的透明度对抗云黑盒，但必须补齐可声明的 TTL、checkpoint 和跨 placement ABI。

## 3. Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论

- Crawl4AI v0.9.3 不是功能炫技 release，而是安全边界 release：PDF 处理和 Docker Playground 的漏洞修复说明知识摄取同样属于不可信执行环境。
- OpenClaw v2026.8.2 的 standalone browser relay 让浏览器执行脱离 Gateway 仍可被认证 CDP client 使用；“浏览器是否在线”与“Gateway 是否在线”开始解耦。
- E2B、Browserbase/Stagehand、Daytona、Modal 及云厂 sandbox 本周未核到同量级新发布；竞争基线仍是隔离、网络/凭证策略、文件挂载、checkpoint、回放和审计，而非单纯浏览器自动化成功率。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| E2B | 静默/未核到强动态 | [E2B docs](https://e2b.dev/docs) | 否 |
| Browserbase / Stagehand | 静默/未核到强动态 | [Browserbase](https://www.browserbase.com/) | 否 |
| Daytona | OpenClaw cloud workspace 背景集成，未核到独立强动态 | [Daytona](https://www.daytona.io/) | 否 |
| Modal | 静默/未核到强动态 | [Modal Sandboxes](https://modal.com/docs/guide/sandbox) | 否 |
| OpenAI Computer Use / Browser / Code Interpreter | 本周未核到同等级新发布 | [OpenAI tools](https://platform.openai.com/docs/guides/tools) | 否 |
| Anthropic Computer Use | 本周未核到窗口内强发布 | [Computer use](https://docs.anthropic.com/en/docs/agents-and-tools/computer-use) | 否 |
| AWS AgentCore Browser / Code Interpreter | 存量能力 | [AgentCore](https://aws.amazon.com/bedrock/agentcore/) | 否 |
| Azure Browser Automation / Code Interpreter | 存量能力 | [Foundry tools](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/tool-catalog) | 否 |
| Google Code Execution / sandbox | 存量能力 | [Code Execution](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/code-execution-overview) | 否 |
| Crawl4AI | 有动态 | [v0.9.3 release](https://github.com/unclecode/crawl4ai/releases/tag/v0.9.3) | 是 |

### 深度笔记

#### Crawl4AI v0.9.3：知识摄取的安全债务前移

官方 GitHub release 的安装信息是 `pip install crawl4ai==0.9.3`，并给出 Docker tag `unclecode/crawl4ai:0.9.3`。变更说明本身很短，要求继续阅读 CHANGELOG；仓库 README 对该版本给出更完整的原文摘要：这是 security release，修复五项 coordinated-disclosure advisories，包含 PDF 路径上的 arbitrary file write、SSRF、denial of service，以及 Docker Playground 的两项 XSS，同时包含 33 个 Docker server、crawler 和 PDF 处理 bug fixes；无新 feature、无 breaking change。仓库当前公开定位是 50k+ star 社区规模，GitHub 页面抓取日为 2026-09-03；这个数字是当前快照，不能解释为本周增长。

这条动态的重要性不在“爬虫修了多少 bug”，而在于 Agent 的 context ingestion 走过浏览器、PDF、Docker API 和用户请求 body；任何一段都可能把外部内容变成 SSRF、文件写入、脚本执行或模型上下文污染。Crawl4AI 早期版本已强调 Docker API 默认 auth、loopback bind 和 request body 作为 untrusted trust boundary，v0.9.3 把漏洞修复继续推进到具体处理路径。对 OpenClaw，Firecrawl/Crawl4AI 类工具应放在独立 sandbox/egress policy 中，输出需保留来源 URL、抓取时间、内容哈希和清洗状态，不应直接成为高信任 memory。

#### OpenClaw browser relay：浏览器成为独立 execution provider

v2026.8.2 允许支持的 macOS/Linux Chrome extension 构建唤醒配对的本地 relay，为认证 CDP client 提供浏览器；standalone relay 在 Gateway 断线时仍与其他 CDP clients 共享配对浏览器。它把浏览器 session、Gateway 控制面和 CDP transport 拆开，提升长任务的可恢复性，但也需要更明确的 relay ownership、origin、tab scope、cookie boundary 和断线后的授权撤销。

#### 云/托管 sandbox 的比较基线

Google Agent Platform 官方文档把 Code Execution 定义为 secure, isolated, managed sandbox，并与 Agent Runtime、Memory Bank、IAM agent identity 组合；Microsoft Foundry 把 code interpreter、MCP、web search 和 browser automation 作为可版本化 Toolbox；AWS AgentCore 以 runtime、browser、code interpreter、gateway、identity、memory、observability 组合成平台。E2B/Modal/Daytona/Browserbase 则代表更专门的执行 substrate：分别强调代码解释器、serverless container/GPU、开发 workspace、云浏览器。均未核到窗口内新的官方强信号，本期不把产品页能力写成新闻。

### 模块洞察

Sandbox 正从“隔离容器”分化为 browser、code、workspace、knowledge-ingestion 四类执行 substrate；下一代标准件必须同时给出网络、凭证、文件、回放、TTL、fork 和审计契约。

## 4. Tool Gateway / Protocol / Integration 工具层

### 本周模块结论

- MCP 与 A2A 的基础规格本周没有窗口内新版本；协议层的关键问题已从 discovery 转向长任务、异步事件、身份传递、progress/cancel 和 schema context budget。
- Microsoft Foundry Toolbox、AWS AgentCore Gateway、Composio/Arcade/Nango/Pipedream 的存量路线表明，tool gateway 正从 connector catalog 走向 managed auth、token exchange、版本化和审计。
- OpenClaw v2026.8.2 的 MCP response/SSE size limit 是“小而关键”的网关防护：协议语义必须在解析前受资源上限约束。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP | 本周无新正式版本；作为协议基线 | [MCP specification](https://modelcontextprotocol.io/specification/2025-06-18) | 否 |
| A2A | 本周无新正式版本；1.0.0 为基线 | [A2A specification](https://a2a-protocol.org/latest/specification/) | 否 |
| Composio | 未核到窗口内强发布 | [Composio MCP](https://composio.dev/) | 否 |
| Arcade | 未核到窗口内强发布 | [Arcade](https://www.arcade.dev/) | 否 |
| Nango | 未核到窗口内强发布 | [Nango](https://nango.dev/) | 否 |
| Pipedream Connect | 未核到窗口内强发布 | [Pipedream](https://pipedream.com/connect) | 否 |
| AWS AgentCore Gateway | 存量能力 | [AgentCore](https://aws.amazon.com/bedrock/agentcore/) | 否 |
| Google Agent Gateway | 存量能力 | [Google Agent Platform](https://docs.cloud.google.com/gemini-enterprise-agent-platform/) | 否 |
| Microsoft Toolbox / MCP endpoint | 文档能力基线，未核到窗口内新 GA | [Tool catalog](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/tool-catalog) | 否 |
| OpenClaw MCP handling | 有动态 | [v2026.8.2 release](https://github.com/openclaw/openclaw/releases/tag/v2026.8.2) | 是 |

### 深度笔记

#### 协议基线：MCP 与 A2A 各自稳定，网关层仍在补空白

MCP 规范页面定义 Host、Client、Server 三种角色，使用 JSON-RPC 2.0，提供 resources、prompts、tools，以及 sampling、roots、elicitation；同时明示 tools 代表任意代码执行，tool annotation 不应被无条件信任，Host 在调用前应获得用户 consent。MCP 协议自身不能强制 authorization 和 privacy，必须由实现层做 access control、数据保护和清晰授权 UI。A2A 1.0.0 则以 AgentCard、Task、Message、Artifact 为核心，支持同步、streaming、异步 push、cancel/list/get task 和多种 binding，强调 opaque execution 与 enterprise security。两者本周无新 release，因此作为背景和互操作基线，不能冒充动态。

#### OpenClaw MCP response limit

v2026.8.2 在 parse 前拒绝 oversized HTTP responses 和 SSE events，同时保留健康的 long-lived stream 与 keepalive。这个顺序很重要：如果先把外部 response 全部读入 parser，MCP server 就能以超大 JSON、长 SSE 或恶意事件拖垮 Gateway；若过早切断又会误伤正常 keepalive。OpenClaw 的修复将资源限制放在协议适配层，并配合 source-file fidelity、plugin approval verification 和 private diagnostics redaction，形成小型 tool gateway trust boundary。

#### Managed gateway 的路线

AWS AgentCore 产品页将 Gateway、Identity、Runtime、Memory、Browser、Code Interpreter、Observability 组合在同一平台，核心卖点是 any framework/any model 与 security built in；Microsoft Foundry 文档明确 Toolbox 可将 web search、file search、code interpreter、MCP servers、custom functions 统一为 managed MCP endpoint，并有 centralized authentication、governance、versioning。Google 的 Agent Platform 以 Agent Gateway、IAM agent identity、tool access 和 monitoring 组合；Composio/Arcade/Nango/Pipedream 则从 integration/auth broker 角度补 SaaS 连接和用户 token。平台化的差异不在“支持多少 tools”，而在第二跳 token 如何 exchange、谁能看到 tool schema、调用失败和撤销如何入审计。

### 模块洞察

Tool Gateway 正在从 function-calling 目录标准化为 **protocol + discovery + token exchange + policy + audit**；MCP/A2A 解决互操作，但不会自动解决用户同意、越权和数据泄露，治理仍是平台竞争核心。

## 5. Identity / Auth / Permission 权限层

### 本周模块结论

- 本窗口没有核到身份动态池的强发布，因此必须明确“无强信号”，不能用通用 IAM 新闻凑数；但云平台文档已把 Agent identity、OAuth/OIDC、RBAC、MCP endpoint auth、审计放进默认架构。
- 身份层至少要分四段：workload/agent identity、用户委托、credential broker/token vault、调用级 action policy。只有 OAuth login 没有后两段，不足以保护 Agent。
- OpenClaw 的 session visibility、plugin approval、workspace tool policy 和 MCP response limit 是本地控制面已有基础；下一步应将 approval、token scope、audit event 和撤销做成统一 permission contract。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 本周无强动态，平台基线 | [AgentCore](https://aws.amazon.com/bedrock/agentcore/) | 否 |
| Microsoft Entra Agent Identity / Foundry identity | 文档基线更新 | [Foundry overview](https://learn.microsoft.com/en-us/azure/foundry/agents/overview) | 是（基线） |
| Google Agent Identity / Gateway | 存量能力，平台基线 | [Google scale](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale) | 否 |
| Arcade Auth | 未核到窗口内强发布 | [Arcade](https://www.arcade.dev/) | 否 |
| Composio Auth | 未核到窗口内强发布 | [Composio](https://composio.dev/) | 否 |
| Nango OAuth / token management | 未核到窗口内强发布 | [Nango](https://nango.dev/) | 否 |
| Pipedream managed auth | 未核到窗口内强发布 | [Pipedream Connect](https://pipedream.com/connect) | 否 |
| OpenClaw permission boundary | 有动态 | [v2026.8.2 release](https://github.com/openclaw/openclaw/releases/tag/v2026.8.2) | 是 |

### 深度笔记

#### 云平台的身份基线

Microsoft Foundry 官方 overview（页面更新于 2026-08-27）将 Identity & Security 列为 Agent Service 组件：Microsoft Entra identity、RBAC、content filters、virtual network isolation；Toolboxes 通过单一 managed MCP endpoint 做 centralized authentication、governance 和 versioning。Google Agent Platform scale 文档列出 manage agent access、agent identity、service accounts、API keys、OAuth clients，并将 CMEK、data residency、VPC Service Controls 和 Access Transparency 分别映射到 Runtime、Sessions、Memory Bank、Code Execution 等服务。AWS AgentCore 的产品定位则把“secure tool calls”和“security built in from the start”作为 Gateway/Identity/Runtime 组合卖点。它们代表 capability baseline，不计为本周新增发布。

#### OpenClaw 的本地 permission contract

v2026.8.2 将 unsandboxed session 的默认可见范围扩大到同一 agent 的其他 session，包含 retained cron session，同时仍保留 sandbox/cross-agent 限制；官方给出的收窄选项是 `tools.sessions.visibility=tree|self`。这一变化有实用价值：跨 session 协作不需要复制上下文；但 shared-agent deployment 的默认面更宽，必须通过配置审计和启动时告警明确暴露。workspace permission 变化作用于 active run 且不扩大 cloud worker 的 tool policy，plugin external verification 也由 OpenClaw 保留 approval identity、authorization、timeout 和最终 decision。它们共同说明权限应绑定运行实体和 tool policy，而不是只绑定用户登录。

#### OAuth/OIDC 与最小权限检查清单

本期对每个身份对象都按以下缺口检查：OAuth/OIDC issuer/audience 是否 allowlist；用户 token 是否以 OBO/token exchange 进入第二跳；raw provider credential 是否只在 broker/vault 解密；tool schema、tool call、resource access 是否能按 user/agent/workspace/action 限制；审批、拒绝、撤销、异常和 policy decision 是否有 audit；prompt injection 能否把低风险 read 提升为 delete/send/pay；session transcript、memory、trace 是否会意外泄露 token。公开资料未能证明所有候选均满足这些条件，因此表内静默对象不作“安全已解决”判断。

### 模块洞察

Identity/Permission 是当前 Harness 最明显的短板：标准 OAuth 能证明“谁登录”，却不能单独证明“这次 tool action 是否获准”。行业将继续从 token 管理走向 agent identity、delegation、action policy 和可撤销审计。

## 6. Context / Memory / Knowledge 记忆知识层

### 本周模块结论

- OpenViking v0.4.17 是本周最强的 Context/Memory 动态：SDK 对齐、全文返回、MCP media、请求级 TOS 凭证、URI 兼容性、Session/memory 修复和抽取指标共同把上下文数据库推向生产控制面。
- Mem0、Cognee、supermemory、Letta、Zep/Graphiti、Firecrawl 本周没有都达到窗口内强动态门槛；OpenViking 与 Crawl4AI 覆盖了“记忆/资源/技能统一”和“外部知识摄取”的两端。
- Memory 的标准件不应只是 embedding + top-k，而应包含 provenance、scope、write policy、forget/delete、token budget、source freshness、ACL 与可重建索引。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态 | [v0.4.17 release](https://github.com/volcengine/OpenViking/releases/tag/v0.4.17) | 是 |
| Mem0 | 本周未核到窗口内强 release | [Mem0 releases](https://github.com/mem0ai/mem0/releases) | 否 |
| Cognee | 最近可核实版本在窗口外 | [Cognee releases](https://github.com/topoteretes/cognee/releases) | 否 |
| supermemory | 最近可核实版本在窗口外 | [supermemory releases](https://github.com/supermemoryai/supermemory/releases) | 否 |
| Letta | 本周未核到强动态 | [Letta](https://github.com/letta-ai/letta) | 否 |
| Zep / Graphiti | 本周无重大公开动态 | [Graphiti](https://github.com/getzep/graphiti/releases) | 否 |
| Firecrawl | 本周未核到窗口内新 release | [Firecrawl](https://github.com/firecrawl/firecrawl/releases) | 否 |
| Crawl4AI | 有动态，知识摄取安全信号 | [v0.9.3](https://github.com/unclecode/crawl4ai/releases/tag/v0.9.3) | 是 |
| LightRAG / GraphRAG / LlamaIndex / LangMem/Store | 未核到同等级窗口内动态 | 官方 releases/docs | 否 |

### 深度笔记

#### OpenViking v0.4.17：Context Database 进入跨 SDK 与协议阶段

GitHub release 原文称 v0.4.17 包含 **92 个 commit**，并欢迎 **14 位首次贡献者**。本版对齐 Python、Go、TypeScript SDK，覆盖 find/search、context search、recall、resources、content、Session、Skill、reindex 和 administration；`find` 与 list-mode `search` 新增 `read_content`，可把命中 URI 的可见全文放进 `content` 字段，CLI 对应 `--read-content`。MCP read 可以返回标准 image/audio content block，`mode=download` 导出原始 bytes；视频走 download。

数据导入边界也被明确：`add_resource` 支持一次性的 `args.tos_signature` 或 `args.tos_access` 进行 HEAD/GET，凭证不进入 resource metadata 或 async queue。目录 mkdir 即使无 description 也创建最小 L0 并排队向量化；content write 的 replace/append 在目标不存在时创建文件和父目录；accounts/users list 的 name 支持 `*`、`?`。公开 URI 发生 breaking change，uid-less 的 `viking://user/resources`、`viking://user/memories` 要迁移到 `viking://~/resources`、`viking://~/memories` 或显式 `viking://user/{user_id}/...`，否则返回 400。升级脚本、prompt、plugin 和服务端需要成组迁移。

可靠性修复包括连续 Session commit 的 archive lock contention、memory 多 block patch、replace 字段丢失、目录 overview 未进入 L1、query planner 返回 array 崩溃；Claude Code/Codex memory plugin 新增 `ov-memory-doctor`，DSH 可排除 delegated subagent session 避免污染用户记忆；新增按 memory type/action/result 的抽取指标，并记录受控错误码和真实耗时。仓库页面定位为 self-evolving Context Database，统一 Agent Memory、Knowledge RAG、Skills；抓取日公开 stars 约 **35,200**，该值为快照，非周增量。

**影响判断**：OpenViking 正从“RAG backend”走向带 URI namespace、Session、Skill、MCP content、异步 job、凭证边界和 observability 的 Context control plane。对 OpenClaw，最值得吸收的是 session commit → memory extraction 的异步分离、`viking://~` 这类当前主体 namespace、memory doctor 和抽取 outcome 指标；风险是 breaking URI、AGPL 许可和将 user memory、resources、skills 置于同一权限域的治理复杂度。

#### Crawl4AI：知识获取端也属于 Memory trust boundary

Crawl4AI v0.9.3 的安全 release 详见第 3 模块；在 Context 维度，它意味着外部网页、PDF、浏览器会话和 Docker server 的输出不能直接写入长期 memory。应至少保存 source URL、抓取时间、content hash、parser version、授权/robots 结果、清洗和人工复核状态；高风险内容先进入 quarantine namespace，再由 policy 允许进入 user/project memory。Crawl4AI 官方仓库 README 将其定位为给 RAG、agents、data pipelines 生成 LLM-ready Markdown 的开源 crawler，当前公开社区规模超过 50k stars；这类规模让漏洞修复具有生态扩散意义，但仍不等于其输出可信。

#### 静默对象与补漏结论

Cognee 最近可核实的 `v1.5.3.dev1` 发布在 2026-08-26，严格在窗口外；supermemory `server-v0.0.8` 在 2026-08-17；MCP specification 公开 RC 也在窗口外。因此它们保留为背景和动态池过滤结果，不能凑入本周强信号。Mem0、Letta、Zep/Graphiti、Firecrawl、LightRAG、GraphRAG、LlamaIndex、LangMem/Store、向量数据库 agent memory productization 均逐一过筛，未核到足以写成窗口内新闻的官方原文。

### 模块洞察

Memory 正从“检索组件”标准化为 **context database + lifecycle policy + evidence + skills**；OpenViking 和 Crawl4AI 分别展示了上下文控制面与摄取信任边界，行业仍缺少通用的 memory provenance/forget ABI。

## 7. Observability / Eval / Guardrails 可观测治理层

### 本周模块结论

- Langfuse v4.26.0 将 evaluator execution trace linkage、API spec preview 与 OTel ingest 修复合并；v3.225.7 则把 OTel、API key entitlement、JWT session age、凭证日志脱敏作为安全维护主线。
- OTel GenAI semantic conventions 仍处于 Development，不能把字段建议写成已冻结标准；Agent eval 要记录 turn、tool、identity、cost 和 response correlation，才有可追责性。
- 云厂将 trace、evaluation、guardrails、IAM 和 runtime 放在控制面；开源项目的机会是提供可迁移、可自托管、保留原始事件的 evidence plane。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 未核到窗口内强 release | [LangSmith](https://smith.langchain.com/) | 否 |
| Langfuse | 有动态 | [v4.26.0](https://github.com/langfuse/langfuse/releases/tag/v4.26.0) / [v3.225.7](https://github.com/langfuse/langfuse/releases/tag/v3.225.7) | 是 |
| Helicone | 未核到窗口内强 release | [Helicone](https://github.com/Helicone/helicone/releases) | 否 |
| AgentOps | 未核到窗口内强 release | [AgentOps](https://github.com/agentops-ai/agentops/releases) | 否 |
| Braintrust | 未核到窗口内强 release | [Braintrust](https://www.braintrust.dev/) | 否 |
| Arize Phoenix | 未核到窗口内强 release | [Phoenix](https://github.com/Arize-ai/phoenix/releases) | 否 |
| Coze Loop | 未核到窗口内强 release | [Coze Loop](https://github.com/coze-dev/coze-loop) | 否 |
| OpenTelemetry for Agents | semantic conventions 持续演进，未核到窗口内 GA | [GenAI semconv](https://opentelemetry.io/docs/specs/semconv/gen-ai/) | 是（标准背景） |
| AWS/Google/Azure observability/eval/guardrails | 平台基线 | 官方 Agent Platform 文档 | 否 |

### 深度笔记

#### Langfuse v4.26.0 与 v3.225.7

v4.26.0 release 原文列出两项 features：API spec previews for pull requests，以及将 evaluator execution traces 与被评估 trace 关联；同时修复 structured output 中 reasoning collision、OpenAI Responses in-app-agent 的 stateless call、OTel prompt version attribute 解析为 integer，并为 `metadata_dropped` 增加 projectId、SDK/attributeKey/parse-failure-kind 等标签。它们把 evaluation 过程本身变成可查询 trace，而不是一个离线分数。

v3.225.7 是同周的安全/稳定回补版本：防止 OTel prototype-chain clobbering；API key creation 受 admin-api entitlement 控制；默认 JWT session max age 降到 **14 天**；worker 拒绝日志脱敏 credentials；补回 attribute-path reconstruction hardening。两版 release 的独立原文均已精读；它们的交叉信号是 observability ingest 面越开放，越需要 tenant boundary、属性路径安全、session expiration 和凭证不落日志。

**影响判断**：Langfuse 以 OTel 兼容性扩大数据入口，以 evaluator trace 关联扩大质量闭环，同时用 v3 backport 修复安全边界。对 OpenClaw，评测事件应沿用 session/turn/tool/identity correlation，且必须在进入 trace 前做 secret redaction 和 cardinality 控制；“能观测”不能牺牲凭证安全。

#### OTel：语义层可互操作，但尚未冻结

官方 GenAI semantic conventions 将 agent、workflow、LLM、tool execution、evaluation 等事件逐步纳入统一语义，但字段与状态仍标记 Development。MCP 等工具链可以携带 trace context，但 implementation 必须避免重复 span、无限 cardinality、把完整 prompt/tool schema 默认写入 telemetry。Agent 评测还需要区分 attempt、logical turn、retry、cancel、zombie 和最终 outcome；只记录 HTTP 200/500 会丢掉 JSON-RPC error、policy deny 与 async completion。

#### 云厂的治理闭环

Google Agent Platform 文档将 built-in observability、Cloud Trace/Logging/Monitoring、Evaluation Service、Example Store、Memory Bank、IAM identity 与 Code Execution 放在同一生产面；Microsoft Foundry 把 tracing、metrics、evaluations、Application Insights、Agent optimizer、Entra identity、RBAC、content filters、VNet isolation 并列；AWS AgentCore 产品定位则强调 debug unexpected behaviors、secure tool calls 和 scale without rearchitecting。它们代表 managed control plane 的方向，但本周未核到这些平台有更强的窗口内 release。

### 模块洞察

Observability/Eval/Guardrails 正从 dashboard 竞争转为共享事件平面：同一个 tool-call event 既要被 trace、eval、cost、policy 和审计消费；OTel 提供互操作方向，却还没有替开发者定义数据最小化与执行阻断。

## 8. Managed Agent Platform / Enterprise Control Plane

### 本周模块结论

- 云厂的统一平台已经覆盖 Runtime、Memory/Context、Gateway/Tools、Identity、Sandbox、Observability/Eval；差异主要在默认边界、跨云可迁移性、数据治理和开发者自由度。
- AWS 强在模块化 AgentCore；Google 把 Agent Runtime、Sessions、Memory Bank、Evaluation、Code Execution、IAM identity 做成一体；Microsoft 将 Foundry Agent Service、Toolboxes、Entra、Application Insights 和发布纳入 enterprise lifecycle。
- 阿里云、火山/字节、腾讯和 Databricks 具备平台与模型/数据协同优势；本周公开强信号集中在火山 OpenViking，而非每个平台的托管 runtime 发布。

### 云厂能力矩阵（7/7）

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Runtime、Sessions、长期任务/托管运行 | AgentCore Memory、事件/记忆策略 | AgentCore Gateway、MCP/OpenAPI/tool access | AgentCore Identity、IAM/STS/委托 | Browser、Code Interpreter | AgentCore observability、Policy、Bedrock Guardrails | 本周未核到新平台级 release；能力基线来自 [AgentCore](https://aws.amazon.com/bedrock/agentcore/) |
| Google | Agent Platform Runtime、Sessions、managed agents | Memory Bank、context/session 管理 | Agent Gateway、MCP/A2A/工具治理 | IAM agent identity、service accounts、OAuth clients | Code Execution、Computer Use、secure sandbox | Cloud Trace/Logging/Monitoring、Evaluation、Example Store | 统一平台能力文档持续完善；[scale](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale) |
| Microsoft | Foundry Agent Runtime、prompt/hosted agents、conversations | Foundry memory/context 与项目数据能力 | Toolboxes、managed MCP endpoint、OpenAPI/MCP | Entra identity、RBAC、content filters、VNet | Code interpreter、browser automation、hosted container | tracing、metrics、evaluations、Application Insights、optimizer | 官方 overview 在 2026-08-27 更新；[Foundry](https://learn.microsoft.com/en-us/azure/foundry/agents/overview) |
| 阿里云 | 百炼/Model Studio/PAI 的模型与 Agent 托管能力 | 知识库、RAG、记忆相关组件 | 工具/插件/API 集成 | RAM/STS 等云身份；Agent 权限需按产品配置 | PAI/代码与应用运行环境 | Model Studio/PAI 评测与监控能力 | 本周未核到窗口内平台级强信号 |
| 火山/字节 | Ark/Coze/Coze Studio/Loop 运行与应用平台 | **OpenViking**：Memory/Knowledge/Skills Context Database | Coze/Ark tools、MCP/插件生态 | 云账号/应用侧 auth；Agent action policy 公开细节不一 | Coze/Ark 执行与外部工具；OpenViking ingestion | Coze Loop、OpenViking memory metrics | **OpenViking v0.4.17，92 commits；SDK/MCP/memory reliability** |
| 腾讯云 | 智能体平台/元器/CloudBase AI Toolkit/Serverless runtime | 知识库、RAG、Agent memory 组件 | 插件/API/MCP 类工具接入 | CAM/子账号/应用侧授权 | CloudBase/代码运行与工具执行 | TI/智能体平台的评估和监控 | 本周未核到窗口内平台级强信号；[TI](https://cloud.tencent.com/product/ti) 为能力基线 |
| Databricks | Mosaic AI Agent Framework/Agent Bricks、部署与 serving | Unity Catalog、Vector Search、知识与数据治理 | tools/UC functions/外部连接 | Workspace/IAM、Unity Catalog 权限 | serverless/模型与数据执行环境 | MLflow tracing/evaluation、质量闭环 | 本周未核到窗口内强 release；治理数据协同是差异化 |

### 平台判断

七家都在补同一张图，但默认哲学不同：AWS 以模块化和任何框架/模型为卖点；Google 将四个生产服务（Runtime、Context、Quality、Sandbox）直接产品化；Microsoft 以企业身份、Toolbox 和发布渠道形成 lifecycle；阿里云与火山/腾讯更强调本土云、模型和应用生态协同；Databricks 从数据治理、Unity Catalog 和 MLflow 进入 Agent 控制面。OpenClaw 的参照点不是与云厂比资源规模，而是保留 Gateway、session、cron、tool policy 的可见性和可迁移性，再以标准事件/协议接入云 runtime、memory 和 observability。

## TOP 5：按基础设施信号价值排序

1. **OpenViking v0.4.17：Context Database 从概念走向生产 contract。** 92 commits、跨语言 SDK、`read_content`、MCP media、request-scoped TOS credential、URI breaking change、Session/memory 修复与抽取指标同时出现，说明 Memory/Knowledge/Skills 正合成一个可操作的上下文控制面。
2. **OpenClaw v2026.8.2：Agent OS 的恢复与权限边界进入同一 release。** 后台 session placement、prepared workspace、standalone browser relay、visibility、升级迁移、active-run policy 和 MCP size limit 跨 Runtime、Sandbox、Identity、Gateway 联动。
3. **Langfuse v4.26.0 + v3.225.7：Eval trace 与安全摄入闭环。** evaluator trace linkage、OTel attribute handling、JWT 14 天、API-key entitlement、凭证脱敏共同说明观测系统本身也需要身份和安全治理。
4. **Crawl4AI v0.9.3：知识摄取成为 Sandbox/Memory 的安全边界。** PDF/Docker 处理漏洞并非外围问题；Agent 直接把外部 web/PDF 变成 context 时，SSRF、文件写入、DoS、XSS 都会转化为工具和记忆风险。
5. **七大平台的统一控制面收敛。** 虽然本周未出现七家同时发布的新 GA，但 AWS/Google/Microsoft 等官方平台文档已把 Runtime、Session、Memory、Gateway、Identity、Sandbox、Eval 组合起来；竞争从“提供组件”进入“默认安全边界与可迁移性”。

## 对 OpenClaw 的三条以上战略参照

- **机会**：把 sessions/cron/Gateway 的现有优势抽象成公开 lifecycle ABI：session owner、visibility、placement、TTL、checkpoint、cancel、resume、tool policy、audit event；这样可以接入云 Runtime 而不丢本地可解释性。
- **补课**：吸收 OpenViking 的 context namespace、memory doctor、异步抽取 outcome 与 `read_content`/MCP content 设计；memory 写入必须区分 user fact、runtime metadata、tool output、skill candidate，并支持 evidence/forget。
- **补课**：建立统一 PreToolUse/PostToolUse policy event，四态至少包括 allow、deny、instruct、review；把 secret redaction、MCP response limit、session visibility、plugin verification 连接到同一审计流。
- **威胁**：云厂把 Runtime、Memory、Identity、Sandbox、Eval 预集成后，企业采购会偏向一站式控制面；OpenClaw 若只以“本地能跑”竞争，会在治理、SLA、证据和撤销上被收编。
- **差异化**：OpenClaw 可以坚持 Gateway trusted control plane + untrusted execution + deterministic policy，提供跨供应商 placement 和可导出的 session/memory/trace，而不是锁定某一家模型或云。

## 研究门控自检

- 第①关模块覆盖：**8/8**，每个模块均含结论、固定对象表、深度笔记/静默说明、模块洞察。
- 第②关平台矩阵：**7/7**，AWS、Google、Microsoft、阿里云、火山/字节、腾讯云、Databricks 均有七列能力。
- 第③关 GitHub 热度补漏：**已完成**；见 `hot-scan-2026-09-03.md`。查询方向 9/9 执行；OpenViking、Cognee、supermemory、Crawl4AI 均有归类，窗口外对象未冒充本周动态。
- 第④关原文深度：**通过**；抽查 OpenClaw v2026.8.2、OpenViking v0.4.17、Crawl4AI v0.9.3、Langfuse v4.26.0/v3.225.7 五组官方 release，URL 可访问且正文细节相符。
- 第⑤关判断质量：**通过**；8 个模块均有洞察，TOP5 按基础设施信号价值排序。
- 第⑥关数据可信：**通过**；版本、日期、commit 数、contributors、stars 等关键数字均标 URL/日期或注明快照/供应商自报；未核实数字不写。
- 第⑦关身份覆盖：**通过**；覆盖 OAuth/OIDC、agent/workload identity、token exchange/broker、tool permission、audit、越权/泄露风险，并填入矩阵。
- 第⑧关 OpenClaw 参照：**通过**；机会、补课、威胁、差异化共 5 条。

## 主要来源索引

- OpenClaw release：<https://github.com/openclaw/openclaw/releases/tag/v2026.8.2>
- OpenViking release：<https://github.com/volcengine/OpenViking/releases/tag/v0.4.17>
- OpenViking repo：<https://github.com/volcengine/OpenViking>
- Crawl4AI release：<https://github.com/unclecode/crawl4ai/releases/tag/v0.9.3>
- Crawl4AI repo：<https://github.com/unclecode/crawl4ai>
- Langfuse v4.26.0：<https://github.com/langfuse/langfuse/releases/tag/v4.26.0>
- Langfuse v3.225.7：<https://github.com/langfuse/langfuse/releases/tag/v3.225.7>
- MCP specification：<https://modelcontextprotocol.io/specification/2025-06-18>
- A2A specification：<https://a2a-protocol.org/latest/specification/>
- AWS AgentCore：<https://aws.amazon.com/bedrock/agentcore/>
- Google Agent Platform scale：<https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale>
- Microsoft Foundry Agent Service：<https://learn.microsoft.com/en-us/azure/foundry/agents/overview>
- 腾讯云 TI：<https://cloud.tencent.com/product/ti>

## 研究缺口与保守说明

- Brave Search 在本期补漏时出现 429；已改用官方 GitHub release/repository、官方文档和产品页直接核验，未把未核实二手线索计入采用来源。
- 四条研究线子任务的落盘标记若未在父会话等待中全部到达，父会话以本母稿的主会话补抓为准；不得把子任务口头状态替代文件验收。
- Identity/Gateway 动态池、阿里云/腾讯/Databricks 本周未获得足够窗口内强原文，不强行拔高；“本周无重大公开动态”是有效结果。
