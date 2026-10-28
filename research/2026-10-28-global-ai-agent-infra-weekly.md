# 全球 AI Agent 基础设施研究周报（2026-10-28 / 第 19 期）研究母稿

- 冻结窗口：2026-10-22 00:00 ~ 2026-10-28 24:00（Asia/Shanghai）；资料读取截至 2026-10-28 下午（+0800）
- 口径：GitHub release 正文、官方 changelog/release notes/产品公告为一手依据（A）；厂商自述数字标 B；月级归档、未逐条标日的条目只写"10 月"，不计为确定窗内事件。GitHub 时间取 releases Atom 的 `updated` 字段折算 +0800，与"发布时刻"可能有分钟级差异。
- 本期主线：**中断、重试与升级时"不重复副作用"成为 Agent 基础设施的共同工程主题**——OpenClaw 以 replay-safe session recovery 为头条并开 LTS 轨；E2B 把重试语义交给服务端声明并加幂等键；AWS AgentCore Gateway 为模型流量加有序 fallback 与熔断；Dify/MAF/ADK/OpenViking 同周发出需要迁移的破坏性变更。并行的第二条线是**策略执行点下沉到工具网关与 SDK 契约**（Composio session hooks、Claude Code safety_event、Google 语义治理意图匹配开关、agent-browser 配置信任边界）。

## 1. Harness / Agent OS 控制层

### 本周模块结论

1. **"中断后可重放恢复 + 升级迁移成本"是本周 Harness 层共同主题**。OpenClaw 2026.10.7/10.8 以 replay-safe session recovery 为头条；Dify 1.18.0 的 Agent run protocol v2 不向后兼容；Microsoft Agent Framework python-1.23.0 三项 BREAKING；Google ADK 2.13.0 默认遥测 schema 切换；`langchain-core 1.7.0` 改流式工具参数事件。
2. **OpenClaw 首次出现主线 + extended-stable（LTS 等价）双轨**：2026.9.34（10-24）与 2026.9.35（10-27）为 gateway-only extended-stable，安全修复同时下放。
3. **权限与安全事件进入 SDK 契约**：Claude Code `claude_code.safety_event`、MAF `unsafe_extra_run_args` 更名与 AG-UI 授权 scope 显式化、pydantic-ai 护栏关闭 fail-open。
4. **成本归因字段细化**：Claude Agent SDK 按 5 分钟/1 小时缓存寿命拆 token；LangGraph DeltaChannel 快照频率默认 1000→100（读快、存储多）；pydantic-ai `PostgresSpendStore` 共享预算。
5. OpenAI Agents SDK 本周空窗（py 最新 v0.24.0 为 10-15，js v0.21.0 为 10-21），API 侧 10-24 Enterprise Key Management。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态：2026.10.7（10-25）、2026.10.8（10-28）、2026.9.34/9.35 LTS（10-24/10-27）、2026.10.10-beta.4（10-27） | GitHub releases | 是 |
| OpenAI Agents SDK | 无动态（py v0.24.0=10-15；js v0.21.0=10-21 05:56，均窗外） | releases Atom ×2；platform changelog | 否（平台侧一句） |
| Anthropic Claude Agent SDK / Claude Code | 有动态：TS v0.3.307–312、Py v0.2.171–174、Claude Code v2.1.307–312；平台 10-21 API 版本、10-22 Google Cloud 托管 | GitHub releases；docs.claude.com release notes | 是 |
| LangChain / LangGraph / LangSmith | 有动态：langgraph 1.2.17/1.2.18、checkpoint 4.3.1、sdk-py 0.4.9/0.4.10、cli 0.4.38–0.4.40、core 1.7.0；LangSmith 独立条目未取得 | GitHub releases；changelog.langchain.com | 是 |
| Google ADK | 有动态：adk-python v2.13.0（自注 10-22）；adk-js/java 窗内无版本 | GitHub releases | 是 |
| Microsoft Agent Framework / SK / AutoGen | MAF 有动态：python-1.23.0、dotnet-1.26.0；SK 最新 10-06；AutoGen 最新 2025-09 | GitHub releases ×3 | 是（MAF） |
| Databricks Mosaic AI / Agent Bricks | 有动态（月档未标日）：MCP 越狱筛查 Beta、外部 Agent 默认 OAuth GA 等 | Databricks release notes | 是（限述日期） |
| 动态池：Dify / CrewAI / trueforge / pydantic-ai | 有基础设施级动态：Dify 1.18.0、CrewAI 1.15.29–32、trueforge 0.180.1/0.181.0-rc、pydantic-ai v2.60–2.63 | GitHub releases | 是（摘要） |

### 深度笔记


#### OpenClaw（必覆盖）
- 窗口内状态：**有动态**（窗口内 4 个具名版本 + 多个 `release-publish/*` 构建标签）。
- 事实要点：
  - `2026.9.34`（10-24 19:38）与 `2026.9.35`（10-27 10:20）：官方定义为 **gateway-only extended-stable release，"our current equivalent to LTS"**，即 9 月底代码线 + 关键安全/可靠性修复 + 新模型支持；发布时最新主线分别为 2026.10.6 与 2026.10.7。【A】
    - 9.34：`apply_patch` 先校验有序 envelope 再改工作区，避免后一个非法 hunk 删除前一个操作已改文件（#160409）；托管升级时官方插件随 core 版本收敛（#174257）；`before_tool_call` hooks 在 `openclaw agent exec` 下恢复执行（#159333）；Memory Wiki 重导入保留人写 Notes（#175707）。【A】
    - 9.35：worker heap 上限在 Gateway 服务传入进程级 `--max-old-space-size` 时仍生效、空闲 Codex app-server 客户端 30 秒后退役、archive worker 复用（#166581/#171490/#168387/#171156/#175091）；`test -v` exec 操作数在 allowlist 模式下需审批（#180880）；generic node invoke 拒绝浏览器代理命令（#179880）；`openclaw mcp list/show` 与日志脱敏凭证（#183193 等）；Claude CLI 输出达上限时快速失败而非卡 15 分钟（#159931 等）。【A】
  - `2026.10.7`（10-25 04:19）Highlights：**Replay-safe session recovery**——中断会话保留恢复溯源（recovery provenance）与未完成工具结果、停止的会话在接收下一条消息前清理终态恢复残留、大批量子会话完成结果控制在请求方上下文内（#153728/#168764/#172068/#177716 等 9 个 PR）；更新激活与恢复（#181166 等）；数据库与 worker 连续性——维护拒绝时保留 peer readers/borrowers、不兼容的保留 agent 数据库隔离（#175987/#179320 等）；备份与状态持久性——快照保留受支持的旧 exec-approval 策略、R2 校验与恢复可中断续做（#164297/#171292 等）；operator 控制连续性——原生 computer control 会话过期后恢复、cron 公告保留 CLI 会话（#169385/#174530 等）。【A】
  - `2026.10.8`（10-28 08:10）Highlights：更新后 Doctor 普通失败会重启 Gateway 而非停机，孤儿维护 worker 不再阻塞所有 CLI/Gateway 启动（#180668/#181695 等 7 个 PR）；三平台 Gateway 服务安装修复（macOS launchd、Ubuntu 默认 umask 下创建私有状态目录、updater 等待 Gateway 释放数据库，#180390/#179538/#182055）；**会话持续接收消息**——被 kill 的 run 释放 restart-recovery fence、中断与刚接受的子会话在重启后恢复、回复运行时无法发布时入站消息停止无限重试（#181992/#178888/#181871 等）；启动与 SQLite 读作用域、锁竞争重试（#182615/#182446/#182385）；安全加固——沙箱内派生子进程不能运行宿主 CLI 后端（#178742）、secret egress proxy 拒绝不受信 eMudhra 证书链（#179249）、Fish Audio/Gradium 错误不再暴露 API key（#178877）。【A】
  - `2026.10.10-beta.4`（10-27 13:39）：自动化保留已认证 operator 权限用于同会话显式定时跟进（含 one-shot `next_check` 重新挂载），同时保留角色/会话/取消/目标/工具策略撤销边界（#176422）；环境变量引用的 `hooks.token` 不进入 agent host-exec 与 CLI 子进程环境（#179199）；Claude CLI 在 Control UI 会话中保留原生会话与上下文而非每次重播历史（#178955）；agent 数据库生命周期（#175987/#163258/#179320）。【A】
  - CHANGELOG 已改为分文件结构（`CHANGELOG/<版本>.md`），索引页链到 docs.openclaw.ai/releases。【A】
- 影响 / 为什么重要：OpenClaw 本周首次出现"主线 + extended-stable（LTS 等价）双轨"，并连续两版把**重启/中断后的会话可重放恢复**作为头条。对比上期（10-22）其 CHANGELOG 未标发布日、无法计入窗口，本期可用公开 release 计入，证据等级从"本机观测"提升到 A。对自托管 Harness 运维者：可选择 9.x LTS 轨道降低升级频率；安全修复（exec allowlist、沙箱子进程、证书链、密钥脱敏）同时下放到 LTS。
- 证据级摘要：A（GitHub release 正文）。
- 来源：
  - GitHub releases｜https://github.com/openclaw/openclaw/releases/tag/v2026.10.8｜10-28｜Highlights 全文
  - https://github.com/openclaw/openclaw/releases/tag/v2026.10.7｜10-25｜Highlights
  - https://github.com/openclaw/openclaw/releases/tag/v2026.9.35｜10-27｜Highlights
  - https://github.com/openclaw/openclaw/releases/tag/v2026.9.34｜10-24｜Highlights/Changes/Fixes
  - https://github.com/openclaw/openclaw/releases/tag/v2026.10.10-beta.4｜10-27｜Fixes 前 9 条
  - CHANGELOG 索引｜https://raw.githubusercontent.com/openclaw/openclaw/main/CHANGELOG.md｜读取 10-28

#### OpenAI Agents SDK（Python / JS）
- 窗口内状态：**无动态**（核验入口：1. `openai-agents-python` releases Atom，最新 v0.24.0 为 10-15，窗外；2. `openai-agents-js` releases Atom，最新 v0.21.0 为 10-21 05:56 +0800，窗外；3. SDK 文档 release 页）。
- 平台侧相关（模型/API 层，非 SDK）：OpenAI API changelog 10-22 Decisions API GA（`gpt-6-luna`，每请求问题上限 200→400）；10-24 Enterprise Key Management（客户自管 KMS 密钥加密）与 UK data residency；10-26 `gpt-6.1-terra`（官方描述含 "precise computer use"）。【A】
- 影响：SDK 本周空窗；EKM 与数据驻留属于企业控制面采购条件，影响托管 Agent 的合规评估，而非 Harness 语义。
- 证据级：A（官方 changelog）。
- 来源：https://github.com/openai/openai-agents-python/releases ；https://github.com/openai/openai-agents-js/releases ；https://platform.openai.com/docs/changelog（10-28 读取，Oct 22/24/26 条目）

#### Anthropic Claude Agent SDK / Claude Code
- 窗口内状态：**有动态**（Python SDK v0.2.171–v0.2.174 共 4 版；TS SDK v0.3.307–v0.3.312 共 6 版；Claude Code v2.1.307–v2.1.312 共 6 版）。
- 事实要点：
  - Python SDK 4 版均为"Updated bundled Claude CLI"（2.1.307→2.1.310），无独立 API 变更。【A】
  - TS SDK：v0.3.307（10-22 06:17）在定时 wakeup/task 的 `command_lifecycle` started 帧加入 `wakeup_source` 与 `scheduled_for`（capability `lifecycle_wakeup_source_v1`），宿主可区分是哪个触发；浏览器 SDK `query()` 增 `supportedDialogKinds`。v0.3.309（10-23）修复宿主提供的 `managedSettings` 丢失 `disableAllHooks`/`disableSkillShellExecution` 等字段；内嵌 CLI 解压到按用户隔离的临时目录且仅在字节一致时复用。v0.3.311（10-27）`ModelUsage` 新增 `cacheCreationEphemeral5mInputTokens`/`cacheCreationEphemeral1hInputTokens`（按缓存寿命拆分）；最低 Node 18.14.0。v0.3.312（10-28）Settings 类型加入 `autoMode`、`permissions.disableAutoMode` 等；AskUserQuestion 增 `unanswered` 注记（capability `ask_user_question_unanswered_v1`）。【A】
  - Claude Code：v2.1.307 新增 `claude_code.safety_event` OpenTelemetry 事件（每次被权限规则/auto mode/安全检查/hook/沙箱拦截、提示或退回的工具调用各记一条）；HTTP MCP 连接中途关闭时只重试只读或幂等工具（此前会发两次）。v2.1.309 修复 macOS/Linux 沙箱 Bash 在沙箱外执行 shell 启动文件、沙箱命令可改 `--mcp-config` 文件等多项沙箱/权限漏洞。v2.1.311 新增 self-hosted-runner `--hold-idle-file`/`--max-hold-min`；修复子 agent 无法使用晚连接的 MCP 工具、SDK 会话 transcript 乱序。v2.1.312 Claude apps gateway 新增 `oidc.user_id_claim`（可用 Entra ID 的 `oid` 而非 `sub` 识别用户）。【A】
  - Claude Developer Platform：10-21 API version `2026-10-21` 发布；10-22 上线 "Claude Models on Google Cloud (Anthropic managed)"（Anthropic 运营、经 Google Cloud 项目访问，IAM 控制访问、Marketplace 计费）；10-23 Claude Tag API beta（Enterprise）。【A】
- 影响：Anthropic 本周把**权限拦截事件化（safety_event）**、**定时唤醒来源可识别**、**缓存成本按寿命拆账**推进到 SDK 契约层；对把 Claude Agent SDK 嵌入自有 Harness 的团队，审计与成本归因字段需同步升级。上期记"Anthropic 未取得"，本期经 GitHub releases 取得一手材料。
- 证据级：A。
- 来源：https://github.com/anthropics/claude-agent-sdk-typescript/releases（v0.3.307–312）；https://github.com/anthropics/claude-agent-sdk-python/releases ；https://github.com/anthropics/claude-code/releases（v2.1.307–312）；https://docs.claude.com/en/release-notes/overview（Oct 21–23）

