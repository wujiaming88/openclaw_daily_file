# 全球 AI Agent 研究周报 · 第 24 期 研究母稿（2026-11-09 ～ 2026-11-15）

- 运行日：2026-11-16（Asia/Shanghai）
- 窗口：2026-11-09 00:00 ~ 2026-11-15 24:00（CST）= 2026-11-08T16:00Z ~ 2026-11-15T16:00Z
- 期号：第 24 期（上期第 23 期，窗口 2026-11-02 ~ 11-08）
- 读者：R1 开发者（主）/ R2 架构负责人（协同）
- 本文为冻结母稿（全量研究版）：含覆盖表、发现层摘要、主线专题、综合层/周环比、证据等级与来源。读者稿另见 `reader.md`。
- 证据级：A 可核原始事实；B 具名披露/研究结果（未独立核实）；C 有限范围独立佐证；D 欠证/争议。每条主张单独定级。

## 一、信息面摘要

读者本周要回答的问题：**Agent 的能力边界这周是从哪一层推动的——模型、工具协议、还是运行时？**

答案偏第三层，而且比上期更具体。编码 CLI 的版本节奏没有停（Claude Code 四个版本、Codex 夜间线、Gemini CLI 两个版本），但真正改变使用方式的不是模型权重，而是**动作空间本身被换掉了**：browser-use 1.0 删掉 DOM serializer 与 action schema、删了 136,866 行代码，让模型在持久 Python REPL 里直接对 CDP 写代码；两天后 Claude Code 2.1.323 加入实验性 Code Mode，Claude 写 JavaScript 调用工具。两条产品线各自独立，指向同一件事——**一次动作不再是一个结构化调用，而是一段程序**。

这让上期留下的问题变得更尖锐。上期的主线是「执行面分层、授权层最薄」；本周的变化是：授权的最小单位也跟着变了。当动作是一段代码，逐条命令批准还能批准什么？

须看见的对象类型：编码 Agent/CLI/IDE；开源框架（Gateway 与编排 SDK 两条栈）；浏览器/Computer Use；企业 Agent + MCP 协议/评测/工程（memory、sandbox、permission、audit）。
须看见的一手入口：GitHub releases/tags/commits Atom、官方 changelog、规范仓库 commit/SEP、npm/PyPI 版本元数据、benchmark 方法与结果页、HN Algolia、arXiv API。
信号类型：release / 破坏性变更 / 架构变更 / 新范式（code mode）/ 安全研究 / benchmark 方法论 / 协议与扩展生命周期 / 治理。

## 二、主线专题：动作空间换成了代码——一次调用变成一个程序

### 2.1 一周里两次「删掉 schema」

**2026-11-10 10:40 CST**，browser-use 发布 **1.0.0**，标题 "CDP is all you need"，正文第一行：

> −136,866 lines. 80% of the library deleted.

新链路是 `task → 模型写一个 cell（new_tab(url); bu.click(41); js(...)）→ REPL 在 Chrome 上经 CDP 执行 → 输出回模型 → finish(result)`，正文原话 "No DOM serializer, no action schema, nothing in between." [A｜release 正文]

**2026-11-12T22:12Z（11-13 06:12 CST）**，Claude Code **v2.1.323** 发布，changelog 第一条是 Code Mode：

> Added Code Mode, an experimental opt-in in which Claude writes JavaScript to call its tools; see https://code.claude.com/docs/en/code-mode to turn it on, or to turn it off for an organization

[A｜官方 changelog，读取 2.1.323 全节]

两家没有互相引用，做的事却是同一件：**把「模型逐次选择工具、逐次读结果」换成「模型写一段代码、运行时替它调工具」**。browser-use 删掉的是 DOM 序列化器与动作 schema，Claude Code 删掉的是「每个工具一次往返」的节奏；两者都把动作空间从「有限的动词表」换成「一门语言」。

### 2.2 机制一：为什么代码更省——中间结果不再进上下文

不开 Code Mode 时，Claude 逐个请求 Bash/Read/Edit，每读一次结果再决定下一步；每一次结果都要作为消息进入上下文。开启后，Claude 写一段 JavaScript，由 Claude Code 在你的会话里执行。官方示例（原文照录）：

```js
const files = await $`rg -l "function retryPolicy" src`.text();
const target = files.trim().split("\n")[0];
await edit(target, "maxAttempts: 3", "maxAttempts: 5");
({ edited: target, tests: $`npm test -- retryPolicy`.nothrow() });
```

shell 用 `$` 模板串，文件编辑用 `edit(path, old, new)`；一段代码可以并行跑多条命令、把上一个结果直接喂给下一个调用、只把需要的片段 `return` 给模型。`files`、`target` 留在运行时里，不进上下文。[A｜官方文档]

browser-use 走的是同一条账，而且给出了数字。1.0.4 的 release 正文解释了一个 705 步任务的成本：它读了 **27.8M input tokens，其中只有 1.6M 来自 prompt cache**——原因是旧实现每来一张新截图就改写更早的消息，**每次剪枝都打断 provider 的 prompt cache**，截图密集的运行几乎每步都按全价付输入。改成累计 20 条再批量剪枝后，BU Bench v2.1（200 任务）分数持平（**76.1 vs 76.0**），每任务模型成本从 **$0.434 降到 $0.208**。[A｜release 正文；B｜厂商自测基准]

也就是说，这一轮成本下降主要不是模型变强，而是**上下文结构变了**：中间变量留在运行时，历史不再被反复改写。两周前的第三方测量（LangChain 用 Stagehand 的 code mode 跑 WebVoyager：通过 **90%**、总成本 **$1.98**；Playwright MCP 通过 **78%**、**$26.71**，约 13 倍）与本周的一条厂商自述（Port of Context：单次输入 token 从 **93.6k 降到 31.8k**）指向同一个方向。[A｜方法；B｜benchmark/厂商自述，均未独立复现]

### 2.3 机制二：代码在哪里跑、谁来批——四种答案

code mode 把一个问题拆成了两个：**代码在哪执行**、**授权在哪一层生效**。本周能观察到的四种答案，正好排成一条从「信任主机」到「隔离 guest」的轴。

**（1）Claude Code：会话内 REPL + 逐调用规则。** 代码由 `REPL` 工具在你的会话里执行；代码里的每一次工具调用仍走 `deny`/`ask` 规则与 `PreToolUse` hook，不需要改 matcher。官方给的排查入口是：hook 匹配 `REPL`，从 `tool_input.code` 读 JavaScript。运行上限是前台 **10 分钟**（含等权限提示的时间）、后台 **2 小时**（需以 auto 或 `bypassPermissions` 启动）。可见性也变了：会话里看到的是工具调用（如 edit 的 diff），不是代码；按 `Ctrl+O` 才看到折叠的 **Code** 行。[A｜官方文档]

**（2）browser-use：持久 Python REPL 直连 CDP，脱敏不是隔离。** 1.0 把 CDP 直接暴露给模型写的 Python（`bu.click(41)`、`js(...)`、`new_tab(url)`），工具面就是语言；代价写在正文里——`sensitive_data` 配 `type_secret()` 会从 cell 输出、checkpoint、tool result 与最终结果中脱敏，但官方明确标注 **"Not a sandbox"**。域名限制（`allowed_domains` / `prohibited_domains` / `block_ip_addresses`）在所有浏览器模式生效；1.0.1 补的一个洞正是「`--mcp` 配了 `allowed_domains` 仍可被云浏览器绕过」。[A｜release 正文]

**（3）OpenClaw：工具桥 + 两种执行器，权限留在 Gateway。** OpenClaw 的 Code Mode 不是本周新功能（2026.10 起已在），但它是目前文档写得最细的实现：模型可见工具只剩 `exec`、`wait` 与少数 direct-only 工具；`exec` 在所选执行器的 worker 线程里求值模型生成的 JavaScript；每个启用的非 MCP 工具在 guest 程序里暴露为 async 全局函数，MCP 工具经桥接；**权限、审批与会话归属仍留在 Gateway**。执行器二选一：

- `node`（默认）：Node.js `node:vm`，跑在 worker 线程。文档原话：**"Node's node:vm is not a security boundary."** worker 只是把计算挪出 Gateway 事件循环，**共享 Gateway 进程的 OS 权限**，因此「Treat Node Code Mode as trusted host execution」。
- `quickjs`：QuickJS-WASI 在 worker 线程里，文档称 **"Hardened guest isolation"**，挂起状态是序列化的 VM 快照。

[B｜当前态文档，非窗内发布]

