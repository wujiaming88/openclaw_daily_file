# 全球 AI Agent 基础设施周报 · 第 16 期 · 研究母稿

> 预算确认：黄山（wairesearch）已收到本子预算合同（父级 deadline_at=2026-10-08T10:14:00+08:00、checked_at=2026-10-08T08:31:00+08:00、剩余约 6180s、下游 reserve_seconds=3600、本子可用 1500s、runTimeoutSeconds=1500），不调用 sessions_yield，按 L1/L3 有界追加落盘。
> run_id：`agent-infra-20261008T081427+0800-fdf1d555`
> 本文档性质：资料库保存的**完整研究母稿**（含审计性细节），供下游文章编辑线改造为读者稿；不是读者稿本身。

## 一、头部

- **期次**：第 16 期
- **主题句**：**控制层收编战：Harness 的工程可靠性成为主战场，身份、执行环境与工具结算三处同时被平台方收口。**
  本周（第 16 期）跨 8 模块的综合判断是：Agent 基础设施的竞争重心已从「能不能编排」整体转向「长时间运行不掉线、可恢复、可审计、以正确的身份与预算触达正确的工具与执行环境」。四股力量同向：① 开源 Agent OS（OpenClaw）与开源编排（LangGraph/ADK）把 session/state 持久化、优雅取消、人工确认做成发布主线；② 模型厂把浏览器/计算机执行工具与网络策略下放进 SDK（Anthropic browser-use/computer-use toolset、`allowed_hosts` 收紧）；③ 云厂把控制面（AgentCore Gateway 私有 CA、Cloud Trace、Foundry Routines）与身份（Entra Agent ID/Consent Portal）持续平台化，并把模型厂 Harness 收编为自家 SKU（Bedrock Managed Agents powered by OpenAI、火山 Agent Plan 专属 Harness）；④ IAM 厂商（Okta/WorkOS）主动抢 MCP 网关身份标准，工具层出现首个「Agent 钱包」按用量结算（Composio Instant）。
- **报道窗口**：2026-10-01 00:00 ~ 2026-10-07 24:00（Asia/Shanghai）。窗口外信息一律标「（背景，非本周）」，不进入本周动态判断。
- **取证范围**：9 方向 GitHub/Web 热度补漏（`hot-scan-2026-10-08.md`）＋ 4 条研究线（A/B/C/D）共 21 个分片。已读一手入口包括（按线）：
  - 线 A：GitHub releases API（openclaw/openclaw、langchain-ai/langgraph、google/adk-python）、docs.openclaw.ai/releases、platform.claude.com release-notes 与 browser-use-sdk 文档、developers.openai.com/api/docs/changelog、aws.amazon.com 周报与 bedrock-agentcore release-notes、docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes、devblogs.microsoft.com/foundry、learn.microsoft.com（agent-framework/overview、azure/foundry/whats-new-foundry、microsoft-copilot-studio/whats-new）、docs.databricks.com October 2026 release notes。
  - 线 B：上述 AWS/Vertex/Gemini Ent./Microsoft Foundry 发布说明、browserbase.com/changelog 与 observability、modal.com/blog 与 changelog、openclaw/openclaw releases、docs.openclaw.ai、e2b-dev/E2B（gh api）、daytonaio/daytona（gh api）、openai.com DevDay 页、learn.chatgpt.com 周报、platform.claude.com computer-use 文档、learn.microsoft.com Playwright Workspaces。
  - 线 C：gh api 直查 4 次（mcp-gateway-registry、a2aproject/a2a、ArcadeAI/arcade-mcp、NangoHQ/nango 等）、web_fetch 一手原文 12+（a2a-protocol.org、composio.dev/blog、okta.com/blog、workos.com/blog、nango.dev docs、Arcade/iComposio releases、AWS/Google release notes、Microsoft Learn）。
  - 线 D：gh api 直查约 22 次（OpenViking、mem0、cognee、supermemory、letta、graphiti、firecrawl、crawl4ai、lightrag、graphrag、langfuse、langsmith-sdk、braintrust-sdk、arize-phoenix、helicone、agentops、coze-loop 等 releases/commits/repo 元数据），serper 搜索 9 次；模块 6/7 的本周动态均以 GitHub 官方 release body 与 commits（一手全文）为证，未以搜索摘要支撑任何「本周动态」。
- **取证局限**（贯穿全篇，不逐条重复）：
  1. **「未查询到 ≠ 不存在」**。云厂发布说明按月/周聚合、无逐条日期（AWS、Azure），中国云厂文档页动态渲染/中文动态页分散，多处 web_fetch 抽取失败或仅得旧页；这些一律记为「本次未取得窗口内一手证据」，不作「无动态」的强断言。
  2. **日期不确定性**。AWS AgentCore Gateway 私有 CA 官方仅标「October 2026」、无具体日，存在落在 10-08 的轻微不确定，已限述为「（背景/归属待明确）」；OpenAI 官方无细粒度 changelog，ChatGPT 周报（9/28–10/2）单条日期不可核，未作窗口内一手主张。
  3. **GitHub 数值为快照绝对值**，非周增速；本期未取得两周前快照，不计算增速。
  4. **B 级自披露口径**：Composio（月 10 亿 tool calls、百万用户）、Pipedream（托管 3,000+ API auth）、腾讯云客户案例（伊利点击率 +15.7% 等）等为厂商自披露，未独立核实。
  5. **未使用**：本次未使用 tavily/exa/xAI 补齐，未登录抓取；GitHub 数据均 `gh api` 直查（认证 login=wujiaming88，core remaining 5000）。
- **非实测声明**：本期所有平台能力、发布与数值均为**文献取证**（官方发布说明、release notes、changelog、repo 元数据、厂商博客）所得，**未对本报告涉及的任何平台/工具进行实际部署、压测或功能实测**。所有「影响判断」「模块洞察」属基于已落盘证据的推理，非实测结论；分片中已限述/隔离的主张保持其限定与归属；冲突或不确定处如实保留在本稿中，不作抹平。
- **母稿结构**：模块 1–8（各含本周模块结论、固定对象状态表、深度笔记、模块洞察）→ 云厂能力矩阵（7 行）→ TOP 5 候选 → OpenClaw 战略参照 → 覆盖审计 → R3 价值链位置与 R2 解决方案透镜。

## 二、模块 1 — Harness / Agent OS 控制层

### 本周模块结论（第 16 期）
1. **控制层的可靠性/会话语义成为本周主线**：OpenClaw（`v2026.9.8` 于 10-03 发布、`v2026.10.1-beta.1` 于 10-05 发布）与 LangGraph（1.2.14 / sdk 0.4.6 / cli 0.4.33，10-06~10-07）本周交付的几乎都是 session/state、审计、恢复类修补，而非新范式；Harness 竞争已从「能不能编排」转向「长时间运行不掉线、可恢复、可审计」。
2. **模型厂把 Harness 与执行工具直接下放进 SDK**：Anthropic 10-07 在 Python/TS SDK 中为浏览器/计算机使用工具提供 beta 类，并让 Claude Managed Agents 的 `allowed_hosts` 约束 `web_fetch`/`web_search`——执行环境与网络策略由 SDK/托管层统管，控制层被「收编」进模型厂平台。Google ADK v2.11.0（10-01）同日补齐优雅取消、工具人工确认、内置 SQLite memory 与 MCP SDK 2.x，开源控制层快速同质化。
3. **云厂把 Agent 控制面垄断到自家身份/权限体系**：AWS 10-05 Roundup 重申 Bedrock Managed Agents（基于 OpenAI Agents API 的 AWS-native 定制版）可选 AgentCore Runtime 作为执行环境（发布在 2026-09，属背景），控制层与执行层被打包。
4. **OpenClaw 参照意义**：OpenClaw 本周的 session/memory/plugin/MCP 修补方向与 AgentCore Harness lifecycle hooks、Anthropic SDK toolset 属同一竞争面；OpenClaw 的优势是开放多框架 + 本地/自托管控制层，补课点是浏览器/计算机执行工具与网络策略的细粒度治理。

### 固定对象状态表（模块 1）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态（v2026.9.8 10-03、v2026.10.1-beta.1 10-05、v2026.8.35 10-02、v2026.8.34 10-02） | docs.openclaw.ai/releases/2026.9.8；gh api openclaw/openclaw releases | 是 |
| OpenAI Agents SDK / Responses API | 本周无重大公开动态（背景：2026-09 Bedrock Managed Agents 基于其 Agents API 定制） | aws.amazon.com 2026-10-05 Roundup（背景引用） | 否（背景；但 API 侧窗口内有变更，见笔记） |
| Anthropic Claude Agent SDK / MCP | 有动态（10-07 SDK browser/computer use beta 类；10-07 Managed Agents 网络策略收紧） | platform.claude.com/docs/en/release-notes/overview | 是 |
| LangChain / LangGraph / LangSmith | 有动态（langgraph 1.2.14、sdk 0.4.6 10-06；cli 0.4.33 10-07） | gh api langchain-ai/langgraph releases | 是（LangSmith 见模块 7） |
| Google ADK（A2A / Vertex / Gemini Enterprise） | 有动态（ADK Python v2.11.0 10-01；平台侧见模块 8） | gh api google/adk-python releases/tags/v2.11.0；docs.cloud.google.com/.../release-notes | 是 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 本周未取得窗口内发布（最近：Foundry Routines GA 2026-09-24，属背景） | devblogs.microsoft.com/foundry | 否（背景） |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 有动态（2026-10 平台 notes：Agent Bricks code-first 文档、Genie Code CLI 10-06 等） | docs.databricks.com/aws/en/release-notes/product/2026/october | 是（并入模块 8） |

> 说明：模块 1 固定对象 7 + 动态池 3 类；深写对象为 OpenClaw、OpenAI、Anthropic、LangGraph、Google ADK（5）；Microsoft、Databricks 记窗口/背景；动态池经门槛过滤。

### 深度笔记（模块 1）

#### OpenClaw（Agent OS / Gateway / sessions / cron / tool runtime / plugin & skills）
- **本周动态**：OpenClaw 本周连续交付三个版本：`v2026.8.35`（2026-10-02，非预发布）、`v2026.9.8`（2026-10-03，非预发布）、`v2026.10.1-beta.1`（2026-10-05，预发布）。`v2026.9.8` 官方 release notes 明确「修复 agent 之间缺失的回复、降低运行大量 Codex agent 时的内存占用、修复失败更新与 Windows 启动问题」，规模为「43 个 PR、12 个直接提交、8 位贡献者」；具体条目含：更新恢复保留已允许/启用的插件、Doctor 补完待确认升级、热重载连接设置时进行中的工作可完成、`REPLY_SKIP`/`ANNOUNCE_SKIP` 不再隐藏回复。预发布 `v2026.10.1-beta.1` 聚焦 sessions/memory（跨 registry 变更保留 usage、远程 workspace 投递 worker 附件、迁移 embedding 缓存）、plugins/Codex/MCP（修复过期远程执行审批污染 auth profile、恢复 node policy hooks、同步 MCP forms/files/context、后台 skill review 走 Workshop proposals）、Cloud workers/Crabbox、Windows workspace 与 Playwright Chromium ARM64 自动启动、以及「Migrated existing agents to local Claws」「incognito actor memory 与 Codex history routing」等。上周的 `v2026.9.7` 已引入「OpenAI Agents API」与「Sign in with ChatGPT (Beta)」（背景）。
- **关键数据**：`v2026.9.8` = 43 PR / 12 commits / 8 contributors；发布节奏 `v2026.8.35` @ 2026-10-02、`v2026.9.8` @ 2026-10-03、`v2026.10.1-beta.1` @ 2026-10-05。发布时间戳（线 B 补充）：`v2026.10.1-beta.1` published_at `2026-10-05T19:47:49Z`、`v2026.9.8` `2026-10-03T03:21:47Z`、`v2026.8.35` `2026-10-02T14:06:34Z`、`v2026.8.34` `2026-10-02T00:12:39Z`（来源：GitHub releases API `repos/openclaw/openclaw/releases`，取得于 2026-10-08）。
- **原文链接**：https://docs.openclaw.ai/releases/2026.9.8 ；https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases
- **影响判断**：OpenClaw 本周的发力点全部落在「长时间运行 + 多 agent 协作 + 更新/恢复可靠性」上，与 AgentCore（Harness lifecycle hooks、interactive shells）、Anthropic SDK（toolset）在同一竞争面，本质是把 Agent OS 的稳定性和运维体验做成护城河。对搭方案而言，OpenClaw 的开放控制层 + 本地/自托管 + 多框架（Codex/MCP/插件）是差异化优势，而浏览器/计算机执行工具与细粒度网络策略仍是需要补课或借力的部分。
- **运行语义变化（弃用时间线，跨模块 1/2 复用）**：`v2026.10.1-beta.1` 列出多条自 **2026-10-01 起告警**的插件 API 弃用——`session-manager-sync-persistence`（改为 await 对应的 Async 后缀 SessionManager 方法）、`extension-session-sync-persistence`（await ExtensionAPI/AgentSession 持久化方法）、`provider-replay-sync-persistence`（改用异步 replay sanitizer 与 session-state API）、`memory-session-sync-inventory`（await `loadArchivedSessionsAsync` / `resolveMemorySessionTargetsAsync`）；另 `workspace-mutation-guard-callback`、`gateway-placement-sync-results` 自 2026-10-02 告警。**含义：session/state 持久化从「同步写」全面转向「异步 await」语义**，是长时、并发 Agent runtime 的典型演进方向。

#### OpenAI Agents SDK / Responses API（含工具调用、Computer Use、Code Interpreter、AgentKit/Swarm 谱系）
- **本周动态**：控制层本体本周无 SDK 大版本发布，但 API 侧有窗口内变更：① **2026-10-07** 更新 `chat-latest` 快照（面向 ChatGPT Plus/Pro/Business/Enterprise，官方建议生产用 GPT-6 家族）；② **2026-10-06** 发布 **Decisions API**（beta，`gpt-6-luna`），官方称「把文本和图像转成类型化答案，比 Responses API 快 10 倍」；③ **2026-10-06** 将 API 使用层级从 5 档简化为 3 档（Build / Launch / Grow）；④ **2026-10-05** 在 API 组织设置中加入 HIPAA 合规支持流程（可签署 BAA）。属控制层谱系的近两周背景：**2026-09-29** 将 Computer Use 加入 **Agents API**（Agent 可在 OpenAI 托管浏览器中完成任务，网站访问审批与登录由应用处理）；同日发布 GPT-6.1 Sol（$2 input / $0.10 cached input / $2.50 cache write / $10 output 每 1M tokens，≤272K 输入）并支持 Multi-agent（beta，在单次 Responses 请求内委派子 Agent）；2026-09-29 为 GPT-6 Astra 增加 Ultrafast 模式。
- **关键数据**：Decisions API 官方称比 Responses API 快 10x（2026-10-06）；使用层级 5→3（2026-10-06）；GPT-6.1 Sol 定价 $2/$0.10/$2.50/$10 per 1M（2026-09-29，背景）。
- **原文链接**：https://developers.openai.com/api/docs/changelog
- **影响判断**：本周 OpenAI 没有动 Harness 骨骼，而是补「快速类型化决策 API + 层级简化 + 合规」这类平台治理项；真正的控制层动作（Computer Use 进 Agents API、Multi-agent 委派）发生在 9 月底。这提示 OpenAI 正把 Agent 能力下沉为 Responses API 原语——对第三方 Harness（含 OpenClaw）是「接口被上游吸收」的持续压力。

#### Anthropic Claude Agent SDK / MCP
- **本周动态**：**2026-10-07 是密集发布日**。① **SDK 内置浏览器/计算机使用工具**：Python 与 TS SDK 新增 browser use 与 computer use 工具的 beta 类；开发者子类化并自写每个成员工具方法（如 `navigate`、`left_click`），SDK 负责路由调用、执行 config 策略、调用审批回调并组装 `tool_result`。官方明确 SDK **不含浏览器/桌面/驱动/URL 策略**，仅提供 `claude-quickstarts` 中的最小 CDP 示例（非生产代码）；并列出 Browser Use、Browserbase、Daytona、E2B 的第三方集成。② **Claude Managed Agents 网络策略收紧**：云环境的 `limited` 网络模式现将 `allowed_hosts` 同时施加到 `web_search` 与 `web_fetch` 工具，命中不到允许主机的 `web_fetch` 返回 `url_not_allowed`。③ **Claude Haiku 5.5** 发布（`claude-haiku-5-5`，1M 上下文、128k 最大输出、adaptive thinking + effort 参数，覆盖 API / Bedrock / Claude Platform on AWS / Google Cloud / Microsoft Foundry）；官方警示 Haiku 4.5 代码可能在 5.5 报 400（手动 extended thinking `budget_tokens` 已废）。④ Sonnet 5.5 prompt cache 读取降价 $0.20 → $0.10 / 1M tokens（0.1x→0.05x 基础输入价）。⑤ Max/Team 计划纳入月度 API 额度。**2026-10-08**（窗口外，背景）Compliance API chat 端点扩展至统一 Claude 体验。MCP 本体：当前规范为 **2026-07-28**（stateless core + OAuth/OIDC 加固），属背景，本周无窗口内新规范。
- **关键数据**：cache read $0.10/1M（2026-10-07）；SDK toolsets beta（2026-10-07）；Haiku 5.5 1M ctx / 128k output（2026-10-07）。来源：platform.claude.com/docs/en/release-notes/overview；platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-sdk
- **原文链接**：https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-sdk ；https://platform.claude.com/docs/en/release-notes/overview
- **影响判断**：Anthropic 把「浏览器/计算机执行环境」抽象成 SDK 工具类 + 自带审批回调与 URL 策略，直接与 Browserbase/E2B/Daytona 形成「SDK 定协议、伙伴做实现」的分工——这正是控制层向执行层下沉、并收编第三方沙箱的信号。对 OpenClaw 的含义：若要做同类能力，与其自研浏览器栈，不如对齐 SDK toolset 语义并接入 Browserbase/E2B 等伙伴，把精力放在会话/记忆/多 agent 编排的差异化上。

#### LangChain / LangGraph / LangSmith
- **本周动态**：编排/运行时层本周以小幅迭代为主。**LangGraph 1.2.14**（2026-10-06）、**langgraph-sdk 0.4.6**（2026-10-06）、**langgraph-cli 0.4.33**（2026-10-07）接连发布。1.2.14 为纯发版提交（changes since 1.2.13）；sdk 0.4.6 修复 stream 请求中 thread/assistant ID 的百分号编码问题；cli 0.4.33 新增 `--image-uri`（部署已推送镜像）与 `langgraph deploy listeners list` 子命令，并新增「拒绝携带凭据的 Git 依赖」安全修复。LangSmith 本周未取得窗口内独立发布（属未取得，非无动态；其 SDK 侧动态见模块 7）。背景（非本周）：LangChain/LangGraph 1.0 于 2025-10-22 GA；官方 release policy 显示 LangChain 0.3 处于 MAINTENANCE，支持至 2026-12。
- **关键数据**：langgraph==1.2.14（2026-10-06）；langgraph-sdk==0.4.6（2026-10-06）；cli==0.4.33（2026-10-07）。来源：gh api `repos/langchain-ai/langgraph/releases`（取得于 2026-10-08）。
- **原文链接**：https://github.com/langchain-ai/langgraph/releases
- **影响判断**：LangGraph 本周的动作集中在部署/运维体验（镜像部署、listeners、依赖安全）——这是「运行时商品化」阶段的典型特征：编排语义已稳定，竞争转向托管与交付。对 OpenClaw 的参照是，LangGraph 的 checkpointer/store 与 `langgraph deploy` 形成「编排+托管」闭环，OpenClaw 的 sessions/cron/Gateway 若要对标，需把「部署与运维可观测」进一步产品化。

#### Google ADK（Agent Development Kit / A2A / Vertex / Gemini Enterprise）
- **本周动态**：**ADK Python v2.11.0 于 2026-10-01 发布**，是本周窗口内少见的控制层实功能包，Highlights 含：① **优雅取消**：可向 `Runner`、`Workflow`、节点传 `abort_signal` 以优雅停止运行，`/run_sse` 在客户端断开时取消运行；② **工作流内工具确认**：工具节点现可像 `LlmAgent` 一样通过 `RequestInput` 暂停等待用户批准，而非把错误传向下游；③ **ModelConsultTool**：允许 Agent 在任务中途咨询另一模型，受每轮/每会话预算约束；④ **内置 SQLite memory service**：以 `sqlite://` memory service URI 选择本地 SQLite 记忆库；⑤ **MCP SDK 2.x**：通过新 opt-in 路径以现代协议连接 MCP server。破坏性变更：Dev UI 的 runtime config 改由服务端按请求下发，不再写入安装包（需用 `--logo-text`/`--logo-image-url` 配置）。平台侧窗口内动态见模块 8（Gemini Enterprise Agent Platform release notes 10-05 起）。A2A 协议本体本周未取得窗口内独立发布。
- **关键数据**：ADK Python v2.11.0 @ 2026-10-01（含 abort_signal、RequestInput 工具确认、ModelConsultTool、SQLite memory、MCP SDK 2.x）。来源：gh api `repos/google/adk-python/releases/tags/v2.11.0`（取得于 2026-10-08）；https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- **原文链接**：https://github.com/google/adk-python/releases ；https://github.com/google/adk-python/blob/main/docs/guides/runners/runner/abort.md
- **影响判断**：ADK 把「可取消/可中断 + 工具人工确认 + 记忆内置（SQLite）+ MCP 2.x」一次性补齐，等于在开源控制层里对标了 Anthropic 的 approval callback 与 AgentCore 的 lifecycle hooks——控制层正快速同质化。其 SQLite memory 与 MCP 2.x opt-in 对 OpenClaw 是直接参照：本地记忆与协议升级应尽量做成可选后端而非硬依赖。

