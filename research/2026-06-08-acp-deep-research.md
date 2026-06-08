# Agent Client Protocol (ACP) 深度研究报告

> 研究员:黄山(System Architect & Technology Researcher)
> 完成日期:2026-06-08
> 研究对象:**Zed Industries 主导的 Agent Client Protocol (ACP)** —— 连接「任意编辑器 × 任意 AI 编码 Agent」的开源协议
> 一句话定位:**ACP 是 AI 编码 Agent 时代的 LSP(Language Server Protocol)。**

---

## ⚠️ 命名澄清(本主题最大陷阱)

"ACP" 这个缩写在 2025–2026 年至少对应**两个完全不同的协议**,务必先厘清:

| 缩写 | 全称 | 主导方 | 解决的问题 | 本报告焦点 |
|------|------|--------|-----------|-----------|
| **ACP** | **Agent _Client_ Protocol** | **Zed Industries**(+ Google Gemini CLI) | 编辑器/IDE ↔ AI 编码 Agent | ✅ **是** |
| ACP | Agent _Communication_ Protocol | IBM Research / BeeAI | Agent ↔ Agent(多智能体协作) | ❌ 否(仅做对比) |

**关键事实(交叉验证)**:IBM 的 "Agent Communication Protocol" 已于 2025 年 4 月随 BeeAI 捐给 Linux Foundation(LF AI & Data),并在 **2025 年 8 月底宣布并入 Google 的 A2A 协议**,作为独立品牌实际上已"退场"。来源:LF AI & Data 官方博客《ACP Joins Forces with A2A》(2025-08-29)、Linux Foundation 新闻稿(2025-04-29)。因此当下技术圈说 "ACP for coding agents" 时,几乎总是指 **Zed 的 Agent Client Protocol**。

---

## 1. 协议本质:解决什么问题?

### 1.1 M×N 集成爆炸

AI 编码 Agent(Claude Code、Gemini CLI、Codex、Goose…)与编辑器(Zed、Neovim、Emacs、JetBrains…)此前是**紧耦合**的:
- 每个编辑器要为每个想支持的 Agent 写定制集成;
- 每个 Agent 要实现每个编辑器特定的 API 才能触达用户。

这造成官方文档明确点名的三个问题(来源:agentclientprotocol.com/get-started/introduction):
1. **集成开销**:每个「Agent × 编辑器」组合都要定制开发(M×N 复杂度);
2. **兼容性受限**:Agent 只能在一部分编辑器里用;
3. **开发者锁定**:选了某个 Agent 就被迫接受它的交互界面。

### 1.2 设计哲学:做 Agent 时代的 LSP

ACP 的核心类比是 **Language Server Protocol(LSP)**。当年 LSP 把"语言智能"从 IDE 中解耦(M×N → M+N),ACP 想把"AI Agent 能力"从编辑器中解耦:
- **Agent 实现一次 ACP → 在所有兼容编辑器里可用;**
- **编辑器支持一次 ACP → 接入整个 ACP Agent 生态。**

Zed 创始团队在发布博客(2025-08-27《Bring Your Own Agent to Zed》)中的原话:"Just as the Language Server Protocol unbundled language intelligence from monolithic IDEs, our goal with the Agent Client Protocol is to enable you to switch between multiple agents without switching your editor."

> **黄山点评**:ACP 的设计哲学有一个被低估的"反向"洞察 —— 它假设**用户主要待在编辑器里**(user is primarily in their editor),Agent 是被编辑器"召唤"进来的子进程。这与 A2A/IBM-ACP 那种"Agent 作为对等网络节点"的世界观根本不同,也决定了它天然是 **client-spawns-subprocess** 架构,而非服务网格。

---

## 2. 技术架构

### 2.1 传输层:JSON-RPC 2.0 over stdio

