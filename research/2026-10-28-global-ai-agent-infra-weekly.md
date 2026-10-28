# 全球 AI Agent 基础设施研究周报 · 第 19 期研究母稿

- 覆盖窗口：2026-10-22 00:00 ~ 2026-10-28 24:00（Asia/Shanghai）
- 运行日：2026-10-28（手动试跑；按周四触发规则冻结）
- 产出人：Grok Bot
- 证据标准：weekly-research-evidence（主张级 A–D）
- OpenClaw：必覆盖；老板侧正在迁定时任务至 Grok Bot——**不静默删除**；ECS 本机 CLI 版本本轮未取得字符串

## 一、本期总览

本周最强的不是「又多一个 Agent 框架」，而是三条并行硬化：

1. **开源 Agent OS 进入「更新不断线」竞赛**：OpenClaw 在窗口内连发 2026.10.6 → 10.7 → **10.8**（及 10.10-beta.4），主题是 Gateway 更新后恢复、会话 fence 释放、安全默认收紧。
2. **主流 Harness 把 MCP 2.x / 流式契约 / 会话存储做成破坏性升级**：Microsoft Agent Framework python-1.23.0、langchain-core 1.7.0、LangGraph 1.2.18、Google ADK 2.13.0 同窗落地。
3. **工具入口继续「去配置化 + 会话拦截」**：Arcade Plugin（装插件即用共享 gateway）与 Composio Session hooks（执行前/结果前阻断）同日（10-22）强化「工具网关不必自建、但调用必须可拦」。

云厂侧：Databricks 在窗口末把 **外部 AI agents 默认 OAuth 连 Unity Gateway MCP** 推到 GA；AWS AgentCore 十月笔记继续堆 Gateway 推理回退 / Step Functions MCP / CLI v1，但多数仍缺逐日日期，按月级限述。

## 二、8 模块状态

### 模块 1｜Harness / Agent OS 控制层

**实际状态：OpenClaw 稳定线连发 + 三大框架破坏性契约升级。**

**OpenClaw（必覆盖，深写）**
公开仓 releases（证据 A）：

- **2026.10.6（10-22）**：强制 Node 24.22.1+ / 26.12.1+（应对证书链安全）；更新/恢复路径与投递韧性；无新功能面。
- **2026.10.7（10-24）**：Replay-safe session recovery；update 激活与 DB/worker 连续性；Gemini 4 Argon 模型支持。
- **2026.10.8（10-27）**：主稳定线——更新后 Doctor 失败会重启 Gateway 而非停死；kill/中断后会话继续收消息；exec allowlist / browser proxy 拒绝 / 沙箱子进程禁 host CLI；MCP session close 超时不再搞挂下一轮；Windows S4U exec。
- **2026.10.10-beta.4（10-27）**：同会话 scheduled follow-up 保留 operator 权限边界；`hooks.token` 不进 host-exec 环境；运行中 Gateway 接受 `config.patch`。

迁出标注：用户正在把 OpenClaw 定时任务迁到 Grok Bot；ECS `~/.openclaw` 仍在，本轮 SSH 未读到本机版本号。上期实例 2026.10.5；公开最新稳定 **2026.10.8**。

**OpenAI Agents SDK**
窗口内无新 tag；最新仍 v0.24.0（10-15，窗外）。Agents API Oct 16 Artifact/Ultrafast 窗外。记「本周无重大公开动态（SDK）」+ 核验 GitHub releases / API changelog。

**Anthropic Claude Agent SDK**
0.3.301/302 落 10-15/16（窗外，含 sdk MCP per-tool permission_policy）。窗口内无新版本 → 无重大公开动态。

**LangChain / LangGraph / LangSmith（深写）**
- langchain-core **1.7.0（10-22）**：`tool-call-delta` 增量流；旧客户端可能停更 UI；须先升客户端再升服务端。A。
- langgraph **1.2.17（10-24）/1.2.18（10-26）**：DeltaChannel 默认快照频率 1000→100；error_handler 全路径恢复；interrupt/recursion 停跑仍 stream 末 checkpoint。checkpoint 4.3.1 拒 NUL namespace。A。
- LangSmith Cloud 周更 10-19~26：新侧栏、`reference_outputs`、Store namespace 校验、组织 bulk export 限额。A。

**Google ADK 2.13.0（10-22/标签 10-23，深写）**
TypeSafe/Jev 分类器、Live Audio barge-in、实验 MongoDB Session/Memory、MongoDbToolset 可部署 Agent Engine、telemetry 默认 OTel GenAI v2（Breaking）、官方称 string-model 回合可至约 8x（未独立复测）。A（性能 B）。

