# DeepSeek Harness 全景跟踪报告

> **检索截止**：2026-09-08 14:20:27（Asia/Shanghai）  
> **主增量时间窗**：`(2026-09-01 14:20:51+08:00, 2026-09-08 14:20:27+08:00]`  
> **最近 7 天回溯窗**：`[2026-09-01 14:20:51+08:00, 2026-09-08 14:20:27+08:00]`。本期因上次成功基线为 09-01，主窗与回溯窗基本重合。

## 1. 导读：alpha.2 修性能，alpha.1 重写 Session 合同

本期 DeepSeek Harness（dsh）从 `v0.1.2-rc.1` 进入 **`v0.1.3-alpha.1` 与 `v0.1.3-alpha.2`**。Tag 与 Commit 已核对：alpha.1 指向 `d347e703908d0406b7a7ef80e3a0e594d86b2215`；alpha.2 指向 `82a5fd61a7cf5c293cec4bdff68f455398d685e9`。截至截止时，npm `alpha=0.1.3-alpha.2`，但 `latest=next=0.1.2-rc.1`；主干 HEAD 已到 `c389f96bf3a9b6807cb71ed6bdad5849be0df6d8`，晚于 alpha.2。因此试用必须锁 tag/SHA，不能把 npm latest、alpha 和 master 混为同一基线。

本期最大的技术事件不是 Web 新功能，而是 **Session 从普通 persistence API 转向生命周期作用域的 `SessionHandle`、单进程锁与 v2 generation 迁移链**。Assistant 流按 attempt 聚合为 durable settlement，历史 v0/v1 通过不可变的相邻 generation 迁移；这让 crash/replay 语义更清晰，也把升级成本从“改调用”扩大为“生命周期、并发持有、格式迁移”三重兼容。

alpha.1 同时承认历史 Session 加载的性能回退；alpha.2 随即降低长会话打开、恢复、继续对话时的卡顿与内存，并让模型在引用长会话时按需读取预览外内容。这里能确认“官方在修”，不能确认“容量问题已关闭”：没有公开 100k-event、P50/P95、内存峰值与 rollback 基准。

生态侧继续加速：`dshmarket` 到 1.45.0，`@xmanrui/dsh-im` 到 4.15.0，dsh-cost-meter 明确声明 alpha.2 compatible，dsh-univer-office 把 Office/Spreadsheet collaboration Gateway 与 Viewer 做成新产品形态。然而，**插件 A 级仍为 0，P1/P2 仍为 0，客户、采购、收入、SLA 与独立生产指标仍未发现。** 本期是“架构与产品形态加速”，不是“生产与商业拐点”。

## 2. 版本、分发与阶段状态

| 对象 | 时间/指针 | 结论 |
|---|---|---|
| `v0.1.3-alpha.1` | 2026-09-04 19:34:32+08；SHA `d347e703...` | Session API/格式的破坏性变化主版本 |
| `v0.1.3-alpha.2` | 2026-09-07 21:59:29+08；SHA `82a5fd61...` | immutable prerelease；长会话、Web、Windows、子代理体验修复 |
| npm | `alpha=0.1.3-alpha.2`；`latest=next=0.1.2-rc.1` | alpha 与默认分发并行；registry 未见 alpha.1 主 CLI 版本 |
| master | `c389f96b...`（截止时） | 晚于 alpha.2，只能视为未发布主干信号 |
| 官方阶段 | Developer Preview | 仍明确会有 compatibility-breaking changes |
| 安全状态 | 未安全审计 | 官方明确不可视为 secure 或 production-ready |

SAFETY 没有因 alpha.2 改变：项目可执行模型生成代码与命令、加载第三方插件，并访问可用的网络、进程、凭据和文件；sandbox、approval、permission 只能降风险，不能保证隔离。

## 3. 技术线：49 组模块未扩容，核心合同在组内重排

alpha.2 的官方 `packages/README.md` 仍列出 **49 个 package groups**，与上期一致。没有发现 group 级新增、删除或更名；本期是组内 API、数据格式、默认工具和客户端行为变化。

