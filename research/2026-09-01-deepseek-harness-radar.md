# DeepSeek Harness 全景跟踪报告｜2026-09-01

- **报告日期**：2026-09-01（周二，Asia/Shanghai）
- **主增量窗**：2026-08-28 14:23:20（不含）—2026-09-01 14:20:51（含，UTC+8）
- **7 天补漏窗**：2026-08-25 14:20:51—2026-09-01 14:20:51（UTC+8）
- **上期基线**：`v0.1.2-alpha.1` / `dsh-v0.1.2-alpha.1` / `cd5ef8148158c3a752a658978873241fdf8e2bbc`
- **本期对象**：`v0.1.2-alpha.3` / `dsh-v0.1.2-alpha.3` / `dd6322d604e00eec1ba5e0c8541159906a21094a`
- **阶段**：Developer Preview；官方仍明确会发生兼容性破坏，且尚未安全审计、不得视为 production-ready

> **一句话结论**：本期真正改变采用判断的不是连续两次 UI 优化，而是 alpha.3 直接移除 SQLite Session 后端——DeepSeek Harness 正在改善长会话、连接与图片投递体验，同时继续快速改写存储和事件契约；外部生态已从插件扩展到 Ollama 入口、桌面发行、技能迁移和 Hook 兼容，但仍没有可独立核验的 P1 生产或 P2 公开试点，因此最优策略仍是锁版、隔离、先做迁移与故障恢复验证，暂不承诺企业 SLA。

## 1. 双线导读与关键变化

**技术主判断（高确定性）**：`alpha.2 → alpha.3` 主要改善 Client/Remote、长会话、Attachment/Subagent 体验，但 Session/Persistence 出现明确破坏性迁移。功能可用性向前，版本稳定性没有同步提升。

**生态主判断（中高确定性）**：插件和发行活动继续增长，Ollama 官方集成是本期最强外部接入信号；然而插件 A 级仍为 0，案例 P1/P2 仍为 0，商业信号仍停留在产品化与交付投入。

**技术—生态关系**：一方面，Remote、Profile、Attachment、Skill 等开放边界迅速被桌面、市场、迁移和兼容工具承接；另一方面，SQLite 移除、事件字段反复、npm 默认版本滞后和垂直产品白名单修补，说明生态正在为上游 ABI 漂移支付显性成本。

本期 TOP 6：

1. `v0.1.2-alpha.2` 与 `alpha.3` 连续发布；Tag/Release/SHA 对齐到 `dd6322d6…094a`。
2. alpha.3 移除可选 SQLite Session backend；旧内容不删除，但官方要求用旧版本导出。
3. alpha.2 恢复在 alpha.1 被移除的 `SessionEvent.ignorable`，暴露事件契约仍未冻结。
4. Client/Remote 增加连接失败状态、自动重试、立即重连和 `RemoteError`，alpha.3 修复 host stall 被误判为断线。
5. 运行中/排队图片可可靠回显和投递，持续子代理 follow-up 支持图片；长会话支持未加载分页预览和跳转。
6. Ollama 提供 `ollama launch dsh` 官方入口；桌面发行、Launcher、Skill/Hook 迁移工具增多，但无客户、采购、SLA 或独立生产指标。

## 2. 质量门控摘要