**Microsoft Agent Framework python-1.23.0（10-22，深写）**
BREAKING：MCP 2.x client lifecycle；AG-UI 必须显式 authorization scope / single_user；DockerShell `unsafe_extra_run_args`。A2A 白名单转发 kwargs；可选 trailing user turn。A。

**Databricks Mosaic / Agent Bricks**
十月笔记逐日可核：窗口内 **10-27 Default OAuth apps for external AI agents GA**；Agent memory pipelines Beta 日期标 10-12（窗外，背景）。Skills API 等上期已报。

**动态池** CrewAI/Dify/n8n/Flowise：未命中窗口内 infra 级动态。

**价值链**：Harness 层把「协议生命周期 / 流式契约 / 会话存储后端 / 更新恢复」下沉为默认；对上层应用迁移成本上升，对工具网关议价被「框架内建 MCP」挤压。

### 模块 2｜Runtime / Session / State

- OpenClaw Gateway/sessions：见模块 1。
- AWS AgentCore：十月笔记含 Runtime FUSE 挂载、Memory TTL/按量、Gateway 推理与回退——**月级，窗口归属未坐实**。
- Google：随 ADK Mongo session 服务（实验）。
- Microsoft Foundry Hosted Agents：窗口内官方 what’s-new 未取得新条目（Routines 等媒体综述偏 10-19 窗外）。
- 阿里云百炼 / 火山·Coze / 腾讯 ADP：**本次未取得窗口内条目**。
- E2B 幂等创建与重试：偏沙箱，见模块 3。

### 模块 3｜Sandbox / Computer Use / Browser

**E2B 2.59.0（10-22）→ 2.60.0/2.61.0（10-26）**：dnsServers、弃用分散 URL、控制面重试语义、创建 idempotencyKey、undici CVE。A。
Browserbase/Stagehand/Daytona：无窗口内 release。Modal Training API 非本模块主线。ADK 含 computer-use schemas / OpenSandbox（交叉）。

### 模块 4｜Tool Gateway / Protocol

- MCP 规范本体无新版本（仍 2026-07-28）。
- **Arcade Plugin（10-22）**：IDE/CLI 插件 → 共享 gateway + Tool Recommendation（>1K tools，catalog 不进上下文）。A。
- **Composio Session hooks（10-22）**：pre/post 阻断。A。
- Databricks Unity Gateway：10-27 外部 agents 默认 OAuth GA；MCP jailbreak screen 10-21 窗外。
- AWS Gateway InvokeModel/fallback/Step Functions connector：十月笔记，日戳缺。
- Nango/Pipedream：窗口内未取得。

### 模块 5｜Identity / Auth / Permission

强信号：MS AF AG-UI 强制授权 ownership；Databricks 默认 OAuth client IDs；Composio hooks；Arcade 每调用解析默认 project。云厂 Agent Identity（AgentCore Identity / Entra / Google）窗口内独立新发未取得。

### 模块 6｜Context / Memory / Knowledge

- ADK MongoDbMemoryService（实验，关键词记忆、无向量索引）。
- OpenViking/Mem0/Letta/Zep/supermemory：无窗口内 release。
- Firecrawl：10-22 有镜像/标签活动与 Government & Legal Index 公告（细节限述）。
- Crawl4AI：无本周。
- Databricks Agent memory pipelines：Beta 日 10-12 窗外。

### 模块 7｜Observability / Eval / Guardrails

- Langfuse 10-22：blob export `score_metadata`/`score_provenance`。A。
- Phoenix：有 10-23~25 维护发版（未深写）。
- Braintrust：精确日落窗未钉死。
- Databricks MCP jailbreak screen：10-21 窗外。

### 模块 8｜Managed Platform / Enterprise Control Plane

- Databricks：10-22 Shared Serverless / pyproject 环境；10-26~27 安全默认、Unity Gateway OAuth GA、GPT-6.1 Terra 上等——**企业控制面 + 外部 agent 接入**。
- AWS AgentCore：十月 Registry 扩区、CLI v1、Gateway/Memory/Eval——月级限述。
- 其余云厂：见模块 2。

## 三、云厂能力矩阵（窗口内已取证）

