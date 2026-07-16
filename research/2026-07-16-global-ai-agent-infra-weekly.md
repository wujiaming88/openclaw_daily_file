# 全球 AI Agent 基础设施研究周报 · 第 5 期（2026-07-09 ~ 07-15）

> 覆盖区间：**2026-07-09 00:00 → 2026-07-15 24:00（上海时区）** 完整一周
> 生成日期：2026-07-16（周四）｜研究团队：黄山（wairesearch）× 小帅（统帅审核）
> 聚焦：AI Agent **基础设施赛道**（运行时 / 编排层 / 框架托管），非应用层
> 覆盖：12 个核心对象（3 云厂托管平台 + 4 模型厂商/通用框架 + 数据/开源/中国平台）

---

## 四维质量门控（本期自检）

| 关卡 | 标准 | 结果 |
|------|------|------|
| ① 覆盖率 | A 组 3 云厂 100% 必出 + B/C 合计 ≥80% | **11/12 覆盖**（A 3/3 + B 4/4 + C 4；字节 Coze✅）PASS |
| ② 原文深度 | 抽 5 对象验 URL 真实且内容对得上 | AgentCore/Foundry/OpenAI/Dify/Coze 抽查 URL 真实、内容一致 PASS |
| ③ 判断质量 | 每对象有洞察 + 四维趋势齐 | 每对象含影响判断，每组含四维本组洞察 PASS |
| ④ 数据可信 | 关键数据有源 URL+日期，交叉验证，零编造 | 版本号/定价/Stars/日期全标源，MCP 大改正确标注窗外(07-28) PASS |

**四道全过，准予出刊。**

---

## 本期 TOP 5（按对基础设施格局的信号价值排序）

1. **微软 Foundry「全家桶 GA」（7/9）** — Hosted agents 作为「任意框架/harness 的统一生产运行时」正式 GA，同步 GA GPT-5.6 系列（Sol/Terra/Luna）+ APAC 数据区 + Voice Live。本周唯一平台级重磅，把"模型—运行时—身份安全—M365/Teams 分发"压进一个平台。
2. **OpenAI hosted multi-agent over WebSocket（Agents SDK v0.18.2，7/11）** — 把多智能体编排从"客户端库"上抬为"Responses 平台侧托管服务"，Swarm→Agents SDK→托管化谱系闭环，同期砍掉可视化 Agent Builder。
3. **Google Memory Bank profiles GA + ADK 默认 OTEL tracing（7/15）** — 长期记忆从向量检索式往结构化 profile 式演进（低延迟直取），新部署 ADK agent 默认开可观测，生产运维基座收口。
4. **Dify v1.16.0-rc1「Dify Agent」（7/9）** — 开源阵营正式切入 shell/Linux sandbox + Skills 的通用 Agent 运行时范式，对标 Coze Studio 与闭源 coding agent。
5. **Databricks Omnigent 会话级 contextual policy 防 slow-burn 攻击（7/14）** — 把 Agent 治理从"单点授权"升级到"会话级行为审计"，是当前 Agent 安全领域少有的把"多步组合攻击"作为一等公民治理的公开工程叙事。

---

## 本周主线（四维趋势）

**一、三大云厂节奏：微软领跑、Google 稳推、AWS 收口。** 微软 7/9 一次性 GA 前沿模型 + APAC 数据区 + Hosted agents 生产运行时 + Voice Live；Google 以 Memory Bank profiles GA、多区域 GA、ADK 默认 OTEL tracing 稳步推进生产运维基座；AWS 本周无平台级新组件，重心在多租户身份治理（OBO/Gateway）、CLI 逼近 1.0、真实客户落地与旧 Bedrock Agents 7/30 日落。

**二、战略趋同：都在抢"框架无关的中立托管运行时"。** AWS AgentCore "any framework"、Google ADK "model-agnostic"、微软 Foundry Agent Service 明确收编 Agent Framework/Copilot SDK/LangGraph/OpenClaw/Hermes。竞争焦点从"框架好不好用"转向"运行时的身份/安全/可观测/长时任务韧性/合规区域"。

**三、执行托管化 + 安全隔离成标配。** OpenAI hosted multi-agent、Anthropic Cowork 远程会话、LangSmith Sandboxes、OpenAI Sandbox Agents 同向发力——安全隔离的 agent 代码执行正成为平台标配。

**四、治理/可观测/成本成新护城河。** CrewAI 把 Cost Limit 写进 Agent Control Plane、Databricks 用 Omnigent 会话级策略防组合攻击、字节持续投入 Coze Loop 可观测、LangSmith 强化 coding agent 与多轮 thread evaluator。2026 下半年竞争主战场是"生产级可运维性"，而非模型或框架本身。

---


# A 组 · 三大云厂 Agent 托管平台

### Amazon Bedrock AgentCore（AWS）

- **本周动态**：本周 AgentCore **无平台级新组件 GA/preview 公开发布公告**（无新 Runtime/Memory/Gateway/Identity GA、无新区域官方 What's New 条目落在 7/9–7/15 窗口内），但**开发者工具链与生态高频推进**，且官方内容密集围绕 Identity/Gateway 的多租户企业场景与真实客户落地展开：

  ① **开发者工具链（GitHub 直查，均在窗口内）**：`aws/agentcore-cli`（AgentCore CLI，"终端体验"）本周连发多版本——`v0.24.0` 与 `v1.0.0-preview.21`（2026-07-10）、`v0.24.1` 与 `v1.0.0-preview.22`（2026-07-13）、以及每次 main 提交自动打包的 `prerelease`（最新 2026-07-15 17:06 UTC）。变更以修复为主：修复 `agentcore dev` 覆盖 OTEL exporter 环境变量（PR #1742）、修复首次部署被 scope 到零 stack 的问题（PR #1753）、TUI 部署 scope 到 picker 选中目标（#1659）、稳定 AGUI 浏览器 thread ID（#1686），并新增 API 参考文档生成 CI（#1694）。CLI 项目文件 `agentcore.json` 已管理 agents/memory/credentials/gateways/evaluators/online evals/knowledge bases/**harnesses**/policy engines/**payment managers and connectors**/datasets/runtime endpoints——印证 harness(preview)、Payments、Policy 等组件已进入 CLI 一等公民管理面。CLI 正处在 `v0.24.x`（稳定线）与 `v1.0.0-preview.x`（预览线）双轨并行、逼近 1.0 正式版的节点。

  ② **官方博客/文档（Identity + Gateway 深度）**：AWS ML Blog 本周发布《Implement on-behalf-of token exchange for multi-tenant agents with Amazon Bedrock AgentCore Gateway》（约 7/14）。原文关键点：多租户生产架构中 agent 代用户调下游 API 的身份难题——用 agent 服务身份会塌陷审计链、直接转发用户 token 会把每个下游工具变成"confused deputy"。AgentCore **Identity 原生支持 OAuth 2.0 Token Exchange（RFC 8693）作为 credential-provider 授权类型**，实现 OBO（on-behalf-of）令牌交换。文中以 TravelBot 多租户订票助手（Acme/Globex 两租户）为参考实现，演示对接 Okta、逐跳 JWT claim 变换、audience binding 的纵深防御；参考代码将发布于 `aws-samples/sample-obo-flow-poc`。此为 4 月《Building multi-tenant agents》与《Gateway interceptors 细粒度访问控制》的落地续篇——AgentCore 正把企业级身份/多租户治理做深。

  ③ **客户落地案例（本周密集）**：KTern.AI 基于 AgentCore + Strands Agents SDK 为 SAP 构建多 agent 系统（~7/11，持久上下文/安全工具访问/生产级可靠性）；Bluesight（CTO Vijay Venkatesh 合著）用两次 AWS engagement + AgentCore 从单产品原型演进到覆盖 6 个医疗合规产品的统一 agentic 方案 Prism，其 ControlCheck 助手 2026-05 上线，用于 340B 药品定价合规审计（单实体年省 4000+ 小时人工、覆盖 620+ 医院）；Thrad.ai 用 Strands + AgentCore 做多 agent 销售管线（Swarm vs Graph 编排 head-to-head benchmark）；另有 AWS End User Messaging + AgentCore Runtime + Strands 构建自主电商助手的 messaging blog。

  ④ **生态开源**：`awslabs/loom`（Loom for AWS，企业级平台，构建/部署/运营 AgentCore Runtime + Strands agents，Cognito 认证、scope 授权、多 persona、对 agents/memory/MCP servers/A2A/AWS Agent Registry 治理做全生命周期管理）本周被 AWS Open Source Blog 正式介绍，并入选 7/13 AWS Weekly Roundup。

  ⑤ **竞争/战略信号**：多方来源确认 **Bedrock Agents "Classic"（旧版 Agents）将于 2026-07-30 停止向新客户开放，官方引导新用户改用 AgentCore**——即 AgentCore 已成为 AWS agent 平台唯一正式入口，旧 Agents 进入日落。

  （背景，非本周）AgentCore 平台级里程碑：Agent Registry preview（2026-04-09）、AgentCore Payments（与 Coinbase/Stripe，2026-05-07）、AgentCore Optimization preview（2026-05-04）、AgentCore Web Search 工具（2026 年内）。

