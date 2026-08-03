# 全球 AI Agent 研究周报 · 第 9 期（2026-07-27 ~ 2026-08-02）

> **覆盖区间**：2026-07-27 ~ 2026-08-02（Asia/Shanghai，刚结束的完整自然周）  
> **覆盖范围**：Agent 产品、开源项目、框架工具、CLI/IDE、浏览器/Computer Use、企业垂直 Agent、MCP/权限/沙箱/评测等，共覆盖 42 个固定与扩展对象。  
> **数据声明**：本期只写时间窗内可核验公开信息；时间窗外旧闻仅作背景并明确标注。开源项目优先直查 GitHub release、仓库页、官方 changelog、API/文档或 benchmark 页面；搜索摘要只用于发现线索，不作为事实来源。遇到搜索或 GitHub API 限流时，降级为官方页面、GitHub 网页、原始文档与已读全文链接交叉核验，并把无法稳定取得的数据标注为“未公开/未稳定获取”。

## 本周一句话

> 本周 Agent 赛道从“产品能力竞赛”继续收敛到“运行时与治理竞赛”：MCP 2026-07-28 把工具协议推向无状态、可网关化和企业授权；编码 Agent 继续平台化为多会话、多插件、多端协作的开发工作台；开源框架集中补安全沙箱、checkpoint、skills、workflow 与浏览器 harness；企业 Agent 则把身份、审计、成本、数据上下文和业务结果变成采购核心。

## 🔥 本周 TOP 5 Agent 事件

### 1. MCP 2026-07-28：工具协议进入企业治理阶段

MCP 在 2026-07-28 发布重大修订，从会话式工具调用走向 stateless core：移除协议级 session 与 initialize handshake，每个 request 通过 `_meta` 携带 protocol version、capabilities、client/server info；新增 `server/discover`、extensions capability、OpenTelemetry trace context、CacheableResult 的 TTL/cache scope；Tasks 被移到官方 extension，Enterprise-Managed Authorization 引入企业 IdP、policy enforcement、revocation 与 auditable trail。这个变化会带来短期兼容成本，但中期会推动 Agent 平台把权限、trace、long-running tasks 与身份治理做成基础设施。

### 2. Dify 1.16.1：开源 Agent 平台开始补生产安全课

Dify 本周发布 `v1.16.1 - Bug Fixes and Security Enhancements`，新增 workflow tool node multi-select、workflow logs 与 RAG tracing 等生产体验，同时重点加固 Agent local sandbox：dedicated Squid forward proxy、strict ACL、禁止 sandbox 直连内部服务、API 与 agent backend bearer token、Jinja2 SandboxedEnvironment、React Server Components DoS 修复等。它说明可视化 Agent 平台的竞争不再只是“能拖流程”，而是多人协作、权限边界、日志追踪和升级安全。

### 3. OpenAI Agents SDK 0.19：模型开始直接编排工具

OpenAI Agents SDK 本周 `0.19.0/0.19.1/0.19.2` 把 Programmatic Tool Calling 纳入 SDK：支持模型生成 JavaScript 协调 eligible tools，并结合 allowed callers、structured outputs、Runner streaming、guardrails、approvals、sessions 与 RunState。与此同时，release 持续修复 sandbox path grants、MCP credentials/tracing/tool metadata redaction、memory session item counting 与 Realtime/voice/tracing。这个方向可能改变复杂工具链的 orchestration 模式，但也把工具权限、日志脱敏、sandbox mounts 和 approvals 变成硬门槛。

### 4. Perplexity Personal Computer for Windows：桌面 Agent 进入商业化工作流

Perplexity 本周发布 Personal Computer for Windows，把 Comet/Computer 能力从浏览器扩展到 Windows 10/11、本地文件、Office 365 与 400+ app 连接器。官方称其 agent harness 可跨 15+ models 编排，支持 approved folders/files/apps、per-user permissions、activity logs、sensitive action confirmation 与 secure sandbox。它的意义不只是“浏览器能点网页”，而是桌面、本地文件、企业连接器和 AI 浏览器开始合成新的工作流入口。

### 5. Sierra Agency：企业 Agent 的沙箱变成云原生控制面

Sierra 在 2026-07-29 披露 Agency：Kubernetes 原生的 secure/scalable sandbox control plane。它用无状态控制面 + 有状态 runner fleet、IAM、DynamoDB、K8s Pod、persistent volume、LLM proxy、egress proxy、pod identity、Redis Streams 与 FSM checkpoint/replay 来支撑长任务、客户数据隔离和成本休眠。Sierra 的披露给行业一个清晰信号：企业 Agent 运行时越来越像云原生平台，身份、网络、状态、审计和成本恢复比单次模型能力更重要。

## 🧭 三条主线

### 产品主线：Agent 从单点入口走向跨端工作台

编码 Agent 侧，Claude Code、Codex、Cursor、Devin Desktop、OpenCode、Cline 都在把 CLI/IDE/桌面/移动/Slack/远程主机串成持续会话工作台：side chats、thread forks、Inbox、PR review、Slack multi-repo、browser preview、checkpoint、worktree merge 和 mobile control 成为产品关键词。浏览器与通用 Agent 侧，Perplexity Windows、Genspark Workspace/Claw、Manus Browser Operator、OpenAI Work、Anthropic/Google Computer Use 则继续在云端浏览器、本地登录态、桌面文件、Office 和多模型路由之间寻找可用边界。

### 工程主线：协议、沙箱、状态与可观测成为底座

本周高价值更新集中在看不见的运行时层：MCP 去 session 化并加入 enterprise auth；Dify 加固 sandbox 与 agent backend；Sierra 自建 Kubernetes runner；LangGraph 修 stream/checkpoint namespace；CrewAI 加 WaitTool、skill usage events 与 flow failure semantics；browser-use 修 DOM snapshot、navigation readiness、cross-origin iframe 和 MCP server；OpenAI Agents SDK 与 Codex/Claude Code 则继续处理工具权限、MCP、trace、session fork 与 proxy。Agent 工程正从 prompt 编排转向“受管执行系统”。

### 商业化主线：企业买治理、计费与结果，不只买模型

Salesforce Agentforce 把 Flex Credits、conversation pricing、Agent Fabric 和 Moody’s 案例推向明确采购语言；Microsoft 把 Copilot Credits、spending policies、SharePoint list knowledge source 与 extensibility known issues 写进管理面；Glean 用 Work AI Index 强调 adoption 与 ROI 的落差；Harvey 用 24.8M 文档/周的处理规模证明垂直 Agent 的数据面工程价值。企业 Agent 的商业化正在进入 FinOps、权限、审计、数据驻留、业务结果和用户可见治理共同决定采购的阶段。

## 🧩 开源生态雷达

| 类别 | 项目 | 本周判断 |
|------|------|----------|
| 增长/活跃项目 | Dify、Google ADK、OpenAI Agents SDK、browser-use、CrewAI、LangGraph、OpenClaw、Hermes、OpenHands | 活跃点集中在 sandbox、workflow graph、Task API、Programmatic Tool Calling、Browser Harness、skills/flows、session fork、MCP 与控制中心化。 |
| 事实标准候选 | MCP、LangGraph、Dify、browser-use、OpenAI Agents SDK、Google ADK、OpenClaw | 分别占据协议标准、有状态 workflow、可视化 Agent 平台、浏览器执行层、官方 multi-agent SDK、云厂商 Agent SDK、个人 Agent OS 等关键生态位。 |
| 观察/静默项目 | AutoGen、LlamaIndex Agents、MetaGPT、SuperAGI、ServiceNow AI Agents、Coze/扣子、部分中国通用 Agent | 多数仍有长期价值或渠道优势，但本周缺少重大 release、架构披露、客户案例或可核验指标，不用历史热度凑正文。 |
| 热闹但需谨慎 | 高 stars 的早期自主 Agent 项目、缺少 release notes 的高速项目、闭源桌面/浏览器 Agent | GitHub 热度不是生产价值；没有安全边界、客户、benchmark、release 或审计数据时，只能进入观察池。 |

## 📡 Agent 产品雷达

| 赛道 | 代表对象 | 本周变化 |
|------|----------|----------|
| 编码 Agent | Claude Code、Codex、Cursor、Devin/Windsurf、OpenCode、Aider、Cline、Replit Agent | 重点在多会话、插件/skills、模型路由、桌面/CLI server、浏览器预览、checkpoint、权限卡片与移动/Slack 工作流。 |
| 浏览器 / Computer Use | Perplexity Personal Computer、OpenAI Work、Anthropic Computer Use、Google Mariner/Gemini Computer Use、Manus、Genspark、browser-use | 重点在本地文件、Office、登录态、云/本地浏览器、截图循环、支付/敏感动作确认、跨源 iframe 与安全沙箱。 |
| 企业/垂直 Agent | Sierra、Glean、Harvey、Salesforce Agentforce、Microsoft Copilot Agents、Coze/扣子 | 重点在安全 sandbox、permission-aware context、legal document processing、action pricing、Cost Management、connector governance 与审计。 |
| 中国 Agent | Kimi、Qwen-Agent/Qwen3Guard、AutoGLM/GLM-5.2、Manus、Genspark、Coze | 本周更多是模型/框架/安全护栏与工作台路线，真正 browser/OS 操作产品更新较少；需要区分模型底座能力和可审计执行闭环。 |

## 🚦 四维质量门控

- **覆盖率门控**：覆盖 42/42 个固定与扩展对象；有料对象均包含深度笔记与原文链接，静默/观察对象写明核验范围和原因。
- **原文深度门控**：原文抽查 5/5 通过，抽查对象包括 MCP 2026-07-28、Dify 1.16.1、OpenAI Agents SDK 0.19、Perplexity Personal Computer for Windows、Sierra Agency；开源/GitHub/benchmark 数据已按官方页面或 GitHub 网页/API 核验，遇 API 限流已标注。
- **工程判断门控**：每个有料对象均覆盖产品形态、工程架构、生态/采用、风险/限制；全文已形成产品、工程、商业化三条主线。
- **数据可信门控**：关键版本、日期、stars、pricing、benchmark、客户、任务量等均附来源或标注未公开；搜索遇限后已降级到 GitHub 页面、官方 docs/changelog/blog、benchmark/arXiv 页面和原始 release 全文。

## 编码 Agent / CLI / IDE

### Claude Code
- 本周动态：本周 Claude Code 的主线是长上下文模型、沙箱网络边界、MCP 诊断与多 Agent 编排。官方 changelog 最新条目显示 2.1.219 新增 Claude Opus 5（`claude-opus-5`）并设为默认 Opus 模型，提供 1M context 与 fast mode；新增 `sandbox.network.strictAllowlist`，让 sandboxed commands 对非 allowlist host 直接拒绝而不是再弹确认；新增 `DirectoryAdded` hook 支持会话中通过 `/add-dir` 或 SDK `register_repo_root` 动态注册工作目录；`mcp_server_errors` 被加入 headless `stream-json` init event，终端也会对 MCP config 校验失败项给 startup warning；还支持 nested subagent forwarding，在 `--forward-subagent-text` 下把深层 subagent 文本按 spawning tool_use id 转发。2.1.218/217/216 继续修复 `/code-review` 后台化、fork lineage、background sessions、workspace trust、Windows path/PowerShell 权限、symlink/worktree 隔离、`/rewind` 不穿透 symlink/hard link、scheduled tasks untrusted prompt、telemetry/tool provenance 等可靠性问题。同期 Anthropic 发布《MCP 2026-07-28 spec: stateless core, coming to Claude》，说明新 MCP stateless core、standardized extensions、hardened auth 会 rolling out across Claude products soon。
- 工程与产品分析：
  - 产品形态：Claude Code 已不只是终端编码助手，而是具备本地/云端会话、IDE/Remote Control、code review、skills、subagents、MCP、sandbox 与 headless stream-json 的开发 Agent runtime。
  - 工程架构：重点从“代码生成”转向受管执行：sandbox network allowlist、动态 repo root、MCP config error surfacing、nested subagent text forwarding、background review agent、workflow size guideline 与 OpenTelemetry provenance 都在强化长任务可控性。
  - 生态/采用：与 MCP、Claude Desktop/Web、Bedrock/Vertex、skills/plugins、IDE selection、Remote Control 相连；MCP 2026-07-28 支持将影响 Claude 产品的工具接入协议。
  - 风险/限制：能力面越宽，权限、网络出口、工作区 trust、subagent fan-out 与 prompt injection 风险越高。官方频繁修复 Windows/PowerShell/symlink/worktree/remote session 问题，说明企业使用必须锁版本并开启最小权限 sandbox。
