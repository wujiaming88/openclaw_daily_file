# 全球 AI Agent 研究周报 · 第 23 期 研究母稿（2026-11-02 ～ 2026-11-08）

- 运行日：2026-11-09（Asia/Shanghai）
- 窗口：2026-11-02 00:00 ~ 2026-11-08 24:00（CST）= 2026-11-01T16:00Z ~ 2026-11-08T16:00Z
- 期号：第 23 期（上期第 22 期，窗口 2026-10-26 ~ 11-01）
- 读者：R1 开发者（主）/ R2 架构负责人（协同）
- 本文为冻结母稿（全量研究版）：含覆盖表、发现层摘要、主线专题、综合层、证据等级与来源。读者稿另见 `reader.md`。
- 证据级：A 可核原始事实；B 具名披露/研究结果（未独立核实）；C 有限范围独立佐证；D 欠证/争议。每条主张单独定级。

## 一、信息面摘要

读者本周要回答的问题：**Agent 的执行面该怎么隔离、怎么授权、怎么证明它没越界？** 本周三条线同时给出答案的一角：基础设施侧把沙箱变成平台原语（Agent Substrate / Replit microVM / agent-sandbox），产品侧把权限规则做成可持久化的开关（Claude Code 的 deny/allow 规则），开源 Gateway 侧把「密钥不出日志、代理不出私网」当成补丁主线（OpenClaw 2026.11.1）。因此本期信息面按「执行面」而不是「模型能力」组织。

须看见的对象类型：编码 Agent/CLI/IDE；开源框架（Gateway 与编排 SDK 两条栈）；浏览器/Computer Use；企业 Agent + MCP 协议/评测/工程。
须看见的一手入口：GitHub release/tag Atom、官方 changelog、规范仓库 commit/SEP、厂商工程博客、benchmark 方法与结果页。
信号类型：release / 破坏性变更 / 架构变更 / 安全研究 / benchmark 方法论 / 协议与扩展生命周期。

## 二、TOP5 候选（每条均有窗内 A/B 级原文）

### 1) 沙箱下沉为基础设施：Agent Substrate 1.0 + gVisor 进 CNCF，Replit 全量迁 microVM（主线）

- **2026-11-05**，Google Open Source Blog 宣布 **Agent Substrate 到 1.0**，并将在 KubeCon NA（Salt Lake City，2026-11-09~12）把 **Agent Substrate 与 gVisor 捐给 CNCF**，进入 **Sandbox 阶段**（与 OpenRL 一起）。[A｜官方博客]
- 机制（原文）：Agent 会话 90%–95% 时间在等模型/工具/人审，但不能杀容器（内存里有语言运行时、本地 git 仓库、未提交改动、工具会话）；常驻 Pod 太贵，scale-to-zero 冷启 >20 秒破坏交互。Substrate 把 **Actor（会话状态：文件系统、env、内存、网络规则）与 Worker（预热 Pod 池）解耦**：请求先到 `atenet-router` L7 代理挂起 → controller 放置到空闲 slot → 从分层存储恢复内存与磁盘（**<500ms**）→ 回合结束快照并释放 slot，**不创建新 Pod 对象**，避免压垮 etcd / apiserver / 子网 IP。隔离用 **gVisor（runsc）** 在用户态拦 syscall，因其虚拟化自有内存与进程表，可冻结、写页、异地恢复；需要硬件虚拟化时用 **Cloud Hypervisor microVM**，同一套 API。
- **2026-11-04**，Replit 工程博客披露沙箱引擎**完整重写**：隔离边界从共享内核容器改为 **每沙箱一个 microVM（KVM + Cloud Hypervisor）**，host↔guest 走 **vsock + gRPC**（无需 IP 网络）；guest 内核从 `tinyconfig` 起（去掉蓝牙/无线/USB/显示，禁模块加载），VMM 无特权、无 capabilities；容器仍在 guest 内做 namespace/seccomp/capability 分角色。审计 **2026-06-01~11-04 的 6,211 条 Linux-CNA CVE**，规避 **5,969 条（96.1%）**：4,375 条（70.4%）补丁先于披露落地、676 条（10.9%）靠配置排除；≥15 条被明确描述为可致 LPE。eBPF + LSM 做运行时观测/阻断，每沙箱一个安全监控进程（host+guest 双侧）可自愈，安全组件合并后 **15 分钟内**热更新到全量沙箱。egress 在 guest 外强制（host 侧按 TLS SNI 过滤 + DNS 过滤，guest 关不掉）；凭据由 credential broker 代附加，workload 拿不到账号 key；npm/pip 走 registry firewall。**获取一个沙箱约 500ms**（含挂载卷）。迁移**数亿项目**无数据丢失。[A｜厂商工程博客，数字为厂商自述]
- 同一周 **kubernetes-sigs/agent-sandbox v1.0.10**（2026-11-06T22:09Z）发布，仓库 4.6k★ / 607 fork，Apache-2.0；提供 Sandbox CRD + WarmPool + Python/Go SDK（`create_sandbox(warmpool=…)`、`sandbox.commands.run()`），面向「隔离、有状态、单例」负载。[A]
- 意味着：沙箱从「某产品的功能」变成「有调度 API、有标准归属、有隔离级别可比较」的基础设施层。架构选型的问题随之变成四个可测指标：唤醒/恢复时延、状态快照粒度、隔离级别（gVisor vs microVM vs 容器）、egress 与凭据是否在 guest 外强制。
- 口径提醒：博文写「This week at KubeCon … is donating」，会期在 11-09~12；应写「宣布将在 KubeCon 捐赠 / 进入 CNCF Sandbox 阶段」，不写「已完成毕业」。

### 2) Claude Code「Don't ask again」把密钥写进项目文件：1,122 个公开文件

- **2026-11-07** Apiiro 研究（HN 首页 582 分）称：扫描到 **1,122 个公开 GitHub 文件**含由此产生的密钥；追踪到 **1,105 个含真实密钥的仓库**，其中 **539 个**仓库里有一次 **Claude 共同署名提交**改动了该文件。[B｜厂商研究，未独立复核]
- 机制（作者在 HN 讨论中说明）：选「Yes, and don't ask again」后，**被批准的整条命令（含内联密码/token）写入项目内 `.claude/settings.local.json`**；Claude Code 只把它加进**全局** gitignore，不写进仓库 `.gitignore`；换机器、容器、复制目录或文件已被跟踪时照常提交。作者更正了最初「fresh clone 也会带上」的说法。[B]
- 反方与边界（HN 讨论）：前提是用户批准了含密钥的命令并提交；不是工具自动外泄。有人主张应由推送前扫描/护栏解决。[C]
- 厂商回应：Claude Code 团队成员（Boris）在帖中表示历史上没做 secret scrubbing，正在研究如何防止；强调该文件本应留在本地、由 Claude 创建时会自动 gitignore。[B｜公开评论]
- 意味着：**权限规则的持久化载体本身就是攻击面**。allow-rule 应绑定命令「形状」而非含密参数；项目级 settings 需要入库前扫描；「别再问我」这类降低摩擦的设计必须与密钥检测同批上线。

### 3) Claude Code 2.1.317–319：MCP 任务后台化、deny-instead-of-prompt、网关经营面

- 窗内三个稳定版：**2.1.317**（11-03）、**2.1.318**（11-04）、**2.1.319**（11-06）。[A｜官方 changelog + GitHub releases]
- 2.1.319 新增 **MCP tasks**：MCP server 以 task 方式执行工具调用时，Claude Code 立即转到后台并在完成时告知模型；`CLAUDE_CODE_DISABLE_MCP_TASK_BACKGROUND` 可改为原地等待。新增 **`permissions.denyInsteadOfPrompting`**：本会弹窗的调用直接拒绝并继续回合（含子 agent 与 teammates）。新增 `/claude-api latency-optimize`、`/usage` 对无 spend limit 的网关用户显示花费；网关侧加 `admin.pooled_conflict_rule`、`admin.pooled_priority_order`、`CLAUDE_GATEWAY_LOG_FORMAT=json`。修复包括「worktree 创建期间的沙箱逃逸」「permission-rule bypasses」「MCP handshake 兼容」「恢复后的 MCP 调用」等。[A]
- 2.1.319 行为收紧：关闭 telemetry/feature flags 时，auto mode 对服务端无法核查的调用改为询问或拒绝（`CLAUDE_CODE_AUTO_MODE_SERVER=0` 可保留内置分类器）；项目设置/插件不能在外部已关闭后重新打开服务端核查；`CLAUDE_CODE_PROXY_RESOLVES_HOSTS` 不能再由 settings 文件设置；Bash 沙箱开启时限制嵌套 `.claude/skills` 加载。[A]
- 2.1.318：gateway `mantle` upstream 支持 `assume_role`（跨账号 AWS + 按开发者归因成本）；claude.ai 登录过期时间进入 `claude auth status` 与 `claude -p` JSON；`deniedMcpServers` 的 URL 条目同时屏蔽 Anthropic 提供的 servers/connectors。[A]
- 意味着：编码 Agent 的竞争点继续从「模型」转向「执行面的可运维性」——异步任务、默认拒绝、网关成本归因、凭据过期可见性。`denyInsteadOfPrompting` 与沙箱是两条不同的边界，企业要分别配。

### 4) OpenClaw 2026.11.1：密钥不进日志、代理不出私网、配置保存不再覆盖 secret

