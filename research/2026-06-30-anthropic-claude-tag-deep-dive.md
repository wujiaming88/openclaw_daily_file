# Anthropic「Claude Tag」深度技术研报

> 发布日期：2026-06-30 ｜ 主题：Anthropic 于 2026-06-23 推出的常驻 Slack「AI 团队成员」Claude Tag ｜ 聚焦维度：技术原理与工程架构

---

## 执行摘要（≤200 字）

Claude Tag 是 Anthropic 于 2026-06-23 推出、面向 Enterprise/Team 的「常驻 Slack AI 团队成员」，运行在 Opus 4.8 上，公开测试版。它用 @Claude 委派任务，区别于旧版「Claude in Slack」聊天机器人的核心是四点：多人共享单一身份（multiplayer）、跨会话持久记忆（按频道隔离）、ambient 主动监听、异步长任务与定时例程。工程上每个线程跑在 Anthropic 托管的临时沙箱里，对外请求经「Agent Proxy」按管理员规则默认拒绝、注入凭据；最关键的是「Agent 身份」模型——频道里 Claude 以自己的服务账号行事，权限随频道走而非随人走。旧版集成 2026-08-03 下线，30 天迁移窗口。安全界（Zenity/CybersecurityNews）已警示其从「治理用户」转向「控制 Agent 意图」的新型控制风险。

---

## 1. 产品形态与交互机制

### 1.1 定位：从「单用户助手」到「常驻虚拟员工」

Claude Tag 是 Anthropic「让团队与 Claude 协作的新方式」，首发落地 Salesforce 旗下的 Slack——Claude 以「团队成员」身份加入频道。管理员授予其选定频道访问权、并连接所需工具/数据/代码库后，频道内任何人都能 @Claude 委派任务，自己去做别的事。官方将其定位为「Claude Code 的演进」：让模型更主动、更适合整个团队协作。（来源：anthropic.com/news/introducing-claude-tag，2026-06-23）

Anthropic 给出的内部数据点很激进：**其产品团队 65% 的代码已由内部版 Claude Tag 生成**，模式正从工程扩散到追产品指标、处理 support ticket、定位疑难 bug。（来源：官方页 + venturebeat.com，2026-06-23/24；techtimes.com，2026-06-23）

可用范围：今日起对 **Claude Enterprise 与 Team** 客户 beta 开放，运行在 **Opus 4.8**。已上架 AWS Marketplace（via Claude Enterprise）。（来源：官方页；aws.amazon.com/about-aws/whats-new/2026/06/claude-tag-aws-marketplace）

### 1.2 交互范式：@Tag 委派 + 线程协作

- **启动会话**：在频道里 @Claude 并把需求写在同一条消息里（一个问题、一个任务、一个要排查的问题），即开启一个针对该线程的「工作会话」。频道里任何人都能发起。（来源：claude.com/docs/claude-tag/concepts/how-it-works）
- **进度呈现**：短问题直接回复；长任务先回一个「checklist（实时任务清单）」，Claude 边做边就地编辑勾选。注意 Slack 对「编辑消息」不发通知，所以线程看似「冻结」其实是在干活——这是一个重要的 UX 陷阱，官方专门提示「安静的线程通常意味着在做，而非卡住」。每次交付末尾带「Open session in Claude」只读链接，含所有工具调用全记录。（来源：how-it-works 文档）
- **多人接力 steer**：会话一旦在线程里激活，就「属于频道里所有人」。同事无需再次 @Claude，直接在该线程回复即可补充上下文/改变方向/接手结果。编辑或删除消息不会撤回已发给 Claude 的内容（无 rewind，要纠偏只能新发一条）。（来源：how-it-works 文档）
- **上下文窗口细节**：中途 @Claude 进入已有线程，会拿到从线程根起的最多 **50 条消息**（根 + 最早的回复，过滤掉其他 bot），长线程里你 @ 之前的最近消息可能落在窗口外——所以关键信息要复述。（来源：how-it-works 文档，Conversation context 段）

### 1.3 与旧版「Claude in Slack」的本质区别

