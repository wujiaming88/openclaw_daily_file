# DeepSeek Harness 全景跟踪报告

> **检索截止**：2026-09-04 14:18:00（Asia/Shanghai）  
> **主增量时间窗**：`(2026-09-01 14:20:51+08:00, 2026-09-04 14:18:00+08:00]`  
> **最近 7 天补漏窗**：`2026-08-28 14:20:51+08:00` 起；补录信息标记为“上期补录/回溯”，不冒充主窗新事件。

## 1. 导读：RC 让分发更近，未让生产化成立

本期 DeepSeek Harness（dsh）从上期 `v0.1.2-alpha.3` 连续推进到 `alpha.4`、`alpha.5`，再到 **`v0.1.2-rc.1`**。Release、Tag 与 Commit 已核对：`dsh-v0.1.2-rc.1` 指向 `a66e4702047846cdaa10c66c9d3df3951f5ea70d`；npm 默认分发也从 `0.1.1-rc.2` 切换为 `latest=0.1.2-rc.1`。这降低了试用者的版本发现成本，却没有改变官方阶段：README 仍是 Developer Preview，明确会有兼容性破坏；SAFETY 仍明确未经过安全审计、不可视为 secure 或 production-ready。

技术线的主判断是：**dsh 正在把可替换能力收敛成更细的 package/service/event 契约，尤其是 Session 按需读取、投影缓存、Remote/ACP、父子 Agent 双向消息和 profile 组合；但迁移、远程鉴权、公网 WebFetch、同内核 sandbox 与客户端构建仍缺生产级证据。** 生态线的主判断是：**插件与衍生产品进入快速产品化期，市场、桌面、移动远控、IM、视觉、记忆和交易研究等供给明显增加，但高质量案例仍停在可复现开发活动，未发现独立 P1 生产或 P2 公开试点，也未核验客户、采购、收入或 SLA。**

最重要的交叉结论有三条：

1. **技术—生态双向共振**：Session API 的变化催生了 dsh-im 对 `snapshotEvents()` 的适配、Bridge/Mnemon/Pi 桥的升级压力；生态已在消费官方 seam，但多数兼容声明仍停在 alpha.1/rc.1/rc.2，技术演进速度高于生态兼容合同。
2. **分发产品化—治理能力背离**：`dsh-market`、`dsh-web`、Pocket 和桌面发行把安装、更新、远控、SSH、隧道、导出、cron 等能力聚合起来；它们正好放大了官方尚未解决的包级 provenance、权限 manifest、token 生命周期、回滚和审计问题。
3. **垂直价值—商业转化背离**：`dsh-trading` 的 typed seam、只读风险门和 `NOT PROVEN` 回测结论显示了可做的垂直产品方法；但本窗仍无独立客户、持续运行、成本/可靠性指标或付费信号，不能把产品化包装当成商业采用。

### 本期关键变化

- `v0.1.2-rc.1` 发布，immutable/prerelease，Tag/Commit 已核；npm `latest/next` 切到 rc.1，`alpha=0.1.2-alpha.5`。
- `Session.events` 转向 `seq`、`eventAt()`、`snapshotEvents()` 按需读取；`SessionSeq` 与 `SessionLogOffset` 强类型区分。
- 父 Agent 与可持续子 Agent 通过 `send_message` 双向传递后续消息；ACP、模型选择、取消和 Remote 统一面扩大。
- alpha.5 修复从旧 RC/alpha.3 升级时应用无法启动或 Session title 消失的问题；上期移除 SQLite Session backend 的迁移风险仍是 P0。
- 官方包图已经按当期源码覆盖 **49/49 package groups**，并补充 apps/native/vendor/website/python workspace 层；生态出现 `dsh-market`、`dsh-trading`、`dataelement/dsh-desktop` 等新的产品化信号。
- 插件质量门控仍为 **A=0；B/B-=5；C=4；D=5**（连续主台账口径）；案例 **P1=0、P2=0、P3=9、P3→P4=4、P4=1、P5=1**；商业转化未核实。

## 2. 技术线：官方模块地图与工程演进

### 2.1 官方模块地图（按 package group，不使用任意历史分类）

