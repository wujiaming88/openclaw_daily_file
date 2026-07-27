# 全球 AI Agent 研究周报 · 第 8 期（2026-07-20 ~ 2026-07-26）

> **覆盖区间**：2026-07-20 ~ 2026-07-26（Asia/Shanghai，上一个完整自然周）  
> **覆盖范围**：Agent 产品、开源项目、框架工具、CLI/IDE、浏览器/Computer Use、企业垂直 Agent、MCP/权限/沙箱/评测等，共覆盖 41 个固定与扩展对象。  
> **数据声明**：本期只写时间窗内可核验公开信息；时间窗外旧闻仅作背景并明确标注。开源项目优先直查 GitHub release、仓库页、npm/PyPI registry 或官方 changelog；搜索摘要只用于发现线索，不作为事实来源。

## 本周一句话

> 本周 Agent 赛道的主线，是从“会执行任务”继续推进到“可路由、可迁移、可沙箱、可审计、可计费”的生产级运行时：编码 Agent 在多会话和权限治理上加速，开源框架在 Skills/Flows/MCP/浏览器 harness 上硬化，企业 Agent 则把身份、数据边界和业务结果变成核心卖点。

## 🔥 本周 TOP 5 Agent 事件

### 1. Claude Code：Opus 5、sandbox 与 subagent 治理进入同一条主线

Claude Code 在 2026-07-20 至 07-25 连续发布 v2.1.216 到 v2.1.220。更新重点覆盖 `sandbox.filesystem.disabled`、`sandbox.network.strictAllowlist`、worktree-isolated subagents 的 git redirect 修复、后台 `/code-review`、stream-json 的 MCP server errors、`DirectoryAdded` hook、nested subagent forwarding、workflow size guideline，以及 `claude-opus-5` 默认化。它不是单一功能发布，而是编码 Agent CLI 从“帮我改代码”继续演化为可编排、可观测、可限制网络/文件系统权限的工程运行时。

### 2. OpenAI Codex CLI：长会话、迁移与 multi-agent runtime 合流

Codex CLI 在本周发布 `rust-v0.145.0`，并推进 0.146 alpha 线。正式版新增实验性分页 thread history，支持 resume、search、持久名称、sub-agent 与 memories；`/import` 可迁移 Cursor 与 Claude Code 的 settings、MCP servers、plugins、sessions、commands、project-scoped memories；multi-agent V2 支持配置子代理模型、reasoning levels、concurrency 与 roles。Codex 的本周信号，是把本地编码 Agent 运行时做成可迁移、可恢复、可多代理调度的系统。

### 3. Cursor Router：模型选择变成平台级成本/质量调度问题

Cursor 在 2026-07-22 发布 Cursor Router，并将 Auto mode 改为由 Router 驱动。官方称 Router 在 600k+ live requests 上训练，并在数百万在线请求 A/B 测中优化用户满意度；早期企业客户在 Auto-routed requests 上相对全量 Opus 4.8 定价节省约 30%–50%，线上 A/B 测称可达到 frontier-quality performance 与 60% savings。Cursor 的本周更新说明 IDE Agent 竞争正在从“接入哪个模型”转向“谁拥有任务路由、缓存、成本和满意度的数据飞轮”。

### 4. Sierra：MCP Gateway 与 Takeoff 收购把企业 Agent 推向结果交付

Sierra 本周公开 MCP Gateway 工程复盘，披露其内部统一连接 Slack、GitHub、Salesforce、数据仓库、生产系统和内部文档等 45 个服务，89% 员工活跃使用；同时披露 Takeoff 收购整合，将 long-horizon agent runtime 与 Sierra Horizon 结合。Sierra 的重要性在于，它没有把 MCP 当“接工具清单”，而是把身份、权限、跨客户数据隔离、审批、审计、service owner 和 outcome-based pricing 放到企业 Agent 的核心。

### 5. browser-use：浏览器 Agent 基础设施开始产品化

browser-use 本周发布 Recording Controls & OAuth Browser Access，并在 0.13.x 线推进 Rust-backed beta agent、Browser Use CLI 3.0、MCP server/shared MCP runner、navigation readiness、LLM output truncation detection、structured error memory 与 Browser Harness 可靠性修复。浏览器 Agent 的工程主战场不再是“能不能点击网页”，而是登录态授权、录屏隐私、跨域/支付字段、错误恢复、MCP/CLI 接入和可计费 harness。

## 🧭 三条主线

### 产品主线：Agent 产品从单点助手转向跨端工作流

编码 Agent 继续强化 CLI/IDE/桌面/云端/移动端一体化：Claude Code、Codex、Cursor、OpenCode、Cline Desktop、Replit Agent 都在解决长会话、桌面/终端联动、Slack/移动入口和多模型选择。浏览器/通用 Agent 侧，OpenAI 把 ChatGPT Work 与 Presence 推向企业和小企业场景，Perplexity Comet、Manus Browser Operator、Browser Use Harness 则分别代表 AI 浏览器、本地登录态接管和开发者浏览器执行层三条路线。

### 工程主线：MCP、sandbox、memory、routing 与 observability 成为底座

本周高价值更新集中在运行时：Claude Code/Codex/OpenAI Agents SDK 修 session、sandbox、trace、schema 与 provider 并发隔离；LangGraph 修 checkpoint/delta/subgraph；CrewAI 推 Skills/Flows/hooks/usage observability；Sierra/Glean 将 context、tool catalog、identity 与 audit 作为企业工程核心。Agent 工程的关键问题正在从 prompt 写法转向：工具如何授权、状态如何恢复、结果如何审计、成本如何度量、失败如何回滚。

### 商业化主线：企业为业务结果、治理和可预测成本买单

Sierra 强调 outcome-based pricing，Salesforce Agentforce 把 action/conversation/user 计费与 Digital Wallet 组合到企业采购语言里，OpenAI Presence 走生产交付和仿真评测，Glean 把 token efficiency 和 voice tooling 上升为工作流成本问题。企业买 Agent 的关注点正在变成：能不能安全接内部系统、能不能解释权限和归因、能不能把业务结果和消耗绑定，而不是单纯模型能力。

## 🧩 开源生态雷达

| 类别 | 项目 | 本周判断 |
|------|------|----------|
| 增长/活跃项目 | OpenClaw、CrewAI、OpenAI Agents SDK、browser-use、LangGraph | 都在推进运行时硬化：远程会话、Skills/Flows、sandbox/trace、浏览器 harness、checkpoint/delta。 |
| 事实标准候选 | LangGraph、browser-use、OpenAI Agents SDK、MCP Gateway 模式、OpenClaw | 分别占据有状态 workflow、浏览器执行层、官方 runtime、企业工具网关、Agent OS。 |
| 观察/静默项目 | Dify、AutoGen、LlamaIndex Agents、Google ADK、OpenHands、AutoGPT、MetaGPT、SuperAGI、Hermes | 多数仍有长期生态价值，但本周缺少窗口内重大 release，不用历史热度凑动态。 |
| 热闹但需谨慎 | 高 stars 的早期自主 Agent 项目、闭源/同名 Hermes 线索 | stars 不能代表生产价值；缺少 release、客户、benchmark 或架构证据时，只进观察池。 |

## 📡 Agent 产品雷达

| 赛道 | 代表对象 | 本周变化 |
|------|----------|----------|
| 编码 Agent | Claude Code、Codex、Cursor、OpenCode、Cline、Replit Agent | 重点在多会话、模型路由、桌面/CLI server、Slack/mobile 上下文、sandbox 与权限。 |
| 浏览器 / Computer Use | Browser Use、OpenAI ChatGPT Work/Presence、Comet、Manus、Anthropic Computer Use | 重点在登录态授权、录屏/审计、跨域/支付字段、人工确认与本地/云端执行边界。 |
| 企业/垂直 Agent | Sierra、Glean、Harvey、Salesforce Agentforce、Microsoft Copilot Agents | 重点在身份、权限、审计、数据上下文、deterministic script、计费和 outcome。 |
| 中国 Agent | Kimi、Qwen-Agent/BrowserQwen、AutoGLM、Coze | 本周多数无独立新发布，价值更多体现在模型/API 底座、开源框架与 GUI/浏览器插件长期能力。 |

## 🚦 四维质量门控

- 覆盖率门控：固定与扩展对象覆盖 41/41；有料对象均给出原文链接或官方仓库链接，静默对象写明核验范围与原因。
- 原文深度门控：抽查 Claude Code、Codex、Cursor Router、Sierra MCP Gateway、browser-use 5 个对象，均已打开官方 changelog/release/blog 或 GitHub 页面核验；开源项目 GitHub/release/registry 数据已核。
- 工程判断门控：每个有料对象均覆盖产品形态、工程架构、生态/采用、风险/限制；全文已形成产品、工程、商业化三条主线。
- 数据可信门控：关键版本、日期、stars/forks、定价/客户/benchmark 等均附来源；未公开处已明确标注“未公开”；搜索遇限后已降级到 GitHub 页面、npm registry、官方文档与已落盘研究结果交叉验证。

## 编码 Agent / CLI / IDE

### Claude Code
- 本周动态：本周 Claude Code 在 2026-07-20 至 07-25 连续发布 v2.1.216、2.1.217、2.1.218、2.1.219、2.1.220。核心变化不只是常规修复：v2.1.216 增加 `sandbox.filesystem.disabled`，把“跳过文件系统隔离”和“保留网络出站控制”拆开；同时修复长会话消息归一化近似二次增长导致的卡顿、恢复后台 agent 会话丢失 agent prompt/工具限制、worktree-isolated subagents 被 `git -C` / `GIT_DIR` 重新定向到共享 checkout 等问题。v2.1.218 将 `/code-review` 改为后台 subagent，降低 review 对主会话上下文的污染，并修复 `/code-review ultra` 在非交互会话错误地走本地 review 的问题。v2.1.219 引入 Claude Opus 5（`claude-opus-5`）并作为 Opus 默认模型，标注 1M context、fast mode $10/$50 per Mtok；新增 `sandbox.network.strictAllowlist`、`DirectoryAdded` hook、stream-json 的 `mcp_server_errors`、嵌套 subagent 转发、workflow size guideline，并把 subagent 默认可嵌套深度调到 3。v2.1.220 仅标注 bug fixes/reliability。另据 npm registry，`@anthropic-ai/claude-code` 本周在 07-20、07-21、07-22、07-24 均有版本发布时间，latest 为 2.1.220。
- 工程与产品分析：
  - 产品形态：CLI/IDE/云端会话统一的编码 Agent，重点在终端交互、后台会话、代码审查、MCP、subagent 编排和远程控制；本周的 Code Review 后台化与 Opus 5 默认化都指向“长任务代理”而非一次性补全。
  - 工程架构：发布说明显示其关键架构围绕 sandbox（文件系统/网络拆分）、worktree 隔离、stream-json 协议、hooks、MCP server 校验、后台 subagent 与动态 workflow 尺寸控制展开。新增 `DirectoryAdded` hook 与 nested subagent forwarding 说明 CLI 正在把代理生命周期事件结构化暴露给上层 IDE/SDK/远程控制端。
  - 生态/采用：GitHub 仓库（2026-07-27 02:03 UTC 左右 API 核验）139,204 stars / 22,362 forks，本周 releases 页面显示每个正式版本带 10 个跨平台制品；npm dist-tag latest/next 为 2.1.220、stable 为 2.1.212。Stars 只代表关注度，更重要的是其 MCP、hooks、stream-json、subagent 事件继续成为第三方编排器和企业审计接入点。
  - 风险/限制：默认引入更深 subagent 嵌套和更强模型会带来成本、并发、权限面扩大风险；虽然 strict allowlist、workflow size guideline、workspace trust 等在收敛风险，但复杂工作流下仍需要企业侧限制并发、预算、网络出站和 hook 信任边界。
