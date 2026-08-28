# DeepSeek Harness 全景跟踪报告｜2026-08-28

- **报告日期**：2026-08-28（周五，Asia/Shanghai）
- **主增量窗**：2026-08-25 14:10:00（不含）—2026-08-28 14:23:20（含，UTC+8）
- **7 天补漏窗**：2026-08-21 14:00:00—2026-08-28 14:23:20（UTC+8）
- **上期基线**：`v0.1.1-rc.2` / `dsh-v0.1.1-rc.2` / `b150a551b8d465e31e418e1b2eaf5e79bbb7d28e`
- **本期对象**：`v0.1.2-alpha.1` / `dsh-v0.1.2-alpha.1` / `cd5ef8148158c3a752a658978873241fdf8e2bbc`
- **阶段**：Developer Preview；官方明确将继续发生兼容性破坏，且尚未接受安全审计，不应视为 production-ready

> **一句话结论**：DeepSeek Harness 在本期完成了应用入口、SDK/ACP、Remote API、子代理路由与 Web 访问面的关键收敛，社区也从“插件热潮”扩展到桌面发行、垂直设计运行时、Windows 安装器和远程 worker；但版本从 RC 转入新一轮 alpha、默认网络与数据外发面扩大、插件 ABI 剧烈漂移，且仍无可独立核验的 P1 生产或 P2 公开试点，因此最合理的策略仍是“锁版、隔离、做受控 PoC”，而不是承诺企业 SLA。

---

## 1. 质量门控摘要

| 门控 | 结果 | 说明 |
|---|---|---|
| 完整性 | **通过** | 技术线覆盖版本、官方模块、接口、调用链、工程成熟度；生态线覆盖插件、案例、衍生、商业、竞品与行动 |
| 时效性 | **通过** | 主窗与 7 天补漏窗明确；最终版本/Tag/npm/Topic 于 14:23 复扫 |
| Release / Tag / SHA | **通过** | Release、Tag 与 HEAD 均指向 `cd5ef814…2bbc`；发布时间 `2026-08-27T17:06:37Z` |
| 阶段与安全 | **通过** | README 的 Developer Preview 与 SAFETY 的“未安全审计、非 production-ready”均按原文保留 |
| 模块真实性 | **通过** | 模块骨架来自当期官方 `architecture.md`、Profile/Bundle 与 package README，不沿用上期固定概念分类 |
| Breaking / 迁移 | **通过** | ApiProxy 删除、Profile 统一、PTC 更名、UI 分层、数据外发与 WebFetch 默认变化均纳入 |
| 插件真实性 | **有条件通过** | 11 个重点对象逐项核仓库/包/版本/兼容/许可/测试/权限/供应链；A=0，不凑数 |
| 案例真实性 | **通过** | P1=0、P2=0；Demo、作者自测、下载与 Stars 未包装成生产采用 |
| 衍生项目 | **通过** | 5 个核心项目按 D1—D4 核验，普通插件未重复计算 |
| 商业真实性 | **通过** | 未发现 DSH 专属付费客户、采购、双方合作、融资、招聘或监管动作；负面结论按“本轮未发现”表述 |
| 证据抽查 | **通过** | 官方/技术原文 16 条；插件与案例原始证据均达到门槛 |
| 零编造 | **通过** | 发现 `pi2dsh 0.12.4` 与 npm 元数据冲突后，以 registry `/latest` 的 **0.21.0** 为准，错误值未进入结论 |

**门控限制**：本期未安装第三方插件或二进制，未做 Windows 实机矩阵、动态 SSRF/token fuzz、全仓逐行审计、P95/并发/长跑基准，也未获得客户侧一手生产数据。GitHub 匿名 API 后段限流，最终复扫用固定 Release 页面、raw 文档、Git refs、npm registry 与搜索端点交叉核验。

---

## 2. TOP 8 关键变化

1. **`v0.1.2-alpha.1` 发布，版本稳定性没有升级**：从 `0.1.1-rc.2` 进入新一轮 alpha，官方仍写 Developer Preview 与 breaking changes；这意味着“功能更完整”不能推导为“版本更稳定”。
2. **应用入口统一到 Profile/Bundle**：`web`、`headless`、`sdk`、`sdk-minimal`、`acp` 成为正式模板，SDK 与 ACP 通过独立 app bundle 叠加在 `dsh-base` 上；私有 executable/direct-config 路径不再是受支持入口。
3. **ACP 从接口占位走向可用控制面**：补齐标准 session control、模型设置、MCP、permission、cancel，并规定 prompt route pin、关闭顺序与 trusted-controller 边界；但自身不是零信任身份系统。
4. **子代理路由变得可控但不是任意可改**：调用方可指定 provider/model/reasoning/max output，Agent 只在授权范围内选择；provider 不支持时应 fail loudly。Codex/Claude Code 可在 bundle 层配置模型，但当前不接受每次调用 route override。
5. **安全面一进一退**：网络 Web UI 新增 launch URL 一次性 token，缓解裸暴露；与此同时 public WebFetch 默认启用且公网请求不再逐次审批，SSRF 分类器成为关键安全依赖。
6. **数据外发面扩大**：官方 DeepSeek adapter 默认附带启用插件包名与版本，可关闭；Session 日志增量上传为 opt-in、默认关闭。两者与 OTel telemetry 是三个独立数据面，不能用一个“遥测开关”笼统解释。
7. **兼容迁移集中爆发**：旧 ApiProxy 已删除，统一迁移 `@Remote`；Code Mode 改名 PTC；UI 工程大拆分；Profile patch 仍按 row 整块替换 config，旧 patch 可能静默丢失新增安全默认。
8. **生态从插件走向交付层，但生产证据仍为零**：OpenDesign、两类 Desktop、Windows Launcher、远程 `dsh-sev` 证明社区在补发行与部署；插件侧 Bridge、Vision、pi2dsh、mnemon 活跃，但 P1/P2、SLA、TCO、并发和客户对等确认仍未出现。

