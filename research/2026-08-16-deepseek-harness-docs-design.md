# DeepSeek Harness 官方文档与设计精读

> 状态：提纲已创建，正文将按官方文档逐页研究后逐章追加。

## 研究元数据
- 访问日期：2026-08-16（Asia/Shanghai）
- 官方资料范围：<https://github.com/deepseek-ai/deepseek-harness>；<https://deepseek.com/harness/en/>
- 仓库 HEAD SHA：`47f943859bef60e4160492346772ded9b24f765a`
- 文档/软件版本：根包 `0.1.0-rc.5`（Developer Preview）
- 方法约束：先列目录；每次仅读取一个官方页面或仓库文件，读完立即追加笔记；不批量加载全仓库。

## 提纲
1. 文档地图、版本与阅读方法
2. 为什么是 Harness：产品定位与设计取舍
3. Everything is a Plugin：扩展模型及其边界
4. Cordis：内核、依赖注入与运行时角色
5. Presets：默认组合而非单一产品
6. 插件 API：依赖、作用域、生命周期与组合规则
7. 核心能力组合：session、skill、subagent、workflow、sandbox、storage、scheduler
8. Web UI 与人机协作面
9. 安全、运维与兼容性
10. Developer Preview：采用风险与验证清单
11. 与 Claude Code、Codex、OpenClaw 的克制架构对照
12. 五个反直觉观点
13. 术语表
14. 证据矩阵（至少 20 条）
15. 文章大纲与结论

---
## 1. 文档地图、版本与阅读方法

### 1.1 仓库入口页笔记（README）

仓库在本次访问时的远端 `HEAD` 为 `47f943859bef60e4160492346772ded9b24f765a`。README 把 DeepSeek Harness（命令名 `dsh`）定义为 DeepSeek AI 开发的开源 **agent harness**，而不是模型、IDE 或固定形态的 coding agent。入口页用一句“Everything is a Plugin”概括其架构，并明确运行时由 Cordis 驱动；Cordis 背后的理论来源被链接到 “A Programming Paradigm for Spatiotemporal Composability”。这意味着项目首先强调的是可组合运行容器及扩展机制，而非某个预装 Agent 的终端体验。

README 给出的最短启动方式是通过 npm 运行 `@deepseek-ai/dsh web`，默认仅在 `127.0.0.1:3080` 提供 Web UI。源码运行要求 Node.js、pnpm、安装依赖并构建。默认绑定环回地址是一个有意义的安全默认值，但并不等价于完整的身份认证、租户隔离或生产加固。

最重要的版本信号是：项目被明确标为 **Developer Preview**，README 用大写警告“将会有破坏兼容性的变化”。因此本文记录的“版本”不应虚构成稳定 semver 承诺；更准确的研究基线是上述 HEAD SHA + 访问日期。任何插件接口、配置形状、preset 名称和运行语义都必须按该提交冻结理解。

来源：
- <https://github.com/deepseek-ai/deepseek-harness>
- 仓库文件：`README.md`（HEAD `47f943859bef60e4160492346772ded9b24f765a`）

### 1.2 README 指向的一级文档

入口页显式给出以下阅读路径，后文将逐页处理：

1. `docs/user/guide/index.md`：Web UI 用户指南；
2. `docs/development.md`：开发指南；
3. `docs/architecture.md`：架构文档；
4. `AGENTS.md`：面向仓库内开发 Agent 的约束；
5. `CONTRIBUTING.md`：贡献流程；
6. `README.zh.md`：中文入口页；
7. `LICENSE` 与 `THIRD_PARTY_NOTICES.md`：许可与第三方依赖披露。

此外，README 指向 Cordis 仓库及其论文，但本文严格按任务限定，不越出 DeepSeek Harness 两个官方入口做展开；只记录 Harness 官方文档对 Cordis 的引用与解释。

### 1.3 `docs/` 顶层目录（先目录、后正文）

通过固定 SHA 的 GitHub Contents API 取得 `docs/` 顶层清单。为控制上下文，只记录路径，不在此步读取文件正文。英文主文档包括：`agent-lifecycle.md`、`api-gateway.md`、`architecture.md`、`capability-seams.md`、`config-catalog.md`、`cordis-primer.md`、`defensive-patterns.md`、`development.md`、`event-producer-consumer.md`、`glossary.md`、`graph-atlas.md`、`module-graph.md`、`persistence-catalog.md`、`rescope.md`、`testing.md`、`tool-catalog.md`、`tool-execution-pipeline.md`、`web-styling.md`；另有对应 `.zh.md` 与 `.i18n.yaml`。子目录为 `cookbook/`、`cordis-api/`、`cordis-tutorial/`、`i18n/`、`postmortem/`、`subsystems/`、`user/`。

本报告采用“主题所需的主文档 + 子系统目录 + 用户指南”路线，不重复读取同义中英文页，也不把 13 万字配置目录整页塞入上下文；后者只在具体论点需要时按单页/单文件处理。

来源：<https://api.github.com/repos/deepseek-ai/deepseek-harness/contents/docs?ref=47f943859bef60e4160492346772ded9b24f765a>

## 2. 为什么是 Harness：产品定位与设计取舍

“harness”在这里更接近**可装配、可替换、可观测的 Agent 运行支架**。架构页没有把“Agent”固化为一个应用，而把运行中的 `dsh` 描述为启动时由有序层组成的插件树。模型适配器、工具注册表、session log，甚至 agent loop 本身都只是插件。这一命名强调三件事：第一，模型与执行能力需要被约束并接线；第二，UI、无头运行、存储和策略是不同分发组合；第三，扩展原则是挂载旁路插件，而不是修改所谓核心。

与“SDK”相比，Harness 不只给调用接口，还规定启动组合、运行时作用域、事件流、持久日志和 UI 投影；与“Agent 产品”相比，它又刻意保留替换 agent loop、模型、工具、持久化与 sandbox 的能力。它真正售卖的抽象是“组合关系”和“生命周期一致性”。

架构页定义 step 为“一次模型请求及其工具调用”，turn 为“零或多个 step”。输入、prompt/tool schema 组装、模型流、工具执行、停止判定被事件化。这里的重要取舍是：系统既提供一个默认 driver，又不把 driver 神圣化。扩展可通过 agent、tools、capability 三类事件域接入，只有更改 loop 本身才需要更新架构地图。

## 3. Everything is a Plugin：扩展模型及其边界

这句话不是“任何代码都可以随便注入”。它有清晰边界：

1. **插件共享 Cordis context，但通过服务、typed event、可逆 effect 接入。** 注册随插件卸载而回滚，避免永久污染运行时。
2. **无特权核心不等于无架构纪律。** 新行为必须附着在文档化 extension point；持久事实进入 session event，飞行中行为进入 `agent/*`，能力策略进入 capability event。
3. **可替换受服务基数和作用域约束。** 某些服务可以多注册，某些是唯一 provider；单 session 的不同能力集需 agent preset，且服务行可能必须使用 `isolate` realm。
4. **模型可见内容受日志不变量约束。** 文档明确“Model-visible means logged”：送入模型的内容必须能从 session log 重建。插件不能绕过日志悄悄改变模型上下文而仍声称可回放。
5. **seam 不是一个接口名称。** 完整 seam 至少包括 Service Definition、Provider、Consumer 三种角色；只实现其中之一不构成可换能力。
6. **patch 不是字段级任意合并。** 配置层按 bundle、profile patch、home patch、命令行 overlay 排序；patch 以 row id 定位并替换整份 config，或插入新行。