- **关键数据**：
  - agentcore-cli 版本：v0.24.1 / v1.0.0-preview.22（2026-07-13），prerelease（2026-07-15 17:06 UTC）— https://github.com/aws/agentcore-cli/releases ｜ 2026-07-16 直查
  - GitHub Stars（2026-07-16 直查 api.github.com）：`aws/bedrock-agentcore-starter-toolkit` 497★（pushed 2026-07-15）；`aws/agentcore-cli` 212★（pushed 2026-07-15）；`awslabs/loom` 111★（pushed 2026-07-10）
  - Bedrock Agents Classic 对新客户关闭日：2026-07-30 — https://www.augmentcode.com/tools/aws-bedrock-agents-vs-cosmos ｜ 2026-07-15（需官方交叉验证，第三方来源）
  - Bluesight：单covered entity 年省 4000+ 小时、网络覆盖 620+ 医院 — AWS ML Blog ｜ ~2026-07-15
- **原文链接**：
  - https://aws.amazon.com/blogs/machine-learning/implement-on-behalf-of-token-exchange-for-multi-tenant-agents-with-amazon-bedrock-agentcore-gateway/
  - https://aws.amazon.com/blogs/machine-learning/building-an-agentic-ai-solution-at-bluesight-with-amazon-bedrock/
  - https://github.com/aws/agentcore-cli/releases （CLI 版本/提交实时数）
  - https://aws.amazon.com/blogs/aws/aws-weekly-roundup-...-july-13-2026/ （Loom for AWS）
- **影响判断**：本周 AgentCore 无"大爆点"发布，但信号一致指向"平台成熟收口"：①CLI 逼近 1.0、harness/Payments/Policy 已进 CLI 管理面，说明组件矩阵趋于稳定可运维；②官方内容重心从"发新组件"转向"多租户身份治理 + 真实企业落地"（KTern/Bluesight/Thrad），是从 land 到 expand 的商业化阶段特征；③旧 Bedrock Agents 7/30 对新客户关闭，AgentCore 独占 AWS agent 平台入口，战略地位坐实。

---

### Google Vertex AI Agent Engine + Agent Builder + ADK（Google Cloud）

- **本周动态**：本周 Google 托管 agent 栈（现统一品牌为 **Gemini Enterprise Agent Platform**，整合原 Vertex AI Agent Engine / Agent Builder）**有多条在窗口内的官方 release note，且 ADK/A2A 开源侧持续高频迭代**：

  ① **Memory Bank memory profiles GA（2026-07-15，窗口内）**：官方 release note 原文——Memory Bank 的 memory profiles 正式 GA。memory profiles 允许生成"结构化画像"（带静态 schema 的数据结构，由 LLM 填充/更新）。通过定义固定 schema，agent 可对不断演化的信息获得即时、低延迟访问，**无需在会话中执行昂贵的 search 操作**。这是 Google 把"agent 长期记忆"从向量检索式往结构化 profile 式演进的关键一步——针对高频读取的用户/实体画像做低延迟直取。

  ② **Preview 模型退役（2026-07-09，窗口内）**：`gemini-2.5-flash-lite-preview-09-2025`、`gemini-2.5-flash-preview-05-2025`、`gemini-3.1-flash-lite-preview` 三个 preview 端点已退役、不可访问，需迁移到最新 Google 模型。反映 Gemini 模型代际推进（3.1 Pro 已在 Google Cloud 上线，见下）与 preview 端点快速轮替的节奏。

  ③ **近窗口（release notes 于 7/10 前后更新，A2A/Agent Engine 相关）**：Memory Bank 与 Sessions 对**多区域(multi-regional)与全局(global)端点的支持已 GA**；**新部署的 ADK agent 在 Agent Engine 上默认开启 OpenTelemetry tracing（Default-On Tracing）**，无需手动配置即获得可观测性；Agent Gateway 支持 Agent-to-Anywhere(egress) 与 Client-to-Agent(ingress) 双模式（Agent Runtime 全支持，Gemini Enterprise 仅 egress）。（背景，7/8）Memory Bank IngestEvents API GA（事件摄取与记忆生成解耦，支持 overlap_event_count 跨窗口上下文承接、revision_labels/revision_ttl 管理、metadata 附加）；Memory Bank 支持 gemini-embedding-2 相似度检索。

  ④ **ADK 开源侧（GitHub 直查，2026-07-16）**：`google/adk-python` 20,627★，本周仍在高频提交（pushed 2026-07-16 01:34 UTC），最新 release v2.4.0（2026-07-07，紧邻窗口前）、v1.36.0/1.36.1（双线并行，2.x 新架构 + 1.x 维护线）；`google/adk-go` 8,570★（pushed 2026-07-15）；`google/adk-java` 1,646★（pushed 2026-07-16）。ADK 定位"模块化、模型无关框架，让构建/部署复杂 AI agent 像标准软件开发"。ADK agent 可通过 Agents CLI 一条命令注册到 Gemini Enterprise，并部署到 Vertex AI Agent Engine 或 Cloud Run。

  ⑤ **A2A 协议**：`a2aproject/A2A`（Agent2Agent 协议）**24,804★**（pushed 2026-07-15，本周活跃），是三大云厂 agent 互操作协议中 Star 数最高的开源项目之一，Google 主导、已捐给 Linux Foundation 生态；A2A 深度集成进 Agent Gateway/Agent Engine 的 agent 间通信。

  ⑥ **模型侧**：Google Cloud 本周（"6 days ago"）宣布 **Gemini 3.1 Pro** 上线 Google Cloud（"更聪明、更强的复杂问题求解基线"），并推 Gemini Live Agent Challenge。