- **协议基础**:JSON-RPC 2.0(来源:agentclientprotocol.com/protocol/overview 多源一致)。
- **本地 Agent**:作为编辑器的**子进程**运行,通过 **stdio(stdin/stdout 管道)**通信 —— 与 LSP server 的启动方式完全一致(编辑器 spawn 子进程 → 管道通信)。
- **远程 Agent**:可通过 HTTP / WebSocket 部署在云端(官方标注**"work in progress",完整远程支持仍在与各 Agent 平台共建中**)。
- **当前稳定协议版本**:`protocolVersion = 1`(GitHub README,截至 2026-06-08)。

两类消息:
- **Methods**:请求-响应对(期待 result 或 error);
- **Notifications**:单向消息(不期待响应)。

### 2.2 Session 模型与消息流

典型生命周期(来源:官方 protocol/v1/overview):

```
初始化阶段
  Client → Agent: initialize        (协商版本 + 交换 capabilities)
  Client → Agent: authenticate      (如 Agent 要求鉴权)
会话建立
  Client → Agent: session/new       (新建会话)
  Client → Agent: session/load      (恢复历史会话,需 loadSession capability)
Prompt 回合(Prompt Turn)
  Client → Agent: session/prompt    (发送用户消息)
  Agent  → Client: session/update   (流式进度:消息块/工具调用/计划/模式变更)
  Agent  → Client: 文件操作 / 权限请求(按需)
  Client → Agent: session/cancel    (中途打断)
  回合结束:Agent 返回 session/prompt 响应 + stop reason
```

### 2.3 核心原语(Primitives)

| 原语 | 方向 | 作用 |
|------|------|------|
| `initialize` | C→A | 协商版本、交换能力 |
| `session/new` / `session/load` | C→A | 新建 / 恢复会话 |
| `session/prompt` | C→A | 发送用户 prompt |
| `session/update` | A→C | **流式输出**:消息块(agent/user/thought)、工具调用、计划(plan)、可用命令、模式变更 |
| `session/request_permission` | A→C | **权限请求**:工具调用前请求用户授权(ACP 的安全核心) |
| `session/set_mode` | C→A | 切换 Agent 运行模式 |
| `session/cancel` | C→A | 取消进行中的操作 |
| `fs/read_text_file` / `fs/write_text_file` | A→C | 文件读写(需 fs capability) |
| `terminal/create` `terminal/output` `terminal/wait_for_exit` `terminal/kill` `terminal/release` | A→C | **终端控制**(需 terminal capability) |

约束:**所有文件路径必须为绝对路径;行号 1-based**。用户可读文本默认 **Markdown** 格式(不强制编辑器渲染 HTML)。

### 2.4 与 LSP / MCP 的关系和借鉴

- **借鉴 LSP**:stdio + JSON-RPC + 子进程模型 + capability 协商,几乎是 LSP 的"精神续作"。
- **复用 MCP**:官方明确"**协议尽可能复用 MCP 中的 JSON 表示**(re-uses the JSON representations used in MCP where possible)",但增加了编码 UX 专用类型,例如 **diff 展示**。
- **能力分层**:wire 兼容性由 `initialize` 协商的 `protocolVersion` 决定;具体可选功能由交换的 `capabilities` 决定。Rust crate / schema 包版本号 **不代表** wire 兼容性 —— 这是个容易踩坑的设计细节(README 专门强调)。

> **黄山点评**:把"权限请求(request_permission)"做成一等公民原语,是 ACP 最务实的工程决策。AI Agent 改代码、跑终端命令天然危险,把"人类授权"内建进协议层、而非各 Agent 各自实现,直接决定了它能不能被企业和谨慎开发者接受。

---

## 3. GitHub 实况(数据快照:2026-06-08,经 GitHub API 实查)

主仓库已从 `zed-industries/agent-client-protocol` **迁移/独立**到中立组织 **`agentclientprotocol/agent-client-protocol`**(这是治理中立化的重要信号,不再挂在 Zed 名下)。

### 3.1 主协议仓库 `agentclientprotocol/agent-client-protocol`