因此，“Everything”说的是产品组件的地位平等和替换路径，而不是取消类型、依赖、作用域、安全策略与持久性规则。

## 5. Profiles、Bundles 与 Presets：三个容易混淆的组合层

架构页使用 **profile** 与 **bundle** 描述启动组合：profile 是 Harness home 中的命名组合，列出叠加 bundles、安装的树外插件和用户 `cordis.patch.yml`；`web` 与 `headless` 随项目提供模板。bundle 是 Cordis config rows 及其挂载代码的分发格式。`dsh-base` 是所有 profile 第一层，提供模型适配器、工具、持久化、sandbox/审批策略、设置、凭据、遥测；`dsh-web-app` 增加浏览器应用；`dsh-headless` 增加不启动服务器的一次性 runner。

**preset** 则位于更细的 Agent 组合层：架构页在“让一个 session 拥有不同 capability set”时要求 compose an agent preset。故不能把 profile 和 preset 当同义词：前者决定整个进程/产品形态启动什么插件树，后者决定某个 Agent/Session 获得哪些能力。后文再依据专页细分 preset 差异。

## 4. Cordis：内核、依赖注入与运行时角色

Harness 官方把 Cordis 定义为底层 framework：插件向共享 context 贡献 services、typed events 和 reversible effects。Cordis 的角色不是一个普通插件市场，也不是单纯 IoC 容器，而是同时承担：

- 插件树与有序配置装配；
- service 发现与依赖关系；
- typed event 的生产、消费及 waterfall/serial 等调度语义；
- effect 与插件卸载联动的资源回收；
- context/realm 形成的运行时作用域。

这使“插件化”获得时间维度：不只问服务在哪里，还问何时创建、在哪个 context 可见、何时撤销。官方引用的“时空可组合性”由此落到工程实践。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/architecture.md>

### 4.1 Cordis 五个基础概念与事件语义

Primer 补足了具体 API 语义。插件是实现 `Service` 的对象：可以是带可选 `inject`、`apply(ctx)` 字段的函数，也可以是 `Service` 子类。context 是 service repository，稳定的 `ctx.<key>` 代替对实现类的直接 import。插件用 `inject` 声明必需服务，只有依赖出现后才激活，因此“加载顺序”被提升为依赖可满足性，而非手写 boot sequence。

事件有四种公开调度契约：`emit` 不等待、无返回；`waterfall` 不以 fan-out 等待方式调度但有返回值，作为 around-middleware，监听器必须调用 `next()` 才继续；`parallel` 等待所有监听器并行完成、无返回；`serial` 等待监听器依注册顺序完成、有返回。官方要求新事件使用 `@mode` 标记，让生成目录核对 declaration 与 dispatch site。这表明事件模式不是实现细节。

Loader 还允许配置表达式：include 插件解析 `!!js` 表达式，entry config 在声明的 injection 激活后针对插件 context 插值，`disabled` 则在每次 mount 决策时针对 loader context 计算。官方建议环境选择插件时使用 overlay。表达式配置提升动态性，也扩大了配置审计与供应链风险面。

实践规则是：拦截与策略优先事件，直接能力调用优先 service method；每个注册都应有 disposer，若 teardown 顺序重要，应把相关工作放进同一个 effect，以获得预期的逆序撤销。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/cordis-primer.md>

### 1.4 子系统文档目录

`docs/subsystems/` 的英文页面目录为：`README.md`、`approval.md`、`attachment.md`、`client-modules.md`、`code-runtime.md`、`commands.md`、`compaction.md`、`core.md`、`credentials.md`、`extensions.md`、`feedback.md`、`filesystem.md`、`goal.md`、`invariants.md`、`jobs.md`、`llm-streaming.md`、`lsp.md`、`permission-presets.md`、`persistence.md`、`plan.md`、`sandbox.md`、`schedule.md`、`scope.md`、`session-projection.md`、`session-query.md`、`session-reference.md`、`session-telemetry.md`、`session-title.md`、`session.md`、`settings.md`、`shell.md`、`skills.md`、`spill.md`、`storage.md`、`subagent.md`、`subprocess.md`、`system-prompt.md`、`terminal.md`、`token-meter.md`、`tools.md`、`typert.md`、`user-questions.md`、`web-server.md`、`web.md`、`workflow.md`、`workspace.md`。后续只逐页读取任务覆盖所需的页面。

来源：<https://api.github.com/repos/deepseek-ai/deepseek-harness/contents/docs/subsystems?ref=47f943859bef60e4160492346772ded9b24f765a>

## 6. 插件 API：依赖、作用域、生命周期与组合规则

### 6.1 Scope：可见性与所有权统一

Scope 专页揭示 per-agent 隔离的实现边界。`ScopeKey` 是按对象身份比较的不透明 key；默认 loop 使用 live `Agent` 对象作为 key，但 primitive 不检查其内容。`scopeTarget(base,key)` 创建仅用于事件路由的 branded receiver，真实 subject 仍作为显式 event 参数传递。

`Scope` 把注册 context 与两条 teardown 路径绑定：`rawDispose` 保留 Cordis disposer 的精确身份，便于有序 composite effect；公开 `dispose()` 是共享 quiescence boundary，并发调用等待同一完成结果。`ScopedLayers` 有 eager global layer 和 lazy exact-scope layers；只读不创建 scope layer，合并时先全局命名项，再以 scoped shadow 覆盖。注册所用 context 同时决定**可见性**和 **effect 所有权**。

这解释了插件作用域不是简单的 Map 过滤器：它把“谁看得到”与“谁负责回收”绑定起来，防止 session/agent 专属工具在 Agent 销毁后泄漏。边界也很明确：隔离依赖 exact object identity，不是自动的权限安全域；若插件错误地注册到 global context，它仍会全局可见。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/scope.md>

## 7. 核心能力如何组合

### 7.1 Session：事件溯源的共同脊柱

Session 是 typed `SessionEvent` 的 append-only log，是整个 Agent 交互历史的单一事实源；LLM message history 始终从日志派生，不另存副本。事件词汇支持 TypeScript declaration merging，插件可增加事件类型；事件数据要求 lossless JSON、连续 seq，raw chunk 也进入 canonical log。持久化是相邻的 seam，而不是 Session 内存模型本身。

核心事件覆盖 turn/step 边界、user/assistant 消息、原始流 chunk、tool call/result、todo 快照、request header/context 和 seed 边界。普通 prompt、`agent.inject()` 的合成上下文、goal continuation 都统一为有 source 区分的 `user/message`。工具私有 UI meta 可以写入 `tool/result`，但必须 JSON 可序列化，保证回放产生相同卡片。

兼容性策略偏“拒绝错误重建”：未知事件仅在显式 `ignorable: true` 时可跳过；否则 reader 必须拒绝 reconstruct。由于事件 map 可被插件扩展，官方反而禁止对整个 union 使用 `assertNever`。旧 v0 request-header delta 日志也会在 seed、append、load 边界被拒绝，而不是不完整回放。这是一种重数据正确性、轻宽松兼容的选择。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/session.md>

### 7.2 Skill：可发现、按需加载的指令能力