`dsh-v0.1.2-rc.1` 的 `packages/README.md` 将 package 按官方 group 划分，每个 `@deepseek-ai/dsh-*` package 归属于一个 group，group README 定义其 Service/接口边界。全量地图如下：

| 层面 | 官方 package groups | 核心职责/接口边界 | 本期状态 |
|---|---|---|---|
| 产品 API 与会话主干 | `core`、`goal`、`schedule`、`feedback`、`identity`、`todo`、`plan`、`session`、`session-query`、`workspace` | `ctx.sessions`、Agent/Loop、append-only SessionEvent、Goal/Plan、定时 follow-up、检索与 Workspace | Session 读取/投影/迁移是重点增量；其余以 rc.1 树核验 |
| 模型、上下文与编排 | `llm`、`context`、`compaction`、`subagent`、`preset`、`guard`、`jobs`、`workflow`、`experimental` | LLM provider、model-visible context、压缩、子代理 provider registry、preset、deadline/guard、jobs/workflow | ACP/Remote/双向子代理、PTC 入口收窄是重点 |
| 执行、文件与隔离 | `subprocess`、`shell`、`terminal`、`code-runtime`、`sandbox`、`fs`、`lsp`、`skill`、`e2b` | subprocess/Bash/PTy/code worker、文件/LSP/Skill、bwrap/Landlock/Seatbelt/Windows ACL、E2B POC | sandbox 明确 same-world；PTC 不是 OS sandbox；E2B 仍 POC |
| Web、事件与数据载荷 | `web`、`webhook`、`attachment`、`spill`、`storage` | search/fetch、可信外部事件、附件 durable identity、tool-result spill、非 Session storage domain | 默认公网 WebFetch、Attachment/Session 上传与数据平面需单独治理 |
| 交互、安全配置与扩展 | `interaction`、`credentials`、`settings`、`extensions`、`hooks` | approval/ask-user/permission preset、凭据引用、settings、运行时 mount/unmount、Claude/Codex hooks | 高权扩展面增加，审计与撤销合同仍不足 |
| RPC、SDK、前后端与启动 | `api`、`typert`、`sdk`、`acp`、`boot`、`host`、`client`、`bundle` | Remote BFF/Typert、JSON-RPC SDK、ACP、应用启动、Web host/client、profile patch/bundle | APIProxy 移除并统一 Remote；rc.1 客户端构建阻断报告需作为 smoke gate |
| 工程支撑 | `test-support`、`runtime-diagnostics`、`util` | testkit/invariant/replay/loader smoke、诊断报告、路径/超时/保留等工具 | 具备工程闸门，但没有公开生产容量/SLA |

合计 **49/49 package groups**。workspace 另纳入 `vendor/*`、`native/landlock-run`、`apps/*`、`website`、`python/sdk-runtime`；当前应用层核验到 `apps/cli` 与 `apps/web`，CLI 提供 `dsh` bin。`bundle` 层提供 `web`、`headless`、`sdk`、`sdk-minimal`、`acp` 等 profile；`dsh-base` 由多 profile 共享，而 `sdk-minimal` 有独立完整树。

### 2.2 装配、生命周期与调用链

Cordis Context 承载 services、typed events 与可逆 effects。Profile 的 bundles → profile `cordis.patch.yml` → home-level patch → `--patch` overlay 按层装配；patch 按 row id 定位并替换该 row 的完整 config，而不是字段级 merge。因此扩展插件应依赖 Service Definition（例如 `ctx.sessions`、`ctx.subagents`、`ctx.sessionProjections`）而非 concrete provider；升级前必须做配置语义 diff。

关键调用链可以概括为：

```text
用户/外部事件
  → host/client/Remote 或 ACP
  → Agent / Session service
  → SessionEvent append-only log
  → projection/cache/title/telemetry 等 domain consumers
  → context/compaction
  → LLM adapter stream
  → tools / shell / fs / web / subagent
  → tool/model events 回写 Session log
  → Remote/session-controller 向客户端推送 projection、状态和结果
```

每一层的故障边界不同：Remote/ACP 负责连接、取消与异常分发；Session 负责事实源与顺序；projection 负责客户端可见的整体值；LLM/Tool 负责外部副作用；sandbox 只约束其自身 provider 的能力。把整条链称为“安全隔离”或“可靠重试”都超出证据。