#### Microsoft Agent Framework / Semantic Kernel / AutoGen
- **本周动态**：**本周未取得窗口内（2026-10-01~10-07）公开发布**。Semantic Kernel 与 AutoGen 已合并为 **Microsoft Agent Framework**（1.0 于 2026-04-03 发布，属背景）。近两周背景（非本周）：**2026-09-24** Foundry「Routines」GA（把监控/事件驱动/长时任务从手写调度器抽象为托管能力），**2026-09-15** Foundry Dev Pack，**2026-08/09** Foundry Hosted Agents / Toolbox / memory（程序性/用户/会话记忆）/ Foundry IQ / Voice Live 等 Build 2026 能力；**Agent Framework 概述文档更新于 2026-08-25**（session-based state、type-safe）。Copilot Studio 侧：自 2026-07 起为每个新 Agent 自动创建 Microsoft Entra Agent ID（身份层，背景）。
- **关键数据**：Agent Framework 1.0 @ 2026-04-03；Foundry Routines GA @ 2026-09-24（均属背景）。来源：devblogs.microsoft.com/foundry；learn.microsoft.com/en-us/agent-framework/overview/
- **原文链接**：https://learn.microsoft.com/en-us/agent-framework/overview/ ；https://devblogs.microsoft.com/foundry/
- **影响判断**：微软把 Harness 收进「Agent Framework（开源 SDK）+ Foundry（托管 runtime/memory/toolbox）+ Entra Agent ID（身份）」三件套，控制层与身份层强耦合。本周虽静默，但其 9 月 Routines GA 已经把「长期运行/事件驱动」做成平台原语——对 OpenClaw 是直接的同类功能对标点。

#### Databricks Mosaic AI Agent Framework / Agent Bricks
- **本周动态**：Databricks 平台 **2026-10 发布说明**（窗口内条目）含：**Agent Bricks documentation for code-first agent development**（面向代码优先的 Agent 开发文档，10 月）；**Genie Code CLI（Beta，2026-10-06）**——终端内编码 Agent，可发现数据、构建并部署 pipeline/model/app；**DeepSeek V4.1 Flash 支持 priority pay-per-token 与预留吞吐（2026-10-07）**；**Metric view window measures GA（2026-10-06）**；**Google Workspace connector Beta（2026-10-09，窗口外）**。近两周背景：Agent Bricks Supervisor Agent 支持自定义 MCP server 与 Databricks Apps 上的自定义 Agent（2026-09 平台 notes）。
- **关键数据**：Genie Code CLI Beta @ 2026-10-06；DeepSeek V4.1 Flash priority/预留吞吐 @ 2026-10-07（来源：docs.databricks.com October 2026 release notes）。
- **原文链接**：https://docs.databricks.com/aws/en/release-notes/product/2026/october
- **影响判断**：Databricks 的差异化仍是「治理数据 + Agent Runtime + 可评测/可追踪 + MCP」。本周以文档化「code-first Agent 开发」和终端编码 Agent 补开发体验，控制层本身无范式变化；其价值锚点是 Unity Catalog 治理，而非 Harness 运行时本身。

#### 动态池（CrewAI AMP / Studio、Dify Agent Runtime、n8n / Flowise）
- **本周扫描**：**均无满足「平台化 / runtime / observability / enterprise deployment」基础设施级门槛的窗口内动态**。近两周背景（非本周）：Dify 于 **2026-08-27** 发布「New Agent」（Agent 成为独立应用或工作流可复用资源）；CrewAI 2026-02 发布《state of agentic AI in 2026》报告。n8n / Flowise 本周未取得基础设施级窗口发布。
- **来源**：dify.ai/blog/introducing-new-dify-agent（2026-08-27，背景）
- **影响判断**：动态池本周按规则「仅基础设施级动态才写」过滤，不作为本周条目。这本身是信号：应用层工作流平台本周未在控制层范式上提出新主张，竞争集中在云厂与开源 SDK。

### 模块 1 洞察
- 控制层本周没有新范式，而是把「会话/状态/恢复/审计」这类工程可靠性做成竞争主战场，同时被模型厂（SDK 内置执行工具）与云厂（托管 Runtime + 身份体系）从两端收编。开源侧（OpenClaw/LangGraph/ADK）在可靠性语义上同质化加速：优雅取消、人工确认、异步持久化、内存/状态迁移成为共同发布语汇。

## 三、模块 2 — Runtime / Session / State 执行层

### 本周模块结论
1. **云厂托管 runtime 本周整体进入静默/维护窗口**：AWS AgentCore Runtime、Google Agent Engine（Gemini Enterprise Agent Platform）、Microsoft Foundry Hosted Agents 在 10-01~10-07 均**无窗口内一手功能发布**（AWS 10 月仅 Gateway 私 CA 一项，属模块 4；Google 10/05–10/07 均为 CodeMender/Nano Banana）。本期最实的一手信号来自**开源 Agent OS（OpenClaw）**与**托管算力平台（Modal）**。
2. **「有状态长期执行」成为共同路线，但本周新增证据集中在 Modal**：Modal 在 10-01 Runtime 大会把 **Sticky Sessions**（会话粘滞到同一容器）正式产品化，与 AWS 8 月的 *Instances 持久会话（最长 14 天）*、Google 9 月的 *sandbox pause/resume* 指向同一方向——session 生命周期正在超过「单次调用」。
3. **OpenClaw 本周连续多发**：`2026.10.1-beta.1`（10-05）、`2026.9.8`（10-03）、`2026.8.35`/`2026.8.34`（10-02），核心围绕 **sessions / state / memory 迁移与持久化语义加固**，并从 2026-10-01 起对多条「同步→异步持久化」插件 API 发出弃用警告——是本期最直接、可核验的 runtime 生命周期演进信号（R3 位置：运行时/Harness 段）。
4. **国产平台本周未见窗口内动态**：阿里云百炼、火山方舟/Coze、腾讯云 ADP 均未查到 10-01~10-07 一手发布（仅背景促销/更名/下线公告），如实标静默并记录已查入口。

### 固定对象状态表（模块 2）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw sessions/cron/Gateway runtime | **有动态**（10-02/10-03/10-05 多版本） | GitHub releases；docs.openclaw.ai | 是 |
| Modal（托管执行/长任务、Sticky Sessions） | **有动态**（10-01） | modal.com/blog、modal.com/changelog | 是 |
| AWS Bedrock AgentCore Runtime | 静默（10 月无 Runtime 条目） | docs.aws.amazon.com 发布说明 | 是（限述） |
| Google Vertex AI Agent Engine / Gemini Ent. Agent Platform | 静默（10/05–07 为 CodeMender/Nano Banana） | docs.cloud.google.com 发布说明 | 是（限述） |
| Microsoft Foundry Hosted Agents / Agent Service | 静默（最新 what's-new 为 8 月页） | learn.microsoft.com | 是（限述） |
| 阿里云百炼 / Model Studio / PAI | 未查到窗口内发布 | developer.aliyun.com 月报 | 否（背景） |
| 火山方舟 Ark / Coze / Coze Studio | 未查到窗口内发布 | volcengine.com 文档 | 否（背景） |
| 腾讯云智能体平台 / 元器 / CloudBase | 未查到窗口内发布 | cloud.tencent.com 文档 | 否（背景） |
| E2B（托管执行 SDK） | 有补丁（10-05/10-06） | GitHub releases | 是 |
| Daytona（托管执行/容器生命周期） | 静默（仓库已转闭源，背景） | github.com/daytonaio/daytona | 否（背景） |

### 深度笔记（模块 2）

#### OpenClaw sessions / cron / Gateway runtime
- **本周动态（10-02 ~ 10-05，窗口内）**：OpenClaw 本周连发多个版本。`openclaw 2026.9.8`（发布 2026-10-03）、`2026.8.35`（10-02）、`2026.8.34`（10-02）为常规修复；**`v2026.10.1-beta.1`（发布 2026-10-05）**是本周最重的一版。其 Highlights 首条即 **Sessions and memory**：跨注册表变更保留 usage、从远程 workspace 投递 worker 附件、阻止「排队中的取消」与 transcript 别名卡住活跃 turn、保持 continuation 签名对齐、并将 embedding 缓存**按有界批次迁移并上报超大行**（PR #164217/#164219/#164230/#164251/#164289/#164287/#164303）。Changes 段另有：**迁移既有 agents 到 local Claws**（#162329）、降低 Sessions-board 与 state-path 开销（服务化准备事实、按 store revision 复用卡片载荷、把生命周期变更移出主线程、保留 canonical state handles，#164218/#164301/#163815/#164110）。
- **关键运行语义变化（弃用时间线）**：该版列出多条自 **2026-10-01 起告警**的插件 API 弃用——`session-manager-sync-persistence`（改为 await 对应的 Async 后缀 SessionManager 方法）、`extension-session-sync-persistence`（await ExtensionAPI/AgentSession 持久化方法）、`provider-replay-sync-persistence`（改用异步 replay sanitizer 与 session-state API）、`memory-session-sync-inventory`（await `loadArchivedSessionsAsync` / `resolveMemorySessionTargetsAsync`）；另 `workspace-mutation-guard-callback`、`gateway-placement-sync-results` 自 2026-10-02 告警。**含义：session/state 持久化从「同步写」全面转向「异步 await」语义**，这正是长时、并发 Agent runtime 的典型演进方向。
- **关键数据**：`v2026.10.1-beta.1` published_at `2026-10-05T19:47:49Z`；`v2026.9.8` `2026-10-03T03:21:47Z`；`v2026.8.35` `2026-10-02T14:06:34Z`；`v2026.8.34` `2026-10-02T00:12:39Z`（来源：`gh api repos/openclaw/openclaw/releases`，取数 2026-10-08 08:19 +0800）。
- **原文链接**：https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases
- **影响判断**：OpenClaw 本周把「session 生命周期 + state 持久化」当成发布主线，且以**弃用警告**驱动插件生态迁移到异步语义，说明长时/并发 Agent OS 的瓶颈已从「能否跑」转到「跨 turn/跨 workspace 的状态一致性」（R3：运行时/Harness 段在自建 state 语义，价值向控制层集中）。对云厂托管 runtime 的参照：**session 语义与迁移/断点续跑的可控性，正成为 runtime 的差异化点而非功能点**。

#### Modal（托管执行 / 长任务 / Sticky Sessions）
- **本周动态（10-01，窗口内）**：Modal 举办首届大会「Runtime」，CEO Erik 主题演讲发布多项 runtime 原语。与**本模块（session/state）**直接相关的是 **Sticky Sessions**：客户端带上 session token 即可保证请求路由回**同一运行中的容器**，从而让应用跨请求保持状态、给终端用户「无缝重连」体验，官方点名实时语音等对容器路由速度敏感的场景。
- **已读来源关键摘录**：Modal 博客原文——“Sticky Sessions allow you to keep a client’s interactions attached to the same running Modal container, so your application can maintain state across requests.”（https://modal.com/blog/runtime-product-update-sandbox-endpoints ，10-01）。
- **关键数据**：会议日期 2026-10-01（页面“Oct 1, 2026”）；同一场还发布 VM Sandboxes / Sandbox Sidecars / Modal Clusters / Endpoint Candidates（详见模块 3）。
- **原文链接**：https://modal.com/blog/runtime-product-update-sandbox-endpoints ；https://modal.com/changelog
- **影响判断**：Modal 把「会话粘滞」从运维技巧变成**平台原语**，意味着 serverless 执行面正在补齐过去只有长驻进程才有的 state 能力（R3：运行时/执行环境段向上吸收部分「有状态服务」价值）。与 AWS AgentCore 的 session/14 天持久实例、Google sandbox pause/resume 同向，**「无状态函数」与「长驻有状态 session」的边界正在被托管 runtime 主动抹平**。

#### AWS Bedrock AgentCore Runtime
- **本周动态**：**窗口内无 Runtime 专属发布**。官方 Release Notes 的「## October 2026」段**仅一条**：*Gateway: Private certificate authority support for targets*（网关支持私有 CA 签发 TLS 证书，面向 MCP/OpenAPI/HTTP passthrough 目标）——属**模块 4 工具网关**，本模块仅记录不深写。Runtime 侧最近条目均在窗口前（（背景，非本周））：
  - **（背景，非本周）2026-08**：*Runtime: Instances compute type with capacity providers* —— Instances 在客户自有 AWS 账号的托管 EC2 上跑 agent，**支持最长 14 天的持久会话、GPU 实例、多 agent 共享实例**，可用 Savings Plans/ODCR；另 8 月还提高了默认配额（数据面 `InvokeAgentRuntime` 合并为 1000 TPS/账号，新建 session 25 TPS/账号）。
  - **（背景，非本周）2026-07**：Runtime **BYO File System**（挂载 Amazon S3 Files / EFS，跨 session 持久化中间结果与共享 skills）、Runtime **Interactive Shells**（每 session 最多 10 个持终态 shell）。
- **关键数据**：10 月条目数 **1**（Gateway 私 CA，无日期粒度）；8 月 Instances 持久会话上限 **14 天**；数据面配额 **1000 TPS/账号**、新建 session **25 TPS/账号**（来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ，取数 2026-10-08）。
- **原文链接**：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- **影响判断**：AWS AgentCore Runtime 本周**无新信号，等于把战线交给 Gateway/Identity**（10 月唯一更新在网关信任链）。对 R1 的含义：AgentCore 的 runtime 能力（持久 session / BYO 文件系统 / 交互 shell）已在 7–8 月集中铺完，**近两周处于功能固化期**。局限：官方发布说明按月聚合、无逐条日期，10 月条目具体日不可核，存在落在 10-08 的轻微不确定，已标。

#### Google Vertex AI Agent Engine / Gemini Enterprise Agent Platform
- **本周动态**：**窗口内无 Agent Engine / Managed Agents 专属发布**。`Gemini Enterprise Agent Platform release notes` 的 10/07、10/06、10/05 条目均为 **CodeMender（代码安全 agent，v0.13.0/v0.12.0）**、**Gemini Nano Banana 2.1**（图像模型 GA）——不属 runtime/session 层。旧 Vertex AI 发布说明页 10/05、10/04 亦全为 **Agent Platform Workbench（笔记本）**包更新。
- **近两周背景（非本周）**：**2026-09-09** Computer Use 与 **Shell sandboxes GA**，并含 VPC-SC/PSC 隔离、CMEK、**sandbox 暂停/秒级恢复（保文件系统与连接身份）**；**2026-09-30** Agent Gateway 集成 Cloud Trace（Preview）；Agent Runtime 近期还推出 ADK telemetry metrics（ADK 2.6.0+）。
- **关键数据**：窗口内 Agent Engine 条目数 **0**；背景：Sandbox GA 日 **2026-09-09**（来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ，取数 2026-10-08）。
- **原文链接**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ；https://docs.cloud.google.com/vertex-ai/docs/release-notes
- **影响判断**：Google 本周末在 runtime 层发声，重点在**安全 agent（CodeMender）与模型（Nano Banana）**。其 sandbox 暂停/恢复等长时会话能力已在 9 月落地；本周无线索表明有新增，只能记静默。

#### Microsoft Foundry Hosted Agents / Foundry Agent Service
- **本周动态**：**未找到 10 月窗口内动态**。官方 `What's new for Microsoft Foundry` 页仍为 **August 2026**（`ms.date: 2026-09-01`），未出 9/10 月页；无窗口内新条目。
- **近两周背景（非本周）**：8 月新增/更新的 Hosted Agents 文档集中围绕**长时运行 agent**——Long-running agent API 参考、**长时 agent 韧性**、崩溃后恢复（`recover-long-running-work`）、**任务状态管理**（`manage-task-state`）、流式重连（`stream-with-reconnect`）、**可转向 agent（steer in-flight turn）**、人类审批（human-in-the-loop）、私有 ACR 镜像。定位上 Hosted Agents 提供「托管沙箱会话 + 状态 + 文件系统 + 多框架」。
- **关键数据**：最新 what's-new 页覆盖 **2026-08**（页 `ms.date 2026-09-01`）；窗口内条目数 **0**（来源：https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry ，取数 2026-10-08）。
- **原文链接**：https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry ；https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents
- **影响判断**：Microsoft 本周无公开动态。可观察点：其**「长时 agent 的韧性/恢复/转向」文档体系（8 月）与 OpenClaw 本周的 continuation/迁移主题高度同题**，说明「长时运行 + 可恢复 + 可干预」已是跨平台共识（R1）。局限：无 9/10 月页面，不能断言无发布，仅记「本次未查到」。

#### 阿里云百炼 / Model Studio / PAI（Agent 托管）
- **本周动态**：**未查到 10-01~10-07 窗口内一手平台发布**。已查：百炼产品页、阿里云开发者社区月报/周报、应用功能动态页（`help.aliyun.com/zh/model-studio/application-release-notes`，页面更新 2026-09-17）。最接近的均非本周：
  - **（背景，非本周）** 百炼产品周报覆盖 **2026.08.31~09.04**；月报最新为 **2026年7/8月**。
  - **（背景，非本周）** 历史快照模型将于 **2026-10-10** 下线（属未来日程，非本周发生）；Wan3.0 发布与后付费限时 7 折促销截至 10-31（页面级营销，无确切发布日）。
- **关键数据**：窗口内发布数 **0**（已查入口见上；未取得一手发布）。
- **原文链接**：https://help.aliyun.com/zh/model-studio/application-release-notes ；https://developer.aliyun.com/article/1761210
- **影响判断**：阿里云本周末在 Agent 托管 runtime 层发布；百炼重心仍在模型上下架与知识库/应用构建。局限：中文发布页分散、月报与周报口径不一，本次未取得窗口内条目，**属「未查询到」而非「不存在」**。

#### 火山方舟 Ark / Coze / Coze Studio
- **本周动态**：**未查到窗口内一手运行时发布**。`docs.coze.cn/recent-updates` 顶部记录为 **2025-10~11** 旧页；方舟产品页/文档未命中 10 月条目。
- **近两周背景（非本周）**：方舟 **Agent Plan**（零售套餐，含多模态模型 + Harness 工具）继续主推；Q3 促销与年付预告（文章日 2026-08-31）；Coze 开源为 2025-07 旧闻（**背景，非本周**）。
- **关键数据**：窗口内发布数 **0**；已查入口：volcengine.com/docs、docs.coze.cn。
- **原文链接**：https://www.volcengine.com/docs/ark/agent-plan-personal-plan-overview ；https://docs.coze.cn/recent-updates
- **影响判断**：方舟本周末在 runtime/长任务层发声，仍以套餐与商业化为主题（R3：平台层向下游卖打包能力）。局限：方舟文档站多为 JS 动态页，web_fetch 抽取失败，仅得搜索线索，不足以支撑任何窗口主张。

#### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit
- **本周动态**：**未查到窗口内一手发布**。智能体开发平台（ADP）产品动态页首屏仅返回 2025-08 条目（正文不完整告警），无 2026-10 内容。
- **近两周背景（非本周）**：ADP 定位「以 AgentOps 为核心的企业原生智能体平台」，含 Agentic Loop / LLM+RAG / Workflow / Multi-agent / **Claw 模式**；国际版 ADP 4.0 重大升级（Smart Desk + Claw Mode）为 **2026-07** 旧闻。
- **关键数据**：窗口内发布数 **0**（来源：https://cloud.tencent.com/document/product/1759/104191 ，正文不完整）。
- **原文链接**：https://cloud.tencent.com/document/product/1759/104191 ；https://cloud.tencent.com/product/adp
- **影响判断**：腾讯本周末在 runtime 层发声。注意 ADP 已有「Claw 模式」与 OpenClaw 同名词，但目前无 10 月证据，仅为命名相似，不作推断。局限：文档页动态渲染导致抽取不完整，只记未取得。

#### E2B / Daytona（托管执行 / 长任务 / 容器生命周期）
- **E2B（有动态，10-05/10-06）**：本周两个发布——`e2b@2.53.1`（2026-10-06）为**重发上个版本**（工作流已版本化但未能推上 npm/PyPI，PR `cd4c62b`）；`e2b@2.52.1` 与 Python SDK（10-05）包含实质修复：**仅在可安全重放的操作上重试 502**（sandbox 创建/fork/snapshot 等资源创建型 POST 不再重试，避免重复创建）、secret 更新不再重放，`503` 仍全重试；**修复 JS SDK `WatchHandle.stop()` 视为干净结束**（不再报 TimeoutError）。stars 14220 / forks 1091（取数 2026-10-08）。
- **关键数据**：`e2b@2.53.1` published_at `2026-10-06T20:18:12Z`；`e2b@2.52.1` `2026-10-05T12:41:19Z`；stars 14220（`gh api repos/e2b-dev/E2B`）。
- **Daytona（静默）**：窗口内无 release（最新 `v0.190.0` 为 2026-06-23，仓库 pushed_at 2026-07-24）；README 注明「自 2026-06 起核心开发已迁移到私有码库，本仓不再更新」（**背景，非本周**）。stars 71610 / forks 5647。
- **原文链接**：https://github.com/e2b-dev/E2B/releases ；https://github.com/daytonaio/daytona
- **影响判断（R2 落地）**：E2B 本周是**运维可靠性向**补丁（幂等创建、watch 语义），对搭生产方案的含义是：**sandbox 创建/快照类调用必须按非幂等处理**，不要盲目重试 502——这是可复制的避坑点。Daytona 已转闭源并停更公开仓（R3：开源自托管路径收窄，价值向商业化托管集中）。