- **关键数据**：
  - Memory Bank memory profiles GA 日期：2026-07-15 — https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ｜ 直查 2026-07-16
  - GitHub Stars（2026-07-16 api.github.com 直查）：adk-python 20,627★（v2.4.0 / 2026-07-07）、adk-go 8,570★、adk-java 1,646★、a2aproject/A2A 24,804★
  - Grok 4.1 在 Google Agent Platform 关停日：2026-08-20（迁移到 Grok 4.2/4.3 或 Model Garden 替代）— 同 release notes ｜ 2026-07-08
- **原文链接**：
  - https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes （7/15 Memory profiles GA、7/9 preview 退役、7/8 IngestEvents GA 等，均直读原文）
  - https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud （Gemini 3.1 Pro 上线）
  - https://github.com/google/adk-python/releases （ADK 版本/提交实时数）
  - https://github.com/a2aproject/A2A （A2A 协议 Star/活跃度）
- **影响判断**：①Google 把"Vertex AI Agent Engine + Agent Builder"统一收编进 **Gemini Enterprise Agent Platform** 品牌，是与 AWS AgentCore、微软 Foundry 正面对标的"一体化 agent 平台"定位；②本周动作集中在**记忆(Memory Bank profiles GA/多区域 GA)与可观测性(ADK 默认 OTEL tracing)**这两个"生产运维基座"，说明 Google 也进入"让 agent 可规模化上生产"的收口阶段，与 AWS 节奏高度一致；③A2A 24.8k★ + ADK 20.6k★ 的开源号召力是 Google 相对 AWS/微软最大的差异化护城河——以开放协议+开放框架抢占 agent 互操作标准话语权。

---

### Microsoft Foundry Agent Service（Azure AI Foundry）

- **本周动态**：**本周是三大云厂里动静最大的一家**——微软于 **2026-07-09**（原文 datePublished 2026-07-09T17:00Z，窗口内）发布重磅博客《Frontier models and production agents: Advancing Microsoft Foundry for the agentic era》，一次性宣布**三大块 GA**：

  ① **Hosted agents in Foundry Agent Service 正式 GA**（本组最重要 in-window 事件）。原文："Hosted agents in Foundry Agent Service is now generally available, giving developers one production runtime for agents built with any framework and harness—Microsoft Agent Framework, GitHub Copilot SDK, LangGraph, OpenClaw, Hermes, and others." 即 Foundry Agent Service 成为**框架/harness 无关的统一生产运行时**。企业级能力 day-one 就位：通过 Azure Virtual Network (VNet) 集成做网络隔离，把 agent 流量锁在安全边界内；面向长时任务的 **resilient task support 进入 private preview**（aka.ms/ResilientAgent/PrPr）——平台保持沙箱运行、harness 负责 checkpointing，二者协作让 agent 重启后可从断点恢复（多轮对话/推理循环/human-in-the-loop 审批无需开发者自建 recovery/retry/state 管理）。支持发布到 **Microsoft 365 Copilot 与 Microsoft Teams**。另外 **Hosted agents with Voice Live 同步 GA**（用 Azure VoiceLive SDK 给任意框架构建的 agent 加实时语音）。

  ② **OpenAI GPT-5.6 前沿模型系列 GA**：GPT-5.6 Sol（最强推理，面向 agentic/代码密集企业级负载）、GPT-5.6 Terra（均衡日用款，性能对标 GPT-5.5 但成本更低）、GPT-5.6 Luna（最快最省，面向高并发低延迟）。**Day-one 覆盖全部 28 个 global 区域的 Global Standard + Global Priority Processing、Data Zones Standard、Global Provisioned**。定价（USD/百万 token，Standard Global）：**Sol 输入 $5.00 / 输出 $30.00；Terra 输入 $2.50 / 输出 $15.00；Luna 输入 $1.00 / 输出 $6.00**。（注：正文小标题写 Luna，列表处曾出现"GPT-5.6"三名并列，以定价表 Sol/Terra/Luna 为准。）

  ③ **Asia-Pacific (APAC) Data Zone GA**：让 APAC 客户在区域内运行前沿 OpenAI 模型、数据处理留在亚太区，满足主权/合规。引用客户 Viva Republica (Toss，韩国) CDAO Hongsoo Kim 背书。

  ④ **规模数据（原文）**："More than 100,000 organizations are already building on Microsoft Foundry"，Adobe、Telefónica、Tata Consultancy Services (TCS) 已在生产跑 agent。

  ⑤ **开源框架侧（GitHub 直查 2026-07-16）**：**Microsoft Agent Framework**（autogen + Semantic Kernel 融合后的新一代统一框架）12,138★，本周活跃（pushed 2026-07-15 23:00 UTC），窗口内发 **python-1.11.0（2026-07-10）**，另有 dotnet-1.13.0（7/3）；`Microsoft.Agents.AI.Foundry` NuGet 包（--prerelease）已可直接 `.AsAIAgent(model:"gpt-5.4-mini")` 对接 Foundry。**Semantic Kernel** 28,317★（pushed 2026-07-10），最新 python-1.44.0 / dotnet-1.78.0（均 2026-07-07，紧邻窗口前）。**AutoGen** 59,758★ 但**已冻结**（last push 2026-04-15、last release python-v0.7.5 2025-09-30），能力已并入 Agent Framework——AutoGen 品牌进入维护/收编状态。

  ⑥ **文档/配置侧（in-window）**：Foundry Learn 文档更新——2026-06-25 后创建的 Foundry project 支持私有(网络加固)的 Azure Container Registry 存放 agent 镜像（hosted-agents 文档，"4 days ago"更新）。

- **关键数据**：
  - GPT-5.6 定价（Standard Global，USD/百万 token）：Sol 5.00/30.00、Terra 2.50/15.00、Luna 1.00/6.00 — https://azure.microsoft.com/en-us/blog/frontier-models-and-production-agents-advancing-microsoft-foundry-for-the-agentic-era/ ｜ 2026-07-09
  - Foundry 客户规模：100,000+ 组织（Adobe/Telefónica/TCS 生产运行）— 同上 ｜ 2026-07-09
  - GitHub Stars（2026-07-16 api.github.com 直查）：autogen 59,758★（冻结，last push 2026-04-15）、semantic-kernel 28,317★、agent-framework 12,138★（python-1.11.0 / 2026-07-10）
- **原文链接**：
  - https://azure.microsoft.com/en-us/blog/frontier-models-and-production-agents-advancing-microsoft-foundry-for-the-agentic-era/ （GA 公告全文，已读）
  - https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents （Hosted agents 概念/VNet/私有 ACR）
  - https://github.com/microsoft/agent-framework/releases （python-1.11.0 in-window）
  - https://learn.microsoft.com/en-us/agent-framework/overview/ （Microsoft.Agents.AI.Foundry 对接 Foundry）
- **影响判断**：①本周微软打出"全家桶 GA"组合拳（前沿模型 GPT-5.6 + APAC 数据区 + Hosted agents 生产运行时 + Voice Live），把"模型—运行时—身份安全—M365/Teams 分发"压进一个平台，是三大云厂中**分发渠道最强**的一家（直连 M365 Copilot/Teams 十亿级用户）；②Foundry Agent Service 明确定位"任意框架/harness 的统一生产运行时"（连 LangGraph、OpenClaw、Hermes 都收），与 AWS AgentCore"any framework"、Google"model-agnostic ADK"形成三方趋同——都在抢"中立托管层"；③AutoGen 冻结、能力并入 Agent Framework，微软框架线完成收编统一，Agent Framework(12k★)成为唯一主推，与 Google ADK、AWS Strands 三分开源框架格局。