### 2.3 重点模块深析

#### Session、Persistence、Projection

官方仍将 Session 定义为 append-only `SessionEvent` log，模型消息历史由该日志重建，不单独存储。rc.1 采用 `seq`、`eventAt()`、`snapshotEvents()` 替代直接读取 `Session.events`，并以强类型区分 `SessionSeq` 与 `SessionLogOffset`；这是向按需读取和长会话内存控制收敛的重要 ABI 变化。Session group 当前包括 persistence service/JSONL、checkpoint policy、projection、projection cache、stats、turn outline、title、telemetry/OTel 等包。

Session projection 由框架监听 committed event 并折叠 domain state，客户端收到完成后的 whole value；projection cache 只是 fold shortcut，带有明确 `seq` 表示其陈旧程度，不能成为事实源。SQLite Session persistence 已在 alpha.3 移除，但 `session-query` 仍可以使用 SQLite FTS，二者不能混淆。迁移结论仍是：旧 SQLite 内容不会被自动删除，但需用旧版本导出；rc.1 没有证明已提供第一方 import/verify/rollback 闭环。

工程后果：

- 正面：长历史不必让所有事件持续驻留，projection/cache 可改善列表和冷启动读取；session log、projection、telemetry、query index 形成可分离数据平面。
- 负面：直接读旧数组、混淆 seq 与 byte offset 的插件可能在编译或 replay 时暴露；title/projection/session migration 的任一层失败都可能呈现为“启动成功但历史不完整”。
- 验收：备份旧 home，做 export/hash/count/import/resume/rollback；分别验证 log、projection、title、attachment、schedule、query index、OTel 与官方请求 metadata 的 retention/deletion。

#### Subagent、ACP 与 Remote

subagent group 以 `ctx.subagents` 注册多个 provider：in-process fresh/fork、ACP、Codex、Claude Code、dsh SDK；模型侧由 `tool-subagent` 与 control 工具消费。alpha.4/rc.1 新增父子 Agent 双向 `send_message`，并允许在授权范围内选择 provider/model/reasoning/max output；ACP 补齐 Session/model/MCP/permission/cancel 控制，旧 APIProxy 迁移并移除，统一到 Remote。

这使“子代理可继续工作”更接近一等编排能力，但状态机复杂度同步增加：消息 idempotency、父子权限继承、断线重连、取消后拒绝新消息、父会话关闭后的 child quiescence 都需要测试。Release notes 没有给出重复投递、重放、乱序或 HA 证明。

#### Sandbox、PTC 与 Web

sandbox group 包含 contract、Linux/macOS/Windows provider 与 policy；read-only、workspace-write、danger-full-access 等模式可通过用户批准的 escalation 改变。官方 SAFETY 明确：项目可执行模型生成代码和命令、加载第三方插件、访问网络、进程、凭据和文件；sandbox、approval、permission 只能降低风险，不能保证隔离。当前 sandbox 是 same-world，共享 host kernel/filesystem；容器、microVM、remote executor 才是替换整个 capability family 的外层边界。

PTC Mode 的 SDK 能力收窄到 `run_code`，Web PTC 默认不再给模型通用 workflow tool，这是最小化模型工具面的一步，但 worker thread 仍不等于 OS sandbox。rc.1 还将公网 `web_fetch` 默认带入 Python SDK、Headless、ACP 与 custom profiles，并声称内置 SSRF 防护。该“防护”没有经过本期动态 fuzz；部署应默认验证或关闭 redirect、DNS rebinding、IPv4/IPv6 私网、metadata endpoint、代理变量、响应大小/时间和 content-type。

#### Profile、Client 与供应链

profile/bundle 组合使 dsh 的差异化落在装配能力，而非单一内置 Agent。与此同时，pnpm `allowBuilds` 显式放行 `esbuild`、`lefthook`、`node-pty`、`koffi` 和 SDK runtime postinstall 等项目，并对部分新鲜依赖设置 release-age exclusion。这个策略优于默认允许生命周期脚本，但仍不能替代锁版本、校验 provenance、平台二进制 hash 和安装时网络行为。

