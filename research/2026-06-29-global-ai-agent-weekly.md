# 全球 AI Agent 赛道研究周报 · 第 4 期（2026-06-22 ~ 06-28）

> 生成日期：2026-06-29 ｜ 覆盖区间：2026-06-22（周一）→ 2026-06-28（周日）（上海时区）｜ 4 大板块共 28 个 Agent 对象


> **覆盖区间**：2026-06-22（周一）00:00 → 2026-06-28（周日）24:00（上海时区）
> **覆盖范围**：4 大板块共 28 个 Agent 研究对象（编码 Agent/CLI · 通用框架 · 垂直企业 · 浏览器操作+中国）
> **时间窗声明**：仅收录区间内真实公开动态；区间外旧闻仅作背景并标注"（背景，非本周）"；关键数据均附来源与日期，查不到如实标"未公开"。

## 本周一句话

> 编码 Agent 集体停下"刷分"、转向远程化与企业治理；通用框架在一周三爆安全漏洞后被迫补课；垂直企业 Agent 从"试点问答"升级为"按工作流定制+全员部署"；而中美两侧在 subagents/Agent Swarm 的技术路线上正惊人地趋同——本周的主线是**赛道从"模型能力竞赛"整体迈入"工程化、远程化、可治理化、商业化落地"的分水岭**。

## 🔥 本周 TOP 5

### 1. OpenAI 预览 GPT-5.6，把多智能体编排做进模型 ｜ 6-26

OpenAI 于 6-26（周五）预览发布 **GPT-5.6 系列**：旗舰 Sol、日常均衡档 Terra（性能接近 GPT-5.5 但便宜 2 倍）、低成本高吞吐档 Luna。与 Agent 直接相关的核心升级是引入全新 **"max" reasoning effort** 与 **"ultra" mode——通过调度 subagents（子智能体）来加速复杂任务**，把"多智能体编排"从应用层拼装下沉为模型原生能力。官方称 Sol 在 **Terminal-Bench 2.1（命令行工作流，需规划/迭代/工具协调）创下 SOTA**。定价（每百万 token，input/output）：Sol $5/$30、Terra $2.50/$15、Luna $1/$6。本次为"限定预览"：因网络安全能力顾虑，应美政府要求，初期仅通过 API 和 Codex 向少数受信任合作伙伴开放，OpenAI 罕见地公开反对"政府准入流程成为长期默认"。

↳ **为什么重要**：ultra mode + subagents 抬高了 ChatGPT Agent 在长程计算机操作任务上的天花板；限定预览+政府审查则是前沿模型发布首次出现"准入摩擦"，预示 agentic 网络安全能力进入监管视野。

