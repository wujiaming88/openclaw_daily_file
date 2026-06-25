# 全球 AI Agent 基础设施研究周报 · 第 2 期（2026-06-18 ~ 2026-06-24）

> 覆盖区间：2026-06-18 00:00 → 2026-06-24 24:00（上海时区，完整一周）
> 聚焦：Agent 基础设施赛道（运行时 / 编排层 / 框架托管），非应用层

---

## 本期摘要

这一周是「Agent 生产化治理」竞赛的集中引爆点。三大云厂在七天内隔空对垒——AWS（6-17 Summit NY）、Google（6-18 GA 潮）、Microsoft（Build 余波 + 6 月底兑现承诺），不约而同把战线从「能否构建/运行 Agent」推进到「能否在生产环境治理 Agent」。关键词高度同构：统一 Gateway 安全网格、默认开启的 OpenTelemetry 可观测、Agent/工具 Registry、持续评估优化闭环、MCP/A2A 协议站队。

与此同时，模型厂商正全面「向下吞噬基础设施层」：Anthropic 发布 Claude Tag（Slack 多人共享 Agent），把 Agent 的度量单位从个人会话改为团队频道；Databricks 在 Data + AI Summit 把 Agent Bricks 升级为综合 Agent 平台；开源与中国阵营则呈现「产品热、开源冷」的分化。

---

## 🏆 本期 TOP 5（按对基础设施格局的信号价值排序）

| # | 信号 | 为什么重要 |
|---|------|-----------|
| 1 | 三大云厂同周 GA「Gateway + Observability」 | AWS 6-17、Google 6-18 隔天打擂台，标志「Agent 安全网格」成 2026 H2 兵家必争之地，竞争焦点从「能跑 Agent」转向「能治理 Agent」 |
| 2 | Anthropic Claude Tag 发布（6-23） | 模型厂商占领企业协作入口（Slack），Agent 从单人会话进化为多人共享常驻同事，内部 65% 产品代码已由其生成 |
| 3 | Databricks Agent Bricks 平台化（DAIS 2026） | 用「数据+AI 统一治理」叙事把战线上移到 Agent 平台底座，10 万+ Agents、年处理 1+ 千万亿 tokens，Unity AI Gateway 统一治理 |
| 4 | Google ADK A2A 1.0 + 默认 OTel（6-18） | 押注开放互操作对抗 AWS 一体化栈，A2A 协议 1.0 正式纳入 Agent Registry，新部署 Agent 默认开启追踪 |
| 5 | Microsoft 双框架收敛（AutoGen 冻结 + SK successor callout） | 正式宣告「框架战争」在其内部收敛为 Microsoft Agent Framework，预示独立框架生存空间被进一步挤压 |

---


## A 组｜三大云厂 Agent 托管平台

### Amazon Bedrock AgentCore（AWS）

- **本周动态**：本窗口（6-18→6-24）AgentCore 的真正"新落子"是 **Memory 跨账户访问（cross-account access）**——AWS What's New feed 在本周（约 6-23）发布：AgentCore Memory 现支持跨账户访问，允许构建"memory 资源与消费 agent 跨多个 AWS 账户"的多账户架构，通过 resource-based policies 授权一个账户的 principal 调用另一账户的 memory data-plane API。这对大型企业（中心化记忆库 + 分散业务线 agent）是刚需，标志 AgentCore Memory 从单账户玩具走向企业级多账户治理。除此之外，**6-17 Summit 的整批公告在本窗口内完成文档化与定价补全**：①**Web Search 工具 GA**（AWS News Blog 原文"Today we're announcing the general availability of Web Search on Amazon Bedrock AgentCore"，并于 **6-18 更新补充了明确的定价声明**；二手源 Kingy AI 记为 6-19 GA）——基于 Amazon 自有搜索基础设施，专有 web 索引 + 结构化知识图谱，作为 AgentCore Gateway 上的内置 connector target 经 MCP 暴露，返回带 snippet/source URL/标题/发布日期的排序结果，数据驻留在客户 AWS 环境内、零数据外流（zero data egress）。②**AgentCore Harness GA**（全区域）——CreateHarness/InvokeHarness，无编排代码、无需构建容器；GA 新增默认内置 memory、经 LiteLLM 与 Bedrock Mantle 接入更多模型商（解锁 OpenAI GPT-5.5/GPT-5.4）、AWS 策展技能目录一键开关、评测与优化、统一可观测性、版本与端点、导出 Strands 代码；并新增 **Step Functions 原生集成**（工作流内并行/串行跑多个 harness + 人工审批）。③**Managed Knowledge Base GA**（文档 6-19 更新修正建库截图）——全托管 RAG，六个原生连接器（S3/SharePoint/Confluence/Google Drive/OneDrive/Web Crawler），混合检索、文档重排、多模态。④**优化套件**：Failure Insights/Intent/Trajectory Insights 在 13 区域 preview，Recommendations/Batch Evaluations/A-B Testing 在 14 区域 GA（6-17 原文，aws-news）。⑤**Gateway** 大升级 GA：Runtime targets、HTTP passthrough targets、Inference targets、强制入站只来自 gateway、AgentCore Policy 支持 Bedrock Guardrails（gateway 层执行，agent 代码无法绕过）。⑥**Runtime**：默认服务配额大涨（活跃会话 us-east-1/us-west-2 升至 5,000、其他区 2,500；InvokeAgentRuntime 速率 25→200 TPS/agent；容器部署新会话创建率 100→400 TPM）、交互式 Shell/Terminal（每会话最多 10 个并发 shell）。⑦**合规**：AgentCore 取得 SOC 1/2/3 合规。⑧**Identity**：可直接引用已有 AWS Secrets Manager secret ARN。**路线判断**：AWS 在 Summit NY 用"一周一大批 GA"把 AgentCore 从去年 7 月的 preview 全面拉至生产级，主轴是"agent 性能闭环（observability→insights→recommendations→batch eval→A/B test）+ Gateway 作为统一安全/治理面（Guardrails、强制入站、MCP 全特性）"。本周的 Memory 跨账户是这套企业级叙事的延续。AgentCore 已不是"框架"，而是想做 agent 界的"托管控制平面 + 安全网格"。