**（4）Cloudflare：V8 isolate + 绑定授权（2025-09-26，背景，非本周）。** 把 MCP server 的 tool schema 转成 TypeScript API，只给模型一个「执行 TypeScript」的工具；代码跑在 V8 isolate（毫秒级启动、几 MB 内存），无外网，只能经 RPC 回到 agent loop 调**已授权的 MCP 绑定**；token 留在 supervisor，AI 写的代码拿不到密钥。[A｜官方博客]

四种答案的差别不在「有没有沙箱」，而在**代码与凭据、代码与审批的相对位置**：Claude Code 把代码放进会话、靠逐调用规则与 hook；browser-use 把代码放进 REPL、靠域名规则与脱敏；OpenClaw 把代码放进 worker/guest、靠 Gateway 持有权限与审批；Cloudflare 把代码放进 isolate、靠绑定代替网络与密钥。**这是本周唯一值得架构负责人带走的一张对照表。**

### 2.4 为什么这一周特别：文本规则同时被承认不是边界

code mode 并没有绕过权限规则。Claude Code 文档明确写，代码里的每一次工具调用仍走 `deny`/`ask` 规则与 `PreToolUse` hook。变化发生在两处更细的地方。

**第一处是 auto mode 的审查对象。** 原文：

> the classifier reviews each piece of code before it runs, not each tool call. It doesn't see values computed at run time, such as a path taken from search output, so keep rules or hooks for calls you must control.

分类器从「逐条调用」变成「逐段代码」，而代码里的路径、参数、目标可能是运行期算出来的——`rg` 的结果、`git diff` 的输出、API 返回值。一段 20 行的代码，写下的时刻是合法的，执行到第 12 行时可能已经在操作另一个目录。这不是实现缺陷，而是「审代码」与「审调用」的固有差别：**代码的语义要到运行期才完整**。

**第二处是文本规则本来就兜不住。** 同一份文档的「What a Bash rule doesn't match」一节自己承认：

> A Bash rule matches the command text Claude writes... It doesn't match the same program invoked in a different form, so a deny or ask rule covers the invocation Claude usually produces and **isn't a security boundary around the program**.

文档给的例子：`Bash(curl *)` 拦不住 `/usr/bin/curl ...` 和 `sh -c 'curl ...'`；`Bash(rm *)` 拦不住 `/bin/rm`、`bash -c 'rm -rf build/'`；`Bash(git push *)` 拦不住 `git -C . push`。官方给的替代只有两条：**sandbox**（不依赖命令文本的文件系统与网络强制）和 **PreToolUse hook**（用自己的逻辑检查完整命令文本）。而沙箱按官方文档只覆盖 Bash/PowerShell/Monitor 及其子进程，Read/Edit/Write/WebFetch/WebSearch、MCP server、hooks 本身都在界外。[A｜官方文档]

把这两点接起来：code mode 让「一次动作」可以是一段程序，文本规则匹配的是程序里写出来的字符串，真正执行的是运行期求值后的调用。规则的用途因此退回它本来的位置——**减少误操作**，而不是当安全边界。

### 2.5 同一版本里的证据：规则引擎一直在漏

v2.1.323 的 changelog 里，与 Bash/权限直接相关的修复有十余条（逐条摘自原文）：

- 对写入 `.git`、`.claude` 等敏感路径的命令仍提供「don't ask again」，而保存的规则并不能阻止下一次提示；
- 某些 `lsof` 命令未经权限提示就运行；
- `cat > file <<EOF` 被显示成 "Read 1 file"；
- `rm` 的权限检查在错误目录下判断，在 bypassPermissions 或 Bash allow 规则下跳过了危险删除提示；
- `--permission-mode auto` 在 auto 不可用时可能以更宽松的模式启动（现改为 Manual）；
- Bash 权限检查漏掉命令的一部分；Bash 沙箱可能在会话中被关闭；
- `Bash(ls*)` 这类带通配符的 allow 规则在某些情况下跳过提示；`Bash(NODE_ENV*)` 改为必须询问；
- `Bash(curl *)` 类 deny/ask 规则漏掉经 `sudo`、`env` 等 wrapper 运行的命令；
- `sandbox.excludedCommands` 可能让未被点名的命令跑在沙箱外；
- Write/Edit 可能写入被 `Read` deny 规则覆盖的路径；
- 特定 zsh 选项下 Bash 命令无提示运行；
- legacy config 安装下 Bash 沙箱未完全保护 Claude Code 自己的配置；沙箱命令可读 config 目录下的文件检查点副本；
- `--settings`/SDK 设置校验失败时，`claude -p` 与 Agent SDK 会**无沙箱**跑 Bash（现改为启动即停）。

[A｜官方 changelog，逐条对读]

一个版本里能列出这么多条，说明这不是某个单点 bug，而是**「用命令文本近似程序行为」这一模型的系统性偏差**：wrapper、相对路径、通配符、heredoc、shell 选项、配置校验失败后的降级，每一个都是文本与语义之间的缝隙。上期 Apiiro 的「don't ask again 把含密命令写进 `.claude/settings.local.json`」是这条缝的另一种表现；本期的修复里也有一条直接对应（对写入 `.claude` 的提示不再提供「don't ask again」）。

### 2.6 影响

**对开发者**：code mode 现在值得试，但要按「实验性」对待。Claude Code 的 Code Mode 只在终端交互式会话、v2.1.323+、且不能经 gateway/Bedrock/Vertex/Foundry、不能用于 `-p`/Agent SDK/VS Code/Desktop；会话只能用同样开着的开关恢复。browser-use 1.0 则是**不兼容升级**：官方要求 `Pin with ==`、所有依赖精确 pin 并提交 lockfile，0.x 里不支持的选项会在启动浏览器或计费之前抛 `TypeError`。

**对架构负责人**：如果团队把「逐条命令批准」当安全边界，本周的证据说明这条边界的作用范围只是「写出来的字符串」。可落地的是三层分工：**OS 沙箱**管文件系统与网络（不依赖文本）、**hook** 管命令文本与代码文本（`REPL` 的 `tool_input.code`）、**规则**管误操作与摩擦。选型时问四个问题：代码在哪个执行器里跑（同进程 / worker / guest / isolate）、凭据在不在代码可达范围内、审批发生在代码前还是调用前、以及能不能看到模型实际写了什么。

### 2.7 局限

- Claude Code 的 Code Mode 是实验性功能，官方声明「可能在任何版本变更或移除」；本报告只描述 2.1.323 文档所述行为，未实测。
- browser-use 1.0 的基准为厂商自测，且正文自曝窗口内 OpenAI 故障（Pi 丢 18/180 次运行、1.0 丢 1 次）；剔除故障后与 Pi 的配对差为 **+1.1 [−3.2, +5.7]**，**不显著**。正确结论是「同等质量、更便宜更快」，不是「更强 6 个点」。
- OpenClaw 的 Code Mode 文档为**当前态**，其引入时间早于本期窗口（2026.10.x 已在），本期只作机制对照，不计为本周事件。
- 「分类器看不到运行期值」是官方文档的自述，未做红队复现；不能据此断言存在可利用绕过。

## 三、编码 Agent / CLI：这周改的是默认值与信任边界

四个 Claude Code 版本、四个 Codex 正式版、两个 Gemini CLI 版本、两个 OpenCode 版本，功能清单都很长；但把「升级后行为会变、且不会报错」的条目挑出来，本周只有一组，而且两家给出了相反的答案。

**Codex 0.169.0（11-13 16:43 CST）把「沙箱可写」与「项目可信」拆成两个判定。** 原文：`codex exec` keeps project configuration and MCP servers disabled in untrusted directories——**即使传了 `--sandbox workspace-write`**；要恢复旧行为必须显式 `--trust` 并保存信任（PR #60041）。理由很直接：项目配置能改模型与审批，项目 MCP server 是任意命令执行，两者都是「仓库能对你施加影响」的入口。0.168.0 同时把权限解析挪到沙箱启动边界，并让读 skill 也受文件系统限制——skill 是模型会主动读的文件，不限制就等于留了一条绕过路径限制的读取通道。[A｜release 正文 + PR]

**Cline 在同周走了反方向。** 提交 `feat(cli): default non-interactive runs to yolo mode (#15644)`（11-11 06:15 CST）把一次性 CLI 运行从 act 模式改为默认 yolo，理由原文是「Nobody is at the keyboard to approve tools in these runs」。但 PR 同时声明 yolo **不是 act 的超集**：一次性 yolo 运行**失去** search、web fetch、apply-patch、skills、ask-question、sub-agents 与 teams，只新增 `submit_and_exit`；作者还自認「Not exercised with a real agent run」。也就是说，同一周里，Codex 用「不信任就不加载」保护 CI，Cline 用「给自主权但砍能力面」保护 CI；前者让既有流水线静默少加载，后者让既有脚本静默提权。[A｜commit + PR 正文；C｜能力得失为作者自述且未验证]

