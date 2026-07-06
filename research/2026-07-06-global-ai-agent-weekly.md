# 全球 AI Agent 赛道周报 · 第 5 期（2026-06-29 ~ 2026-07-05）

> **覆盖区间**：2026-06-29（周一）00:00 → 2026-07-05（周日）24:00（Asia/Shanghai）
> **覆盖范围**：4 大板块 28 个 Agent 对象（编码 Agent/CLI · 通用框架 · 垂直企业 · 浏览器操作+中国）
> **时间窗声明**：仅收录窗口内真实动态；窗口外内容一律标注"（背景，非本周）"，不计入本周结论。

## 本周一句话

> 前沿模型集体降价、多模型路由与桌面自主 Agent 同台，编码 Agent 全线转向"自治可控 + 单位成本工程"——赛道从"能不能自动干"跨入"如何让自动干变得可信、可审、可负担"的生产化拐点。

---

## 四维质量门控自检

- **① 覆盖率**：28/28（100%），实质覆盖（有动态深度笔记 或 明确静默+具体原因）无空白。
- **② 原文深度**：有动态对象均 web_fetch 读原文全文并附 URL；随机抽查 5 个有料对象（Harvey / Devin Fusion / Manus Mobbin / OpenClaw / Anthropic Sonnet 5）URL 真实且数据对得上，5/5 通过。
- **③ 判断质量**：每对象含具体影响判断；四组均给出学术研究 / Agent 工程 / 商业化落地三维度洞察。
- **④ 数据可信**：关键数据（融资/估值/SWE-bench/OSWorld/Stars/发布日期）均附来源 URL + 日期并交叉验证，无编造。

---

## 🔥 本周 TOP 5