- **关键数据**：
  - Runtime 活跃会话配额：us-east-1/us-west-2 = 5,000（原 1,000）、其他区 = 2,500（原 500）｜来源：AgentCore release notes https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ｜2026-06
  - InvokeAgentRuntime：25 → 200 TPS/agent/account；容器新会话创建率 100 → 400 TPM/endpoint｜同上
  - 优化套件区域：Insights 13 区 preview；Recommendations/Batch Eval/A-B Test 14 区 GA｜来源：aws-news.com https://aws-news.com/article/2026-06-17-amazon-bedrock-agentcore-introduces-new-optimization-capabilities-to-continuously-improve-agents-in-production ｜2026-06-17
  - 客户 logo（Summit 公布，背景）：Amazon Devices Ops & Supply Chain、Archera.ai、Cohere Health、Cox Automotive、Druva、Heroku、Natera、NTT Data、MongoDB、PGA TOUR、Pulumi、Thomson Reuters、Workday、Snorkel.ai、Swisscom、S&P Global Market Intelligence｜来源：aboutamazon.com https://www.aboutamazon.com/news/aws/aws-amazon-bedrock-agent-core-ai-agents ｜2025-12-02 起持续
  - Web Search 定价：原文 6-18 更新"added a clear pricing statement"，具体数额未在抓取正文展开（JS 渲染），**精确单价未公开/待核**
  - AgentCore CLI v0.19.0 / CDK constructs v0.1.0-alpha.36（Payments 支持）｜来源：release notes（同上）｜2026-06

- **原文链接**：
  - AgentCore Release Notes（已读全文）：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
  - 优化套件（aws-news，已读全文）：https://aws-news.com/article/2026-06-17-amazon-bedrock-agentcore-introduces-new-optimization-capabilities-to-continuously-improve-agents-in-production
  - Web Search GA（AWS News Blog）：https://aws.amazon.com/blogs/aws/announcing-web-search-on-amazon-bedrock-agentcore-ground-your-ai-agents-in-current-accurate-web-knowledge/
  - 二手分析（Kingy AI，定价/风险）：https://kingy.ai/news/amazon-bedrock-agentcore-web-search-guide/
  - 生态：Netskope 宣布即将集成 AgentCore（6-17）：https://www.stocktitan.net/news/NTSK/netskope-announces-upcoming-integration-with-amazon-bedrock-agent-45no06mbhnw3.html

- **影响判断**：① AWS 把"agent 生产化"定义为可观测+可优化+可治理的闭环，逼迫 Google/Microsoft 在"运行时 observability + 安全网格"维度跟进。② Web Search 零数据外流 + 自有索引，是对"agent 需要联网但企业怕数据泄漏"痛点的精准打击，直接挤压第三方搜索 API（Tavily/Serper 类）的企业市场。③ Memory 跨账户 + Gateway 强制入站，说明 AWS 押注"大型企业多账户/多团队"场景，这是其相对 Google/MSFT 的传统护城河（org 级治理）。

---

### Google Vertex AI Agent Engine + Agent Builder + ADK（现 Gemini Enterprise Agent Platform）

- **本周动态**：本窗口 Google 是三家中"本周动态最密集"的——大批 GA 恰好落在 **6-18**。**①Agent Gateway GA（6-18）**：Gemini Enterprise Agent Platform 的网络组件，统一为所有 agentic 交互（用户↔agent、agent↔工具、agent↔agent）提供安全与治理连接，正面对标 AWS AgentCore Gateway。**②Agent Observability GA（6-18）**：为已部署 agent 与 MCP server 提供性能/行为/健康可见性，关键是 **Default-On Tracing——新部署的 ADK agent 在 Agent Engine 上默认开启 OpenTelemetry 追踪**，无需手动配置；默认存储改为 GCS（替代 Cloud Logging）以支撑大体量多模态 payload；支持逐步会话执行检查与 trace span DAG 可视化。**③Agent Registry GA（6-18）**：agent 与 MCP server 的中心化发现/注册目录，API v1 + 七语言客户端库（C#/Go/Java/Node.js/PHP/Python/Ruby），**关键是支持 A2A 协议 1.0 版**（可在 supportedInterfaces 数组中显式声明 transport endpoint 与 binding，兼容旧 0.3 schema），Terraform 支持 GA。**④Agent Identity API（agentidentity.googleapis.com）preview（6-18）**：取代旧 IAM Connectors API 管理认证提供方与 agent 身份，迁移期双 API 并行、旧 authProvider 自动镜像到 V2 资源层级。**⑤AI security findings in Agent Platform GA（6-24）**：Security 仪表盘新增 Top security findings widget，agent 运行时（如 Cloud Run）的漏洞/威胁监控与历史违规趋势 preview。**⑥6-22**：Gemini 3.1 Flash Lite 与 3.5 Flash 的监督微调 preview（限 us-central1/europe-west4），SFT Gemini 3 模型支持 Provisioned Throughput。**在 Gemini Enterprise（应用层）侧**：6-24 Observability for agents GA、6-23 Deep Research agent 可观测 preview、**6-18 Workflow agents GA（allowlist）**（可在 web app 创建/导入工作流 agent，混合 AI 自动化与人工介入、基于触发器）。**ADK（开源 SDK）侧**：google/adk-python **v2.3.0**（tag 2026-06-17、GitHub 显示 6-18 发布）携大量特性：A2A 元数据保留与 HITL 中断修复、AgentRegistry 客户端 mTLS、McpToolset 迁移到 AsyncAuthorizedSession 支持 mTLS、GEPARootAgentOptimizer、Gemma4 支持、E2BEnvironment 远程沙箱、实验性 Antigravity SDK agent wrapper、GOOGLE_GENAI_USE_ENTERPRISE 环境变量、Gemini Live 3.1 输入转录处理、per-request OpenTelemetry 配置。**路线判断**：Google 在 6-18 用"Gateway + Observability + Registry + Identity"四件套一次性补齐了"企业级 agent 治理面"，且把 ADK 的默认 OTel 追踪与 A2A 1.0 注册深度绑定——这是其差异化主轴：**以开源 ADK + A2A 开放协议为生态入口，用 Gemini Enterprise Agent Platform 做托管收口**。命名上 Vertex AI 已整体更名为 Gemini Enterprise Agent Platform（Cloud Next 2026，4-22 背景），本周是改名后治理能力的实质性 GA 兑现。

