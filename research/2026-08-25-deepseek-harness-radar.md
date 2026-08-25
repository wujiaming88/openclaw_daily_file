# DeepSeek Harness 全景跟踪报告（首期基线｜2026-08-25）

- **报告日期**：2026-08-25（周二，Asia/Shanghai）
- **首次基线窗口**：公开版本自 2026-08-10 首个 npm RC、2026-08-17 首个 GitHub Release 起，生态与案例重点覆盖最近 30 天，截止 2026-08-25 14:10（UTC+8）
- **7 天补漏窗**：2026-08-18 14:00（不含）—2026-08-25 14:10（含）
- **检索截止时间**：2026-08-25 14:10（UTC+8）
- **事件分类**：本期为首次运行，尚无“上期补录”；窗外 rc.7 仅作基线背景；rc.8、rc.1、rc.2及同期生态事件计入本期基线新增；跨期问题进入持续跟踪。

> **阶段警示**：官方产品页与 README 均明确写明 **Developer Preview**，且警告未来会有兼容性破坏。npm 将 RC 放在 `latest` 不等于稳定版；任何试用都应固定精确版本、备份会话并放在隔离环境。

## 1. 本期一句话结论

DeepSeek Harness 用 Cordis 把模型、工具、Skill、Session、Sandbox、Storage、Loop、Scheduling 与 UI 全部拆为插件，架构差异化已成立，短期版本和社区供给爆发；但当前仍是 RC/Developer Preview，SQLite 不兼容升级、权限边界与第三方插件供应链风险真实存在，且没有可独立核验的 P1 生产案例，因此最合理的定位是“值得研究和做受控 Demo 的新一代 Agent Runtime”，不是可直接承诺企业 SLA 的成熟平台。

## 2. 质量门控摘要

| 门控 | 结果 | 说明 |
|---|---|---|
| 完整性 | **通过** | 8/8 大章节；12/12 架构模块均检查 |
| 时效性 | **通过** | 首期基线、7 天补漏窗、实际截止时间均明确；背景/本期/持续问题分开 |
| Release/Tag/SHA | **通过** | `v0.1.1-rc.2` / `dsh-v0.1.1-rc.2` / `b150a551…d28e` 三项一致；14:10 复扫无更新 |
| Breaking / 迁移 | **通过** | rc.8 SQLite 数据格式不兼容且无通用迁移承诺；Developer Preview 风险已标明 |
| 插件真实性 | **有条件通过** | 重点项目核对仓库/包/版本/日期/License/兼容/维护；A/B/C/D 已分级；无插件达到 A，不凑数 |
| 案例真实性 | **通过** | P1—P5 分级；结论明确 P1=0、P2=0，Demo 未包装为生产 |
| 重点事实抽查 | **通过** | 12/12 原始链接与正文/元数据相符；官方/架构 5、插件 4、社区/案例 3 |
| 安全覆盖 | **通过** | Sandbox、网络/进程边界、凭据、插件供应链、SQLite 升级、Web 控制面均覆盖 |
| 数据可信 | **通过但有限制** | GitHub 数字有抓取时间；Topic 总量明确降级为高噪发现指标，不等于有效插件数 |
| 行动价值 | **通过** | 立即体验、3 个 Demo、开发机会、OpenClaw 集成、暂不建议、下期 10 问齐全 |
| 零编造 | **通过** | 查不到的 P1/P2、长期记忆、原生 Browser/Computer Use、企业治理均写未验证或缺口 |

**门控局限**：未安装社区插件，故没有 A 级“运行验证”；官方仓库关闭 Issues/PR，公开响应速度与首次贡献者无法可靠统计；部分安全问题来自可复现社区报告而非 CVE，必须对固定版本再次动态复测。

## 3. TOP5 关键变化

1. **`v0.1.1-rc.2` 完成 Release/Tag/SHA 对齐**：最新预发布版于 8 月 21 日发布，DeepSeek 适配器优先通过 Files API 上传并复用图片，自动缩放和格式转换；多模态链路更实用，但仍是 RC。
2. **rc.8 扩展为“上层编排器”**：Claude Code 与 Codex 可作为按需 Profile Bundle，支持命名实例、非交互权限与 Job Panel；这比单纯再做一个 coding agent 更具战略价值。
3. **安全修复与新风险同时出现**：rc.1 修复 Bubblewrap 通过 `/proc/<pid>/root` 绕过文件限制，但官方 SandboxMode 明确不覆盖网络和进程可见性；Web 控制面、approval principal 与 Code Mode 仍需固定版本复测。
4. **SQLite 性能改善伴随不兼容格式**：rc.8 提升读写/分叉性能并缩小体积，却明确数据结构不兼容；预览期升级前必须导出、备份、恢复和回滚演练。
5. **生态爆发但发现层严重失真**：14:10 复扫 `topic:dsh-plugin` 为 11,432 个仓库，样本混入通用项目和蹭标签仓库；只有 Bridge、Vision Router、dsh-web 单项包达到 B 级，不能用 Topic 数量或 Stars 代替有效生态质量。

## 4. 时间窗与版本时间线

| 分类 | 事件 | 时间（UTC+8） | 身份 |
|---|---|---:|---|
| 背景基线 | npm `0.0.1-rc.1` 首次公开 | 2026-08-11 03:41 | 背景，首期基线 |
| 背景基线 | GitHub `dsh-v0.1.0-rc.7` | 2026-08-17 20:01 | 7天窗前背景 |
| 本期基线新增 | `dsh-v0.1.0-rc.8` | 2026-08-19 23:37 | 7天窗内 |
| 本期基线新增 | `dsh-v0.1.1-rc.1` | 2026-08-21 15:12 | 7天窗内 |
| 本期基线新增 | `dsh-v0.1.1-rc.2` | 2026-08-21 20:35 | 7天窗内、当前最新 |
| 持续跟踪 | SQLite 迁移、安全边界、插件 ABI、案例真实性 | 截止 2026-08-25 14:10 | 下期复核 |

14:10 最终复扫结果：Tags 最新仍为 `dsh-v0.1.1-rc.2`，Tag 与 master HEAD 均为 `b150a551b8d465e31e418e1b2eaf5e79bbb7d28e`；GitHub 的 `/releases/latest` 因全部为 prerelease 返回 404，因此最新版本以 Releases 列表首项而非该端点判定。

---

## 5. 官方版本、代码演进与 12 模块架构

# DeepSeek Harness 全景报告 A线：官方版本、代码、架构、安全

- 报告日：2026-08-25（Asia/Shanghai）
- 检索截止：2026-08-25 14:00 CST（GitHub 仓库最后可见 push 为 2026-08-21 20:35 CST 左右）
- 基线：首次运行，无历史基线；版本追溯至首个公开 npm 版本/首个公开 GitHub Release，重点近 30 天
- 7 天回溯窗：2026-08-18 14:00 CST—2026-08-25 14:00 CST
- 证据原则：官方仓库、官方 Release/Tag/Commit、官方 npm 元数据、Cordis 官方仓库/论文优先；所有关键事实见同目录 `A-evidence.tsv`

## 0. 执行摘要

DeepSeek Harness（`dsh`）是 DeepSeek AI 官方开源 Agent Harness，核心定位为“Everything is a Plugin”。其运行时建立在 Cordis 之上，将模型适配器、工具注册、Session 日志、Agent Loop 乃至 UI/持久化都实现为可配置、可卸载的插件。官方 README 明确标注 **Developer Preview**，并以醒目文字警告仍会发生兼容性破坏，不宜按稳定平台对待。

截至截止时点，三项核验一致：

| 核验项 | 最新值 | 结论 |
|---|---|---|
| GitHub Release | `v0.1.1-rc.2`，2026-08-21 20:35 CST，预发布 | 最新公开 Release |
| Git Tag | `dsh-v0.1.1-rc.2` | 与 Release 一致 |
| Tag 对应 Commit | `b150a551b8d465e31e418e1b2eaf5e79bbb7d28e` | 与 master HEAD/Release 合并提交一致 |
| npm dist-tag | `@deepseek-ai/dsh` 的 `latest`、`next` 均为 `0.1.1-rc.2` | 官方包元数据一致 |

首个公开 npm 版本为 `0.0.1-rc.1`（2026-08-10 UTC）；GitHub 仓库创建于 2026-08-13 UTC，首个公开 GitHub Release 为 `dsh-v0.1.0-rc.7`（2026-08-17 UTC）。仓库内部最早提交可追溯至 2026-06-10，但不能等同公开 Release。

本 7 天窗内共 426 个 master 可达提交，发布 `0.1.0-rc.8`、`0.1.1-rc.1`、`0.1.1-rc.2` 三个预发布版；主线增量是多模态图像/Files API、子代理 Profile Bundle、Windows 持久 PowerShell、Web/会话性能及安全修复。最重要安全事实是 rc.1 修复 Bubblewrap 受限进程借 `/proc/<pid>/root` 绕过限制；但 Sandbox 的承诺仅覆盖文件效果，**不覆盖网络与进程可见性**，Windows ACL 与旧 Landlock 仍可能只达到 partial enforcement。

## 1. 版本、阶段、迁移与安全

### 1.1 发布阶段

- 官方 README 当前明确写作 **Developer preview**，并声明“THERE WILL BE COMPATIBILITY-BREAKING CHANGES”。
- 所有 GitHub Release 都带 `rc` 且标记 prerelease；npm 主包虽将 RC 置于 `latest`，不改变其预览性质。
- 结论：官方阶段仍是 Developer Preview，成熟度为 **早期预览 / 高频迭代**。

### 1.2 版本链与近 7 天变化

