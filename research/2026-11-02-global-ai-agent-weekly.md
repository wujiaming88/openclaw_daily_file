# 全球 AI Agent 研究周报 · 第 22 期 研究母稿（2026-10-26 ～ 2026-11-01）

> 本期：2026-10-26 ～ 2026-11-01（Asia/Shanghai 完整自然周，上周一 00:00 → 上周日 24:00）。期次：**第 22 期**（上期第 21 期：10-19～10-25）。
> 定位：Agent 产品 + 开源项目 + Agent 工程生态（编码 Agent / 开源框架 / Computer Use / 企业与协议评测）。
> 读者透镜：R1 开发者（主）+ R2 架构负责人（协同）；聚焦产品/开源/工程，非公司战略流水账。
> 证据口径：主张级 A–D（**仅母稿标注**）；窗外标「背景，非本周」；厂商自述标 B；结论强度 ≤ 证据强度。
> 运行目录：`/workspace/weekly/weekly-agent-report/2026-11-02/`；分片 A/B/C/D + `mainline-deep.md` + `wow.md`。
> 主线专题：**MCP 从托管代理走向官方端点 + 发布火车 + 企业控制面**（深挖见 §三；`parallel-deep-research` 因无 API key 跳过，见局限）。

---

## 一、标题与窗口 · 信息面摘要

**标题建议**：全球 AI Agent 研究周报 · 第 22 期｜MCP 代理关停与发布火车定档，编码侧把权限/长会话做成可运维产品

**窗口**：2026-10-26 ~ 2026-11-01（Asia/Shanghai）

**信息面（读者决策须看见）**
- **对象类型**：编码 Agent/CLI/IDE；开源 Agent 框架与项目（含 OpenClaw 必覆盖）；Computer Use / 浏览器自主 / 通用 Agent；企业 Agent + MCP 协议 / 评测 / 工程控制面。
- **一手入口**：GitHub releases/API、官方 changelog/博客、产品公告、benchmark 发布页、MCP 生态文档（含 smithery.ai/future、SEP PR）。
- **信号类型**：release / 重大 PR / 架构或权限变更 / 协议治理变更 / 破坏性连接迁移 / 企业控制面（评测·熔断·FinOps）/ 真实工程与安全讨论。

**本期一句话**：本周 MCP **无新协议版本**（仍 `2026-07-28`），但连接身份、规格发布火车与企业控制面同时变硬；编码 Agent 把「工作区写边界 + idle/百分比 compaction + 跨工具登录」打成可运维能力；开源 Gateway（OpenClaw）继续以安全补丁与失败可恢复为主叙事。

---

## 二、TOP5 候选

> 排序依据：工程影响力 × 破坏性/迁移成本 × 生态位置 × 窗内一手可核。各条含判断、事实、机制要点、影响、证据级、来源。

### 1) Smithery MCP Proxy 关停 + SEP-3398 / SEP-3392（主线）

- **判断**：MCP 的主矛盾从「有没有服务器」转为「谁托管身份、规格何时可排期、扩展稳不稳、企业控制面能不能看见」——本周三件套同时落地。
- **事实**：
  1. Smithery 官方页确认 **2026-10-31** 关闭 connection management：`run.tools` / `server.smithery.ai` URL、API/Connect/Toolbox、账户与 API keys、CLI/SDK（deprecated）全部停用；**保留** smithery.ai 作非代理公共目录（Arcade.dev 驱动），已验证服务器页展示厂商直连 URL（例 `mcp.linear.app/mcp`）。付费自 8-05 起退款并取消订阅（公司披露）。[A｜关停范围；B｜退款]
  2. PR **#3398**「SEP-3398: Release Cycle Updates」于 **2026-10-27T17:10:05Z** merged：形式化每年约 **3 月与 9 月**发布、重叠约八个月周期、轮值 release manager；**过渡将原 2026-12 发布目标改至 2027-03**。[A]
  3. PR **#3392** 于 **2026-10-29T11:37:16Z** merged（Final）：扩展成熟度 Experimental → Beta → Stable（仍为扩展）或晋升核心；仓库命名 `experimental-ext-*` / `beta-ext-*` / `ext-*`。[A]
- **机制要点**：托管代理在厂商普遍自建 Streamable HTTP 官方端点后边际价值下降，身份回到「客户端 ↔ 厂商 OAuth」；流程 SEP 把「下一规格何时来」变成可排期火车；扩展生命周期用命名+SEP 门禁替换碎规则。
- **影响**：凡 `.mcp.json` / Cursor / Claude Desktop 仍指向 Smithery URL 或 `@smithery/cli` 的连接在 10-31 后**失效**（破坏性，影响面=所有 Smithery URL 用户与基于 Connect 的 B2B）——须改厂商 URL 并重新 OAuth。生产基线整个冬天应以 **2026-07-28** 为准；「等下一大版本」对齐 2027 春季。
- **证据级**：A（关停页 + PR 元数据）；商业退款 B
- **来源**：https://smithery.ai/future ；https://github.com/modelcontextprotocol/modelcontextprotocol/pull/3398 ；https://github.com/modelcontextprotocol/modelcontextprotocol/pull/3392

### 2) Claude Code 2.1.314–316：工作区外写拒绝 + idle compaction / 企业网关

- **判断**：编码 Agent 企业化的下一段不是「新模型」，而是路径边界与长会话运维与 IdP 组预算叠成多层控制面。
- **事实**：窗内稳定版 **v2.1.311 / 312 / 314 / 316**（约 10-26～10-31）。**2.1.314** 新增 `permissions.blockWritesOutsideWorkingDirectories`——Write/Edit/NotebookEdit 在**任何** permission mode 下拒绝工作目录外路径；将 **idle compaction** 扩展到 VS Code 与 Claude Desktop Code tab（闲置 200K+ token 对话摘要；prompt cache 过期后下次消息用摘要）；gateway upstream 可按 IdP `groups` 路由。**2.1.316**：子 agent 独立 effort；Claude apps gateway **pooled group budgets**；`managed.policy_mode: layered`；Bedrock `guardrail.input_tagging`；**Deprecated Opus 4.8 fast mode**（自 10-30，将于 **2026-11-30** 移除，迁 Opus 5.5）。[A]
- **机制要点**：权限层在工具执行前做路径边界检查，与 permission mode 解耦；空闲主动摘要衔接 cache 过期后续写；组预算与 layered policy 把 spend/合规从单用户限额升到 IdP 组与多策略叠加。
- **影响**：默认拒绝工作区外写入降低越权写盘；IDE/Desktop 与终端对齐 idle compaction；仍依赖 Opus 4.8 fast 的工作流须在 11-30 前迁移，否则将直接报错不回退。
- **证据级**：A
- **来源**：https://code.claude.com/docs/en/changelog ；https://github.com/anthropics/claude-code/releases

### 3) OpenClaw 2026.10.8 / 10.9：安全与恢复（必覆盖）