---

## 3. 官方版本、发布与阶段

### 3.1 四项硬核验

| 项目 | 本期值 | 判断 |
|---|---|---|
| GitHub Release | `v0.1.2-alpha.1`，2026-08-27 17:06:37 UTC | 最新公开 prerelease |
| Tag | `dsh-v0.1.2-alpha.1` | 与 Release 一致 |
| Tag / HEAD SHA | `cd5ef8148158c3a752a658978873241fdf8e2bbc` | Release 合并提交、Tag、HEAD 对齐 |
| npm `@deepseek-ai/dsh` | 14:23 `/latest` 仍为 `0.1.1-rc.2` | GitHub Release 与 npm 分发存在时差，不能把 alpha 当成 `npx` 默认已可取 |

GitHub Commit API 显示该 SHA 时间为 `2026-08-27T16:57:43Z`，提交信息为 `release: dsh@0.1.2-alpha.1`，且 merge commit 未签名。未签名不等于发布被篡改，但企业采用还应单独核 Tag 签名、npm provenance、wheel 哈希与 SBOM。

### 3.2 阶段为何仍是早期预览

- README 原文：`DeepSeek Harness is in developer preview and iterating rapidly. THERE WILL BE COMPATIBILITY-BREAKING CHANGES.`
- SAFETY 原文：`It has not undergone a security audit and must not be treated as secure or production-ready.`
- SAFETY 同时说明 sandbox、approval、permission 只能降低风险，不能保证隔离。
- 本期包含 ApiProxy 删除、应用入口统一、PTC 更名、UI 分层、默认网络策略变化，均是大幅迁移信号。

**结论**：当前处于“架构快速收敛、兼容承诺尚未冻结”的开发者预览期。可以研究、做隔离 Demo 和有限 PoC；不宜承载未信任代码、生产密钥、敏感会话或无人值守公网控制面。

---

## 4. 当期官方模块地图

### 4.1 Profile / Bundle 运行树

```text
dsh CLI + app-boot
├─ profile:web        = dsh-base → dsh-web-app       （支持 live patch reload）
├─ profile:headless   = dsh-base → dsh-headless      （startup-only）
├─ profile:sdk        = dsh-base → dsh-sdk-app       （startup-only，stdio JSON-RPC）
├─ profile:acp        = dsh-base → dsh-acp-app       （startup-only，ACP JSON-RPC stdio）
└─ profile:sdk-minimal = dsh-sdk-minimal             （独立完整树，不加载 dsh-base）
```

层叠顺序为：bundle（按 Profile 声明）→ Profile `cordis.patch.yml` → Home patch → `--patch` overlay。Patch 按 row id 定位并**整块替换 config**，不是字段级深合并。

- `dsh-base`：模型、工具、持久化、sandbox/approval、settings、credentials、telemetry。
- `dsh-web-app`：浏览器 UI、Gateway 与 Remote 控制面。
- `dsh-headless`：无 server 的一次性 runner；stderr 输出进度，stdout 只保留最终结果。
- `dsh-sdk-app`：SDK stdio server；stdout 只能有 newline-delimited JSON-RPC。
- `dsh-acp-app`：automation-only ACP stdio server。
- `dsh-sdk-minimal`：两工具、未压缩 JSONL、`danger-full-access`，不含 base 的 settings、managed credentials、telemetry、compaction、skills、jobs、subagents；“minimal”不等于“安全”。

### 4.2 官方模块全景状态矩阵

