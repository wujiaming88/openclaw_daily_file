---
layout: single
title: "全球 AI Agent 研究周报 · 第 6 期（2026-07-06 ~ 07-12）"
date: 2026-07-13 10:14:00 +0800
categories: [AI]
tags: [AI Agent, 周报, Claude Code, Codex, OpenClaw, 开源, Agent框架, 编码Agent, 行业观察]
header:
  overlay_image: /assets/images/posts/2026-07-13-global-ai-agent-weekly-header.png
  overlay_filter: 0.5
  caption: "AI Agent 赛道周度观察"
excerpt: "巨头同周押注'Agent 上云 + 后台长任务 + 人在回路审批'，编码 CLI 集体升维为 Agent OS，中国开源模型成西方 Agent 的高性价比底座。"
toc: true
toc_sticky: true
---

> **覆盖区间**：2026-07-06（周一）00:00 → 2026-07-12（周日）24:00（上海时区）
> **覆盖范围**：编码 Agent/CLI、通用 Agent 框架、垂直企业 Agent、浏览器操作与中国 Agent，共 28 个研究对象
> **时间窗声明**：本报只记录该区间内的真实动态；区间外信息标注"（背景，非本周）"，无动态明确标注，数据均附来源。

## 本周一句话

> 巨头在同一周把"Agent 上云、后台跑数小时、跨端、重大动作前人审"钉成了行业标准范式；编码 CLI 集体升维为可编排多子 Agent 的操作系统；而 GPT-5.6 与一批中国开源模型，正同时成为这场竞赛的共同底座。

## 🔥 本周 TOP 5

### 1. OpenAI 把 Operator、Codex、Atlas 收进一个 ChatGPT ｜ 07-09

7 月 9 日 OpenAI 第二场直播正式发布 **ChatGPT Work**——内建于 ChatGPT 的通用工作型 Agent，可在 web/mobile/desktop 三端运行，跨 App 收集信息，产出 sheets/slides/docs/web apps 等成品，并能把复杂项目拆成子步骤、自主执行数小时。同日随附三件套：Codex 并入全新 ChatGPT 桌面应用（旧版改名 ChatGPT Classic）；新增公测 **Sites**（把成果变成可分享 URL 的交互式站点）；桌面版内建 **browser + Computer Use**（GPT-5.6 驱动），并把 Atlas 浏览器能力并入 ChatGPT——官方明确"begin sunsetting the standalone Atlas browser"。模型底座同步发布 **GPT-5.6（Sol/Terra/Luna 三档）**，新增 **ultra 模式**默认并行协调 4 个 agent（可扩至 16）。