**Claude Code 则把上期 Apiiro 那条泄漏的机制逐条关掉。** v2.1.323 的三条改动直接对应上期的失效路径：「含密、或会被保存到 git 跟踪的 settings.local.json 的 allow 规则，只在本次会话有效、不落盘」；「`.claude/settings.local.json` 在目录后来变成 git 仓库、或换机器时未被全局忽略」；「写 `.git`、`.claude` 的命令不再提供 don't ask again」。v2.1.325 再补两处：已提交的 `settings.local.json` 在仓库某些子目录下不再被当作用户配置；容器内 worktree/submodule 的 `-p`/SDK 运行要等目录被信任后才应用其中的 allow 规则。修法不是「扫描并警告」，而是**改变落盘条件**加**补全忽略的时序分支**——在写入点拦，而不是事后检测。[A｜changelog 原文]

其余三家是维护周：**Gemini CLI** 两版 66 项几乎全是修复，两条值得记的是「判定顺序」——rootless podman 缺 `--userns=keep-id` 会让容器内 UID 映射错位（写文件属主错但不报错），macOS 上必须**先解析文件夹信任再进 Seatbelt**，否则信任决策依据的是沙箱外的路径（#30118、#30164）。**OpenCode** 仓库已迁到 `anomalyco/opencode`（`sst/opencode` 301），v2.3.0 把子代理默认改为后台运行（立即返回会话 ID、空闲时汇报，父会话可并发多个），代价是一组 SDK 破坏性变更：插件仍在加载的 Location 上，`agent.list` 返回已加载的部分，`integration.list`、`usage.limits`、`vcs.init`、`rpc.call`、`artifact.*` 不再等最多 5 秒，依赖「拿到 list 就是全量」的脚本会静默少项。[A]

安静的四个也值得记一句，因为它们决定了本周不该从哪里找主线：**Cursor** 的 changelog 窗内 0 条（最近 11-06）；**Windsurf** 的 changelog 已 308 到 `docs.devin.ai/desktop/changelog`，连续第二周没有独立版本节奏；**Aider** 最后 release 2026-02-12、**Roo Code** 2026-05-15，继续停更；**SWE-bench** 官方仓库最后提交 2026-09-02，窗内 HN 0 命中——**本周没有任何可引用的新 SWE-bench 数字**。

**但默认值的问题不止在配置，还在产物。** 名单外的一条研究给出了本周最刺眼的数字：Claroc Research 11-10 披露，尝试 **43,551** 个 `*.grok.me` 地址，**37,571** 在线，其中 **35,578 个（94.7%）在未登录状态下即可打开**，估计约 **650–800** 个应用含私有数据——样本包括一份标密的入职计划、**594 个**战略账户及其 pipeline 的销售区域图、某医院集团 **3,500+ 员工**的可搜索名册、单个 ICU 病人的检验/影像/呼吸机状态简报。机制有三段，没有一段是沙箱：发布即公网且主机名会进**被动 DNS**（对 `*.grok.me` 做模式搜索即可拿到清单）；发布面板**预选**「Anyone with the link」；团队型应用的登录流程**先把任意 Google 账户加入团队、再检查成员资格**。只改默认值仍可通过链接传播，只改登录顺序已公开的仍可读。[B｜厂商研究，未独立复核；A｜HN 时间与分数]

## 四、开源 Gateway 与框架：发布管线本身成了风险面

**OpenClaw 本周只有一个稳定版 2026.11.3（11-11 02:53 CST），官方标为 Security release、无新功能**（56 PR / 44 commits / 36 contributors）。六类修复指向同一个 bug 类：**空白或缺省值被解释成「不校验」**。空白 TLS 指纹原本会关掉证书校验而不是退回 CA 校验；Gateway allowlist 下动态 shell `test`/`[` 谓词绕过授权自动批准；托管 Signal daemon 与 bundled language server 默认继承 Gateway 凭据；Firecrawl/Exa/Tavily 的搜索缓存跨 API key 复用。修法是把 `blank ⇒ skip verification` 改成 `blank ⇒ CA 校验`，把 allowlist 的匹配对象从字符串前缀改成命令结构，把子进程环境从继承改成最小集，把缓存键加上凭据维度。[A｜release 与 CHANGELOG]

一个必须纠正的版本事实：**2026.11.4 没有发布**。tag 页 404，npm `latest` 仍是 2026.11.3，但 11-13 至 11-15 连续出现四条针对 2026.11.4 的 `release-publish/...` CI tag（apply performance waiver、unblock plugin publication、honor authorized failures、honor exact-candidate failure grants）。这些是发布管线的产物、不是版本；能得出的只是「11.4 进入过放行流程且被判失败/豁免」，不能得出其内容。窗内实际可用的下一版是 **2026.11.5-beta.3（11-15 08:31）**，主题转向大会话内存、重启后的投递安全与 MCP 工具面收敛（deferred MCP 工具加 bounded input hints、去重被包装的结构化结果）。[A｜tag/npm；B｜「放行失败」为推断]

**Hermes v0.23.1（11-10 09:42 CST）** 是一个把约 **618 个 PR** 卷进稳定 tag 的补丁版（commit 记 2,578 non-merge commits、2,781 changed files、+151,690/−62,595），正文只展开一件事：11-09 插件目录站点部署后，`plugin-catalog.json` **超过客户端接受的 2 MiB 上限**，于是每次安装都**静默回退**到随包快照——`hermes plugins install <name>` 找不到新插件、装的是本 release 的 pin、漏掉较新的 `removed` 条目。本版把上限提到 **16 MiB**，但**没改回退的可观测性**，停在 v0.23.0 或更早的安装会继续静默回退。v0.23.2 停在 rc.8（11-14），窗内无稳定版；完整 curated notes 明说随 v0.24.0 发布。[A｜release 正文]

**browser-use 1.0** 见主线专题；它随后 5 天连发 1.0.1–1.0.5，全部在补「把动作空间换成代码」之后的工程缺口：1.0.1 让 `--cli-mcp` 在没有 Chrome 的服务器/CI 上自带 Chromium、并修掉「`--mcp` 配了 `allowed_domains` 仍可被云浏览器绕过」；1.0.3 把 CDP 连接失败从 30 秒缩到 3 秒；1.0.4 改成批量截图剪枝以恢复 prompt cache；1.0.5 加入每次运行一次的模型 judge（输出 `success`、`failure_reason`、`prompt_injection_detected`、`bot_block_or_captcha_detected`、`gotchas`）。[A]

**编排 SDK 这周的主线是「决策模型」。** langchain-core 1.8.0 引入 decision models（PR #41765），langchain 1.5.0 加 model router 与 auto mode middleware（#41766，标 beta），langchain-typesafe 0.1.0 把 TypeSafeClassifier 变成 decision model（#41767），langchain-openai 1.8.0 加面向 GA Decisions API 的 OpenAIClassifier（#41787）。机制上，这是把「这次请求走哪个模型」从 if/else 提升为一个**带类型的对象**：可记录、可断言、可替换成任意实现。同一周 langchain-core / langchain / typesafe / langchain-openai 与 LlamaIndex 全系 integration 都把 Python 最低版本抬到 **3.11**（LlamaIndex 标 BREAKING，逐包 +1 版本），升级前应先查 Python floor，而不是先查 API 变更。CrewAI 三连发里最该记的是默认模型切到 `gpt-6-luna`——不写 model 的 crew 会静默换模型。[A]

平台层没有发布级动作：**Dify** 窗内无 release（最新仍是 11-04 的 v1.19.0，属背景），可见提交全是把测试纳入 strict pyrefly 类型检查；**OpenHands** 三连发都在 Canvas/自动化与 Service accounts、预算 meter 这类可运营性上；**AutoGPT** 两版在做 plan-first 试用、账号删除与 E2B 并发上限。**AutoGen 已确认归档**（README：「archived and no longer maintained by Microsoft」，最后 release 2025-09-30），官方指向 Microsoft Agent Framework；**MetaGPT**（最后 2025-03-09）与 **SuperAGI**（最后 2024-01-16）本周无任何动态，应从选型清单移出。[A]

## 五、浏览器与 Computer Use：迁移单位从「模型」变成「工具集」