| 指标 | 数值 | 出处/备注 |
|------|------|-----------|
| Stars | **3,342** | GitHub API,2026-06-08 |
| Forks | **269** | GitHub API |
| Open Issues | 30 | 较低,说明维护活跃 / 协议表面积小 |
| Watchers(subscribers) | 14 | — |
| 主语言 | **Rust** | — |
| License | **Apache-2.0** | 无需 CLA,贡献即按 Apache 2.0 授权 |
| 创建时间 | 2025-06-23 | 协议起步早于 8 月公开发布约 2 个月 |
| 最近提交 | **2026-06-08**(当日) | 高频活跃,几乎每日提交 |
| 贡献者 | **约 108 页(per_page=1)→ 约 100+ 贡献者** | GitHub API Link 头分页推算(含匿名) |
| 最近 Release | **v0.13.6 / 2026-06-05** | 发布节奏极快(v0.13.5 = 06-01,v0.13.4 = 05-27,约每周一发) |

> 注:Release 用 `v0.13.x` 语义化版本管理 **Rust crate 与 JSON Schema 工件**;而 **wire 协议**稳定在 `protocolVersion=1`。二者解耦,不要混淆。

### 3.2 官方 SDK 仓库(同组织,均 Apache-2.0)

| SDK | 仓库 | Stars | Forks | 创建 | 最近 push |
|-----|------|-------|-------|------|-----------|
| **Python** | `python-sdk` | 272 | 31 | 2025-09-06 | 2026-05-31 |
| **TypeScript** | `typescript-sdk`(npm `@agentclientprotocol/sdk`) | 188 | 31 | 2025-10-11 | 2026-06-07 |
| **Rust** | `rust-sdk`(crates.io `agent-client-protocol`) | 155 | 28 | 2025-10-13 | 2026-06-08 |
| **Kotlin / Java** | `kotlin-sdk` / `java-sdk` | 见仓库 | — | — | JVM 支持(Kotlin 其他 target 进行中) |

官方库覆盖 **Rust / TypeScript / Python / Kotlin / Java** 五种语言,另有社区库(community libraries)。

> **黄山点评**:数据画像非常健康 ——「协议仓 3.3k★ + 当日提交 + 周更 release + 100+ 贡献者 + 5 语言官方 SDK + 仓库脱离 Zed 命名空间中立化」。这不是一个 demo 项目,而是一个**有治理意图、按工业标准在运营**的协议。3.3k★ 看似不如 MCP 动辄数万,但要注意 ACP 表面积小、受众是"编辑器/Agent 开发者"这个窄而专业的群体,star 含金量高。

---

## 4. 生态与采用

### 4.1 编辑器 / 客户端侧(Clients)

| 编辑器 | 状态 | 出处 |
|--------|------|------|
| **Zed** | 一等公民,发起方,自家 Agent 也走 ACP 同一套代码路径 | zed.dev/acp |
| **Neovim** | 通过 **CodeCompanion.nvim**(Oli Morris,与 Zed 合作)+ `agentic.nvim` 等插件 | Zed 发布博客 + Reddit r/neovim |
| **Emacs** | 通过第三方插件接入(如 Augment/Auggie 文档列出 emacs 插件) | docs.augmentcode.com |
| **JetBrains** | **2025 年 10 月起官方合作伙伴** | NousResearch issue #569 等多源 |
| VS Code | **尚未支持,据称在讨论中** | byteiota(2026)"VS Code support reportedly in discussion" |

### 4.2 Agent 侧(Agents,"Bring Your Own Agent")

参考实现是 **Google Gemini CLI**(Zed × Google 合作,首发参考实现)。截至 2026 年初,Zed 官方文档《External Agents》列出可在 Zed 中通过 ACP 使用的 Agent 包括:**Claude(Claude Code,2025-09-03 beta)、Codex(OpenAI)、OpenCode、Copilot(GitHub)、Cursor、Pi Coding Agent** 等;社区盘点称"早 2026 已有 17+ 个严肃编码 Agent"接入或可接入(Claude Code、Cursor、Codex CLI、Gemini CLI、Windsurf、Cline、Goose、Kimi CLI 等)。

