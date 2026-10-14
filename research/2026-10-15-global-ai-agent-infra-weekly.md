<!-- PRIVATE_INTERNAL: 本行及其后同类标记为内部协作信息（run 标识 / 分片映射 / 写入权交接），禁传文章。 -->
<!-- AUDIT_METADATA: 取证过程、工具、provider、失败记录、质量计数仅留资料库；对外正文只保留必要局限说明。 -->

# 全球 AI Agent 基础设施研究周报 · 第 17 期：控制层运维化、记忆网关化、工具会话化（2026-10-08 ~ 2026-10-14）

- 报道事件窗口：2026-10-08 00:00:00 ~ 2026-10-14 24:00:00（Asia/Shanghai，不含 10-15）
- 信息采用截止：2026-10-14 24:00 +0800
- 取证时间：2026-10-15
- 资料性质声明：本报告为**文献取证**成果，**未做任何实测或复现**。所有产品能力、性能数据与计费主张，均按其公开发布记录（官方 release notes / release body / 公告 / 章程）或具名披露如实转述，并保留原始限定条件（窗口归属、日期粒度、是否为官方自述、是否独立核实）。

<!-- PUBLIC_CONTENT: 自本行起至「来源清单」之前的全部正文，均为进入文章基线的公开内容（含本期总览、模块 1—8 正文、云厂能力矩阵、TOP 5、OpenClaw 战略参照、热度补漏摘要、价值链传导）。 -->
<!-- EVIDENCE_ONLY: 「来源清单」可整体进入公开来源附录。 -->
<!-- PRIVATE_INTERNAL: 「局限、未取得与隔离项」中含取证过程与工具细节的子块仅留资料库，对外只保留证据边界说明。 -->

## 本期总览（跨模块判断）

1. **本周真正的主线，是「Harness 生产治理四件套」被框架层默认内建。** LangGraph（10-12~10-14）、Google ADK v2.12.0（10-13）、Microsoft Agent Framework（10-08 / 10-14）在同一窗口内各自把**工具审批、工具输出闸门、状态回收、部署身份**从应用层下沉为框架能力。对搭生产方案的人意味着：控制层选型标准已从「能不能编排」变成「出事时能不能拦、能不能回收、能不能审计、能不能降级」。证据以官方发布记录为主（A 类），未做实测对比。

2. **记忆层正在从「要装插件的 SDK」变成「可被任意 harness 调用的服务 / 网关」。** 火山引擎 OpenViking `v0.5.0`（10-09）以 Gateway（Beta）形态用「只改 base URL」无侵入接管上下文，并明确以「不破坏 provider prompt cache」为一等设计约束；AWS AgentCore 把记忆做成可结算资源（长期记忆 TTL + 短期记忆按量计费）。对搭方案的人意味着：记忆的采购点从「召回质量」转向「TTL/保留策略、迁移成本、私网信任与计费可预测性」。

3. **工具与权限层是「标准收敛、实现领先」。** MCP / A2A 本周**无新规范版本**（MCP 最新稳定版仍为 2026-07-28；A2A 仅文档级提交），增量落在治理章程与开源实现；Nango / Composio 把价值锚点从「接了多少 API」迁移到「会话级凭据托管与逐工具授权」。对搭方案的人意味着：「会话级授权 + 可撤销 + 凭据不落 agent」应作为工具网关的硬指标，而不是加分项。

4. **谁在向哪段挤压：三方同时抢「Agent 会话边界」。** 云厂从「托管容器」向「状态与治理控制面」上挤（AWS 记忆可结算+私网直连、Databricks 记忆管道 Beta+Unity Gateway、腾讯 ADP 席位制+Agent Portal）；工具集成商从「API 目录」向「会话授权」上挤（Nango agent sessions、Composio `proxyExecute`）；记忆厂商从「库」向「网关」上挤（OpenViking Gateway）。Google 本周走的是错位路线——把资源投在模型与编码代理（Gemini 4 Argon GA、CodeMender 连发），控制面本身窗口内无独立条目。

5. **执行环境层已进入工程硬化期。** 沙箱/浏览器层本周只有 E2B `e2b@2.56.0`（10-13，纯工程硬化）一条可核信号，Browserbase/Stagehand（08-28）、Daytona（06-23）窗口内无发版，能力扩张让位于规模化可靠性。

6. **观测层的主线是「已上生产的 trace 后端企业化/合规化」，且被观测对象扩容。** Langfuse 三天连发三版（10-12/13/14），主题是 FIPS/密码学、gateway key 过期、媒体上传池与**成本口径修正**；Braintrust 新增 Coding agent insights / Trace Cursor sessions，把 coding agent 当一等被观测实体。

> 本期最强信号的一句话概括：**控制层在「运维化」、记忆在「网关化」、工具在「会话化」、沙箱在「硬化」、观测在「合规化」——五条线指向同一个结论：Agent 基础设施的竞争点已从「能力有无」转到「边界与成本可控」。**
## 模块 1：Harness / Agent OS 控制层

### 本周模块结论

1. **最强信号 = 控制层「运维化 / 持久化」下沉。** LangGraph 窗口内密集发版（10-12~10-14），重心从「能跑图」转到部署与状态生命周期：CLI 0.4.34/0.4.35 加入私有 registry 部署（`--image-pull-secret`、按控制面返回的 registry 用户名登录）与部署构建日志保留；`checkpointpostgres==3.2.0` 新增 `prune`；`checkpoint==4.3.0` 修 delta 重放顺序与序列化保留。竞争点从编排 API 转向「可部署、可回收、可审计」。（A｜官方 release body）
2. **HITL 审批与工具闸门被内置为框架一等能力。** Google ADK v2.12.0 引入 `after_tool_callback`（工具输出返回模型前拦截/过滤）、工作流节点 `require_confirmation`、Agent Engine 专用自定义服务账号；Microsoft Agent Framework 加入「工具审批复用」「自动拒绝超时未响应的工具审批」「工具结果 standing guidance」。同一周两条主线的公共词是审批 / 治理 / 合规。（A）
3. **长会话性能成为新卖点。** ADK 宣称长会话首个模型请求耗时降低 40%（**官方 release 自述，B 级、未独立复测**）。
4. **OpenClaw 参照意义。** ADK 的 `after_tool_callback`、MS 的 tool-approval 超时自动拒绝、LangGraph 的 checkpoint `prune`，可分别对应 OpenClaw 的 tool runtime 输出闸门、审批生命周期、cron/session 存储回收三项设计对照（详见「OpenClaw 战略参照」）。

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 本线未直查其仓库；经 OpenViking v0.5.0 说明间接引用 | gh release body | 否（见模块 8） |
| OpenAI Agents SDK / Responses API | 窗口内无 release（最新 v0.23.1 @ 2026-10-02，窗外） | gh api | 否 |
| Anthropic Claude Agent SDK | v0.2.165(10-08)、v0.2.166(10-14)、v0.2.167(10-14) | gh api | 是 |
| LangChain / LangGraph / LangSmith | cli 0.4.34(10-13)、cli 0.4.35(10-14)、sdk 0.4.7、checkpoint 4.3.0(10-12)、checkpointpostgres 3.2.0(10-14) | gh api | 是 |
| Google ADK | v2.12.0（10-13） | gh api | 是 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | agent-framework python-1.21.0(10-08)、dotnet-1.25.0(10-14)；SK python-1.45.0(10-06，窗外)；AutoGen 最新 release 2025-09 | gh api | 是 |
| MCP（SDK 侧） | python-sdk v2.3.0(10-02，窗外) | gh api | 否（协议本体归模块 4） |
| Databricks Mosaic AI Agent Framework | 本次未取得（时间预算）；平台侧逐日条目见模块 8 | — | 否 |

**价值链位置（模块 1）**：LangGraph / ADK / MS Agent Framework / Claude Agent SDK 均处 **运行时/Harness** 层；本周变化集中在把「工具审批、输出过滤、状态回收、部署身份」从应用层下沉到框架层 → 对上层编排与应用集成方的**议价上升**，对模型与算法层无直接传导。
#### 深度笔记

#### LangChain / LangGraph / LangSmith

- **本周动态**：窗口内 LangGraph 以多包并行发布推进「生产部署 + 状态持久化」。`cli==0.4.34`(10-13)、`cli==0.4.35`(10-14) 让 CLI 支持经私有 registry 部署（新增 `--image-pull-secret`，并改为用控制面返回的 registry 用户名登录），同时保留失败部署的构建日志（修复运维盲区）；`sdk==0.4.7`、`checkpoint==4.3.0`(10-12)、`checkpointsqlite==3.1.2`、`checkpointpostgres==3.1.3` 同批发布。checkpoint 4.3.0 修了多项持久化正确性：InMemorySaver delta 历史默认指向最新 checkpoint、store dispatch 前校验 namespace 标签、对象无法重建时保留已序列化数据、恢复中的 exit-mode run 按实际顺序回放 delta 写入、delta 通道按 task path 排序。10-14 `checkpointpostgres==3.2.0` 为 PostgresSaver/AsyncPostgresSaver 新增 `prune`，把「checkpoint 累积膨胀」变成可运维动作。以上均为发布记录层面的 A 类事实；未做实际部署实测。
- **关键数据**：cli 0.4.34 @ 2026-10-13；cli 0.4.35 @ 2026-10-14；checkpoint 4.3.0 @ 2026-10-12；checkpointpostgres 3.2.0 @ 2026-10-14（来源：https://github.com/langchain-ai/langgraph/releases ）。
- **原文链接**：https://github.com/langchain-ai/langgraph/releases/tag/cli%3D%3D0.4.35 ；https://github.com/langchain-ai/langgraph/releases/tag/checkpointpostgres%3D%3D3.2.0
- **影响判断**：LangGraph 正把差异化落在「私域部署 + 状态回收/正确性」而非新编排原语，直接利好已在 K8s/私有 registry 落地的企业客户；对 OpenClaw 而言，其 checkpoint 分层（checkpoint vs sqlite vs postgres 独立发版）与 `prune` 思路可对照 session/cron 状态的保留策略设计。
- **价值链位置**：运行时/Harness（编排 + 部署 + 状态存储），本周向「生产运维」上移，对上层应用集成方议价上升。

#### Microsoft Agent Framework（含 Semantic Kernel / AutoGen 谱系）

- **本周动态**：Microsoft Agent Framework 双语言并行发版——`python-1.21.0`(2026-10-08)、`dotnet-1.25.0`(2026-10-14)。Python 侧新增：tool-result standing guidance（工具结果常驻指导语）、暴露重写后的变量展开参数、流式响应全缓冲 Purview 策略评估；`agent-framework-openai` 支持最大 reasoning-effort 选项；新增 alpha 的 Oracle 原生向量存储连接器；隔离 provider 自有 service session 状态（当 agent 作为 tool 被调用时）；Anthropic SDK 升到 1.11；修复同批本地工具在声明式混合批次中的执行、共享文件编辑串行化等。.NET 侧（1.25.0）加入「审批复用注意事项」、Purview 检查补充引用与错误详情、**自动拒绝永不响应的工具审批请求**、A2A 包升到 `1.0.0-preview3`，并对 Cosmos chat 元数据与 partition-key 策略解耦（标记 BREAKING）。另有 `dotnet-1.24.0`(10-07，窗外)。
- **关键数据**：python 1.21.0 @ 2026-10-08；dotnet 1.25.0 @ 2026-10-14；A2A `1.0.0-preview3`（**预览，非 GA**）（来源：https://github.com/microsoft/agent-framework/releases ）。
- **原文链接**：https://github.com/microsoft/agent-framework/releases/tag/python-1.21.0 ；https://github.com/microsoft/agent-framework/releases/tag/dotnet-1.25.0
- **影响判断**：Microsoft 把「合规（Purview）+ 审批生命周期 + A2A 互操作」做成框架默认能力，走「企业治理优先」路线；A2A 仍为 preview，不能写成协议已定稿。Semantic Kernel 本周无窗口内 release（python-1.45.0 @10-06 属窗外背景），AutoGen 已长期未发版（2025-09），显示主线资源已并入 Agent Framework。
#### Google ADK（Agent Development Kit）

- **本周动态**：`v2.12.0`（2026-10-13）聚焦「长会话性能 + 工具/工作流治理 + 部署身份」三条线。性能：长会话中「首个模型请求耗时降低 40%」（**官方 release 自述**）；第一轮 LLM 请求不再导入无用 provider。工具：新增 `after_tool_callback`，可在工具输出返回模型前拦截/过滤（对应 issue #6966）；`ExecuteBashTool` 白名单改为整 shell token 匹配。工作流/HITL：`@node` 与 FunctionNode 支持 `require_confirmation`（执行前人工确认）；`_ToolNode` 支持工具认证请求与凭证续跑；task 模式支持子代理委派与恢复；并修复「已确认工具每次审批只运行一次」（#7434）。部署与身份：`adk deploy` 到 Agent Engine 支持专用自定义服务账号（#2951）；ADK 迁移到 `google-cloud-aiplatform v2.2 (agentplatform)`；新增「不装 GAPIC 栈的轻量 Gemini Enterprise (Agent Platform) SDK」（commit d92735d）；`AgentCardBuilder` 增加 skill 级安全支持。安全面：修复 OAuth2 密钥经 `/run`、`/run_sse`、`/run_live`、dev_server 与会话端点泄露；`adk web` 仅绑定 loopback 时启用内置 agent，非 loopback 返回 403。会话/记忆：Firestore 会话与记忆服务可用化（#7192）、Vertex AI `append_event` 更新 `last_update_time`、SQLite 保留会话、支持 Python 3.15。
- **关键数据**：v2.12.0 @ 2026-10-13；首请求耗时 -40%（官方自述，未独立复测）；Python 3.15 支持（来源：https://github.com/google/adk-python/releases/tag/v2.12.0 ）。
- **原文链接**：https://github.com/google/adk-python/releases/tag/v2.12.0
- **影响判断**：ADK 把「工具输出闸门 + 工作流人工确认 + 部署身份隔离 + 凭证不泄露」一次性内建，明显对齐企业级 Agent 治理诉求；与 Microsoft 的审批/合规线形成同向竞争。A2A 相关修复（tool_call/tool_response 转换、A2A 任务在普通用户回复后续跑）说明 A2A 互操作仍是活跃区但仍在修补期。
- **价值链位置**：运行时/Harness（偏 SDK 与部署）→ 与平台层（Vertex AI / Gemini Enterprise）强绑定，形成「SDK 免费 + 平台计费」的捆绑议价结构。

#### Anthropic Claude Agent SDK（Python）

- **本周动态**：窗口内三次发版：`v0.2.165`（10-08）仅内部变更（内置 Claude CLI 升到 2.1.294）；`v0.2.166`（10-14）为本周实质更新——新增 **hook 专用输出类型**（typed output classes、补齐 hook 输入字段，替代无类型 dict，PR #1331）；新增 `SystemInitData` TypedDict 及 `SystemInitMcpServer`、`SystemInitPlugin`、`SystemInitPluginError`、`FastModeState`/`FastModeDisabledReason` 等嵌套类型（#1332）；修复 `SandboxSettings.ignoreViolations` 类型（由带 `file`/`network` 键的 TypedDict 改为 `dict[str, list[str]]`，与 CLI 实际 schema 一致，#1380）；`v0.2.167`（10-14）仅内置 CLI 升 2.1.300。
- **关键数据**：v0.2.165 @ 2026-10-08；v0.2.166 @ 2026-10-14；v0.2.167 @ 2026-10-14；内置 Claude CLI 2.1.294→2.1.299→2.1.300（来源：https://github.com/anthropics/claude-agent-sdk-python/releases ）。
- **原文链接**：https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.166
- **影响判断**：本周证据均为 SDK 类型化/沙箱配置修正，属开发者体验与安全边界打磨，**未见**远程 MCP 或企业治理新能力的窗口内官方发布；不宜据此写「企业治理升级」。高频率 patch 节奏本身说明 SDK 紧跟 CLI 迭代。

#### OpenAI Agents SDK / Responses API

- **本周状态**：**本周无重大公开动态**。GitHub 最新 release 为 `v0.23.1` 与 `v0.23.0`（均 2026-10-02），在冻结窗口外。Computer Use / Code Interpreter / AgentKit 本周未见可核窗口内官方发布，本次未取得。（来源：https://github.com/openai/openai-agents-python/releases ）
- **影响判断**：在 LangGraph/ADK/MS 三家于窗口内密集发版时，OpenAI Agents SDK 本周静默，短期未形成新增控制层差异化信号；后续以官方 blog/changelog 复核为准。

#### OpenClaw（自有对象；本线只作参照，不深写自身仓库）

- **本周状态**：本线未直接查询其仓库/release（时间预算与职责边界）。间接证据：火山引擎 OpenViking `v0.5.0`（10-09）把 `OpenClaw` 明确列为插件默认行为对象——`contextManagementMode` 默认 `"native"`，需显式设为 `"openviking"` 才由 OpenViking 管理上下文；并新增「OpenClaw 自动上下文注入用户 profile」（#5676）与「OpenClaw/pi experimental 客户端在响应体截断时按失败处理」（#5790）。
- **关键数据**：`contextManagementMode: "native"`（默认）/ `"openviking"`（显式）；#5676、#5790（来源：https://github.com/volcengine/OpenViking/releases/tag/v0.5.0 ）。
- **影响判断**：第三方记忆/上下文厂商正把 OpenClaw 当作一等宿主适配对象，并围绕其默认上下文策略做取舍，说明 OpenClaw 的上下文管理模式已成为生态接口事实标准之一。

