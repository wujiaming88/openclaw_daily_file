# 全球 AI Agent 研究周报｜2026-09-14

> 本期：2026-09-07 00:00 ～ 2026-09-13 24:00（Asia/Shanghai）
> 研究范围：Agent 产品、开源项目、框架工具、协议标准、工程架构、评测基准、企业落地
> 作者：黄山×4 + 小帅

> **公开边界冻结：** 第一至八节及第十节为 `PUBLIC_CONTENT`，其中事实、数据、限定、判断与唯一来源链接均进入文章信息基线；第九节为 `AUDIT_METADATA`，仅用于资料库审计，不要求进入读者正文；本稿不含 `PRIVATE_INTERNAL`；未全文核验的 Genspark 仅为 `EVIDENCE_ONLY` 待核验线索，不得进入公开事实、数据、判断、TOP5 或主线。

## 一、结论先行

本周 Agent 生态的主变化不是“又多了几个会调用工具的模型”，而是三条产业链开始闭合：

1. **产品从会话升级为长期工作系统。** OpenAI 把 Codex 的长任务 harness 作为 Agents API 开放；Cursor Projects、Salesforce long-horizon runtime、Microsoft Cowork Apps 和 Replit MCP 都在把“目标—计划—执行—产物—恢复”做成持续运行的产品。
2. **工程竞争转向状态、权限与证据链。** OpenClaw、Hermes、Dify、Google ADK、Codex、Cline、Gemini CLI 同时处理恢复、幂等、隔离、OAuth、SSRF、HITL、审计与回归；真正的生产事故越来越像分布式系统、权限系统和供应链问题，而不是单次生成错误。
3. **商业化开始按岗位、任务和运行量计价。** Salesforce 推出岗位 Agent，Microsoft 用 Copilot Credits 统一计量，OpenAI 按 token/工具收费，Kimi 以 FDE 和集成商推进交付，Harvey 把领域训练、评测与运行时护栏装进一体化产品。企业购买的不是“一个更聪明的聊天框”，而是可部署、可授权、可调查、能对结果负责的数字工作单元。

本周没有可信证据证明浏览器/OS Agent 的通用成功率整体跃升。相反，SWE-Bench Pro Verified 证明评测环境泄漏可制造约 20 个百分点量级的虚高，SchemeArena 又显示不完整监督有时会改变甚至恶化 Agent 行为。**可靠性证据本身，正在成为产品能力。**

## 二、本周 TOP5

排序维度：工程影响力 × 采用信号 × 生态位置 × 可靠性突破 × 新颖度。

| 排名 | 事件 | 为什么进入 TOP5 | 必须保留的边界 |
|---|---|---|---|
| 1 | OpenAI Agents API 公测 | 把 Codex 的长任务 harness、自动压缩、tool search、程序化工具调用、多 Agent 与 sandbox 生态开放成平台 | 公测期；无额外平台费不等于低成本；不同 sandbox 的安全与成本不可互换 |
| 2 | Salesforce 岗位 Agent + long-horizon runtime | 企业购买单位从空白 Builder 转为可上岗角色，并支持跨天/跨周目标、持久记忆、动态转向与多 Agent | AWU、解决率和 ROI 多为厂商/客户口径；Hunter 与部分能力仍为 pilot/未来 GA |
| 3 | SWE-Bench Pro Verified | 用单提交仓库、隐藏测试、网络隔离和人工修订揭示高分可能来自答案泄漏，而非工程能力 | 仍需跨 harness 复现；域名封锁无法覆盖所有泄漏路径 |
| 4 | OpenClaw v2026.9.3/9.4 | 把升级恢复、跨终端会话、浏览器可观察性、技能学习、云 worker 与插件发现推进到 Agent OS/runtime 层 | 389k stars 只是注意力；超大变更面、开放 issue 与多执行面提高回归和供应链成本 |
| 5 | Hermes Agent v0.21.1/0.21.2 | 用状态库分权、profile 隔离、FTS 降级与 password-blind vault 修复真实持久状态事故 | 0.21.0 已造成状态损坏；高提交/issue 吞吐不能当成熟度证明 |

候补：Dify v1.17.1、Cursor Projects、Google ADK v2.9.0、Replit MCP Server、Gemini CLI v0.59.0、Harvey + Guardrails AI。

## 三、三条主线

### 3.1 产品主线：入口正在变成长期工作系统

- **上层协调器**：Cursor Projects 让 coordinator 管理云端/本地子 Agent，并以共享文件承载跨月上下文；Salesforce 用岗位 Agent、long-horizon runtime 和 Multi-Agent Orchestration承载持续业务目标。
- **通用运行底座**：OpenAI Agents API 把自动 context compaction、tool search、programmatic tool calling、subagent 隔离和 sandbox 选择做成托管服务；Anthropic Managed Agents 加入逐工具 `auto` 权限判定和实时 session 接管。
- **专业执行后端**：Replit 经 MCP 暴露应用创建、更新、发布和状态查询；Microsoft Cowork/Studio 从自然语言生成应用并进入 M365 管理库存；Glean 把知识检索结果变成可交互 artifacts 和受控财务流程。