> 数据可信度标注:具体 Agent 列表来自 Zed 官方 External Agents 文档(高可信)+ 第三方盘点(中可信,"17+" 为博客作者统计,未做逐一官方核实,标注为社区口径)。

### 4.3 时间线(交叉验证)

- **2025-06-23**:协议仓库创建。
- **2025-08-27**:Zed 公开发布 ACP,Gemini CLI 作首发参考实现(《Bring Your Own Agent to Zed》)。
- **2025-09-03**:Zed 加入 Claude Code(beta)支持。
- **2025-10**:JetBrains 官方合作。
- **2026-04-29**:**Zed 1.0 正式发布**(Rust 编写、0.6s 冷启动、并行多 Agent 线程,ACP 是其 AI 集成基座)—— 多源(chatforest/conzit 评测)。
- **2026-06-05**:协议最新 release v0.13.6。

---

## 5. 与 MCP 的关系:互补,不是竞争

这是最容易被外行搞混的一层,必须画清:

```
        ┌─────────────────────────────────────────────┐
        │  用户(开发者)                                │
        └───────────────┬─────────────────────────────┘
                        │  人在编辑器里
        ┌───────────────▼─────────────┐
        │  编辑器 / IDE(ACP Client)   │  Zed, Neovim, JetBrains...
        └───────────────┬─────────────┘
                        │  ★ ACP(编辑器 ↔ Agent)
                        │    JSON-RPC over stdio
        ┌───────────────▼─────────────┐
        │  AI 编码 Agent(ACP Agent)   │  Claude Code, Gemini CLI, Goose...
        └───────────────┬─────────────┘
                        │  ★ MCP(Agent ↔ 工具/数据)
        ┌───────────────▼─────────────┐
        │  MCP Servers(工具/数据源)    │  文件系统、数据库、API...
        └─────────────────────────────┘
```

- **MCP(Anthropic)**:解决 **Agent ↔ 外部工具/数据** —— "给 Agent 接上工具"。Agent 是 MCP 的 host/client,工具是 server。
- **ACP(Zed)**:解决 **编辑器 ↔ Agent** —— "给 Agent 接上用户(通过编辑器 UI)"。编辑器是 client,Agent 是被 spawn 的子进程。

一句话精炼(社区流传、本报告认同):**"MCP gives agents tools; A2A gives agents collaborators; ACP gives agents users (via editors)."** 三者处于不同层,完全互补。事实上 ACP 还在协议里复用了 MCP 的 JSON 表示,并让编辑器能管理 Agent 所连的 MCP servers —— **它们是上下游叠加关系,不是替代关系。**

---

## 6. 横向对比表:ACP(Zed) vs ACP(IBM) vs MCP vs A2A vs LSP