---

## 本组洞察（三大云厂 Agent 平台格局变化 · 2026-07-09→07-15）

1. **本周节奏：微软领跑、Google 稳推、AWS 收口。** 微软 7/9 一次性 GA "GPT-5.6 系列 + APAC 数据区 + Hosted agents 生产运行时 + Voice Live"，是本周唯一的平台级重磅发布；Google 以 Memory Bank profiles GA(7/15)、preview 模型退役(7/9)、Memory/Sessions 多区域 GA、ADK 默认 OTEL tracing 稳步推进"生产运维基座"；AWS 本周无平台级新组件公告，重心在多租户身份治理(OBO/Gateway)、CLI 逼近 1.0、真实客户落地(KTern/Bluesight/Thrad)与旧 Agents Classic 7/30 日落。

2. **三方战略趋同：都在抢"框架无关的中立托管运行时"。** AWS AgentCore "any framework/any model"、Google ADK "model-agnostic" + Agent Engine、微软 Foundry Agent Service 明确收编 Agent Framework/Copilot SDK/LangGraph/OpenClaw/Hermes。谁都不想把自己绑死在单一框架，而是争当"agent 上生产的底座层"。竞争焦点从"框架好不好用"转向"运行时的身份/安全/可观测/长时任务韧性/合规区域"。

3. **差异化护城河各不同：** 微软=分发渠道（M365 Copilot/Teams 直达十亿级企业用户）+ OpenAI 前沿模型独家；Google=开放护城河（A2A 24.8k★ + ADK 20.6k★ 双开源标准）+ Gemini 自研模型；AWS=企业身份治理深度（OBO/RFC8693/Gateway interceptors）+ Strands 生态 + Payments(Coinbase/Stripe) 差异化组件。

4. **框架整合完成时刻：** 微软 AutoGen 已冻结(last push 2026-04-15)、能力并入 Agent Framework(12k★)；印证 2026 年 agent 开源框架进入"少数几家收口"阶段（Agent Framework / Google ADK / AWS Strands 三足）。

5. **共同主线=从实验到生产。** 三家本周关键词高度重合：长时任务韧性(微软 resilient task/AWS harness/Google 会话持久)、结构化记忆(Google Memory profiles/AWS Memory)、可观测性(Google 默认 OTEL/微软 online eval)、身份合规(AWS OBO/微软 VNet+私有 ACR/Google SGP)。2026 下半年竞争主战场已明确是"生产级可运维性"，而非模型或框架本身。

---

# B 组 · 模型厂商 Agent 平台 + 通用框架

### 4. OpenAI Responses API + Agents SDK（含 Swarm 谱系 / AgentKit）

- **本周动态**：本周 OpenAI Agents SDK 迭代极密，Python 与 JS 两条线均有多个 release 落在窗口内。**Python SDK**：v0.18.1（2026-07-09 23:38 UTC）、v0.18.2（2026-07-11 01:07 UTC）连发（v0.18.0 于 07-07 略早于窗口，作背景）。最关键的一条是 v0.18.2 中的 **`feat: add hosted multi-agent beta support`（PR #3788）**——这是把「多智能体编排」从纯客户端库能力抬升为 **OpenAI Responses 托管侧能力**的信号：PR 原文说明为「adds experimental OpenAI Responses **hosted multi-agent support over WebSocket**, including local function-tool injection, hosted-agent attribution, normalized output handling」，并指向新 API 指南 `developers.openai.com/api/docs/guides/tools-multi-agent`。即多智能体协作可由 OpenAI 服务端通过 WebSocket 托管运行，本地只需注入 function-tool，路线上与 Swarm→Agents SDK→托管化的谱系一脉相承，等于把当年 Swarm 的实验性 handoff 编排收编进 Responses 平台侧。同时 v0.18.1/v0.18.2 完成了对 **GPT-5.6 的默认模型迁移与 request controls 支持**（PR #3774 add GPT-5.6 model defaults、#3794 support GPT-5.6 request controls），并大量强化 **Sandbox Agents**（v0.18.0 引入的 beta 特性区，本周继续 own Daytona/Docker/Unix PTY 清理任务、E2B/Runloop rclone 共享等，见 #3778/#3779/#3780/#3798/#3799）。**JS SDK** 同样高频：v0.13.1（07-09）、v0.13.2（07-10）、v0.13.3（07-13）、v0.13.4（07-15）四连发，含 invalid final output recovery handler、恢复会话历史 system messages 等修复。背景补充：AgentKit（含 Agent Builder）于 2025-10-06 发布，但 **Agent Builder 与 Evals 已于 2026-06-03 宣布终止**（背景，非本周），官方引导迁移至 ChatKit Python SDK——说明 OpenAI 正在收敛可视化编排层、把重心压回 Responses API + Agents SDK + 托管多智能体的代码路径。
- **关键数据**：
  - openai-agents-python Stars ≈ **27,934**（https://github.com/openai/openai-agents-python 取数 2026-07-16）
  - Python v0.18.2 published **2026-07-11**（https://github.com/openai/openai-agents-python/releases/tag/v0.18.2）
  - Python v0.18.1 published **2026-07-09**（同上 releases 页）
  - JS v0.13.4 published **2026-07-15**（https://github.com/openai/openai-agents-js/releases）
- **原文链接**：
  - https://github.com/openai/openai-agents-python/releases（web_fetch 读全文）
  - https://github.com/openai/openai-agents-python/pull/3788（web_fetch 读 PR body 全文）
  - https://api.github.com/repos/openai/openai-agents-python/releases（取 published_at）
- **影响判断**：hosted multi-agent over WebSocket 是本周最强信号——OpenAI 正把多智能体编排从「开发者库」上抬为「平台托管服务」，与 Anthropic Managed Agents、LangGraph Platform 托管化形成同一方向的竞争。GPT-5.6 全线默认化说明模型-框架耦合进一步加深，第三方模型接入虽仍支持但一等公民始终是自家模型。Agent Builder 被砍则表明可视化 no-code 编排在 OpenAI 内部优先级下降，代码优先 + 托管运行时是既定路线。

---

### 5. Anthropic Claude Agent SDK + MCP（MCP 协议演进 / Claude Agent SDK / Computer Use）