Skill seam 分为 Definition（`ctx.skills`）、filesystem/provider、可选 badge provider 与模型工具 consumer。Skill 是可选指令而不是 session event；registry 合并 host 与 per-scope provider catalog，preset 内挂载的 provider 自动进入对应 scope layer。最近 scope 对同名 skill 整体遮蔽全局项，同层才按 rank、provider order、local order裁决。

Provider 同步注册，但远端初始化、认证与 discovery 应在可等待的 `list()` 内完成；`get()` 按先前 candidate 加载完整 body。catalog 观察显式携带 `complete`：临时失败可返回仍可用但不权威的候选，不缓存 incomplete snapshot。模型目录只看可调用 skill 的 name/description，不把正文或绝对路径预灌入 prompt；正文由 `skill` 工具按需加载。这既节约上下文，也把 discovery 与 instruction activation 分开。

本地来源优先级从项目 `.dsh/skills`、项目 `.agents/skills`、custom、用户 dsh、用户 agents 到 bundled（数字 rank 越低越优先）。`.git` 最近祖先确定项目根；若存在 `ctx.fs`，根目录探测也走 filesystem service，以适应 remote/sandbox workspace。skill 还区分 `modelInvocable` 与 `userInvocable`，两者都 false 时仍可被可信 `ctx.skills.get()` 调用。因此“存在于 catalog”不等于“模型有权调用”。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/skills.md>

### 7.3 Subagent：可选 seam，而不是 loop 内置递归

Subagent 与 bash 类似，是可选 capability，不属于 agent loop。不同之处是 `ctx.subagents` 允许多个命名 provider 共存；官方列出的 provider 包括 in-process spawn、fork、ACP、Codex、Claude Code、dsh SDK。consumer 分为按 provider delegation、全局控制工具和 child-scoped report channel。这个设计直接说明对其他 Agent 产品的集成是 provider backend，不代表 Harness 与这些产品结构相同。

一次性启动前，service 根据静态 descriptor 检查 output schema、depth limit、tool filter、persona；缺能力时 typed error 失败，禁止“接受后忽略”。工具过滤不仅从 child prompt 隐藏 schema，也拒绝执行；persona 作为 child-scoped prompt section 遮蔽 deployment persona。取消统一走 AbortSignal。

可继续后台子 Agent 则是“一个 durable child Session + 最多一个 process-local Activation”。Activation 可执行多轮 FIFO turn，且在其后代仍运行时保持驻留；唯一队列就是 Agent inbox，不再造第二套任务状态机。无 Activation 时 followup 触发 cold resume。权限来自 live Agent tool context 与 durable direct-parent lineage，而不是消息中自报的 sender id。interrupt 取消当前 turn 但保留 inbox 和 descendants，之后消息可唤醒恢复。这是把 session、scope、持久化、subagent lineage 和生命周期真正组合起来的例子。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/subagent.md>

### 7.4 Workflow：模型编写的编排脚本

Workflow 是可选 seam，允许 Agent 运行模型生成的 orchestration script 来启动 subagents。每个 context 只有一个 `ctx.workflowEngine`，不同于多 provider 的 subagent registry。当前 provider 使用 Node worker thread，每次 run 一个 worker，脚本在其中的 VM context 执行。`meta`/`args` 是先校验的纯 JSON，不通过执行脚本取得；每个 child 必须归属 live parent Agent，并继续经过 subagent seam 的 cwd、lineage、depth 规则。

Run handle 的 `result` 不 reject，失败以 closed stop reason 表示；holder 必须 dispose。取消具有有界 grace，即便脚本不退出，engine 也 force-settle 并终止 worker，防止调用者永久挂起。脚本 API 错误、cap 超限、取消属于 fatal，不能被 parallel/pipeline 悄悄转成 null。观察事件只发送克隆的数据快照，不暴露 live run 的 cancel/dispose，也隔离 listener 异常。

Workflow 的展示事实投影回 parent Session，但不转移执行所有权；日志记录 start/member/end 合法前缀，尾部缺失 end 被解释为中断证据。于是 workflow 把动态编排放进受限 worker，把 Agent 执行交给 subagent seam，把审计与 UI 交给 session projection。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/workflow.md>

### 7.5 Sandbox：文件效果约束，不是万能隔离

Sandbox mode 只治理 filesystem effects：`read-only`、`workspace-write`、`danger-full-access`；网络和进程可见性明确在词汇边界之外。`danger-full-access` 直接绕过 provider。Linux 本地实现可用 bwrap/Landlock，macOS Seatbelt，Windows ACL restricted token；容器、microVM、remote execution 应作为完整 capability seam 的兄弟实现，而不是 `ctx.sandbox` provider。

策略逐调用解析，可并发给不同 session/consumer 不同 root 和 mode；workspace root 来自 immutable session cwd 并按 filesystem 语义 canonicalize。backend 必须报告 `full` 或 `partial` enforcement，旧 Landlock 和 Windows ACL 边界可能只 partial。没有可用 backend 时必须 fail closed，禁止在 confined policy 下静默裸跑。换言之，“启用 sandbox”仍需核对平台、enforcement 和网络边界，不能只看布尔开关。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/sandbox.md>

### 7.6 Storage：非 Session 日志的数据域

Storage 持久化“不属于 session event log”的数据。`ctx.storage` 是 hub 而非 store，不做 IO；多个 JSON/SQLite backend 可并存，由 domain consumer route，而不是全局只选一个。backend 拥有 medium 和可选 facet，domain form 提供 typed semantic API，产品包不得直接触碰 backend。

Domain spec 用名称、版本和 zod schema 定义布局。写操作在 per-domain chain 排队：backend durability 确认后才更新内存，再发 `domain/changed`；失败则内存不动。格式版本不符或 medium malformed 均 fail loud，文档明确当前 pre-release 不做 migration。change event 只进程内广播，跨进程 push 是已知限制。这与 Session persistence 的职责分离，可避免把设置、索引、业务 KV 强行塞进对话事件流。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/storage.md>

### 7.7 Scheduler：会话内、持久、至少一次的普通后续轮次

Schedule 不是外部通知服务，而是把 durable reminder 在原 live Session 中送成普通后续 turn。v1 支持 after、带时区的 absolute at、至少五分钟的 fixed-rate every；不支持 cron、calendar recurrence、跨记录 admission gate。绝对时间最终 canonicalize 为 UTC，缺 offset、DST gap、非未来目标均拒绝。

`schedule/change` 是唯一 durable authority。冷 Session 不执行；重开后重建 timer，过期项变 overdue。递归提醒只合并最新到期 occurrence，不枚举 missed intervals。交付等待 Agent 完全 idle，不打断当前 turn；crash 在 inbox admission 与 dispatch durable append 之间可能重复，所以官方明确是 best-effort at-least-once，而非 exactly-once。fork 只 fold seedLength 之后的事件，保留历史但不继承父 session 的 active reminders。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/schedule.md>

### 5.1 Permission presets 的差异

官方当前默认 permission preset 只有两种：

| preset | sandbox | approval | 含义 |
|---|---|---|---|
| `workspace-write` | workspace-write | ask | 文件写入限于 workspace，并在策略要求时询问 |
| `danger-full-access` | danger-full-access | never | 绕过文件 confinement 且不询问，风险最高 |