- **关键数据**：
  - Agent Registry：API v1，七语言客户端库（C#/Go/Java/Node.js/PHP/Python/Ruby），A2A 协议 1.0｜来源：GEAP release notes https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ｜2026-06-18
  - SFT 模型 Provisioned Throughput burndown 高于 base 模型（具体倍率未公开）｜同上｜2026-06-22
  - ADK-python v2.3.0（compare v2.2.0...v2.3.0），tag 日期 2026-06-17｜来源：GitHub https://github.com/google/adk-python/releases ｜显示 6-18 发布
  - ADK v2.2.0 BREAKING：LlmAgent 默认模型 gemini-2.5-flash → gemini-3-flash-preview（2.5-flash 2026-10-16 关停）｜同上｜2026-06-04（背景）
  - GEAP 多区域/全球端点 Memory Bank & Sessions GA｜同上｜2026-06-17（背景，窗口前一天，全球端点不支持 CMEK）
  - 二手：dev.to 提示废弃 SDK 模块需在 2026-06-24 前迁移｜https://dev.to/jangwook_kim_e31e7291ad98/google-gemini-enterprise-agent-platform-build-and-deploy-a2a-agents-11ck ｜2026-04-26

- **原文链接**：
  - Gemini Enterprise Agent Platform release notes（已读全文）：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
  - Gemini Enterprise（应用）release notes（已读全文）：https://docs.cloud.google.com/gemini/enterprise/docs/release-notes
  - ADK-python releases（已读全文）：https://github.com/google/adk-python/releases
  - 改名背景（Google Cloud Blog）：https://cloud.google.com/blog/products/ai-machine-learning/introducing-gemini-enterprise-agent-platform

- **影响判断**：① Google 与 AWS 在 6-17/6-18 隔天打擂台——两家都在同一周把"Gateway 安全网格 + 可观测 + Registry/Identity"GA，说明 2026 H1 三大云厂的竞争焦点已从"能不能跑 agent"转向"能不能在生产里治理 agent"。② Google 的差异化是 **A2A 协议 1.0 正式纳入 Agent Registry + ADK 默认 OTel**，押注开放互操作（对抗 AWS 相对封闭的 AgentCore 一体化栈）。③ Default-On Tracing 降低了可观测门槛，可能成为开发者选型的体验差异点。

---

### Microsoft Foundry Agent Service（Azure AI Foundry）

- **本周动态**：本窗口（6-18→6-24）Microsoft 三家中**最安静**——无强时间戳的官方 GA 公告精确落在 6-18→6-24。本周可确认的是 **Build 2026（6-2/6-3，背景）所做承诺正在窗口期兑现/逼近兑现**：①Build 上 Microsoft 宣布 **Foundry Agent Service 的 Hosted Agents 计划"6 月底（by end of June 2026）GA"**，并配套四项开箱即生产能力；②**Hosted agents 的 Tracing 与 Evaluation 计划"6 月晚些时候（later in June 2026）GA"**（官方 Foundry 博客 agent-service-build2026 原文）；③**Foundry agent 直接发布到 Microsoft Teams 与 M365 Copilot 计划 6 月 GA**——agent 可直接进入员工日常工具，身份/权限/策略自动贯通。这三项的目标窗口都正好压在本研究区间内，但截至抓取时点（6-25）尚未检索到带明确"6-18→6-24 某日 GA"字样的官方落地公告，故按铁律标注为"**承诺窗口在本周内、精确 GA 日未公开/待核**"。**开源 SDK 侧（GitHub 实测）**：**AutoGen 已实质冻结**——microsoft/autogen 最新 release 仍停在 python-v0.7.5（2025-09-30），近三个季度无新 release，因为其能力已并入 **Microsoft Agent Framework（autogen + semantic-kernel 的官方继任者）**；**Semantic Kernel** 最新动作在 **6-17**（窗口前一天，python-1.42.0），且其 README 已被加上"**Microsoft Agent Framework successor callout**"（PR #13932，明确告知 SK 的继任者是 Agent Framework），本周 SK 提交以依赖 bump（authlib/onnxruntime/boto3）与安全加固（SQL/Redis 转义、AllowedBaseUrls 校验）为主，无重大新特性。**路线判断**：Microsoft 的战略已清晰——**收敛双框架（AutoGen + SK）到统一的 Microsoft Agent Framework**，并把生产化能力（Hosted Agents 受管计算 + OpenTelemetry 端到端 tracing + 持续 evaluation + AI Red Teaming）集中到 Foundry Agent Service。其独特护城河是**与 M365 Copilot/Teams/Agent 365 的渠道贯通**——"agent 建好即可发布到员工已在用的工具里"，这是 AWS/Google 都不具备的"to-work"分发优势。Build 2026 还把 **MCP 设为 Foundry/Agent 365/IQ/Copilot 全线默认层**（二手 windowsforum），协议站队 MCP。

- **关键数据**：
  - autogen 最新 release：python-v0.7.5｜来源：GitHub https://github.com/microsoft/autogen/releases ｜2025-09-30（近三季度无新版，已被 Microsoft Agent Framework 取代）
  - semantic-kernel 最新：python-1.42.0，含"Microsoft Agent Framework successor callout"（PR #13932）｜来源：GitHub https://github.com/microsoft/semantic-kernel/releases ｜2026-06-17（窗口前一天）
  - Hosted Agents GA 目标："by end of June 2026"；Tracing/Eval GA 目标："later in June 2026"｜来源：Foundry Blog https://devblogs.microsoft.com/foundry/agent-service-build2026/ ｜Build 2026（6-2/6-3）发布，精确 GA 日未公开
  - Teams/M365 Copilot 发布 GA 目标：June 2026｜来源：InfoQ https://www.infoq.com/news/2026/06/microsoft-foundry-agents/ ｜2026-06
  - AzureML SDK v1 EOL：2026-06-30（背景，迁移 v2）｜来源：Foundry Blog（Dec2025/Jan2026 期）

- **原文链接**：
  - Foundry Agent Service @ Build 2026（已读摘要）：https://devblogs.microsoft.com/foundry/agent-service-build2026/
  - autogen releases（已读全文，确认冻结）：https://github.com/microsoft/autogen/releases
  - semantic-kernel releases（已读全文，确认 successor callout）：https://github.com/microsoft/semantic-kernel/releases
  - Foundry Agent Service classic what's-new（已读，确认 classic agents 2027-03-31 退役）：https://learn.microsoft.com/en-us/azure/foundry-classic/agents/whats-new
  - InfoQ 综述：https://www.infoq.com/news/2026/06/microsoft-foundry-agents/