- **本周动态**：本周 Anthropic 侧动态密集，分三条线。**（1）Claude Agent SDK（Python）**发布节奏极快，v0.2.116（07-11）、v0.2.117（07-14）、v0.2.118（07-14）、v0.2.119（07-14）、v0.2.120（07-15）五连发，全部落在窗口内。这些 release 的实质是**捆绑 Claude CLI（Claude Code）版本滚动升级**（bundled Claude CLI 2.1.207→2.1.211），即 Agent SDK 与底层 Claude Code 运行时深度绑定、同步演进。v0.2.117 含一条安全修复：用 `jq` 而非 bash 替换来转义 Slack issue 通知中的 issue 标题/用户名，防止 mrkdwn 注入（#1116）。底层 CLI 2.1.211 带来的重要能力包括：新增 `--forward-subagent-text` 标志与 `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT` 环境变量，把子智能体的文本与 thinking 纳入 stream-json 输出；修复权限预览未中和双向覆盖/零宽/仿冒引号字符（防止工具输入视觉篡改审批消息）——这是 agent 安全治理的实打实加固；改进后台 agent 结果上报（真实等待完成而非编造结果）；以及一批 Claude in Chrome（Computer Use 谱系）修复。**（2）Claude 产品侧（含 Computer Use / Cowork）**：官方 Release Notes 记录了 07-07「**Claude Cowork 上线 web 与 mobile**」（此前仅 desktop，先从 Max 计划分批推出），关键在于 **Cowork 会话"remotely（远程/托管）运行"**——会话与文件存到 Claude 账户、跨设备可用、关掉笔记本仍继续、定时任务无设备在线也能跑，这是把 agent 执行托管化的产品级体现；同日「**Microsoft 365 connector 新增 write 工具**」（可起草/发送/组织邮件、管日历、改邮箱设置、在 OneDrive/SharePoint 建改文件，需 Entra 管理员授权）。07-09 上线 monthly recap/Reflect（beta，需开 memory）；07-14「**HIPAA 配置转为自助**」（Enterprise 与 API 均可自助审 BAA 并启用），这是企业合规化的重要一步。**（3）MCP 协议**：需强调时间边界——MCP 官方博客关于「**2026-07-28 规范 Release Candidate**」「Enterprise-Managed Authorization 转 stable」「SDK betas」等重磅内容日期均为 **2026-07-28，落在本周窗口之外**（背景/roadmap，非本周），本周 MCP 无落在 07-09→07-15 的独立正式发布。该 RC 方向是「stateless core（去掉 initialize 握手与协议级 session，可用普通 round-robin 负载均衡横向扩展）+ Tasks 长任务扩展 + MCP Apps 服务端渲染 UI + 更贴近 OAuth/OIDC 的授权 + 正式弃用策略」，值得下期重点跟踪。
- **关键数据**：
  - claude-agent-sdk-python Stars ≈ **7,641**（https://github.com/anthropics/claude-agent-sdk-python 取数 2026-07-16）
  - Claude Agent SDK v0.2.120 published **2026-07-15**，bundled Claude CLI 2.1.211（https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.120）
  - Claude Cowork web+mobile 与 M365 write 工具：**2026-07-07**（https://support.claude.com/en/articles/12138966-release-notes）
  - HIPAA 自助配置：**2026-07-14**（同上 Release Notes）
  - 背景：MCP 2026-07-28 RC / EMA stable（https://blog.modelcontextprotocol.io/ ；日期 07-28，非本周）
- **原文链接**：
  - https://support.claude.com/en/articles/12138966-release-notes（web_fetch 读全文，取 07-07/07-09/07-14 条目）
  - https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md（web_fetch 读 CLI 2.1.211 全文）
  - https://github.com/anthropics/claude-agent-sdk-python/releases（web_fetch + API 取 published_at）
  - https://blog.modelcontextprotocol.io/（web_fetch，确认 MCP 大改在 07-28 窗口外）
- **影响判断**：本周 Anthropic 的关键词是「托管化 + 企业合规 + agent 安全治理」。Cowork 远程运行会话把「agent 执行」变成账户级托管服务，与 OpenAI hosted multi-agent、LangGraph Platform 同向；M365 write 工具与 HIPAA 自助反映其正加速攻企业市场。Agent SDK 与 Claude Code CLI 强绑定、周更五版，说明 Anthropic 把 SDK 定位为 Claude Code 运行时的对外接口而非独立框架。MCP 大改虽在窗口外，但 stateless 化将显著降低 MCP server 的运维门槛，是下期最值得盯的协议级变量。

---

### 6. LangChain / LangGraph / LangSmith Deployment（Platform 托管化 / LangSmith 可观测 / Deployment 形态）

- **本周动态**：LangChain 本周动态非常丰富，横跨博客、开源 release 与 SaaS changelog 三线。**（1）产品品牌与形态**：官方产品导航已把体系重构为「Agent Improvement（Engine/Observability/Evaluation）+ Agent Infrastructure（**Deployment**「Ship and scale agents in production」/ **Sandboxes**「Run agent-generated code safely」）+ No-Code Agents（**Fleet**「Agents for the whole company」）+ 开源框架（deepagents/langgraph/langchain）」。重要背景：**LangGraph Platform 已更名为 LangSmith Deployment、LangGraph Studio 更名为 LangSmith Studio**（见 LangSmith changelog 顶部说明），即把托管部署与可观测统一收进 LangSmith 品牌伞下。**（2）本周博客（均在窗口内）**：07-15「**New in LangSmith Fleet：一键把 agent 接入 Slack**」（Fleet 是面向全公司的 no-code agent 层，主打企业内部把 agent 直接嵌入 Slack）；07-15「**Agents need their own computer. Here's how to give them one safely.**」（对应 **LangSmith Sandboxes**——为 agent 提供隔离的临时锁定环境跑不可信代码，Private Preview，与 LangSmith Deployment 直接集成，可给 agent thread 挂 sandbox；内部用于 Open SWE）；07-14「**Your coding agents are a black box. Here's how to crack them open.**」（可观测/LangSmith 面向 coding agent 的追踪）；07-10「**Introducing OpenWiki Brains, general-purpose wiki memory for agents**」（面向 agent 的通用 wiki 记忆）。背景（窗口边缘 07-07/07-08，非本周核心）：07-08 LangChain × NVIDIA 推「NemoClaw Deep Agents Blueprint」及 Nemotron 3 Ultra playbook；07-07 Schneider Electric 用 LangSmith 建企业级 LLMOps 的客户案例。**（3）开源 release（窗口内）**：langgraph **1.2.9**（2026-07-10 01:30 UTC，修 updateState metadata/counters for delta channel #8315）、langgraph-cli **0.4.31**（2026-07-10 22:58 UTC）；1.2.8 于 07-06 略早。**（4）LangSmith Cloud changelog**：标注「July 6-10, 2026」（RSS 标题 2026-07-13），本周为 observability/evaluations 大批打磨——如 `POST /v2/datasets/{dataset_id}/experiment-runs` 成为分页实验对比的官方公开 API（旧 dataset comparison helper 从公开 OpenAPI 与生成 SDK 移除）；`/runs/rules/validate` 新增支持 thread evaluators（传 `test_thread_id`+`session_id` 可在保存前对真实多轮对话测评估器）；每 workspace 可复用 evaluator 数量设上限防资源膨胀；自托管经 SSO/OAuth cookie 鉴权的实验对比视图修复等。
- **关键数据**：
  - langgraph Stars ≈ **37,377**；langchain Stars ≈ **141,865**（https://github.com/langchain-ai 取数 2026-07-16）
  - langgraph 1.2.9 published **2026-07-10**（https://github.com/langchain-ai/langgraph/releases）
  - langgraph-cli 0.4.31 published **2026-07-10**（同上）
  - LangSmith Cloud changelog「July 6-10, 2026」（RSS 2026-07-13）（https://docs.langchain.com/langsmith/changelog）
  - 博客 07-15 两篇 / 07-14 一篇 / 07-10 一篇（https://www.langchain.com/blog）
- **原文链接**：
  - https://www.langchain.com/blog（web_fetch 读全文，确认各文日期）
  - https://docs.langchain.com/langsmith/changelog（web_fetch 读 July 6-10 全文）
  - https://www.langchain.com/blog/introducing-langsmith-sandboxes-secure-code-execution-for-agents（web_fetch 读 Sandboxes 产品细节全文）
  - https://api.github.com/repos/langchain-ai/langgraph/releases（取 published_at）
