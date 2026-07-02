# 全球 AI Agent 基础设施研究周报 · 第 3 期

- **覆盖区间**：2026-06-25 00:00 → 2026-07-01 24:00（上海时区）
- **生成日期**：2026-07-02
- **研究范围**：AI Agent 基础设施赛道（运行时 / 编排层 / 框架托管），11 个核心对象
- **质量门控**：四维全过（覆盖率 11/12·A组三大云厂100% / 原文深度抽查5个URL真实 / 判断质量四维齐 / 数据可信交叉验证）

---

## 本周 TOP 5 信号

1. AWS AgentCore 一整排组件同周 GA（Web Search/Managed KB/Harness/评估三件套 + Gateway 统一治理面 + WAF/SOC）——托管 Agent 平台正式进入生产平台阶段。
2. 三大云厂同步跨进生产 GA 下半场（AWS 平台成型 / Google Vertex 收编进 GEAP + 语义治理 SGP / 微软 Hosted Agents 临 GA + MAF 统一 SK/AutoGen）。
3. Anthropic 模型因 cyber 能力遭美出口管制、一度全球下线又于 7/1 复活——监管中断风险成 Agent 选型一等考量。
4. 「子代理」范式跨厂商共识化（OpenAI GPT-5.6 ultra mode 与 LangChain Deep Agents 动态子代理同周撞车）。
5. 字节扣子企业版近翻倍提价（标准版+97%，7/13 生效）+ 开源重心从 Studio 转向评测平台 Coze Loop。

---


## A 组


### Amazon Bedrock AgentCore（AWS）
- 本周动态：本周 AWS 在 AgentCore 上持续高密度发布，堪称"GA 大爆发周 + 开发者体验重构周"。**（1）产品/GA 层面**：AgentCore 官方 release notes 的「June 2026」条目集中释放多项 GA：① **Web Search Tool 转 GA**——一个全托管、零数据外泄（zero data egress）、数据驻留在客户 AWS 环境内的搜索工具，构建于亚马逊自有搜索基础设施（专有 web 索引 + 结构化知识图谱），以 MCP 内置连接器 target 形式暴露在 Gateway 上，返回带 snippet/源URL/标题/发布日期的排序结果；② **AgentCore Harness 转 GA**（全 AgentCore 支持区域）——用 CreateHarness/InvokeHarness 声明式定义并运行 agent，无需编排代码、无需构建容器，GA 新增默认内置 Memory、通过 LiteLLM 与 **Bedrock Mantle**（解锁 OpenAI GPT-5.5 / GPT-5.4 等模型上 Bedrock）扩展模型商、AWS 策展 skills 目录一键开关、评估与优化、统一可观测性、版本与端点、导出为 Strands 代码；③ **Managed Knowledge Base 转 GA**——全托管 RAG 管线，6 个原生连接器（S3、SharePoint、Confluence、Google Drive、OneDrive、Web Crawler），支持混合检索/文档排序/文本视频音频图像多模态；④ **Recommendations / Batch Evaluations / A/B Testing 三件套转 GA**——构成"agent performance loop"，可在 AgentCore Runtime、Lambda、EKS 乃至非 AWS 环境运行；⑤ **Failure Insights 转 Public Preview**——跨数百会话发现复发性失败模式（含无错误信号的静默行为失败）、解释根因并按影响面排序。**（2）Gateway 大量增强**：AgentCore Runtime targets 转 GA（网关直连 runtime agent，可加 API schema 让策略引擎施加 guardrails、支持请求/响应 interceptor Lambda）、新增 HTTP passthrough targets（可 front A2A agent / 外部 MCP server / 自定义推理端点，统一鉴权+策略+可观测性）、Inference targets（front 模型商，自动处理模型发现/ID 翻译/路径重写）、可强制入站流量仅来自网关（SigV4 用 aws:SourceArn，OAuth 用 allowedWorkloadConfiguration）。**（3）安全合规**：AgentCore 通过 SOC 合规（纳入 SOC 1/2/3 报告范围）；AWS WAF 对 AgentCore Gateway 的保护转 GA（可挂 WAF protection pack 做 IP 访问控制、限速、AWS 托管规则组含 Bot Control，网关级一次配置全 target 生效）。**（4）Runtime 扩容**：默认服务配额大幅提升——活跃会话 us-east-1/us-west-2 由 1000→5000、其他区 500→2500；InvokeAgentRuntime 由 25 TPS→200 TPS/agent/账户；容器部署新会话创建率 100→400 TPM/端点；新增交互式 Shell（Terminals），每会话最多 10 个并发 shell，跨命令保持环境变量/工作目录/进程状态。**（5）开发者体验重构**：AWS 推出全新 **`@aws/agentcore` npm CLI（Node.js 20+）**，取代旧的 Python `bedrock-agentcore-starter-toolkit`（两者命令名都叫 agentcore，会提示卸载旧版），提供 TUI 交互式向导 + `create/dev/deploy/invoke` 命令，支持 harness/memory/credentials/gateway/evaluators/knowledge-base/policy-engine(Cedar)/payments(x402 协议 pay-per-call) 等海量资源声明；同期 AgentCore CLI v0.19.0 + CDK constructs v0.1.0-alpha.36 加入 Payments 支持；Step Functions 原生集成 AgentCore harness（可视化 builder 内联建 harness、并行/串行编排 + 人工审批）。**（6）技术路线判断**：AWS 正把 AgentCore 从"托管 Runtime"推向"全生命周期 agent 平台"——Gateway 成为一切外部能力（工具/推理/A2A/MCP/搜索）的统一治理面，Guardrails/WAF/SOC 补齐企业安全，performance loop（评估→推荐→A/B→洞察）补齐运营闭环，Harness + 新 CLI 大幅降低"零代码建 agent"门槛，明显在对标 Google Agent Engine 与微软 Foundry 的托管+治理一体化叙事。
- 关键数据：
  - Runtime 活跃会话配额：1000→5000（us-east-1/us-west-2）、500→2500（其他区）；InvokeAgentRuntime 25→200 TPS/agent；容器新会话 100→400 TPM/端点（来源：AgentCore release notes「June 2026」https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ，读取于 2026-07-02）
  - 新 CLI 包名 `@aws/agentcore`（npm，需 Node.js 20.x+）；Bedrock 默认模型 us.anthropic.claude-sonnet-4-5-20250514-v1:0（来源：https://github.com/aws/agentcore-cli ，读取于 2026-07-02）
  - AgentCore CLI v0.19.0 / CDK v0.1.0-alpha.36 加入 Payments（来源：同 release notes）
  - 背景（非本周）：AgentCore 2025-10 GA，覆盖 9 个 AWS 区域；消费型定价含 12 组件（来源：awsinsider.net 2025-10-23；cloudburn.io 2026-05-14）