rc.1 有一个单一但可复述的 Windows + Node 24 社区报告（Discussion #5544）：client bundles 引用未物化的 client packages，导致 `client-modules` build-time externals drift，可能让前端 plugin tree 无法启动。它不是普遍统计，也未证明官方已修；但应作为升级前 P0 clean-install smoke gate。

## 3. 生态线：插件、案例、衍生与商业

### 3.1 插件生态：数量增长快，可信准入仍为空

本期继续采用保守口径：**A=0；B/B-=5；C=4；D=5**。这不是“生态没有项目”，而是没有任何重点插件同时满足一级来源、兼容契约、安装/运行验证、权限/供应链闭环，故没有 A 级生产准入对象。

| 对象 | 本期信号 | 主要能力/风险 | 等级与建议 |
|---|---|---|---|
| `dsh-plugin-bridge` 0.3.2 | npm integrity、SLSA、OIDC trusted publisher、tests/typecheck/dataset/package smoke | Session migration、Remote/UI、preset；peer 仍未明确覆盖 alpha.3 | B；隔离、假会话、锁 digest |
| `dsh-vision-router` 2.1.1 | MIT、Node 22/24、较多兼容/资源/对抗/压力测试、SLSA | 图片/OCR/截图/Puppeteer/HTTP/native sharp/模型凭据 | B-；限制目的地和资源，不能凭作者测试升生产 |
| `dsh-mnemon` 0.5.0 | MIT、vitest、headless、deterministic build、package/attw/publint、SLSA；已发布 composable memory plugins | Source/Strategy/Provider、多 provider、长期文档与记忆 | B-；假数据试验，审 poisoning/留存/删除/恢复 |
| `pi2dsh` 0.24.0 | MIT、E2E/seams/community/live scripts、registry signature | Pi Host ABI、MCP、OAuth、扩展/子进程/文件桥接 | B-；canonical 直抓和 alpha.3 兼容仍缺 |
| `dsh-pocket` 2.10.3 | GPL-2.0、Node≥22、node:test、npm signature；本期修复 0.0.0.0 默认密码 | LAN/公网 QR、cloudflared、实时同步、session export | C；高权远程面，禁止直接公网采用 |
| `@xmanrui/dsh-im` 4.9.1 | MIT、18MB、9 IM 渠道、test/build/check、registry signature | 机器人凭据、双向审批、第三方 SDK、公网 AI Office | C；每渠道独立 principal/假凭据，不能推断兼容 |
| `@dsh-market/plugin` 0.4.5 | MIT、build/typecheck，但 test 仅 echo 转 core；一键安装管理下游 | 市场/更新是供应链放大器，依赖范围宽 | C；市场自身与下游逐包准入 |
| dsh-web 家族 | 分包持续发布，聚合包身份不闭合 | SSH/SFTP/tunnel/cron/视觉/Git/救援/删除 | C；不可把家族聚合为一个可信对象 |
| 未 scoped `dsh-im` 1.0.5 | 仍指向旧 rc.6 peer，身份与 scoped 包不同 | 通知/命令/审批 | D；当前 ABI 不兼容或未证 |
| `dsh-skill-mover`、`hooks-adapter` | 上期对象仍无当前 ABI/分发/测试闭环 | 文件/instructions/scripts 迁移、shell/webhook | D；禁止自动采用 |

市场方面，`dsh-market` README 的 2300+ catalog、curated registry、host-aware filter、build scripts 默认阻断和安装/备份能力属于项目方主张；`dsh-market` v1.41.0 的 release 原文可核实其修复 npm 更新说明、主机版本过滤、favorites、Git 插件迁移等产品演进。它是分发基础设施，不是信任根。包级 immutable digest、权限 manifest、SBOM、provenance、撤回/回滚和恶意包通知仍未闭合。

### 3.2 落地案例：P3 开发活动，尚无 P1/P2

本期分级：**P1=0，P2=0，P3=9，P3→P4=4，P4=1，P5=1**。