1. `dsh-v0.1.0-rc.7`（2026-08-17，窗前）：插件设置卡、Codex/Claude Code Job Panel、MCP/ACP 持久图片附件；多项大历史与 max-token 修复。
2. `dsh-v0.1.0-rc.8`（2026-08-19）：DeepSeek 原生图片请求，`/goal`、`/plan` 图文输入，`@` 引用文件/会话；Codex/Claude Code 子代理可按需安装为 Profile Bundle；Windows PTY 持久 PowerShell；SQLite 后端读写/分叉与体积优化，但**数据结构不兼容**；Python SDK 依赖扩展。
3. `dsh-v0.1.1-rc.1`（2026-08-21）：新增 `DeepSeek-V4-Flash-Vision-Exp`；修复 Bubblewrap `/proc/<pid>/root` 逃逸；优化子代理会话标题、cache-hit 精度、问答多行输入。
4. `dsh-v0.1.1-rc.2`（2026-08-21）：DeepSeek Files API 优先上传与复用，按模型自动缩放/格式转换。

### 1.3 Breaking / 迁移

- 总体：官方明确不保证兼容。
- rc.8 明确指出 SQLite 数据结构不兼容；当前 SQLite README 描述 schema 17，并明确旧 schema、外来应用标识、非空未版本化库与不兼容对象均拒绝，**预发布 provider 不提供迁移**。升级前必须备份/导出会话，不能原地假设兼容。
- Session persistence 只提供少量同 format version 的旧记录读取转换，不是通用 v0 迁移承诺；未知必需事件会 fail closed。
- 最新 rc.2 未单独列 breaking change，但不能据此推断稳定。

### 1.4 安全状态

- 已验证修复：rc.1 阻止 Bubblewrap 受限进程通过 `/proc/<pid>/root` 绕过文件限制（合并 PR #1798；Release 明列）。
- Sandbox 设计：`read-only` / `workspace-write` / `danger-full-access`；confined 模式不可静默降级，provider 不可用时必须 `SANDBOX_UNAVAILABLE`。
- 边界：SandboxMode 只治理文件效果；网络和进程可见性不在承诺内。旧 Landlock ABI 和 Windows ACL 的 Everyone/硬链接边界可报告 `partial`，要求绝对边界的调用方必须拒绝或显式提示。
- 权限：默认 permission presets 包含 `workspace-write + ask` 与 `danger-full-access + never`；后者风险极高，属于用户显式选择，不是安全默认替代。
- 持久化加固：SQLite 禁用 trusted schema 与 mmap，强制/校验 `synchronous=FULL`；POSIX 检查所有权与权限，拒绝符号链接/非普通文件；Windows 仍由部署方负责 ACL。
- 官方 GitHub Security Advisories API 截止时返回空数组；这仅表示无公开 advisory，不等于无漏洞。

## 2. 架构总览

Cordis 提供显式依赖注入、scoped services、生命周期清理与配置驱动加载。论文《A Programming Paradigm for Spatiotemporal Composability》（2026-08-13 draft preprint）将其抽象为：可逆 effect 支持时间可组合性，reactive coeffect 支持空间可组合性，组件卸载时 effect 应回滚，依赖变化触发重求值。Harness 仓库 vendor 了 Cordis，并发布 `@deepseek-ai/cordis`；其 npm stable 为 `4.0.1`，而 dsh release 系列使用同仓库 vendored 版本。

启动时 `dsh` 从有序 layers 构造插件树：Profile → Bundles → profile patch → home patch → `--patch` overlay。`dsh-base` 装配模型、工具、持久化、sandbox、审批、设置、凭证、telemetry；`dsh-web-app` 加 Web 应用；`dsh-headless` 提供无服务器一次性 runner。所有模型可见输入必须可从 append-only SessionEvent log 重构，运行时 invariant 会检查这一点。

Agent 生命周期以 Turn/Step 为核心：一个 Step 是一次模型请求加工具调用；一个 Turn 可含多个 Step。流为 inbox → prompt/tool schema assembly → `agent/pre-step` → `llm/stream` → assistant chunks/message → guarded tools pipeline → tool results → step/turn end。Session/Agent/Capability 三类事件分别承担 durable facts、live orchestration 与 capability policy。

## 3. 十二模块完整检查

> 成熟度：预览-低 / 预览-中 / 预览-较高，均不代表生产 SLA。

### 3.1 Cordis

- **当前能力快照**：全插件化 Context；显式 DI、Service、typed events、fiber/effect 生命周期、配置 loader/include/HMR；注册 effect 可在插件卸载时回滚。Harness vendor Cordis，并有 primer、tutorial、API 文档和自动生成 catalog。
- **本期变化**：已检查近 7 天 commit/Release，未发现已验证的 Cordis 核心语义重大变化；主要为文档/catalog 与产品插件迭代。
- **证据 URL/日期**：架构文档与 Cordis primer（仓库 HEAD 2026-08-21）；Cordis 论文 draft 2026-08-13；npm `@deepseek-ai/cordis` stable 4.0.1（2026-08-13）。
- **成熟度**：预览-较高（框架机制丰富，但 Harness 整体仍 Developer Preview）。
- **风险缺口**：同进程插件默认是 trusted composition code；插件供应链/恶意插件隔离不由 Cordis 自身解决；论文仍是 active revision preprint。

### 3.2 Agent Loop / Goal / Plan

- **当前能力快照**：唯一 concrete loop 位于 `dsh-agent-loop`；支持创建/恢复、Turn/Step、并行工具、cancel/drain、durable goal、goal round driver、`/goal`、plan mode、todo/workflow。
- **本期变化**：rc.8 的 `/goal`、`/plan` 支持图文输入；修复取消流式生成后前缀未进入后续/分叉；近 7 天未发现 loop 核心协议的已验证重大重构。
- **证据 URL/日期**：rc.8 Release 2026-08-19；`docs/architecture.md`、`packages/core/agent-loop/README.md`。
- **成熟度**：预览-中。
- **风险缺口**：Loop 本体虽强调最小化，外围 waterfall/plugin 顺序仍复杂；max-token、retry、取消恢复曾出现缺陷，需回归测试。

### 3.3 Model Adapter

- **当前能力快照**：抽象 `ctx.llm` seam；官方 DeepSeek 直连 chat-completions/SSE adapter 与 pi-ai adapter；支持 thinking/reasoning effort、retry、token meter、自定义 OpenAI-compatible gateway、多模态图像。
- **本期变化**：rc.8 原生图像请求与图像载荷治理；rc.1 新增 `DeepSeek-V4-Flash-Vision-Exp`；rc.2 Files API 优先、上传复用、自动缩放/转换，并修复 Files resolution fallback 与 files/stream timeout 解耦。
- **证据 URL/日期**：rc.8 2026-08-19；rc.1/rc.2 2026-08-21；相关 commits `d29855f…`、`1b38979…`、`d618bfe…`。
- **成熟度**：预览-中。
- **风险缺口**：实验视觉模型、provider 限额/Files 生命周期与大图预算增加复杂性；官方 adapter 默认上限很高（例如 raw image request 128 MiB、最多 600 图），部署需收紧；自定义网关兼容仍可能漂移。

### 3.4 Tool / Skill / Command / 协议

- **当前能力快照**：scoped tool registry + pre/execute/post guarded pipeline；文件、shell、terminal、web、LSP、MCP、skill、workflow、ask-user、Cordis 等工具；human command 独立于模型 Turn；协议包括 MCP、ACP、JSON-RPC/SDK gateway。
- **本期变化**：rc.8 `web_search` 并发查询、`@` 引用文件/会话、图文 command；rc.1 ask-user 多行；已检查未见 Skill/MCP 核心协议在本窗重大 breaking 变化。
- **证据 URL/日期**：rc.8、rc.1 Release；`docs/tool-execution-pipeline.md`、`docs/api-gateway.md`、package tree。
- **成熟度**：预览-中。
- **风险缺口**：工具参数虽有 schema 与 approval，但插件/协议桥会扩大权限面；ACP 曾有 default export 导致 inject 丢失的复盘，说明组合层错误可使服务在连接时崩溃。

### 3.5 Session / State / Storage

- **当前能力快照**：append-only `SessionEvent` 是唯一事实源；支持 fork/resume/replay/transcript；JSONL 与 opt-in SQLite persistence；storage-json/sqlite；projection/cache；崩溃后保留已提交事件并补 synthetic closers。
- **本期变化**：rc.8 SQLite 读写/分叉性能及体积优化，同时数据结构不兼容；近期稳定 persisted-turn coverage 和 projection state schema。
- **证据 URL/日期**：rc.8 2026-08-19；`session-persistence` 与 `session-persistence-sqlite` README（schema 17）。
- **成熟度**：JSONL 预览-中；SQLite 预览-低至中（opt-in、无迁移）。
- **风险缺口**：SQLite 无旧 schema 迁移；单库故障域；JSONL/SQLite 都需外部备份；Windows ACL 由部署方保障；Event schema 漂移可造成拒绝加载。

### 3.6 Context / Memory / Knowledge / Cache

- **当前能力快照**：系统 prompt sections、agent instructions、file/session/time/tmux context；basic compaction + tool-result pruner；session projection cache；provider KV/cache metrics；官方示例通过 MCP 接 Memorix/Engram/reference memory。
- **本期变化**：rc.8 文件/会话引用与大历史 fork 性能；rc.1 cache-hit 99.x% 精度；已检查近 7 天，未发现**内建长期语义记忆/知识库**的已验证重大新增。
- **证据 URL/日期**：rc.8/rc.1 Release；`examples/mcp-memory/*`；Discussion #14“求一个memory能力”（官方社区需求信号，非产品承诺）。
- **成熟度**：上下文/压缩预览-中；长期 Memory/Knowledge 预览-低（主要依赖 MCP 外挂）。
- **风险缺口**：缺少一等长期记忆治理（遗忘、来源、权限、去重、污染隔离）；projection cache 只是 fold shortcut，不是知识权威；compaction 可能损失细节。

### 3.7 Sandbox / Terminal / Browser / 权限