- 原文链接：
  - https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
  - https://aws.amazon.com/about-aws/whats-new/2026/06/aws-waf-amazon-bedrock-agentcore/ （WAF 支持 GA，约 2026-06-30）
  - https://aws.amazon.com/blogs/machine-learning/its-safe-to-close-your-laptop-now-hosting-coding-agents-on-amazon-bedrock-agentcore/ （托管 Claude Code/Codex/Kiro/Cursor 等编码 agent）
  - https://aws.amazon.com/blogs/machine-learning/build-generative-ui-for-ai-agents-on-amazon-bedrock-agentcore-with-the-ag-ui-protocol/ （AG-UI 协议 + FAST 模板，约 2026-07-01）
  - https://github.com/aws/agentcore-cli
- 影响判断：AWS 本周的信号极强——不是单点更新而是"平台成型"：Web Search/KB/Harness/评估三件套一次性转 GA，意味着 AgentCore 的托管运行时+RAG+运营闭环已进入生产可用阶段；Gateway 演进为跨 A2A/MCP/推理/工具的统一治理入口 + WAF/Guardrails/SOC 合规，直接瞄准企业采购门槛。新 Node CLI 取代 Python toolkit + 支持 Claude Code/Codex/Cursor 托管，是在抢"编码 agent 运行基座"这一高价值场景。三大云厂中，AWS 本周动作最密、最偏"平台完备度"。

---

### Google Vertex AI Agent Engine + Agent Builder + ADK / Gemini Enterprise（Google Cloud）
- 本周动态：本周 Google 侧最重磅的是**品牌/架构大整合**——官方文档明确「Vertex AI is now part of Gemini Enterprise Agent Platform」，且「Agent Builder is now part of Gemini Enterprise Agent Platform」，模型支持信息也迁入 GEAP > Models（读取于 2026-07-02，文档条目标注为「2 days ago」）。即 Google 把原 Vertex AI Agent Engine、Agent Builder、模型服务统一收编进「Gemini Enterprise Agent Platform（GEAP）」顶层品牌，与面向业务终端的「Gemini Enterprise」应用层形成"平台层+应用层"双层结构。**（1）GEAP 平台层本周更新（精确落窗内）**：① 07-01「Provisioned Throughput: Multiple pending new orders」转 GA——同一模型同一区域最多提交 7 个待处理订单；② 06-29 Memory Bank 默认生成模型由 Gemini 2.5 Flash 升级为 Gemini 3.5 Flash；③ 06-29「Semantic Governance Policies（SGP）」进 Public Preview——运行时对 agent 拟发起的工具调用做"意图对齐"评估的智能安全/合规层，核心能力含自然语言约束(NLC，英文写声明式业务规则无需改代码重部署)、分层意图门控(拦截运行时工具调用防越权/流氓工具/数据外泄)、细粒度作用域(对特定工具/参数施加财务额度或地理限制)、Agent Skills 生命周期治理(防上下文投毒与供应链攻击)、Dry Run 模式(Log Explorer 观察裁决后再启用)；④ 06-29 PT 事件邮件通知转 GA。**（2）Gemini Enterprise 应用层本周更新**：① 06-25「Agent Registry 治理」GA——可从 Agent Registry 目录选 A2A agent 或自定义 MCP server 加入 Gemini Enterprise 应用，并经 Agent Gateway egress 策略对流量设 allow/deny；② 06-25「View agent identity」GA——管理员可在 Agent 详情页查看 agent 身份(通常是 SPIFFE ID，未发布则回退 Agent Registry 资源 ID)；③ 06-25 Lovable 数据存储进 Preview + Airtable/Freshservice/Google Stitch/Zoho 新动作；④ 06-26 Confluence Data Center 联邦数据存储 GA；⑤ 06-29 Jira Data Center + HubSpot 联邦数据存储 GA；⑥ 06-30 SharePoint 过滤器 GA + 印度(IN)/新加坡(SG)区域以 at-rest 数据驻留(DRZ)+机器学习处理(MLP)在区 GA(allowlist)。**（3）模型侧**：Google Cloud「What's New」Jun29–Jul3 宣布 Claude Sonnet 5 上线 Agent Platform（作为 Sonnet 4.6 drop-in 替换，强化推理/代码生成/computer use）；Gemini 3.1 Pro 在 Vertex AI/Gemini Enterprise 预览(约6天前)。**（4）背景锚点（近2周非窗内但构成语境）**：06-18 Agent Gateway、Agent Observability、Agent Registry 三件套均转 GA，Agent Identity API 进 Preview，是本周 06-25 应用层"消费"Agent Registry 与 SPIFFE 身份的底座。**（5）技术路线判断**：Google 走"统一平台品牌 + A2A/MCP 原生 + SPIFFE 身份 + 语义治理"差异化路线——SGP 的"运行时意图门控"是三大云厂里最语义化/AI 原生的治理叙事(对标 AWS Cedar+Guardrails、微软内容安全)；Agent Registry+Agent Gateway+SPIFFE 身份构成完整的"多 agent 互联治理"栈，明显押注 A2A 生态。
- 关键数据：
  - Memory Bank 默认模型 Gemini 2.5 Flash → Gemini 3.5 Flash（2026-06-29，来源：GEAP release notes https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ）
  - PT 单模型单区域最多 7 个待处理订单（2026-07-01 GA，来源同上）
  - 印度/新加坡区域 GA(allowlist)，支持 in-region DRZ+MLP 与 Gemini 3.5 Flash（2026-06-30，来源：Gemini Enterprise release notes https://docs.cloud.google.com/gemini/enterprise/docs/release-notes ）
  - Claude Sonnet 5 上线 Agent Platform（Jun29–Jul3，drop-in 替换 Sonnet 4.6，来源：https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud ）
  - Agent Registry 支持 A2A v1.0（06-18 GA 背景，来源：GEAP release notes）
- 原文链接：
  - https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
  - https://docs.cloud.google.com/gemini/enterprise/docs/release-notes
  - https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud
- 影响判断：本周 Google 最强信号是"平台收编 + 语义治理"：把 Vertex AI/Agent Builder 统一为 GEAP 降低产品线认知碎片；SGP(运行时意图门控+NLC)是对企业最担心的"agent 越权/数据外泄"痛点的高阶回应，比 AWS Cedar 更偏语义/自然语言，差异化明显。Agent Registry 治理+SPIFFE 身份+A2A v1.0 落到应用层，说明 Google A2A 生态从"协议"走向"可治理的生产落地"。Claude Sonnet 5 drop-in 上线延续 Google 多前沿模型托管开放叙事，直接与 AWS Bedrock Mantle(托管 GPT-5.5)打对台。