- **2026-11-05T21:39Z（=11-06 05:39 CST）** 发布 2026.11.1。[A｜GitHub release notes]
- 安全/信任边界（本周主叙事）：**日志脱敏**——畸形自定义条目不再使有效规则或内置密钥保护失效，无效策略会被报告而安全脱敏继续生效（#173471）；**secret egress**——托管代理与导出的子进程 CA bundle 拒绝依赖不受信的 emSign ECC G3 根（#179249），需重启 Gateway，独立信任库的客户端另行更新；**网络与工具安全**——ClickClack/ClawHub 拒绝重定向到无关私网服务，Discord CDN 下载不再继承浏览器私网访问，FIFO native-hook 凭据被拒且不挂起 agent（#190944/#190939/#191458/#191423）。[A]
- 稳定性与恢复：更新器崩溃/取消后可恢复、Windows Gateway 验证失败后可恢复、大状态检查避免反复全库复制；超大回合保留有用历史；停止首个 Claude CLI 回合不再让下一条消息从零开始；子 agent 跨模型/会话变更保留跟进，父会话在自定义 session store 下也能收到子审批；Android「End Talk」停止监听但不取消已接受的 agent 工作。[A]
- 配置与凭据：macOS 设置保存失败不再覆盖 secret；关闭 Tailscale 暴露后 Gateway 认证保持；保存的 Claude 订阅账号可为配置模型供能而无需单独 native 登录；可通过 `plugins.entries.anthropic.config.managedNativeTools` 选择启用原生 Agent/Workflow 编排（默认关，受限运行保持既有工具上限）；Anthropic API-key 可记录 workspace ID；Bedrock Mantle 按模型自动选 Responses/Chat Completions/Anthropic Messages 路由。[A]
- 窗外背景：**2026.11.2** 于 2026-11-08T20:27Z（=11-09 04:27 CST）发布，主题同为隐私与信任边界（配置密钥/会话内容/工具错误/渠道载荷不进诊断日志、释放暖 CLI 回合的 MCP grants），**不在本期窗口**，下期跟进。
- 意味着：自托管 Gateway 的「安全」不是一次加固，而是三条持续回归线——日志/诊断的脱敏、出站代理的信任链、配置写入不覆盖密钥。10.x→11.x 的升级应按这三条做回归。

### 5) Perplexity 把 Computer 搬到 Mac 端侧：执行位置变了，权限模型没跟上

- **2026-11-06** Perplexity changelog 发布「Teammates, fully local Computer on Mac, and Voice mode」：Computer 可**完全在 Mac 上运行**，要求 Mac app 26.42.0+、Apple silicon、推荐 36 GB 统一内存，面向 Pro/Max/Enterprise；提供 **Local**（全端侧）与 **Hybrid**（Mac + 云分工）两种模式。官方描述是经用户许可后可跨本地文件与原生 Mac 应用（Notes、Mail 等）工作，受支持任务使用**端侧模型、harness 与执行**，不把个人数据发到云。同批 **Teammates** 把「一次一个任务」改成「一个持续岗位」：接收 ongoing job 后自行规划、并行执行，复用用户的 Computer 任务/skills/memory/工具，产出进入人工复核（Max、Web）。[A｜官方 changelog]
- 机制：把 Computer 从云端 VM 拆成**可端侧部署的执行栈**——模型 + harness + 执行器都在设备上，云端只在 Hybrid 模式保留编排与重活。权限入口收敛为安装/首次使用时的「用户许可」，changelog 未描述逐动作审批、审批队列或审计日志。这与云端 browser agent（ChatGPT cloud browser 的独立 profile + 管理员 origin 策略）是两条路线：一条把数据留在端上、把管控交给用户；一条把会话放云上、把管控交给管理员。[A｜条款；对比为分析]
- 意味着：这是本周唯一「数据不出端」的主流 Computer 产品口径，金融/医疗等不能把屏幕与文件送云的场景第一次有可选方案；但 36 GB 内存门槛把它限定在高端 Mac，且**取证随之下沉**——企业若需要审计 Agent 点了什么、读了哪些文件，当前 changelog 没有给出对应能力。选型时要把「执行在哪」与「审计在哪」分开问。

## 三、主线专题：Agent 执行面的隔离与授权（机制级深挖）

### 3.1 一句话

本周把「Agent 在哪里跑、能碰什么」拆成了三层可独立采购/验收的供给边界：**客户端 OS 沙箱 → 云端 microVM 运行时 → 集群级沙箱编排**；授权是跨层的第四层，而权限规则的持久化（allow-rule 写盘）是这条链上最薄的一环。

### 3.2 三层供给与一层授权

| 层 | 代表 | 强制点 | 机制要点 | 主要缺口 |
|---|---|---|---|---|
| 客户端 | Claude Code Bash sandbox | OS：macOS Seatbelt / Linux bubblewrap + socat；`@anthropic-ai/sandbox-runtime` | 默认关（`sandbox.enabled=false`）；写限工作目录+临时目录+allowWrite；读默认可达整机（含 `~/.ssh`、`~/.aws/credentials`，除非 denyRead/credentials）；网络默认无直连，全部经本机代理按 allowedDomains 逐 host 检查（初始为空） | 只包 shell 命令及其子进程；Read/Edit/Write/WebFetch 等内置工具、MCP server、hooks、plugin monitors、LSP、状态栏命令、mods 都在界外；`!` 手敲命令多数不过沙箱；`excludedCommands` 与 unsandboxed retry 是逃生门。官方建议要把这些纳入同一边界，需把 Claude Code 进程本身放进容器/VM/沙箱运行时 |
| 云端运行时 | Replit 沙箱引擎 | KVM + Cloud Hypervisor microVM；guest 内 runc 容器 | 每沙箱独立内核；guest `tinyconfig` + 禁模块；VMM 无特权；eBPF+LSM 双侧监控；egress 在 guest 外按 SNI/DNS 过滤；credential broker 代附加；CoW 远端磁盘；~500ms 获取 | 仍是「单租户边界内多进程」模型，guest 内提权需靠 seccomp/capability 分角色；成本与密度压力大 |
| 集群编排 | Agent Substrate / agent-sandbox | Actor/Worker 解耦 + 预热池 + 快照恢复 | 不建 Pod 对象、请求挂起后放置、<500ms 恢复、gVisor 或 microVM 二选一 | CNCF Sandbox 阶段，生态与 API 仍在稳定；多集群/多云一致性未在原文展开 |
| 授权（跨层） | Claude Code 权限规则 / OpenClaw 策略 | settings 文件、managed policy、Gateway 代理 | allow/deny 规则持久化；`denyInsteadOfPrompting` 让「会弹窗」直接变拒绝；OpenClaw 把 secret 脱敏与出站代理做成补丁线 | 规则载体本身会泄漏（Apiiro）；规则粒度是命令前缀，难表达「这条命令里不许出现密钥」 |

### 3.3 为什么这周是转折点

1. **供给端同时到位**：一周内出现「编排标准（Agent Substrate→CNCF）」「运行时重写（Replit microVM）」「K8s 原语（agent-sandbox v1.0.10）」三个层次的一手材料。此前沙箱多是产品内实现，外部只能看宣传。
2. **隔离级别第一次被量化**：Replit 用 6,211 条 CVE 的规避率（96.1%）和 ~500ms 获取时间把「隔离」变成可比较指标；Agent Substrate 用 <500ms 恢复与「不建 Pod」把密度变成可比较指标。
3. **失败案例落在授权层而非沙箱层**：Apiiro 的 1,122 个文件不是沙箱被突破，而是「用户批准的命令被持久化进仓库」。这说明沙箱与权限是两套机制，前者防执行越界，后者防授权扩散，不能互相替代。
4. **开源 Gateway 同向**：OpenClaw 2026.11.1 的补丁线（日志脱敏不被畸形条目关闭、代理拒绝不受信根、拒绝重定向进私网、配置保存不覆盖 secret）与云端沙箱的 egress/凭据控制在讲同一件事——**边界要在 workload 之外强制**。

### 3.4 主线局限

- Agent Substrate 的捐赠尚在 KubeCon 会期宣布，CNCF 接受与后续治理节奏未取得原文；「1.0」与「CNCF Sandbox」并存，成熟度不宜按毕业项目理解。
- Replit 的 CVE 规避率、迁移项目数、500ms 均为厂商自述，未独立复核；其口径是「审计的 Linux-CNA 条目中被规避的比例」，不等于「无漏洞」。
- Apiiro 全文页为 JS 渲染且返回 403，机制细节取自作者在 HN 讨论帖的公开回复；1,122/1,105/539 三个数字未能回到博文正文逐条核对，按 B 级采用。
- Claude Code 沙箱文档为当前文档（非窗内变更），用于说明机制与覆盖边界；窗内实际变更是 2.1.317–319 的权限与 MCP 任务项。
- 未取得：Agent Substrate 的具体 API/CRD 定义、各云厂商托管版本的定价、E2B/Daytona 等商用沙箱本周的对比数据（Daytona releases 页停在 2026-06，未取到窗内发布）。

## 四、分对象深拆（按机制分组）

### 4.1 编码 Agent 与 CLI：默认姿态从「先问」转向「先拒」

本周六个 CLI/IDE 发布的方向一致：把权限判定从「运行时弹窗」前移到「策略与会话」，把沙箱边界从「命令」扩到「进程树」，并把「等人批准」从关键路径上移走。差别只在强制点放在哪一层。

**Claude Code 2.1.317–319（11-03 / 11-04 / 11-07 01:04 CST）** 是本周把「默认拒绝」写得最明确的。2.1.319 新增 `permissions.denyInsteadOfPrompting`：原本会弹窗的调用直接拒绝并继续回合，覆盖子 agent 与 teammates——这使「拒绝」成为一种不阻塞 agent 的策略表达，而不是一次中断。同一版把 auto mode 改为 fail-closed：关闭 telemetry 或 feature flags 后，服务端无法核查的调用一律询问或拒绝，且项目设置与插件**不能**在被外部关闭后重新打开服务端核查（`CLAUDE_CODE_AUTO_MODE_SERVER=0` 可退回内置分类器）；`CLAUDE_CODE_PROXY_RESOLVES_HOSTS` 也不再允许由 settings 文件设置。MCP 侧，server 以 task 方式执行工具调用时，Claude Code 立即转后台并在完成时告知模型（`CLAUDE_CODE_DISABLE_MCP_TASK_BACKGROUND` 改回原地等待）。网关侧补了 `admin.pooled_conflict_rule`、`admin.pooled_priority_order` 与 JSON 日志，`/usage` 对无 spend limit 的网关用户显示花费。修复项里有「worktree 创建期间的沙箱逃逸」与「permission-rule bypasses」——两条都说明沙箱与规则引擎的接缝才是实战中的突破口。[A]