| 门控 | 结果 | 说明 |
|---|---|---|
| 研究域 | **10/10** | 版本、模块、插件、社区、案例、衍生、商业、风险、竞品、行动全部覆盖 |
| 时效性 | **通过** | 主窗与 7 天补漏明确；14:20 最终复扫，GitHub API 后段 403 限流，以 14:01 已成功的 Release/Tag/HEAD 证据和 14:20 npm/Topic 复核收口 |
| Release/Tag/SHA | **通过** | `alpha.3` Release、Tag 与 HEAD 均为 `dd6322d604e00eec1ba5e0c8541159906a21094a` |
| 官方模块 | **通过** | 继承上期全量官方包图，本期按 Session、Client/Remote、Attachment、Subagent、UI 等真实包族复核 |
| 技术原文 | **通过** | 技术线候选18、精读12、采用13；重点事实技术≥6 |
| 插件生态 | **通过** | 候选27、精读14；A=0、B/B-=5、C=4、D=5 |
| 案例 | **通过** | P1=0、P2=0；P3=9、P3→P4=4，未把 Demo 包装成生产 |
| 衍生项目 | **通过** | 候选25、精读18；D1/D2/D3/D4 边界与普通插件去重 |
| 商业信息 | **通过** | 事实、项目方主张、媒体、传闻分层；客户/采购/融资/收入/SLA 均为“本轮未发现” |
| 安全 | **通过** | Sandbox、权限、凭据、供应链、Web/Remote、迁移和升级风险均覆盖 |
| 双线交叉 | **通过** | 形成4项可验证共振/背离 |

**限制**：未安装第三方插件或二进制；未做 SQLite export/import、长会话 benchmark、Remote/WS 故障注入、图片/子代理竞态、安全审计或客户侧生产核验。所有“修复/改善”按官方发布声称书写，生产性结论仍需独立测试。

## 3. 技术线：版本、模块与工程成熟度

### 3.1 版本与分发硬核验

| 项目 | 本期值 | 判断 |
|---|---|---|
| GitHub Release | `v0.1.2-alpha.3`，2026-08-31 16:03:39 UTC | 最新 immutable prerelease |
| Tag | `dsh-v0.1.2-alpha.3` | 与 Release 一致 |
| Tag/HEAD SHA | `dd6322d604e00eec1ba5e0c8541159906a21094a` | Release 合并提交、Tag、HEAD 对齐；提交未签名 |
| npm dist-tags | `alpha=0.1.2-alpha.3`；`latest=next=0.1.1-rc.2` | 默认 `npx` 不会取得 alpha.3；复现须显式 pin |
| 官方阶段 | Developer Preview；未安全审计 | 连续 alpha 不等于稳定或生产承诺 |

### 3.2 官方模块状态矩阵

| 官方模块/包族 | 职责与关键接口 | 本期状态 | 工程后果 |
|---|---|---|---|
| Cordis / Loader / Profile / Bundle | Context、typed events、reversible effects、Profile 组合 | 无已验证核心语义变化 | in-process 插件仍是可信代码；Profile 整块替换配置风险持续 |
| Session core | append-only `SessionEvent`、`ctx.sessions` | 恢复 `SessionEvent.ignorable` | alpha.1—alpha.3 replay 与 consumer 必须容忍字段漂移 |
| Session persistence / projection | `ctx.sessionPersistence`、JSONL provider、checkpoint、projection cache | **SQLite provider 被移除**；长历史处理优化 | 升级前旧版导出和恢复演练成为 P0；无自动迁移承诺 |
| Agent / Agent Loop | turn/step、模型请求、工具执行、取消 | 本期无重大契约变化 | waterfall、取消和持久化排序仍需压力测试 |
| LLM / Context / Compaction | adapter、stream、history、token/耗时 | UI 展示 token/耗时；长历史效率改善 | 可观测性增强但无容量/P95 证明 |
| Tools / PTC / MCP | Tool registry、`run_code`、MCP mounts | 无已验证 PTC OS sandbox 新证明 | PTC 收窄入口不等于 OS 级隔离；MCP 仍需 timeout/output/egress 控制 |
| Attachment | `ctx.attachments`、durable local image | 排队/运行中图片可靠回显投递；无扩展名图像按内容识别 | 扩大 parser、路径、持久化和模型外发面 |
| Subagent | `ctx.subagents`、one-shot/continuable、follow-up/report | continuable child 的 follow-up 支持图片 | 父子权限、生命周期、取消和失败归因需独立验证 |
| Client / Remote | browser-host RPC、Connection、`@Remote` | 连接状态/重试/立即重连、`RemoteError`、stall 分类修复 | 仍未证明幂等、重放、半开连接、backpressure 或高可用 |
| Conversation UI | pagination、outline、render/highlight | 可预览/跳转未加载 turn；降内存、提代码高亮响应 | 长会话更可用，不等于无限容量 |
| Sandbox / Approval / Credentials | file fence、policy、approval、credential service | 阶段声明未变 | 官方明确不能保证隔离，不可作为唯一安全边界 |
| Scheduling / Jobs / Telemetry / Eval | timer/job、Session telemetry、OTel | 本期无重大高可信变化 | 仍缺 HA、公开产品级 eval 与企业留存/删除承诺 |
| SDK / ACP | stdio JSON-RPC、session/model/MCP/permission/cancel | 本期无重大新增 | trusted controller 边界、取消/关闭原子性仍需验证 |

