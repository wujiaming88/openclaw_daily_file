# 全球 AI Agent 研究周报 · 第 11 期（2026-08-10 ~ 2026-08-16）

> **覆盖区间**：2026-08-10 00:00 ~ 2026-08-16 24:00（Asia/Shanghai，刚结束的完整自然周）  
> **覆盖范围**：编码 Agent、开源项目与框架、浏览器/Computer Use、企业与垂直 Agent、协议、记忆、沙箱、权限、审计、可观测与评测，共核验 48 个固定与扩展对象组。  
> **数据声明**：仅写时间窗内可核验公开信息；窗外内容只作明确背景。关键事件回到官方原文，开源数据直查 GitHub 页面/API；供应商数字按供应商口径标注，无法全文核验的线索降级为观察，不以摘要下结论。

![全球 AI Agent 研究周报头图](/assets/images/2026-08-17-global-ai-agent-weekly.png)

## 本周一句话

> Agent 生态本周的主战场已经从“再加一种能力”转到“让执行可持续、可测试、可恢复、可授权”：编码产品优化环境启动与企业控制面，开源运行时集中补强确定性测试、权限和状态一致性，企业 Agent 则开始围绕长时任务、业务结果计费和可审计治理形成产品闭环。

## 🔥 本周 TOP 5 Agent 事件

### 1. OpenClaw：权限与恢复能力前移

OpenClaw v2026.8.1-beta.2 把共享密钥与目标 HTTPS host 精确绑定，未绑定即 fail closed；插件来源、浏览器标签页 consent、SQLite 快照验证与恢复也被纳入同一条安全—运维链。它的重要性不在 38.6 万 stars，而在于个人与团队 Agent OS 开始同时回答“谁能调用、凭据能去哪、状态坏了怎么恢复”。版本仍为 beta，生产采用应锁定来源、验证快照并保留回滚。

### 2. OpenAI Agents SDK：确定性测试成为运行时原语

v0.21.0 新增 provider-neutral 的 Agent、Sandbox、Realtime 与 Voice 测试工具，可在不发 provider 请求的情况下脚本化验证工作流；同时修复 RunState 中断快照、递归审批恢复、MCP 生命周期、stream cleanup 和敏感错误脱敏。Agent 测试因此从昂贵、非确定的端到端调用前移到状态机单测，可能成为框架生产成熟度的关键分水岭。

### 3. Cursor Builds：云编码 Agent 先解决环境冷启动

Cursor 为 Cloud Agents 引入后台预构建环境快照，官方称内部环境启动快 10 倍、首 token 快 3 倍；失败构建不会激活，Agent 继续使用最后成功版本，Dashboard 记录日志、commit SHA 与每次运行所用 build。编码 Agent 的瓶颈正在从推理速度转向依赖安装、环境复现和可审计执行，但快照陈旧、供应链脚本与 secret 暴露仍需治理。

### 4. SWE-Bench ProMax：评测转向大型跨文件重构

SWE-Bench ProMax 提供 170 道多语言重构题，平均修改 11.4 个文件、261.6 行代码，最佳模型 resolve rate 仅 41.2%。它将问题描述重写并人工审查测试，直面旧 benchmark 的测试缺陷和训练污染；同时披露 Sonnet 4.6 与 GLM-5 的成本/成功率差异，提示企业选型应比较单位成功成本、长程协调和失败模式，而不只看总分。

### 5. Sierra：长时 Agent 与结果计费合流

Sierra Horizon 把“每位客户一个持续数天、数周乃至数月的任务实例”作为产品形态，跨短信、电话和业务状态保持上下文，并在需要牌照判断时转人工；安全架构同时采用可信内容、自然语言政策、独立 supervisor 与确定性 guard。Sierra 继续强调按贷款、理赔、留存等 outcome 计费，但尚未公开转化提升和单位成本，商业闭环仍需客户侧验证。

## 🧭 三条主线

### 产品主线：从助手转向持续执行面

Cursor Builds、Devin Desktop、Replit 双向 MCP、OpenHands context meter、Manus 备份—删除—恢复都在把 Agent 产品从一次会话扩展为持续运行的工作空间。产品竞争点不再只是回答质量，而是环境是否预热、上下文是否可见、状态是否可迁移、任务能否恢复、用户能否在高风险动作前接管。

### 工程主线：可测试、可恢复、可授权

OpenAI Agents SDK 的离线确定性测试、LangGraph checkpoint conformance、ADK capability declaration、Claude Code 资源限制、Gemini CLI 的 sandbox/A2A 修复、MCP 的多版本字段裁剪共同指向同一底座：失败路径要可复现，恢复语义要稳定，工具权限要由身份和确定性策略约束。MCP/Skill 解决能力分发，但签名、来源、版本锁定和最小权限仍必须由运行时补齐。

### 商业化主线：从席位与 token 转向业务结果

Sierra 用业务 outcome 描述计费，OpenAI 用插件、skills 与跨职能使用深度说明企业扩张，Harvey 把 Agent 放进邮件与 matter 工作流，Glean 强调 permission-aware 企业上下文。商业价值正从“用了多少模型”迁移到“完成了什么工作”，但若缺少基线、人工接管、失败成本、动作级审计与客户侧对照，结果计费仍会面临归因争议。

## 🧩 开源生态雷达

### 事实标准候选

- **OpenAI Agents SDK / Google ADK / LangGraph**：分别在确定性测试、模型能力声明与状态图恢复上形成可复用运行时原语。
- **MCP**：进入多协议版本并存和互操作纪律阶段；字段裁剪、握手取消、认证与重连比“能否连上”更重要。
- **OpenClaw Skill / browser-use 集成**：Skill 正成为上层运行时可发现、可安装的能力分发单元，但供应链和浏览器权限仍待统一治理。

### 本周高活跃项目

- **OpenClaw**：安全边界、插件来源、浏览器 consent 与可验证快照同时推进。
- **Google ADK**：v2.7.0 用 capability declaration 代替 model-id 猜测，并补强多模态工具状态和多项安全边界。
- **OpenAI Agents SDK**：把无 provider 请求的脚本化测试带入 Agent/Sandbox/Realtime/Voice。
- **Dify**：虽无正式 release，但集中修复 sandbox、workspace credential、OAuth 与 RAG 变量访问控制。
- **OpenHands**：把上下文预算显示和手工压缩交给用户控制。

### 高审计成本与静默池

- **Hermes Agent**：稳定版汇总约 656 个 PR、1,444 次提交，但 release 说明不足，适合灰度与 compare 审计，不宜只凭版本号升级。
- **AutoGPT**：继续平台化到单容器、Expert scheduling 和 credit guardrail，但仍处 beta。
- **AutoGen、MetaGPT、SuperAGI、Swarm**：本周无 commit/release 或长期静默；历史 stars 不能替代维护连续性。
- **Aider、Roo Code**：Aider 本周无正式 release；Roo Code 已在背景期停止维护，迁移风险高于热度价值。

## 📡 Agent 产品雷达

### 编码 Agent

Claude Code、Gemini CLI、Cursor、Devin Desktop、Replit、OpenCode 与 Cline 的共同主题是运行时成熟：资源限制、云端环境快照、分层权限、双向 MCP、上下文压缩、共享 SDK 和工具级日志。Codex CLI 保持高频 alpha，生态活跃但生产团队应锁定 commit SHA；Aider 静默，Roo Code 进入终止维护风险。

### 浏览器与通用 Agent

OpenAI 的企业数据说明 Agent 增长更多来自插件、skills 与企业上下文，而非单纯 GUI 点击；Manus 的公司拆分把任务历史、生成文件和长期上下文的可移植性推到一级能力。Mariner 已在背景期结束独立产品形态，Comet、Anthropic Computer Use、Kimi、Qwen-Agent、AutoGLM 本周无可核验重大动态；Genspark 因官方正文抓取失败降级为观察。

### 企业与垂直 Agent

Sierra 在长时任务、纵深防御与 outcome pricing 上信号最强；Harvey 将法律 Agent 延伸到邮件入口并维持 matter-level controls；Glean 提供统一知识、权限和行动层的采购框架。ServiceNow、Salesforce、Microsoft Copilot Agents 与 Coze 本周未发现同时满足日期与官方原文要求的新增发布。

### 协议、评测与基础工程

MCP 进入多版本协商和 SDK 实现纪律阶段；SWE-Bench ProMax 把重点转向大型跨文件重构，OSWorld-V2 继续强化 runner、资产、镜像与版本绑定。WebArena、GAIA、τ-bench 与 Agent 安全红队论文本周无高置信新作，不能用二手榜单或搜索摘要补位。

## 四维质量门控

- **覆盖率**：48/48 个固定与扩展对象组完成核验（100%）；有料 27 个，观察/静默 21 个。Genspark 因正文抓取失败主动降级，不计有料。
- **原文深度**：随机抽查 OpenClaw、Gemini CLI、Cursor Builds、OpenAI Agents SDK、SWE-Bench ProMax 共 5 个对象，5/5 URL 返回 200 且正文数据相符。
- **GitHub/benchmark 数据**：开源 stars/forks/release/commit 直查 GitHub 页面或 API；SWE-Bench ProMax 与 OSWorld 直查论文/官方仓库。API 返回上限 100 时只写“至少 100”，不伪造精确数。
- **工程判断**：有料对象均覆盖产品、架构、生态/采用、风险与影响；全文包含产品、工程、商业化三条主线。
- **数据可信**：关键数字附来源与查询日期；无法公开或无法全文核验的内容明确写“未公开/观察”，编造零容忍。

## 各组深度正文


## 编码 Agent / CLI / IDE

- **严格时间窗**：2026-08-10 00:00—2026-08-16 24:00（Asia/Shanghai）。窗口外信息仅作为明确标注的背景，不计入“本周动态”。
- **核验方法**：逐一检查产品官网/官方博客/更新日志、官方 GitHub 仓库 Releases/Commits/Issues/API；开源项目记录查询日（2026-08-17）的可验证仓库指标。搜索仅用于发现线索，结论以全文原文或 API 数据为准。对未发现动态者说明核验范围，避免用热度替代价值判断。
- **分析维度**：产品形态；上下文、工具调用、MCP、沙箱、权限、记忆、多 Agent、可观测等工程架构；生态采用；风险与限制；关键数据；影响判断。

> 注：GitHub stars/forks 等是查询时点快照，会持续变化；贡献者数如采用 GitHub contributors API 分页/响应，应按文中口径理解。

### 1. Claude Code — 有动态