- **影响判断**：LangChain 的战略已从「开源编排框架」清晰转向「**LangSmith 一体化 agent 平台**」：Deployment（托管运行）+ Sandboxes（安全执行不可信代码）+ Fleet（企业 no-code + Slack 分发）+ Observability/Eval 构成完整闭环，把 LangGraph Platform/Studio 全部并入 LangSmith 品牌是这一整合的标志。本周 Sandboxes 与「给 agent 一台自己的电脑」直指 OpenAI Sandbox Agents、Anthropic Cowork 同一战场——安全隔离的 agent 代码执行正成为平台标配。Fleet 一键接 Slack 则是抢企业内部分发入口。可观测侧对 coding agent 与多轮 thread evaluator 的加强，说明评测正从单轮向长程 agent 轨迹演进。

---

### 7. CrewAI AMP（CrewAI 平台化 / Enterprise / CrewAI Studio）

- **本周动态**：CrewAI 本周**无落在 07-09→07-15 的正式发版**（最近一个正式 release 是 v1.15.2，publish 于 2026-07-08，恰在窗口前一天，作背景/近旁参照），但主干（main）在窗口内有**活跃的 15 次 commit（2026-07-09→2026-07-15）**，方向集中在企业级 agent 运行时治理：**（1）执行钩子/拦截点重构**——新增 execution-boundary interception points（#6517）、通用 interception-hook dispatcher（#6516）、step interception points 并重写 execution hooks 文档（#6548、07-14/07-15），修复 `after_llm_call` 钩子不再破坏原生工具执行（#6531）；这类「在 agent 执行边界插入拦截/审批」的能力是 AMP 平台侧做 governance / 审计 / policy enforcement 的底座。**（2）成本与用量可观测**：per-call usage metrics 报到 kickoff 结果（#6506）、token usage 同时以两个名字暴露在 agent/crew 结果上（07-10），呼应 v1.15.2 文档中新增的「**Cost Limit rule type in Agent Control Plane**」——即 AMP 控制面正在把「成本上限」做成可配置策略。**（3）平台/仪表盘品牌调整**：v1.15.2 文档明确「将措辞由 **Rules 改为 Policies 以匹配新 dashboard 变化**」，说明 AMP 控制台在做 Rules→Policies 的概念统一。**（4）Flow/CLI 打磨**：declarative flows 可在 TUI 无头终端跑（07-10）、修复 flow 重放上一轮 intent、tool-result 缓存由默认开改为 **opt-in（破坏性变更）**（07-11）等。综合来看，CrewAI 本周是「平台治理底座 + 成本可观测 + Flow 声明式化」的持续打磨，无重磅平台发布。背景（非本周）：v1.15.2（07-08）已引入 dynamic 拉取最新 LLM 模型、inline skill 定义、Flow Definition 授权 skill、stream frame protocol；更早 2026-02 CrewAI 曾发《The state of agentic AI in 2026》调研（称 500 名高管中 100% 计划 2026 扩大 agentic 采用）——属营销背景，非本周。
- **关键数据**：
  - crewAI Stars ≈ **55,591**（https://github.com/crewAIInc/crewAI 取数 2026-07-16）
  - 最近正式 release v1.15.2 published **2026-07-08**（窗口前一天）（https://github.com/crewAIInc/crewAI/releases/tag/1.15.2）
  - 窗口内 main commit 数 = **15**（2026-07-09→2026-07-15）（https://api.github.com/repos/crewAIInc/crewAI/commits）
  - 关键 commit：interception points #6516/#6517、per-call usage #6506、tool caching opt-in（07-11）
  - AMP 文档：Cost Limit rule / Rules→Policies（https://docs.crewai.com/en/changelog）
- **原文链接**：
  - https://docs.crewai.com/en/changelog（web_fetch 读全文，取 v1.15.2 / Agent Control Plane 条目）
  - https://api.github.com/repos/crewAIInc/crewAI/commits（取窗口内 commit 列表与日期）
  - https://github.com/crewAIInc/crewAI/releases/tag/1.15.2（web_fetch/API 读 release body 全文）
- **影响判断**：CrewAI 本周虽无正式发版，但代码走向清楚指向「**AMP（Agent Control Plane）企业治理**」：执行拦截点 + Cost Limit 策略 + Rules→Policies 统一，都是为在企业里对 agent 做审批、审计、成本封顶铺路——与 LangSmith、Anthropic 企业化同赛道。相较 OpenAI/Anthropic 的「托管运行时」路线，CrewAI 更强调「开源框架 + 可自托管的控制面/策略层」，差异化在 governance 与 Flow 声明式编排。无重磅发布也说明其平台化处于持续迭代而非里程碑期。

---

## 本组洞察

**本周 B 组的主线是「agent 执行的托管化 + 安全隔离 + 企业治理」三重收敛。** 四家在同一方向发力却路径分化：OpenAI 用 `hosted multi-agent over WebSocket`（Agents SDK v0.18.2）把多智能体编排上抬为 Responses 平台侧托管服务，并同步砍掉可视化 Agent Builder，走「代码优先 + 托管运行时 + 自家模型深绑（GPT-5.6）」；Anthropic 用 Cowork 远程会话 + Claude Code CLI 强绑定 + HIPAA 自助 + M365 write 工具，走「产品级托管 + 企业合规」；LangChain 把 LangGraph Platform/Studio 并入 LangSmith，用 Deployment + Sandboxes（安全跑不可信代码）+ Fleet（企业 no-code/Slack 分发）+ Observability 拼一体化平台；CrewAI 则在 AMP 控制面深耕执行拦截点、Cost Limit 策略与 Rules→Policies 治理，坚持「开源 + 可自托管控制面」的差异化。**协议生态方面**，MCP 的大改（stateless core、Tasks、MCP Apps、EMA 转 stable）虽落在本窗口之外（2026-07-28），但已释放明确信号：MCP 将去 session 化以便普通负载均衡横向扩展，且企业级授权（EMA，Anthropic/Microsoft/Okta 采用）成为标配——这是下期最值得跟踪的协议级变量。**框架托管化走向**已基本定局：纯客户端编排库正整体让位于「平台托管运行时 + 安全沙箱 + 可观测/成本治理」的一体化 agent 平台，而安全隔离（Sandbox/Cowork/Sandbox Agents）与成本+权限治理（Cost Limit/Policies/EMA）是四家共同押注的下一个竞争焦点。


---

# C 组 · 数据 / 开源 / 中国 Agent 平台