- **当前能力快照**：Linux bwrap/Landlock、macOS Seatbelt、Windows ACL restricted-token；Bash/PowerShell sandbox；PTY terminal；permission presets 将 sandbox 与 approval 组合；Web UI 本地默认 127.0.0.1:3080 并自动开浏览器。
- **本期变化**：rc.8 Windows PTY 持久 PowerShell；rc.1 修复 bwrap `/proc/<pid>/root` escape；近期权限 preset 变更曾合并后回滚（`7ce8528…`），显示默认语义仍活跃调整。
- **证据 URL/日期**：rc.8 2026-08-19、rc.1 2026-08-21；`docs/subsystems/sandbox.md`、permission presets；commit `fe12e04…`/PR #1798。
- **成熟度**：预览-中。
- **风险缺口**：文件 sandbox 不含网络/进程可见性；Windows/旧 Landlock partial；`danger-full-access + never` 无隔离无审批；浏览器功能主要是 Web UI 与 web fetch/search tool，并非已验证的完整 browser automation 隔离栈。

### 3.8 Subagent

- **当前能力快照**：统一 `ctx.subagents` seam；one-shot 与 continuable children；in-process/fork、SDK、ACP、Claude Code、Codex providers；支持 depth/tool/persona/schema、followup/interrupt/report、持久 lineage、children/descendants 查询、Job Panel。
- **本期变化**：rc.8 Codex/Claude Code 可作为按需 Profile Bundle，支持非交互权限与命名实例；`reportDelivery` 及时反馈并唤醒父任务；rc.1 优化子代理会话标题切换。
- **证据 URL/日期**：rc.8 2026-08-19；rc.1 2026-08-21；`packages/subagent/subagent/README.md`。
- **成熟度**：预览-中。
- **风险缺口**：权限继承、工具过滤、树状生命周期/冷恢复复杂；非交互模式增加误授权风险；外部代理能力/协议差异需单独审计。

### 3.9 Scheduling

- **当前能力快照**：Session-local durable reminders；`after_seconds`、绝对 `at`、>=5 分钟 fixed-rate `every_seconds`；显式 IANA/offset 时区；create/list/delete；基于 Session log 与 persistence，恢复后重建 timer。
- **本期变化**：已检查近 7 天 Release/commit，未发现已验证重大变化；功能在本月早期已落地。
- **证据 URL/日期**：`docs/subsystems/schedule.md`、`packages/schedule/schedule/README.md`（HEAD 2026-08-21）。
- **成熟度**：预览-中。
- **风险缺口**：只投递到原 live root Session；dispatch 表示已排队并记录，不保证模型成功或用户已读；依赖 persistence；无独立 receipt/跨节点 scheduler/SLA。

### 3.10 Web UI / CLI / Profile

- **当前能力快照**：`npx @deepseek-ai/dsh web`；本地 Web UI；headless；profile/bundle/patch；设置卡、模型/权限/skill/subagent/jobs/workflow/session UI；`--dump-config` 可查看实际树。
- **本期变化**：rc.7 插件自注册设置卡；rc.8 自动开浏览器、窄屏/侧栏/工作流/模型选择等优化；rc.1 Markdown 表格、问答输入与子代理导航改进。
- **证据 URL/日期**：README、rc.7—rc.1 Releases；`apps/cli`、`apps/web`。
- **成熟度**：预览-中。
- **风险缺口**：快速 UI 变更与 Safari/布局问题历史；本地 server 暴露/反向代理认证需部署方核验；Profile patch 的整行替换语义易产生配置漂移。

### 3.11 SDK / API

- **当前能力快照**：TypeScript protocol/client/server SDK；严格生成的 API gateway；Python SDK 与 bundled runtime；ACP/JSON-RPC 示例；支持程序化 create/resume/fork。
- **本期变化**：rc.8 Python SDK 依赖覆盖 4 个内建 Agent presets，并含 `rg`/glob 与 MCP stdio 依赖；已检查未发现 rc.1/rc.2 的 SDK breaking 声明。
- **证据 URL/日期**：rc.8 2026-08-19；`docs/api-gateway.md`、`packages/sdk/*`、`python/sdk/*`。
- **成熟度**：预览-中。
- **风险缺口**：协议/API 随 Developer Preview 可能 breaking；子进程 SDK 的 env 传递由调用者负责凭证清洗；跨版本 client/server 兼容矩阵未见稳定承诺。

### 3.12 Observability / Eval / Guardrails / 部署

- **当前能力快照**：session telemetry seam + OpenTelemetry backend；token meter、session stats、runtime invariants；guard 包含 repeat-tool reminder 与 timeout policy；大量 unit/e2e/snapshot/web perf/stress/coverage/CI gates；Web/headless/Profile 部署形态。
- **本期变化**：rc.1 cache 指标显示优化；近 7 天 CI release check、snapshot 稳定与失败路径覆盖增强；未发现产品级 eval dashboard/benchmark service 的已验证新增。
- **证据 URL/日期**：`docs/subsystems/session-telemetry.md`、`BENCHMARK.md`、package scripts、近期 commits。
- **成熟度**：可观测性预览-中；Eval/生产部署预览-低至中。
- **风险缺口**：telemetry redaction 可扩展但数据外发策略需部署方配置；OTel 后端负责排队/重试/丢失，Harness 边界止于 emit；缺少稳定 SLO、HA、分布式调度与正式生产安全基线；guardrails 更偏运行时防御，不等同模型安全评测体系。

## 4. PR / Issue / Discussion / Contributors 检查结果

- GitHub REST commits 与 releases/tags 已核验；仓库在截止时 GitHub metadata 报告 `open_issues_count=0`，Issues API 对 7 天窗口返回空数组。该字段含 PR 语义且可能受仓库迁移/镜像状态影响，不能据此声称“从未有问题”。
- Release 中可追溯 PR 包括 #2783（rc.8）、#2890（rc.1）、#2908（rc.2）、#1798（bwrap 安全修复）、#2676（图像管理策略）。
- Discussions 已检查；官方欢迎帖 #12 当前页面显示已删除，搜索快照曾显示“早期预览”措辞，但阶段结论以 README 为准。Discussion #14 反映长期 memory 需求，不能当 roadmap。
- Contributors API 已检查：领先贡献者包括 `tianyicui`、`LegGasai`、`imccyu`、`Chinesezjc`、`turtle1999`、`CreatixChu`、`kermanx` 等；贡献数是 GitHub 聚合指标，不用于质量判断。

## 5. 风险排序与采用建议

### P0 / 升级前必须处理

1. 若使用 SQLite，rc.8/schema 17 不兼容且无迁移：先离线备份、导出与恢复演练，再升级。
2. 所有使用 bwrap 的旧版本升级至至少 rc.1；同时验证 `/proc`、PID namespace 与 runner 实际 enforcement。
3. 禁止把 `danger-full-access + never` 作为无人值守默认；外部子代理非交互权限单独建最小权限 Profile。

### P1 / 生产试点必须补齐

1. 额外网络隔离（容器/microVM/远程执行 provider），因为内建 SandboxMode 不管网络。
2. OTel 出站脱敏、凭证清洗、日志保留与 Session 数据分类。
3. 固定 npm 精确版本和 integrity；RC 位于 latest，禁止无锁漂移。
4. 建立 JSONL/SQLite 备份、format/schema 升级闸门、fork/resume/cold recovery 回归。

### 采用判断

适合：开发者预览、受控代码 Agent 试验、插件/架构研究、隔离环境内的工作流验证。

暂不适合直接承诺：多租户强隔离、无人值守高权限生产执行、长期兼容 API、跨节点 HA scheduler、带正式 SLA 的企业平台。推荐以固定版本、隔离执行面、显式审批、外部审计日志进行小范围试点。

## 6. 主要一级来源

- 官方仓库：https://github.com/deepseek-ai/deepseek-harness
- README：https://github.com/deepseek-ai/deepseek-harness/blob/master/README.md
- 架构：https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/architecture.md
- Releases：https://github.com/deepseek-ai/deepseek-harness/releases
- Tags：https://github.com/deepseek-ai/deepseek-harness/tags
- Commits：https://github.com/deepseek-ai/deepseek-harness/commits/master
- npm dsh：https://www.npmjs.com/package/@deepseek-ai/dsh
- npm Cordis：https://www.npmjs.com/package/@deepseek-ai/cordis
- Cordis 官方：https://github.com/cordiverse/cordis
- Cordis 论文：https://github.com/cordiverse/paper

> 注：逐事实日期、SHA、证据类型与 URL 已结构化记录在 `A-evidence.tsv`。# DeepSeek Harness 插件生态与社区健康（B线）

> 抓取时间：2026-08-25 14:00–14:15（Asia/Shanghai；GitHub API 时间为 UTC）  
> 首次运行，无历史基线；生态观察窗为近30天（2026-07-27起），重点回溯近7天（2026-08-19起）。  
> 结论先行：**生态处于爆发式加速，但发现层已被 Topic 污染，数量不能等同于有效插件数；官方核心工程成熟度显著高于社区分发治理。** 本期没有 A 级社区插件，因为未在隔离环境完成“安全代码审查 + 最小安装测试”双门槛。

## 1. 口径、来源与分级

- 一级来源：`deepseek-ai/deepseek-harness` 源码、manifest、官方文档及 GitHub API；社区项目原始仓库、Release、npm registry 元数据；GitHub `dsh-plugin` Topic/API。
- GitHub 的 `watchers_count` 实际等于 stars；本报告另取 `subscribers_count` 作为“Watch/订阅”。contributors 为 API 当前页可见人数；达到100时记为 `≥100`。
- A：完成安全代码审查且隔离最小安装/启动测试通过；B：资料、测试、发布链较完整，但未完成上述双门槛；C：兼容、维护或供应链信息不足；D：高风险、误导、废弃或不建议使用。
- **禁止盲装**：GitHub 源安装可能执行 `prepare`，pnpm≥10 需显式 allowBuilds；这相当于在 agent sandbox 外授予安装时代码执行权。应固定 tag/commit，先审查 patch、install scripts、网络/文件/进程权限，再在空 profile 测试。

