# 全球 AI Agent 基础设施研究周报（2026-10-22 / 第 18 期）研究母稿

- run_id: `agent-infra-20261022T060000+0800-fdf1d555`
- 冻结窗口: 2026-10-15 00:00:00 ~ 2026-10-21 24:00:00（Asia/Shanghai）
- 汇总完成: 2026-10-22 06:5x +0800
- 口径: 仅采用研究分片中已取证内容；官方 release/文档/commit 为一手依据，厂商自测数字保留其口径；"本次未取得/未披露/未独立确认"原样保留，不推断为"无能力"。

## 1. Harness / Agent OS 控制层

### 本周模块结论

1. **竞争焦点从"能跑 Agent"转到"会话生命周期与审批语义"**。OpenAI Agents SDK v0.24.0 修 pending approvals 与自动 compaction 冲突、会话写入批量化；Microsoft Agent Framework 1.22.0 警示持久化状态跨版本不兼容；LangGraph 1.2.16 连修 4 个 resume 语义 bug。长任务进入生产后，"暂停—恢复—审批"一致性成为主要缺陷源。
2. **开源 Harness 把"沙箱 + 会话 + 观测"做成同一交付物**。trueforge 0.180.0-rc.1 同版发布 Daytona 沙箱 ENTRYPOINT/超时、`x-tfg-*` 会话级请求头与 `GET /metrics`，卖点从编排 DSL 转为可运维运行时。
3. **平台把调度器收进控制面**。Microsoft Foundry 10-15 宣布 Routines GA，并明确"不替代多 agent 编排或审批流"；调度、身份、运行历史留在项目内。
4. **OpenClaw 被第三方侧面确认**：火山方舟 Agent Plan 文档把 OpenClaw 与 Claude Code、Codex CLI、Cursor 并列为可接入 AI 工具，并单列接入页与 1M 上下文方案。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 无对外版本公告；实例 2026.10.5 (1b58cb9)；被方舟列为接入工具 | 本机 `openclaw --version`；方舟文档（10-22 抓取） | 是（架构观测） |
| OpenAI Agents SDK | 有动态：v0.24.0（10-15） | github.com/openai/openai-agents-python/releases | 是 |
| Anthropic Claude Agent SDK / MCP | 获取失败：news 页仅返回站点壳，窗口内正文未取得 | anthropic.com/news（10-22） | 否（限述） |
| LangChain / LangGraph / LangSmith | 有动态：langgraph 1.2.16、checkpoint-postgres 3.2.0、sdk-py 0.4.8、cli 0.4.37 | github.com/langchain-ai/langgraph/releases（10-16~10-19） | 是 |
| Google ADK | 窗口内无 release（v2.12.0 为 10-13T16:35Z，折 10-14 00:35，越窗） | github.com/google/adk-python/releases | 是（平台侧补） |
| Microsoft Agent Framework | 有动态：python-1.22.0（10-15）、dotnet-1.25.0（10-14T19:10Z=10-15 03:10） | github.com/microsoft/agent-framework/releases | 是 |
| Databricks Mosaic AI / Agent Bricks | 本周无重大公开动态（未取得窗口内官方条目） | databricks.com 产品页（无日期） | 否 |
| trueforge（热度补入） | 有动态：0.180.0-rc.1（10-21） | github.com/truefoundry/trueforge/releases | 是 |
| CrewAI / Dify / n8n / Flowise（动态池） | 未取得基础设施级动态 | 本轮检索未命中 | 否 |

### 深度笔记

#### trueforge
- 本周动态：10-21 发布 `@truefoundry/trueforge@0.180.0-rc.1`（16:50 +0800）。四层变更：① 保留 Daytona 自定义环境 buildInfo 的 supervisord `ENTRYPOINT`（否则默认 `sleep infinity`，NATS bridge 起不来），`requestTimeoutMs` 设 60s，每次 exec 施加“命令超时 + 5s”HTTP deadline；② 创建/替换 inline session 与运行 turn 时允许 `x-tfg-skills`/`x-tfg-mcp`/`x-tfg-models`，skill 必须是 git skill，MCP/model 缺名回退 registry，其他路由拒绝；③ 日志统一带 tenant/request/session/turn id；④ 新增 `GET /metrics` Prometheus 端点（速率/状态码/延迟）。
- 关键数据：6,335 stars / 534 forks（gh api 2026-10-21T21:27Z）；exec deadline=命令超时+5s。
- 原文链接：https://github.com/truefoundry/trueforge/releases （2026-10-21）
- 影响判断：自托管 Harness 的运维面被当作产品面；`x-tfg-*` 只在会话创建/替换时校验、不落库，是“会话声明与持久规格分离”的可借鉴设计。

#### OpenAI Agents SDK / Responses
- 本周动态：`openai-agents-python` v0.24.0 于 2026-10-15T02:20:12Z 发布。四项均指向长会话治理：MCP 在转换后工具上暴露 annotations（#5356）；run-wide 工具异常格式化（#5326）；conversation session 写入按 API 上限批量提交（#5334）；修复“存在 pending approvals 时自动 compaction 被提前触发”（#5363）。
- 关键数据：v0.24.0；PR #5356/#5326/#5334/#5363。
- 原文链接：https://github.com/openai/openai-agents-python/releases/tag/v0.24.0
- 影响判断：审批挂起、上下文压缩、会话写入被视为同一组状态机问题；human-in-the-loop 必须与 compaction、写入顺序一起设计。

#### LangGraph / LangChain
- 本周动态：`1.2.16`（2026-10-16T22:11:28Z）修 4 个 resume 语义：resume 值非法时其他 task 正常结束（#9265）、resumed `Command` 更新只应用一次（#9322）、阻止子图 resume 重跑已完成 task（#9315）、pending writes 只保存一次（#9314）。同窗口 `checkpoint-postgres 3.2.0` 为 `PostgresSaver` 加 `prune`（#9290）；`sdk-py 0.4.8` 让 thread stream 错误上抛（#9317）；`cli 0.4.37` 把 `deploy` 默认切 serverless（#9333）。LangSmith 本周独立发布条目本次未取得。
- 关键数据：1.2.16（10-16）、checkpoint-postgres 3.2.0、sdk-py 0.4.8、cli 0.4.37（10-19）。
- 原文链接：https://github.com/langchain-ai/langgraph/releases/tag/1.2.16
- 影响判断：checkpoint 从“能持久化”走向“能治理”（prune 对应成本/合规，resume 修复对应人工介入后的正确性）；竞争点转向恢复正确性与存储成本。

#### Microsoft Agent Framework
- 本周动态：`python-1.22.0`（2026-10-15T09:53:40Z）支持 Python 3.15，并警告内嵌序列化 `Content`/response-update 的聊天历史、session store、protocol snapshot、workflow checkpoint 可能跨版本不兼容（普通 session metadata 不受影响）。`dotnet-1.25.0`（2026-10-14T19:10:54Z，北京 10-15 03:10）加入 approval 复用（#9389）、永不响应的 tool-approval 自动拒绝（#9152）、A2A 1.0.0-preview3（#9386）、Purview 覆盖 citations/error details（#9375）。
- 关键数据：python-1.22.0；dotnet-1.25.0；A2A 1.0.0-preview3。
- 原文链接：https://github.com/microsoft/agent-framework/releases/tag/python-1.22.0
- 影响判断：Agent 状态被承认为带 schema 的资产，升级需要迁移策略；会话/审批记录应带显式 schema 版本。

#### Google ADK / Gemini Enterprise Agent Platform
- 本周动态：ADK 窗口内无 release（v2.12.0 于 10-13T16:35:19Z 发布，越窗；内容为长会话首个模型请求耗时降 40%、`after_tool_callback` 过滤工具输出、workflow 人工确认）。平台侧两条：10-21 CodeMender v0.16.0（`cm find` 默认并发 deep scan、新增 `cm health` 预检、单轮读文件上限 256 KiB、`run_command` 超时 120s/300s、修沙箱写 `audit.log` 失败、部分失败报 INCOMPLETE）；10-14 DeepSeek-V4.1-Flash 以 MaaS 进入 Model Garden（1M 上下文，Public Preview）。
- 关键数据：CodeMender v0.16.0（10-21）；256 KiB；120s/300s；DeepSeek-V4.1-Flash 1M 上下文（10-14）。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- 影响判断：平台用“垂直安全 Agent + 模型中立目录”扩张；ADK 本周空窗。

#### Anthropic / Databricks / OpenClaw（限述）
- Anthropic：`anthropic.com/news` 仅返回站点壳；列表页摘要显示 10-21 有 Claude Opus 5.5 条目，但正文未读，不写成已核实事实（且属模型层）。本次未取得窗口内 Agent SDK/MCP 正文。
- Databricks：本周无重大公开动态，产品页/docs 无发布日期可核；维持“数据治理强、Harness 原语弱”判断。
- OpenClaw：实例 `OpenClaw 2026.10.5 (1b58cb9)`；控制面为 Gateway + `sessions_spawn`（depth 1/5、runtime=subagent、runTimeoutSeconds）+ 策略过滤/延迟工具目录 + exec 审批 + isolated cron + memory-core + 两层技能。外部信号为方舟接入页（10-22 抓取）。局限：无公开版本化 changelog 与 schema 化持久化说明。
- 原文链接：https://www.anthropic.com/news ；https://docs.databricks.com/aws/en/agents/ ；https://docs.volcengine.com/docs/ark/agent-plan-personal-plan-overview

### 模块洞察
Harness 控制层正标准化会话/审批语义，并把调度与运行历史平台化；开源与 SDK 同时押注恢复正确性和状态兼容，这一层已过能力演示期，进入可靠性与迁移成本竞争。

## 2. Runtime / Session / State 执行层

### 本周模块结论