### 3.3 重点模块深析

#### A. Session/Persistence：本期最强破坏信号

alpha.3 的 release 只承诺“既有 SQLite 内容不会删除”并要求“使用旧版本导出”，没有承诺 alpha.3 自动读取、迁移或回滚。当前 shipped backend 回到每 Session append-only JSONL，配合 checkpoint 与 projection cache。

**迁移门槛**：冻结写入 → 备份原始 SQLite → 旧版 export → 校验 turn/tool/attachment/title/schedule 计数与 hash → 目标版本 import/resume/compact → 回退阅读。任何一步失败，都不应升级。`ignorable` 在 alpha.1 移除、alpha.2 恢复，也要求跨版本 event replay 和 unknown/missing field 测试。

#### B. Client/Remote：错误可见性提高，高可用仍未证明

连接失败状态、自动 retry、立即 reconnect、统一 `RemoteError` 与 stall/断线差分是正向变化；但官方没有公开退避策略、retry budget、幂等键、断线重放、WebSocket 半开探测和 backpressure 语义。应在 tool result、queued image、subagent follow-up、cancel/close 边界注入 host stall、DNS/TCP/WS close 和代理错误，检查重复、丢失、乱序和取消后复活。

#### C. Attachment/Subagent：图片链打通，同时放大信任边界

本期链路为：Client composer 追加/排队图片 → durable local attachment → Session event/checkpoint → active conversation 或 continuable child follow-up → Remote event delivery → Client echo/分页渲染。需验证取消、重试、切换 Session、父子权限、无扩展名文件欺骗、解码资源上限、磁盘配额、删除与模型外发告知。

#### D. 长会话：从“能打开”走向“可导航”，尚无容量证据

未加载分页 turn 的预览与跳转，加上内存和高亮优化，合理方向是用 outline/projection 与按需分页减少 DOM 和高亮常驻成本。建议用 1k/10k/100k event、100 images、密集 live message 测首次可交互、P50/P95 跳转、heap、CPU、掉帧、重连与 resume；没有这些数据，不能承诺长会话 SLA。

### 3.4 跨模块影响链

```text
SQLite 移除
  → SessionPersistence provider 变化
  → checkpoint / projection / query / resume
  → Profile 与第三方会话插件
  → 桌面发行、Bridge、OpenDesign 等上层产品的升级与回滚
```

```text
运行中图片
  → Attachment 本地持久化
  → SessionEvent + checkpoint
  → Agent/Subagent follow-up
  → Remote/Connection 重连与错误归一
  → Conversation UI 分页、回显和历史恢复
```

**工程成熟度**：架构 seam 清晰、体验修复快，但存储迁移、安全审计、Remote 失败语义、长会话容量、插件 ABI 和企业治理尚未闭环。确定性：高。

## 4. 生态线：插件、案例、衍生与商业

### 4.1 插件生态

| 等级 | 对象 | 本期判断 |
|---|---|---|
| A | 无 | 未做独立代码全审+隔离安装/启动，拒绝凑数 |
| B/B- | Bridge 0.3.1、Vision Router 2.0.1、dsh-web 单项、pi2dsh 0.24.0、dsh-mnemon 0.4.4 | 分发、文档、测试或 peer 有证据；仍只适合隔离评估 |
| C | MCP connector、memory-connect、autogate、dsh-plugin-hub（`dsh-plugin` 1.4.1） | 身份可查但权限、兼容或供应链缺口明显；市场不能替下游包背书 |
| D | ACN、session-export、topology、dsh-skill-mover、hooks-adapter | 停滞、身份/分发不闭合、旧 ABI 或高权执行面，暂停采用 |

