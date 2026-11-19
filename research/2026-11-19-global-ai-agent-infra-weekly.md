# 全球 AI Agent 基础设施研究周报（2026-11-19 / 第 22 期）研究母稿

- 运行日：2026-11-19（周四，Asia/Shanghai）
- 本期窗口：**2026-11-12 00:00 ~ 2026-11-18 24:00（Asia/Shanghai）**
- 期号：第 22 期；上期第 21 期（2026-11-12，窗口 11-05~11-11，主线「默认不可信——证明取代位置」）已发布；第 20 期缺号不补做。
- 周环比基准：第 21 期冻结母稿（`prior/master.md`）
- 本期主线专题：**长时作业——平台卖档期、检查点与档案，进度仍归应用**

---

## 0. 主线专题（机制级深挖）：长时作业

### 0.1 一句话与三条支撑

**本周平台开始把「Agent 能跑很久」当产品卖，但卖的是三样东西：档期、检查点、档案——没有一家承诺「替你保存进度」。**

1. **档期**：Google 11-16 把 Deferred tier 转 GA，把延迟容忍的 agent 作业排到非高峰，模型推理五折，目标 95% 在 24 小时内完成，服务端状态保留 7 天（A）。
2. **检查点**：AWS 11-17 让 Lambda durable functions 支持 pause/resume，从**最后一个 checkpoint** 在同一 function version 续跑，并明确「进程内未 checkpoint 的状态会丢」；阿里云百炼 11-08 上线的沙箱持久化只保存**文件系统快照、不含进程**（本周才被公开索引，标「本周新披露的历史事项」）（A）。
3. **档案**：AWS 11-17 把 AgentCore Memory 的短时记忆保留上限从 1 年提到 **10 年**，并让每个会话自动生成「全量会话摘要」（A）。

三条线在同一周撞到一起，指向同一个架构事实：**平台能保证「这件事还活着」「这件事有记录」，但不能保证「你的中间状态还在原地」**。最能说明问题的是三个「不」：阿里明确「不保留运行中的进程」；AWS Lambda 明确「pause 冻结 checkpoint 指针，进程内未 checkpoint 的状态会丢」；Google 的 ADK 文档明确「ADK does not preserve in-flight interaction IDs across restarts」。

同周还有两条把「状态所有权」直接搬家的动作：Anthropic 11-12 上线 self-hosted Claude Managed Agents，把 API、agent loop、agents/sessions/session history 全部搬进客户 infra（PostgreSQL 16+），只有模型调用出网（A）；OpenClaw 11-17 的 2026.11.5 把排队消息、发送权限、最终聊天写入做成**跨 Gateway 重启保留**，靠的是先落库再投递而非持久化进程内存（A）。

### 0.2 档期：Google Deferred tier（证据级 A）

**做了什么。** 11 月 16 日，Gemini Enterprise Agent Platform 把两条 deferred 能力同时转 GA：面向自主 agent 调度的 deferred tier（支持 ADK agent 与 Gemini Deep Research Agent），以及 Interactions API 上异步模型调用的 deferred tier。定价为标准按需的**五折**，官方目标是「95% 的任务在 24 小时内完成」，超时即失败，**不回退**到标准档。

**怎么做到的。** 提交时 API 异步受理并**立即返回 interaction ID**，作业走 `queued → in_progress → 终态`。ADK 侧通过 `RunConfig(service_tier=ServiceTier.DEFERRED)` 按次生效；ADK 在后台提交、指数退避轮询，再把完成的 interaction 转回普通响应事件。前提是模型走 Interactions API（`Gemini(use_interactions_api=True)`），否则 ADK 忽略该档位、按标准生成执行并只记一条警告。

**边界比折扣更值得读**：
- 延迟型作业**不能用 SSE 流式**，传 `"streaming": true` 直接 422。
- 多轮工具工作流里**每个模型轮各提交一次 interaction**，每一轮都要各自排队——「一个 agent 作业」在队列与计费上是「N 个排队请求」。
- ADK **不跨重启保留 in-flight 的 interaction ID**：客户端停了轮询就断了；客户端超时只停轮询，后端仍在跑、仍在计费，输出可能取不回来。
- 运行环境差异：Cloud Run 服务在排队期间保持 HTTP 连接，而请求上限 60 分钟；Agent Runtime 与 Cloud Run jobs 允许 168 小时，但**每个模型轮仍受 24 小时限制**；GKE 无平台请求超时。
- 服务端 7 天状态保留只为 `previous_interaction_id` 续链，不是工作流检查点。

**意味着什么。** 「省钱」的代价是把同步语义换成队列语义：调用方必须自己持有 interaction ID、自己做轮询与重试、自己决定超时后是否重投。对平台团队，agent 的 SLA 从「请求延迟」变成「作业完成率」，可观测性要能按作业而不是按请求聚合。

### 0.3 检查点：三家都把「断点」定在磁盘，不定在进程（证据级 A）

**AWS Lambda durable functions（11-17）。** 运行中的 durable execution 可以暂停，稍后从**最后一个 checkpoint** 在同一 function version 续跑；默认暂停时间不计入执行超时；可在保留期结束前删除已完成执行的 history、checkpoint 与输入输出 payload。durable functions 本身支持最长 1 年、内置 checkpoint 与自动重试。机制上，pause 等于「冻结 checkpoint 指针 + 停止计时」，恢复时从指针重放——**不是保留进程内存**，所以暂停期间不计费也不占并发，代价是进程内未 checkpoint 的状态会丢。

**阿里云百炼沙箱持久化（事件 11-08，本周新披露）。** 创建会话时可选「保留沙箱的工作文件与环境修改」，空闲回收时保存**文件系统快照**并释放沙箱，保留期内再次运行从当前快照恢复一个新沙箱；保留期默认 3 天、支持 1–30 天（`snapshot_persistent_seconds` 取 86400–2592000 秒），按快照存在时长计费。保存范围明确排除：上传文件、未同步产物、Memory、Skills、**运行中的进程**。新快照会删除上一份并从新快照创建时间重算保留期，因此它是**单点恢复位**，不是版本链——回不到更早状态。

**Anthropic self-hosted Claude Managed Agents（11-12）。** 客户运行整套 Managed Agents 服务：`cma-server` 提供 API、跑 agent loop、存 agents/sessions/history，但**从不执行 agent 的 shell/文件工具**；数据库要求 PostgreSQL 16+（无数据库则内存态，重启即失）；worker 从 server 取任务，在客户沙箱里跑 shell/文件工具。模型请求发给客户选择的 provider（默认 Anthropic，可选 Bedrock、Google Cloud、Microsoft Foundry、自建 gateway）。

**三者的共同边界。** 恢复的对象都是「磁盘 / 数据库 / 快照」，不是「进程」。这条边界决定了长时 agent 的设计：任何超过一次 handler 生命周期的进度，必须写成外部可读的检查点，并且要幂等——因为恢复通常是「重新进来一遍」，而不是「接着算」。

**意味着什么。** 对迁移方，最危险的问题不是「快照保留几天」，而是「我的 agent 把进度放在哪」：放在进程内存里的长任务，换任何一家托管运行时都不可恢复；放在沙箱本地盘的，能跨空闲但不能跨实例；只有放在外部存储（对象存储、数据库、agent memory）的，才是真正可迁移的。

### 0.4 档案：AWS 把会话记录做成长期资产（证据级 A）

**做了什么。** 11 月 17 日两条同日公告：AgentCore Memory 的短时记忆事件保留上限从 1 年提高到**最长 10 年**；同一服务开始为每个会话自动维护**全量会话摘要**。11 月 16 日，WorkSpaces for AI agents 追加任意 OIDC IdP 登录、on-behalf-of 身份，以及 session replay（会话截图转视频 + 自然语言行动记录，存客户自有 S3、客户自有 KMS 加密）。

**怎么做到的。** 保留期配置在 memory 资源上，**在事件创建时逐条应用**，因此「既有事件保持原保留期」——改配置不会追溯改写历史数据。全量摘要挂在 summary strategy 下、**无需额外配置**：任何启用了 summary strategy 的 memory 都会自动获得（含已存在的会话），随新事件到达持续更新，作为一条长期记忆记录与 summary chunks 并存，检索时可按 record type 只取全量摘要。

**意味着什么。** 这是「记录系统」不是「恢复系统」：十年保留解决审计、合规、老用户回访；它不能把 agent 恢复到中断那一刻。WorkSpaces 的 session replay 同理——回答「agent 当时看到了什么」，不回答「agent 当时算到哪一步」。

### 0.5 客户端侧的同构：OpenClaw 把会话所有权上收到 host（证据级 A）

**做了什么。** OpenClaw 11 月 17 日发布 2026.11.5：队列中的消息、发送权限、最终聊天写入**跨 Gateway 重启保留**；更新失败自动回滚；大内存索引重建可完成；带认证的浏览器 CDP URL 不再进入工具结果。11 月 18 日的 2026.10.33 是 gateway-only 的 extended-stable：以 10 月底代码为基线叠加关键安全/可靠性修复，并**保留 2026.11.4 的签名源码作为「兼容身份」**，显示版本仍是 10.33——版本号与插件 API 兼容基线被拆成两个字段。

**怎么做到的（破坏性变更在此）。** 11.5 对 harness/plugin 的 session control 做了破坏性调整（#175837，PR 合入于 10-18，本版首次对第三方生效）：每个物理 session 由一个 controller 独占 admission/排队/steering/Stop；第三方 harness 必须在 host 的 `runAttempt` 回调内注册「按会话键的活跃运行」并保留返回的 cleanup，否则抛 `AgentHarnessPreflightError` + `SESSION_CONTROLLER_ADMISSION_REQUIRED`；插件不得再直接操作 `chatAbortControllers`/`chatQueuedTurns`（访问抛 `PluginCapabilityRemovedError`），必须走 `registerGatewayMethod` + 授权分发。cron 侧同版把账号选择、重试截止时间、完成运行身份都随 job 持久化。

**意味着什么。** 这把「谁拥有一次运行」从插件私有状态上移到 host 注册表——与云厂的 work identity + 租约是同一个设计动作。它也解释了为什么这类变更总是破坏性的：一旦运行归属上收，任何绕过 host 直接改内部状态的插件都会失效。

### 0.6 背景（非本周）：Microsoft Ignite 的同一动作

Microsoft 在 Ignite 2026 发布的 Foundry Hosted Agents 更新（long-running resiliency GA、memory snapshots preview、idle timeout 2 分钟–4 小时、BYO-AKS）与本周主线完全同构：resiliency 的两套身份（work identity + input identity）+ 租约 + handler 重入，**恢复从 handler 开头重入、不是确定性重放**；memory snapshot 官方定义为「a prepared starting point, not a checkpoint of an ongoing session」，`$HOME` 与进程内存不跨 idle 保留。

**但该博客发布于 2026-11-18 17:00Z = 11-19 01:00 CST，比窗口终点晚 1 小时**，按窗口纪律标「背景，非本周」，不计入本周判断。它在本期的价值是外部佐证：第四家厂商在同一周给出同一条边界。

### 0.7 与上期的关系

上期主线「默认不可信——证明取代位置」回答「这次调用凭什么被允许」；本期回答「跑了很久、断过一次之后，这还算不算同一次作业」。两者在身份处接续：上期把身份绑定到每次调用，本期把身份延伸到跨进程的作业（work identity / 租约 / checkpoint），并把「状态存在哪」变成采购与架构的第一问题。周环比见 §9。

### 0.8 主线局限

- Google 队列边界为官方文档单源，未取得配额数值与第三方复核。
- AWS 两条 Memory 公告为 What's New 单条，**未取得 API 字段与配额细节**；AgentCore release notes 为月档，无日级锚点。
- 阿里两条属「本周新披露的历史事项」：事件日 11-08 / 11-11，上周同一页面最新为 10-21，故披露日 ≥11-12，但**实际披露时刻未取得**。
- Microsoft Ignite 全文超窗 1 小时，仅作背景，不参与本周结论。
- OpenClaw 2026.11.4 的 220 个提交未逐条读（release 页只给统计），故 11.4 只作背景。

---

## 1. Harness / Agent OS 控制层

### 本周模块结论