来源：[OpenAI 官方博客](https://openai.com/index/previewing-gpt-5-6-sol/) · [MacRumors](https://www.macrumors.com/2026/06/26/openai-gpt-5-6-sol)

### 2. SpaceX 600 亿美元收编 Cursor，产品不减速反加速 ｜ 本周延烧

SpaceX 以 **600 亿美元全股票**收购 Cursor 母公司 Anysphere 的并购在本周持续发酵（交易本体 6-16，预计 2026 Q3 完成）。被收编后 Cursor 产品没有停滞反而加速云化与可定制化：**Bugbot 大幅升级**——平均审查时间从约 5 分钟降到**约 90 秒（3 倍+）**、每次审查找到的 bug 数从 0.56 升到 0.62（+10%）、每次运行便宜约 22%，由正在训练的自研 **Composer 2.5** 模型驱动；新增 `/review`（push 前跑 Bugbot+Security Review）。同时上线 Customize Cursor 统一面板（plugins/skills/MCPs/subagents/rules/commands/hooks）、`/in-cloud` 云子 Agent、本地↔云会话 handoff。

↳ **为什么重要**：标志 AI 编码工具从"独立 SaaS"进入"被超大型科技公司纳入战略版图"的整合阶段，同时产品向"团队级云 Agent 平台"升维。

来源：[Reuters](https://www.reuters.com/legal/transactional/spacex-buy-anysphere-60-billion-2026-06-16/) · [Cursor Changelog](https://cursor.com/changelog/bugbot-updates-june-2026)

### 3. Perplexity 推出 Computer for Counsel，通用 Agent 入侵法律垂直 ｜ 6-24

Perplexity 于 6-24 发布 **Computer for Counsel**（面向律师/法务的 AI Agent），由 **20+ 前沿模型**驱动、系统按任务自动选模型，覆盖法律研究、合同初审（contract triage）、监管监测、引文核查（citation review）、intake 处理等工作流。深度集成 Microsoft 365（Word 起草/SharePoint 取文件）、Google 工作区及 **400+ App Connectors**（Box、Carta、Clio、DeepJudge、Docusign、Ironclad、NetDocuments 等）；与 Midpage（判例/法规/citator）、Deel（合规数据）、LegalZoom（合同模板）合作；所有输出回链原文可核验。今日起向 Perplexity Enterprise 与 Max 订户开放。

↳ **为什么重要**：通用 Agent 巨头开始系统性切法律垂直、与 Harvey（$11B 估值）正面竞争，但用"通用 Computer + 连接器/合作方"横向打法降低自建法律内容门槛，对 Harvey 形成定价与分发双重压力。

来源：[Law.com](https://www.law.com/legaltechnews/2026/06/24/perplexity-ai-launches-computer-for-counsel-powered-by-legal-tech-integrations/) · [Pulse2](https://pulse2.com/perplexity-launches-computer-for-counsel-for-legal-teams/)

### 4. Agent 框架一周三爆安全漏洞，AutoGen Studio RCE 评分 9.8 ｜ 6-23

本周 AutoGen 最大事件是安全事故：AutoGen Studio 曝出**严重代码执行漏洞（CVSS 9.8）**——agent sandbox 未能正确隔离 AI 生成的 Python 代码，可绕过沙箱实现宿主级 RCE；默认配置下 Web UI（8081 端口）无需认证即可访问，扫描显示约 **4,200 个公网暴露实例**、估计 18,000+ 内网部署，受影响为 0.4.x 及更早全部版本。微软已发布 **0.4.8** 修复（默认启用 gVisor 沙箱、seccomp、非 root、强制 OAuth2/OIDC）。报道将其列为"一周内第三起 AI 框架被攻破"（前两起为 Mastra 被 Lazarus 利用、LiteLLM 进入 CISA KEV）。同期 Dify 修复路径穿越 CVE-2026-41948、CrewAI 三连安全修复（SSRF/symlink/credential 权限）。

↳ **为什么重要**：暴露多 Agent 框架"隐式信任 LLM 输出+弱隔离+暴露管理界面"的行业通病——Agent 框架选型必须把"沙箱架构/默认认证"作为硬性安全门槛。注：该 CVE 编号尚为占位、待 MSRC 官方交叉验证。

来源：[threat-modeling.com](https://threat-modeling.com/microsoft-autogen-studio-code-execution-june-2026/) · [Dify Releases](https://github.com/langgenius/dify/releases)

### 5. 智谱借出口管制卡位"Claude 平替"，市值冲上中国 AI 第三 ｜ 6-24

受地缘政治催化——6-12 美商务部以国安为由要求 Anthropic 限制外国公民访问最新模型并暂停两款海外服务，智谱于 6-13 迅速宣布 **GLM-5.2 全量开放、支持真正可用的 1M 上下文**。此后股价持续上涨，截至 6-24 市值达 **9693 亿港元**（一度越过万亿港元门槛），超过小米/网易/京东，并于 6-08 纳入恒生科技指数。GLM-5.2 定价约 $0.95/百万输入、$3/百万输出 token，较 Claude 4.6 便宜约 80%。旗舰 Agent 产品 AutoGLM 的竞争位势被底座能力跃升与"Anthropic 平替"叙事直接强化；CEO 张鹏明确公司现阶段聚焦 Coding 与 Agent。

↳ **为什么重要**：美国的出口管制反而把非美开发者推向 GLM，智谱精准卡位"Claude 平替"。隐忧明确：算力超卖致高峰期体验不稳、用户忠诚度低、Gartner 预警 2027 年 40% 代理型 AI 项目将被取消。

来源：[新浪财经/《豹变》](https://finance.sina.com.cn/jjxw/2026-06-24/doc-iniepkrp8152396.shtml) · [AutoGLM 官网](https://autoglm.zhipuai.cn/)

## 🧭 三大维度趋势

**学术研究**：本周无新 SWE-bench 突破分数刷新（官方榜单头部仍为 Claude 4.5 Sonnet 71.40 / Kimi K2.5 70.80），重心转向方法论——LangChain 的 RubricMiddleware（Deep Agent 用 rubric 自评迭代）、Google ADK 的 GEPARootAgentOptimizer 与 RubricBasedMultiTurnTrajectoryEvaluator，把"Agent 自我评估并收敛质量"从论文概念固化进生产中间件；OpenAI Sol 在 Terminal-Bench 2.1 创下 SOTA、Qwen3.7-Plus 的 ScreenSpot Pro 79.0（GUI 定位）代表"命令行+图形界面操作"成为新评测焦点。

**Agent 工程**：远程化与可治理化是双主线。Codex Remote GA + DigitalOcean 插件把执行面推向移动/云沙箱；Claude Code 深耕 CLI 级 MCP 鉴权、设备信任、子 Agent 权限；MCP 工具检索（tool search）在 Codex 中默认启用。开源侧 OpenCode（172k stars）上会话快照/V2 插件 API、Dify 推出 difyctl 命令行、CrewAI 转向 JSON-first 声明式 Flow——共同指向"Agent 工作流要能被代码/CLI/CI 无缝编排嵌入"。

**商业化落地**：资本与客户高度集中于垂直/企业 Agent——SpaceX $60B 收编 Cursor、Cognition/Devin $26B（$490M ARR、53x 倍数）、Harvey $11B（本周 Maddocks/WKB 两家律所 firmwide 部署）、Sierra $15B、Replit $9B；Glean 入选 Gartner "No-Code Agent Builders" 新兴市场象限 Market Shaper，标志企业 Agent 进入被分析师正式建类的成熟阶段。

## 💻 编码 Agent / CLI

本板块本周主线："封闭巨头走外延+治理、开源阵营拼平台化、商业进入战略并购整合期。"

### 速查表 · 编码 Agent

| 对象 | 热度 | 本周看点 |
|---|---|---|
| Cursor（Anysphere） | 🔥 | SpaceX $60B 收编延烧 + Composer 2.5 把 Bugbot 做到亚分钟（详见 TOP5） |
| OpenAI Codex / Codex CLI | 🔥 | Codex Remote GA + DigitalOcean 插件 + MCP tool search 默认 |
| Claude Code（Anthropic） | 🟢 | 企业治理深耕：CLI 级 MCP 鉴权、设备信任、子 Agent 权限修复 |
| OpenClaw（Agent OS） | 🟢 | 308 PR 高频迭代：Slack relay/Mattermost/按 DM 模型覆盖 |
| OpenCode | 🟢 | 会话快照与 revert、`--mini` 模式、V2 插件 API、172k stars |
| Cognition（Devin/Windsurf） | 🟡 | Devin Desktop v3.3.1018：ACU 用量可见、子 Agent 默认模型 |
| Hermes Agent（自进化） | 🟡 | 本周无新版本（v0.17.0 于 6-19，窗口前），主分支持续高频提交 |

### 详情 · 编码 Agent

**Cursor（Anysphere）**：详见 TOP 5。补充产品细节：Customize Cursor 新页面统一管理 plugins/skills/MCPs/subagents/rules/commands/hooks，可按 user/team/workspace 分层、自带 MCP，新增 Marketplace 排行榜与 Plugin canvases（Hex/Atlassian 预建模板）、Team Marketplaces 支持从 GitLab/BitBucket/Azure DevOps 导入；云 Agent 侧 `/babysit` 云端照看 PR、10 分钟内云端 dev 环境搭建+可复用快照。历史融资（背景，非本周）：$2.3B 轮、$29.3B 估值（2025-11-13）。

**OpenAI Codex / Codex CLI**：详见 TOP 5 主体。CLI 内核本周高频迭代——6-25 发布 rust-v0.142.2（MCP 工具默认启用 tool search #29486、macOS 鉴权支持系统代理/PAC/WPAD #26709、PowerShell 安全分类器无法检查区域强制需审批 #24092、OpenSSL 升级 3.6.3），随后 6-25~6-28 连续打出 0.143.0-alpha.16~29 预发布。产品面 6-22 发布 ChatGPT for iOS 1.2026.167（按主机人格设置 Friendly/Pragmatic、输入框直接编辑 goals、fork 会话回链原线程）。来源：[Codex Changelog](https://developers.openai.com/codex/changelog)、[GitHub Releases](https://github.com/openai/codex/releases)。

**Claude Code（Anthropic）**：本周走"企业治理+CLI 稳定性深耕"路线，CHANGELOG 高频迭代——v2.1.186（6-22）新增 `claude mcp login/logout`（CLI 级 MCP 鉴权，支持 `--no-browser` 经 SSH）、`!` bash 命令输出现触发 Claude 自动响应（Breaking）、修复命名子 Agent 的 `Agent(type)` deny 规则失效；窗口内连续发到 v2.1.195（新增 `CLAUDE_CODE_DISABLE_MOUSE_CLICKS`、修复中日泰无空格语言语音听写自动提交）。产品侧两条：6-23 Claude Tag in Slack（Team/Enterprise 可在 Slack 直接 @Claude 委派任务）、6-25 Trusted Devices for Remote Control（远程操控本地会话前需验证设备）。来源：[官方 CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)、[Release Notes](https://support.anthropic.com/en/articles/12138966-release-notes)。

**OpenClaw（Agent OS）**：保持"每周多发"高频节奏，最新预发布打于 6-28 23:19，审计记录覆盖 v2026.6.10..（commit 0a4d0da）共 **308 个合并 PR**。本周重点：更强渠道控制（Slack relay #94707、Mattermost 原生 `/oc_queue` #95546、按 DM 模型覆盖 #95120）、运维工作流（`openclaw agent --message-file` #93351、RAFT CLI 唤醒桥 #95497）、插件分发安全（官方插件外置 + 图标元数据 #95683/#95845）、Android 设置详情面板、Codex 部分增量与长上下文 prompt-cache 稳定性。来源：[GitHub Releases](https://github.com/openclaw/openclaw/releases)、[Releasebot](https://releasebot.io/updates/openclaw)。

**OpenCode**：本周三连发（6-25/6-24/6-21）。6-25 新增**会话快照（session snapshots）与 revert 控制**（可回滚到更早消息含文件改动）；6-24 最密集——新增 `--mini` CLI 模式、MCP server instructions 注入上下文、OpenCode 托管 provider 集成、TUI 可配置 diff 查看器、Desktop 移动端底部导航、Extensions 新增 **V2 插件 API（支持 Effect 与 Promise 插件）**；6-21 尊重配置的 agent 步数上限、为 GLM-5.2 新增 high/max 思考变体。GitHub Stars 据第三方榜单（6-18）达 **172,198**，居开源编码 Agent 榜首、支持 75+ providers。来源：[GitHub Releases](https://github.com/anomalyco/opencode/releases)、[MorphLLM 榜单](https://www.morphllm.com/best-ai-coding-agents-2026)。

**Cognition（Devin / Windsurf）**：通过 Devin Desktop（原 Windsurf，6-02 OTA 改名）的"Next"构建迭代——v3.3.1018（6-23）客户端显示 **Devin ACU 用量**（算力计量可见化）、Windows 上 `bash` 解析为 Git Bash、**子 Agent 可配置默认模型**、MCP 注册表缓存启动预热、新增 `attribution` 配置（可隐藏 commit 中的 Devin 提及）。本周无新 Devin 模型/新 SWE-bench 分。来源：[Devin Changelog](https://docs.devin.ai/desktop/changelog-next)、[SWE-bench](https://www.swebench.com/)。

**Hermes Agent（自进化）**：本周（6-22~6-28）无新版本 Release，最近一次正式发布 v0.17.0（v2026.6.19，发布于 6-19，窗口前 3 天）"The Reach Release"——自 v0.16.0 起约 1,475 commits / ~800 PRs / 245 贡献者，新增 iMessage（经 Photon Spectrum）、加入 Raft Agent 网络、桌面 App 实时子 Agent watch-window、**后台/异步子 Agent（`delegate_task(background=true)`）**、Automation Blueprints、可经 xAI Grok 调用 Cursor 的 grok-composer-2.5-fast（200k 上下文）、memory 工具升级为原子批量操作。本周主分支持续提交（v0.18.0 在路上但窗口内未 release）。来源：[GitHub Releases](https://github.com/nousresearch/hermes-agent/releases)、[主分支 commits](https://github.com/NousResearch/hermes-agent/commits/main)。


## 🧩 通用 / 自主 Agent 框架

本板块本周主线："一周三爆安全事件后的集体补课 + 声明式/可编程编排收敛 + 自评估成为框架级能力。"

### 速查表 · 通用框架

| 对象 | 热度 | 本周看点 |
|---|---|---|
| Microsoft AutoGen | 🔥 | AutoGen Studio RCE（CVSS 9.8），已发 0.4.8 修复（详见 TOP5） |
| Dify | 🔥 | 1.15.0：difyctl 命令行 + CoT 可视化 + 富 HITL 表单 + CVE 修复 |
| CrewAI | 🟢 | v1.15.0：JSON-first 声明式 Flow + DMN + 三连安全修复 |
| LangChain / LangGraph | 🟢 | 多核心包高频发版 + RubricMiddleware + Programmatic Subagents |
| OpenAI Agents SDK / Swarm | 🟢 | v0.17.7：可配置 WebSocket、缓冲式工具流、沙箱稳健性 |
| Google ADK | 🟡 | 本周无新 tag（v2.3.0 于 6-17，窗口前）；GEPA/E2B/mTLS 路线 |
| LlamaIndex Agents | ⚪️ | 本周无法核实到 Agent 专项重大动态（碎片化微版本） |

### 详情 · 通用框架

**Microsoft AutoGen**：详见 TOP 5。背景（非本周）：4-03 微软在 BUILD 2026 发布 Microsoft Agent Framework 1.0，把 AutoGen 与 Semantic Kernel 统一为单一生产级 SDK，AutoGen 作为独立研究框架的角色正被并入统一框架——本周安全事故会加速企业向有微软背书+强沙箱默认配置迁移。注：CVE 编号尚为占位符，需 MSRC 官方公告交叉验证以排除二手来源夸大。来源：[threat-modeling.com](https://threat-modeling.com/microsoft-autogen-studio-code-execution-june-2026/)。

**Dify**：发布重磅大版本 **1.15.0（6-25）**——①**difyctl 命令行客户端**：首次可从终端直接运行 apps/workflows，无需 Web UI，支持三平台单命令安装、二进制带 checksum，意味个人 Agent/脚本/CI 可直接调用 Dify 工作流（#37036/#37454）；②**CoT 思维链可见**：模型推理实时流式进入专用 thinking 面板、CLI 同样可见（#37460/#37828）；③更丰富的 Human-in-the-Loop 表单（支持下拉/文件上传，#36322）；④支持慢速长时模型（轮询机制等图像/视频生成不超时 #37462）。安全：修复 plugin-daemon 路径穿越 **CVE-2026-41948**，对 Firecrawl/Jina 等出站 HTTP 加固 SSRF 出口。来源：[GitHub Releases](https://github.com/langgenius/dify/releases)、[GHSA](https://github.com/advisories/GHSA-h666-98mq-949j)。

**CrewAI**：B 组本周迭代最密集，6-23~6-27 连续发版，主线收敛到 **v1.15.0（6-26 pre-release）/ v1.15.1a1（6-27）**，核心是 **JSON-first/声明式 Flow 架构转向**——unified declarative flow loading、declarative Flow CLI、对话式 Flow（CLI TUI 中 conversational flows + chat API）、FlowDefinition 体系大扩展、Implement **DMN mode**（决策模型与表示法）；工程化新增 Git 仓库初始化、CLI deploy 后打开部署页、typed output schemas。安全三连修复：SSRF redirect bypass（#6331）、symlink path traversal、credential 文件 owner-only 权限。GitHub Stars 约 54,242（6 月，二手约值）。来源：[GitHub Releases](https://github.com/crewAIInc/crewAI/releases)。

**LangChain / LangGraph**：主仓库高频小版本——`langchain` 6-22 发 1.3.11、`langchain-openai` 6-22 发 1.3.3、`langchain-anthropic` 6-26 发 1.4.8、`langchain-openrouter` 6-23 发 0.2.4，修复中含对 gpt-5.2/gpt-5.4 dated snapshots 的 provider strategy 检测（紧跟最新模型）；LangGraph 本周无新 tag（最近 1.2.6 于 6-18）。6 月 Newsletter 公布开源两大重点：**Deep Agents 的 RubricMiddleware**（rubric 自评迭代）与 **Programmatic Subagents**（从代码 dispatch 子 Agent，fan-out 后合成）；客户案例 Box 用 Deep Agents 提速 3X、Harmonic 用 LangSmith 留存提升 4X（厂商自述）。来源：[GitHub Releases](https://github.com/langchain-ai/langchain/releases)、[6 月 Newsletter](https://www.langchain.com/blog/june-2026-langchain-newsletter)。

**OpenAI Agents SDK / Swarm**：本周发布 **v0.17.7（6-24）**——可配置 WebSocket max_size（#3645）、缓冲式 Chat Completions 工具调用流式（#3506），及一批稳健性修复：沙箱缓冲/超时优化（#3642）、AdvancedSQLiteSession 写入原子性（#3349）、guardrail 并发取消（#3239）、消除 Realtime 多 Agent 工具派发歧义（#3441）、E2B 沙箱 PTY（#3610）。前一版 v0.17.6（6-19）新增 pre-approval tool input guardrails（#3487）。Swarm 已被 Agents SDK 取代、本周无独立动态。来源：[GitHub Releases](https://github.com/openai/openai-agents-python/releases)。

**Google ADK**：本周窗口内无新正式 tag（最近 v2.3.0 于 6-17，窗口外）。v2.3.0 路线参考：Create GEPARootAgentOptimizer（GEPA 根 Agent 优化器）、E2BEnvironment 远程沙箱工作区、Gemma4 支持、mTLS support in AgentRegistry/McpToolset；更早 v2.2.0（6-04）BREAKING——LlmAgent 默认模型改 gemini-3-flash-preview。E2B 远程沙箱与 mTLS 恰是 AutoGen 本周暴露安全短板的"正确解法"。来源：[GitHub Releases](https://github.com/google/adk-python/releases)。

**LlamaIndex Agents**：采用 monorepo 多包独立版本策略、发版极碎。本周窗口内未见明确的核心框架（llama-index-core）大版本或 Agent 专项大特性发布，GitHub releases 聚合页时间戳无法确认落在本周，故严格按时间窗标注**本周无法核实到重大公开动态**。其 Agent 能力以 AgentWorkflow + Workflow 事件驱动 + LlamaCloud（企业 RAG）为核心，差异化在企业数据接入而非多 Agent 编排创新。来源：[GitHub Releases](https://github.com/run-llama/llama_index/releases)。


## 🏢 垂直 / 企业 Agent 产品

本板块本周主线："通用平台 Agent 入侵法律垂直 + 护城河从模型能力转向连接器生态/企业上下文/治理合规。"本周有实质一手动态的对象 3 个（Perplexity/Harvey/Glean），其余 4 个重大动作均落在窗口前、本周为复盘期。

### 速查表 · 垂直企业

| 对象 | 热度 | 本周看点 |
|---|---|---|
| Perplexity（Comet/搜索 Agent） | 🔥 | Computer for Counsel 入侵法律垂直（详见 TOP5） |
| Harvey（法律） | 🟢 | Maddocks（6-22）/ WKB（6-23）两家律所 firmwide 部署 |
| Glean（企业知识） | 🟢 | 入选 Gartner No-Code Agent Builders Market Shaper（6-22） |
| Sierra（客服） | ⚪️ | 本周静默（融资/认证/合作均在窗口前） |
| Manus（通用自主） | ⚪️ | 本周无官方新发布；第三方估算 $450M 年化收入 |
| Devin（Cognition 独立追踪） | ⚪️ | 本周无新品；$26B/$490M ARR 里程碑被复盘确认 |
| Replit Agent | ⚪️ | 本周无新 changelog（最新止于 6-19） |

### 详情 · 垂直企业

**Perplexity（Comet / 搜索 Agent）**：详见 TOP 5。背景（非本周）：约 6-05 完成约 $200M 融资、估值约 $200 亿、ARR 约 $200M（The Information 转述）。其"通用 Computer + 垂直连接器/合作方"横向路线，与 Harvey 的纯法律原生路线形成分化。

**Harvey（法律）**：本周属"商业化落地"维度——客户侧 firmwide 采用密集：**Maddocks（澳大利亚律所）6-22 宣布 enterprise-wide 推广**、**WKB Lawyers（波兰/中东欧）6-23 宣布 firmwide 部署**，延续 6 月以来"律所全所采用"打法。同期博客主题聚焦"Legal Agents for Every Matter, Tailored to You"，产品叙事从"问答助手"转向"按 matter 定制的法律 Agent"。本周无新融资/产品，靠客户 logo 累积——这是法律 AI 龙头（$11B 估值，背景 3-25 $200M 融资）的稳态打法，但面对 Perplexity 入场需警惕中长期分发与定价压力；国际化明显（澳/波兰）。来源：[Harvey Newsroom](https://www.harvey.ai/newsroom)、[Harvey Blog](https://www.harvey.ai/blog)。

**Glean（企业知识）**：6-22 宣布入选 **2026 Gartner Emerging Market Quadrant for No-Code Agent Builders – Startup Vendors**，定位 **"Market Shaper"**。Gartner 将 NCAB 市场定义为"以 SaaS 交付、无需编码即可构建/发布/管理 AI Agent，可被 Copilot/ChatGPT/Gemini 调用"。CEO Arvind Jain 主张"光有易用性不够——需深度公司上下文、强治理、对业务系统安全访问、跨工作流行动能力"，把 Glean 定位为"企业 Agent 操作层"。背景（非本周）：ARR 跨过 $300M（5-28）、累计融资约 $765M。来源：[Glean 官方解读](https://www.glean.com/blog/gartner-no-code-agent-builders)、[Yahoo Finance](https://finance.yahoo.com/technology/ai/articles/glean-recognized-market-shaper-2026-140000063.html)。

**Sierra（客服）**：本周无重大公开动态——密集动作集中在窗口前（5-04 完成 $950M Series E @ $15B+、6-10 FedRAMP High、6-11 与 Kraken 合作切能源、6-12/6-15 CX 系列博客），当前处于"融资+认证+行业扩张"后的消化期。背景：ARR 已过 $150M、服务 40% Fortune 50、采用 outcome-based 定价（按解决结果计费，首年约 $200K–$350K+）；截至 6 月未发布 MCP server（多 Agent 编排生态潜在短板）。来源：[Sierra Blog](https://sierra.ai/blog)、[AI Agent Index](https://theaiagentindex.com/agents/sierra)。

**Manus（通用自主）**：本周无重大公开产品/融资动态（关键事件均在窗口前：Meta 收购被中国 NDRC 阻止 4-27、运营拆分完成 6-11、Manus 1.6 年初发布）。本周相关数据点：Sacra 估计 Manus 2026 年 6 月达约 **$450M 年化收入**（对比 2025 年 $127M，第三方估算非官方）。架构：多 Agent（orchestrator + browser/code/data/file 子 agent）、云端沙箱 VM、底层用含微调的 Qwen，总部新加坡，定价 $20–$200/月。处于"地缘政治后遗症消化期"，所有权悬而未决是企业采用顾虑。来源：[SSOJet 综述](https://ssojet.com/blog/what-is-manus-ai-agent-explained)、[Sacra](https://sacra.com/c/manus/)。

**Devin（Cognition，独立追踪）**：本周无新产品，但 $1B 融资/$26B 估值/$490–492M 年化收入里程碑（原报道 5-27）在窗口内被 AI Market Watch 等以正式 funding 条目重新确认深度解读（6-24）。关键数据：Lux/General Catalyst/8VC 领投、累计融资 >$2.5B、约 53x 倍数；**89% 的 Devin 自身代码提交由 Devin 完成**；标杆客户 Mercedes-Benz 用 Devin 把 8 个月遗留系统迁移压缩到 8 天，客户含 Goldman Sachs、NASA、US Army/Navy、Itaú。model-neutral 架构（自研 SWE-1.6 + 外部模型），强调"上下文工程"护城河。注：Cognition 长期对 SWE-bench 分数保持沉默。来源：[AI Market Watch](https://www.ai-market-watch.com/news/ai-coding-agent-devin-developer-cognition-raises-1b-at-26b-valuation-with-annual-nopxe9)、[AIWeekly](https://aiweekly.co/alerts/cognition-ai-secures-1b-as-devin-arr-hits-73m)。

**Replit Agent**：本周无新官方 changelog（最新止于 6-19，窗口内 6-22~6-26 均 404 确认）。窗口前紧邻动态：6-19 "Use Replit from Claude"（Replit 成为 Claude 的 connector，可在对话中创建/查询 Replit app）、Voice Mode 全计划可用、Apollo+Black Forest Labs MCP server；6-12 Package Firewall（安装前拦截被投毒依赖包）。背景：Agent 4 于 3-11 发布、同日 $400M D 轮 @ $9B；定价 Core $25/月。深度绑定 Anthropic 生态、押注"对话即产品"。来源：[Replit Changelog 6-19](https://docs.replit.com/updates/2026/06/19/changelog)、[Agent 4 发布](https://replit.com/blog/introducing-agent-4-built-for-creativity)。


## 🌐 浏览器操作 Agent + 中国 Agent

本板块本周主线："多智能体编排下沉为模型原生能力 + 独立 computer-use 产品加速被收编；中国侧模型即 Agent 底座的竞赛白热化。"

### 速查表 · 浏览器操作 + 中国

| 对象 | 热度 | 本周看点 |
|---|---|---|
| OpenAI Operator / ChatGPT Agent | 🔥 | GPT-5.6 ultra mode + subagents 把多 Agent 编排做进模型（详见 TOP5） |
| 智谱 AutoGLM | 🔥 | 借出口管制卡位 Claude 平替，市值冲中国 AI 第三（详见 TOP5） |
| Anthropic Computer Use | 🟢 | 企业治理多条：Trusted Devices、Claude Tag、API 限额上调 |
| 月之暗面 Kimi Agent | 🟢 | 苹果 WWDC 选 K2.6 作本地大模型旗舰演示（6-18 曝光） |
| Google Project Mariner | ⚪️ | 已于 5-04 关停、能力并入 Gemini/Antigravity |
| 字节 Coze / 扣子 | ⚪️ | 本周无独立重大公告（扣子 3.0 于 6-01 发布） |
| 阿里 Qwen Agent | ⚪️ | 本周无重大公告（Qwen3.7 系列密集发布后消化期） |

### 详情 · 浏览器操作 + 中国

**OpenAI Operator / ChatGPT Agent**：详见 TOP 5。补充：自动化红队投入 >700,000 A100-equivalent GPU 小时。Operator 独立产品已于 2025-08-31 关停、能力并入 ChatGPT Agent，CUA 模型经 Agents SDK 的 computer-use 工具对开发者开放（背景，非本周）；CUA 历史 benchmark：OSWorld 38.1% / WebArena 58.1% / WebVoyager 87.0%。来源：[OpenAI 官方](https://openai.com/index/previewing-gpt-5-6-sol/)。

**Anthropic Computer Use**：本周无 computer-use 专属新模型，但 Agent 基础设施与企业治理多条更新——6-25 Trusted Devices for Remote Control（远程操控本地 Claude Code 会话前验证设备）；6-23 Claude Tag（Slack 内 @Claude 委派任务）；6-26 Claude Developer Platform 全面上调 API 速率限制（Sonnet/Haiku 对齐 Opus，使用层级精简为 Start/Build/Scale 三档，同日弃用 Opus 4.7 fast mode）。Claude Code 密集迭代（2.1.187→2.1.195）含全屏鼠标点击控制、sandbox 凭据屏蔽、组织级模型限制、`/rewind`、流式响应 CPU 占用降低约 37%。节奏从"模型能力秀"转向"企业级治理与可靠性"。来源：[官方 Release Notes](https://support.claude.com/en/articles/12138966-release-notes)、[Releasebot](https://releasebot.io/updates/anthropic)。

**Google Project Mariner**：本周无重大公开动态——作为独立产品已于 **5-04 关停**，落地页写明技术已"voyaged to other Google products"，能力并入 Gemini app / Search AI Mode / Gemini Enterprise Agent Platform。相关背景：Gemini CLI 已于 6-18 对消费级停服并强制迁移到 Antigravity CLI。Google 的"浏览器/计算机操作 Agent"叙事已从独立 Mariner 转为"Gemini 原生 + Antigravity Agent 平台"形态。"消亡即融合"与 OpenAI 关停独立 Operator 如出一辙。来源：[官方落地页](https://deepmind.google/models/project-mariner/)、[The Verge](https://www.theverge.com/tech/925559/google-project-mariner-shut-down)。

**字节 Coze / 扣子**：本周无重大独立产品公告——最近一次重大版本"扣子 Coze 3.0"已于 6-01 全平台上线，本周处于常规迭代与运营期。背景：3.0 从"单一工具"向"新一代 AI 团队"跃迁，核心含多人多 Agent 协作、全新 Agent 架构、六大行业专家技能包、支持接入 Claude Code/Codex CLI 等外部工具链；官网本周仍持续更新文档与 release_note（音视频通话多情感音色、音乐搜索播放插件）。差异化在"应用编排层 + 字节流量分发"。来源：[扣子更新日志](https://www.coze.cn/open/docs/guides/release_note)、[新浪科技](https://finance.sina.com.cn/tech/digi/2026-06-01/doc-inhzwyqr2443757.shtml)。

**智谱 AutoGLM**：详见 TOP 5。补充数据：2025 全年营收 7.24 亿元（同比 +132%），其中 B 端本地化 5.34 亿（73.7%）；MaaS 平台 API ARR 达 17 亿元、一年提升 60 倍、付费开发者超 24.2 万。背景：AutoGLM 2.0 为全球首个手机智能体，端到端强化学习，单次任务成本约 0.2 美元（传统 API 的 1/10~1/20），全端适配手机/电脑/AI 眼镜。来源：[新浪财经/《豹变》](https://finance.sina.com.cn/jjxw/2026-06-24/doc-iniepkrp8152396.shtml)。

**月之暗面 Kimi Agent**：本周无新模型/新 Agent 版本，但获重量级"他方背书"——苹果在 WWDC 2026 特别讲座（乔布斯剧院）压轴演示用 **4 台 Mac Studio 集群、经 LM Studio 在本地跑起月之暗面万亿参数模型 Kimi K2.6**，借 macOS Tahoe 26.2 的 RDMA over Thunderbolt 实现微秒级跨机内存直读、约 1.5TB 统一内存，开发者实测约 28 tokens/s（6-18 曝光，新浪/IT 之家 6-22 转载）。背景：K2.6 于 4-20 开源（1 万亿参数 MoE、激活 320 亿、256K 上下文、Apache 2.0），主打长程编码（13 小时不间断、4000+ 工具调用）、Agent Swarm（最多 300 子 Agent 并行）、跨设备协作 Claw Groups（首批支持 OpenClaw）。来源：[IT 之家](https://www.ithome.com/0/965/722.htm)、[Kimi Blog](https://www.kimi.com/blog/kimi-k2-6)。

**阿里 Qwen Agent**：本周无新模型/新 Agent 重大公告，处于 Qwen3.7 系列密集发布后消化期。背景（均非本周）：6-02 发布多模态 Agent 基础模型 Qwen3.7-Plus（"One model. Sees, thinks, codes, acts."，SWE-bench Multilingual 75.8 / Pro 57.6 / Terminal-Bench 2.0 70.3 / ScreenSpot Pro 79.0）；6-03 千问全面开放第三方 Agent 与 Skill（瑞幸、东航首批接入）；Qwen3.7-Max（5-20/22）完成 35 小时全自主 Linux 内核优化任务、强调 cross-scaffold 跨框架一致性。Agent 战略最完整：模型层+生态层+框架层三线并进。来源：[威易网](https://www.weste.net/2026/06-02/Qwen3.7-Plus.html)、[AIBase](https://news.aibase.com/zh/news/28609)。


## 📋 关于本周报

- **数据口径**：覆盖 2026-06-22~06-28 完整一周；区间外动态标注"（背景，非本周）"。关键数据均附来源 URL 与日期，查不到如实标"未公开/未核实"。
- **图标说明**：🔥 重大动态 ｜ 🟢 一般动态 ｜ 🟡 边缘动态 ｜ ⚪️ 本周静默。
- **来源说明**：优先官方博客/论文/GitHub release/官方公告，二手新闻仅作交叉验证；关键数据尽量 2 个以上独立来源；存在争议或第三方估算处已显式标注。
- **覆盖**：4 大板块共 28 个 Agent 对象逐一覆盖；本周有实质一手动态约 16 个，明确静默并附原因约 12 个。
- **下期预告**：持续追踪 GPT-5.6 正式 GA 与政府准入框架进展、Hermes v0.18.0、OpenClaw 周迭代、智谱/Kimi 的"出海+平替"叙事，以及 Agent 框架安全补课的后续。

> 下周一同一时间，第 5 期见。