值得注意：Bridge 已将关键 peer 扩到 alpha.1并有 SLSA provenance；pi2dsh 与 mnemon 也追随 alpha.1；Vision Router 的关键 peer 仍停留 rc.1。Skill Mover 会读取并复制多个 Agent 的技能文件，Hooks Adapter 会复用 shell/webhook/oracle/proxy 配置——它们是信任边界转换器，不是普通 UI 插件。

GitHub Topic 主窗内有 push 的 `dsh-plugin` 仓库约 **3,074**（14:20 搜索快照），只是高噪声发现指标，不能解释为有效插件数或增长率。

### 4.2 落地案例

- **P1 生产：0；P2 公开试点：0（本轮未发现）**。
- P3 主要是本地 Web/Remote、ACP 互操作、Bridge 迁移、Vision Router、多项 dsh-web、MCP、pi2dsh、mnemon 和插件市场等开发者 Demo。
- P3→P4 包括 Skill Mover、Hooks Adapter、ACN、topology：有源码或主张，但缺持续维护、分发、独立复现或安全闭环。
- 未发现客户侧 SLA、持续时长、TCO、P50/P95、并发、故障率、安全评估或业务复盘。

### 4.3 衍生项目

| 项目 | 关系 | 本期增量 | 判断 |
|---|---|---|---|
| Ollama DSH integration | D2 深度接入 | 官方文档提供 `ollama launch dsh` | 最强外部入口；web search 需 cloud access，不等于离线企业方案 |
| OpenDesign 0.21.1 | D1 原生垂直产品 | macOS/Windows 资产、实验性 Design Harness Labs | 垂直包装强，但实验状态与版本锁摩擦持续 |
| DeepSeek Harness Desktop 0.10.0 | D1 桌面发行 | 多平台安装资产 | 分发事实可核，安全/留存/稳定未核 |
| DSH Desktop 2.0.4 | D1 桌面发行 | 适配 alpha.1；LAN 改 HTTPS+token | 对上游响应快，也坐实 breaking change 成本 |
| dsh-launcher 0.5.0 | D2 Windows 交付 | Windows asset+sha256 | 可测试交付层；更新/来源/权限需审 |
| dsh-sev 0.3.4 | D1 边界远程层 | 本窗无新 release | “安全审计 PASS”为项目方主张，不是独立审计 |
| dsh-skill-mover / hooks-adapter | D2 迁移/兼容 | 跨 Harness 资产和行为迁移 | 迁移成本下降，命令/URL/脚本信任面扩大 |
| dsh2opendesign | D2 适配修补 | 修改白名单绕过版本锁 | 一手暴露 ABI 摩擦；不建议生产绕过供应商边界 |

### 4.4 商业报道与转化

**已验证事实**：Ollama 官方集成页；OpenDesign、两类 Desktop、Launcher 的公开 release/资产。它们说明产品化和交付投入存在。

**项目方主张**：插件市场收录/精选/无遥测、dsh-sev“安全审计 PASS”、Skill Mover 14 平台、Hooks Adapter 测试与兼容等，均未升级为独立事实。

**本轮未发现**：DSH 专属付费/生产客户、采购/招标/合同、DeepSeek 与生态项目双方合作公告、融资、专门招聘、监管文件、收入、SLA、TCO、留存或客户侧性能指标。

因此商业阶段仍是 **P3 产品化信号**，不是交易闭环。

## 5. 技术—生态交叉：四个共振与背离

### 命题一：开放插件/Remote 边界已被交付层承接，但治理落后（确定性：高）