#### 模块洞察（模块 1）

控制层竞争已从「编排原语」转向「审批、工具输出闸门、状态回收、部署身份」四类生产治理能力的默认内建；证据不足以判断哪家形成垄断，暂保留观察（多源 A 类发布记录，未做实测对比）。
## 模块 2：Runtime / Session / State 执行层

### 本周模块结论

1. **云厂 runtime 竞争点从「能托管」转向「会话/状态生命周期 + 计费形态」。** AWS AgentCore 十月在 Memory 同批上「长期记忆 TTL」（`recordExpirySpecification` + 新 IAM 权限 `bedrock-agentcore:UpdateMemoryRecordExpirySpecification`）与「短期记忆按量计费」（摄入/检索/存储分开计费，无需配置、自动生效），Gateway 新增私有 CA 信任（VPC Lattice 私网直连、PEM 证书存 S3/Secrets Manager）。这三项都指向「状态保留成本与私网合规」，而非新编排原语。（A｜官方 release notes；**月级条目、无逐日日期**）
2. **国内平台把「席位许可 + Agent Portal + 多智能体协作」作为 runtime 之上的新增值层。** 腾讯云智能体开发平台 ADP 自 2026-10-12 起上线新版订阅套餐——体验版（免费）/ 进阶版（1 个成员 License）/ 企业标准版（20 个成员 License、可按需增购）；成员 License 绑定腾讯云子账户，进阶/企业新增 Agent Portal（统一管理、访问权限、多智能体协作）。元器（Yuanqi）10-08 更新「迁移至 ADP 指引」。（A｜官方公告/官网页）
3. **「长期运行、有状态、可恢复进程」已成云厂明确产品线（多为窗口外背景）。** 微软 Foundry 8 月（背景，非本周）已把 long-running hosted agent 的崩溃恢复、`manage-task-state`、HITL 审批、steer/reconnect 流式文档化为 preview；AgentCore 8 月（背景）推出 Runtime **Instances** compute type（capacity provider、持久会话最长 14 天、支持 GPU、多 agent 共享实例）。本周十月条线在 Memory/Gateway 层继续补「记忆保留 + 私网信任」。
4. **Google Vertex AI Agent Engine：本周窗口内未见可定位的 runtime/session 实质更新。** 仅见 2026-10-12「Agent Platform Workbench 修复 gcloud/gsutil 加载」（非 runtime/会话能力），本次未取得 agent engine 独立更新条目（时间预算）。

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 十月 Memory TTL/按量计费、Gateway 私有 CA（A）；Runtime Instances 属 8 月背景 | 官方 release notes | 是 |
| Google Vertex AI Agent Engine / Managed Agents | 窗口内未定位实质更新（仅 10-12 Workbench 修复） | 官方 release notes | 否 |
| Microsoft Foundry Hosted Agents | 最新 whats-new=2026-08（09-09 更新），窗口内未定位新增量 | learn.microsoft.com | 是（限述） |
| 阿里云百炼 / Model Studio | 更新公告页最近更新 2026-10-09（全妙类），未触及 Agent runtime | 帮助中心页（只读到导航） | 否 |
| 火山方舟 Ark / Coze / Coze Studio | 窗口内未定位 runtime 更新（命中的 ArkClaw/Agent Plan 属窗外） | serper | 否 |
| 腾讯云 ADP / 元器 / CloudBase | ADP 10-12 新版订阅 + Agent Portal；元器 10-08 迁移指引 | 腾讯云公告 2476 / 元器官页 | 是 |
| OpenClaw sessions / cron / Gateway | 本线未直查仓库，无独立证据；经 OpenViking 间接引用 | — | 否 |
| E2B / Modal / Daytona（长时任务侧） | Daytona 最新 release=v0.190.0（06-23），窗口内无发版 | gh api | 否（见模块 3） |

**价值链位置（模块 2）**：AgentCore / Foundry Hosted Agents / Vertex Agent Engine / ADP 均处 **运行时/Harness（托管 runtime）** 层，并向下绑定「状态存储（Memory/Session）」与「身份/网关」子能力；本周变化集中在**记忆保留策略与计费形态、席位与门户治理**，对上层应用集成方议价上升，对模型层无直接传导。
#### 深度笔记

#### AWS Bedrock AgentCore（Runtime + Memory + Gateway）

> 去重说明：本对象的完整取证（十月三条）见「模块 8 · AWS Bedrock AgentCore」；此处仅回填 **runtime / session 与计费形态**的本模块专业分析，不重复罗列细节。

- **本模块视角要点**：① 长期记忆 TTL 使「抽取出的记忆何时过期」从无限保留变为可运营策略；② 短期记忆由「每事件固定费率」改为**按消耗计费**，且摄入（ingestion）、检索（retrieval）、存储（storage）**分开结算**，对短期记忆用量自动生效、无需配置；③ Gateway 目标侧支持**私有 CA 签发**的 TLS 证书（PEM 存 S3/Secrets Manager），可直连 VPC Lattice 私网端点，无需前置中间 ALB。**取证边界**：官方页仅到「October 2026」月级、**未标注具体日**，不能坐实落在 10-08~10-14 内（窗口内可能性高但未坐实）。
- **关键数据**：`recordExpirySpecification`、IAM `bedrock-agentcore:UpdateMemoryRecordExpirySpecification`、短期记忆三断会计费（ingestion/retrieval/storage）（来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ）。
- **影响判断**：AWS 把差异点押在「状态可回收 + 成本随用随计 + 私网直连」，减少客户对「记忆无限膨胀」和「必须加中间件才合规」的顾虑；对已用 VPC/Lattice 的企业客户议价上升。对 OpenClaw 的对照意义：session/记忆的保留与回收策略（TTL/prune）正被云厂产品化，可作为 OpenClaw cron/session 存储治理的参照设计。

#### 腾讯云智能体开发平台 ADP（含元器迁移）

- **本周动态**：腾讯云 2026-10-12 起上线 ADP 新版订阅套餐，按使用阶段重划为**体验版（免费）/ 进阶版（1 个成员 License，面向个人开发者，含 Agent Portal）/ 企业标准版（20 个成员 License 可增购，支持成员协作、资源共享、企业级管理，含 Agent Portal）**。改动核心是**计量方式**：由旧「工作空间数量 + 单空间成员上限」改为**成员 License** 计量，一个 License 绑定一个腾讯云子账户，主账户默认 1 个，未分配的子账户登录受限。进阶/企业新增 **Agent Portal**（智能体统一管理、访问权限配置、多智能体协作）。平台提供 3 个月过渡期，原套餐不再开放新购、存量到期后回落体验版并回收成员 License。同时**元器（Yuanqi）10-08 更新「迁移至 ADP 指引」**，指向腾讯把分散的智能体入口收敛到 ADP。（A｜官方公告与官网页；未做实际平台实测）
- **关键数据**：新版套餐生效日 2026-10-12；企业标准版 20 个成员 License（可增购）；过渡期 3 个月；元器迁移指引更新日 2026-10-08（来源：https://cloud.tencent.com/announce/detail/2476 ；https://yuanqi.tencent.com/cl/adp-guide ）。
- **影响判断**：腾讯把 Agent 平台从「按资源包」推向「按席位」的 SaaS 化治理，Agent Portal/多智能体协作是拉高客单价的抓手；对已多账号企业是迁移成本，对个人开发者是免费体验获客。

#### Microsoft Foundry Hosted Agents（限述）

- **本周动态**：本次**未定位到窗口内（10-08~10-14）新增量**。Foundry「What's new」页最新为 **August 2026**（页面 `ms.date` 2026-09-01、`updated_at` 2026-09-09），devblogs Foundry 关于 Hosted Agents 的汇总文为「July and August 2026」（2026-09-09），两者均属**窗外背景**。背景一句：Foundry 8 月已把 long-running hosted agent 的崩溃恢复、task state 管理、HITL 审批、steer/reconnect 流式输出、BYO registry、私有 skill catalog 等以 **preview** 文档化。
- **关键数据**：Foundry whats-new 最新期 = August 2026（updated 2026-09-09）；Hosted Agents 长任务能力标注 preview（来源：https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry ）。
- **影响判断**：无法就本周 Microsoft Foundry 作增量判断；仅记录其 long-running/HITL/资源目录主线与 AWS「持久会话」同向，属背景参照，本期不进入动态池。

#### 模块洞察（一句话趋势）

**云厂 Agent runtime 正从「托管容器」升级为「可计费、可回收、私网合规的有状态会话服务」——记忆 TTL/按量计费（AWS）与席位+门户治理（腾讯 ADP）是本周两个可核方向，长期运行进程能力多沉淀在窗口外背景。**
## 模块 3：Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论

1. **E2B 窗口内发版 `e2b@2.56.0`（2026-10-13），主攻运行时/传输层而非沙箱能力**：要求 Node.js ≥22.19.0、依赖 `undici@^8`（弃用 undici 7）；**移除 SDK 级 in-flight 请求上限**及 `E2B_API_INFLIGHT_REQUESTS`/`E2B_ENVD_INFLIGHT_REQUESTS`/`E2B_ENVD_RPC_INFLIGHT_REQUESTS` 三个环境变量，并发改由 undici 连接池（`E2B_API_CONNECTIONS`、`E2B_ENVD_RPC_CONNECTIONS`）治理；undici 8 遵循服务端 HTTP/2 `SETTINGS_MAX_CONCURRENT_STREAMS`，连接饱和时开更多连接。（A｜release body 全文已读）
2. **Browserbase / Stagehand 窗口内无 release**：stagehand 两个包最新均停在 2026-08-28（`stagehand-server-v3/v3.7.6`、`@browserbasehq/stagehand@3.7.3`），窗外。→ 本期无重大公开动态。
3. **Daytona 窗口内无 release**：最新为 `v0.190.0`（2026-06-23）。→ 本期无重大公开动态。
4. **Computer Use / Browser 两巨头窗口内无可核增量**：OpenAI 相邻事件为 DevDay 2026-09-29 GPT-6.1 Sol（含 computer use）与 ChatGPT Atlas 浏览器 2026-08-09 停用，均属**窗外背景**；Anthropic 窗口内检索命中为 Usage Policy 更新（约 10-09）与 9 月威胁情报报告，非沙箱/执行面更新。→ 本期不进入动态池。

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| E2B（code interpreter sandbox） | `e2b@2.56.0`(10-13) 传输层/并发改造；`@e2b/python-sdk@2.56.0`、`dockerfile-utils@0.1.1` 同批 | gh api release body | 是 |
| Browserbase / Stagehand | 无窗口内 release（最近 08-28） | gh api | 否 |
| Daytona（cloud workspace/sandbox） | 无窗口内 release（最新 06-23） | gh api | 否 |
| Modal（serverless container/GPU） | 本次未取得窗口内动态（时间预算） | — | 否 |
| OpenAI Computer Use / Browser / Code Interpreter | 窗口内未定位；相邻事件属窗外背景 | serper | 否 |
| Anthropic Computer Use | 窗口内未定位执行面更新（命中为政策/威胁报告） | serper | 否 |
| AWS AgentCore Browser / Code Interpreter | 本次未取得窗口内独立条目 | serper | 否 |
| Azure Browser Automation / Code Interpreter / Playwright | 本次未取得窗口内独立条目；Foundry Code Interpreter 仅见文档（背景） | — | 否 |
| Google Code Execution / Managed Agents sandbox | 本次未取得窗口内独立条目 | — | 否 |

**价值链位置（模块 3）**：E2B / Daytona / Modal / Browserbase 处 **运行时/Harness（隔离执行环境）** 层，为上层 agent 提供「一次运行 = 一个隔离环境」的底座；本周变化在 E2B 的**连接/并发与运行时版本**（工程可靠性），不构成新增值执行能力，属**议价中性偏稳**。

#### 深度笔记

#### E2B（code interpreter sandbox）

- **本周动态**：窗口内（2026-10-13）E2B 发布 `e2b@2.56.0`、`@e2b/python-sdk@2.56.0`，同批 `@e2b/dockerfile-utils@0.1.1`、`@e2b/dockerfile-utils-python@0.1.1`。Release body 显示：① **运行时门槛抬高**——要求 Node.js **22.19.0 或更新**、并**只依赖 `undici@^8`**（明确弃用 undici 7）；另有一条「要求 Node.js 22+（不再支持 Node 20）」。② **并发模型重构**——移除 SDK 层 in-flight 请求上限，并**删除三个相关环境变量**（标 **Breaking**）；并发改由 **undici 连接池**治理，沿用/新增 `E2B_API_CONNECTIONS`、`E2B_ENVD_RPC_CONNECTIONS`；undici 8 会遵循服务端 HTTP/2 `SETTINGS_MAX_CONCURRENT_STREAMS`，单连接饱和时**自动开更多连接**。这是沙箱执行底座的连接可靠性/吞吐治理，而非新增 sandbox 语义（如 GPU、网络策略）。**取证边界**：只读 release body；未做实际并发压测；hot-scan 线索 `@e2b/code-interpreter-python@2.11.0` 本次在 GitHub releases 未复核到（最新 `@e2b/code-interpreter-python@2.9.1` @08-13），标**未独立复核**。
- **关键数据**：`e2b@2.56.0` published_at 2026-10-13T15:02:37Z；Node 门槛 22.19.0+；undici ^8（弃用 7）；移除 3 个 in-flight env（标 Breaking）；连接数 env `E2B_API_CONNECTIONS`/`E2B_ENVD_RPC_CONNECTIONS`（来源：https://github.com/e2b-dev/E2B/releases/tag/e2b%402.56.0 ）。
- **影响判断**：E2B 把竞争点放在「大规模并发下的连接治理」，与其官网「isolated machine for every agent」定位一致——每 agent 一个隔离环境的规模化瓶颈在连接层；对高并发用户是可靠性利好，但 Breaking 变更（env 移除 + Node 门槛）带来强制迁移成本。对 OpenClaw 参照：其 sandbox 执行的并发/连接上限管理可对照「框架级上限 → 连接池自治」的迁移路径。

#### 模块洞察（一句话趋势）

**沙箱/浏览器执行层本周只有 E2B 一条可核信号，且落在「运行时版本与连接池并发治理」而非新执行能力——该层已进入工程硬化期，能力扩张让位于规模化可靠性。**
## 模块 4：Tool Gateway / Protocol / Integration 工具层

### 本周模块结论

1. **工具集成层由「应用数量」转向「权限会话」。** Nango 连续把产品重心从 Connection MCP 迁到 **agent sessions**（scoped session + 元工具），并把 `nango_create_connection`（会话中即时连接）、`nango_proxy`（免凭据代调用）作为默认关闭的元工具；Composio 同期在 session 上新增 `proxyExecute` 与 `session.executeMeta`。两家一致表明：工具网关的价值锚点从「接了多少 API」转向「会话级凭据托管与逐工具授权」。（Nango changelog 2026-10-06；Composio commit #4764/#4842，2026-10-13）
2. **协议本体进入「治理与实现」阶段而非「规范发布」阶段。** MCP 规范仓库本周无新 spec 版本（最新稳定版仍为 2026-07-28），窗口内实质提交为 **Governance WG charter（10-08/10-11）与 Progressive Disclosure WG charter（10-13）**；A2A 仓库本周仅文档级提交（10-12 canonicalization 示例修正）。即：**协议之争已收敛，本周增量在章程、实现与网关，而非协议文本。**
3. **云厂「协议原生网关」是背景而非本周新增。** Google **Agent Gateway**（Envoy/K8s，原生解析 MCP/A2A 报文，SPIFFE 身份 + 工具名 RBAC）属 Google Cloud Next '26（2026-04）发布，本周（10-08 UTC）仅见 Forkast 分析文；未取得本周官方新增动态，按**背景**处理。
4. **开源网关侧 `mcp-gateway-registry` 在窗口内密集修复 auth/虚拟路由/agent card 流转（10-12），并起草 1.33.0 release notes（10-14）**，但 GitHub 最新已发布 release 仍为 **1.32.1（10-06，窗外 2 天）**，1.33.0 截至取证时未在 releases 接口出现。

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP 协议本体 | 无新 spec 版本；治理/披露 WG 章程推进 | modelcontextprotocol/modelcontextprotocol commits（gh api） | 是 |
| MCP SDK（TS/Python） | 无窗口内 release（TS v2.3.1 @10-05；PY v2.3.0 @10-02） | gh api releases | 否（状态表） |
| A2A | 仅文档提交（10-12）；最新 release v1.0.1（05-28，窗外） | a2aproject/A2A commits/releases | 是（限述） |
| Composio | **多 release**：@composio/core@0.24.0、python 0.27.0 等（10-14） | gh api releases + commits | 是 |
| Nango | **v0.71.13（10-14）**；agent sessions + MCP 工具 | gh api releases/compare + changelog | 是 |
| Arcade | 无 release；10-14 MCP Apps/worker 资源示例提交 | gh api commits | 是（限述） |
| mcp-gateway-registry | 1.33.0 起草中（10-14）；已发布仍 1.32.1（10-06） | gh api releases/commits | 是 |
| Google Agent Gateway | 背景（Next '26）；本周仅分析文 | forkast.news 2026-10-08 | 是（背景） |
| AWS AgentCore Gateway | 本次未取得窗口内官方动态（十月私有 CA 见模块 8） | web 检索 | 否 |
| Microsoft Toolbox / MCP endpoint | 本次未取得窗口内官方动态 | web 检索 | 否 |
| Pipedream Connect | 本次未取得窗口内官方动态 | — | 否 |
| Smithery / Zapier MCP 等动态池 | 本次未取得窗口内强信号 | — | 否 |

