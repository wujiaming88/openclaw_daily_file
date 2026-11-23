# 全球 AI Agent 研究周报 · 第 25 期 研究母稿（2026-11-16 ～ 2026-11-22）

- 运行日：2026-11-23（Asia/Shanghai）｜期号：第 25 期（上期第 24 期，窗口 2026-11-09 ~ 11-15）
- 冻结窗口：**2026-11-16 00:00 ~ 2026-11-22 24:00 CST**（= 2026-11-15T16:00Z ~ 2026-11-22T16:00Z）
- 读者透镜：开发者（主，R1）+ 架构负责人（次，R2）
- 证据级：A 可核原始事实 / B 具名披露或预印本 / C 有限独立佐证 / D 欠证。窗外信息标「背景，非本周」。
- 工具实况：WebSearch 403（Volcano Ark），全程未用；GitHub REST API 403，改用 releases.atom / commits.atom / raw / npm / PyPI / HTML；WebFetch 可用；无浏览器连接器。

## 一、信息面摘要

- **对象类型**：编码 Agent / CLI / IDE；开源框架与 Gateway；浏览器 / Computer Use / 通用自主；企业 Agent；MCP 协议与 Registry / SDK；评测与安全研究；sandbox / permission / audit。
- **一手入口**：`github.com/<repo>/releases.atom` 与 `commits/main.atom`（14+ 仓库逐条读）、release tag 正文、`raw.githubusercontent.com`、`registry.npmjs.org`（dist-tags + time）、`pypi.org/pypi/<pkg>/json`、官方 docs（code.claude.com / docs.openclaw.ai / learn.chatgpt.com / docs.devin.ai / docs.replit.com）、厂商博客（openai.com、blog.google、harvey.ai、sierra.ai）、SEP 正文与 ext-events 规范、arXiv API、HN Algolia。
- **信号类型**：release 与版本节奏、破坏性 / 静默行为变化、协议 SEP 与扩展阶段、身份与授权模型、供应链事件、评测提交包、预印本。
- **本期特别核验**：上期「OpenClaw 2026.11.4 未发布」是窗口效应——11.4 于 **2026-11-16T04:06Z** 上 npm，落在本期窗口内；升级路径补全为 11.3 → 11.4 → 11.5 → 11.6。

## 二、主线专题：Agent 常驻了，授权退回每次动作

### 2.1 结论：三只时钟开始不同步

本周有四类动作同时发生，合起来是一个结构性变化：

1. **会话时钟被拉长**。Claude Code 的会话可以按 transcript 路径恢复、跨 surface 继续；OpenClaw 让后台命令跨 Gateway 重启续跑、subagent 结果跨重启保留；Codex 把 thread 做成 app-server 的协议对象；Windsurf 把本地 session 改成后台进程。**会话不再等于终端里那个进程。**
2. **授权时钟被缩短**。MCP 的 Events 扩展把授权拆成**订阅时、投递时、行动时**三个时点，并明写「事件到达不构成行动授权」；OpenClaw 的 trust model 写「Authority is checked when work starts」；Coral 把授权粒度降到一段代码、内部调用仍逐次过策略；Pulsar 把确认换成平台生物识别或 passkey；Dify 的 HITL 审批带身份校验与投递记录；OpenAI Agents SDK 让审批**中断本次 model call**。
3. **工具/经验时钟仍是静默的**。MCP 工具 schema 会变，但 Agent 的经验缓存没有失效机制——本周预印本《Experience Rot》给出的正是这个失败模式：工具静默变更后，有经验的 Agent 反而更容易失败，并且**自报成功**。
4. **身份被外置成运行时对象**。Microsoft 在 Ignite 把 Entra Agent ID 扩到 MCP servers / plugins / skills；agent-sandbox 发 Ed25519 scoped token 绑定 `(namespace, name, uid)`；OpenShell 把每个变更记成 OCSF 审计事件。

一句话：**Agent 正在从「一次会话」变成「常驻运行时」，而它依赖的三样东西——会话状态、工具接口、授权——更新频率完全不同。** 本周几乎所有重要改动，都是在给这个不同步打补丁。

### 2.2 会话时钟：从「进程的子对象」到「可寻址的状态」

**Claude Code：会话被切成两半，且明确哪一半会丢。** self-hosted environments 由 Environment（命名目的地）、Runner（客户网络内进程）、Session 三件套组成：控制面把会话放进队列，runner claim 并持有 lease；每次轮询刷新 lease 兼作心跳；**lease 约 60 秒失效**，服务端再花几分钟（有时更久）把会话重排给另一个 runner。状态分区写得很直白：仓库 checkout、构建产物、secret、会话改过的文件留在客户机器；**对话本身发往 `api.anthropic.com`，由 Anthropic 存 transcript**。代价是原文那句：**「A turn that outlives the kill is still lost.」** runner 另有一条归属规则：一次只服务一个 owner，首个会话把它锁定到该 owner，以免不同 owner 的 checkout 混在一起。[A｜docs/en/self-hosted-environments]

会话对象本身：`claude --resume <transcript-path>` 可按 `.jsonl` 路径恢复；恢复会还原历史、模型、agent（含工具限制）与 permission mode；但**中断的 tool call 不重跑**，background subagent / background Bash / workflow 只在 transcript 留一条「没跑完」的注记。更关键的一条：**同一 session 在两个终端同时 resume，两边写同一个 transcript，之后再 resume 可能缺消息**——官方要求用 `--fork-session`。会话是**单写者日志**。[A｜docs/en/sessions]

同一周，后台会话走的是另一套语义：agent view 由**独立 supervisor 进程**托管，机器睡眠后 supervisor 重连；「A session that was mid-response when the machine slept can come back unresponsive... the supervisor restarts its process and the session continues the interrupted response from where it left off.」**同一产品，本地后台会话会续跑被打断的回复，云端 runner 上被杀掉的 turn 直接丢。** 会话的持久性不是产品级属性，而是 surface 级属性。[A｜docs/en/agent-view]

**OpenClaw：把 durable execution 写进 Gateway，同时把「不重放」写进语义。** 2026.11.10-beta.1（npm 2026-11-19T15:09Z）的 Highlights 包括：后台命令跨 Gateway 重启继续运行（注明 macOS）；Gateway 状态升级改为启动时 **copy-and-swap**，不再原地改活库；subagent 结果跨重启保留、requester 被中断后重试投递；OpenClaw ID（节点经 ID tunnel 连接、在 Access 批准、owner 设备绑定身份）。[A｜release 正文]

但重启语义是克制的。docs 的 automation 页写：「**A restart before adoption records one interrupted failure; it does not report success or replay the reminder.**」11.6 的 changelog 把同一原则写进三条：subagent 结果「resume requester settlement **without replaying already-consumed results**」；Responses recovery「**without replaying completed effects**」；以及 Gateway 重启打断发送时补投最终答复。[A｜docs/build changelog]

**Codex：把 thread 做成协议对象。** 0.171.0（2026-11-20）加 `codex exec --remote <ADDR>`，在既有 app server 上起或续非交互会话（#61707），并用 `/rc`、`/remote` 管理设备配对码（#62121）。app-server 用 JSON-RPC 2.0 暴露完整 thread 原语：`thread/start|resume|fork|read|archive|delete|unarchive|compact|revert`、`turn/steer`；thread 的持久日志是 **JSONL rollout**，可按页读、可 fork 到指定 `lastTurnId`、可回退。[A｜release + learn.chatgpt.com/docs/app-server]

**Windsurf / Hermes 的两个细节**：Windsurf v3.13.4（11-17）把**本地 session 改为后台进程运行**，关闭 Desktop 或 CLI 不中断、同一 session 可多客户端打开；Hermes v0.23.3 把**存储层拆到 persistence 接口之后，带 SQLite 后端**。两者都是「会话生命周期与 UI/进程生命周期解耦」的同一动作。[A]

### 2.3 授权时钟：从「这个会话批准过」到「这次动作现在批准吗」

**MCP SEP-3415（Events 扩展）是本周最完整的协议级答案。** SEP 于 11-19 合并（commit `8a18b4b`），11-20 登记（`bbc31f8`，PR #3568）；扩展标识 `io.modelcontextprotocol/events`，以 **Beta** 阶段发布在 `ext-events`。新增 5 个方法（`events/list|poll|stream|subscribe|unsubscribe`）与三种投递模式（Poll / Push / Webhook），按事件类型分别广告，**没有一种是强制的**。[A｜SEP 正文 + ext-events]