| 官方域 | Service / API / 事件边界 | 本期状态 | 成熟度与生产约束 |
|---|---|---|---|
| Cordis / Loader / app-boot | Context、DI、typed events、reversible effects | 正式应用统一 Profile 启动 | 组合模型清晰；in-process 插件仍是可信代码 |
| Profiles / Bundles | `--profile`、`--patch`、`--dump-config` | 五模板与 SDK/ACP bundle 定型 | patch 整块替换可能丢默认值，升级前必须 diff |
| Session core | `ctx.sessions`、append-only `SessionEvent`、`session/event` | 初始化、磁盘占用、尾截断修复改进 | “Model-visible means logged”是强不变量；schema/恢复仍需压力测试 |
| System Prompt | `ctx.systemPrompt`、section/tool schema assembly | Shell 与 workflow 顺序修复 | 顺序影响行为与缓存；插件必须遵守所有权层 |
| Agent / Agent Loop | `ctx.agents`、`ctx.agentLoop`、`agent/*` | queued draft、turn/step 语义保持 | waterfall/取消/重入竞态复杂 |
| LLM / Adapter | `ctx.llm`、`agent/request→llm/stream` | provider 支持更新；DeepSeek adapter 新增元数据与日志面 | 数据出境、provider 漂移与字段治理是新增风险 |
| Tools / PTC | `ctx.tools`、`tools/pre/execute/post`、`run_code` | Code Mode→PTC；SDK 能力只在 `run_code` | 需证明内部调用仍走相同 approval/sandbox |
| FS / Subprocess / Shell | `ctx.fs/subprocess/shell`、`fs/*` | Bash/PowerShell 管道、readiness、进程树修复 | 文件 sandbox 不等于网络/进程隔离 |
| Terminal | `ctx.terminals`、owner-scoped PTY | UI 展开与跨平台修复 | ConPTY、EOF、信号、编码仍是高风险矩阵 |
| Sandbox / Approval | `ctx.sandbox` + policy + permission | SAFETY 明确不保证隔离 | 未审计；不能作为唯一安全控制 |
| Web Fetch / Search | Web tool + network policy | public WebFetch 默认开启、声称内置 SSRF 防护 | 需测 DNS rebinding、IPv6、redirect、proxy、metadata |
| Attachment / Image | `ctx.attachments`、durable refs、local CAS | 图片先显示后压缩上传；Trajectory 展图 | optimistic UI、路径暴露、hash 与生命周期需验证 |
| Compaction / Context | Session projection→model history | 图片占用纳入压缩计费 | 长会话、多图和预算误差需基准 |
| Persistence | JSONL / SQLite providers | 日志空间优化、尾修复警告 | SQLite 迁移/回滚仍未见通用承诺，继续列 P0 |
| API Gateway / Remote | Typert Remote Host + controllers | ApiProxy 删除，统一 `@Remote`；WebSocket 心跳 | 强 breaking；重连顺序、幂等、backpressure、鉴权待测 |
| Web server / auth | launch URL capability token | 网络访问时要求一次性 token | 不等于 SSO、RBAC、CSRF、TLS 或多租户认证 |
| Conversation / Client UI | Chat node、focused client modules | 回答折叠、token、导航、宽度/字号、草稿队列、工程拆分 | import 边界变化会破坏旧 UI 插件 |
| ACP server | ACP v1 JSON-RPC stdio | session/model/MCP/permission/cancel 补全 | trusted controller；自身无强身份系统，仍缺 deletion/fork/load/terminal |
| SDK server / client | SDK JSON-RPC | 正式 `sdk` Profile；Python Windows x64 runtime | stdout 污染、同版依赖、Windows原生闭包需测 |
| Subagent | `ctx.subagents`、provider registry | route/effort/max-token 受能力验证；不支持即启动失败 | 权限在启动时固定，但 provider/外部 CLI 权限仍需单审 |
| Goals / Plans / Workflow | scoped services/events | 本期主要是 prompt/preset 修复 | 组合可见性需 profile 级测试 |
| Jobs / Schedule | background job/timer services | 本期无重大变化 | 无 HA、跨节点 lease 与 SLA |
| MCP | per-session stdio/HTTP mounts | ACP 可携带标准 MCP declarations | command/env/header 由 trusted client 授权，需 secret/egress/timeout/size 限制 |
| Telemetry | OTel/telemetry events | Base 默认关闭；与 adapter 元数据/日志上传独立 | 三个开关必须分别治理、审计和告知 |
| Settings / Credentials | settings cards、provider sign-in | 插件可注册提供方登录控件 | 增加钓鱼/凭证劫持面，需 trusted-plugin policy |
| i18n | UI language registry | 支持第三方语言 | 安全文案必须有可信 fallback |
| Runtime tests / invariants | unit/e2e/conformance/entrypoint checks | 官方测试叙述较完整 | 没有独立审计或公开全量兼容矩阵 |
| Python runtime packaging | wheel 内含普通 dsh CLI | 新增 Windows x64 | 发行物存在不等于 Windows 全面生产就绪 |

### 4.3 核心调用链

```text
Profile resolve → ordered patches → Cordis plugin tree
→ Agent inbox → turn/start → claim
→ prompt sections + tool schemas → agent/pre-step
→ step/start → durable user/message → deriveMessages(Session log)
→ agent/request → llm/stream → assistant/chunk* → assistant/message
→ tool/call* → tools/pre-execute → execute → post-execute → tool/result*
→ step/end → next step / agent/turn-stopping → turn/end
→ persistence/projection → UI / @Remote / ACP
```