#### LangChain / LangGraph / LangSmith
- 窗口内状态：**有动态**。
- 事实要点：
  - `langgraph 1.2.17`（10-24 09:08）：显式 `recursion_limit` 等于默认值时也生效（#9417）；`RemoteGraph.stream(subgraphs=True)` 保留调用方 namespace（#9401）。【A】
  - `langgraph 1.2.18`（10-27 04:05）：**DeltaChannel 默认每 100 次更新做一次全量快照（原 1000）**——长线程读取更快、存储更多，可用 `snapshot_frequency=1000` 恢复（#9420）；`error_handler` 在所有路径可恢复并流出失败任务结果（#9408）；被 `interrupt_after` 或递归上限停止的 run 流出最后一个 checkpoint（#9409）。JS 侧 `@langchain/langgraph 1.5.3` 同步改为 100（#3125）。【A】
  - `checkpoint 4.3.1`：namespace 标签拒绝 NUL 字节（#9383）；JS `checkpoint-mongodb 1.5.1` 对 namespace/键做 `$eq` 包装，防止对象值被当作查询运算符（#3093/#3103）。【A】
  - `sdk-py 0.4.9` 增 thread `Priority`（#9392），`cli 0.4.38` 在 `langgraph.json` 增 priority 节（#9393）；`sdk-py 0.4.10` `runs.wait` 失败时用无 body GET 重试、SSE 解析按规范处理多行/空 id/BOM（#9399/#9402）；`cli 0.4.39/0.4.40` 增 `deploy list --json`、上传时发送控制面返回的 headers（#9395/#9396）。【A】
  - `langchain-core 1.7.0`（10-23 01:48）：流式工具调用参数改为 `tool-call-delta` 切片而非累计快照；读原始流事件的代码需改读新事件，或 pin `<1.7`。【A】
  - LangSmith：`langsmith-sdk` 最新 v0.14.9（10-15，窗外）；changelog.langchain.com 页面已抓取但未定位到窗口内可核条目 → 本次未取得独立条目（已试 2 入口）。
- 影响：LangGraph 本周主题从"resume 正确性"（上期）转到**长线程读取成本 vs 存储成本**的默认值重设，以及**线程优先级**进入部署配置；`langchain-core 1.7.0` 是本周少数需要代码改动的流式契约变更。
- 证据级：A。
- 来源：https://github.com/langchain-ai/langgraph/releases/tag/1.2.18 ；…/1.2.17 ；https://github.com/langchain-ai/langchain/releases/tag/langchain-core%3D%3D1.7.0 ；https://github.com/langchain-ai/langgraphjs/releases

#### Google ADK
- 窗口内状态：**有动态**：`adk-python v2.13.0`（release 自注 2026-10-22，feed 时间 10-24 02:08 +0800）。adk-js（最新 10-14）、adk-java（v1.13.0 为 10-21 21:58 +0800，窗外）无窗口内版本。
- 事实要点：12 个成熟实验特性转 stable（ea298d4）；**遥测默认切到 OpenTelemetry GenAI v2（`otel_semconv_1_44`），移除 `call_llm` span——破坏性**，可设 `ADK_TELEMETRY_SCHEMA_VERSION_OPT_IN=otel_semconv_1_36` 保留旧 schema（7838488）；`MongoDbSessionService`（跨 runner 副本共享会话）与 `MongoDbMemoryService`（关键字召回、无需向量索引），均为实验；新增 OpenSandbox 环境（69d1c90）、`vmaas: AgentEngineEnvironment`；"bind sandbox resources per tool call, not per computer"；RestApiTool 加 SSRF 防护（30726ea）；`BaseMemoryService.delete_memory`；eval 把调用耗时拆为 model/tool/framework；string-model agent 执行轮次最高快 8 倍（官方口径）。【A；8x 为官方自述 B】
- 影响：ADK 本周最大工程影响是**遥测 schema 默认切换**——依赖 `call_llm` span 的看板/告警会断；同时把会话与记忆存储扩到 MongoDB，降低"必须上 Vertex"的耦合。
- 来源：https://github.com/google/adk-python/releases/tag/v2.13.0（Highlights + All changes 前半）

#### Microsoft Agent Framework / Semantic Kernel / AutoGen
- 窗口内状态：Agent Framework **有动态**；SK 最新 python-1.45.0（10-06，窗外）；AutoGen 最新 python-v0.7.5（2025-09，长期静默）。
- 事实要点：`python-1.23.0`（自注 10-22，feed 10-23 01:06）三项 **[BREAKING]**：MCP 2.x 兼容基础并迁移 MCP transports/errors/schemas/生命周期（#9236）；AG-UI 端点注册须显式授权 scope 或单用户声明（#9413）；Docker shell `extra_run_args` 更名为 `unsafe_extra_run_args` 并显式信任要求（#9453）。新增：A2A 请求 metadata 中 function-invocation/client 参数按 allowlist 转发（#9193）；定义 caller-owned 与 framework-owned 两种 MCP client 生命周期（#9237/#9532）；Hyperlight 0.8 输出上限适配。`dotnet-1.26.0`（10-23 22:32）：保留 toolbox OAuth consent（#9565）、后台完成等待绑定执行身份（#9442）、stateless shell 工具不继承宿主 stdin（#9469）、安装式 Agent Framework builder skill（#9374）。【A】
- 影响：MCP 2.x 迁移与 AG-UI 授权显式化是**升级必改项**；"unsafe_" 前缀把容器逃逸风险写进 API 名。
- 来源：https://github.com/microsoft/agent-framework/releases/tag/python-1.23.0 ；…/dotnet-1.26.0 ；https://github.com/microsoft/semantic-kernel/releases ；https://github.com/microsoft/autogen/releases

#### Databricks Mosaic AI / Agent Bricks
- 窗口内状态：**有动态（月级归档，未逐条标日）**。Databricks 产品 release notes "October 2026" 列出：Default OAuth apps for external AI agents GA；Screen MCP tool calls and results for jailbreaks（Beta）；`ai_enrich` 可用外部 MCP 搜索提供方为行做 grounding（Beta）；Filter data per end user with OAuth custom identity claims；GPT-6.1 Terra 上 Unity Gateway；DeepSeek V4.1 Flash 计划退役。【A 标题级；具体日期未取得】
- 影响：Databricks 把 **MCP 调用越狱筛查**与**外部 Agent 的默认 OAuth 应用**放进数据平台治理，补上上期判断的"Harness 原语弱"中的身份与工具安全两格；但日期粒度为月，不能确认落在本窗口。
- 来源：https://docs.databricks.com/aws/en/release-notes/product/（10-28 读取，October 2026 目录）

#### 动态池（仅基础设施级）
- **Dify v1.18.0**（10-23 14:35）：Agent 节点 Output Routes（Agent 选择工作流分支，#42599）；`.ifpkg` 可移植应用包（携带内联 Agents/Skills/文件，#42066 等）；嵌套 Workflow Tool 作为子图运行，支持协调的暂停/恢复/停止（#40277 等）；Agent Knowledge Base beta（KnowledgeFS）；`difyctl` + OpenAPI。**升级须同时升级 API/worker/Agent Backend/Agent runtime 镜像；`/runs` 只接受 composition v2、拒绝 v1；旧 runtime 读不了新存的 v2 快照；本地 Agent sandbox 必须配置非空认证 token（#44152）；移除旧 AskHuman 工具与 deferred resume 路径（#43833）**。【A】
- **CrewAI 1.15.29–1.15.32**：`AgentExecutor` 转出实验；对话式 flow 上下文压缩（1.15.31）；修复 `output_file` 模板插值路径穿越与"反序列化、SQL 注入、路径穿越"漏洞（1.15.31，官方表述）；修复无来源私有记忆泄漏到所有 recall（1.15.29）。【A】
- **trueforge 0.180.1 / 0.181.0-rc.1~rc.3**（10-27）：上下文压缩前后发出 `thread.context_compaction_started/finished` 事件（含 trigger/usage/duration_ms）；自定义 cron 表达式；sandbox environment 创建限管理员、创建者或管理员可改删，并通过 list-permissions 暴露 schedule/sandbox MANAGE/DELETE；Helm 资源 tier 默认 small。【A】
- **pydantic-ai v2.60–v2.63**（10-23~10-28）：Harness 原语密集——`DetectLoops` 能力打断重复动作循环、`PostgresSpendStore` 共享 SpendLimits 预算、`task_timeout`、hosted MCP 工具名默认加服务前缀（兼容性变更）、`SummarizingCompaction` 摘要改存为 `CompactionPart`、`InputGuardrail` 关闭 fail-open 路径。【A】
- 来源：https://github.com/langgenius/dify/releases/tag/1.18.0 ；https://github.com/crewAIInc/crewAI/releases ；https://github.com/truefoundry/trueforge/releases ；https://github.com/pydantic/pydantic-ai/releases

#### 模块 1 结论（供母稿）
1. 本周 Harness 层的共同主题是**"中断后的可重放恢复 + 升级迁移成本"**：OpenClaw 10.7/10.8 以 replay-safe recovery 为头条并开 LTS 轨；Dify 1.18 的 run protocol v2 不向后兼容；MAF 1.23 三项 breaking；ADK 2.13 遥测 schema 默认切换；langchain-core 1.7 改流式事件。
2. **权限与安全事件进入 SDK 契约**：Claude Code `safety_event`、MAF `unsafe_extra_run_args`、AG-UI 授权显式化、Composio/pydantic-ai 的 hook/guardrail fail-closed（见 C/D）。
3. **成本归因字段细化**：Claude SDK 按缓存寿命拆 token、pydantic-ai 共享预算存储、LangGraph 快照频率默认值重设。

### 模块洞察
Harness 层已不再比拼"能不能编排"，而是比拼**升级与恢复时的契约稳定性**：谁能把会话恢复、遥测 schema、流式事件与权限配置的变更做成可预告、可回退、可双轨（主线/LTS）的发布，谁就降低了企业的持有成本。本周 5 个主要框架中有 4 个发出了需要代码或配置改动的变更，OpenClaw 则用 LTS 轨回应同一问题。

## 2. Runtime / Session / State 执行层

### 本周模块结论

1. **"恢复不重放已完成副作用"成为 runtime 新门槛**：OpenClaw 10.7 记录 recovery provenance 与未完成工具结果、10.8 让被 kill 的 run 释放 restart-recovery fence；E2B 2.61.0 `Sandbox.create` 幂等键；Dify 1.18.0 嵌套 workflow 协调暂停/恢复/停止；a2a-python 1.3.0 超时释放挂起的中断任务。
2. **会话状态的存储面外延到文件系统与通用数据库**：AgentCore Runtime FUSE 挂载（10 月档）、ADK `MongoDbSessionService`、OpenViking durable content write task。
3. **托管 runtime 大厂本周静默**：Google Agent Engine、Microsoft Foundry Hosted Agents 无窗内条目；国内百炼/方舟/ADP 无窗内 runtime 条目。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Runtime | 有动态（10 月档 FUSE 挂载，未标日）；SDK v1.25.0（10-24）/v1.25.1（10-28） | AWS release notes；GitHub releases | 是 |
| Google Vertex Agent Engine / Managed Agents | 无 runtime 级动态（仅 Workbench 维护）；ADK 侧 AgentEngineEnvironment | Vertex / GEAP release notes | 否 |
| Microsoft Foundry Hosted Agents | 无动态 | Foundry devblog RSS；MAF releases | 否 |
| 阿里云百炼 / PAI | 限述：窗内无可核条目（Evolution 10-21、Agent Studio 手册 10-13 为窗外） | help.aliyun.com；bailian docs；开发者社区 | 否（背景） |
| 火山方舟 / Coze | 无 runtime 级动态（coze-studio 最新 02-05） | 方舟公告；GitHub releases | 否 |
| 腾讯云 ADP / 元器 | 无窗内日期条目（10 月上下文管理仅标月份，页 10-19 更新） | cloud.tencent.com 产品动态 | 否（背景） |
| OpenClaw sessions / cron / Gateway | 有动态（10.7/10.8/10.10-beta.4/9.35） | GitHub releases | 是 |
| E2B / Modal / Daytona | E2B 有动态；Modal 1.6.3（10-27）；Daytona 无（0.225.0=10-16，GitHub 主仓 10-03 归档） | 各 changelog / releases | 是（见模块 3） |

### 深度笔记


#### AWS Bedrock AgentCore Runtime
- 窗口内状态：**有动态（月档，未逐条标日）** + SDK 窗内版本。
- 事实要点：Runtime 容器内支持 **FUSE 挂载文件系统**，Agent 可在运行时挂存储并按本地文件读写，不必编排下载/上传（October 2026 档）。【A 内容 / 日期限述】9 月档背景：harness 交互式 shell（WebSocket，同一隔离 microVM 会话内保持环境变量/工作目录/历史/进程，重连回放最多 256 KB 缓冲输出，单会话最多 10 个 shell）。SDK v1.25.0（10-24）支持**对已存在 session 做评估**并新增 RecommendationClient。【A】
- 影响：Runtime 的状态面从"会话内存"扩到**会话文件系统**；与 E2B/Modal 的卷与快照形成正面竞争。
- 来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ；https://github.com/aws/bedrock-agentcore-sdk-python/releases/tag/v1.25.0

#### Google Vertex AI Agent Engine / Managed Agents
- 窗口内状态：**无 runtime 级动态**（核验入口：1. Vertex release notes 窗内仅 Workbench v2 维护；2. Gemini Enterprise Agent Platform release notes 窗内为治理与图像输出条目）。
- 侧面信号：ADK v2.13.0 新增 `vmaas: AgentEngineEnvironment`、sandbox manager 命令与就绪 helper、MongoDbToolset 可 pickle 以部署到 Agent Engine 且不打包连接串（ab5cb45/2f6c666）。【A】
- 影响：Agent Engine 本周的增量来自 SDK 侧适配，而非平台发布。