- **BotFleet × DSH driver（P3）**：独立仓 PR #189 合并；作者报告定向 56 tests、全套 2,583 pass，同时说明两个无关 suite 本地启动失败；修复 fallback error 分类、`DSH_HOME` credentials precedence、model-set 错误，并明确 ACP resume/MCP/usage 仍有缺口。是真实开发集成，不是生产案例。
- **OpenDesign/Aurora gateway（P3）**：PR #29 仍 open/unmerged，作者称 85 个 control-plane tests、4 个 e2e、Docker/PostgreSQL smoke；这是作者的 feature task，且明确不是 DSH-only，不是公开试点。
- **dsh-pocket、@xmanrui/dsh-im、dsh-vision-router、Bridge、Mnemon、pi2dsh、dsh-web 家族**：均有可核代码、包或 release，最多 P3。作者测试、stars、下载量、市场目录数不能替代主体、周期、业务结果、SLA、成本、P50/P95、故障率或安全审计。
- 未发现独立主体同时具备生产/试点范围、持续周期和可靠性/成本/安全指标。GitHub `production`/`deployment` 宽搜命中主要为自动阅读清单、通用 agent 文章、未合并 PR 和代码集成，不能升级为 P1/P2。

### 3.3 衍生项目：产品形态明显增加，但仍无采用闭环

本轮衍生候选 24、精读/直接抓取 17、采用/更新 14；分布 **D1=5、D2=3、D3=3、D4=3**。这里的 D1—D4 是本期衍生项目口径，不与插件 A/B/C/D 混用。

- **D1：`maddogfinance/dsh-trading`**。非 fork、early scaffold，采用 typed market-data seam、CSV/Futu provider、只读分析工具、risk-guard、回测 verdict；明确拒绝 execution-shaped tool names，允许 `NOT PROVEN`。是最清晰的垂直产品方法，但不接实盘。
- **D1：`dataelement/dsh-desktop`**。基于 `@deepseek-ai/dsh@0.1.2-rc.1` 的 macOS/Windows 桌面发行，声称签名、更新确认、安全模式、手机配对和 quick tunnel；版本滞后和上游 ABI 需要矩阵化披露。
- **D1 边界：`dsh-web`**。将任务/cron、移动远控、SSH/SFTP/隧道/集群执行、视觉、Git/worktree、救援和会话归档聚成工作台；实现仍是多插件组合，因此安全边界应按子包逐一审计。
- **D2：Ollama 集成**。Ollama 官方文档提供 `ollama launch dsh`，按需安装 `@deepseek-ai/dsh`，可配置模型；仍标 developer preview，web search 需要 Ollama cloud access 和支持工具的模型。这是平台接入/获客入口，不是联合销售或收入证据。
- **D3：`dsh-market`**。在 Web profile 内提供发现、安装、更新、主题、备份/恢复和诊断；产品化强，但把供应链权力集中到市场入口。
- **D4：Fairy-DSH、普通 Fork、旧 ACN/session-export/topology、未恢复 Bridge canonical**。没有足够的 canonical repo、release、差异说明和维护证据；不因名称、Fork 活动或第三方描述升级。

### 3.4 商业报道：接入与包装上升，商业转化未证

商业层级分为 L1 原始证据、L2 项目方主张、L3 媒体/咨询判断、L4 传闻/弱线索。本窗核验：**L1=2、L2=3、L3=1，L4=1（排除）**。

- **L1：官方阶段/产品状态**。DeepSeek 官方仍只给 worldwide Developer Preview/source included，没有价格、企业版、SLA、客户或采购入口。
- **L1：Ollama 官方集成**。是真实的启动/配置接入，可改善可得性；没有联合销售、分成、认证伙伴或付费客户证据。
- **L2：Desktop、dsh-market、dsh-trading**。分别有签名桌面发行、2300+ catalog/更新能力、交易研究工作台主张，但没有下载活跃、付费、客户、合同或独立指标闭环。
- **L3：Wavect 企业评测**。判断适合 contained engineering pilot，不应把 stars 当生产 control plane；是独立风险判断，不是客户案例或审计。
- **L4：泛 DeepSeek 公司融资等错配线索**。与 DSH 项目收入/融资无直接关系，排除。

因此本期不能写“DeepSeek Harness 已商业化”，只能写：**平台接入、桌面发行、市场和垂直包装提高了可获得性；商业转化仍未被原始证据验证。**

## 4. 双线交叉：技术供给能否转成采用

### 命题一：Session seam 已得到生态响应，但兼容合同落后（确定性：高）