---

### Microsoft Foundry Agent Service（Azure AI Foundry）
- 本周动态：本周微软处于「Build 2026（6月2日）+ Foundry 门户 GA（6月19日）」两大节点后的密集落地期，本组窗口内（6-25→7-1）最关键的信号是 **Foundry Agent Service「Hosted Agents（托管 agent）」预计"by early July 2026 / 未来30天内"转 GA**——即本周正是其 GA 目标窗口。官方 Build 版「What's New in Foundry」明确：Hosted Agents 是生产级 agent 的托管运行时，每个会话跑在**独立 sandbox**（专属 compute/memory/filesystem），运行时**框架无关**（用 Microsoft Agent Framework、GitHub Copilot SDK、LangGraph、Claude Agent SDK 构建的 agent 无需重写即可部署），支持两种协议：**Responses API**（OpenAI 兼容的有状态交互）与 **Invocations protocol**（无 schema 的 pass-through）。**（1）产品/技术更新**：① Hosted Agents 临近 GA（本周窗口）；② **发布 Foundry agent 到 Microsoft Teams + Microsoft 365 Copilot** 计划 2026年6月 GA（身份/权限/策略自动流转）；③ Foundry Toolkit for VS Code 转 GA；④ **Memory in Foundry Agent Service** 公开预览，含 procedural / user / session 三类记忆；⑤ Toolboxes（意图式工具箱）公开预览、Voice Live 实时语音、Agent Optimizer（预览）、Routines（预览）、incoming A2A endpoint（预览）、Managed MCP servers via connector namespaces（预览）、Fabric IQ / Work IQ 连接（预览）。**（2）框架层——Microsoft Agent Framework（MAF）**：MAF 是本组"harness"维度的核心——它**统一了 Semantic Kernel 的企业基础 + AutoGen 的多 agent 编排**（GitHub semantic-kernel 仓库首页已置顶「Semantic Kernel is now Microsoft Agent Framework」，MAF 1.0 为生产就绪版：稳定 API + 长期支持承诺，经 A2A 与 MCP 实现跨运行时互操作）。背景锚点：**MAF 1.0 GA 于 2026-04-02/03**（.NET + Python 双语言，统一 SK+AutoGen；AutoGen 已于 Q1 2026 进入维护模式，社区 fork AG2 延续 AutoGen 血脉）。Build 版更新含 agent harness（skills/memory/middleware 稳定版）、与 GitHub Copilot SDK 及 Claude Agent SDK 集成（稳定）、Magentic-One 多 agent 编排（稳定）、文件系统/记忆工具与 deep research agent（预览）；MAF 仓库新增「Foundry Hosted Agents：2 行代码部署到 Foundry 托管基础设施」。**（3）商业化/生态**：微软 6 月 Partner Center 公告——**Microsoft 365 Copilot 新增 Copilot Cowork（GA，面向复杂长时多工具任务的 agentic 系统）与 Microsoft Scout**，采用 **Copilot Credits** 用量计费（统一消费货币，覆盖 Copilot Studio、Foundry、Work IQ API）；自 6-1 起 **Microsoft 365 E5 成为新购 Microsoft Agent 365 的许可前置**；**Work IQ**（经 A2A 让 agent 情境化访问 M365 数据）GA。认证体系也重构：APL-7008（Copilot Studio 自定义 agent）6月底退役，新增 AB-100（Agentic AI Business Solutions Architect）与 AB-620（AI Agent Builder Associate）。**（4）客户案例**：Telefónica Spain（Jaime Lluch）证言用 Foundry Agent Service + MAF 在移动网络内/上嵌入 AI，面向 6G 网络优化。**（5）技术路线判断**：微软的差异化是"framework-agnostic 托管 + 深度 M365/Copilot 渠道 + 统一 Credits 商业化"——Hosted Agents 用 sandbox+双协议对标 AWS AgentCore Runtime 与 Google Agent Platform Runtime；MAF 收编 SK+AutoGen 结束了自家框架内耗；而"发布到 Teams/M365 Copilot + Copilot Credits"是三大云厂里最强的**分发渠道 + 变现闭环**（Google/AWS 无同级别的终端办公场景入口）。
- 关键数据：
  - MAF 1.0 GA 日期 **2026-04-02/03**（.NET+Python，统一 SK+AutoGen；来源：https://devblogs.microsoft.com/agent-framework/microsoft-agent-framework-at-build-2026-announce/ 2026-06-03；https://devblogs.microsoft.com/agent-framework/microsoft-agent-framework-version-1-0/ 2026-04-03）
  - AutoGen 于 Q1 2026 进入维护模式，AG2 为社区 fork（来源：uvik.net 2026 综述，交叉见 semantic-kernel 首页 MAF 迁移说明 https://github.com/microsoft/semantic-kernel ）
  - Hosted Agents 预计 early July 2026 / 未来30天 GA；发布到 Teams+M365 Copilot 计划 2026-06 GA（来源：https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-build-2026 与 https://devblogs.microsoft.com/foundry/agent-service-build2026 ）
  - Foundry 门户 GA 2026-06-19（背景，窗前，来源：https://learn.microsoft.com/en-us/azure/foundry/concepts/general-availability ）；AzureML SDK v1 EOL 2026-06-30（来源：devblogs Foundry Dec2025-Jan2026）
  - MAF 定位：.NET 10.0+ / Python 3.10+ / Java JDK 17+（来源：https://github.com/microsoft/semantic-kernel ，读取于 2026-07-02）
- 原文链接：
  - https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-build-2026
  - https://devblogs.microsoft.com/foundry/agent-service-build2026
  - https://github.com/microsoft/agent-framework
  - https://github.com/microsoft/semantic-kernel
  - https://learn.microsoft.com/en-us/partner-center/announcements/2026-june
- 影响判断：本周微软的关键在于 Hosted Agents GA 临门一脚——若如期落地，则三大云厂的"托管 agent 运行时"在 2026 年中全部进入生产 GA 阶段，竞争进入"治理+分发+变现"的下半场。微软独有的杀手锏是把 agent 直接发布进 Teams/M365 Copilot 并用 Copilot Credits 统一计费，把"agent 建好后卖给谁/怎么收钱"这一环补齐，这是 AWS/Google 目前的短板。MAF 统一 SK+AutoGen（AutoGen 退居维护、AG2 社区接棒）标志微软开源框架战略收敛，framework-agnostic 的 Hosted Agents 则同时向 LangGraph/Claude SDK/Copilot SDK 生态张开怀抱，兼顾开放与锁定。