#### Microsoft Foundry Hosted Agents
- 窗口内状态：**无动态**（核验入口：1. Foundry devblog RSS；2. Agent Framework releases——dotnet-1.26.0 "bind background completion waits to execution identity (#9442)"属框架侧）。

#### 阿里云百炼 / PAI（Runtime）
- 窗口内状态：**限述/无窗内条目**（入口同 A-02：应用功能动态、Evolution 更新日志、开发者社区周报摘要）。背景：Agent Studio 手册（10-13）称提供 Managed Agent（运行、会话、事件流、密钥、环境）、Sandbox、AutoModel；新用户含"10 小时 Managed Agent 运行时长"（阿里云自述，B）。

#### 火山方舟 / Coze
- 窗口内状态：**无 runtime 级动态**（核验入口：1. 方舟 API 兼容性升级公告——属协议层，见 A-02；2. `coze-dev/coze-studio` releases 最新 V0.5.1 为 2026-02-05；3. `coze-dev/coze-loop` releases 最新 2026-03-26）。

#### 腾讯云 ADP / 元器
- 窗口内状态：**无窗内日期条目**（产品动态页 10-19 更新；10 月"超时自动清空上下文""企微群聊共享上下文"仅标月份）。背景：上期报元器自 10-29 起停止新建智能体 API key 分发（生效日在本窗之后 1 天，属待生效事项）。
- 影响：ADP 的会话治理以**上下文清空/共享开关**降 Token 消耗，属"会话生命周期产品化"的轻量版本。

#### OpenClaw sessions / cron / Gateway runtime（必覆盖）
- 窗口内状态：**有动态**（见 A-01 全部版本）。Runtime 相关摘录：
  - 10.7：中断会话保留 recovery provenance 与未完成工具结果；停止会话在接收新消息前清理终态残留；大批量子会话完成结果控制在请求方上下文内；数据库维护拒绝时保留 peer readers/borrowers；不兼容的保留 agent 数据库隔离；R2 校验与恢复可续做。【A】
  - 10.8：被 kill 的 run 释放 restart-recovery fence；中断与刚接受的子会话在 Gateway 重启后恢复；回复运行时无法发布时入站消息不再无限重试；启动工作不再继承已关闭 SQLite reader scope；agent 数据库启动时短暂锁竞争重试。【A】
  - 10.10-beta.4：同会话显式定时跟进保留已认证 operator 权限，含 one-shot `next_check` 重新挂载，同时保留撤销边界（#176422）。【A】
  - 9.35（LTS 轨）：worker heap 上限、空闲 Codex app-server 30 秒退役、archive worker 复用——长时运行 Gateway 不再累积内存。【A】
- 影响：OpenClaw 的恢复边界从上期的"重启后恢复 turn"推进到**"恢复时不重放已完成副作用、不让残留阻塞新消息"**（replay-safe）；cron/自动化的权限在定时跟进中被显式保留并可撤销。这与 Foundry 长任务韧性（上期：重连不让重复外部动作变安全）的边界划分形成对照：OpenClaw 在 runtime 内部记录未完成工具结果作为恢复依据。

#### E2B（runtime 侧）
- 窗口内状态：**有动态**——见 B-02。Runtime 相关：`Sandbox.create` 新增 **idempotency key**（e2b 2.61.0，10-27 00:23）。

#### Modal（runtime 侧）
- 窗口内状态：**有动态**——Python SDK 1.6.3（10-27 发布；GitHub tag 10-28 03:22 +0800）：新 Image Builder 版本 2026.10；`App.stop()` 可编程停止应用；`--shared` 创建 Shared Endpoints；`Image.from_registry()` 可凭 secret 拉 ECR/GCP Artifact Registry。【A】

#### Daytona（runtime 侧）
- 窗口内状态：**无动态**（核验入口：1. daytona.io/changelog——最新 0.225.0 为 10-16（NVIDIA B200 GPU 类型），窗外；2. GitHub `daytonaio/daytona` 页面显示"archived by the owner on Oct 3, 2026. It is now read-only"，releases 停在 0.190.0（06-23））。
- 说明：GitHub 主仓归档与 changelog 继续更新同时存在；本期不推断原因，仅记"发布渠道以 daytona.io/changelog 为准"。【A 页面事实】

#### trueforge（自托管 runtime，热度对象）
- 窗口内状态：**有动态**——0.180.1/0.181.0-rc.x（10-27）：上下文压缩起止事件、Helm 资源 tier 默认 small 与显式资源表优先、sandbox environment 管理权限收紧（见 A-01）。

#### 模块 2 结论（供母稿）
1. **"恢复不重放"成为 runtime 新门槛**：OpenClaw 10.7/10.8 记录恢复溯源与未完成工具结果；E2B 用 idempotency key 让 sandbox 创建可安全重试；Dify 1.18 嵌套 workflow 协调暂停/恢复/停止。三者共同指向"重试/恢复时如何不重复副作用"。
2. **会话状态的存储面外延**：AgentCore FUSE 挂载、ADK MongoDB 会话服务、腾讯 ADP 云盘（窗外）——会话状态从内存/KV 走向文件系统与通用数据库。
3. **托管 runtime 大厂本周相对静默**（Google/Microsoft 无条目），增量集中在 AWS 月档与开源/中立 sandbox 厂商。

### 模块洞察
Runtime 竞争正从"会话能否恢复"（上期）推进到"恢复/重试时副作用是否只发生一次"。这要求 runtime 记录**工具调用的完成状态**而不仅是对话历史，并要求下游（sandbox 创建、外部 API）提供幂等语义；本周 OpenClaw 与 E2B 分别从两端补上了这一链条。

## 3. Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论

1. **重试与幂等协议化**：E2B 2.60.0 按服务端 `Should-Retry` 头重试、发送后网络错误不再重试；2.61.0 `Idempotency-Key`；2.59.0 `dnsServers` 闭合 DNS 出站。
2. **"Agent 能登录但看不到密码"成为浏览器层默认目标**：Browserbase × 1Password（10-22）人批 + 扩展内填充；Authenticated Fetch（10-27）复用 Context cookie 但不回写；agent-browser v0.40.0 修存储恢复把 token 暴露给页面脚本。
3. **本地沙箱漏洞面被具体化**：Claude Code v2.1.309 修复沙箱外执行 shell 启动文件、symlink 绕过 `denyWrite`、沙箱命令可改 `--mcp-config`。
4. **fail-closed 第二周延续并扩展到配置信任边界**：agent-browser v0.39.3 禁止自动发现的项目配置设置可执行路径/浏览器参数/插件，MCP 参数不能覆盖服务端访问设置。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| E2B | 有动态：SDK 2.59.0（10-23）、2.60.0（10-26）、2.61.0（10-27）；desktop-python 2.7.2 | GitHub releases | 是 |
| Browserbase / Stagehand | 有动态：1Password for Agents（10-22）、Authenticated Fetch（10-27）；server-v3 v3.7.7（10-24） | browserbase.com/changelog；GitHub releases | 是 |
| Daytona | 无动态（0.225.0=10-16）；GitHub 主仓 10-03 归档 | daytona.io/changelog；GitHub | 否 |
| Modal | 有动态：SDK 1.6.3（10-27）Image Builder 2026.10、`App.stop()` | modal.com changelog；GitHub | 是（简） |
| OpenAI / Anthropic Computer Use | OpenAI：gpt-6.1-terra（10-26，模型层）；Anthropic：Claude Code 沙箱修复（10-23/10-24） | platform changelog；claude-code releases | 是 |
| 云厂 Browser / Code Interpreter | AWS Web Search 域名过滤（10-23）；Foundry Browser automation GA（10-19 窗外）；ADK Gemini 3.x computer use schema | AWS What's New；devblog；ADK releases | 是（简） |
| browser-use（热度） | 有动态：0.13.14（10-27，PyPI 待审批） | GitHub releases | 是 |
| vercel-labs/agent-browser（热度） | 有动态：v0.39.2/0.39.3/0.39.4/0.40.0 | GitHub releases | 是 |
| microsoft/playwright-mcp | 无动态（v0.0.83=09-29） | GitHub releases；Foundry devblog | 否 |

### 深度笔记

#### E2B
- 窗口内状态：**有动态**（JS/Python SDK 2.59.0、2.60.0、2.61.0；desktop-python 2.7.2；code-interpreter-python 2.11.3–2.11.5）。
- 事实要点：
  - 2.59.0（10-23 00:20）：网络选项新增 `dnsServers`/`dns_servers`——当 `allowOut` 含域名时沙箱可访问的 DNS 服务器；不填为默认 8.8.8.8，传 IP 列表则仅允许这些，传 `[]` 则全禁；只开防火墙、不改 `/etc/resolv.conf`；`updateNetwork` 不填时重置为默认。弃用 `apiUrl`/`sandboxUrl` 及对应环境变量（下个大版本移除）。【A】
  - 2.60.0（10-26 22:42）：控制面 API 错误按 `Should-Retry: true` 重试，或对无该头的 429/502/503/504 重试；`Should-Retry: false` 永不重试；**移除按方法与"可重放操作"的重试白名单；发送后网络错误不再重试，连接失败仍重试**；Python 创建沙箱时保留省略的 public-traffic 选项由服务端决定默认；undici 升级修复 CVE-2026-109869。【A】
  - 2.61.0（10-27 00:23）：`Sandbox.create` 新增 `idempotencyKey`/`idempotency_key`，发送 `Idempotency-Key` 头；键须为 1–255 个小写 ASCII 字母、数字或连字符。【A】
  - desktop-python 2.7.2（10-22 17:31）：要求 pillow 13 以修复 CVE-2026-112404 与 CVE-2026-112895。【A】
- 影响：E2B 本周把**重试语义交给服务端声明（Should-Retry）+ 客户端幂等键**，并明确"已发送请求不重试"，是对"沙箱创建重复计费/重复副作用"问题的协议化解法；`dnsServers` 让出站白名单真正闭合 DNS 侧信道。
- 证据级：A。
- 来源：https://github.com/e2b-dev/E2B/releases/tag/e2b%402.61.0 ；…/e2b%402.60.0 ；…/e2b%402.59.0 ；…/%40e2b%2Fdesktop-python%402.7.2

#### Browserbase / Stagehand
- 窗口内状态：**有动态**。
- 事实要点：
  - 10-22 **1Password for Agents**：Agent 遇到登录表单时请求某个登录项；用户在自己设备上批准/拒绝；1Password 在浏览器扩展内自动填充并提交，提交后移除已填值；官方称凭证不经过应用、模型或日志；会话可配置零数据保留、不录制不记录。【A 产品公告；"凭证不经过"为厂商表述 B】
  - 10-27 **Authenticated Fetch**：Fetch 端点传 `contextId` 复用 Context 中保存的登录 cookie，返回 raw/markdown/结构化 JSON；使用最后一次保存会话的 cookie，**不回写**更新后的 cookie；需要 JS 渲染或 JS 生成认证 token 的页面仍需浏览器会话。【A】
  - Stagehand：server-v3 v3.7.7（10-24 02:09）——可空 act action schema 设 `additionalProperties false`（#3150）、本地 attach 遵守 CAPTCHA 感知选项（#3114）、较新 Claude 模型不强制 done 工具（#3132）、有 shadow root 时用 XPath 回退（#3287）、移除 `browse`（#3306）。python 4.3.1a0.dev 系列（10-28）移除过时 CrewAI 集成（#3336）。【A】
- 影响：浏览器层的竞争点从"能否登录"转到**"凭证不进入模型上下文"**的登录路径（人批 + 扩展内填充）与**免浏览器的已认证抓取**（成本更低，但不刷新 cookie）。
- 来源：https://www.browserbase.com/changelog（Oct 22 / Oct 27 条目）；https://github.com/browserbase/stagehand/releases

#### Daytona
- 窗口内状态：**无动态**（见 B-01；0.225.0 为 10-16，窗外）。

#### Modal
- 窗口内状态：**有动态**（见 B-01：SDK 1.6.3，Image Builder 2026.10、`App.stop()`）。沙箱专属条目：本次未见。
- 来源：https://modal.com/docs/reference/changelog（1.6.3 (2026-10-27)）；https://github.com/modal-labs/modal-client/releases

#### OpenAI / Anthropic Computer Use
- OpenAI：10-26 `gpt-6.1-terra` 发布，官方描述含"precise computer use"（模型层；未取得 Computer Use 工具接口变更条目）。【A 描述】
- Anthropic：Claude Code v2.1.309 修复多项沙箱逃逸类缺陷——macOS/Linux 沙箱 Bash 在每条命令前于沙箱外执行 shell 启动文件；macOS 沙箱 `denyWrite` glob 经 symlink 时不生效；沙箱命令与自动接受的编辑可修改 `--mcp-config` 文件；worktree 隔离会话接受部分应拒绝的 locale 前缀/zsh 算术命令。v2.1.310 Linux `/sandbox` 提示 Ubuntu AppArmor 对 user namespace 的限制阻止 bubblewrap 启动。【A】
- 影响：Anthropic 的本地沙箱修复说明"**沙箱边界 = shell 启动链 + symlink 解析 + 配置文件写保护**"三处同时成立才算闭合；自建 Harness 用 bubblewrap/seatbelt 的团队可直接对照自查。
- 来源：https://platform.openai.com/docs/changelog ；https://github.com/anthropics/claude-code/releases/tag/v2.1.309 ；…/v2.1.310

#### 云厂 Browser / Code Interpreter
- AWS：10-23 Bedrock Web Search 支持域名过滤与用户位置（What's New）。AgentCore Browser/Code Interpreter 本窗无独立条目。【A】
- Microsoft：Foundry Browser automation tool GA 为 10-19（窗外背景）。
- Google：ADK 2.13.0 支持 Gemini 3.x computer use 浏览器动作 schema；"bind sandbox resources per tool call, not per computer"；新增 OpenSandbox 环境。【A】
- 国内：未取得窗内条目（入口：方舟/百炼/ADP 动态页，见 A-02）。