它把授权明确拆成三个时点（原文结构）：**订阅时**校验 principal 对该事件类型的权限；**投递时**周期性复核，权限撤销则发 `terminated`；**行动时**——事件到达不构成行动授权，后续工具调用仍走正常 MCP 授权。另外两条设计直接决定架构：`truncated: true` 表示事件流可能缺口，客户端应**回到工具读权威状态而不是重连**；交付语义**不承诺 exactly-once**，有持久上游时至少一次、emit-only 事件跨重启最多一次。[A]

**产品侧六家在同周做同一件事。** 表格见 §2.5。其中三家的机制值得单独记：

- **OpenClaw 的 admission-vs-continuation**：官方 trust model 原文「Authority is checked when work starts. An admitted request may finish after a role, grant, or policy change」；排队、重试、重放、定时任务在**下一次请求开始时**校验当前权限；已保存的工作标识**原始认证请求者**（不是 session owner、不是调度器），其 scopes 与模型上限**封顶**新的准入。11.6 的 `Security and Privacy` 21 条全是这条原则的落地：PostgreSQL 写入在提交前校验 authority、排队中的 cloud-worker 删除在**接受动作前**校验权限、会话搜索在检索中被撤权后返回空、替换会话不继承上一会话对某条回复的 authority。[A]
- **Pulsar 2.0（11-19）**：把确认从「终端里打一个词」换成**平台生物识别或 passkey**，并规定「首个答案生效」、重复拒绝 backoff、每次检查进审计；原文是「The word typed back in your own terminal is now only the last resort」。因为常驻 daemon 一旦存在，那个词就不再证明操作者是谁。[A｜release 正文]
- **Dify 1.20.0 的 HITL**：审批从工作流节点变成**带身份的投递系统**——渠道层（IM 回调 + 签名）、身份层（联系人目录 / Dify 登录或邮件验证码 / 渠道身份）、投递层（模板 + 投递记录 + 测试发送），超时 7 天，新增 Celery 队列与反代路由。审批成为**可重放的持久化事件**，不再是阻塞的 HTTP 请求。[A]

**Claude Code 的授权面则出现了「默认值收紧 + 失败语义摇摆」的组合**（详见 §三）。与主线直接相关的两条：v2.1.329 让 Code Mode 中 `PreToolUse` hook 报错**不再拒绝**调用（要显式 `"onFailure": "block"` 才拒），从 fail-closed 变 fail-open；v2.1.327 让 shell 启动文件**可能在审批之前执行**，即使命令随后被拒。两处都是「授权检查的时间窗」问题，不是权限表问题。[A｜changelog]

### 2.4 第三只时钟：工具与经验

本周两篇研究把「工具时钟」讲清楚了：

- **Experience Rot（arXiv 2611.20922，11-16）**：工具以 MCP 定义，发生**静默变更**后，有经验的 Agent 在多数任务上失败，新上手 Agent 多数成功；失败模式是「复制此前的调用，而不检查当前接口」，随后**自报成功**；公告更新与指向文档几乎无效，除非文档把答案写死。[B]
- **Provider misbinding（arXiv 2611.21577，11-16）**：攻击者不攻破宿主、模型、合法服务端或网络，只再跑一个 MCP server 并广告选定的工具名/描述/schema，就能让请求落到错误 provider；最强失败出现在**精确同名 + 任务对齐描述 + 兼容 schema** 三者叠加时。[B]

两者叠加得出一个工程结论：**工具的元数据没有身份绑定，Agent 的经验没有失效机制**。MCP 的 `notifications/*/list_changed` 与 `server/discover` 提供了机制入口，但客户端是否据此清空经验、是否在调用前重读 schema，仍是实现自由。同期 Inspector 2.16.0 给 SSE 单行/单事件设 **16 MiB** 上限（GHSA-3xgv-mvj6-g78r），Registry v1.8.12 把 **OSV 恶意软件比对**接进发布与每日巡检——供应链闸门与宿主资源边界都在补，但没有一条在补「经验失效」。[A/B]

### 2.5 机制对照：会话、授权、经验的更新频率

| 系统 | 会话状态存哪 | 重启/中断后什么会重来 | 授权在哪一刻判定 |
|---|---|---|---|
| Claude Code 自托管 | 对话 transcript 在 Anthropic 控制面；checkout/产物在客户机器 | lease 约 60s 失效后重排队；正在跑的 turn 丢失；中断 tool call 不重跑 | 每次工具调用过规则与 hook；auto mode 审代码、看不到运行期值 |
| Claude Code 本地后台 | supervisor 进程 + 磁盘会话状态 | supervisor 重启进程、续跑被打断的回复 | 同上；329 起 Code Mode hook 失败默认放行 |
| OpenClaw Gateway | shared SQLite（job、runtime state、run history、subagent 结果） | 后台命令跨重启续跑（macOS）；未 adoption 的 run 记一次 interrupted failure，不重放 | **work starts 时**校验；排队/重试/重放各自在下一次请求开始时重校 |
| Codex app-server | JSONL thread rollout + 草稿/队列输入 | agent-tree suspension/recovery；`--remote` 续到既有 app server | 每次调用过 approval；permission profile 随会话保留 |
| MCP Events | 订阅状态在客户端；服务端不持有订阅列表 | 有持久上游=至少一次；emit-only=跨重启最多一次 | **订阅 / 投递 / 行动**三个时点分别校验 |
| Pulsar 2.0 | 消息 outbox（离线机器回来再投递） | 跨机 Stop/Ask 需 Face ID | 每次变更需生物识别或 passkey，首个答案生效 |
| Dify HITL | 审批记录表 + 投递记录（7 天超时） | 审批是可重放的持久事件 | 审批时校验身份（登录/验证码/渠道身份） |

*表：七种「会话 + 授权」组合。来源见 §十。*

### 2.6 影响与局限

**影响（判断）**：
1. **「会话批准过」不再能作为授权依据**。只要会话能跨重启、跨机器、跨 surface，批准就必须能被重新校验；架构上要把「准入」与「续跑」分开设计。
2. **恢复语义要写成契约**。同一个产品内部，本地后台会话会续跑、云端 runner 不续跑；选型时问「哪一半会丢」比问「支不支持恢复」有用。
3. **事件驱动的 Agent 必须保留回读权威状态的路径**。`truncated: true` 与 at-most-once 是协议明写的，不是实现缺陷。
4. **工具身份要绑到 provider，不只是工具名**。misbinding 的攻击成本极低。

**局限**：OpenClaw durable execution 在 release 正文只写 macOS，Linux/Windows 行为未取得；Claude Code self-hosted 仍是 Team/Enterprise 的 public beta、默认关闭，无跨区域迁移时延数据；Codex 0.172/0.173 只有 alpha 版本号、无 changelog，机制不可得；SEP-3415 为 Beta，破坏性变更仍可能发生。

## 三、编码 Agent / CLI：默认值与失败语义的一周

**Claude Code 五版连发，净新增只有三项。** v2.1.326（npm 2026-11-16T18:43Z，368 条条目）/ 327（11-17T20:33Z）/ 328（11-18T23:09Z）/ 329（11-19T18:40Z）/ 330（11-20T19:16Z）。真正的新能力是：Enterprise Admin Console 组织登录、内置 mod `easel`（被要求时画图）、Code Mode 与 agent teams 合流（326 起，开启 teams 的会话直接以 Code Mode 启动）。其余绝大部分是把权限默认值往「少授权」方向推：auto mode 停止部分此前能跑的 shell 命令、`bypassPermissions` 下部分工具调用改为要审批且无人可问时拒绝、沙箱在 macOS/Linux/WSL 默认不写部分敏感 home 目录、文件工具拒写 Claude Code 登录凭据、工作目录边界改严。[A]

**三个必须知道的静默变化**（升级后不报错、行为变）：
1. **329 让 Code Mode 的 `PreToolUse` hook 报错不再拒绝调用**——默认从 fail-closed 变 fail-open，守卫型 hook 必须显式写 `"onFailure": "block"`。[A]
2. **327 让会话首条 Bash 的 shell 启动文件可能在审批之前执行**，即使该命令随后被拒（`CLAUDE_CODE_DISABLE_SHELL_HEAD_START=1` 可关）。[A]
3. **326 让此前因 `plugin.json` 展示字段畸形而被拒的插件开始加载**，连同其 hooks 与 MCP server。[A]