1. **执行单位从「一次工具调用」变成「一段代码」。** Claude Code 2.1.323 上线实验性 Code Mode：Claude 写 JavaScript，经名为 `REPL` 的工具执行，一次往返里完成「搜索→筛→改→测」；OpenClaw 的 Code Mode 从「可跨 cell 保留 store/load」推进到跨重启保留。随之而来的是治理错位——权限规则按单次调用求值，auto 模式分类器按整段代码求值，且**看不见运行期才算出来的值**（如从搜索结果里取到的路径）。
2. **默认值集体变严，且每家都留了具名的「回到旧行为」开关。** Claude Code 2.1.325 把「沙箱内 Bash 免询问」翻转为默认走正常权限流（旧行为需显式 `sandbox.autoAllowBashIfSandboxed: true`）；OpenAI Agents SDK alpha.8 禁止网络规则里的裸 `*`（全放行必须 `NetworkPolicy.allow_all()` + 隔离执行器）；OpenClaw 11.4 要求受限/未验证授权下的委托式持久变更必须审批。
3. **扩展点从「同侪」降为「租户」。** OpenClaw 11.5 要求 active run 在 host 的 `runAttempt` 回调内按 session key 注册、插件 RPC 改走 Gateway 授权分发（`chatAbortControllers`/`chatQueuedTurns` 被移除）；Claude Code 用 `engines["claude-code"]` 做安装期版本闸、hook 参数必须数组、`createSdkMcpServer` 在 agent 级弃用。
4. **框架层本周以性能与契约微调为主。** LangGraph 1.2.21/1.2.22 全是热路径常数因子；ADK 三语言分叉（Java 补类型化工作流端口、JS 补遥测 v2、Python 只修 tracing）；真正的架构增量在 CrewAI 的向量层解耦与 Dify 1.20 的 HITL 2.0。
5. **供应链可见性出现反例。** Microsoft Agent Framework 的 GitHub 主仓在运行日 404（多路径复核），但 PyPI `agent-framework` 1.26.0（11-12）与 NuGet `Microsoft.Agents.AI` 1.28.0（11-06）仍在发版——发版通道与变更说明通道分裂。

### 固定对象状态表

| 对象 | 窗内状态 | 窗内版本 / 日期（CST） | 证据级 |
|---|---|---|---|
| OpenClaw | 有动态（主线 + extended-stable 双线） | 2026.11.4（11-17）、2026.11.5（11-17，UTC 更新 11-18 03:33）、2026.10.33 extended-stable（11-18） | A |
| Anthropic Claude Code | 有动态（4 版） | 2.1.323（11-13）、2.1.325（11-14）、2.1.326（11-17）、2.1.327（11-18） | A |
| Claude Agent SDK (TS / Py) | 有动态 | TS 0.3.323/325/326/327；Py 0.2.181–0.2.184（无 release body） | A / C |
| OpenAI Agents SDK | 有动态 | Py 0.24.0-alpha.8（11-16）；JS 0.22.0（11-13）、0.22.0-alpha.3（11-17） | A |
| LangGraph / LangChain | 有动态（性能为主） | LangGraph 1.2.21（11-13）、1.2.22（11-14）；core 1.8.3、langchain 1.5.1（11-18） | A |
| LangSmith | 有动态（周档） | 周条目「November 9-16, 2026」 | C（周桶） |
| Google ADK | 有动态（三语言） | py 2.14.1（11-13）、js 2.5.0（11-13）、java 1.15.0（11-18） | A |
| Microsoft Agent Framework | **本次未取得（异常）** | 主仓 404；PyPI 1.26.0（11-12）、NuGet 1.28.0（11-06）、Go v0.3.1（11-13） | B（版本 A / 机制 D） |
| Semantic Kernel / AutoGen | 无动态 | SK 最新 python-1.47.0（11-05）；AutoGen 0.7.5（2025-09-30） | A |
| Databricks Mosaic / Agent Bricks | 月档，非日级 | 索引页 2026-10-30 | C |
| CrewAI | 有动态 | 1.15.40（11-12）、1.15.41（11-13） | A |
| pydantic-ai | 有动态（含 2 个 high GHSA） | 2.68.0（11-12）、2.69.0（11-17）、2.70.0（11-18） | A |
| Dify | 有动态 | 1.20.0（11-18） | A |

### 深拆条目

**OpenClaw：会话所有权上收 + 版本号与兼容身份解耦（A）**

11.5（11-17 发布）的 breaking 集中在 session control（PR #175837）：每个物理 session 由一个 controller 独占 admission / 排队输入 / steering / Stop / 结算；`setActiveEmbeddedRun(...)` 不再凭 session key 或 agent id 自证身份，必须搬进 host 的 `runAttempt` 回调注册并保留返回的 cleanup，违规抛 `AgentHarnessPreflightError` + `SESSION_CONTROLLER_ADMISSION_REQUIRED`；插件侧 `chatAbortControllers`/`chatQueuedTurns` 被删除，访问抛 `PluginCapabilityRemovedError`，改走 `registerGatewayMethod(...)` + `dispatchGatewayMethod` 鉴权分发。同版「restart-safe conversations」把排队消息、发送权限、最终写入做成跨 Gateway 重启保留（#196923/#196540/#196493），机制是先落库再投递、按幂等键重放，而不是持久化进程内存；cron 侧把账号选择、重试截止、完成运行身份随 job 持久化。10.33 是 gateway-only extended-stable：以 10 月底代码为基线叠加关键修复，并「retain the signed 2026.11.4 source baseline as this release's **compatibility identity**」——显示版本仍是 10.33，插件 API 基线钉在 11.4，于是版本号不再唯一决定兼容性。

**Claude Code：Code Mode 的机制与四个硬限制（A）**

2.1.323 以 `CLAUDE_CODE_EXPERIMENTAL_CODE_MODE=1` 开启：Claude 写 JS（例：`const files = await $(rg -l ...).text(); await edit(...)`），由 `REPL` 工具执行，代码内每次工具调用仍按原名（如 `Bash`）过 deny/ask 规则与 `PreToolUse` hook。限制很具体：仅终端交互会话与原生安装，**不能用于 `-p`、Agent SDK、VS Code、Desktop、cloud 会话**，**不能经 gateway / Bedrock / Claude Platform on AWS / Google Cloud Agent Platform / Microsoft Foundry**，HIPAA 或零数据留存组织不可用，前台代码 10 分钟、后台最长 2 小时；组织只能通过 managed settings 设 `0` 关闭，不能强制开启。2.1.325 反转沙箱 Bash 默认并拒绝沙箱内写 `.claude` 的 settings/skills/agents/commands/hooks；2.1.326 加 `OTEL_RESOURCE_INCLUDE_HOST`（默认关）；2.1.327 加 managed settings checksum 头、`/status` 列出「被忽略的权限设置 / 永不匹配的 hook matcher」、拒绝部分符号链接。TS SDK（背景，非本周）0.3.326 把 `mcpServersDelivery: 'initialize'` 做成默认路径的替代（避免 MCP 定义走命令行），0.3.327 要求 hook 选项必须是数组、弃用 agent 级 `createSdkMcpServer`。

**OpenAI Agents SDK：审批、预算检查点、并发默认反转（A）**

Py alpha.8 引入 `FunctionToolApprovalRequest` / `FunctionToolApprovalDecision`（可「记住整个 Session」），并用 `run_input_policy_before_approval=True` 让输入策略在批准谓词之前也跑一次，避免「人看到未脱敏参数、执行的是另一份」；checkpoint 恢复时把已花的 request/token 预算写进检查点并继续计入，因此 alpha.7 拒绝打开 alpha.8 的 budgeted checkpoint。JS alpha.3 把「只含自动工具的 catalog」默认改为并发准入回调（`maxFunctionConcurrency: 1` 回到串行），`session.enqueue()` 开始拒绝此前被忽略的 `ifBusy`。平台侧 11-17 给 Responses API 两小时/八小时完成窗口，token 费率较 Standard 低 30% / 40%。

**LangGraph / ADK / Dify：性能与治理各走一步（A）**

LangGraph 1.2.22 把子图流式放到独立线程，其余是热路径优化（pending writes 先按 task 过滤、宽 state 用 set 匹配 update key、runner 停止条件只看 failed futures），并同步发 checkpoint 4.3.2 / checkpoint-postgres 3.2.1。ADK-Java 1.15.0 加 `FunctionNode`（`TypeReference` 端口 + 构建期端口/边可赋值性检查）与 `ClassifierNode`/`LlmClassifier`，把路由判定做成图上显式节点；ADK-JS 2.5.0 发 v2 span 树与 GenAI log records、`setIdProvider`（确定性回放），并修「agent instructions 出现在公开 A2A agent card」。Dify 1.20.0 把 HITL 做成平台资源（共享渠道 + 联系人 + 模板 + 审批表单，邮件/Slack/飞书/Teams/钉钉/企业微信投递），新增 OTLP 导出、可选恶意文件扫描（默认关）、个人访问令牌；breaking 包括 OpenShell 共享卷 Home Snapshots 移除、`shared.env` 退役、6 个迁移。

**Microsoft Agent Framework 的异常（B/D）**

主仓 `microsoft/agent-framework` 在 GitHub 返回 404（releases.atom、仓库页、API、releases 页四路复核），而 PyPI `agent-framework` 1.26.0 上传于 2026-11-12T18:25Z、NuGet `Microsoft.Agents.AI` 1.28.0 于 11-06、Go 仓 `agent-framework-go` v0.3.1 于 11-13。Learn 概览页仍把 Harness Agent 定义为「batteries-included… planning and todo tracking, context compaction, file access and memory, don't-ask-again tool approval, and observability」，并称 Agent Framework 是 SK 与 AutoGen 的直接继任者。**机制未取得**：release body 不可达，PyPI 的 release_notes 链接仍指向 404 路径。结论只到「版本仍前进、变更说明不可核」，不推断原因。

### 模块洞察

1. **「一段代码」比「一次调用」更难审。** Code Mode 把延迟和 token 降下来，但把判定粒度撕开：规则看单次调用、分类器看整段代码、运行期值谁都看不见。Claude Code 文档自己给的答案是「必须控住的调用留在规则/hook 层」——这等于承认自动分类无法承担关键授权。
2. **默认值在这一周变成「合规配置」的一部分。** 五处独立的默认收紧（Claude Code 沙箱 Bash、OpenAI 裸 `*`、OpenClaw 委托审批、LangSmith auth-proxy 目的地、CrewAI 私网 URL 白名单）都采用同一句式：宽松行为降级为具名选择。升级检查单应新增一栏「哪些原本默认放行的路径现在会问/会拒」。
3. **插件生态正在被「票」治理。** `runAttempt` 注册、`engines` 版本闸、hook 参数结构化、managed settings checksum，四件事的共同点是把「扩展能不能动」从运行期试错前移到安装期与准入期。对自研 harness 的团队，这是本周唯一必须排期的破坏性改造。

---

## 2. Runtime / Session / State 运行时与会话状态

### 本周模块结论