### 模块 2 洞察
- **本期 Runtime/Session/State 层的真实增量由「开源 Agent OS + 托管算力平台」提供，而非云厂**：云厂（AWS/Google/Microsoft）本周集体静默，OpenClaw 用**异步化的 session/state 持久化 + 跨 workspace/迁移语义**、Modal 用 **Sticky Sessions** 把「有状态长期执行」推成默认原语——这一层正从「无状态函数」向「长驻有状态会话」收敛，并开始显现为 runtime 的差异化点。

## 四、模块 3 — Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论
1. **本周最强信号来自 Modal Runtime 大会（10-01，窗口内）**：发布 **VM Sandboxes**（给 agent 一整台 Linux 计算机：可跑 Docker 栈、本地数据库/dev server、图形环境与移动模拟器，甚至折腾内核）与 **Sandbox Sidecars**（同一 host 上、隔离级别等同于独立 sandbox 的「旁车」容器），把 agent 执行环境从「容器跑代码」推向**「真机 + 信任边界隔离」**。
2. **云厂浏览器/代码沙箱本周集休眠**：AWS AgentCore Browser / Code Interpreter、Azure Playwright Workspaces / Code Interpreter、Google Code Execution 均**无窗口内发布**（Google Computer Use/Shell sandbox GA 为 09-09，Azure 概览更新为 09-15，均属背景）。
3. **开源/托管沙箱 SDK 以可靠性补丁为主**：E2B 本周 `2.53.1`（10-06，重发）/`2.52.1`（10-05，修复 502 重放与 watch 语义）——**无新隔离机制**，重点在幂等与稳定性。
4. **Browserbase「Observability」经核对：窗口内无独立发布**——其 changelog 最近条目为 `Sep 30, 2026`（Functions Secrets），9/24 为 Pause & Resume；Observability（live view / session replay / logs&traces）作为平台内置能力，**本周未观察到新发布**，与热度扫描的「待核」结论一致。

### 固定对象状态表（模块 3）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| Modal（serverless、agent tasks、sandbox） | **有动态**（10-01 VM Sandboxes/Sidecars） | modal.com/blog、modal.com/changelog | 是 |
| E2B（code interpreter sandbox） | 有补丁（10-05/10-06） | GitHub releases | 是 |
| Browserbase / Stagehand | 无窗口内发布（最近 09-30） | browserbase.com/changelog | 是（限述） |
| AWS AgentCore Browser / Code Interpreter | 静默（10 月无相关条目） | AWS 发布说明 | 是（限述） |
| Azure Browser Automation / Code Interpreter / Playwright Workspaces | 静默（概览 09-15） | learn.microsoft.com | 是（限述） |
| Google Code Execution / Managed Agents sandbox | 静默（Sandbox GA 为 09-09） | docs.cloud.google.com | 是（限述） |
| OpenAI Computer Use / Browser / Code Interpreter | 无窗口内一手发布（DevDay 09-29 为背景） | openai.com / learn.chatgpt.com | 是（限述） |
| Anthropic Computer Use | 无窗口内发布（工具集 20260801 为背景） | platform.claude.com | 否（背景） |
| Daytona（cloud workspace/sandbox） | 静默（仓已转闭源） | github.com/daytonaio/daytona | 否（背景） |

### 深度笔记（模块 3）

#### Modal — VM Sandboxes / Sandbox Sidecars
- **本周动态（10-01，窗口内）**：Modal 首届大会「Runtime」发布三项与本模块直接相关的原语：
  1. **VM Sandboxes**：「给你的 agent 一整台 Linux 计算机」——官方描述 agents 越来越想“住在一个像真机器的环境里”：跑 Docker 栈、本地数据库与 dev server、图形环境与移动模拟器，甚至折腾 Linux 内核。已用于客户 **Linear、Legora、Snorkel** 的编码 agent 与评测。
  2. **Sandbox Sidecars（Beta）**：「与主 Sandbox 跑在同一 host、但隔离级别等同于独立 sandbox 的旁车容器」——**agent 生成的代码在主 Sandbox 跑，而凭据/代理/harness 逻辑跑在 agent 无法直接访问的 Sidecar**；两者共享 host，通信本地化，避免 execution-heavy agent loop 里的网络往返。
  3.（相关）**Modal Clusters GA**：通过单个装饰器 `@modal.clustered` 提供多节点集群（服务/训练万亿参数模型），已在 Decagon、1x、Runway 使用。
- **已读来源关键摘录**：“VM Sandboxes give your agent access to a full Linux computer… Sidecars are containers that run alongside your main Sandbox on the same host, but with the same isolation as separate sandboxes. This means agent-generated code can run in the main Sandbox while credentials, proxies, harness logic, or other trusted operations run in a Sidecar that the agent cannot directly access.”（https://modal.com/blog/runtime-product-update-sandbox-endpoints ，2026-10-01）
- **关键数据**：发布日 **2026-10-01**；Sidecar 为 **Beta**（changelog 条目“Sandbox Sidecars… now in Beta”，此前为 public alpha）；客户名单 Linear / Legora / Snorkel（VM Sandboxes）、Decagon / 1x / Runway（Clusters）。
- **原文链接**：https://modal.com/blog/runtime-product-update-sandbox-endpoints ；https://modal.com/changelog/give-agents-a-full-computer-with-vm-sandboxes
- **影响判断**：Modal 把「**真机保真度**」与「**凭据隔离（信任边界）**」捆成一个产品，直接命中 agent 落地的两大痛点：需要完整 OS/内核的编码与评测场景、以及“不能让 agent 碰凭据”的安全要求（R2：交付形态为 serverless 托管，same-host 旁车降低延迟；R3：执行环境层把凭据托管/隔离内化，向上侵蚀身份层的部分价值）。对 OpenClaw 参照：**旁车信任边界**是凭据/代理类安全的可借鉴模式。

#### E2B — code interpreter sandbox / cloud execution
- **本周动态（10-05/10-06，窗口内）**：`e2b@2.53.1`（2026-10-06）为**重发**（上个版本已 versioned 但未能推上 npm/PyPI，PR `cd4c62b`），无新功能；`e2b@2.52.1`（10-05）为实质修复：**仅重试可安全重放的操作**——sandbox 创建、fork、snapshot 等资源创建型 POST 遇 **502 不再重试**（避免重复创建），secret 更新（`POST /secrets/{id}`）不再重放，`503` 仍全重试；**修复 JS SDK `WatchHandle.stop()`** 现在算干净结束（`onExit` 无错而非报 `TimeoutError`）。同期 `@e2b/code-interpreter` 2.8.2 / python 2.10.3 随版重发。
- **关键数据**：仓库 stars **14220** / forks **1091**，pushed_at `2026-10-07T16:15:30Z`；`e2b@2.53.1` published_at `2026-10-06T20:18:12Z`；`e2b@2.52.1` `2026-10-05T12:41:19Z`（来源：`gh api repos/e2b-dev/E2B` + `/releases`，取数 2026-10-08 08:19 +0800）。
- **原文链接**：https://github.com/e2b-dev/E2B/releases
- **影响判断（R2 避坑）**：E2B 本周是**分布式可靠性**向补丁，直接给出可复制规则：**sandbox 创建/快照/fork 类调用非幂等，勿对 502 盲重试**；生命周期 stop 的语义一致性向 Python 对齐。无新隔离能力，说明该阶段竞争不在“能不能跑代码”。

#### Browserbase / Stagehand（含 session replay / browser observability）
- **本周动态（窗口内无发布）**：官方 **Changelog 最近条目为 2026-09-30**（*Secrets are now in Functions*，Functions 支持密钥，运行时从 `ctx.secrets` 引用），其次 09-24（*Pause & Resume Agent Runs*，自然语言 `pauseWhen` 条件 + `PAUSED` 状态、可恢复）、09-09（Functions Webhooks）。**窗口内（10-01~10-07）未观察到新条目**。
- **Observability 核对结论**：`browserbase.com/observability` 作为平台内置能力提供 **Live view / Session replay / Logs and traces**（每 session 自动录像、结构化日志含网络/console/错误/时序，无需插桩）；但**未见于 changelog 形成窗口内独立发布**。与热度扫描「建议核对是否有发布」的结论：**检查结果=窗口内无独立发布**，Observability 非本周新增。
- **关键数据**：changelog 最新条目日期 **2026-09-30**；Stagehand 仓 stars **25562** / forks **1753**，pushed_at `2026-10-07T23:59:54Z`；最新 release `stagehand-server-v3/v3.7.6`（2026-08-28）。
- **原文链接**：https://www.browserbase.com/changelog ；https://www.browserbase.com/observability
- **影响判断**：Browserbase 本周末在沙箱/浏览器层发布新能力，其近月主线是 **Functions（边缘执行 + secrets + webhooks）+ agent run 可暂停/恢复**；观测（replay/trace）仍是平台内置而非独立产品（R1）。对 OpenClaw 参照：**内置、零插桩的 session replay + 结构化日志**是浏览器 agent 可观测性的现实基准线。

#### AWS AgentCore Browser / Code Interpreter
- **本周动态**：**窗口内无专属发布**。10 月 AWS AgentCore 发布说明仅 Gateway 私 CA 一条（模块 4）；未有 Browser Tool / Code Interpreter 的 10 月条目。
- **近两周背景（非本周）**：**2026-08** 起 Runtime 与内置工具（Code Interpreter、Browser）发布 `ActiveSessionCount` CloudWatch 指标（`AWS/Bedrock-AgentCore` 命名空间，按 `Service=AgentCore.CodeInterpreter|AgentCore.Browser` 区分）；AgentCore MCP server（awslabs/mcp）覆盖 Runtime/Memory/Browser/Code Interpreter。
- **关键数据**：窗口内 Browser/Code Interpreter 条目数 **0**；背景：`ActiveSessionCount` 为 **2026-08** 能力（来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ）。
- **原文链接**：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- **影响判断**：AWS 把代码/浏览器沙箱的可观测性（活跃会话数）先做成了度量（R1）；本周末发新功能。局限：发布说明按月聚合、无逐条日期，10 月条目归属存在轻微不确定。

#### Azure Browser Automation / Code Interpreter / Playwright Workspaces
- **本周动态**：**未找到窗口内发布**。`What is Playwright Workspaces?` 概览页更新于 **2026-09-15**（“fully managed cloud browser platform for testing applications, automating browser workflows, and powering AI…”），无 10 月条目；Foundry 侧 Code Interpreter 文档变更均在 8 月页。
- **近两周背景（非本周）**：Playwright Workspaces 提供托管云浏览器网格（无本地 Chrome 安装），与 Code Interpreter connector 并列用于 AI agent 浏览器能力；Foundry 8 月文档含 Code Interpreter 工具页更新。
- **关键数据**：窗口内发布数 **0**；Playwright Workspaces 概览页日期 **2026-09-15**（来源：learn.microsoft.com）。
- **原文链接**：https://learn.microsoft.com/en-us/azure/app-testing/playwright-workspaces/overview-what-is-microsoft-playwright-workspaces
- **影响判断**：Azure 把浏览器执行能力放在 **Playwright Workspaces（测试出身、现供 AI agent）**，与 Browserbase/Stagehand 的「为 agent 而生」路线形成定位差（R3）。本周末发新。

#### Google Code Execution / Managed Agents sandbox
- **本周动态**：**窗口内无发布**。相关能力最近为 **2026-09-09**：Computer Use 与 **Shell sandboxes 双双 GA**（Shell 沙箱支持直接 API `/exec` 跑不可信 shell、装包、改文件），并含 VPC-SC/PSC、CMEK、**sandbox 暂停/秒级恢复（保文件系统与连接身份）**。
- **关键数据**：Sandbox GA 日期 **2026-09-09**；窗口内条目数 **0**（来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ）。
- **原文链接**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/computer-use
- **影响判断**：Google 的 sandbox 已具备 **pause/resume + 企业网络/加密隔离**，接近“有状态计算机”形态；本周末有新信号（R1）。

#### OpenAI Computer Use / Browser / Code Interpreter
- **本周动态**：**未取得窗口内一手 agent-execution 发布**。最近的大型发布为 **DevDay 2026（页面 09-29）**（GPT-6.1 Sol、computer use 强化），属**窗口前**。ChatGPT 产品周报页覆盖 **9/28–10/2**，提及 Codex/Work 的电脑访问、Dots（带自有云计算机与浏览器的常驻 agent）等，但**页面为周报汇总，单条日期不可核、不能确认落在 10-01 后**，故不作窗口内一手主张。
- **关键数据**：DevDay 2026 页面日 **2026-09-29**；窗口内可确认一手条目数 **0**。
- **原文链接**：https://openai.com/index/devday-2026-recap/ ；https://learn.chatgpt.com/docs/whats-new/september-28-october-2-2026
- **影响判断**：OpenAI 的 computer use 强化发生在 DevDay（窗口前）；本周无可归因到窗口内的执行环境发布。局限：官方无细粒度 changelog，单条日期不可核，已限述。

#### Anthropic Computer Use（背景）
- **本周动态**：**未查到窗口内发布**。文档站约 toolset 版本 `computer_toolset_20260801`（命名含 2026-08-01）。
- **关键数据**：工具集版本标识 `computer_toolset_20260801`（来源：platform.claude.com computer-use 文档）。
- **原文链接**：https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool
- **影响判断**：（背景，非本周）Anthropic 的 computer use 版本化工具集继续演进，但本周末见窗口内条目。

#### Daytona（背景）
- **本周动态**：**窗口内无 release**（最新 `v0.190.0` 为 2026-06-23），仓库已转私有码库、不再公开更新（**背景，非本周**）。stars 71610 / forks 5647。
- **原文链接**：https://github.com/daytonaio/daytona
- **影响判断**：（背景，非本周）Daytona 已从开源自托管转商业化闭源，公开可核动态有限。

### 模块 3 洞察
- **执行环境层的竞争焦点已从「沙箱能不能跑代码」转向「能不能跑一台真机 + 凭据不泄 + 可回放」**：Modal VM Sandboxes/Sidecars（本周）把真机保真度与信任边界做成平台原语，而云厂（AWS/Azure/Google）本周集体静默、只有运行时度量与 9 月存量能力——本层正在由托管专业厂商领跑，云厂在追赶安全/企业隔离维度。
- 交叉观察（跨模块）：Anthropic SDK 把浏览器/计算机工具收进 SDK 与 Modal 的「真机+旁车」形成两种实现路径——一个是「协议/工具定义层收编」，一个是「执行环境层内化」，二者共同压缩了中间层（纯浏览器/沙箱平台）的差异化空间（与模块 1 结论互证）。

## 五、模块 4 — Tool Gateway / Protocol / Integration 工具与协议层

### 本周模块结论
- **协议层本周给的是“接入面”而非“新规范”**：MCP 最新正式规范仍是 2026-07-28（背景，非本周）；窗口内实质动态集中在**开源企业级 MCP Gateway/Registry 的密集迭代**（1.32.0/1.32.1，含私有 CA、前置代理出口、`mcp<2.0` 版本钉死与 401 头修复），以及 **MCP Dev Summit Toronto（10-05~06）** 把 MCP 定为“agentic substrate”的行业叙事。
- **A2A 出现“协议 CLI 化”信号**：2026-10-01 官方 A2A CLI 发布（`a2a`，基于 A2A Go SDK，协议 v1.0），把非 Agent 的 shell/CI/编码助手接进 A2A 网络；同周仓库持续补伙伴与社区 SDK（a2a-php 等）。
- **工具网关“钱”的维度被打开**：Composio Instant（10-07）给 Agent 内建钱包，可直接按调用付费使用 100+ 付费工具；这是工具层从“接得通”走向“按用量结算”的新信号。
- **OpenClaw 参照**：MCP Gateway/Registry 的 OAuth+动态工具发现+审计与 A2A CLI 的“标准命令面”，对 OpenClaw 的 tool runtime / plugin&skills / 会话工具授权有直接借鉴价值（统一网关、按用户授权、工具级审计）。

### 固定对象状态表（模块 4）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP（协议本体） | 无新规范；窗口内有 MCP Dev Summit Toronto（10-05~06） | events.linuxfoundation.org（2026-10-05/06） | 是（事件+背景） |
| MCP Gateway & Registry（agentic-community） | 有动态：1.32.0（10-04）/1.32.1（10-06） | github.com/agentic-community/mcp-gateway-registry | 是 |
| MCP 规范讨论 #804（Gateway Authorization） | 非本周（2025-07-01 提案）→ 热度观察 | github.com/modelcontextprotocol/.../discussions/804 | 否（列观察） |
| A2A（Google / Linux Foundation） | 有动态：A2A CLI 发布（10-01）、伙伴/SDK 增补 | a2a-protocol.org；github.com/a2aproject/a2a | 是 |
| Composio | 有动态：Composio Instant 钱包（10-07）；CLI beta 多次 | composio.dev/blog/composio-instant；GitHub releases | 是 |
| Arcade（ArcadeAI/arcade-mcp） | 有动态：10-02/10-07 提交（MFA 拒绝、schema 修复） | github.com/ArcadeAI/arcade-mcp | 是 |
| Nango | 有动态：v0.71.12（10-02）；10-06 Management MCP 进 Claude 目录 | nango.dev/docs/updates/changelog | 是 |
| Pipedream Connect | 本周无明显窗口内动态（最近为 2025-10/2026-06 条目） | pipedream.com/docs/changelog | 否 |
| AWS AgentCore Gateway | 有动态：10 月私有 CA 支持（未标具体日） | docs.aws.amazon.com/bedrock-agentcore/.../release-notes.html | 是 |
| Google Agent Gateway | 本周窗口无动态（Agent Gateway+Cloud Trace 为 09-30，近窗口/背景） | docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes | 否→背景 |
| Microsoft Toolbox / MCP endpoint | 本周无官方窗口内发布（文档为 2026-07/08） | learn.microsoft.com/azure/foundry/.../toolbox-overview | 否（列背景） |

### 深度笔记（模块 4）

#### MCP（协议本体 + 企业级 Gateway/Registry）
- **本周动态**：协议本体本周无新规范发布（正式规范仍为 2026-07-28 的 stateless core，属背景非本周）；窗口内实质事件有二。其一，**MCP Dev Summit Toronto 于 2026-10-05~06 举行**（Linux Foundation 主办），议程含 Den Delimarsky 主旨演讲《MCP As The Agentic Substrate》，把 MCP 定位为“agentic 底层基质”，Angie Jones 开场。其二，开源企业级 **MCP Gateway & Registry（agentic-community）** 在窗口内连发两版：**1.32.0（2026-10-04）** 引入“前置代理出口”（`EGRESS_FORWARD_PROXY_ENABLED`/`EGRESS_FORWARD_PROXY_CA_BUNDLE`，对企业前置代理网络开放受 SSRF 保护的出口，同时对携带密钥的请求只允许 https），以及可配置注册表子域与额外 ingress 主机名；**1.32.1（2026-10-06）** 修复 `http://` 前置代理下 `proxy_ssl_context` 报错、把 `mcp` 依赖钉在 `<2.0`（因 mcp 2.x 无兼容别名重命名 `streamablehttp_client`）、去掉 otel-collector 的错误健康检查。该仓库定位“企业级 MCP Gateway + Registry：集中 AI 开发工具，安全 OAuth、动态工具发现，对接 Keycloak/Entra”。
- **关键数据**：mcp-gateway-registry stars=963、forks=243、created 2025-05-29、pushed_at 2026-10-06、open_issues 132（gh api 快照，2026-10-08 08:17 +0800）；1.32.0 published 2026-10-04T17:26Z、1.32.1 published 2026-10-06T07:30Z；1.32.0 新环境变量含 `SECURITY_BLOCK_ON_SCAN_FAILURE`（默认 true）、`AWS_EC2_METADATA_DISABLED`。MCP Dev Summit 日期 2026-10-05~06（events.linuxfoundation.org）。
- **原文链接**：https://github.com/agentic-community/mcp-gateway-registry/releases/tags/1.32.0 ；https://github.com/agentic-community/mcp-gateway-registry/releases/tags/1.32.1 ；https://events.linuxfoundation.org/mcp-dev-summit-toronto/ ；https://blog.modelcontextprotocol.io/posts/2026-07-28/ （背景）
- **热度观察（不深写）**：MCP 规范讨论 **#804 "Spec Proposal: A Gateway-Based Authorization Model"** 发布于 **2025-07-01**，**非本期窗口**，故仅列观察、不作本周动态。
- **影响判断**：企业级 Gateway/Registry 的连日修复（出口代理、证书信任、依赖钉版）说明 MCP 的“网关化”已从概念进入**生产运维细节**竞争，而 Dev Summit 的“substrate”叙事把 MCP 抬到基础设施层。对 OpenClaw 的意义：tool gateway 的 OAuth、动态发现、出口安全与工具级审计正被开源实现标准化，OpenClaw 的 plugin/tool runtime 可对标其“网关+注册表”双层结构。