## 2. 官方仓库与内置生态全景

### 2.1 官方快照

| 字段 | 值 |
|---|---:|
| 仓库 | `deepseek-ai/deepseek-harness` |
| 当前根版本 | `0.1.1-rc.2` |
| 创建 / 最后 push | 2026-08-13 / 2026-08-21 12:35Z |
| Stars / Forks / Watch | 192,993 / 21,671 / 849 |
| Open issues | 0（仓库 Issues 未开启；不能解释为零缺陷） |
| License / 主语言 | MIT / TypeScript |
| 近30天 commits / 作者身份 | 7,200（本地完整浅深度100克隆可见）/ 49 |
| 近7天 commits / 作者身份 | 234 / 24 |
| 近7天 releases | 4：rc.7、rc.8、rc.1、rc.2（8/17–8/21，其中观察窗内3个） |
| GitHub API contributors | 当前页100（分页存在，故记 `≥100`） |

注：GitHub Search 对官方仓库返回 commits 近30天 7,513、近7天 289，与 clone 的可达提交统计不同；原因可能是 Search 索引计数与当前分支可达提交口径不同。本报告保留两组原始证据，不混算。

### 2.2 Profile Bundle 与插件类别覆盖

官方 Bundle 契约是 npm manifest 中的 `dsh.bundle.patch`；Profile 位于 `$DSH_HOME/profiles/<name>`，按序叠加 bundles。内置三个主 bundle：

1. `@deepseek-ai/dsh-base`：所有 profile 的共享核心。
2. `@deepseek-ai/dsh-web-app`：浏览器 UI、Host/API、动态 client 插件与 Web runtime。
3. `@deepseek-ai/dsh-headless`：无 Host/HTTP/Browser 的一次性任务模式。

| 类别 | 官方内置代表 | 状态与观察 |
|---|---|---|
| 模型 | `dsh-llm`, `llm-deepseek`, `llm-pi-ai`, `llm-retry`, token-meter | 默认 `deepseek-official/deepseek-v4-flash`；设置热更新。多供应商 twin 默认无路由，需用户配置。 |
| 工具 | tools、bash/pwsh、fs/read-write-search、todo、goal、subagent、workflow、web | 原生工具面广；权限由 sandbox + approval 组合。Code Mode 仍由临时进程级 `DSH_TOOLS_MODE` 控制。 |
| Skill | skill registry、filesystem provider、tool-skill、badge | 本地文件 Skill 已内置；badge 默认关闭。 |
| Session | event-sourced session、JSONL persistence、projection、query、title、checkpoint、stats/reference/export | 完整度高；全文检索默认 `openAt: never`，避免默认打开 SQLite。 |
| Storage | storage hub、JSON、SQLite、domain；attachment/spill | Web 默认 JSON domain storage；session 默认 JSONL，SQLite 有可替换实现。 |
| Memory | **无官方独立长期记忆插件** | session history/query/compaction 不等于跨会话语义记忆；这是明确生态缺口。 |
| Sandbox | local + policy + Linux Landlock/bwrap、macOS Seatbelt、Windows ACL restricted token | fail-closed 设计；默认 workspace-write + ask。社区插件若自行直接访问 Node/OS API，仍需单独审计。 |
| Browser | Web UI 与匿名 HTTP fetch/search | **未发现官方浏览器自动化/Playwright 工具**；`web` 是 HTTP search/fetch seam，不等同浏览器控制。 |
| UI | 大量 `dsh-client-ui-*`：conversation、settings、plugins、trajectory、model、skill、subagent 等 | 插件化程度高；client 注入接口仍随 RC 快速演进。 |
| Loop | agent-loop、repeat-tool-reminder、goal-round-driver、Ralph/workflow | 有防重复与 timeout policy；复杂自演化社区插件仍属高风险。 |
| Scheduling | `dsh-schedule`、jobs-local/tool-jobs | durable after/at/fixed-rate reminder 已有包，但 base bundle 默认主要挂 jobs，schedule 是否启用取决 profile。 |
| Observability | session telemetry + OTel、trajectory UI、stats、invariants | Telemetry 默认 DISABLED；启用后配置注释明确说明导出原始捕获副本，需评估隐私和 OTLP 端点。 |

### 2.3 官方工程健康与风险

**优势**：MIT；Node `^22.19 || >=24`；完整 build/typecheck/lint/test/e2e/snapshot/perf/stress/Windows gate；包级 README/测试广泛；发布包有统一版本；profile layering、HMR cleanup、schema validation、dependency injection 与权限模型文档充分。

**风险/限制**：仍是 RC；仓库公开仅约12天却暴露超大历史与极高 stars，增长异常快，不能把热度当稳定性；Issues 未开启削弱公开缺陷可见性；Web client 契约快速变化；telemetry 虽默认关闭但启用后可能上传原始会话记录；Git source 插件安装的 `prepare` 在 sandbox 外执行。

## 3. 重点社区插件核验

### 3.1 评级汇总与优秀插件 TOP

**优秀 TOP（宁缺毋滥，仅3项，均为 B）**

1. **dsh-plugin-bridge（B）**：边界清晰、兼容表、测试/构建/pack smoke、npm provenance 齐全；主要风险是跨 preset/session 状态读取与 RC client 契约。
2. **dsh-vision-router（B）**：测试量最大、版本/Node约束明确、npm provenance；但权限和外部数据面很大（匿名远端视觉、截图、HTTP provider、Puppeteer），必须审查后再试。
3. **dsh-web 单项包（B）**：活跃、显式 `dsh.engines >=0.1.1-rc.1`、文档和测试充分；**仅推荐按需单项安装，不推荐聚合包 `dsh-web-all`**。

| 插件 | 类别/解决问题 | 仓库/包/维护者 | 版本、发布、最后 commit | 安装依赖与声明兼容 | GitHub 指标（star/fork/watch/contrib/issues） | 权限/供应链、文档测试License | 状态、替代与级别 |
|---|---|---|---|---|---|---|---|
| dsh-plugin-bridge | Session；跨 preset 可预览迁移，保留状态与模型意图 | Totoro-qaq/dsh-plugin-bridge；npm `dsh-plugin-bridge`；npm maintainer totoro1017 | 0.2.11；2026-08-24；commit `5a4550b` 2026-08-25 06:00Z | Node≥22；schemastery；README兼容表含 dsh 0.1.0-rc.6，当前包未声明 `dsh.engines` | 127/6/8/2/1 | 读写会话迁移数据；npm integrity+provenance；MIT；13 test/spec，verify含 build/typecheck/dataset/package smoke | 活跃；替代：官方 session-reference/export + 手工新会话；**B** |
| dsh-vision-router | 模型/工具/Browser边缘；为文本模型补视觉、OCR、截图/像素工具 | ysr666/dsh-vision-router；npm同名；maintainer ysr182 | 1.7.7；2026-08-22；commit `87c8df5` 2026-08-25 05:54Z | Node `^22.19 || >=24`；schemastery、potrace、puppeteer-core、undici；未声明 `dsh.engines`，README称rc6/rc7兼容 | 965/42/1/5/5 | 可上传图片至远端、截图（默认关）、网络访问、自更新面；npm provenance；MIT；131 test/spec、详细中英README | 活跃；替代：官方原生图像能力或 dsh-web describe-image；**B** |
| dsh-web（建议单项） | UI/工具/Skill/remote/SSH/doctor 等插件集合 | zhu1090093659/dsh-web；多个 `@linxin666/*` npm包；maintainer linxin666 | repo release 0.3.3，2026-08-24；commit `deb45af` 2026-08-25 06:00Z | 单项多声明 Node `^22.19 || >=24`、`dsh >=0.1.1-rc.1`；聚合包依赖19个包 | 5,979/382/7/≥100/9 | 单项权限差异巨大：SSH/远程隧道/文件写/doctor均高权；Apache/BSD/MIT混合；362 test/spec；npm聚合包无 provenance 字段 | 高速活跃；替代：官方UI或只装所需单项；单项 **B**，聚合 **C** |
| dsh-mcp-connector | 工具/集成；MCP连接、OAuth/PKCE、API key、stdio/HTTP、市场 | duhu2000/dsh-mcp-connector；npm同名；duhu2000（仓库称QCC团队发起） | 0.2.20；2026-08-25；commit `4bdc189` 05:39Z | Node≥20；零 runtime deps；未声明 `dsh.engines` | 6/2/0/2/0 | 可启动stdio进程、访问任意MCP HTTP、持有OAuth/API key；npm provenance；MIT；16 test/spec，prepublish gate | 很新、发版过密；替代：官方 `dsh-mcp-client`；**C**（首选官方替代） |
| dsh-memory-connect | Memory/Scheduling；跨会话提取、召回、LLM合并 | Asher-2000/dsh-memory-connect；**npm 404，仅GitHub**；仓库owner维护 | 0.4.1；2026-08-25；commit `41d71fd` 05:54Z | schemastery；README声称在 dsh 0.1.1-rc.2/Node24 E2E；manifest未声明 engines/dsh | 2/0/0/4/0 | 读全部会话并把召回注入系统提示、SQLite `~/.dsh/memory.db`、定时维护；Git安装可能涉及构建信任；MIT；4 test/spec | 新且缺独立验证；替代：官方 session-query/reference（非语义记忆）；**C** |
| OpenDesign DSH runtime | Skill/UI/工具；设计工作流、桌面端、导出 | nexu-io/open-design；内部 `@open-design/dsh-runtime` **npm 404**；大型多维护者项目 | repo 0.20.3（Release最新0.20.2，8/21）；commit `9989c75` 8/25 04:46Z | Node~24/pnpm10；DSH runtime依赖固定 rc.2；无独立注册表包 | 91,180/10,504/274/≥100/848 | install.sh、postinstall、进程/MCP、文件、BYOK网络、渲染导出，权限面最大；Apache-2.0；2069 test/spec、文档很强 | 活跃但不是轻量插件；替代：独立运行后以MCP连接；**C**（不建议直接脚本安装） |
| DeepSeek Harness Desktop (Tauri) | UI/Desktop；捆绑runtime和插件 | dsh-tauri-desk/deepseek-harness-desktop；无核验npm包；9 contributors | 0.8.1-beta.1，2026-08-25；commit `03222fe` 05:59Z | 桌面安装器；package无 dsh兼容声明 | 1,130/69/6/9/9 | 捆绑二进制/runtime与自动更新，供应链/签名需平台核验；MIT；41 test/spec | 高频beta；替代：官方 `dsh web` 本地运行；**C** |