- **影响判断**：① Microsoft 把 AutoGen/SK 双线收敛到 Microsoft Agent Framework，短期对开源用户是迁移成本，长期是"一个框架 + Foundry 托管 + M365 分发"的闭环，威胁 LangChain 等独立框架。② "agent 直发 Teams/M365 Copilot"是 Microsoft 对 AWS/Google 的非对称打击——后两者没有同等量级的企业办公终端入口。③ 本周的"安静"恰恰因为 Microsoft 的大爆发在 Build（6-2/6-3），节奏与 AWS（6-17 Summit）、Google（6-18 GA 潮）错峰；三家在 2026 H1 形成"Build→Summit→GEAP GA"的连续三波。

---

## 本组洞察（三大云厂格局变化）

**2026 年 6 月中下旬这一周，是"agent 生产化治理"竞赛的集中引爆点。** 三大云厂在 7 天内隔空对垒：AWS（6-17 Summit）、Google（6-18 GA 潮）、Microsoft（承诺 6 月底兑现 + Build 6-2/6-3 余波），不约而同把战线从"能否构建/运行 agent"推进到"能否在生产环境治理 agent"——三家本周/近周的关键词高度同构：**统一 Gateway 安全网格 + 默认开启的 OpenTelemetry 可观测 + Agent/工具 Registry + 持续评估/优化闭环 + MCP/A2A 协议站队**。差异化主轴清晰分化：**AWS** 押"一体化托管控制平面 + org 级多账户治理 + 自有零外流 Web Search"（最封闭、最企业 IT 向）；**Google** 押"开源 ADK + A2A 1.0 开放互操作 + 默认 OTel 低门槛"（最开放、最开发者友好）；**Microsoft** 押"双框架收敛为 Agent Framework + Foundry 托管 + M365/Teams 渠道贯通"（最强 to-work 分发、最强办公终端入口）。协议层面，MCP 已成三家共识底座，A2A 由 Google 高举。**本周最具信号意义的单点**：Google 与 AWS 在 6-17/6-18 隔天 GA "Gateway + Observability"，说明"agent 安全网格"已是 2026 下半年的兵家必争之地；而 Microsoft 用 AutoGen 冻结 + SK successor callout，正式向市场宣告"框架战争"在其内部已收敛——这预示独立 agent 框架的生存空间将被三大云厂的"框架+托管+分发"闭环进一步挤压。

---

## B 组｜模型厂商 Agent 平台 + 通用框架

### OpenAI Responses API + Agents SDK（含 Swarm 谱系 / AgentKit）
- 本周动态：本周 `openai/openai-agents-python` 连发两个补丁版本，节奏密集。**v0.17.6（6 月 19 日发布）** 引入两项面向生产的能力：`feat: add pre-approval tool input guardrails`（#3487，工具调用前对输入做护栏校验，可在工具真正执行前拦截/改写参数）与 `feat: add SDK-only custom data for tool outputs`（#3486，允许在工具输出上挂载仅 SDK 可见的自定义数据，便于在 trace/回调中携带业务上下文而不污染模型可见内容），随后 #3657 又把 #3486 收紧为"强制文档化的严格 JSON 兼容契约"。**v0.17.7（6 月 24 日发布）** 偏运维与稳定性：`feat: expose configurable websocket max_size limit`（#3645，Realtime 场景可配置 WS 帧上限）、`feat: add buffered Chat Completions tool-call streaming`（#3506，Chat Completions 路径下缓冲式工具调用流式输出）、以及一批 sandbox（E2B/Blaxel/Modal/Vercel 多沙箱后端）超时与缓冲修复、MCP 重名工具报错提示增强（#3678）、Realtime 多 Agent 工具派发歧义修复（#3441）。①组件/版本：v0.17.6→v0.17.7，主线维护者 seratch 主导。②关键信号：本周特性集中在"工具治理（pre-approval guardrails）+ 多沙箱执行后端稳健性 + Realtime/MCP 边界"，而非大版本能力跃迁；社区贡献者井喷（单周 10+ 位首次贡献者），说明 SDK 进入高频社区共建的成熟期。③路线判断：Agents SDK 已是 OpenAI 把 Swarm 实验范式产品化后的官方主干，当前阶段重心从"能跑"转向"可控可观测可托管"——guardrails、沙箱、tracing 三条线同时加固，配合平台侧 AgentKit（DevDay 2025 发布）与 Responses/Conversations API（替代将停用的 Assistants API），形成"托管运行时 + 开源 SDK"双层栈。本周无 AgentKit/Responses API 的官方博客级新公告（属背景，非本周）。
- 关键数据：v0.17.6 发布 2026-06-19、v0.17.7 发布 2026-06-24（https://github.com/openai/openai-agents-python/releases）；openai-agents-python GitHub Stars **27,406**（GitHub API 实时，2026-06-25）；Assistants API 已公布弃用时间线、引导迁移至 Responses + Conversations API（https://releasebot.io/updates/openai，2026-06-23 前后）
- 原文链接：https://github.com/openai/openai-agents-python/releases
- 影响判断：OpenAI 在 Agent 层的策略是"开源 SDK 快速迭代 + 平台 API 收口（Assistants→Responses）"，本周的 pre-approval guardrails 直指企业对 Agent 工具调用安全的核心顾虑，是把 Agent 推向生产环境的关键拼图。多沙箱后端持续加固说明"代码执行/计算机使用"已成 SDK 一等公民。

---