#### A2A（Agent2Agent 协议 / Google 与 Linux Foundation）
- **本周动态**：**2026-10-01 官方发布 A2A CLI（命令名 `a2a`）**，定位“每个 A2A Agent 的统一命令行客户端”，基于 **A2A Go SDK**、讲 **A2A Protocol v1.0**；提供 `a2a card get`（发现 Agent Card）、发送消息、流式更新，并提供协议原生 JSON 输出与可预测退出码以嵌入 CI/流水线，同时可给编码助手当工具用。博客明确它填补两个缺口：非 Agent 系统（shell、定时任务、构建/测试、终端用户）接入 A2A，以及此前多语言社区 CLI“命名/参数/输出各异”的碎片化。仓库侧窗口内活动密集：a2aproject/a2a 提交 **#2283（2026-10-02）“introduce the A2A CLI”**、#2285（10-06）改进 `a2a-protocol.org` 的 agent-readiness 信号，伙伴列表新增 Salt（10-02）、MusedIn / Agent Commerce Gateway / ADEXTO（10-07），community SDK 新增 **a2a-php / a2a-php-sdk（10-07）**。
- **关键数据**：A2A 最新 release **v1.0.1（2026-05-28）**、v1.0.0（2026-03-12）（GitHub releases，背景）；Linux Foundation 披露 A2A 支持组织 **150+**、核心仓 **22,000+ stars**、SDK 覆盖 5 种语言（JS/Java/Go/.NET 等），AP2 支付协议 60+ 组织——均为 **2026-04-09** 口径（背景，非本周）；A2A CLI 基于 Go SDK、协议 v1.0（2026-10-01 博客）。
- **原文链接**：https://a2a-protocol.org/latest/blog/2026/10/01/introducing-a2a-cli/ ；https://github.com/a2aproject/a2a-cli ；https://github.com/a2aproject/a2a/commits （窗口内提交）；https://www.linuxfoundation.org/press/a2a-protocol-surpasses-150-organizations... （背景）
- **影响判断**：A2A 用 CLI 把协议入口下沉到“任何能跑命令的东西”，与 MCP 的 Gateway/Registry 一样都在**降低协议接入摩擦**、扩大网络效应；R3 视角上，A2A CLI 处在“协议与工具生态”段，把非 Agent 端纳入 A2A 网络，为跨 Agent 编排的商品化铺路。对 OpenClaw 的意义：Agent 间协作若走 A2A，一个标准 CLI/工具面即可把 OpenClaw 会话接入外部 Agent 网络。

#### Composio（tool integration / managed auth / MCP 工具网关）
- **本周动态**：**2026-10-07 发布 Composio Instant**——给 Agent 一个“自己的钱包”，可直接使用 100+ 付费工具而无需创建账号、复制 API key 或订阅；官方称已向 Agent 钱包充值 **超过 100 万美元**供当天起消费。Instant 首批覆盖：线索/联系人（Apollo、People Data Labs）、搜索与调研（Exa、Parallel）、视频生成（Higgsfield）、邮件验证（ZeroBounce）、爬虫/SEO/转写/语音/文档表格抽取等，且只覆盖各 provider 的核心动作（搜索/查询/转写）。计费为“用多少付多少”：新账号赠 **$2**，Pro 每月含 **$29** 额度。同期 CLI 连续发 beta：`@composio/cli` 0.4.3-beta.410/411（10-01）→ .412（10-05）→ .413/.414/.415（10-07）。仓库顶部横幅显示 Composio 已进入 **ChatGPT Plugins Directory**。
- **关键数据**：Composio Instant 覆盖 1,500+ 应用、100+ 付费工具；“每月经 Composio 的 tool calls 超 10 亿次”、用户“超百万”（官方博客 2026-10-07，B 级自披露）；赠送 $2 / Pro $29 每月（同上）；仓库 stars=30,464、forks=4,846（hot-scan gh api 快照 2026-10-08）。
- **原文链接**：https://composio.dev/blog/composio-instant ；https://github.com/ComposioHQ/composio/releases ；https://composio.dev/blog
- **影响判断**：这是工具层第一个把“**Agent 自主付费**”产品化的公开动作，把工具访问从“接得通”推进到“按用量结算”，可能改变工具供应商的分发与定价（对 OpenClaw：若工具生态走向计价网关，OpenClaw 的工具授权层需考虑预算/计费/审计的钩子）。

#### Arcade（ArcadeAI / arcade-mcp：tool execution + MCP runtime + auth 边界）
- **本周动态**：窗口内仓库提交聚焦 **auth/MFA 与工具 schema 质量**。2026-10-07 提交 **#951**：当组织要求强认证（MFA/passkey）时，Arcade 拒绝纯密码登录并返回 RFC 9470 `insufficient_user_authentication` 挑战；此前 CLI 读不到该挑战，会保存随后必然失败的 token，现改为展示 Arcade 的说明、**登出**该被拒会话并提示 `arcade login`，其中 `arcade-core` 升到 **4.22.1**、根包升到 **1.16.2**。10-02 提交 **#950** 修复 `arcade-core` 从工具 schema 丢失 TypedDict 字段描述的问题（改为基于 AST 提取继承链上的字段说明，支持 `Required`/`NotRequired`），`arcade-core` 升 **4.22.0**。10-05 提交 #959 加“open-pr”技能与 PR 模板重构（工程侧）。定位上，Arcade 自称“生产 Agent 的 MCP runtime”，提供安全 Agent 授权、可靠工具与治理。
- **关键数据**：`arcade-core` 4.22.0（10-02）→ 4.22.1（10-07）；根包 1.16.2（10-07）；仓库 stars=1,046、forks=118（hot-scan 快照）。Arcade “撰写/参与 MCP 工具授权规范”之说法见于第三方对比文（TrueFoundry 2026-09-28，二手，不作一手依据）。
- **原文链接**：https://github.com/ArcadeAI/arcade-mcp/commits/main ；https://www.arcade.dev/blog/
- **影响判断**：Arcade 把“强认证拒绝 + token 不落无用”打磨为产品细节，说明**工具运行时的身份边界（谁能调用、以何身份）正成为 MCP runtime 的差异化点**；对 OpenClaw 的身份/工具授权模块有直接参照。

#### Nango（open-source integrations / OAuth token management / MCP server）
- **本周动态**：**v0.71.12（2026-10-02）** 发布，含 **Azure Key Vault 作为 DEK 包裹 provider**（KMS 侧加密托管）、Slack app 配置 token、Discord Bot、邮件类集成；并修复 MCP 相关“保护凭据、确认破坏性操作”（#7750）、`mcp` 工具搜索误报未连接等。文档 changelog 另记：**2026-10-06 Management MCP server 进入 Claude 的 connector 目录**（可在 Claude / Claude Code / Codex / VS Code / ChatGPT 中配置集成、调 API、触发 sync、部署函数）；同日宣布**弃用 Connection MCP server**，改用更可用的 "agent sessions"（影响：用 Environment API key + `connection-id`/`provider-config-key` 头的 Agent 需迁移）；**2026-10-01** 第二轮 webhook 验证（支持“允许未验证 webhook”按集成开关、转发时带 `X-Nango-Webhook-Unverified`、对不签名 provider 要求 per-connection secret）；**10-01** 记 9 月新增 **49 个 API**。
- **关键数据**：v0.71.12 published 2026-10-02（GitHub release）；9 月新增 49 个集成（Nango changelog 2026-10-01）；仓库 stars=12,552、forks=1,424（hot-scan）。
- **原文链接**：https://nango.dev/docs/updates/changelog ；https://github.com/NangoHQ/nango/releases/tag/v0.71.12
- **影响提示**：Nango 把“MCP server 进主流客户端目录 + 从 Connection MCP 迁向 scoped agent sessions”作为主线，反映集成平台正把**每用户 OAuth 与作用域化会话**当作默认形态（R3：集成与交付段，议价在 token 托管与目录分发）。

#### Pipedream Connect（managed auth / integration platform / MCP）
- **本周动态**：**本周无重大公开动态**。其公开 changelog 最近的窗口相关条目均早于本期（最近为 2025-10-01 的 MCP+ChatGPT 支持、2025-09 的 SDK 等；2026 年条目未见落在 10-01~10-07 的实质发布）。
- **关键数据**：官网口径“托管 3,000+ API 的 auth、10,000+ 工具带 toolAnnotations”（pipedream.com，B 级长期口径，非本周）；本次未取得窗口内新版本号。
- **原文链接**：https://pipedream.com/docs/changelog
- **影响判断**：（背景，非本周）Pipedream 的托管 OAuth + 静态 MCP URL 曾是“零配置接入多工具”的代表；本周无信号，赛道热度更多集中在 MCP Gateway（见 WorkOS 对比与 Composio）。

#### AWS AgentCore Gateway
- **本周动态**：AWS AgentCore 发布说明的 **"October 2026"** 条目记为 **Gateway 支持私有 CA 签发的 TLS 证书**：可对接“私有 CA 签发服务器证书”的 **MCP server / OpenAPI / HTTP proxy（passthrough）** 目标，无需在目标前放 ALB；默认只信任公共 CA 证书，现可注册 PEM 编码 CA 证书（存放于 S3 或 Secrets Manager）作为出站 TLS 信任锚，配合 **Amazon VPC Lattice** 私有端点直连 VPC 内目标。**局限**：该条目只标“October 2026”、未给具体日期，无法确证落在 10-01~10-07 内（按 A 级事实但日期限述）。
- **关键数据**：条目名称 "Gateway: Private certificate authority support for targets"（AWS 官方 release notes，October 2026）；相关基线：AWS Agent Registry 于 **2026-08** GA、Memory 直写长记忆与 PrivateLink 于 08 月（背景，非本周）。
- **原文链接**：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- **影响判断**：把“企业私有 PKI + VPC 内直连”接进 Agent 工具网关，是**云厂把 MCP Gateway 拉进企业网络边界**的动作；R3 上凸显网关层与云网络/安全栈的耦合加深。

#### Google Agent Gateway
- **本周动态**：**本周窗口内无公开动态**（Gemini Enterprise Agent Platform release notes 的 10 月条目仅含 CodeMender v0.13/0.12 与 Gemini Nano Banana 2.1 GA，未见 Agent Gateway/Identity 更新）。最近相关信号为 **2026-09-30** "Agent Gateway 集成 Cloud Trace（Preview）"——提供 Agent→网关→跨 Google Cloud 服务/工具/Agent/MCP server 的端到端请求可观测（**背景/近窗口，非本周**）。
- **关键数据**：Cloud Trace×Agent Gateway 发布于 2026-09-30（Google 官方 release notes，窗口外 1 天）；Agent Registry 支持 A2A v1（背景）。
- **原文链接**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- **影响判断**：Google 本周把发布节奏放在模型与安全 Agent（CodeMender）上，网关层信号仅“近窗口”的可观测集成；趋势仍是**网关 + 可观测绑定**。

#### Microsoft Toolbox / MCP-compatible endpoint
- **本周动态**：**本周无窗口内官方发布**。Foundry "What's new" 最新为 **2026-08**（文档 updated 2026-09-09，背景）；Toolbox 概念/操作文档为 **2026-07-30 / 2026-08-26**（背景）；Toolbox 的网络隔离文档列于 8 月新文。仅见社区 Q&A **2026-10-05** 报“Toolbox 内 Skills 未被发现”，属用户问题、非官方发布，列观察。
- **关键数据**：Toolbox=单一托管 MCP endpoint 集中管理与共享工具（Microsoft Learn，背景）；本周未取得窗口内版本号或 GA/preview 变更。
- **原文链接**：https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/toolbox-overview
- **影响判断**：（背景，非本周）微软把“MCP endpoint + 工具目录/策展”作为 Foundry 工具层形态，方向与 MCP Gateway 趋同；本周无新证据。

### 模块 4 洞察
- 本周工具层的增量价值从“协议发布”转向**接入面与结算面**：开源 MCP Gateway/Registry 拼运维与安全细节、A2A 用 CLI 扩张网络、Composio 用“Agent 钱包”打开按用量付费，三者共同指向工具生态的**标准化 + 商品化前夜**，议价正从“协议本身”向“网关治理与用量结算”迁移。

## 六、模块 5 — Identity / Auth / Permission 身份与权限层

### 本周模块结论
- **本周身份层最强信号是“第三方 IdP × 云厂 AgentCore”的委托模式落地**：Okta 2026-10-02 博文给出 XAA / ID-JAG 的两条拓扑（Pattern A：Agent 内自查；Pattern B：AgentCore Gateway + AWS Lambda 拦截器集中换票），并点破关键边界——**用户 OIDC token 不能直接转发给下游 MCP server**（audience 不匹配，等于取消边界）。
- **MCP 网关的“身份四家对比”于 10-02 成形**：WorkOS 文章给出 Cloudflare / Okta / Auth0 / Microsoft 的 MCP gateway 状态与方法（Access OAuth、Okta 身份+XAA、Auth0 token vault、Entra Conditional Access），并强调“网关不替代 MCP server 自身的授权”。
- **云厂自家 Identity 本周窗口内静默**：AWS AgentCore Identity 的 Consent Portal、Entra Agent ID 平台、Google Agent Identity 均为 6–9 月背景；本周无新发布。
- **权限专项观察**：行业正收敛到“**短时、IdP 中介、作用域化、可审计**”的 token（XAA/ID-JAG、OAuth 2.1、token vault、scoped agent sessions），静态 API key 与静默长期授权被明确列为反模式。

### 固定对象状态表（模块 5）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 本周无窗口内动态（Consent Portal 为 2026-09-01） | aws.amazon.com/about-aws/whats-new/2026/09 | 否→背景 |
| Microsoft Entra Agent ID / Foundry agent identity | 本周无窗口内动态（文档 2026-06/08） | learn.microsoft.com/entra/agent-id | 否→背景 |
| Google Agent Identity / Gateway | 本周无窗口内动态（Agent Identity API 06 月；Cloud Trace 09-30） | docs.cloud.google.com/.../release-notes | 否→背景 |
| Arcade Auth / tool permission | 有动态：10-07 强认证（MFA/passkey）拒绝处理 | github.com/ArcadeAI/arcade-mcp | 是 |
| Composio Auth | 有动态：10-07 Instant 钱包（支付授权）+ 托管 auth | composio.dev/blog/composio-instant | 是 |
| Nango OAuth / token management | 有动态：10-02 v0.71.12（Azure Key Vault DEK）；10-06 agent sessions | nango.dev/docs/updates/changelog | 是 |
| Pipedream Connect managed auth | 本周无窗口内动态 | pipedream.com/docs/changelog | 否→背景 |
| Okta（动态池） | 有动态：10-02 AgentCore+XAA/ID-JAG 博文 | okta.com/blog/ai/okta-amazon-bedrock-agentcore-security | 是 |
| WorkOS（动态池） | 有动态：10-02 MCP gateway 身份四家对比 | workos.com/blog/mcp-gateways-compared | 是 |
| Auth0（动态池） | 无窗口内动态（Agent Gateway beta 2026-09-18） | auth0.com/blog/auth0-agent-gateway-beta | 否→背景 |
| Cloudflare（动态池） | 无窗口内动态（MCP portals GA 2026-09-24） | workos 对比文（二手） | 否→背景 |
| Permit.io（动态池） | 无明确窗口内发布 | permit.io/tags/ai-identity | 否 |
| Descope（动态池） | 无窗口内发布（2026-09-02 对比文） | descope.com/blog | 否 |
| Clerk（动态池） | 无明确窗口内日期（MCP server Beta 文档） | clerk.com/docs/guides/ai/mcp | 否 |

> 对象计数：模块 5 固定对象 7（AWS/MS/Google/Arcade/Composio/Nango/Pipedream）+ 动态池 7（Okta/WorkOS/Auth0/Cloudflare/Permit.io/Descope/Clerk）；窗口内实质动态为 Arcade、Composio、Nango、Okta、WorkOS 共 5。

### 深度笔记（模块 5）

#### AWS AgentCore Identity
- **本周动态**：**本周窗口内无新的 Identity 发布**。最近一次为 **2026-09-01** "Amazon Bedrock AgentCore Identity now offers a managed consent portal"——托管同意门户，消除自建 OAuth callback 的负担（**背景，非本周**）。本周与 AgentCore Identity 相关的可读信号来自第三方：**Okta 于 2026-10-02 发布《The agent is not the user: Using Amazon Bedrock AgentCore with Okta to secure AI agent identity》**，以 AgentCore 为例说明身份边界如何被正确处理（详见下文 Okta）。
- **关键数据**：Consent Portal 发布日 2026-09-01（AWS what's-new，背景）；Consent Portal 需以“配 JWT 入站认证的 AgentCore Gateway”为源、IdP 许可 scope 含 `openid`（AWS release notes，背景）。
- **原文链接**：https://aws.amazon.com/about-aws/whats-new/2026/09/amazon-bedrock-agentcore/ ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-consent-portal.html （背景）
- **影响判断**：AWS 把“用户同意”做成托管门户，是把 Agent 授权从代码搬进平台控制面的动作；本周无新进展，态势延续。

#### Microsoft Entra Agent ID / Foundry agent identity
- **本周动态**：**本周窗口内无公开动态**。既有能力为背景：Entra Agent ID 提供“Agent 身份/身份蓝图（agent identity blueprint）”等新对象类型，为 Agent 建立目录内一等身份；Foundry 侧把每个 Agent 自动注册进目录，受 Conditional Access 治理。文档与发布集中于 2026-06~08 月，**背景，非本周**。
- **关键数据**：Entra Agent ID 概念文档 2026-06-24；Foundry agent identity 概念文档 2026-08-25（Microsoft Learn，背景）；本周未取得窗口内版本号或 GA 变更。
- **原文链接**：https://learn.microsoft.com/en-us/entra/agent-id/what-is-microsoft-entra-agent-id ；https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity （背景）
- **影响判断**：（背景，非本周）微软把 Agent 当“目录主体”治理，与 Okta 把 Agent 建模为“有 owner/凭据/策略的身份”路线一致，说明**“Agent 是独立身份主体”已成主流设定**；本周无新证据。

#### Google Agent Identity / Agent Gateway（身份侧）
- **本周动态**：**本周窗口内无公开动态**。Gemini Enterprise Agent Platform release notes 的 10 月条目均为 CodeMender（v0.13/0.12）与 Gemini Nano Banana 2.1 GA，未见 Agent Identity/Gateway 更新；最近相关为 **2026-09-30** Agent Gateway 集成 Cloud Trace（Preview，**背景/近窗口，非本周**）。既有身份能力为背景：Agent Identity API（`agentidentity.googleapis.com`）与 Agent Registry GA、Agent Gateway 用 Identity-Aware Proxy + Access 策略治理 MCP server/Agent 通信（6 月前后）。
- **关键数据**：Cloud Trace×Agent Gateway 2026-09-30（Google 官方）；Agent Identity API / Agent Registry GA 属 2026-06 口径（背景）；本周无窗口内日期。
- **原文链接**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- **影响判断**：（背景，非本周）Google 的 Agent 身份与网关治理（IAP/Access、mTLS）已成体系，本周发布节奏偏向模型与安全 Agent，身份侧无增量。

#### Arcade Auth / tool permission
- **本周动态**：窗口内 Arcade 的 auth 侧动作集中在**强认证（MFA/passkey）的拒绝语义**。2026-10-07 提交 **#951**：当组织要求强认证时，Arcade 以 RFC 9470 `insufficient_user_authentication` 挑战拒绝纯密码登录；此前 CLI 读不到该挑战会保存“随后必然失败”的 token，现改为**展示原因并登出被拒会话**（保留 org/project/user 与 URL，便于重新 `arcade login`），失败 refresh 也会丢弃 `invalid_grant` 的 refresh token 以免卡在“already logged in”（`arcade-core` → 4.22.1、根包 → 1.16.2）。10-02 提交 **#950** 修复工具 schema 字段描述丢失（`arcade-core` → 4.22.0），提升 Agent 看到的工具参数说明质量。
- **关键数据**：`arcade-core` 4.22.0（10-02）→ 4.22.1（10-07）；根包 1.16.2（10-07）；仓库 stars=1,046、forks=118（hot-scan 快照）。
- **原文链接**：https://github.com/ArcadeAI/arcade-mcp/commits/main
- **影响判断**：把“认证失败的正确落盘/清理”做成明确行为，是**工具运行时身份边界产品化**的细节；对 OpenClaw 的 tool permission 与凭据生命周期管理有参照。

#### Composio Auth（managed auth + 支付授权）
- **本周动态**：**2026-10-07 Composio Instant** 首次把“授权”扩展到**支付维度**——Agent 拥有钱包，可即时使用 100+ 付费工具而无需建账号/配 key/订阅；官方称已向 Agent 钱包充值超 100 万美元，新账号赠 $2、Pro 每月含 $29。底层仍是既有托管 auth（1,500+ 应用、每用户会话），Instant 在其上加“按调用付费”的额度授权。
- **关键数据**：100+ 付费工具、1,500+ 应用、“月超 10 亿次 tool calls”、百万用户（官方博客 2026-10-07，B 级自披露）；$2 / $29 每月额度（同上）；仓库 stars=30,464、forks=4,846（hot-scan）。
- **原文链接**：https://composio.dev/blog/composio-instant ；https://composio.dev/toolkits
- **影响判断**：支付授权成为 Agent 权限层的新子问题（谁批准 Agent 花钱、上限与审计如何做）；这是**权限从“能不能用”扩展到“能花多少”**的信号，对 OpenClaw 的工具预算/审批/审计设计有前瞻价值。

