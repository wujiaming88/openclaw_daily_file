---
bucket: agent-infra
layout: single
title: "全球 AI Agent 基础设施研究周报 · 第 4 期（2026-07-02 ~ 07-08）"
date: 2026-07-09 10:20:00 +0800
categories: [AI]
tags: [AIAgent, Agent基础设施, 云计算, AgentCore, Vertex AI, Foundry, MCP, Databricks, Coze, 行业观察]
header:
  overlay_image: /assets/images/posts/2026-07-09-global-ai-agent-infra-weekly-header.png
  overlay_filter: 0.5
  caption: "全球 AI Agent 基础设施赛道 · 2026 第 28 周"
excerpt: "三大云厂本周同步攻长期记忆与规模化：AWS 把 AgentCore 运行时配额一次拉高 5 倍、Google 的 Memory Bank 摄取转 GA、微软 autopilot agents 拿到 Entra 身份；协议层 MCP v2 无状态重写落地，控制面、评测与成本治理成为新主战场。"
toc: true
toc_sticky: true
---

本期聚焦 AI Agent **基础设施赛道**（运行时 / 编排层 / 框架托管），覆盖区间为 **2026-07-02 00:00 → 2026-07-08 24:00（上海时区）** 的完整一周，共扫描 12 个核心对象。

上一周三大云厂刚集体跨进「生产 GA 下半场」，这一周它们几乎同题作答：长期记忆的生产化、运行时的规模化、治理的门槛化。与此同时，协议层的 MCP 完成了一次架构级重写，通用框架把商业价值全面上移到「控制面」——可观测、评测、成本上限、合规授权。谁能把这些托管能力做成企业敢采购的东西，谁就拿到下半场的入场券。

---

## 本周主线

**一、三大云厂同题作答：长期记忆 + 规模化。** AWS 把 AgentCore 运行时默认配额一次上调最高 5 倍、Memory 加上元数据过滤；Google 的 Memory Bank IngestEvents 转 GA、ADK 出 v2.4.0 大版本；微软 Foundry Memory 补上 procedural memory 与 TTL。三家在同一周同时攻「记忆检索质量 + 高并发承载」，说明竞争焦点已从「能不能托管 Agent」下沉到「能不能扛住企业级生产负载并记得住」。

**二、协议层进入企业化深水区。** MCP 官方 SDK 发布首个 v2 beta，用无状态内核重写，配套 2026-07-28 规范 RC 与 Okta 组织级 connector，正把 MCP 推向「AI 工具层的 HTTP」。协议的可治理、可横向扩展，成了比功能更关键的竞争维度。

**三、价值上移到控制面。** LangChain 联手 NVIDIA 打「开放模型 10x 低成本」牌，CrewAI 把 Cost Limit 写进 Agent Control Plane，Databricks 用 Unity AI Gateway 做动态行为级授权，字节 Coze 把资源全押在评测/可观测的 CozeLoop 上。纯编排框架的差异化窗口在收窄，控制面、评测与成本治理成为新战场。

---

## 本周 TOP 5 信号

按对基础设施格局的信号价值排序：

1. **AWS AgentCore 运行时配额一次拉高 5 倍** —— 默认支持最高 5,000 并发会话，标志 AWS 认定 AgentCore 已过 PoC、直接对标企业级高并发生产负载。
2. **MCP v2 无状态重写 + 2026-07-28 规范 RC** —— 官方 SDK 首个 v2 beta，把 MCP 从有状态 session 协议推向可横向扩展、企业可治理的生产级标准。
3. **LangChain × NVIDIA NemoClaw blueprint** —— 开放模型 + Deep Agents，benchmark 0.86 分、成本仅 $4.48（约为次优方案 1/10），直接冲击「必须用闭源前沿模型跑 Agent」的默认假设。
4. **Google ADK v2.4.0 + Marketplace AaaS 通道** —— Workflow-as-Tool、ManagedAgent 把编排原语托管化，A2A/A2UI 开放标准 + Marketplace 分发让 Google 试图成为第三方 Agent 的「应用商店」。
5. **微软 autopilot agents 拿到 Entra Agent ID** —— Agent 作为拥有账号/席位/日历的「数字员工」嵌入 M365，是 AWS/Google 难以复制的生产力套件护城河。

---

## 三大云厂：托管平台的同题异构

### AWS：AgentCore 补齐一体化控制面

本周是 AgentCore 的高产周，恰逢 AWS New York Summit 2026（7 月初），围绕规模化、检索精度、身份治理与生态集成密集出货。

**Runtime 配额大幅上调**：AWS What's New（2026-07-01，InfoWorld 同日转载称「最高提升 5 倍」）宣布 AgentCore 默认运行时配额提高——美东（弗吉尼亚北部）与美西（俄勒冈）默认支持最高 **5,000 个并发活跃会话**，其余所有支持区域为 **2,500 个**；所有可用区域现统一支持 **200 次/秒 agent 交互** 与 **25 个/秒新建会话**，且自动应用到全部企业账户、无需申请。这直接把 AgentCore 从「能跑 demo」推向「能扛企业高吞吐生产负载」。

**Memory 元数据过滤**：AWS ML Blog（2026-07-01）宣布 AgentCore Memory 支持基于属性的元数据过滤（priority/department/time range 等），叠加在 namespace 隔离之上，用于 agent 累积数周交互历史后提升长期记忆检索精度。**Identity 复用自有 Secrets Manager**：AWS re:Post（约 2026-07-07）宣布可在 AgentCore Identity 凭证提供程序中直接引用已有 AWS Secrets Manager secret，用户对加密、轮换、打标签与访问策略拥有完整所有权——面向合规/治理敏感的企业。