1. **计价维度从「预留规格」拆成「基线 + 突发 + 档期」。** AWS AgentCore V2 新增 resource configuration：承诺 0.25 vCPU / 1 GB 到 2 vCPU / 8 GB 的基线，峰值可突发到基线 4 倍（单会话上限 8 vCPU / 32 GB），基线单价低于按量；Modal 用工程博客给出反面论证（沙箱一生中超过一半时间使用不到峰值 6%），默认 0.125 核 / 128 MiB 起步、CPU 可突发 +16 核；Google 则单卖「延迟」——Deferred tier 五折。
2. **「会话可重建」进一步变成「状态必须外置」。** 阿里云百炼沙箱持久化只保存文件系统快照、不保留进程；Anthropic self-hosted Managed Agents 把 agents/sessions/history 搬进客户 PostgreSQL；AWS Lambda durable functions 从最后一个 checkpoint 续跑并明确「进程内未 checkpoint 的状态会丢」。
3. **会话历史成为可长期持有的资产。** AgentCore Memory 短时记忆保留上限 1 年 → 10 年，且策略在事件写入时固化；每个会话自动生成全量摘要。
4. **控制面继续下沉到客户集群。** Google 11-12 把 Agent Gateway for GKE 推到 Preview（GKE ≥1.37.2-gke.1042000，europe-west1 / us-central1），管控「到 agent、从 agent 出、agent 之间」三类流量。
5. **国内三家节奏仍与能力脱钩。** 阿里是「做了但晚披露」（11-08 能力本周才进索引），腾讯是「披露了但不在本模块」，火山是「文档有能力、公告停在 202610」，Coze 公开面未取得。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| AWS AgentCore Runtime | 有动态（月级 + 日级旁证） | resource configuration、10 GB 镜像（V2）、build warmup hook、再扩 9 Region、Instances 扩 6 Region | B（月级） |
| AWS AgentCore Memory | 有动态 | 10 年保留、全量会话摘要、每月 5,000 次免费 web search（11-17） | A |
| AWS Lambda | 有动态 | durable functions pause/resume（11-17）、customer-managed runtimes GA（11-18） | A |
| Google Agent Runtime | 有动态 | Deferred tier GA（11-16）、Gemini 4 Hydrogen GA（11-12） | A |
| Google Agent Gateway | 有动态 | for GKE Preview（11-12） | A |
| Microsoft Foundry Hosted Agents | **窗外 1 小时（背景）** | Ignite 稿 11-19 01:00 CST | A（超窗） |
| 阿里云百炼 | **本周新披露的历史事项** | 沙箱持久化（事件 11-08）、多模态评测（11-11） | A |
| 腾讯云 ADP | 有动态（非本模块） | 天气工具下线、文档解析计费（11-13） | A |
| 火山方舟 / Coze | 无窗内可核验 runtime 条目 | 产品公告最新 202610；202611 仅模型 | A / C |
| Anthropic Managed Agents | 有动态 | self-hosted 整套服务（11-12） | A |
| OpenClaw sessions/cron/Gateway | 有动态 | 3 个版本（详见 §1） | A |
| E2B / Modal / Daytona | Modal 有动态；E2B 有版本；Daytona 无 | Modal 11-12；E2B 2.64.0（11-13）；Daytona 最新 11-07 | A |

### 深拆条目

**AWS AgentCore：基线 + 突发 + 预热钩子（B，月级）**

resource configuration 把「容量承诺」与「实际调度」解耦：客户为基线付费拿下限保障，超出部分从平台空闲容量取、按秒结算，且基线单价低于按量单价。配套 10 GB 镜像上限（仅 V2，>2 GB 需设 `minimumMemoryInMiB` 提供 build disk）与 build warmup hook（`CreateAgentRuntime`/`UpdateAgentRuntime` 的 `hooksConfiguration`）：第一个 hook 在平台准备 agent 时**调用容器两次**，一次 memory call 载入「每会话都要用的东西」、一次 disk call 读取「会话启动时要读的文件」——把进程内初始化提前到平台准备阶段。风险在尾部：突发不保证，官方未披露争用策略。

**AWS Lambda：pause 的语义是「冻结指针」，不是「冻结进程」（A）**

11-17 的 durable functions 支持暂停/恢复/删除：pause 保存最后一个 checkpoint、停止计时，默认暂停时间不计入执行超时；恢复时从该 checkpoint 在同一 function version 续跑；可在保留期结束前删除已完成执行的 history、checkpoint 与 payload。durable functions 本身支持最长 1 年、内置 checkpoint 与自动重试。11-18 的 customer-managed runtimes GA 把 runtime 变成独立资源（ECR 中的 OCI 镜像），function 只引用 runtime ARN，更新走执行环境回收路径——等价于把运行时补丁做成平台级滚动发布。

**Google：Deferred tier 的边界（A）**

除折扣外，真正影响架构的是四条：不支持 SSE（`"streaming": true` 返回 422）；多轮工作流每个模型轮各提交一次 interaction、各自排队；ADK 不跨重启保留 in-flight interaction ID，客户端超时只停轮询、后端继续计费；运行环境请求上限不同（Cloud Run 60 分钟、Agent Runtime 与 Cloud Run jobs 168 小时但每模型轮 24 小时、GKE 无平台超时）。Gemini 4 Hydrogen 同周 GA：统一 1,048,576 token 输入输出、65,536 前台输出 + `continuation_token` 长解码、四档 thinking、隐式 durable caching（≥4,096 token 共享前缀默认开）。

**Anthropic self-hosted Managed Agents：控制面 / 数据面 / 模型面三层解耦（A）**

客户运行整套服务：`cma-server` 提供 API、跑 agent loop、存 agents/sessions/history，但**从不执行 shell/文件工具**；数据库要求 PostgreSQL 16+（无数据库则内存态、重启即失）；worker 从 server 取任务并在客户沙箱里执行工具。模型请求发给客户选择的 provider（默认 Anthropic，可选 Bedrock、Google Cloud、Microsoft Foundry、自建 gateway）。即使控制面被攻破，攻击者也不能直接在客户环境执行命令，必须经 worker 的授权路径；代价是客户要自己安装每个 release、运维数据库与 worker 池。

**阿里云百炼沙箱持久化：只存磁盘，不存进程（A，本周披露）**

创建会话时可选择保留工作文件与环境修改；会话空闲达回收条件时保存**文件系统快照**并释放沙箱，保留期内再次运行从当前快照恢复新沙箱。保留期默认 3 天、支持 1–30 天（`snapshot_persistent_seconds` 取 86400–2592000 秒），按快照存在时长计费。**不保留**：上传文件、未同步产物、Memory、Skills、运行中的进程。新快照会删除上一份并从新快照时间重算保留期，因此是单点恢复位而非版本链。

**腾讯 / 火山 / Coze：三种不同的「没东西可报」（A/C）**

腾讯 11-13 两条 ADP 公告是工具与计费（天气工具 2026-12-11 下线、文档解析 11-26 起调价），非 runtime；火山方舟产品更新公告最新分区为 202610，202611 只有模型发布（`doubao-seedance-2-5-flash-261115`）；Coze 首页、`/open/docs`、`/docs`、`/store`、docs.coze.cn 等 10 个入口均为 JS 壳或无更新条目，公开面未取得。三者性质不同：腾讯是「有动态但不在本模块」，火山是「公告未更新」，Coze 是「本次未取得」。

### 模块洞察

1. **报价单要拆成四项。** 基线单价、突发单价、突发上限、突发不保证时的行为——只问「每小时多少钱」会同时低估峰值账单与高估保障。这一条对 AWS 与 Modal 都成立，且两家的商业设计相反（AWS 用低价鼓励调准基线，Modal 用无上限内存鼓励不为峰值预留）。
2. **「会话状态」是四种资产，各有各的存储。** 磁盘文件（可快照：阿里、Foundry memory snapshot）、进程内存（不可快照：两家都明确不保留）、会话历史（可外置：Anthropic Postgres、OpenClaw 持久队列、AgentCore Memory）、检索记忆（独立生命周期）。把它们混在一个 `session` 概念里，是迁移返工的第一来源。
3. **自托管的边界从「沙箱」扩到「服务」。** Anthropic 把 agent loop 与 session 存储交给客户、只保留模型可替换，与 AWS/Google「控制面留在云上」方向相反。采购问题因此变成三选一：自持数据、自持控制面、还是两者都要。

---

## 3. Sandbox / Computer Use / Browser 沙箱与浏览器

### 本周模块结论

1. **沙箱计费从「预留规格」转向「按秒实际 + 突发」。** Modal 11-12 的工程博客给出量化依据：典型沙箱一生中超过一半时间使用不到峰值的 6%；默认 0.125 核 / 128 MiB，CPU 可突发 +16 核、内存默认不设上限，按秒取「request 与实际用量的较大者」，<8 GiB 突发沙箱 OOM SLO 0.0001%/分钟（约 694 沙箱日一次）。E2B 同周把可调 vCPU 做成模板属性（`maxCpuCount` + 每沙箱 `cpuCount`）。
2. **开源浏览器 agent 进入「成本与可观测」阶段。** browser-use 1.0.4 把「每来一张截图就重写历史消息」改为每 20 条工具结果批量裁剪，恢复 provider prompt cache：同一 BU Bench v2.1（200 任务）分数 76.1 vs 76.0，**单任务模型成本 $0.434 → $0.208**；1.0.5 把运行评判做成内置 judge；1.0.6 把默认模型切到 BU 4.0（$1.80/$9.00 per 1M token，是 `bu-fast` 的 15 倍）。
3. **浏览器会话的「断线重连 + 归类」语义在补齐。** Browserbase 11-12 上线 session labels（按 workflow/env/version 过滤）；agent-browser 0.43.0 修「tab 关闭后命令等到超时」并给可访问名为空/重复的控件加 snapshot hint；Stagehand 稳定版 3.7.4 落在 11-19 07:19 CST（窗外）。
4. **云厂内置浏览器/代码解释器本周无新条目。** AgentCore Browser/Code Interpreter 的 11 月 release notes 零条目；Google 的 computer use 走 Gemini 4 Hydrogen 模型能力（11-12 GA），不是托管浏览器；OpenAI/Anthropic 的 computer use 在各自 changelog 窗内无变更。
5. **企业边界成为浏览器自动化的新卖点，但证据在窗外。** Foundry Browser Automation 的 VNet 注入、自有代理、Web Bot Auth、会话录制均随 Ignite 发布，博客时间戳超窗 1 小时，只能作背景。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| E2B | 有动态 | 2.64.0（11-13）：可调 vCPU、OAuth header、模板分页/删除 | A |
| Modal | 有动态 | Sandbox Events UI、成本归因、burst 博客（11-12） | A |
| Daytona | 无动态 | changelog 最新 11-07 v0.231.0 | A |
| Browserbase | 有动态 | session labels（11-12） | A |
| Stagehand | 窗内仅 dev 预发布 | 3.7.4 于 11-19 07:19 CST（窗外） | A |
| browser-use | 有动态（4 版） | 1.0.3–1.0.6；成本减半、内置 judge、BU 4.0 默认 | A |
| agent-browser | 有动态 | v0.43.0（11-13 CST） | A |
| OpenAI / Anthropic Computer Use | 无窗内变更条目 | platform changelog 11-16/17 仅模型与计费 | A |
| AWS Browser / Code Interpreter | 无窗内发布条目 | 11 月 release notes 0 条 | A |
| Google computer use | 有动态（模型侧） | Gemini 4 Hydrogen GA（11-12） | A |
| Microsoft Browser Automation | 窗外 1 小时（背景） | Ignite 稿 11-19 01:00 CST | A（超窗） |

### 深拆条目

**Modal：把「预留」论证成浪费（A）**

计费上「request 是地板、实际是天花板」：空闲只付小地板、峰值按秒付实际。平台因此敢把内存默认设成无上限——内存超卖的风险由 OOM SLO 与「超出 request 才可能被驱逐」的规则兜底；CPU 争用只导致变慢（每沙箱至少拿到 request），内存争用才会驱逐。这是两种资源不同的超卖策略，也是「可接受偶发 OOM」换「不为峰值付费」的显式交易。配套 Events UI（execs / TCP tunnels / HTTP requests 三类事件）与按沙箱成本归因，把黑盒变成可审计轨迹。

**E2B 2.64.0：把规格与身份都变成参数（A）**

模板声明 `maxCpuCount`、创建沙箱时选 `cpuCount`，同一模板可服务轻/重两类任务，不必为峰值建两个模板。API client 接受 `Authorization` 头替代 API key，并用 `X-Team-ID` 选团队——企业可用自己的 IdP 发短期 token、按团队计费审计，不必把长期 key 嵌进沙箱创建方。breaking 是 `e2b template list -f json` 改输出 SDK `TemplateInfo` 结构（`templateId`/`buildId`/`names`）。

**browser-use：先降成本，再抬默认模型（A）**

1.0.4 的批量裁剪是「恢复 prompt cache」的直接手段：此前每张截图都重写历史消息，缓存全失效；改为每 20 条工具结果裁剪一次后，benchmark 分数几乎不变而成本减半（$0.434 → $0.208/任务）。1.0.5 把 judge 内置，输出 `success/failure_reason/prompt_injection_detected/bot_block_or_captcha_detected/gotchas`，把「这次跑得好不好」变成结构化字段。1.0.6 把默认模型换成 BU 4.0——单价是 `bu-fast` 的 15 倍，官方建议想保留旧价用 `llm='bu-fast'`。这是一次**默认成本上调**，升级即账单变化。

**Browserbase / Stagehand / agent-browser：会话元数据与稳定性（A）**