- 关键数据：GitHub 网页查询（2026-08-03）：`anthropics/claude-code` 约 140,032 stars；changelog 声明 Claude Opus 5 为默认 Opus、1M context、fast mode $10/$50 per MTok；Sonnet 5（背景条目）促销价到 2026-08-31。fork/open issues 因 GitHub API 403 未稳定获取。
- 原文链接：[Claude Code changelog](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)；[MCP 2026-07-28 coming to Claude](https://claude.com/blog/bringing-mcp-2026-07-28-to-claude)；[Claude Code docs](https://code.claude.com/docs/en/overview)；[GitHub](https://github.com/anthropics/claude-code)
- 影响判断：Claude Code 本周继续把编码 Agent 的关键竞争点推向“可靠运行时”：模型上下文、沙箱网络、MCP 诊断、subagent 管理和审计信号同等重要。它可能继续引领高端开发者体验，但企业落地必须把 permission/sandbox/telemetry 当核心配置，而不是默认信任 agent。

### OpenAI Codex / Codex CLI
- 本周动态：OpenAI Codex 本周 release 页面显示 `0.147.0-alpha.*` 预发布系列，变化非常密集，核心是把 Codex CLI/APP-server 从单线程对话推进到多会话、多插件、多环境控制面。新特性包括：用 `/new` 或 `/clear` 为新 session 命名、pin 重要 threads、在不关闭主会话的情况下切换 side conversations；支持 Agent Plugins manifests、workspace plugin publishing，并增加 Amazon Bedrock 与 Claude Code plugin marketplaces；支持 fork threads 与分页历史，包括不会进入 thread listing 的 temporary forks；app-server 可通过 WebSocket 连接 remote Code Mode hosts；兼容 custom model provider 的 standalone web search；可发现 executor-provided skills 并安全读取 associated resources。Bugfix 主线更工程化：proxy 设置贯穿 authentication、plugin downloads、MCP authorization、remote execution、WebSockets、redirects、LM Studio；MCP connections 和 Apps tools 在 auth/config 变化后可保持最新并重连 closed servers；submitted messages、final responses、failed-turn errors、imported timestamps、approval settings 在 interruptions/replay/imports/forks 中保留；Windows sandbox process tree 终止、narrow layout、hyperlinks、skill catalog truncation warnings 等也被修复。
- 工程与产品分析：
  - 产品形态：Codex 从“OpenAI 编码 CLI”走向 agent workstation：CLI、app-server、Code Mode host、plugins、skills、MCP、thread forks、enterprise update controls 共同构成开发 Agent 平台。
  - 工程架构：多会话/side conversation 与 thread fork 解决长任务分叉；Agent Plugin manifests 和 marketplace 解决能力分发；WebSocket remote host 与 proxy-aware HTTP client 解决企业网络；MCP auth/reconnect、approval preservation、skill catalog budget 解决生产可恢复性。
  - 生态/采用：与 OpenAI release infrastructure、Agent Plugins、Amazon Bedrock、Claude Code marketplace、MCP、custom providers 和 skill ecosystem 互联。
  - 风险/限制：0.147.0 仍是 alpha/pre-release；插件市场、remote execution、skills resource read、MCP auth 与 proxy 穿透都增加供应链和权限面。企业需要验证 plugin provenance、approval audit、remote host isolation。
- 关键数据：GitHub 网页查询（2026-08-03）：`openai/codex` 约 103,369 stars；release 页面显示 `0.147.0-alpha.4/alpha.3/alpha.1.1/alpha.2`；新功能与 bugfix 关联大量 PR（如 #34605、#35105、#35220、#35078 等）。fork/open issues 因 GitHub API 403 未稳定获取。
- 原文链接：[OpenAI Codex releases](https://github.com/openai/codex/releases)；[OpenAI Codex GitHub](https://github.com/openai/codex)
- 影响判断：Codex 本周最值得关注的是“生态化”和“会话工程”：插件、skills、thread forks、remote hosts 与企业更新控制让它更像开发者 Agent OS。短期 alpha 风险较高，但如果稳定，可能成为 OpenAI 体系内对标 Claude Code/Cursor/Devin Local 的核心入口。

### Cursor
- 本周动态：Cursor 本周 changelog 显示三条核心产品线推进：移动端/iPad、低价区域计划、模型路由与 Slack/Cloud Agent 协作。`Cursor, now on iPad` 将 Cursor for iPad 扩展到所有付费计划；iPhone/iPad 新增 Inbox，用于查看 agent 进度、需要注意的事项和 PR review 状态；移动端 review screen 覆盖完整 PR，包括 comments、checks、approvals、reviewers，并可提示 agent 处理评论，形成“agent output → PR review → merge”的移动闭环。`Cursor Start` 于 2026-07-28 面向印度推出 ₹649/月本地价计划，包含 Cursor models、always-on cloud agents、iOS remote control、plugins、MCP servers、hooks、skills。`Cursor Router` 让 Auto mode 由智能模型路由驱动，支持 Intelligence/Balance/Cost 三种优化模式，Team 默认开启，Enterprise 管理员可控制可用模式、默认模式、底层模型 allow/block；覆盖 desktop、web、iOS、CLI、SDK。Slack 集成则新增任务前计划、multi-repo environment、跨 channels/threads 读取上下文和回写更新。Side Chats/Conversation Search 支持并行探查、搜索 agent transcripts、本地索引、cloud agent conversation hooks（beforeSubmitPrompt、afterAgentResponse、afterAgentThought、stop、subagentStart 等）。
- 工程与产品分析：
  - 产品形态：Cursor 正在从 IDE agent 扩展为跨桌面、Web、移动、Slack、CLI/SDK 的 agentic development platform。
  - 工程架构：Cloud agents 是中心；Router 做模型策略和成本/质量优化；hooks 暴露 prompt/response/thinking/subagent/turn lifecycle；Inbox/PR review/Slack multi-repo 把异步 agent 工作流产品化。
  - 生态/采用：支持 Bitbucket、Azure DevOps SCM；Slack、GitHub/GitLab/Azure DevOps、plugins、MCP servers、hooks、skills 构成扩展生态；印度 Start 计划说明商业化向区域定价扩展。
  - 风险/限制：多端和 Slack 跨 channel 读取上下文提升便利，也提升数据权限和上下文污染风险；Router 的底层模型选择需要企业管理员明确 allow/block，否则成本和数据路由不可预测。
- 关键数据：Cursor Start 价格 ₹649/月，2026-07-28 起可用；Router 提供 Intelligence/Balance/Cost 三种优化模式；Cursor Router 覆盖 desktop/web/iOS/CLI/SDK，Teams 默认开启，Enterprise 可启用并管控。未公开本周 agent 完成率或 SWE-bench 新分数。
- 原文链接：[Cursor changelog](https://cursor.com/changelog)；[Cursor Start announcement](https://cursor.com/blog/cursor-start-india)；[Cursor Router](https://cursor.com/blog/router)；[Slack docs](https://cursor.com/docs/integrations/slack)
- 影响判断：Cursor 本周的主线是“从 IDE 到异步协作网络”：移动端 PR review、Slack multi-repo、Router 和 hooks 把 Agent 开发变成团队工作流。它的竞争点正在从模型能力转向组织协作、成本治理和跨工具上下文。

### Cognition Devin / Windsurf
- 本周动态：Cognition 将 Windsurf 迁移到 Devin Desktop 体系后，本周 changelog 非常活跃。`v3.6.21`（2026-07-29）是核心版本：Devin Desktop 新增统一通知设置，可在任意 agent session 完成或需要输入时发 native OS notification；Codemaps 可在 Agent Window 模式中作为独立 editor tab 打开，Codemap @-mentions 可用于 Devin Local；文字 transcript 可选中并加入 chat input；permission requests 新增 keyboard shortcuts 与 always-allow/reject hints；agent sidebar 增强右键菜单、双击重命名、workspace filters/sort/grouping、read-only locked sessions、new-session shortcut 与 sticky grouped spaces；Cascade、Devin Local 和所有 ACP agents 在 Restricted Mode 下不可用，hooks 也不加载/运行；Devin Local customizations 新增 Plugins section。最关键的是 remote agent (ACP) sessions 可打开 browser preview：agent 可代理本地 dev server，用户捕获的元素和 console output 会作为 pending context 落入 agent message box，Devin Desktop 在内置浏览器 pane 打开 preview。Devin Local 还新增 Cascade Migration Wizard、Plan mode（先 read-only research，维护 `~/.devin/plans/plan-<session>.md`，实施前 approval）、worktree sessions Merge button、Megaplan、editable command approvals、MCP auth buttons 等。`v3.6.22` 修复 telemetry 在 account status resolve 前启动的问题，`v3.6.27` 修复 Windows certificate store 与 Devin Local 工具禁止经 symlink 写文件。
- 工程与产品分析：
  - 产品形态：Devin Desktop/Windsurf 已成为本地桌面 Agent Command Center，支持 Cascade、Devin Local、ACP agents、浏览器预览、codemap、worktree、plan mode 和权限卡片。
  - 工程架构：重点在 ACP session、local dev server proxy、browser preview、permission cards、Restricted Mode、hooks gating、plugins/customizations、worktree merge、plan file 持久化和 symlink write 防护。
  - 生态/采用：通过 ACP 与多个 agent runtime 兼容；从 Cascade 到 Devin Local 的迁移 wizard 表明 Cognition 正在把 Windsurf 资产整合进 Devin 产品线。
  - 风险/限制：本周多处修复 telemetry、certificate、symlink、Restricted Mode，说明本地桌面 agent 对企业代理/证书链、文件写入重定向、hooks 和权限策略非常敏感；Plan mode 与 editable approval 降低风险但也增加交互成本。
- 关键数据：Devin Desktop changelog：v3.6.21（2026-07-29）、v3.6.22（2026-07-29）、v3.6.27（2026-08-01）；base IDE 更新到 VS Code 1.126；Plan mode 计划文件路径 `~/.devin/plans/plan-<session>.md`。未公开本周 benchmark 分数。
- 原文链接：[Devin Desktop changelog](https://docs.devin.ai/desktop/changelog)
- 影响判断：Devin/Windsurf 本周给出了“本地 Agent IDE 收敛”的清晰样板：ACP、browser preview、plan approval、worktree merge、MCP auth、Restricted Mode 都围绕真实开发流程。它的差异化是把编码、预览、权限和桌面通知整合在一起；最大挑战是复杂本地权限和企业 IT 环境兼容。

### OpenCode
- 本周动态：OpenCode 本周 release 页面显示多次最新 release，重点是 MCP、新模型 provider 与 Desktop V2 稳定化。最新条目包括：修复 MCP SSE connections 在 server error responses 后陷入 reconnect loops；修复 provider model configs 对 `reasoning_text` 或 custom reasoning field 的 interleaved reasoning 字段兼容；Desktop 改为外部链接在系统浏览器打开、修复 stale session tab state、directory picker、file tree clipping、debug gutter alignment。另一条 release 新增 Modal models 自动发现，并改进 Desktop 重复附件防护、新 session button、toast stacking/dismissal/mobile layout、tab hover/active/overflow 状态，同时修复 persisted tabs malformed、model variant selector loading、custom agent picker。更早但仍在最新 release 列表中的条目还包括恢复 legacy MCP SDK clients compatibility、opt-in V2 desktop sidecar backed by bundled CLI service、newer MCP servers and OAuth flows compatibility、expired SDK sessions 后重连 MCP servers、honor configured MCP OAuth callback ports、停止向新 Gemini models 发送 deprecated sampling defaults、Linux AppStream metadata、provider connection state refresh、current-server terminal transport/review data/session actions/timelines/events 等。整体看，OpenCode 正在从 CLI 走向 Desktop + Server 双轨，并把 MCP、OAuth、Modal、current/legacy server compatibility 作为核心工程。
- 工程与产品分析：
  - 产品形态：开源/开放的 coding agent CLI + Desktop 应用，强调 provider 多样性、MCP、server/desktop 组合与插件生态。
  - 工程架构：MCP SSE/OAuth/session reconnect、provider model config reasoning fields、Desktop V2 sidecar、current-server/legacy-server 双兼容、session timelines/events 与 terminal transport 是核心。
  - 生态/采用：GitHub 网页查询显示约 192,447 stars；生态中出现 Modal provider setup、opencode-tavily plugin、Kimi adaptive thinking、Mistral/MiniMax/Gemini/OpenAI Responses compatibility 等社区贡献。
  - 风险/限制：release 页面未稳定抽取日期；本条仅按 2026-08-03 最新 release 核验为“本周/近期活跃观察”，不把具体日期作为已证事实。MCP/OAuth/server 兼容修复很多，说明协议升级期存在断连、认证、状态一致性风险。
- 关键数据：GitHub 网页查询（2026-08-03）：`anomalyco/opencode` 约 192,447 stars；latest releases 列出 Modal models、MCP SSE reconnect、legacy MCP SDK compatibility、Desktop V2 sidecar 等。fork/open issues 与 release 日期因 API 403/页面抽取限制未公开。
- 原文链接：[OpenCode releases](https://github.com/sst/opencode/releases)；[OpenCode GitHub](https://github.com/anomalyco/opencode)
- 影响判断：OpenCode 的价值不是 star 数，而是作为多 provider、MCP-first、桌面/CLI 双形态的开放编码 Agent。它本周/近期修复集中在 MCP 与 Desktop 稳定性，说明开源编码 Agent 进入“协议兼容和桌面控制面”竞争。

### Aider
- 本周动态：Aider 本周固定核验 release/HISTORY，最新历史显示 `v0.85.2~v0.86.1` 围绕新模型接入和 deterministic coding behavior 迭代。`v0.85.2` 支持 Grok-4（`xai/grok-4` 与 `openrouter/x-ai/grok-4`）、Gemini 2.5 Flash-Lite preview、OpenRouter Moonshot Kimi K2，并改善 `/clear`、`/undo`、model settings replacement；`v0.85.4/0.85.5` 加入 OpenAI GPT-5 支持、PostHog SDK event-capture API、默认关闭 GPT-5 family temperature、强制 GPT-5 使用 diff edit format、加入 reasoning_effort 并修复 versioned GPT-5 名称设置；`v0.86.0/0.86.1` 扩展 GPT-5 family/provider 支持，并为 GPT-5 models 加入 reasoning_effort、默认禁用 temperature。Aider 仍坚持轻量 CLI pairing 模式，而不是桌面多窗口控制面；它的工程价值在 repo-map、diff/patch edit formats、model-specific settings、commit attribution 和 token/cost 透明。
- 工程与产品分析：
  - 产品形态：面向终端开发者的轻量 CLI pair programming agent，适合在现有 repo 中做小步代码修改、提交、review 和多模型切换。
  - 工程架构：repo map + chat/edit formats + git commit workflow + model metadata/settings；本周围绕 GPT-5/Grok/Kimi/Gemini 模型能力、diff edit format 与 reasoning_effort 对齐。
  - 生态/采用：GitHub 网页查询约 47,888 stars；支持 OpenAI/Azure/OpenRouter/xAI/Gemini/Moonshot 等 provider，继续作为“模型接入速度最快的 CLI coding agent”之一。
  - 风险/限制：相比 Claude Code/Codex/Cursor，Aider 缺少完整桌面/云 agent control plane；对大型长任务、团队权限、MCP/插件治理和企业审计需要外部工具补齐。
- 关键数据：GitHub 网页查询（2026-08-03）：`Aider-AI/aider` 约 47,888 stars；HISTORY 显示 v0.85.2~v0.86.1 主要更新 GPT-5/Grok-4/Gemini 2.5 Flash-Lite/Kimi K2、reasoning_effort、diff edit format。fork/open issues 因 GitHub API 403 未稳定获取。
- 原文链接：[Aider HISTORY](https://raw.githubusercontent.com/Aider-AI/aider/main/HISTORY.md)；[Aider releases](https://github.com/Aider-AI/aider/releases)；[Aider GitHub](https://github.com/Aider-AI/aider)
- 影响判断：Aider 的本周价值在“模型适配层”：当主流模型快速迭代时，它能迅速把 reasoning_effort、edit format、temperature 等工程参数纳入 CLI 工作流。它不是最完整的平台，但仍是开发者评估新模型写代码能力的低摩擦入口。

### Cline / Roo Code
- 本周动态：Cline 本周 releases/changelog 显示 `4.1.0~4.1.3` 是关键窗口：4.1.0 把 stable VS Code extension 转成 combined A/B package，一个 VSIX 同时含 legacy extension 与新的 SDK-based extension，由 staged remote rollout 控制，每个 window 激活一个；设置、credentials、preferences 共享，若新 extension 激活失败自动 fallback。4.1.1 移除 vestigial MCP server-key machinery，native MCP tool calls 改为按 server name 路由，避免随机内存 uid 导致 restart/server list change 后路由失效。4.1.2 显示 active variant（Legacy/Next）。4.1.3 修复两套 rollout bundle 互相使 account session 失效、未知模型迁移 fallback、可靠 checkpoints、settings edits 保留、自定义 URL 输入、AskSage custom API URL、edited message 替换 session 后 pending tool approval 卡住、terminal command completion、untracked files commit message、Windows Store PowerShell profile、upstream provider error surfacing、Ollama empty response retry/5分钟冷启动 timeout、video input capability 等。Roo Code 仓库在 GitHub release 页面显示已于 2026-05-15 archive/read-only，但 CLI prerelease 仍列出 v0.1.14~v0.1.17：fix command output streaming、follow-up routing for completion asks、`--terminal-shell`、custom session ID support。Roo 主仓库 archive 使其长期可维护性弱于 Cline。
- 工程与产品分析：
  - 产品形态：Cline 是 VS Code 内的 agentic coding extension，正在向 shared Cline SDK session layer、marketplace、plugins/MCP/skills、ClinePass/provider catalog 收敛；Roo Code 更像历史 fork/CLI 观察对象。
  - 工程架构：Cline 4.1 核心是 SDK migration + staged rollout + checkpoints + native MCP routing + provider/model catalog + session fork/restore；Roo CLI 最近修复 stdin-stream routing、command output streaming、session id 与 shell selection。
  - 生态/采用：GitHub 网页查询（2026-08-03）Cline 约 65,507 stars，Roo Code 约 24,360 stars；Cline 对 Claude Code、OpenRouter、Vercel AI Gateway、Qwen/Moonshot/Z AI、Ollama、MCP 等 provider/工具更活跃。
  - 风险/限制：Cline 4.1.0 采用 A/B rollout 说明 SDK 迁移风险大；checkpoint/workspace rewind、tool approval settle、provider credential migration 都是容易造成真实代码损坏或会话失效的高风险点。Roo Code 主仓库 archive 是选型红旗。
- 关键数据：Cline GitHub 网页查询约 65,507 stars；RooCodeInc/Roo-Code GitHub 网页查询约 24,360 stars，页面提示 repository archived on May 15, 2026；Cline 4.1.0 staged rollout 初始 1% 用户进入 SDK-based extension；Ollama response-start timeout 提至 5 分钟。
- 原文链接：[Cline changelog](https://raw.githubusercontent.com/cline/cline/main/CHANGELOG.md)；[Cline releases](https://github.com/cline/cline/releases)；[Roo Code releases](https://github.com/RooCodeInc/Roo-Code/releases)
- 影响判断：Cline 本周反映 VS Code Agent 插件正在进入“运行时重构期”：SDK、checkpoint、MCP 路由、marketplace、provider catalog 都是长期基础设施。Roo Code 则说明 fork 生态会快速分化，主仓库归档后不宜只看 star 继续采用。

### Replit Agent
- 本周动态：Replit 本周最明确的新动态不是 Agent core release，而是 2026-07-29 发布 `Introducing Replit Design`。官方博客列表同时显示 2026-06-23《Closing the loop: Evaluating and improving Replit Agent at scale》作为背景材料：Replit Agent 面向“从自然语言 idea 直接生成可运行 app/design/slides/mobile app/connected artifacts”的 vibe coding 用户，评估不能只看单一 benchmark，而要围绕用户点击后的 app 是否真的工作建立持续改进闭环。Replit Agent docs 当前将 Agent 定位为“turns your ideas into apps, designs, slides, and more, all from plain language”，支持 Web、Mobile、Slides、Animation、Design、Data Visualization、Automation、3D Game、Document、Spreadsheet 等输出类型。6月的 skills/custom instructions、Databricks/Microsoft Fabric 企业数据集成、Package Firewall、Shopify storefront、SEO Agent 等背景更新说明 Replit Agent 正在从生成 demo 扩展到部署、设计、增长、安全和企业数据治理，但在本周窗口内没有新的 Agent benchmark 或核心工程 release。
- 工程与产品分析：
  - 产品形态：从自然语言创建完整应用/设计/文档/自动化的云端 Agent 工作台，面向非专业开发者和企业业务团队。
  - 工程架构：Agent 在 Replit 云开发环境中生成、运行和发布项目；docs 展示多输出类型，Package Firewall、Security Center、Databricks/Microsoft Fabric、Shopify/SEO 等背景能力体现从开发到部署/增长/治理的闭环。
  - 生态/采用：与 Claude、Databricks、Microsoft Fabric、Shopify、Socket、Replit Design/Slides/Docs 等生态连接；适合“从 idea 到 published app”的端到端 workflow。
  - 风险/限制：本周没有公开新的任务完成率或评测数据；Replit Agent 的成功标准高度依赖生成 app 的真实交互质量、安全依赖、数据权限和部署运维，而不是代码 patch benchmark。
- 关键数据：Replit Blog 本周条目：2026-07-29 `Introducing Replit Design`；背景文 2026-06-23 讨论 Agent evaluation loop；docs 显示 Agent 可生成 Web/Mobile/Slides/Animation/Design/Data Visualization/Automation/3D Game/Document/Spreadsheet。未公开本周 Agent 成功率新数字。
- 原文链接：[Replit Blog](https://replit.com/blog)；[Replit Agent docs](https://docs.replit.com/replitai/agent)；[Evaluating Replit Agent at scale（背景）](https://blog.replit.com/evaluating-and-improving-agent-at-scale)
- 影响判断：Replit 本周应归入“产品边界扩展/观察”：Design 让 Agent 输出从代码进一步覆盖视觉与产物形态，但本周缺少可核验的核心 Agent 工程指标。它的长期看点是是否能把 evaluation loop、security、data governance 与 app publishing 结合成低门槛生产平台。

### 其他本周活跃编码 Agent（Gemini CLI / SWE-agent / Amp）
- 本周动态：本周搜索和 GitHub API 均遇到额度限制，未能稳定完成 Gemini CLI、SWE-agent、Sourcegraph Amp 的逐项深度核验；因此不将其作为“有料对象”写入 TOP 事件。固定补充核验口径包括 GitHub/官方 changelog/search；在本期已核验资料中，本周编码 Agent 主线主要集中在 Claude Code、Codex、Cursor、Devin Desktop、Cline、OpenCode、Aider。SWE-bench 方向已由评测与基础工程章节覆盖，本周未见 SWE-bench 官方重大新增；OSWorld/WebArena/τ-bench/StealthBench 等评测与安全红队也在 评测章节单独说明。
- 工程与产品分析：
  - 产品形态：Gemini CLI、SWE-agent、Amp 均属编码/软件工程 agent 观察池，但本周缺少足够原文支撑。
  - 工程架构：待后续核验其 MCP、sandbox、IDE/CLI、benchmark、模型路由与企业权限能力。
  - 生态/采用：暂不采纳搜索摘要或二手标题为事实。
  - 风险/限制：搜索限流与 GitHub API 403 是本周数据缺口；按周报铁律，缺口应标注而不是补旧闻。
- 关键数据：未公开/未稳定获取。
- 原文链接：[SWE-bench](https://www.swebench.com/)；[GitHub Search](https://github.com/search)
- 影响判断：本周不应把观察池项目硬写成重大动态。后续可在搜索额度充足时单独补充 Gemini CLI/Amp/SWE-agent 的 release 与 benchmark。

## 开源 Agent 框架与项目

### OpenClaw
- 本周动态：本周有重大公开动态。GitHub Releases 显示 `2026.7.2`（预发布）在本周发布，主题不是单点功能，而是把个人 Agent 从“能聊天/能调用工具”推向“可长期运行的本地控制平面”。release highlights 覆盖状态安全与恢复、持久化 channel delivery、session rewind/branching、Interactive MCP Apps/dashboard、跨 web/channel/macOS/native apps 的结构化提问与审批、会议与 realtime Talk、Wear OS companion，以及 onboarding/local inference。尤其值得注意的是：持久化消息入口和 dead-letter recovery 覆盖 Telegram、Signal、Slack、QQBot、Twitch、Synology Chat、Tlon、IRC、Zalo User；MCP Apps 被设计成带 ticket、bound tools/resources、bounded context updates 的交互式应用；session 级 rewind/fork 与 Codex 上游 session fork 说明其正在吸收 Claude Code/Codex 式长任务开发体验。README 也明确 OpenClaw 是 personal AI assistant、本地优先 Gateway、25+ channel、multi-agent routing、sandboxing、skills、nodes、Canvas 与 OAuth/多 provider 模型管理。风险在于它把远程消息入口、主机工具、沙箱、审批、语音/会议和多端节点聚合到同一 Gateway，安全边界与配置复杂度显著高于库型框架；官方 README 也反复提醒 inbound DMs are untrusted、远程暴露前阅读 security/exposure runbook，并建议 non-main sessions 进 sandbox。
- 工程与产品分析：
  - 产品形态：面向个人/单用户的开源本地优先 AI assistant/runtime，既有 CLI/Gateway，又覆盖 Telegram/WhatsApp/Slack/Discord/QQ 等通道、桌面/移动节点、Canvas、Talk/Voice Wake、skills 与 dashboards。
  - 工程架构：Gateway 是控制面，负责 sessions/channels/tools/events；插件化 channel 与 nodes 接入外部世界；Agent 可在主会话直接使用 host 工具，非主会话可按 `agents.defaults.sandbox.mode: "non-main"` 进入 Docker/SSH/OpenShell 沙箱；本周 release 强化 SQLite snapshot、quarantine store、dead-letter recovery、session branch/fork、MCP Apps ticket 与审批队列。
  - 生态/采用：README 列出 Anthropic/OpenAI/Google/xAI/OpenRouter/GitHub Copilot/MiniMax 等 provider 与 subscription OAuth；与 Codex、Claude 工具请求、MCP、ClawHub skills、QQ/Telegram/Slack 等形成生态关系。
  - 风险/限制：功能面非常宽，生产使用依赖用户正确配置 DM allowlist、sandbox、provider auth、远程暴露与审批；本周 release 为 pre-release，部分新能力可能仍处于快速迭代稳定化阶段。
- 关键数据：GitHub README/release 页面核验：OpenClaw 组织有 87 repositories（搜索结果，2026-08-03）；README 声明支持 25+ channels、Runtime Node 24.15+ recommended / Node 22.22.3+ / Node 25.9+；release `2026.7.2` 覆盖上百 PR/issue 链接。stars/forks 因 GitHub API rate limit 未能稳定直查，标注未公开。
- 原文链接：
  - [openclaw/openclaw README](https://github.com/openclaw/openclaw)
  - [OpenClaw Releases](https://github.com/openclaw/openclaw/releases)
  - [OpenClaw docs](https://docs.openclaw.ai)
- 影响判断：OpenClaw 本周的价值不在 GitHub 热度，而在把“个人 Agent 操作系统”所需的可靠性层补齐：状态恢复、消息持久化、审批、分支会话、MCP Apps 和沙箱同时推进。若后续稳定，可能成为 Claude Code/Codex 类工具与日常通信入口之间的本地中枢；短期最大挑战是安全默认值、配置可理解性和多端质量一致性。

### LangGraph / LangChain Agents
- 本周动态：本周有连续工程型 release。LangGraph Releases 显示 2026-07-28 发布 `1.2.10`，2026-07-30 发布 `checkpointpostgres==3.1.1` 与 `checkpointsqlite==3.1.1`。核心变化集中在 durable agent graph 的状态与可观测：`feat(langgraph): type v3 stream_events return and native projections`，以及 checkpoint Postgres/SQLite 修复 `scope namespace matching to segment boundaries`，Postgres/checkpoint 还新增 `omit_expired` 用于读取时跳过 expired rows。此前 1.2.8/1.2.9 已修复 delta channel/updateState/snapshot 相关问题，本周 1.2.10 表明 LangGraph 正在处理流事件、状态投影、checkpoint namespace 这类生产 Agent 最容易踩坑的边界条件。LangChain 本体 Releases 同周发布 `langchain-core==1.5.2/1.5.3`、`langchain-anthropic==1.5.3`、`langchain-fireworks==1.5.2` 等，重点是 LangSmith Gateway env var 回退、Anthropic streaming signature_delta 保留空 thinking 字段、剥离不支持的 system content blocks、Claude Opus 5 支持、OpenAI profile 修正和工具 token counting cache。二者合看，LangChain/LangGraph 从“Agent 抽象”继续向 agent engineering platform 下沉：模型 provider 兼容、gateway、trace/stream、checkpoint 是主线。
- 工程与产品分析：
  - 产品形态：LangChain 是 agent engineering platform 和模型/工具/chain 基础库；LangGraph 是面向有状态、多步、可恢复 agent/workflow 的图执行框架与部署生态。
  - 工程架构：LangGraph 以 graph/node/edge/state/checkpointer/stream 为核心，本周围绕 v3 stream events、TracePolicy 回退/调整、checkpoint Postgres/SQLite namespace 边界和 expired row 读取优化；LangChain core/provider packages 则处理 model gateway、tool schema/token counting 与 Anthropic/OpenAI/Fireworks profile。
  - 生态/采用：LangChain 生态与 LangSmith、Anthropic/OpenAI/Fireworks/OpenRouter 等 provider 深耦合；LangGraph 是大量企业自建 Agent 与 LangChain Agents 的状态层，checkpoint 修复直接影响生产恢复和多租户 namespace 安全。
  - 风险/限制：release 粒度细且频繁，工程团队需要 pin 版本并回归 stream/checkpoint 行为；TracePolicy 相关 PR 出现 expose/drop/revert，说明 tracing API 仍在调整。
- 关键数据：GitHub API 查询（2026-08-03）：`langchain-ai/langgraph` 38,707 stars、6,526 forks、669 open issues、pushed_at 2026-08-02T00:51:22Z、本周 4 commits（API per_page=100 计数）；`langchain-ai/langchain` 143,258 stars、23,861 forks、453 open issues、pushed_at 2026-08-02T22:01:07Z、本周 24 commits。contributors 总数因 GitHub API contributors endpoint 在额度/分页下返回不可靠，未采用。
- 原文链接：
  - [LangGraph Releases](https://github.com/langchain-ai/langgraph/releases)
  - [LangChain Releases](https://github.com/langchain-ai/langchain/releases)
  - [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph)
  - [langchain-ai/langchain](https://github.com/langchain-ai/langchain)
- 影响判断：本周 LangGraph/LangChain 的动向是“基础设施打磨”，对终端用户不显眼，但对生产 Agent 很关键：stream event 类型、checkpoint namespace、gateway env var 与 provider edge case 决定长任务是否可观察、可恢复、可安全隔离。它进一步巩固 LangGraph 在 durable workflow agent 中的事实标准位置。


### Microsoft AutoGen
- 本周动态：本周无重大公开动态。核验范围包括 `microsoft/autogen` GitHub 仓库 API 元数据、releases/commits 活跃度快照与项目 README/官方定位。GitHub API 查询（2026-08-03）显示该仓库 `pushed_at` 停留在 2026-04-15T11:59:09Z；在本周时间窗内未发现 release，API commit 查询为 0。本周也未在固定核验源中看到 AutoGen 对 MCP/sandbox/memory/HITL/多 Agent 编排等方向的公开重大架构变更。AutoGen 仍是 Microsoft 早期推动 multi-agent conversation、assistant/user proxy/group chat 等范式的重要开源项目，但就本周周报而言，应归为观察/静默，而不把既有影响力误判为本周动态。
- 工程与产品分析：
  - 产品形态：面向开发者的 multi-agent programming framework，历史上强调多个 agent 通过 conversation 协作完成任务。
  - 工程架构：核心抽象为可对话 agent、group chat、tool/code execution 等；但本周未见公开架构更新或 release notes。
  - 生态/采用：Microsoft 背书与早期社区规模仍然使其具备背景价值；但当前生态热点更多转向 LangGraph、OpenAI Agents SDK、Dify、CrewAI 等更高频维护项目。
  - 风险/限制：本周 GitHub 活跃度低，若企业选型应核查 Microsoft 是否有新包/新仓库迁移或文档转移，避免基于旧仓库做长期承诺。
- 关键数据：GitHub API 查询（2026-08-03）：60,172 stars、9,065 forks、970 open issues、pushed_at 2026-04-15T11:59:09Z、本周 commits 0、releases 0；来源 [microsoft/autogen](https://github.com/microsoft/autogen)。
- 原文链接：
  - [microsoft/autogen](https://github.com/microsoft/autogen)
  - [AutoGen releases](https://github.com/microsoft/autogen/releases)
- 影响判断：AutoGen 仍是多 Agent 框架史上的关键项目，但本周没有足够新增事实进入“有料”正文。建议在后续周报继续监测是否出现仓库迁移、重启或 Microsoft 官方新 Agent SDK 替代路线。

### CrewAI
- 本周动态：本周有多次 release，主要围绕工具调用可靠性、skills 生态、长任务等待、观测与安全依赖修复。GitHub Releases 页面在本周时间窗内展示 `1.15.7a1/1.15.7/1.15.8/1.15.9/1.15.10` 等连续版本：`1.15.7` 系列修复 registry skills 通过 runtime CrewAI+ client 解析、GPT-5.6 tools + `reasoning_effort` 400、Responses API path 的 tool calling、responses-only models 404，并 bump `bedrock-agentcore` 以修复 CVE-2026-16796；同时 emit skill usage events 用于 observability。`1.15.8` 增加 `WaitTool`，用于长时间运行 job 的暂停/等待，并修复 FileWriterTool、E2B 工具 env var 要求；`1.15.9`/`1.15.10` 继续推进 skill usage events、progressive disclosure for skills，并让 tool failures 不再被报告为 success，flow 失败时 emit `FlowFailedEvent`。这些变化说明 CrewAI 正在从“角色扮演多 Agent 编排库”转成可被 Studio/Skills Registry/CrewAI+ 运行时托管的工作流产品：失败语义、skills 分发、E2B 执行环境和 Responses API 兼容比新增 agent 抽象更重要。
- 工程与产品分析：
  - 产品形态：Python multi-agent orchestration framework + CrewAI 平台/Studio/Skills Registry 生态，面向团队将 agents、tasks、tools、flows 组合成可运行流程。
  - 工程架构：核心是 Agent/Crew/Task/Flow/Tool；本周重点在 tool calling path、flow failure event、execution hooks、skills resolution、WaitTool、E2B 工具和 observability event，显示运行时边界逐步产品化。
  - 生态/采用：与 OpenAI Responses API、E2B、Bedrock AgentCore、CrewAI+ client、Skills Repository 相连；skills 从实验态转入更正式分发，使社区工具可复用性增强。
  - 风险/限制：release 高频且涉及模型新特性兼容，企业使用需锁版本并验证 tool failure/flow failure 语义；CrewAI+ client 与 registry 能力也意味着开源/云端边界需要看清。
- 关键数据：GitHub API 查询（2026-08-03）：56,521 stars、8,044 forks、747 open issues、pushed_at 2026-08-02T22:40:22Z、本周 23 commits；本周 releases：1.15.10（2026-07-31T14:57:37Z）、1.15.9（2026-07-30T05:45:26Z）、1.15.8（2026-07-28T15:06:04Z）、1.15.7/1.15.7a1（2026-07-26 UTC，对应北京时间 2026-07-27 凌晨）。来源 [crewAIInc/crewAI releases](https://github.com/crewAIInc/crewAI/releases)。
- 原文链接：
  - [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI)
  - [CrewAI Releases](https://github.com/crewAIInc/crewAI/releases)
  - [GitHub Advisory GHSA-j6g5-3hh3-pgw8](https://github.com/advisories/GHSA-j6g5-3hh3-pgw8)
- 影响判断：CrewAI 本周的核心信号是“运行时产品化”：它正在把失败事件、skill usage、skills registry、WaitTool 和外部执行环境补齐，降低多 Agent 流程上线后的黑盒风险。短期竞争点不是抽象是否优雅，而是谁能把工具失败、模型 API 变化和长任务等待处理得更稳。

### Dify
- 本周动态：本周有重大 release：`v1.16.1 - Bug Fixes and Security Enhancements`。这次更新非常贴近企业生产：新增 workflow tool node multi-select、workflow run logs/error 中点击 `node_id` 定位画布节点、workflow block selector 键盘导航/分类预览/搜索体验、agent app 从 sidebar 导出 DSL YAML、knowledge/RAG document processing tracing。Bugfix 覆盖 workflow collaboration、RAG/Knowledge、Agent、Web App/UI、API/Backend 多层，其中 Agent 相关包括 preview conversation 不继承旧 ID、chat input 不被 history 更新替换、保留完整 model usage pricing、agent execution logs 展示 workflow node runs、agent monitoring stats 包含 workflow runs、阻止 unpublished agents 被 workflows 使用。安全增强是本周最大看点：Agent local sandbox 加 dedicated Squid forward proxy 与 strict ACL，禁止 sandbox 直连内部服务，仅允许 API `/files/` 与 agent_backend `/agent-stub/`，且短期 token 保护；API 与 agent backend 改用 `DIFY_AGENT_API_TOKEN / AGENT_BACKEND_API_TOKEN` bearer auth；Jinja2 workflow code node 改用 SandboxedEnvironment；修复 React Server Components DoS、email validator trailing newline bypass 等。release 还给出 Docker Compose 网络变化、4 个 additive migrations、recent apps endpoint 约 69% 延迟降低（3.2x faster）等细节。
- 工程与产品分析：
  - 产品形态：面向企业/团队的开源 LLM app、Agentic workflow 与 RAG pipeline 平台，可云端/VPC/自托管，提供可视化 workflow、agent app、知识库、插件和监控。
  - 工程架构：前端 workflow canvas + 后端 API/worker + agent_backend + local_sandbox/plugin 服务；本周通过 sandbox proxy network、agent_sandbox_network、bearer token 和 SandboxedEnvironment 加固内部服务边界，同时增强 workflow/agent logs 与 RAG tracing。
  - 生态/采用：Dify 的价值在低代码 agent/workflow/RAG 生产化；DSL YAML 导出便于版本控制，MCP tool output_schema bugfix、tool provider type contracts 和 external knowledge validation 说明其正与工具生态、MCP/插件生态继续耦合。
  - 风险/限制：新增 `DIFY_AGENT_API_TOKEN` 默认值明确“不安全，生产必须替换”；Docker Compose 网络与 env 变化要求运维升级认真执行，否则安全增强可能落空；协作编辑和 draft 保存仍是复杂高风险区。
- 关键数据：GitHub API 查询（2026-08-03）：151,112 stars、23,849 forks、934 open issues、pushed_at 2026-08-03T01:54:25Z；本周 commits API per_page=100 已达 100（实际可能更多）；release `1.16.1` published_at 2026-07-28T03:43:51Z。Release 原文称 recent apps endpoint 延迟降低约 69%、3.2× faster、SQL queries 从 19+ 降至 1 projection SELECT、response size 约降 50%；含 4 个 additive migrations。来源 [Dify v1.16.1 Release](https://github.com/langgenius/dify/releases/tag/1.16.1)。
- 原文链接：
  - [Dify v1.16.1 Release](https://github.com/langgenius/dify/releases/tag/1.16.1)
  - [langgenius/dify](https://github.com/langgenius/dify)
- 影响判断：Dify 本周是开源 Agent 平台里最典型的“生产安全补课”案例：sandbox SSRF/内网访问、API-agent_backend token、Jinja2 沙箱、协作保存与监控全部触及真实企业上线问题。它证明可视化 Agent 平台的竞争壁垒正在从“能拖流程”转向“多人协作、权限边界、日志追踪和升级安全”。


### LlamaIndex Agents
- 本周动态：本周无重大公开动态。核验范围包括 `run-llama/llama_index` GitHub API 元数据、commits、releases 页面与 release notes。GitHub API（2026-08-03）显示仓库本周有 2 commits、`pushed_at` 为 2026-08-01T08:59:09Z，但 releases 页面最新主要 release notes 显示为 2026-03-16，未发现 2026-07-27~2026-08-02 时间窗内的重大 release。该项目在 Agents/RAG/OCR/document agent 方向仍是重要背景：release notes 中可见其长期模块包括 agentmesh、Azure agent、callbacks/observability integrations、core chat_engine/retrieval/structured_predict 等；但这些不是本周新增。就本周标准，LlamaIndex Agents 缺乏可写入“有料对象”的 release、安全修复、架构变化或采用事件。
- 工程与产品分析：
  - 产品形态：以文档/RAG/索引/检索增强为核心的 Python 框架，延伸到 document agent、chat engine、callbacks 和多种数据/embedding/vector backend 集成。
  - 工程架构：模块化 package 体系，core + integrations + callbacks + agents；Agent 侧通常依赖工具化检索、query engine、chat engine 和 workflow/agent extensions。
  - 生态/采用：在 RAG 与文档 agent 生态中基础设施地位强，集成众多 observability providers、embedding/vector backends；但本周未见新的生态事件可确认。
  - 风险/限制：本周 release 信息滞后于代码推送，说明不能仅以 push 活跃判断产品变化；选择 LlamaIndex Agents 仍需结合具体 package 版本与 changelog。
- 关键数据：GitHub API 查询（2026-08-03）：51,321 stars、7,858 forks、608 open issues、pushed_at 2026-08-01T08:59:09Z、本周 commits 2；本周 releases 0。来源 [run-llama/llama_index](https://github.com/run-llama/llama_index)、[releases](https://github.com/run-llama/llama_index/releases)。
- 原文链接：
  - [run-llama/llama_index](https://github.com/run-llama/llama_index)
  - [LlamaIndex Releases](https://github.com/run-llama/llama_index/releases)
- 影响判断：LlamaIndex 本周适合作为“静默但需继续观察”的基础设施项目。它的价值仍在 RAG/document agent 生态，不应因本周缺少 release 而忽视，但周报正文不宜把旧有能力包装成新动态。
### Google ADK
- 本周动态：本周有重大 release。`google/adk-python` 在本周发布 `v2.6.0`（release 页面标注 2026-07-29/30）和 `v2.6.1`，同时还有 `v1.37.0`。README 明确 ADK 2.x 的 breaking changes：agent API、event model、session schema 变化；并把产品定位为 code-first Python toolkit，用于 building/evaluating/deploying sophisticated AI agents。2.x 架构重点是 Workflow Runtime（graph-based execution engine，支持 routing、fan-out/fan-in、loops、retry、state management、dynamic nodes、HITL、nested workflows）与 Task API（agent-to-agent delegation、多轮 task mode、single-turn controlled output、mixed delegation、HITL、task agents as workflow nodes）。本周 `v2.6.0` 新增/强化 per-invocation auth headers for A2A agent cards、`adk deploy agent_engine --extra_packages`、多种 ADK evaluation samples（home automation、basic/rubric/custom metrics、LLM judge、user simulation、audio eval）、BigQuery graph skill、agent identity auth manager 3-legged OAuth finalize、state_delta support for LiveRequest、ManagedAgent instruction/system_instruction、Eventarc Advanced toolset、OCI Generative AI provider、A2A metadata symmetry、Agent Engine telemetry、transitive dependency protection constraints files，以及 ReflectAndRetryModelPlugin 用于 self-healing model errors。Bugfix 中可见 task cancellation、ParallelAgent cancellation、dynamic tools prompt cache、artifact namespacing、A2A response stream close、GKE code sandbox credential 不挂载、resumability checkpoints 等。`v2.6.1` 则继续补 ADK CLI telemetry grouping/TTL、TTY connectivity、long-running web servers telemetry 和 tool confirmations 复验问题。
- 工程与产品分析：
  - 产品形态：Google 官方 code-first Agent Development Kit，提供 Python SDK、CLI、Web UI、Agent Engine/Google Cloud 集成、evaluation samples 与 workflow/task API。
  - 工程架构：Agent + Workflow 双核心；graph runtime 管理状态、路由、重试、动态节点与 HITL；Task API 做结构化 agent-to-agent delegation；本周围绕 A2A、Agent Engine telemetry、OAuth/auth manager、BigQuery/Eventarc tools、Live mode state_delta 与 evaluation 体系扩展。
  - 生态/采用：与 Google Cloud Agent Engine、BigQuery、Eventarc、OCI provider、A2A、MCP/remote agent registry 等生态相连；README 推荐 companion constraints files 保护 transitive dependency，说明其面向企业部署。
  - 风险/限制：2.x 有 breaking changes，sessions 只保证 ADK 2.0 对 1.28+ 可读、旧 1.x 不兼容；telemetry 增强需要用户关注 consent/status；Google Cloud 生态耦合可能使非 GCP 部署团队需评估成本。
- 关键数据：GitHub API 查询（2026-08-03）：20,978 stars、3,783 forks、595 open issues、pushed_at 2026-08-01T01:48:15Z；本周 releases：v2.6.1（2026-07-31T21:14:57Z）、v2.6.0（2026-07-30T17:58:27Z）、v1.37.0（2026-07-30T18:10:52Z）。README 声明 Python 3.10+，release cadence roughly bi-weekly。来源 [google/adk-python releases](https://github.com/google/adk-python/releases)、[README](https://github.com/google/adk-python)。
- 原文链接：
  - [google/adk-python](https://github.com/google/adk-python)
  - [Google ADK Releases](https://github.com/google/adk-python/releases)
  - [ADK Docs](https://google.github.io/adk-docs/)
- 影响判断：Google ADK 本周是“官方云厂商 Agent SDK”路线的强信号：workflow graph、Task API、A2A、evaluation、Agent Engine telemetry 和 cloud toolsets 正在同一套 SDK 中合流。它对企业开发者的吸引力在于部署/评估/云集成闭环；短期风险是 2.x 破坏性迁移与 Google 生态绑定。


### OpenAI Agents SDK / Swarm
- 本周动态：OpenAI Agents SDK 本周有重大 release，Swarm 本周无新增且已被官方标注为由 Agents SDK 替代。OpenAI Agents SDK README 定位为 lightweight yet powerful framework for multi-agent workflows，provider-agnostic，支持 OpenAI Responses/Chat Completions API 与 100+ LLMs；核心能力包括 Agents、Sandbox agents、Realtime agents、Voice agents、Agents as tools / Handoffs、Tools（functions/MCP/hosted tools）、Guardrails、HITL、Sessions、Tracing。Releases 本周集中在 `0.19.0/0.19.1/0.19.2`：`0.19.0` 是关键版本，新增 `agents.tool.ProgrammaticToolCallingTool`，让支持的 OpenAI Responses models 生成 JavaScript 协调 eligible tools，并支持 per-tool `allowed_callers`、structured function-tool outputs，并与 Runner streaming、guardrails、approvals、sessions、RunState 集成；同时加入 `agents.decorators` 与 `@tool` alias，SDK config 统一接受 typed settings objects/dicts，强化 models/tools/MCP/Realtime/sessions/sandboxes/tracing 的敏感诊断日志脱敏，改善 AnyLLM/LiteLLM/Chat Completions compatibility，新增 VercelCloudBucketMountStrategy。`0.19.1/0.19.2` 继续补 sandbox native host path grants、MCP URL credentials/tracing/tool metadata redaction、memory session item counting（SQLite/SQLAlchemy/MongoDB/Redis/Dapr）、input guardrail tripwire 结果上报、Realtime/voice/tracing 稳定性。Swarm README 则明确 “Swarm is now replaced by the OpenAI Agents SDK… production-ready evolution… recommend migrating”。
- 工程与产品分析：
  - 产品形态：OpenAI 官方 Python multi-agent SDK，覆盖文本、沙箱长任务、realtime/voice、多模型 provider、MCP/hosted/function tools、guardrails、HITL、sessions 与 tracing；Swarm 是教育性轻量多 Agent 编排前身。
  - 工程架构：核心为 Agent/Runner/Tool/Handoff/Guardrail/Session/Tracing；本周新增 ProgrammaticToolCallingTool，把工具协调从 Python side orchestration 扩展到 Responses 模型生成 JS 计划；SandboxAgent 与 path grants/cloud mounts 说明其面向真实 workspace 操作。
  - 生态/采用：与 OpenAI Responses、Chat Completions、MCP、LiteLLM/AnyLLM、Vercel/Modal/Blaxel 等运行环境或 provider 生态相连；Swarm 到 Agents SDK 的迁移指引会把早期 multi-agent 示例用户导向新 SDK。
  - 风险/限制：Programmatic Tool Calling 是强能力也引入更复杂的工具权限/审计边界；release 中大量红线是“redact credentials / sensitive logs / fail closed / sandbox path grants”，说明默认生产使用必须重视 trace/log 泄露和 sandbox mount 策略。
- 关键数据：GitHub API 查询（2026-08-03，额度耗尽前取得）：`openai/openai-agents-python` 28,347 stars、4,435 forks、54 open issues、pushed_at 2026-08-03T01:18:12Z；`openai/swarm` 21,870 stars、2,335 forks、36 open issues、pushed_at 2026-04-15T17:10:28Z。Releases 页面列出 0.19.0/0.19.1/0.19.2 本周 changelog；README 声明 Python 3.10+。来源 [OpenAI Agents SDK releases](https://github.com/openai/openai-agents-python/releases)、[README](https://github.com/openai/openai-agents-python)、[Swarm README](https://github.com/openai/swarm)。
- 原文链接：
  - [openai/openai-agents-python](https://github.com/openai/openai-agents-python)
  - [OpenAI Agents SDK Releases](https://github.com/openai/openai-agents-python/releases)
  - [openai/swarm](https://github.com/openai/swarm)
  - [Programmatic Tool Calling guide](https://developers.openai.com/api/docs/guides/tools-programmatic-tool-calling)
- 影响判断：OpenAI Agents SDK 本周把“模型直接编排工具”的 Programmatic Tool Calling 正式纳入 SDK，可能改变复杂工具链的 orchestration 模式：从宿主程序固定 loop 转向模型生成可约束的工具协调代码。Swarm 的静默与替代声明则意味着 OpenAI 生态的多 Agent 用户应尽快迁移到 Agents SDK，并重点评估日志脱敏、MCP credentials、sandbox mounts 与 approvals。


### browser-use
- 本周动态：本周有明显工程动态，集中在 CLI 3.0、Browser Harness 与浏览器状态鲁棒性。Releases 页面显示本周 `0.13.3/0.13.4/0.13.7` 等版本：`0.13.3` Launch Browser Use CLI 3.0 powered by Browser Harness，并把 browser-use skill 随 package 发布，让 Claude Code、Codex、Cursor、Gemini、OpenCode 等 coding agents 能安装 skill 直接使用浏览器；`0.13.4` 加入 MCP server for CLI 3.0（shared MCP runner、max_dim guard），修复 navigation readiness detection、same-document navigation timeout、markdown extraction URL/long link、LLM output truncation detection/fallback LLM、BrowserErrors recoverable 与 structured error memory；`0.13.7` 继续修复 Gemini genconfig 默认参数、file:// URL、React controlled inputs 清空、cross-origin iframe extraction/filtering、selector indices across CDP sessions、DOM fanout bound、browser-state timeout 后不复用 cached DOM、payment field extraction、capture timeout 后以 minimal state 调模型，并带 Browser Harness 0.1.8。README 同周展示其产品从 Python library 扩展为 CLI + cloud agent + optimized ChatBrowserUse model，强调可被 Claude Code/Codex/Cursor/Hermes/OpenClaw 等 agent 安装 skill 使用；还声称开源 benchmark 100 real-world browser tasks，并在 Odysseys leaderboard 200 long-horizon web tasks 上 87.4% average。
- 工程与产品分析：
  - 产品形态：开源 browser automation agent/library + CLI skill + Browser Use Cloud；面向“让 AI agent 像人一样打开网页、点击、输入、填表”。
  - 工程架构：Python Agent/ChatBrowserUse + Browser Harness/CDP sessions + CLI 3.0 + MCP server/skill 安装；本周大量修复聚焦 DOM snapshot、cross-origin iframe、navigation lifecycle、cached state、recoverable error memory 和 fallback LLM，是浏览器 Agent 的真实可靠性问题。
  - 生态/采用：README 明确对 Claude Code、Codex、Cursor、Hermes、OpenClaw 等 coding agents 提供 skill 接入；MCP server 让它可作为通用浏览器能力被其他 Agent runtime 调用。
  - 风险/限制：网页自动化天然受跨源 iframe、支付字段、动态 React input、导航 readiness、captcha/stealth 限制影响；README 也把 stealth/proxy/captcha/scale 放到 cloud browsers/cloud agent，开源本地版与 hosted 版能力边界需区分。
- 关键数据：GitHub API 查询（2026-08-03，额度耗尽前）：107,622 stars、11,828 forks、323 open issues、pushed_at 2026-08-03T02:00:45Z。README 声明 benchmark 覆盖 100 real-world browser tasks；Odysseys leaderboard 87.4% average、200 long-horizon web tasks；ChatBrowserUse 平均 3-5× faster（项目 README 声明）。来源 [browser-use releases](https://github.com/browser-use/browser-use/releases)、[README](https://github.com/browser-use/browser-use)。
- 原文链接：
  - [browser-use/browser-use](https://github.com/browser-use/browser-use)
  - [browser-use Releases](https://github.com/browser-use/browser-use/releases)
  - [browser-use benchmark](https://github.com/browser-use/benchmark)
  - [Odysseys leaderboard](https://odysseysbench.com/leaderboard)
- 影响判断：browser-use 本周的意义在于把浏览器从“某个 Agent 的内置工具”拆成可通过 CLI/MCP/skill 被多个 Agent 共享的专业子系统。对开源 Agent 生态而言，这会强化“专用能力工具 + coding agent 主控”的组合；但高风险网页任务仍需要权限、账号、支付与跨源数据处理的安全策略。


### OpenHands / AutoGPT / MetaGPT / SuperAGI（按本周活跃度取舍）
- 本周动态：本组按本周活跃度取舍后，OpenHands 有公开 release，AutoGPT 有代码活跃但未发现重大 release，MetaGPT/SuperAGI 静默。OpenHands `1.8.0` 于 2026-07-30 发布，新增“从 MCP server card 启用/禁用已安装 MCP server”，修复 disabled skills 仍进入 agent context 的问题，并 bump agent-server 1.39.1、automation 1.5.0、typescript-client 1.36.1。README 显示 OpenHands 当前产品形态已转向 Agent Canvas：self-hosted developer control center for coding agents and automations，可运行 OpenHands、Claude Code、Codex、Gemini 或任何 ACP-compatible agent，支持 local/remote/cloud backends、automations（Slack/GitHub/Linear 等）、多后端切换、OpenHands Cloud/Enterprise。它同时明确警告 agent-server 直接运行在安装机器上，agent 将拥有 filesystem full access；Docker/本地安装也需要把 projects path 挂载给 agent。AutoGPT API 快照显示本周 pushed_at 活跃（2026-08-02T22:04:50Z），但未在 releases/固定核验源中看到本周重大公开 release 或架构说明；MetaGPT API 快照显示仓库已迁移/归属 FoundationAgents，pushed_at 2026-01-21；SuperAGI pushed_at 2025-01-22，二者本周无重大公开动态。
- 工程与产品分析：
  - 产品形态：OpenHands 是自托管 coding agents/automations 控制中心；AutoGPT 属于早期 autonomous agent 项目，当前本周仅观察到代码活跃；MetaGPT/SuperAGI 为历史多 Agent/自主 Agent 项目，本周静默。
  - 工程架构：OpenHands 以 Agent Canvas 前端连接多个 Agent Server 后端，Agent Server 可跑在本机/Docker/VM/云端，并可配 Automation Server 触发定时或 webhook 任务；本周 MCP card enable/disable 与 disabled skills context 修复都属于“多 agent/多工具管理平面”的安全与上下文卫生。
  - 生态/采用：OpenHands 与 Claude Code、Codex、Gemini、ACP-compatible agents、Slack/GitHub/Linear 集成，定位从单一 coding agent 扩展为 agent control center；这与 OpenClaw、browser-use 等“agent 外部工具/控制面”趋势一致。
  - 风险/限制：OpenHands 明确提示本地 agent-server 有文件系统全权限，企业应优先使用隔离 VM/Docker/权限收敛；MCP server 与 skills 的启停/上下文过滤如果处理不当会造成越权工具暴露。AutoGPT/MetaGPT/SuperAGI 本周缺乏足够公开动态，不宜因历史 star 数进入有料正文。
- 关键数据：GitHub API 查询（2026-08-03，额度耗尽前）：OpenHands 82,910 stars、10,682 forks、288 open issues、pushed_at 2026-08-02T17:36:46Z；AutoGPT 185,775 stars、46,053 forks、529 open issues、pushed_at 2026-08-02T22:04:50Z；MetaGPT（FoundationAgents/MetaGPT）69,639 stars、8,874 forks、141 open issues、pushed_at 2026-01-21T10:12:33Z；SuperAGI 17,651 stars、2,224 forks、268 open issues、pushed_at 2025-01-22T22:14:07Z。OpenHands release `1.8.0` 来源 [OpenHands releases](https://github.com/OpenHands/OpenHands/releases)。
- 原文链接：
  - [OpenHands/OpenHands](https://github.com/OpenHands/OpenHands)
  - [OpenHands Releases](https://github.com/OpenHands/OpenHands/releases)
  - [Significant-Gravitas/AutoGPT](https://github.com/Significant-Gravitas/AutoGPT)
  - [FoundationAgents/MetaGPT](https://github.com/FoundationAgents/MetaGPT)
  - [TransformerOptimus/SuperAGI](https://github.com/TransformerOptimus/SuperAGI)
- 影响判断：OpenHands 本周最值得记录的是“控制中心化”：它不只运行自己的 agent，还承接 Claude Code/Codex/Gemini/ACP agents，并用 MCP/skills/backend switching 管理能力面。AutoGPT/MetaGPT/SuperAGI 则体现开源 Agent 早期明星项目的分化：没有本周 release 或生产范式更新时，star 数不应被当作价值信号。


### Hermes Agent
- 本周动态：本周有重大 release。`NousResearch/hermes-agent` Releases 显示 `Hermes Agent v0.19.1 (v2026.7.30)`，Release Date: July 30, 2026，是 patch release，用于把自 v0.19.0 以来约 1,000+ PRs 合入稳定 tag，服务 Docker images、hosted deployments 与 fresh installs。release 明确统计：自 v2026.7.20 到 v2026.7.30，main 上约 2,789 commits、4,748 files changed、442,000 insertions、392,300 deletions；窗口主线是 gateway、voice subsystem、desktop app、installer 的 bug-fix/salvage waves，以及 Buzz/Nostr channel、FLUX3 video generation and delivery、Telegram media reliability、voice-mode regressions 等平台工作。README 定位 Hermes 为 Nous Research 的 self-improving AI agent：内置 learning loop，会从经验创建 skills、使用中改进、主动 nudges 记忆、搜索过去会话、跨 session 建立用户模型；可在 Telegram/Discord/Slack/WhatsApp/Signal/CLI 通过单一 gateway process 使用；支持 cron automations、isolated subagents、RPC tools、七种 terminal backends（local、Docker、SSH、Singularity、Modal、Daytona、Vercel Sandbox）、batch trajectory generation。v0.19.0（背景，非本周）还提供本周 patch 的上下文：first token 延迟约从 4.3s 降到 0.9s、smart approvals 默认、Bitwarden/1Password SecretSource、subagent live transcripts、delivery-obligation ledger、profile-based routing 等；v0.19.1 是这些能力进入稳定下游交付的本周标签。
- 工程与产品分析：
  - 产品形态：面向个人/团队的 self-improving autonomous agent，既有 TUI/CLI，又有 messaging gateway、desktop app、cron、skills、memory、subagents 和云/本地运行后端。
  - 工程架构：单 gateway process 聚合多平台消息；learning loop 通过 skills、memory、session search、user modeling 闭环；执行层可切换 local/Docker/SSH/Singularity/Modal/Daytona/Vercel Sandbox；本周 patch 主攻 gateway/voice/desktop/installer 稳定化与媒体/通道可靠性。
  - 生态/采用：README 显示支持 Nous Portal、OpenRouter、OpenAI、自有 endpoint 等 provider；Tool Gateway 覆盖 web search、image generation、TTS、cloud browser；兼容 agentskills.io 标准，并提供 `hermes claw migrate` 从 OpenClaw 迁移，说明其与 OpenClaw/Browser Use/skills 生态存在直接关系。
  - 风险/限制：Hermes 的 learning loop、message gateways、subagents、secret sources 与多 backends 功能面极广，安全边界依赖审批、secret provenance、sandbox 与 gateway 配置；本周 release 是 patch rollup，完整 curated notes 要到 v0.20.0，部分细节需等待后续文档。
- 关键数据：GitHub 搜索/网页核验（2026-08-03）：GitHub releases 搜索摘要显示约 Star 224k、Fork 43.4k；Star-history 搜索摘要显示 222.6k stars、42.7k forks、2.5k contributors（第三方，仅作参考）。Release v0.19.1 原文给出本周窗口约 1,000+ PRs、2,789 commits、4,748 files changed、442k insertions、392.3k deletions。GitHub API 因 rate limit 未能直查稳定 repo 数字，以上 stars/forks 标注为网页/搜索核验。
- 原文链接：
  - [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
  - [Hermes Agent Releases](https://github.com/NousResearch/hermes-agent/releases)
  - [Hermes docs](https://hermes-agent.nousresearch.com/docs/)
- 影响判断：Hermes 本周是“高速个人 Agent 平台”路线的代表：它把学习闭环、跨渠道 gateway、subagents、sandbox backends、secret sources 和自动化揉成一个可持续运行的 agent。v0.19.1 的意义是把 v0.19.0 后的大规模修复打稳定标签；但完整 release notes 延后，也意味着企业采用需谨慎等待 v0.20.0 的可审计细节。

## 浏览器 / Computer Use / 通用自主 Agent

### OpenAI Operator / ChatGPT Agent（ChatGPT Work）
- 本周动态：本周在固定核验范围内未发现“Operator”品牌本身的重大公开更新；OpenAI 官网产品页在 2026-07-30 仅出现 GPT-5.6 价格/性能新闻，API changelog 在 07-28~07-30 主要是转写模型、Terraform provider、模型价格与 Fast mode，并非浏览器/Computer Use 产品发布。但 OpenAI Help Center 于本周检索到新的/更新的“ChatGPT Work and Codex”说明页（搜索结果显示 1 day ago，查询日期 2026-08-03），它把 ChatGPT 的通用任务代理能力正式表述为 Chat、Work、Codex 三种体验：Work 用于较长、多步骤任务和成品交付，可研究主题、分析信息、创建文档/表格/演示/报告/Site；在 Web、移动端、桌面端都有云端 Work，桌面端在授权后还可使用本地文件和桌面应用。重要安全边界包括：工作区管理员可单独控制 Work Cloud、Work Local、Codex Local、浏览器使用和网络访问；桌面端本地文件需要显式授权；Work 支持一次性、定时或触发式任务，用户可查看进展、回答问题、改变方向并批准重要动作。结论是 OpenAI 本周不是发布独立“浏览器代理”，而是把 Operator/agentic 能力进一步吸收到 ChatGPT Work/Codex 体系与企业权限模型中。
- 工程与产品分析：
  - 产品形态：面向 ChatGPT 付费/企业用户的通用自主 Agent 体验；Chat 做快速对话，Work 做长任务和交付物，Codex 保持开发代理；桌面端叠加 Voice 与本地文件/应用访问。
  - 工程架构：Help Center 描述为云端 Work 与本地 Work 双形态；管理员可配置起始模型、推理级别、速度、Fast Mode、新对话行为，Work/Codex 共用 agentic usage/credits；项目上下文、文件、计划任务构成长任务运行环境。
  - 生态/采用：面向 ChatGPT Web/mobile/desktop 及 Enterprise/Edu 工作区；企业端需要 EKM 的 eligible workspaces；Codex 与 Work 在桌面端并列，降低从聊天到执行型任务的迁移成本。
  - 风险/限制：浏览器使用和网络访问为单独权限；本地文件仅桌面端且需授权；Voice 可能需要麦克风、屏幕录制/辅助功能权限；涉及登录、付款、外部网络时仍依赖用户审查与“重要动作批准”，真实可用性更像有监督代理而非完全无人值守。
- 关键数据：OpenAI API changelog：2026-07-29 发布 Terraform provider；2026-07-30 GPT-5.6 Luna 降价 80%、Terra 降价 20%、Sol Fast mode 最高 2.5× standard speed、价格为 2 倍；ChatGPT Work 页未公开任务完成率/浏览器成功率（来源链接见下，查询日期 2026-08-03）。
- 原文链接：
  - [ChatGPT Work and Codex | OpenAI Help Center](https://help.openai.com/en/articles/20001275-chatgpt-work-and-codex)
  - [ChatGPT — Release Notes | OpenAI Help Center](https://help.openai.com/en/articles/6825453-chatgpt-release-notes)
  - [OpenAI API Changelog](https://developers.openai.com/api/docs/changelog)
  - [OpenAI Product Releases](https://openai.com/news/product-releases/)
- 影响判断：OpenAI 的方向是把“通用自主 Agent”产品化为 Work，并通过企业权限、云/本地分层、审批节点来缓解浏览器/OS 操作风险。本周没有新的公开 benchmark，因此可用性判断应以“可协作、可审计的长任务工作流”而非“无监督网页任务完成率”来理解。

### Anthropic Computer Use / Claude Managed Agents
- 本周动态：本周未见 Anthropic 对 Computer Use 本身的单独发布，但平台 release notes 在 2026-07-27~08-02 前后的最近更新（07-24）直接影响 Computer Use/通用代理可用性：Claude Opus 5 上线，支持 1M token context、128k max output、thinking 默认开启，价格 $5/$25 per MTok，并支持 `computer-use-2025-11-24` beta header；同时 Mid-conversation tool changes 进入 beta，允许在保持 prompt cache 的情况下在会话中增删工具；server-side fallback 也进入 beta。Computer Use docs 明确该能力仍是 beta，提供 screenshot、鼠标、键盘控制，要求开发者在 VM/容器中运行 agent loop：Claude 提出 tool_use，应用在沙箱里执行，再返回截图/结果，直到完成。安全说明非常具体：建议专用虚拟机/容器、最小权限、避免敏感登录信息、互联网 allowlist，并对接受 cookies、金融交易、同意服务条款等真实世界后果动作进行人类确认；Anthropic 还称会对 prompt injection 截图触发分类器，必要时引导模型先请求用户确认。
- 工程与产品分析：
  - 产品形态：API 级 Computer Use 工具与 Claude Managed Agents 平台能力结合；不是面向普通消费者的一体化浏览器，而是开发者把 Claude 接入沙箱桌面、浏览器、bash、文本编辑器的代理框架。
  - 工程架构：核心是循环式 tool-use：输入用户请求、截图/环境状态、近期动作历史，模型返回鼠标/键盘/截图等工具调用；参考实现使用 Docker、Xvfb 虚拟显示、Linux 桌面、Firefox/LibreOffice 等应用、agent loop 与 web UI。
  - 生态/采用：官方 quickstart 仓库提供 computer-use-demo；GitHub 查询显示 `anthropics/claude-quickstarts` 17359 stars、3002 forks、200 open issues，created 2024-08-29、pushed 2026-07-24、updated 2026-08-03（GitHub API，查询日期 2026-08-03）。平台还通过 Bedrock、Google Cloud、Microsoft Foundry 分发 Opus 5。
  - 风险/限制：官方承认网页/图片里的指令可能覆盖用户意图导致错误；ZDR、截图分类器、用户确认只是缓解层。Computer Use 对支付、登录、隐私数据尤其敏感，企业落地必须隔离凭据、限定域名、记录每步动作并设置确认策略。
- 关键数据：Claude Opus 5：1M context、128k max output、$5/$25 per MTok；Computer Use beta header `computer-use-2025-11-24`；GitHub `anthropics/claude-quickstarts` 17359 stars/3002 forks/200 open issues（GitHub API，2026-08-03）。未公开本周新的 Computer Use 任务完成率。
- 原文链接：
  - [Anthropic Computer use tool docs](https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/computer-use-tool)
  - [Claude Platform release notes](https://docs.anthropic.com/en/release-notes/api)
  - [Models overview](https://docs.anthropic.com/en/docs/about-claude/models/overview)
  - [anthropics/claude-quickstarts GitHub](https://github.com/anthropics/claude-quickstarts)
- 影响判断：Anthropic 的本周价值不在“新演示”，而在把更强长上下文 Opus 5、动态工具配置、Managed Agents 事件流与 Computer Use 的安全边界拼到一起。它更适合企业自建受控代理环境；对于开放互联网浏览和支付闭环，Anthropic 官方仍把人类确认和沙箱隔离作为硬前提。


### Google Project Mariner / Gemini Computer Use
- 本周动态：本周核验 Google Blog、DeepMind 项目页、Gemini/AI 更新与搜索结果，未发现 2026-07-27~08-02 期间 Project Mariner 的新公开发布；最新可用的关键材料仍是 I/O 2025 期间的通用助手/Mariner 更新，以及后续（背景，非本周）的 Gemini 2.5 Computer Use model 文档。作为背景，Google 曾说明 Mariner 是从浏览器开始探索人机协作的研究原型，更新版可让一个系统的 agents 同时完成最多 10 个任务，帮助查询、预订、购买、研究，并向美国 Google AI Ultra 用户开放；其 computer-use 能力计划进入 Gemini API。Computer Use model 资料进一步揭示工程形态：模型通过 Gemini API 的 `computer_use` tool 在循环中接收用户请求、环境截图、近期动作历史，输出 click/type/scroll 等 UI action 或请求最终用户确认；客户端执行后回传新截图和 URL。Google 明确说该模型主要为网页浏览器优化，移动 UI 有潜力，但尚未针对桌面 OS-level 控制优化。
- 工程与产品分析：
  - 产品形态：Mariner 是 Google 面向终端用户的浏览器多任务 Agent 原型；Gemini Computer Use 是开发者 API/Vertex AI 形态，支撑 Mariner、Firebase Testing Agent、Search AI Mode 的部分 agentic capability。
  - 工程架构：典型闭环架构：screenshot + current URL + action history → 模型生成 UI function call/确认请求 → 客户端执行 → 回传新截图；可在本地 Playwright 或 Browserbase/cloud VM 中运行。
  - 生态/采用：Google 内部已用于 UI testing；公开 reference 为 `google-gemini/computer-use-preview`，GitHub API 查询显示 3156 stars、401 forks、34 open issues，created 2025-05-06、pushed 2026-07-28、updated 2026-08-03（查询日期 2026-08-03）。Project Mariner 面向 Google AI Ultra 美国订阅者，Gemini API/Vertex AI 面向开发者和企业。
  - 风险/限制：Google 明确把购买等动作列为需最终用户确认的高风险点，并提供 per-step safety service、system instructions 来拒绝或要求确认；禁止/防止绕过 CAPTCHA、危害系统完整性、控制医疗设备等。桌面 OS 控制不是当前强项，真实落地更偏浏览器与 UI 测试，不能简单外推为通用电脑接管。
- 关键数据：Project Mariner 背景数据：最多 10 个任务并行（Google I/O 2025 blog，非本周）；Gemini 2.5 Computer Use：官方称在多项 web/mobile control benchmarks 领先且低延迟，但正文未给表格可读数值；GitHub `google-gemini/computer-use-preview` 3156 stars/401 forks/34 open issues（GitHub API，2026-08-03）。本周无新增公开完成率。
- 原文链接：
  - [Our vision for building a universal AI assistant](https://blog.google/innovation-and-ai/models-and-research/google-deepmind/gemini-universal-ai-assistant/)
  - [Introducing the Gemini 2.5 Computer Use model](https://blog.google/innovation-and-ai/models-and-research/google-deepmind/gemini-computer-use-model/)
  - [Project Mariner - Google DeepMind](https://deepmind.google/models/project-mariner/)
  - [google-gemini/computer-use-preview GitHub](https://github.com/google-gemini/computer-use-preview)
- 影响判断：Google 的优势是把浏览器 Agent、Search/Gemini/Vertex/Firebase 测试场景统一到 Computer Use model；安全设计强调每步动作审查和高风险确认。本周静默说明商业化仍在受控扩展期，真实可用性更接近“云端浏览器+确认式执行”，而不是完全自主的 OS 级代理。


### Perplexity Comet / Personal Computer
- 本周动态：本周 Perplexity 有明确重大动态：搜索结果定位到 2026-07-27~08-02 窗口内的官方博客《Personal Computer is now available on Windows》（原站 web_fetch 被 403，已通过 r.jina.ai 打开原文全文并核对）。Perplexity 宣布 Personal Computer for Windows 上线，把其 agent platform 带到 Windows 10/11，本地文件、Microsoft Office 365 和 Web 统一到一个任务入口。官方声称自今年早些时候推出以来，Computer 已为用户完成超过 $9.4B labor-equivalent work；新版本可创建/编辑 Word、Excel 等本地文件，查找 Downloads 里的文件并移动到 File Explorer 目录，甚至从手机发起“根据今日新闻更新桌面 SpaceX Excel 模型”再在桌面完成。与 Comet 浏览器配合后，Computer 可操作网页系统填写表单、预约、安排会议。安全方面，官方表示 Enterprise 不用公司数据训练；发送邮件、删除文件等敏感动作前会提醒用户，用户能看到 Computer 正在做什么并可介入，文件在 secure sandbox 中创建，动作可审计。另一个产品页显示 Personal Computer for Windows 是“agent harness”，可跨 15+ models 编排，读取/编辑用户批准的文件夹、文件和应用，连接 400+ apps，并提供 folder scoping、per-user permissions、activity logs。
- 工程与产品分析：
  - 产品形态：Comet 是带个人 AI 助手的浏览器；Personal Computer for Windows 是桌面端通用任务 Agent，覆盖本地文件、Office、Outlook、连接器与开放 Web，Pro/Max/Enterprise 订阅可用，Windows app 分发。
  - 工程架构：官方描述为 multi-model orchestration / agent harness，跨 15+ 模型调度，结合本地文件权限、App Connectors、Comet 浏览器网页自动化与语音模式；不是单纯浏览器 sidebar，而是本地 OS 文件与云连接器混合执行。
  - 生态/采用：深度绑定 Microsoft 生态：此前已有 Microsoft 365 side panel、Teams 集成，本周扩展到 Windows；连接 Snowflake、Salesforce、HubSpot、Outlook、OneDrive 等 400+ app，目标用户是企业 finance/legal/sales 等团队。
  - 风险/限制：本地文件+网页+邮件/删除动作是高风险组合；官方缓解措施包括批准的 folders/files/apps、敏感动作提醒、sandbox、activity logs、Enterprise 不训练公司数据。但对登录、支付、跨站表单、误删/误发邮件仍需用户实时监督和 IT 权限边界。
- 关键数据：$9.4B+ labor-equivalent work（Perplexity 官方博客，2026-08-03 查询）；Windows 覆盖 10/11，博客称 Windows 生态超过 1 billion devices；产品页称 15+ models、400+ connected apps；Pro、Max、Enterprise 可用/或 rollout（官方博客与产品页，2026-08-03）。
- 原文链接：
  - [Personal Computer is now available on Windows](https://www.perplexity.ai/hub/blog/personal-computer-on-windows)
  - [Personal Computer for Windows](https://www.perplexity.ai/hub/products/computer-for-windows)
  - [Comet Browser: a Personal AI Assistant](https://www.perplexity.ai/comet)
  - [Introducing Comet](https://www.perplexity.ai/hub/blog/introducing-comet)
- 影响判断：Perplexity 是本周 C 组最明确的商业化推进：从浏览器 Comet 扩展到 Windows 本地工作台，直接挑战 Office/Windows 工作流自动化。它的真实可用性看点不再是演示中的“买椅子/订会议”，而是能否在企业权限、审计、敏感动作确认下稳定处理本地文件和连接器数据。


### Manus
- 本周动态：本周未发现 Manus 在 2026-07-27~08-02 窗口内发布新的浏览器/Computer Use 重大更新；官网、Blog、Updates、Browser Operator 功能页均已核验。Blog 最新邻近更新是 2026-07-24 Supabase connector 与 2026-07-22 Plan Mode，均早于本周窗口；Updates 页面只显示总标题无详细条目。作为背景，Manus Browser Operator 是其浏览器/网页操作核心：通过 Chrome/Edge 扩展把 Manus 接入用户本地浏览器，使用真实本地 IP、网络连接、现有登录和 active tabs，适用于 premium data sources、CRM、LinkedIn、Google Maps、Amazon order history、求职表单等需要认证会话的任务；它与 Manus 原有 cloud browser 形成“双浏览器”架构，云浏览器提供隔离、一致性和跨设备，local browser 提供已登录、已信任、少 CAPTCHA 的访问路径。安全与协作机制包括一次性 Authorize 授权、专用 tab group 实时监控、关闭 tab 即停止、动作日志/audit trail、敏感信息访问前提示用户审查。
- 工程与产品分析：
  - 产品形态：通用自主 Agent 工作台，包含 cloud browser、Browser Operator、本地/桌面入口、connectors、Plan Mode、slides/design/code 等任务模块；浏览器能力既可云端沙箱执行，也可接管本地已登录浏览器。
  - 工程架构：Browser Operator 是扩展型本地执行层；任务先由 Manus 规划，再在本地浏览器上下文里导航、点击、填表和抽取数据。Plan Mode（背景，07-22）在执行前生成可编辑 Markdown 计划，用户确认后才构建/修改，强化人机对齐。
  - 生态/采用：官网显示产品线包括 Web app、AI design/slides/image/music、Manus browser operator、Wide Research、Mail Manus、Slack integration、Team plan、SSO、API；Blog 显示大量 connectors 和 customer stories，但本周无新增重大公开动态。
  - 风险/限制：本地浏览器优势也带来登录态、付费数据源、社媒发帖、Amazon 订单、求职申请等权限风险。官方承认复杂交互如 drag-and-drop 或多步表单可能不完美；对敏感站点需用户先审查授权，并可中途关闭 tab 介入。
- 关键数据：Browser Operator 功能页发布时间 Apr 24, 2026；博客称自 2025-11-22 起对所有用户可用，推荐 Chrome/Edge；本周未公开新的完成率、用户数或商业化数字（官方 Blog/Updates/feature pages，2026-08-03 查询）。
- 原文链接：
  - [Manus Blog](https://manus.im/blog)
  - [Manus Browser Operator feature page](https://manus.im/features/manus-browser-operator)
  - [Introducing Manus Browser Operator](https://manus.im/blog/manus-browser-operator)
  - [Introducing Plan Mode](https://manus.im/blog/manus-plan-mode)
  - [Manus Updates](https://manus.im/updates)
- 影响判断：Manus 本周静默，但其 Browser Operator 仍是“用本地登录态解决网页代理可达性”的代表路线。短期优势是能访问真实工作系统；长期挑战是权限、审计、敏感动作确认和复杂网页交互稳定性，否则真实可用性会被安全风险抵消。

### Genspark / Genspark Claw / 通用任务 Agent
- 本周动态：本周 Genspark 有三条公开内容：07-27《Why Genspark Signed the Open Weights AI Letter》、07-28 影视创作者案例、07-30 教育者无代码构建案例；其中最相关的是 07-27 官方文章，它把开放权重与 agentic AI 架构直接关联，称 Agent 不是一次模型调用，而是很多步调用，不同步骤适合不同模型，Genspark AI Workspace 6.0 会在超过 70 个模型之间路由，把合适模型放到对应步骤。另据 07-20 Workspace 6.0（背景，非本周）原文，Genspark 当前架构由四层组成：SecondBrain 记忆层、Super Agent 智能引擎、Build/Office/Content Suites 执行工具层、GenTeam 人机/agent 协作层。主页与 Claw 产品页（查询日显示 Published Time: 2026-07-27）强调 Genspark Claw 是“Your First AI Employee”，有自己的 Cloud Computer、记忆用户上下文，支持 WhatsApp、LINE、Slack、Teams、Telegram、Discord，起价限时 $9.99/月并给最高 10,000 bonus credits。浏览器/电脑操作方面，旧文 Workspace 4.0 明确 Desktop 版 Claw 可通过 Computer Use 操作本地文件、应用和屏幕，通过 Browser Use 自动网页导航、填表、监控页面和跨站抓取。
- 工程与产品分析：
  - 产品形态：从 AI Browser/Super Agent 演化为 all-in-one AI workspace 与“AI employee”：桌面、移动、聊天软件、Office 插件、GenTeam、SecondBrain 共同承载通用任务。
  - 工程架构：核心是多模型/多代理编排；Workspace 6.0 明示 70+ models routing，SecondBrain 持久记忆，Super Agent 结合 Design/Code/AgentBase/Slides/Sheets/Docs/GenMail 等工具执行，Claw 则提供 Cloud Computer 和本地 Computer Use/Browser Use。
  - 生态/采用：本周案例显示教育者用 Genspark Code/Design/Speakly/Super Agent 构建 13 个 apps/websites/simulations；影视案例使用 Super Agent + GPT Image、Nano Banana、KLING、VEO 完成 AI film workflow。产品生态覆盖 Office、Google Workspace、Microsoft 365、聊天平台和内容生成。
  - 风险/限制：越多模型路由和工具连接，越需要权限最小化、数据隔离、模型选择审计和输出可追溯；SecondBrain 记忆层编译邮件、会议、聊天、文档、应用，隐私边界尤其敏感。Browser/Computer Use 的表单填写、网页监控、本地文件操作需要用户确认和回滚机制，官方本周文章未给新的安全基准。
- 关键数据：Workspace 6.0 routes across more than 70 models（Genspark 07-27 官方文，2026-08-03 查询）；Claw 限时起价 $9.99/mo、最高 10,000 bonus credits；教育案例称一名 educator 构建 13 个 apps/websites/simulations；旧背景：Workspace 4.0 描述 Computer Use 和 Browser Use。
- 原文链接：
  - [Why Genspark Signed the Open Weights AI Letter](https://www.genspark.ai/blog/why-genspark-supports-open-weight-ai)
  - [Introducing Genspark AI Workspace 6.0](https://www.genspark.ai/blog/genspark-ai-workspace-6)
  - [Genspark Claw](https://www.genspark.ai/genspark-claw)
  - [Introducing Genspark AI Workspace 4.0](https://www.genspark.ai/blog/genspark-ai-workspace-4)
  - [Genspark Blog](https://www.genspark.ai/blog)
- 影响判断：Genspark 本周的重点是“开放权重+70+模型路由”对 Agent 供应链的意义，而不是单点浏览器演示。它的竞争力在端到端工作台和多模型调度，但隐私、记忆和跨应用权限会成为企业采用的核心审查点。


### Kimi Agent / Moonshot AI
- 本周动态：本周核验 Kimi 官网、Moonshot 官网、Kimi Blog、Kimi API docs、搜索与公开报道，未发现 2026-07-27~08-02 期间 Kimi Agent/浏览器/Computer Use 产品本身的重大公开发布；Kimi Blog 最新相关技术条目是 2026-07-16 Kimi K3 与 PerceptionBench，早于本周。需要注意的是，本周外部搜索结果显示 Kimi K3 开放权重/许可讨论在 07-27 前后仍有媒体报道，但官方产品原文中可核验的是 Kimi K3 已作为“built for agentic coding & knowledge work”的模型能力，而不是独立浏览器 Agent 更新。Kimi API docs 当前推荐 Kimi K3：2.8T 参数、1M-token context、native visual understanding，适合 Claude Code 等 programming agent 场景、知识工作和深度推理；也提供 Kimi K2.7 Code（256K 上下文，文本/图像/视频输入，thinking mode）和 Kimi K2.6（general-purpose，256K，上述多模态与思考/非思考模式）。工具层面，文档列出 Tool calls、JSON mode、thinking models、OpenAI-compatible API，可用于 agent tasks、web search 和 complex workflows。
- 工程与产品分析：
  - 产品形态：当前公开信息更偏模型/API 与 Kimi web 产品入口（“Ask anything, or task an agent...”），不是已详细披露的 browser operator；主要服务 agentic coding、知识工作、长上下文推理。
  - 工程架构：OpenAI-compatible API + tool calling + reasoning_effort（low/high/max）+ 多模态输入；Kimi K3 提供 1M context 支撑长程任务，K2.7/K2.6 提供 256K 多模态与 thinking mode。
  - 生态/采用：与 Claude Code 等编程代理场景兼容是官方 docs 强调点；Kimi Blog 显示 Agent Swarm、Kimi-Researcher、Kimi-Dev 等背景研究/产品线，但本周无新 Agent 发布。
  - 风险/限制：工具调用可接 web search 和外部 API，但未见本周公开的浏览器权限确认、支付/登录边界、审计能力说明；如用于 Computer Use，需要开发者自建沙箱、权限管理和操作日志。
- 关键数据：Kimi K3：2.8T parameters、1M-token context、native visual understanding；Kimi K2.7 Code/K2.6：256K context、text/image/video input；Kimi Blog 最新相关条目 Kimi K3 日期 2026/07/16（Kimi/Moonshot 官方，查询日期 2026-08-03）。本周无公开浏览器任务完成率。
- 原文链接：
  - [Kimi](https://www.kimi.com/)
  - [Moonshot AI](https://www.moonshot.ai/)
  - [Kimi Blog](https://www.kimi.com/blog/)
  - [Kimi API Docs](https://platform.moonshot.ai/docs/)
- 影响判断：Kimi 本周对 C 组的意义是“模型底座继续 agentic 化”，而不是可核验的浏览器/OS 操作产品更新。若其 Agent Swarm/Work 类产品后续公开，评估重点应放在真实工具执行闭环、用户确认与审计，而不是只看 1M 上下文和模型榜单。

### Qwen Agent / Qwen Chat / 阿里通义
- 本周动态：本周 Qwen 官方 Blog 在 2026-07-27~08-02 窗口内没有发布浏览器/Computer Use 产品更新；最新可见条目主要是 Qwen3Guard、Qwen-Image-Edit、Qwen-Image、GSPO、Qwen-MT 等模型/安全/多模态能力。与通用 Agent 直接相关的是 Qwen-Agent 开源框架和 Qwen3Guard 安全护栏。Qwen-Agent GitHub README 显示它是基于 Qwen instruction following、tool usage、planning、memory 能力的 LLM 应用框架，含 Browser Assistant、Code Interpreter、Custom Assistant，并作为 Qwen Chat 后端；支持 Function Calling、MCP、Code Interpreter、RAG、Chrome extension。DeepPlanning benchmark（背景，非本周）给出长程旅行/购物规划任务，含 120 ZH/120 EN travel tasks、120 shopping tasks、9/15 specialized APIs、isolated Python sandbox，显示即使 frontier agentic LLM 也在长程规划上困难。Qwen3Guard 则是本周安全相关亮点：Qwen 家族首个 safety guardrail model，含 Gen 与 Stream 两种变体、0.6B/4B/8B 三种规模，支持 119 languages/dialects，Stream 可 token-by-token 实时检测。
- 工程与产品分析：
  - 产品形态：Qwen-Agent 是开发者框架而非单一消费者浏览器；Qwen Chat/Studio 是前端入口，框架提供 Browser Assistant、代码解释器、RAG、MCP 等组件。
  - 工程架构：Assistant/Agent 抽象 + function_list/tools + 本地 Docker code interpreter sandbox + MCP server 配置；BrowserQwen/Chrome extension 提供浏览器助手能力。DeepPlanning 用 Python sandbox 和 specialized APIs 做可验证长程规划评测。
  - 生态/采用：Qwen-Agent 连接 DashScope、开源 Qwen、自部署 vLLM/Ollama、MCP servers、Gradio WebUI；GitHub 页面显示项目 README 但 GitHub API 本次因 rate limit 未能取关键数字，故不写 stars/forks 数值。
  - 风险/限制：README 明确代码解释器基于本地 Docker，只挂载指定 working directory，有基础 sandbox isolation，但生产仍需谨慎；浏览器扩展/Browser Assistant 未见本周新的支付、登录、隐私确认机制披露。Qwen3Guard 可作为实时安全过滤层，但不能替代权限隔离和人类确认。
- 关键数据：Qwen3Guard：0.6B/4B/8B；119 languages/dialects；DeepPlanning：Travel 120(ZH)/120(EN)、Shopping 120(EN)、9/15 APIs、7,708 records/task travel、171 records/task shopping；leaderboard 中 Qwen-3.5-Plus avg acc 37.6（w/o thinking）/35.9（w/ thinking）（官方页面，查询日期 2026-08-03）。GitHub stars/forks 未获取（API rate limit）。
- 原文链接：
  - [Qwen Blog](https://qwenlm.github.io/blog/)
  - [Qwen-Agent GitHub](https://github.com/QwenLM/Qwen-Agent)
  - [Qwen Agent Documentation](https://qwenlm.github.io/Qwen-Agent/en/)
  - [DeepPlanning Benchmark](https://qwenlm.github.io/Qwen-Agent/en/benchmarks/deepplanning/)
  - [Qwen3Guard](https://qwenlm.github.io/blog/qwen3guard/)
- 影响判断：Qwen 的本周价值在安全护栏与开源 Agent 框架生态，而非新浏览器产品。对企业而言，Qwen-Agent 更像可组合底座：能接 MCP/代码/RAG/浏览器，但必须自己补齐权限确认、审计、登录/支付边界和生产 sandbox。

### AutoGLM / 智谱 GLM Agent
- 本周动态：本周核验 Zhipu 官网 news、BigModel docs、搜索结果及 GLM/AutoGLM 相关公开页面，未发现 2026-07-27~08-02 期间 AutoGLM 移动/浏览器 Computer Use 产品的新增官方公告。Zhipu 官网首页/新闻页本周可见的重点是 GLM-5.2：称其为新一代旗舰模型并开源，在 Artificial Analysis 综合榜单取得 51 分，与 Anthropic、OpenAI 一起位居前三，为开源模型 SOTA；还强调 Coding 能力开源 SOTA、支持 1M 无损上下文、长程任务执行更稳定，另有多模态 Coding 模型针对视觉编程与“龙虾类 Agent 任务”优化。BigModel 平台文档显示其能力覆盖模型调用、部署、微调、评测、联网搜索、知识库检索，并支持 HTTP API、Python/Java SDK、OpenAI SDK 兼容、LangChain 集成。搜索结果显示 GLM-5 GitHub 在本周有“From Vibe Coding to Agentic Engineering”相关开源动态，但这更偏模型/代码代理能力，而非 AutoGLM 产品更新。
- 工程与产品分析：
  - 产品形态：AutoGLM 作为背景是智谱面向移动/通用任务的 Agent；本周公开重点转向 GLM-5.2/GLM-5 模型与 MaaS/开发平台，而非具体浏览器或手机操作产品。
  - 工程架构：BigModel 提供模型 API、搜索增强、知识库、评测、微调和 LangChain/OpenAI SDK 接入；GLM-5.2 的 1M 上下文和 coding/agentic engineering 能力可作为通用 Agent 底座。
  - 生态/采用：智谱强调“一站式模型即服务”与“精选智能体应用”，注册享 2000万 tokens；面向企业与行业伙伴提供应用级 API 和开发套件。
  - 风险/限制：未见本周 AutoGLM 对登录、支付、手机权限、网页操作审计的新说明；若用于真实移动/网页任务，需补充用户确认、敏感动作拦截、数据最小化和操作日志。模型榜单分数不能等同于网页/OS 任务完成率。
- 关键数据：GLM-5.2 官网声称 Artificial Analysis 综合榜单 51 分；支持 1M 无损上下文；注册立享 2000万 tokens（Zhipu 官网，查询日期 2026-08-03）。本周未公开 AutoGLM 任务完成率或浏览器 benchmark。
- 原文链接：
  - [智谱官网/News](https://www.zhipuai.cn/news)
  - [BigModel 平台文档](https://docs.bigmodel.cn/)
  - [GLM-5 GitHub（搜索定位）](https://github.com/zai-org/GLM-5)
- 影响判断：AutoGLM 本周属于“静默/底座更新”状态。GLM-5.2 的长上下文和 coding-agent 能力值得跟踪，但在没有新的 AutoGLM 产品权限、安全和真实任务数据前，不应把模型榜单直接推断为通用手机/浏览器 Agent 可用性。


### 其他中国通用 Agent（固定对象补充核验）
- 本周动态：除 Kimi、Qwen、AutoGLM、Manus、Genspark 外，本周在固定核验范围内未发现其他中国“通用自主 Agent/浏览器/Computer Use”产品在 2026-07-27~08-02 发布重大公开动态。核验范围包括：中文/英文 web search（关键词覆盖 browser agent、computer use、通用 Agent、AutoGLM/Kimi/Qwen/Genspark/Manus 等）、各家官网/Blog/docs、开源框架与 benchmark 页面。搜索结果中出现的 GLM-5、Kimi K3、Qwen3Guard 等均更偏模型、安全或开发框架，不是新的 consumer/browser operator 产品；外部媒体或聚合站提及的 Kimi Work、Agentic Browser Landscape 等未作为核心事实写入，因缺少本周官方原文支撑或超出固定对象核验要求。
- 工程与产品分析：
  - 产品形态：国内通用 Agent 目前主要分为三类：模型/API 底座（Kimi/Qwen/GLM）、工作台/AI employee（Genspark/Manus）、浏览器/本地扩展或桌面接管（Manus Browser Operator、Genspark Claw 背景）。
  - 工程架构：共同趋势是多模型路由、长上下文、工具调用/MCP、云端 sandbox、本地浏览器或桌面权限桥接；但公开资料对支付/登录/隐私确认的细节披露差异很大。
  - 生态/采用：国内产品生态更强调 Office/企业应用、聊天入口、连接器、内容生产和代码/网站构建；开源框架以 Qwen-Agent 等为代表。
  - 风险/限制：本周没有新的跨产品真实任务完成率对比；浏览器登录态、CRM/付费数据库、邮件/社媒发帖、本地文件删除/移动仍是主要风险。凡未公开审计、回滚、确认、权限最小化的产品，不宜直接用于高价值交易和敏感数据。
- 关键数据：本周无新增可核验关键数字；已在各对象条目中列出 Kimi K3、Qwen3Guard/DeepPlanning、GLM-5.2、Genspark、Manus 等关键数字来源与查询日期。
- 原文链接：
  - [Kimi Blog](https://www.kimi.com/blog/)
  - [Qwen Blog](https://qwenlm.github.io/blog/)
  - [智谱官网](https://www.zhipuai.cn/news)
  - [Manus Blog](https://manus.im/blog)
  - [Genspark Blog](https://www.genspark.ai/blog)
- 影响判断：本周中国通用 Agent 的主线不是单一“浏览器代理大战”，而是模型底座、工作台、桌面/浏览器桥接三线并行。周报应把“有产品闭环且有权限说明”的 Perplexity/Manus/Genspark 与“模型或框架更新”的 Kimi/Qwen/GLM 分开评价，避免把演示能力误判为可审计的生产自动化。

## 企业垂直 Agent / 协议 / 评测 / 基础工程

### Sierra
- 本周动态：本周 Sierra 最有价值的公开动态是 2026-07-29 发布的工程博客《Agency: Secure, scalable sandboxes for agents》，直接披露其企业 Agent 基础设施的“沙箱编排层”。该文把 Sierra 的内部员工 Agent Pinecone 与面向客户 Agent 构建的 Ghostwriter 放到同一底座：早期原型是单 VM 上打包的隔离沙箱，但无法承载并发、长任务、客户数据与细粒度权限；因此 Sierra 自建 Agency，而不是依赖第三方 sandbox provider。架构上，Agency 是 Kubernetes 原生应用，包含无状态控制平面与有状态 runner fleet：控制平面通过 IAM 鉴权、管理模板和权限、在 DynamoDB 跟踪 runner 状态，并将 runner 定义翻译为 K8s Pod；runner 则获得独占计算、持久卷、仓库与构建产物存储，像开发者工作站一样执行任务。安全设计很具体：LLM proxy 在沙箱外注入密钥并做 token accounting；不同 runner 类型绑定专用 IAM role；容器非 root、drop capabilities、只读根文件系统；所有外网流量走过滤 egress proxy；Pod 调度到隔离 nodepool；控制平面通信携带 pod identity 防止 runner impersonation。更关键的是 hibernation：Sierra 观察到近 8 小时活跃 runner 与近 8 天活跃 runner 数量通常相差 2~4 个数量级，于是用消息队列、FSM、checkpoint/event replay 让空闲 Agent 透明休眠/恢复，Redis Streams 往返 p50 8ms、p99 40ms。这说明企业 Agent 的瓶颈已从“模型能不能做”转向“身份、权限、数据驻留、长任务恢复和成本可控”。同周 sitemap 还显示 2026-07-31 更新 Capital on Tap 客户页，但原始发布时间为 2026-06-23，应作为背景：其 AI chat agent 处理超过 60% 对话、覆盖 12 个 journey，目标 65%，上线日超 30% containment 目标达 35%，立即要求人工的客户仅 4%。
- 工程与产品分析：
  - 产品形态：Sierra 是面向客服/客户运营的企业 Agent 平台，本周重点是内部基础设施 Agency；它服务 Pinecone、Ghostwriter 及客户 Agent 的安全运行环境，另有 Horizon 等长周期 outcome agent（背景页本周有更新但非明确新发布）。
  - 工程架构：Kubernetes 控制面 + 状态 runner；IAM、DynamoDB 状态、持久卷、LLM proxy、egress proxy、nodepool 隔离、pod identity、Redis Streams 消息通道、FSM checkpoint/replay 共同构成企业级 sandbox primitive。
  - 生态/采用：Pinecone 用于 Sierra 内部员工 Agent；Ghostwriter 用于客户 Agent 构建。Capital on Tap 案例（背景）显示 Sierra 在金融 SMB 信用卡支持中已覆盖 web/chat、将扩展 voice、web、WhatsApp、美国市场。
  - 风险/限制：自建沙箱带来运维复杂度；透明 hibernation 依赖应用 runner 正确产出 checkpoint/delta；外部 vendor 选择少虽是自建理由，但长期需要证明成本、隔离强度、事件回放一致性和事故排查能力。
- 关键数据：Agency 文称 runner 8 小时活跃量与 8 天活跃量通常相差 2~4 个数量级；Redis Streams 在线往返 p50 8ms、p99 40ms；目标 runner 规格“8+ cores, 24GiB RAM”；Capital on Tap 背景数据：350 人支持团队、24 小时运营、AI agent 处理超过 60% 对话/12 journeys、目标 65%、上线日 35% containment、人工请求 4%。来源：Sierra Agency 博客与 Capital on Tap 客户页，查询日期 2026-08-03。
- 原文链接：[Agency: Secure, scalable sandboxes for agents](https://sierra.ai/blog/agency-secure-scalable-sandboxes-for-agents)；[Capital on Tap 客户案例（背景，非本周发布）](https://sierra.ai/customers/capital-on-tap)；[Horizon 产品页](https://sierra.ai/product/horizon)
- 影响判断：Sierra 的披露给“企业 Agent 运行时”提供了可复用参考：沙箱不是只限制文件系统，而是要把身份、LLM 密钥代理、网络出口、长任务状态、成本休眠和审计边界全部产品化。对行业的启示是，Agent 平台竞争会越来越像云原生控制面竞争，客户可见的对话体验只是冰山上层。

### Glean
- 本周动态：Glean 本周在官网博客连续发布与企业 Agent 治理/编排/上下文有关的文章：2026-07-29《Enterprise context starts with indexing, but it doesn’t end there》、2026-07-30《Agent orchestration platforms compared》、2026-07-30《What organizations closing the AI impact gap do differently》、2026-07-31 UK Work AI Index 文章。最有料的是它把企业 Agent 问题明确拆成“编排 + 权限感知上下文 + 可观测/评测 + 治理反馈”。编排比较文把 Glean 定位为 enterprise platform，强调跨部门 workflow、company knowledge、business systems、approvals、permission-aware context 与 trace-level debugging；还明确对比 Gemini Enterprise Agent Platform、LangChain/LangGraph、CrewAI、Lindy AI、Microsoft Agent Framework/Foundry，并把 MCP、A2A、250+ connectors、第三方 agent/framework 支持作为开放性指标。Indexing 文章进一步说明 Glean 不是只做 embedding，而是用 unified permission-aware foundation 正规化内容与信号，保留 Salesforce opportunity 等结构化实体的字段、关系、权限、activity/freshness；并以专门索引覆盖公司数据、代码、专家、profiles、tools、calendars，再叠加 Enterprise Graph、personal graph、memory、connectors、tools。Impact gap 文章提供本周可引用的治理数据：Work AI Index 2026 调研 6,000 名美国/英国/澳大利亚数字工作者，87% 工作中使用 AI，75% 认为 AI 提升生产力并通过自动化每周约省 11 小时，但只有 13% 认为组织绩效显著改善；“transformative organizations” 平均测量 5 个维度而非 3 个，73% 跟踪 AI 使用（其他组织 44%），71% 让员工看自己的使用数据（其他 40%），93% 定期复审 AI policy（其他 55%），89% 定义谁可构建/部署 AI agents（其他 61%）。
- 工程与产品分析：
  - 产品形态：企业 Work AI 平台，覆盖 Assistant、enterprise search、agents、agent orchestration、connectors、graph、memory、AI Gateway 等；本周内容偏方法论与产品定位，但与 Glean Agents/AI Gateway/MCP 直接相关。
  - 工程架构：以统一企业索引为底座，结合语义/词法/结构化检索、权限镜像、活动与新鲜度信号、Enterprise Graph、personal graph、enterprise/personal memory、native 与 MCP-based actions，形成“system of context”。编排层强调 durable execution、branch/loop、routing、scheduled triggers、question routing、approvals、trace-level debugging。
  - 生态/采用：官方声称 250+ connectors，支持 APIs、MCP、第三方 agents/frameworks（LangChain、LangGraph）。Work AI Index 覆盖美英澳 6,000 digital workers，为其治理叙事提供市场数据。
  - 风险/限制：Glean 本周多为厂商视角比较与指数报告，存在自我定位偏差；“250+ connectors”“transformative organizations”需在具体客户部署中验证权限映射完整性、数据新鲜度、trace 可用性和 agent action 的审批边界。
- 关键数据：Work AI Index 2026：6,000 名数字工作者；87% 使用 AI；75% 称更高产，自动化每周省约 11 小时；仅 13% 认为组织绩效显著改善；transformative organizations 平均测量 5 个维度 vs 3；73% vs 44% 跟踪使用；71% vs 40% 员工可见使用数据；93% vs 55% 定期复审政策；89% vs 61% 定义 agent 构建/部署权限；Glean 对外声称 250+ connectors。来源：Glean 博客/Work AI Index 文章，查询日期 2026-08-03。
- 原文链接：[Agent orchestration platforms compared](https://www.glean.com/blog/agent-orchestration-platforms-compared)；[What organizations closing the AI impact gap do differently](https://www.glean.com/blog/work-ai-index-ai-impact-gap)；[Enterprise context starts with indexing, but it doesn’t end there](https://www.glean.com/blog/enterprise-ai-indexing-context)；[Glean Blog 列表](https://www.glean.com/blog)
- 影响判断：Glean 本周的价值不在单个新功能，而在把企业 Agent 标准化成可采购/可治理的架构清单：上下文系统、权限感知索引、编排恢复、审批、trace/debug、MCP 开放接口。它也强化了“AI adoption≠ROI”的行业判断，企业买家会更关注结果指标、质量指标和审计反馈，而不是 agent 数量。

### Harvey
- 本周动态：Harvey 本周最重要公开内容是 2026-07-27 发布的《Scaling Document Processing Across Harvey》，它披露了法律 AI 平台在真实客户文档规模下的基础工程。Harvey 指出 document processing 是 Vault、Assistant 与所有客户数据 workflow 的底座；律师查询几乎都涉及文件，范围从单文件到数百/数千文档。过去一年其处理规模从“忙碌周略低于 100 万文档”增长到最新完整周 2,480 万文档、56TB 原始文件数据，日均约 350 万文档，文档数增长 26x、数据量增长 39x。工程上，原先单一 pipeline 被拆为 extraction、chunk/embed、index 三类系统：前者受文件格式/OCR/转换支配，中间受 chunk 量与 embedding throughput 支配，后者受 vector-store 写入、blob 内存与下游 backpressure 支配。Harvey 用内部 Job Framework 替代旧队列，提供 durable workflow state、显式 timeout/retry、文件级失败隔离、queue isolation、task routing、observability、regional worker management；为文档结构引入 versioned UDF（Unified Document Format），benchmark 中 extraction latency p50 降约 19%、p90 降 17%、p99 降 11%。索引热路径还经历 primary Vector Database live migration：dual-write、shadow reads、backfills、稳定后 promotion；为降低 dual-write/embedding persistence 带来的内存和延迟，把 embed-to-index handoff 从 JSON 序列化迁移到 Arrow IPC。同期 Harvey 平台 agents 页（本周 sitemap 更新）给出业务规模：700k+ daily tasks run using agents、50M terms extracted weekly、5.8M+ documents analyzed daily；安全页更新强调 SAML SSO、audit logs、IP allow-listing、data lifecycle management、区域数据驻留、no model training、ethical walls enforcement。
- 工程与产品分析：
  - 产品形态：Harvey 是法律垂直 Agent/Assistant/Vault 平台，面向律所与企业法务的研究、文档处理、知识库、agentic workflow。Agents 产品强调“deploy a team of agents that split large tasks, work in parallel, and return review-ready outputs”。
  - 工程架构：核心是文档处理与检索基础设施：fetch/extract/OCR/metadata、chunk/embed、vector index、Vault/Assistant/workflow 检索；Job Framework 提供长任务可恢复编排；UDF 作为版本化内部文档格式；Vector DB 双写迁移、shadow reads/backfills、Arrow IPC handoff、stage-specific queues/workers/rate limits/retry budgets/observability 支撑规模化。
  - 生态/采用：连接 iManage、SharePoint、Box、Google Drive、NetDocuments 与 on-premise 文档管理；法律研究文章强调 authoritative legal databases、BigLaw Bench、Legal Agent Bench；安全上支持 EU/Switzerland、US、Australia 区域控制与 ethical walls。
  - 风险/限制：法律 AI 对 grounding、citation、negative treatment、client confidentiality 要求极高；Harvey 自述仍有 legacy vector-store path 退休、dual-write 临时成本、metrics-driven autoscaling 等未完成工作。benchmarks 需要用户用真实 matter 复核，不能只信演示。
- 关键数据：最新完整周 24.8M 文档/56TB，约 3.5M 文档/日；一年前 0.94M 文档/1.44TB；文档数 26x、数据量 39x；UDF benchmark：p50 latency -19%、p90 -17%、p99 -11%；Agents 页：700k+ daily tasks、50M terms extracted weekly、5.8M+ documents analyzed daily。来源：Harvey 工程博客/平台页/安全页，查询日期 2026-08-03。
- 原文链接：[Scaling Document Processing Across Harvey](https://www.harvey.ai/blog/scaling-document-processing-across-harvey)；[Harvey Agents](https://www.harvey.ai/platform/agents)；[AI in Legal Research vs. Traditional Tools](https://www.harvey.ai/blog/legal-ai-vs-traditional-legal-research)；[Harvey Security](https://www.harvey.ai/security)
- 影响判断：Harvey 的披露说明垂直 Agent 的护城河越来越偏“数据面工程”：文档格式、区域驻留、检索写入、OCR fallback、向量库迁移、可观测与失败隔离。法律场景中，Agent 能否规模化不是只看推理能力，而是看能否在客户数据、ethical walls 与 citation 验证约束下稳定处理海量异构文档。

### ServiceNow AI Agents
- 本周动态：本周核验了 ServiceNow 官网/博客/产品页和搜索结果，但未发现 2026-07-27~2026-08-02 时间窗内与 ServiceNow AI Agents 相关的重大公开发布或客户案例。Brave 检索 `site:servicenow.com/blogs ServiceNow AI agents July 2026` 在本周窗口返回 0 条；随后尝试直访 ServiceNow sitemap、blogs、AI agents/AI Agent Studio 产品页时多次超时，因此本周判断为“无重大公开动态”，但保留不确定性：官网访问超时可能导致少量静态更新未被抓取。已知背景（非本周）是 ServiceNow 的 AI Agent/Now Assist 路线通常围绕 ITSM、CSM、HR、workflow automation 与企业服务管理展开，重点在把 AI agent 嵌入既有 ServiceNow workflow、CMDB/record system、approval 与治理体系中。本周没有足够原始来源支持写入新增客户、价格、benchmark 或工程标准化数据。
- 工程与产品分析：
  - 产品形态：本周无重大公开动态；背景上属于 ServiceNow 平台内的企业 workflow/ITSM/CSM Agent 能力。
  - 工程架构：未见本周新增公开细节；可核验范围内没有新的 sandbox、permission、identity、audit、observability 或 benchmark 说明。
  - 生态/采用：未见本周新增客户/行业案例。ServiceNow 既有生态强在 enterprise workflow、IT/HR/customer service，但本周未找到新证据。
  - 风险/限制：本次核验受官网超时影响；若 ServiceNow 在动态内容或区域化页面发布小更新，可能未被抓取。没有原始来源则不推断。
- 关键数据：未公开/未发现本周新增。查询：Brave 搜索与官网直访，查询日期 2026-08-03。
- 原文链接：[ServiceNow Blogs（访问尝试超时）](https://www.servicenow.com/blogs.html)；[ServiceNow AI Agents 产品页（访问尝试超时）](https://www.servicenow.com/products/ai-agents.html)
- 影响判断：本周 ServiceNow 对企业 Agent 标准化议题没有可引用新增信号。后续应继续关注其是否把 agent governance、flow execution、CMDB 权限与审计能力公开成独立控制面，因为这会直接对标 Salesforce Agent Fabric、Glean AI Gateway 等路线。

### Salesforce Agentforce / MuleSoft Agent Fabric
- 本周动态：Salesforce 本周有明确的 Agentforce 动态，尤其是 2026-07-30 发布的 Moody’s 客户案例与 2026-07-27 sitemap 更新的 MuleSoft Agent Fabric/Agentforce 页面。Moody’s 案例显示，Agentforce 被嵌入服务控制台，面向 300 人 service team 提供“agentic rep support”：客户提出技术问题时，agent 给客服代表检索规格与排障信息；对话推进时分析客户产品和使用模式，提示 next best product/service；遇到账单问题时，从 Moody’s knowledge base 拉取并排序相关文章，结合 contract details 与 interaction history 在 Agentforce Service 内生成品牌语气的个性化回复，由代表审阅/编辑/发送。数据底座很典型：Moody’s 专有数据分散在 Databricks、SAP、Oracle、legacy databases；Informatica 在源头 profiling 和数据质量规则，Data 360 用 zero-copy integration 将 account、opportunity、support interactions、contract records 与专有 intelligence 连接起来，在原位置和原治理结构下查询；MuleSoft 通过 API 在系统间移动数据以保持实时性。结果页给出“Agentforce service agent went live within weeks”和“150+ employees trained to build agents”。价格页本周更新更关键：Agentforce 已公开多种计费模型，Salesforce Foundations $0；Flex Credits $500/100k credits，Agentforce action 20 credits、Voice action 30 credits；Conversations $2/conversation；Agentforce add-ons $125/user/month；Industries add-ons $150/user/month；Agentforce 1 Editions from $550/user/month（含 2.5M Flex Credits per org per year）；Agentforce User License $5/user/month（需 Flex Credits）。MuleSoft Agent Fabric 页面则把 Agentforce 与第三方 agents 纳入“single control plane”，提供 catalog/governance、budget limits、intelligent routing、MCP controls、guided determinism。
- 工程与产品分析：
  - 产品形态：Agentforce 是 Salesforce 平台内的 agentic layer，覆盖 customer-facing/employee-facing agents、Voice、Coworker、Vibes、Builder、Prompt Builder 等；Agent Fabric 是 MuleSoft 侧面向多厂商 Agent 的治理/编排控制面。
  - 工程架构：Agentforce 依托 Agentforce Service、Data 360、MuleSoft APIs、zero-copy integration 与 Trust Layer；在 Moody’s 中以现有 service console 为工作入口，agent 读取知识库、合同、交互历史、产品/使用数据并写回记录。Agent Fabric 提供跨 Agent catalog、预算/路由/MCP 控制与确定性编排。
  - 生态/采用：Moody’s 115 年历史金融情报公司，300 人服务团队；Salesforce 训练 150+ Moody’s 员工在纽约、德里、伦敦配置、测试、发布 agents。相关 Moody’s sales recon 用例还声称 sales representatives book 20% more meetings（同页关联卡片）。
  - 风险/限制：价格页说明 Data 360 credits/其他 consumption services 可能另计，示例不保证真实用量；Flex Credits 把成本映射到 action，但复杂流程 action 颗粒度与治理边界需客户监控。Agent Fabric 的“third-party agents”治理能力仍需看实际兼容深度、MCP control 粒度和审计归因。
- 关键数据：Moody’s：300-person service team、within weeks 上线、150+ employees trained；Agentforce pricing：$500/100k Flex Credits、20 credits/action、30 credits/Voice action、$2/conversation、$125/user/month add-on、$150/user/month industries add-on、Agentforce 1 from $550/user/month 含 2.5M Flex Credits/org/year、$5/user/month Agentforce User License；示例 Where-is-my-order 2 actions=40 credits=$0.20，20 requests/day*30 days=$120/month。来源：Salesforce Agentforce pricing、Moody’s customer story、MuleSoft Agent Fabric，查询日期 2026-08-03。
- 原文链接：[Agentforce Pricing](https://www.salesforce.com/agentforce/pricing/)；[Moody’s Agentforce service case](https://www.salesforce.com/customer-stories/moodys/agentic-service/)；[MuleSoft Agent Fabric](https://www.salesforce.com/mulesoft/agent-fabric/)
- 影响判断：Salesforce 本周把 Agentforce 从“能建 agent”推进到“可计费、可治理、可在大型客户内扩散”的阶段。尤其是 Flex Credits + Digital Wallet + Agent Fabric 的组合，说明企业 Agent 采购会进入 FinOps/Governance 时代：不只问效果，还要问每个 action 的成本、来源数据治理和跨 Agent 归因。

### Microsoft Copilot Agents / Copilot Studio / Microsoft 365 Copilot Extensibility
- 本周动态：Microsoft 本周在 Microsoft Learn 上有多项与 Copilot agents 相关的公开文档更新，虽然不是单一“发布会式”产品公告，但对企业 Agent 工程化很关键。2026-07-29 更新的 Microsoft 365 Copilot release notes 中，Copilot extensibility 新增/GA 信号包括：ServiceNow Connector 的 user mappings 与 query filters 可在连接配置中直接编辑，不必重建连接；Agent Builder 支持 SharePoint list 作为 agent knowledge source，每个 agent 可引用 1 个 SharePoint list、最多 20,000 items，可与其他知识源并存，但暂不支持 list attachments 和 lookup columns；custom engine agents 支持 adaptive card refresh。2026-07-30 的 usage-based billing 文档把 Copilot Credits 的企业成本治理写清楚：Microsoft 365 admin center 的 Copilot > Cost Management 可配置 billing method、tenant/monthly spending limit、per-user monthly limit、policy alerts、group/user/service scoped spending policies；Global/Billing admin 可设置 billing，AI admin/License admin 可创建 spending policies、limits/alerts 与查看 dashboard；usage-based billing 当前可解锁 Cowork 与 Work IQ API，Microsoft 正在把更多 agents/services 纳入该体验。Known issues 文档同周更新也很重要：Power Automate Flows 作为 declarative agents actions 可能不可靠且可能不返回结果；基于 custom metadata 的列表查询（如 ServiceNow tickets assigned to me）不支持；SharePoint grounding 需要 Microsoft 365 Copilot license、user auth、目标 site read 权限，否则可能静默失败；API plugins 不支持 nested objects、oneOf/allOf/anyOf/circular refs、非 Authcode/PKCE OAuth、dual auth 等；custom engine agents 还有 conversation history、attachments、proactive notifications、citation 类型等限制。
- 工程与产品分析：
  - 产品形态：Microsoft 365 Copilot、Copilot Chat、Agent Builder、Copilot Studio 新 agent experience、declarative agents、custom engine agents 与 Copilot connectors 共同组成企业 Copilot Agents 体系。
  - 工程架构：知识源覆盖 uploaded files、public websites、SharePoint、ServiceNow、Confluence、Jira、Azure DevOps Work Items、Dataverse、Azure AI Search、Copilot connectors；安全/权限依赖 M365 license、Graph/SharePoint access、user authentication、connector user mappings/query filters；成本治理通过 Copilot Credits、Cost Management、spending policies 与 alerts 实现。
  - 生态/采用：本周涉及 ServiceNow connector、SharePoint Lists、Power Automate Flows、Dataverse、Azure AI Search、Jira、Azure DevOps、Confluence 等企业系统。对微软客户而言，Agent 的采用路径更多是从现有 M365/Power Platform 管理面扩展。
  - 风险/限制：已知问题暴露出现阶段 agent extensibility 不稳定点：Power Automate action reliability、SharePoint grounding 静默失败、API plugin schema/OAuth 限制、custom engine agent 对附件/历史/主动通知/部分 citations 支持不足。SharePoint list 20,000 items 与单 list 限制也说明结构化 grounding 仍处 preview/渐进阶段。
- 关键数据：Release notes：每个 Agent Builder agent 可引用 1 个 SharePoint list、最多 20,000 items；usage billing：Cost Management 支持 tenant/user/group/service policies、monthly limits、alerts/hard caps；当前 usage-based billing setup 明确可用于 Cowork 与 Work IQ API。来源：Microsoft Learn release notes、usage-based billing、known issues、knowledge sources，查询日期 2026-08-03。
- 原文链接：[Microsoft 365 Copilot Release Notes](https://learn.microsoft.com/en-us/microsoft-365/copilot/release-notes)；[Managing AI experiences enabled by usage-based billing](https://learn.microsoft.com/en-us/microsoft-365/copilot/usage-based-billing-manage-copilot-credits)；[Known Issues in Microsoft 365 Copilot Extensibility](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/known-issues)；[Available knowledge sources for agents](https://learn.microsoft.com/en-us/microsoft-copilot-studio/agents-experience/knowledge-sources-overview)
- 影响判断：Microsoft 本周的信号是“企业 Agent 进入管理面”：数据连接、权限映射、知识源、消费额度、spending policy 和已知问题都被文档化。相比初创厂商强调平台能力，Microsoft 的优势是把 Agent 纳入 M365 admin、Entra/SharePoint/Power Platform 的既有治理流程；短板是 extensibility 表面大但约束多，需要客户在生产前逐项验证。

### 字节 Coze / 扣子
- 本周动态：本周核验了 Coze/扣子国内与海外官网、开发者文档入口、sitemap。未发现 2026-07-27~2026-08-02 期间明确的重大公开产品公告、客户案例、价格变更、工程标准化文档或 benchmark 更新。coze.cn sitemap index 在 2026-08-02T16:00:06.566Z 更新了 vibe/sitemap-1.xml，但该 sitemap 主要列出大量 gallery/detail 页面，缺少可读 lastmod/标题和可验证的“官方公告”语义；官网与开发者文档页面通过 CSR 渲染，web_fetch 只抽取到标题“扣子 - AI Agent智能办公平台 - 扣子用AI重塑生产力与工作效率 / Coze-AI Agent Intelligent Office Platform”，未能获得本周新增正文。直查页面 HTML 可见产品定位仍围绕 Agent、API、docs、MCP 等导航/资源，但没有时间窗内可引用新增。故本周写“无重大公开动态”。背景上，扣子/Coze 是字节系低/零代码 Agent 开发平台，覆盖 bot/agent 构建、workflow、plugin/API、发布渠道、知识库等，国内外站分别服务不同区域，但本周没有足够原始来源支撑更细的新增判断。
- 工程与产品分析：
  - 产品形态：低/零代码 AI Agent 智能办公/生产力平台，官网标题强调“AI Agent智能办公平台”。
  - 工程架构：本周未见新增公开架构；页面资源中可见 docs/API/MCP 相关入口，但正文无法抽取，不能推断新增能力。
  - 生态/采用：gallery/detail sitemap 大量更新说明模板/应用生态持续有内容变化，但本周未能解析出可验证的企业客户、行业落地或治理能力。
  - 风险/限制：公开信息可抓取性较差；若只依赖动态 CSR 页面，外部研究很难核验版本、发布日期、权限/审计/计费等企业采购关键点。对企业市场而言，需更多官方 changelog、docs diff、客户案例与治理白皮书。
- 关键数据：coze.cn sitemap index lastmod 为 2026-08-02T16:00:06.566Z；无本周官方关键产品数字。来源：Coze/扣子 sitemap 与官网/开发者文档入口，查询日期 2026-08-03。
- 原文链接：[扣子 sitemap](https://www.coze.cn/sitemap.xml)；[扣子首页](https://www.coze.cn/home)；[Coze 首页](https://www.coze.com/home)；[扣子 API 文档入口](https://www.coze.cn/open/docs/developer_guides/coze_api_overview)
- 影响判断：本周 Coze/扣子对企业 Agent 标准化议题缺少可引用新增。后续如果要进入企业/垂直 Agent 周报主线，应重点跟踪其 MCP、权限审计、企业工作区、私有化/数据合规、调用计费与 API changelog 是否变得更透明。

### MCP 协议与工具生态
- 本周动态：MCP 是本周 D 组最重要的工程标准化动态。GitHub releases 显示 modelcontextprotocol/modelcontextprotocol 在 2026-07-28T16:47:49Z 发布 2026-07-28 RC，随后同日 16:44:35 UTC 标记正式 2026-07-28 修订；官方 changelog 明确这是相对 2025-11-25 的重大改版。核心变化是去 session 化与 stateless：从 Streamable HTTP 移除协议级 session 和 Mcp-Session-Id；移除 initialize/notifications/initialized 握手；每个 request 都在 `_meta` 携带 protocol version、client capabilities，client/server info 也走 `_meta`；版本不匹配返回 `UnsupportedProtocolVersionError`。新增 `server/discover`，server 必须声明支持的 versions、capabilities、identity。订阅模型改为 `subscriptions/listen`，取代 HTTP GET endpoint 和 resources subscribe/unsubscribe。Tasks 从核心协议移到官方 extension `io.modelcontextprotocol/tasks`，用 `tasks/get` 轮询、`tasks/update` 处理中途输入、durable task handle 支撑 CI、batch processing、human approval 等长任务。Multi Round-Trip Requests（MRTR）替代 server-initiated requests，server 返回 `InputRequiredResult`，client 在 retry 原请求时带 inputResponses。每个 result 必须带 `resultType`。同时引入 extensions capability、OpenTelemetry trace context `_meta` 约定、deterministic tools/list 排序、Streamable HTTP 标准 request headers、CacheableResult 的 `ttlMs/cacheScope`、OAuth issuer/client credential 绑定等安全与缓存改进。官方 extension 侧还给出 Enterprise-Managed Authorization：用企业 IdP（Okta/Azure AD/SSO）集中控制 MCP server access、ID-JAG 换取 MCP access token，支持集中策略、SSO、policy enforcement、revocation 与 auditable trail。
- 工程与产品分析：
  - 产品形态：MCP 从“工具接入协议”升级为企业 Agent 的上下文/工具/授权/长任务/扩展标准。它定义 hosts、clients、servers，以 JSON-RPC 2.0 连接 resources、prompts、tools，并扩展到 Tasks、Apps、Skills over MCP、Enterprise auth。
  - 工程架构：2026-07-28 版强调 per-request metadata、stateless transport、server/discover、extension negotiation、subscriptions/listen、Tasks durable handles、MRTR、cache TTL/scope、OpenTelemetry traceparent/tracestate/baggage、Streamable HTTP headers、OAuth security。架构上更适合无状态网关、缓存、代理和企业审计。
  - 生态/采用：Sierra 本周工程文直接把 MCP Gateway 称作连接 Slack/GitHub/Salesforce/数据仓库/生产系统的统一入口；Glean、Salesforce Agent Fabric、Microsoft Copilot extensibility 均在本周材料中提到或体现 MCP/connector/agent control plane 方向。
  - 风险/限制：2026-07-28 是破坏性较强的协议时代切换；legacy initialize-based clients/servers 与 modern per-request metadata 需 dual-era 兼容。Tasks/Enterprise auth 是 extension，实际 client support 不一致；企业落地必须关注权限提示、tool 安全、server identity、token scope、审计和跨版本协商失败处理。
- 关键数据：2026-07-28 release GitHub 页面时间：2026-07-28T16:47:49Z；正式 tag 时间 2026-07-28 16:44:35 UTC；错误码 `UnsupportedProtocolVersionError` 为 -32022；Tasks statuses：working/input_required/completed/failed/cancelled；feature lifecycle 最小 12 个月 deprecation window。来源：GitHub releases、MCP 2026-07-28 changelog、versioning、Tasks、Enterprise-Managed Authorization 文档，查询日期 2026-08-03。
- 原文链接：[GitHub Releases](https://github.com/modelcontextprotocol/modelcontextprotocol/releases)；[MCP 2026-07-28 Key Changes](https://modelcontextprotocol.io/specification/2026-07-28/changelog.md)；[Versioning and Compatibility](https://modelcontextprotocol.io/specification/2026-07-28/basic/versioning.md)；[Tasks extension](https://modelcontextprotocol.io/extensions/tasks/overview.md)；[Enterprise-Managed Authorization](https://modelcontextprotocol.io/extensions/auth/enterprise-managed-authorization.md)
- 影响判断：MCP 2026-07-28 把协议从“会话式工具调用”推向“可网关化、可缓存、可审计、可跨组织治理”的企业标准。短期会带来 SDK/客户端兼容成本；中期会推动 Agent 平台把权限、trace、long-running tasks 与 IdP policy 作为基础设施，而非各自私有实现。

### Agent memory / context engineering
- 本周动态：本周没有出现一个单独命名的“Agent memory/context engineering”基础论文成为全行业事件，但多个原始来源共同把该主题推到企业 Agent 工程核心。Glean 2026-07-29 的索引文章给出最完整的企业上下文工程框架：企业 AI 不是“接入数据”即可，而是要把信息组织成 permission-aware、fresh、relevant 的系统；其 system of context 由 indexes、graphs、memory、data connectors、tools 组成。索引侧不止 embedding，而要统一跨应用内容与信号，保留 entities、identities、permissions、activity、relationships；针对 company data、code、experts、profiles、tools、calendars 用 specialized indexes，并结合 semantic、lexical、structured retrieval。Memory 被定位为跨 session/task 携带有用上下文，enterprise memory 帮助 agent 将长期工作中学到的内容应用到后续任务，personal memory 则适配个人偏好、项目、工作模式。Sierra 同周 Agency/MCP Gateway 系列也从运行时角度补齐 context engineering：MCP Gateway 统一连接 Slack、GitHub、Salesforce、数据仓库、生产系统；为避免跨客户数据污染，Sierra 建立了客户相关数据访问 audit log，用 deterministic candidate customer list、fast model 初筛、slower model 终判数据所属客户与敏感性，并阻断同一 session 中跨多个客户访问敏感数据，除非 out-of-band explicit approval。Microsoft 本周 Copilot release notes 则把 context engineering 落到知识源粒度：Agent Builder 开始支持 SharePoint list（最多 20,000 items）作为结构化 grounding；ServiceNow connector 支持编辑 user mappings/query filters，说明企业上下文工程离不开权限映射与 query scoping。
- 工程与产品分析：
  - 产品形态：不是单一产品，而是企业 Agent 的上下文层/记忆层/检索层/工具层工程范式，贯穿 Glean、Sierra、Microsoft、Salesforce 等平台。
  - 工程架构：核心组件包括 permission-aware index、enterprise/personal graph、enterprise/personal memory、connector federation、structured/semantic/lexical retrieval、MCP/tool actions、客户/租户 provenance、audit log、approval gate、query filters、zero-copy data access。
  - 生态/采用：Glean 明确以 250+ connectors 与 MCP/native actions 承载；Sierra 用 MCP Gateway 服务内部员工和客户 Agent；Microsoft 将 SharePoint/ServiceNow/Dataverse/Azure AI Search/Copilot connectors 纳入 agent knowledge source。
  - 风险/限制：上下文越丰富，越容易发生权限错配、过期数据、跨租户泄露、source authority 冲突和 silent coverage gaps。Memory 还需解决可解释删除、保留策略、用户可见性、审计和“错误记忆”纠偏。
- 关键数据：Glean Work AI Index：53% workers 称 critical information 不能通过 AI systems 访问；context-rich vs context-poor 环境中，worn out by AI 为 18% vs 50%，ship work they can’t explain 为 26% vs 54%，use unapproved tools 为 21% vs 53%，rerun prompts across tools 为 48% vs 70%。Microsoft SharePoint list knowledge source：每 agent 1 个 list、最多 20,000 items。来源：Glean/Microsoft/Sierra 原文，查询日期 2026-08-03。
- 原文链接：[Glean enterprise indexing/context](https://www.glean.com/blog/enterprise-ai-indexing-context)；[Glean AI impact gap](https://www.glean.com/blog/work-ai-index-ai-impact-gap)；[Sierra Agency](https://sierra.ai/blog/agency-secure-scalable-sandboxes-for-agents)；[Microsoft Copilot release notes](https://learn.microsoft.com/en-us/microsoft-365/copilot/release-notes)
- 影响判断：本周证据显示 context engineering 已从 RAG 提示技巧升级为企业 Agent 的系统工程：索引、权限、记忆、图谱、工具和审计必须一起设计。未来采购评估不应只问“接了哪些数据源”，而要问是否保留结构与权限、是否能解释来源和新鲜度、是否能隔离租户/客户、是否有记忆治理。

### Sandbox / permission / identity / audit / observability
- 本周动态：本周多家厂商和协议都把 sandbox、permission、identity、audit、observability 作为企业 Agent 的基础工程主线。Sierra 的 Agency 博客给出最深入的 sandbox 细节：Agent 不能用开发者 token 以 danger-full-access 无人值守运行，因此每个 runner 在 K8s pod 内隔离，使用专用 IAM role、非 root/只读 root FS/drop capabilities、过滤 egress proxy、隔离 nodepool、pod identity 防 impersonation、LLM proxy 外置密钥注入与 token accounting、persistent volume 保存代码和构建产物；再用 runner hibernation、Redis Streams、FSM checkpoint/event replay 支撑长任务低成本恢复。Glean 的 Agent Identity（背景非本周）与本周 orchestration 文章共同强调 scoped credentials、persistent presence、audit trail、approvals、permission-aware context、trace-level debugging。Salesforce Moody’s 案例展示企业数据治理路径：Informatica 在源头做 data quality，Data 360 zero-copy 保持原治理结构，MuleSoft APIs 保持数据新鲜，Agentforce Trust Layer 提供 data masking/zero retention；Agent Fabric 则将 Agentforce 与 third-party agents 纳入 single control plane，提供 catalog、budget limits、intelligent routing、MCP controls、guided determinism。Microsoft 本周 docs 更偏管理面：Cost Management 的 spending policies/alerts/hard caps，ServiceNow connector 的 user mapping/query filter 编辑，known issues 中对 SharePoint grounding 的 license/user auth/read permission 要求和静默失败警告。MCP 2026-07-28 则把 trace context、enterprise-managed authorization、server/discover identity、stateless version metadata、cache scope 等协议化。
- 工程与产品分析：
  - 产品形态：企业 Agent 安全/治理控制面，包括运行沙箱、身份凭证、权限映射、审批、审计日志、成本治理、trace/debug、协议级 version/capability/identity。
  - 工程架构：Sierra 偏运行时隔离；Glean 偏 identity/context/audit；Salesforce 偏 CRM/Data 360/Trust Layer/Agent Fabric 控制面；Microsoft 偏 M365 admin/connector/license/billing policies；MCP 偏跨平台标准化字段和扩展。
  - 生态/采用：这些能力同时出现在客服、法律、金融情报、M365、MCP 工具生态中，说明已从安全附属功能变成 Agent 采购必选项。
  - 风险/限制：安全控制多为分层拼接，真正难点是跨层归因：一个 agent action 可能经过 LLM、retriever、connector、API、approval、human edit、writeback。若 trace 和 audit 不能关联 identity、data source、prompt/context、tool call、cost 和 outcome，合规仍然不可用。
- 关键数据：Sierra runner 在线消息往返 p50 8ms/p99 40ms、活跃 8h vs 8d runner 相差 2~4 数量级；Salesforce Flex Credits 20/action、Voice 30/action，并用 Digital Wallet 近实时监控；Microsoft Cost Management 支持 monthly spending limit、per-user limit、alerts、hard caps；MCP `UnsupportedProtocolVersionError` -32022 与 OpenTelemetry `traceparent/tracestate/baggage` 约定。来源：Sierra/Salesforce/Microsoft/MCP 原文，查询日期 2026-08-03。
- 原文链接：[Sierra Agency](https://sierra.ai/blog/agency-secure-scalable-sandboxes-for-agents)；[Salesforce Agentforce Pricing](https://www.salesforce.com/agentforce/pricing/)；[MuleSoft Agent Fabric](https://www.salesforce.com/mulesoft/agent-fabric/)；[Microsoft usage-based billing](https://learn.microsoft.com/en-us/microsoft-365/copilot/usage-based-billing-manage-copilot-credits)；[MCP Key Changes](https://modelcontextprotocol.io/specification/2026-07-28/changelog.md)
- 影响判断：本周可以明确判断：企业 Agent 的“基础设施栈”正在成形，核心不是更长 prompt，而是受管运行时、身份、权限、审计、可观测与成本策略。未来领先平台会把这些能力做成统一控制面；缺少这些的 Agent builder 更适合个人/部门试点，难以进入受监管生产流程。

### SWE-bench / OSWorld / WebArena / GAIA / τ-bench / Agent 安全红队论文
- 本周动态：评测方向本周有两类重要信号：一是 τ-bench/安全红队有本周内或本月明确更新，二是 SWE-bench/OSWorld/WebArena/GAIA 本周未见重大新增但需要作为基准背景核验。τ-bench 最新 repo 已从 τ²-bench 更新到 τ³-bench，README 标注“July 2026 — v1.0.1 grading update”，其中 `banking_knowledge` 修复导致该 domain 分数与 <1.0.1 不可比；leaderboard submissions 已重新评分，旧结果可用 `tau2 evaluate-trajs --fresh-tasks` 重评。Release notes 披露此次修复包括 extra read calls 不再 zero reward、int-vs-float 参数归一、lost/stolen card gold trajectory 可实现化、交易时间顺序修复、cash-back rate 矛盾修复、task_074 ATM refund 从 $8.00 改 $14.50 等；在 re-graded leaderboard 中，gpt-5-5 pass^1 从 37.37 到 46.39（+9.02），gpt-5-4 从 30.67 到 39.43（+8.76），无 simulation 从 pass 变 fail。τ³-bench 还新增 banking_knowledge（97 tasks/698 docs）、voice full-duplex、75+ task fixes、telecom dual-control 等。安全红队方面，2026-07-28 arXiv 发布 StealthBench，14 dockerized task scenarios、8 agent models、771 evaluated trajectories，评估 offensive-security agents 的 OPSEC tradecraft；网站快照显示 overall safe success 43.8%，最高 Claude Opus 4.8 safe success 53.8%，Kimi K3 52.5%，GLM 5.2 50.4%，无模型超过 54%。OSWorld 本周无新增，但官网提示 2026-06-26 OSWorld 2.0 可用、2025-07-28 OSWorld-Verified；其旧版为 369 tasks（8 Google Drive 任务可手工配置或排除为 361）、134 execution-based eval functions，人类 72.36% vs 最佳模型 12.24%（旧论文结果）。WebArena 本周无新增，官方仍指向 self-hostable web environment 与 AgentLab/BrowserGym 改进；GAIA Hugging Face leaderboard 可访问但抓取仅显示 Space 运行信息，无本周新增可读数据。
- 工程与产品分析：
  - 产品形态：SWE-bench 评软件工程 patch；OSWorld 评真实 OS/GUI 多模态任务；WebArena 评自托管 web agent；GAIA 评通用助理难题；τ-bench/τ³-bench 评工具-用户-策略交互与语音/知识/双控制；StealthBench 评 offensive-security agents 的“成功且隐蔽”。
  - 工程架构：SWE-bench 使用 Docker 可复现 harness；OSWorld 用真实 computer environment、任务初始状态和 execution-based eval；WebArena 自托管站点+browser env+config；τ³-bench 采用 half/full-duplex orchestrator、domain policy/tools/tasks、DB outcome reward、pass^k、knowledge retrieval、voice realtime providers；StealthBench 用 Docker 场景、ATIF/OTEL trajectory、3-model judge panel、majority vote。
  - 生态/采用：SWE-bench 仍是编码 Agent 主基准；OSWorld/WebArena 是 GUI/Web Agent 主基准；τ-bench 对客服/垂直工具 Agent 更贴近企业流程；StealthBench 则把安全红队从“能否攻破”推进到“是否守 OPSEC”。
  - 风险/限制：本周 τ-bench v1.0.1 是评测可靠性的警示：少量评分/任务缺陷可让排行榜大幅移动，跨版本不可比必须显式标注。StealthBench 使用 LLM judge 评 OPSEC，需关注 judge bias 与人类专家验证；OSWorld 旧版有 Google Drive 网络依赖，WebArena 需要正确自托管环境；GAIA leaderboard 动态页面不易抓取。
- 关键数据：τ³-bench：banking_knowledge 97 tasks/698 docs、75+ fixes、v1.0.1 gpt-5-5 pass^1 37.37→46.39、gpt-5-4 30.67→39.43；StealthBench：14 scenarios、8 models、771 evaluated trajectories、770 complete stealth panels、overall safe success 43.8%、最高 53.8%、judge panel cost $62.30、total evaluation cost $345.42；OSWorld：369 tasks/361 可排除 Google Drive、134 exec eval funcs、人类 72.36%、旧最佳模型 12.24%；WebArena：812 examples。来源：各 benchmark 官方/GitHub/论文页面，查询日期 2026-08-03。
- 原文链接：[SWE-bench 官网](https://www.swebench.com/)；[SWE-bench GitHub](https://github.com/SWE-bench/SWE-bench)；[OSWorld](https://os-world.github.io/)；[WebArena](https://webarena.dev/)；[WebArena GitHub](https://github.com/web-arena-x/webarena)；[GAIA leaderboard](https://huggingface.co/spaces/gaia-benchmark/leaderboard)；[τ³-bench README](https://raw.githubusercontent.com/sierra-research/tau2-bench/main/README.md)；[τ³-bench Release Notes](https://raw.githubusercontent.com/sierra-research/tau2-bench/main/RELEASE_NOTES.md)；[StealthBench arXiv](https://arxiv.org/abs/2607.26314)；[StealthBench leaderboard](https://stealthbench.com)；[StealthBench dataset](https://huggingface.co/datasets/0xmoose/stealthbench)
- 影响判断：Agent benchmark 正在从单纯 pass rate 转向可靠性、版本可比性、长任务恢复、用户交互、语音、知识检索和安全行为评估。企业采用评测时必须记录 benchmark version、task fixes、环境依赖、judge 方法和成本，否则排行榜数字很容易误导 ROI 与风险判断。

## 下周观察点

1. **MCP 2026-07-28 兼容迁移**：重点看 Claude、OpenAI Agents SDK、Dify、browser-use、Copilot/Glean/Salesforce 等客户端/服务器是否快速支持 stateless metadata、server/discover、Tasks extension 与 enterprise auth。
2. **编码 Agent 平台化竞争**：继续跟踪 Claude Code、Codex、Cursor、Devin Desktop、Cline/OpenCode 在多会话、插件市场、MCP、browser preview、sandbox 与移动/Slack 工作流上的稳定性。
3. **浏览器/桌面 Agent 的权限边界**：重点看 Perplexity Windows、Manus Browser Operator、Genspark Claw、OpenAI Work/Anthropic/Google Computer Use 是否披露登录、支付、文件删除/邮件发送等高风险动作的审计与回滚策略。
4. **企业 Agent 计费和治理**：关注 Salesforce Flex Credits、Microsoft Copilot Credits、Glean governance、Sierra Agency/Harvey 数据面工程是否继续出现真实客户 ROI 与事故/限制披露。
5. **评测可比性**：τ-bench v1.0.1 grading update 和 StealthBench 显示 Agent benchmark 正在变复杂；后续必须记录 benchmark version、task fixes、judge 方法、成本和轨迹公开度。

## 关于本周报

本周报聚焦 Agent 产品、开源项目、框架工具、CLI/IDE、协议标准、评测基准、企业落地和开发者生态；不把企业战略、融资和公司竞争作为主轴。所有“本周动态”均以 2026-07-27 ~ 2026-08-02 时间窗内公开可核验信息为准；时间窗外信息仅作背景并已标注。开源项目进入正文必须满足 release、架构变化、安全修复、采用/集成、benchmark、社区真实工程问题或生态关系等标准之一；不把 GitHub 热度单独当作价值判断。