| 平台 | Runtime/Session | Memory/Context | Gateway/Tools | Identity/Auth | Sandbox | Obs/Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS AgentCore | FUSE 挂载等（十月笔记，日未核） | TTL+短期按量（十月，日未核） | InvokeModel/fallback/Step Functions MCP（十月） | 本周独立新发未取得 | Browser/CI 十月笔记交叉 | FailureAnalysis 洞察（十月） | Gateway 推理层加厚（**月级限述**） |
| Google | ADK Mongo session（实验） | Mongo memory（实验） | 随 ADK/Agent Engine | 未取得独立新发 | OpenSandbox/computer-use schemas | OTel GenAI v2 默认 | **ADK 2.13.0** |
| Microsoft | Foundry 窗口内条目未取得 | 未取得 | AF MCP 2.x | AG-UI auth ownership 强制 | DockerShell unsafe 显式化 | 未取得 | **AF python-1.23.0** |
| 阿里云 | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 未取得 |
| 火山/字节 | 本次未取得 | OpenViking 无本周 release | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 未取得 |
| 腾讯云 | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 本次未取得 | 未取得 |
| Databricks | Shared Serverless 等 | memory pipelines Beta（10-12 背景） | **Default OAuth for external agents GA（10-27）**；Skills API（背景） | 默认 OAuth client IDs | Apps 包仓（背景） | MCP jailbreak（10-21 背景） | **外部 agent 默认 OAuth GA** |

## 四、TOP 5

排序：信号价值 × 证据可核度 × 对搭生产 Harness 的直接影响。

1. **OpenClaw 2026.10.8（+10.6/10.7）**：Agent OS「更新不断线 + 会话可恢复 + 安全默认」三联发。A。
2. **Microsoft Agent Framework 1.23.0**：MCP 2.x + AG-UI 授权 ownership 双 Breaking。A。
3. **Google ADK 2.13.0**：Mongo session/memory 实验 + telemetry v2 Breaking + 分类器/Live。A。
4. **LangGraph 1.2.18 + langchain-core 1.7.0**：长线程 Delta 快照默认加密 + 工具流式契约迁移。A。
5. **Arcade Plugin + Composio Session hooks（同日 10-22）**：工具入口「零配置接入」与「会话可阻断」并进。A。

候补：E2B 2.59–2.61；Databricks 外部 agent 默认 OAuth GA；Langfuse score provenance 导出；AWS AgentCore 十月 Gateway（月级）。

## 五、OpenClaw 战略参照（6 条）

1. **对齐点：更新激活必须可恢复。** 10.8 明确 Doctor 失败重启 Gateway、interrupted update settle——自建迁移流程应同样「失败可回、成功可证」。
2. **对齐点：会话 fence / restart-recovery。** kill 后释放 fence、子会话重启恢复——对照自有 sessions_spawn。
3. **补课：MCP 客户端生命周期。** MS AF 迁 MCP 2.x；超时 close 不得污染下一回合（OpenClaw 10.8 已修）。
4. **补课：工具结果/调用闸门。** Composio hooks、Arcade 治理运行时——对照 tool runtime 前后拦截点。
5. **补课：流式工具参数契约。** langchain-core tool-call-delta——若对接 LangGraph UI/SDK 需客户端协同升级。
6. **旁参：默认 OAuth / 外部 agent 接入。** Databricks 10-27 降低 MCP 接入摩擦——对照 Gateway 对外身份产品化。

## 六、价值链传导

模型/算法 → Harness（本周契约升级）→ 协议/工具（插件化网关 + hooks）→ 平台（Databricks OAuth GA；AWS Gateway 月级）→ 集成交付（迁移成本上升）→ 终端场景（会话不断线成为体验底线）。

定价权信号：工具推荐/共享 gateway（Arcade）与会话阻断（Composio）把「目录规模」变成「检索+治理」；框架内建 MCP 2.x 降低第三方薄网关议价。

## 七、局限

- AWS AgentCore 十月多条无逐日日期 → 不作「本周新增」硬结论。
- 国内三云与 Nango/Pipedream/部分记忆厂商：公开检索未取得，≠无动态。
- OpenClaw ECS 本机版本未读到；性能数字（ADK 8x 等）厂商自述未复测。
- Firecrawl/Phoenix 细节未全文深读。
- parallel-cli 未登录；主要用 WebSearch + WebFetch/GitHub。
- 未做任何产品实测。

## 八、分片索引

- shards/A-part-01.md, A-part-02.md
- shards/B-part-01.md, B-part-02.md
- shards/C-part-01.md
- shards/D-part-01.md