---

## 本组洞察（三大云厂格局变化）
本周（2026-06-25→07-01）三大云厂在 Agent 托管平台上呈现"同步进入生产 GA 下半场、但打法分化"的清晰格局：**(1) 全部完成"托管运行时 + 治理 + 运营闭环"的补全**——AWS 一次性把 Web Search/Managed KB/Harness/评估三件套转 GA 并强化 Gateway 为统一治理面（+WAF/Guardrails/SOC）；Google 把 Vertex AI/Agent Builder 收编为 Gemini Enterprise Agent Platform 并推出语义治理 SGP（运行时意图门控）；微软 Hosted Agents 临 GA、MAF 统一 SK+AutoGen。**(2) 差异化主轴各不相同**：AWS = 平台完备度 + 编码 agent 基座（托管 Claude Code/Codex/Cursor）+ 新 Node CLI；Google = 统一品牌 + A2A/SPIFFE 身份 + 最"AI 原生"的语义治理；微软 = framework-agnostic 托管 + 独有的 Teams/M365 Copilot 分发渠道 + Copilot Credits 变现闭环。**(3) 协议与模型开放趋同**：三家都押 MCP + A2A 互操作；模型侧互相"抢托管"——AWS Bedrock Mantle 托管 GPT-5.5、Google Agent Platform drop-in Claude Sonnet 5，多前沿模型托管成为标配。**核心信号**：竞争焦点已从"能不能托管 agent"转向"谁的治理更可信、谁的分发更近业务、谁的变现更顺"——微软在分发/变现领先，Google 在语义治理领先，AWS 在平台工程完备度与开发者基座领先。


## B 组


### 4. OpenAI Responses API + Agents SDK（含 Swarm 谱系、AgentKit）

- **本周动态**：本周 OpenAI 侧重点集中在模型层而非 Agent 平台层的独立公告，但两者高度耦合。核心事件是 **GPT‑5.6 系列（旗舰 Sol、均衡 Terra、高性价比 Luna）于本周进入"有限预览（limited preview）"**（OpenAI 官方发布说明，releasebot 收录，1天前）。对 Agent 平台的直接意义在于：GPT‑5.6 引入两项面向 Agent 的新推理能力——**新增 "max reasoning effort" 档位**（给 Sol 最长的深度推理时间）与 **全新 "ultra mode"**（"beyond the capabilities of a single agent by leveraging subagents to accelerate complex work"，即原生子代理/多代理编排）。这标志 OpenAI 把 multi‑agent（Swarm→Agents SDK 谱系的核心理念）下沉进模型运行时本身。官方说明明确"models are available via the **Responses API** and our Client SDKs"，即 Responses API 仍是所有新模型的统一入口。预览期模型仅通过 **API 与 Codex** 面向"select group of trusted partners"开放，因涉美政府 cyber 审查而采分阶段放量，"generally available in the coming weeks"。②数据细节：GPT‑5.6 Sol 在 **Terminal‑Bench 2.1**（命令行 Agent 工作流）刷新 SOTA；在 **GeneBench v1**、**ExploitBench²**（约用 Mythos Preview 1/3 output tokens 达到相当水平）、**ExploitGym**（UC Berkeley 与 OpenAI 等合作）上均展示更强 agentic 能力；Terra 性能对标 GPT‑5.5 但便宜 2 倍。③GitHub 侧：`openai/openai-agents-python`（Python Agents SDK）本周持续高频合并 PR，含 websocket max_size 可配置、Chat Completions 工具调用缓冲流式、E2B/Blaxel 沙箱超时修复、Realtime 多 Agent 工具分发歧义修复、重复 MCP server 工具名报错提示等（GitHub releases 页，本周多条 PR #3645/#3506/#3642/#3678 等），显示 SDK 已进入以稳定性、沙箱运行时（sandbox runtime）、Realtime 与 MCP 集成打磨为主的成熟期，而非大版本能力跃迁。技术/商业路线判断：OpenAI 的 Agent 战略正从"SDK 层拼装"上移到"模型原生多代理 + Responses API 统一入口 + AgentKit/Agent Builder 可视化编排"三层协同；ultra mode 把子代理能力做进模型，可能弱化外部编排框架的部分价值。
- **关键数据**：GPT‑5.6 三档（Sol/Terra/Luna）limited preview，Terra 较 GPT‑5.5 便宜 2x（https://releasebot.io/updates/openai ，2026-07-01前后）；Terminal‑Bench 2.1 SOTA、ExploitBench² 约 1/3 output tokens（同源）；Agents SDK 本周 PR #3645/#3506/#3642/#3678（https://github.com/openai/openai-agents-python/releases ，2026-07-02 读取）
- **原文链接**：https://releasebot.io/updates/openai ；https://github.com/openai/openai-agents-python/releases ；https://developers.openai.com/api/docs/models
- **影响判断**：ultra mode 把"子代理加速复杂工作"做进模型运行时，是对 LangGraph/CrewAI 等外部多代理编排框架的正面竞争信号；Responses API 继续作为唯一模型入口，强化 OpenAI 平台锁定。GPT‑5.6 因 cyber 能力被美政府要求分阶段放量，说明前沿 Agent 能力已进入国家安全审查范畴，将影响所有依赖 OpenAI 后端的 Agent 平台的可用性节奏。

---

### 5. Anthropic Claude Agent SDK + MCP（MCP 协议演进、Computer Use）

