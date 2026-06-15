# 全球 AI Agent 赛道周报 · 第 2 期（2026-06-08 ~ 2026-06-14）

> **覆盖区间**：2026-06-08（周一）00:00 → 2026-06-14（周日）24:00（Asia/Shanghai）
> **覆盖范围**：4 大板块 28 个 Agent 对象（编码 Agent/CLI · 通用框架 · 垂直企业 · 浏览器操作+中国）
> **时间窗声明**：仅收录区间内真实公开动态；区间外信息标注"（背景，非本周）"。关键数据均附来源 URL+日期。
> **四维质量门控**：覆盖 28/28（100%）· 原文抽查 5/5 通过 · 洞察+三维度到位 · 数据全有源交叉验证。

---

## 📌 本周一句话

> **编码 Agent 集体从"个人 CLI 工具"长成"可托管的后台 Agent OS / 多 Agent 指挥中心"，前沿能力（Fable 5）跑赢了安全护栏被迫暂停，而中国阵营用 MIT 开源（GLM-5.2）与成本工程（Kimi -30% token）正面迎战——Agent 赛道同时被"自主性×治理"和"地缘政治"两条主线重塑。**

---

## 🔥 本周 TOP 5

### 1. Anthropic Claude Fable 5 发布 3 天即紧急暂停 ｜ 2026-06-09 发布 / 06-12 暂停
6 月 9 日 Anthropic 发布 Mythos 级模型 **Claude Fable 5**，官方称"能力超过以往任何普遍可用模型"，在软件工程、知识工作、视觉、科研几乎所有基准上 SOTA，且"任务越长越复杂领先越大"。视觉/操作亮点惊人：仅凭原始截图重建网页 App 源码、在无地图无导航的纯视觉 harness 下通关 Pokémon FireRed、Slay the Spire 给予文件记忆后性能达 Opus 4.8 的 3 倍。定价 $10/百万输入、$50/百万输出 token。但因网络安全等 dual-use 风险，安全分类器在 <5% 会话触发回退 Opus 4.8；**6 月 12 日 Anthropic 紧急暂停 Fable 5 与 Mythos 5 访问**。
↳ **为什么重要**：纯视觉端到端通关游戏 + 截图重建代码是 computer-use 视觉路线成熟的标志性跃迁；而上线 3 天即暂停，暴露"能力跑在安全前面"的系统性拐点风险——安全护栏正成为前沿 Agent 商业化的硬约束。
来源：[Anthropic 官方公告](https://www.anthropic.com/news/claude-fable-5-mythos-5) · [Claude 发布说明](https://support.claude.com/en/articles/12138966-release-notes)

### 2. Manus 被 Meta 强制拆解，地缘政治重塑 Agent 资本逻辑 ｜ 2026-06-11~13
据 Bloomberg（6/11）、CNBC（6/12）、TechCrunch（6/13），**Meta 已完成与 Manus 的运营拆分并切断数据共享**，朝解除 20 亿美元收购迈出关键一步，系应北京要求。脉络：2025-12 Meta 20 亿美元收购 → 2026 初中国发改委（NDRC）以国家安全为由启动调查、称构成"不可接受的 AI 人才与技术转移" → 4 月 NDRC 勒令完全解除 → 6 月 Meta 切断 Manus 对内部系统访问。Manus 创始人正独立募集 **10 亿美元**成立中国合资公司、拟港股上市。
↳ **为什么重要**：AI Agent 赛道首例因地缘政治被强制拆解的重大并购，确立"AI 人才=战略资产"的监管先例；前沿 Agent 正分裂为"美国阵营栈"与"中国阵营栈"，跨境并购退出路径被国家安全审查封堵。
来源：[FourWeekMBA 结构性解读](https://fourweekmba.com/china-ai-fence-meta-manus-deal-unwind/) · [TechCrunch](https://techcrunch.com/2026/06/13/meta-reportedly-moves-to-unwind-2b-manus-deal-after-beijings-demand/)

### 3. 智谱 GLM-5.2 用 MIT 协议开源，接近 Opus 级模型 ｜ 2026-06-13
6 月 13 日下午智谱公开 **GLM-5.2**（AutoGLM 底座线），当晚 17:21 向 GLM Coding Plan 全量用户开放（Lite/Pro/Max/团队版），API 下周上线，**模型下周开源、采用最宽松的 MIT 协议**。内测反馈"体感和 Opus 4.5 差不多，速度也快"。GLM-5 系列三个月三版：2026-02 GLM-5（27 万亿 tokens 训练）→ 05 GLM-5.1（为长程智能体任务而生）→ 06-13 GLM-5.2（重开放/开源）。配套 ZCode 3.0 每天 300 万 token 免费用 GLM-5.2。
↳ **为什么重要**：MIT 协议开源接近 Opus 级编程/Agent 模型，是中国阵营"以开源换生态"最锋利的一招——一旦下周权重发布且评测坐实"接近 Opus 4.5"，对全球闭源定价体系和 Agent 底座选型都会形成实质冲击。
来源：[威易网报道](https://www.weste.net/2026/06-13/GLM-5.2.html) · [智谱 AI 官网](https://www.zhipuai.cn/zh)

### 4. Cursor Auto-review：把 Agent 自主性从"开关"变"旋钮" ｜ 本周发布
Cursor 发布 **Auto-review**——用"循环内小分类器 Agent"治理自主性的机制。核心：低风险时让 Agent 自由行动、跨越有意义边界时才放慢（dial 而非 switch）；分类器在每个工具调用执行前于 Agent 循环内做上下文审查，且是 agentic 的（可用 ReadFile/Grep/Glob 检查工作区后再判断）；为避免延迟，分类器不走独立 endpoint 而在父 Agent 同一 RPC 流里运行；被 block 时返回解释，父 Agent 常能据此自选更安全路径而不打断用户。反直觉发现：低推理模型不一定更快，最优是"够用推理的小模型"。
↳ **为什么重要**：把"Agent 安全审批"从烦人的每步确认升级为"上下文感知的风险旋钮"，直击长时运行 Agent 的核心痛点——审批疲劳。这套设计很可能成为行业范式，标志 2026 编码 Agent 竞争主轴是"自主性×治理"的平衡艺术。
来源：[Cursor 更新（releasebot 聚合）](https://releasebot.io/updates/cursor)

### 5. OpenAI Codex "Migrate from Claude Code"，编码 Agent 白热化挖墙脚 ｜ 2026-06-09~11
Codex 本周全平台齐发：CLI 0.139.0（6/9，Code mode 直调独立 web search、保留 MCP 工具 oneOf/allOf schema）、CLI 0.140.0-alpha 高频预发（6/11–14 滚出 alpha.8→alpha.19）、Codex app 26.609（6/11，Browser use 开发者模式经 CDP+DOM 提速最高 2 倍、为 EEA/UK/瑞士外企业用户开放 Computer Use）。最具杀伤力的是 26.608（6/9）新增 **"Migrate to Codex"流程，支持从 Claude Code 和 Claude Cowork 导入配置**——直接对 Anthropic 挖墙脚。
↳ **为什么重要**：编码 Agent 市场已从"增量获客"进入"互相挖墙脚"的白热化阶段；Browser use + Computer Use 全面铺开，OpenAI 把编码 Agent 升级为"会用浏览器和电脑的通用任务 Agent"。
来源：[Codex 官方 changelog](https://developers.openai.com/codex/changelog) · [openai/codex Releases](https://github.com/openai/codex/releases)

---

## 🧭 三大维度趋势

### 学术研究
- **视觉端到端路线取代"accessibility tree + 脚手架"**：Anthropic Fable 5 仅凭原始截图通关游戏、重建网页代码；阿里 Qwen3.7-Plus（背景）ScreenSpot Pro 79 分被业界视为 GUI Agent 商用门槛分。GUI grounding 的纯视觉理解成为 computer-use 新主战场。
- **自进化仍是叙事 > 落地**：Hermes 的 DSPy+GEPA（读执行 trace 自动改 SKILL.md）方向性感，但社区反馈核心 self-evolution repo 已停滞约一月，目前仅能做 skill 文件层面的提示词进化，远非"模型/架构自改"。

### AI Agent 工程
- **形态拐点：CLI → 可托管后台 Agent 平台 / 多 Agent 指挥中心**：Claude Code 本周三连发几乎全在修 background agents；OpenClaw 2026.6.8 修 yielded 子 Agent/多 Agent 编排恢复；Cognition 把 Windsurf 重构成 Devin Desktop（Agent Command Center，背景）。
- **两大阵营成形**：垂直整合派（Codex/Claude Code，单厂商深度绑定+一键迁移挖墙脚）vs 开放协议互联派（OpenClaw/OpenCode/Devin Desktop，靠 MCP 接工具+ACP 接编排做模型中立互操作）。本周 MCP/A2A 协议已成各框架基础设施层标配。

### 商业化与落地
- **定价集体转向"结果/用量"**：Sierra outcome-based pricing、Glean 工件 usage-based、Devin !ultra/!fast 算力分层、OpenAI workspace agents 免费期 7/6 收尾转计费、Kimi 高速版"6x 速度 2x 价格"。Agent 边际成本（推理）远高于传统 SaaS，定价必须挂钩价值/成本——这是区别于 SaaS 的根本拐点。
- **护城河从"模型"转向"专有数据+安全合规"**：Harvey（判例法/DeepJudge 机构知识）、Glean（企业知识图谱）、Sierra（FedRAMP High）不约而同强调模型可替换、数据与合规才是壁垒。供应链安全（Replit Package Firewall 默认拦截恶意包）成为企业 Agent 准入门槛。

---

## 💻 编码 Agent / CLI 板块深度

### 1. Claude Code（Anthropic）— 🔴 最高优先级

- **本周动态**：本周 Claude Code 进入高频迭代节奏，6 月 12 日单日连发三个版本 **2.1.174 / 2.1.175 / 2.1.176**（GitHub release 时间戳 12 Jun 01:16 / 04:23 / 21:53，CHANGELOG 于 13 Jun 01:25 同步），均在覆盖窗口内。这一波更新的主线不是堆功能，而是**企业治理与后台 Agent（background agents）稳定性**两条线。
  ① **企业模型治理收紧**：2.1.175 新增 `enforceAvailableModels` 托管设置——开启后 `availableModels` 白名单同时约束 Default 模型，用户/项目设置无法再"放宽"管理员设定的白名单；2.1.176 进一步堵死了通过 `ANTHROPIC_DEFAULT_*_MODEL` 环境变量把别名模型重定向到被封禁模型的漏洞，`/fast` 在会触发越界切换时拒绝切换。这是典型的"防止终端用户绕过 IT 管控"的企业级硬化。
  ② **新模型 Fable 5 接入**：changelog 多处提到 Fable 5（Mythos-class 模型），2.1.176 修复了"组织未启用 Opus 4.8 时 auto 模式在 Fable 5 上失败"——分类器现在回退到最佳可用 Opus；并修了"Fable 5 开始消耗 usage credits"横幅在企业账户误显。说明 Anthropic 正把新一代模型逐步铺进 Claude Code 调度链。
  ③ **后台 Agent（claude agents / background sessions）**：本周大量修复围绕后台会话——`/bg` 中途无续接内容却永远显示 "Working"、按 PR URL 搜索后台 agent、Windows 后台服务守护进程、跨自动更新的版本偏移（version-skew）提示、云会话长时间空闲后认证失败等。**判断**：Anthropic 正把 Claude Code 从"交互式 CLI"推向"可长期托管、可远程控制（Remote Control web/mobile）的后台编码 Agent 平台"，这是与 Codex cloud、Devin 正面竞争的战场。
- **关键数据**：
  - 版本 2.1.174（June 12, 2026）、2.1.175（June 12, 2026）、2.1.176（June 12, 2026），CHANGELOG 同步 13 Jun 01:25 — 来源：https://code.claude.com/docs/en/changelog ｜ https://github.com/anthropics/claude-code/releases （读取于 2026-06-15）
  - 新模型代号：Claude Fable 5（Mythos-class）、Opus 4.8 — 来源：同上 changelog
- **原文链接**：
  - https://code.claude.com/docs/en/changelog
  - https://github.com/anthropics/claude-code/releases
- **影响判断**：本周三连发几乎全是"企业治理 + 后台 Agent 可靠性"，几乎没有面向个人开发者的炫技功能。信号很明确：**Claude Code 的产品重心已从"个人 CLI 工具"转向"企业可托管的 Agent 基础设施"**——模型白名单强约束、托管设置不可被用户放宽，是冲着大客户合规采购去的。后台 Agent 的密集修复则说明 async/长时运行编码 Agent 已是主流形态，2026 年编码 Agent 的竞争焦点是"无人值守可靠性"而非单次补全质量。

---

### 2. OpenAI Codex / Codex CLI — 🔴 老板点名必覆盖

- **本周动态**：Codex 本周是 A 组里发布密度最高的对象，呈现"全平台齐头并进"态势：
  ① **Codex CLI 0.139.0（2026-06-09 正式版）**：`npm install -g @openai/codex@0.139.0`。重点是 **Code mode 现在能直接调用独立 web search**（包括从嵌套 JavaScript 工具调用中），并接收纯文本搜索结果（PR #26719）；工具与 connector 的 input schema 现在保留 `oneOf`/`allOf`，大 schema 压缩时保留更多浅层结构，**显著改善对更丰富 MCP 工具的兼容性**（#24118、#27084）；`codex doctor` 报告增加编辑器/pager 环境细节（JSON 输出脱敏，#27081）；plugin marketplace 自动化增强（`--json` 含 marketplace 来源）。
  ② **CLI 进入 0.140.0-alpha 高频预发**：GitHub releases 显示 6/11–6/14 窗口内连续滚出 alpha.8 → alpha.19（14 Jun 02:03 为 alpha.19），可见 rusty_v8 升级到 149.2.0（#26464）、release 构建恢复独立符号归档改善崩溃符号化（#26202）、`/app` 命令可把当前 CLI 线程交接到 macOS/Windows 上的 **Codex Desktop**。
  ③ **Codex app 26.609（2026-06-11）/ 26.608（2026-06-09）**：新增 **Browser use 的 Developer mode**（受控 Chrome DevTools Protocol 访问，做性能 profiling 和深度网络/console 调试），Browser use 通过 CDP+DOM 快照优化**提速最高 2 倍**；新增 `/init` 命令；为 EEA/UK/瑞士以外的企业用户开放 **Computer Use**；新增 Plus/Pro 的 rate-limit reset banking 与推荐邀请机制。
  ④ **抢夺竞品用户**：26.608 新增 **"Migrate to Codex" 流程，支持从 Claude Code 和 Claude Cowork 导入配置**——直接对 Anthropic 下手挖墙脚。
- **关键数据**：
  - Codex CLI 0.139.0 — 2026-06-09 — 来源：https://developers.openai.com/codex/changelog （读取于 2026-06-15）
  - Codex CLI 0.140.0-alpha.19 — 14 Jun 02:03 — 来源：https://github.com/openai/codex/releases （读取于 2026-06-15）
  - Codex app 26.609（2026-06-11）、26.608（2026-06-09）；ChatGPT for iOS 1.2026.153（2026-06-09）— 来源：同 changelog
  - GitHub openai/codex：Star 91k，Fork 13.4k — 来源：搜索结果（github.com，3 days ago）
- **原文链接**：
  - https://developers.openai.com/codex/changelog
  - https://github.com/openai/codex/releases
- **影响判断**：Codex 这周三个信号最值得划重点：(1) **Browser use + Computer Use 全面铺开**，OpenAI 把编码 Agent 升级为"会用浏览器和电脑的通用任务 Agent"，超出纯代码补全范畴；(2) **MCP 兼容性深耕**（保留 oneOf/allOf）说明 MCP 已是 Codex 的核心扩展协议，与 Claude Code 生态正面竞争；(3) **"Migrate to Codex" 一键迁移 Claude Code/Cowork** 是赤裸裸的存量用户争夺战——编码 Agent 市场已从"增量获客"进入"互相挖墙脚"的白热化阶段。CLI 一天滚多个 alpha，反映其工程节奏远快于季度发版的传统软件。

---

### 3. OpenClaw（Agent OS）— 🔴 老板点名必覆盖

- **本周动态**：OpenClaw 在覆盖窗口内发布 **2026.6.8**（GitHub release 标注 14 Jun 22:45，Pre-release，正好落在周日窗口末尾）。本期主线是**渠道交付质量 + Agent/Gateway 恢复韧性 + Skill Workshop 治理化**三条：
  ① **渠道（channels）更稳更富**：Telegram 现在能发送带表格、列表、可展开引用块的结构化富文本，保留 prompt 的 CLI 后端交付，更安全的富媒体边界；WhatsApp 现在遵守配置的 ACP 绑定（#92679、#84082、#89421、#92513）。
  ② **Agent/Gateway 恢复**：围绕账户范围 DM 发送、生成媒体完成、auto-reply 的 message-tool 最终回复、重启关闭中止、**yielded 子 Agent 暂停**、trusted 子 Agent thinking 覆盖回退、yielded cron 媒体、心跳去重、会话身份提示等做了一大批恢复性修复（#92788、#91246、#92879 等）——几乎全是"长时运行/多 Agent 编排不掉链子"的工程硬化。
  ③ **Provider/模型扩展**：新增 **GLM-5.2、Claude Haiku 4.5** 目录行，OpenRouter / Google Vertex provider 前缀归一化，托管 SecretRef 认证，OAuth 图像默认经 Codex 路由等。
  ④ **Skill Workshop 治理流程成型**（近期 releasebot 主题）：proposal 列表、today actions、修订交接、可搜索文件预览、review 状态、本地化——`skill_workshop` agent 工具可经受控 review 流程 apply/reject/quarantine 提案；并把 Tokenjuice、GitHub Copilot agent runtime 外置为官方插件（@openclaw/tokenjuice、@openclaw/copilot）。
- **关键数据**：
  - OpenClaw 2026.6.8（Pre-release，14 Jun 22:45）— 来源：https://github.com/openclaw/openclaw/releases （读取于 2026-06-15）
  - 新增模型目录：GLM-5.2、Claude Haiku 4.5 — 来源：同上
  - 背景（非本周）：2026.5.3（文件传输/`/steer`/`/side`）、2026.2.15 — 来源：releasebot.io/updates/openclaw、社区帖
- **原文链接**：
  - https://github.com/openclaw/openclaw/releases
  - https://releasebot.io/updates/openclaw
- **影响判断**：OpenClaw 本周的工程重心落在"**多 Agent 编排 + 子 Agent yield/恢复**"和"**Skill Workshop 受控治理**"上——这正是把"个人玩具 Agent"升级为"可托管、可审计、可协作的 Agent OS"的关键路径。把 Copilot/Tokenjuice 外置为官方插件，反映其走"内核精简 + 插件市场（ClawHub）"的平台化路线。GLM-5.2、Haiku 4.5 即时上架说明它定位"模型中立的编排层"，这是与单厂商绑定的 Claude Code/Codex 形成差异化的根本。

---

### 4. Hermes Agent（Nous Research，自进化）— 🔴 老板点名必覆盖

- **本周动态**：**本周无新版本发布**。Hermes Agent 最近一个正式版是 **v0.16.0（v2026.6.5），发布于 2026-06-05**——比本覆盖窗口（6/08 起）早 3 天，按铁律仅作背景。该版"The Surface Release"体量惊人：自 v0.15.2 起 **874 commits / 542 merged PRs / 1962 文件变更 / 20.5 万行新增 / 17 万社区贡献者中 170 位参与**，核心是**全新原生桌面应用 Hermes Desktop**（Electron，macOS/Linux/Windows，一键安装、应用内自更新、拖拽文件、状态栏内联模型选择器、多 profile 并发会话、简体中文全量翻译、OAuth/账密连接远程 gateway），web dashboard 新增浏览器管理面板，并带一轮安全修复（CVE-2026-48710 Starlette pin、SSRF off-loop 加固、子进程凭据剥离）。（以上均为"背景，非本周"）
  关于"自进化"：社区项目 `NousResearch/hermes-agent-self-evolution`（用 DSPy + GEPA 基于真实执行 trace 自动进化 SKILL.md，Phase 1 已实现、Phase 2/3 规划中）本周无明确更新；Reddit 有用户反馈"该 repo 已停滞约一个月"（未本周动态，需谨慎）。
- **关键数据**：
  - Hermes Agent v0.16.0（v2026.6.5）— 2026-06-05（背景，非本周）— 来源：https://github.com/NousResearch/hermes-agent/releases （读取于 2026-06-15）
  - 自进化引擎 DSPy + GEPA（Genetic-Pareto Prompt Evolution），MIT 许可 — 来源：https://github.com/NousResearch/hermes-agent-self-evolution
  - GitHub Stars：约 160,175（2026 年 2 月发布后约 12 周）— 来源：LinkedIn 文（二手，单一来源，需交叉验证；未达 ≥2 独立来源标准）
- **原文链接**：
  - https://github.com/NousResearch/hermes-agent/releases
  - https://github.com/NousResearch/hermes-agent-self-evolution
- **影响判断**：Hermes 本周静默，但 v0.16.0（6/5）的"桌面化 + 一周内 100 PR 造出原生 App"反映其**靠超高速社区贡献（单周百级 PR）拉开身位**——这是开源 Agent 的独特护城河。自进化（DSPy+GEPA 读 trace 自动改 skill）方向虽性感，但社区反馈核心 self-evolution repo 停滞，说明"真·自进化"距离生产可用仍有距离，目前更多是 skill 文件层面的提示词进化，而非模型/架构自改。

---

### 5. Cursor（Anysphere）

- **本周动态**：本周 Cursor 的核心动作是发布 **Auto-review（自动审查）**——一套用"专门的分类器 Agent（classifier agent）"治理 Agent 自主性的机制（releasebot 标注 3 天前，落在窗口内）。官方博客原文要点：把 Agent 自主性"从开关变成旋钮（dial 而非 switch）"——低风险时让 Agent 自由行动，跨越有意义的边界时才放慢。技术实现上：(1) 用一个**小模型分类器**在每个工具调用执行前、在 Agent 循环内对动作做上下文审查，核心规则是"安全风险低则宽松、风险高则谨慎"；(2) 分类器是 **agentic 的**——像 `python script.py` 这种命令是否安全取决于文件内容，分类器可用 ReadFile/Grep/Glob/ListDir 检查工作区后再判断；(3) 为避免额外往返延迟，分类器**不走独立 endpoint，而是在父 Agent 的同一 RPC 流里运行**（架构类似 subagent）；(4) 被 block 时返回解释给父 Agent，父 Agent 常能据此自行选更安全路径而不打断用户。一个反直觉发现：低推理模型不一定更快——理解不了策略时反而耗更多 token 找出更差答案，最优是"够用推理的小模型"。
  **商业侧（窗口内/邻近）**：Cursor 调整定价，对 Teams/Individual 计划引入 usage-based billing，新客户立即生效、续费客户在 **2026-07-01 起的计费周期**生效；另有资料提"2026-06-08 后首次续费生效"并暴露可配置 effort level。
- **关键数据**：
  - Auto-review 发布（"this week"，releasebot 3 天前）— 来源：https://releasebot.io/updates/cursor （读取于 2026-06-15）
  - 定价：usage-based billing，新客户即时 / 续费客户 2026-07-01 起计费周期生效 — 来源：同上 releasebot
  - 估值/营收（背景，二手）：估值约 $60B；ARR 路径 $100M(2025-01)→$500M(2025-06)→$1B(2025末)→早 2026 报道 >$3B — 来源：tech-insider.org、blog.mean.ceo（二手媒体，需谨慎，未拿到一手财报）
- **原文链接**：
  - https://releasebot.io/updates/cursor
- **影响判断**：Auto-review 是本周 A 组**最具技术含量的单点创新**：它把"Agent 安全审批"从烦人的"每步确认"升级为"上下文感知的风险旋钮"，直击长时运行 Agent 的核心痛点——审批疲劳（approval fatigue）。用"循环内小分类器 Agent + 同 RPC 流"避免延迟、用"返回解释让父 Agent 自我纠偏"而非打断用户，这套设计很可能成为行业范式。结合 Claude Code 本周的"企业治理硬化"，可见 2026 年编码 Agent 的竞争主轴已是**"自主性 × 安全/治理"的平衡艺术**，而非单纯能力堆叠。

---

### 6. Cognition（Devin / Windsurf）

- **本周动态**：**本周无重大新发布**。Cognition 最近的重磅是 **2026-06-02 将 Windsurf 正式更名/重构为 Devin Desktop**（比窗口早 6 天，背景）：以 Windsurf 的 IDE 为底座，推出"管理所有 Agent 的指挥中心（Agent Command Center）"，作为标准 OTA 更新静默推送——用户 6/2 后重启编辑器即已在跑 Devin Desktop。最关键的架构信号：**Devin Desktop 支持开放的 ACP 协议**，让 Codex、Claude Agent、OpenCode 及自研 Agent 在共享 Kanban 工作区里并排运行（以上为"背景，非本周"）。本覆盖窗口内未检索到 Cognition/Devin 的一手新版本或公告。
- **关键数据**：
  - Windsurf → Devin Desktop 更名：2026-06-02（背景，非本周）— 来源：https://devin.ai/blog/windsurf-is-now-devin-desktop/ ｜ https://cognition.ai/blog/devin-in-windsurf
  - 支持 ACP 协议，多 Agent（Codex/Claude Agent/OpenCode/自研）共享 Kanban — 来源：codingwithai.com、chatforest.com（二手，需以官方博客交叉验证）
- **原文链接**：
  - https://devin.ai/blog/windsurf-is-now-devin-desktop/
  - https://cognition.ai/blog/devin-in-windsurf
- **影响判断**：尽管本周静默，Devin Desktop（6/2）的战略意义巨大：Cognition 不再把自己定位成"又一个编码 Agent"，而是**"多 Agent 的指挥中心/操作系统"**——用 ACP 开放协议主动拥抱竞品（让 Codex、Claude Agent 在自家 IDE 里跑），赌的是"编排层"而非"单 Agent 能力"的未来。这与 Cursor 的"多模型公司"、OpenClaw 的"Agent OS"思路殊途同归：2026 年的拐点信号是**编码 Agent 正在分化为"底层 Agent 引擎"与"上层编排/指挥层"两个战场**。

---

### 7. OpenCode

- **本周动态**：OpenCode（仓库 `anomalyco/opencode`，原 sst/opencode 已重定向）本周在覆盖窗口内连续滚动发布多个 Immutable release（GitHub 时间戳 14 Jun 18:49、13 Jun 22:39、13 Jun 19:59 等，均在窗内）。本周主线是 **MCP 协议兼容性 + ACP 集成 + 多端（Core/TUI/Desktop/SDK）打磨**：
  ① **MCP 深耕**：MCP servers 现在能接收当前 workspace 作为 client root；通过声明 OpenCode 支持的 client capabilities 提升 MCP server 兼容性；恢复过期的 MCP session（而非让 MCP 工具断连）、清理已关闭的 MCP client 避免陈旧连接残留、以可读形式返回结构化 MCP 工具输出；MCP debug 用上 SDK 最新协议版本。
  ② **ACP（Agent Client Protocol）**：ACP shell 工具调用现在从一开始就显示命令和工作目录——呼应 Cognition Devin Desktop 用 ACP 做多 Agent 编排的趋势，OpenCode 作为 ACP 生态的开放 Agent 一员在补齐体验。
  ③ **Provider/工程**：新增 Snowflake Cortex provider 的外部浏览器 OAuth（社区 PR #31700）；SDK 在集成变化时刷新模型/provider 可用性；修复 `$ARGUMENTS` 命令重复注入文件内容（#31245）等。Desktop 端刷新 oc-2 配色、改善终端 resize。
- **关键数据**：
  - 窗口内多个 Immutable release：14 Jun 18:49（2026-06-14T18:49:10Z）、13 Jun 22:39、13 Jun 19:59 — 来源：https://github.com/anomalyco/opencode/releases （读取于 2026-06-15）
  - 版本约 v1.17.4（June 2026，二手）— 来源：developersdigest.tech（二手，需谨慎）
  - GitHub Stars 约 160,000；月活开发者约 750 万；用 Go 构建（SST 团队）；据称 2026 年初 LogRocket 榜超越 Cursor 登顶 — 来源：byteiota.com、developersdigest.tech（均二手，未拿一手数据，需交叉验证）
- **原文链接**：
  - https://github.com/anomalyco/opencode/releases
  - https://opencode.ai/
- **影响判断**：OpenCode 本周没有炫技大功能，全是 MCP/ACP 协议兼容与多端打磨——这恰恰是其战略价值所在：作为**模型中立、终端原生的开源编码 Agent**，它把宝押在"开放协议互操作"（MCP 接工具、ACP 接编排层）。在 Codex/Claude Code 走"单厂商垂直整合"的同时，OpenCode + OpenClaw + Devin Desktop（ACP）正形成一个**"开放协议互联"阵营**。其 160K Stars / 750 万月活（若属实）说明开源终端 Agent 的群众基础极厚，是不可忽视的第三极。

---

## 🔭 本组洞察（编码 Agent / CLI 赛道）

**1. 主轴已从"能力"转向"自主性 × 治理"的平衡。** 本周最硬核的两个创新都不是"更会写代码"，而是"如何安全地让 Agent 少打扰人":Cursor 的 **Auto-review**（循环内小分类器 Agent，把审批从开关变旋钮）、Claude Code 的 **enforceAvailableModels 企业治理硬化**。当 Agent 进入长时/无人值守运行，"审批疲劳"与"合规管控"成了真痛点，谁解得好谁赢企业单。

**2. 形态拐点：从"交互式 CLI"→"可托管的后台 Agent 平台 / 多 Agent 指挥中心"。** Claude Code 本周几乎全在修 background agents；OpenClaw 在修 yielded 子 Agent / 多 Agent 编排恢复；Cognition 把 Windsurf 重构成 **Devin Desktop（Agent Command Center）**。单个 CLI 工具正在长成"管理一群 Agent 的操作系统"。

**3. 两大阵营成形：垂直整合 vs 开放协议互联。**
- **垂直整合派**（OpenAI Codex、Anthropic Claude Code）：单厂商模型+工具+云深度绑定，Codex 甚至做 "Migrate from Claude Code" 直接挖墙脚。
- **开放协议互联派**（OpenClaw、OpenCode、Cognition Devin Desktop）：靠 **MCP（接工具）+ ACP（接编排）** 做模型中立、跨 Agent 互操作。本周 OpenCode 和 OpenClaw 都在猛补 MCP/ACP 兼容，Devin Desktop 用 ACP 让 Codex/Claude Agent 在自家跑——这是赌"编排层"价值高于"单 Agent 能力"。

**4. 工程节奏的代差。** Codex CLI 一天滚多个 0.140-alpha、Claude Code 单日连发 3 版、OpenCode/OpenClaw 每日级 release——头部编码 Agent 已是"日更级"持续交付，传统季度发版的软件公司在节奏上被彻底碾压。

**5. 自进化仍是叙事 > 落地。** Hermes 的 DSPy+GEPA 自进化方向性感，但社区反馈核心 self-evolution repo 已停滞约一月，目前能做的仅是 skill 文件层面的提示词进化，远非"模型/架构自改"。"真·自进化 Agent"本周无实质进展，需持续观察、勿被营销话术带节奏。
-e 
---

## 🧩 通用 / 自主 Agent 框架板块深度

### 1. LangChain / LangGraph

- **本周动态**：本周 LangChain 生态进入"快速迭代+安全修补"双线状态。①**版本发布**：LangGraph 核心包于 6 月 12 日发布 **v1.2.5**（PR #8062），本周还连发 CLI v0.4.28（6/10）、v0.4.29（6/11，新增 dev server HTTPS 证书支持 PR #8031）；底层把 Python 类型检查从 mypy 迁移到 ty（PR #8002），并修复了空 thread 上 deltaChannel 的 updateState bug（#8011）。LangChain 主仓同期在 1.3.8 / langchain-core 1.4.6 节奏上滚动发布。②**架构内容**：官方博客本周高频输出 Deep Agents 路线——6/12《Building Box AI: How an Enterprise Content Platform Went AI-Native with Deep Agents》（Box 企业内容平台基于 Deep Agents 转型案例）、6/12《How to Choose the Right Sandbox for Your Agent》、6/10《The Missing Link Between Agents and Applications》（Open Source）、6/10 工程长文《Full Text Search in SmithDB: Designing an Inverted Index for Object Storage》（15 min，揭示其自研对象存储倒排索引）。6/5《Give your agent its own computer》（LangSmith 给 agent 配专属计算环境）。③**安全事件**：本周曝出多个 CVE（含 CVE-2026-34070），需升级 langchain-core 到 1.2.22 修复（详见下条核验）。④判断：LangChain 战略重心已从"链/图编排"明确转向 **Deep Agents + 企业落地案例 + LangSmith 商业化闭环**，博客几乎每篇都挂企业客户（Box/Rippling/Harmonic/Lyft/Benchling/Harvey），是典型"开源引流→LangSmith 付费"打法。

- **关键数据**：
  - LangGraph v1.2.5，2026-06-12 发布，https://github.com/langchain-ai/langgraph/releases
  - LangGraph CLI v0.4.29，2026-06-11；CLI v0.4.28，2026-06-10，同上
  - 历史背景（非本周）：100K+ GitHub stars、累计 $35M 融资（来源 taskade 博客，待核）
  - 三高危 CVE（已核验，来源 techjuice.pk，Cyera 研究员 Vladimir Tokarev 披露）：CVE-2026-34070（LangChain 路径穿越，任意文件读取）修复版 langchain-core 1.2.22；CVE-2025-68664（反序列化→prompt injection 泄露 API key/环境密钥）修复版 0.3.81 与 1.2.5；CVE-2025-67644（LangGraph SQLite checkpoint SQL 注入）修复版 langgraph-checkpoint-sqlite 3.0.1。影响"每周 6000 万开发者"，沿依赖网络向下游百余库扩散。https://www.techjuice.pk/langchain-framework-hit-with-critical-cves/

- **原文链接**：
  - https://github.com/langchain-ai/langgraph/releases
  - https://www.langchain.com/blog

- **影响判断**：LangGraph 已是多 Agent 编排事实标准之一，v1.x 进入高频补丁期说明其在生产环境承压加大（fault tolerance、checkpoint、streaming 全在改）。Deep Agents 叙事+密集企业案例显示 LangChain 正卡位"企业 AI-native 改造"中台层；但本周 CVE 集中爆发也暴露其作为基础设施的安全攻击面正快速扩大，是值得警惕的拐点信号。

---

### 2. Microsoft AutoGen

- **本周动态**：**本周无重大公开发布动态**。直查 GitHub releases 页，AutoGen 最新稳定版仍停留在 **python-v0.7.5（2026-09-30 之前的发布节奏，最新条目为 9/30）**——注：releases 页顶部条目时间戳显示为 9 月，明显早于本研究周，本周（6/8–6/14）无新 tag。近期版本主线（0.7.x）的方向包括：GPT-5 模型 reasoning_effort 参数支持（#7054）、Anthropic thinking 模式（#7002）、GraphFlow 循环检测修复（#7026）、默认强制 DockerCommandLineCodeExecutor 安全沙箱（#7035/#6684）、RedisMemory 线性记忆（#6972）。判断：AutoGen 在微软内部已与 Semantic Kernel 走"融合/Agent Framework 统一"路线，社区版 release 节奏明显放缓，本周静默符合其"重大更新往 Microsoft Agent Framework 收口"的战略趋势。需后续核验微软是否有官方博客层面的 Agent Framework 公告。

- **关键数据**：
  - 最新可见稳定版 python-v0.7.5（GitHub releases 顶部），本周无新版本
  - 来源 https://github.com/microsoft/autogen/releases

- **原文链接**：
  - https://github.com/microsoft/autogen/releases

- **影响判断**：AutoGen 社区仓库本周静默，与 LangGraph/CrewAI 的高频迭代形成鲜明对比，反映微软已把 Agent 框架战略重心迁移到统一的 Microsoft Agent Framework（AutoGen + Semantic Kernel 合流），开源 AutoGen 逐渐沦为"实验室前哨"。对企业用户是信号：押注 AutoGen 需关注微软官方收口路线，避免 API 断裂风险。

---

### 3. CrewAI

- **本周动态**：本周 CrewAI 节奏最密集——6 月 11 日正式发布 **v1.14.7**（稳定版），本周内连推 4 个 alpha/rc 预发布（v1.14.7a2 6/9、a3 6/9、a4 6/11、rc1 6/11）。核心更新围绕**架构重构与可插拔后端**：①**可插拔默认后端**——memory/knowledge/rag/flow 全部支持替换默认后端（pluggable default backends），这是架构解耦的重大动作；②**Flow 引擎重构**——把 flow.py 拆分为 DSL/definition/runtime 三层，flow 条件评估改为无状态（stateless per event），@listen/@router/@start 运行时改为从 FlowDefinition 读取；③**对话式 Flow（chat API）**——新增 conversational flows 的 chat API 与 handle_turn，并支持对话流 traces；④**企业集成**——新增原生 Snowflake Cortex LLM provider、Databricks 集成指南、NVIDIA Nemotron LLM 指南；⑤**安全**——解决 aiohttp/docling/docling-core 的 pip-audit CVE。判断：CrewAI 这轮是典型"从玩具框架走向企业级平台"的架构补课——可插拔后端+无状态 flow+对话 API，瞄准生产级多 Agent 工作流和 Agent Control Plane（ACP）商业化。

- **关键数据**：
  - CrewAI v1.14.7 稳定版，2026-06-11 发布，https://github.com/crewAIInc/crewAI/releases
  - 预发布：v1.14.7a3（6/9）、a4（6/11）、rc1（6/11），同上
  - 新增 Snowflake Cortex LLM provider、Databricks 集成（v1.14.7）

- **原文链接**：
  - https://github.com/crewAIInc/crewAI/releases

- **影响判断**：CrewAI 本周的"可插拔后端+Flow 三层解耦+对话式 Flow"组合拳，标志它正从"快速搭多 Agent demo"转向"可被企业改造、可观测、可控制平面化"的生产平台。原生接 Snowflake/Databricks 说明其商业化锚点是数据仓库生态里的企业 Agent，是 LangGraph 企业路线的直接竞争者。Agent Control Plane（ACP Beta）是其与 LangSmith 对标的关键变现卡位。

---

### 4. Google ADK（Agent Development Kit）

- **本周动态**：本周 ADK Python 发布 **v1.35.0（2026-06-10）**，是本周区间内的真实发布。该版本聚焦 **Gemini Live 3.1 多模态实时能力**：新增对 Gemini Live 3.1 模型输入转写（input transcription）的差异化处理（#6045），修复 Gemini 3.1 Live 协议 1007 错误、grounding metadata 静默丢失、live session 重连后透明配置保留等问题。背景（非本周但紧邻）：6/4 发布了重磅 **v2.2.0**，含两处 BREAKING CHANGE——①LlmAgent 默认模型从 gemini-2.5-flash 改为 **gemini-3-flash-preview**（为 2026-10-16 gemini-2.5-flash 停服铺路）；②支持 GenAI SDK v2.0.0，术语从 "turns" 改为 "steps"。v2.2.0 还引入 AutoTracingPlugin（OpenTelemetry 自动埋点）、RubricBasedMultiTurnTrajectoryEvaluator（基于评分标准的多轮轨迹评估器）、原生 OTel gen_ai.client.* 指标、A2A 协议中区分 input-required/auth-required，并修复 CVE-2026-48710（starlette/fastapi）及 GCS skill 解压的 Zip Slip 路径穿越漏洞。判断：ADK 同时维护 1.x（稳定/Gemini Live 实时线）和 2.x（GA 多 Agent 工作流引擎线）双轨，本周 1.35.0 偏实时多模态补丁，是 Google 把 Agent 能力与 Gemini 3.1 模型迭代深度绑定的体现。

- **关键数据**：
  - ADK Python v1.35.0，2026-06-10 发布，https://github.com/google/adk-python/releases
  - 背景：v2.2.0（2026-06-04，非本周但相邻）；v2.0.0 GA（2026-05-19）
  - 默认模型改为 gemini-3-flash-preview（v2.2.0 BREAKING）
  - 修复 CVE-2026-48710（starlette/fastapi，v2.2.0）

- **原文链接**：
  - https://github.com/google/adk-python/releases

- **影响判断**：ADK 把默认模型切到 gemini-3-flash-preview 是强信号——Google 用框架默认值"推"开发者上 Gemini 3 系列，框架成为模型分发渠道。A2A 协议持续完善（input/auth-required 区分）显示 Google 在押注跨 Agent 互操作标准。OTel 原生指标+Rubric 评估器表明 ADK 正补齐企业级可观测与评估短板，直接对标 LangSmith。

---

### 5. OpenAI Agents SDK / Swarm

- **本周动态**：本周 OpenAI Agents SDK（Python）发布 **v0.17.5（2026-06-11）**，属本周真实发布但以修复+文档为主、无重磅特性。主要变更：暴露 sandbox 错误的可重试性（retryability，#3581）、把 tool-end hook 结果类型修正为 object（#3518）、SpeechGroupSpanData __slots__ 用 tuple 形式（#3534）、Modal sandbox extra 升级到 1.4.3（#3538）；文档侧新增 MongoDB session 示例、把 Latitude 加入外部 tracing 处理器列表，并大幅补测试覆盖率（_openai_retry 从 77%→95%）。背景：前序版本（0.17.x，5 月）已密集投入 **Sandboxes（沙箱执行）、Realtime Agents（实时语音）、Sessions（多后端会话存储 SQLite/Redis/MongoDB）、Tracing** 四大方向。判断：Agents SDK 本周节奏偏"稳态打磨"，0.17.x 长期停留在 0.x 说明 OpenAI 仍未给该 SDK 打 1.0 稳定承诺；其工程重心是把 sandbox+realtime+session 这套"自主执行底座"做扎实，配合 Responses API 与内置工具生态。注：Swarm 已是被 Agents SDK 取代的实验项目，本周无独立动态。

- **关键数据**：
  - OpenAI Agents SDK (Python) v0.17.5，2026-06-11 发布，https://github.com/openai/openai-agents-python/releases
  - 前序 v0.17.4（2026-05-26）、v0.17.3（2026-05-19）
  - 测试覆盖率 _openai_retry 77%→95%（#3544）

- **原文链接**：
  - https://github.com/openai/openai-agents-python/releases

- **影响判断**：OpenAI Agents SDK 仍在 0.x 高频小版本迭代，沙箱可重试性、realtime、多后端 session 是其差异化护城河——它不做"框架霸权"，而是把自家 Responses API/内置工具/沙箱执行打包成最低摩擦的官方自主 Agent 底座。对开发者而言，绑定 OpenAI 模型生态是隐性成本。Swarm 彻底退场印证"轻量多 Agent 教学项目→官方生产 SDK"的收口路径。

---

### 6. Dify

- **本周动态**：**本周无新版本发布**。直查 GitHub releases，Dify 最新版本为 **v1.14.2（2026-05-19）**，本研究周（6/8–6/14）无新 tag（v1.14.2 为背景，非本周）。该版本主线方向（供背景参考）：①**安全加固**——租户级敏感端点隔离（app trace-config / FilePreview 文本提取）、内置工具凭证更新限制为 workspace admin/owner、修复 LiteLLM 的 CVE-2026-42208（v1.14.1）、SECRET_KEY 自动生成持久化、/threads 与 /db-pool-stat 内部指标端点防未授权暴露、修复 GET /account/avatar 的 IDOR；②**Workflow/HITL**——HITL 工作流 resume 后恢复 tracing、暴露 Human-in-the-loop 选定动作值、Question Classifier 支持可编辑类标签；③**RAG/知识库**——允许 LLM 节点访问检索到的知识文件、doc_id 跨 provider 去重、跳过空文档再向量化；④**UI 平台迁移**——大规模迁移到 @langgenius/dify-ui 设计系统。判断：作为最热门的开源 LLM 应用开发平台之一，Dify 本周静默，处于 1.14.x 补丁周期之间，工程重心明显是企业级安全合规（多租户隔离、CVE 修复）+ Workflow 生产可靠性，符合其面向企业自部署市场的商业化路线。

- **关键数据**：
  - Dify 最新版 v1.14.2，2026-05-19 发布（非本周），https://github.com/langgenius/dify/releases
  - 修复 LiteLLM CVE-2026-42208（v1.14.1，GHSA-r75f-5x8p-qvmc）
  - 本周无新 release

- **原文链接**：
  - https://github.com/langgenius/dify/releases

- **影响判断**：Dify 的迭代节奏（约每 2-4 周一个 patch）较 LangGraph/CrewAI 的周级节奏更慢，但安全加固密度极高（每版多条 CVE/租户隔离修复），反映其用户主体是企业自托管场景，安全合规优先级高于新特性。它走的是"低代码可视化 Workflow + 企业自部署"路线，与 LangGraph/CrewAI 的"代码框架"形成差异化竞争。本周无动态不代表停滞，需关注下个 1.14.x/1.15 版本。

---

### 7. LlamaIndex Agents

- **本周动态**：**本周未发现明确标注于本周区间内的新发布**。直查 GitHub releases 页（run-llama/llama_index 为 monorepo 统一 Release Notes），可见的最近批量版本条目时间戳为 **2026-03-16**（llama-index-core 0.14.18 / 0.14.17 等），明显早于本研究周；页面未呈现 6/8–6/14 区间的明确新 tag（注：该 monorepo 子包版本众多、release 页渲染聚合，可能存在抓取时未完整展示最新条目的情况，本结论存在不确定性，建议下期用 PyPI 版本时间戳二次核验）。可见的近期 core 更新方向（供背景，非本周）：跨 core/向量后端对齐 text match 过滤（#20883）、修复 chat_engine 在流未完整消费时保留 chat history（#20897）、PydanticOutputParser 保留非 ASCII schema 描述（#21016）、structured_predict() 单字段模型默认值修复（#21025）、正式弃用 Python 3.9（#20956）。判断：LlamaIndex 的 Agent 能力深度绑定其 RAG/数据索引核心，工程重心在数据检索质量与结构化输出可靠性，Agent 编排为其上层封装。

- **关键数据**：
  - GitHub releases 可见最近批量版本时间戳 2026-03-16（llama-index-core 0.14.18，非本周），https://github.com/run-llama/llama_index/releases
  - 本周无明确新 tag（结论含不确定性，待 PyPI 二次核验）

- **原文链接**：
  - https://github.com/run-llama/llama_index/releases

- **影响判断**：LlamaIndex 的差异化护城河始终是"数据→索引→检索"这条 RAG 主线，Agent 只是其在数据之上的编排层。本周无明确公开框架动态，反映其在 Agent 框架军备竞赛中相对低调，更聚焦数据连接与企业 RAG 落地（LlamaCloud 商业化）。在 Deep Agents/多 Agent 编排成为主战场的当下，LlamaIndex 若不强化 Agent 自主性叙事，可能在通用 Agent 框架赛道被 LangGraph/CrewAI 边缘化为"RAG 工具层"。

---

## 📌 本组洞察（通用/自主 Agent 框架赛道趋势）

**1. 迭代节奏分层，强者愈强。** 本周区间内有真实发布的是 LangGraph（1.2.5）、CrewAI（1.14.7）、Google ADK（1.35.0）、OpenAI Agents SDK（0.17.5）四家，均为周级高频迭代；而 AutoGen、Dify、LlamaIndex 本周静默。节奏分层揭示赛道正在分化——头部框架进入"生产承压→高频补丁"阶段，落后者要么收口到母体战略（AutoGen→Microsoft Agent Framework），要么聚焦细分护城河（LlamaIndex→RAG、Dify→企业自部署）。

**2. 主战场已从"能编排"转向"可生产+可观测+可控制平面"。** 本周关键词高度趋同：CrewAI 推可插拔后端+无状态 Flow+Agent Control Plane；LangChain 推 Deep Agents+LangSmith Engine+沙箱；ADK 推 OTel 原生指标+Rubric 评估器；OpenAI 推 sandbox 可重试+多后端 session。所有头部玩家都在补"企业级可观测/评估/控制平面"这门课——这是 2026 年 Agent 框架商业化变现（LangSmith vs Agent Control Plane vs Vertex）的核心战场。

**3. 框架沦为模型分发渠道。** ADK 把 LlmAgent 默认模型直接切到 gemini-3-flash-preview，OpenAI Agents SDK 深绑 Responses API/内置工具，是强信号：大厂的 Agent 框架本质是把开发者"漏斗"进自家模型生态。中立框架（LangGraph/CrewAI）反而强调"model neutrality"（LangChain 6/4 博客《Why Model Neutrality Matters More Than Cloud Neutrality》），形成"中立 vs 锁定"两条路线对峙。

**4. 安全攻击面急剧扩大是被低估的拐点信号。** 本周 LangChain/LangGraph 集中爆 3 个高危 CVE（CVE-2026-34070 路径穿越、CVE-2025-68664 反序列化密钥泄露、CVE-2025-67644 SQLite checkpoint SQL 注入），影响"每周 6000 万开发者"且通过依赖网络向下游百余库扩散；ADK 修 Zip Slip、Dify 持续修租户隔离/IDOR。当 Agent 框架成为连接模型-数据-工具的基础设施，prompt injection + 反序列化 + 路径穿越构成的复合攻击面正成为企业采用的最大隐性风险，安全将是下一阶段框架竞争的硬指标。

**5. MCP/A2A 协议层成为标配。** AutoGen 升级 MCP、ADK 完善 A2A（区分 input/auth-required）、CrewAI 强化 StdioTransport 安全——跨 Agent/跨工具互操作协议（MCP、A2A）已从概念走向各框架基础设施层标配，是 Agent 生态从"孤岛"走向"互联"的底层管道，值得持续追踪谁主导协议标准。
-e 
---

## 🏢 垂直 / 企业 Agent 产品板块深度

### Perplexity（Comet / 搜索 Agent）
- 本周动态：本周 Perplexity 最大的公开动态是 CEO Aravind Srinivas 于 6 月 8 日接受 CNBC 采访，明确表态公司计划在 **2028 年 IPO 上市**，且与 OpenAI、Anthropic、SpaceX 三家近期同期递交上市申请"脱钩"——"Agnostic of these two companies, we were planning for something in 2028, so that still remains the case"。他强调 SpaceX 本周的 IPO 将是 Anthropic/OpenAI 上市的"领先指标"（leading indicator），并认为 AI 前沿模型每进步一次"Perplexity 就更强一次"。原文同时回顾了 Perplexity 的产品与商业图景：估值在去年 9 月 2 亿美元融资后达 **200 亿美元**；其 AI 浏览器 Comet 通过抓取互联网为搜索查询提供对话式回答；今年早些时候推出的通用 Agent "Computer"（数字员工）可接收"建网站/分析数据集/做市场研究"等目标并自主运行数小时乃至数月。需注意本周还有二手报道称"Perplexity 为 Comet 募资 2 亿美元、估值 200 亿"（techtimes/opentools，6 月 8 日），但与官方口径核对后，这实为去年 9 月那轮融资的复述，并非本周新融资，**不计入本周新动态**。技术与商业判断：Perplexity 正把叙事从"搜索引擎"升级为"Agent 经济入口"（浏览器 Comet + 通用 Agent Computer），IPO 时间表的公开是为了在 OpenAI/Anthropic 上市潮中锚定自身节奏、稳住投资者预期。
- 关键数据：估值 200 亿美元（2025-09 融资后，来源 https://www.siliconrepublic.com/business/perplexity-plans-for-2028-ipo-debut-ceo-aravind-srinivas-says ，2026-06-13 读取）；IPO 目标 2028 年（同上，CNBC 原访 2026-06-08）；去年对 Google Chrome 出价 345 亿美元未果（同上）
- 原文链接：https://www.siliconrepublic.com/business/perplexity-plans-for-2028-ipo-debut-ceo-aravind-srinivas-says （转引 CNBC https://www.cnbc.com/2026/06/09/perplexity-ipo-2028-as-anthropic-openai-prepare-listings.html ）
- 影响判断：①IPO 时间表公开化是 Perplexity 在巨头上市潮中"占位"的战略动作，向资本市场释放独立性信号。②"Computer"通用 Agent 标志其从搜索向自主执行延伸，与本组其他企业 Agent 形成正面竞争。③持续的版权诉讼（BBC/NYT/Amazon/Cloudflare 下架爬虫）是其商业模式的结构性风险，IPO 前需化解。

---

### Harvey（法律 Agent）
- 本周动态：Harvey 本周动态密集且为一手官方来源，含金量高。①**6 月 9 日**官方宣布与 **Datasite** 集成（SAN FRANCISCO, June 9, 2026 /PRNewswire/），将实时交易数据（虚拟数据室/M&A 尽调）接入 Harvey 的 AI 交易工作流。②官方博客发布 **"The Brief June 2026"** 产品月报，集中披露大量功能更新：在 Harvey for Word 中提升 redlining（修订）质量与上下文理解、Agentic Word 支持复杂文档格式（缩进控制、脚注编辑）、Word 内置 Writing Styles 与 Model Selector；Playbook 审阅新增 Review Mode、超范围条款标记、Prompt Library；Vault/Assistant 支持 **.pst 邮件归档文件**搜索分析；Review Tables 支持表级指令与单元格级刷新；**Anthropic Opus 4.8 模型已上线** Harvey（横跨 Assistant/Vault/Agent Builder）；与 **DeepJudge** 合作把律所机构知识注入 Harvey；新增美国判例法知识源、印度 SCC Online 集成、160+ 新法律研究数据源；Harvey Mobile 上线 **Android**，支持图片能力与 Magic Prompt；新增 Email Harvey（邮箱内问答）；管理侧新增 Space Admin 角色、CSV 批量上传 500 条 Prompt。技术与商业判断：这是一次"全平台铺开"式月度更新，覆盖起草/审阅/研究/移动/管理全链路，显示 Harvey 正从单点工具走向法律工作操作系统；引入 Opus 4.8 + DeepJudge + 判例法数据，是在强化"机构智能"（institutional intelligence）护城河。
- 关键数据：客户数 >1,000、ARR 1.9 亿美元（截至 2026-01，来源 https://blockchain.news/news/harvey-connector-library-launch ，背景数据）；3 月融资 2 亿美元、估值 110 亿美元（GIC + Sequoia 领投，同上，**背景，非本周**）；Datasite 集成发布日 2026-06-09（https://aijourn.com/... ）
- 原文链接：https://www.harvey.ai/blog/the-brief-june-2026 （2026-06-15 读取全文）；Datasite 集成 https://aijourn.com/harvey-partners-with-datasite-to-bring-live-data-into-ai-powered-deal-workflows/
- 影响判断：①Opus 4.8 首日级别上线 + DeepJudge/判例法数据，说明 Harvey 在"模型+专有法律数据"双轮驱动上持续加码，护城河从工具转向数据与机构知识。②.pst 邮件归档、M&A 数据室集成直指诉讼 e-discovery 与并购尽调两大高价值法律场景，商业化指向明确。③移动端 Android + Email Harvey 降低使用门槛，扩大律所内渗透率。

---

### Replit Agent
- 本周动态：Replit 于 **6 月 12 日**发布官方 changelog，本周更新明确落在窗口内，且围绕 Agent 的企业化与安全治理展开。①**Agent 自定义（Customization）**：用户现在可在 Workspace Settings > Customization 中设置**自定义指令（custom instructions）**让 Agent 在每个项目都遵循，并创建可复用的**技能（skills）**供 Agent 按需加载——这是把"团队工作方式教给 Agent 一次、处处生效"的能力，对标 Claude/Cursor 的 rules+skills 范式。②**Package Firewall（包防火墙）**：Replit 现在在恶意/被投毒的软件包到达应用前自动拦截，跨主流包管理器检查每一次安装，**默认开启**，且 Agent 会在某个包被拦截时自动调整方案改用更安全的替代——这是供应链安全的实质性防护，直击 AI 自动装包的风险点。③**Canvas 生成媒体支持视觉参考**：生成图片/视频/矢量图时可把画板上已有的帧/便签/图片作为视觉参考（注：ChatGPT Images 2.0 暂不支持上传，需切换到 Nano Banana Pro 等模型）。④幻灯片导入导出提速 3-10 倍，支持 200+ 页大型 deck。⑤**Production Alerts** 安全设置：可单独控制生产告警邮件（正常运行事件、依赖安全漏洞、模型更新），若已发布应用使用过期模型，Replit 还会自动准备一个升级草稿任务供一键审阅。技术与商业判断：本周更新主线是"治理 + 安全 + 企业可控性"，Package Firewall 和 Production Alerts 表明 Replit 正在把 vibe coding 平台向生产级/企业级收敛，降低 AI 自主编码的供应链与运维风险。
- 关键数据：发布日 2026-06-12（来源 https://docs.replit.com/updates/2026/06/12/changelog ，2026-06-15 读取）；幻灯片导出提速 3-10×、支持 200+ 页（同上）；Package Firewall 默认开启（同上）
- 原文链接：https://docs.replit.com/updates/2026/06/12/changelog
- 影响判断：①Package Firewall 是 AI 编码安全的标志性功能——AI Agent 自动装包是供应链攻击新入口，Replit 默认拦截走在行业前面。②Agent Customization（instructions + skills）说明 Agent 编排范式正向"可复用技能库"收敛，与本组 Devin 的 Skills/Playbooks 路线一致。③Production Alerts 自动准备模型升级草稿，体现"Agent 自我运维"雏形。

---

### Devin（Cognition）
- 本周动态：Devin 官方 release notes 在窗口内有两次密集更新（6 月 10、6 月 12），均为一手来源。**6 月 12 日**：①**Session Folders**——侧边栏可把会话分组进命名文件夹，支持拖拽，文件夹为个人私有布局；②**!ultra / !fast 会话中切换**——可直接从 Slack 用 `!ultra` 命令在 Devin Ultra 上启动会话，并在会话中途通过 `!ultra`/`!fast` 切换 Ultra/Fast 模式；③**Marketplace MCP 服务器自定义 OAuth**——需要组织专属 OAuth 客户端凭证的 MCP 服务器现可直接在集成页配置；④Worklog 支持 Markdown 文件预览切换；⑤**企业 Web 搜索开关**——企业管理员可在企业设置中开/关 Devin 的网页搜索能力；⑥更智能的 emoji 反应（仅对显式 sleep/archive 命令加表情）。**6 月 10 日**：①**Devin Review**——PR 推新 commit 时自动取消进行中的 review，PR Review API 新增 `cancelled` 状态；②大段粘贴（10k+ 字符）自动转为附件；③**官方 Figma MCP 集成**上线（旧的非官方集成停用）；④"Sent from Slack/Teams/Linear"来源徽章；⑤IdP 组角色可作首个角色分配；⑥@mentions 渲染为样式化深链。技术与商业判断：本周 Devin 的更新主线是**企业治理 + MCP 生态 + Devin Review 工作流打磨**——!ultra/!fast 模式切换说明其在算力分层（Ultra 强算力 vs Fast 省成本）上做精细化运营；企业 Web 搜索开关、自定义 OAuth、IdP 组角色等密集的企业管控功能，指向其与 Cognizant 合作后的大企业落地需求。
- 关键数据：更新日 2026-06-12、2026-06-10（来源 https://docs.devin.ai/release-notes/overview ，2026-06-15 读取）；官方 Figma MCP 集成（2026-06-10）；Devin 定价约 $500/月（来源 https://www.idlen.io/blog/devin-ai-engineer-review-limits-2026 ，背景）；与 Cognizant 战略合作（2026-01-28，**背景，非本周**，来源 https://investors.cognizant.com/... ）
- 原文链接：https://docs.devin.ai/release-notes/overview
- 影响判断：①!ultra/!fast 模式切换 + 企业级管控（Web 搜索开关、OAuth、IdP）密集落地，是 Devin 从"明星 demo"转向"企业生产工具"的工程信号。②官方 Figma MCP 集成显示 Devin 在打通设计→代码全链路，MCP 生态是其差异化抓手。③Devin Review（PR 自动审查）的持续打磨说明 Cognition 把"AI 代码审查"作为继自主编码后的第二增长曲线。

---

### Manus（通用自主 Agent）
- 本周动态：Manus 本周是地缘政治焦点，动态重大且确凿。据 Bloomberg（6 月 11 日）、CNBC（6 月 12 日）、TechCrunch（6 月 13 日）报道，**Meta 已完成与 Manus 的运营拆分并停止双方数据共享**，朝着解除其 20 亿美元收购迈出关键一步——此举系应北京要求。事件脉络：①2025 年中 Manus 凭 AI agent demo 走红，随后把团队从中国迁至新加坡；②2025 年 12 月 Meta 以 20 亿美元收购 Manus；③2026 年初中国国家发改委（NDRC）以国家安全为由启动监管调查，称该交易构成"不可接受的 AI 人才与技术转移"；④2026 年 4 月 NDRC 命令 Meta 完全解除交易；⑤2026 年 6 月 Meta 切断 Manus 对所有内部系统的访问，全面分离进行中，Manus 创始人正独立募集 **10 亿美元**用于成立中国合资公司（JV）并可能在香港上市。FourWeekMBA 的结构性解读颇具洞察："同一周内出现两道对称的篱笆"——美国 6 月 12 日把 Anthropic Fable 5 模型对外国用户封锁（能力围栏），中国则把 Manus 团队从美国公司手中夺回（人才围栏）。技术与商业判断：Manus 作为"agentic harness layer（智能体编排层）"的代表，本周事件标志 AI Agent 赛道正沿半导体剧本演进——资本密集、国家介入、按司法辖区划界。前沿 AI 正分裂为"美国阵营栈"与"中国阵营栈"两套竞争系统。
- 关键数据：Meta 收购价 20 亿美元（2025-12）；NDRC 4 月勒令解除；6 月完成运营拆分/断数据（来源 https://fourweekmba.com/china-ai-fence-meta-manus-deal-unwind/ ，2026-06-15 读取，转引 Bloomberg 2026-06-11 / CNBC 2026-06-12 / TechCrunch 2026-06-13）；Manus 创始人独立募资 10 亿美元（拟设中国 JV + 港股上市，同上）
- 原文链接：https://fourweekmba.com/china-ai-fence-meta-manus-deal-unwind/ （Bloomberg 原文 https://www.bloomberg.com/news/articles/2026-06-11/... 被反爬拦截，403）；TechCrunch https://techcrunch.com/2026/06/13/meta-reportedly-moves-to-unwind-2b-manus-deal-after-beijings-demand/
- 影响判断：①这是 AI Agent 赛道首例因地缘政治被强制拆解的重大并购，确立"AI 人才=战略资产"的监管先例。②Manus 独立募资 10 亿美元 + 港股上市路径，意味着它将作为"中国阵营"自主 Agent 旗舰重启。③对全球 Agent 创业公司是警示信号：跨境并购退出路径正在被国家安全审查封堵，资本退出逻辑生变。

---

### Sierra（客服 Agent）
- 本周动态：Sierra 本周有两条一手动态 + 一条二手大客户消息。①**6 月 10 日**官方博客宣布与 Knox Systems 合作**获得 FedRAMP High 认证**——这是美国云厂商服务联邦机构的最高安全标准之一。Sierra 强调"成立仅两年多即达成此里程碑，快于多数公司"，意在打开美国联邦政府市场（社保、医保、退伍军人事务、报税、护照等关键交互场景）。博客披露重磅商业数据：**财富 50 强中 40% 的企业**已用 Sierra 转型客户体验；客户含 Vanguard、Rocket Mortgage、Sutter Health；财富 20 强医疗公司 **Cigna 在 8 周内将 agent 投产、患者认证时间缩短 80%**；支持 58 种语言、7×24 全天候。②**6 月 11 日**（Axios 独家，因反爬 403 未读全文）Sierra **进军公用事业（utilities）软件领域**，与 Kraken Technologies 达成合作，Sierra 的 agent 技术将接入 Kraken 系统（已含客户账户、电表、费率等上下文数据）。③6 月 12 日官方博客开启"Discovering what's possible with AI for CX"系列。技术与商业判断：本周 Sierra 的主线是**向高监管/高壁垒垂直市场扩张**——FedRAMP High 打开政府市场，Kraken 合作打开公用事业市场，二者都是"数据敏感+合规要求高"的领域，正是 Sierra "按结果定价 + 安全护栏"模式的最佳适配场景。
- 关键数据：财富 50 强 40% 采用、58 种语言、Cigna 8 周投产/认证时间-80%（来源 https://sierra.ai/blog/certified-fedramp-high ，2026-06-15 读取）；ARR >1.5 亿美元（2026-02 官方"Year two in review"，背景）；估值 >150 亿美元（2026-05 融资，CNBC，**背景，非本周**，来源 https://www.cnbc.com/2026/05/04/bret-taylor-sierra-fundraise-openai.html ）；Kraken 公用事业合作 2026-06-11（Axios，因反爬未读全文）
- 原文链接：https://sierra.ai/blog/certified-fedramp-high ；https://sierra.ai/blog （博客索引，含 6/12、6/10 文章）；https://www.axios.com/2026/06/11/kraken-technologies-sierra-utilities-customer-service-bots （403 未读）
- 影响判断：①FedRAMP High 是客服 Agent 进入政府市场的入场券，Sierra 抢先卡位万亿级公共服务自动化市场。②Kraken/公用事业合作显示 Sierra 从通用客服向"行业垂直 + 已有数据底座"打法演进，降低落地摩擦。③"按结果定价（outcome-based pricing）"在高监管行业更易被采购方接受，是其商业模式护城河。

---

### Glean（企业知识 Agent）
- 本周动态：Glean 本周动态围绕"AI coworker"产品升级与模型生态展开，均为一手来源。①官方博客（约 6 月 10 日，配合"June Drop"）发布**企业内容创作新标准**：在 Canvas 中推出**电子表格（spreadsheets）+ 可刷新交互式工件（refreshable interactive artifacts）**，二者均"扎根于企业知识图谱"。交互式工件是动态可视页面，可汇聚全组织数据、支持实时探查/追问/筛选/结果实时更新，典型用例包括 ROI 计算器、动态任务清单、客户资料表（可一次构建、按需刷新、直接从 Glean 分享）；Canvas 电子表格让普通员工无需分析师介入即可基于公司数据做产品采用分析、营销活动追踪、deal review、客户反馈优先级排序。博客明确"Artifacts 可能采用按量计费（usage-based pricing）"。②LinkedIn（约 6 月 12 日）官方宣布支持 **NVIDIA Nemotron Ultra 3** 开源模型，称其"在完整性等关键指标上达到前沿模型 91% 的性能"，赋予日常企业工作强 agentic 能力。③背景：Glean MCP Gateway 于 6 月 3 日更新（**背景，临近窗口但非本周核心**）。技术与商业判断：Glean 的产品主线是从"企业搜索"升级为"企业 AI 同事（coworker）"——交互式工件 + 电子表格是把"知识检索"延伸到"知识生产与分析"，直接侵入 Excel/BI 工具的腹地；引入 Nemotron Ultra 3 等开源模型 + LLM choice，强化"模型中立 + 专有数据图谱"的差异化定位。
- 关键数据：交互式工件/电子表格发布（约 2026-06-10，来源 https://www.glean.com/blog/enterprise-content-creation-artifacts ，2026-06-15 读取）；Nemotron Ultra 3 达前沿模型 91% 完整性性能（来源 LinkedIn https://www.linkedin.com/company/gleanwork ，约 2026-06-12）；截至 2026-05 未官宣 IPO（来源 https://forgeglobal.com/insights/how-to-invest-in-glean-stock-pre-ipo/ ，背景）
- 原文链接：https://www.glean.com/blog/enterprise-content-creation-artifacts ；https://www.glean.com/product-drop/june-2026 （June Drop，JS 渲染未取到正文）
- 影响判断：①"交互式工件 + 电子表格"标志企业知识 Agent 从"答问"走向"产出可交付物"，Glean 正面挑战传统 BI/表格工具。②支持 Nemotron Ultra 3 等开源模型，体现 Glean "把模型当可替换组件、把企业数据图谱当护城河"的战略定力。③按量计费（usage-based）的工件定价，是企业 Agent 从订阅制向"用量/结果计费"探索的又一信号，与 Sierra 的 outcome-based 形成呼应。

---

## 本组洞察（C 组：垂直 / 企业 Agent 赛道趋势）

**1. 定价模式集体转向"结果/用量"——订阅制天花板已现。** 本周三条独立信号叠加：Sierra 明确"按结果定价（outcome-based pricing）"、Glean 工件"按量计费（usage-based）"、Devin 用 !ultra/!fast 做算力分层运营。企业 Agent 正集体逃离"按席位订阅"模型，转向"为交付的价值/消耗的算力付费"。底层逻辑：Agent 的边际成本（推理算力）远高于传统 SaaS，且产出价值可量化，定价必须与价值/成本挂钩。这是 Agent 商业化区别于 SaaS 的根本性拐点。

**2. 护城河从"模型"转向"专有数据 + 安全合规"。** Harvey（判例法/DeepJudge 机构知识）、Glean（企业知识图谱 + 模型中立）、Sierra（FedRAMP High + 行业数据底座）三家不约而同强调：模型是可替换组件，真正的壁垒是专有数据接入 + 合规资质。本周 Harvey 首日级上线 Opus 4.8、Glean 接入 Nemotron Ultra 3，都印证"模型快速商品化、数据与合规才是壁垒"的判断。

**3. 供应链与治理安全成为企业 Agent 的"准入门槛"。** Replit Package Firewall（默认拦截恶意包）、Devin 企业 Web 搜索开关/自定义 OAuth/IdP 组角色、Sierra FedRAMP High——本周企业 Agent 的工程重心明显从"能力炫技"转向"可治理、可审计、可管控"。AI 自主执行（装包、搜索、改代码）带来的新攻击面正在被系统性收敛，这是 Agent 进入大企业生产环境的必经之路。

**4. 地缘政治正在重塑 Agent 赛道的资本与退出逻辑。** Manus 被 Meta 强制拆解（北京监管 + 10 亿美元独立募资转港股）是标志性事件：AI Agent 团队已被视为"战略资产"，跨境并购退出路径被国家安全审查封堵。前沿 Agent 正分裂为"美国阵营栈"与"中国阵营栈"，全球创业公司被迫选边。这对投资人的退出预期、对创业公司的注册地/募资结构都是结构性变量。

**5. 通用 Agent 与垂直 Agent 的边界在模糊。** Perplexity 的"Computer"（通用数字员工）、Replit Agent（vibe coding→企业级）、Glean（搜索→内容生产）都在横向扩张能力边界；而 Sierra（客服→公用事业/政府）、Harvey（法律→M&A/e-discovery）则在垂直深耕。拐点信号：能力层趋同（都靠前沿模型 + MCP 生态 + 编排），差异化越来越依赖"进入哪个高壁垒垂直场景 + 占有哪些专有数据"。
-e 
---

## 🌐 浏览器/计算机操作 Agent + 中国 Agent 板块深度

### 1. OpenAI Operator / ChatGPT Agent
- 本周动态：本周 OpenAI 在浏览器/计算机操作 Agent 主线上**无旗舰级发布**，但开发者侧有两项与 Agent 直接相关的小迭代落在窗口内。其一，6 月 13 日 OpenAI 在开发者网站（developers.openai.com）上线了可生成自定义指南的 **docs Agent**，并为 **Codex 浏览器**推出"开发者模式"（developer mode）——这是 Codex/CUA 体系向"浏览器内可调试代理"方向的工程化补强（来源：橘鸦Juya《AI早报 2026-06-13》逐条目录，YouTube，2026-06-13）。其二，OpenAI 此前公告把 workspace agents（Codex 驱动的工作区代理）**免费期延长至 2026-07-06**，之后转为基于额度的计费（来源：releasebot.io/updates/openai，抓取于 2026-06-15）。背景层面（非本周）：ChatGPT Agent 于 2025-07-17 发布，整合 Operator 的"行动型远程浏览器"+ Deep Research 网络综合 + ChatGPT 对话能力，配置可视化浏览器/文本浏览器/终端/API 四件套工具；ChatGPT Pro 订阅 2026 年 6 月仍为 $200/月（来源：openai.com/index/introducing-chatgpt-agent；technosports.co.in，2 days ago）。技术/商业判断：OpenAI 本周把重心放在"开发者基础设施"（docs Agent、Codex 浏览器开发者模式）而非面向消费者的 Operator 大版本，反映 CUA 已从"演示阶段"转入"开发者可嵌入/可调试"的工程化沉淀期；Operator 独立品牌正逐步被"ChatGPT Agent + Codex"双轨吸收。
- 关键数据：ChatGPT Pro $200/月（technosports.co.in，2026-06，2 days ago）；workspace agents 免费期延至 2026-07-06（releasebot.io，2026-06-15 抓取）；docs Agent / Codex 浏览器开发者模式（2026-06-13，橘鸦Juya AI早报）。
- 原文链接：https://openai.com/index/introducing-chatgpt-agent ；https://releasebot.io/updates/openai ；https://www.youtube.com/watch?v=kkkX1kHY-CQ
- 影响判断：本周信号是"Agent 下沉到开发者工具链"——把浏览器代理变成可调试、可嵌入的开发件，而非继续堆消费级演示。免费期收尾（7/6 起计费）是 Agent 商业化"开始收钱"的明确拐点信号。

---

### 2. Anthropic Computer Use（Claude）
- 本周动态：**本组本周最大事件之一**。6 月 9 日 Anthropic 发布 **Claude Fable 5**（Mythos 级模型、面向通用可用），官方称其能力"超过我们以往任何普遍可用的模型"，在软件工程、知识工作、视觉、科研等几乎所有测试基准上达到 SOTA，且"任务越长越复杂，Fable 5 领先越大"。与计算机/视觉操作强相关的亮点：Fable 5 是**新的视觉 SOTA**，能仅凭截图重建网页 App 源码；在仅用"原始游戏截图、无地图/无导航辅助"的极简视觉 harness 下**通关 Pokémon FireRed**（此前 Claude 需要复杂辅助 harness 才能玩）；在 Slay the Spire 中给予基于文件的持久记忆后，性能提升是 Opus 4.8 的 3 倍。定价 **$10/百万输入 token、$50/百万输出 token**（约为 Claude Mythos Preview 的不到一半）。但 6 月 12 日 Anthropic **紧急暂停** Claude Fable 5 与 Mythos 5 的访问（官方声明：暂停访问、尽快恢复）（来源：support.claude.com 发布说明，2026-06-09/06-12；anthropic.com/news/claude-fable-5-mythos-5）。背景（非本周）：3 月 23 日 Computer Use research preview 进入 Cowork/Claude Code；Claude for Chrome 已对付费用户 beta 开放。技术/商业判断：Fable 5 的"纯视觉通关游戏 + 截图重建代码"是 GUI grounding / 视觉操作能力的标志性跃迁，说明 computer-use 正从"靠 accessibility tree + 脚手架"走向"纯视觉端到端"；而上线 3 天即暂停，暴露 Mythos 级能力（尤其网络安全 dual-use）的安全护栏仍未稳定，是"能力跑在安全前面"的典型拐点风险。
- 关键数据：Fable 5 发布 2026-06-09、暂停 2026-06-12（support.claude.com release notes）；定价 $10/$50 每百万 token（anthropic.com/news/claude-fable-5-mythos-5，2026-06-09）；Slay the Spire 记忆增益为 Opus 4.8 的 3 倍、通关末章频次 3 倍（同上）；分类器触发 <5% 会话、>95% 会话无回退（同上）；外部 bug bounty 1000+ 小时未发现通用越狱（同上）。
- 原文链接：https://support.claude.com/en/articles/12138966-release-notes ；https://www.anthropic.com/news/claude-fable-5-mythos-5
- 影响判断：纯视觉端到端通关游戏 + 截图重建代码，是 computer-use Agent 视觉路线成熟的强信号；3 天即暂停则警示前沿能力的安全护栏成为商业化"硬约束"，安全与能力的拉扯已成 Agent 落地的主要瓶颈。

---

### 3. Google Project Mariner
- 本周动态：**本周关键状态变更（信息更新落在窗口内）**。6 月 11 日 Google Developer Experts/Medium 转载文章在文首明确标注："Update — June 2026: Google has officially discontinued the standalone Project Mariner experiment to integrate its web-browsing capabilities directly into Gemini Agent and AI Mode"——即 Google 已**正式停掉独立的 Project Mariner**，将其网页浏览能力直接并入 Gemini Agent 与 AI Mode（来源：prodsens.live，2026-06-11，原文 Medium/Google Developer Experts）。需要交叉说明：该文主体是对 2026-04-22 Cloud Next 的回顾（Vertex AI 被 Gemini Enterprise Agent Platform 取代、ADK 1.0、A2A 1.2 等均为 4 月旧闻，属背景），但"独立 Mariner 停用"的更新标记是 2026 年 6 月。Mariner 历史数据（背景）：由 DeepMind 构建、Gemini 2.0 驱动，WebVoyager 基准 **83.5%**，可云端 VM 并行 10 个任务；曾规划 Mariner Studio（Q2）、跨设备同步（Q3）、Agent 市场（Q4）。技术/商业判断：独立 Mariner 退场不是失败而是"收编"——Google 选择不维护单独的浏览器 Agent 产品，而把 web-browsing 作为 Gemini Agent 的原生能力，与 OpenAI 把 Operator 并入 ChatGPT Agent 的路径高度一致。三大巨头（OpenAI/Anthropic/Google）都在把"独立 CUA 产品"折叠进主力对话/Agent 平台，标志浏览器操作正从"独立功能"变为"基础能力"。
- 关键数据：独立 Mariner 停用并入 Gemini Agent/AI Mode（prodsens.live，2026-06-11）；WebVoyager 83.5%（背景，同源）；ADK 1.0 四语言、A2A 1.2、Model Garden 200+ 模型、150+ 组织生产环境用 A2A（均为 2026-04-22 Cloud Next 背景）。
- 原文链接：https://prodsens.live/2026/06/11/vertex-ai-is-gone-here-is-what-google-built-instead/
- 影响判断：独立浏览器 Agent 产品形态正在消亡，被收编为通用 Agent 平台的原生能力——这是 2026 年 Agent 赛道"产品收敛"的明确趋势信号，巨头不再单独卖"浏览器代理"，而是把它做成默认能力。

---

### 4. 字节 Coze / 扣子
- 本周动态：本周扣子**无新版本发布**，但 6 月 13-14 日有两条相关动态落在窗口内：①豆包（字节 C 端）于本周上线"任务模式"并升级"专家模式"（来源：橘鸦Juya AI早报 2026-06-13 目录），与扣子 Agent 体系同属字节 Agent 矩阵；②6 月 14 日东方财富/财联社主题报道继续发酵扣子 3.0 商业化叙事，浙商证券冯翠婷给出"2026 年 AI Agent 技术演进及商业化进入新拐点"的判断（来源：finance.eastmoney.com，2026-06-14 抓取，574 人评论）。核心产品事件（背景，非本周）：扣子 **Coze 3.0** 于 **2026-05-30 前后发布、6 月 1 日 IT之家报道**，支持多人多 Agent 协作、开箱即用、多种专家技能；可一键接入 Claude Code、Codex CLI、OpenClaw 等本地 Agent；含自媒体/法律/金融/互联网/医疗等行业专家模板；支持手机电脑跨端同步、授权 Agent 处理本地文件（来源：finance.sina.com.cn，2026-06-01）。开源侧：核心仓库 coze-studio（零代码/低代码 Agent 可视化引擎）、coze-loop（企业级 Agent 运维/评测），2025-07 起 Apache 2.0 开源可商用（来源：cloud.tencent.com 教程，抓取于 2026-06）。技术/商业判断：扣子本周处于 3.0 发布后的"商业化叙事消化期"，资本市场（券商研报、A股概念股）正把扣子 3.0 当作"Agent 商业化拐点"的标志性事件来炒作；字节的差异化是"全民低代码 + 行业模板 + 跨端云设备"，把 Agent 平民化做到极致。
- 关键数据：Coze 3.0 发布约 2026-05-30、报道 2026-06-01（IT之家/新浪，背景）；coze-studio GitHub Star 约 4.9K+（53ai.com，抓取于 2026-06）；开源协议 Apache 2.0，2025-07 开源；豆包任务模式/专家模式升级（2026-06-13）。
- 原文链接：https://finance.eastmoney.com/a/202606033758104260.html ；https://finance.sina.com.cn/tech/digi/2026-06-01/doc-inhzwyqr2443757.shtml
- 影响判断：扣子是中国 Agent"商业化拐点"叙事的核心载体——券商把它和 OpenClaw 并列为"从自动化走向自主性"的代表。本周虽无新版本，但豆包"任务模式"上线显示字节在 C 端同步推进 Agent 入口争夺，B/C 两端并行。

---

### 5. 智谱 AutoGLM
- 本周动态：智谱本周核心事件是 6 月 13 日公开 **GLM-5.2**（AutoGLM 的底座模型线）。据威易网 2026-06-14 报道，智谱 6 月 13 日下午宣布 GLM-5.2，当晚 5:21 开放给 GLM Coding Plan 全量用户（覆盖 Lite/Pro/Max/团队版），API 下周上线，模型下周开源、采用最宽松的 **MIT 协议**。内测用户初步反馈"体感和 Opus 4.5 差不多，速度也快"。GLM-5 系列三个月三版的节奏：2026-02 发布并开源 GLM-5（27 万亿 tokens 训练，定位"从 Vibe Coding 到 Agentic Engineering"）；2026-05 GLM-5.1（"为长程智能体任务而生"）；2026-06-13 GLM-5.2（重点是开放与开源而非能力升级）。配套地，智谱本周还发了 ZCode 3.0，每天 300 万 token 免费用 GLM-5.2（来源：weste.net，2026-06-14）。AutoGLM 作为智谱的端侧/计算机操作 Agent（背景，非本周）：AutoGLM 2.0 为"全球首个手机 Agent"，开创 Agent + 云手机/云电脑范式；AutoGLM 可自主执行 50+ 步长操作、跨 app 执行；GLM-PC 为"像人一样操作计算机"的视觉 Agent（来源：zhipuai.cn；oschina.net/news/367374）。技术/商业判断：智谱本周走的是"底座模型开源放量"路线——用 MIT 协议把接近 Opus 级的编程/Agent 模型彻底开源，是对闭源阵营最锋利的一招。AutoGLM/GLM-PC 的计算机操作能力直接受益于 5.2 底座升级。
- 关键数据：GLM-5.2 公开 2026-06-13、当晚 17:21 全量开放、API 下周上线、下周开源 MIT 协议（weste.net，2026-06-14）；GLM-5 训练 27 万亿 tokens、2026-02 开源（同上）；ZCode 3.0 每天 300 万 token 免费（weste.net，2026-06-14）；AutoGLM 50+ 步、跨 app（zhipuai.cn，背景）。
- 原文链接：https://www.weste.net/2026/06-13/GLM-5.2.html ；https://www.zhipuai.cn/zh ；https://www.oschina.net/news/367374
- 影响判断：MIT 协议开源接近 Opus 级模型，是中国 Agent 阵营"以开源换生态"的最强信号——一旦下周权重发布且公开评测坐实"接近 Opus 4.5"，对全球闭源定价体系和 Agent 底座选型都会形成实质冲击。

---

### 6. 月之暗面 Kimi Agent
- 本周动态：**本组本周中国侧最大事件之一**。6 月 12 日月之暗面 Kimi 发布并开源 **Kimi K2.7 Code** 编程模型（IT之家 2026-06-12）。官方称内外部基准显示：相比 K2.6 显著提升长上下文编程的指令遵循与长程任务性能，大幅改善长程任务"过度思考"倾向，平均 token 消耗减少 **30%**。代码基准：Kimi Code Bench v2 **+21.8%**、Program-Bench **+11%**、MLS Bench Lite **+31.5%**；Agent 自主执行基准（Kimi Claw 24/7 Bench、MCP Atlas、MCP Mark Verified）性能提升约 **10%**。定价：1M token 标准输入/输出与 K2.6 一致，分别 **6.5 元 / 27 元**，命中缓存输入降至 **1.3 元**。Kimi Code Plan 默认模型同步升级为 K2.7 Code；非编程任务仍推荐更全面的 K2.6；使用 K2.7 Code 须开启 Thinking 模式（关闭会报错或回退 K2.6）。同时预告 **K2.7 Code 高速版**：同模型、输出速度约普通版 5-6 倍（常规约 180 Token/s、短上下文达 260 Token/s），**6 月 15 日**上线、6x 速度 2x 价格。此外本周 Kimi 还宣布推出"全球首张 AI 原生信用卡"并开启预约（来源：橘鸦Juya AI早报 2026-06-13）。开源地址 huggingface.co/moonshotai/Kimi-K2.7-Code。背景（非本周）：ARR 突破 1 亿美元、传新一轮融资估值料升至 180 亿美元、传赴港 IPO（MoneyDJ/鉅亨網，2026-03）。技术/商业判断：Kimi 本周聚焦"编程 Agent 的工程化"——减 30% token、治"过度思考"、高速版"6x 速度 2x 价格"，全是面向长程 Agent 落地的成本/效率优化，而非单纯刷榜。
- 关键数据：K2.7 Code 发布开源 2026-06-12（IT之家）；token 消耗 -30%；Code Bench v2 +21.8%、Program-Bench +11%、MLS Bench Lite +31.5%、Agent 基准 +约10%；定价 6.5/27 元每 1M、缓存 1.3 元；高速版 6 月 15 日、180-260 Token/s、6x速度2x价（finance.sina.com.cn，2026-06-12）；ARR>1 亿美元、估值料 180 亿美元（MoneyDJ，2026-03-31，背景）。
- 原文链接：https://finance.sina.com.cn/tech/digi/2026-06-12/doc-iniceccm3424210.shtml ；https://huggingface.co/moonshotai/Kimi-K2.7-Code
- 影响判断：Kimi 把竞争焦点从"能力刷榜"转向"长程编程 Agent 的成本与速度工程"，-30% token + 6x 高速版直击 Agent 商用最大痛点（贵、慢、过度思考）。这是中国 Agent 从"比聪明"转向"比能不能便宜稳定地干长活"的拐点。

---

### 7. 阿里 Qwen Agent
- 本周动态：Qwen-Agent 开源框架本周**无新 release**（GitHub releases 最近一次为 2026-05-29：修复 mcp 的 sse_read_timeout 与自动重连；近期主要围绕 MCP streamable-http 支持、5-22 改 Apache 2.0 协议、transformers/audio 输入等工程补强）。本周阿里在 Agent 侧的动态落在"应用/生态层"：6 月 10 日财新报道阿里、腾讯发布"高考填报智能体"，AI 入口之争加码（来源：caixin.com，2026-06-10）。Qwen-Agent 是通义发布的 Agent 开发框架，开发者可基于其利用 Qwen 的指令遵循、工具使用、规划、记忆能力，内置浏览器助手、代码解释器、自定义助手等示例（来源：tongyi.aliyun.com 通义实验室页）。底座背景（非本周，均在窗口外）：6 月 2 日发布 **Qwen3.7-Plus**（多模态 Agent 模型，"一个模型能看、能想、能写代码、能行动"，ScreenSpot Pro **79.0** 超 GPT-5.4 的 67.4 与 Gemini 3.1 Pro 的 68.1，AndroidWorld 81.0，Terminal-Bench 2.0 70.3；Hybrid-Agent 连续运行 11 小时自动完成英语单词 App 研发；定价输入 $0.4/输出 $1.6 每百万 token；仅 API 不开源）（来源：wallstreetcn.com，2026-06-03）；更早 Qwen3.6-Plus（2026-04-02，Terminal-Bench 2.0 61.6 超 Claude Opus 4.5）。技术/商业判断：Qwen-Agent 框架本周静默，但底座 Qwen3.7-Plus（6/2，窗口外）把"看屏幕、操作 GUI、写代码"统一进一个多模态 Agent 模型，ScreenSpot Pro 79 分被业界视为"GUI Agent 能否真正商用"的关键门槛——这是阿里 computer-use 路线的核心筹码。本周应用层"高考填报智能体"则是把 Agent 推向真实 C 端刚需场景。
- 关键数据：Qwen-Agent 最近 release 2026-05-29、协议改 Apache 2.0（GitHub，抓取于 2026-06-15）；高考填报智能体 2026-06-10（caixin.com）；Qwen3.7-Plus ScreenSpot Pro 79.0、AndroidWorld 81.0、Terminal-Bench 70.3、定价$0.4/$1.6（wallstreetcn.com，2026-06-03，背景）。
- 原文链接：https://github.com/QwenLM/Qwen-Agent/releases ；https://tongyi.aliyun.com ；https://wallstreetcn.com/articles/3773626
- 影响判断：阿里把 GUI 操作能力压进多模态底座（Qwen3.7-Plus ScreenSpot Pro 79，业界商用门槛分）、把 Agent 应用推向高考填报等 C 端刚需，是"底座+入口"双线打法。Qwen-Agent 框架本身趋于稳定维护期，竞争重心已上移到底座模型的 GUI grounding 能力。

---

## 本组洞察（浏览器/计算机操作 Agent + 中美 Agent 对比）

1. **"独立浏览器 Agent 产品"正在集体消亡，被收编为通用 Agent 平台的原生能力。** 本周 Google 正式停掉独立 Project Mariner、并入 Gemini Agent/AI Mode（2026-06-11 更新标记），与 OpenAI 把 Operator 折叠进 ChatGPT Agent 的路径一致。三巨头都不再单独卖"浏览器代理"，computer-use 从"独立功能"变成"默认基础能力"。这是 2026 年 Agent 赛道最清晰的产品收敛信号。

2. **视觉路线（纯截图端到端）正在取代"accessibility tree + 脚手架"。** Anthropic Claude Fable 5（6/9）仅凭原始截图通关 Pokémon、截图重建网页源码；阿里 Qwen3.7-Plus（背景）ScreenSpot Pro 79 分。GUI grounding 的视觉理解能力是 computer-use Agent 的新主战场，且 79 分被业界视为"商用门槛"。

3. **安全护栏成为前沿能力商业化的硬约束。** Fable 5 上线 3 天即因 Mythos 级 dual-use 风险（网络安全/生物）紧急暂停（6/9→6/12），暴露"能力跑在安全前面"的系统性风险。这是美系前沿厂商独有的拐点烦恼，中国厂商本周未见类似事件。

4. **中美打法分化明显——美国"能力优先 + 安全约束"，中国"开源放量 + 成本工程 + 入口争夺"。** 本周中国侧三件大事都不是刷能力榜：智谱 GLM-5.2 用 MIT 协议把接近 Opus 级模型彻底开源（6/13）；Kimi K2.7 Code 主攻 -30% token + 6x 高速版的长程编程成本工程（6/12）；字节/阿里/腾讯在豆包任务模式、高考填报智能体等 C 端入口贴身肉搏。中国 Agent 已从"比聪明"转向"比能不能便宜、稳定、可商用地干长活"。

5. **拐点信号：Agent 商业化"开始收钱"。** OpenAI workspace agents 免费期收尾（7/6 起计费）、Kimi 高速版"6x 速度 2x 价格"、智谱用免费 token（ZCode 每天 300 万）抢开发者——免费补贴与差异化定价并存，说明 Agent 正从"拉新补贴期"进入"商业模式验证期"。券商（浙商证券）明确把 2026 定义为"AI Agent 技术演进及商业化进入新拐点"之年。

---

## 📋 关于本周报

- **数据口径**：仅收录 2026-06-08~2026-06-14 区间内公开动态；"（背景，非本周）"为区间外补充信息，不计入本周动态。
- **覆盖统计**：28/28 对象全覆盖。有重大动态：Claude Code、Codex、OpenClaw、Cursor、OpenCode、LangGraph、CrewAI、Google ADK、OpenAI Agents SDK、Perplexity、Harvey、Replit、Devin、Manus、Sierra、Glean、Anthropic Computer Use(Fable 5)、Google Mariner、智谱 GLM-5.2、Kimi K2.7 Code 等。本周静默（已标注原因）：Hermes、Microsoft AutoGen、Dify、LlamaIndex、Cognition(Windsurf)、字节扣子、Qwen-Agent 框架、OpenAI Operator 旗舰。
- **来源说明**：官方博客/GitHub release/官方公告/论文为一手优先；二手媒体已标注并尽量交叉验证 ≥2 源。
- **下期预告**：持续追踪 GLM-5.2 权重开源后的公开评测、Fable 5 恢复访问进展、Manus 中国 JV 募资落地、编码 Agent 阵营迁移战。