三层边界：Service 定义可替换能力；Session/Agent/Capability 三类事件表达持久事实、运行中控制和能力策略；Web/SDK 通过 `@Remote` 暴露选定 Host capability，ACP 走独立标准 transport。API 不能绕过 Service 所有权和 Session 事实源。

---

## 5. 重点技术变化深潜

### 5.1 Profile 统一：入口更一致，配置漂移风险上移

统一入口减少 SDK/ACP/Web 各自复制 agent core，也让 entrypoint 静态检查成为可能；但 Profile patch 的 whole-config replacement 会让旧 override 静默遮掉新增字段。生产评估必须保留每个环境的 `--dump-config` 快照，升级时做语义 diff，并分别黑盒验证 web/headless/sdk/acp 的 stdout、EOF、signal 与 persistence flush。

### 5.2 ACP：可用控制面，不是零信任边界

ACP 现覆盖初始化、认证、session new/list/resume/close、模型配置、prompt、cancel、update、permission 与 MCP。一次 prompt 内 provider/model/effort 会被 pin，配置变更只影响下一 turn；close 应先阻止新工作，再取消 admission/Agent、drain update/descendant、flush persistence。

限制同样明确：`authenticate` 立即成功，客户端被视作 trusted controller；MCP command/env/URL/header 都是强权限输入；远程 ACP 子代理仍主要 one-shot，且不进入父进程本地 trace corpus。必须测试 prompt/cancel/config/close 竞态、MCP 部分失败回滚、close 幂等和断连 quiescence。

### 5.3 子代理路由：从“能启动”到“受约束选择”

调用方可给 provider/model/reasoning/max output，Agent 只能从授权范围选择；provider 能力不匹配应 fail loudly。in-process 和 DSH SDK provider 支持 agentOptions；ACP/Codex/Claude provider 当前拒绝每次调用 route override，但后两者可在 bundle 配置模型。

这减少子代理偷偷切模型或扩大权限的风险，却未解决同进程资源隔离、外部 CLI 凭证、父子 policy 继承与 resume/fork 后策略不降级。最重要的回归不是“能否跑”，而是父级 deny-read、网络禁用、provider allowlist 在任何子路径中都不能被放宽。

### 5.4 Adapter 元数据与 Session 上传：新增两个合规面

- **插件元数据**：默认随官方 DeepSeek 请求附带 enabled plugin names + versions，可关闭。
- **Session 增量日志**：opt-in、默认关闭，只上传相对进度的增量。

默认插件元数据可能暴露内部包名、版本和漏洞面；Session 日志可能包含 prompt、tool 参数/结果、路径、附件、模型输出与操作轨迹。企业基线应显式配置两者，做字段级抓包、allowlist/redaction、重试去重、跨 session 隔离、删除与数据驻留验证，不能把它们和 OTel 混成一个开关。

### 5.5 一次性 Web token：是票据，不是 IAM

它显著优于裸 Web 控制面，但仍要测试 token 熵、TTL、首次使用原子失效、并发重放、browser history、Referer、proxy/access log、shell history、WebSocket 兑换绑定、Origin/Host、SSH forward 与反向代理头。它没有自动提供多用户、RBAC、审计、SSO、CSRF 与 TLS。

### 5.6 ApiProxy→`@Remote` 与 UI 拆分

旧 ApiProxy 已删除，不是“弃用但兼容”。迁移需扫描 imports、类型生成物、插件 hooks、test mocks，禁止保留隐式 fallback；Remote 只能暴露应用选择的 Host capabilities，controllers 负责 cold read 与 live control。UI 大拆分后应按能力所有层导入，避免越层依赖重新形成隐式 API。

### 5.7 PTC：调用面收窄，不代表沙箱问题消失

Code Mode 更名 PTC，旧 Session 记录可读；SDK 功能只允许在 `run_code` 内调用，不再作为普通 model-callable tools。这减少 schema 污染和双调用面，但必须证明内部能力仍经过同一 policy、timeout、network、filesystem 与 output 限制。需做旧 durable event replay、fork/resume/compaction 与工具注册表回归。

### 5.8 Public WebFetch + SSRF

默认公网访问不再逐次审批，易用性提高，但风险从“人工看 URL”转移到地址分类和连接实现。必测十/八/十六进制 IPv4、IPv4-mapped IPv6、link-local/ULA、DNS rebinding/CNAME、每跳重定向、代理环境变量、userinfo、metadata/Kubernetes service、TOCTOU 与 canonical URL/IP 审计。

### 5.9 Session、图片、终端与 Windows

会话一次加载自有状态和日志压缩能降开销，却加大 snapshot+incremental 边界的重要性；尾截断自动修复必须只删不完整尾记录并保留警告。图片先显示再上传属于 optimistic UI，需要失败/取消/切会话收敛；本地可读路径不能泄露 DSH_HOME 其他内容。PowerShell/Bash 集中修复说明 PTY 生命周期仍活跃。Windows x64 runtime 还需 Win10/11/Server、PowerShell5/7、Unicode/长路径/UNC、ConPTY、CTRL 信号、ACL、进程树与 wheel 完整性矩阵。