### Anthropic Claude Agent SDK + MCP（含 Computer Use / Managed Agents）
- 本周动态：本周 Anthropic 的核心公开动作是 **6 月 23 日发布 Claude Tag**（Slack 集成，beta，面向 Claude Enterprise/Team 客户），这是 Claude Agent 形态从"单人会话"向"团队多人共享 Agent"演进的标志性产品。①发生了什么：Claude 作为团队成员加入 Slack 频道，管理员授予其频道访问权与工具/数据/代码库连接（含私有 MCP server），任何人 @Claude 即可委派任务；它会跨任务/跨人保留频道上下文记忆。四大新特性：**multiplayer**（一个频道一个 Claude，所有人共享其工作状态）、**learns over time**（跨频道与数据源自动积累 tacit knowledge，私有频道不外泄）、**takes initiative**（开启 ambient 行为后主动推送、追踪未解决线程）、**works asynchronously**（可为自己排程，连续数小时/数天自治推进项目）。②原文关键数据/摘录："Today, 65% of our product team's code is created by our internal version of Claude Tag"——Anthropic 内部产品团队 65% 的代码已由内部版 Claude Tag 生成；身份与计费按频道隔离（销售用 Claude 不会把记忆/数据泄漏给工程用 Claude），管理员可设组织级与频道级 token 上限并查看完整操作日志；Claude Tag 运行在 **Opus 4.8** 上，将在 30 天内替换原有的 "Claude in Slack" app。③路线判断：这是把 Claude Code/Cowork 的 agent 能力"多人化 + 常驻化 + 自治化"，本质是与 OpenAI ChatGPT 团队版 Agent、Google 协作型 Agent 抢占"企业协作场域内的常驻 AI 同事"心智。MCP 在此扮演私有数据/工具连接底座。背景（非本周）：MCP 规范层最新为 2026-07-28 RC（5 月 29 日挂出 draft），Claude Managed Agents 的 self-hosted sandboxes(public beta)+MCP tunnels(research preview) 已于 5 月 19 日 Code with Claude London 发布；Claude Code 仍在高频迭代（releasebot 显示 374 条更新，最新 6 月 24 日），本周修复涉及 subagent transcript 可见性、auto mode 在 subagent spawn 前先经分类器审查、MCP 鉴权服务器修复等。
- 关键数据：Claude Tag 发布 2026-06-23（https://fortune.com/2026/06/23/anthropic-claude-tag-virtual-employee-tool-slack/ ；https://www.anthropic.com/news/introducing-claude-tag）；内部 65% 产品代码由 Claude Tag 生成（Anthropic 官方博客，2026-06-23）；运行模型 Opus 4.8；Claude Code 最新更新 2026-06-24（https://releasebot.io/updates/anthropic/claude-code）
- 原文链接：https://www.anthropic.com/news/introducing-claude-tag （经 releasebot 抓取全文）
- 影响判断：Claude Tag 把 Agent 的"度量单位"从个人会话改为团队频道，是 Anthropic 平台化的关键一跃——它绑定企业协作入口(Slack)、用 MCP 连私有系统、用频道级身份/计费/审计满足合规，直接卡位企业级常驻 Agent。配合 Managed Agents 的自托管沙箱与 MCP tunnels，Anthropic 的"模型厂商→Agent 基础设施厂商"转型已成体系，对纯框架厂商(LangChain/CrewAI)形成上压。

---

### LangChain / LangGraph / LangSmith Deployment
- 本周动态：本周 LangChain 栈"代码层 + 平台层"双线均有在窗动态。①代码层：`langchain-ai/langgraph` 于 **6 月 18 日发布 langgraph 1.2.6**（#8139），修复两处回归：nested subgraph 继承父 checkpoint_ns（1.2.3 引入的回归，#8053）、v3 stream abort 时取消运行中的 subgraph（#8057）；CLI 0.4.30（6 月 16 日）新增"兼容 API 版本区间"支持（#8023）。背景：1.2.3（6 月 1 日）起 SDK-py 已全量铺开 **v3 streaming**（SSE/WebSocket 传输、messages/tool-call projections、interleave、reconnect 加固），是本季度主线工程方向。②平台层（LangSmith Cloud changelog，**June 15-19, 2026 周更**，在窗）：动态极密集——**Deployment**：预览部署改为按 preview commit 构建镜像（不再复用父部署镜像）；**Sandboxes**：标注 AWS US SaaS 转为 GA、新增 Git mounts 与 GCS bucket mounts、auth proxy 补充 GCP 规则与服务账号处理；**Engine**（其 agentic 自动修 issue/开 PR 引擎）：统一启用界面+访问申请、组织设置集中用量与限额、spend 超阈值邮件告警；**Observability**：Dashboards 新增 chart builder（模板/编辑面板/时间序列刷选）、alerts 支持 Slack 原生通知目标、Playground 为 OpenAI Responses API reasoning 模型暴露 Reasoning Summary 选项、Trace query 语法补全操作符参考；**LLM Gateway**：支持 Vertex AI 原生 Gemini 路由与 OpenAI embeddings 端点、guard 策略支持细粒度 PII 配置；**Admin**：Vanta MCP 集成转 GA。③路线判断：LangChain 已把品牌收口为"LangSmith 三件套（Observability + Evaluation + Deployment）"（LangGraph Platform→LangSmith Deployment 的更名自 2025-10 完成，属背景），本周节奏显示其正全力把"托管部署 + 沙箱执行 + 可观测 + LLM 网关"打包成企业级 Agent 运行平台，并通过 Engine 切入"AI 自动修代码"赛道。
- 关键数据：langgraph 1.2.6 发布 2026-06-18、CLI 0.4.30 发布 2026-06-16（https://github.com/langchain-ai/langgraph/releases）；LangSmith Cloud 周更 June 15-19, 2026（https://docs.langchain.com/langsmith/changelog）；langgraph GitHub Stars **35,664**（GitHub API 实时，2026-06-25）；LangChain Interrupt 2026 称新架构 trace tree 加载 P50 92ms、全文搜索 400ms、较旧版最高 12x 提速（Reddit r/LangChain，背景）
- 原文链接：https://docs.langchain.com/langsmith/changelog ；https://github.com/langchain-ai/langgraph/releases
- 影响判断：LangChain 的差异化在"开源框架(LangGraph)→托管平台(LangSmith Deployment)→可观测/评估(LangSmith)"全栈闭环，本周 Sandboxes GA 化 + Gateway 多模型路由 + Engine 自动修 issue，意味着它正与模型厂商(OpenAI/Anthropic)的托管 Agent 平台正面竞争，但以"模型中立 + 可观测护城河"为卖点。对企业是"不锁定单一模型"的关键替代项。

---