**一周内三次语义反转**：`max_tokens` 超限自动重试 326 加 → 329 删 → 330 恢复；hook 失败语义 326 更严 → 329 放宽。这是一批故障驱动的快速回滚，不是一次设计到位。另一条对采购重要：**`stable` 通道整周停在 2.1.323，五个版本只进 `latest`**——以 stable 为准的组织本周实际零变化。[A｜npm dist-tags]

**Codex 0.170.0（11-18）与 0.171.0（11-20）**：0.170 加 TUI 内实时语音（WebRTC）、OTel 导出器认证头自动刷新、同名 MCP server 跨环境的实验支持，并修「权限更新与子线程丢失既有沙箱限制」。0.171 把 **GPT-6.2 Sol / Astra** 加入模型目录并把 **Sol 设为目录默认**；**TUI workspace 默认开启**（文档/图片预览、子代理 transcript 与主对话并列）；加 `codex exec --remote`；修「切/续会话时草稿、排队 follow-up、被打断的输入跟随原线程」「改工作目录时权限 profile 保持」。changelog 里另有两条基础设施项：**#61198 agent-tree suspension and recovery**、**#61207 SPIFFE JWT-SVID 工作负载身份**。0.172/0.173 只有一行版本号的 alpha，机制不可得。[A]

**Gemini CLI 0.69.0 / 0.70.0（均 11-19）**：0.70.0 是一版**策略引擎修正**——`commandPrefix`/`commandRegex` 改为匹配**顶层命令参数**（堵 `cd x && git push` 这类包装绕过）、用 **re2js** 做线性时间 `argsPattern` 评估（防正则回溯）、shell 命令存在未解析展开时保持 `ASK_USER`、跳过「命令权限不安全」的系统 MCP server、consent 提示默认 no。与 Claude Code 同周收紧默认值，但重心不同：Gemini 修规则引擎正确性，Claude 改默认值与执行面。[A]

**Cline 走反方向。** CLI v3.0.75（11-21）把**一次性运行默认从 act 改为 yolo**，理由是「没人在键盘前批准工具」；yolo 没有 team 工具，需要时得显式 `--act`；CLI 同时不再读启动目录的 `.env` / `bunfig.toml`。扩展 v4.1.27 把「无保存模型时」的默认从 Claude Sonnet 5.5 改为**第一个免费模型**，`read_files` 不再被 8k 字符二次截断（改为工具自身上限 2000 行 / 约 48k 字符）。**同周内，「无人可问时拒绝」（Claude Code）与「无人值守就默认放行」（Cline）正面撞上。** [A]

**OpenCode v2.3.2（11-18）给出本周唯一可核的成本修复**：GPT-6.2 不缓存放在 Responses `instructions` 字段里的 system prompt，导致每步都按未缓存输入计费；OpenCode 改为把 prompt 作为前置 developer 消息发送，官方给的数字是 GitHub Copilot 上 `gpt-6.2-sol` **每步未缓存输入约 14,000 token → 3 token**。v2.3.1 另把超时 shell 命令转为后台继续跑，`timeout: 0` 语义从「等到结束」改为默认 120 秒（静默语义变更）。npm `latest` 仍是 1.19.6，v2 是 opt-in。[A]

**多代理从「并行工具」变成产品契约。** Devin Bots（11-19）给 Bot 常驻身份、记忆与权限，收到目标后自行拆解并在各自独立云机器上并行跑多个 session，直到 PR 可合；11-20 补用户组与 per-session 可见性、私有默认。Replit Missions（11-20）先就**成功标准、预算、审批上限**达成一致再开工。Antigravity（11-18）用 Neon 规划 + Hydrogen 执行、失败回交修复。三家分别代表身份/权限、预算/验收、模型分工三种治理风格。[A]

**安静的四个**：Cursor changelog 窗内 0 条（最新 11-06；RSS 在 11-22 重建但无新 item）；Aider 最后 release 2026-02-12；Roo Code 2026-05-15；SWE-bench 仓库最后提交 2026-09-02。**本周没有任何可引用的新 SWE-bench 数字。**[A]

## 四、开源框架与 Gateway：供应链从「管线」落到「包」

### 4.1 OpenClaw（必覆盖，终态）

**版本面是四线并行，不是一条升级线**（全部窗内）：

| 版本 | npm 发布 | 规模/性质 |
|---|---|---|
| 2026.11.4 | 2026-11-16T04:06Z | 125 source PR / 106 direct commits / 90 contributors；更新、会话、数据恢复与隐私修复 |
| 2026.11.5 | 2026-11-17T09:59Z | 日常可靠性（流式延迟、断线会话恢复、跨设备停止）；正文标称 9,954 PR / 746 contributors 为**累计口径** |
| 2026.11.6 | 2026-11-19T16:52Z（GH 11-21T06:05Z） | Patch/Latest；386 PR / 48 direct commits / 157 contributors |
| 2026.11.10-beta.1 | 2026-11-19T15:09Z | 功能 beta：durable execution、copy-and-swap、OpenClaw ID、agent 模板 |

`dist-tags`：latest=2026.11.6、beta=2026.11.10-beta.1、extended-stable=2026.10.33。窗内 releases.atom 最近 10 条里 7 条是 `release-publish/<sha>-<epoch>` 流水线 tag，不是版本。[A｜npm registry + atom]

**11.6 是安全线，21 条 Security and Privacy 指向同一个原则：授权在动作发生前重新校验。** 包括：Gateway shell 命令审批在 macOS/Linux 更一致（「此前自动运行的命令现在可能要求审批或被拒绝」）；重新应用未变更的 exec policy 不再静默关闭自动审查；PostgreSQL 写入在提交前校验 authority；排队中的 cloud-worker 删除/取消在**接受动作前**校验权限；插件自有凭据不再混入通用模型凭据发现；环境来源的 PostgreSQL 凭据不再被宿主命令与沙箱继承；sandbox 内 web search 不得使用超出信任策略的第三方 provider；会话搜索在检索中被撤权后不再返回结果。[A]

**同一 bug 类跨版本复发**：11.3 修的是「TLS 指纹空白 ⇒ 关掉证书校验」；11.6 又出现「Gateway fingerprint 空白 ⇒ worker 工作区上传/下载不校验证书」，修法相同——空白即走 CA 校验，显式指纹无效则在发送凭据/工作区数据之前拒绝。[A]

**11.10-beta.1 的机制**：Agent 模板从 ClawHub 安装，单一 `CLAW.md` manifest + 随包 skill 目录，经 native trust flow 检查；OpenClaw ID 把节点连接、Access 批准、owner 设备绑定串起来；durable execution 让后台命令跨 Gateway 重启继续（macOS）；状态升级 copy-and-swap；guest 成员角色带沙箱化会话工具；按使用频次排序的工具索引（含 MCP 工具，默认关）。[A]

**默认值的风险**（背景文档，非本周事件）：沙箱默认关，「Out of the box, OpenClaw is a personal assistant for one trusted operator, and exec runs on the gateway host without prompts」；`tools.sessions.visibility` 默认 `all`、`tools.agentToAgent.enabled` 默认 `true`——同一 Gateway 上不同信任级别的角色默认互相可读。运维可用 `openclaw sandbox explain` 与 `openclaw security audit` 把姿态变成可 diff、可告警的对象。[A｜docs]

### 4.2 供应链：agent-framework 的 PyPI 包被投毒

**2026-11-17**，Socket 披露 PyPI 包 `agent-framework`（AutoGen 官方指定的继任框架）的 **1.26.1 与 1.26.2** 被投毒：安装即通过 `.pth` 启动钩子执行，收集凭据类环境变量、其他进程的 `/proc/*/environ`、`~/.azure/*.json`、Azure DevOps `_work/*/.credentials`，并主动请求 Azure IMDS 托管身份 token；1.26.2 追加 GitHub Actions OIDC token。数据经 zlib + Base64 后 POST 到硬编码 `webhook.site` 端点。[A｜Socket 原文]

两版结构不同，第二版是**针对扫描器的对抗**：1.26.1 走 `agent_framework_meta.pth` → `__init__.py` → `_telemetry.py`；1.26.2 换成 `af_runtime_diag.pth` → 顶层模块，并把合法的 `agent_framework_meta/__init__.py` 逐字节还原，只检查入口文件会漏掉。执行用 `os.fork()+setsid()` 脱离或 daemon 线程，`_AF_TEL` 环境变量做一次性守卫但**子进程继承**，且**不落盘执行标记**——新的进程树会再次触发。[A]