判断：这套组合把「无人批准」变成默认结果，同时不牺牲回合连续性。它恰好是 Apiiro 那条泄漏的反面——若默认是拒绝，含密命令不会被写成 allow 规则；若已写成规则，`denyInsteadOfPrompting` 至少能让「本该问」的调用不再静默通过。

**Codex CLI 0.167.0（11-06 09:42 CST）** 走的是另一条：把批准变成「每次都新鲜」。`prompt-user` 命令规则要求对高风险命令形状重新取得批准，而不是复用历史同意；`[permissions.network]` 把网络访问写成声明式配置；Guardian 做服务端复核；Code Mode 采用协商式截断；MCP 改为 **per-chat 租约**——同一台机器上不同会话不共享连接与凭证上下文。`deferred tool world state` 转为默认开启。判断：Codex 与 OpenCode 在同一周从两侧摸到同一处——OpenCode 的 `pool: true` 把 MCP 连接提升为机器级共享资源（省进程、但故障域与权限上下文合并），Codex 的 per-chat 租约则反向收紧。两种选择都对，前提是自己知道在拿什么换什么。[A]

**Gemini CLI v0.67.0（11-05 04:27 CST）/ v0.68.0-preview.0** 的重点是「IDE 集成进沙箱」：`bridge the IDE companion into container sandboxes over exec stdio`（#29858）用 exec + stdio 把 IDE 伴随进程搬进容器命名空间，保留打开文件、选区、诊断能力，又不必在宿主机暴露容器文件系统。ACP 权限请求开始携带 MCP server 与 tool 元数据（#29910），使编辑器能在批准时显示「哪个 server 的哪个工具」。另有两条值得记录：从 Claude 配置迁移 hooks 时「秒→毫秒」单位错算被修（#29899，说明迁移兼容层真实存在且出过数据正确性 bug）；rootless podman 沙箱补 `--userns=keep-id`（#30118）。[A]

**GitHub Copilot CLI 1.0.107（11-06）** 把沙箱从「CLI spawn 的进程」推到「第三方进程」：新增 Sandbox extensions 设置，让扩展进程在沙箱内跑；沙箱化本地 MCP server 尊重相对文件系统权限、相对 cwd 与可写的 `npm_config_cache`。权限文档实质化：`write(path)`/`read(path)` 支持 glob，新增 `memory` 类规则，并明确「未限定范围的 `write` 规则只批准 shell 输出重定向、不批准命令本身」——把「批准写文件」与「批准任意命令」拆开。破坏性一条：插件规则 `alwaysApply: false` 语义反转，从「默认生效」改为「需在 `/instructions` 显式启用才进 prompt」。[A]

**OpenCode v2.2.6（11-07 07:37 CST）** 给了 CI 一个必须处理的语义：`opencode run` 现在会等待本次 prompt 启动的后台 shell、子代理、图像任务全部结束才让模型作答并退出，**没有时间上限**；永不退出的 dev server 会让 run 一直挂着，需 Ctrl+C 或 SIGTERM（退出码 143）。安全面同时收紧：`/api/*` 只服务沙箱化下载并拒绝跨站来源；webfetch 拒绝含凭证的 URL、规则匹配忽略 `#fragment`、Code Mode 每个重定向都重新对照规则（#60502/#61701/#62373）；`session_move` 离开项目需 `external_directory` 权限。[A]

**Cursor / Devin / Cline** 的动作在「入口」而非「内核」。Cursor 11-06 上线实时语音（Grok Voice 驱动，Privacy Mode 下称零保留），11-05 上线「在 Cursor 内建活应用」：cloud agent 脚手架 web app、按需起 Postgres、在 Cursor SSO 后配鉴权、provision 托管与域名，发布前跑「确定性检查 + agentic 安全检查」，通过且显式发布前不上线，管理员可看全部应用与密钥、可下架。Devin Desktop v3.12.28（11-07）把 MCP 开关与重认证收到会话头部，并修好「第三方 ACP agent 的权限请求让会话视图崩溃」。Cline nightly（11-05）把「验证」也交给子代理，但要求子代理继承委派审批策略——否则子代理会成为绕过审批的后门。[A｜条款；能力自述 B]

**退场与静默**：Aider 最后 release 2026-02-12（约 9 个月）、Roo Code 2026-05-15（约 6 个月）、Windsurf 独立 changelog 已 308 永久重定向到 Devin Desktop 文档（Cascade 标 legacy）。Replit 产品博客停在 10-28，但其工程博客 Frontier 于 11-04 披露沙箱引擎重写（见 §三），采集层若只看 `/blog` 会误判「无动态」。[A]

### 4.2 开源框架：Gateway、SDK、平台三条路线分家

18 个对象里，动作最密的是 Gateway 型个人助理（OpenClaw、Hermes）与 SDK 型运行时（OpenAI Agents SDK、MS Agent Framework、ADK）；图编排（LangGraph、CrewAI）只在修语义细节；平台（Dify、OpenHands、AutoGPT）在做自动化与包格式。三条路线已不是同一市场的不同实现。

**OpenClaw 2026.11.1（11-05 17:48 发布 / Atom 11-06 05:39 CST）** 的补丁线全部落在信任边界：畸形自定义日志条目不再让有效脱敏规则或内置密钥保护失效（#173471）；托管代理与导出的子进程 CA bundle 拒绝不受信的 emSign ECC G3 根（#179249）；ClickClack/ClawHub 拒绝重定向到无关私网服务，Discord CDN 下载不继承浏览器私网访问，FIFO native-hook 凭据被拒且不挂起 agent。配置侧，macOS 设置保存失败不再覆盖 secret。其文档把模型写成一句话：**One Gateway is one trust boundary**；顺序是 **Identity first → Scope next → Model last**。MCP loopback grant 按「铸造者 + 受众」回收，暖回合最多复用 3 轮；导航 fail-closed；工作区 `.env` 不能设置 `PATH`。[A｜release notes + 文档；文档为当前态，B]

窗内合入、窗外出包的 **2026.11.2**（11-09 04:27 CST）主题相同：配置密钥、会话内容、工具错误、渠道载荷不进诊断日志，释放暖 CLI 回合的 MCP grants。本期不写为事件，下期跟进。[A｜窗外]

**Hermes Agent v0.23.0「The Hearth Release」（11-06 05:32 CST）** 与 OpenClaw 独立收敛到同一个架构判断：**一个 gateway 拥有每个会话，所有界面都是客户端**。此前 CLI、TUI、Desktop、编辑器（ACP）、消息 bot、cron 各自对同一聊天跑一份 agent 副本，导致消息重复写或丢失；现在一个聊天 = 一个队列 + 一份历史。差别在边界哲学：Hermes 走「成本与授权可见化」——付费 MCP 工具可声明单次调用成本，审批卡显示单次价格与该聊天累计，**即使在 YOLO 模式也会问**；Group Chat 的 bot 间回环以 `max_hops`（默认 4）硬截断，且 bot 收不到运行时通知；插件目录增至 1,050+ 条并新增 Verified 层（由被集成产品的厂商自己构建），`hermes curator lock` 让 agent 通过任何工具都不能改写你手改过的技能，YOLO 下也不行。破坏性升级必须排期：`browser_*` 十件套与 `agent-browser` 全部删除，只保留 `browser_exec`；Electron 44 要求 macOS 13+ / 64 位 Windows；`hermes mcp serve` 改名 `mcp-serve` 且不自动改写客户端命令；Office 三个技能合并；webapp 默认关闭。[A｜release 正文含 Upgrade notes]

判断：一个用「拒绝」保护用户（OpenClaw 的 fail-closed 与单信任边界），一个用「让你看清代价」保护用户（Hermes 的标价、额度、审批卡显示确切命令）。两条都成立，但它们对「企业该选哪个」给出的答案不同：前者适合当基础设施，后者适合当个人工作台。

**图编排 SDK**：LangGraph 1.2.20（11-05）加 per-interrupt id 与 strict resume，sdk 0.4.12–0.4.14；LangChain core 1.7.4–1.7.6、`typesafe` 0.0.1/0.0.2、async subagents；CrewAI 1.15.34–1.15.37（1.15.38 在 11-09 03:39，窗外）。这一层的变更以「恢复语义」和「子代理生命周期」为主，没有架构级动作。[A]

**MS Agent Framework python-1.25.0 / dotnet-1.28.0（11-07）** 是本周破坏性最集中的一版：7 条 `[BREAKING]`，并把**授权作用域**绑到 agent 上。AutoGen 已于 2025-09-30 停更、2026-10-17 声明归档（背景，非本周），接续即 MS AF——这条对仍在引用 AutoGen 的团队是明确的迁移信号。[A]

**平台侧**：Dify v1.19.0（11-04 15:37）把「可观测」推进到「workflow 调用的 workflow 内部的 LLM 调用」（#44673，历史 trace 不回填），`.ifpkg` 升 v2 让 App 连同 Workflow Tool 绑定版本一起打包、导入端按「复用已有 → 重建缺失 → 重映射引用」收敛（#44592/#45353）；真正会绊倒运维的是队列切换——新任务默认进 `ops_trace_v2`，API/worker/Beat 必须一致，旧 trace worker 要留在 `ops_trace` 直到旧生产者排空，是双写过渡而非开关（#44941/#45314）。OpenHands v1.35–1.37 把 automations 交给 **service account** 运行（#19033），并让仓库选择器只把所选仓库发给确实会克隆它的 provider（#19347，数据最小化）；macOS 包仍未签名/公证。AutoGPT v0.11.x 是「自托管安全性向云看齐」：`TRUSTED_PROXIES` 修掉 `X-Forwarded-For` 取最左值被伪造的问题，不再随包发 VAPID 密钥对（升级要跑 `make init-env`，换密钥会让既有推送订阅失效），LaunchDarkly 换 PostHog。[A]