- 技术证据：Profile/Bundle、Client/Remote、Skill、Attachment/Subagent 均有清晰扩展 seam。
- 生态证据：Ollama、Desktop、Launcher、市场、Skill/Hook 兼容层快速出现。
- 判断：可得性提升是真共振；缺失的是制品签名、精确权限、出站目的地、撤销、迁移与审计，而不是更多市场条目。

### 命题二：Session 技术路线与生态升级需求发生背离（确定性：高）

- 技术证据：alpha.3 删除 SQLite provider；`SessionEvent.ignorable` 移除后恢复。
- 生态证据：Bridge、Desktop、OpenDesign、dsh2opendesign 均依赖会话/Remote/Profile 或显式暴露版本锁。
- 判断：上游快速收敛正在把迁移、回滚和白名单维护成本转嫁给生态。短期最值得开发的不是新 UI，而是版本矩阵、导出/恢复验证和受管兼容层。

### 命题三：长会话与图片体验形成技术共振，但没有采用数据（确定性：中高）

- 技术证据：分页导航、内存/高亮、排队图片和持续子代理图片均改善。
- 生态证据：Vision Router、mnemon、pi2dsh 等正好需要多模态、长期上下文和子代理链。
- 判断：功能方向与需求匹配，但 P1/P2、P95、容量、成本和安全数据为零；当前只能做受控验证。

### 命题四：商业叙事明显领先于生产证据（确定性：高）

- 技术证据：README/SAFETY 仍明确 Developer Preview、未审计；npm `latest` 仍停 rc.2。
- 生态证据：桌面资产、市场与集成增加，却无客户、采购、SLA 或独立生产指标。
- 判断：关注度和产品化真实，商业转化未证实。融资/合作/客户类结论必须继续保持零推断。

## 6. 竞争位置

与 OpenClaw、Claude Code、Codex、OpenCode、Gemini CLI 的本窗官方发布相比，DSH 的优势仍是 Cordis 驱动的可替换 Runtime 和开放组合；差距集中在：

- Claude Code 的不可被项目配置放宽的 Restricted 模式与路径/设置安全修复；
- Codex 的 MCP 输出上限、timeout、可信 origin/no-redirect 与 sandbox 修复；
- OpenClaw 的精确制品/能力审阅、目的地受限 secret proxy 和可撤销自动化授权；
- OpenCode 的企业身份、可恢复 subagent、权限续传和 retry storm 限制；
- Gemini CLI 的 eval、取消原子性、capacity/timeout 失败分类。

**位置判断**：DSH 更适合作为开放 Runtime 编排与插件实验平台，而不是无约束替代成熟 Coding Harness。确定性：中高。

## 7. 决策与行动清单

### 立即体验

1. **显式 pin `0.1.2-alpha.3`/SHA**，只在独立 VM、假凭据和脱敏数据上运行；不要用无 tag 的默认 `npx` 当 alpha.3。
2. 用一个脱敏长会话验证分页、token/耗时、重连与图片 follow-up；记录 P50/P95、内存、重复/漏投。

### 72 小时 Demo

1. **SQLite 迁移恢复实验**：旧版 export→alpha.3 import/resume→回退阅读。成功指标：turn/tool/attachment/title/schedule 全量一致；停止条件：任一丢失或不可逆。
2. **Remote 故障注入**：host stall、DNS/TCP/WS close、代理 502、cancel/close。成功指标：0 重复副作用、0 丢事件、取消不复活；否则停止。
3. **Restricted Profile 原型**：禁 shell/PTC/public WebFetch，固定 workspace fence、插件 allowlist、子代理不得放宽策略。成功指标：30 个越权/路径/子代理用例全拒绝。

### 值得开发/集成

- 版本/ABI/迁移兼容矩阵与 Profile semantic diff；
- Session export/import/verify/rollback 工具；
- 插件精确制品、provenance、权限、网络目的地和撤销审计；
- ACP/MCP/Remote output cap、timeout、trusted origin、redirect policy 与 cancel/close 幂等；
- 对 OpenClaw 可借鉴 Cordis seam 与 Profile 组合，但应避免整块配置替换、trusted controller 和“市场即信任”。

### 合作观察