1. **托管 Runtime 的竞争点从“能跑容器”转到“会话能否被中断、恢复、按用量计费”**。Foundry 把 Routines 推 GA、长任务韧性进 preview；AWS AgentCore 补 Memory TTL 与短期记忆分项计费。会话成为有生命周期、留存策略与账单口径的资源。
2. **“定时 + 事件触发”成为 Agent Runtime 一等原语**。Routines 支持 timer、周期 schedule、GitHub issue、Teams 频道事件，配置/身份/运行历史留在项目内，与 OpenClaw sessions+cron 同构。
3. **状态治理细化到“留存”和“错误语义”**。E2B 10-19 把 pauseMode 暴露到查询接口并区分 not-running/unreachable；AWS 给长期记忆加 TTL 与独立 IAM 权限。
4. **国内三家本周以治理/迁移/下线为主**。百炼、方舟、腾讯 ADP/元器窗口内可核条目为模型下线、元器停发 API key 与迁移指引，均非新运行时能力。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Runtime | 有动态（10 月月度说明 + SDK 1.24.1，具体日不定） | AWS release-notes；PyPI 1.24.1（10-19） | 是 |
| Microsoft Foundry Hosted Agents | 有动态（Routines GA、长任务韧性 preview） | devblogs.microsoft.com/foundry（10-15） | 是 |
| OpenClaw sessions / cron / Gateway | 有动态（本地版本恢复/worker 推理；发布日未标） | 本机 CHANGELOG；`openclaw --version` | 是（限述） |
| Google Agent Engine / Managed Agents | 无 runtime 级动态（仅 Workbench v2 依赖/CVE 维护） | Vertex release notes（10-19） | 否 |
| 阿里云百炼 / PAI | 本周无重大公开动态（仅模型下线/文档更新） | help.aliyun.com（最新 2026-02-10） | 否 |
| 火山方舟 / Coze | 本周无重大公开动态（可核条目在窗口外） | 官方检索无窗口内公告 | 否 |
| 腾讯云元器 / ADP | 治理动作（API key 停发、迁移 ADP），日期在窗口前 | yuanqi.tencent.com（10-08/10-13） | 否（背景） |
| E2B / Modal / Daytona | 有动态（生命周期/GPU/指标） | 各 changelog（10-15~10-19） | 是（见模块 3） |

### 深度笔记

#### AWS Bedrock AgentCore Runtime
- 本周动态：10 月发布说明四项均在运行时周边：① `Builtin.FailureAnalysis` 失败归因评估器，跨 session 聚类为 insight，结果在 `GetBatchEvaluation.insightResults`；② 长期记忆 TTL（`recordExpirySpecification`，需 IAM `bedrock-agentcore:UpdateMemoryRecordExpirySpecification`）；③ 短期记忆按 ingestion/retrieval/storage 分项计费，自动生效；④ Gateway 支持私有 CA TLS，PEM 存 S3/Secrets Manager，直连 VPC Lattice 私有端点。SDK `bedrock-agentcore` 1.24.1 于 10-19 发布。
- 关键数据：SDK 1.24.1（2026-10-19）；条目属“October 2026”整月归档，未逐条标日。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ；https://pypi.org/project/bedrock-agentcore/
- 影响判断：把 Agent 会话当数据库管：留存可配、成本可归因、失败可聚类。Runtime 本体难拉开差距，差异化移到治理与成本口径。

#### Microsoft Foundry Hosted Agents
- 本周动态：9 月月度更新博文发布于 **2026-10-15**。Routines GA（一个触发器启动一个 agent；timer/周期/GitHub issue/Teams 事件；配置、身份、运行历史留在 project 内；官方明确不替代多 agent 编排与审批）；长任务 hosted-agent resilience 进 public preview（只读后台报告、断开客户端后取回结果，但 checkpointing 与幂等仍需应用自做，重连不会让重复外部动作变安全）；Tool Search、A2A GA；Insights（trace 根因与修复建议）preview。
- 关键数据：发布 10-15；四类触发器；`azure.ai.agents` beta.18（09-30）要求 runtime 定义写入 azure.yaml 或显式 root `$ref`，长任务用 `--long-running`。
- 原文链接：https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-september-2026/
- 影响判断：Azure 把 cron for agents 收进控制面，同时克制地划清 Runtime 与 Orchestration 边界。功能多在 9 月上线，属“发布事件在窗口、功能时点在窗口前”的混合情形。

#### OpenClaw sessions / cron / Gateway runtime
- 本周动态：本机 `OpenClaw 2026.10.5 (1b58cb9)`。CHANGELOG Highlights 三条 runtime 能力：① 重启安全会话——被中断 turn、worktree 首条消息、subagent 工作与 deferred tasks 在 Gateway 重启后恢复，会话数据挺过重启/并发写/发布失败；② worker-local inference runtime——Gateway 派发、客户端放置、worker 策略与目标校验前置，给出可读初始化失败原因；③ 会话定向发送不授予 transcript 读取权，设备加入后可装后台 node service 承载 agent session（`--service --session-host`）。另有 automation repair：失败自动化先由属主会话修复。
- 关键数据：版本 2026.10.5，commit 1b58cb9（10-22 实测）；CHANGELOG 涉及 PR #165333/#166042/#168650/#169144/#158902/#163645/#164444/#168623/#161007。
- 原文链接：本机 `CHANGELOG.md`（2026.10.5 章节）；无公开 URL。
- 影响判断：重启不再等于丢 turn，subagent 结果可穿过重启返回；差异在本地 Gateway + 多设备 node 承载，恢复边界在进程与 SQLite。CHANGELOG 未标发布日，**不计为窗口内发布**，仅作 OpenClaw 参照。

#### Google Vertex AI Agent Engine / Managed Agents
- 本周动态：**本周无重大公开动态**。窗口内最近条目为 2026-10-19 `Agent Platform Workbench v2` 20261018.00_p0：升级依赖、修 Jupyter Server 终端配置覆盖 Dataproc 插件设置、容器启动无法应用终端禁用设置。无 Agent Engine/Managed Agents 功能、区域或计费变更。
- 关键数据：条目日期 2026-10-19；受影响组件 Agent Platform Workbench v2。
- 原文链接：https://docs.cloud.google.com/vertex-ai/docs/release-notes
- 影响判断：在 AWS/Microsoft 补会话生命周期的对照下，Google runtime 层本周“静默”，是转向 Gemini Enterprise 控制面还是节奏问题，本次无法判断。

#### 阿里云百炼 / 火山方舟 / 腾讯云（限述）
- 本周动态：三家窗口内均未取得 runtime 级官方发布。百炼 `application-release-notes` 最新条目 2026-02-10；方舟检索仅得产品/营销与历史文（ArkClaw 为 2026-04）；腾讯元器公告自 2026-10-29 起停止创建新智能体 API key 分发，存量可用，并给迁移 ADP 指引（页面更新 10-13，窗口前）。
- 关键数据：百炼最新条目 2026-02-10；元器生效日 10-29、指引更新 10-13。
- 原文链接：https://help.aliyun.com/zh/model-studio/application-release-notes ；https://yuanqi.tencent.com/cl/adp-guide
- 影响判断：国内平台近期主题是“收敛与迁移”，采购方实际成本是迁移与 API key 生命周期，不宜写成能力升级。

### 模块洞察
Runtime 竞争已从“能不能托管”转为“会话能否可靠中断、恢复、计量与归因”；调度原语正在标准化，差异化下沉到留存策略、成本口径与恢复保证。

## 3. Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论

1. **浏览器执行层的价格锤点被拉到“按小时几分钱”，商业重心转向组合能力**。browser-use 仓库描述与第三方文称 $0.02/浏览器小时（官方定价页未列该单价，**未独立确认**）；Browserbase 卖的是“浏览器 + 搜索 + 凭证托管”组合。裸算力商品化，治理与集成溢价。
2. **竞争从“能不能点”转到“出错时是否安全失败”**。vercel-labs/agent-browser 窗口内 10 条提交至少 4 条是安全默认值：策略加载 fail-closed、拒绝 schema 未声明参数、点击隐藏/禁用/视口外元素直接失败、拒绝歧义 stale-ref 恢复。
3. **沙箱厂商补“状态语义”而非“启动速度”**。E2B 10-19 暴露 `pauseMode`（full/filesystem）并区分 not-running/unreachable；Daytona 10-16 加 NVIDIA B200；Modal 10-15 上 metrics 与 Service Users。
4. **大厂本周无新的 sandbox/browser 能力披露**。AWS Browser/Code Interpreter 仅在未标日的月档；OpenAI 10-20 浏览器改进正文未取得；Azure、Google 窗口内无可核条目。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| browser-use | 有动态：0.13.13（10-15T23:50Z=10-16 07:50） | GitHub release | 是 |
| vercel-labs/agent-browser | 有动态：窗口内 10 commits（安全默认值） | gh api commits | 是 |
| E2B | 有动态：pauseMode、SDK 2.56.0（10-19） | docs.e2b.dev/changelog | 是 |
| Daytona | 有动态：0.225.0 B200（10-16） | daytona.io/changelog | 是 |
| Modal | 有动态：Python SDK 1.6.2（10-15） | modal.com/docs/sdk/py/releases | 是 |
| Browserbase / Stagehand | 本周无重大公开动态（10-14/10-12 均窗口外） | browserbase.com/changelog | 否（背景） |
| OpenAI Computer Use / Browser | 获取失败（release notes 正文只渲染到 06-10） | help.openai.com | 否 |
| Anthropic Computer Use | 本周无重大公开动态（未取得窗口内条目） | — | 否 |
| AWS AgentCore Browser / Code Interpreter | 月档有条目但无具体日期，不能证明窗口内 | AWS release-notes | 否（限述） |
| Azure Browser Automation / Playwright | 本周无重大公开动态（未取得条目） | — | 否 |
| Google Code Execution / sandbox | 本周无重大公开动态（同模块 2） | Vertex release notes | 否 |

### 深度笔记