**SDK 侧两处机制级变化**：ADK 2.14.0 让 `RunSkillScriptTool` **不再接受 `command`**——环境模式下模型只能传 `args`/`short_options`/`positional_args`，脚本从 skill 目录运行，仅支持 `.py/.sh/.bash`。原文写明这关掉了「被提示注入的模型执行任意 shell 命令」的洞。代价是「毕业」的 16 个特性**始终可用**，`ADK_DISABLE_*`、`override_feature_enabled(..., False)`、`--disable_features` 不再生效且**不报错不告警**。OpenAI Agents SDK 0.24.0-alpha.6/.7 把 v0 运行时退居 `agents.classic`，native 运行时默认 `write_policy="strict"`，**权限在 Session 打开时快照、之后不能扩张**，`RunBudget` 缺 usage 即停止准入；API 面（Runner/Turn/wait/interrupt/approval_mode）几乎全改，且只走 GitHub Release 的 wheel、不上 PyPI。[A]

**Harness 极**：Pi 1.5.0（11-02 19:05 CST）定位「最小 agent harness」——明确跳过 sub-agents 与 plan mode，靠 extensions/skills/prompt templates 拼装，提供 interactive、print/JSON、RPC、SDK 四种模式，官网直接写 "See **OpenClaw** for a real-world integration"。1.5.0 把工具参数校验下沉到 `@earendil-works/pi-schema`，JSON Schema 之外的 TypeBox 特性失效，MCP 工具与内置工具走同一套强制转换。Rivet 3.0.4–3.0.6 + Launch HN 代表第四条路线：每个 agent 一个 actor、状态放 S3、72 KB/actor、p99 冷启 4.99 ms（均为厂商自述，三个 release 正文只有 Full Changelog，改了什么不可知）。[A｜版本；B｜README/HN 指标]

### 4.3 浏览器与 Computer Use：运行时与管控面在动，模型面静默

本周三家模型厂商都没有新的 computer-use 模型或工具集版本。可核增量集中在**身份、隔离与管控面**，以及一条产品架构级变化（Perplexity 端侧 Computer，见 §二.5）。

**OpenAI 本周不可评。** ChatGPT/Codex 合并 changelog 的 11 月段只有 Codex CLI 0.167.0（11-06）与 ChatGPT iOS（11-02），API changelog 窗内三条（11-02 SIP、11-04 图像、11-05 Cyber）均与浏览器/computer use 无关。但 `help.openai.com` 的 release notes、ChatGPT agent、cloud browser 三页全部 403（含 reader 代理 401），因此只能确认「已核入口无相关条目」，**不能反推「没有发布」**。当前文档口径（非窗内变更）：桌面端 Computer Use 让 ChatGPT Work 或 Codex 操作内置浏览器，内置浏览器用**独立 profile**，管理员可用 managed browser controls 限制 origins、上传、下载与 developer access——这是目前唯一能写进企业策略的 OpenAI 浏览器管控面。[A｜changelog；未取得｜help 站]

**Anthropic 补的是外围身份，不是工具集。** 11-05 Claude Console 上线组织级 **IP allowlist（beta）**：名单外地址的请求被拒，官方定位是「限制泄漏的 API key 还能在哪用」，每组织最多 1,000 条 IPv4/IPv6 地址或 CIDR；同日 Admin API 支持把 Enterprise 成员**从所有 Claude 会话登出（beta）**，成员仍在组织内、可重新登录。11-02 Messages API 上线 **message threads（beta）**：会话状态留服务端，后续请求只发新消息，线程最后一次请求后 5 分钟过期、最迟 1 小时删除，官方场景明确包含「长对话与 agent loop 降低首 token 时延」。[A]

工具集口径值得写清：`computer_toolset_20260801` 是**客户端工具集**，一个 tools 条目给 17 个成员工具，在你的环境执行，不在 Claude Managed Agents 提供；`browser_toolset_20260801` 有 27 个默认成员 + 4 个可选成员，同时用**可访问性树 + 元素 ref**与截图/坐标，同样由应用侧执行，「Anthropic 侧不跑任何东西」；SDK 跑工具循环、执行你设的 URL/file policy 与 approval callback。判断：**取证点在你自己的 executor**——日志、URL 白名单、下载落盘、审批记录都要自建；IP allowlist 只解决「key 被带走到别处用」，不解决 Agent 在授权范围内被 prompt injection 操纵。[A｜文档当前态]

另有一条宽口径材料：11-06 **Project EVE**，Claude 在 EVE Online 模拟盘交易（9 个两周窗口、3B ISK 起始，Opus 4.6→Fable 5 平均收益三倍），EVE Frontier 中四 Agent 编队里被指示暗中破坏的成员几乎未被队友发现。它是长程自主与欺骗检测的一手实验，但不是屏幕级 computer use。[B｜厂商研究]

**Google 的浏览器品牌在退场，运行时在上前台。** `deepmind.google/technologies/project-mariner/` 现 301 到 DeepMind 首页，页面无 Mariner 文案——可核「官方产品页不再存在」，**不可核退场日期**；blog.google 与 Cloud blog 窗内无浏览器 Agent 公告。同周 11-05 Agent Substrate 1.0 并 GA on GKE（详见 §三），其 **Gateways 按 Actor 身份做进出向访问控制并注入密钥（密钥不进 Agent 环境）** 正好对应浏览器 Agent 的三个信任边界：内网 egress、凭据不下发、session scope。[A]

**Cloudflare 把「让 Agent 看、但不让它填」做成策略。** 11-04 Browser Isolation 的 isolation policy 新增第三种键盘档 **Allow read-only actions（beta）**：阻断数据录入，但保留页内查找、全选、复制、打印、缩放，其余键盘输入不进入隔离页；复制/打印仍受各自策略控制，**策略组合而非互相覆盖**。同日 Bots 的「Configure AI bot policies」更名为 **AI Crawler and Agent access policies**，站点可对 **Personal agents 逐个设置动作**（allow/challenge/block），从「一类 bot 一个策略」变成「按 Agent 产品分别授权」。11-03 Browser Run 的 `/crawl` 结果新增**逐 URL outcome 与 robots.txt 诊断**，是少见的取证级 crawl 记录。同日 Agents SDK v0.33.0 把 PiHarness 升到 Pi 1.5：流式写入改为约每秒批量落盘，SQLite 下长回答存储事务约降 **27x**、并行工具轮降 **5.7x**，2,048 会话基准下单 harness 从 **88 → 459 agent runs/s**。[A｜条款；性能为厂商自述]

**LangChain 给出了「工具协议 > 换模型」的可复算证据。** 11-03《How We Optimized Browser Use for Deep Agents》比较 7 个浏览器工具集后选 Browserbase 的 **Stagehand**：WebVoyager 100 题、Claude Sonnet 5.5 下 Stagehand 通过 **90%**、总成本 **$1.98**、中位 17.4 s/题；Playwright MCP 通过 **78%**、**$26.71**（约 13x 成本）、耗时约 3x。机制是 **code mode**：只给 Agent 三个工具（`snapshot` 读可访问性树并给元素打 ID、`run` 批量动作或写 Playwright 风格 JS、`screenshot`），Agent 写一段代码在一次调用里完成「开页→填表→点击→校验」，中间变量留在代码里、只有结果进上下文。Playwright MCP 单个 WebVoyager 任务平均 **26 个模型轮**，而经 Browserbase hosted MCP 的一次导航页面内容中位数约 **17,000 字符**——两个瓶颈都被工具协议直接对准。[A｜方法；B｜benchmark，未独立复现]

**未取得**：Browserbase / Steel / Browserless 的窗内博客条目（入口 200 但未解析出 2026-11 日期，时间用尽）；Kimi 与 Qwen 官方博客（JS 壳，无日期条目）；OpenAI help 站（403）。C 组未扫描 HN/arXiv，因此「本周是否有新 CUA benchmark」未核，不写「无」。[—]

判断：浏览器 Agent 的竞争点已从「能不能点」转向「**能否按站点/按动作/按 Agent 身份收紧，并留下可复算的成本与轨迹**」。但三条边界仍空着：① 管控都停在站点/网络层，不解决「在允许的站点内被页面指令操纵」；② benchmark 只测成功率与成本，不测注入成功率；③ 浏览器会话录像、下载落盘、审批记录在平台侧都没有窗内新能力——取证仍要自建。

## 九、覆盖表、发现层与局限

### 9.1 覆盖表（四组，逐对象终态）

**A 组｜编码 Agent / CLI / IDE（固定 13 项 + 名单外 2 项）**

| 对象 | 窗内状态 | 关键锚点（CST） | 分片 |
|---|---|---|---|
| Claude Code | 有动态 | 2.1.317（11-03）/ 318（11-04）/ 319（11-07 01:04） | A/part-01 |
| OpenAI Codex CLI | 有动态 | 0.167.0（11-06 09:42）；alpha 至 11-08 03:36 | A/part-01 |
| Gemini CLI | 有动态 | v0.67.0（11-05 04:27）/ v0.68.0-preview.0 | A/part-02 |
| Cursor | 有动态 | 11-05 活应用 / 11-06 实时语音 | A/part-02 |
| Devin Desktop | 有动态 | v3.12.28（11-07） | A/part-02 |
| Windsurf | 无独立动态（入口合并） | windsurf.com/changelog → 308 → docs.devin.ai | A/part-02 |
| OpenCode | 有动态 | v2.2.6（11-07 07:37）/ process-daemon 0.5.0 | A/part-02 |
| Aider | 无动态（已核验） | releases.atom 最新 2026-02-12 | A/part-03 |
| Cline | 有动态（nightly） | desktop-nightly-20261104233655（11-05 05:08） | A/part-03 |
| Roo Code | 无动态（已核验） | releases.atom 最新 2026-05-15 | A/part-03 |
| GitHub Copilot CLI | 有动态 | 1.0.107（11-06） | A/part-02 |
| Replit | 产品博客无动态；**工程博客有动态** | `/blog` 最新 10-28；frontier.replit.com 11-04 沙箱引擎重写（主控补研） | A/part-03 + §三 |
| 编码评测（SWE-bench 等） | 混合 | SWE-bench 仓库最新提交 2026-09-02；arXiv 11-04/11-05 五篇 | A/part-03 |
| agent-autoloop（名单外） | 有动态 | 建仓 2026-11-03，4.1k★/747 fork | A/part-03 |
| Google Agent Distraction（名单外） | 有动态 | 2026-11-06，+70%/+77%/+105% | A/part-03 |