| 层面 | 官方 groups | 本期状态 |
|---|---|---|
| 产品 API / Session 主干 | `core`、`goal`、`schedule`、`feedback`、`identity`、`todo`、`plan`、`session`、`session-query`、`workspace` | SessionHandle、async loop、lock、v2 migration/settlement 是 P0 |
| 模型、上下文、编排 | `llm`、`context`、`compaction`、`subagent`、`preset`、`guard`、`jobs`、`workflow`、`experimental` | pi-ai 0.85.1；长会话按需读；continuable subagent 控制扩展 |
| 执行、文件、隔离 | `subprocess`、`shell`、`terminal`、`code-runtime`、`sandbox`、`fs`、`lsp`、`skill`、`e2b` | SDK/Headless/ACP 默认 read/write/edit；普通 subprocess handle 去 pid |
| Web、事件、数据载荷 | `web`、`webhook`、`attachment`、`spill`、`storage` | 任意文件上传、图片工具卡、代理变量、断线恢复 |
| 交互、安全配置、扩展 | `interaction`、`credentials`、`settings`、`extensions`、`hooks` | persona prefix/suffix；旧配置需适配 |
| RPC、SDK、前后端、启动 | `api`、`typert`、`sdk`、`acp`、`boot`、`host`、`client`、`bundle` | Intel Mac runtime、Windows SDK 修复、“Open in”入口 |
| 工程支撑 | `test-support`、`runtime-diagnostics`、`util` | 有测试/诊断设施，仍没有公开生产容量承诺 |

### 3.1 Session v2：升级真正需要验证什么

调用链已变为：

```text
Web/SDK/ACP 输入
 → core Agent Loop（create 异步）
 → SessionHandle（生命周期持有）+ 单进程锁
 → JSONL canonical generation
 → v0→v1→v2 相邻迁移
 → Assistant attempt settlement
 → projection / cache / query / title / client
```

v2 的关键设计是：历史 generation 不被原地改写，而是通过静态、相邻迁移链解码；write open 在编码与校验后发布新 generation，旧 source 保留。Assistant 的完整 compact timed stream 被嵌入 `assistant/message`，失败、重试、取消、stream-error 则落为 `assistant/attempt`，Web 继续消费进程内 live stream。

正面影响：

- Session 事实源、迁移、projection 与 live UI 的边界更明确；
- 失败/重试尝试可持久化，不必只依赖运行时瞬态；
- generation 不原地覆盖，有利于回溯和离线校验。

新增风险：

- 旧插件若同步调用 `agentLoop.create()`、越过 `SessionHandle` 或多进程同时开同一 Session，将直接不兼容；
- Session lock 会影响多实例、后台任务、恢复工具与自建索引器；
- alpha.1 已证明迁移与读取路径存在性能回退，alpha.2 的改善仍缺公开容量数据；
- migration 发布成功不等于 title、projection、attachment、schedule、query index 与 telemetry 全部一致。

升级闸门应至少覆盖：v0/v1 样本只读 open、write migration、generation/hash/count、并发锁拒绝、进程崩溃尾部修复、resume、fork、title/projection、附件、schedule、query、旧版本只读回滚。没有这套测试，不应覆盖现有 home。

### 3.2 子代理：从“能继续”到“可控制队列”

alpha.1 将 Agent Team `send_message` 统一为 steer 语义，并保留发送者与顺序。alpha.2 又为 continuable subagents 增加消息排队、编辑、删除、单条/全部 Steer 与 Stop；排队消息在 sending 完成前不能编辑、删除或 steer。

这提升了交互可控性，但状态机未因此自动可靠。仍需验证：重复投递、编辑与发送竞争、stop 后拒绝新消息、父会话关闭后的 child quiescence、断线恢复后的队列重放、权限继承和 durable attribution。Release notes 没有给出幂等/HA 证明。

### 3.3 文件、网络、模型与客户端

alpha.1 的任意文件上传会保存路径，模型再用既有文件工具按需读取；图片可在 Web 工具卡中渲染。出站请求遵循 `HTTP_PROXY`、`HTTPS_PROXY`、`ALL_PROXY`、`NO_PROXY`。这提高企业网络可用性，也新增治理点：上传文件类型、大小、保留、路径权限、代理信任、NO_PROXY 绕过与内容外发必须单审。

alpha.2 将 SDK、Headless、ACP 默认文件编辑工具统一为 read/write/edit，Web minimal 与 sdk-minimal 不变。该变化缩小默认编辑面的复杂度，但不是 sandbox。persona 配置拆为 prefix/suffix，普通 subprocess handle 移除 pid；两者都可能让第三方 config、常量或进程管理插件出现静默退化。

## 4. 生态线：供给加速，兼容与权限债同步增长

### 4.1 插件门控

本期连续台账保守评级：**A=0，B/B-=6，C=5，D=5**。