技术证据：rc.1 将 `Session.events` 改为按需 `seq/eventAt/snapshotEvents`，并将 SQLite Session backend 移除、保留 JSONL/persistence/projection seam。生态证据：`@xmanrui/dsh-im` 4.9.1 明确适配 `snapshotEvents()` 同时保留旧路径，以使九类 IM 的问题/审批能继续原 Turn；Bridge/Mnemon/Pi 桥也在快速迭代。背离在于：多对象的 peer/开发基线仍停在 alpha.1/rc.1/rc.2，另有旧 `dsh-im` 仍指向 rc.6。结论：官方 seam 可用性正在吸引开发，但“包版本新”不能替代 host×plugin ABI 兼容矩阵。

### 命题二：可组合性同时产生产品化和供应链集中风险（确定性：高）

技术证据：profile/bundle 按 row id 完整替换配置，`bundle` 可把 Web、Remote、Session、tool、hook 等能力叠加；官方 `allowBuilds` 只对部分安装脚本做显式许可。生态证据：dsh-market/dsh-web/Pocket/desktop 将一键安装、自更新、远控、SSH/SFTP、隧道、cron、导出和删除聚合到用户入口。结论：`Everything is a Plugin` 的创业价值很强，但市场必须成为权限/来源/撤回的治理层，而不能只是目录和安装按钮。

### 命题三：技术成熟度高于案例证据，商业叙事仍是包装叙事（确定性：高）

技术证据：49/49 官方 package groups 已有明确 Service Definition/事件/装配边界，Session projection、subagent、sandbox、ACP 等能力形成完整 runtime 结构；但官方无 P50/P95、100k-event、multi-image、reconnect benchmark，SAFETY 仍否定 production-ready。生态证据：P3 对象数量上升，dsh-trading、BotFleet、Aurora、Ollama 和桌面/市场项目均可核，但 P1/P2=0，商业原始证据只到平台接入。结论：可做受控 Demo/垂直试验，不可基于“活跃生态”给企业 SLA、商业采用或投资级成熟度。

### 命题四：竞争差距已从“功能存在”转为“组合治理”（确定性：中高）

OpenClaw 的跨端 Gateway、Doctor 回滚、坏 cron 隔离和来源频道审批；Claude 的 enterprise scanning、managed settings、Trusted Devices/Remote Control；Codex 的 marketplace/source policy、重连不确定提交暂停、账户级审批证据；OpenCode 的多 provider 兼容修复与数据库兼容；Gemini CLI 的 Seatbelt 对 Docker/container sockets/binaries 隔离和 write safety checker，都把长期运行治理做成产品面。dsh 的插件可组合性仍有优势，适合快速造垂直 runtime；短板集中在 OS 级隔离、升级回滚、账户/设备/审批域、市场治理和容量证明。

## 5. 对 OpenClaw 与老板的决策建议

### 立即体验（低风险）

1. 在一次性 VM/独立 OS 用户、假凭据、锁 `0.1.2-rc.1` 与 SHA 的环境中跑 Web/headless/SDK/ACP 冷启动；先做 clean install，不覆盖旧 home。
2. 只读试用 dsh-trading 的 typed seam/risk-guard 思路和 dsh-mnemon 的 composable memory 设计；不连接真实券商、不导入敏感文档、不启用公网隧道。
3. 把 `snapshotEvents()`、projection cache、父子 `send_message` 当作 OpenClaw 架构参照，先在本地做 replay/取消/恢复验证，不直接引入第三方插件。

### 可做 Demo（1—2 周）

- **兼容与迁移闸门**：构建 host×plugin×profile×storage schema 矩阵，自动做 manifest/peer/integrity 检查、Session export/hash/count、旧版本回读和 rollback；成功指标是升级后 session/title/attachment/schedule 全量一致，失败即阻断。
- **只读垂直评测台**：仿 dsh-trading 做固定数据集、纯函数指标、risk guard 和 `NOT PROVEN` verdict；成功指标包含 P50/P95、token/cost、重试、回放率和错误拒绝率，不接真实执行工具。
- **市场安全预检**：只读解析插件包的权限、scripts、依赖、网络目的地、provenance、SBOM 和 immutable digest；默认 deny shell/SSH/tunnel/restart/delete，提供审计日志和离线 allowlist。

### 值得开发/集成