#### browser-use（热度对象）
- 0.13.14（10-27 06:00）：加入 OpenAI browser tools 与共享 Bash helper；改进有界页面观测、表单状态、文件访问与浏览器恢复；缩放显示下截图/裁剪/点击对齐；支持 Browser Use Cloud SDK V4。**发布说明注明受保护发布流程需另一位 release reviewer，PyPI 发布在批准之后**（即 GitHub release ≠ 已上 PyPI）。【A】
- 来源：https://github.com/browser-use/browser-use/releases/tag/0.13.14

#### vercel-labs/agent-browser（热度对象）
- v0.39.2（10-23 03:52）：策略文件不可读/无效时**拒绝动作**（#2179）；MCP 参数未声明键返回错误（#2175）；点击隐藏/禁用/视口外元素报错（#2173）；主文档重定向到被屏蔽主机时报错（#2114）。【A】
- v0.39.3（10-26 09:37）：自动发现的项目配置不能设置可执行路径、浏览器参数或插件（#2180）；**MCP 工具参数不能覆盖服务端的网络/文件/策略/主机访问设置**（#2181）；inspect WebSocket 只接受本地 DevTools origin（#2182）；无效密钥时不覆盖认证加密密钥（#2178）。【A】
- v0.39.4（10-26 13:50）：卡死标签页以 `page_wedged` 失败并在二次超时后替换（#2100）；`--pin-tab` 防止其他会话抢占（#2135）。【A】
- v0.40.0（10-28 05:32）：**破坏性**——`@agent-browser/eve` 需 eve ≥0.84.0（#2226）；`startAgentBrowserMcp` 每个 Vercel Sandbox 一个 MCP server（#2228）；修复 state load 恢复存储时把保存的 token 暴露给页面脚本、跨重定向写错 origin（#2212）。【A】
- 影响：连续两周把"fail-closed + 参数不可越权"作为主题（上期已报策略 fail-closed），本周扩展到**配置信任边界**与**存储恢复的 origin 绑定**。
- 来源：https://github.com/vercel-labs/agent-browser/releases

#### microsoft/playwright-mcp
- 窗口内状态：**无动态**（releases 最新 v0.0.83 为 09-29；核验入口 2：Foundry devblog 窗内无浏览器条目）。

#### 模块 3 结论（供母稿）
1. **重试与幂等协议化**（E2B Should-Retry + Idempotency-Key）是本周 sandbox 层最具结构性的变化。
2. **凭证与浏览器的隔离**：Browserbase 1Password 人批自动填充、Authenticated Fetch 不回写 cookie、agent-browser 修存储恢复 token 暴露——"Agent 能登录但看不到密码"成为默认设计目标。
3. **本地沙箱漏洞面**：Claude Code 2.1.309 的修复清单给出可复用的自查项（启动文件、symlink、配置写保护）。

### 模块洞察
执行环境层的差异化从"隔离强度"转到**"可安全重试 + 凭证不可见"**两项协议能力。E2B 的 Should-Retry/幂等键与 Browserbase 的人批填充都在把原本由应用层兜底的风险收进基础设施契约。

## 4. Tool Gateway / Protocol / Integration 工具层

### 本周模块结论

1. **MCP 本周在分发层而非规范层**：TS SDK v2.4.0 实现 Skills over MCP（SEP-2640，含大小/摘要/frontmatter 校验与缓存字段）；Registry v1.8.2–v1.8.6 做生产容量与诊断；规范最新仍为 `2026-07-28`。
2. **工具网关成为策略执行点**：Composio core 0.27.0 session hooks 可在执行前或结果到达 Agent 前阻断，并以 `resultType: 'blocked'` 返回；Arcade 1.12.0 Preview 工具响应脱敏本次凭证、拒绝解析到内网的出站主机。
3. **云厂网关吞并模型流量**：AWS AgentCore Gateway（10-22）InvokeModel 方言翻译 + 有序 fallback + 默认熔断。
4. **A2A 规范静默、SDK 补中断任务回收**：a2a-python 1.3.0。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP 规范 / SDK / Registry | 规范无新版（2026-07-28）；TS SDK 2.4.0 + 1.32.2（10-24）；Py SDK 无（v2.3.0=10-03）；Registry v1.8.2–1.8.6 | GitHub releases ×4；MCP blog | 是 |
| A2A | 规范无新版（v1.0.1=05-28）；a2a-python 1.3.0（10-27） | GitHub releases ×2 | 是 |
| Composio | 有动态：core/slim 0.27.0（10-22）、CLI beta.497–504 | GitHub releases | 是 |
| Arcade | 有动态（Preview）：1.12.0（10-27 生成，已在 Arcade Cloud 运行） | docs.arcade.dev changelog；arcade-mcp Atom（空） | 是 |
| Nango | 有托管发布标签（10-23、10-28），变更内容未取得 | GitHub Atom；nango.dev/changelog；docs.nango.dev/changelog（404） | 否 |
| Pipedream Connect | 本次未取得 | GitHub Atom（最新 2025-11）；docs changelog（404） | 否 |
| 云厂 Gateway / Toolbox | AWS 有动态（10-22）；Microsoft toolbox OAuth consent（MAF）；Google 未取得 | AWS What's New；MAF releases；GEAP notes | 是（AWS） |
| mcp-gateway-registry（热度） | 有动态：1.34.0（10-23） | GitHub releases | 是 |

### 深度笔记

#### MCP（规范与官方 SDK / Registry）
- 窗口内状态：**规范无新版**（`modelcontextprotocol/modelcontextprotocol` releases 最新 `2026-07-28`；blog.modelcontextprotocol.io 首页窗内无新文）；**SDK 与 Registry 有动态**。
- 事实要点：
  - **TypeScript SDK v2.4.0**（10-24 02:32；client/server/core 2.4.0、node 2.1.2）：
    - **Skills over MCP（SEP-2640）**：服务端 `loadSkills(folder)` + `SkillsExtension.attach(server)` 发布一个技能文件夹，提供 `skills/list`、`skills/get`、`resources/directory/read` 与 `skill://{+path}` 资源模板；客户端 `SkillsClient` 列出、读取并**校验大小、摘要与 SKILL.md frontmatter**（不符抛 `SkillVerificationError`，缓存副本校验失败会以 `cacheMode: 'refresh'` 重取一次）；在 2025-11-25 与 2026-07-28 两个协议修订上均可用；仅 2026-07-28 上服务端发送缓存字段 `ttlMs`/`cacheScope` 且客户端要求必填；`attach` 标为 experimental，其余 Skills API 稳定。【A】
    - 升级注意：对 number 参数使用 `x-mcp-header` 按 2026-07-28 规范被拒——客户端不列出该工具，服务端对调用返回 **-32020**（#2762/#2960）；在 2025-11-25 连接上 `outputSchema` 结果不再包一层 `{ result }`（#3081）；内置 Ajv 改用 fast-uri 3.1.8，`my_tool:output` 这类非法 scheme 的 `$id`/`$ref` 不再编译（#3083）。【A】
    - OAuth：`OAuthClientProvider.scopeForRefresh(tokens)` 可选——用于拒绝无 scope refresh 的授权服务器（**Microsoft Entra ID 在 client 与 resource 为同一 app registration 时返回 AADSTS90009**，#2718/#3085）；默认请求不变。【A】
    - `ServerEvent` 可带 params，网关可携 `_meta` 转发变更通知（#3057）；v1→v2 升级指南也做成可安装 agent skill（#2968）。【A】
  - TypeScript SDK 1.32.2（v1.x 维护，10-24 02:06）：connect() 后若能力已声明仍可注册（#2958）。【A】
  - Python SDK：最新 v2.3.0（10-03 06:02 +0800），窗内无版本。【A】
  - **MCP Registry v1.8.2–v1.8.6**（10-23 ~ 10-27）：v1.8.3 为服务名子串搜索建索引（#1730）；v1.8.4 在事务外校验 registries 并计时连接池等待（#1562）；v1.8.5 生产性能诊断（请求积压、DB 池/查询指标、与 ingress request ID 关联的慢列表日志，#1742/#1743）、发布者修复（P-384 签名定宽、初始化时记录 repository.id 以便改名后可解析、GitLab 嵌套子组 URL），**更严格校验不完整仓库元数据——既存无效元数据在重新发布时可能需修正**；v1.8.6 搜索性能（covering index 选页键、非空搜索词至少 3 个 Unicode 字符否则 HTTP 422；验证的突发容量基于 3-CPU PostgreSQL 配额）。【A】
- 影响：MCP 本周不在规范层而在**分发层**：Skills over MCP 把"技能包"变成可校验、可缓存的 MCP 资源，Agent 工具与技能的分发通道合流；Registry 进入"生产容量与可观测"阶段。`x-mcp-header` 的 -32020 是需要回归的兼容性点。
- 来源：https://github.com/modelcontextprotocol/typescript-sdk/releases/tag/v2.4.0 ；…/%40modelcontextprotocol%2Fserver%402.4.0 ；…/%40modelcontextprotocol%2Fclient%402.4.0 ；https://github.com/modelcontextprotocol/registry/releases（v1.8.2–1.8.6）；https://github.com/modelcontextprotocol/modelcontextprotocol/releases ；https://github.com/modelcontextprotocol/python-sdk/releases

#### A2A
- 窗口内状态：**规范无新版**（`a2aproject/A2A` 最新 v1.0.1 为 2026-05-28）；**a2a-python v1.3.0**（10-27 18:06）有动态。
- 事实要点：服务端**在可配置超时后释放被挂起（parked）的中断任务**（#1338）；状态事件校验失败后可恢复（#1365）；执行器失败经事件消费者记录（#1366）；拒绝布尔型 JSON-RPC 请求 ID（#1350）；跳过格式错误的 agent card 签名头（#1335）；v0.3 兼容适配器返回 A2A 错误码（#1369）。【A】
- 关联：Microsoft Agent Framework python-1.23.0 按 allowlist 转发 A2A 请求 metadata 中的函数调用/客户端参数（#9193）。【A】
- 影响：A2A 的工程增量集中在**中断任务的资源回收与错误语义**，与模块 2 的"恢复/挂起"主题一致。
- 来源：https://github.com/a2aproject/a2a-python/releases/tag/v1.3.0 ；https://github.com/a2aproject/A2A/releases

#### Composio
- 窗口内状态：**有动态**。
- 事实要点：
  - `@composio/core` / `@composio/slim` **0.27.0**（changesets 发布，10-22 20:39）：**Session hooks**——hook 可在工具调用执行前阻断，或在结果到达 Agent 前阻断；`create()`/`update()` 接受 `hooks`（`update` 时整体替换，`null` 清空，不可与 `experimental.sessionConfigId` 同用）；示例 hook `before_execute` + `condition_check`（自然语言条件，如"发邮件给 example.org 以外的人"）+ `action: 'block'`；被阻断调用返回 `resultType: 'blocked'`、空 data、`blockReason`，provider 集成以失败调用交给 Agent；所有结果在 hook 生效时带 `hookResults`；`proxyExecute()` 现返回 `resultType: 'completed' | 'blocked'`，**被阻断请求无 HTTP 响应，读 `status` 的 TS 代码须先判 `resultType`**（破坏性行为变化）。【A】
  - CLI 0.5.1-beta.497~504（10-23~10-27）：**对 `composio proxy` 强制 consumer 权限闸**（#5093）；文档"在 Agent 落地处说明凭证边界"（#5114）、重定向 Agent 会猜的 auth/security URL（#5113）、更正 Custom MCP 认证/撤销/发现说明（#5016）；修补 undici/body-parser/zod 高危通告（#5121）。【A】
- 影响：Composio 把**策略执行点放进会话**（执行前 + 结果前两处），且允许用自然语言条件描述策略——工具网关从"连接器目录"转为"带策略的执行代理"。
- 来源：https://github.com/ComposioHQ/composio/releases/tag/versioning-example%400.1.11（含 core 0.27.0 changeset 全文）；https://github.com/ComposioHQ/composio/releases（CLI beta.497–504）

#### Arcade
- 窗口内状态：**有动态（Preview）**：Arcade **1.12.0 Preview**，"Live on Arcade Cloud"，生成于 2026-10-27 06:59 UTC（=10-27 14:59 +0800），自托管下个版本获得；说明"内容、版本号在正式发布前可能变化"。【A，状态为预览】
- 事实要点：可选的集群内用量上报 collector（不必直报 Arcade Cloud）；`deployments.resourceQuota.enabled`、`deployments.network.egress.allow`；**workload identity 让 engine 访问云密钥库无需长期凭证**；`tools.worker_secret_sharing` 可对 API 注册的 worker 扣留 secret；出站请求拒绝解析到/编码私有内网地址的主机名（SSRF/DNS rebinding）；**工具调用响应在到达调用方/日志/hook 前脱敏该次调用提供的凭证原文**；部署日志写入时即脱敏；修复并发授权下远程 MCP OAuth code 被错误 client 兑换的竞态（新增列绑定 pending 授权与构造 URL 的 client）；Slack/Google Calendar 工具包重建、多数工具包改名（破坏性）；重部署服务不得绑定 `0.0.0.0` 且 `/worker/health` 须免认证。【A】
- 已试入口：1. `ArcadeAI/arcade-mcp` releases Atom（返回空）；2. docs.arcade.dev changelog（成功）。
- 影响：Arcade 本周重心在**自托管安全基线**（SSRF、密钥扣留、凭证回显脱敏、OAuth 竞态）——上期是"工具推荐降 token"，本期是"网关自身不泄密"。
- 来源：https://docs.arcade.dev/en/home/changelog（10-28 读取）

#### Nango
- 窗口内状态：**有发布、无可读说明**——`managed-1.6.28`（10-23 15:29）、`managed-1.6.29`（10-28 04:19）两个托管版本标签，正文仅"Managed release ..."。
- 已试入口：1. GitHub releases Atom（仅标签）；2. nango.dev/changelog（重定向至 docs.nango.dev/changelog）；3. docs.nango.dev/changelog（Page Not Found）。→ **变更内容本次未取得**。