**价值链位置（模块 4）**：MCP/A2A（标准制定）、Composio/Nango/Arcade（协议与工具 → 集成与交付）、mcp-gateway-registry（网关/身份边界）、Google Agent Gateway（平台与工具链）。本周议价上移发生在**开源集成商**一侧（会话级授权与凭据代管成为新收费/留存点）。
#### 深度笔记

#### MCP 协议本体

- **本周动态**：MCP 规范仓库（`modelcontextprotocol/modelcontextprotocol`）窗口内无新版本 tag，最新稳定 release 仍为 **2026-07-28**。窗口内实质提交为社区治理与文档：`docs(community): add Governance Working Group charter`（2026-10-08, 1e837b3）、其合并（10-11, 4a04acd）、`docs/progressive-disclosure-wg-charter` 合并（2026-10-13, 5ea9960），以及 Inspector 安全教程/TypeScript quickstart `serveStdio` 等文档修正（10-12, 3778656）。技术含义：协议层已从「半年一次大版本」转入**工作组治理**阶段，progressive disclosure（渐进式能力披露）被单独立 WG，说明社区把「工具/上下文按需暴露」当作下一阶段核心议题。
- **关键数据**：本周 spec 新版本数 = **0**；窗口内 commits ≥10 条（10-08~10-14）；最新稳定版日期 2026-07-28（来源：https://github.com/modelcontextprotocol/modelcontextprotocol/releases ；commits）。
- **影响判断**：规范文本稳定有利于实现者收敛，但**安全/授权细节仍散落在实现与网关**（见模块 5）；progressive disclosure WG 若产出规范，将直接影响工具网关的上下文注入与权限面。**价值链位置**：协议与工具层（标准制定位）；本周议价能力未见变化，属「标准沉默期」。

#### Composio

- **本周动态**：10-14 集中发版：`@composio/core@0.24.0`、`@composio/slim@0.24.0`、`@composio/openai-agents@0.11.2`、`@composio/langchain@0.11.2`、`@composio/claude-agent-sdk@0.12.2`、`@composio/anthropic@0.11.5`、`@composio/mastra@0.10.6`、`@composio/experimental@0.2.8`；commit #4864「prepare Python 0.27.0 and TypeScript 0.24.0 releases」、#4865「docs: clarify OAuth types in the SDK release changelog」。技术主线是**会话级凭据与工具执行控制**：10-13 为 session 新增 `proxyExecute`（PLEN-4324, #4764，含布尔简写与 live API 测试）与 `session.executeMeta`（#4842），owned clients 升至 `2.0.0-rc.14`；CLI 迁至 Effect 4.0.3（#4833）。文档侧新增「Muse」接入 Composio Connect 并让 SDK MCP 页指向它（#4827, 10-12），以及提示 `backend.composio.dev` MCP URL 首次出现位置（#4828）。
- **关键数据**：窗口内 release 条目 ≥8 个（均 2026-10-14）；核心 SDK 版本 0.24.0（TS）/0.27.0（Python，制备中）。第三方聚合（unified.to 2026-10-08）称 Composio 约有 1600 个 toolkit——**二手来源、未独立核实**，仅作背景（来源：https://github.com/ComposioHQ/composio/releases ）。
- **影响判断**：`proxyExecute`/`executeMeta` 表明 Composio 把「会话 = 一次受控工具执行上下文」作为产品抽象，与 Nango agent sessions 直接竞争同一位置（会话级凭据代理）。**价值链位置**：协议与工具 → 集成与交付；本周通过对多 agent SDK 的同步发版扩大下游覆盖面，议价能力小幅上行。

#### Nango