**未给 D 级**：本期重点样本中未发现可由一级来源坐实的恶意/废弃项目；但 GitHub Topic 中大量仅贴标签、与 DSH 关系弱的项目不进入评级，也绝不能据 Topic 自动安装。

## 4. 社区健康与30天/7天动态

### 4.1 发现层规模与污染

| 指标 | 近30天 | 近7天 | 解读 |
|---|---:|---:|---|
| `topic:dsh-plugin` 当前总仓库 | 11,432 | — | 数量异常大，明显包含搭标签蹭热度、通用项目与插件目录镜像。 |
| 新建且带 Topic | 11,116 | 3,625 | 97%在30天内创建；7天仍约518个/日，不是可信“有效插件”口径。 |
| 近7天 push 活跃 | — | 6,631 | Topic 生态表面极热，但需 manifest/兼容/源码门禁去重。 |
| 本期API结果前100样本 | — | 100 | 混有 OpenViking、通用 agent OS、dotfiles 等非原生 DSH 插件，证明 Topic 精度低。 |

**趋势判断：加速（热度与供给），但治理质量滞后。** 证据是新仓库与push量爆发、重点插件高频发布、官方短期多RC；反证是 Topic 污染、很多包无 `dsh.engines`、单维护者、聚合包权限膨胀、release cadence 快于成熟验证。首次运行没有历史基线，因此不能计算环比，结论仅基于窗口内速度与结构。

### 4.2 活跃、首次/外部贡献、停止插件

- 官方当前分支近30天49个作者身份，近7天24个；按邮箱粗分可见多位非 `@deepseek.com` 作者（如社区 noreply、qq/outlook/sina 等），说明存在外部贡献，但邮箱身份可能重复，不能当唯一人数。
- GitHub Contributors API 至少100名；前100已经截顶。公开 Issues/PR 统计为0，原因是官方仓库 `has_issues=false`，不能据此判断响应速度、合并率或首次贡献者数量。
- 重点社区项目近7天均有 commit/release；dsh-web 与 vision-router contributors 已分别达到≥100、5；Bridge 2；MCP connector 2；Memory 4；Desktop 9。
- **首次贡献者**：官方未提供可核验的一等事件流/PR列表，commit身份又有同人多邮箱，故本期记“不可可靠统计”。
- **新增插件**：Topic近7天新建3,625个，但有效插件需二次门禁；重点样本中 MCP connector（8/20）与 memory-connect（8/19）是新项目。
- **停止插件**：观察窗仅7–30天且生态本身刚公开，无法可靠判定停止维护；本期不列“停止”名单。

### 4.3 教程、SDK、模板与集成

- 官方教程覆盖 first plugin、配置schema、tool、发布bundle/profile、Cordis生命周期/HMR；明确 npm、tarball、GitHub安装与 `prepare/allowBuilds` 风险。
- 官方 SDK：TypeScript client/protocol/JSON-RPC server、Python SDK测试、ACP server/demo、headless/jsonrpc示例。
- 模板：dsh-web 提供 `scripts/plugin-template`；官方仓库提供 examples、cookbook 与 package invariants，但未发现官方集中式、签名/审核插件市场。
- 集成：官方 MCP client、Claude Code/Codex hooks与subagent、ACP；社区快速扩展到视觉、桌面、飞书、远程UI、MCP市场、记忆与设计。

## 5. 安全采用建议

1. **默认只用官方内置**；优先官方 `dsh-mcp-client`、session/query/reference、Web UI，只有明确缺口才引入社区包。
2. 建立准入门：仓库归属与npm maintainer一致、固定version+integrity/commit、检查 `dsh.bundle.patch`、`prepare/postinstall`、网络目标、secret存储、文件/进程/截图权限、license、测试和卸载路径。
3. 用全新 profile、空 workspace、假凭据、loopback网络与最低权限执行 `--dump-config` 后再启动；不在生产 `$DSH_HOME` 上首测。
4. 聚合包拆装；尤其 SSH、远程隧道、桌面捆绑runtime、视觉上传、Memory全会话读取、MCP任意server 等高权能力应一项一审。
5. 对 Topic 建立结构化过滤：必须有 `dsh.bundle`、版本兼容声明、license、可复现release、测试、最近commit、明确权限清单；仅有 `dsh-plugin` 标签不计入有效生态。

## 6. 本期结论

- **官方核心：健康、快速迭代，但仍为RC。** 架构覆盖模型/工具/Skill/Session/Storage/Sandbox/UI/Loop/Scheduling/Observability，长期Memory与浏览器自动化是主要缺口。
- **社区：加速但高噪声。** 有少量工程质量不错的插件，但发现层的11,432仓库数字严重失真。
- **推荐名单：Bridge、Vision Router、dsh-web单项包，均B级。** 没有任何项目达到A；MCP connector应优先用官方替代，Memory/Desktop/OpenDesign建议隔离评估或以外部服务方式集成。
- 下期基线应保存 Topic有效插件去重数、重点项目star/fork/watch/release/commit/issue变化、兼容声明覆盖率、npm provenance覆盖率和首次贡献者事件，以便真正判断加速/平稳/降温。
# DeepSeek Harness 全景报告 C线：案例、反馈、持续问题、安全、竞品与机会

**观察时点**：2026-08-25 14:00（Asia/Shanghai）  
**首期、无基线**；案例/生态重点近30天，补漏窗 2026-08-18 14:00 起。  
**证据口径**：优先官方仓库、官方文档、发布说明、作者仓库与可复现报告。项目仅于 2026-08-13 建仓，绝大多数“案例”仍是作者自述或社区 Demo，**未找到可独立核验的 P1 生产案例**。

## 0. 结论先行

- **定位**：DeepSeek Harness（dsh）不是单一 coding CLI，而是 Cordis 驱动的可重组 agent runtime；模型、工具、skills、session、sandbox、storage、loop、schedule、UI 都可替换。它最有差异化的不是“会写代码”，而是**把整个 harness 拆成插件和 capability seams**。
- **成熟度**：官方明确为 developer preview，警告会有 breaking changes；截至观察时点最新为 `v0.1.1-rc.2` 预发布。首发约12天即形成大量插件/Demo，但生产、企业治理、行业落地证据不足。
- **最强可验证场景**：本地 coding/research harness、MCP/ACP、Claude Code/Codex 子代理编排、会话导出、可观测插件拓扑、多 agent 消息网络。
- **最大风险**：Web 控制面缺少认证、approval 回环自批准、Code Mode worker 未进入文件沙箱等报告涉及核心权限边界；另有插件 ABI 双份依赖导致 turn 崩溃并永久污染会话、Windows sandbox 兼容、长输出阻塞事件循环、SQLite 升降级失败进程退出等持续问题。
- **建议**：可立即在隔离机器/测试仓库体验 native 模式；**暂不把 Web UI 暴露到 LAN/公网，不在敏感宿主启用 Code Mode，不把社区插件直接装入生产 profile**。商业机会优先做企业 profile 签名/锁定、插件 ABI 验证、可恢复启动、安全审计、会话修复与评测观测层。

## 1. 项目与能力基线

- 官方 README：`npx @deepseek-ai/dsh web`，本地默认 `127.0.0.1:3080`；从源码需 Node.js、pnpm install/build。MIT。
- 官方架构：Cordis plugin tree；profile 叠加 bundle + patch；session 是 append-only event log，支持 fork/resume/transcript/telemetry；FS/subprocess 共用 execution world，可整体切换到远端 sandbox；subagent provider 可替换。
- 内置证据可见：SQLite/JSONL session persistence、OpenTelemetry session telemetry、MCP client、ACP、E2B、jobs、schedule、goals/plans、LSP、persistent terminal、Claude Code/Codex hooks 与 subagent bundles、实验 Agent Teams。
- 生态速度：GitHub API 在 2026-08-25 06:01Z 返回约 192,993 stars / 21,671 forks；这是热度而非采用或质量证明。

## 2. 案例地图（严格 P1–P5）

### 分级定义

- **P1 生产**：真实业务、持续运行、使用方与指标可核验。
- **P2 公开试点**：真实使用方公开试点，有范围/运行证据但尚无生产 SLA。
- **P3 可复现 Demo**：源码、安装步骤或测试可复现。
- **P4 概念**：提案、路线图或局部原型。
- **P5 未验证**：宣传/二手说法，无可核验实现。