本周官方仓库连续发布 v2.1.227、.228、.229、.231、.232、.233，共 6 个正式版本；查询日仓库为 **141,668 stars / 22,740 forks / 15,278 open issues**（[GitHub API/仓库](https://api.github.com/repos/anthropics/claude-code)，2026-08-17）。[v2.1.233 官方全文](https://github.com/anthropics/claude-code/releases/tag/v2.1.233)显示，产品形态已明显超出“终端聊天”：`--worktree` 支持 GitLab MR，self-hosted runner 优化启动，Apps Gateway 可选择转发签名用户身份以做逐用户成本归因。工程侧重点是长期运行可靠性与企业治理：Linux Bash 工具可配置 memory cgroup，WebFetch 缓存 TTL 可配；修复 MCP v2 长连接反复重开、云会话在权限提示时误判丢失、sandbox 空闲占满 CPU。权限/安全方面修复 Windows NT 设备路径绕过 UNC 校验导致 NTLM 凭据泄漏，并改进 permission hooks。值得注意的是新模型默认撤下 Todo/Task 工具，暗示任务规划可能更多内化到模型或新接口，而非继续暴露旧式任务工具。风险仍是高频发布带来的回归（本周明确回滚 2.1.232 的部分 Windows Bash 权限更改），企业应锁版本、灰度升级并采集工具调用/审批/资源限额日志。影响判断：Claude Code 正把“单机编码助手”推进成可托管、可归因、可限制资源的工程执行层，价值来自治理闭环，而非 stars。

### 2. OpenAI Codex / Codex CLI — 有动态

官方仓库本周出现大量 alpha：从 rust-v0.147.0-alpha.6.6、v0.148.0-alpha.6 至 `.20`，至少 15 个预发布标签；[0.148.0-alpha.20 官方页](https://github.com/openai/codex/releases/tag/rust-v0.148.0-alpha.20)标注 2026-08-16 发布，但正文只有版本号，因此不能从标签推断具体功能，需以 commit/PR 审计后再部署。查询日仓库 **106,292 stars / 16,148 forks / 12,792 open issues**（[API](https://api.github.com/repos/openai/codex)，2026-08-17）；窗口内提交持续至 8 月 16 日，例如 [9ded177c](https://github.com/openai/codex/commit/9ded177ce7c1c0bd2047f902936c177612ab3434)。产品形态仍是 Rust CLI/本地 Agent 与 OpenAI 云端能力的组合；工程关注点通常落在会话编排、命令执行、沙箱/审批、MCP 与终端 UI，但本周 release note 信息不足，不能声称某一特性已稳定落地。如此密集 alpha 更像快速集成与验证通道，生态活跃度高却也扩大供应链、版本漂移和行为不可复现风险。团队应优先固定 commit SHA、保留审批策略和执行日志，生产环境不要追随 alpha latest。影响判断：本周最确定的信号不是单一功能，而是 Codex CLI 仍处于高速迭代；其商业价值取决于稳定渠道与可观测性是否追上发布速度。

### 3. Google Gemini CLI — 有动态

本周发布 v0.55.1、v0.55.0-preview.3、v0.56.0-preview.1及每日 nightly。查询日 **106,536 stars / 14,444 forks / 848 open issues**（[API](https://api.github.com/repos/google-gemini/gemini-cli)，2026-08-17）。[v0.55.1 官方完整 changelog](https://github.com/google-gemini/gemini-cli/releases/tag/v0.55.1)信息密度很高：上下文层修复 `/compress` 会话重载、配额回退时工具响应丢失及 thought/历史泄漏；工具与生态层增加 tool registry discovery、刷新 MCP OAuth token；权限/沙箱层将 macOS sandbox 的 `~/.gitconfig` 设为只读、采用 deny-default profile，并修补 at-reference、防符号链接目录逃逸、A2A workspace trust/task isolation 等问题。多 Agent/自动化方向尤值得关注：仓库内 caretaker triage、PR generator、Cloud Run/Workflows/PubSub/Firestore 形成从 issue 摄取、LLM 分诊、迭代修复到 GitHub egress 的异步流水线，并加入 eval coverage/local report 与 judge runner，显示“CLI 内核 + 云端 Agent 工厂”的架构演进。风险面也由变更反证：ReAct/prompt-injection 死循环、A2A RCE、明文凭据、thought leakage 均曾需要修复；nightly 不宜默认生产使用。影响判断：Gemini CLI 的差异化正在从终端 UX 转向开放工具注册、A2A 与 GCP 原生多阶段编排，但安全边界和状态一致性必须作为首要验收项。

### 4. Cursor — 有动态

Cursor 于 8 月 13 日发布 Cloud Agents 的 **Builds**（[官方全文](https://cursor.com/changelog/08-13-26)）。其产品形态是 IDE 前台与云端异步编码 Agent 后台结合；本次不是模型升级，而是把 repo clone、依赖安装和 install script 预先固化成可复用环境快照。官方称内部环境启动 **10× 更快、首 token 时间 3× 更快**（官方原文，2026-08-13），且 Builds 随 Cloud Agents 免费提供。架构上，定期构建成功版本并保留 warm copies，坏 commit/依赖导致新 build 失败时自动继续使用最后成功版本；Dashboard 提供状态、日志、commit SHA 及每次 Agent run 对应 build，Agent 本身也可通过内置工具检查和管理 builds。这里同时覆盖 sandbox 冷启动、上下文外部依赖复现和可观测性，是云 Agent 吞吐的关键工程优化。风险是“最后成功快照”可能掩盖主干已坏或依赖陈旧；预构建脚本也具有供应链/secret 暴露面。建议设置 stale threshold、最小权限 secret、将 build SHA 写入审计与制品元数据。影响判断：云编码 Agent 的瓶颈正从推理速度转到环境准备和可复现执行；Cursor 用构建缓存将 Agent 基础设施产品化。

### 5. Cognition Devin / Windsurf（现 Devin Desktop）— 有动态

官方 changelog 本周发布 v3.7.16（8 月 10 日）与 v3.7.25（8 月 13 日），详见[官方完整更新页](https://docs.devin.ai/desktop/changelog)。产品已呈 Desktop/Local/Cloud 三层：Desktop 是 agent-native IDE/command center，Local 在工作树执行，Cloud 保持长任务。本周工程改进覆盖多 Agent 与上下文：Customizations 新增 Subagents，统一搜索 skills/rules/hooks/plugins/MCP；ACP 大文件读取改为有界分页；远程 WSL/SSH/dev container 下从远端打开 codemap/MCP 配置。权限模型把 enterprise、mode、user、project、subagent 多层规则改为确定性组合，显式 deny 永远胜出并显示拒绝来源；网络访问受管理员策略约束。可观测性方面每个 MCP server 独立日志通道，共享 Local 会话前会移除系统提示/工具定义、脱敏 secrets 和规范化路径。v3.7.25 修复部分自托管 GitLab/旧 Atlassian MCP 鉴权，并优化数千缓存会话下侧栏性能。风险仍包括转录脱敏遗漏、插件跨设备默认同步、重启停止本地 Agent，以及 worktree/远端路径边界。影响判断：Cognition 正将 Windsurf 品牌整合为 Devin 的桌面控制面，竞争点从补全转向多执行域、分层权限和企业可审计性。

### 6. Replit Agent — 有动态

[8 月 14 日官方更新全文](https://docs.replit.com/updates/2026/08/14/changelog)显示 Replit 正由封闭式在线 IDE Agent 转成可被其他 Agent 调用的平台：官方 MCP Server 可让 ChatGPT、Claude、Slack 或兼容客户端创建、查找、检查、更新、发布 Replit app，并可复制现有 app。Agent 内又新增 Cal.com、Airtable、Rootly Docs MCP；这形成“双向 MCP”——既消费外部工具，也把 Replit 的构建/部署能力暴露为工具。产品层新增对数据问题直接生成 inline chart、由 Agent 迁移 Replit Auth 至 Clerk（先迁账户数据再改登录代码）。记忆/复用层以 workspace skills 共享：成员可私有或共享，其他成员默认关闭、管理员可强制技能。治理侧 Pro 可选择北美/EU/亚洲区域，Enterprise Admin API beta 可按成员/项目/工作区查看 usage 并编辑 budgets。风险集中于 MCP 跨系统授权、发布动作的破坏性、技能强制启用及身份迁移一致性；必须使用细粒度 OAuth、审批、区域/预算策略和发布回滚。影响判断：Replit 的护城河正在变成“Agent 可调用的应用生命周期平台”，而不只是浏览器里的代码生成器。

### 7. OpenCode — 有动态

OpenCode 本周 8 月 10、12、13 日均有官方更新（[官方 changelog 全文](https://opencode.ai/changelog)，并以 [GitHub Releases](https://github.com/anomalyco/opencode/releases)交叉核验）。查询日仓库 **198,147 stars / 25,523 forks**（[GitHub 仓库页](https://github.com/anomalyco/opencode)，2026-08-17）；8 月 12 日 release 明列 **6 名 community contributors**，可追溯到对应 PR。产品形态覆盖 CLI/TUI、Desktop，并内建 full-access build agent、只读 plan agent及 general subagent。最重要的工程改动是上下文压缩：保留完整近期 turns、为小模型生成更清晰摘要，避免早期工具结果与调用脱节；这直接影响长会话记忆的因果完整性。可靠性上给自动重试设上限并加 jitter，避免 provider 故障形成 retry storm；模型路由修正 Kimi/Moonshot、xAI、DeepSeek、Muse 与 MERGE Gateway reasoning variants，体现多模型抽象层的维护成本。生态上 GitHub Copilot 模型可附 PDF；Desktop 避免用陈旧本地默认模型覆盖服务端配置。权限架构仍需注意：build 模式全权限，而 plan 模式默认拒绝编辑并在 Bash 前询问，用户若无意识切换模式，风险边界显著不同。影响判断：OpenCode 的价值不是庞大 star 数，而是开放的多供应商适配与可审计 PR；本周工作集中解决长会话一致性和故障风暴，属于生产成熟度提升。

### 8. Aider — 观察/静默

核验范围包括 [官方 release history](https://aider.chat/HISTORY.html)、[GitHub Releases](https://github.com/Aider-AI/aider/releases)、仓库主页面及窗口内可见发布记录。查询日仓库 **48,274 stars / 4,848 forks**（[GitHub 仓库](https://github.com/Aider-AI/aider)，2026-08-17）。未发现 2026-08-10—08-16 期间有带日期的正式 release；GitHub Releases 顶部仍是更早的 GPT-5 支持版本，而 HISTORY 的 “main branch” 是未发布累积项，不能冒充本周发布，因此本组不把其中 Claude/Gemini/GPT 新模型条目计为本周动态。贡献者信息也只在具体旧版本中按署名列出，本窗口没有新 release 可形成“本周贡献者”口径。作为背景，Aider 仍是 terminal pair-programming 形态，以 repo map 做大仓库上下文、git 自动提交/撤销、lint/test 闭环为核心；相较云端多 Agent，它的优势是本地、简单、可用 Git 审计，限制是工具编排、MCP、沙箱和企业权限治理较弱。结论：本周保持观察，不能因累计 stars 或 main 分支文字更新而判定产品动态。

### 9. Cline / Roo Code — 有动态（Cline 活跃，Roo 静默）

Cline 本周官方 Releases 发布 4.1.8—4.1.10及对应 SDK/CLI/Desktop 包（[官方 Releases 全文](https://github.com/cline/cline/releases)）。查询日 Cline 为 **66,298 stars / 7,131 forks**（[仓库](https://github.com/cline/cline)，2026-08-17）；release notes 按 SDK bundle 追踪贡献/变更，但页面未给稳定的窗口贡献者总数，故不臆造总量。架构信号很强：SDK 成为 VS Code、CLI、Desktop 与多 Agent Kanban 的共享内核；provider-native web search 默认关闭，调用与结果写入会话历史；Hub daemon 用 build total-order 和兼容协议解决多安装互相杀死、升级中断会话的问题；闲置 plugin sandbox 回收。权限上 Claude Code provider 改用其 native tools，加载 `~/.claude` 和项目权限，工作区编辑自动允许但命令仍受 Claude 设置控制。可观测性修正 token 遥测重复计数（缓存重会话曾约膨胀 5×）、降低无价值 stream delta 事件，并为每个工具调用展示独立状态/输出。风险在 auto-approve 迁移、跨 bundle 行为差异、持久化 web 搜索内容与共享 daemon 隔离。

Roo Code 则经 [官方仓库 README 全文](https://github.com/RooCodeInc/Roo-Code)核验，扩展已于 **2026-05-15（背景）**关闭，仓库本周无新 release；查询日仍有 **24,337 stars / 3,415 forks**（[仓库](https://github.com/RooCodeInc/Roo-Code)，2026-08-17），但历史热度不代表可持续维护，官方建议迁移 ZooCode 或 Cline。故本对象整体列“有动态”仅来自 Cline，Roo 明确为静默/终止维护风险。

### 开源仓库数据口径补充

| 对象 | 查询日指标 | 本周 release/贡献者核验 |
|---|---|---|
| Claude Code | 141,668 stars / 22,740 forks | 6 个正式 release；API 限流后未获得可靠 contributor 总数，不臆造 |
| OpenAI Codex | 106,292 / 16,148 | 至少 15 个 alpha 标签；release 页未列 contributor 总数 |
| Gemini CLI | 106,536 / 14,444 | v0.55.1 等；该 release 明列 5 名 new contributors |
| OpenCode | 198,147 / 25,523 | 8/10、8/12、8/13 更新；8/12 release 致谢 6 名 community contributors |
| Aider | 48,274 / 4,848 | 窗口内无正式 release，因此无本周贡献者口径 |
| Cline | 66,298 / 7,131 | 4.1.8—4.1.10及多包发布；官方页未给稳定总数 |
| Roo Code | 24,337 / 3,415 | 5/15 已关闭（背景），本周无 release/contributor 活动 |

> 指标来源均为对应 GitHub 仓库页面/API，查询日期 2026-08-17。GitHub 未认证 API 在采集中触发限流；对无法从官方页面稳定得到的 contributor 总数明确记为 unavailable，而非用猜测填补。

### 本组洞察

1. **编码 Agent 的核心竞争从模型转向运行时。** Cursor 的预构建快照、Claude Code 的 cgroup/self-hosted runner、Cline 的 Hub 升级协议，都在解决环境冷启动、资源失控和长会话中断。
2. **权限正在从单一“允许/拒绝”升级为分层策略。** Devin 将 enterprise/mode/user/project/subagent 组合且 deny 优先；Claude、Cline 也把本地设置、项目规则和审批打通。企业采购应测试策略冲突与拒绝原因可解释性。
3. **MCP 进入双向平台化阶段。** Replit 既消费 MCP 又作为 MCP Server 暴露完整应用生命周期；Claude/Gemini/Devin/OpenCode则重点修复 OAuth、连接重开和日志。这意味着生态扩大，同时把凭据、网络与发布权限变成主要攻击面。
4. **上下文压缩与遥测准确性是“隐形可靠性”。** Gemini、OpenCode、Cline都修复历史/工具结果丢失、thought 泄漏或 token 重计。没有可重放 transcript、build SHA、工具级日志和准确成本桶，benchmark 分数无法转化为生产可信度。
5. **热度不能替代维护状态。** Roo Code 即使仍有 2.4 万 stars，也已停止服务；Aider 本周无正式发布。评估应以窗口内 release、可追溯 PR、维护连续性与安全响应为准。
6. **SWE-bench/社区增补核验**：本周搜索了 SWE-bench、主流 IDE 集成与开发者社区线索；在严格要求“官方全文 + 时间窗可证”的条件下，未发现需要新增且证据强度高于上述固定对象的独立编码 Agent 事件，故不以二手榜单或热帖扩充对象数。


## 开源框架与项目

- **严格时间窗**：2026-08-10 00:00—2026-08-16 24:00（Asia/Shanghai；对应 GitHub UTC 检索时按事件时间逐条换算）
- **查询日期**：2026-08-17（Asia/Shanghai）
- **方法**：逐项目核验官方 GitHub 仓库/API、release、commit、PR 与官方文档/博客；正文只纳入本周重大 release/架构或安全变化、显著且可解释增长、头部集成/生产采用、新工程范式、benchmark 突破或有实质内容的工程讨论。GitHub stars 仅作规模背景，绝不等同技术价值。无达标动态者进入观察池/静默池。数字均保留可复核 URL 与查询日期。
- **口径限制**：GitHub contributors 总数在未认证 API 下无法稳定获得精确全集时，使用仓库 API 的 `contributors_url` 可复核入口，并记录本周 commit/PR 活跃作为增量代理；star 增长若无历史快照，不伪造周增量。

### 1. OpenClaw｜有料：安全边界与可运维性同时前移

本周 [v2026.8.1-beta.2 官方 release 全文](https://github.com/openclaw/openclaw/releases/tag/v2026.8.1-beta.2) 是明确的重大工程版本。最关键并非模型适配，而是“共享密钥—目标主机”绑定：CLI、Gateway RPC、Control UI 在把 sentinel 替换为明文前校验精确 HTTPS host，未绑定即 fail closed；配合任意可执行插件来源需 `--force`、浏览器 relay 每次执行既有标签页命令都重验 consent，构成从凭证、插件供应链到浏览器权限的连续防线。架构上，频道插件引入统一 ingress monitor（持久 admission、poll、prune、claim identity、handoff、shutdown），IRC/Synology Chat/Google Chat 首批迁移；SQLite 快照获得 create/list/verify/restore 且仅允许恢复到 fresh target；浏览器扩展补齐 CDP/DevTools 兼容，使 Puppeteer/chrome-devtools-mcp 可驱动配对浏览器。产品形态已从“聊天机器人框架”进一步变成带多端控制面、持久状态、节点与浏览器执行面的个人/团队 Agent OS。风险在于 beta 变更面极大、权限与状态机复杂度高，生产采用应先验证 secret host 清单、插件信任来源、快照恢复和升级回滚。

**可验证数据（2026-08-17）**：GitHub API [仓库](https://api.github.com/repos/openclaw/openclaw) 386,471 stars、81,208 forks、5,579 open issues；本周 commits API（[固定时间查询](https://api.github.com/repos/openclaw/openclaw/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100)）首屏即满 100，说明实际至少 100；release 发布于 2026-08-15 13:36 CST。代表性 PR/提交包括 [#124673 工具取消转发](https://github.com/openclaw/openclaw/pull/124673) 与 release 中的安全条目。贡献者入口：[GitHub contributors API](https://api.github.com/repos/openclaw/openclaw/contributors?per_page=100)。判断：本周价值来自权限边界与运营恢复，不来自 star 绝对值。

### 2. LangGraph / LangChain Agents｜有料：可观测策略进入图节点与中间件

[LangGraph 1.2.11 官方 release 全文](https://github.com/langchain-ai/langgraph/releases/tag/1.2.11) 把 `trace_policy` 暴露到 `add_node`，同期 [LangChain 1.3.15](https://github.com/langchain-ai/langchain/releases/tag/langchain%3D%3D1.3.15) 将其暴露到 `AgentMiddleware`；这不是表面 API 增量，而是让工程团队能按节点/中间件声明追踪策略，降低长图、多模型、内部 middleware 调用造成的 trace 噪声与成本。LangChain 同周还修复 HITL approval gate 静默 fail-open、ToolCallLimit 产生孤儿 tool call、checkpoint turn 间残留 structured response、summary 失败丢历史等状态一致性问题，并增加 `wrap_tool_call(state_schema=...)`。LangGraph checkpoint 侧修复 delta channel history 的 plain-value seed writes，并让 Postgres/SQLite 跑同一 conformance suite，体现其核心竞争力仍是可恢复状态图，而不是“多 Agent 对话”包装。生态上，OpenAI 3.0、Anthropic/OpenRouter provider metadata 与 LangSmith provider 持续同步；风险是多包独立版本、provider 快速漂移和 checkpoint 兼容面会把升级测试成本转嫁给应用方，尤其 HITL 与恢复路径必须回归。

**可验证数据（2026-08-17）**：LangGraph [仓库 API](https://api.github.com/repos/langchain-ai/langgraph) 39,817 stars/6,692 forks/697 open issues，本周主分支 2 commits、release 1 个；LangChain [仓库 API](https://api.github.com/repos/langchain-ai/langchain) 144,355 stars/24,025 forks/413 open issues，本周 [commits 查询](https://api.github.com/repos/langchain-ai/langchain/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 得 42 commits，并发布 9 个核心/伙伴包版本。关键 PR：[LangGraph #8523](https://github.com/langchain-ai/langgraph/pull/8523)、[LangChain #39247](https://github.com/langchain-ai/langchain/pull/39247)。贡献者入口：[LangGraph](https://api.github.com/repos/langchain-ai/langgraph/contributors?per_page=100)、[LangChain](https://api.github.com/repos/langchain-ai/langchain/contributors?per_page=100)。

### 3. CrewAI｜有料：Flow 可观测性和前端协议接轨

[1.15.16 官方 release 全文](https://github.com/crewAIInc/crewAI/releases/tag/1.15.16) 与 [1.15.15](https://github.com/crewAIInc/crewAI/releases/tag/1.15.15) 连续推进 Flow 生产可观测性：执行上下文加入 UUID，记录终止 Flow 的异常类型、outcome、duration、HITL signals、运行 release，并修复“失败 turn 污染下一 turn”与边界 hook 中止时缺失 FlowStartedEvent。本质上是把 Crew/Flow 的运行语义映射为可归因 trace，而不是只做 prompt orchestration。官方同时增加 CopilotKit 与 AG-UI 前端指南，显示产品形态从 Python 多 Agent 编排向可嵌入交互式前端延伸；AMP trace batch 与 deployment origin 记录则强化其商业控制面。安全方面 1.15.15 升级 torch 2.13.0、gitpython 3.1.58，需注意这类重依赖升级可能带来环境兼容成本。风险/限制：telemetry 与 AMP 紧耦合可能带来数据治理顾虑；执行上下文虽提升排障能力，但跨 crew/flow 的因果一致性仍需实测；Responses API 原生 tool calls 在本周另有 [#6515 修复](https://github.com/crewAIInc/crewAI/pull/6515)，说明 provider 兼容仍是高频故障面。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/crewAIInc/crewAI) 57,175 stars、8,160 forks、796 open issues；本周 [commits API](https://api.github.com/repos/crewAIInc/crewAI/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 20 commits、2 releases；1.15.16 列出 4 位贡献者，1.15.15 列出 5 位（存在重复，不合并伪造唯一总数），完整入口见 [contributors API](https://api.github.com/repos/crewAIInc/crewAI/contributors?per_page=100)。

### 4. Google ADK｜有料：模型能力声明取代 model-id 猜测，跨模型媒体工具闭环

[ADK Python v2.7.0 官方 release 全文](https://github.com/google/adk-python/releases/tag/v2.7.0) 含 212 项变化，是本组本周最清晰的架构校正之一。首先，模型自行声明 capability，ADK 不再用 model id 猜测 output schema 与 tools 能否组合；这为 Gemini、Anthropic、LiteLLM、Apigee、OCI 多后端统一运行减少脆弱分支。其次，工具返回的图片/媒体可原样进入模型，且 Gemini thought signature、server-side tool call parts、并行 function call 的全部结果能跨轮保存，解决多模态工具链和恢复历史的“语义丢包”。新增 Jinja2 instruction template、root LlmAgent native task mode、MCP elicitation callback、异步非阻塞 skill loading，以及 Data Agent tools stable，表明 ADK 正形成模型—工具—技能—A2A—评测的完整运行时。安全修复包括 artifact 路径穿越、skill zip 条目/字节上限、A2A agent-card RPC 目标约束、DNS rebinding、防泄漏 agent instruction、生产禁用 dev endpoint；这比 feature 数量更值得生产团队关注。Breaking change 是 `pyarrow` 移出 `gcp` extra（约减 50MB），BigQuery analytics 用户需显式安装新 extra。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/google/adk-python) 21,149 stars、3,843 forks、558 open issues；本周 [commits API](https://api.github.com/repos/google/adk-python/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 首屏 100（实际至少 100），v2.7.0 于 2026-08-14 06:18 CST 发布。关键提交：[capability system](https://github.com/google/adk-python/commit/2aff82c30923e5f7df5ce4101db52bce82740329)、[tool media](https://github.com/google/adk-python/commit/df9d6dec58f4cb22a1010b72e9fd8d347ce8145a)、[artifact traversal](https://github.com/google/adk-python/commit/2716ad55b8e9eb0c4f719f65bdc0b3f2a26cc551)；[contributors API](https://api.github.com/repos/google/adk-python/contributors?per_page=100)。

### 5. OpenAI Agents SDK / Swarm｜有料（SDK）；Swarm 静默

[Agents SDK v0.21.0 官方 release 全文](https://github.com/openai/openai-agents-python/releases/tag/v0.21.0) 的核心是 provider-neutral deterministic testing：`agents.testing`、`realtime.testing`、`voice.testing` 可在不发 provider 请求时测试 Agent、Sandbox、Realtime、Voice 工作流。这把 Agent 测试从昂贵、非确定的端到端调用前移为可脚本化单测，是可复用的新工程范式。版本同时兼容 OpenAI Python 3/HTTPX2，并强化 RunState interruption snapshot 隔离、递归 agent-tool approval 恢复、max-turn 终止、stream cleanup、敏感错误脱敏、MCP lifecycle snapshot 与 retry ceiling、sandbox image path grants、音频输入校验。此前同周 [v0.20.0](https://github.com/openai/openai-agents-python/releases/tag/v0.20.0) 将默认模型改为 gpt-5.6-luna、兼容 MCP Python SDK v1/v2，并允许 RunState 持久暂存 resume 前用户输入。产品形态已从轻量 handoff SDK 走向含状态恢复、审批、MCP、沙箱、实时与语音的运行时；风险是 0.x 快速演进、默认模型变化与 MCP transport major version 对自定义 HTTP transport 构成升级破坏面。

**数据（2026-08-17）**：[SDK 仓库 API](https://api.github.com/repos/openai/openai-agents-python) 28,694 stars、4,515 forks、11 open issues；本周 [commits API](https://api.github.com/repos/openai/openai-agents-python/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 87 commits、2 releases；v0.21.0 release 列 8 位 new contributors；完整 [contributors API](https://api.github.com/repos/openai/openai-agents-python/contributors?per_page=100)。关键 PR：[testing #4362](https://github.com/openai/openai-agents-python/pull/4362)、[recursive approval #4414](https://github.com/openai/openai-agents-python/pull/4414)。**Swarm**：[仓库 API](https://api.github.com/repos/openai/swarm) 21,905 stars/2,327 forks，本周 0 commit、0 release，最后 push 2026-04-15，作为教育性 predecessor 静默，不与 SDK 合并制造动态。

### 6. OpenHands｜有料：上下文预算成为一等产品控制

[OpenHands v1.13.0 官方 release 全文](https://github.com/OpenHands/OpenHands/releases/tag/v1.13.0) 增加 context window usage meter、usage drawer 与 manual compaction。对代码 Agent 而言，这不是 UI 装饰：长任务失败常来自用户无法看见上下文消耗与自动压缩边界；把预算可视化并允许人工压缩，使“何时牺牲历史换取继续执行”成为显式的人机控制。同期加入 client-side conversation archive、inline Markdown artifact preview，以及按 issue 类型判断 ready-for-dev 的 readiness gate，说明产品从单轮代码生成向 issue intake—执行—产物审阅闭环延伸。工程上强制 agent-server API 走 typed TypeScript client、launcher 不再隐式 shell、集成无法由 MCP 安装时不再静默丢弃，分别降低接口漂移、命令注入面与可诊断性问题。限制是 manual compaction 仍需用户理解信息损失；客户端归档的多设备一致性与企业保留策略需另行评估；readiness gate 的类型规则可能误伤非标准 issue。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/All-Hands-AI/OpenHands) 84,237 stars、10,937 forks、498 open issues；本周 [commits API](https://api.github.com/repos/All-Hands-AI/OpenHands/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 34 commits，v1.13.0 于 2026-08-13 09:57 CST 发布；release 列出 4 位 new contributors。关键 PR：[context meter #16311](https://github.com/OpenHands/OpenHands/pull/16311)、[no implicit shell #16093](https://github.com/OpenHands/OpenHands/pull/16093)；[contributors API](https://api.github.com/repos/All-Hands-AI/OpenHands/contributors?per_page=100)。

### 7. AutoGPT｜有料：从经典 autonomous loop 转向可部署的 Agent 平台

[AutoGPT Platform beta v0.7.1 官方 release 全文](https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.7.1) 显示产品重心已明显转向平台化：新增单容器发行与镜像流水线、Expert scheduling（attribution、trigger、thread post、credit guardrail）及 UI、morning briefing/needs-attention 聚合、Home dashboard aggregation endpoint、可编辑 Expert Soul 文档、Tavily search/extract/crawl/map blocks，并预览 ChatGPT/Codex subscription transport。单容器与 same-origin self-hosted routing 降低部署门槛，调度+归因+credit guardrail 则是从“让 Agent 跑起来”进化到“可计划、可计费、可追踪地长期运行”。安全/多租户修复同样关键：运行依赖、测试工具、LangSmith 依赖打补丁；移除 classic 中无用脆弱依赖；修复 startup migration tenancy sweep leak；强化 container supervision。风险是 beta 平台同时覆盖 builder、marketplace、experts、chat、billing 与 auth，变更面宽；subscription transport 仍为 preview；Soul 文档和长期调度引入 prompt 治理、权限与费用失控风险。不能因历史 star 高就推断平台采用。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/Significant-Gravitas/AutoGPT) 186,646 stars、46,067 forks、516 open issues；本周 [commits API](https://api.github.com/repos/Significant-Gravitas/AutoGPT/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 14 commits，v0.7.1 于 2026-08-13 12:14 CST 发布；release 致谢 1 位新贡献者与 6 位回归贡献者。关键 PR：[single container #13758](https://github.com/Significant-Gravitas/AutoGPT/pull/13758)、[tenancy leak #13745](https://github.com/Significant-Gravitas/AutoGPT/pull/13745)、[Tavily blocks #13499](https://github.com/Significant-Gravitas/AutoGPT/pull/13499)；[contributors API](https://api.github.com/repos/Significant-Gravitas/AutoGPT/contributors?per_page=100)。

### 8. Hermes Agent｜有料但信息披露不足：超大规模稳定化 rollup

[Hermes Agent v2026.8.13 官方 release 全文](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.8.13) 将 v0.20.0 后约 656 个 PR、1,444 commits、2,172 files（+233,872/−75,244）及约 481 个已关闭 issue 汇成 v0.20.1 稳定标签，面向 Docker、hosted deployment 和 latest-tag 安装者。规模本身不等于价值，但“desktop app、gateway platforms、installer、tool system、provider catalogs”共同稳定化，且下游消费者获得固定 tag，符合重大 release 门槛。时间窗需谨慎：这些数字覆盖 8月3日至13日，其中部分早于本报告窗口，故只能作为 release 官方给出的背景总量；本周 API 显示至少 100 commits。代表性本周提交包括 [Windows process scan 探针设界避免更新卡死](https://github.com/NousResearch/hermes-agent/commit/4e3de140c7522577e3d1b5c98fb1806fc5af4fdc) 与 background-review 使用量归因/成本控制。产品形态类似本地/桌面+gateway+工具执行的 Agent runtime。最大风险是 release 明言完整 curated notes 要等 v0.21.0，当前无法对 656 PR 的行为变化、breaking risk 和安全影响逐项审计；生产升级应依赖 compare、锁定镜像摘要并做灰度，而非只信“patch”。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/NousResearch/hermes-agent) 231,551 stars、46,058 forks、32,490 open issues；本周 [commits API](https://api.github.com/repos/NousResearch/hermes-agent/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 首屏 100（至少 100），release 于 2026-08-14 04:37 CST；[compare 全量入口](https://github.com/NousResearch/hermes-agent/compare/v2026.8.3...v2026.8.13)、[contributors API](https://api.github.com/repos/NousResearch/hermes-agent/contributors?per_page=100)。

### 9. Dify｜有料：一组集中式访问控制修复（尚无本周 release）

Dify 本周没有正式 release，但官方 [本周 commits 页面全文](https://github.com/langgenius/dify/commits/main/?since=2026-08-10&until=2026-08-16) 显示一组具有共同根因的权限修复，达到安全修复门槛：保护 agent sandbox reads（[#40794](https://github.com/langgenius/dify/pull/40794)）、workspace credential mutations（[#40790](https://github.com/langgenius/dify/pull/40790)）、custom OAuth client deletion（[#40786](https://github.com/langgenius/dify/pull/40786)），并强制 RAG draft variable access boundaries（[#40745](https://github.com/langgenius/dify/pull/40745)）。这些点横跨 Agent 执行沙箱、工作区凭据、OAuth 管理与 RAG 草稿变量，反映低代码 Agent 平台的主要风险不是单一模型越狱，而是多租户对象级授权散布在众多 API controller。同期 conversation deletion 回收资源、Agent duplicate creation 返回 conflict、测试从 stand-in 迁到 SQLite ORM 真模型，有助于状态/资源一致性。产品仍是 workflow/RAG/agent/app 一体化控制面；生产方应把本周修复视为升级优先项，并复查自建版 API 网关是否存在绕过路径。由于无 release/CVE 公告，不把修复严重度或已利用情况做超证据推断。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/langgenius/dify) 152,646 stars、24,098 forks、988 open issues；本周 [commits API](https://api.github.com/repos/langgenius/dify/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 首屏满 100（至少 100），0 release；[contributors API](https://api.github.com/repos/langgenius/dify/contributors?per_page=100)。限制：未见官方 security advisory/CVE，故只陈述代码层访问控制修复。

### 10. browser-use｜有料：成为 OpenClaw 一方技能，浏览器执行层开始标准化分发

本周提交 [#5476 / f3298c5 官方 diff 全文](https://github.com/browser-use/browser-use/commit/f3298c5) 加入 first-party OpenClaw skill support：从 Browser Harness 技能源生成 Browser Use 身份的 checked-in `SKILL.md`，自动附加 OpenClaw metadata、要求 `browser-use` binary，并声明通过 `uv` 安装 CLI；同步脚本验证两个产物，减少技能文档与运行依赖漂移。它的重要性不在 feature 数量，而在生态关系：browser-use 不再只提供 Python API/CLI，而是以可安装、带依赖元数据的一方 skill 嵌入 OpenClaw，从“库”变成 Agent runtime 可发现的浏览器能力模块。架构上仍是 CDP 直接浏览器控制，适合 automation、scraping、testing、screenshots；skill packaging 让上层 Agent 统一发现/安装，但也扩大供应链和浏览器权限面。风险包括网页 prompt injection、登录态/敏感页面暴露、CDP 权限过大；metadata 只解决分发，不解决操作级授权、域名策略和审计。

**数据（2026-08-17）**：[仓库 API](https://api.github.com/repos/browser-use/browser-use) 109,443 stars、12,032 forks、355 open issues；本周 [commits API](https://api.github.com/repos/browser-use/browser-use/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 22 commits、无 release。关键提交时间为 2026-08-16 01:07 CST；[contributors API](https://api.github.com/repos/browser-use/browser-use/contributors?per_page=100)。这是头部生态集成信号，不把 star 当采用证据。

### 观察池 / 静默池（逐一核验）

| 对象 | 2026-08-17 仓库快照 | 本周核验与取舍 |
|---|---:|---|
| **Microsoft AutoGen** | [60,457 stars / 9,115 forks / 997 issues](https://api.github.com/repos/microsoft/autogen) | [本周 commits API](https://api.github.com/repos/microsoft/autogen/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 为 0、release 0，last push 2026-04-15；静默。贡献者入口 [API](https://api.github.com/repos/microsoft/autogen/contributors?per_page=100)。 |
| **LlamaIndex Agents** | [51,685 / 7,950 / 620](https://api.github.com/repos/run-llama/llama_index) | 本周 [commits](https://api.github.com/repos/run-llama/llama_index/commits?since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z&per_page=100) 10、release 0；主要为 Pinecone v8/v9、Bedrock 空 embedding、Azure AI Search 等集成修复，未见 Agent 架构/benchmark/生产采用达门槛，观察。官方 [commit 页面](https://github.com/run-llama/llama_index/commits/main/?since=2026-08-10&until=2026-08-16)，[contributors](https://api.github.com/repos/run-llama/llama_index/contributors?per_page=100)。 |
| **MetaGPT** | [69,858 / 8,882 / 129](https://api.github.com/repos/FoundationAgents/MetaGPT) | 本周 0 commit、0 release，last push 2026-01-21；静默。[contributors](https://api.github.com/repos/FoundationAgents/MetaGPT/contributors?per_page=100)。 |
| **SuperAGI** | [17,657 / 2,225 / 268](https://api.github.com/repos/TransformerOptimus/SuperAGI) | 本周 0 commit、0 release，last push 2025-01-22；静默。[contributors](https://api.github.com/repos/TransformerOptimus/SuperAGI/contributors?per_page=100)。 |

> 注：OpenAI Swarm 已在第5节单列静默；全部指定对象均已覆盖。观察/静默对象没有“本周有动态正文”，因此不伪造≥200字事件笔记。

### 本组洞察

1. **Agent 工程的竞争焦点从 orchestration API 转向“恢复与授权语义”**：OpenClaw 的 secret-host binding、LangChain 的 HITL fail-open 修复、OpenAI SDK 的 RunState/递归审批隔离、Dify 的对象级访问控制，都指向同一事实——生产事故更常发生在跨轮恢复、权限继承和异步边界，而非 prompt 本身。
2. **可测试性正在成为框架分水岭**：OpenAI provider-neutral scripted testing、LangGraph checkpoint conformance、ADK eval 与能力声明、OpenHands typed client，都把不可重复的模型调用拆成可确定验证的状态机接口。未来评估框架应看“失败路径能否离线复现”，而非 demo 成功率。
3. **Skill/Tool 分发趋向运行时标准件**：ADK 非阻塞 skill loading、browser-use 的 OpenClaw first-party skill、OpenClaw 插件 provenance warning 共同形成“可发现—可安装—可审计”的能力供应链；下一步矛盾会集中在签名、来源信任、最小权限与版本锁定。
4. **多模态与实时能力进入状态一致性阶段**：ADK 重点修复 media/tool result 和 thought signature 历史保存，OpenAI SDK 强化 voice/realtime 输入与 cleanup。行业不再缺“能接语音/图片”，缺的是中断、重放、并行调用下不丢语义。
5. **平台化与轻量 SDK 分叉加剧**：AutoGPT、Dify、OpenClaw、OpenHands向完整控制面走；LangGraph、Agents SDK 保持可嵌入核心但不断吸收运维能力。选型必须先决定要“平台所有权”还是“运行时组合权”，star 无法回答这一问题。

### 开源生态雷达候选（供总报告筛选）

- **P0：OpenClaw v2026.8.1**——secret egress host binding + 插件来源强确认 + SQLite 可验证快照，安全与运维双主线。
- **P0：Google ADK v2.7.0**——模型 capability declaration、跨 provider 工具媒体、A2A/artifact/skill 多项边界修复，架构含金量高。
- **P0：OpenAI Agents SDK v0.21.0**——无 provider 请求的确定性 Agent/Sandbox/Realtime/Voice 测试，值得作为工程范式专题。
- **P1：Dify 集中授权修复**——未发布 release 但覆盖 sandbox/credential/OAuth/RAG boundary，自建用户应追踪后续稳定版本/公告。
- **P1：browser-use × OpenClaw first-party skill**——能力库向 Agent runtime 标准化分发的生态关系信号。
- **P1：OpenHands context meter/manual compaction**——把 token/context 预算变成人机共同控制面。
- **P2：AutoGPT single-container + Expert scheduling**——平台部署和长期 Agent 运营闭环，但仍是 beta。
- **P2：Hermes v0.20.1**——变更规模异常大但 release 说明不足，列入“高活跃/高审计成本”雷达，而非直接推荐升级。

### 数据口径与可复核索引

- 所有 stars/forks/issues 来自各仓库 REST `repos/{owner}/{repo}`，查询日 2026-08-17；会随时间变化。
- 本周 commit 统计按 `since=2026-08-09T16:00:00Z&until=2026-08-16T16:00:00Z`，对应上海 8月10日 00:00 至 8月17日 00:00；返回 100 时仅声明“至少100”，不误报精确总量。
- release 日期以 `published_at` 判断；全文均通过 GitHub 官方 release/commit 页面 `web_fetch` 实读，正文提供 Markdown 链接。
- 未认证 GitHub API 的 contributors 分页总量不可稳定精确，故给出项目级可验证入口，不将首屏长度冒充总贡献者数。


## 浏览器 / Computer Use / 通用自主 Agent

- **严格时间窗**：2026-08-10 00:00—2026-08-16 24:00（Asia/Shanghai；即 UTC 2026-08-09 16:00—2026-08-16 16:00）。
- **方法**：逐项核验官方新闻/博客、产品页与 GitHub；搜索发现只作线索，判定“有动态”前必须阅读全文。动态日期以官方页面为准；旧资料只作明确背景。GitHub 以时间窗内 commit 记录及仓库元数据核查。第三方报道仅用于交叉验证，不替代官方原文。重点观察浏览器/OS 执行、任务完成能力、安全边界、人工确认、登录支付隐私、可用性及商业化。
- **口径提醒**：本周未发布新功能，不等于产品停止运营；“静默”仅表示公开可核验渠道在本时间窗无新增。

### 1. OpenAI Operator / ChatGPT Agent（有动态）

**本周动态（8月12日）**：OpenAI 发布企业采用研究《From assistance to execution》，虽非 ChatGPT Agent 单项版本更新，却给出通用 Agent 从“回答”迈向“执行”的最新一手采用数据。官方称，企业侧 Codex 在 6 月已占 Codex+ChatGPT 输出 token 的 **64%**；“前沿企业”（月度人均输出 token 前10%）人均用量是典型企业的 **8.3 倍**，1 月仅 **2.6 倍**。插件周活渗透率为前沿企业 **21%**、典型企业 **9%**，技能分别为 **19%/3%**；自 2 月以来，企业 Codex 周活用户在法务增长 **108倍**、销售和招聘各 **41倍**、市场 **26倍**，工程仅 **5倍**。样本还覆盖逾 **1000万条消息**。[官方全文（2026-08-12）](https://openai.com/index/how-enterprises-put-ai-to-work/)

**产品/工程/生态判断**：产品形态已从单一浏览器代操作，扩展为 ChatGPT Work/Codex + 插件（连接企业数据与动作）+ skills（可复用流程）的执行平台。工程核心不是纯 GUI 点击，而是“企业上下文—工具调用—文件产出—人工复核”的编排链；这比 Operator 时代对网页像素的脆弱依赖更可控。实际采用数据显示 Agent 正横向进入法务、销售、招聘、营销，生态壁垒逐渐转为插件、权限和共享流程。

**风险与限制**：官方没有披露浏览器任务成功率、支付/登录成功率或误操作率，64% 是输出 token 占比，不是任务完成率，不能据此推断可靠性。插件把 CRM、内部文档和动作权限引入 Agent，显著放大越权、提示注入、敏感信息串用与错误提交风险。OpenAI 本周明确建议使用“清晰权限、治理和人工复核”，说明高风险写操作仍不适合无监督自动化。商业化上，企业 benchmark 和插件/skills 采用正成为席位之外的扩张抓手。

### 2. Anthropic Computer Use（观察/静默）

**核验结论**：本时间窗未发现 Computer Use 的新版本、基准、定价、可用区或安全公告。核验了 [Anthropic Newsroom](https://www.anthropic.com/news)（截至 2026-08-16 的公开列表）并针对 “computer use / Claude browser / August 2026” 做定向检索；本周没有对应官方条目。搜索命中的 Computer Use 官方原文仍是 [2024-10-22 发布页（背景）](https://www.anthropic.com/news/3-5-models-and-computer-use)，不计入本周动态。

**观察原因**：Computer Use 的关键风险面仍是屏幕感知误判、网页提示注入、凭据暴露以及在登录、支付、发送/删除等不可逆动作上的确认机制，但本周官方没有新增任务完成率或安全边界数据，故不以旧 benchmark 冒充当周进展。

### 3. Google Project Mariner（观察/静默）

**核验结论**：本周无 Project Mariner 独立产品动态。核验 [Project Mariner 官方落地页](https://labs.google.com/mariner/landing)、Google 官方博客定向结果以及公开报道。需要明确的**背景**是：Project Mariner 已于 **2026-05-04** 关闭，技术迁入 Google 其他产品；报道指出其能力此前进入 Gemini Agent 与 Search AI Mode，并提到一次最多并行 10 个任务。[The Verge 背景核验（2026-05-06）](https://www.theverge.com/tech/925559/google-project-mariner-shut-down)。因此本周按“观察”而非活跃独立产品计，不把 Gemini/Chrome 的一般更新错误归名为 Mariner。

**观察原因**：Mariner 的消失反映浏览器 Agent 正由实验插件向 Gemini/Search/Chrome 原生入口收敛；这有利于登录态、页面语义和权限 UI 集成，却也让支付、邮件归档、酒店预订等跨产品动作的权限边界更重要。本周没有新的任务完成率、确认流程或隐私数据可核验。

### 4. Perplexity Comet（观察/静默）

**核验结论**：本时间窗未发现 Comet 新版本、企业套餐、公开任务成功率或安全公告。核验 Perplexity 官方 Blog 索引及 “Comet / browser / August 10–16 2026” 定向检索；搜索结果未出现当周官方原文。可见命中主要是 2025 年 Comet Enterprise/Comet Plus 旧文，均不计当周动态。[Perplexity 官方博客索引](https://www.perplexity.ai/hub/blog)

**观察原因**：作为带登录态的浏览器，Comet 的核心价值仍是搜索、页面理解与代操作一体化；核心风险是网页内容对 Agent 的提示注入、Cookie/历史记录暴露、跨标签权限扩散，以及提交订单/发送信息前是否稳定要求人工确认。本周没有可引用的新数据，故不沿用旧营销数字。

### 5. Manus（有动态）

**本周动态（8月11日）**：Manus 宣布将重新成为独立公司，并因特定司法辖区的监管要求，对部分用户在 **2025-12-29 及以后**产生的数据执行迁移性删除。受影响用户从公告日起至 **2026-08-23 07:59（SGT）**可多次备份；数据将在 **8月23—24日**删除，恢复入口于 **8月25日 08:00（SGT）**开放。受影响账户预计停用两天，备份期不收费，恢复后有补偿；Apple ID/Facebook 注册者因平台没有邮箱地址，必须留意应用内通知。官方称服务有“数百万用户”，数据存储在美国和新加坡，并明确这不是安全事件。[官方全文（2026-08-11）](https://manus.im/blog/a-note-to-our-users)

**产品/架构/商业化影响**：这不是功能更新，但对云端通用 Agent 的实际可用性影响重大。Manus 的任务历史、生成文件和长期上下文本身就是“Agent 工作状态”；公司边界变化迫使其提供备份—删除—恢复工具，说明状态可移植性与模型能力同等关键。工程上需要用户级数据筛选、多次增量备份、恢复门户及暂停访问窗口；商业上通过免收费与恢复奖励降低流失。第三方 Reuters 在 8 月11日报道其与 Meta 交易解除并恢复独立运营，方向与官方一致（Reuters 页面受 JS 限制，本文关键事实仍只采用上述官方原文）。

**风险/人机协作判断**：这是本周最强的隐私与连续性信号。用户必须在明确截止时间前主动备份，新任务生成后还需再次备份，否则会丢失；社交登录用户的通知链更脆弱。对于代登录、代购物、代办公的 Agent，任务日志可能含凭据痕迹、个人资料和商业文档，跨公司拆分时必须证明删除范围、备份加密、恢复完整性与数据驻留。本公告未给删除证明、备份格式/可移植程度或恢复成功率，仍是待验证缺口。

### 6. Genspark / 通用任务 Agent（观察：原文抓取失败，降级不计有料）

**本周动态（8月13日）**：Genspark 官方博客新增用户案例《How One US Navy Veteran Built 8,000 Websites and Never Stopped》。官方博客索引确认日期与题名；正文遭站点 Cloudflare 拒绝 `web_fetch`，因此严格按“全文阅读”规则，不采用正文中无法核验的细节，只把**官方可核验的发布事实与题名数字 8,000**列为弱动态。[官方博客索引（2026-08-13）](https://www.genspark.ai/blog)；[官方文章链接](https://www.genspark.ai/blog/how-one-veteran-built-websites)

**产品/生态判断**：题名所呈现的案例方向，是从一次性回答转向批量网站生产，符合通用任务 Agent/AI Workspace 将研究、内容、代码、部署串联的形态；8,000 是案例声称的产出规模，并非独立审计的成功任务数，也不能等同于网站质量或无人值守完成率。其生态意义更多是低代码创作者采用，而非本周底层架构升级。

**风险与限制**：批量建站会把域名、托管、第三方登录、版权素材、表单隐私、支付与持续维护集中交给 Agent。若没有逐站抽检、发布前确认、凭据最小权限、成本上限和回滚，规模会放大错误与垃圾内容。本周官方未提供浏览器/OS benchmark、失败率、人工介入次数、部署成本或权限确认设计；且正文未能全文抓取，故本项按门控降级为“观察”，不计入有料对象，不做营销外推。

### 7. Kimi Agent（观察/静默）

**核验结论**：本周未发现 Kimi Agent、Agent Swarm 或通用任务执行产品的新公告、版本、基准与商业化变化。核验 [Kimi 官方研究/技术博客索引](https://www.kimi.com/blog/)；其最新公开条目为 **Kimi K3 / PerceptionBench（2026-07-16）**，Agent Swarm 为 **2026-02-09**，均在时间窗外。另做中英文定向搜索，未发现 8月10—16日官方原文。

**观察原因**：Kimi 具有搜索、文件和工具型工作流，但本周无网页/OS 任务完成率、权限确认、支付登录或隐私边界新材料。近期 K3 属模型背景，不应自动等同于 Kimi Agent 产品升级，故保持静默判定。

### 8. Qwen Agent（观察/静默，已直查 GitHub）

**核验结论**：Qwen-Agent 主仓本周没有 commit。直接读取 [GitHub 主分支 Commit Atom](https://github.com/QwenLM/Qwen-Agent/commits/main.atom) 并以时间窗筛选；feed 的最新主分支提交是 **31a4d36，2026-03-04 08:13:57Z**（更新 DeepPlanning v1.1 leaderboard），远早于本周。另以 `git ls-remote` 核对 HEAD 同为该 SHA，排除搜索索引延迟。本周也未检出官方 Agent 产品公告。

**观察原因**：仓库静默意味着本周没有可归因的框架、工具调用、浏览器控制或安全确认改动。Qwen-Agent 的开源属性有利于审计工具链和自部署，但安全仍取决于执行器沙箱、工具白名单、凭据隔离及高风险动作确认；这些本周均无新增实证数据。GitHub 星数等会随时变化且 API 遭共享 IP 限流，本报告不填未经可靠抓取的快照数字。

### 9. AutoGLM（观察/静默，已直查 GitHub）

**核验结论**：官方开源仓库采用 [zai-org/Open-AutoGLM](https://github.com/zai-org/Open-AutoGLM)。直连 GitHub 后以 git 历史按 UTC 对应时间窗筛选，**0 条 commit**；主分支 HEAD 为 **86f5538**，最近提交时间 **2026-03-06 16:38:32+08:00**（更新英文 README）。同时核验智谱/Z.ai 官网及“AutoGLM 2026-08-10—16”定向搜索，未发现本周新版本、benchmark、端侧适配或商业化公告。

**观察原因**：AutoGLM 的 GUI/手机自动化天然涉及系统权限、短信/通知读取、跨应用登录和支付，最需要设备侧隔离、动作可视化、关键步骤二次确认与可撤销性。但本周无工程提交和产品公告，不能用 2025 年 AutoGLM 2.0 旧闻冒充新进展。

### 本组洞察

1. **“Agent 能力”正分化为执行平台与浏览器入口两条线**：OpenAI 本周数据说明企业增长来自插件、skills、公司上下文和可复用工作流，而不是单纯更会点网页；Google 则已把 Mariner 的实验技术并入更大产品。独立浏览器 demo 的竞争权重下降，权限层与生态连接器上升。
2. **可靠性指标仍严重不足**：本周唯一大量量化数据来自 OpenAI，但都是使用深度/增长，不是端到端任务成功率。浏览器 Agent 在登录、支付、跨站写操作上的真实成功率、误提交率、人工接管率仍缺公开可比数据。
3. **数据可移植性成为通用 Agent 的一级能力**：Manus 公司拆分触发备份—删除—恢复，提示长期运行 Agent 的“记忆、任务与产物”需要标准导出、删除证明、恢复校验和数据驻留说明。否则组织/监管变化会直接变成产品停机风险。
4. **人机协作不是过渡方案，而是控制面**：OpenAI 明确强调权限、治理、人工复核；Manus 要求用户主动备份；Genspark 批量生产案例更需要抽检与发布确认。高风险动作的可见计划、逐步授权、成本上限和回滚，应成为产品雷达硬指标。
5. **中国开源通用 Agent 本周整体静默**：Kimi、Qwen-Agent、AutoGLM 未发现当周更新；尤其 Qwen-Agent 与 Open-AutoGLM 已用 GitHub 主分支时间戳交叉确认。覆盖率上不应以旧模型发布或 PR 搜索噪音填充。

### 产品雷达候选

- **Manus 数据备份/恢复机制**（高优先）：跟踪备份格式、是否可迁移到其他 Agent、删除证明、恢复成功率、受影响地区与账户比例；8月23—25日是验证窗口。
- **OpenAI Plugins + skills + ChatGPT Work/Codex**（高优先）：关注插件权限粒度、写操作确认、审计日志、提示注入防护，以及能否公布真正的任务成功率而非 token 使用量。
- **Google Mariner 技术迁移后的 Gemini/Chrome auto-browse**（中高优先）：观察原生浏览器登录态、支付/预订确认和并行任务隔离。
- **Genspark 批量生产工作流**（中优先）：验证“8,000 网站”案例的人工介入、部署成本、质量抽检、版权/隐私治理；在无法全文复核前不升级为强信号。
- **Qwen-Agent / Open-AutoGLM 复苏监控**（观察）：以 release/commit 为触发条件，重点看沙箱、GUI benchmark、端侧权限与高风险动作确认。

### 覆盖统计

- 固定追踪对象：**9 个**
- 本周有料：**2 个**（OpenAI、Manus）
- 观察/静默：**7 个**（Anthropic、Google Mariner、Perplexity Comet、Genspark、Kimi、Qwen Agent、AutoGLM；Genspark 因正文抓取失败按门控降级）


## 企业 / 垂直 Agent、协议与评测

- **严格时间窗**：2026-08-10 00:00—2026-08-16 24:00（Asia/Shanghai；网页日期按发布地时区核验，边界不确定项不计为本周动态）。
- **方法**：逐项检索官网新闻/博客/文档与官方 GitHub、论文或 benchmark 页面；只有在窗口内可核验的原始材料才列为“有动态”。搜索摘要仅用于发现线索，结论以全文抓取为准；旧材料仅作标注背景。关键数字优先双源交叉。
- **关注维度**：客户与行业落地、计费、身份权限、审计归因、企业治理、ROI、评测、工程标准化。

**固定厂商追踪**

### 1. Sierra — 有动态（本周多篇）

本周 Sierra 同时推进“收入型长时运行 Agent”、安全工程和 DACH 商业扩张。[《The follow-up is the sale》](https://sierra.ai/blog/the-follow-up-is-the-sale)把 Horizon 定义为可持续数天、数周甚至数月跟进单一客户的长时 Agent：保险场景中，Agent 能读取已保存报价、跨短信/电话保持上下文、解释保障范围与价格变化，并在需要受牌照人员判断时转交。产品形态已从一次会话客服变为“每位申请人一个持续任务实例”，核心资产是随互动累积且归客户所有的上下文。商业价值不再只是降工单成本，而是提高未完成报价的转化率；但原文没有披露转化 uplift 或单客成本，ROI 仍需客户对照实验验证。

安全上，[《Defense in depth in the age of agents》](https://sierra.ai/blog/defense-in-depth-in-the-age-of-agents)公开四层运行时架构：可信内容、自然语言规则/政策、独立 supervisor 模型、不可被提示说服的确定性 guard；单条消息可经过约半打检查，且只有认证后才向 Agent 暴露账户修改工具。运行时之外再叠加持续红队（累计数百万次尝试）、平台级 Threat Detection、单 Agent Monitor 与上线前 Simulations。其重要工程判断是：模型护栏负责语义风险，确定性权限门负责绝对约束，两者不能相互替代。商业扩张方面，[《Building in DACH》](https://sierra.ai/blog/building-in-dach)宣布慕尼黑办公室，称客户覆盖全球领先银行约三分之一、Fortune 50 的 40%、全球前十医疗机构中的 5 家；BBVA、Next、Singtel 上线周期分别为 30/42/56 天，并再次强调按“贷款再融资、理赔完成、客户留存”等结果而非 token 计费。以上数字为 Sierra 自述（本周页面核验），尚缺客户方同期独立交叉验证。

### 2. Glean — 有动态（采购/治理方法论更新）

Glean 于 **2026-08-14** 更新[企业 AI 平台与点工具选型指南](https://www.glean.com/perspectives/how-do-i-choose-between-an-all-in-one-enterprise-ai-platform-and-point-solution)。虽然偏市场教育而非重大版本发布，但清晰暴露其企业 Agent 架构主张：统一层连接 knowledge、context、action；检索前继承源系统权限，回答提供引用，并以企业知识图谱、混合检索与 RAG 形成 permission-aware 上下文；Agentic layer 再负责规划、适应及多步编排。其采购框架要求同时评估集成深度、权限执行、答案质量、可行动性、治理、上线时间和多年 TCO，而不是比较 connector 数量。

关键可核验数据包括：Glean 宣称已有 **250+ 开箱即用连接器**；援引第三方调研称 30% 企业领导者认为在冗余 AI 软件上浪费资金、仅 21% 使用生成式 AI 的组织曾根本性重构至少部分工作流。应注意后两项是文章引用的 Zapier/McKinsey 旧数据，属于背景而非本周新增。对企业治理的实际启示是，权限必须在生成前过滤，不能事后补丁；连接器应验证同步频率、元数据、结构化/非结构化数据、读写动作与权限保真。限制是本周材料没有新增客户、定价或真实 ROI，且“统一平台优于点工具”是厂商立场，采购方仍需防止平台锁定和单一索引层扩大爆炸半径。

### 3. Harvey — 有动态（Email Harvey 全客户 Early Access）

Harvey 本周发布[《Move Work Forward With Email Harvey》](https://www.harvey.ai/fr-FR/blog/using-email-harvey)，宣布 Email Harvey 向全部 Harvey 客户开放 Early Access。律师可转发邮件触发任务，让系统直接回传 Word 或 PowerPoint 附件，例如总结监管更新、根据外部律师反馈修订合规和风险缓释方案；复杂任务可从邮件线程转入 Web 应用，保存到具体 matter 的 Vault，把历次协议 redline、审阅表及分析上下文串联。产品因此从独立法律工作台扩展为“邮箱入口 + Web 深作业 + matter context record”，降低应用切换和重复重建上下文的成本。

权限与审计方面，官方强调 Email 与 Web 使用相同认证协议；若租户要求 client-matter tagging，邮件入口也必须执行相同验证，从而保留 matter-level controls。律师在私有邮件线程内复核结果、继续追问，确认后才向外分享，明确保留 human-in-the-loop。风险仍包括邮件转发造成的错误 matter 归属、附件中的提示注入、收件人/抄送泄露以及文档版本混淆；官方本周原文未说明完整审计日志、数据驻留、附件恶意内容隔离、价格或可量化节时，因此 Early Access 更应视为受控入口扩张而非无人值守法律 Agent。

### 4. ServiceNow AI Agents — 观察/静默

核验 ServiceNow 官方 press room、产品博客、Now Assist/AI Agents 文档索引及站内检索（窗口 8/10—8/16）。搜索出现的“Explore”“AI Guardian”“Data and policy configuration agent”等页面显示近期抓取/更新，但页面没有可靠的首发日期和版本变更记录，无法证明其内容在严格窗口内新增，因此不计动态。未发现可同时满足“本周日期 + 官方原文”的客户、计费、身份权限、审计或 ROI 发布。持续观察 AI Control Tower、AI Agent Orchestrator、AI Guardian 的策略继承和审计归因落地。

### 5. Salesforce Agentforce — 观察/静默

核验 Salesforce Newsroom、官方 Agentforce 博客、Help/Release Notes 与 Trailblazer Community。窗口内检索结果主要为社区主题页、招聘页、用例常青页及 Help 文档，均不能证明本周发生产品发布；最近可确认的 FY27 Q1 汇总为 2026-05-26，属于旧闻，不纳入。故本周未发现可核验的新增客户、定价、权限模型或治理功能。后续重点观察 Agentforce 的按 action/consumption 计费可预测性、Data Cloud 权限传递、跨 Agent 身份和动作级审计。

### 6. Microsoft Copilot Agents — 观察/静默

核验 Microsoft News、Microsoft 365/Copilot Blog、Copilot Studio Blog、Azure/Microsoft Learn 的 Agent 页面与更新日期。窗口内有 Learn 文档和“如何构建 AI Agent”科普内容被搜索引擎标为近期，但未发现带可靠发布日期且构成新增商业/技术发布的官方原文；新闻页抓取还遭遇 403，未据搜索摘要下结论。未核验到本周客户、计费或身份治理更新。后续重点观察 Entra Agent ID、Copilot Studio 审计、MCP 连接和多 Agent 编排的 GA 边界。

### 7. 字节 Coze/扣子 — 观察/静默

核验 coze.cn/coze.com、扣子文档、模型发布动态及火山引擎站内结果。窗口内主要命中隐私政策、用户协议、FAQ、模型动态常青页和第三方创建的公开 Agent/Skill 页面；缺少明确日期的官方版本公告，不能把爬虫更新时间当作发布日。未发现严格窗口内可核验的客户案例、收费、身份权限、审计或治理更新。观察重点为扣子空间与开发平台边界、企业租户权限、工作流执行日志、Skill 供应链安全及国内外 Coze 版本差异。

**协议、工具与工程基础设施**

### 8. MCP 协议与官方 SDK — 有动态（兼容性与实现纪律）

本周 MCP specification、Python SDK、TypeScript SDK 均有代码变更。规范仓库把 Node 最低版本从已 EOL 的 20 提升至 24，并修补开发依赖的两个高危 advisory；更多是构建链安全与维护基线，而非线协议大版本。Python SDK 的[兼容性修复](https://github.com/modelcontextprotocol/python-sdk/commit/31b76cb)明确：在 pre-2026 协议会话中，服务端即使发送新版本的 `ttlMs`、`cacheScope`、`resultType`，客户端也必须丢弃，回落到保守默认值，避免跨版本字段导致联合类型误路由。TypeScript SDK 的[初始化取消修复](https://github.com/modelcontextprotocol/typescript-sdk/commit/90ee47dd)落实规范要求：客户端 abort 或 timeout 只在本地拒绝 initialize，不在 wire 上发送 `notifications/cancelled`；其他普通方法仍正常发送取消通知。

这组变化表明 MCP 生态已经进入“多协议时代共存”的工程阶段：互操作风险从能否连接转向协商版本后的字段裁剪、握手特殊语义、SSE 重连/取消边界和依赖供应链。企业采用时不应只做 happy-path tool call，应将版本矩阵、旧端恶意/错误发送未来字段、request id=0、握手超时、重连 token、审计关联 ID 纳入合规测试。官方 servers 仓库在窗口内无提交；本周没有可核验的重大工具目录扩张或企业采用数字。

### 9. Agent memory / context engineering — 观察（无独立本周权威发布）

检索 arXiv、官方研究博客与 GitHub 后，未发现窗口内足以构成独立重大 memory benchmark/标准的权威发布。相关进展更多嵌入产品：Sierra Horizon 把跨天、跨渠道客户上下文作为持续任务资产，Harvey 把邮件线程、Vault 和 matter 历史组成 context record，Glean 则强调权限感知的知识图谱和检索先于生成。共同趋势是 memory 不再等于“无限聊天记录”，而是带所有权、作用域、来源引用、保留期与权限继承的业务状态。观察风险包括跨 matter/客户污染、过期事实未淘汰、被检索内容携带提示注入、删除请求无法传播到派生摘要，以及“上下文归客户所有”缺少可迁移/可证明删除机制。

### 10. Sandbox / permission / identity / audit / observability — 有动态（厂商工程披露）

本周最实质材料来自 Sierra 的[纵深防御说明](https://sierra.ai/blog/defense-in-depth-in-the-age-of-agents)：运行时将内容、政策、supervisor 模型和 deterministic guard 分层，账户修改工具在用户认证前根本不可见；回复前后均可被独立模型审查，敏感数据再由确定性输出检查；平台级 Threat Detection、Agent Monitor、上线前 Simulation 与持续第三方红队组成观测闭环。Harvey 的[邮件入口说明](https://www.harvey.ai/fr-FR/blog/using-email-harvey)补充 matter tagging 与认证协议在新入口保持一致。这说明企业 Agent 的权限边界正从“提示词写禁止”迁移到工具可见性和身份状态机。

但公开披露仍有明显空白：没有动作级主体（人/Agent/服务账号）统一身份格式，没有说明 supervisor 判定的可解释证据与误拦截率，也没有展示端到端审计事件 schema、不可抵赖签名、数据保留和客户导出接口。所谓“数百万次红队尝试”是投入量，不等于覆盖率或剩余风险。工程采购应要求按一次任务串起 authn、policy decision、tool grant、model/version、retrieval sources、human approval、side effect、rollback 与最终业务结果，才能真正完成归因。

**Benchmark 与安全研究**

### 11. SWE-bench / SWE-Bench ProMax — 有动态

**2026-08-10（UTC）**提交的 [SWE-Bench ProMax 论文与全文](https://arxiv.org/abs/2608.09802)提出面向大型多语言重构的 170 题 benchmark，覆盖 Python、Java、TypeScript、Go、C、C++、Rust；任务平均修改 **11.4 个文件、261.6 行代码**，最佳模型 resolve rate 仅 **41.2%**。论文从 29,782 个候选筛到 170 题，重写问题描述并人工剔除过窄/过宽测试；其动机是近期审计称 SWE-bench Verified 未解题中近 60% 存在测试问题，同时公共仓库金补丁可能被训练数据复现。成本结果也值得商业化关注：Claude Sonnet 4.6 平均 **$4.77/题、38.8%**，GLM-5 **$0.24/题、36.5%**，说明模型单价与任务成功并非线性关系，真正瓶颈是跨文件协调。

SWE-bench 官方仓库本周也持续重构评测基础设施。[8月16日提交](https://github.com/SWE-bench/SWE-bench/commit/ca6e4e0)拒绝“零测试计数却被视为有效”的摘要，并在 re-grade 时保留原 task repo，避免丢失“到底按哪套测试评分”的唯一记录；本周其他提交拆分 task metadata、支持 multi-dataset task repos、为每个 dataset 发布 eval card。影响判断：排行榜可信度越来越依赖评测资产版本、测试实际执行证据与 re-grade lineage，而不仅是 resolve 百分比。ProMax 仍有局限：来自公开 commit，污染风险只能降低不能消除；执行测试仍无法完全衡量可维护性、架构质量和隐藏回归。

### 12. OSWorld — 有动态（OSWorld 2.0 工程更新）

OSWorld-V2 本周仓库新增 [Muse Spark agent integration（2026-08-14）](https://github.com/xlang-ai/OSWorld-V2/commit/8b6b596)，为特定 runner 设置至少 4096 输出 token、处理本地资产 URI 与非 Windows volume cleanup，体现桌面 Agent 评测正在吸收更多 agent harness，但也揭示不同 runner 需要兼容补丁，得分可能受预算和环境配置影响。官方 README 当前推荐 `osworld-v2-2026.08.08` release，要求代码、Python task、gated assets、mock website 和 provider image 严格同版；该 release 日期早于本周窗口，作为背景而非本周发布。

[官方仓库全文](https://github.com/xlang-ai/OSWorld-V2)说明任务类和完整 assets 采用 gated Hugging Face 分发以降低泄题，GitLab 任务必须自托管私有 token；Docker/AWS 有官方镜像，其他 provider 路径存在但需迁移镜像。此设计在可复现性、安全与开放性间做了现实权衡：版本 manifest 和 gated assets 增强可比性及抗泄漏，却增加准入与基础设施成本；私有 token 任务也要求隔离凭据、销毁环境并保留轨迹证据。Muse Spark 接入本身没有新分数，不能据此推断能力跃迁。

### 13. WebArena — 观察/静默

核验官方 GitHub `webarena-benchmark/webarena`、项目页及本周学术检索；官方仓库在严格窗口内无提交，未发现带日期的 benchmark 新版、官方 leaderboard 或评测协议更新。旧版 WebArena 仍是自托管网站环境的重要基线，但其网站状态、账号种子、浏览器版本和 evaluator 规则均可能影响复现；本周无新数据可报告。

### 14. GAIA — 观察/静默

核验 GAIA 官方 GitHub/数据集与论文检索，窗口内官方仓库无提交，也未发现明确日期的 benchmark 或榜单更新。搜索结果多为模型报告引用或二手榜单，不满足必须直查官方页的要求，故不纳入。继续观察题目污染、工具可用性差异和 pass@k/成本报告是否标准化。

### 15. τ-bench — 观察/静默

核验 Sierra Research τ-bench 相关官方仓库、论文与 Sierra 博客，本周未发现可确认的新 release、任务集或 leaderboard。搜索中存在命名近似和衍生实现，但没有官方时间证据，故不据此写动态。后续重点关注 τ-bench 对 policy compliance、用户模拟稳定性、工具 side effect 和多轮成功的联合度量，以及是否披露每次成功成本。

### 16. Agent 安全红队论文 — 观察/静默

以 arXiv、GitHub 和厂商研究页检索 2026-08-10—08-16 的 agent security/red teaming/prompt injection/tool-use 论文，未找到能同时确认本周首发、Agent 专项且有官方全文的高置信新作；因此不以新闻摘要拼凑。可核验的本周实践披露是 Sierra 的持续第三方红队与“数百万次尝试”，但这是厂商方法说明，不是可复现实验论文。研究空白仍是：跨工具间接提示注入、长期 memory poisoning、身份混淆、授权升级、审计逃逸和多 Agent 串谋，需要统一攻击语料、side-effect severity 与可复现 sandbox。

**本组洞察**

1. **商业化从席位/token 转向结果，但可审计归因尚未跟上。** Sierra 明确按贷款、理赔、留存等 outcome 计费；要避免归因争议，企业必须记录基线、归因窗口、人工接管和失败成本。
2. **长时 Agent 的核心是有作用域的业务状态，不是更长 prompt。** Horizon 的一客一实例、Harvey 的 matter record、Glean 的 permission-aware graph 指向同一架构：状态必须绑定主体、来源、权限、生命周期和可删除性。
3. **权限控制正走向“双轨”：模型监督 + 确定性能力门。** 模型适合语义判断，认证前隐藏工具、参数约束和审批则必须确定性执行；只靠 prompt policy 不足以支撑高风险动作。
4. **评测进入“版本与证据链时代”。** SWE-bench 保留 task repo/re-grade lineage，OSWorld 绑定代码、任务、资产、网站和镜像版本；企业内部评测也应锁定完整环境并保存轨迹，而非只存最终分数。
5. **Benchmark 必须同时报告质量、成本与长程协调。** ProMax 中 GLM-5 以约 1/20 成本接近 Sonnet 4.6，说明单位成功成本和失败模式比单纯排行更能指导选型。

**协议 / 评测 / 商业化雷达候选**

- **协议雷达**：MCP 多版本字段裁剪、initialize/cancel 特例、SSE 重连 token；建议建立“协议协商 × SDK × transport × auth”互操作矩阵。
- **身份治理雷达**：Agent 独立身份、最小权限工具发现、动作级授权、跨渠道主体连续性、审计事件统一 schema。
- **安全雷达**：检索内容/邮件附件间接注入、长期 memory poisoning、supervisor 共模失败、确定性 guard 绕过。
- **评测雷达**：SWE-Bench ProMax 的跨文件协调与单位成功成本；OSWorld release manifest、gated assets 和轨迹验证；WebArena/GAIA/τ-bench 是否推出带成本与环境版本的新榜单。
- **商业化雷达**：Sierra outcome pricing 的合同归因方式；Email Harvey 从 Early Access 到 GA 的定价、matter 审计与节时数据；Glean 统一平台的 TCO 是否有客户侧证据。

**覆盖汇总**

共核验 **16 个对象**：有料 **7 个**（Sierra、Glean、Harvey、MCP、sandbox/permission/identity/audit/observability、SWE-bench/ProMax、OSWorld）；观察/静默 **9 个**（ServiceNow、Salesforce、Microsoft、Coze、memory/context 独立研究、WebArena、GAIA、τ-bench、Agent 安全红队论文）。

## 下周观察点

1. OpenClaw v2026.8.1 从 beta 进入稳定渠道后，secret-host binding、插件来源确认和 SQLite 恢复是否保持兼容。
2. OpenAI Agents SDK 的 provider-neutral testing 是否被主流框架、企业 CI 和安全评测采用。
3. Cursor Builds 的 stale threshold、secret 隔离、build provenance 与跨仓库复现是否公开更多细节。
4. Manus 在 8 月 23—25 日完成备份、删除与恢复后，能否披露备份格式、删除证明和恢复成功率。
5. SWE-Bench ProMax 是否出现可复现 leaderboard、更多 agent scaffold 与单位成功成本报告。
6. Sierra outcome pricing 是否出现客户侧基线、人工接管、失败成本和合同归因证据。
7. MCP 多版本互操作是否形成官方 conformance suite，覆盖字段裁剪、initialize/cancel、认证与重连。

## 关于本周报

本周报覆盖 Agent 产品、开源项目、框架工具、CLI/IDE、协议标准、评测基准、企业落地与开发者生态。时间窗口严格采用刚结束的完整自然周；官方原文、GitHub/API、论文与 benchmark 官方页优先，社区讨论只作线索。累计 stars 只表示历史关注，不直接等于工程价值、生产采用或维护健康度。

**门控结果**：覆盖 48/48；原文抽查 5/5；GitHub/benchmark 数据已核；工程判断到位；关键数据有源，未公开与弱证据均已标注。