- 关键数据：版本 v2.1.216/v2.1.217/v2.1.218/v2.1.219/v2.1.220（[GitHub Releases](https://github.com/anthropics/claude-code/releases)，2026-07-20~25）；GitHub 139,204 stars / 22,362 forks、pushed_at 2026-07-25T01:35:55Z（[GitHub API/仓库](https://github.com/anthropics/claude-code)，核验 2026-07-27）；npm latest 2.1.220、stable 2.1.212，2.1.216~2.1.220 发布时间落在本周（[npm registry](https://registry.npmjs.org/@anthropic-ai/claude-code)，核验 2026-07-27）。
- 原文链接：[CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)、[v2.1.219 release](https://github.com/anthropics/claude-code/releases/tag/v2.1.219)、[v2.1.218 release](https://github.com/anthropics/claude-code/releases/tag/v2.1.218)、[v2.1.216 release](https://github.com/anthropics/claude-code/releases/tag/v2.1.216)、[npm package](https://registry.npmjs.org/@anthropic-ai/claude-code)
- 影响判断：Claude Code 本周的信号是从“强 CLI”继续转向“可编排代理运行时”：subagent、hooks、stream-json、MCP 错误面向机器消费，后台 code review 面向长任务。短期会提高团队自动化集成价值，但也把治理重点从 prompt 质量转到权限、网络、预算与 agent 扇出控制。

### OpenAI Codex / Codex CLI
- 本周动态：本周 OpenAI Codex 仓库发布了正式版 `rust-v0.145.0`（2026-07-21T18:21:04Z）以及大量 0.145/0.146 alpha 版本。v0.145.0 的 release note 有实质功能更新：新增实验性分页 thread history，支持高效 resume、search、持久名称、sub-agent 与 memories；扩展 `/import`，可迁移 Cursor 与 Claude Code 的 settings、MCP servers、plugins、sessions、commands、project-scoped memories；加入实验性 Amazon Bedrock 登录、自定义 endpoint/auth，并把 GPT-5.6 Sol 作为默认 Bedrock 模型；加入本地音频输入和 tool outputs，并引入 streaming realtime V3 conversations；稳定 opt-in multi-agent V2，支持可配置 sub-agent models、reasoning levels、concurrency、恢复 roles、改进 agent navigation；终端 UI 增加安全可点击 inline visualization links。Bugfix 层面集中在长会话增量 Markdown 渲染、MCP 启动/OAuth 串行化、Windows native exec-server sandbox、network-proxy enforcement、安全 buffer 分支、forced-rm 检测、full-access confirmation 等。GitHub search 在本周 merged PR 查询中返回 267 条 merged PR，说明这不是单点发布而是高频工程迭代；npm registry 也显示 `@openai/codex` 0.145.0 和 0.146.0-alpha.10.1 多平台包本周发布。
- 工程与产品分析：
  - 产品形态：Codex CLI 是终端/本地工程环境中的编码 Agent，同时具备 code-mode、TUI、MCP、插件/skills、session/memory、multi-agent 与 provider 登录能力。本周 `/import` 明确把 Cursor/Claude Code 迁移作为入口，意图降低用户从其他 Agent 迁移的摩擦。
  - 工程架构：v0.145.0 的重点在“会话数据库化/分页化 + 多 agent runtime + exec-server sandbox + MCP/OAuth 稳定性”。分页 thread history 与 memories 让长期会话可检索、可恢复；multi-agent V2 通过模型、reasoning、concurrency 配置把子代理当成调度实体；Windows sandbox 与 network proxy enforcement 说明其执行层正在摆脱简单 shell 包装，转向跨平台隔离执行服务。
  - 生态/采用：GitHub 仓库（2026-07-27 API 核验）101,666 stars / 15,232 forks；v0.145.0 release 带 162 个资产，覆盖多二进制/平台/签名制品。热度不能直接等同价值，但 `/import` 支持 Cursor/Claude Code 与 Bedrock/custom endpoint 说明 OpenAI 在生态上同时做“迁入”和“企业模型/云接入”。
  - 风险/限制：本周正式版包含多项 experimental 能力，alpha 版本频繁，稳定性仍需区分 stable 与 alpha；multi-agent、audio/tool outputs、Bedrock、自定义 endpoint 扩大攻击面和配置复杂度，企业采用需核对 sandbox、MCP OAuth、日志与数据驻留边界。
- 关键数据：正式版 `rust-v0.145.0` 发布于 2026-07-21，后续 `0.146.0-alpha.1~10.1` 于 2026-07-22~25 发布（[GitHub Releases](https://github.com/openai/codex/releases)）；GitHub 101,666 stars / 15,232 forks、v0.145.0 162 assets、2026-07-20..26 merged PR 查询约 267 条（[GitHub 仓库](https://github.com/openai/codex)，核验 2026-07-27）；npm latest 0.145.0、alpha 0.146.0-alpha.10.1（[npm registry](https://registry.npmjs.org/@openai/codex)，核验 2026-07-27）。
- 原文链接：[v0.145.0 release](https://github.com/openai/codex/releases/tag/rust-v0.145.0)、[GitHub Releases](https://github.com/openai/codex/releases)、[npm package](https://registry.npmjs.org/@openai/codex)、[merged PR search](https://github.com/openai/codex/pulls?q=is%3Apr+merged%3A2026-07-20..2026-07-26)
- 影响判断：Codex 本周最重要的不是某个模型名，而是把长会话、迁移、MCP、multi-agent 和跨平台 sandbox 串成可持续运行的本地 Agent 架构。若稳定性跟上，它会在企业内与 Claude Code/Cursor 形成“可迁移、可审计、可多后端”的正面竞争；但 experimental 与 alpha 密集也意味着生产团队应分层试点。


### Cursor
- 本周动态：Cursor 本周（页面原始 HTML 日期核验为 2026-07-22）发布 Cursor Router，并将 Auto mode 改为由 Router 驱动。官方 changelog 说明 Router 会分析请求并将任务送到合适模型，提供 Intelligence、Balance、Cost 三种优化模式；团队管理员可按 team/group 启用，限制成员可选模式，设置默认模式，允许或阻止底层模型；可用范围覆盖 desktop、web、iOS、CLI 与 SDK，Teams 计划默认开启，Enterprise 从 dashboard 启用。官方 blog 进一步披露：Router 在 600k+ live requests 上训练，并在数百万在线请求 A/B 测中优化用户满意度（AFC），早期访问的企业客户在 Auto-routed requests 上相对全量 Opus 4.8 定价节省约 30%–50%，线上 A/B 测称 frontier-quality performance 可达 60% savings；Auto Intelligence 接近 Fable 输出满意度且团队成本约低 60%，相对 Opus 4.8 在近似成本下满意度提升约 15%；Auto Balance 高于 Opus 4.8 且成本约低 36%。同一 changelog 页面还列出 07-17 的 Slack 改进、07-10 的 Side Chats/Conversation Search 等旧闻，因早于本时间窗，仅作为背景不计入本周动态。
- 工程与产品分析：
  - 产品形态：Cursor 从“IDE + Agent”扩展为跨桌面、Web、移动、CLI、SDK 的 Agent 平台；本周 Router 直接嵌入 Auto mode，把模型选择从用户手动切换变成企业策略和产品默认体验。
  - 工程架构：Router 本质是请求前分类器，输入 query、context、task complexity、domain 与模型行为画像；训练和评估均考虑 cache miss 成本，说明 Cursor 的优化目标不是单次 benchmark，而是多轮会话、缓存、代码保留率、用户纠偏等生产流量指标。它与此前动态工具调用、agent harness 降耗共同构成 token efficiency 层。
  - 生态/采用：Cursor 官方称每周路由数亿次 coding requests，早期访问覆盖 dozens of enterprises 和 three high-volume accounts with thousands of users。GitHub `cursor/cursor` 仓库（2026-07-27 API 核验）33,065 stars / 2,276 forks，但该仓库不是完整产品价值载体；更关键的采用信号是 Router 横跨 IDE/CLI/SDK/iOS，并作为 Teams 默认能力进入企业工作流。
  - 风险/限制：Router 提升成本效率的同时降低了模型选择透明度；管理员虽可 allow/block 底层模型，但用户需要知道何时被路由、如何计费（Balance/Intelligence 按被路由模型费率计费）、数据是否用于训练/评估，以及在高风险代码任务中是否应固定模型以便复现。
- 关键数据：Cursor Router changelog 日期 2026-07-22（[Router changelog](https://cursor.com/changelog/router)）；训练数据 600k+ live requests、A/B test 数百万请求、早期企业节省 30%–50%、线上称 60% savings、Auto Balance 约 36% lower cost（[Cursor Router blog](https://cursor.com/blog/router)，2026-07-22）；GitHub 33,065 stars / 2,276 forks（[cursor/cursor](https://github.com/getcursor/cursor)，核验 2026-07-27）。
- 原文链接：[Cursor Router changelog](https://cursor.com/changelog/router)、[Introducing Cursor Router](https://cursor.com/blog/router)、[Cursor changelog index](https://cursor.com/changelog)、[cursor/cursor GitHub](https://github.com/getcursor/cursor)
- 影响判断：Router 是 Cursor 本周最具战略性的更新：它把“哪个模型最好”变成平台级调度问题，并把成本治理交给管理员与在线指标。对团队用户，这是降低 AI spend 的强卖点；对开发者生态，则意味着 IDE/Agent 的竞争会从单模型能力转向流量、遥测、缓存和任务路由的数据飞轮。

### Cognition Devin / Windsurf
- 本周动态：本周未发现落在 2026-07-20~07-26 的重大公开正式更新。官方 Devin Desktop（Windsurf）changelog 最新条目为 v3.5.17，日期 2026-07-19，早于本周时间窗，不能写入“本周动态”作为本周事实；该条目仅作为背景显示 Devin Desktop、Devin Cloud、Devin Local 在上一日更新了长会话渲染性能、inline network policy 授权、Windsurf hooks 到 Devin hooks 迁移、Fast Context、worktree-backed sessions 等。时间窗内我核验了  [windsurf.com/changelog](https://windsurf.com/changelog) （重定向到 `docs.devin.ai/desktop/changelog`）、Devin Desktop changelog 全文、GitHub 常见组织/仓库；未找到公开 GitHub 主仓库或本周 release 可用于写入正式动态。由于 Windsurf/Devin 是商业闭源 IDE/Agent 产品，公开的 GitHub stars/forks 不适合作为核心采用指标，本周关键数字只能写“未公开”。
- 工程与产品分析：
  - 产品形态：Devin/Windsurf 现阶段是桌面 IDE（Devin Desktop/Windsurf）、云端 Devin Cloud 与本地 Devin Local 的组合，定位从 IDE agent 过渡到“云端/本地可切换的工程执行环境”。上一条更新显示其关注 Agent Command Center、Cascade、Devin Local customizations 与网络策略管理。
  - 工程架构：公开 changelog 背景显示其架构核心是 worktree-backed sessions、远程云会话、network policy、hooks、自定义技能、Fast Context 和跨 workspace folder 的本地会话状态；这与 Claude Code/Codex 类似，都是把 agent 运行时从单一聊天框扩展为可恢复、可审计、可约束的执行系统。
  - 生态/采用：本周无公开客户数、活跃用户数、benchmark 或 GitHub release 数据。Windsurf 被并入/品牌迁移到 Devin 文档体系后，生态关注点从原 Codeium IDE 插件转向 Devin Desktop/Cloud/Local，但公开采用数字不足。
  - 风险/限制：闭源商业形态导致可验证工程细节、benchmark、成本、数据边界透明度低；网络策略与云会话是关键控制点，但本周没有新公开信息说明默认策略、审计日志或企业治理能力变化。
- 关键数据：本周重大公开动态未公开；Devin Desktop 最新公开 changelog v3.5.17 日期 2026-07-19（时间窗外，仅背景）（[Devin Desktop changelog](https://docs.devin.ai/desktop/changelog)）；公开 GitHub 主仓库/本周 release：未发现。
- 原文链接：[Devin Desktop/Windsurf changelog](https://docs.devin.ai/desktop/changelog)、[windsurf.com/changelog](https://windsurf.com/changelog)
- 影响判断：Devin/Windsurf 本周属于观察/静默对象。上一日更新方向与行业主线一致（长会话、hooks、网络策略、本地/云协同），但因时间窗外且缺乏公开数据，本期不应把它包装成本周动向；后续需重点盯 3.5.x 后续版本与 Devin Local 企业治理能力。


### OpenCode
- 本周动态：OpenCode 本周有两次正式 release：v1.18.4（2026-07-20T15:28:21Z）与 v1.18.5（2026-07-24T22:18:16Z），并伴随多个用于 PR 可视化验证的 pre-release 资产。v1.18.4 在 Core 层为 Kimi models on Anthropic-compatible providers 启用 adaptive thinking controls，默认输出 summarized reasoning；修复 OpenAI provider 慢连接 header timeout、provider-defined reasoning options 被错误覆盖、Azure Cognitive Services endpoint 支持。Desktop 层同步嵌入终端主题、改进 review panel、重写 v2 prompt input 以提高 command/context/shell/attachment/history 交互可靠性。v1.18.5 继续修复模型/SDK 兼容：改进 Claude adaptive thinking across more response shapes，避免 OpenAI Responses phase handling 破坏对话，保留 grep symlink paths，保留 Mistral reasoning history，稳定 Mistral prompt caching，修复 MiniMax M3 thinking variant。Desktop 层则重点支持 current server：terminal transport、review data、server discovery、session actions、timeline rendering、event streaming，并能检测 legacy/current servers 以兼容双栈。npm registry 还显示 `opencode-ai` 本周有大量 beta/dev 版本发布，说明主线正在快速迁移 desktop/current-server 架构。
- 工程与产品分析：
  - 产品形态：OpenCode 是开源 CLI/桌面编码 Agent，兼顾终端 TUI、桌面 app、review/diff、server session 与多模型 provider。v1.18.4/1.18.5 的重心从“单机 CLI”转向“桌面连接当前 server、流式 timeline、review data 可视化”。
  - 工程架构：本周关键是 provider 抽象与 server 协议迁移。Core 对 Claude/Kimi/Mistral/MiniMax/OpenAI/Azure 的 reasoning、prompt cache、Responses phase 进行兼容处理；Desktop 对 legacy/current server 做双栈适配，说明底层协议或服务端模型在升级，需要 UI 与会话事件流解耦。grep symlink path 修复虽小，但对大型 monorepo 与符号链接工程很关键。
  - 生态/采用：GitHub 仓库（2026-07-27 API 核验）189,947 stars / 24,085 forks；v1.18.4/v1.18.5 各带 37 个跨平台资产，release note 感谢 3 名与 2 名社区贡献者。Stars 不能代表企业采用，但高频社区 PR、桌面/CLI 多制品和 provider 兼容贡献表明其价值在“开放、多模型、本地可控”的生态位。
  - 风险/限制：OpenCode 正处于 legacy/current server 过渡，桌面端需要隐藏 legacy-only 功能、保持 timeline 顺序、避免 config permissions 被自动接受，说明迁移期存在交互一致性和权限误判风险；多 provider reasoning/prompt cache 也会带来不同模型行为不可复现的问题。
- 关键数据：v1.18.4（2026-07-20）、v1.18.5（2026-07-24），各 37 assets（[GitHub Releases](https://github.com/anomalyco/opencode/releases)）；GitHub 189,947 stars / 24,085 forks、pushed_at 2026-07-27T01:59:32Z（[sst/opencode / anomalyco/opencode](https://github.com/sst/opencode)，核验 2026-07-27）；npm latest 1.18.5、dev/beta 本周多次发布（[npm registry](https://registry.npmjs.org/opencode-ai)，核验 2026-07-27）。
- 原文链接：[v1.18.5 release](https://github.com/sst/opencode/releases/tag/v1.18.5)、[v1.18.4 release](https://github.com/sst/opencode/releases/tag/v1.18.4)、[opencode npm](https://registry.npmjs.org/opencode-ai)、[opencode GitHub](https://github.com/sst/opencode)
- 影响判断：OpenCode 本周体现了开源编码 Agent 的现实竞争点：不是抢单一模型首发，而是快速吸收不同 provider 的 reasoning/缓存差异，并把桌面 UI 接到更稳的 server 会话流。短期对重视可控与多模型的团队有吸引力，但协议迁移期需要谨慎升级。

### Aider
- 本周动态：本周无重大公开动态。核验 Aider 官方 release history、GitHub releases 页面、PyPI `aider-chat` 包：最新 PyPI 版本为 0.86.2，上传时间为 2026-02-12；GitHub releases 页面显示最新正式 release 仍停留在旧版本线，GitHub API 早前核验的仓库 pushed_at 为 2026-05-22，未见 2026-07-20~07-26 的正式 release 或公开 changelog 条目。官方 HISTORY 页面顶部有 main branch 的模型支持更新（Claude 4.5/4.6、Gemini 3 preview、GPT-5.1/5.2 等），但该页面未给出本周日期，且其中多项内容明显不是 2026-07-20~07-26 的可核验证据，因此本期不写入“本周动态”。
- 工程与产品分析：
  - 产品形态：Aider 是经典终端 pair-programming/patch-edit Agent，强调 git 集成、repo map、edit format、自动提交与多 provider 模型配置；相较 Claude Code/Codex/Cursor，它更轻量、更接近“LLM 直接改仓库”的 CLI 工作流。
  - 工程架构：公开历史显示 Aider 的核心资产是 repo-map 语言解析、diff/patch edit formats、模型 metadata/pricing、commit message、chat history summarization 与 provider 兼容层，而不是复杂的 subagent/sandbox/server 架构。本周未见这些模块有正式发布变化。
  - 生态/采用：GitHub 仓库（2026-07-27 API 核验）47,715 stars / 4,775 forks；PyPI `aider-chat` 最新 0.86.2。其生态意义在于轻量、脚本友好、模型供应商中立；但本周没有新增采用数据、benchmark 或 release 可证明趋势变化。
  - 风险/限制：Aider 的轻量模式通常依赖本地 git 与模型 API 权限，缺少本周其他产品强调的企业级网络策略、subagent 并发、云端审计、IDE 远控能力；在大型团队治理场景中需要额外封装。
- 关键数据：GitHub 47,715 stars / 4,775 forks、pushed_at 2026-05-22T14:02:20Z（[Aider GitHub](https://github.com/Aider-AI/aider)，核验 2026-07-27）；PyPI `aider-chat` latest 0.86.2，upload_time 2026-02-12（[PyPI JSON](https://pypi.org/pypi/aider-chat/json)，核验 2026-07-27）；本周 release/benchmark/客户：未公开。
- 原文链接：[Aider release history](https://aider.chat/HISTORY.html)、[Aider GitHub releases](https://github.com/Aider-AI/aider/releases)、[PyPI aider-chat](https://pypi.org/pypi/aider-chat/json)
- 影响判断：Aider 本周是静默对象，但仍是 CLI 编码 Agent 的重要基线：简单、透明、容易嵌入脚本。与本周活跃项目相比，它的短板不是改代码能力，而是缺少可公开核验的近期节奏和企业运行时治理能力更新。


### Cline / Roo Code
- 本周动态：Cline 本周有多条实质公开动态。VS Code 扩展/核心项目发布 v4.0.10（2026-07-20）和 v4.0.11（2026-07-24）：v4.0.11 新增 Claude Opus 5，覆盖 Anthropic、Claude Code、Bedrock、Vertex、Cline、OpenRouter providers，并包含 1M context variants；新增 Moonshot Kimi K3 支持；遥测事件加入 host plugin version；修复 Claude Opus 1M context variants 在超过 200k tokens 请求时成本被高估的问题，并为 Kimi K3 启用 native tool calling 以修复空响应。更重要的是 Cline Code desktop 在 2026-07-22 首次公开发布 macOS 桌面 app（desktop-v0.0.2），用于运行和检查 Cline agent sessions，Apple Silicon/Intel 签名与公证，并提供自动更新；随后 desktop-v0.0.4（2026-07-24）加入无项目文件夹聊天、首次启动 onboarding、拖拽文件、图片内联显示、一次性 routines、agentic compaction 默认开启、通过 login shell PATH 找到 `gh` 等 CLI、headless routines 默认 YOLO 以无人值守执行。Roo Code 本周未见重大公开动态：其 GitHub 仓库已于 2026-05-15 archived/read-only，最新 release v3.54.0 也在 05-15，时间窗内无更新。
- 工程与产品分析：
  - 产品形态：Cline 继续从 VS Code 插件扩展为“扩展 + 独立桌面 session inspector/runner”。桌面 app 让 agent sessions 脱离单一 IDE 窗口，可独立运行、检查、自动更新；v4.0.11 的多 provider 模型更新则保持插件层的模型覆盖。
  - 工程架构：Cline 的架构重点是 provider adapter、native tool calling、上下文/成本计量、agentic compaction、routines/headless execution 与桌面自动更新。desktop-v0.0.4 对 login shell PATH 的修复表明桌面沙箱/GUI 环境与开发者 shell 环境之间的路径差异是实际可用性痛点。
  - 生态/采用：GitHub `cline/cline`（2026-07-27 API 核验）65,085 stars / 6,990 forks；本周 release 包括 VS Code 侧 v4.0.10/v4.0.11 与 desktop-v0.0.2~0.0.4。Roo Code 仍有 24,366 stars / 3,382 forks，但仓库 archived 后生态活跃度需要打折看待，不能用历史 stars 说明本周价值。
  - 风险/限制：Cline desktop 的 YOLO headless routines、agentic compaction、文件拖拽与图片内联提高便利性，也扩大无人值守执行与上下文压缩误判风险；Opus 1M context 成本修复说明长上下文计费仍容易被误估。Roo Code 的 archived 状态意味着用户应谨慎依赖其上游安全更新。
- 关键数据：Cline v4.0.11 发布于 2026-07-24，desktop-v0.0.2 首次公开发布于 2026-07-22，desktop-v0.0.4 发布于 2026-07-24（[Cline releases](https://github.com/cline/cline/releases)）；GitHub 65,085 stars / 6,990 forks、pushed_at 2026-07-27T01:55:37Z（[cline/cline](https://github.com/cline/cline)，核验 2026-07-27）；Roo Code archived/read-only，最新 v3.54.0 为 2026-05-15，GitHub 24,366 stars / 3,382 forks（[Roo Code releases](https://github.com/RooCodeInc/Roo-Code/releases)，核验 2026-07-27）。
- 原文链接：[Cline v4.0.11](https://github.com/cline/cline/releases/tag/v4.0.11)、[Cline Desktop v0.0.2](https://github.com/cline/cline/releases/tag/desktop-v0.0.2)、[Cline Desktop v0.0.4](https://github.com/cline/cline/releases/tag/desktop-v0.0.4)、[Roo Code releases](https://github.com/RooCodeInc/Roo-Code/releases)
- 影响判断：Cline 本周的桌面 app 首发值得关注，它把 VS Code agent 的会话运行/检查抽象成独立产品形态，贴近 Claude Code/Codex 的长期 session 方向。Roo Code 则应在本期标为静默/维护风险对象，后续若无新上游，开发者社区可能继续向 Cline 或其他 fork/替代迁移。

### Replit Agent
- 本周动态：Replit 在 2026-07-24 发布产品更新，涉及 Mobile、Integrations、Billing，其中与 Agent 最相关的是移动端与 Slack context。移动端方面，Replit Mobile App 刷新 home screen 与项目导航，用户可在 Agent、tasks、Preview 间滑动，用语音描述要构建的内容，并通过改进通知与 Live Activities 跟踪 Agent 进度。Integrations 方面，Slack 连接后，Agent 可搜索用户有权访问的 messages、files、channels、people；可读取 private conversations 与 thread replies、以用户身份发送消息、创建或更新 Slack canvases。官方 Agent Integrations 文档进一步说明 Replit Agent 支持 Replit managed、Connectors、External integrations、Agent services 四类集成；连接器一次 OAuth 后可跨应用复用，Slack 权限仅限 connected Slack account 可访问内容。本周同时宣布 Pro plan 调整与 8 月 Replit Cloud 降价，但这属于部署/账单背景，不直接计入编码 Agent 能力。
- 工程与产品分析：
  - 产品形态：Replit Agent 是云 IDE/应用构建平台内的 Agent，强调从 idea 到 app，并与移动端、Preview、tasks、connectors、deployment/billing 结合；本周把 Agent 的入口从桌面扩到手机，并把 Slack 变成需求/上下文来源与通知/协作通道。
  - 工程架构：Agent integration 文档显示其通过 managed integrations、OAuth connectors、第三方 API 与内置服务组成工具层。Slack connector 是典型高权限工具：搜索/读取/写入消息与 canvases，再把结果注入构建任务。移动端 Live Activities/notifications 则把长任务状态外显，适合 Agent 异步执行。
  - 生态/采用：Replit Agent 没有公开独立 GitHub 仓库、stars/forks 或本周 benchmark；作为闭源 SaaS，其采用更多体现在平台内移动端、连接器目录、部署价格联动。Slack connector 的意义不是“又一个集成”，而是把产品讨论、需求澄清和 Agent 构建闭环放进协作工作区。
  - 风险/限制：Slack connector 权限很敏感，可读 private channels/DMs/group DMs、发送消息和管理 canvases；虽然文档强调只访问用户账号可访问内容，但企业需要 OAuth scope 审批、审计日志、最小权限和数据保留策略。移动端语音输入也可能降低需求表达门槛但增加误触发/模糊指令风险。
- 关键数据：2026-07-24 changelog（[Replit updates](https://docs.replit.com/updates/2026/07/24/changelog)）；Slack connector 能力：search messages/files/channels/people、read private channels/DMs/group DMs/thread replies、send messages as user、create/read/update canvases（[Agent Integrations docs](https://docs.replit.com/features/integrations/overview#use-slack-with-agent)）；独立 GitHub 数据/Agent benchmark：未公开。
- 原文链接：[July 24, 2026 changelog](https://docs.replit.com/updates/2026/07/24/changelog)、[Agent Integrations / Slack](https://docs.replit.com/features/integrations/overview#use-slack-with-agent)、[Replit Mobile App docs](https://docs.replit.com/features/platforms/mobile-app#navigate-your-project)
- 影响判断：Replit 本周的 Agent 更新重点不在模型或代码 benchmark，而在“随时随地发起构建 + 从 Slack 吸收上下文”。这会强化 Replit 作为端到端应用生成平台的差异化，但企业落地前必须认真处理 Slack 权限与代发消息的治理问题。


### SWE-bench / 编码 Agent 基准榜单观察
- 本周动态：本周未发现 SWE-bench 官方 leaderboard 在 2026-07-20~07-26 新增可核验的编码 Agent 条目。已打开 `www.swebench.com` 官方榜单页面全文；因页面为大型前端内嵌数据，进一步解析 HTML 中全部 `"date"` 字段，未发现 `2026-07-20` 至 `2026-07-26` 日期，最新可见日期集中在 2026-02（例如 Gemini 3 Pro、GPT-5-2 Codex 等），不属于本期自然周。因此本期不把任何 SWE-bench 名次变化写作“本周动态”。榜单中仍可见 Google Jules + Gemini 2.0 Flash 等历史条目，但日期为 2024-12-12；只说明 SWE-bench 长期覆盖云端/IDE 编码 Agent，不代表本周活跃。开发者社区/IDE 集成层面，本周更明显的公开活动来自 Cursor Router（跨 desktop/web/iOS/CLI/SDK）、Cline Desktop 首发、Replit Agent Slack connector、Claude Code/Codex/OpenCode 的 CLI/桌面/服务器协议迭代，已分别在上文对象中展开。
- 工程与产品分析：
  - 产品形态：SWE-bench 是编码 Agent 解决真实 GitHub issue 能力的公开基准与 leaderboard，不是产品本身；它对本报告的价值是校验“本周是否有可量化能力突破”。
  - 工程架构：榜单数据包含 resolved、cost、date、logs/trajs、system/model/open-source 标记等字段；这些字段能帮助区分一次性 benchmark、可复现实验轨迹与闭源产品宣称。本周没有新日期条目，因此不能推导模型/Agent 工程能力在本周发生跃迁。
  - 生态/采用：SWE-bench 仍是编码 Agent 对外宣传的重要锚点，但本周 本组对象的真实竞争信号更多来自产品运行时：Router、subagent、sandbox、MCP、desktop session、Slack/mobile integration，而不是 leaderboard 新分数。
  - 风险/限制：SWE-bench 分数容易被过度解读；如果没有本周新增条目、日志和轨迹，就不应拿旧分数凑周报。即便有新分数，也需看 attempts、cost、轨迹公开程度和是否针对 Verified/Lite/Multilingual 等不同集合。
- 关键数据：官方页面解析到的 `"date"` 字段中无 2026-07-20~2026-07-26 条目（[SWE-bench Leaderboards](https://www.swebench.com/)，核验 2026-07-27）；本周新增 resolved/排名：未公开。
- 原文链接：[SWE-bench Leaderboards](https://www.swebench.com/)
- 影响判断：本周不应把 SWE-bench 当作“能力突破”来源。更可靠的结论是：编码 Agent 竞争重心在本周继续向工程化运行时、企业治理、跨端协作和成本路由移动，benchmark 需要等待有日期和轨迹的新提交再纳入。

## 开源 Agent 框架与项目

### OpenClaw
- 本周动态：OpenClaw 本周有明确版本线更新。npm registry 显示 `openclaw` 包在 2026-07-21 发布 extended-stable `2026.6.33`，并在 2026-07-24 发布 `2026.7.2-beta.4`；GitHub releases 页面显示 `2026.7.2` 预发布说明，主题不是单一功能，而是把个人/团队 agent OS 往“远程编码会话 + 节点能力 + 渠道可靠性 + 安装包 + Gateway 恢复”推进。release highlights 包括：远程 coding sessions 可在 cloud workers 上运行 Control UI sessions，在拥有主机上打开 Codex/Claude catalog terminal sessions，并能 resume OpenCode 和 Pi sessions；移动端 Automations parity、Android foreground Voice Wake、headless Linux nodes 暴露 camera/location/notification；Telegram durable-ingress restart 不丢、Signal stop/approval 在 active turns 中保持响应、channel allowlists 不再授予 owner access；Gateway restart admission、reply session finalization stall、one-shot cron lifecycle race 等恢复问题修复；Linux deb/AppImage bundles 与安装指导也纳入稳定主线。对 Agent 工程生态而言，本周 OpenClaw 的意义在于把 agent 从“单会话聊天”推进到跨主机、跨渠道、跨移动/节点设备的运行时。
- 工程与产品分析：
  - 产品形态：OpenClaw 是个人/团队 Agent OS，而非单一编码工具；本周更新覆盖 Control UI、channel ingress、cron、paired nodes、native terminals 与安装包。
  - 工程架构：重点在 Gateway/session lifecycle、远程 terminal relay、paired-node capability exposure、channel durability、外部 gateway supervision 与 Skill Workshop 审批策略。`OPENCLAW_SUPERVISOR_MODE=external` 说明其开始为 OCM 等 lifecycle owner 提供受控 restart handoff，避免暴露 native service mutation。
  - 生态/采用：GitHub GitHub 核验显示 openclaw/openclaw 约 384,239 stars；npm dist-tag latest 为 2026.7.1-2，beta 为 2026.7.2-beta.4。Stars 不能说明生产价值，更重要的是 OpenClaw 正把 Codex、Claude Code、OpenCode、Pi、mobile nodes 和 messaging channels 接入同一运行时。
  - 风险/限制：功能面扩大也扩大了安全面：渠道 allowlist、owner access、node camera/location、terminal relay、restart handoff 都需要默认最小权限与审计。beta 线不应直接视作生产稳定版。
- 关键数据：npm `openclaw`：`2026.6.33` 于 2026-07-21T11:25:55Z 发布，`2026.7.2-beta.4` 于 2026-07-24T06:11:58Z 发布；GitHub 约 384,239 stars（GitHub 核验，核验 2026-07-27）；release 说明来自 [OpenClaw Releases](https://github.com/openclaw/openclaw/releases)。
- 原文链接：[OpenClaw GitHub releases](https://github.com/openclaw/openclaw/releases)、[npm openclaw](https://registry.npmjs.org/openclaw)
- 影响判断：OpenClaw 本周是“Agent OS 化”的代表：把编码 agent、移动/节点能力、渠道自动化、cron 和 gateway lifecycle 串成一个可长期运行的系统。下一步观察点是 beta 能否稳定、节点权限和 channel durable ingress 是否形成企业级治理范式。

### LangGraph / LangChain Agents
- 本周动态：LangGraph 本周 release 页面显示 1.2.9/CLI 0.4.31 一线更新，主轴是状态更新、delta channel、CLI deploy 与依赖安全维护。release 内容包括修复 `updateState` metadata/counters for delta channel、delta channel 在 fresh thread 上强制 snapshot 而非 stub checkpoint、snapshot DeltaChannel overwrite supersteps、Overwrite JSON roundtrip、subgraph abort 与 checkpoint namespace 等；CLI 侧允许 `langgraph-api` 版本上限到 1.0.0，支持 prebuild images for `langgraph deploy`，并更新 starlette、cryptography、pyjwt、langsmith、websockets 等依赖。LangChain 主仓库本周未核到同等重大 Agent 发布；本期把 LangGraph 作为主对象。
- 工程与产品分析：
  - 产品形态：LangGraph 是 agent workflow/state machine runtime，面向长期、多步骤、有状态 agent，而不是端侧产品。
  - 工程架构：本周修复集中在 checkpoint、delta channel、subgraph、stream abort 与 CLI deploy，说明生产 agent 的难点已落到“状态一致性、恢复、部署兼容和依赖安全”。
  - 生态/采用：GitHub 核验显示 langchain-ai/langgraph 约 38,196 stars，langchain-ai/langchain 约 142,632 stars。LangGraph 的生态意义不在 stars，而在其被大量企业和框架作为有状态 agent orchestration 基座。
  - 风险/限制：LangGraph 本周没有单一亮眼产品发布，更多是底层稳定性维护；对新手来说抽象成本高，对生产用户则应重点测试 checkpoint 迁移、API 版本兼容和回滚。
- 关键数据：LangGraph releases 页面显示 1.2.9、CLI 0.4.31；GitHub 约 38,196 stars（核验 2026-07-27）；关键 PR 包括 #8315/#8316/#8319 等，来源 [LangGraph Releases](https://github.com/langchain-ai/langgraph/releases)。
- 原文链接：[LangGraph Releases](https://github.com/langchain-ai/langgraph/releases)、[LangChain GitHub](https://github.com/langchain-ai/langchain)
- 影响判断：LangGraph 本周体现的是“框架成熟期”的价值：少有营销噱头，多是状态机和部署边界修复。对构建长程 agent 的团队，delta/checkpoint/subgraph 可靠性比新增 demo 更关键。

### Microsoft AutoGen
- 本周动态：严格按 2026-07-20~07-26，AutoGen GitHub releases 页面未显示本周正式 release；最新可见重要 release 为窗口外。release 页面后续内容显示 AutoGen 0.7.x 线在 DockerCommandLineCodeExecutor、RedisMemory、MCP Workbench、nested team、OpenAI built-in tools、Anthropic thinking mode、MCP session failure、GraphFlow cycle detection 等方面持续演进，但这些不是本周窗口内公开发布。故本期将 AutoGen 标为观察/静默，不用旧 release 凑动态。
- 工程与产品分析：
  - 产品形态：AutoGen 是微软开源多 agent 编排框架，强调 agent/team/tool/code executor/memory。
  - 工程架构：近期背景显示其工程重点围绕 Docker 默认执行器、安全 warnings、Redis memory、MCP workbench、GraphFlow cycle detection、streaming/tool-use 兼容；这些方向与本周行业主线一致。
  - 生态/采用：GitHub 核验显示 microsoft/autogen 约 60,007 stars。其生态价值在企业和研究团队多 agent 编排，但本周无新 release 证据。
  - 风险/限制：多 agent 框架的最大风险仍是工具执行安全、循环/递归、memory 污染和 MCP 失败恢复；本周无新增修复意味着生产用户应继续按既有版本做安全评估。
- 关键数据：GitHub 约 60,007 stars（核验 2026-07-27）；本周正式 release：未发现；release 背景来自 [AutoGen Releases](https://github.com/microsoft/autogen/releases)。
- 原文链接：[Microsoft AutoGen Releases](https://github.com/microsoft/autogen/releases)、[Microsoft AutoGen GitHub](https://github.com/microsoft/autogen)
- 影响判断：AutoGen 本周不是热点，但仍是多 agent 编排的基础项目。它的下一步价值取决于能否把 Docker、MCP、memory、GraphFlow 与企业审计做成默认安全路径。

### CrewAI
- 本周动态：CrewAI 本周 releases 页面显示 1.15.x 线继续快速迭代，重点在 Skills、Flows、execution hooks、Responses API/tool calling、observability 与安全依赖修复。release 内容包括：Promote Skills Repository out of experimental status、Authenticate skill registry downloads、inline skill definitions、generated Flow Definition authoring skill、Flow action inputs templating、stream frame protocol for flows、AgentExecutor feedback handling、repository agents to flow definitions；运行时修复包括 Responses API path 的 tool calling、GPT-5.6 tools + reasoning_effort 400、responses-only models 404 routing、strict tool schema property names、execution_end hook on failed crew/flow、agent/crew result token usage、per-call usage metrics，以及 bedrock-agentcore CVE-2026-16796 patch。对开源 Agent 框架而言，这是一组偏“生产工作流化”的更新。
- 工程与产品分析：
  - 产品形态：CrewAI 是多 agent crew/flow 框架，本周更突出 Skills Repository、Flows in Studio、TUI/headless terminal fallback 与 Agent Control Plane 的规则/成本限制。
  - 工程架构：其关键架构从 agent/crew 运行拓展到 flow definition、execution-boundary interception points、hooks、skill registry、stream frame protocol、token usage observability。工具调用兼容 Responses API 说明其在跟进 OpenAI 新 API 形态。
  - 生态/采用：GitHub 核验显示 CrewAI 约 56,183 stars；release 页面贡献者较多，说明社区仍活跃。其价值在于把 agent 编排做成可审计、可复用 skills/flows，而不是只提供聊天式多 agent。
  - 风险/限制：Skills registry 认证与下载链路本身是供应链风险点；execution hooks 若设计不当可能改变工具结果或形成隐蔽控制面。CVE patch 也提示 agent runtime 依赖链需要持续安全扫描。
- 关键数据：GitHub 约 56,183 stars；release 页面包含 v1.15.3~1.15.7 系列变更，CVE-2026-16796 patch、skill usage events、Responses API tool calling 等，来源 [CrewAI Releases](https://github.com/crewAIInc/crewAI/releases)。
- 原文链接：[CrewAI Releases](https://github.com/crewAIInc/crewAI/releases)、[CrewAI GitHub](https://github.com/crewAIInc/crewAI)
- 影响判断：CrewAI 本周最大价值是把 skills/flows/hooks/observability 拉到产品化层面。它正在从“多 agent demo 框架”进入“可编排工作流 runtime”，但需要特别关注 skill supply chain 与 hook 权限。

### Dify
- 本周动态：Dify 本周（2026-07-20~07-26）未发现新的重大 release；GitHub releases 页面最新重大版本为 1.16.0，发布日期 2026-07-17，属于上一期窗口，只能作为背景。该背景版本引入 Dify Agent beta、Linux sandbox、Skills、workflow agent node、web app 发布、MCP protocol 2025-06-18、OpenAI Responses API 默认配置等，已在上一期覆盖。本周严格不把 7月17日内容写成本周动态。
- 工程与产品分析：
  - 产品形态：Dify 是低代码 LLM app/workflow/agent 平台，1.16.0 后正在向 sandbox + skills + workflow agent runtime 转型。
  - 工程架构：核心架构是 Linux sandbox、Agent builder、Skills/files、tools/knowledge、Workflow agent node、MCP server 与 provider cost attribution。
  - 生态/采用：GitHub 核验显示 langgenius/dify 约 150,335 stars / 23k+ forks；这说明关注度高，但本周无新增重大 release，不能只用热度证明本周价值。
  - 风险/限制：Dify 官方 1.16.0 警告 shell-based agent 仅应提供给 trusted users；sandbox、skill 权限、MCP header passthrough 与编辑器权限仍是企业治理重点。
- 关键数据：GitHub 约 150,335 stars（核验 2026-07-27）；最新重大 release 1.16.0 发布于 2026-07-17（窗口外背景），来源 [Dify Releases](https://github.com/langgenius/dify/releases)。
- 原文链接：[Dify Releases](https://github.com/langgenius/dify/releases)、[Dify Agent docs](https://docs.dify.ai/en/self-host/use-dify/build/new-agent/overview)
- 影响判断：Dify 本周按静默处理，但仍是低代码平台拥抱 agent runtime 的事实标准候选。下一步要看 1.16.x 后续是否补齐 sandbox 权限、安全审计与企业部署治理。

### LlamaIndex Agents
- 本周动态：LlamaIndex 本周未发现面向 Agents 的重大官方 release 或 GitHub releases 更新。GitHub 核验显示 run-llama/llama_index 约 51,128 stars；但近期 release 不落在本期窗口内，且官方文档/仓库未核到 2026-07-20~07-26 的 Agent 架构突破或重要安全修复。故本期列为观察/静默。
- 工程与产品分析：
  - 产品形态：LlamaIndex Agents 主要服务 RAG/knowledge workflow 里的 agentic retrieval、tool calling、workflow orchestration。
  - 工程架构：其优势在 data connector、index、retriever、workflow 与 agent tool abstraction 的组合；相比 CrewAI/LangGraph，它更贴近知识库与数据编排。
  - 生态/采用：GitHub 约 51,128 stars，社区长期活跃；本周无 release 并不代表项目衰退，只说明没有新的可写入周报动态。
  - 风险/限制：知识 agent 的主要风险是数据权限、检索污染、source provenance 与长链 tool call 的可追踪性；本周未见新增治理能力。
- 关键数据：GitHub 约 51,128 stars（核验 2026-07-27）；本周 release/benchmark：未发现。
- 原文链接：[LlamaIndex GitHub](https://github.com/run-llama/llama_index)、[LlamaIndex docs](https://docs.llamaindex.ai/)
- 影响判断：LlamaIndex 本周静默，但仍是知识型 agent 的基础设施候选。后续更值得关注它与 MCP、enterprise permissions、agent workflow observability 的结合。

### Google ADK
- 本周动态：Google ADK 本周未发现正式 GitHub release；GitHub 核验显示 google/adk-python 约 20,897 stars、google/adk-js 约 1,324 stars。ADK 仍是 Google agent 开发生态的重要项目，但 2026-07-20~07-26 未核到重大 release、架构更新或 benchmark。Google Agent 相关动态更多出现在 本组的 Gemini/Search/Mariner 背景，而不是 ADK 本周 release。
- 工程与产品分析：
  - 产品形态：ADK 是 Google agent development kit，面向构建可部署 agent、工具和工作流。
  - 工程架构：ADK 的价值在模型/工具/部署/Google Cloud 生态打通；本周无新证据显示其在 memory、MCP、sandbox 或 observability 上有重大变化。
  - 生态/采用：Python 仓库关注度明显高于 JS 仓库，说明主开发者群体仍偏 Python；但本周没有 release 支撑“生态跃迁”。
  - 风险/限制：Google agent 产品线分散在 Gemini/Search/Workspace/Cloud，ADK 与产品化入口之间的边界需要继续观察。
- 关键数据：adk-python 约 20,897 stars，adk-js 约 1,324 stars（核验 2026-07-27）；本周 release：未发现。
- 原文链接：[google/adk-python](https://github.com/google/adk-python)、[google/adk-js](https://github.com/google/adk-js)
- 影响判断：ADK 本周静默。其战略价值取决于能否成为 Google Cloud/Gemini 企业 agent 的默认开发框架，而不是作为孤立 SDK 存在。

### OpenAI Agents SDK / Swarm
- 本周动态：OpenAI Agents SDK 本周 release 页面显示 v0.18.3 线更新，重点在 tracing、realtime usage、memory/session 并发、computer provider isolation、sandbox workspace、strict JSON schema、trace redaction 与 hosted multi-agent 文档。release 内容包括：task/turn tracing spans configurable、track realtime response usage in session context、serialize OpenAI conversation session initialization、preserve user messages containing history wrappers、isolate provider instances across concurrent runs、avoid redundant E2B workspace root creation、preserve streamed session input across model retries、prevent stale prepared-item identity reuse、AdvancedSQLiteSession metadata leak fixes、bound `$ref` expansion in strict JSON schema conversion、redact non-tool trace error details。窗口前 v0.18.2 背景还包括 hosted multi-agent beta support、GPT-5.6 request controls、Docker/Daytona/Unix PTY sandbox cleanup。Swarm 作为旧 educational framework，本周未见新增 release。
- 工程与产品分析：
  - 产品形态：Agents SDK 是 OpenAI 官方 Python agent runtime，面向 handoffs、tools、realtime、computer、sandbox、tracing 与多 agent；Swarm 更像历史教育项目。
  - 工程架构：本周集中修复并发隔离、session initialization、retry 状态、trace redaction、schema expansion 与 E2B workspace，说明 SDK 正进入 production hardening 阶段。Computer provider isolation 对浏览器/桌面 agent 尤其关键。
  - 生态/采用：GitHub 核验显示 openai/openai-agents-python 约 28,188 stars、openai/swarm 约 21,861 stars。真正重要的不是 stars，而是官方 SDK 会成为 OpenAI Presence、ChatGPT Work、开发者 agent 的底层参考。
  - 风险/限制：官方 SDK 更新频繁，hosted multi-agent、computer、sandbox、realtime 都涉及权限和成本；生产采用需要 pin 版本并审查 trace 中是否泄露用户数据。
- 关键数据：v0.18.3 release 内容见 [OpenAI Agents Python Releases](https://github.com/openai/openai-agents-python/releases)；GitHub 约 28,188 stars；Swarm 约 21,861 stars（核验 2026-07-27）。
- 原文链接：[OpenAI Agents Python Releases](https://github.com/openai/openai-agents-python/releases)、[OpenAI Swarm](https://github.com/openai/swarm)
- 影响判断：OpenAI Agents SDK 本周最值得关注的是工程硬化：session、sandbox、trace、schema 与 provider 并发隔离。这些修复比新 demo 更接近真实生产问题，也会影响第三方 agent 框架对 OpenAI runtime 的适配。

### browser-use
- 本周动态：browser-use 本周同时在 本组作为浏览器 agent 平台出现，在 本组作为开源项目也值得进入正文。GitHub releases 页面显示 0.13.x 线包含 Rust-backed beta agent、Browser Use CLI 3.0、MCP server for CLI 3.0、shared MCP runner、max_dim guard、navigation readiness detection 修复、markdown extraction URL 保留、LLM output truncation detection、structured error memory、Browser Harness pinning 与 Windows reliability 修复。官方 changelog 还在 2026-07-20 发布 Recording Controls & OAuth Browser Access：API 调用默认不录制、UI 会话默认录制但可关闭，`browserSettings.record` 显式控制并继承到 follow-up runs；OAuth terminal flow 新增 `v3:browsers:read` scope 可读取 existing browsers。GitHub 直查还显示 7月23-24 有 payment field extraction、cross-origin controls、state timeout recovery 等提交。
- 工程与产品分析：
  - 产品形态：browser-use 是开源 Python library/CLI + Browser Harness 的浏览器 agent 执行层，给 Claude Code、Codex、Cursor、OpenClaw 等 agent 提供浏览器控制能力。
  - 工程架构：本周架构重点是 Rust-backed beta agent、CLI 3.0、MCP runner、recording control、OAuth browser access、structured error memory 与 readiness detection。它把浏览器自动化从 Playwright 脚本封装升级为可由 agent 调用、可记录/中断/计费/限额的 harness。
  - 生态/采用：GitHub 核验显示 browser-use/browser-use 约 106,920 stars。Stars 之外，更关键的是它被多个 coding agent skill directory 与 Browser Harness API 接入，可能成为“agent 浏览器控制层”的事实标准候选。
  - 风险/限制：浏览器自动化天然涉及登录态、cookie、支付表单、跨域 iframe、录屏隐私与 OAuth scope。recording 默认与 OAuth 读浏览器能力需要清晰授权，否则会成为隐私风险。
- 关键数据：GitHub 约 106,920 stars（核验 2026-07-27）；0.13.x releases、CLI 3.0、MCP runner 与 2026-07-20 recording/OAuth changelog 来源 [browser-use Releases](https://github.com/browser-use/browser-use/releases)、[Browser Use changelog](https://browser-use.com/changelog/20-7-2026)。
- 原文链接：[browser-use GitHub releases](https://github.com/browser-use/browser-use/releases)、[Recording Controls & OAuth Browser Access](https://browser-use.com/changelog/20-7-2026)、[browser-use GitHub](https://github.com/browser-use/browser-use)
- 影响判断：browser-use 本周是开源生态里的强信号：浏览器 agent 需要的不是又一个 UI，而是可靠导航、错误记忆、OAuth/recording 控制和 MCP/CLI 接入。它有机会成为上层 agent 产品的通用浏览器执行层。

### OpenHands / AutoGPT / MetaGPT / SuperAGI
- 本周动态：这些老牌自主 agent/软件工程 agent 项目本周大多无窗口内重大 release。OpenHands releases 页面最新可见 1.11.0 为 2026-07-09（窗口外），内容包括 repository metadata observability traces、cloud/SaaS backend Agent Profiles、Budgets dashboard、Usage Dashboard、SMTP/resend email enabled 等；本期不写成本周动态。AutoGPT、MetaGPT、SuperAGI 本周未核到重大 release 或架构突破。GitHub 核验显示：OpenHands 约 82,201 stars，AutoGPT 约 185,700 stars，MetaGPT 约 69,527 stars，SuperAGI 约 17,641 stars。
- 工程与产品分析：
  - 产品形态：OpenHands 更偏 software engineering agent 平台；AutoGPT 是早期自主 agent 代表；MetaGPT 偏软件公司/多角色 agent；SuperAGI 偏通用 agent framework。
  - 工程架构：OpenHands 窗口外 1.11.0 的预算/usage/agent profile/observability 方向仍有参考价值，但本周无新增；AutoGPT/MetaGPT/SuperAGI 的本周公开信号弱。
  - 生态/采用：历史 stars 很高，但本周不能把历史热度当当前价值。应把它们放在观察池，除非出现新的生产 adoption、重大 release 或架构改造。
  - 风险/限制：早期 autonomous agent 项目常见问题是 demo 热、生产弱、权限/审计不足。OpenHands 的预算和 usage 背景方向较实用，但不属于本期新动态。
- 关键数据：OpenHands 约 82,201 stars；AutoGPT 约 185,700 stars；MetaGPT 约 69,527 stars；SuperAGI 约 17,641 stars（核验 2026-07-27）；OpenHands 1.11.0 发布时间 2026-07-09，非本周。
- 原文链接：[OpenHands Releases](https://github.com/OpenHands/OpenHands/releases)、[AutoGPT](https://github.com/Significant-Gravitas/AutoGPT)、[MetaGPT](https://github.com/FoundationAgents/MetaGPT)、[SuperAGI](https://github.com/TransformerOptimus/SuperAGI)
- 影响判断：本组本周应降低这些历史明星的正文权重。开源 Agent 生态正在从“自主 agent 概念”转向可部署 runtime、skills、MCP、sandbox、observability 与浏览器 harness；只有跟上这些生产议题的项目才值得进入正文。

### Hermes Agent
- 本周动态：本周未能核验到 Hermes Agent 的官方 GitHub release 或可引用原文动态。已在固定对象范围内搜索 Hermes/OpenClaw/Claude Code/Codex 相关生态线索，但未找到 2026-07-20~07-26 的可核验 release、benchmark 或官方公告。因此本期按观察/静默处理，不用二手热度或不明仓库凑数。
- 工程与产品分析：
  - 产品形态：Hermes 长期被关注为自进化/增长较快的 agent 项目，但本周缺少可验证来源。
  - 工程架构：无法确认本周 memory、skills、growth loop、sandbox、CLI/IDE 集成是否有变化。
  - 生态/采用：本周未公开可核验 stars、release、采用或集成数据。
  - 风险/限制：名称歧义较大，若无官方仓库/公告链接，很容易误把同名项目当作目标项目；本周不进入正文热点。
- 关键数据：本周重大公开动态：未发现；官方 GitHub 数据：未能可靠确认。
- 原文链接：未找到可核验本周原文。
- 影响判断：Hermes 本周应放观察池。后续只有在官方仓库、release、benchmark、被主流 agent 产品集成等信号明确后，才应进入 TOP 或正文重点。

## 本组洞察
- 本周开源 Agent 生态的核心不是“谁 stars 更多”，而是谁在把 agent runtime 做成可部署、可治理、可观测的系统：OpenClaw 把跨主机/渠道/节点/cron 统一，CrewAI 把 Skills/Flows/hooks/observability 产品化，OpenAI Agents SDK 修 session/sandbox/trace，browser-use 把浏览器控制层升级为 CLI/MCP/Harness。
- 观察池项目仍重要，但本周没有 release 就应克制：Dify、AutoGen、LlamaIndex、ADK、OpenHands、AutoGPT、MetaGPT、SuperAGI、Hermes 都不该用历史热度填充“本周动态”。
- 事实标准候选正在从框架层分化：LangGraph 偏有状态 workflow runtime，CrewAI 偏 crew/flow/skills，browser-use 偏浏览器执行层，OpenAI Agents SDK 偏官方 runtime，OpenClaw 偏完整 Agent OS。企业采用时应按 runtime 责任边界选型，而不是按 GitHub 榜单排序。

## 浏览器、Computer Use 与通用自主 Agent

### OpenAI Operator / ChatGPT Agent / ChatGPT Work
- 本周动态：时间窗内，OpenAI 没有把 2025 年发布的 ChatGPT agent/Operator 作为单独新版本发布，但在 2026-07-21 与 2026-07-22 两次把其“通用自主 Agent”能力推进到商业化场景：7 月 21 日的 Small Business program 明确把 ChatGPT Work 定位为可完成多步骤任务、端到端完成复杂项目/initiative 的 agent，并把培训、互动指南、Dropbox/Shopify/Intuit/Slack/Atlassian/Wix 等伙伴技能/优惠打包给小企业；7 月 22 日 OpenAI Presence 则把生产级 voice/chat agent 作为企业部署产品推出，强调系统访问、批准动作、升级给人工、仿真评测和 Codex 驱动的改进闭环。作为背景，7 月 9 日（时间窗外）ChatGPT Work 已发布：可跨 web/mobile/desktop、连接 Slack/Teams/Drive/SharePoint/email/calendar/CRM 等插件，生成 sheets/slides/docs/Sites，支持 Scheduled Tasks、内置浏览器、桌面 Computer Use、Chrome 侧边栏，并开始迁移 Atlas 浏览器能力。7 月 21 日同周的 OpenAI-Hugging Face 安全事件也给通用 Agent 的权限与沙箱边界提供了反面案例：长程模型在评测环境中链式利用漏洞突破隔离，说明“能上网/能执行/能持久操作”的 agent 风险需要按生产系统治理。
- 工程与产品分析：
  - 产品形态：从 Operator/Deep Research 合并后的 ChatGPT agent，演进为 ChatGPT Work（个人/团队生产力）、Presence（企业语音/聊天流程代理）和桌面 Computer Use 的组合。Work 更像通用办公室/浏览器/文件 agent；Presence 更像由 OpenAI FDE 与集成商交付的生产级流程 agent。
  - 工程架构：官方描述包括视觉浏览器、文本浏览器、有限联网 terminal、连接器/API、插件目录、桌面本地文件与应用控制、Scheduled Tasks，以及 Codex/Presence plugin 提议变更再由团队测试批准的闭环；企业侧强调管理员可控的插件、网络访问、敏感动作限制和 Compliance API。
  - 生态/采用：ChatGPT Work 在 7 月 9 日称 Codex 每周超过 500 万人使用、超过 100 万非开发工作用途；OpenAI 内部近 100% 团队使用 Work/Codex。Small Business program 把伙伴插件和线下/线上培训引入小企业渠道；Presence 启动客户包括 BBVA、SoftBank、IAG 探索场景。
  - 风险/限制：OpenAI 明确要求 consequential actions 前用户批准；桌面/浏览器任务涉及登录、cookie、连接器私密数据、支付/发送邮件等高风险，需 Watch Mode、takeover、浏览数据清除、Auto-review、管理员策略与网络访问控制。Hugging Face 事件显示内部评测若降低拒答并给网络/包缓存通道，agent 可链式突破隔离。
- 关键数据：ChatGPT Work 发布可用性（Pro/Enterprise/Edu 先滚动，Plus/Business 随后；桌面 Chat/Work/Codex 全计划含 Free）见 [OpenAI, 2026-07-09](https://openai.com/index/chatgpt-for-your-most-ambitious-work/)；Small Business program 与 ChatGPT Work 可用性见 [OpenAI, 2026-07-21](https://openai.com/index/introducing-chatgpt-small-business-program/)；Presence 电话支持 75% inbound issues 无人工解决、10 天内 handoff 降 15 个百分点，见 [OpenAI, 2026-07-22](https://openai.com/index/introducing-openai-presence/)；ChatGPT agent 背景指标包括 BrowseComp 68.9%、SpreadsheetBench 45.5%、HLE 41.6/44.4（时间窗外旧闻），见 [OpenAI, 2025-07-17](https://openai.com/index/introducing-chatgpt-agent/)。
- 原文链接：
  - [Introducing the ChatGPT for small business program｜OpenAI｜2026-07-21](https://openai.com/index/introducing-chatgpt-small-business-program/)
  - [Introducing OpenAI Presence｜OpenAI｜2026-07-22](https://openai.com/index/introducing-openai-presence/)
  - [OpenAI and Hugging Face partner to address security incident during model evaluation｜OpenAI｜2026-07-21](https://openai.com/index/hugging-face-model-evaluation-security-incident/)
  - [ChatGPT is now a partner for your most ambitious work｜OpenAI｜2026-07-09，背景](https://openai.com/index/chatgpt-for-your-most-ambitious-work/)
  - [Introducing ChatGPT agent｜OpenAI｜2025-07-17，背景](https://openai.com/index/introducing-chatgpt-agent/)
  - [ChatGPT agent System Card｜OpenAI｜2025-07-17，背景](https://openai.com/index/chatgpt-agent-system-card/)
- 影响判断：OpenAI 本周的重点不是“浏览器 agent 单点发布”，而是把通用 agent 包装为小企业采用计划与企业生产交付产品。其关键竞争力正在从模型/浏览器操作转向连接器、治理、评测、审批和落地服务；同时安全事件提示，长程 agent 的沙箱与网络边界将成为企业采购的硬门槛。

### Anthropic Computer Use
- 本周动态：本周未发现 Anthropic 对 Computer Use 发布新的官方产品公告或 changelog。核验范围包括 Anthropic 官网新闻、Claude Platform Computer Use Tool 文档、2024 年 Computer Use 发布背景页以及搜索结果；时间窗内没有新的“浏览器/OS 操作 Agent”公开重大动态。作为核验背景，Anthropic 的官方文档在当前形态中仍将 Computer Use 标为 beta，并列出面向 Claude Opus 5、Claude Sonnet 5、Claude Opus 4.8/4.7/4.6、Sonnet 4.6 等模型的 `computer-use-2025-11-24` beta header，以及旧模型的 `computer-use-2025-01-24` header；能力是让 Claude 通过截图、鼠标、键盘控制桌面环境，开发者负责提供虚拟机/容器、工具实现和 agent loop。文档的安全章节仍是本周最关键的可验证信息：建议专用 VM/容器、最小权限、避免敏感数据、域名 allowlist，并要求对 cookie、金融交易、同意条款等真实世界后果动作进行人工确认。
- 工程与产品分析：
  - 产品形态：更偏 API/开发者能力而非面向终端用户的独立浏览器产品；开发者把 Claude 接入可视化桌面，作为后台自动化、浏览器操作、软件/文档流程的一环。
  - 工程架构：官方参考实现包含 Docker 容器、虚拟 X11 显示（Xvfb）、Linux 桌面环境、Firefox/LibreOffice/文件管理器等应用、工具实现与 sampling loop；Claude 不直接连入环境，而是发出 tool use request，应用执行截图/点击/键盘等动作后回传结果。
  - 生态/采用：2024 发布时列举 Asana、Canva、Cognition、DoorDash、Replit、The Browser Company 探索多步任务；本周未发现新的官方客户或可量化采用更新。GitHub 参考实现需直查，但本次未发现本周相关 release，代码数据不写新增。
  - 风险/限制：Anthropic 明示网页/图片内 prompt injection 可能覆盖用户指令；自动分类器会在截图中识别潜在注入并引导模型先询问用户确认，但仍建议隔离环境和最小权限。当前能力仍是 beta，适合低风险任务先行。
- 关键数据：本周无新公开数据；Computer Use beta header 与支持模型见 [Claude Platform Docs, fetched 2026-07-27](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool)；旧发布背景中 OSWorld screenshot-only 14.9%、更多步骤 22.0%，SWE-bench Verified 49.0%、TAU-bench retail 69.2/airline 46.0 为 [Anthropic, 2024-10-22](https://www.anthropic.com/news/3-5-models-and-computer-use) 的历史数据。
- 原文链接：
  - [Computer use tool｜Claude Platform Docs｜核验于 2026-07-27](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool)
  - [Introducing computer use, a new Claude 3.5 Sonnet, and Claude 3.5 Haiku｜Anthropic｜2024-10-22，背景](https://www.anthropic.com/news/3-5-models-and-computer-use)
  - [Computer use reference implementation｜GitHub｜背景](https://github.com/anthropics/anthropic-quickstarts/tree/main/computer-use-demo)
- 影响判断：Anthropic 的 Computer Use 本周处于“稳定底层能力/无新公开商业动作”状态，但其文档对 sandbox、allowlist、人工确认和 prompt injection 分类器的描述仍是行业安全基线。与 OpenAI/Perplexity 的产品化路线相比，Anthropic 更依赖开发者把能力嵌入自身应用与治理流程。


### Google Project Mariner / Gemini Spark / Search Agents
- 本周动态：本周未发现 Google 对 Project Mariner 发布新的官方重大更新；核验 Google Labs Mariner landing、Google Blog、DeepMind 相关页后，Project Mariner 自 2026-05-04 已停止作为独立实验产品运行，landing 当前需要登录且可读内容极少，第三方 The Verge 在 5 月记录其页面提示“technology voyaged to other Google products”。因此本周动态应理解为“Mariner 技术线静默/已并入 Gemini、Search、Chrome/agentic products”，而非独立产品迭代。时间窗内可关联但不是 7 月 20-26 的旧闻包括：Google I/O 2026 发布 Gemini Spark（24/7 consumer agent）、Search information agents、agentic booking/calling、Search 内 Antigravity mini-app/dashboard，以及 Google AI Ultra $100/$200 订阅；6 月 DeepMind 发布 AI Control Roadmap，说明内部对 Gemini Spark 这类 agent 已建设 live monitor 来应对误删等行为。本周未看到 Google 在 7 月 20-26 公开宣布 Spark beta 新进展或 Mariner 后续迁移明细。
- 工程与产品分析：
  - 产品形态：Project Mariner 已不再是独立浏览器 agent；其能力在 Google 产品中分流为 Gemini Spark（个人数字生活 agent）、Search Agents（信息监控/订阅型 agent）、agentic booking/calling、Chrome/AI Mode 相关浏览与个性化能力。
  - 工程架构：I/O 旧闻称 Spark 运行在 Google Cloud 专用 VM 上，连接 Google 产品并在用户指挥下执行动作；Search Agents 则在后台 24/7 跨 web、新闻、社交、金融/购物/体育实时数据监控变化。DeepMind AI Control Roadmap 强调把内部 agent 当作潜在 insider threat，用监督模型审查推理、行动和计划，按 coverage、recall、time-to-response 衡量。
  - 生态/采用：Google 的优势在 Search/Gmail/Calendar/Photos/Workspace/Chrome 等分发面。Search AI Mode 旧闻称已超过 10 亿月活，AI Overviews 25 亿月活；Gemini app 9 亿月活。Agent 能力若成功迁移，比独立 Mariner 更容易触达用户。
  - 风险/限制：Project Mariner 关闭说明独立 agent 原型未必是最佳商业形态；Google 选择把权限压在订阅、Google 账号、Search/Workspace 交互与企业/云安全框架中。Spark/Personal Intelligence 涉及 Gmail、Photos、Calendar 等高敏个人上下文，必须依赖透明授权、可撤销连接、VM 隔离和行为监控。
- 关键数据：本周无 Mariner 新数据；Mariner shutdown 日期 2026-05-04 见 [The Verge, 2026-05-06](https://www.theverge.com/tech/925559/google-project-mariner-shut-down)；Google AI Ultra $100/月、顶级 Ultra 从 $250 降至 $200、Spark trusted testers 本周/下周 beta（旧闻）见 [Google Blog, 2026-05-19](https://blog.google/products-and-platforms/products/google-one/google-ai-subscriptions/)；Search AI Mode 超 10 亿月活、AI Overviews 25 亿月活见 [Google Blog, 2026-05-19](https://blog.google/products-and-platforms/products/search/search-io-2026/)；AI Control Roadmap 分析 100 万条 coding agent trajectories，见 [Google DeepMind, 2026-06-18](https://deepmind.google/blog/securing-the-future-of-ai-agents/)。
- 原文链接：
  - [Project Mariner landing｜Google Labs｜核验于 2026-07-27](https://labs.google.com/mariner/landing)
  - [Google shuts down Project Mariner｜The Verge｜2026-05-06，背景](https://www.theverge.com/tech/925559/google-project-mariner-shut-down)
  - [Everything new in our Google AI subscriptions｜Google｜2026-05-19，背景](https://blog.google/products-and-platforms/products/google-one/google-ai-subscriptions/)
  - [A new era for AI Search｜Google｜2026-05-19，背景](https://blog.google/products-and-platforms/products/search/search-io-2026/)
  - [Securing the future of AI agents｜Google DeepMind｜2026-06-18，背景](https://deepmind.google/blog/securing-the-future-of-ai-agents/)
- 影响判断：Google 本周没有独立 Mariner 动态，但“关闭原型、迁移到高流量产品”本身值得持续观察。对浏览器/网页任务 agent 赛道而言，Google 的关键变量不再是 Mariner demo，而是能否在 Search、Chrome、Gemini 与 Workspace 中以默认体验实现受控行动。

### Perplexity Comet
- 本周动态：本周未发现 Perplexity Comet 在 2026-07-20~07-26 的官方新发布；核验范围包括 Comet 官方产品页、Perplexity Hub Comet launch blog 以及搜索结果。官方产品页当前强调 Comet 是 “a new browser from Perplexity / the browser that works for you”，已覆盖 Mac、Windows、iOS、Android，并用“AI that understands / builds / emails / creates / shops”展示浏览器内代理能力：比较不同新闻来源、调用建站工具生成基础网站、根据日程草拟邮件、基于 syllabus 制定学习计划、购买便宜舒适办公椅等。旧闻（2025-07-09）显示 Comet 起初面向 Perplexity Max 用户，夏季逐步邀请 waitlist；本周搜索未发现价格、可用性、安全边界或模型能力的新官方变动。由于 Perplexity 官网直接抓取有 Cloudflare 拦截，本次通过 Jina reader 打开官方页面全文核验，但仍以官方页面内容为准。
- 工程与产品分析：
  - 产品形态：Comet 是完整 Chromium-like AI browser，而非普通网页插件；核心卖点是把 assistant 固化在浏览会话中，让用户在任意页面、跨 tab 询问、比较、总结和执行邮件/购物/预订等动作。
  - 工程架构：官方没有公开底层 agent loop、权限模型或任务成功率；从产品页可见它围绕浏览器上下文、标签页、邮箱、购物和网页内容构建侧边/会话式 assistant。与 ChatGPT Work 的“云/桌面/连接器”相比，Comet 更强调浏览器为主工作台。
  - 生态/采用：本周无官方新增用户数；产品页显示多平台下载入口和资源中心。旧发布从 Max/邀请制开始，后续是否免费/全球化需以更新公告为准，本周未核到新的官方公告。
  - 风险/限制：Comet 的强项也是风险点：浏览器天然携带登录态、cookie、历史记录、邮箱和支付页面。产品页列出隐私/安全 FAQ 但未在可抓取正文中展开；涉及购买、邮件发送、金融/旅行等任务时，仍应把最终确认、敏感站点隔离、浏览数据可控作为必要边界。
- 关键数据：本周无新公开任务完成率/用户数；官方产品页显示平台覆盖 Mac、Windows、iOS、Android，见 [Perplexity Comet page, fetched 2026-07-27](https://www.perplexity.ai/comet)；旧 launch blog 称 2025-07-09 起 Max subscribers 可用、waitlist 夏季邀请，见 [Perplexity, 2025-07-09](https://www.perplexity.ai/hub/blog/introducing-comet)。
- 原文链接：
  - [Comet Browser: a Personal AI Assistant｜Perplexity｜核验于 2026-07-27](https://www.perplexity.ai/comet)
  - [Introducing Comet: Browse at the speed of thought｜Perplexity｜2025-07-09，背景](https://www.perplexity.ai/hub/blog/introducing-comet)
- 影响判断：Comet 本周处于静默期，但仍是“AI 原生浏览器”路线的代表。短期看，它需要补足可验证的权限/审计/支付确认叙事；长期看，如果浏览器入口稳定，Comet 会持续压缩传统搜索、书签、标签页和网页自动化插件的边界。


### Manus
- 本周动态：本周没有发现 Manus 在 2026-07-20~07-26 发布独立重大功能公告；核验范围包括 Manus 官网、Web App、Wide Research、Manus Browser Operator、Events、Pricing、API/Trust Center 入口和 2026 年 agents 对比博客。本周可确认的是其产品矩阵已明确把“浏览器/网页任务完成”纳入 Browser Operator：官方页面称它可把现有浏览器连接到 Manus，在用户本地 IP、当前登录会话和活动标签页中执行任务，适合 premium platforms、CRM、authenticated services；流程为安装扩展、在 connector tab 启用、授权浏览器访问，然后 agent 使用已登录会话完成信息收集和操作。主页还显示“Manus is now part of Meta — bringing AI to businesses worldwide”（需持续跟踪正式交易/公告来源），产品导航包含 Web app、Wide Research、Mail Manus、Slack integration、Browser Operator、API、Team plan 等。Events 页没有 2026-07-20~07-26 新活动，页面列出的 7 月 20/26 活动为 2025 年旧活动。
- 工程与产品分析：
  - 产品形态：通用云端/网页任务 agent + 浏览器扩展 + Web App Builder + Wide Research。相比只做“搜索总结”的 agent，Manus 强调交付成品：网页应用、数据表、研究报告、邮件/Slack 流程和浏览器内 authenticated workflow。
  - 工程架构：Browser Operator 依赖本地浏览器上下文和扩展，将任务执行从云端 VM 转到用户可信本地网络/IP/登录态；Wide Research 则是并行多 agent 架构，每个子任务独立 VM、工具和互联网访问，由主 agent 分发与汇总，避免上下文污染。
  - 生态/采用：官网显示 Team、SSO、API、Trust Center 和 Slack integration 入口；Web App Builder 面向 founders/creators/businesses，宣称内置数据库和后端、可导出完整 codebase、连接自定义域名、版本回滚和权限协作。本周未公开新增客户数或任务成功率。
  - 风险/限制：Browser Operator 明确使用现有登录态，这提升通过安全检查的能力，也放大隐私、越权、误发帖、误下单、简历批量投递、订单历史读取等风险。官方页面提出“Grant Access / permission”，但可抓取正文未披露细粒度权限、审计日志、支付/发布确认策略；应默认要求用户可随时停止、敏感动作二次确认、最小化授权。
- 关键数据：本周无新增成功率/用户数；Browser Operator 发布页时间元数据为 2026-04-24，能力与本地浏览器会话见 [Manus Browser Operator](https://manus.im/features/manus-browser-operator)；Wide Research 页同为 2026-04-24，称可部署 hundreds of AI agents in parallel、每个 sub-agent 有 own VM/tools/internet access，见 [Manus Wide Research](https://manus.im/features/wide-research)；Web App Builder 支持 full code export / no lock-in 见 [Manus Web App](https://manus.im/features/webapp)。
- 原文链接：
  - [Manus homepage｜核验于 2026-07-27](https://manus.im)
  - [Manus Browser Operator｜Manus｜2026-04-24，背景](https://manus.im/features/manus-browser-operator)
  - [Manus Wide Research｜Manus｜2026-04-24，背景](https://manus.im/features/wide-research)
  - [Launch business applications without engineering resources｜Manus Web App｜核验于 2026-07-27](https://manus.im/features/webapp)
  - [10 Best AI Agents in 2026｜Manus Blog｜时间窗内搜索显示 2026-07-24 左右，需注意厂商自评](https://www.manus.im/blog/best-ai-agents)
- 影响判断：Manus 的差异化在于“直接交付物”和“用户本地浏览器登录态”的结合，实际可用性会比纯云端 agent 更强。风险也更尖锐：一旦授予浏览器上下文，邮件、社媒、招聘、订单、CRM 都可能被操作，企业采用必须先问权限隔离与审计。

### Genspark / 通用任务 Agent
- 本周动态：本周未发现 Genspark 在 2026-07-20~07-26 发布与浏览器/Computer Use 直接相关的新官方公告；核验范围包括 Genspark 官网、Genspark AI Workspace 页面、搜索到的 BusinessWire/Microsoft 合作稿（因 BusinessWire 403，仅作线索，不作为主要事实）以及产品导航。官网当前页面元数据发布时间为 2026-06-30，显示 Genspark AI Workspace 6.0，产品结构包括 Standard、Connectors、Speak、GenTeam、AI Slides/Sheets/Docs/GenMail、Google Workspace Plugin、Microsoft 365 PowerPoint/Excel/Word Plugin、Build Suite（Design/Prototype、Code、Dashboards & CRM）、AI Chat/Image/Video/Music/Audio、AI Meeting Notes、All Agents，以及独立产品 Genspark Claw、Speakly、GenClipboard、GenTerminal。搜索结果显示 2026-07-25 有转载称 Genspark 与 Microsoft 365 / Agent 365 战略合作，但可打开的 National Law Review 页面被客户端 challenge 阻断，BusinessWire 原文也 403，因此不写入“已核实本周动态”。
- 工程与产品分析：
  - 产品形态：Genspark 更像 All-in-One AI Workspace：把文档、表格、幻灯片、邮件、设计、代码、仪表盘/CRM、内容生成和会议记录收敛到一个多 agent 工作台，而不是专门的 AI 浏览器。
  - 工程架构：官网未公开 agent loop 或浏览器控制细节；可确认的是其通过 Google Workspace/Microsoft 365 插件、GenTeam 和工具矩阵把任务路由到不同办公/创作 agent。若 Genspark Claw 是“AI assistant with own computer”的能力，本周未能打开到足够原文核验，暂不展开。
  - 生态/采用：产品导航已覆盖移动应用下载、多语言站点、企业/商业入口与大量工具页；Microsoft 365 插件若最终坐实，将是办公套件入口的重要渠道，但本周未能核到可引用原文。
  - 风险/限制：Workspace 型 agent 的主要风险是企业文档、邮件、表格、CRM 和会议记录的权限边界；与浏览器 agent 相比，误操作更多发生在文件创建、邮件发送、数据改写和外部分享。由于官网未公开审批/审计/数据保留细节，本周关键安全数据为未公开。
- 关键数据：官网元数据 `Published Time: Tue, 30 Jun 2026 21:18:00 GMT`；Workspace 6.0 产品矩阵见 [Genspark homepage, fetched 2026-07-27](https://www.genspark.ai/)；本周新增客户/ARR/任务成功率/浏览器 agent benchmark：未公开或未核实。
- 原文链接：
  - [Genspark - Your All-in-One AI Workspace｜Genspark｜核验于 2026-07-27](https://www.genspark.ai/)
  - [Genspark Announces Global Strategic Partnership with Microsoft...｜BusinessWire｜2026-04-29，原文访问受限，仅作背景线索](https://www.businesswire.com/news/home/20260429907387/en/Genspark-Announces-Global-Strategic-Partnership-with-Microsoft-to-Embed-AI-Agents-Across-Microsoft-365-and-Agent-365)
- 影响判断：Genspark 本周没有可核实的新浏览器/Computer Use 事件，但其 Workspace 6.0 体现了通用 agent 商业化的另一条路线：把 agent 嵌入办公生产套件而非浏览器。后续若 Microsoft 365/Agent 365 合作有可访问官方原文，应补充其权限、租户治理和商业条款。

### Kimi Agent / Moonshot Kimi
- 本周动态：本周未发现 Kimi 发布独立“浏览器/Computer Use 通用 Agent”重大公告；核验范围包括 Kimi 官网、Kimi API 文档、Kimi K3/K2.7/K2.6 指南线索和搜索结果。可确认的新近背景是 Kimi API 文档已将 Kimi K3 标为正式发布并推荐从 `kimi-k3` 开始：K3 支持 1M token 上下文与视觉理解，定位于 Claude Code 等编程 Agent、知识工作和深度推理；K2.7 Code 支持 256K 上下文、文本/图片/视频输入和思考模式；K2.6 支持通用对话、Agent 任务、视觉理解和复杂推理。Kimi 主页的可抓取文案为 “Ask anything, or task an agent...”，标题为 “Built for Agentic Coding & Knowledge Work”。因此本周可写为“模型/API 层 agent 能力持续可用，无独立浏览器操作产品新动态”。
- 工程与产品分析：
  - 产品形态：更偏模型与 API 平台，服务编程 Agent、知识工作 Agent 和工具调用工作流；没有核到类似 Comet/Browser Operator 的官方浏览器产品更新。
  - 工程架构：Kimi API 兼容 OpenAI API 格式，支持工具调用、JSON mode、思考模型、多模态输入、流式输出和多轮对话；K3 顶层 `reasoning_effort` 支持 low/high/max，适合长程工具调用与 Agent 任务。
  - 生态/采用：文档强调 Claude Code Kimi 接入、开发者社区和 OpenAI SDK 兼容，降低现有 agent 框架迁移成本；Browser Use 7 月 17 日 changelog 也把 Kimi K3 加入 Browser Harness，说明 Kimi 正被第三方 browser agent 平台纳入模型选择。
  - 风险/限制：模型/API 层没有天然浏览器权限，但一旦被 Claude Code、Browser Use 或企业工具链接入，就会继承 shell、文件、网页、凭证等外部工具风险。Kimi 文档提示 API Key 不要泄露或硬编码，具体浏览器/支付/登录确认策略取决于上层框架。
- 关键数据：Kimi K3：2.8 万亿参数、1M token 上下文、视觉理解，见 [Kimi API Docs, fetched 2026-07-27](https://platform.kimi.com/docs/overview.md)；K2.7 Code / K2.6：256K 上下文与多模态输入见同页；本周独立 agent 成功率/定价/客户：未公开。
- 原文链接：
  - [Kimi API 快速开始｜Moonshot/Kimi｜核验于 2026-07-27](https://platform.kimi.com/docs/overview.md)
  - [Kimi AI with K3｜Kimi｜核验于 2026-07-27](https://www.kimi.com/)
  - [Browser Harness API, New Models & Lower Top-Up Minimum｜Browser Use｜2026-07-17，显示 Kimi K3 被第三方浏览器 agent 平台接入](https://browser-use.com/changelog/17-7-2026)
- 影响判断：Kimi 本周对 本组的价值主要在“成为 agent 框架的模型底座”，而不是直接争夺 AI 浏览器入口。其长上下文和视觉能力适合网页/文档密集任务，但真正的安全与可用性取决于集成方的浏览器控制、沙箱和权限确认设计。
### Qwen Agent / BrowserQwen
- 本周动态：本周未发现 Qwen-Agent 在 2026-07-20~07-26 发布新的浏览器/Computer Use 产品公告；核验范围包括 Qwen-Agent GitHub README、BrowserQwen 文档、GitHub release/commit。GitHub 仓库本周（按 git log 2026-07-20~07-26 Asia/Shanghai）无提交，仓库总提交数 304；最近 README 可见的动态是 2026-02-16 开源 Qwen3.5、2026-01-27 开源 DeepPlanning benchmark 与文档，均非本周。可确认的固定对象形态是：Qwen-Agent 是基于 Qwen 指令遵循、工具使用、规划与记忆能力的 LLM 应用框架，并作为 Qwen Chat 后端；示例应用包括 Browser Assistant、Code Interpreter、Custom Assistant。BrowserQwen 是 Chrome 扩展，能围绕当前网页/PDF 讨论、记录浏览过的网页和 PDF/Word/PowerPoint 材料，支持多网页问答、长文写作和 Code Interpreter 数据可视化。
- 工程与产品分析：
  - 产品形态：开源 agent 框架 + 浏览器扩展示例，而不是闭源的消费级 AI 浏览器。适合企业/开发者基于 Qwen/DashScope/自部署模型构建网页阅读、文档问答、代码解释器和 MCP 工具 agent。
  - 工程架构：Qwen-Agent 提供 LLM、Tool、Agent 原子组件和 Assistant/FnCallAgent 等高层组件；支持 DashScope 或 OpenAI-compatible 自部署模型；Code Interpreter 基于本地 Docker 容器执行。BrowserQwen 需要在本机部署数据库服务管理浏览历史和对话历史，再安装 Chrome unpacked extension，并由用户点击“Add to Qwen's Reading List”授权后台分析页面。
  - 生态/采用：仓库 README 指向 Qwen Chat、Hugging Face、ModelScope、文档、Benchmark、微信和 Discord；支持 PyPI 安装 `qwen-agent[gui,rag,code_interpreter,mcp]`。本周无新增 release，GitHub releases 页面未作为主要更新来源。
  - 风险/限制：BrowserQwen 会记录浏览页面和文档材料，天然涉及隐私与企业资料外泄；Code Interpreter 虽基于 Docker，但文档曾提示部分 python executor 用于本地测试而非生产。浏览器扩展需要显式授权页面加入阅读列表，这比完全接管浏览器更保守，但也限制了自动化动作能力。
- 关键数据：GitHub 直查：2026-07-20~07-26 无提交、总提交数 304（`git clone --filter=blob:none --no-checkout` 后 `git log`/`rev-list`，核验于 2026-07-27）；README 动态：Qwen3.5 2026-02-16、DeepPlanning 2026-01-27，见 [Qwen-Agent GitHub](https://github.com/QwenLM/Qwen-Agent)；BrowserQwen 支持网页/PDF/Office 材料记录、多网页 QA、Code Interpreter，见 [browser_qwen.md](https://github.com/QwenLM/Qwen-Agent/blob/main/browser_qwen.md)。
- 原文链接：
  - [QwenLM/Qwen-Agent｜GitHub｜核验于 2026-07-27](https://github.com/QwenLM/Qwen-Agent)
  - [BrowserQwen 文档｜GitHub｜核验于 2026-07-27](https://github.com/QwenLM/Qwen-Agent/blob/main/browser_qwen.md)
- 影响判断：Qwen-Agent 本周静默，但其价值在于为中文/开源生态提供可改造的 agent 工程脚手架。BrowserQwen 更偏“浏览内容理解与写作辅助”，不是强执行型 Operator；这使它风险相对可控，也意味着真实网页任务完成率取决于二次开发。

### AutoGLM / 智谱清言插件 / Open-AutoGLM
- 本周动态：本周未发现 AutoGLM 在 2026-07-20~07-26 发布新的重大公开公告；核验范围包括智谱清言插件 AutoGLM-Web landing、智谱清言主页、Open-AutoGLM GitHub、GitHub releases、搜索结果。清言插件页面显示“AutoGLM Web / 开启全自动上网新体验”，支持 Google Chrome、Microsoft Edge、360 安全浏览器，并提供 Chrome Web Store 入口和社群。Open-AutoGLM 仓库本周无提交、无 GitHub releases；README 显示它是基于 AutoGLM 的 Phone Agent 框架，使用 ADB/HDC 控制 Android/HarmonyOS/iOS 相关设备，以视觉语言模型理解屏幕并规划点击/输入/滑动等动作，支持敏感操作确认和登录/验证码人工接管。它还提供 AutoGLM-Phone-9B、AutoGLM-Phone-9B-Multilingual 模型下载链接，以及 BigModel/ModelScope API 或本地 vLLM/SGLang 部署路径。
- 工程与产品分析：
  - 产品形态：智谱侧同时有浏览器插件（AutoGLM-Web）和手机 GUI Agent（Open-AutoGLM/Phone Agent）。前者面向“全自动上网”、多链接总结、站内检索、写作、划线翻译等浏览器任务；后者面向移动端 App 操作。
  - 工程架构：Phone Agent 架构是截图→视觉模型理解界面→输出坐标/动作→ADB/HDC 执行→循环；支持 Launch、Tap、Type、Swipe、Back、Home、Long Press、Double Tap、Wait、Take_over 等动作；远程调试可通过 WiFi/网络连接设备。模型服务可走 BigModel `autoglm-phone`、ModelScope 或本地 `autoglm-phone-9b`。
  - 生态/采用：支持 50+ 中文 Android 应用和 60+ 鸿蒙原生/系统应用，覆盖微信、淘宝、京东、美团、12306、滴滴、抖音、小红书、WPS、UC 浏览器等；Midscene.js 已适配 AutoGLM 模型，可用于 iOS/Android 自动化。
  - 风险/限制：GUI Agent 会直接操作真实手机/浏览器，支付、密码、银行类页面、验证码和登录必须人工接管或确认；ADB/HDC 调试本身是高权限通道，设备需开发者模式、USB 调试/安全设置、ADB Keyboard 等，普通用户误配风险高。项目声明仅供研究学习，严禁违法用途。
- 关键数据：GitHub 直查：Open-AutoGLM 2026-07-20~07-26 无提交、总提交数 106，releases 页面显示无 releases（核验于 2026-07-27）；AutoGLM-Phone-9B / Multilingual 下载见 [Open-AutoGLM GitHub](https://github.com/zai-org/Open-AutoGLM)；插件支持 Chrome/Edge/360 浏览器见 [AutoGLM-Web landing](https://new-front.chatglm.cn/webagent/landing/index.html)；支持 50+ Android 应用、60+ HarmonyOS 应用、默认 max steps 100 见 GitHub README。
- 原文链接：
  - [智谱清言插件 AutoGLM-Web｜核验于 2026-07-27](https://new-front.chatglm.cn/webagent/landing/index.html)
  - [zai-org/Open-AutoGLM｜GitHub｜核验于 2026-07-27](https://github.com/zai-org/Open-AutoGLM)
  - [Open-AutoGLM Releases｜GitHub｜核验于 2026-07-27](https://github.com/zai-org/Open-AutoGLM/releases)
- 影响判断：AutoGLM 是中国 GUI/移动端 agent 中工程落地较完整的一支，尤其覆盖真实 App 与浏览器插件。短板是本周无新增公开进展，且高权限设备控制对安全、合规和用户教育要求很高；若商业化，需要把确认回调、接管、审计和敏感 App 禁用做成默认能力。

### Browser Use（补充：开源/云端浏览器 Agent 平台）
- 本周动态：Browser Use 是本周 本组最明确的新增动态之一。2026-07-20，Browser Use 发布 “Recording Controls & OAuth Browser Access”：Browser Harness v4 API 的 session recording 改为由调用方控制，API 调用默认不录制、UI 会话默认录制但可关闭，`browserSettings.record` 显式值优先并会被同一 browser 的 follow-up runs 继承；OAuth terminal flow 新增 `v3:browsers:read` scope，可读取 existing browsers。时间窗外但同一发布节奏中，7 月 17 日 Browser Harness agent API 公开进入 OpenAPI spec/docs/SDK codegen，支持 typed status、cursor pagination、session queue/interrupt、run events、per-run spend caps；新接入 Grok 4.5、Kimi K3、Claude Fable 5，并让 GLM/MiniMax 原生可用于 Computer Use 和 Browser Use。GitHub releases/commit 直查显示本周 7 月 23-24 有多次修复，包括 payment field extraction、cross-origin controls、state timeout recovery 等。
- 工程与产品分析：
  - 产品形态：开源 Python library/CLI + Browser Harness Cloud API + hosted cloud agent + stealth/proxy/captcha 基础设施。它不是面向普通用户的浏览器，而是给 AI agents 和开发者的浏览器控制层。
  - 工程架构：CLI 3.0（7 月 1 日旧闻）把固定 click/type 动作菜单换成可编辑 Python harness，让 coding agents 在浏览器内执行 Python；0.13.0 引入 Rust-backed beta agent，给现代模型更直接的 browser control loop。Cloud API 支持 runs/sessions、event log、queued follow-up messages、interrupt 和 maxCostUsd。
  - 生态/采用：README 称可接入 Claude Code、Codex、Cursor、Hermes、OpenClaw 等 agent，并提供 Python library；支持 ChatBrowserUse、OpenAI/Anthropic/Google 等 provider-prefixed 模型。本周新增 Kimi K3、Grok 4.5、Claude Fable 5、GLM/MiniMax，显示其定位是多模型浏览器执行平台。
  - 风险/限制：浏览器自动化涉及登录态、真实 profile、CAPTCHA 绕过、代理和 stealth；7 月 20 把 recording 默认关/可控是隐私治理进步，但 OAuth 读取 existing browsers 也扩大了授权面。7 月 24 修复 cross-origin payment fields，说明支付字段/iframe 表单识别是敏感且复杂的工程边界。
- 关键数据：Changelog 日期 2026-07-20；Browser Harness API 公开与 pay-as-you-go top-up 从 $25 降至 $5 是 2026-07-17 旧闻；README 称 Odysseys leaderboard 87.4% average、100 real-world browser tasks benchmark 开源，见 [Browser Use GitHub](https://github.com/browser-use/browser-use)；GitHub 直查 2026-07-20~07-26 有提交，如 `0964ad45 2026-07-24 Call the model with minimal state after capture timeout (#5300)`，仓库总提交数 9905（核验于 2026-07-27）。
- 原文链接：
  - [Recording Controls & OAuth Browser Access｜Browser Use｜2026-07-20](https://browser-use.com/changelog/20-7-2026)
  - [Browser Harness API, New Models & Lower Top-Up Minimum｜Browser Use｜2026-07-17，背景](https://browser-use.com/changelog/17-7-2026)
  - [Browser Use Releases｜GitHub｜核验于 2026-07-27](https://github.com/browser-use/browser-use/releases)
  - [browser-use/browser-use｜GitHub｜核验于 2026-07-27](https://github.com/browser-use/browser-use)
- 影响判断：Browser Use 本周的 recording/OAuth 与 Harness API 更新，说明浏览器 agent 基础设施正在从 demo 库走向可计费、可审计、可中断、可限额的生产 API。它对上层产品的影响很直接：未来很多“通用 Agent”可能不自研浏览器控制，而是采购/嵌入这类 harness。

## 本周总结
- 有料动态：OpenAI（Small Business/Presence 与安全事件）、Browser Use（2026-07-20 recording/OAuth + GitHub 修复）、Manus（虽无本周发布但 Browser Operator/Meta 状态需跟踪，作为持续有料对象）、Kimi（模型底座被 Browser Use 接入，独立产品静默）、Google（Mariner 静默但 Spark/Search Agents 背景关键）。
- 观察/静默：Anthropic Computer Use、Perplexity Comet、Genspark、Qwen Agent、AutoGLM 本周均未核到时间窗内重大新公告；已分别记录核验范围与原因。
- 共同趋势：浏览器/Computer Use agent 的竞争从“会点击网页”转向四个工程问题：登录态和本地环境如何授权、敏感动作如何确认、录屏/事件/成本如何审计、以及长程任务失败/跨域 iframe/支付字段等边角 case 如何恢复。

## 企业垂直 Agent、协议、评测与基础工程

## 企业/垂直 Agent

### Sierra
- 本周动态：本周 Sierra 有两条实质动态。第一，Sierra 官方博客在 7月23日前后发布《Building Sierra’s MCP Gateway》，披露其内部 MCP Gateway 已成为连接员工 AI agents 与 Slack、GitHub、Salesforce、数据仓库、生产系统、内部文档等 45 个服务的统一网关；官方给出的采用数据是 89% 员工活跃使用，近三分之二提交来自最初项目组之外。文章重点不在“接一个 MCP server”，而在企业级 agent 工程冰山：统一权限、审计、法律合规、跨客户数据隔离、身份归因、服务 owner 模式、sidecar 与多区域服务、以及对 OAuth/heartbeat/tool name validation 等客户端差异的兼容。第二，Sierra 在本周发布/更新 Takeoff 收购公告（页面抓取时间窗内，原文称 Takeoff 2026年7月被 Sierra 收购），将 Takeoff 的 long-horizon agent runtime 与 Sierra Horizon 结合；Takeoff 原 CEO Aakash Thumaty 在文中披露 Takeoff 从年初 0 ARR 增长到“nearly 8 figures of revenue”，3 人团队接近 8 位数 run rate，并强调 Sierra/Takeoff 的共同商业模式是 outcome-based、面向行业端到端解决方案而非按 token 收费。Horizon 本体 7月16日发布，属于窗口前背景；本周可写的是收购整合与 MCP Gateway 工程复盘。
- 工程与产品分析：
  - 产品形态：Sierra 仍定位为企业客户体验/业务结果型 agent 平台，本周新增叙事是 Horizon 长周期互动 agent 与内部 MCP Gateway 的企业连接层。Horizon 面向跨天/跨周的入站与出站客户互动；Gateway 面向员工与内部 agent 的工具访问。
  - 工程架构：MCP Gateway 采用统一网关抽象，接入远程 MCP server、本地 sidecar、多区域服务与 CLI 型只读访问；敏感客户数据访问采用多阶段判定：确定性候选客户生成、快速模型初筛、慢模型最终判定客户与敏感性；跨客户访问需 out-of-band 显式批准并写入审计日志。身份原则是交互式工作以用户身份运行，定时/共享工作以最小权限 service account 运行，访问客户数据的自动化需预授权声明客户与工具范围。
  - 生态/采用：官方披露内部 45 个服务、89% 员工使用，Gateway 已从中央团队“grab the lock”阶段进入社区共建。Takeoff 侧披露覆盖 lending、healthcare 等五个行业、数个七位数合同，但客户名未公开。
  - 风险/限制：最大风险是代理跨客户复用/泄露敏感上下文、工具权限过宽、agent 绕过官方接口自证成功，以及 MCP 客户端生态不一致造成审计/授权断裂。Sierra 的经验表明 80% 工作流覆盖在 agent 产品中“约等于 0%”，否则用户不会迁移完整流程。
- 关键数据：89% 员工活跃使用 MCP Gateway、45 个服务、近三分之二 commits 来自初始团队外（[Sierra MCP Gateway，2026-07-22 lastmod/本周发布](https://sierra.ai/blog/building-sierras-mcp-gateway-an-engineering-iceberg)）；Takeoff 从 0 ARR 到 nearly 8 figures revenue、3 人团队接近 8 位数 run rate、五个行业、多个七位数合同（[Sierra acquires Takeoff，页面本周更新](https://sierra.ai/blog/sierra-acquires-takeoff)）。交易金额、Horizon 定价未公开。
- 原文链接：
  - [Building Sierra’s MCP Gateway: An engineering iceberg](https://sierra.ai/blog/building-sierras-mcp-gateway-an-engineering-iceberg)
  - [We’re excited to share that Sierra is acquiring Takeoff](https://sierra.ai/blog/sierra-acquires-takeoff)
  - [Sierra Blog 索引（核验 7月16 Horizon 为窗口前背景）](https://sierra.ai/blog)
- 影响判断：Sierra 把“企业 agent 平台”的竞争点从模型调用推进到身份、权限、审计与跨系统连接层，且明确走 outcome-based 而非 token-based 计费叙事。MCP Gateway 文章对企业落地很有参考价值：真正可复用的是数据最小暴露、客户域隔离、审批与审计闭环，而不是简单套 MCP 标准。

### Glean
- 本周动态：Glean 本周连续发布两篇与企业 agent 工程强相关的文章。7月23日《How to optimize token efficiency in agentic systems》把 token 成本从“prompt 裁剪”上升为 workflow design 问题，主张按 planning、retrieval、tool calls、execution、review、retries、memory updates 等阶段度量 token，并用检索降噪、结构化记忆、复杂度路由、循环终止规则和复用已验证计划来提升“每 token 成功任务数”。7月24日《What enterprise voice demands of your tool stack》从 Glean Voice 的经验说明，企业语音 agent 的瓶颈经常不是模型而是工具栈：语音模型上下文更紧、延迟预算更硬、错误更难静默修复，因此必须在执行前检索最合适 skill，暴露 canonical names/server identity/argument schema，采用单一规范执行路径，明确授权状态，禁止模型在下游确认前声称成功。Glean 博客索引还显示 7月15日 agent identity、7月17日 Databricks integration 等窗口前背景；本期不纳入本周动态，只作为治理脉络。
- 工程与产品分析：
  - 产品形态：Glean 以企业搜索/Work AI/AI Assistant 为底座，向 agentic engine、voice、independent agents 与 AI gateway 扩展。本周内容偏工程最佳实践，但直接服务企业 assistant/agent 产品的 ROI 与可靠性。
  - 工程架构：token efficiency 文章提出分层 memory（当前 step working state、workflow session summary、按需检索长期事实）、stage-level token telemetry、retrieval/rerank/dedup、routing by complexity/risk/context depth、bounded loops 与 plan caching。voice 文章进一步提出 skill wrapping：把任务所需工具与详细指令封装成 skill，请求时先对 catalog live search/ranking/filter-rank-trim，再执行工具；动作执行走“find skill → resolve authorized tool → validate call → execute → confirm result”的 canonical path。
  - 生态/采用：Glean 未在本周文章披露新客户或付费数字；但产品面向全企业知识与工具栈，强调 permission-aware retrieval、企业上下文、Databricks/Slack/Jira/GitHub 等生态连接（部分为窗口前背景）。
  - 风险/限制：语音场景放大了工具 schema、授权状态和重试语义的不完备；token 优化若只压缩 prompt 而不衡量 groundedness、human correction rate、retry frequency，会把成本转移为失败重试或人工返工。Glean 没披露 voice 的延迟、成功率或成本基准，定量 ROI 仍未公开。
- 关键数据：7月23日 token efficiency 文章列出 tokens per successful task、cost per completed workflow、latency、retrieval precision、groundedness、human correction rate、retry frequency、context utilization rate 等度量（[Glean，2026-07-23](https://www.glean.com/blog/how-to-optimize-token-efficiency-in-agentic-systems)）；7月24日 voice tooling 文章提出 skill retrieval、lexical weighting、structured retry signals、canonical execution path（[Glean，2026-07-24](https://www.glean.com/blog/voice-tools)）。客户数、定价、voice 量化指标未公开。
- 原文链接：
  - [How to optimize token efficiency in agentic systems](https://www.glean.com/blog/how-to-optimize-token-efficiency-in-agentic-systems)
  - [What enterprise voice demands of your tool stack](https://www.glean.com/blog/voice-tools)
  - [Glean Blog 索引](https://www.glean.com/blog)
- 影响判断：Glean 的本周重点非常贴近企业 CIO/平台团队：agent 成本与质量不能只看单次调用，而要看成功工作流的端到端 token 生命周期。语音 agent 的“工具契约前置 + 授权可见 + 执行后确认”也会反向提高文本 agent 的工具调用可靠性。

### Harvey
- 本周动态：Harvey 本周没有发布新的融资、平台大版本或 benchmark；但官方博客在 7月24日连续发布两篇面向法律垂直场景的产品教育/落地文章，分别覆盖 AI legal brief writing 与 in-house legal workflow automation。两篇都不是“新功能发布”，但能反映 Harvey 当前商业落地重点：把 legal-specific AI 从通用问答推进到可审计、可验证、可嵌入 Microsoft Word/合同队列/法律知识库的工作流。brief writing 文章强调文件级法律生成必须同时满足三根支柱：事实来自案卷、法律来自真实可引用权威、论证结构能说服；并明确通用 chatbot 的风险是虚构 citation、quote 或 holding，法院制裁风险不能由模型兜底。in-house automation 文章则以法律部门高压队列为背景，列出合同审查、例行协议初稿、合同集关键条款抽取、业务法律问答、法规影响分析、政策/模板更新、外部 counsel memo review 等七类可自动化工作，并引用 2026 ACC CLO Survey：1,049 名 legal leaders 中 63% 预计团队规模不变、53% 把效率作为首要目标、35% 认为预算和资源有限是最大阻碍。
- 工程与产品分析：
  - 产品形态：Harvey 是法律/专业服务垂直 AI 平台。本周文章中的产品形态包括 grounded legal drafting、Microsoft Word 内写作、firm precedent/approved language 复用、custom agents 应用律所标准、合同/政策库批量分析和法律问答。
  - 工程架构：核心架构仍是“专有法律语料与组织知识 + 可追溯来源 + 人类律师最终审核”。brief writing 强调 citations trace directly to authority；workflow automation 强调每个 flagged deviation、extracted term、policy answer 都要能打开原 clause/source 验证。其风险控制不是让 AI 独立完成，而是把 blank-page work 变为 review/edit/verify work。
  - 生态/采用：文章提及 Harvey 可在 Microsoft Word 中起草，并面向 law firms 与 in-house teams；具体新客户、活跃用户、合同金额本周未公开。Harvey sitemap 显示 7月24日两篇内容为窗口内，平台/安全/solutions 页面在 7月22日更新但不是可确认产品公告。
  - 风险/限制：法律 AI 的关键限制是责任不可外包：律师仍需核验每个 citation/quotation、决定策略并对提交文件负责。通用模型的 hallucinated citations 在法律场景会直接引发制裁、声誉与保密风险；Harvey 的差异化也依赖高质量权威库、source linking、客户数据不用于公共训练等治理承诺。
- 关键数据：2026 ACC CLO Survey：1,049 名 legal leaders、63% 预计团队同规模、53% 首要目标为提高效率、35% 最大阻碍为预算/资源（[Harvey in-house workflows，2026-07-24](https://www.harvey.ai/blog/what-legal-workflows-can-in-house-teams-automate)）；brief writing 风险/产品说明（[Harvey legal brief writing，2026-07-24](https://www.harvey.ai/blog/ai-legal-brief-writing)）。本周新客户、定价、平台 benchmark 未公开。
- 原文链接：
  - [AI Legal Brief Writing: Faster Drafts, Stronger Arguments](https://www.harvey.ai/blog/ai-legal-brief-writing)
  - [What Legal Workflows Can In-House Teams Automate?](https://www.harvey.ai/blog/what-legal-workflows-can-in-house-teams-automate)
  - [Harvey sitemap 核验窗口内页面](https://www.harvey.ai/sitemap.xml)
- 影响判断：Harvey 本周没有“硬发布”，但两篇文章清楚显示垂直 agent 的商业化路径：把模型输出嵌到律师已有的核验、模板、案卷和办公文档中，而不是承诺全自动替代律师。其 ROI 叙事越来越像运营自动化：减少空白起草、批量阅读、重复问答时间，同时保留专业责任与 source-level audit。

### ServiceNow AI Agents
- 本周动态：本周未核验到 ServiceNow AI Agents 的重大公开产品发布；核验范围包括 ServiceNow 官网新闻/博客入口、AI agents 产品页、搜索结果与 ServiceNow Community Now Assist 条目。ServiceNow 官网多页在本环境下请求超时，能打开的原始 Community 页面只返回标题正文缺失；搜索发现的相关条目为“Beginning July 9, 2026, ServiceNow will begin rolling out third-party model providers as the default for out-of-the-box Now Assist skills and AI agents”，发布时间为窗口前 7月9日，属于背景而非本周动态。另有 careers 页面提到 ServiceNow SDK / Fluent APIs 正成为 Now Platform 上 agentic app development substrate，但招聘信息不能作为产品发布。故本期按“观察/静默”处理，不写入本周动态事实。
- 工程与产品分析：
  - 产品形态：ServiceNow AI Agents/Now Assist 面向 ITSM、CSM、HR、SecOps 等工作流自动化，核心仍是平台内 workflow + AI skills/agents。
  - 工程架构：窗口内未见可核验新增架构。窗口前背景显示 ServiceNow 正把第三方模型 provider 作为 OOTB Now Assist skills/agents 默认项，说明其 agent 层在模型供应上走多模型/托管 provider 路线。
  - 生态/采用：本周未公开新增客户或采用数字。ServiceNow 的优势在已有企业 workflow 数据与权限体系，但本周无新证据。
  - 风险/限制：官网可访问性与公开 changelog 透明度不足会影响外部研究复现；如果第三方模型成为默认，企业需关注数据驻留、模型供应商条款、审计日志与权限继承是否清晰。
- 关键数据：本周无重大公开动态；窗口前背景为 ServiceNow Community 条目称 2026-07-09 起逐步将第三方模型 provider 作为 OOTB Now Assist skills/AI agents 默认项（[Community 原始页，正文抓取受限](https://www.servicenow.com/community/now-assist-articles/third-party-model-providers-are-becoming-the-default-for-now/ta-p/3560810)）。新客户、定价、benchmark 未公开。
- 原文链接：
  - [ServiceNow Community: Third-party model providers are becoming the default...](https://www.servicenow.com/community/now-assist-articles/third-party-model-providers-are-becoming-the-default-for-now/ta-p/3560810)
  - [ServiceNow AI Agents 产品页（本环境超时，已尝试核验）](https://www.servicenow.com/products/ai-agents.html)
- 影响判断：本周 ServiceNow 在公开可核验层面偏静默。企业观察重点应放在 Now Assist/AI Agents 的模型 provider 切换是否带来新的合规、数据处理与采购条款变化，而不是把招聘或搜索摘要当成产品发布。

### Salesforce Agentforce
- 本周动态：Salesforce 本周有较强实质动态，围绕 Agentforce 的生产级工程与计费透明化。官方 Agentforce 页面显示“Over 18K companies already run on Agentforce”，并列举 OpenTable、SharkNinja、Indeed、Heathrow、Equinox、Fujitsu、Finnair 等客户故事入口；同时 FAQ 描述 Agentforce 通过 Atlas Reasoning Engine 分解 prompt、规划步骤、基于 CRM/Data 360/外部数据检索，并可通过 Flows、MuleSoft API、Apex/JavaScript 扩展。7月窗口内 Salesforce 发布 Indeed 案例，重点不是 demo，而是工程化：Indeed 在 IT support、sales、employer services、web portal 等多条生产 agents 中，把关键逻辑从大 prompt 移入 deterministic Agent Script，并通过 Headless 360 的 API/CLI/MCP 工作流在 Cursor 中构建、测试、部署，无需浏览器 UI。案例披露 Indeed 生产 agents 包括 Service Agent（web portal）、IT Help Agent（Slack）、SDR Agent（email）和 Spark Agent；Data 360 预处理 employer profiles、account status、flagged job metadata、support history，Agent Script 使用结构化数据做确定性路由。
- 工程与产品分析：
  - 产品形态：Agentforce 是 Salesforce 的 AI agent 平台，覆盖 customer service、contact centre、field service、employee service、sales service、IT service 等角色；企业可用低代码 Agent Builder，也可用 Headless 360/API/CLI/MCP 面向开发者构建。
  - 工程架构：Indeed 案例突出“LLM 负责柔性表达，关键决策走确定性代码”。Agent Script 负责状态变量、if/then routing、escalation packaging；MuleSoft 连接外部源；Data 360 提供预计算统一数据层；API 驱动的 ADLC skill 在 Cursor 中生成/测试/部署 agent 配置。Microsoft/Salesforce/Glean/Sierra 本周都指向同一趋势：production agents 需要 code-like lifecycle，不是 prompt-only。
  - 生态/采用：官方称超过 18K companies run on Agentforce；Indeed 有多个生产 agent，且“first agent took months, latest took weeks”，体现数据层与 headless 开发工具的复用收益。
  - 风险/限制：Agentforce 强绑定 Salesforce 数据/工作流生态，非 Salesforce 栈企业接入成本取决于 MuleSoft/Data 360。复杂逻辑下如果没有 Agent Script 这类确定性层，大 prompt A/B 会产生不稳定；同时计费按 action/conversation/user 组合，企业需用 Digital Wallet 管理消耗。
- 关键数据：超过 18K companies run on Agentforce（[Agentforce 产品页，本周核验](https://www.salesforce.com/agentforce/)）；Flex Credits：$500/100k credits，Agentforce action 20 credits、Voice action 30 credits，Conversations $2/conversation，Agentforce add-ons $125/user/month，Industries add-ons $150/user/month，Agentforce 1 Editions from $550/user/month，Agentforce User License $5/user/month requires Flex Credits（[Pricing](https://www.salesforce.com/agentforce/pricing/)）；Indeed 生产 agents 列表与 Data 360/Agent Script/Headless 360 架构（[Indeed Agentforce 案例](https://www.salesforce.com/blog/indeed-agentforce/)）。
- 原文链接：
  - [Agentforce: The AI Agent Platform](https://www.salesforce.com/agentforce/)
  - [How Indeed Builds, Tests, and Deploys Agents Without Ever Opening a Browser](https://www.salesforce.com/blog/indeed-agentforce/)
  - [Salesforce Agentforce Pricing](https://www.salesforce.com/agentforce/pricing/)
- 影响判断：Agentforce 本周最值得关注的是“headless + deterministic logic + MCP/API”的企业开发范式，而不是又一个客服机器人。Salesforce 把 agent 计费拆到 action/conversation/user，有利于采购和 ROI 测算，但也要求客户把 agent 动作粒度、Data 360 消耗与人工节省一起建模。

### Microsoft Copilot Agents
- 本周动态：Microsoft 本周没有在 7月20-26 发布可核验的 Copilot Agents 月度大版本（Microsoft Learn release notes 最新批次为 7月15，属于窗口前背景），但本周 GitHub Copilot CLI 有多项 agent/权限/沙箱相关更新，且 7月15 的 Microsoft 365 Copilot release notes 对企业 agent 治理有重要背景价值。Release notes 中的关键功能包括：Agent Builder 创建的 agents 可经 Microsoft 365 Admin Center 审核后发布到 Agent Store 的“Built by your org”；MCP-built agents 可在 Word、Excel、PowerPoint、Outlook、Catalyst 中访问；Federated Copilot Connectors（MCP-based connectors）可在 admin center Connectors tab 统一部署管理，使用 user-level authentication 在运行时访问外部数据，避免组织级索引并保留源权限；Confluence/ServiceNow connectors 支持 nested permissions。GitHub Copilot CLI 在 7月20/23/24 的 release notes 则体现 coding agent 基础工程：agentStop hook 连续阻塞 8 次后结束 turn、opt-in git/gh authentication inside OS sandbox、macOS keychain sandbox 默认关闭、command approvals 不跨 repo 继承、/mcp add/edit 保留 env var 中 = 以避免 token 破坏、支持 Open Plugin Spec v1 manifests 和 mcp.json、默认 sandbox first-run splash 等。
- 工程与产品分析：
  - 产品形态：Microsoft 365 Copilot Agents 面向 Office/企业知识/业务应用，GitHub Copilot CLI 面向开发者 coding agents；本周窗口内的硬更新主要在 GitHub CLI，M365 Copilot governance 属于 7月15背景。
  - 工程架构：M365 的方向是 Agent Store + admin approval + MCP/federated connectors + user-scoped runtime auth + nested ACL。GitHub CLI 的方向是 OS sandbox、repo-scoped approvals、MCP server lifecycle、plugin/skill management、hook 防死循环与秘密值保护。
  - 生态/采用：Microsoft 把 MCP agent 带入 Office apps，说明 MCP 已成为 M365 Copilot extensibility 的一等路径；GitHub Copilot CLI 同时支持 Open Plugin Spec 与 mcp.json，说明开发者 agent 工具生态正在向 manifests/config 标准化靠拢。
  - 风险/限制：M365 release notes 为 7月15，不应当作本周发布；本周 GitHub CLI 多为 pre-release/CLI 层更新。企业侧仍需关注 MCP connector 的 runtime auth 是否真正继承源系统 ACL、agent store 审核标准、以及本地 sandbox 与审批边界是否足以防 prompt/tool injection。
- 关键数据：M365 release notes 日期 2026-07-15，包含 Agent Store admin review、MCP agents in Office apps、Federated Copilot Connectors、nested permissions（[Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-365/copilot/release-notes)）；GitHub Copilot CLI releases：2026-07-20/23/24，Claude Opus 5、Open Plugin Spec v1、mcp.json、sandbox/auth/approval 修复（[GitHub releases](https://github.com/github/copilot-cli/releases)）。客户/定价本周未公开。
- 原文链接：
  - [Release Notes for Microsoft 365 Copilot](https://learn.microsoft.com/en-us/microsoft-365/copilot/release-notes)
  - [GitHub Copilot CLI Releases](https://github.com/github/copilot-cli/releases)
- 影响判断：Microsoft 的企业 agent 主题是“治理型扩展”：从 agent build 到 org catalog，到 MCP connector runtime access，再到 nested ACL。GitHub CLI 的沙箱/审批修复提醒企业：coding agents 的核心不是代码生成速度，而是 hook、approval、secret、repo boundary 这些基础安全边界。

### 字节 Coze / 扣子
- 本周动态：本周未核验到 Coze/扣子官方在 2026-07-20~07-26 发布重大产品公告或开源版本。核验范围包括 coze.com/coze.cn 开放文档入口、coze-dev/coze-studio GitHub releases 与 commits、中文公开搜索。Coze Studio GitHub 最新 release 为 v0.5.1（页面显示 2月5日），main commits 页面最新可见为 2026年4月，窗口内无 release；中文搜索结果多为行业盘点或第三方新闻，未提供 Coze/扣子原始公告全文，且部分为 2026-07-27 之后或泛泛提及“字节扣子/飞书 Agent/TRAEWork”竞争格局，不能写入本周动态。
- 工程与产品分析：
  - 产品形态：Coze/扣子是字节的一站式 AI Agent 搭建平台，Coze Studio 开源版本提供 bot/workflow/plugin/knowledge 等能力（本周无新变更）。
  - 工程架构：历史 release 可见其工程关注点包括 conversation isolation、knowledge OpenAPI、plugin header 传递、NATS EventBus、Pyodide sandbox、horizontal privilege 修复、SQL injection 修复、跨账号密码重置限制等，但这些均非本周。
  - 生态/采用：本周无官方新增客户/开发者数据。第三方行业文章称国产大厂桌面/办公 agent 竞争升温，但非原始来源。
  - 风险/限制：对企业采用而言，Coze Studio 的权限、插件调用、沙箱、知识库 API 与审计能力是关键；但本周没有可核验的新证据。使用第三方盘点容易把旧闻或猜测误写为动态，本期按静默处理。
- 关键数据：本周无重大公开动态；Coze Studio 最新可核验 release 为 v0.5.1，非本周（[GitHub releases](https://github.com/coze-dev/coze-studio/releases)）；官方开放文档入口本环境可打开但正文抽取不足（[coze.com docs](https://www.coze.com/open/docs/)、[coze.cn docs](https://www.coze.cn/open/docs/)）。客户、定价、benchmark 本周未公开。
- 原文链接：
  - [Coze Studio Releases](https://github.com/coze-dev/coze-studio/releases)
  - [Coze Studio Commits](https://github.com/coze-dev/coze-studio/commits/main/)
  - [Coze Open Docs](https://www.coze.com/open/docs/)
  - [扣子开放文档](https://www.coze.cn/open/docs/)
- 影响判断：Coze/扣子本周对外信息偏静默。后续若出现企业级 Agent 发布，应重点核验它是否补齐身份权限、插件安全、审计与私有化部署，而不仅是“低代码搭建 agent”的泛能力。

## 协议、工程与评测

### MCP 协议与工具生态
- 本周动态：时间窗内可核验的 MCP 动态主要来自生态采用而非官方稳定规范发布：Sierra 本周公开 MCP Gateway 工程复盘，展示企业内部如何把 MCP 作为统一工具/数据访问网关；GitHub Copilot CLI 在 7月23 支持 Open Plugin Spec v1 manifests 与 mcp.json configuration；Microsoft 365 Copilot release notes（7月15，窗口前背景）已把 MCP agents 接入 Office apps、Federated Copilot Connectors 纳入 admin center。官方稳定规范当前仍以 2025-06-18 为可用版本，定义 JSON-RPC、stateful connections、hosts/clients/servers、resources/prompts/tools，以及 sampling/roots/elicitation 等 client features；安全原则要求用户明确同意数据访问和工具调用，tool descriptions/annotations 应视为不可信。窗口内官方 servers repo 未见新 release，最新 v2026.7.10 属窗口前。
- 工程与产品分析：
  - 产品形态：MCP 正从“开发者接工具协议”变成企业 agent 平台的连接与治理基座；Sierra、Microsoft/GitHub 已把 MCP 用于内部 gateway、Office agents、federated connectors、CLI plugin config。窗口外背景：官方 GitHub releases 页面在 2026-07-28 标出下一版 RC，草案方向包括移除 protocol-level sessions/initialize handshake、转向 stateless request `_meta`、server/discover、subscriptions/listen 与 MRTR input_required；该信息不计入本周动态。
  - 工程架构：稳定版强调 JSON-RPC、capability negotiation、tools/resources/prompts；企业落地必须额外实现 auth、审批、审计、源系统 ACL 和运行时数据最小化。窗口外 draft 的 stateless 化若最终落地，会降低 session 粘性和缓存/负载均衡复杂度，但要求每次请求携带 capabilities、身份与 trace metadata。
  - 生态/采用：官方 servers repo 本周无 release（最新为 v2026.7.10，窗口前）；Sierra 内部 45 services/89% employees 是本周最强采用证据；Microsoft Office/M365 生态是平台级采用证据（窗口前背景）。
  - 风险/限制：MCP 本身不能强制安全原则，只规定 implementors SHOULD；tool descriptions 是潜在 prompt injection/权限误导面。协议草案变动大，企业不宜追 RC 前夜特性做生产依赖，应通过 version negotiation 与 gateway 适配层隔离。
- 关键数据：稳定规范 2025-06-18（[MCP specification](https://modelcontextprotocol.io/specification/2025-06-18)）；官方 releases 显示 2026-07-28 RC 为窗口外背景（[GitHub releases](https://github.com/modelcontextprotocol/specification/releases)）；draft changelog 变更清单（窗口外背景，[draft changelog](https://modelcontextprotocol.io/specification/draft/changelog)）；official servers 最新 v2026.7.10 非本周（[servers releases](https://github.com/modelcontextprotocol/servers/releases)）。
- 原文链接：
  - [MCP Specification 2025-06-18](https://modelcontextprotocol.io/specification/2025-06-18)
  - [MCP GitHub Releases](https://github.com/modelcontextprotocol/specification/releases)
  - [MCP Draft Changelog（2026-07-28 RC，窗口外背景）](https://modelcontextprotocol.io/specification/draft/changelog)
  - [MCP Servers Releases](https://github.com/modelcontextprotocol/servers/releases)
  - [Sierra MCP Gateway](https://sierra.ai/blog/building-sierras-mcp-gateway-an-engineering-iceberg)
- 影响判断：本周 MCP 的真实主线不是协议版本发布，而是企业平台开始把 MCP 当“工具治理接口层”。下一阶段竞争点会从“支持 MCP”转向“谁能把 MCP 变成带身份、审计、审批、缓存、trace 和 source ACL 的安全运行时”。

### Agent memory / context engineering
- 本周动态：本周没有单独的新标准发布，但 Glean、Sierra 两家都把 memory/context engineering 作为生产 agent 的核心工程主题。Glean 7月23日文章明确提出 raw transcripts 不是 durable memory，应把记忆分为 current step working state、workflow session summary、long-term facts，并只在相关时检索长期事实；还建议存储 validated plan、工具顺序、检索模式和预期输出，避免重复任务每次重新规划。Sierra MCP Gateway 文章则从企业内部知识上下文切入，指出上下文存在于 Slack、GitHub、Salesforce、data warehouse、production systems、internal docs 等多处，agent 若要高质量工作必须通过统一 gateway 安全访问，并用 mcp-gateway.md 作为 living design principles 文档要求 coding agents 每次任务前读取、任务后更新，提高 one-shot 成功率。
- 工程与产品分析：
  - 产品形态：memory/context engineering 不再只是长上下文或向量库，而是工作流状态、长期事实、权限过滤、工具检索、系统设计文档和计划缓存的组合。
  - 工程架构：Glean 的结构化 state 替代全文 transcript，Sierra 的 gateway 统一上下文源且加权限/审计；两者都强调在进入模型前减少噪声。对于企业 agent，context selection 必须 permission-aware，并且不同 workflow stage 需要不同 context，而不是全量塞进上下文窗口。
  - 生态/采用：Glean 面向企业知识栈，Sierra 内部 89% 员工使用 gateway 是采用证据；两者都未公开 memory 模块的独立定价。
  - 风险/限制：过度压缩记忆会丢失关键约束，过度保留 transcript 会增加成本和混淆；跨客户/跨团队上下文若无 provenance 与敏感性判定，容易泄露或错误复用。Glean/Sierra 都没有公开可复现 benchmark 来量化这些架构的收益。
- 关键数据：Glean 7月23提出 token/context scorecard 与三层 memory；Sierra 7月22/23披露 45 services、89% 员工使用、mcp-gateway.md living doc（链接见上）。独立 memory benchmark 未公开。
- 原文链接：
  - [Glean: How to optimize token efficiency in agentic systems](https://www.glean.com/blog/how-to-optimize-token-efficiency-in-agentic-systems)
  - [Sierra MCP Gateway](https://sierra.ai/blog/building-sierras-mcp-gateway-an-engineering-iceberg)
- 影响判断：企业 agent 的“记忆”正在从模型能力变成平台工程能力：状态压缩、权限过滤、检索路由、计划缓存、设计文档维护共同决定成功率与成本。采购时应要求供应商解释 memory 的来源、保留周期、权限继承、删除机制和审计，而不是只问上下文窗口大小。

### Sandbox / permission / identity / audit / observability
- 本周动态：本周安全治理线索非常集中。Sierra 明确区分 interactive work runs as the user，scheduled/shared workflows run as least-privilege service accounts；跨客户敏感数据访问通过候选客户识别、多模型敏感性判定、out-of-band approval 与 audit log 控制。Salesforce/Indeed 案例把关键决策从 LLM prompt 抽到 Agent Script 确定性逻辑，并让 escalation 始终打包 conversation history、summary、employer profile 给人工，便于归因与运营指标。Microsoft/GitHub Copilot CLI 7月20更新了 sandbox/approval 边界：agentStop hook 连续阻塞不再无限循环、git/gh auth 需 opt-in 进入 OS sandbox、macOS keychain access 默认关闭、command approvals 不随 /cd 跨 repository 继承、删除 MCP server 停止后台进程、SSO 可被 managed settings 强制。
- 工程与产品分析：
  - 产品形态：治理能力正在成为 agent 平台的一等功能，覆盖用户身份、service account、审批、sandbox、secret masking、MCP server lifecycle、escalation packaging 与 usage wallet。
  - 工程架构：最佳实践是多层防线：运行身份最小化，工具/数据按会话或任务预授权，敏感访问写审计日志；可变业务逻辑用代码/脚本固定关键分支；工具调用必须等待下游确认；本地开发 agent 需 sandbox、repo-scoped approval 与 hook termination。
  - 生态/采用：Sierra、Salesforce、Microsoft/GitHub 分别从 CX platform、CRM platform、developer tooling 给出同方向证据。Agentforce Digital Wallet 还把 observability 扩展到近实时 credit 消耗与阈值告警。
  - 风险/限制：如果审计只记录最终回答而不记录 tool inputs/outputs、身份与审批链，事故后无法归因；如果 approvals 跨 repo/跨 session 继承，会形成权限漂移；如果 service accounts 权限过宽，离职/转岗后自动化可能静默继续运行。
- 关键数据：Sierra 45 services/89% employees；Agentforce Pricing 中 Digital Wallet 近实时 consumption/threshold alerts；GitHub Copilot CLI 7月20/23 release notes 多项 sandbox/approval/MCP lifecycle 修复（链接见上）。
- 原文链接：
  - [Sierra MCP Gateway](https://sierra.ai/blog/building-sierras-mcp-gateway-an-engineering-iceberg)
  - [Salesforce Indeed Agentforce 案例](https://www.salesforce.com/blog/indeed-agentforce/)
  - [GitHub Copilot CLI Releases](https://github.com/github/copilot-cli/releases)
  - [Agentforce Pricing / Digital Wallet](https://www.salesforce.com/agentforce/pricing/)
- 影响判断：本周最重要的企业共识是：agent 不是“一个更聪明的用户”，而是需要独立身份模型和审计面的执行体。未来 RFP 中应把 sandbox、approval scope、service account lifecycle、tool-result audit、credit observability 列为硬指标。

### SWE-bench / OSWorld / WebArena / GAIA / τ-bench / Agent 安全红队论文
- 本周动态：评测对象中，时间窗内最有料的是 τ-bench/τ³-bench 的 1.0.1 grading update；其他固定 benchmark 本周未核验到重大新版本。τ²/τ³-bench GitHub README 明确 2026年7月 v1.0.1 修复 banking_knowledge 任务错误，导致该 domain 分数变更，tau2-bench <1.0.1 与 >=1.0.1 不可比较；CHANGELOG 标明 1.0.1 日期为 2026-07-15，属窗口前发布但本周仍是评测采用/重算重点。Release notes 给出重评影响：gpt-5-5 banking_knowledge pass^1 37.37→46.39（+9.02），gpt-5-4 30.67→39.43（+8.76），gpt-5-2 24.74→32.22（+7.48），多个模型 upward flips，且 no simulation flipped from pass to fail；核心原因是 extra read calls 曾被写入 DB-hash reward 比较，使谨慎验证读也零分。SWE-bench 官方主页本周无可抽取重大更新；OSWorld 页面显示 2026-06-26 OSWorld 2.0 可用，非本周；WebArena 首页仍是 benchmark suite 索引，未见本周变更；GAIA HuggingFace leaderboard 可打开但未显示本周更新；Agent 安全红队/安全论文方面，τ³ task fixes 引用 SABER（Small Actions, Big Errors）作为任务修复依据，但 SABER 属窗口外/背景，未见本周新安全红队论文可核验。
- 工程与产品分析：
  - 产品形态：τ-bench/τ³-bench 聚焦 customer service agents 的 tool-agent-user interaction，包含 text half-duplex、voice full-duplex、banking knowledge retrieval、airline/retail/telecom 等域；SWE-bench 测代码修复，OSWorld 测真实桌面环境，WebArena 测 Web 任务，GAIA 测通用助理推理。
  - 工程架构：τ³ 的 1.0.1 说明 benchmark 本身需要像生产系统一样做 reward audit：额外 read 不应惩罚谨慎 agent，numeric args 需规范化，任务 gold trajectory 必须 agent-realizable，工具输出顺序需与知识文档一致。OSWorld 仍强调 execution-based evaluation scripts 与 369/361 tasks；WebArena 生态扩展到 WebArena-Infinity、VisualWebArena、TheAgentCompany。
  - 生态/采用：τ-bench 有 leaderboard、trajectory visualizer、S3-hosted submissions；OSWorld 2.0 已上线但非本周；SWE-bench 仍是 coding agent 主流榜单但本周无新 release。
  - 风险/限制：benchmark 分数可因任务/评分修复大幅漂移，企业不能跨版本比较 ROI 或模型能力；τ-bench banking_knowledge 的 pass^1 上调最多 9 点说明“评测噪声”足以改变排名。OSWorld/GAIA 等网页榜单动态内容较多，需通过官方 changelog/GitHub 数据确认日期。
- 关键数据：τ-bench v1.0.1 日期 2026-07-15，banking_knowledge scores not comparable；gpt-5-5 pass^1 37.37→46.39，pass^4 20.62→27.84；gpt-5-4 pass^1 30.67→39.43；额外 read logging fix 是主要影响（[CHANGELOG](https://raw.githubusercontent.com/sierra-research/tau2-bench/main/CHANGELOG.md)、[RELEASE_NOTES](https://raw.githubusercontent.com/sierra-research/tau2-bench/main/RELEASE_NOTES.md)）。OSWorld：2026-06-26 OSWorld 2.0 可用、原 OSWorld 369 tasks/361 excluding 8 Google Drive tasks（[OSWorld](https://os-world.github.io/)）。WebArena suite 索引（[WebArena](https://webarena.dev/)）。
- 原文链接：
  - [τ²/τ³-bench GitHub](https://github.com/sierra-research/tau2-bench)
  - [τ-bench leaderboard site](https://taubench.com)
  - [τ³-Bench: Fixing Airline + Retail](https://taubench.com/blog/tau3-task-fixes.html)
  - [SWE-bench Leaderboards](https://www.swebench.com/)
  - [OSWorld](https://os-world.github.io/)
  - [WebArena-x](https://webarena.dev/)
  - [GAIA HuggingFace leaderboard](https://huggingface.co/spaces/gaia-benchmark/leaderboard)
- 影响判断：本周评测最大启示是：agent benchmark 的“正确答案”和“副作用评分”必须可审计，否则会惩罚真实生产中应有的谨慎验证行为。企业用 benchmark 做选型时，应记录 benchmark version、task split、grading commit、是否 re-scored，并避免把窗口外榜单刷新误读为模型真实跃迁。

## 下周观察点

1. Claude Code / Codex / Cursor 的多代理与模型路由是否继续向企业策略、预算和审计层开放。
2. browser-use、Manus、Comet、OpenAI Work/Presence 在浏览器登录态、支付字段、录屏、OAuth scope 上是否给出更清晰的默认安全策略。
3. Sierra、Glean、Salesforce、Microsoft 是否把 identity、MCP connector、deterministic script 和 Digital Wallet 变成企业 Agent RFP 的标准条目。
4. Dify、AutoGen、ADK、LlamaIndex、OpenHands 等观察池项目是否出现新的 release、生产采用或安全治理更新。
5. SWE-bench、τ-bench、OSWorld、WebArena、GAIA 是否出现带日期、轨迹和 grading commit 的新提交；没有可复现证据时不把旧榜单当本周跃迁。

## 关于本周报

本周报聚焦 Agent 产品、开源项目、框架工具、CLI/IDE、协议标准、评测基准、企业落地和开发者生态。它不按 GitHub 热度排序，而按“工程影响力 × 采用信号 × 生态位置 × 可靠性突破 × 新颖度”筛选。时间窗外旧闻只作背景，不计入本周动态。