旧版（2025-10 起两向连接、2026-01 互动式 Claude apps、Claude Code in Slack 把 @ 路由到 web 编码会话）本质是**单用户工具**：DM 或 @ 拿到按需帮助，按「你」的身份和会话运行。Claude Tag 加了一层旧工具难以维持的**持久上下文 + 记忆**，并把交互对象从「单个用户/单次任务」变成「一个频道共享的队友」。（来源：techcrunch.com，2026-06-23；venturebeat.com）

四个差异化能力（官方原文归纳）：

1. **@Claude is multiplayer**：一个频道内只有一个 Claude，与所有人交互；谁都能看它在做什么、从别人停下的地方接着干。
2. **@Claude learns over time**：跟随频道积累上下文，不必每次从头解释；获授权后还能自动从其他频道/数据源学习（**不报告私有频道内容**）。
3. **@Claude takes initiative**（ambient）：开启后主动推送它认为你需要知道的信息，跨频道/工具标记相关情报，跟进「沉默」的线程/任务。
4. **@Claude works asynchronously**：派完任务你去忙别的；它能给自己排期，自主推进项目数小时到数天。Anthropic 称内部「现在更多时间花在并行给许多 Claude 派活」。

（来源：anthropic.com/news/introducing-claude-tag）

> **关键区分（易混淆点）**：频道里的 Claude Tag = 管理员配的 Agent 身份；而 DM 里的 @Claude、以及把编码 @ 路由到 web 的「Claude Code in Slack」= 以**你自己的账号**运行。官方给的判别法：如果 @Claude 在你工作区里开的 PR 作者是**你本人**，那是 Claude Code in Slack，不是 Claude Tag 频道会话。（来源：agent-identity 文档）

## 2. 核心技术能力

### 2.1 持久记忆（persistent memory）

**记忆按频道划分**（不绑定个人）：公共频道产生的记忆会自动「升级」为全 workspace 共享（在 #data-eng 记下的决策，在 #analytics 提问时可用）；私有频道学到的东西只存入该频道自己的 store，不外湢。（来源：claude.com/docs/claude-tag/users/memory）

读/写规则（记忆隔离的技术边界）：

| Claude 工作位置 | 读取自 | 写入到 |
| :--- | :--- | :--- |
| 公共频道 | workspace 记忆 | 本频道笔记或 workspace 共享（均在 workspace store 内） |
| 私有频道 | 该频道记忆 + workspace 记忆（只读） | 该频道自己的 store |

DM 与其他 workspace 保持隔离。私有频道后来转公开，其私有期间的记忆不会随之迁移。（来源：memory 文档）

**记忆是「策展的笔记」而非 transcript**：三种积累方式——(1) 你明说「remember for this channel: …」；(2) Claude 工作中自发记下决策等事实；(3) 可读过往会话 transcript（但**不能全文检索**，要指定时间段/主题）。官方建议长 playbook 放仓库让 Claude 读，而非塞进记忆。管理员可在 admin-settings 查看各 scope 记忆文件，Owner 可编辑/删除。（来源：memory 文档）

> **隐私边界关键点**：「销售」用的 Claude 不会把记忆传给「工程」用的 Claude；ambient 也不报告私有频道。这是 Anthropic 应对企业「记忆串频道」担忧的核心设计。（交叉：官方页 + techcrunch.com）

### 2.2 环境监听（ambient / always-on）

ambient 是**可开关的模式**，开启后 Claude 从「被动响应」转为「主动响应」：不再等用户发起每次交互，而是主动监听会话、浮出相关信息、跟进停滞的工作。（来源：anthropic.com；zenity.io，2026-06-29；cybersecuritynews.com，2026-06-23）

技术上「常驻」的落地不是一个一直跑的进程，而是通过**例程（routines）** 实现的调度型 always-on。例程三种触发：

- **Scheduled jobs**：「每个工作日 9am 读本频道未关线程…逐条发一行状态」。默认 UTC，需显式写时区。
- **Watch channels**：监听指定频道，命中主题时在本频道汇报（「每天一次，有相关就发，没有就跳过」）。
- **Follow a PR**：订阅某个 PR，CI 完成或 review 落地时播报、失败时 @ 你。