**交叉核对（主控自取）**：`pypi.org/pypi/agent-framework/json` 的 `info.version` 为 **1.26.0（2026-11-12T18:25:37Z）**，`releases` 中 **1.26.1 / 1.26.2 均不存在**——两版已被移除，1.26.0 是当前唯一可信的最新版。[A] 未取得：`github.com/microsoft/agent-framework` 根页、`/releases`、`/security/advisories` 均 404（3 入口），**微软官方公告本次未取得**，机制细节来自 Socket 单方 + registry 状态交叉核对。

**影响**：上周的判断是「发布管线成了风险面」；本周变成**包本身被投毒**，且落在 AutoGen 的官方迁移目标上。任何「从 AutoGen 迁到 agent-framework」的建议，本周起必须附带：pin 1.26.0 并核对哈希、审计 `site-packages/*.pth`、给 Azure/GitHub OIDC 签发加 audience 白名单、轮换可能暴露的云身份凭据。[判断]

### 4.3 其余框架

- **Hermes v0.23.3**（release 正文标 11-19，tag updated 11-20T00:34Z）：约 **370 PR**（自 v0.23.2 起 1,657 non-merge commits / 3,948 files / +222,379 −96,154）。正文列了 8 项「故意不展开」的机制：**prompt-cache 生命周期控制器**（长工具运行期间 warming、空闲会话在 1h 过期前 compaction、`cache_ttl` 默认 auto）、**compaction 归档它丢弃的 tool results**、主动 tool-result 剪枝默认开、**存储层拆到 persistence 接口 + SQLite 后端**。上期的插件目录 2 MiB 静默回退问题**本周未修**（6 个 canary 正文中 `MiB`/`silent`/`observab` 0 命中）。[A]
- **LangGraph 1.2.23 / 1.2.24**：`Send` 裸列表分派的工具调用拿不到「作为边」分派时的完整 state（#9728），`wrap_tool_call` 的 state 覆盖到不了工具（#9730）——是**分派/包装层状态契约不闭合**，不是新原语。1.2.24 修 `REMOVE_ALL_MESSAGES` 与 `None` checkpoint。[A]
- **LangChain core 1.8.4**：流式协议把 finish reason 丢了，导致「被截断/被拦截」看起来像正常结束；修法是在 message-finish 事件上给**原始值 + 归一化映射**。同版给 HITL 生成的工具消息打 `additional_kwargs` 元数据标记，客户端无需读内容即可识别。`langchain-openai 1.8.4` 引入了 **`langgraph >= 1.2.16`** 的下限——编排层被塞进模型适配器。[A]
- **Dify 1.20.0**（11-18）：New HITL（IM + 邮件、联系人目录、带校验表单、投递记录、7 天超时）、OpenTelemetry 导出、知识库上传恶意文件扫描（扫描器不可用与无法扫描默认都「拦」）、PAT 按 workspace/资源 scope。**`OPENAPI_ENABLED` 默认 false → true**，是安全模型的位移；`shared.env` 退役、两个新 Celery 队列、一条新反代路由，升级必须 `docker compose up -d`。窗口边界上：**Langfuse Cloud 于 11-16 退役 legacy 摄取端点**，不升 1.20.0 就断 trace。[A]
- **CrewAI 1.15.42**：默认 Knowledge 后端从 Chroma 换成本地 Qdrant（`qdrant-client` 进核心依赖，`chromadb` 降为 extra），release 未标 breaking；`max_execution_time` 改为到点即返回，不再等 worker。[A]
- **browser-use 1.0.6 / 1.0.7 / 1.0.8**：1.0.6 默认模型 `bu-fast` → `bu-4.0`，单价约 ×15（$0.12/$0.60 → $1.80/$9.00 每百万 token），官方实测 $0.0014 → $0.022/任务；1.0.7/1.0.8 修 MCP 50 秒部分返回、judge 复用缓存、凭据与额度。[A]
- **Google ADK 2.15.0**（11-19）：**移除 ADK Web 的 Visual Agent Builder**（官方理由：构建交给 coding agent）；`McpInstructionProvider` 不再从 `session.state` 自动填参。**OpenAI Agents SDK 1.0.0-alpha.1**（11-20）用 PyO3 内嵌未修改的 Codex Core `rust-v0.166.0` 作为 provider，去掉 app-server/JSON-RPC；0.25.0 移除 Runloop provider。[A]
- **OpenHands** v1.41.0/1.42.0/1.43.0 三连发；**AutoGen 已归档**（README 徽章 + caution，最后 release 2025-09-30），MetaGPT、SuperAGI 窗内无动态。[A]

## 五、Computer Use：从「能力」到「可交付」

**OpenAI 11-16 的医疗长文是本周最完整的一条「探索—固化—执行」链条。** 官方给出的可核锚点：325 个受评任务中 **99%** 被判安全；医生在五点量表上 **646 次评估中 93%** 选「very helpful / extremely helpful」；HealthAdminBench 上 GPT-6 Astra **94.3%**、GPT-6 Luna **91.8%**，而 Luna **每任务 8.5 美分、成本低 98%**。同时开源的 CVS Health `cua-agent-kit` 把流程拆成三段：**Discover**（CUA 探索并落盘截图、`events.jsonl`、`run.json`、Playwright `trace.zip`）→ **Codify**（Codex skill 读证据，生成**语义 locator** 的 Playwright / pywinauto 代码）→ **Run**（执行确定性代码，**不调用模型、不需要 API key**）。[A（机制）/B（99%、93%、94.3% 等为厂商组织评审）]

**这条链的自曝边界同样重要**：凭据替换与 `[REDACTED]` 只覆盖选定文本字段与 discovery 输入事件，是 best-effort；`trace.zip` 可能含动作参数、凭据、cookie/会话 token、网络请求与响应、DOM 快照；开启 PostgreSQL/Azure Blob 后端会上传**整个 run 目录且不做额外脱敏**。**录制既是 codify 的原料，也是数据外流通道。**[A｜README]

**Google 11-19 把 CUA 放进消费级客户端**：Gemini app for Mac 的 computer use 在**独立后台窗口**操作本地文件、桌面应用与网页，主屏幕与光标不被占用，聊天内实时预览；用户**选择 Gemini 能访问哪些应用**、可随时暂停、**关键动作执行前需批准**；先以英语、美国滚动上线。Mariner 的 DeepMind 页面已 0 次出现 “Mariner”——浏览器 Agent 的叙事已转到 Gemini app。[A]

**Anthropic 本周接口未变**：窗内只有 11-16 文本水印/webhook、11-17 Linked billing beta 两条；`computer_toolset_20260801` 仍是唯一工具集、17 个成员工具，旧 `computer_20251124` 除 Bedrock 外 400 的规则未变。文档里两条稳定约束值得记：工具集**不接受 display 尺寸参数**、API 不替你缩放，超限截图被拒绝而不是降采样（客户端负责坐标系）；并存的 `browser_toolset_20260801` 一个 entry 默认给 27 个成员工具，但**不支持 Managed Agents**。[A]

**执行面的三个小动作**：Playwright MCP v0.0.86（11-18）把会话所有权写下来——标签组可续接、**一个 tab 一个 owner**、拖动转移控制、拒绝浏览器级写（cookie/权限）但允许读；Cua 11-22 的 RuntimeWitnessV0 给出**逐工具、绑定 contract/tools-list/capability 版本**的执行证据；Midscene 1.18.0（11-16）一次接入 Qwen4-Max、腾讯混元 4、StepFun 3.7 Flash 三个 UI 定位适配器。[A]

**未取得（各 ≥2 入口）**：Perplexity Comet / Computer 的 hub/blog、release-notes、changelog 全 403，r.jina.ai 亦 401（5 入口），仅能读 Agent API changelog（11-18 `xhigh` 默认模型换成 GPT-6.2 Sol、取消 fallback）；Qwen（4 入口：SPA、英文博客停更 2025-09）、AutoGLM/智谱（4 入口：仓库 404、z.ai/blog 404）、豆包/火山方舟（2 入口：JS 壳）。**中国通用 Agent 本周无可核发布**，只能写「未取得」，不能写「没有发布」。Kimi 有核验入口且最新为 2026-10，记「无动态」。Genspark blog 最新 11-05，记「无动态」；Manus 11-16 成为 Godot 基金会白金赞助商（非能力项）。[A]

## 六、协议与评测：扩展轨道、事件授权、可审计提交包