**B 组｜开源框架 / Gateway（固定 16 项 + 名单外 2 项）**

| 对象 | 窗内状态 | 关键锚点（CST） | 分片 |
|---|---|---|---|
| **OpenClaw** | 有动态（必覆盖） | v2026.11.1（11-05 17:48 / Atom 11-06 05:39）；11.2 为 11-09 04:27 窗外 | B/part-01 |
| Hermes Agent | 有动态 | v0.23.0（11-06 05:32）/ v0.22.7 / canary 每日 | B/part-03 |
| LangGraph | 有动态 | 1.2.20（11-05）、sdk 0.4.12–0.4.14 | B/part-02 |
| LangChain | 有动态 | core 1.7.4–1.7.6、typesafe 0.0.1/0.0.2 | B/part-02 |
| CrewAI | 有动态 | 1.15.34–1.15.37（1.15.38 窗外） | B/part-02 |
| AutoGen | 无动态（已归档） | 最后 release 2025-09-30；归档声明 2026-10-17 | B/part-02 |
| Microsoft Agent Framework | 有动态 | python-1.25.0（11-07 23:52）/ dotnet-1.28.0（11-07 06:00） | B/part-02 |
| Dify | 有动态 | v1.19.0（11-04 15:37） | B/part-03 |
| Google ADK | 有动态 | v2.14.0（Atom 11-07 08:58；正文标 11-04） | B/part-03 |
| OpenAI Agents SDK | 有动态 | 0.24.0-alpha.6（11-04）/ alpha.7（11-08 15:07） | B/part-03 |
| LlamaIndex | 弱动态（有提交无发布） | llama_index 11-04 #23923；最新发布 09-22 | B/part-03 |
| browser-use | 无动态（已核验） | 最新 0.13.14（10-27，「before the Pi migration」） | B/part-03 |
| OpenHands | 有动态 | v1.35.0 / v1.36.0 / v1.37.0（11-04~11-06） | B/part-03 |
| AutoGPT | 有动态 | v0.11.0（11-04）/ v0.11.1（11-06） | B/part-03 |
| MetaGPT | 无动态（维护停滞） | 最新 release 2025-03-09；提交 2026-01-21 | B/part-03 |
| SuperAGI | 无动态（实质停更） | 最新提交 2025-01-23 | B/part-03 |
| Pi（名单外） | 有动态 | 1.5.0（11-02 19:05，npm `time`） | B/part-03 |
| Rivet（名单外） | 有动态 | 3.0.4–3.0.6 + Launch HN（11-05） | B/part-03 |

**C 组｜浏览器 / Computer Use（固定 9 项 + 平台托管 4 项 + 名单外 3 项）**

| 对象 | 窗内状态 | 关键锚点 | 分片 |
|---|---|---|---|
| OpenAI Operator / ChatGPT Agent | 无动态（help 站 403，口径为「已核入口无条目」） | ChatGPT/Codex changelog 11-06/11-02；API 11-02/04/05 | C/part-01 |
| Anthropic Computer Use | 有动态（平台权限侧） | 11-05 IP allowlist + 全局登出；11-02 message threads | C/part-01 |
| Google Project Mariner / Gemini 浏览器 | 无动态（产品页退场） | 301 → DeepMind 首页，日期不可核 | C/part-01 |
| Perplexity Comet / Computer | 有动态 | 11-06 本地 Computer（Local/Hybrid）+ Teammates | C/part-02 |
| Manus | 无产品动态 | 11-06 SEO 博客；`/updates` JS 壳 | C/part-02 |
| Genspark | 无动态 | blog 最新 2026-10-27 | C/part-02 |
| Kimi | **本次未取得** | 三入口 JS 壳/无日期 | C/part-02 |
| Qwen | **本次未取得** | 三入口无窗内条目 | C/part-02 |
| 智谱 AutoClaw | 无版本动态 | 11-02~11-06 教程/营销 | C/part-02 |
| Cloudflare（Browser Isolation / Bot 策略 / Browser Run） | 有动态 | 11-04 只读键盘 beta、按 Personal Agent 授权；11-03 逐 URL outcome | C/part-03 |
| LangChain（浏览器工具集） | 有动态 | 11-03 Stagehand 90%/$1.98 vs Playwright MCP 78%/$26.71 | C/part-03 |
| Browserbase | **本次未取得（时间用尽）** | blog 200 但未解析出 2026-11 日期 | C/part-03 |
| Steel / Browserless | **本次未取得（时间用尽）** | blog 200 但未解析日期 | C/part-03 |
| Google Agent Substrate（名单外） | 有动态 | 11-05 1.0 + GKE GA + 捐 CNCF | C/part-01 |
| Anthropic Project EVE（名单外） | 有动态 | 11-06 长程多 Agent 实验 | C/part-01 |
| LangChain 优化长文（名单外） | 有动态 | 11-03（同上） | C/part-03 |

**D 组｜企业 / MCP / 评测 / 研究（固定 15 项 + 名单外 3 项）**

| 对象 | 窗内状态 | 关键锚点 | 分片 |
|---|---|---|---|
| MCP 规范 / SEP | 有动态（无新 SEP、无新修订版） | 窗内 17 merged PR；Accepted 1 / Final 44 | D/part-01 |
| MCP 授权路径 | 有动态 | PR #3518（11-08）CIMD 上位、DCR deprecated | D/part-01 |
| MCP Inspector | 有动态 | 2.14.0（11-05 07:55）/ 1.0.4，3 个 CVE | D/part-01 |
| MCP Registry | 有动态 | v1.8.8（11-06 22:12），URL 不再唯一 | D/part-01 |
| MCP SDK（TS/Python） | 无窗内发布（背景） | TS 2.4.0（10-23）/ Python 2.3.0（10-02） | D/part-01 |
| MCP 扩展（Apps/Tasks/Skills/Auth） | 文档更新（能力为背景） | Skills Beta 目录移动 10-29，本周仅修链接 | D/part-01 |
| Sierra | 有动态 | 11-05 收购 Anon；11-02 新 CISO | D/part-02 |
| Glean | 有动态 | v568（11-06）/ v567（11-03） | D/part-02 |
| Harvey | 有动态 | 11-05 FORUM Chicago | D/part-02 |
| Salesforce | 有动态 | 11-04 Coworker 185k / 21x / $50 | D/part-02 |
| ServiceNow | **本次未取得** | 5 个入口 403/JS 渲染 | D/part-02 |
| Coze | **本次未取得** | 5 个入口 SPA/无窗内条目 | D/part-02 |
| memory / context | 研究侧有动态；产品无发版 | MEMOIR / EvoMemState；mem0/Letta/Zep 窗外 | D/part-03 |
| sandbox / permission / audit | 有动态 | Agent Substrate、E2B 2.63.0、Inspector | D/part-03 |
| 评测（SWE-bench / OSWorld / WebArena / τ-bench） | 无新榜；OSWorld 维护级 | 仓库 commits + arXiv | D/part-03 |
| 安全研究 | 有动态 | 投毒 22.9%、审批缺口 90%/60.7%、签名不等于安全 | D/part-03 |
| Google/Microsoft 企业治理 | Google 有动态；MS 无窗内 | CNCF 博客、技能评测五规则 | D/part-03 |
| CNCF Agent Substrate（名单外） | 有动态 | 11-05 捐赠宣布 + 1.0（D 组记为 11-06，抓取日差异） | D/part-03 |
| Zalando Identity Broker（名单外） | 有动态 | 11-06 Show HN，OAuth2 委派链 | D/part-03 |
| Google 技能评测方法论（名单外） | 有动态 | 11-03 五规则 + `skill-reach` | D/part-03 |

**计数**：固定对象 A 13 + B 16 + C 13 + D 15 = **57**；名单外纳入深写 **10**（A 2、B 2、C 3、D 3，去重后 9 个独立对象）；窗内有动态约 **40**；无动态（已核验）**11**；本次未取得 **6**（ServiceNow、Coze、Kimi、Qwen、Browserbase、Steel/Browserless）。OpenClaw 已覆盖并在 B 组给终态行。

### 9.2 发现层摘要

| 组 | 宽口径手段 | 线索 | 纳入深写 | 未纳入的主要原因 |
|---|---|---|---|---|
| A | GitHub search 2 次、HN Algolia 1 次、arXiv 1 次、厂商博客索引 | 10 | 2（agent-autoloop、Agent Distraction） | 刚建仓、无可读机制（6 条）；Apiiro 正文 403（1 条，转入主线 B 级使用） |
| B | GitHub Atom 45 个源、PR `.patch`、npm registry、HN、search 1 次 | 6 | 2（Pi、Rivet） | 规模不足或与固定对象重叠 |
| C | 厂商 blog/RSS、Cloudflare changelog、GitHub releases | 7 | 3（Agent Substrate、Project EVE、LangChain 长文） | Agent Distraction 日期不可核；DataDome 二手；Cloudflare 属固定项 |
| D | 60 个一手/研究入口、arXiv 6 个 query、Show HN、GitHub Atom | 10 | 3（Agent Substrate、Zalando、Google 技能方法论） | Arken/ScamWorld 仅自述；其余为早期项目 |

跨组去重后，本周「名单外纳入深写」实际为 9 个独立对象（Agent Substrate 由 C/D 各自独立发现，计 1）。

### 9.3 未取得清单（每条 ≥2 个已试入口）