Preset layer 自己**不执行安全策略**，只把 sandbox mode 与 approval policy 两个独立 knob 打包为客户端的一个 selector，并调用各自 canonical setter；真正执行、prompt narration、replay 仍读取各 knob 的 fold。若 knob 组合不匹配表内项，UI 显示派生的 `custom`，但 `custom` 不是可切换目标。插件还要求 confining shell executor 和 approval service；在不支持 confinement 的 bash 上装 preset 会在 load 时失败。

这再次说明 preset 是“组合便利层”，不是安全边界。尤其 `danger-full-access + never` 是明确能力选择，不应误称默认沙箱。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/permission-presets.md>

## 8. Web UI 与人机协作面

Web profile 在 base 上增加 browser app；HTTP carrier `ctx.webServer` 本身不懂 Harness，只提供 named route、index transform、单一 fallback。`/api` bridge、plugin bundle、HMR stream 均由别的插件注册。路由按 exact、最长 prefix、fallback 固定匹配；重复 route 与第二个 fallback 都视为 composition error。

服务默认监听 `127.0.0.1`，也可显式选 `0.0.0.0`。官方清楚声明：没有 TLS、认证和 origin policy，非 loopback bind 会暴露给所在网络。因此 Web UI 是本地 GUI host，不应未经反向代理鉴权和网络隔离直接当多用户公网服务。Electron 则从 `file://` 加载并经 IPC bridge fetch，不走该 HTTP server。

Web access（`ctx.web`）与 Web UI 是不同子系统：前者为模型提供 search/fetch seam。它在执行时按显式 provider id 选择；多个可用 provider 而未配置时抛 ambiguous，不靠注册顺序。HTTP fetch backend 会限制 redirects/bytes/chars/time，却**不阻断私网目标**；官方明确警告不要在能访问敏感内网的环境启用 `web_fetch`。这构成 SSRF/内网探测风险面，不能由 process sandbox 的文件策略覆盖。

来源：
- <https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/web-server.md>
- <https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/docs/subsystems/web.md>

## 9. 安全、运维与兼容性

### 9.1 安全边界

Harness 采用多层而非单一“安全模式”：工具注册与 scope 控制可见性；approval 决定人是否确认；sandbox 限制文件效果；filesystem/subprocess provider 决定实际执行世界；Web fetch 另有网络风险；session log 提供审计与回放。关键是不要混淆这些层：隐藏工具不等于无执行权限，approval 不等于隔离，filesystem sandbox 不等于 network sandbox，loopback UI 不等于身份认证。

### 9.2 运维姿态

推荐冻结 SHA/lockfile 和 profile dump，使用 `--dump-config` 审核最终插件树；上线前分别验证 backend availability、sandbox enforcement（full/partial）、persistence barrier、storage schema/version、Web bind、凭据和 provider ambiguity。Cordis effect/disposer 让 HMR 与 teardown 可控，但第三方插件仍能注册 service/event/tool，属于高信任供应链代码，应审查来源和最小 scope。

### 9.3 兼容性基线

根 `package.json` 标识版本 `0.1.0-rc.5`、Node `^22.19.0 || >=24.0.0`、pnpm `11.7.0`；README 同时将项目标为 developer preview。Session reader 对未知 required event 和旧 v0 header log fail closed，Storage 对 version mismatch 不迁移，配置 patch 又以整行 config 替换。因此升级前必须备份数据、验证插件编译/事件目录、做 session/storage fixture 回放并比较 dump config；不能假设 rc 小版本兼容。

来源：<https://github.com/deepseek-ai/deepseek-harness/blob/47f943859bef60e4160492346772ded9b24f765a/package.json>

## 10. Developer Preview：采用风险与验证清单

官方警告的“compatibility-breaking changes”应被当作架构事实，而不是免责声明。主要风险有：

1. **API 漂移**：service key、事件 payload、provider contract、preset/config 字段可能改变；
2. **数据兼容**：Session 与 Storage 都偏向拒绝不完整解释，migration 能力尚非稳定承诺；
3. **插件生态**：树外插件需与精确 HEAD/包版本联测，Cordis lifecycle 正确并不自动保证业务兼容；
4. **安全成熟度**：Web server 无 auth/TLS/origin policy，fetch 不封私网，sandbox 只管文件且可能 partial；
5. **运维成熟度**：session-local scheduler 无冷会话外部交付，cross-process storage change push 缺失；
6. **产品语义变动**：profile/bundle/preset 的默认组合仍可能调整。

建议定位为本地开发、受控试验或内部单用户 preview。若进入生产路径：固定 commit 和镜像；禁用不必要 provider/tool；默认 loopback；对外置网关做 TLS、鉴权、CSRF/origin 与网络 ACL；确认 sandbox full enforcement；把日志/存储做升级前导出；为插件注册/卸载、重放、取消、崩溃恢复建回归测试；每次升级人工审查 config diff 与 persistence compatibility。

### 2.1 官方发布页的最短定位

官方站点发布页把受众限定为“agent harness developers worldwide”，并逐项宣称 models、tools、skills、sessions、sandboxes、storage、loops、scheduling、UI 都能作为插件替换或重组。这与仓库架构页一致，也进一步说明此 preview 首先面向框架/插件开发者，而非承诺开箱即用的稳定终端用户产品。

来源：<https://deepseek.com/harness/en/>

## 11. 与 Claude Code、Codex、OpenClaw 的克制架构对照

> 以下只对照架构重心，不做功能排名；Claude Code、Codex、OpenClaw 的具体内部实现不由本次限定的 DeepSeek 官方资料证明，因此只使用 Harness 官方文档可证的集成边界与通用产品形态描述。

| 观察维度 | DeepSeek Harness | Claude Code / Codex | OpenClaw |
|---|---|---|---|
| 首要抽象 | Cordis plugin tree + capability seams + event-sourced session | 面向编码任务的 Agent 产品/CLI；在 Harness 中可被当作命名 subagent provider | 以网关、渠道、工具/技能和多 Agent 会话为中心的个人/消息平台运行时 |
| Agent loop 地位 | 默认 loop 也是可替换插件 | 对外通常以产品既定 loop 行为呈现 | 运行时调度与会话/渠道集成是主干 |
| 组合单位 | profile → bundles → Cordis rows；agent preset → scoped capability | Harness 官方提供 Codex/Claude Code subagent backend，说明通过 transport/provider seam 接入 | 工具、skills、渠道插件、子 Agent 与持久任务围绕网关组合 |
| 状态模型 | append-only typed SessionEvent 是模型上下文事实源 | 本报告不从非限定资料推断其内部日志模型 | 会话、记忆、渠道状态与工具结果有独立运行时约束 |
| UI | Web 是一个 bundle/plugin，headless 不启动 server | 典型入口偏 CLI/IDE/产品客户端 | 聊天渠道与控制面是核心入口之一 |
| 扩展哲学 | “Everything is a Plugin”，Definition/Provider/Consumer seam 显式拆分 | 更强调完成编码任务的统一产品体验；Harness 将其作为外部 provider | 更强调跨渠道执行、个人助理运维与 skill/tool 集成 |

最值得注意的是：Harness 把 Claude Code/Codex backend 放在 **subagent provider** 层，而不是兼容整个 plugin tree。这种架构对照应理解为“可桥接的执行后端”与“宿主 harness”的关系，不能据此宣称协议、权限、日志或生命周期完全等价。与 OpenClaw 的差异也主要在重心：Harness 追求组件地位平等和运行时可重组；OpenClaw 更像带渠道、网关和个人自动化治理的长驻宿主。两者可能拥有相似名词（skill、subagent、session），但 scope、安全默认值、调度交付语义不应互相套用。

