# 全球 AI Agent 研究周报 · 第 12 期（2026-08-17 ~ 2026-08-23）

> **覆盖区间**：2026-08-17 00:00 ~ 2026-08-23 24:00（Asia/Shanghai，刚结束的完整自然周）  
> **覆盖范围**：编码 Agent、开源项目与框架、浏览器/Computer Use、企业与垂直 Agent、协议、记忆、沙箱、权限、审计、可观测与评测，共核验 **49 个固定对象/对象组**。  
> **数据声明**：仅写时间窗内可核验公开信息；窗外内容只作明确背景。关键事件回到官方原文，开源数据直查 GitHub 页面/API；供应商数字按供应商口径标注，无法全文核验的线索降级为观察，不以摘要下结论。

![全球 AI Agent 研究周报头图](/assets/images/2026-08-24-global-ai-agent-weekly.png)

## 本周一句话

> Agent 产品正在从“会话内助手”变成可共享、可订阅事件、可持续运行的组织工作单元；与之同步，工程竞争点从模型能力前移到持久状态、身份委派、审批、恢复、幂等与审计，商业化也开始从席位费转向 credits、运行预算和业务结果。

## 🔥 本周 TOP 5 Agent 事件

### 1. OpenAI Workspace Agents：组织级常驻 Agent 成为独立产品层

OpenAI 将 ChatGPT Agent 从个人一次性代办扩展为可共享、可定时、可在 ChatGPT 与 Slack 中持续运行的 workspace agent。产品由 Codex 云端执行，连接文件、代码、工具和 memory，并提供动作审批、管理员连接器/分享控制、Compliance API 与运行分析。它的核心意义不是又多了一个“Agent builder”，而是把 Agent 定义成组织内可复用、可治理、可计量的工作单元；研究预览、提示注入与跨工具写操作风险意味着企业仍需从窄权限场景开始。

### 2. Cursor Origin：编码 Agent 开始反向吞并代码托管与事件源

Cursor Origin early beta 把 repo、PR、代码浏览、GitHub 双向同步和 Agent 放进同一控制面；同周的 cloud agents/harness 更新又增加 PR、Slack、schedule 订阅、独立 VM subagents、长期 `/goal` 与周期 `/loop`。两组能力合起来，Cursor 不再只争 IDE 入口，而是开始掌握代码托管、PR/CI 事件和常驻执行闭环。平台锁定与 source-of-truth 风险随之上升，企业应保留 GitHub 同步、权限边界与退出路径。

### 3. MCP 新路线图：身份、事件与渐进式工具发现进入核心议程

8 月 23 日 MCP 路线图把 Agent identity/delegation、server-initiated events、HTTP-native transport、改进 primitives 与 SDK conformance列为五大优先方向。最关键的变化是协议开始面向无人值守云端 Agent、代用户行动和对子 Agent 的窄权限委派，并计划通过 DPoP、WIF、ID-JAG 与 token exchange 取代长期 API key；progressive discovery 则同时降低百工具场景的 token 成本和误选攻击面。路线图不是已落地规范，但其生态外溢面最大。

### 4. OpenAI Agents SDK v0.22.0：guardrail 从显示层进入持久状态安全

v0.22.0 会将被 output guardrail 拒绝的终态工具输出从 replayable/persisted SDK state 中清除，并对 `failed/incomplete` 非流式响应 fail closed。这个改动揭示了一个普适问题：敏感输出即使没有展示给用户，只要仍留在 checkpoint、session 或 trace 中，就可能在后续回放中重新泄漏。它是容易被其他框架复用的安全基线，但不能替代工具调用前授权和外部副作用控制。

### 5. Kimi Work：浏览器登录态、本地 OS 与 300-Agent 调度汇入桌面执行面

Kimi Work 把本地文件、Python/shell、已登录浏览器 WebBridge、定时任务和 Goal Mode 合为桌面 Agent，官方宣称单指令最多调度 300 个 Agent。产品层面，它代表中国通用 Agent 从云端问答走向本机交付闭环；工程层面，真正价值在可观察的目标循环和人工干预，而不是“300”这个容量数字。文件写入、shell 与登录态浏览器三权合一也形成本周最高权限风险，企业部署必须使用目录白名单、独立浏览器 profile、强制审批和版本回滚。

## 🧭 三条主线

### 产品主线：Agent 成为可持续运行的工作单元

OpenAI Workspace Agents、Cursor subscriptions/goal/loop、Cline durable schedule、Replit Routines、Devin Automations 与 Kimi Goal Mode 共同指向同一形态：Agent 不再依赖用户守在聊天框前，而是由事件或计划触发，在持久目标上持续执行，并允许人类在关键节点 steer、approve、pause 或接管。竞争焦点因此从“单轮回答好不好”转向“任务状态是否可见、是否可恢复、是否能安全地产生产物”。

### 工程主线：可信状态、身份委派和失败语义

OpenAI Agents SDK 清洗被阻断的持久状态，Cline 加入 drain/replay/dedupe，ADK 修复 Live session、任务取消与 A2A/HITL，MCP 把 Agent identity 和事件机制推到协议层。Agent 运行时正在呈现分布式系统特征：需要幂等、重试上限、事件顺序、checkpoint 一致性、短期凭据、委派链、动作级 trace 与可回滚副作用。没有这些原语，benchmark 高分无法转化为生产可靠性。

### 商业化主线：从席位转向运行量、预算与结果

OpenAI 预告 workspace agents 进入 credits 逻辑，Replit 把 recurring run 与 Power/Max 预算绑定，Devin 提供 ACU 限额与企业部署，Cursor 用付费计划扩展 Origin，Microsoft 用 Marketplace 建立行业 Agent 分发与采购入口。近期最现实的模式不是纯 outcome pricing，而是“席位/容量 + credits/动作 + 私有连接与治理”的混合计费；合同需要明确失败调用、重试、人工升级和外部副作用是否计费。

## 🧩 开源生态雷达

### 高活跃与增长项目

- **OpenAI Agents SDK**：状态清洗、fail-closed 与 checkpoint usage 隔离，安全语义可迁移。
- **Google ADK**：Live session、任务取消、A2A/HITL 与 Agent Engine 快速硬化；高频回滚同时暴露协议组合风险。
- **Cline**：durable Hub drain/replay/dedupe、Langfuse trace 与企业 MCP policy，向长期运行服务迈进。
- **OpenHands**：可安装 automation bundle、provenance、本地 agent-server UI 与桌面安装形成分发闭环。
- **Hermes Agent**：Bot Mode、cron persistent memory、skill 扫描、多 sandbox 与 stall guards 组合出个人 Agent OS 新范式，但超大 rollup 使审计成本很高。

### 事实标准候选

- **MCP**：从工具连接扩展到身份、委派、事件和渐进发现，生态位置最强，但新路线仍待规范和跨厂商 conformance 落地。
- **LangGraph / LangChain Agents**：状态图、子图与可恢复执行仍具结构优势；本周信号偏可靠性修复而非能力跃迁。
- **OpenAI Agents SDK / Google ADK**：分别在持久状态安全和 A2A/Live/部署栈上形成可复用运行时原语。
- **Cline / OpenHands automation 分发**：skill/automation 正变成可安装能力单元，下一阶段必须补签名、来源、权限和撤销机制。

### 热闹但尚不成熟

- **Hermes Agent**：极高 star 与大规模 patch rollup 不能替代留存、任务成功率和稳定升级证据。
- **AutoGPT Platform beta**：专家 pods、隔离 memory、预算和支付审批贴近组织运营，但金融副作用与 beta 成熟度需要单独验证。
- **OpenClaw / Dify 主干**：窗口内有大量重要工程变化但无正式 release，生产团队应追稳定版本、契约和回归证据，不追 main。

### 静默与迁移风险

AutoGen、MetaGPT/FoundationAgents、SuperAGI、Aider、Roo Code 与 browser-use 本周未出现满足门槛的重大正式动态；其中历史 star 只能说明累计关注，不能替代维护连续性、正式 release 与生产采用。

## 📡 Agent 产品雷达

### 编码 Agent

Cursor 通过 Origin 与常驻 cloud agents 扩大平台边界；Codex CLI、Claude Code、Gemini CLI、OpenCode、Cline、Devin 与 Replit 的共同主题是多 session/subagent 调度、队列、事件订阅、权限 profile、MCP policy、持久目标与成本 telemetry。编码 Agent 的胜负正在从补全质量转向“事件源 + 隔离执行 + 状态恢复 + 企业控制面”。

### 浏览器与通用 Agent

OpenAI Workspace Agents 把浏览器代办上收为组织工作流；Kimi Work 把登录态浏览器、本地文件与 shell 下沉到桌面；Genspark 用 Office 执行面和 Git 化记忆强调 diff/rollback；Qwen Code 用 fork、工具收窄、缓存和续跑完善多 Agent runtime。Mariner、Comet、Manus、AutoGLM 本周无满足原文与日期门槛的重大新增。

### 企业与垂直 Agent

Microsoft Dragon Copilot 新的 Marketplace offer type 补上医疗 Agent 的发现、采购、履约与部署通道，但患者数据权限、审计和责任归因披露不足。Sierra、Glean、Harvey、ServiceNow、Salesforce Agentforce 与 Coze 本周没有可计入的官方新增；Salesforce AWU 与 Glean 大会预告仅作为背景/下周观察，未冒充本周动态。

### 协议、评测与基础工程

MCP 是本周最强协议信号；公开 benchmark 侧没有可核验的新突破。SWE-bench、OSWorld、WebArena、GAIA、τ-bench 与安全红队均应从单次总分升级为可执行内部回归：同时报告 pass^k、环境版本、轨迹、成本、权限前提、副作用、人工接管与失败恢复。

## 四维质量门控

- **覆盖率**：49/49 个固定对象/对象组完成实质核验（100%）；有料 25 个，观察/静默 24 个，超过 80% 门槛。
- **原文深度**：随机抽查 Cursor Origin、OpenAI Agents SDK v0.22.0、OpenAI Workspace Agents、Kimi Work、MCP Roadmap 共 5 个对象，5/5 URL 返回 200，核心功能与原文一致。
- **GitHub/benchmark 数据**：开源 stars/forks/release/commit 直查 GitHub 页面/API并注明 2026-08-24；匿名 API 限流处已降级到官方仓库/release 页面，未伪造 contributor 数；benchmark 无本周新证据时明确写“无动态”。
- **工程判断**：有料对象均覆盖产品、架构、生态/采用、风险与影响；全文具备产品、工程、商业化三条主线。
- **数据可信**：关键数字有来源与日期；厂商口径、背景材料、未公开项和无法确认日期的材料均明确标注，未把搜索摘要当结论。

## 各组深度正文


## 编码 Agent / CLI / IDE

- **严格时间窗**：2026-08-17 00:00—2026-08-23 24:00（Asia/Shanghai；对应 UTC 2026-08-16 16:00—2026-08-23 16:00）。
- **查询/核验日**：2026-08-24。
- **研究对象**：Claude Code、OpenAI Codex/Codex CLI、Google Gemini CLI、Cursor、Cognition Devin/Windsurf、OpenCode、Aider、Cline/Roo Code、Replit Agent，以及窗口内明显活跃的编码 Agent。
- **核验方法**：逐一检查官方博客、changelog、文档与官方 GitHub Releases；开源项目同时通过 GitHub API 核验 release 时间、仓库 stars/forks/open issues，并检查贡献者接口。仅把发布时间或明确发生时间落在窗口内的事项列为“本周动态”；窗口外内容只作背景。搜索摘要不作为事实终点，动态条目均回到官方原文。GitHub stars/forks 是查询时点快照，只反映关注度，不等同于产品价值或采用。

> 注：GitHub 的 contributor 总数没有直接字段；若分页响应未提供可靠 Link 尾页，本文不臆测总数，写“未公开/未可靠取得”。商业闭源产品未披露的架构与采用数字亦明确标注“未公开”。

---

### 1. Claude Code — 有料

**本周动态（≥200字）**：窗口内官方连续发布 v2.1.234—v2.1.241。重点不是单一 UI 小修，而是生产化边界同步前移：v2.1.234 加固 Windows NT namespace 路径，覆盖远程读取、会话恢复、CLAUDE.md include、workflow 与上传，防 NTLM 凭证泄漏；长会话压缩后 sandbox 网络检查异常亦被修复。v2.1.236 增加跨会话 `SendMessage.notify_when_idle`，并让 macOS sandbox 中 `.env` 等通配拒读规则优先、不能靠重命名绕过。v2.1.238 为 URL 插件市场增加可动态签发短期 HTTP header 的 `headersHelper`，执行前展示命令并默认 `[y/N]`；自托管 runner 支持延迟关停与动态代理授权；同时释放离开近期显示窗口的 subagent tool result，遏制长会话无界内存增长。v2.1.239 又补齐云会话同步插件命名隔离、MCP 5xx 重连、OTel trace 连续性、跨机器会话通信（含 Windows）、目标恢复，以及 Bedrock 代理导致“每轮重跑、账单翻倍”等严重可靠性问题。v2.1.240/241 官方仅称 bug fixes/reliability，无细项，本文不外推。