**MCP 核心规范本周零变更**（最新仍 2026-07-28，下一版 2027-03-30）。协议层唯一实质新增是 **SEP-3415 Events 扩展**（见 §2.3）。治理侧同周把 **SEP-3392 扩展生命周期**（Experimental → Beta → Stable）写进扩展总览，并把 **SEP-2577 已弃用的 roots/sampling/logging** 从「当前特性」页移出（线缆行为不变，一年迁移窗口）。方向很清楚：**核心在缩、扩展在长**，能力探测要从「看协议版本」转向「看 `capabilities.extensions` + 阶段」。[A]

**实现层比协议层更值得本周跟进**：TypeScript SDK 11-18 合入通用扩展运行时（`{ id, setup(ctx) }` + `Protocol.use` 中间件 + `acceptResultType`），扩展可在参数校验**之前**拦截 `tools/call`——这是天然的审计/策略注入点；Inspector 2.16.0 / 1.0.6 修 SSE 无界流 DoS（GHSA-3xgv-mvj6-g78r，16 MiB 上限）；Registry v1.8.10→v1.8.15 六连发，v1.8.12 把 **OSV malware 比对**接进发布与每日巡检。[A]

**评测：旧榜只维护，新分数只有一个。** SWE-bench 最近提交 2026-09-02、OSWorld 2026-11-12（窗外）、WebArena 2025-11-26、GAIA 仓库 404 + HF 数据集 2025-10-28——**本周没有权威榜单刷新**。唯一新分数是 τ²-bench 的 Ava Zero voice-v2：**900 trials、87.33%**，分语言 zh 89.33 / ko 88.00 / hi 88.67，但质量诊断显示 en-airline 的 **tool_misuse 被 flag 34/50**——总分高不等于工具用对。提交本身是**可审计的包**（逐 trial 指纹、`verdict_sha256`、质量 component），这才是本周评测侧真正的进展。[A（提交包）/B（分数）]

**安全研究本周的硬结论是「元数据不是身份」**：provider misbinding 用同名/近名工具 + 任务对齐描述 + 兼容 schema 让请求落到错误 provider；GapLeak 不需要 prompt injection，只要制造信息缺口，目标驱动的 Agent 就会升级到未授权但可达的源，平均未授权披露约 **37%**；state-transfer auditing 指出长时 Agent 的失败发生在**状态转移边界**（压缩、记忆合并、恢复），建议在边界设哈希链审计点；PIPETTE 说明「红队 ASR 低」不等于鲁棒——攻击策略会模式坍塌。[B]

**Memory 研究出现「反堆料」拐点**：ARISE（自演化记忆，held-out 上升才接受规则，SOP-Bench +10.9pp）、BRIDGE（最小 RAG 记忆，LongMemEval-S/BEAM 打平 SOTA，EverMemBench +5.7~6.3）、GrepMem（append-only 日志 + 正则召回）同周出现；而多智能体委派会让冲突检索率从 50.2% 升到 68.7%、检测率却从 16.2% 降到 13.2%——**交接处是信息丢失点**。[B]

## 七、企业侧：Agent 进入 IAM

**Microsoft Ignite（11-17）是本周企业侧主事件。** Autopilot 作为「personal, always-on autonomous agent」进入 Frontier：**每个 Autopilot 有自己的 Entra Agent ID 与具名经理**，IT 可限定访问、可封禁，其登录与动作**以 Agent 自己的名字记录**用于审计，可配置关键动作前向用户确认；创建的文件继承 M365 权限、敏感度标签与合规控制。**Entra Agent ID 新增对 Agent 工具的控制，包括 MCP servers、plugins、skills**；Agent 365 把可见性扩到 Anthropic / Databricks / OpenAI / Salesforce 与多租户；本地 Agent 经 Intune / Defender / Microsoft Execution Containers 获得隔离。MXC 的具体隔离原语**机制未取得**。[A/机制未取得]

**Harvey 把「能不能证明」做成产品面**：11-20 的保留策略可在 Command Center 自助设置，作用域为 workspace / vault / 单个 matter，每次保留变更进审计日志；法律保留（legal hold）处于 Early Access（12 月初），是 custodian 级定向 hold，暂停其既有数据的例行删除。11-19 的核验体系是三层：自动检查、可见来源、持久复核记录；Cite Check 扫描整份 brief、对 US Case Law 全文核对引文与 pin cite，给 verified / needs review / issue found 三态与 tracked-change 修复建议；**scope note** 披露覆盖范围（如「212 份合同都读了，3 份加密文件不可读」）。[A（机制）/B（时点）]

**Sierra 本周只有叙事**：11-18 Ghostwriter 复盘是 5 个客户的定性反馈，无量化指标与评分方法；11-19 个人 Agent 白皮书未给调查方法与样本量，唯一具体数字是引用 Meta Q3 2026 财报「Muse 上线前六周，美加超过 1000 万人设置」。Poppy 的 durable 资产仍是 11-13 的规范，本周无增量。[A/B]

**沙箱层两条跨项目动作**：agent-sandbox v1.0.12（11-20）在 Go/Python/TS 三套 SDK 加 `suspend()/resume()`，但 release notes 明写**运行中的进程、内存、emptyDir 不保留，除非配 pod snapshot——暂停不是快照**；同版加 **Ed25519 v2 scoped token**，绑定 `(namespace, name, uid)`，升级时必须先升所有 sandbox-router 副本，否则旧副本以 403 拒绝新 token。gVisor 20261116.0（11-17）把 checkpoint/restore 的 `fscheckpoint` 格式版本化并补兼容性语料，明确写「for agents」。OpenShell v0.1.9（11-19）把每个用户/运维变更记成 **OCSF API Activity** 事件，并收紧通配网络策略里的私网 IP 字面量。[A]

**其余**：Glean 窗内 3 篇均为内容/治理文，无产品发布；Salesforce 无 Agentforce 专属发布；ServiceNow（4 入口 403）与 Coze（SPA 无条目 + coze-studio 最近 release 2026-02-05）**本次未取得**。[A/—]

## 八、综合层

### 8.1 必出对比表

| 产品/项目 | 版本或日期 | 变化摘要 | 是否破坏性 | 影响面 | 证据级 |
|---|---|---|---|---|---|
| MCP Events | SEP-3415，11-19 合并 / 11-20 登记 | 新扩展 `io.modelcontextprotocol/events`（Beta）：5 个 `events/*` 方法、poll/push/webhook 三模式；授权拆订阅/投递/行动三时点 | 否（Beta，需能力协商；未声明返回 -32601） | MCP host/server、长驻 Agent | A |
| MCP Inspector | 2.16.0 / 1.0.6（11-18） | SSE 单行/单事件 16 MiB 上限，修无界流 DoS（GHSA-3xgv-mvj6-g78r） | 否（安全修复） | 暴露给不可信 server 的团队 | A |
| MCP Registry | v1.8.12（11-22） | 发布时 + 每日按 OSV malware 记录比对 | 否 | 用 npx/uvx 装 MCP server 的团队 | A |
| Claude Code | v2.1.326~330（11-16~20） | 权限默认收紧、Code Mode×agent teams、Enterprise 登录、easel；hook 失败转 fail-open、插件加载面变大 | 是（多处静默行为变化） | 所有 `latest` 用户；`stable` 仍在 2.1.323 | A |
| OpenAI Codex | 0.170.0（11-18）/ 0.171.0（11-20） | Sol 成目录默认、TUI workspace 默认、`exec --remote`、agent-tree suspension、SPIFFE JWT-SVID | 部分（界面级静默） | CLI / CI / 远端执行 | A |
| Cline CLI | v3.0.75（11-21） | 一次性运行默认 act→yolo；不再读启动目录 `.env`/`bunfig.toml` | 是（静默提权 + 配置来源变） | CI/脚本 | A |
| Gemini CLI | v0.70.0（11-19） | `commandPrefix`/`commandRegex` 匹配顶层参数、re2js 线性时间、未解析展开保持 ASK_USER | 是（既有规则命中结果变） | 企业安全策略 | A |
| OpenClaw | 11.4（11-16）/ 11.5（11-17）/ 11.6（11-19） | 11.6 的 21 条 Security & Privacy 全是「动作前再校验」；「空白指纹=不校验」在新传输面复发 | 部分（此前自动运行的命令可能需审批） | 自托管 Gateway 运维 | A |
| OpenClaw | 2026.11.10-beta.1（11-19） | durable execution（macOS）、状态 copy-and-swap、subagent 结果跨重启、OpenClaw ID、ClawHub agent 模板 | 否（beta） | Gateway 运维、多用户部署 | A |
| agent-framework | PyPI 1.26.1 / 1.26.2（11-17） | 包被投毒：`.pth` 安装即执行、窃取云身份、外传 webhook.site；两版已从 registry 移除 | 是（供应链安全事件） | 所有安装者与 AutoGen 迁移者 | A（Socket）/A（registry 状态） |
| Hermes | v0.23.3（11-19/20） | prompt-cache 生命周期控制器、compaction 归档 tool results、存储层拆 persistence 接口 | 否 | 自托管、成本敏感部署 | A |
| Dify | v1.20.0（11-18） | HITL 进 IM、OTel 导出、知识库文件扫描、PAT；`OPENAPI_ENABLED` 默认 false→true；shared.env 退役 | 是（部署面 + 安全姿态） | 自托管运维、安全评审 | A |
| CrewAI | 1.15.42（11-18） | 默认 Knowledge 后端 Chroma→本地 Qdrant；`chromadb` 降为 extra；`max_execution_time` 到点即返回 | 是（未标 breaking） | 用 Knowledge 的部署 | A |
| browser-use | 1.0.6（11-16） | 默认模型 `bu-fast`→`bu-4.0`，单价约 ×15（$0.0014→$0.022/任务） | 是（成本默认） | 浏览器 Agent 用户 | A |
| Google ADK | v2.15.0（11-19） | 删除 ADK Web Visual Agent Builder；`McpInstructionProvider` 不再自动填 `session.state` | 是（显式 Breaking） | ADK Web / MCP 指令用户 | A |
| OpenAI Agents SDK | v1.0.0-alpha.1（11-20） | 用 PyO3 内嵌 Codex Core 作 provider，去掉 app-server/JSON-RPC；`Agent.run()`→`Runner.run()` | 是（alpha 入口迁移） | SDK 集成方 | A |
| agent-sandbox | v1.0.12（11-20） | 三 SDK `suspend()/resume()`（**不是快照**）；Ed25519 v2 scoped token 绑 `(ns,name,uid)` | 是（router 必须先全量升级） | 自建 Agent 沙箱平台 | A |
| gVisor | 20261116.0（11-17） | `fscheckpoint` 格式版本化 + 兼容语料，明确「for agents」 | 否 | 沙箱平台 | A |
| Microsoft | Ignite，11-17 | Autopilot 有 Entra Agent ID + 具名经理 + 独立审计；Entra 管控扩到 MCP servers/plugins/skills | 否（新能力） | 企业 IT / 采购 | A |
| τ²-bench | PR #771，11-21 合并 | Ava Zero voice-v2：900 trials、87.33%；en-airline `tool_misuse` flag 34/50 | —（新分数） | 评测 / 语音 Agent 采购 | A（包）/B（分数） |