### Databricks Mosaic AI / Agent Bricks
- 本周动态：Databricks 在本周（7/9–7/15）保持了 DAIS 2026（6 月中旬）后的高密度产品博客节奏，本周确有多篇官方新内容落地，属于 Agent Bricks 平台"发布后填坑"阶段的持续兑现：①**7/15 — Inkling model from Thinking Machines Lab now on Databricks**：Thinking Machines Lab（Mira Murati 团队）的 Inkling 模型上线 Databricks 模型目录，进一步兑现 Agent Bricks"任意模型（any model）"的选择维度承诺——此前 DAIS 已宣布 OpenAI/Anthropic/Gemini/Qwen/Kimi(Moonshot)，并与 SpaceX 合作将 Grok 原生接入。②**7/14 — Genie One on mobile（iOS/Android GA）**：将 6 月 GA 的"数据智能 AI 同事"Genie One 扩展到移动端，全量体验（chat、dashboards、Databricks Apps、skills、MCP）随行，接入 Google Drive/Microsoft 365/Atlassian 外部连接器，权限经 Unity Catalog / source-native ACL 强制；客户 Etihad（阿提哈德航空）站台背书。③**7/14 — Blocking Slow-Burn Attacks: Contextual Policies in Omnigent（Cybersecurity）**：延续 7/7 的 Omnigent 上下文策略文章，演示"慢烧攻击（slow-burn）"——把恶意目标（如外泄客户名单）拆成 read_runbook→read_document→send_report 等单步看似合规的动作，绕过逐动作 guardrail；Omnigent 的 contextual policy 是有状态的（stateful），跟踪整个 session 的历史事件，可 allow/deny/人工审批/改写动作，成功在同一攻击下"无策略被攻破、单条上下文策略拦截"。这是 Databricks 把 Agent 治理从"单点授权"升级到"会话级行为审计"的关键技术叙事。背景（非本周）：Agent Bricks 于 DAIS 2026（6/16 前后）从"Agent 构建实验"升级为完整开发者 Agent 平台，累计 100k+ agents、年处理 1+ quadrillion tokens，客户含 AstraZeneca、7-Eleven、Fox、Block；开源元框架 Omnigent（Apache 2.0，repo: github.com/omnigent-ai/omnigent）于 6/16 前后开源，托管版在 Databricks Beta，受 Unity AI Gateway 治理。
- 关键数据：
  - Inkling(Thinking Machines Lab)上线：https://www.databricks.com/blog/inkling-thinking-machines-lab-now-databricks（2026-07-15）
  - Genie One mobile GA：https://www.databricks.com/blog/take-insights-anywhere-genie-one-mobile（2026-07-14）
  - Omnigent 慢烧攻击防护：https://www.databricks.com/blog/blocking-slow-burn-attacks-contextual-policies-omnigent（2026-07-14）
  - 背景：100k+ agents、1+ quadrillion tokens/年（Agent Bricks DAIS 2026 blog，2026-06-16 前后）
  - Omnigent repo: https://github.com/omnigent-ai/omnigent（Apache 2.0，PyPI: omnigent）
- 原文链接：
  - https://www.databricks.com/blog/take-insights-anywhere-genie-one-mobile
  - https://www.databricks.com/blog/blocking-slow-burn-attacks-contextual-policies-omnigent
  - https://www.databricks.com/blog/agent-bricks-dais-2026（背景）
  - https://github.com/omnigent-ai/omnigent
- 影响判断：Databricks 的差异化正从"模型/框架任意选"转向"数据+治理护城河"。本周三条动态分别对应选择（Inkling 模型接入）、场景渗透（Genie One 移动端把 Agent 推到业务一线）、治理深度（Omnigent 会话级上下文策略）。尤其 slow-burn 攻击防护是当前 Agent 安全领域少有的、把"多步组合攻击"作为一等公民治理的公开工程叙事，对企业级 Agent 采购决策有实质影响——这是 Databricks 对抗 Snowflake/云厂商 Agent 平台的核心卖点。

---

### Dify（开源 LLM 应用/Agent 平台）
- 本周动态：**本周 Dify 有重磅版本动作——7/9 发布 v1.16.0-rc1（预发布/pre-release），核心是首次实验性推出「Dify Agent（Experimental）」，标志 Dify 从"工作流编排平台"正式切入 shell-based / code-execution Agent 赛道。** 官方 release note（GitHub，2026-07-09T14:06 UTC）明确定位："shell-based LLM agent 范式带来了 Agent 能力的重大飞跃……结合 Skills 标准化封装分发能力"，并"像其他主流 Agent 一样在 Linux sandbox 中运行"。本次 RC 包含三大能力：①**Dify Agent Builder**——UI 内设 base prompt、上传 Skills 与文件、接入 Dify 生态的工具与知识库；同时提供一个"用于构建 Dify Agent 的 Agent"，通过对话配置 Linux sandbox 环境、安装依赖包、创建 Skills 与文件。②**Dify Workflow 集成**——可在工作流节点内调用已有 Dify Agent 或临时创建 inline Agent，执行任务并把输出传给下一节点。③**新 Web App 体验**——构建的 Dify Agent 可发布为 web app。官方明确标注重大安全限制："当前实验版所有 Dify Agent 共享同一 sandbox……任一 Agent 可读取或干扰其他 Agent 环境与用户数据，严格隔离将在未来版本实现"，并两次强调"仅面向可信、非恶意用户提供服务"。此外本次含数据库迁移（需在升级时执行）。这是继 Anthropic Claude Code、字节 Coze Studio 等之后，开源阵营对"shell/沙箱执行型 Agent + Skills"范式的又一次跟进，路线上明显对标当前主流 coding/general agent 形态。GitHub Stars 达 **148,973**、Forks 23,461（github.com/langgenius/dify，截至 2026-07-16 实时读取），仍是开源 LLM 应用平台 Stars 第一梯队。前序稳定版为 1.15.0（2026-06-25）。
- 关键数据：
  - v1.16.0-rc1 发布：2026-07-09（GitHub release，pre-release）https://github.com/langgenius/dify/releases/tag/1.16.0-rc1
  - Stars 148,973 / Forks 23,461 / open issues 966（GitHub API 实时，2026-07-16）https://github.com/langgenius/dify
  - 上一稳定版 1.15.0：2026-06-25（背景）
  - Dify Agent 文档：https://docs.dify.ai/en/self-host/use-dify/build/new-agent/overview
- 原文链接：
  - https://github.com/langgenius/dify/releases/tag/1.16.0-rc1
  - https://github.com/langgenius/dify/releases
  - https://github.com/langgenius/dify
- 影响判断：Dify Agent 是本季度 Dify 最重要的战略转向——从"低代码工作流/LLMOps 平台"扩张到"通用 shell 沙箱 Agent 运行时"，直接进入 Coze Studio、n8n AI、以及闭源 coding agent 的竞争带。采用 Skills 标准化封装 + Linux sandbox 的组合，说明开源社区正快速收敛到"沙箱执行 + 技能包"这一事实标准。但共享 sandbox、无严格隔离、明确"仅限可信用户"的限制说明其仍处早期实验，短期内难用于多租户 SaaS 生产。对企业自托管用户而言，这是一个值得跟踪但需谨慎上生产的能力。

---