| 对象 | 本期证据 | 评级与边界 |
|---|---|---|
| dshmarket 1.45.0 | OIDC trusted publisher、SLSA provenance、signature/integrity、vitest/compat/restart smoke；修复私有 Git 更新识别 | B；市场自身更成熟，但下游包仍逐个准入 |
| `@xmanrui/dsh-im` 4.15.0 | 9 IM + 公网 AI Office；签名；build/test/check；显式兼容 alpha.1，未列 alpha.2 | B-；凭据、公网通道、18MB 依赖面需单审 |
| dsh-cost-meter 1.7.14 | 将 alpha.2 标 compatible、alpha.1 标 unknown；公开多供应商网络权限 | B-；主动维护兼容矩阵，但会触及余额/API/凭据 |
| dsh-univer-office 0.2.14 | Apache-2.0；host/integration/client/skills/telemetry tests；Gateway/Viewer | B-；产品和测试面清楚，但约 180MB、浏览器/libsql/原生与 insiders 依赖提高风险 |
| Bridge / Vision Router / Mnemon / pi2dsh | 上期 B/B- 台账延续，未出现 A 级独立证据 | B/B-；需补 alpha.2 实机矩阵 |
| Pocket / dsh-web / 旧 unscoped dsh-im / skill-mover / hooks-adapter | 高权远程、身份或兼容闭环仍不足 | C/D；继续暂缓公网和自动采用 |

A=0 的原因不是“没有代码”，而是没有对象同时完成：本期宿主实机兼容、权限/数据流审计、断线与恢复、供应链闭环和独立生产验证。

### 4.2 案例与社区

案例连续口径更新为 **P1=0、P2=0、P3=11、P3→P4=4、P4=1、P5=1**。新增 P3 是 cost-meter 与 Univer Office 的可核包、测试和集成形态；它们依旧是项目方工程证据，不是客户侧生产证据。

官方仓快照为 215,430 stars、25,417 forks、929 subscribers（2026-09-08 14:04+08）。这说明极强关注与开发者流入，不说明 SLA、采购或生产规模。GitHub `dsh-plugin` topic 宽查询混有插件、工具和衍生项目，不能把搜索匹配数当生态总量。

## 5. 衍生项目与商业：Office 产品形态新增，转化仍未证

本期衍生分布为 **D1=6、D2=3、D3=3、D4=3**。最清晰的新对象是 dsh-univer-office：它把 inline preview、浮动 Worktree、session-end review、协作 Gateway 与 Viewer 组合成办公产品，证明官方 client/session/tool seam 可以长出垂直界面；但没有独立用户规模、持续运行与生产 SLA。

商业分层为 **L1=2、L2=4、L3=1、L4=1（排除）**：L1 仍只有官方阶段/产品状态与 Ollama 官方接入；L2 是 market、desktop、trading、Univer Office 的项目方主张；L3 是独立企业准备度判断；L4 泛 DeepSeek 公司融资/模型新闻与 dsh 项目商业化错配，排除。

本期没有发现客户公告、采购合同、收入、融资、SLA 或独立生产指标。因此可写“产品入口和垂直形态增加”，不可写“DeepSeek Harness 已商业化”。

## 6. 双线交叉判断

### 命题一：Session 合同正在成为生态的版本税（确定性：高）

官方在一周内引入 SessionHandle、async loop、lock 和 v2 migration；生态中 IM 只明确兼容 alpha.1，cost-meter 明确兼容 alpha.2，而 market 的部分 peer 仍落在 0.1.2 系列。技术 seam 已被消费，但兼容速度不一致。结论：任何生态评估都必须以宿主版本、profile、Session format 与具体包版本为四维矩阵，不能用“最新版”三个字代替。

### 命题二：长会话恢复是竞争力，也是当前最大回归面（确定性：高）

v2 settlement 与 generation migration 让重试、取消、恢复具备更清晰事实模型；alpha.1 的性能回退和 alpha.2 的紧急优化又说明该路径仍在高频变化。对 OpenClaw 的借鉴重点应是 immutable generations、durable attempts 与 projection seam；采用重点则是回归门控，而不是直接迁移现有历史。

### 命题三：市场、IM、Office 正把插件体系推向“平台”，治理没有同步平台化（确定性：高）

market 管安装与更新，IM 管公网与机器人凭据，Office 管文档、浏览器、Gateway 与遥测。这些不是低权装饰插件，而是新的 trust boundaries。官方 SAFETY 仍否定 production-ready，生态必须自行补 permission manifest、provenance、端点/数据保留、撤回、rollback 与审计。

### 命题四：关注度远高于采用证据（确定性：高）

仓库热度、插件发布频率和产品型项目都在上升，但 P1/P2、客户、采购、收入、SLA 仍为 0。最合理策略仍是受控试验与治理工具开发，不是企业 production 承诺。

## 7. 对 OpenClaw 与老板的行动建议

### 立即体验

