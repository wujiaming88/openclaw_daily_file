# 全球 AI Agent 研究周报 · 第 10 期（2026-08-03 ~ 2026-08-09）

> **覆盖区间**：2026-08-03 ~ 2026-08-09（Asia/Shanghai，刚结束的完整自然周）  
> **覆盖范围**：编码 Agent、开源框架、浏览器/Computer Use、企业垂直 Agent、协议、记忆、沙箱、权限、审计与评测，共覆盖 48 个固定与扩展对象组。  
> **数据声明**：仅写时间窗内可核验公开信息；窗外内容只作明确背景。关键事件回到官方原文，开源数据直查 GitHub 页面/API；API 遇限流时不猜值。供应商案例与营销指标均按供应商口径标注，不与独立 benchmark 混用。

![全球 AI Agent 研究周报头图](/assets/images/2026-08-10-global-ai-agent-weekly.png)

## 本周一句话

> Agent 竞争正在从“模型会不会做”转向“系统能否安全、持续、可审计地做”：编码产品变成多 Agent 工作台，开源运行时集中修补状态、权限与供应链，企业市场开始用工作单元、成本、解决率和治理证据衡量真实价值。

## 🔥 本周 TOP 5 Agent 事件

### 1. Codex CLI 0.147.0：Agent Host 形态成型

Codex CLI 0.147.0 同时推进可移植 Agent Plugins、持久会话 sections、自动审查批准、Cursor skills 与 Claude/Cursor 会话导入，以及 MCP 2026-07-28 适配；安全侧又补齐 secret 遮蔽、陌生项目 trust、托管认证限制与插件断网失败策略。它不再只是命令行编码助手，而是逐步形成“插件目录 + 会话数据库 + MCP 客户端 + 多环境执行器”的 Agent Host。企业价值在互操作与执行边界，风险则是自动批准和跨生态导入带来的信任继承。

### 2. Claude：企业控制面前移到推理入口

Anthropic 的 inference hooks 把 allow/deny 从工具执行前移到受治理推理之前；Managed Agents 同周加入会话硬预算、advisor 模型、多地域推理和仓库技能发现。预算、数据驻留、技能供应链与审计被合并到托管运行时，说明 Claude Code 的竞争维度正在从“写代码能力”扩展为企业 Agent 控制平面。

### 3. Google ADK 1.38：确认后仍需重验证

Google ADK 1.38 将 tool confirmation security 与 re-validation 修复移植到 v1，ReadFileTool 去除 shell execution 并把本地文件访问限制在 workspace，同时向 Live API 透传 safety settings。其重要性不在新增工具数量，而在把“确认—重验证—执行”与最小文件权限落到运行时，直接回应批准后参数漂移、路径越界和实时链路策略绕过问题。

### 4. OpenAI Agents SDK：守住事务边界

Agents SDK 0.19.3/0.19.4 密集修复 guardrail 结果持久化、session save 时序、并发 sibling cancellation、sandbox 输出预算、MCP 退避/分页、错误脱敏与 tracing。它显示生产 Agent 的难点已经从 handoff 演示转向 streaming、resume、HITL、guardrail、sandbox 和 session 组合状态的一致性。

### 5. Salesforce：用工作单元衡量企业 Agent

Salesforce Agentic Enterprise Index 披露每组织激活 Agent 数接近 3 倍、创建时间下降 53%、AWU 截至 2026 年 4 月保持 15% 月复合增长，并给出 Pandora 处理 60% 常规支持请求、NPS 提升 10% 等供应商案例。AWU 还不是跨厂商标准，但它代表企业计量从 token/会话转向“完成了什么工作”；采购方仍需把工作单元映射到成功交易、人工接管、成本和治理证据。

## 🧭 三条主线

### 产品主线：从聊天框到工作台

Cursor iPad、Copilot 并发 session/worktree、Codex sections、Claude Managed Agents、Cline SDK/CLI/Desktop 和 Kimi Work 都把操作者推向“多 Agent 调度者”。浏览器能力也在成为执行组件：OpenAI 将 Operator 并入 ChatGPT agent，Kimi 复用登录态，Genspark 把 Agent 嵌入 Office，企业 Agent 则更多绕过 UI 直接调用业务逻辑。产品竞争点由入口转向持续会话、审批队列、交付物和可恢复轨迹。

### 工程主线：权限、状态与可观测

本周高价值变化集中在确认重验证、workspace 文件边界、sandbox budget、checkpoint TTL、compaction 一致性、MCP 凭据脱敏、插件隔离和逐次运行成本。MCP 的问题也从“能不能接”进入凭据、分页、重试、目录完整性和 trace 泄漏。真正的底座是身份、权限、状态生命周期、可回放事件和失败补偿，而不是再加一个工具。

### 商业化主线：从使用量到业务结果

Salesforce 开始用 AWU、技能复杂度和业务案例描述价值；Replit 把安全扫描、数据库、部署和企业 SSO做成 Agent 可操作的平台原语；Anthropic 将扫描、推理 hook、预算和数据驻留包装成企业治理能力。商业化正在从“卖更多 token”转向托管执行、控制面、连接器、治理和结果计费，但供应商指标仍需独立复验。

## 🧩 开源生态雷达

### 事实标准候选

- **OpenAI Agents SDK / Google ADK / LangGraph**：分别在 sessions/guardrails、确认与执行边界、checkpoint 状态语义上形成可复用运行时原语。
- **MCP**：已从连接协议进入 authorization、redaction、pagination、retry 和 registry 治理阶段；协议降低适配成本，但不会自动提供安全。
- **OpenHands typed child conversation**：把子 Agent 启动、父子关系和成本从自然语言提升为结构化事件，值得跟踪其互操作潜力。

### 本周增长与活跃

- **OpenClaw**：修复 npm singleton-array metadata 兼容，强调插件分发元数据就是供应链接口。
- **OpenCode**：连续四个版本集中修复 compaction、历史顺序、revert/fork 和 transcript 导出，价值在记忆正确性。
- **Cline**：补齐 checkpoint、耐中断状态、scheduled run、MCP OAuth/容错和插件 host 隔离。
- **AutoGPT**：从自治循环继续转向专家市场、身份化会话、Dream memory 与安全下载平台。

### 观察与静默

AutoGen、Dify、LlamaIndex Agents、browser-use、MetaGPT、SuperAGI、Hermes Agent、Aider、Roo Code 等本周未出现达到正文门槛的明确事件，或只有持续提交但缺少集中、可核验的重大变化。累计 stars 只代表历史关注，不替代本周维护速度、生产采用或任务成功率。

## 📡 Agent 产品雷达

### 编码 Agent

Claude、Codex、Cursor、OpenCode、Cline、Replit 与 GitHub Copilot 本周共同指向控制面、并发会话、跨端审批、状态恢复和安全左移；Devin/Windsurf、Aider、Roo Code 本周静默。

### 浏览器与通用 Agent

OpenAI 强化 ChatGPT agent 的接管、确认与数据边界；Manus 扩展 ElevenLabs connector；Kimi Work 把本地文件、shell、浏览器登录态和定时任务放进桌面执行面；Qwen Code 推进 subagents 与 skills；Genspark GenOffice 把 Agent 嵌进 Office 编辑器。Mariner、Comet、AutoGLM 无重大公开发布。

### 企业与垂直 Agent

Salesforce 提供最强的本周生产聚合证据；Glean 本周更多输出治理与 ROI 观点而非产品发布。Sierra、Harvey、ServiceNow、Microsoft Copilot Agents、Coze 未发现可确认的新发布。企业落地的共同要求是身份继承、最小权限、审计归因、人工升级、回滚和可复现 ROI。

### 中国 Agent

Kimi Work、Kimi Docs、Qwen subagents/skills 是本周主要进展；AutoGLM 与 Coze 的公开发布面静默。值得关注的不是并发数量宣称本身，而是共享目录冲突、全权限模式、浏览器登录态、技能供应链与成本约束。

## 深度正文

## 编码 Agent / CLI / IDE 产品

> **严格统计时间窗**：上海时区 2026-08-03 00:00—2026-08-09 24:00（即截至 2026-08-10 00:00）。窗外信息仅在明确标注为“背景”时引用，不计入本周动态。
>
> **固定对象覆盖清单**：Claude Code；OpenAI Codex / Codex CLI；Cursor；Cognition Devin / Windsurf；OpenCode；Aider；Cline / Roo Code；Replit Agent；本周明显活跃的其他编码 Agent。开源仓库数据统一于 **2026-08-10（上海时区）** 查询 GitHub API，数据是查询时点快照。

## 1. Claude Code / Claude Managed Agents｜有料

本周最重要变化不只是 CLI 功能，而是 Anthropic 将编码 Agent 推向“可治理的企业执行面”。8 月 5 日上线的 **Inference hooks（企业 Beta）**会在 claude.ai、Cowork 与 **Claude Code** 的每次受治理推理前，把提示交给企业安全服务器作 allow/deny；请求签名、失败策略和 Activity Feed 审计均进入控制链。这比普通 PreToolUse hook 更上游：风险控制从“工具将执行什么”前移到“模型能否看到并处理什么”，适用于数据防泄漏和行业合规，但也增加外部策略服务的可用性依赖、延迟与误拒绝风险。8 月 7 日 Claude Managed Agents 又增加会话硬预算（触顶以 `budget_reached` 暂停）、advisor 模型、多地域推理，以及从挂载 GitHub 仓库根目录 `.claude/skills` 自动发现技能。它把成本、数据驻留、技能供应链与多 Agent 编排放进同一个托管运行时，产品形态已超出本地编码助手。

工程上，本地 Claude Code 仍以长上下文、工具调用、MCP、hooks、sandbox、权限确认和 compaction 为核心；本周官方 changelog 所示版本还持续加固工作区信任、MCP OAuth、跨会话消息、凭据掩码及 permission bypass。值得注意的是“仓库即技能来源”便利但会扩大供应链面：技能应随 commit 固定、代码审查，并与推理 hook/工具权限组合，而不能把 hook 当万能沙箱。**影响判断**：Anthropic 的差异化正在从模型能力转向“Agent 控制平面”，利好受监管团队；代价是体系复杂度和平台锁定上升。