Browserbase 的 label 是项目级、多对多元数据，不改变 session 生命周期，但把「找一次运行」从 session ID 变成业务维度检索——这是成本归因与回归对比的前置条件。agent-browser 0.43.0 修「tab 关闭后命令挂到超时」，并给可访问名为空/重复的控件加 snapshot hint，属于可访问性树质量修复。Stagehand 窗内只有 python dev 预发布（browse CLI、Discord fallback、扩展打包 minify），稳定版在窗外，故本周不作主张。

### 模块洞察

1. **沙箱的「密度」与「状态」被同时重新定价。** Modal 按实际用量+突发，E2B 按模板上限+每沙箱选核，AWS 按基线+4 倍突发——三家都在承认「agent 的负载是尖峰且短暂」。但密度提升的前提是状态外置：一旦沙箱可能被驱逐，把进度放在沙箱内就是设计错误。
2. **浏览器 agent 的竞争点从「能力」变成「单位任务成本」。** browser-use 一轮发布里最重的两条（批量裁剪、默认模型）都是成本项，judge 则把质量变成可记录字段。对平台团队，浏览器任务的预算应按「每完成任务」而不是「每 token」做。
3. **企业网络边界仍是云厂的护城河，但本周无法计入。** Foundry 的 VNet 注入、代理、CAPTCHA/Web Bot Auth 是开源方案短期补不上的；证据超窗 1 小时，本期只作背景提示，等下一期正式评估。

---

## 4. Tool Gateway / Protocol 工具与协议层

### 本周模块结论

1. **MCP 本周没有新协议修订，但「发布节律」变了。** 官方博客把规范发布固定为每年两次（3 月与 9 月最后一个周二），下一次 **2027-03-30**，原定 2026-12 的版本取消——公告发布于 2026-11-11 09:00Z（北京时间 11-11 17:00），比窗口起点早 7 小时，按纪律记**背景，非本周**，但它是理解窗内所有 MCP 动作的前提。
2. **窗内实质动作在「扩展」层。** SEP-3392（Extension Lifecycle）为 Final，11-17 文档对齐完成：扩展标识符固定 `{vendor}/{name}`、阶段由目录承载（experimental / beta / stable）、破坏性变更递增 `revision`、**收到未知 revision 的对端不应启用该扩展**；TS SDK 的完整 `{ id, setup(ctx) }` 扩展 API 在 11-18 深夜（UTC 16:47 = CST 11-19 00:47，已过窗口终点）才落到 main，且未发版，按背景处理。
3. **网关出现「三协议合流」。** Google 11-12 的 Agent Gateway for GKE 与 AWS 的 AgentCore Gateway 都同时承载 LLM / MCP / A2A 流量；差异在控制点位置——Google 压到 service mesh（agent 不动、流量绕行），AWS 压到运行时与桌面。
4. **工具网关的竞争点从「接了多少 SaaS」转向「schema 与错误的可编程性」。** Composio 11-17 一批发布里最实质的是 JSON Schema 归约（Gemini `parametersJsonSchema`、Vertex 子集降级）与结构化错误信封（`statusCode`/`apiErrorCode`/`suggested_fix`）。
5. **A2A 与 Pipedream 本周无协议/产品动态；Azure 侧本次未取得。** 三者性质不同：A2A 是「无变更」、Pipedream 是「无公开记录」、Azure API Center 是「未取得」。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| MCP 规范 / SEP | 有动态（文档/流程，无修订） | 11-16 弃用清理、11-17 扩展总览对齐 SEP-3392、11-18 Inspector 文档 | A |
| MCP Registry | 有动态（提交级） | 11-12 多 proof record 校验、11-13 publisher 私钥来源；最近版本 v1.8.9（11-10，窗外） | A |
| MCP SDK | 窗内无发版（TS main 提交在窗外） | `extensions({id,setup})` 落地 CST 11-19 00:47；Py 窗内无提交 | A |
| A2A | 无动态（仅 docs 提交） | 11-13 合作伙伴、11-16/11-18 文档修链；v1.1.0-rc 为 10-29 | A |
| Composio | 有动态 | 11-17 SDK（core 0.30.0 / py 0.33.0）、11-16 CLI 0.6.2 | A |
| Arcade | 有动态（提交级） | 仓库迁至 `arcade-mcp`；11-13/11-17/11-18 三条提交 | A/B |
| Nango | 有动态 | v0.72.5 / v0.72.6（11-16） | A |
| Pipedream Connect | 无动态 | changelog 最新 2025-10-01 | A（入口）/ D |
| AWS AgentCore Gateway | 有动态 | 11-17 免费 web search、11-16 WorkSpaces 接入 | A（公告）/ C（月级） |
| Google Agent Gateway | 有动态 | 11-12 GKE Preview | A |
| Azure API Center / Foundry toolbox | 本次未取得 | 已试 3 入口（updates 0 条、learn 落地页 2026-01、whats-new 404） | — |

### 深拆条目

**MCP：扩展生命周期成为可求值字段（A）**

阶段变化不改标识符，扩展目录承载阶段：`specification/experimental/<name>`（或独立 `experimental-ext-<name>` 仓）、`beta/<name>`、`stable/<name>/<protocol-revision>/`（已发布 revision 不可变），晋升核心后进 `archived/<name>`。协商时机是**逐请求**：无状态协议下客户端在每个请求的 `_meta["io.modelcontextprotocol/clientCapabilities"].extensions` 里声明，服务端在 `server/discover` 响应里声明——这与 2026-07-28 取消 `initialize` 握手是同一套设计。Registry 11-12 的修复把「只取第一条 proof record」改为遍历全部记录逐一验签，坏记录不再遮蔽好记录；配套语义是「发布新 key 不吊销旧 key；删除记录只阻止新登录，已签发 token 仍有效至过期」。

**Composio：一份 schema 多 provider 的有损投影（A）**

Composio 的工具定义是「一份 JSON Schema、多 provider 适配」。Gemini/Vertex 只接受 OpenAPI 子集、直接在传输层被拒，解法是在包装期做**有损但语义保持**的投影：丢不支持关键字、`oneOf`→`anyOf`（放宽）、`null` 成员→`nullable`（等价）、字符串 `const`→单值 `enum`（等价）、非字符串枚举搬进 description。容错侧不再因单个工具「合法但非常规」的 schema（`items: true`、draft-04 布尔 `exclusiveMinimum`、无 `type:"object"` 的组合根）整包失败——1562 个 toolkit 中 8 个含此类工具，不可修复则跳过并告警。错误信封让 agent 能按 `statusCode`（如 410）分支重建连接，而不是做字符串匹配。

**Nango：把 CI/CD 的 workload identity 搬进集成平台（A）**

installation token（#8224，11-13 合入）由自托管安装用**自己的私钥**在本地签 JWT，claims 含 `typ`、`ver`、**`body_sha256`（请求体摘要）**、签发时间与 key id；registry 侧查 key → 验签 → 校验 key/installation 存活 → 比对 body 摘要 → 校验 license，token 寿命 5 分钟、允许 15 分钟时钟偏移。body 绑定使 token 无法挪用到另一个请求。task capability token（#7980，11-11 合入）是短时 JWT，只在声明了 scope 的路由接受，须匹配 environment/connection/sync/task 四元组，且 `mountPersistAuth` 在 body 解析之前完成凭证检查。

**Arcade：仓库迁移与「错误面收敛」（A/B）**

`ArcadeAI/arcade-ai` 301 到 `ArcadeAI/arcade-mcp`，窗内无版本发布，动作集中在 agent 可见面：11-17 `ARCADE_WORKER_SECRETS` 支持 worker 注入多个 secret；11-18 让 GraphQL 原始错误不再进入 agent-facing message。合看是把「凭证进、错误出」两个方向的泄漏面同时收窄——模型会把内部错误当指令读。

**Google / AWS 网关：一个压到 mesh，一个压到运行时（A/B）**

Google 的做法不是新建数据面，而是复用既有 service mesh：每个集群跑本地 gateway 代理，agent 出口流量被 sidecar 接管，访问策略在连接层求值；agent 只需被注册并获得身份（身份与 Agent Registry 记录绑定，MCP server 同表登记）。AWS AgentCore Gateway 做的是**双边界认证**：入站 JWT authorizer 校验调用方 workload identity，出站 credential provider 在调用瞬间注入目标 OAuth/API key 并负责 refresh，凭证不进入 agent 进程；同时支持 OpenAPI/Smithy/Lambda 输入与 passthrough（含 A2A）。

### 模块洞察

1. **问「支持哪个 MCP 版本」已经过时。** 2027 Q1 之前不会再有核心修订，差异全在「支持哪些扩展的哪个 revision」。采购问题应改成「扩展清单 + revision 策略 + 未知 revision 的行为」。
2. **「无状态协议 + 平台自定义会话头」成为事实模式。** MCP 2026-07-28 移除 `Mcp-Session-Id` 后，AgentCore Runtime 用 `X-Amzn-Bedrock-AgentCore-Runtime-Session-Id` 承接会话、`GET /ping` 做健康检查。互操作测试必须覆盖这一层，否则换平台就会丢会话。
3. **工具网关的护城河分裂成两条。** Composio 优化「调用成功率」（schema 投影 + 错误可编程），Nango 优化「凭证可控性」（短时 token + 请求体绑定 + 读取审计）。选型时先确定自己更怕哪种失败：工具调不通，还是凭证管不住。

---

## 5. Identity / Auth / Permission 身份与权限层

### 本周模块结论

1. **本周身份层的主线不是「给 agent 发身份」，而是「让委托可被收回」。** IETF OAuth WG 在 11-15~11-17 有 10 余份 agent 相关草案更新，其中两份方向一致：把「吊销一个 token」升级为「关闭一条授权谱系」（authority epoch / revocation closure），以及用 DNS 记录把 agent 名与它的 OAuth client 绑定（免联邦的跨组织校验）。
2. **MCP 侧的客户端注册范式已转向 Client ID Metadata Documents（CIMD），但不是共识。** 2026-07-28 规范把 RFC7591 动态注册标为弃用、改推 CIMD；Entra Agent ID 把 CIMD 做成 preview 并另设「批准/监控/禁用」管理面；Nango 的 vMCP 反而优先管理员静态凭证。三种取舍说明 CIMD 是**按信任域选择**，不是默认答案。
3. **凭证注入位置继续下沉，agent 进程不再持有长期 secret。** Nango 用「私钥签名 + 请求体摘要 + 5 分钟寿命」给自托管安装发身份；AWS WorkSpaces 用 OBO 让 agent 继承登录用户权限；E2B 用 OAuth header + `X-Team-ID` 替代长期 API key。
4. **云厂身份产品本周没有新版本，只有接入面扩张。** Entra Agent ID 的 what's-new 最新日期化条目停在 2026-10-23；AWS AgentCore Identity 无独立发版；Google 只在跨云 Agent Gateway 条目里提「可验证身份」。**不要把接入面扩张写成身份模型升级。**
5. **审计成为身份层的第二产品。** Nango 记录控制面/数据面凭证读取、Arcade 收敛错误文本、AWS WorkSpaces 用会话回放做审计证据——「谁读了凭证」正在与「谁能拿 token」并列为一级事件。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| AWS AgentCore Identity | 有动态（间接） | WorkSpaces OIDC/OBO（11-16）、agentic 开户短时凭证（11-17）；Identity 服务无发版 | A（公告）/ B（机制） |
| Microsoft Entra Agent ID | 无窗内可核条目 | what's-new 最新 2026-10-23；fundamentals 最新 June 2026 | A（入口日期） |
| Google Agent Identity | 有动态（仅网关条目内） | 11-11（PT，边界）可验证身份 + Agent Registry | A/B |
| Nango auth | 有动态 | #7980（11-11）、#8224（11-13）、v0.72.5/.6（11-16） | A |
| Composio auth | 有动态（连接/错误语义） | 11-17 `blocked` 可解析、429 超时不重试 | A |
| Arcade auth | 有动态（提交级） | 11-17 secret 注入、11-18 错误文本收敛 | A/B |
| Pipedream auth | 无动态 | changelog 最新 2025-10-01 | A（入口）/ D |
| MCP 授权 / CIMD | 有动态（文档 + Registry 密钥） | 11-12 Registry 多 proof 校验、11-17 ext-auth Stable | A |
| IETF OAuth agent 草案 | 有动态 | 11-15~11-17 共 10+ 份修订 | A（草案文本） |

### 深拆条目

**IETF：从「撤销 token」到「关闭授权谱系」（A）**