**Anthropic 在 11-09 把 CUA 的迁移单位换掉了。** Fable 5.2 / Mythos 5.2 只支持 `computer_toolset_20260801`，原文：a request that declares the earlier `computer_20251124` tool returns a **400 error on every platform except Amazon Bedrock**, where the earlier tool still works。这不是弃用预告，是即刻失效；Bedrock 成了旧工具的兼容孤岛。工具集本身是客户端工具集，一个条目暴露 **17 个成员工具**（screenshot、zoom、各类 click、drag、scroll、type、key、hold_key、wait），成员可按需关；一批动作必须按序执行，任一失败则其余以固定文案回填。截图与文件在你的环境捕获与存储（因此 ZDR 元数据标 eligible），但 Anthropic 仍在服务端对工具返回（含截图）跑 prompt-injection 分类器。[A｜release notes；B｜工具集细节为当前态文档]

同周 **11-12**，Anthropic 上线 self-hosted Claude Managed Agents：整条 Managed Agents 服务（而不只是沙箱）跑在你的基础设施上，agents、sessions、session history 都存在你这里，模型请求发往你选的供应商（默认 Anthropic），需向账号团队申请。这把「会话历史存在哪」这个采购障碍移除了。[A]

**Google 这一周只有「读」，没有「做」。** 11-12 Gemini 进 Chrome 侧边栏，官方用例是 summarize a dense report / compare product details / explain complicated topics，全文没有 click、navigate、act，也没有站点授权模型；Mariner 产品页仍是 301 到 DeepMind 首页。Google 真正的 agent 动作在模型与 API 层：11-10 Gemini 4 Carbon GA、11-11 Decision 1（二值/分类/rubric 决策，零输出 token）、11-12 Gemini 4 Hydrogen GA，后者成为 Gemini Managed Agents 里 Antigravity agent 的默认模型。[A]

**Perplexity 把「沙箱出网」的失效模式讲清楚了。** 11-11《Escaping SPACE: Part II》自述：VM 逃逸任务**零成功**（即便明确指示模型专攻虚拟化层），真正可破的是**部分网络放行下的策略执行**——两条路径：① **DNS 伪造**，agent 有 root 与源码知识时伪造 DNS 响应，把允许域（如 `pypi.org`）解析到自己的回调服务器，随机化的 UDP 查询端口用**包喷洒**打中；② **共享 IP**，连到被允许域与回调共用的 IP，操纵 SNI/Host，或借 Fastly 托管的中继、图片/截图服务取回 flag（走 `1.1.1.1` 的尝试被 403 挡住）。两处已修并复测无绕过，但同一类缺陷在 **10 家第三方沙箱中的 8 家**复现（厂商自述，已走负责任披露）。全文无 CVE 编号、无披露时间线。[A｜厂商一手披露；B｜第三方沙箱结论]

机制上这条比任何成功率都重要：**allowlist 按域名写，运行时却按 IP 连**，中间隔一次 DNS 解析与一次 TLS SNI；只要控制解析或找到共用 IP，就能让「允许的域名」指向「不允许的目的地」。修复必须同时约束解析结果、SNI/Host 与出口 IP 归属，三者缺一即可绕。[A｜机制为原文复述]

同周 11-12 Perplexity 发布 **Decider**：Decider v1.3 与蒸馏版 Flash v1.3，返回是/否、多选、有序评分的概率分布，新增 `locate` 抽取精确文本 span；权重在 Hugging Face、Apache 许可，经 OpenRouter 与 Decisions API 提供。机制是在特殊 marker token 处由 decision head 给候选打分，不生成、零输出 token。它没有声明接入 Comet 或 Computer。[A]

**OpenAI 本周不可评。** `help.openai.com` 的 release notes 与 `openai.com/news` 均 403（带浏览器 UA 仍 403）；可打开的 `developers.openai.com/api/docs/changelog` 在 11 月只有 11-05 GPT-6 Cyber、11-04 图像模型、11-02 GPT-Live-1 三条，**11-09 至 11-15 无条目**。只能写「已核入口无条目」，不能反推「没有发布」。[A｜入口状态]

**还有一个不在浏览器组、但同周发生的编排动作**：11-13 Google Antigravity App **v2.32.0** 加入 **Dynamic Workflows**——「letting agents orchestrate parallel subagents and multi-step tasks in Python using the runtime bundled with the app」。即 IDE 内置运行时，让 agent 用 Python 编排并行子代理；这与 Claude Code 的 Code Mode、browser-use 的 REPL 是同一形状的第三次出现。[A｜changelog 原文]

浏览器基础设施本周补的是「点了之后留下什么」。**Steel** 11-13 用 **rrweb** 做会话录制与 UI 回放（每 **250 ms** 批量、按已发送字节计量、剔除上一个浏览器的批次、从 bfcache 恢复的页面重新快照），配合 11-09 的 `/commands/{executionId}`，第一次能在开源托管浏览器上拿到「动作 id ↔ 页面录像」可对齐的轨迹。**Browserless 2.63.0** 把鉴权挪到**读 body 与校验 schema 之前**（#5670，标 `fix!`），并自述此前默认 Token 从不运行函数式 auth、这类路由可匿名访问；同版 `/sessions` 暴露每会话 CPU 与内存，严格鉴权改为 opt-in（#5676）以保持向后兼容。**Stagehand** 11-11 把六个 harness 的适配收敛到同一个 facade，只暴露 `stagehand_run` / `stagehand_snapshot` / `stagehand_screenshot` 三个工具、**20 步**上限；11-13 把 Browserbase 服务端缓存**从默认开启改为按项目 opt-in**（需邮件申请，未启用时 `cacheStatus` 为 `undefined`）——上期引用的「$1.98 / 90%」是在默认缓存期测的，与新默认值不可直接比。[A｜release/PR/commit；B｜"$1.98 受缓存影响"为推断]

## 六、执行面基础设施：从「产品功能」变成云厂商与基金会的标准件

**KubeCon NA 2026（盐湖城，11-09~12）给出了上期结转线索的答案，但主角不是 Agent Substrate。** 11-10 CNCF 宣布 **NVIDIA 把 OpenShell 捐入 CNCF Sandbox**：定位「保护与治理自主 AI Agent 的开源运行时」，**在 Agent 之外、在 Agent 运行的基础设施里**执行策略；策略语言用 CNCF 项目 **Cedar**；核心贡献者来自 NVIDIA、Red Hat、Docker、Canonical；仓库迁到中立组织 `ai-openshell`。11-11 的 Kubernetes 指南把机制写清楚了：每个 Agent 跑在自己沙箱里，**沙箱外有一个可信 supervisor 决定它能访问什么**——文件系统用 Landlock 限制可写路径，进程启动前降到非 root、去 capabilities、上 seccomp，网络默认拒绝出站、按二进制/host/port/HTTP method 放行，凭据只给 Agent 占位符、由 supervisor 在 provider 允许的端点上换真 key；K8s 侧复用 **Agent Sandbox**（`agents.x-k8s.io`）把每个 Agent 变成 Pod/Service/PVC/Secret/NetworkPolicy，OpenShell 补上 K8s 看不见的三件事：**哪个 Agent 在调用、哪个二进制发的请求、某个 POST 是否允许出集群**。策略可在运行中更新、无需重启。[A｜CNCF 博客 + 指南]

同日 CNCF 年度里程碑公告把 **Agent Substrate 与 OpenShell 并列为新 Sandbox 项目**，并列出 gVisor、KubeRay、OpenRL 等贡献；但 **Agent Substrate 本周没有新阶段、没有新版本**——属于 KubeCon 场合的正式确认，不是新事件。这一点必须与上期的「宣布捐赠」区分开。[A]