### CrewAI AMP（平台化 / Enterprise / Crew Studio）
- 本周动态：本周 `crewAIInc/crewAI` 开源主线进入 **v1.14.8 系列高频 alpha 滚动**，工程主题高度聚焦"**声明式 Flow（JSON-first / 无 Python 代码编排）**"，与平台侧 Crew Studio 的可视化编排战略直接呼应。逐条在窗动态：6/18 v1.14.8a 起连发 a1/a3/a4 多个 alpha——新增 `script/code block`、`crew actions`、`each composite action` 到 FlowDefinition，实现"无需 Python 代码即可运行 Flow 定义"，引入 `crewai run --definition`（实验性）、ZIP 部署回退、**JSON-first crews**；6/18 还加入 Datadog 集成指南（含可导入运维仪表盘）；6/23 a3 加入"统一声明式 flow 加载"、合并 `crewai run` 与 `crewai flow kickoff`、为 CrewAI tools 增加类型化输出 schema、允许 `@router()` 作为 flow 起始方法、支持 CLI TUI 中的对话式 flow；6/24/6/25 a4 继续打磨 declarative refs 跨 flow/crew、修复 JSON schema flow state 输入，并移除 StateProxy。文档侧推进 Crew Studio 的"One Card per Step"页面（AGE-107）。①路线判断：CrewAI 正把"代码定义 crew"升级为"声明式/JSON 定义 + 可视化 Studio + 一键部署(AMP)"，目标是降低非工程人员搭建多 Agent 工作流的门槛，与 n8n 等可视化 Agent 平台正面竞争。背景：n8n 2026 企业 Agent 工具报告称 CrewAI 因发布 Crew Studio 而首次入选，评价其产品"非常连贯、文档与讲解到位"。
- 关键数据：v1.14.8a 系列 alpha 集中于 2026-06-18→06-25（https://github.com/crewAIInc/crewAI/releases）；稳定版 v1.14.7 发布 2026-06-11；CrewAI GitHub Stars **54,317**（GitHub API 实时，2026-06-25；注：部分二手榜单引述的 5K stars 已严重过时，应以实时数据为准）
- 原文链接：https://github.com/crewAIInc/crewAI/releases
- 影响判断：CrewAI 的平台化路径（开源 crewAI → Crew Studio 可视化 → AMP 企业托管）瞄准"业务人员可搭建的多 Agent 工作流"，JSON-first 是关键解耦——把编排从 Python 代码中抽离，为 Studio 拖拽与云端部署铺路。但与 OpenAI/Anthropic 的模型厂商托管平台、LangChain 全栈平台相比，CrewAI 体量更小，差异化在"角色化多 Agent 协作 + 低代码"，能否商业化放量是观察重点。

---

## 本组洞察（模型厂商 vs 通用框架格局）
- **模型厂商正全面"向下吞噬基础设施层"**：本周最强信号是 Anthropic Claude Tag（6/23）——模型厂商不再只卖 token，而是直接占领企业协作入口(Slack)、用 MCP 连私有系统、用频道级身份/计费/审计提供常驻 AI 同事。OpenAI 同步用 Agents SDK(pre-approval guardrails)+ 平台 API 收口(Assistants→Responses)推进同一方向。模型厂商的优势是"模型-Agent 一体化垂直整合 + 品牌信任"。
- **通用框架以"模型中立 + 全栈可观测/部署"反制**：LangChain 把 LangSmith 三件套(Observability/Eval/Deployment)+Sandboxes+LLM Gateway 打成企业级运行平台，卖点是"不锁定单一模型 + 深度可观测"；CrewAI 走"声明式/低代码 + 可视化 Studio + 角色化多 Agent"差异化。两者本质是用"开放性与中立性"对抗模型厂商的垂直整合。
- **共同收敛趋势**：①工具治理（pre-approval/guardrails/权限）成为生产化核心；②沙箱执行（self-hosted sandbox / 多沙箱后端）已是标配，安全边界从"模型侧"移向"客户侧"；③MCP 成为跨阵营的私有数据/工具连接事实标准（Anthropic MCP tunnels、LangSmith Vanta MCP GA、OpenAI SDK 的 MCP 支持）；④可观测性（tracing/eval/cost）从框架附属升级为独立护城河。
- **判断**：2026 H2 的竞争主线是"模型厂商垂直整合 Agent 平台" vs "中立框架全栈托管化"的正面对撞，胜负手在企业对"锁定 vs 开放""一体化体验 vs 可观测可控"的权衡。MCP 作为中立协议层是双方都必须支持的最大公约数。

---

## C 组｜数据 / 开源 / 中国 Agent 平台

### Dify（langgenius/dify，开源 LLM 应用/Agent 平台）
- 本周动态：本周（6/18–6/24）Dify **无新版本 tag 发布**，最新正式版仍停留在 **v1.14.2（2026-05-19 发布）**，本期处于 1.14.x 补丁线之后、下一个 minor 的开发窗口。不过 GitHub 主仓 `pushed_at` 显示 2026-06-25 仍在高频提交（主分支 main 持续活跃），说明开发节奏未停，只是未打正式 release。从最近的 v1.14.x 系列发布脉络可读出 Dify 当前主线方向：①**安全加固**——按租户隔离敏感端点（app trace-config、FilePreview 文本抽取）、限制内建工具凭据仅 workspace admin/owner 可改、为自托管部署去除公共默认 SECRET_KEY（空值时自动生成并持久化运行时密钥），并为 CVE-2026-42208 升级 LiteLLM；②**工作流与 HITL（Human-in-the-loop）可靠性**——修复 HITL 工作流恢复后的链路追踪、暴露 HITL 流程被选中的 action 值、减少消息更新的数据库往返；③**RAG/知识库**——允许 LLM 节点访问检索到的知识文件、跨 provider 用 doc_id 做去重、修复知识库图片渲染；④**前端设计系统迁移**——大规模把遗留组件迁移到 `@langgenius/dify-ui` 基元（Drawer/Tabs/Combobox 等）。路线判断：Dify 已从"低代码 LLM 应用搭建"明确转向**生产级 agentic workflow 平台**（仓库 description 已改为"Production-ready platform for agentic workflow development"，topics 含 agent/agentic-ai/mcp），企业级（多租户隔离、安全合规、可观测性 Opik/Langfuse/Phoenix 三接入）是当前打磨重心。
- 关键数据：GitHub Stars **146,480**、Forks **23,044**、watchers 814、open issues 784（https://github.com/langgenius/dify ，2026-06-25 实时 API 读数）；最新版本 v1.14.2（https://github.com/langgenius/dify/releases ，2026-05-19）。
- 原文链接：https://github.com/langgenius/dify ｜ https://github.com/langgenius/dify/releases
- 影响判断：14.6 万 Stars 使 Dify 稳居开源 LLM 应用/Agent 平台第一梯队（仅次于以自动化为主的 n8n）。本周无 release 属正常节奏，主分支持续提交说明 1.15/下一 minor 在路上；企业级安全与 HITL 的密集投入，反映开源 Agent 平台竞争已从"能搭建"转向"敢上生产"的合规与可靠性深水区。