例程用「频道的连接」与交互请求同权限；创建者离职例程继续跑，但创建者被移出频道则停止。（来源：claude.com/docs/claude-tag/users/proactivity）

> **技术含义**：ambient 把 Claude 从「调用才响应的函数」变成「持续观察信息环境、自主决定何时插话的代理」。VentureBeat 称这是「代理性（agency）的显著扩张」，也是治理难点所在。（来源：venturebeat.com）

### 2.3 跨频道上下文（cross-channel context）

上下文聚合与隔离同时存在：

- **聚合**：公共频道记忆自动全 workspace 共享；获授权后可跨频道/数据源拉上下文（「看 #data-eng 对这个了解多少」）。
- **隔离**：每个 Slack 线程 = 一个独立会话 + 独立沙箱；同频道两个线程互不共享 state。私有频道不外报；Agent 身份间记忆不互通。

（来源：how-it-works、memory 文档）

### 2.4 工具连接与 Agentic workflow

**连接对象**：代码库（GitHub，走 Claude GitHub App）、ticketing、数据仓库、监控、任意 HTTP API，以及 **plugins 与 skills**。个人在 claude.ai 配的 connectors（含 **MCP servers**）仅在 **DM** 生效，频道里只用管理员挂的服务账号连接。（来源：overview、agent-identity 文档）

> **是不是 MCP？** 是，但不止。文档明确提到 MCP（个人 connectors 含 MCP servers；Zenity 也提到「invoking an MCP server」）；但频道侧的「连接」是更广的 Access bundle 概念（凭据 + 允许主机规则），不限于 MCP 一种协议。（来源：agent-identity；zenity.io）

**Agent 如何规划与执行多步任务**：五步循环——(1) @ 启动会话或例程触发；(2) 为该线程构建隔离沙箱；(3) 在沙箱内用频道访问权跑工作循环、就地编辑 checklist；(4) 结果落在线程（回复/文档/图表/PR）；(5) 空闲期释放沙箱、线程保留，新回复重建沙箱。沙箱跑的是「与 Claude Code on the web 同一引擎」，所以产出是可工作产物（PR、文档）而非聊天。（来源：how-it-works 文档）

### 2.5 背后模型与编排

运行在 **Claude Opus 4.8**（`claude-opus-4-8`，2026-05-28 发布，1M 上下文，定价 $5/$25 每百万 token）。该模型在发布时同期推出 **Dynamic Workflows**（研究预览）：可在单个 Claude Code 会话内编排**数十到数百个并行 subagents**，自动 plan/distribute/verify/integrate。官方描述 Claude Tag「现在更多时间花在并行给许多 Claude 派活」，与 Opus 4.8 的 subagent 编排能力同源。Opus 4.8 agentic coding 69.2%（上代 64.3%），Super-Agent 基准唯一端到端全过模型。（来源：anthropic.com/news/claude-opus-4-8，2026-05-28；lushbinary.com；aesopacademy.org）

> **注意判别**：Claude Tag 是否在频道会话内直接调用 Dynamic Workflows 的数百 subagents，官方 Claude Tag 文档**未明说**；仅能确认两点：跑的是「与 Claude Code on the web 同一引擎」且模型为 Opus 4.8。「频道内多 subagent 编排」属于合理推断，未被官方产品页明确陈述，标为**未公开**。

## 3. 架构与工程视角

### 3.1 运行时架构：沙箱 + Agent Proxy + 凭据库

三区架构（官方 request-path 图）：

1. **Slack 工作区**：用户 @ 或调度触发起始点。
2. **Anthropic 托管的会话沙箱**：每线程一个，读文件/写文档/跑代码/克隆仓库。**沙箱不持有任何凭据**。克隆的仓库在沙箱内改、推回 Git host 为分支/PR。
3. **Agent Proxy（网络边界）**：沙箱所有出站请求都过它，按管理员规则判定。凭据存于**独立凭据库**，仅在边界注入瞬间取出并附到请求上——**模型与沙箱拿不到密钥**。