**AWS 在 11-09 把硬件隔离沙箱做成默认基础设施。** **Nitro Sandboxes** 以 Nitro Hypervisor 管理的轻量 VM 形式提供，可用于 **EKS Pod、ECS Task 或 EC2**，每个工作负载（含其中的 Agent）获得独立硬件隔离 VM；跑在客户自己的 EC2 上，接近原生性能；可通过**密码学 attestation** 只向证明完整的 Sandbox 释放 secret；EKS/ECS 开启是「一行改动」，Pod Identity、VPC CNI、EBS/EFS/S3、CloudWatch 照常；所有商业区域可用，**不额外收费**。[A｜AWS What's New]

**Kubernetes 原语侧同步推进。** `kubernetes-sigs/agent-sandbox` **v1.0.11（11-13 07:19 CST）** 把浏览器与文件流补进沙箱路由：路径前缀路由默认重写上游 `Set-Cookie` 的 path 与重定向 `Location` 到前缀下（旧行为可关）、Python SDK 进程信号默认 **5 秒**超时并抛 `TimeoutError`、`agent_sandboxes` gauge 新增 `operating_mode` 标签（Running/Suspended）；SDK 增加 mkdir/move/copy、append/createOnly、递归 list、router 隧道；sandboxd 拒绝 PTY stdin EOF、拒绝 FIFO/设备文件、删符号链接只删链接本身。三项需动作的破坏性变更已写进 release notes。[A]

**隔离与生命周期正在被拆成两个采购项。** gVisor **20261109.0（11-12）** 给 runsc 加了可编程 Go client 的 **pause/resume/state**——正是长任务 Agent 沙箱需要的「快照—恢复」接口；而 Agent Substrate 管的是会话空闲快照与 <500ms 恢复。两者是同一能力的两个层次：**内核隔离边界**（gVisor/microVM/Nitro）与**会话生命周期**（Substrate/agent-sandbox）。E2B 2.64.0（11-14）则补企业身份：OAuth access token（`Authorization: Bearer` + `X-Team-ID`）替代长期 API key，模板可调 CPU。[A]

## 七、协议与评测：定规矩的一周，旧榜只维护不刷新

**MCP 本周没有新规范版本，但把「下一版什么时候来」制度化了。** 11-11 官方博客宣布规范发布改为**固定六个月一次**，一般在 **3 月与 9 月的最后一个周二**；下一版目标 **2027-03-30**（版本号即日期）。倒排里程碑：发布前 **8 个月**开始规划、**6 个月**开始 Core Maintainer 评审、**2.5 个月** soft freeze（进版提案必须 Final 且已合并）、**1.5 个月** Tier 1 SDK beta、**1 个月** hard freeze（只收关键安全/正确性/互操作修复，需全员投票）；未就绪的提案顺延到下一版、不拖累整版。同文把 **Release Manager** 变成正式角色，Luca Chang 加入 Den Delimarsky 与 David Soria Parra。这与上期记录的 SEP-3398 是同一条线的落地。[A｜官方博客]

**协议层唯一的新能力是「文件搬运」扩展草案（11-10）。** 扩展标识 `io.modelcontextprotocol/files`，用 **`x-mcp-file`** 标注工具参数；小文件 base64 内联、受服务端 `maxInlineBytes` 限制，大文件走带外：客户端先只发文件元数据调工具，服务端做权限与配额检查后返回 `upload_required` + `uploads[]` + `requestState`，客户端用 HTTPS PUT 上传，再带原样 `requestState` 重试；服务端校验 `requestState` 未被篡改、与原始调用匹配、文件已到达且大小/类型正确，才执行工具。`credentials` 分 `omit`（不带 MCP 凭据、靠预签名 URL）与 `include`（只对 MCP 地址下的 path 或同源 URL 附凭据），客户端必须拒绝重定向、拒绝目标自带 `Authorization`。官方明说 digest 一致只证明字节匹配、不证明文件安全。这是**把「大对象」移出模型上下文**的协议级版本——与本周 code mode 的动机同源。[A｜官方博客，草案]

治理侧同周把 SEP 入口从「找个人 sponsor」改成「找 Working Group sponsor」（#3529，11-12）：WG 赞助是常规路径，Core Maintainer 个人赞助成为例外，尚无赞助者的提案以 draft PR + `wg-support-needed` 标签存在、不占 SEP 编号。**安全侧最硬的是 Inspector 2.15.0（11-12 08:46 CST）一次修四个漏洞**：fetch guard 拦截 **169.254.0.0/16 之外**的云元数据地址（含阿里云 `100.100.100.200`、Oracle `192.0.0.192` 及其十进制/IPv4-mapped 形式）、event-stream 响应记录设上限、server.json 启动预览显示每个环境变量值并要求确认、mcpdo 守护进程必须先证明持有用户 token。四条没有一条是模型层攻击，全是宿主对不可信元数据、无界流与本地守护进程的处理缺陷。[A]

**评测侧：没有权威榜单在本周刷新。** SWE-bench 最后提交 2026-09-02；WebArena 最后 2025-11-26；OSWorld 是任务与评测器修复；τ²-bench 修 Anthropic adaptive-thinking 的 effort 透传。真正的新东西是 **Google + Artificial Analysis 的 MKA 基准（11-10）**：**200 个任务、10 个垂直、83 种职业**，每题是「资深从业者 3–8 小时」的多步项目，配约 **70 条**专家 yes/no rubric，权重 **75% 事实准确性 / 25% 视觉设计**；所有模型跑同一套开源 harness **Stirrup**，评分用非 Google 模型的 agentic autorater（会打开文件、渲染页面、检查表格公式），与专家一致率 **96%**；公开 10 题、其余私有防泄漏。它把评分对象从「答案」换成了**交付物**。[A｜发布页；B｜排名与成本为自述]

**OSWorld 本周同时是安全事件**：`desktop-env 1.0.3`（11-10）修 **GHSA-8cw3-7xw3-vpph，CVSS 9.3**——evaluator 的 `check_python_file_by_test_suite` 从任务 guest 取 Python 文件、在 evaluator 环境里 import 执行测试套件，导致 **guest 控制的代码以宿主权限执行**（评分前即触发，无需网络/持久化/hypervisor 利用）。修复把测试套件搬回 guest，advisory 同时明写「removes the host-execution sink but **does not authenticate scores**」。**评测环境本身成了攻击面**。[A]

研究侧两块值得记。**memory**：DISCERN 指出企业记忆的召回已接近饱和（保留率与时效性 **0.93–0.98**），未解的是实体/时态消歧与「证据不足时拒答」；MemCredit 把选择标准从语义相关换成决策效用（ALFWorld **86.57 SR@50 vs BM25 65.67%**）；MAPE 用程序演化得到两条规律（保留原始对话作证据、按查询意图组合证据），比手工基线最多 **+12 个百分点**、服务成本仅 **35%**。**安全**：CapLite 测 15 个开源权重模型，13 个 1.7B–12B 的模型写出的策略/图/约束分别让 14、13、11 个模型被攻破，CaMeL 程序最多 **68%** 回合跑不起来；它改为从工具 schema 推导策略，在 **13,935 个**被攻击的 AgentDojo 回合里**零成功**。Intent-Aware 把「是否仍忠于部署目的」做成一等安全对象，四分类 F1 **45%→79%**。[B｜均为预印本，作者自述]

## 八、企业侧：身份、墙，与「谁能代表用户」

**Sierra 在 11-13 发布 Personal Agent Protocol（Poppy）v1.0**，定义「个人 Agent 代表一个用户与一家公司协作」，复用 **MCP、OpenAPI、UCP**，账号访问用 OAuth。协议分五层：Discovery（公司在 `/.well-known/poppy.json` 发布渠道、能力、登录选项）、Operator recognition（推荐 **Web Bot Auth** 签名，让既有 bot 防御在应用处理前认证「这是哪个 Agent 运营方」）、Sessions（个人 Agent 对每个请求签 **`Poppy-Session` JWT**，用短时 delegated key）、Account access（标准 OAuth）、Interaction channels（API / 浏览器 / 公司 Agent）。关键设计是 **User ID 由个人 Agent 分配、在每个公司不同且稳定的 pairwise 标识**——公司未登录也能识别「同一个用户」，但跨公司无法匹配；Session 与账号访问相互独立。落地：**Shopify 全量商户**自动发布 Poppy 文件、**Meta Muse** 每次访问先找 Poppy、设计伙伴从 40+ 增至 **100+**（含 Salesforce、Stripe、Intuit、Cisco、Zoom、Ping Identity、WorkOS）。[A｜发布与规范；B｜伙伴数量与上线效果为自述]

**Harvey 在 11-13 把律所的 ethical wall 做进平台。** 资源（Vault 项目/文件、会话、Review Table）绑定到 Client Matter 及其墙；导入把「事项身份」与「访问策略」分开，两个同步作业（Client Matter sync / Wall sync）跑在 Temporal 上；每次请求**同时检查资源权限与 matter clearance**；失败语义 **fail-closed**——取不到策略就保留上次策略并重试，exclusionary 墙查不全所有人就跳过更新、保留旧策略。最大 workspace 约 **170 万 matter**，picker 迁到 turbopuffer。对 Agent 的含义：**生成物继承源文档的墙**，摘要与分享不能绕过。[A｜工程博客；B｜规模数字]

**Salesforce 11-11 的 SFR-AutoR&D** 是一组端到端跑研究闭环的 Agent：给目标、待改进系统与算力预算，自己提假设、实现、对基线做受控实验，只有被证据支持且证明准确/安全才保留改动；已用于改进 SFR-Embedding V3，并把开源 EmbeddingGemma 2 做成 SFR-Embedding v4；一个改进周期约 **80 小时**。[B｜厂商自述]

**Glean 与 Microsoft Copilot 本周无窗内发布**（Glean 最新 v568 在 11-06；Copilot 博客最新 11-05）；**ServiceNow 与 Coze 本次未取得**（press-room/blogs 403；coze.cn / coze.com 为 SPA 壳，开源仓库无窗内 release）。[A｜入口状态]

## 九、综合层

### 9.1 必出对比表

| 产品/项目 | 版本或日期 | 变化摘要 | 是否破坏性 | 影响面 | 证据级 |
|---|---|---|---|---|---|
| browser-use | 1.0.0（11-10）→1.0.5（11-14） | 删除 DOM serializer 与 action schema，−136,866 行；改为持久 Python REPL 直连 CDP | 是（0.x 不兼容） | 浏览器 Agent 开发者 | A |
| Claude Code | v2.1.323（11-13 06:12） | Code Mode：Claude 写 JavaScript 调用工具；REPL 工具承载，hook 可读 `tool_input.code` | 否（实验性、opt-in） | 编码 CLI 用户、平台安全评审 | A |
| Claude Code | v2.1.323 / v2.1.325 | 含密或会被 git 跟踪的 allow 规则只在会话内有效；补目录后成仓库/换机器/子目录三处时序漏洞 | 否（行为收紧） | 所有使用者 | A |
| Codex CLI | 0.169.0（11-13 16:43） | 未信任目录下 `codex exec` 即使 `--sandbox workspace-write` 也不加载项目配置与 MCP，须 `--trust` | 是（静默不加载） | CI/自动化 | A |
| Cline | 提交 #15644（11-11 06:15） | 一次性 CLI 运行默认改为 yolo；yolo 非 act 超集，失去 search/web fetch/apply-patch/skills | 是（静默提权） | CI/脚本用户 | A/C |
| OpenClaw | 2026.11.3（11-11 02:53） | Security release：空白 TLS 指纹不再关校验、`test`/`[` 谓词需授权、子进程不继承凭据、搜索缓存按凭据隔离 | 是（部分配置需复查） | 自托管 Gateway 运维 | A |
| OpenClaw | 2026.11.4 | **未发布**（tag 404、npm 无），仅 11-13~15 四条 CI 放行/豁免 tag | — | 升级路径 11.3→11.5 | A/B |
| Hermes | v0.23.1（11-10 09:42） | 618 PR 卷包；插件目录 2 MiB→16 MiB，旧客户端继续静默回退 | 否 | 自托管插件生态 | A |
| Anthropic CUA | 11-09 | 只接受 `computer_toolset_20260801`；旧 `computer_20251124` 除 Bedrock 外全平台 400 | 是（即刻失效） | 所有 computer-use 集成 | A |
| Anthropic Managed Agents | 11-12 | self-hosted：agents/sessions/history 全在客户基础设施 | 否（新增选项） | 企业采购 | A |
| Perplexity SPACE | 11-11 | 出网策略可被 DNS 伪造与共享 IP 绕过；10 家第三方沙箱 8 家复现 | —（安全披露） | 托管浏览器/Computer 买家 | A/B |
| Grok Build（名单外） | 11-10 | 43,551 个 `*.grok.me` 中 35,578（94.7%）免认证可开，约 650–800 个应用含私有数据 | —（安全披露） | 产物发布者 | B |
| CNCF / OpenShell | 11-10 | NVIDIA 捐 OpenShell 进 CNCF Sandbox；策略在 Agent 之外、Cedar 语言 | 否 | K8s 平台团队 | A |
| AWS Nitro Sandboxes | 11-09 | EKS/ECS/EC2 上的硬件隔离 VM 沙箱，支持 attestation，不额外收费 | 否 | 云上 Agent 运行时 | A |
| agent-sandbox | v1.0.11（11-13 07:19） | 路径前缀路由（重写 Set-Cookie/Location）、Python 信号 5 秒超时、`operating_mode` 标签 | 是（三项需动作） | 自建沙箱平台 | A |
| MCP | 11-11 | 规范改半年一版（3/9 月最后一个周二），下一版 2027-03-30；Release Manager 正式化 | 否 | 所有 MCP 实现方 | A |
| MCP | 11-10（草案） | 文件扩展 `io.modelcontextprotocol/files`：`x-mcp-file`、带外上传、`requestState` | 否（草案） | MCP server/host | A |
| MCP Inspector | 2.15.0（11-12 08:46） | 修四个漏洞：云元数据地址绕过、event-stream 内存、server.json 环境变量预览、mcpdo 冒充 | 否（安全修复） | Inspector 使用者 | A |
| OSWorld | desktop-env 1.0.3（11-10） | CVSS 9.3：evaluator 执行 guest 提交代码；修后仍「不认证分数」 | 是（评测环境） | benchmark 运营方 | A |
| Sierra Poppy | v1.0（11-13） | 个人 Agent ↔ 商家协议：poppy.json、Web Bot Auth、Poppy-Session JWT、pairwise User ID | 否（新协议） | 商家、IdP、Agent 平台 | A/B |

### 9.2 周环比（第 23 期 → 第 24 期）

**延续**

- **执行面分层**：上期 Agent Substrate 捐 CNCF、Replit microVM、agent-sandbox v1.0.10；本期 OpenShell 进 CNCF Sandbox、AWS Nitro Sandboxes 上线、agent-sandbox v1.0.11、gVisor 加 pause/resume。供给层从「宣布」走到「可用 + 有标准组织」。
- **授权层最薄**：上期 Apiiro 的「don't ask again 写盘」；本期 Claude Code 改落盘条件并补齐三处时序漏洞，同时 auto mode 的审查对象从「每次调用」变成「整段代码」。
- **MCP 治理**：上期 SEP-3398 发布火车、CIMD 上位、Registry 键语义；本期正式公布半年节奏与 2027-03-30、SEP 改为 WG 赞助、文件扩展草案。
- **Gateway 安全补丁线**：上期 OpenClaw 2026.11.1（日志脱敏 fail-safe）；本期 2026.11.3（空白值不再等于不校验、子进程不继承凭据）。
- **评测方法论**：上期 Surge AI harness 收益递减、接管 4.95%、多步 18.5%；本期旧榜只维护、MKA 把评分对象换成交付物、OSWorld 曝评测器 RCE。

**新出现**

- **动作空间换成代码**：browser-use 1.0（−136,866 行、REPL 直连 CDP）、Claude Code Code Mode、Antigravity Dynamic Workflows（Python 编排并行子代理）、OpenClaw 的 `exec`/`wait` 与 node:vm/QuickJS 双执行器。
- **出网策略被证伪**：Perplexity SPACE II 的 DNS 伪造与共享 IP 绕过，10 家第三方沙箱 8 家中招。
- **产物默认值泄漏**：Grok Build 94.7% 免认证（43,551 扫描 / 35,578 可开）。
- **benchmark 成为攻击面**：OSWorld CVSS 9.3，评测器 import 被测代码。
- **Agent 身份协议**：Sierra Poppy v1.0（pairwise User ID、Web Bot Auth、Poppy-Session）。
- **headless 默认值公开分歧**：Codex 要 `--trust`、Cline 默认 yolo。

**消失 / 降温**

- **Cursor**：changelog 窗内 0 条（最近 11-06），上两周的语音/活应用节奏中断。
- **Aider / Roo Code**：继续停更（2026-02-12 / 2026-05-15），本期无任何 release。
- **AutoGen**：已归档，无窗内动态；MetaGPT（2025-03-09）、SuperAGI（2024-01-16）同。
- **SWE-bench / WebArena**：无窗内活动（2026-09-02 / 2025-11-26），本周没有可引用的新分数。
- **Dify**：窗内无 release（最新 v1.19.0 在 11-04，窗外），只有测试类型化提交。
- **Windsurf**：changelog 308 到 Devin Desktop，连续第二周无独立节奏。
- **OpenClaw 2026.11.4**：进入放行流程但未出包，升级路径实际是 11.3 → 11.5。

### 9.3 模块洞察

1. **本周的变量是「动作的形状」，不是模型能力。** 三家产品（browser-use、Claude Code、Antigravity）在五天内独立把「一次调用」换成「一段程序」，MCP 的文件扩展则把「大对象」移出上下文——四件事的共同点都是**让模型只处理结论、让运行时处理载荷**。这解释了为什么本周的成本新闻都来自缓存与剪枝（browser-use 1.0.4 的 $0.434→$0.208），而不是模型降价。
2. **授权的最小单位跟着动作走，而规则引擎是按「文本」设计的。** Anthropic 自己的文档承认 Bash 规则「isn't a security boundary around the program」，同一版本又修了十余条文本匹配缝隙；auto mode 的分类器改成审代码、且看不到运行期值。结论不是「规则没用了」，而是**规则只能当第三层**：沙箱管文件系统与网络、hook 管代码文本、规则管摩擦。
3. **「有沙箱」与「边界成立」是两件事，本周有两条硬证据。** Perplexity 的 SPACE 复盘说明 allowlist 不约束解析结果与 SNI 就可绕；Grok Build 说明发布默认值可以把「私有」变成「可枚举、可写」。两者都不在模型层，而在**运行时与产物的默认值**。
4. **执行面正在变成标准件，采购问题从「有没有」变成「哪一层」。** OpenShell 把策略放到 Agent 之外、Nitro 把硬件隔离做成默认、agent-sandbox 补路由与文件流、gVisor 补 pause/resume——隔离边界、会话生命周期、策略与凭据、审计与身份，四层各有可引用的原文。
5. **协议的竞争从「加原语」转向「定节奏与入口」。** MCP 半年一版 + WG 赞助，Sierra Poppy 抢「个人 Agent 到商家」的入口，两者都在回答「谁在什么时间、以什么身份、能把什么送到哪里」。

## 十、覆盖表（固定对象逐行终态）

| 组 | 对象 | 状态 | 窗内关键锚点 / 核验入口 |
|---|---|---|---|
| A | Claude Code | 有动态 | v2.1.321/322/323/325；Code Mode；settings.local.json 三条修复 |
| A | OpenAI Codex CLI | 有动态 | 0.167.1/0.167.2/0.168.0/0.169.0；未信任目录须 `--trust` |
| A | Gemini CLI | 有动态 | v0.68.0 / v0.69.0-preview.0；信任先于 Seatbelt、podman UID 映射 |
| A | Cursor | 无动态 | changelog 窗内 0 条（最近 11-06） |
| A | Devin / Windsurf | 有动态（Devin）/ 无独立动态（Windsurf） | Devin v3.12.43/57/59；Windsurf 308 → docs.devin.ai |
| A | OpenCode | 有动态 | 仓库迁 `anomalyco/opencode`；v2.2.7 / v2.3.0（子代理默认后台、SDK 破坏性） |
| A | Aider | 无动态 | 最后 release 2026-02-12 |
| A | Roo Code | 无动态 | 最后 release 2026-05-15 |
| A | Cline | 有动态（仅提交） | #15644 非交互默认 yolo；无窗内 release |
| A | Replit Agent | 有动态（非编码线） | 11-12 采购/获客公告，机制未披露 |
| A | SWE-bench（社区） | 无更新 | 最后提交 2026-09-02；HN 窗内 0 命中 |
| B | **OpenClaw** | **有动态（终态）** | 2026.11.3（11-11 02:53，Security release）；2026.11.5-beta.3（11-15 08:31）；**2026.11.4 未发布** |
| B | Hermes Agent | 有动态 | v0.23.1（11-10）；插件目录 2 MiB→16 MiB；v0.23.2 停在 rc.8 |
| B | LangGraph | 有动态 | 1.2.21/1.2.22；子图独立线程流式、namespace 整段匹配 |
| B | LangChain Agents | 有动态 | core 1.8.0 decision models；langchain 1.5.0 model router；Python 3.11 floor |
| B | AutoGen | 无动态（已归档） | README 归档声明；最后 release 2025-09-30 |
| B | CrewAI | 有动态 | 1.15.38–1.15.41；默认模型 gpt-6-luna |
| B | Dify | 无 release | 最新 v1.19.0（11-04，窗外）；窗内仅测试类型化提交 |
| B | LlamaIndex Agents | 有动态 | v0.14.26；全 integration 抬 Python floor（BREAKING） |
| B | Google ADK | 有动态（极薄） | v2.14.1 tracing 修复；adk-go/adk-java 窗内 0 条 |
| B | OpenAI Agents SDK | 无版本/有提交 | 窗内 19 提交（guardrail 跨 resume、MCP v2 并发） |
| B | browser-use | 有动态 | 1.0.0–1.0.5；−136,866 行；1.0.4 成本 $0.434→$0.208 |
| B | OpenHands | 有动态 | 1.38/1.39/1.40；Canvas、Service accounts、预算 meter |
| B | AutoGPT | 有动态 | 0.11.2/0.11.3；plan-first 试用、E2B 并发上限 |
| B | MetaGPT | 无动态 | 最后 release 2025-03-09 |
| B | SuperAGI | 无动态 | 最后 release 2024-01-16 |
| C | OpenAI Operator / ChatGPT Agent | **本次未取得** | help.openai.com 403、openai.com/news 403；developers changelog 窗内 0 条 |
| C | Anthropic Computer Use | 有动态（破坏性） | 11-09 工具集硬迁移（旧工具 400，Bedrock 例外）；11-12 self-hosted Managed Agents |
| C | Google Mariner / Gemini 浏览器 | 有动态（非 Agent） | 11-12 Chrome 侧栏只读；Mariner 页 301 |
| C | Perplexity Comet / Computer | 有动态 | 11-11 SPACE II；11-12 Decider v1.3 |
| C | Manus | 无产品动态 | 最近产品文 11-06（窗外） |
| C | Genspark | **本次未取得** | 四个入口全 403 |
| C | Kimi | 无动态 | kimi.com/blog 最新 2026-10-24 |
| C | Qwen | **本次未取得** | qwen.ai/blog SPA 无日期；RSS 停更 2025-09-23 |
| C | AutoGLM（智谱） | **本次未取得** | 官网仅标题；z.ai/blog 404 |
| C | Browserbase / Stagehand | 有动态 | 六 harness 合并、三工具 facade；11-13 服务端缓存改 opt-in |
| C | Steel | 有动态 | commands API v2、rrweb 会话回放、executionId |
| C | Browserless | 有动态 | 2.61–2.63；先鉴权后读 body（#5670）、会话级 CPU/内存 |
| C | WebVoyager | **本次未取得** | 仓库与作者页均 404（不可写「已删除」） |
| C | WebArena | 无动态 | 最新 v0.2.0（2023-10-21） |
| C | OSWorld | 有动态（安全级） | GHSA-8cw3-7xw3-vpph，CVSS 9.3；desktop-env 1.0.3 |
| D | KubeCon NA / CNCF | 有动态 | 11-10 OpenShell 进 Sandbox |
| D | Agent Substrate | 无新阶段 | 仅被 11-10 里程碑公告列为新 Sandbox 项目 |
| D | gVisor | 有动态 | 20261109.0：runsc pause/resume/state Go client |
| D | OpenRL | 无窗内动态 | 仅被公告列为贡献项目 |
| D | agent-sandbox | 有动态 | v1.0.11；路径前缀路由、5 秒信号超时 |
| D | MCP 规范修订版 | 无新版本 | 仍为 2026-07-28 stable |
| D | MCP 发布节奏 | 有动态 | 11-11 半年一版；下一版 2027-03-30 |
| D | MCP SEP 流程 | 有动态 | 11-12 #3529：WG 赞助为常规路径 |
| D | MCP 文件扩展 | 有动态（草案） | 11-10 `io.modelcontextprotocol/files` |
| D | MCP Inspector | 有动态 | 2.15.0 修四漏洞 |
| D | MCP Registry | 有动态 | v1.8.9；proof 全量校验 |
| D | MCP TS/Python SDK | 无窗内发布 | 2.4.0（10-23）/ v2.3.0（10-02） |
| D | memory / context | 有动态（研究） | DISCERN、MemCredit、MAPE 等 6 篇预印本 |
| D | sandbox / permission / audit | 有动态 | OpenShell、Nitro、agent-sandbox、E2B、Harvey |
| D | SWE-bench（官方） | 无窗内活动 | 最后提交 2026-09-02 |
| D | OSWorld（评测） | 有动态 | 11-12~13 #704–#709 评测器修复；另有安全公告 |
| D | WebArena（评测） | 无窗内活动 | 最后 2025-11-26 |
| D | GAIA | **本次未取得** | 仓库 404/空响应（已试 commits + 主页） |
| D | τ-bench / τ³-bench | 有动态（维护级） | τ²-bench 11-11 修 effort 透传 |
| D | 新榜 MKA | 有动态 | 11-10；200 任务/10 垂直/83 职业 |
| D | 安全红队 | 有动态（研究） | CapLite、Intent-Aware、Harness Matters 等 6 篇 |
| D | Sierra | 有动态 | 11-13 Poppy v1.0 |
| D | Glean | 无窗内发布 | 最新 v568（11-06） |
| D | Harvey | 有动态 | 11-13 ethical wall |
| D | Salesforce | 有动态 | 11-11 SFR-AutoR&D |
| D | ServiceNow | **本次未取得** | press-room/blogs 403；investor news JS |
| D | Microsoft Copilot Agents | 无窗内发布 | 博客最新 11-05 |
| D | Coze（扣子） | **本次未取得** | coze.cn / coze.com SPA 壳；开源仓库无窗内 release |

## 十一、发现层摘要、局限与来源

### 11.1 名单外发现（四组均已做）

| 组 | 线索数 | 纳入深写 | 纳入对象 |
|---|---|---|---|
| A | 18 | 2 | Grok Build 泄漏（Claroc）、Modern Web Guidance 1.0 |
| B | 14 | 6 | agno v3.2.0、Strands、Haystack 3.5.0、Langfuse v4.77–80、pydantic-ai 2.67/2.68、MS Agent Framework 1.26.0 |
| C | 14 | 1 | arXiv 2611.16107（GUI 语料可访问性债务） |
| D | 16 | 3 | OpenShell、AWS Nitro Sandboxes、MKA 基准 |

另有若干线索记录未纳入：Antigravity 1.5.5→2.32.0（已用于主线第三次例证）、Amp 弃 Dial/Boxes、Kiro 3.3.0、Qwen Code 0.27.4、Termination Lag 论文（arXiv 2611.14960，未逐篇核读）、Universal 的 code-mode 库等。**未纳入理由统一为：版本正文为空、只有二手转述、或与主线重复。**

### 11.2 局限

- **OpenAI 侧连续两期不可评**：`help.openai.com` 与 `openai.com/news` 均 403（带浏览器 UA 仍 403），只能确认 `developers.openai.com` changelog 窗内无条目。任何「OpenAI 本周没动」的结论都不成立。
- **本次未取得 8 项**：Genspark（4 入口 403）、Qwen（SPA/RSS 停更）、AutoGLM（无发布页）、ServiceNow（403）、Coze（SPA）、GAIA（404）、WebVoyager（404）、OpenAI ChatGPT release notes（403）。均记「已试入口 ≥2」，不推断为「不存在」。
- **GitHub 元数据**：`api.github.com` 本机 403，star/fork 与仓库描述不可得；「显著 star 增长」一项本期无法核验，未作判断。
- **arXiv 限流**：多组遇到 429，单查询范围有限；「本周无某类论文」不成立，只能写查询范围内无命中。
- **厂商自述数字未独立复现**：browser-use BU Bench、Port of Context token 降幅、Perplexity 8/10 第三方沙箱、Salesforce 80 小时、Poppy 100+ 伙伴，均按 B 级使用并标明。
- **无浏览器/连接器**：JS 渲染页（Coze、ServiceNow investor、Qwen）无法取证；已在 delivery.md 列「需 Bot 补证」。

### 11.3 来源

- Claude Code releases｜https://github.com/anthropics/claude-code/releases
- Claude Code Code Mode 文档｜https://code.claude.com/docs/en/code-mode
- Claude Code 权限文档｜https://code.claude.com/docs/en/permissions
- Claude Code 沙箱文档｜https://code.claude.com/docs/en/sandboxing
- Codex releases｜https://github.com/openai/codex/releases
- Gemini CLI releases｜https://github.com/google-gemini/gemini-cli/releases
- Cursor changelog｜https://cursor.com/changelog
- Devin Desktop changelog｜https://docs.devin.ai/desktop/changelog
- OpenCode releases｜https://github.com/anomalyco/opencode/releases
- Cline PR #15644｜https://github.com/cline/cline/pull/15644
- SWE-bench commits｜https://github.com/SWE-bench/SWE-bench/commits/main.atom
- OpenClaw v2026.11.3｜https://github.com/openclaw/openclaw/releases/tag/v2026.11.3
- OpenClaw v2026.11.5-beta.3｜https://github.com/openclaw/openclaw/releases/tag/v2026.11.5-beta.3
- OpenClaw Code Mode 文档｜https://docs.openclaw.ai/tools/code-mode
- OpenClaw Code Mode executors｜https://docs.openclaw.ai/tools/code-mode/executors
- Hermes v0.23.1｜https://github.com/NousResearch/hermes-agent/releases/tag/v0.23.1
- LangGraph releases｜https://github.com/langchain-ai/langgraph/releases
- LangChain releases｜https://github.com/langchain-ai/langchain/releases
- browser-use 1.0.0｜https://github.com/browser-use/browser-use/releases/tag/1.0.0
- browser-use 1.0.4｜https://github.com/browser-use/browser-use/releases/tag/1.0.4
- Dify releases｜https://github.com/langgenius/dify/releases
- LlamaIndex v0.14.26｜https://github.com/run-llama/llama_index/releases
- Google ADK releases｜https://github.com/google/adk-python/releases
- OpenAI Agents SDK commits｜https://github.com/openai/openai-agents-python/commits/main.atom
- OpenHands releases｜https://github.com/All-Hands-AI/OpenHands/releases
- AutoGPT releases｜https://github.com/Significant-Gravitas/AutoGPT/releases
- AutoGen README｜https://github.com/microsoft/autogen
- Anthropic API release notes｜https://platform.claude.com/docs/en/release-notes/api
- Anthropic Fable/Mythos 5.2｜https://www.anthropic.com/claude-fable-and-mythos-5-2
- Claude computer use 文档｜https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool
- Perplexity SPACE II｜https://www.perplexity.ai/hub/blog/escaping-space-part-ii
- Perplexity Decider｜https://www.perplexity.ai/hub/blog/perplexity-decider
- Gemini in Chrome｜https://blog.google/innovation-and-ai/products/gemini-app/research-with-gemini-in-chrome/
- MKA benchmark｜https://blog.google/innovation-and-ai/models-and-research/gemini-models/multimodal-knowledge-agent-benchmark/
- Gemini API changelog｜https://aistudio.google.com/docs/changelog
- kimi.com blog｜https://kimi.com/blog
- manus.im blog｜https://manus.im/blog
- Stagehand releases｜https://github.com/browserbase/stagehand/releases
- Steel commits｜https://github.com/steel-dev/steel-browser/commits/main.atom
- Browserless releases｜https://github.com/browserless/browserless/releases
- OSWorld advisory｜https://github.com/xlang-ai/OSWorld/security/advisories/GHSA-8cw3-7xw3-vpph
- OSWorld desktop-env 1.0.3｜https://github.com/xlang-ai/OSWorld/releases
- Claroc Grok Build 研究｜https://blog.claroc.io/ghostshares-grok-build-apps/
- Modern Web Guidance 1.0｜https://developer.chrome.com/blog/modern-web-guidance-v1
- Antigravity changelog｜https://antigravity.google/docs/changelog
- CNCF OpenShell｜https://www.cncf.io/blog/2026/11/10/welcoming-openshell-to-the-cncf-open-governance-to-secure-agentic-ai/
- OpenShell on Kubernetes｜https://www.cncf.io/blog/2026/11/11/openshell-on-kubernetes-a-guide-for-platform-engineers/
- CNCF 里程碑公告｜https://www.cncf.io/announcements/2026/11/10/cncf-hits-major-milestones-with-global-community-growth-record-industry-investment-and-a-new-generation-of-projects-to-build-ai-systems-in-production/
- agent-sandbox releases｜https://github.com/kubernetes-sigs/agent-sandbox/releases
- gVisor releases｜https://github.com/google/gvisor/releases
- AWS Nitro Sandboxes｜https://aws.amazon.com/about-aws/whats-new/2026/11/nitro-sandboxes-eks-ecs-ec2/
- E2B releases｜https://github.com/e2b-dev/E2B/releases
- MCP release cycle｜https://blog.modelcontextprotocol.io/posts/mcp-release-cycle/
- MCP 文件扩展｜https://blog.modelcontextprotocol.io/posts/exploring-file-uploads-and-downloads-in-mcp/
- MCP Inspector releases｜https://github.com/modelcontextprotocol/inspector/releases
- MCP Registry releases｜https://github.com/modelcontextprotocol/registry/releases
- Sierra Poppy v1.0｜https://sierra.ai/blog/releasing-poppy
- Poppy 规范｜https://personalagentprotocol.org/docs/1.0/spec
- Harvey ethical wall｜https://www.harvey.ai/blog/building-ethical-wall-enforcement-into-harvey
- Salesforce SFR-AutoR&D｜https://www.salesforce.com/news/stories/agents-that-improve-ai-models/
- Glean release notes｜https://docs.glean.com/release-notes/
- arXiv：2611.15729（DISCERN）、2611.15600（MemCredit）、2611.17068（MAPE）、2611.17115（CapLite）、2611.16122（Intent-Aware）、2611.16107（Accessibility Debt）

### 11.4 冻结声明

本母稿于 2026-11-16 冻结，窗口与期号不再变更。若编辑阶段需有界补证，另存 `master-v2.md` 并更新 `status.md`。