| 等级 | 使用者/案例 | 问题与架构/插件 | 复现条件 | 成本/性能/稳定/安全 | 优势、限制、商业化距离 |
|---|---|---|---|---|---|
| P3 | **官方本地 Web coding/research harness** | `dsh web`；Cordis profile + model/tool/session/sandbox/UI plugins；可用 DeepSeek/兼容模型、bash/fs/LSP/MCP | Node.js；`npx @deepseek-ai/dsh web`；模型凭据；仅 loopback | 软件 MIT；推理成本随模型；RC breaking changes；Web 控制面与 sandbox 风险见第4节 | 最快体验“全插件”；仍是开发者预览，离企业生产至少缺认证、治理、稳定 SLA |
| P3 | **Claude Code / Codex 作为 dsh 子代理** | rc.8 起可作为 Profile Bundle 安装；支持多个命名实例、非交互权限模式、Job Panel、父任务唤醒 | 安装对应 CLI/认证与 bundle；创建需委派的 coding task | 同时承担 dsh + 外部 agent 模型/订阅成本；权限边界叠加；会话/工具 ABI需测 | 直接复用强 coding agent，dsh 做上层编排；商业化可落在统一治理/成本路由，但目前没有企业案例 |
| P3 | **MCP/ACP 互操作** | 官方 MCP client、ACP bridge；rc.7 持久化图片附件，PTC 可转发嵌套图片；Python SDK runtime 带 MCP stdio 依赖 | 配置 MCP server 或 ACP agent；验证图片/工具 round-trip | 外部 server 可卡死分页/处置（重复 cursor 无上限的审计报告）；供应链/凭据风险 | 标准协议降低迁移成本；需要 server allowlist、timeout、审计后才适合企业 |
| P3 | **ACN 跨实例多 agent 协作** | 社区 `dsh-plugin-acn`：join、能力搜索、消息、inbox；MIT | `dsh plugin --profile web add github:acnlabs/dsh-plugin-acn`，重启 | 作者自述，无规模、延迟、鉴权、滥用/隐私指标 | 证明第三方可扩展跨实例网络；仅 Demo，距商业化需身份、租户、审计、可靠投递 |
| P3 | **会话导出/报告交付** | `dsh-session-export`：Markdown/JSON/自包含 HTML，含 tool calls/reasoning/metadata；零 runtime deps | 安装插件并加入 profile patch；执行 `/export-*` | 本地导出成本低；导出 reasoning/工具参数可能泄露敏感信息 | 适合研究报告、审计附件、交付归档；需脱敏、访问控制、签名与保留策略 |
| P3 | **插件依赖拓扑/运行观测** | `dsh-contrib-topology`：读取 loader entries，展示 plugin/service/dependency/fiber state SVG | 源码集成；作者说明第三方 Host Remote 需改中央 assembly/web roster | 暴露运行拓扑；Windows 全量并行 build 可能遇杀软锁文件 | 很适合运维诊断；同时暴露现有扩展契约摩擦，商业化需要无核心改动的动态 extension API |
| P3 | **自动审批辅助 dsh-autogate** | L0规则 + L1 LLM classifier + L2人类；approval trail；fail-closed；workspace-write 保留 | GitHub plugin 安装；配置 classifier endpoint/model | 增加模型调用、8s 默认 timeout；作者明确它不是安全边界，full-auto 有误判风险 | 降低审批疲劳且有决策轨迹；需安全评测、策略签名和集中治理才可企业化 |
| P3 | **Pi 生态桥 pi2dsh** | 作为 Host ABI 挂载兼容 Pi package；复用 dsh LLM/MCP/credentials/sessions；Pi subagent 成为 dsh child | 安装 `pi2dsh` + 兼容 Pi 包；作者称已跑真实 loops | 插件兼容矩阵复杂；二套 ABI/依赖冲突风险高 | 显著扩大生态，适合做迁移层；需官方契约与 conformance suite |
| P4 | **实验 Agent Teams** | 私有 opt-in seam：durable roster、task board、mailbox、continuable subagents | 阅读/启用 experimental bundle，需自行验证 | 官方标为 experimental；无公开规模/稳定数据 | 可做多 agent 项目管理；当前不应对外承诺生产 |
| P4 | **Browser / Computer Use** | 未找到官方一等 browser/computer-use provider 的可靠使用案例；可经 MCP/外部子代理接入 | 自带浏览器 MCP 或 Claude Code/Codex 等外部能力 | 浏览器会扩大凭据、会话与 prompt injection 面 | 是明显生态缺口与机会，当前不能宣称 dsh 原生成熟 |
| P4 | **企业工作流、数据报告、本地助手、垂直行业/私有化** | 组件上可拼（schedule/jobs/session/OTel/MCP/profile），但未找到真实企业或行业使用方证据 | 需要自建插件、身份、策略、部署与运维 | 没有 SLA/TCO/并发/租户/合规数据 | 架构潜力大，商业化距离较远；先做平台治理，再谈行业方案 |
| P5 | 网络文章/视频声称“已改变AI”“生产爆发”等 | 二手热度与 star 数推断采用 | 不可复现 | 无真实业务、成本、性能和故障数据 | 不纳入决策证据 |

**案例不足说明**：扫描范围内没有达到 P1 的案例；P2 也缺乏能由真实使用方独立确认的持续试点。现阶段合理表述是“生态爆发中的可复现开发者平台”，不是“已验证的企业 agent 平台”。

## 3. 用户反馈与持续问题表

仓库关闭 Issues/PR，官方引导 Discussions；因此“open issue count=0”不表示没有问题。下表以 Discussions、发布修复和源码审计为持续跟踪入口。

| 类别 | 证据/现象 | 影响 | 当前状态/缓解 | 下期动作 |
|---|---|---|---|---|
| 安装/依赖 | Windows `npx` 原生包/构建工具问题；Ubuntu 用户误在 git checkout 跑 npm；官方仍是 RC | 首次体验失败 | 文档与清缓存/平台包 workaround；rc.8 减下载体积 | 干净 Win/macOS/Linux 安装矩阵，记录时间/下载量/失败率 |
| 插件 ABI/供应链 | Discussion #1337：profile 中第二份 `@deepseek-ai/dsh-tools` Symbol 不同，首个 tool call 崩；随后 dangling tool_calls 使会话永久不可续 | 插件冲突→turn 崩溃、数据逻辑损坏 | 禁用社区插件可恢复新会话；缺 load-time ABI guard/安全模式 | 做 lockfile/ABI attestation、quarantine startup、会话修复器 |
| 升级/迁移 | rc.8 SQLite 读写/分叉优化但**存储格式不兼容**；审计称 schema mismatch 可触发未处理 rejection 进程退出 | 升降级失败、无法回滚 | 发布说明有警告，但未见公开迁移/回滚工具证据 | 测 rc.7↔rc.8 备份、迁移、回滚、损坏注入 |
| 长会话 | rc.7 修复大历史分页 stack overflow、max-token 截断续会；rc.8 改进大历史 fork | 长会话卡死/不可续 | 已有修复，缺规模基准 | 10k/100k events、图片累积、fork/resume P50/P95 |
| 性能/事件循环 | #3251：persistent terminal 长行输出对每个 chunk 扫描4MiB buffer，5MB 可阻塞超1分钟；另有后台进程永久15ms轮询 | 全局 streaming/timer/abort 停摆、并发劣化 | 有作者 patch 建议，无可靠合入证据 | 基准 1/10/100MB 长行，多会话并发与取消延迟 |
| 工具结果一致性 | #3251：max-token 后工具执行但结果未被下一模型请求消费；auto-compaction 同步轮可能丢 runtime context | 有副作用无最终解释；模型不知道 sandbox/approval | 源码审计，高置信但需官方修复状态 | 建回归用例：truncate→tool→final；compact→runtime context |
| MCP | #3251：外部 MCP 重复 `nextCursor` 无检测/页上限，dispose 可永久挂；SSE截断重试语义不一致 | 恶意/坏 server DoS、关停卡住 | 未见修复证据 | fake MCP constant cursor；timeout/page cap；断流重试 |
| 跨OS | #1613：Windows restricted token 与 Cygwin/MSYS 初始化冲突；Node on alternate drive 未完全复现；rc.7 升 node-pty、rc.8 加 persistent PowerShell | 默认 workspace-write 下 grep/Git Bash 等不可用 | 可用 native Win32 shell 或 danger-full-access（后者不推荐）；诊断 patch另行 | Win11 Git/Node C:/D:、PowerShell、MSYS、WSL2 matrix |
| 临时目录/路径 | 搜索到 Windows `%TEMP%` fs fence 与 ACL 不一致、Linux `/tmp` root rebind 报告 | 越界写或误拒绝 | 需逐条复现，不将搜索摘要当定论 | 复现 #3903/#278，验证最新版与 inode/realpath策略 |
| 进程/数据丢失 | #3251：SDK stdout EPIPE 可进程致命，中断 dispose、截断 JSONL、遗留子进程；spill temp 不清理 | 崩溃、日志截断、磁盘泄漏 | 有明确 fix 建议，未见合入证据 | kill client/断管测试、fsync/checkpoint/recovery、磁盘上限 |
| 图片/兼容网关 | rc.8 修复超大/累计图片请求失败、OpenAI compatible request差异与 reasoning缺失；rc.2 Files API复用与预处理 | 多模态长会话失败、兼容性差 | 最近版本持续修复 | 10/100图、不同格式/尺寸、自建网关契约测试 |
| 浏览器/Safari UI | rc.7 修 Safari composer cursor错位；rc.8 多处窄屏/侧栏/文件打开修复 | 前端交互问题 | 已修但缺回归范围 | Safari/Chrome/Firefox + mobile viewport |
| 可观测性 | 内置 OTel session telemetry、stats、trajectory UI；社区 topology/autogate trail | 有组件，无公开 SLO/eval/告警方案 | 需自己拼装 | 定义 trace schema、token/cost/tool failure、eval dataset |

## 4. 安全风险（按处置优先级）

> 这些是公开报告与代码/动态复现证据，不等同于官方 CVE。由于仓库无 Issues 且报告时称无 SECURITY.md/私密漏洞入口，修复状态必须逐版本实测。

### S0：立即隔离

1. **Web 控制面无认证 / 本地或远程 RCE（#853，验证 rc.6）**  
   报告称 `/api` 60+ RPC、events mux、approval respond、session export 无 token/cookie/TLS；Host/Origin fence 明示不是 auth。任一本地进程可操控 agent；若被错误绑定非 loopback，可能远程利用。  
   **措施**：仅 loopback；不暴露 LAN/公网；远程必须认证 TLS reverse proxy；独立 OS 用户/VM；验证最新版是否已加 auth。