窗内草案群的核心问题是「不可信之后，怎么证明已经不可信」。authority epoch 的思路是给一条委托链一个单调递增的纪元号，撤销即推进纪元，任何持有旧纪元的凭证自动失效——不必逐个 token 枚举；revocation closure 则要求撤销一个授权时，把它派生出的子授权一并关闭。DNS 绑定的思路是把 agent 名与其 OAuth client 通过 DNS 记录关联，让跨组织校验不必先建联邦。这三条都还停在草案，**本周不能写成产品能力**，但它们定义了下半年企业身份集成要问的问题。

**Nango：请求体绑定 + 资源四元组（A）**

installation token 的 `body_sha256` 让 token 只能用于它被签发时对应的那个请求体，重放到另一个请求会被拒；5 分钟寿命 + 15 分钟时钟偏移容忍，把「时钟同步」变成自托管的硬依赖。task capability token 把 runner 的权限限制在 environment/connection/sync/task 四元组上，且凭证检查发生在 body 解析之前（`mountPersistAuth`），避免「先解析再鉴权」的解析器攻击面。反例是 `Drop pkce for teamviewer`——单个 provider 去掉 PKCE 属姿态回退，需核实上游约束。

**AWS：OBO 把「给 agent 授权」变成「agent 借人的授权」（A）**

WorkSpaces for AI agents 支持任意 OIDC IdP、管理员可把登录直接路由到企业 IdP、OBO 登录让 agent 以登录用户身份行动并继承其目录身份、权限与桌面组策略。审计面靠 session replay（截图转视频 + 自然语言 transcript，存客户自有 S3、客户自有密钥）。风险同样明确：agent 拿到的是人的全部桌面权限，属于**权限放大**，必须用录像与 S3 侧密钥做补偿控制。同周 11-17 的 agentic 账号注册让 coding harness 直接完成 AWS 开户并拿到自动刷新的短期凭证——把「人把长期 access key 粘进 agent 配置」这条最常见泄漏路径去掉，但把风险转到「谁能触发注册、绑定哪个身份」。

**Entra Agent ID：本周无新版，但拓扑约束值得提前决定（A，背景机制）**

现行能力（无窗内日期）：本地 agent 作为 OAuth public client（authorization code + PKCE、可用 CIMD URL 作 `client_id`）；blueprint 支持单实例/多实例两种拓扑，`isSingleInstance` **不可变**——单实例让同一 agent 跨租户共用 client ID（便于识别），多实例让每个 Agent ID 独立 client ID（便于 fleet 隔离与单独吊销）。Conditional Access 提供自治 agent 与 OBO agent 两类模板。迁移前必须先定拓扑，因为事后改不了。

### 模块洞察

1. **身份层的下一个问题是「撤销的传播」。** 发身份已经产品化（Agent ID、workload identity、CIMD），难的是「撤销一个用户/一条委托后，派生出来的 agent 凭证多久失效」。IETF 草案与 Nango 的短时 token 是两种解法：一个是语义层的谱系，一个是工程层的短寿命。
2. **审计正在从「日志」变成「证据」。** 会话录像 + 自有密钥 + 自有桶，使 agent 行为可以作为合规证据保存；这与 AgentCore Memory 10 年保留是同一条思路的两个落点（行为证据 vs 内容记录）。
3. **「接入面扩张 ≠ 身份模型升级」。** 本周 AWS/Google 的动作都在接入面（OIDC、OBO、注册表），真正的模型变化（CIMD、blueprint 拓扑）发生在文档里而非发布公告里。评估供应商时应要求对方画出「身份对象图」，而不是看支持几个 IdP。

---

## 6. Context / Memory / Knowledge 记忆与知识层

### 本周模块结论

1. **竞争点从「召回质量」移到「多主机部署 + 写入一致性 + 连接器面」。** OpenViking v0.5.5 用 pgvector + PostgreSQL PathLock + 可插拔 coordination 去掉多主机部署对 Redis 的硬依赖；Cognee 一周三版把 Slack/Dropbox/Vercel/Telegram/Evernote 收进 connectors 包，并把 embedding 搬到 RabbitMQ worker；Graphiti 用 change set + lease/fence 给「同一张图并发摄取」加乐观并发控制。
2. **上下文供给链被产品化成「数据索引 + provider 路由」。** Firecrawl 一周四条：MCP v3 把 3,000+ 工具做成一次连接、失败自动换 provider 的 waterfall；Alexandria 覆盖 75M+ 公司；UltraSearch 把 250M 人/75M 公司/150K 股票塞进搜索结果；Firecrawl Local 用 Rust 把抓取压到 11 MB 常驻内存。
3. **项目生命周期出现分叉，版本入口本身不可靠。** Letta 主仓 `letta-ai/letta` 最新 release 仍是 0.16.8（2026-05-14）、最后提交 10-18，但 `letta-code` 窗内 7 个版本、`letta-agent-sdk` 7 个版本——维护资源已转向新产品线，不是「停更」。
4. **默认值变更正在改变安全边界。** OpenViking Gateway 把 `disabled_tools` 默认改为空，8 个写工具（remember/write/edit/add_resource/add_skill/forget/set_acl/cancel_watch）默认开放；`PUT /admin/policies/{id}` 是全量替换，漏传字段会把写工具全部打开。
5. **Crawl4AI 连续第五周无版本**（最新 v0.9.5，10-14），在 Firecrawl Local 主打本地抓取的同一周，其「开源本地抓取」定位被正面竞争。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| OpenViking | 有动态（核心 1 版 + 预览线） | v0.5.5（11-13）、SuperAgent 0.5.4-preview（11-17） | A |
| Mem0 | 无版本；有代码与方法论 | release 仍 2026-09-25；commit #7939（11-18）；博客两篇（11-17） | A/B |
| Cognee | 有动态（3 版） | v1.6.8（11-12/13）、v1.6.9（11-18）、connectors-core 0.2.0（11-13） | A |
| supermemory | 无版本；有代码 | server-v0.0.9（10-12）；Pipecat v5 迁移（11-13）、MCP registry（11-17） | A/B |
| Letta | 主仓静默；子仓高频 | letta 0.16.8（05-14）；letta-code v0.34.59–.65；agent-sdk 0.8.84–.90 | A |
| Zep / Graphiti | Zep 有动态；Graphiti 无 release 有提交 | Zep changelog 11-12/11-13；Graphiti #2154/#2153/#2151（11-15） | A |
| Firecrawl | 有动态（4 条） | MCP v3（11-12）、Alexandria（11-13）、UltraSearch（11-17）、Local（11-18） | A/B |
| Crawl4AI | 无动态 | 最新 v0.9.5（10-14）；窗内仅 docs 提交 | A |

### 深拆条目

**OpenViking v0.5.5：把多主机部署从 Redis 里解出来（A）**

两个关键机制。**路径锁租约**：PathLock 从进程内锁变成数据库行上的租约，租约带持有者与过期时间，多主机靠数据库原子更新竞争；配合 `storage.agfs.coordination`（memory/sqlite/cache）决定 Watch 选主与语义任务版本——版本号单调递增，只有已持久化的任务版本能覆盖旧版本，避免旧 worker 的迟到结果回写。**快照路径索引**：维护 `(path → commit)` 派生索引，不再扫描全部提交历史；升级后首次提交后台回填（每节点各一份 SQLite），多实例必须切 MySQL 并在启动时建表，DSN 缺失则服务拒绝启动。安全侧是本模块最需要复核的一条：`disabled_tools` 默认空、8 个写工具默认开放，`X-OpenViking-Context` 只能收窄不能扩权。

**Cognee：连接器成为产品面，embedding 搬出主进程（A）**

v1.6.8 加完整 Slack 连接器与 `@Cognee` Slack app、基于 RabbitMQ 的 embedding-worker（主服务只写任务消息，worker 消费回写向量，失败可重试、可水平扩），并把 provenance ledger 的写入顺序与删除墓碑理顺。v1.6.9 连接器大扩（Dropbox/Vercel/Telegram/Evernote、`hermes-agent`），**移除旧 Slack history import（breaking）**——Slack 从「历史导入 API」改成 host/adapter 模块，自建 wiring 的团队必须改 import。chunk 正确性靠「只解析一次 + 集中写 chunker identifier」。

**Graphiti：change set + lease + fence（A）**

一个 ingestion unit 先产出 `ChangeSet`（要创建的记录 + 对已存记录的 `PatchNode`/边操作），提交时携带当前 fence；状态存储校验 fence 是否为该 unit 当前值，不是则抛 `StaleCommitError`；unit 超 deadline 或已失败则抛 `UnitExpiredError`；host 可在写入前用 hook 拒绝（`ChangeSetRejected`）。默认 `lease_seconds=60`，要求 `write_margin_seconds < lease/3`（默认 5s）。同时 #2151 删除 Kuzu 驱动（上游项目已归档），可选项收窄为 Neo4j/FalkorDB 等。

**Zep：把「容量不足」从错误改成背压状态（A）**

模型容量暂时不可用时不再让合法 episode 失败，而是延迟处理；等待超 24 小时可见 `wait_status`（`account_rate_limit_reached` / `waiting_for_earlier_episodes` / `processing_delayed`）；超 7 天停止处理并写 `expired_at`；batch 从「固定尝试次数」改为「墙钟 7 天」。v3 API 定于 **2027-04-13** 停止服务。

**Firecrawl：从抓取 API 变成数据路由器（A 日期 / B 数字）**

MCP v3（11-12）在单次工具调用内做多 provider 顺序回退：agent 只发一次「找这个人」，MCP 依次查多个数据源直到命中，把「provider 选择」从推理负担变成网关的确定性逻辑；限流最高 60x、可派生子任务。Firecrawl Local（11-18）用 Rust 重写 scrape/crawl/map，官方口径比 self-hosted 快 37x、内存少 230x（空闲 11 MB），不含云端索引，召回覆盖会下降。

**Letta / Mem0 / supermemory / Crawl4AI：四种「没有版本」的含义（A/B）**

Letta 是仓库级迁移（主仓停、子仓日更）；Mem0 无版本但用博客定义迁移语义——导入必须携带每条消息的原始发送时间、按用户从旧到新、raw 与 extracted 二选一、结构化记录只存「该在对话里提起的字段」；supermemory 无版本但把 `user_id` 变成 namespace、`session_id` 变成文档主键（v5，SDK 0.2.0），并给 MCP Registry 加 `server.json`；Crawl4AI 是真的静默（最新 10-14）。

### 模块洞察

1. **记忆系统的「分布式正确性」成为主战场。** OpenViking 的租约、Graphiti 的 fence、Cognee 的 worker，三家在不同层回答同一个问题：多 worker 并发写同一份记忆时，什么算「写完」、冲突怎么检测、失败怎么重试。选型应要求供应商画出写入状态机（queued/processing/committed/expired/failed），而不是只看召回 benchmark。
2. **连接器数量与数据目录规模正在替代算法成为差异点。** 代价是数据许可、PII 与跨境合规责任随之上移——「供应商替你接数据」意味着供应商也替你承担了一部分合规面。
3. **默认值就是安全策略。** OpenViking 的写工具默认开放、Cognee 删除旧 Slack 导入，都是「升级即行为变化」。运维应把 release notes 里的 breaking / default change 单独拉清单，逐条对照自己的 policy。

---

## 7. Observability / Eval / Guardrails 可观测与治理层

### 本周模块结论