| 维度 | **ACP (Zed)**<br>Agent _Client_ Protocol | ACP (IBM)<br>Agent _Communication_ Protocol | **MCP** (Anthropic) | **A2A** (Google→LF) | **LSP** (Microsoft) |
|------|------|------|------|------|------|
| **解决什么** | 编辑器 ↔ 编码 Agent | Agent ↔ Agent(多智能体) | Agent ↔ 工具/数据 | Agent ↔ Agent(跨组织) | 编辑器 ↔ 语言服务器 |
| **谁是 client** | 编辑器/IDE | 调用方 Agent | AI 应用(host) | client agent | 编辑器/IDE |
| **谁是 server** | Agent(子进程) | 被调 Agent | 工具 server | remote agent | 语言服务器 |
| **传输** | JSON-RPC 2.0 / stdio(本地)、HTTP/WS(远程,WIP) | RESTful HTTP-native | JSON-RPC(stdio / HTTP+SSE) | HTTP / JSON-RPC + Agent Card | JSON-RPC / stdio |
| **状态** | 有 session,长连子进程 | 偏 REST 调用 | 偏工具调用 | 异步、支持 discovery | 有 session |
| **主语言/实现** | Rust(协议本体) | Python(BeeAI 生态) | 多语言 | 多语言 | 多语言 |
| **治理** | `agentclientprotocol` 中立组织,Apache-2.0 | **已并入 A2A**(LF AI & Data) | Anthropic + 社区 | Linux Foundation | Microsoft + 社区 |
| **现状(2026-06)** | 活跃,Zed 1.0 落地,JetBrains 接入 | **作为独立品牌已退场** | 事实标准(工具层) | 事实标准(Agent 协作层) | 久经验证的事实标准 |
| **类比定位** | "AI Agent 的 LSP" | (已消亡)→ A2A | "AI 的 USB-C 接口" | "Agent 的互联网协议" | 标杆原型 |

**核心区分一句话**:
- 想给 Agent **接工具** → MCP
- 想让 Agent **互相协作** → A2A(IBM-ACP 已并入它)
- 想让 Agent **进编辑器、面对用户** → **ACP(Zed)**
- LSP 是上述所有协议共同的"精神祖宗"。

---

## 7. 社区评价(实时讨论)

### 7.1 正面 / 期待

- **HN 高赞主帖**(news.ycombinator.com/item?id=45074147,281 points / 98 comments):社区称 ACP 解决了 **"three-app problem"**(以前要同时开编辑器 + Agent 窗口 + 浏览器,ACP 把 Agent 收进编辑器);另有用户指出 **ACP 降低 AI 助手切换成本,迫使厂商在质量上正面竞争而非靠锁定**(tessl.io 引述)。
- HN 用户 `cube2222`:认为 Zed "回归协作初心",布局后退一步、反而可能颠覆 agentic IDE 品类。
- **Reddit r/ZedEditor**:多数用户表达"被 Zed 开发体验转化"的热情。
- Emacs/Vim 社区(batsov.com,2026-03)将 ACP 视为老牌编辑器在 AI 时代**不被 VS Code 一家通吃**的关键武器。

### 7.2 质疑 / 痛点

- **"为什么不直接用 LSP 扩展?"**(HN top discussion 原话:"why it can't be just a LSP server or extension to the LSP protocol")—— 对"另起炉灶"造新协议有合理质疑。
- **Zed 自身 AI 体验争议**(BigGo News,2025-10):部分用户认为 Zed 一味"加 Agent 选项"(Codex 集成)并没解决其既有 AI 能力的根本短板,"more options ≠ better"。
- **远程 Agent 支持未完善**(官方自己标 WIP),企业级远程/云部署仍是空缺。
- **VS Code 缺位**:占统治地位的 VS Code 尚未支持(据称讨论中),是 ACP 成为"事实标准"的最大变数 —— 微软有自己的 Copilot 生态,接入动机存疑。

---

## 8. 趋势判断与洞察(黄山观点)

### 8.1 ACP 会成为编辑器-Agent 集成的事实标准吗?

**判断:大概率成为"非 VS Code 阵营"的事实标准,但全面通吃存在结构性障碍。**

**底层逻辑(为什么它有戏)**:
1. **LSP 范式已验证**:stdio + JSON-RPC + capability 协商,是被工业界十年验证过的解耦范式,迁移成本和心智成本都低。
2. **双边网络效应已启动**:Agent 侧(Claude Code/Gemini/Codex/Goose…)和编辑器侧(Zed/Neovim/JetBrains)都已上车,飞轮转起来后边际接入成本趋零。
3. **治理中立化**:仓库迁出 `zed-industries` 到中立组织,是为"让竞争对手也敢用"扫清政治障碍 —— 这是协议想做标准的必要信号。
4. **与 MCP 不冲突反而叠加**:不抢 MCP/A2A 的地盘,定位清晰,容易被整个生态接受。