2. **approval 回环自批准（#250，master 动态组合复现）**  
   workspace-write child 网络未隔离，且获知 `DSH_WEB_URL`；可订阅 pending approval 并 POST `allowed-once`，将一次调用提升到 `danger-full-access`。  
   **措施**：把 human approval 绑定到独立认证 UI principal/capability；模型进程不能读取；默认禁用 background shell 或阻断其访问 control plane仅属防御纵深。

3. **Code Mode `run_code` worker 未受 sandbox（#3245）**  
   报告称 worker thread 以 `new AsyncFunction` 执行模型 TypeScript，虽 `env:{}` 与资源限制，但可 dynamic import `node:fs`/`child_process`，未进入 Landlock/bwrap/Seatbelt。触发需 `DSH_TOOLS_MODE=code|both`。  
   **措施**：敏感环境禁用 Code Mode；把 runtime 放独立容器/进程并施加同一 sandbox；建立读写工作区外与 child_process 回归测试。

### S1：发布前必须解决

- **Bubblewrap `/proc/<pid>/root` 绕过**：官方 rc.1 发布说明明确已修；说明 sandbox 曾有可利用逃逸，需对固定版本做安全回归。
- **插件供应链/ABI**：社区 GitHub 包直接进入 profile，可带宿主权限；缺签名、allowlist、版本锁与 load-time ABI guard；第二份 runtime 已实证可崩溃并污染会话。
- **网络/凭据**：官方 sandbox 文档口径只约束 file effects，不约束 network/process visibility/credential；MCP、网页内容、社区插件可成为注入与外传通道。
- **会话导出与 telemetry**：工具参数、reasoning、session logs、OTel 可能含密钥/PII；必须脱敏、加密、RBAC、保留/删除策略。
- **Windows 为兼容切 danger-full-access**：常见 workaround 实际取消安全边界，不可作为企业默认。

## 5. 固定竞品对照（只写有可靠证据者）

记号：**强**=官方一等能力且证据明确；**有**=存在但范围/成熟度有限；**弱/未证**=本轮未找到可靠一等证据，不代表绝对不存在。

| 维度 | DeepSeek Harness | OpenClaw | Claude Code | Codex | OpenCode | Gemini CLI |
|---|---|---|---|---|---|---|
| 插件/扩展 | **强**：所有能力插件化、profile/bundle/patch | **强**：tools/skills/plugins、channel/gateway生态 | **强**：plugins打包 skills/hooks/agents/commands/MCP | **强**：skills、MCP、lifecycle hooks/plugin bundles（部分企业支持仍演进） | **强**：事件 hooks 插件、生态目录 | **强**：extensions、tools、MCP |
| runtime/session | append-only event log、fork/resume、JSONL/SQLite，**强但RC迁移风险** | 长驻 gateway、多渠道 session，强 | 交互 coding session/SDK，强 | CLI/IDE/desktop/cloud统一 coding session，强 | client/server + session，强 | CLI session/checkpoint，强 |
| sandbox | Landlock/bwrap/Seatbelt/Windows ACL seam；**安全报告严峻** | 可配 sandbox/host工具边界；官方安全审计明确漂移检查 | permissions + sandbox + managed settings | **强**：平台原生 sandbox，文件+网络与 approval分离，规则/auto-review | permissions有；硬隔离/企业强制证据弱 | sandbox + policy engine；近期 Windows/subagent加强 |
| browser/computer use | **弱/未证**：主要经 MCP/外部 agent | **强**：托管/用户浏览器、节点，官方安全文档单列browser exposure | web/browser能力依环境/MCP；非核心 computer-use CLI证据有限 | web/cloud/desktop能力强，但本轮未核到通用本地 browser automation插件面 | 主要经 MCP/插件 | Google Search/web fetch与MCP；通用 browser automation需扩展 |
| MCP | 官方 client，强 | MCP工具可纳入 sandbox policy | 官方一等能力 | 官方一等能力且审批政策覆盖MCP | 官方一等能力 | 官方一等能力且企业配置可管 |
| subagent | provider seam；Claude/Codex bundle；Agent Teams experimental | sessions_spawn/team orchestration，强 | 官方 subagents/Agent SDK，强 | 官方多agent/subagents能力，强 | primary/subagent权限模型 | 官方 subagents，强 |
| memory | session log/reference/compaction；跨会话 memory 主要插件 | 文件记忆+索引/插件，强 | CLAUDE.md、auto memory等，强 | instructions/skills/session，长期memory口径需谨慎 | AGENTS/instructions/生态memory | GEMINI.md/context/checkpoint；长期memory能力演进中 |
| scheduling | 官方 schedule/jobs seam | **强**：cron/reminders/long-running gateway | hooks/CI/SDK可调度，CLI内建持续scheduler弱 | cloud tasks/automations能力强，本地CLI scheduler非核心 | 生态 background agents，内建scheduler未证 | CLI/headless/CI；内建持续scheduler未证 |
| 安全审计 | OTel/approval trail可拼；**无成熟统一 audit CLI证据** | **强**：`openclaw security audit --deep/--fix/--json`，威胁模型明确 | managed settings、permissions/hooks/telemetry，企业成熟 | sandbox/approvals/rules/企业策略，强 | permission config；企业审计弱 | **强**：system overrides、policy engine、禁YOLO、企业文档 |
| observability/eval | OTel、stats、trajectory；无公开 eval/SLO | tracing/logs/usage生态；eval需自建 | telemetry/hooks/平台监控；强 | 平台 traces/evals/usage能力强 | hooks可观测；eval弱 | OpenTelemetry GenAI metrics、日志；强 |
| 企业治理 | **弱**：无租户/RBAC/SSO/签名插件/SLA证据 | 明确单信任边界；多租户需隔离 gateway cell | **强**：managed settings/MDM/console | **强**：组织策略、云执行；plugin enterprise仍演进 | **弱**：开源灵活但集中治理证据少 | **强**：system default/override、工具/MCP政策 |
| 生态成熟 | 12天高速增长，Demo密集但ABI不稳 | 多渠道/技能/插件与运维生态成熟 | coding生态最成熟之一 | coding平台与云生态成熟 | 开源 provider/插件生态成熟 | Google生态、开源CLI、企业渠道成熟 |

### 竞争判断

- 对 **Claude Code/Codex**：dsh 不应正面比 coding intelligence；应做“可替换模型 + 多 agent runtime + 统一会话/治理/观测”，并把二者当 subagent。
- 对 **OpenClaw**：dsh 的 Cordis 组合与 capability seams 更“框架化”；OpenClaw 在长驻渠道、浏览器/设备、定时任务、安全审计和运维经验更成熟。两者最佳关系是互补而非替代。
- 对 **OpenCode**：均强调开放/多模型/插件；dsh 更彻底拆 runtime，OpenCode 的 coding UX 与生态更稳。dsh 必须先解决 ABI、迁移和安全边界。
- 对 **Gemini CLI**：Gemini 的企业系统级覆盖、policy engine 与 Google云/搜索生态更强；dsh 优势是模型中立和任意 capability replacement。

## 6. 建议组合

### 6.1 立即体验（仅隔离环境）

1. 固定 `dsh-v0.1.1-rc.2`，使用测试仓库、低权限 OS 用户、loopback Web、native tool mode、workspace-write。
2. 先不装社区插件；完成 coding、research、MCP、session fork/export、SQLite备份恢复基线。
3. 再逐一装插件，每次锁版本、保存 profile/lockfile、跑工具与会话一致性回归。

### 6.2 建议做的 3 个 Demo

#### Demo A：Claude Code + Codex 双子代理的代码审查仲裁
- **目标**：dsh 主 agent 拆任务，两子代理独立 review，主 agent 汇总差异。
- **步骤**：固定小型开源 repo与10个缺陷 → 安装两个 bundle/命名实例 → 分派同一 commit → 汇总报告 → 人工 gold set评分。
- **指标**：缺陷召回/误报、P50/P95 时延、token/美元、工具失败率、父唤醒丢失率、可续会率。
- **成本**：2个外部 agent订阅/API + dsh主模型；首轮控制在每case 3次运行。
- **通过线**：召回≥单agent +15%，成本≤2.2×，0条越界写，30/30可恢复。

#### Demo B：安全与恢复压测
- **目标**：验证 dsh 是否能作为受控本地 harness。
- **步骤**：loopback API未认证测试、approval自批准回归、Code Mode工作区外读写、恶意MCP constant cursor、断SDK pipe、SQLite升降级、插件双ABI。
- **指标**：越权成功数=0；崩溃后RPO=0条已确认event、RTO<60s；所有失败有可定位诊断；插件隔离不污染会话。
- **成本**：1台Linux VM + Win11 runner；不需真实敏感凭据。
- **通过线**：S0全部关闭或强制禁用，恢复/回滚自动化通过。

#### Demo C：研究→数据报告可追溯工作流
- **目标**：MCP检索/数据工具 → subagent分析 → session export HTML/JSON → OTel trace。
- **步骤**：只读数据源MCP、固定问题集、引用检查、导出脱敏、对比OpenClaw同任务。
- **指标**：引用正确率、报告字段完整率、端到端时延/成本、失败重试、trace覆盖、敏感字段泄露=0。
- **成本**：模型+搜索/API调用；本地存储。
- **通过线**：≥95%报告字段完整、≥90%引用可追溯、无敏感日志。

### 6.3 值得开发

- **企业 Profile Registry**：签名插件、SBOM、lockfile、ABI/conformance验证、灰度与一键回滚。
- **Recoverable Safe Mode**：插件启动隔离、故障 quarantine、只读恢复、dangling tool-call/session repair。
- **Security Audit CLI**：借鉴 OpenClaw，检查 bind/auth、sandbox、Code Mode、approval principal、MCP网络/凭据、插件来源、日志泄密。
- **评测/观测层**：OTel语义规范、trajectory replay、成本/缓存/工具故障仪表盘、基于session event的回归评测。
- **Browser provider seam**：隔离浏览器、凭据代理、域 allowlist、截图/下载审计，避免简单把CDP直通模型。