---

## 6. 工程成熟度与风险优先级

### P0：进入任何企业 PoC 前必须关闭

1. **未经安全审计**：隔离 VM/容器、最小权限、独立凭证、可恢复备份；不能把 dsh sandbox 当唯一边界。
2. **WebFetch SSRF**：默认网络面扩大，必须做地址规范化、DNS/redirect/proxy/metadata 红队。
3. **一次性 token**：必须验证重放、泄漏、WS/Remote 全覆盖与代理边界。
4. **SQLite/schema 迁移与回滚**：上期风险本期未宣称解决；升级前离线备份、导出/恢复与旧库拒绝路径测试。
5. **`sdk-minimal` danger-full-access**：只能在一次性隔离环境；文档和启动器必须醒目标记。

### P1：PoC 期间持续监控

- 插件包版本默认上报与 Session 增量上传的字段、默认值、脱敏与删除语义。
- ApiProxy 删除与 Profile whole-config replacement 引发的硬 break / 安全默认丢失。
- ACP trusted-controller、MCP command/env/header、prompt/cancel/close 竞态。
- 子代理 route/policy 继承、PTC 内部能力绕过、Windows/PTY 原生闭包。
- Attachment 路径与 optimistic upload、Session 重连顺序、JSONL 尾修复误删。
- 插件 provider 登录控件造成凭证钓鱼，第三方插件作为同进程可信代码的供应链风险。

### P2：从 Demo 走向可运营产品的缺口

- UI/client import 漂移、headless stdout 语义、i18n 安全文案、WebSocket 半开与重复事件。
- 100k events、100 images、10 concurrent agents 的性能、磁盘、内存和预算基准。
- MCP response size/timeout/secret egress、durable subagent mailbox、跨节点 lease、HA/SLO。

---

## 7. 插件生态：活跃、快速、难治理

截至 14:23，GitHub 搜索 `topic:dsh-plugin pushed:>2026-08-25T06:10:00Z` 返回约 **2,792** 个仓库。它只是“贴 Topic 且主窗有 push”的高噪发现指标，绝不等于有效插件数。上期全 Topic 总量 11,432 也不能与本期 2,792 直接作增长率比较：口径不同。

### 7.1 重点插件评级

| 对象 | 当前核验 | 权限/兼容要点 | 评级与建议 |
|---|---|---|---|
| `dsh-plugin-bridge` | npm 0.3.0；活跃；OIDC provenance；完整 verify | 读写/迁移跨 preset Session；未明确 alpha.1 | **B**：隔离回归 `@Remote` 与会话迁移 |
| `dsh-vision-router` | npm 2.0.1；高活跃；百项级测试；provenance | 图片外传、HTTP、截图、Puppeteer、自更新；官方视觉已增强 | **B**：仅在明确缺口时使用 |
| `dsh-web` 单项 | 聚合 0.3.6；活跃；多个可分装包 | SSH、remote UI、launcher、doctor、market 权限差异大 | 单项 **B**；`dsh-web-all` **C**，禁止全家桶直装 |
| `dsh-mcp-connector` | 0.2.26；活跃；provenance | stdio/HTTP/OAuth/API key；peer 部分通配 | **C**：优先官方 MCP，第三方仅隔离评估 |
| `dsh-memory-connect` | manifest 0.6.1；scoped 包名；非 scoped registry 404 | 全会话语义召回、Python embedding、定时维护；仍锁旧 RC | **C**：不从 Git 直装，先厘清分发与 alpha 兼容 |
| ACN | 0.1.0；7天无 push；registry 404 | 外部协作网络、能力广播与消息外传 | **D**：停止候选，只保留历史 Demo |
| session-export | npm 0.1.0；canonical 仓库/maintainer 不一致 | 导出可含 reasoning/tool args/secret | **D**：身份未厘清前暂停 |
| topology | private workspace；7天无 push；无公开包 | 暴露服务/依赖拓扑 | **D**：源码概念，不当可采用插件 |
| autogate | manifest 0.2.0；旧 RC peer；registry 404 | 位于 approval 关键链，LLM classifier 看到操作语义 | **C**：只能给建议，危险操作仍人工 |
| `pi2dsh` | npm **0.21.0**；118 files/约17MB；强 verify | 运行未修改 Pi 扩展，继承文件/进程/网络/凭证面；未声明 alpha peer | **B-**：逐个扩展准入，不能继承整生态信任 |
| `dsh-mnemon` | 新增，npm 0.3.4；显式 peer alpha.1；活跃 | 跨会话记忆、项目文档、第三方 provider、提示注入 | **B-**：假数据做 7—30 天试验 |

**优秀候选只保留 5 个**：Bridge、Vision Router、dsh-web 单项、pi2dsh、dsh-mnemon。A=0，因为本期遵守“不安装未知包”，没有完成代码全审+隔离安装运行双门槛。

### 7.2 生态结构判断