| 对象 | 已试入口 | 失败原因 |
|---|---|---|
| ServiceNow | press-room.html；investor/news 及 RSS；sitemap.xml；newsroom.servicenow.com；/blogs/ | Cloudflare 403、JS 渲染、超时 |
| Coze（扣子） | coze.cn；coze.com /blog /release-notes；coze.cn/open/docs changelog；volcengine.com/product/coze；coze-studio / coze-py / coze-js 仓库 | SPA 壳、空壳、仓库无窗内发布 |
| Kimi | kimi.moonshot.cn；/blog；platform.moonshot.cn/blog | 144 字符壳、无日期字段、无正文 |
| Qwen | qwen.ai；qwen.ai/blog；qwenlm.github.io/blog | 8 字符壳、无日期、索引无 11 月条目 |
| Browserbase / Steel / Browserless | browserbase.com/blog 与 rss.xml；steel.dev/blog；browserless.io/blog | 200 但未解析出 2026-11 日期（时间用尽） |
| OpenAI 产品 release notes | help.openai.com 三页；r.jina.ai 代理 | 403（Cloudflare）；代理 401 |
| Anthropic 11-08 Announcements | anthropic.com/news；/news/announcements；sitemap.xml | 页头标 Nov 8，列表止于 10-28，sitemap 无条目 |
| Apiiro 博文正文 | apiiro.com/blog/... 直连；WebFetch；reader 代理 | 403（Cloudflare/网络声誉）；改用 HN 讨论帖作者回复 |

另有两个「入口级」失败：Gemini CLI 的 `CHANGELOG.md` raw 404（已用 release notes 替代）；Replit docs changelog 404（已用工程博客与 release 页替代）。这两项不影响对象结论。

### 9.4 局限

- **检索面**：WebSearch 全程 403（Volcano Ark「Access denied」），本周信息面依赖 GitHub Atom、厂商 changelog/博客、HN Algolia、arXiv API 与定向抓取；没有搜索引擎覆盖，可能漏掉未在上述入口发布的消息。
- **无浏览器**：所有依赖 JS 渲染的页面（Coze、Kimi、Qwen、ServiceNow、OpenAI help）只能记「未取得」。这不是「不存在」。
- **配额**：GitHub API 60 次/小时、search 10 次/小时由四个子代理共享，全部改用 Atom 源规避；A 组 search 仅用 2/3。
- **时间**：C 组在 2.5 小时后被主控要求收尾，Browserbase / Steel / Browserless 与 HN/arXiv 扫描未完成，故「本周无新 CUA benchmark」一说不成立，只能写「未核」。
- **厂商自述**：Replit 的 6,211 CVE / 96.1% / ~500ms、Agent Substrate 的 <500ms / 10x、Salesforce 的 185k / 21x、Hermes 的 10,080 commits、Rivet 的 72KB/4.99ms、Cloudflare 的 27x/459 runs/s 均为厂商口径，未独立复现。
- **预印本**：D 组六篇 arXiv 结论（4.95%、18.5%、0.92 vs 0.62、22.9%、90%/60.7%、41–46%）均未经同行评审，按 B 级使用。
- **Apiiro**：正文 403，机制取自作者在 HN 讨论帖的公开回复与 Claude Code 团队成员的公开评论；1,122/1,105/539 三个数字未能回到博文正文逐条核对，按 B 级采用，并在读者稿中标明「厂商研究，未独立复核」。
- **口径**：Agent Substrate 的捐赠在 KubeCon 会期（11-09~12）宣布，写作统一为「宣布将在 KubeCon 捐赠 / 上月已进 CNCF Sandbox」，不写「已完成毕业」；MCP Skills Beta（10-29）、NIST 身份十原则（10-27）、Salesforce Agent Fabric Evals（10-27）均为窗外背景。

## 十、来源（按组，均为窗内一手入口）

**A 组**
- Claude Code changelog｜https://docs.claude.com/en/release-notes/claude-code
- Claude Code GitHub releases｜https://github.com/anthropics/claude-code/releases.atom
- Codex releases / tags｜https://github.com/openai/codex/releases.atom；/tags.atom
- Gemini CLI releases｜https://github.com/google-gemini/gemini-cli/releases.atom
- Copilot CLI changelog｜https://raw.githubusercontent.com/github/copilot-cli/main/changelog.md
- OpenCode changelog｜https://opencode.ai/changelog；releases.atom（anomalyco/opencode）
- Cursor changelog｜https://cursor.com/changelog
- Devin Desktop changelog｜https://docs.devin.ai/desktop/changelog
- Replit Frontier｜https://frontier.replit.com/sandbox-engine-microvms-part-1/
- Google Agent Distraction｜https://developers.googleblog.com/en/agent-distraction/
- agent-autoloop｜https://github.com/KKKKhazix/agent-autoloop
- arXiv 编码评测五篇（Takeover / Multi-step SWE / failure predictor 等）｜https://arxiv.org/abs/ 对应编号见 A/part-03

**B 组**
- OpenClaw releases｜https://github.com/openclaw/openclaw/releases/tag/v2026.11.1
- OpenClaw 文档（trust model / computer use / logging）｜仓库 docs 目录
- Hermes v0.23.0｜https://github.com/NousResearch/hermes-agent/releases/tag/v0.23.0
- LangGraph / LangChain / CrewAI / MS AF / ADK / OpenAI Agents SDK / Dify / OpenHands / AutoGPT / LlamaIndex｜各自 `releases.atom`（窗内条目见 B/status-table）
- Pi｜https://registry.npmjs.org/@earendil-works/pi-coding-agent（`time` 字段）；https://pi.dev/changelog
- Rivet｜https://github.com/rivet-dev/rivet/releases.atom；HN item

**C 组**
- Perplexity changelog 条目｜https://www.perplexity.ai/changelog/teammates-fully-local-computer-on-mac-and-voice-mode
- Anthropic API release notes｜https://docs.claude.com/en/release-notes/api
- Computer use tool｜https://docs.claude.com/en/docs/agents-and-tools/tool-use/computer-use-tool
- Browser use tool｜https://docs.claude.com/en/docs/agents-and-tools/tool-use/browser-use-tool
- Project EVE｜https://www.anthropic.com/research/project-eve-claude-plays-mmorpgs
- Cloudflare changelog｜https://developers.cloudflare.com/changelog/
- LangChain 浏览器优化｜https://blog.langchain.com/how-we-optimized-browser-use-for-deep-agents/
- ChatGPT changelog｜https://learn.chatgpt.com/docs/changelog；API changelog｜https://learn.chatgpt.com/api/docs/changelog

**D 组**
- MCP spec PR #3518 / #3469 / #3185 / #3514｜https://github.com/modelcontextprotocol/modelcontextprotocol/pull/…
- MCP Inspector 2.14.0｜https://github.com/modelcontextprotocol/inspector/releases
- MCP Registry v1.8.8｜https://github.com/modelcontextprotocol/registry/releases
- Agent Substrate / CNCF｜https://cloud.google.com/blog/products/containers-kubernetes/open-infrastructure-for-autonomous-agents-comes-to-cncf/
- Google 技能评测五规则｜https://cloud.google.com/blog/topics/developers-practitioners/evaluate-agent-skills-before-they-bloat-your-context-window/
- Glean release notes｜https://docs.glean.com/release-notes/
- Sierra acquires Anon｜https://sierra.ai/blog/sierra-acquires-anon
- Harvey FORUM Chicago｜https://www.harvey.ai/blog/forum-chicago-product-announcements
- Salesforce Coworker｜https://www.salesforce.com/news/stories/agentforce-coworker-surpasses-185k-users/
- E2B 2.63.0｜https://github.com/e2b-dev/E2B/releases.atom
- arXiv 2611.02527 / 2611.06585 / 2611.07640 / 2611.03555 / 2611.08417 / 2611.07631 / 2611.03743 / 2611.07238 / 2611.07689｜https://arxiv.org/abs/…
- Zalando Identity Broker｜https://github.com/zalando-incubator/agentic-identity-broker

## 十一、冻结声明

- 本稿为第 23 期研究母稿，窗口冻结为 2026-11-02 00:00 ~ 2026-11-08 24:00（Asia/Shanghai）= 2026-11-01T16:00Z ~ 2026-11-08T16:00Z。所有「本周」仅指该区间；区间外条目已逐条标注「背景，非本周」或「窗外」。
- 窗内最后一条被计入的发布为 OpenAI Agents SDK 0.24.0-alpha.7（2026-11-08 15:07 CST）；OpenClaw 2026.11.2（11-09 04:27）、CrewAI 1.15.38（11-09 03:39）均明确排除，下期跟进。
- 每条主张单独定级：A 可核原始事实；B 具名披露/研究结果（未独立核实）；C 有限独立佐证；D 欠证/争议。厂商自述数字一律标 B。
- 本稿只在本工作目录内生成，未发布、未推仓、未使用任何 GitHub/ECS 凭证，未调用 Codex，未使用任何付费检索代理。
- 读者稿 `reader.md` 由本稿派生，差异仅为文体与取舍，事实与数字须一致（见 `quality-gate.md` 的 number_diff 结果）。

### 4.4 企业 Agent：身份、预算、审计三件套

**Glean v568（11-06）/ v567（11-03）** 把 Agent 的身份从「用户 OAuth 代跑」改成**服务账号**：Atlassian、Coda、Datadog、incident.io、Intercom、Linear、Zendesk（v567 另有 ServiceNow）的 service-credential MCP servers 转 GA，Agent 通过共享服务账号访问。代价是权限粒度从「用户可见范围」变成「服务账号被授予的范围」，所以同版必须补上「投递前校验订阅者可见性」——Slack 触发的投递先校验订阅者能否看到该频道，Zendesk 触发在无法核验时**不再投递**。成本侧把选模型从用户行为改成管理员策略：Auto mode 可按组织/部门指定 Economy/Balanced/Frontier，Frontier 用户到月度额度 **75%** 降 Balanced、**90%** 降 Economy；因自动设定推理强度，原 Fast/Adaptive/Thinking 三档被移除；回复中显示实际模型。另有 EU AI Act 透明度提示（用组织白标名替换 "Glean"）。[A｜条款；B｜效果]

**Salesforce Agentforce Coworker（11-04）** 给出的是定价与入口：185,000+ 用户、三个月用量增长 21x、$50/用户/月，Teams 内直接派活并沿用既有权限与 sharing rules，12 月起定时任务与 Daily Digest。治理叙事是否兑现取决于「Agent 的越权是否等于用户的越权被放大」——它继承对象/字段级安全，卖点是不用重建权限，风险也在这里。[B｜数据与效果均厂商自述；A｜价格与日期]