1. **优先做治理而非又一个 UI**：host ABI、版本/迁移/回滚、审批事件不可变记录、token TTL/设备绑定/撤销、市场撤回通知是当前高价值缺口。
2. **OpenClaw 可借鉴**：dsh 的 capability seam、profile/bundle 装配、Session projection 与 service-definition 依赖方向；但保留 OpenClaw 的 gateway trust boundary、security audit、故障恢复和审批来源语义。
3. **对 dsh 的集成边界**：只把 dsh 当受控外部 runtime/adapter，隔离 credentials、网络与文件；不要把其 sandbox 或 Developer Preview 状态当作 OpenClaw 的安全边界。

### 暂缓投入/停止条件

- 暂不直接采用 dsh-market 聚合安装、Pocket 公网 tunnel、dsh-web SSH/SFTP/cron、IM 公网 AI Office、hooks-adapter、skill-mover 和未 scoped `dsh-im`。
- 若无可验证导出/回滚即发生 Session/storage schema 变化，或高权插件无权限 manifest/provenance，或断线/compaction/fork/subagent 后审批证据丢失，应停止扩大试点。
- 连续两窗仍无独立 P1/P2、成本/可靠性指标或商业转化证据时，不把生态热度升级为企业合作或投资判断。

### 下期验证问题

1. rc.1 是否发布首个稳定版或接口/Schema freeze/迁移合同？
2. SQLite/JSONL/export 是否出现官方 import、verify、rollback 工具？
3. 49 个 package groups 中哪些第三方包明确声明并实测 alpha.3/rc.1 兼容？
4. `Session.events` 迁移是否有编译、replay、100k-event 基准？
5. Remote/`send_message` 是否公布幂等、cancel/close、父子 quiescence 语义？
6. WebFetch SSRF 是否有 redirect、DNS rebinding、IPv6、metadata 的测试证据？
7. dsh-market 是否出现签名索引、SBOM、权限声明、撤回与回滚机制？
8. Pocket/IM 是否公开 token TTL、重放拒绝、凭据留存与公网威胁模型？
9. 是否出现独立 P2/P1，具备主体、范围、周期和成本/可靠性/安全指标？
10. Ollama 接入是否产生官方联合销售、认证或付费支持证据？

## 6. 官方模块状态矩阵（全量摘要）

| Group | 本期状态 | 工程判断 |
|---|---|---|
| core/session/session-query | Session API 按需读取；Session log 仍事实源；SQLite persistence 已移除、query 可有 SQLite FTS | 方向正确，迁移风险 P0 |
| goal/schedule/feedback/identity/todo/plan/workspace | rc.1 package tree 核验，无本期独立重大破坏信号 | 依赖 Session/Remote 时需回归 |
| llm/context/compaction | provider/context/compaction seam 延续；长会话和 token 统计增强 | 无公开容量 SLA |
| subagent/preset/guard/jobs/workflow/experimental | provider registry、父子双向消息、PTC/tool guard | 生命周期和权限需故障注入 |
| subprocess/shell/terminal/code-runtime | 持久 shell/PTy/code worker 继续可替换 | same-world，非强隔离 |
| sandbox/fs/lsp/skill/e2b | 多平台后端与 policy；E2B POC | network/process/credential 边界不足 |
| web/webhook/attachment/spill/storage | WebFetch 默认面扩大；附件/数据平面分化 | SSRF、外发、留存需单审 |
| interaction/credentials/settings/extensions/hooks | approval/credential/settings/runtime extension | 高权、撤销、审计合同不足 |
| api/typert/sdk/acp/boot/host/client/bundle | Remote 统一、ACP 补全、profile/bundle 完整树 | rc.1 client smoke 必须门禁 |
| test-support/runtime-diagnostics/util | 工程检查与 replay/invariant 设施存在 | 未转为公开生产基准 |

## 7. 来源与验证摘要

### 官方与技术