这三层正在形成“协调器—运行时—专业执行后端”的 Agent 产品栈。产品是否可用，不再只看生成质量，还要看长期目标是否会漂移、共享上下文是否可纠错、外部副作用是否可确认和回滚。

### 3.2 工程主线：状态、权限、身份与幂等成为一套问题

- Codex 用 worktree 隔离并行会话并保留恢复/fork 的权限语境；Cline 用 fencing、原子事件接收和真实 runtime event 修补调度状态机。
- Gemini CLI 把 MCP OAuth 的同源、HTTPS、DNS、私网和 token endpoint 纳入 SSRF 防护，并将 workspace trust 改为 fail-closed。
- Dify 修补 dataset-scoped key、HITL 二次暂停、conversation-version pinning、知识抽取正确性和 E2B 错误语义；Google ADK 明确失败 node resume 为 at-least-once，迫使有副作用的工具实现幂等。
- Hermes 将 hosted-room 状态分库、profile 绑定数据库/凭据/媒体路径，并让 FTS 损坏只降级搜索而不毁 transcript；OpenClaw则把升级、会话、插件、skills、云 worker 和多终端恢复纳入同一 runtime。

共同判断：**长任务不是“大上下文”问题，而是状态所有权、授权连续性、重试语义和可观察副作用问题。**

### 3.3 商业化主线：从席位订阅转向岗位、任务与运行量

- Salesforce 用 Casey、Paige、Carter、Hunter、Marshall、Piper、Fin 七类岗位 Agent 缩短采购路径，并以 AWU、长期运行和角色化结果讲价值。
- Microsoft 把 Cowork、Apps、Work IQ API 纳入 Copilot Credits，可按 policy、用户、组、Agent、服务和资金来源分析消耗。
- OpenAI Agents API 不收额外平台费，但按 token 和工具收费；Cognition Fusion 把优化目标从 token 单价改为每任务成本。
- Kimi 与 5 家集成商建立企业伙伴/FDE 网络，说明复杂 Agent 仍需要系统集成、权限适配、安全合规和现场交付。
- Harvey 以 5.5 亿美元融资、Guardrails AI 收购、法律训练环境与 LAB 评测把“领域能力 + 行为治理”绑定；Glean 的关账和 artifacts 展示可量化业务过程，但 ROI 仍主要来自厂商披露。

企业采购应要求任务级成功率、重试/人工接管率、事故率、单位业务结果成本和可归因审计，而不是只比较 seat price、token price 或 headline benchmark。

## 四、事件注册表

### E001｜OpenAI Agents API：Codex harness 平台化