来源：[Claude Platform release notes（8月5/7日，官方全文）](https://platform.claude.com/docs/en/release-notes/overview)；[Claude Code CHANGELOG（官方全文）](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)。GitHub API 查询日 2026-08-10 遭二级限流（429），故不填不可靠 stars/forks 数字。

## 2. OpenAI Codex / Codex CLI｜有料
\n8 月 7 日稳定版 **Codex CLI 0.147.0** 是本周工程密度最高的发布之一。新版本支持可移植 Agent Plugins，并能跨本地、个人、workspace 和远端目录搜索；持久化且可手工排序的会话 sections 改善超长轨迹浏览；`--approve-for-me` 引入自动审查批准；可导入 Cursor 管理的 skills，并同步 Claude/Cursor 对话而避免重复；MCP 适配 2026-07-28 协议，覆盖分页发现、多轮请求和非阻塞 server startup。架构信号很明确：Codex 正由单体 CLI 变成“插件目录 + 会话数据库 + MCP 客户端 + 多环境执行器”的 Agent host。

安全修复同样关键：命令展示及重放历史中遮蔽 secret/完整 bearer token，陌生本地项目要求显式 trust，托管认证限制在凭据使用前生效，插件隔离强化且策略更新失败时默认断网。旧 `codex exec --full-auto` 被移除，转向显式 `--sandbox workspace-write`，说明 OpenAI 正把“自动化程度”与“可写边界”拆开。风险在于 `--approve-for-me` 的审核者仍是自动系统，不能等同人工授权；插件、导入会话和 MCP 跨生态互操作也会带来信任继承问题。**影响判断**：互操作性本周显著领先，但大版本内变更面很广，企业应固定版本、设置网络 deny-by-default，并对自动批准做策略测试。

关键数据（GitHub API，查询日 2026-08-10）：`openai/codex` **104,965 stars、15,893 forks、12,094 open issues**；8 月 5 日 0.146.1、8 月 7 日 0.147.0，另有多枚 0.148 alpha。stars 是关注度，不代表生产质量；open issues 也含需求，不能直接视作缺陷数。来源：[OpenAI 官方 Codex changelog（0.147.0 全文）](https://developers.openai.com/codex/changelog)；[GitHub 0.147.0 release](https://github.com/openai/codex/releases/tag/rust-v0.147.0)。

## 3. Cursor｜有料

8 月 3 日 Cursor 发布 Google Workspace Plugins，编码 Agent 可直接对 Gmail、Drive、Calendar **读、写与行动**：搜索/下载及创建整理 Drive 文件，读取邮件、起草发送、标签和线程管理，以及读取日程、创建更新事件和寻找空档。产品边界因此从 IDE/代码库扩展到知识工作执行层；Marketplace/Customize 成为插件分发入口。其上下文不再只有代码索引与聊天历史，而包含邮件、文件和日历，适合把需求材料拉入开发或从 Agent 结果生成协作文档。但“可发送邮件/更新日历”的不可逆外部副作用高于读代码，最小权限、OAuth scope、发送前确认和审计日志必须成为默认控制；被污染邮件/文档也可能成为间接提示注入载体。

同周 Cursor 上线 iPad 付费版：固定侧栏可观察多个 Agent 并行，split screen 同看 review/chat，完整 PR 评论、checks、approvals 与 merge 流程，Inbox 汇总运行中、待处理和评审任务，并支持 Bitbucket/Azure DevOps、多 PR session。产品形态从“桌面编辑器”向“多 Agent 调度与移动审批台”演化。工程优势是把执行与人工 review 解耦；限制则是移动端更适合监督而非深度调试，且跨 Google Workspace 的权限面迅速放大。**影响判断**：Cursor 正用插件和多端控制抢占 Agent 的工作流入口，其护城河逐渐从补全体验转向集成密度；治理若跟不上，便利会直接转化为企业数据与误操作风险。

来源：[Cursor changelog：Google Workspace Plugins（官方全文）](https://cursor.com/changelog/google-workspace-plugins)；[Cursor changelog：iPad（官方全文）](https://cursor.com/changelog/ipad)；[Cursor 总 changelog](https://cursor.com/changelog)。闭源产品，无可比 GitHub 核心仓库 stars 指标。

## 4. Cognition Devin / Windsurf（Devin Desktop）｜观察/静默

严格检查 Cognition 官方 Devin Desktop changelog 全文后，时间窗内 **未发现 8 月 3—9 日新版本**；最近版本为 **v3.6.27（8 月 1 日，窗外背景）**，仅修复 Windows 企业根/中间证书导致的 TLS 登录问题，以及 Devin Local 的 `edit`、`write`、`apply_patch`、`notebook_edit` 拒绝穿过 symlink 写入，避免已批准编辑被重定向至意外文件。这两项虽与企业代理兼容和文件权限边界有关，但发布日期早于窗口，故不计本周动态。

核验范围包括官方 Desktop changelog（页面标称 Windsurf 的 release notes）、Cognition 官网搜索与窗口内日期扫描；未发现 Devin 云 Agent 的独立重大公告。背景上，产品已将 Windsurf 编辑器形态并入 Devin Desktop，结合 Devin Local/远端 Agent、ACP、MCP、Plan、worktree、浏览器预览和权限卡，但本周没有足以独立分析的新公开变动。来源：[Devin Desktop / Windsurf 官方 changelog](https://docs.devin.ai/desktop/changelog)。

## 5. OpenCode｜有料

OpenCode 在窗口内连续发布 **v1.18.12（8/4）、1.18.13（8/4）、1.18.14（8/5）、1.18.15（8/7）**。1.18.15 的重点是 Agent 历史一致性：导入或旧消息 ID 乱序时仍按真实时间排序；revert/fork 改用消息实际 chronology；反复 compaction 时保留更早工具调用历史，避免留下无对应结果的孤儿；截断清理按文件时间删除陈旧文件。Desktop 还可从 UI 导出完整 session transcript JSON，并扩大本地化覆盖。对长任务而言，这不是小 UI 修补：上下文压缩后工具调用—结果配对是否保真，直接影响 Agent 后续判断、复盘和可观测性；完整 JSON 导出也利于审计与离线评测。

开源形态提供终端、桌面与 web 表面，多模型、工具/MCP 和会话持久化带来可替换性；但高频发布及导入旧数据的兼容层会提高状态迁移风险。建议关键团队固定 minor、对 compaction 前后做回归，并保护导出的 transcript（可能含代码、路径、工具输出和 secrets）。**影响判断**：本周价值集中在“记忆正确性”而非炫目功能，属于生产 Agent 很重要但容易被低估的可靠性工程。

GitHub API 快照（2026-08-10）：仓库已重定向至 `anomalyco/opencode`，**195,449 stars、25,060 forks、5,041 open issues、752 watchers**；窗口内 4 个 release。数字说明生态关注和迭代强度，不证明任务成功率。来源：[v1.18.15 官方 release 全文](https://github.com/anomalyco/opencode/releases/tag/v1.18.15)；[Releases](https://github.com/anomalyco/opencode/releases)。

## 6. Aider｜观察/静默

核验 `Aider-AI/aider` GitHub Releases、仓库 push 时间与公开搜索后，本窗口无 release、无窗口内代码推送；最新正式 release 仍为 **v0.86.0（2025-08-09，窗外）**，仓库最近 push 为 **2026-05-22**。因此本周不把模型兼容、repo map、git 自动提交等既有能力包装成“新动态”。

GitHub API 快照（2026-08-10）：**48,084 stars、4,831 forks、1,784 open issues、255 watchers**。Aider 仍是终端型、git-native、多模型编码助手的重要基线，优势是工作流透明和低平台绑定；但相对本周活跃产品，其 release 节奏静止，不能仅以累积 stars 推断当前维护速度或企业适配。来源：[Aider Releases](https://github.com/Aider-AI/aider/releases)；[Aider 仓库](https://github.com/Aider-AI/aider)。

## 7. Cline / Roo Code｜Cline 有料；Roo 静默

Cline 窗口内高频发布，至少覆盖 VS Code **v4.1.4—4.1.7**，并同步 CLI、SDK、Desktop。8 月 9 日 v4.1.7 恢复由 SDK checkpoints 支撑的 “View Changes”，能从完成卡审查任务触及的全部变更；中断后 queued prompts 不丢失，会话状态跨 abort/hub restart 保持；scheduled run 报告加入 schedule、duration 与生命周期错误；MCP 方面支持预注册 OAuth client、SSE 401 触发授权、挂死 server 不再拖垮 session 创建，未配置 stdio 初始化限定 30 秒。插件设置改为 host-aware snapshot 与 atomic toggle，且阻止源 host 执行外来的编译 plugin-sandbox bootstrap。它表明 Cline 的产品形态已从 VS Code 插件扩到可调度的 SDK/CLI/Desktop host，工程焦点是 checkpoint、耐中断状态机、MCP 容错和插件隔离。

风险方面，持久化上下文会同时持久化敏感内容；checkpoint diff 现在纳入 snapshot 时的 untracked files，提升审查完整性，也要求团队注意秘密文件是否进入轨迹。MCP OAuth 和 plugin host 增加凭据与供应链面。**影响判断**：Cline 本周并非单纯堆模型，而是在补齐 Agent runtime 的 durability/observability，这是从交互助手迈向无人值守调度的必要条件。

GitHub API（2026-08-10）：`cline/cline` **65,928 stars、7,081 forks、966 open issues、280 watchers**；8/9 v4.1.7。来源：[Cline v4.1.7 官方 release 全文](https://github.com/cline/cline/releases/tag/v4.1.7)、[v4.1.6](https://github.com/cline/cline/releases/tag/v4.1.6)。

**Roo Code 核验结果**：官方仓库窗口内无 release/推送；最新 release **v3.54.0（2026-05-15，窗外）**。API 快照（2026-08-10）：**24,352 stars、3,409 forks、1,036 open issues、146 watchers**。故列静默，不将 fork 生态热度替代本周事实。来源：[Roo Code Releases](https://github.com/RooCodeInc/Roo-Code/releases)。

## 8. Replit Agent｜有料

8 月 7 日 Replit 将 **Semgrep 安全扫描直接嵌入 Agent 的 code review**：Agent 会检查自己改动的文件，寻找常见高风险模式与硬编码 secret，并在任务完成前处理可能发现。这是“生成—执行—审查”闭环中的安全左移，价值在于无需用户另开 CI 才获得基础 SAST；同时它不是完整保证：扫描只针对 Agent 修改文件、规则有误报/漏报，依赖风险、运行时权限和业务逻辑漏洞仍需 CI、测试及人工 review。

同一官方更新还允许轮换生产数据库凭据，并在支持的在线 deployment 上触发 redeploy；通过 Clerk 为 Agent 构建的应用配置 Okta/Entra SSO；团队 workspace 间可后台移动项目，但操作不可撤销且 Linked Account Secrets 不随迁移。整体产品形态继续把 Agent 与托管数据库、部署、认证、团队空间绑定成一体化云开发环境。优势是 Agent 能获得从代码到运行环境的闭环上下文；限制是控制面集中、迁移和外部连接的 blast radius 较大。**影响判断**：Replit 的差异化不是最开放的 MCP/模型生态，而是把安全检查和生产基础设施做成 Agent 可直接操作的平台原语；适合快速交付，但企业仍要区分“平台自动检查”与“安全验收”。

来源：[Replit 2026-08-07 官方更新全文](https://docs.replit.com/updates/2026/08/07/changelog)；[项目安全中心](https://docs.replit.com/features/security/project-security-center#security-scan-while-you-build)。核心 Agent 为闭源，未用无关 GitHub 仓库 stars 代替采用数据。

## 9. GitHub Copilot（本周明显活跃对象）｜有料

GitHub 8 月 7 日周更把 Copilot app、CLI 与 VS Code 的“并行但不打断”做成一致范式。App 支持 shared sessions 直达与 `/side` 并行提问，并显示 Auto 实际选用模型及可用的 AI credit/cache 信息；CLI 增加多 concurrent session 侧栏、实验性 `/worktree` 隔离工作区、无需 Git 的 `/rewind`（恢复对话及 Copilot 改动文件，同时保留后续 edits），以及 timeline 中实时工具调用耗时。VS Code 的 `/btw` side chat 共享主对话上下文和 prompt cache 却不打断当前 turn；集成浏览器可选中具体 DOM 元素并附多条视觉反馈给 Agent。

这些变化同时触及上下文分叉、文件隔离、恢复机制与可观测性。worktree 是强工程边界但不是安全 sandbox；`/rewind` 不依赖 Git 更易用，也使内部 checkpoint 的正确性成为关键。显示模型、credit/cache 和 tool duration 提高成本/性能解释性，却仍不足以回答工具参数、网络出站和权限决策等完整审计问题。**影响判断**：GitHub 正把 Copilot 从单会话聊天升级为并发 session manager，优势是与 repo、worktree、VS Code 浏览器天然结合；其风险主要在共享上下文侧聊可能扩大敏感信息传播，以及非 Git 恢复边界需充分验证。

来源：[GitHub Copilot weekly releases — August 3（8月7日官方全文）](https://github.blog/changelog/2026-08-07-github-copilot-weekly-releases-august-3/)；[VS Code 1.132 release notes](https://aka.ms/VSCode/132)。闭源主产品，不以辅助开源仓库 stars 代替采用指标。

# 本组横向洞察

1. **控制面成为竞争核心**：预算、data residency、inference hook（Anthropic），trust/sandbox/plugin network policy（Codex），checkpoint/MCP 容错（Cline），SAST（Replit）都在回答“Agent 如何被允许运行”，模型本身反而不是本周主角。
2. **并发与跨端取代单聊天**：Cursor iPad、Copilot side session/worktree、Codex persistent sections、Claude 跨 session/托管 Agent 均把操作者变成多个 Agent 的调度者。下一瓶颈是状态一致性、注意力与审批队列，不是再多一个聊天框。
3. **上下文完整性是隐性基础设施**：OpenCode 修复 compaction 后工具历史，Cline 保持 abort 后状态，Copilot `/rewind`、Codex sections 都说明“可恢复、可解释的轨迹”已经成为生产 Agent 的硬指标。
4. **生态互操作扩大供应链风险**：Codex 导入 Cursor skills/Claude conversations，Claude 从 GitHub 自动加载 skills，Cursor Workspace 插件、MCP OAuth 都降低连接成本，也让来源、scope、版本固定、撤销机制更重要。
5. **热度不等于价值**：stars/forks 仅是可见兴趣存量；本周最有价值的变化多是权限、历史一致性与容错，必须结合 release 原文和架构后果判断。

# 覆盖统计与方法说明

- **总对象 N=9**（合并口径：Claude Code；Codex；Cursor；Devin/Windsurf；OpenCode；Aider；Cline/Roo；Replit Agent；GitHub Copilot）。
- **有料 M=7**：Claude、Codex、Cursor、OpenCode、Cline（同组 Roo 静默）、Replit、GitHub Copilot。
- **观察/静默 K=2**：Devin/Windsurf、Aider；另 Cline/Roo 合并对象中的 Roo 单项静默。
- 固定对象逐一核验，实质覆盖 **100%（8/8 固定合并对象）**。所有“有料”对象均阅读官方原文全文；开源数据通过 GitHub API 于 2026-08-10 查询。GitHub 二级限流处明确留空，未猜值。时间窗外材料均标为背景或静默依据。
## 开源 Agent 框架与项目

- **严格时间窗（Asia/Shanghai）**：2026-08-03 00:00—2026-08-09 24:00（对应 UTC 2026-08-02 16:00—2026-08-09 16:00）。
- **查询日期**：2026-08-10。
- **覆盖清单**：OpenClaw、LangGraph/LangChain Agents、Microsoft AutoGen、CrewAI、Dify、LlamaIndex Agents、Google ADK、OpenAI Agents SDK/Swarm、browser-use、OpenHands、AutoGPT、MetaGPT、SuperAGI、Hermes Agent。
- **口径**：正文仅纳入窗口内可由官方公告、官方文档、GitHub Release/API、提交或一手工程讨论核验，且满足重大 release/架构或安全变化、可解释增长、头部采用/集成、新范式、benchmark、真实工程讨论或主流生态关系至少一项的动态；其余进入观察池/静默。Stars/Forks 等为查询时点快照，会持续变化。

## 一、本周入选动态

### 1. OpenClaw：插件更新链兼容修复，暴露“分发元数据即供应链接口”

**事实核验。** OpenClaw 于 **2026-08-04 00:41 UTC（上海 08:41）**发布 `v2026.7.1-2`，唯一明确修复是兼容新版 npm 客户端返回的 singleton-array metadata，使被跟踪的官方插件能够安装、升级到纠错版本；发布页还给出 PR #108336、签名标签及提交 `0790d9f`。[官方 Release](https://github.com/openclaw/openclaw/releases/tag/v2026.7.1-2)｜[对应 PR](https://github.com/openclaw/openclaw/pull/108336)。查询日仓库快照为 **385,706 stars / 81,071 forks**（[仓库](https://github.com/openclaw/openclaw)，2026-08-10 查询）。

**分析。** 这不是功能扩张，而是重要的生态可靠性修复：Agent 平台越来越依赖可独立升级的插件，npm 响应结构的细微改变就可能阻断安全补丁和兼容修正版的传播。产品上，它降低用户“主程序可用、插件却无法更新”的隐性故障；工程上，说明 registry metadata 应被视为版本化外部协议，需要数组/对象归一化、fixture 回归和失败可观测性。风险仍在：自动跟踪“官方插件”扩大软件供应链信任面，签名标签只能证明核心 release 来源，不能替代插件包的 provenance、锁定与回滚。事实标准潜力在于：若插件身份、版本解析和更新策略进一步机器可读，OpenClaw 可推动个人 Agent 生态形成类似包管理器的兼容契约。

### 2. LangGraph / LangChain Agents：持久化过期数据治理与 MCP 凭据脱敏同步落地

**事实核验。** LangGraph 于 **2026-08-07 20:05 UTC（上海 8日 04:05）**发布 `langgraph-checkpoint==4.2.0`，新增可选 `omit_expired`，读取时跳过过期 checkpoint 行，并修复 delta channel history 在 plain-value seed 场景收集 writes 的正确性；[官方 Release](https://github.com/langchain-ai/langgraph/releases/tag/checkpoint%3D%3D4.2.0)。同日 LangChain 发布 `langchain-openai==1.4.2`，包含 **MCP authorization 脱敏**、`ContextWindowExceededError` 处理、过滤框架生成 content block IDs、保留 Responses text options；[官方 Release](https://github.com/langchain-ai/langchain/releases/tag/langchain-openai%3D%3D1.4.2)。查询日快照：LangGraph **39,317 stars / 6,603 forks**，LangChain **143,816 / 23,961**（[LangGraph](https://github.com/langchain-ai/langgraph)｜[LangChain](https://github.com/langchain-ai/langchain)，2026-08-10）。

**分析。** 两个包共同指向生产 Agent 的“状态面”成熟：checkpoint TTL 不只是存储优化，还影响恢复、审计和隐私删除语义；采用 opt-in 而非默认过滤，避免升级时悄然改变历史回放，是稳健的兼容策略。MCP authorization 脱敏则表明 MCP 已进入日志、错误和追踪链路，凭据泄漏不再是理论风险。生态上，LangGraph 负责可恢复工作流，LangChain provider 包吸收 OpenAI Responses/MCP 的协议差异，形成“编排核 + 快速集成层”。风险在于 `omit_expired` 的数据库实现与清理策略可能不一致，脱敏也需覆盖异常对象、trace exporter 和用户回调。其事实标准可能性来自 checkpoint/thread 状态语义与 MCP 凭据处理若稳定下来，容易被其他工作流引擎复用为互操作预期。

### 3. CrewAI：供应链安全补丁与跨模型路由计量修正

**事实核验。** CrewAI 于 **2026-08-07 21:13 UTC（上海 8日 05:13）**发布 `1.15.13`，将 `h2` 升至 `4.4.1` 以修复 **GHSA-6hr6-w5qg-qmwg**，并修复 LiteLLM 路由模型的 provider 信息保留、Anthropic cache token usage 低报及 LLM event-bus mock 脆弱问题；贡献者名单也在官方说明中列出。[官方 Release](https://github.com/crewAIInc/crewAI/releases/tag/1.15.13)｜[GitHub Advisory](https://github.com/advisories/GHSA-6hr6-w5qg-qmwg)。查询日仓库 **56,869 stars / 8,107 forks**（[仓库](https://github.com/crewAIInc/crewAI)，2026-08-10）。

**分析。** 入选原因是“安全修复 + 多模型生产计量”而非版本号本身。CrewAI 的抽象价值在于 Crew/Flow 上层保持统一，而 LiteLLM 等路由层处理提供商；provider 丢失会破坏成本归因、策略路由和事故定位，Anthropic 缓存 token 低报会直接使 FinOps 数据失真。`h2` 补丁同时提醒：Agent 即使业务逻辑在 Python 层，也继承 HTTP/2 协议栈风险。产品上，本次改动增强企业对成本和供应商使用情况的可解释性；工程上应把 provider identity、cache hit/token 与 trace span 绑定。风险是多层路由后“实际执行提供商”仍可能与请求标签不同；标准机会在统一 usage 事件 schema，而非 CrewAI 私有字段。

### 4. Google ADK：工具确认重验证与文件读取去 shell 化，权限边界成为版本主线

**事实核验。** Google ADK Python 于 **2026-08-07 23:41 UTC（上海 8日 07:41）**发布 `v1.38.0`。官方列出的关键项包括：把 `generate_content_config` 的 `safety_settings` 转发给 Live API；`ReadFileTool` 范围读取避免 shell execution，并把本地文件访问限制在 workspace；把 tool confirmation security 与 re-validation 修复移植到 v1；修复 Live agent transfer 对 function response 顺序的依赖，以及 eval 失败结果处理。[官方 Release](https://github.com/google/adk-python/releases/tag/v1.38.0)｜[文件工具修复提交](https://github.com/google/adk-python/commit/c68072840131199e93ba6cff76b20ca758ef1161)｜[确认重验证提交](https://github.com/google/adk-python/commit/47833640c7be84f238d6a046f3bd3e2aa9ce3ef3)。查询日 **21,055 stars / 3,815 forks**（[仓库](https://github.com/google/adk-python)，2026-08-10）。

**分析。** 这是本周最清晰的 Agent 权限工程信号之一：用户确认不能只在“计划动作”时做一次，执行前必须对参数和上下文重验证，否则模型或异步状态可在批准后发生 TOCTOU 式漂移；文件工具去 shell 化、workspace 限界则把最小权限从文档约定落到实现。Live API safety settings 透传避免实时链路绕过离线安全策略。架构上，ADK 正把安全策略、HITL 确认、工具执行器和实时会话做成端到端控制面。风险仍包括符号链接/路径规范化、工具组合越权以及确认 UI 对最终参数展示不足。若“确认—重验证—执行”事件模型公开稳定，具备成为跨框架权限事实标准的潜力。

### 5. OpenAI Agents SDK / Swarm：密集修复守住 guardrail、session、sandbox 与 MCP 的一致性

**事实核验。** Agents SDK Python 在窗口内发布 `v0.19.3`、`v0.19.4`；后者发布时间 **2026-08-05 02:58 UTC（上海 10:58）**。`0.19.4` 修复包括：保存已完成 tool guardrail 结果、无效工具参数错误脱敏、输出 guardrail 前延迟非流式 session save、并发失败后取消 sibling work、暴露非流式 content-filter refusal、MCP streamable HTTP 退避、sandbox token 输出预算、MongoDB session closed-state、tracing failure 标记等；`0.19.3` 还覆盖 resumed tool name collision、批准工具输出恢复、MCP 自动分页、snapshot path 加固、SQLite 回滚与 Realtime guardrail。[v0.19.4](https://github.com/openai/openai-agents-python/releases/tag/v0.19.4)｜[v0.19.3](https://github.com/openai/openai-agents-python/releases/tag/v0.19.3)。查询日 SDK **28,513 stars / 4,473 forks**；Swarm **21,891 / 2,331**（[SDK](https://github.com/openai/openai-agents-python)｜[Swarm](https://github.com/openai/swarm)，2026-08-10）。Swarm 官方 README 明示已由生产级 Agents SDK 取代，应迁移。

**分析。** 这批并非“杂项 bug”，而是在校准 Agent runtime 的事务边界：输出 guardrail 与 session commit 的先后顺序决定违规输出是否被持久化；并发 sibling cancellation 决定失败后是否继续产生副作用；sandbox output budget 既控成本也防资源耗尽；MCP retry/pagination 决定工具目录在真实网络下是否完整。产品上，SDK 已从 Swarm 的 `Agent + handoff` 教学原语演进为含 sessions、guardrails、tracing、sandbox、realtime 的生产运行时。风险是状态组合爆炸，尤其 streaming/resume/HITL/guardrail 交叉场景；密集修复本身提示升级需回归。它最可能形成的事实标准是 handoff、tool guardrail 和 trace span 的语义，而非 Swarm 旧 API。

### 6. OpenHands：Agent Canvas 加入子会话动作与逐次运行成本，编码 Agent 转向可运营工作台

**事实核验。** OpenHands 于 **2026-08-07 18:01 UTC（上海 8日 02:01）**发布 `v1.11.0`，新增 Activity Log/导出中的 **per-run LLM cost**、用于启动本地或 Cloud child conversation 的 typed agent action、automation 标签筛选与 conversation 标签；随后 `v1.12.0`（上海 8日 03:33）澄清免费模型 endpoints。[v1.11.0 官方 Release](https://github.com/OpenHands/OpenHands/releases/tag/v1.11.0)｜[v1.12.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.12.0)。查询日仓库 **83,558 stars / 10,806 forks**（[仓库](https://github.com/OpenHands/OpenHands)，2026-08-10）。

**分析。** typed child-conversation action 是值得关注的多 Agent 原语：它把“再开一个 Agent”从自然语言/临时工具调用提升为可验证事件，并允许本地与云执行后端统一呈现；配合 automation/tag，OpenHands 正由单次 coding session 走向可分派、可检索的工作队列。逐次成本进入 Activity Log 与导出则是 Agent 可观测性真正可运营的基础，可支持预算、回归和团队 chargeback。生态上，产品名明确为 Agent Canvas，显示 UI 不再只是聊天壳。风险包括父子会话权限、secret 继承、递归 fan-out 和成本爆炸；成本数据也受 provider 缓存/重试计量影响。若 typed action、运行 ID、父子关系和成本字段对外稳定，可成为编码 Agent 事件互操作的重要事实格式。

### 7. AutoGPT：0.7.0 把“专家市场 + 身份化会话 + Dream memory”纳入平台，同时补 SSRF

**事实核验。** AutoGPT 于 **2026-08-05 14:02 UTC（上海 22:02）**发布 `autogpt-platform-beta-v0.7.0`。主要变化：Copilot backend 增加 expert-scoped sessions 与 identity context，新增 Experts marketplace、team page、per-expert threads；认证从 Supabase Auth 切换 Better Auth；统一 LLM model catalog；修复 VideoDownloadBlock 的 **SSRF 防护与下载限制**；Dream memory 删除 transient-intent/generic-knowledge，并修正阶段超时、ingestion drain、registration 等运行时正确性。[官方 Release](https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.7.0)｜[SSRF PR](https://github.com/Significant-Gravitas/AutoGPT/pull/12702)｜[身份会话 PR](https://github.com/Significant-Gravitas/AutoGPT/pull/13687)。查询日 **186,464 stars / 46,069 forks**（[仓库](https://github.com/Significant-Gravitas/AutoGPT)，2026-08-10）。

**分析。** 架构方向已从早期“一个自治循环”转为带身份、市场、线程和长期记忆的平台。expert-scoped session 能隔离人格/上下文，但必须与授权域一致，否则“专家隔离”只是 UI 分组；单一 model catalog 有利于路由和产品一致性。Dream memory 主动排除瞬时意图和通用知识，体现长期记忆需要治理“该记什么”，而非无限写入。SSRF 与下载上限修复尤其关键：网页/媒体输入使 Agent 成为网络代理，必须阻断内网探测和大文件资源耗尽。生态采用潜力来自专家市场，但 marketplace 同时引入提示、工具、身份和计费供应链风险。事实标准可能性较低于 MCP，但 per-expert thread 与 memory ingestion lifecycle 值得跟踪。

## 二、观察池与静默对象（逐一核验）

> 以下对象已直查官方 GitHub 仓库/Release/窗口内提交。没有达到正文门槛，不将普通提交数量包装成重大动态；仓库统计均为 2026-08-10 查询快照。

| 对象 | 查询快照（stars / forks） | 窗口结论与官方入口 |
|---|---:|---|
| **Microsoft AutoGen** | 60,332 / 9,089 | **静默/迁移背景。** 窗口内未发现合格 release；官方 README 当前明确 AutoGen 进入 maintenance mode、由社区维护，并推荐新用户转 Microsoft Agent Framework，后者提供 A2A/MCP，但无法把未带窗口日期的 README 状态当作本周动态。[仓库](https://github.com/microsoft/autogen)｜[Releases](https://github.com/microsoft/autogen/releases) |
| **Dify** | 151,881 / 23,972 | **观察池。** 窗口内提交活跃但无经核验的窗口 release/单一重大事件达到门槛；官方定位仍是 workflow、RAG、Agent、模型管理与 Opik/Langfuse/Phoenix 可观测集成的一体平台，属背景。[仓库](https://github.com/langgenius/dify)｜[Releases](https://github.com/langgenius/dify/releases) |
| **LlamaIndex Agents** | 51,511 / 7,898 | **观察池。** 窗口内无合格 release；官方仓库强调文档 Agent/OCR、LlamaAgents 与 300+ integrations，但本周未见可独立确认的重大架构/采用事件。[仓库](https://github.com/run-llama/llama_index)｜[Releases](https://github.com/run-llama/llama_index/releases) |
| **OpenAI Swarm** | 21,891 / 2,331 | **静默（并入 SDK 背景）。** 窗口内无发布/提交；官方明确被 Agents SDK 替代，仅保留教育用途。其生态关系已在 SDK 条目分析，不重复计动态。[仓库](https://github.com/openai/swarm) |
| **browser-use** | 108,497 / 11,930 | **观察池。** 窗口内有持续提交但无 release，未找到足够集中且一手说明完备的重大变化；官方定位仍是让 Agent 打开、点击、输入和填表，并提供 Cloud。[仓库](https://github.com/browser-use/browser-use)｜[Releases](https://github.com/browser-use/browser-use/releases) |
| **MetaGPT** | 69,749 / 8,878 | **静默。** 窗口内无发布/提交；README 最新显著新闻仍停留在 2025 年 MGX/AFlow（窗外背景），不可纳入本周。[仓库](https://github.com/FoundationAgents/MetaGPT)｜[Releases](https://github.com/FoundationAgents/MetaGPT/releases) |
| **SuperAGI** | 17,652 / 2,223 | **静默。** 窗口内无 release/提交，官方仍描述为 dev-first autonomous Agent framework；没有本周可核验工程事件。[仓库](https://github.com/TransformerOptimus/SuperAGI)｜[Releases](https://github.com/TransformerOptimus/SuperAGI/releases) |
| **Hermes Agent** | 227,961 / 44,773 | **观察池。** 官方仓库主张内建学习闭环、技能自改进、跨会话 FTS5 recall、agentskills.io 兼容和多渠道 gateway，具新范式背景；但窗口内 release 数据未能形成可准确归属的合格事件，故不以高 stars 代替增长证据。[仓库](https://github.com/NousResearch/hermes-agent)｜[Releases](https://github.com/NousResearch/hermes-agent/releases) |

## 三、开源生态观察

1. **权限从“是否允许工具”升级为执行期协议。** Google ADK 的确认重验证/工作区文件边界、OpenAI SDK 的 guardrail 提交顺序与 sandbox budget、AutoGPT 的 SSRF/下载限制共同表明：生产 Agent 的核心差异正在转向 TOCTOU、防副作用、网络/文件边界和资源预算。
2. **MCP 已进入安全与可靠性深水区。** LangChain 做 authorization 脱敏，OpenAI SDK 修 retry backoff 与分页；关注点从“能接 MCP”变成凭据、目录完整性、失败恢复和 trace 泄漏。下一阶段需要跨框架一致的 auth-redaction、capability declaration、approval/audit schema。
3. **持久化与记忆开始分层治理。** LangGraph 用 TTL 读取策略治理 checkpoint；AutoGPT Dream memory 筛除瞬时/通用信息；OpenAI SDK 校正 session closed/branch/provenance。状态不再是简单聊天历史，而是有生命周期、来源、分支与删除语义的数据产品。
4. **多 Agent 原语正在类型化。** OpenHands typed child conversation、OpenAI handoff、AutoGPT per-expert threads 都在把自然语言协作转成结构化事件。谁能稳定公开 parent/run/agent/tool/approval/cost 关系，谁更可能成为观测和迁移的事实标准。
5. **旧明星项目出现代际分化。** AutoGen 指向 Microsoft Agent Framework，Swarm 指向 Agents SDK；MetaGPT/SuperAGI 窗口内静默。GitHub 累计 stars 只能衡量历史关注，不能等同当前研发速度或生产采用。

## 四、本周统计（严格窗口）

- 固定对象 **14 组全部核验**（将 LangGraph/LangChain、Agents SDK/Swarm 各按题目组合口径计组；实际直查 **16 个 GitHub 仓库**）。
- 正文入选 **7 组**：OpenClaw、LangGraph/LangChain、CrewAI、Google ADK、OpenAI Agents SDK/Swarm、OpenHands、AutoGPT。
- 观察池/静默 **7 组**：AutoGen、Dify、LlamaIndex Agents、browser-use、MetaGPT、SuperAGI、Hermes Agent（Swarm 的静默状态另在组合项中标注）。
- 窗口内经发布页直接核验的代表版本：OpenClaw 1；LangGraph 1 + LangChain provider 1；CrewAI 至少 1 个安全相关版本；Google ADK 1 个关键 v1 版本；OpenAI SDK 2；OpenHands 2；AutoGPT 1。
- 本周没有把累计 stars 变化写成“增长”：缺少同口径期初快照时，只报告 2026-08-10 的绝对快照，避免伪造增量。contributors 未能从所有仓库统一取得时，以 release 明列贡献者/PR 作者代替，未作跨项目失真排名。
## 浏览器 / Computer Use / 通用 Agent

- **严格时间窗（Asia/Shanghai）**：2026-08-03 00:00—2026-08-09 24:00
- **覆盖清单**：OpenAI Operator / ChatGPT Agent、Anthropic Computer Use、Google Project Mariner、Perplexity Comet、Manus、Genspark、Kimi Agent、Qwen Agent、AutoGLM；并检索本周显著活跃的同类产品。
- **口径**：只有在时间窗内由官方渠道发布、更新或可核验的动态才列为“本周动态”；旧闻不回填。官方原文均实际读取，并给出 Markdown 链接。日期按上海时区判断。

## 1. OpenAI Operator / ChatGPT Agent｜本周有相关更新

**核验结论（8月5—6日）**：Operator 独立站已退出，能力并入 ChatGPT agent；本周 OpenAI 更新了 agent 帮助页，并发布 GPT‑5.6 Sol 预览。前者明确了真实浏览器执行的权限、登录和数据边界，后者增强的是底层“长程工具协同 / 多 Agent”能力，尚不是一次 ChatGPT agent 产品能力全面开放。

OpenAI 帮助页显示，Agent 可在 Web、移动和桌面端使用，付费层月度额度为 Plus 40、Pro 400、Business/Enterprise 40 次；企业灵活计费为每次 30 credits。需要登录时，Agent 暂停并要求用户接管虚拟浏览器，接管期间不截屏；高影响动作须确认，部分站点启用 watch mode。Cookie 可跨会话保留，浏览历史与截图随聊天保留，删聊后相关数据原则上 90 天内删除。真实可用性仍受站点 blocklist、并发/额度、接管后恢复失败等约束；支付并无“完全自主”承诺，确认和人工接管仍是核心安全闸门。[官方帮助页（本周检索结果显示 8月5日更新）](https://help.openai.com/en/articles/11752874-chatgpt-agent)

8月6日官方预览 GPT‑5.6 Sol/Terra/Luna：Sol 引入 max reasoning，ultra mode 通过 subagents 加速复杂任务；Terminal‑Bench 2.1 达到官方所称 SOTA，但官方未披露浏览器/OS任务完成率，因此不能外推为 ChatGPT agent 的网页任务成功率。预览仅向少数可信伙伴的 API/Codex 开放；Sol/Terra/Luna 每百万 token 定价分别为输入/输出 $5/$30、$2.5/$15、$1/$6。它体现产品工程从“单 Agent 循环”转向可调度子 Agent，但短期商业化仍是模型/API，不等于普通用户 Agent 额度或可靠性提升。[官方原文，2026-08-06](https://openai.com/index/previewing-gpt-5-6-sol/)

同周官方客户案例提供了可量化但**非浏览器基准**的生态信号：Circles 的 CareX 多 Agent 客服在受支持工作流中自主解决率 65%，早期运营商首周 55%；其工程机制是编排 Agent + 账单/订阅/网络/账户专用 Agent，按最小必要信息授权，并保留人工升级、分阶段发布、限流和回滚。该案例证明垂直、权限收敛的 Agent 比开放网页 Agent 更易商业闭环，但不可与 OSWorld/WebArena 横比。[官方客户案例，2026-08-04](https://openai.com/index/circles/)

## 2. Anthropic Computer Use｜核心能力静默，安全生态有更新

**核验结论（8月6日）**：Anthropic 官方 Claude release notes 在本周唯一相关条目是 Enterprise 的 Skill / Plugin security scanning beta：组织可在第三方技能或插件上传、编辑时自动扫描恶意内容。它不是 Computer Use 模型或 Cowork 屏幕操控能力升级，也没有公布本周浏览器/OS成功率。

这一更新仍直接回应通用自主 Agent 的现实攻击面：当 Claude 可通过 Computer Use 点击屏幕、通过插件/skills 获得动作能力时，恶意工具说明、供应链污染与 prompt injection 会叠加。把扫描放在“上传/编辑”入口，属于部署前治理；但官方没有宣称扫描可发现所有恶意逻辑，也没有替代运行时权限确认、最小权限和人工监督。商业化上仅 Enterprise 可启用，说明安全治理正成为企业 Agent 套餐的付费差异化能力。[Claude 官方 Release Notes，2026-08-06](https://support.claude.com/en/articles/12138966-release-notes)

Computer Use/Cowork 本体在本周无新发布。已核验范围：Anthropic News、Claude Blog、Claude Help/Release Notes、Computer Use 文档索引；搜索窗口内未找到模型、浏览器扩展、任务成功率或价格更新。静默原因只能确认“官方无条目”，不推测内部路线。

## 3. Manus｜本周上线 ElevenLabs Connector

**动态（8月3日）**：Manus 将 ElevenLabs 的语音生成、转写、声音克隆和语音应用构建接入同一个对话工作流。工程上由 Manus 负责计划、脚本编写与工作流编排，ElevenLabs 通过 API 执行音频处理，结果回传 Manus 会话；用户无需管理 API key，但必须先在 Integrations 以 OAuth/登录方式授权已有 ElevenLabs 账户。

人机协作与风险边界写得较清楚：官方要求所有 AI 音频在发布/分发前人工复核；克隆声音必须拥有权利并满足 ElevenLabs 同意要求；Manus 只访问用户已授权的第三方连接器，不自动新增权限。数据与商业关系仍分层：音频按 ElevenLabs 的留存政策处理，能力取决于 ElevenLabs 套餐和 credits，历史与计费仍在 ElevenLabs。由此看，Manus 的产品形态正从“自带云电脑的通用 Agent”延伸为统一会话编排层；优势是减少工具切换，限制是跨服务的数据处理、双重条款/计费和内容审核责任仍由用户承担。本次没有发布浏览器或 OS 任务完成率，也没有支付自动化更新。[Manus 官方原文，2026-08-03](https://manus.im/es-419/blog/elevenlabs-connector)

## 4. Kimi Agent｜Kimi Work 桌面自主 Agent 与文档 Agent 本周活跃

**动态（官方页面约8月7日更新/收录）**：Kimi Work 被定义为 macOS/Windows 本地桌面 Agent，可读取/写入本地文件、运行 Python/shell、借助 Kimi WebBridge 操作已登录浏览器，并执行定时任务；Goal Mode 可跨轮持续执行，官方宣称单指令最多并行 300 个 Agent。其循环是拆解—并行执行—验证—反馈到下一轮，过程可观察、可人工干预。

权限设计有两档：`Ask permission` 在敏感步骤暂停审批，`Full access` 则允许端到端免打断执行；本地文件夹需显式挂载，插件通过 MCP/OAuth/开放平台连接用户有权访问的第三方账户。WebBridge 复用现有登录态能降低频繁登录摩擦，但也扩大 cookie、账户与页面 prompt injection 的暴露面；尤其定时/通宵运行要求电脑保持开机，“全权限 + 已登录浏览器 + 长时任务”组合应只用于低风险、可回滚流程。官方没有给出 OSWorld/WebArena 成功率，也未披露 300 Agent 的质量、成本与并发退化数据，故该数字只能视为并发上限主张，不代表 300 倍产能。[Kimi 官方 Kimi Work 原文，约2026-08-07](https://www.kimi.com/resources/kimi-work-introduction)

同周 Kimi Docs 页面强调可生成最高约 10,000 字 Word/PDF、批量生成数百短文件并做 Word/PDF/PPT/Excel 转换；页面列出“周期快 90%”“专家反馈效率 3x”，但没有披露测试样本、基线与方法，应视作营销指标而非独立基准。产品形态显示通用 Agent 正向“本地 Computer Use + 专业 Office Agent”双层演进：执行面在桌面，交付面是可下载/继续编辑的文件。[Kimi Docs 官方页，本周收录](https://www.kimi.com/features/docs)

## 5. Qwen Agent / Qwen Code｜Subagents、Agent Skills 成为工程化产品面

**动态（8月3—7日）**：Qwen3.8 官方发布定位 Coding 与 Cowork；Qwen Code 文档本周新增/更新了 Subagents 与 Agent Skills。Subagent 可拥有独立上下文、任务专用 prompt 和受控工具；fork 模式继承父上下文，可用 `fork_tools` 或项目级 profile 收窄执行能力，且子 fork 禁止递归再派生。官方称并行 3 个 fork 共享提示缓存前缀可节省 80%+ token 成本；这是缓存成本主张，不是任务完成率。

安全与协作机制较细：工具限制在调度前执行，但文档明确说明它是调用者选择的约束，**不是管理员强制安全沙箱**；shell 即使列入允许工具仍要经过正常权限检查。后台 Agent 可查看进度、收到完成通知并续接；但 fork 共享工作目录且无 worktree 隔离，并发改文件可能冲突。权限模式还包含 default/plan/auto-edit/yolo/bubble，其中 yolo 会自动批准潜在破坏操作，企业使用应禁用或外围加策略。Agent Skills 则把说明、脚本、模板做成可发现模块，可由模型自动调用或用户显式调用，支持项目/个人/扩展来源；`/learn` 能从文档、目录或视频生成 Skill，但官方要求分享前人工复核。生态采用门槛低（Git 可分发），供应链与技能注入风险则随之增加。[Qwen Code Subagents 官方文档，2026-08-07](https://qwenlm.github.io/qwen-code-docs/en/users/features/sub-agents/)；[Agent Skills 官方文档，2026-08-07](https://qwenlm.github.io/qwen-code-docs/en/users/features/skills/)；[Qwen3.8 官方发布，2026-08-03](https://qwen.ai/blog?id=qwen3.8)

## 6. Genspark｜开源 GenOffice，把 Agent 嵌进 Office 编辑器

**动态（8月3日）**：Genspark 发布 GenOffice Alpha，核心办公功能免费、无广告、无水印，开放代码；Docs/Sheets/Slides/PDF 中原生嵌入 Super Agent，AI 研究、分析与生成消耗 Genspark credits。官方称 Alpha 由一名工程师用一周、约 $10,000 token 成本构建，这更能说明 Agent 辅助软件生产的速度，不应解读为成熟度；官方也直言有 bugs、缺失功能和 rough edges。[Genspark 官方原文，2026-08-03（站点反爬，已通过全文检索读取）](https://www.genspark.ai/blog/genoffice-open-source-ai-office)

官方代码库提供更可验证的工程机制：六个 Electron 应用共享引擎，文档采用 block 级编辑、快照和 diff；DOCX 仅重写被修改段落，未改内容字节保留；Sheets 使用 Rust sidecar，PDF 通过 PDFium wasm 改写内容流。AI 通过设备码登录 Genspark，模型调用经 Genspark proxy 路由 Claude/GPT/Gemini，用户不保存模型 API key；内置 web/image search、图像生成和多媒体分析工具。安全说明提到 renderer sandbox、IPC 校验与外链 gating，但本周没有公开办公任务完成率或本地/云端数据分流基准。开源范围主要 Apache-2.0，`ee/` 企业模块保留商业许可证，体现“免费本地编辑器 + credits AI + 未来企业模块”的商业化路径。[官方 GitHub README，本周持续更新](https://github.com/genspark-ai/genoffice)

## 7. Google Project Mariner｜本周静默

核验范围：Google Blog（AI、Chrome、Gemini）、Google DeepMind News/Research、Gemini 产品更新与 Project Mariner 关键词检索；2026-08-03—08-09 未发现 Mariner 新功能、开放范围、价格、浏览器基准、权限/支付机制更新。由于 Mariner 能力此前逐步进入 Gemini Agent Mode，但本周没有可归因到 Mariner 的官方发布，故不以旧闻补位。静默原因仅能确认官方发布面无新增，不能推测项目状态。[Project Mariner 官方既有页面（用于核验产品入口，非本周新闻）](https://deepmind.google/models/project-mariner/)

## 8. Perplexity Comet｜本周无重大产品发布，仅支持/可用性维护信号

核验范围：Perplexity Hub Blog、Comet Help Center、产品页、官方社媒索引与搜索结果。窗口内只检出 Comet “无法访问”帮助页约8月6日更新，内容涉及防火墙/杀毒软件白名单、重启、安装与网络排障；没有新 Agent 功能、成功率、商业套餐或权限政策发布。该维护信号反而说明 Agent 浏览器的现实可用性不仅取决于模型，还受终端安全软件、企业网络策略和安装环境制约。因原页 Cloudflare 阻断全文抓取，已记录检索结果但不将其计为有重大动态对象。[Comet 官方帮助页，约2026-08-06](https://www.perplexity.ai/help-center/comet/en/articles/11734754-why-can-t-i-access-comet.html)

## 9. AutoGLM｜本周静默

核验范围：智谱/清言官网、Z.ai Blog、AutoGLM 产品及模型页面、GitHub/ModelScope/Hugging Face 官方组织、官方公众号/社媒可索引内容；窗口内未发现 AutoGLM 手机/网页 Computer Use 新版本、评测、开放范围、定价或权限确认机制更新。检索结果中的历史演示与旧 benchmark 均未纳入。静默原因仅记为“官方可检索发布渠道无新增”。[AutoGLM 官方既有项目入口（核验用，非本周新闻）](https://github.com/THUDM/AutoGLM)

## 10. 本周显著活跃同类：Salesforce Agentforce 与 Glean（企业 Headless Agent）

### Salesforce Agentforce（8月7日）

Salesforce 发布 2026 Agentic Enterprise Index，基于 2025年2月至2026年4月、每月均有生产 Agent 的企业聚合使用数据。平均每组织激活 Agent 数近 3 倍，创建到使用平均 2 天且创建耗时下降 53%；Agentforce 的 Agentic Work Unit 截至2026年4月月复合增长 15%。零售 Agent 多数平时仅 1—2 个动作，高峰平均可执行 9 种技能；客户服务转人工率在会话扩大时维持 32%。Pandora 案例中 Agent 处理 60% 常规支持请求、NPS 提升 10%；部署购物 Agent 的零售商假日线上销售同比增长 8%，未部署者 2%（4倍增长率）。

这些是真实生产采用指标，但不是浏览器/OS benchmark，也不能证明因果：官方方法明确结果不代表 Salesforce 自身性能，且样本要求连续生产使用，存在幸存者偏差。工程趋势是 headless 架构绕过 UI 直接触发业务逻辑；金融案例可查余额、贷款状态、转账，必须置于登录后并配合法务/合规治理。相较开放浏览器 Agent，这种 API/业务规则约束的形态任务更窄，却更容易审计、扩展与商业化。[Salesforce 官方原文，2026-08-07](https://www.salesforce.com/news/stories/agentic-enterprise-index-insights-2026/)

### Glean（8月7日）

Glean 本周文章给出 Work AI Index 摘要：87% 数字工作者使用 AI、75% 自报更高生产力，但仅 13% 认为组织绩效显著改善。文章明确指出生产 Agent 的难点是 authentication/permissions、动作边界、模型/工具调用成本和长推理循环；并挑战“permission-aware 就等于安全”“只读 Agent 风险低”“有审计日志就足够”等假设。虽然文章主要为 8月26—27日 Glean:GO 会议预告，不是新产品发布，但它代表企业 Agent 的评价重心已从采用率转向 ROI、风险、成本和可验证边界。[Glean 官方原文，2026-08-07](https://www.glean.com/blog/glean-go-2026-reasons-to-attend)

## 本组洞察

1. **Browser Use 正从独立产品变为执行组件。** Operator 已并入 ChatGPT agent；Kimi 用 WebBridge 复用登录态；Genspark 把 Agent 嵌入 Office；企业端则用 headless API 直接执行业务逻辑。用户购买的不再是“会点击”的演示，而是可交付文件、可持续 Goal、可审计动作。
2. **本周没有任何固定对象发布可比的浏览器/OS任务完成率。** Terminal‑Bench、客服自主解决率、AWU、NPS、销售增速各测不同层级，禁止横向拼成“谁更强”。这周最重要的信号恰恰是产品公司更愿意披露业务结果，而非 WebArena/OSWorld。
3. **登录与权限成为体验/安全的同一瓶颈。** OpenAI 用 takeover 且敏感输入期间不截屏；Kimi 允许 Ask permission 或 Full access；Manus 只调用已授权连接器；Qwen 可缩窄子 Agent 工具。越顺滑地复用 cookie/OAuth，越需要最小权限、短授权、可撤销和动作级审计。
4. **支付和高影响动作仍不适合默认全自动。** 本周没有产品宣布取消确认。OpenAI 明确高影响动作确认与 watch mode；金融 Headless Agent 也置于登录后及合规框架内。可靠路线是“Agent 准备—人确认—系统执行”，而非让开放网页 Agent 持续握有支付能力。
5. **隐私风险从截图扩展到本地文件和跨服务数据。** ChatGPT agent 截图/浏览记录随会话留存；Kimi Work 可接触本地目录、shell 和已登录浏览器；Manus/ElevenLabs 涉及跨服务音频处理；GenOffice 模型请求经 Genspark proxy。企业采购应画清数据路径，而不是只问模型是否训练数据。
6. **多 Agent 商业价值取决于成本和冲突控制。** OpenAI ultra、Kimi 300-Agent、Qwen forks 都强调并行；但 Qwen 已明确共享目录可能冲突，Glean也指出重复工具调用和长循环会推高成本。并发上限不是生产吞吐，必须配预算、验收证据、幂等与文件隔离。
7. **开源和 Skills/Plugins 正形成新生态，也形成供应链攻击面。** GenOffice 降低定制门槛；Qwen Skills 可 Git 分发；Anthropic 把技能/插件恶意扫描做成 Enterprise beta。未来平台差异化将来自签名、扫描、权限清单、来源信誉和运行时隔离，而不只是 Skill 数量。

## 统计与核验说明

- **固定对象覆盖**：9/9 全部核验。
- **本周有实质产品/工程动态**：6/9（OpenAI、Anthropic〔安全生态更新，Computer Use 本体静默〕、Manus、Genspark、Kimi、Qwen）。
- **本周无重大动态**：3/9（Google Project Mariner、Perplexity Comet、AutoGLM）。
- **额外同类产品**：2 个（Salesforce Agentforce、Glean）。
- **实际读取官方全文**：OpenAI 3 篇、Anthropic 1 篇、Manus 1 篇、Kimi 2 篇、Qwen 3 篇、Genspark 官方博客全文检索 + GitHub 1 篇、Salesforce 1 篇、Glean 1 篇；均超过 200 字。Comet 支持页因 Cloudflare 403 仅用于静默核验，不作为重大动态证据。
- **关键数据口径**：均保留官方日期和原文链接；未找到可独立复核的第二官方/第三方来源时明确标注“官方宣称/案例/营销指标”，不伪造双源。
- **时间窗纪律**：正文动态只采纳 2026-08-03 00:00—08-09 24:00（Asia/Shanghai）；静默对象所列历史入口仅说明核验范围，不作为本周新闻。
## 企业垂直 Agent与协议评测

**严格时间窗：** 上海时区 2026-08-03 00:00—2026-08-09 24:00（即截至 2026-08-10 00:00；检索于 2026-08-10）。窗口外材料均明确标注为背景，不计作本周动态。

**固定覆盖清单：** Sierra、Glean、Harvey、ServiceNow AI Agents、Salesforce Agentforce、Microsoft Copilot Agents、字节 Coze/扣子、MCP 协议与工具生态、Agent memory/context engineering、sandbox/permission/identity/audit/observability、SWE-bench、OSWorld、WebArena、GAIA、τ-bench、Agent 安全红队论文。

## 一、企业与垂直 Agent

### 1. Sierra

**本周核验：未发现可确认的官方产品发布、融资、定价或客户案例更新。** 检索范围包括 Sierra 官网资源/新闻、Sierra Research 与其 GitHub 组织，以及 2026-08-03 至 08-09 的网页索引；搜索命中主要是既有演示页，页面未给出落在本时间窗的发布日期，故不把搜索引擎抓取时间误报为发布日期。作为背景，Sierra 的产品定位仍是面向消费者服务的企业 Agent，典型任务覆盖推荐、服务补救与取消挽留；其商业价值应以端到端解决率、升级人工率、客户满意度及每解决任务成本衡量，而非单纯对话量。[Sierra 官方资源中心](https://sierra.ai/resources)；[Sierra Research](https://sierra.ai/research)。治理上，此类 Agent 会执行退款、改签等真实动作，企业采购时应要求按客户身份继承权限、敏感动作二次确认、工具调用全链路审计以及可归因到具体策略/模型/知识版本。无新动态不等于能力停滞，只表示在公开可核验渠道与本周窗口内证据不足。

### 2. Glean

**本周核验：未发现落在窗口内的官方 Agent 发布。** 已逐页核验 Glean Work AI Blog、Agent evaluation 指南及公开产品内容；搜索结果中的“enterprise agent evaluation guide”实际标注 **Last updated Aug 01, 2025**，属于旧文，不能作为本周新闻。[Glean 官方博客](https://www.glean.com/blog)；[评测指南原文（2025-08-01，背景）](https://www.glean.com/blog/enterprise-agent-evaluation-guide)。不过该文对企业落地仍有直接工程价值：建议先由领域用户整理约 20 个真实样例，设一个北极星指标并拆成 2—4 个子指标，优先采用清晰的二元评分；改进顺序是指令、上下文结构、参数、模型。其核心客户价值来自跨企业知识源的检索与权限感知，而 ROI 应看查找时间、任务完成质量、采用率和延迟/成本。风险在于“能检索”不等于“有权行动”：连接器需沿用源系统 ACL，评测集需覆盖越权、过期知识和引用错误，并保存查询、检索证据、模型输出与动作日志用于审计归因。

### 3. Harvey

**本周核验：未发现可确认的官方公告。** 检索 Harvey 官方站点的 News/Blog、产品与客户案例，并以 2026-08-03—08-09 限定检索；未得到带本周发布日期的原文，因此不采信无日期的聚合转载。[Harvey 官网](https://www.harvey.ai/)；[Harvey Newsroom](https://www.harvey.ai/newsroom)。Harvey 面向律所与企业法务，价值不是“生成更多文字”，而是压缩尽调、合同审阅、诉讼研究与知识检索周期；ROI 应结合律师工时节省、交付周转、引用准确率、返工率和客户可计费规则评估。法律垂直场景的部署门槛高于通用办公 Agent：需要事项级隔离、最小权限、数据驻留与保留策略、来源引用、人工复核以及对每次检索和草拟所用材料的完整审计。还要区分供应商宣称的效率与客户可复现的受控实验，尤其避免把节省的内部时间直接等同为可确认收入。

### 4. ServiceNow AI Agents

**本周核验：未发现窗口内官方发布。** 检索 ServiceNow Newsroom、AI Agents 产品页、开发者与 WorkArena 相关官方页面，命中多为既有产品说明及 2026 活动页，未见 8月3—9日正式公告。[ServiceNow AI Agents 官方页](https://www.servicenow.com/products/ai-agents.html)；[ServiceNow Newsroom](https://www.servicenow.com/company/media/press-room.html)。其优势在于 Agent 可直接嵌入 ITSM、CSM、HR 与安全工作流，客户 ROI 更应以工单自动解决率、平均处理时长、变更失败率、员工等待时间及每工作流成本计算。部署治理关键是让 Agent 身份进入既有 CMDB、角色访问控制、审批链和审计体系，不能以共享服务账号绕过职责分离；高风险变更应受策略门、沙箱验证、人工批准和回滚约束。公开活动或营销页不能替代客户生产指标，故本周不作“新增能力”判断。

### 5. Salesforce Agentforce

**本周有明确官方数据更新。** Salesforce 于窗口内发布 2026 Agentic Enterprise Index，基于 Agentforce 聚合使用数据称：每组织激活 Agent 数在财年内接近 **3 倍**，从创建到使用平均 **2 天**且创建时间下降 **53%**；截至 2026 年 4 月，Agentic Work Unit（AWU）以 **15% 月复合增长**，零售占月度 AWU 的 **22%**、旅游占 **10%**。Pandora 案例称高峰期 Agent 处理 **60%** 常规支持请求、NPS 提升 **10%**；这些数字均来自 Salesforce 官方、发布日期为本周，应视为供应商口径而非独立审计。[官方原文（2026-08-07左右，检索于08-10）](https://www.salesforce.com/news/stories/agentic-enterprise-index-insights-2026/)。工程意义是企业正在从“答复 token”转向可计量动作单元；但 AWU 尚非跨厂商标准，不能直接代表经济价值。采购方应把 AWU 对齐成功交易、避免升级、收入或节省工时，并按 Agent 身份实施登录后授权、字段级权限、审批、回滚和动作审计。复杂金融操作尤其需要把身份验证、政策版本和工具调用证据绑定到单次决策。

### 6. Microsoft Copilot Agents

**本周核验：未发现正式官方发布。** 检索 Microsoft Copilot Blog、Copilot Studio 更新页、Microsoft Learn 与 Adoption 站点；结果主要为既有 Copilot Studio 能力及 2026 活动，没有日期落在 8月3—9日的产品公告。[Copilot Studio 官方入口](https://www.microsoft.com/en-us/microsoft-copilot/microsoft-copilot-studio)；[Microsoft Learn：Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/)。企业价值来自将 Agent 接到 Microsoft 365、Dataverse、Power Platform 与业务连接器，但授权边界易因共享连接、委托权限和环境迁移变得模糊。ROI 应按每流程成功完成率、人工接管、许可与模型调用总成本衡量，不能仅报“创建了多少 Agent”。部署时应使用环境隔离、DLP 策略、最小权限连接、发布审批、管理员清单和运行日志，并将 Agent、所有者、连接器、服务主体及数据源形成可查询的责任图。本周缺乏新原文，故不把活动页或 Learn 页面更新时间当作发布。

### 7. 字节 Coze / 扣子

**本周核验：未发现可证实的正式发布。** 检索 coze.cn、docs.coze.cn 的模型发布/下线通知、产品文档与公开内容，搜索命中多为用户分享或无发布日期文档；例如“模型发布动态”和“模型下线通知”未在抓取页提供本周新增条目，不能据此推断产品变更。[扣子官方文档](https://docs.coze.cn/)；[模型发布动态](https://docs.coze.cn/guides_model_release_note)；[模型下线通知](https://docs.coze.cn/guides_model_offline_note)。Coze 的客户群更偏开发者、运营和中小企业低代码自动化，ROI 取决于搭建周期、插件调用成本、工作流成功率和人工替代时长。风险集中在第三方插件权限、密钥托管、知识库数据边界、公开 Bot 泄漏和模型下线造成的回归；上线应锁定模型/工作流版本、隔离测试与生产空间、限制插件权限，记录发布者、调用链、输入输出和失败补偿。由于公开中文站索引不完整，本结论是“未找到可核验动态”，不是断言平台本周绝无灰度更新。

## 二、协议、记忆与基础工程

### 8. MCP 协议与工具生态

**本周核验：未发现新的正式规范版本，但生态状态值得校准。** 官方当前可核验规范仍为 2025-06-18 版：以 JSON-RPC 2.0 建立 host/client/server 架构，服务器暴露 resources、prompts、tools，客户端可提供 sampling、roots、elicitation，并支持能力协商、取消、进度与日志。[MCP 规范原文](https://modelcontextprotocol.io/specification/2025-06-18)。官方 servers 仓库已明确：这里只保留 steering group 的少量**参考实现**，生产目录应去 MCP Registry；参考服务器不是 production-ready。仓库列出 C#、Go、Java、Kotlin、PHP、Python、Ruby、Rust、Swift、TypeScript SDK。[官方 servers 仓库](https://github.com/modelcontextprotocol/servers)；[MCP Registry](https://registry.modelcontextprotocol.io/)。标准化意义是减少工具适配的 N×M 成本并让能力协商可移植；风险是协议本身不能强制安全原则。生产系统仍需可信发布/签名、服务器身份、细粒度 OAuth scope、用户同意、参数校验、网络与文件沙箱、工具结果来源标记和全链路审计，尤其不能信任工具 description/annotation。

### 9. Agent memory / context engineering

**本周有一项供应商研究报告更新，但日期元数据存在冲突。** Mem0 页面 front matter 标注发布 **2026-08-07 14:05 UTC**，正文作者区却显示 Jul 18, 2026；因此本周只确认“页面元数据在窗口内更新”，不把全部结果视为本周首次发布。报告列出 LoCoMo 1,540题、LongMemEval 500题，以及 BEAM 的 1M/10M token 尺度；供应商自报 LoCoMo **92.5**、LongMemEval **94.4**，平均每查询约 6,900 tokens，并公开评测框架。[Mem0 报告原文](https://mem0.ai/blog/state-of-ai-agent-memory-2026)；[memory-benchmarks GitHub](https://github.com/mem0ai/memory-benchmarks)。背景论文 ACC（2026-01-15）主张以有界内部状态替代无限 transcript replay，并将 artifact recall 与 state commitment 分离，以降低漂移和记忆投毒。[ACC 论文](https://arxiv.org/abs/2601.11653)。工程上，context engineering 正从“塞满窗口”转为带 provenance、TTL、冲突处理、身份分区和写入审批的状态管理；需同时评估准确率、陈旧率、删除可验证性、token/延迟与跨用户污染，而供应商自测必须由独立数据复验。

### 10. Sandbox / permission / identity / audit / observability

**本周未发现单一权威标准发布；核验官方协议、安全研究与基础设施资料后，结论是这些能力仍需组合实现。** MCP 规范明确任意数据访问与代码执行需要显式同意、访问控制和工具安全，但也直言协议无法在协议层强制这些原则。[MCP 安全章节](https://modelcontextprotocol.io/specification/2025-06-18#security-and-trust--safety)。生产参考架构应分五层：①每 Agent/任务短期身份与最小权限 token；②网络、文件、进程和凭证隔离的 sandbox；③高风险写操作策略门与人审；④不可篡改事件日志，关联用户、Agent、模型、prompt/策略版本、工具参数和资源变更；⑤面向任务成功、成本、延迟、失败类型和安全事件的 trace/metric。仅有容器并不等于安全，宿主挂载、云元数据、出站网络和持久凭证仍可能越界；仅有 observability 也不能替代 prevention。采购评估应要求权限撤销时延、回放能力、数据留存/删除、跨租户测试及事故归因 SLA，而不只看“支持 RBAC”。

## 三、Agent 评测与安全红队

### 11. SWE-bench

**本周未见官方公告或基准版本更新。** 已核验官方 leaderboard、文档及 GitHub；官方“Latest News”最近列出的仍是 2025-01 的 Multimodal 私有测试集评测与云评测，SWE-bench Verified 背景为 **500 个工程师确认可解**的问题。[官方文档](https://www.swebench.com/SWE-bench/)；[官方 GitHub](https://github.com/SWE-bench/SWE-bench)。SWE-bench 的标准化价值是把“给定仓库+issue生成 patch”落到 Docker 可复现执行测试；官方建议评测主机至少约 **120GB 空闲存储、16GB RAM、8 CPU cores**，说明排行榜分数背后还有明显基础设施成本。局限包括数据污染、测试覆盖不足、环境构建失败、补丁投机与真实代码审查缺失。企业不能把 resolved rate 直接映射开发 ROI，应叠加代码质量、安全扫描、隐藏测试、人工复核时长和合并后缺陷率，并固定数据集、容器镜像、Agent scaffold、token预算和重试策略以保证可比。

### 12. OSWorld

**本周未见新版本；最新明确官方大更新是窗口外的 OSWorld 2.0（2026-06-26）。** 原站说明 OSWorld v1 含 **369** 个真实电脑任务，8 个 Google Drive 任务可因网络依赖改为 361 项评测，提供 **134** 个 execution-based evaluator；初始论文对比中人类完成率 **72.36%**、当时最佳模型仅 **12.24%**，这些是历史基线而非当前榜首。[OSWorld 官方原站](http://osworld-v1.xlang.ai/)；[OSWorld 2.0](https://osworld-v2.xlang.ai/)。它的意义在于跨 Ubuntu/Windows/macOS、跨应用、从真实初始状态执行验证，比静态问答更接近桌面 Agent。限制是 GUI/应用版本、网络、账号状态和随机弹窗造成高方差，成本也受 VM 并发与重放影响。企业使用时应报告任务排除项、环境快照、失败归因、危险动作拦截和权限配置，不能把旧版与 2.0 或 361/369 设置混排行。

### 13. WebArena

**本周未发现官方 benchmark 更新。** 核验 WebArena 套件入口、原始 WebArena 页面和项目列表；官网仍将其定义为可自托管、模拟真实网站的交互环境，并通过参考答案或程序化检查中间状态验证功能正确性。[WebArena 官方原站](https://webarena.dev/og/)；[WebArena-x 项目入口](https://webarena.dev/)。该基准的工程价值是测试高层自然语言指令到网页操作的长程规划，观察可用 screenshot、DOM 或 accessibility tree，能暴露登录态、导航、跨站检索和状态写入问题。局限是克隆网站与真实 SaaS 差异、站点状态漂移、任务模板泄漏，以及“最终状态正确”可能漏掉过程中的隐私或越权行为。生产评测应增加每步策略合规、域名 allowlist、凭证隔离、不可逆动作确认、轨迹重放和成本/延迟；同时固定浏览器、站点镜像和种子，避免将环境噪声误判为模型能力。

### 14. GAIA

**本周 leaderboard 数据集有运行性更新迹象，但未发现正式版本公告。** Hugging Face 官方组织页在抓取时显示 results_public “updated about 1 hour ago”，leaderboard 共约 **619** 个 Agents；独立 leaderboard 页面显示当前顶部条目 93.36，提交日期 2026-06-03，而非本周新提交。[GAIA 官方组织页（检索日期 2026-08-10）](https://huggingface.co/gaia-benchmark)；[官方 Leaderboard](https://gaia-benchmark-leaderboard.hf.space/)。因此应区分数据集后台更新与新基准发布。GAIA 衡量通用助手在检索、推理和工具使用上的问题解决能力，适合比较端到端系统；但公开榜单含多模型路由、搜索资源和自报系统，成本、工具预算、人工介入与可复现性可能不一致。93%级总分不能直接代表企业流程可靠性；采购方应要求逐级难度、失败样例、调用成本、数据泄漏防护、答案证据和重复运行方差，并用内部私有任务防止 benchmark overfitting。

### 15. τ-bench / τ³-bench

**本周未发现正式发布；但官方仓库已明确原 τ-bench 任务过时，应使用 τ³-bench。** τ³ 仓库最近明确更新为 **2026年7月 v1.0.1 grading update**：修复 banking_knowledge 任务错误，旧于 1.0.1 的该域分数与新版本不可比；并包含 banking knowledge、voice full-duplex，以及累计 75+ 任务修复。[τ³-bench 官方仓库](https://github.com/sierra-research/tau2-bench)；[旧 τ-bench 仓库的弃用警告](https://github.com/sierra-research/tau-bench)。这对工程标准化很关键：客户服务 Agent 不只答题，还必须在政策约束下与模拟用户交互并正确调用工具；Pass^k 还能揭示重复运行可靠性下降。限制包括 LLM 用户模拟偏差、任务政策覆盖不足、grader 版本变更和运行成本。报告必须锁定版本/commit、域、文本或语音模式、用户模型、试验次数和 grader；真实部署还需加入身份核验、拒绝策略、资金/订单写操作审计及人工升级质量。

### 16. Agent 安全红队论文

**本周未检出新的、日期落窗且可由 arXiv 原站确认的代表论文；最新相关重点材料为窗口外背景。** DeepTrap《Red-Teaming Agent Execution Contexts》（v1 2026-05-11，v2 2026-06-14）把文件、记忆、工具、技能等可变执行上下文纳入黑盒轨迹级攻击，构建 **42 个案例、6 类漏洞、7 类场景**，评估 9 个模型；结论是攻击可在保持表面任务完成的同时诱发不安全行为，所以只看最终回复不足。[arXiv 原文及日期](https://arxiv.org/abs/2605.11047)；[代码](https://github.com/ZJUICSR/DeepTrap)。这扩展了传统 prompt injection 红队边界：应对完整轨迹做风险实现、良性效用和隐蔽性联合评分，覆盖持久记忆投毒、恶意技能、工具返回注入和工件污染。局限是针对特定运行时、案例规模有限且自动 judge 可能偏差；企业需基于自身工具图和权限做持续红队，并把检测、阻断、恢复和审计证据纳入验收。

## 四、本组洞察

1. **企业 Agent 的计量单位正在从 token/会话转向“完成的工作”。** Salesforce 的 AWU 是有用尝试，但尚非可跨平台比较的会计单位；必须映射到成功业务结果，并扣除人工接管、失败补偿、模型/平台许可和治理成本。
2. **身份与授权是 Agent 平台的真正控制平面。** MCP 等协议降低集成成本，却不会自动提供安全；短期身份、最小权限、用户同意、策略门、回滚和不可篡改审计应成为默认部署基线。
3. **评测正在走向执行环境与版本化。** SWE-bench 的容器、OSWorld/WebArena 的可控环境、τ³ 的 grader 修复都说明：不记录版本、环境、预算与排除项的榜单数字几乎不可审计。
4. **记忆既是能力乘数，也是持久攻击面。** 需要把“检索到”与“写入长期状态”分离，记录来源、TTL、主体身份和冲突，并用跨会话污染、删除验证与陈旧信息测试补足准确率指标。
5. **本周公开动态偏少，最重要的新证据是 Salesforce 的生产聚合指标；其余多数对象应诚实报告无动态。** 这比用旧文、活动页或搜索抓取时间制造“新闻”更有研究价值。

## 五、统计与核验说明

- 固定对象覆盖：**16/16**。
- 窗口内可确认的重要官方动态：**Salesforce Agentforce 1项**；Memory 页面元数据更新 **1项（日期冲突，降级表述）**；GAIA 运行性数据集更新迹象 **1项（非正式版本发布）**。
- 明确无窗口内正式动态：Sierra、Glean、Harvey、ServiceNow、Microsoft、Coze、MCP正式规范、基础工程标准、SWE-bench、OSWorld、WebArena、τ-bench、Agent安全红队论文。
- 原文核验：已直读官方公司页、协议规范/GitHub、benchmark 原站/Hugging Face 与 arXiv；关键数字均在对应段落附 URL 与日期语境。供应商 ROI 数字均标明供应商口径；无法双源独立验证者未包装成行业事实。

## 下周观察点

1. Codex 插件目录、自动批准和 MCP 2026-07-28 是否出现企业策略模板、兼容问题或真实采用反馈。
2. Claude inference hooks 与 Managed Agents 的延迟、误拒绝、data residency、技能供应链和预算治理是否有客户证据。
3. Google ADK、OpenAI Agents SDK、LangGraph 的确认、guardrail、session 与 checkpoint 语义是否趋于可互操作。
4. 多 Agent 并发产品是否披露冲突率、成本、回滚和验收证据，而不只强调并发上限。
5. Salesforce AWU、客服自主解决率等业务指标能否被客户或第三方以统一口径复验。
6. MCP Registry、OAuth scope、server provenance、工具描述注入与审计 schema 是否出现新的标准化动作。

## 关于本周报

本周报覆盖 Agent 产品、开源项目与工程生态。所有有动态对象优先阅读官方原文；开源项目直查 GitHub release、仓库页面或 API；评测回到 benchmark 原站；供应商案例与营销数据明确标注口径。无本周动态的对象按核验范围列入观察/静默，不用旧闻补位。

**四维门控结果**：覆盖 48/48 个固定与扩展对象组；原文随机抽查 5/5（Codex、Google ADK、OpenAI GPT-5.6 Sol、Salesforce Agentic Enterprise Index、OpenClaw release）；GitHub/benchmark 数据已核，API 限流项已明确；有料对象均包含产品/工程/生态/风险判断；关键数据有源，未公开或供应商口径均已标注。