- **本周动态**：本周 Anthropic 的核心事件是 **出口管制解除与模型恢复上线**，直接关系到所有基于 Claude Agent SDK 的应用可用性。据 Anthropic 官方发布说明（releasebot 收录），6月12日美政府对 Anthropic 最新模型 **Claude Fable 5 与 Claude Mythos 5** 施加出口管制（因 Amazon 研究者报告了绕过 Fable 5 安全护栏、令其识别并演示利用软件漏洞的方法），Anthropic 一度对全体用户暂停两款模型。**6月30日出口管制解除**；**Fable 5 自7月1日（周三）起面向全球用户重新上线** Claude Platform、Claude.ai、Claude Code 与 **Claude Cowork**——Pro/Max/Team 及部分 Enterprise 计划在7月7日前可用至每周用量上限的 50%，之后转为按 usage credits 计费；AWS、Google Cloud、Microsoft Foundry 将"尽快"重新启用。Mythos 5 已于6月26日经美政府批准，向一组美国组织恢复（Glasswing 计划）。②安全细节：Anthropic 训练了新的 safety classifier，被拦截的 Fable 5 请求会通知用户并改由 **Opus 4.8** 处理；新分类器对报告技术的拦截率>99%，但代价是提高了常规编码/调试的误报率。Anthropic 联合 Amazon、Microsoft、Google 等 Glasswing 伙伴启动"共享 jailbreak 严重性评估框架"。③MCP 与生态：本周 MCP 侧动态集中在生态化——Claude 上线 **connector 可观测性公测**（管理员可跨 Claude 产品监控 connector 的采用率、错误、延迟、用量）并支持**从 Claude 内直接提交 MCP connector 到目录**（releasebot，2天前）；社区维护的 Claude Connectors Directory 已记录 **511 个验证过的 MCP 集成、30 个类别**（GitHub awesome-claude-connectors，更新于2026-06-26）。Claude Code 本周多次迭代：新增 sandbox 凭据拦截、组织级模型限制、全屏控制，修复 remote MCP hang、resume、结构化输出等。技术/商业路线判断：Anthropic 把 MCP 从"协议标准"推进到"可运营的企业级连接层"（可观测+目录+提交流水线），这是 MCP 从开发者工具向企业治理基础设施升级的关键一步。
- **关键数据**：Fable 5 出口管制6月30日解除、7月1日全球恢复，7月7日前含至每周用量 50%（https://releasebot.io/updates/anthropic ，2026-06-30）；新 classifier 拦截率>99%、拦截请求改由 Opus 4.8 处理（同源）；Mythos 5 于6月26日经美政府批准恢复给美国组织（同源）；MCP connectors 目录 511 个集成/30 类，更新2026-06-26（https://github.com/rdmgator12/awesome-claude-connectors ）
- **原文链接**：https://releasebot.io/updates/anthropic ；https://releasebot.io/updates/anthropic/claude ；https://releasebot.io/updates/anthropic/claude-code
- **影响判断**：本周事件揭示前沿模型的 Agent/cyber 能力已成国家安全监管对象，Claude Agent SDK 生态的可用性首次因政府管制中断——这对企业选型是重大可用性风险信号。MCP connector 可观测性+目录提交把 MCP 推向企业治理层，强化 Anthropic 作为"Agent 连接标准制定者"的护城河，也为 MCP 对抗 A2A、OpenAI 私有生态提供治理差异化。

---

### 6. LangChain / LangGraph / LangSmith Deployment

- **本周动态**：LangChain 本周产出极为密集，主线是 **Deep Agents（深度代理）架构 + LangSmith 可观测**双轮驱动，而非底层框架大改。①开源/框架：`langchain-ai/langgraph` 本周内发布 **1.2.7（2026-06-29）**，为纯稳定性/修复版——修复 snapshot DeltaChannel overwrite supersteps、Overwrite 的 JSON roundtrip 存活、为 langgraph-api 的 exit-mode delta task_ids 生成合法 UUID（GitHub releases，PR #8223/#8125/#8127/#8165），并同步 CLI 0.4.30（新增“支持兼容 API 版本区间”feat #8023）与大量依赖升级（langsmith 0.8.0→0.8.18、cryptography 46→48 等）。截至本周 LangGraph 约 **36.1k GitHub Stars**（decisioncrafters，2天前，属二手需交叉验证）。②Deep Agents 成为本周官方博客绝对主角：6月29日《Introducing Dynamic Subagents in Deep Agents》（动态子代理，运行时按需生成子代理，直接对标 OpenAI ultra mode 的子代理思路）；7月1日《How to Use RLMs in Deep Agents》《Introducing OpenWiki, an open source agent for repo documentation》（开源仓库文档代理）；6月30日《Running Untrusted Agent Code Without a Sandbox》（无沙箱运行不可信代理代码，安全执行方向）、Harrison Chase 亲撰《Wiki Memory》（代理记忆新范式）。③LangSmith 可观测/Deployment：7月1日案例《How Pendo used LangSmith to trace Novus from user behavior to code fixes》、6月29日《How Candidly Built State-Aware Agent Harnesses with LangSmith》，6月30日《Harbor x LangChain: A Unified Stack for Evaluating Agents》（与 Harbor 合作统一评测栈）；背景：**LangSmith Engine** 已于5月13日发布（背景，非本周）。技术/商业路线判断：LangChain 正把重心从“链/图编排原语”上移到“Deep Agents 参考架构 + LangSmith 作为 Agent 工程平台（调试/评测/一键部署）”，用可观测性与评测（evals）建立商业护城河，LangGraph 本身回归稳定的执行内核角色。
- **关键数据**：LangGraph 1.2.7 发布于 2026-06-29（https://github.com/langchain-ai/langgraph/releases ，2026-07-02 读取）；约 36.1k Stars（https://www.decisioncrafters.com/langgraph-build-resilient-agents/ ，2天前，二手待验证）；CLI 0.4.30、langsmith 依赖升至 0.8.18（GitHub releases 同源）；本周博客密集：Dynamic Subagents 6-29、OpenWiki/RLMs/Pendo 案例 7-1、无沙箱执行 6-30（https://www.langchain.com/blog ）
- **原文链接**：https://github.com/langchain-ai/langgraph/releases ；https://www.langchain.com/blog ；https://releasebot.io/updates/langchain-ai
- **影响判断**：Deep Agents 的“动态子代理”与 OpenAI GPT‑5.6 ultra mode 撞车，说明“运行时按需生成子代理”正成为多代理编排的共识范式；LangChain 抢先以开源参考架构 + 商业可观测（LangSmith）卡位。“无沙箱安全运行不可信代理代码”直指企业最痛的 Agent 安全执行问题，若成熟将显著降低生产部署门槛。LangGraph 进入稳定内核期，意味着竞争焦点已从框架转向平台层（部署+可观测+评测）。

---

### 7. CrewAI AMP