## 12. 五个反直觉观点

1. **“Everything is a Plugin”反而要求更强的核心纪律。** 没有特权核心并不意味着没有规则；事件域、service seam、scope、disposer、日志重建不变量比传统硬编码核心更严格。
2. **Session 不是聊天消息数组。** 原始流 chunk、turn/step 边界、request header、tool meta 与插件事件都进入日志，消息只是投影。
3. **Sandbox 不是安全容器的同义词。** 官方 sandbox 只治理文件效果，不管网络/进程可见性，还显式报告 partial enforcement；远程执行或 microVM 是另一整套 seam。
4. **Scheduler 持久化了提醒，却不保证离线送达。** 规则存在 session log 中，但只有原 Session live 时才计时投递，且是至少一次；“durable”描述状态，不等于外部通知 SLA。
5. **Workflow 并没有建立第二个工作流状态机。** 脚本在 worker 中编排，child 仍由 subagent/Agent inbox 执行，观察事实投影进 Session；有意复用现有生命周期而非复制一套 DAG engine 核心。

## 13. 术语表

- **Harness**：给 Agent 模型、工具、状态、策略、执行环境和 UI 接线的可组合运行支架。
- **Cordis**：Harness vendored 的插件框架，提供 context、service、typed event、effect 与生命周期。
- **Plugin**：函数式 Service 对象或 Service 子类，通过 `apply(ctx)` 挂载能力。
- **Context (`ctx`)**：按稳定 key 提供服务的 repository，也携带 scope 与 effect ownership。
- **Inject**：插件声明必需 service 的依赖机制，依赖满足后才激活。
- **Effect / disposer**：可逆注册及其撤销函数；插件卸载时回滚资源。
- **Profile**：Harness home 中的命名启动组合，叠加 bundles 与 patch。
- **Bundle**：Cordis 配置 rows 及其代码的分发单位。
- **Preset**：本文需区分 agent capability preset 与 permission preset；前者做 scoped Agent 组合，后者打包 sandbox/approval knob。
- **Realm / isolate**：Cordis 配置中的隔离边界；单 Agent 服务组合可能要求 isolate realm。
- **ScopeKey**：按身份比较的不透明作用域键；默认可使用 live Agent 对象。
- **Seam**：完整的可换能力边界，通常由 Service Definition、Provider、Consumer 构成。
- **SessionEvent**：append-only、JSON 可序列化的 typed log 事件。
- **Surface event**：参与模型消息表面的事件；并非所有 durable event 都可见于模型。
- **Step**：一次模型请求及其工具调用。
- **Turn**：零个或多个 step，从输入 claim 到无待办工作。
- **Waterfall**：around-middleware 事件；调用 `next()` 才委托下游，可短路。
- **Activation**：可继续 subagent 的进程内驻留期；不是 durable child 本身。
- **Skill**：经 provider 发现、按需加载的可选指令，不是 session event。
- **Workflow**：模型生成的脚本编排能力，通过 subagent seam 启动 child。
- **Storage domain**：非 session log 数据的 typed、versioned KV 语义层。
- **Persistence seam**：专门让 Session log durable 的边界，与 Storage 分开。
- **Sandbox enforcement**：`full`/`partial` 的实际文件约束完备度声明。
- **Developer Preview**：快速迭代、明确允许破坏兼容的发布阶段。

## 14. 证据矩阵

| # | 文档声称 | 官方链接或文件路径 | 判断 |
|---:|---|---|---|
| 1 | dsh 是开源 agent harness | `README.md` / <https://github.com/deepseek-ai/deepseek-harness> | 产品定位不是模型或固定 coding agent。 |
| 2 | 项目处于 Developer Preview 且会破坏兼容 | `README.md` | 生产采用必须固定 SHA 并设升级闸门。 |
| 3 | 官方站称模型、工具、skills、sessions、sandbox、storage、loop、schedule、UI 均可换/重组 | <https://deepseek.com/harness/en/> | “Everything”覆盖产品纵向栈，但仍受 seam 契约约束。 |
| 4 | Cordis 让插件贡献 service、typed event、reversible effect | `docs/architecture.md` | 插件化包含生命周期，不只是注册表。 |
| 5 | 模型 adapter、tool registry、session log、agent loop 都是插件 | `docs/architecture.md` | 默认 loop 无特权地位。 |
| 6 | profile 是命名组合，web/headless 是模板 | `docs/architecture.md` | UI 与无头运行是分发组合差异。 |
| 7 | dsh-base 是每个 profile 第一层 | `docs/architecture.md` | 基础能力由 bundle 提供，不等于不可替换 core。 |
| 8 | patch 按 id 替换整份 row config | `docs/architecture.md` | overlay 审查需注意不是深层字段 merge。 |
| 9 | “Model-visible means logged” | `docs/architecture.md` | 插件改变模型上下文必须留下可重建事实。 |
| 10 | seam 需要 Definition、Provider、Consumer 三角色 | `docs/architecture.md` | 单独一个 provider/接口不构成完整能力。 |
| 11 | 插件用 `inject` 等待依赖出现 | `docs/cordis-primer.md` | 启动顺序由依赖满足表达，减少手工 sequencing。 |
| 12 | waterfall listener 不调用 `next()` 即短路 | `docs/cordis-primer.md` | policy/interceptor 插件可改变控制流，需高信任审计。 |
| 13 | 每个 registration 应有 disposer | `docs/cordis-primer.md` | 热重载和卸载安全依赖插件正确清理。 |
| 14 | Scope 注册 context 同时决定可见性和 effect ownership | `docs/subsystems/scope.md` | per-agent 隔离与生命周期回收统一。 |
| 15 | Session 是 append-only log，LLM history 从中派生 | `docs/subsystems/session.md` | 重放和 UI 都围绕同一事件源。 |
| 16 | 未知 required event 必须拒绝重建 | `docs/subsystems/session.md` | 兼容策略偏 fail closed，插件事件升级需谨慎。 |
| 17 | Skill 是可选指令，不是 session event | `docs/subsystems/skills.md` | skill discovery 与对话事实是不同层。 |
| 18 | Skill catalog 正文按需 `get()`，模型目录只呈现 name/description | `docs/subsystems/skills.md` | 采用渐进披露，降低 prompt 常驻成本。 |
| 19 | Subagent 是可选 capability，可有多个 provider | `docs/subsystems/subagent.md` | child delegation 不在 agent loop 中硬编码。 |
| 20 | 官方提供 Codex 与 Claude Code subagent provider | `docs/subsystems/subagent.md` | 它们作为后端被桥接，不代表架构同构。 |
| 21 | Continuable child = durable Session + 最多一个 live Activation | `docs/subsystems/subagent.md` | 持久身份与进程驻留分离，支持 cold resume。 |
| 22 | Workflow 每 context 一个 engine，当前 worker-thread provider 每 run 一个 worker | `docs/subsystems/workflow.md` | 编排脚本与 Agent child 执行分离。 |
| 23 | Workflow cancel/dispose 有 bounded settlement | `docs/subsystems/workflow.md` | 卡死脚本不应无限阻塞 holder 清理。 |
| 24 | Sandbox mode 只治理文件效果，不治理网络/进程可见性 | `docs/subsystems/sandbox.md` | 不能把它宣传成全面安全容器。 |
| 25 | confined policy 不可静默 unconfined passthrough | `docs/subsystems/sandbox.md` | backend unavailable 时应 fail closed。 |
| 26 | Sandbox enforcement 可为 partial | `docs/subsystems/sandbox.md` | Windows ACL/旧 Landlock 等环境需显式风险处置。 |
| 27 | Storage 管理非 session event log 数据 | `docs/subsystems/storage.md` | 对话日志与业务 KV 职责分离。 |
| 28 | backend 版本不符拒绝，无 migration（pre-release） | `docs/subsystems/storage.md` | 升级前必须做数据导出与兼容验证。 |
| 29 | Schedule 只在原 live Session 中交付 | `docs/subsystems/schedule.md` | 不具备冷会话外部通知 SLA。 |
| 30 | Schedule crash 窄窗口可能重复，语义为至少一次 | `docs/subsystems/schedule.md` | reminder consumer 应容忍重复。 |
| 31 | 默认 permission presets 为 workspace-write/ask 与 danger-full-access/never | `docs/subsystems/permission-presets.md` | preset 只是两个 enforcement knob 的快捷组合。 |
| 32 | Permission preset 自己不 enforcement | `docs/subsystems/permission-presets.md` | 安全判断必须继续查看 sandbox 与 approval 实现。 |
| 33 | Web server 非 loopback 暴露时无 TLS/auth/origin policy | `docs/subsystems/web-server.md` | 生产对外必须加受控网关与网络策略。 |
| 34 | 本地 web fetch 不阻断私网目标 | `docs/subsystems/web.md` | 存在 SSRF/内网探测风险，应禁用或网络隔离。 |
| 35 | 根版本为 `0.1.0-rc.5`，Node 要求 `^22.19.0 || >=24` | `package.json` | 研究基线应同时记录版本和 commit。 |
| 36 | README 默认 Web UI 监听 `127.0.0.1:3080` | `README.md` | 本地默认合理，但不构成身份认证。 |