### 字节 Coze / 扣子（ByteDance，coze.cn 国内版 + coze.com 海外版）
- 本周动态：**本周（7/9–7/15）Coze 的可核实公开动态集中在开源侧的持续工程维护，产品侧重大版本（3.0）属近期背景、非本周。** 具体本周动作：开源可观测项目 **coze-loop（github.com/coze-dev/coze-loop，Stars 5,611）本周有 3 次实质提交**，均在时间窗内，方向为 trace/可观测性增强：①7/10 `[feat][backend] trace time range config`（#577，新增 trace 时间范围配置）；②7/13 `[fix][backend] ignore CheckTraceBenefit error in expire error processor`（#578，过期错误处理器容错修复）；③7/15 `[feat][trace] parallelize span and annotation queries in GetTrace`（#582，GetTrace 中并行化 span 与标注查询，属性能优化）。这些提交显示字节仍在稳定投入 Coze Loop 的 Agent 观测/评测基础设施——这是企业级 Agent"可观测、可评估、可调优"链路的关键。另一核心开源项目 **coze-studio（Stars 21,171，Forks 3,080）本周在主分支无新提交**（上次 push 为 2026-04-20），近期以稳定期为主。**背景（非本周，供格局参考）**：①扣子于 2026-06-01 正式上线 **Coze 3.0**，从"单一 Agent 构建工具"进化为"开放、协同、全栈式 AI 应用开发平台"，主打"多人+多 Agent 协作"，可创建项目空间召集不同 Agent 协作，内置金融/自媒体/医疗/法律/科研行业技能包（来源：新浪财经/东方财富 2026-06-01/06-03）；②7/6（窗前）有第三方深度实测文章《实测扣子3.0：把 Claude Code、CodeX 拉到一个项目群里干活》，证实 3.0 支持把 Claude Code、Codex 等异构 coding agent 拉入共享上下文的项目空间协作分工；③国内商业化已成型，火山引擎下扣子采用"包年包月订阅+按量计费"混合模式，企业版 lite ¥4,731/月起（300 万资源点/月、2TB 知识库、200 万条/月 Trace）、企业旗舰版 ¥5,980/月（来源：扣子官方套餐页）；④2025-07-26 开源 Coze Studio + Coze Loop（Apache 2.0，可商用）；海外版 coze.com 与国内 coze.cn 双轨运营，海外主打无代码 bot 发布到 Telegram/Discord/LINE 等。
- 关键数据：
  - coze-loop 本周 3 次提交（7/10/#577、7/13/#578、7/15/#582），Stars 5,611（GitHub API 实时，2026-07-16）https://github.com/coze-dev/coze-loop
  - coze-studio Stars 21,171 / Forks 3,080，本周主分支无提交（GitHub API 实时，2026-07-16）https://github.com/coze-dev/coze-studio
  - 背景：Coze 3.0 上线 2026-06-01（新浪财经）https://finance.sina.com.cn/roll/2026-06-01/doc-inhzwyqi8410456.shtml
  - 背景：企业版 lite ¥4,731/月、企业旗舰版 ¥5,980/月（扣子官方套餐页）
- 原文链接：
  - https://github.com/coze-dev/coze-loop（本周提交直查）
  - https://github.com/coze-dev/coze-studio
  - https://finance.sina.com.cn/roll/2026-06-01/doc-inhzwyqi8410456.shtml（背景，3.0 上线）
  - https://finance.eastmoney.com/a/202606033758104260.html（背景，3.0 商业化解读）
- 影响判断：本周 Coze 无重大产品/融资/出海公开动态，但开源可观测层（Coze Loop）的持续迭代是重要信号——字节在把"Agent 可观测性/评测"当作长期基础设施投资，而非一次性开源公关。这与 Databricks（Unity AI Gateway/Omnigent 治理）、Dify（Agent 沙箱）形成同一趋势：2026 下半年 Agent 平台竞争的焦点正从"能不能搭 Agent"转向"能不能治理、观测、评估生产级 Agent"。Coze 的差异化在于国内最成熟的商业化闭环（火山引擎订阅+企业技能商店）叠加开源双轨，短期护城河稳固；需持续跟踪其 3.0 之后的下一次产品迭代节奏与海外 coze.com 的商业化进展。（本周判断：Coze 已充分覆盖，无遗漏；未见可核实的窗内重大产品发布，故不编造。）

---

### n8n / Flowise（开源 Agent IDE，动态对象池）
- 本周动态：**本周 n8n 命中"重大产品动态"纳入门槛——7/14–7/15 正式发布 n8n AI Assistant（内建工作流构建 Agent）。** 据 n8n 社区官方公告（community.n8n.io，2026-07-15）："We're launching the n8n AI Assistant, a new chat-based agent that lives right inside n8n and builds workflows for you from plain language. It can create, edit, test, and troubleshoot…"——即用自然语言在画布内直接生成/编辑/测试/排障工作流，先在 n8n Cloud 上线，同时（7/14）发布 self-hosted 早期接入说明（标注为 preview/early）。同期 GitHub 侧节奏密集：**7/14 发布 n8n@2.31.0、7/15 发布 n8n@2.31.1（beta）与 n8n@2.30.5（stable）**；2.31.0 changelog 明显围绕 Agent 能力打磨——含 `Agent Node: Fall back to guardrails input and hide auto prompt source without a chat trigger`（#33762）、`AI Agent Node: Remove assistant tool call redundant message and simplify chat tool response`（#33640）等多项 AI Agent 节点修复。n8n GitHub Stars 已达 **196,591**（实时，2026-07-16），是本组覆盖对象中 Stars 最高者。背景（非本周）：n8n 累计融资约 $180M；2026 年内先后推出 tool-level HITL（5月）、五个 prebuilt agents（随 1.107.0 引入）、model-agnostic 架构；有第三方提及"SAP $5.2B investment"背书其企业成熟度（未由 n8n 官方独立确认，仅作背景，需谨慎）。**Flowise**：本周无新版本发布（最新 flowise@3.1.3 为 2026-06-25，窗前），主分支仍有日常提交（pushed 2026-07-15），Stars 54,660（实时，2026-07-16）——本周一句带过，无重大动态。
- 关键数据：
  - n8n AI Assistant 发布：2026-07-14/15（n8n 社区官方公告）https://community.n8n.io
  - n8n@2.31.0（2026-07-14）/ 2.31.1、2.30.5（2026-07-15）https://github.com/n8n-io/n8n/releases/tag/n8n@2.31.0
  - n8n Stars 196,591（GitHub API 实时，2026-07-16）https://github.com/n8n-io/n8n
  - Flowise Stars 54,660，本周无新 release（最新 3.1.3=2026-06-25）https://github.com/FlowiseAI/Flowise
- 原文链接：
  - https://github.com/n8n-io/n8n/releases/tag/n8n@2.31.0
  - https://community.n8n.io（AI Assistant 公告与 self-hosted 早期说明）
  - https://github.com/FlowiseAI/Flowise/releases
- 影响判断：n8n AI Assistant 把"AI 帮你搭 AI 工作流"从竞品（Zapier、Make、Coze 编程 Vibe Coding）追平到自身画布内，是 n8n 从"工程师手动连节点"向"自然语言生成工作流"的关键跃迁，直接强化其对非技术用户的获取能力。结合本周 Agent Node 的多项打磨，n8n 正把"AI Agent 编排 + 自然语言构建"作为下一阶段主战场。Flowise 本周相对沉寂，节奏落后于 n8n/Dify，需观察其 3.x 后续是否跟进沙箱/Assistant 类能力。

---

## 本组洞察（开源 / 中国平台格局）

本周 C 组四对象共同指向一个清晰主题：**2026 下半年 Agent 平台竞争的分水岭已从"能否搭建 Agent"转向"能否治理、观测、评估、并用自然语言构建生产级 Agent"。** 三条主线：①**沙箱执行 + 技能包正在成为开源事实标准**——Dify（v1.16.0-rc1 的 shell/Linux sandbox Dify Agent + Skills）直接对标 Coze Studio 与闭源 coding agent，开源阵营快速收敛。②**治理/可观测是新护城河**——Databricks 用 Omnigent 会话级 contextual policy 防 slow-burn 攻击、字节持续投入 Coze Loop 的 trace/评测基础设施，都说明"单点授权"已不够，"会话级行为审计 + 可观测"成为企业采购的硬指标。③**自然语言构建工作流全面铺开**——n8n AI Assistant、Coze 编程 Vibe Coding 让"AI 搭 AI"平民化。格局上：n8n（196k stars）在开源 IDE 侧 Stars 与融资双领先；Dify（149k stars）以战略转向切入沙箱 Agent；字节 Coze 以国内最成熟的商业化闭环（火山引擎订阅+企业技能商店）+ 开源双轨稳守中国市场，本周虽无产品大动作但基础设施投入不停；Databricks 则以"数据+治理"差异化占据企业级高地。Flowise 本周相对掉队，是需要重点观察的对象。