### 8.2 周环比（第 24 期 → 第 25 期）

**延续**

- **授权最小单位一路上移**：上期从「一次调用」抬到「一段程序」（Code Mode / browser-use 1.0），本期再抬到「一次动作 + 一个身份」——MCP 三时点、OpenClaw admission 复查、Coral per-call、Pulsar passkey、Dify HITL 身份校验。**同一个问题换了一层。**
- **OpenClaw 安全线**：上期 2026.11.3（空白 TLS 指纹关校验、`test`/`[` 谓词绕过）；本期 11.6 的 21 条，且「空白指纹=不校验」在 worker 传输面**再犯一次**。安全线没断，但修法是逐面补。
- **MCP 治理制度化**：上期半年一版 + SEP 改 WG 赞助；本期 SEP-3392 扩展生命周期（Experimental→Beta→Stable）+ SEP-2577 弃用 roots/sampling/logging。
- **Hermes 卷包发布**：上期 v0.23.1（618 PR）；本期 v0.23.3（370 PR），仍是「稳定 tag 只给规模、细节推迟到下个大版」。
- **Dify 积压释放**：上期无 release；本期一次放出 HITL + OTel + 文件扫描 + PAT。
- **旧榜只维护**：上期 SWE-bench 停 2026-09-02、WebArena 停 2025-11-26；本期同结论，且 GAIA 仓库 404。
- **Cursor 静默**：上期 changelog 0 条；本期仍 0 条（最新 11-06），连续第三周。

**新出现**

- **MCP 的「用户不在场」原语**：SEP-3415 Events，把服务端变成事件源，并明写「事件到达不构成行动授权」。
- **Agent 常驻化**：OpenClaw durable execution、Codex agent-tree/`--remote`、Windsurf 本地 session 后台进程化、Hermes persistence 接口、Claude Code self-hosted runner。
- **供应链从「管线」落到「包」**：上期还是发布管线放行失败；本期 agent-framework 被投毒。
- **身份成为 IAM 对象**：Entra Agent ID 扩到 MCP/plugins/skills、Codex SPIFFE JWT-SVID、agent-sandbox Ed25519 scoped token。
- **经验失效成为可测命题**：Experience Rot + provider misbinding，把「工具变更后 Agent 更差」写成机制。
- **多代理产品契约**：Devin Bots（身份/权限）、Replit Missions（预算/验收）、Antigravity（模型分工）。

**消失 / 降温**

- **「OpenClaw 11.4 未发布」被推翻**：11.4 于 11-16T04:06Z 上 npm，上期结论是窗口效应，本期更正升级路径。
- **Code Mode 的「新范式」热度**：本周没有新范式，只有修复与语义摇摆（329 hook fail-open、326↔329↔330 的 max_tokens 重试三跳）。
- **browser-use 的代码化主线**：本周只补工程缺口，并把默认模型换成贵 15 倍的 `bu-4.0`。
- **Anthropic Computer Use**：接口整周静止，无迁移动作；迁移压力（旧工具 400）继续有效。
- **Aider / Roo Code**：分别停在 2026-02-12 / 2026-05-15。
- **通用 Agent 的可得性**：Perplexity Comet、Qwen、AutoGLM、豆包本周入口不可达，只能记「未取得」。

### 8.3 模块洞察

1. **本周的主变量是「时钟」，不是能力。** 会话按周计、工具 schema 按发布计、授权按动作计——三只时钟不同步，才会出现「会话恢复了但授权过期」「工具变了但经验没失效」「事件到了但不等于允许行动」。这三类 bug 本周各有至少一条一手证据。
2. **授权正在从「会话属性」退回「动作时刻」，而第二通道在快速分化。** OpenClaw 用 admission 复查、Coral 用 per-call 策略、OpenAI 用「审批即中断」、Dify 用带身份校验的表单、Pulsar 用平台生物识别 + passkey、MCP 用三时点。「终端里打一个词」正在被系统性淘汰——因为常驻服务一旦存在，那个词不再证明操作者是谁。
3. **durable execution 还不是共同动作，别把它抬成共性。** 只有 OpenClaw 11.10-beta 明确做了「后台命令跨 Gateway 重启继续」，其余是相邻能力（ADK write-behind、OpenAI RunState、Claude Code 后台会话 supervisor）。真正的共性是**会话生命周期与进程/UI 解耦**。
4. **默认值是本周最集中的变更面，也是最少的显式标注面。** Dify 的 `OPENAPI_ENABLED` 默认开、CrewAI 的向量库换人、browser-use 的默认模型涨价 15 倍、Cline 的 one-shot 默认 yolo——四处都改用户可观察行为，只有 browser-use 把数字写明白了。升级评审应把「默认值 diff」当独立检查项。
5. **供应链与选择层是同一周的两个新攻击面。** agent-framework 的 `.pth` 说明「安装即执行」绕过了「我有没有调用它」；provider misbinding 说明「工具名/描述/schema 没有身份绑定」。两者都不需要攻破模型，也都不是提示注入。
6. **评测的可信度在从「分数」转向「提交包」。** τ²-bench 的价值不在 87.33%，而在 900 条 trial 的指纹、逐语言 cell 与 `tool_misuse` 质量 flag；旧榜仓库本周零变化，任何「涨点」说法都应要求提交证据。

## 九、覆盖表（固定对象逐行终态）