1. **OTel GenAI 在窗口内没有提交，权威版本依然缺失。** 两个语义澄清提交（#721 `gen_ai.tool.definitions` 作用域、#724 抽公共属性组）实际落地时间为 11-19 07:0x CST，**已在窗口之外**，按纪律记背景，不计入本周判断。窗内可确认的只有「仍无 release、文档页仍是 Moved 占位」。
2. **Eval 平台集体转向「agent 工作流」而非「单次打分」。** LangSmith 周档给出 `langsmith investigate` / `verify` 与 MCP 语义检索；Phoenix 把 prompt/dataset 版本与 tag 搬进 CLI；Braintrust 让 LLM-as-judge 走 Decisions API；Langfuse 做 Topics 聚类与 native OTLP。
3. **成本语义向「provider 上报 + 服务档位」收口。** Langfuse 在 v4 系列里连续做 provider usage/cost 归一化；Phoenix 修 $0 价格、负 token 费率与内置价格表；Braintrust 记录 `requested_service_tier` / `served_service_tier`。
4. **护栏供给侧继续收缩。** Guardrails AI 自 2026-08-26 起无提交（最新 v0.11.0，08-14），Hub 已进入退场流程；NeMo Guardrails 本周只有 `fern-docs-snapshot-v0.25.0`（11-18），**无 v0.25.0 代码 release**，CHANGELOG 最新仍是 0.24.1（09-16）。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| OTel GenAI semconv | 无窗内提交（背景：11-19 两个提交） | #721、#724 落地 11-19 07:0x CST | A |
| LangSmith | 有动态（周档） | 「November 9-16, 2026」发布于 11-16 | A（内容）/ D（条目日期） |
| Phoenix | 有动态（4 发布） | v21.1.0（11-13）、v21.2.0（11-18）、otel 3.1.0 / cli 1.23.0（11-17） | A |
| Langfuse | 有动态（4 发布） | v4.79.0（11-12）、v4.80.0（11-13）、v4.81.0（11-16）、v4.82.0（11-17） | A |
| Braintrust | 有动态 | py 0.51.0 / bt 0.32.0（11-17）；11 月产品档 11-18 更新 | A |
| Guardrails AI | 无动态 | 最新 v0.11.0（08-14）；最后提交 08-26 | A |
| NeMo Guardrails | 仅文档快照 | fern-docs-snapshot-v0.25.0（11-18）；CHANGELOG 0.24.1 | A/B |

### 深拆条目

**OTel（背景，非本周）：#721 是语义消歧，#724 是去重（A）**

两个提交的实际落地时间为 11-19 07:0x CST，超出窗口，以下只作机制背景，不构成本周结论。#721 不改变 schema，只写清同一属性名在不同 span 类型上的取值来源（本次请求提供给模型的工具 vs agent 配置的工具清单），这样消费方才能判断「模型没用某工具」是没提供还是提供了没选。#724 把 event 从「引用整个 span 组继承属性」改为引用抽出的 common 组，减少「span 有、event 没有」的漂移。对埋点方：`gen_ai.tool.definitions` 的含义依赖 span 类型，**不能跨类型直接聚合**；做「工具选择准确率」要先按 span 类型分组。

**LangSmith 周档：把失败归因做成命令（A 内容 / D 日期）**

`langsmith investigate` 对一个 project 的失败按 step/error 分组并附证据 trace；`langsmith verify --since <fix time>` 用时间窗对比修复前后失败率——把「人肉翻 trace」固化成 `investigate → fix → verify` 闭环。配套：大 trace 分页加载、trace 树 minimap（turn 边界与错误点）、MCP `ai_search` 语义检索作用于 run/trace/thread、MCP 可创建 dataset 与批量写 example。

**Langfuse：native OTLP 快路径 + AI Gateway 扩到六家（A）**

`native` 是 Rust 写的 OTLP 摄取快路径：不做 document tree，直接解码 typed OTLP envelope；从 ClickHouse schema 派生 owned rows（schema 即契约）；用规则重建 provider 输入输出 payload。效果是 OTLP 落地不经过通用 JSON 文档层，usage/cost/tool calls 归一化在写入前完成。v4.82 归一化 provider usage 与 supplied costs，并把「provider 429 后暂停 LLM 连接而不是调用内重试」作为修复——限流时重试会放大费用。

**Phoenix / Braintrust：版本指针与受约束选择（A）**

Phoenix 的 `px prompt tag` 是**指针语义**：tag 名在 prompt 维度唯一，再次打 tag 即移动指针，所以「production」永远只指一个版本，回滚 = 把 tag 移回旧 version；`phoenix-otel@3.1.0` 对 `OTEL_TRACES_SAMPLER`/`OTEL_BSP_*` 等被 OTel JS 3 忽略的环境变量**每个变量告警一次**——不恢复隐式行为，但把「你设了但被忽略」显式化。Braintrust 的 Decisions API judge 把评分从「生成式解析」改成「受约束选择」：模型返回结构化 choice + 概率分布，置信度低可路由人工复核，消除了「输出格式漂移导致 parse 失败」的评测噪声。

### 模块洞察

1. **观测层的「标准」仍在漂。** OTel GenAI 无 release、文档页是 Moved 占位、属性语义仍无冻结版本，行业此刻用的 `gen_ai.*` 没有权威版本。跨厂商 trace 可移植性本周没有改善，采购时应问「你按哪个 revision 的语义发属性」。
2. **Eval 的价值从「打分」转到「归因与回归」。** investigate/verify、prompt tag、pattern rules、dataset 写入，四家都在把「一次评测」变成「可持续的回归流程」。这意味着 eval 平台的采购标准应包含「能否在 CI 里跑、能否按版本对比」。
3. **护栏开源供给只剩一条主线且也在减速。** Guardrails AI 退场、NeMo 只有文档快照，企业护栏需求正在被平台内置能力（Dify 的 HITL、OpenAI 的 approval、AWS 的 policy plugin）吸收。

---

## 8. Managed Agent Platform / 企业控制面

### 本周模块结论

1. **争夺点从「能不能托管」转到「agent 的出口与身份怎么被外部强制」。** AWS WorkSpaces 给 agent 加 OIDC + OBO 登录与会话录像；Anthropic 把整套 Managed Agents 下沉到客户自有基础设施；Azure 11-17 的 Agent Grid 定位是「identity-based Zero Trust network security to AI agents」——三家都把信任边界从 agent 代码里挪到平台侧。
2. **「按 agent 会话计价的资源」在成形。** AgentCore Memory 保留 1 年 → 10 年（按事件写入时定策略）、全量会话摘要、每月 5,000 次免费 web search；Google 给 agent 工作负载单独的 deferred tier（-50%）；OpenAI 给后台完成窗口 -30%/-40%。记忆、检索、算力三条都被拆成可单独采购/限额的品类。
3. **身份层出现两种对立路线。** AWS 让 coding harness 直接完成 AWS 账号注册并拿到短期凭证（`aws signup`）；Anthropic 的 self-hosted Managed Agents 让模型请求也走客户自选 provider。前者是「把云的 onboarding 交给 agent」，后者是「把 agent 的运行时交还给客户」。
4. **Microsoft 本周信息面最厚但最不可核验。** Foundry 的 Ignite 公告质量很高，但博客时间戳 11-18T17:00Z 落在窗界外 1 小时；Entra what's-new 仍停在 2026-06；Azure Updates 的 HTML 页在本次环境返回「0 Updates found」，但 RSS 通道可读出 11-17 的四条 agent 相关 preview。
5. **可核验性本身成了厂商差异。** AWS/Google/Anthropic 的 release notes 有精确时间戳且可机读；Databricks 只有月档；Azure 详情页依赖 JS 渲染。

### 固定对象状态表

| 对象 | 窗内状态 | 关键锚点（CST） | 证据级 |
|---|---|---|---|
| AWS（AgentCore / WorkSpaces / 账号） | 有动态 | Memory 10 年（11-18 03:22）、会话摘要（11-18 03:17）、免费检索（11-18 02:00）、agentic 开户（11-17 16:00）、WorkSpaces（11-17 02:00） | A |
| Google Cloud | 有动态 | Agent Gateway for GKE（11-12）、deferred tier GA（11-16）、Gemini 4 Hydrogen GA（11-12） | A |
| Microsoft Azure / Foundry | 边缘（窗外 1 小时）+ 部分可核 | Foundry Ignite 五篇（11-19 01:00 CST，窗外）；Azure Updates RSS 四条 preview（11-17） | B/C |
| Anthropic（平台侧） | 有动态 | self-hosted Managed Agents（11-12）、linked billing beta（11-17） | A |
| Databricks | 月档，非日级 | 索引页 2026-10-30 | C |
| 阿里 / 腾讯 / 火山 | 见 §2 | 阿里本周披露历史事项；腾讯工具计费；火山停 202610 | A/C |

### 深拆条目

**AWS：把「记录」和「入口」都做成产品（A）**

AgentCore Memory 的保留策略是**事件级属性**而非资源级开关：设 retention 时写入每个 event 的策略快照，改策略只影响新事件——「延长保留」不会变成「追溯延长/追溯删除」，审计时可按事件时间点举证。全量会话摘要是每个 session 一条长期记忆记录，与 summary chunks 分工（整体 vs 细节），随新事件更新、复用既有检索/权限/删除路径。免费 web search（每组织每月 5,000 次、跨区域跨账号共享、按月重置）把检索从「按量能力」变成「带额度的基础件」，与上期记录的「检索三层计价」形成价格策略的两端。

**Google：网关原生进 GKE，调度按时间卖（A）**

Agent Gateway for GKE 的形态是「东西向 + 南北向」的 agent 流量控制层，落地在集群内，要求 GKE 1.37.2-gke.1042000+，只开 europe-west1 / us-central1。它与上期「跨云 Agent Gateway」是否同一控制面，原文未说明——**标 B，不做合并结论**。deferred tier 对 ADK 用户的直接含义是：同一份 agent 代码可通过 `ServiceTier.DEFERRED` 切换成本结构。

**Anthropic：把运行时交还给客户（A）**

self-hosted Managed Agents 的 API 与 hosted 相同、SDK 与 `ant` CLI 可用，但 agents/sessions/history 全在客户侧，`cma-server` 不执行 shell/文件工具。这使「用不用 Anthropic 的模型」与「用不用 Anthropic 的运行时」解耦，采购谈判从「整体托管」变成「模型 + 可自托管运行时」。

**Azure：RSS 可读、正文不可读的四条 preview（B，主控补充）**

Azure Updates 的 HTML 页在无 JS 环境下返回 0 条，但其 RSS 通道可读出 2026-11-17 的四条 agent 相关 preview：**Agent Grid**（「identity-based Zero Trust network security to AI agents」，集中治理 agent/model/tool/external service 之间的通信）、**Agent Sandbox cluster extension**（在 Kubernetes 上为执行不可信模型生成代码的 agent 提供每会话隔离环境，替团队接管 sandbox 生命周期/存储/预热逻辑）、**Azure SRE Agent 支持 Entra Agent ID 与 Agent 365**（每个 agent 可有自己的 Agent ID）、**Azure SRE Agent 支持 A2A**（agent 间交接任务且各自保留本团队权限）。四条详情页依赖 JS 渲染，**正文未取得**，故只作「有动态（标题级）」，机制留待下期。

### 云厂能力矩阵（截至 2026-11-18，仅列可核验项）

| 能力 | AWS | Google | Microsoft | 阿里云 | 腾讯云 | 火山方舟 |
|---|---|---|---|---|---|---|
| 托管 Agent Runtime | AgentCore V2：基线+4x 突发、10 GB 镜像、warmup hook | Agent Runtime + Deferred tier | Foundry Hosted Agents（resiliency/idle timeout，窗外 1h） | 百炼 Managed Agent | ADP | Managed Agents（公告停 202610） |
| 会话 / 状态 | Memory 10 年保留、全量摘要、Lambda checkpoint | 7 天 interaction 状态、Memory Bank | memory snapshot（preview，窗外） | 沙箱持久化（仅磁盘，1–30 天） | 未取得 | 文档有 Session 归档 |
| 沙箱隔离 | Nitro Sandboxes（上期）、AgentCore 容器 | 容器化 Code Interpreter | VM 隔离 + BYO-AKS pod sandboxing（preview，窗外） | 沙箱文件系统快照 | 「云端沙箱」无日期 | 云沙箱（无窗内条目） |
| 浏览器 / 代码解释器 | AgentCore Browser / Code Interpreter（窗内无条目） | Gemini 4 Hydrogen computer use（模型侧） | Browser Automation（GA，窗外） | 未取得 | 未取得 | 未取得 |
| 工具网关 / MCP | AgentCore Gateway（入站 JWT + 出站凭证） | Agent Gateway for GKE（preview） | Foundry Toolboxes（MCP endpoint，窗外） | 未取得 | 未取得 | 未取得 |
| Agent 身份 | Workload identity + OBO + 开户短时凭证 | Agent Registry 可验证身份（跨云条目） | Entra Agent ID（公开面停 10-23；RSS 提及 Agent 365） | 未取得 | 未取得 | 未取得 |
| 记忆 | AgentCore Memory（10 年 + 摘要） | Memory Bank | Foundry 内记忆（未单列） | Memory（未取得细节） | 未取得 | 记忆（文档有，公告停 10 月） |
| 可观测 | CloudTrail + OverheadLatency + 免费检索 | Cloud Logging / Trace | Azure Monitor + Insights（窗外） | 未取得 | 未取得 | 未取得 |