↳ **为什么重要**：Operator 作为独立品牌事实上终结、Atlas 下线，OpenAI 从"独立 agent 产品"转向"把 agent 能力沉进 ChatGPT 主入口"。GPT-5.6 Sol 在 OSWorld 2.0（62.6%）、BrowseComp（92.2%）刷新 SOTA，标志 computer-use Agent 从 demo 走向生产级。[OpenAI ChatGPT Work](https://openai.com/index/chatgpt-for-your-most-ambitious-work/)、[GPT-5.6](https://openai.com/index/gpt-5-6/)

### 2. Claude Cowork 上云，90% 用途不是写代码 ｜ 07-07

Anthropic 7 月 7 日发布《Claude Cowork is coming to mobile and web》，把 Cowork 从桌面扩展到 web + mobile + cloud：会话与文件跨端流转、关掉笔记本任务继续跑、Scheduled Tasks 可在无设备在线时执行、遇到需人类决策的节点推送到手机审批（"Nothing ships until you've reviewed and approved it"）。官方披露**超过 90% 的 Cowork 使用不是软件开发**，最大类别是业务运营与内容创作。同期还发布 **Claude for Government**（Claude Code + Cowork 进入 FedRAMP High 授权环境）与 Microsoft 365 写工具。

↳ **为什么重要**：与 OpenAI 隔两天同题竞争，"Agent 上云 + 后台 + 跨端 + 人在回路审批"成为 2026 下半年产品标准范式；"90% 非编码"证明 computer-use 已破圈成通用知识工作 Agent；抢滩 FedRAMP 高合规市场是 Anthropic 的差异化护城河。[Claude Cowork](https://claude.com/blog/cowork-web-mobile)、[Claude for Government](https://claude.com/blog/bringing-claude-code-and-claude-cowork-to-government)

### 3. Cognition SWE-1.7：基于中国开源模型，逼近前沿还便宜 ｜ 07-08

Cognition 7 月 8 日发布自研编程模型 **SWE-1.7**，已在 Devin 全形态上线、经 Cerebras 以 1000 TPS 推理。最硬的技术信号：**SWE-1.7 基于中国开源模型 Kimi K2.7 base 训练**，在已做过大量 RL 后训练的基座上仍取得大幅增益，"挑战了 post-training 天花板的观点"。官方 benchmark：FrontierCode 1.1 Main **42.3%**（vs GPT-5.5 43.0%、Opus 4.8 46.5%，上代 SWE-1.6 仅 9.4%）、Terminal-Bench 2.1 **81.5%**、SWE-Bench Multilingual **77.8%**；第三方测算成本约 **$1.97/任务**。

↳ **为什么重要**：西方顶级 Agent 公司把中国开源当高性价比底座，全球模型供应链正在重构；SWE-1.6→1.7 一个季度 4 倍提升说明 RL 远未见顶；1000 TPS + $1.97/任务正面回应了"Agent 经济可行性"难题。[Cognition SWE-1.7](https://cognition.com/blog/swe-1-7)

### 4. 腾讯拟 $2B 收购 Manus，Agent 成国家级资产 ｜ 07-10

据 FT 独家（the-decoder 等多源 7 月 10 日转载），**腾讯正洽谈收购 Manus 多数股权**成为最大股东。背景是此前 **Meta 对 Manus 的 $2B 收购被中国监管当局叫停并勒令解除**（2026 年 4 月以"违反投资规则"为由封杀，并对创始人肖弘下达出境禁令）。本轮由腾讯、真格、红杉 HSG 加管理层按同样 **$2B 估值**回购，Benchmark 预计不参与；Manus 最新年营收接近 **$5 亿 ARR**，继续从新加坡独立运营，腾讯计划把 Agent 嵌入微信。

↳ **为什么重要**：Agent 已被视为国家级战略资产（报道类比"AI 时代的网络核武器"）；$5 亿 ARR 证明通用自主 Agent 已跑通规模化商业化；"嵌入微信"意味着技术可能触达十亿级用户入口。[the-decoder](https://the-decoder.com/tencent-moves-to-buy-majority-stake-in-manus-after-beijing-forced-meta-to-unwind-its-2-billion-deal/)

### 5. 中国双主线：智谱 314 亿港元配售，shell-agent 范式框架化 ｜ 07-09

资本侧：智谱 7 月 9 日在港交所公告配售最多 **1978 万股新 H 股、募资约 314.1 亿港元**，是国内大模型赛道上市后最大一笔股权融资，卡在上市半年基石解禁窗口落地、股价逆势走强。范式侧：**Dify v1.16.0-rc1 实验性推出 "Dify Agent"**，官方直言"shell-based LLM agent 范式带来 agent 能力的重大飞跃"、运行在 Linux 沙箱中——连以可视化工作流见长的平台也在拥抱 shell-agent + Skills 范式。

↳ **为什么重要**：314 亿港元配售标志中国头部厂商进入高强度资本竞赛、对标海外数十亿美元融资；Dify 的转向说明"沙箱内 shell agent + 可分发 Skills"正成为框架层标配，但 Dify 坦承共享沙箱、隔离未就绪，暴露多租户安全仍是全行业未解难题。[智谱配售公告](https://www.stcn.com/article/detail/4008146.html)、[Dify Agent](https://github.com/langgenius/dify/releases/tag/1.16.0-rc1)

## 🧭 三大维度趋势

**学术研究**：Cognition 用 SWE-1.7 给出一条重要经验——在已重度 RL 后训练的中国开源基座（Kimi K2.7）上继续 RL，FrontierCode 从上代 9.4% 跃升至 42.3%，直接挑战"post-training 天花板"的判断，并配套自压缩（self-compaction，模型学会总结工作状态并从摘要续跑以突破上下文窗口）、跨三洲多集群容错 RL 训练等方法。benchmark 战场本周同样密集：GPT-5.6 Sol 刷新 OSWorld 2.0（62.6%）、BrowseComp（92.2%）、Terminal-Bench 2.1（88.8%，ultra 91.9%）。

**Agent 工程**：编码 CLI 集体升维为 Agent OS/运行时——Claude Code 补齐 background daemon + agent teams + dynamic workflows + Remote Control，OpenClaw 做多 Provider 聚合并反向编排 Codex/Cursor，OpenCode 走 SDK 运行时化 + code mode MCP 编排。GPT-5.6（Sol/Terra/Luna）成为 Codex、OpenClaw 的共同基座，多 Agent 并发从实验走向默认（Codex 已为 Ultra 档并发加用量告警），成本治理成为下一战场。框架层则被 shell-agent + Sandbox + Skills 范式统一，Dify、ADK、OpenAI Agents SDK 同周强化沙箱化代码执行。

**商业化落地**：托管/控制面成为主战场——OpenAI 上线 hosted multi-agent beta、CrewAI 强化 Agent Control Plane（Cost Limit/Policies/可观测）、ADK 推出 ManagedAgent。同时"技术成功≠经济可行"被两家头部企业 Agent 公司同周点破：Sierra 提出"护城河是 harness 不是权重"，Glean 的 Arvind Jain 抛出"分诊 Agent 自动化 95% 事件、但月耗 $100 万推理成本高于 15 人团队"的警钟。资本侧则有腾讯 $2B 洽购 Manus、智谱 314 亿港元配售、Norm Ai $120M 法律独角兽、SpaceX 拟 $60B 收购 Cursor（背景）多点开花。

---

## 💻 编码 Agent / CLI

### 速查表

| 对象 | 热度 | 本周关键动作 |
|---|---|---|
| Claude Code | 🔥 | Cowork 上 Web/移动、CLI 2.1.207、Agent OS 四件套成形 |
| OpenAI Codex | 🔥 | 一周多版、GPT-5.6 接入、多 Agent 并发告警 |
| OpenClaw | 🔥 | v2026.7.1-beta.5、ClawRouter、编排 Codex/Cursor |
| Hermes Agent | 🟢 | 主仓单周 ~667 commits、v0.18.1；自进化模块本周静默 |
| Cursor | 🔥 | 3.11 Side chats + cloud agent hooks |
| Cognition/Devin | 🟢 | SWE-1.7 发布（详见 TOP5）；产品线企业化小迭代 |
| OpenCode | 🔥 | 一周 5 个 release、SDK 运行时化、code mode MCP |

### Claude Code：从编码 CLI 到 Agent OS

本周 Claude Code 及其衍生产品有两条硬动态。7 月 6 日 Anthropic 官网发布长文《The Making of Claude Code》，口述其如何从内部 CLI 工具演变为旗舰编码 Agent。7 月 7 日，Claude Cowork（把 agentic 能力搬到桌面/知识工作场景的产品线）正式扩展到 Web 与移动端，先从 Max 套餐灰度：会话与文件远程运行（beta）、跨设备同步、关掉笔记本任务继续跑、定时任务无需在线设备也能执行，Chat 与 Cowork 合并为统一入口；同日 Microsoft 365 连接器新增写入工具（起草/发送邮件、管理日历、更新 OneDrive/SharePoint，Teams 仍只读）。

CLI 层面，GitHub 官方 CHANGELOG 本周可见最新版本为 **2.1.207**，核心演进方向：Auto mode 在 Bedrock/Vertex/Foundry 上免 opt-in 开放；**agent teams（多 Agent 编排/teammate mailbox）、background agents（后台守护进程）、dynamic workflows（可配 small/medium/large 的 Agent 数量）、Remote Control（手机/Web 远程操控本地会话）** 持续加固；默认权限模式从 "default" 改为 "Manual"（2.1.200）；Bedrock/Vertex/AWS 平台默认模型切到 Claude Opus 4.8。

- **关键数据**：CLI 最新版 [2.1.207](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)（GitHub CHANGELOG，读取于 2026-07-13）；Cowork Web/移动端上线 2026-07-07、M365 写工具 2026-07-07（[官方 release notes](https://support.claude.com/en/articles/12138966-release-notes)）；《The Making of Claude Code》2026-07-06（[官网](https://www.anthropic.com/news)）。
- **影响判断**：background daemon + agent teams + dynamic workflows + Remote Control 四件套已成形，意味着 Anthropic 把长时任务、多 Agent 协作、跨设备远控当作产品主线；Cowork 上 Web/移动是把这套能力向非工程师人群渗透，编码 Agent 的护城河正外溢到通用知识工作。

### OpenAI Codex：每日 alpha、双日 stable 的最激进节奏

本周是 Codex CLI 高频发版周，窗口内正式 release 有 **rust-v0.143.0（07-08）、v0.144.0（07-09）、v0.144.1（07-09）**，另有 0.145.0-alpha.1~4 滚动预发布。核心演进：**GPT-5.6 家族接入**——Amazon Bedrock 新增 GPT-5.6 Sol/Terra/Luna 三变体并支持 max reasoning effort，0.144.0 统一了 Bedrock 上的显示命名；**多 Agent 并发**——选择 Ultra 推理档时高并发会弹用量告警，说明 Codex 已内建子 Agent 编排且把成本控制做进 TUI；**code-mode 默认走 hosted 托管模式**，所有审批触发 elicitation 暂停；**远程插件默认开启**（npm marketplace 来源）+ codex remote-control pair 手动配对码；MCP 工具默认走 tool search、支持交互式认证。

- **关键数据**：[rust-v0.143.0（07-08）/v0.144.0（07-09）/v0.144.1（07-09）](https://github.com/openai/codex/releases)（GitHub API 取精确时间戳，读取于 2026-07-13）；GPT-5.6 Sol/Terra/Luna 上线 Bedrock（PR #30285/#30467）。
- **影响判断**：Codex 的发版节奏在编码 Agent 赛道属最激进，且已把 GPT-5.6 + 多 Agent 并发 + 远程执行器 + 插件市场全部产品化，与 Claude Code 的"Agent OS"路线正面竞争。Ultra 档的并发用量告警是拐点信号：多 Agent 并行从实验走向默认，成本治理成为下一战场。

### OpenClaw：做 Agent 之上的聚合操作系统

OpenClaw 本周窗口内发布 **v2026.7.1-beta.5（07-11）**，是一次大版本累积。重头戏：**模型/Provider 大扩容**——新增 Featherless、Claude Sonnet 5、Mythos 5、Meta Muse Spark 1.1，以及自家路由层 **ClawRouter**（凭据级动态模型发现、OpenAI 兼容 + 原生 Anthropic/Gemini 传输、预算治理），并把 **GPT-5.6 设为新装默认**，配 `/think ultra`（Sol/Terra）与 `max`（Luna）；**Crestodian 对话式 onboarding**（全平台跑真实 agent-loop 安装流程）；**Control UI + 原生 macOS 聊天**；**Codex 互通**——Telegram 里私聊 `/login` 配对 Codex、`/steer` `/tell` 引导在跑的 run，并把 **Cursor Agent 接入为 autoreview 引擎**；崩溃循环恢复、control-plane-safe 模式、离线移动缓存、Apple Watch 语音回合等。

- **关键数据**：[v2026.7.1-beta.5 发布 2026-07-11、beta.2 2026-07-05](https://github.com/openclaw/openclaw/releases)（GitHub API 读取于 2026-07-13）；GPT-5.6 设为新装默认；集成 Claude Sonnet 5、Mythos 5、Meta Muse Spark 1.1、Featherless、ClawRouter。
- **影响判断**：OpenClaw 的差异化在"编排/互操作"——把 Codex 配对、Cursor Agent 当审查引擎、ClawRouter 统一多 Provider 路由，不与 Claude Code/Codex 正面拼编码能力，而做它们之上的聚合 Agent OS。这是编码 Agent 赛道从"单一工具"向"Agent 聚合器/操作系统"分层的明确信号。

### Hermes Agent：主仓狂奔，自进化模块停摆

需区分两个仓库。主仓 **hermes-agent**（Nous Research 的本地 Agent OS，GitHub Stars **213,757**，实时读取 2026-07-13）本周窗口内发布 **v0.18.1（发布日 2026-07-07）**——一次基础设施驱动的 patch tag：自 v0.18.0（7/1）六天内 main 累计约 **667 次 commit、涉及 ~990 个文件（+89.5k/−10.4k 行）**，含 Windows 安装器/更新器自愈、dashboard 与 gateway 修复、WhatsApp dashboard 配对、MCP 与 provider 修复。自进化仓 **hermes-agent-self-evolution**（Stars 4,642）本周无新 commit（最近 commit 为 2026-06-17，非本周）——该项目用 **DSPy + GEPA（Genetic-Pareto Prompt Evolution，ICLR 2026 Oral）** 自动进化 Hermes 的 skills/prompt/tool/code，纯 API 调用、每次优化 run 约 $2-10，目前仅 Phase 1（SKILL.md 进化）已实现，Phase 2-5 仍 Planned。

- **关键数据**：[hermes-agent Stars 213,757、self-evolution Stars 4,642](https://api.github.com/repos/NousResearch/hermes-agent)（GitHub API，2026-07-13）；[v0.18.1 发布 2026-07-07、窗口内 ~667 commits/~990 files](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.7.7)；[自进化引擎 DSPy+GEPA、~$2-10/run](https://github.com/NousResearch/hermes-agent-self-evolution)。
- **影响判断**：主 Agent OS 单周 667 次 commit 的工程强度是全组最猛之一，213K Stars 说明社区规模远超多数商业编码 Agent。但"自进化"这一最亮卖点本周并无新进展，显示 Nous 当前重心在把 Agent OS 本体做稳，自进化仍是研究性早期能力——叙事领先于工程落地。

### Cursor：Side chats 与可编程的 Agent 控制面

Cursor 窗口内发布 **3.11 版（changelog 标注 Jul 10, 2026）**，主题《Side Chats and Conversation Search》。核心功能：**Side chats（旁支对话）**——用 `/side`、`/btw` 或聊天面板 + 号，在不打断主 Agent 对话的前提下开一个可持久、可回访、可 @ 回主线拉 context 的完整 Agent 会话；**Conversation search**——在 Agents Window 用命令面板搜索 Agent 转录，本地索引可扩展到数千个会话；**重设计的 project/repo 选择器**（可直接建 project 并连 GitHub/GitLab/Azure DevOps）；**新的 cloud agent hooks**——新增 `beforeSubmitPrompt`、`afterAgentResponse`、`afterAgentThought`、`stop`、`subagentStart` 等钩子，可观测/控制 Agent 的 prompt、响应、思考、子 Agent、compaction、turn completion，用于构建自纠错循环。背景（非本周）：SpaceX 拟以约 $600 亿全股票收购 Anysphere（2026-06-16 宣布），此前 ARR 约 $20 亿。

- **关键数据**：[Cursor 3.11 发布 2026-07-10](https://cursor.com/changelog/side-chat)（官方 changelog）；[SpaceX 收购 Anysphere 报价 $60B 全股票、2026-06-16 宣布](https://www.cnbc.com/2026/06/16/spacex-spcx-cursor-acquisition-ipo.html)（背景，非本周）。
- **影响判断**：cloud agent hooks（可观测 prompt/思考/子 Agent 并能 build self-correcting loops）是关键信号：Cursor 把"可编程控制 Agent 内部循环"开放给团队，编码 Agent 正从黑盒走向可编排/可审计的平台层。叠加 $60B 被 SpaceX 收购的资本背书，Cursor 战略已超出 IDE，指向企业级 Agent 基础设施。

### Cognition / Devin：SWE-1.7 之外，产品线转向企业化治理

SWE-1.7 详见 TOP5。产品线方面，本周**无确认的全新产品发布**：Devin 官方 release-notes 在本窗口相邻的最新两条为 7 月 1 日与 7 月 3 日（均在窗口边缘或之前），含 Diff 行永久链接、Slack `!agent` 更名 `!normal`、Service User 通过 API 管理 automations、Git-backed Blueprints、安全扫描修复 API v3 等偏企业/工程化的小步迭代。唯一与本周强相关的公开动态是 **RAISE Summit 2026（7 月 8-9，巴黎）**：官方在会上复述 Devin 采用数据（13 个月内 ~65x 增长、企业客户含 Goldman Sachs/Palantir/Nvidia/Cloudflare），但其复宣的"最大升级"指 Devin 2.2（实际发布 2026-02-24，非本周），属峰会造势而非新发布。

- **关键数据**：[Devin release-notes 最新条目 2026-07-03/07-01，窗口内无新条目](https://docs.devin.ai/release-notes/2026)；[Devin 2.2 实际发布 2026-02-24](https://cognition.com/blog/introducing-devin-2-2)（背景，非本周）。
- **影响判断**：需警惕"峰会复宣"被误当"本周新发布"。Devin 本周真实动态是企业化小迭代（审计日志、ACU 治理、Blueprint 版本化），显示 Cognition 重心从"炫能力"转向"企业级可治理性/合规"，但缺乏本周里程碑说明其产品节奏慢于 Codex/Claude Code 的周更。

### OpenCode：开源阵营的可嵌入 Agent 运行时

活跃的 OpenCode 现位于 **`anomalyco/opencode`**（原 `sst/opencode` 已 301 重定向至此），GitHub Stars **185,109**（实时读取 2026-07-13）。本周窗口内高频发版：**v1.17.14（07-06）、v1.17.15（07-07）、v1.17.16/17/18（07-09）**。核心演进：Core 层新增 **code mode MCP adapter**（在受限沙盒中对连接的 MCP 工具运行编排脚本）、**session snapshots & revert**（可把会话连同文件改动回滚）、为 Claude Sonnet 5 开启 adaptive thinking；TUI 新增 **yolo mode（自动批准权限）**；**SDK 大幅扩展**——live event 订阅流、活动会话访问、会话运行时操作、分页持久会话历史、权限请求端点，把 OpenCode 做成可被外部程序驱动的 Agent 运行时；Desktop v2 UI 全面重构（多标签会话、可拖拽 tab、v2 review 面板、集成终端、WSL 安装流）。

- **关键数据**：[anomalyco/opencode Stars 185,109](https://api.github.com/repos/sst/opencode)（GitHub API，2026-07-13）；[窗口内 release v1.17.14~18](https://github.com/anomalyco/opencode/releases)（07-06 ~ 07-09）。
- **影响判断**：OpenCode 以 185K Stars 稳居开源编码 Agent 头部，本周主线是"SDK 运行时化 + code mode MCP 编排 + 多形态（TUI/Desktop/SDK）"——把自己打造成可被任何应用嵌入的开源 Agent 运行时，与 OpenClaw 的"聚合 OS"路线互补。session snapshots/revert 与 yolo mode 显示开源阵营在"可回滚安全网"与"全自动放权"两端同时试探。

---

## 🧩 通用 / 自主 Agent 框架

### 速查表

| 对象 | 热度 | 本周关键动作 |
|---|---|---|
| LangChain/LangGraph | 🟢 | 1.2.8/1.2.9 补丁、CLI 放开 api 上限，为 1.0 GA 收尾 |
| Microsoft AutoGen | ⚪️ | 事实停更，投入迁入 Microsoft Agent Framework |
| CrewAI | 🟢 | 1.15.2、强化 Agent Control Plane 与 Flow 流式协议 |
| Google ADK | 🔥 | v2.4.0、ManagedAgent、Workflow as Tool、mTLS 全铺开 |
| OpenAI Agents SDK | 🔥 | 一周 4 版、GPT-5.6 默认、hosted multi-agent beta |
| Dify | 🔥 | v1.16.0-rc1 推出 shell-based Dify Agent（详见 TOP5） |
| LlamaIndex Agents | 🟢 | 无发版但持续开发，深耕多模态 RAG + 模型集成 |

### LangChain / LangGraph：1.0 GA 临门一脚

本周 LangChain 阵营处于"1.0 正式版冲刺期"。核心开源框架 langgraph 窗口内连发两个补丁：**1.2.8（07-06）、1.2.9（07-10）**，另有 CLI **0.4.31（07-10）**。均为工程修复：1.2.8 修复"在全新线程上 updateState 会强制生成 snapshot 而非 stub checkpoint"的 bug，1.2.9 修复 delta channel 的 updateState 元数据/计数器问题，CLI 0.4.31 放开 langgraph-api 版本上限至 1.0.0 并支持预构建镜像部署——显示 LangGraph Platform（现更名 LangSmith Deployment）正为 1.0 GA 铺路。背景（非本周）：7 月 2 日官方博客发布 langchain/langgraph 1.0 alpha，把 langchain 包收敛到统一的 create_agent 抽象，目标"10 月底正式 1.0"。

- **关键数据**：[langgraph 1.2.8（07-06）、1.2.9（07-10）、CLI 0.4.31（07-10）](https://api.github.com/repos/langchain-ai/langgraph/releases)；[langchain 主仓 Stars 141,612](https://api.github.com/repos/langchain-ai/langchain)（2026-07-13 实时）；[1.0 alpha 博客 2026-07-02](https://www.langchain.com/blog/langchain-langchain-1-0-alpha-releases)（背景）。
- **影响判断**：本周无功能级大新闻，但连续补丁 + CLI 放开 api 版本上限 = 1.0 GA 临门一脚。LangGraph 把 delta channel/checkpoint 稳定性作为生产级 agent 的核心竞争点，是整个"durable agent"赛道的风向标；14 万+ Stars 仍是通用 agent 框架的绝对头部。

### Microsoft AutoGen：事实停更，被收编进统一栈

本周 AutoGen 无重大公开动态。核心事实：microsoft/autogen 主仓**最后一次代码推送为 2026-04-15**，本周窗口内无任何 commit/release；最新正式版仍是 **python-v0.7.5（2025-09-30 发布）**，距今近 10 个月未发新版。这与微软 2025 年将 AutoGen 与 Semantic Kernel 融合、推出统一 "Microsoft Agent Framework" 的战略一致——AutoGen 作为独立研究项目已进入维护/淡出状态。0.7.5 曾集成的重点（GPT-5 model info、Anthropic thinking mode、MCP 升级、nested Team as participant）均为 2025 下半年成果，非本周。

- **关键数据**：[GitHub Stars 59,681、最后代码推送 2026-04-15、最新 release python-v0.7.5（2025-09-30）](https://api.github.com/repos/microsoft/autogen)；本周新版本/commit：无（未在窗口内检出）。
- **影响判断**：AutoGen 事实性停更是本组重要信号——大厂"实验性 Agent 框架"正被收编进统一商业化栈，独立 OSS 框架的生命周期在加速分化，对采用方是迁移风险提示。

### CrewAI：开源引流 + 企业控制面变现

CrewAI 本周有实质发布：**1.15.2（07-08）**，围绕 Flow（声明式工作流）与 Agent Control Plane（企业控制面）密集迭代。新特性：crew wizard 动态拉取最新 LLM 模型目录、支持 inline skill 定义、模板化 Flow action 输入、为 flows 定义 **stream frame 协议（流式帧协议）**、在 CrewDefinition 中为 tool/app 加类型。修复含：按精确 API key 缓存 model-catalog、修复 onnx 1.22.0 与 nltk 的 pip-audit 安全告警、拒绝自监听 flow 方法。文档层把 "Rules" 更名为 "Policies"（对齐新 dashboard）、记录 Agent Control Plane 中的 Cost Limit 规则类型。

- **关键数据**：[CrewAI 1.15.2 发布 2026-07-08](https://github.com/crewAIInc/crewAI/releases/tag/1.15.2)；[GitHub Stars 55,395](https://api.github.com/repos/crewAIInc/crewAI)（2026-07-13 实时）；融资/估值本周未见新披露（未公开）。
- **影响判断**：与 AutoGen 停滞形成鲜明对比，CrewAI 保持每周级发布节奏且强化企业控制面（成本/策略/可观测），是"多智能体协作框架商业化"最积极的玩家之一。stream frame 协议 + Cost Limit 显示其正把重心从"能跑"转向"生产可控可计费"。

### Google ADK：ManagedAgent 与全面 mTLS

ADK-Python 本周发布重量级版本 **v2.4.0（07-07）**。核心新特性：**ManagedAgent（由 Managed Agents API 支撑）**——把托管 agent 作为一等公民接入；**Workflow as Tool 核心特性**——工作流可作为工具被复用；**OpenAI Responses API support in labs**——首次引入对 OpenAI Responses API 的支持；**DaytonaEnvironment 远程沙箱工作区**集成；大量安全加固——为 DiscoveryEngineSearchTool/Google API tools/GDA client 加 **mTLS 支持**、DNS-rebinding 防护、config_path 路径遍历防护、YAML agent config 代码引用模块黑名单、ContainerCodeExecutor 默认加固；以及 Vertex AI session TTL、DeepSeek-V3 内联工具调用、Anthropic effort/thinking 参数传递。

- **关键数据**：[ADK-Python v2.4.0 发布 2026-07-07](https://github.com/google/adk-python/releases/tag/v2.4.0)；[GitHub Stars 20,576、pushed_at 2026-07-12](https://api.github.com/repos/google/adk-python)（2026-07-13 实时）。
- **影响判断**：ADK 本周是本组最活跃、功能最密集的对象之一。ManagedAgent + Workflow as Tool + OpenAI Responses API 支持，说明 Google 在"用开源 ADK 反向兼容竞品模型、再用 Vertex AI 托管变现"上加速。mTLS 全面铺开是企业级信号——Agent 框架竞争进入"安全合规"深水区。

### OpenAI Agents SDK：贴着平台的托管 Agent 运行时

OpenAI Agents SDK（Swarm 的正式继任者）本周发版最频繁，一周连发 4 版：**v0.17.8（07-06）、v0.18.0（07-07）、v0.18.1（07-09）、v0.18.2（07-11）**。关键内容：v0.18.0 把 **RealtimeAgent 默认模型升级为 gpt-realtime-2.1** 并新增 SQLAlchemySession 的 Unicode 存储；v0.18.1 **添加 GPT-5.6 模型默认值并迁移示例**，修复跨版本 cache-write usage、嵌套工具状态恢复；v0.18.2 **支持 GPT-5.6 request controls + 新增 hosted multi-agent beta 支持**——OpenAI 开始提供"托管多智能体"能力，同时大量 sandbox 重构（Daytona/E2B/Runloop/Docker/Unix PTY 任务归属与清理）；v0.17.8 加了无效最终输出恢复处理器、realtime 校验失败日志脱敏。

- **关键数据**：[v0.17.8（07-06）、v0.18.0（07-07，gpt-realtime-2.1）、v0.18.1（07-09，GPT-5.6 默认）、v0.18.2（07-11，hosted multi-agent beta）](https://github.com/openai/openai-agents-python/releases/tag/v0.18.2)；[GitHub Stars 27,854、open issues 仅 59](https://api.github.com/repos/openai/openai-agents-python)（2026-07-13 实时）。
- **影响判断**：一周 4 版、v0.18.1 出现 GPT-5.6 默认值，说明 OpenAI 已在窗口内发布/内测 GPT-5.6，Agents SDK 是其"最快贴合新模型的宿主"。hosted multi-agent beta 是拐点：OpenAI 从"客户端 SDK"迈向"托管多智能体服务"，与 CrewAI/ADK 的托管控制面正面竞争。

### Dify：连工作流平台也拥抱 shell-agent

主线详见 TOP5。补充细节：Dify v1.16.0-rc1（07-09 预发布）的 Dify Agent 像业界头部 agent 一样**运行在 Linux 沙箱中**，本次发布包含：**Dify Agent 构建器**（UI 里设 base prompt、上传 Skills 与文件、连接生态工具与知识库，还提供一个"帮你造 Agent 的 Agent"）；**Dify Workflow 集成**（工作流节点中调用已有或内联的 Dify Agent）；**新 web app 体验**（构建的 Agent 可发布为 web app）。官方明确风险警告：当前实验版**所有 Dify Agent 共享同一个沙箱**，任一 Agent 即可读取/干扰其他 Agent 环境与用户数据，"严格隔离将在未来版本实现"，因此仅应对可信用户开放。此 RC 还含大量 RBAC 迁移、MCP 支持动态 HTTP header、修复一处 SQL 注入。

- **关键数据**：[Dify v1.16.0-rc1 预发布 2026-07-09](https://github.com/langgenius/dify/releases/tag/1.16.0-rc1)；[GitHub Stars 148,613](https://api.github.com/repos/langgenius/dify)（2026-07-13 实时，本组最高）；依赖 pydantic-ai-slim 从 1.85.1 升至 1.102.0。
- **影响判断**：这是本组本周最具"范式意义"的动态——连以工作流可视化编排见长的平台也在拥抱 shell-based 自主 agent + Skills 范式，说明"沙箱内 shell agent + 可分发 Skills"正成为行业共识底座。14.8 万 Stars 使其成为本组人气第一；共享沙箱的安全短板则提示自主 agent 的多租户隔离仍是未解难题。

### LlamaIndex Agents：无发版，深耕多模态 RAG

LlamaIndex 本周无新 tagged release（最近正式版 v0.14.23，2026-06-24，在窗口之前），但主仓窗口内保持活跃开发（pushed_at 2026-07-11）。经 commits API 核查，窗口内确有合入，例如 2026-07-08 的 `fix(google-genai): don't send default params in gemini genconfig`（因 Gemini 3 系列收到 temperature 等默认参数可能报错，故移除以保向后兼容）。延续中的重点：llama-index-core 的多模态合成与多模态 query engines、为 FunctionTool 增加 DocumentBlock/VideoBlock 解析、workflow 深拷贝 initial_state 防跨 run 状态泄漏，以及集成层快速跟进新模型（llama-index-llms-anthropic 0.11.6 新增 Claude Opus 4.8 与 Claude Fable 5）。

- **关键数据**：[最新正式版 v0.14.23（2026-06-24）](https://github.com/run-llama/llama_index/releases/tag/v0.14.23)（背景）；[窗口内 commit：2026-07-08 gemini genconfig 修复 PR #22270](https://github.com/run-llama/llama_index/commit/67514f63410c6d4c2344e7ca14b3ea7214d0bb84)；[GitHub Stars 50,801](https://api.github.com/repos/run-llama/llama_index)（2026-07-13 实时）。
- **影响判断**：本周无发版但开发不停，实质是"稳态迭代"。它不追逐 shell-agent 热点，而是深耕多模态 RAG + 模型集成矩阵，走"数据层护城河"的差异化路线；对采用方的价值在于对最新模型（Gemini 3/Claude 新款）的快速兼容与多模态合成能力。

---

## 🏢 垂直 / 企业 Agent 产品

### 速查表

| 对象 | 热度 | 本周关键动作 |
|---|---|---|
| Perplexity | 🟢 | 秘密研发编程工具 "Teammate"，剑指 Cursor/Codex |
| Harvey | 🟡 | 自身静默；竞品 Norm Ai $120M/$1.2B 独角兽入场 |
| Sierra | 🔥 | 官方博客《AI-pilling our company》，提出 harness 护城河 |
| Glean | 🔥 | Arvind Jain 抛"$1M 月成本>15 人团队"经济性警钟 |
| Manus | 🔥 | 腾讯拟 $2B 洽购多数股权（详见 TOP5） |
| Devin | 🔥 | SWE-1.7 发布（详见 TOP5） |
| Replit Agent | 🟡 | 产品静默；创始人入选 Endeavor、约旦授勋 |

### Perplexity：从搜索/浏览器切入编程 Agent

本周最重磅信号来自 **Business Insider 独家（07-08）**：Perplexity 正秘密研发内部 AI 编程工具，代号 **"Teammate"**，剑指 Cursor、Claude Code 和 Codex。据知情人士及内部截图，Teammate 自 **2026 年 5 月起** 已在工程师内部使用，定位"长周期工程工作"——原文引内部公告"owning projects, investigating issues, and monitoring services"。关键特征：**模型无关（model-agnostic）**，不绑定任何单一底层大模型；预计将与 Comet 浏览器集成，但官方尚未公布公开发布时间表。路线信号：CTO Denis Yarats 在上线前几周向工程师喊话"到年底或更早"软件工程师应"stop looking at code"，并反驳 AI 生成 slop 的指控——"只要代码通过质量检查，slop 就不会成为问题"。产品侧：Comet 浏览器 iOS 版（26.26.0）本周于 App Store 推送更新（因 Cloudflare 拦截未能读全文，标注待核）。

- **关键数据**：[Teammate 内部启用 2026 年 5 月、模型无关架构](https://www.businessinsider.com/perplexity-building-ai-coding-tool-take-on-cursor-and-openai-2026-7)（BI 2026-07-08）；Perplexity 估值 $20B（2025 年融资轮，背景）；Comet iOS 版本号 26.26.0（待核）。
- **影响判断**：搜索/浏览器起家的 Perplexity 切入编程 Agent，是"通用 AI 公司向高价值垂直 Agent 收敛"的又一信号——编程是当前商业化最快的 Agent 场景。model-agnostic 架构是差异化卖点（对冲底层模型风险）。CTO"年底停止看代码"表态激进，但仍是"报道"阶段、无公开时间表，需持续追踪。

### Harvey：自身静默，赛道被新玩法逼近

Harvey 本周无自身重大公开动态（无新融资/新产品官方公告落在窗口内）。但法律 AI 赛道出现直接冲击其竞争格局的事件：**Norm Ai 于本周内（LawNext 报道约 07-08）宣布完成 $120M C 轮融资、估值达 $1.2B（$12 亿），跨入独角兽门槛**，由 **Khosla Ventures 领投**（OpenAI 首个机构投资人首次投资 Norm Ai），回头客含 Blackstone、Bain Capital Ventures、Coatue、Vanguard 等；Norm Ai 自 2023 年中成立以来累计融资超 $260M。多篇报道将其定位为"叫板 Harvey 与 Legora"。关键差异化：Harvey/Legora 卖"给律师用的 AI 工具"，而 Norm Ai 把法律与监管推理嵌入**面向金融机构的 AI Agent（agentic law）**，并自建关联律所 Norm Law LLP（AI 原生、按成果计费而非按小时），客户合计管理资产超 $30 万亿。作为对比锚点（背景，非本周）：Harvey 于 2026 年 3 月完成 $200M G 轮、估值 $11B。

- **关键数据**：[Harvey $200M G 轮/$11B 估值（2026-03，背景锚点）、竞品 Norm Ai $120M C 轮/$1.2B 估值/累计 $260M（2026-07 本周）、Norm Ai 客户 AUM 合计>$30T](https://www.lawnext.com/2026/07/norm-ai-hits-unicorn-status-with-120m-series-c-at-1-2-billion-valuation.html)（LawNext）；Legora $600M D 轮/$5.6B（背景）。
- **影响判断**：Harvey 虽本周静默，但赛道正被"新玩法"逼近——Norm Ai 的"AI 原生律所 + 按成果计费"模式，从商业模型层面挑战 Harvey"卖工具给律师"的 SaaS 路线。Khosla 领投 + Blackstone 双重身份（投资人兼用户），说明资本押注"Agent 直接交付法律服务"。法律 AI 已形成 $1B+ 独角兽俱乐部（Harvey/Legora/Norm Ai），拥挤度与估值同步飙升。

### Sierra：护城河是 harness，不是权重

Sierra 本周发布罕见的内部实践博客《AI-pilling our company: lessons learned》（FourWeekMBA 于 07-11 深度解读，落在本周窗口），公开自家如何在 **600+ 员工、37 个集成系统** 上部署单一统一 Agent "**Pinecone**"。核心论点极具穿透力：**"前沿模型对大多数业务需求已经足够好，瓶颈已从'模型智能'转移到'业务上下文'（business context is the bottleneck, not intelligence）"**。自报数据：自 3 月 Pinecone 首次 commit 以来运行 **75,000+ 内部 Agent 会话**、服务 600+ 人、**70% 的 Pull Request 经 Agent 发起**、1 月试点某些任务录得 **5 倍生产力提升**。技术架构：Pinecone 构建于 **Claude Code + Codex** 之上，通过 **MCP Gateway** 统一路由——按任务把活儿分给最合适的模型，并做权限继承、策略强制、数据隔离与审计留痕。五课要点包括合一 Agent、主动而非被动、业务上下文是瓶颈、Agent 即 UI 系统即后端，以及"重结果非活动量"——Sierra 坦承"我们目前还没有好办法衡量真实产出"，直言会话数是"虚荣指标"，还透露正实验让 Pinecone"做梦（dream）"：每天反思工作并提议改进自身技能。

- **关键数据**：[75,000+ 内部会话、600+ 员工、70% PR 经 Agent 发起、5× 生产力（1 月试点特定任务）、37 个集成系统](https://sierra.ai/blog/ai-pilling-our-company-lessons-learned)（Sierra 官方博客，均为自报，2026-07）；[分析解读](https://fourweekmba.com/ai-sierra-pinecone-enterprise-ai-context-moat/)。
- **影响判断**：这是本组最有"拐点信号"价值的内容之一，把行业叙事从"卷模型"明确推向"卷 harness（上下文 + 权限 + 路由层）"——底层模型（Claude Code/Codex）被定义为"可互换的路由目标"，差异化上移到 MCP Gateway 这类集成/治理层。Sierra 诚实承认"无法衡量真实结果"，暴露整个企业 Agent 市场仍处早期。

### Glean：$1M 月成本高过 15 人团队的警钟

Glean 本周最实质的信号来自创始人兼 CEO **Arvind Jain 的 20VC 播客访谈**（相关深度报道 07-11 发布，落在本周窗口）。Jain 抛出反直觉案例：Glean 自建的**生产告警分诊 Agent 自动化了 95% 的运维事件，但每月消耗约 $100 万推理 token 成本——高于原本 15 人 on-call 团队的人力成本**。Agent 技术上成功、经济上却"初测不及格"。由此提出核心论点：**Agent 革命不是"裁员清洗"而是一场"成本与产能竞赛"**，用 AI 放大产出的公司会击败只想缩减薪资的公司。技术解法：**模型层正在商品化 + 智能路由**——他估计 90%+ 的企业用例可由多个模型（含开源）胜任，Glean 把大部分工作负载路由到开源模型、推理成本约为前沿 API 的 **1/10**，并点名 **GLM 5.2** 为 2026 年中的转折点，称 OpenRouter 使用量前六是中国模型。Glean 的产品回应是**自动模型路由**——把模型选择变成编排策略而非员工偏好。背景（非本周）：Glean 估值 $7.2B、累计融资超 $770M（待二次核实）。

- **关键数据**：[告警分诊 Agent 自动化 95% 事件/$1M 月推理成本>15 人团队、开源模型成本≈前沿 API 的 1/10、90%+ 用例可覆盖](https://windowsforum.com/threads/gleans-1m-monthly-ai-agent-cost-more-than-15-person-team.437077/)（转述 20VC 访谈，2026-07-11）；Glean 估值 $7.2B/累计融资>$770M（待核实）。
- **影响判断**："$1M 月成本>15 人团队"是整个企业 Agent 赛道的一记警钟——"技术成功≠经济可行"，完成率（95%）是虚荣指标，真正该看的是"每个已解决结果的全负载成本"。这与 Sierra 本周论点惊人一致：都指向模型商品化、价值上移到路由/上下文/治理层。点名 GLM 5.2 与"前六是中国模型"，反映开源（尤其中国开源）模型正改写企业推理成本结构。

### Manus 与 Devin：本周两大 TOP 事件

Manus 的腾讯 $2B 洽购与 Cognition 的 SWE-1.7 均已在 TOP5 详述。补充 Manus 一条产品侧小动态：本周新增 **/game-dev 技能**，可无需人工干预部署可运行的游戏玩法（二手来源，待核）。补充 Devin 训练方法细节：SWE-1.7 的四大训练要点为——保持熵 + 稳定训练（top-p 采样 replay 对抗 entropy collapse，配合 Muon 优化器）、跨三大洲多集群 RL 训练 + 容错、高质量数据管线（自动执行测试过滤、防 reward-hacking）、长周期任务的**自压缩（self-compaction）**（模型学会总结工作状态并从摘要续跑，突破原始上下文窗口）。

> 💤 完整深度见 [🔥 本周 TOP 5](#-本周-top-5) 第 3、4 条。

### Replit Agent：产品静默，创始人上升为区域标杆

Replit 本周无重大产品/融资公开动态。唯一落在窗口内的真实动态是创始人层面的荣誉：2026-07-07，Replit 联合创始人 **Amjad Masad 与 Haya Odeh 入选 Endeavor Entrepreneur**——这是 Endeavor 在约旦的首个独角兽入选、也是 Endeavor 全球第 100 个独角兽，两人同获 2026 届"Endeavor Outliers"称号。发布稿披露公司现状：Replit 全球用户已超 **6000 万**，与约旦政府合作的 AI 学习助手 **Siraj** 已服务当地公立学校 **10 万+ 师生**；约旦国王阿卜杜拉二世还向 Amjad 授予"阿卜杜拉二世二级卓越勋章"。融资/估值背景（非本周，存争议需交叉核实）：Tracxn 记录 Replit 最大一轮为 2026-03-11 的 $400M D 轮、估值 $9B，累计融资约 $922M；另有来源称已 IPO 估值 $14.5B，但未获权威二次印证，标注待核。

- **关键数据**：[创始人入选 Endeavor（全球第 100 个独角兽，约旦首个）2026-07-07、用户 6000 万+、Siraj 服务 10 万+ 师生](https://www.tradingview.com/news/reuters.com,2026-07-07:newsml_Zaw4mdpWr:0-zawya-founders-of-replit-amjad-masad-and-haya-odeh-join-the-global-endeavor-network/)（Reuters/Zawya）；[估值 $9B/D 轮 $400M（2026-03-11，背景）、累计融资 $922M](https://tracxn.com/d/companies/replit/)；$14.5B IPO 说法存争议待核。
- **影响判断**：本周 Replit 产品线静默，但创始人入选 Endeavor + 约旦国王授勋，是"AI-native 编程平台创始人上升为区域/全球标杆"的软实力信号，也强化其 MENA/新兴市场叙事（Siraj 教育部署 10 万+ 师生显示 vibe coding 能力正向政府/教育端渗透）。需注意估值数据在不同源间分歧较大（$9B vs 传闻 $14.5B），本报统一采用 Tracxn 的 $9B 为可靠锚点。

---

## 🌐 浏览器操作 Agent + 中国 Agent

### 速查表

| 对象 | 热度 | 本周关键动作 |
|---|---|---|
| OpenAI Operator/ChatGPT Agent | 🔥 | ChatGPT Work + GPT-5.6，Atlas 下线（详见 TOP5） |
| Anthropic Computer Use/Cowork | 🔥 | Cowork 上云 + Claude for Government（详见 TOP5） |
| Google Project Mariner | 🟢 | 打包进 Ultra（降价 $249→$99）+ Spark 后台 Agent |
| 字节 Coze/扣子 | 🔥 | 扣子 3.0，多 Agent 协作项目空间，纳入竞品 Agent |
| 智谱 AutoGLM | 🔥 | 314 亿港元港股配售（详见 TOP5）；产品侧安静 |
| 月之暗面 Kimi Agent | 🟢 | K2.7 Code 高速版转正、常驻 180 Token/s |
| 阿里 Qwen Agent | 🟢 | 拟人化/自建智能体 7/15 合规下线 |

### OpenAI Operator 与 Anthropic Cowork：本周两大 TOP 事件

OpenAI ChatGPT Work + GPT-5.6（Atlas 下线）与 Anthropic Claude Cowork 上云 + Claude for Government 均已在 TOP5 详述。补充 GPT-5.6 定价与更多 benchmark 供参考：**API 定价（每 1M tokens）** Sol $5 in/$30 out、Terra $2.50 in/$15 out、Luna $1 in/$6 out；**Codex 周活 >500 万，其中 >100 万人用于非软件工作**；GPT-5.6 Sol 在 Agents' Last Exam 53.6/52.7%（较 Claude Fable 5 领先约 13.1 点）、Artificial Analysis Coding Agent Index 80（SOTA）；GPT-5.4 将于 2026-07-23 退役、GPT-5.5 保留；安全测试约 70 万 A100e GPU 小时黑盒红队。Anthropic 侧补充：上云 beta 先从 Max 计划开放，配套至 2026-08-05 的双倍用量额度；Claude for Government 含防篡改哈希链审计日志、两人审批、按拨款计费。

- **关键数据**：[GPT-5.6 API 定价、benchmark、安全测试](https://openai.com/index/gpt-5-6/)（2026-07-09）；[Codex 周活 >500 万](https://openai.com/index/chatgpt-for-your-most-ambitious-work/)（2026-07-09）；[Cowork 非编码用途>90%、上云 beta 从 Max 开放](https://claude.com/blog/cowork-web-mobile)（2026-07-07）。
- **影响判断**：完整判断见 TOP5。核心是 OpenAI/Anthropic 隔两天同题竞争，"Agent 上云 + 后台 + 跨端 + 人在回路审批 + 企业治理"成为 2026 下半年标准范式；企业侧 Auto-review/Compliance API 是大规模落地的关键闸门。

### Google Project Mariner：不单飞，打包进 Ultra

Project Mariner 本周无独立重大发布，主要以"被打包进 Gemini 消费订阅"的形态出现。据 Gemini 定价指南（07-11 更新）与官方订阅页（07-10 抓取），**Project Mariner（agentic browser control）已作为标准权益打包进 Google AI Ultra 计划**（$99.99/月起，较 I/O 2026 的 $249.99 大幅下调）。同一计划本周的真正新动作是 **Gemini Spark**——被定位为"24/7 background agent"，本周（约 07-08）在 Product Hunt 上线，仅限美国/英文，可跨 Workspace（Drive/Gmail/Docs/Calendar）执行多步后台任务，"checks with you before major actions"。相关背景：Gemini 3.5 Pro 据 TechTimes（07-08）目标 7 月 17 日发布，本周仍未 GA；Gemini 3.5 Flash 已于 2026-05-19 上线并内建 computer use 能力。

- **关键数据**：[Project Mariner 打包进 Google AI Ultra（$99.99/月起，顶配 $200/月）](https://felloai.com/gemini-pricing/)（2026-07-11）、[官方订阅页](https://gemini.google/subscriptions/)（2026-07-10）；[Gemini Spark：24/7 background agent，Ultra 专属，约 2026-07-08 上线](https://www.producthunt.com/products/gemini-spark)；Gemini 3.5 Pro 目标 2026-07-17（本周未 GA）。
- **影响判断**：Mariner 未单飞，而是被 Ultra 降价 + Spark 后台 Agent 组合"平台化"，Google 打法是把 agentic 能力做成订阅捆绑而非独立爆款。Spark 的"重大动作前确认"再次印证本周三巨头在"后台长任务 + 人在回路审批"上的路线趋同；Ultra 从 $249→$99 是激进价格战信号。

### 字节跳动 Coze/扣子：把竞品 Agent 拉进自己的协作层

**扣子（Coze）本周迎来 3.0 大版本，核心是从单 Agent 编排平台转向多 Agent 协作工作区**。据 53AI 深度实测（07-06）与官方文档，扣子 3.0 最重磅的是**「项目空间」（多 Agent 协作）**：拥有共享上下文、任务流、协作记录的真实工作区，人与 AI、AI 与 AI 可像飞书群聊一样对话、分工、交付。最杀手级能力是**可把不同厂商的 Agent 直接拉进同一项目组**——支持接入本地 Agent（明确点名 **Claude Code、Codex、OpenClaw**）、新建云端 Agent（等于租一台云电脑）、用官方职业模板 Agent。实测中主 Agent 会先做任务拆解 + 分配，遇关键信息缺失会先向用户确认再开工，多个子 Agent 并行执行后由主 Agent 自动汇总。同步更新：专家技能包、三端协同（网页/桌面/移动，手机端可审批发布）；内置"持续在线的 Coze Agent"具备长期记忆、云端工作台（云电脑 Ubuntu/云手机 Android/独立邮箱身份/日程），支持 Doubao-Seed、Kimi、GLM、Minimax 等模型切换，视频侧内置 Seedance 2.0；生态侧推出 Agent World。

- **关键数据**：[订阅套餐个人免费版 0 元、进阶 39.9 元/3 万积分、高阶 99 元/9.9 万积分、旗舰 199 元；云手机跑任务约 200 积分、制作一支视频约 6000 积分；支持 Doubao-Seed/Kimi/GLM/Minimax + 自带 API](https://docs.coze.cn/cozespace_start_use)（2026-07 抓取）；[53AI 深度实测](https://www.53ai.com/news/coze/2026070680379.html)（2026-07-06）。
- **影响判断**：扣子 3.0"把 Claude Code/Codex/OpenClaw 拉进同一项目组"是极具战略性的开放编排打法——把竞品 Agent 变成自己平台上的"打工人"，抢占 Agent 协作层入口。多 Agent 协作 + 主 Agent 自动拆解/确认/汇总，说明中国 C 端 Agent 已从"工作流搭建工具"进化到"开箱即用的 AI 员工团队"。积分制 + 云设备是中国特色商业化打法，与美国订阅制路线分野明显。

### 智谱 AutoGLM：产品侧安静，资本侧大动作

智谱本周的重大动态在资本侧（详见 TOP5：314 亿港元港股配售）。补充要点：配售 1978 万股新 H 股、配售价 1588 港元/股（对 7 月 8 日收盘价折价约 12.99%），由中金独家代理；融资卡在 **7 月 8 日上市满半年、首批基石投资者锁定期到期解禁** 窗口落地，近七成解禁基石股东公开表态长期持有不减持，股价逆势走强（7 月 9 日配售公告后盘中一度涨超 16%-20%）；同时 A 股科创板 IPO 辅导已完成（拟募资 150 亿元）。财务基本面：2025 全年营收 7.24 亿元、净亏损 47.18 亿元。产品背景（非本周）：旗舰模型 GLM-5.2 于 2026-06-17 上线并开源（1M 无损上下文、Code Arena 全球可用模型第一）；AutoGLM（手机/PC 端 computer-use Agent）本周有开发者文档更新迹象但无独立重大版本发布。

- **关键数据**：[H 股配售 1978 万股/募资约 314.11 亿港元/配售价 1588 港元/折价 12.99%、7/8 基石解禁、7/9 盘中涨超 16%、2025 全年营收 7.24 亿元/净亏 47.18 亿元](https://www.stcn.com/article/detail/4008146.html)（STCN 2026-07-09）、[交叉印证](https://finance.sina.com.cn/roll/2026-07-09/doc-inihenca8321325.shtml)（新浪财经 2026-07-09）；GLM-5.2 于 2026-06-17 开源（背景）。
- **影响判断**：单笔 314 亿港元配售是国产大模型上市后最大股权融资，标志中国头部厂商进入高强度资本竞赛、对标海外数十亿美元融资。融资卡在基石解禁窗口落地且股价逆势上涨，反映资本市场对"国产大模型 + 国产算力闭环"叙事的强烈信心。智谱 Agent 战略以 GLM-5.2 开源权重为底座，走"更广分发→更大使用→更强付费转化"路径，与美国闭源订阅路线不同。

### 月之暗面 Kimi Agent：把高速版转正

**月之暗面本周核心动作是 Kimi K2.7 Code 高速版结束 Beta、成为 Kimi Code 常驻可选模式**。据 IT之家（07-11 报道，官方 07-10 晚宣布）与官方 API 文档，K2.7 Code 高速版与普通版是同一模型，但**输出速度约为普通版 5-6 倍**：常规编程场景约 **180 Token/s**，短上下文峰值可达 **260 Token/s**，支持 256K 上下文；订阅 Allegretto 及以上会员可在 Kimi Code CLI 通过 Coding Plan 使用。产品背景（非本周，构成技术底座）：K2.7 Code 于 2026-06-12 发布并开源——1 万亿参数 MoE（每 Token 激活 320 亿，384 个专家）、256K 上下文、Modified MIT 许可，推理 token 平均消耗较 K2.6 降约 30%，强制思考模式，并兼容 Claude Code/Cline/Roo Code 生态（经 Anthropic 兼容端点）。API 定价：输入 ¥6.5/M、输出 ¥27/M（≈$0.95/$4.00），高速版输出翻倍。

- **关键数据**：[K2.7 Code 高速版 5-6 倍速/常规约 180 Token/s/峰值 260 Token/s/256K 上下文、2026-07-10 结束 Beta 转常驻](https://platform.kimi.com/docs/guide/kimi-k2-7-code-quickstart)（2026-07；[IT之家 2026-07-11](https://linux.do/t/topic/2565512)）；[K2.7 Code 背景：1T 参数/32B 激活/384 专家/256K、2026-06-12 开源、推理 token 较 K2.6 降约 30%、API 输入 ¥6.5/M 输出 ¥27/M](https://www.aitoollab.cn/articles/kimi-k2-7-code-open-source-1t-coding-model-benchmark-202606/)（2026-06-13）。benchmark 均为官方自报。
- **影响判断**：高速版转正 + Coding Plan 订阅，说明 Kimi 从"开源刷榜"进入"编程 Agent 产品化运营"阶段，对标 Claude Code 但走开源低价 + 高速路线。兼容 Claude Code/Cline 生态是关键策略——"寄生 + 替换"海外主流 Agent 工具、降低迁移成本。180 Token/s 高速版以"速度 + 性价比"切成本敏感开发者，与智谱 GLM-5.2、DeepSeek 形成国产开源三强竞争。局限：benchmark 缺 SWE-Bench 等第三方独立验证。

### 阿里 Qwen Agent：拟人化智能体 7/15 合规下线

**Qwen 本周最受关注的动态是合规监管相关的智能体功能下线，而非产品升级**。据 InfoQ AI 周报与官方公告（07-04）：通义千问宣布其**"拟人化互动类智能体"及"用户自建智能体"功能将于 2026-07-15 全面下线**（公告在窗口前一天，但下线执行日 7/15 及本周行业讨论落在本期），届时用户无法访问已创建的智能体配置及历史对话、数据将被清除，官方已开通数据导出通道。关键背景：此非千问单独行动——**字节豆包几乎同时发布类似公告，同步于 7/15 终止智能体功能**；7 月 15 日正对应《人工智能拟人化互动》相关监管规定生效节点，部分高度拟人化智能体被用于情感陪伴甚至不当互动，平台借机合规整改。千问强调**核心大模型能力（文本生成、代码辅助、多轮对话）不受影响**，仅拟人化/自建智能体这一类被下线。另据行业消息，本周还传出"阿里内部禁用 Claude Code"（转向国产工具）。产品侧：据知乎（07-10）整理，阿里千问团队主推 **Qwen3.6-Plus/Qwen3.6-Max**（"走向现实世界智能体"，默认百万 token 上下文，强化工具执行/终端操作/长程规划），最新版本号（3.6 vs 3.7）本周官方口径不统一，标注待核。

- **关键数据**：[拟人化互动类/用户自建智能体 2026-07-15 全面下线、公告 2026-07-04、豆包同步 7/15 下线](https://www.jzl.com/industry-news/qwen-agent)（2026-07-04）、[InfoQ](https://www.infoq.cn/news/rs0HJTRdN6Pl88LIFh1a)；[Qwen3.6-Plus/Max 百万 token 上下文、强化 Agent 编程](https://zhuanlan.zhihu.com/p/670574382)（2026-07-10）；Qwen 最新版本号（3.6 vs 3.7）待核实。
- **影响判断**：中国 Agent 监管进入"实操下线"阶段，7/15《人工智能拟人化互动》规定使豆包/千问同步关停拟人化 + 用户自建智能体，是中国 Agent 赛道本周最强监管信号——拟人化情感陪伴类 Agent 首当其冲。须区分"被关停的社交拟人化 Agent"与"持续演进的编程/工具型 Agent"，Qwen 底层模型与编码 Agent 能力不受影响。"阿里禁 Claude Code"若属实，反映中美 Agent 工具在企业内部使用上的脱钩与国产替代加速。

---

## 📋 关于本周报

**数据口径**：覆盖 2026-07-06 ~ 2026-07-12 上海时区完整一周，共 28 个 AI Agent 研究对象（编码 CLI 7 + 通用框架 7 + 垂直企业 7 + 浏览器操作与中国 7）。区间外信息标注"（背景，非本周）"；无动态对象明确标注；关键数据均附来源与日期。

**图标说明**：🔥 重大动态 ｜ 🟢 一般动态 ｜ 🟡 边缘/间接动态 ｜ ⚪️ 本周静默。

**来源说明**：以官方博客、GitHub release/API、官方公告、一手报道为主，二手来源标注并尽量交叉验证；GitHub Stars/版本号为 2026-07-13 实时读取。部分数据（Replit $14.5B 估值、Qwen 版本号、Comet iOS 更新等）来源分歧或未获权威二次印证，已在文中标注"待核"。

**下期预告**：持续追踪 GPT-5.6 生态铺开与多 Agent 并发的成本治理、Gemini 3.5 Pro 是否 GA、Perplexity Teammate 是否公开发布、腾讯收购 Manus 的落地进展，以及中国 7/15 拟人化智能体监管新规执行后的连锁反应。