**harness 转正 GA**：据第三方月报（usage.ai）梳理，AgentCore harness 在 2026 年 4 月 What's Next 活动预览后本季转入正式可用，按标准 Bedrock 基础设施费率计费；同时 Bedrock Agents Classic 已进入维护模式（maintenance mode），AWS 明确推荐新建 agent 一律走 AgentCore，并在开发一个从 Classic 直迁 harness 的迁移 skill。**Knowledge Bases 深度集成**：NY Summit 上 Bedrock 全托管 Knowledge Bases（原生数据连接器、Smart Parsing 多格式解析、复杂多步查询的 Agentic Retriever）宣布与 AgentCore 全面集成。

技术路线判断：AWS 本周把 AgentCore 打造成「托管运行时 + 记忆 + 身份 + 网关 + 知识」的一体化控制平面，全面接管 Classic，规模化与治理是本周主线。

关键数据：Runtime 配额 5,000 并发会话（us-east-1/us-west-2）、2,500（其他区域）、200 交互/秒、25 新会话/秒（[AWS What's New](https://aws.amazon.com/about-aws/whats-new/2026/07/amazon-bedrock-agentcore-increases-default-runtime-quota-limits/)，2026-07-01；[InfoWorld](https://www.infoworld.com/article/4192220/aws-raises-agentcore-runtime-quotas-by-up-to-5x-to-help-enterprises-scale-ai-agents.html) 转载「最高 5 倍」，2026-07-01）；Memory 元数据过滤（AWS ML Blog，2026-07-01）；Python SDK bedrock-agentcore **v1.16.0**（最新 release，新增 MemoryClient.create_event 的 extraction_mode 参数 #550；v1.15.1 含 A2A/AG-UI ping 响应修正、批量 evaluation 增加 KMS/tags/在线数据源，[GitHub releases](https://github.com/aws/bedrock-agentcore-sdk-python/releases)，查阅 2026-07-09）。另见 [Identity/Secrets Manager 原文](https://repost.aws/articles/AR3ArUSPp_QBW8fKs9H9uFOw/referencing-your-own-aws-secrets-manager-secrets-in-amazon-bedrock-agentcore-identity)。

配额 5x 上调是清晰的「生产化」信号——AWS 认为 AgentCore 已过 PoC 阶段，直接对标企业级高并发。Classic 转维护模式 + 统一推荐 AgentCore，标志 AWS 完成 agent 平台的代际收敛，减少产品线分裂。Identity/Memory 的治理与检索精度增强，瞄准的是最难啃的受监管大客户。

---

### Google：ADK 大版本 + Marketplace 分发

Google 本周动作密集且高质量，主线是「托管运行时长期记忆能力 GA + 开源 ADK 大版本 + Agents-as-a-Service 商业化闭环」。

**ADK Python v2.4.0**（2026-07-07，正落在本周窗口）是功能密集的大版本，核心新增包括——Workflow as Tool（把工作流作为工具的核心特性，强化多 agent 编排）；ManagedAgent（由 Managed Agents API 支撑的托管 agent 抽象）；Vertex AI session service 支持 session TTL 与过期；DiscoveryEngineSearchTool 与 Google API tools 的 mTLS 支持（企业安全）；labs 中新增 OpenAI Responses API 支持（跨模型互操作）；memory 新增 Vertex AI load_profiles 工具；interactions 支持流式 thought/media/code-exec/function-result 增量与 grounding+usage 元数据；DatabaseSessionService 支持复用已有 SQLAlchemy AsyncEngine；BigQuery analytics 增加 thinking/tool-use token 列与 OTel 关联。

**Memory Bank（Agent Engine 托管长期记忆）双更新**：Google Cloud release notes（2026-07-08）宣布 Memory Bank IngestEvents API 转 GA——将事件摄取与记忆生成解耦，可持续流式写入并配置记忆生成触发时机，GA 特性含 overlap_event_count（跨生成窗口保留上下文）、revision_labels/revision_ttl/disable_memory_revisions（记忆修订管理）、metadata+metadata_merge_strategy（结构化元数据）；同日 Memory Bank 新增对 gemini-embedding-2 嵌入模型的相似度搜索支持（仅限 global/us/eu 端点）。

**Gemini Enterprise 治理与商业化**：release notes（2026-07-07）宣布数据连接器的托管组织策略约束转 GA（限制允许的数据源如 Jira/Box/Confluence、限制出站 FQDN）；Google Cloud Blog（约 2026-07-08）发布《Publish agents in Gemini Enterprise and Google Cloud Marketplace》，正式铺开「SaaS → Agents-as-a-Service（AaaS）」路径：第三方 agent 经 Google Cloud Marketplace 上架并部署到 Gemini Enterprise app，强制要求遵循 A2A 协议、提供 A2A Agent Card（声明 skills/认证/端点的 JSON）、支持 OAuth 2.0 授权码流程、集成 Procurement API，并可选 A2UI 协议生成交互式界面。同期博客《20 questions for the agentic enterprise》再次强调 A2A 作为跨 agent 发现/上下文传递/安全委派的开放标准。

技术路线判断：Google 把差异化押在「开放协议（A2A/A2UI）+ 开源 ADK 开发者心智 + Marketplace 商业分发」三位一体，用生态开放对冲 AWS/Azure 的一体化优势。

关键数据：[ADK Python v2.4.0](https://github.com/google/adk-python/releases)（2026-07-07 release，含 Workflow as Tool、ManagedAgent、session TTL、mTLS、OpenAI Responses API 等，查阅 2026-07-09）；Memory Bank IngestEvents GA、gemini-embedding-2 相似度搜索支持（2026-07-08）、Gemini Enterprise 数据连接器托管组织策略约束 GA（2026-07-07）（[Google Cloud release notes](https://docs.cloud.google.com/release-notes)）；Grok 4.1 模型族在 Gemini Enterprise Agent Platform 弃用、2026-08-20 停服（需迁移到 Grok 4.2/4.3 或 Model Garden 其他模型，同上 release notes）。另见 [Marketplace 发布博客](https://cloud.google.com/blog/topics/developers-practitioners/publish-agents-in-gemini-enterprise-and-google-cloud-marketplace)。

ADK v2.4.0 的 Workflow-as-Tool + ManagedAgent 说明 Google 在把「编排原语」标准化并托管化，降低多 agent 系统搭建门槛。Memory Bank IngestEvents 转 GA 与 AWS AgentCore Memory 元数据过滤形成正面对位——两家本周都在攻长期记忆的检索质量与流式摄取。最具战略意义的是 Marketplace AaaS 通道：Google 试图用开放标准 + 分发计费闭环，把自己变成第三方 agent 的「应用商店」。

---

### 微软：Agent 即数字员工

微软本周的核心叙事是「Build 2026 之后的兑现周 + 治理即门槛」，多条 6 月承诺在 7 月初落地并伴随月报公开。

**Foundry June 月报**（2026-07-07 发布，落在本周窗口）系统性披露：Foundry agents 发布到 Microsoft 365 Copilot 与 Teams 已于 6/10 转 **GA**，兑现 Build「GA in June 2026」承诺——任意 agent 可几步发布到 M365/Teams，无需按 surface 重建，走统一受治理发布管线；交互范式从「prompt→response」转为「goal→持续执行→检查点→协作」。

**autopilot agents（公共预览）**是全新 agent 品类，拥有独立 Entra Agent ID 用户账号 + 生产力许可证（自带邮箱、日历、OneDrive、Teams 存在、组织架构位置），面向 Teams 群聊等共享空间协同工作；参考实现为 Foundry Workstream Manager 示例 agent。**Toolboxes 扩展**（均预览）新增 Skills、Work IQ、Fabric IQ、Browser Automation（基于 Playwright 的 MCP 原生 web 自动化）、Tool Search（运行时只检索最相关工具，用 tool_search/call_tool 元工具替代扁平工具列表，解决 200+ 工具时 token 爆炸问题），并新增 Routines（预览，定时/触发式 agent 运行控制）。

**Memory 生产化**：新增 procedural memory、管理体验与 TTL 控制；Agent Optimizer 进入私有预览（evaluate→生成候选→排名→部署闭环）。**Claude 在 Foundry 转 GA**（约 2026-07-02，InfoQ/TechTimes 报道）：Claude Opus 4.8、Haiku 4.5、Sonnet 5 在 Azure 上 GA，走 MACC 计费、Entra ID 认证、企业治理，Foundry Agent Service 可用 Claude 作多步 agent 的推理核。**治理即门槛**：多方报道（azure-garage、aitechpartner）指出自 2026-07 起 Foundry 部分安全能力不再经 Defender for Cloud 授权，转由 Agent 365 承载；Build 已将 Agent 365 SDK 推 GA，把身份/策略/数据管控内建进 agent 构建。

技术路线判断：微软押注「agent 即数字员工（Entra Agent ID + M365 席位）+ 治理内建 + 多模型（含 Claude）」，深度绑定 M365/Teams 生态与企业 IT 治理体系。

关键数据：Microsoft Agent Framework **.NET v1.13.0**（本周最新）：新增 Foundry Hosting 每用户会话隔离 + Responses v2 协议 fast-fail（#6832）、Skills API 从 Experimental 转正（#6861）、新增 skill approval options（#6843）、[BREAKING] 新增文件编辑工具（#6807）、Azure.AI.Projects 升至 2.1.0-beta.4（[GitHub releases](https://github.com/microsoft/agent-framework/releases)，查阅 2026-07-09）；Claude on Foundry GA：Opus 4.8 / Haiku 4.5 / Sonnet 5（约 2026-07-02，[InfoQ](https://www.infoq.com/news/2026/07/claude-foundry-ga-europe/)）；SDK 收敛：Java azure-ai-projects 2.1.0 GA、Python/JS-TS 向 2.3.0 收敛（将 Hosted Agents 与 Toolboxes 从 beta 升 stable，指向 Hosted Agents「early July 2026」GA 临近，[Foundry June 月报](https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-june-2026/)）。

autopilot agents + Entra Agent ID 是微软最独特的杀手锏——把 agent 作为拥有账号/席位/日历的「数字员工」嵌入 M365，是 AWS/Google 都无法轻易复制的 OS + 生产力套件护城河。Tool Search 直击大工具集的上下文膨胀痛点，工程成熟度高。Claude GA 显示微软在自研模型之外坚持多模型开放，用 Anthropic 补强推理核；「治理即门槛」（Agent 365）把合规变成采购前置条件，绑定企业 IT。

---

### 三大云厂：格局正在怎么变

本周三大云厂在 agent 托管平台上呈现清晰的「同题异构」。**趋同点**是三家都在本周同步强攻两件事：长期记忆的生产化（AWS AgentCore Memory 元数据过滤、Google Memory Bank IngestEvents GA、Microsoft Foundry Memory procedural+TTL），以及规模化/工程成熟度（AWS 配额 5x、Microsoft Tool Search 解决工具膨胀、Google session TTL）。

**分野点**在商业化路线：AWS 把 AgentCore 做成「托管集成底座」，用配额与 Classic 收敛巩固生产化心智，靠 Rubrik 等合作伙伴做集成分发；Google 押「开放协议（A2A/A2UI）+ 开源 ADK + Marketplace AaaS」，试图成为第三方 agent 的应用商店与开发者默认框架；Microsoft 押「agent 即数字员工（Entra Agent ID + M365 席位）+ 治理即门槛（Agent 365）」，用 OS/生产力生态构筑最深护城河。

**竞争信号**：Claude 同时登陆 AWS（Sonnet 5，6/30）与 Azure Foundry（Opus 4.8/Haiku 4.5/Sonnet 5 GA），说明模型层日益商品化、平台层的差异化正从「哪个模型」转向「记忆/身份/治理/分发」这些托管能力。总体判断：竞争主战场已从「能否构建 agent」彻底转向「能否在企业里安全、可治理、规模化地运营 agent 车队」，三家路线的胜负手是各自生态锁定的深度。

---

## 模型厂商与通用框架：价值上移到控制面

### OpenAI：Agents SDK 一周两跳

本周 OpenAI Agents SDK（Python，openai/openai-agents-python，Swarm 的官方继任者）迭代活跃，在时间窗内正式发布 **v0.18.0（2026-07-07 published）**，作者 seratch（OpenAI DevRel）。

v0.18.0 核心变化：**RealtimeAgent 默认模型升级为 gpt-realtime-2.1**（PR #3740），紧跟上一版 v0.17.0 刚把默认切到 gpt-realtime-2，说明 OpenAI 实时语音代理模型在一周内连续快跑；`SQLAlchemySession` 新增 Unicode 存储选项（PR #3746），改善多语言会话持久化；可视化 handoff 节点 fillcolor 修复（PR #3744）。更值得记的是紧邻窗口的 **v0.17.0**（含安全强化）：引入 **Sandbox 本地源物化边界收紧**——`LocalFile.src`/`LocalDir.src` 默认必须落在 materialization `base_dir` 内，除非通过 `Manifest.extra_path_grants` + `SandboxPathGrant`（支持 read_only）显式授权（fix #3169 / PR #3177），关闭了一个本地工件越界读取隐患；同时修了 Responses context-management 的 `extra_args` 冲突（PR #3185）。

技术路线判断：OpenAI 把 Agents SDK 明确做成「Responses API + 沙箱 + 实时语音 + 子代理 handoff」的一体化运行时，安全边界（sandbox grant 模型）与实时多模态（gpt-realtime-2.1）是本阶段两条主线；版本号仍在 0.1x 高频小步快跑（一周多个 patch/minor），生态处于快速收敛期。

关键数据：[v0.18.0 发布 2026-07-07](https://github.com/openai/openai-agents-python/releases)；仓库 Stars 27,741、最近 push 2026-07-08（api.github.com/repos/openai/openai-agents-python，2026-07-09 查）；默认实时模型 gpt-realtime-2.1。

OpenAI 以周为节奏推进官方 Agents SDK，实时语音代理默认模型一周两跳（2→2.1），叠加沙箱授权模型收紧，说明其正把「可控执行 + 实时交互」作为差异化护城河；对开发者意味着需持续 pin 版本，也标志 Swarm 已被生产级 SDK 完全取代。

---

### Anthropic：MCP v2 无状态重写

本周 Anthropic 侧最重量级信号来自 **MCP 协议与官方 SDK**。modelcontextprotocol/python-sdk 发布 **v2.0.0b1（首个 v2 beta，published 2026-06-30，紧邻窗口前一天）**，这是**首个完整支持 2026-07-28 MCP 规范**的版本（该规范本周处于 Release Candidate 阶段，目标 2026-07-28 定稿）。

v2 是一次架构级重写：**核心换代**——用 dispatcher/runner 流水线取代 v1 的 session-centric 内核，`ServerRunner` 成纯 handler 内核，单端点同时服务 2025/2026 两代协议；**FastMCP 更名 MCPServer**（装饰器 API 保留）；**新 Client**：`Client(target, mode='auto')` 自动探测 `server/discover` 并回退 `initialize`，支持 URL/stdio/内存对象；**协议类型独立成包** `mcp-types`（仅依赖 pydantic + typing-extensions）。2026-07-28 规范新特性包括：**无状态核心**（self-describing 请求、无握手、纯 HTTP 横向扩展无会话亲和）、**多轮往返请求**（工具/资源可在调用中途索要输入，MCPServer 上 requestState 默认封存加密）、**header-based 路由与缓存**（Mcp-Method/Mcp-Name 头 SEP-2243、ttlMs 缓存 SEP-2549）、**企业级鉴权 SEP-990 身份断言 ID-JAG**；**弃用提示**：roots/sampling/logging setLevel 按 SEP-2577 标记弃用（仅告警）。

此外 Anthropic 本周在产品侧宣布**管理员可通过 IdP（首发 Okta）为整个组织统一配置 MCP connectors**，用户首次登录自动获得访问权限——把 MCP 从开发者协议推向企业 IT 治理层。技术路线判断：MCP 正从「有状态 session 协议」转向「无状态、可横向扩展、企业可治理」的生产级标准，v2 重写 + 企业 IdP 集成是把 MCP 做成「AI 工具层的 HTTP」的关键一跳。

关键数据：[mcp python-sdk v2.0.0b1 published 2026-06-30](https://github.com/modelcontextprotocol/python-sdk/releases)；[2026-07-28 MCP 规范 RC](https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/)；python-sdk Stars 23,563（2026-07-09 查）；claude-agent-sdk-python Stars 7,566、最近 push 2026-07-08。

MCP v2 无状态化 + Okta IdP 组织级 connector 是「协议企业化」的分水岭，直接对标 A2A 等竞争协议，也让 OpenAI Apps SDK 与 Claude 的工具层互通更可行（厂商可移植性）；对基础设施方意味着 MCP 网关/托管服务将成为新的中间件品类。

---

### LangChain：联手 NVIDIA 打开放牌

本周 LangChain 生态最重磅动作是 **2026-07-08 LangChain 与 NVIDIA 联合发布「NemoClaw for LangChain Deep Agents blueprint」**（企业级开放 Agent 参考架构）。该 blueprint 组合三件套：**LangChain Deep Agents Code**（Deep Agents 代码代理框架）+ **NVIDIA Nemotron 3 Ultra**（开放模型）+ **NVIDIA OpenShell runtime**（安全执行运行时），让企业可自定义、私有化部署并低成本运行 Agent。

核心卖点是 benchmark 成绩：**在 LangChain agent eval suite 中，Nemotron 3 Ultra + Deep Agents 取得 aggregate 0.86 分、成本仅 $4.48；次优模型成本 $43.48，即约 10x 更低推理成本**。LangChain CEO Harrison Chase 强调「改进模型周边系统（记忆、工具使用、评估）才是造更好 Agent 之道」；NVIDIA CEO 黄仁勋称「超级智能体已经到来」。定位上，LangChain 把自己框定为覆盖 build/test/deploy/monitor 全生命周期，LangSmith 作为「框架中立」的可观测/评估层（PR 稿披露 **7,000+ 客户，含 NVIDIA、Bridgewater、LinkedIn、Workday、Harvey、Rippling**）。

开源侧同步小步快跑：**langgraph 1.2.8（2026-07-06）**主要为 delta channel updateState bug 修复 + 依赖升级（websockets 15→16 等）；**langchain 1.3.12（2026-07-08）**为常规 patch。技术路线判断：LangChain 正从「框架公司」升级为「企业 Agent 生命周期平台 + 开放栈参考架构提供方」，与 NVIDIA 绑定用「开放模型 + 自有数据 + 可观测」对冲对闭源大模型的依赖，Deep Agents（长任务/文件系统/子代理）成为其对标 OpenAI/Anthropic 的旗舰产品线。

关键数据：[NemoClaw blueprint 发布 2026-07-08](https://www.prnewswire.com/news-releases/langchain-and-nvidia-launch-nemoclaw-deep-agents-blueprint-for-enterprise-agents-302820446.html)；benchmark 0.86 分/$4.48 vs 次优 $43.48（约 10x 成本优势，同源）；LangSmith 7,000+ 客户；[langgraph 1.2.8 发布 2026-07-06](https://github.com/langchain-ai/langgraph/releases)、langchain 1.3.12 发布 2026-07-08；langgraph Stars 36,817、langchain Stars 141,324（2026-07-09 查）。

LangChain × NVIDIA 用「开放模型 10x 低成本 + Deep Agents harness + OpenShell 安全运行时」打出企业自主可控牌，直接冲击「必须用闭源前沿模型跑 Agent」的默认假设；对基础设施格局意味着「开放栈 + 评估驱动调优」成为企业采购的新叙事，也强化 LangSmith 作为中立可观测层的护城河。

---

### CrewAI：把成本上限写进控制面

CrewAI 本周持续推进「框架 + 平台」双轨，时间窗内发布 **v1.15.2（2026-07-08）**，主线明显向 **Flow（流程编排）与企业控制面（Agent Control Plane / AMP）** 倾斜。

1.15.2 关键特性：crew wizard 支持**动态拉取最新 LLM 模型目录**；支持 **inline skill 定义**与「Flow Definition authoring skill」（把技能/流程作为一等公民声明式编排）；**模板化 Flow action 输入**、flow CEL prompts 文本 helper、streaming frame 协议、AgentExecutor 消息与反馈处理；文档层把 **「Rules」术语统一改为「Policies」** 以匹配新版 dashboard，并**新增 Agent Control Plane 的 Cost Limit（成本上限）规则类型文档**——直接指向企业治理/成本管控。修复项含 model-catalog 缓存按精确 API key 分区、bedrock extra 补 aiobotocore、拒绝自监听 flow 方法、修复 onnx/nltk 安全审计（PYSEC-2026-597）。

背景（近期非本周）：AMP（Agent Management Platform）作为商业控制面提供托管部署、可观测、治理、SSO、on-prem/VPC；定价侧 $25/月 Professional 档在 2025-10 AMP 改名时推出、已于 2026-05 前后下线（背景，非本周）。技术路线判断：CrewAI 正把重心从「多 Agent 编排框架」迁移到「企业 Agent 控制面」，Policies + Cost Limit + 声明式 Flow 是其把 AMP 做成「可过采购审查的治理平台」的关键，呼应本周 Forbes/Forrester 提出的「Agent 控制面/网关正形成独立企业软件品类」趋势。

关键数据：[crewAI v1.15.2 发布 2026-07-08](https://github.com/crewAIInc/crewAI/releases)；仓库 Stars 55,179、最近 push 2026-07-09（api.github.com/repos/crewAIInc/crewAI，2026-07-09 查）；AMP $25/月 Professional 档 2025-10 上线、约 2026-05 下线（背景）。

CrewAI 1.15.2 把 Cost Limit/Policies 写进 Agent Control Plane，标志其商业化核心已从「跑 Agent」转向「管 Agent 的成本与合规」，与 CrewAI AMP 企业叙事一致；在 LangGraph/OpenAI/Anthropic 挤压下，CrewAI 的差异化押注是「声明式 Flow + 企业治理控制面」这一中腰市场。

---

### 模型厂商与框架：差异化窗口在收窄

本周四个对象呈现一条清晰主线：**Agent 基础设施正在从「框架/SDK 竞赛」进入「企业化 + 协议标准化 + 成本/治理控制面」的深水区**。协议层，MCP v2 无状态重写 + 2026-07-28 规范 RC + Okta IdP 组织级 connector，把 MCP 推向「AI 工具层的 HTTP」，企业可治理是关键词。模型厂商 SDK 侧，OpenAI（Agents SDK 沙箱授权 + gpt-realtime-2.1）与 Anthropic（MCP）都在强化「可控执行 + 实时/工具」。通用框架侧，LangChain × NVIDIA 用「开放模型 10x 低成本 + Deep Agents + OpenShell」打自主可控牌，CrewAI 用 Policies/Cost Limit 做企业控制面——两者都在下注「控制面/评估/成本治理」而非纯编排。总判断：谁能把「可观测 + 成本控制 + 合规治理 + 协议互通」做成企业可采购的控制面，谁就能在下一阶段占位；纯框架的差异化窗口正在收窄。

---

## 数据、开源与中国平台：治理与评测上位

### Databricks：数据平台即治理层

Databricks 的旗舰大会 **Data + AI Summit 2026（DAIS 2026）于 2026-06-15~18 在旧金山 Moscone 举办（背景，非本周；32k+ 现场参会）**，但**本周（7/2–7/8）Databricks 官博与社区持续放出 DAIS 后续的深度 recap 与 GA/免费版落地公告，属本周真实动态**。

**2026-07-07 官博《OpenAI and Databricks at DAIS 2026: Making enterprise AI real》**系统阐述 OpenAI × Databricks 合作：OpenAI 提供前沿模型智能与 agents，Databricks 提供「企业上下文与治理」，客户可在 Databricks 平台上用 GPT 模型与 **Codex** 构建自定义 agent，且通过 **Unity AI Gateway** 对每一次 Codex/模型交互做审计、按用户预算控费、流量路由；**Agent Bricks 定位为「解决 agent 系统 99% 隐性技术债（部署/安全/评测/监控/上下文/共享）」的开发平台**，内置的 **Databricks Agent Tools** 让 OpenAI 驱动的 agent 通过 **MCP** 安全受治理地访问企业数据。OpenAI 总裁 Greg Brockman 与 Databricks CEO Ali Ghodsi 同台，OpenAI CFO Sarah Friar 亦在 Exec Forum 露面，并披露「Databricks 是 OpenAI 的营销数据基座」。

**Unity AI Gateway 核心能力在 DAIS 2026 达到 GA**（模型服务、外部模型端点、限流、AI guardrails），并推出 **Contextual Service Policies（Beta）**——从「谁能访问」升级到「当下能做什么」的动态上下文治理：可对推代码、改文件、访问企业系统、处理敏感信息等具体动作做 allow/deny/require-approval，并可按 user/agent/model/MCP service/tool 乃至请求响应内容多维施加，叠加 PII/prompt injection/越狱防护。**Databricks Free Edition 本周扩容**，新增 Genie Code、serverless GPU、Lakebase、**Agent Bricks**、Lakeflow Designer 五项，把 Agent Bricks 下放给学习者/开发者免费试用。

技术路线判断：Databricks 正把 Agent Bricks 打造成「托管企业级 agent 平台」，核心卖点不是模型本身而是「围绕模型的一切」（治理、评测、数据接入、MCP），与 OpenAI 深度绑定形成「前沿智能 + 企业治理」组合拳，直指 Snowflake Cortex，并为其 IPO 叙事加码。

关键数据：DAIS 2026 会期 2026-06-15~18、32k+ 现场（背景，[Databricks 新闻稿](https://www.databricks.com/company/newsroom/press-releases/databricks-announces-2026-data-ai-summit-keynote-lineup-and)，2026-06-02）；[OpenAI 合作 recap 官博发布 2026-07-07](https://www.databricks.com/blog/openai-and-databricks-dais-2026-making-enterprise-ai-real)；Unity AI Gateway GA + Contextual Policies Beta（DAIS 2026，[AdvancingAnalytics](https://www.advancinganalytics.co.uk/blog/all-announcements-on-unity-ai-gateway-at-data-and-ai-summit-2026)，2026-07-03）；Free Edition 新增 Agent Bricks 等 5 项（Databricks Community 公告，约 2026-07-05）；背景：2025 DAIS 首发 Agent Bricks/Lakebase/Databricks One，SQL 产品营收 run rate 达 10 亿美元，2026 完成 100 亿美元 Series J。

Databricks 的 Agent 战略核心是「数据平台即 Agent 治理层」——Unity AI Gateway GA + Contextual Policies 把 agent 治理从静态访问控制推向动态「行为级」授权，这是企业敢放开 agent 自主权的前提，护城河极深。与 OpenAI 的深度绑定（GPT/Codex 原生可用 + 全治理）让 Databricks 成为企业落地 OpenAI agent 的首选托管场，直接挤压 Snowflake 与纯 MLOps 工具。把 Agent Bricks 放进 Free Edition，是典型的 PLG 获客 + 生态卡位打法，为 IPO 前的用户增长铺路。

---

### Dify：从 UI 工具到可脚本化运行时

**本周（7/2–7/8）无新的 GitHub 正式 Release**。截至 2026-07-09 直查 GitHub REST API，Dify 最新正式版仍为 **1.15.0（发布于 2026-06-25，背景，非本周）**，1.15.0 是本轮的重量级版本：引入 **difyctl** 命令行客户端（v0.1.0-alpha），支持从终端直接运行 apps 和 workflows，个人 agent、脚本与 CI 管线无需打开 Web UI 即可调用 Dify 工作流，全平台（macOS/Linux/Windows）单命令安装、无需 access token、二进制带 checksum 校验（PR #37036/#37454）；Workflow & Chatflow & CLI 中开始暴露 CoT（思维链）可见性；大量 UX 重构（重新设计 onboarding、可折叠工作流面板、一键删除确认、「go to anything」命令面板、无障碍改进）。

虽然正式版停在 6/25，但仓库在本周窗口内仍高频提交——REST API 显示仓库 `pushed_at` 为 2026-07-09T01:57Z、`updated_at` 2026-07-09T01:53Z，说明 main 分支持续活跃开发（1.16 前置工作/难点修复）。商业侧背景：Dify 于 **2026-03-10 官宣完成 3000 万美元 Pre-A 轮融资**（背景，非本周），官博持续强调「开源社区 + 企业采用」双轮，企业版提供额外的 enterprise-centric 特性。技术路线判断：Dify 把重心从「可视化 workflow 编排」进一步推向「可编程化/CI 化」（difyctl + /openapi/v1 API），意在从低代码工具升级为可嵌入工程管线的 Agent 运行时，卡位企业级 DevOps 场景。

关键数据：GitHub Stars **148,225**、Forks **23,357**、Open Issues **818**（[api.github.com/repos/langgenius/dify](https://api.github.com/repos/langgenius/dify)，直查 2026-07-09）；[最新 Release 1.15.0](https://github.com/langgenius/dify/releases)（2026-06-25）；Pre-A 融资 3000 万美元（2026-03-10，[dify.ai/blog](https://dify.ai/blog)，背景）。

Dify 已是开源 Agent 平台的头部之一（14.8 万 Stars），difyctl 的推出把它从「UI 工具」变为「可脚本化的 Agent 基础设施」，直接对标 n8n/Flowise 的自动化叙事同时向企业 CI/CD 渗透。本周虽无发版，但高频 commit 说明迭代节奏很快，是开源赛道的活跃度标杆；3000 万美元 Pre-A 为其企业版商业化提供弹药，开源 + 企业双轨模式跑通与否是中国系开源 Agent 出海的风向标。

---

### 字节 Coze：资源全押在评测平台

Coze 的开源体系由两大仓组成——**Coze Studio（可视化 Agent 开发工具）** 与 **Coze Loop / CozeLoop（Agent 全生命周期评测/可观测/优化平台）**，均于 2025-07-26 正式开源（背景）。本周（7/2–7/8）**真正活跃的是 coze-loop（coze-dev/coze-loop）仓库**：直查 GitHub API，coze-loop 的 pushed_at 为 **2026-07-08T16:03Z**，本周窗口内合入了一批 evaluation / observability 方向的 feature 与 fix（PR #569–#576）。

关键改动包括：**新增独立窄接口 UpdateExptRunConf（PATCH /experiments/:expt_id/run_conf，#574）**，支持对 Pending/Processing 状态的实验在线修改评测并发度（ItemConcurNum）与数据行最大重试次数（ItemRetryNum）；**为 CreateAnnotation/DeleteAnnotation OpenAPI 增加按 workspace 的独立限流（#576）**，annotation 写接口与 query 接口在 Redis 层隔离限流桶；GetTrace API 支持用 logid 或 trace_id 任一维度取 trace（#573）；修复 Anthropic Claude 并行工具调用时单条 role:tool 消息含多个 tool_call_response 被覆盖丢失的 bug（#575）；修复评测导出签名 URL 编码、大字段上传对象存储重试、异步 eval target 轨迹抽取起点、以及 callEvaluators goroutine 池泄漏（生产环境观测到约 3900 僵尸 goroutine、占 80%，#569）；webhook 通知支持多环境泳道 header（#571）；实验名长度上限从 65 放宽到 200（#572）。

值得注意：这些 commit 大量标注 Co-Authored-By: Claude Opus 4.8，显示 Coze 团队在用 AI 辅助编码高强度推进评测平台。相较之下 **Coze Studio 主仓 pushed_at 停在 2026-04-20（本周无提交/无发版，偏静默）**。coze-loop 最新正式 Release 仍是 v1.5.1（2026-01-20，背景），本周为 main 分支持续迭代但未打新 tag。技术路线判断：Coze 本周把资源集中在「评测与可观测（Loop）」而非「编辑器（Studio）」，说明其战略重心正从「降低 Agent 搭建门槛」转向「Agent 上线后的质量度量与运维闭环」，这是企业级 Agent 落地最痛的环节，也是字节把火山引擎商业化能力与开源社区打通的关键抓手。

关键数据：[coze-dev/coze-loop](https://api.github.com/repos/coze-dev/coze-loop) Stars **5,594**、Forks **772**、Open Issues **65**、pushed_at **2026-07-08T16:03Z**（直查 2026-07-09）；[coze-dev/coze-studio](https://api.github.com/repos/coze-dev/coze-studio) Stars **21,132**、Forks **3,074**、pushed_at **2026-04-20**（直查 2026-07-09）；本周合入 PR #569–#576（2026-07-03 ~ 07-08）；开源首发 2025-07-26（背景，[极客公园](https://www.geekpark.net/news/352159)）。另见 [coze-loop commits](https://github.com/coze-dev/coze-loop/commits/main)。

Coze 本周所有可见公开动作都集中在 **CozeLoop 评测/可观测平台**而非编辑器，信号明确：字节认为 Agent 竞争已从「能不能搭」进入「搭出来好不好用、可不可运维」的下半场。在线改运行配置、限流隔离、trace 双维度检索等都是面向大规模企业/多租户生产场景的硬需求，指向火山引擎的企业商业化；Coze Studio 主仓本周静默值得持续观察——是节奏性停顿还是重心转移，将影响其对 Dify/n8n 的开源竞争态势。

---

### n8n 与 Flowise：开源 IDE 三足格局

**n8n 本周有密集发版，属本周重大动态**。直查 GitHub API，n8n-io/n8n 本周（7/2–7/8）连续发布多个正式 tag，包括 **n8n@2.30.1、n8n@2.29.8（均 2026-07-08）、n8n@1.123.64（2026-07-08，1.x LTS 维护线）**，仓库 pushed_at 为 2026-07-09T02:00Z，处于每日高频迭代节奏；n8n 已迈入 2.x 主版本，并行维护 1.x LTS，显示其企业客户基数大、需要长期支持线。n8n 定位为「面向技术团队的工作流自动化 + AI Agent 编排」平台，是本轮开源 Agent IDE 里 Star 数最高的项目（19.5 万）。

**Flowise 本周相对静默**：FlowiseAI/Flowise 最新正式版为 **flowise@3.1.3（2026-06-25，背景，非本周）**，本周仓库 pushed_at 2026-07-06（有零星提交但无新 tag/无重大发布）。Flowise 定位可视化 LLM/Agent 编排（LangChain 生态友好），Star 5.44 万。技术路线判断：两者代表开源 Agent IDE 的两条路线——n8n 走「通用自动化 + AI 增强」（更偏 iPaaS/DevOps），Flowise 走「纯 LLM/Agent 可视化编排」（更偏 AI 原生）；本周 n8n 的高频发版与体量优势明显拉开身位。

关键数据：[n8n-io/n8n](https://api.github.com/repos/n8n-io/n8n) Stars **195,726**、Forks **59,180**，本周发版 n8n@2.30.1 / 2.29.8 / 1.123.64（均 2026-07-08，直查 2026-07-09）；[FlowiseAI/Flowise](https://api.github.com/repos/FlowiseAI/Flowise) Stars **54,448**、Forks **24,678**、最新 Release flowise@3.1.3（2026-06-25，背景）。

n8n 以 19.5 万 Stars 稳居开源自动化/Agent IDE 头部，2.x 与 1.x LTS 双线维护说明其已进入「企业级基础设施」阶段，是 Dify/Coze 之外西方开源阵营的关键力量。Flowise 本周虽静默但仍是 LangChain 生态里最主流的可视化编排工具之一；两者与 Dify 共同构成「开源 Agent 编排」的三足格局。本周无公开融资动态，主要看点是产品迭代速度——n8n 的发版频率是开源赛道健康度的强信号。

---

### 开源与中国平台：从编辑器上移到运维

本周最清晰的信号是：**开源 Agent 赛道的竞争重心正从「编辑器/编排器」上移到「运行时治理、评测与可观测」**。三大标志：字节 Coze 本周把全部可见资源投向 CozeLoop 评测/可观测平台（在线改运行配置、限流隔离、trace 双维检索、goroutine 泄漏修复），而编辑器 Coze Studio 主仓静默——说明字节判断 Agent 已进入「可运维」的下半场；Databricks 用 Unity AI Gateway GA + Contextual Service Policies 把治理从「谁能访问」推向「当下能做什么」的动态行为级授权，并靠深绑 OpenAI（GPT/Codex 全治理）卡位企业 agent 托管；Dify 推出 difyctl 把平台从「UI 工具」变为「可脚本化/CI 化的 Agent 运行时」。

横向看，**开源 Star 座次**为 n8n（19.5 万）> Dify（14.8 万）> Flowise（5.44 万）> Coze Studio（2.11 万）> CozeLoop（0.56 万）；n8n/Dify 的高频发版是赛道活跃度标杆。中国系（Coze/Dify）与西方系（n8n/Flowise/Databricks）都在向企业级「治理 + 评测 + 运维」闭环收敛，谁先跑通「开源引流 → 企业变现」的双轨模式，谁就能在 Agent 基础设施的下半场胜出。

---

## 写在最后

把三组放到一起看，本周的方向出奇一致：竞争的重心正从「能不能造出 Agent」整体上移到「能不能在企业里安全、可治理、规模化地运营 Agent」。三大云厂同题攻长期记忆与规模化，协议层用 MCP v2 无状态重写换取企业级可扩展与可治理，通用框架和开源阵营则把商业价值集中押注在控制面——可观测、评测、成本上限、行为级授权。托管运行时的门槛已经不再是「有没有」，而是「记得住、扛得住、管得住」。下半场的胜负手，落在各自生态锁定的深度与治理的可信度上。