#### Nango OAuth / token management
- **本周动态**：**v0.71.12（2026-10-02）**含 **Azure Key Vault 作为 DEK 包裹 provider**（KMS/密钥托管侧扩展）、Slack app 配置 token、Discord Bot 等；MCP 侧修复“保护凭据、确认破坏性操作”。**2026-10-06** 起 **Management MCP server 进入 Claude connector 目录**（Claude/Claude Code/Codex/VS Code/ChatGPT 可用），并推荐走 OAuth；同日**弃用 Connection MCP server**，改推更可用的 **agent sessions**（影响使用 Environment API key + `connection-id`/`provider-config-key` 头的 Agent）。
- **关键数据**：v0.71.12 published 2026-10-02（GitHub release）；Management MCP 进目录与 Connection MCP 弃用均为 2026-10-06（Nango changelog）；仓库 stars=12,552、forks=1,424（hot-scan）。
- **原文链接**：https://nango.dev/docs/updates/changelog ；https://github.com/NangoHQ/nango/releases/tag/v0.71.12
- **影响判断**：Nango 把“每用户 OAuth + 作用域化 agent sessions”作为默认，叠加 KMS 侧 DEK 托管，是**集成平台把 token 托管与目录分发当作议价点**的体现（R3：集成与交付段）。

#### Pipedream Connect managed auth
- **本周动态**：**本周无重大公开动态**。公开 changelog 最近条目均早于本期（2025-09/10 的 SDK 与 MCP+ChatGPT；2026 年无落在 10-01~10-07 的实质发布）。
- **关键数据**：官网口径“托管 3,000+ API auth”（背景，长期口径，非本周）；本次未取得窗口内新版本。
- **原文链接**：https://pipedream.com/docs/changelog
- **影响判断**：（背景，非本周）托管 auth 赛道本周热度转向 MCP Gateway 与 Agent 钱包，Pipedream 无窗口内增量。

#### 动态池：Okta（AgentCore + XAA/ID-JAG）
- **本周动态**：**2026-10-02** Okta 与 AWS 联合发布《The agent is not the user: Using Amazon Bedrock AgentCore with Okta to secure AI agent identity》。文章指出 AgentCore 只做**入站 JWT 校验**，出站工具调用的身份缺口需自行解决；明确“**简单转发用户 token 会失败**”——OIDC token 是发给 Web 应用客户端的身份声明，不是给下游 resource server 的 bearer 凭据，转发等于让 MCP server 接受**audience 不符**的 token、丧失边界。解法是**两步委托**：Cross-App Access（XAA）/ ID-JAG 换取带“用户+Agent 双重归因”的短时 scoped token。给出两条拓扑：**Pattern A**（Agent 内用 Okta SDK 自查 XAA，动件少、密钥在 Agent 运行时）；**Pattern B**（AgentCore Gateway + **AWS Lambda 拦截器**集中换票，Agent 只需在允许的头里带用户 token，密钥材料放 AWS Secrets Manager 只给 Lambda 访问，策略集中可审计、无需重部署 Agent）。前提是**Agent 需在 Okta 中作为可治理身份存在**（有 owner、凭据、资源访问策略），可从 AgentCore 通过 Okta Integration Network 的 AWS 应用自动导入。
- **关键数据**：博文日期 2026-10-02（Okta）；XAA 已被纳入 MCP 作为**授权扩展**（Okta/Auth0 口径，背景：Okta 2025-11-25）；XAA 早期采用者 25+（含 Anthropic、Cloudflare、Cursor、Keycloak、MintMCP、Scalekit、WorkOS、Zuplo 等，Okta press 2026-06-23，背景）。
- **原文链接**：https://www.okta.com/blog/ai/okta-amazon-bedrock-agentcore-security/
- **影响判断**：这是本周权限层**最可操作的一手参考**——它把“Agent 代表用户行动”落到 token 交换的 audience/归因/密钥落点选择；Pattern B（网关+拦截器集中换票）尤其值得 OpenClaw 的 tool gateway/auth 设计借鉴。

#### 动态池：WorkOS（MCP gateway 身份对比）
- **本周动态**：**约 2026-10-02** WorkOS 发布《MCP gateways compared: Cloudflare, Okta, Auth0 and Microsoft》，以“Status (Oct 1, 2026)”为基准给出四家 MCP 网关定位：**Cloudflare MCP server portals**（2026-09-24 GA，Cloudflare Access OAuth/服务 token，Code Mode 折叠工具以控上下文，Logpush 出 SIEM）；**Okta Agent Gateway**（Q3 计划 GA、7 月起 research release，Okta 签发 token、Agent 注册为身份，XAA/代办同意，逐工具调用策略与审计链）；**Auth0 Agent Gateway**（2026-09-18 beta，面向多租户 SaaS，短时 token 只在网关有效、Token Vault + token exchange）；**Microsoft Entra MCP firewall**（public preview since Aug，走 Global Secure Access 网络路径，按 server/method/tool/protocol version 允许或阻断，Generative AI Insights 进 Sentinel）。文章强调共同点与差异，并重申“**网关不替代 MCP server 自身授权**”。
- **关键数据**：四家状态见文（GA 09-24 / GA 计划 Q3 / beta 09-18 / public preview，均为背景事件，本文 10-02 汇总）；Okta GA 计划 Q3 2026。
- **原文链接**：https://workos.com/blog/mcp-gateways-compared ；https://auth0.com/blog/auth0-agent-gateway-beta/ （背景）
- **影响判断**：一篇文章把“MCP 网关”从工具网关话题收编进**身份/治理品类**，标志 IAM 厂商正主动抢 MCP 身份层；对 OpenClaw 的意义是网关不只是工具发现，更是身份与审计的事实标准入口。

#### 动态池：其他（Auth0 / Cloudflare / Permit.io / Descope / Clerk）
- Auth0：**无窗口内动态**（Agent Gateway beta 为 2026-09-18，背景）；Cloudflare：**无窗口内动态**（MCP portals GA 2026-09-24，背景）；Permit.io：**无明确窗口内发布**（其 ai-identity 内容页长期在线，未取得 10-01~10-07 新发布）；Descope：**无窗口内发布**（最近为 2026-09-02 对比文，背景）；Clerk：有面向 MCP 的 remote server（Beta）文档，但**未取得窗口内日期**，列观察不深写。
- **原文链接**：https://auth0.com/blog/auth0-agent-gateway-beta/ ；https://clerk.com/docs/guides/ai/mcp/clerk-mcp-server
- **影响判断**：动态池本周真正有窗口内一手动作的是 Okta 与 WorkOS；Auth0/Cloudflare 的强信号发生在 9 月（背景），说明该赛道**9 月密集、10 月首周内容侧为主**。

### 模块 5 洞察
- 本周身份层的主线是**“Agent 作为一等身份 + IdP 中介的短时委托 token”**：Okta 用 AgentCore 案例把 XAA/ID-JAG 的 audience 边界与两种拓扑讲清，WorkOS 把 MCP 网关收编进 IAM 品类；权限正从“有没有 key”升级为“以谁的身份、花多少、能否审计”，云厂自家 Identity 本周静默、生态侧（IAM 厂商×MCP 网关）在抢标准。

## 七、模块 6 — Context / Memory / Knowledge 记忆知识层

### 本周模块结论
- **检索质量与权限治理同时下沉到开源 Context DB**：OpenViking v0.4.23（10-02）把召回重写为「单次全局向量召回 + 统一 rerank」，并新增 ACL MCP 工具与 OIDC token 支持；Cognee v1.6.3（10-07）强化时序检索边界、ingest 校验与账号权限收敛。记忆层竞争焦点从「存不存得下」转向「召回准不准、谁能读谁的」。
- **从开源库转向托管 context 服务**：Crawl4AI（10-05）在 main 分支推 cloud launch 软启动（free credit、无额度无截止）；supermemory 集中落地 v5 API 迁移并退役 `@supermemory/ai-sdk`（10-06，breaking）。头部记忆项目正把「库」包装成「记忆 API / context 服务」。
- **摄取层向 agent 会话化演进**：Firecrawl 本周给全部官方 SDK 增补 agent exchange/threadId/mode，并新建 gov 检索索引，方向是让抓取结果直接成为 agent 长期会话的可检索记忆源。
- **云厂收编信号**：OpenViking 发布说明加入火山「OpenViking Service」产品页入口，记忆层被平台方包成托管服务；ACL/OIDC 等企业治理项补齐，向企业采购要求靠拢。

### 固定对象状态表（模块 6）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态（v0.4.23，10-02） | gh releases/tags/v0.4.23；commits | 是 |
| Mem0 | 有动态（安全修复 + SDK 文档刷新，无新 release） | gh commits（10-01~10-07） | 是 |
| Cognee | 有动态（v1.6.3，10-07） | gh releases/tags/v1.6.3 | 是 |
| supermemory | 有动态（v5 API 迁移，10-06 breaking） | gh commits | 是 |
| Letta | 本周无重大公开动态（窗口内 commits=0） | gh commits 空返回 | 是 |
| Zep/Graphiti | 有动态（LLMRuntime，10-06） | gh commits（#1778） | 是 |
| Firecrawl | 有动态（agent exchange / gov 索引） | gh commits | 是 |
| Crawl4AI | 有动态（cloud launch 软启动，10-05） | gh commits（main） | 是 |
| LightRAG/GraphRAG/LlamaIndex/LangMem/Onyx/Haystack/Jina/Unstructured/向量库 | 热度观察 | 见下文强观察池 | 否（观察） |

> 覆盖：模块 6 固定对象 8/8（上述 OpenViking…Crawl4AI）；来源：gh api 直查约 22 次中含本模块多个；本周动态主要证据为一手 GitHub release body/commits（完整读取）。

### 深度笔记（模块 6）

#### OpenViking（必覆盖）
- **本周动态**：v0.4.23 于 **2026-10-02** 发布（同步 cli@0.4.23、python-sdk@0.1.13、sdk/go/v0.0.5）。① 检索层重写：#5450 每条查询改单次全局向量召回 + 按模式统一 rerank，移除目录递归与父级分数传播，阈值在 rerank 后应用；#5454 移除热度加权与 `retrieval.hotness_alpha`；#5214 `find`/`search` 新增事件时间衰减参数 `events_time_decay_protection`；#5456 `search` 新增 `search_type="keywords"` BM25 关键词检索，覆盖 REST/MCP/CLI 与 Py/TS/Go SDK；#5486 Jev rerank 新增 Choice 模式。② 权限/治理：#5466 新增 MCP 工具 `list_users`/`list_groups`/`get_acl`/`set_acl`，`write`/`add_resource` 支持 `acl` 参数；#5483 账号变更缺注册表基线时拒绝写入；#5448 `ovcli.conf` 接受 `oidc_token`；#5495 Studio 账号级记忆抽取规则编辑。③ 记忆整理：`ov compile --skill memory` 就地去重/合并/规范化（#5178）；`reindex` 迁 RFV planner、加 `force`、异步可恢复（#5416）。窗口内 commits 另见 10-06 新增 **context-gateway**「把 OpenViking memory 带回任意 API-key 客户端」(#5625)、Codex 插件内建 usage summary(#5699)、ov-usage 来源卡片(#5653)、10-05 Hermes Quick Local 本地嵌入(#5465)。④ 兼容性：`memory.session_auto_commit` 的 `default_enabled`/`idle_enabled` 合并为 `enabled`（默认 false，旧键不兼容被忽略）；检索评分与排序相对 v0.4.22 会变化，用 `score_threshold` 的调用方需重校准；带无效 API key 访问 `/health` 由匿名 200 改为认证错误。
- **关键数据**：stars 39366 / forks 3108 / pushed_at 2026-10-07（hot-scan GitHub 快照，取得 2026-10-08 08:16 +0800；绝对值为快照，非周增速）。
- **原文链接**：https://github.com/volcengine/OpenViking/releases/tag/v0.4.23
- **影响判断**：把召回从「层级递归」改为「全局召回 + 统一 rerank」是路线级修正，直接决定 Context DB 的精度天花板；一次放开 ACL + OIDC 说明其在补企业治理短板，配合火山 Service 入口，记忆层正被「开源引擎 + 云托管」双轨收编。对 OpenClaw 而言，`ov-usage` 来源卡片与 hook 级 recall（`recallExcludeUris`/`recallQueryFilters`）值得作为 Agent Memory 插件的交互参照。

#### Mem0
- **本周动态**：窗口内**无新 release**（最新 v2.2.1 / ts-v3.3.1 发布于 2026-09-25，属背景）。10-01~10-07 的窗口内工作集中在**安全加固与文档一致性**：10-05 `fix(security)` 解决 13 个 Vanta HIGH Dependabot 漏洞（#7528）；10-01 `fix(security)` 解决 7 个 Vanta MEDIUM 漏洞（undici、ip-address、adm-zip，#7510）；10-07 `fix(vector-store)` 停止把 GoogleMatchingEngine 的 service account 私钥写进 DEBUG 日志（#7506）；10-07 `fix(ts-oss)` 停止 `add()` 修改调用方传入的 filters 对象（#6797）；10-07 `docs(skills)` 按 SDK 2.2.1 / TS 3.3.1 刷新 mem0 skills（#7548）。可见其维护节奏是「9 月底功能发版 → 10 月初补安全与 SDK 对齐」。
- **关键数据**：stars 66778 / forks 7859 / pushed_at 2026-10-07（hot-scan 快照，2026-10-08 取得）；最新 release `v2.2.1` @ 2026-09-25。
- **原文链接**：https://github.com/mem0ai/mem0/commits/main（窗口内 commits）；https://github.com/mem0ai/mem0/releases/tag/v2.2.1（背景版本）
- **影响判断**：Mem0 本周无产品级动态，但「把私钥从日志移除」与两轮 Dependabot 高危修复，反映通用记忆层的安全面（凭证、日志、依赖）正成为企业评估门槛。作为 universal memory layer 的代表，其本周增量弱于 OpenViking/Cognee，评价应写「静默/维护周」而非趋势信号。

#### Cognee
- **本周动态**：**v1.6.3 于 2026-10-07 发布**（v1.6.2→v1.6.3，主题 "Better Temporal Search & Retrieval Accuracy"）。① 时序检索：#1 时间窗 `since X`/`until X` 现**包含边界日**并修正 off-by-one，日期锚点按与窗口的紧密度排序，并扩大候选池提升边界召回；自然语言检索不再跑 "turn analysis"、且在 payload 中返回匹配到的数据库行。② ingest 与图：删除 Notion 渲染的人工深度上限、避免递归展开；拒绝畸形 `node_set`（非 JSON list）并校验条目；新增 `dlt_config` 分组并恢复 `temporal_columns`。③ 权限收敛：**agent 不能再创建嵌套 agent**，`create_agent` 拒绝 nested agents；父账号可正确访问其 agent 数据集；公开注册不再接受 `parent`。④ 破坏性变更：移除 `temporal_cognify` 配置项；DLT 依赖钉在 `<1.31`；移除日志中的 "extraction reason" 以免泄露内部推理。⑤ 适配器/技术：Turso、LanceDB、Pylance 适配器与向量存储重构；新增 `dateparser>=1.2,<2` 依赖。
- **关键数据**：stars 31562 / forks 3242 / pushed_at 2026-10-07（hot-scan）；release v1.6.3 published 2026-10-07T14:21:57Z；Python 需 `>=3.10,<3.15`。
- **原文链接**：https://github.com/topoteretes/cognee/releases/tag/v1.6.3
- **影响判断**：时序检索是 agent memory 相对纯向量 RAG 的差异化卖点，Cognee 本周把「时间窗边界正确性」当版本主题，说明记忆层竞争已从「能存」进入「时间语义准不准」。同时禁止 agent 自我复制式建 agent，是权限/安全边界的实质收紧，对企业多 agent 部署有直接治理意义。相对 OpenViking 的 ACL 工具，两者都在补「谁能读写记忆」这一课。

#### supermemory（memory & context engine / Memory API）
- **本周动态**：本周无新 Git tag release（最新 `server-v0.0.8` @ 2026-08-17，背景），但窗口内 commits 密集，核心是 **v5 API 全面迁移**：10-06 一次性补全 v5 文档面——versioned V5 API reference（#1690）、V3/V4→V5 migration guide（#1691）、分页默认值（#1766）、`attach` 改名 `include`（#1763）、`search` 的 `isInference`（#1764）、`GET memory`（#1771）、参数放置（#1770）、namespace 分页（#1769）；并发布 **`@supermemory/tools` 3.0 基于 v5 API 且退役 `@supermemory/ai-sdk`（#1773，breaking）**；10-06 `fix(python)` 在 wrapper 包中把 `supermemory` 上限钉在 `<5`（#1774）。产品侧：**10-01 `feat(livekit)` 为 LiveKit Agents 增加持久记忆（#1702）**；10-07 MCP 保留旧 snake_case 工具名作 deprecated 别名（#1782）。安全/合规：10-03 `fix(auth)` 升级 Better Auth 到修补版 1.7.6（#1719），10-02 升级 better-auth 1.3.3→1.6.22（#1741）；10-04 文档披露自托管安全与 telemetry 行为（#1711）；10-03 MCP 把 out-of-credits 错误从 error rate 中剔除（#1753）。另新增 `llms.txt` 摘要（#1757）。
- **关键数据**：stars 31146 / forks 2739 / pushed_at 2026-10-07（hot-scan 快照）。
- **原文链接**：https://github.com/supermemoryai/supermemory/commits/main
- **影响判断**：一周内完成 API 大版本（v5）切换并同步退役旧 SDK，是「Memory API 服务化」的典型动作——把接口契约当产品节奏管理，比「库 + 语义版本」更激进。接入 LiveKit（实时语音 agent）说明记忆层正在向实时会话场景延伸。MCP 工具名兼容与 auth 补丁显示其同时面对开发者迁移成本与安全审计压力，商业上更像「托管 Context API」而非自托管组件。

#### Letta（stateful agents / persistent context）
- **本周动态**：**本周无重大公开动态**。窗口内 `letta-ai/letta` commits 查询返回空集（since 2026-09-30 无 commit），仓库 `pushed_at` 为 2026-09-10；最新 release `0.16.8` 发布于 2026-05-14。（背景，非本周：Letta 长期以 stateful agent + 自管理记忆块（memory blocks）路线著称，0.16.x 系列已持续数月。）
- **关键数据**：stars 25070 / forks 2644 / pushed_at 2026-09-10 / 最新 release 0.16.8 @ 2026-05-14（hot-scan 快照，2026-10-08 取得）。
- **原文链接**：https://github.com/letta-ai/letta/releases（最近 release 均为窗口外）
- **影响判断**：Letta 在本窗口完全静默，与 OpenViking/Cognee/supermemory 的发版节奏形成对照；不能据此判断项目停滞（release 间隔本就较长，但 repo 自 9-10 起无 push 值得持续观察）。本期对其结论只能写「静默 + 近两周无公开增量」，不得用旧闻凑动态。

#### Zep / Graphiti（合并追踪）
- **本周动态**：窗口内无新 Git tag（最新 `v0.30.2` @ 2026-09-08 ）但 **10-06 引入 `LLMRuntime`（PR #1778），用于 prompt 与模型路由**——把「用哪个模型/prompt 做图谱抽取」抽象成可配置运行时，属于把 memory 引擎的模型层解耦的基础设施化动作。其余窗口内 commit 以安全与兼容为主：10-07 升级 urllib3/tornado/jupyterlab/fsspec/langgraph/multidict 修安全公告（#1972）；10-06 升级 mcp_server 的 pyjwt 与 sentence-transformers（#1965）；10-06 `fix(falkordb)` 用 DDL 形式为 FalkorDB 6.x 建节点全文索引（#1963）。注意仓库内多条 commit 为 CLA 签名机器人记录，不构成功能动态。（背景，非本周：Zep 为企业级 temporal knowledge graph memory 服务，Graphiti 为其 Apache-2.0 开源引擎，较新版 v0.30.x 在 9 月初发布。）
- **关键数据**：stars 31529 / forks 3236 / pushed_at 2026-10-07 / 最新 release v0.30.2 @ 2026-09-08（hot-scan 快照）。
- **原文链接**：https://github.com/getzep/graphiti/commit/689de29（LLMRuntime #1778）
- **影响判断**：LLMRuntime 让图谱记忆的「抽取模型」可插拔，降低对单一模型的锁定，是 memory 层走向「引擎 + 可替换模型后端」的信号，也与 OpenViking 的 embedder/rerank 可配置路线同向。FalkorDB 6.x 索引修复说明其图数据库后端矩阵在持续扩展。本周增量中等，策略是「稳基础设施、不追发版」。

