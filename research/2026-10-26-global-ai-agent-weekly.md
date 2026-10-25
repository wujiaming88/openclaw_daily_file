# 全球 AI Agent 研究周报 · 第 21 期 研究母稿（2026-10-19 ～ 2026-10-25）

> 本期：2026-10-19 ～ 2026-10-25（Asia/Shanghai 完整自然周，上周一 00:00 → 上周日 24:00）。期次：第 21 期。
> 定位：Agent 产品 + 开源项目 + Agent 工程生态。run_id: e0de9bad-34c7-4686-a0e5-f6189f218841。
> 研究分工（唯一主责）：A 组编码 Agent/CLI/IDE；B 组开源 Agent 框架与项目（Hermes 唯一主责）；C 组浏览器/Computer Use/通用自主 Agent；D 组企业垂直 Agent + 协议/评测/基础工程。四组串行派发，黄山（wairesearch）执行。
> 读者定位：R1 最新技术与产品动态（主责）+ R2 Agent 侧落地（协同）。
> 准出依据：industry-research-evidence（逐主张分级 A/B/C/D）；事实、数据、来源与矛盾处置见各组「关键数据」「原文链接」「覆盖与取证审计」节。
> 规则版本：cron-run-reliability/SKILL.md `f2883810…`、research-contract.md `b76f66f6…`、industry-research-evidence/SKILL.md `bf9febbb…`、weekly-agent-report.md `e18d97f3…`、_reader-positioning.md `b9afd6e1…`。

## 一、本期概览

本期是「边界周」：增量主要不在模型能力，而在 **权限、自治等级、故障恢复、身份凭证、记忆与审计**。两组事实同时成立——编码 Agent 一侧在密集收紧沙箱与权限判定（Claude Code 窗口内 6 个版本几乎全为权限/沙箱修复；Codex 把企业 MCP 授权与凭据遮蔽放进同一版；Antigravity CLI 把「用户最新指令」交给 hook 以便审查），而通用/生产侧在反向放开自治（Replit Monitoring Agent 可自动修复并 auto-publish 到生产；Claude Duet 让 Agent 默认先开口找你）。行业尚未形成统一的自治等级标准，这正是本期最有信息量的信号。

## 二、TOP5 候选（按工程影响力 × 采用信号 × 生态位置 × 可靠性突破 × 新颖度）