（来源：claude.com/docs/claude-tag/concepts/agent-identity、security-and-data）

**Agent Proxy 三种结果（默认拒绝）**：

| 目标主机 | 结果 |
| :--- | :--- |
| 命中某连接规则 | 注入该连接凭据并转发（模型/沙箱不得密钥） |
| 仅在 allowlist、无连接 | 无凭据转发 |
| 两者都不命中 | 直接拦截（主机不可达） |

同规则也适用于 Claude 在沙箱里跑的 `curl`/`fetch`。默认 deny：未加入规则/allowlist 的主机一律不可达。数据只能流向已允许主机。（来源：security-and-data、agent-identity 文档）

### 3.2 Agent 身份模型（本产品最重要的架构创新）

频道里 Claude 以**自己的服务账号**行事，而非代表发请求的人：Slack 里以 Claude app 发帖，GitHub 上以 Claude GitHub App 作 PR 作者，其他工具用管理员 provision 的服务账号。「访问权随频道走」，同一请求在 #platform-eng 能做的比普通频道多。四个后果：一次配置全员可用、行为不随发起人变化（可预测）、个人 connectors 仅 DM 生效、审计干净（动作落在服务账号名下）。（来源：agent-identity 文档；blog/agent-identity-access-model）

**DM 身份截然不同**：DM 无 scope 可绑，跑在用户自己的 claude.ai 账号上、用个人 connectors、费用计到个人 seat、PR 作者是个人。管理员可全组织禁用 DM。（来源：agent-identity 文档）

### 3.3 计算与数据保留

沙箱 = Claude Code on the web 同一托管算力，每线程一个，空闲释放、回复重建。**持久化**：线程/可见产物/push 到分支或 PR/Slack 贴出的内容；**不持久**：仅存于沙箱的文件（要保留需 push/贴出）。**Claude Tag 保留频道记忆与会话 transcript，因此启用 Zero Data Retention (ZDR) 的组织不可用**。（来源：security-and-data 文档）

### 3.4 权限治理与审计

- **默认能力**：仅读/发已加入频道 + 关键词搜公共频道；未加连接前无任何外部系统访问。连接按频道/workspace scope。
- **花费控制**：组织级与频道级 token 限额；channel work 计到组织 usage balance，DM 计个人 seat。无按座计费。
- **审计四处**：Audit 页（scheduled work / memory / network events）、各 scope 记忆文件、每个动作的服务账号归属、各连接服务自身审计日志。Network events 为逐小时 JSON 导出（**不含 Git 与 MCP 流量**，需联系客户团队启用）。**注意**：Audit 页无「每个任务及谁发起」的逐动作日志，routine 仅显示 Created by。（来源：claude.com/docs/claude-tag/admins/audit）

### 3.5 与 Slack API 的集成方式

安装 Claude app 仅是前提，**真正的 setup 是「provision 一个身份」**：四步——与 Slack workspace 配对、给工具访问权（Access bundle）、设组织月度花费上限、在私有频道测试。需 Claude 组织的 Owner 执行。默认任何连接 Slack workspace 的人都可调用（哪怕没 Claude 账号），Owner 可收窄为仅组织成员/按角色。（来源：overview、security-and-data 文档）

### 3.6 安全与合规：从「治理用户」到「控制 Agent 意图」

Zenity（2026-06-29）提出核心论点：讨论多集中在「身份」，但真正的变化是**从治理用户转向控制 Agent 意图**。传统模型下助手权限 = 用户权限；用户访问不了仓库，助手也不行。Claude Tag 把权限**直接赋给共享 Agent**：只要 Claude 有 GitHub/Jira/Drive/Salesforce 访问权，频道里任何人都能让它用这些权限干活。示例风险：无权访问敏感仓的开发者，让 Claude 去分析/总结/准备 PR——只要频道授了权，请求就成功，因为**授权属于 Claude 而非发起人**。（来源：zenity.io）