### 模块洞察

1. **控制面的商品化路径是「记录 + 入口 + 身份」三件套。** 记忆保留卖合规，网关卖流量治理，身份卖权限继承。三者都能单独计价，也都要求客户把 agent 的生命周期交给平台——这是本周期所有云厂动作的共同商业逻辑。
2. **「自托管」并不是同一条路。** Anthropic 让客户自持控制面与状态；AWS/Google 把控制面留在云上、把数据面推进客户集群。采购时先回答「你要自持的是数据、控制面，还是两者都要」，否则会在迁移时才发现锁定点。
3. **可核验性已经是选型指标。** 同周内，能在一小时内完成一次可审计升级的厂商（AWS/Google/Anthropic）与不能的（Azure 详情页、Databricks 月档、MAF 主仓 404）差距明显。建议把「release notes 是否可机读、是否有精确时间戳」写进供应商评估表。

---

## 9. 汇总：对比表、矩阵与判断

### 9.1 必出对比表

| 模块 | 产品/厂商 | 版本或日期 | 变化 | 是否破坏性 | 证据级 |
|---|---|---|---|---|---|
| 1 | OpenClaw | v2026.11.5（11-17） | 会话重启安全（排队消息/发送权限/最终写入跨重启保留）；harness/plugin session control 破坏性改造 | 是 | A |
| 1 | OpenClaw | v2026.10.33（11-18） | gateway-only extended-stable；显示版本与插件兼容身份（11.4 签名基线）解耦 | 否 | A |
| 1 | OpenClaw | v2026.11.4（11-16） | 220 commits；修 Signal 重连丢消息、设置重载丢回复；委托变更审批 | 部分 | A |
| 1 | Anthropic Claude Code | v2.1.323（11-13） | Code Mode（实验）：Claude 写 JS 经 `REPL` 执行；`engines` 插件版本闸 | 否（opt-in） | A |
| 1 | Anthropic Claude Code | v2.1.325（11-14） | 沙箱 Bash 默认走正常权限流；拒沙箱内写 `.claude` 配置 | 是（默认反转） | A |
| 1 | Anthropic Claude Code | v2.1.326 / v2.1.327（11-17/18） | `OTEL_RESOURCE_INCLUDE_HOST`；managed settings checksum；`/status` 暴露被忽略的权限设置 | 否 | A |
| 1 | Claude Agent SDK (TS) | 0.3.326 / 0.3.327（11-17/18） | `mcpServersDelivery: 'initialize'`；hook 选项必须数组；agent 级 `createSdkMcpServer` 弃用 | 是 | A |
| 1 | OpenAI Agents SDK (Py) | 0.24.0-alpha.8（11-16） | 函数调用批准 + 记住 Session；网络规则禁裸 `*`；checkpoint 带预算 | 是（alpha） | A |
| 1 | OpenAI Agents SDK (JS) | 0.22.0-alpha.3（11-17） | 自动工具 catalog 默认并发准入；`session.enqueue()` 拒绝 `ifBusy` | 部分 | A |
| 1 | LangGraph | 1.2.21 / 1.2.22（11-13/14） | 子图流式独立线程；热路径性能优化；checkpoint 4.3.2 | 否 | A |
| 1 | Google ADK | java 1.15.0（11-18）、js 2.5.0（11-13）、py 2.14.1（11-13） | 类型化工作流端口；遥测 v2 span 树；tracing 修复 | 否 | A |
| 1 | Microsoft Agent Framework | PyPI 1.26.0（11-12） | 版本前进但 GitHub 主仓 404，release notes 不可达 | 未知 | B/D |
| 1 | Dify | v1.20.0（11-18） | HITL 2.0（渠道/联系人/模板/表单）、OTLP 导出、恶意文件扫描、PAT；OpenShell Home Snapshots 移除 | 是 | A |
| 1 | CrewAI | 1.15.40 / 1.15.41（11-12/13） | 移除 chromadb embedding 依赖；允许批准的私网 URL host | 部分 | A |
| 1 | pydantic-ai | 2.70.0（11-18） | 修两个 high ReDoS（ANSI 剥离 / JWT 脱敏）；`StreamGuardrail`、`SpendLimits` | 是（安全修复） | A |
| 2 | AWS AgentCore Runtime | 11 月档（月级） | resource configuration（基线 + 4x 突发）、10 GB 镜像、build warmup hook、扩 9 Region | 否 | B |
| 2 | AWS AgentCore Memory | 11-17 | 短时记忆保留 1 年 → 10 年（事件级固化）；全量会话摘要自动生成 | 否 | A |
| 2 | AWS Lambda | 11-17 / 11-18 | durable functions pause/resume（从最后 checkpoint 续跑）；customer-managed runtimes GA | 否 | A |
| 2 | Google Agent Runtime | 11-16 | Deferred tier GA：五折、24 小时目标、状态保留 7 天、不回退 | 否 | A |
| 2 | Google Agent Gateway | 11-12 | for GKE Preview（GKE ≥1.37.2-gke.1042000，2 区域） | 否（preview） | A |
| 2 | 阿里云百炼 | 事件 11-08（本周披露） | 沙箱持久化：文件系统快照、1–30 天、不保留进程 | 否 | A |
| 2 | 腾讯云 ADP | 11-13 | 天气工具 12-11 下线；文档解析 11-26 起调价 | 是（工具下线） | A |
| 2 | Anthropic Managed Agents | 11-12 | self-hosted 整套服务（Postgres 16+、worker 执行、模型可换 provider） | 否 | A |
| 3 | Modal | 11-12 | Sandbox Events UI；成本归因 SDK；burst 计费博客（0.125 核起步、+16 核突发） | 否 | A |
| 3 | E2B | 2.64.0（11-13） | 可调 vCPU（`maxCpuCount`/`cpuCount`）、OAuth header + `X-Team-ID`、模板分页/删除 | 部分（JSON 输出） | A |
| 3 | browser-use | 1.0.4 / 1.0.5 / 1.0.6（11-13/14/16） | 成本 $0.434→$0.208/任务；内置 judge；默认模型切 BU 4.0（15 倍价） | 是（默认成本） | A |
| 3 | Browserbase | 11-12 | session labels（按 workflow/env/version 过滤） | 否 | A |
| 3 | agent-browser | v0.43.0（11-13） | 修 tab 关闭后命令挂起；空/重复可访问名 snapshot hint | 否 | A |
| 3 | Stagehand | 3.7.4（11-19，窗外） | 稳定版超窗，仅 dev 预发布在窗内 | — | A |
| 4 | MCP | 11-17 | SEP-3392 扩展生命周期 Final：三级目录 + `revision` + 未知 revision 不启用 | 否（规范流程） | A |
| 4 | MCP Registry | 11-12 | 多 proof record 逐一验签；删记录不吊销已签发 token | 否 | A |
| 4 | MCP TS SDK | 11-18（main，未发版） | `extensions({id,setup(ctx)})` 扩展 API | 否（未发版） | A |
| 4 | Composio | core 0.30.0 / py 0.33.0（11-17） | schema 有损归约（Gemini/Vertex）；结构化错误信封；`customToolkits` 转正 | 部分 | A |
| 4 | Arcade | 11-13/17/18（无发版） | 仓库迁至 `arcade-mcp`；worker 多 secret；错误文本收敛 | 否 | A/B |
| 4 | Nango | v0.72.5 / v0.72.6（11-16） | actions→tools；installation token（body 绑定）；凭证读取审计 | 部分 | A |
| 4 | A2A | 窗内仅 docs | 无协议/产品变更；v1.1.0-rc 仍在 10-29 | — | A |
| 5 | AWS AgentCore Identity | 11-16 / 11-17 | WorkSpaces OIDC + OBO；agentic 账号注册（短期凭证） | 否 | A |
| 5 | Entra Agent ID | 无窗内条目 | what's-new 最新 2026-10-23；blueprint 单/多实例不可变 | — | A |
| 5 | Nango auth | 11-11 / 11-13 合入 | task capability token（四元组）；installation token（5 分钟） | 否 | A |
| 5 | IETF OAuth | 11-15~11-17 | 10+ 份 agent 授权草案（authority epoch / revocation closure / DNS 绑定） | — | A（草案） |
| 6 | OpenViking | v0.5.5（11-13） | pgvector + PostgreSQL PathLock + coordination；8 个写工具默认开放 | 是 | A |
| 6 | Cognee | v1.6.8 / v1.6.9（11-12/18） | 5 个新连接器；RabbitMQ embedding worker；移除旧 Slack 导入 | 是 | A |
| 6 | Graphiti | 11-15（无 release） | 并发摄取 change set + lease/fence；删除 Kuzu 驱动 | 是（Kuzu 用户） | A |
| 6 | Zep | 11-13 | 容量不足改为延迟 + `wait_status`；v3 API 2027-04-13 日落 | 否 | A |
| 6 | Firecrawl | 11-12/13/17/18 | MCP v3 waterfall；Alexandria；UltraSearch；Local（Rust、11 MB） | 否 | A/B |
| 6 | Letta | 主仓 0.16.8（05-14）；子仓日更 | 仓库级迁移到 letta-code / agent-sdk | — | A |
| 7 | OTel GenAI | 11-19 07:0x（窗外，背景） | `gen_ai.tool.definitions` 作用域澄清；common 属性组抽取；无版本 | 否 | A |
| 7 | LangSmith | 周档 11-09~11-16 | `investigate` / `verify`；trace minimap；MCP `ai_search` | 否 | A/D |
| 7 | Langfuse | v4.79–v4.82（11-12~17） | native OTLP 快路径；AI Gateway 扩到六家；usage/cost 归一化 | 部分 | A |
| 7 | Phoenix | v21.1.0 / v21.2.0（11-13/18） | prompt tag（指针语义）；otel 3.1.0 环境变量告警 | 否 | A |
| 7 | Braintrust | 11-17 / 11-18 | Decisions API judge；Translate trace（本地）；Pattern rules | 否 | A |
| 7 | Guardrails AI | 无动态 | 最新 0.11.0（08-14），Hub 退场 | — | A |
| 8 | AWS | 11-17 | agentic 账号注册；WorkSpaces OIDC/OBO + session replay | 否 | A |
| 8 | Azure | 11-17（RSS） | Agent Grid、Agent Sandbox cluster extension、SRE Agent + Entra Agent ID/Agent 365、A2A | 否（preview） | B |
| 8 | Microsoft Foundry | 11-19 01:00 CST（窗外） | resiliency GA、idle timeout、memory snapshots、BYO-AKS | 否 | A（超窗） |
| 8 | Databricks | 月档 | 无日级条目 | — | C |

### 9.2 模块 × 对象信号强度（图 1 数据源）

| 模块 | OpenClaw | 云厂托管平台 | 沙箱/浏览器 | 协议/MCP | 工具网关 | 身份/权限 | 记忆/知识 | 观测/评测 | 国内云 | 开源框架 |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 Harness | 3 | 1 | 0 | 1 | 0 | 1 | 0 | 0 | 2 | 3 |
| 2 Runtime | 3 | 3 | 1 | 0 | 0 | 1 | 2 | 0 | 2 | 1 |
| 3 Sandbox | 1 | 1 | 3 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |
| 4 Protocol | 0 | 2 | 1 | 2 | 3 | 1 | 0 | 0 | 0 | 1 |
| 5 Identity | 1 | 2 | 0 | 2 | 3 | 3 | 0 | 0 | 0 | 1 |
| 6 Memory | 0 | 2 | 1 | 0 | 0 | 0 | 3 | 0 | 0 | 1 |
| 7 Observability | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 3 | 0 | 1 |
| 8 Control plane | 1 | 3 | 2 | 1 | 2 | 3 | 2 | 1 | 1 | 1 |

评分口径：0 = 窗口内无信号；1 = 仅背景或单一非结构性条目；2 = 窗内单一实质更新；3 = 窗内结构性变化（多条目或机制级变更）。**评分为编辑判断**，依据为 §1–§8 各状态表，仅用于横向比较，不是能力评分。

### 9.3 TOP5 及依据