1. 在一次性 VM/容器或独立 OS 用户中，锁 `dsh-v0.1.3-alpha.2` 与 SHA；使用全新 home、假凭据，不覆盖上期 rc.1 数据。
2. 准备脱敏 v0/v1 Session 样本，做只读 open、write migration、generation/hash/count、并发锁、崩溃恢复、resume/fork 与旧版本只读回滚。
3. 只读体验 cost-meter 的权限 manifest 与 dsh-univer-office 的产品形态；禁止真实 API key、敏感文档、远程隧道和自动安装下游。

### 可做 Demo（1—2 周）

- **Session v2 迁移闸门**：host×profile×format×plugin 矩阵，覆盖 lock、async create、attempt settlement、title/projection/attachment/schedule/query。
- **子代理队列故障注入**：对 queue/edit/delete/steer/stop 做重复、乱序、断线、父会话关闭和恢复测试。
- **插件权限与数据流预检**：解析 network destinations、credentials、browser/native dependencies、telemetry、retention、scripts、provenance 与 uninstall 残留。

### 值得开发

1. 优先做迁移 verifier、兼容矩阵与 rollback，不再做一个单纯 UI。
2. 借鉴 dsh 的 immutable adjacent generations、durable attempts、capability seam 和 profile/bundle；保留 OpenClaw 更明确的 gateway trust boundary、审批来源语义与故障恢复。
3. 把 dsh 作为外部受控 runtime/adapter；文件、网络、凭据与 Session 数据和 OpenClaw 主控制面隔离。

### 暂缓与停止条件

- 暂缓 Pocket 公网、IM AI Office、dsh-web SSH/SFTP/tunnel/cron、market 一键安装未知包，以及无 alpha.2 矩阵的高权插件。
- 若 Session migration 无校验/回滚、锁导致后台任务死锁、队列断线后重复副作用、persona/default-tool 变更造成审批或工具面漂移，应停止扩大试点。
- 在出现独立 P2/P1、30 天持续运行、规模/成本/P50/P95/故障与安全边界前，不升级为企业合作或生产选型。

## 8. 下期验证问题

1. alpha.2 之后是否发布 rc/stable，npm latest 是否切换？
2. Session v2 是否公开迁移 verifier、rollback 与 100k-event 基准？
3. lock 的多进程/HA/后台任务语义是否有正式合同？
4. continuable subagent queue 的幂等、断线重放、stop/close 是否有测试或文档？
5. 哪些重点插件显式并实测 alpha.2，而非只写宽 peer range？
6. dshmarket 是否把 permission manifest、撤回、恶意包通知和离线 allowlist 做成强制门禁？
7. Univer Office 是否披露遥测、数据保留、Gateway 威胁模型、包体与原生依赖审计？
8. 是否首次出现独立 P2/P1、客户、采购、收入或 SLA？

## 9. 研究门控与缺口

- 研究域：10/10 完成（版本、模块、插件、社区、案例、衍生、商业、安全、竞争、行动）。
- 官方 package groups：49/49 覆盖；Release/Tag/SHA/npm/README/SAFETY 已复扫。
- 插件：连续台账 + 4 个本期重点对象；未安装未知插件，故无 A 级。
- 案例：P1/P2 搜索与原始证据复核完成；结果仍为 0。
- 衍生：D1—D4 完成；商业 L1—L4 完成。
- 缺口：无公开容量/rollback 基准；无独立生产与商业转化；搜索提供商曾限流，关键结论已改用 GitHub/npm/官方文档直抓，不依赖搜索摘要。

## 10. 主要来源

### 官方
- <https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.3-alpha.1>
- <https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.3-alpha.2>
- <https://api.github.com/repos/deepseek-ai/deepseek-harness/git/ref/tags/dsh-v0.1.3-alpha.1>
- <https://api.github.com/repos/deepseek-ai/deepseek-harness/git/ref/tags/dsh-v0.1.3-alpha.2>
- <https://registry.npmjs.org/@deepseek-ai%2Fdsh>
- <https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.3-alpha.2/packages/README.md>
- <https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.3-alpha.2/docs/architecture.md>
- <https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.3-alpha.2/packages/session/README.md>
- <https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.3-alpha.2/README.md>
- <https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/dsh-v0.1.3-alpha.2/SAFETY.md>

### 生态与商业
- <https://github.com/dsh-market/dsh-market/releases/tag/v1.45.0>
- <https://registry.npmjs.org/dshmarket/latest>
- <https://registry.npmjs.org/@xmanrui%2Fdsh-im/latest>
- <https://registry.npmjs.org/dsh-cost-meter/latest>
- <https://registry.npmjs.org/dsh-univer-office/latest>
- <https://api.github.com/repos/shaobeichen/dsh-pocket/releases/latest>
- <https://docs.ollama.com/integrations/deepseek-harness>
- <https://wavect.io/blog/deepseek-harness-enterprise-review/>