- **判断**：自托管个人/团队助理的「Gateway 类」开源本周主叙事仍是安全补丁 + 失败可引导，而非新功能清单。
- **事实**：**2026.10.8**（2026-10-27Z）：更新失败后 Doctor 重启 Gateway；孤儿 maintenance worker 不再堵 CLI；会话恢复与安全硬化（exec allowlist `test -v`、拒绝 generic node invoke 上的 browser proxy、沙箱子进程禁 host CLI）。**2026.10.9**（2026-10-29Z）：依赖安全（fast-uri 4.2.3、Zod 集合边界、nodemailer 10.1.4、MSAL Node 7.1.1）；`tools.fs.workspaceOnly` 落到 Gateway 构建的 delegate/media 工具；凭证不出 MCP CLI / Google OAuth 日志；失败回滚与 SQLite tokenizer/全文索引恢复；磁盘满后可自愈。**extended-stable 2026.9.35/9.36** 回灌上述安全与恢复；**2026.10.10-beta.4/5** 修流式卡住与 Node 兼容口径。[A]
- **机制要点**：单机长驻 Gateway（WS 控制面 + 渠道）把「受信控制面 / 不可信执行 / 策略用代码强制」落地；本周集中在（a）依赖与解析边界防 DoS/注入；（b）`workspaceOnly` 扩展到 Gateway 合成工具；（c）更新/Doctor/回滚状态机避免半更新不可引导。
- **影响**：生产自托管必须跟进 10.9 级补丁；启用 `workspaceOnly` 的部署应验证 delegate/media 行为变化；LTS 用户可走 extended-stable。与编码侧路径边界、企业 Kill Switch 同向「边界硬化」。
- **证据级**：A（双入口：GitHub releases + docs.openclaw.ai/releases）
- **来源**：https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases

### 4) Codex 0.165 / 0.166 + GPT-6.1 Terra（备选对照：OpenCode Claude Agent 桥）

- **判断**：OpenAI 把「多云模型编目 + computer use 标签模型 + 长会话 queue/resume」钉进 Codex/Work；开源侧 OpenCode 用 Claude Agent `/connect` 复用 Claude Code 登录，形成对照的「登录互通」产品动作。
- **事实**：
  1. **2026-10-26**：官方 changelog 宣布 **GPT-6.1 Terra** 进入 ChatGPT Work 与 Codex（Plus/Pro/Business/Enterprise/Edu）；定位快速高效专业模型，强图像理解 + **computer use**；桌面/Work 可选，Chat 不可用，无 UAE inference residency。[A]
  2. **Codex CLI 0.165.0**（changelog 10-27；GitHub rust-v0.165.0 ≈10-28 Asia/Shanghai）：内置 **Google Cloud Vertex AI** provider（`model_provider = "gcp"`）；编目加入 Terra；memory v2 默认对新 profile 开启；实验性 attached thread forks。[A]
  3. **Codex CLI 0.166.0**（≈10-29/10-30）：`codex queue --resume`；TUI 更清晰的 safety-block 与更安全改写选项；`codex doctor --network-only`；保留 resume/fork 时的 permission 与 reasoning-token 记账以免过早 compaction。[A]
  4. **窗外边界**：`0.167.0-alpha.2` published 2026-11-01 19:00Z = **2026-11-02 03:00 Asia/Shanghai** → 窗外，不计入。[A]
  5. **对照（未升为本条主位）**：OpenCode **v2.2.0–2.2.5**（10-27～10-31）内置 Claude Agent provider（`/connect` 复用 Claude Code 登录）、`/goal`、百分比 `compaction.buffer`、移除 OpenCode GitHub Action（破坏性）。[A]
- **机制要点**：Vertex 一等 provider 减少自建代理；queue resume 服务长会话内存回收；safety UX 把策略拒绝变成可操作改写循环。Terra 以模型能力标签进入 Work/Codex 选择器，执行面落在 cloud browser / dots（见 C 组）。
- **影响**：已在 GCP 的团队可用同一 Codex CLI 直连 Vertex；Terra 强化「看图/看屏再操作」；运维面 `doctor --network-only` 缩短连通性排障。OpenCode 侧 CI 用户须因移除 GitHub Action 迁移自建流水线。
- **证据级**：A
- **来源**：https://learn.chatgpt.com/docs/changelog ；https://github.com/openai/codex/releases ；https://opencode.ai/changelog

### 5) Salesforce Agent Fabric：Agent Evals 覆盖 MCP + Kill Switch / FinOps（工程影响优先）

- **判断**：企业把 MCP server 当作与 LLM/Agent 同级的生产依赖——持续评测、可熔断、可计费管控；本周控制面信号强于单纯「又多一个合规仪表盘」。
- **事实**：**2026-11-01** Salesforce 宣布 Agent Fabric 扩展：**Agent Evals**（部署前自动生成测试，生产中对 agents / LLMs / **MCP servers** 按质量阈值评估；不达标可触发预定干预，含 **Agent Kill Switch**，可要求审批）；**API Evals**；FinOps Dashboard / Model Wallet / Cost Optimization Policies **今日 GA**；Kill Switch GA；Triggered Kill Switch 预期 2027-01 GA；Agent/API Evals Beta 2026-11、GA 预期 2027-01。文中「>1.2B 日请求」等规模数字为公司披露。[A｜产品可用性；B｜规模/调研数字]
- **机制要点**：把「发现问题」与「自动干预/熔断/控费」放进同一控制面；评测对象显式含 MCP servers。
- **影响**：多 Agent 平台企业获得生产级 SRE+FinOps for agents 的产品化路径；MCP 运营者会被纳入与 LLM 同级的持续评测。Kill Switch 对业务流量可破坏。
- **证据级**：A（产品声明）；规模 B
- **来源**：https://www.salesforce.com/in/news/stories/agent-fabric-catch-failures-control-ai-costs/
- **同周强对照（未入 TOP5 主位，综合层引用）**：Glean **565**（10-27）+57 MCP 模板、service-credential 须显式 audience、list API 收窄、`private_key_jwt`、invocation ID、预算金额不再暴露给调用方 [A]；Sierra **Compliance Console**（10-28）主动 outreach 合规控制面 [A]；ServiceNow×OpenAI（10-28）ChatGPT marketplace **MCP plugin** [A]。

**备选未入 TOP5**：Hermit v0.1.0 harness-adapter 首发；LangChain Managed Deep Agents 浏览器；Cloudflare Agents SDK internal hostnames；Harvey LAB:USCL；CoSA Skills 组合攻击；智谱 AutoClaw 2.2.0；GitHub Copilot CLI Assisted Permissions 出实验；Replit Cloud Agents 公司库贡献。

---

## 三、主线专题：MCP 从托管代理走向官方端点 + 发布火车 + 企业控制面

> 压缩自 `mainline-deep.md`；机制级。深挖方式：一手精读 smithery.ai/future + PR #3398/#3392 API + 企业分片交叉。`parallel-deep-research` 因 PARALLEL_API_KEY 未登录不可用。

### 3.1 一句话

本周 MCP **没有新协议版本**（仍 `2026-07-28`），但连接层、发布治理与企业控制面同时变：托管代理退出、规格火车定档、扩展成熟度 Final、企业把 MCP 当生产依赖评测/熔断。

### 3.2 机制拆解

#### （1）Smithery Proxy 关停（2026-10-31）— 连接身份从中间人迁回厂商

早期托管代理统一 OAuth/连接，把多服务器身份收在 Smithery。当 Linear/GitHub/Notion 等普遍自建 Streamable HTTP 官方端点后，中间层边际价值下降。关停后身份与令牌回到「客户端 ↔ 厂商 OAuth」，目录与「替终端用户托管 MCP」产品位移到 Arcade 或其他方案。

对工程的直接后果：配置里的 Smithery URL / `@smithery/cli` 在 10-31 后失效——**破坏性**；迁移动作是改厂商 URL + 重新 OAuth。个人「开箱 Gmail/Slack」与「帮用户管多服务器」是两条不同产品问题，不再由同一代理层解决。用户规模与 Arcade 迁移完成率**未取得公开数字**。

#### （2）SEP-3398 Release Cycle（merged 2026-10-27）— 规格时间线可排期

用流程 SEP（非 wire 变更）把「下一个规格何时来」从不确定路线图变成可排期火车：一般每年 3 月与 9 月、重叠约八个月、轮值 release manager、共享 SEP review queue；过渡将原 **2026-12** 目标改至 **2027-03**。SDK/客户端可按 freeze / SDK beta 节点规划。生产基线至少整个冬天仍应以 **2026-07-28** 为准。流程本身不破协议；破坏性来自未来按火车合并的特性。