1. **Anthropic Claude Duet 研究预览（2026-10-21）** — 通用 Agent 的默认发起权从人转向 Agent：独立 app + 云 VM 自带浏览器，晨间简报 + 周期性巡检；不可逆动作（发消息/付款/签约/删除）必须展示待执行动作并等待批准，证券交易为硬红线；底座 Claude Opus 5.5，美国 Pro/Max waitlist 放量，额度共用。10-23 补发安全/隐私专文。局限：当前不能展示浏览器画面（审计只能靠日志与审批卡），个人琐事场景弱。[claude.com](https://claude.com/resources/articles/claude-duet)
2. **Harvey Graph（窗口内，法律垂直 Agent）** — 企业垂直 Agent 的竞争从「模型多强」转向「开工前知道多少」：知识图谱（全美判例）+ 上下文图谱（按 Space 组织、继承伦理隔离），运行时多跳检索。公司自述 LAB 实验 rubric +30%、成本 −50%；某 firm-knowledge 任务无图 0% vs 有图 75%。属公司自建评测（B 级披露）。[harvey.ai](https://www.harvey.ai/blog/improving-agent-accuracy-with-harvey-graph)
3. **ServiceNow Arc GA + NVIDIA OpenShell（2026-10-21，GTC Berlin）** — 企业 Agent 治理下沉到运行时与硬件：Arc 给目标不给步骤、本地优先推理、不单独收费（随 EmployeeWorks 三档 SKU）；OpenShell 提供软件/硬件层「数秒内撤销」。**关键限定：1 秒级撤销与「硅上执行」所依赖的 AI Passport 属未来版本**（官方可用性段落写「expected to be available in a future release」），采购应按「已 GA 的策略执行」验收。[explainx 全文核对](https://explainx.ai/blog/servicenow-arc-ga-personal-enterprise-agent-nvidia-openshell-ai-passport-revocation-one-second-2026)
4. **编码 Agent 的权限与自治边界周** — Claude Code 窗口内 6 版（2.1.304→2.1.310，含 Monitor 工具与企业多云支持、大量沙箱/权限绕过修复）；Codex rust-v0.164.0 把企业 MCP 授权、远程会话凭据遮蔽、Bedrock 向导放入同一版；Antigravity CLI 1.4.7 给 hook 增加 `lastUserInput`；Replit Monitoring Agent（10-22）反向把自治推到「自动改生产并发布」。同一周内一边收紧一边放开，是自治等级尚未标准化的直接证据。
5. **OpenClaw v2026.10.6 / v2026.10.7 + Hermes 迁移（开源运行时与生态位重排）** — OpenClaw 把「Agent 运行时 = 有状态服务」做实：强制 Node 安全版本（修复被攻陷证书密钥签发的 TLS 链）、恢复来源标记与幂等重放、截断写保留 last-known-good、补丁部分失败回滚。同周 Hermes v0.22.5 上线 `hermes import-agent` 与 OpenClaw 迁移路径，并做 core→plugin 剥离；AutoGen 官方宣布归档、转向 Agent Framework。开源框架的「迁移成本」正被当竞争武器使用。

候选（未入 TOP5 但具生态含义）：OpenCode v2.1.4 的 `metadata.keepID` 引用式压缩（上下文工程可复用范式）；AutoGen 归档 → Microsoft Agent Framework；Ivo×micro1 ContractBench（7 个前沿模型全部 <60%，瓶颈在交付完整性与单件成本）；AfterDeleteBench / Post-Audit Mirage（记忆删除与离线审计的原理性结论）。
## 三、产品 / 工程 / 商业化主线（本期）

**产品主线一：通用 Agent 的默认发起权反转到 Agent 一侧。** Claude Duet（10-21）主动推送简报并周期性巡检，只在「需要你」时开口；智谱 AutoClaw（澳龙，10-21）把高权限本地 Agent 做成消费级安装包（50+ 技能、飞书集成、自进化「进化请求卡片」需人工审批后写入长期记忆）。两者同周印证同一件事：审批粒度与记忆治理，已经比任务成功率更决定能否真用。对照面：OpenAI 关停 Atlas 后把能力并入主应用 + Chrome 扩展 + 主动助手（背景，非本周），说明「自建浏览器壳」价值下降。

**产品主线二：编码 Agent 从「写代码」走向「对运行中的系统负责」。** Replit Monitoring Agent 让 Agent 读生产日志/指标→定位→验证→auto-publish；Claude Code 的 Monitor 工具与 cloud session 把长时任务接进企业权限模型；Cursor、Devin Desktop、Antigravity 把终端入口统一为「指挥台 + 云执行」。竞争点从补全质量转向可审计、可回滚、权限分级。

**工程主线一：权限与自治分级。** AutoGPT block 级 effect 声明 + 按动作代价分级审批（廉价外向动作自动、昂贵动作先问）；Agent Framework 把 Docker 参数改名 `unsafe_extra_run_args` 并把信任要求写进命名、AG-UI 端点必须显式声明授权 scope；Dify v1.18 给本地 Agent sandbox 强制高熵认证 token；OpenAI Agents SDK 禁止工作区操作加载启动文件。方向一致：谁批准、边界在哪，正在成为可比较的工程契约。

**工程主线二：故障恢复与状态一致性成为一等能力。** OpenClaw 的恢复来源/幂等重放/截断写保护；Codex 修「压缩失败残留半截摘要」与「排队 prompt 越过未决权限」；Claude Code 修「压缩后仍保留过多 base64/SVG」；LangGraph 修 `RemoteGraph.stream(subgraphs=True)` 的 namespace 归属与显式 `recursion_limit`；OpenHands 把 condenser/verification/model router 收进 profile。共同点是长会话的状态机可靠性。

**工程主线三：上下文从「检索」升级为「结构 + 策略客体」。** Harvey Graph 用图 + 权限继承替代 flat retrieval；OpenCode 把压缩摘要改为引用 `metadata.keepID`；Google ADK 用小型分类器（Jev/TypeSafe）替代 LLM 做路由并引入 MongoDB 关键词记忆；Dify 让 Agent 选工作流分支。策略被搬进可配置对象，也意味着错误配置成为新的主要故障源。

**商业化主线：从「席位」到「托管生产」与「治理品类」。** Sierra 的 results-based 计费、Replit 的托管运维、ServiceNow 把身份凭证/执行边界/可撤销性做成产品（Workday 收购 ConductorOne 同向）；同时开源框架被大模型厂商当作分发渠道（AutoClaw 基于 OpenClaw 封装），本地 Agent 落地摩擦从「配环境」降到「装软件」。

## 四、开源生态雷达（本周）

| 项目 | stars（2026-10-26 快照） | 本周信号 |
|---|---|---|
| OpenClaw | 393,049 | v2026.10.6/10.7：运行时安全基线 + 可回放恢复 |
| Hermes Agent | 257,040 | v0.22.5：core→plugin 剥离、`hermes import-agent` 迁移 OpenClaw、可切换委派 |
| OpenCode | 221,485 | v2.1.4：`native` 契约合并、keepID 引用式压缩（破坏性 SDK 变更） |
| AutoGPT | 187,749 | beta v0.9.0：block 级 effect + 按代价分级审批 |
| browser-use | 119,117 | 运行记录可在不逐步调用模型下重放 |
| OpenHands | 91,819 | 4 天 5 版：Agent Profile 成为一等配置对象 |
| Cline | 70,836 | 窗口内无发版（观察） |
| CrewAI | 60,095 | 1.15.29：AgentExecutor 转正、离线路由与本地评估 |
| Microsoft AutoGen | 61,559 | 官方宣布归档（API `archived=false`，标志未同步）；继任 Agent Framework |
| Aider | 49,750 | 长期无新版（静默，最新 0.86.2 / 2026-02） |
| LangGraph | 43,883 | 1.2.17：namespace 与 recursion_limit 正确性修复 |
| browser-use / LlamaIndex / MetaGPT / SuperAGI | 52,662（LlamaIndex）等 | 文档级提交或长期停滞 |

说明：stars 为 2026-10-26 取得时快照，本期无跨期快照，不报周增速；热度不作为价值判断。

## 五、Agent 产品雷达（本周）

- **有料**：Claude Duet（通用主动型）、智谱 AutoClaw（本地桌面）、Claude Code、Codex、OpenCode、Devin Desktop、Replit Agent、Gemini CLI→Antigravity CLI、Harvey Graph、ServiceNow Arc。
- **结构性事件**：Gemini CLI 消费线迁往 Antigravity（企业线保留）；Windsurf 更名 Devin Desktop；Roo Code 归档；AutoGen 归档。
- **观察**：Cursor（窗口内无更新，10 月发布节奏放缓）、Cline（无发版）、OpenAI Operator/ChatGPT Agent（release notes 正文截断，未取得 10 月条目）、Google Mariner/Gemini Agent、Salesforce Agentforce。
- **静默**：Aider、Sierra、Glean、Microsoft Copilot Agents、字节 Coze、Perplexity Comet、Manus、Genspark、Kimi、Qwen、LlamaIndex、MetaGPT、SuperAGI、SWE-bench/OSWorld/WebArena/GAIA/τ-bench（未见窗口内新纪录）。
# A组｜编码 Agent / CLI / IDE 产品 — 2026-10-26 期（窗口 2026-10-19 00:00 ～ 2026-10-25 24:00 Asia/Shanghai）

> 研究：黄山（wairesearch）。run_id: e0de9bad-34c7-4686-a0e5-f6189f218841
> 取证方式：官方 changelog / GitHub 认证 GET（gh api，login=wujiaming88）/ 官方博客原文；搜索默认 serper，正文深读 tavily 或 web_fetch，逐条在「关键数据」标 URL 与日期。

### Claude Code（Anthropic）
- 本周动态：窗口内连发 6 个版本（2.1.304→2.1.310，npm 发布时间 10-19 19:47Z 至 10-23 21:20Z），是本期更新密度最高的编码 Agent。2.1.310 新增 Monitor 工具与 plugin monitors，且明确在 Bedrock、Vertex、Foundry 以及「遥测/非必要流量被禁用」的环境中同样可用，同时禁止长时间前台 sleep——这等于把「后台盯任务」从交互式终端能力下推到企业私有云通道。2.1.309 是一版典型的安全硬化：修掉 macOS/Linux 沙箱在执行每条命令前于沙箱外读取 shell 启动文件、`denyWrite` glob 经符号链接失效、沙箱命令可改写 `--mcp-config` 指定文件、Bash 权限检查信任可能重定向失败的变量、`cd` 包裹/前缀绕过复合命令确认、worktree 隔离会话接受 locale 前缀命令等一串提权面。2.1.307 把 `/claude-api` 的 api-version 迁到 `2026-10-21`；2.1.310 又把 Managed Agents 子代理团队切到 `multiagent_20261001` 契约、动态 workflow 默认开启。此外 Cloud sessions 与 Remote Control 被纳入 Enterprise 自定义角色权限，管理员开启时需确认并列出受影响角色。
- 工程与产品分析：
  - 产品形态：终端 + VS Code 扩展 + 桌面/云会话三形态并行；本周主线不是「更会写代码」，而是把长时任务（Monitor、cloud session、routine）与企业权限模型接上，让 Agent 从「会话内助手」变成「可被组织治理的后台执行体」。
  - 工程架构：沙箱（bubblewrap/seatbelt）+ worktree 隔离 + hooks（PreToolUse/PermissionRequest）+ MCP elicitation 四层权限面同时在被收紧；上下文侧修「Prompt is too long 后压缩仍保留过多 base64/SVG」与超大嵌套 CLAUDE.md 反复压缩，说明其瓶颈已从模型能力转向上下文与状态机可靠性。
  - 生态/采用：MCP、plugin、skill、Code Review、Claude Tag（Slack）构成外围生态；Bedrock/Vertex/Foundry 同步支持 Monitors，说明企业多云是本周发版的第一优先级。
  - 风险/限制：单周 6 个 patch 版本、changelog 中大量「Fixed ... bypass/permission」条目本身即说明权限判定仍在高频打补丁；`sed -i` 改为标准 Bash 且不再被 `/rewind` 还原，属于行为变更，依赖回滚的工作流需重测。
- 关键数据：2.1.310（2026-10-23T21:20Z，npm registry `@anthropic-ai/claude-code` time 字段）；2.1.309（10-22）；2.1.307 api-version `2026-10-21`；窗口内 6 个版本。来源：[CHANGELOG.md](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)（2026-10-25 读取）、[npm registry](https://registry.npmjs.org/@anthropic-ai/claude-code)。
- 原文链接：https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md
- 影响判断：Claude Code 正把竞争点从「模型+harness」转向「企业可控的后台执行 + 权限可审计」。短期看这是对 Codex 云任务和 Cursor Cloud Agents 的正面回应；中期看，谁先把沙箱/权限/hooks 做成稳定契约，谁就更容易进受监管企业。

### OpenAI Codex / Codex CLI
- 本周动态：`rust-v0.164.0` 于 2026-10-23 发布（04:48Z），同日推出 `0.165.0-alpha.1`，窗口内还有 0.164.0-alpha.9/10/11/11.1/12 等一串预发布。0.164.0 的功能项指向「可复用工作流 + 企业接入」：新增 10 个编号 `/presets` 槽位保存可复用 prompt 与 slash command，配键盘菜单；`/model`、`/permissions` 支持内联参数直接设定模型、reasoning effort、speed 与权限档；Kitty/Sixel 终端可全屏预览查看与生成的图片；企业 MCP 连接可用 Codex 账号授权或专用登录（含需要 secret 的 OAuth client）；远程 Bash 与 Zsh snapshot 会话会遮蔽凭据（含自定义 provider 的凭据）；Bedrock 配置向导默认开启。修复侧集中在压缩失败残留半截摘要、恢复会话时用全局默认覆盖已存 thread 设置、Windows 代理认证（Negotiate/NTLM）、多级 `-c/--config` 覆盖丢失、排队 prompt 越过未决权限选择继续执行，以及 macOS 大小写变体元数据路径与可替换符号链接的沙箱校验。
- 工程与产品分析：
  - 产品形态：Rust 实现的 CLI + TUI，向「可脚本化、可预设、可多人/多机复用」演进；presets 与内联权限参数是为高频团队工作流服务的，而不是演示型功能。
  - 工程架构：企业 MCP 认证 + 凭据遮蔽 + Bedrock 向导三件事放在同一版，说明 Codex 的企业落地路径是「自带云账号 + 自带 IdP」，而非只走 OpenAI 托管；沙箱校验开始处理 macOS 大小写不敏感文件系统与可替换 symlink，属真实逃逸面。
  - 生态/采用：MCP 企业授权、Guardian（安全审查线程）、app-server daemon、subagent threads 均已存在于代码库与 release notes，表明 Codex 已是「daemon + 多前端」架构，CLI 只是其中一个前端。
  - 风险/限制：同日仍发 alpha，稳定版节奏约每周一次，企业需自建版本钉扎；「排队 prompt 等待权限选择」这类修复说明并发交互下仍可能绕过人工确认，属需回归测试的高风险面。
- 关键数据：rust-v0.164.0 published_at 2026-10-23T04:48:10Z；0.165.0-alpha.1 2026-10-23T14:09:53Z。来源：[GitHub Releases API](https://github.com/openai/codex/releases)（2026-10-25 认证 GET）。
- 原文链接：https://github.com/openai/codex/releases/tag/rust-v0.164.0
- 影响判断：Codex 的差异化正在从模型转向「企业身份 + 云账号 + 守护式审查」的工程外壳，与 Claude Code 的企业权限路线正面撞车。下一步看 presets/Guardian 是否形成可共享的团队资产格式，那会决定它能否沉淀组织级工作流。
# A组 分片 02 — Cursor / Google Gemini CLI & Antigravity CLI

### Cursor
- 本周动态：**本周（10-19～10-25）无重大公开产品更新**。核验范围：官方 changelog 首页（读于 2026-10-25）、第三方聚合 changelog 全量列表（monthly 聚合，含 10/13、10/16 条目）。最新三条公开更新为 2026-10-16「Cloud Agent Canvases and Environment Improvements」（cloud agent 可生成交互式 canvas，Environments API 管理环境，最多 300 个仓库）、2026-10-13「Origin App Marketplace」、2026-10-06「Remote control for local agents」，均在窗口之外，只作背景不作本周动态。背景（非本周）：9-10 上线 Projects（协调者 Agent 不写码，只规划与分派，可并行上千 subagent，Project 级共享上下文跨云/本地同步，支持 Slack 频道订阅与定时触发）；9-2 上线 self-hosted machines（工具执行完全留在客户网络）。这说明 Cursor 本周处于 9—10 月密集发布后的整理期，而非停更。
- 工程与产品分析：
  - 产品形态：从 IDE 转向「Agents Window + Cloud Agents + iOS 远程控制」多端指挥台；Projects 把交互单位从「一次会话」提升为「持续数月的工作体」。
  - 工程架构：coordinator/subagent 两层、Project 共享上下文文件、cloud 机器 + 本地 agent 混合执行、Origin 代码托管与 App Marketplace（app JWT + installation token + webhook 写回 check run/PR 评论）构成平台化闭环。
  - 生态/采用：Marketplace 首批 20+ 集成（Cloudflare、Vercel、CircleCI、Sentry、Linear、Semgrep、Socket 等），并把提交口开放给第三方，是在抢「Agent 工具分发入口」。
  - 风险/限制：Remote Control 默认开启（Enterprise 除外），本机需保持开机联网，等于把本地 agent 暴露为可远程下指令的执行端，企业需在 Org 设置里显式管控；Projects 仍是 beta，coordinator 大规模并行 subagent 的成本与失败恢复未公开数据。
- 关键数据：最新公开更新 2026-10-16（[Cursor changelog](https://cursor.com/changelog)，读取 2026-10-25）；10 月仅 3 条更新（[thismonthinai 聚合](https://thismonthinai.com/updates/cursor)）；Projects 上线 2026-09-10。
- 原文链接：https://cursor.com/changelog/projects
- 影响判断：Cursor 的竞争重心已从编辑器补全转到「云端多 Agent 编排 + 应用市场」。本周静默不改变趋势判断，但需注意其在 10 月发布节奏明显放缓（3 条 vs 月均 5.6 条，据第三方聚合），下一步看 Projects 何时转 GA 与定价。

### Google Gemini CLI / Antigravity CLI
- 本周动态：Google 的编码 CLI 主线已在 2026-05-19 官方宣布迁移——Gemini CLI 与 Gemini Code Assist IDE 扩展于 2026-06-18 起停止为 Google AI Pro/Ultra 及个人免费版提供服务，统一到 Antigravity（桌面 Antigravity 2.0 + Go 编写的 Antigravity CLI，共享同一 agent harness，保留 Agent Skills、Hooks、Subagents、Extensions→plugins）。企业侧不变：持 Gemini Code Assist Standard/Enterprise 或经 Google Cloud 使用 GitHub 版的客户继续获得 Gemini CLI 更新。窗口内两条线都在动：Gemini CLI 于 10-20 发布稳定版 v0.65.0（npm 时间 2026-10-20T21:26Z），内容以安全与状态机修复为主——不可信目录强制只读 workspace 设置、OAuth 回调按 RFC 9207 校验 iss、快速 Ctrl-C 中断导致 session poisoning、恢复会话时重复 tool response、退出时误删 resumed 会话历史、重新选择 Google 登录未清缓存凭据。Antigravity CLI 则在 10-20 至 10-24 连发 1.4.3→1.4.7 五个版本；1.4.7（10-24）给 hook 的 stdin JSON 增加 `lastUserInput`，使 hook 能在 Agent 行动前审查用户最新指令；按需加载的 MCP 工具结果直返上限从 4KB 提到 10KB；`-p` headless 大幅降 CPU；修复 ADC 登录下 skills/rules/plugins/hooks 不加载、单条超大消息导致反复压缩、macOS/Windows keychain 存不下大 token 导致登录丢失，以及同机不同用户共用 OAuth token 的隔离缺陷。
- 工程与产品分析：
  - 产品形态：Gemini CLI 从消费级主力降为「企业维护轨道」；Antigravity CLI 承接多 Agent 异步编排（后台跑大型重构，不锁终端），与桌面端共用 harness。
  - 工程架构：Go 重写换启动与渲染性能；hook 拿到 lastUserInput 等于把「提示词审查/防注入」下放到 hook 层，是可审计的治理点；MCP 按需加载 + 10KB 直返是在压上下文与往返次数。
  - 生态/采用：官方披露 Gemini CLI 累计 10 万+ GitHub stars、6,000+ 合并 PR；企业客户走 Gemini Code Assist 授权不变，形成「消费迁移、企业留守」的双轨。
  - 风险/限制：迁移非 1:1 功能对等（官方明说）；两套 CLI 并存会让企业文档与插件生态分裂；本周修复集中在凭据隔离与 session poisoning，说明多用户/多账号场景仍有安全债。
- 关键数据：Gemini CLI v0.65.0 2026-10-20；v0.64.0 2026-10-13；Antigravity CLI 1.4.7 2026-10-24T02:47Z（1.4.3 起 10-20）。来源：[Gemini CLI releases](https://github.com/google-gemini/gemini-cli/releases)、[npm registry](https://registry.npmjs.org/@google/gemini-cli)、[Antigravity CLI releases](https://github.com/google-antigravity/antigravity-cli/releases)、[官方迁移公告 2026-05-19](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/)。
- 原文链接：https://github.com/google-antigravity/antigravity-cli/releases/tag/1.4.7
- 影响判断：这是本期最重要的结构性变化——Google 把编码 Agent 的终端入口并入 Antigravity 平台，用 Go + 共享 harness 换性能和统一。对企业而言，短期「Gemini CLI 还能用」成立，但新能力会优先落在 Antigravity；采购时应按「平台绑定」而非「单 CLI」评估。
# A组 分片 03 — OpenCode / Cognition Devin Desktop（原 Windsurf）

### OpenCode（anomalyco/opencode）
- 本周动态：v2.1.4 于 2026-10-23 发布（窗口内），两个 Highlight 都指向「长会话可用性」：其一，MCP server 在 tool call 中请求输入时，客户端现在直接弹出表单（支持 text/number/choice/multiselect/boolean/URL，桌面与 web 均可），而不是让调用一直等到超时；其二，新增实验性 `experimental.background_compaction`，会话接近压缩阈值时后台预生成摘要，避免自动压缩时同步等待——官方同时明确提醒「从未被使用的摘要仍消耗 token」。同版还改了压缩策略：压缩请求超 provider 上限时，先裁旧 tool output 与旧对话，而不是整体失败。更关键的是 2.1 版本是一次**公开契约变更**：SDK、HTTP message/event、plugin 三处统一把 provider replay 数据字段改为 `native`（原 `state`/`providerState`/`resultState`），tool call 与 result 合并为单一 `tool.native`，`Credential.Key.configuration` 移除、改写入 `metadata`，summary compaction 不再复制扁平文本而改用 `metadata.keepID` 引用首条保留消息，`providerContext` 迁入 `native.messages`，并删除过渡事件 `session.compacted`。官方称旧会话/凭据/导入仍可读，无需数据库迁移。
- 工程与产品分析：
  - 产品形态：开源（MIT）编码 Agent，终端 TUI + 桌面 App + IDE 扩展多前端；不绑定模型供应商，走 75+ provider 路线。
  - 工程架构：2.1 的改动本质是「上下文与回放模型重构」——把摘要压缩从「复制一份扁平历史」改成「引用原消息 ID」，把 provider 私有回放态收进单一 `native` 命名空间。这直接降低长会话的存储与 token 冗余，也让 compaction hook 能覆盖 keepID，属于可编程上下文管理。
  - 生态/采用：GitHub 221,485 stars / 29,614 forks（2026-10-25 认证 GET 快照），是本期开源编码 Agent 中体量最大者；插件与 SDK 契约破坏性变更意味着生态集成方必须跟进，短期会有兼容摩擦。
  - 风险/限制：后台压缩「未使用的摘要也烧 token」是明确的成本风险，默认关闭合理；2.1 属破坏性 SDK/event 变更，自建集成的团队需锁定版本；3,813 个 open issues 说明迭代速度与缺陷积压并存。
- 关键数据：v2.1.4（2026-10-23）；stars 221,485、forks 29,614、open issues 3,813、pushed_at 2026-10-25T22:02Z。来源：[OpenCode changelog](https://opencode.ai/changelog)、[GitHub API repos/anomalyco/opencode](https://github.com/anomalyco/opencode)。
- 原文链接：https://opencode.ai/changelog
- 影响判断：OpenCode 正在把「开源 + 任意模型」的卖点落到上下文引擎的工程质量上，而不是只拼 provider 数量。2.1 的 keepID 引用式压缩如果稳定，会成为其他 harness 可借鉴的范式；但破坏性契约变更也提醒企业：开源 Agent 的升级成本主要在集成层。

### Cognition Devin Desktop（原 Windsurf）
- 本周动态：窗口内两个稳定版，10-23 的 v3.11.212 是一次界面与工作流的大合并：Agent Window 直接跑与 app.devin.ai 相同的界面（sessions 侧栏、session view、Automations、Review、Wiki、设置、⌘K 命令面板），支持把会话拖到另一会话上做最多 8 个并排对比、按 workspace 分组、从任意会话「More」菜单派生子会话；每个会话内新增 Files 树、Changes 标签（本地会话也有逐文件 diff 与「Since last seen」范围）、可在会话机器上开 Terminal、⌘L 引用代码进对话。云会话侧加「IDE」按钮直接对该会话机器开 Remote SSH 窗口、Preview 标签带 URL 栏/端口切换/设备尺寸/元素拾取，连接本机的云会话可读取未保存编辑。交互上改为：Enter 在 Agent 工作中是「steer 当前回合」，⌘/Ctrl+Enter 才排队到回合结束；已配置的 MCP server 可被 @ 提及。10-24 的 v3.11.216 是修复版，重点是权限与安装：组织角色无 Devin Cloud session 权限的成员恢复可见/可开 Devin Local 会话；Windows 安装 CLI 后新终端立即可用 `devin`；更新后已保存登录在编辑器自身连不上服务器时仍可用；终端打印 inline image 不再让 Local 会话崩溃。背景（非本周）：2026-06-02 Windsurf 更名 Devin Desktop，9-5 移除 Cascade、Devin Local 成为唯一本地 Agent。
- 工程与产品分析：
  - 产品形态：从「AI IDE」转为「Agent 指挥台 + 编辑器」双模：本地/worktree/云端三档执行位置成为一级选项，Subagent、ACP、Spaces 都在同一壳内。
  - 工程架构：桌面端与 web 端共用同一 Agent 界面与 MCP 定制层，云会话通过 Remote SSH 把「云机器」变成可视化工作区；Enter=steer / ⌘Enter=queue 是显式的回合控制语义，说明其把「人类插话」做成一等交互。
  - 生态/采用：保留 Windsurf 插件市场与 JetBrains 插件线，兼容 `.windsurfignore`/`.devinignore`；ACP（Agent Client Protocol）已默认开启，可接第三方 Agent。
  - 风险/限制：一周内两版且 3.11.212 改动面极大（界面、快捷键、权限、MCP 全动），企业升级需回归；权限模型刚修过「无云权限角色看不到本地会话」，说明角色与能力矩阵仍在收敛；Remote SSH 到云会话机器扩大了凭据与网络暴露面。
- 关键数据：v3.11.212（2026-10-23）、v3.11.216（2026-10-24）。来源：[Devin Desktop changelog](https://docs.devin.ai/desktop/changelog)（2026-10-25 读取 .md 版）。
- 原文链接：https://docs.devin.ai/desktop/changelog
- 影响判断：Cognition 把 Windsurf 彻底并入 Devin 品牌与云端体系，桌面端变成 Devin 云平台的客户端。对企业的含义是「买 IDE」变为「买 Agent 平台席位」；对竞争的含义是 Cursor 的 Agents Window 与 Devin Desktop 正在收敛成同一种产品形态。
# A组 分片 04 — Aider / Cline / Roo Code / Replit Agent

### Aider
- 本周动态：**本周无重大公开动态**。核验范围：PyPI `aider-chat` 全版本、GitHub Releases、仓库 pushed_at。最新 PyPI 版本为 0.86.2（2026-02-12T00:42Z），GitHub 最后一个 release 为 v0.86.0（2025-08-09），仓库最后推送 2026-05-22。项目事实上处于低频维护期，本期没有任何版本、架构或 benchmark 变化可写。
- 工程与产品分析：
  - 产品形态：终端 pair programming，git-native 提交与 repo map 是其标志；在「多 Agent 编排 + 云端执行」成为主流的 2026 年，Aider 仍坚持单会话、单机、可解释的编辑循环。
  - 工程架构：repo map（tree-sitter 抽取符号图）+ 精确 edit block 格式，是上下文压缩的早期范式；但无 sandbox、无 MCP 一等支持、无云端会话，与本期其他对象的工程方向相反。
  - 生态/采用：49,750 stars、5,107 forks、1,943 open issues（2026-10-25 认证 GET 快照），社区仍有存量但新增动能弱。
  - 风险/限制：长期不发版意味着新模型适配滞后；高度依赖用户自建环境，企业治理（权限/审计/身份）基本缺失。
- 关键数据：latest 0.86.2（PyPI，2026-02-12）；GitHub release v0.86.0（2025-08-09）；stars 49,750。来源：[PyPI aider-chat](https://pypi.org/project/aider-chat/)、[GitHub API](https://github.com/Aider-AI/aider)。
- 原文链接：https://pypi.org/pypi/aider-chat/json
- 影响判断：Aider 已从「竞争者」退为「参照系」——它证明了 git 原生编辑循环的价值，但没跟上 harness 平台化。**取证警示**：第三方对比页曾称「Aider 于 2026-10-22 发布 V1 v1.19.4 与 V2 2.1.3、支持 75+ provider」，与 PyPI/GitHub 原始记录直接矛盾（这些版本号实为 OpenCode 的发布序列），本组按原始源判定该说法不成立，不予采用。

### Cline
- 本周动态：**窗口内无新版本发布**。核验范围：GitHub Releases（最新为 v4.1.25，2026-10-16；同日另有 CLI v3.0.73、Desktop v0.0.48、SDK v0.0.95），均在窗口之前；仓库 2026-10-25 仍有推送，说明代码活跃但未发版。故本周记为「观察」而非「静默」。可写的结构性事实（背景，非本周）：Cline 已形成 IDE 扩展 + CLI + Desktop + SDK 四条产品线，v4.x 为主扩展线。
- 工程与产品分析：
  - 产品形态：VS Code 扩展起家，现为「扩展 + 独立 CLI + 桌面端 + SDK」矩阵，覆盖人类交互与自动化两种用法。
  - 工程架构：以 MCP 市场、plan/act 双模式、checkpoint 回滚为核心；SDK 化（v0.0.x）说明其正把 harness 开放给外部集成。
  - 生态/采用：70,836 stars、7,748 forks（2026-10-25 快照），是开源 IDE Agent 中体量第二的选手（仅次于 OpenCode）。
  - 风险/限制：多产品线并进但版本号体系分裂（4.x / 3.0.x / 0.0.x），企业选型时难以判断哪条线是长期主线；窗口内不发版也意味着本周无新能力可评估。
- 关键数据：v4.1.25（2026-10-16）、CLI v3.0.73（2026-10-16）、Desktop v0.0.48（2026-10-17）、SDK v0.0.95（2026-10-17）；stars 70,836。来源：[Cline Releases](https://github.com/cline/cline/releases)、[GitHub API](https://github.com/cline/cline)。
- 原文链接：https://github.com/cline/cline/releases
- 影响判断：Cline 的 SDK/Desktop 化是在追随「harness 平台化」，但发布节奏已落后于 OpenCode 与 Codex。下一步看 v4.1.26+ 是否把 SDK 与扩展的上下文模型统一。

### Roo Code
- 本周动态：**本周无动态，项目已终止**。Roo Code 仓库已 archived（`archived: true`），最后推送 2026-05-15；官方在扩展内提示 2026-05-15 关停并指向替代品（Cline / ZooCode）。本周核验未发现任何恢复或继任发布。
- 工程与产品分析：
  - 产品形态：Cline 分叉出的「多模式（Architect/Code/Debug/Orchestrator）+ 自定义模式」IDE Agent，曾以模式编排与团队配置见长。
  - 工程架构：模式即角色，本质是把 prompt 与工具白名单打包成可切换 profile；该思路已被 Cursor modes、Claude Code subagent、Devin subagent 吸收。
  - 生态/采用：24,262 stars（归档时快照），用户需迁移。
  - 风险/限制：**选型风险实例**——依赖单一开源 IDE Agent 存在停服风险；归档后无安全修复，继续使用等于把未修补的权限/执行面留在开发机上。
- 关键数据：archived=true、pushed_at 2026-05-15T18:08Z、stars 24,262。来源：[GitHub API repos/RooCodeInc/Roo-Code](https://github.com/RooCodeInc/Roo-Code)。
- 原文链接：https://github.com/RooCodeInc/Roo-Code
- 影响判断：Roo Code 退场是本期开源编码 Agent 格局的重要注脚：模式化编排的差异化不足以支撑独立产品，最终被平台型 harness 吸收。对企业，这是一条明确的供应链风险证据。

### Replit Agent
- 本周动态：2026-10-22 发布 **Replit Monitoring Agent**——把 2026 年上半年上线的 App Monitoring（健康检查+告警）闭成环：生产事故发生时，Agent 可读取生产日志与指标定位原因、验证修复、并经「auto-publish」直接部署到生产，随后邮件回报发生了什么、改了什么；是否自动发布由用户开关决定。同日另发安全公告，称对本周披露的广泛依赖库漏洞，Replit 直接在其托管环境打补丁、更新语言工具链并阻断利用，需要重新发布的 App 会主动通知用户。这两条合起来是 Replit 的产品主张：把「运维/安全」也纳入 Agent 的责任边界，而不只写代码。
- 工程与产品分析：
  - 产品形态：从「vibe coding 建应用」延伸到「上线后自治运维」，Agent 角色由 builder 扩为 on-call engineer。
  - 工程架构：Agent 需要生产日志/指标读取权限 + 修复验证 + 部署权限三段打通，本质是「可观测性 → 代码修改 → 发布流水线」的闭环；auto-publish 是可关的自治等级开关，属分级授权设计。
  - 生态/采用：依托 Replit 自有托管环境（这也是它能「替用户打补丁」的前提）；企业侧另有 Bring Your Own Cloud（10-16）与治理工具承接隔离需求。客户数与采用数据未公开。
  - 风险/限制：让 Agent 自动改生产并自动发布，是本组本周见到的最高自治等级，风险面包括误判根因、修复引入回归、以及「Agent 拥有生产写权限」的审计与回滚要求；官方博客未披露验证机制细节、失败率或回滚策略，效果主张（能自动修好）本次未取得独立证据。
- 关键数据：发布日 2026-10-22（官方博客）；同日安全公告 2026-10-22。来源：[Replit Monitoring Agent](https://replit.com/blog/replit-monitoring-agent)、[Replit blog index](https://replit.com/blog)。
- 原文链接：https://replit.com/blog/replit-monitoring-agent
- 影响判断：这是编码 Agent 竞争从「写得多快」转向「敢不敢托管生产」的标志性一步。若 auto-publish 在真实事故中可靠，Replit 会拿到「一人公司也能有 on-call」的独特卖点；反之，一次自动发布引发的生产事故就足以让企业客户关掉该能力。下一步看是否公开事故拦截率与回滚数据。
# A组 分片 05 — 其他活跃对象观察 / 本组洞察 / 覆盖审计

### SWE-bench（评测面）
- 本周动态：**未取得窗口内（10-19～10-25）可核验的新增榜单条目**。核验范围：官方 swebench.com 排行榜、两个第三方聚合榜。官方榜当前可见条目包含「Gemini 3 Pro Preview + live-SWE-agent 77.40」「Claude 4 Sonnet + EPAM AI/Run Developer Agent 76.80」，但页面未标注更新时间，无法判定是否落在本周；第三方榜（benchlm 称 Claude Opus 5 达 96%，覆盖 115 个模型）口径混杂「模型自报」与「Agent 系统分」，且未给出可复现运行信息，本组不采用该 96% 数字作为事实。背景（非本周）：官方榜历史上更新频率低（2026-02 曾做一次全量重跑），因此「本周无新条目」是常态而非异动。
- 工程与产品分析：
  - 产品形态：SWE-bench Verified 仍是编码 Agent 最主要的对外宣称口径，但它测的是「给定 issue 能否产出通过测试的 patch」，不覆盖长时任务、多轮交互、生产部署。
  - 工程架构：分数由「模型 + harness（scaffold）」共同决定，官方榜同时列 model 与 agent 两列，正是承认 harness 是一等变量；这也是本期 Replit 用 DeepSWE/Terminal-Bench 讲 harness 效率的原因。
  - 生态/采用：厂商自报分与官方榜分长期存在差距，采购时不能直接横比。
  - 风险/限制：本周第三方聚合站出现明显不可核的高分（96%），属典型「排行榜通胀」，引用时须回到官方或可复现技术报告。
- 关键数据：官方榜可见 live-SWE-agent 77.40、EPAM AI/Run 76.80（无更新时间）。来源：[swebench.com](https://www.swebench.com/)（2026-10-25 读取）。
- 原文链接：https://www.swebench.com/
- 影响判断：本周没有可用的新 benchmark 信号，说明竞争已从「刷榜」转向「工程可用性」（权限、上下文、云执行、生产闭环）。评估供应商时应要求其给出 harness 版本与可复现配置，而不是单一百分比。

## 本组洞察（编码 Agent / CLI / IDE）

1. **本周主线是「权限与自治的边界」，不是模型能力。** Claude Code 一周 6 版几乎全在补沙箱/权限/hooks 漏洞；Codex 0.164 把企业 MCP 授权、凭据遮蔽、排队 prompt 让位权限确认放在同一版；Antigravity CLI 给 hook 喂 `lastUserInput` 以便审查指令；Replit 则反向把自治推到「自动改生产并发布」。同一周内，一边在收紧「Agent 能做什么」，一边在放开「Agent 敢替你上线」——这是行业尚未形成统一自治等级的直接证据。
2. **终端入口在平台化，独立 CLI 正在被收编。** Google 用 Antigravity CLI 取代消费级 Gemini CLI（企业轨道保留），Cognition 用 Devin Desktop 统一 Windsurf，Cursor 把 Agents Window/Cloud Agents/Projects 做成指挥台。结论：单点 CLI 的差异化窗口在关闭，竞争转移到「共享 harness + 云端执行 + 治理面」。
3. **上下文工程出现可复用的新范式。** OpenCode 2.1 把压缩摘要从「复制扁平历史」改为「引用 `metadata.keepID`」，并把 provider 回放态收进单一 `native` 命名空间；Codex 修「压缩失败留下半截摘要」；Claude Code 修「压缩后仍保留过多 base64/SVG」。三家同期在解决同一类问题：长会话的状态一致性。这是本周最值得架构师关注的技术细节。
4. **开源侧的集中度在上升，且伴随明确的供应链风险。** OpenCode 221K stars、Cline 70.8K、Aider 49.8K，但 Aider 自 2026-02 无新版、Roo Code 已于 5-15 归档。开源编码 Agent 的「活跃度分层」比 stars 更能预测可用性。
5. **商业形态从「席位」走向「托管生产」。** Replit 的 Monitoring Agent、Cursor 的 Rollouts（部署后健康监控）、Claude Code 的 Monitor 工具，三点同向：Agent 的价值主张正在从「写代码」移到「对运行中的系统负责」。这会重新定义采购标准（审计、回滚、权限分级），而不只是补全质量。

## 覆盖与取证审计
- 固定对象 9 个 + 评测面 1 个：有料 5（Claude Code、Codex、OpenCode、Devin Desktop、Replit Agent），结构性有料 2（Gemini CLI→Antigravity CLI 迁移、Roo Code 归档），观察 2（Cursor 窗口内无更新、Cline 窗口内无发版），静默 1（Aider）。覆盖率 9/9 已逐一核验，有料深度条目 5 条，达到 ≥80% 覆盖目标。
- 主要缺口：① Cursor 官方 changelog 页面不含条目日期，本周判定依赖第三方聚合（10 月仅 3 条，最新 10-16），若官方后续补发窗口内条目需复核；② Replit Monitoring Agent 的可靠性/回滚数据未公开，效果主张未独立验证；③ Antigravity CLI 与 Gemini CLI 的企业版功能差异官方未给对照表；④ SWE-bench 窗口内无可核验新增条目。
- 已知矛盾处置：第三方页面称「Aider 2026-10-22 发布 V2 2.1.3」与 PyPI/GitHub 原始记录矛盾，已按原始源否定，不采用；benchlm「Claude Opus 5 96%」不可核实现场隔离，不采用。
- 工具记录：搜索 provider=serper（默认）；正文深读 provider=tavily 或 web_fetch；GitHub 数据全部经认证 GET（login=wujiaming88），stars 为 2026-10-25 快照，无跨期快照故不报周增速。
# B组｜开源 Agent 框架与项目（第 21 期）

- 冻结时间窗：2026-10-19 00:00 ～ 2026-10-25 24:00（Asia/Shanghai）
- 研究主责：黄山（wairesearch）；run_id：e0de9bad-34c7-4686-a0e5-f6189f218841
- 取证口径：GitHub 认证 GET（`gh api --hostname github.com`，login=wujiaming88，核对时刻 2026-10-26 06:10 CST，core 额度 4987/5000）；stars/forks 均为取得时快照，本期无跨期快照，不声称周增速。release 采用 `published_at`，不以 `updated_at` 代替。
- 本片对象：OpenClaw、Hermes Agent。

---

### OpenClaw
- 本周动态：窗口内 OpenClaw 连发三个正式版与两个 beta：v2026.10.6（2026-10-22T12:53Z）、v2026.10.7（2026-10-24T09:53Z），另有同批推送的 v2026.9.34（10-24T11:38Z，维护线回补），以及 2026.10.10-beta.2（10-19）、beta.3（10-21）。10.6 的核心是**运行时安全基线**：强制 Node 24.22.1+ / 26.12.1+，理由是 2026 年 10 月 Node.js 安全版本修复了"被攻陷证书密钥签发的 TLS 链"，Docker 镜像与安装器同步换装，`openclaw update` 在旧 Node 上直接拒绝安装并给恢复指引，而不是装完再坏；源码构建锁 pnpm 12.15.0。10.7 的主题是**可回放的会话恢复**：中断会话保留 recovery provenance 与未完成工具结果，已停止会话在接受下一条消息前清退终态恢复残留，大包子任务完成结果被约束在请求方上下文内，Codex 预览在上下文刷新后不再阻塞回复；同时备份/状态持久化做了"截断写入时保留 last-known-good 配置快照""多文件补丁失败保留先前文件""Memory Wiki 重导入保留人工笔记"。同版还为 Google 模型加入 Gemini 4 Argon 支持（#171852）。
- 工程与产品分析：
  - 产品形态：跨 OS/平台的常驻 Agent 运行时（CLI + Gateway + 桌面 + 聊天渠道），卖点不是单次任务能力，而是"长期挂着不坏"。
  - 工程架构：本周改动集中在状态机与持久化层——恢复来源标记、幂等重放、锁与租约、截断写保护、补丁部分失败回滚；工具执行与子任务完成走"请求方上下文配额"约束，属于上下文工程而非提示词技巧。
  - 生态/采用：393,049 stars / 82,614 forks（2026-10-26 06:12 CST 快照），release 贡献者名单里出现大量社区 ID，说明外部 PR 已成主力；插件层持续收敛官方插件版本。
  - 风险/限制：更新链与 Node 版本强绑定，自建部署存在升级窗口成本；恢复语义复杂，回归面大，一旦 provenance 记录不全会退化为不可重放。
- 关键数据：v2026.10.7 发布于 2026-10-24T09:53:46Z；v2026.10.6 发布于 2026-10-22T12:53:10Z；stars 393,049、forks 82,614、pushed_at 2026-10-25T22:09:16Z（[repo](https://github.com/openclaw/openclaw)，2026-10-26 取得）。
- 原文链接：[v2026.10.7 release](https://github.com/openclaw/openclaw/releases/tag/v2026.10.7)、[v2026.10.6 release](https://github.com/openclaw/openclaw/releases/tag/v2026.10.6)
- 影响判断：OpenClaw 本周没有讲新故事，而是把"Agent 运行时=有状态服务"这件事做实：恢复、幂等、迁移、备份四条线同时推进，这恰是自建 Agent 平台最容易翻车的地方。它正在把竞争维度从"支持多少工具"拉到"故障后能不能恢复"，后来者若只堆功能会在这条线上被拉开。

---

### Hermes Agent
- 本周动态：NousResearch/hermes-agent 窗口内三连发 v0.22.3（10-21T12:21Z）、v0.22.4（10-21T18:49Z）、v0.22.5（10-23T05:28Z）。v0.22.5 是聚合补丁版，release note 给出量化：自 v0.22.4 以来 **231 个非合并提交、804 个改动文件（+35,212/−17,885）、81 个已合并 PR、30 个关闭 issue**，测量点为 commit `bf0203a794a`。内容上最值得记的不是修 bug，而是**核心减负与迁移能力**：`hermes mcp serve` 与 Singularity 后端移出 core 改为插件；新增 `hermes import-agent` 与 OpenClaw 迁移路径（检测到其他 Agent 时安装流程主动提供导入）；委派后端可插拔，可按 model map 或 profile 路由子 Agent 并逐会话切换；插件斜杠命令支持让用户选项；Nous 登录统一为设备登录、免费访客可移交账号；新增基于用量窗口的套餐计量与模型切换恢复；实验性 webhook 模式 MCP 事件客户端。依赖侧升 Electron 44、Pillow 13 并批量修安全告警。
- 工程与产品分析：
  - 产品形态：自托管、跨渠道（Telegram/Discord/Slack/WhatsApp/Signal/CLI 单网关）的"会自我进化"的个人/小团队 Agent；README 明确其学习闭环为经验生成技能、使用中自改技能、主动催促沉淀记忆、用 FTS5 全量检索+LLM 摘要做跨会话回忆，并以 Honcho 做用户建模，兼容 agentskills.io 标准。
  - 工程架构：本周关键动作是**把可选能力从核心剥离成插件**（MCP serve、Singularity），同时把"委派"抽象成可切换后端——这是多 Agent 编排从硬编码走向运行时策略的信号；导入器则直接对准 OpenClaw 的用户资产（技能、记忆、配置）。
  - 生态/采用：257,040 stars / 56,301 forks，创建于 2025-07-22，MIT 许可；同时存在第三方生态仓（awesome-hermes-agent 5,897 stars、中文橙皮书 5,021 stars），说明社区文档与教程层已自发形成。
  - 风险/限制：open issues 高达 51,071，issue 吞吐明显落后于合并速度；两天 231 次提交的节奏意味着 API 与插件契约高频变动，企业自建需锁定版本；"自进化"能力缺少公开可复核的效果基准，本周 release 未给出任何评测数字。
- 关键数据：v0.22.5 发布于 2026-10-23T05:28:45Z；v0.22.4 10-21T18:49:24Z；v0.22.3 10-21T12:21:11Z；stars 257,040、forks 56,301、open issues 51,071（[repo](https://github.com/NousResearch/hermes-agent)，2026-10-26 取得）。
- 原文链接：[v0.22.5 release](https://github.com/NousResearch/hermes-agent/releases/tag/v0.22.5)、[README](https://github.com/NousResearch/hermes-agent)
- 影响判断：Hermes 正在用"兼容 OpenClaw 资产 + 插件化 + 可切换委派"三件事抢同一批自托管用户，迁移成本被主动降到接近零，这是典型的后来者切入策略。它的真实考验不在功能表，而在 5 万级 issue 积压与自进化效果能否给出可复核证据；下一步看 v0.23.0 的完整 release notes 是否补上评测口径。
## B组分片 02（LangGraph / LangChain、Google ADK）

### LangGraph / LangChain Agents
- 本周动态：LangGraph 走"小步高频"补丁线：`langgraph==1.2.17`（2026-10-24T01:08Z）、`langgraph-sdk==0.4.9`（10-23T14:19Z）、`langgraph-cli==0.4.38`（10-23T14:22Z）、`cli==0.4.37`（10-19T14:06Z）。1.2.17 的实质改动只有三条：显式传入等于默认值的 `recursion_limit` 时按显式值生效（此前会被内部默认覆盖，长任务容易莫名中断）；`RemoteGraph.stream(subgraphs=True)` 保留调用方的 namespace（分布式部署下子图事件归属错乱的根因）；移除预防性的第三方依赖上界。LangChain 主仓窗口内 82 次默认分支提交，几乎全是依赖与安全补丁——包括 `build(deps): patch vulnerable integration dependencies (#41473)`、`fastmcp 4.0.11→4.1.2`、setuptools 84.1.0，文档侧更新 OpenWiki；对应发布 `langchain==1.4.7`（10-21T21:39Z）、`langchain-core==1.7.0`（10-22T17:47Z）。
- 工程与产品分析：
  - 产品形态：LangGraph 仍是"显式状态图 + checkpoint"路线的主力，面向需要可中断、可恢复、可人工介入的长流程；LangChain 1.x 已收缩为集成与工具层。
  - 工程架构：本周两条改动都指向**分布式与递归语义的正确性**——namespace 归属决定多进程/远程图的事件与检查点写到哪，recursion_limit 决定失控循环何时被掐断。这类修复不产生新 API，但直接决定线上故障率。
  - 生态/采用：43,883 stars / 7,539 forks / 513 open issues（10-26 06:12 CST 快照），issue 存量相对 stars 很低，维护响应较好；`fastmcp` 升级说明 MCP 客户端已跟随 4.x 主线。
  - 风险/限制：连续三个包各自发版（core/sdk/cli），版本矩阵需要对齐，自建部署容易混版；本周无新范式，只有正确性修补，说明 1.2 线进入稳定期而非能力扩张期。
- 关键数据：1.2.17 发布于 2026-10-24T01:08:05Z；sdk 0.4.9 于 10-23T14:19:24Z；cli 0.4.38 于 10-23T14:22:29Z；stars 43,883 / forks 7,539 / open issues 513；pushed_at 2026-10-25T15:27:16Z（[repo](https://github.com/langchain-ai/langgraph)，2026-10-26 取得）。
- 原文链接：[langgraph 1.2.17](https://github.com/langchain-ai/langgraph/releases/tag/1.2.17)、[langchain-core 1.7.0](https://github.com/langchain-ai/langchain/releases/tag/langchain-core%3D%3D1.7.0)
- 影响判断：LangGraph 本周的价值在"少出事"：namespace 与递归上限都是生产事故高发点，修掉比加功能更重要。对架构选型者的含义是——它的护城河已从"能编排"转为"状态语义可信"，而这正是多数轻量框架缺的部分。

---

### Google ADK（adk-python）
- 本周动态：`v2.13.0` 发布（release 列表 published_at 2026-10-23T18:08Z；release 正文标注 2026-10-22，两处日期不一致，以列表时间为准并保留差异）是一次"转正 + 扩容"版本：**12 个实验特性转 stable**；新增 `TypesafeClassifier` 与 `ClassifierNode`，用 TypeSafe 的 Jev 模型做工作流路由分类器，声称单次前向即返回校准概率、比 LLM 分类快得多；Live Audio 支持实时语音与 barge-in（打断），接入 Gemini STT/TTS；内存与持久化侧新增实验性 `MongoDbSessionService`（会话存 MongoDB、跨 runner 副本共享）与 `MongoDbMemoryService`（关键词召回长期记忆，**无需 embedding 模型与向量索引**）；`MongoDbToolset` 可部署到 Agent Engine 而不打包连接串，Atlas Automated Embedding 在服务端完成查询向量化；性能上字符串模型 Agent 的执行回合最高快 8 倍，事件加载开销下降。破坏性变更：遥测默认切到 OpenTelemetry GenAI v2（`otel_semconv_1_44`，移除 `call_llm` span），需设 `ADK_TELEMETRY_SCHEMA_VERSION_OPT_IN=otel_semconv_1_36` 才保留旧 schema。
- 工程与产品分析：
  - 产品形态：面向 Google Cloud/Agent Engine 的 Agent 开发框架，强项是把会话、记忆、工具、部署与可观测打通成一条云上路径。
  - 工程架构：三处值得单独记——① 用小型分类模型替代 LLM 做路由，把"每次分支判断一次推理"的成本降为一次前向；② 无向量库的关键词记忆服务，等于承认大量团队根本没有向量基础设施；③ 遥测默认切 v2 属语义化契约变更，会把既有看板打空。
  - 生态/采用：22,004 stars / 4,246 forks，pushed_at 2026-10-25T17:53Z；MongoDB 官方集成说明 ADK 在补齐"非 Google 原生栈"的落地路径。
  - 风险/限制：Jev/TypeSafe 为外部模型供应方，本周未取得独立性能复现；8x 加速仅对"字符串模型 Agent"，不能外推到多工具或多 Agent 场景；记忆服务走关键词匹配，召回质量上限明确。
- 关键数据：v2.13.0；stars 22,004 / forks 4,246（[repo](https://github.com/google/adk-python)，2026-10-26 取得）；12 项实验特性转 stable（release 正文，2026-10-22/23）。
- 原文链接：[adk-python v2.13.0](https://github.com/google/adk-python/releases/tag/v2.13.0)
- 影响判断：ADK 的路线很务实——不追求最强 Agent，而是把企业最缺的三件事（路由成本、记忆持久化、可观测契约）做成默认件。遥测 v2 的破坏性切换说明它开始把自己当"平台标准"而非"库"；升级方须先锁 schema 版本再看板。
## B组分片 03（Dify、OpenHands）

### Dify
- 本周动态：`v1.18.0`（2026-10-23T06:33Z，距上版 v1.17.1 已隔 6 周）主题是"Agent 决定下一步"。核心能力四项：① **Output Routes**——Agent 节点输出可带选择条件并接到不同分支（如直接解决或转交专家），只读 `switch` 输出暴露所选路由（#42599），同时 Agent v2 节点改为流式输出文本，但结构化结果、路由结果与使用默认值兜底的节点仍缓冲（#43986）；② **可移植应用包 `.ifpkg`**——把应用连同其内联 Agent、Skills 与文件打进单包，导入时在目标工作区重建资源并重映射引用，文件/URL 导入兼容包与 YAML（#42066、#42579、#42626、#42863）；③ **嵌套工作流可视化**——从运行历史点进 Workflow Tool 调用可看子工作流各步骤，嵌套工具以子图运行并协同 pause/resume/stop 与文件输出，带源应用访问校验（#40277、#42819–#42822）；④ **Agent Knowledge Base（Beta）**——独立知识空间，可查文档处理、元数据、检索轨迹与质量评估，与新的 Knowledge Retrieval 节点共享受访问控制的 KnowledgeFS，需独立服务与数据库，云版"即将上线"（#44165）。开发者侧新增 OpenAPI 与 `difyctl`：命令从服务端 operation catalog 动态发现，支持 Workflow/Chatflow 创建、DSL 导入导出、环境变量、发布与版本恢复，draft hash 防并发覆盖，并可用 `difyctl install skills <dir>` 装内置 skill。
- 工程与产品分析：
  - 产品形态：从"可视化编排平台"转向"Agent + 工作流混合编排台"，路由决策从人画边改为 Agent 选边，等于把分支逻辑交给模型判断。
  - 工程架构：本次是**协议级破坏变更**——`/runs` 只接受 composition v2 并拒绝 v1，旧 Agent 专用 AskHuman 工具与延迟恢复路径被删除（共享 Workflow Human Input 节点保留），旧运行时读不了新快照；本地 Agent sandbox 必须配高熵认证 token（`--require-auth-token`，1.17.1 镜像不支持），源码安装要求 Python 3.13。升级必须 API、workers、Agent Backend、Agent runtime 一起换。
  - 生态/采用：159,522 stars / 25,214 forks（快照），发版节奏从双周拉长到 6 周，说明进入大版本整合期；`.ifpkg` + difyctl 的组合明显指向"应用在租户/环境间搬迁"这一真实运维痛点。
  - 风险/限制：官方自承嵌套运行的用量与步数统计在暂停/停止后仍可能近似；Knowledge Base 需额外服务与库，自建成本上升；若团队仍用 1.17 运行时，混版会直接读不了 v2 快照，回滚窗口很窄。
- 关键数据：v1.18.0；stars 159,522 / forks 25,214 / pushed_at 2026-10-25T21:19Z（[repo](https://github.com/langgenius/dify)，2026-10-26 取得）；上版 v1.17.1 为 2026-09-10。
- 原文链接：[dify 1.18.0](https://github.com/langgenius/dify/releases/tag/1.18.0)
- 影响判断：Dify 用"Agent 选路"换掉了部分人工编排，这在低代码平台里是范式位移：边由模型决定，可解释性就落到 `switch` 输出与运行轨迹上——正因如此它同版补了嵌套可视化。真正的采用门槛不在功能，而在 v2 协议的一次性硬切；准备升级的团队应先在隔离环境用新镜像跑完快照转换。

---

### OpenHands
- 本周动态：4 天内连发 5 个版本：v1.29.0（10-20T22:22Z）、v1.30.0（10-22T01:08Z）、v1.31.0（10-22T16:09Z）、v1.32.0（10-23T03:03Z）、v1.33.0（10-23T13:46Z）。实质内容集中在 **Agent Profile 成为一等配置对象**：可按 profile 从服务端目录选 skills、编辑 condenser 与 verification、选 Model Router，并按 id 直接启动 `default`，profile 自己持有设置（#18679、#18685、#18686、#18720）；公共 skills 改从随包 extensions 读取（#18683）。平台侧补自动化的集成连接态展示、canvas 用服务端会话标签持久化工作区分组、云端会话保存已连接仓库、以及可选的 Mars web bridge。v1.33.0 修了一处安全问题：请求表单与 Settings 表单中的 secret 值改为掩码显示（#18870）；v1.32.0 把 DigitalOcean 上新 Agent 默认放到最小 VM。README 移除 beta 徽章（#18176）。
- 工程与产品分析：
  - 产品形态：从"开源编码 Agent"扩为"Agent Canvas"——会话、自动化、技能、多后端（本地/Cloud/DigitalOcean）在同一画布里管。
  - 工程架构：把 context condenser、verification、model router、skills 收进 profile，等于承认 Agent 质量主要由"上下文压缩策略 + 校验环节 + 路由模型"决定，而非基座模型；这也是可复制到企业环境的配置面。
  - 生态/采用：91,819 stars / 12,194 forks，pushed_at 2026-10-25T20:58Z；release 由 Release Please 自动生成，issue 编号带 OHE/OSS 前缀，说明有内部工单体系并行。
  - 风险/限制：macOS 构建尚未签名/公证，Gatekeeper 会报"已损坏"，需手动 `xattr -dr com.apple.quarantine`——企业分发仍是缺口；本周多数条目是前端与云端体验修补，编码能力本身无新证据；secret 掩码属显示层修复，不等同于凭据存储加固。
- 关键数据：v1.29.0 2026-10-20T22:22:52Z、v1.30.0 10-22T01:08:52Z、v1.33.0 10-23T13:46:20Z；stars 91,819 / forks 12,194（[repo](https://github.com/OpenHands/OpenHands)，2026-10-26 取得）。
- 原文链接：[v1.29.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.29.0)、[v1.33.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.33.0)
- 影响判断：OpenHands 把"Agent 可调参数"产品化了：profile 里放 condenser/verification/router，是把自己往"可交付的编码 Agent 平台"推，而不是继续做 demo。短期看签名与自托管复杂度是落地阻力；中期看这套 profile 抽象若能导出复用，会成为企业内多团队共享 Agent 配置的实际载体。
## B组分片 04（Microsoft AutoGen / Agent Framework、CrewAI、AutoGPT）

### Microsoft AutoGen（→ Microsoft Agent Framework）
- 本周动态：**本周无重大公开动态**，且已进入终止态。仓库 README 顶部挂 `status-archived` 徽章并写明"项目已归档，Microsoft 不再维护，不提供 bug 修复、安全修复、新功能或支持"，明确建议不要用于生产，新用户应转向 Microsoft Agent Framework；警告未修漏洞会随依赖累积。最近的提交为 2026-10-16 的 `docs: clarify AutoGen is archived and no longer maintained (#8366)`（**窗口外，作背景**），再往前是 2026-04-06 的维护横幅与 2026-03-26 的一次 provider 加载安全修复；最新 release 仍是 `python-v0.7.5`（2025-09-30）。需记录的矛盾：GitHub API 返回 `archived=false`，即仓库并未真正置为归档只读，只有声明层面归档——审计上应表述为"官方宣布归档，仓库标志未同步"。
- 工程与产品分析：
  - 产品形态：原多 Agent 对话式框架（GroupChat/AgentChat），已停止演进。
  - 工程架构：继任者 Agent Framework `python-1.23.0`（2026-10-22T17:05Z）与 `dotnet-1.26.0`（10-23T14:32Z）本周给出迁移落点，且是破坏性升级：MCP 2.x 兼容基座落地，传输、错误、schema 与生命周期整体迁移（#9236）；AG-UI 端点注册必须显式声明授权 scope 或单用户模式（#9413）；Docker shell 参数 `extra_run_args` 更名 `unsafe_extra_run_args` 并把信任要求写进命名（#9453）；MCP 客户端生命周期区分 caller-owned 与 framework-owned（#9237、#9532）；A2A 支持按白名单从请求元数据转发函数调用与客户端参数（#9193）。
  - 生态/采用：AutoGen 61,559 stars / 9,314 forks，1,121 open issues 将不再处理；Agent Framework 14,314 stars / 2,512 forks，pushed_at 2026-10-25T14:38Z。
  - 风险/限制：仍在 AutoGen 上跑生产的企业面对"无安全补丁"敞口，迁移是被迫而非选择；迁移不是改 import，而是 MCP 生命周期与授权模型同时变。
- 关键数据：AutoGen 最新 release `python-v0.7.5` 2025-09-30；归档声明提交 2026-10-16T16:14Z；API `archived=false`（2026-10-26 取得）；Agent Framework python-1.23.0 2026-10-22。
- 原文链接：[AutoGen README](https://github.com/microsoft/autogen)、[agent-framework python-1.23.0](https://github.com/microsoft/agent-framework/releases/tag/python-1.23.0)
- 影响判断：这是本期开源侧最重的一条结构性事实：多 Agent 框架第一代的代表正式退场，微软把编排、MCP、A2A、AG-UI 收进单一继任框架并要求显式授权。对架构师的直接含义是——今年选框架必须把"上游是否还在维护"和"MCP/授权契约是否稳定"放在功能之前。

---

### CrewAI
- 本周动态：`1.15.29`（2026-10-23T17:35Z）是一次功能密集版：**AgentExecutor 从 experimental 转正**；新增离线 "jev routing" 与 guardrail evaluation runner；集成应用动作可直接以 `call: tool` 调用；CLI 增加平台应用搜索、登录时选组织、动作选择器搜索高亮、会话路由与公开回复追踪；新增 Azure DocumentDB 向量检索、只读 notebook 文本加载器与标准库 jsonl 加载器；`crewai eval` 支持把评估全量数据留在项目内、一条命令跑 crew 拿判决、把评估导出为文件。修复面向长期运行的真实故障：工具动作遵守 failure policy 且每次 kickoff 重取用量预算、**无来源的私有记忆不再泄漏进每次召回**、LanceDB 记忆检索顺序、LanceDB 过滤器 scope/id 转义、重规划失败时恢复任务描述、**阻止 Agent 重复同一工具调用**。重构项：上下文压缩改为 BaseLLM 能力。`1.15.30`（10-24T01:56Z）仅文档与 AGENTS.md 登录流程修正。
- 工程与产品分析：
  - 产品形态：Crew（角色分工）+ Flow（事件编排）双轨，本周把执行器转正，等于承认 AgentExecutor 是稳定对外契约。
  - 工程架构：上下文压缩上移到模型层，是"压缩策略随模型走"的路线，与 LangGraph 的显式状态、ADK 的 classifier 节点形成三种不同取舍；离线路由 + 本地评估 runner 则把评估从云服务拉回本地，适合内网。
  - 生态/采用：60,095 stars / 8,881 forks，单个补丁版贡献者 24 人，社区提交占比高。
  - 风险/限制：一次补丁版塞进十余项特性，回归面偏大；"离线 jev routing"与 ADK 的 Jev 分类器同名但本次未取得统一说明，不能推断为同一产品化能力；记忆与 LanceDB 相关修复集中出现，提示该存储路径此前不够稳。
- 关键数据：1.15.29 发布于 2026-10-23T17:35:29Z；1.15.30 于 2026-10-24T01:56:04Z；stars 60,095 / forks 8,881（[repo](https://github.com/crewAIInc/crewAI)，2026-10-26 取得）。
- 原文链接：[crewAI 1.15.29](https://github.com/crewAIInc/crewAI/releases/tag/1.15.29)
- 影响判断：CrewAI 把"评估"和"路由"两个此前靠外挂的环节内置，是在补生产化短板；Executor 转正意味着 API 冻结信号，适合要长期维护的项目。仍需观察的是高频补丁下的稳定性与记忆系统是否真正收敛。

---

### AutoGPT（Platform beta）
- 本周动态：`autogpt-platform-beta-v0.9.0`（2026-10-23T01:28Z）给出一个值得单独记的权限模型：**每个 block 声明自身 effect，Auto 对廉价的外向动作直接判断、对昂贵动作先询问**（#14981）——把 HITL 从"全量确认"改成"按动作代价分级审批"，并配套按专家（Expert）设置新网页会话的默认审批模式（#15115）。平台侧同版补齐运维面：Docker Hub 镜像自托管 + Windows 安装器（#14553）、管理员用户页可查/封禁/代登录并内置限流（#15675）、多账号滥用治理与度量（#15824）、浏览器工具流量走 egress 代理（#15859）、swap proxy 由只暴露两个调用的服务提供且 proxy 后放占位符而非 token（#14865、#14868）。调度与成本侧：AutoPilot 触限暂停而非死掉、预算重置后可恢复、可设"重置时发送"、低额度提示（#15388、#15390、#15403）；计划任务同因失败会暂停并告知、owner 收到提醒（#15374、#15375、#15377）；"dreaming" 过程蒸馏私有账号与 Expert 技能，并加 DreamPass 记录与重叠守卫（#14551、#14961、#14970）。模型目录新增 Claude Haiku 5.5 与 Meta Muse Spark。
- 工程与产品分析：
  - 产品形态：从"自主循环实验"转为多租户 Agent 平台，重心在托管、计费、滥用治理与定时任务。
  - 工程架构：block 级 effect 声明是本周最有复用价值的范式——把"是否需要人确认"从全局开关变成每个动作的元数据，再由策略引擎按代价判定；egress 代理与占位符换 token 则把凭据隔离到网络层。
  - 生态/采用：187,749 stars / 45,895 forks（存量热度极高），pushed_at 2026-10-25T22:08Z；仍标 beta。
  - 风险/限制：beta 期一次发布含 30+ 变更，升级风险高；"Auto 判断廉价动作"的边界由平台定义，企业需核对自身合规是否接受自动外向动作；本周未见独立安全评估。
- 关键数据：v0.9.0 发布于 2026-10-23T01:28:07Z；stars 187,749 / forks 45,895（[repo](https://github.com/Significant-Gravitas/AutoGPT)，2026-10-26 取得）。
- 原文链接：[autogpt-platform-beta-v0.9.0](https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.9.0)
- 影响判断：AutoGPT 的贡献不在自主性，而在"按代价分级审批 + 动作 effect 声明"这套可移植的权限语义；若被其他框架采纳，"哪些动作必须问人"将首次有可比较的标准。当前仍是 beta，适合观察而非生产押注。
## B组分片 05（OpenAI Agents SDK、browser-use、静默项与观察池、本组洞察）

### OpenAI Agents SDK（openai-agents-python）
- 本周动态：**无新 release**（最近 v0.24.0 为 2026-10-15，窗口外），窗口内默认分支 11 次提交，方向是**收窄 sandbox 供应商面 + 加固沙箱**：10-19 移除 Runloop provider 并删除对应文档指引（#5369、#5370）；10-22 的 `[sandbox-hardening] Avoid loading startup files during workspace operations (#5406)` 让工作区操作不再加载启动脚本（shell rc 类文件是典型的持久化与提权入口）；依赖侧把 `mcp` 从 2.0.0 升到 2.3.0、playwright 1.50→1.63、aiohttp 3.14.3→3.14.5、fastapi ≥0.143。属维护周，无能力新增。
- 工程与产品分析：产品形态是"少抽象、贴近 OpenAI API 的 Agent 运行时"，配套 tracing 与 handoff；架构上 sandbox 仍是最活跃的工程边界——先减供应商再堵启动文件加载，说明其威胁模型从"隔离进程"细化到"隔离环境初始化"；生态 30,274 stars / 4,935 forks，pushed_at 2026-10-22T22:05Z。风险：provider 移除对已接入 Runloop 的用户是破坏性变更，且只在 commit 中体现、无 release note 承载，升级者容易漏读。
- 关键数据：v0.24.0 2026-10-15T02:20Z（窗口外）；窗口内 11 次提交（since 2026-10-18T16:00Z）；stars 30,274 / forks 4,935（[repo](https://github.com/openai/openai-agents-python)，2026-10-26 取得）。
- 原文链接：[commit 12ce34d remove Runloop provider](https://github.com/openai/openai-agents-python/commit/12ce34d)、[commit 841dfdd sandbox-hardening](https://github.com/openai/openai-agents-python/commit/841dfdd)
- 影响判断：本周的价值在信号而非功能：OpenAI 在自己 SDK 里把"沙箱初始化"当成攻击面处理，这会给下游框架设定事实基线。观察点是有无正式 release 说明 provider 迁移路径。

---

### browser-use
- 本周动态：**无新 release**（最近 0.13.13 为 2026-10-15，窗口外），窗口内仅 3 次 README 提交，但主题有工程含义：**保存的运行记录可在不逐步调用模型的情况下重放**（#6183，"rerun a saved task without calling the model on every step"），并补了重放 FAQ——保存的运行仍可能在页面快照里含密钥，重放需要相同的 `sensitive_data`（#702c737 提及的实测结论）。即把一次浏览器任务固化成可复现轨迹，模型只在必要时介入。
- 工程与产品分析：产品形态是"给 LLM 一个浏览器"的自动化层；架构上重放机制意味着动作序列与页面快照成为可持久化工件，这对回归测试、审计与成本控制都有直接价值（不必每步重推理）；生态 119,117 stars / 13,241 forks，pushed_at 2026-10-24T07:23Z。风险：快照含敏感数据的边界由使用者自行管理，官方只提示"需要同样的 sensitive_data"，没有内建脱敏，企业用于生产需自建快照清理。
- 关键数据：窗口内 3 次提交（since 2026-10-18T16:00Z）；0.13.13 2026-10-15T23:50Z（窗口外）；stars 119,117 / forks 13,241（[repo](https://github.com/browser-use/browser-use)，2026-10-26 取得）。
- 原文链接：[commit 3df5806 replay without per-step model calls](https://github.com/browser-use/browser-use/commit/3df5806)
- 影响判断：重放是浏览器 Agent 从"演示"走向"可回归测试"的关键一步，且直接压低单任务推理成本。若后续把重放产物标准化，可能成为 Web Agent 的测试基线格式。

---

### 观察池 / 静默（本周无重大公开动态）

- **LlamaIndex Agents**：无新 release，最新仍为 `v0.14.25`（2026-09-21）。默认分支在窗口内按提交 API 返回 0 条，但仓库 `pushed_at` 为 2026-10-23T13:51Z——两者矛盾，本次未取得解释（可能为非默认分支推送或镜像同步），故只记"未见默认分支公开提交"，不推断其在改什么。stars 52,662 / forks 8,428。
- **MetaGPT**：最新 release `v0.8.2`（2025-03-09），`pushed_at` 2026-01-21T10:12Z，长期停滞；stars 71,013。**背景，非本周**。
- **SuperAGI**：`pushed_at` 2025-01-22，未归档但已休眠；stars 17,715。**背景，非本周**。
- **AutoGen**：本周零动态（详见分片 04 的归档条目）。
- **Swarm**：本期未单独扫描（已由同组 OpenAI Agents SDK 覆盖其继任线），不声称其状态。

---

## 本组洞察

1. **竞争维度从"能力"移向"故障与权限"**。本周八个有料对象里，OpenClaw 做恢复与幂等、LangGraph 修 namespace 与递归上限、Dify 改 `/runs` 协议并给 sandbox 加认证 token、Agent Framework 强制 AG-UI 授权 scope 并把 Docker 参数改名 `unsafe_extra_run_args`、AutoGPT 按动作代价分级审批并让浏览器流量走 egress 代理、OpenAI SDK 禁止工作区操作加载启动文件、OpenHands 掩码表单 secret——七条独立动作指向同一个方向：Agent 平台的差异正在"出事之后能不能恢复、出事之前谁批准、凭据放在哪"这三处形成。
2. **上游退场开始重排生态位**。AutoGen 官方宣布归档（窗口外声明，本周仍无维护动作），微软把编排/MCP/A2A/AG-UI 收进 Agent Framework；同周 Hermes 上线 `hermes import-agent` 与 OpenClaw 迁移，主动接收存量用户资产。框架层的"迁移成本"正被当成竞争武器使用。
3. **配置与策略客体化**。OpenHands 把 condenser/verification/model router/skills 收进 profile；CrewAI 把上下文压缩上移为 BaseLLM 能力、Executor 转正；ADK 用小型分类器替代 LLM 做路由；Dify 让 Agent 选工作流分支。共同点是"策略从代码里被搬到可配置对象里"——这既提高可复用性，也让错误配置成为新的主要故障源。
4. **热度不等于进展，需分开记**。browser-use（119k stars）与 LlamaIndex（52k stars）本周实质动作只有文档级提交或零提交；AutoGPT 187k stars 仍是 beta。Stars 存量与本周边际变化无关，本组未取得跨期快照，故不报增速。

**下周观察点**：Hermes v0.23.0 完整 release notes 是否给出自进化评测口径；Agent Framework 的 MCP 2.x 迁移指南与 AutoGen 用户迁移路径；Dify 1.18 的 v2 快照转换在真实自建环境的反馈；browser-use 重放是否落为稳定 API。
# C 组｜浏览器 / Computer Use / 通用自主 Agent 产品（2026-10-19 ～ 2026-10-25）

- 期次：第 21 期；run_id：`e0de9bad-34c7-4686-a0e5-f6189f218841`
- 冻结窗口：2026-10-19 00:00 ～ 2026-10-25 24:00 Asia/Shanghai（下文未特别标注者为窗口内）
- 搜索入口实测 provider：`serper`（`web-search-plus/scripts/search.py -p serper`，`routing.auto_routed=false`，`cached=false`）
- 结构：每片 1—2 个对象，按主题 Prompt「统一输出模板」；窗口外材料一律标「背景，非本周」。

## 本片要点

1. **Anthropic 窗口内唯一重磅**：10 月 21 日开放 Claude Duet 研究预览——从「你发指令它执行」转向「它主动来找你」，独立 app + 云虚拟机自带浏览器；10 月 23 日补发安全/隐私专文。
2. 这是 C 组本周唯一有完整一手材料、且直接改变「通用自主 Agent 产品形态」的事件；其余对象本片后续与 part-02/03 分述。

### Anthropic Claude Duet（主动型通用 Agent，研究预览）

- 本周动态：Anthropic 于 **2026-10-21** 开放 Claude Duet 研究预览，定位「a new app where Claude works as a proactive agent」：它主动带着「需要你注意的事项」来找你，完成你交办的任务，你离开后仍继续工作，并在代表你行动前向你确认。形态为 **iOS / Android 独立 app + claude.ai**，本阶段仅限**美国 Pro / Max 订阅者**、按 waitlist 放量，额度与其余 Claude 共用、不额外计费。能力上以 **Claude Opus 5.5** 为底座，每天早上推送跨已连接应用的短简报（brief），白天每隔几小时巡检一次已连接账号，只在「需要你」时发消息；任务面从安排会议，到用数十个工具搭 dashboard、做财务/销售预测、做原型、搭 web app。工作方式的关键变化是：它有一个**带自有浏览器的虚拟机**，不依赖你的手机/电脑开机；交互是单一持续线程（可打字或语音），短回复和周级项目在同一处起步。**2026-10-23** 另发《Claude Duet Safety, Privacy, and Security》专文，同日还有 Claude Cowork 与 chat 在 Enterprise 合并的公告。
- 工程与产品分析：
  - 产品形态：把「chat 等你提问」改成「agent 先开口」。日报+巡检构成一个**常驻注意力代理**，而不是任务式 Copilot；对专业人士/小商户的场景（未付发票、排班、招聘发布、店铺运营）是「替你盯盘 + 待你批准」的混合体。明确短板：个人琐事（如订票）较弱，**当前不能展示它的浏览器画面**，且与主 Claude app 分离。
  - 工程架构：云侧 VM + 自有浏览器执行；复用 Claude 账号的 memory、skills、已连接应用（迁移成本低）；工具面接 **Claude Marketplace 6,000+ connectors/plugins**（Gmail、Slack、QuickBooks、Stripe、Gusto、LinkedIn、Docusign、HubSpot、Canva、Shopify）。凭据按 Claude Managed Agents 的设计处理，**不直接看到密码与登录 token**；动作经 auto mode classifier 审批；防 hidden instruction / prompt injection 沿用其 browser-use 研究；另设**专用分类器 + 安全 system prompt**，默认拒发信用卡号、政府证件号，健康/个人财务信息仅在明确指示下放行。
  - 生态/采用：支付走 Stripe **Link** 数字钱包（虚拟卡，不暴露真实卡号）与 Shopify **Shop Pay**；**1Password 保存的登录**为「即将支持」。早期用户为小商户与创业者（文中具名：房产经纪 Jess Provencher、餐厅 Shahs of Kabob 老板 Amin Ebrahimi、品牌策略 Mya Dalton），属**具名用户证言，非规模化采用数据**。
  - 风险/限制：红线设计值得注意——**发消息、付款、签文件、删除前必须展示待执行动作并等待批准；即使批准也不允许证券交易或账户间转账**。但仍自认「可能误读线程、误判紧急度」，后台巡检计入套餐额度、重任务更耗模型轮次，即**额度经济学尚未解**。不可见浏览器画面意味着排障与审计只能靠日志/审批卡，对企业合规是待补项。
- 关键数据：开放日 2026-10-21、范围「US Pro/Max、waitlist」、底座 Opus 5.5、connectors 6,000+（来源：claude.com 文章，2026-10-21）；安全专文 2026-10-23。
- 原文链接：[Introducing Claude Duet](https://claude.com/resources/articles/claude-duet)（2026-10-21，全文已读）；[Claude Release notes](https://support.claude.com/en/articles/12138966-release-notes)（2026-10-21 条目，已读）
- 影响判断：真正的分水岭不是「能不能点网页」，而是**默认发起权从人转向 agent**——一旦用户接受「每天一份简报 + 随时被打断」，通用 Agent 的竞争维度就从任务成功率变成「判断什么值得打扰你」与「审批粒度」。Anthropic 把不可逆动作（付款/签约/删除）与可逆动作分开，并保留证券交易硬红线，这套「分级授权」很可能被后来的消费级/商户级 Agent 抄成事实标准；接下来要看 waitlist 放量后的额度投诉、浏览器可视化的补齐，以及非美国区上线节奏。
# C 组 · part-02（2026-10-26）

### 智谱 AutoClaw（澳龙，本地化通用桌面 Agent）

- 本周动态：智谱 AI 于 **2026-10-21** 正式对外介绍 **AutoClaw（中文名「澳龙」）**——基于开源 **OpenClaw** 框架封装的本地化 AI 智能体桌面平台，支持 macOS / Windows，下载安装包后「约一分钟」完成部署，无需命令行。产品预置 **50 余项技能**，覆盖内容创作、办公自动化、编程、数据分析、金融投研；关键能力是**浏览器自动化**（官方称基于 AutoGLM 技术，可跨页面、多步骤执行信息采集、表单填写、数据导出）。默认模型为面向 OpenClaw 场景优化的 **Pony-Alpha-2**，可切换 DeepSeek / Kimi / MiniMax 等第三方模型，也支持接本地 Ollama 模型。周边生态：**飞书集成**（群内 @AI 助手下指令并收结果，Mac 一键接入），**Skill 商店**（自研 GLM Office Skills 覆盖 PPT/DOCX/XLSX/PDF/Charts），窗口内另发 10-23 的「10 月 26 日—11 月 1 日登录送 1 亿 Tokens」拉新活动。
- 工程与产品分析：
  - 产品形态：把「高权限本地 Agent」做成**消费级安装包**。定位不是聊天，而是本机上的数字员工：一条指令产出 PPT + 讲稿 + Excel 的「多产物协同」被明确作为卖点，指向汇报材料密集的团队。
  - 工程架构：本地执行 + 本地存储（官方称文件、会话、数据留在设备，仅传输必要任务描述）；继承 OpenClaw 的浏览器控制、文件读写、命令执行能力，因此**权限面本质上仍是「本机高权限」**；自进化机制（2026-04 上线）在每轮对话后复盘，生成「进化请求卡片」，用户审批后写入长期记忆——即把记忆写入做成**人工审批的写操作**。
  - 生态/采用：以 OpenClaw 开源生态为底座反向做商业封装，是本周最值得记的一笔——**开源 Agent 框架开始被大模型厂商当作分发渠道**。客户数、付费转化、企业版定价本次未取得。
  - 风险/限制：官方通篇为产品介绍，**无任务完成率、无 benchmark、无第三方评测**；「本地执行更安全」是架构属性，不等于沙箱隔离或权限最小化（同机文件与浏览器会话仍暴露）；自进化写入长期记忆若无回滚与审计视图，偏好污染会累积。GLM-5.3「内部评测较前代提升约 50%、多项公开基准开源第一」为厂商口径，未独立核实。
- 关键数据：发布/介绍日 2026-10-21；50+ 预置技能；默认模型 Pony-Alpha-2；自进化机制 2026-04 上线；GLM-5.3 于 2026-08 上线 AutoClaw（来源：autoclaw.zhipuai.cn，2026-10-21）。
- 原文链接：[智谱AutoClaw官方正版产品介绍](https://autoclaw.zhipuai.cn/blog/news/autoclaw-product-introduction/)（2026-10-21，全文已读）
- 影响判断：这是 OpenClaw 生态第一次出现「厂商级发行版」，其意义不在功能表，而在**本地 Agent 的落地摩擦从「配环境」降到「装软件」**；一旦成立，浏览器/OS 级 Agent 的竞争会从模型能力转向「技能商店 + 审批与记忆治理」。需要盯：是否有独立评测、企业私有化版本与权限模型。

### OpenAI Operator / ChatGPT Agent（含 Atlas 退场后的接续形态）

- 本周动态：**本周未取得窗口内（10-19～10-25）经原文确认的 Operator / ChatGPT Agent 重大产品动态**。已核验范围与结论：(1) 官方 ChatGPT Release Notes 页（help.openai.com/en/articles/6825453）本次 `web_fetch` 返回 200 但正文仅渲染到 2026-06-10 的模型选择器条目、其余条目因页面过大被截断（「Response body incomplete after 750000 bytes」），未能取得 10 月条目正文，故不以搜索摘要替代；(2) 独立打开的官方页面显示 Atlas 浏览器已于 **2026-07-09 宣布弃用、2026-08-09 停止服务**，其 agent 能力被重新分配到 ChatGPT 主应用与 Chrome 扩展（背景，非本周）；(3) OpenAI 的主动型助手 **dots** 于 **2026-09-29** 发布（背景，非本周）。因此本对象本周记为**观察**：形态仍在「浏览器退场、能力并入主应用 + 扩展 + 主动助手」的迁移期，但窗口内没有可引用的新发布。
- 工程与产品分析：
  - 产品形态：Atlas 作为独立浏览器产品的实验已终止，说明「自建浏览器壳」不是必要路径；能力改由宿主浏览器扩展 + 主应用承接，用户侧摩擦更低，但**权限边界从自有浏览器沙箱退回宿主浏览器**，对页面篡改与提示注入的防线更依赖扩展层策略。
  - 工程架构：本次未取得窗口内架构披露，不作推断。
  - 生态/采用：Chrome 扩展为「where available」的分发形态（依据 release notes 片段提及的扩展/sidebar 入口，属页面导航性表述，未作为版本事实）。
  - 风险/限制：产品线切换（浏览器→扩展→主动助手 dots）带来的**能力与权限口径不连续**是采购方最实际的问题：同一「让它帮我在网页上办事」的诉求，落在三个不同入口，审计与数据留存策略并不一致。
- 关键数据：Atlas 弃用公告 2026-07-09、停服 2026-08-09；dots 发布 2026-09-29（均窗口外，作背景）；本周窗口内条目：本次未取得。
- 原文链接：[ChatGPT release notes](https://help.openai.com/en/articles/6825453-chatgpt-release-notes)（200，正文截断，未取得 10 月条目）；[Introducing dots](https://openai.com/index/introducing-dots/)（2026-09-29，背景）
- 影响判断：OpenAI 事实上承认「浏览器不是护城河，入口才是」，把 agent 塞回用户已在用的浏览器与 IM 式主动助手；这对 C 组的含义是：**通用 Agent 的竞争焦点从「能不能操作网页」转到「在谁的宿主里操作、由谁审批」**。下一步看 dots 是否与 Chrome 扩展打通、以及扩展侧对支付/登录的权限模型。
# C 组 · part-03（2026-10-26）：其余固定对象核验与观察

> 本片对象均为**本周无重大公开动态**或仅**间接观察**；逐条写明核验范围与原因，不以热度当进展。

### Google Project Mariner / Gemini Agent
- 状态：**本周无重大公开动态（观察）**。核验范围：`serper` 检索「Project Mariner / Gemini agent 2026-10」；Google Cloud 官方博客「Gemini at Work 2026: Introducing Gemini agent」为 **2026-10-08**（窗口外，背景）；Gemini Enterprise Agent Platform release notes 检索结果为模型弃用排期（Gemini 2.5 Flash Image 退役延至 2027-03-15），非 agent 产品更新。第三方资料称 Mariner 作为独立产品已于 **2026-05-04** 关停、能力并入 Gemini Agent 与 Chrome（第三方转述，未取得 Google 原文，**仅记录线索不作主张**）。
- 判断：Mariner 品牌已让位于「Gemini Agent + Chrome」，C 组后续应以 Gemini Agent（Chrome 内）为主责对象重设追踪口径。

### Perplexity Comet
- 状态：**本周无经原文确认的产品动态（观察）**。核验范围：`serper` 检索 Comet 10 月更新；官方 changelog（perplexity.ai/changelog）本次直接抓取返回 **HTTP 403**，`web_fetch` 未取得正文，故不以搜索摘要拼版本事实。窗口内唯一可见的官方动作是 **Privacy Notice 页面标注 2026-10-23 更新**，该页面覆盖 Comet 浏览器（仅见日期与适用范围表述，**正文未读，不作条款主张**）。
- 背景（非本周）：Comet 于 2025-09/10 全量免费开放；2026-03-18 上线 iOS、2026-08-19 上线 Android（第三方综述，未逐条核官方）；2026 年中重建 Comet Assistant、称多步任务较前代提升 23%（第三方测评转述，**未取得 Perplexity 原始披露，不采用为数据**）。
- 判断：Comet 的「免费 + 全平台」策略已把 agentic browser 变成流量入口之争；本周无新增能力，但隐私条款改动频率本身值得作为合规观察项跟踪。

### Manus
- 状态：**本周无重大公开动态（静默）**。核验范围：直接读取官方博客索引（manus.im/blog，2026-10-26 取得），最新产品文为 **2026-10-13《Manus Partners with OPPO to Bring Agentic AI Experiences to Smartphones》** 与 10-13 客户故事，均**早于窗口起点**；窗口内（10-19～10-25）无新条目。背景（非本周）：**Manus 2.0 于 2026-09-28 发布**（Cascade agent harness、Cloud Computer、Automations、Manus Studio、个人 agent 应用 Cue）；2026-10-01 增 Video Editor / Game Dev，09-29 增 Manus Flex（自带 API key）；**2026-09-01「Manus Resumes Independent Operations」**。
- 判断：Manus 的产品节奏集中在 9 月末—10 月初的 2.0 大版本，本周处于发布后消化期；Cascade harness + Cloud Computer 是它与 Duet 正面对撞的部位，值得在下周观察其任务成功率与额度政策披露。

### Genspark / 通用任务 Agent
- 状态：**本周无重大公开动态（静默）**。核验范围：`serper` 检索 Genspark 10 月动态，返回内容为产品说明与旧内容（Super Agent 帮助中心、2024-09 Autopilot Agent 发布、2025-07 OpenAI 案例 $36M ARR/45 天），无可归入窗口的发布；官方 blog 未见窗口内更新。
- 判断：Genspark 的差异化仍是「Agent + 办公套件（slides/sheets/docs）+ 构建套件」的一体化 workspace，本周无新证据改变该判断，列入观察池。

### Kimi Agent / Kimi Work（月之暗面）
- 状态：**本周无重大公开动态（静默）**。核验范围：直接读取官方资讯页（kimi.com/news，2026-10-26 取得），最新条目为 **2026-09-21 Kimi Code Desktop 正式发布**、09-17 金融行业方案、09-10 企业合作伙伴计划（华胜天成、金山云、亚康股份、亚信科技、中软国际已签约）；窗口内仅见 **10-24「NO GENRE Night Talk」线下活动**（招聘/品牌活动，非产品）。另：站内功能导航已列「Kimi Claw」，**未取得其发布日与能力原文，不作主张**。
- 判断：Kimi 的通用 Agent 叙事正从「Kimi Agent / OK Computer」转向**企业版 + 行业方案 + 伙伴 FDE 队伍**，C 组应把「Kimi Work 目标模式（官方称可连续工作 24 小时，2026-06-18）」纳入下周能力核验清单。

### Qwen Agent（阿里通义）
- 状态：**本周无重大公开动态（静默）**。核验范围：`serper` 检索中文「Qwen 智能体 2026 年 10 月」；命中为阿里云产品月刊（2026-01）、模型上下架文档（Qwen3.8-2.4T-A95B，2026-08）、**Qwen3.7-Plus 多模态智能体（2026-05-31/06-02，含 GUI 操作 + CLI + 自验证统一）**，均窗口外；窗口内无 agent 产品发布。
- 判断：Qwen 的 agent 能力主线仍是「模型层统一 GUI/CLI 操作」（Qwen3.7-Plus 路线），产品化入口（千问 App / 夸克）本周无新证据，列观察。

### 本组洞察（2026-10-19 ～ 10-25）

1. **形态分水岭：从「你下令」到「它来找你」。** Claude Duet（10-21）把通用 Agent 的默认发起权交给模型，配套的是「不可逆动作必须审批 + 证券交易硬红线」的分级授权；AutoClaw（10-21）则把高权限本地 Agent 做成安装包，并用「进化请求卡片」把长期记忆写入变成人工审批。两条路线的共同点是：**审批粒度与记忆治理，已经比任务成功率更决定能不能真用**。
2. **浏览器不再是产品，是宿主。** OpenAI 关停 Atlas 后把 agent 能力并入主应用 + Chrome 扩展 + 主动助手 dots（均为窗口外背景），Anthropic 让 Duet 用云 VM 自带浏览器且暂不展示画面。自建浏览器壳的试验价值在下降，**权限与审计落在谁的宿主上**才是采购问题。
3. **开源框架成了厂商发行版的底座。** AutoClaw 基于 OpenClaw 封装，是中国大模型厂商第一次把开源 Agent 框架变成自有分发渠道；这对 B 组（OpenClaw 生态）是需求侧信号，对 C 组则是「本地高权限 Agent 消费化」的开端。

### 本组覆盖与缺口（如实）

- 有料（≥200 字深度条目）：**2**（Claude Duet、智谱 AutoClaw）。
- 观察/静默并写明核验范围：**6**（OpenAI Operator/ChatGPT Agent、Google Project Mariner/Gemini Agent、Perplexity Comet、Manus、Genspark、Kimi、Qwen —— 其中 OpenAI 与 Google 计入观察，其余静默；计数按对象条目）。
- 覆盖：固定对象 7 类全部过一遍，实质覆盖约 **2/7 有本周增量（≈29%）**，未达 80% 目标，原因是本周确为发布淡季（多数厂商动作集中在 9 月末—10 月上旬的 2.0/大版本窗口外），非检索放弃；已在各条列明核验入口。
- 未取得：OpenAI 官方 release notes 10 月条目（页面 750KB 截断）、Perplexity 官方 changelog（403）、Google Mariner 关停原文（仅第三方转述）、Kimi Claw 发布原文、各产品任务完成率/客户数/定价（多数未公开）。
# D组 · 企业/垂直 Agent + 协议/评测/基础工程（第 21 期）

- 本期冻结窗口：2026-10-19 00:00 ～ 2026-10-25 24:00（Asia/Shanghai）
- 研究主责：黄山（wairesearch）；run_id: e0de9bad-34c7-4686-a0e5-f6189f218841
- 搜索入口：web-search-plus 2.8.1，provider 实为 `serper`（`routing.auto_routed=false`），复核正文用 `web_fetch` / Tavily raw_content / arXiv API
- 证据口径：按 industry-research-evidence 逐主张分级；窗口外内容一律标「背景，非本周」

## 一、企业/垂直 Agent

### Sierra
- 本周动态：**本周无重大公开动态**。核验范围：sierra.ai/blog 官方博客列表（截至抓取时最新为 2026-10-06 的 Summit 回顾）、Serper 按「Sierra AI agent news week October 20 2026」检索（《Sierra and Meta Announce Open Standard…》实为 10 月 6—7 日稿件，非本周）。因此本周（10/19—10/25）Sierra 本体无新发布。**背景，非本周**：Sierra 在 10 月 6 日 Summit 上与 Meta 联合发布 Personal Agent Protocol（PAP），并在 9 月 30 日成为 OpenAI Marketplace 首发伙伴，主打 results-based（按结果）计费。这两条是本周观察其企业落地节奏的前提，但均不在窗口内，不作本周动态计入。
- 工程与产品分析：
  - 产品形态：面向企业客服/客户体验的「Agent as a Service」，卖点是按解决结果计费而非按 token；Ghostwriter 让业务方用自然语言生成并持续优化 Agent，把交付物从「一个 bot」变成「可运营的 Agent 资产」。
  - 工程架构：Agent OS + Agent Data Platform（ADP）承载跨渠道会话与记忆；PAP 的设计意图是让企业侧 Agent 与「个人 Agent」在用户授权下互通，本质是把身份、授权、上下文交换做成协议层问题——这与 MCP 正在推进的 agent identity 方向同构，但 PAP 目前只有公告级材料，未见规范正文与实现细节。
  - 生态/采用：据 Sierra 2026-02-06 年报博客自述 ARR 超 1.5 亿美元；本轮未取得更新的客户数、留存或毛利率数据（本次未取得），也未独立核实 ARR 口径。
  - 风险/限制：结果计费对「结果」定义高度敏感，容易出现归因争议；跨企业—个人 Agent 的协议若无强制身份校验，实际会放大钓鱼与越权面（参见本组 AgentPhishing 条目）。
- 关键数据：ARR >$150M（Sierra 官方博客，2026-02-06，公司自述，未独立核实）；PAP 发布 2026-10-06（sierra.ai/blog/introducing-personal-agent-protocol）。
- 原文链接：https://sierra.ai/blog ；https://sierra.ai/blog/introducing-personal-agent-protocol
- 影响判断：Sierra 本周静默属发布节奏问题，不是需求转弱信号；真正值得跟踪的是 PAP 能否拿到除 Meta/Genesys/NiCE 之外的第三方实现——协议只有被非发起方实现才算标准。

### Glean
- 本周动态：**本周无重大公开动态**。核验范围：glean.com/press 新闻室全量列表（最新 press release 为 2026-10-13「Appoints Francesca Moore to Lead Australia and New Zealand」，早于窗口）、Serper 按「Glean news October 22 2026」检索无窗口内条目。**背景，非本周**：8 月 26 日 Glean:GO 发布 Tau 桌面工作区与「上下文优于模型」路线，主打用企业上下文把 token 成本压下来（对 Anthropic 客户账单偏高的公开批评即出自该轮）；9 月起铺全球伙伴网络。
- 工程与产品分析：
  - 产品形态：从企业搜索升级为「Work AI」平台：搜索 + 助手 + Agent 构建 + 桌面端 Tau，卖点是跨 SaaS 的权限感知上下文层。
  - 工程架构：核心是连接器 + 权限镜像 + 混合检索 + 自建上下文/记忆层，再向上暴露 Agent 生命周期管理（5 月的 Enterprise Agent Development Lifecycle）与远程 MCP server；架构选择等于把「谁能看到什么」做成平台底座，而不是交给每个 Agent 自己处理。
  - 生态/采用：据 TechCrunch 2026-05-28 报道 ARR 超 3 亿美元、15 个月增两倍（媒体援引公司披露，未独立核实）；伙伴网络与 MCP 生态是其企业分发主路径。
  - 风险/限制：权限镜像一旦与源系统漂移，就会出现「检索到了但本不该看到」的越权；上下文层越厚，Agent 行为越难归因到具体文档版本。成本叙事依赖自建小模型与缓存策略，可复制性取决于企业数据治理成熟度。
- 关键数据：ARR >$300M（TechCrunch，2026-05-28，援引公司，未独立核实）；Tau 发布 2026-08-26（glean.com/press）。
- 原文链接：https://www.glean.com/press
- 影响判断：Glean 的静默期正好落在 MCP 推进 agent identity 的同一周，说明「上下文层」竞争已从检索质量转向身份与治理；下一阶段看它是否把 MCP 授权扩展（企业托管授权）作为默认路径。
# D组 第 21 期 · 分片 02

## 二、垂直 Agent

### Harvey（法律垂直 Agent）
- 本周动态：Harvey 于 10 月 19 日前后发布 Harvey Graph（官方博客《Improving Agent Accuracy With Harvey Graph》，Serper 返回「6 days ago」，原始 URL 已读全文），把「上下文」从检索问题升级为数据结构问题。要点：Harvey Graph 不是单一产物，而是多个专用图的集合——（1）知识图谱：覆盖全美判例（所有联邦地区/上诉法院与 50 州，官方称数百万份判决），抽取「谁引用谁、案件被如何对待、哪条推理线仍成立」；（2）上下文图谱：按 Space 组织的私有图，把 matter、文档、Vault 与集成之间的关系连起来，包括「某文件是后来的第 4 稿且已被取代」「另一个 matter 里同名主体是同一实体」这类隐性关系。两者都自动继承 Space 的治理与伦理隔离（ethical wall）设置，用户无需启用或管理。同一周该领域还有两件配套动作：10 月 23 日 Artificial Lawyer 周报披露 Mary Technology 的事实调查能力以 connector 形式接入 Harvey（Harvey Connector Library 已连多家法律科技公司）；Harvey 与 Artificial Lawyer 将于 11 月 2 日办「Agents in Legal」实操 webinar。**背景，非本周**：Harvey 首个后训练开源权重模型 Tenet（Kimi K3 底座 + Fireworks 异步 RL）发布于 8 月 20 日。
- 工程与产品分析：
  - 产品形态：从「法律 AI 助手」转为「法律工作编排层」：主 Agent 负责规划调度，专用 custom agents 在后台执行，用户不选不配；Harvey Graph 让 Agent 在提问前就带着 matter 上下文与先例起步，直接目标是消灭「每次重新交代背景」的仪式。
  - 工程架构：明确否定纯向量检索——官方指出 flat retrieval 只找段落不找关系，Agent 每次任务都要重新发现实体与交叉引用，白烧 token。做法是离线推断关系→对源校验→随业务变化持续维护，运行时把图交给 Agent 做多跳检索（取权威→顺引用外扩→查案件被对待情况→回检自身答案）。治理上，图跟随 Space 权限而非另建一套，这是企业可用性的关键设计。
  - 生态/采用：官方披露 LAB 实验：带上下文图的 Agent rubric 通过率最高 +30%，任务成本下降约 50%；某 firm-knowledge 任务中，无图版本挑错先例（0% rubric），有图版本直接命中（75%）。用户侧：用户记忆 GA 后调研称 93% 认为记忆让 Harvey 更有用、50% 表示重复交代上下文变少（均为公司自述，样本与方法未披露，未独立核实）。客户数、席位与单价本次未取得。
  - 风险/限制：图的正确性风险高于检索——一旦把「哪一版有效」「是否已被推翻」推断错，错误会随图扩散到所有下游任务且更难发现，因此官方把「对源校验」列为工程难点是对的；其次是维护成本（数百万文档的关系持续更新）与权限继承的一致性（伦理隔离若与源系统漂移即为越权）。评测为厂商自建 LAB + 自评，属 B 级披露。
- 关键数据：rubric 通过率 +30%、成本 −50%（harvey.ai 博客，2026-10 第 3 周，公司实验，未独立核实）；US Case Law 覆盖「数百万份判决、50 州 + 全部联邦地区/上诉法院」（同上）；用户调研 93%/50%（同上）。
- 原文链接：https://www.harvey.ai/blog/improving-agent-accuracy-with-harvey-graph ；https://www.artificiallawyer.com/2026/10/23/grok-top-for-contracts-al-on-hols-harvey-agents/
- 影响判断：这是本周企业/垂直 Agent 最重要的一条工程信号——法律 AI 的竞争焦点从「模型多强」转到「开工前知道多少」，且解法是图 + 权限继承 + 运行时多跳，而不是更长上下文。可复制到审计、投行尽调、医药注册等强关系型文档场景；不成立的前提是企业没有稳定的 matter/版本/主体主数据。
# D组 第 21 期 · 分片 03

### ServiceNow Arc（个人常驻企业 Agent）+ NVIDIA OpenShell 执行层
- 本周动态：2026 年 10 月 21 日 GTC Berlin，ServiceNow 宣布个人常驻 Agent **Arc 正式 GA**：用户给目标而非步骤，Arc 自行规划、跨企业系统执行、自检并调整，跨度可以是「几分钟到几天」；会主动从待办、收件箱、会议与对话中捞出待办/待审批/需跟进项；缺少集成时能自己现搭连接器，且限定在同一 OpenShell 边界内运行；带记忆与技能累积；推理上「本地优先」——日常任务用 NVIDIA RTX Spark 上的本地模型，难任务再调前沿模型。定价上 Arc 不单独收费，随 EmployeeWorks 的 Foundation / Advanced / Prime 三档 SKU 提供；平台先 Mac，Windows 在数周内。同日 NVIDIA 发布 **OpenShell 参考架构**（企业可在软件与硬件层于数秒内撤销 Agent 访问权）。治理叙事是「一次定义、处处执行」：IT 在 Super Intelligence Control Tower 定策略，OpenShell 在运行时执行，可细到「禁止写生产系统但允许 Agent 继续其余工作」。**关键限定**：承载「1 秒级撤销」「硅上执行」「精确隔离」的 **AI Passport 属未来版本**，官方可用性段落明确写「expected to be available in a future release」；已发布材料未给测试条件、Agent 数量、网络假设与测量方法，也无第三方复现。
- 工程与产品分析：
  - 产品形态：不是聊天机器人，也不是固定流程 bot，而是「目标常驻 + 主动发现工作 + 自建集成 + 跨会话记忆」的个人工作 Agent；风险与价值同源——它能用真实凭据走每一步，还能长出新行为。
  - 工程架构：三层治理（Control Tower 的动作级策略 → OpenShell 软件层 sandbox 执行与审计 → BlueField DPU 上 Sentry 的硬件信任根），叠加 AI Passport 作为「网关凭证」：官方描述它是签发给每个 Agent、MCP server 等受管资产的背书记录，携带决策逻辑、供应商风险、风险容忍度、可访问外部服务等业务上下文，供编排与执行时校验。这套设计与 MCP 正在推进的 DPoP/Workload Identity Federation 属同一问题域的两条路径（专有凭证 vs 开放协议），未来极可能冲突或互认。
  - 生态/采用：NVIDIA 侧称 Anthropic、AWS、Cisco、CrowdStrike、Dell、Google Cloud、HPE、IBM、Meta、Microsoft、OpenAI、Palo Alto、Perplexity、SAP、ServiceNow、Siemens 等「正在合作」，1Password、Okta、Zscaler 等安全厂商称在集成——「合作」不等于部署，属意图广度证据。Arc 的真实装机量、活跃率、留存本次未取得。
  - 风险/限制：（1）安全故事的一半在 roadmap，采购应按「已 GA 的 OpenShell 策略执行」验收，不能按 1 秒撤销验收；（2）自建连接器是策略绕过面，官方只承诺「在同一边界内跑」，未说明构建期如何防越权取数；（3）记忆本身是敏感数据，官方未披露留存与删除策略——这与本组 AfterDeleteBench 的结论直接对撞；（4）Control Tower 不可达时的失败模式（停机 / 用缓存策略 / 无限制运行）未公开。
- 关键数据：Arc GA 2026-10-21；随 EmployeeWorks Foundation/Advanced/Prime 提供，无额外费用（ServiceNow 新闻稿，经 explainx.ai 2026-10-21 全文核对，未独立核实）；AI Passport 与硬件执行「未来版本」（同上）；OpenShell 参考架构「数秒内撤销」为 NVIDIA 自述（globenewswire 2026-10-21）。
- 原文链接：https://explainx.ai/blog/servicenow-arc-ga-personal-enterprise-agent-nvidia-openshell-ai-passport-revocation-one-second-2026 ；https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-delivers-industry-first-personal-enterprise-agent-and-policy-enforcement-with-NVIDIA-extending-AI-governance-across-software-and-silicon/ （官方页 Cloudflare 403，正文经镜像与第三方核对）
- 影响判断：本周企业 Agent 的分水岭不是「又多了个个人 Agent」，而是治理下沉到运行时与硬件——身份凭证 + 执行边界 + 可撤销性正在成为独立产品品类（Workday 收购 ConductorOne 同向）。采购判断应盯「今天能强制什么」，而不是发布会上的撤销时延。

### Salesforce Agentforce / Microsoft Copilot Agents
- 本周动态：**本周无重大公开动态**。核验范围：Salesforce news 检索（窗口内无 Agentforce 新稿，最近为 8 月 24 日 SalesforceBen《伙伴未看到 Agentforce ROI》与更早的 360 开放构建者）；Microsoft 侧窗口内仅有 Partner Center 月度公告与 10 月 1 日 M365 计费类更新，未见 Agent 治理/运行时能力发布。**背景，非本周**：Agentforce 的 ROI 争议与 Copilot 的 agent 治理（2026 Wave 1 管理控件）是既有线索，本周无增量。
- 原文链接：https://www.salesforce.com/news/news-explorer/ ；https://learn.microsoft.com/en-us/partner-center/announcements/2026-october
- 影响判断：两家本周静默，恰好把话语权让给 ServiceNow 的「治理下沉」叙事；下一观察点是 10 月 28 日 ServiceNow Q3 财报能否给出 AI ACV 与 Arc 采用的可核数字。
# D组 第 21 期 · 分片 04

## 三、平台与协议

### 字节 Coze / 扣子
- 本周动态：**本周无重大公开动态**。核验范围：官方更新日志 docs.coze.cn/recent-updates（最新条目仍停在「2026 年 07 月 · 豆包渠道下架」，即 7 月 1 日下线低代码智能体发布至豆包渠道；其后无 8—10 月条目）、Serper 中文检索（窗口内仅出现百科/导流类《扣子AI是什么》稿，无产品发布）。**背景，非本周**：2026 年 6 月扣子 3.0 上线并宣称支持 OpenClaw 等外部运行形态；平台侧近期能力集中在企业治理面——企业商店分发、企业插件商店、多组织、成员积分额度与用量明细、单次调用积分明细、SSO、私网连接、记忆库（按 UID+渠道 ID 隔离）等，均为既有功能。
- 工程与产品分析：
  - 产品形态：低代码智能体/工作流 + 应用搭建 + 插件/MCP 工具生态，客群从个人开发者延伸到企业版（订阅套餐 + 积分按量混合计费）。
  - 工程架构：MCP 双向使用（内置 MCP client 把外部服务包成插件；把自家付费插件封装成 MCP 工具给 Cursor/Trae/Claude 调用）；记忆库走「统一写入 + 多库隔离 + 可绑定多智能体共享」；异步工作流与批量任务支撑长任务。
  - 生态/采用：国内渠道分发（含中兴、荣耀、联想应用商店）与火山引擎私网/知识库/数据库绑定是其企业落地主路径；付费客户数、调用量本次未取得。
  - 风险/限制：文档显示自定义模型接入支持「明文存储鉴权密钥」（2025-11 条目），企业采购需确认是否强制 KMS/密文；长期无更新日志也意味着能力边界以既有版本为准，不宜按发布会口径规划。
- 关键数据：最近更新 2026-07-01（docs.coze.cn/recent-updates）；扣子 3.0 发布 2026-06（新浪科技 2026-06-02，媒体转述）。
- 原文链接：https://docs.coze.cn/recent-updates
- 影响判断：扣子进入「治理与企业分发补课」阶段而非能力冲刺，与海外同期的身份/审计叙事同向；对国内方案选型而言，真正的差异点已从「能不能搭」变成「权限、计费与审计能否过关」。

### MCP 协议与工具生态
- 本周动态：**协议本体本周无新规范发布**，但工程侧有可核活动。核验范围：MCP 官方博客（最新两篇为 8 月 22 日《The New MCP Roadmap》与 7 月 28 日规范发布，均早于窗口）、规范仓库 commit（10 月 20 日合并 Tasks/Events 工作组范围与 Agents IG 名册修订，10 月 23 日修订维护者信息）。**背景，非本周**（但决定本周所有企业 Agent 讨论的坐标系）：2026-07-28 规范取消了协议级 session 与初始化握手（SEP-2575/2567），改为 server/discover 先探能力、list 结果可缓存（SEP-2549）；Tasks 退为官方扩展（SEP-2663），以 Multi Round-Trip Requests（SEP-2322）替代服务端发起请求；授权侧引入 issuer 校验、issuer-bound client credentials、CIMD，企业托管授权（Enterprise-Managed Authorization）已成稳定扩展；8 月 22 日新路线图把「Agent 身份与企业级安全」列为五大优先域之一，明确要做 DPoP、Workload Identity Federation、ID-JAG 与标准 token exchange。
- 工程与产品分析：
  - 产品形态：MCP 已从「工具调用协议」变成 Agent 的 HTTP 级数据与交互底座；官方称 Tier 1 SDK 月下载近 5 亿、TS/Python SDK 各自累计破 10 亿（8 月博客自述）。
  - 工程架构：无状态化是分水岭——服务端可水平扩展、可被当普通 HTTP 负载托管；代价是原本靠 session 承载的交互（elicitation、进度、长任务）必须改造成 MRTR + Tasks + subscriptions/listen，客户端实现复杂度上升。下一阶段两个硬点：结果类型统一契约（tools/call 同一输出多种形态导致客户端行为不可预期）、渐进式发现（百工具服务器在提问前就吃掉上下文且选择质量下降）。
  - 生态/采用：路线图由 Core Maintainers + 多个 WG 推进，SEP 优先级与路线图绑定——不在五域内的提案仍可提交但排队更久，这实际是治理层的资源分配信号。企业侧出现分叉：ServiceNow 用专有 AI Passport 做「Agent/MCP server 的背书记录」，与 MCP 的开放身份路线并行，短期会并存、长期看谁被非发起方实现。
  - 风险/限制：授权仍以「人在浏览器里点同意」为默认，云上无人值守 Agent 与子 Agent 委派是缺口；无状态化后重放与幂等需要应用层自建；工具面膨胀带来上下文成本与选择退化。
- 关键数据：规范 2026-07-28（blog.modelcontextprotocol.io/posts/2026-07-28/）；路线图 2026-08-22（modelcontextprotocol.io/development/roadmap）；本周 commit 2026-10-20、2026-10-23（gh api，仓库 modelcontextprotocol/modelcontextprotocol）。
- 原文链接：https://blog.modelcontextprotocol.io/posts/mcp-roadmap/ ；https://blog.modelcontextprotocol.io/ ；https://github.com/modelcontextprotocol/modelcontextprotocol/commits
- 影响判断：MCP 本周「安静但在长骨架」——身份与长任务两条线同时推进，2027 年前的 Agent 平台若不接 MCP 授权扩展，就得自建一套等价的凭证与撤销体系。判断标准不是它发了什么版本，而是有没有非发起方在生产里实现 agent identity。
# D组 第 21 期 · 分片 05

## 四、评测与论文（窗口内 arXiv 直读）

### Ivo × micro1 ContractBench（法律合同审查）
- 本周动态：10 月 23 日 Artificial Lawyer 周报披露，法律 AI 公司 Ivo 与数据实验室 micro1 共建 ContractBench，用 350 个真实合同审查任务测 7 个前沿模型「能否做出与资深律师相同的判断」，评估维度包括问题优先级、修改是否恰当、以及是否识别出必须转人工的情形。结果：**7 个模型在律师定义加权标准上全部低于 60%**，最高仅 58.3%（Grok 4.7），其后 Opus 5.5 58.1%、Kimi K3 57.1%。更关键的差异不在分数而在完成率与成本：Opus 完成率 80.8%，Grok 99.5%，Kimi 100%；Kimi 每次完成 rollout 的成本比 Grok 低 38%、速度快 13%。Artificial Lawyer 的判断是：复杂法律工作想超过中等成功率，必须有贴合事项的参考数据、规则手册与先例，以及能纠正首轮输出的细致监督。
- 工程与产品分析：
  - 产品形态：不是模型排行榜，而是「能否替代律师判断」的能力闸门；350 任务 + 律师定义 rubric 的设计让「看起来对」与「法律上对」分开。
  - 工程架构含义：完成率 80.8% vs 100% 的差距说明部分模型的失败是「压根没交付」，工程上等于 Agent 的终止与自检环节缺失——这与本组 Harvey Graph、ServiceNow Arc 强调的「自检/回检」同源。成本口径按「完成一次」而非「每 token」计算，是正确的企业口径。
  - 生态/采用：Ivo 为商业法律 AI 厂商，benchmark 自带商业动机；micro1 提供数据与标注。属厂商自建评测，未见第三方复现。
  - 风险/限制：样本 350 且任务分布未公开；「律师定义加权标准」的权重与标注者一致性未披露；单轮结果不能外推为生产可用率。属 B 级披露，引用须带口径。
- 关键数据：350 任务 / 7 模型 / 最高 58.3%（Ivo 公布，Artificial Lawyer 2026-10-23 报道，未独立核实）；Kimi K3 成本 −38%、速度 +13%（同上）。
- 原文链接：https://www.artificiallawyer.com/2026/10/23/grok-top-for-contracts-al-on-hols-harvey-agents/ ；https://www.ivo.ai/research/ivo-micro1-contractbench
- 影响判断：法律 Agent 的真实天花板是「判断质量 + 交付完整性 + 单件成本」三者的乘积，不是 rubric 分数；这也解释了为何 Harvey 转向图与记忆而非换更强底座。

### EpiSEM-Bench：缺失证据下的安全与取证恢复（arXiv 2610.31650，10-22）
- 本周动态：作者提出可执行 benchmark，专门测一种被忽视的失效：工具返回的每条陈述都是真的，但**遗漏了与安全相关的关键事实**，Agent 于是执行了本应被禁止的动作——用户请求本身无害。数据集含 6 个领域、300 组「不安全/安全」配对任务，通过系统性屏蔽关键事实测量不安全执行率，并给出「最小观测失败基数」（含全证据下仍失败、以及穷尽测试后零失败两类）；配套独立审计工具检验 Agent 是否会主动追问缺失事实、并在补齐后既拒绝禁止动作又完成允许部分。
- 工程与产品分析：这把 Agent 安全从「防注入」扩到「防信息缺口」。工程含义直接：权限判定不能只依赖工具返回值，需要「缺字段即拒绝/追问」的默认策略（fail-closed），并在 harness 层记录「决策所依赖的证据是否齐全」。对 ServiceNow 式「策略在网关执行」是补强也是挑战——网关看到的是动作，未必知道模型缺了什么事实。
- 风险/限制：合成配对任务的生态效度待验证；「关键事实」的判定由作者定义，跨领域迁移未知。属预印本，未同行评审。
- 原文链接：http://arxiv.org/abs/2610.31650v1

### AfterDeleteBench：删除后的信息残留审计（arXiv 2610.31366，10-22）
- 本周动态：针对「Agent 有外部持久记忆并派生摘要」的场景，作者指出删除原始记录并不等于删除其派生信息。方法是对每个合成秘密做对照：一组 Agent 先接触再删除，另一组从未接触，其余条件匹配，从而把「删除后仍能恢复」归因于原始暴露。主实验中，**单次提问即可从 Qwen2.5-7B-Instruct 恢复约三分之二的已删秘密，而从未接触的对照组恢复率为零**；更严重的是，恢复不依赖逐字副本——即使完整秘密串已不存在，仅剩分别存储的组件（公开口径下）也能被重组。
- 工程与产品分析：这是企业「记忆删除权/被遗忘权」合规的直接技术反驳：删除 API 返回 200 不等于数据消失。工程上需要「派生血缘」（summary/embedding/结构化字段都登记来源）、级联删除、以及删除后的对抗性探测。对 ServiceNow Arc、Glean、Coze 记忆库这类「统一记忆池」产品，这是必须在采购问卷里问的项。
- 风险/限制：固定权重小模型 + 合成秘密，规模与真实企业语料差异大；恢复率随模型与提示变化，不能直接外推为大模型同等比例。
- 原文链接：http://arxiv.org/abs/2610.31366v1

### 记忆与审计的另外三篇（同窗口，简记）
- **When Is a Memory Safe Enough to Act On?（2610.31446）**：把「记忆是否要复核」定义为动作条件问题——同一条记住的地址，普通发货可直接用，贵重发货必须先确认；形式化为序贯停止问题，只有当复核能改变下一步动作时才值得付费。对长生命周期 Agent 的工程含义：记忆条目应带「动作敏感度」，而不是统一 TTL。
- **Post-Audit Mirage（2610.31130）**：给出可执行的下界结论——存在「验证器可见证据完全相同、但部署后安全性相反」的配对生命周期，因此离线审计无法区分某些更新；提出 IdentifiedRangeMonitor 输出 deploy/hold/cannot determine/unsupported 四态。含义：Agent 上线评审不能只交离线通过率，必须留「无法判定」这一档，并配在线监控。
- **AgentPhishing（2610.31404）**：针对邮件 Agent 的自适应钓鱼 benchmark，用 PhishOpt 在固定约束与真实性约束下优化可复用邮件生成技能，测的是「是否被说服去执行恶意请求」，而非单纯识别钓鱼。含义：Agent 的邮件权限应按动作分级（读/草拟/发送/付款），单靠内容分类器不够。
- 原文链接：http://arxiv.org/abs/2610.31446v1 ；http://arxiv.org/abs/2610.31130v1 ；http://arxiv.org/abs/2610.31404v1
- 影响判断：本周论文的共同指向很清楚——2026 下半年 Agent 可靠性的瓶颈已从「会不会做」转为「该不该做、凭什么做、做完能否证明」，而这三个问题都落在记忆治理与可审计性上，正好是 MCP 身份路线图与企业治理产品交汇处。
# D组 第 21 期 · 分片 06（本组洞察与覆盖台账）

## 五、本组洞察

1. **企业 Agent 的竞争焦点本周完成了一次迁移：从「模型/流程」转到「上下文结构与治理执行」。** Harvey Graph 用图 + 权限继承 + 多跳检索换来 rubric +30%、成本 −50%；ServiceNow 用 Control Tower + OpenShell + （未来）AI Passport 把治理压到运行时与硬件。两者不是同一层，但回答同一个问题——Agent 在动手之前知道什么、动手之时被谁约束。对方案架构师的含义：上下文层与策略层要分别设计，不能靠「更长的 prompt」或「更聪明的模型」合并解决。
2. **身份正在从功能变成产品品类，且出现开放/专有两路线并行。** MCP 路线图把 agent identity 列为首要域（DPoP、Workload Identity Federation、ID-JAG）；ServiceNow 走 AI Passport 专有凭证；Workday 收购 ConductorOne 同向。短期企业会遇到「每家一个 passport」的碎片化，选型时应要求凭证可撤销、可审计、且不绑定单一 Agent 厂商。
3. **「删得掉、查得到、说得清」成为企业采购的硬门槛。** AfterDeleteBench 证明删除原始记录后单次提问可恢复约 2/3 秘密，Post-Audit Mirage 证明离线审计存在原理性盲区，EpiSEM-Bench 证明「真话但不全」也能诱发越权。三条合起来，等于要求供应商提供：派生数据血缘 + 级联删除 + 上线后在线监控 + 「无法判定」状态。本周没有任何一家企业 Agent 厂商在这三项上给出完整公开材料（本次未取得）。
4. **垂直 Agent 的真正护城河是「交付完整性 × 单件成本」，不是 benchmark 分数。** ContractBench 里 7 个模型全部 <60%，且完成率从 80.8% 到 100% 不等；Harvey 的应对不是换更强底座，而是把 firm knowledge 内化进参数记忆（token 降 58%、单查询成本降 90%，公司自述）。这提示：垂直 Agent 的 ROI 叙事正在从「替代人力」转为「减少重复交代与返工」。
5. **协议层进入「安静长骨架」期。** 本周 MCP 无新规范，只有工作组 commit；Coze 更新日志停在 7 月。这不代表生态停滞，而是标准与平台都在为身份、长任务、渐进发现做结构性改造——下一个可见爆发点应是 Tasks 扩展进规范与 agent identity 的首次跨厂商实现。

## 六、覆盖台账（本组）

- 对象清单与状态：
  - 有料（6）：Harvey（Graph，本周）、ServiceNow Arc + NVIDIA OpenShell（本周）、Ivo×micro1 ContractBench（本周）、MCP 工具生态（工程活动，非规范发布）、arXiv 记忆/审计/安全四篇（本周）、评测方法学（Post-Audit Mirage 等）。
  - 观察（1）：Salesforce Agentforce（窗口内无新稿，ROI 争议延续）。
  - 静默（5）：Sierra、Glean、Microsoft Copilot Agents、字节 Coze/扣子、SWE-bench/OSWorld/WebArena/GAIA/τ-bench（未见本周新纪录或新版本，leaderboard 未刷新）。
- 来源计数：已读原始/一手页面 9 个（sierra.ai/blog、glean.com/press、harvey.ai 两篇博客、artificiallawyer 10-23、explainx 10-21、newsroom.servicenow 官方 URL（403，经镜像核对）、blog.modelcontextprotocol.io 两篇、docs.coze.cn/recent-updates）；API/结构化入口 3 类（Serper、Tavily raw_content、arXiv API + gh api commits）。
- 缺口与局限：
  - ServiceNow 官方新闻稿页 Cloudflare 403，正文经 explainx.ai 全文与 Serper 摘要交叉核对，关键可用性表述（AI Passport 属未来版本）已双处一致；未取得 ServiceNow 一手 PDF/IR 材料。
  - Harvey、Ivo、Sierra、Glean 的数字均为公司自述或厂商自建评测，未独立核实；客户数、单价、留存普遍未披露（写「未取得」）。
  - Sierra PAP、Harvey Tenet、MCP 2026-07-28 规范与 8-22 路线图、Coze 3.0 均为窗口外，已标「背景，非本周」，未计入本周动态。
  - 未做 GitHub stars/增速统计（本组对象非开源项目主导，MCP 仓库仅取 commit 证据），故无跨期快照可报。
- 规则版本：cron-run-reliability + research-contract + industry-research-evidence + weekly-agent-report + _reader-positioning 已完整读取；SHA 由父级合同登记。
- 写权声明：本组仅写 `D组-2026-10-26*` 与 `units/D组-2026-10-26*.done`，未触碰其他组、母稿与博客。
## 六、下周观察点

1. **自治等级是否会标准化**：Claude Duet 的「不可逆动作必须审批 + 证券交易硬红线」与 AutoGPT 的「按动作代价分级」是否被其他框架抄成通用语义；Replit auto-publish 是否公开拦截率与回滚数据。
2. **身份凭证的两条路线谁被非发起方实现**：MCP 的 DPoP / Workload Identity Federation / ID-JAG，与 ServiceNow AI Passport 专有凭证；Workday 收购 ConductorOne 后续整合。
3. **MCP Tasks 扩展是否进规范**：无状态化后 MRTR + Tasks + subscriptions/listen 的客户端实现成熟度；工具面膨胀下的渐进式发现。
4. **Hermes v0.23.0 是否给出自进化评测口径**；Agent Framework 的 MCP 2.x 迁移指南与 AutoGen 用户迁移路径。
5. **Dify 1.18 v2 快照转换在真实自建环境的反馈**；browser-use 重放是否落为稳定 API。
6. **企业侧可核数字**：ServiceNow Q3 财报（AI ACV / Arc 采用）、Harvey/Glean/Sierra 的客户数与单价是否披露。
7. **记忆删除与审计的工程化**：是否出现供应商提供「派生数据血缘 + 级联删除 + 在线监控 + 无法判定状态」的完整公开材料。

## 七、覆盖与取证审计（父级汇总）

- **时间窗**：2026-10-19 00:00 ～ 2026-10-25 24:00 Asia/Shanghai，已冻结并对齐四组；窗口外材料一律标「背景，非本周」。
- **固定对象覆盖**：A 组 9/9 核验（有料 5、结构性有料 2、观察 2、静默 1）；B 组 15 个已扫描（有料 9、观察 2、静默 4）；C 组 7 类全过（有料 2、观察 2、静默 5），实质覆盖约 2/7 有本周增量（≈29%，本周确为发布淡季）；D 组 12 项（有料 6、观察 1、静默 5）。A、B、D 达到或接近 ≥80% 覆盖目标；C 组未达目标，原因与核验范围已如实登记。
- **原文取证**：拟采用动态均尽力打开原始来源（官方 changelog/docs/博客、GitHub release notes、arXiv、benchmark 页）并标 URL + 日期；GitHub 数据经认证 GET（login=wujiaming88）直查，stars 为 2026-10-26 快照，无跨期快照故不报周增速。
- **风险导向抽查（5 个高影响对象）**：Claude Duet（TOP5）、Harvey Graph 数字口径（TOP5，公司自述）、ServiceNow Arc 的 AI Passport 可用性限定（TOP5，官方页 403 → 镜像 + 摘要双处核对）、Claude Code 2.1.309 安全修复项（权限主线）、AutoGen 归档的 `archived` 字段矛盾。抽查为定向选样，非随机抽样。
- **未取得/局限**：Cursor 官方 changelog 无条目日期；OpenAI release notes 与 Perplexity changelog 正文不可得（750KB 截断 / 403）；Replit 效果主张与各产品完成率/客户数/定价多数未公开；LlamaIndex 提交数为 0 与 `pushed_at` 矛盾未解释；ADK v2.13.0 版本日期列表与正文不一致；CrewAI/ADK 的 “jev” 未取得统一说明；Harvey/Sierra/Glean/ContractBench 数字均为公司自述或厂商自建评测，未独立核实。
- **已隔离矛盾（不采用）**：第三方「Aider 2026-10-22 发布 V2 2.1.3」（与 PyPI/GitHub 原始记录矛盾）；benchlm「Claude Opus 5 96%」（不可核实）；第三方 Mariner 关停转述（无 Google 原文，仅记线索）。
- **判定**：局部欠证与覆盖缺口已按共同标准限述/隔离/归因，未出现仍拟发布的重大无源或虚假事实、无可解的核心矛盾、无隐私或授权风险，母稿可冻结并进入文章流程，局限随文披露。