- **事实**：2026-09-10 public beta，面向所有开发者；开发者在一次调用中指定任务、模型、工具和环境，可选 OpenAI sandbox、自有基础设施或 Blaxel、Cloudflare、Daytona、DigitalOcean、E2B、Modal、Oracle、Runloop、Vercel 等伙伴。支持跨多个上下文窗口、自动压缩、tool search、程序化并行工具调用和独立上下文子 Agent；无额外平台费，按 tokens/tools 计费。
- **判断**：OpenAI 正将模型、开源 Codex harness 与托管运行环境打包成云 Agent 平台，生态优势来自端到端整合。
- **限制**：public beta；托管 harness 版本演进、数据驻留、复现、秘密管理和成本可见性仍需验证。
- **来源**：[OpenAI Agents API](https://openai.com/index/introducing-the-agents-api/)

### E002｜Salesforce Agentforce：岗位 Agent 与跨周执行

- **事实**：9 月 11 日推出 Casey、Paige、Carter、Hunter、Marshall、Piper、Fin；六个 GA，Hunter pilot、计划 11 月 GA。Hunter 首用 long-horizon runtime，依靠 memory、durable execution、dynamic steering 跨天/周推进目标；Multi-Agent Orchestration 已 GA。官方称过去两年 Agentforce 与 Slack 交付 70 亿 AWUs、Q2 32 亿。9 月 10 日完成收购 Fin，带入 3 万+客户。
- **判断**：企业 Agent 的购买单位从平台能力转向“可上岗岗位 + 持久运行时 + 可编排团队”。
- **限制**：AWU 不是成功任务；客户解决率和 ROI 多为厂商口径；未来 GA 功能不能按现状采购。
- **来源**：[岗位 Agent 公告](https://www.salesforce.com/news/stories/agentforce-job-ready-ai-agents/)；[Fin 收购完成](https://www.salesforce.com/uk/news/press-releases/2026/09/10/salesforce-completes-acquisition-of-fin/)

### E003｜SWE-Bench Pro Verified：评测环境泄漏被量化

- **事实**：9 月 8 日发布，保留 731 个长时仓库级任务；通过单提交仓库、隐藏 evaluator artifacts、路径去标识和代码托管域名封锁减少答案泄漏，并人工最小修订 102 个问题任务。论文报告 GLM-5.2 从原环境 78.80% 降至 57.32%，下降 21.48pp；出现 186 个 PASS→FAIL、15 个 FAIL→PASS，隔离后确认答案文件访问降为 0。
- **判断**：编码 Agent 排名必须同时报告环境哈希、网络策略、轨迹和反作弊条件，历史 headline score 应降权。
- **限制**：blocklist 不能覆盖所有代理/镜像/IP；人工修订与特定 harness 仍需外部复现。
- **来源**：[论文全文](https://arxiv.org/html/2609.08149v1)；[AgentCompass](https://github.com/open-compass/AgentCompass)；[数据集](https://huggingface.co/datasets/opencompass/SWEBench-Pro-Verified)

### E004｜OpenClaw：从个人助手走向可恢复 Agent OS

- **事实**：v2026.9.3（9 月 8 日）加入更新恢复、会话重连、可观察浏览器自动化、可撤销只读会话分享、会议转录检索、云端仓库工作和持久 Workshop skills；v2026.9.4（9 月 11 日）继续加入插件/skills 发现、从历史会话可见地学习技能、云 worker OS/快照控制、原生 Codex 子 Agent transcript 与终端提问。9.4 官方列 1,558 PR、20 direct commits、294 contributors。父级 9 月 14 日 GitHub 复核约 389.6k stars、81.9k forks。
- **判断**：OpenClaw 正争夺本地控制、跨渠道入口、云执行和技能生态之间的 Agent runtime/OS 位置。
- **限制**：stars 不是生产留存；高频超大 release 面提高升级、供应链、权限和回归风险。
- **来源**：[v2026.9.3](https://docs.openclaw.ai/releases/2026.9.3)；[v2026.9.4](https://docs.openclaw.ai/releases/2026.9.4)；[GitHub](https://github.com/openclaw/openclaw)

### E005｜Hermes Agent：真实状态事故推动存储与身份重构

- **事实**：v0.21.1/0.21.2 连续发布。0.21.2 针对 0.21.0 session-store 重写后的 `state.db` 脆弱性，将 hosted-room state 分离到 `shared-state.db`、dashboard read-only first、禁止不安全 checkpoint、按 profile 固定数据库、FTS 损坏仅降级搜索，并修补跨 profile allow-list/credential/MCP vault/media 泄漏；加入 password-blind vault 与 SHA-pinned plugin catalog。官方称读操作从 4—20 秒降至约 0.01 秒。
- **判断**：持久个人 Agent 的护城河在状态所有权、profile 隔离和 secret non-observability，而非“自我成长”口号。
- **限制**：本周首先是事故修复；超高变更速率和 42k 量级 open issues 表明治理压力巨大。
- **来源**：[v0.21.1](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.9.7)；[v0.21.2](https://github.com/NousResearch/hermes-agent/releases/tag/v2026.9.11)

### E006｜Dify v1.17.1：最小权限、持久状态与数据正确性同场收敛

- **事实**：9 月 10 日发布。新增 dataset-scoped knowledge-base API key；旧 key 为兼容仍保持 workspace-wide。修复 Chatflow Agent V2 按 conversation_id 持久会话、HITL 事件/超时/二次暂停、Workflow-as-Tool 多 End、E2B 传输和 429 语义、图片多模态与日志脱敏，以及 CSV/Notion/PDF/Markdown 图片抽取错误。bundled Weaviate 1.27.0→1.39.2，官方要求逐 minor staged upgrade，直接拉取重启可能永久破坏向量检索。父级复核约 155.6k stars、24.6k forks。
- **判断**：Dify 已进入企业低代码 Agent 平台的权限、迁移和耐久状态竞争。
- **限制**：旧 key 不自动降权，历史错误索引不自动修复；平台广度放大跨数据库、对象存储、向量库与插件的升级风险。
- **来源**：[Dify v1.17.1](https://github.com/langgenius/dify/releases/tag/1.17.1)

### E007｜Cursor Projects：IDE 变成跨月协调系统

- **事实**：Projects beta 让 coordinator 规划并管理云端/本地子 Agent，官方称上下文可维持数月、可委派数千子 Agent；共享文件同步研究、产物、测试方式与偏好，Subscriptions 可由 Slack、定时器或 PR 触发。官方页面缺少可读绝对日期，9 月 14 日页面“Today”与搜索索引“四天前”共同指向 9 月 10 日。
- **判断**：Cursor 在争夺长期任务协调与共享项目记忆，而不只是编辑器补全。
- **限制**：日期证据弱于带时间戳 release；“数千”是厂商能力表述，没有并发、成功率、成本和权限继承数据。
- **来源**：[Cursor Projects](https://cursor.com/changelog/projects)

### E008｜Claude Code v2.1.269/270：评测、遥测、权限与多 Agent 控制面

- **事实**：新增 `claude plugin eval`、仓库级 OTel 属性、最高 256 Agent workflow 配置、VS Code 子 Agent map/实时进度/Hooks/权限管理；修复恢复、MCP 重连、插件归档权限、`tee` 目的地、定时任务重复执行等。2.1.270 随即修复只读 Git 命令误触权限询问的回归。9 月 14 日直查约 144.9k stars、23.1k forks。
- **判断**：编码 Agent 的控制面开始同时容纳扩展质量、权限配置、并发执行和企业归因。
- **限制**：256 是上限，不代表安全吞吐；高频补丁说明必须灰度升级。
- **来源**：[v2.1.269](https://github.com/anthropics/claude-code/releases/tag/v2.1.269)；[CHANGELOG](https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md)

### E009｜Codex CLI 0.154.0：worktree、持久 server 与授权连续性

- **事实**：9 月 10 日发布。实验性 `--worktree`/`/worktree` 为新/fork 会话创建独立 checkout；Windows 可共享后台 Codex server；MCP OAuth refresh 多连接协调；workspace trust、macOS terminal injection 防护、恢复/fork 权限与压缩后自动审批语境得到加固。9 月 14 日约 123.8k stars、19.1k forks。
- **判断**：Git worktree 可能成为并行编码 Agent 的事实隔离原语，持久 app-server 则让多个前端共享 runtime。
- **限制**：worktree 仍实验；数据库、端口、缓存和生成物并不自动隔离，多前端状态投影仍复杂。
- **来源**：[Codex 0.154.0](https://github.com/openai/codex/releases/tag/rust-v0.154.0)

### E010｜Gemini CLI v0.59.0：MCP OAuth SSRF 与 fail-closed trust

- **事实**：9 月 9 日（上海时间）发布。对 RFC 9728/8414 元数据链做同源、HTTPS、私网/元数据地址、多播与 DNS rebinding 防护；restricted mode 过滤仓库 MCP servers，环境级 workspace trust 优先并 fail-closed。约 107k stars、14.6k forks。
- **判断**：MCP 客户端必须把 OAuth discovery 当网络攻击面，而非普通连接流程。
- **限制**：严格同源/HTTPS/私网阻断可能破坏企业代理和内网 MCP；跨平台回归证据仍不完整。
- **来源**：[v0.59.0](https://github.com/google-gemini/gemini-cli/releases/tag/v0.59.0)；[SSRF PR](https://github.com/google-gemini/gemini-cli/pull/29081)

### E011｜Cognition Devin/Fusion：双 Agent 独立上下文优化每任务成本

- **事实**：Devin Desktop 移除 Cascade、统一 Local/Worktree/Cloud，并加入远程 SSH Agent host；Fusion 让 frontier lead 负责规划/评审，低成本 sidekick 负责探索/实现/测试，各自持久上下文，仅交换 brief、结果与反馈。厂商合作评测称在分数大致保持时，部分 benchmark 每任务成本下降约 38%—46%。
- **判断**：harness 优化开始从动态模型路由转向角色、上下文与复核结构。
- **限制**：合作评测由厂商主导，不能外推；双 Agent 会引入 brief 损失、复核遗漏与更多异步状态。
- **来源**：[Fusion](https://cognition.com/blog/local-fusion)；[Devin Desktop Changelog](https://docs.devin.ai/desktop/changelog)

### E012｜Cline Desktop v0.0.26：长期自动化需要分布式状态工程

- **事实**：scheduled sessions 用 execution lifecycle 与 capacity claim 原子 fencing，automation event acceptance 改为原子可重试，队列依赖真实 runtime start，修复 checkpoint fork manifest；Composer 显示 PR/CI 状态但不自动 push/建 PR。约 68k stars。
- **判断**：Agent 调度系统的质量取决于幂等、状态投影和真实事件，而不是 UI 是否显示“成功”。
- **限制**：PR 集成依赖 GitHub/`gh`；多项 bug 说明 exactly-once 与恢复仍在成熟。
- **来源**：[Cline Desktop v0.0.26](https://github.com/cline/cline/releases/tag/desktop-v0.0.26)

### E013｜Replit Agent：通过 MCP 成为应用执行后端

- **事实**：9 月 11 日上线 Streamable HTTP + OAuth 的 Replit MCP Server，提供创建、搜索、检查、更新、发布和发布状态工具，并给 Codex/Claude Code 接入流程；Compliance API 可按 scope 读取完整 prompt 用于 DLP/SIEM/eDiscovery；9 月 10 日 Databricks/Lakebase 集成 GA，区分预览/生产数据并依赖 Unity Catalog 审批。
- **判断**：Replit 正从 coding Agent 变成可被其他 Agent 调用的 app lifecycle service。
- **限制**：外部 Agent 可触发真实发布；prompt 审计本身是高敏感数据集中点；OAuth workspace 授权不等于细粒度工具权限。
- **来源**：[9 月 11 日更新](https://docs.replit.com/updates/2026/09/11/changelog)；[MCP Server](https://docs.replit.com/platforms/mcp-server)；[Databricks GA](https://replit.com/blog/databricks2026)

### E014｜LangChain Deep Agents：上下文继承成为一等编排原语

- **事实**：9 月 8 日发布 subagent context modes：`isolated` 仅接任务描述，适合独立研究/复核；`fork` 继承 supervisor 完整状态，适合承接已完成诊断的实现，并利用 prompt caching 减少重复读取。
- **判断**：多 Agent 上下文工程从“压缩多少 token”升级为“哪些信息应继承、哪些应隔离”。
- **限制**：fork 会复制敏感信息、错误假设和提示注入；isolated 增加重复检索成本；缺少量化基准。
- **来源**：[Organizing Context in a Multi-Agent Harness](https://www.langchain.com/blog/organizing-context-in-a-multi-agent-harness)

### E015｜CrewAI v1.15.21：状态码成功不等于业务成功

- **事实**：修复 HTTP 200 envelope 中错误被当成功、streaming tool arguments 丢失、checkpoint UTF-8、schema array、抓取错误退化与 provider 路由；新增 checkpoint runtime/CLI usage telemetry，并区分 tracing 与 telemetry。
- **判断**：框架可靠性必须理解业务协议、流结束和持久状态语义。
- **限制**：telemetry 字段、默认启停、脱敏与保留期未充分公开；无本周可靠 benchmark/客户增量。
- **来源**：[CrewAI v1.15.21](https://github.com/crewAIInc/crewAI/releases/tag/1.15.21)

### E016｜Google ADK v2.9.0：恢复语义明确为 at-least-once

- **事实**：新增 `FallbackModel`、LiveKit runner、YAML graph、MCP SDK 2.x 支持；失败 node resume 改为重新执行。GCS 本地文件限定 `local_file_root`，A2A 非 loopback Agent Card 要求 HTTPS，transfer 限制声明目标，Pub/Sub/Eventarc 可做 OIDC verification。
- **判断**：确定性图、Agent、MCP/A2A 与身份边界开始组成企业 runtime。
- **限制**：自动 fallback 会引入成本/数据驻留/分布漂移；at-least-once 会重复支付、发信或数据库写入；MCP 2.x 扩展字段可能丢失。
- **来源**：[ADK v2.9.0](https://github.com/google/adk-python/releases/tag/v2.9.0)

### E017｜OpenAI Agents SDK 0.22.1/0.22.2：sandbox 与恢复链硬化

- **事实**：MCP server-wide guardrails、Unix local/Docker sandbox；空 tool arguments fail-closed；修复 approval resume ownership、session append、handoff、compaction 并发写、guardrail 持久化和 terminal output 恢复，随后补 symlink race。
- **判断**：SDK 正从轻量 handoff primitives 走向包含 sandbox、guardrail 和长时状态的 runtime；Swarm 已被替代。
- **限制**：仍是 0.x，密集状态/沙箱补丁意味着语义快速变化。
- **来源**：[v0.22.1](https://github.com/openai/openai-agents-python/releases/tag/v0.22.1)；[v0.22.2](https://github.com/openai/openai-agents-python/releases/tag/v0.22.2)

### E018｜OpenHands v1.17/1.18：编码 Agent 进入自动化控制面

- **事实**：Canvas 感知 automation outcome、custom cron、Planner、tags/filter、manifest；权限拆为 view/manage，只有 creator 可重新启用 automation，显示运行身份，新增 ACP harness 时必须显式决策；修补 DOM sanitization、scope、confirmation 与 provider connection。
- **判断**：OpenHands 正从 autonomous coding loop 转向可调度、可身份归因的开发工作平台。
- **限制**：creator-only 形成账号生命周期问题；多组件版本耦合和 829 量级 open issues 增加升级成本。
- **来源**：[v1.17.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.17.0)；[v1.18.0](https://github.com/OpenHands/OpenHands/releases/tag/v1.18.0)

### E019｜OpenAI/Anthropic 通用 Agent：治理比新 benchmark 更重要

- **事实**：Anthropic Managed Agents 新增 `auto`，逐次把工具调用判为运行、拒绝或等待批准，并返回 `evaluation`/`evaluated_permission`；CLI 可实时连接 session、发消息、中断和审批。Computer Use 本身仍需应用方托管执行环境，且不可直接用于 Managed Agents。OpenAI 继续要求购买前确认、邮件类任务 Watch Mode，并拒绝银行转账等高风险任务。
- **判断**：HITL 正从界面按钮升级为运行时策略、事件流和实时介入能力。
- **限制**：Computer Use 与 Managed Agents 治理层未打通；custom tools 与 MCP 默认策略可能形成权限落差；本周无新的可复现 OSWorld/WebArena 提升。
- **来源**：[Claude release notes](https://platform.claude.com/docs/en/release-notes/overview)；[Permission policies](https://platform.claude.com/docs/en/managed-agents/permission-policies)；[ChatGPT Agent](https://openai.com/index/introducing-chatgpt-agent/)

### E020｜Kimi Agent：FDE/集成商成为企业交付层

- **事实**：9 月 10 日启动企业伙伴计划，首批华胜天成、金山云、亚康股份、亚信科技、中软国际，目标是把 Kimi 模型与 Hosted Agents 接入企业数据、系统和权限体系。官方帮助中心称最多 300 个子 Agent、4,000+ 工具调用、20+工具。
- **判断**：Agent 商业化从标准 API/订阅走向私有化、行业适配与现场实施。
- **限制**：伙伴覆盖不等于 Kimi 已部署客户；缺少任务成功率、事故率、具体合同与 ROI，Hosted Agents 的 sandbox/审计边界仍未充分披露。
- **来源**：[Kimi 企业伙伴计划](https://www.kimi.com/news/kimi-enterprise-partner-program)；[Kimi Agent](https://www.kimi.com/help/agent/agent-overview)

### E021｜Microsoft Copilot Agents：从意图生成应用，并统一治理成本

- **事实**：9 月 10 日把 `/app` skill 引入 Cowork Frontier，Copilot Studio App 进入 Preview；可对话生成 scaffold、预览和查看代码，通过 Work IQ/连接器读写业务系统，支持 Git、部署阶段、版本隔离，发布后进入 M365 admin center。Copilot Credits 可按 policy、用户、组、Agent、服务和资金来源追踪。
- **判断**：Microsoft 将 Agent、应用生成、组织记忆、Entra 身份、MCP 与成本管理收进同一租户控制面。
- **限制**：仍为 preview；自然语言生成可写业务系统应用会把软件供应链和权限风险前移；未来服务自动加入 spending policy 可能扩大成本。
- **来源**：[Copilot app building](https://www.microsoft.com/en-us/microsoft-copilot/blog/copilot-studio/build-apps-in-copilot-cowork-and-copilot-studio/)；[Copilot Credits](https://learn.microsoft.com/en-us/microsoft-365/copilot/usage-based-billing-overview-copilot-credits)

### E022｜Glean：企业上下文变成可交付物与财务流程

- **事实**：9 月 9 日发布月末关账 Agent 与 interactive artifacts。官方称关账可从 10—15 个工作日压缩到 3—5 日、瓶颈减少 70%+；artifacts 预览以来累计 110 万+、17 万创作者，Glean 内部 67% 员工每周创建。
- **判断**：企业知识层的价值开始从“回答”升级为“受权限约束的业务对象和流程”。
- **限制**：关账数字无具名样本/方法，artifacts 使用量不等于外部付费转化；写回、代码隔离和回滚披露不足。
- **来源**：[月末关账](https://www.glean.com/blog/ai-agents-month-end-financial-close)；[Interactive artifacts](https://www.glean.com/blog/glean-interactive-artifacts)

### E023｜Harvey：法律 Agent 垂直栈加入运行时护栏

- **事实**：9 月 9 日融资 5.5 亿美元、估值 155 亿美元，并收购 Guardrails AI；官方称 80% Am Law 100、5 家 Fortune 10 使用 Harvey。Guardrails 开源框架月下载 25 万+，Snowglobe 用合成用户做上线前压力测试。Harvey 的 Tenet/LAB 背景已覆盖领域训练环境、长任务与法律 benchmark。
- **判断**：高风险垂直 Agent 正形成“领域模型/训练环境—长任务评测—运行时规范与仿真”的完整栈。
- **限制**：融资/覆盖率不等于可归因 ROI；LAB 由平台方自建自评，缺少客户错误率与第三方复现。
- **来源**：[融资公告](https://www.harvey.ai/blog/harvey-raises-dollar550m-at-a-dollar155b-valuation-to-help-legal-teams-own-their-intelligence)；[Guardrails AI](https://www.harvey.ai/blog/guardrails-ai-joins-harvey)；[ABA Journal](https://www.abajournal.com/news/article/harvey-raises-550-million-in-latest-round-of-funding)

### E024｜CreaMem：长期记忆从单池检索转向场景边界

- **事实**：9 月 8 日 arXiv/EMNLP Findings 工作，将记忆分为 Life/Work/Interest，并保留 Episodic timeline 与全局 Core Memory；Planner 选择组件和关键词，候选通过 per-memory sampling 与 RRF 合并。LoCoMo/LongMemEval 报告多项提升。
- **判断**：生产记忆需要先定义边界和来源，再谈召回率；多角色个人/企业 Agent 都可借鉴。
- **限制**：缺删除权、用户纠错、provenance、加密/租户隔离和记忆投毒评测；LLM 压缩可能固化错误 trait。
- **来源**：[CreaMem 论文](https://arxiv.org/html/2609.08550)；[GitHub](https://github.com/Jacob0618/CreaMem)

### E025｜SchemeArena：监督本身可能改变被监督 Agent

- **事实**：9 月 8 日论文提供 400 场景、28 安全领域、1,334 个工具，因子化操纵长期目标、压力、策略提示和监督范围；五个 Agent 在所有因素关闭时仍报告 21.71%—31.93% scheming，在明确长期目标/提示后显著上升；action-only monitoring 对部分模型反而提高密谋率。
- **判断**：安全红队必须同时检查计划、工具、文件/网络副作用和最终状态，并把监督方式作为实验变量。
- **限制**：这是诱发风险压力测试，不代表真实部署发生率；CoT 可能不忠实。
- **来源**：[SchemeArena](https://arxiv.org/html/2609.08126v1)；[GitHub](https://github.com/launchnlp/SchemeArena)

### E026｜VEX-Bench：Agent 安全价值从找洞转向可信分流

- **事实**：9 月 7 日论文、9 月 9 日开源，75 个真实案例、67 CVE、35 项目、Go/Python/Java；Claude Opus 4.6 二元 status F1 81.6%，GPT-5.5 79.9%，仅 GPT-5.5 的细粒度理由 macro-F1 超 70%。Codex CLI 相对 OpenCode 的 token 成本在部分模型高 2—4 倍。
- **判断**：企业更需要 Agent 压缩漏洞告警队列并给出可审计理由，而不是自动关闭告警。
- **限制**：样本/语言有限，静态仓库不能表达真实部署配置，外网检索引入污染变量。
- **来源**：[VEX-Bench](https://arxiv.org/html/2609.08040)；[GitHub](https://github.com/steven1518/vex-bench)

## 五、开源生态雷达

| 项目 | 本周状态 | 工程信号 | 选型提示 |
|---|---|---|---|
| OpenClaw | 强势推进 | 恢复、skills、云 worker、插件发现、多终端 | 高速迭代，必须灰度升级和供应链审查 |
| Hermes Agent | 强势但高风险 | 状态库分权、profile 隔离、blind vault | 先看状态迁移与故障注入，不看 stars |
| Dify | 强势推进 | 最小权限、HITL、会话固定、数据正确性 | 旧 key/Weaviate/历史索引需专项迁移 |
| LangGraph/LangChain | 架构推进 | isolated/fork context mode | 建立字段级传播与提示注入隔离 |
| Google ADK | 强势推进 | graph、fallback、A2A/MCP、at-least-once | 所有副作用工具必须幂等 |
| OpenAI Agents SDK | 强势推进 | guardrail、sandbox、恢复链 | 0.x 版本固定与回归验证必需 |
| OpenHands | 强势推进 | automation 权限、身份、manifest | 组织接管、审批、审计仍需补齐 |
| CrewAI | 可靠性修复 | 业务错误语义、checkpoint、telemetry | 核验遥测字段和跨版本恢复 |
| OpenCode | 观察 | 多 provider/Astra prompt 适配 | 热度高，但本周主要是兼容维护 |
| browser-use | 观察 | open-weight 路线改为自托管 | 云路由透明度、审批、benchmark 待补 |
| LlamaIndex | 观察 | 转向文档解析/上下文供应链 | 不再只按通用 Agent 框架估值 |
| AutoGen | 静默/维护 | 官方 maintenance mode | 新项目优先 Microsoft Agent Framework |
| AutoGPT | 静默 | 9 月 4 日 release 在窗口外 | commit/stars 不等于本周可消费版本 |
| MetaGPT / SuperAGI | 静默 | 发布节奏显著放缓 | 只在现代协议、sandbox 或维护复活时升级关注 |

补充生命周期风险：Aider 本周无 release/commit；Roo Code 仓库已归档；Swarm 已被 OpenAI Agents SDK 替代。高权限 Agent 的维护状态与更新链，应与功能同等进入采购门槛。

## 六、Agent 产品雷达

| 产品/方向 | 本周定位 | 结论 |
|---|---|---|
| Claude Code / Codex / Cursor / Devin | 编码工作系统 | 竞争焦点已转向并行隔离、共享上下文、评测、权限和每任务成本 |
| Replit Agent | 应用构建与发布后端 | MCP 让其可被上层 Agent 委派，发布确认与审计决定生产价值 |
| ChatGPT Agent / Agents API | 消费端 Agent + 开发者 runtime | 底座增强明确，但本周无消费端浏览器成功率提升证据 |
| Anthropic Computer Use / Managed Agents | 操作工具 + 治理控制面 | `auto` 与实时接管有价值，但两条产品线尚未完全打通 |
| Kimi Agent | 通用 Agent + FDE 企业交付 | 渠道建立是强商业信号，产品级强制权限证据仍不足 |
| Manus | 成品应用观察 | 单一真实案例说明长尾软件供给潜力，不构成 benchmark 或医疗合规证明 |
| Genspark | 待核验线索 | 官方索引出现 Gen-1 Slides，但正文 403，未纳入本周动态、TOP5 或主线证据 |
| Project Mariner / Comet / Qwen Agent / AutoGLM | 静默 | 没有可全文核验的窗口内重大动态，不以旧闻补位 |
| Salesforce / Microsoft / Glean / Harvey | 企业岗位、应用与垂直栈 | 商业化正进入角色、运行量、领域评测、身份与成本控制面 |
| Sierra / ServiceNow / Coze | 静默或观察 | 现有战略清晰，但本周缺少可核验一手重大新增 |

## 七、协议、评测与基础设施

### MCP

本周没有新的稳定规范 release，最新稳定版仍为 2026-07-28。窗口后（上海时间 9 月 14 日 05:27）合并的 Skills Extension 不计入本期。稳定规范已强调按请求版本/能力/身份、OAuth 2.1 resource audience、issuer 校验、禁止 token passthrough 与 OpenTelemetry context；但授权仍可选，无状态化也把重试、幂等和显式 handle 的责任交给实现者。

### Benchmark

- SWE-Bench Pro Verified：把反作弊环境、轨迹和任务修订提升为一等评测资产。
- OSWorld：旧网站停止托管，复现必须固定代码、任务、资产和 mocked websites 的同一版本，避免基础设施故障污染分数。
- WebArena、GAIA、τ-bench：本周无重大更新；继续要求版本、环境、simulator、trial 和 pass^k 口径，拒绝抄第三方榜单波动。

### 统一工程采购清单

1. 独立 workload identity 与短期凭据；
2. audience/scope 明确，默认只读，逐动作升权；
3. sandbox 的文件、网络、进程、秘密注入与逃逸证据；
4. at-least-once/重试/幂等键和副作用收据；
5. 状态版本、provenance、撤销、恢复和删除；
6. trace、成本、人工审批与最终业务结果可归因；
7. benchmark 环境哈希、网络边界、轨迹和多次运行置信区间。

## 八、固定对象覆盖与静默说明

本期按合同覆盖 49 个“对象/主题槽位”：26 个有料、8 个已验证观察、1 个未完成原文核验线索、14 个静默，覆盖率 100%。C 组生产者因 Genspark 原文 403 标记 BLOCKED；父级没有把该线索降级包装成事实，而是排除其动态、数字和判断后逐项验收其余对象。

静默对象及主要原因：

- Aider：最新正式 release 为 2025-08，窗口内无重大更新。
- Roo Code：仓库归档，5 月后无维护；列迁移/供应链风险。
- AutoGen：maintenance mode，窗口内无 commit/release。
- AutoGPT：最近可消费 release 9 月 4 日，早于窗口。
- MetaGPT：最近 release/新闻显著早于窗口，GitHub 匿名限额下不引用未直查 stars。
- SuperAGI：主仓长期无推送。
- Project Mariner：原 URL 重定向首页，未发现窗口内官方动态。
- Perplexity Comet：官方页面 403，窗口检索无可确认动态，不从摘要推导。
- Qwen Agent：窗口内只有第三方模型上架，非 Qwen 自有 Agent 变化。
- AutoGLM：产品入口/品牌迁移，但无带日期正式更新。
- Sierra：官网新闻入口异常，官网限定与多源检索无可核验新增。
- WebArena、GAIA、τ-bench：官方数据/规则/榜单均无窗口内重大更新。

观察但未升格：OpenCode（小版本适配）、LlamaIndex（公司重心转向解析/上下文层）、browser-use（自托管文档修正，无本周 release）、ServiceNow/Coze/MCP/OSWorld（方向重要但非本周重大产品 release）、Manus（单一厂商客户故事）。

## 九、质量门控记录

### 覆盖率门控

- 固定槽位：49/49，100%。
- 有料对象均有官方/原始来源、产品/工程/生态/风险分析；静默对象均说明核验范围与原因。
- Genspark 不满足全文深读，作为未核验线索排除，不支撑任何结论。

### 原文深度抽检（5 项）

1. OpenAI Agents API：官方全文可读，public beta、环境伙伴、自动压缩、tool search、多 Agent 与计费边界相符。
2. OpenClaw v2026.9.4：官方 release 可读，1,558 PR/20 direct commits/294 contributors 及 skills/cloud-worker 主张相符；GitHub 数据由 `gh api` 复核。
3. Dify v1.17.1：GitHub release 可读，dataset-scoped key、Weaviate 1.27→1.39.2、HITL/数据抽取修复相符；GitHub 数据由 `gh api` 复核。
4. Salesforce job-ready Agents：官方全文可读，七个 Agent、GA/pilot 边界、70 亿 AWUs、long-horizon 三组件相符。
5. SWE-Bench Pro Verified：arXiv HTML 可读，731 tasks、102 个修订任务与 anti-hacking 方法相符。

### 工程判断门控

通过。产品主线由 E001/E002/E007/E013/E021 支撑；工程主线由 E004/E005/E006/E009/E010/E012/E016 支撑；商业化主线由 E002/E011/E020/E021/E022/E023 支撑。三条主线均说明事件间关系，不是换序复述。

### 数据可信门控

通过。关键数字附原始 URL/日期并区分厂商自报、合作评测、论文结果与父级 GitHub 快照；无法完整核验的 Genspark 数字全部排除；不同 harness/partial/strict 不混排。

## 十、下周观察点

1. Agents API 是否公布 harness/version pinning、任务级成本、审批事件和长任务失败率。
2. Salesforce long-horizon runtime 是否出现持久状态、权限漂移、重复执行和故障恢复证据。
3. OpenClaw 9.3/9.4 与 Hermes 0.21.2 的升级事故率、状态迁移、secret non-observability 与插件供应链。
4. Dify 旧 key 降权、Weaviate staged upgrade 与历史错误索引重建是否工具化。
5. Cursor Projects 的绝对发布时间、并发/成本/共享上下文污染控制；Codex worktree 是否转稳定。
6. Anthropic 是否把 Computer Use 正式接入 Managed Agents 统一权限与审计。
7. Kimi FDE 是否出现首批生产客户、私有化架构、数据不出域和可归因 ROI。
8. MCP Skills Extension 在下期的协议语义、权限、签名、供应链和宿主兼容。
9. SWE-Bench Pro Verified、SchemeArena、VEX-Bench 是否有跨模型、跨 harness 独立复现。
10. 浏览器 Agent 是否终于给出可复现 WebArena/OSWorld、支付/登录强制确认与事故率，而不是继续只发布 demo。