Ollama、OpenDesign、Bridge、pi2dsh、mnemon 的维护者值得跟踪；合作触发条件是明确 alpha.3 兼容、可复现测试、制品 provenance 和至少一个独立 P2 使用方。

### 暂不建议

- 未演练 SQLite 导出的 alpha.3 原地升级；
- 生产使用 dsh2opendesign 白名单修补、Skill Mover 自动迁移和 Hooks Adapter 高权复用；
- 把插件市场精选、Stars、下载或项目方“审计 PASS”当安全/商业证明；
- 对外承诺多租户、企业 SLA、生产稳定性或客户采用。

## 8. 持续问题与下期验证

| 问题 | 当前状态 | 下期复核 |
|---|---|---|
| Developer Preview / 未审计 | 持续 | 稳定版、接口冻结、迁移指南与安全审计信号 |
| SQLite 移除 | 新 P0 | 官方导出/导入文档、兼容读取、回滚和第三方产品处理 |
| Event schema 漂移 | 持续 | `ignorable` 后续是否稳定、跨版 replay |
| Web/Remote token、SSRF、重连 | 持续 | TTL/原子兑换、DNS/redirect/proxy/metadata fuzz、retry 幂等 |
| PTC sandbox | 未证明 | worker 是否进入 OS sandbox |
| 插件元数据/Session upload/OTel | 三数据面持续 | schema、脱敏、地域、留存、删除与独立开关 |
| ACP/MCP trusted controller | 持续 | route pin、cancel admission、rollback、close quiescence |
| 插件 alpha.3 兼容 | 部分到 alpha.1 | Bridge/Vision/dsh-web/pi2dsh/mnemon 的运行验证 |
| Skill/Hook 迁移安全 | 新风险 | 新 ABI、registry、测试、默认拒绝 shell/webhook |
| ACN/session-export/topology | 连续停滞 | canonical release；第三窗无恢复则保持 D |
| P1/P2 与商业转化 | 仍为 0 | 首个独立客户/试点、成本、P95、并发、故障率、持续使用 |

## 9. 关键来源

1. DeepSeek Harness Releases：<https://github.com/deepseek-ai/deepseek-harness/releases>
2. alpha.3 Release：<https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.2-alpha.3>
3. alpha.3 Commit：<https://github.com/deepseek-ai/deepseek-harness/commit/dd6322d604e00eec1ba5e0c8541159906a21094a>
4. README：<https://github.com/deepseek-ai/deepseek-harness/blob/master/README.md>
5. SAFETY：<https://github.com/deepseek-ai/deepseek-harness/blob/master/SAFETY.md>
6. npm `@deepseek-ai/dsh`：<https://www.npmjs.com/package/@deepseek-ai/dsh>
7. Packages map：<https://github.com/deepseek-ai/deepseek-harness/blob/master/packages/README.md>
8. Ollama integration：<https://docs.ollama.com/integrations/deepseek-harness>
9. OpenDesign：<https://github.com/nexu-io/open-design/releases>
10. DeepSeek Harness Desktop：<https://github.com/dsh-tauri-desk/deepseek-harness-desktop/releases>
11. DSH Desktop：<https://github.com/anywhere-labs/dsh-desktop/releases>
12. dsh-launcher：<https://github.com/Wanbinyu/dsh-launcher/releases>
13. dsh-plugin-hub：<https://github.com/dshplugin/dsh-plugin-hub>
14. dsh-skill-mover：<https://github.com/mjylfz/dsh-skill-mover>
15. hooks-adapter：<https://github.com/JohnXu22786/hooks-adapter>

---

**最终门控结论**：研究域 10/10；官方模块全覆盖并按本期真实包族复核；Release/Tag/SHA 已核；重点事实抽查超过14条；插件 A/B/C/D、案例 P1—P5、衍生 D1—D4、商业事实分层均完成。研究门控通过，可进入 `report2article`；文章必须保留 SQLite P0、Developer Preview/未审计、插件 A=0、案例 P1/P2=0、商业转化未证实和三项可执行停止条件。