## 15. 可据此写作的文章大纲

### 建议标题
**《DeepSeek Harness 精读：当 Agent 的模型、循环、会话与 UI 都成为插件》**

### 开篇：不要把 Harness 读成又一个 Coding Agent
- 以 developer preview 和 0.1.0-rc.5 建立预期；
- 用“运行支架”解释 harness，而非做产品功能对打；
- 给出研究 SHA，提醒文章描述的是一个快照。

### 第一部分：Everything is a Plugin，但不是 Everything Goes
- Cordis 的 service/context/inject/effect；
- waterfall 与可逆注册；
- 无特权核心和文档化 extension point 的张力；
- 模型可见即已记录的不变量。

### 第二部分：三层组合词汇
- profile 决定进程产品形态；
- bundle 作为配置与代码分发单位；
- agent preset 做 per-session scoped capability；
- permission preset 只绑定 sandbox 与 approval。

### 第三部分：Session 是架构的事实脊柱
- turn/step/tool/chunk/request header 的事件溯源；
- UI、重放、fork、telemetry 如何成为投影；
- unknown required event fail closed 的兼容哲学。

### 第四部分：能力不是功能清单，而是 seam 图
- Definition/Provider/Consumer；
- skill 的渐进披露；
- subagent 的 provider 多态和 cold resume；
- workflow 复用 subagent，而非另造执行核心；
- storage 与 persistence 的分工；
- scheduler 的 live-session、至少一次边界。

### 第五部分：安全必须逐层读
- tool visibility、approval、filesystem sandbox、execution world、network 是五个不同问题；
- full/partial enforcement；
- danger-full-access 的真实含义；
- Web UI 无 auth/TLS 与 web_fetch 私网风险。

### 第六部分：与 Claude Code、Codex、OpenClaw 对照
- 只谈宿主抽象、组合单位、入口形态和状态边界；
- 强调 Codex/Claude Code 在 Harness 内是 subagent backend；
- 相同名词不保证相同权限/生命周期；
- 不做“谁更强”的排行榜。

### 结尾：Developer Preview 值得观察，但应如何试用
- 固定 SHA、dump config、最小插件集；
- local-first、loopback、外部网关；
- 数据备份与回放兼容 gate；
- 把 Harness 看作一种 Agent 系统架构实验，而非已冻结平台标准。

## 结论

DeepSeek Harness 最有辨识度的地方，不是插件数量，而是把**替换性、作用域、生命周期和可重建性**放进同一套 Cordis 组合模型。模型与工具可换并不新鲜；把 agent loop、session、UI、storage、scheduler 也降为插件，并要求它们通过 service/event/effect 和 durable log 协作，才是其“harness”含义。

同时，这种高度开放的组合性把责任推向部署者：必须理解每个 seam 的安全边界，审查第三方插件，区分 profile/preset，处理数据版本，并接受 preview 阶段的接口破坏。官方文档在不少关键点上相当坦率——sandbox 不管网络、Web server 无认证、fetch 不挡私网、schedule 至少一次、storage 暂无迁移。正确的评价不应是功能多寡，而应是：它提供了一套结构清晰、约束鲜明、仍在快速变化的 Agent 运行时实验场。

## 16. 组合视角补论：从一次请求看完整运行时

前面的子系统若只按目录阅读，容易重新落回“功能清单”。Harness 的真正设计要从一次请求如何穿过这些 seam 来理解。

### 16.1 启动阶段：先组合产品，再创建 Agent

进程启动时，profile 按声明顺序展开 bundles，随后应用 profile、home 与命令行 patch。这个阶段确定模型 adapter、存储 backend、持久化、sandbox policy、approval、Web 或 headless host 等“站立能力”。Cordis 依据 `inject` 等待 service 依赖满足，并把每次注册放进 effect 生命周期。最终得到的不是一个不可变全局单例集合，而是一棵可卸载、可被上层 row 替换的插件树。

创建 Agent 时，preset 的 standing composition 进入该 Agent 的 scope。工具、skills provider、prompt section 等注册到 agent context，因 ScopeKey 只对该 Agent 可见，并由同一 scope 的 disposer 所有。全局 registry 与 scoped layer 在读取时合并；同名 scoped 项可以遮蔽 global 项。这个机制使“同一进程中两个 Agent 有不同工具与技能”成为组合结果，而不是每次执行时手工判断 session id。

但 scope 不是进程隔离。插件代码仍运行在同一宿主信任域内，能够拿到哪些 service 取决于 context 与 composition。若恶意或错误插件被挂到 host/global context，它可能扩大影响范围。部署者应把 scope 理解为架构可见性与清理边界，而不是对不可信代码的安全沙箱。

### 16.2 输入阶段：一个 inbox，多个来源

人类 prompt、subagent followup、scheduler reminder、goal continuation、文件变更注入等最终都经过 Agent inbox。设计坚持“一条 FIFO 主线”，避免 scheduler、subagent 或 workflow 各自维护第二套 turn queue。turn 在 claim 前开始，`agent/pre-step` 可以拒绝或改写输入；即便首个 claim 被拒绝或变空，也会关闭一个没有 step 的 durable turn，留下尝试发生过的事实。

这条规则看似增加日志噪声，实则支持运维解释：没有模型请求不等于什么都没发生，可能是策略拦截、取消或空输入。对审计系统而言，区分“未发生”和“发生但未进入模型”非常重要。

### 16.3 请求阶段：动态能力被固化为可重建快照

