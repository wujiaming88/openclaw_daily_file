# Amazon Bedrock AgentCore 全景深度技术研究报告

> **研究日期**：2026-06-11　|　**研究员**：黄山（System Architect & Technology Researcher）
> **研究对象**：Amazon Bedrock AgentCore（AWS 企业级 AI Agent 运行时与工具平台）

---

## 🎯 TL;DR（一句话核心结论）

**AgentCore 是 AWS 为「Agent 时代」押注的云原生底座——它把 Agent 生产化所需的运行时、记忆、工具网关、身份、浏览器、代码沙箱、可观测七大基础设施做成了可独立计费、框架/模型完全中立的 serverless 模块，本质是要复刻当年 Lambda + 一众托管服务统治云计算的剧本，抢占「Agent 基础设施标准底座」的生态位。**

**给老板的一句话判断**：AWS 这步棋的本质不是做一个 Agent 框架，而是做 Agent 的「水电煤」——它故意不绑死框架和模型，赌的是无论上层框架战争谁赢，跑在生产环境的 Agent 都要落到它的运行时上付费。这是典型的 AWS 卖铲子战略，对 LangChain 这类中间层是降维打击，对创业公司既是基础设施红利也是被平台化的威胁。

---

## 目录

1. [它是什么 & 解决什么问题](#1-它是什么--解决什么问题)
2. [七大核心组件逐个深挖](#2-七大核心组件逐个深挖)
3. [框架与模型中立性](#3-框架与模型中立性)
4. [与 MCP / A2A 协议生态的关系](#4-与-mcp--a2a-协议生态的关系)
5. [安全、合规、企业级特性](#5-安全合规企业级特性)
6. [定价模型](#6-定价模型)
7. [竞争格局横向对比](#7-竞争格局横向对比)
8. [实战上手](#8-实战上手)
9. [趋势研判与洞察](#9-趋势研判与洞察)
10. [信息源清单](#10-信息源清单)

---

## 1. 它是什么 & 解决什么问题

### 1.1 定位与核心痛点

Amazon Bedrock AgentCore 是 AWS 推出的**企业级 agentic 平台**，官方定义为「a comprehensive set of enterprise-grade services that help developers quickly and securely deploy and operate AI agents at scale using any framework and model, hosted on Amazon Bedrock or elsewhere」（来源：AWS News Blog 预览公告）。

它要解决的核心痛点，AWS 官方博客讲得很直白：开发者想做 Agent，却被迫**花几个月去搭地基**——session 管理、身份控制、记忆系统、可观测性，同时还要满足安全合规。结果是大量 Agent 卡在「原型炼狱」（prototype purgatory），demo 跑得很漂亮，但永远上不了生产。

> 原文：「Instead of being able to focus on the core features of the agent, developers and AI engineers have to spend months building foundational infrastructure for session management, identity controls, memory systems, and observability—at the same time supporting security and compliance.」（AWS News Blog）

AgentCore 的解法：把这些「地基」全部做成**全托管、可独立使用、可组合**的 serverless 服务，让开发者只写 Agent 业务逻辑，几行代码部署到生产。

### 1.2 与旧版 Bedrock Agents 的区别（关键澄清）

这是最容易混淆的点。AgentCore **不是**旧的 Bedrock Agents（managed agent）的升级版，两者是**不同的产品和计费模型**（来源：cloudburn.io 深度拆解）：

| 维度 | 旧版 Bedrock Agents（legacy） | Bedrock AgentCore |
|------|------------------------------|-------------------|
| 本质 | 一个**编排层**（orchestration layer） | 一个**全栈托管平台**（full-stack platform） |
| 计费 | 按 FM 推理 token 计费，无 Runtime/Memory/Gateway 单元 | 12 个独立计费组件 |
| Cost Explorer 标识 | `bedrock:InvokeAgent` / `AmazonBedrock` | `AmazonBedrockAgentCore` |
| 框架 | 锁定 AWS 自家编排 | 任意开源框架（CrewAI/LangGraph/...） |
| 模型 | Bedrock 内模型 | 任意模型，Bedrock 内外皆可（含 OpenAI/Gemini） |
| 定位 | 简单、可预测 | 覆盖 Agent 全生命周期：执行/隔离/记忆/工具/身份/可观测/策略/评估 |

**关系判断**：互补 + 演进替代。旧版 Agents 仍在（适合极简场景），但 AWS 的战略重心和未来投入明显押在 AgentCore 上——它是为「任意框架 + 生产级 + 企业合规」这个真实战场设计的。

### 1.3 发布时间线 & 可用性

- **2025-07-16**：preview 发布（AWS Summit New York 2025，News Blog 由 Danilo Poccia 撰写）
- **2025-10-13**：正式 GA（general availability）—— 来源：AWS What's New 公告 + ML Blog GA 文 + cloudburn.io 交叉验证
- **当前可用区域（9 个）**：US East（N. Virginia / Ohio）、US West（Oregon）、Asia Pacific（Mumbai / Singapore / Sydney / Tokyo）、Europe（Frankfurt / Ireland）
- GA 时新增能力：全服务支持 VPC、AWS PrivateLink、CloudFormation、resource tagging；Runtime 支持 A2A 协议；Gateway 可连现有 MCP server 并支持 IAM 授权

> **采用规模信号（官方口径，注意是营销数据）**：AgentCore SDK 下载量「超过 100 万次」；早期客户包括 Clearwater Analytics、Cox Automotive、Druva、Ericsson、Experian、Heroku、National Australia Bank、Sony、Thomson Reuters 等（来源：AWS ML Blog GA 文）。

---

## 2. 七大核心组件逐个深挖

AgentCore 由一组**可组合、可独立使用**的模块化服务构成。GA 时官方核心是 7 大组件，GA 后又陆续追加了 Policy、Evaluations、Agent Registry、Payments、Optimization 等（cloudburn.io 统计已达 12 个计费组件）。以下逐个拆解 7 大核心。

### 2.1 AgentCore Runtime（无服务器运行时）—— 平台心脏

- **是什么**：purpose-built 的 secure、serverless 运行时，专门用来部署和扩展 Agent 与工具。支持两种部署模式：**direct code deployment**（快速迭代）和 **container-based deployment**（最大控制）。
- **解决什么**：Agent workload 时长高度不可预测，传统 compute 要么预留资源浪费钱，要么扛不住突发。Runtime 自动从 0 扩到数千 session。
- **关键能力**：
  - **业界领先的 8 小时执行窗口**（eight-hour execution windows）——支持超长异步任务（多源交叉验证：AWS What's New + LinkedIn + Medium 多篇实测均确认 up to 8 hours）
  - **完整 session 隔离**：每个 session 跑在独立的 **microVM** 里，物理级隔离防数据泄漏（来源：AWS ML Blog GA 文明确 "microVM technology, giving each agent session its own isolated computing environment"）
  - 快速冷启动（fast cold starts）
  - 用 `runtimeSessionId` 维持跨调用上下文
  - 内嵌 Identity（embedded identity）
  - GA 后新增：支持 **A2A 协议**、interactive shell sessions（持久终端访问）、与 AWS Step Functions 原生集成
- **怎么用**：通过 bedrock-agentcore SDK + starter toolkit / agentcore CLI，几行代码 + 一条 CLI 命令即可部署；底层跑在容器（Docker）上。
- **限制/定价**：按 active CPU + peak memory 计费（详见第 6 节）；最长 8 小时；128MB 最小内存计费。

### 2.2 AgentCore Memory（记忆系统）

- **是什么**：托管记忆服务，免去开发者自建记忆基础设施。
- **两层记忆**：
  - **短期记忆（short-term）**：会话内上下文，按「raw events 创建数」计费
  - **长期记忆（long-term）**：跨会话的语义/事实记忆，按「处理并存储的 memory records 数 + 检索调用数」计费
- **托管 vs 自管**：GA 新增 **self-managed strategy**——既可用 built-in memory strategies（自动处理），也可用 configurable strategies，在你自己账户里用你选的 model 和 prompt 跑提取/整合 pipeline，完全掌控记忆抽取与固化流程。
- **典型场景**（官方举例）：销售支持 Agent 跨多轮对话记住客户行业、预算、技术需求，避免重复提问；技术排障 Agent 记住此前调试尝试及结果。
- **定价**：短期按 create event 请求；长期存储按 stored record 小时计费；长期检索按 retrieve 请求。

### 2.3 AgentCore Gateway（工具网关）—— MCP 的核心载体

- **是什么**：把现有 **API、AWS Lambda 函数转成 Agent 可用的工具**，并能**连接现有 MCP server**，作为 Agent 发现和使用工具的单一安全端点。
- **解决什么**：免去为每个工具写自定义集成；统一鉴权和工具发现。
- **关键能力**：
  - 将 REST API / Lambda → MCP tools（一篇 dev.to AWS Heroes 系列文专门演示了 "Exposing existing Amazon API Gateway REST API via MCP" 和 "Exposing existing AWS Lambda function via MCP"）
  - 第三方业务工具开箱集成：**Jira、Asana、Zendesk** 等（来源：ML Blog GA 文）
  - 语义搜索（semantic search）做工具发现
  - GA 后新增：**IAM 授权**（除 OAuth 外）、**MCP Sessions**（有状态会话，初始化时返回 `Mcp-Session-Id`，可跟踪 downstream MCP target session 及 elicitation/sampling 交互）
- **定价**：按 MCP 操作数（ListTools、CallTool、Ping）、search queries、语义搜索索引的工具数计费；出口到客户 VPC 收 $0.006/GB 数据处理费。

### 2.4 AgentCore Identity（身份与访问委托）

- **是什么**：简化 Agent 的身份与访问管理，让 Agent 安全地代表用户或自身访问 AWS 资源和第三方工具。
- **关键能力**：
  - OAuth 标准；与主流 IdP 集成：**Amazon Cognito、Microsoft Entra ID、Okta**，及 Google、GitHub 等 OAuth provider（来源：Strands Agents 官方文档）
  - **代用户调用第三方**（act on behalf of users）with pre-authorized user consent
  - GA 后新增：identity-aware authorization、refresh token 的 secure vault storage、更多 OAuth 服务原生集成
  - 第三方生态：Auth0 已出专门的 AgentCore 集成指南（Auth0 blog）
- **定价**：**通过 Runtime 或 Gateway 使用 Identity 不额外收费**；独立使用时按 OAuth token / API key 请求数计费。

### 2.5 AgentCore Browser（云端托管无头浏览器）

- **是什么**：fast、secure、cloud-based 浏览器运行时，让 Agent 大规模与网站交互（网页自动化操作）。
- **关键能力**：托管无头浏览器；Browser Profiles（持久化 cookies、local storage 等 profile 工件，存 S3，2026-04-15 起按 S3 标准费率计费）。
- **定价**：与 Runtime 同模型——active vCPU-hour + peak GB-hour；官方 worked example 用 2 vCPU / 4 GB。

### 2.6 AgentCore Code Interpreter（沙箱代码执行）

- **是什么**：让 Agent 在隔离 sandbox 里安全生成并执行代码，提升准确性、扩展解决端到端复杂任务的能力。
- **关键能力**：支持 **Python、JavaScript、TypeScript** 执行（来源：cloudburn.io）；隔离沙箱环境；官方 blog（2025-08-06 ML Blog 专文）介绍其设计。
- **重要架构约束**（实测踩坑，来源 hidekazu-konishi）：不能从 Code Interpreter 内部调用 MCP 工具（architectural constraint）。
- **定价**：与 Runtime 同模型，按秒计费、取每秒 CPU/内存最高水位、1 秒最小计费；官方示例 2 vCPU / 8 GB。

### 2.7 AgentCore Observability（可观测性）

- **是什么**：给开发者对 Agent 工作流的完整可见性，用于 trace、debug、监控生产环境 Agent 行为。
- **关键能力**：
  - 由 **Amazon CloudWatch** 驱动，实时 dashboard + 详细审计轨迹（audit trails），CloudWatch GenAI Observability 页面
  - **OpenTelemetry（OTEL）兼容**，需用 **AWS Distro for OpenTelemetry（ADOT）SDK** 埋点
  - 无缝集成外部可观测平台：**Dynatrace、Datadog、Arize Phoenix、LangSmith、Langfuse**
  - 内置 metrics 覆盖 runtime、memory、gateway、built-in tools、identity 资源类型
- **定价**：telemetry 数据进 CloudWatch，按 CloudWatch 费率 pass-through（ingestion + storage + query + PII 脱敏）。

> ⚠️ **成本陷阱提醒**（来源：Dipayan Das Medium「$6,500 telemetry line」）：Observability 的 CloudWatch pass-through 计费容易被低估，曾有团队遭遇意料外的 telemetry 账单。

### 2.8 GA 后追加组件（补充）

- **Policy**：用 Cedar 策略控制 Agent 行为边界，支持自然语言生成 Cedar 策略；按授权请求 + 授权 token 计费。
- **Evaluations**：持续评估 Agent 质量（正确性、有用性、安全性）；按 1000 token（built-in）或 1000 runs（custom）计费。
- **Agent Registry**（preview，免费）、**Payments**（preview）、**Optimization**（preview，免费）。

---

## 3. 框架与模型中立性

这是 AgentCore 最重要的战略选择，也是它区别于旧版 Bedrock Agents 的根本。

### 3.1 框架中立（官方明确支持清单）

官方反复强调「any framework」，明确点名支持（来源：AWS What's New + ML Blog GA 文）：

- **Strands Agents**（AWS 自家开源 SDK）
- **LangGraph / LangChain**
- **CrewAI**
- **LlamaIndex**
- **Google ADK**（Agent Development Kit）
- **OpenAI Agents SDK**
- AutoGen 等其他开源框架亦可（Runtime 不关心你用什么框架）

> 核心理念（ML Blog 原文）：「The agent landscape is evolving rapidly, with new frameworks, models, and protocols emerging almost weekly. You can build the way you want with composable AgentCore services.」AgentCore 本质是**基础设施**，不在乎你上层用什么框架（aiechoes 实测博客印证："AgentCore is infrastructure—it doesn't care what agent framework you use"）。

### 3.2 模型中立（真中立，含非 Bedrock 模型）

**是真模型中立**。官方明确：可用 Amazon Bedrock 内的模型，也可用 **Bedrock 之外的模型，包括 OpenAI 和 Gemini**（来源：ML Blog GA 文 "models available outside Bedrock including OpenAI and Gemini"）。

- 怎么用：在你的 Agent 代码里直接调任意模型 provider 的 API（Agent 逻辑跑在 Runtime 容器里，出网调用任意模型），AgentCore 只负责托管运行时和周边设施，不强制走 Bedrock 推理。
- Strands 文档亦确认 Runtime「supports any model from any provider including Amazon Bedrock, OpenAI, Gemini, etc.」

### 3.3 与 Strands Agents SDK 的关系

- **Strands Agents** 是 AWS 自家开源的 Agent SDK（GitHub `strands-agents`，harness-sdk 仓库 ~6,098 stars，活跃），model-agnostic、原生支持 multi-agent 模式、与 AgentCore / Bedrock Guardrails / OTEL 一等公民集成。
- 关系：Strands 是**推荐但非强制**的上层框架。AWS 用 Strands 做「最佳搭档」演示，但 AgentCore 平台本身对框架完全开放——这是「自家框架 + 中立平台」的双轨打法，类似「我有亲儿子，但欢迎所有人」。

---

## 4. 与 MCP / A2A 协议生态的关系

AgentCore 的协议策略是「全面拥抱开放标准」，这是它对抗封闭生态的关键武器。

### 4.1 拥抱 MCP（Model Context Protocol）

- **Gateway 是 MCP 的核心载体**：把 API/Lambda 转成 MCP tools，并能直连现有 MCP server，做 Agent 的单一 MCP 端点。
- GA 后 Gateway 支持 **IAM + OAuth 双授权**用于 over-MCP 的 Agent-to-tool 交互。
- 新增 **MCP Sessions**：有状态会话，`Mcp-Session-Id`，跟踪 downstream MCP target session、elicitation/sampling 交互——说明 AWS 在深度跟进 MCP 规范演进。
- AgentCore 还提供自己的 **MCP server**，能接入 Kiro、Cursor AI 等 IDE，让开发者在编码环境里直接调 AgentCore 能力（ML Blog GA 文）。

### 4.2 支持 A2A（Agent-to-Agent）协议

- GA 时 **Runtime 已支持 A2A 协议**，官方称「broader A2A support coming soon across all AgentCore services」（来源：AWS What's New）。
- 这意味着 AgentCore 既支持 Agent↔工具（MCP），也支持 Agent↔Agent（A2A）两条互操作主干。

### 4.3 协议浪潮中的站位

AWS 选择**做协议的中立承载层**而非另立标准：MCP（Anthropic 主导）+ A2A（Google 主导）两大跨厂商标准它都接。这是聪明的「不赌协议、赌运行时」策略——无论哪个协议赢，Agent 都要在某个运行时上跑，而 AWS 要做那个运行时。

---

## 5. 安全、合规、企业级特性

这是 AgentCore 相对开源框架托管化方案的**最强护城河**，也是 AWS 拿下 Cohere Health（受监管医疗）、National Australia Bank 等客户的核心理由。

| 能力 | 细节 | 来源 |
|------|------|------|
| **会话隔离** | 每个 session 独立 **microVM**，物理级隔离，防数据泄漏 | ML Blog GA 文 |
| **网络隔离** | 全服务支持 **VPC + AWS PrivateLink**，流量私有化 | What's New GA |
| **IAM 集成** | Gateway 支持 IAM 授权（除 OAuth 外）做 over-MCP 交互 | What's New GA |
| **身份委托** | Identity 支持 OAuth、IdP 集成、refresh token secure vault | What's New GA |
| **可审计** | Observability 提供完整审计轨迹（audit trails），CloudWatch 驱动 | ML Blog GA 文 |
| **IaC / 自动化** | CloudFormation + CDK（无需 -alpha 包）+ resource tagging | What's New / Release Notes |
| **行为边界** | Policy（Cedar 策略）控制 Agent 能做/不能做什么 | 定价页 |

> Cohere Health 选 AgentCore 的原因（ML Blog 客户案例）：在高度监管的医疗环境做首个生产级 agentic AI 部署，需要 **comprehensive audit trails、extended session support、跨多小时复杂工作流维持历史**——这正是企业级与开源 demo 的分水岭。Sony 用它建了集团级 Agentic AI 平台，看重 enterprise-level security、observability、scalability。

---

## 6. 定价模型

### 6.1 总体原则

- **Consumption-based，无预付、无最低消费**（来源：官方定价页）
- **harness 本身免费**，只为底层资源付费
- 新 AWS 客户有 **up to $200 Free Tier credits**；preview 期组件（Agent Registry、Optimization）免费
- 12 个组件独立计费，分 **5 种计费模式**：per-session active consumption / per-request / per-record / pass-through / free-preview（来源：cloudburn.io）

### 6.2 各组件计费维度（核心数字，标来源）

| 组件 | 计费方式 | 关键数字 | 来源 |
|------|---------|---------|------|
| **Runtime** | active vCPU-hour + peak GB-hour | **CPU $0.0895/vCPU-hr**；**Memory $0.00945/GB-hr** | 官方定价页 + cloudburn + tech42 三方交叉验证 |
| **Browser** | 同 Runtime | 同上费率；示例 2 vCPU/4 GB | 官方定价页 |
| **Code Interpreter** | 同 Runtime | 同上费率；示例 2 vCPU/8 GB | 官方定价页 + ML Blog |
| **Gateway** | per MCP 操作 + 工具索引 | 按 ListTools/CallTool/Ping 等；VPC 出口 $0.006/GB | 官方定价页 |
| **Identity** | per OAuth token / API key 请求 | **经 Runtime/Gateway 使用免费** | 官方定价页 |
| **Memory** | 短期 per event；长期 per record/月 + per retrieval | 短期按 create event；长期按 stored record 小时 | 官方定价页 |
| **Policy** | per 授权请求 + per 1000 token（NL 生成 Cedar） | — | 官方定价页 |
| **Observability** | CloudWatch pass-through | ingestion + storage + query + PII 脱敏 | 官方定价页 |

### 6.3 计费精髓：active consumption 的「省」与「不省」

这是理解 AgentCore 成本最重要的一点（来源：官方定价页 + cloudburn.io 深度拆解）：

- **CPU 省**：Agent 30-70% 时间在 I/O wait（等 LLM 响应、API、DB），这段时间 **CPU 不计费**。AWS 称 70% I/O wait 场景下相比预留 compute 可省 **up to 3.3x**。
- **Memory 不省**：内存按**峰值水位**计费，覆盖整个 session 生命周期（含 idle 秒），**不随 I/O wait 停止**。
- 计费粒度：**per-second，1 秒最小**，128MB 最小内存。
- 官方算例（单 session）：CPU 18 秒×1vCPU = $0.0004475；Memory 阶梯 = $0.000276；合计 **$0.0007235/session**。

> **隐性成本警告**：Container 部署需 ECR 存储（单独计费）；direct code 部署按 S3 标准费率存代码工件；网络数据传输按 EC2 标准费率；Observability 的 CloudWatch 账单易超预算（实测案例曾出现 $6,500 telemetry line）。

---

## 7. 竞争格局横向对比

### 7.1 对比总表

| 维度 | **AWS Bedrock AgentCore** | **LangGraph Platform / LangChain** | **OpenAI Agents SDK + Responses API** | **Google Vertex AI Agent Engine + ADK** | **Azure AI Foundry Agent Service** | **Cloudflare Agents / Workers AI** |
|------|--------------------------|-----------------------------------|--------------------------------------|----------------------------------------|-----------------------------------|-----------------------------------|
| **定位** | 全栈 Agent 基础设施（运行时+周边7件套） | 开源框架 + 托管编排/部署 | 模型厂自带 Agent 能力 + hosted tools | 开源 ADK + 托管运行时 Agent Engine | 托管 Agent 服务，深绑 Azure/M365 | 边缘 serverless Agent 运行时 |
| **框架中立** | ✅ 极强（任意框架） | ⚠️ 以自家 LangGraph 为中心 | ❌ 绑自家 SDK | ⚠️ 以 ADK 为中心，可接其他 | ⚠️ 偏自家，支持部分开源 | ⚠️ 偏自家 Agents SDK |
| **模型中立** | ✅ 真中立（含 OpenAI/Gemini） | ✅ 中立 | ❌ 绑 OpenAI 模型 | ⚠️ 偏 Gemini | ⚠️ 偏 Azure OpenAI，有 model catalog | ✅ 多模型（Workers AI + 外部） |
| **会话隔离** | ✅ microVM 物理隔离 | 取决于自托管 | 平台托管 | VPC/VNet 隔离 | VNet 隔离 | V8 isolate（轻量） |
| **超长运行** | ✅ 8 小时 | 自托管不限 | 受限 | 较长 | 较长 | 边缘短时为主 |
| **记忆托管** | ✅ 短期+长期+self-managed | LangMem / 自建 | 内置 conversation state | 内置 | 内置 thread/memory | KV/D1 自建 |
| **可观测** | ✅ CloudWatch + OTEL + 第三方 | LangSmith（强） | 平台内 | Cloud Trace | App Insights | 平台内 |
| **协议** | MCP + A2A | MCP | MCP | A2A（Google 主推）+ MCP | MCP（A2A 跟进） | MCP |
| **定价模型** | 12 组件 consumption | 平台订阅 + 用量 | token + tool 用量 | $0.00994/vCPU-hr（Agent Engine） | 无额外费，付底层 compute+模型 | Workers 用量 |
| **生态绑定** | AWS 全家桶 | 云中立（最灵活） | OpenAI 生态 | GCP 全家桶 | Azure + M365 全家桶 | Cloudflare 边缘网络 |

> 竞品数字来源：planetarylabour.com（Vertex Agent Engine $0.00994/vCPU-hr；Azure 无额外费付底层）、agentmarketcap.ai（Azure 65% 存量客户评估/采用、GA 时 10,000+ 客户；Vertex ADK 7M+ 下载）、Forbes（批评 Microsoft Agent 栈复杂）。

### 7.2 文字判断

- **vs LangGraph/LangChain**：LangChain 派胜在框架灵活、云中立、LangSmith 可观测强；但托管化、企业级隔离、合规、超长运行是其短板。AgentCore 恰好可以**承载** LangGraph——LangChain 是被 AgentCore「平台化」的对象之一，而非正面对手。**这是 AgentCore 对中间层最大的冲击：你的框架可以赢，但生产运行时是我的。**
- **vs OpenAI Agents SDK**：OpenAI 是「模型 + 轻量 Agent 工具」垂直整合，开发体验顺滑，但锁定 OpenAI 模型、缺企业级隔离/VPC/合规深度。AgentCore 用「中立 + 企业级」错位竞争。
- **vs Vertex AI Agent Engine**：最接近的对手，同为云厂全托管 Agent 运行时。Google 靠 ADK + A2A 协议主导权 + Gemini 性价比；AWS 靠更成熟的企业信任、microVM 隔离、8 小时运行、更广的框架中立。
- **vs Azure AI Foundry Agent Service**：Azure 深绑 M365/Entra/企业 IT，存量客户转化强（GA 时 10,000+ 客户）；但 Forbes 批评其「Agent 栈让开发者困惑」（ADK/Agent Engine/多产品并存）。AgentCore 的模块化叙事相对更清晰。
- **vs Cloudflare Agents**：定位不同——Cloudflare 打**边缘 + 低延迟 + 低成本**的轻量 Agent，AgentCore 打**重型企业级长时任务**。短期不正面冲突。

### 7.3 AgentCore 的差异化优势 / 短板 / 战略意图

**优势**：①真框架/模型中立（最彻底）②microVM 物理隔离 + 8 小时运行（企业级最硬指标）③模块可独立用（渐进采用）④MCP+A2A 双协议 ⑤AWS 存量企业信任与合规底座。

**短板**：①12 组件计费复杂、成本难预估（最大吐槽点，催生一堆第三方 cost calculator）②深绑 AWS 生态，多云不友好 ③Observability 易超支 ④相对 OpenAI/Vertex 的「开箱即用顺滑度」略逊，偏「装配」。

**真实战略意图**：AWS 不做 Agent 框架战争的参战方，而做**所有框架的生产落地层**——卖运行时的「铲子」，赌 Agent 规模化后的基础设施长尾收入。

---

## 8. 实战上手

### 8.1 GitHub 生态实测数据（截至 2026-06-11，直接查 GitHub API）

| 仓库 | 用途 | Stars | Forks | Open Issues | 最近 push | 备注 |
|------|------|-------|-------|-------------|-----------|------|
| `aws/bedrock-agentcore-sdk-python` | Python SDK（核心 primitives） | **720** | 115 | 81 | 2026-06-08 | 活跃 |
| `aws/bedrock-agentcore-starter-toolkit` | CLI toolkit（**已标 legacy**） | **492** | 146 | 95 | 2026-06-02 | 官方建议新项目转用 agentcore-cli |
| `aws/agentcore-cli` | 新一代 CLI | **170** | 47 | 183 | 2026-06-11 | 新仓库（2026-01 建），高 issue 说明迭代快 |
| `awslabs/agentcore-samples`（原 amazon-bedrock-agentcore-samples，已重定向） | 官方示例集 | **3,046** | 1,181 | 353 | 2026-06-09 | 示例丰富，社区参与高 |
| `strands-agents/harness-sdk`（原 sdk-python 重定向） | Strands Agents SDK | **6,098** | 874 | 648 | 2026-06-10 | AWS 自家框架，热度最高 |

> **解读**：①生态非常活跃（全部近 2 日内有 push）②starter-toolkit 已被官方标记 legacy，迁移到 `agentcore-cli`，说明工具链在快速演进、有 breaking change 风险 ③samples 仓库 3k+ stars / 1.1k forks 显示真实开发者在跑示例 ④Strands harness-sdk 6k+ stars 是整个生态最热的入口。

### 8.2 最小可用示例（Python 部署骨架）

> 注：API 细节随 SDK 版本演进（toolkit 已 legacy 化），以下为**概念性骨架**，展示典型部署链路。具体以 `agentcore-cli` 最新文档为准。

```python
# 1) 安装
# pip install bedrock-agentcore strands-agents
# pip install bedrock-agentcore-starter-toolkit   # 或新版 agentcore-cli

# 2) 用 Strands 写一个最小 Agent（agent.py）
from strands import Agent
from bedrock_agentcore.runtime import BedrockAgentCoreApp

app = BedrockAgentCoreApp()          # AgentCore Runtime 入口封装
agent = Agent(model="us.anthropic.claude-...")  # 模型可换任意 provider

@app.entrypoint                      # 标记 Runtime 调用入口
def invoke(payload):
    user_msg = payload.get("prompt", "")
    result = agent(user_msg)         # Agent 推理 + 工具调用
    return {"result": result.message}  # Runtime 以 NDJSON 流式返回

if __name__ == "__main__":
    app.run()
```

```bash
# 3) 一条 CLI 部署到 AgentCore Runtime（零基础设施管理）
agentcore configure --entrypoint agent.py    # 生成配置
agentcore launch                              # 构建容器 + 部署到 Runtime
agentcore invoke '{"prompt": "Hello"}'        # 调用测试

# Runtime 自动：建 microVM、隔离 session、按 active 资源计费
```

**进阶接线**（按需组合）：
- 接 **Memory**：`from bedrock_agentcore.memory import MemoryClient`，存/取短期+长期记忆
- 接 **Gateway**：把 Lambda/API 注册为 MCP tool，Agent 通过 Gateway 端点发现调用
- 接 **Identity**：配 Cognito/Entra/Okta，让 Agent 代用户 OAuth 访问第三方
- 加 **Observability**：装 ADOT SDK 埋点，数据进 CloudWatch GenAI Observability

### 8.3 开发者体验评价

- **优点**：CLI 一条命令部署、几行代码、零基础设施管理；MCP server 可接 Kiro/Cursor IDE；Strands 配套顺滑；示例丰富。
- **痛点**（社区实测）：①工具链快速演进（starter-toolkit→agentcore-cli 迁移）有学习/迁移成本 ②Code Interpreter 内不能调 MCP 等架构约束需踩坑 ③12 组件计费心智负担重 ④NDJSON 流式返回等细节需适应。

---

## 9. 趋势研判与洞察

### 9.1 对 Agent 基础设施赛道意味着什么

AgentCore 的推出标志着 Agent 赛道从「**框架战争**」（谁的编排 API 更好用）进入「**基础设施战争**」（谁来托管生产 Agent）。三大云厂（AWS AgentCore、Google Vertex Agent Engine、Azure Foundry Agent Service）几乎同期推出托管 Agent 运行时，说明**云厂一致判断：Agent 的钱不在框架，在运行时和周边托管服务的长尾消费**。

### 9.2 会成为「Agent 时代的 Lambda / 云原生标准底座」吗？

**大概率会，但路径有变数。** 类比成立：
- Lambda 当年用「serverless + 按用量 + 零运维」定义了云原生函数计算标准，AgentCore 想用同样配方定义「serverless agent runtime」。
- microVM（Firecracker 血统）+ 8 小时运行 + active consumption 计费，是把 Lambda 经验迁移到 Agent 场景。

**变数**：①计费复杂度是 Lambda 当年没有的负担，可能拖慢普及 ②多云现实下，没有任何单一云能像 Lambda 一样「赢家通吃」，更可能是 AWS/Google/Azure 三分天下 + MCP/A2A 做跨厂互操作 ③开源自托管（K8s + 开源框架）仍是不愿锁定的企业的退路。

### 9.3 对创业公司 & LangChain 类中间层的冲击

- **对中间层（LangChain/LangGraph/CrewAI）**：**降维但不致命**。AgentCore 故意不做框架、反而托管它们，等于把中间层变成「跑在我平台上的一个选项」。中间层的价值被压缩到「开发期 DX + 可观测（LangSmith）」，而生产期的运行时收入被云厂拿走。LangChain 必须靠 LangSmith/LangGraph Platform 的托管化和云中立性守住价值。
- **对创业公司**：双刃剑。①**红利**：不用自建地基，小团队也能做生产级 Agent ②**威胁**：做「Agent 基础设施」的创业公司（记忆/沙箱/浏览器/网关类）直接和云厂七大组件正面竞争，生存空间被挤压；最佳策略是做**云厂没做好的垂直深度**或**跨云中立层**。

### 9.4 该用 / 不该用 AgentCore 的场景

**该用**：
- 已在 AWS 生态、要把 Agent 推上生产、有合规/审计/隔离硬要求（金融、医疗、电信——Cohere Health、NAB、Ericsson 即是）
- 需要超长运行（多小时异步任务）、强 session 隔离
- 想要框架/模型自由又不想自建地基

**不该用 / 慎用**：
- 强多云/避免厂商锁定诉求
- 极致成本敏感且负载简单（12 组件计费可能不划算，简单场景旧版 Agents 或自托管更省）
- 边缘低延迟轻量 Agent（Cloudflare 更合适）
- 团队完全在 Azure/GCP 生态且深绑其 IT（用对应云的 Agent 服务更顺）

### 9.5 给老板的核心判断（一句话）

**AWS 用 AgentCore 把「Agent 生产化」这件最脏最累的活做成了水电煤，赌的不是哪个框架赢，而是赌所有 Agent 最终都要在某个企业级运行时上落地收费——这是经典的 AWS「卖铲子」战略在 Agent 时代的复刻，谁掌握生产运行时，谁就掌握 Agent 时代的基础设施税。**

---

## 10. 信息源清单

### 官方一手来源
- AWS What's New（GA 公告，2025-10-13）：https://aws.amazon.com/about-aws/whats-new/2025/10/amazon-bedrock-agentcore-available
- AWS ML Blog（GA 深度文，Swami 署名）：https://aws.amazon.com/blogs/machine-learning/amazon-bedrock-agentcore-is-now-generally-available/
- AWS News Blog（preview 公告，2025-07-16，Danilo Poccia）：https://aws.amazon.com/blogs/aws/introducing-amazon-bedrock-agentcore-securely-deploy-and-operate-ai-agents-at-any-scale/
- 官方定价页：https://aws.amazon.com/bedrock/agentcore/pricing/
- 官方文档 Overview：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html
- Release Notes：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- Observability 配置文档：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/observability-configure.html
- Runtime sessions 文档：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-sessions.html
- Code Interpreter 官方 blog（2025-08-06）：https://aws.amazon.com/blogs/machine-learning/introducing-the-amazon-bedrock-agentcore-code-interpreter/
- FAQ：https://aws.amazon.com/bedrock/agentcore/faqs/

### GitHub（直接 API 查证，2026-06-11）
- aws/bedrock-agentcore-sdk-python（720★）
- aws/bedrock-agentcore-starter-toolkit（492★，legacy）
- aws/agentcore-cli（170★，新）
- awslabs/agentcore-samples（3,046★）
- strands-agents/harness-sdk（6,098★）

### 第三方深度 / 交叉验证
- Strands Agents 官方文档（部署到 AgentCore）：https://strandsagents.com/docs/user-guide/deploy/deploy_to_bedrock_agentcore
- cloudburn.io 12 组件计费拆解：https://cloudburn.io/blog/amazon-bedrock-agentcore-pricing
- tech42consulting 成本计算器/分析
- pump.co 功能与定价综述
- hidekazu-konishi 实现指南 & 三大云对比
- dev.to AWS Heroes Runtime 系列
- aiechoes.substack 实测
- agentmarketcap.ai / planetarylabour.com / Forbes（竞品数据）
- Auth0 blog（Identity 集成）

### 数据可信度说明
- **runtime/browser/code-interpreter 费率（$0.0895/vCPU-hr、$0.00945/GB-hr）**：官方定价页 + cloudburn + tech42 三方一致，高可信。
- **GA 日期 2025-10-13、9 区域、8 小时、microVM、A2A、框架/模型清单**：官方多来源一致，高可信。
- **采用规模（SDK 100 万下载、客户名单）**：官方营销口径，仅供参考。
- **竞品具体数字（Vertex $0.00994、Azure 10000+ 客户）**：第三方来源，中等可信，未经官方逐一核验。
- Gateway/Memory/Policy 的**逐单元具体单价**：官方按维度计费但未在抓取内容中给出每单位精确美元数，已如实标注计费维度而非编造数字。

---

*报告完 · 黄山 · 2026-06-11*