1. **Google Deferred tier GA（11-16）。** 依据：release notes 两条同日 GA 条目；机制文档（排队、五折、24 小时、7 天状态、不支持流式、每轮单独排队、ADK 跨重启丢 interaction ID、无回退）。等级 A。
2. **AWS 把「记录 + 检查点」做成原语（11-17）。** 依据：AgentCore Memory 10 年保留、全量会话摘要、每月 5,000 次免费检索三条 What's New；Lambda durable pause/resume 一条 What's New。等级 A。
3. **状态所有权搬家：Anthropic self-hosted（11-12）+ 阿里百炼沙箱持久化（本周披露）。** 依据：Claude Platform release notes 与 self-hosted 文档（Postgres 16+、worker 分离、模型可换）；百炼应用发布记录与沙箱持久化文档（只存磁盘、不存进程、1–30 天）。等级 A（阿里标「本周新披露的历史事项」）。
4. **Claude Code Code Mode + 默认收紧（11-13/11-14）。** 依据：CHANGELOG 2.1.323/2.1.325/2.1.327 原文 + Code Mode 官方文档（限制清单、分类器看不到运行期值）。等级 A。
5. **OpenClaw 2026.11.5 会话所有权上收 + 10.33 兼容身份解耦（11-17/11-18）。** 依据：release body 的 breaking 条目与 PR #175837；10.33 的 compatibility identity 原文。等级 A。

### 9.4 覆盖表（8 模块固定对象 + OpenClaw 终态）

| 模块 | 对象 | 终端状态 | 说明 |
|---|---|---|---|
| 1 | OpenClaw | **有动态（3 版本）** | 控制层 + runtime 双覆盖；11.5 为破坏性 session control；extended-stable 10.33 为采购推荐线 |
| 1 | Anthropic Claude Code / Agent SDK | 有动态 | CC 4 版、TS SDK 4 版、Py SDK 4 版（无正文） |
| 1 | OpenAI Agents SDK | 有动态 | Py alpha.8、JS 0.22.0 + alpha.3 |
| 1 | LangGraph / LangChain / LangSmith | 有动态 | 性能为主 + LangSmith 周档 |
| 1 | Google ADK | 有动态 | 三语言各 1 版 |
| 1 | Microsoft Agent Framework / SK / AutoGen | **本次未取得（异常）** | 主仓 404；已试 4 入口；PyPI/NuGet/Go 仍在发版 |
| 1 | Databricks Mosaic | 未取得日级 | 月档，标背景 |
| 1 | CrewAI / pydantic-ai / Dify | 有动态 | 三个均有版本 |
| 2 | AWS AgentCore Runtime | 有动态（月级） | resource config、10 GB、warmup、Region |
| 2 | AWS AgentCore Memory | 有动态 | 10 年保留 + 全量摘要 |
| 2 | Google Agent Runtime | 有动态 | Deferred tier GA |
| 2 | Microsoft Foundry Hosted Agents | **窗外 1 小时（背景）** | 不计入本周判断 |
| 2 | 阿里云百炼 | **本周新披露的历史事项** | 沙箱持久化 11-08 |
| 2 | 腾讯云 ADP | 有动态（非本模块） | 工具下线 + 计费 |
| 2 | 火山方舟 / Coze | 无窗内条目 / 未取得 | 公告停 202610；Coze 10 入口不可读 |
| 2 | Anthropic Managed Agents | 有动态 | self-hosted |
| 3 | E2B | 有动态 | 2.64.0 |
| 3 | Modal / Daytona | Modal 有动态；Daytona 无 | burst 博客；Daytona 最新 11-07 |
| 3 | Browserbase / Stagehand | 有动态 / 窗内仅 dev | labels；稳定版窗外 |
| 3 | browser-use / agent-browser | 有动态 | 1.0.3–1.0.6；0.43.0 |
| 3 | OpenAI / Anthropic Computer Use | 无窗内变更 | 已核 changelog |
| 3 | AWS Browser / Code Interpreter | 无发布条目 | 月级 0 条 |
| 4 | MCP 规范 / Registry / SDK | 有动态（无修订） | SEP-3392 Final；TS SDK main |
| 4 | A2A | 无动态 | 仅 docs 提交 |
| 4 | Composio / Arcade / Nango / Pipedream | 前三有动态；Pipedream 无 | Arcade 仓库迁移 |
| 4 | AWS AgentCore Gateway | 有动态 | 免费检索 + 文档机制 |
| 4 | Google Agent Gateway | 有动态 | GKE Preview |
| 4 | Azure API Center / Foundry toolbox | **本次未取得** | 已试 3 入口 |
| 5 | AWS AgentCore Identity | 有动态（间接） | OBO + 开户 |
| 5 | Entra Agent ID | 无窗内条目 | 公开页停 10-23 |
| 5 | Google Agent Identity | 有动态（网关条目内） | 可验证身份 |
| 5 | Arcade / Composio / Nango auth | 三家均有动态 | 见 §5 |
| 5 | IETF OAuth 草案 | 有动态 | 10+ 份修订 |
| 6 | OpenViking | 有动态 | v0.5.5 + SuperAgent preview |
| 6 | Mem0 / supermemory | 无版本、有代码 | 迁移方法论 / v5 namespace |
| 6 | Cognee / Zep / Graphiti | 有动态 | 三版 / 背压 / fence |
| 6 | Letta | 主仓静默、子仓活跃 | 仓库级迁移 |
| 6 | Firecrawl / Crawl4AI | 有动态 / 无动态 | 四条 / 第五周静默 |
| 7 | OTel GenAI | 无窗内提交（背景：11-19 两个提交） | 2 提交，无版本 |
| 7 | LangSmith / Phoenix / Langfuse / Braintrust | 有动态 | 周档 / 4 版 / 4 版 / 2 版 |
| 7 | Guardrails AI / NeMo | 无动态 / 仅文档快照 | 退场中 / 无代码版本 |
| 8 | AWS / Google / Microsoft / Anthropic | 有动态 | 见 §8；Microsoft 主证据超窗 |
| 8 | 阿里 / 腾讯 / 火山 / Databricks | 见模块 2 / 月档 | 公开面缺口 |

### 9.5 名单外发现（discovery layer）

四组共记录 45+ 条线索，进入正文的 6 条：Azure 11-17 四条 preview（主控补充）、IETF OAuth 草案群（C 组纳入）、Modal burst 博客（B 组纳入）。

- **A 组**：Gateway 插件生态的可观测性项目、harness 性能基准仓、Agent Skills 生态；判断「release notes 可机读性」应进能力矩阵。
- **B 组**：OpenMausBot（每 bot 一台机器）、Pomerado（任意网站 → MCP）、AWS Emulator（CI 无账号跑云 API）、United Airlines 禁 agent 代订；结论「本周没有新的沙箱厂商」。
- **C 组**：Coral v1.8.0（Secret Store 接 provider 凭证）、Obot v0.28.1（静态凭证优先于 CIMD 的反例）、LF Agent Name Service（11-10，窗外）、IETF 草案群；15 行线索表。
- **D 组**：Letta 子仓、supermemory MCP registry、Cognee Vercel connector、NeMo 文档快照、Firecrawl Local；16 条。

未纳入理由集中在两类：无法确认窗内首发（多为 10 月底/11 月初），或仅 README/标题级、机制不可核。

### 9.6 覆盖与局限

1. **WebSearch 在本环境返回 403**（Volcano Ark 未开通），全部取证改用一手 URL 直取 + GitHub `releases.atom` + RSS。因此可能漏掉没有稳定入口的公告，国内云最明显。
2. **Microsoft 主证据超窗 1 小时**：Foundry Ignite 五篇博客时间戳 2026-11-18T17:00Z = 11-19 01:00 CST。本期只作背景；Azure 11-17 四条来自 RSS 标题与摘要，正文未取得。
3. **国内云公开面**：阿里两条属「本周新披露的历史事项」（事件 11-08/11-11，披露 ≥11-12，具体时刻未取得）；腾讯仅有工具/计费公告；火山产品公告停 202610；Coze 十个入口均不可读（首页、/open/docs、/docs、/store、docs.coze.cn 等）。
4. **日期精度**：AgentCore Runtime 四项、Databricks、LangSmith 为月档/周档；文中已逐处标注。
5. **未取得清单**（均列 ≥2 个已试入口）：Microsoft Agent Framework release notes（4 入口 404）、Azure API Center/Foundry toolbox（3 入口）、Azure Updates 详情正文（JS 渲染）、Coze（10 入口）、Databricks 日级（月档）、Google Agent Gateway 详细文档（2 入口 404）。
6. **单一来源风险**：Google Deferred 边界、AWS Memory 保留语义均为官方文档单源，未取得第三方复核；阿里沙箱持久化仅官方文档。

### 9.7 来源总表

- **OpenClaw**：https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases/2026.11.4 ；PR #175837
- **Anthropic**：https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md ；https://code.claude.com/docs/en/code-mode ；https://platform.claude.com/docs/en/release-notes/overview ；https://platform.claude.com/docs/en/managed-agents/self-hosted
- **OpenAI**：https://github.com/openai/openai-agents-python/releases ；https://github.com/openai/openai-agents-js/releases ；https://developers.openai.com/api/docs/changelog
- **Google**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/efficiency/autonomous-scheduling.md.txt ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/deferred-tier
- **AWS**：https://aws.amazon.com/about-aws/whats-new/recent/feed/ ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ；https://aws.amazon.com/about-aws/whats-new/2026/11/amazon-bedrock-agentcore-memory-10-year-retention ；https://aws.amazon.com/about-aws/whats-new/2026/11/amazon-bedrock-agentcore-memory-full-session-summaries ；https://aws.amazon.com/about-aws/whats-new/2026/11/agentic-account-creation/ ；https://aws.amazon.com/about-aws/whats-new/2026/11/amazon-workspaces-AI-agents-connect-govern ；https://aws.amazon.com/about-aws/whats-new/2026/11/lambda-durable-pause-delete/ ；https://aws.amazon.com/about-aws/whats-new/2026/11/bedrock-agentcore-free-web-search-queries/
- **Microsoft**：https://devblogs.microsoft.com/foundry/feed/ ；https://learn.microsoft.com/azure/foundry/agents/concepts/long-running-agent-resilience ；https://learn.microsoft.com/azure/foundry/agents/how-to/use-hosted-agent-memory-snapshots ；https://www.microsoft.com/releasecommunications/api/v2/azure/rss ；https://learn.microsoft.com/en-us/entra/agent-id/whats-new-agent-id
- **MCP / A2A**：https://blog.modelcontextprotocol.io/posts/mcp-release-cycle/ ；https://modelcontextprotocol.io/seps/3392-extension-lifecycle ；https://modelcontextprotocol.io/extensions/overview.md ；https://github.com/modelcontextprotocol/registry/releases ；https://github.com/a2aproject/A2A/releases
- **框架**：https://github.com/langchain-ai/langgraph/releases ；https://github.com/google/adk-python/releases ；https://github.com/google/adk-java/releases ；https://github.com/google/adk-js/releases ；https://github.com/langgenius/dify/releases/tag/1.20.0 ；https://github.com/crewAIInc/crewAI/releases ；https://github.com/pydantic/pydantic-ai/releases
- **工具网关 / 身份**：https://docs.composio.dev/changelog ；https://github.com/NangoHQ/nango/releases ；https://github.com/ArcadeAI/arcade-mcp/commits/main ；https://datatracker.ietf.org/
- **沙箱 / 浏览器**：https://modal.com/blog/sandbox-bursting ；https://github.com/e2b-dev/E2B/releases ；https://github.com/browser-use/browser-use/releases ；https://www.browserbase.com/changelog ；https://github.com/vercel-labs/agent-browser/releases ；https://www.daytona.io/changelog
- **记忆 / 观测**：https://github.com/volcengine/OpenViking/releases ；https://github.com/topoteretes/cognee/releases ；https://github.com/getzep/graphiti ；https://help.getzep.com/changelog ；https://www.firecrawl.dev/changelog ；https://github.com/open-telemetry/semantic-conventions-genai ；https://docs.langchain.com/langsmith/changelog ；https://github.com/langfuse/langfuse/releases ；https://github.com/Arize-ai/phoenix/releases
- **国内云**：https://help.aliyun.com/zh/model-studio/application-release-notes ；https://help.aliyun.com/zh/model-studio/managed-agents-session-operations ；https://cloud.tencent.com/announce ；https://www.volcengine.com/docs/82379/1159177