#### Firecrawl（外部知识获取入口：search / extract / crawl API）
- **本周动态**：窗口内无新 release（最新 `v2.11.0` @ 2026-06-19，背景），但 commits 火力集中在**把爬取接入 agent 会话**与**扩展检索品类**。① **Agent exchange**：10-06 一次性为 Elixir/PHP/Rust/Go/Ruby/Java SDK 增补 agent exchange、`thread_id`、`mode` 选项（#4990/#4989/#4988/#4987/#4985/#4984），并 `fix(python-sdk)` 暴露 `get_agent_thread`（#4983），JS bump 4.44.0、Python 4.49.0。② **Alexandria 反馈闭环**：10-06 给反馈加 20 分钟窗口（#4986）并按反馈退回 1 credit（#4980），把用户反馈直接接入检索质量与计费。③ **gov 检索索引**：10-06 新增 `search` 接受 `gov` 品类（8cc9068）、把端点迁到 `/search/gov`（2763b03）、给 SDK 加 index search 方法（564ac3f）。④ 运维/正确性：10-07 记录 robots.txt 拒绝（#4900）、无页面成功时正确回报 `completedAt`（#4899）、可中止的 `crawl()`（#4898/#4897）；10-07 在 TypeSafe span 上记录 token usage 与 team（#5004）；Exchange 抓取回传 `metadata.provider`（#5000）。⑤ 10-06 浏览器会话广告拦截可配置（#4977）。
- **关键数据**：stars 189494 / forks 10045 / pushed_at 2026-10-07（hot-scan 快照）；JS SDK 4.44.0、Python SDK 4.49.0（10-06 commits）。
- **原文链接**：https://github.com/firecrawl/firecrawl/commit/1bf1215（agent thread_id/mode/exchange 系列起点）
- **影响判断**：agent exchange + threadId 意味着 Firecrawl 正把「一次性抓取 API」升级为「有会话记忆的抓取 agent」，抓取结果可挂到 agent 长期线程，直接与记忆层竞争「外部知识入口」。新增 gov 垂直索引与反馈计费闭环，显示其在检索品类与商业化（credit）上双向扩张。对 OpenClaw 的启发：外部知识摄取与会话记忆正在合流，摄入层可能被记忆层或 agent runtime 收编。

#### Crawl4AI（LLM-friendly crawler / scraper）
- **本周动态**：窗口内无新 tag release（最新 `v0.9.4` @ 2026-09-23，背景），但 **2026-10-05 在 main 分支完成一次「cloud launch」软启动**：commit `8afd0a6`「The cloud launch on main: the docs banner, the docs home, the daily notice, with the soft-launch words」；`4f105ff`/`df442c9` 在 README 与 launch banner 写入「**free credit to start, no amount and no end date**」（给免费额度、不公布金额与截止日）；`65f0a28` README 价格行同口径；`fb408df` 将 cloud-launch 分支并入 main。也就是说，这个高热开源爬虫项目开始转向**托管云服务 + 免费额度获客**的商业模式。
- **关键数据**：stars 84918 / forks 8802 / pushed_at 2026-10-05（hot-scan 快照）；cloud launch commits 均为 2026-10-05。
- **原文链接**：https://github.com/unclecode/crawl4ai/commit/8afd0a6
- **影响判断**：Crawl4AI 从纯开源库切入托管云，是「开源记忆/摄取层被云托管收编」的又一例证，与 Firecrawl 的「摄取层商品化」合并指向同一趋势：外部知识获取正变成带免费额度的托管服务。未公布额度与截止日的软启动措辞，说明其定价策略仍在试探。对自建方案者，意味着未来可能面临「自托管 vs 云托管」的成本对比。

#### 强观察池（模块 6，本窗口）
- **LightRAG**：窗口内 commits（since 09-30）返回**空集**；最新 release `v1.5.7` @ 2026-09-02（背景，非本周）。**本期无窗口内公开动态。**
- **Microsoft GraphRAG**：窗口内 commits 返回**空集**；最新 release `v3.2.0` @ 2026-09-24（背景，非本周）。**本期无窗口内公开动态。**
- **LlamaIndex**：最新 release `v0.14.25` @ 2026-09-21（背景，非本周）；本次未逐一深查其 knowledge/memory 组件的窗口内增量，列为观察。
- **LangMem / LangGraph Store**：归线 A（LangGraph/LangSmith 谱系）主责，本线不重复；本节仅登记存在性。
- **Onyx / Haystack / Jina Reader / Unstructured**：本次未逐一直查，列为观察，不写动态。
- **Chroma / Qdrant / Milvus / Weaviate 的 agent memory 产品化**：本次未逐一直查，列为观察；目的是避免把本模块稀释成泛向量数据库周报。
- **`rohitg00/agentmemory`（热度观察，未达基线深写标准）**：gh api 直查——created_at 2026-02-25、**stars 29217 / forks 2556 / pushed_at 2026-10-06**；定位「#1 persistent memory for AI coding agents」，支持 hooks/MCP/REST，Claude Code 原生插件 + 12 hooks。星数已超 29k、窗口内有 push，但非本期固定/基线对象，**仅列热度观察，不深写**，建议下期纳入基线并做跨期星速对比。
- 说明：观察池整体在本窗口**普遍静默**（LightRAG/GraphRAG 均无窗口内 commit），不构成「该层无进展」的结论，仅表示本次未取得窗口内公开动态。

### 模块 6 洞察
- **Context/Memory/Knowledge 层本周的关键词是「工程化收口 + 商业模式上移」**：OpenViking、Cognee 用检索/时序/权限加固把开源 Context DB 推向可生产化，supermemory、Crawl4AI 用 API 大版本与云托管把「库」变成「服务」，记忆层正从碎片化开源组件走向「开源引擎 + 云托管」双轨；企业治理（ACL/OIDC/反自我复制）成为准入门槛，定价权有向托管服务上移的初信号。

## 八、模块 7 — Observability / Eval / Guardrails 可观测治理层

### 本周模块结论
- **商用开源平台在本周密集发版**：Langfuse 连发 v4.52.0/v4.53.0/v4.54.0（10-06~10-07），Arize Phoenix 发 v20.17.0/v20.18.0/v20.19.0（09-30~10-01），Braintrust 发 3.36.0/3.37.0/3.37.1（10-01~10-07）——评测/追踪平台进入「周级迭代」的竞争节奏。
- **评测能力向「决策模型（decision models）」与批量写入收敛**：Langfuse 支持 OpenAI decision models（#18389）并让 `POST /scores` 支持批量（#18408）；Phoenix 引入 **DECISION span kind** 并配套 OpenAI Decisions API 文档——平台开始为「agent 的决策过程」建一等公民观测对象。
- **治理（RBAC/权限）上移**：Langfuse 把 API-key 授权改由 SystemRoleAssignments 解析（#17952），并给 audit log 写入加 entitlement 门控；说明可观测平台正补企业级权限与审计。
- **两家静默/受限**：Helicone 与 AgentOps 本周均未取得窗口内 commit（见下），本层覆盖存在获取受限。

### 固定对象状态表（模块 7）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 有动态（SDK v0.14.3/v0.14.4，10-01~10-02） | gh releases（langsmith-sdk） | 是 |
| Langfuse | 有动态（v4.52.0~v4.54.0，10-06~10-07） | gh releases/commits | 是 |
| Helicone | 本周无窗口内动态（commits 空） | gh commits/releases | 是（限述） |
| AgentOps | 本周无窗口内动态（commits 空，repo 自 06-25 无 push） | gh repo/commits | 是（限述） |
| Braintrust | 有动态（3.36.0~3.37.1，10-01~10-07） | gh releases | 是 |
| Arize Phoenix | 有动态（v20.17.0~v20.19.0 + DECISION span） | gh releases/commits | 是 |
| Coze Loop | 本周无窗口内动态（commits 空，最新 release v1.5.1 @ 01-20） | gh repo/commits | 是（限述） |
| OpenTelemetry for Agents | 背景/标准迁移中（无窗口内一手动态） | serper | 否（背景） |
| AWS/Google/Azure observability/eval/guardrails | 本窗口内未命中一手发布 | serper / 官方 release notes | 是（限述） |

> 覆盖：模块 7 固定对象 9/9 已扫描；其中 OTel 与云厂本周仅得背景，如实标注。

### 深度笔记（模块 7）

#### LangSmith（LangChain 谱系）
- **本周动态**：开源 SDK 仓 `langchain-ai/langsmith-sdk` 窗口内发 **v0.14.3（10-01）、v0.14.4（10-02）**，JS 0.10.7/0.10.8 同步。窗口内改动偏「接入正确性与协议对齐」：`fix(py,js)` 修正完整 OTLP traces endpoint 解析（#3645）、`feat` 把 agent addressing 改为 typed address object（#3635）、`fix(py)` 将 OTel 的 prompt/completion 导出为 JSON 字符串（#3636）、`fix(js)` 在返回的 ReadableStream 出错时结束被追踪 run（#3633）；另有 CI freeze guard（#3668）说明部分目录已拆到独立仓库。LangSmith **平台本体闭源**，故本周只有 SDK/接入层证据。
- **关键数据**：release v0.14.4 published 2026-10-02T17:16:21Z；v0.14.3 @ 2026-10-01T23:57:26Z（gh api）。
- **原文链接**：https://github.com/langchain-ai/langsmith-sdk/releases/tag/v0.14.4
- **影响判断**：LangSmith 继续把重心放在 OTel 兼容与多语言 trace 接入一致性上，typed address 与 OTel JSON 导出是「让 tracing 数据标准化、可跨平台搬运」的动作。作为 LangChain 生态的观测入口，其 SDK 迭代为闭源平台导流；与 Langfuse 的开源路线形成「闭源托管 vs 开源自托管」对照。

#### Langfuse
- **本周动态**：3 天内连发 **v4.52.0/v4.53.0（10-06）、v4.54.0（10-07）**。v4.54.0 要点：`feat(topics)` 把 trace 按桶分类（#17664）、`feat` 新增**外部媒体存储集成**（#18320）、`feat(scores)` 让 experiment-item / prompt-event 读取走 query AST（#17553）、`feat(sessions)` session 视图改用 trace transcripts（#18063）、`feat(analytics)` 跟踪用户可见错误 toast（#18324）。commits 另见：`feat(evals)` 支持 **OpenAI decision models**（#18389）、`feat(scores)` `POST /scores` **支持批量处理**（#18408）、`feat(rbac)` API-key 授权改由 SystemRoleAssignments 解析（#17952）、`feat(skills)` 对比已保存版本与草稿（#18409）、ingestion 遇 S3 限流返回 503+Retry-After（#18398）、修「无企业许可时仍应用数据保留」（#18283）与 audit log entitlement 门控（#18285）。
- **关键数据**：stars 35495 / forks 3947 / pushed_at 2026-10-07T22:03:30Z（gh 快照 2026-10-08）。
- **原文链接**：https://github.com/langfuse/langfuse/releases/tag/v4.54.0
- **影响判断**：Langfuse 本周在「评测（decision models、批量 scores）」「治理（RBAC、audit entitlement）」「数据基础设施（外部媒体存储、S3 限流韧性）」三条线同时推进，是最活跃的开源可观测平台。decision models 支持意味着评测开始覆盖 agent 的决策选择而非仅输出打分，与 Phoenix 的 DECISION span 同向，是整个 eval 层的方法论升级信号。

#### Helicone（限述）
- **本周动态**：窗口内 `Helicone/helicone` 的 commits（since 2026-09-30）返回**空集**；releases 页最新为 `v2025.08.21`（2025-08-21）。**本次未取得窗口内公开动态**。局限：可能发版/活动渠道不在该主仓或本入口未覆盖，不能据此判定项目停滞。
- **关键数据**：—（窗口内无取得项）
- **原文链接**：https://github.com/Helicone/helicone/commits/main（查询为空）
- **影响判断**：作为 LLM observability 老牌平台，本周无窗口内证据，本期只作「静默/获取受限」记录，不写趋势判断；后续需换入口（官网/changelog）复核。

#### AgentOps（限述）
- **本周动态**：窗口内 commits 返回**空集**；releases 页最新 `0.4.21` @ 2025-08-29；repo 元数据 `pushed_at=2026-06-25`、默认分支 main、未归档、stars 5887 / forks 645。**本周无重大公开动态**，且仓库自 2026-06-25 起无 push，可能活动已迁移至其他仓库/渠道。局限：本次未定位其现役发版入口。
- **关键数据**：stars 5887 / forks 645 / pushed_at 2026-06-25（gh 快照 2026-10-08）。
- **原文链接**：https://github.com/AgentOps-AI/agentops（commits 查询为空）
- **影响判断**：静默期偏长，本期只列事实与局限，不作衰退判断；建议下期换个入口核对是否已换仓库或转闭源。

#### Braintrust
- **本周动态**：开源 SDK 仓窗口内连发 **3.36.0（10-01）、3.37.0（10-05）、3.37.1（10-07）**。最新 3.37.1 的 release note 仅一条 patch：`fix(vite)` 支持 Vite 8 依赖优化（braintrust-sdk-javascript #2582）。平台本体闭源，SDK 迭代聚焦构建工具兼容与接入稳定性，本周无方法论级变化。
- **关键数据**：release `braintrust@3.37.1` published 2026-10-07T18:17:38Z（gh api）。
- **原文链接**：https://github.com/braintrustdata/braintrust-sdk/releases/tag/braintrust@3.37.1
- **影响判断**：本周为维护型发版，信号弱；但其「周级高频 patch」印证评测平台在 SDK 兼容面上竞争密集。对 OpenClaw 的参照有限，仅作生态活跃度记录。

#### Arize Phoenix
- **本周动态**：窗口内连发 **v20.17.0/v20.18.0（09-30）、v20.19.0（10-01）**。v20.19.0 两个 feature：`datagen` 让每个被记录的应用进入独立 project（#16682）；**`tracing` 在全平台新增 DECISION span kind（#16657）**。窗口内 commits 另见：`perf(pxi)` 把数据问题路由到 analytics SQL 并减少无效轮次（#16857）；**`feat(mcp)` 新增 GraphQL schema/query/mutation 工具（#16828）**；`feat(pxi)` PXI 的 MCP code mode 可配置以跑 Harbor benchmarks（#16845）；`refactor(evals)` 把 TRAIL 度量改名 turn_count/tool_count（#16816）；`docs(tracing)` 记录 decision models 与 **OpenAI Decisions API**（#16829）；experiments 对比网格加 metric charts（#16761/#16803）。即 Phoenix 同时在「决策型 trace（DECISION span）」「用 LLM/agent（PXI）自诊断 trace」「MCP 暴露图数据」三条线推进。
- **关键数据**：stars 11744 / forks 1192 / pushed_at 2026-10-08T00:12:22Z（gh 快照 2026-10-08）；release v20.19.0 published 2026-10-01T22:59:10Z。
- **原文链接**：https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.19.0
- **影响判断**：DECISION span kind 是全行业首批把「agent 的决策」建模为可观测一等 span 的落地之一，和 Langfuse 的 OpenAI decision models 形成跨平台共振，标志 eval 从「输出对不对」转向「决策过程可解释」。Phoenix 让 PXI（其 agent）通过 MCP 读图数据自诊断，把可观测平台自身 agent 化，是治理层「用 agent 管 agent」的前哨。

#### Coze Loop（限述）
- **本周动态**：窗口内 commits 返回**空集**；releases 页最新 `v1.5.1` @ 2026-01-20。repo 元数据 `pushed_at=2026-10-05`、stars 5763 / forks 801。**本周无重大公开动态**；`pushed_at`（10-05）与 commits 空返回冲突，疑似默认分支/发版分支不一致，本次未定位其现役分支。局限：本入口未能证明窗口内有实质 commit。
- **关键数据**：stars 5763 / forks 801 / pushed_at 2026-10-05（gh 快照 2026-10-08）。
- **原文链接**：https://github.com/coze-dev/coze-loop（commits 查询为空）
- **影响判断**：Coze Loop 是火山 Coze 谱系的开源 agent 优化/评测平台（与 OpenViking 同属字节系）。本周静默，本期不作趋势判断；因与火山生态强相关，建议下期用官网/changelog 复核其发版渠道。

#### OpenTelemetry for Agents / tracing standards（背景，非本周）
- **本周动态**：本期未取得窗口内一手动态。Serper 命中显示 OTel GenAI 语义约定**页面已迁移**至专用 GenAI semconv 仓库，官方页标注「no longer maintained」；据 greptime 等文（2026-05）与 decagon（2026-09）转述，GenAI/MCP 语义约定截至 2026 年 5 月仍处 **Development** 状态。（背景：OTel 的 `gen_ai.*` 命名空间已成 LLM/agent 遥测事实标准，LangSmith/Langfuse 等均在做 OTel 对齐。）**上述均为窗口外/标准背景，不作为本周动态。**
- **关键数据**：—（无窗口内数据）
- **原文链接**：https://opentelemetry.io/docs/specs/semconv/gen-ai/（页面迁移提示）
- **影响判断**：OTel 仍是观测层的「公共协议层」，决定各家 trace 可搬运性。本期无可核窗口进展，仅作背景记录；本模块「标准化」判断更多来自 LangSmith/Langfuse 对 OTel 的持续对齐行为。

#### 云厂 observability / eval / guardrails（AWS / Google / Azure）
- **本周动态**：**本期窗口（10-01~10-07）内未命中一手发布。** 检索命中均为窗口外（背景，非本周）：AWS **Amazon CloudWatch Omni**（AI-first、面向 agent 的可观测/评测/实验方案）发布于 2026-09-22/23；**Bedrock AgentCore Evaluations** GA 于 2026-03-31；**Microsoft Foundry** tracing + evaluations GA 于 2026 Build（6 月，hosted agents 临近）；Google Vertex AI GenAI evaluation service 相关文章为 2025 年。局限：本次未逐家直查官网 release notes，属「未查询到窗口内信号」而非「不存在」。
- **关键数据**：—（窗口内无取得项）
- **原文链接**：https://aws.amazon.com/about-aws/whats-new/2026/09/amazon-cloudwatch-omni-ai/（背景，09 月）
- **影响判断**：云厂把可观测/评测直接内置进 agent 平台（CloudWatch Omni、AgentCore Evaluations、Foundry Observability）是「Observability 被云厂收编/商品化」的明确信号，迫使独立平台（Langfuse/Arize 等）差异化到开源自托管与跨云中立。此项虽为背景，但构成本模块价值链判断的关键语境。

### 模块 7 洞察
- **可观测治理层正从「追踪工具」升级为「决策级评测 + 企业治理平台」**：Langfuse/Phoenix 本周把 decision models、DECISION span 引为一等对象，评测对象从输出转向决策过程；同时 RBAC/audit entitlement/批量 scores 等治理与吞吐能力密集补齐。竞争格局呈「开源可自托管（Langfuse/Phoenix 高频迭代）vs 闭源托管 SDK（LangSmith/Braintrust）」二分，而云厂（CloudWatch Omni/AgentCore Evaluations/Foundry）正把基础可观测能力内嵌商品化，独立平台的护城河上移到跨云中立、决策级 eval 与开源可审计。

## 九、模块 8 — Managed Agent Platform / Enterprise Control Plane 平台与控制面

### 本周模块结论
1. **云厂矩阵本周增量集中在「边缘能力补齐」，而非新平台**：AWS AgentCore 10 月补 Gateway 私有 CA；Google 10-05~10-07 补 CodeMender 与 Nano Banana 2.1；Databricks 10 月补 Agent Bricks code-first 文档与 Genie Code CLI；均是把已有控制面磨得更可用。
2. **AWS 本周最强信号是「把 OpenAI Agents API 变 AWS-native」**：10-05 Roundup 重申 Bedrock Managed Agents powered by OpenAI（基于定制版 OpenAI Agents API），执行环境可选自托管或 AgentCore Runtime——模型厂 Harness 被云厂收编进自家身份/权限/治理体系。
3. **中国云厂本周窗口内无强一手发布**：阿里云百炼、火山方舟、腾讯云 ADP 均为模型上下架/订阅套餐/认证类动作（多为窗口外或背景），平台控制面本体无窗口内范式变更。
4. **OpenClaw 参照意义**：AgentCore 的 Identity Consent Portal、lifecycle hooks、interactive shells 是 OpenClaw Gateway/tool runtime/sessions 最直接的对标面；云厂把「身份同意 + 生命周期钩子 + 交互式 shell」做成平台原语，OpenClaw 的补课点恰在身份/授权与可观测治理。

### 固定对象状态表（模块 8）
| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 有动态（2026-10 Gateway 私有 CA） | docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html | 是 |
| Google Vertex AI / Gemini Enterprise Agent Platform | 有动态（10-05~10-07 CodeMender / Nano Banana 2.1） | docs.cloud.google.com/.../release-notes | 是 |
| Microsoft Foundry / Copilot Studio / M365 Agent SDK | 本周未取得窗口内发布（背景：Routines GA 09-24、Entra Agent ID 07） | devblogs.microsoft.com/foundry | 否（背景） |
| 阿里云百炼 / Model Studio / PAI | 本周无平台级窗口动态（背景：知识库商业化、Agent 2.0） | help.aliyun.com/zh/model-studio/application-release-notes | 否（背景） |
| 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking | 本周未取得窗口内平台发布（背景：ArkClaw SaaS 版 OpenClaw 2026-03） | volcengine.com 文档 | 否（背景） |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 本周未取得窗口内发布（背景：ADP 4.0 于 2026-06-05） | cloud.tencent.com/product/adp | 否（背景） |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 有动态（2026-10 Agent Bricks code-first 文档；Genie Code CLI 10-06） | docs.databricks.com/.../2026/october | 是 |

> 平台覆盖：7/7（AWS/Google/Microsoft/阿里云/火山/腾讯云/Databricks）；深写 3（AWS/Google/Databricks）。

### 深度笔记（模块 8）