- **本周动态**：CrewAI 本周动态集中在**开源框架迭代 + AMP/Agent Control Plane 企业控制面**的双线推进，核心版本进入 **v1.15.x 预发布序列（1.15.1a1 / 1.15.2a1）**。①开源框架（GitHub releases，本周多条预发布）：新增 **Flow（事件驱动流）能力**——为 flows 定义 stream frame 协议（流式帧协议）、支持内联 skill 定义（inline skill definitions）、在 CrewDefinition 中新增 type tool 与 app、生成 Flow Definition 授权 skill，并新增流式文档；修复“拒绝 self-listening flow 方法”、SSRF 重定向绕过（#6331，安全修复）。CLI 侧：要求显式 CrewAI 项目定义（#6358）、为生成项目初始化 Git 仓库（#6364）、CLI deploy 后自动打开部署页（#6343）——显示 CrewAI 正强化“从 CLI 到云端一键部署”的开发者体验闭环。②AMP/企业化：官方定位 **CrewAI AMP Suite** 为“commercial control plane around CrewAI”，提供 managed deployment、observability、governance、security 与企业支持；本周文档新增 **Agent Control Plane 的 Cost Limit（成本上限）规则类型**（GitHub release notes），是企业级成本治理的直接信号；免费入口为 Crew Control Plane（app.crewai.com）。③生态：Databricks Data + AI Summit 2026（本周，1天前报道）宣布 Agent Bricks/Omnigent 继续兼容 CrewAI、LangGraph、OpenAI Agent SDK、Claude Code SDK 等 harness，CrewAI 作为受支持编排框架被纳入 Databricks 托管代理生态。社区侧：CrewAI 宣称已通过社区课程认证 **超 10 万名开发者**（GitHub README）。技术/商业路线判断：CrewAI 走“开源 Crews+Flows 双原语 + AMP 商业控制面”的经典开源商业化路径，本周 Cost Limit 规则、一键部署、可观测治理均指向 Enterprise 变现，Flows 的流式协议强化其在“精确事件驱动编排”上与 LangGraph 的差异化。
- **关键数据**：v1.15.1a1 / 1.15.2a1 预发布（本周，https://github.com/crewaiinc/crewai/releases ，2026-07-02 读取）；Flow stream frame 协议、内联 skill、SSRF 修复 #6331、CLI 显式项目定义 #6358（同源）；Agent Control Plane 新增 Cost Limit 规则类型（同源 release notes）；社区认证开发者 >100,000（https://github.com/crewaiinc/crewai README）；Databricks DAIS 2026 兼容 CrewAI（https://qubika.com/blog/everything-databricks-announced-dais-data-ai-summit-2026/ ，5天前，属背景边界）
- **原文链接**：https://github.com/crewaiinc/crewai/releases ；https://github.com/crewaiinc/crewai ；https://www.crewai.com/enterprise
- **影响判断**：Cost Limit 规则类型是 Agent 平台“FinOps 化”的明确信号——企业开始把 Agent 运行成本纳入治理，谁先把成本护栏做进控制面谁就更贴近企业采购。CrewAI 用 Flows 流式协议+一键部署+AMP 控制面构建从原型到生产的闭环，与 LangGraph（图执行内核）形成“事件驱动 vs 状态图”的路线分野。被 Databricks 纳入托管生态，说明框架层已被数据平台巨头“harness 中立化”收编，框架厂商的价值正加速向控制面/可观测迁移。

---

## 本组洞察（模型厂商 Agent 平台与通用框架走向）

本周四对象呈现三条清晰主线：**（1）多代理下沉与“子代理”范式共识化**——OpenAI GPT‑5.6 ultra mode 把子代理做进模型运行时，LangChain 同周推出 Deep Agents“动态子代理”，“运行时按需生成子代理”正从框架特性变为跨厂商共识，通用编排框架的部分价值被模型层与参考架构双向挤压。**（2）竞争焦点从框架转向平台层（部署+可观测+评测+治理）**——LangGraph/CrewAI 开源核心均进入稳定/预发布打磨期，真正的商业动作全在 LangSmith（evals/trace/一键部署）、CrewAI AMP（Cost Limit 成本治理、控制面）；MCP 也从协议升级为“可观测+目录”的企业连接层。谁掌握平台层谁掌握变现。**（3）安全与合规成为一等约束**——Anthropic 因 cyber 能力遭美出口管制、模型一度全球下线，OpenAI GPT‑5.6 分阶段放量同样受政府审查；同时 LangChain“无沙箱安全运行不可信代理代码”、CrewAI SSRF 修复与 Cost Limit 均指向“生产级 Agent = 安全执行 + 成本治理 + 政府合规”。选型建议：企业应把“可用性受监管中断风险”和“成本/安全治理能力”提到与功能同等权重。（注：x_search 全程 403 额度耗尽，本组以官方 releasebot/GitHub/官方博客一手来源为主；LangGraph Stars 为二手数据待交叉验证。）


## C 组


### Databricks Mosaic AI Agent Framework / Agent Bricks
- 本周动态：Databricks 在 2026 Data + AI Summit（6/15–18，属**背景，非本周**）密集发布 Agent Bricks、Genie 家族（Genie One / Genie Agents / Genie Ontology）、Unity AI Gateway、Omnigent（Apache 2.0 的"harness of harnesses"编码 agent 元框架，包裹 Claude Code、Codex）等。落在本期时间窗（6/25–7/1）内的是官方产品 Release Notes 的滚动 GA/Beta 上线，含多项与 Agent 强相关能力：①**6/30 Anthropic Claude Sonnet 5 登陆 Model Serving**，作为 Databricks 托管模型经 Foundation Model APIs 调用，官方定位"面向 coding、agentic workflows 与大规模专业工作，近 Opus 级智能 + Sonnet 的成本与速度"——这直接强化 Agent Bricks/AI Runtime 的底层模型选项；②**6/29 Unity Catalog 中以 model services（Beta）治理 Databricks 托管 LLM**：model service 是 UC securable，代表受治理的 LLM endpoint，一次定义跨 workspace 共享、免每 workspace 重复建 endpoint，system.ai schema 提供开箱即用服务，可经 Unity AI Gateway UI / Catalog Explorer / UC REST API 自建；③**6/29 AI Runtime CLI（air）工作负载支持自带 Docker 镜像（Beta）**，用于特定系统库版本/复杂依赖/可复现环境；④**6/29 Genie Code 移除 Chat/Agent 模式选择器，Genie Code 现仅以 Agent 模式运行**（想要纯对话需在 prompt 里显式说明），是从"对话"向"自主执行 agent"收敛的明确信号；⑤**6/30 Lakehouse//RT（Beta）** serverless SQL 仓库，亚秒级读、面向数百到数千并发，服务应用/运营分析/仪表盘——是 agentic 数据访问的实时底座。技术/商业路线判断：Databricks 把"治理"作为 agentic 时代主轴（Unity AI Gateway：从"谁能访问数据"到"agent 实际能做什么"，含 Contextual Service Policies Beta、PII/prompt injection 防护、跨 provider 预算硬上限），并把 Genie 从产品升级为家族 + 以 Omnigent 拥抱外部 coding agent（Claude Code/Codex），路线是"数据+治理为地基、模型可插拔、Agent 编排层开放"。
- 关键数据：Claude Sonnet 5 上线 Model Serving 6/30/2026（https://docs.databricks.com/aws/en/release-notes/product/2026/june）；model services Beta 6/29/2026、AI Runtime 自带 Docker Beta 6/29、Genie Code 仅 Agent 模式 6/29、Lakehouse//RT Beta 6/30、Lakebase Autoscaling 登陆 AWS 东京 ap-northeast-1 6/30、Parquet v2 GA 6/29（同上 release notes）；Unity Catalog 治理组织数 >14,000（DAIS 2026 背景，https://www.databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026, 6/16/2026）；Omnigent 采用 Apache 2.0（https://atlan.com/know/ai-agent/databricks/databricks-data-ai-summit-2026-announcements/, 6/19/2026）
- 原文链接：https://docs.databricks.com/aws/en/release-notes/product/2026/june ；https://www.databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026
- 影响判断：本周的滚动 GA 表明 DAIS 上的 agent 愿景正快速落地为可用产品，Claude Sonnet 5 即时可用 + Genie Code 强制 Agent 模式是把"数据平台"变"agent 运行时"的实操信号；对企业客户，UC 治理 + 模型可插拔的组合是它对抗云厂商原生 agent 平台的核心差异化。