- **本周动态**：`v0.71.13` 于 **2026-10-14T13:01Z** 发布。`compare v0.71.12...v0.71.13`（10-02→10-14）共 114 commits，窗口内（10-08~10-14）可定位的关键提交：`feat(mcp): list every action in connections MCP tools`(#7853, 10-08)、`fix(oauth2): interpolate connection_config in refresh/token params before refresh`(#7807, 10-08)、`feat(agent-sessions): send session context through MCP server instructions`(NAN-7501, 10-12)、`feat(agent-sessions): discover remote MCP tools when a session is created`(NAN-7426, 10-13) 与 `run remote MCP tools from agent sessions`(NAN-7427, 10-13)、`docs: document MCP server tools in agent sessions`(#7894)、`feat(server): harden the Agent Playground agent against misuse`(#7877, 10-13)、`feat(functions): treat every action as enabled when tools-catalog is on`(#7833)。安全相关：`fix(server): remove open redirect in GitHub App install/OAuth callback`(#7485, 10-09)、`feat(integrations): add opt-in option to skip TLS cert verification`(#7793, 10-09)。官方 changelog 已读：Connection MCP 自 **10-06** 弃用，迁移至 scoped `/docs/guides/agent-sessions`；Management MCP 可用 OAuth 登录（`https://mcp.nango.dev/mcp`），并已进入 Claude connector directory（两者日期 10-06，属**背景/上周**）。
- **关键数据**：发布版本 v0.71.13 @ 2026-10-14T13:01Z（+0800 为 10-14 21:01，窗内）；窗口内 commits 约 20+ 条；支持 API >1,000（changelog，09-14，背景）（来源：https://nango.dev/docs/updates/changelog ；https://github.com/NangoHQ/nango/releases ）。
- **影响判断**：窗口内 Nango 把 MCP 从「连接入口」改写为「agent session 内的远程工具发现+执行」，并在同一 session 内完成凭据注入，等于在开源侧给出**会话级 tool auth 参考实现**；`nango_proxy` 免凭据代调用与 create_connection 即时授权是权限层的关键机制。**价值链位置**：协议与工具 → 集成与交付；开源领先于多数商业网关。
#### Arcade（ArcadeAI/arcade-mcp）

- **本周动态**：**无 GitHub release**。窗口内提交：`feat(examples): show worker-compatible resources and MCP Apps`(#961, 10-14)、`fix(arcade-cli): depend on httpx2 so authlib stops warning on every command`(#968, 10-14)、`fix(arcade-tdk): keep Microsoft Graph error text out of the agent-facing message`(#966, 10-12)、`fix(arcade-core): type pydantic field annotations as Any for pydantic 2.14`(#964, 10-09)、`feat(arcade-cli): explain an MFA refusal and log out instead of failing un-helpfully`(#951, 10-07)。取向清晰：**tool execution 的凭据/错误边界与 MCP Apps**（工具 UI 载体）是本期工程重点，非协议层。
- **关键数据**：窗口内 commits ≥5 条；无 release tag。**取证边界**：其产品版本走官网而非 GitHub release，本次**未读取官网 changelog**，故不能判定「无产品动态」，仅记为仓库层无重大公开动态（来源：https://github.com/ArcadeAI/arcade-mcp/commits ）。
- **影响判断**：Arcade 本周无重大对外发布，动作为打磨 auth 边界与示例。**价值链位置**：协议与工具（tool execution runtime）。

#### agentic-community/mcp-gateway-registry

- **本周动态**：窗口内密集修复 `auth`/虚拟路由/agent card：`fix(registry): repair live auth, virtual routing, and agent card flows`(938161b, 10-12)、`fix(auth): accept a root-endpoint server's bare registered path at /validate`(f6d6891, 10-13)、`fix(egress,registry): report unavailable versions as 503 and guard the nginx render`(b17988a, 10-12)、`fix(registry): include metadata in registration gate payload`(10-13)。10-14 起草并刷新 **1.33.0** release notes（562e2a0/962bca1）。但 `releases` 接口最新仍为 **1.32.1 - Forward-Proxy TLS, an mcp 2.x Pin, and Collector Health**（2026-10-06T07:30Z，窗外 2 天）。
- **关键数据**：已发布最新 1.32.1（10-06，**背景，非本周**）；1.33.0 截至 2026-10-15 06:2x 未出现在 releases 接口（仅 notes 草稿）；窗口内 commits ≥13 条。
- **影响判断**：开源 MCP 网关仍处「auth 流转 + 虚拟服务器（per-server PRM/Entra audience、per-user egress 凭据）」打磨期，尚未到 1.33.0 对外发布节点；**提案≠已生效**，1.33.0 能力不能按已发布陈述。**价值链位置**：协议与工具（网关/身份边界）。

#### A2A（Agent2Agent 协议）

- **本周动态**：仓库 `a2aproject/A2A` 窗口内**无 release**（最新 v1.0.1 @ 2026-05-28，窗外）。窗口内提交仅文档级：`docs(spec): make the 8.4.1 canonicalization example a valid Agent Card`(#2319, 2026-10-12, 7c861a5)；其余为 10-07 的 partners/SDK 列表补充（窗外）。技术含义：本周 A2A 侧动作是**规范示例正确性修正**（canonicalization 示例须是合法 Agent Card），说明生态重心在 Agent Card 与身份绑定细节，而非新协议特性。
- **关键数据**：窗口内 commits 1 条（10-12）；最新 release 日期 2026-05-28（背景）。A2A v1.0 已在 150 家组织投产、归入 Linux Foundation Agentic AI Foundation——**来源为 Google 官方公告口径（经 Forkast 2026-10-08 转述，未独立核实）**。
- **影响判断**：A2A 已过规范密集期，进入「示例/工具链/身份绑定」打磨；本周无对集成方有实际影响的变更。**价值链位置**：协议与工具（跨 Agent 协议）。

#### Google Agent Gateway（Gemini Enterprise Agent Platform）

- **本周动态（背景为主）**：Forkast 2026-10-08 分析文（UTC 06:47，Yahoo 转载标 10-07）详述 Agent Gateway：构建于 **Envoy + Kubernetes Gateway API**，**协议原生**解析 MCP 与 A2A 报文，抽取工具名/模型标识/Agent 身份做**协议层 RBAC**；执行模型为 mTLS 握手中校验 SPIFFE 身份 → deframing filter 解析 MCP 消息 → 提取 method/tool name → 按策略仅放行该身份的已批准工具。配套 Model Armor（提示注入/tool poisoning/数据泄露）、**Agent Identity**（非人主体唯一加密 ID + 可审计轨迹）、Security Command Center 自动发现 Cloud Run/GKE 上未纳管 agent 与 MCP server。⚠️ 该产品首发于 **Google Cloud Next '26（2026-04）**，本周未取得官方新增公告，故列为**背景，非本周**。
- **关键数据**：Agent Gateway 处 **preview**（Forkast 明确「预览、GA 前可能变」）；Google 托管远程 MCP server 已覆盖 BigQuery/Compute Engine/Kubernetes Engine/Security Operations（GA，来源 Google 口径）。
- **影响判断**：Google 把**治理点从网络层上移到协议层**，是本期权限层最清晰的架构信号（可回填云厂矩阵 Gateway/Identity 列）。但**是否为本周增量待核**：本文为二手指引，官方原文（cloud.google.com/blog 与 docs 页）本次未取得窗口内发布日，故不按本周新增主张。**价值链位置**：平台与工具链（云厂协议原生网关）。

#### 模块洞察（模块 4）

**标准化已收敛、云厂以「协议原生网关」收编治理、开源（Nango/Composio）以会话级凭据与 MCP 工具领先实现——本周工具层竞争焦点从「接多少 API」迁移到「在网关/会话内如何逐工具授权与审计」。**
## 模块 5：Identity / Auth / Permission 权限层

### 本周模块结论

1. **本周权限层的实质增量来自「工具集成商」而非云厂。** Nango（agent sessions 的 scoped 凭据 + `nango_create_connection` 即时授权 + `nango_proxy` 免凭据代调用 + OAuth refresh 参数插值修复 + 修掉 GitHub App OAuth 回调开放重定向）与 Composio（session `proxyExecute`、OAuth 类型澄清）在窗口内给出可落地的**逐会话/逐工具授权**能力。（Nango commits 10-08~10-13；Composio commits 10-13/10-14）
2. **三大云厂本周无 Identity 侧官方新品。** AWS AgentCore Identity 最近可见动作为 **2026-09-01 managed consent portal**（背景）；Microsoft Entra Agent ID 官方 what's-new/文档多为 2026-05~08（背景）；Google Agent Identity 随 Agent Gateway 属 Next '26（背景）。**本周窗口内未取得三者官方新发布**，仅按背景记录其权限模型基线。
3. **机制侧共识在使用 OAuth 2.1/OIDC + 请求域身份。** MCP 规范（2026-07-28，背景）将协议会话改写为**请求域身份**，官方另发布 enterprise-managed authorization（组织集中管控 + 单点登录接入 MCP server，2026-06-18，背景）。本周工具层的 session-scoped 令牌正是该模型的商业实现。
4. **审计与撤销已成产品文案标配但取证受限。** Nango 有 `DELETE /sessions/{session_id}` 提前终止并撤销令牌、Logs 的 Agent session 过滤（changelog，09-16 背景）；本周新增 `harden the Agent Playground agent against misuse`（#7877）与 `scope flow disable to the caller's environment`（#7715, 10-08）。**风险**：多数「细粒度权限/审计」主张来自厂商文档，未做独立实测，按 B/C 级处理。

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 本周无官方动态；managed consent portal 为 09-01 背景 | aws what's-new（检索） | 是（背景） |
| Microsoft Entra Agent ID | 本周无官方动态；文档/what's-new 多为 05~08 | learn.microsoft.com（检索） | 是（背景） |
| Google Agent Identity | 随 Agent Gateway 属 Next '26 背景；本周仅分析文 | forkast 10-08 | 是（背景） |
| Arcade Auth / tool permission | 无 release；10-14 MCP Apps、10-12 Graph 错误脱敏、10-07 MFA 拒绝解释 | gh api commits | 是 |
| Composio Auth | 10-14 澄清 SDK OAuth 类型；session `proxyExecute`/`executeMeta` | gh api commits/releases | 是 |
| Nango OAuth / token 管理 | v0.71.13；OAuth refresh 插值、回调开放重定向修复、会话凭据代理 | gh api + changelog | 是 |
| Pipedream Connect | 本周无公开动态；managed auth 3,000+ API（官网口径） | pipedream.com（检索） | 否（状态表） |
| Auth0/WorkOS/Clerk/Descope/Permit.io/Aserto | 本周未见面向 Agent/MCP 工具权限的明确新发布 | 检索 | 否（状态表） |

**价值链位置（模块 5）**：权限能力横跨「协议与工具（OAuth/OIDC 机制、MCP 授权模型）」与「平台与工具链（云厂 Identity）」，本周价值上移到**开源集成商**（token 托管 + 会话级凭据代管 + 可撤销链）。
#### 深度笔记

#### AWS AgentCore Identity（背景）

- **本周动态**：窗口内**未取得官方新发布**。最近可见：`Amazon Bedrock AgentCore Identity now offers a managed consent portal`（what's-new，2026-09-01，**窗外，背景**）——用托管同意页取代自建 OAuth 回调；官方安全博客《Propagate user authorization context in AI agents with AgentCore》（无日期，未判窗口）；Okta 2026-10-02 分析文指出 **AgentCore 会校验入站用户认证，但出站工具调用默认使用 agent 自身 principal**——即「代表用户行动」需显式传播授权上下文。
- **关键数据**：managed consent portal 发布日 2026-09-01（背景）；本次未取得窗口内数字（来源：https://aws.amazon.com/about-aws/whats-new/2026/09/amazon-bedrock-agentcore/ ，**检索得到、未逐篇读全文，标为未独立核实**）。
- **影响判断**：AgentCore Identity 的默认出站 principal = agent 自身，是**越权首要风险点**；其解法（workload access token 绑定 user+agent）与 Google/Entra 的「非人身份」路线收敛。**价值链位置**：平台与工具链（云厂 Identity）。

#### Microsoft Entra Agent ID（背景）

- **本周动态**：窗口内**未取得官方新发布**。可见基线（均背景）：Agent ID 引入面向 AI agent 的身份构造与认证协议（what's-new，2026-05-01）、agent identity 为 Entra ID 中的特殊 service principal、由 **agent identity blueprint** 创建（文档 2026-05-01）；Dataverse 集成文（2026-08-06）。
- **关键数据**：本次未取得窗口内日期/数字；无独立佐证（来源：https://learn.microsoft.com/en-us/entra/agent-id/whats-new-agent-id ）。
- **影响判断**：Entra 用「blueprint 派生 service principal」把 agent 纳入既有 IAM 对象模型，利于企业治理复用，但会给 agent 与人类/应用身份带来混淆风险；**本周无新增可核事实**。**价值链位置**：平台与工具链（云厂 Identity）。

#### Google Agent Identity / Gateway（背景）

- **本周动态**：Agent Identity 为 non-human 主体发放**唯一加密 ID 并形成可审计轨迹**，与 Agent Gateway 的 SPIFFE 身份 + 工具名 RBAC 组合；Security Command Center 自动发现 Cloud Run/GKE 上未纳管的 agent 与 MCP server；跨云发现延伸至 AWS AgentCore、Azure Copilot Studio、Salesforce Agentforce（Wiz 能力扩展）。均属 Next '26（2026-04）发布，本周（10-08 Forkast 分析）为转述。
- **关键数据**：Agent Gateway preview；A2A v1.0 投产 150 家组织（Google 口径）；Triage/Investigation agent 一年处理 >500 万告警、30 分钟人工分析压缩至 60 秒（**厂商口径，未独立核实**）（来源：https://forkast.news/google-cloud-ships-the-first-protocol-native-agent-gateway-and-it-understands-mcp-and-a2a/ ）。
- **影响判断**：把 agent 身份注入 mTLS/SPIFFE 与协议报文解析，是「代表谁行动 + 拿什么权限 + 可审计」三问的一次性工程答案，但**preview 且未 GA**，不宜作为已生效能力引用。**价值链位置**：平台与工具链（云厂 Gateway+Identity，可回填矩阵两列）。
#### Arcade Auth / tool permission

- **本周动态**：无 release。窗口内：`feat(examples): show worker-compatible resources and MCP Apps`(#961, 10-14)、`fix(arcade-tdk): keep Microsoft Graph error text out of the agent-facing message`(#966, 10-12，**把上游错误文本挡在 agent 可见消息之外，降低凭据/内部信息泄露面**)、`fix(arcade-cli): depend on httpx2 so authlib stops warning`(#968, 10-14)、`feat(arcade-cli): explain an MFA refusal and log out instead of failing un-helpfully`(#951, 10-07，**多用户授权失败时的显式登出语义**）。
- **关键数据**：窗口内 commits ≥5；release 0（产品版本走官网，本次未读取其 changelog——取证边界）。
- **影响判断**：Arcade 的权限工程集中在**错误信息边界与授权失败语义**，即「越权/凭据泄露面」的工程收口，符合 tool execution runtime 的定位；**本周无对外新能力发布**。

#### Composio Auth

- **本周动态**：10-14 `docs: clarify OAuth types in the SDK release changelog`(#4865) 与同批 0.24.0/0.27.0 发版，表明 OAuth 凭据类型进入对外 SDK 契约；10-13 session 新增 **`proxyExecute`**（#4764）与 `session.executeMeta`（#4842）——会话级代理执行与元数据执行，是把「用谁的凭据、执行什么工具」下沉到 session 对象的机制。10-13 文档提示 `backend.composio.dev` MCP URL 首次出现处（#4828）。
- **关键数据**：发布条目 ≥8（10-14）；核心 SDK 0.24.0（TS）。
- **影响判断**：Composio 与 Nango 在**会话级授权**上正面竞争；差异在 Composio 更强调 Tool Router/多框架 SDK 覆盖。

#### Nango OAuth / token 管理

- **本周动态**：窗口内 (a) `fix(oauth2): interpolate connection_config in refresh/token params before refresh`(#7807, 10-08)——刷新令牌前把连接级配置插值进 refresh/token 参数，修正多环境/自建 OAuth 场景；(b) **安全**：`fix(server): remove open redirect in GitHub App install/OAuth callback`(#7485, 10-09)——移除 OAuth 回调开放重定向（可被用于诱导回调劫持）；(c) `feat(integrations): add opt-in option to skip TLS cert verification`(#7793, 10-09)（默认关闭）；(d) agent sessions 侧把**远程 MCP 工具在会话创建时发现并在会话内执行**（NAN-7426/7427, 10-13），凭据由 Nango 注入、agent 不接触明文；(e) `harden the Agent Playground agent against misuse`(#7877, 10-13)。
- **关键数据**：v0.71.13 @ 2026-10-14T13:01Z；窗口内 commits 约 20+；支持 API >1,000（背景）。
- **影响判断**：Nango 是本期**权限层最具体的开源进展**：token 托管（OAuth 刷新/插值/回调安全）+ 会话级凭据代理 + 会话撤销构成完整撤销链；开放重定向修复提示**集成层的攻击面在 OAuth 回调而非模型**。

#### Pipedream Connect

- **本周动态**：**本周无重大公开动态**（检索未取得窗口内发布）。近背景：官网称 managed auth 覆盖 3,000+ API，由其托管 OAuth 客户端、令牌存储与自动刷新；Connect 支持 tools/raw proxy/MCP（官网口径，未独立核实）。
- **来源**：https://pipedream.com/docs/connect/managed-auth/quickstart
- **影响判断**：模式与 Nango/Composio 同构（托管 auth + MCP 暴露），本周无增量。

#### 模块洞察（模块 5）

**权限层的「标准（OAuth 2.1/OIDC 请求域身份）已定、云厂仅给 preview 级 Gateway+Identity、真正可用的细粒度授权与撤销实现由开源/集成商（Nango、Composio、Arcade）领先交付——安全短板集中于 OAuth 回调与上游错误/凭据泄露面。**

#### 云厂矩阵回填信号（Gateway / Identity 列）

- **Gateway 列**：Google **Agent Gateway**（Envoy/K8s，MCP+A2A 协议原生，SPIFFE+工具名 RBAC，**preview**）；AWS/Microsoft 本周未取得窗口内 Gateway 新信号（AWS 十月 Gateway 私有 CA 见模块 8）。
- **Identity 列**：Google **Agent Identity**（非人加密 ID + 审计）；AWS **AgentCore Identity**（managed consent portal 09-01；出站默认 agent principal）；Microsoft **Entra Agent ID**（blueprint 派生 service principal）。三者均**背景/预览**，本周无新增。
## 模块 6：Context / Memory / Knowledge 记忆知识层

### 本周模块结论

1. **记忆层本周主线＝「记忆从 SDK 库变成可被任意 harness 调用的服务」。** OpenViking `python-sdk@0.1.15`（10-13）补 `BatchWriteOptions.skip_conflicts`（供 VikingBot Compile finalize）与 `grep(level_limit)`；叠加 10-09 的 `v0.5.0` OpenViking Gateway(Beta)（容器 `openviking-gateway`，默认端口 `1935`，改 base URL 即接入；**平台层完整取证见模块 8**），Context DB 正从「要装插件的库」推到「改 URL 的代理层」。（A）
2. **记忆库本周集体转向存储/可靠性工程，而非功能竞赛。** cognee `v1.6.4`（10-13）修 LanceDB/pgvector 搜索返回整列向量、Turso 打开失败报 `OperationalError`、移除 LanceDB 后台 pruning（破坏性变更）；supermemory `server-v0.0.9`（10-12）随 API v5 发本地版；mem0 窗口内无新 release。（A）
3. **摄取层进入安全加固期。** crawl4ai `v0.9.5`（10-14）是纯安全版本，一次性关闭 6 个协调披露 advisory（SSRF、`css_selector` JS 注入、`CosineStrategy.model_name` 任意 HF 模型加载、ReDoS、无界 delay、Chromium 关证书校验），并给 Docker server 加 opt-in deep crawling。（A）
4. **商业路线判断**：三家（OpenViking/supermemory/cognee）都在「本地/自托管 server + 云托管 API + MCP」三件套上加码，记忆层的分发形态正在从「SDK 依赖」收敛为「server + MCP + 迁移 CLI」，议价点从模型侧转到数据与迁移成本（v5 migrate、backup 校验、namespace）。（B）

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | `python-sdk@0.1.15`(10-13)；`v0.5.0` Gateway Beta(10-09，模块 8 已取证) | gh api releases；REST | 深写(本模块) |
| Mem0 | 窗口内无 release（最新 Python `v2.2.1` 09-25 / TS `v3.3.1` 09-25；docs highlights 最新 2026-08-24） | gh api releases；docs.mem0.ai/changelog | 简写 |
| Cognee | `v1.6.4`(10-13) + `v1.6.4.dev0`(10-13) | gh api releases | 深写 |
| supermemory | `server-v0.0.9`(10-12)；API v5(10-07，窗外) | gh api releases；官方 changelog | 深写 |
| Letta | 窗口内无 release（最新 `0.16.8` 05-14）；repo pushed 09-10 | gh api releases | 简写 |
| Zep / Graphiti | 窗口内无 release（最新 `v0.30.2` 09-08；repo pushed 10-14） | gh api releases | 简写 |
| Firecrawl | 窗口内无 release（最新 `v2.11.0` 06-19；repo pushed 10-14） | gh api releases | 简写 |
| Crawl4AI | `v0.9.5`(10-14) security release | gh api releases；CHANGELOG.md | 深写 |

**价值链位置（模块 6）**：记忆/知识处「运行时/Harness 之下的数据层」与「平台与工具链（记忆 API/网关）」；本周分发形态从「SDK 依赖」转向「server + MCP + 迁移 CLI」，议价从模型侧转到**数据与迁移成本**。
#### 深度笔记

#### OpenViking（Context Database for AI Agents）

> 去重说明：`v0.5.0` 的 Gateway（Beta）完整取证归「模块 8 · 火山引擎 OpenViking」；此处只写 Context/Memory 视角的复用与 SDK 小版本。

- **本周动态**：窗口内两条版本记录。① `python-sdk@0.1.15`（2026-10-13T08:02:46Z，GitHub release），说明仅一行：「Adds `BatchWriteOptions.skip_conflicts` (required by VikingBot Compile finalize) and `grep(level_limit)`」——即写入侧新增「跳过冲突」批写选项、文件系统检索 `grep` 新增 `level_limit` 参数，前者被上游 VikingBot 的 Compile finalize 流程依赖，属**被下游需求倒逼的 SDK 补齐**（B 级具名披露口径，release body 为仓库自述）。② `v0.5.0`（2026-10-09T15:46:55Z）为平台层大版本。**从记忆层视角复用**：网关把记忆检索改为「每条新用户消息先检索、再附在消息末尾」，并逐字节回放已注入内容以保住 provider prompt cache 与 Claude thinking 签名——这是记忆层首次明确以「不破坏 prompt cache」为一等设计约束。（A/B）
- **关键数据**：stars 39,924 / forks 3,174（gh api 快照，2026-10-15 06:06 +0800，**非周增速**）；`python-sdk@0.1.15` 发布 2026-10-13T08:02:46Z；`v0.5.0` 发布 2026-10-09T15:46:55Z（均 https://github.com/volcengine/OpenViking/releases ）。
- **影响判断**：SDK 0.1.15 是配套小版本，价值信号在「gateway- session / skip_conflicts / grep 分页」这组接口说明 OpenViking 正被当成**可编程的记忆后端**接入第三方 agent 产品（VikingBot），而非只服务自家控制台。**价值链位置**：平台与工具链（Context DB + Gateway 双形态），本周议价变化＝把记忆的接入成本压到「改 base URL」，对第三方 harness 的替换成本下降。

#### Cognee（v1.6.4 / v1.6.4.dev0）

- **本周动态**：窗口内连发 `v1.6.4.dev0`（2026-10-13T13:07:54Z）与 `v1.6.4`（2026-10-13T15:23:18Z）两条。核心是**向量检索适配器与 Turso 数据库的可靠性修复**：① LanceDB 与 pgvector 适配器在相似度搜索时不再请求返回整列原始向量，只返回元数据与最近邻分数，降低网络/内存负载并避免失败；② Turso 适配器在打开文件失败时统一抛 `OperationalError`，使调用方与 ORM 处理一致；③ **移除 LanceDB 后台自动 pruning**（破坏性变更：依赖自动压缩回收空间的用户须手动 compaction/pruning）；④ 补充向量距离语义与 Turso 共享行为的测试。对照 `v1.6.3`（2026-10-07，窗外，仅背景）——上版主题是 temporal search 边界与检索精度，本周则完全落在存储层。（A）
- **关键数据**：`v1.6.4` 2026-10-13T15:23:18Z、PR #5745；stars 32,293 / forks 3,365（gh api 快照 2026-10-15 06:06 +0800）（来源：https://github.com/topoteretes/cognee/releases ）。
- **影响判断**：cognee 本周没有新能力，只有「减少带宽/内存 + 统一错误语义 + 去掉意外后台任务」，是典型的**生产化阶段补丁**。对自托管用户的直接影响是 LanceDB 部署需自己管 compaction——这类「把隐式便利改成显式运维」的取舍，说明记忆库客户已从 demo 走向有存储成本压力的生产环境。**价值链位置**：运行时/Harness 之下的数据层（记忆+知识图谱）；本周议价变化不明显，属内功。
#### supermemory（server-v0.0.9）

- **本周动态**：`server-v0.0.9`（2026-10-12T18:59:36Z）发布，官方名为「Supermemory Local 0.0.9」。要点：① 新增 Linux amd64/arm64 预构建 Docker 镜像；② 改善 Local 上传、namespace 操作、search scoping 与 CLI 命令；③ 新增 **API v5 支持**（v5 官方公告日期为 2026-10-07，属窗外，仅作背景）；④ 升级前须备份 store、保留原目录与 API key，**localhost 请求现在也要求 key**、`WORKFLOW_ENGINE=direct` 不再支持；迁移前 Local 会校验完整原始备份；清理会移除较旧的重复文档及其源链接；⑤ Native Windows 仍停留在 0.0.8。窗口内另有 `server-v0.0.9-rc.3`（10-12T09:34:13Z）。（A）
- **关键数据**：`server-v0.0.9` 2026-10-12T18:59:36Z（https://github.com/supermemoryai/supermemory/releases ）；API v5 公告「October 7, 2026」（https://supermemory.ai/changelog/supermemory-api-v5/ ，窗外背景，已读全文）；stars 31,228 / forks 2,748（gh api 快照）。v5 定位自述：「Simpler responses, Markdown output, and namespaces」，迁移命令 `npx supermemory migrate`，现有数据留在原地（厂商自披露）。
- **影响判断**：supermemory 把「本地 server」做成与云 API 同版本节奏（v5 落地后一周内发 Local 0.0.9 + 多架构镜像），并用 `npx ... migrate` 把迁移摩擦降到一行命令——**记忆层的竞争点正在从「召回质量」转向「迁移/备份/命名空间治理」**。注意 `localhost 也要求 key` 是安全默认收紧，会对既有本地集成造成 breaking。**价值链位置**：平台与工具链（记忆 API，含 Local/Cloud 双形态）；本周议价变化＝以 namespace + 迁移工具提高留存、抬升切换成本。

#### Crawl4AI（v0.9.5）

- **本周动态**：`v0.9.5`（2026-10-14T10:25:39Z）为**安全发布**，一次关闭 6 个协调披露 advisory，全部围绕 Docker server 处理「非可信请求体」：① 缓存新鲜度检查 `CacheValidator.validate()` 走自有 HTTP 客户端绕过 egress 代理 → 盲 SSRF（CWE-918，medium，GHSA-w4xc-px5p-c32w）；② `css_selector` 被拼进 JS 字符串、`wait_for` 可作页面脚本执行 → 页面 JS 注入（CWE-95，medium，GHSA-qj46-wp7m-rgj8）；③ 非可信体可设 `CosineStrategy.model_name` → 下载并加载任意 HuggingFace 仓库（PyTorch<2.6 时 pickle 权重可执行代码，CWE-502，high，GHSA-f856-7xp9-w3cc）；④ 调用方自定义 regex（`RegexExtractionStrategy.custom`、`RegexChunking.patterns`、schema 内 `"type":"regex"`）诱发 ReDoS 并因 GIL 冻结整个 server（CWE-1333，medium，GHSA-j843-8p47-rhxp）；⑤ `delay_before_return_html`/`mean_delay`/`max_range` 无上限（CWE-770，medium，现封顶 60s）；⑥ 默认启动参数含 `--ignore-certificate-errors` 使 TLS 校验失效（CWE-295，medium）。另加 4 项 hardening（`DomainFilter` 用 `urlparse()` 解析真实 host、webhook header 用 `fullmatch` 等）。功能面仅一个：Docker server 新增 **opt-in deep crawling**（`CRAWL4AI_ALLOW_DEEP_CRAWL=true`，BFS/DFS/BestFirst，页/深预算来自 `config.yml` 的 `limits.max_pages`/`max_depth`，默认关闭），并加入 Crawl4AI Cloud 提示（可用 `CRAWL4AI_NO_CLOUD_NOTICE=1` 关闭）。Docker 非可信体若设上述字段现返回 400。（A）
- **关键数据**：`v0.9.5` 2026-10-14T10:25:39Z（https://github.com/unclecode/crawl4ai/releases ）；stars 85,545 / forks 8,880（gh api 快照）；CHANGELOG.md 直读。
- **影响判断**：一周内第二个连续安全版本（0.9.4 为 09-23）说明 crawl4ai 的 Docker server 已被真实部署在「接受外部 URL / 外部请求体」的位置（否则不会连续出 SSRF/注入）。功能上新增 Cloud 提示＝**开源抓取层开始向上层托管服务导流**。**价值链位置**：集成与交付之上的摄取层（RAG/记忆的数据入口）；本周议价变化＝安全信任成为复用前提，自托管用户被动升级。
#### 其余固定对象（模块 6，无窗口内动态）

- **Mem0 — 本周无重大公开动态**：窗口内无新 release。最近为 Python `v2.2.1`（2026-09-25T17:35:20Z）与 Node/TS `v3.3.1`（2026-09-25T17:36:35Z），均窗外；官方 docs `changelog/highlights` 最新条目停在 2026-08-24（DeepSeek Harness 原生 Cordis 插件，含 `search_memory`/`add_memory` 两工具与 `userId/agentId/runId` 覆盖）。repo `pushed_at` 2026-10-14 仅为仓库活动，不构成版本事实。**取证边界**：未取得窗口内 commit 明细。价值链位置：平台与工具链（记忆 API + 编辑器插件族）。
- **Letta — 本周无重大公开动态**：窗口内无 release；最新 `0.16.8`（2026-05-14），repo `pushed_at` 2026-09-10。本周无公开版本级信号；不做内容推测。
- **Zep / Graphiti — 本周无重大公开动态**：窗口内无 release。graphiti 最新 `v0.30.2`（2026-09-08，FalkorDB 更新）与 `mcp-v1.1.0`（2026-09-01，Neo4j 自定义库修复），repo `pushed_at` 2026-10-14 属仓库活动。背景一句：该组合近期主线是图数据库路由与多租户隔离正确性。
- **Firecrawl — 本周无重大公开动态**：窗口内无 release；最新 `v2.11.0`（2026-06-19，Firecrawl Research Index：3M+ arXiv + 其 GitHub 代码索引，**厂商自披露** arXivQA 召回领先次优 18%）。repo `pushed_at` 2026-10-14 属仓库活动。**取证边界**：未查窗口内 commit/PR。价值链位置：集成与交付之上的摄取层。

#### 模块洞察（模块 6）

记忆/知识层本周没有「更强的记忆算法」，只有「更好接入 + 更可靠/更安全的存储与迁移」——赛道已从能力比拼转入分发与运维：OpenViking 把接入压到一个 base URL、supermemory 把迁移压成一行 `npx`、cognee 与 crawl4ai 发的是存储与安全补丁。

#### Memory/Context 列强信号（供云厂矩阵回填）

- OpenViking：Context DB + Gateway 双形态，会话开头注入 profile/记忆/skill 目录，逐字节回放保 prompt cache。
- supermemory：Local server（多架构镜像）+ API v5（namespace/Markdown 输出）+ `npx supermemory migrate`，本地与云同版本节奏。
- cognee：pgvector/LanceDB/Turso 适配器收敛，LanceDB 自动 pruning 改为手动（破坏性）。
- Crawl4AI：摄取侧安全加固（6 advisory），Docker server opt-in deep crawling。

#### 模块 6 缺口

- Mem0 / Letta / Graphiti / Firecrawl 仅核到 release 与 `pushed_at`，未逐查窗口内 commit/PR（时间预算，可能漏掉未打 tag 的能力变更）。
- Letta 官方 blog/changelog 未单独核验。
- 强观察池（LightRAG、MS GraphRAG、LlamaIndex、LangMem/LangGraph Store、Onyx、Haystack、Jina Reader、Unstructured、Chroma/Qdrant/Milvus/Weaviate）本轮未扫描，无命中即不写。
## 模块 7：Observability / Eval / Guardrails 可观测治理层

### 本周模块结论

1. **本周没有新的观测范式，只有「已经上生产」的加固。** Langfuse 三天连发 v4.57.0/v4.58.0/v4.59.0（10-12/13/14），主题全部落在 trace 批量就绪、媒体上传池、**成本口径修正**、FIPS/密码学与企业化开关；LangSmith SDK 落在 sandbox API 与 JOSE 算法。（A）
2. **观测对象从「LLM 调用」扩展到「编码 agent 会话」。** Braintrust 十月条目新增 *Coding agent insights*（按 user/API key/model/tool/branch 拆 Coding agent 成本）与 *Trace Cursor sessions*，即 eval 平台开始把 coding agent 当一等被观测实体。（B）
3. **治理/合规开始进入 trace 产品。** Langfuse v4.57.0 引入 FIPS 模式（PBKDF2 口令哈希、拒绝以 MD5 计算存储选项）、Cloudflare Turnstile 与 gateway API key 过期；LangSmith 的 freeze guard 与 multipart 回退说明吞吐边界在被处理。（A）
4. **标准层**：OTel GenAI 语义约定已从 opentelemetry.io 主仓**迁移到独立仓库 `semantic-conventions-genai`**，本周无窗口内发布内容（仅记录结构变化）。（A）

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | `langsmith-sdk` v0.14.7(10-09)/v0.14.8(10-13) | gh api releases | 深写 |
| Langfuse | v4.57.0(10-12)/v4.58.0(10-13)/v4.59.0(10-14) | gh api releases | 深写 |
| Helicone | 窗口内无 release（最新 `v2025.08.21-1`，无正文） | gh api releases | 简写 |
| AgentOps | 窗口内无 release（最新 `0.4.21` 2025-08-29） | gh api releases | 简写 |
| Braintrust | 官方 changelog「October 2026」条目（未标具体日） | braintrust.dev/docs/changelog | 深写 |
| Arize Phoenix | `arize-phoenix` v20.21.2(10-13)/v20.21.3/v20.21.4(10-14) | gh api releases | 简写 |
| Coze Loop | 本次未取得（未找到窗口内官方更新） | — | 简写 |
| OTel for Agents | GenAI semconv 迁至 `open-telemetry/semantic-conventions-genai` | opentelemetry.io docs | 简写 |
| AWS/Google/Azure agent obs | 官方文档常青（AgentCore Observability 等），非窗口事件 | docs.aws.amazon.com | 简写 |

**价值链位置（模块 7）**：可观测/评估处「平台与工具链（SaaS + 自托管）」与「协议与工具（OTel 语义约定）」；本周企业合规能力（FIPS、key 过期、Turnstile）成为采购门槛项，被观测对象扩展抬高了 eval 平台的入口价值。
#### 深度笔记

#### Langfuse

- **本周动态**：窗口内三连发。`v4.59.0`（2026-10-14T09:20:36Z）为补丁级汇总：把 TypeSafe 适配器在 picker 中标注为「TypeSafe (System One)」；worker 每区间只轮询一次队列指标；**修正 Claude Sonnet 5.5 的 cache-read 价格**；修复 sessions 中工具响应处理；账号与组织设置合并为单页；移除未用的 ClickHouse 成本与 export heartbeat 行指标；`trace-batching` 改为分片就绪后重处理迟到数据；Topics trace 列表加过滤/搜索。`v4.58.0`（2026-10-13T07:05:09Z）为功能版：密码重置邮件要求 Turnstile；`feat(otel)` 在 TypeScript 解析前提取媒体；`feat(media)` 新增带并发与字节上限的上传池；`feat(worker)` 在 `tracing_readiness_settings` 中支持按项目设置 trace 空闲时间；Topics 可配置在项目自有 LLM 连接上。`v4.57.0`（2026-10-12T17:20:29Z）：FIPS 模式下拒绝以 MD5 计算存储选项、口令用 PBKDF2 哈希；凭证认证恢复可选 Cloudflare Turnstile；**gateway 新增 API key 过期**；evals 度量分数持久化结果；skills 加 CLI 安装指引。（A）
- **关键数据**：`v4.59.0` 2026-10-14T09:20:36Z、`v4.58.0` 2026-10-13T07:05:09Z、`v4.57.0` 2026-10-12T17:20:29Z（https://github.com/langfuse/langfuse/releases ）；stars 35,828 / forks 3,988（gh api 快照）。定价事实：本周仅见「修正 Claude Sonnet 5.5 cache-read 价格」的改动记录，**未取得 Langfuse 自身定价变更**。
- **原文链接**：`gh api repos/langfuse/langfuse/releases`（release body 直读；langfuse.com/changelog 与 /changelog.md **均 404**，未取得落地页）。
- **影响判断**：三天三版且改动集中在批处理就绪、媒体上传上限、成本计价与 FIPS/企业认证——这是**trace 后端在承接大规模 agent 流量**的信号（成本口径错一位就会影响客户账单，故被当补丁单独修）。**价值链位置**：平台与工具链（可观测/评估 SaaS + 自托管）；本周议价变化＝企业合规能力（FIPS、key 过期、Turnstile）成为采购门槛项。

#### LangSmith（langsmith-sdk）

- **本周动态**：`v0.14.8`（2026-10-13T00:42:09Z）含 `fix(py)` 在 `RunTree.patch` 发送 `session_id`；freeze guard 链接不再包含标点；`fix(py)` 使 `/runs/multipart` 404 能回退到 `/runs/batch`（吞吐降级路径可达）；`feat(sandbox)` 接受任意 JOSE 非对称算法。`v0.14.7`（2026-10-09T16:31:51Z）为 `fix`：归一化 sandbox API 端点前缀；同窗口还有 js 侧 `0.10.9` 与 js 冻结（JS SDK 已迁至独立仓库）的 CI 记录。（A）
- **关键数据**：v0.14.7 2026-10-09T16:31:51Z、v0.14.8 2026-10-13T00:42:09Z（https://github.com/langchain-ai/langsmith-sdk/releases ）。
- **影响判断**：LangSmith 本周的可见动作是**沙箱（sandbox）接口与鉴权算法**，加上 JS SDK 迁出、py/JS 分仓冻结——治理面正在把「运行 agent 代码的沙箱」纳入同一 SDK 边界。**价值链位置**：平台与工具链（eval/观测 + sandbox 执行）。

#### Arize Phoenix

- **本周动态**：`arize-phoenix` `v20.21.4`（2026-10-14T16:12:17Z，UI：Escape 保留标签、修复表格排序与 a11y/accessor 警告）、`v20.21.3`（2026-10-14T03:38:44Z，修死链文档）、`v20.21.2`（2026-10-13T16:04:09Z，experiments 在 PostgreSQL 上将重复运行平均延迟强制为 float；graphql 将检索摘要计数归一为 int）。均为维护级补丁。（A）
- **关键数据**：v20.21.2/3/4 发布日期见上（https://github.com/Arize-ai/phoenix/releases ）。
- **影响判断**：三日三补丁、无新功能，属高频维护节奏；开源 trace/eval 工具的自托管用户按补丁跟进即可。**价值链位置**：平台与工具链。
#### Braintrust

- **本周动态**：官方「Product updates」页存在 **October 2026** 条目（页面**未标注具体日期，仅月份**，与本窗口同月但**不能确证落在 10-08~10-14 内**，故按 B 级具名披露并注明口径）。要点：① **Coding agent insights**（public preview）：内置仪表盘按 user、API key、model、tool、branch 展示 coding agent 用量与成本（tool 外均有成本拆分），并有每日 Loop 自动化找出团队会话中的反复问题，需 data plane `v2.13.0+`；② **Patterns 严重度**：为发现项赋 severity 以排序/过滤，可带理由纠正且 Loop 保留纠正，需 `v2.18.0+（self-hosting 尚未发布）`；③ **新 thread view**（preview）：把每轮 trace 拆成 request／agent 所做工作／最终响应，工具调用与请求它的 LLM 调用并列、sub-agent 嵌套，需 `v2.13.0+`；④ **SQL charts**（仅 Pro/Enterprise）；⑤ **PagerDuty 通知**用于 Loop 自动化与 log/时间窗/环境告警，需 `v2.17.0+`；⑥ **Trace Cursor sessions**：`bt trace enable cursor`，需 `bt v0.26.0+`；⑦ `bt` CLI v0.26.0（preprocessors 可不再发布即本地预览真实 trace；环境变量统一 `BRAINTRUST_` 前缀）、v0.25.0（`metadata.turn_span_id` 逐轮归因）、v0.23.0（pi 追踪字段**破坏性重命名**）；Python SDK v0.46.0（span customizer 也作用于 OTel span、新增 OpenAI/LiteLLM Decisions API 与 Google ADK workflow 节点/tool call 追踪）。（B）
- **关键数据**：仅取得「October 2026」月份标签，**具体发布日期本次未取得**；data plane 版本门槛见上（https://www.braintrust.dev/docs/changelog ；文档索引 https://www.braintrust.dev/docs/llms.txt ）。
- **影响判断**：Braintrust 把「coding agent 成本与效率」做成开箱仪表盘，并对 Cursor/Claude Code/Codex/pi 逐一接插件——**eval 平台正在抢 coding agent 的观测入口**，与自有参照相关（可对比其 `session_id`/`turn_span_id` 类字段设计）。**价值链位置**：平台与工具链（观测/eval，含 Loop 自然语言探查）；本周议价变化＝以 coding agent 洞察切入研发预算（成本可见性）。

#### 其余对象（模块 7 简写）

- **Helicone — 本周无重大公开动态**：窗口内无 release，最新 `v2025.08.21-1`（2025-08-21，release body 为空）；未取得窗口内版本级信号。
- **AgentOps — 本周无重大公开动态**：窗口内无 release，最新 `0.4.21`（2025-08-29）；repo 近期记录为 OSS 分发同步（`AgentOps.Next`）。
- **Coze Loop — 本次未取得**：未找到窗口内官方更新页面；时间预算内未逐源核对，标缺口不判无动态。
- **OTel for Agents / tracing 标准**：GenAI 语义约定已从 opentelemetry.io 主站迁移到独立仓库 `open-telemetry/semantic-conventions-genai`（原页面标注「moved and no longer maintained」）；本周无窗口内该仓发布事件取证。价值链位置：协议与工具（跨厂商 trace 语义）。
- **AWS Bedrock AgentCore Observability**：常青官方文档（**非窗口事件**）：agent/gateway/memory 三类内置指标，memory 资源可另开 span/log，全部以 OTEL 兼容格式存入 CloudWatch，agent runtime 另有 CloudWatch 观测仪表盘。取证边界：文档无发布日期，**不能当作本周动态**。价值链位置：平台与工具链（云厂托管观测）。
- **Google / Azure agent observability / evaluation / simulation / guardrails**：本次未取得窗口内官方更新（时间预算）；标缺口。

#### 模块洞察（模块 7）

可观测/评估层本周的主线不是新指标，而是**把已经承载生产的 trace 后端做企业化与合规化（FIPS、key 过期、批处理就绪、成本口径），并把被观测对象从「模型调用」扩到「coding agent 会话」**；标准层则把 GenAI 语义约定固化为独立仓库，跨厂商 trace 语义开始有稳定落点。

#### Observability / Eval 列强信号（供云厂矩阵回填）

- Langfuse：3 日 3 版，FIPS/PBKDF2、gateway key 过期、媒体上传池、按项目 trace 空闲时间、成本计价修正。
- LangSmith：sandbox API 前缀归一、`/runs/multipart`→`/runs/batch` 回退、JOSE 非对称算法、`RunTree.patch` 带 `session_id`。
- Braintrust：Coding agent insights、新 thread view、SQL charts、PagerDuty、Loop on dashboards、`bt` v0.26.0。
- Arize Phoenix：v20.21.2/3/4 维护补丁。

#### 模块 7 缺口

- Braintrust 条目仅有「October 2026」月份标签，**无法确证是否在 10-08~10-14 内**。
- Google Vertex/Azure AI Foundry、Coze Loop 的窗口内官方更新本次未取得。
- Helicone / AgentOps 仅核到 release 端点，未查窗口内 commit/PR。
- langfuse.com/changelog 与 /changelog.md 均 404，未取得落地页正文（仅用 release body）。
## 模块 8：Managed Agent Platform / Enterprise Control Plane

### 本周模块结论

1. **最强信号 = AWS AgentCore 把「记忆生命周期 + 计费粒度 + 私域网关信任」做成平台级控制面能力。** AgentCore Memory 新增长期记忆记录 TTL（通过 `recordExpirySpecification` 配置，需新 IAM 权限 `bedrock-agentcore:UpdateMemoryRecordExpirySpecification`）；短期记忆改为**按消耗计费**（ingestion / retrieval / storage 分别计费，无需配置自动生效）；AgentCore Gateway 新增对**私有 CA 签发 TLS 证书**的 MCP server / OpenAPI / HTTP proxy(passthrough) 目标的支持，可直接对接 VPC Lattice 私有端点，信任锚取自 S3 或 Secrets Manager 中的 PEM CA 证书。**取证边界**：官方 release notes 页按「October 2026」按月归档、未标具体日，是否落在 10-08~10-14 **无法证实** → 按 A 类陈述采用内容，但日期只到月份级，标为「10 月内、精确日未取得」。（A，日期限述）
2. **Google 平台层窗口内有两次可核发布**：10-13 **Gemini 4 Argon** GA（统一 1,048,576-token 输入/输出上限、可配置 thinking 级别 LOW/MEDIUM/HIGH、continuation token 长解码、agentic video understanding GA，另有 Gemini 4 Argon Cyber Permissive 在 Fairwind 计划 allowlist 内 GA）；10-14 CodeMender v0.15.0（SARIF 2.1.0、model invocation metrics）。（A）
3. **火山引擎 OpenViking v0.5.0（10-09）以「网关」形态切入企业控制面**：新增 **OpenViking Gateway（Beta）**——独立进程 `openviking-gateway`（默认端口 1935），位于客户端与模型服务之间，任何可改 base URL 的客户端即可获得 OpenViking 记忆，零插件、零改码/改 prompt；支持 Anthropic Messages / OpenAI Chat Completions / 全历史 OpenAI Responses 三种协议**原协议转发**（不在协议间转换）。（A）
4. **⚠️ 隔离主张**：热度扫描称「Gemini Enterprise Agent Platform release notes 页面出现 deprecated / 2026-08-20 关停提示」。本次已 web_fetch 该页正文（raw 84008 字符），对 `deprecat` / `shutdown` / `retire` 关键词 grep **无命中**，**该主张未获证实，不作结论**。后续由平台矩阵逐一核对官方改名页，判定为**重命名/品牌整合，非关停**（详见矩阵行）。本周确认的真实「退役」语义在 Microsoft Foundry 侧：「Agents (classic) 已 deprecated，2027-03-31 退役」「Foundry 将于 2026-12-01 退役 workflows，改用 Microsoft Agent Framework」——属 8~9 月既有背景，非本周新增。

#### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | Memory TTL + 按量计费；Gateway 私有 CA（均归「October 2026」，精确日未取得） | 官方 release notes（web_fetch） | 是 |
| Google Vertex AI / Gemini Enterprise Agent Platform | Gemini 4 Argon GA(10-13)、CodeMender v0.14.0(10-12)/v0.15.0(10-14) | 官方 release notes（web_fetch） | 是 |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | 窗口内未取得具体新增；classic agents 退役为背景 | 官方页月级归档 | 是（限述） |
| 阿里云百炼 / Model Studio / PAI | 本次未取得窗口内条目（功能更新页最新 8 月）；PAI 未核 | 官方帮助页 | 是（限述） |
| 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking | OpenViking v0.5.0(10-09) Gateway(Beta) | gh release body | 是 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | ADP 10-12 新版订阅+Agent Portal（模块 2 已取证）；GLM-5 系列 10-09 下线（窗口内事件日） | 官方公告 / 官网页 | 是（限述） |
| Databricks Mosaic AI / Agent Bricks | 官方 October 2026 **逐日**条目：Agent memory pipelines Beta(10-12)、Unity Gateway Skills API Beta(10-12)、AI Runtime SDK(10-13) 等 | 官方 release notes（逐日） | 是 |

#### 平台层六列强信号回填（供云厂矩阵拼装）

| 平台 | Runtime | Memory | Gateway | Identity | Sandbox | Observability |
|---|---|---|---|---|---|---|
| AWS AgentCore | Instances 计算类型（8 月，背景）；9 月 Harness 交互式 shell | **TTL `recordExpirySpecification`；短期记忆按量计费**（10 月，日未取得） | **私有 CA TLS 目标支持**（10 月，日未取得） | —（Consent Portal 属 9 月背景） | —（同 microVM 交互式 shell 属 9 月背景） | —（Evaluations TS 框架属 9 月背景） |
| Google Agent Platform | ADK 部署 Agent Engine + 专用自定义服务账号(10-13)；Cloud Run/GKE 部署修复 | Memory Bank（常青，窗口内无独立条目） | Agent Gateway（Cloud Trace 集成属 9-30 背景） | IAM agent identity；ADK 凭证加密入 session、OIDC audience 强制(10-13) | Code Execution；CodeMender v0.14.0(10-12)/v0.15.0(10-14) | Evaluation Service + Example Store（App Topology 9-30 背景） |
| 火山引擎 OpenViking | Helm chart 0.2.0 sidecar / Docker gateway profile | **Working Memory 默认关闭**（#5696/#5686）；检索 quota 补位（#5679） | **OpenViking Gateway(Beta) 端口 1935**（#5625） | 网关 key + context profile 默认只读（#5625） | —（本次未取得） | Studio Requests 页 + OV-Usage 来源卡片 |
| Microsoft Foundry | Hosted Agents（long-running，preview，8 月背景） | 本次未在该页取得窗口内条目 | Toolbox / Foundry MCP Server（背景） | Entra authentication for trace ingestion（preview）；Entra Agent ID（5 月背景） | Code Interpreter（Foundry）；Copilot Studio Computer use（5 月 GA，背景） | cloud evaluation + Agent Monitoring Dashboard（背景） |
| 阿里 / 腾讯 / Databricks | 见矩阵专行（腾讯、Databricks 有窗口内条目；阿里本次未取得） | — | — | — | — | — |
#### 深度笔记

#### AWS Bedrock AgentCore

- **本周动态**：官方 release notes「October 2026」节列三项控制面更新。① **Memory 长期记忆 TTL**：为长期记忆记录加入 time-to-live，控制抽取记录在过期前的保留时长，通过 `recordExpirySpecification` 配置；配置或移除 TTL 需新 IAM 权限 `bedrock-agentcore:UpdateMemoryRecordExpirySpecification`。② **Memory 短期记忆按消耗计费**：由每事件固定费率改为按消耗计费，ingestion、retrieval、storage 分别结算，自动适用于短期记忆、无需配置。③ **Gateway 私有 CA 目标支持**：对 MCP server、OpenAPI、HTTP proxy(passthrough) 目标支持由**私有 CA 签发**的 TLS 证书；默认只信任公有 CA 证书，现可注册私有 CA 证书以直连 VPC Lattice 支撑的私有端点，CA 以 PEM 存于 S3 或 Secrets Manager，网关取回后作为出站 TLS 信任锚（省去前置中间 ALB）。上下文背景（**非本周**）：8 月 AWS Agent Registry GA + KMS 客户自管密钥 + PrivateLink + RAM 跨账号共享；9 月 Harness 交互式 shell（WebSocket、同 microVM、可重连回放 256KB、单会话最多 10 shell）、Harness 生命周期钩子（`before_invocation`/`before_tool_call`/`after_tool_call`/`after_invocation`，Lambda 返回同步 allow/deny、SNS/EventBridge 非阻塞通知）、Evaluations 支持 TypeScript 框架与 Skill 评估器、Identity Consent Portal。
- **关键数据**：TTL 配置字段 `recordExpirySpecification`；IAM `bedrock-agentcore:UpdateMemoryRecordExpirySpecification`；短期记忆三断会计费（ingestion/retrieval/storage）；来源日期粒度为「October 2026」（精确日未取得）。来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html （2026-10-15 取得）。
- **影响判断**：TTL + 按量计费把「记忆」从功能卖点变成可治理、可结算的资源，直击企业「记忆无限增长／成本不可控」痛点；私有 CA 支持则降低金融/政企用私网部署 Gateway 的改造成本。对自有参照：其外部记忆接入若要企业可用，同样需回答 TTL/保留策略与「不前置额外网关」的私网信任问题。
- **价值链位置**：平台与工具链（Managed Runtime + Memory + Gateway + Identity + Observability），本周向「企业控制面」继续上移，对模型层议价不变、对应用集成方议价上升。

#### Google Vertex AI / Gemini Enterprise Agent Platform

- **本周动态**：官方 release notes 窗口内两条。**10-13**：`gemini-4-argon` 进入 GA（Google 称其为面向编码、金融、法律、网络安全、科学等复杂真实任务的前沿模型，统一 1,048,576-token 输入与输出上限，thinking 级别可配 LOW/MEDIUM/HIGH，支持经 continuation token 的长解码至 1,048,576 token，agentic video understanding GA；已知问题：长解码仅在 v1beta1 API 可用，Gen AI SDK 默认 v1beta1，直连 REST 需用 v1beta1 路径）。同日的 `gemini-4-argon-cyber-permissive`（防御性网络安全向）在 Fairwind 计划 allowlist 内 GA；CodeMender 支持 Gemini 4 Argon（仍以 Gemini 3.8 Flash 为默认）。**10-14**：CodeMender v0.15.0（SARIF 2.1.0 报告标准化 rule descriptor/severity/仓库相对路径以兼容 GitHub Code Scanning，`cm stats --json` 增加模型调用统计，修复错误/取消路径下 token 用量遗漏）。**10-12** CodeMender v0.14.0（`--diff` 捕捉被移除的安全控制、新增 `--deep-max-turns`/`--enable-bash`）。页面另见 9-30 Cloud Trace 与 Agent Gateway 集成（Preview）（**背景**）。
- **关键数据**：gemini-4-argon GA @ 2026-10-13；1,048,576 token 输入/输出；CodeMender v0.14.0 @ 2026-10-12、v0.15.0 @ 2026-10-14。来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes （2026-10-15 取得）。
- **影响判断**：Google 本周平台层信号主要在**模型与编码代理**侧，未在 Runtime/Memory/Gateway 上给出新的窗口内控制面能力；与 AWS/火山的「控制面」路线形成错位。⚠️ 热度扫描所述该页 deprecated/2026-08-20 关停提示**未在正文证实**，本报告不采用（后续核对改名页后判定为**重命名/品牌整合**）。
- **价值链位置**：模型与算法 + 平台与工具链（Agent Studio/Engine）；SDK(ADK) 与平台强绑定。
#### 火山引擎 OpenViking（v0.5.0，2026-10-09）

- **本周动态**：v0.5.0 为「网关」版本。新增 **OpenViking Gateway（Beta）**：独立进程 `openviking-gateway`（默认 1935），代理 Anthropic Messages / OpenAI Chat Completions / 全历史 OpenAI Responses 并对配置上游**原协议**转发；客户端仅改 base URL 与 API key 两项即得记忆，无需插件/改码/prompt；会话开头注入用户 profile 与记忆、skill 目录，新用户消息先检索再把相关记忆附于消息末尾，后续请求逐字节回放，保持 provider prompt cache 与 Claude thinking 签名有效；对话存入 `gateway-…` 命名的 OpenViking session 并抽取新记忆，网关新建 session 关闭 Working Memory；接近窗口（默认 90%）时由同一模型写有上限摘要替换切点前历史；网关自执行 `openviking_` 前缀 MCP 工具，新 context profile 默认只勾选只读工具，写类工具（`remember`/`write`/`edit`/`add_resource`/`add_skill`/`forget`/`set_acl`）需管理员勾选；`tool_max_rounds`/`tool_total_seconds`/`tool_total_tokens` 默认**不限**（`tool_timeout_seconds` 30s 不变），非流式客户端断开后循环不停止，建议设 `tool_total_seconds`。管理面：Studio 新增 Gateway 页（Overview/Upstreams/Profiles/Keys/Requests/Connect），服务端新增管理代理 `/api/v1/admin/gateway/*`；Connect 页为 pi/OpenCode/DSH 生成配置。部署：pip extras `gateway`/`gateway-fast`、Docker 内置网关、Compose 新增 gateway profile、Helm 升 0.2.0；需 `ov.conf` 设 `gateway.enabled: true` 并提供 `OPENVIKING_GATEWAY_ENCRYPTION_KEY`(Fernet) 与 `OPENVIKING_GATEWAY_ADMIN_TOKEN`(≥32 字符)。**兼容性变更**：Working Memory 默认关闭（`memory_policy.working_memory.enabled` 由 true 改 false），commit 仍归档原始消息并抽取长期记忆，但默认不再生成 archive overview 与 checkpoint 摘要；`POST /api/v1/sessions/{id}/commit` 新增 `enable_working_memory`；插件宿主（Claude Code/Codex/OpenCode/pi/OpenClaw）默认改由宿主自管历史与压缩，`OpenClaw` 的 `contextManagementMode` 默认 `"native"`、需显式 `"openviking"`；MCP `remember` 改为返回「已提交抽取」+ `task_id`（旧返回文本调用方需更新）；context 模式召回不再返回系统预置目录、quota 名额由其他类别补足、`exclude_uris` 目录改为排除整棵子树。
- **关键数据**：v0.5.0 @ 2026-10-09（GitHub release）；`python-sdk@0.1.15` @ 2026-10-13；默认端口 1935；上下文压缩阈值默认 90%；`tool_timeout_seconds` 默认 30s；`OPENVIKING_GATEWAY_ADMIN_TOKEN` ≥32 字符；Helm 0.2.0。来源：https://github.com/volcengine/OpenViking/releases/tag/v0.5.0
- **影响判断**：以「模型网关中间层」无侵入接管上下文，是记忆厂商从 SDK 插件升级为**企业控制面**的典型路径，直接与 AWS AgentCore Gateway / Google Agent Gateway 的功能区重叠；Working Memory 默认关闭则反映「宿主自管压缩」成为行业默认前提。
- **价值链位置**：协议与工具 → 运行时/Harness（记忆与上下文网关）；本周由「集成与交付」上移到「运行时/网关」控制点，对宿主（OpenClaw 等）议价上升（成为可选上游），对模型层依赖降低（原协议转发、不做转换）。

#### Databricks Mosaic AI Agent Framework / Agent Bricks

- **本周动态**：官方 **October 2026 产品发布说明（逐条带日期）**。Runtime/Session：**Databricks AI Runtime SDK（`databricks-sdk-air`）取代 `serverless_gpu`**，GPU env v6 起（**10-13**）；旧名 FutureWarning、v7 终止支持。Memory/Context：**Agent memory pipelines 进入 Beta**（**10-12**）——session store 接 memory store，每次运行用 LLM 蒸馏持久事实/偏好/决策，可按需或约每 24h 运行。Gateway/Tools：**Unity Gateway Skills API Beta**（**10-12**）；**Unity Gateway 支持 Amazon Bedrock Mantle**（**10-09**）；Unity Gateway 上架 Google Gemini 4 Argon（**10-13**）、Anthropic Claude Haiku 5.5（**10-07**）。Identity/Auth：**custom service policies 支持调用方 request tags**（**10-09**）。Sandbox/Code：Databricks Apps 工作区级 package repositories GA（**10-14**）。Observability/Eval：**OpenJev（Qwen3.5 4B）作 LLM-as-a-judge 评估器（Beta）**（**10-09**）。治理/退役：**Knowledge Assistant 与 Supervisor Agent 转为 legacy**（**10-12**），推荐 Agent Bricks CLI / Genie Agents。
- **关键数据**：全部源＝ https://docs.databricks.com/aws/en/release-notes/product/2026/october （October 2026，逐日条目）＋同页链接文档页。官方声明「Releases are staged，账户可能延后一周以上」，未逐条独立复核；窗口外（10-05~10-07）条目已标背景。
- **影响判断**：Databricks 是本期**唯一提供逐日官方发布节奏**的平台，且同时在手洽 Runtime、Memory、Gateway、Identity、Eval 五列——把「数据平台 + 模型网关 + 记忆管道」整合为 Agent 控制面。**价值链位置**：平台与工具链（数据+Agent 控制面）；本周向「记忆管道 + 模型网关」上移。

#### 模块洞察（模块 8）

平台层本周的共同发力点是「**把记忆 / Gateway 做成可计量、可治理、可私有互联的控制面**」：AWS 用 TTL+按量计费把记忆变成可结算资源、用私有 CA 打通企业私网；火山引擎用网关形态无侵入接管上下文；Google 则在模型与部署身份侧推进；Databricks 用逐日节奏同时推进记忆管道与模型网关。证据以官方发布记录为主、未做实测，不足以断言格局定型，保留观察。
## 云厂能力矩阵

说明：1 行为一个平台，1 列为一项能力。单元格只写**已取证事实**或「本次未取得／本周无重大公开动态」；**不留空、不猜**。窗口外内容一律标「背景，非本周」。窗口＝2026-10-08 00:00 ~ 2026-10-14 24:00（+0800）。

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| **AWS**（Bedrock AgentCore） | Instances 计算类型、持久会话至多 14 天（8 月背景）；9 月 Harness 交互式 shell（同 microVM） | **长期记忆 TTL `recordExpirySpecification`；短期记忆按量计费（ingestion/retrieval/storage）**（10 月分区、精确日未取得） | **Gateway 支持私有 CA 签发 TLS 证书的 MCP/OpenAPI/HTTP proxy 目标（直连 VPC Lattice）**（10 月分区、精确日未取得） | 无本周新信号；Consent Portal 属 09-01 背景；出站默认 agent principal（Okta 10-02 分析，未独立核实） | 8 月 AgentCore Browser/Code Interpreter（本次未取得窗口内独立条目）；9 月交互式 shell 同 microVM | AgentCore Observability（OTEL→CloudWatch，常青文档、非窗口事件）；9 月 Evaluations 支持 TypeScript 框架 | 记忆可结算（TTL+按量）+ 私网直连（**但仅月级、无逐日日期，窗口归属未坐实**） |
| **Google**（Gemini Enterprise Agent Platform / Agent Engine） | Agent Runtime（部署/管理五种方式）+ Sessions；ADK 部署 Agent Engine 支持专用自定义服务账号（10-13） | Memory Bank（长期偏好/事实）；官方改名页将 Agent Engine Memory Bank 归入新平台（**重命名，非关停**） | Agent Gateway（拟议原生解析 MCP+A2A，Envoy/K8s，**Next '26 背景、preview**）；Cloud Trace 集成（09-30 背景） | IAM agent identity；ADK 凭证加密入 session、OIDC audience 强制、修 OAuth2 密钥泄露（10-13）；Agent Identity（非人加密 ID，Next '26 背景） | Code Execution；**CodeMender v0.14.0（10-12）/v0.15.0（10-14）** | Evaluation Service + Example Store；App Topology API GA（09-30 背景） | 窗口内发布集中在**模型与编码代理**（Gemini 4 Argon GA 10-13、CodeMender 连发）；控制面本身无独立条目 |
| **Microsoft**（Foundry Agent Service / Hosted Agents / Copilot Studio） | Hosted agents、long-running（crash-resilient、steerable、reconnect、task state、HITL）——**均 preview、8 月背景** | 本次未在该官方页取得窗口内独立 Memory 条目 | Toolbox（含 toolbox-network-isolation）、OpenAPI/web search/Code Interpreter tools、Foundry MCP Server（背景） | Entra authentication for Foundry Agent trace ingestion（preview）；Entra Agent ID（blueprint 派生 service principal，5 月背景） | Code Interpreter tool（Foundry）；Copilot Studio Computer use（2026-05 GA，背景） | cloud evaluation 系列 + Agent Monitoring Dashboard + Foundry SDK 评测（背景） | **本周无重大公开动态**：what's-new 最新 August 2026（updated 09-09）、Copilot Studio 最新 September 2026、Foundry Blog 最新 09-29 |
| **阿里云**（百炼 Model Studio / PAI） | 智能体托管运行时（06-29 上线，背景） | 记忆库 Memory 2.0（03-20）+ 记忆库商业化通知（07-21）（背景） | 网关变更通告（07-13）；官方/第三方 MCP（02-06）；数据连接模块 MySQL/语雀/OSS（06-10） | 生成临时 API Key（06-03）；API Key 加密存储与业务空间专属推理域名升级（06-29） | 知识检索服务、Coding Plan 联网搜索 MCP（06-11）；**未见独立浏览器沙箱条目** | 模型评测（06-09）、知识库日志与监控投递 SLS（04-24） | **本次未取得窗口内条目**：功能更新页 2026 年最新为 8 月（9/10 月分区未出现）；PAI 未核 |
| **火山-字节**（OpenViking / Ark / Coze） | Helm chart 0.2.0 sidecar；Docker gateway profile；Compose gateway profile（10-09） | **Working Memory 默认关闭**（#5696/#5686）；检索 quota 补位（#5679）；`python-sdk@0.1.15` 补 `skip_conflicts`/`grep(level_limit)`（10-13） | **OpenViking Gateway（Beta），默认端口 1935，原协议转发 Anth/OpenAI**（#5625，10-09） | 网关 key + context profile 默认只勾选只读工具，写类工具需管理员勾选（#5625） | 本次未取得（窗口内无独立条目） | Studio Requests 页 + OV-Usage 来源卡片（10-09） | **OpenViking Gateway(Beta) 以「改 base URL」无侵入接管上下文，并逐字节回放保 provider prompt cache** |
| **腾讯云**（ADP / 元器 / CloudBase） | ADP **10-12** 新版订阅（体验/进阶 1 License/企业标准 20 License）+ Agent Portal；ADP 4.0 以 AgentOps 为核心、「新增 Claw 模式，引入云端 Agent Harness 架构」（博客，无逐日日期） | 本次未取得（未见窗口内独立 Memory 条目） | ADP 4.1.4「新增授权凭证，连接器和工具可跨空间共享、知识库支持 SAP HANA」（博客，无逐日日期） | 本次未取得 | 本次未取得 | ADP 4.0 含「治理、观测与优化」链路（博客口径，未给逐条日期/文档页） | **席位 License + Agent Portal**（10-12）；**GLM-5/5-Turbo/5.1 于 TokenHub/ADP/CloudBase 下线，生效 10-09 00:00**，ADP 自动切至 GLM-5.3（announce/2469） |
| **Databricks**（Mosaic AI Agent Framework / Agent Bricks） | **`databricks-sdk-air` 取代 `serverless_gpu`**（10-13，GPU env v6 起） | **Agent memory pipelines 进入 Beta**（10-12）：session store 接 memory store，LLM 蒸馏持久事实，可约每 24h 跑 | **Unity Gateway Skills API Beta**（10-12）；支持 Amazon Bedrock Mantle（10-09）；上架 Gemini 4 Argon（10-13）/Claude Haiku 5.5（10-07） | **custom service policies 支持调用方 request tags**（10-09） | Databricks Apps 工作区级 package repositories GA（10-14） | **OpenJev（Qwen3.5 4B）作 LLM-as-a-judge 评估器 Beta**（10-09） | **唯一逐日官方节奏**；记忆管道 Beta + Unity Gateway 扩模型/网关，Knowledge Assistant 与 Supervisor Agent 转 legacy（10-12） |

矩阵留白说明：上表中标注「本次未取得」的单元格，均为本期实际扫描后仍未取得可核原件的项，**不代表官方无动态**；「本周无重大公开动态」仅指官方页未出现属于 10-08~10-14 的逐条条目。

## 本周 TOP 5 候选及依据

排序依据：**对 Agent Harness 基础设施格局的信号价值**（控制面/入口/治理边界的变化幅度 × 证据可核度 × 对搭生产方案的人的直接影响）。

**1. AWS Bedrock AgentCore：记忆 TTL + 短期记忆按量计费 + Gateway 私有 CA。**
- 信号：平台把「记忆」从功能卖点变成可治理、可结算、可私网互联的资源（TTL 可配置、ingestion/retrieval/storage 分开计费、私有 CA 直连 VPC Lattice）。
- 依据：AWS AgentCore 官方 release notes「October 2026」分区（https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ，取得 2026-10-15）。
- 为何入选：它定义了「记忆作为可计费基础设施」的产品形态，直接挤压下游自建记忆层的议价空间；Harness 选型从此多了一条「记忆成本可预测性」轴。**限述：仅月级归档、无逐日日期，窗口归属未坐实**，故不作为「本周新增」硬结论。

**2. 火山引擎 OpenViking v0.5.0：OpenViking Gateway（Beta）。**
- 信号：以「模型网关中间层」无侵入接管上下文（只改 base URL），且把「不破坏 provider prompt cache」作为一等设计约束；Working Memory 默认关闭，改由宿主自管压缩。
- 依据：GitHub release `v0.5.0` @ 2026-10-09（https://github.com/volcengine/OpenViking/releases/tag/v0.5.0 ）。
- 为何入选：这是本周**窗口内日期最确定、架构含义最清晰**的记忆层信号——记忆厂商从 SDK 插件升级为企业控制面切口，直接与 AWS/Google 的 Gateway 功能重叠；对自建 harness 意味着「外部记忆可后装、可拆」。

**3. LangGraph 部署/状态生命周期发版潮（CLI 0.4.34/0.4.35、checkpoint 4.3.0、checkpointpostgres 3.2.0）。**
- 信号：控制层把差异化从「编排原语」转到「私域部署 + 状态回收/正确性」（`--image-pull-secret`、构建日志保留、`prune`、delta 重放正确性）。
- 依据：gh api releases，cli 0.4.34(10-13)/0.4.35(10-14)/checkpoint 4.3.0(10-12)/checkpointpostgres 3.2.0(10-14)（https://github.com/langchain-ai/langgraph/releases ）。
- 为何入选：它是本周「控制层运维化」主线的**最密集、最可核**证据集，且直接可映射到自建 harness 的 session/cron 存储回收设计。

**4. Google：Gemini 4 Argon GA（10-13）+ ADK v2.12.0 工具闸门/HITL/部署身份（10-13）。**
- 信号：同一天同时推模型能力（1,048,576 token、thinking 可配、长解码、agentic video）与框架治理（`after_tool_callback` 输出过滤、`require_confirmation`、专用服务账号、OAuth2 密钥泄露修复）。
- 依据：Google 官方 release notes 逐日条目（https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ）；ADK v2.12.0（https://github.com/google/adk-python/releases/tag/v2.12.0 ）。
- 为何入选：本周唯一「模型 + 框架」同日双发的厂商，且首请求 -40% 是本周少见的性能量化主张（**官方自述，未独立复测**）。

**5. 工具层的会话级授权落地：Nango v0.71.13 + Composio 多包发版。**
- 信号：价值锚点从「接了多少 API」转为「会话级凭据托管与逐工具授权」，并含 OAuth 回调开放重定向修复等真实安全收口。
- 依据：Nango v0.71.13 @ 2026-10-14T13:01Z（https://github.com/NangoHQ/nango/releases ）；Composio 10-14 多包发版与 `proxyExecute`/`executeMeta`（https://github.com/ComposioHQ/composio/releases ）。
- 为何入选：它把「逐会话授权 + 可撤销 + 凭据不落 agent」变成可落地实现，是本周工具/权限层唯一具备完整撤销链的开源参考。

### 候补信号

1. **Databricks October 2026 逐日条目**（Agent memory pipelines Beta 10-12、Unity Gateway Skills API Beta 10-12、AI Runtime SDK 10-13、OpenJev 评估器 10-09、Knowledge Assistant/Supervisor Agent 转 legacy 10-12）——逐日可核且五列同时推进，但主要影响 Databricks 生态内客户。
2. **腾讯云 ADP 席位制订阅 + Agent Portal**（10-12）与 GLM-5 系列下线（10-09）——国内平台治理化与模型供给切换。
3. **crawl4ai v0.9.5 安全版**（10-14，6 个 advisory）与 **Langfuse 三连发**（10-12/13/14）——摄取层与观测层的生产硬化。
4. **E2B 2.56.0**（10-13）——沙箱底座连接池自治（Breaking）。
5. **Microsoft Agent Framework dotnet-1.25.0**（10-14，工具审批超时自动拒绝）——企业治理路线，但幅度小于上述 5 条。
## OpenClaw 战略参照

（均以本周窗口内证据支撑；外部参照仅作对照，不代表已对自有实现作出变更。）

1. **领先点：默认上下文管理被外部实现承认为「事实接口」。** 火山引擎 OpenViking `v0.5.0`（10-09）把插件宿主默认行为改为**宿主自管历史与压缩**，其中 `OpenClaw` 的 `contextManagementMode` 默认即 `"native"`，需显式设 `"openviking"` 才外接；同时新增 OpenClaw 自动上下文注入用户 profile（#5676）与对 OpenClaw/pi 客户端截断按失败处理（#5790）。→ 第三方记忆厂商围绕 OpenClaw 的默认策略做取舍，说明「默认 native、按需外接」的边界已被生态承认，可作为 session/context 策略的对外契约继续维护。
2. **补课点一：工具输出闸门。** Google ADK v2.12.0（10-13）新增 `after_tool_callback`，可在工具输出返回模型前拦截/过滤；同一周 Microsoft 加入 tool-result standing guidance。→ 对应自有 tool runtime 应在「工具结果进入模型上下文前」提供可插拔拦截/改写点（而非仅在工具侧校验）。
3. **补课点二：审批生命周期与超时归还。** Microsoft `dotnet-1.25.0`（10-14）**自动拒绝永不响应的工具审批请求**，ADK 修「已确认工具每次审批只运行一次」（#7434）并支持 `require_confirmation`；LangGraph 保留失败部署的构建日志。→ 对应自有的审批/确认流程需定义「超时默认拒绝」与「不重复消耗审批」两个明确语义，避免长时挂起与重复执行。
4. **补课点三：状态回收与成本可控。** LangGraph `checkpointpostgres==3.2.0`（10-14）新增 `prune`；AWS AgentCore 长期记忆 TTL；cognee v1.6.4 把 LanceDB 隐式后台 pruning 改为手动（破坏性）。→ 本周三家独立证据同向：状态存储必须提供**显式回收（prune/TTL）与可预测成本**。自有 cron/session 存储应对齐「默认保留策略 + 显式 prune」两件事。
5. **补课点四：会话级外部凭据的企业可用性。** AWS 私有 CA/VPC Lattice（10 月分区）解决「不前置额外网关的私网信任」，Nango agent sessions 做到「凭据由网关注入、agent 不触明文」。→ 自有外部工具接入若要企业可用，需同时回答「私网信任锚」与「凭据不经 agent」两个问题。
6. **旁参：观测字段设计。** Braintrust（October 2026）以 `session_id`/`turn_span_id` 支持逐轮归因与 coding agent 成本拆分；Langfuse 本周修正 cache-read 价格口径。→ 可作为自有 trace/成本归因字段与计价口径的对照清单。

## GitHub 热度补漏摘要

本期在研究前先做 9 方向 GitHub/Web 热度补漏扫描（`hot-scan-2026-10-15.md`，扫描于 2026-10-15 06:03~06:12 +0800，入口：`gh api` 认证直查 + serper）。

### 9 方向执行结果（精简）

| # | 方向 | 结果要点 |
|---|---|---|
| 1 | agent memory / context database | OpenViking 仍居 topics 首位；2026 记忆对比文为二手聚合 |
| 2 | agent harness / runtime | 品类词固化；`agent-harness` topic 1,584 仓；MS Agent Framework BUILD 2026 为背景 |
| 3 | browser agent runtime / sandbox / code execution | Northflank/Modal/Firecrawl 2026 沙箱对比为聚合文；E2B 官网定位「isolated machine for every agent」 |
| 4 | MCP gateway / agent auth / OAuth / tool permission | `agentic-community/mcp-gateway-registry` 居首；Permit「OAuth on MCP」、MCP discussion #804「Gateway-Based Authorization Model」、Red Hat 网关 auth 文 |
| 5 | agent observability / eval / guardrails | `ai-observability`/`llm-observability` topics 活跃；MonteCarlo、Braintrust 指南为聚合 |
| 6 | AI agent RAG / knowledge graph / memory / skills | OpenViking 首位；serverless 单文件 memory layer；TeleAI-UAGI/Awesome-Agent-Memory 收录 |
| 7 | 云厂平台（AWS/Google/Microsoft） | AgentCore 官网；Gemini Enterprise Agent Platform release notes（⚠️ 页面曾提示 deprecated，**经逐源核实为改名而非关停**）；三方对比为二手 |
| 8 | 火山引擎 / Coze / OpenViking | 火山 OpenViking 产品页 2026/6 更新为窗外背景；marktechpost 2026-03 文为背景 |
| 9 | MCP / A2A 协议本体周讯 | ⚠️ **该方向返回被「October」歧义词污染，无有效结果**；不据此判无动态，**后由工具与协议专项逐源补齐**（详见模块 4：MCP 无窗口内新 spec 版本；A2A 仅 10-12 文档提交） |

### GitHub 直查快照（2026-10-15 06:06 +0800；stars 为绝对值，非周增速）

| 仓库 | stars | forks | pushed_at | 最新 release | 窗口内 | 归类模块 |
|---|---|---|---|---|---|---|
| volcengine/OpenViking | 39924 | 3174 | 2026-10-14 | `python-sdk@0.1.15` @ 10-13 | ✅ | 6 Context/Memory（+8 平台） |
| mem0ai/mem0 | 67194 | 7909 | 2026-10-14 | `v2.2.1` @ 09-25 | — | 6 |
| topoteretes/cognee | 32293 | 3365 | 2026-10-14 | `v1.6.4` @ 10-13 | ✅ | 6 |
| supermemoryai/supermemory | 31228 | 2748 | 2026-10-14 | `server-v0.0.9` @ 10-12 | ✅ | 6 |
| letta-ai/letta | 25138 | 2646 | 2026-09-10 | `0.16.8` @ 05-14 | — | 6 |
| getzep/graphiti | 31752 | 3268 | 2026-10-14 | `v0.30.2` @ 09-08 | — | 6 |
| firecrawl/firecrawl | 191558 | 10128 | 2026-10-14 | `v2.11.0` @ 06-19 | — | 6 |
| unclecode/crawl4ai | 85545 | 8880 | 2026-10-14 | `v0.9.5` @ 10-14 | ✅ | 6 |
| e2b-dev/E2B | 14353 | 1112 | 2026-10-14 | `e2b@2.56.0` @ 10-13 | ✅ | 3 |
| browserbase/stagehand | 25668 | 1757 | 2026-10-14 | `stagehand-server-v3/v3.7.6` @ 08-28 | — | 3 |
| ComposioHQ/composio | 30552 | 4852 | 2026-10-14 | `@composio/openai-agents@0.11.2` @ 10-14 | ✅ | 4 |
| ArcadeAI/arcade-mcp | 1051 | 120 | 2026-10-14 | （无 GitHub release） | — | 4/5 |
| NangoHQ/nango | 12662 | 1436 | 2026-10-14 | `v0.71.13` @ 10-14 | ✅ | 4/5 |
| langchain-ai/langgraph | 43273 | 7360 | 2026-10-14 | `cli==0.4.35` @ 10-14 | ✅ | 1 |
| langfuse/langfuse | 35828 | 3988 | 2026-10-14 | `v4.59.0` @ 10-14 | ✅ | 7 |
| agentic-community/mcp-gateway-registry | 981 | 248 | 2026-10-14 | `1.32.1` @ 10-06 | —（窗内-2 天） | 4/5 |

**过滤项**：`awesome-*` 榜单仅作线索；平台对比/导购/榜单文（Northflank、Modal resources、MonteCarlo、Braintrust、powerdrill、atlan、triotechsystems、gmicloud）为二手聚合，不作已读一手来源；时间窗外旧闻（OpenViking 产品页 2026/6 条目、marktechpost 2026-03、Microsoft BUILD 2026-06、Coze 开源等）仅作背景。

**补漏结论**：9 方向中 8 个给出了可用线索，方向 9（MCP/A2A 协议周讯）被「October」歧义词污染而失效，**已由工具与协议研究线逐源核对官方仓库/规范补齐**（结论：协议本体本周无新规范版本，仅治理与披露 WG 章程推进），未因此方向失效而错报「协议无动态」。
## 价值链传导与议价

链条：模型与算法 → 运行时/Harness → 协议与工具 → 平台与工具链 → 集成与交付 → 终端场景。

1. **模型与算法 → 运行时/Harness：能力通过框架捆绑向运行时传导，但定价权仍在模型侧。** Google 同日把 Gemini 4 Argon GA（10-13，统一 1,048,576-token 输入/输出、thinking 级别可配）与 ADK v2.12.0 绑定发布，形成「SDK 免费 + 平台计费」的捆绑结构；ADK 宣称长会话首请求 -40%（官方自述，未独立复测）。→ 模型侧的 context 上限与 thinking 级别已成 harness 上下文策略的直接输入。
2. **运行时/Harness → 协议与工具：授权中间件被上游吸收，工具网关被迫上移到凭据与撤销链。** ADK `after_tool_callback`（10-13）、MS 工具审批超时自动拒绝（10-14）把「工具输出闸门 + 审批」内建到框架。→ 单纯「代理工具调用」的网关价值被商品化；Nango/Composio 的差异化被逼向「跨框架凭据托管 + 可撤销会话」。**位置待明确**：会话级授权由谁定义标准（MCP progressive disclosure WG 尚未产出规范）。
3. **协议与工具 → 平台与工具链：标准沉默期，云厂以「协议原生网关」抢治理位。** MCP/A2A 本周无新规范版本（MCP 最新 2026-07-28；A2A 仅 10-12 文档提交）；云厂同步加码网关（Google Agent Gateway preview，Next '26；AWS 私有 CA 直连 VPC Lattice；Databricks Unity Gateway Skills API Beta）。→ 标准沉默 + 云厂收编，集成方的迁移成本被锁定在各家网关的私网/身份模型上。
4. **平台与工具链 → 集成与交付：记忆与会话变为可计量商品，报价结构从项目制转向按会话/按席位。** AWS 记忆 TTL + 按量计费（10 月分区）、Databricks Agent memory pipelines Beta（10-12）、腾讯 ADP 席位 License（10-12）。→ 议价权向平台倾斜，交付方需重算「记忆保留成本 + 席位/用量」两项。
5. **集成与交付 → 终端场景：安全信任与成本可见性成为采购门槛。** crawl4ai 一周内第二个安全版（10-14，6 个 advisory）、Nango 修 OAuth 回调开放重定向（10-09）、Arcade 把上游错误挡在 agent 可见消息外（10-12）；观测层同步企业化（Langfuse FIPS/网关 key 过期、Braintrust coding agent 成本仪表盘）。→ 终端场景的采购门槛从「能跑通」变为「能过安全与合规审查，且成本可归因」。

**本周商品化/定价权信号小结**：定价权本周**清晰地向平台侧（计费与席位）与云厂网关（私网与身份）移动**；开源侧（Nango/Composio/OpenViking）以「会话/网关」抢占集成入口，但尚未形成可复用的跨厂商标准——**该项位置待明确**。
## 局限、未取得与隔离项

> 以下均按原样保留各研究线标记的局限；**未取得 / 限述 / 隔离**的内容不得升格为确定事实。相应不能作出的判断已逐条写明。

### 1. 日期粒度与窗口归属类

- **AWS AgentCore「October 2026」三条**（Memory 长期记忆 TTL、短期记忆按量计费、Gateway 私有 CA）：官方页**仅月级分区、无逐日日期**，**不能坐实落在 10-08~10-14 窗口内**，也不能据此写「本周新增」。本次未取 AWS What's New 逐日页另证。
- **Braintrust**：仅有「October 2026」月份标签，**无法确证是否在 10-08~10-14 内**；具体发布日期未取得。
- **腾讯云 ADP**：ADP 4.0 / 4.1.4 博客**无逐日日期**，不能判断窗口归属（仅 10-12 三档订阅、10-09 GLM-5 下线为窗口内确定日期）。
- **Microsoft**：what's-new 为月级滚动（最新 August 2026，updated 09-09）、Copilot Studio 最新 September 2026、Foundry Blog 最新 09-29——**未取得 10-08~14 逐日条目，故记「本周无重大公开动态」，不等于「无动态」**。
- **阿里云百炼**：功能更新页 9/10 月分区未出现，**不能据此断言「无动态」，只能说「本次未取得窗口内条目」**；PAI 未核。

### 2. 未取得 / 未复核类

- **Gemini Enterprise Agent Platform deprecated / 2026-08-20 关停主张**：已 fetch 该页正文（raw 84008 字符），对 `deprecat`/`shutdown`/`retire` grep **无命中**，**主张未获证实，已隔离，本报告不采用**。后续核对官方改名页：Vertex AI Agent Engine → **Agent Runtime on Gemini Enterprise Agent Platform**（Memory Bank/Sessions/Code Execution 同步改名），原 release-notes URL 现 302 跳转——判定为**重命名/品牌整合，非关停**，按「重命名，未证实关停」限述。
- **Langfuse changelog 落地页**：`langfuse.com/changelog` 与 `/changelog.md` **均 404**，未取得落地页正文，仅以 release body 为据；未取得 Langfuse 自身定价变更。
- **Mem0 / Letta / Graphiti / Firecrawl / Helicone / AgentOps**：仅核到 release 端点与 `pushed_at`，**未逐查窗口内 commit/PR**，可能漏掉未打 tag 的能力变更；Letta 官方 blog/changelog 未单独核验。
- **强观察池未扫描**：LightRAG、MS GraphRAG、LlamaIndex、LangMem/LangGraph Store、Onyx、Haystack、Jina Reader、Unstructured、Chrom/Qdrant/Milvus/Weaviate 本轮**未扫描**，无命中即不写。
- **Arcade**：产品版本走官网而非 GitHub release，**本次未读取其官网 changelog**，故不能判定「无产品动态」，仅记「仓库层无重大公开动态」。
- **mcp-gateway-registry**：1.33.0 **仅有 notes 草稿（10-14）未发布**，按「提案≠已生效」处理，不得按已发布能力陈述。
- **MCP discussion #804**「Gateway-Based Authorization Model」日期经 GraphQL 查询未返回，**未核、未采用**。
- **Google Agent Gateway**：官方 blog/docs 的窗口内发布日期未取得（Forkast 为二手分析文），官方概览 URL 未读取；产品处 **preview**，不得当作已生效能力引用。
- **AWS AgentCore Identity / Microsoft Entra Agent ID / Google Agent Identity**：窗口内**未取得官方新发布**，按背景记录；AWS what's-new 与 learn.microsoft 页面**未逐篇全文读取**，未独立核实。
- **Pipedream Connect、Smithery、Zapier MCP、Auth0/WorkOS/Clerk/Descope/Permit.io/Aserto**：本周未见面向 Agent/MCP 工具权限的明确新发布，仅保留状态表行（搜索无结果不等于不存在）。
- **E2B**：hot-scan 线索 `@e2b/code-interpreter-python@2.11.0` 本次在 GitHub releases **未复核到**（最新 `@e2b/code-interpreter-python@2.9.1` @08-13），标未独立复核。
- **Coze Loop、Google Vertex/Azure AI Foundry 的 agent observability**：窗口内官方更新本次未取得。
- **Databricks**：官方声明「Releases are staged，账户可能延后一周以上」，未逐条独立复核。

### 3. 列入矩阵的未取得列

- Microsoft：窗口内无逐日条目；Memory 列未在该页取得窗口内独立条目；多列为背景。
- 阿里云：窗口内无条目；PAI 未核；未见独立浏览器沙箱条目。
- 腾讯云：Memory / Identity / Sandbox 三列本次未取得。
- 火山-字节：Sandbox 列本次未取得。

### 4. 证据强度与未实测类

- 本报告全部内容为**文献取证，未做实测复现**：ADK 首请求 -40%、AWS 私有 CA 连通性、E2B 并发治理、Braintrust 成本拆分、Google Triage agent 处理量等，均为**厂商自述/官方口径**，未独立复测。
- 「细粒度权限/审计」主张多来自厂商文档（Nango/Composio），按 B/C 级处理。
- 平台对比/导购/榜单类二手聚合文（Northflank、Modal、MonteCarlo、Braintrust、powerdrill、atlan、triotechsystems、gmicloud）**未作为一手来源**。

### 5. 不能作出的判断

- 不能声称 AWS 十月三条「发生在本周」，只能作「十月内、精确日未取得」。
- 不能声称 Microsoft / 阿里云窗口内「无动态」，只能作「本次未取得窗口内条目」。
- 不能声称 Gemini Enterprise Agent Platform「关停」，只能作「重命名」。
- 不能将 mcp-gateway-registry 1.33.0、Google Agent Gateway preview、Braintrust self-hosting 能力当作已生效能力。

### 6. 取证过程与质量计数（仅留资料库）

<!-- AUDIT_METADATA -->
- 入口：`gh api`（认证面）直查 GitHub releases/commits/compare；`web_fetch` 读官方页；搜索 provider=serper（`auto_routed:false`，未用 tavily/exa 以避免重复消耗）。
- 分片载荷：20 个研究分片（含平台矩阵缺列补缺 4 片）全部完整读取；逐单元标记已先载荷后写入。
- 失败/降级记录：Langfuse changelog 404；热度扫描方向 9 被「October」歧义污染（后由工具与协议专项逐源补齐）；阿里云更新公告页 readability 未取正文（只读到导航）。
- 未做：实测复现、跨期 stars 增速计算（无两周前快照）、AWS What's New 逐日页另证。

<!-- PRIVATE_INTERNAL -->
- run 标识、分片与模块的映射、写入权交接等信息仅存于本 run 内部文件（run-contract / 各线交接标记），不进入本报告公开正文。

---

<!-- EVIDENCE_ONLY -->
## 来源清单

（编号 L1…；每条带获取/发布日期。均为本 run 内实际读取或直查。标记「gh api」者为 GitHub API 直查（releases/commits）而非网页正文。）

### 官方发布与文档

- L1. AWS Bedrock AgentCore release notes（October/September/August 2026 分区）— https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html （取得 2026-10-15）
- L2. Google Gemini Enterprise Agent Platform release notes（逐日）— https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes （取得 2026-10-15）
- L3. Google Vertex AI → Gemini Enterprise Agent Platform 改名映射 — https://docs.cloud.google.com/gemini-enterprise-agent-platform/vertex-ai-name-changes （取得 2026-10-15）
- L4. Google Agent Gateway 概览（本次未逐一读取）— https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview
- L5. Microsoft Foundry What's new（August 2026）— https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry （取得 2026-10-15）
- L6. Microsoft Copilot Studio What's new（September 2026 分区）— https://learn.microsoft.com/en-us/microsoft-copilot-studio/whats-new （取得 2026-10-15）
- L7. Microsoft Foundry Blog（最新 2026-09-29）— https://devblogs.microsoft.com/foundry/ （取得 2026-10-15）
- L8. Microsoft Entra Agent ID What's new — https://learn.microsoft.com/en-us/entra/agent-id/whats-new-agent-id
- L9. 阿里云百炼「模型平台功能更新」（2026 年 8 月分区）— https://help.aliyun.com/zh/model-studio/model-release-notes ；产品动态索引 — https://help.aliyun.com/zh/model-studio/release-notes （取得 2026-10-15）
- L10. 阿里云百炼相关公告/通知 — 记忆库商业化通知 https://www.aliyun.com/notice/118464 ；网关变更通告 https://www.aliyun.com/notice/118436 ；API Key 加密存储与专属域名升级 https://www.aliyun.com/notice/118406
- L11. 腾讯云公告 2476（ADP 新版订阅套餐，生效 2026-10-12）— https://cloud.tencent.com/announce/detail/2476 （已读全文）
- L12. 腾讯云公告 2469（GLM-5/5-Turbo/5.1 下线，生效 2026-10-09 00:00）— https://cloud.tencent.com/announce/detail/2469 （已读全文）
- L13. 腾讯云公告 2496（DeepSeek-V4-Flash 0731 下线 2026-10-31）— https://cloud.tencent.com/announce/detail/2496 （已读全文）
- L14. 腾讯元器「迁移至 ADP 指引」（更新 2026-10-08）— https://yuanqi.tencent.com/cl/adp-guide
- L15. 腾讯 ADP 博客（4.0/4.1.4，无逐日日期）— https://adp.tencent.com/zh/blog （取得 2026-10-15）
- L16. Databricks October 2026 产品发布说明（逐日）— https://docs.databricks.com/aws/en/release-notes/product/2026/october （取得 2026-10-15）
- L17. AWS What's New（AgentCore Identity managed consent portal，2026-09-01，投影、未逐篇读全文）— https://aws.amazon.com/about-aws/whats-new/2026/09/amazon-bedrock-agentcore/
- L18. Pipedream Connect managed auth 文档（本周无动态，仅背景）— https://pipedream.com/docs/connect/managed-auth/quickstart
- L19. Braintrust 产品更新（October 2026 条目）— https://www.braintrust.dev/docs/changelog ；文档索引 — https://www.braintrust.dev/docs/llms.txt （取得 2026-10-15）
- L20. supermemory API v5 公告（2026-10-07，窗外背景）— https://supermemory.ai/changelog/supermemory-api-v5/ （已读全文）
- L21. Crawl4AI CHANGELOG（v0.9.5）— https://raw.githubusercontent.com/unclecode/crawl4ai/main/CHANGELOG.md （直读）
- L22. Mem0 官方 changelog/highlights（最新 2026-08-24）— https://docs.mem0.ai/changelog
- L23. OTel GenAI 语义约定独立仓库 — https://github.com/open-telemetry/semantic-conventions-genai
- L24. Nango 官方 changelog（Connection MCP 弃用与 agent sessions 迁移）— https://nango.dev/docs/updates/changelog （已读全文）
### GitHub releases / commits / compare（gh api 直查）

- L25. langchain-ai/langgraph — https://github.com/langchain-ai/langgraph/releases ；cli 0.4.35 — https://github.com/langchain-ai/langgraph/releases/tag/cli%3D%3D0.4.35 ；checkpointpostgres 3.2.0 — https://github.com/langchain-ai/langgraph/releases/tag/checkpointpostgres%3D%3D3.2.0
- L26. microsoft/agent-framework — https://github.com/microsoft/agent-framework/releases ；python-1.21.0 — https://github.com/microsoft/agent-framework/releases/tag/python-1.21.0 ；dotnet-1.25.0 — https://github.com/microsoft/agent-framework/releases/tag/dotnet-1.25.0
- L27. google/adk-python v2.12.0 — https://github.com/google/adk-python/releases/tag/v2.12.0
- L28. anthropics/claude-agent-sdk-python — https://github.com/anthropics/claude-agent-sdk-python/releases ；v0.2.166 — https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.166
- L29. openai/openai-agents-python（窗口内无 release）— https://github.com/openai/openai-agents-python/releases
- L30. volcengine/OpenViking v0.5.0 — https://github.com/volcengine/OpenViking/releases/tag/v0.5.0 ；releases 列表 — https://github.com/volcengine/OpenViking/releases
- L31. e2b-dev/E2B e2b@2.56.0 — https://github.com/e2b-dev/E2B/releases/tag/e2b%402.56.0
- L32. modelcontextprotocol/modelcontextprotocol — releases https://github.com/modelcontextprotocol/modelcontextprotocol/releases ；commits https://github.com/modelcontextprotocol/modelcontextprotocol/commits
- L33. ComposioHQ/composio — releases https://github.com/ComposioHQ/composio/releases ；commits https://github.com/ComposioHQ/composio/commits
- L34. NangoHQ/nango — https://github.com/NangoHQ/nango/releases
- L35. ArcadeAI/arcade-mcp commits — https://github.com/ArcadeAI/arcade-mcp/commits
- L36. agentic-community/mcp-gateway-registry — commits https://github.com/agentic-community/mcp-gateway-registry/commits ；releases https://github.com/agentic-community/mcp-gateway-registry/releases
- L37. a2aproject/A2A — commits https://github.com/a2aproject/A2A/commits ；releases https://github.com/a2aproject/A2A/releases
- L38. topoteretes/cognee releases — https://github.com/topoteretes/cognee/releases
- L39. supermemoryai/supermemory releases（server-v0.0.9）— https://github.com/supermemoryai/supermemory/releases
- L40. unclecode/crawl4ai releases（v0.9.5）— https://github.com/unclecode/crawl4ai/releases
- L41. langfuse/langfuse releases（v4.57.0/v4.58.0/v4.59.0）— https://github.com/langfuse/langfuse/releases
- L42. langchain-ai/langsmith-sdk releases（v0.14.7/v0.14.8）— https://github.com/langchain-ai/langsmith-sdk/releases
- L43. Arize-ai/phoenix releases（v20.21.2/3/4）— https://github.com/Arize-ai/phoenix/releases
- L44. GitHub 元数据快照（stars/forks/pushed_at）：volcengine/OpenViking、mem0ai/mem0、topoteretes/cognee、supermemoryai/supermemory、letta-ai/letta、getzep/graphiti、firecrawl/firecrawl、unclecode/crawl4ai、e2b-dev/E2B、browserbase/stagehand、ComposioHQ/composio、ArcadeAI/arcade-mcp、NangoHQ/nango、langchain-ai/langgraph、langfuse/langfuse、agentic-community/mcp-gateway-registry（`gh api` 快照，2026-10-15 06:06 +0800）

### 媒体与分析文（二手，已标注）

- L45. Forkast（2026-10-08）Google 协议原生 Agent Gateway 分析 — https://forkast.news/google-cloud-ships-the-first-protocol-native-agent-gateway-and-it-understands-mcp-and-a2a/ （已读全文，二手）

> 来源计数（仅资料库）：官方一手页 L1—L24；gh api 直查仓 L25—L44；二手分析 L45。所有 URL 均为本 run 内实际读取或 API 直查；未引用未读页面作为事实依据。

<!-- PRIVATE_INTERNAL: 报告结束。本母稿为文献取证成果，证据边界见「局限、未取得与隔离项」；后续编辑环节需保留本节的限定条件与归因。 -->
<!-- 母稿结构自检：标题含「第 17 期」；模块 1—8 齐备；云厂矩阵 7 平台 × 6 列 + 强信号；TOP 5 共 5 条 + 5 条候补；OpenClaw 战略参照 6 条；价值链传导 5 条；局限与隔离项 6 类；来源清单 L1—L45。 -->