#### AWS Bedrock AgentCore
- **本周动态**：**2026-10（窗口内）** AgentCore 发布 **Gateway：目标端私有 CA 支持**——Gateway 现支持由**私有 CA 签发的 TLS 证书**用于 MCP server、OpenAPI、HTTP proxy（passthrough）目标；默认 Gateway 只信任公共 CA 签发的证书，现可注册私有 CA 证书（PEM，存于 Amazon S3 或 Secrets Manager）作为出站 TLS 信任锚，配合 Amazon VPC Lattice 私有端点直连，无需在目标前置 ALB。近两周背景（2026-09，非本周）：Harness 支持 **WebSocket 交互式 shell**（同一隔离 microVM 会话内保持环境变量/工作目录/历史/进程，可重连回放至多 256KB、单会话最多 10 个 shell）；支持自定义 **OpenAI 兼容端点（`apiBase`）**；支持 **lifecycle hooks**（`before_invocation`/`before_tool_call`/`after_tool_call`/`after_invocation`，Lambda 同步 allow/deny，SNS/EventBridge 非阻塞通知）；Evaluations 增加 **TypeScript 框架支持**（Strands、LangGraph、OpenAI Agents、Vercel AI SDK）；**Consent Portal for AgentCore Identity**（托管门户，终端用户授权 Agent 代为访问资源）。AWS 10-05 Roundup 重申 **Amazon Bedrock Managed Agents powered by OpenAI**（基于定制版 OpenAI Agents API、AWS-native、可跑在 AgentCore Runtime；原始发布在 2026-09，属背景）。
- **关键数据**：Gateway 私有 CA 支持（2026-10）；交互式 shell 回放 256KB / 最多 10 shell（2026-09，背景）；Consent Portal 需 Gateway + JWT 入站 + `openid` scope（2026-09，背景）。来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- **原文链接**：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ；https://aws.amazon.com/blogs/aws/aws-weekly-roundup-amazon-bedrock-managed-agents-powered-by-openai-q3-service-availability-updates-kiro-workflows-and-more-october-5-2026/
- **影响判断**：AWS 在把企业网络边界（私有 CA/VPC Lattice）与身份同意（Consent Portal）做成 Agent 平台原语——这正是「企业控制面」的护城河，OpenClaw 若面向企业自托管，需对标私有 CA/私有端点与用户授权门户。将 OpenAI Agents API 收编为 AWS-native，等于在 Harness 层对模型厂进行「反向整合」，议价权向掌握身份与治理的云厂倾斜。

#### Google Vertex AI / Gemini Enterprise Agent Platform
- **本周动态**：Vertex AI 已于 2026-04 rebrand 为 **Gemini Enterprise Agent Platform**（背景）。窗口内（2026-10-05~10-07）release notes 条目：**CodeMender v0.12.0（10-05）/v0.13.0（10-07）**——安全 Agent CLI（`cm`），新增隐藏文件扫描 `--include-hidden`、文件大小上限 500KB→2MiB、并发扫描状态可靠性、非可重试错误立即失败、Ctrl+C 中断时干净保存会话状态；**Gemini Nano Banana 2.1 GA（10-06）**——高速多模态图像生成/编辑，1K/2K/4K 输出。近两周背景（2026-09，非本周）：**09-30 Agent Gateway 集成 Cloud Trace（Preview）**，提供 Agent 请求跨 gateway/服务/工具/Agent/MCP server 的端到端可观测；**09-30 App Topology API GA**（含自定义查询构建器、单 Agent topology）；**09-29 语义治理策略自定义拒绝消息**（`agentResponseCustomization.denialMessage`，最长 1000 字符）；**09-24 Gemini 3.8 Live GA、Meta Muse Spark 1.3 Preview**（agentic 推理 + MCP 工具调用 + 1M 上下文）。
- **关键数据**：CodeMender v0.12/v0.13（2026-10-05/10-07）；Nano Banana 2.1 GA（2026-10-06）；Agent Gateway Cloud Trace（2026-09-30，背景）。来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- **原文链接**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- **影响判断**：Google 本周控制面本体无大动作，CodeMender/Nano Banana 属「Agent 附带工具」打磨；真正的治理能力（Agent Gateway + Cloud Trace 的可观测、语义治理拒绝消息、App Topology）都在 9 月底落地——说明 Google 的企业控制面主线是「可观测 + 可治理 + 拓扑可视化」，而非 Harness 运行时。对 OpenClaw 的参照：把 Agent 拓扑与网关级 trace 作为一等公民，是当前可观测治理层的竞争高地。

#### Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK
- **本周动态**：**本周未取得窗口内（2026-10-01~10-07）公开发布**。近两周背景（非本周）：**2026-09-24 Foundry「Routines」GA**——把「监控工作、响应业务事件、跨时间持续任务」从自建 scheduler/event listener/webhook/queue/run history 抽象为托管能力；**2026-09-15 Foundry Dev Pack**；2026-08/09 Foundry 文档新增多项 Hosted Agent 预览能力（long-running agent 状态管理、崩溃恢复、human-in-the-loop 审批、steerable agent、stream with reconnect、private skill catalog、toolbox 网络隔离、BYO registry）。Copilot Studio 侧：自 **2026-07** 起为每个新 Agent 自动创建 **Microsoft Entra Agent ID**；自 **2026-07-01** 起 Copilot Studio 与 Foundry Agent 的 AI 安全能力需 Microsoft Agent 365。
- **关键数据**：Routines GA @ 2026-09-24；Entra Agent ID 自动创建 @ 2026-07（均属背景）。来源：https://devblogs.microsoft.com/foundry/ ；https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry
- **原文链接**：https://devblogs.microsoft.com/foundry/ ；https://learn.microsoft.com/en-us/microsoft-copilot-studio/whats-new
- **影响判断**：微软的路线是把「长期运行 + 事件驱动 + 人审 + 恢复」做进 Foundry 平台，并以 Entra Agent ID 把身份收进企业管理体系。本周静默但方向明确：企业控制面的胜负手在身份与治理（Entra / Agent 365），Harness 只是承载。对 OpenClaw，这是「自托管 + 自有身份」与「云厂托管身份」的路线分野。

#### 阿里云百炼 / Model Studio / PAI
- **本周动态**：**本周（2026-10-01~10-07）未取得平台控制面的一手发布**。窗口内可见的仅为**模型生命周期动作**：百炼宣布将于 **2026-10-10** 对部分主线模型、快照模型与老旧模型下线（公告分别发布于 2026-04/06/07，属背景，执行日在窗口后）。近两周背景（非本周，来源见下）：应用侧最近一批功能更新为 **2026-09-24 高代码应用**（基于 Python 项目结构部署 AI 后端，内置自动化运维/可观测/日志）、**2026-09-23 Dify 工作流一键导入、文件问答升级（全文引用/切片检索/自定义处理）、回复升级（自动切换更优模型）、知识库创建流程与调试面板优化**；**长期记忆&用户画像 API**（2026-01-31）、**Agent 2.0（知识库与 MCP 统一为工具、自主规划调用）**（2025-12-26）。模型侧：官网页显示 Wan3.0 视频生成模型发布并有 10 月限时优惠（未取得明确发布日，列背景/待核）。
- **关键数据**：模型下线执行日 2026-10-10（公告早于窗口）；高代码应用 2026-09-24；Dify 导入/文件问答 2026-09-23。来源：https://help.aliyun.com/zh/model-studio/application-release-notes
- **原文链接**：https://help.aliyun.com/zh/model-studio/application-release-notes
- **影响判断**：百炼本周无平台级新增，控制面能力（长期记忆、MCP、工作流、高代码应用）均已在 9 月及更早落地；其竞争动作更偏模型供给与生态（Dify 导入、Responses API 兼容）。对 OpenClaw 的参照是：百炼把「知识库/MCP 统一为工具 + 自主规划」作为 Agent 2.0 范式，与 OpenClaw 的 skills/tool runtime 同构，但绑定阿里云生态。

#### 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking
- **本周动态**：**本周未取得窗口内（2026-10-01~10-07）平台控制面发布**。近两周背景（非本周）：**方舟 Agent Plan** 文档更新于 **2026-09-29**——面向个人用户的订阅式大模型套餐，官方称「新增支持全模态模型及**专属 Harness**，采用精细化积分计费」；**ArkClaw**（云上 SaaS 版 OpenClaw，2026-03-09 上线，属较远背景）；Coze Studio / Coze Loop 开源为 2025-07 旧闻（背景）。OpenViking（Context Database）属模块 6，本周热扫描显示 v0.4.23 @ 2026-10-02（见模块 6/热度扫描，不在本线深写）。
- **关键数据**：Agent Plan 文档 @ 2026-09-29（背景）；ArkClaw @ 2026-03-09（背景）。来源：https://www.volcengine.com/docs/ark/agent-plan-personal-plan-overview
- **原文链接**：https://www.volcengine.com/product/ark ；https://www.volcengine.com/docs/ark/agent-plan-personal-plan-overview
- **影响判断**：火山本周静默；最值得注意的历史信号是「Agent Plan 提供**专属 Harness**」——即云厂把 Harness 作为套餐卖点，与 AWS「Managed Agents 可选 AgentCore Runtime」是同一逻辑：Harness 正在被包装成云服务 SKU。ArkClaw 则说明云厂已在做「OpenClaw 类 Agent OS 的 SaaS 化」参照样本。

#### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit
- **本周动态**：**平台控制面本周未取得窗口内发布**；窗口内可见的是**商业活动**：腾讯云 ADP「FDE（前沿部署工程师）认证」活动期 **2026-09-11 ~ 10-31**（覆盖本周），首推行业 FDE 认证，考察场景理解/交付实施/安全合规三大能力，依托 ADP 的知识库、工作流、Agent 及安全治理；新客购套餐赠 100 元 PU（约 5000 万 token）；官网列出华润信托、伊利（点击率 +15.7%、订单 +26%、需求识别准确率 93%、转化率 +39%）、德邦快递、尚美数智等客户案例（均为官方披露口径，未独立核实）。背景（非本周）：**ADP 4.0 于 2026-06-05 发布**，定位「企业级 AgentOps 平台」。
- **关键数据**：FDE 认证活动期 2026-09-11~10-31；客户案例数据为腾讯云官方披露（2026-10-08 取得）。来源：https://cloud.tencent.com/act/pro/openclaw-in-adp ；https://cloud.tencent.com/product/adp
- **原文链接**：https://cloud.tencent.com/act/pro/openclaw-in-adp
- **影响判断**：腾讯云本周的信号在「交付能力标准化」（FDE 认证）而非技术控制面——这反映企业 Agent 落地的瓶颈已从「能不能搭」转向「能不能交付与运维（AgentOps）」。对 OpenClaw：ADP 把交付/运维/安全合规打包成认证与平台能力，OpenClaw 若面向企业可通过「可复制交付方法论 + 治理能力」对标。

#### Databricks Mosaic AI Agent Framework / Agent Bricks
- **本周动态**：Databricks 平台 **2026-10 发布说明**窗口内条目：**Agent Bricks 面向「代码优先 Agent 开发」的文档**（10 月）；**Genie Code CLI（Beta，2026-10-06）**——终端内编码 Agent，能与本地文件协作、用 Databricks CLI 发现数据并构建/部署 pipeline、model、app；**DeepSeek V4.1 Flash 支持 priority pay-per-token 与预留吞吐（2026-10-07）**；**Metric view window measures GA（2026-10-06）**。近两周背景（2026-09）：Agent Bricks **Supervisor Agent 支持自定义 MCP server 与 Databricks Apps 上的自定义 Agent**；**MLflow trace storage 在 Unity Catalog**。
- **关键数据**：Genie Code CLI Beta @ 2026-10-06；DeepSeek V4.1 Flash priority/预留 @ 2026-10-07。来源：https://docs.databricks.com/aws/en/release-notes/product/2026/october
- **原文链接**：https://docs.databricks.com/aws/en/release-notes/product/2026/october
- **影响判断**：Databricks 的 Agent 控制面围绕「治理数据（Unity Catalog）+ Agent Runtime + MLflow 追踪评测 + MCP」构建，差异化在治理而非 Harness 本身；本周以文档化和终端编码 Agent 补开发体验，Signal 强度中等。对 OpenClaw：Databricks 证明「治理与可观测」是可独立变现的平台层，OpenClaw 若走企业路线需强化这层。

### 模块 8 洞察
- 模块 8 本周呈现「平台能力已就位、增量在磨边角」的格局：**Runtime/Session 与 Gateway/Tools 已被各家做齐，Identity/Auth 与 Observability/Eval 成为差异化高地**；中国三家本周无窗口内平台级动作，AWS/Google/Databricks 以边缘能力与治理补齐为主，Harness 正在被云厂当作 SKU 收编（AWS Managed Agents、火山 Agent Plan 专属 Harness）。

> 跨模块提示：模块 8 的「Gateway 私有 CA」与模块 4 的同一事件共享证据（同一 AWS release notes 条目）；本稿保留其双重归属：在模块 4 作为「工具网关信任链」证据，在模块 8 作为「企业控制面网络边界」证据。

## 十、云厂能力矩阵（第 16 期权证快照）

> 数据为 2026-10-08 取证快照；无证据单元写「未取得」，不编造。矩阵 7 行齐全：AWS / Google / Microsoft / 阿里云 / 火山·字节 / 腾讯云 / Databricks。列为：Runtime/Session、Memory/Context、Gateway/Tools、Identity/Auth、Sandbox/Browser/Code、Observability/Eval、本周强信号。

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Runtime（会话 + 可配置存储）；Harness 交互式 shell（2026-09，背景）；Instances 持久会话最长 14 天（2026-08，背景） | AgentCore Memory（含 episodic memory，2025-12 re:Invent，背景） | AgentCore Gateway（MCP/OpenAPI/HTTP proxy 目标；**2026-10 私有 CA 支持**） | AgentCore Identity + Consent Portal（2026-09，背景） | AgentCore Browser / Code Interpreter（背景，本期未取证窗口细节；ActiveSessionCount 指标 2026-08） | AgentCore Evaluations（含 TypeScript 框架，2026-09 背景） | **Gateway 私有 CA（2026-10）**；Bedrock Managed Agents powered by OpenAI（10-05 重申，发布在 09） |
| Google | Gemini Enterprise Agent Platform（原 Vertex AI，2026-04 rebrand）；Agent Engine；sandbox pause/秒级恢复（2026-09-09，背景） | 未取得（本期未取证 Memory Bank 具体条目） | Agent Gateway（**2026-09-30 集成 Cloud Trace**，背景）+ MCP server 支持 | 语义治理策略 / 自定义拒绝消息（2026-09-29，背景）；Agent Identity API（06 月，背景） | CodeMender 安全 Agent CLI（**2026-10-05/10-07**，v0.12/v0.13）；Computer Use/Shell sandbox GA（09-09，背景） | Agent Gateway + Cloud Trace（09-30）+ App Topology API GA（09-30） | CodeMender v0.12/v0.13（10-05/10-07）、Nano Banana 2.1 GA（10-06） |
| Microsoft | Foundry Hosted Agents / 长时运行 Agent（preview，2026-08/09 文档，背景）；Routines GA（09-24，背景） | Foundry Agent Service memory（程序性/用户/会话，2026 背景） | Foundry Toolboxes（背景）；MCP 兼容端点 | Entra Agent ID（每新 Agent 自动创建，2026-07 背景）；Agent 365 | Playwright Workspaces（概览 2026-09-15，背景）/ Code Interpreter（8 月文档，背景） | Foundry 可观测与评测（Build 2026，背景，未本期取证窗口细节） | 无（本周未取得窗口动态） |
| 阿里云 | 百炼智能体/工作流应用（异步运行模式，2026-01 背景） | 长期记忆 & 用户画像 API（2026-01-31 背景） | MCP 外部调用（2025-08 背景） | 未取得 | 高代码应用（Python 后端部署，2026-09-24 背景） | 新版应用评测（2026-02 背景） | 无（模型下线执行日 2026-10-10，公告早于窗口） |

| 火山 / 字节 | Agent Plan 专属 Harness；ArkClaw（SaaS 版 OpenClaw，2026-03 背景） | 未取得（本模块未取证；OpenViking 见模块 6） | 未取得 | 未取得 | 未取得 | Coze Loop（开源，2025-07 背景） | 无（Agent Plan 文档 09-29 属背景） |
| 腾讯云 | ADP 智能体运行环境（断点续跑/闲置暂停/密钥隔离托管，官网口径） | 变量与记忆（长期记忆 SYS.Memory，2025-08 背景） | 未取得（本期未取证 MCP gateway 细节） | 平台端用户权限 / 企业空间（2025-08 背景） | CloudBase AI Toolkit（未本期取证） | 全链路 Trace（官网口径）+ 应用评测（2025-08 背景） | FDE 认证活动期（2026-09-11~10-31，覆盖本周） |
| Databricks | Agent Bricks Agent Runtime（code-first 文档，2026-10） | 未取得（本期未取证 Agent memory 细节） | Unity Gateway + 自定义 MCP server（2026-09 背景） | Unity Catalog 治理 + OAuth（Google Workspace connector 用 OAuth，10-09 窗口外） | Genie Code CLI（**2026-10-06**，Beta） | MLflow trace storage in Unity Catalog（2026-09 背景）+ built-in eval | Agent Bricks code-first 文档 + Genie Code CLI（10-06） |

> 矩阵说明：表中「（背景，非本周）」单元格为维持平台画像完整性而保留的存量能力，**不作为本周动态**；标「未取得」的单元格表示本期取证未取到对应证据（未查询到 ≠ 不存在）。火山·字节行的 Memory/Context 列写「未取得」指**本模块（Managed Platform）口径下未取证**；其旗下 OpenViking 记忆引擎本周动态见模块 6（v0.4.23，10-02），两者不矛盾。

## 十一、TOP 5 候选（按对 Agent Harness 基础设施格局的信号价值排序）

> 排序标准：① 是否改变 Harness/控制层的竞争结构；② 一手证据强度；③ 是否具跨模块外溢影响。本期满足门槛的候选≥ 5 条，以下列前 5，另附候补。

### TOP 1 — Modal Runtime 大会：VM Sandboxes + Sandbox Sidecars + Sticky Sessions（2026-10-01）
- **依据**：一次发布把 agent 执行环境的三个关键维度同时产品化：① **真机保真**（VM Sandboxes：完整 Linux，可跑 Docker/本地数据库/图形环境）；② **信任边界**（Sidecars：agent 无法直接访问的凭据/代理/harness 容器）；③ **有状态长会话**（Sticky Sessions：会话粘滞到同一容器）。三者合起来直接对标 AWS AgentCore Runtime 的存量能力，且是**托管专业厂商领先云厂**的罕见窗口。
- **来源**：https://modal.com/blog/runtime-product-update-sandbox-endpoints （2026-10-01）；https://modal.com/changelog（Sidecars Beta）。

### TOP 2 — OpenClaw v2026.10.1-beta.1：session/state 异步持久化与跨 workspace 迁移（2026-10-05）
- **依据**：本周**最可核验、最直接**的 runtime 生命周期演进信号：把 session/state 持久化从同步写全面转向异步 await（多条插件 API 自 10-01 起弃用告警），并处理跨 registry usage、remote workspace worker 附件、embedding 缓存有界批次迁移、canonical state handles 等。与 Microsoft Foundry 8 月「长时 agent 韧性/恢复/转向」文档同题，是「长时运行 + 可恢复」成为跨平台共识的证据。
- **来源**：https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases/2026.9.8 。

### TOP 3 — Anthropic SDK 内置 browser/computer-use 工具集 + Managed Agents 网络策略收紧（2026-10-07）
- **依据**：模型厂以 SDK 定义执行工具协议（子类化成员工具 + 审批回调 + URL 策略），并明确不含浏览器/驱动实现、转而列 Browserbase/Daytona/E2B 为集成伙伴；同时 `allowed_hosts` 收紧 `web_fetch`/`web_search`。这是「控制层被模型厂收编」的机制性证据，重塑了 SDK 与沙箱厂商的分工。
- **来源**：https://platform.claude.com/docs/en/agents-and-tools/tool-use/browser-use-sdk ；https://platform.claude.com/docs/en/release-notes/overview 。

### TOP 4 — Okta（10-02）与 WorkOS（约 10-02）：MCP 网关身份层被 IAM 厂商抢占
- **依据**：Okta 把 XAA/ID-JAG 的两步委托拍成可落地的两条拓扑（Agent 内自查 vs AgentCore Gateway + Lambda 拦截器集中换票），并点破 OIDC token 不得直接转发（audience 边界）；WorkOS 把 Cloudflare/Okta/Auth0/Microsoft 的 MCP gateway 状态整理为「身份/治理品类」。两者共指：**工具网关的身份与审计正成为事实标准入口**，而云厂自家 Identity 本周静默。
- **来源**：https://www.okta.com/blog/ai/okta-amazon-bedrock-agentcore-security/ ；https://workos.com/blog/mcp-gateways-compared 。

### TOP 5 — Composio Instant：Agent 钱包与按用量结算（2026-10-07）
- **依据**：工具层首次把「**Agent 自主付费**」产品化（无账号/无 key/无订阅直接调用 100+ 付费工具，官方称已充值超 $1M、新账号赠 $2 / Pro $29），把工具访问从「接得通」推到「按用量结算」。这可能改变工具供应商的分发与定价，也给工具授权层提出「预算/计费/审计钩子」的新要求。
- **来源**：https://composio.dev/blog/composio-instant （2026-10-07，含 B 级自披露数据）。

### 候补（未入前五，但具信号价值）
- **A2A CLI 发布（2026-10-01）**：协议入口下沉到「任何能跑命令的东西」，扩大 A2A 网络效应（https://a2a-protocol.org/latest/blog/2026/10/01/introducing-a2a-cli/ ）。
- **OpenViking v0.4.23（10-02）+ Cognee v1.6.3（10-07）**：记忆层「召回重写 + 时序边界正确性 + ACL/OIDC 治理」同步下沉到开源 Context DB。
- **Langfuse decision models + Arize Phoenix DECISION span（10-01~10-07）**：评测对象从「输出」转向「决策过程」的跨平台共振。
- **Google ADK v2.11.0（10-01）**：开源控制层一次性补齐优雅取消、工具人工确认、内置 SQLite memory 与 MCP SDK 2.x，同质化加速。