### Dify
- 本周动态：Dify（langgenius/dify）于**6/25/2026 发布 1.15.0**（正处本期窗口）。这是一次面向"CLI 化 + agentic 工作流深化"的实质更新，核心新特性：①**difyctl** 命令行客户端首发（[docs.dify.ai/en/cli/overview]），可直接从终端运行 apps 与 workflows，让个人 agent、脚本、CI 流水线免开 Web UI 调用 Dify workflow；全平台（macOS/Linux/Windows）一条命令安装、无需 access token，二进制以带 checksum 校验的公开 release 发布（PR #37036、#37454）；可向 CLI 工具运行传递 scoped 环境变量，并在 difyctl 与 /openapi/v1 API 上统一友好的错误信息含限流处理（#37324/#37285/#37313/#36896）。②**Workflow/Chatflow/CLI 可见 CoT（思维链）**：把模型推理流式送入专用"thinking"实时面板，最终答案保持干净，刷新后推理仍保留，CLI 与 workflow 预览同样可见（#37460/#37828）。③**更丰富的 Human-in-the-Loop 表单**：workflow 暂停向人求输入时，表单可含下拉选择与单/多文件上传，不再只有自由文本（#36322）。④**支持慢/长耗时模型**：workflow 可用图像/视频生成等长耗时生成模型，节点经轮询机制耐心等待最终结果不超时（#37462）。⑤知识导入从 Excel 内嵌图片提取（#37104）；可为 Phoenix 设自定义 trace session id、追踪文档检索步骤深化 observability（#37056/#37283）；start/output 节点重做、恶意 app/workspace ID 更友好报错。技术/商业路线判断：Dify 正从"可视化 no-code Agent 编排"向"可脚本化/工程化/CI 可集成"演进（difyctl 是关键落子），并强化 agentic 长任务（长耗时模型轮询）与人机协作（结构化 HITL 表单），对标企业级生产可用性。
- 关键数据：Dify 1.15.0 发布 6/25/2026（https://github.com/langgenius/dify/releases/tag/1.15.0）；GitHub Stars 147,292、Forks 23,197、Open Issues 862、最近 push 2026-07-02（GitHub API repos/langgenius/dify，实时查于 2026-07-02）；此前部署量 1M+ apps、5M+ downloads（as of May 2026，二手来源 https://www.swfte.com/blog/dify-vs-swfte-open-source-agent-platform-2026，待官方交叉验证）
- 原文链接：https://github.com/langgenius/dify/releases/tag/1.15.0 ；https://github.com/langgenius/dify
- 影响判断：difyctl 把 Dify 从"UI 优先"扩展到"CLI/CI 优先"，直击开发者与自动化管线场景，与 n8n/Flowise 的差异化在于 LLMOps + RAG + Agent 一体；147k+ Stars 稳居开源 LLM 应用平台第一梯队，CLI + 长任务支持是它守住企业自托管市场的关键动作。

### 字节 Coze / 扣子（ByteDance）
- 本周动态：本期时间窗（6/25–7/1）内，Coze 的一手动态集中在**开源仓库 coze-loop 的持续迭代**与**企业版定价调整的落地临近**两条线。①开源侧：coze-dev/coze-loop（下一代 AI Agent 优化/评测平台）在窗口内有 **5 次 commit**（6/25–6/30），含 [feat][evaluation] 新增 failed evaluator 记录创建与处理（#563）、[fix][evaluation] 新增 OpenAPI extra_output 字段并修复两处水平越权（6/25）、[docs][all] 初始化 "AI coding harness" 文档（#566，6/29）、[fix][evaluation] 实验名格式校验（#567）、[fix][backend] 给 ListSpansRepeat 加 MaxBytes 限制防止过大响应（#568，6/30）——方向是评测（evaluation）能力增强 + 安全越权修复 + 为"AI coding harness"铺文档；而 **coze-studio 本窗口 0 commit**（最近 push 2026-04-20，最新 release 仍是 v0.5.1，2026-02-05），开源主战场已明显转向 coze-loop。②商业化/企业版：扣子官方于 **2026年6月2日（背景，非本周）** 发布《企业版套餐定价调整》公告，但**新价格于 2026年7月13日 12:00 AM 起生效**，恰是本期窗口后的临界事件——企业标准版 ¥498/月→¥980/月（默认席位 2→5，超出席位 ¥29/个/月；月度积分 13.8万→34.5万；版本费 ¥360→¥490），企业旗舰版 ¥5,980/月→¥8,980/月（默认席位 20→30；月度积分 138万→207万；版本费 ¥4,600→¥6,040）；旧团队版/企业版即日起不再支持按年续费，12月31日下线。企业版权益绑定扣子 3.0：接入自定义模型、Seedance2.0 视频创作、云手机/云电脑、多 Agent 与项目协作（连接本地 Agent 数量不限，每项目最多 50 协作者）、行业技能包（自媒体/金融/法律/科研/电商）。③背景（非本周）：扣子 Coze 3.0 于 2026-06-01 全端上线（iOS/Android/Mac/Windows/coze.cn），核心是"项目空间"+多人多 Agent 协作，并支持一键接入本地 Claude Code / Codex CLI / OpenClaw，及云端 Agent（云电脑常驻）。技术/商业路线判断：字节走"上层扣子空间聚合 Agent 生态 + 底层 Studio/Loop 开源立标准"的双层策略；本周信号是它把开源重心押在 **Coze Loop（Agent 评测/可观测/优化）**——这是 agent 工程化最缺的一环，同时用企业版大幅提价（近翻倍）为扣子 3.0 的企业级能力变现。
- 关键数据：coze-loop GitHub Stars 5,569 / Forks 769 / 最近 push 2026-07-01（GitHub API repos/coze-dev/coze-loop，查于 2026-07-02）；窗口内 5 次 commit（同 API commits?since=2026-06-25）；coze-studio Stars 21,079 / Forks 3,067 / 最新 release v0.5.1（2026-02-05）/ 窗口内 0 commit（GitHub API repos/coze-dev/coze-studio）；企业版定价：标准版 ¥498→¥980、旗舰版 ¥5,980→¥8,980，生效 2026-07-13，公告日 2026-06-02（https://docs.coze.cn/guides_enterprise_plan_pricing_adjustment）；扣子3.0上线 2026-06-01（https://www.ithome.com/0/958/372.htm）
- 原文链接：https://github.com/coze-dev/coze-loop/releases ；https://docs.coze.cn/guides_enterprise_plan_pricing_adjustment ；https://www.ithome.com/0/958/372.htm
- 影响判断：企业版近翻倍提价（标准版 +97%、旗舰版 +50%）是字节把扣子 3.0 从"引流免费"转向"企业级变现"的明确拐点，7/13 生效前会催生一波续费抢闸。开源侧押注 Coze Loop（评测/可观测）而非 Studio，说明字节判断"agent 质量与优化"是差异化护城河，与 Databricks 的 Agent Bricks 评测/调优、Dify 的 observability 强化形成同一赛道正面竞争。