#### browser-use
- 本周动态：`0.13.13` 于 2026-10-15T23:50:45Z 发布，主题为 **OpenAI browser-tool driver**：browser-use 直接充当 OpenAI 浏览器工具驱动层，提供 18 个默认浏览器工具 + 6 个可选动作（Browser Use Actor），支持本地浏览器、Browser Use Cloud 与“借用”会话三种后端。修复 Cloud tab URL 短暂为空、缩放显示器坐标不对齐。需 `openai-tools` extra 与 OpenAI Python ≥3.31。官方称 11 个 driver 测试全过，两个新回归测试在旧实现上失败，取代被取消发布的 0.13.12。
- 关键数据：0.13.13；18 默认工具 + 6 可选动作；OpenAI Python ≥3.31；定价页：$1 免费额度、最低充值 $5、按分钟向上取整、住宅代理 $5/GB、并发档 $0/$100/$1,000/$5,000/$25,000 对应 10/50/250/500/1,000 会话（无发布日）。
- 原文链接：https://github.com/browser-use/browser-use/releases/tag/0.13.13 ；https://browser-use.com/pricing
- 影响判断：把开源库做成模型厂 browser tool 的默认驱动，是切入工具链的典型路径；`$0.02/浏览器小时` 仅见仓库描述与第三方文，不用于成本测算。

#### vercel-labs/agent-browser
- 本周动态：窗口内无新 release（最新 v0.39.1 为 10-13），实质变化全在 main：10-21 `fix(policy): fail closed when the policy file cannot be loaded`（#2179）；10-20 MCP 拒绝 schema 未声明参数（#2175）；10-20 点击 hidden/disabled/off-viewport 元素报错（#2173）；10-20 拒绝歧义 stale-ref 恢复（#2145）；另修 CDP 跨后续命令保持附着（#2155）、同一事件批内的失效 target/session（#2176）。
- 关键数据：44,391 stars / 3,035 forks；pushed_at 2026-10-21T19:47:45Z；窗口内 10 commits；最新 release v0.39.1（10-13）。
- 原文链接：https://github.com/vercel-labs/agent-browser/commits/main
- 影响判断：44k stars 项目把工程重心放在“拒绝执行”而非多支持动作，说明真实痛点已从能力覆盖转向误操作与越权。

#### E2B
- 本周动态：2026-10-19 周更：`GET /sandboxes/{id}` 对已暂停沙箱返回 `pauseMode`（`full`/`filesystem`），Dashboard 对 FS-only 暂停打标；JS SDK 2.56.0 要求 Node ≥22.19.0 并跟随服务端 HTTP/2 流上限（移除三个 inflight 环境变量），Python SDK 2.56.0 要求 Python ≥3.11，达流上限时新建连接（`E2B_MAX_CONNECTIONS` 默认 200）。另修暂停恢复变慢、volume 挂载失败仍报成功、多 tag 连接失败、HTTP/1.1 请求体截断、指标漏点等。
- 关键数据：changelog 10-19；SDK 2.56.0；Node 22.19.0 / Python 3.11；`E2B_MAX_CONNECTIONS=200`。
- 原文链接：https://docs.e2b.dev/changelog
- 影响判断：`pauseMode` 是给上层编排的恢复语义字段——知道会不会丢内存，Agent 才敢在暂停后继续多步任务。

#### Daytona
- 本周动态：0.225.0（2026-10-16）在 API client 新增 **NVIDIA B200 GPU** 类型，沙箱可按 B200 规格申请。此前 0.224.0（10-12，窗口外）支持逐调用指定 region。
- 关键数据：0.225.0；日期 10-16。
- 原文链接：https://www.daytona.io/changelog/nvidia-b200-gpu-type
- 影响判断：沙箱开始承接 GPU 型 Agent 负载（本地推理、渲染、训练型 Agent）；与 E2B 的 MicroVM 生命周期路线形成分工。

#### Modal
- 本周动态：Python SDK 1.6.2（2026-10-15）：新增 `modal function metrics` / `modal server metrics`（JSON/CSV 导出，`Function.metrics`/`Server.metrics` 代码查询）；Service Users 编程管理；autoscaler `settings()`/`update()`；`function calls`/`server requests` 支持 `--since`/`--until`；支持 Python 3.15；`Sandbox.from_name(include_terminated=True)`；`modal run -` 从 stdin 读脚本。
- 关键数据：1.6.2；2026-10-15。
- 原文链接：https://modal.com/docs/sdk/py/releases
- 影响判断：Service Users + 配置溯源 + 调用时间过滤，是把 serverless 当企业基础设施管；差异化在运营面与控制面。

#### Browserbase / Stagehand（背景）与大厂扫描（限述）
- Browserbase 本周无重大公开动态；最近条目 10-14 Parallel 搜索、10-12 Stagehand 4.2，均在窗口外。其路线是“浏览器 + 搜索 + 函数 + 人工接管”。
- AWS Browser 的 OS 级交互、`ActiveSessionCount`、Code Interpreter 作为 LangChain Deep Agents sandbox provider，均未标日，只记“2026 年内已发布”，不作本周动态。OpenAI 10-20 浏览器改进仅有搜索摘要，正文未取得，不采用。Anthropic/Azure/Google 窗口内未取得可核条目。

### 模块洞察
沙箱与浏览器执行层两极分化：E2B/Daytona/Modal 把隔离环境做成可暂停、可计量、可审计的运维对象；browser-use/agent-browser 用开源与安全默认值抢占模型厂工具链默认执行位。裸算力持续商品化，定价权移到治理、凭证与集成。

## 4. Tool Gateway / Protocol / Integration 工具层

### 本周模块结论

1. **工具网关竞争点从“接得上”转向“选得准、管得住”**。Arcade 10-15 发布 Tool Recommendation：Agent 不再持有全量工具定义，按任务检索少量工具（官方称最多省 91% 输入 token、37% token 成本），推荐与调用都过 policy 与审计。
2. **凭证代理成为开源网关必争能力，且收紧到“精确出站 URL”**。mcp-gateway-registry 1.33.0（10-16）把 vaulted credential 绑定从 origin 改为精确 URL，并在 consent 开始时固化授权目标集合；代价是已连接账号需重连。
3. **MCP 进入“事件化”酝酿期，但本周无新规范版本**。规范仓库 10-16 组建 Tasks and Events WG、10-20 合并 PR #3440；MCP Events 仍为 draft（PR #3415），不能写成“已发布标准”。
4. **大厂网关以企业接入细节迭代为主**。AWS Gateway 加 private CA 信任锚（月级归档）；microsoft/mcp-gateway 窗口内无 commit；Google Agent Gateway 仍为 10-07 preview（窗口外）。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP 协议/治理 | 有治理动作（Tasks & Events WG；Events draft） | spec repo commits 10-16/10-20 | 是 |
| A2A | 本周无重大公开动态（v1.0 为 3 月背景） | 检索无窗口内发布 | 否 |
| Composio | 有动态：SDK 0.29.0 / TS 0.26.0 / CLI 0.5.0（10-21） | gh api commits | 是 |
| Arcade | 有动态：Tool Recommendation（10-15） | arcade.dev/blog | 是 |
| Nango | 窗口内无发布（MCP Events 文 10-14，窗口外一天） | nango.dev/blog | 是（背景） |
| Pipedream Connect | 本周无重大公开动态（changelog 最新 2025-10） | pipedream.com | 否 |
| AWS AgentCore Gateway | 有动态：private CA target（10 月条目） | AWS release-notes | 是 |
| Google Agent Gateway | 窗口内无动态（preview 10-07，窗口外） | docs.cloud.google.com | 否（背景） |
| Microsoft Toolbox | 本周无重大公开动态（GA 于 7-8 月） | learn.microsoft.com | 否 |
| microsoft/mcp-gateway | 窗口内无 commit（pushed_at 10-16 仅为分支推送） | gh api | 是（限述） |
| mcp-gateway-registry | 有动态：1.33.0 凭证代理收紧（10-16） | gh release | 是 |

### 深度笔记

#### Arcade
- 本周动态：10-15 发布 Tool Recommendation，把工具选择从 reasoning 改为 retrieval。只保留三个内置工具 `Arcade_ListApps`/`Arcade_SelectTools`/`Arcade_UseTool`；由 embedding + ranking 从目录检索少量工具及 schema。8,000+ 工具全量加载需 1.75M token（Gmail 30、Salesforce 17、GitHub 43、Jira 45）；检索在 MCP 之上实现，任何 MCP client 无需改 SDK；推荐与调用均过授权、policy hook（PII/DLP）与 OpenTelemetry 审计。
- 关键数据：10 轮会话输入 token 最多降 91%（GPT-5.6 256,650→22,164；Claude Opus 5 411,729→38,170）；token 成本最多降 37%、典型约 20%；1,000 席位/Opus 5 年省约 $119K；408 会话/64 工作流端到端账单降 7.6%（95% 区间 2.5%~12.6%），完成率不变；固定 100 工具在约 25~28 个工具以下更便宜。
- 原文链接：https://www.arcade.dev/blog/tool-recommendation （2026-10-15）
- 影响判断：价值从工具数量转向检索质量与治理面；数字含厂商自测与建模口径，Recall@10 对比 Microsoft 自认 “indicative rather than exact”。

#### agentic-community/mcp-gateway-registry
- 本周动态：1.33.0（2026-10-16T03:00:48Z）主题 Virtual-Server Credential Brokering and Root-Endpoint Routing。vaulted credential 绑定从 origin 收紧到精确出站 URL；approved destinations 在 consent 开始时快照，关闭“用户授权期间新增 server 版本继承未看过的批准”窗口。破坏性：所有已连接 egress 账号需重连（oauth_user 重授权、pat 重提交），`EGRESS_AUTH_ENABLED=true` 部署均受影响；修 nginx location 命名冲突，stateful backend 获新 `Mcp-Session-Id`。
- 关键数据：1.33.0；1,010 stars / 254 forks；pushed_at 2026-10-21T21:33Z。
- 原文链接：https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.33.0
- 影响判断：企业网关差异化落在“授权对象确切性”和“同意时机”，而非工具数量；token 绑定不应停在域名级，consent 快照必须与回调解耦。

