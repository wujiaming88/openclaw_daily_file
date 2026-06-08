# 全球 AI Agent 周报 · 第 N 期（2026-06-01 ~ 2026-06-07）

> **覆盖区间**：2026-06-01（周一）00:00 → 2026-06-07（周日）24:00（上海时区完整一周）
> **覆盖范围**：4 大板块 28 个 Agent 对象（编码CLI / 通用框架 / 垂直企业 / 浏览器操作+中国）
> **时间窗声明**：仅收录区间内真实公开动态；区间外旧闻一律标注"（背景，非本周）"。
> **实质覆盖率**：28/28（100%），获取失败 0 个。

---

## 本周一句话

> **ACP（Agent Client Protocol）正在成为多 Agent 互操作的事实标准——赛道集体从"做最强的单个 Agent"转向"做所有 Agent 的指挥中心与编排层"，而 Token 经济学已成为全行业产品架构的第一性约束。**

本周两场大会（Microsoft Build 2026、LangChain Interrupt 2026）+ Cognition 把 Windsurf 升级为 Devin Desktop 并拥抱 ACP，三件事共同把 Agent 竞争推进到"生产级可靠运行 + 多 Agent 编排 + 企业治理"的下半场。与此同时，中国 Agent 本周才是落地主战场（扣子 Coze 3.0、Kimi Work 公测、Qwen-VLA 具身）。

---

## 🔥 本周 TOP 5