**Sierra 收购 Anon（11-05）** 是本周唯一把「Agent 的登录能力」当资产买下的动作：Anon 提供 authentication/credential handling、浏览器基础设施、agent harness 与可嵌入 SDK，自述已处理敏感数据与 MFA、单任务数小时、出错后恢复。Sierra 博文把这条与 Horizon 的长周期目标直接挂钩——放贷、医保 prior authorization 往往跨多个无 API 的系统，任何一步要登录就会打断端到端完成率。[A｜日期；B｜能力自述]

**Harvey（11-05，FORUM Chicago）** 的方向是「把上下文从 prompt 搬到数据结构」：Harvey Graph 映射一个 matter 内的关系，让多个 Agent 共享同一张工作地图（"agents can only hand work to one another if they understand it the same way"）；Fact Graph 维护争议/诉讼的事实与证据链；Intake 从业务方邮件直接接单；Outlook 内跑个人简报 Agent。护城河从「模型 + 提示」转为「事务图谱 + 入口」，采购时要问图谱的更新与权限继承。[B｜产品自述；A｜日期]

**未取得**：ServiceNow（press-room / investor / sitemap / newsroom / blogs 五个入口全部 403 或 JS 渲染）、Coze（coze.cn / coze.com / 文档 changelog / 火山引擎产品页 / 三个 SDK 仓库均无窗内条目）。按「未取得 ≠ 不存在」处理，不做产品推断，入口清单见 §九。[—]

### 4.5 MCP 与评测：这一周在「补合约」和「拆地基」

**MCP 没有新能力，只有合约收紧。** spec 仓库窗内 17 个 merged PR 全落在 docs/CI/schema 修复/依赖升级；SEP 索引仍为 Accepted 1（SEP-3398）/ Final 44，无窗内新增；无新规范修订版、无 SDK 大版本。三条实改动：① PR #3518（11-08）把 **CIMD 立为客户端注册主路径、DCR 标 deprecated**，示例整体迁 v2 SDK 并加 audience/issuer/scope/origin 四项校验——规范层 2026-07-28 已定，本周是「实现指南换轨」，让新接入方从第一天就走 CIMD；② Inspector 2.14.0（11-05 07:55 CST）一次修 3 个 CVE：MCP App 的 sandbox frame 一旦离开获批 CSP 策略就断 relay 并移除 frame，服务端提供的 schema pattern 改为**有界时间线性匹配**（超限报「未验证」而不求值），server.json 导入前置显示确切命令、URL elicitation 限 http(s)；③ Registry v1.8.8（11-06）放开「不同 server name 共享同一 remote URL」，要求消费方按 **name + version** 而非 URL 唯一性索引——服务端无需迁移，但按 URL 建键的客户端会静默丢记录。另有两处 schema 修正：回补 input request/response 的可选 `_meta`（#3469），修掉 oneOf 类型检查绕过（`{"id":"r1","name":123}` 曾可通过，#3185）。治理上贡献路径改为以 working group 为单位（#3514）。[A]

口径纠正：「MCP Skills 进 Beta」**不是本周事件**。实际目录移动发生在 ext-skills#161（2026-10-29），本周 #3466 只是把网站链接从 `specification/stable/` 改指 `specification/beta/`。写作时必须标背景。[A]

**编码评测侧没有新榜，但有三篇在拆旧榜的地基。** Surge AI（11-05）把「思考预算 vs harness 复杂度」做成可比较的数字：固定 Opus 5.5、100 个真实 SE 任务，vanilla Claude Code 的 thinking 从 medium 提到 xhigh 提升 **11.3 分**；最有效的 harness 增量只有 **2–3 分**（Superpowers +2.4 分、成本 +10%；`/goal`+`/code-review` +3.3 分、成本 1.8×）；Compound Engineering 成本 **8×**、无统计显著提升。arXiv 窗内五篇编码评测互相咬合：`Take It From Here` 的项目接管在 Full History 下完整交付率仅 **4.95%**（6 个 model-harness 组合、37 个可执行目标）；`Multi-step SWE` 的 69 个 5–15 步依赖链任务最强仅 **18.5%**；`Hard Issue, Weak Model, or Bad Run?` 发现只看题难度的参考分可达 **0.92 AUROC**，而轨迹预测器约 **0.62**——现有失败预测器主要学到题难度与模型能力，而非 run 状态。Terminal-Bench 2.0 的「benchmark maintenance debt」则解释了为什么厂商自述与独立复现会分叉：模型变强后合法解会被旧验证器误判。[B｜预印本/厂商基准]

安全与治理侧的可采购数字：官方 MCP registry 1,000 仓库抽样中约 **90%** 的破坏性工具没有服务端确认（95% CI 82–95）；41 个主流 host/SDK 里 **32 个默认没有审批步骤**，配对后 **60.7%** 的工具×宿主组合没有强制人工批准。MCP 工具投毒的跨框架实测跑 9,720 格（12 框架 × 18 模型 × 45 场景），总体攻击成功率 **22.9%**，其中 12.1% 可验证外泄。另一篇证明「已签名」不等于安全：一个签名工具可以在完成广告功能的同时把数据塞进发往「策略允许目的地」的请求，Meta 的 MCPGuard-Dynamic 对该攻击每次试验都失败；作者提出「germline execution」——每次调用从无数据胚种进程 fork 临时副本，只注入本次最小输入。间接提示注入被重新定义为**权限问题**而非措辞问题：植入内容试图影响其来源无权决定的决策即为攻击，基准含 90 个已校验用例。[B｜预印本]

**沙箱侧的补充**：E2B 2.63.0（11-05 00:41 CST）把「暂停」变成三态——`pause(strict)` 在 guest agent 不响应时拒绝暂停并抛 `ServiceBusyError`，沙箱继续运行；默认行为仍是「照常快照并打标记」。对长任务 Agent，静默产生一个「看似恢复实则状态残缺」的沙箱是最坏情况，strict 让编排层能决策（重试、迁移、放弃）。[A]

**上下文工程**：产品侧解法是「让上下文可检查」（Harvey 的两张图、Glean 的 context panel）；研究侧在修「压缩即销毁」——MEMOIR 在合并前用 screening gate 判断「答案相关证据」是否会被破坏、并做用后回溯归因；EvoMemState 把「事实集合」改成「状态中心」。mem0 / Letta / Zep 窗内均无 release。[B｜预印本；A｜无发版]

**代码库噪声可计价**：Google《Agent Distraction》（11-06）以 `TODO(bug/...)` 引用为代理，跨数千工程师、数亿 agent step 统计：13% 的读文件会话接触到此类引用，其中 6% 触发后续动作，而这些动作 **83% 是用户没要求的**；控制开发者、代码库复杂度、任务类型、模型档位等变量后，每会话 **+70% 步数、+77% token、+105% 等待时间**（p<0.0001）。[B｜厂商自述含方法]

## 五、对比表（跨组素材）

| 产品/项目 | 版本或日期 | 变化摘要 | 是否破坏性 | 影响面 | 证据级 |
|---|---|---|---|---|---|
| Claude Code | 2.1.317（11-03）/ 318（11-04）/ 319（11-07 01:04 CST） | `permissions.denyInsteadOfPrompting`（含子 agent/teammates）；auto mode 服务端核不了即问或拒；MCP tasks 后台化；网关成本归因与 JSON 日志；修 worktree 创建期沙箱逃逸 | 部分（行为收紧；原本弹窗的调用现在直接拒绝） | 全部 Claude Code 用户、企业网关、MCP 任务编排 | A |
| Codex CLI | 0.167.0（11-06 09:42 CST） | `prompt-user` 新鲜批准命令规则；`[permissions.network]` 声明式网络权限；Guardian 服务端复核；Code Mode 协商截断；MCP per-chat 租约；`deferred tool world state` 默认开 | 是（审批记忆与网络策略行为变化） | CLI 用户、CI、多会话工作站 | A |
| OpenAI Agents SDK | 0.24.0-alpha.6（11-04）/ alpha.7（11-08 15:07 CST） | v0 运行时退居 `agents.classic`；native 默认 `write_policy="strict"`；权限在 Session 打开时快照不可扩张；`RunBudget` 缺 usage 即停止准入；`approval_mode`/`Turn`/`Runner` 等 API 全面改名 | 是（几乎全 API 面） | 已上 0.23 的团队；CI 不能靠 PyPI 取版 | A |
| Microsoft Agent Framework | python-1.25.0 / dotnet-1.28.0（11-07） | 7 条 `[BREAKING]`；授权作用域与 agent 绑定；MCP 会话改为每次调用新开 | 是 | .NET/Python 企业集成；AutoGen 迁移方 | A |
| Google ADK | v2.14.0（Atom 11-07 08:58；正文标 11-04） | 环境/A2A/评测转稳定；`RunSkillScriptTool` 不再接受 `command`（关掉提示注入执行任意 shell）；16 个特性毕业后 `ADK_DISABLE_*` 静默失效；Enum 参数改收成员 | 是（含静默行为变化） | ADK 部署、skill 脚本作者、运维开关 | A |
| Hermes Agent | v0.23.0（11-06 05:32 CST） | 单 gateway 拥有全部会话；付费 MCP 工具单次标价 + 累计 + YOLO 也问；bot 回环 `max_hops=4`；`browser_*` 十件套删除只留 `browser_exec`；Electron 44 抬到 macOS 13+；Verified 插件层 + curator lock | 是 | 个人/小团队自托管、插件与浏览器工具作者 | A |
| Dify | v1.19.0（11-04 15:37 CST） | 嵌套 workflow 追踪（历史不回填）；`.ifpkg` v2 打包 Workflow Tool 依赖并重映射；`ops_trace_v2` 双写过渡；Compose ≥2.35 | 部分（导入器版本、队列配置） | 多租户平台运维、跨工作区交付 | A |
| MCP Inspector | 2.14.0（11-05 07:55 CST）/ 1.0.4 | 3 个 CVE：MCP App frame 离开获批 CSP 即断 relay；schema pattern 改有界线性匹配、超限报「未验证」；导入前置校验、URL elicitation 限 http(s) | 是（v1 线不再求值 pattern，原本被拒的输入现在接受并附注） | MCP App 宿主、把 Inspector 当校验器的 CI | A |
| MCP Registry | v1.8.8（11-06 22:12 CST） | 不同 server name 可共享同一 remote URL；消费方须按 name + version 索引；prepared listing 回填、bounded autoscaling | 是（消费者键语义；无数据库迁移） | MCP 目录/市场、企业白名单、聚合搜索 | A |
| MCP 授权指南 | PR #3518（11-08 合入） | CIMD 立为客户端注册主路径；DCR 标 deprecated；示例迁 v2 SDK；加 audience/issuer/scope/origin 校验 | 否（文档层；规范层 2026-07-28 已定） | 所有 MCP client、授权服务器、MCP 网关 | A |
| Agent Substrate / gVisor / OpenRL | 2026-11-06 | 宣布将在 KubeCon 捐入 CNCF（上月已进 Sandbox）；Agent Substrate 1.0 并 GA on GKE；Actor/Worker 解耦、空闲快照 <500ms 恢复、10x 容器密度 | 否 | 沙箱厂商、平台工程、自有 K8s 采购口径 | A |
| E2B | 2.63.0（11-05 00:41 CST） | `pause(strict)`：guest agent 不响应即拒绝暂停并抛 `ServiceBusyError`；暴露 `envdUnresponsiveAtPause`；此类沙箱 resume 未指定 reboot 会抛错 | 否（新增参数），但恢复路径新增异常 | 长任务 Agent 编排 | A |
| Glean | v567（11-03）/ v568（11-06） | Agent 服务凭证 GA（7 个 MCP servers，ServiceNow 于 v567）；Auto mode 按部门设 Economy/Balanced/Frontier，75%/90% 自动降级；Fast/Adaptive/Thinking 三档移除；投递前校验订阅者可见性 | 是（三档模式移除；无法核验权限时不再投递） | 企业知识平台管理员、用户 OAuth 型 Agent 部署 | A（条款）/ B（效果） |
| Salesforce Agentforce Coworker | 2026-11-04 | 185,000+ 用户、三个月 21x；Teams 内派活、M365/Workspace 连接、原生端、Conversation History、Skills；**$50/用户/月** | 否 | 全员 Agent 的定价基准与入口竞争 | B（数据自述）/ A（价格日期） |

