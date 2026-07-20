# 全球 AI Agent 研究周报 · 第 7 期（2026-07-13 ~ 2026-07-19）


> **覆盖区间**：2026-07-13 ~ 2026-07-19（Asia/Shanghai，上一个完整自然周）  
> **覆盖范围**：编码 Agent/CLI、通用 Agent 框架、垂直企业 Agent、浏览器/计算机操作 Agent 与中国 Agent，共 28 个对象。  
> **时间窗声明**：区间外旧闻只作背景，不计入“本周动态”。有动态对象均尽量直读官方公告、GitHub release、官方文档或原文报道；无法确认日期/原文的条目已按静默或疑似线索处理。

## 本周一句话

> 本周 Agent 赛道的主线不是“单点能力演示”，而是向可长期运行、可审计、可沙箱化、可计费的生产级 Agent 系统收敛。

## 🔥 本周 TOP 5

### 1. Kimi K3：开放 3T 级长程工作模型 ｜ 本周

- 本周动态：Kimi 是本周 D 组最强信号。7月16日 Moonshot/Kimi 官方发布 Kimi K3，定位为 Kimi 迄今最强模型、全球首个开放的 3T 级模型，2.8 万亿参数，基于 Kimi Delta Attention 与 Attention Residuals，原生视觉，1M token 上下文，面向长程编程、知识工作和推理。官方明确把 K3 用在 Kimi.com、Kimi Work、Kimi Code 与 Kimi API：Kimi Work 提供 Widgets 和 Dashboard，让 chat 中的交互组件可视化且可持久化；Kimi Code 在终端选择 K3，支持长程 coding；API 兼容 OpenAI，`kimi-k3` 默认/当前仅支持 max thinking effort，支持工具调用、`tool_choice="required"`、动态加载工具、1M 上下文自动缓存、视觉输入、结构化输出。Agent 工程亮点是“动态加载工具”：在 `messages` 中插入带 `tools` 字段且不含 `content` 的 system message，从该位置起加载完整工具定义，解决工具定义膨胀和工具误选，可组合自定义 `search_tools` 实现 tool search；注意仅 K3 支持，服务端不保存声明。K3 技术博客给出大量长程 Agent 案例：24小时 GPU kernel 优化、从零构建 MiniTriton 编译器、48小时自主芯片设计、I-Love-Q 天体物理复现、42年 ASIC 行业交互研究网站（120+轮自我改进、2.8k+网页搜索/抓取、1.1k+终端数据拉取、11k+页面、87份季报、99份PDF）。商业化上，K3 API 定价为 cache-hit input $0.30/MTok、cache-miss input $3.00/MTok、output $15.00/MTok；官方称 coding workload cache hit rate above 90%。7月19日第三方转载 Kimi 公告称 K3 发布后48小时用户请求显著超预期、逼近集群承载极限，暂停 C 端新用户订阅，并计划拆分 Kimi 主权益与 Kimi Code 权益。
- 关键数据：Kimi K3：2.8T 参数、1M token 上下文、896 个专家中激活 16 个、相对 K2 整体 scaling efficiency 约 2.5×、完整权重计划 2026-07-27 前发布（Kimi，2026-07-16，[Kimi](https://www.kimi.com/blog/kimi-k3)）。API 价格：cache-hit input $0.30/MTok、cache-miss input $3.00/MTok、output $15.00/MTok；coding workloads 官方 API cache hit rate >90%（同源）。K3 `max_completion_tokens` 默认 131072、最大 1048576；`reasoning_effort` 当前仅 `max`；动态加载工具仅 K3 支持（[Kimi](https://platform.kimi.com/docs/guide/kimi-k3-quickstart)；[Kimi](https://platform.kimi.com/docs/guide/use-dynamic-tool-loading)）。PerceptionBench：3000 verified questions、10 atomic visual categories、40+ benchmarks 归因、无模型超过 60% accuracy（Kimi，2026-07-16，[Kimi](https://www.kimi.com/blog/perception-bench)）。
- 原文链接：[Kimi](https://www.moonshot.cn/)；[Kimi](https://www.kimi.com/blog/kimi-k3)；[Kimi](https://www.kimi.com/blog/perception-bench)；[Kimi](https://platform.kimi.com/docs)；[Kimi](https://platform.kimi.com/docs/guide/kimi-k3-quickstart)；[Kimi](https://platform.kimi.com/docs/guide/use-dynamic-tool-loading)；[来源](https://news.bjd.com.cn/2026/07/19/11874545.shtml)；[Qwen/阿里](https://help.aliyun.com/zh/model-studio/kimi-api-by-moonshot-ai)
- 影响判断：Kimi K3 把中国 Agent 竞争从“应用助手”推到“开放权重/开放 API 的长程工作模型”层面，并且把 tool bloat、缓存、长程 coding、知识工作可视化作为工程重点。其风险也很清楚：官方限制里承认 thinking history 敏感、过度主动，说明面向企业 Agent 仍需强约束 system prompt、AGENTS.md 与 harness 兼容性。

### 2. Dify Agent：低代码平台拥抱 Linux sandbox + Skills ｜ 本周

- 本周动态：Dify 是 B组本周最强动态。官方 GitHub release 1.16.0 于 2026-07-17 发布，标题就是 “Introducing Dify Agent (Beta): A New Agent Experience in Dify”。release 原文明确警告：Dify Agent services 只应提供给 trusted, non-malicious users，因为 shell-based LLM agent paradigm 带来重大能力跃迁，也带来更高风险。新 Dify Agent 运行在 Linux sandbox，提供 Agent builder：用户可在 UI 设置 base prompt、上传 Skills 和 files、连接 Dify 生态里的 tools 与 knowledge；同时提供一个“帮你构建 Dify Agents 的 agent”，可通过对话配置 Linux sandbox 环境、安装 packages、创建后续可用 Skills/files。Dify Agent 还接入 Workflow：既可在 workflow 中引用已有 Dify Agent，也可临时创建 inline Dify Agent，执行节点任务并把输出传给下一节点；新 web app 体验允许把构建好的 Dify Agent 发布成 web app。1.16.0 还包含 OpenAI GPT-5.6 Compatibility Notice：OpenAI plugin 默认 API type 从 Chat Completions 改为 Responses，旧用户需手动检查；Agent App open beta 默认启用，含 built-in sandbox、code execution/shell commands、skill system、agent roster、workflow agent node 引用；AI workflow generator 取消低价值 Ideal output、使用 workspace context 生成建议、并行 node config generation，`WORKFLOW_GENERATION_TIMEOUT_MS` 默认 180s；workflow-as-MCP server 支持 MCP protocol 2025-06-18、版本协商、structured tool output 与动态 HTTP headers。学术/benchmark 未见新增，商业化体现为开源平台向 agentic workflow product 升级。
- 关键数据：Dify 1.16.0 published_at 2026-07-17T11:14:06Z；`WORKFLOW_GENERATION_TIMEOUT_MS` 默认 180s；MCP protocol 2025-06-18；GitHub 2026-07-20 抓取：langgenius/dify 149,381 stars、23,543 forks、1,091 open issues，pushed_at 2026-07-20T03:50:40Z；release assets 包含 difyctl-v0.2.0-alpha 多平台二进制。
- 原文链接：[GitHub](https://api.github.com/repos/langgenius/dify/releases/tag/1.16.0)；[GitHub](https://github.com/langgenius/dify/releases/tag/1.16.0)；[GitHub](https://api.github.com/repos/langgenius/dify)
- 影响判断：Dify 1.16.0 标志着 no-code/low-code LLM app 平台正式拥抱“Linux sandbox + skills + workflow agent node”的 Agent 形态。它把开发者熟悉的 Dify 工作流和新一代 shell agent 结合，优势是上手快、生态集成强；风险也很直接：沙箱、trusted users、skill 权限和 MCP header passthrough 都需要企业治理。

### 3. Sierra Horizon：客服 Agent 转向业务结果 ｜ 本周

- 本周动态：Sierra 于 2026-07-16 发布《The next Horizon in agents》，正式宣布 Horizon 平台，把 Agent OS 从单次客服对话扩展到跨天、跨周、甚至跨月的“长周期目标”执行。官方给出的典型任务包括发起贷款、医疗流程 prior authorization、成交销售、升级订阅、安排试驾等；核心变化是 Horizon agents 会同时编排 outbound 与 inbound 互动，并用 context engine 串联客户、专员、推荐医生等多方多轮交互。Sierra 明确表示 Agent OS 已为“hundreds of companies”提供电话和聊天能力，客户包括 Santander、Rocket Mortgage、Cigna，并覆盖“almost half of the Fortune 50”；而 Horizon 是 2024 年公司发布以来最重要的扩展。技术/产品层面，Horizon 的关键词不是单轮回答准确率，而是 long-horizon planning、flexible context engine、每次互动后自动学习优化决策；商业模式也从 token 计费叙事切到 outcomes-based：客户为业务结果付费，不为 token 付费，Sierra 承担 token spend 管理。学术/benchmark 方面，官方没有披露公开评测集或量化 benchmark，只提供了医疗转诊预约等设计伙伴案例。
- 关键数据：发布日期 2026-07-16；Agent OS 服务 hundreds of companies；客户示例 Santander、Rocket Mortgage、Cigna；覆盖 almost half of the Fortune 50；来源：[Sierra](https://sierra.ai/blog/horizon（2026-07-16)）。
- 原文链接：[Sierra](https://sierra.ai/blog)；[Sierra](https://sierra.ai/blog/horizon)
- 影响判断：Horizon 把客服 Agent 的 KPI 从“解决一通对话”推进到“完成一个业务结果”，这会把客服、增长、销售运营和行业流程自动化合并到同一平台。其护城河叙事也从模型能力转向企业自有 customer context/memory，若 outcomes-based pricing 落地顺利，会对按 seat/token 收费的客服 AI 形成差异化压力。

### 4. Claude Code：编码 Agent CLI 的安全治理周 ｜ 本周

- 本周动态：本周有连续工程更新。官方 GitHub release 与 changelog 显示，Claude Code 在 2026-07-14 至 07-19 发布了 v2.1.208、v2.1.209、v2.1.210、v2.1.211、v2.1.212、v2.1.214、v2.1.215 等多个版本，重点不是新 benchmark，而是把编码 Agent/CLI 的“后台代理、子 Agent、安全权限、可观测性、企业环境”做深。v2.1.208 新增 screen reader mode（`claude --ax-screen-reader`、`CLAUDE_AX_SCREEN_READER=1`、或 settings 中 `axScreenReader: true`）、`vimInsertModeRemaps`、`CLAUDE_CODE_PROCESS_WRAPPER`，并修复后台 agent 文本丢失、自动更新导致 context window 短暂重置等问题。v2.1.210 修复 `isolation: 'worktree'` 子 Agent 可在主 checkout 执行 git mutating command 的隔离漏洞。v2.1.211 新增 `--forward-subagent-text` / `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT`，让 stream-json 输出携带子 Agent 文本和 thinking，同时修复 chat approval 中 bidi/zero-width/look-alike quote 字符造成的视觉混淆风险。v2.1.212 把 `/fork` 改成复制会话到后台 session，原 in-session subagent 改名 `/subtask`；新增 WebSearch 每会话默认 200 次上限、子 Agent spawn 默认 200 次上限、MCP 超过 2 分钟自动后台化等反 runaway 机制。v2.1.214 大规模加固 Bash/PowerShell/docker/file 权限分析，超过 10,000 字符命令始终提示，settings 文件 >2 MiB 启动失败，并加入 OTel 字段与 60 KB 内容属性截断配置。v2.1.215 则取消 Claude 自动运行 `/verify`、`/code-review` skills，要求用户显式调用。学术/商业侧未见本周新增论文、SWE-bench/GAIA 公开成绩或融资公告。
- 关键数据：GitHub API 2026-07-20 抓取：anthropics/claude-code 138,358 stars、22,205 forks、12,325 open issues，repo pushed_at 2026-07-19T21:36:21Z；v2.1.215 published_at 2026-07-19T02:56:01Z；v2.1.214 published_at 2026-07-18T01:20:30Z；WebSearch/subagent 默认上限均 200（v2.1.212 release）；MCP 自动后台阈值 2 分钟；OTel 内容属性默认截断 60 KB，可用 `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` 配置；settings >2 MiB 启动失败。
- 原文链接：[来源](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)；[GitHub](https://api.github.com/repos/anthropics/claude-code/releases?per_page=10)；[GitHub](https://api.github.com/repos/anthropics/claude-code)；[GitHub](https://github.com/anthropics/claude-code/releases)
- 影响判断：Claude Code 本周体现出“编码 Agent OS 化”的成熟方向：后台会话、子 Agent、MCP、远程/企业代理、OTel、权限规则都在同一 CLI 内收敛。安全修复密集，说明真实使用中权限 bypass、视觉混淆、后台代理生命周期已成为 Agent CLI 的主战场；短期对企业采用是利好，但也提示团队需要把自动模式和子 Agent 上限纳入治理基线。

### 5. Glean：企业 Agent 身份与数仓上下文 ｜ 本周

- 本周动态：Glean 本周有两条重要工程产品更新。其一，2026-07-15 发布 Agent identity public beta：企业 Agent 可用自己独立的 scoped service account credentials 行动，而不是借用触发者身份；可表现为 Slack/Teams 中自己的 bot、Jira 中自己的账号、GitHub 中自己的 App，动作在审计轨迹里以 Agent 自身账户归因，同时记录触发人或 schedule。官方强调这解决四类问题：用户权限不足导致 agent 不能跑、资深用户权限过高导致 agent 继承过大权限、长任务依赖用户 token 过期、以及审计归因混乱；管理员可注册、设定范围、轮换或撤销凭据。其二，2026-07-17 发布 Databricks in Glean Assistant：用户可在 Glean Assistant 中以自然语言查询 Databricks 数据或运行 read-only SQL，经 Databricks Genie 将自然语言转 SQL，再与 docs、tickets、notes、Slack、email、rollout plans 等企业上下文结合，生成文档、图表、slides 或 interactive artifacts。Glean 同时列出与 Databricks 的四类集成：Assistant 原生数据源、Connector 搜索 dashboards/Genie Spaces、Direct SQL in Glean、Databricks Genie/Genie Code with Glean MCP，且称这些 integrations 均已 GA。学术/benchmark 方面，本周未见公开企业知识 Agent benchmark；商业化数据未披露。
- 关键数据：Agent identity last updated Jul 15, 2026，public beta；Databricks in Glean Assistant last updated Jul 17, 2026，相关 integrations generally available；来源：[Glean](https://www.glean.com/blog/introducing-agent-identity)、[Glean](https://www.glean.com/blog/query-databricks-with-glean)。
- 原文链接：[Glean](https://www.glean.com/blog)；[Glean](https://www.glean.com/blog/introducing-agent-identity)；[Glean](https://www.glean.com/blog/query-databricks-with-glean)
- 影响判断：Glean 本周的重点是企业 Agent 治理与数据接入，而非单纯搜索体验。Agent identity 直接补上自主 Agent 在权限、归因、审计、长期运行上的企业级缺口；Databricks 集成则把结构化数仓与非结构化知识上下文放进同一 Assistant 工作流，强化其“企业上下文层+Agent 平台”的定位。

## 🧭 三大维度趋势

### 学术研究

- 本周公开 benchmark 与论文不是主流发布形态；更明显的是厂商把自有评测、生产指标与安全红队纳入 Agent 发布叙事。Kimi 的 PerceptionBench 与 K3 长程案例、OpenAI GPT-Red、Replit 内部 benchmark/A-B tests，显示评估正在从单步任务转向长程执行、视觉/网页输入、生产闭环与安全鲁棒性。
- 通用框架侧缺少统一可复现 benchmark，LangGraph、CrewAI、Dify、OpenAI Agents SDK、ADK 的更新更多落在 runtime、sandbox、MCP、hooks、trace、usage、tool-call 可信性上。

### Agent 工程

- 编码 Agent 正从单 CLI 升级为多会话、多 repo、多渠道、后台/云端/桌面统一的 Agent OS；权限规则、nested subagent 限制、MCP/session isolation、hooks、OTel、network policy、channel durable ingress 是本周最密集的治理点。
- 企业/浏览器 Agent 的共同瓶颈是工具定义膨胀、prompt injection、上下文缓存、沙箱隔离、计划确认、人类接管、subagent/工作流可观测性；OpenAI GPT-Red、Anthropic Computer Use 安全文档、Kimi 动态加载工具、Google prompt transpilation、Qwen MCP/WebShell 都指向这条工程主线。

### 商业化落地

- Agent 产品正在从“回答问题/自动化一步”转向“完成业务结果”：Sierra outcome-based Horizon、Manus Ascendea 客户故事、Replit 内部生产率数据、Glean Agent identity/Databricks、Dify Agent App open beta 都在证明 Agent ROI。
- 计费与容量成为核心变量：OpenAI ChatGPT Work/Guaranteed Capacity/Scale Tier、Google Gemini Enterprise Agent Platform、阿里百炼/Qwen、Kimi API 与 Dify/Workspace 生态，均把 Agent 能力放进企业计费、治理和 marketplace/console。

## 📊 赛道速查表

### 💻 编码 Agent / CLI

| 对象 | 状态 | 一句话 |
|---|---:|---|
| Claude Code（Anthropic） | 🔥 重大 | 本周有连续工程更新。官方 GitHub release 与 changelog 显示，Claude Code 在 2026-07-14 至 07-19 发布了 v2.1.208、v2.1.209、v2.1.210、v2.… |
| OpenAI Codex / Codex CLI | 🟢 一般 | 本周有稳定版与 alpha 版并行发布。OpenAI 官方 GitHub releases 显示，Codex Rust CLI 在 2026-07-16 发布 rust-v0.144.5，修复 dangerous-com… |
| OpenClaw（Agent OS） | 🟢 一般 | 本周 OpenClaw 有稳定版与 2026.7.2 beta 线更新。npm registry 显示，`openclaw` 包在时间窗内发布 2026.7.1（2026-07-13）、2026.7.2-beta.1（0… |
| Hermes Agent（自进化） | ⚪️ 静默 | 严格按 2026-07-13~07-19 时间窗，本周未发现 Hermes Agent 官方新增 release；GitHub releases 最新为 v0.18.2（v2026.7.7.2，发布日 2026-07-0… |
| Cursor（Anysphere） | 🟢 一般 | 本周 Cursor 有一项明确的官方 changelog：2026-07-17 “Improvements to Cursor in Slack”。官方页面说明 Cursor in Slack 现在会在开始前先分享 pl… |
| Cognition（Devin / Windsurf） | 🟢 一般 | 本周 Cognition / Devin 的核心公开动态是 Devin Desktop（Windsurf）v3.5.17，官方 changelog 日期 2026-07-19。Devin Desktop 侧更新包括：Ca… |
| OpenCode | 🟡 边缘 | OpenCode 本周持续密集发版，官方 changelog 与 GitHub releases 显示 2026-07-13 至 07-16 依次出现 v1.17.19、v1.17.20、v1.18.0、v1.18.1、… |

### 🧩 通用 / 自主 Agent 框架

| 对象 | 状态 | 一句话 |
|---|---:|---|
| LangChain / LangGraph | 🟡 边缘 | 本周 LangGraph Python 官方 GitHub release 在 2026-07-13~07-19 窗口内没有新的 Python release，最近 Python release 为 1.2.9（2026… |
| Microsoft AutoGen | ⚪️ 静默 | 本周 Microsoft AutoGen 未发现 2026-07-13~07-19 的新 release 或官方博客动态。GitHub releases 最新稳定版在当前 API 返回中为 python-v0.7.5（2… |
| CrewAI | 🟢 一般 | CrewAI 本周有明确工程 release。官方 GitHub releases 显示 2026-07-16 发布 1.15.3，随后 2026-07-17 发布 1.15.4。1.15.3 的核心是把 CrewAI … |
| Google ADK（Agent Development Kit） | 🟡 边缘 | Google ADK Python 本周没有新的 GitHub release；最新 release v2.4.0 发布时间为 2026-07-07（非本周）。但 repo 本周仍有 push（2026-07-17T21… |
| OpenAI Agents SDK / Swarm | 🟢 一般 | OpenAI Agents SDK 本周发布 v0.18.3（2026-07-17），是框架层面的真实动态；Swarm 作为旧的 educational framework，本周无 release，GitHub rele… |
| Dify | 🔥 重大 | Dify 是 B组本周最强动态。官方 GitHub release 1.16.0 于 2026-07-17 发布，标题就是 “Introducing Dify Agent (Beta): A New Agent Expe… |
| LlamaIndex Agents | 🟡 边缘 | LlamaIndex 本周没有正式 GitHub release；最近 release v0.14.23 发布时间为 2026-06-24（非本周），release 内容包括 llama-index-core 0.14.… |

### 🏢 垂直 / 企业 Agent 产品

| 对象 | 状态 | 一句话 |
|---|---:|---|
| Perplexity（Comet / 搜索 Agent） | 🟡 边缘 | 本周检索到的公开信号以 Perplexity 产品发布聚合页为主，官方站点的 changelog / blog / Comet 页面在抓取时返回 403（Cloudflare “Just a moment”），因此本条按… |
| Harvey（法律） | 🟡 边缘 | 本周查阅 Harvey 官方博客列表，发现可见最新主题为“Legal Agents for Every Matter, Tailored to You”，摘要称 Harvey 正引入改进后的 agentic capabi… |
| Sierra（客服） | 🔥 重大 | Sierra 于 2026-07-16 发布《The next Horizon in agents》，正式宣布 Horizon 平台，把 Agent OS 从单次客服对话扩展到跨天、跨周、甚至跨月的“长周期目标”执行。官… |
| Glean（企业知识） | 🔥 重大 | Glean 本周有两条重要工程产品更新。其一，2026-07-15 发布 Agent identity public beta：企业 Agent 可用自己独立的 scoped service account creden… |
| Manus（通用自主 Agent） | 🔥 重大 | Manus 本周连续发布三类信号。产品侧，7月13日 Auto-Publish 将 WebDev 项目的“构建成功→发布到公开 URL”做成可选自动化：在 publish popover 打开 toggle 后，每次 s… |
| Devin（独立追踪产品动态） | 🟢 一般 | Devin 本周可确认的官方更新来自 docs.devin.ai release notes 的 2026-07-15 条目，属于工程化与企业管理增强，而非大模型能力发布。具体包括：在 session 中可从文件、wor… |
| Replit Agent | 🔥 重大 | Replit 于 2026-07-16 发布《The Self-Driving Company》，虽不是单一 Replit Agent release note，但它是对 Replit 内部 Agent 系统在工程与全公… |

### 🌐 浏览器操作 + 中国 Agent

| 对象 | 状态 | 一句话 |
|---|---:|---|
| OpenAI Operator / ChatGPT Agent | 🟢 一般 | 本周 OpenAI 没有单独发布名为 Operator/ChatGPT Agent 的产品升级公告，但连续两篇官方材料直接指向“agentic era”的工程化与安全化。7月14日《How to manage AI in… |
| Anthropic Computer Use | 🟡 边缘 | Anthropic 本周未发布新的 Computer Use 专项功能，但官方平台 release notes 在7月14日和7月15日更新了与企业 Agent 管理密切相关的能力：7月14日 Claude Enterp… |
| Google Project Mariner / Gemini 浏览器与 Agent 平台 | 🟡 边缘 | 本周没有看到 Google 以 Project Mariner 名义发布浏览器操作 Agent 新功能；DeepMind 官方博客列表显示相关“Introducing computer use in Gemini 3.5… |
| 字节 Coze / 扣子 | ⚪️ 静默 | 本周未发现 Coze/扣子在 2026-07-13 至 2026-07-19 时间窗内发布与浏览器操作、GUI 自动化、Agent SDK/平台、benchmark 或商业化落地相关的重大官方公告。已检查的来源包括 Co… |
| 智谱 AutoGLM | 🟡 边缘 | 本周未检索到智谱以 AutoGLM 名义在 2026-07-13~2026-07-19 新发布官方公告；但官方文档当前已经把 AutoGLM-Phone 作为可调用模型页公开，且文档内容本身与本组“计算机/手机操作 Ag… |
| 月之暗面 Kimi Agent | 🔥 重大 | Kimi 是本周 D 组最强信号。7月16日 Moonshot/Kimi 官方发布 Kimi K3，定位为 Kimi 迄今最强模型、全球首个开放的 3T 级模型，2.8 万亿参数，基于 Kimi Delta Attent… |
| 阿里 Qwen Agent | 🟢 一般 | 本周 Qwen Agent 相关公开信号主要来自两个方向。其一，QwenLM/qwen-code 在 GitHub release 中持续快速迭代，搜索结果与 release 页显示本周有 v0.20.0/夜版更新，重点… |

## 📚 赛道深度正文

### 💻 编码 Agent / CLI

#### Claude Code（Anthropic）（详见 TOP5，同时保留完整对象记录）

- 本周动态：本周有连续工程更新。官方 GitHub release 与 changelog 显示，Claude Code 在 2026-07-14 至 07-19 发布了 v2.1.208、v2.1.209、v2.1.210、v2.1.211、v2.1.212、v2.1.214、v2.1.215 等多个版本，重点不是新 benchmark，而是把编码 Agent/CLI 的“后台代理、子 Agent、安全权限、可观测性、企业环境”做深。v2.1.208 新增 screen reader mode（`claude --ax-screen-reader`、`CLAUDE_AX_SCREEN_READER=1`、或 settings 中 `axScreenReader: true`）、`vimInsertModeRemaps`、`CLAUDE_CODE_PROCESS_WRAPPER`，并修复后台 agent 文本丢失、自动更新导致 context window 短暂重置等问题。v2.1.210 修复 `isolation: 'worktree'` 子 Agent 可在主 checkout 执行 git mutating command 的隔离漏洞。v2.1.211 新增 `--forward-subagent-text` / `CLAUDE_CODE_FORWARD_SUBAGENT_TEXT`，让 stream-json 输出携带子 Agent 文本和 thinking，同时修复 chat approval 中 bidi/zero-width/look-alike quote 字符造成的视觉混淆风险。v2.1.212 把 `/fork` 改成复制会话到后台 session，原 in-session subagent 改名 `/subtask`；新增 WebSearch 每会话默认 200 次上限、子 Agent spawn 默认 200 次上限、MCP 超过 2 分钟自动后台化等反 runaway 机制。v2.1.214 大规模加固 Bash/PowerShell/docker/file 权限分析，超过 10,000 字符命令始终提示，settings 文件 >2 MiB 启动失败，并加入 OTel 字段与 60 KB 内容属性截断配置。v2.1.215 则取消 Claude 自动运行 `/verify`、`/code-review` skills，要求用户显式调用。学术/商业侧未见本周新增论文、SWE-bench/GAIA 公开成绩或融资公告。
- 关键数据：GitHub API 2026-07-20 抓取：anthropics/claude-code 138,358 stars、22,205 forks、12,325 open issues，repo pushed_at 2026-07-19T21:36:21Z；v2.1.215 published_at 2026-07-19T02:56:01Z；v2.1.214 published_at 2026-07-18T01:20:30Z；WebSearch/subagent 默认上限均 200（v2.1.212 release）；MCP 自动后台阈值 2 分钟；OTel 内容属性默认截断 60 KB，可用 `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` 配置；settings >2 MiB 启动失败。
- 原文链接：[来源](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)；[GitHub](https://api.github.com/repos/anthropics/claude-code/releases?per_page=10)；[GitHub](https://api.github.com/repos/anthropics/claude-code)；[GitHub](https://github.com/anthropics/claude-code/releases)
- 影响判断：Claude Code 本周体现出“编码 Agent OS 化”的成熟方向：后台会话、子 Agent、MCP、远程/企业代理、OTel、权限规则都在同一 CLI 内收敛。安全修复密集，说明真实使用中权限 bypass、视觉混淆、后台代理生命周期已成为 Agent CLI 的主战场；短期对企业采用是利好，但也提示团队需要把自动模式和子 Agent 上限纳入治理基线。

#### OpenAI Codex / Codex CLI

- 本周动态：本周有稳定版与 alpha 版并行发布。OpenAI 官方 GitHub releases 显示，Codex Rust CLI 在 2026-07-16 发布 rust-v0.144.5，修复 dangerous-command detection，覆盖更多 forced `rm` 形式，并在命令被拒绝时给出更清晰的 rejection reasons；这一点直接对应 coding agent 在终端内执行破坏性命令的安全边界。2026-07-18 发布 rust-v0.144.6，刷新 GPT-5.6 Sol、Terra、Luna 的 bundled instructions，并把这些模型的 context window 修正为 272,000 tokens，release changelog 指向 #33972 与 #34009。同期还连续出现 rust-v0.145.0-alpha.13/14/15/16/18/19/20/22/23/24 等预发布，说明主干在快速迭代，但公开 release body 仅写 “Release 0.145.0-alpha.xx”，未披露具体功能细节。仓库元数据显示 openai/codex 描述为 “Lightweight coding agent that runs in your terminal”，语言 Rust，2026-07-19 仍有 push。本周未找到 OpenAI 官方博客公布新的 Codex benchmark、SWE-bench/GAIA/WebArena/τ-bench 成绩或商业定价/客户案例；因此有料部分主要来自工程 release 与 GitHub 元数据。
- 关键数据：GitHub API 2026-07-20 抓取：openai/codex 99,752 stars、14,932 forks、10,216 open issues，repo pushed_at 2026-07-19T21:42:15Z；rust-v0.144.5 published_at 2026-07-16T02:54:48Z；rust-v0.144.6 published_at 2026-07-18T13:51:52Z；GPT-5.6 Sol/Terra/Luna context window 修正为 272,000 tokens；本周至少 9 个 0.145.0-alpha 预发布。
- 原文链接：[GitHub](https://api.github.com/repos/openai/codex/releases?per_page=20)；[GitHub](https://github.com/openai/codex/releases)；[GitHub](https://api.github.com/repos/openai/codex)；[GitHub](https://github.com/openai/codex/blob/main/CHANGELOG.md)
- 影响判断：Codex CLI 本周重心是“安全命令判定 + 模型元数据准确性”，与 Claude Code 类似都在补终端 Agent 的执行安全短板。272k context window 的明确修正对大型 repo 任务有直接工程影响；但 alpha release 内容不透明，外部团队不宜仅凭 tag 节奏判断可用功能。

#### OpenClaw（Agent OS）

- 本周动态：本周 OpenClaw 有稳定版与 2026.7.2 beta 线更新。npm registry 显示，`openclaw` 包在时间窗内发布 2026.7.1（2026-07-13）、2026.7.2-beta.1（07-15）、2026.7.2-beta.2（07-17）、2026.7.1-1（07-18）、2026.7.1-2（07-18）、2026.7.2-beta.3（07-18），latest 指向 2026.7.1-2，beta 指向 2026.7.2-beta.3。GitHub release 2026.7.2 预发布说明内容很密集，重点是 Agent OS 层的“远程编码会话 + 多渠道网关 + 节点能力 + Control UI”。Highlights 包括：Control UI sessions 可运行在 cloud workers；Codex 与 Claude catalog sessions 可在 owning host 的 terminal 打开；OpenCode 与 Pi sessions 可直接 resume 到 terminal。移动端 Automations parity、Android 前台 Voice Wake、headless Linux node 暴露 camera/location/notification 能力进入节点体系。渠道安全方面修复 Telegram restart 后 durable-ingress loss、Signal 在 active turn 中 stop/approval 控制响应、channel allowlists 误授 owner access。Control UI 增强包括 Settings 配置模型 provider、channel guided setup、session 创建时选择 images/models。工程层新增 `OPENCLAW_SUPERVISOR_MODE=external`，让 OCM 等外部生命周期 owner 保留 restart/deferral 行为但阻止 native service mutation 与 self-update；MCP isolation 改为按 requesting session 作用域；Skill Workshop 可扫描历史会话生成保守、reviewable 的 skill ideas；Codex CLI bundled plugin 升至 0.144.6，并把 GPT-5.6 Codex context metadata 对齐上游 272k。学术/商业侧未见本周公开论文、benchmark 或融资定价公告。
- 关键数据：npm registry 2026-07-20 抓取：latest=2026.7.1-2，beta=2026.7.2-beta.3；2026.7.1 发布时间 2026-07-13T17:58:18.920Z，fileCount 8,550，unpackedSize 87,679,175；2026.7.1-2 发布时间 2026-07-18T03:53:48.967Z，unpackedSize 87,477,902；2026.7.2-beta.3 发布时间 2026-07-18T23:15:12.160Z，fileCount 10,143，unpackedSize 109,663,149；GitHub API 2026-07-20 抓取 openclaw/openclaw 383,504 stars、80,561 forks、6,924 open issues，pushed_at 2026-07-20T03:40:18Z；Gateway control-plane rate limiting 为 per-method buckets 30/min；Codex context metadata 272k。
- 原文链接：[来源](https://registry.npmjs.org/openclaw)；[GitHub](https://api.github.com/repos/openclaw/openclaw)；[GitHub](https://github.com/openclaw/openclaw/releases)；[来源](https://www.npmjs.com/package/openclaw（403)，已降级 npm registry）
- 影响判断：OpenClaw 本周把编码 Agent 从“单机 CLI”进一步抽象为可跨 Control UI、cloud worker、paired node、移动端和消息渠道运行的 Agent OS。对团队采用的价值在于统一 Claude/Codex/OpenCode/Pi 会话入口与网关治理；风险在于系统面更大，channel allowlist、MCP session scope、外部 supervisor 这类控制面安全需要严格回归测试。

#### Hermes Agent（自进化）

- 本周动态：严格按 2026-07-13~07-19 时间窗，本周未发现 Hermes Agent 官方新增 release；GitHub releases 最新为 v0.18.2（v2026.7.7.2，发布日 2026-07-08，非本周）。我查了 web_search（Hermes Agent self-evolving AI agent July 2026）、GitHub releases、GitHub repo 元数据与 README。可作为背景但不可计入本周动态的是：v0.18.2 是 v0.18.1 的 same-day patch，修复 WhatsApp Baileys 依赖，从 pinned git commit 改用发布的 `7.0.0-rc13`，使 Docker image builds 更可靠；v0.18.1 声称把 v0.18.0 后六天约 660 个 PR、667 commits、约 990 files、+89.5k/-10.4k lines 的 installer/updater self-healing、dashboard/gateway、WhatsApp pairing、MCP/provider fixes 打入稳定标签；v0.18.0（07-01，非本周）包含自进化核心叙事：Mixture-of-Agents 成为 selectable model，/goal completion contracts，验证 evidence，/learn 自动生成 reusable skill，/journey 可视化 memory/skills，background fan-out subagents，desktop coding Projects，gateway scale-to-zero/drain coordination，以及 cheaper self-improvement。README 也强调 Hermes 是 Nous Research 的 self-improving AI agent，具备 closed learning loop、agent-curated memory、skill creation、skills self-improve during use、FTS5 session search 与 Honcho dialectic user modeling。本周没有官方论文、benchmark、SWE-bench/GAIA/WebArena/τ-bench 成绩、融资或客户数据更新。
- 关键数据：GitHub API 2026-07-20 抓取：NousResearch/hermes-agent 217,322 stars、40,927 forks、23,973 open issues，pushed_at 2026-07-20T03:38:59Z；最新官方 release v0.18.2 published_at 2026-07-08T03:11:22Z（背景，非本周）；v0.18.1 背景数字：约 667 commits、约 990 files、+89.5k/-10.4k lines；v0.18.0 背景数字：~1,720 commits、998 merged PRs、2,215 files changed、~251,000 insertions、~41,000 deletions、949 issues closed、370+ contributors、P0 3 issues/8 PRs、P1 493 issues/188 PRs。
- 原文链接：[GitHub](https://api.github.com/repos/NousResearch/hermes-agent/releases?per_page=10)；[GitHub](https://github.com/NousResearch/hermes-agent/releases)；[GitHub](https://api.github.com/repos/NousResearch/hermes-agent)；[GitHub](https://github.com/NousResearch/hermes-agent)
- 影响判断：本周结论是“无新增公开大事件”，但其 7 月上旬发布展示了自进化 Agent 的完整产品化路线：记忆、技能、验证、MoA 与后台 fan-out 形成闭环。若下周 v0.19.0 如 release note 所称补齐 curated notes，应重点跟踪其是否把自学习治理、安全边界和成本控制讲清。

#### Cursor（Anysphere）

- 本周动态：本周 Cursor 有一项明确的官方 changelog：2026-07-17 “Improvements to Cursor in Slack”。官方页面说明 Cursor in Slack 现在会在开始前先分享 plan，便于用户早期介入和 redirect；执行中会更新 status，便于跟踪每一步。Slack 消息形态也被重做：in-message buttons 移除，改成 compact footer links，tables、PRs、artifacts 渲染更干净。工程上最重要的是 multi-repo environment support：从 Slack 触发时，Cursor 可在 named multi-repo environment 中启动，而不是只能绑定单一默认 repo；如果 frontend、backend、shared code 分散在多个 repo，Cursor 会读请求并选择能访问全部上下文的 environment；任务中如需当前 environment 外的 repo，会用 Switch repository button 请求切换并继续。跨渠道 workflow 也加强：Cursor 可读取其他 Slack channels/threads 的上下文，并把更新发回原 thread 或相关 channel。为确认上下文，我还读了 07-10（非本周但紧邻背景）的 Side Chats and Conversation Search：side chats 是 durable full agent conversation，可用 `/side`、`/btw` 或 plus 创建；conversation search 在 Agents Window 用 Cmd+K 搜索本地 agent transcript index；新增 cloud agent hooks 可观察/控制 prompts、responses、thinking、subagents、compaction、turn completion，hooks 列表含 beforeSubmitPrompt、afterAgentResponse、afterAgentThought、stop、subagentStart 等。官方博客本周（07-13~07-19）未见新的研究/商业文章；07-08 Grok 4.5 与 07-06 CFO council 属背景，非本周。
- 关键数据：Cursor 官方 blog/changelog 2026-07-20 抓取：本周 changelog 日期 2026-07-17；Slack docs 命令/选项包括 `@Cursor [prompt]`、`@Cursor settings`、`@Cursor agent [prompt]`、`@Cursor list my agents`，options 包括 `repo`、`env/environment`、`branch`、`model`、`autopr`、`worker/machine`、`pool`、`self_hosted`、`channel`；Cloud agent 支持 hooks 14 类：beforeShellExecution、afterShellExecution、beforeReadFile、afterFileEdit、preToolUse、postToolUse、postToolUseFailure、subagentStart、subagentStop、beforeSubmitPrompt、preCompact、afterAgentResponse、afterAgentThought、stop。
- 原文链接：[Cursor](https://cursor.com/changelog)；[Cursor](https://cursor.com/changelog/slack-improvements)；[Cursor](https://cursor.com/docs/integrations/slack)；[Cursor](https://cursor.com/docs/hooks#cloud-agent-support)；[Cursor](https://cursor.com/blog)
- 影响判断：Cursor 本周把 Cloud Agent 的入口从 IDE/Agents Window 扩展到团队 Slack 工作流，并开始处理多 repo、多 channel、多 thread 的真实企业协作场景。先 plan 后执行和状态更新降低了“黑箱 agent”风险；但跨频道读取与发消息会把权限、隐私和上下文泄漏治理推到 Slack 管理层面。

#### Cognition（Devin / Windsurf）

- 本周动态：本周 Cognition / Devin 的核心公开动态是 Devin Desktop（Windsurf）v3.5.17，官方 changelog 日期 2026-07-19。Devin Desktop 侧更新包括：Cascade 中 `@` mention pills 增加 type-specific icons；Agent Command Center 的 command palette 重新样式化；默认隐藏 status bar（可在 user settings 设置 `"workbench.statusBar.visible": true` 恢复）；新 worktree-backed sessions 现在立即打开，并在后台创建 worktree 时保持可交互；“View usage” 可直接打开 eligible Devin users 的 personal analytics；`devin.*` settings 中 gitignore access、completion mode、auto-continue 开始生效；恢复 agent session 时使用原 working directory，因此在其他目录启动的 Claude sessions 可重新加载；修复 Cascade Recent Chat History modal crash；Windows auto-updater 在应用更新前会清理 stale `Devin.exe`。Devin Cloud 侧：长 Devin Cloud sessions 的 render/scroll/type 更快，streaming 时保持响应；短暂 remote connection drop 不再闪 disconnected banner；可在 chat 内配置 session network policy，并 inline grant/deny network access requests，无需切到 web app。Devin Local 侧：customizations 与 sidebar skills count 覆盖所有 open workspace folders；Hooks tab 展示 hooks source 和 trigger events；新增命令把 Windsurf hooks 迁移到 Devin hooks；新增 timeline navigator 与 Fast Context support。另读官方 blog：07-09 GPT-5.6（非本周但仍在 7 月背景）已进入 Devin Desktop/CLI，Devin Cloud preview 到 07-16，Sol/Terra/Luna 分别定位旗舰、平衡、最快最低成本；FrontierCode 1.1 ExtendedScore/Cost 上强调 Sol 近半成本强结果、Terra 约半价达到 GPT-5.5 性能、Luna 最低 cost per task。商业页面显示 Devin Desktop trusted by 1M+ users 与 4000+ enterprise customers。
- 关键数据：Devin Desktop changelog v3.5.17 日期 2026-07-19；跨平台下载覆盖 macOS Apple Silicon/Intel zip+dmg、Linux x64 tar.gz+deb、Windows arm64/x64 user/system exe+zip；Devin blog 2026-07-09：GPT-5.6 Cloud preview through 2026-07-16，三模型 Sol/Terra/Luna；Terra 约半价匹配 GPT-5.5，Sol 约 next best model 半成本（具体曲线数值未公开在正文）；Devin Desktop 官方页 2026-07-20 抓取：1M+ users、4000+ enterprise customers。
- 原文链接：[Devin/Cognition](https://docs.devin.ai/desktop/changelog（由) [Devin/Cognition](https://windsurf.com/changelog) 跳转）；[Devin/Cognition](https://devin.ai/blog)；[Devin/Cognition](https://devin.ai/blog/gpt-5-6)；[Devin/Cognition](https://devin.ai/desktop/)
- 影响判断：Devin/Windsurf 本周把重点放在本地 IDE/桌面 agent cockpit 的可用性、session/network policy 控制和 Windsurf hooks 迁移，说明收购整合后正在把 Cloud、Desktop、Local 拉到同一治理面。Fast Context 与 worktree-backed session 立即可交互对开发体验直接增益；inline network grant/deny 则是企业安全审计会关注的新控制点。

#### OpenCode

- 本周动态：OpenCode 本周持续密集发版，官方 changelog 与 GitHub releases 显示 2026-07-13 至 07-16 依次出现 v1.17.19、v1.17.20、v1.18.0、v1.18.1、v1.18.2、v1.18.3。7 月 13 日两次 Core/TUI/Desktop 更新：支持 OpenAI pro reasoning mode，默认关闭 xAI Responses 的 response storage，新增 Luna Responses Lite OAuth，console logout 后可切换到另一个可用 org，GPT-5.6 over OAuth 使用 Codex context limits；TUI worker 转发 CLI environment variables；Desktop 侧修复 review panel width jump、clipped labels/branch tooltips、timeline outlines、context token counts 与 usage totals 对齐，并新增 per-prompt model selection、middle-click open sessions in new tab、review panel persistent file browsing/file tabs/open-in-app actions。v1.17.20 移除可能干扰 OpenAI Luna Responses Lite requests 的 obsolete Codex workaround，并更新 Azure AI 对 GPT-5.6 的支持。7 月 14 日 v1.18.0 完成 Desktop v2 migration，含新 layout upgrade handling 与 first-launch onboarding，并加入新旧 Desktop layout 过渡开关；修复 project picker、permission auto-accept state per server、remote sessions auto-accept permissions、terminal tabs focus、timeline reconnect/backfill、Home cold-load 等问题。v1.18.2（07-15）停止 subagents 默认启动 nested subagents，并提供可配置 `subagent_depth`；同时改善 Meta models 默认 reasoning depth。v1.18.3（07-16）新增 Up Arrow 在首项被选中时关闭 subagent picker；Desktop 修复 Home page scrolling、WSL server loading 计入 startup readiness、custom agent selector visibility，并让 Home command palette search 可查找和打开 sessions。未见本周论文、benchmark、融资/客户公告。
- 关键数据：GitHub API 2026-07-20 抓取：anomalyco/opencode 187,576 stars、23,582 forks、4,734 open issues，default_branch=dev，pushed_at 2026-07-20T03:31:14Z；v1.17.19 published_at 2026-07-13T16:34:56Z；v1.17.20 2026-07-13T21:09:56Z；v1.18.0 2026-07-14T20:29:48Z；v1.18.1 2026-07-14T21:37:54Z；v1.18.2 2026-07-15T16:15:38Z；v1.18.3 2026-07-16T15:34:33Z；v1.18.3 release assets 中 latest.yml download_count 321,947、latest-mac.yml 291,740、latest-linux.yml 158,788（抓取时点）。
- 原文链接：[来源](https://opencode.ai/changelog)；[GitHub](https://api.github.com/repos/sst/opencode/releases?per_page=20（跳转) anomalyco/opencode）；[GitHub](https://github.com/sst/opencode/releases（跳转) anomalyco/opencode）；[GitHub](https://api.github.com/repos/sst/opencode)
- 影响判断：OpenCode 本周明显在追赶桌面端 Agent IDE 体验与多模型适配：Desktop v2、review panel、per-prompt model、WSL readiness、nested subagent depth 都是高频真实使用痛点。默认禁止 nested subagents 是一个重要安全/成本边界，表明开源 coding agent 也开始从“能力扩张”转向“可控运行”。

**本板块洞察**：

- 学术/评测：本周 A 组对象没有新增公开论文或标准 benchmark 成绩；更值得注意的是厂商自有评测与模型元数据（Devin FrontierCode 1.1、Codex/OpenCode/OpenClaw 的 GPT-5.6 context/成本描述）正在成为产品发布语言的一部分，但开放可复现性仍弱。
- 工程：主线高度一致：编码 Agent 正从单 CLI 升级为多会话、多 repo、多渠道、后台/云端/桌面统一的 Agent OS；同时权限规则、nested subagent 限制、MCP/session isolation、hooks、OTel、network policy、channel durable ingress 成为本周最密集的工程治理点。
- 商业化：Cursor Slack、Devin Desktop/Cloud/Local、OpenClaw Control UI/移动节点都显示企业落地正在转向“协作入口 + 管理控制面”；明确商业数字较少，Devin 官方页披露 1M+ users 与 4000+ enterprise customers，Cursor 本周未新增收入/客户数据。

---

### 🧩 通用 / 自主 Agent 框架

#### LangChain / LangGraph

- 本周动态：本周 LangGraph Python 官方 GitHub release 在 2026-07-13~07-19 窗口内没有新的 Python release，最近 Python release 为 1.2.9（2026-07-10，非本周）；官方 Python changelog 页面在本周窗口内也没有新增条目，最近 changelog 是 2026-07-07 的 `deepagents` v0.7.0a6，包含 delete filesystem tool、`write_file` 覆盖、FilesystemMiddleware tools allowlist、Structured SystemPromptConfig 等，因日期在窗口外不计入本周动态。真正处于窗口内的公开发布是 JS/NPM 包 `@langchain/langgraph`：npm registry 显示 latest 为 1.4.8，发布时间 2026-07-15T04:49:06.933Z；官方 GitHub repo 本周仍有 push（2026-07-19T23:31:21Z），说明 LangGraph 生态在继续维护。由于 npm registry 元数据未给出 1.4.8 的细粒度 changelog，本期只把它作为“包版本更新”记录，不扩写为具体新功能。工程维度上，LangGraph 仍是 resilient/stateful agent runtime 的核心框架之一；但本周没有新的 benchmark、论文或商业化公告。
- 关键数据：`@langchain/langgraph` latest=1.4.8，发布时间 2026-07-15T04:49:06.933Z（npm registry）；GitHub 2026-07-20 抓取：langchain-ai/langgraph 37,635 stars、6,310 forks、631 open issues，pushed_at 2026-07-19T23:31:21Z。
- 原文链接：[来源](https://registry.npmjs.org/@langchain%2Flanggraph)；[GitHub](https://api.github.com/repos/langchain-ai/langgraph)；[GitHub](https://api.github.com/repos/langchain-ai/langgraph/releases?per_page=10)；[LangChain](https://docs.langchain.com/oss/python/releases/changelog)
- 影响判断：LangGraph 本周属于“低噪声维护周”，没有平台级新叙事，但 npm 包持续发布说明 JS agent runtime 仍在迭代。对企业采用而言，LangGraph 的关键仍是状态、检查点、长线程和错误恢复；本周缺少新公开功能，建议继续跟踪 Python/JS release 是否重新同步。

#### Microsoft AutoGen

- 本周动态：本周 Microsoft AutoGen 未发现 2026-07-13~07-19 的新 release 或官方博客动态。GitHub releases 最新稳定版在当前 API 返回中为 python-v0.7.5（2025-09-30，明显不在本周），仓库 pushed_at 也停在 2026-04-15T11:59:09Z；因此本期不能写作“本周更新”。为核验框架状态，已读 GitHub repo metadata 与 releases API；AutoGen 仍被描述为 “A programming framework for agentic AI”，但本周无工程 release、无学术 benchmark、无商业化新增披露。需要注意的是，AutoGen 历史 release 中已经包含 GraphFlow、MCP session failure handling、DockerCommandLineCodeExecutor 默认安全警告、Anthropic thinking mode、OpenAI GPT-5 reasoning_effort 等方向，但这些均非本周。
- 关键数据：GitHub 2026-07-20 抓取：microsoft/autogen 59,822 stars、9,005 forks、967 open issues，pushed_at 2026-04-15T11:59:09Z；本周新增 release：0。
- 原文链接：[GitHub](https://api.github.com/repos/microsoft/autogen)；[GitHub](https://api.github.com/repos/microsoft/autogen/releases?per_page=10)；[GitHub](https://github.com/microsoft/autogen/releases)
- 影响判断：AutoGen 本周公开节奏明显弱于 CrewAI、Dify、OpenAI Agents SDK 等活跃框架。它的历史定位仍是多 Agent 编程框架，但如果主仓长时间低频更新，生态注意力可能继续向 LangGraph、CrewAI、OpenAI Agents SDK 和 Google ADK 迁移。

#### CrewAI

- 本周动态：CrewAI 本周有明确工程 release。官方 GitHub releases 显示 2026-07-16 发布 1.15.3，随后 2026-07-17 发布 1.15.4。1.15.3 的核心是把 CrewAI 从“角色协作框架”进一步推向可插拔执行边界：新增 organization ID parameter 到 PlusAPI client；新增 step interception points，并围绕 `@on` 重做 execution hooks 文档；wire execution-boundary interception points；新增 generic interception-hook dispatcher；支持 declarative flows 在 TUI 上运行，并提供 headless terminal fallback。Bug fix 也集中在真实 agent runtime 痛点：OUTPUT hook 与 kickoff-completed event 同步、after_llm_call hooks 不破坏 native tool execution、tool-result caching 改为 opt-in、停止重写 authored tool description、结果中同时暴露 token usage、报告 per-call usage metrics、避免 route_turn falsy 时重放上一轮 intent。1.15.4 则把 Skills Repository 从 experimental 提升到正式状态，并补充 Flows in Studio 文档。学术/benchmark 未见本周官方论文；商业侧没有融资/客户数字，但 PlusAPI、Studio、Skills Repository 和 Flows 明显指向企业/团队工作流。
- 关键数据：1.15.3 published_at 2026-07-16T19:43:04Z；1.15.4 published_at 2026-07-17T14:33:30Z；GitHub 2026-07-20 抓取：crewAIInc/crewAI 55,803 stars、7,882 forks、656 open issues，pushed_at 2026-07-19T11:25:00Z。
- 原文链接：[GitHub](https://api.github.com/repos/crewAIInc/crewAI/releases?per_page=10)；[GitHub](https://github.com/crewAIInc/crewAI/releases/tag/1.15.3)；[GitHub](https://github.com/crewAIInc/crewAI/releases/tag/1.15.4)；[GitHub](https://api.github.com/repos/crewAIInc/crewAI)
- 影响判断：CrewAI 本周的关键词是“hooks 与技能正式化”。这说明通用 Agent 框架正在从 demo 编排转向可观测、可拦截、可审计的执行边界；tool-result caching 改 opt-in、token usage/per-call metrics 暴露，也反映出成本与可重复性开始成为框架一等能力。

#### Google ADK（Agent Development Kit）

- 本周动态：Google ADK Python 本周没有新的 GitHub release；最新 release v2.4.0 发布时间为 2026-07-07（非本周）。但 repo 本周仍有 push（2026-07-17T21:15:08Z），并且 v2.4.0 的 release 原文可作为近邻背景：它一次性加入 ManagedAgent backed by Managed Agents API、Workflow as Tool、DaytonaEnvironment remote sandbox workspaces、OpenAI Responses API support in labs、Vertex AI session TTL/expiration、Anthropic effort/thinking parameter propagation、MCP HTTP traces、mTLS for Google API tools/DiscoveryEngineSearchTool、BigQuery analytics 中 thinking/tool-use token columns、stream thought/media/code-exec/function-result deltas、streamed grounding/final usage metadata、Vertex AI load_profiles memory tool 等。因 v2.4.0 不在本周，本期只记录“本周无新 release”，但 ADK 的工程方向非常清楚：把 agent runtime、managed agents、workflow-as-tool、远程沙箱、可观测 token/trace 数据、企业 mTLS/安全参数整合到 Google Cloud 与 Gemini 生态中。本周 D组另外记录了 Google 7月16日 Gemini Enterprise Agent Platform 的 Parallel Web Search 与 prompt transpilation，这属于 Google Agent 平台侧动态，可作为 ADK 生态外部信号。
- 关键数据：GitHub 2026-07-20 抓取：google/adk-python 20,753 stars、3,721 forks、642 open issues，pushed_at 2026-07-17T21:15:08Z；最新 release v2.4.0 published_at 2026-07-07T19:45:22Z（非本周）。
- 原文链接：[GitHub](https://api.github.com/repos/google/adk-python)；[GitHub](https://api.github.com/repos/google/adk-python/releases?per_page=10)；[GitHub](https://github.com/google/adk-python/releases/tag/v2.4.0)；[Google](https://developers.googleblog.com/en/)
- 影响判断：ADK 本周没有可计入新发布，但 v2.4.0 近邻更新显示 Google 把 Agent 框架绑定到 Cloud-native 运行时、managed agent API、workflow、sandbox 和 telemetry。它与 LangGraph/CrewAI 的差异在于更强平台依赖，也更适合 Google Cloud 客户把 Agent 纳入既有企业治理。

#### OpenAI Agents SDK / Swarm

- 本周动态：OpenAI Agents SDK 本周发布 v0.18.3（2026-07-17），是框架层面的真实动态；Swarm 作为旧的 educational framework，本周无 release，GitHub releases API 返回空数组。v0.18.3 的变化集中在多 Agent runtime、computer/sandbox 并发安全、tracing 与 memory/session 修复：新增 task 与 turn tracing spans 可配置；Realtime session context 开始 track response usage；修复 OpenAI conversation session initialization 序列化；模型 provider args 冲突时抛 UserError 而非 assert；handoffs 保留带 history wrappers 的 user messages；computer 模块修复 concurrent runs 下 provider instances 隔离问题；sandbox 避免冗余 E2B workspace root creation；streamed session input 在 model retries 中保留；防止 stale prepared-item identity reuse；AdvancedSQLiteSession clear_session/pop_item 修复 metadata leaks；strict JSON schema conversion 对 `$ref` expansion 加 bound；trace error details 对非 tool 错误做 redaction。文档侧更新 hosted multi-agent support。结合 07-11 v0.18.2（非本周背景）的 hosted multi-agent beta 与 GPT-5.6 request controls，SDK 正在把 OpenAI 的 Computer Use、sandbox、hosted multi-agent、tracing/usage/memory 变成生产框架。
- 关键数据：openai-agents-python v0.18.3 published_at 2026-07-17T03:39:51Z；GitHub 2026-07-20 抓取：openai/openai-agents-python 28,023 stars、4,353 forks、51 open issues，pushed_at 2026-07-19T23:51:42Z；openai/swarm 21,843 stars、2,335 forks、40 open issues，pushed_at 2026-04-15T17:10:28Z，releases=[]。
- 原文链接：[GitHub](https://api.github.com/repos/openai/openai-agents-python/releases?per_page=10)；[GitHub](https://github.com/openai/openai-agents-python/releases/tag/v0.18.3)；[GitHub](https://api.github.com/repos/openai/openai-agents-python)；[GitHub](https://api.github.com/repos/openai/swarm/releases?per_page=10)；[GitHub](https://api.github.com/repos/openai/swarm)
- 影响判断：OpenAI Agents SDK 的本周重点不是新增酷炫 API，而是把生产 Agent 最容易出问题的地方补牢：并发隔离、sandbox、trace redaction、memory/session consistency 和 usage tracking。Swarm 基本已成为历史/教学入口，真正的生产路线已经转移到 Agents SDK。

#### Dify（详见 TOP5，同时保留完整对象记录）

- 本周动态：Dify 是 B组本周最强动态。官方 GitHub release 1.16.0 于 2026-07-17 发布，标题就是 “Introducing Dify Agent (Beta): A New Agent Experience in Dify”。release 原文明确警告：Dify Agent services 只应提供给 trusted, non-malicious users，因为 shell-based LLM agent paradigm 带来重大能力跃迁，也带来更高风险。新 Dify Agent 运行在 Linux sandbox，提供 Agent builder：用户可在 UI 设置 base prompt、上传 Skills 和 files、连接 Dify 生态里的 tools 与 knowledge；同时提供一个“帮你构建 Dify Agents 的 agent”，可通过对话配置 Linux sandbox 环境、安装 packages、创建后续可用 Skills/files。Dify Agent 还接入 Workflow：既可在 workflow 中引用已有 Dify Agent，也可临时创建 inline Dify Agent，执行节点任务并把输出传给下一节点；新 web app 体验允许把构建好的 Dify Agent 发布成 web app。1.16.0 还包含 OpenAI GPT-5.6 Compatibility Notice：OpenAI plugin 默认 API type 从 Chat Completions 改为 Responses，旧用户需手动检查；Agent App open beta 默认启用，含 built-in sandbox、code execution/shell commands、skill system、agent roster、workflow agent node 引用；AI workflow generator 取消低价值 Ideal output、使用 workspace context 生成建议、并行 node config generation，`WORKFLOW_GENERATION_TIMEOUT_MS` 默认 180s；workflow-as-MCP server 支持 MCP protocol 2025-06-18、版本协商、structured tool output 与动态 HTTP headers。学术/benchmark 未见新增，商业化体现为开源平台向 agentic workflow product 升级。
- 关键数据：Dify 1.16.0 published_at 2026-07-17T11:14:06Z；`WORKFLOW_GENERATION_TIMEOUT_MS` 默认 180s；MCP protocol 2025-06-18；GitHub 2026-07-20 抓取：langgenius/dify 149,381 stars、23,543 forks、1,091 open issues，pushed_at 2026-07-20T03:50:40Z；release assets 包含 difyctl-v0.2.0-alpha 多平台二进制。
- 原文链接：[GitHub](https://api.github.com/repos/langgenius/dify/releases/tag/1.16.0)；[GitHub](https://github.com/langgenius/dify/releases/tag/1.16.0)；[GitHub](https://api.github.com/repos/langgenius/dify)
- 影响判断：Dify 1.16.0 标志着 no-code/low-code LLM app 平台正式拥抱“Linux sandbox + skills + workflow agent node”的 Agent 形态。它把开发者熟悉的 Dify 工作流和新一代 shell agent 结合，优势是上手快、生态集成强；风险也很直接：沙箱、trusted users、skill 权限和 MCP header passthrough 都需要企业治理。

#### LlamaIndex Agents

- 本周动态：LlamaIndex 本周没有正式 GitHub release；最近 release v0.14.23 发布时间为 2026-06-24（非本周），release 内容包括 llama-index-core 0.14.23、multimodal synthesis part 2、DocumentBlock/VideoBlock tool output 解析、URL-backed video/document memory blocks、multimodal query engines、workflow initial_state deep copy 防止跨 run mutation leaks 等，均不计入本周动态。本周窗口内 repo 只有一个可见 commit：2026-07-16 `fix(ag-ui): raise ValueError instead of fabricating tool_call_id (#22103)`，这是 AG-UI / tool call 可信性相关修复。该修复虽然不是大版本，但对于 agent tool calling 很关键：框架不应在缺少真实 tool_call_id 时“伪造”一个 ID，否则 tracing、审计、回放和多工具并发时可能产生错误关联。本周未见 LlamaIndex 新 benchmark、融资或客户公告；作为 document agent / OCR / RAG+agent 平台，它处于维护节奏。
- 关键数据：GitHub 2026-07-20 抓取：run-llama/llama_index 50,950 stars、7,776 forks、567 open issues，pushed_at 2026-07-16T05:24:11Z；本周 commit dbdaf89d，2026-07-16T05:24:10Z，`fix(ag-ui): raise ValueError instead of fabricating tool_call_id (#22103)`；正式 release 本周新增 0。
- 原文链接：[GitHub](https://api.github.com/repos/run-llama/llama_index/releases?per_page=10)；[GitHub](https://github.com/run-llama/llama_index/commit/dbdaf89dc66a6469081c9f8fddc9c1bf6c43d8a2)；[GitHub](https://api.github.com/repos/run-llama/llama_index)
- 影响判断：LlamaIndex 本周没有大版本，但 tool_call_id 真实性修复反映出 agent 框架正在进入“审计一致性”阶段：错误的工具调用标识会污染后续 evaluation、observability 和 replay。对以文档/检索为核心的 Agent 平台来说，工具调用链路的可追踪性比单次 RAG 准确率越来越重要。

**本板块洞察**：

- 学术/评测：本周通用框架没有新的公开 benchmark 或论文成为主线；更新集中在 runtime、sandbox、MCP、workflow、hooks、trace/usage 和 tool-call 可信性。评测侧仍缺少统一可复现的框架级 agent benchmark。
- Agent工程：最强信号是“生产化执行边界”：CrewAI hooks/Skills、OpenAI Agents SDK tracing/并发隔离、Dify Linux sandbox+skills+MCP、LlamaIndex tool_call_id 真实性、Google ADK managed agents/workflow-as-tool 背景，都指向可观测、可拦截、可审计、可沙箱化。
- 商业化落地：Dify 1.16.0 是最明确的平台商业化信号，把 Agent App 默认开到 open beta；CrewAI 的 PlusAPI/Studio/Skills Repository 和 Google ADK 的 Cloud-native 路线也在把框架变成组织可管理产品，而不仅是开源库。

---

### 🏢 垂直 / 企业 Agent 产品

#### Perplexity（Comet / 搜索 Agent）

- 本周动态：本周检索到的公开信号以 Perplexity 产品发布聚合页为主，官方站点的 changelog / blog / Comet 页面在抓取时返回 403（Cloudflare “Just a moment”），因此本条按“已直读可访问原文，但官方原页未能直读”的审慎口径记录。Releasebot 抓取到的 Perplexity 7月更新显示，Perplexity 正把搜索 Agent 从“问答/浏览器侧助手”扩展为更完整的企业/个人工作流平台：Computer 面向 Pro 用户开放 Web 与 iOS，声称包含 20+ 高级模型、预置和自定义 skills、数百个 connectors；Enterprise/Slack 版本面向 Enterprise Max/Pro，可在 Slack DM 与频道 mention 中执行分析、生成代码和定时工作流，并连接 Snowflake、Salesforce、HubSpot 等。Comet 侧，Enterprise 版本支持 macOS/Windows 的 MDM 静默部署、数百项浏览器策略、AI Agent 行为控制、审计日志/权限/数据保留继承，并强调数据不用于训练；桌面版新增选中文本的 inline assistant（fact-check、define、summarize、translate、improve）与标签组/菜单重设计。商业化/平台化信号包括 API Platform（Agent API、Search API、Embeddings API、Sandbox API coming soon）、BYOC/MCP 自定义远程连接器、Finance Computer 的 Plaid 券商账户连接、40+ 金融工具源、Polymarket、以及 CB Insights/PitchBook/Statista premium sources。
- 关键数据：20+ advanced models、400+ applications/connectors、40+ finance tools、API Platform 四类 API（Agent/Search/Embeddings/Sandbox coming soon）、“hundreds of millions of Samsung devices”和“6 of 7 MAG7”采用表述；来源：[来源](https://releasebot.io/updates/perplexity-ai（页面标题) July 2026；抓取时间 2026-07-20）。官方原页 [来源](https://www.perplexity.ai/changelog/what-we-shipped---march-13-2026) 抓取 403，日期字段疑似聚合页映射异常，未作为精确发布日期。
- 原文链接：[来源](https://releasebot.io/updates/perplexity-ai)；[来源](https://www.perplexity.ai/changelog/what-we-shipped---march-13-2026（尝试直读但) 403）；[来源](https://www.perplexity.ai/comet（尝试直读但) 403）
- 影响判断：Perplexity 的本周信号显示 Comet/Computer 正从消费者搜索入口转向企业可管控 Agent 运行时：浏览器 Agent、Slack Agent、MCP connector、数据仓库和金融数据源被打包进一个工作流面。最大不确定性在于官方原文未能抓取，需要后续以官方可访问 changelog 复核发布日期与可用范围；但若这些能力已上线，Perplexity 与 Glean/ChatGPT Enterprise 的竞争边界会更接近。

#### Harvey（法律）

- 本周动态：本周查阅 Harvey 官方博客列表，发现可见最新主题为“Legal Agents for Every Matter, Tailored to You”，摘要称 Harvey 正引入改进后的 agentic capabilities，让用户能更快获得一致、高质量的法律工作结果；但博客列表未暴露日期，按标题推测可能为近期产品更新，尝试以多种 slug（包括 /blog/legal-agents-for-every-matter-tailored-to-you、/blog/legal-agents）打开原文均返回 404，搜索限定 2026-07-13 至 2026-07-20 也未检索到可验证的官方/新闻原文。由于任务要求有本周动态必须直读官方公告/原始来源全文，本期不把该摘要写作“本周已确认动态”，而归入“已查到疑似近期产品线索、无法确认在本周窗口内发布”。商业化、融资/估值、客户采用与监管方面，本轮在可用搜索与官网抓取内没有发现 2026-07-13~07-19 的新增公开披露；未公开。学术/benchmark 方面未见 Harvey 自身本周发布法律 Agent benchmark 或评测报告。
- 关键数据：本周无可核验新增关键数字；融资/估值/营收/客户本周新增披露未公开。
- 原文链接：[来源](https://www.harvey.ai/blog（已读博客列表)）；[来源](https://www.harvey.ai/blog/legal-agents-for-every-matter-tailored-to-you（尝试直读)，404）；[来源](https://www.harvey.ai/blog/legal-agents（尝试直读)，404）
- 影响判断：Harvey 似乎在继续把法律 AI 从问答/文书辅助升级为“matter-level legal agents”，但本周缺少可验证原文与日期，不能作为本周重大动态。对企业法律场景而言，真正值得继续追踪的是其 agentic capabilities 是否给出可审计工作流、法律准确性评测与客户部署边界，而这些本周未公开。

#### Sierra（客服）（详见 TOP5，同时保留完整对象记录）

- 本周动态：Sierra 于 2026-07-16 发布《The next Horizon in agents》，正式宣布 Horizon 平台，把 Agent OS 从单次客服对话扩展到跨天、跨周、甚至跨月的“长周期目标”执行。官方给出的典型任务包括发起贷款、医疗流程 prior authorization、成交销售、升级订阅、安排试驾等；核心变化是 Horizon agents 会同时编排 outbound 与 inbound 互动，并用 context engine 串联客户、专员、推荐医生等多方多轮交互。Sierra 明确表示 Agent OS 已为“hundreds of companies”提供电话和聊天能力，客户包括 Santander、Rocket Mortgage、Cigna，并覆盖“almost half of the Fortune 50”；而 Horizon 是 2024 年公司发布以来最重要的扩展。技术/产品层面，Horizon 的关键词不是单轮回答准确率，而是 long-horizon planning、flexible context engine、每次互动后自动学习优化决策；商业模式也从 token 计费叙事切到 outcomes-based：客户为业务结果付费，不为 token 付费，Sierra 承担 token spend 管理。学术/benchmark 方面，官方没有披露公开评测集或量化 benchmark，只提供了医疗转诊预约等设计伙伴案例。
- 关键数据：发布日期 2026-07-16；Agent OS 服务 hundreds of companies；客户示例 Santander、Rocket Mortgage、Cigna；覆盖 almost half of the Fortune 50；来源：[Sierra](https://sierra.ai/blog/horizon（2026-07-16)）。
- 原文链接：[Sierra](https://sierra.ai/blog)；[Sierra](https://sierra.ai/blog/horizon)
- 影响判断：Horizon 把客服 Agent 的 KPI 从“解决一通对话”推进到“完成一个业务结果”，这会把客服、增长、销售运营和行业流程自动化合并到同一平台。其护城河叙事也从模型能力转向企业自有 customer context/memory，若 outcomes-based pricing 落地顺利，会对按 seat/token 收费的客服 AI 形成差异化压力。

#### Glean（企业知识）（详见 TOP5，同时保留完整对象记录）

- 本周动态：Glean 本周有两条重要工程产品更新。其一，2026-07-15 发布 Agent identity public beta：企业 Agent 可用自己独立的 scoped service account credentials 行动，而不是借用触发者身份；可表现为 Slack/Teams 中自己的 bot、Jira 中自己的账号、GitHub 中自己的 App，动作在审计轨迹里以 Agent 自身账户归因，同时记录触发人或 schedule。官方强调这解决四类问题：用户权限不足导致 agent 不能跑、资深用户权限过高导致 agent 继承过大权限、长任务依赖用户 token 过期、以及审计归因混乱；管理员可注册、设定范围、轮换或撤销凭据。其二，2026-07-17 发布 Databricks in Glean Assistant：用户可在 Glean Assistant 中以自然语言查询 Databricks 数据或运行 read-only SQL，经 Databricks Genie 将自然语言转 SQL，再与 docs、tickets、notes、Slack、email、rollout plans 等企业上下文结合，生成文档、图表、slides 或 interactive artifacts。Glean 同时列出与 Databricks 的四类集成：Assistant 原生数据源、Connector 搜索 dashboards/Genie Spaces、Direct SQL in Glean、Databricks Genie/Genie Code with Glean MCP，且称这些 integrations 均已 GA。学术/benchmark 方面，本周未见公开企业知识 Agent benchmark；商业化数据未披露。
- 关键数据：Agent identity last updated Jul 15, 2026，public beta；Databricks in Glean Assistant last updated Jul 17, 2026，相关 integrations generally available；来源：[Glean](https://www.glean.com/blog/introducing-agent-identity)、[Glean](https://www.glean.com/blog/query-databricks-with-glean)。
- 原文链接：[Glean](https://www.glean.com/blog)；[Glean](https://www.glean.com/blog/introducing-agent-identity)；[Glean](https://www.glean.com/blog/query-databricks-with-glean)
- 影响判断：Glean 本周的重点是企业 Agent 治理与数据接入，而非单纯搜索体验。Agent identity 直接补上自主 Agent 在权限、归因、审计、长期运行上的企业级缺口；Databricks 集成则把结构化数仓与非结构化知识上下文放进同一 Assistant 工作流，强化其“企业上下文层+Agent 平台”的定位。

#### Manus（通用自主 Agent）

- 本周动态：Manus 本周连续发布三类信号。产品侧，7月13日 Auto-Publish 将 WebDev 项目的“构建成功→发布到公开 URL”做成可选自动化：在 publish popover 打开 toggle 后，每次 successful build 都成为 deployment event，失败或进行中的 build 不会覆盖稳定版本，web、iOS、Android 全量可用；还支持把多个修改请求排队，让 Manus 逐个构建并自动上线。7月14日 PowerPoint Slides 进入 Beta，面向 1.6 和 Max models：Manus 不再先生成网页再导出，而是从第一张到最后一张直接 author native .pptx，支持可编辑 charts、structured tables、slide masters，可从 Google Sheets、研究主题、PDF/文档、URL、会议纪要生成 deck；图表可在 Manus 内打开 spreadsheet overlay 修改数据并实时重绘。商业落地侧，7月17日 Ascendea 客户故事把 Manus 描述为“James”AI chief of staff：Ascendea 10人团队把 Manus 放在三层 AI workforce 顶层，处理 strategy documents、technical architecture、research 等复杂上下文任务；首个显著成果是一天生成 303 个 SOP，客户称人工需要 2人约14周；当前服务112个 active clients，运行28~33个 live AI workflows，并宣称 workforce output 提升 90x。学术/benchmark 本周未见 Manus 自研公开评测。
- 关键数据：Auto-Publish 发布 2026-07-13，web/iOS/Android 全用户可用；PowerPoint mode 发布 2026-07-14，Beta，适用于 1.6 和 Max models；Ascendea 案例 2026-07-17：90x output shift、303 SOPs in one day、2人约14周人工估计、10 human staff、3 Slack Agents、6 other agents、112 active clients、28~33 live AI workflows；来源：[Manus](https://manus.im/blog/manus-auto-publish)、[Manus](https://manus.im/blog/manus-ppt-slides)、[Manus](https://manus.im/blog/Ascendea-James-Customer-Story)。
- 原文链接：[Manus](https://manus.im/blog)；[Manus](https://manus.im/blog/manus-auto-publish)；[Manus](https://manus.im/blog/manus-ppt-slides)；[Manus](https://manus.im/blog/Ascendea-James-Customer-Story)；[Manus](https://manus.im/)
- 影响判断：Manus 的路线很清晰：把“通用 Agent”落到可交付 artifact 与可持续运行的业务流程，而不只是浏览器自动化。Auto-Publish 缩短从对话到线上交付的最后一步，PowerPoint 原生化增强企业交付可信度，客户故事则强化“AI chief of staff/AI workforce”的商业叙事。

#### Devin（独立追踪产品动态）

- 本周动态：Devin 本周可确认的官方更新来自 docs.devin.ai release notes 的 2026-07-15 条目，属于工程化与企业管理增强，而非大模型能力发布。具体包括：在 session 中可从文件、worklog 或 Devin 消息选择文本并 quote 到下一条消息，降低长任务沟通中的引用歧义；sessions list 可按被激活的 skill 过滤，便于团队按工作类型复盘；session t-shirt sizes（XS–XL）现在只基于 ACU consumption，不再把用户消息数纳入大小判断，使成本/规模统计更贴近算力消耗；管理员可把单个组织的 playbook promote 到 entire enterprise，实现跨组织复用；enterprise ACUs-by-product 图表 legend 可点击开关单个 series。补充背景：Cognition 官网 Research 页本周没有 7月13~19 新研究，最近研究页为 07.08.26 的 SWE-1.7、open-source-derived model trustworthiness、FrontierCode 1.1，属本周前背景；Devin Desktop 页面展示其“manage fleets of local and cloud agents”定位、ACP、Spaces、Fast Context、SWE-1.6 unlimited access，并披露 1M+ users、4000+ enterprise customers，但页面未给本周发布日期，不能算本周新动态。商业化方面本周未见 Devin 新融资/估值/客户公告。
- 关键数据：2026-07-15 release notes：ACU-only session sizing、enterprise playbook promotion、ACU chart legend toggles 等；Devin Desktop 静态页披露 1M+ users、4000+ enterprise customers、SWE-1.6 unlimited access（页面无本周日期，仅作背景）；来源：[Devin/Cognition](https://docs.devin.ai/release-notes/2026)、[Devin/Cognition](https://devin.ai/desktop/)。
- 原文链接：[Devin/Cognition](https://docs.devin.ai/release-notes/2026)；[Devin/Cognition](https://devin.ai/desktop/)；[Devin/Cognition](https://cognition.com/research)；[Devin/Cognition](https://cognition.com/blog)
- 影响判断：Devin 的本周变化说明成熟代码 Agent 的竞争重心正在向企业运营面迁移：skill/playbook 管理、ACU 计量、session 可检索性和引用协作，都是规模化部署后的“管控与可复用”问题。虽然没有大版本模型更新，但这些小功能直接改善组织级 adoption 与成本治理。

#### Replit Agent

- 本周动态：Replit 于 2026-07-16 发布《The Self-Driving Company》，虽不是单一 Replit Agent release note，但它是对 Replit 内部 Agent 系统在工程与全公司流程落地的深度披露，且直接关联 Replit Agent 的自我改进路线。官方称过去六个月工程团队 code output nearly tripled，review times held steady，reversions 与 product incidents 保持 flat，quality metrics improved，releases accelerated。工程侧，他们在1月下旬利用 agent harness、microVMs、remote filesystem infrastructure，让工程师可并行 orchestration swarms of agents，并以 access policies、token proxies、audit logging、ZeroTrust network 接入 GitHub、GCP、Azure、Linear、Notion、Slack、ZenDesk 等系统。数据上，早1月至6月下旬 lines of code contributed 增长 5.8x；剔除 hiring effect 后同一作者 cohort 仍为 2.9x；Agent 参与 review 后节省 30% 且增长中的 human PR review time；PR reversion rates 与 incidents opened 趋势 flat；MTTM 下降。更重要的是，AI team 建了 continual learning system，分析用户反馈、提出改进，并用 benchmarks 和 A/B tests 验证收益，官方称 Replit Agent is self improving。商业/组织层面，内部 Agent 已扩展到数据、销售、营销、支持：数据团队提供 semantic layer，支持 business intelligence、charts、presentations；支持团队给 Agent skills 以按 playbook 调查问题，复杂人工升级 tickets 关闭速度提升 60%。本周未见 Replit Agent 外部产品功能大版本，但该文提供了企业 Agent 平台化的工程与商业采用证据。
- 关键数据：发布日期 Thu, Jul 16, 2026；过去六个月 code output nearly tripled；早1月至6月下旬 lines of code contributed +5.8x；consistent cohort +2.9x；human PR review time saved 30% and growing；支持团队 escalated-to-human hardest tickets 关闭速度 60% faster；接入系统包括 GitHub、GCP、Azure、Linear、Notion、Slack、ZenDesk；来源：[Replit](https://replit.com/blog/self-driving-company（2026-07-16)）。
- 原文链接：[Replit](https://replit.com/blog)；[Replit](https://replit.com/blog/self-driving-company)；[Replit](https://docs.replit.com/replitai/agent)
- 影响判断：Replit 把 Agent 从“帮用户写 App”的产品扩展为公司自身运营系统，给出了罕见的生产数据与组织流程改造样本。其关键启发是 agent harness + 安全治理 + 语义数据层 + feedback loop，能够把代码 Agent 从 IDE 助手升级为跨部门执行层；这也会反向增强 Replit Agent 的产品可信度。

**本板块洞察**：

- 学术/评测：本周垂直/企业 Agent 厂商直接发布公开 benchmark 的不多；Replit 披露了内部 benchmarks+A/B tests 驱动 continual learning，Devin/Cognition 的 FrontierCode/SWE-1.7 属 7月8日背景，Glean/Harvey/Sierra/Manus 未见本周公开评测。整体看，企业 Agent 评估正在从单点任务分数转向生产闭环指标（ACU、PR review time、MTTM、ticket resolution、业务 outcome）。
- 工程产品：企业 Agent 的共性演进是“长期运行+权限治理+上下文连接+可交付 artifact”。Glean 的 agent identity、Sierra 的 long-horizon planning、Perplexity/Manus/Replit 的 connector/workflow/部署能力，以及 Devin 的 playbook/ACU/skill 管理，都在补齐规模化运行时而非单次回答。
- 商业化落地：本周最强商业信号来自 Sierra 的 outcome-based Horizon、Manus 的 Ascendea 90x/303 SOP 客户故事、Replit 的内部生产率数据与成本替代案例。多数厂商融资/估值本周未新增披露，竞争焦点转向能否用客户可感知结果证明 Agent ROI。

---

### 🌐 浏览器操作 + 中国 Agent

#### OpenAI Operator / ChatGPT Agent

- 本周动态：本周 OpenAI 没有单独发布名为 Operator/ChatGPT Agent 的产品升级公告，但连续两篇官方材料直接指向“agentic era”的工程化与安全化。7月14日《How to manage AI investments in the agentic era》把 ChatGPT Work 定位为支持“更长、多步骤任务”的企业入口，并明确提到 connectors、plugins、Computer Use、approved context、permitted actions、usage/spend controls、Guaranteed Capacity、Scale Tier、Batch API、Flex processing、Prompt Caching 等用于生产级 agent 工作流的治理与容量方案；这说明 OpenAI 的浏览器/计算机操作能力正在从单点 Operator 演示转向企业级可观测、可控、可计费的工作流底座。7月15日 GPT-Red 公告则从安全角度解释 agent 暴露面：AI 系统会通过浏览器、连接应用、本地文件和工具接触第三方数据，提示注入可能藏在网页、邮件、工具输出和代码仓库中；OpenAI 用内部自动红队模型 GPT-Red 生成攻击并训练 GPT-5.6，称 GPT-5.6 Sol 相比四个月前最强生产模型在最难直接提示注入 benchmark 上失败少 6 倍，并在一组直接注入中仅 0.05% 失败。对浏览器/计算机操作 Agent 来说，本周核心信号不是新入口发布，而是 OpenAI 把企业治理、成本 ROI 与 prompt-injection 鲁棒性同时推到台前。
- 关键数据：GPT-4 到 GPT-5.4 每百万 token 价格下降 97%；GPT-5.6 在 Artificial Analysis Coding Agent Index 中输出 token 少 54%、每任务耗时少 57%（OpenAI，2026-07-14，[OpenAI](https://openai.com/index/managing-ai-investments-in-agentic-era/)）。GPT-Red 在复刻 Dziemian et al. (2025) 间接提示注入 arena 中对 GPT-5.1 攻击成功覆盖 84% 场景，人类为 13%；GPT-5.6 Sol 对 GPT-Red 直接提示注入失败率 0.05%（OpenAI，2026-07-15，[OpenAI](https://openai.com/index/unlocking-self-improvement-gpt-red/)）。
- 原文链接：[OpenAI](https://openai.com/news/)；[OpenAI](https://openai.com/index/managing-ai-investments-in-agentic-era/)；[OpenAI](https://openai.com/index/unlocking-self-improvement-gpt-red/)；[OpenAI](https://developers.openai.com/api/docs/changelog)
- 影响判断：OpenAI 本周把 agent 的竞争点从“能不能操作浏览器/电脑”推进到“能否被企业治理、度量 ROI 并抵抗网页/工具注入”。对行业的压力在于，Computer Use 类能力必须绑定审计、权限、成本与安全 eval，否则很难规模化进入企业系统。

#### Anthropic Computer Use

- 本周动态：Anthropic 本周未发布新的 Computer Use 专项功能，但官方平台 release notes 在7月14日和7月15日更新了与企业 Agent 管理密切相关的能力：7月14日 Claude Enterprise Admin API 进入 beta，支持列成员、按邮箱查找、变更角色、移除成员、发送/撤回邀请、管理 group 与 membership、读取 custom roles，其中 group/custom-role 请求需要 `anthropic-beta: ce-user-management-2026-07-13`；7月15日 mid-conversation system messages 在 Claude Fable 5、Claude Mythos 5、Claude Opus 4.8，以及 Claude API、Amazon Bedrock、Google Cloud 上可用且无需 beta header。这些并非鼠标键盘层面的更新，但会影响企业把 Computer Use 接入长流程时的组织权限、角色与对话中途控制。官方 Computer Use 文档仍标注 beta，要求 `computer-use-2025-11-24`（适用于 Claude Sonnet 5、Opus 4.8/4.7/4.6、Sonnet 4.6、Opus 4.5）或旧 `computer-use-2025-01-24` beta header；工具提供截图、鼠标、键盘控制，推荐在低权限 VM/container 中运行、限制敏感数据、域名 allowlist，并在人类确认后执行有现实后果的步骤。文档还说明 Anthropic 对 screenshots 中潜在 prompt injection 运行分类器，触发时会引导模型请求用户确认。结论：本周 Computer Use 本体无重大公开动态，但 Anthropic 在组织管理和中途 system message 控制上补齐企业 Agent 运维层。
- 关键数据：Claude Enterprise Admin API beta 日期为 2026-07-14，group/custom-role 需 `anthropic-beta: ce-user-management-2026-07-13`；mid-conversation system messages 2026-07-15 扩展到 Fable 5、Mythos 5、Opus 4.8 且无需 beta header（[Anthropic](https://platform.claude.com/docs/en/release-notes/overview)）。Computer Use 当前需 `computer-use-2025-11-24` 或 `computer-use-2025-01-24` beta header，示例 display_width_px=1024、display_height_px=768（[Anthropic](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool)）。
- 原文链接：[Anthropic](https://www.anthropic.com/news)；[Anthropic](https://platform.claude.com/docs/en/release-notes/overview)；[Anthropic](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool)
- 影响判断：Anthropic 的本周变化偏“企业控制面”而非 GUI automation 本身，但这正是 Computer Use 产品化的必要条件。其安全文档仍比多数厂商更明确：沙箱、域名限制、人类确认和 prompt-injection 分类器，是后续行业实现计算机操作 Agent 的基本防线。

#### Google Project Mariner / Gemini 浏览器与 Agent 平台

- 本周动态：本周没有看到 Google 以 Project Mariner 名义发布浏览器操作 Agent 新功能；DeepMind 官方博客列表显示相关“Introducing computer use in Gemini 3.5 Flash”为6月发布，属于背景、非本周。本周 Google Agent 相关的实质更新集中在 Gemini Enterprise Agent Platform 与开发者工具链。7月16日 Google Developers Blog 宣布 Parallel Web Systems 成为 Gemini Enterprise Agent Platform 原生 web grounding provider，能力覆盖 Gemini API 调用、Agent Studio 选择和 Google Cloud Marketplace 订阅，计费并入 Google Cloud invoice，并支持 ZDR 选项。文章把场景明确指向 KYC 自动检查、目录/数据库补全、实时新闻分析、企业尽调、合规/风险检查、多 Agent 编排等，这与浏览器型 Agent 的“读网页—引用—缓存—交给下游模型/子 Agent”的工程模式高度相关。同日另一篇文章提出 modular prompt transpilation，把生产 Agent 的 prompt 拆成 skill files、通过模板依赖图、静态校验、golden file drift check 与 CI/CD 生成确定性 prompt artifact；还提出 agent 可提交自身指令层更新 PR，但不得实时自改。另有 Conductor Plugin 本周支持 Antigravity CLI，使 spec-driven development 的 context/spec/plan markdown 可跨 Gemini CLI、Antigravity CLI、Claude 等工具复用。整体看，Mariner 本体沉默，但 Google 正在把“浏览器/网页 grounding + agent 工作流编排 + prompt 工程构建系统”合成企业 Agent 平台。
- 关键数据：Parallel Web Search 于 2026-07-16 原生集成 Gemini Enterprise Agent Platform，可在 Gemini API、Agent Studio、Google Cloud Marketplace 使用，并支持 ZDR 选项（[Google](https://developers.googleblog.com/en/expanding-choice-in-gemini-enterprise-agent-platform-introducing-grounding-with-parallel-web-search/)）。Conductor Plugin 支持 Antigravity CLI，本周公告给出安装命令 `agy plugins install [GitHub](https://github.com/gemini-cli-extensions/conductor`)，并称复杂 TerminalBench 子集成功率高于未使用 SDD 的用户（未公开具体百分比）（[Google](https://developers.googleblog.com/en/evolving-spec-driven-development-conductor-now-supports-antigravity/)）。
- 原文链接：[Google](https://deepmind.google/blog/)；[Google](https://developers.googleblog.com/en/)；[Google](https://developers.googleblog.com/en/expanding-choice-in-gemini-enterprise-agent-platform-introducing-grounding-with-parallel-web-search/)；[Google](https://developers.googleblog.com/en/building-scalable-ai-agents-with-modular-prompt-transpilation/)；[Google](https://developers.googleblog.com/en/evolving-spec-driven-development-conductor-now-supports-antigravity/)
- 影响判断：Google 的本周重心不是展示 Mariner “代人点网页”，而是把 Agent 使用网页的基础设施商业化：可引用、可缓存、可计费、可接入企业架构。其 prompt transpilation 与 Conductor/Antigravity 路线表明，Google 更强调把 Agent 可靠性纳入软件工程生命周期，而不是只依赖模型端规划能力。

#### 字节 Coze / 扣子

- 本周动态：本周未发现 Coze/扣子在 2026-07-13 至 2026-07-19 时间窗内发布与浏览器操作、GUI 自动化、Agent SDK/平台、benchmark 或商业化落地相关的重大官方公告。已检查的来源包括 Coze 中国站与海外站开放文档入口（web_fetch 直读，但页面对抓取仅返回站点标题）、面向 Coze/扣子的本周官方域名搜索、以及英文“Coze release notes July 2026 agent platform official”搜索；搜索结果未返回 coze.cn/coze.com/bytedance.com 的本周更新，主要出现第三方 awesome 列表和无关平台 release notes。由于官方文档页为前端渲染，当前 web_fetch 未能读到更深层 changelog；在缺乏可验证原始来源全文的情况下，不写入任何“本周动态”。背景上，Coze/扣子仍是字节的 AI Agent 智能办公/Agent 构建平台，通常覆盖 no-code bot/agent、插件、工作流、多渠道发布等方向，但这些均非本周新证据，不能计入本周动态。
- 关键数据：—（本周未找到官方公开数字；搜索与官方入口检查日期为 2026-07-20，覆盖 2026-07-13~2026-07-19）
- 原文链接：[来源](https://www.coze.cn/open/docs)；[来源](https://www.coze.com/open/docs)
- 影响判断：扣子本周公开信号偏弱，至少在可抓取官方渠道未看到面向浏览器/计算机操作 Agent 的新 release。若有实际产品迭代，可能发生在登录态控制台、应用内公告或私域开发者社群，需要后续用账号态浏览器或官方更新页补验。

#### 智谱 AutoGLM

- 本周动态：本周未检索到智谱以 AutoGLM 名义在 2026-07-13~2026-07-19 新发布官方公告；但官方文档当前已经把 AutoGLM-Phone 作为可调用模型页公开，且文档内容本身与本组“计算机/手机操作 Agent”高度相关，记录为本周扫描到的官方产品信号，无法确认具体发布日期。AutoGLM-Phone 被定义为“基于视觉语言模型的 AI 手机智能助理框架”，通过多模态理解屏幕内容，并用 ADB 自动操控 Android 设备；用户可用自然语言下达“打开小红书搜美食”等指令，模型完成意图解析、界面理解、规划和执行。官方列出上下文窗口 20K、最大输出 2048、中文、Android 设备，支持 50+ 款中文主流应用，覆盖微信、QQ、微博、淘宝、京东、拼多多、美团、饿了么、携程、12306、滴滴、B站、抖音、小红书、知乎等；动作原语包括 Launch、Tap、Type、Swipe、Back、Home、Long Press、Double Tap、Wait、Take_over（登录/验证码等请求人工接管）。工程上，开发者需准备 Python 3.10、ADB、Android 7.0+ 设备或模拟器、USB 调试、ADB Keyboard，并通过 Open-AutoGLM 仓库运行 `main.py --base-url [来源](https://open.bigmodel.cn/api/paas/v4) --model "autoglm-phone"`。另外，智谱文档本周扫描还显示 GLM-5.2 与 GLM Coding Plan 团队版已上线，强调 1M 上下文、128K 最大输出、Function Call、MCP、上下文缓存与 Coding Agent 扩展组件；这属于 AutoGLM 之外的 Agent 工程底座信号。
- 关键数据：AutoGLM-Phone：上下文 20K、最大输出 2048、Android 7.0+、支持 50+ 中文应用、动作原语 10 类（智谱文档，访问 2026-07-20，[来源](https://docs.bigmodel.cn/cn/guide/models/vlm/autoglm-phone.md)）。GLM-5.2：1M 上下文、128K 最大输出 tokens，官方称在长程任务基准 FrontierSWE/SWE-Marathon/PostTrainBench 上为开源 SOTA 区间，并可处理超过 850K tokens 的连续工程流程（[来源](https://docs.bigmodel.cn/cn/guide/models/text/glm-5.2.md)）。
- 原文链接：[来源](https://docs.bigmodel.cn/llms.txt)；[来源](https://docs.bigmodel.cn/cn/guide/models/vlm/autoglm-phone.md)；[来源](https://docs.bigmodel.cn/cn/guide/models/text/glm-5.2.md)；[来源](https://docs.bigmodel.cn/cn/coding-plan/learning-resources/how-coding-agent-works.md)；[来源](https://docs.bigmodel.cn/cn/coding-plan/learning-resources/agentic-extension.md)
- 影响判断：AutoGLM-Phone 是中国厂商在“移动端 GUI 操作 Agent”上最直接的公开工程形态之一，动作空间和环境准备比浏览器 Agent 更贴近真实消费 App。短板是本周未见明确 release 事件和公开 benchmark 日期，后续应重点追踪 Open-AutoGLM GitHub release、AutoGLM-Phone API 计费/开放状态与安全接管策略。

#### 月之暗面 Kimi Agent（详见 TOP5，同时保留完整对象记录）

- 本周动态：Kimi 是本周 D 组最强信号。7月16日 Moonshot/Kimi 官方发布 Kimi K3，定位为 Kimi 迄今最强模型、全球首个开放的 3T 级模型，2.8 万亿参数，基于 Kimi Delta Attention 与 Attention Residuals，原生视觉，1M token 上下文，面向长程编程、知识工作和推理。官方明确把 K3 用在 Kimi.com、Kimi Work、Kimi Code 与 Kimi API：Kimi Work 提供 Widgets 和 Dashboard，让 chat 中的交互组件可视化且可持久化；Kimi Code 在终端选择 K3，支持长程 coding；API 兼容 OpenAI，`kimi-k3` 默认/当前仅支持 max thinking effort，支持工具调用、`tool_choice="required"`、动态加载工具、1M 上下文自动缓存、视觉输入、结构化输出。Agent 工程亮点是“动态加载工具”：在 `messages` 中插入带 `tools` 字段且不含 `content` 的 system message，从该位置起加载完整工具定义，解决工具定义膨胀和工具误选，可组合自定义 `search_tools` 实现 tool search；注意仅 K3 支持，服务端不保存声明。K3 技术博客给出大量长程 Agent 案例：24小时 GPU kernel 优化、从零构建 MiniTriton 编译器、48小时自主芯片设计、I-Love-Q 天体物理复现、42年 ASIC 行业交互研究网站（120+轮自我改进、2.8k+网页搜索/抓取、1.1k+终端数据拉取、11k+页面、87份季报、99份PDF）。商业化上，K3 API 定价为 cache-hit input $0.30/MTok、cache-miss input $3.00/MTok、output $15.00/MTok；官方称 coding workload cache hit rate above 90%。7月19日第三方转载 Kimi 公告称 K3 发布后48小时用户请求显著超预期、逼近集群承载极限，暂停 C 端新用户订阅，并计划拆分 Kimi 主权益与 Kimi Code 权益。
- 关键数据：Kimi K3：2.8T 参数、1M token 上下文、896 个专家中激活 16 个、相对 K2 整体 scaling efficiency 约 2.5×、完整权重计划 2026-07-27 前发布（Kimi，2026-07-16，[Kimi](https://www.kimi.com/blog/kimi-k3)）。API 价格：cache-hit input $0.30/MTok、cache-miss input $3.00/MTok、output $15.00/MTok；coding workloads 官方 API cache hit rate >90%（同源）。K3 `max_completion_tokens` 默认 131072、最大 1048576；`reasoning_effort` 当前仅 `max`；动态加载工具仅 K3 支持（[Kimi](https://platform.kimi.com/docs/guide/kimi-k3-quickstart)；[Kimi](https://platform.kimi.com/docs/guide/use-dynamic-tool-loading)）。PerceptionBench：3000 verified questions、10 atomic visual categories、40+ benchmarks 归因、无模型超过 60% accuracy（Kimi，2026-07-16，[Kimi](https://www.kimi.com/blog/perception-bench)）。
- 原文链接：[Kimi](https://www.moonshot.cn/)；[Kimi](https://www.kimi.com/blog/kimi-k3)；[Kimi](https://www.kimi.com/blog/perception-bench)；[Kimi](https://platform.kimi.com/docs)；[Kimi](https://platform.kimi.com/docs/guide/kimi-k3-quickstart)；[Kimi](https://platform.kimi.com/docs/guide/use-dynamic-tool-loading)；[来源](https://news.bjd.com.cn/2026/07/19/11874545.shtml)；[Qwen/阿里](https://help.aliyun.com/zh/model-studio/kimi-api-by-moonshot-ai)
- 影响判断：Kimi K3 把中国 Agent 竞争从“应用助手”推到“开放权重/开放 API 的长程工作模型”层面，并且把 tool bloat、缓存、长程 coding、知识工作可视化作为工程重点。其风险也很清楚：官方限制里承认 thinking history 敏感、过度主动，说明面向企业 Agent 仍需强约束 system prompt、AGENTS.md 与 harness 兼容性。

#### 阿里 Qwen Agent

- 本周动态：本周 Qwen Agent 相关公开信号主要来自两个方向。其一，QwenLM/qwen-code 在 GitHub release 中持续快速迭代，搜索结果与 release 页显示本周有 v0.20.0/夜版更新，重点是终端/网页壳 Agent 工程能力而非模型本体：新增 bounded daemon log rotation、review round label 身份标识、readonly WebShell 回放 ChatRecord、exit_plan_mode 确认中展示完整 plan、Token Plan 模型列表加入 `qwen3.8-max-preview`；修复 Java SDK 30分钟超时、OpenAI-compatible 连接错误暴露 cause、strict providers 下 MCP 工具名规范化、Gemma 4 native tool calling schema、WebShell/Review 多项问题；性能上延迟加载 TUI runtime、缓存 channel memory recall。夜版条目还显示 web-shell skill management pages、workspace goals page、subagent delegation defaults/guardrails、per-model sub-agent concurrency limits、full-turn multimodal routing for image prompts、web_fetch 内容保真/二进制/安全/韧性改造等，说明 Qwen Code 正在从 coding CLI 扩展为带 daemon、WebShell、memory、goals、subagents、channels 的多入口 Agent OS。其二，Qwen-Agent 框架本体 release 页显示最近版本支持 MCP streamable-http、SSE read timeout 和自动重连、MCP server resource as tool、empty tool response、invalid tool call fallback，并已改 Apache 2.0；README 明确 Qwen-Agent 是 Qwen Chat 后端，提供 Function Calling、MCP、Code Interpreter、RAG、Chrome extension/Browser Assistant，代码解释器基于本地 Docker 容器沙箱。学术/benchmark 方面，DeepPlanning 虽非本周发布（v1.1 为 2026-03-03），但仍是 Qwen 官方 agent planning benchmark：旅行规划与购物规划共 360 任务、9/15 个 API、隔离 Python 沙箱，评测长程主动信息获取、局部约束与全局优化。
- 关键数据：qwen-code release 本周引入 `qwen3.8-max-preview` 到 Token Plan model list、bounded daemon log rotation、WebShell ChatRecord replay、MCP strict provider tool name normalization 等（GitHub，访问 2026-07-20，[GitHub](https://github.com/QwenLM/qwen-code/releases)）。Qwen-Agent 默认环境变量曾设 `QWEN_AGENT_MAX_LLM_CALL_PER_RUN=20`、`QWEN_AGENT_DEFAULT_MAX_INPUT_TOKENS=58k`；当前框架包含 Browser Assistant、Code Interpreter、Custom Assistant，代码解释器用 Docker sandbox（[GitHub](https://github.com/QwenLM/Qwen-Agent)；[GitHub](https://github.com/QwenLM/Qwen-Agent/releases)）。DeepPlanning v1.1：Travel 120 ZH/120 EN、Shopping 120 EN；工具 9/15 个 API；Qwen-3.5-Plus w/o thinking Avg Acc 37.6，Qwen3-Max w/ thinking 29.7（[Qwen/阿里](https://qwenlm.github.io/Qwen-Agent/en/benchmarks/deepplanning/)）。阿里云百炼支持可视化 Agent 1.0、工作流、高代码应用、插件与 MCP，提供华北2、美国弗吉尼亚、新加坡、德国法兰克福、日本东京地域（[Qwen/阿里](https://help.aliyun.com/zh/model-studio/what-is-model-studio)）。
- 原文链接：[Qwen/阿里](https://qwenlm.github.io/blog/)；[GitHub](https://github.com/QwenLM/qwen-code/releases)；[GitHub](https://github.com/QwenLM/Qwen-Agent)；[GitHub](https://github.com/QwenLM/Qwen-Agent/releases)；[Qwen/阿里](https://qwenlm.github.io/Qwen-Agent/en/benchmarks/deepplanning/)；[Qwen/阿里](https://help.aliyun.com/zh/model-studio/what-is-model-studio)
- 影响判断：Qwen 本周最值得关注的不是单一模型 announcement，而是 Agent 工程栈密集补齐：WebShell、daemon、goals、memory、subagent、MCP、review、计划确认与工具安全都在 release 中出现。它与百炼商业平台结合，正在形成“开源框架/CLI + 云端模型与应用构建”的双轨落地；缺点是 release 信息噪声较大，官方博客未提供统一周度解读，需继续跟踪 tag 日期与正式版说明。

**本板块洞察**：

- 学术/benchmark：本周最有价值的评测信号来自 Kimi PerceptionBench 与 Qwen DeepPlanning（背景非本周），前者把多模态 Agent 的视觉失败拆成 10 类原子能力、3000 verified questions，后者强调长程规划中的主动信息获取、局部约束和全局优化；行业正在从单步 GUI/网页任务转向“可验证约束 + 长程执行”的 benchmark。
- 工程：OpenAI GPT-Red、Anthropic Computer Use 安全文档、Kimi 动态加载工具、Google prompt transpilation/Qwen MCP-WebShell 更新共同指向同一趋势：Agent 的核心瓶颈不再只是模型会不会调用工具，而是工具定义膨胀、prompt injection、上下文缓存、沙箱隔离、计划确认、人类接管、subagent/工作流可观测性。
- 商业化：Google Gemini Enterprise Agent Platform、OpenAI ChatGPT Work/Guaranteed Capacity/Scale Tier、阿里百炼/Qwen Token Plan、Kimi API/Kimi Enterprise 都在把 Agent 能力放进企业计费、治理和 marketplace/console 中；Kimi K3 因算力压力暂停 C 端新订阅说明，高强度 Agent 工作负载会优先考验缓存命中率、容量采购和订阅权益拆分。

---

## 📋 关于本周报

- **数据口径**：本周动态仅覆盖 2026-07-13 ~ 2026-07-19；时间窗外内容标注为背景或不计入本周动态。
- **图标说明**：🔥重大 = 对赛道方向或商业化有明显影响；🟢一般 = 有明确工程/产品更新；🟡边缘 = 有信号但日期/影响力有限；⚪️静默 = 本周未发现可验证重大公开动态。
- **质量门控**：覆盖 28/28；原文抽查 5/5（Claude Code、CrewAI、Sierra Horizon、Kimi K3、Dify 1.16.0）；洞察覆盖学术研究、Agent 工程、商业化落地三维；关键数据均保留来源链接或标注未公开。
- **信息校验**：28 对象 / 80+ 数据点 / 28+ 判断 / 57 个去重来源链接，全部对应 ✅。
- **下期预告**：继续跟踪 Kimi K3 权重开放、Dify Agent beta、Claude/Codex/OpenCode 安全治理、Glean/Sierra 企业 Agent 落地与中国 Agent 工程栈。