- Release：<https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.2-rc.1>
- Release API：<https://api.github.com/repos/deepseek-ai/deepseek-harness/releases/tags/dsh-v0.1.2-rc.1>
- Tag ref：<https://api.github.com/repos/deepseek-ai/deepseek-harness/git/ref/tags/dsh-v0.1.2-rc.1>
- README：<https://github.com/deepseek-ai/deepseek-harness>
- SAFETY：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.2-rc.1/SAFETY.md>
- Package map：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.2-rc.1/packages/README.md>
- Architecture：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.2-rc.1/docs/architecture.md>
- Session group：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.2-rc.1/packages/session/README.md>
- Sandbox group：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.2-rc.1/packages/sandbox/README.md>
- npm metadata：<https://registry.npmjs.org/@deepseek-ai%2Fdsh/latest>
- Ollama：<https://docs.ollama.com/integrations/deepseek-harness>
- 社区风险：<https://github.com/deepseek-ai/deepseek-harness/discussions/5544>、<https://github.com/deepseek-ai/deepseek-harness/discussions/5519>

### 生态与案例

- dsh-market：<https://github.com/dsh-market/dsh-market>
- dsh-web：<https://github.com/zhu1090093659/dsh-web>
- dsh-trading：<https://github.com/maddogfinance/dsh-trading>
- dsh-desktop：<https://github.com/dataelement/dsh-desktop>
- dsh-pocket：<https://github.com/shaobeichen/dsh-pocket>
- @xmanrui/dsh-im：<https://github.com/xmanrui/dsh-im>
- dsh-mnemon：<https://github.com/omdsh-dev/dsh-mnemon>
- BotFleet PR #189：<https://github.com/jaywedgeworth22/BotFleet/pulls/189>
- OpenDesign PR #29：<https://github.com/eanfs/open-design/pulls/29>
- dsh-market Release：<https://github.com/dsh-market/dsh-market/releases/tag/v1.41.0>
- dsh-pocket Release：<https://github.com/shaobeichen/dsh-pocket/releases/tag/v2.10.3>
- dsh-im Release：<https://github.com/xmanrui/dsh-im/releases/tag/v4.9.1>
- dsh-web Release：<https://github.com/zhu1090093659/dsh-web/releases/tag/v0.3.14>
- mnemon Release：<https://github.com/omdsh-dev/dsh-mnemon/releases/tag/v0.5.0>
- 企业准备度评测：<https://wavect.io/blog/deepseek-harness-enterprise-review/>

### 竞争对照

- OpenClaw Releases：<https://github.com/openclaw/openclaw/releases>
- Claude Code Releases：<https://github.com/anthropics/claude-code/releases>
- Codex Releases：<https://github.com/openai/codex/releases>
- OpenCode Releases：<https://github.com/anomalyco/opencode/releases>
- Gemini CLI Releases：<https://github.com/google-gemini/gemini-cli/releases>
- Claude 产品发布说明：<https://support.claude.com/en/articles/12138966-release-notes>

## 8. 验证局限与门控结果

- 研究域：**10/10 完成**（版本代码、官方模块、插件、社区健康、案例、衍生、商业、Issue/风险、竞争、行动建议）。
- 官方模块：**49/49 package groups 覆盖**，另核验 apps/native/vendor/website/python workspace 层。
- 版本：Release/Tag/SHA 已核；README Developer Preview 与 SAFETY 未审计状态已核。
- 原文精读：技术 18 个候选/18 深读/15 采用来源，技术重点事实 12+；插件/案例/衍生/商业抽查均达到门槛（插件 3、案例 2、衍生 3、商业 3）。
- 插件：A/B/C/D 已分级；本期没有 A 级。
- 案例：P1—P5 已分级；P1/P2 均为 0，未把 Demo 或作者 PR 写成生产。
- 衍生：D1—D4 已分级；弱关联、未恢复 canonical 和普通 Fork 未进入强结论。
- 商业：事实、项目方主张、媒体判断、传闻分层；未发现客户、采购、收入、融资、SLA、监管或独立生产指标。
- 未完成：本期没有做本地安装、隔离运行、迁移执行、故障注入、动态 SSRF/权限审计或独立安全审计；因此所有 A/P1/P2/生产化判断保持保守。
- 搜索降级：Brave 首批请求出现 429，核心事实改用 GitHub Release/Tag/API、npm registry、官方项目页和仓库原文补足；搜索负面结果不作穷尽声明。

**门控结论：研究门控通过，但生产采用门控不通过。** 本稿可交给 `report2article` 做读者化重组；读者稿不得新增事实、不得把 P3/P4 提升为生产或商业结论。