---

### Databricks Mosaic AI Agent Framework / Agent Bricks
- 本周动态：本周是 Databricks 的**年度旗舰大会 Data + AI Summit 2026（DAIS 2026）周**，公司围绕 Agent 平台一口气放出重磅升级，构成本期 C 组最实锤的产品级动态。核心是博客《Agent Bricks: Data + AI Summit 2026》宣布把 **Agent Bricks 从"建 Agent 的实验"正式升级为"面向开发者的综合 Agent 平台"**。原文关键数据/摘录：自去年 DAIS 首发以来"已构建超 10 万+ Agents（100k+ agents built），每年处理 1+ 千万亿（quadrillion）tokens"，AstraZeneca、7-Eleven、Fox、Block 等已在其上交付 Agent。Databricks 提出"核心 agent loop 只占 1% 工作量，另外 99% 是 token 容量/部署/安全/评估/监控/上下文/共享的隐藏技术债"，并以 **Choice / Context / Control 三支柱** 重构平台：①Choice——单平台聚合所有前沿闭源+开源模型（OpenAI/Anthropic/Gemini/Qwen，新增 **Kimi**，并宣布与 **SpaceX 合作把 Grok 模型原生引入 Databricks**）；支持任意 agent harness（LangGraph/Agno/CrewAI/Claude Code SDK/OpenAI Agent SDK），并开源 meta-harness **Omnigent**（"上周末刚发布"）的托管版；②Context——给 Unity Catalog 加 **MCP 支持**连接 Google Drive/JIRA/Slack/Github，推出 **Genie Ontology**（持续学习数据本体+人工业务语义）、Databricks Agent Tools（文档搜索 subagent 比此前快 3x）、**Agent memory service**（底层 Lakebase，跨会话/跨 Agent 持久化记忆）、Document Intelligence（ai_parse_document/ai_extract/ai_classify GA）、**Databricks Sandbox**（隔离 VM 安全运行代码解释器/subagent）；③Control——发布 **Unity AI Gateway** 统一治理层（覆盖 MCP/模型/外部 Agent，细粒度访问控制+按人/组预算+智能路由），Agent traces 入 Lakehouse 并接 LakeWatch 安全平台、SQL 写 Contextual Policies、把 agents/tools/models 纳入 Unity Catalog 注册。配套生态侧博客《Becoming the most comprehensive data & AI ecosystem on earth》同周宣布 Marketplace Commit Drawdown、可在 Marketplace 分发 Databricks Apps（5,000+ 账户周活跑 Apps、同比 5X 增长）与 Genie Agents、并推出面向 AI 时代的开放共享协议 **OpenSharing**。路线判断：Databricks 的打法极其清晰——**不与 LangGraph/CrewAI 等 harness 正面竞争，而是做"模型+数据+治理"的底座平台**，用 Lakehouse 的数据治理护城河（"AI 治理无法与数据治理分离"）锁定企业级 Agent 生产化场景，三支柱直击企业部署 Agent 的真实痛点（选型/上下文/管控）。
- 关键数据：100k+ agents built、1+ quadrillion tokens/year（https://www.databricks.com/blog/agent-bricks-dais-2026 ，DAIS 2026 周）；20,000+ 客户、Fortune 500 中 70%+、年化营收运行率同比 +65% 破 $5B、Databricks Apps 5,000+ 账户周活产线同比 5X（https://www.databricks.com/blog/becoming-most-comprehensive-data-ai-ecosystem-earth ，2026-06-17）。Databricks 连续第二年在 Gartner Magic Quadrant 执行力最高、愿景最远（https://www.databricks.com/blog ，2026-06-24 News）。
- 原文链接：https://www.databricks.com/blog/agent-bricks-dais-2026 ｜ https://www.databricks.com/blog/becoming-most-comprehensive-data-ai-ecosystem-earth
- 影响判断：这是本周全球 Agent 基础设施层最重的一击——Databricks 用"数据+AI 统一治理"叙事把战线从"Agent 框架"上移到"Agent 平台底座"，与 Snowflake、云厂商及纯框架玩家形成差异化；SpaceX/Grok、Kimi 等模型纳入显示其"模型中立聚合器"野心。Unity AI Gateway + Agent traces 入湖的设计，可能成为企业"敢上生产 Agent"的关键合规拼图，对 LangSmith/Arize 等独立可观测厂商构成挤压。

---

### 字节跳动 Coze / 扣子（ByteDance Coze，国内扣子 + 海外 coze.com）
- 本周动态：本周（6/18–6/24）字节 Coze/扣子**无新的产品大版本发布**，主线动态仍是 6 月初 **Coze 3.0 全球上线（2026-06-01）** 的余波在持续发酵——本周仍有海外科技媒体在跟进解读其意义（China Daily Brief 于 6 月 24 日前后刊文《Beyond Chatbots: ByteDance's Coze 3.0 Signals a New Era of Autonomous AI Agents》，将 Coze 3.0 定性为"从聊天机器人迈向自主 AI Agent 新时代"的信号）。**（背景，非本周）** Coze 3.0 关键能力：新增**多人多 Agent 协作**、金融/医疗等**六大行业技能包**、多端同步与一键加载，并可无缝接入 Claude Code、Codex CLI 等外部编码工具；国内扣子官网（coze.cn）主打"职场 AI 伙伴"，Agent 持续满配在线、配云手机/云电脑、长期记忆、自主推进任务，覆盖编程/PPT/数据分析/小程序/视频等场景；订阅分个人免费版/个人进阶版/团队版/企业版四档。**开源侧（本周重点核查）**：开源项目 `coze-dev/coze-studio` **本周无任何提交**——GitHub API 显示其主分支最新 commit 停在 **2026-04-20**（"fix(plugin): oauth phishing #2668"），最新 release 仍为 **v0.5.1（2026-02-05，镜像 cozedev/coze-studio-server:0.5.1）**，本周开源仓库处于停滞状态；Coze Studio 当前 Stars **21,040**、Forks 3,059、open issues 519。另一开源运维平台 Coze Loop（coze-dev/cozeloop，2025-08 开源的 Agent 开发运维平台）本周亦无公开重大动态。路线判断：字节把**重火力压在闭源商业化的 Coze 3.0/扣子产品线**（多 Agent 协作 + 行业技能包 + 出海全球版），走"产品力 + 生态接入（Claude Code/Codex）"路线抢占企业与职场用户；而开源的 Coze Studio 在 v0.5.x 后明显放缓，更像是"社区蓄水池/获客入口"而非主投入方向，本周开源与产品两条线节奏分化明显。
- 关键数据：Coze Studio GitHub Stars **21,040**、Forks **3,059**、open issues 519、最新 commit 2026-04-20、最新 release v0.5.1（2026-02-05）（https://github.com/coze-dev/coze-studio ，2026-06-25 实时 API）；Coze 3.0 全球上线 2026-06-01（https://finance.sina.com.cn/wm/2026-06-03/doc-inhzzyte2869078.shtml ；https://www.zgeo.com.cn/news/byte-dance-coze-3-0-ai-agent ）。本周区间内 Coze 产品侧无新版本号公开动态——记为"未公开"。
- 原文链接：https://github.com/coze-dev/coze-studio ｜ https://chinadailybrief.com/article/6a1f7098bc35116ac7b1cbf8 ｜ https://www.coze.cn/
- 影响判断：作为国内 Agent 平台头部，字节本周"产品热、开源冷"的反差值得关注——Coze 3.0 的多 Agent 协作+行业技能包打法直接对标 Databricks Agent Bricks 的企业级叙事与扣子的职场场景护城河；但开源 Coze Studio 两个月零提交，若长期停滞或削弱其对开发者生态的吸引力，与 Dify（14.6 万 Stars、持续高频提交）的开源活跃度差距正在拉大。