#### （3）SEP-3392 Extension Lifecycle Final（merged ~2026-10-29）— 扩展稳定性可沟通

扩展成熟度 Experimental → Beta → Stable（仍为扩展）或晋升核心；仓库命名 `experimental-ext-*` / `beta-ext-*` / `ext-*`；进 Beta/Stable 各需 Extensions Track SEP。过渡分类提案（分片已记）：`ext-apps`/`ext-auth` Stable；`ext-skills`/`ext-tasks` Beta 等。用命名约定 + SEP 门禁替换「每次破坏换 identifier」的碎规则。企业选型可看生命周期阶段；跟 Experimental 的实现方在进 Beta 前仍可能遇破发——设计内允许。

#### （4）企业控制面同周把 MCP「对象化」

| 信号 | 日期 | 机制要点 | 证据 |
|---|---|---|---|
| Glean 565 | 10-27 | +57 MCP 模板；service-credential 须显式 audience；list API 收窄；`private_key_jwt`；invocation ID；预算金额不再暴露给调用方 | A｜docs.glean.com |
| ServiceNow × OpenAI | 10-28 | ChatGPT marketplace **MCP plugin**；动作仍落 ServiceNow 权限/审批 | A｜IR |
| Salesforce Agent Fabric | 11-01 | Agent Evals 覆盖 agents/LLMs/**MCP servers**；Kill Switch；FinOps GA | A｜salesforce news |
| MCP docs | 10-30 | enterprise managed auth / IdP 文档 | A｜commit 主题 |

共同点：MCP server 开始像生产 API——有受众、调用 ID、持续评测、可熔断、可计费管控。

### 3.3 与上周对照

上期（第 21 期）主线是「自治等级 / 权限 / 恢复 / 身份」。本期 MCP 主线是同一「边界」问题的**协议层答案**：身份不再经第三方代理、规格火车可排期、企业把 MCP 纳入 SRE/FinOps。编码侧 Claude Code `blockWritesOutsideWorkingDirectories`、OpenClaw `workspaceOnly`、Copilot Assisted Permissions 与主线同向，但不替代 MCP 专题。

### 3.4 主线局限

- parallel-deep-research 未跑通（无 API key）。
- SEP-3392 过渡分类细节以分片与 PR 元数据为准；未逐字贴全文。
- Smithery 用户规模与 Arcade 迁移完成率未取得公开数字。

---

## 四、分节深写 · 编码 Agent / CLI / IDE（A 组）

### 4.1 模块结论

本周编码 Agent 主线不是「新榜分数」，而是 **CLI/IDE 把长会话、权限边界与跨运行时登录打成可运维产品能力**：Claude Code 将 idle compaction 与工作区外写拒绝推到 IDE/企业网关；Codex 用 0.165–0.166 接上 Vertex 与 GPT-6.1 Terra 并强化 queue/resume 与 safety UX；OpenCode 一周内连发 2.2.x，用 Claude Agent 桥复用 Claude Code 登录，并加上 `/goal` 与百分比 compaction；GitHub Copilot CLI 将 Assisted Permissions 移出实验；Replit 则把 Cloud Agents 卖成「非工程贡献 → 带视频证据的 PR」。Cursor 本窗无新产品 changelog；Aider/Roo 静默或已关停；SWE-Bench Pro V2 属窗外背景。

### 4.2 Claude Code（详见 TOP5-2）

窗内 **2.1.311–316**。核心工程点：`blockWritesOutsideWorkingDirectories` 与 permission mode 解耦；idle compaction IDE/Desktop 化；gateway 组预算 + layered policy + Bedrock input tagging；Opus 4.8 fast 弃用倒计时至 11-30。另：2.1.311 `ultrathink` 对指定模型走 xhigh effort；2.1.312 `oidc.user_id_claim`、hook 并发上限（每会话最多 24 个 prompt/agent hooks）。[A]

### 4.3 OpenAI Codex / CLI（详见 TOP5-4）

0.165.0 / 0.166.0 + Terra（10-26）。机制收敛：GCP Vertex 内置、memory v2 默认、queue `--resume`、reasoning-token 跨 resume 记账、safety-block 可选题改写、`doctor --network-only`。0.167 alpha 窗外。[A]

### 4.4 OpenCode

**v2.2.0（10-27）→ 2.2.5（≈10-31）**。[A]
- 2.2.0：实验 Desktop GUI plugins；`ctx.session.instructions.entry` 增量注入（保护 prompt cache）；可配置 cache TTL；加入 Terra；**移除 OpenCode GitHub Action（破坏性）**。
- 2.2.1：`/goal <objective>` 目标循环至评审确认；实验 `image_generate`。
- 2.2.3：**Claude Agent provider**——`/connect` 复用 Claude Code 登录与模型；managed policy 拆分 `integration.use` / `mcp.use` / `skill.use` / `plugin.use`。
- 2.2.4：持久 Desktop terminals；实验 artifacts；引导式 Claude Agent 安装。
- 2.2.5：百分比 `compaction.buffer`（如 `"20%"`）。

机制：把 Claude Code 可执行文件与已有 auth 挂成 provider，而非重做 Anthropic OAuth；目标循环 + 百分比 compaction 追平商业 CLI 的自主/运维面。

### 4.5 Gemini CLI

**v0.66.0 稳定**（≈10-27/28）：tool call groups 由 scheduler 发出、去掉 UI lookahead；Windows openDiff quoting；禁用 git 交互式凭据/SSH 提示；MCP OAuth 可选私网 endpoint；横幅提示 **Gemini CLI 未针对 Gemini 4 优化**。同窗 **v0.67 preview/nightly** 活跃。官方 docs announcements 仍滞后于 v0.64 叙述——本期稳定通道以 GitHub 为准。[A]

### 4.6 GitHub Copilot CLI（名单外纳入）

**1.0.104 / 1.0.105（10-27）**：Fusion 新会话默认从 Auto 起步；**Assisted Permissions 无需再开 experimental mode**；长上下文可选 Fusion High/Max 修复。与 Claude Code / Codex 企业权限叙事同向。[A]

### 4.7 Cline / Devin Desktop / Replit

- **Cline v4.1.26** + CLI/Desktop/SDK 同日（约 10-26）：云任务本地/云模型分离 + sandbox 进度卡。[A｜见 A-cline-roo]
- **Devin Desktop 3.11.228–238**：Remote-SSH/WSL 修复、Cyber Verification 开关；大改 Agent Window 对齐 web 在 **3.11.212=10-23（窗外背景）**。[A]
- **Replit Cloud Agents for company codebase**（博客 Published Oct 27）：Pro/Enterprise；非工程自然语言改公司库 → 沙箱浏览器验收 → PR/MR 附截图与**视频证据**；self-improving workspace memory（early access，token 降幅等为厂商自述 B）；Shared environments + Slack `@Replit`。[A/B]

### 4.8 静默 / 背景

| 对象 | 状态 | 说明 |
|---|---|---|
| Cursor | 无动态 | 产品 changelog 最近 Agent SDK 等 ≤10-23；窗内无新产品公告 [A] |
| Aider | 无动态 | 最新仍 v0.86.0（2025-08）[A] |
| Roo Code | 无动态 | 已关停；最后 v3.54.0=2026-05-15 [A] |
| SWE-bench | 背景，非本周 | SWE-Bench Pro V2 ≈2026-09-22 / 论文约 10-16，窗外 [背景] |

### 4.9 编码模块洞察

- **机制收敛点**：长上下文（idle/百分比 compaction、resume 记账）、权限（路径边界、Assisted、企业 policy）、运行时桥（Claude 登录复用、Vertex/GCP、云 sandbox）同时出现在头部 CLI——采购 checklist 应问这三件事而非模型名。
- **强弱**：**强** Claude Code / Codex / OpenCode / Copilot CLI / Replit；**中** Gemini CLI（稳修）/ Devin（远程一致性修补）/ Cline；**静** Cursor、Aider、Roo。
- **评测**：勿用窗外近天花板榜首百分比替代上述机制证据。

---

## 五、分节深写 · 开源框架与项目（B 组）

### 5.1 模块结论

本周开源 Agent 框架面三条并行线：（1）**个人助理 Gateway 的安全与恢复硬化**——OpenClaw 连发 2026.10.8/10.9 与 extended-stable 回灌；（2）**编排内核与应用壳**：LangGraph 1.2.18→1.2.19、CrewAI 1.15.31–33、browser-use 0.13.14、OpenHands v1.34.0；（3）**名单外新范式**——Hermit v0.1.0 首发可训练 harness adapter。Hermes 窗内无新 tag 但提交持续；Dify/ADK/OpenAI Agents SDK 无窗内正式 tag；AutoGen 落地页加 archive caution，与 Microsoft Agent Framework 1.24.0 形成迁移对照。

### 5.2 OpenClaw（必覆盖 · 独立深写）

- **窗口内状态**：有动态（核验：GitHub releases `openclaw/openclaw`；docs.openclaw.ai/releases；官网 openclaw.ai）— **双入口齐备**。
- **事实要点**（再述机制层，避免仅复读 TOP5）：
  - **2026.10.8**（2026-10-27Z）：更新失败后 Doctor 重启 Gateway；孤儿 maintenance worker 不再堵 CLI；Gateway 服务安装在 macOS/Linux 更稳；会话恢复与安全硬化（exec allowlist `test -v`、拒绝 generic node invoke 上的 browser proxy、沙箱子进程禁 host CLI）。
  - **2026.10.9**（2026-10-29Z）：依赖安全补丁链（fast-uri / Zod 集合边界 / nodemailer / MSAL Node）；**`tools.fs.workspaceOnly` 落到 Gateway 构建的 delegate/media 工具**——策略从「用户配置开关」延伸到合成工具路径；凭证不出 MCP CLI / Google OAuth 日志；失败回滚与 SQLite tokenizer/全文索引恢复；磁盘满后可自愈。
  - **extended-stable 2026.9.35/9.36**（10-27 / 10-29）：把上述安全与恢复回灌到「九月底 + 关键补丁」LTS 线——承认生产用户需要可预测的补丁火车，而非只追 mainline。
  - **2026.10.10-beta.4/5**（10-27 / 10-30）：流式不因类 tool-call XML/残缺 HTML 卡住 Gateway；Node 兼容放宽为「≥24.16 或 ≥26.1，24.22.1/26.12.1 为安全推荐」；cron 误丢与启动追赶修复。
  - 规模信号（仓况，**非窗内增量主张**）：README 叙事约 ~394k ★、MIT、Foundation 501(c)(3)。
- **机制**：单机长驻 **Gateway**（WS 控制面 + 渠道连接）把「受信控制面 / 不可信执行 / 策略用代码强制」落地。本周改动集中在三处：（a）依赖与解析边界防 DoS/注入；（b）`workspaceOnly` 与审批边界扩展到 Gateway 合成工具；（c）更新/Doctor/回滚状态机，避免「半更新不可引导」。
- **三问自检**：做了什么=安全依赖补丁 + workspace 边界 + 更新/会话恢复；怎么做到=Gateway 工具合成路径继承 `workspaceOnly` + 解析器/依赖边界 + Doctor/rollback 状态机；意味着什么=生产自托管必须跟进 10.9 级补丁，LTS 可走 extended-stable。
- **影响**：与 Hermes 同属「messaging Gateway + 本地状态」赛道；本周 Hermes 发版节奏更「提交密集、tag 滞后」（最近正式版 v0.22.5=10-23 **窗外**）。启用 `workspaceOnly` 的部署应回归测试 delegate/media。CoSA 论文（见 §七）在 OpenClaw 等 harness 上测 Skills 组合攻击，提示安全评审须扩展到组合工作流。
- **证据级**：A
- **来源**：https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases ；https://github.com/openclaw/openclaw

### 5.3 Hermit（名单外 · harness adapter 首发）

**v0.1.0** published 2026-10-26T01:17:18Z。[A] 框架训练/评估/部署 **harness adapter**——在不改原模型与原 harness 前提下，学习可版本化的外部指令/技能/记忆/工具/协作逻辑。进化方法：GEPA、SkillOpt、MWM、Harness²、Continual Harness。可生成 Codex/Claude Code 工作区或导出为 native plugins。Apache-2.0；早期 0.x API 可能变。机制：统一环 任务→Agent→Evaluator→Evolver→adapter 版本；adapter 规格（`.hermit/adapter.yaml` + ADAPTER.md + skills/tools）与宿主解耦。影响：给「只调 prompt/skill、不动基座」的持续改进提供工程化训练环；与 OpenClaw/Hermes skill、agentskills 标准同向。

### 5.4 LangGraph / LangChain / deepagents

- **langgraph 1.2.18**（10-26）：`error_handler` 全路径恢复；`DeltaChannel` 默认每 100 次更新打快照（原 1000）；interrupt_after/递归上限停跑仍推最后 checkpoint；子图 tag 去重。[A]
- **langgraph 1.2.19**（10-30）：`trace_policy` 不改写流式 node payload；messages/tools 事件带所属 graph namespace；子图内流式等修复；**ToolNode 工具名写入 graph node metadata**。[A]
- 同窗：langgraph-sdk 0.4.10/0.4.11（SSE 重连/backoff/Last-Event-ID）、cli 0.4.39/0.4.40、checkpoint 相关小版；langchain-core 1.7.1–1.7.3。[A]
- **deepagents-code 0.2.2**（10-26）：阻止项目 `.env` 设定 extension/shell/plugin/skill trust；终端外链限 HTTP/HTTPS；Auto mode 只读 Git allowlist；停向 LangSmith 上传本地 usage metadata。[A]

### 5.5 CrewAI / browser-use / OpenHands / AutoGPT

- **CrewAI 1.15.31–33**（10-27～10-29）：conversational flow **context compaction**；安全类修复（path traversal / SQL / 反序列化）；`crewai skill search`；`crewai run --inputs`；`deploy create --zip`。**1.15.34** published 2026-11-01T21:21:56Z → **窗外，正文不采用**。[A]
- **browser-use 0.13.14**（10-26）：保留 Python agent；**加入 OpenAI browser tools** 与共享 Bash helper；改进有界页面观察/表单/文件/browser recovery；明确 **Pi migration 仍分离**。[A]
- **OpenHands v1.34.0**（10-27）：per-conversation Docker runtime + Settings→Runtime；automations 标签过滤/编辑；markdown 外链安全（不信任 markdown 不得设 `rel=opener`/任意 target）。[A]
- **AutoGPT Platform beta v0.10.0**（10-27）：自托管 Docker Compose **每安装生成服务密码** + 数据端口仅 `127.0.0.1`（破坏性，需 `make init-env`）；External API **v2**（v1 弃用至 2027-01-31）；接入 GPT-6.1 Terra 等。[A]

### 5.6 其他固定对象（要点 / 静默）

| 对象 | 窗内 | 要点 |
|---|---|---|
| Hermes Agent | 有动态（提交）/ 无 tag | 最近正式版 v0.22.5=10-23 窗外；Desktop/渠道提交活跃 [A] |
| AutoGen | 文档信号 | 10-28 docs: archive caution；无窗内产品 release [A] |
| Microsoft Agent Framework | 有动态 | python-1.24.0（10-30）：MCP 本地工具默认审批；AgentTriggeredCompaction / UnloadSkillsCompaction；RedisContextProvider 索引迁移破坏性；Python 3.11 基线预警 [A] |
| Dify | 提交侧 | 无窗内 tag；1.18.0=10-23 窗外；HITL/IM、knowledge 提交 [A] |
| Google ADK | 提交侧 | 无窗内 tag（v2.13.0=10-23 窗外）；McpToolset 可收 `tools/list_changed`；eval parallelism [A] |
| OpenAI Agents SDK | 维护提交 | 无窗内 tag（v0.24.0=10-15 窗外）[A] |
| LlamaIndex / MetaGPT / SuperAGI | 无动态 | 长期无窗内显著 release [A] |

### 5.7 开源模块洞察

1. **安全与恢复成为 Gateway 类开源的主叙事**（OpenClaw、deepagents、AutoGPT 自托管），而不只是新功能清单。
2. **「Skill / Adapter 可进化」**：CrewAI skill search、MS AF skill unload、Hermit harness adapter——技能层从静态包走向可检索/可卸载/可训练。
3. **编排内核（LangGraph）继续抠流式与子图正确性**；应用层补产品与集成。
4. **双栈并存**：个人助理 Gateway（OpenClaw/Hermes）vs 图/多代理 SDK（LangGraph/CrewAI/ADK/MS AF）；Hermit 试图用 adapter 训练环横跨宿主。

---

## 六、分节深写 · Computer Use / 浏览器 / 通用自主 Agent（C 组）

### 6.1 模块结论

本周 Computer Use 增量不在「又一个能点网页的 demo」，而在三条并行工程线：（1）**OpenAI 把 computer use 明确钉在 ChatGPT Work 模型目录**（GPT-6.1 Terra，10-26），并用 Work/Codex 额度翻倍（10-29）与 Dot 短信通道（10-28）继续把「云浏览器 + 常驻 Agent」做成默认产品面——旧 ChatGPT agent / Operator 入口已退场，采购口径应以 Work cloud browser 为准；（2）**托管/平台侧把浏览器当成一等基础设施交付**——LangChain Managed Deep Agents（10-29）与 Cloudflare Agents SDK internal hostnames（10-28）；（3）**中国通用 Agent 继续以本地高权限发行版消化能力**——智谱 AutoClaw 2.2.0（10-26）、Genspark Media Studio（10-27）。Anthropic Computer Use API、Project Mariner、Perplexity Comet、Kimi/Qwen 浏览器扩展本窗无新的可核一手产品发布。

### 6.2 OpenAI Work / cloud browser / dots / Terra

- 官方 ChatGPT agent 帮助页写明：**「ChatGPT agent is no longer available. Use ChatGPT Work…」**；Operator 功能已并入 agent/Work（关停本身属更早产品事件，作背景+本周文档口径确认）。[A]
- **10-26** Terra 入 Work/Codex，官方描述覆盖 visual reasoning、**computer use**、writing。[A]
- **10-28** Pro（美国）beta「Texting your dot」——经 iMessage/RCS 与自有 dot 双向短信；经第三方 Linq。[A]
- **10-29** Pro 档与受影响套餐 **Work 与 Codex 额度翻倍**。[A]
- Cloud browser 机制（帮助页当前有效）：远程独立浏览器；登录 secure form、凭据对模型不可见；结果性动作（支付/预订等）仍需确认；与本机会话隔离。[A]

机制：不再维护独立 agent mode / Operator 站，把「推理 + 交付物 + 浏览器动作」收束到 Work；computer use 以模型能力标签进入选择器；短信通道把 HITL 降到即时通讯，但权限仍绑定原有 plugins/memory。

### 6.3 平台托管浏览器

- **LangChain Managed Deep Agents Browser（10-29）**：`define_browser(scope=thread|user)`；`browser_snapshot` / `browser_run`（Stagehand）/ `browser_screenshot` / `browser_handoff`。厂商自测 WebVoyager 100 任务 90% pass / \$1.98——**B，未独立核实**。[A/B]
- **Cloudflare Agents SDK internal hostnames（10-28）**：持久浏览器可配置 `internalHosts`，请求回源到 Agent Durable Object / 沙箱端口，**无需把 dev server 暴露公网**；需 Agents SDK ≥0.31.0。解决「沙箱起了 Vite/Next，云端浏览器打不到 localhost」。安全上需限制可代理目标，防内网 SSRF。[A]（10-13 persistent browserTool 为窗外背景底座）

### 6.4 中国通用 Agent / 其他

- **智谱 AutoClaw 2.2.0（10-26）**：项目模式、卡顿重连与限流断点续跑、专业库直连、IM 机器人增强、旧版三步迁移；窗内 Tokens 活动覆盖至 11-01；**10-28** GLM-5.3-flashX-Legal（Harvey LAB 通过率等为厂商口径 B）。[A/B]
- **Genspark Media Studio（10-27）**：Agent 任导演编排多模型影视流水线。[A] SB-Box 产品页可见、精确首发日未钉死（第三方称 late October）→ 轻写观察。[A/B–D]
- **Anthropic Computer Use / Duet**：API toolset `computer_toolset_20260801` 稳定无新版本日；Duet 无窗内新发（上窗 10-21/10-23 延续）→ 消化期。[背景 A]
- **Mariner / Comet / Kimi / Qwen 浏览器 / Manus**：无窗内可核重大一手或仅聚合站弱信号 → 静默/观察（见覆盖表）。

### 6.5 Computer Use 模块洞察

1. **入口品牌退场，配额与模型成为 Computer Use 的真实控制面**——评测与采购应改问 Work/cloud browser/dots。
2. **「浏览器」正在被平台收编为托管原语**——选型轴变为会话范围（thread/user）、handoff、egress/allowlist、可观测。
3. **中系偏发行版与垂直模型，美系偏云浏览器配额**——对照成立但勿过度外推未核数字。

---

## 七、分节深写 · 企业 / 协议 / 评测与工程（D 组）

### 7.1 模块结论

本周企业 Agent 叙事从「能不能做事」转向 **「长周期主动触达能否合规」+「跨平台 Agent 能否被评测/熔断/控费」+「垂直场景是否用真实工作产物评测」**。协议侧无新 MCP 规格版本，但 SEP-3398/3392 + Smithery 关停 + 企业 IdP 文档化改变规划方式。评测有料点在 Harvey LAB:USCL 与 CoSA（Skills 组合攻击），而非经典通用榜刷新。

### 7.2 MCP 生态（与主线交叉，此处补工程面）

- Spec 仍 **2026-07-28**；SDK：TS 最近有料 v2.4.0=10-23 **窗外**；Python v2.3.0=10-02 **窗外** → 本周 SDK 静默。[A]
- **MCP Inspector 2.13.0**（≈10-28/29）：跟进 Node.js CA/runtime 安全发布（eMudhra 中间 CA 等）；属安全运维必做项。[A]
- **2026-10-30** docs：enterprise managed auth / IdP 支持文档（#3306）；**10-31** Security IG 改 routing group（#3331）。[A｜主题级]

### 7.3 Salesforce Agent Fabric（详见 TOP5-5）

Agent Evals / API Evals / Kill Switch / FinOps；评测显式覆盖 **MCP servers**。控制面能力多为新增；被 Kill Switch 关停对业务面可破坏。[A/B]

### 7.4 Glean 565（2026-10-27）

Agent import/export 放宽到创建者；自主执行引擎默认升级；**+57** remote MCP server templates；service-credential 须显式 Platform audience；list API 对非管理员仅基础字段；Usage APIs / Evaluate My Usage Limits **不再向调用方暴露组织预算金额**；`private_key_jwt` 机密客户端；invocation ID；动态 skills/tools 默认个性化 tool list；memory settings；Gemini 4 Argon 入 Model Hub（内部 eval 偏好率等 **B**）；EU AI Act 相关 Assistant AI-generated notice 默认可于 **2026-11-10** 自动开启。[A/B]

机制：企业知识图 + 权限继承之上，把 MCP 当作受管工具平面。对依赖完整 server list / org budget 字段的集成 = **部分破坏性**。

### 7.5 Sierra / Harvey / ServiceNow

- **Sierra Compliance Console（10-28）**：Horizon 内置主动 outreach 护栏——渠道 disclosure、时区 contact windows、节假日排除、频次上限、全渠道 opt-out 存档、Insights（allowed/deferred/blocked/held）。[A] **10-30** 披露 \$400M+ ARR 等经营数据（**B，未独立核实**）；推进开放标准 **Poppy**（进行中，B）。
- **Harvey（10-26/28/29）**：登录页邮箱路由；Tirant 知识源、Agent Builder 增强、Retention policy、**Ethical Walls – iManage SPM** 等 GA/更新。[A] **LAB: USCL（10-29）**：真实 PACER/RECAP + CourtListener；closed/open-book（CourtListener MCP）；成对 Elo；环境暂不公开样本。[A/B]
- **ServiceNow × OpenAI（10-28）**：Action Fabric；ChatGPT 内 **ServiceNow MCP plugin** 已在 marketplace 可用；2027 规划项标 B。[A/B]

### 7.6 评测与安全工程

#### Harvey LAB: USCL

从约 200 dockets 管线初产 40 环境，人工校正后 **100** 个；引用匹配规则 >95%；单短指令无律师迭代；称少数前沿模型可 one-shot 完整初稿但仍有长尾失败（幻觉、让步、过时先例）——能力判断为研究报告 **B**。垂直域用真实工作产物替代合成 quiz。[A/B]

#### CoSA / CoSA-Bench（arXiv 2610.35082，published 2026-10-26）

提出 Conflict of Skills：单 Skill 过静态检查仍可能在组合时违规。CoSA 攻击：向池中加入通过单包检查的「良性」Skills，预算 ≤ 原池 5%。Bench：288 任务 × 多领域。五模型 × 三 harness（**OpenClaw / OpenHands / OpenCode**）：违规率 **35.02% → 58.45%（+23.43pp）**（论文数字 **B**）。轻量护栏后 OpenClaw 招聘任务违规 **65.28% → 6.67%**（**B**）。静态扫描增强前后严重告警数不变。[A/B]

影响：采用 Agent Skills / MCP 工具池的团队，安全评审须从「扫每个包」扩展到「组合工作流与产物用途」。

#### 通用榜

SWE-Bench Pro V2（约 10-16）、OSWorld / WebArena / GAIA / τ-bench：**本周无核出重大官方突破一手**；Pro V2 仅作窗外背景（干净容器重评、锁网等）。[窗外/未取得]

### 7.7 静默企业对象

- Microsoft Copilot Agents（企业 Studio 独立稿）：本组口径无重大公开动态；GitHub Copilot Universe 主责归 A。[核验]
- 字节 Coze / 扣子：docs.coze.cn/recent-updates 已读，缺精确窗内日戳重大条 → 无动态。[核验]

### 7.8 企业/协议模块洞察

1. 合规与治理产品化同步发生在「长周期主动 Agent」与「跨平台 Agent 控制面」两端。
2. 垂直评测用真实案卷/真实义务重新拉开差距；通用编码榜继续修标。
3. 攻击面从单工具调用迁移到 Skills 组合与产物复用——与 MCP/Skills 标准化同周期。
4. 协议冷静、治理吵闹：无 wire 大改，但发布火车 + 扩展生命周期 + 代理关停改变产品规划。

---

## 八、对比表素材（≥8 行）

| 产品/项目 | 版本或日期 | 变化摘要 | 是否破坏性 | 影响面 | 证据级 |
|---|---|---|---|---|---|
| Smithery MCP Proxy | 2026-10-31 | 关停代理与托管身份；目录留存由 Arcade 驱动 | **是** | 所有 Smithery URL 用户 / Connect B2B | A |
| SEP-3398 | merged 2026-10-27 | 3/9 月发布火车；下版目标→2027-03 | 否（流程） | SDK/产品排期 | A |
| SEP-3392 | Final/merged 10-28/29 | 扩展 Experimental/Beta/Stable 生命周期 | 对跟实验扩展者潜在是 | 扩展作者/实现方 | A |
| Claude Code | 2.1.314–316 | 工作区外写拒绝；idle compaction IDE 化；组预算/layered policy；Opus 4.8 fast 弃用倒计时 | 低～中（行为收紧+模型弃用） | 编码 Agent 企业部署 | A |
| OpenClaw | 2026.10.8/10.9 | 依赖安全；workspaceOnly→合成工具；Doctor/回滚/磁盘满自愈；extended-stable 回灌 | 低（策略开启后行为变） | 自托管 Gateway | A |
| Codex CLI | 0.165.0 / 0.166.0 | Vertex 内置；Terra；queue --resume；safety UX | 否 | 多云编码 CLI | A |
| OpenCode | 2.2.0–2.2.5 | Claude Agent 桥；/goal；百分比 compaction；**移除 GitHub Action** | **部分是**（CI Action） | 开源桌面/TUI | A |
| Salesforce Agent Fabric | 2026-11-01 | Agent/API Evals；Kill Switch/FinOps GA；评测含 MCP | 干预可破坏业务流量 | 多平台 Agent 治理 | A |
| Glean 565 | 2026-10-27 | +57 MCP 模板；受众/预算字段收紧；JWT 机密客户端 | **部分是**（API 字段收窄） | 企业 MCP 网关 | A |
| browser-use | 0.13.14 | 接入 OpenAI browser tools；Pi migration 仍分离 | 否 | 浏览器自动化集成 | A |
| Hermit | v0.1.0（10-26） | 可训练 harness adapter 首发 | 0.x API 可能变 | 跨宿主 skill/adapter | A |
| CrewAI | 1.15.31–33 | flow compaction；skill search | 否 | 多代理 Flow/CLI | A |
| AutoGPT Platform | beta v0.10.0 | 本机绑定+生成密钥；API v2 | **是**（自托管网络/密钥） | 自托管平台 | A |
| Sierra Compliance Console | 2026-10-28 | 主动 outreach 合规控制台 | 否（新增） | 受监管主动触达 | A |
| CoSA / CoSA-Bench | 2026-10-26 | Skills 组合攻击 + 护栏实验 | 研究性 | Skills/OpenClaw 安全 | A/B |
| MCP Spec / TS·Py SDK | 窗内 | Spec 无新版；SDK 无窗内新 major | — | 实现基线 | A |

---

## 九、综合层

### 9.1 模块洞察（跨对象）

1. **边界硬化同周出现在三层**：协议连接（Smithery→厂商端点）、编码工具路径（Claude Code / OpenClaw workspaceOnly / Copilot Assisted Permissions）、企业控制面（Salesforce Kill Switch / Glean audience）。读者应把这三层当作同一检查清单，而非三个无关新闻。
2. **长会话成为可运维产品能力**：idle compaction（Claude Code IDE 化）、百分比 compaction buffer（OpenCode）、queue resume + reasoning-token 记账（Codex）、CrewAI conversational flow compaction、MS AF AgentTriggeredCompaction——竞争点从「上下文窗口多大」转为「压缩/续跑/记账是否可预期」。
3. **MCP 被对象化之后，评测与攻击面也跟着对象化**：Salesforce 评测 MCP servers；Glean 给 invocation ID；CoSA 证明 Skills 组合风险绕过单包扫描——运营 MCP/Skills 的团队需要「组合级」安全与 SRE。
4. **Computer Use 的采购口径已换名**：Operator/agent mode → Work + cloud browser + dots；平台托管浏览器（LangChain / Cloudflare）降低自建 Chromium 差异化。
5. **开源双栈**：Gateway 个人助理（OpenClaw/Hermes）vs 图/多代理 SDK；Hermit 试图用可训练 adapter 横跨——仍属早期 0.x，勿当生产默认。

### 9.2 周环比（第 22 期 vs 第 21 期）

上期窗口：2026-10-19 ~ 10-25｜本期：2026-10-26 ~ 11-01

#### 延续
- **权限/沙箱硬化**：上期 Claude Code 密集修 bypass；本期继续推 `blockWritesOutsideWorkingDirectories`、网关 layered policy / 组预算；OpenClaw `workspaceOnly` 落到 Gateway 合成工具；Copilot Assisted Permissions 出实验。
- **会话恢复与压缩**：上期 OpenClaw 恢复 provenance、OpenCode keepID；本期 OpenClaw 失败更新/Doctor/磁盘满自愈，Claude Code idle compaction 扩到 IDE/Desktop，Codex `queue --resume` + reasoning-token 记账，CrewAI conversational flow compaction。
- **OpenClaw 必覆盖**：上期 10.6/10.7；本期 10.8/10.9 + extended-stable 回灌。
- **企业主动触达/治理**：上期 ServiceNow Arc / NVIDIA OpenShell；本期 Sierra Compliance Console、Salesforce Kill Switch/FinOps。

#### 新出现
- **Smithery MCP Proxy 10-31 关停**（破坏性连接迁移）。
- **SEP-3398 / SEP-3392**：发布火车→2027-03；扩展生命周期 Final。
- **GPT-6.1 Terra** 入 ChatGPT Work / Codex（含 computer use 标签）；Work/Codex 额度翻倍；Dot 短信。
- **OpenCode Claude Agent `/connect`** 复用 Claude Code 登录；`/goal`。
- **LangChain Managed Deep Agents 浏览器**；**Cloudflare Agents SDK internal hostnames**。
- **Hermit v0.1.0** harness-adapter 首发。
- **Glean 565** MCP 模板+受众收紧；**Harvey LAB:USCL**；**AutoClaw 2.2.0**；**Genspark Media Studio**。
- **Salesforce Agent Fabric Agent Evals** 显式覆盖 MCP servers（11-01）。
- **CoSA** Skills 组合攻击论文（10-26）。

#### 消失 / 降温
- **Claude Duet / Anthropic Computer Use**：本窗无新发，消化上期信号。
- **Cursor**：本窗无新产品 changelog（上期亦弱）。
- **Aider / Roo**：继续静默或已关停。
- **Project Mariner / Comet / Kimi / Qwen 浏览器**：无窗内一手增量。
- **SWE-bench 新榜**：仍无可用窗内突破。
- **Dify / Hermes / ADK**：无窗内正式 tag（提交或窗外版延续）。

---

## 十、覆盖表（固定对象终态）+ 发现层摘要 + 局限

### 10.1 覆盖表

#### A · 编码 Agent / CLI / IDE

| 对象 | 窗内状态 | 分片/备注 |
|---|---|---|
| Claude Code | 有动态 | A-claude-code.md｜2.1.311–316 |
| OpenAI Codex/CLI | 有动态 | A-codex.md｜0.165/0.166 + Terra |
| Gemini CLI | 有动态 | A-gemini-cli.md｜0.66.0 + 0.67 preview/nightly |
| Cursor | 无动态（已核验） | A-cursor.md｜最近公告 ≤10-23 |
| Devin/Windsurf→Devin Desktop | 有动态 | A-devin-windsurf.md｜3.11.228–238；大改 3.11.212 窗外背景 |
| OpenCode | 有动态 | A-opencode.md｜2.2.0–2.2.5 |
| Aider | 无动态 | A-aider.md｜最新 0.86.0 (2025-08) |
| Cline | 有动态 | A-cline-roo.md｜4.1.26 + cli/desktop/sdk |
| Roo | 无动态（已关停） | A-cline-roo.md｜最后 2026-05-15 |
| Replit Agent | 有动态 | A-replit.md｜Cloud Agents 博客 10-27 |
| GitHub Copilot CLI（名单外） | 有动态 | A-copilot-cli.md｜1.0.104/105 |
| SWE-bench 相关 | 背景，非本周 | A-swebench.md｜Pro V2 窗外 |

#### B · 开源框架与项目

| 对象 | 窗内状态 | 备注 |
|---|---|---|
| OpenClaw（必覆盖） | 有动态 | 2026.10.8/10.9 + extended-stable + beta；双入口 |
| Hermes Agent | 有动态（提交）/无 tag | v0.22.5=10-23 窗外 |
| LangGraph / LangChain | 有动态 | 1.2.18/1.2.19 等 |
| AutoGen | 有动态（文档） | archive caution 10-28；无产品 release |
| CrewAI | 有动态 | 1.15.31–33；1.15.34 窗外 |
| Dify | 有动态（提交）/无 tag | 1.18.0=10-23 窗外 |
| LlamaIndex Agents | 无动态 | 最新 v0.14.25=09-21 |
| Google ADK | 有动态（提交）/无 tag | v2.13.0=10-23 窗外 |
| OpenAI Agents SDK | 有动态（维护提交）/无 tag | v0.24.0=10-15 窗外 |
| browser-use | 有动态 | 0.13.14 |
| OpenHands | 有动态 | v1.34.0 |
| AutoGPT | 有动态 | Platform beta v0.10.0 |
| MetaGPT | 无动态 | 最新仍 2025 v0.8.x |
| SuperAGI | 无动态/低活跃 | 未取到窗内显著 release |
| Hermit（名单外） | 有动态 | v0.1.0 首发 |
| deepagents（名单外） | 有动态 | deepagents-code 0.2.2 等 |
| MS Agent Framework（名单外） | 有动态 | python-1.24.0 / dotnet-1.27.0 |

#### C · Computer Use / 浏览器 / 通用 Agent

| 对象 | 窗内状态 | 备注 |
|---|---|---|
| OpenAI Operator/ChatGPT Agent→Work+cloud browser+dots | 有动态 | Terra / Dot / 额度翻倍；agent 页确认退场口径 |
| Anthropic Computer Use API | 无重大公开动态 | toolset_20260801 稳定；无窗内新版本日 |
| Anthropic Claude Duet | 无窗内新发布 | 延续上期 10-21/10-23 |
| Google Project Mariner / Gemini Agent | 无重大公开动态 | 观察；关停线索无 Google 原文 |
| Perplexity Comet / Computer | 无经原文确认的窗内产品动态 | changelog≈10-19 |
| Manus | 轻动态/观察 | 聚合站 10-27 Sites 桌面应用；官方 blog 无同日帖 |
| Genspark | 有动态 | Media Studio 10-27；SB-Box 日期未钉死 |
| Kimi Agent / 浏览器扩展 | 无窗内新动态 | 资源页 Updated 2026-09-28 |
| Qwen Agent / Browser Use | 无窗内一手周报/重大公告 | 最近周报 10-09/10-15 窗外 |
| 智谱 AutoClaw | 有动态 | 2.2.0 + Tokens 活动 + Legal 模型 |
| LangChain Managed Deep Agents Browser（名单外） | 有动态 | 10-29 |
| Cloudflare Agents SDK internal hostnames（名单外） | 有动态 | 10-28 |

#### D · 企业 / 协议 / 评测

| 对象 | 窗内状态 | 备注 |
|---|---|---|
| MCP Spec | 无新版本；有治理 SEP | 仍 2026-07-28；3398/3392 |
| MCP TS/Py SDK | 窗内无新 major | 最近有料版窗外 |
| MCP Inspector | 有动态 | 2.13.0 |
| Smithery / Registry 代理层 | 有动态 | 10-31 关停 |
| Sierra | 有动态 | Compliance Console；ARR 披露 B |
| Glean | 有动态 | 565 |
| Harvey | 有动态 | Ethical Walls；LAB:USCL |
| ServiceNow AI Agents | 有重大动态 | ×OpenAI + MCP plugin |
| Salesforce Agentforce / Agent Fabric | 有重大动态 | Evals/Kill Switch/FinOps |
| Microsoft Copilot Agents（企业） | 无重大公开动态（本组口径） | Copilot Universe 归 A |
| 字节 Coze/扣子 | 无动态 | 缺窗内日戳条目 |
| SWE-bench/OSWorld/WebArena/GAIA/τ-bench | 无重大窗内官方突破 | Pro V2 窗外背景 |
| CoSA（名单外） | 有动态 | arXiv 10-26 |

**覆盖对象计数（表内行，含名单外纳入与静默核验）**：A 12 + B 17 + C 12 + D 14 ≈ **55** 行终态（含交叉对象按组分别记账；OpenClaw 必覆盖已满足双入口）。

### 10.2 发现层摘要

| 组 | discovery 路径 | 名单外纳入深写（例） | 排除/观察要点 |
|---|---|---|---|
| A | shards/A/discovery.md | Copilot CLI Assisted Permissions | Cursor/Aider/Roo 静默；0.167 alpha 窗外；SWE Pro V2 窗外 |
| B | shards/B/discovery.md | Hermit；deepagents；MS Agent Framework | Agent Kernel 窗外 tag；AgentRage 二手不采用；SuperAGI 低活跃 |
| C | shards/C/discovery.md | LangChain Managed Browser；CF internal hostnames；AutoClaw/Terra 扩写 | Foundry/Telnyx/Simular 窗外；Manus 聚合弱信号；SB-Box 日期未钉 |
| D | shards/D/discovery.md | Smithery；SEP-3398/3392；Salesforce；CoSA；Harvey LAB | SWE Pro V2/OpenShell/Strands 窗外；Coze 无日戳；OSWorld 等无突破一手 |

### 10.3 局限（已知）

1. **`parallel-deep-research` 未跑通**（PARALLEL_API_KEY 未登录 / 不可用）；主线改为一手 WebFetch + PR API + 分片交叉，机制级已覆盖但缺少该工具的二次发散检索。
2. **若干精确规模/迁移完成率未取得**：Smithery 用户规模与 Arcade 迁移率；Salesforce「>1.2B」等为公司披露未独立核实；LangChain WebVoyager 90%/\$1.98、Sierra ARR、CoSA 百分比效果均为 B。
3. **部分入口滞后或不完整**：Gemini CLI 官方 docs announcements 滞后于 GitHub 0.66；Perplexity/Qwen/Mariner/Coze 等依赖检索+页面日期扫描，已标「未取得」或静默；SEP-3392 过渡分类未逐字贴全文；CrewAI 1.15.34 / Codex 0.167 alpha 等严格窗外排除。

---

## 十一、来源清单（母稿采用主源）

### 主线 / MCP
- https://smithery.ai/future
- https://github.com/modelcontextprotocol/modelcontextprotocol/pull/3398
- https://github.com/modelcontextprotocol/modelcontextprotocol/pull/3392
- https://github.com/modelcontextprotocol/inspector/releases （2.13.0）
- https://kapyn.app/blog/smithery-shutdown-mcp-migration （迁移交叉，背景）

### 编码 Agent
- https://code.claude.com/docs/en/changelog
- https://github.com/anthropics/claude-code/releases
- https://learn.chatgpt.com/docs/changelog
- https://github.com/openai/codex/releases
- https://opencode.ai/changelog
- https://github.com/anomalyco/opencode/releases
- https://github.com/google-gemini/gemini-cli/releases/tag/v0.66.0
- https://raw.githubusercontent.com/github/copilot-cli/main/changelog.md
- https://replit.com/blog/anyone-can-bring-ideas-to-company-codebase
- https://docs.devin.ai/desktop/changelog
- https://github.com/cline/cline/releases
- https://cursor.com/changelog （无窗内新产品）

### 开源框架
- https://github.com/openclaw/openclaw/releases
- https://docs.openclaw.ai/releases
- https://github.com/Infini-AI-Lab/hermit/releases/tag/v0.1.0
- https://infini-ai-lab.github.io/hermit/
- https://github.com/langchain-ai/langgraph/releases
- https://github.com/langchain-ai/deepagents/releases
- https://github.com/crewAIInc/crewAI/releases
- https://github.com/browser-use/browser-use/releases/tag/0.13.14
- https://github.com/OpenHands/OpenHands/releases/tag/v1.34.0
- https://github.com/Significant-Gravitas/AutoGPT/releases/tag/autogpt-platform-beta-v0.10.0
- https://github.com/microsoft/agent-framework/releases/tag/python-1.24.0
- https://github.com/microsoft/autogen/commit/d07c667a3239ea4ab7af62a53b0f4ff205a1f23d
- https://github.com/NousResearch/hermes-agent/releases （窗外 tag 核验）
- https://github.com/google/adk-python/commits
- https://github.com/langgenius/dify/releases

### Computer Use
- https://help.openai.com/en/articles/6825453-chatgptrelease-notes
- https://help.openai.com/en/articles/20001280-using-cloud-browser-in-chatgpt
- https://help.openai.com/en/articles/11752874-chatgpt-agent
- https://www.langchain.com/blog/browser-use-in-managed-deep-agents
- https://developers.cloudflare.com/changelog/post/2026-10-28-browser-internal-hostnames/
- https://autoclaw.zhipuai.cn/blog/news/autoclaw-2-2-0-upgrade-data-migration/
- https://autoclaw.zhipuai.cn/blog/model/GLM-5.3-FlashX-Legal/
- https://www.genspark.ai/blog/genspark-media-studio
- https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/computer-use-tool （背景）

### 企业 / 评测
- https://www.salesforce.com/in/news/stories/agent-fabric-catch-failures-control-ai-costs/
- https://docs.glean.com/release-notes/releases/2026-10-27-october-release
- https://sierra.ai/blog/introducing-compliance-console
- https://sierra.ai/blog/our-customers-ambition-is-accelerating-our-growth
- https://help.harvey.ai/release-notes
- https://www.harvey.ai/blog/legal-agent-bench-us-case-law
- https://investor.servicenow.com/news/news-details/2026/ServiceNow-and-OpenAI-accelerate-enterprise-AI-from-models-and-operations-to-cybersecurity-and-agentic-development/default.aspx
- https://arxiv.org/abs/2610.35082 （CoSA）

### 运行目录内部素材
- `/workspace/weekly/weekly-agent-report/2026-11-02/status.md`
- `/workspace/weekly/weekly-agent-report/2026-11-02/mainline-deep.md`
- `/workspace/weekly/weekly-agent-report/2026-11-02/wow.md`
- `/workspace/weekly/weekly-agent-report/2026-11-02/prior-wow-notes.md`
- `/workspace/weekly/weekly-agent-report/2026-11-02/shards/{A,B,C,D}/*`

---

## 十二、冻结声明

- 本文件为第 22 期**全量研究版冻结母稿** `master.md`。
- 证据级 A–D **仅存于母稿**；读者稿由 `report2article` 改写时不得展示证据级标签。
- 若编辑阶段有界补证修订，另存 `master-v2.md` 并更新 `status.md` 指向。
- 研究 PASS 条件已由主控在 `status.md` 勾选；本母稿汇总分片与主线深挖，可进入编辑。