另一难点：下游系统记录的是 Claude 服务账号而非发起员工。Anthropic 自己的日志能把任务绑到 requester，但你的 SIEM/连接系统只看到「Claude」——**要关联意图与动作需拼接两套日志**。ambient 叠加跨系统执行，使 prompt injection / 恶意指令 / 意外行为影响可信企业集成的机会增多。Zenity 结论：可见性是基础但不够，需在每次工具调用/API/MCP 调用**之前**的 runtime 控制。（来源：zenity.io，2026-06-29）

CybersecurityNews（2026-06-23）从安全视角复述了四大能力与管理员控制（scoped 身份、token 限额、全任务日志），并确认 8/3 下线与 30 天迁移窗口、官方 X 账号 @claudeai 同日官宣。（来源：cybersecuritynews.com/anthropic-claude-tag）

### 3.7 与 OpenAI/Google 同类路线的技术对比

Slack 频道成为企业 AI 最激烈的战场：

- **Salesforce/Slack**：2026-03 为 Slackbot 增 30+ 能力，推「agentic OS」。
- **OpenAI**：2026-04 推 Workspace Agents，跨 Slack/Drive/Microsoft/Salesforce/Notion 执行任务（connectors 路线）。
- **Perplexity**：企业版「Computer」 agent，@computer 直接进 Slack。
- **Microsoft**：Graph + Copilot/Work IQ 作为组织上下文层；GitHub Copilot 进 Teams。
- **Cognition Devin**：从早期就以 Slack 为主接口。

（来源：venturebeat.com；techcrunch.com）

> **技术对比洞察**：OpenAI Workspace Agents 是「用户构建、跨 app 执行」的任务编排，本质仍是用户代理；Google/Microsoft 走「组织知识图谱（Graph）+ copilot」。Anthropic 的差异点在**「Agent 身份」与「频道级共享主体」**：不是每人一个助手，而是一个有独立 service account、独立凭据、独立记忆的共享虚拟员工。这把「上下文护城河」从个人层提到了团队层，也把治理难度同步提升。

## 4. 能力边界与局限

### 4.1 已知限制与风险

- **Prompt injection 放大**：how-it-works 明说沙箱跑「与 Claude Code on the web 同一引擎」。同期安全报道（SecurityWeek 2026-04）指 Claude Code/Gemini CLI/Copilot 均可被代码注释里的注入绕过多层防御Ｍ——「注入不是 bug，是 agent 被设计去处理的 context」。频道场景下，恶意消息/被污染的仓库文件可能被写入记忆或触发越权动作。（来源：securityweek.com 2026-04-21；zenity.io）
- **越权**：频道成员可借 Claude 服务账号访问自己无权的资源（Zenity 示例）。
- **幻觉在协作场景的放大**：ambient 主动插话 + 多人共享记忆，一条错误「事实」会被写入 workspace 记忆并跨频道传播。记忆「不能全文检索」也限制了回溯准确性。
- **上下文窗口限制**：中途加入线程仅取 50 条，长线程关键信息可能丢失。
- **无 rewind**：编辑/删除消息不能撤回已发送给 Claude 的指令。
- **ZDR 不可用**：因保留记忆与 transcript，启用 Zero Data Retention 的组织无法使用。（来源：security-and-data 文档）
- **可靠性**：VentureBeat 指 Anthropic 近期坐认需求激增带来的基础设施压力，「常驻」定位使宕机成本与按需工具不同。（来源：venturebeat.com）

### 4.2 定价/可用范围/迁移成本

- **定价模型**：无按座费，频道/线程按 usage 计（Opus 4.8 费率，$5/$25 每百万 token），从组织 usage balance 扣；spend limit 封顶。DM 走个人 seat。未公布详细套餐价。（来源：overview 文档；venturebeat.com；anthropic.com/claude/opus）
- **token 消耗画像不同**：持续监听+建记忆+异步跨时的 agent，消耗远高于传统按需调用，VentureBeat 点名为采纳顾虑。（来源：venturebeat.com；techtimes.com 2026-06-27）
- **迁移**：替代旧「Claude in Slack」，管理员 30 天内 opt-in；未迁移则 **2026-08-03 自动迁移**。Anthropic 发 launch credit 供试用。（来源：官方页；techtimes.com 2026-06-23；cybersecuritynews.com）
- **供应商锁定**：积累数月频道上下文与机构记忆的 Claude 极难替换，切换成本高。（来源：venturebeat.com）