### 1. Cognition 把 Windsurf 升级为 Devin Desktop，拥抱 ACP 开放协议 ｜ 2026-06-02
Cognition 通过 OTA 把 Windsurf 重命名/升级为 **Devin Desktop**（用户 plan/定价/扩展/键位无缝保留）。核心三变：①**Agent Command Center** 成默认界面，用单一 Kanban 管理所有本地与云端 agent，新增 **Spaces** 在 agent 间共享上下文；②**支持 Agent Client Protocol (ACP)** 开源协议，发布即兼容 **Codex、Claude Agent、OpenCode** 及自建 agent，第三方 agent 获得与 Devin 同等待遇；③推出 **Devin Local**（Cascade 继任者，用 Rust 从零重写，token 效率提升最高 30%，支持 subagents，旧 Cascade 7/1 EOL）。Ramp、Harvey、NVIDIA 等均站台。
↳ **为什么重要**：这是从"做最好的编码 agent"转向"做所有 agent 的操作台/聚合层"的战略转身。连 Claude Code 都在 6/3 把 /ide 里的 Windsurf 改名跟进——ACP 正在成为多 agent 互操作的事实标准。
↳ [Devin 官方博客](https://devin.ai/blog/windsurf-is-now-devin-desktop) · [Tech Edition 报道](https://www.techedt.com/cognition-launches-devin-desktop-for-managing-ai-coding-agents-across-engineering-workflows)

### 2. 微软基于 OpenClaw 推出 Scout + Windows 原生 Agent 沙箱 ｜ 2026-06-02
微软在 Build 2026 发布 **Scout**——一款"OpenClaw-inspired"、基于 OpenClaw 框架构建的 Microsoft 365 常驻 agentic 助手；同时宣布 Windows 内置 AI Agent 沙箱（MXC）+ OpenClaw 支持 + NVIDIA OpenShell 集成。OpenClaw 本周自身也密集迭代（6/7 pre-release）：Parallel 成为内置 web_search provider、MCP 富内容在 materialize 边界强制规整防 400 错误、auth profiles 迁入 SQLite、ClawHub 可装 GitHub 仓库技能。
↳ **为什么重要**：开源 Agent OS 被超大厂"标准化采纳"的拐点信号——Agent 框架正从个人工具升级为被大厂嵌入操作系统的底座。
↳ [TechCrunch 报道](https://techcrunch.com/2026/06/02/microsoft-launches-scout-an-openclaw-inspired-personal-assistant/) · [OpenClaw Releases](https://github.com/openclaw/openclaw/releases)

### 3. 双会齐发：LangChain Interrupt 2026 + Microsoft Build 2026 ｜ 2026-06-02 ~ 06-05
**LangChain Interrupt（6/5）** 发布 **LangSmith Engine**（自主 Agent，持续监控生产 trace、聚类失败、诊断根因、自动提 PR 修复）、**SmithDB**（Rust+DataFusion 构建，核心体验提速最高 15x）、**Managed Deep Agents**、**Sandboxes GA**、**LLM Gateway**（spend 硬上限/PII 脱敏）。**Microsoft Build（6/2-3）** 完成 AutoGen+Semantic Kernel→**MAF** 统一，发布生产级 **Agent Harness**、**Foundry Hosted Agents**（scale-to-zero，7月初 GA）、**CodeAct + Hyperlight micro-VM**。
↳ **为什么重要**："Agent Harness"（记忆/技能/todo/子Agent/上下文压缩）已成行业标准抽象，竞争从"能不能搭"转向"能不能在生产里持续可靠运行并自我改进"。
↳ [Interrupt 2026 总览](https://www.langchain.com/blog/interrupt-2026-overview) · [MAF @ Build 2026](https://devblogs.microsoft.com/agent-framework/microsoft-agent-framework-at-build-2026-announce/)

### 4. 中国 Agent 集体爆发：扣子 Coze 3.0 + Kimi Work 公测 + Qwen-VLA ｜ 2026-05-30 ~ 06-04
本周窗口内的实打实落地全部来自中国：①字节 **扣子 Coze 3.0**——"多人+多 Agent 协作"范式升级，主动接入 Claude Code/Codex CLI/OpenClaw 等外部框架做"开放编排层"；②月之暗面 **Kimi Work 公测**——通用型本地操作 Agent（拆解任务/调用工具/用浏览器/交付文档表格 PPT），估值飙至逾 200 亿美元；③阿里 **Qwen-VLA**（6/3）——具身智能"大脑+小脑"架构，把 Agent 从屏幕推向物理世界。
↳ **为什么重要**：海外三巨头本周集体进入平台期/退场（Mariner 5/4 已停运），中国 Agent 反而密集落地、商业化提速，呈现三条差异化路线（协作编排层 / 本地操作 Agent / 统一具身基座）。
↳ [扣子 3.0 报道](https://news.qq.com/rain/a/20260601A07WH900) · [Kimi Work 公测](https://wap.eastmoney.com/a/202606043759654280.html) · [Qwen-VLA 深度](https://m.ofweek.com/ai/2026-06/ART-201717-8420-30689246.html)

### 5. Token 经济学成为全赛道第一性约束 ｜ 贯穿本周
几乎所有头部企业 Agent 同一周围绕"降本"出招：**Perplexity** 推端云混合推理（routine work 下沉端侧，联合 Intel）、**Harvey** 与 Factory 做模型路由+与 LangChain 把 verifier 成本降一个数量级、**Glean** 接入 NVIDIA Nemotron 3 Ultra 开源模型、**Devin** 预告 agent router 按成本路由。叠加 **Sierra** 的"Saaspocalypse / 按结果付费"叙事，商业模式正从"卖席位/卖用量"转向"卖结果/卖业务闭环"。
↳ **为什么重要**：OpenAI/Anthropic 在企业市场近乎垄断后涨价，中间商毛利承压，"per seat 定价已死"。谁先解决单位经济模型谁就赢。
↳ [Legal AI 的 Token 价格问题](https://www.artificiallawyer.com/2026/06/03/legal-ai-has-a-growing-token-price-problem/) · [Sierra Outcomemaxxing](https://sierra.ai/blog/outcomemaxxing)

---

## 🧭 三大维度趋势

### 学术研究
- **自进化 Agent 走向企业可部署**：Nous Research 的 Hermes Agent 获 NVIDIA 官方技术博客背书（~6/3），用 OpenShell 沙箱做凭据隔离/禁公网，让"自动造技能、跨会话记忆"的自进化范式首次具备企业级安全前提；自进化技能通过 snapshot/restore 跨部署存活。
- **具身智能成 Agent 新边界**：阿里 Qwen-VLA（6/3）首创"VLA 大一统策略模型 + 扩散动作生成 + 仿真强化学习"融合路线，11.5 亿参数扩散动作解码器输出连续物理参数，真机遥操作数据占训练集 74.2%，在 DOMINO 动态操控评测中零样本超越专用模型。

### AI Agent 工程
- **"多 Agent 编排 + 子 Agent"全赛道同频**：Claude Code（跨会话权限隔离+fallbackModel 链）、Codex（Multi-agent v2 per-thread 运行时路由）、Cursor（nested subagents+custom tools+auto-review）、OpenCode（后台 subagents）、Devin Local（支持 subagents）五家同周强化子 Agent。
- **"Agent Harness"成标准抽象**：MAF Agent Harness、LangChain Deep Agents、ADK Workflow Runtime 在记忆/技能/todo/子Agent/压缩/沙箱执行上高度收敛。ADK 2.2.0（6/4）带破坏性变更，默认模型切到 gemini-3-flash-preview。

### 商业化与落地
- **资本按"重塑行业"定价**：Devin $26B 估值（约 53 倍 ARR，年化收入 $492M/+1230%）、Sierra $15B+、Harvey $11B、Replit $9B、Glean $7.2B（ARR ~$300M）。
- **监管与地缘成变量**：Manus 案——中国 7/1 起"对外投资技术溯源"新规法典化，实质阻断 Meta 约 $2B 收购；通用自主 Agent 头部正被卷入国家级博弈。

---

## 📚 赛道深度正文

下列为各板块全量深度笔记（每个有动态对象 ≥200 字，已进 TOP 5 的标"详见 TOP5"）。


---

### 💻 编码 Agent / CLI（A 组）

**速查表（仅导航）**

| 对象 | 本周强度 | 一句话 |
|------|---------|--------|
| Claude Code | 🔥重大 | 2.1.166 发布，fallbackModel 多级回退 + 跨会话权限隔离 |
| OpenAI Codex / Codex CLI | 🔥重大 | CLI 0.137.0，Multi-agent v2 per-thread 运行时路由 |
| OpenClaw | 🔥重大 | 详见 TOP5（微软 Scout 采纳）+ Parallel 内置搜索/MCP 硬化 |
| Hermes Agent | 🔥重大 | NVIDIA NemoClaw + OpenShell 自进化 Agent 部署范例 |
| Cursor | 🔥重大 | Composer 2.5 + SDK custom tools/nested subagents/auto-review |
| Cognition (Devin/Windsurf) | 🔥重大 | 详见 TOP5（Devin Desktop + ACP） |
| OpenCode | 🟢一般 | 仓库迁 anomalyco，Provider 矩阵扩张 + ACP 标准化 |

#### Claude Code（Anthropic）
本周 Claude Code 发布密集，CHANGELOG 显示版本从 2.1.163（6/4）一路滚动到 2.1.168（6/6），核心版本为 **2.1.166（6/6 发布）**。最重磅功能是新增 **`fallbackModel` 设置**：可配置最多三个回退模型，当主模型过载/不可用时按顺序自动切换，`--fallback-model` 现也适用于交互式会话；当 API 返回非预期的不可重试错误时，Claude Code 会在回退模型上自动重试一次（auth/限速/请求体过大/传输错误仍立即上报）。安全侧两项硬化：①deny 规则的工具名位置新增 **glob 通配支持**（`"*"` 可禁用所有工具），allow 规则拒绝非 MCP 的 glob，未知工具名启动时告警；②**跨会话消息（SendMessage）硬化**——由其他 Claude 会话中继的消息不再携带用户权限，接收方拒绝中继的权限请求，auto 模式直接拦截（这是对子 Agent 编排场景下权限提升攻击的防御）。6/4 的 2.1.163 新增 `requiredMinimumVersion`/`requiredMaximumVersion` 受管设置、`/plugin list` 命令、Stop/SubagentStop hooks 可返回 `additionalContext`。另一关键信号：6/3 把 **`/ide` 菜单里的 "Windsurf" 重命名为 "Devin Desktop"**，跟随该编辑器品牌重塑。技术判断：本周无模型层更新，全是 CLI 工程化打磨——回退模型链 + 跨会话权限隔离 + 受管版本锁，三者都指向企业级多 Agent 编排的可靠性与安全治理。
- **关键数据**：版本 2.1.166（6/6 发布），CHANGELOG 头部已到 2.1.168（6/6）；6/2-6/6 多次发布。来源 [Claude Code Releases](https://github.com/anthropics/claude-code/releases)、[CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)（读取于 2026-06-08）
- **影响判断**：fallbackModel 多级回退 + 跨会话权限隔离是面向"多 Agent 协作可靠性/安全"的关键基建；Windsurf→Devin Desktop 改名是 Cognition 整合 Windsurf 的直接旁证。

#### OpenAI Codex / Codex CLI
本周 Codex 有两条官方发布（均 2026-06-04）：①**Codex CLI 0.137.0**（`npm install -g @openai/codex@0.137.0`，从 rust-v0.136.0 升级）；②**Codex app 26.602**。CLI 0.137.0 头条是 **Multi-agent v2**：核心是**每个 thread 各自保留运行时选择**（runtime choice kept with each thread），并为派生子 Agent 提供更干净的 follow-up 与 metadata 默认值——此前所有从父会话派生的子 Agent 都继承父级运行时配置，v2 实现 **per-thread 运行时路由**。其他工程更新：TUI 支持 F13-F24 键位、可搜索菜单粘贴、紧凑推理状态项；企业流新增**月度信用额度显示与云托管配置包（cloud-managed config bundles）**含 EDU 工作区；远程控制客户端可通过 app-server v2 RPC 发起配对、列出/撤销控制者授权；插件新增 `codex plugin list --json`；托管 web/image 工具可在更多 code-mode 流程使用，独立 web 搜索可并行。安全侧：权限请求与审批携带环境身份，受管 MITM 代理向子命令导出可读 CA 包。架构重构：共享 prompts、context fragments、skills plumbing 移入专用 crate 降低 codex-core 耦合。技术判断：Codex 与 Claude Code 本周高度趋同——子 Agent/多 Agent 编排 + 企业级配置治理 + 权限携带环境身份。
- **关键数据**：Codex CLI **0.137.0**、app **26.602**（2026-06-04）。来源 [Codex Changelog](https://developers.openai.com/codex/changelog)、[Codex Releases](https://github.com/openai/codex/releases)
- **影响判断**：Multi-agent v2 的 per-thread 运行时路由是子 Agent 编排范式升级，不同子任务可用不同模型/配置，直接对标 Claude Code 的子 Agent 体系。

#### OpenClaw（Agent OS）
**详见 TOP5 第 2 条。** 补充工程要点：本周 6/7 00:26 发布 pre-release（6 月版本地板 2026.6.5，Releasebot 记 2026.6.2）。亮点：①**Parallel 成内置 web_search provider**（PARALLEL_API_KEY 自动发现、缓存安全会话 id、onboarding 选择器，PR #85158）；②**MCP 工具结果在 materialize 边界强制规整** resource_link/resource/audio/畸形 image 等非文本块，防 Anthropic 400 错误与"中毒"会话历史（#90710/#90728）；③Anthropic extended-thinking 会话在 prompt-cache 过期或 Gateway 重启后可恢复；④auth profiles 迁入 SQLite、官方 npm 插件安装记录保留可信 pin；⑤ClawHub 可安装 GitHub 仓库技能（按 pinned commit）；⑥QQBot 原生投递前剥离模型 reasoning/thinking 脚手架。
- **关键数据**：6/7 pre-release；微软 Scout 基于 OpenClaw 框架（2026-06-02）。来源 [OpenClaw Releases](https://github.com/openclaw/openclaw/releases)、[TechCrunch](https://techcrunch.com/2026/06/02/microsoft-launches-scout-an-openclaw-inspired-personal-assistant/)
- **影响判断**：微软采纳 + Windows 原生支持是开源 Agent OS 被超大厂标准化的拐点；内置 Parallel 搜索 + MCP 富内容硬化体现平台向生产级可信运行时成熟。

#### Hermes Agent（Nous Research，自进化）
本周 Hermes 最重磅动态是 **NVIDIA 官方技术博客（~2026-06-03）发布 Hermes Agent × NVIDIA NemoClaw 自进化 Agent 部署范例**——Nous Research 自进化 Agent 获 NVIDIA 生态背书的关键事件。范例核心：用 Hermes + NemoClaw 跨 Outlook/Slack/GitHub 做产品研究，由 **NVIDIA OpenShell（v0.0.38）** 强制安全审批运行时沙箱。技术细节（读自原文）：①OpenShell 沙箱管理凭据使 Hermes **永远看不到 Slack/Outlook token**（认证在沙箱代理出口完成），并强制网络访问策略（持敏感内部数据的 agent **被禁止访问公网**，即使被攻破也无法外泄）；②默认模型 **nvidia/nemotron-3-super-120b-a12b**，也可跑自托管 NIM/vLLM；③**"教一次，处处调用"**：用户在 Slack 口头教 agent 一个日报格式，Hermes 识别模式后**自动写出 SKILL.md**（YAML frontmatter + 格式骨架）到文件系统，通过 snapshot/tear-down/rebuild/restore 保证技能跨部署存活。Hermes 官方定位（GitHub README）：带内置学习闭环——从经验创建技能、使用中自我改进、自我提醒持久化知识、FTS5 检索历史会话、Honcho 用户建模；支持多渠道单网关、六种终端后端（local/Docker/SSH/Singularity/Modal/Daytona）。坊间反馈（Medium ~6/5）：有用户称连续用三周后日报任务 token 消耗降约 30%（单一来源，待验证）。技术判断：Hermes 走与编码 CLI 完全不同的路线——"随用随进化、跨会话记忆、自动造技能"，本周拿 NVIDIA NemoClaw+OpenShell 安全运行时背书，是自进化 Agent 商业化落地的实质一步。
- **关键数据**：默认模型 nvidia/nemotron-3-super-120b-a12b；OpenShell v0.0.38。来源 [NVIDIA 技术博客](https://developer.nvidia.com/blog/deploy-self-evolving-agents-for-faster-more-secure-research-with-a-hermes-agent-and-nvidia-nemoclaw/)、[Hermes GitHub](https://github.com/nousresearch/hermes-agent)
- **影响判断**：NVIDIA 背书 + OpenShell 凭据隔离/禁公网解决了"自进化黑盒 agent 接触企业敏感数据"的安全顾虑，是自进化 Agent 进入企业的关键拼图。

#### Cursor（Anysphere）
本周 Cursor 官方 changelog（~2026-06-04）密集更新，主线是 **SDK + 企业治理 + 多 Agent 编排**。①**Cursor SDK 大更新**：(a)**Custom tools**——通过 `local.customTools` 把自定义函数作为工具交给本地 agent，经内置 MCP server 暴露，对父 agent 的所有子 agent 可见，无需自建 stdio/HTTP MCP server；(b)**Auto-review**——headless 运行时通过 `local.autoReview` 把工具调用路由到分类器审查，用 `permissions.json` 的自然语言指令引导（只读放行、删除必停）；(c)**JSONL/自定义存储**——agent/run 元数据可选 append-only JSONL 或实现 `LocalAgentStore` 接 Postgres；(d)**嵌套子 Agent（nested subagents）**——子 agent 可无限层级再生子 agent，每层保留自己的 prompt/model。②**Composer 2.5**——固定 composer-2 的脚本自动迁移（模型迭代信号）。③**Design Mode**：浏览器中多选元素、语音输入；Canvas 获 Design Mode + 上下文用量报告（拆解 system prompt/tool definitions/rules/skills 的 token 去向）。④**Enterprise Organizations GA**：组织作为顶层容器统管多个 Team，汇总全公司 spend 与 token 用量，引入 Groups。技术判断：Cursor 在"自有模型 + SDK 可编程 + 企业治理"三线并进。
- **关键数据**：Composer 2.5；SDK custom tools/auto-review/JSONL/nested subagents；Enterprise Organizations GA。来源 [Cursor Changelog](https://cursor.com/changelog)
- **影响判断**：nested subagents + custom tools + auto-review 把"可编程多 Agent 编排"标准化，瞄准 CI/生产脚本场景；Enterprise Organizations GA 是冲击大型企业采购的治理基建。

#### Cognition（Devin / Windsurf）
**详见 TOP5 第 1 条。** 关键补充：Devin Local 用 Rust 重写、token 效率最高 +30%、支持 subagents，旧 Cascade 7/1 EOL；"One Devin, every surface"覆盖 Desktop/Cloud/CLI/Review。第三方分析（byteiota ~6/7）指出 Spaces 是"刻意精简的早期功能"，更多开发延续到 Q3 2026。
- **关键数据**：2026-06-02 Windsurf→Devin Desktop（OTA）；Cascade EOL 2026-07-01；Devin Local token 效率最高 +30%。来源 [Devin 博客](https://devin.ai/blog/windsurf-is-now-devin-desktop)、[Devin Desktop FAQ](https://docs.devin.ai/desktop/devin-desktop-faq)
- **影响判断**：拥抱 ACP 把竞品 agent 纳入自家指挥中心，是"聚合层"战略关键落子；Devin Local +30% token 效率显示性能/成本竞争白热化。

#### OpenCode
本周 OpenCode 在 GitHub 持续高频发布，6/5 有两次 release。**组织信号：仓库 github.com/sst/opencode 现 301 重定向至 github.com/anomalyco/opencode**——OpenCode 似已从 SST 转入 anomalyco 组织（治理或商业化结构变化）。本周亮点：①**Core**：managed workspace cloning（保留 dirty/untracked 文件）、session 跨 workspace 移动、通过 AWS Bedrock 提供 OpenAI 模型、**skill discovery + file-based agent loading**、`run --replay` 交互式回放、新增 Snowflake Cortex provider；②**子 Agent**：running subagents 可发送到后台运行，长会话持久化 system context；③**ACP**：恢复加载已保存会话时完整 ACP session replay、修复 ACP cancel——印证 OpenCode 是 ACP 生态一员（与 Devin Desktop"发布即支持 OpenCode"互相印证）；④编辑安全：edit 拒绝可能覆盖错误代码的 loose matches；⑤Desktop：多服务器支持。技术判断：定位为"provider 中立、开源、ACP 兼容"的编码 agent。
- **关键数据**：6/5 两次 release；仓库 sst→anomalyco（301 重定向）。来源 [OpenCode Releases](https://github.com/anomalyco/opencode/releases)
- **影响判断**：仓库归属迁移是结构性信号；ACP 兼容让其被 Devin Desktop 等指挥中心收编，开源编码 CLI 正通过协议标准化嵌入更大编排生态。

---

### 🧩 通用 / 自主 Agent 框架（B 组）

**速查表（仅导航）**

| 对象 | 本周强度 | 一句话 |
|------|---------|--------|
| LangChain / LangGraph | 🔥重大 | 详见 TOP5（Interrupt 2026：LangSmith Engine 等） |
| Microsoft AutoGen → MAF | 🔥重大 | 详见 TOP5（Build 2026：Agent Harness/Foundry/CodeAct） |
| Google ADK | 🟢一般 | 2.2.0（6/4）破坏性更新，默认模型切 gemini-3-flash-preview |
| CrewAI | 🟢一般 | 6/3、6/5 两预发布，Snowflake/Databricks 集成+对话式 flow |
| OpenAI Agents SDK / Swarm | ⚪️静默 | 最新 0.17.4 在 5/26（区间外），本周无新 tag |
| Dify | ⚪️静默 | 最新 v1.14.2 在 5/19，"agent groundwork"蓄力 |
| LlamaIndex Agents | ⚪️静默 | 最新可见 3/16，已固化为 RAG/检索层 |

#### LangChain / LangGraph
**详见 TOP5 第 3 条。** 全量要点：年度大会 **Interrupt 2026（6/5）** 集中发布面向"Agent 开发生命周期"的产品：①**LangSmith Engine**（公开 beta）——自主 Agent 持续监控生产 trace，将失败聚类成命名 issue、对照代码诊断根因、自动提 PR 修复并生成 eval 覆盖；客户 Cogent/Campfire 已用它解决影响数千条 trace 的问题。②**SmithDB**——Rust 基于 Apache DataFusion + Vortex 构建，对象存储持久化 trace、小型 Postgres 做 metastore，核心体验提速最高 **15x**（P50 trace 树 92ms、单 run 71ms）。③**Managed Deep Agents**——API 优先托管运行时，支持 planning/工具/子 Agent 委派/写文件/长时任务，支持 AGENTS.md/skills/subagents/tools.json 项目结构。④**Sandboxes GA**——硬件虚拟化 microVM 隔离，支持 snapshot/copy-on-write fork、闲时暂停。⑤**Context Hub**——集中管理塑造 Agent 行为的文件，带版本/tag/评论。⑥**LLM Gateway**（私有 beta）——运行时治理层，硬性 spend 上限（命中返回 402）、PII/密钥脱敏、审计日志。GitHub 侧 6/5 发版 langchain-core 1.4.1 等多包。路线判断：LangChain 全面转向"Agent 运维/生命周期平台（LangSmith 为核心商业化载体）"。
- **关键数据**：SmithDB 提速最高 15x、P50 92ms/单 run 71ms（2026-06-05）；core 1.4.1 等 6/5 发版。来源 [Interrupt 2026 总览](https://www.langchain.com/blog/interrupt-2026-overview)、[GitHub Releases](https://github.com/langchain-ai/langchain/releases)
- **影响判断**：LangChain 把"可观测性→自动诊断→自动修复→治理→沙箱执行"全栈打通，竞争从"能不能搭"转向"能不能在生产里持续可靠运行并自我改进"。

#### Microsoft AutoGen（→ Microsoft Agent Framework）
**详见 TOP5 第 3 条。** 全量要点：AutoGen 已完成历史使命——**MAF** 已于 **2026-04-02 达 1.0 GA**（背景），将 AutoGen 多 Agent 编排与 Semantic Kernel 企业级基础收敛为单一平台。**Build 2026（6/2-3）** 增量：①**Agent Harness**（生产模式内建）——shell/文件系统访问、HITL 审批、长会话上下文管理变成一等公民，单方法把任意 chat client 变 Harness Agent。内建自动上下文压缩、FileMemoryProvider、FileAccessProvider、TodoProvider、AgentModeProvider（plan/execute）、AgentSkillsProvider、BackgroundAgentsProvider（子 Agent 并行 fan-out）、内建 Web search、沙箱 Shell 执行；中间件含 ToolApprovalAgent、OpenTelemetryAgent。②**Foundry Hosted Agents**——把本地 MAF Agent 打包成容器部署到 Foundry，scale-to-zero、状态跨缩容保留、每会话 VM 隔离 sandbox、OTel trace 直通 Application Insights，预计 **2026-07 初 GA**。③**CodeAct**——让模型写调用 `call_tool(…)` 的短 Python 程序一次跑完，替代多轮工具调用；随 `agent-framework-hyperlight`（alpha）发布，每次调用在隔离 Hyperlight micro-VM 内运行。
- **关键数据**：MAF 1.0 GA = 2026-04-02（背景）；Foundry Hosted Agents 预计 2026-07 初 GA。来源 [MAF @ Build 2026](https://devblogs.microsoft.com/agent-framework/microsoft-agent-framework-at-build-2026-announce/)、[Foundry Build 版](https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-build-2026/)
- **影响判断**：微软完成"框架统一→harness 标准化→托管化（Foundry）"三连。Hosted Agents 的 scale-to-zero+状态保留直接对标 LangSmith Managed Deep Agents。

#### Google ADK（Agent Development Kit）
ADK 本周有**重大版本动作**。Python 版 **google-adk 2.2.0 于 2026-06-04 发布**，且 PyPI 上 ADK 主线已进入 **2.0** 大版本（含从 1.x 的破坏性变更，涉及 agent API、event model、session schema——2.0 生成的 session 可被 1.28+ 读取但不兼容更老 1.x）。2.0 核心新特性：①**Workflow Runtime**——基于图的执行引擎，支持 routing、fan-out/fan-in、循环、retry、状态管理、动态节点、HITL、嵌套 workflow（向 LangGraph 式确定性编排靠拢）；②**Task API**——结构化 agent-to-agent 委派，支持多轮 task、单轮受控输出、混合委派、HITL、task agent 作 workflow 节点。2.2.0 增量含破坏性变更：**LlmAgent 默认模型从 gemini-2.5-flash 改为 gemini-3-flash-preview**（为 2026-10-16 gemini-2.5-flash 停服做准备）；AutoTracingPlugin（OTel 自动 instrumentation）、原生发射 OTel gen_ai.client.* 指标、A2A 消息 metadata 保留、compaction 摘要含 thoughts 和 tool calls。发布节奏约双周一次。
- **关键数据**：google-adk 2.2.0（2026-06-04）；主线 2.0 破坏性变更；默认模型 gemini-2.5-flash→gemini-3-flash-preview。来源 [ADK Releases](https://github.com/google/adk-python/releases)、[PyPI google-adk](https://pypi.org/project/google-adk/)
- **影响判断**：Workflow Runtime 补齐图编排短板，使 ADK 在企业级确定性流程更具竞争力；默认模型切 Gemini 3 Flash 是 Google 用框架默认值引导开发者上新模型的生态信号。

#### CrewAI
CrewAI 本周 GitHub 有**两个 in-window 预发布**。**6/3（17:41）** 预发布主打企业数据栈集成：新增**原生 Snowflake Cortex LLM provider**、**Databricks 集成指南**、crew trained agents 文件支持；并将 flow.py 拆为 DSL/definition/runtime 三层（架构重构），lazy-load docling 提升导入速度。**6/5（21:19）** 预发布（v1.14.7a1）聚焦**对话式 flow（conversational flow）**：新增 conversational flow traces、实现对话 flow 的 chat API、用 handle_turn 更新文档；在 LLM 事件中暴露真实 finish_reason、采样参数、response.id；将 flow DSL 单体拆成聚焦 decorator 模块；新增 NVIDIA Nemotron LLM 指南。结合前一周 checkpoint/恢复增强与 Agent Control Plane（ACP Beta）文档推进，路线清晰：深耕企业数据生态（Snowflake/Databricks）+ 做实对话式 flow 与可观测性 + 架构解耦 + 企业级 ACP。融资无本周新动态（累计约 $18M，A 轮 Insight Partners 领投 2024-10-22，背景）。
- **关键数据**：6/5 预发布 v1.14.7a1、6/3 预发布含 Snowflake Cortex/Databricks；累计融资约 $18M（背景）。来源 [CrewAI Releases](https://github.com/crewAIInc/crewAI/releases)
- **影响判断**：用 Snowflake/Databricks 原生集成+ACP 瞄准企业数据团队，conversational flow 补齐多轮对话能力，属"持续高频小步迭代+企业化转型"代表。

> 💤 本周静默：**OpenAI Agents SDK / Swarm**（最新 0.17.4 在 2026-05-26 区间外，本周无新 tag；但 workspace agents 免费期延至 2026-07-06 后转 credit 计费，是商业化信号）· **Dify**（最新 v1.14.2 在 2026-05-19，"agent groundwork"措辞显示蓄力，本周无新版本）· **LlamaIndex Agents**（GitHub releases 最新可见 2026-03-16，行业角色固化为 RAG/检索层，常被嵌入 LangGraph 等顶层编排框架）。

---

### 🏢 垂直 / 企业 Agent 产品（C 组）

**速查表（仅导航）**

| 对象 | 本周强度 | 一句话 |
|------|---------|--------|
| Perplexity | 🔥重大 | Computer 端云混合推理（联合 Intel，7月起） |
| Harvey | 🔥重大 | 接入 Mistral + 公开谈 Token 成本/模型路由降本 |
| Sierra | 🟢一般 | Outcomemaxxing 长文：按结果付费 + Saaspocalypse |
| Glean | 🔥重大 | 支持 Nemotron 3 Ultra + 发布 ADLC + 深化 Snowflake |
| Manus | 🟢一般 | 监管/地缘：中国新规阻断 Meta 收购（产品平静） |
| Devin | 🔥重大 | 详见 TOP5 + Carahsoft 政府合作 + CEO 发声 |
| Replit Agent | 🔥重大 | Shopify 店面集成 + SEO Agent，全业务闭环 |

#### Perplexity（Comet / 搜索 Agent / Computer）
本周核心动作集中在**Agent 基础设施的"混合推理（hybrid agentic inference）"**。6/2（北京时间 6/3），Perplexity 官博宣布：AI Agent 产品 **Perplexity Computer**（Mac 端"Personal Computer"）引入 **hybrid local-server 系统**，自 2026 年 7 月起**自动判断任务哪些部分在用户本地设备（端侧小模型）运行、哪些发往云端前沿大模型**。意图有二：①隐私——财务/健康/个人文件等敏感数据留在本地端侧模型处理；②**Token 效率/成本**——把 routine work 从昂贵云端卸载到用户设备。系统由 Perplexity 联合 **Intel** 发布，同一框架也可跑在其他本地硅片（含 NVIDIA RTX Spark）。CEO 本周定位"Computer"为"能帮助构建并运营整个业务"的 AI 平台。商业路线：Perplexity 正从"搜索引擎/浏览器"向"个人/企业自主 Agent 操作系统"转型——Comet 浏览器是入口、Computer 是执行层、端云混合是差异化叙事，本质也是降低自身 Token 采购成本的商业自救。
- **关键数据**：hybrid agentic inference "7月起"上线（2026-06）；Comet iOS 版 2026-03 完成全平台覆盖（背景）。来源 [CNET](https://www.cnet.com/tech/services-and-software/perplexity-wants-to-move-more-ai-work-from-the-cloud-to-your-computer/)（官博原文经 Cloudflare 拦截，由 CNET 转述确认）
- **影响判断**：头部 Agent 公司开始把"Token 经济学"作为产品架构的第一性约束，而非单纯堆云端算力；端侧 Agent 叙事+隐私合规卖点切中监管痛点。

#### Harvey（法律 Agent）
本周两条实打实动态。①**与 Mistral AI 达成合作**（6/2 周二官宣）：巴黎的 Mistral 将其模型接入 Harvey 平台，面向全球法律团队（合规/诉讼/合同分析）——这是 Harvey"多模型平台"战略延续，也是 Mistral 进军企业级/法律垂直、主打"主权 AI"的关键一步。②**Token 成本问题公开发声**：在 Artificial Lawyer 6/3 深度报道《Legal AI Has A Growing Token Price Problem》中，Harvey CEO Winston Weinberg 表示正"非常深入地思考 Token 成本及运行 Agent 的整体基础设施成本"，点名两项降本工作——(a)与 **Factory** 合作做"任务→模型"智能路由；(b)与 **LangChain** 合作，通过批处理 verifier+开源模型把"检查 Agent 性能（verifier）"成本**降低一个数量级**。商业路线：Harvey 正从"卖法律 AI 助手"演进为"管理 Token 经济学的法律 AI 基础设施层"。背景：in-house 客户占业务 **40%**；FT 报道估值已达 **$11B**、拿下全美一半最大律所。
- **关键数据**：估值 $11B、客户含全美半数顶级律所（[FT](https://www.ft.com/content/8514e586-96a9-4e74-b8c6-893a629ce5e4)，付费墙仅摘要）；in-house 占 40%（[Business Insider](https://www.businessinsider.com/wordsmith-ai-for-corporate-lawyers-70-million-series-b-2026-6)，已读全文）；与 LangChain "verifier 成本降一个数量级"（[Artificial Lawyer](https://www.artificiallawyer.com/2026/06/03/legal-ai-has-a-growing-token-price-problem/)）
- **影响判断**：接入 Mistral 既是多模型策略也是降低对 OpenAI/Anthropic 单一依赖与议价权的对冲；法律 AI 竞争已下沉到"单位经济模型"层面。

#### Sierra（客服 Agent）
本周最实在的公开动态是 CEO Bret Taylor 署名长文《**Outcomemaxxing**》（官博 2026-06-03），系统阐述 **outcome-based pricing（按结果付费）** 商业哲学的"18 个月复盘"。核心论点：①自 2024-12 首篇按结果付费博文以来，标普 500 涨约 30%，但 WCLD（最接近 SaaS 指数的云计算 ETF）却跌约 15%——市场正在内化"未来不是给团队的生产力工具（seat-based SaaS），而是交付结果的 AI Agent"，即"Saaspocalypse（SaaS 末日）"。②按结果付费"重写公司架构"，但比 seat/consumption 定价"运营、合同、会计上都复杂得多"。③引用 Madhavan Ramanujam 的 2x2 框架（软件 agency × 结果可归因性），Sierra 自我定位在"高自主+高可归因"右上象限。④金句："原始智能的成本必将下降…不会压缩的是结果（outcome）"。本周（6 月初）Sierra 还在 Skift Data + AI Summit 与 Amadeus 同台展示旅游业 production-ready Agent。
- **关键数据**：本周无新融资。背景：2026-05-04 融资 $950M、估值超 $15B，Tiger Global 与 Alphabet 旗下 GV 领投（[CNBC](https://www.cnbc.com/2026/05/04/bret-taylor-sierra-fundraise-openai.html)）；2026-02-06 披露 ARR 超 $150M。来源 [Sierra Outcomemaxxing](https://sierra.ai/blog/outcomemaxxing)
- **影响判断**："Saaspocalypse"是 2026 年企业软件估值重估的关键框架；按结果付费若跑通将重塑企业 SaaS 定价范式，但 Forrester Q2 2026 Wave 指出 Sierra 在对接遗留系统上"低于标准"，企业化深水区仍有短板。

#### Glean（企业知识 Agent）
Glean 本周动作密集。①**6/4 官宣**：支持 **NVIDIA Nemotron 3 Ultra** 开源模型，扩展平台模型选择，强调为"cost-effective agentic work"提供新开源选项——该模型驱动 Glean Assistant 与 Agents，强化多模型策略并与 NVIDIA 企业 AI 生态深度绑定。②同期推出企业级 **Agent Development Lifecycle（ADLC，Agent 开发生命周期）** 框架与配套平台能力，帮企业系统化部署 Agent——把"造 Agent"从手工作坊推向工程化流程。③深化 **Snowflake** 关系：被评为 2026 AMER Snowflake 年度产品创新合作伙伴，并在 Assistant 中上线 Snowflake 数据集成。④Glean×Valiantys 合作访谈（Diginomica 6 月初）把 Glean 定位为"AI 转型的骨干工具"，核心卖点是 permissions-aware Knowledge Graph（权限感知知识图谱），能把 Salesforce 商机↔ServiceNow 工单↔Jira ticket 语义连接。商业路线：Glean 正从"企业搜索"升级为"企业 AI 操作层"，多模型+开源（降本）+生命周期工程化（规模化）+生态合作四线并进。
- **关键数据**：估值 $7.2B、ARR 约 $300M（截至 2026-05，[Diginomica](https://diginomica.com/enterprise-ai-still-stuck-experimentation-valiantys-and-glean-think-they-know-why)，已读全文）；支持 Nemotron 3 Ultra + 发布 ADLC（BusinessWire 2026-06-04，原文被拒访问，经 [TipRanks](https://www.tipranks.com/news/private-companies/glean-advances-enterprise-ai-infrastructure-deepens-snowflake-ties-and-showcases-new-use-cases) 交叉确认）
- **影响判断**：支持 Nemotron 开源模型与 Perplexity 端侧、Harvey 模型路由同属"2026 Agent 降本主线"；ADLC 标志企业 Agent 进入工程化/可治理阶段；约 24 倍 ARR 估值显示企业知识 Agent 是最被资本认可的落地方向之一。

#### Manus（通用自主 Agent）
Manus 本周核心动态是**监管/地缘层面**而非产品。①2026 年 6 月初（6/1 多家媒体报道），**中国正式收紧对外投资规则**，将 NDRC 此前用于"拆解"Meta 约 $2B 收购 Manus 交易的"技术溯源（technology-tracing）"做法**制度化/法典化**，自 7/1 起生效——中国监管机构现已具备完整法律依据强制拆解涉及受限技术的境外交易。Meta 对 Manus 母公司（新加坡注册的 Monica）的收购因此被实质性阻断。②背景：2025-12 Meta 曾宣布收购 Manus（传闻估值 $2-3B），中国商务部/NDRC 介入审查，本周新规使交易"materially harder"。③产品侧本周相对平静，仅见生态小动作（Manus Shopify Connector 在 Product Hunt 上线等），无官方重大产品/融资公告。
- **关键数据**：Meta 收购传闻估值 $2-3B（2025-12，背景）；中国对外投资新规 7/1 生效。来源 [Asahi Shimbun](https://www.asahi.com/ajw/articles/16609074)、[Wikipedia Manus](https://en.wikipedia.org/wiki/Manus_(AI_agent))
- **影响判断**：Manus 案成中美 AI/科技脱钩标志性案例，催生中国"对外投资技术溯源"新法，影响所有跨境 AI 并购；通用自主 Agent 头部正越来越多被卷入国家级监管与地缘博弈。

#### Devin（Cognition / 独立追踪）
**部分详见 TOP5 第 1 条。** 本周三条硬动态：①**6/7 Devin Desktop 发布**（同一 Devin agent 跨 desktop/cloud/CLI 运行，Spaces 共享上下文，支持 ACP，预告 agent router 按性能/成本路由）。②**6/3 与 Carahsoft 战略合作**——Carahsoft 成为 Cognition"Master Government Aggregator"，通过 NASA SEWP V、NASPO ValuePoint、OMNIA Partners 等合同把 Devin 卖给美国联邦/公共部门，主打 **COBOL 与大型机现代化**；平台具备 **FedRAMP High 授权+零数据保留**，采用"compound AI"架构按任务选模型。③**6/1 CEO Scott Wu 发声**——反驳"取代程序员"叙事，称 Devin 能力在"初级到中级工程师之间"，专攻遗留迁移/平台过渡；披露在 Cognition 内部 **Devin 贡献 89% 的提交代码**。
- **关键数据**：背景（持续发酵）：2026-05-27 Series D $1B、估值 $26B；Devin 年化收入 $492M、同比 +1230%；企业使用量自 2026 初增长超 10 倍（[the-agent-report](https://the-agent-report.com/2026/06/cognition-devin-1b-26b-valuation-june-2026/)）。内部 89% 代码由 Devin 提交（[theaiinsider](https://theaiinsider.tech/2026/06/01/cognition-ceo-scott-wu-says-devin-ai-coder-is-a-buddy-not-a-replacement/)，已读全文）。客户：Mercedes-Benz、Goldman Sachs、Nubank、Ramp、Harvey、NVIDIA 等。
- **影响判断**：Devin Desktop 押注 ACP+多 agent 协同，意在做"管理 agent 舰队"的统一控制台；进军美国联邦市场（FedRAMP High+COBOL 现代化）打开高壁垒高粘性政府营收；$26B 估值约 53 倍 ARR，资本已按"重塑软件开发"定价。

#### Replit Agent
Replit Agent 本周连发**两个产品**，主题一致——"让普通人从一句话造出真实业务"。①**6/4 Shopify 店面集成**（官博）：通过与 Replit Agent 对话设计并上线自定义 Shopify 店面——描述想要的店，Agent 生成定制前端、创建新 Shopify 店、同一对话里加产品；"从第一句 prompt 到接到真实订单约 10 分钟"。区别于传统选模板：无需选 theme，Agent 按品牌/产品/调性生成，配合 Canvas 探索多变体，底层是真实可扩展 Replit 项目。②**6/3 SEO Agent 发布**（官博+X）：帮已发布 app 在 Web 搜索和 AI 搜索中被发现——全量扫描、按影响排序指出可发现性问题、一键修复；新增 Growth dashboard 监控流量；升级默认值——新 app 自带语义标签、无障碍、预填 meta 标签、Open Graph、robots.txt 与 sitemap.xml 开箱即生成。商业路线：Replit 把 Agent 从"vibe coding"向"全栈业务运营"延伸——造店（Shopify）+被发现（SEO/GEO）+收钱（Visa agentic payments）+部署闭环。
- **关键数据**：估值 $9B（截至 2026-03-11，[Tracxn]）；背景 2025-09 融资 $250M、估值 $3B；Shopify 店面"prompt 到接单约 10 分钟"（[Replit 官博](https://replit.com/blog/create-a-custom-shopify-store)，已读全文）；Visa 战略投资共建 agentic payments（[theaiinsider](https://theaiinsider.tech/2026/06/02/visa-invests-in-replit-to-build-ai-agent-payment-infrastructure/)，背景）。来源 [SEO Agent 官博](https://replit.com/blog/seo-agent)
- **影响判断**：战略锚点从"开发者工具"转向"普通创业者一站式业务平台"；SEO Agent 把 GEO（AI 搜索优化）纳入默认是前瞻渠道卡位；$9B 估值（较 2025-09 三倍跳升）+Visa 投资显示资本对"agentic commerce"的强烈认可。

---

### 🌐 浏览器 / 计算机操作 Agent + 中国 Agent（D 组）

**速查表（仅导航）**

| 对象 | 本周强度 | 一句话 |
|------|---------|--------|
| OpenAI Operator / ChatGPT Agent | 🟡边缘 | Agent 能力无更新；6/4 记忆系统 Dreaming V3 |
| Anthropic Computer Use | 🟡边缘 | 操作能力无更新；6/2 企业 admin 权限治理 |
| Google Project Mariner | ⚪️已退役 | 2026-05-04 停运，能力并入 Gemini Agent / Search AI Mode |
| 字节 Coze / 扣子 | 🔥重大 | 详见 TOP5（Coze 3.0 多人多 Agent 协作） |
| 智谱 AutoGLM | ⚪️静默 | 2 月刚发 GLM-5，处基座中段平台期 |
| 月之暗面 Kimi Agent | 🔥重大 | 详见 TOP5（Kimi Work 公测，估值逾 200 亿美元） |
| 阿里 Qwen Agent | 🔥重大 | 详见 TOP5（Qwen-VLA 具身智能，6/3） |

#### OpenAI Operator / ChatGPT Agent
**ChatGPT Agent（Operator 后继）本周无针对 Agent 能力的独立新版本/新功能发布。** 本周 OpenAI 最大动作是 6/4 推出的记忆系统重大升级 **"Dreaming"**（背景记忆合成架构），属个性化/记忆基础设施而非操作能力，但对 Agent 长任务上下文有间接增益。原文关键摘录：①"开始铺开一个更有能力、可扩展的记忆合成系统"，构建在 dreaming 之上的"显著更强、算力更高效的记忆架构"；②版本演进：2024=Saved memories；2025=Saved memories + Dreaming V0；**2026=Dreaming V3**；③"今日向美国 Plus/Pro 用户铺开，未来数周扩展到更多国家与 Free/Go 用户"；④对 Free 用户的工程突破："近期改进把向 Free 用户提供 dreaming 所需算力降低了约 5x"。技术/商业判断：OpenAI 本周把资源压在"记忆持久化"而非"操作能力"，反映其 Agent 战略从"会点会点"转向"懂你+长程上下文"。ChatGPT Agent（融合 Deep Research + Operator，2025-07-17 整合）本身处稳态运营期，本周无版本号变更。
- **关键数据**：Dreaming V3 上线 2026-06-04；Free 用户 serving 算力降约 5×。来源 [OpenAI ChatGPT Memory Dreaming](https://openai.com/index/chatgpt-memory-dreaming/)
- **影响判断**：记忆架构 5× 降本+面向免费用户铺开，是 Agent 规模化普及的基础设施信号——长程任务的"上下文连续性"将成 Agent 竞争的隐性护城河。

#### Anthropic Computer Use
**Computer Use 能力本周无独立新版本发布。** 据 Claude 官方 Release Notes 逐条核对，2026 年 6 月窗口内唯一条目为 **6/2：Enterprise 计划可用自定义角色管理 admin 权限**（custom roles + admin permissions，让成员无需成为 Owner 即可访问 billing/privacy 等管理域），属企业治理，与 Computer Use 操作能力无直接关系。Computer Use 近期里程碑均在区间外（背景）：3/23 在 Cowork 和 Claude Code 开启 research preview；2/17 Sonnet 4.6 升级 computer use；5/28 Opus 4.8 发布。技术/商业判断：Anthropic 本周把 Computer Use 作为已交付能力维持，新增量投入在企业级权限/合规，显示其 Agent 商业化重心在"企业可治理性"。
- **关键数据**：6/2 Enterprise 自定义角色 admin 权限；Opus 4.8 发布 2026-05-28（背景）。来源 [Claude Release Notes](https://support.claude.com/en/articles/12138966-release-notes)
- **影响判断**：Computer Use 处于"能力已交付、等模型底座升级带动"阶段；本周更新集中在企业 admin 治理，印证 Anthropic 走"企业合规优先"路线，与 OpenAI 的消费级记忆路线形成对照。

#### Google Project Mariner
**Project Mariner 已于 2026-05-04 正式停运（discontinued），本周无任何动态——因为产品已不存在。** 据 PCMag（2026-05-07）与 Wikipedia 交叉确认：Mariner 于 2026-05-04 关闭，技术被并入其他 Google 产品，官方引导用户改用 **Gemini Agent** 处理 complex 网页操作任务。背景脉络：2024 年底 Google I/O 首次亮相，2025-05-20 I/O 2025 rollout 给 Google AI Ultra 订阅者，2026 I/O（5/19 公布）把 agent 能力整合进 Search 的"AI Mode"。自 5/4 起，Mariner 作为独立品牌终结，浏览器操作 Agent 衣钵由 Gemini Agent + Search AI Mode 承接。
- **关键数据**：停运 2026-05-04（[PCMag](https://www.pcmag.com/news/google-closes-project-mariner-web-browsing-ai-shut-down-earlier-this-week)、[Wikipedia](https://en.wikipedia.org/wiki/Project_Mariner)）；I/O 2026 Search agent 整合 2026-05-19（[blog.google](https://blog.google/products-and-platforms/products/search/search-io-2026/)）
- **影响判断**：浏览器操作 Agent 独立品牌时代在 Google 侧落幕，能力下沉为平台默认功能，意味着"Agent 即功能"而非"Agent 即产品"；纯浏览器操作 Agent 若无差异化场景，易被超大平台入口级整合吞噬。

#### 字节 Coze / 扣子
**详见 TOP5 第 4 条。** 全量要点：**扣子 Coze 3.0 正式发布**（约 5/30，6/1 IT之家/东方财富密集报道，落本周窗口）。关键细节（读自原文）：①**全新 Agent 协作方式**——"可灵活组合一人+多 Agent / 多人+多 Agent"，多项目独立管理、资产自动沉淀；②**开放生态突破**——"能够接入 Claude Code、Codex CLI、OpenClaw 等本地 Agent"，打破生态壁垒（从封闭平台转向开放编排的关键信号）；③**行业专家技能**——内置自媒体、法律、金融、互联网、医疗健康等垂直专家 Agent 模板；④**跨端与本地能力**——"支持手机电脑跨端同步，可授权 Agent 处理本地文件"。版本脉络：2024-02 初版→2026-01-19 2.0（引入 Agent Skills 和 Agent Plan）→本周 3.0。
- **关键数据**：Coze 3.0 上线（[腾讯新闻/IT之家](https://news.qq.com/rain/a/20260601A07WH900)、[东方财富](https://finance.eastmoney.com/a/202606013756095091)，2026-06-01）；前代 2.0 发布 2026-01-19（背景）。来源 [Coze 官网](https://www.coze.cn/)
- **影响判断**："多人+多 Agent 协作"是 Agent 产品形态范式升级，从"个人助手"走向"团队协作中枢"；主动接入 Claude Code/Codex/OpenClaw 等外部框架，意味着字节做"开放编排层"而非封闭花园，争夺 Agent 生态入口级地位。

#### 月之暗面 Kimi Agent
**详见 TOP5 第 4 条。** 全量要点：**Kimi Work 开启公测**（~2026-06-04，本周窗口内），同期月之暗面估值飙升至逾 200 亿美元。能力摘录（读自原文）："只需用自然语言描述目标，Kimi Work 就可以在用户的电脑上拆解任务、并行执行、调用工具、使用浏览器、创建和整理文件夹，并交付文档、表格、PPT 等工作产物"——具备**本地计算机操作 + 浏览器操作**能力的通用 Agent，直接对标 Claude Cowork / ChatGPT Agent。底层模型脉络（背景）：Kimi K2.6 已于 2026-04-20 发布并开源，Agent Swarm 架构支持 300 个子 Agent 并行、4000 个协调步骤；单工程任务可持续运行 12 小时、发起 4000+ 次工具调用；基准 HLE-Full（带工具）54.0、SWE-Bench Verified 80.2、SWE-Bench Pro 58.6。
- **关键数据**：Kimi Work 公测 ~2026-06-04（[东方财富/财联社](https://wap.eastmoney.com/a/202606043759654280.html)）；估值逾 200 亿美元（[Yahoo 财经](https://hk.finance.yahoo.com/news/月之暗面-kimi-work開啟公測-021438279.html)）；K2.6 SWE-Bench Verified 80.2（背景，[36氪](https://m.36kr.com/p/3775887908450819)）
- **影响判断**：Kimi Work 是国产"本地通用操作 Agent"商业化落地的标志性产品，直接对标 Claude Cowork/ChatGPT Agent；估值 200 亿美元 + 券商"商业化拐点"判断，显示资本押注 Agent 应用层变现拐点。

#### 阿里 Qwen Agent
**详见 TOP5 第 4 条。** 全量要点：通义千问 **6/3 发布具身智能新模型 Qwen-VLA（Vision-Language-Action）**，进军"物理世界 Agent"。技术深度摘录：①**架构**——"大脑+小脑"，大脑用 Qwen3.5 多模态模型作中枢（认知/理解/空间判断），小脑接入 **11.5 亿参数、基于扩散模型的动作解码器**（输出关节角度、底盘方向等连续物理参数，而非预测下一帧画面）；②**路线创新**——首创"VLA 大一统策略模型 + 扩散动作生成 + 仿真强化学习"融合路线；③**四阶段训练法**——T2A→CPT→SFT→RL；④**数据构成**——真机遥操作 74.2%（含内部超 1000 小时真机遥操作轨迹）、人类第一视角视频 6%、合成仿真 3.7%（仿真引擎已自动生成超 800 万条物理碰撞轨迹）、通用图文 8.5%；⑤**性能**——真实双臂机器人上强分布外泛化（没见过的玩具鸭/墨镜照样抓取），DOMINO 动态操控评测中无需微调即可实时拦截移动物体，超越一批专用模型。官方坦承局限：动作数据量级仍太小、多模态优化"左右互搏"、缺触觉反馈、长程任务仍是痛点。
- **关键数据**：Qwen-VLA 发布 2026-06-03；小脑动作解码器 11.5 亿参数；训练数据真机遥操作 74.2%/视频 6%/仿真 3.7%/图文 8.5%。来源 [OFweek 深度](https://m.ofweek.com/ai/2026-06/ART-201717-8420-30689246.html)、[搜狐](https://www.sohu.com/a/1031585578_122445228)
- **影响判断**：Qwen Agent 从"屏幕内操作"扩展到"物理世界具身 Agent"，是 Agent 边界外延的标志性事件；阿里用"统一基座收敛碎片化"复制大模型成功路径；同周国产 Agent 底层亦密集（阶跃星辰 Step 3.7 Flash 专为生产级 Agent 设计、400 tokens/秒、性能达 Claude Opus 4.6 的 97% 并全面开源）。

> 💤 本周静默：**智谱 AutoGLM**（6/1-7 无新版本/功能/基准；GLM-5 于 2026-02-11 刚发，处基座中段平台期，作为应用层产品依赖基座节奏，本周无独立迭代属正常周期）。

---

## 📋 关于本周报

- **数据口径**：本期覆盖 2026-06-01 ~ 2026-06-07 完整一周（上海时区）。所有"本周/过去一周"均指此区间，区间外内容标注"（背景，非本周）"。
- **图标说明**：🔥重大 / 🟢一般 / 🟡边缘 / ⚪️静默或已退役 / 💤 本周静默合并。
- **实质覆盖率**：28/28（100%），获取失败 0 个，远超 ≥80% 门控。有动态对象均经原文全文阅读并附 URL；关键数据交叉验证，付费墙/拦截源已注明仅摘要确认。
- **来源说明**：官方博客/GitHub release/论文/官方公告优先于二手新闻；GitHub/arXiv 数据直查实时页面。
- **下期预告**：MAF Foundry Hosted Agents 7 月初 GA、LangSmith Engine 转 GA 节奏、ADK 2.x 后续迭代、Dify"agent groundwork"是否兑现、智谱 GLM-5.x/GLM-6 发布时点、Kimi Work 正式版商业化定价。