- 三天内 Bridge、Vision、MCP connector、memory-connect、dsh-web、pi2dsh 均快速迭代，说明供给旺盛，也说明 ABI 追赶成本高。
- 大量 peer 仍锁 rc.6/rc.7/rc.8，或使用 `*`；alpha.1 已删除 ApiProxy 并重构 Remote，能安装/能编译均不等于能正确运行。
- 高权扩展成为常态：长期记忆、MCP 进程、视觉/截图、Pi 扩展、SSH/remote UI、自动审批都会触达敏感面。
- 发布可信度不均：Bridge/Vision/MCP connector 有 provenance；其他对象多只有 integrity/signature，Git-only 或同名仓对象风险更高。

---

## 8. 落地案例：P3 增多，P1/P2 仍为零

| 等级 | 案例 | 当前证据 | 判断 |
|---|---|---|---|
| P1 | 真实业务生产 | 未发现使用方一手声明、SLA、连续运行、业务指标 | **0** |
| P2 | 独立公开试点 | 未发现具名团队范围、周期、复盘与客户确认 | **0** |
| P3 | 官方本地 Web harness | UI/Session/图片/终端改进可复现；无 P95/长跑数据 | 开发者 Demo |
| P3 | ACP 互操作 | 标准控制面更完整；无跨实现 conformance 与故障率 | 受控互操作 Demo |
| P3 | Claude Code/Codex 子代理 | 可配模型/route/effort；成本至少双栈 | 短期评测，非企业总线 |
| P3 | Bridge / Vision / pi2dsh | 活跃发布与作者测试充分；缺独立长期稳定数据 | 可隔离跟踪 |
| P3 | dsh-mnemon | 新增三层记忆，显式 alpha peer；无大库/恢复/poisoning结果 | 假数据试验 |
| P3 | autogate | 规则+LLM+人工；无误放/误拒与红队数据 | 研究 Demo，不能做安全边界 |
| P3→P4 | ACN / topology | 源码存在但停止/不可分发信号增强 | 降级观察 |
| P4 | 企业多租户、成熟 Browser/Computer Use、行业私有化 | 缺身份、RBAC、租户隔离、客户证据 | 概念/机会 |
| P5 | “Stars 证明成熟”“已爆发式生产采用” | 无业务一级证据 | 排除 |

所有持续试验至少记录 7 天：崩溃率、会话可续率、升级/回滚、token/美元、P50/P95、内存/磁盘、网络目的地和敏感日志。没有使用方对等确认前，市场表述只能是“可复现开发者平台/插件 Demo”。

---

## 9. 衍生项目：交付层开始成形

| 项目 | 分类 | 与 dsh 的真实关系 | 本窗增量与证据 | 判断 |
|---|---|---|---|---|
| OpenDesign | D1 垂直产品 | `@open-design/dsh-runtime` 原生 Bundle；依赖官方 CLI/Session/LLM | 0.21.0 修复 DSH release-line 兼容；跨平台下载真实 | 本期最强垂直衍生；总下载不能归因给 dsh |
| DeepSeek Harness Desktop | D1 桌面发行 | Tauri 管理 Web/Profile/plugin/runtime/update | v0.9.1 发布；多平台资产；上游漂移与附加许可待审 | 交付价值高，企业部署风险高 |
| DSH Desktop | D1 社区桌面 | 固定上游版本并用插件组成桌面/market | v2.0.3；完整分发；LAN 模式明确无鉴权 | 真实下载，不等于企业采用；LAN 是阻断项 |
| dsh-launcher | D2 Windows 安装器 | 安装/校验官方 npm 包，管理 Node/pnpm/修复/卸载 | v0.4.0；下载量小但需求明确 | 窄而实用，价值取决于官方安装器演进 |
| dsh-sev | 边界 D1 远程管理层 | Bundle/Client 注入 + SSH tunnel + 远程 headless/web + task tool | 主窗新建并发布 0.3.4；仍无独立用户 | 值得跟踪，需审 SSH/iframe/凭证/control-plane |

普通 TUI、Telegram、皮肤、桌宠、计费/探针插件未重复计入衍生。`pi2dsh` 在插件生态中作为桥接层重点跟踪，不重复计为核心衍生数量。

共同风险：桌面发行和垂直产品都能启动进程、管理插件、读写项目并联网；远程层还复制 SSH/DSH credentials。长期可持续性取决于官方能否冻结 Bundle、Client、Remote 与 Session API，并建立可恢复升级与签名分发。

---

## 10. 商业与产业信号：有人产品化，但尚无交易闭环

### 10.1 已验证 P3 信号

- OpenDesign 把 dsh 作为 first-class native runtime，且产品存在 OpenDesign Cloud 付费入口与 DeepSeek 模型促销。
- 两类 Desktop、dsh-launcher 已提供二进制分发；dsh-sev 形成远程 worker 原型。
- GitHub Release 下载与 Stars 证明有人关注/获取，不证明安装成功、活跃、留存、付费或 SLA。

### 10.2 本轮未发现