## 5. 技术研判

1. **「Agent 身份」是本次发布真正的架构拐点**。把权限/凭据/记忆/审计绑在一个可被企业安全团队理解的 service account 上，是「AI 虚拟员工」从 demo 走向生产的必要工程前提。Agent Proxy 默认拒绝 + 凭据不进沙箱的设计，是对「agent 被注入后偷凭据」的直接防御。
2. **真正的范式转移是「从治理用户到控制 Agent 意图」**。传统 RBAC/IAM 在「共享 Agent + 任人可委派」下失效；意图与动作需跨两套日志拼接。这是企业采纳的真正门槛，也是 runtime 控制类安全产品的新机会。
3. **ambient 是 agent 工程的关键信号**：AI 从「调用才响应的函数」变为「持续观察、自主决定何时行动的主体」。配合 Opus 4.8 的 Dynamic Workflows（数百 subagent 并行），信号是：下一代企业价值不再由「存数据的系统」捕获，而由「坐在干活现场的 agent」捕获。

## 6. 主要来源清单

**官方**（以下为权威原文）：
- Anthropic 公告：anthropic.com/news/introducing-claude-tag（2026-06-23）
- 产品文档：claude.com/docs/claude-tag/overview、concepts/how-it-works、concepts/agent-identity、concepts/security-and-data、users/memory、users/proactivity、admins/audit（2026-06，public beta）
- Opus 4.8：anthropic.com/news/claude-opus-4-8、anthropic.com/claude/opus（2026-05-28）
- AWS Marketplace 上架：aws.amazon.com/about-aws/whats-new/2026/06/claude-tag-aws-marketplace

**技术/财经媒体**：
- TechCrunch（2026-06-23）、VentureBeat（2026-06-23/24）、ZDNET（2026-06）、TechTimes（2026-06-23 与 06-27）、BuildFastWithAI、TheNextWeb

**安全分析**：
- CybersecurityNews（2026-06-23）、Zenity（2026-06-29，「控制风险」观点）、SecurityWeek（2026-04，agent 注里 prompt injection）

**社交**：官方 X @claudeai（2026-06-23 官宣，经 CybersecurityNews 引用）、r/ClaudeAI 讨论。

---

## 7. 信息覆盖自检

**覆盖维度**：✅ 产品形态与交互 / ✅ 持久记忆（有读写隔离表）/ ✅ ambient 监听（含 routines 机制）/ ✅ 跨频道上下文 / ✅ 工具连接与 MCP / ✅ 模型（Opus 4.8）/ ✅ 架构（沙箱+Agent Proxy+凭据库）/ ✅ 安全权限审计 / ✅ 竞品对比 / ✅ 边界与定价迁移。

**关键事实来源数**：
- 发布日期 6/23 + 8/3 下线 + 30 天迁移：≥3 源（官方、TechTimes、CybersecurityNews）
- 运行 Opus 4.8：≥3 源（官方页、VentureBeat、CybersecurityNews）
- 四大能力（multiplayer/learn/ambient/async）：≥3 源（官方、TechCrunch、CybersecurityNews）
- Agent Proxy / 默认拒绝 / 凭据不进沙箱：官方 2 页文档（agent-identity + security-and-data）
- 记忆按频道隔离：≥2 源（官方 memory 文档 + TechCrunch）
- 65% 内部代码：≥2 源（官方 + VentureBeat/TechTimes）

**未公开 / 未证实（绝不编造）**：
- 频道会话内是否直接调用 Dynamic Workflows 的数百 subagents——**未公开**（仅知同引擎 + Opus 4.8）。
- 记忆底层存储形式（向量库/文件）、上下文压缩算法——**未公开**（仅知为「策展笔记」且不可全文检索 transcript）。
- 具体 SLA / 宕机赔付 / 详细套餐价——**未公开**。
- ambient 触发的内部阈值/评分机制——**未公开**。