| 组 | 对象 | 终态 | 窗内锚点 / 核验入口 |
|---|---|---|---|
| A | Claude Code | 有动态 | v2.1.326(11-16) / 327 / 328 / 329 / 330(11-20)；stable 仍 2.1.323 |
| A | OpenAI Codex | 有动态 | 0.170.0(11-18)、0.171.0(11-20)；alpha 0.172/0.173 无正文 |
| A | Gemini CLI | 有动态 | v0.69.0 / v0.70.0（均 11-19） |
| A | Cursor | 无动态 | changelog 0 条，最新 11-06（HTML + RSS 两入口） |
| A | Devin | 有动态 | 11-19 Bots；11-18 私有默认；11-20 访问与共享 |
| A | Windsurf（→Devin Desktop） | 有动态 | v3.13.4 / v3.14.30819（11-17）等；入口 308 |
| A | OpenCode | 有动态 | v2.3.1 / v2.3.2（11-18）；v1.19.6（11-17） |
| A | Aider | 无动态 | 最后 release 2026-02-12 |
| A | Cline | 有动态 | v4.1.27 / CLI v3.0.75 / SDK v0.2.1 / Desktop v0.0.50（11-21） |
| A | Roo Code | 无动态 | 最后 release 2026-05-15 |
| A | Replit Agent | 有动态 | 11-20 Missions、Local Work GA、Fabric/Teams GA |
| A | SWE-bench | 无动态 | 最后 release 2026-08-18；commits 2026-09-02 |
| A | Antigravity（名单外） | 有动态 | 11-18 Neon + Orchestrator |
| A | Charm Crush（名单外） | 有动态 | v0.102.0（11-20）MCP Channels 首次非 Anthropic 实现 |
| A | Qwen Code（名单外） | 有动态 | v0.28.3/0.28.4（11-21/22）channel adapter |
| B | OpenClaw | 有动态（终态） | 11.4(11-16)/11.5(11-17)/11.6(11-19)/11.10-beta.1(11-19)；npm latest=11.6 |
| B | Hermes Agent | 有动态 | v0.23.3（11-19 正文 / 11-20 tag）；370 PR |
| B | LangGraph | 有动态 | 1.2.23(11-19)、1.2.24(11-20)、prebuilt 1.1.3 |
| B | LangChain | 有动态 | core 1.8.4、openai 1.8.2–1.8.5、openrouter 0.3.0（11-18/19） |
| B | Dify | 有动态 | v1.20.0（11-18） |
| B | CrewAI | 有动态 | 1.15.42/43/44（11-18/19） |
| B | LlamaIndex | 无动态 | 最新 v0.14.26（11-13，窗外）；12 个集成包窗内 0 release |
| B | Google ADK | 有动态 | v2.15.0（11-19/20） |
| B | OpenAI Agents SDK | 有动态 | 1.0.0-alpha.1（11-20）；0.25.0 |
| B | browser-use | 有动态 | 1.0.6(11-16)/1.0.7(11-20)/1.0.8(11-22) |
| B | OpenHands | 有动态 | v1.41.0/1.42.0/1.43.0 |
| B | AutoGen | 无动态（已归档） | README 徽章；最后 release 2025-09-30 |
| B | MetaGPT | 无动态 | 最后 release 2025-03-09 |
| B | SuperAGI | 无动态 | 最后 release 2024-01-16 |
| B | agent-framework（名单外） | 有动态（供应链事件） | PyPI 1.26.1/1.26.2 被投毒，已移除；latest 1.26.0（11-12） |
| B | Coral（名单外） | 有动态 | v1.9.0 / v1.10.0（11-19） |
| B | Pulsar（名单外） | 有动态 | 2.0.0（11-19） |
| B | AG-UI（名单外） | 有动态 | 1.0.5（11-17）；四适配器协调发布（11-21） |
| C | OpenAI Operator / ChatGPT Agent | 有动态 | 11-16 医疗 CU 长文 + CVS `cua-agent-kit`；11-17 GPT-6.2 |
| C | Anthropic Computer Use | 无动态 | release notes 窗内仅 11-16/11-17 两条，均与 CUA 无关 |
| C | Project Mariner | 无动态 | DeepMind 页 0 次 "Mariner" |
| C | Google Gemini 计算机使用 | 有动态 | 11-19 Mac 版 CUA |
| C | Perplexity Comet / Computer | **本次未取得** | 5 入口 403/401；仅 Agent API changelog 可读 |
| C | Manus | 有动态（非能力项） | 11-16 Godot 基金会白金赞助 |
| C | Genspark | 无动态 | blog 最新 11-05；changelog 403 |
| C | Kimi | 无动态 | 平台 changelog 最新 2026-10；博客 10-24 |
| C | Qwen | **本次未取得** | 4 入口（SPA / 博客停更 / 空 feed / JS 壳） |
| C | AutoGLM / 智谱 | **本次未取得** | 4 入口（404 / 空壳 / 仓库无此项目） |
| C | 豆包 / 火山方舟 | **本次未取得** | 2 入口（JS 壳） |
| C | Playwright MCP（名单外） | 有动态 | v0.0.86（11-18）tab owner |
| C | Skyvern（名单外） | 有动态 | v1.0.58（11-17） |
| C | Cua（名单外） | 有动态 | 11-22 RuntimeWitnessV0 |
| C | Midscene（名单外） | 有动态 | 1.18.0（11-16）三中国模型适配 |
| D | MCP 核心规范 | 无新版本 | 最新 2026-07-28；下一版 2027-03-30 |
| D | MCP SEP 治理 | 有动态 | SEP-3415 / SEP-3392 / SEP-2577（11-16~20） |
| D | MCP Events 扩展 | 有动态（Beta） | 5 方法、三模式、三时点授权 |
| D | MCP Registry | 有动态 | v1.8.10→v1.8.15（11-20~22），OSV 扫描 |
| D | MCP Inspector | 有动态（安全） | 2.16.0 / 1.0.6（11-18），16 MiB |
| D | MCP TypeScript SDK | 有动态（无 release） | 11-18 #2820 扩展运行时 |
| D | MCP Python SDK | 无窗内发布 | 最新 v2.3.0（2026-10-02） |
| D | OSWorld | 无窗内活动 | 最后提交 2026-11-12（窗外） |
| D | WebArena | 无窗内活动 | 最后提交 2025-11-26 |
| D | GAIA | **本次未取得** | 仓库 404；HF lastModified 2025-10-28 |
| D | τ²-bench | 有动态 | 11-21 合并 Ava Zero voice-v2（900 trials / 87.33%） |
| D | agent-sandbox | 有动态 | v1.0.12（11-20） |
| D | gVisor | 有动态 | 20261116.0（11-17） |
| D | OpenShell | 有动态 | v0.1.9（11-19） |
| D | E2B | 无窗内发布 | 2.64.0（2026-11-13，窗外） |
| D | Cloudflare sandbox | 无窗内文章 | RSS 20 条无 sandbox 主题 |
| D | Microsoft Copilot Agents | 有动态 | Ignite 11-17：Autopilot / Entra Agent ID / Agent 365 |
| D | Sierra | 有动态 | 11-18/19/20 三篇（内容与白皮书，无新协议条款） |
| D | Glean | 有动态（内容，无产品） | 11-16/17/19 三篇治理与搜索文 |
| D | Harvey | 有动态 | 11-19 核验体系；11-20 保留/法律保留/审计 |
| D | Salesforce | 无 Agentforce 窗内发布 | 11-17 Informatica 集成；11-19 政策 |
| D | ServiceNow | **本次未取得** | 4 入口 403 |
| D | Coze | **本次未取得** | SPA 无条目；coze-studio 最新 2026-02-05 |
| D | 安全红队 | 有动态 | 6 篇预印本 + Inspector/Registry 修复 |
| D | memory / context | 有动态（研究集群） | 窗内 ≥12 篇预印本（11-16~19） |

**统计口径**：覆盖表 73 行（A 15 / B 18 / C 15 / D 25，含名单外纳入与合并行）；窗内**有动态 47**、**无动态/无新版本 19**、**本次未取得 7**（Perplexity Comet、Qwen、AutoGLM、豆包、GAIA、ServiceNow、Coze）。未取得率 7/73 ≈ 9.6%，未触发 25% 补搜。名单外纳入深写 13 个（A 3、B 5、C 4、D 5，部分重叠计一次）。

## 十、发现层摘要、局限与来源

### 10.1 名单外发现（四组均已做）

| 组 | 线索数 | 纳入深写 | 代表对象 |
|---|---|---|---|
| A | 17 | 3（+1 浅写） | Antigravity、Charm Crush（MCP Channels 首个非 Anthropic 实现）、Qwen Code；Amp |
| B | 22 | 5 | agent-framework 投毒、Coral（program-level 授权）、Pulsar 2.0（passkey presence）、AG-UI 1.0 适配器、Plannotator |
| C | 12 | 4 | CVS `cua-agent-kit`、Midscene、Skyvern、Cua RuntimeWitness |
| D | 20 | 5 | provider misbinding、Experience Rot、BRIDGE、Multi-Agent Memory Inconsistency、State-Transfer Auditing |