- P1 生产案例：0；P2 公开试点：0。
- DSH 专属付费客户、收入、留存、TCO、SLA：未发现。
- 可核采购/招标/合同：未发现。
- 双方对等确认合作：未发现。
- Harness 或核心衍生项目完成融资：未发现。
- 明确招聘 DSH 产品/销售/交付岗位：未发现。
- 针对 Harness 的监管、禁令或采购限制：未发现。

DeepSeek 公司融资传闻、模型 API 销售、OpenDesign 总付费、Desktop 总下载、README 赞助 Logo 均不能归因成 Harness 商业采用。

### 10.3 商业机会仍集中在“补治理”

最值得验证的不是再做一个聊天 UI，而是：Enterprise Restricted Profile、Profile Registry + SBOM/签名、可恢复升级、Windows 管理安装、远程隔离 worker、统一观测与成本路由。这些都是高概率痛点，但在拿到客户对等确认前仍只是待验证假设。

---

## 11. 技术供给 × 生态采用交叉判断

| 官方技术供给 | 外部采用信号 | 当前匹配度 | 结论 |
|---|---|---|---|
| Profile / Bundle | OpenDesign、Desktop、dsh-sev、众多插件 | **高** | 是生态真正抓住的核心接口，也是 ABI 漂移主战场 |
| Session / Event log | Bridge、export、memory、Desktop resume | **中高** | 可组合价值已验证；隐私、迁移、损坏恢复未验证 |
| ACP / MCP / Subagent | Codex/Claude 编排、pi2dsh、connector、远程 worker | **中** | Demo 供给活跃；conformance、取消一致性与 policy 继承不足 |
| Web / Remote | Desktop、remote UI、dsh-sev | **中** | 一次性 token 有进展；公网、多用户、RBAC 仍缺 |
| Sandbox / Approval / PTC | autogate、restricted 场景 | **低** | 生态能扩展策略，但官方自己也不承诺隔离，不能外包安全 |
| Attachment / Vision | Vision Router、官方原生视觉、OpenDesign | **中高** | 多模态成为可用能力；成本、数据外传与失败恢复不足 |
| Telemetry / Cost | 少量 probe/meter 插件 | **低** | 没有统一 SLO、成本路由和客户侧生产数据 |
| Windows runtime / installer | Desktop、Launcher | **中** | 真实交付需求成立；原生依赖、签名、更新与回滚仍需治理 |
| Long-term memory | mnemon、memory-connect | **中低** | 需求强烈，但召回质量、poisoning、删除、租户隔离未证 |
| Jobs / Schedule / HA | dsh-sev、远程长任务原型 | **低** | 单机 Demo 可行，跨节点 lease/SLA/故障恢复缺失 |

**关键判断**：DeepSeek Harness 的差异化不是“功能最多”，而是 Cordis + Profile/Bundle + Session 事件流形成的开放 runtime。生态已经验证了“可组合性”，尚未验证“可治理性、可恢复性和生产经济性”。

---

## 12. 与固定竞品的本窗位置

| 竞品 | 本窗强项 | 对 dsh 的含义 |
|---|---|---|
| OpenClaw | secret egress host binding、SQLite backup/restore、plugin provenance、浏览器 relay、外部 supervision | dsh 需要补秘密出站、恢复、插件来源与长期运行闭环 |
| Claude Code | `--restricted`、server-managed settings、企业诊断、marketplace hardening | dsh 缺少同等级 Restricted Profile 与 fail-closed managed policy |
| Codex | 任务互引、多 agent、权限保持、不信任项目指令、日志脱敏、Windows sandbox | dsh 必须证明父子/恢复/ACP 路径中的 policy 不降级 |
| OpenCode | 企业云身份、多 provider、gateway passthrough、可恢复 subagent task | “模型可替换”不等于 provider conformance 与企业身份成熟 |
| Gemini CLI | 企业工作站 OAuth、eval failure summary、容量重试、取消 rollback、subagent 修复 | dsh 需要 transactional cancel、公开 eval 与故障分类 |

最佳竞争位点不是替代 Claude Code/Codex，而是把它们和其他能力编排为开放、可替换的 runtime；真正差距集中在治理闭环，而非工具数量。

---

## 13. 给老板的行动建议

### 13.1 72 小时内：先做能否进入企业 PoC 的硬门槛

1. 固定 `dsh-v0.1.2-alpha.1` + SHA，仅在隔离 VM 与测试仓库运行；若通过 npm，注意 `/latest` 仍为 rc.2，不要误装。
2. 测一次性 token：重放、history/Referer/log、跨 Profile、WebSocket、iframe、LAN proxy、Origin/Host。
3. 抓包验证插件包名/版本上报的关闭开关，以及 Session 增量上传默认关闭是否跨 Profile/升级保持。
4. 复测 PTC、approval、subagent、ACP/MCP 的 policy 继承；任何路径可放宽父策略即停止 PoC。
5. 执行 rc.2→alpha.1 的 Session/JSONL/SQLite 备份、读取、回滚和 Remote/API smoke。