**风险与障碍**:
1. **VS Code / 微软变量**:占据 70%+ 市场份额的 VS Code 有自己的 Copilot Agent 体系,若微软推自有编辑器-Agent 接口(或仅做私有集成),ACP 就只能是"挑战者联盟"的标准,而非全行业标准。
2. **"另一个标准"陷阱**:XKCD 927 风险 —— 协议太多反而无标准。不过 ACP 定位足够差异化(编辑器层),这个风险相对可控。
3. **远程/企业场景未补齐**:云 Agent、团队协作、鉴权审计等企业刚需仍是 WIP,可能被企业级方案绕过。
4. **依赖 Zed 持续投入**:虽已中立化,但事实上的推进动力仍高度依赖 Zed 团队;若 Zed 商业受挫,协议演进速度存疑。

### 8.2 未来 1–2 年走势预测

- **2026 H2–2027**:接入 Agent 数量继续增长(已 17+),Neovim/Emacs/JetBrains 生态插件成熟;**远程 Agent(HTTP/WS)规范定稿**是下一个里程碑。
- **关键观察指标**:① VS Code / 微软是否表态;② 是否有第二家主流编辑器(非 Zed 系)把 ACP 列为一等公民;③ 是否进入某个基金会(如 LF)做正式治理 —— 若进基金会,标准地位基本坐实。
- **最可能的终局**:ACP 成为 **"编辑器-Agent 互操作层的 LSP"**,在 Zed/JetBrains/Neovim/Emacs 阵营内成为默认,与微软 Copilot 私有栈**长期并存、双标准格局**。

### 8.3 一句话结论

> **ACP 把"AI Agent 能力"从编辑器里解耦出来,做对了 LSP 当年做对的事。它几乎肯定会成为开放编辑器阵营的事实标准;能否真正"通吃全行业",取决于 VS Code/微软的态度和远程能力的补齐——这两点是未来 18 个月最值得盯的变量。**

---

## 附录:主要信息来源(均经访问核实)

| # | 来源 | 类型 | 用途 |
|---|------|------|------|
| 1 | agentclientprotocol.com(introduction / protocol/overview) | 官方文档 | 协议本质、架构、原语 |
| 2 | github.com/agentclientprotocol/agent-client-protocol + GitHub API | 一手数据 | Stars/Forks/Release/语言/license/提交 |
| 3 | zed.dev/blog/bring-your-own-agent-to-zed(2025-08-27) | 官方博客 | 设计动机、发布、合作 |
| 4 | zed.dev/docs/ai/external-agents | 官方文档 | 已接入 Agent 列表 |
| 5 | zed.dev/blog/acp-progress-report(2025-10-02) | 官方博客 | 社区推进进展 |
| 6 | lfaidata.foundation《ACP Joins Forces with A2A》(2025-08-29) | 一手新闻 | IBM-ACP 并入 A2A(命名澄清) |
| 7 | linuxfoundation.org 新闻稿(2025-04-29) | 一手新闻 | BeeAI/IBM-ACP 捐赠 LF |
| 8 | news.ycombinator.com/item?id=45074147(281pts) | 社区讨论 | 开发者真实评价 |
| 9 | heidloff.net / boomi / akka / philschmid / marcnuri 等 | 第三方分析 | 横向对比、架构图佐证 |
| 10 | byteiota / chatforest / conzit / BigGo News | 第三方评测 | Zed 1.0、VS Code 缺位、质疑声 |

> **数据诚信声明**:GitHub 数值为 2026-06-08 经 API 实查;协议机制以官方文档为准并多源交叉;"17+ Agent""VS Code 讨论中"等为社区口径已明确标注;IBM-ACP 与 Zed-ACP 命名冲突已重点厘清。报告无编造数据。

*—— 黄山(System Architect & Technology Researcher),2026-06-08*