## 十二、OpenClaw 战略参照（对照本周信号）

1. **【领先点】开放控制层 + 本地/自托管 + 多框架（Codex/MCP/插件）**。本周云厂把 Harness 收编为 SKU（AWS Managed Agents powered by OpenAI、火山 Agent Plan 专属 Harness），身份与治理在地下。OpenClaw 的自托管与开放编排是差异化护城河（见模块 1、模块 8）。
2. **【领先点】session/state 持久化的异步化与迁移语义已主动推进**：本周以弃用告警驱动插件生态转向异步持久化（模块 1/2），与 Microsoft Foundry 8 月「长时 agent 韧性/恢复/转向」文档体系同题，说明 OpenClaw 在最核心的「长时运行不掉线」命题上与一线平台同代。
3. **【补课点】浏览器/计算机执行工具与网络策略**：Anthropic SDK 已以 toolset 定义 browser/computer use 并施加 `allowed_hosts`；OpenClaw 本周无同类发布。建议：对齐 SDK toolset 语义并接入 Browserbase/E2B/Daytona 伙伴，而非自研浏览器栈（模块 1、模块 3）。
4. **【补课点】身份/授权与工具预算**：Okta 的 Pattern B（网关 + 拦截器集中换票）与 Composio Instant（Agent 钱包）提示工具授权层需支持「以谁的身份、花多少、能否审计」。建议 OpenClaw 的 tool gateway/auth 引入可插拔的 token 交换钩子与预算/计费/审计接口（模块 4、5）。
5. **【可借鉴】旁车信任边界**：Modal Sidecars 把凭据/代理/harness 逻辑放到 agent 无法直接访问的容器。OpenClaw 的凭据/代理/工具运行时亦可采用同构分区（模块 3）。
6. **【可借鉴】网关 + 注册表双层结构**：开源 MCP Gateway/Registry 的 OAuth、动态工具发现、出口安全与工具级审计已标准化（模块 4）；OpenClaw 的 plugin/tool runtime 可对标。
7. **【可借鉴】可观测基准线与决策级评测**：Browserbase 内置零插桩 session replay + 结构化日志是浏览器 agent 的现实基准线；Langfuse/Phoenix 把「决策过程」建模为可观测对象。OpenClaw 可把 Agent 拓扑与网关级 trace、决策级 span 作为可观测治理的一等公民（模块 3、7）。
8. **【风险参照】云厂身份/治理护城河**：AWS Consent Portal/私有 CA、Entra Agent ID、Google IAP/Access 均已成体系；若 OpenClaw 走企业路线，身份与可观测治理是必补项（模块 5、8）。

## 十三、覆盖审计（第 16 期）

### 13.1 模块覆盖：8/8
| 模块 | 负责人 | 分片 | 固定对象覆盖 | 本稿状态 |
|---|---|---|---|---|
| 1 Harness/Agent OS 控制层 | A | part-01..04 | 7 固定 + 3 动态池 | 已汇总 |
| 2 Runtime/Session/State | B | part-01 | 10（含背景） | 已汇总 |
| 3 Sandbox/Computer Use/Browser | B | part-02 | 9 | 已汇总 |
| 4 Tool Gateway/Protocol/Integration | C | part-01..02 | 10 固定 + #804 观察 | 已汇总 |
| 5 Identity/Auth/Permission | C | part-03..04 | 7 固定 + 7 动态池 | 已汇总 |
| 6 Context/Memory/Knowledge | D | part-01..05 | 8/8 固定 + 强观察池 | 已汇总 |
| 7 Observability/Eval/Guardrails | D | part-06..07 | 9/9 已扫描 | 已汇总 |
| 8 Managed Agent Platform | A | part-05..08 | 7 平台 | 已汇总 |

### 13.2 平台矩阵覆盖：7/7
AWS、Google、Microsoft、阿里云、火山·字节、腾讯云、Databricks 七行齐全，无空缺行；单元级缺口以「未取得」标注（见第十节）。

### 13.3 热度补漏 9 方向执行情况
| # | 方向 | provider | 结果 | 入稿处理 |
|---|---|---|---|---|
| 1 | agent memory / context DB / knowledge graph / RAG memory | serper | OpenViking、Cognee、mem0 稳居；新见 rohitg00/agentmemory | agentmemory 列热度观察（模块 6） |
| 2 | agent harness / runtime | serper | 「agent harness」成显式品类词 | 作为叙事背景，未作条目 |
| 3 | browser agent runtime / sandbox / code execution | serper | 多篇 2026 沙箱对比；Browserbase Observability | 核对结论=窗口内无独立发布（模块 3） |
| 4 | MCP gateway / agent auth / OAuth / tool permission | serper | mcp-gateway-registry；MCP 讨论 #804 | 入模块 4/5；#804 列观察 |
| 5 | agent observability / eval / guardrails | serper | GitHub topic agent-observability；2026 平台对比 | 入模块 7；聚合文未作来源 |
| 6 | MCP 协议本体 | serper | 焦点仍为 2026-07-28 规范 | 标背景（非本周） |
| 7 | Coze / 火山运行时 | serper | coze-studio 常青；Coze 开源 2025-07 旧闻 | 标背景，未入动态池 |
| 8 | agent sandbox 平台（E2B/Browserbase/Daytona/Modal） | gh api + serper | 见 GitHub 快照 | 入模块 2/3 |
| 9 | 平台/云厂动态 | gh api + serper | 本期窗口内云厂发布未在热度扫描出现强命中 | 交研究线逐平台核对（模块 8） |

> 说明：方向 7、8 与方向 1 的新项目均按规则处理（旧闻归背景、聚合文不入动态池、新项目列热度观察）；方向 5/9 的云厂一手发布需逐对象核对，已在模块 7/8 如实标注「未取得」。

### 13.4 风险导向抽查项（本题 5 项）
1. **日期归属风险**：AWS AgentCore「Gateway 私有 CA」仅标「October 2026」无具体日，存在落在 10-08 的可能。处理：按 A 级事实保留、标「日期限述/归属待明确」，不当作窗内确定条目。
2. **聚合文当一手**风险：TrueFoundry / Modal resources / Northflank / Beam / Mastra / Laminar / Braintrust 等对比与导购文、awesome-* 榜单。处理：一律不作已读来源，仅作线索。
3. **B 级自披露风险**：Composio（月 10 亿 tool calls、百万用户）、Pipedream（3,000+ API）、腾讯云客户案例（伊利数据）。处理：标注为官方自披露、未独立核实；不据以推导市场结论。
4. **静默误判风险**：Helicone/AgentOps/Coze Loop 本入口 commits 空；Coze Loop pushed_at(10-05) 与 commits 空冲突。处理：只记「本次未取得窗口内动态」，明标本入口局限，不作停滞/衰退结论。
5. **冲突/不确定保留**：OpenAI ChatGPT 周报（9/28–10/2）单条日期不可核，未作窗内一手主张；Daytona 已转闭源、公开仓停更；MCP #804 发布于 2025-07-01（非本期）。处理：均保留限定与归属，不抹平。

### 13.5 缺口与原因（未查询到 ≠ 不存在）
- **模块 1**：OpenAI Agents SDK 本体、Microsoft Agent Framework 本体、LangSmith、CrewAI AMP/Studio 本周未取得窗内独立发布；MCP 本体最近规范为 2026-07-28（背景）。
- **模块 2/3**：云厂 Agent Runtime 与浏览器/代码沙箱本周均无窗内一手发布；AWS/Azure/Google 发布说明按月聚合、无逐条日期。
- **模块 4/5**：云厂自家 Identity 本周静默；动态池 Auth0/Cloudflare/Permit.io/Descope/Clerk 无窗内已确证发布。
- **模块 6**：强观察池多数未逐一直查（Onyx/Haystack/Jina/Unstructured/向量库）；LightRAG/GraphRAG 已直查确认窗内静默；Letta 窗内完全静默。
- **模块 7**：云厂 observability/eval 仅有背景（CloudWatch Omni 09-22/23、AgentCore Evaluations 03-31、Foundry Build 2026）；Helicone/AgentOps/Coze Loop 需换入口复核；OTel for Agents 仅得标准背景。
- **模块 8**：中国三家（阿里云/火山/腾讯云）平台控制面本周无窗内一手发布；Microsoft Foundry what's-new 最新仅至 2026-08 页。
- **通用原因**：① 官方发布说明按月/周聚合、无逐条日期；② 中文云厂动态页分散/动态渲染，web_fetch 抽取失败或仅得旧页；③ 部分项目发版渠道不在主仓（Helicone/AgentOps/Coze Loop）；④ 本期未使用 tavily/exa/xAI 补齐，未登录抓取。
- **未使用的入口（后续可补）**：官网 changelog、状态页、社交渠道、跨期 GitHub 快照（用于星速对比）。

## 十四、R3 价值链位置与 R2 解决方案透镜

### 14.1 R3 — 价值链位置（本周）
价值链分段：模型与算法 → 上下文/记忆层 → 运行时/Harness → 协议与工具 → 平台与工具链 → 集成交付。
- **控制层/Harness（模块 1/2/8）**：处「运行时/Harness」段，向上被模型厂 SDK 吸收执行能力（Anthropic），向下被云厂以 Runtime+身份打包（AWS/火山），中间层价值重归「长时运行可靠性与运维体验」。
- **执行环境（模块 3）**：卡在「运行时」与「平台」之间，本周由托管专业厂商（Modal）向上吸收「有状态会话」与「凭据隔离」价值，中间层（纯沙箱）差异化空间被压缩。
- **工具/协议（模块 4）**：处「协议与工具生态」段，价值从「协议规范」转向「网关治理 + 用量结算」；A2A CLI 把非 Agent 端纳入网络。
- **身份/权限（模块 5）**：处「平台与工具链」的治理组件，IAM 厂商×MCP 网关在抢标准，与云厂自家 Identity 形成竞争。
- **记忆/上下文（模块 6）**：处「模型→上下文层→Harness」中游，向上一段买模型/嵌入/推理，向下一段卖「可检索、可治理的长期上下文」；本周价值落点在**检索精度（OpenViking 全局召回+rerank、Cognee 时序边界）与治理（ACL/OIDC/反自我复制）**，从「存得下」上移到「召回准 + 谁有权读写」。初始商品化信号：OpenViking 打通火山 Service 入口、Crawl4AI 软启动 cloud + 免费额度、supermemory v5 API 服务化——**记忆正从开源库被包装为带免费额度的托管 Context 服务**，纯开源库面临被商品化压力，护城河转向企业治理与检索质量。
- **可观测/评测（模块 7）**：横跨 Harness 与平台层，属「平台与工具链」中的治理组件；向运行时买 trace/eval 数据、向企业卖「敢上生产的可信度」。本周价值落点在**决策级评测（decision models/DECISION span）与企业治理（RBAC/audit）**；云厂（CloudWatch Omni、AgentCore Evaluations、Foundry Observability）把基础 trace/eval 内嵌商品化（背景，非本周），迫使独立平台向「跨云中立 + 开源自托管 + 决策级 eval」上移。
- **位置待明确项**：Firecrawl/Crawl4AI 的摄取层究竟独立成段还是被记忆层/runtime 吸收——本周出现「摄取 + 会话记忆合流」信号（Firecrawl agent exchange/threadId），趋势方向明确但归属未定，标「位置待明确」。

### 14.2 R2 — 解决方案透镜（怎么搭的 / 交付给谁 / 什么代价 / 踩了什么坑 / 能否复制）

#### A. Modal：真机 + 旁车（VM Sandboxes / Sidecars / Sticky Sessions）
- **怎么搭的**：serverless 平台把 VM 级 Linux 环境与会话粘滞做成原语；agent 生成代码跑主 Sandbox，凭据/代理/harness 逻辑跑同一 host 但隔离级别等同独立 sandbox 的 Sidecar，两地本地通信。
- **交付给谁**：需要完整 OS/内核的编码与评测团队（Linear/Legora/Snorkel）、需实时路由的语音等场景；集群面向大模型服务/训练（Decagon/1x/Runway）。
- **什么代价**：Sidecar 仍为 Beta（此前 public alpha）；需接受 serverless 厂商的运行时生态约束（未披露定价细节）。
- **踩了什么坑**：未披露（官方未公开迁移/踩坑细节）。
- **能否复制**：「同 host 旁车 + 隔离边界」模式可复制（自建时以进程/容器分区 + 本地 gRPC）；「真机保真」需底层虚拟化能力，自建门槛高。

#### B. 开源 MCP Gateway/Registry：网关 + 注册表
- **怎么搭的**：集中 AI 开发工具的网关，安全 OAuth、动态工具发现，对接 Keycloak/Entra；前置代理出口受 SSRF 保护、带密钥请求仅 https；依赖钉 `mcp<2.0` 兼容。
- **交付给谁**：企业平台团队（自托管、需统一工具治理）。
- **什么代价**：需运维 Keycloak/Entra 与出口代理；GitHub open_issues 132（快照）。
- **踩了什么坑**：mcp 2.x 无兼容别名重命名 `streamablehttp_client` 导致需钉版；`http://` 前置代理下 `proxy_ssl_context` 报错；otel-collector 健康检查错误。
- **能否复制**：可复制（开源可自托管）；关键在「网关统一入口 + 注册表发现 + OAuth」三件套。

#### C. Okta + AgentCore：两步委托换票
- **怎么搭的**：Pattern A（Agent 内用 Okta SDK 查 XAA）或 Pattern B（AgentCore Gateway + AWS Lambda 拦截器集中换票，密钥放 Secrets Manager 只给 Lambda）；Agent 在 Okta 建为可治理身份。
- **交付给谁**：需让 Agent 代表用户访问下游 MCP/工具的企业。
- **什么代价**：需 Okta 与 AWS 双栈；Pattern B 需维护 Gateway/Lambda/Secrets 链路（未披露成本）。
- **踩了什么坑**：直接转发用户 OIDC token 会因 audience 不匹配而失败——必须换带「用户+Agent 双重归因」的短时 scoped token。
- **能否复制**：可复制（任何 IdP + 网关拦截器架构同构）；关键是密钥落点与归因传递。

#### D. Composio Instant：Agent 钱包
- **怎么搭的**：托管 auth（1,500+ 应用）上加「按调用付费」额度，预充值池供 Agent 直接调用 100+ 付费工具，无需建账号/key/订阅。
- **交付给谁**：想让 Agent 自主调用付费 API 的开发者与小团队。
- **什么代价**：用多少付多少（新赠 $2 / Pro $29 每月）；依赖厂商托管凭据与计费。
- **踩了什么坑**：未披露（官方未公开试点细节）。
- **能否复制**：需预付款/计费治理与多 provider 结算能力，自建难度高；但「预算+审计钩子」思路可借鉴到自建工具授权层。

#### E. E2B / 浏览器与代码沙箱：生产可靠性
- **怎么搭的**：托管 code-interpreter sandbox SDK；本周修复重试语义与 watch 生命周期。
- **交付给谁**：需要跑不可信代码的 agent 应用。
- **什么代价**：按版本升级（非幂等调用需改代码）；stars 14220 小体量。
- **踩了什么坑（可复制避坑）**：**sandbox 创建/fork/snapshot 类 POST 遇 502 不得盲重试**（会重复创建）；secret 更新不得重放；JS SDK `WatchHandle.stop()` 语义需与 Python 对齐。
- **能否复制**：可靠性规则可直接照搬到任何自建沙箱编排（区分幂等/非幂等、生命周期语义一致）。

#### F. OpenClaw：自托管 Agent OS 的 runtime 演进（本稿核心参照物）
- **怎么搭的**：开放控制层 + 本地/自托管 + 多框架（Codex/MCP/插件）；session/state 持久化改异步 await，跨 workspace/迁移语义加固。
- **交付给谁**：希望自托管、多框架、可自控的团队（对比云厂托管身份）。
- **什么代价**：需跟随插件 API 弃用迁移（多条 10-01/10-02 起告警）。
- **踩了什么坑**：过期远程执行审批污染 auth profile、跨 registry usage 丢失、transcript 别名卡住活跃 turn（均为官方 release notes 披露的已修项）。
- **能否复制**：模式可复制（异步持久化 + canonical state handles + 有界批次迁移）；是「长时运行 Agent OS」的现实参考实现。

## 十五、附录

### 15.1 分片与交接清单（本母稿依据的全部输入）
- 热度扫描：`hot-scan-2026-10-08.md`（9 方向补漏 + GitHub 直查快照）
- 运行合同：`run-contract.md`（run_id、窗口、预算、目标产物、写作权分配）
- 交接：`line-A.done`、`line-B.done`、`line-C.done`、`line-D.done`（均 status: PASS）
- 分片：line-A-part-01..08（8）、line-B-part-01..02（2）、line-C-part-01..04（4）、line-D-part-01..07（7），共 21 片
- 单元标记：`units/line-{A,B,C,D}-part-*.md.done`

### 15.2 主要来源索引（可定位 URL，按线）
- **线 A**：docs.openclaw.ai/releases/2026.9.8；github.com/openclaw/openclaw/releases；github.com/langchain-ai/langgraph/releases；github.com/google/adk-python/releases 与 /blob/main/docs/guides/runners/runner/abort.md；platform.claude.com/docs/en/release-notes/overview 与 /agents-and-tools/tool-use/browser-use-sdk；developers.openai.com/api/docs/changelog；aws.amazon.com/blogs/aws/aws-weekly-roundup-…-october-5-2026/；docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html；docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes；learn.microsoft.com/en-us/agent-framework/overview/、/azure/foundry/whats-new-foundry、/microsoft-copilot-studio/whats-new；devblogs.microsoft.com/foundry/；docs.databricks.com/aws/en/release-notes/product/2026/october；help.aliyun.com/zh/model-studio/application-release-notes；volcengine.com/docs/ark/agent-plan-personal-plan-overview；cloud.tencent.com/act/pro/openclaw-in-adp、/product/adp。
- **线 B**：modal.com/blog/runtime-product-update-sandbox-endpoints 与 modal.com/changelog；github.com/e2b-dev/E2B/releases；browserbase.com/changelog 与 /observability；learn.microsoft.com/…/whats-new-foundry、/azure/foundry/agents/concepts/hosted-agents、/azure/app-testing/playwright-workspaces/overview-…；docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/computer-use；openai.com/index/devday-2026-recap/；learn.chatgpt.com/docs/whats-new/september-28-october-2-2026；platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool；github.com/daytonaio/daytona。
- **线 C**：github.com/agentic-community/mcp-gateway-registry/releases/tags/1.32.0 与 1.32.1；events.linuxfoundation.org/mcp-dev-summit-toronto/；blog.modelcontextprotocol.io/posts/2026-07-28/；a2a-protocol.org/latest/blog/2026/10/01/introducing-a2a-cli/；github.com/a2aproject/a2a-cli、/a2a/commits；composio.dev/blog/composio-instant、/toolkits；github.com/ComposioHQ/composio/releases；github.com/ArcadeAI/arcade-mcp/commits/main；arcade.dev/blog/；nango.dev/docs/updates/changelog；github.com/NangoHQ/nango/releases/tag/v0.71.12；pipedream.com/docs/changelog；okta.com/blog/ai/okta-amazon-bedrock-agentcore-security/；workos.com/blog/mcp-gateways-compared；auth0.com/blog/auth0-agent-gateway-beta/；clerk.com/docs/guides/ai/mcp/clerk-mcp-server；aws.amazon.com/about-aws/whats-new/2026/09/amazon-bedrock-agentcore/；learn.microsoft.com/en-us/azure/foundry/agents/concepts/toolbox-overview。
- **线 D**：github.com/volcengine/OpenViking/releases/tag/v0.4.23；github.com/mem0ai/mem0/commits/main 与 /releases/tag/v2.2.1；github.com/topoteretes/cognee/releases/tag/v1.6.3；github.com/supermemoryai/supermemory/commits/main；github.com/letta-ai/letta/releases；github.com/getzep/graphiti/commit/689de29；github.com/firecrawl/firecrawl/commit/1bf1215；github.com/unclecode/crawl4ai/commit/8afd0a6；github.com/langchain-ai/langsmith-sdk/releases/tag/v0.14.4；github.com/langfuse/langfuse/releases/tag/v4.54.0；github.com/Helicone/helicone/commits/main；github.com/AgentOps-AI/agentops；github.com/braintrustdata/braintrust-sdk/releases/tag/braintrust@3.37.1；github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.19.0；github.com/coze-dev/coze-loop；opentelemetry.io/docs/specs/semconv/gen-ai/；aws.amazon.com/about-aws/whats-new/2026/09/amazon-cloudwatch-omni-ai/。

### 15.3 本母稿的写作约束自查
- 数据/事实均来自已落盘输入（hot-scan + 21 分片 + 4 交接 + 合同），**未新增研究、未联网补写、未编造**；分片中已限述/隔离的主张保持其限定与归属；冲突或不确定处如实保留。
- 报告中未使用占位符式标记；本文所有「未取得」均指本次取证未获对应证据（未查询到 ≠ 不存在）。
- 本文为资料库保存的完整母稿，供下游文章编辑线改造；写权仅限本文件与 `research-draft.done`。

— 母稿结束 —