#### AWS AgentCore Gateway
- 本周动态：10 月发布说明新增 targets 支持私有 CA TLS：PEM CA 证书存 S3/Secrets Manager，注册到 MCP server、OpenAPI、HTTP passthrough 三类 target，Gateway 拉取为出站信任锚，经 VPC Lattice 直连私有端点，不必前置 ALB。与 8 月 rate limit（按 JWT claim/IAM principal/target/tool 限流，`rate=0` 可紧急隔离）拼成“私网接入 + 多租户配额”底座。
- 关键数据：条目归档“October 2026”，未逐条标日；rate limit 在 August 2026。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- 影响判断：没有私有 CA 信任，很多内网 MCP server 无法不过 ALB 直连；但月级归档不能声称“本周发布”。

#### Composio
- 本周动态：10-21 准备 Python SDK/provider 0.29.0、TS SDK 0.26.0、CLI 0.5.0；同日让 Vercel、LlamaIndex、Claude Agent SDK 三个 provider 透出每个工具自己的 JSON Schema（#4940），并修 `certifi>=2026.10.19` 应对 eMudhra 中间证书泄露。公开 changelog 最新仍为 2026-09-29，只能按 commit/release 写。
- 关键数据：30,674 stars / 4,888 forks；pushed_at 2026-10-21T22:08Z。
- 原文链接：https://github.com/ComposioHQ/composio/commits/main
- 影响判断：护城河仍是 toolkit 数量 + 托管 auth，但竞争点转向“跨框架 schema 一致性”——Agent 换框架最易踩的坑。

#### MCP 协议与治理
- 本周动态：窗口内无新 release（最新仍 2026-07-28）；10-16 成立 Tasks and Events WG、把 Agents WG 降为 Interest Group，10-20 合并 PR #3440。MCP Events 仍为 draft extension（PR #3415，经 Nango 10-14 转述），覆盖 webhook/streaming/polling，OpenAI 已在 ChatGPT 侧实现事件订阅；支持 tools 的 client ≠ 支持事件订阅。
- 关键数据：规范 release 2026-07-28；commits 10-16T19:58Z、10-20T20:01Z。
- 原文链接：https://github.com/modelcontextprotocol/modelcontextprotocol/commits/main
- 影响判断：事件化若定稿，工具网关将从请求-响应代理变为订阅-触发总线，与 cron/工作流引擎重叠；当前只能作方向判断。