每个 step 开始时，系统读取 prompt sections 和 tool schemas。Skill catalog 只提供摘要，模型需要某项 skill 时再调用工具加载正文；这避免所有技能常驻上下文。模型 route、rendered system prompt、工具 schema 被写成 request header 快照；route capacity 另记 request context。由此，即便插件后来卸载、配置改变或 provider 更新，旧请求仍能从日志解释。

这种“先动态组合，再把有效请求固化”是 Harness 很关键的折中。完全动态会破坏重放，完全静态又失去 per-agent 重组。它没有试图让未来插件恢复过去代码，而是保证过去送给模型的有效 envelope 有日志证据。

### 16.4 工具阶段：可见性、审批、隔离是串联关系

工具 schema 出现在 prompt，只证明模型能看见入口。调用后仍会穿过 pre-execute、execute、post-execute 等事件；具体 consumer 再解析 approval 与 sandbox policy。一次 shell 调用可能经历：工具 registry 命中、参数校验、审批策略判断、为当前 session 解析 sandbox mode 与 workspace root、sandbox provider 把 argv 包装、subprocess provider 在相应 execution world 启动、结果写回 `tool/result`。

这里至少有四个不同失败：工具不存在或 scoped 不可见；审批拒绝；sandbox backend 不可用或仅 partial；命令自身失败。官方为 runner failure 与 sandbox denial 使用不同 stderr 分类，正是为了不把“隔离器没启动”误报成“任务失败”，也不把“隔离成功阻止写入”误报成基础设施损坏。运维指标应保留这种错误身份，不能只统计一个 tool error。

### 16.5 子 Agent 与 Workflow：委托不跳过宿主规则

一次性 subagent 请求先检查选定 provider 的 capability flags。in-process child 可以接受 tool filter、persona、depth 和 structured output；外部 provider 若不支持应直接拒绝，而不是静默降级。可继续 child 的 durable descriptor 写入 child Session，进程内 Activation 只是一段驻留期。父 Agent 结束一个调用，不代表 child 身份消失；下一次 followup 可从 persistence 冷恢复。

Workflow 把模型生成脚本放在 worker thread 的 VM 中，但脚本的 `agent()` 仍通过同一个 subagent seam。脚本不能任意替换 engine-wide provider 或总 child cap；meta 在执行前按数据校验；取消后有有界清理。这种设计把“不可信编排逻辑”和“有权限的 Agent 创建”隔开了一层。不过 worker VM 也不应被夸大为操作系统安全边界，真正的文件与进程安全仍由 child 的工具、sandbox 和 execution provider 决定。

### 16.6 持久化阶段：三类状态不要混存

第一类是 Session log：一切影响交互重建的 durable facts，包括消息、工具、request envelope、schedule change、workflow presentation 等。第二类是 Storage domain：设置、业务索引等非会话日志数据，走 typed KV 与 backend route。第三类是纯运行时状态：live Agent、Activation、AbortSignal、provider handle、effect disposer，它们不能被 JSON 日志直接恢复。

这三分法避免了常见错误：把 live handle 序列化会产生假恢复；把所有设置塞进 Session 会污染对话历史；另存一份 message history 会与 canonical events 分叉。代价是插件作者必须明确新状态属于哪类，并设计 seed、replay、dispose 与版本错误语义。

### 16.7 Scheduler 展示了“持久状态”和“持续服务”的区别

Reminder rule 写进 Session 后可跨重启存在，因此是 durable；但 timer owner 只在 Session live 时存在，因此不是持续外部服务。Session 重开会把过期提醒折成 overdue，再等 Agent idle 后 enqueue 普通 followup。投递没有独立 Web receipt，也不保证模型成功回答或用户阅读。

这对产品文案很重要：“可恢复的会话提醒”是准确描述，“后台通知系统”则会造成错误预期。若业务需要关机后准时推送、跨设备通知、去重收据或 exactly-once job，应该另建外部 scheduler/queue seam，而不是在当前 session-local 能力上添加不实承诺。

## 17. 插件作者的 API 与生命周期检查表

### 17.1 定义能力前

先判断是复用现有 service method、监听已有 event，还是确实需要新 seam。若新能力可替换，应同时设计 Definition、Provider、Consumer，避免 consumer 直接 import concrete backend。选择事件域时问三个问题：事实需要重启后存在吗？若是，扩展 SessionEventMap；行为只在工作进行时拦截吗？使用 agent/tools event；它是跨 loop 的策略或 adapter 吗？放 capability domain。

### 17.2 注册时

- 用 `inject` 声明 required service，不依赖偶然 mount 顺序；
- 决定注册在 host context 还是 agent scope，默认最小可见；
- 所有 listener、provider、tool、prompt section 都返回精确 disposer；
- 若多个资源的 teardown 有顺序要求，放入同一 effect；
- registry 对重复名、唯一 provider、named multi-provider 的规则要 fail loud；
- 远端 discovery 放进可取消的异步调用，不让 `apply()` 无限等待网络。

### 17.3 执行时

- 传播 AbortSignal，并区分“取消请求”与“已经被 inbox 接受后的独立所有权”；
- waterfall observer 必须调用 `next()`，只有真正拥有决策时才短路；
- 对 unsupported capability、ambiguous provider、missing backend 明确报错，禁止猜测或 first-wins；
- tool visibility 与 execution authority 同时收紧，不能只藏 schema；
- 外部内容、skill body、workflow script 都按不可信数据处理，权限仍由工具层执行。

### 17.4 写日志时

Session event payload 必须是 lossless JSON。影响模型请求的内容要能从日志重建；纯 UI meta 也要序列化稳定，保证回放一致。事件版本演进应先规定 unknown reader 行为，只有完全不影响重建的信息才能标记 ignorable。插件扩展 union 后，公共 consumer 应有容忍未知插件事件的 default 分支，而不是把封闭世界假设写成 `assertNever`。

### 17.5 卸载与失败时

dispose 要幂等，竞态调用等待同一 quiescence；先停止接收新工作，再 drain/abort 已有工作，最后注销服务并释放 medium。已经 durable commit 的写入不能因 observer 抛错而回滚假象；尚未 publish 的失败则要清理 partial resource，且不返回看似有效的 id。对 worker、SSE、terminal、child Agent 这类可能不自然结束的资源，应设置有界取消或强制关闭路径。

## 18. 运维落地清单

### 18.1 安装与升级

记录 npm 包版本、仓库 SHA、Node/pnpm 版本和最终 lockfile；保存 `--dump-config` 输出作为部署物。升级前在副本上加载旧 Session 和 Storage，验证 unknown event、header version、domain version；比较 profile/bundle row id 与整行 config 替换；重新构建所有树外插件并执行一次 mount/unmount 压测。

### 18.2 暴露面

默认保持 loopback。若必须远程访问，在 Harness 前放 TLS 终止、强认证、会话授权、CSRF/origin 校验、速率限制与审计代理；不要仅把 host 改为 `0.0.0.0`。对 `web_fetch` 配置 egress proxy 或网络 ACL，阻断 metadata endpoint、RFC1918、loopback、内部 DNS 和重定向绕过。凭据不要写进 profile patch 或 Session log，使用 credential service 与最小权限 token。

### 18.3 执行面