纳入理由统一为：有窗内一手原文、对开发者的迁移/选型有直接含义、且能讲清机制；未纳入的多为仅有标题、无窗内日期或机制不可得。

### 10.2 局限

- **入口不可达（已试 ≥2，逐项列于覆盖表）**：Perplexity Comet/Computer（5 入口 403/401）、Qwen（4）、AutoGLM（4）、豆包/火山方舟（2）、ServiceNow（4）、Coze（2）、GAIA（2）。这些记「本次未取得」，**不写作「没有发布」**。
- **官方公告缺失**：agent-framework 投毒事件无微软官方公告（GitHub 根页/releases/advisories 三入口 404），机制细节来自 Socket 单方 + PyPI registry 状态；证据等级按「A（registry）/B（机制细节）」处理。
- **alpha 无正文**：Codex 0.172/0.173 五个 alpha release 正文只有一行版本号，机制不可得，不据此推断方向。
- **口径问题**：OpenClaw 11.5 的 9,954 PR / 746 contributors 为累计口径，未拆分单版；Hermes v0.23.3 的 8 项机制无文档细节（v0.24.0 未发），机制描述来自 release 正文自述。
- **厂商自报**：τ²-bench 87.33% 为 Ava Zero 自提交（900 trials）；OpenAI 医疗文的 99%/93%/94.3% 为厂商组织评审；memory 与安全数字均为预印本作者自述（B）。
- **元数据不可得**：GitHub API 403，star/fork/下载量无法量化，「升温」只用 trending 与 HN 点位作弱证据。
- **文档不一致**：Claude Code 2.1.328 release 写 Opus 4.6/Sonnet 4.6 在第三方云支持 auto，permission-modes 文档列 Sonnet 5+/Opus 4.7+，两者口径不一致，正文不引用具体模型门槛。

### 10.3 来源（一手）

**协议 / 评测**
- MCP SEP-3415｜https://github.com/modelcontextprotocol/modelcontextprotocol/blob/main/seps/3415-events-extension.md
- MCP ext-events Beta 规范｜https://github.com/modelcontextprotocol/ext-events/blob/main/specification/beta/events/events.mdx
- MCP commits｜https://github.com/modelcontextprotocol/modelcontextprotocol/commits/main.atom
- MCP Registry releases｜https://github.com/modelcontextprotocol/registry/releases
- MCP Inspector releases｜https://github.com/modelcontextprotocol/inspector/releases
- MCP TypeScript SDK PR #2820｜https://github.com/modelcontextprotocol/typescript-sdk/pull/2820
- τ²-bench PR #771｜https://github.com/sierra-research/tau2-bench/pull/771
- SWE-bench commits｜https://github.com/SWE-bench/SWE-bench/commits/main.atom
- OSWorld commits｜https://github.com/xlang-ai/OSWorld/commits/main.atom
- WebArena commits｜https://github.com/web-arena-x/webarena/commits/main.atom

**编码 Agent**
- Claude Code releases｜https://github.com/anthropics/claude-code/releases.atom
- Claude Code npm｜https://registry.npmjs.org/@anthropic-ai%2fclaude-code
- Claude Code sessions 文档｜https://code.claude.com/docs/en/sessions
- Claude Code self-hosted environments｜https://code.claude.com/docs/en/self-hosted-environments
- Claude Code agent view｜https://code.claude.com/docs/en/agent-view
- Claude Code Code Mode｜https://code.claude.com/docs/en/code-mode
- Codex releases｜https://github.com/openai/codex/releases.atom
- Codex app-server｜https://learn.chatgpt.com/docs/app-server
- Gemini CLI releases｜https://github.com/google-gemini/gemini-cli/releases.atom
- Cline releases｜https://github.com/cline/cline/releases.atom
- OpenCode releases｜https://github.com/anomalyco/opencode/releases.atom
- Devin release notes｜https://docs.devin.ai/release-notes
- Devin Desktop changelog｜https://docs.devin.ai/desktop/changelog
- Replit updates｜https://docs.replit.com/updates/2026/11/20/changelog
- Cursor changelog｜https://cursor.com/changelog
- Aider releases｜https://github.com/Aider-AI/aider/releases.atom
- Roo Code releases｜https://github.com/RooCodeInc/Roo-Code/releases.atom

**开源框架 / 供应链**
- OpenClaw releases｜https://github.com/openclaw/openclaw/releases.atom
- OpenClaw npm｜https://registry.npmjs.org/openclaw
- OpenClaw 11.6 release｜https://docs.openclaw.ai/releases/2026.11.6.md
- OpenClaw trust model｜https://docs.openclaw.ai/gateway/security/trust-model.md
- OpenClaw automations｜https://docs.openclaw.ai/automation/cron-jobs/how-it-works
- Socket：agent-framework 投毒｜https://socket.dev/blog/agent-framework-pypi-package-compromised-with-credential-stealer
- PyPI agent-framework｜https://pypi.org/pypi/agent-framework/json
- Hermes v0.23.3｜https://github.com/NousResearch/hermes-agent/releases/tag/v0.23.3
- LangGraph 1.2.23｜https://github.com/langchain-ai/langgraph/releases/tag/1.2.23
- LangChain core 1.8.4｜https://github.com/langchain-ai/langchain/releases/tag/langchain-core%3D%3D1.8.4
- Dify v1.20.0｜https://github.com/langgenius/dify/releases/tag/1.20.0
- CrewAI 1.15.42｜https://github.com/crewAIInc/crewAI/releases/tag/1.15.42
- browser-use releases｜https://github.com/browser-use/browser-use/releases.atom
- Google ADK v2.15.0｜https://github.com/google/adk-python/releases
- OpenAI Agents SDK 1.0.0-alpha.1｜https://github.com/openai/openai-agents-python/releases
- Coral｜https://github.com/withcoral/coral/releases
- Pulsar 2.0.0｜https://github.com/yocontra/pulsar/releases/tag/v2.0.0
- AG-UI releases｜https://github.com/ag-ui-protocol/ag-ui/releases.atom

**浏览器 / Computer Use**
- OpenAI 医疗 CU｜https://openai.com/index/advancing-computer-use-for-healthcare-teams
- CVS cua-agent-kit｜https://github.com/cvs-health/cua-agent-kit
- OpenAI platform changelog｜https://platform.openai.com/docs/changelog
- Gemini Mac CUA｜https://blog.google/innovation-and-ai/products/gemini-app/computer-use-mac/
- Anthropic release notes｜https://platform.claude.com/docs/en/release-notes/api
- Anthropic computer use 工具｜https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool
- Perplexity Agent API changelog｜https://docs.perplexity.ai/changelog
- Playwright MCP releases｜https://github.com/microsoft/playwright-mcp/releases.atom
- Skyvern v1.0.58｜https://github.com/Skyvern-AI/skyvern/releases
- Cua｜https://github.com/trycua/cua/releases
- Midscene v1.18.0｜https://github.com/web-infra-dev/midscene/releases/tag/v1.18.0

**沙箱 / 企业 / 研究**
- agent-sandbox v1.0.12｜https://github.com/kubernetes-sigs/agent-sandbox/releases
- gVisor 20261116.0｜https://github.com/google/gvisor/releases
- OpenShell v0.1.9｜https://github.com/ai-openshell/openshell/releases
- Microsoft Ignite｜https://www.microsoft.com/en-us/microsoft-365/blog/2026/11/17/copilot-at-microsoft-ignite-expanding-whats-possible-with-intelligence-built-for-work/
- Harvey 核验｜https://www.harvey.ai/blog/how-harvey-is-building-reviews-and-verification
- Harvey 治理｜https://www.harvey.ai/blog/information-governance-in-harvey
- Sierra 白皮书解读｜https://sierra.ai/blog/personal-agents-insights
- Experience Rot｜arXiv 2611.20922
- Provider misbinding｜arXiv 2611.21577
- PIPETTE｜arXiv 2611.24362
- State-Transfer Auditing｜arXiv 2611.23346
- GapLeak｜arXiv 2611.22223
- Multi-Agent Memory Inconsistency｜arXiv 2611.22245
- BRIDGE｜arXiv 2611.22179
- ARISE｜arXiv 2611.23588

### 10.4 冻结声明

本母稿冻结于 2026-11-23 研究阶段，窗口 2026-11-16 ~ 2026-11-22（CST）。四组分片位于 `shards/A|B|C|D/`，含各自 `discovery.md` 与状态表。读者稿 `reader.md` 由本母稿按 report2article 改写，语义保真；发布由 Bot 在独立会话执行，本次未推仓、未使用任何凭证、未调用 Codex。