#### Pipedream Connect
- 窗口内状态：**本次未取得**（已试入口：1. `PipedreamHQ/pipedream` releases Atom——最新 2025-11；2. pipedream.com/docs/connect/changelog——HTTP 404）。

#### 云厂 Gateway / Toolbox
- AWS AgentCore Gateway：InvokeModel + fallback（10-22，见 A-02）；Step Functions connector 把状态机暴露为 MCP 工具（10 月档）。【A】
- Microsoft：Agent Framework dotnet-1.26.0 "preserve toolbox OAuth consent"（#9565）；`microsoft/mcp-gateway` 最新 v1.0.0 为 10-17 07:49 +0800（上期窗内、本期窗外背景）。【A】
- Google：本窗未取得 Agent Gateway 条目（入口：GEAP release notes、Vertex release notes）。
- 国内：方舟 Responses API 兼容 `namespace`/`defer_loading`（工具分组与懒加载，见 A-02）。

#### agentic-community/mcp-gateway-registry（热度对象）
- **1.34.0**（10-23 09:51）：**移除 LiteLLM**，改用自有 embeddings 适配器（OpenAI/兼容端点、Azure OpenAI、Bedrock Titan、Bedrock Cohere），已存向量保持有效无需重嵌入；`cohere/`、`voyage/` 及其他 LiteLLM 专属前缀在启动时报错；远程 embeddings 超时 600s→30s；安全扫描器的 `llm` analyzer 不可用（Cisco AI Defense scanner 依赖 LiteLLM），配置了则每次扫描失败并把实体记为 unsafe；移除 shell CLI（Anthropic 导入曾把公共 registry 字段插值进 shell/Python 命令串，#1794）；**Entra 组恢复默认开启**——委托用户 token 缺组声明时以 on-behalf-of 换 Microsoft Graph token 读成员关系，租户未授予 Graph `User.Read` 委托同意则返回 503；`ENTRA_ENABLED=0` 此前被当字符串而启用，现正确关闭；镜像移除 10-20 被根程序撤信的 eMudhra 两个根 CA。【A】
- 影响：说明 MCP 网关的供应链风险面（LiteLLM 依赖、shell 插值）正在被主动收缩；Entra 组恢复是"**网关用委托身份做授权**"的典型落地细节。
- 来源：https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.34.0

#### 模块 4 结论（供母稿）
1. **MCP 承载面扩到"技能分发"**（SEP-2640 + 校验/缓存），Registry 进生产容量阶段；规范本身本周无新版。
2. **工具网关成为策略执行点**：Composio session hooks（执行前/结果前阻断）、Arcade 凭证回显脱敏与 SSRF、AgentCore Gateway 把模型流量也纳入。
3. **供应链与证书事件外溢**：10-20 eMudhra 根撤信在本周被 OpenClaw、mcp-gateway-registry、Phoenix、LangGraph（certifi 2026.10.19）等多处同步处理。

### 模块洞察
"工具"与"技能"的分发通道正在合流到 MCP，"工具调用"与"模型调用"的流量正在合流到同一网关。谁掌握网关，谁就掌握策略执行点、成本计量点和审计点；本周 AWS（模型流量）、Composio/Arcade（工具策略）、MCP（技能分发）从三个方向逼近同一位置。

## 5. Identity / Auth / Permission 权限层

### 本周模块结论

1. **"凭证不进模型"出现多处具体机制**：1Password 人批填充（Browserbase）、Arcade 响应脱敏、OpenClaw `hooks.token` 不下放子进程、agent-browser 存储恢复 origin 绑定。
2. **Entra 成为生态事实兼容目标**：Claude apps gateway `oidc.user_id_claim`（`oid`）、MCP TS SDK `scopeForRefresh`（AADSTS90009）、mcp-gateway-registry Entra 组恢复（OBO→Graph）、MAF toolbox OAuth consent——4 个独立项目同周适配；Entra 官方 what's new 本周无 Agent ID 条目。
3. **Google 把意图匹配做成可审计开关**（10-26 `sgpUserIntentMatching`）。
4. **权限显式化是破坏性升级的主要来源**：MAF AG-UI scope、Composio proxy 权限闸与 `blocked` 结果、Dify 本地 sandbox 认证 token 必填。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 限述：CLI v1.0 identity 命令（10 月档）；Identity 服务窗内条目未取得 | AWS release notes；What's New RSS | 否（限述） |
| Microsoft Entra Agent ID | 官方无窗内条目（what's new 最新 2026-06）；第三方 4 项适配 | learn.microsoft.com；Foundry devblog；各项目 releases | 是（侧面） |
| Google Agent Identity / 语义治理 | 有动态：10-26 意图匹配开关 | GEAP release notes | 是 |
| Arcade Auth | 有动态（Preview）：OAuth 竞态修复、profile scope、workload identity | docs.arcade.dev changelog | 是 |
| Composio Auth | 有动态：proxy 权限闸、凭证边界文档 | GitHub releases | 是 |
| Nango Auth | 内容未取得（3 入口） | 见模块 4 | 否 |
| Pipedream Auth | 本次未取得（2 入口） | 见模块 4 | 否 |

### 深度笔记

#### AWS AgentCore Identity
- 窗口内状态：**限述**——AgentCore CLI v1.0（10 月档，未标日）提供 `identity` 直接资源命令与凭证创建向导；未取得 Identity 服务本身的窗内条目（入口：AgentCore release notes、AWS What's New RSS）。【A 内容 / 日期限述】

#### Microsoft Entra Agent ID
- 窗口内状态：**Entra 官方无窗内条目**（核验入口：1. learn.microsoft.com Entra what's new，最新月份为 2026-06（含 Conditional Access 针对 agent identities、Agent ID sponsor 生命周期 GA）；2. Foundry devblog RSS 窗内无身份条目）。
- **第三方本周集中适配 Entra**（侧面信号，均 A）：
  - Claude Code v2.1.312：Claude apps gateway 新增 `oidc.user_id_claim`，可用 `oid` 等非 `sub` 声明识别用户（官方举例 Entra ID 的 `oid`）。
  - MCP TS SDK 2.4.0：`scopeForRefresh` 解决 Entra AADSTS90009（client 与 resource 同一 app registration 时 refresh 需带 scope）。
  - mcp-gateway-registry 1.34.0：Entra 组恢复默认开（OBO 换 Graph token），未授权 Graph User.Read 返回 503。
  - Microsoft Agent Framework dotnet-1.26.0：保留 toolbox OAuth consent（#9565）。
- 影响：Entra 正在成为 Agent/MCP 生态里**事实上的企业 IdP 兼容目标**——本周至少 4 个独立项目为其 token 语义（oid、scope-on-refresh、组声明溢出）做专门处理。

#### Google Agent Identity / 语义治理
- 窗口内状态：**有动态**——10-26 semantic governance policies 用户意图匹配开关 `sgpUserIntentMatching`（默认开，关闭降低间接 prompt injection 防护；日志字段 `sgpUserIntentMatchingMode`）。【A】
- 来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes

#### Arcade Auth / Tool Permission
- 窗口内状态：**有动态（Preview）**——Arcade Auth 额外请求 OAuth `profile` scope；远程 MCP OAuth code 绑定构造 URL 的 client（修并发竞态）；dashboard 可清除远程 MCP server 已存 OAuth Client ID（连同 secret）；workload identity 访问云密钥库；工具响应脱敏本次调用凭证。【A】
- 来源：https://docs.arcade.dev/en/home/changelog

#### Composio Auth
- 窗口内状态：**有动态**——CLI `composio proxy` 强制 consumer 权限闸（#5093）；文档明确 Agent 落地处的凭证边界（#5114）；Custom MCP 认证/撤销说明更正（#5016）。session hooks 可在结果到达 Agent 前阻断（见 C-01）。【A】

#### Nango / Pipedream Auth
- Nango：有托管发布标签，内容未取得（3 入口，见 C-01）。
- Pipedream：本次未取得（2 入口，见 C-01）。

#### 其他权限层信号（窗内，A）
- **Databricks**（10 月档）：外部 AI Agent 默认 OAuth 应用 GA；用 OAuth 自定义身份声明按终端用户过滤数据。
- **Browserbase × 1Password**（10-22）：Agent 请求登录项、人批、扩展内填充，凭证不进入应用/模型/日志（厂商表述）。
- **OpenClaw**：10.10-beta.4 环境变量引用的 `hooks.token` 不进入 host-exec 与 CLI 子进程环境；自动化保留已认证 operator 权限但保留撤销边界；9.35/10.8 `mcp list/show` 与日志凭证脱敏。
- **Microsoft Agent Framework** python-1.23.0：AG-UI 端点注册须显式授权 scope 或单用户声明（BREAKING）。
- **Anthropic**：Claude Code `claude_code.safety_event` OTel 事件；TS SDK `managedSettings` 不再丢 `disableAllHooks`/`disableSkillShellExecution`；v2.1.310 Enterprise 自定义角色可控制 cloud sessions 与 Remote Control 权限。
- **OpenAI**：10-24 Enterprise Key Management（客户外部 KMS 管密钥）。
- **CrewAI** 1.15.29：修复无来源私有记忆泄漏到每次 recall。

#### 模块 5 结论（供母稿）
1. **"凭证不进模型"从口号变成多处具体机制**：1Password 人批填充、Arcade 响应脱敏、OpenClaw hooks.token 不下放、agent-browser 存储恢复 origin 绑定。
2. **企业 IdP 兼容集中在 Entra**（4 个独立项目本周适配），但 Entra 官方本周无 Agent ID 条目。
3. **权限显式化成为破坏性升级的主要来源**：MAF AG-UI scope、Composio proxy 权限闸与 `blocked` 结果类型、Dify sandbox 认证 token 必填。

### 模块洞察
Agent 身份层的实际进展不在"给 Agent 发身份"，而在**凭证使用路径的最小暴露**与**企业 IdP token 语义的兼容**。前者决定能否在真实 SaaS 上让 Agent 登录，后者决定能否在 Entra 租户里落地 MCP 网关——两者本周都有一手证据，但没有一家把它们做成统一的可采购产品。

## 6. Context / Memory / Knowledge 记忆知识层

### 本周模块结论

1. **记忆层主题从"召回效果"切到"删除、隐私与审计"**：Cognee v1.6.6rc1 history purge 不成功则操作失败、删 dataset 连带清检索/会话历史；OpenViking v0.5.2 上线 Session 隐私自动识别，v0.5.2.1（4 天后）因误判暂时关闭新值识别且不清理已产生记录；ADK 加 `delete_memory`；CrewAI 修私有记忆泄漏。
2. **默认少存**：OpenViking Working Memory 默认关；Zep HIPAA 账户 Graph Assistant 默认关。
3. **记忆 schema 类型化**：Zep 边类型层级（closed beta）。
4. Mem0、supermemory、Letta、Crawl4AI 本周静默；Firecrawl 有 10 个镜像标签但无说明。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态：v0.5.2（10-23）、sdk 0.1.17（10-26）、v0.5.2.1（10-27） | GitHub releases | 是 |
| Mem0 | 无动态（SDK v2.2.1=09-26；docs changelog 最新 08-24） | Atom；docs.mem0.ai | 否 |
| Cognee | 有动态：v1.6.6rc1（10-23） | GitHub releases | 是 |
| supermemory | 无动态（Local 0.0.9=10-13；changelog 最新 10-10） | Atom；supermemory.ai/changelog | 否 |
| Letta | 无动态（v0.16.8=05-15；docs changelog 无可读条目） | Atom；docs.letta.com | 否 |
| Zep / Graphiti | Zep 有动态（10-22/10-23）；Graphiti 无窗内版本（v0.31.2=10-21 01:25） | help.getzep.com；GitHub | 是 |
| Firecrawl | 有发布无说明（v2.11.607–616，10-25~10-28） | GitHub Atom；官方 changelog 检索 | 否 |
| Crawl4AI | 无动态（v0.9.5=10-14） | Atom；GitHub releases | 否 |

### 深度笔记

#### OpenViking（火山引擎）
- 窗口内状态：**有动态**——v0.5.2（10-23 20:43）、python-sdk 0.1.17（10-26 11:25）、v0.5.2.1 hotfix（10-27 21:47）。
- 事实要点：
  - v0.5.2 重点：**隐私与数据治理**——新增 Session 隐私自动提取与恢复、隐私树 MCP 工具、查看当前隐私配置树；Agent/Memory 稳定性（记忆读取与提取重试、Phase 2 解耦、轨迹去重、插件 pending 写入回放、跨分支捕获、recall 上下文归因）；Compile 工作流增量更新/调度/版本历史；服务端 durable content write task、pathlock 释放顺序、ordered delta replay 上限、OIDC issuer 兼容。【A】
  - v0.5.2 **破坏性**（5 项）：服务端不再提供 `openviking.integrations.langchain`，须改装 `langchain-openviking`；**Working Memory 默认关闭**（仍归档原始消息并提取长期记忆，但默认不生成 WM/checkpoint summary，需 `enable_working_memory=true`）；Watch API：`watch_interval > 0` 的重复导入不再更新/重新激活已有 Watch，改用 `PATCH /api/v1/watches/{task_id}`；Pi extension 0.4.0 改用服务端 MCP tools，工具名 `viking_*`→`openviking_*`，root API key 不能用于 `/mcp`；外部 peer 身份改无损 `ext-<base64>` ID，旧有损目录不自动读取。升级前停写、备份、在 stg 回归 CLI/data/console/ovtest。【A】
  - **v0.5.2.1 hotfix**：v0.5.2 的 Session 隐私自动识别**误判**，把普通内容替换为隐私占位符并产生无效隐私记录 → **暂时关闭新敏感值的自动识别与替换**（例：未登记的 `password=example-password` 保持原样）；已登记隐私值的匹配替换与历史占位符还原保留；**不清理此前产生的隐私记录**（#6680）。另修 MySQL 多服务任务隔离（#6676）。【A】