### 13.2 一周内：做三项可沉淀资产

- **Enterprise Restricted Profile**：默认无 PTC/shell/public WebFetch，工作区 fence，插件 allowlist，策略签名，不能被 UI/子代理放宽。
- **Profile Registry + Conformance**：SBOM、来源、lockfile、ABI、兼容矩阵、灰度/回滚；首批覆盖 OpenDesign runtime、两类 Desktop、pi2dsh。
- **Recovery / Eval Pack**：会话尾修复、可校验备份恢复、取消原子性、tool-call 故障分类、100-case ACP/MCP/subagent 回归。

### 13.3 两周内：只争取一个可对等核验的 P2

选择一个真实团队，以隔离 worker 形态接入，不开放公网 Web UI；记录运行天数、任务成功率、人工接管率、成本、越权/故障、RTO/RPO。只有使用方公开确认后才升级为 P2。

### 13.4 暂不做

- 不宣称 dsh 已具备企业多租户、生产隔离、成熟 Browser/Computer Use 或安全审计。
- 不在含生产密钥的员工主机安装未经审计的 Desktop/插件，不启用无鉴权 LAN。
- 不把 DeepSeek 公司融资、模型收入、总下载、Stars 或作者 Demo 当作 Harness 商业化。
- 不做“全家桶插件市场”式默认安装；每个高权插件独立准入。

---

## 14. 下期持续跟踪清单

1. npm `@deepseek-ai/dsh` 是否发布 `0.1.2-alpha.1`，Release/Tag/registry 三者何时对齐。
2. 一次性 token 的 TTL、原子兑换、全 Remote/WS 覆盖、Referer/log 泄漏。
3. public WebFetch 的 SSRF 实现与 DNS/redirect/proxy/metadata 回归。
4. 插件版本上报、Session 上传的配置键、wire schema、脱敏、地域、留存/删除。
5. PTC worker 是否真正处于 OS sandbox，而非仅更名与收窄工具暴露。
6. Bridge/Vision/dsh-web/pi2dsh/mnemon 对 alpha.1 的真实运行兼容。
7. SQLite/JSONL rc.2↔alpha.1 迁移、备份、修复和回滚。
8. ACP route pin、cancel admission、MCP rollback、close quiescence 与 policy 继承。
9. ACN/session-export/topology 是否恢复发布；若连续两窗无活跃，正式标停止。
10. 是否出现首个独立 P2/P1，以及成本、P95、并发、稳定、安全和持续使用数据。

---

## 15. 重点一级来源

### 官方

- DeepSeek Harness Release：<https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.2-alpha.1>
- README：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/cd5ef8148158c3a752a658978873241fdf8e2bbc/README.md>
- SAFETY：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/cd5ef8148158c3a752a658978873241fdf8e2bbc/SAFETY.md>
- Architecture：<https://raw.githubusercontent.com/deepseek-ai/deepseek-harness/cd5ef8148158c3a752a658978873241fdf8e2bbc/docs/architecture.md>
- npm `@deepseek-ai/dsh`：<https://registry.npmjs.org/@deepseek-ai%2Fdsh/latest>

### 插件与衍生

- Bridge：<https://github.com/Totoro-qaq/dsh-plugin-bridge>
- Vision Router：<https://github.com/ysr666/dsh-vision-router>
- dsh-web：<https://github.com/zhu1090093659/dsh-web>
- pi2dsh：<https://registry.npmjs.org/pi2dsh/latest>
- dsh-mnemon：<https://github.com/omdsh-dev/dsh-mnemon>
- OpenDesign：<https://github.com/nexu-io/open-design>
- DeepSeek Harness Desktop：<https://github.com/dsh-tauri-desk/deepseek-harness-desktop>
- DSH Desktop：<https://github.com/anywhere-labs/dsh-desktop>
- dsh-launcher：<https://github.com/Wanbinyu/dsh-launcher>
- dsh-sev：<https://github.com/Buzzso/dsh-sev>

### 竞品

- OpenClaw：<https://github.com/openclaw/openclaw/releases>
- Claude Code：<https://github.com/anthropics/claude-code/releases>
- Codex：<https://github.com/openai/codex/releases>
- OpenCode：<https://github.com/anomalyco/opencode/releases>
- Gemini CLI：<https://github.com/google-gemini/gemini-cli/releases>

---

## 16. 方法与限制

本期由三条研究分片并行完成：官方技术线、插件/案例线、衍生/商业线；主会话逐文件审核、交叉消歧并执行最终官方复扫。版本事实以 Release/Tag/SHA/npm 为硬锚；生态对象以原始仓库、manifest、registry、Release、许可和测试声明为锚；采用与商业结论坚持客户/交易主体优先。

本报告是代码、文档与公开证据审查，不是安全认证、法律意见或生产背书。未动态运行第三方插件、桌面二进制和远程控制项目；所有“可评估”均意味着在隔离环境、假数据、最小权限、锁定版本与可恢复备份下进行。