#### microsoft/mcp-gateway 与其余对象
- microsoft/mcp-gateway 窗口内无 commit：最新 commit 为 10-14 “Verify deployment ownership for adapters and tools (#110)”，`pushed_at` 10-16 只反映分支/标签推送；无 release；定位为 K8s 下 MCP server 反向代理与 session-aware routing。
- Nango：MCP Events 文 10-14（窗口外一天）；Agent Sessions 以 MCP 暴露工具而不把 provider 凭证交给模型。Pipedream changelog 最新 2025-10。Google Agent Gateway 10-07 preview。A2A 窗口内无发布。
- 原文链接：https://github.com/microsoft/mcp-gateway/commits/main ；https://nango.dev/blog/mcp-events-for-customer-facing-ai-agents

### 模块洞察
本周工具层的真实进展不是“接更多 SaaS”，而是把工具选择、凭证绑定、事件触发从应用代码收进网关治理面；谁定义这三层的默认安全语义，谁掌握工具生态议价权。

## 5. Identity / Auth / Permission 权限层

### 本周模块结论

1. **身份层增量不在新 IdP，而在“代表用户行动时的凭证边界”**。mcp-gateway-registry 1.33.0 把凭证从域名级收紧到精确出站 URL，并在 consent 开始时快照授权范围，直指“授权期间目标被替换”的越权窗口。
2. **工具调用前后的策略执行点（PEP）成为标准形态**。Arcade 以“用户可做 ∩ Agent 被允许做”的交集授权，凭据留在 vault、不进模型上下文；pre/post hook 承担 PII/DLP，审计走 OpenTelemetry。
3. **“不要把 provider token 交给模型”已成集成层共识**。Nango Agent Sessions 由后端在运行前选定连接、允许工具与过期时间；但默认包含租户全部工具，需显式收窄并关闭 generic proxy。
4. **三大云厂 Agent Identity 本周无窗口内新发布**。AWS Consent Portal 在 9 月、Google Agent Gateway 10-07 preview（窗口外）、Microsoft Entra Agent Identity 本次未取得。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 本周无重大公开动态（Consent Portal 为 9 月背景） | AWS release-notes | 否 |
| Microsoft Entra Agent Identity | 本次未取得窗口内官方发布 | 检索无条目 | 否 |
| Google Agent Identity / Gateway auth | 窗口内无动态（preview 10-07 窗口外） | docs.cloud.google.com | 否 |
| Arcade Auth / tool permission | 有动态（授权交集 + hook + 审计，随 10-15 发布） | arcade.dev/blog | 是 |
| Composio Auth | 本周无身份侧新能力（仅 SDK/provider 维护） | gh api | 否 |
| Nango OAuth / token | 窗口内无发布（Agent Sessions 文 10-14 背景） | nango.dev | 是（背景） |
| Pipedream managed auth | 本周无重大公开动态 | pipedream.com | 否 |
| mcp-gateway-registry | 有动态：1.33.0 凭证绑定收紧（10-16） | gh release | 是 |

### 深度笔记

#### mcp-gateway-registry：凭证代理的“精确资源”化
- 本周动态：1.33.0 把 egress 凭证绑定对象从 origin 改为精确 outbound URL，approved destinations 在 consent 开始时固化。威胁模型：用户跳转 provider 授权期间新增 server 版本，旧实现回调时重读目标集合，会让新目标继承未看过的批准。次要变更：nginx location 单射命名、stateful backend 重连获新 `Mcp-Session-Id`。运维代价：`EGRESS_AUTH_ENABLED=true` 需全量重授权。
- 关键数据：1.33.0 published_at 2026-10-16T03:00:48Z。
- 原文链接：https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.33.0
- 影响判断：把 OAuth 同意从一次点击变成有作用域、有时点的授权快照；安全收紧与运维体验仍在拉扯。

#### Arcade Auth / tool permission
- 本周动态：每次 action 在“用户权限 ∩ Agent 权限”交集上即时授权；用户走 provider OAuth，runtime 只申请该 action 所需 scope；凭证存 Arcade vault。执行前后 hook 接企业 policy engine/IdP，做 PII 筛查与 DLP；访问过滤在推荐与调用两处都生效；所有推荐/调用统一审计，经 OpenTelemetry 进现有栈；支持云端、自建、气隙部署。
- 关键数据：8,000+ 工具、全量约 1.75M token（2026-10-15 发布文）。
- 原文链接：https://www.arcade.dev/blog/tool-recommendation
- 影响判断：把“检索”纳入权限检查点是关键细节，否则推荐层会成为绕过 ACL 的侧信道。

#### Nango（背景）
- 本周动态：窗口内无发布。10-14 文说明 Agent Sessions 通过 MCP 暴露工具，模型拿不到 provider 原始凭证；后端运行前指定连接、允许工具与过期时间，例如把“发送回复”留到单独授权步骤。官方提示默认包含全部已连接集成，需显式限制工具并关闭 generic proxy，记录级权限仍需工具代码实现。
- 关键数据：文章日期 10-14；仓库页面显示 12.7k stars。
- 原文链接：https://nango.dev/blog/mcp-events-for-customer-facing-ai-agents
- 影响判断：“能力收窄靠配置、不靠模型自觉”务实，但默认值偏宽；工具授权应绑定 session 级快照，而非长期连接。

### 模块洞察
Agent 身份问题正被拆成“谁在行动、能碰哪个确切资源、这次运行允许哪些工具”三个可审计字段，而不是一张长期有效 token。

## 6. Context / Memory / Knowledge 记忆知识层

### 本周模块结论

1. **Memory 从“记忆 API”变成“上下文数据库”**。OpenViking v0.5.1 的重心不在召回算法，而在 Gateway 嵌入 Server、Redis/MySQL 多实例后端、字段级隐私引用、批量写入冲突检测与迁移路径——数据库该有的运维面。
2. **本周是“破坏性升级周”**。OpenViking 列 10 条迁移项（create 语义反转、session extract 移除、wait timeout 移除、trusted 模式强制 root key），cognee 移除 triplet embedding 面；能力在涨，升级成本与锁定风险同步上升。
3. **竞争焦点转向摄取与权限边界**。supermemory 16 个 commit 几乎全在收紧 MCP 的 ID/space 授权与 forget 语义；Firecrawl 上线 provider tools 零数据留存并清理请求日志表头；Graphiti 因 eMudhra 证书链投毒紧急升 certifi。
4. **知识摄取层高度集中于 Firecrawl / Crawl4AI**（193,914 / 85,990 stars），一个是 commit 洪流、一个是窗口外发版后的静默期，增量价值向治理与索引质量转移。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态：v0.5.1（10-19）、v0.5.1.1（10-20） | GitHub releases | 是 |
| Cognee | 有动态：v1.6.5（10-16T20:10Z=10-17 04:10） | GitHub release | 是 |
| supermemory | 有动态：16 commits，MCP 授权收紧（10-15~10-18） | gh api commits | 是 |
| Zep / Graphiti | 有动态：v0.31.0/1/2 三连发 | GitHub releases | 是 |
| Mem0 | 近乎静默：窗口内 1 个文档 commit | gh api | 是（短） |
| Letta | 静默：2 条 README commit | gh api（10-18） | 是（短） |
| Firecrawl | 有动态：≥100 commits，零留存/日志脱敏 | gh api | 是 |
| Crawl4AI | 本周无窗口内发布；v0.9.5 为 10-14（背景） | GitHub release | 否 |

### 深度笔记

#### OpenViking
- 本周动态：10-19 v0.5.1（自 v0.5.0 起 151 commits）、10-20 v0.5.1.1 修缺陷。主线：① Gateway 可嵌入 Server，模型/管理接口走 `/gateway`，地址从 `:1935/v1` 迁到 `:1933/gateway/v1`，引入独立 `gateway.management_key`（root/admin 也不能绕过）；② 隐私字段级引用与原子更新，`ov privacy reference` 默认只返回 owner 引用、`resolve` 才读明文，扫描默认 dry-run；③ `batch_write` 整批 `processing_mode`、每文件 tags/ACL、`expected_sha256` 与 `skip_conflicts`；④ `image_url` 支持有序多图，CLI 新增 `ov search --mode context`；⑤ Session idle auto-commit 可选 Redis 调度，Account Store 新增 MySQL 与 Redis+MySQL，多写存储升级 V2 分区日志 + checkpoint；⑥ 新增 Microsoft Agent Framework context provider；⑦ MCP 新增 `download(uri)`（约 10 分钟一次性链接）。迁移代价：`write(mode="create")` 变 replace 别名不再 409、`POST /sessions/{id}/extract` 移除、wait `timeout` 移除、trusted 模式强制非空 root key。v0.5.1.1 修“后续 commit 记忆搜不到”（#6331）。
- 关键数据：v0.5.1 2026-10-19T13:37Z；v0.5.1.1 2026-10-20T12:40Z；40,528 stars / 3,251 forks；`openviking-sdk==0.1.16`、`@openviking/cli@0.5.1`。
- 原文链接：https://github.com/volcengine/OpenViking/releases/tag/v0.5.1 ；…/v0.5.1.1
- 影响判断：竞争维度从召回效果拉到多租户、隐私字段、批量一致性、迁移与回滚，实质在抢 Agent 场景的数据库位置；短期最大风险是升级破坏性。

#### Cognee
- 本周动态：v1.6.5（2026-10-16T20:10Z，北京 10-17 04:10）主题“蒸馏可靠性 + embedding 计量 + 连接器加固”。蒸馏只读所需 QA 轮次、按 curator 批次封存、默认逐条 curate；函数/类/模块 docstring 存为一等图文档并链接代码符号；新增 Memify API/CLI；trace 整段 backlog 存单文档 + 单次 cognify 建 trace pass window；embedding 支持 base64、按 activity 记录 token 用量、默认 batch 36→32；本地模型缓存统一 `~/.cognee/models`。安全：每日 CVE 摘要推 Slack、收敛 Azure token、加固 Gmail/Google Calendar、Cypher 关闭时返回 403。破坏性：移除/弃用 triplet embedding 与 triplet memify。
- 关键数据：v1.6.5；12 个 PR；litellm ≥1.102.2,<2.0.0；lancedb 0.39.x；32,632 stars / 3,382 forks。
- 原文链接：https://github.com/topoteretes/cognee/releases/tag/v1.6.5
- 影响判断：知识图谱 + 代码图谱 + 成本计量路线；embedding token 计量把记忆成本显性化，docstring 入图服务 coding agent 召回。

#### supermemory
- 本周动态：10-15~10-18 共 16 commits，主线为 MCP 授权边界与 v5 API 文档对齐：MCP 只返回调用者可用 ID 与 space；prompts/resources 共享可访问默认空间并优先可写空间；forget 改为按 ID 精确删除而非 LLM 匹配；认证失败分级（预期拒绝 warn、认证服务不可用 error）。文档侧统一 billing/analytics/self-hosting/connectors/v5 ingestion 页面，修 namespace 迁移与 scoped keys。
- 关键数据：16 commits；最新 2026-10-18T02:37Z；31,342 stars / 2,741 forks；无窗口内 release。
- 原文链接：https://github.com/supermemoryai/supermemory/commits/main
- 影响判断：把记忆当多租户数据面，授权粒度与精确 forget 是企业采购硬条件；MCP 已是记忆产品默认交付接口。

#### Zep / Graphiti
- 本周动态：v0.31.0（北京 10-15 07:58）、v0.31.1（10-15 23:02）、v0.31.2（10-21 01:25），窗口内 23 commits。v0.31.0 引入 `LLMRuntime` 统一 prompt/模型路由；C2 组合抽取 prompt 默认；新增 Jev 与 OpenAI Decisions 客户端去重；MCP server 升 SDK 2.x 并按 `group_id` 路由图谱；FalkorDB 6.x 改 DDL 全文索引；默认模型 gpt-4.1-nano→gpt-6-luna。v0.31.2 因 eMudhra 被攻破紧急升 certifi，固定 graphiti-core 0.31.2、MCP server 1.1.3。
- 关键数据：v0.31.0 列 21 项 PR；v0.31.2 2026-10-20T17:25Z；32,113 stars / 3,280 forks；certifi 2026.10.19。
- 原文链接：https://github.com/getzep/graphiti/releases/tag/v0.31.0 ；…/v0.31.2
- 影响判断：时序知识图谱竞争转向多图谱隔离、去重质量、供应链安全；已进入需要安全响应流程的阶段。

#### Mem0 / Letta（静默）
- Mem0 窗口内 1 个 commit（10-21T01:16Z，重写 BYOK 页面 #7661），无 release（最近 v2.2.1 为 09-25，背景）；67,598 stars。Letta 窗口内 2 个 README commit（10-18，#3454 移除桌面应用表述），无 release；25,219 stars。
- 原文链接：https://github.com/mem0ai/mem0/commits/main ；https://github.com/letta-ai/letta/commits/main
- 影响判断：单点记忆 API 的差异化被平台内嵌能力侵蚀；Letta 的“记忆即运行时”叙事本周无新增证据。

#### Firecrawl / Crawl4AI
- Firecrawl 窗口内 ≥100 commits：provider tools 零数据留存（#5178）并补计费测试（#5304）；请求错误日志脱敏（#5301）；PDF 索引一致性开关 `INDEX_SKIP_ON_PDF_REFRESH`/`INDEX_PDF_SUPERSEDE_CHECK`（#5292/#5293）；v2 OpenAPI spec 替换 v1（#5303）；品牌问答默认走 Jev（#5175）。193,914 stars，无窗口内 release。
- Crawl4AI 本周无窗口内发布；v0.9.5 为 2026-10-14（背景），release 页仅指向 CHANGELOG；85,990 stars。
- 原文链接：https://github.com/firecrawl/firecrawl/commits/main ；https://github.com/unclecode/crawl4ai/releases/tag/v0.9.5
- 影响判断：摄取层竞争已是“抓得合规、索引不脏、可计费”；零留存与日志脱敏直接对准企业法务。

### 模块洞察
记忆知识层的主线不是“记得更准”，而是“像数据库一样可运维、可审计、可迁移”；多租户隔离、隐私字段、批量一致性、供应链安全决定谁能成为 Agent 上下文底座，代价是破坏性升级频繁。

## 7. Observability / Eval / Guardrails 可观测治理层

### 本周模块结论

1. **发版密度成为竞争指标**：Langfuse 一周连发 v4.63.0→v4.67.0 五版，Braintrust、Arize Phoenix 各两版，LangSmith 周更。但增量主要在“产品面扩张”（skills、topics、gateway、sandbox），而非新评估方法论。
2. **可观测平台自己开始被治理**：LangSmith 推出只写不可读的 tracing-only API key、拆分 Engine 权限、workspace secret 绑 allowed hosts、部署密钥降为 `DEPLOYMENT_RUNTIME`；Helicone 连发三条 security sync。
3. **网关吞掉可观测与评估**：LangSmith LLM Gateway 接 ScaleDown、按缓存费率计 cached token；Langfuse AI Gateway 按内存预算准入并度量网关开销。trace 成为网关策略、成本与回放的同一平面。
4. **标准层收敛**：OTel GenAI semconv 要求 `execute_tool` 用 provider 提供的 tool call ID、澄清 MCP 错误属性、token usage 仅非零上报，并启用 strict conformance。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 有动态：10-12~10-19 周更 | docs.langchain.com/langsmith/changelog | 是 |
| Langfuse | 有动态：v4.63.0/4.64.0/4.65.0/4.66.0/4.67.0 | GitHub releases | 是 |
| Helicone | 弱动态：4 个安全/上游同步 commit（10-19~10-20） | gh api | 是（短） |
| Braintrust | 有动态：braintrust@3.38.0 + @braintrust/otel@1.1.0 | GitHub releases | 是 |
| Arize Phoenix | 有动态：v20.22.0（10-15）、v20.23.0（10-16） | GitHub releases | 是 |
| AgentOps | 静默：无 commit/release（最新 0.4.21 2025-08-29） | gh api | 否 |
| Coze Loop | 静默：最新 v1.5.1（2026-01-20） | gh api | 否 |
| OTel for Agents | 有动态：semconv-genai 7 commits | gh api | 是 |

### 深度笔记

#### LangSmith
- 本周动态：10-12~10-19 周更四条主线。① 权限最小化：tracing-only API key 限定 workspace、只能写 run/建 project，泄露也不能读或改；Engine 权限拆 read/manage 与 usage-controls；部署密钥改为 `DEPLOYMENT_RUNTIME`（Editor + gateway/sandbox/agent-auth），不再默认 workspace admin。② 网关：LLM Gateway 接 ScaleDown（summarize/extract/classify/compress 与 Decisions），支持 `/scaledown`、统一 `/v1/chat/completions` 与 `/v1/systemone`，可按 ScaleDown 计价并 fallback；新增 Anthropic 兼容端点。③ 数据主权：自有 GCP 项目创建/删除 BYOC data plane（仅 API、限 US control plane）；AWS data plane 可只存 SmithDB 不用 ClickHouse。④ Sandbox：AWS/GCP/Azure 短期工作负载身份替代静态密钥，运行中可 live-migrate；OTel trace 可用 `Langsmith-Agent-Id` 头投递；cache token 按缓存费率计价。
- 关键数据：changelog 标注 October 12-19, 2026；tracing key 仅 write runs/create projects；webhook 连败 3 次标 `FAILING`。
- 原文链接：https://docs.langchain.com/langsmith/changelog
- 影响判断：可观测扩成“网关 + 沙箱 + 身份 + 数据面”控制面；tracing 写权限与读权限必须天生分离。

#### Langfuse
- 本周动态：五版：v4.63.0（北京 10-16 22:33）、v4.64.0（10-20 01:34）、v4.65.0（10-20 21:35）、v4.66.0（10-21 01:31）、v4.67.0（10-21 19:31）。三块：① Skills 成为一等对象（public v4 preview，带 usage metrics；恢复 MCP 访问；ingestion 接受 name/version skill catalog）；② Topics 聚类（大批量非阻塞、按 facet 命名、trace map、成本按 run 展示、失败打 Datadog）；③ AI Gateway（按内存预算准入、按 origin 归因错误并度量开销、self-hosted “None” ingestion、release 同步发 gateway 镜像）。另 Langfuse Assistant 更名 Halo，API key 默认启用 project 权限。
- 关键数据：v4.67.0 published_at 2026-10-21T11:31Z；36,146 stars / 4,016 forks。
- 原文链接：https://github.com/langfuse/langfuse/releases/tag/v4.67.0
- 影响判断：把 prompt/skill 版本、topic 聚类与网关合并，评估前移到“上线前选择 skill 版本”；五连发意味着升级回归成本高，生产应固定小版本。

#### Helicone / Braintrust / Arize Phoenix
- Helicone：窗口内 4 commits（10-19~10-20），全为安全/上游同步：`Sync security fixes`（#5841/#5842/#5844）、钉 Node engines（#5843）；无 release。公开仓库是私有主干下游镜像，外部无法逐条审计；6,231 stars。
- Braintrust：10-20 北京 02:44 发布 `braintrust@3.38.0` 与 `@braintrust/otel@1.1.0`；核心是 OTel span customizers（导出前定制，报错 fail closed 但不丢记录），追踪扩到 decisions API 与 media，typesafe 捕获 image 输入，修复凭据被排队登录替换。3.39.0 已出窗口。stars 本次未取得。
- Arize Phoenix：v20.22.0（10-15T07:02Z）、v20.23.0（10-16T03:16Z）；server 日志可 OTLP 导出（#17010）、playground 对 Bedrock 工具结果按文本转发、文档加 Atomic Agents tracing；11,940 stars。v20.24.0 已出窗口。
- 原文链接：https://github.com/Helicone/helicone/commits/main ；https://github.com/braintrustdata/braintrust-sdk/releases ；https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.23.0
- 影响判断：Braintrust 深绑 OTel 并覆盖决策点；Phoenix 补“观测系统的观测性”；Helicone 的“私有核心 + 公开外壳”放大安全信任成本。

#### AgentOps / Coze Loop / OTel for Agents
- AgentOps 窗口内无 commit、无 release（最新 0.4.21，2025-08-29）；Coze Loop 最新 v1.5.1（2026-01-20），长期停更，评测能力更多收进 Coze/Ark 平台侧。
- OTel `semantic-conventions-genai` 窗口内 7 commits：`execute_tool` 必须用 provider 提供的 tool call ID（#489/#525）；澄清 MCP 错误属性（#452）；可选 token usage 仅非零上报（#548）；strict conformance（#444）。最新 2026-10-21T05:38Z。
- 原文链接：https://github.com/AgentOps-AI/agentops/releases ；https://github.com/coze-dev/coze-loop/releases ；https://github.com/open-telemetry/semantic-conventions-genai/commits/main
- 影响判断：agent trace 字段级标准从建议走向可测试的一致性；SDK 不能再自定义语义蒙混，session/tool/span 命名与 ID 传递应尽早对齐。

### 模块洞察
可观测层正被“网关 + 技能/提示版本 + 最小权限”重新定义：trace 是策略执行与成本归因的旁路数据；分水岭是谁能同时做对 OTel 语义、写权限隔离与回放。

## 8. Managed Agent Platform / Enterprise Control Plane 平台控制面

### 本周模块结论

1. **AWS 把 AgentCore 的“评测 + 记忆 + 网关”补成闭环**：`Builtin.FailureAnalysis` 批量评测（定位失败、归因、聚类为 insight 并给修复建议）、长期记忆 TTL、短期记忆按 ingestion/retrieval/storage 计费、Gateway 私有 CA 直连 VPC Lattice。平台把 Agent 运维成本显性化。
2. **Microsoft 把调度器与控制面并入 Foundry**：Routines（timer/日程/GitHub issue/Teams 事件）GA、Tool Search GA、A2A GA、Insights preview、长任务韧性 preview；同时明确“Routines 不替代多 agent 编排与审批流”。
3. **中国云厂走“订阅套餐 + Harness 打包”路线**：火山方舟 Agent Plan 以 40/200/500/1000 元/月、AFP 积分计量，把豆包搜索、Agent 记忆、Computer Use、AI Native 应用开发底座、Agent 进化、专业数据集当 Harness 权益卖，并接入 OpenClaw/Claude Code/Codex CLI。
4. **矩阵实际缺口在 Identity 与 Observability 的跨平台可比性**：阿里云/火山/腾讯本周未取得可比的官方 Identity/Observability 更新条目，矩阵只能标“本次未取得”，不能推断为“无能力”。

### 固定平台状态表

| 平台 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 有动态（10 月四项：FailureAnalysis、Memory TTL、短期记忆消费计费、Gateway 私有 CA） | AWS release-notes（10-22 抓取） | 是 |
| Google Gemini Enterprise Agent Platform | 有动态（CodeMender v0.16.0 10-21；DeepSeek-V4.1-Flash 10-14） | Google release notes | 是 |
| Microsoft Foundry | 有动态（10-15：Routines/Tool Search/A2A GA、Insights preview） | devblogs.microsoft.com（10-15） | 是 |
| 阿里云百炼 / PAI | 本次未取得窗口内条目（最新 2026-02-10） | help.aliyun.com | 否 |
| 火山引擎 Ark / Coze | 有动态（Agent Plan 套餐与 Harness 权益；10-20 起 economy 模型 5 折） | 方舟文档（10-22 抓取） | 是 |
| 腾讯云 ADP / 元器 | 获取失败（仅见 10-18 博客摘要） | adp.tencent.com（仅摘要） | 否（限述） |
| Databricks Mosaic AI | 本周无重大公开动态 | 产品页（无日期） | 否 |

### 深度笔记

#### AWS Bedrock AgentCore（平台侧）
- 本周动态：同模块 2/4 的四项（FailureAnalysis、Memory TTL、短期记忆分项计费、Gateway 私有 CA）。FailureAnalysis 在 agent session 中找失败、判根因、跨 session 聚类为 insight，每条 insight 带修复建议（改 system prompt/tool definition），结果在 `GetBatchEvaluation.insightResults`。Memory TTL 需 `bedrock-agentcore:UpdateMemoryRecordExpirySpecification` 权限。
- 关键数据：`Builtin.FailureAnalysis`；日期区间 2026-10（月级归档）。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- 影响判断：评测从打分推进到“根因 + 修复建议”，压缩调优人力；TTL 与分项计费解决留存合规与成本可预测；私有 CA 是金融/政企硬门槛。

#### Google Gemini Enterprise Agent Platform
- 本周动态：10-21 CodeMender v0.16.0（并发逐文件 deep scan、`cm health` 预检、文件读取上限 256 KiB、`run_command` 超时 120s/300s、修沙箱写 `audit.log`、部分失败 INCOMPLETE）；10-14 DeepSeek-V4.1-Flash MaaS（文本+图像，1M 上下文，Public Preview）。
- 关键数据：CodeMender v0.16.0（10-21）；256 KiB；120s/300s；1M 上下文（10-14）。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- 影响判断：把“修漏洞 Agent”做成平台一等公民（自带沙箱、resume、audit log、用量统计），嵌入 DevSecOps；模型目录中立化保住平台议价权。

#### Microsoft Foundry（平台侧）
- 本周动态：10-15 博文汇总 9 月功能（功能上线日多在 9 月，属“发布事件在窗口、功能时点在窗口前”）。Routines GA：一个 routine 一个触发器启动一个 agent，配置/身份/运行历史留 project；明确不替代多 agent 编排/审批，agent 自助 reminder 仍 preview。Tool Search GA：Toolbox 通过 `tool_search`/`call_tool` 暴露工具发现与调用，不再把全量定义塞进每次请求。A2A GA；Insights preview（trace 找重复问题并给证据/建议）；Voice 与长任务 hosted-agent 韧性 preview；Model Router 加 session affinity 与 routing metadata（扩至 32 区域）；hosted agent 可同时暴露 Responses/Invocations/Activity 三种协议。
- 关键数据：博文 10-15；32 区域；Routines/Tool Search/A2A=GA；Insights=preview。
- 原文链接：https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-september-2026/
- 影响判断：把 Agent 的 cron、tool gateway、observability 三模块产品化，同时把编排让给 Agent Framework，形成“平台管生命周期、框架管逻辑”的分工。

#### 火山引擎 Ark / Coze / Coze Loop
- 本周动态：Agent Plan 四档 Small/Medium/Large/Max，40/200/500/1000 元/月，AFP 计量，月额度 2 万/10 万/25 万/50 万，并有周/5 小时/日额度；Harness 权益含专业数据集、豆包搜索（500 次/月免费）、Agent 记忆、AI Native 应用开发底座、Agent 进化（前 50 文件免费）、Computer Use（仅 Large/Max），Harness 类不计 5 小时/周额度、只受日/月额度约束。计费活动：10-12~10-25 kimi-k3 抵扣系数 5 折；10-20~12-30 deepseek-v4.1-flash-economy 再 5 折。接入面写明 OpenClaw、Hermes Agent、Claude Code、OpenCode。
- 关键数据：4 档 40/200/500/1000 元/月；2 万~50 万 AFP/月；豆包搜索 500 次/月；10-20 起 economy 5 折。
- 原文链接：https://docs.volcengine.com/docs/ark/agent-plan-personal-plan-overview
- 影响判断：把 Harness 当套餐权益卖，用 AFP 降低预算不确定性；对 OpenClaw 是渠道利好，对独立 Harness 创业公司是补贴压力。

#### 阿里云 / 腾讯云 / Databricks（限述）
- 阿里云：百炼 `application-release-notes` 最新 2026-02-10，窗口内无条目；主线/快照模型下线生效 10-10（窗口外，属模型生命周期）；本期不写“百炼本周动态”。
- 腾讯云：仅见 ADP 博客 10-18 摘要（员工集中使用获授权智能体、团队文件跨会话复用、知识库支持企微文档导入与时效性检索），正文未读，只作线索、不作事实。
- Databricks：本周无重大公开动态；Agent Bricks 负责企业数据构建与治理，Mosaic AI Agent Framework 负责编排/评测，共用 Unity Catalog（背景）。
- 原文链接：https://help.aliyun.com/zh/model-studio/application-release-notes ；https://adp.tencent.com/zh/blog ；https://www.databricks.com/product/artificial-intelligence/agent-bricks

### 模块洞察
平台竞争从“有没有 Agent 服务”转为“能否把评测归因、记忆留存、私有网络接入、调度与身份打成可采购组合”；AWS/Microsoft 各补一块，中国云厂用订阅套餐前置打包，商品化路径分叉。

## 云厂能力矩阵（2026-10-15 ~ 10-21）

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Runtime；Instances 计算型支持最长 14 天持久会话（9 月背景） | 长期记忆 TTL（`recordExpirySpecification`）；短期记忆按 ingestion/retrieval/storage 计费 | Gateway 私有 CA TLS、直连 VPC Lattice；rate limit（8 月） | AgentCore Identity；Consent Portal（9 月背景） | 内置 Code Interpreter/Browser（月档条目未标日）；9 月交互式 shell（背景） | `Builtin.FailureAnalysis` 批量评测 + insight | 评测从打分到根因；记忆成本/留存可控 |
| Google | Agent Engine / Agent Platform（既有）；ADK 本周无 release | Memory Bank（既有）；DeepSeek-V4.1-Flash 1M 上下文入目录 | Agent Gateway（既有，10-07 preview 窗口外） | Agent Identity / 语义治理策略（既有） | CodeMender 沙箱会话 + audit log；256 KiB 读上限 | App Topology/策略拒绝审计；CodeMender 用量统计 | CodeMender v0.16.0（10-21） |
| Microsoft | Foundry hosted agents；长任务韧性 preview；Routines 调度 GA | Foundry memory（既有）；session 状态由 Responses 托管 | Toolbox + Tool Search GA；A2A GA；三种协议 | Entra Agent ID（既有）；trace ingestion Entra 认证 preview | Code Interpreter / Browser Automation（既有） | Insights preview（trace 归因）；Agent Monitoring Dashboard | Routines/Tool Search/A2A 三项 GA（博文 10-15） |
| 阿里云 | 百炼智能体/工作流（既有）；本次未取得窗口内更新 | 长期记忆 2.0 API（1 月背景） | MCP 市场与自定义 MCP（背景） | RAM 子账号/分账（背景） | 代码解释器插件（背景） | 应用观测 OTel（背景） | 本次未取得 |
| 火山/字节 | 方舟 Agent Plan 托管 Harness；Coze/Coze Studio（既有） | 套餐含 Agent 记忆 Harness | 豆包搜索 Harness；MCP 兼容（既有） | 主账号/IAM 角色（文档提及 `iam:CreateRole`） | 套餐含 Computer Use Agent（Large/Max） | Coze Loop（既有）；AFP 用量明细 | 订阅套餐把 Harness 权益打包（10 月文档） |
| 腾讯云 | ADP 智能体/工作流（既有）；本次未取得更新 | 知识库（企微文档导入，仅摘要） | 插件/MCP（既有，未核） | 企业授权分发（仅摘要） | CloudBase AI Toolkit（既有，未核） | 本次未取得 | 仅 10-18 博客摘要，正文未读 |
| Databricks | Model Serving / Agent Bricks 部署（既有） | Unity Catalog + 向量检索（既有） | MCP/工具（既有，未核） | Unity Catalog 权限（既有） | 本次未取得 | Mosaic AI 评测（既有） | 本周无重大公开动态 |

> 矩阵中“既有/背景”仅用于列完整性，不作本周动态；“本次未取得”表示本轮无可核证据，不代表平台无该能力。

## TOP 5 候选及依据（按对 Agent Harness 基础设施格局的信号价值排序）

1. **Microsoft Foundry 把调度、工具发现、trace 归因同时收进平台**（Routines/Tool Search/A2A GA，Insights/长任务韧性 preview，博文 2026-10-15）。信号价值：一次性重画了“平台控制面 vs 框架编排”的边界，且官方自我限定“不替代编排与审批”，为所有 Harness 厂商提供了可复制的职责切分。局限：功能上线多在 9 月，属发布事件在窗口、功能时点在窗口前。
2. **AWS AgentCore 把评测、记忆留存、私有网络接入补成可采购组合**（FailureAnalysis、Memory TTL、短期记忆分项计费、Gateway 私有 CA）。信号价值：评测从打分变为“根因 + 修复建议”，记忆从功能变为可计量成本项，直指企业采购的三个硬条件。局限：发布说明月级归档，除 SDK 1.24.1（10-19）外不能逐条证明窗口内日期。
3. **OpenViking v0.5.1/0.5.1.1 把 Memory 推向“上下文数据库”**（多实例 Redis/MySQL、字段级隐私、批量写入冲突检测、Gateway 管理密钥）。信号价值：模块定位发生迁移——竞争从召回效果转向数据库运维面（多租户、迁移、回滚），同时用 10 条破坏性变更证明其已进入生产部署阶段。
4. **Arcade Tool Recommendation 把工具选择改为检索问题**（10-15；官方称输入 token 最多降 91%、成本降 37%）。信号价值：为“工具目录无限膨胀”给出可落地解，并把权限检查嵌入推荐与调用两处；工具网关的稀缺资源从连接数变为上下文预算与治理面。局限：数字为厂商自测/建模口径，未独立复核。
5. **浏览器执行层的“安全默认值”转向**（vercel-labs/agent-browser 窗口内 10 条提交：策略 fail-closed、schema 白名单、拒绝隐藏/禁用/视口外点击、拒绝歧义 stale-ref；browser-use 0.13.13 成为 OpenAI browser-tool 驱动）。信号价值：Agent 浏览器从“能力覆盖”进入“安全失败与误操作防控”竞争，且开源项目正抢占模型厂工具链的默认执行位。

> 合格强信号为上述 5 条，故列满 5 条。MCP 事件化（Tasks & Events WG、Events 仍 draft）与 mcp-gateway-registry 凭证精确绑定因“尚未定稿/单点安全修复”列为次强观察，未进 TOP5。

## OpenClaw 战略参照（6 条）

1. **会话/审批状态需要 schema 版本与迁移策略**。Microsoft 1.22.0 的持久化兼容警告、OpenAI 的 pending-approval 压缩修复、LangGraph 的 resume 修复指向同一风险。OpenClaw 若把 session/approval 记录当作可升级资产并标注 schema 版本，可避免“升级即失忆”，也便于企业审计与跨版本回放。
2. **turn 级硬超时 + 缺失 `tool.response` 的兜底**。trueforge 把 exec deadline 设为“命令超时 + 5s”，显式避免一次工具挂起吞掉整个会话。OpenClaw 的 tool runtime 应对每次工具调用设置可观测 deadline，超时写入结构化错误事件。
3. **策略与配置加载必须 fail-closed**。agent-browser 本周把“策略文件读不到就拒绝”作为修复主题。OpenClaw 的 tool policy / exec 审批在配置缺失、解析失败时应拒绝而非降级放行，工具参数按 schema 白名单校验。
4. **调度边界保持克制，补统一运行视图**。Foundry 明确 Routines 只“一个触发器启动一个 agent”，不承担编排与审批。OpenClaw 的 cron 宜维持“触发 + 隔离 run + 交接产物”，把多 agent 编排留给 sessions/subagents；应补的是触发器来源与运行历史的统一视图，而非再引入外部调度器。
5. **可观测对外接口与权限隔离**。trueforge 用 `GET /metrics` 暴露 rate/status/latency；LangSmith 把 tracing-only key 做成只写不可读。OpenClaw 目前对外可核运行指标有限，若补只读指标端点或结构化 run 事件导出，并天生分离 trace 写/读权限，会显著降低企业评估成本与会话泄露风险。
6. **渠道即资产，但需版本化接入契约**。方舟 Agent Plan 单列 OpenClaw 接入页与 1M 上下文方案，说明“被云厂支持”能直接换取用户；反向要求 OpenClaw 的接入文档、版本兼容策略与 changelog 可引用、可版本化。

## 覆盖与缺口

### 实际覆盖计数

- **模块：8/8**（1 Harness、2 Runtime、3 Sandbox/Browser、4 Tool Gateway、5 Identity、6 Memory、7 Observability、8 Managed Platform）；均有结论、状态表、深度笔记与模块洞察。模块 5 与模块 8 的深度受一手材料限制，已按限述处理。
- **平台：7/7 扫描**；其中 4 家取得窗口内可核动态（AWS、Google、Microsoft、火山/字节），3 家未有可用窗口证据（阿里云：百炼页面最新 2026-02-10；腾讯云：仅 10-18 博客摘要；Databricks：无日期产品页、无窗口条目）。矩阵 7 列 × 7 行完整，缺口单元格标“本次未取得/既有（背景）”。
- **GitHub 热度补漏：9/9 查询方向**，补入 8 个对象（OpenViking、cognee、trueforge、microsoft/mcp-gateway、langfuse、browser-use、mcp-gateway-registry、vercel-labs/agent-browser）；过滤 awesome-list/教程/应用模板。
- **TOP5：5 条**；**OpenClaw 参照：6 条**；模块洞察：8 条。

### 未能取得项与原因

1. **Anthropic**：`anthropic.com/news` 只返回站点壳/登录入口，窗口内 Agent SDK/MCP 正文未取得；列表页 10-21 Claude Opus 5.5 仅有摘要，未读正文，不写成事实。
2. **AWS 日期精度**：release notes 按月归档（“October 2026”），四项未逐条标日；仅 PyPI/SDK 1.24.1（10-19）可精确证明。本轮未查 RSS/公告页。
3. **OpenAI 浏览器改进**：ChatGPT release notes 正文只渲染到 2026-06-10，10-20 条目仅有搜索摘要，未采用。
4. **腾讯云**：ADP 博客 10-18 条目仅有列表摘要，正文未读；元器停服/迁移指引日期在窗口前。
5. **阿里云百炼**：应用功能动态最新条目 2026-02-10，窗口内无条目；不推断为停滞或无能力。
6. **Microsoft Entra Agent Identity / Azure Playwright / Google Code Execution**：窗口内未取得官方材料，记“本次未取得”，不推断为无发布。
7. **browser-use 单价**：`$0.02/浏览器小时` 仅见仓库描述与第三方文，官方定价页未列，标“未独立确认”。
8. **交叉验证**：本周主张均为官方一手（GitHub release/commit、AWS/Google/Microsoft/火山官方文档/博客），未做独立二源；按“单源原始事实”采用并注明口径。
9. **动态池**：CrewAI AMP/Studio、Dify、n8n、Flowise 未取得基础设施级动态；Pipedream、Microsoft Toolbox、A2A 窗口内无公开更新。

## 价值链位置判断（R3）

| 对象 | 链条位置 | 本周价值/议价信号 |
|---|---|---|
| trueforge | 运行时/Harness（自托管） | 沙箱与可观测做成产品面，议价点从“编排功能”转向“运维可信度” |
| OpenAI Agents SDK | 运行时/Harness（SDK） | 修审批与压缩冲突，巩固“SDK 即控制层”默认选项地位 |
| LangGraph | 运行时/Harness + 平台与工具链 | checkpoint prune + serverless 默认部署，向托管编排平台上移 |
| Microsoft AF / Foundry | 运行时/Harness → 平台与工具链 | 框架定状态语义、平台收调度/工具发现/归因，控制面集中 |
| AWS AgentCore | 平台与工具链 | 评测归因 + 记忆 TTL + 私有 CA，向可采购企业平台收敛 |
| Google Agent Platform | 平台与工具链 | CodeMender 嵌入安全运维；模型目录中立化保住平台位置 |
| 火山方舟 Agent Plan | 平台与工具链（订阅） | Harness 权益打包 + 兼容外部客户端，靠渠道与价格抢入口 |
| OpenViking / Cognee | 运行时/Harness（上下文存储） | 记忆数据库化，向平台内嵌存储层上移，压制单点记忆 API |
| Arcade / mcp-gateway-registry | 协议与工具 | 工具检索与凭证边界成为议价点，网关收“治理税” |
| browser-use / agent-browser | 协议与工具 → 运行时（浏览器驱动） | 开源抢占模型厂工具 schema 的默认执行位 |
| E2B / Daytona / Modal | 运行时/Harness（执行底座） | 拼 GPU 规格、生命周期字段、运营面，价格与差异化同时下压 |
| OpenClaw | 运行时/Harness（自托管客户端） | 被云厂列为接入目标，渠道价值上升；控制面标准输出不足 |

**传导方向与商品化**：① 上游模型厂把浏览器/工具 schema 标准化，中游开源驱动与网关受益，下游 Harness 的“连接能力”被商品化；② 云厂把 cron、评测、记忆留存、私有网络收进平台，自建 Harness 的剩余空间集中在“跨云、跨模型、可迁移”；③ 火山用订阅套餐给基础 Harness 能力定价（40 元/月起），AWS 把记忆改为分项计费，两侧共同压低自建基础 Harness 的溢价；④ 增量价值正落在治理、凭证、迁移与可观测，而非裸算力或 DSL 表达力。

## 解决方案透镜五要素（仅就已披露内容）

本周材料以产品/版本发布为主，**没有可完整支撑五要素的客户落地案例**。按对象逐项标注，未披露即写“未披露”：

| 对象 | 怎么搭的 | 交付给谁 | 什么代价 | 踩了什么坑 | 能否复制 |
|---|---|---|---|---|---|
| 火山 Agent Plan | 方舟托管 Harness + 外部客户端（OpenClaw/Claude Code 等）+ AFP 计量 | 个人开发者/小团队（订阅套餐）；规模未披露 | 40/200/500/1000 元/月；额度与超限规则已披露；TCO 未披露 | 未披露 | 可复制到“模型厂 + 订阅制 Harness 分发”，前提是自有模型与渠道；企业私有化边界未披露 |
| Microsoft Foundry Routines | 触发器 + hosted agent + 项目内身份/运行历史；编排交给 Agent Framework | 企业 Azure 客户；行业/规模未披露 | 定价未披露 | 官方明确长任务需自做 checkpoint 与幂等，“重连不会让重复外部动作变安全” | 可复制到定时/事件型 Agent；不适用于复杂多 agent 编排（官方自限定） |
| Arcade Tool Recommendation | MCP 之上加检索层 + actions runtime 授权/policy/OTel | 工具目录规模大的平台/企业；客户名未披露 | 未披露（仅给 token/成本节省模型） | 工具数少时反而更贵（约 25~28 个以下） | 可复制到工具目录膨胀场景；依赖高质量工具描述与 embedding |

> 演示 ≠ 规模部署，试点 ≠ 付费交付，采购 ≠ 收入；上表不构成采用规模或收入判断。

## 来源清单

1. https://docs.volcengine.com/docs/ark/agent-plan-personal-plan-overview — 2026-10-22 抓取（10 月文档）
2. https://github.com/openai/openai-agents-python/releases/tag/v0.24.0 — 2026-10-15
3. https://github.com/langchain-ai/langgraph/releases/tag/1.2.16 — 2026-10-16
4. https://github.com/microsoft/agent-framework/releases/tag/python-1.22.0 — 2026-10-15
5. https://github.com/truefoundry/trueforge/releases — 2026-10-21
6. https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes — 2026-10-14/10-21
7. https://www.anthropic.com/news — 2026-10-22（正文未取得）
8. https://docs.databricks.com/aws/en/agents/ — 无日期
9. https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html — 2026-10（月档）
10. https://pypi.org/project/bedrock-agentcore/ — 2026-10-19
11. https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-september-2026/ — 2026-10-15
12. https://help.aliyun.com/zh/model-studio/application-release-notes — 最新 2026-02-10
13. https://adp.tencent.com/zh/blog — 2026-10-18（仅摘要）
14. https://yuanqi.tencent.com/cl/adp-guide — 2026-10-13
15. https://docs.cloud.google.com/vertex-ai/docs/release-notes — 2026-10-19
16. https://github.com/browser-use/browser-use/releases/tag/0.13.13 — 2026-10-15T23:50Z
17. https://browser-use.com/pricing — 无日期
18. https://github.com/vercel-labs/agent-browser/commits/main — 2026-10-21
19. https://docs.e2b.dev/changelog — 2026-10-19
20. https://www.daytona.io/changelog/nvidia-b200-gpu-type — 2026-10-16
21. https://modal.com/docs/sdk/py/releases — 2026-10-15
22. https://browserbase.com/changelog — 2026-10-14/10-12（窗口外）
23. https://www.arcade.dev/blog/tool-recommendation — 2026-10-15
24. https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.33.0 — 2026-10-16
25. https://github.com/ComposioHQ/composio/commits/main — 2026-10-21
26. https://github.com/modelcontextprotocol/modelcontextprotocol/commits/main — 2026-10-16/10-20
27. https://github.com/microsoft/mcp-gateway/commits/main — 最新 2026-10-14
28. https://nango.dev/blog/mcp-events-for-customer-facing-ai-agents — 2026-10-14
29. https://github.com/volcengine/OpenViking/releases/tag/v0.5.1 — 2026-10-19；v0.5.1.1 — 2026-10-20
30. https://github.com/topoteretes/cognee/releases/tag/v1.6.5 — 2026-10-16T20:10Z
31. https://github.com/supermemoryai/supermemory/commits/main — 2026-10-18
32. https://github.com/getzep/graphiti/releases/tag/v0.31.0 — 2026-10-15；v0.31.2 — 2026-10-20T17:25Z
33. https://github.com/mem0ai/mem0/commits/main — 2026-10-21
34. https://github.com/letta-ai/letta/commits/main — 2026-10-18
35. https://github.com/firecrawl/firecrawl/commits/main — 2026-10-21
36. https://github.com/unclecode/crawl4ai/releases/tag/v0.9.5 — 2026-10-14（窗口外）
37. https://docs.langchain.com/langsmith/changelog — 2026-10-12~10-19
38. https://github.com/langfuse/langfuse/releases/tag/v4.67.0 — 2026-10-21
39. https://github.com/Helicone/helicone/commits/main — 2026-10-20
40. https://github.com/braintrustdata/braintrust-sdk/releases — 2026-10-19T18:44Z
41. https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-v20.23.0 — 2026-10-16
42. https://github.com/AgentOps-AI/agentops/releases — 最新 2025-08-29
43. https://github.com/coze-dev/coze-loop/releases — 最新 2026-01-20
44. https://github.com/open-telemetry/semantic-conventions-genai/commits/main — 2026-10-21
45. https://github.com/volcengine/OpenViking/releases/tag/v0.5.1.1 — 2026-10-20
46. https://github.com/openai/openai-agents-python/releases — 2026-10-15

> 共 46 条定位来源；其中正文可读并用于主张的官方来源为主，搜索摘要/无日期产品页仅用于定位或明确标为未取得。

---

### 自查记录

- 8 个模块均有“本周模块结论 / 固定对象状态表 / 深度笔记 / 模块洞察”。
- 云厂矩阵 7 平台 × 7 列完整；缺口单元格与“本次未取得”说明保留。
- 所有带日期的主张均来自已读官方 release/docs/commit；月级归档、窗口外背景、摘要未读、厂商自测数字均已显式标注，未新增未取证事实。
- 本文件为研究母稿，不含文章化改写；文章主线与章节交由 report2article 处理。