- 影响：OpenViking 延续上期"上下文数据库化"路线，本周把**隐私自动脱敏**推上线又在 4 天内因误判回滚为"仅登记值"。对采用者：v0.5.2→0.5.2.1 之间写入的会话可能留有误替换与无效隐私记录，需要自行排查；"自动 PII 识别直接改写记忆"的风险在生产中被证实。
- 证据级：A。
- 来源：https://github.com/volcengine/OpenViking/releases/tag/v0.5.2 ；…/v0.5.2.1

#### Mem0
- 窗口内状态：**无动态**（核验入口：1. `mem0ai/mem0` releases Atom，最新 Python SDK v2.2.1 为 09-26 01:35 +0800；2. docs.mem0.ai/changelog，最新条目 2026-08-24）。

#### Cognee
- 窗口内状态：**有动态**——v1.6.6rc1（自注 Release Date 2026-10-23，feed 10-23 09:52）。
- 事实要点：`forget(clean_history=True)` 仅清除检索历史；用户可经 API/服务端删除**自己的**检索历史（检索历史操作限定到调用用户，避免跨用户误删）；Obsidian/Asana/OneNote 连接器；Drive/Asana 同步更快且可续传；recall 命中返回 dataset 与原始 data id。**破坏性**：删除 dataset 会**连带清除关联的检索与会话历史**（依赖其做备份/审计须先导出）；`run_info` 不再内嵌 `data` 项（附迁移）；history purge 无法完成时删除/遗忘操作**直接失败**；预算耗尽统一抛 `LLMPaymentRequiredError`。【A；版本为 rc】
- 影响：Cognee 把"遗忘"做成**带失败语义的合规操作**（purge 不成功则整体失败），并让召回结果可回溯到源数据 id——记忆层的竞争转向**可删除性与可审计性**。
- 来源：https://github.com/topoteretes/cognee/releases/tag/v1.6.6rc1

#### supermemory
- 窗口内状态：**无动态**（核验入口：1. releases Atom 最新 Supermemory Local 0.0.9 为 10-13 02:59 +0800；2. supermemory.ai/changelog 最新条目 October 10, 2026）。

#### Letta
- 窗口内状态：**无动态/本次未取得条目**（核验入口：1. `letta-ai/letta` releases Atom 最新 v0.16.8 为 2026-05-15；2. docs.letta.com/changelog 返回客户端渲染外壳，未见条目）。

#### Zep / Graphiti
- Zep（托管）窗口内**有动态**（help.getzep.com/changelog）：10-23 **Edge type hierarchies（closed beta）**——`project.set_ontology`/`graph.set_ontology` 可选 `edge_type_hierarchy` 字段把自定义边类型分为类型与子类型，Zep 把每条抽取边归到最深适用子类型，按边类型过滤同时匹配其子类型；HIPAA 账户的 Graph Assistant 默认关闭须 owner/admin 显式开启；观察名为空时继续更新观察（此前会停止该图全部观察更新）。10-22 无 user ID 的用户节点用 UUID 作标识；BYOM 移除 GPT-5.4 Mini/Nano，改选 GPT-6 Luna 或 GPT-5.6 Luna；Batch API 用于测试数据与回填的指引。【A】
- Graphiti（开源）：**无窗内版本**（v0.31.2 为 10-21 01:25 +0800，窗外 1 天；内容为更新 certifi 以应对 eMudhra 事件）。核验入口 2：Zep changelog 未列 Graphiti 版本。
- 影响：Zep 在图谱记忆上加入**本体层级**（类型/子类型），把"记忆 schema"推向可继承的类型系统；HIPAA 默认关闭助手体现记忆产品的合规默认值。
- 来源：https://help.getzep.com/changelog（Oct 22/23, 2026）；https://github.com/getzep/graphiti/releases

#### Firecrawl
- 窗口内状态：**有发布、无可读说明**——GitHub 窗内至少 10 个 API 镜像标签 v2.11.607–v2.11.616（10-25 ~ 10-28），正文均为"Release API image vX"。Atom 仅返回最近 10 条，更早窗内标签可能未列出。
- 已试入口：1. releases Atom；2. 搜索官方 changelog（未定位窗内条目）。→ 变更内容**本次未取得**。

#### Crawl4AI
- 窗口内状态：**无动态**（核验入口：1. releases Atom 最新 v0.9.5 为 10-14；2. GitHub releases 页面同）。

#### 其他记忆相关（窗内，A）
- **Google ADK 2.13.0**：`MongoDbMemoryService`（关键字召回、无需向量索引，实验）；`BaseMemoryService.delete_memory`。
- **pydantic-ai v2.60.0**：可选 `MetadataMemoryStore` 记录谁写了记忆文件；v2.62.0 Harness Memory 快照每个变更 run 只记一次，保持请求 append-only。
- **CrewAI 1.15.29**：修复无来源私有记忆泄漏到所有 recall；LanceDB 过滤器转义 scope/id。
- **Dify 1.18.0**：Agent Knowledge Base beta（KnowledgeFS 空间，访问控制共享）。
- **AWS AgentCore Memory**：10 月档 TTL 与消费计费（上期已报，延续）。
- **腾讯 ADP**：9 月上线记忆库（按终端用户查看/编辑/删除/导入导出），窗外背景。

#### 模块 6 结论（供母稿）
1. **记忆层的主题从"召回效果"切到"删除、隐私与审计"**：Cognee purge 失败即失败、OpenViking 隐私自动脱敏上线即回滚、ADK 加 delete_memory、CrewAI 修私有记忆泄漏、pydantic-ai 记录写入者。
2. **记忆 schema 类型化**：Zep 边类型层级、OpenViking 身份 ID 无损化。
3. **默认值收缩**：OpenViking Working Memory 默认关、Zep HIPAA 助手默认关——默认少存、显式开启。

### 模块洞察
OpenViking 的"上线即回滚"是本周最有价值的反例：**自动识别并改写记忆内容**在生产中会污染数据且难以回收。记忆基础设施的成熟度标志正在变成"能否可靠地不存、少存、删干净、说清楚删了什么"。

## 7. Observability / Eval / Guardrails 可观测治理层

### 本周模块结论

1. **安全事件进入遥测**：Claude Code `claude_code.safety_event`；Databricks MCP 调用越狱筛查（Beta，10 月档）；pydantic-ai `InputGuardrail` 关闭 fail-open。
2. **OTel GenAI v2 从规范进入框架默认**：ADK 2.13.0 默认 `otel_semconv_1_44`、移除 `call_llm` span。
3. **观测平台向网关与技能注册扩张**：Langfuse v4.68–4.71 AI Gateway 与 Skills 追踪/版本管理；Phoenix 20.25 issue-to-PR factory。
4. **评测转向对已有 session 回放**：AgentCore SDK 1.25.0、Langfuse `runBatchEvaluation` MCP 工具。
5. **供应链**：Phoenix evals 3.9.3 排除被入侵的 litellm 1.107.0、要求 certifi 2026.10.18。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 本次未取得独立条目 | langsmith-sdk Atom；changelog.langchain.com | 否 |
| Arize Phoenix | 有动态：20.25.0/20.26.0/20.26.1；evals 3.9.3–3.9.5 | GitHub releases | 是 |
| Guardrails AI | 无动态（v0.11.0=08-14） | Atom；GitHub releases | 否 |
| Langfuse | 有动态：v4.68.0–v4.71.0 | GitHub releases | 是 |
| Braintrust | 有动态：JS SDK 3.39.0（10-22）、3.40.0（10-27） | GitHub releases | 是（简） |
| Helicone / AgentOps | 无动态 | Atom；GitHub releases | 否 |
| OTel GenAI semconv | 规范无新版（v1.44.0=08-05）；ADK 默认采用 | GitHub releases；ADK | 是（采用侧） |
| Coze Loop / NeMo Guardrails | 无动态 | GitHub releases；方舟公告 | 否 |

### 深度笔记

#### LangSmith
- 窗口内状态：**本次未取得独立条目**（已试入口：1. `langsmith-sdk` releases Atom，最新 v0.14.9 为 10-15；2. changelog.langchain.com 抓取 25 万字符页面，未定位到窗内可核条目）。
- 侧面：`langchain-anthropic 1.7.7` 追踪解析后的 reasoning effort（#41536）；`langchain 1.4.7` LangChainTracer 接受 address（#41006）。【A】

#### Arize Phoenix
- 窗口内状态：**有动态**。
- 事实要点：arize-phoenix **20.25.0**（自注 10-22）脚手架"managed agents issue-to-PR factory"（#17020）、沙箱在取消时保持 teardown（#17166）；**20.26.0**（10-23）factory 在分诊中提名候选并派发受信任者（#17170）、服务端 OTel resource 加 `service.version`（#17212）；20.26.1（10-25）新增 Microsoft Agent Framework 追踪集成页（#17209）。phoenix-evals **3.9.3**（10-22）**排除被入侵的 litellm 1.107.0**（#17087）、要求 certifi 2026.10.18 以撤信被入侵的 emSign 根（#17093）；3.9.4/3.9.5、TS evals 2.7.1 为修复。【A】
- 影响：可观测平台开始**自带"Agent 工厂"**（issue→PR），且在供应链事件（litellm 1.107.0、emSign）上做了显式依赖排除。
- 来源：https://github.com/Arize-ai/phoenix/releases

#### Guardrails AI
- 窗口内状态：**无动态**（核验入口：1. releases Atom 最新 v0.11.0 为 08-14；2. GitHub releases 页面同）。

#### Langfuse
- 窗口内状态：**有动态**（v4.68.0 10-22、v4.69.0 10-23、v4.70.0 10-24、v4.70.1 10-26、v4.71.0 10-27；v3.225.13–15 维护分支）。
- 事实要点：**AI Gateway** 成为主线——成员可自建 gateway API key、owner/admin 以 service account 签发、用户离开组织时撤销其 gateway key（#19101）、自托管全局开关与派生 JWT 公钥（#19159）、在 generation 上记录模型/key 所有者/字节数/上游错误（#19161）；**Skills 可观测**——Agent 从 Langfuse 加载托管 skills（#19148）、追踪显示请求的 skill 加载与文件路径（#19239）、按可用/已加载 skill 名过滤（#19279）、MCP 创建 skill 版本与管理标签（#19247）；评测：`runBatchEvaluation` MCP 工具（#19314）；安全：webhook/PostHog 目标变更时要求重新提供 secret（#19261）、blob storage 出站主机 allowlist（#18907）、遗留 webhook header 加密（#19207）；**自托管政府版 license `lf_gov_`**（#19316，标 `!` 破坏性）；新组织 legacy ingestion 仅限 scores（#19042）。【A】
- 影响：Langfuse 从 trace 存储走向**"网关 + 技能注册 + 评测"**的一体化控制面——与 AgentCore Gateway 的模型流量网关形成开源对照；Skills 被作为一等可观测对象。
- 来源：https://github.com/langfuse/langfuse/releases（v4.68.0–v4.71.0）

#### Helicone / Braintrust / AgentOps
- Helicone：**无动态**（入口：releases Atom 最新 deploy-20261010；GitHub releases 页面同）。
- Braintrust：**有动态**——JS SDK 3.39.0（10-22 00:03）应用日志与 console 捕获（#2639）、AI SDK 批量追踪与 code mode 追踪；3.40.0（10-27 04:49）**长生命周期 Node 进程中日志行批量、最多延迟 1 秒 flush**（`BRAINTRUST_FLUSH_DELAY_MS`，须在退出前调用 `flush()`；serverless 默认仍即时 flush）、Pi coding agent 避免 token 用量重复计数（#2672）。【A】
- AgentOps：**无动态**（入口：releases Atom 最新 0.4.21 为 2025-08-29；GitHub releases 页面同）。

#### OpenTelemetry GenAI 语义约定
- 窗口内状态：**规范无新版**（`open-telemetry/semantic-conventions` 最新 v1.44.0 为 08-05）。**采用侧有动态**：Google ADK 2.13.0 默认切到 `otel_semconv_1_44`（GenAI v2），移除 `call_llm` span（破坏性）；Claude Code 新增 `claude_code.safety_event`；Phoenix 加 `service.version`。【A】
- 影响：OTel GenAI v2 从"规范已发"进入**主流框架默认**阶段，看板迁移成本本周开始兑现。

#### Coze Loop / NeMo Guardrails
- Coze Loop：**无动态**（releases 最新 2026-03-26；方舟窗内公告无 Loop 条目）。
- NeMo Guardrails：**无动态**（releases 最新 v0.24.1 为 09-17；GitHub releases 页面同）。

#### 其他护栏/评测信号（窗内，A）
- **pydantic-ai v2.61.0**：`InputGuardrail` 可脱敏用户自身 prompt，并关闭护栏的 fail-open 路径（#10841）；v2.63.0 `DetectLoops` 打断重复动作循环、`Dataset.evaluate(task_timeout=...)`。
- **CrewAI 1.15.29/31**：离线 jev 路由与护栏评测 runner；畸形护栏结果也发 `LLMGuardrailCompletedEvent`；`crewAI eval` 可一条命令运行 crew 并出 verdict。
- **AWS AgentCore SDK 1.25.0**：评估已有 sessions + RecommendationClient；batch evaluation insight results。
- **Databricks**（10 月档）：Screen MCP tool calls and results for jailbreaks（Beta）。
- **Google ADK 2.13.0**：eval 把调用耗时拆为 model/tool/framework；`adk eval` 退出码反映通过/失败；surface Vertex rubric verdicts。
- **trueforge**：context compaction 起止事件含 usage/duration_ms。

#### 模块 7 结论（供母稿）
1. **安全事件进入遥测**：Claude Code safety_event、Databricks MCP 越狱筛查、pydantic-ai 护栏 fail-closed——"被拦截了什么"成为可观测数据。
2. **OTel GenAI v2 默认化**（ADK）带来看板迁移。
3. **观测平台扩张为网关与技能注册**（Langfuse AI Gateway + Skills），评测从"打分"走向"对已有 session 回放评估"（AgentCore SDK、Langfuse runBatchEvaluation）。
4. **供应链事件**：litellm 1.107.0 被排除（Phoenix）、eMudhra/emSign 根撤信（多处）。