- **产品形态**：终端 agent + IDE 集成 + Web/Desktop/Mobile 云会话 + self-hosted runner/Remote Control；同一会话体系连接本地、云端及跨机器协作。
- **工程架构**：项目指令/skills/plugins 构成上下文层；Bash、Edit/Write、WebFetch、MCP 等工具层；macOS/Linux sandbox 与显式权限提示；会话持久化、压缩、`/resume`、`/goal`；subagent、跨会话 SendMessage/ListAgents；OTel 可观测。本周变更显示其重点是权限 fail-safe、云会话恢复、工具结果生命周期和多会话消息总线。
- **生态/采用**：GitHub 仓库查询快照为 **142,768 stars、22,856 forks、15,131 open issues**（GitHub API，2026-08-24）；贡献者总数未可靠取得。云端同步插件不覆盖同名本地插件，体现生态冲突隔离。热度不等于企业采用或价值，官方本周未披露活跃用户/收入。
- **风险/限制**：高频修复暴露出复杂部署矩阵（Bedrock/Vertex/Foundry、代理、musl、IDE、云 session）带来的回归面；插件 `headersHelper` 本质可执行命令，虽有展示与确认仍需供应链审计；费用与数据驻留策略差异增大配置复杂度。
- **关键数据+来源+日期**：v2.1.234 发布 2026-08-17 20:20 UTC，v2.1.239 发布 2026-08-21 19:54 UTC；仓库指标如上，均由 GitHub API 于 2026-08-24 查询。
- **官方原文**：[v2.1.234](https://github.com/anthropics/claude-code/releases/tag/v2.1.234) · [v2.1.236](https://github.com/anthropics/claude-code/releases/tag/v2.1.236) · [v2.1.238](https://github.com/anthropics/claude-code/releases/tag/v2.1.238) · [v2.1.239](https://github.com/anthropics/claude-code/releases/tag/v2.1.239) · [Releases](https://github.com/anthropics/claude-code/releases)
- **影响判断**：**高**。Claude Code 正从“单终端助手”转为跨设备、跨会话、可自托管的 agent runtime；本周价值主要是把权限、恢复、代理和追踪补到企业可运营水平，而非模型能力跃迁。

### 2. OpenAI Codex / Codex CLI — 有料

**本周动态（≥200字）**：官方在 8 月 18 日发布稳定版 0.148.0，新增完整 TUI 对话 Markdown 导出、`codex exec fork`、会话归档/恢复、费用估算、Amazon Bedrock 原生 provider，以及“异步命令 + MCP tool”hooks；恢复会话会保留 cwd 与 approval policy，MCP OAuth 重认证后无需重启，Linux/Windows sandbox 对拒绝或不可读路径改为 fail closed。8 月 20 日的 0.149.0 更关键：加入交互式 `codex agents` dashboard，可搜索、启动、打开、重命名和停止任务；`codex queue` 可向本地或远程既有 session 投递消息；`codex doctor` 扩至端点防护、网络/代理、桌面状态和更新链路。完整 changelog 还显示环境级 command policy、MCP OAuth header 隔离与同源 redirect、Linux capability drop、Windows reparse point 防护、Guardian 风险/审批链、app-server 成本 telemetry 等工程化内容。它把多 Agent 操作、会话生命周期、权限恢复和诊断合并进 CLI 控制面。

- **产品形态**：Rust CLI/TUI + app server/SDK + 本地/远程 session；可接 OpenAI 及本周新增 Bedrock Runtime。
- **工程架构**：项目/插件 skill loader 与上下文压缩；工具、MCP、hooks；Linux/Windows sandbox 和 approval profile；session fork/archive/resume/queue；`agents` dashboard 作为多 Agent 控制面；doctor、tracing、cost telemetry 提供可观测性。
- **生态/采用**：GitHub API 快照 **115,364 stars、17,590 forks、13,573 open issues**（2026-08-24），贡献者总数未可靠取得。Bedrock 与 MCP hook 扩展部署/工具生态；官方本周未披露 MAU、付费转化或企业席位。
- **风险/限制**：0.148→0.149 两天一稳定版且大量 alpha 并行，升级节奏快；完整 changelog 暴露权限投影、MCP redirect、sandbox path 等持续加固区域。安全 devcontainer 文档明确提示 DNS exfiltration 与信任边界，sandbox 不能被误当成绝对隔离。
- **关键数据+来源+日期**：0.148.0（2026-08-18 22:26 UTC）、0.149.0（2026-08-20 21:04 UTC）；仓库指标来自 GitHub API，查询日 2026-08-24。
- **官方原文**：[0.148.0](https://github.com/openai/codex/releases/tag/rust-v0.148.0) · [0.149.0](https://github.com/openai/codex/releases/tag/rust-v0.149.0) · [Releases](https://github.com/openai/codex/releases)
- **影响判断**：**高**。`agents` dashboard + queue 把 Codex CLI 从单会话交互器推向任务编排入口；Bedrock、MCP hooks、诊断与 permission persistence 则明显瞄准组织级运行环境。

### 3. Google Gemini CLI — 有料

**本周动态（≥200字）**：官方在窗口内发布 v0.56.0 稳定版与 v0.57.0-preview.0，并持续 nightly。v0.57 preview 原文显示：Cloud Workstations OAuth 代理 redirect URI 改为动态解析；IDE 连接不再吞掉工作目录不匹配；新增 eval validate、tool-call formatter 和失败摘要；容量错误加入“结合上下文的静默重试 + availability TTL”；取消/abort 时回滚整个多轮请求，避免半提交状态；规范化 git 环境以修复 workspace state mismatch。SSR Agent 相关修复包括为 TUI 执行加 timeout 防无限挂起、禁用 agents mode 时阻止 subagent、修复启动时 sub-agent handoff token 回归。后续 nightly 还统一 ignore path 的 symlink 求值，并在 macOS Seatbelt 中隔离 Docker/container runtime sockets 与 binaries。整体是围绕 Agent 状态原子性、子 Agent 开关、评测可诊断性与 sandbox 边界的集中收敛。

- **产品形态**：开源终端 Agent，兼具 IDE 连接、Cloud Workstations/Vertex 环境与 SSR/subagent 能力。
- **工程架构**：多轮上下文与 `/clear` 重置；shell/filesystem/media/tools；agents mode/subagent handoff；macOS Seatbelt sandbox；OAuth、workspace/git 状态；eval failure summary 提供质量可观测。本周的全请求 rollback 强化取消语义，减少状态撕裂。
- **生态/采用**：GitHub API 快照 **106,642 stars、14,476 forks、806 open issues**（2026-08-24）；贡献者总数未可靠取得。nightly 8/22 记录一名新贡献者，但不能据此推总贡献人数。
- **风险/限制**：本周亮点大多在 preview/nightly，稳定性与默认可用性需区分；容量重试可能隐藏真实 provider 拥塞；subagent 与 sandbox 仍处快速修复期。官方未披露生产采用、成功率或成本改善数据。
- **关键数据+来源+日期**：v0.56.0 与 v0.57.0-preview.0 均发布于 2026-08-19 UTC；仓库快照查询日 2026-08-24。
- **官方原文**：[v0.57.0-preview.0](https://github.com/google-gemini/gemini-cli/releases/tag/v0.57.0-preview.0) · [8/22 nightly（sandbox）](https://github.com/google-gemini/gemini-cli/releases/tag/v0.56.0-nightly.20260822.g5411f113c) · [Releases](https://github.com/google-gemini/gemini-cli/releases)
- **影响判断**：**中高**。不是新交互范式，但取消原子性、eval 摘要、子 Agent 开关和容器边界都直接影响可测试、可控和可托管程度。

### 4. Cursor — 有料

**本周动态（≥200字）**：8 月 17 日 Cursor 宣布 Origin Code Hosting 进入 early beta，覆盖所有付费计划（企业管理员可选择退出），首批提供 repo、PR、代码浏览、GitHub 双向同步，并把 Agent 直接放进 repo/PR 上下文；Vercel、Depot、Buildkite 已作为首批 app extension。8 月 19 日又发布 cloud agents/harness 更新：Agent 可订阅 PR、Slack thread 或 schedule，事件到来时唤醒；它创建的 PR 自动订阅并持续修 CI/处理 bot 评论。skills 可固定为 Custom Mode；subagent 可各自运行在独立 VM，拥有项目隔离副本和干净上下文，用于 swarm 或独立验证；`/goal` 持有长期目标，`/loop` 定期检查；用户 steering 消息改在下一次 tool call 注入而非中断当前动作。两项发布组合起来，Cursor 在同一周同时控制“代码托管/PR 事件源”和“常驻 Agent 执行面”。

- **产品形态**：AI IDE + Cloud Agents + Slack/PR 入口 + 新增 Origin 代码托管/PR 平台。
- **工程架构**：repo/PR/Slack/schedule 作为事件上下文；skills/Custom Mode 提供持久行为约束；每个 subagent 独立 VM 和 clean context；goal/loop 支撑长任务；事件订阅与 non-interrupt steering 构成调度层。sandbox 具体实现、权限模型、持久记忆与底层 observability 细节本周原文未公开。
- **生态/采用**：Origin 已接 Vercel、Depot、Buildkite，并支持 GitHub 实时双向同步；early beta 面向所有 paid plans。用户数、repo 数、Agent 完成率、付费转化未公开。
- **风险/限制**：subscriptions 暂仅 cloud agents；Origin 是 early beta，GitHub 来源 repo 仍以 GitHub 为 source of truth。代码托管、Agent 执行与应用扩展集中到单一供应商，带来锁定、权限放大、凭证/供应链和故障域集中风险；独立 VM 降低冲突但提高成本。
- **关键数据+来源+日期**：Origin 2026-08-17；Cloud Agents/Harness 2026-08-19。商业闭源产品，无可比 GitHub 仓库指标；采用数字未公开。
- **官方原文**：[Origin Code Hosting](https://cursor.com/changelog/origin-code-hosting) · [Cloud Agents and Cursor Harness Improvements](https://cursor.com/changelog/08-19-26) · [Cursor Changelog](https://cursor.com/changelog)
- **影响判断**：**很高，候选 TOP1**。Cursor 正把竞争边界从“编辑器里的 Agent”推向 agent-native forge：自己掌握 repo、PR、CI 事件和常驻执行，商业护城河与平台风险同步上升。

### 5. OpenCode — 有料

**本周动态（≥200字）**：窗口内官方发布 v1.18.19、v1.18.20、v1.18.21。v1.18.19 加入 Cloudflare AI Gateway 对 OpenAI/Anthropic 的原生 passthrough，传递 ChatGPT workspace compute residency 到 Codex 请求，并处理 websocket 消息过大、错误 model pricing、Qwen 不支持的 sampling 参数等多 provider 兼容问题。v1.18.20 聚焦多 Agent 失败语义：subagent tool call 失败会暴露可恢复 `task_id`，不再返回空结果；`opencode run` 中由 subagent 触发的 permission request 可被正确应答；对 `finish_reason: network_error`、xAI capacity/temporary unavailable 等可重试。v1.18.21 又处理未知 finish reason 不中断，以及 Vertex AI 美/欧多区域 Gemini 走 REP endpoint。信号很明确：OpenCode 的差异化在 provider-neutral runtime，但可靠性成本也集中在不同 provider 的协议、限额、错误码和数据驻留语义适配。

- **产品形态**：开源终端/桌面编码 Agent 与多 provider runtime。
- **工程架构**：session/archive、tools/subagent、权限请求、provider adapter、重试与 resumable task；本周未见新 MCP/sandbox/长期记忆能力发布。失败返回 `task_id` 是可恢复执行的关键可观测接口。
- **生态/采用**：仓库已迁至 `anomalyco/opencode`；GitHub API（旧别名自动解析）快照 **200,692 stars、25,956 forks、5,400 open issues**（2026-08-24）。v1.18.19 点名 4 名社区贡献者，v1.18.21 点名 1 名；总贡献人数未可靠取得。
- **风险/限制**：广泛 provider 兼容意味着错误语义难以统一；自动重试须防重复副作用；透传 data residency 不能替代端到端审计。stars 很高但不等于留存、企业采用或任务成功率，后者未公开。
- **关键数据+来源+日期**：v1.18.19（2026-08-20）、v1.18.20/v1.18.21（2026-08-21）；GitHub 快照查询日 2026-08-24。
- **官方原文**：[v1.18.19](https://github.com/anomalyco/opencode/releases/tag/v1.18.19) · [v1.18.20](https://github.com/anomalyco/opencode/releases/tag/v1.18.20) · [v1.18.21](https://github.com/anomalyco/opencode/releases/tag/v1.18.21)
- **影响判断**：**中高**。没有 headline feature，但 resumable subagent failure 与权限回路是多 Agent runtime 从“能跑”到“可恢复”的核心工程进步。

### 6. Cline — 有料

**本周动态（≥200字）**：Cline 在桌面、CLI、SDK、扩展多轨密集发布。Desktop v0.0.15 将 Plugins、MCP servers、Skills 合并为 Marketplace，并允许 Agent 管理 durable todos 与一次性/周期 schedule；SDK v0.0.76 改为通过 skills tool 加载 slash command，避免把整份 SKILL.md 粘进用户消息和重复注入，并补回 provider-executed tool observational events、Pre/PostToolUse hook 的 context/cancel 语义，AI SDK spans 增加 user/session/conversation/run/provider/model 标签。SDK v0.0.78 与 CLI v3.0.57 引入 Hub drain/upgrade：停止接收新变更，完成在途工作；durable event log 让客户端重连 replay，event-id 去重，durable run 不丢；Langfuse trace 绑定 session/client，delegated agent 归组到 parent。扩展 v4.1.12 还执行企业 MCP marketplace/allowlist 控制，并修复自定义 OpenAI-Compatible 模型 capability 为空时工具调用被关闭的问题。整体围绕长驻调度、Hub 高可用、工具可观测和企业策略闭环。

- **产品形态**：VS Code 扩展 + Desktop + CLI/TUI + SDK/Hub + 云 handoff（beta）；多模型、多 provider。
- **工程架构**：skills/MCP/plugins 统一工具目录；durable agenda/schedules；session history/checkpoints；Hub event log/replay/dedupe/drain；delegated agents；企业 allowlist/auto-approve；AI SDK/Langfuse traces。sandbox 的底层隔离细节本周未公开。
- **生态/采用**：GitHub API 快照 **66,729 stars、7,196 forks、1,065 open issues**（2026-08-24），贡献者总数未可靠取得。新增/刷新多 provider 与 model catalog；Marketplace 统一生态入口。
- **风险/限制**：企业 MCP allowlist 有助于治理，但工具权限与 marketplace 配置仍需持续审计。model catalog 默认值变化可能导致未 pin 用户静默换模；Hub replay/dedupe 改善恢复，但真正 exactly-once 副作用仍取决于工具幂等性。多发行轨增加版本配套复杂度。
- **关键数据+来源+日期**：Desktop v0.0.15、SDK v0.0.76 与 v4.1.12 于 2026-08-21；SDK v0.0.78 于 2026-08-22 UTC（均落在上海时间窗内）。仓库快照查询日 2026-08-24。
- **官方原文**：[Desktop v0.0.15](https://github.com/cline/cline/releases/tag/desktop-v0.0.15) · [SDK v0.0.76](https://github.com/cline/cline/releases/tag/sdk/sdk/v0.0.76) · [SDK v0.0.78](https://github.com/cline/cline/releases/tag/sdk/sdk/v0.0.78) · [v4.1.12](https://github.com/cline/cline/releases/tag/v4.1.12)
- **影响判断**：**高**。Cline 本周最强信号不是品牌/UI，而是把 agent runtime 做成可 drain、可 replay、可 trace、可施加企业 MCP policy 的服务。

### 7. Cognition Devin / Devin Desktop（原 Windsurf）— 有料

**本周动态（≥200字）**：8 月 21 日 Devin 平台更新同时推进多 Agent 导航、企业 MCP 与安全扫描：session 页/侧栏重构，Sub-Devin 以嵌套树展示；新增 session subscribers；automation webhook 可用 Bearer secret；Code Scan 可切 security profile、选择 normal/deep effort，v3 API 支持立即增量扫描和多 repo ingest。企业管理员可一次配置 MCP server 后分发到选定组织，组织自己的同名安装优先；dedicated deployment 可经私网 tunnel 完成 MCP OAuth 与调用，并上传私有 CA。8 月 19 日还加入 Ultra lead action model 降级/恢复通知、automation schedule timezone。Devin Desktop v3.8.20 则允许多个 Agent Command Center 窗口并行；Local 的 subagent 可单独停止，plan mode 生成可审阅 Markdown plan 后显式 Implement；workspace 未信任时阻止 local agent 并提示授权；可控制 terminal/user-edit activity 是否分享给 ACP agents；Cloud shell 实时流式输出，网络配置冲突不再静默覆盖。

- **产品形态**：Web 云 Agent、Devin Desktop（原 Windsurf）agent-native editor、Devin Local/Cloud、Review/Code Scan、Slack 与 Automations。
- **工程架构**：session hierarchy/Sub-Devin；worktree hooks、计划-实施两阶段；workspace trust 与 network security profiles；MCP 企业分发、私网 tunnel/CA；automation/webhook/API；model degradation、shell stream、scan findings 提供可观测。
- **生态/采用**：New Relic MCP 新入 marketplace，Mintlify Index MCP 脱离 beta，Cello MCP 于 8/19 加入；企业级统一安装可下发到组织。闭源，用户/席位/任务成功率/收入本周未公开。
- **风险/限制**：企业级 MCP 继承/覆盖与私有 CA 显著增强能力，也放大管理员误配和横向权限风险；terminal/user edits 默认分享给 ACP agents，组织需审视数据最小化；多窗口、多 session/subagent 提升并发但也提高成本与监督负担。
- **关键数据+来源+日期**：平台更新 2026-08-19、08-21；Desktop v3.8.20 于 2026-08-21。商业指标未公开。
- **官方原文**：[Devin Recent Updates](https://docs.devin.ai/release-notes/overview) · [Devin Desktop v3.8.20 changelog](https://docs.devin.ai/desktop/changelog)
- **影响判断**：**高**。Cognition 的路线已清晰统一：本地/云执行、多 Agent session tree、Code Scan、自动化与企业 MCP policy 汇聚为工程平台，而不只是独立开发者 IDE。

### 8. Replit Agent — 有料

**本周动态（≥200字）**：Replit 8 月 21 日官方更新重构了 Agent 的任务入口和商业分层。Free Mode 允许聊天、探索与构建而不消耗 Power/Max credits（额度仍按 plan）；用户可先在私有 Conversation 中附加上下文、运行 Routine，再把工作升级为 Project，保留上下文和文件。Routines 让同一 Conversation 周期执行，结果回到原线程，但每次须配置 Power/Max budget。消息可在 Agent 工作时选择 Steer（注入当前 turn）或 Queue；Skills 可从公开 GitHub repo/folder/file 导入，添加前预览，Project Skills 有 Required/Available/No access 权限。企业管理员可按 provider 制定 account policy，再按 Workspace 控制具体模型。Level 3 security scan 并行组合依赖检查、Agent 源码静态分析与对 live Preview 的外部黑盒测试。这使 Replit 从“生成应用”进一步转向 Conversation→Project→Routine 的持续工作流。

- **产品形态**：浏览器 Workspace、Conversations、Projects、Agent modes、Routines、部署 Preview 与安全中心一体化。
- **工程架构**：Conversation 保存上下文/文件并可升格 Project；Routines 提供 schedule/run history；Steer/Queue 控制活动 turn；GitHub Skills；workspace 级模型 policy；Level 3 并行扫描。sandbox、MCP、多 Agent、底层记忆策略本次原文未披露。
- **生态/采用**：公开 GitHub Skills 可导入，降低工作流迁移门槛；企业 provider/model policy 支持治理。闭源；本周未披露 MAU、Agent 成功率、Routines 数或收入。
- **风险/限制**：Free Mode 仍有计划额度；Routines 必须使用付费模式并设预算，商业化与自动化深度绑定。公开 GitHub Skill 是供应链输入，虽可预览仍需版本 pin/审计。黑盒测试对 live Preview 发起外部测试，需确保授权与隔离范围。
- **关键数据+来源+日期**：官方 changelog 日期 2026-08-21；采用/性能数据未公开。
- **官方原文**：[Replit Changelog — August 21, 2026](https://docs.replit.com/updates/2026/08/21/changelog) · [Changelog入口](https://replit.com/changelog)
- **影响判断**：**高**。Conversation→Project→Routine 是清晰的漏斗：免费探索获客、项目承接资产、按次预算自动化变现；同时以 Skills 与企业模型治理扩展生态及组织采用。

### 9. Aider — 观察/静默

- **核验范围**：官方 [Release history](https://aider.chat/HISTORY.html)、[GitHub Releases](https://github.com/Aider-AI/aider/releases)、仓库元数据/最近 push。
- **核验结果与原因**：时间窗内没有带明确发布日期的新 release；官方 history 顶部为未标日期的 `main branch` 条目，不能仅凭页面现状认定发生于本周，因此不写作本周动态。GitHub API 显示仓库最近 push 为 2026-05-22，进一步支持本周无已发布重大变更。旧版 v0.86.1 等仅作背景，不混入时间窗。
- **产品/工程背景**：终端 pair-programming 工具，以 repo map、git commit、architect/editor model 分工和多 provider 适配见长；本周没有可核验的新 MCP、sandbox、权限、记忆或多 Agent 发布。
- **关键数据**：**48,434 stars、4,873 forks、1,818 open issues**（GitHub API，2026-08-24）；贡献者总数未可靠取得。热度不代表当前发布活跃度。
- **判断**：静默不等于停止使用，但相较本周常驻/多 Agent 平台化竞赛，Aider 官方发布节奏明显偏静态。

### 10. Roo Code — 观察/静默

- **核验范围**：官方 [GitHub Releases](https://github.com/RooCodeInc/Roo-Code/releases)、仓库元数据及 archive 状态。
- **核验结果与原因**：仓库已于 **2026-05-15** 被 owner archived 并设为只读；时间窗内无 release、无代码 push，故无重大动态。页面可见的 v3.54.0、CLI prerelease 等均为旧闻，不计入本周。
- **产品/工程背景**：VS Code/CLI Agent，历史上支持 modes、tools、MCP 与任务会话；本周没有可验证的上下文、sandbox、权限、记忆、多 Agent或可观测升级。
- **关键数据**：**24,328 stars、3,414 forks、1,036 open issues**（GitHub API，2026-08-24）；贡献者总数未可靠取得。
- **判断**：归档是比“无更新”更强的生命周期信号；评估者不应仅按 stars 继续视其为活跃选型。

---

### 本组洞察

1. **常驻 Agent 的共同原语已成形**：Cursor subscriptions/goal/loop、Cline durable schedule/Hub、Replit Routines、Devin Automations，以及 Claude/Codex 跨 session messaging，正在收敛到“事件源 → 持久目标 → 队列/重试 → 人工 steering/approval → 可恢复 session”。
2. **多 Agent 的难点从生成能力转向状态与故障语义**：独立 VM、subagent tree/dashboard 很显眼，但本周更关键的是 resumable `task_id`、Hub replay/dedupe/drain、permission profile restore、取消全事务回滚、子 Agent 结果内存回收。这些决定系统能否长期运行。
3. **权限和供应链成为主战场**：MCP 企业 allowlist/统一下发、私网 tunnel/CA、skills 从 GitHub 导入、动态 header helper、workspace trust 与 sandbox path hardening同时出现。生态扩展越强，策略层越不能后补。
4. **代码托管边界被 Agent 反向吞并**：Cursor Origin 把 repo/PR/Agent/CI app 合一，是本周最具平台竞争意味的动作。Agent 供应商开始争夺事件源和 source-of-truth 周边，而不满足于 IDE 插件入口。
5. **热度与价值必须分离**：OpenCode/Claude/Codex/Gemini CLI 的 stars 均很高，但并不能证明任务成功率、企业留存或商业收入；闭源厂商也普遍未公开这些数据。本周判断以工程原语与治理能力为主，不用 stars 排价值。

### 候选 TOP 事件

1. **Cursor：Origin Code Hosting + subscriptions/独立 VM subagents/`/goal`**——Agent 厂商进入代码托管与事件执行闭环。
2. **OpenAI Codex 0.148/0.149：`agents` dashboard、queue、Bedrock、MCP hooks 与安全诊断**——CLI 变多任务控制面。
3. **Cline：durable Hub drain/replay/dedupe + Langfuse + 企业 MCP policy**——开源 Agent runtime 的 HA/治理里程碑。
4. **Cognition Devin：企业 MCP 私网与统一分发、Sub-Devin tree、Desktop 多 Agent Command Center**——企业控制面持续加深。
5. **Replit：Conversation→Project→Routine + Free/Power/Max 模式**——产品漏斗与自动化商业化被明确编码进产品。

### 产品 / 工程 / 商业化信号

- **产品**：入口从“聊天框”扩为 PR、Slack、schedule、Conversation、code host；用户交互从 interrupt 转向 steer/queue；skills 变成可固定模式和可共享资产。
- **工程**：事件日志、session 恢复、幂等/去重、权限 profile、sandbox fail-closed、MCP policy、trace identity 和 cost telemetry 成为标配候选。下一阶段应重点比较副作用幂等、跨 session causal trace、策略继承冲突和 VM 成本。
- **商业化**：Cursor 以 paid-plan Origin 扩平台锁定；Replit 把 recurring run 与 Power/Max budget 绑定；Claude 显示数据驻留 1.1× premium；Cline 强调 billed gateway cost；Devin 提供 ACU limit/enterprise deployment。收费单位正从席位转向“常驻执行、算力/预算、治理与私有连接”。

### 覆盖统计与边界

- 固定对象共 **10 个**：Claude Code、OpenAI Codex、Gemini CLI、Cursor、Cognition Devin/Windsurf、OpenCode、Aider、Cline、Roo Code、Replit Agent。
- **有料 8 个；观察/静默 2 个**。
- “本周明显活跃编码 Agent”筛选中，固定对象本身已覆盖窗口内最显著官方发布；未将仅有媒体报道、无官方原文或发布时间无法落入窗口的产品追加为动态对象。


## 开源 Agent 框架与项目

- **本周时间窗（铁律）**：2026-08-17 00:00—2026-08-23 24:00（Asia/Shanghai）。窗口外信息只作“背景”并明确标注，不计入本周动态。
- **核验方法**：固定追踪 14 个项目；逐项检查官方 GitHub 仓库的 releases/tags、提交记录、仓库指标及官方博客/文档。GitHub 数字以 **2026-08-24** 查询为准；star/fork 仅作生态信号，不替代技术价值判断。正文门槛为重大 release、架构变化、安全修复、可解释的显著增长、头部采用、新范式、benchmark 突破或真实工程讨论；不达门槛者进入“静默/观察池”。
- **证据规则**：正文动态均打开并核读官方原文；链接直达官方页面或 GitHub API/仓库。由于 GitHub contributors 为分页近似口径，优先报告 API 可复核的 stars、forks、open issues、更新时间、release 与窗口内 commit 活跃；contributors 仅在可稳定取得时列示。

### 1. OpenClaw — 高频工程演进，窗口内无正式 release（正文）

**本周动态（≥200字）**：窗口内主分支提交量超过 GitHub API 单页上限（至少 100 条），但最近正式 release `v2026.8.1-beta.2` 发布于北京时间 8 月 15 日，不能误写为本周发布。本周真正值得进入正文的是持续的运行时与权限工程：8 月 23 日集中修复大工具参数组装时的流式响应阻塞、Gateway worker 冻结恢复、channel 健康状态在时钟回拨后的误判、插件 binding proof、memory-core 终态回复竞态及 Signal 端口冲突诊断。这不是“又多了几个模型”的浅层更新，而是在高并发、多通道、长工具调用条件下补齐 admission、liveness、reply drain 与状态一致性边界。结合窗口前 beta 已引入的 secret egress host binding、插件来源强制确认、SQLite 快照，可以看出 OpenClaw 正由个人助手框架转向需要明确秘密流向、生命周期治理和可恢复状态的 agent runtime；但这些窗口内改动尚未形成稳定 release，生产采用必须锁定版本并做回归。

- **产品形态**：本地优先的多通道个人/团队 Agent 平台，CLI、Gateway、Control UI、插件与节点运行时一体。
- **工程架构**：多 Agent session、tool calling、插件/skills、Gateway、SQLite memory/session、节点 sandbox、人工审批、MCP 与多通道 ingress；本周重点是流式背压、worker/channel 生命周期、内存终态一致性及插件证明。
- **生态采用**：截至 2026-08-24，GitHub **387,278 stars / 81,325 forks / 6,185 open issues**；量级显示极强关注与二次分发，但 fork/star 无法证明企业生产渗透。窗口内至少 100 commits，工程吞吐异常高，也意味着升级面和回归面同样大。
- **风险限制**：窗口内无稳定发布；高速主干可能使文档、插件 ABI 与安全假设漂移。多通道+任意工具带来提示注入、秘密外泄和权限扩大风险，必须坚持最小权限与目标主机绑定。
- **关键数据与来源（查询 2026-08-24）**：[仓库/API 页面](https://github.com/openclaw/openclaw)、[窗口内 commits](https://github.com/openclaw/openclaw/commits/main/)、[最近 release（背景，8/15）](https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2)。
- **影响判断**：**高（工程趋势），中（本周可交付性）**。它正在把 Agent 的核心竞争点从“会调用工具”推向“秘密、状态和通道生命周期可治理”，但本周不应包装成 release 新闻。

### 2. LangGraph / LangChain Agents — SDK 0.4.3 与子图检测可靠性（正文）

**本周动态（≥200字）**：LangGraph 于 8 月 20 日（北京时间）发布 Python SDK 0.4.3，窗口内核心提交包括 `decrypt replacement result` 支持，以及将子图检测从读取源码改为字节码分析。后者对部署形态很关键：运行在打包产物、动态环境或无法稳定取得 source 的服务端图，不应因源码不可见而漏识别 subgraph；这提升了图结构发现、可视化/追踪和运行时一致性。SDK 的 decrypt replacement result 则指向托管执行中加密/脱敏状态被替换后的结果处理能力。此次并非 LangGraph 主版本架构重写，release notes 还聚合了若干窗口外依赖与历史发布，阅读时必须区分；本周有效事实是 SDK 0.4.3 及 4 条窗口内主分支提交，属于“可靠性和托管 SDK 契约”增强，而非 benchmark 突破。

- **产品形态**：以有状态 graph/workflow 为中心的 Agent 编排库与托管服务 SDK。
- **工程架构**：显式节点/边、checkpoint memory、interrupt/HITL、子图、多 Agent、工具节点、LangSmith tracing；本周增强部署环境中的子图发现和加密替换结果契约。
- **生态采用**：2026-08-24 为 **40,300 stars / 6,793 forks / 223 open issues**；生态优势在 LangChain/LangSmith 组合与持久化后端，而非单纯 star 数。
- **风险限制**：release notes 跨多个包并夹带窗口外变更，容易夸大；图框架仍需开发者自行定义权限、sandbox 和工具副作用补偿。
- **关键数据与来源（查询 2026-08-24）**：[SDK 0.4.3 release](https://github.com/langchain-ai/langgraph/releases/tag/sdk%3D%3D0.4.3)、[子图检测提交记录](https://github.com/langchain-ai/langgraph/commits/main/)、[仓库](https://github.com/langchain-ai/langgraph)。
- **影响判断**：**中**。不是炫目的新能力，但修复了图运行时在真实封装/部署环境中的可发现性问题，对可观测与子图治理更实用。

### 3. CrewAI — 1.15.17：声明式对话 Flow 与 SSRF 防线（正文）

**本周动态（≥200字）**：CrewAI 1.15.17 于北京时间 8 月 20 日发布，把“对话式 flow”从手写运行逻辑推进为声明驱动：声明可以启用 conversational mode，并自动合成内建对话方法；随后窗口内又补上 crew-style LLM 配置兼容与 CLI TUI 打开路径。更重要的是安全与执行语义修复：SSRF 检查被固定到**每次重定向跳和实际 peer IP**，避免只验证初始 URL 后被重定向到内网；失败重试确保关闭 agent scope；工具错误归因到实际失败工具；修复 OpenAI Responses API 的原生 tool calls。这组更新同时覆盖开发体验、MCP server 命名和生产边界，说明 CrewAI 正把 Crew（角色协作）与 Flow（确定性编排）融合成可声明的对话应用层，而不仅是“多个角色聊天”。

- **产品形态**：Python 多 Agent crews + 事件驱动 flows，并配套 AMP 部署/可观测平台。
- **工程架构**：角色/任务多 Agent、Flow 状态机、memory、工具与 MCP、HITL/恢复、tracing；本周突出声明式 conversation、重试 scope、SSRF 与 tool error attribution。
- **生态采用**：2026-08-24 **57,522 stars / 8,221 forks / 319 open issues**，窗口内 22 commits；release 列出 7 名贡献者。价值来自对话入口与可恢复 flow 统一，不能由 star 独立推出。
- **风险限制**：声明式抽象可能隐藏状态迁移与重试副作用；AMP slug/遥测存在平台耦合与数据治理问题；SSRF 修复反向说明远程 MCP/HTTP 工具的网络边界必须持续审计。
- **关键数据与来源（查询 2026-08-24）**：[1.15.17 官方 release](https://github.com/crewAIInc/crewAI/releases/tag/1.15.17)、[窗口内 commits](https://github.com/crewAIInc/crewAI/commits/main/)、[仓库](https://github.com/crewAIInc/crewAI)。
- **影响判断**：**中高**。将可对话入口声明化，降低从多 Agent demo 到交互式应用的胶水代码；SSRF 按 hop/peer 校验则是可直接迁移到其他 Agent 平台的安全范式。

### 4. Dify — Agent v2、统一 tracing 与 RBAC 补洞（正文，未发版）

**本周动态（≥200字）**：Dify 窗口内没有新 release（最近 1.16.1 为 7 月 28 日），但主干至少 100 commits，出现三条值得跟踪的生产信号：其一，新增 provider-neutral unified tracing，试图把不同模型/Agent 后端的调用观测归一；其二，简化 Agent v2 输出契约并修复 workflow refresh render loop，说明 7 月推出的 Linux sandbox 新 Agent 正进入集成硬化期；其三，连续为默认模型、provider models 和 data source integrations 的 GET 端点补上 admin/RBAC 权限检查。这些不是正式可消费 release，但权限修复具有安全意义：只读端点同样可能暴露供应商、数据源和组织配置，不能因 GET 而放松授权。Enterprise Home Snapshot 的 runtime endpoints 与 dify-agent adapter 也显示企业控制面正向 Agent runtime 汇合。

- **产品形态**：低代码 LLM/Agent 应用平台，覆盖 workflow、RAG、插件、发布和企业治理；新 Agent 为 Linux sandbox + Skills。
- **工程架构**：可视化 workflow、知识库/memory、tool calling、sandbox、插件/MCP、HITL、RBAC、tracing；本周重点是跨 provider trace、Agent v2 output contract、企业快照 adapter 和读取权限。
- **生态采用**：2026-08-24 **153,295 stars / 24,218 forks / 1,093 open issues**，窗口内至少 100 commits。高热度与低代码分发能力显著，但 open issues 和高变更率提示维护压力。
- **风险限制**：上述均在主干、未进入 release；Agent beta 官方仍警告只向可信非恶意用户提供。Linux sandbox 并不自动解决网络、秘密、供应链与持久卷隔离。
- **关键数据与来源（查询 2026-08-24）**：[统一 tracing 与 RBAC 提交记录](https://github.com/langgenius/dify/commits/main/)、[RBAC 修复记录](https://github.com/langgenius/dify/commits/main/)、[仓库](https://github.com/langgenius/dify)、[最近 release（背景）](https://github.com/langgenius/dify/releases/tag/1.16.1)。
- **影响判断**：**高（方向），中低（本周可用）**。Dify 正从 workflow builder 变成带 sandbox Agent 的企业平台，而本周权限补洞说明治理成熟度仍在追赶能力扩张。

### 5. LlamaIndex Agents — 0.14.24 修复 AgentWorkflow 输出与 memory 写入（正文）

**本周动态（≥200字）**：LlamaIndex 0.14.24 于 8 月 20 日（北京时间）发布，核心不是单一大功能，而是一组直接影响 Agent/RAG 正确性的修复：AgentWorkflow 现在尊重 `structured_output_fn/output_cls`，流式 chat response 写入 memory 时补齐 response text，多 block 聊天历史不再丢写；IngestionPipeline upsert 保留每个 document 的全部 nodes；工具 schema 不再把 `*args/**kwargs` 错判为必填。窗口内另有 AG-UI 修复，避免前端 tool result 被服务端重复持久化，以及支持多模态用户输入（该提交发生于北京时间 8 月 17 日中午，属于窗口内）。这些变更共同解决“界面有结果、状态却错了”这一 Agent 工程常见问题：输出契约、事件持久化、记忆和索引增量必须一致，否则长会话与重放会产生幽灵状态。

- **产品形态**：数据/RAG 框架及 AgentWorkflow、事件流与 LlamaCloud 生态。
- **工程架构**：workflow、memory、工具调用、structured output、RAG ingestion/property graph、AG-UI、多模态；sandbox/权限并非核心内建强项。
- **生态采用**：2026-08-24 **51,826 stars / 8,009 forks / 936 open issues**，窗口内 7 commits。生态意义在大量数据连接器和 RAG 基础设施，而非多 Agent 编排领先。
- **风险限制**：0.14.24 是修复密集版，说明边缘状态组合复杂；AG-UI 的客户端/服务端持久化责任需应用明确界定。默认模型更新（Gemini 3.7 Flash）可能引入成本与行为漂移。
- **关键数据与来源（查询 2026-08-24）**：[v0.14.24 release 全文](https://github.com/run-llama/llama_index/releases/tag/v0.14.24)、[窗口内 commits](https://github.com/run-llama/llama_index/commits/main/)、[仓库](https://github.com/run-llama/llama_index)。
- **影响判断**：**中高（数据型 Agent）**。本周价值是修正 workflow-output-memory-ingestion 的一致性链条，对生产可靠性比新增一个工具适配器更重要。

### 6. Google ADK — 1.39.0 / 2.7.1 与 Live、HITL、A2A 快速硬化（正文）

**本周动态（≥200字）**：Google ADK 在窗口首日发布 v1.39.0 与 v2.7.1。1.39.0 为 Live session resumption 使用 `RunConfig.session_resumption.handle`，支持实时输入 `audio_stream_end`，并在 Live run 结束时停止后台工具任务；两条版本线都加入 session initialization event 校验，2.7.1 还恢复 OpenTelemetry 版本上限。随后主干保持高频演进：新增 live streaming tool 主动向用户发消息、可配置最大 LLM 调用次数、向 LLM span 记录 context cache、RemoteA2AAgent 鉴权解析和 Cloud Build worker pool 部署；同时“revert A2A guard that broke every HITL tool confirmation”是重要工程教训——跨 Agent 协议的安全 guard 可能破坏人工审批语义，权限加强必须以端到端 HITL 测试验证。

- **产品形态**：Google 面向 Gemini/Vertex AI 的 Agent 开发套件，含 Python SDK、部署与 Live/A2A 能力。
- **工程架构**：Sequential/Parallel/Loop workflow agents、session/state/memory、tools、MCP、A2A、Live 多模态、HITL、OpenTelemetry tracing、Agent Engine 部署。
- **生态采用**：2026-08-24 **21,238 stars / 3,881 forks / 464 open issues**，窗口内至少 100 commits；Google Cloud/Agent Engine 的原生路径是采用优势，但也构成云绑定。
- **风险限制**：v1/v2 双线并行增加兼容负担；高频主干与当周回滚说明 guard、HITL、A2A 组合仍易回归；Live 后台任务需严格取消与资源配额。
- **关键数据与来源（查询 2026-08-24）**：[v1.39.0 release](https://github.com/google/adk-python/releases/tag/v1.39.0)、[v2.7.1 release](https://github.com/google/adk-python/releases/tag/v2.7.1)、[窗口内 commits](https://github.com/google/adk-python/commits/main/)、[仓库](https://github.com/google/adk-python)。
- **影响判断**：**高**。ADK 把 Live 多模态、A2A、Agent Engine 与可观测串成完整栈；而 HITL 回归清楚提示“协议互联”已成为 Agent 安全测试的新主战场。

### 7. OpenAI Agents SDK / Swarm — v0.22.0 默认拒绝失败响应并防护敏感工具输出（正文）

**本周动态（≥200字）**：OpenAI Agents SDK Python v0.22.0 于 8 月 19 日发布，官方明确称其为 runtime hardening。最关键修复是：被 agent output guardrail 拒绝的终态 function-tool 输出，会从可重放和持久化 SDK 状态中清除，避免敏感/违规工具结果虽然没显示给用户，却留在 session 中被后续重放；非流式 Responses 若终态为 `failed/incomplete`，不再被当作普通响应继续；独立 RunState checkpoint 的 usage 计量隔离，同时保留 nested-agent 聚合；生成图可展开 `handoff(agent)` 注册的 agent。窗口内主干还增加空 tool arguments fail-closed、MCP server 去重/清理与 Docker sandbox labels。这里的范式变化是 guardrail 从“输出过滤器”提升为“状态污染防线”。Swarm 已是历史实验，当前落点应以 Agents SDK 为准。

- **产品形态**：轻量 Agent SDK，支持 agents、handoffs、guardrails、sessions、tracing、realtime/voice 和 sandbox 扩展。
- **工程架构**：run loop、tool calling、handoff 多 Agent、RunState/checkpoint、MCP、HITL approvals、Docker/Modal sandbox、guardrails、tracing；本周强化持久状态清洗与失败闭合。
- **生态采用**：2026-08-24 **28,899 stars / 4,567 forks / 227 open issues**，窗口内 59 commits。OpenAI API 原生集成降低采用门槛，但同时强化 provider 绑定；显式 client 与 organization/project 配置契约变严格，升级需改配置。
- **风险限制**：output guardrail 不能替代工具调用前授权；结果生成后再拦截仍可能已产生外部副作用。状态清洗也需覆盖应用自建日志/trace。v0.x 快速演进，API 契约仍可能变化。
- **关键数据与来源（查询 2026-08-24）**：[v0.22.0 release 全文](https://github.com/openai/openai-agents-python/releases/tag/v0.22.0)、[窗口内 commits](https://github.com/openai/openai-agents-python/commits/main/)、[仓库](https://github.com/openai/openai-agents-python)、[Swarm（背景）](https://github.com/openai/swarm)。
- **影响判断**：**高**。把被阻断的工具输出从 replay/persistence 中剔除，是容易被其他 SDK 复用的安全基线；“显示层拦截”不足以保证 Agent 状态安全。

### 8. OpenHands — 一周两版，自动化目录与本地 Agent Server 产品化（正文）

**本周动态（≥200字）**：OpenHands 在北京时间 8 月 18 日发布 v1.14.0、8 月 21 日发布 v1.15.0。一周两版的主线不是新的 SWE benchmark，而是把 coding agent 从单次会话推向可安装自动化与本地部署产品：v1.14.0 增加 Automations Git Sync、LLM 配置预检和结构化错误；v1.15.0 支持从 catalog 安装附带 script bundle 的 automation，加入 local agent-server 的 provider connections UI、统一 commits drawer/会话 overview，并传递 versioned setup 的 provenance。窗口末又加入 Linux desktop installer、Windows bundled Node/npm 修复和 ACP 凭据状态提示。安装脚本 bundle 与自动化目录扩大复用能力，也扩大供应链攻击面，因此 provenance 不能只展示，必须进入签名、权限和审计决策。

- **产品形态**：开源软件开发 Agent，覆盖 Web/Cloud、CLI、桌面、本地 agent-server 与自动化。
- **工程架构**：隔离 runtime/sandbox、repo workspace、LLM provider、skills、automations、Git/commit 视图、ACP、事件 socket；human review 通过会话与提交界面完成。
- **生态采用**：2026-08-24 **84,881 stars / 11,081 forks / 474 open issues**，窗口内 63 commits；桌面与本地 server 降低个人/企业试用门槛，但 star 不是任务成功率。
- **风险限制**：catalog script bundle 可能执行第三方代码；本地 provider credentials、workspace 与 Docker/cloud 边界需隔离。两版快速发布带来升级回归，且本周无公开 benchmark 突破证据。
- **关键数据与来源（查询 2026-08-24）**：[v1.14.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.14.0)、[v1.15.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.15.0)、[窗口内 commits](https://github.com/OpenHands/OpenHands/commits/main/)、[仓库](https://github.com/OpenHands/OpenHands)。
- **影响判断**：**高（coding-agent 产品化）**。自动化可安装、provenance、本地 provider UI 与桌面安装形成分发闭环；下一阶段胜负更依赖执行隔离和自动化供应链治理，而非单轮代码生成。

### 9. AutoGPT — Platform beta v0.7.2 转向“可雇佣专家团队”（正文）

**本周动态（≥200字）**：AutoGPT Platform beta v0.7.2 于北京时间 8 月 21 日发布，产品叙事已明显从经典“自主目标循环”转向持续运营的专家团队：新增 expert memory 隔离与管理员查看、named pods、专家 work surface、真实 workflow bundles、用户 memory 设置、Microsoft Teams bot adapter，以及 device-code OAuth/Stripe Link wallet blocks；同时修复 entitlement 被绕过时 run 仍执行、codex transport 触达无权限用户，并让审批 sheet 处理支付 `requires_action`。这批更新把 memory、预算、身份、支付审批和团队入口放在同一控制面，说明 Agent 平台开始处理“谁能做、花多少、记住什么、通过哪个通道交付”的运营问题，而非只追求 autonomous loop。

- **产品形态**：低代码 Agent/automation 平台与 marketplace，以“experts/teams/pods”包装可持续工作流。
- **工程架构**：block graph/workflow、expert memory 隔离、subgraph credentials、Teams adapter、OAuth、支付 HITL、预算/entitlement、copilot tool chain UI；执行层有 container 化平台。
- **生态采用**：2026-08-24 **186,834 stars / 46,050 forks / 447 open issues**，窗口内 28 commits。历史品牌带来巨大 star 基数，不能当作新版 Platform 的活跃用户证据；真实意义在工作流包、Teams 与支付闭环。
- **风险限制**：beta；支付型工具扩大财务风险，审批与幂等必须端到端验证。专家“灵魂/写作风格”与长期 memory 涉及隐私、删除与跨专家隔离。经典 AutoGPT 名气会掩盖平台已彻底换代的迁移成本。
- **关键数据与来源（查询 2026-08-24）**：[beta v0.7.2 release 全文](https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.7.2)、[窗口内 commits](https://github.com/Significant-Gravitas/AutoGPT/commits/master/)、[仓库](https://github.com/Significant-Gravitas/AutoGPT)。
- **影响判断**：**中高（新范式），中低（成熟度）**。其“专家团队+隔离 memory+预算+支付审批”比传统 autonomous loop 更贴近组织运营，但 beta 与金融动作使治理要求陡增。

### 10. browser-use — 窗口内静默于重大功能，保留观察

- **核验范围**：检查 releases、主分支窗口内 commits、仓库指标与最近版本全文。[仓库](https://github.com/browser-use/browser-use)｜[releases](https://github.com/browser-use/browser-use/releases)｜[commits](https://github.com/browser-use/browser-use/commits/main/)。
- **结果**：最近 0.13.8 发布时间为北京时间 **8 月 17 日 02:48**，早于本周窗口约 21 小时，明确列为背景，不计本周。窗口内仅 9 commits，主要是把 `bu-2-0` 恢复为默认、文件替换报错改善和删除失效 CI workflow，未达到本周正文的重大 release/架构/benchmark 门槛。
- **数据（2026-08-24）**：**110,270 stars / 12,120 forks / 300 open issues**。热度极高，但本周提交内容不能支持“重大突破”。
- **观察理由**：浏览器 Agent 仍是 tool/sandbox/网页注入安全的关键赛道；待下个正式 release 或公开 benchmark/企业采用证据再升正文。

### 11. Microsoft AutoGen — 本周静默

- **核验范围**：[仓库](https://github.com/microsoft/autogen)、[releases](https://github.com/microsoft/autogen/releases)、[commits](https://github.com/microsoft/autogen/commits/main/)。
- **结果**：窗口内 GitHub API 返回 0 commits、无 release；最近 Python v0.7.5 为 2025-09-30，不能用旧闻充数。
- **数据（2026-08-24）**：**60,596 stars / 9,141 forks / 433 open issues**。
- **静默原因判断**：成熟项目可能进入维护/方向迁移期，但仅凭静默不能推断停项；继续观察 Microsoft Agent Framework 迁移线索，AutoGen 本周不入正文。

### 12. Hermes Agent — v0.20.4/v0.20.5：Bot Mode、零密钥 Web 与执行纪律（正文）

**本周动态（≥200字）**：Hermes 在窗口内连发 v0.20.4（8 月 18 日）和 v0.20.5（8 月 19 日）。v0.20.4 官方称自前一版合入约 146 commits/74 PR，重点包括 NVIDIA SkillEvaluator Tier 1 在 skill 安装时进行许可证与安全建议扫描、Bot Mode 多人房间与跨机器路由修复、cron 媒体发送/错过触发提示、SessionDB 事件循环与竞争修复。v0.20.5 再汇总约 746 commits/323 PR，引入 Bot Mode group-room threads、可折叠会话摘要、PDF/文件拖放、5 家供应商轮换与 ring failover 的零密钥 Web、基于 Composio eval 的执行纪律和 runtime stall guards、cron 持久 memory/推理力度，以及 update receipts/fleet `--plan` 验证。这是本周最强的“个人 Agent 变操作系统”信号之一，但异常大的提交/PR 数和 patch rollup 也要求谨慎看待稳定性。

- **产品形态**：自改进、多通道个人 Agent + Desktop/Gateway，强调长期 memory、自生成/改进 skills 与远程持续运行。
- **工程架构**：agent loop、skill procedural memory、FTS5 session recall、subagents、cron、MCP、A2A、Docker/SSH/Modal/Daytona/Vercel sandbox、command approval、多平台 gateway；本周新增 skill advisory scan、stall guard、Bot Mode threads 与 cron persistent memory。
- **生态采用**：GitHub 页面于 2026-08-24 显示 **235,033 stars / 47,359 forks**；v0.20.5 官方报告该 rollup 约 323 PR。数字增长极端，必须与真实留存/生产部署分开验证，不能单凭 star 判定价值。
- **风险限制**：skill 自学习与自动更新会放大供应链/权限漂移；Tier 1 advisory scan 不是强制隔离或签名验证。零密钥供应商轮换涉及数据去向和服务条款；patch 汇总规模过大，回归定位困难。
- **关键数据与来源（查询 2026-08-24）**：[v0.20.5 官方 release 全文](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.8.19)、[v0.20.4](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.8.18)、[仓库/架构说明](https://github.com/NousResearch/hermes-agent)。
- **影响判断**：**高潜力、高风险**。skill 学习、持久 cron memory、Bot 群组和多 sandbox 的组合代表个人 Agent 平台新范式；但超高速 rollup 与自动能力扩张使可审计性成为首要约束。

### 13. MetaGPT — 本周静默，品牌/仓库迁移需注意

- **核验范围**：原地址已重定向到 [FoundationAgents/MetaGPT](https://github.com/FoundationAgents/MetaGPT)；检查主页、[commits](https://github.com/FoundationAgents/MetaGPT/commits/main/) 与 [releases](https://github.com/FoundationAgents/MetaGPT/releases)。
- **结果**：主页最新显著新闻仍是 2025 年 MGX/AFlow，窗口内未发现满足门槛的官方 release 或架构动态；不将旧论文和 Product Hunt 成绩写成本周新闻。
- **数据（2026-08-24）**：GitHub 页面 **69,973 stars / 8,898 forks**。仓库迁移/重定向本身不等于产品增长。
- **静默原因判断**：SOP/“软件公司角色”仍有研究影响，但开源主线本周缺少可验证增量；MGX 商业产品与 OSS 仓库动态应分开追踪。

### 14. SuperAGI — 本周静默，架构叙事陈旧

- **核验范围**：[仓库](https://github.com/TransformerOptimus/SuperAGI)、[commits](https://github.com/TransformerOptimus/SuperAGI/commits/main/)、[releases](https://github.com/TransformerOptimus/SuperAGI/releases)。
- **结果**：官方 README 仍主要描述 autonomous agents、toolkit marketplace、vector DB、telemetry 与 ReAct workflows，窗口内未见达到门槛的新 release/架构变化/benchmark。
- **数据（2026-08-24）**：GitHub 页面 **17,662 stars / 2,230 forks**。
- **静默原因判断**：仍可用作早期 autonomous-agent 平台样本，但面对新一代显式 workflow、sandbox、HITL、MCP/A2A 与权限治理框架，本周无证据显示其追上事实标准演进。

# 开源生态雷达与本组结论

### 增长/高活跃候选

1. **Hermes Agent**：双 patch release、数百 PR rollup，skill 学习、Bot Mode、cron memory 与多 sandbox 汇合；增长信号极强但需防异常热度与稳定性幻觉。
2. **OpenClaw**：窗口内至少 100 commits，运行时、通道生命周期、流式背压和秘密治理持续深化；无本周正式版，属“高活跃主干”。
3. **Google ADK**：双版本线发布并高频推进 Live/A2A/HITL/Agent Engine，云原生完整度快速提高。
4. **OpenHands**：一周两版，把 coding agent 扩展为 automation catalog、本地 agent-server 与桌面分发。
5. **Dify**：至少 100 commits，Agent v2、统一 tracing、企业 adapter 与 RBAC 同步演进，但未发版。

### 静默候选

- **Microsoft AutoGen**：窗口内 0 commit/0 release（核验到仓库与 releases）。
- **MetaGPT**：开源主页主要新闻停留于 2025，仓库迁移后本周无硬动态。
- **SuperAGI**：无本周正式动态，架构说明仍偏早期 autonomous-agent 范式。
- **browser-use**：有少量维护提交，但最近 release 在窗口前，未达正文门槛。

### 事实标准候选（不是已定标准）

- **持久 workflow/checkpoint**：LangGraph 的显式图与 checkpoint 仍是可恢复 Agent 的参考实现。
- **协议互联**：MCP 已横跨 CrewAI、Dify、ADK、OpenAI SDK、Hermes 等；A2A 在 ADK/Hermes 扩张，但 HITL 回归说明规范一致性仍需测试套件。
- **可观测**：OpenTelemetry/统一 tracing 正从可选插件变为生产 Agent 基线；Dify provider-neutral tracing、ADK spans、CrewAI/Phoenix 文档均印证。
- **状态安全**：OpenAI SDK 将 guardrail 拒绝结果从 replay/persistence 清除，以及 OpenClaw 的 secret host binding（背景）共同指向“状态与秘密流向”会成为新的事实标准。
- **sandbox + approval**：仅有容器已不足够；需要网络开关、run-scoped workspace、命令审批、provenance、entitlement 与审计联合成立。

### 热闹但尚不成熟

- **自生成/自改进 skills**：Hermes 等将经验固化为 skill，价值高，但权限累积、供应链、回滚和评估尚缺统一标准。
- **Agent 团队/专家 pods**：AutoGPT 的 experts/pods 和 Hermes Bot Mode 将多 Agent 产品化，但身份、预算、memory 隔离和责任归因仍在早期。
- **零密钥/自动 provider failover**：体验顺滑，却会模糊数据去向、模型差异和合规边界。
- **支付型 Agent**：AutoGPT 将 Stripe Link 与审批纳入 block，商业闭环明确，但财务幂等、欺诈、授权撤销与争议处理尚需真实生产证据。

### TOP 候选（供总报告筛选）

1. **OpenAI Agents SDK v0.22.0：guardrail 拒绝的工具输出从可重放/持久状态中清除**——最具可迁移性的安全基线。
2. **Google ADK 1.39.0/2.7.1：Live session 恢复、任务取消与 A2A/HITL 快速硬化**——协议+实时 Agent 的工程前沿。
3. **Hermes v0.20.4/0.20.5：skill 扫描、Bot Mode、cron persistent memory、stall guards**——最强新范式，同时风险最高。
4. **OpenHands 1.14/1.15：可安装 automation bundle + provenance + 本地 agent-server UI**——coding agent 从会话走向分发平台。
5. **CrewAI 1.15.17：声明式对话 Flow + redirect-hop/peer-IP SSRF 校验**——应用抽象与安全工程兼具。
6. **AutoGPT beta 0.7.2：专家 memory 隔离、pods、预算/支付审批**——组织运营型 Agent 的代表，但 beta 成熟度有限。

### 本组洞察

1. **本周主线不是模型能力，而是“状态能否被信任”**：LlamaIndex 修复 output-memory-ingestion 一致性，OpenAI 清除被 guardrail 阻断的持久状态，OpenClaw 修复终态竞态，ADK 校验 session initialization。Agent 的失败越来越像分布式系统，而非 prompt 问题。
2. **HITL 已进入协议层测试**：ADK 的 A2A guard 一度破坏所有工具确认，说明人工审批不能只是 UI 按钮，必须作为跨 Agent/工具协议中的可验证语义。
3. **sandbox 正从“有没有”升级为“边界可证明吗”**：网络、redirect peer、运行目录、skill provenance、entitlement、秘密目标绑定缺一不可。CrewAI 的 SSRF 修复和 OpenHands automation bundle 是同一问题的两面。
4. **多 Agent 从角色扮演转向组织控制面**：AutoGPT pods/experts、Hermes Bot Mode、CrewAI declarative conversational flows 都在处理身份、memory、预算、交付通道和恢复；MetaGPT/SuperAGI 的早期角色叙事若不补治理会继续边缘化。
5. **高提交量是风险信号，不是价值证明**：OpenClaw/Dify/ADK/Hermes 均出现 API 单页上限或巨量 rollup；生产团队应追 release、契约与回归证据，而不是追 main 或 star 曲线。

---

#### 核验完整性说明

固定追踪 14/14 已逐一核验：OpenClaw、LangGraph/LangChain Agents、Microsoft AutoGen、CrewAI、Dify、LlamaIndex Agents、Google ADK、OpenAI Agents SDK/Swarm、browser-use、OpenHands、AutoGPT、MetaGPT、SuperAGI、Hermes Agent。正文 10 个（其中 OpenClaw/Dify 为主干重大工程动态，明确未发版），静默/观察 4 个；MetaGPT 重定向至 FoundationAgents 后按新地址复核。所有计数均注明 2026-08-24 查询日期；GitHub API 达到匿名 rate limit 后，对后三个仓库改用官方 GitHub 页面内嵌仓库元数据与 release 页面交叉核验，未虚构 contributors 数。


## 浏览器 / Computer Use / 通用自主 Agent

- **研究时间窗**：2026-08-17 00:00—2026-08-23 24:00（Asia/Shanghai）
- **覆盖对象**：OpenAI Operator / ChatGPT Agent、Anthropic Computer Use、Google Project Mariner、Perplexity Comet、Manus、Genspark / 通用任务 Agent、Kimi Agent、Qwen Agent、AutoGLM 等中国通用 Agent。
- **核验方法**：逐项检索时间窗内官方博客、产品更新日志、帮助中心、开发者文档、官方社交账号及可定位日期的 benchmark 原文；搜索结果摘要只用于发现线索，结论以打开并通读的原文为准。对“无重大动态”对象，同样记录核验页面、范围和判定原因；时间窗外材料仅作背景并明确标注。
- **证据口径**：关键数字优先采用官方一手来源并标注发布日期；可获得时以第二独立来源交叉核验。产品常驻文档若无本周更新时间，不作为“本周动态”。

### 1. OpenAI Operator / ChatGPT Agent：从个人“代办”转向组织级常驻 Agent（本周重大动态）

**本周动态（官方原文通读）**：OpenAI 在本周发布 [Introducing workspace agents in ChatGPT](https://openai.com/index/introducing-workspace-agents-in-chatgpt/)，把 ChatGPT 内的 Agent 产品边界从一次性个人任务扩展为可共享、可定时、可长期运行的组织工作流。它并非 Operator 品牌的一次浏览器 UI 更新，而是 Operator/ChatGPT Agent 路线的企业化上层：团队可从侧栏用自然语言定义流程、连接工具、加入 skills 并测试；Agent 在云端持续执行，可进入 ChatGPT 与 Slack，覆盖报告、代码、消息回复、CRM 更新、IT 工单、月结等。研究预览面向 Business、Enterprise、Edu、Teachers；官方同时明确 GPTs 暂时保留，后续支持转换。商业化已进入 credit 计价逻辑（页面称预览期免费、随后启用 credits；具体展示日期与发布时点存在页面文案不一致，故不据此推断当前收费状态）。

- **产品形态**：共享的 workspace agent、模板/可视化搭建器、ChatGPT/Slack 双入口、计划任务与后台运行；本质是“组织内可复用的工作单元”，不是单一浏览器代操作模式。
- **工程架构**：官方写明由 Codex 云端执行，拥有文件、代码、工具和 memory 工作区；可运行代码、调用 connected apps、跨步骤保持状态。配套本周技术文 [Codex as a platform: build on the open agent harness](https://developers.openai.com/blog/codex-as-a-platform) 公开了更底层结构：Codex harness 管理 conversation state、streaming、工具调用、失败恢复、sandbox 与 approval policy；app-server 暴露 thread/turn/event/approval 协议；业务应用保留上下文、规则、MCP 数据/动作及最终记录的所有权。Relay 样例要求“重新订舱”等后果性写操作先经人工批准，展示了 HITL 的参考落点。
- **权限、登录、支付与隐私**：创建者可按动作要求确认，例如编辑表格、发邮件、添加日历事件；Enterprise/Edu 管理员可按用户组控制连接器与动作、限制创建/分享权限，并通过 Compliance API 查看 Agent 配置、更新与每次运行，必要时暂停。官方称对外部误导内容/提示注入有内置防护，但未公开针对网页登录、支付、凭据接管的独立成功率，本周也没有证明其能无人监管完成消费支付的 benchmark。
- **可靠性与可观测性**：共享后可看完成运行数和用户数；路线图还包括更完整 performance dashboard。官方客户 Rippling 称原来销售每周 **5–6 小时**的账户研究、Gong 摘要与 Slack 简报可后台自动跑；这是客户引述而非受控评测。底层技术文给出 ARC-AGI-3 harness 实验：保留推理与上下文压缩使 GPT-5.6 Sol 从 **13.3% 提升至 38.3%**，输出 token 降至约六分之一；它说明 harness 对长程可靠性的重要性，但不是 GUI/browser 任务完成率。
- **生态采用**：官方列举内部销售、产品、会计团队；对外已以 Slack、连接器、MCP、Compliance API 构成企业生态，并引用 GitHub/JetBrains、Cisco、税务工作流等 Codex harness 采用案例。税务 pilot 的 **7,000 份申报、准备时间约降三分之一**属于此前案例背景，不能算本周新增实测。
- **风险限制**：研究预览意味着稳定性与行为边界仍在形成；memory、跨工具写入与常驻触发扩大数据泄漏、错误写操作及提示注入的影响半径。现有批准粒度由创建者/管理员配置，若配置过宽，治理能力本身不会自动避免业务错误；官方也未披露本周端到端任务失败率、支付安全指标或登录挑战处理率。
- **影响判断**：本周最强信号不是“浏览器点得更准”，而是 OpenAI 将 Agent 商业化单元从聊天席位推进到**可计量运行的组织工作流**，并把 harness 开放为可嵌入层。竞争重点因此转向权限模型、运行审计、持续改进与跨应用分发。

### 2. Anthropic Computer Use：合规边界被进一步显式化（本周有料，但非能力首发）

**本周动态（官方页面核验）**：本周可定位到 Anthropic 更新后的商业客户 BAA 说明 [Business Associate Agreements (BAA) for Commercial Customers](https://privacy.claude.com/en/articles/8114513-business-associate-agreements-baa-for-commercial-customers)，其中首次在当前产品矩阵中明确列出 **Claude Code Computer Use [beta]**：可在无 ZDR 情况下使用，但不受 Anthropic BAA 覆盖，且与 ZDR 不兼容；Claude Platform API 的 Computer Use [beta] 对 HIPAA-ready API 组织同样不在 BAA 覆盖范围且不可访问。此动态不代表本周发布新 computer-use 模型，却是生产采用的重要“负向产品信号”：涉及 PHI/医疗合规的浏览器或 OS 自动化不能把模型能力等同于合规可部署性。

- **产品形态**：Computer Use 仍是模型驱动的 browser/desktop 操作能力，并已出现在 Claude Code 的 beta 功能矩阵；Claude in Chrome、Cowork、远程 Claude Code 等构成相邻执行面。本周 [Claude Sonnet 产品页](https://www.anthropic.com/claude/sonnet) 继续将 browser/computer use 列为采购、客户 onboarding、竞争分析等场景，但 Sonnet 5 发布于 6 月 30 日，属于背景而非本周新发布。
- **工程架构**：官方产品页强调 Sonnet 5 的长程 instruction following、tool selection、error correction 与 1M context，适合作为 agent backbone；Computer Use 通过视觉/界面动作控制既有软件，而工具/API、MCP/连接器用于结构化调用。Anthropic 本周没有公开新的 OS 控制协议、sandbox 实现或独立 GUI benchmark，因此不能把营销中的“reliably”量化为任务完成率。
- **权限、登录、隐私与 HITL**：BAA 页面给出了清晰的数据边界：Claude in Chrome/MCP 向第三方发送数据不受 Anthropic BAA 覆盖；Computer Use beta 与 ZDR 不兼容；文件创建和代码执行即使在 Enterprise BAA 下，覆盖也排除网络访问和外部网站。由此，登录态、网页内容、屏幕可见 PHI 及第三方传输必须由部署方额外隔离和审批。页面没有给出支付确认或高风险写动作的统一 HITL 保证，企业不能假设模型层默认提供业务级授权控制。
- **生态采用与商业化**：Sonnet 5 可通过 Claude Platform、AWS、Google Cloud、Microsoft Foundry 使用，官方价 **$2/百万输入 token、$10/百万输出 token**（发布背景，非本周调价），缓存最高节省 90%、batch 50%。官方客户 Pace 称其 computer-use agents 运行保险 submission intake、FNOL、loss runs；这是厂商页面客户证言，未给样本数和完成率。
- **风险限制**：最大新增可操作信息是“能力可用 ≠ BAA/ZDR 可用”。在医疗、保险等高敏行业，浏览器画面、第三方站点及远程执行路径可能落在合规承诺之外。另无本周独立基准、失败重试率、人工接管率或 prompt-injection 红队数字，故不作性能跃升结论。
- **关键数据与影响判断**：本周没有新的 Computer Use 任务完成率数字。合规矩阵本身将产品成熟度分层：结构化 Messages API 的 memory/web search/bash/text editor 可纳入特定 BAA，而 GUI Computer Use 仍被隔离在外。对采购方的现实影响是，应优先采用“结构化工具 + 最小权限”，仅在无 API 的遗留系统启用 computer use，并把屏幕数据分级、人工确认和完整审计放在模型之外实现。

### 3. Kimi Agent：Kimi Work 将浏览器登录态、本地 OS 与 300-Agent 编排合并（本周重大动态）

**本周动态**：Kimi 本周发布/更新了完整产品说明 [Kimi Work: The Ultimate Desktop AI Agent for Knowledge Work](https://www.kimi.ai/resources/kimi-work-introduction) 与配套 [Local AI Agent for Automated Workflows](https://www.kimi.ai/resources/local-ai-agent)。Kimi Work 是 Windows/macOS 原生桌面 Agent：读取和写入本地文件、运行 Python/shell、通过 WebBridge 操作已登录浏览器、执行定时任务，并用 Goal Mode 跨多轮持续推进目标。官方最醒目的容量数字是单指令可调度**最多 300 个 Agent**并行拆解任务，输出 Word、Excel、PPT、PDF、网站或代码；但官方没有公开 300 并发下的质量、时延、成本及任务成功率，因此应视为调度上限而非效果 benchmark。

- **产品形态与实际可用性**：桌面 Work mode 可绑定本地目录，也可无目录运行；Goal Mode 保存 persistent goal state，每轮判定 complete/blocked/paused/continue；Schedule 支持 once/daily/weekly/monthly。覆盖研究、投研、开发、咨询与办公交付，相比网页版从“云端研究与生成”扩展到真正改文件和跑命令。
- **工程架构**：融合 Kimi Web 的长文/推理、Kimi WebBridge 浏览器自动化和 Kimi Code 文件/命令执行；多 Agent 拆分—并行执行—汇总—验证—反馈形成循环。插件由多个 MCP 通过 skills 组合，可经 OAuth/开放平台接入第三方；本地代码/文件处理宣称留在设备上，但模型仍为云端驱动，不能据“local agent”字样推断完全离线。
- **权限、登录、隐私与 HITL**：WebBridge 直接复用现有浏览器 session，可点击、填表、下载，减少重复登录；这也使 cookie、账户权限和页面敏感数据进入高风险面。启动任务可选 **Full access** 或 **Ask permission**：后者在敏感权限步骤暂停，前者允许端到端不中断。插件 OAuth 明确要求用户拥有或获授权的第三方账户。官方未披露支付步骤的强制二次确认、凭据隔离、提示注入防护或审计日志保留策略，金融/电商操作不宜开启 Full access。
- **可靠性与人机协作**：计划和执行进度可见，用户可中途干预；官方建议目标包含结果、验收证据、范围/预算约束及失败策略，工程任务用 clean build/test suite 作为验收。这是比“自主到底”更务实的可验证 Agent 设计，但本周无 GA 稳定性承诺、端到端成功率、人工接管率或独立 benchmark。
- **生态与商业化**：插件市场、MCP、OAuth、专业金融/学术数据构成差异化数据生态，浏览器登录态又可连接长尾网页系统。官方页面未提供本周价格、付费转化或企业席位数字；“专业数据库无需单独订阅”的价值主张可能构成订阅绑定，但具体数据授权范围仍需采购核验。
- **影响判断**：这是本周中国通用 Agent 中最直接的 OS/browser 产品推进：把云端 Agent 落到本机控制面，并提供明确权限档位和可验证 Goal loop。优势是交付闭环，最大风险同样来自本地 shell、文件写入与已登录浏览器三种高权限汇聚；企业部署需要目录白名单、浏览器独立 profile、关键写动作强制审批和可回滚版本控制。

### 4. Qwen Agent / Qwen Code：Subagents 引入 fork、工具收窄和续跑（本周重大工程动态）

**本周动态**：Qwen Code 本周更新的官方文档 [Subagents](https://qwenlm.github.io/qwen-code-docs/en/users/features/sub-agents/) 给出一套相当完整的多 Agent runtime：named subagent 使用独立上下文与任务专属 prompt/tools；fork subagent 继承父会话完整上下文或最近 N 个真实用户回合，在后台 detached 执行。它不是面向普通消费者的浏览器代办，但对通用 Agent 工程架构、权限与可观测性具有较强参考价值。

- **产品形态**：开源终端 coding agent 内的可配置 specialist/fork；项目级、用户级、extension 级 Markdown 配置；支持交互和 headless。后台任务完成后通知主会话，可用 `list_agents` 查看状态、用 `send_message` 续跑已暂停/完成 Agent，恢复 session 时可重建兼容 roster。
- **上下文、记忆与并发**：fork 默认继承父上下文，可用 `fork_turns` 限定最近回合；多个 fork 共享父请求前缀以命中 DashScope prompt cache，官方称 3 个并行 fork 相比独立 subagent 可节省 **80%+ token 成本**。这是架构估算而非任务准确率。递归委派在 runtime 被禁止，限制失控的 Agent 树。
- **权限与 sandbox**：`fork_tools`/`fork_profile` 可逐次缩窄内置与 MCP 工具；未列工具会在调度/审批前拒绝。文档明确警告：这是 caller-selected restriction，调用者可省略或扩大，**不是管理员强制安全沙箱**。Named agent 支持 default/plan/auto-edit/yolo/bubble；bubble 将后台审批浮回父会话。一个值得警惕的继承规则是 permissive parent 优先，例如父会话 yolo 时子 Agent 的 plan 仍可能以 yolo 运行。
- **可靠性与可观测性**：实时显示进度、工具调用和执行统计；后台结果有 completion notification，失败/需要用户输入时 fork 返回 blocker（fork 禁止直接 ask user）。当前明确限制是 fork 共享父 working directory、无 worktree isolation，并发写文件可能冲突；named agent 可绑定现有 git worktree，但 fork 不可。故多 Agent 并行应以读任务优先，写任务必须分工作树或串行合并。
- **browser/OS、登录支付与商业化**：核心控制面是终端文件、shell 和 MCP，不是视觉浏览器；登录/支付能力取决于接入工具，本周没有官方支付流程 benchmark。多模型 selector 与 provider 路由、缓存节省是商业化/成本信号，但无本周用户或收入数据。
- **影响判断**：Qwen Code 把“多 Agent”从营销概念落到了上下文继承、权限收窄、缓存复用、后台续跑和冲突限制等工程细节。其诚实标注“非安全沙箱”和共享工作区冲突尤其重要；下一步若补齐强制策略层与 worktree 隔离，将更接近企业可治理 runtime。

### 5. Genspark / 通用任务 Agent：以开源 Office 执行面与 Git 化记忆补齐可控性（本周重大动态）

**本周动态**：Genspark 本周公开 [GenOffice](https://github.com/genspark-ai/genoffice)，定位为 Apache-2.0 的跨平台 AI Office 套件，把 Agent 从网页聊天/通用任务入口嵌入 DOCX、XLSX、PPTX、PDF、Markdown 的原生编辑状态；同时 [SB-Git early access](https://www.genspark.ai/sb-git/intro) 提供 Agent 可读写、用户可 clone、浏览器可审计的真实 Git 版本库，作为跨 session/跨 Agent 记忆。二者合起来形成“可执行办公状态 + 可版本化长期记忆”，比单纯增加模型更值得关注。

- **产品与架构**：GenOffice 是六个 Electron app 共用 engine 层；`agent-core` 提供 loop/skill composition，`ai-provider` 抽象模型与流式输出，`ai-search` 接 web/image 等工具。文档 Agent 采用 block-level edits、snapshot/diff；Office 文件尽量窄 patch，DOCX 未触碰段落保留原始字节。PDF 打开、编辑、转 Office 在本机完成；AI 工具需联网，可 Genspark 登录或 BYOK 连接 Claude/OpenAI/Gemini/Kimi/GLM/Qwen 等。
- **记忆与可观测性**：SB-Git 基于标准 Git Smart HTTP/refs，一个 token 打通 git、REST、CLI；Agent 可 clone 后 commit，也可用 CLI 单 HTTP 调用 ls/cat/commit/log/diff。不同 VM/Agent 与人类在同一 repo 协作，提交历史可 diff、rollback 和浏览器检查，直接改善“聊天记录不可审计”和静默覆盖。
- **权限、隐私与可靠性**：本地文档不会为打开/保存而上传；官方 packaged build 默认发送有限使用 analytics，可关闭，并称不发送文档内容、文件名、路径、身份或邮箱。Agent 生成内容仍可能经配置的模型端点处理，BYOK/本地 endpoint 才能进一步收窄数据路径。SB-Git 用同一 API key 覆盖多表面降低配置摩擦，但 token 泄漏影响半径也更大，应实施短期凭据、仓库级授权与 secret scanning。Office 的 snapshot/diff、Git 回滚提升人机复核，但官方未给格式保真成功率、复杂文档 round-trip 错误率或 Agent 完成率。
- **生态与采用**：跨 Windows/macOS/Linux，兼容真实 Office 格式，开放 provider 和 OpenAI-compatible endpoint；这使 Genspark 从封闭 Super Agent 向可被开发者嵌入/分叉的执行生态延伸。套件免费开源，`ee/` 为未来 enterprise modules 预留专有许可，是明确的开源获客—企业商业化信号。
- **browser/OS、支付与限制**：本周重点不是浏览器视觉控制，而是文档应用内部结构化工具调用；登录通过 device-code 或自有 key。未见支付/采购执行能力与强制 HITL 说明。Electron 攻击面、AI 生成文档中的外链/公式/宏类内容、跨模型数据发送仍需威胁建模；Git 记忆是可追溯存储，不会自动判断“记忆是否正确”。
- **影响判断**：Genspark 给出的可借鉴路径是让 Agent 在可 diff、可回滚、结构化的应用状态中工作，而不是依赖脆弱像素点击。GenOffice + SB-Git 同时改善执行精度与审计，可能成为企业接受 Agent 的关键基础设施；但缺乏公开 benchmark，成熟度仍应按 early access/开源快速迭代看待。

### 6. Google Project Mariner：本周无重大动态

- **核验范围**：检索 8 月 17–23 日 Google Blog、Google DeepMind 官方站与开发者更新中 “Project Mariner / Gemini Agent / browser agent” 条目，并复核 [Project Mariner 官方介绍](https://deepmind.google/models/project-mariner/) 与 Google I/O 既有材料。
- **判定原因**：未发现本时间窗内带日期的官方发布、能力升级、开放地区/价格调整、browser benchmark、权限/支付策略或用户规模数据。搜索结果仍主要指向此前发布的浏览器研究原型及 Gemini API/Agent Mode 背景，不能重包装为本周新闻。
- **持续观察点**：多任务并行浏览器 VM、Teach and Repeat、用户确认高风险动作，以及与 Gemini/Chrome 的产品合并路径；在出现官方更新前，不对任务完成率和商业可用性作新增判断。

### 7. Perplexity Comet：本周无重大动态

- **核验范围**：检索 Perplexity 官方博客、Help Center、Comet 产品/下载页及官方发布线索，关键词覆盖 Comet、browser、assistant、shopping/payment、privacy、enterprise，限定本自然周。
- **核验页面**：[Perplexity Help Center](https://www.perplexity.ai/help-center/) 与 [Comet 产品页](https://www.perplexity.ai/comet)。本周 Help Center 搜索命中多为常驻订阅/推广页面的更新时间，并非 Comet 新能力公告。
- **判定原因**：没有找到本周官方、可明确定位日期的 Comet 功能上线、任务完成率、支付/登录安全策略变化、企业可用性或价格变更。搜索摘要出现的合作推广与推荐计划信息不足以证明浏览器 Agent 发生产品变化，故不写“有动态”。

### 8. Manus：本周无重大动态

- **核验范围**：检索 Manus 官方站、官方社交发布、帮助/更新页及开发者资料，覆盖 browser、computer、connector、Wide Research、payment、privacy、pricing 等词，并交叉查看应用商店近期条目。
- **核验页面**：[Manus 官方站](https://manus.im/) 与 [Manus Help Center](https://help.manus.im/)。
- **判定原因**：本周检索结果主要是第三方评测、软件下载聚合或旧功能介绍；未发现官方带日期的重大更新、benchmark 原文、权限确认/支付机制变化、商业化数字。无法由应用商店“最近更新”或第三方文章推断 Agent 核心能力升级。

### 9. AutoGLM 等中国通用手机/OS Agent：本周无重大动态

- **核验范围**：检索智谱 AI/智谱开放平台、AutoGLM 官方产品与 GitHub、应用商店发布信息，关键词覆盖 AutoGLM、GLM-Phone、Phone Use、手机 Agent、browser、隐私与支付，并扩展核验国内通用 Agent 官方渠道。
- **核验页面**：[AutoGLM GitHub](https://github.com/THUDM/AutoGLM)（如页面仍指向既有开源版本）、[智谱 AI](https://www.zhipuai.cn/) 与官方产品入口。
- **判定原因**：本周搜索结果以第三方视频、产品盘点、应用商店相似推荐及旧开源项目为主，没有找到时间窗内官方发布的手机/浏览器任务完成率、模型/执行框架新版本、支付确认流程、隐私政策或商业化数据。因此 AutoGLM 本周列入“持续跟踪、无可证实重大动态”，不把旧的截图—点击能力当新消息。

### Agent 产品雷达与组内结论

#### 雷达候选

| 候选 | 本周信号 | 产品成熟度 | 核心观察指标 |
|---|---|---:|---|
| OpenAI Workspace Agents | 企业共享、后台/定时、Slack、审批、Compliance API、credits | 研究预览 | 每工作流成本、运行成功率、审批率、提示注入事件、活跃组织数 |
| Kimi Work | 本地文件+shell+登录态浏览器+Goal loop，最多300 Agent | 可下载产品/快速迭代 | WebBridge 成功率、敏感动作确认覆盖、并发质量、设备端/云端数据边界 |
| Qwen Code Subagents | fork 上下文、工具收窄、缓存、续跑、可观测 | 开源工程能力较完整 | worktree 隔离、管理员强制策略、冲突率、80%+缓存节省复现 |
| Genspark GenOffice + SB-Git | 结构化 Office Agent、diff/rollback、版本化记忆 | 开源 + early access | 格式保真、Agent 编辑接受率、仓库权限、企业模块定价 |
| Anthropic Computer Use | 合规矩阵明确其 BAA/ZDR 限制 | beta 能力强、合规受限 | BAA/ZDR 路线、Computer Use 独立成功率、接管率、第三方数据流 |

#### TOP 候选

1. **产品 TOP：OpenAI Workspace Agents**——最完整地把创建、共享、分发、调度、审批、审计和计费串成组织级产品闭环。
2. **工程 TOP：Kimi Work**——本周最强 browser/OS 执行信号，尤其是登录态浏览器、本地 shell/文件与持久目标循环的结合；高权限风险也最高。
3. **基础设施 TOP：Qwen Code Subagents / Genspark SB-Git（并列）**——前者把多 Agent runtime 的上下文和权限说清，后者用标准 Git 解决记忆可追溯与回滚。

#### 产品、工程与商业化信号

- **产品信号**：Agent 正从“一次对话代办”变成可共享、可定时、可持续改进的工作流对象；入口从浏览器扩散到 Slack、桌面、Office 和终端。
- **工程信号**：可靠性越来越由 harness 决定：上下文压缩、fork/cache、目标状态机、结构化工具、sandbox/审批、diff/rollback 和运行可观测性，比单一模型分数更关键。
- **权限信号**：行业开始提供明确档位（Ask permission/Full access、plan/auto-edit/yolo、动作级审批），但调用者可选的 allowlist 不等于管理员强制沙箱。已登录浏览器、shell、本地文件三权合一必须默认最小权限。
- **隐私信号**：Anthropic 的 BAA/ZDR 排除项说明 GUI Agent 仍是合规薄弱环节；“本地执行”也不等于模型推理和插件数据完全本地，应画清每次数据出境与第三方流向。
- **商业化信号**：OpenAI 从席位走向 credits/运行计量；Anthropic以 token+云渠道扩散；Genspark 采用开源核心并预留 enterprise；Kimi 以专业数据、插件和桌面执行形成付费价值。未来比较应采用“成功完成一次经审核业务结果的总成本”，而非 token 单价。
- **本周证据缺口**：除 harness 类实验外，主流厂商普遍没有发布统一 browser/OS 端到端任务完成率、登录挑战通过率、支付误操作率、人工接管率与真实生产失败分布。任何“已可完全自主”的判断均超出证据。


## 企业 / 垂直 Agent、协议与评测

- **时间窗**：2026-08-17 00:00—2026-08-23 24:00（Asia/Shanghai）
- **研究口径**：只有官方原文标注发布时间/版本发布时间落在窗口内，才计入“本周动态”；窗口外材料仅作背景。逐项检索官方 newsroom/blog/docs、协议规范、论文/benchmark 官网及 GitHub releases/commits；关键数字以原始页面为准，不从搜索摘要推断。
- **核验时间**：2026-08-24（Asia/Shanghai）

### 一、企业 Agent 平台（固定追踪）

#### 1. Sierra
**本周动态：未发现可计入事件。** 核验了 Sierra 官方站点的 company/news、research、客户案例入口，并以 2026-08-17 至 08-23 的逐日日期组合做站内域名检索；检索唯一明显的 2026 内容是语音 Agent benchmark PDF，但搜索结果不能证明其发布时间落在本窗口，因此不把它写成本周发布。Sierra 产品形态仍是面向客户服务的数字 Agent；工程关注全双工语音、多轮任务执行和业务系统连接。由于本周没有经官方日期确认的更新，计费、身份权限、审计归因、客户 ROI 均无新增可核数据。**风险限制**：官网动态页面的搜索索引并不等于完整发布日志，且 PDF 年份不等于发布日期。**影响判断**：保持观察，不应制造“本周发布”叙事。

- 核验入口：[Sierra 官网](https://sierra.ai/)、[Sierra Research](https://sierra.ai/research)

#### 2. Glean
**本周动态：未发现可计入事件。** 核验 Glean 官方 Work AI Blog、产品/客户内容，并按日期与 Agent 关键词检索。官方检索可见的相邻材料包括 8 月 7 日发布的 Glean:GO 2026 预告，以及 8 月 3 日的澳大利亚 Work AI Index，均早于本窗口，只能作为背景。产品形态是企业搜索、知识助手与 Agent 构建/治理平台；工程架构以企业知识图谱、连接器、权限继承和跨应用检索为底座。生态采用与治理侧，本周没有新的客户、计费、权限、审计或 ROI 官方披露。**风险限制**：活动预告谈到“衡量 AI impact、治理风险和成本”，但预告不能替代发布或实测数据。**影响判断**：8 月 26—27 日大会可能成为下一窗口的高密度观察点，本周不提前归因。

- 原文：[5 reasons to attend Glean:GO 2026（2026-08-07，背景）](https://www.glean.com/blog/glean-go-2026-reasons-to-attend)、[Work AI Blog](https://www.glean.com/blog)

#### 3. Harvey
**本周动态：未发现可计入事件。** 核验 Harvey 官网 news、客户故事与产品入口，并以完整日期窗做域名检索，未找到 8 月 17—23 日发布且由 Harvey 官方页面给出日期的公告。本周因此没有可核验的新客户、行业落地、计费、权限、审计或 ROI 数据。产品形态仍是法律专业工作平台，核心场景包括研究、起草、文档分析和工作流；此处仅作持续追踪背景，不将一般产品描述冒充本周更新。**工程架构/生态采用**：缺少窗口内官方原文，不作推断。**风险限制**：法律 Agent 的来源可追溯、客户隔离、保密义务和人工复核仍是审查重点，但本周没有新增证据。**影响判断**：静默周，维持高优先级监测。

- 核验入口：[Harvey 官网](https://www.harvey.ai/)、[Harvey News](https://www.harvey.ai/news)

#### 4. ServiceNow AI Agents
**本周动态：未发现可计入事件。** 核验 ServiceNow 官方 Press Room、AI Agents 产品入口与站内日期检索，没有发现 2026-08-17 至 08-23 发布的 AI Agent 官方公告。产品形态是嵌入 Now Platform 工作流的自治 Agent；工程上依赖企业记录、流程编排、连接器和平台治理。窗口内没有新计费、客户 ROI、身份/权限或审计归因数字。**生态采用**：搜索结果混入旧新闻页面的全站导航文案，不能把导航中的“AI Agents”误判为旧文章的 Agent 新闻。**风险限制**：搜索引擎日期与旧页面模板污染严重，故只认官方正文日期。**影响判断**：本周无新增信号。

- 核验入口：[ServiceNow Press Room](https://www.servicenow.com/company/media/press-room.html)、[ServiceNow AI Agents](https://www.servicenow.com/products/ai-agents.html)

#### 5. Salesforce Agentforce
**本周动态：未发现窗口内发布；但相邻背景值得记录。** 官方 News 检索中最近的高信息量材料是 2026-08-07 的 Agentic Enterprise Index，早于窗口。该报告分析 2025-02 至 2026-04 连续每月启用生产 Agent 的企业队列：每组织激活 Agent 数接近 3 倍、创建至使用平均 2 天，Agentic Work Unit 输出截至 2026-04 以 15% 月复合增长；零售中有 Agent 的同比销售增长 8%，无 Agent 为 2%（4 倍增长率差异）；人工升级率维持 32%。**产品形态/架构**：报告强调 headless 架构与跨云动作，把“动作调用/输出 token”作为从生成转执行的代理指标。**生态采用**：Pandora 的 Gemma 在峰值处理 60% 常规请求并使 NPS +10%；PenFed 在登录后执行余额、贷款状态与转账。**限制**：这是 Salesforce 自有平台聚合队列，不代表全市场，也不证明因果；发布日期不在本周。**影响判断**：AWU 是商业化与 ROI 度量的有力候选，但需独立客户数据校验。

- 原文：[Salesforce Agentic Enterprise Index 2025–2026（2026-08-07，背景）](https://www.salesforce.com/news/stories/agentic-enterprise-index-insights-2026/)

#### 6. Microsoft Copilot Agents
**本周动态（2026-08-20）：Dragon Copilot Physician apps and agents 上架 Microsoft Marketplace 专用 offer type。** 美国医疗软件伙伴可以把定制 AI 应用/Agent 嵌入医生使用 Dragon Copilot 的工作流，并复用 Marketplace 的发现、采购、履约与部署。产品形态从封闭的临床 Copilot 转向可扩展行业 Agent 分发平台；商业化价值在于新的应用/Agent 报价类型和统一交易通路，但官方未披露抽成、席位价或按量费率。**工程架构**：强调标准化嵌入和在临床文档、查询、自动化界面内呈现；可覆盖临床洞察、收入周期、事前授权、文档增强与临床决策支持。**身份权限/审计**：该公告未给出最小权限、患者数据审计或责任归因细节，是医疗落地的主要缺口。**生态采用**：当前仅美国可用。**影响判断**：比模型升级更重要的是形成“行业 Agent 商店+既有采购”的分发闭环，但治理证据尚不足。

同一周 Microsoft Learn 的 Copilot Studio “What’s new” 页面在 8 月 20 日更新、文档日期为 8 月 18 日，但新增列表仍标为 **July 2026**：新 Agent 自动创建 Entra Agent ID 且环境级不可退出、MCP server 可作为 GitHub Copilot harness 工具、MCP server 可申请 Microsoft certification、环境级 telemetry 可导出 Application Insights。因为功能月份明确为 7 月，本报告只作背景，不误写为本周发布；它显示 Microsoft 正把每 Agent 身份、MCP 认证和环境级可观测性连成治理栈。

- 原文：[August 2026 Partner Center announcements—Dragon Copilot（2026-08-20）](https://learn.microsoft.com/en-us/partner-center/announcements/2026-august#dragon-copilot-physician-apps-and-agents)、[Copilot Studio What’s new（文档 2026-08-18 更新；功能标 July，背景）](https://learn.microsoft.com/en-us/microsoft-copilot-studio/whats-new)

#### 7. 字节 Coze／扣子
**本周动态：未发现可计入的官方平台更新。** 核验 Coze/扣子官网、公开社区/开发者页和以 8 月 17—23 日为条件的检索。搜索可见窗口内开发者入驻和第三方 Skill 评价页面，但它们不是字节官方产品公告、release note 或可验证的平台能力发布，故不计入。产品形态覆盖 Agent/工作流/插件与 Skill 分发；工程上涉及模型编排、工具调用、知识库和运行环境。**生态采用**：社区条目能证明内容仍在新增，却不能证明平台能力变化，也没有可审计的活跃开发者或交易额口径。**风险限制**：社区页面日期常对应评论/加入时间，不能映射为 Skill 发布日；计费、沙箱、身份权限、审计归因和 ROI 本周均无官方增量。**影响判断**：继续监测官方 changelog，避免用社区噪声替代产品事实。

- 核验入口：[Coze](https://www.coze.com/)、[扣子](https://www.coze.cn/)

### 二、协议、工具生态与工程基础设施

#### 8. MCP 协议与工具生态
**本周动态（2026-08-23）：MCP Core Maintainers 发布新版路线图。** 路线图把后续工作收敛为五类：Agentic messaging primitives、HTTP-native transport 统一与加固、Agent identity/企业安全、改进 primitives、SDK 开发体验。产品/协议形态上，MCP 正从“工具调用接口”扩展成可承载长任务、流式结果、中途 steering、事件订阅与进度通知的 Agent 基础协议。**工程架构**：此前 2026-07-28 版本已移除协议级 session/初始化握手，引入 `server/discover`、可缓存 list 结果、Tasks extension 与 Multi Round-Trip Requests；本周路线图进一步提出 webhook/channel，避免客户端轮询，并计划以 progressive discovery 缩小百工具场景的上下文与选择成本。**身份权限**：明确从“人在浏览器批准”扩到云工作负载 Agent、代用户行动和对子 Agent 的窄权限委派；路线包括 DPoP、Workload Identity Federation、ID-JAG 与标准 token exchange。**生态采用/治理**：SEP 按五类优先审查，SDK conformance 继续加强。**风险限制**：路线图不是已落地规范；Agent 身份与 delegation 尚未标准化。本次 GitHub 直查相关 Workload Identity Federation PR，但匿名 GitHub API 遭共享 IP rate limit，改以官方路线图内直链核验 PR。**影响判断**：MCP 的竞争焦点已从连接数量转到生产级身份、事件与工具目录规模治理。

- 原文：[The New MCP Roadmap（2026-08-23）](https://blog.modelcontextprotocol.io/posts/mcp-roadmap/)、[官方 Roadmap](https://modelcontextprotocol.io/development/roadmap)、[GitHub：Workload Identity Federation PR #1933](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/1933)、[2026-07-28 规范（背景）](https://modelcontextprotocol.io/specification/2026-07-28/changelog)

#### 9. Agent memory／context engineering
**本周动态：未发现符合窗口与官方原文要求的新论文/产品发布。** 核验 arXiv、相关 GitHub/论文检索及企业平台官方更新。检索命中的系统性材料《Memory in the Age of AI Agents》《Are We Ready For An Agent-Native Memory System?》分别属于 2025 年与 2026 年 6 月，均不在窗口。Microsoft Copilot Studio 的 persistent memory 亦标为 2026 年 6 月功能，不能因 What’s new 页面本周更新就改写发布时间。**产品形态**：业界仍在从“把历史塞入长上下文”转向按用户隔离的持久记忆、检索/压缩/遗忘与 provenance。**工程架构**：需区分短期工作状态、长期事实/偏好、情节轨迹和外部知识，并在写入前做敏感度、时效和冲突判断。**风险限制**：记忆污染、过期事实、跨用户泄漏、删除权及无限增长成本仍未形成统一 benchmark。**影响判断**：本周没有新增事实，但 MCP progressive discovery 从工具侧印证了 context budget 已成为架构问题，而非单纯模型窗口问题。

- 背景原文：[Memory in the Age of AI Agents](https://arxiv.org/abs/2512.13564)、[Are We Ready For An Agent-Native Memory System?](https://arxiv.org/abs/2606.24775)、[Copilot Studio memory overview](https://learn.microsoft.com/en-us/microsoft-copilot-studio/agents-experience/memory-overview)

#### 10. Sandbox／permission／identity／audit／observability
**本周最强信号来自 MCP 路线图与 Microsoft 治理栈，而非独立沙箱新品。** MCP 在 8 月 23 日把 Agent identity 与企业安全列为下一阶段一级优先项，明确处理无人值守 workload identity、代表用户行动、对子 Agent 委派更窄权限，技术路径是 DPoP、WIF、ID-JAG 和 token exchange，反对粘贴 API key/长期 token。Microsoft 本周 Dragon Copilot Marketplace 公告则暴露另一面：分发与采购先标准化，但临床 Agent 的患者数据权限、动作审计和责任归因未在公告给出。背景上，Copilot Studio 7 月能力为每个新 Agent 强制创建 Entra Agent ID、可导出环境级 telemetry 到 Application Insights、提供 MCP certification。**工程标准化判断**：身份必须成为每 Agent 一等资源；动作日志要把用户委派、Agent 身份、工具调用、参数/结果、策略判定和最终业务变更串成 trace。**风险限制**：身份存在不等于最小权限；可观测性也不等于可阻断控制，仍需执行前 policy check、短期凭据、沙箱网络/文件边界与回放证据。

- 原文：[MCP Roadmap](https://blog.modelcontextprotocol.io/posts/mcp-roadmap/)、[Copilot Studio What’s new](https://learn.microsoft.com/en-us/microsoft-copilot-studio/whats-new)、[Dragon Copilot announcement](https://learn.microsoft.com/en-us/partner-center/announcements/2026-august#dragon-copilot-physician-apps-and-agents)

### 三、Benchmark 与安全红队（逐项核验）

#### SWE-bench
**本周动态：未发现带窗口内日期的官方 benchmark 发布。** 已打开官方 leaderboard；页面为动态渲染，只能确认官方榜单持续存在，不能从当前排序反推某成绩何时提交。搜索摘要显示 Claude 4.5 Opus、Doubao-Seed-Code 等排序，但摘要不作为数字证据，故不抄录分数。产品形态是针对真实 GitHub issue 的仓库级软件修复评测；工程价值在可执行测试验证，而非文本相似度。**风险限制**：测试泄漏、公开仓库污染、harness/推理预算差异、单次 resolve rate 对稳定性刻画不足。**影响判断**：企业选型应要求轨迹、成本、wall time、重复运行可靠性和隔离策略，不能只看榜首。原文：[SWE-bench Official Leaderboards](https://www.swebench.com/)、[GitHub](https://github.com/SWE-bench/SWE-bench)

#### OSWorld
**本周动态：无。** 官方 v1 页面最近明确日期是 2026-06-26 的 OSWorld 2.0 上线，早于窗口。v1 有 369 个真实电脑任务（其中 8 个 Google Drive 任务可能需手工配置，也可按官方口径排除后测 361 个），134 个 execution-based evaluator；页面保留的初始论文数字为人类 72.36%、当时最佳模型 12.24%，这些是历史基线而非当前榜单。产品形态是跨 Ubuntu/Windows/macOS 的可控真实计算机环境；架构支持初始化、交互、后处理、文件/信息取回与执行式评估。**风险限制**：网络依赖、UI 漂移、分辨率与轨迹上下文显著影响结果。**影响判断**：比静态 GUI benchmark 更贴近生产，但必须锁镜像/应用版本并报告排除任务。原文：[OSWorld v1 官方页](http://osworld-v1.xlang.ai/)、[OSWorld 2.0](https://osworld-v2.xlang.ai/)、[GitHub](https://github.com/xlang-ai/OSWorld)

#### WebArena
**本周动态：无。** 打开官方 WebArena-x 入口并核验项目导航，未见 8 月 17—23 日 release/公告。当前官方入口把 WebArena、WebArena-Infinity、VisualWebArena 与 TheAgentCompany 组织成一套自治 Web Agent benchmark。产品形态是自托管、可执行的网站环境；工程价值是数据库状态/页面结果可验证。**风险限制**：网站版本和账户初始状态敏感，LLM 可能记忆公开任务，单一成功率无法覆盖策略违规与副作用。**影响判断**：应把 Infinity 的持续演化思路与生产回归测试结合。原文：[WebArena-x](https://webarena.dev/)、[WebArena](https://webarena.dev/og/)、[GitHub](https://github.com/web-arena-x/webarena)

#### GAIA
**本周动态：无窗口内新增。** 已打开 Hugging Face 官方 leaderboard；最新可见高分条目日期早于窗口（例如 2026-07-08），因此不把 8 月的第三方榜单镜像写成更新。官方页当前可见 CustomGPT.ai enterprise agent 的 93.36（提交日期 2026-06-03），但属于公开 leaderboard 自报/提交结果，需结合方法与可复现材料理解。产品形态是多步骤、工具使用、网页与文件推理的一般助手评测。**风险限制**：高分可能来自模型路由、搜索堆栈和多次采样，成本与延迟不可比；公开题污染风险随时间上升。**影响判断**：GAIA 适合测广度，不足以单独证明权限安全或业务动作正确。原文：[GAIA 官方 leaderboard](https://gaia-benchmark-leaderboard.hf.space/)、[数据集](https://huggingface.co/datasets/gaia-benchmark/GAIA)

#### τ-bench
**本周动态：官网未给出更新日期，不能确认其新 voice/banking/telecom 内容在窗口内发布。** 官方页当前列出：全双工实时语音（含打断、口音、背景噪声），约 700 文档的知识密集任务与银行领域，修复 airline/retail 50+ 任务，telecom dual control，以及原始 retail/airline 工具—用户交互，并以可验证数据库结果和 pass^k 可靠性评分。**产品形态**：从纯工具调用扩到语音、政策应用和“用户也必须执行步骤”的双控制。**工程架构**：模拟用户+工具+数据库 outcome。**风险限制**：无页面发布日期，不可写作本周动态；模拟用户偏差和 policy ambiguity 仍需报告。**影响判断**：pass^k 比一次成功率更接近企业对稳定性的要求。原文：[τ-bench 官方页](https://taubench.com/)、[GitHub](https://github.com/sierra-research/tau-bench)

#### Agent 安全红队论文
**本周动态：未检索到窗口内发布且可由论文页日期确认的高相关新论文。** 核验 arXiv 与官方研究页，命中《Measuring AI Agents' Progress on Multi-Step Cyber Attack Tasks》为 2026-03，《Agentic AI Security: Threats, Defenses, Evaluation, and Open Challenges》修订于 2026-02，均只作背景。红队产品形态应覆盖 prompt injection、恶意工具/MCP server、权限提升、数据外泄、长链任务中的策略漂移与多 Agent 委派。**工程标准化**：必须记录攻击前提、可用权限、成功判据、重复次数、检测/阻断率、业务副作用和恢复成本。**风险限制**：只测模型拒答会遗漏运行时身份和工具链攻击；公开攻击集容易过拟合。**影响判断**：下一阶段评测应把 sandbox policy 与 trace/audit 纳入端到端红队，而不是把安全分数与能力 benchmark 分离。背景原文：[Multi-Step Cyber Attack Tasks](https://arxiv.org/abs/2603.11214)、[Agentic AI Security Survey](https://arxiv.org/abs/2510.23883)

### 四、组末雷达与洞察

#### 协议雷达
| 方向 | 本周证据 | 成熟度 | 重点缺口 |
|---|---|---:|---|
| MCP HTTP-native | 8/23 路线图确认无状态、可缓存、可路由方向 | 中高 | 本地/远程 transport 统一与兼容迁移 |
| Agent identity/delegation | MCP 明确 DPoP、WIF、ID-JAG、token exchange | 中 | 标准尚未定稿，跨厂商 trust policy 未验证 |
| 长任务/事件 | Tasks、subscriptions、progress，规划 webhook/channel | 中 | 取消、幂等、重试、事件认证与计费归因 |
| 工具发现 | progressive discovery 进入优先项 | 早中期 | 工具搜索质量、恶意描述、版本与权限预览 |
| MCP 认证 | Microsoft 7 月背景：server certification preview | 早期 | 认证范围、持续复核、供应链撤销机制 |

#### 评测雷达
| Benchmark | 本周状态 | 最值得企业复用的指标 | 主要警报 |
|---|---|---|---|
| SWE-bench | 无确认更新 | 可执行测试通过、成本、时间、重复成功 | 污染与 harness 不可比 |
| OSWorld | 无；2.0 为 6/26 | execution-based outcome、任务排除清单 | UI/网络漂移 |
| WebArena | 无 | 最终数据库状态、副作用 | 站点版本与公开题记忆 |
| GAIA | 无窗口内提交 | 分层准确率+成本/延迟 | 路由/多采样不可比 |
| τ-bench | 页面有新形态但无日期 | pass^k、policy compliance、数据库 outcome | 模拟用户与更新日期不透明 |
| 安全红队 | 无新论文 | 攻击成功/阻断/检测/恢复与权限前提 | 仅模型层测试严重不足 |

#### 企业 Agent 雷达
- **Microsoft：上升。** Dragon Copilot 获得行业 Marketplace 分发/采购闭环；Entra Agent ID、telemetry、MCP certification（7 月背景）显示治理底座连贯。
- **Salesforce：稳定偏强。** 虽非本周发布，AWU 把动作产出、行业规模和销售结果连起来，形成可讨论的 ROI 语言；需警惕厂商自有数据的选择偏差。
- **Glean：蓄势。** 8/26—27 大会将集中披露 ROI、认证、成本与平台能力；本周应等待原文，不抢跑。
- **MCP：本周最高技术信号。** 身份委派、事件与 progressive discovery 直接命中生产瓶颈。
- **Sierra/Harvey/ServiceNow/Coze：本周静默。** 未发现满足官方日期口径的新事件，不以旧闻补位。

#### TOP 候选（供主报告筛选）
1. **MCP 新路线图（8/23）**：Agent identity/delegation、事件化长任务、progressive tool discovery 同时进入优先级，技术外溢面最广。
2. **Dragon Copilot Physician apps and agents Marketplace（8/20）**：医疗 Agent 从单产品升级为行业分发与商业化平台，但权限审计披露不足，兼具机会与治理张力。
3. **企业 Agent 度量方法（背景候选）**：Salesforce AWU/action-to-token 与 Glean 的 adoption-to-outcome gap 可构成“从席位采用到业务产出”的专题，但必须清楚标注 8/7 背景而非本周新闻。

#### 产品、工程与商业化洞察
1. **产品：Agent 平台的最小完整形态从 builder 变为“上下文+身份+工具目录+运行时+评测+分发”。** Microsoft 医疗 Marketplace 和 MCP 路线图分别补齐分发、身份和协议层；只提供 prompt/flow 编辑器的产品会迅速同质化。
2. **工程：每 Agent 身份是治理主键。** 用户身份、Agent workload identity、委派链、tool/server identity 必须同时进入 trace；否则审计只能看到“某应用调用 API”，无法解释谁授权、为何执行、由哪个子 Agent 改写了状态。
3. **工程：progressive discovery 是成本与安全的共同控制。** 百工具全量注入既浪费 token 又扩大误选/恶意工具暴露面；先暴露窄入口，再按意图、权限和风险逐层解锁，应成为默认架构。
4. **商业化：从 per-seat 转向 work-unit/outcome 仍在早期。** Salesforce AWU 给出了工作单元语言，Microsoft Marketplace 给出交易通道，但本周没有公开统一费率。近期更现实的是席位/容量+动作或 credits 的混合模式，合同中需明确失败调用、重试和人工升级是否计费。
5. **ROI：必须做基线与归因。** “使用次数增加”不是 ROI；至少同时看任务完成、人工节省、收入/风险结果、单位成功成本和质量守恒。Salesforce 的 8% vs 2% 销售增长是相关性信号，不应直接写成 Agent 导致 4 倍增长。
6. **评测：公开榜单必须降权，内部可执行回归必须升权。** 以 pass^k、环境版本、轨迹、成本、权限前提、副作用和失败恢复为共同报告模板，才能把 SWE-bench/OSWorld/WebArena/τ-bench 的方法转成企业工程标准。
7. **治理：可观测不等于可控。** telemetry 和 session replay 用于事后解释；生产防线还需要执行前 policy decision、短期 token、沙箱边界、敏感动作二次确认、幂等/回滚与凭据撤销。

### 核验结论
本窗口确认 **2 个高可信本周事件**（MCP 新路线图、Dragon Copilot Physician apps and agents Marketplace）；固定追踪的其余企业、memory/context、六类 benchmark 与安全论文均完成官方入口核验，未满足日期或原文要求者明确列为“无动态/背景”，未用搜索摘要补造发布。


## 下周观察点

1. OpenAI Workspace Agents 的 credits 计价、research preview 稳定性、审批率和组织级使用数据是否公开。
2. Cursor Origin 是否补齐权限模型、企业数据边界、迁移/退出机制，以及 Agent-native app extension 的真实采用。
3. MCP Agent identity、DPoP/WIF/ID-JAG、webhook/channel 和 progressive discovery 是否进入可实现的 SEP 与 SDK conformance。
4. Glean:GO 2026 是否披露可复核的客户 ROI、认证、成本和治理数据。
5. Hermes、OpenClaw、Dify、ADK 等高频项目是否给出稳定 release、回归证据与更清晰的升级契约。
6. 浏览器/OS Agent 是否开始统一公开任务成功率、人工接管率、登录/支付错误率和提示注入事件。

## 关于本周报

本周报聚焦 Agent 产品、开源项目与工程生态。检索只用于发现线索，最终判断以官方博客、文档、GitHub release/API、协议规范、论文和 benchmark 原文为准；时间窗外信息仅作明确背景。对 GitHub 项目，stars 只作为规模快照，不直接等同于工程价值、用户留存或企业采用。