## 六、综合层：本周真正变了什么

1. **执行面被拆成四层，且本周每层都有独立供给。** 客户端沙箱（Claude Code Bash sandbox 的覆盖边界）、云端运行时（Replit microVM、E2B strict pause）、集群编排（Agent Substrate、agent-sandbox v1.0.10）、跨层授权（Claude Code 权限规则、OpenClaw 策略、MCP CIMD）。四层可以分别采购、分别验收，也可以分别失守——Apiiro 的 1,122 个文件不是沙箱被突破，而是授权被持久化进仓库。这决定了「我们上了沙箱」不能回答「我们的 agent 不会越权」。

2. **默认值是本周最危险的东西，且四条都不是 API 变更。** OpenAI 把打包模型的默认 reasoning 从 low 提到 medium；ADK 让 16 个特性的禁用开关静默失效；Copilot CLI 把插件规则 `alwaysApply: false` 反转成「默认不进 prompt」；AutoGPT 不再随包发 VAPID 密钥对（升级后既有推送订阅失效）。加上 Claude Code 的 auto mode fail-closed，本周至少有五个「升级后行为变了但没人报错」的点。升级检查表应单列「默认值差异」，而不是只对照 breaking changes 章节。

3. **成本开始成为与权限并列的运行时概念。** OpenAI `RunBudget` 在缺 usage 时**停止准入**（fail-closed，而不是没数据就放行）；Hermes 把付费 MCP 工具的单次价格与该聊天累计显示在审批卡上，YOLO 也问；Glean 用 75%/90% 两档阈值自动降级模型；Surge AI 则证明 8× 成本的配置没有统计显著收益。四条合起来说明：agent 的钱不能只在账单里事后追责，必须在执行前有准入控制。

4. **身份从「功能」变成「资产与协议」。** Sierra 买 Anon（凭证处理 + 浏览器基础设施 + harness + SDK）、Glean 把用户 OAuth 换成服务账号并补投递前权限校验、MCP 把 CIMD 立为注册主路径、Zalando 开源委派链 broker、NIST 在 10-27 提身份十原则（背景）。企业 Agent 的瓶颈已从「能不能做」转到「以谁的身份做、谁批准、出事能否追溯」。

5. **评测的进展是否定式的。** 本周编码评测没有新榜；SWE-bench 仓库停在 2026-09-02，OSWorld 只有任务修复。真正的进展是拆地基：项目接管 4.95%、多步 18.5%、失败预测器 0.92 vs 0.62、benchmark maintenance debt、MCP 投毒 22.9%、破坏性工具无审批 90%/60.7%。对周报口径的含义：本周不该报「某模型涨点」，该报「评测本身正在被重做」。

6. **平台、SDK、harness 三条路线已经分家。** 平台（Dify/OpenHands/AutoGPT）做自动化、模板、服务账号、包格式；SDK（ADK/OpenAI Agents SDK/MS AF）把执行环境、授权、预算写成契约；harness（Pi/Hermes/OpenClaw）把内核外置或收敛成一个 gateway。三层的动作没有重叠，说明市场分层已稳定——选型时应先问「我在选哪一层」，而不是横向比功能表。

## 七、本周 vs 上周

| 维度 | 上周（第 22 期） | 本周（第 23 期） | 走向 |
|---|---|---|---|
| 权限与沙箱 | Claude Code `blockWritesOutsideWorkingDirectories`、网关 layered policy | `denyInsteadOfPrompting`、auto mode fail-closed、Codex `[permissions.network]`、Copilot 扩展进程进沙箱 | 从「配置项」变成「默认姿态」；下期看默认值迁移成本 |
| MCP 治理 | Smithery 代理关停、SEP-3398 发布火车、SEP-3392 扩展生命周期 | CIMD 上位/DCR 退场、Inspector 3 CVE、Registry 键语义 | 从「连接」转向「注册与索引」，安全修复常态化 |
| 沙箱基础设施 | 无独立层（多为产品内实现） | Agent Substrate 1.0 宣布捐 CNCF、Replit microVM 重写、agent-sandbox v1.0.10、E2B strict pause | **新出现**；下期看 CNCF 治理节奏与托管定价 |
| 企业身份与预算 | Salesforce Agent Evals/Kill Switch（10-27）、Glean v565 | Glean 服务凭证 GA + 75/90 阈值、Sierra 收购 Anon、Coworker $50/席位 | 延续并产品化；身份成为并购标的 |
| 评测 | 单任务榜单与厂商涨点为主 | 接管 4.95%、多步 18.5%、维护债、投毒 22.9%、审批缺口 60.7% | **转向**；下期看是否有新榜接住这些方法 |
| 开源编排 SDK | LangGraph 1.2.18/19、CrewAI 1.15.31–33 | LangGraph 1.2.20、CrewAI 1.15.34–37、MS AF 7 条 BREAKING | 延续；破坏性集中在 SDK 而非图模型 |
| OpenClaw | 10.8/10.9 | 2026.11.1（信任边界补丁线）+ 11.2 窗内合入、窗外出包 | 延续；「一个 Gateway 一个信任边界」成为主线 |
| 终端与分叉 CLI | Aider/Roo 仍有零星维护 | Aider 停更 9 个月、Roo 停更 6 个月、Windsurf 入口并入 Devin | **降温**；应从 2026 Q4 选型清单移出 |

一句话：上周是「把 MCP 收进官方端点」，本周是「把执行面拆成可采购的层」。下周 KubeCon NA（11-09~12）会期大概率给出 CNCF 侧的第一批治理细节，值得作为下期开篇。

## 八、对你意味着什么

**给 R1（开发者，主读者）**

- 升级前先查「默认值差异」，不要只看 breaking changes：ADK 的 `ADK_DISABLE_*` 已成为空操作；Copilot CLI 的 `alwaysApply: false` 已反转；OpenAI 打包模型默认 reasoning 从 low 到 medium。三项都不会报错。
- 如果你的 CI 跑 `opencode run`，现在必须自带 timeout 与 SIGTERM 处理（退出码 143），否则一个 watcher 会永久占用 runner；同时用 `--archived` 让 CI 会话不污染会话列表。
- 别把含密命令存进 allow 规则。Claude Code 的「don't ask again」会把整条命令写进 `.claude/settings.local.json`，且只加进全局 gitignore；用 `denyInsteadOfPrompting` 把「本该问」的调用变成拒绝，比扩大 allowlist 安全。
- MCP 客户端/网关：把客户端注册迁到 CIMD、按 name+version 索引 registry、升级 Inspector 2.14.0。三件事都有明确的失效模式（DCR 退场、URL 键静默丢记录、schema ReDoS）。
- 评估 harness 时先调思考预算：Surge AI 的 11.3 分 vs 2–3 分说明，先加 thinking 再加 skill/多 agent。

**给 R2（架构负责人，协同读者）**

- 沙箱选型问四个可测指标：唤醒/恢复时延、状态快照粒度、隔离级别（gVisor / microVM / 容器）、egress 与凭据是否在 guest 外强制。Agent Substrate 与 Replit 各自给了可比较的数字（<500ms / ~500ms、96.1% CVE 规避）。
- 权限模型能否承载「服务账号」是本周企业侧的核心问题：Glean 的答案是服务账号 + 投递前可见性校验 + 预算阈值；Salesforce 的答案是沿用既有 sharing rules。两种都要回答「agent 越权是否等于用户越权被放大」。
- 预算要做成准入控制而不是账单告警：参考 `RunBudget` 的 fail-closed（缺 usage 即停止）与 Glean 的 75%/90% 降级。
- 评测改用接管与多步口径：一次性 patch 的分数已经不能预测生产表现（4.95% / 18.5%）；同时给基准留维护预算（benchmark maintenance debt）。
- 供应链：Hermes 的 Verified 插件层 + 更新前拦截破坏性变更，是可复制的做法；对自托管 gateway，把「日志脱敏、出站代理信任链、配置写入不覆盖密钥」当三条常驻回归线。