### 模块洞察
可观测层正在把"被拦截了什么、为什么"与"花了多少、在哪花"放进同一条 trace。Langfuse 做网关、AWS 在网关里做评测与熔断，说明观测与控制正在合并；对企业来说，这意味着观测供应商的选择会反过来约束网关与策略引擎的选择。

## 8. Managed Agent Platform / Enterprise Control Plane 平台控制面

### 本周模块结论

1. **AWS 是本周唯一有窗内精确日期且改变控制面结构的云厂**：AgentCore Gateway InvokeModel + 模型 fallback（What's New 10-22 16:00 +0800）；同月档 CLI v1.0、Step Functions connector、Runtime FUSE。
2. **Google 的动作在策略层**（10-26 语义治理意图匹配开关）；Microsoft Foundry 本周静默；Databricks 月档补身份与 MCP 安全。
3. **国内**：方舟以协议兼容推进（10-22 更新 API 兼容性公告：apply_patch、namespace/defer_loading、Anthropic 错误格式）；百炼与 ADP 窗内无可核功能条目，主要动作在窗外（10-13 Agent Studio 手册、10-19 ADP 4.2.1、10-21 轨迹评测）。

### 固定平台状态表

| 平台 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 有动态（10-22 Gateway；10 月档 CLI v1.0 等；SDK 1.25.0/1.25.1） | What's New RSS；release notes；GitHub | 是 |
| Google Gemini Enterprise Agent Platform | 有动态（10-26 治理） | GEAP / Vertex release notes | 是 |
| Microsoft Foundry | 本周无重大公开动态 | devblog RSS；what's new 404 | 否 |
| 阿里云百炼 | 限述（窗外背景 + 10-26 周报摘要） | help.aliyun.com；bailian docs；开发者社区 | 否（背景） |
| 火山方舟 / Coze | 有动态（10-22 API 兼容公告；10-23/10-24 模型目录） | ark.volcengine.com | 是 |
| 腾讯云 ADP | 无窗内日期条目（窗外背景已读正文） | cloud.tencent.com；adp.tencent.com | 否（背景） |
| Databricks | 有动态（10 月档未标日） | Databricks release notes | 是（限述） |

### 深度笔记

#### AWS Bedrock AgentCore（平台侧）
- 窗口内状态：**有动态**。
- 事实要点：
  - **AgentCore Gateway 支持 Bedrock InvokeModel API 与模型 fallback**——AWS What's New 发布于 2026-10-22 08:00 GMT（=10-22 16:00 +0800，窗内）。【A】机制（release notes "October 2026" 原文）：
    - inference target 在聚合 `/inference` 端点上双向支持 `InvokeModel`/`InvokeModelWithResponseStream` 线格式；用 Bedrock SDK 的客户端可路由到任意 inference target（含非 Bedrock 提供方），用 OpenAI 或 Anthropic SDK 的客户端可路由到用 InvokeModel 提供模型的 Bedrock target；方言不同时网关翻译请求并**重新分帧流式响应**，客户端 SDK 不改；新 `bedrock-runtime` connector。【A】
    - 模型 fallback：gateway 规则用 `matchModels` 选请求，在 `routeToTarget` 上定义**有序 fallback 链**；主目标被限流、容量不足或不可达时自动尝试下一个；可配置触发 fallback 的失败类型与**每目标首字节超时**；服务托管的 circuit breaker 默认开启、跳过持续失败的目标。【A】
  - 同在 "October 2026" 档、**未逐条标日**（不计为确定窗内）：AWS Step Functions connector（把 Standard/Express 状态机暴露为 MCP 工具；Standard 每步写执行历史，task-token 支持人工回调）；**AgentCore CLI v1.0**（`@aws/agentcore` 1.0.0：`harness/runtime/memory/identity/gateway/payment` 直接资源命令；全命令 JSON 输出；薄 CDK app 基于 `@aws/agentcore-cdk`；部署默认开启 CloudWatch Transaction Search；`agentcore migrate` 只读迁移计划→确认→迁移，保留 v0 物理资源名、可恢复中断迁移）；Runtime 容器内 **FUSE 挂载文件系统**；AWS Agent Registry 扩展到 US East (Ohio)/Frankfurt/London/Canada (Central)。上期已报的 FailureAnalysis、Memory TTL、短期记忆消费计费、Gateway 私有 CA 同档。【A 内容；日期 D→限述为"10 月"】
  - SDK：`bedrock-agentcore` v1.25.0（10-24 04:19）——evaluation 暴露 batch evaluation insight results（#704）、**评估已有 session 并新增 RecommendationClient**（#708）、Payments 安全加固（#706）；v1.25.1（10-28 01:52）隔离自定义模拟模板渲染（#714）。Starter Toolkit 最新 v0.3.14（10-06，窗外）。【A】
  - What's New 其他窗内：10-23 Bedrock Web Search 支持域名过滤与用户位置控制；10-26 GPT-6.1 Terra 在 Bedrock GA。【A】
- 影响：AgentCore Gateway 从"工具网关"扩为**模型流量网关**（多方言翻译 + fallback + 熔断），与 Agent 的工具调用、身份、评测共用一个控制面。对平台工程：多模型容灾可从应用层下沉到网关规则；但跨方言重分帧意味着要回归流式解析与 usage 计量。
- 来源：https://aws.amazon.com/about-aws/whats-new/2026/10/agentcore-gateway-invokemodel-fallback/（RSS pubDate Thu, 22 Oct 2026 08:00 GMT）；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html（October 2026 全节）；https://github.com/aws/bedrock-agentcore-sdk-python/releases

#### Google Gemini Enterprise Agent Platform / Vertex AI
- 窗口内状态：**有动态（治理类 1 条）**。
- 事实要点：
  - 10-26：**语义治理策略（semantic governance policies）的用户意图匹配可开关**——在 authorization extension metadata 上设 `sgpUserIntentMatching`；默认开启；设为 `DISABLED` 关闭，官方注明"关闭会降低对间接 prompt injection 的防护"；策略评估日志在 `sgpUserIntentMatchingMode` 字段报告每次评估使用的模式。【A】
  - 10-26：Gemini 图像模型 Cloud Storage 直出 GA（模型层，非 Agent 基础设施）。【A】
  - 10-21 CodeMender v0.16.0（上期已报，窗外背景）。
  - Vertex AI release notes 窗内仅 Agent Platform Workbench v2 维护（10-25/10-26：依赖与证书更新；10-26 Workbench 实例自定义组织策略 GA）。Agent Engine / Managed Agents **无功能条目**。【A】
- 影响：Google 本周的 Agent 平台动作落在**策略层**——把"按用户意图判定工具调用是否越权"的检测做成可审计、可关闭的开关，并把关闭的安全代价写进文档。这是本周少数直接面向 prompt injection 的平台级治理变更。
- 来源：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes（October 26, 2026 节）；https://docs.cloud.google.com/vertex-ai/docs/release-notes（October 25/26）

#### Microsoft Foundry
- 窗口内状态：**本周无重大公开动态**（核验入口：1. Foundry devblog RSS——窗内仅 10-26 "Azure AI Speech LLM 09-2026" 语音条目；2. learn.microsoft.com Foundry what's new 页返回 404；3. Agent Framework 仓库 releases 有 dotnet-1.26.0，见模块 1）。
- 窗外背景：10-19 Browser automation tool GA（10-19 18:32 +0800，上期窗口末尾后的次周之前；本期窗外）；10-16 "What's new September 2026"（上期已报）。
- 来源：https://devblogs.microsoft.com/foundry/feed/（10-28 读取）

#### Databricks（平台侧）
- 见 A-01：October 2026 档内 MCP 调用越狱筛查（Beta）、外部 AI Agent 默认 OAuth 应用 GA、OAuth 自定义身份声明按终端用户过滤数据、`ai_enrich` 外部 MCP 搜索 grounding（Beta）。日期未逐条标注。【A 标题级】

#### 阿里云百炼 / Model Studio
- 窗口内状态：**限述**——无窗内日期的平台功能条目可核。
- 已试入口：1. 应用功能动态（help.aliyun.com，最新条目 2026-02-10）；2. Evolution 更新日志（docs.bailian.console.aliyun.com，最新 2026-10-21"轨迹评测上线"，窗外 1 天）；3. 开发者社区"【2026.10.19~10.23】百炼产品动态周报"（10-26 发布，仅读到摘要：本周上新 65 款应用与 11 款 MCP 服务、上线 DeepSeek-V4.1-Flash、推出 Token Plan 个人版）；4. "Agent Studio 产品手册"（10-13，窗外背景：Managed Agent、Sandbox、AutoModel、Memory、全链路 Trace、ADK Build 等）。
- 采用：10-21 轨迹评测与 10-13 Agent Studio 手册作**窗外背景**；10-26 周报仅作 B 级线索（数字为阿里云自述，正文未细读）。
- 来源：https://help.aliyun.com/zh/model-studio/application-release-notes ；http://docs.bailian.console.aliyun.com/zh/model-studio/agenteval-changelog ；https://developer.aliyun.com/article/1775073 ；https://startup.aliyun.com/info/1093766.html

#### 火山引擎方舟 / Coze
- 窗口内状态：**有动态（API 兼容层 + 模型目录）**。
- 事实要点：
  - "API 兼容性升级公告"页更新时间 2026-10-22，称自 2026-09-09 起陆续升级（单条未标日）：Responses API 支持 `apply_patch` 与 `custom tool`（Codex 客户端可执行 diff 工具调用）；兼容 `namespace`、`defer_loading` 等 Codex/MCP 工具分组与懒加载字段（不再 400）；Chat/Responses 顶层 `prompt_cache_key` 增强缓存亲和；Messages API SSE 增 `ping` 事件、错误格式对齐 Anthropic（顶层 `type="error"` 与 `request_id`）；Responses 默认返回 `reasoning.encrypted_content`；原生 `web_search` 工具调用；codex 场景支持 `phase=commentary/final_answer`。【A 内容；逐条日期未标】
  - Agent Plan 功能发布公告（更新 10-24）：10-23 新增 `doubao-seedream-5.0-flash`；10-24 新增 `kimi-k3.1-pro`（抵扣系数 5 折）。模型抵扣系数公告（更新 10-24）：取消输入分段系数，`kimi-k3.1-pro` 输入/输出抵扣系数 7。【A】
- 影响：方舟把**"兼容 Codex/Claude Code 等外部 Harness 的协议细节"**当作平台能力迭代（工具懒加载、apply_patch、Anthropic 错误格式），与上期"Agent Plan 接入 OpenClaw/Claude Code/Codex CLI"一致——国内云厂在 Harness 层的抓手是**协议兼容**而非自研 SDK。
- 来源：https://ark.volcengine.com/region:cn-beijing/docs/api-schema-upgrade-notice（更新 10-22）；https://ark.volcengine.com/region:cn-beijing/docs/agent-plan-personal-feature-release（更新 10-24）；https://ark.volcengine.com/region:cn-beijing/docs/agent-plan-personal-afp-credit-deduction

#### 腾讯云智能体开发平台 ADP
- 窗口内状态：**本周无窗内日期条目**（核验入口：1. 产品动态页，最近更新 2026-10-19，10 月两条"上下文管理（远程终端/Claw 渠道超时自动清空上下文，`/clear`）""企微群聊共享上下文"仅标月份；2. ADP 博客 4.1.5～4.2.1 更新（10-19）：AgentPortal、Claw 云盘、知识库企微文档源与时效性检索；3. 服务公告：新版订阅套餐 10-12 上线、TLS 1.2+ 10-15 20:00 起生效）。
- 采用：均为**窗外背景**；上期"仅摘要未读"的 10-18/19 博客本期已读正文，可补正上期限述：AgentPortal 按全体/部门/用户配置智能体使用范围、门户账号权限独立于开发平台成员名额；云盘挂载目录读写权限三种配置。【A，窗外】
- 来源：https://cloud.tencent.com/document/product/1759/104191 ；https://adp.tencent.com/zh/blog/tencent-cloud-adp-4-1-5-to-4-2-1-update ；https://cloud.tencent.com/announce/detail/2476 ；https://cloud.tencent.com/announce/detail/2461

#### 模块 8 结论（供母稿）
1. **AWS 是本周唯一有窗内精确日期、且改动控制面结构的云厂**：Gateway 同时承载工具（MCP）与模型流量（InvokeModel 方言翻译 + fallback + 熔断）。
2. **Google 的平台动作在策略层**（语义治理意图匹配开关），Microsoft Foundry 本周静默，Databricks 月档补身份与 MCP 安全。
3. **国内三家**：方舟以协议兼容推进（10-22 更新页）；百炼/ADP 窗内无可核功能条目，主要动作在窗外（10-13 Agent Studio 手册、10-19 ADP 4.2.1、10-21 轨迹评测）。

### 模块洞察
平台控制面本周呈现"一家动结构、多家动策略、国内动兼容"的格局。AWS 把模型流量纳入 Agent 网关后，**多模型容灾、成本路由与工具治理**第一次在同一产品中可配置；国内云厂继续以"兼容外部 Harness 协议细节"换取接入量，而非与 Harness 正面竞争。