生产启用 shell 前，在真实内核/平台执行 sandbox functional probe，拒绝业务不接受的 partial enforcement。将 workspace 放在独立低权限账户可访问范围，限制宿主文件、socket、Docker daemon 和 SSH agent。需要网络或进程级隔离时，选择容器、microVM 或 remote execution 整体 seam，而不是期待 filesystem sandbox 自动覆盖。

### 18.4 可观测性

至少区分 Agent turn、LLM adapter、tool policy、approval、sandbox runner、provider、storage/persistence barrier、workflow/subagent lifecycle 八类错误。Session log 是交互证据，但不应无限制暴露其中 prompt、工具参数、文件内容或凭据。Telemetry consumer 应按数据分类脱敏，并验证 fork、compaction、replay 后的 trace 对齐。

### 18.5 故障演练

模拟模型流中断、工具执行中断、插件 HMR、存储写失败、进程在 scheduler admission 与 dispatch append 之间崩溃、workflow worker 卡死、subagent parent 退出、Web SSE 未关闭。验收标准不是“没有错误”，而是：日志保持合法前缀、无 orphan handle、dispose 有界、重开能解释中断、不会把未执行误报为成功、at-least-once 场景允许识别重复。

## 19. 设计判断：优势来自哪些约束，代价又在哪里

### 19.1 “无特权核心”的真实收益

传统 Agent 框架常把 loop、tool dispatch、history 和 UI protocol 焊成一个中心对象，扩展点只是若干 callback。Harness 更激进：连 loop 与 session projection 都能替换。这样做的收益不是代码更少，而是架构决策可以通过配置组合实验。例如，同一模型工具 vocabulary 可以更换 web provider；同一 subagent tool 可以路由到进程内 child、fork、ACP 或外部产品；同一 filesystem/subprocess execution world 可以整体移到远端，而上层 Bash、PTY、LSP 不必各自产生远程分支。

可替换性成立的条件，是 seam 的“窄腰”足够稳定。官方因此投入大量文档描述 payload、error identity、dispatch mode、dispose、cancellation、durability 和 unknown-reader 行为。若只复制 “Everything is a Plugin” 口号而忽略这些契约，系统会退化成大量互相猜测的插件。换言之，Harness 的核心其实不是某个不可替换包，而是一组不可随意破坏的组合规则。

### 19.2 事件溯源让调试更强，也提高演进成本

把模型可见信息、请求 envelope、raw stream、工具结果都记录下来，能支持高保真 UI、重放、fork、telemetry 和 postmortem。尤其把 attempt、rejection、interruption 留成合法日志前缀，使“为什么没产生回答”可被解释。相比只保存最终聊天文本，这是一项明显的可运维性投资。

代价是事件 schema 变成长期数据 API。插件新增 required event，旧 reader 可能无法打开新日志；变更 request reconstruction 需要迁移或明确拒绝；raw chunk 与 meta 增加存储规模和隐私面。Developer Preview 阶段采取 fail-closed 是合理保守选择，但生产平台最终仍需要版本治理、迁移工具、保留策略与敏感字段规范。否则“完整记录”可能从优势变成升级负担。

### 19.3 动态配置扩大实验空间，也扩大审计面

profile、bundle、patch、表达式 config、scoped preset 让同一发行版形成不同产品。这非常适合框架开发者：功能不必 fork，替换 row 即可。然而最终行为不再能从单个 `package.json` 或默认配置判断，必须查看完整 layer order 和 dump config。patch 替换整份 config 还意味着上游新增安全默认字段时，下游旧覆盖行可能继续保留旧形状或触发不兼容。

因此部署审计单位应是“解析后的插件树 + 精确代码版本”，而不是“安装了 dsh”。配置表达式应视为代码近邻：限制谁能写 home/profile patch，变更走 review，禁止从不可信仓库自动加载任意 tree-out plugin。Developer Preview 期间每次升级都应重新生成并比较树，而非只阅读 changelog。

### 19.4 渐进披露是上下文治理，不只是 UX

Skill 先列摘要、再按需读取正文；Web search 返回规范化 citation，再由 fetch 获取内容；subagent 将大任务放进 child Session；workflow 只把结果和展示事实带回 parent。这些机制共同减少主 Agent 常驻上下文。它们也形成权限检查点：发现某资源不代表已经加载，看到某工具不代表执行成功，收到 child id 不代表 child turn 已完成。

反过来，渐进披露可能增加模型的调用步骤与失败模式。目录 incomplete、provider invalidation、skill 同名遮蔽、child cold resume、fetch provider ambiguity 都需要明确错误语义。好的 preset 应在上下文成本、调用可靠性和权限最小化之间做选择，而不是把所有 provider/tool/skill 一股脑挂给每个 Agent。

### 19.5 UI 是投影，不应成为事实源

Web UI 的 conversation nodes、workflow cards、approval selector 都从 Session 或服务投影状态。HTTP server 只负责 carrier，前端插件负责资源与 `/api` bridge，headless profile 可完全没有 server。这一分层让其他 editor/client 复用 `ctx.agents` 与 `session/event`，也避免“浏览器当前显示什么”决定 durable truth。

运维上要警惕 UI 操作与 durable commit 的时间差。按钮显示已提交、inbox 已接受、工具已批准、schedule 已 dispatch，各自可能处于不同边界。客户端应根据服务返回和日志事件更新状态，断线重连后从 authoritative projection 重建；不要依赖内存 toast 或乐观卡片作为审计凭证。

## 20. 研究限制与复核方法

本报告严格限定在两个官方入口，未引用社区评测、第三方教程或其他产品文档。目录通过固定 commit 的 GitHub Contents API 取得；正文按任务主题逐页读取并在每页后追加笔记，没有 clone 或批量读取全仓库。对 Claude Code、Codex、OpenClaw 的段落因此只是架构重心对照，不声称完整刻画其内部实现，更不提供性能或功能排名。

“版本”采用双重标识：根包 `0.1.0-rc.5` 表示发布版本，HEAD `47f943859bef60e4160492346772ded9b24f765a` 表示本次文档精确快照。后续读者复核时应优先打开带 SHA 的链接；master 页面可能已改变。若官方站点、npm 包与仓库 HEAD 在未来不同步，应分别记录三者时间点，不能用当前 README 推断旧部署。

本文没有运行 dsh、构建源码或验证平台 sandbox，只研究官方声称与设计契约。因此关于 full/partial enforcement、provider 可用性、性能、资源占用的结论必须在目标环境实测。官方文档写明的限制可作为最低风险清单，却不能替代渗透测试、供应链审计和故障演练。

## 21. 最终采用建议

若目标是研究可组合 Agent runtime、开发自有 provider 或验证 event-sourced conversation，DeepSeek Harness 值得以受控 preview 方式试验：从 web/headless 模板之一开始，固定 SHA，保留最小 bundle，先写一个低权限 scoped plugin，观察注册、replay 与 dispose，再逐步加入 subagent/workflow/storage。这样能真正检验 Cordis 的时空组合价值，而不是只体验默认 UI。

若目标是立即承载公网多租户、无人值守高价值操作或严格离线调度，则当前官方边界提示需要额外平台工程：身份与租户隔离、TLS/origin、网络 egress、强执行隔离、数据迁移、外部 scheduler、跨进程事件和稳定兼容政策都不能仅靠默认组合获得。最稳妥的态度不是否定 preview，也不是把插件化等同成熟，而是把它当成架构能力强、边界说明清楚、产品契约尚在冻结前的基础设施候选。