---

### n8n / Flowise（开源 Agent IDE / 工作流自动化）
- 本周动态：**n8n 本周是 C 组开源对象里发版最密集的一个**，6/18–6/24 区间内连续滚动发布多个版本：**v2.28.0（2026-06-23，minor 版）** 为本周主线，含大量 core/editor 修复与 AI/MCP 相关增强——如修复 MCP 工具的 error path schema 不匹配、MCP OAuth2 DCR 协商 token_endpoint_auth_method 与 protected-resource scopes、防止给 MCP 分配不可用凭据、处理畸形的 agent tool calls、把执行上下文传播到子工作流工具、AI builder 编辑工作流时保留节点 ID 并防止自动保存失败循环、Instance AI 触发执行在 queue 模式持久化运行数据等；随后 6/24 又滚出 **v2.27.4** 与预发布 **v2.28.1**（修复 allowlisted Python 包相对导入、Google Ads 节点 API v20→v21、建链节点修复），稳定线 v2.27.3（6/19）、v2.26.8（6/19）、v1.123.60（6/22，修复 21 项 tmp/protobufjs/ws 安全问题）并行维护。可见 n8n 当前把"AI Agent + MCP 生产可靠性 + 安全补丁"作为核心迭代方向。**Flowise** 本周主仓 `pushed_at` 显示 2026-06-24 仍有提交、保持活跃开发，但本期无显著的重大产品/融资公开动态，记为"本周无重大公开动态"。路线判断：n8n 已从"工作流自动化工具"全面转向"AI-native 自动化/Agent 平台"，MCP 与 AI builder 是其下一阶段主战场；Flowise 维持稳定迭代但本周声量较低。
- 关键数据：n8n GitHub Stars **193,946**、Forks **58,814**、open issues 1,484（https://github.com/n8n-io/n8n ，2026-06-25 实时 API）；本周版本 v2.28.0（2026-06-23）、v2.27.4 / v2.28.1（2026-06-24）（https://github.com/n8n-io/n8n/releases ）。Flowise GitHub Stars **53,993**、Forks 24,590、open issues 956、最新提交 2026-06-24（https://github.com/FlowiseAI/Flowise ，2026-06-25 实时 API）。
- 原文链接：https://github.com/n8n-io/n8n/releases ｜ https://github.com/FlowiseAI/Flowise
- 影响判断：n8n 以近 19.4 万 Stars 稳居开源自动化/Agent IDE 榜首（C 组 Stars 第一），本周高频发版+MCP/AI 深度集成，说明开源 Agent IDE 赛道正从"可视化连线"快速演进为"AI 原生编排+企业级可靠性"；其对 MCP 标准的持续投入，与 Databricks Agent Bricks 把 MCP 接入 Unity Catalog 形成呼应——MCP 正成为本周跨 C 组（数据平台/开源 IDE）的共同技术主线。

---

## 本组洞察（开源 / 中国 Agent 平台格局）

1. **MCP 成为本周跨阵营的共同主线**：Databricks 把 MCP 接入 Unity Catalog 做企业级数据连接治理，n8n 密集修复/增强 MCP OAuth2 与工具调用可靠性，Dify topics 已含 mcp。MCP（Model Context Protocol）正从"新兴标准"固化为数据平台与开源 Agent IDE 的事实标配接口层。

2. **竞争主轴已从"能不能搭 Agent"上移到"敢不敢上生产"**：本周三大有料对象（Databricks/Dify/n8n）的迭代重心高度一致——安全加固、治理（Unity AI Gateway / 多租户隔离 / 安全补丁）、可观测性与 HITL 可靠性。核心 agent loop 只占 1% 工作量、99% 是生产化技术债（Databricks 语）已成行业共识，平台战争进入"生产化深水区"。

3. **中国 Agent 平台"产品热、开源冷"分化明显**：字节把火力压在闭源商业化的 Coze 3.0/扣子（多 Agent 协作+行业技能包+出海），而开源 Coze Studio 自 4 月起两个月零提交、停在 v0.5.1；反观 Dify（14.6 万 Stars、主分支持续高频提交）与 n8n（19.4 万 Stars、本周连发多版）开源活跃度遥遥领先。开源活跃度与商业化路径的取舍，正成为中外 Agent 平台的关键分野。

4. **Stars 格局速览（2026-06-25 实时）**：n8n 193.9k ＞ Dify 146.5k ＞ Flowise 54.0k ＞ Coze Studio 21.0k。自动化/IDE 类（n8n/Flowise）与 LLM 应用平台类（Dify）领跑，字节开源 Coze Studio 体量仍处第二梯队且本周停滞。

5. **本周"有料度"判断**：Databricks（DAIS 2026 重磅，★最高）、n8n（本周连发 v2.28.0 等多版，★高）为本周真正有实质动态的两个对象；Dify（无 release 但主分支活跃）、Coze（产品余波+开源停滞）、Flowise（稳定迭代无大事）属背景维持级。