## 云厂能力矩阵（2026-10-22 ~ 10-28）

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | Runtime FUSE 挂载（10 月档）；harness 交互 shell（9 月背景） | Memory TTL、短期记忆消费计费（10 月档，上期已报） | **Gateway InvokeModel 方言翻译 + 有序 fallback + 熔断（10-22）**；Step Functions→MCP（10 月档） | CLI v1.0 identity 命令（10 月档） | Web Search 域名过滤/用户位置（10-23） | SDK 1.25.0 评估已有 session + RecommendationClient（10-24） | Gateway 吞并模型流量 |
| Google | Agent Engine 无条目；ADK AgentEngineEnvironment | ADK MongoDbMemoryService（实验） | Agent Gateway 本次未取得 | **语义治理意图匹配开关（10-26）** | ADK OpenSandbox、Gemini 3.x computer use schema | ADK 默认 OTel GenAI v2（破坏性） | 策略层治理 |
| Microsoft | Foundry Hosted Agents 无条目 | 无条目 | MAF MCP 2.x 迁移、toolbox OAuth consent | Entra 官方无窗内条目 | Browser automation GA（10-19 窗外） | 无条目 | 本周静默（框架侧有破坏性升级） |
| 阿里云 | Managed Agent（10-13 手册，窗外） | Memory（手册背景） | 周报称上新 11 款 MCP 服务（10-26 摘要，B） | 本次未取得 | Sandbox（手册背景） | 轨迹评测（10-21，窗外） | 窗内无可核功能条目 |
| 火山/字节 | 无 runtime 条目 | OpenViking v0.5.2/0.5.2.1（开源） | **Responses API 兼容 apply_patch、namespace/defer_loading（页面 10-22 更新）** | 本次未取得 | 原生 web_search 工具（同公告） | Coze Loop 无条目 | 协议兼容外部 Harness |
| 腾讯云 | 上下文超时清空/群聊共享（10 月，未标日） | 记忆库（9 月背景） | MCP Apps 对话内交互（9 月背景） | AgentPortal 使用范围配置（10-19 博客，窗外） | Claw 云盘挂载（窗外） | 无条目 | 窗内无日期条目 |
| Databricks | 本次未取得 | 无条目 | `ai_enrich` 外部 MCP grounding（Beta，10 月档） | 外部 Agent 默认 OAuth 应用 GA；OAuth 自定义声明按用户过滤（10 月档） | 本次未取得 | MCP 调用越狱筛查（Beta，10 月档） | 数据平台补 Agent 安全 |

> "10 月档"指月级归档未逐条标日；"窗外/背景"仅用于列完整性，不作本周动态；"本次未取得"不代表无该能力。

## 模块 × 厂商状态热力矩阵（图表数据）

取值：2=窗内有可核动态（A）；1=月档未标日 / 窗外背景 / 限述；0=本周无动态；-1=本次未取得。

| 模块 | AWS | Google | Microsoft | Anthropic | OpenAI | 阿里云 | 火山 | 腾讯 | Databricks | OpenClaw |
|---|---|---|---|---|---|---|---|---|---|---|
| M1 Harness | 1 | 2 | 2 | 2 | 0 | 1 | 0 | 0 | 1 | 2 |
| M2 Runtime | 1 | 0 | 0 | 2 | 0 | 1 | 0 | 1 | -1 | 2 |
| M3 Sandbox/Browser | 2 | 2 | 1 | 2 | 1 | 1 | 0 | 1 | -1 | 2 |
| M4 Gateway/Protocol | 2 | -1 | 2 | 2 | 0 | 1 | 2 | 1 | 1 | 2 |
| M5 Identity | 1 | 2 | 0 | 2 | 0 | -1 | -1 | 1 | 1 | 2 |
| M6 Memory | 1 | 2 | 0 | 0 | 0 | 1 | 2 | 1 | 0 | 2 |
| M7 Observability | 2 | 2 | 0 | 2 | 0 | 1 | 0 | 0 | 1 | 0 |
| M8 Platform | 2 | 2 | 0 | 2 | 2 | 1 | 2 | 1 | 1 | 0 |

依据摘要：AWS M3=Web Search 10-23、M4/M8=Gateway 10-22、M7=SDK 1.25.0；Google M1/M6/M7/M3=ADK 2.13.0，M5/M8=10-26 治理；Microsoft M1/M4=MAF 1.23.0/1.26.0，M3=Browser automation 10-19 窗外；Anthropic M2=Claude Code self-hosted runner 与会话修复，M3=沙箱修复，M4=HTTP MCP 仅幂等重试，M5=`oidc.user_id_claim`，M7=`safety_event`，M8=Google Cloud 托管 10-22；OpenAI M3=gpt-6.1-terra computer use 描述（模型层），M8=EKM/UK 数据驻留 10-24；火山 M4/M8=API 兼容公告，M6=OpenViking；腾讯均为月份或窗外条目；Databricks 均为 10 月档；OpenClaw M1/M2=10.7/10.8 恢复，M3=沙箱子进程不能跑宿主 CLI（10.8），M4=mcp list/show 脱敏（9.35），M5=hooks.token 不下放（10.10-beta.4），M6=Memory Wiki 保留人写 Notes（9.34/10.7）。

## TOP 5 候选及依据

1. **OpenClaw 以 replay-safe 会话恢复为头条，并开 extended-stable（LTS 等价）双轨**（2026.10.7 10-25、2026.10.8 10-28；2026.9.34 10-24、9.35 10-27）。信号价值：恢复边界推进到"不重放已完成副作用、残留不阻塞新消息"，且以 LTS 轨降低自托管升级频率；必覆盖对象本期首次全部可用公开 release 计入窗口。证据：A。
2. **AWS AgentCore Gateway 把模型流量纳入 Agent 网关**（What's New 10-22 16:00 +0800）：InvokeModel 与 OpenAI/Anthropic 方言双向翻译、流式重分帧、`matchModels` + 有序 fallback 链、每目标首字节超时、默认熔断。信号价值：多模型容灾与成本路由从应用层下沉到控制面，工具与模型共用一个策略/审计点。证据：A。
3. **E2B 把重试与幂等写进 sandbox 协议**（2.60.0 10-26、2.61.0 10-27、2.59.0 10-23）：服务端 `Should-Retry` 决定重试、发送后网络错误不重试、`Idempotency-Key` 创建、`dnsServers` 闭合 DNS 出站。信号价值：重复创建/重复副作用从"应用层兜底"变成基础设施契约，与 TOP1 构成"恢复不重放"的两端。证据：A。
4. **Composio session hooks 让工具网关成为策略执行点**（core 0.27.0，10-22）：执行前与结果到达 Agent 前两处阻断，自然语言条件，`resultType: 'blocked'`（`proxyExecute` 行为变化）。信号价值：工具治理从"连接器权限"升级到"按调用内容裁决"，与 Arcade 1.12.0 凭证回显脱敏、Claude Code `safety_event` 共同构成本周"策略下沉"主线。证据：A。
5. **MCP TS SDK v2.4.0 实现 Skills over MCP（SEP-2640）**（10-24）：技能以 MCP 资源发布，客户端校验大小、摘要与 SKILL.md frontmatter，2026-07-28 修订下带 `ttlMs`/`cacheScope` 缓存字段；同版 `x-mcp-header` 数字参数按规范返回 -32020、Entra `scopeForRefresh`。信号价值：工具与技能的分发通道合流到 MCP，Agent 技能供应链第一次有协议级完整性校验。证据：A。

> 次强观察（未进 TOP5）：OpenViking v0.5.2 隐私自动识别上线 4 天即因误判关闭（记忆层反例，A）；Dify 1.18.0 run protocol v2 不向后兼容（A）；Google 语义治理意图匹配开关（A）；Browserbase × 1Password（A/B）；Entra 被 4 个项目同周适配（A，侧面）。

## OpenClaw 战略参照（6 条）

1. **把"恢复溯源 + 未完成工具结果"开放为可查询事件**。10.7 已在内部记录 recovery provenance；若以结构化事件导出（含工具调用 id 与完成状态），可与 E2B 幂等键、外部 API 幂等语义对接，形成端到端"只执行一次"证明。
2. **LTS 轨需要明确的支持期与回移策略**。9.34/9.35 说明了"9 月底代码线 + 关键修复"，但未见支持期限与哪些类别回移的公开规则；企业评估 LTS 时首先会问这两点。
3. **定时跟进的权限保留应可审计**。10.10-beta.4 让同会话显式定时跟进保留 operator 权限并保留撤销边界；建议每次 `next_check` 重新挂载写入审计记录，对齐 Google 意图匹配"日志报告所用模式"的做法。
4. **工具结果前置阻断点**。Composio 的"结果到达 Agent 前阻断"与 Arcade"响应内凭证脱敏"是 OpenClaw 现有 `before_tool_call` 的对称缺口；可评估 after-tool / before-model 钩子，统一承载脱敏与外发审查。
5. **Skills 分发校验**。MCP SEP-2640 对 SKILL.md frontmatter 与摘要做校验；OpenClaw 两层技能与 ClawHub 包工具（10-24 `release-publish` 提到"isolate trusted ClawHub pack tooling"）可考虑对齐摘要校验与缓存字段，便于跨 Harness 复用。
6. **证书与供应链事件的统一响应**。本周 eMudhra/emSign 根撤信被 OpenClaw（secret egress proxy）、mcp-gateway-registry、Phoenix、LangGraph 分别处理；OpenClaw 若在 release notes 中单列"供应链/证书响应"小节，可降低企业安全团队的核对成本。

## 价值链位置判断（R3）

| 对象 | 链条位置 | 本周价值/议价信号 |
|---|---|---|
| OpenClaw | 运行时/Harness（自托管） | LTS 轨 + replay-safe 恢复，把"可持有性"变成卖点 |
| AWS AgentCore | 平台与工具链 | 网关同时控制工具与模型流量，议价点从托管算力移到流量控制面 |
| E2B | 执行环境（中立 sandbox） | 用协议级幂等/重试与云厂 Runtime 区隔 |
| Composio / Arcade | 工具网关（中立） | 策略执行与凭证脱敏成为相对云厂网关的差异化 |
| MCP（SDK/Registry） | 协议与分发层 | Skills 纳入后，Registry 的分发地位上升 |
| Langfuse / Phoenix | 观测与评测 | 向网关、技能注册、Agent 工厂扩张，与平台控制面重叠 |
| 火山方舟 | 模型与平台（国内） | 以协议兼容承接外部 Harness 流量，不在 SDK 层竞争 |
| Dify / CrewAI | 应用编排平台 | 破坏性 runtime 协议升级提高自托管迁移成本 |

## 周环比（对比 2026-10-22 第 18 期）

- **延续**：OpenClaw（上期本机 2026.10.5 观测 → 本期公开 10.7/10.8 + LTS，恢复主题延续并深化）；AWS AgentCore（上期 FailureAnalysis/TTL/私有 CA → 本期 Gateway InvokeModel/fallback、CLI v1.0、SDK 1.25.x）；LangGraph（上期 resume 修复 → 本期快照频率默认值与线程优先级）；Microsoft Agent Framework（上期持久化兼容警告 → 本期 MCP 2.x 等三项 BREAKING）；OpenViking（v0.5.1 → v0.5.2/0.5.2.1）；vercel-labs/agent-browser（fail-closed 第二周，扩到配置信任边界）；E2B（生命周期/pauseMode → 重试与幂等）；Arcade（工具推荐 → 自托管安全基线）；trueforge、browser-use、mcp-gateway-registry、Cognee、Langfuse、Phoenix、Zep 持续有版本。
- **新出现**：Anthropic Agent SDK/Claude Code（上期未取得 → 本期一手 releases）；Composio session hooks；MCP Skills over MCP（SEP-2640）与 Registry 1.8.x；Dify 1.18.0；Google ADK 2.13.0（上期空窗）；Browserbase 1Password/Authenticated Fetch；Google 语义治理开关；方舟 API 兼容公告；pydantic-ai（首次纳入动态池）；OpenClaw LTS 轨。
- **消失 / 降温**：OpenAI Agents SDK（上期 v0.24.0 → 本期无版本）；Microsoft Foundry（上期 Routines/Tool Search/A2A GA → 本期无条目）；Daytona（上期 0.225.0 B200 → 本期无，GitHub 主仓已归档）；supermemory、Graphiti（上期有动态 → 本期窗内无版本）；LangSmith（本期未取得独立条目）。
- **上期限述的补正**：腾讯 ADP 10-18/19 博客上期仅摘要，本期已读正文（AgentPortal、Claw 云盘、知识库企微源与时效性检索），仍属窗外背景。

## 覆盖与缺口

### 实际覆盖计数
- **模块：8/8**，均有结论、固定对象状态表、深度笔记与模块洞察。
- **固定对象**：模块 1 共 8 行、模块 2 共 8 行、模块 3 共 9 行、模块 4 共 8 行、模块 5 共 7 行、模块 6 共 8 行、模块 7 共 8 行、模块 8 共 7 行，合计 63 行，每行均有终态（有动态 / 无动态+核验入口 / 未取得+已试入口）。
- **GitHub 一手扫描**：62 个仓库的 releases Atom，窗内条目 157 条（含 monorepo 子包标签）。
- **云厂/官方文档页**：AWS release notes + What's New RSS、GEAP/Vertex release notes、Foundry devblog RSS、Databricks release notes、Claude platform release notes、OpenAI changelog、Entra what's new、方舟 3 个公告页、百炼 3 个页面、腾讯 4 个页面、Browserbase/Arcade/Zep/Modal/Daytona/Mem0/supermemory/Letta changelog。

### 未能取得项与原因
1. **Nango**：两个托管版本标签无说明；changelog 重定向后 404（3 入口）。
2. **Pipedream Connect**：Atom 最新 2025-11、changelog 404（2 入口）。
3. **LangSmith**：SDK 窗内无版本、changelog 页面未定位到窗内条目（2 入口）。
4. **Firecrawl**：窗内 ≥10 个镜像标签无说明；Atom 只返回最近 10 条，更早窗内标签可能遗漏。
5. **日期精度**：AWS（除 Gateway 10-22 外）、Databricks、腾讯 ADP 10 月条目为月级归档，均不计为确定窗内事件。
6. **国内云厂**：百炼与 ADP 窗内无可核功能条目；阿里云 10-26 周报只读到摘要；Google Agent Gateway、AWS/阿里/火山 Identity 条目本次未取得。
7. **独立复核**：本周主张均为官方一手（单源原始事实），厂商性能数字（ADK"最高快 8 倍"、阿里云用户数）标 B 未复核。