### n8n / Flowise 等开源 Agent IDE（动态对象池）
- 本周动态：本期窗口（6/25–7/1）n8n 与 Flowise 均有**版本发布落在窗口内**，纳入本期。①**n8n**：稳定版 **n8n@2.28.4 于 2026-07-01 发布**，同日还推进多个 pre-release（2.29.1/2.29.2）。2.28.4 的 Agent 相关要点：AI Agent Node 修复"在 chat memory 中保留并行 tool call 结构"（#33307）、"在预执行权限检查中跳过 AI Gateway 托管凭证"（#33278）、新增 N8N_RUNNERS_ALLOW_TRANSITIVE_IMPORTS 供 Python task runner 使用（#33266）、editor 在 add-node 搜索里浮出 Human review 节点（#33317）；2.29.2 把 **AIA v3（AI Agent 新版体验）设为默认空状态**（#33361）——n8n 正持续加固其"原生 AI/AI Gateway + Human-in-the-loop"能力。②**Flowise**：**flowise@3.1.3 于 2026-06-25 发布**（正好窗口首日）。最亮点是 **feat: turn chatflow into MCP server（#5930）**——把 Flowise 的 chatflow 直接暴露为 MCP 服务器，接入 MCP 生态；此外 agentflow 增加 client-specific knowledge fields for agent nodes（#6226）、Start 节点表单输入的 client 过滤（#6212）、FlowConfigDialog UI 重设计（#6229）、修复 clickjacking（#6185）、修 chatflow MCP schema 生成中畸形 form option 元数据（#6233）。值得注意：3.1.3 大量 PR 来自带 -wd/-workday 后缀的贡献者（jocelynlin-wd、abdullah-workday、jchui-wd 等），印证 **Workday 已于 2025-08-14 收购 Flowise（背景，非本周）**，开源仓库现由 Workday 团队主导维护。技术/商业路线判断：两者都在窗口内把重心压到"agent + MCP 协议 + 治理凭证"——n8n 走"AI Gateway 托管凭证 + AIA v3"的企业治理路线，Flowise 走"chatflow 变 MCP server"的协议互操作路线，反映开源 Agent IDE 正从"可视化编排工具"升级为"可被更大 agent 生态调用/治理的节点"。
- 关键数据：n8n GitHub Stars 194,830 / 最近 push 2026-07-02 / 最新稳定版 n8n@2.28.4 发布 2026-07-01（GitHub API repos/n8n-io/n8n + https://github.com/n8n-io/n8n/releases，查于 2026-07-02）；n8n 融资 Series C $180M、累计 $240M、估值 $2.5B（2025-10 背景，https://www.instagram.com/p/DPmDfLOEYPh/）；Flowise GitHub Stars 54,176 / 最新版 flowise@3.1.3 发布 2026-06-25（GitHub API repos/FlowiseAI/Flowise）；Workday 收购 Flowise 公告 2025-08-14（背景，https://newsroom.workday.com/2025-08-14-Workday-Acquires-Flowise，客户含 Accenture/AWS/Deloitte/Publicis/Thermo Fisher）
- 原文链接：https://github.com/n8n-io/n8n/releases ；https://github.com/FlowiseAI/Flowise/releases/tag/flowise@3.1.3 ；https://diginomica.com/workday-acquires-flowise-build-ai-agents-people-dont-want-ai-bosses
- 影响判断：Flowise「chatflow → MCP server」把开源 Agent IDE 变成 MCP 生态的可复用节点，是 MCP 从"客户端接工具"扩展到"编排平台自身即工具"的信号；叠加 Workday 背书，Flowise 正从社区玩具走向企业级 agent builder。n8n 194k Stars 稳居开源自动化第一，AIA v3 设为默认体现其 all-in AI Agent 的战略决心，与 Dify/Coze 在开源 Agent 编排赛道三足鼎立。

---

## 本组洞察（数据平台 / 开源 / 中国 Agent 走向）
本周 C 组四大对象呈现高度一致的三条主线：**①"治理与评测"成为 Agent 工程化的新主战场**——Databricks 用 Unity AI Gateway 把治理从"谁能访问数据"推进到"agent 能做什么"（Contextual Service Policies、PII/prompt injection 防护、跨 provider 预算硬上限），字节把开源重心从 Coze Studio 转向 **Coze Loop（评测/可观测/优化）**，Dify 深化 Phoenix trace 与文档检索可观测——三家不约而同押注"agent 质量与可控性"，说明行业已过"能不能做 agent"阶段、进入"如何让 agent 可信可治理"深水区。**②MCP 协议成为开源 Agent IDE 的标配互操作层**——Flowise 3.1.3 直接把 chatflow 变 MCP server，n8n 加固 AI Gateway 托管凭证，Databricks 提供 Google Drive/Jira/Slack/GitHub 托管 MCP 服务，MCP 正从"客户端接工具"扩展到"平台即工具"。**③中国 Agent 平台走"开源立标准 + 企业版变现"双轨**——字节扣子 3.0 用免费全端引流、企业版 7/13 近翻倍提价（标准版 +97%）收割企业级能力，同时用 Coze Loop/Studio 开源吸引生态；这与 Dify（147k Stars，difyctl CLI 化打企业自托管）的开源商业化路径同频。总体判断：2026 年中，Agent 基础设施竞争焦点已从"编排能力"转向"治理、评测、协议互操作"三位一体，谁能同时提供开放生态 + 企业级可控性，谁就掌握下一阶段话语权。