### 6.4 OpenClaw 可集成

- **把 dsh 作为 OpenClaw 的受控 coding/research worker**：OpenClaw负责渠道、定时、身份、通知；dsh在独立容器/OS用户执行可复现项目任务。
- **通过 ACP/MCP 接入**，避免共享同一未经认证的 Web control plane；OpenClaw侧用工具 allowlist、sandbox和独立凭据。
- **会话证据桥**：dsh导出 JSON/OTel → OpenClaw归档/通知；不直接转发 reasoning/secret-bearing tool args。
- **反向集成**：将 OpenClaw 已成熟的 browser/device/search 作为受限 MCP provider给 dsh，按域和动作审批。

### 6.5 合作观察

- DeepSeek 官方是否开放安全联系人、private vulnerability reporting、CVE/安全公告与企业路线。
- Cordis/DeepSeek 是否定义稳定第三方 ABI、插件签名与注册中心。
- ACN、pi2dsh、autogate、session-export、topology 是否持续维护并加入兼容测试。
- E2B/远端 sandbox、Claude Code/Codex bundles 是否形成正式支持矩阵。

### 6.6 暂不建议

- 绑定 `0.0.0.0` 或直接公网暴露 dsh Web。
- 在含SSH key、云凭据、生产数据的宿主启用 Code Mode/both。
- 为绕过Windows兼容问题长期使用 `danger-full-access`。
- 无审计地安装GitHub社区插件、自动审批插件 full-auto、未知MCP server。
- 把 RC SQLite 数据当唯一事实源；无备份/迁移演练升级或降级。
- 对客户声称已具备 P1生产案例、企业多租户、成熟Browser/Computer Use或垂直行业方案。

## 7. 下期 10 个验证问题

1. 最新 rc.2 是否仍可复现 #853 未认证控制面？官方修复 commit/版本是什么？
2. #250 approval self-grant 是否已用认证UI principal彻底阻断？
3. Code Mode 是否已换成独立进程/容器并继承同一 sandbox policy？
4. rc.7→rc.8→rc.2 SQLite 的迁移、备份、回滚与schema mismatch行为如何？
5. 第三方插件双份 runtime 是否在 load-time 被拒绝？损坏会话能否自动修复？
6. 100k session events、100图、10并发 agent 的 fork/resume/compaction P95与内存是多少？
7. Windows native/WSL2/MSYS/多盘Node 的 workspace-write 兼容矩阵是否通过？
8. MCP constant cursor、断流、恶意大响应、credential exfiltration有哪些硬限额与审计？
9. 有无可由客户/使用方独立确认的 P2/P1 案例、SLA、成本或故障数据？
10. 插件注册中心、签名、SBOM、RBAC/SSO、集中策略、日志脱敏与租户隔离路线何时明确？

## 8. 主要来源

详见同目录 `C-evidence.tsv`，其中记录来源类型、日期、可靠度、对应结论与URL。关键一手来源包括官方 README/架构/发布说明、DeepSeek 官方预览页、GitHub Discussions 中的可复现报告、以及五个竞品的官方文档。


---

## 13. 关键数据与证据表

| 对象 | 主张/数据 | 原始来源 | 原始时间 | 事件ID/Tag/SHA | 窗口 | 验证状态 |
|---|---|---|---|---|---|---|
| 官方阶段 | Developer Preview；未来会有 breaking changes | [README](https://github.com/deepseek-ai/deepseek-harness/blob/master/README.md) / [产品页](https://deepseek.com/harness/) | 截止 2026-08-25 | master HEAD | 当前状态 | 一级来源已核 |
| 最新 Release | `v0.1.1-rc.2`，prerelease | [Release](https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.1-rc.2) | 2026-08-21 20:35 +08 | Release 374388128 | 7天窗 | 一级来源已核 |
| 最新 Tag | `dsh-v0.1.1-rc.2` | [Tags API](https://api.github.com/repos/deepseek-ai/deepseek-harness/tags) | 2026-08-21 | tag | 7天窗 | 一级来源已核 |
| Tag/HEAD SHA | `b150a551b8d465e31e418e1b2eaf5e79bbb7d28e` | [Commit](https://github.com/deepseek-ai/deepseek-harness/commit/b150a551b8d465e31e418e1b2eaf5e79bbb7d28e) | 2026-08-21 20:03 +08 | SHA | 7天窗 | Tag/HEAD双核 |
| rc.8 存储 | SQLite 性能/体积改善；数据结构不兼容 | [rc.8 Release](https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.0-rc.8) | 2026-08-19 | `dsh-v0.1.0-rc.8` | 7天窗 | 一级来源已核 |
| rc.1 安全 | 修复 bwrap `/proc/<pid>/root` 绕过 | [rc.1 Release](https://github.com/deepseek-ai/deepseek-harness/releases/tag/dsh-v0.1.1-rc.1) | 2026-08-21 | PR #1798 / rc.1 | 7天窗 | 一级来源已核 |
| 官方仓库热度 | 约 192,993 stars / 21,671 forks / 849 subscribers | [Repo API](https://api.github.com/repos/deepseek-ai/deepseek-harness) | 抓取 2026-08-25 14:00 | repo snapshot | 当前快照 | 一级来源；热度非质量 |
| Topic | `dsh-plugin` 11,432 仓库 | [Search API](https://api.github.com/search/repositories?q=topic%3Adsh-plugin) | 抓取 2026-08-25 14:10 | search snapshot | 当前快照 | 已核；严重高噪，不当有效插件数 |
| Bridge | `dsh-plugin-bridge` 0.2.11，MIT，B级 | [仓库](https://github.com/Totoro-qaq/dsh-plugin-bridge) | 2026-08-24/25 | 0.2.11 | 近7天 | 仓库+包已核，未运行 |
| Vision Router | 1.7.7，MIT，B级；网络/截图/远端上传面较大 | [仓库](https://github.com/ysr666/dsh-vision-router) | 2026-08-22/25 | 1.7.7 | 近7天 | 仓库+包已核，未运行 |
| dsh-web | 单项包 B；聚合包 C，Apache/BSD/MIT 混合 | [仓库](https://github.com/zhu1090093659/dsh-web) | 2026-08-24/25 | 0.3.3 | 近7天 | 原始仓库/包已核，未运行 |
| 真实案例 | P1=0，P2=0；主要为 P3 Demo | 官方/作者仓库与可复现步骤 | 截止 2026-08-25 | 多项目 | 近30天 | 未发现独立客户侧证据 |

完整逐事实证据台账：A/B/C 三份 TSV 已合并到持续台账，包含 URL、事件时间、读取时间、窗口身份、SHA/版本与验证状态。

## 14. 重点事实抽查（12/12）

| # | 抽查事实 | 原文核验 | 结果 |
|---:|---|---|---|
| 1 | 官方仍为 Developer Preview | README 与产品页均明确 | 通过 |
| 2 | 最新 Release 为 rc.2 | Releases 列表正文与发布时间一致 | 通过 |
| 3 | Tag 与 SHA | Tags API 指向 `b150a551…d28e` | 通过 |
| 4 | master HEAD | Commit API 与 Tag SHA 一致 | 通过 |
| 5 | rc.8 SQLite 不兼容 | Release 原文明确“storage format is incompatible” | 通过 |
| 6 | rc.1 bwrap 安全修复 | Release 原文明确 `/proc/<pid>/root` | 通过 |
| 7 | rc.8 Claude/Codex Bundle | Release 原文明确可按需安装、命名实例与非交互模式 | 通过 |
| 8 | Bridge 版本/License/维护 | 原始仓库、npm 与 commit 核对 | 通过，B级 |
| 9 | Vision Router 权限与版本 | 原始 manifest、依赖、README 与 npm 核对 | 通过，B级 |
| 10 | dsh-web 聚合风险 | 原始仓库 packages、License、兼容声明核对 | 通过，单项B/聚合C |
| 11 | Topic 数量 11,432 | 14:10 Search API 返回值 | 通过，但仅发现指标 |
| 12 | 无 P1/P2 案例 | 官方、项目方与使用方证据扫描未找到双源生产证明 | 通过；结论为“未找到”，非绝对不存在 |

## 15. 最终判断与验证局限

### 确定性高

- 版本、Tag、SHA、Developer Preview、rc.8 SQLite 不兼容、rc.1 bwrap 修复；依据均为官方一级来源。
- Cordis 全插件架构、Session event log、Profile/Bundle、Subagent/SDK/Scheduling/Telemetry 的存在；依据为官方源码与文档。
- 现阶段不应把 Stars、Topic 数或 Demo 数量解释为生产采用。

### 确定性中

- 社区处于“供给加速、治理滞后”；依据是短窗新建/更新速度与重点项目质量，但首次报告没有环比基线。
- Bridge、Vision Router、dsh-web 单项包是本期相对优秀的第三方项目；已核仓库与包，但尚未运行验证。
- OpenClaw 与 dsh 更适合“控制平面 + 受控 worker”互补，而非互相替代。

### 确定性低 / 待动态复测

- Web 无认证、approval 回环、Code Mode 隔离等公开安全报告在 rc.2 的可复现性；未作为官方 CVE 下结论。
- Topic 中“有效插件”的真实去重数、外部贡献占比、Issue/PR 响应速度；官方关闭 Issues/PR 且 Topic 高噪。
- 性能、并发、TCO、企业 SLA 与 P1/P2 落地；没有足够使用方数据。

**最终建议**：本期可立项两个动作——一是固定 rc.2 做“Claude Code + Codex 双子代理仲裁”Demo；二是同步做安全与恢复压测。任何生产化投入都应以 S0 安全复测、SQLite 回滚、插件 ABI 门禁、网络隔离和会话恢复全部通过为前提。