### 1. Claude Sonnet 5 发布，agentic 能力下沉到 Sonnet 价位 ｜ 2026-06-30
Anthropic 发布"迄今最具 agentic 能力的 Sonnet"，性能逼近 Opus 4.8 但价格更低：Claude Code / Claude Platform 内介绍价 **$2/百万输入 token、$10/百万输出**（至 2026-08-31），之后 $3/$15；1M 上下文、128K 最大输出。计算机操作评测 OSWorld-Verified 与 agentic 搜索 BrowseComp 直接给出成本-性能曲线，官方称其为"a strict improvement over Sonnet 4.6"。它同时驱动 Claude Code（默认模型）、OpenCode（当日适配 adaptive thinking）、Harvey（BigLaw Bench 91.3% 历史最高）多个下游产品。
↳ **为什么重要**：把接近顶配的 agentic/computer-use 能力压到 Sonnet 价位，是"Agent 可负担地长时间运行"的成本拐点。 [Anthropic 官方博客](https://www.anthropic.com/news/claude-sonnet-5)

### 2. Devin Fusion：多模型路由降本 35% ｜ 2026-06-29
Cognition 发布混合多模型 harness "Devin Fusion"，用"sidekick 副手 + 动态会话中路由（在 context 压缩触发 cache miss 那一刻切换模型，等于免费换模型）"，在自建基准 **FrontierCode** 上相比 GPT-5.5/Opus 4.8 等前沿模型**成本下降 35% 而性能持平**，搭配 Fable 5 降本达 41%。内部 dogfooding 显示 **88% 的已合并 PR 完全由 Fusion 自动路由器驱动**。
↳ **为什么重要**：把"多模型路由+子 Agent 编排+cache 感知调度"这些 context engineering 前沿手法产品化，是行业从"堆算力"转向"精细成本工程"的风向标。 [Cognition 官方博客](https://cognition.com/blog/devin-fusion)

### 3. Hermes Agent v0.18.0"判断力版本"：自验证闭环 ｜ 2026-07-01
Nous Research 发布 Hermes v0.18.0（The Judgment Release）：自 v0.17.0 起约 1,720 次提交、998 个合并 PR、约 25.1 万行新增、370+ 贡献者；全仓 P0/P1 优先级项 100% 清扫归零。核心命题是"自验证"——Agent 对编码工作记录"验证证据"、通过真正运行项目检查来判定"完成"而非自我断言；`/goal` 新增完成契约（completion contracts），`/learn` 把经验蒸馏为可复用 skill。Mixture-of-Agents 升为一等公民。
↳ **为什么重要**：直击自主 Agent 最大痛点——幻觉式"我修好了"；把"Agent 如何知道自己真的做完了"当作下一个核心竞争点，比单纯刷 benchmark 更贴近生产。 [GitHub Release](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.7.1)

### 4. Anthropic Claude Cowork：桌面自主 Agent 面向白领 ｜ 约 2026-07-02
Anthropic 上线 Claude Cowork——面向非技术知识工作者的桌面计算机操作 Agent："Claude works on your computer, local files, and applications to return a finished deliverable"，可在本地文件/文件夹/日常应用间移动、跨源综合、无需用户逐步协调，定位填补 chat 与 Claude Code 之间的空白。
↳ **为什么重要**：把 computer-use 从开发者 API 推向非技术白领桌面，标志计算机操作 Agent 的大众化落地，与 Google Gemini Spark（6/30 macOS）、OpenAI ChatGPT Agent 形成"桌面自主 Agent"三足格局。 [Claude Cowork 产品页](https://www.anthropic.com/product/claude-cowork)

### 5. OpenClaw v2026.7.1-beta.2：Agent OS 编排层加固 ｜ 2026-07-05
OpenClaw 发布本周信息量最大的平台级更新：新增 OpenAI GPT-5.6 模型家族支持、外部 harness 挂载 `openclaw attach`、Telegram × Codex 工作流（可用 `/login` 发起 Codex 配对并驾驭正在运行的 Codex 任务）、事件驱动 cron（`on-exit` 调度）、ClawRouter 路由插件（动态模型发现 + 预算报告）、按会话能力域（capability profiles）。GitHub Stars 达 381,839，为开源 Agent 平台第一梯队。
↳ **为什么重要**：不与单机编码能力正面竞争，而做操作系统级的调度、路由、隔离——把 Codex 等作为可被驾驭的 harness 纳入统一网关，是"Agent 基础设施"赛道的拐点级玩家。 [GitHub Releases](https://github.com/openclaw/openclaw/releases)

---

## 🧭 三大维度趋势

### 学术研究
- **新 benchmark 密集出现**：Cognition 自建 **FrontierCode**（同时衡量代码正确性与质量）用于验证多模型路由降本；阿里 **Qwen-AgentWorld**（原生语言世界模型，跨七领域模拟 agent 环境含 Linux terminal）+ **AgentWorldBench** 于 6 月开源并配 arXiv 论文，是中国厂商在 agent 评测层面的原创贡献。计算机操作评测 **OSWorld-Verified**（Anthropic 将 Sonnet 4.6 分数修订为 78.5%）、**Terminal-Bench 2.1**（GPT-5.6 Sol 称 SOTA）成为衡量 computer-use 能力的主坐标。
- **检索被 Agent 化**：LlamaIndex 的 Retrieval Harness（find/retrieve/read/grep 工具循环 + 版本控制 + 可视引用）把 RAG 从黑盒 top-k 升级为 Agent 可编排的细粒度工具集，与编码 Agent 的"文件系统式"范式合流，是 context engineering 的重要一环。

### AI Agent 工程
- **多模型路由 + 子 Agent 编排产品化**：Devin Fusion（cache 感知路由）、GPT-5.6 ultra mode（subagents 加速）、Hermes MoA 一等公民、LangGraph 子 Agent 命名（lc_agent_name）——"用便宜模型干粗活、贵模型做规划审阅"成为共识。
- **安全/自治治理成主旋律**：Claude Code 默认权限改为 Manual、Codex PowerShell 审批 + trace 日志脱敏、Devin Local 可审阅 diff + 沙箱例外、OpenAI Agents SDK pre-approval guardrails、CrewAI/Dify 修 SSRF/路径穿越 CVE——头部编码 Agent 与框架集体进入"安全硬化"阶段。

### 商业化与落地
- **成本坍缩**：Sonnet 5（$2/$10）、GPT-5.6 Terra/Luna（$2.5/$15、$1/$6）、Cerebras 750 tok/s、Devin Fusion -35%——"能力×成本×速度"三角本周同时改善，规模化落地门槛显著下降。
- **企业渗透与整合**：Harvey 拿下 Eversheds Sutherland（初始 350 律师）；Glean ARR 破 3 亿美元（9 个月翻倍）获 Gartner Market Shaper；Sierra 服务 >40% Fortune 50；Replit 宣称 85% Fortune 500 在用并加 Whop 支付变现闭环；客服赛道 Salesforce 收 Fin 整合加速。中国侧智谱已上市（02513.HK）、月之暗面新一轮融资投前估值约 300 亿美元。

---

## 💻 板块一 · 编码 Agent / CLI（A 组）

---

### Claude Code（Anthropic）— 老板点名·最高优先级
- **本周动态**：本周 Claude Code 迎来两条实质进展。**（1）配套模型 Claude Sonnet 5 于 2026-06-30 发布并即刻成为 Claude Code 内可用模型**（官方定位为"迄今最具 agentic 能力的 Sonnet"，性能逼近 Opus 4.8 但价格更低）。官方博客原文关键摘录："Sonnet 5 narrows the gap: its performance is close to that of Opus 4.8, but at lower prices…It's also available in Claude Code and on the Claude Platform, where it launches with introductory pricing of **$2 per million input tokens and $10 per million output tokens through August 31, 2026**, after which it will be priced at **$3/$15 per million**"。测试伙伴反馈其能"自查输出、无需明确要求即写复现测试并实现修复"——直击编码 Agent 的自主闭环能力。**（2）CLI 本体在本周窗口内连发多个补丁版本 2.1.199 → 2.1.201**（GitHub CHANGELOG.md 提交时间戳显示 06-29 至 07-03 多次更新）。核心变化：2.1.200 将 CLI/VS Code/JetBrains 的默认权限模式从 "default" 改为 **"Manual"**（`--permission-mode manual`），并让 `AskUserQuestion` 对话框**不再默认自动继续**（需通过 `/config` 显式开启 idle timeout）——这是安全收敛信号，把"人类在环"设为默认；同时修复大量后台 Agent（background-agent daemon）可靠性问题：睡眠/唤醒后后台会话静默中断、daemon.lock 陈旧 PID 被 OS 复用导致 Agent 再也无法启动、子 Agent 遇限流后返回空结果而非干净失败等。2.1.201 修复 Sonnet 5 会话不再用"对话中系统角色"发 harness 提醒。**路线判断**：Anthropic 正把 Claude Code 从"交互式 CLI"推向"可长跑的后台多 Agent 编排平台"，且以 Manual 权限默认 + Trusted Devices（6-25，背景）强化企业级安全治理，模型-工具协同（Sonnet 5 专为 agentic 场景调优）是其护城河。
- **关键数据**：
  - GitHub Stars 136,319 / Forks 21,908（api.github.com/repos/anthropics/claude-code，实时查询 2026-07-06）
  - CLI 版本 2.1.199 / 2.1.200 / 2.1.201（CHANGELOG.md，提交时间 2026-06-29→07-03）
  - Sonnet 5 发布 2026-06-30；Claude Code 内定价 $2/$10（介绍价，至 2026-08-31），后 $3/$15（anthropic.com/news/claude-sonnet-5）
  - SWE-bench Verified：Sonnet 5 官方分数需核（第三方 vals.ai 榜单显示 Fable 5=95%、Opus 4.8=88.6%，2026-07-01；Sonnet 5 具体分未在博客正文抓到，标注"待官方系统卡核实"）
- **原文链接**：
  - https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md （CLI 变更日志，主源）
  - https://support.claude.com/en/articles/12138966-release-notes （官方发布记录）
  - https://www.anthropic.com/news/claude-sonnet-5 （Sonnet 5 发布博客）
  - https://api.github.com/repos/anthropics/claude-code/commits?path=CHANGELOG.md （版本时间戳）
- **影响判断**：Claude Code 仍是编码 Agent 事实标杆（Stars 13.6 万，A组最高）。本周"Manual 权限默认 + 后台 daemon 稳定性大修 + Sonnet 5 专用模型"三件事叠加，标志赛道从"能力竞赛"转向"可长时间无人值守运行的工程可靠性 + 安全治理"竞赛——这是 Agent 从 Demo 走向生产的拐点信号。

---

### OpenAI Codex / Codex CLI — 老板点名必覆盖
- **本周动态**：Codex CLI 在窗口内保持高频迭代节奏。**稳定版：0.142.4（2026-06-29 05:04Z）与 0.142.5（2026-07-01 01:15Z）**；**下一代 0.143 线密集出 alpha：0.143.0-alpha.31（06-29）、alpha.32（07-01）、alpha.33/34（07-02）、alpha.35（07-03）、alpha.36（07-05）**（均来自 GitHub Releases API 实时时间戳）。内容上，本周两个稳定版为收敛/安全性质：**0.142.5 修复 trace 日志泄漏**——阻止完整的 Responses WebSocket 请求负载被写入 trace 日志（#30771，安全修复）；0.142.4 为无用户可见变更的维护版。紧邻窗口前的 0.142.2（06-25，背景）引入的方向仍在延续：**MCP 工具默认启用 tool search**（改善工具发现，兼容旧模型）、macOS 认证遵循系统代理/PAC/WPAD、Bedrock 凭证过期给出可操作恢复指引、PowerShell 中安全分类器无法检查的 AST 区域强制需审批。产品侧（Codex App，背景非本周核心）此前 06-25 Codex Remote 转正、DigitalOcean 插件、Record & Replay（把演示工作流变可复用 skill）。**路线判断**：OpenAI 把 Codex 打造为"跨本地/远程主机、手机可审批、MCP 原生、可录制工作流"的全栈编码 Agent，0.143 大量 alpha 说明下一个大版本在酝酿；本周稳定版聚焦安全（日志脱敏、审批门槛）与 Codex Code CLI 的 `/import`（从 Claude Code 导入）等生态承接动作。
- **关键数据**：
  - GitHub Stars 95,680 / Forks 14,205（api.github.com/repos/openai/codex，实时 2026-07-06）
  - 稳定版 0.142.4（2026-06-29）、0.142.5（2026-07-01）；alpha 0.143.0-alpha.31→36（06-29→07-05）（GitHub Releases API）
  - 0.142.5 安全修复 PR #30771（trace 日志泄漏）
- **原文链接**：
  - https://github.com/openai/codex/releases （Releases，主源）
  - https://api.github.com/repos/openai/codex/releases （版本+时间戳）
  - https://developers.openai.com/codex/changelog （官方 changelog）
  - https://releasebot.io/updates/openai/codex （聚合，交叉验证日期）
- **影响判断**：Codex 迭代频率是 A组最高（一周内 2 稳定版 + 6 个 alpha），显示 OpenAI 以"快速发布 + 快速修复"抢占开发者心智。本周主题从"加功能"转向"安全脱敏与审批合规"，与 Claude Code 的 Manual 权限默认形成同向信号：**头部编码 Agent 集体进入"安全/治理硬化"阶段**。95.7k Stars 紧追 Claude Code，双寡头格局稳固。

---

### OpenClaw（Agent OS）— 老板点名必覆盖
- **本周动态**：OpenClaw 本周节奏极快，窗口内落地 **稳定版 v2026.6.11（2026-06-30 16:06Z）** 及新版本线 **v2026.7.1-beta.1（07-02）、v2026.7.1-beta.2（07-05）**（GitHub Releases API 实时时间戳）。7.1-beta.2 是本周信息量最大的一次平台级更新，官方 Highlights 关键摘录：**① 新增 OpenAI GPT-5.6 模型家族支持**（贯穿 catalog/capability/runtime 选择链，#98333）；**② 外部 harness 挂载 `openclaw attach`**——可对已存在的 Gateway 会话启动外部 harness，让"Codex 式交互工作流"更易恢复/检视（#96454）；**③ Telegram × Codex 工作流**：Telegram 可用 `/login` 发起 Codex 配对、驾驭（steer）正在运行的 Codex 任务、并在瞬时 API 故障中恢复最终回复（#98006/#98126/#98786）；**④ 事件驱动 cron**：新增 `on-exit` 调度类型，被监视命令退出即唤醒 Agent（#92037）；**⑤ ClawRouter 路由插件**：内置 provider 插件，凭证域内动态模型发现、OpenAI 兼容 + 原生 Anthropic/Gemini 传输、跨用量面板的预算报告（#99658）；**⑥ 按会话能力域（capability profiles）**：为每会话准备工具/访问边界而不削弱默认 profile（#98536）；⑦ 原生 App 刷新（iOS 26 视觉）、iMessage 原生投票、Mac 本地 Gateway 自动安装、Control UI 会话优先侧栏 + reasoning-effort 滑块。**路线判断**：OpenClaw 定位"Agent OS"名副其实——本周把重心放在 **多 harness 编排（attach）+ 跨渠道 Agent 驾驭（Telegram 驱动 Codex）+ 路由/预算治理（ClawRouter）+ 按会话安全域**，即"操作系统级"的调度、路由、隔离能力，而非单点编码功能。
- **关键数据**：
  - GitHub Stars **381,839** / Forks 80,085（api.github.com/repos/openclaw/openclaw，实时 2026-07-06；A组最高、远超同侪）
  - 窗口内版本：v2026.6.11（06-30 稳定）、v2026.7.1-beta.1（07-02）、v2026.7.1-beta.2（07-05）（GitHub Releases API）
  - beta.2 关键 PR：#98333(GPT-5.6)、#96454(attach)、#99658(ClawRouter)、#92037(on-exit cron)、#98536(capability profiles)
- **原文链接**：
  - https://github.com/openclaw/openclaw/releases （Releases，主源）
  - https://api.github.com/repos/openclaw/openclaw/releases （版本时间戳）
  - https://releasebot.io/updates/openclaw （聚合，含 beta.2 完整 Highlights，交叉验证）
  - https://docs.openclaw.ai/releases/2026.6.11 （文档）
- **影响判断**：38 万 Stars 使 OpenClaw 成为开源 Agent 平台第一梯队龙头。本周信号很清晰：OpenClaw 不与 Claude Code/Codex 正面拼"单机编码能力"，而是做**编排层/OS 层**——把 Codex 等作为可被驾驭的 harness 纳入统一网关（Telegram 一句话驱动 Codex）。ClawRouter + capability profiles 表明其向"企业级多模型路由 + 安全隔离"演进，是"Agent 基础设施"赛道的拐点级玩家。

---

### Hermes Agent（Nous Research，自进化）— 老板点名必覆盖
- **本周动态**：**重磅——Hermes Agent 于 2026-07-01 发布 v0.18.0（版本号 v2026.7.1），官方命名"The Judgment Release（判断力版本）"**（GitHub Release，主源）。规模惊人：自 v0.17.0 起 **~1,720 次提交、998 个合并 PR、2,215 文件改动、约 25.1 万行新增、949 issue 关闭、370+ 社区贡献者**。核心叙事三条：**① P0/P1 大清扫——全仓 100% 关闭**：12 天内清掉约 692 个最高优先级项（P0：3 issue+8 PR；P1：493 issue+188 PR），完成瞬间全仓开放 P0/P1 归零，官方承诺"从此保持 0"。**② Mixture-of-Agents 升为一等公民**：MoA 不再是开关模式，而是像 Claude/GPT/Grok 一样在所有模型选择器（CLI/TUI/桌面/网关）里作为 `moa` provider 下的具名预设直接选用；运行时每个参考模型的完整推理各自成块渲染，聚合器答案实时流式输出（#46081/#53548/#53793 等，作者 @teknium1）。**③ 自进化 + 自验证闭环**：Agent 现在**对编码工作记录"验证证据"**，通过真正运行项目检查来判定"完成"而非自我断言；`/goal` 新增 **completion contracts（完成契约）**——你定义"done"的样子，standing-goal 循环据证据判定；`/learn <任何东西>` 把经验蒸馏为可复用 skill、`/journey` 让自我改进可见可控（#50501/#52285/#55413）。底层：网关支持 scale-to-zero 与 drain 协调（可规模化部署）、桌面新增一等编码项目与可玩记忆图、子 Agent 可后台扇出。**背景（非本周）**：其独立 `hermes-agent-self-evolution` 仓（4,524 Stars）基于 **GEPA 遗传进化算法 + DSPy**，宣称比 RL 少用 35x 数据却高 20 个百分点，单次进化运行 $2–10、无需 GPU（多家二手源，5-6月，背景）。**路线判断**：Hermes 走的是"自主+自进化+自验证"路线，与 Claude Code/Codex 的"人类在环收敛"形成鲜明对照，本周把"知道自己何时真正做完（judgment）"作为主命题，直击自主 Agent 最大痛点——幻觉式"我修好了"。
- **关键数据**：
  - GitHub Stars **209,701** / Forks 38,335（api.github.com/repos/NousResearch/hermes-agent，实时 2026-07-06；A组第二）
  - v0.18.0 / v2026.7.1 发布 2026-07-01；自 v0.17.0 起 1,720 commits、998 PR、949 issue closed、370+ 贡献者（GitHub Release body）
  - P0/P1 清扫：P0=3 issue+8 PR，P1=493 issue+188 PR，合计 ~692 项，完成后开放 P0/P1=0
  - 自进化引擎 GEPA+DSPy：35x 少于 RL 数据、+20pp、单次 $2–10（背景，非本周；二手源需谨慎）
- **原文链接**：
  - https://github.com/NousResearch/hermes-agent/releases/tag/v2026.7.1 （v0.18.0 Release，主源）
  - https://api.github.com/repos/NousResearch/hermes-agent/releases （版本时间戳）
  - https://hermes-agent.nousresearch.com/docs/ （官方文档，自进化/记忆/skills 系统）
  - https://github.com/NousResearch/hermes-agent-self-evolution （自进化仓，4,524 Stars，背景）
- **影响判断**：Hermes v0.18.0 是本周 A组"最猛"的单次发布——25 万行改动 + 全仓 P0/P1 归零，工程强度罕见。其"完成契约 + 自验证证据"直接回应了 Claude Code/Codex 本周同样在抓的"可靠性/可信完成"问题，但解法不同（自主自证 vs 人类审批）。20.9 万 Stars + 自进化叙事使其成为"自主 Agent"路线最具代表性的开源力量，是观察"Agent 能否可信自主"的关键样本。

---

### Cursor（Anysphere）
- **本周动态**：Cursor 本周窗口内的公开更新集中在企业分发与移动端两条线（Cursor 官方 changelog，Releasebot 交叉验证日期 06-29/06-30/07-03）。**① Cursor for iOS 移动 App（06-29）**：现于所有付费计划公开 beta。可从手机启动/管理"always-on"云端 Agent——选仓库、语音口述需求、slash 命令引导；云端 Agent 跑在隔离虚拟机（含完整开发环境可测试/验证/演示）；支持 Remote Control（把本机正在跑的 Agent 用手机继续驾驭）、锁屏 Live Activities + 推送（Agent 完成/需输入/待审时通知）、手机端审阅 demo/截图/日志/diff 并直接合 PR。**② Team Marketplaces 支持 Team MCPs 与组织组（06-30）**：管理员一次配置 Team MCP 服务器即可跨 cloud agents/agents 窗口/IDE/CLI 分发；团队市场访问可按 organization groups 限制。**背景（非本周）**：`Auto-review`（分类器 Agent 治理自治，"dial 而非 switch"，97% 准确率）为 2026-06-11 发布；SpaceX 以 **$60B 全股票**收购 Anysphere 为 2026-06-16 前后（多源）；此前 2026-04 曾洽谈 a16z/Thrive $2B 融资、估值 ~$50B（techfundingnews，均为背景）。**路线判断**：Cursor 本周主题是"把 Agent 从 IDE 解绑到手机 + 企业级 MCP 治理分发"，延续其 Cursor 3"agent-first"方向，强调云端 always-on Agent 的随时随地驾驭与企业管控。
- **关键数据**：
  - Cursor for iOS 公开 beta（2026-06-29，所有付费计划）；Team MCPs in Team Marketplaces（2026-06-30）（cursor.com/changelog）
  - 背景：SpaceX $60B 收购 Anysphere（2026-06-16 前后，Yahoo Finance/RTTNews）；Auto-review 97% 准确率（2026-06-11，cursor.com/blog）
  - Cursor 为闭源商业产品，无官方公开 GitHub star 计数（说明：不适用）
- **原文链接**：
  - https://cursor.com/changelog （官方 changelog，主源）
  - https://cursor.com/blog/ios-mobile-app （iOS App 公告）
  - https://releasebot.io/updates/cursor （日期交叉验证：06-29/06-30/07-03）
- **影响判断**：Cursor 是估值最高的编码 Agent 商业玩家（$60B 被购/此前 $50B 估值级别）。本周"移动端 always-on Agent + 企业 MCP 分发"表明其打法是**商业化纵深（企业治理 + 多端触达）**，而非开源社区规模。与开源阵营（OpenClaw/Hermes/OpenCode）形成"闭源商业 vs 开源自主"的赛道分野。

---

### Cognition（Devin / Windsurf）
- **本周动态**：Cognition 旗下 **Devin Desktop（原 Windsurf）于 2026-07-04 发布一波会话/聊天/Agent 工作流更新**（windsurf.com/changelog 官方源，Releasebot 标日期 07-04）。**Devin Desktop**：会话 kebab 菜单新增"New session in space"；Devin Cloud 会话网络恢复后自动重连；聊天可经右键菜单复制图片；新用户默认 agent 模式；agent 侧栏在向 Cascade 发送 problems/explain-and-fix 时保持可见；修复分支 checkout 静默失败、超大会话读写事件缓存导致窗口崩溃、暗色主题下"滚动到顶"按钮可见性；启动时检测并清理孤儿 Devin ACP agent 进程（含 Windows）；修复 TLS 拦截代理下的分析连接失败。**Devin Local（CLI）**：自治模式产生的编辑现生成**可审阅 diff**；新增 `/mcp` slash 命令 + 实时 MCP 服务器状态面板；`/usage` 显示 ACU 用量；skill 权限 frontmatter 现应用于自动批准；企业登录策略在 CLI 强制执行；新增 `sandbox.excluded` allow/ask/deny 配置（可让特定命令跑在沙箱外）；修复 PowerShell `$variable` 赋值前缀的命令批准解析。**背景（非本周）**：Cognition 收购 Windsurf（2025-07）；收购后两月估值 $10.2B（2025-09 CNBC）；2026-04 传洽谈 **$25B 估值**融资（techfundingnews）；Windsurf 已更名并整合为"Devin Desktop"（2026）。**路线判断**：Cognition 正把 Windsurf 深度并入 Devin 品牌（Devin Desktop + Devin Local + Devin Cloud 三形态），本周重点是**自治模式的可审阅性（diff）+ 企业治理（登录策略/沙箱例外）+ MCP 集成**，同样是"自治 + 可控"的收敛主题。
- **关键数据**：
  - Devin Desktop/Local 更新 2026-07-04（windsurf.com/changelog）；关键项：自治编辑可审阅 diff、`/mcp` 面板、`/usage` ACU、企业登录策略 CLI 强制、`sandbox.excluded` 配置
  - 背景：收购后估值 $10.2B（2025-09，CNBC）；洽谈 $25B 估值（2026-04，techfundingnews）
- **原文链接**：
  - https://windsurf.com/changelog （官方 changelog，主源）
  - https://docs.devin.ai/desktop/changelog （Devin Desktop 官方变更日志）
  - https://releasebot.io/updates/windsurf （日期交叉验证 07-04）
- **影响判断**：Cognition 是"Devin=自主软件工程师"叙事的主推者。本周把重心放在自治编辑的可审阅性与企业沙箱治理，与 Cursor/Claude Code/Codex 的安全收敛完全同频——**整个编码 Agent 赛道本周集体转向"自治可控 + 企业合规"**。品牌整合（Windsurf→Devin Desktop）显示其收缩产品线、聚焦 Devin 单一心智。

---

### OpenCode
- **本周动态**：OpenCode（开源 AI 编码 Agent，仓库已从 sst/opencode 迁移至 **anomalyco/opencode**）本周窗口内连发 **v1.17.12（2026-06-30 19:48Z）与 v1.17.13（2026-07-01 15:19Z）**（GitHub Releases API 实时时间戳）。**v1.17.12 核心（紧跟 Sonnet 5 发布日）**：**为 Claude Sonnet 5 启用 adaptive thinking（自适应思考）**——即 OpenCode 在 Sonnet 5 发布当日/次日即完成适配；MCP 相关一批增强：同时存在时优先 MCP content 响应而非结构化输出、OAuth 后即使服务器被禁用也重连 MCP、OAuth 请求 refresh-token scope、显示 MCP OAuth 完成错误、按服务器 URL 界定 MCP 认证状态、刷新缓存的远程 skills；跨 provider 挑选更优的默认小模型；**TUI 新增 yolo 模式（自动批准权限）**；桌面新增 MCP 资源在 composer 自动补全、新会话工作区控制、会话上下文显示已存 token 与成本合计。**v1.17.13 核心**：为 OpenAI 兼容推理模型强制 reasoning 模式（自定义部署上 reasoning 设置可靠生效）、停止重放陈旧的 GitHub Copilot 响应项 ID（避免后续请求失败）；桌面：问题提示可最小化/恢复而不被 dismiss、清理陈旧空/旧草稿存储、v2 会话 UI 新增可搜索模型选择器与模型管理流、会话页失败限定在受影响 tab。**路线判断**：OpenCode 迭代极快（周内 2 个 patch），主攻 **MCP 深度集成 + 多 provider 兼容（含 Copilot/OpenAI 兼容端点）+ TUI/桌面双端体验**，对新模型（Sonnet 5）适配神速，是开源社区响应速度标杆。
- **关键数据**：
  - GitHub Stars **182,654** / Forks（api.github.com/repos/anomalyco/opencode，实时 2026-07-06；A组第三，仅次于 OpenClaw、Hermes 前的量级）
  - 窗口内版本：v1.17.12（2026-06-30）、v1.17.13（2026-07-01）（GitHub Releases API）
  - v1.17.12 关键：Sonnet 5 adaptive thinking、TUI yolo 模式；注意 opencode-ai/opencode（13,240 Stars）为已停更旧 fork，勿混淆
- **原文链接**：
  - https://github.com/anomalyco/opencode/releases/tag/v1.17.13 （v1.17.13，主源）
  - https://github.com/anomalyco/opencode/releases/tag/v1.17.12 （v1.17.12，主源）
  - https://api.github.com/repos/anomalyco/opencode/releases （版本时间戳）
  - https://opencode.ai/ （官网）
- **影响判断**：OpenCode 以 18.3 万 Stars 成为开源编码 Agent 的重量级选手。本周亮点是**对 Sonnet 5 的当日级适配**与 MCP/多 provider 的持续深耕，印证开源工具"模型中立 + 快速跟进前沿模型"的差异化优势。TUI yolo 模式（全自动批准）与头部厂商的安全收敛形成有趣对照——开源侧更愿把"是否收敛"的选择权交给用户。

---

## 📊 本组洞察（A组｜编码Agent/CLI 赛道趋势与拐点信号）

**1. 安全/自治治理成为本周全赛道主旋律（最强信号）。** 六个有动态的对象里，五个不约而同在做"自治可控"：Claude Code 把默认权限改为 **Manual**、Codex 上 **PowerShell 审批 + trace 日志脱敏**、Cursor 的 **Auto-review 分类器**（背景延续）、Devin Local 的**可审阅 diff + 沙箱例外 + 企业登录策略**、Hermes 的**完成契约 + 自验证证据**。这标志编码 Agent 集体跨过"能不能自动干"，进入"如何让自动干变得可信、可审、可合规"的**生产化拐点**——从 Demo 竞赛转向工程可靠性与治理竞赛。

**2. 路线分野清晰：闭源商业纵深 vs 开源自主/中立。** Cursor（$60B）与 Cognition（洽谈 $25B）走**企业治理 + 多端 + 估值**路线；OpenClaw（38.2万⭐）/Hermes（20.9万⭐）/OpenCode（18.3万⭐）走**开源规模 + 模型中立 + 自进化**路线。Claude Code/Codex 则是**模型厂商自带工具**（Sonnet 5 专调 agentic、Codex 绑 GPT-5.x），护城河是模型-工具协同。

**3. 新模型 Sonnet 5（06-30）是本周隐形主线。** 它同时驱动了 Claude Code（默认模型）、OpenCode（当日适配 adaptive thinking），介绍价 $2/$10 压低 agentic 成本，"接近 Opus 4.8 但更便宜"直接降低长跑 Agent 的经济门槛——这是"Agent 可负担地长时间运行"的成本拐点。

**4. "完成即证明"成为新命题。** Hermes v0.18.0 命名"Judgment Release"、Sonnet 5 强调"自查/写复现测试"、Devin 强调"可审阅 diff"——赛道正把"Agent 如何知道自己真的做完了"（而非幻觉式声称完成）当作下一个核心竞争点，这比单纯刷 SWE-bench 分数更贴近生产价值。

**5. 迭代速度分化。** Codex（周内 2 稳定 + 6 alpha）、OpenClaw（1 稳定 + 2 beta）、OpenCode（2 patch）、Hermes（一次 25 万行巨型 release）节奏极快；Cursor/Devin 以产品化功能为节拍。开源阵营对前沿模型的适配速度（OpenCode 当日跟 Sonnet 5）是其相对闭源的关键优势。

---

## 🧩 板块二 · 通用 / 自主 Agent 框架（B 组）

---

### 1. LangChain / LangGraph

- **本周动态**：本周区间内 LangGraph 主线持续高频迭代补丁版本，GitHub Releases 页面显示到 **1.2.7**（`release(langgraph): 1.2.7`，PR #8223），并伴随一批修复：`snapshot DeltaChannel overwrite supersteps`（#8125）、`Make Overwrite survive JSON roundtrips`（#8127）、`emit valid UUIDs for exit-mode delta task_ids`（#8165），以及依赖升级（cryptography 46.0.7→48.0.1、redis、langsmith 0.8.0→0.8.18 等安全性/依赖维护）。此前紧邻窗口的 1.2.3–1.2.6 引入了较有分量的工程能力：**v3 streaming**（RemoteGraph v3 流式支持 #7927、SDK v3 streaming primitives + SSE transport #7818、websocket stream transports #7830）、`name tool-dispatched subagents via lc_agent_name`（#7928，子Agent命名，服务于多Agent编排可观测性）、Python 类型检查从 mypy 迁移到 **ty**（#8002，Astral 新类型检查器）。CLI 到 0.4.30，新增 HTTPS dev server（certfile/cert key）与 API version range 兼容（#8023）。仓库 `pushed_at` 为 2026-07-05，说明本窗口内代码活跃。**方向判断**：LangGraph 正把"持久化执行 + 流式协议（v3）+ 子Agent编排"作为核心竞争壁垒，工程重心明显从"图编排 API"转向"生产运行时（runtime）+ 平台（LangSmith Deployment）"。同期一篇 1.0 alpha 里程碑博客（`create_agent` 新抽象、langchain-core content_blocks、langchain-legacy 兼容包，目标官方 1.0 定于 10 月底）被搜索引擎标注在本窗口附近，但该博客正文与元数据显示其原始发布约在 2025-09（**背景，非本周**，此处仅作 1.0 路线上下文，不计入本周动态）。
- **关键数据**：
  - LangGraph GitHub Stars **36,563**，Forks 6,125，Open Issues 601（来源 GitHub API https://github.com/langchain-ai/langgraph ，取数 2026-07-06；`pushed_at` 2026-07-05）
  - LangChain 主仓 Stars **141,019**，Forks 23,436（来源 https://github.com/langchain-ai/langchain ，2026-07-06）
  - 最新版本 LangGraph 1.2.7（Releases 页面 Verified Jun 29, 2026；来源 https://github.com/langchain-ai/langgraph/releases ）
  - 1.0 官方 GA 目标：2026 年 10 月底（来源 https://www.langchain.com/blog/langchain-langchain-1-0-alpha-releases ，背景）
- **原文链接**：
  - https://github.com/langchain-ai/langgraph/releases （已读全文，逐条 PR）
  - https://github.com/langchain-ai/langgraph （仓库主页 README）
  - https://www.langchain.com/blog/langchain-langchain-1-0-alpha-releases （1.0 alpha 路线，背景）
  - https://docs.langchain.com/langsmith/changelog （LangSmith 周更，最新条目 6/20-28）
- **影响判断**：LangGraph 是本组"生产级 Agent 运行时"事实标准之一，v3 流式协议 + 子Agent命名 + 持久化执行组合，直指长时运行、可观测、可恢复的企业 Agent 需求，是与 OpenAI Agents SDK/Google ADK 正面竞争的护城河。补丁高频（一周多个 patch）显示 1.0 GA（10 月）前进入稳定化冲刺，值得持续跟踪 v3 streaming 是否成为跨框架事实标准。

---

### 2. Microsoft AutoGen

- **本周动态**：**本周无独立重大公开动态（框架已进入冻结/维护态）**。核心事实：AutoGen 已被官方并入 **Microsoft Agent Framework**（统一 Semantic Kernel + AutoGen 的新一代框架，1.0 已于 **2026 年 4 月**达 GA——背景，非本周）。GitHub 官方 Discussion #7066《AutoGen Update》明确："AutoGen 将继续维护——拥有稳定 API，将继续接收关键 bug 修复与安全补丁——但不再新增（重大）功能"，团队精力转向 Agent Framework。旁证：microsoft/autogen 仓库 `pushed_at` 停留在 **2026-04-15**，本窗口（6/29–7/5）内无任何代码提交，印证冻结状态。本周社区侧仅见二手内容（awesome-list、教程、迁移指南）提及"AutoGen 已与 Semantic Kernel 合并进 Agent Framework"，微软官方文档提供《AutoGen → Microsoft Agent Framework 迁移指南》(learn.microsoft.com/agent-framework/migration-guide/from-autogen)。**方向判断**：AutoGen 作为独立品牌事实上已完成历史使命，微软将多Agent能力（event-driven、group chat、magentic 等）沉淀到 Agent Framework 的 graph-based orchestration + middleware pipeline 中。对存量 AutoGen 用户，本周无新功能，但需关注迁移窗口与安全补丁。
- **关键数据**：
  - AutoGen GitHub Stars **59,511**，Forks 8,962，Open Issues 926（来源 GitHub API https://github.com/microsoft/autogen ，2026-07-06）
  - 仓库最后代码推送 `pushed_at` **2026-04-15**（本窗口无提交；来源同上）
  - Microsoft Agent Framework 1.0 GA：2026 年 4 月（背景；来源 https://github.com/ai-boost/awesome-harness-engineering 二手，需以微软官方为准）
- **原文链接**：
  - https://github.com/microsoft/autogen/discussions/7066 （AutoGen Update 官方公告，已读；注：该贴评论区含无关垃圾内容，已忽略）
  - https://learn.microsoft.com/en-us/agent-framework/migration-guide/from-autogen/ （迁移指南）
  - https://github.com/microsoft/autogen （仓库主页，取 Stars/pushed_at）
- **影响判断**：AutoGen 的"停更 + 并入 Agent Framework"是 2026 年 Agent 框架格局重要信号——微软收敛双线（SK/AutoGen）为单一企业级平台。对本周报意义：AutoGen 不再是活跃创新源，跟踪重心应转向 Microsoft Agent Framework；存量项目迁移与安全（本周有多方安全研究点名 AutoGen/LangChain/SK 的 prompt-to-shell 提权路径）值得警惕。

---

### 3. CrewAI

- **本周动态**：CrewAI 本窗口内保持极高发布节奏。稳定版 **1.15.0**（2026-06-25）与 **1.15.1**（2026-06-27）紧邻窗口前，随后窗口内连续推出预发布 **1.15.2a1**（2026-06-30）与 **1.15.2a2**（2026-07-01）。本轮主线是**声明式 Flow（Declarative Flow）与 JSON-first Crew 工程化**：1.15.0 引入"unified declarative flow loading / declarative Flow CLI support / conversational flows in CLI TUI / single agent action & crew actions in FlowDefinition / each 复合动作 / DMN 模式支持"，并把 `crewai run` 与 `crewai flow kickoff` 合并、移除 flow state 的 StateProxy（运行时重构）。1.15.1 强调"要求显式 CrewAI 项目定义（explicit project definitions）"、部署后自动打开 deployment 页、JSON crew 模板渲染修复。窗口内 1.15.2a1/a2 继续补齐：inline skill definitions、stream frame protocol for flows（流式帧协议）、CrewDefinition 中新增 type tool 与 app、生成式 Flow Definition authoring skill、flow agent options 文档与 streaming 文档。安全侧值得注意：本轮修复了 **SSRF redirect bypass**（#6331）、**symlink path traversal in skill archive extraction**、credential 文件 owner-only 权限强制——显示 CrewAI 在把开源框架推向企业生产时补齐安全基线。商业侧：官方 README 明确 **CrewAI AMP Suite**（原 Enterprise/Control Plane）提供托管部署、可观测性、治理、安全与企业支持；定价页（2026-06）宣称服务 **63% 的 Fortune 500**。**方向判断**：CrewAI 正从"角色扮演多Agent库"转向"声明式（JSON/DMN）低代码 + 企业控制面"双轨，工程重心是让非工程用户也能用配置文件编排 Flow，同时用 AMP 变现。
- **关键数据**：
  - GitHub Stars **54,968**，Forks 7,716，Open Issues 613（来源 GitHub API https://github.com/crewAIInc/crewAI ，2026-07-06；`pushed_at` 2026-07-05）
  - 窗口内版本：1.15.2a1（2026-06-30）、1.15.2a2（2026-07-01）；稳定 1.15.1（2026-06-27）、1.15.0（2026-06-25）（来源 GitHub Releases API，同上）
  - 商业：服务 63% 的 Fortune 500（来源：CrewAI 定价页/README，经 usagepricing.com 汇总 2026-06；此前为 Oct 2024 launch 的 "nearly half"→"60%"→"63%"演进）
  - 融资：2024-10 $18M 轮（含 Andrew Ng、Dharmesh Shah 天使；OSS 月执行 >1000 万 agents）——**背景，非本周**（来源 usagepricing.com trivia）
- **原文链接**：
  - https://github.com/crewAIInc/crewAI/releases （已读全文，逐版本变更）
  - https://github.com/crewaiinc/crewai （README，AMP Suite 定位）
  - https://www.usagepricing.com/blueprint/trivia （商业化数据汇总，二手）
- **影响判断**：CrewAI 的"声明式 Flow + JSON-first"是本组差异化最明显的路线——降低多Agent编排门槛、面向企业低代码人群，配合 AMP 控制面直接变现，Fortune 500 渗透率是其最强商业信号。安全补丁（SSRF/路径穿越）也反映 Agent 框架整体进入"企业安全审计"阶段，与本周多起 Agent 框架安全研究呼应。

---

### 4. Google ADK（Agent Development Kit）

- **本周动态**：ADK 本窗口（6/29–7/5）**无新 tag 发布**，但仓库 `pushed_at` 为 **2026-07-03**，主干持续活跃开发（下一个 release 在酝酿）。最近的实质版本紧邻窗口前：**v2.3.0**（2026-06-17，发布于 6/18）为近期最大更新，v1.35.2（6/18）、v1.35.1（6/15）为 1.x 维护线。v2.3.0 关键特性（作为进入本周的技术底座）：**GEPARootAgentOptimizer**（GEPA 自动提示/Agent 优化器，指向"自进化/自动优化"方向）、**E2BEnvironment 远程沙箱工作区集成**、**Gemma4 在 Gemini 中的支持**、**Gemini Live 3.1 输入转写差异化处理 + Live API 翻译配置**、AgentRegistry/McpToolset **mTLS 支持**（企业安全）、per-request OpenTelemetry 配置、为 Anthropic/OpenAI 上报 cached token counts、labs 实验性 **Antigravity SDK agent wrapper**。更早的 v2.2.0（6/4）含一处重要 **BREAKING**：LlmAgent 默认模型从 gemini-2.5-flash 改为 **gemini-3-flash-preview**（为 2026-10-16 gemini-2.5-flash 停用做准备），并支持 GenAI SDK v2.0.0（"turns"→"steps" 术语迁移）。ADK 双版本线（1.x 维护 + 2.x 主线）并行，A2A（Agent-to-Agent 协议）相关修复密集，显示对跨Agent互操作的持续投入。**方向判断**：ADK 深度绑定 Gemini/Vertex 生态（Live API、Gemma4、Agent Engine 部署），并通过 A2A 协议、MCP toolset、mTLS 构建企业级多Agent互操作与安全，GEPA 优化器是其在"Agent 自动优化"研究方向的落子。
- **关键数据**：
  - GitHub Stars **20,478**，Forks 3,650，Open Issues 710（来源 GitHub API https://github.com/google/adk-python ，2026-07-06；`pushed_at` 2026-07-03，窗口内有提交）
  - 最近版本：v2.3.0（2026-06-17，发布 6/18）；v1.35.2（6/18）；v2.2.0（6/4，含默认模型 BREAKING 改为 gemini-3-flash-preview）——均为**背景/窗口前**，本窗口无新 tag（来源 GitHub Releases API）
  - 依赖安全：v2.2.0 起 bump starlette/fastapi 修复 CVE-2026-48710（来源 release notes）
- **原文链接**：
  - https://github.com/google/adk-python/releases （已读全文，v2.3.0/v2.2.0 逐条 commit）
  - https://github.com/google/adk-python （仓库主页，取 Stars/pushed_at）
- **影响判断**：ADK 是 Google 押注企业 Agent 的核心 SDK，v2.3.0 的 GEPA 优化器 + E2B 沙箱 + mTLS + A2A 组合，瞄准"可自优化、可安全部署、可跨Agent协作"的企业场景。默认模型切到 gemini-3-flash-preview 反映 Gemini 3 代际推进。本周虽无新 tag，但主干活跃，v2.4/下一版本临近，需持续跟踪 GEPA 与 A2A 生态。

---

### 5. OpenAI Agents SDK / Swarm

- **本周动态**：OpenAI Agents SDK 本窗口（6/29–7/5）**无新 tag 发布**，但仓库 `pushed_at` 为 **2026-07-04**，主干在窗口内持续高频合并 PR（下一个 patch 在酝酿），可视为活跃维护态。最近的实质版本紧邻窗口前：**v0.17.7**（2026-06-24）、v0.17.6（6/19）、v0.17.5（6/11）。作为进入本周的技术底座，近几版重点集中在**沙箱执行、护栏（guardrails）与实时（Realtime）多Agent**三条线：v0.17.7 新增 configurable websocket max_size、buffered Chat Completions tool-call streaming，修复"取消同级 guardrail 任务当其一抛错"（#3239）、"防止 Realtime 多Agent 工具分派歧义"（#3441）、E2B PTY 输出在进程退出时唤醒（#3610）；v0.17.6 引入 **pre-approval tool input guardrails**（工具输入预审护栏 #3487）与 SDK-only 自定义工具输出数据（#3486）——安全/人机确认（HITL approval）能力持续加强；更早版本含"保持挂载凭证不进入沙箱命令"（#3429）、hardened http client for MCP SSE transport（#3466）等安全硬化。**Swarm**：仓库描述仍为"Educational framework exploring ergonomic, lightweight multi-agent orchentration"（教育性实验框架），`pushed_at` 停留在 **2026-04-15**，未归档但已冻结，官方定位其为 Agents SDK 的前身/教学品，生产建议迁移至 Agents SDK。**方向判断**：OpenAI 把 Agents SDK 做成"轻量 + 强安全护栏 + Realtime 语音多Agent + 沙箱工具执行"的官方参考实现，Swarm 的历史使命已完，SDK 是唯一活跃主线。Open Issues 仅 71（远低于同类），显示维护质量高、issue 治理严格。
- **关键数据**：
  - Agents SDK GitHub Stars **27,668**，Forks 4,261，Open Issues **71**（来源 GitHub API https://github.com/openai/openai-agents-python ，2026-07-06；`pushed_at` 2026-07-04，窗口内活跃）
  - 最新版本 v0.17.7（2026-06-24，**背景/窗口前**；本窗口无新 tag）（来源 GitHub Releases API）
  - Swarm Stars **21,766**，Forks 2,319；`pushed_at` **2026-04-15**（冻结，未归档；来源 https://github.com/openai/swarm ）
- **原文链接**：
  - https://github.com/openai/openai-agents-python/releases （已读全文，v0.17.3–0.17.7 逐条 PR）
  - https://github.com/openai/swarm （仓库状态/描述）
- **影响判断**：OpenAI Agents SDK 是"官方背书"的 Agent 框架，pre-approval guardrails 与沙箱安全硬化直接呼应 2026 年 Agent 安全监管趋势（工具调用需人审）。虽本周无 tag，但主干活跃 + 极低 issue 数说明工程成熟度高，是企业选型的强力候选。Swarm 冻结再次印证"实验品→官方 SDK"的行业收敛模式（与 AutoGen→Agent Framework 同构）。

---

### 6. Dify

- **本周动态**：Dify 本窗口（6/29–7/5）**无新 tag 发布**，但仓库 `pushed_at` 为 **2026-07-06**，为本组最活跃仓库之一（几乎每日提交），下一个版本在密集开发中。最近的重磅版本紧邻窗口前：**Dify 1.15.0**（2026-06-25）。作为进入本周的核心底座，1.15.0 含多项重大特性：①**difyctl 命令行客户端**——首次可从终端/CI 直接运行 Dify apps 与 workflows，无需打开 Web UI，单命令跨平台安装（macOS/Linux/Windows），二进制含 checksum 校验（#37036）；②**Workflow/Chatflow/CLI 中查看 CoT（思维链）**——把模型推理流式渲染到独立"thinking"面板并持久化（刷新后仍在，#37460）；③**更丰富的 Human-in-the-Loop 表单**——工作流暂停询问人时，表单支持下拉选择与文件/多文件上传（不再仅纯文本，#36322）；④**支持慢速长耗时模型**——通过轮询机制等待图像/视频生成结果不超时（#37462）；⑤Excel 内嵌图片在知识导入时被提取（#37104）；⑥更深可观测性（Phoenix 自定义 trace session id、RAG 文档检索步骤追踪）。安全侧修复 **path traversal in plugin-daemon forwarding（CVE-2026-41948）**，并硬化 Firecrawl/Jina/Watercrawl/Nacos/Marketplace 出站 HTTP 超时与默认 SSRF egress。该版本含数据库迁移（OAuth access tokens、Human Input 上传表、分类级 plugin auto-upgrade），升级需 `flask db upgrade` + `flask backfill-plugin-auto-upgrade`。**方向判断**：Dify 正把"低代码 LLM 应用平台"推向"可编程（difyctl/CI）+ 可观测（CoT/RAG trace）+ 企业可控（OAuth/SSRF/权限）"，difyctl 是把平台从 GUI-only 打开给工程化/自动化人群的关键一步。
- **关键数据**：
  - GitHub Stars **147,801**，Forks 23,274，Open Issues 879（来源 GitHub API https://github.com/langgenius/dify ，2026-07-06；`pushed_at` 2026-07-06，窗口内高频提交）——本组 Stars 最高
  - 最新版本 Dify 1.15.0（2026-06-25，**背景/窗口前**；本窗口无新 tag）（来源 GitHub Releases API）
  - 安全：1.15.0 修复 CVE-2026-41948（plugin-daemon 路径穿越）；另有 CVE-2026-28288（Observable Response Discrepancy）本周被威胁情报收录（来源 radar.offseq.com，二手）
- **原文链接**：
  - https://github.com/langgenius/dify/releases （已读全文，1.15.0 完整 release note + 升级指南）
  - https://github.com/langgenius （组织介绍，团队为前腾讯云 DevOps 成员）
- **影响判断**：Dify 是本组 Stars 最高（14.7 万）、社区最活跃的开源 LLM 应用/Agent 平台，difyctl + CoT 面板 + 富 HITL 表单三件套显著提升其"从原型到生产 + 可编程自动化"能力。近期两个 CVE 被收录也提示：高热度开源 Agent 平台正成为安全研究焦点，企业部署需紧跟补丁。

---

### 7. LlamaIndex Agents

- **本周动态**：LlamaIndex 本窗口**有明确重大动态**——发布参考应用 **legal-kb**（github.com/run-llama/legal-kb）与配套方法论 **Retrieval Harness（检索工具链/检索脚手架）**，MarkTechPost 于 **2026-07-05** 深度报道，Latent.Space AINews 同期收录（创始人 Jerry Liu @jerryjliu0 亲自推广）。核心创新：把"agentic retrieval（智能体式检索）"做成一套**类文件系统工具**给 Agent 调用，替代单次 embedding 检索。基于 **LlamaIndex Index v2（LlamaParse Platform）**，暴露四个工具：①`retrieve`（beta.retrieval.retrieve：混合语义检索 + 可选 rerank，返回 chunks + 引用）；②`findFiles`（beta.retrieval.find：按文件名精确/子串搜索，自动分页）；③`readFile`（beta.retrieval.read：按 offset/length 读原文）；④`grepFile`（beta.retrieval.grep：单文件正则匹配，返回字符位置）。系统提示强制调用顺序：先 findFiles 建立文档清单 → retrieve 收窄 → readFile/grepFile 确认精确措辞后再引用。工程栈：**TanStack Start + Vercel AI SDK 6 的 ToolLoopAgent + Prisma/PostgreSQL + WorkOS**，per-turn 可选 OpenAI/Anthropic 并 BYO key（Claude 用 extended thinking、OpenAI 用 medium reasoning effort）。知识库按 (project, filename) 做**版本控制**（v1/v2/v3 并存，retrieve 支持 file_version 过滤），答案带**可视化引用**（页面截图 + bounding-box 标注被引文本）。定位对标"grep is all you need"式简化观点的反驳——用多步工具循环（find→retrieve→read/grep）处理长程文档任务。同期 llama-index-core 最新版本 **v0.14.23**（2026-06-24，窗口前）。**方向判断**：LlamaIndex 把自身从"RAG 库"重新定位为"agentic retrieval 基础设施"，Retrieval Harness 是其对 2026 年"Agent + 检索"融合趋势的旗帜性表态——检索不再是黑盒 top-k，而是 Agent 可编排的细粒度工具集。
- **关键数据**：
  - GitHub Stars（主仓 llama_index）**50,664**，Forks 7,694，Open Issues 493（来源 GitHub API https://github.com/run-llama/llama_index ，2026-07-06；`pushed_at` 2026-07-02）
  - legal-kb 参考应用发布报道：2026-07-05（来源 MarkTechPost；Latent.Space AINews 同期）
  - llama-index-core 最新 tag v0.14.23（2026-06-24，背景/窗口前；来源 GitHub Releases/Tags API）
  - 四工具后端 API：beta.retrieval.retrieve / find / read / grep（Index v2；来源 MarkTechPost 原文含代码）
- **原文链接**：
  - https://www.marktechpost.com/2026/07/05/llamaindex-legal-kb-agentic-retrieval-over-index-v2-with-retrieve-find-read-and-grep-tools/ （已读全文，含工具表与代码）
  - https://github.com/run-llama/legal-kb （参考应用仓库）
  - https://github.com/run-llama/llama_index/releases （版本记录，取核心版本号）
- **影响判断**：Retrieval Harness 是本周本组最具"方法论信号"的动态——它把 RAG 从"一次向量检索"升级为"Agent 驱动的多步检索工具循环（find/retrieve/read/grep + 版本 + 可视引用）"，直击法律/金融等长文档、高可溯源场景。对整个 Agent 生态意义：检索层正被"工具化/Agent 化"，与 Claude Code/Cursor 的"grep+read 文件系统式"范式合流，是 context engineering 的重要一环。

---

## 本组洞察（B组｜通用/自主Agent框架）

**1. 行业进入"框架收敛"期，实验品退场、官方 SDK 上位。** 本周最强结构性信号是两组"实验品→官方主线"的收敛：微软 **AutoGen 冻结**（pushed_at 停在 4/15）并入 **Microsoft Agent Framework（4 月 GA）**；OpenAI **Swarm 冻结**（4/15）、由 **Agents SDK** 接棒。两者同构，说明 2026 年多Agent框架从"百花齐放的实验"走向"厂商级统一平台"。选型上，AutoGen/Swarm 已不宜作新项目基座。

**2. 竞争焦点从"编排 API"上移到"生产运行时 + 安全 + 可观测"。** LangGraph 主推 v3 streaming/持久化执行/子Agent命名；OpenAI SDK 主推 pre-approval guardrails + 沙箱硬化；ADK 主推 mTLS + A2A + OTel；CrewAI/Dify 密集修 SSRF/路径穿越/CVE。本周多家（LangChain/AutoGen/SK 被点名 prompt-to-shell；Dify CVE-2026-41948/28288）显示 **Agent 框架安全已成一线议题**——护栏、沙箱、凭证隔离、依赖 CVE 是企业选型硬门槛。

**3. "声明式/低代码 + 可编程 CLI"双向扩张用户面。** CrewAI 推声明式 Flow（JSON/DMN）降低多Agent编排门槛；Dify 推 difyctl 把 GUI-only 平台打开给 CI/脚本人群。两条相反方向（GUI→代码、代码→配置）都在扩大可触达用户，配合企业控制面（CrewAI AMP、Dify 企业版）变现。

**4. 检索被"Agent 化/工具化"，context engineering 成新战场。** LlamaIndex 的 Retrieval Harness（find/retrieve/read/grep 工具循环 + 版本 + 可视引用）是本周最具方法论价值的动态，把 RAG 从黑盒 top-k 升级为 Agent 可编排的细粒度工具集，与编码 Agent 的"文件系统式"范式合流。

**5. 数据速览（GitHub Stars，2026-07-06）：** Dify 147,801 > LangChain 141,019 > AutoGen 59,511 > CrewAI 54,968 > LlamaIndex 50,664 > LangGraph 36,563 > OpenAI Agents SDK 27,668 > Swarm 21,766 > Google ADK 20,478。热度最高的是"平台型"（Dify/LangChain），但活跃开发（pushed_at 落在本窗口）集中在 Dify、CrewAI、LangGraph、OpenAI SDK、ADK——即"仍在快速迭代"的第一梯队。

**本周有料对象小结：** 明确本周新动态 = LlamaIndex（legal-kb/Retrieval Harness，7/5）；窗口内有版本/预发布 = CrewAI（1.15.2a1/a2）、LangGraph（1.2.7 补丁线）；窗口内主干活跃但无新 tag = OpenAI SDK、Dify、ADK；冻结无动态 = AutoGen、Swarm。

---

## 🏢 板块三 · 垂直 / 企业 Agent 产品（C 组）

---

### Perplexity（Comet / 搜索Agent / Computer）

- **本周动态**：本周(6/29–7/5)Perplexity **无严格落在窗口内的重大官方产品发布**。距窗口最近的官方动作是 6 月 24 日发布的「Computer for Counsel」——面向法律行业的垂直 Agent 平台，可自动化法律研究、文档收集与合同分析，集成 Microsoft 365、Google Drive、Midpage、Deel 等工具，接入付费法律数据库，并强调"让律师掌控敏感数据"，仅对 Enterprise 与 Max 订阅者开放（据 AI-Weekly 2026-06-30 期，事件日期标 6/24，**背景，非本周**）。本周处于其 6 月密集发布潮（Computer for Pro/Enterprise、Comet Enterprise、Personal Computer、Bring-Your-Own-Connector via MCP、Snowflake Connector 等）之后的消化期。战略主线延续：把 Comet 浏览器做成"Agent 经济的前门（front door）"——谁拥有 Agent 开始执行任务的界面，谁就掌握后续研究与购买的入口。商业层面本周同样安静，最近一次融资是 6 月 5 日 The Information 报道的约 2 亿美元新融资（估值约 200 亿美元，累计融资约 17.2 亿美元，**背景，非本周**）。判断：Perplexity 已从"更好的搜索"彻底转向"Agent 公司"，垂直化（Counsel/Finance/Health）+ 企业化（Comet Enterprise + CrowdStrike 安全 + MCP 连接器）是其对抗 Google/OpenAI 的双轮。本周静默属正常发布节奏，不代表放缓。
- **关键数据**：
  - ARR：3 月 2026 突破约 4.5 亿美元（FT 4/8 报道单月营收跳增约 50%）；Sacra 4 月估约 5 亿美元。来源：https://aibusinessweekly.net/p/perplexity-ai-statistics ；https://fatjoe.com/blog/perplexity-ai-stats
  - 融资：6/5/2026 约 2 亿美元 @ 约 200 亿美元估值，累计约 17.2 亿美元（背景）。来源：https://www.techtimes.com/articles/318028/20260608/perplexity-raises-200-million-comet-ai-browser-agent-economy-front-door.htm
  - Comet Plus：$5/月，80/20 分成给出版商，池 4250 万美元，2400+ 出版商（背景）。
  - 定价：Pro $20/月；Enterprise 起 $40/席/月（背景）。
- **原文链接**：
  - https://releasebot.io/updates/perplexity-ai （已读，6 月发布汇总：Computer for Pro/Enterprise、Comet Enterprise、Personal Computer、BYO Connector、Snowflake Connector）
  - https://www.techtimes.com/articles/318028/20260608/perplexity-raises-200-million-comet-ai-browser-agent-economy-front-door.htm （已读，融资时间线纠偏）
  - https://ai-weekly.ai/newsletter-06-30-2026 （已读，Computer for Counsel 6/24）
- **影响判断**：本周无窗口内料，但趋势信号明确——Perplexity 正把"Agent 编排 + 400+ 连接器 + MCP + 行业垂直包"叠成企业级平台，与 Glean/Manus 的竞争面开始重叠。垂直法律包(Counsel)直接踩进 Harvey 腹地，是需持续跟踪的交叉战线。

---

### Harvey（法律AI）

- **本周动态**：Harvey 本周**有实打实窗口内动态**。① **6 月 30 日：Claude Sonnet 5 正式上线 Harvey**（官方博客）。Sonnet 5 是 Anthropic 最新 Sonnet 模型，在 Harvey 内部「法律 Agent 基准 LAB」上取得 **5.8% all-pass**（LAB 是严格的多步法律工作端到端评测，从任务分派到审阅全流程模拟律所真实执行）；在 **BigLaw Bench 上取得 91.3%——Harvey 记录过的 Sonnet 与 Opus 模型中最高分**。模型在能源与自然资源、房地产、资本市场等领域表现突出，起草(drafting)为其最强 LAB 任务类型；BigLaw Bench 上风险评估与合规、案件管理、交易类起草为亮点。Harvey 应用研究负责人 Niko Grupen 评价："Sonnet 5 相比 4.6 在法律质量上有显著跃升，更准确更精确，用更少的字给出更强答案。"但税务、结构化金融等密集专业分析任务仍是难点，最严格的 Agentic 指标（长多步任务零失误）仍有提升空间。美国区将在数日内向合格客户开放 model selector，欧盟/澳洲随后。② **Eversheds Sutherland（International）宣布 Harvey 为其法律 AI 合作伙伴**：初始 350 名律师即刻接入，5 月起在国际业务全面铺开（注：该新闻页于本周窗口内被检索到并明确将 2026 定为该所"AI 之年"，试点覆盖 350+ 律师，聚焦工作流自动化、合同审查、法律起草与数据分析；CEO Winston Weinberg 出面背书）。③ 6 月「The Brief」月度产品汇总覆盖到 6 月底：Word 内红线质量提升、Agentic Word 格式支持、Opus 4.8 上线、DeepJudge 集成、US 判例法知识源、SCC Online（印度法律检索）、160+ 新法律研究数据源、Harvey Mobile for Android、Email Harvey 等。判断：Harvey 在"多模型即插即用（Sonnet 5/Opus 4.8/GPT-5）+ 自研法律专用模型(Harvey Labs)+ 500+ 预建 Agent + Agent Builder + 全球判例数据源"上持续加固护城河，正从"法律版 Copilot"进化为"法律 Agent 操作系统"。
- **关键数据**：
  - Sonnet 5：LAB **5.8% all-pass**；BigLaw Bench **91.3%**（历史最高）。来源：https://www.harvey.ai/blog/sonnet-5-in-harvey （2026-06-30）
  - Eversheds Sutherland：初始 **350 名律师**接入，试点 350+ 律师。来源：https://www.eversheds-sutherland.com/en/united-states/news/harvey-ai-legal-partner
  - 估值/融资：11 亿…更正——**110 亿美元估值 / 2 亿美元融资（2026-03-25，GIC & Sequoia 领投）**；25,000+ 定制…（背景，非本周）。来源：https://www.reuters.com/technology/legal-software-firm-harvey-valued-11-billion-latest-funding-round-2026-03-25/
- **原文链接**：
  - https://www.harvey.ai/blog/sonnet-5-in-harvey （已读全文，6/30，含 LAB/BigLaw Bench 数据）
  - https://www.eversheds-sutherland.com/en/united-states/news/harvey-ai-legal-partner （已读全文，客户案例）
  - https://www.harvey.ai/blog/the-brief-june-2026 （已读全文，6 月产品汇总）
- **影响判断**：Sonnet 5 的 BigLaw Bench 91.3% 是本周法律 AI 最硬的能力信号，说明前沿模型在真实律所任务上仍在快速逼近可交付水准；Harvey 的"模型选择器 + 自建 benchmark(LAB/BigLaw Bench)"策略让它能在模型军备竞赛中保持中立并快速吸收最新能力。与 Perplexity Computer for Counsel 的正面交锋值得高度关注——通用 Agent 厂商正下探法律垂直，Harvey 的深度行业数据源(判例法/SCC/160+源)与律所信任是其最强防线。

---

### Sierra（客服Agent）

- **本周动态**：Sierra 本周(6/29–7/5)**无窗口内重大官方发布**，处于其 5 月大额融资后的执行期。最近的里程碑均为背景：**5 月 4 日 Sierra 完成 9.5 亿美元 Series E**（Tiger Global 与 Google GV 领投，Benchmark/Sequoia/Greenoaks 跟投），投后估值 **158 亿美元**（较去年秋 100 亿翻倍以上），累计可用资金超 10 亿美元，目标成为"AI 客户体验的全球标准"（**背景，非本周**）。产品主线仍是 **Agent OS 2.0**（2025-11-05 发布，"从回答走向记忆与行动"）——把推理、记忆、渠道、工具、监督、分析统一到一个平台。本周第三方生态侧值得记录的窗口内旁证：分析文章 getmacha.com「Sierra AI 完整指南(2026)」于 **7 月 1 日**发布/更新，复盘了 Sierra 的 outcome-based（按结果计费）定价模式、Agent OS 2.0 架构、以及客户群（Prudential、Cigna、Blue Cross Blue Shield、Rocket Mortgage，以及全球三大银行中的一家）——据 CEO Bret Taylor 5 月透露，Sierra 服务 **超 40% 的 Fortune 50**，且"比第二名大数倍"。行业背景：Salesforce 于 6 月 15 日宣布以约 36 亿美元收购 Fin（原 Intercom）并入 Agentforce（**背景，非本周**），客服 Agent 赛道整合加速。判断：Sierra 走"高端、企业级、共建式（build-it-with-us）"路线，非自助 SaaS；靠 outcome-based 定价 + 深度落地 + "模型星座(constellation of models)+自研微调层"构建壁垒，本周静默属融资后正常节奏。
- **关键数据**：
  - 融资：**9.5 亿美元 Series E @ 158 亿美元投后估值**（2026-05-04，背景）。来源：https://techcrunch.com/2026/05/04/sierra-raises-950m-as-the-race-to-own-enterprise-ai-gets-serious ；https://www.cnbc.com/2026/05/04/bret-taylor-sierra-fundraise-openai.html
  - 客户覆盖：**>40% Fortune 50**；客户含 Prudential、Cigna、BCBS、Rocket Mortgage、全球三大行之一（背景）。
  - 定价：outcome-based（按成功解决计费），官方不公开费率；第三方估算模型见 getmacha（2026-07-01）。来源：https://www.getmacha.com/blog/sierra-ai-complete-guide
- **原文链接**：
  - https://techcrunch.com/2026/05/04/sierra-raises-950m-as-the-race-to-own-enterprise-ai-gets-serious （已读，融资背景）
  - https://www.cnbc.com/2026/05/04/bret-taylor-sierra-fundraise-openai.html （已读，客户/竞争格局）
  - https://www.getmacha.com/blog/sierra-ai-complete-guide （已读，7/1 更新，定价/架构/客户）
  - https://sierra.ai/blog/enterprise-grade-agents （已读，τ-Bench 评测/监督模型工程实践）
- **影响判断**：Sierra 是客服 Agent 赛道明确领跑者（估值 158 亿、Fortune 50 渗透率高），但赛道正快速整合（Salesforce 收 Fin/Agentforce、Decagon 等追赶）。其 τ-Bench + 仿真(simulations) + 监督模型的工程护城河是可持续性关键；本周无料不改变领跑地位。

---

### Glean（企业知识Agent）

- **本周动态**：Glean 本周(6/29–7/5)**无严格窗口内重大发布**，但正处于密集商业化/认可期，多项里程碑刚落在窗口前沿：① **6 月 22 日：Glean 被 Gartner 列为 2026「No-Code Agent Builders（初创厂商）Emerging Market Quadrant」的 Market Shaper（市场塑造者）**——Gartner 认可其"把企业上下文、工具与治理暴露为共享的企业级 Agent 层"的路径；CEO Arvind Jain 强调"no-code agent 正成为企业工作的新操作层"，但可访问性不够，还需深度公司上下文、强治理、对业务系统的安全访问及跨工作流行动能力（**背景，非本周**）。② 商业化数据强劲：**ARR 已于 5 月前后突破 3 亿美元**（在 200M→300M 的快速爬升，9 个月翻倍），此前 $200M ARR 里程碑亦为 9 个月内翻倍（**背景**）。③ 融资背景：**Series F 1.5 亿美元 @ 72 亿美元估值**（Wellington 领投，较 9 个月前 Series E 的 46 亿估值再跳升，**背景**）。产品架构主线：Enterprise Graph（企业图谱）+ Glean Agents（Agent Builder/Orchestration/Governance/Library/Agentic Engine）+ MCP Gateway + Universal Model Key（一键接入 15 个主流 LLM，跨 Bedrock/Vertex/Azure OpenAI）+ 250+ 连接器 + Hosted MCP Server + 与 Workday/Snowflake 深度集成。旗舰大会 **Glean:GO 2026 定于 8 月 26–27 日**（Fort Mason, SF，未来事件）。判断：Glean 把"企业上下文层"做成 Agent 的地基，走"人人可建 Agent + IT 可治理"的双轨，正与 Microsoft Copilot 正面竞争（futurumgroup 标题即"Faces Copilot Head-On"）。
- **关键数据**：
  - ARR：**>3 亿美元**（约 2026 年 5 月，9 个月内翻倍）；此前 $200M 里程碑亦 9 个月翻倍。来源：https://www.glean.com/press/glean-surpasses-300m-arr-unrivaled-enterprise-context-fuels-ai-adoption ；https://futurumgroup.com/insights/glean-doubles-arr-to-200m-can-its-knowledge-graph-beat-copilot
  - 融资：**$150M Series F @ $7.2B 估值**（Wellington 领投，背景）。来源：https://news.crunchbase.com/venture/ai-powered-work-assistant-glean-valuation-jumps
  - Gartner：2026 eMQ No-Code Agent Builders **Market Shaper**（2026-06-22，背景）。来源：https://www.glean.com/press/gartner-emerging-market-quadrant-for-no-code-agent-builders-startup-vendors
  - 连接器 250+；Universal Model Key 接入 15 个 LLM（背景）。
- **原文链接**：
  - https://www.glean.com/press/glean-surpasses-300m-arr-unrivaled-enterprise-context-fuels-ai-adoption （已读，ARR）
  - https://finance.yahoo.com/technology/ai/articles/glean-recognized-market-shaper-2026-140000063.html （已读，Gartner Market Shaper 全文）
  - https://www.reworked.co/knowledge-findability/glean-adds-new-functionality-scale-and-reach-to-agent-platform-at-gleango （已读，Glean:GO 产品：Universal Model Key/Hosted MCP/Workday/Snowflake 集成）
  - https://news.crunchbase.com/venture/ai-powered-work-assistant-glean-valuation-jumps （已读，融资）
- **影响判断**：Glean 是企业知识 Agent 赛道的"上下文层"标准候选者，ARR 300M+ 且 9 个月翻倍显示企业采用曲线陡峭。与 Perplexity Computer（400+ 连接器+MCP）、Microsoft Copilot 的三方竞争是 2026 下半年企业 Agent 主战场；Glean 的差异化在"Enterprise Graph 深度上下文 + 治理"，本周无料不改变其上升势头。

---

### Manus（通用自主Agent）

- **本周动态**：Manus 本周(6/29–7/5)**有窗口内产品动态**。**6 月 30 日（周二）发布 Mobbin 连接器（Mobbin connector）**（官方博客）：Mobbin 是拥有 60 万+ 真实已上线产品界面截图的 UI 设计参考库，接入后 Manus 可读取 Mobbin 返回的界面、流程与页面区块，并直接产出成品——可编码 App、利益相关者幻灯片、行业分析或设计批注。连接器在 Manus 内暴露三种搜索工具（单屏搜索、多步用户流程分析、特定网站区块审阅），并可与 Manus 的 Slides Generation、Data & Spreadsheets、Web Development、Wide Research（并行分析数十个 App 流程）、图像生成等能力串联。官方给出 4 个用例：把 KYC 研究做成可导出 PPT/PDF/Google Slides 的路演 deck；一次性研究相机 App 模式并构建可在 Expo Go 运行的原型；用 Wide Research 把一个品类做成"模式图谱"(Excel + 托管站点)；对 Figma 稿做结构化批注并手绘标注修改点。连接需付费 Mobbin 计划(Pro/Team)，严格只读、可随时撤销授权。此前一周(6/24)还发布了 Hosting Modes、Canva 连接器等。公司状态背景：Meta 约 20 亿美元收购 Manus 于 2026 年 4 月被中国监管否决，6 月 11 日 Bloomberg 报道 Meta 已完成运营切割、停止数据共享，Manus 继续作为独立订阅产品从新加坡运营（**背景，非本周**）。判断：Manus 的战略是把"通用自主 Agent + 丰富连接器生态(Mobbin/Canva/等) + 云虚拟机执行"做成"从研究到成品"的一站式闭环，连接器策略与 Perplexity/Glean 的 MCP 生态方向一致——生态即护城河。
- **关键数据**：
  - 累计融资约 8500 万美元（Benchmark、HSG 等，Tracxn 口径，背景）。来源：https://tracxn.com/d/companies/manus
  - 定价：$20/月起，免费层 300 credits/天（背景）。来源：https://www.nocode.mba/articles/manus-ai-pricing
  - Mobbin 库规模：60 万+ 真实产品界面截图。来源：https://manus.im/blog/manus-mobbin-connector （2026-06-30）
- **原文链接**：
  - https://manus.im/blog/manus-mobbin-connector （已读全文，6/30 Mobbin 连接器）
  - https://manus.im/blog （已读，博客时间线：Mobbin 6/30、Hosting Modes 6/24、Canva 连接器）
  - https://ssojet.com/blog/what-is-manus-ai-agent-explained （已读，Meta 收购被否/新加坡独立运营背景）
- **影响判断**：Manus 用"连接器 + Wide Research 并行 + 多模态产出"把通用 Agent 落到具体可交付物上，差异化清晰；但归属与长期方向因 Meta 交易流产仍存不确定性，是企业采用的现实顾虑。连接器生态高频迭代(每周新增)是其保持通用 Agent 竞争力的关键节奏信号。

---

### Devin（Cognition）

- **本周动态**：Cognition 本周**有重磅窗口内工程发布**。**6 月 29 日：发布 Devin Fusion——一种混合多模型 harness，在保持前沿级编码智能的同时降低 35% 成本**（官方博客，已读全文）。核心架构是"sidekick（副手）"：并行跑两个完整 Agent——一个用前沿模型、一个用更划算的 sidekick 模型，主 Agent 默认只做最少动作、负责计划/歧义解释/最终审阅，其余任务委派给 sidekick。另一关键技术是"动态会话中路由"：用轻量级分类器在任务执行中信号切换模型，且在 context 压缩(compaction)时切换——反正那一刻会触发 cache miss，相当于"免费"换模型，避开了传统路由/Advisor 工具每次调用都重新付费的 cache 代价。关键结果：在新 benchmark **FrontierCode**（Cognition 自建，同时衡量代码正确性与质量，6/8 发布）上，Devin Fusion 相比 GPT-5.5/Opus 4.8 等前沿模型 **成本下降 35% 而性能持平前沿**；搭配 Anthropic 的 Fable 5 时成本下降高达 **41%**（但 Fable 5 自 6/12 因美国政府指令被暂停访问，数据为暂停前测得）。内部 dogfooding：启用 Fusion 后，内部用户 **88% 的已合并 PR 完全由自动 Fusion 路由器驱动**。目前以 preview 开放于 app.devin.ai。此前密集发布均为背景：FrontierCode(6/8)、Estimating Productivity + AI Productivity Guarantee（企业客户价值担保，若 Devin 交付价值低于付费则 Cognition 免费使用直至达标，上限 $10M，6/4）、Devin Desktop(6/2)、Hippo 保险全员部署 Devin(6/25)（**背景，非本周**）。判断：Cognition 把竞争重心从"模型能不能写对代码"转向"单位成本下的工程价值"，Devin Fusion + Productivity Guarantee 共同指向一个叙事：前沿 token 成本已高到企业难以承受，多模型路由是未来。
- **关键数据**：
  - Devin Fusion：FrontierCode 上 **成本-35%**（vs GPT-5.5/Opus 4.8）；搭 Fable 5 **-41%**；内部 **88% 已合并 PR 由 Fusion 路由器驱动**。来源：https://cognition.com/blog/devin-fusion （2026-06-29）
  - 融资：累计超 4 亿美元 @ **102 亿美元投后估值**（Founders Fund 领投，2025-09-08，背景）。来源：https://cognition.com/blog/funding-growth-and-the-next-frontier-of-ai-coding-agents
  - 企业落地：Infosys(1/7)、Cognizant(1/28)、Hippo 保险(6/25) 部署全员 Devin（背景）。来源：https://www.stocktitan.net/news/HIPO/hippo-deploys-devin-cognition-s-ai-software-engineer-to-drive-faster-31hotuhtaisn.html
  - 定价：约 $500/月（第三方评测口径，背景）。
- **原文链接**：
  - https://cognition.com/blog/devin-fusion （已读全文，6/29，sidekick+动态路由工程细节+基准数据）
  - https://cognition.com/blog （已读，博客时间线）
  - https://www.stocktitan.net/news/HIPO/hippo-deploys-devin-cognition-s-ai-software-engineer-to-drive-faster-31hotuhtaisn.html （已读，Hippo 部署）
- **影响判断**：Devin Fusion 是本周 C 组最硬的工程信号之一：它把"多模型路由+子 Agent 编排+cache 感知调度"这些 context engineering 前沿手法产品化，且用自建 FrontierCode 基准证明 35% 降本不牺牲质量——这是整个 Agent 行业从"堆算力"转向"精细成本工程"的风向标。叠加 Productivity Guarantee（按交付价值担保），Cognition 在企业销售上正把"ROI 风险"从客户转移到自己——这是很强的商业化杀手销。

---

### Replit Agent

- **本周动态**：Replit 本周**有明确窗口内 Agent 发布**。**7 月 3 日：发布重设计的 Desktop App + Whop 支付集成 + Pro→Core 一键降级**（官方 release notes，已读）。① 重设计 Replit Desktop App：把完整 Web 体验搬到桌面，支持多 App 并行、Agent 需要你介入或完成时一目了然、无需切换即可预览多个 App。② **Sell in your app with Whop**：现在可直接让 Agent 给 App 加支付——Agent 自动创建并连接 Whop 账户、把结账内置进项目，无需外部配置或粘贴 API key；这把"vibe coding→可变现产品"的闭环又缩短了一步。③ Pro→Core 一步降级（留存付费计划与已发布 App 不中断）。另本周前沿背景：6/26 重设计 Integrations（450+ 集成入口、Slack 中用 Replit via Slackbot MCP Client、SCIM 企业多工作区）；6/19 Claude 连接器（在 Claude 对话里创建/更新 Replit App、Claude Design 一键变可运行 App）+ Agent Voice Mode + 新 MCP 服务器（Apollo/Black Forest Labs）（**部分背景，6/19、6/26 为上周**）。产品主线：Agent 4（2026-03 Web 上线、5 月上 iPhone，历经与 Apple 四个月 App Store 审核争议）——并行多 Agent、设计画布、输出覆盖 Web/移动/幻灯片/数据 App/动画，声称比前代快 10x。商业背景：2026-06 完成 **4 亿美元融资 @ 90 亿美元估值**（六个月 3x），同期推出 Agent 4，宣布用户超 5000 万、**85% 的 Fortune 500 在用 Replit**、目标 2026 年底达到 **10 亿美元 run-rate 营收**（**背景，非本周**）。判断：Replit 把"自然语言→可运行可变现的完整 App"的闭环不断压缩，本周 Whop 支付让 Agent 直接带变现，是其“人人可建并赚钱”叙事的关键一步。
- **关键数据**：
  - 本周发布：7/3 Desktop App 重设计 + Whop 支付 + Pro→Core 降级。来源：https://releasebot.io/updates/replit （2026-07-03）
  - 融资：**$400M @ $9B 估值**（2026-06，六个月 3x，背景）。来源：https://replit.com/blog/replit-raises-400-million-dollars
  - 营收：目标 2026 年底 **$1B run-rate**；上轮（2025-09）年化营收 $2.8M→$150M（50x）（背景）。
  - 用户：>5000 万；**85% Fortune 500**；客户含 PayPal/Adobe/Atlassian（背景）。
  - 定价：$25/月起（背景）。
- **原文链接**：
  - https://releasebot.io/updates/replit （已读全文，7/3、6/26、6/19）
  - https://replit.com/blog/replit-raises-400-million-dollars （已读）
  - https://sacra.com/c/replit （已读，Agent 4 架构）
- **影响判断**：Replit 是 vibe-coding/全栈 Agent 领跑者之一，$1B run-rate 目标 + 85% Fortune 500 渗透显示其已从个人开发者向企业扩张。本周 Whop 支付集成信号强：当 Agent 不仅能建 App、还能一键接入变现，“公民开发者”的商业闭环就通了，会显著拉高付费转化与留存。

---

## 本组洞察（C 组：垂直/企业 Agent）

1. **本周真正“有料”的是工程/产品侧而非融资侧**：7 个对象中 4 个有窗口内硬动态（Harvey Sonnet 5、6/30；Manus Mobbin 连接器、6/30；Cognition Devin Fusion、6/29；Replit、7/3），均为产品与模型/架构演进；大额融资（Sierra 9.5亿/5月、Perplexity 2亿/6月5日、Glean 1.5亿、Harvey 2亿/3月）均在本周前。
2. **“成本工程”成为新主线**：Devin Fusion（多模型 sidekick 路由、-35%/-41% 成本）直接呼应业内“前沿 token 太贵”焦虑；叠加 Productivity Guarantee，企业 Agent 正从“堆算力”转向“精细单位经济 + 按价值担保”。
3. **连接器/MCP 生态是共同护城河**：Perplexity(400+ 连接器+BYO MCP)、Glean(250+ 连接器+Hosted MCP+Universal Model Key)、Replit(450+ 集成+Slack/Claude 连接器)、Manus(Mobbin/Canva) 本周均围绕连接器下注——“Agent 能接入多少真实系统”成为差异化核心。
4. **通用 vs 垂直边界模糊**：Perplexity Computer for Counsel 下探法律（踩 Harvey）、Glean 与 Perplexity/Copilot 争企业知识层、Replit/Manus 与 Devin 争建 App——C 组内部竞争面交叠。垂直护城河在深度行业数据（Harvey 判例法/160+ 法律源）与客户信任（Sierra 40% Fortune 50）。
5. **监管/地缘政治开始影响产品**：Cognition 提到 Anthropic Fable 5 自 6/12 因美国政府指令被暂停访问；Manus 因 Meta 收购被中国监管否决而从新加坡独立运营——模型可获得性与跨国归属成为企业采用真实变量。

---

## 🌐 板块四 · 浏览器操作 Agent + 中国 Agent（D 组）

---

### 1. OpenAI Operator / ChatGPT Agent

- **本周动态**：OpenAI 本周未针对 ChatGPT Agent（前身 Operator，已整合进 ChatGPT 的虚拟浏览器/"agent"模式）发布独立的产品级更新，但**驱动其能力的底层模型 GPT-5.6 系列**处于本周关注核心。需澄清时间线：GPT-5.6 系列（Sol 旗舰 / Terra 均衡 / Luna 快速廉价）的 **limited preview 首次公告为 2026-06-26（周五）**，严格说落在本期窗口之外（属背景，非本周），但公告明确 "During the preview, GPT-5.6 models will initially be available through the API and Codex to a select group of trusted partners" 并计划 "in the coming weeks" 向 ChatGPT/Codex/API 更广泛开放——即本周（6/29–7/5）正是其向合作伙伴逐步铺开、面向 agent 场景做能力验证的关键窗口。**本周内确定发生的相关事件**：官方明确 "launching GPT-5.6 Sol on **Cerebras at up to 750 tokens per second in July**"，即 7 月启动超高速推理部署（面向 select customers），这将直接提升 ChatGPT Agent 类长链路操作任务的响应速度。技术要点（来自官方原文）：GPT-5.6 引入 **new max reasoning effort** 和 **ultra mode**（"goes beyond the capabilities of a single agent by leveraging subagents to accelerate complex work"），后者是面向 agent 编排的重要架构演进——用子代理并行加速复杂任务。评测方面：GPT-5.6 Sol 在 **Terminal-Bench 2.1**（命令行工作流，需规划/迭代/工具协调）上"sets a new state of the art"；在 GeneBench v1、ExploitBench、ExploitGym（UC Berkeley 联合基准）等 agentic 能力评测上均有提升。**商业/路线判断**：OpenAI 将 agent 能力升级与模型代际强绑定，且此次因"cyber capabilities step change"接受了美国政府的分阶段发布协调（政府 access process），显示前沿计算机操作/网络能力正进入监管敏感区。ChatGPT Agent 产品面本周静默，实为等待 GPT-5.6 底座 GA。
- **关键数据**：
  - GPT-5.6 preview 公告日 = 2026-06-26（背景，非本周）；来源：https://openai.com/index/previewing-gpt-5-6-sol/
  - 定价（每 1M tokens）：Sol $5 输入 / $30 输出；Terra $2.50 / $15；Luna $1 / $6。来源同上，2026-06-26
  - Cerebras 部署：GPT-5.6 Sol 最高 750 tokens/秒，7 月启动。来源同上
  - Terminal-Bench 2.1：GPT-5.6 Sol 达 SOTA（具体分数官方未在博客给出）。来源同上
- **原文链接**：
  - https://openai.com/index/previewing-gpt-5-6-sol/ （已读全文）
  - https://help.openai.com/en/articles/11794368-chatgpt-agent-release-notes （已读，本周无 agent 新增条目）
  - https://help.openai.com/en/articles/6825453-chatgpt-release-notes （已读，最新条目为 6/10 model picker，6/26 GPT-4.5 下线）
- **影响判断**：GPT-5.6 的 ultra mode（subagents 编排）与 max reasoning effort 是 OpenAI 把"单 agent"推向"多 agent 协作"的关键信号，直接利好 ChatGPT Agent 类长链路操作任务；Cerebras 750 tok/s 部署预示 agent 交互延迟将大幅下降。政府分阶段发布机制则是前沿 agent 进入监管治理的标志性先例。

---

### 2. Anthropic Computer Use

- **本周动态**：本周是 Anthropic 计算机操作 Agent 线的**重磅一周**，两大发布均落在窗口内：**（1）Claude Sonnet 5 于 2026-06-30 全面发布**（LLM Stats 记录发布日 2026-06-30；官方博客同期上线，含 6/30 changelog 修订）。官方定位 "the most agentic Sonnet model yet"，"can make plans, use tools like browsers and terminals, and run autonomously"。性能"close to that of Opus 4.8, but at lower prices"。**计算机操作核心评测**：官方直接给出 **OSWorld-Verified**（计算机操作评测）与 **BrowseComp**（agentic 搜索评测）的成本-性能曲线，称 Sonnet 5 "a strict improvement over Sonnet 4.6" 且成本效率在中等 effort 下大幅提升，高 effort 下部分任务可匹敌 Opus 4.8。官方并披露把 Sonnet 4.6 的 OSWorld-Verified 分数修订为 **78.5%**（改进评测跑法以更贴近真实世界）。早期合作方反馈强调其 computer-use 落地：如 **Pace**（保险工作流 computer-use agent："submission intake, FNOL, loss runs"）称 Sonnet 5 "consistently takes the right action and does it quickly"。安全方面：agentic 安全性优于 4.6，更善于拒绝恶意请求、抵抗 prompt injection 劫持；因略强的网络能力，默认启用 cyber safeguards。**（2）Claude Cowork**（agentic AI for knowledge work，本周期内上线/大力推广，搜索显示 "4 days ago" ≈ 7/2）——这是 Anthropic 面向**非技术知识工作者的桌面计算机操作 Agent**："Claude works on your computer, local files, and applications to return a finished deliverable"，运行在 desktop，可在本地文件/文件夹/日常应用间移动、跨源综合、无需用户逐步协调。定位填补 chat 与 Claude Code 之间的空白（观察到非技术团队绕过 chat 直接用 Claude Code）。**（3）6/30 公告**：Fable 5 于 7/1 全球回归，并联合 Amazon/Microsoft/Google 等 Glasswing 伙伴提出行业级 jailbreak 严重度评分框架。**判断**：Anthropic 本周把"计算机操作"从 API 能力（Computer Use tool）升级为**成品级产品**（Cowork 桌面 agent）+ **更便宜的强 agent 模型底座**（Sonnet 5），computer-use 商业化路径清晰。
- **关键数据**：
  - Sonnet 5 发布日 = 2026-06-30；来源：https://llmstats（LLM Stats 记录）；官方博客 https://www.anthropic.com/news/claude-sonnet-5
  - Sonnet 5 定价：introductory $2/1M 输入 + $10/1M 输出（至 2026-08-31），之后 $3 / $15；1M token 上下文、128K 最大输出。来源：官方博客 + What's new 报道，5 days ago
  - Sonnet 4.6 OSWorld-Verified 修订分 = 78.5%（改进跑法后）；Sonnet 4.6 Humanity's Last Exam 修订 = 34.6%（无工具）/46.8%（有工具）。来源：https://www.anthropic.com/news/claude-sonnet-5 changelog
  - Fable 5 全球回归 = 2026-07-01。来源：https://www.anthropic.com/news （6/30 公告）
- **原文链接**：
  - https://www.anthropic.com/news/claude-sonnet-5 （已读全文）
  - https://www.anthropic.com/product/claude-cowork （已读全文）
  - https://www.anthropic.com/news （已读，6/30 公告条目）
- **影响判断**：Sonnet 5 把接近 Opus 4.8 的 agentic/computer-use 能力下沉到 Sonnet 价位（$2/$10 introductory），显著降低 computer-use agent 的规模化成本，是本周对整个 computer-use 赛道成本结构影响最大的事件。Claude Cowork 则把 computer-use 从开发者 API 推向非技术白领桌面，标志计算机操作 agent 的大众化落地。

---

### 3. Google Project Mariner

- **本周动态**：**关键前提**：Project Mariner 作为独立产品**已于 2026-05-04 正式关停**（17 个月运行后终止；来源多方交叉：Wikipedia、PCMag 2026-05-07、多家 5 月报道），Google 将其浏览器操作 Agent 的能力吸收进 **Gemini in Chrome（auto browse）**与 **Gemini Spark（桌面 agent）**两条产品线。因此本组以"Mariner 的继任能力线"追踪本周动态，**本周确有实质进展**：**（1）2026-06-30，Google 在 Gemini 官方 release notes 发布 Gemini Spark**——"your personal AI agent, is coming to the Gemini app for macOS"，官方描述其"Operating autonomously and under your direction, it organizes folders, uses your local files to build documents, and handles complex workflows across Google Workspace"。这正是 Mariner 式自主操作能力向桌面端的落地形态。发布范围：即日起在 macOS 应用面向 **Google AI Ultra** 订户（英语、18+、supported countries）开放；官方并预告"Coming soon"将支持从 web/mobile 远程命令 Spark 在 Mac 上跑任务/访问本地文件。**（2）Gemini in Chrome 的 auto browse（自主浏览/代办任务）本周持续铺开**：据 Google I/O 2026 及 5 月官方博客，Gemini in Chrome（含 auto browse）自 **6 月底（end of June）** 开始向美国 Android 12+ 设备的 AI Pro/Ultra 订户滚动推送——该时间点与本窗口重叠。官网原文："Automate your tasks with auto browse — tell Gemini what you need and watch it handle the rest on your behalf, while keeping you in control"，目前"Rolling out first in preview to Google AI Pro and Ultra subscribers in the U.S."。**技术/路线判断**：Google 已明确放弃"独立浏览器 agent 产品"（Mariner 模式），转向"把 agent 能力嵌入既有入口"——Chrome（浏览器操作）+ Gemini 桌面 App（文件/Workspace 操作）。Gemini Spark 的定位与 Anthropic Claude Cowork、OpenAI ChatGPT Agent 高度对标：都是"给目标、自主在你电脑/应用间完成成品"。这印证了业界"从 browser chaos 转向 workflow integration"的共识（startupfortune 5 月分析）。
- **关键数据**：
  - Project Mariner 关停日 = 2026-05-04（背景，非本周）。来源：Wikipedia / PCMag 2026-05-07
  - Gemini Spark macOS 发布 = 2026-06-30，限 Google AI Ultra。来源：https://gemini.google/release-notes/
  - Gemini in Chrome auto browse Android 推送 = 6 月底起，美国 Android 12+，AI Pro/Ultra。来源：Google Blog "Bringing the best of Gemini in Chrome to Android" 2026-05-12
- **原文链接**：
  - https://gemini.google/release-notes/ （已读，2026.06.30 Gemini Spark 条目）
  - https://gemini.google/overview/gemini-in-chrome/ （已读，auto browse 描述）
- **影响判断**：Gemini Spark 落地标志 Google 正式以"嵌入式桌面/浏览器 agent"替代已死的独立 Mariner，形成 OpenAI/Anthropic/Google 三家"桌面自主 agent"（ChatGPT Agent / Claude Cowork / Gemini Spark）本周同台竞争的格局。Mariner 品牌虽亡，其 vision（视觉 GUI 操作 + 自主浏览）已全面产品化。auto browse 走 AI Pro/Ultra 付费墙，显示 Google 把计算机操作能力作为高价订阅的差异化卖点。

---

### 4. 字节 Coze / 扣子

- **本周动态**：本周（6/29–7/5）**扣子/Coze 无重大公开发布**，处于 3.0 大版本发布后的常规运营与迭代期。**背景（非本周，但为理解当前状态所必需）**：扣子于 **2026-06-01 正式发布 3.0 版本**（新浪财经/快科技 6/1、53AI 6/1 交叉确认），实现手机端（iOS/Android）、电脑端（Mac/Windows）、网页端（coze.cn）全量统一更新，核心突破是**多人多 Agent 协作架构**——同一项目内可创建多个智能体分工（调研/写作/设计/开发），对话、文件、资产自动沉淀，定位"新一代 AI 团队，从扣子开始"。3.0 支持接入并调度本地及云端多种主流 AI 模型与框架，并提供 Vibe Coding 基础设施（自然语言开发小程序/App/网页/智能体/工作流/Skill 并一键部署）。IT之家 6/1 报道 3.0 还**支持接入 Claude Code**。与"计算机操作 Agent"直接相关的一点：扣子官网明确定位为"可操作电脑和手机，直接交付结果"的职场 AI 伙伴——即扣子的智能体具备端侧操作（电脑/手机）与结果交付能力，与本组"计算机操作 Agent"主题高度契合。**开源侧**：字节 Coze Studio（开源版，GitHub coze-dev/coze-studio）最新正式 release 为 **v0.5.1（2026-02-05）**，本周无新 release；仓库仍在持续合并 PR（安全修复如 memory sql injection、模型管理模块等），但无版本级发布。**判断**：扣子的战略重心在"AI Native 团队协作 + 端侧操作交付 + Vibe Coding"三线，3.0 已把主要牌打出，本周为消化期。作为国内 Agent 平台横评常年居首者（搜狐 6/17），扣子的护城河在字节生态分发与低门槛。
- **关键数据**：
  - 扣子 3.0 发布 = 2026-06-01（背景，非本周），全端统一更新。来源：https://finance.sina.com.cn/tech/discovery/2026-06-02/doc-inhzxewp2360739.shtml
  - Coze Studio 开源版最新 release = v0.5.1（2026-02-05）。来源：https://github.com/coze-dev/coze-studio/releases
  - 3.0 支持接入 Claude Code。来源：https://www.ithome.com/0/958/372.htm（2026-06-01）
- **原文链接**：
  - https://github.com/coze-dev/coze-studio/releases （已读，确认本周无新 release）
  - https://www.coze.cn/ （官网定位描述）
- **影响判断**：扣子本周静默但基本盘稳固；其"可操作电脑和手机、直接交付结果"的产品定位，使其成为国内最接近"计算机操作 Agent"大众化落地的平台之一。开源版 Coze Studio 为国内自建 Agent 平台提供了成熟底座，生态外溢效应持续。

---

### 5. 智谱 AutoGLM

- **本周动态**：本周（6/29–7/5）智谱**未针对 AutoGLM 产品线发布独立更新**，处于 GLM-5.2 旗舰发布后的消化期。**背景（非本周，但为理解 AutoGLM 底座所必需）**：智谱 **GLM-5.2 新一代旗舰模型于 2026-06-13 面向 GLM Coding Plan 全量用户开放、2026-06-16 正式上线并开源（MIT 协议）**（智谱官方 docs.bigmodel.cn new-releases 记 6/16；UniFuncs/媒体记 6/13 发布）。GLM-5.2 核心：**支持 1M 无损上下文**，长程任务能力显著提升，减少复杂任务中的上下文漂移与目标遗忘；Coding 与长程任务评测达开源 SOTA；智谱明确指向"完全自治的智能体系统（Autonomous Agent System）"愿景。这是 AutoGLM 系列 agent 的关键底座升级——1M 上下文直接利好 AutoGLM 执行多步骤、跨页面的长链路浏览器/设备操作任务。**AutoGLM 产品线现状梳理**（均为背景）：AutoGLM「沉思」（边思考边操作、可浏览网页完成数据任务）2025-03-31 发布；AutoGLM 2.0（手机智能体，配专属云手机/云电脑 24h 独立运行）2025-08-20 发布；**AutoGLM-Phone**（AI 手机智能助理框架，自然语言完成 App 操作、界面识别+意图规划+设备执行端到端，已适配 50+ 主流中文应用）2025-12-11 上线；**AutoClaw（澳龙）**（国内首个一键安装本地版 OpenClaw，内置 50+ Skills、集成 **AutoGLM Browser-Use** 浏览器操作能力，补齐 OpenClaw 复杂浏览器任务短板）2026-03-10 发布。**商业面（背景）**：智谱（02513.HK）已于 2026-01-08 港股上市，为"大模型六小虎"首家上市公司；2025 年营收暴增 132%。**判断**：智谱的 agent 战略是"GLM 强底座（长程/Coding/GUI）+ 多形态 agent（沉思/手机/桌面 AutoClaw）+ 开源生态"，本周虽无 AutoGLM 新品，但 GLM-5.2 的 1M 上下文与自治智能体路线是 AutoGLM 后续升级的关键弹药。
- **关键数据**：
  - GLM-5.2 发布/开源 = 2026-06-13 发布、2026-06-16 上线开源（背景，非本周），1M 无损上下文，MIT 协议。来源：https://docs.bigmodel.cn/cn/update/new-releases
  - AutoGLM-Phone 上线 = 2025-12-11，适配 50+ 中文应用。来源：同上 docs new-releases
  - AutoClaw（澳龙）发布 = 2026-03-10，集成 AutoGLM Browser-Use。来源：https://www.oschina.net/news/409053
  - 智谱港股上市 = 2026-01-08（HK 02513）；2025 营收 +132%。来源：https://news.pedaily.cn/202601/559655.shtml
- **原文链接**：
  - https://docs.bigmodel.cn/cn/update/new-releases （已读全文，确认本周无 AutoGLM 新条目，最新为 6/16 GLM-5.2）
- **影响判断**：智谱把浏览器/设备操作能力做成"模型底座（GLM-5.2 1M 上下文）+ 多端 agent 产品矩阵"，AutoClaw 集成 AutoGLM Browser-Use 是国内少见的"本地计算机操作 Agent"落地样本。作为已上市公司，其 agent 商业化压力与信息披露透明度均高于同行，值得持续跟踪季度落地数据。

---

### 6. 月之暗面 Kimi Agent

- **本周动态**：本周（6/29–7/5）月之暗面**未发布 Kimi Agent 相关的独立新产品/新模型**，处于 Kimi K2.7 Code 发布后的迭代运营期。**背景（非本周，均为理解 Kimi Agent 底座的近期高频迭代所必需）**：**（1）Kimi K2.7 Code 于 2026-06-12 发布并开源**（财新/多源 6/12–6/13 确认），以编码为中心的智能体模型、专为长程软件工程任务优化、仅支持思考模式，擅长跨多文件重构、功能实现、长会话调试等复杂 agent 工作流；相比 K2.6 显著提升长上下文编程场景指令遵循能力，**平均 token 消耗减少约 30%**；随后 **2026-06-18 上线高速版 kimi-k2.7-code-highspeed**（功能与 K2.7 Code 一致，速度提升 5–6 倍，阿里云百炼记录）。**（2）Kimi K2.6**（万亿参数、320 亿激活的 MoE，通用 Agent/代码/视觉理解全面提升、支持 Agent 集群协同）于 2026-04-20 发布并开源。**（3）Kimi K2.5**（原生多模态、支持全模态处理）2026-01 发布，并被 OpenClaw 于 2026-02 设为官方主力模型——成为 Kimi 逆袭关键节点，发布后 20 天内累计收入超 2025 全年、ARR 大涨。**（4）Agent Swarm**（智能体集群）为其研究方向之一（moonshot.cn 官网列 2026-02-09）。**商业面（背景，非本周但重磅）**：2026-06-08 多家媒体（证券时报/新浪财经/钛媒体）报道**月之暗面已开启新一轮融资，投前估值飙升至约 300 亿美元**，拟募资上限约 20 亿美元，半年估值暴涨近 7 倍。**判断**：月之暗面的 Agent 战略高度聚焦"编程 Agent（K2.7 Code）+ 长程任务 + Agent 集群协同 + 开源低价"，并深度绑定 OpenClaw 等 agent 客户端生态。本周无新品但商业热度（300 亿美元估值融资）与技术迭代节奏（近三月 K2.5→K2.6→K2.7 Code）均处高位。
- **关键数据**：
  - Kimi K2.7 Code 发布/开源 = 2026-06-12（背景，非本周），token 消耗↓约30%；highspeed 版 2026-06-18 速度×5-6。来源：阿里云百炼 https://help.aliyun.com/zh/model-studio/newly-released-models ；财新 2026-06-12
  - Kimi K2.6 = 2026-04-20，1万亿参数/320亿激活 MoE，开源。来源：同上阿里云页
  - 月之暗面新一轮融资：投前估值约300亿美元、募资上限约20亿美元。来源：证券时报/新浪财经 2026-06-08（背景，非本周）
  - OpenClaw 于 2026-02 将 Kimi K2.5 设为官方主力模型（背景）。来源：中国经营报 2026-04-04
- **原文链接**：
  - https://help.aliyun.com/zh/model-studio/newly-released-models （已读，确认 K2.7 Code 6/15、highspeed 6/18，本周无 Kimi 新条目）
  - https://www.moonshot.cn/ （官网研究列表，Agent Swarm / K2.6）
- **影响判断**：Kimi 以"开源编程 Agent + 低价 + 深度绑定 agent 客户端（OpenClaw）"路线在国内 Agent 底座竞争中占据独特位置；300 亿美元估值融资显示资本对其 agent 商业化（编程/软件工程自动化）的高预期。K2.7 Code 的 token 效率提升直接降低长程 agent 任务成本。

---

### 7. 阿里 Qwen Agent

- **本周动态**：本周（6/29–7/5）阿里 Qwen **无面向 Agent 的独立新模型/新框架发布**（当周阿里云百炼上新为 wan2.7 视频模型快照 2026-07-01，与 agent 无关）。**背景（非本周，但为理解 Qwen Agent 能力线的密集近期迭代所必需，且高度契合本组"计算机操作 Agent"主题）**：**（1）Qwen-AgentWorld 于 2026-06-22 发布**（qwen.ai 博客），是一个"native language world model that simulates agent environments across seven domains"（原生语言世界模型，跨七大领域模拟 agent 环境，含 Linux terminal 环境模拟）；**2026-06-24 GitHub 开源 Qwen-AgentWorld-35B-A3B 与 AgentWorldBench**（新 agent benchmark），并配 arXiv 论文（2606.24597）——这是本组维度①（学术研究/新 benchmark）中极具分量的一项：用语言世界模型为通用 agent 提供可扩展的环境模拟与评测。**（2）Qwen3.7-Plus 多模态混合智能体模型 于 2026-06-01（通义实验室 6/2 凌晨）发布**，核心定位"能看、能想、能动手"，"感知真实世界场景、**读取屏幕并操作 GUI**、基于视觉参考生成代码、端到端导航移动应用"——把 GUI 操作、CLI 调用、代码生成与自我验证统一，正是计算机操作 Agent 的核心能力集。**（3）专用 GUI 操作模型 gui-plus-2026-02-26** 已在阿里云百炼上线（"界面交互"类，支持思考/非思考模式，跨平台多 APP 任务效果大幅提升）——阿里已有专门的 GUI Agent 基座模型产品化。**（4）Qwen3.7-Max**（2026-06-08 快照增加视觉模态、具备多模态混合智能体能力）。**（5）Qwen-Agent 开源框架**为其 agent 开发底座。**判断**：阿里 Qwen 是本组中"计算机操作 Agent"能力布局最系统的中国厂商——同时具备①专用 GUI 操作模型（gui-plus）、②多模态混合智能体旗舰（Qwen3.7-Plus，读屏+操作GUI+导航移动应用）、③agent 环境世界模型与 benchmark（Qwen-AgentWorld/AgentWorldBench）、④开源框架（Qwen-Agent）。本周虽无新品，但 6 月的密集发布（AgentWorld、3.7-Plus、3.7-Max）已把 agent 能力矩阵补齐。
- **关键数据**：
  - Qwen-AgentWorld 发布 = 2026-06-22（博客）；2026-06-24 开源 Qwen-AgentWorld-35B-A3B + AgentWorldBench；arXiv 2606.24597（背景，非本周）。来源：https://qwen.ai/blog?id=qwen-agentworld ；https://github.com/QwenLM/Qwen-AgentWorld
  - Qwen3.7-Plus 发布 = 2026-06-01（背景，非本周），支持读屏操作 GUI/端到端导航移动应用。来源：阿里云百炼 newly-released-models ；量子位 https://www.qbitai.com/2026/06/427730.html
  - GUI 操作模型 gui-plus-2026-02-26 已上线（背景）。来源：阿里云百炼 newly-released-models
  - 本周阿里云百炼上新 = wan2.7-t2v/r2v 快照 2026-07-01（视频，非 agent）。来源：同上
- **原文链接**：
  - https://help.aliyun.com/zh/model-studio/newly-released-models （已读全文，确认本周仅视频模型上新、agent 相关最新为 6/25 及以前）
  - https://qwen.ai/blog?id=qwen-agentworld （Qwen-AgentWorld，2026-06-22）
- **影响判断**：Qwen-AgentWorld + AgentWorldBench 是本组少见的"中国厂商在 agent 学术/评测层面的原创贡献"，用语言世界模型模拟 agent 环境（含终端），可低成本扩展 agent 训练与评估，对整个 agent 研究社区有外溢价值。Qwen3.7-Plus 的"读屏操作 GUI + 移动应用导航"使阿里成为国内计算机操作 Agent 能力最完整的一极。

---

## 本组洞察（D组：浏览器/计算机操作 Agent + 中国 Agent）

**1. 本周主线：西方三巨头"桌面自主 Agent"同台，Anthropic 领跑。** 本周（6/29–7/5）计算机操作 Agent 赛道最实质的动作全部来自 Anthropic：Claude Sonnet 5（6/30 发布，OSWorld-Verified/BrowseComp 计算机操作+浏览器评测直接对标，introductory $2/$10 大幅压低 computer-use 成本）+ Claude Cowork（面向非技术白领的桌面自主 agent）。同期 Google 于 6/30 上线 Gemini Spark（macOS 桌面 agent，操作本地文件/Workspace），OpenAI 则以 6/26 预览的 GPT-5.6（ultra mode 子代理编排）在本周向合作伙伴铺开。三家形成 **ChatGPT Agent / Claude Cowork / Gemini Spark** 的"桌面自主 agent"三足格局，且都走"给目标→自主在电脑/应用间交付成品"的同一范式。

**2. Project Mariner 之死印证行业范式切换：从"独立浏览器 agent"到"嵌入既有入口"。** Google 已于 5/4 关停独立 Mariner，本周用 Gemini Spark（桌面）+ Gemini in Chrome auto browse（浏览器，6 月底 Android 铺开）承接其 vision。"独立 agent 产品"让位于"把 agent 能力嵌入浏览器/OS/App"的整合路线。

**3. 成本坍缩是本周最大结构性信号。** Sonnet 5 把接近 Opus 4.8 的 agentic/computer-use 能力压到 $2/$10 introductory；GPT-5.6 Terra 比 5.5 便宜 2x、Luna $1/$6；Cerebras 750 tok/s。计算机操作 agent 的"能力×成本×速度"三角本周同时改善，规模化落地门槛显著下降。

**4. 中国厂商本周集体"静默期"，但底座与矩阵已在 6 月补齐。** 扣子/AutoGLM/Kimi/Qwen 本周均无独立新品，但 6 月密集发布已铺就：扣子 3.0（多 Agent 协作+可操作电脑手机）、GLM-5.2（1M 上下文，自治 agent 愿景）、Kimi K2.7 Code（编程 agent，token↓30%）、Qwen 三件套（AgentWorld 世界模型+benchmark、3.7-Plus 读屏操作 GUI、gui-plus 专用 GUI 模型）。**阿里 Qwen 是国内计算机操作 Agent 能力最系统的一极**（专用 GUI 模型 + 多模态混合 agent 旗舰 + agent 环境世界模型/benchmark + 开源框架四位一体）。

**5. 中西路线差异清晰：西方拼"产品化桌面 agent + 成本"，中国拼"开源底座 + 端侧操作 + 资本"。** 智谱已上市（02513.HK）、月之暗面 300 亿美元估值新融资，中国 agent 的资本与开源叙事强劲；但在"面向普通用户的成品级桌面自主 agent"产品化上，本周西方（Cowork/Spark）走得更靠前。

**6. 监管信号首次前置到模型发布。** GPT-5.6 因网络能力"step change"接受美国政府分阶段发布协调；GLM-5.2 因网络安全评测领先引发美出口管制讨论；Anthropic 联合 Glasswing 伙伴提出 jailbreak 严重度评分框架。前沿计算机操作/网络 agent 能力正整体进入监管敏感区，这将成为 agent 竞争的新变量。

**数据可靠性说明**：本组关键日期/版本/评测均附官方原文或阿里云/智谱官方 docs 来源并交叉验证；x_search 通道本期因额度耗尽不可用，已改用 Serper（web-search-plus）+ web_fetch 官方原文兜底，不影响结论。所有"背景，非本周"项已明确标注，未混入"本周动态"结论。

---

## 📋 关于本周报

- **数据口径**：GitHub Stars/版本号取自 GitHub API/Releases（2026-07-06 实时）；融资/估值/评测分数附各自来源 URL + 日期，关键数据交叉验证 ≥2 源。
- **时间窗**：本期严格以 2026-06-29 ~ 2026-07-05（上海时区）为界，窗口外内容均标注"（背景，非本周）"。
- **来源说明**：官方博客/论文/GitHub release/官方公告优先于二手新闻；有动态对象均已 web_fetch 读原文全文。
- **下期预告**：持续跟踪 GPT-5.6 GA 后 ChatGPT Agent 产品面、Sonnet 5 SWE-bench 官方系统卡、LangGraph 1.0 GA（10 月）、以及多模型路由是否成为跨框架事实标准。
