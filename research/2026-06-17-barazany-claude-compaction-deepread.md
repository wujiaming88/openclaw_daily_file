# 深度剖析：Claude Code 的压缩引擎——源码究竟揭示了什么

> **本文性质**：这是一篇**深度剖析 + 技术延展**报告，不是原文翻译。
> **原文出处**：Jonathan Barazany，《Claude Code's Compaction Engine: What the Source Code Actually Reveals》
> 原文 URL：<https://barazany.dev/blog/claude-codes-compaction-engine>（作者站点 barazany.dev）
> 这是作者的**第二篇**，承接其第一篇《Context Engineering — What Keeps AI Agents From Losing Their Minds》。
>
> **方法与边界声明**：
> - 原文核心论点、章节结构、关键数字均来自上述原文，本报告逐节高保真覆盖后，在每节追加【技术展开】做原理级深挖。
> - **本次升级**：本报告在原文逆向论述之上，**引入一份社区从 Claude Code `v2.1.88` npm 发布包反混淆得到的「还原源码」**，对压缩引擎逐行核对，把原文中大量「逆向推测/作者自析」的表述**就地改写为带真实「文件:行号 + 常量名/注释」的源码确证**——精确度比博客的逆向高一个量级。
> - **这份还原源码仍属社区逆向**：它来自对发布包的反混淆/重命名，**并非 Anthropic 官方一手源码**；变量名、注释、常量值可能随版本演进而变化，本报告所引行号锚定在 v2.1.88 这一快照。凡涉及服务端（API 侧）行为，源码只暴露**客户端发出的契约**，服务端实现仍属合理推断。
> - 为佐证 Barazany 论点的**普适性**，本报告用三个**真实可见的一手开源实现**做横向交叉印证：`openai/codex`（Rust）、`sst/opencode`（TypeScript / Effect-TS）、`NousResearch/hermes-agent`（Python）。所有引用均标注真实文件路径/行号。
> - 同时复用我们已有研究：`research/2026-06-16-agent-context-compaction.md`。
> - 报告日期：2026-06-17 · 研究员：黄山（System Architect & Technology Researcher）

---

## 〇、导读：作者在赌什么，又赌赢了什么

Barazany 这篇文章的叙事张力，全部建立在他第一篇文章埋下的一个**预测**上。

第一篇里，他从**外部行为**描述了 AI agent 在长会话中"不发疯"靠的几条不变量（作者原意）：

- 保留文件的**最新版本**（keep the latest file versions）；
- **裁剪终端输出**（trim terminal output）；
- **摘要化旧的工具结果**（summarize old tool results）；
- **守护 system prompt**（guard the system prompt）。

然后他下了一个判断（作者原话大意）：**"朴素的 LLM 摘要只是创可贴（band-aid）。真正的功夫必须是确定性的 curation（deterministic curation）。摘要应该是最后手段（last resort）。"**

第二篇的钩子是：Claude Code 的仓库公开浮现后，他让 Claude 去分析它自己的压缩源码。结论是两句话（作者原话大意）：**"预测成立了。而且实现比我预期的更深思熟虑（more thoughtful than I expected）。"**

这篇报告就沿着原文 6 个部分逐节剖开，并在每节后补上原文没有展开、但对工程师最有价值的**原理层**解释。

---

## 一、预测回顾 / curation 哲学

### 原文要点

作者重申第一篇的两个支柱：

1. **确定性 curation 优先于 LLM 摘要**。在动用模型把历史"压成一段话"之前，应当先用**不需要模型、可预测、可复现**的规则去整理上下文：保留最新文件版本、裁剪冗长终端输出、抹除陈旧工具结果、守护 system prompt。
2. **摘要是最后手段**。因为摘要"昂贵且有损"（expensive and lossy）。

作者强调：这一预测在看到源码后**得到印证**——Claude Code 恰恰把摘要放在整条处理链的最末端。

### 【技术展开】为什么"确定性 curation > LLM 摘要"在工程上是对的

把"上下文管理"看作一个**数据管道**，curation 与 summarization 是两类截然不同的算子：

**1）有损 vs 无损的本质差异。**

- **确定性 curation 是"可控有损"甚至"近无损"**。例如"只保留最近 5 个工具结果、其余替换为占位符"这条规则：被抹掉的内容**本可按需重取**（文件还在磁盘、命令可重跑）。信息没有真正湮灭，只是"换出"到了上下文窗口之外——这正是 MemGPT（arXiv 2310.08560）"main context ↔ external context 分页"思想的工程化体现。
- **LLM 摘要是"不可控有损"**。模型把 15K token 压成 800 token 时，**丢弃哪些细节由模型即时决定**，且可能引入"幻觉式改写"（context drift）——复述时悄悄偏离原意。一旦摘要写错，原始信息在上下文里**不可恢复**。

**2）可调试性（debuggability）。**
确定性规则的行为是**可预测的纯函数**：给定同样的消息列表，输出永远相同。出问题时，工程师能精确指出"第 6 个工具结果被抹除规则命中了"。而摘要是一次**采样**（带随机性、受温度影响），同样的输入两次跑出不同摘要，事故难以复现、难以归因。

**3）可重放性（replayability）。**
curation 不破坏"事件溯源（event sourcing）"的可能性——OpenCode 的做法极有代表性：它**不物理删除**消息，而是给消息打 `pruned` 时间戳标记（`opencode/packages/core/src/session/message.ts:120`：`pruned: V2Schema.DateTimeUtcFromMillis.pipe(Schema.optional)`）。数据仍在 DB，随时可回放、可审计。摘要则是"破坏性写入"，原始 turn 一旦被摘要替换，重放链就断了。

**4）成本与延迟。**
curation 是 O(n) 的本地字符串操作，**零模型调用、亚毫秒级**。摘要要发起一次完整的 LLM 推理，**几秒延迟 + 真金白银的 token**。把摘要推到最后，等价于"能用便宜手段解决就绝不调用昂贵手段"——这就是下一节的"成本阶梯"。

> **小结**：Barazany 的预测之所以成立，根因是 curation 在"信息保真、可调试、可重放、成本"四个维度全面优于摘要。摘要的唯一不可替代价值是"语义级压缩比"——当历史实在太长，连"换出"都不够时，才值得用一次有损推理把它压成结构化文本。

---

## 二、Three Tiers, Not One（三层，而非单层）

### 原文要点

Claude Code 的压缩不是单一机制，而是**三层按序施加、一层比一层重**（each heavier than the last）：

**Tier 1 — 每次 API 调用前都跑。**
轻量清理：清掉旧的工具结果，**只保留最近 5 个**，其余替换为字面占位符 `[Old tool result content cleared]`。**快、便宜、不涉及模型**。

**Tier 2 — API 层（服务端策略）。**
基于 **token 阈值**处理 thinking blocks 与 tool result 的清除。这是服务端侧的策略。

**Tier 3 — 全量 LLM 摘要（最后手段）。**
产出**结构化 9 段摘要**：intent（意图）/ technical concepts（技术概念）/ files touched（涉及文件）/ errors and fixes（错误与修复）/ all user messages（所有用户消息）/ pending tasks（待办）/ current work（当前工作）等。模型在产出摘要前，先用一个 **chain-of-thought scratchpad（思维链草稿纸）** 把整段对话推理一遍，**草稿纸事后被剥除**（stripped afterward）。作者评价：精巧（sophisticated），但也是最后手段。

作者点题：这套架构正好印证第一篇的论断——**摘要昂贵且有损，只有当其它一切都跑过之后才动用它**。

### 【源码确证】把"逆向推测"钉到真实常量

还原源码把原文这些靠观察得出的描述，逐条钉到了真实文件与常量上（v2.1.88 还原源码，社区逆向；本地路径 `repos/claude-code-source-code/src/services/compact/`）：

| 原文表述（逆向） | 还原源码确证（文件:行号 + 常量/注释） |
|---|---|
| Tier 3 摘要为"最后手段"，需为输出预留空间 | `autoCompact.ts:30` `MAX_OUTPUT_TOKENS_FOR_SUMMARY = 20_000`，注释 `Based on p99.99 of compact summary output being 17,387 tokens` |
| 触发压缩的阈值 = 有效窗口减去一段缓冲 | `autoCompact.ts:62` `AUTOCOMPACT_BUFFER_TOKENS = 13_000`；`autoCompact.ts:73` `getAutoCompactThreshold = getEffectiveContextWindowSize(model) - AUTOCOMPACT_BUFFER_TOKENS` |
| "有效窗口" = 模型窗口减输出预留 | `autoCompact.ts:33` `getEffectiveContextWindowSize()` = `contextWindow - min(getMaxOutputTokensForModel, 20_000)` |
| Tier 1 占位符字面量 | `microCompact.ts:36` `TIME_BASED_MC_CLEARED_MESSAGE = '[Old tool result content cleared]'`（与原文逐字一致） |

还有一处原文完全没提、但极具说服力的**生产事故注释**——它证明这份代码是真在线上跑、被真实数据打磨过的：`autoCompact.ts:67-70` 给压缩失败加了"熔断器"，`MAX_CONSECUTIVE_AUTOCOMPACT_FAILURES = 3`，注释直书 `BQ 2026-03-10: 1,279 sessions had 50+ consecutive failures (up to 3,272) in a single session, wasting ~250K API calls/day globally`。即：曾有 1,279 个会话连续压缩失败 50+ 次（最高 3,272 次），每天白烧约 25 万次 API 调用，于是加了"连失 3 次就停"的熔断。另一条 `autoCompact.ts:300` 注释 `BQ 2026-03-01: missing this made 20% of tengu_prompt_cache_break events` 同样把缓存失效量化到了 20%。**这种带日期、带数量级的事故注释，是逆向 + 自析永远拿不到、只有还原源码才能看见的"一手证据"。**

> 注意：上表的 `20_000`/`13_000` 等是"客户端"侧 autocompact 的常量；服务端 microcompact 另有 `180_000`/`40_000` 一套（见 §七）。两套不要混淆。

### 【技术展开】"成本阶梯"的工程美学，与 scratchpad 的取舍

**A. 成本阶梯（cost ladder）是一种贪心策略。**

三层的排序本质是一条**按"单位 token 节省成本"递增**排列的处理链：

| 层 | 触发频率 | 是否调模型 | 单次成本 | 有损度 | 可逆性 |
|----|---------|-----------|---------|--------|--------|
| Tier 1 本地抹除 | 每次 API 调用前 | 否 | ~0（本地字符串） | 低（可重取） | 高 |
| Tier 2 服务端阈值清理 | 达 token 阈值 | 否（服务端规则） | 低 | 低-中 | 中 |
| Tier 3 LLM 摘要 | 兜底，最后 | 是（整段推理） | 高（秒级+token） | 高（语义有损） | 低 |

工程美学在于：**每一层只在前一层不足以解决问题时才升级**。这与网络协议的"退避重试"、GC 的"分代回收"、缓存的"多级 LRU"是同构的设计直觉——**让 99% 的常态流量走最便宜的路径，把昂贵机制留给长尾**。

这条阶梯在三个一手开源实现里都能找到对应物，证明它不是 Claude Code 独有：

- **Codex（Rust）**：常态走"达 90% 窗口 → LLM 摘要"，但当摘要本身都撞上 `ContextWindowExceeded` 时，**降级到最廉价的头部 trim 兜底**——`codex/codex-rs/core/src/compact.rs:258` 注释明写：`// Trim from the beginning to preserve cache (prefix-based) and keep recent messages intact.`，对应 `history.remove_first_item()`。这就是"昂贵手段失败后退回便宜手段"的阶梯下半段。
- **OpenCode（TS）**：`compaction.ts` 顶部定义了一组**先于摘要的廉价常量**——`TOOL_OUTPUT_MAX_CHARS = 2_000`（工具输出先按字符截断）、`DEFAULT_KEEP_TOKENS = 8_000`、`DEFAULT_BUFFER = 20_000`。只有当估算 token 超过 `context - max(output, buffer)` 时才进入 `compactAfterOverflow`（`compaction.ts:236-238`）。即"先截断、撞墙才摘要"。
- **Hermes（Python）**：`context_compressor.py` 的 Phase 1 用占位符 `_PRUNED_TOOL_PLACEHOLDER = "[Old tool output cleared to save context space]"`（`context_compressor.py:150`）做旧工具结果抹除——**与 Claude Code 的 `[Old tool result content cleared]` 几乎逐字同构**；只有 Phase 1 不够时才进入 `_generate_summary`（`context_compressor.py:1305`）。

> 三套独立实现、三种语言，都自发收敛到同一条"先抹除/截断、最后才摘要"的阶梯。这强烈说明：**成本阶梯是 agentic 上下文管理的"自然律"**，而非某一家的巧思。

**B. Tier 3 的 chain-of-thought scratchpad：为何"先推理、再摘要、再剥除草稿"？**

这是原文一个容易被略过、但极其精妙的细节。摘要调用并非"读完历史直接吐 9 段"，而是分两步：

1. 模型先在一个 **scratchpad** 里用思维链把整段对话**推理梳理**一遍（哪些是主线意图、哪些错误已修复、哪些文件被改、当前卡在哪）；
2. 然后才**承诺（commit）**到结构化的 9 段摘要；
3. 最后**把 scratchpad 从最终产物里剥除**，只把干净的 9 段留下来重建上下文。

这背后是一个清晰的**"推理质量 vs 上下文洁净"权衡**：

- **要推理质量**：直接让模型一步到位写结构化摘要，会显著降低质量。大量研究（以及 CoT 的基本结论）表明，**让模型先"想"再"答"**能大幅提升复杂归纳任务的准确率。摘要本质是一次高难度的"信息归纳与优先级排序"，没有思维链很容易漏掉关键的"错误与修复""待办"。
- **要上下文洁净**：但 scratchpad 本身是一大段啰嗦的中间推理，**如果把它也留进重建后的上下文，等于刚压缩完又塞回一堆噪声**，与压缩目的自相矛盾。而且这些中间推理对后续 agent 执行毫无价值（它要的是结论，不是过程）。

所以"先推理→产出→剥草稿"是**鱼与熊掌兼得**的设计：用 scratchpad 买到推理质量，用"事后剥除"避免污染。这与 OpenAI o 系列"reasoning tokens 计费但不回灌进后续上下文"是同一种哲学——**推理是一次性的脚手架，用完即拆**。

---

## 三、The Cache Insight That Changes Everything（改变一切的缓存洞察）

### 原文要点

作者描述了他读到 Tier 1 "microcompact" 时的**第一反应**（作者原话大意）：

> "但如果对话已经被缓存了，删除旧消息**会让缓存失效**。而缓存失效的代价极其残酷——本来 token 能享受 **90% 折扣**，失效后你要为 **cache write 支付 1.25×**。你刚刚让压缩变得比它省下的 token 还贵。"

然后他给出 Claude Code 的解法，并称之为 **elegant（优雅）**：

> **当 prompt cache 是温热的（warm）时，Claude Code 根本不去改本地消息。** 取而代之，它把一批 **`cache_edits` 块**排队，**随 API 请求一起发**给服务端——告诉服务端**按 `tool_use_id` 外科手术式地删除特定的 tool result 块**，**不触碰缓存前缀（cached prefix）**。
>
> 结果：缓存完好无损、旧的工具结果消失、零重写成本（no rewrite cost）。

### 【技术展开】用 Transformer 因果注意力讲透"为什么删头会让前缀全失效"

这是全文最硬核的一节，原文只点到"删旧消息会让缓存失效"，但没讲**为什么**。要讲透，必须下沉到 **prompt cache 的物理本质 = KV cache 的前缀复用**。

**1）prompt cache 缓存的是什么？**

Transformer 推理时，每个 token 在每一层都会算出一对向量 **(Key, Value)**，合称该 token 的 **KV**。自回归生成时，为了不重复计算历史 token 的 KV，会把它们缓存起来——这就是 **KV cache**。Anthropic/OpenAI 的 "prompt caching" 就是把**这份 KV cache 按前缀持久化**，下次请求若前缀逐字节相同，就直接复用，省掉这部分的 prefill 计算（因此打 90% 折扣）。

**2）为什么 KV 缓存只能"按前缀"复用？因果注意力（causal attention）。**

关键在于 Transformer 的**因果掩码**：位置 `i` 的 token 在计算自己的表示时，会 attend 到**所有 ≤ i 的 token**（包括它自己和前面全部）。这意味着：

> **token `i` 的 KV，依赖于它前面所有 token 的内容与位置。**

所以缓存能复用的前提是：**从头到 `i` 这一整段前缀，逐 token 完全一致**。一旦你在前缀中间**删掉一条旧消息**，会发生两件致命的事：

- **(a) 位置全体移位**：被删消息之后的每个 token，其**绝对/相对位置编码（RoPE 等）全部改变**。位置变了，KV 就变了（RoPE 把位置旋进 Q/K 里），缓存值作废。
- **(b) 注意力上下文改变**：被删消息之后的 token，原本 attend 到了那条被删消息；删除后它们"看到"的历史不同了，表示必须重算。

因此，**只要动了前缀的任何一个 token，从那个点往后的所有 KV 全部失效，必须重新 prefill**。这就是作者说的"删旧消息让缓存失效"的物理根因：**删头 = 砸掉整条前缀的 KV cache = 全价重算 + 还要付 1.25× 的 cache write 把新前缀重新写入缓存**。本来想省钱，结果是**双重亏损**。

**3）`cache_edits` 按 `tool_use_id` 定向删除，为何能不破坏前缀 KV？**

这正是设计的精髓。`cache_edits` 不是"客户端改消息列表再重发"，而是**把"删除指令"作为元数据随请求发给服务端，让服务端在它自己持有的缓存表示上做手术**。关键差异：

- **朴素删除**：客户端把消息从数组里移除 → 前缀字节流变了 → 服务端算出的 cache key（前缀哈希）不匹配 → 整段 prefill。
- **`cache_edits`**：客户端**保留缓存前缀不动**，仅附带"请把 `tool_use_id=X` 的那个 tool_result 块剔除"的指令。服务端在**已经命中的缓存基础上**做局部编辑——它知道哪些 KV 对应那个块，能在复用绝大部分前缀 KV 的同时，把目标块的贡献剔除/旁路掉。

换句话说：**矛盾的本质是"我既想删掉旧工具结果（省窗口），又想保住缓存前缀（省钱）"——这两个目标在朴素方案里是直接对立的。`cache_edits` 通过"把删除下推到服务端、以 ID 定向、不重写前缀字节流"把对立解开了。** 这是同时满足"删旧"与"保缓存"的关键支点。

> **【源码确证·本次升级】** 原文只说"有个 `cache_edits` 机制"，本报告上一版对它还属"合理推断"。还原源码把客户端侧的这条路径**钉死为可见代码**：`microCompact.ts:52` 有专门的 `--- Cached microcompact state (ant-only, gated by feature('CACHED_MICROCOMPACT')) ---` 模块；`microCompact.ts:84-118` 导出 `getPendingCacheEdits()`/`getPinnedCacheEdits()`/`pinCacheEdit(userMessageIndex, block)` 一组 API；`microCompact.ts:295-301` 注释直述 `Cached microcompact path - uses cache editing API to remove tool results without invalidating the cached prefix`，并明言 `Does NOT modify local message content (cache_reference and cache_edits are added at API layer)`。`microCompact.ts:330-336` 的 `getToolResultsToDelete(state)` → `createCacheEditsBlock(state, toolsToDelete)` → `pendingCacheEdits = cacheEdits`，完整展示了"按 `tool_use_id` 收集要删的块 → 生成 cache_edits 块 → 排队给 API 层"的全链路。**因此"按 tool_use_id 定向删除、不改本地消息、随请求发给服务端"不再是推断，而是源码确证的客户端契约。** 仅服务端如何在 KV 层"旁路一个块"仍属推断（这部分代码不在发布包里）。另：该路径由 `feature('CACHED_MICROCOMPACT')`（`microCompact.ts:276`）门控，且仅 ant-内部、主线程生效。（源：`repos/claude-code-source-code/src/services/compact/microCompact.ts`）

**4）一手开源印证："宁可少删，也要保前缀"是普适直觉。**

即便没有 `cache_edits` 这种服务端能力的开源 harness，也都用**朴素但同向**的手段保护前缀：

- **Codex（Rust）**：摘要兜底失败时**只从头部删一条**（`history.remove_first_item()`），注释直言 `to preserve cache (prefix-based)`（`compact.rs:258-262`）。注意——Codex 这里是"撞墙后的破坏性兜底"，它**接受**前缀缓存的损失，但**最小化**损失（一次删一条、保住最近消息）。这恰好从反面印证：**动前缀是不得已的昂贵操作**。
- **Hermes（Python）**：`prompt_caching.py` 实现 `system_and_3` 策略——**只在 system prompt + 最近 3 条非 system 消息上放 4 个 `cache_control` 断点**（`apply_anthropic_cache_control`，`prompt_caching.py:49-86`）。注释写明"reduces input token costs by ~75% on multi-turn"。它把缓存断点钉在**前缀头部（system）+ 滚动尾部（最近 3 条）**，正是为了让中间历史的增长不破坏前缀命中。这与 Claude Code 的缓存哲学完全同源。

> **横向洞察**：三家都把"前缀 KV 缓存"当作必须供奉的"神"。区别只在手段先进度——Claude Code（据原文）有服务端 `cache_edits` 能做"无损外科手术"；Codex/OpenCode/Hermes 则用"只删头一条 / 时间戳隐藏 / 固定断点"等客户端手段在"删旧"与"保缓存"间取折中。**缓存前缀不可轻动，是 2026 年所有 harness 的共识铁律。**

---

## 四、The Summarization Call Reuses Your Own Cache（摘要调用复用你自己的缓存）

### 原文要点

同样的缓存逻辑也贯穿全量压缩路径（Tier 3）。

你的直觉会是：当 Tier 3 触发、需要摘要整段对话时，Claude Code 会**另起一个 API 调用，配一个专用 system prompt**——"You are a summarization assistant..."。**不同的 system prompt → 不同的 cache key → 整段对话从零重新 tokenize。**

**但他们没有这么做。**

取而代之，摘要调用**复用与主对话完全相同的 system prompt、tools、model 和消息前缀**。压缩指令作为**一条新的 user 消息追加在末尾**。服务端看到**相同的 cache key——直接命中**。

原文给出震撼数字：**被测试过的替代方案（用不同 system prompt）有 98% 的缓存未命中率（cache miss rate）。全球每天为此白白重处理数百亿（tens of billions）token，原因仅仅是压缩调用换了个 system prompt。**

### 【技术展开】cache key = 前缀逐字节哈希；为什么换 system prompt 就 98% miss

**1）cache key 的真相：它是"前缀内容的逐字节哈希"，而 system prompt 站在最前面。**

prompt cache 的命中判定，本质是**对请求前缀做内容哈希、逐段比对**。而消息的拼装顺序几乎总是：

```
[system prompt] → [tools 定义] → [历史消息 ...] → [最新 user 消息]
```

**system prompt 位于整条前缀的最最前端（position 0 区段）。** 由前一节的因果注意力原理：**前缀任何一个 token 变了，从该点往后的所有 KV 全部失效。** system prompt 在最前面——所以**换掉 system prompt = 从 position 0 就不一致 = 整条前缀的缓存全部作废，无一幸免**。

这就是 **98% miss** 的来源：当你为摘要调用换上 "You are a summarization assistant..." 这个不同的 system prefix，**主对话辛辛苦苦攒下的那一大段温热 KV cache（可能几万 token）瞬间全部用不上**，服务端必须从头 prefill 整段历史。98% 而非 100%，大概只是因为偶有零星的全局共享前缀片段碰巧命中。

**2）"fork 复用前缀"省下的全球级算力账。**

Claude Code 的解法把摘要调用**当作主对话的一次普通延续**：

- system prompt **不变** → 前缀哈希前段一致；
- tools 定义 **不变** → 继续一致；
- 历史消息前缀 **不变** → 继续一致（命中那段几万 token 的温热缓存）；
- 唯一的新增是**末尾追加一条 user 消息**："请按 9 段模板总结以上对话"。

由于新增内容**只在最尾部**，**前面整条前缀全部命中缓存**，只需 prefill 这最后一条短指令。**省下的就是整段历史的重复 prefill**。

把这件事乘以"全球每天数千万次 Claude Code 压缩"，就是原文说的**数百亿 token 的日级算力**——这是一个"换不换 system prompt"这种看似微不足道的工程决策，在规模化下放大成的天文数字账单。**架构的杠杆率（leverage）在此体现得淋漓尽致。**

**3）一手开源印证：摘要调用也走"同前缀续写"。**

- **OpenCode（TS）**：摘要不是另起炉灶，而是把压缩指令作为对**同一条消息流**的续写——`compaction.ts:166` 的 `buildPrompt` 把"总结模板/更新指令"拼在既有 `context` 之后；迭代再压缩时甚至复用上一份摘要（`previousSummary`，`compaction.ts:182-186`：`Update the anchored summary below ...`）。它刻意**不引入一个独立的 summarizer system prompt**，从而最大化复用前缀。
- **Codex（Rust）**：本地摘要路径在**同一会话上下文**内追加压缩 turn；远程路径才走专用端点 `RESPONSES_COMPACT_ENDPOINT = "/responses/compact"`（`client.rs:152`，`compact_conversation_history()` 在 `client.rs:486`）——但远程端点是 OpenAI **服务端专门为复用会话状态优化**的内部通道，同样不是"客户端换 system prompt 重发"。
- **Hermes（Python）**：摘要失败时的兜底 `_fallback_to_main_for_compression`（`context_compressor.py:1278`）明确**回退到主对话模型/上下文**做压缩，而非另开一个隔离的 summarizer——同样是"复用主对话身份"的取向。

> **横向洞察**：原文揭示的"摘要复用自身缓存"不是 Claude Code 的孤例，而是**缓存经济学倒逼出的收敛设计**。任何一个想做长会话的 harness，只要算过 cache key 的账，都会避免"为摘要换一个 system prompt"这个昂贵陷阱。

---

## 五、What Happens After Compaction（压缩之后发生什么：重建 reconstruction）

### 原文要点

这是作者第一篇只**抽象描述**过、第二篇靠源码补全的部分：**重建（reconstruction）**。

摘要做完后，Claude Code **不是**把摘要丢进一个空上下文然后听天由命，而是**有条理地重建**（rebuilds methodically）：

1. **boundary marker**（边界标记，含 pre-compaction 元数据）；
2. **格式化后的摘要**；
3. **最近读过的 5 个文件**（5 most recently read files，**总上限 50K token**）；
4. **按 recency 重新注入的 skills**（re-injected skills sorted by recency）；
5. **重新声明的 tool 定义**（tool definitions re-announced）；
6. **重跑的 session hooks**（session hooks re-run）；
7. **恢复的 CLAUDE.md**（CLAUDE.md restored）。

并且，**如果压缩发生前 agent 正在自主运行**，会有一条 **continuation message** 告诉它（作者原话大意）：**"你本来就在干活——别确认这个摘要、别复述（don't acknowledge the summary, don't recap），直接继续。"** 整个会话体验被设计成**无缝（seamless）**——不只对旁观的用户无缝，对正在执行的 agent 也无缝。

> **【源码确证】** 原文只是转述这条 message 的大意，还原源码里它是一段**逐字可引的真实拼接串**：`prompt.ts:358-359` 把 continuation 拼为 `${baseSummary}` + 一段指令，原文为 `Continue the conversation from where it left off without asking the user any further questions. Resume directly — do not acknowledge the summary, do not recap what was happening, do not preface with "I'll continue" or similar. Pick up the last task as if the break never happened.`。注意连 `do not preface with "I'll continue" or similar`（连"我来继续一下"这种开场白都禁止）这种细节原文都没点出——这才是工程上真正压住"摘要污染行为"的完整措辞。（源：`repos/claude-code-source-code/src/services/compact/prompt.ts`）

作者点题（金句，原话大意）：**这正是"能用的压缩系统"与"技术上能跑、却在任务中途悄悄搞砸"的分水岭。**

### 【技术展开】为什么"重读最近 5 文件"必要，以及 continuation message 的注意力学

**A. 为什么必须重读最近 5 个文件（50K 上限）？防止 agent 基于过期代码继续工作。**

摘要是**自然语言的、有损的**。如果只把"我刚才在改 `auth.ts` 的登录逻辑"这句话留给压缩后的 agent，它**手里没有 `auth.ts` 的当前内容**。接下来它要么：

- **凭摘要里的模糊记忆去改**——极易基于"它以为的代码"而非"真实代码"动手，产生幻觉式编辑、覆盖掉刚写好的东西；
- **重新去读一遍文件**——但这浪费一个往返，且 agent 未必知道该读哪些。

所以"主动把最近读过的 5 个文件的**真实最新内容**重新注入"是关键的**确定性 curation**——它把"文件最新版本"这条第一篇就强调的不变量，在压缩边界处**强制兑现**。**50K token 上限**则是工程上的"安全阀"：避免 5 个超大文件把刚腾出来的窗口又一次撑爆，与压缩目的冲突。这是典型的"保真"与"窗口预算"之间的硬约束折中。

> **【源码确证】** 这组常量不是逆向猜测，而是在 `compact.ts:122-124` 三行并列定义：`POST_COMPACT_MAX_FILES_TO_RESTORE = 5`、`POST_COMPACT_TOKEN_BUDGET = 50_000`、`POST_COMPACT_MAX_TOKENS_PER_FILE = 5_000`。原文只说了"5 个文件 / 50K 上限"，还原源码多括出了一条原文未提的**单文件 5K 上限**（`compact.ts:1441` 调用处 `maxTokens: POST_COMPACT_MAX_TOKENS_PER_FILE`）——即不仅总量封顶 50K，每个文件还单独封顶 5K，防止单个巨文件吞掉全部预算。重建顺序也有源码为据：`compact.ts:328-341` `buildPostCompactMessages` 注释明列 `Order: boundaryMarker, summaryMessages, messagesToKeep, attachments, hookResults`，与原文的重建清单逐项对应。

这条在一手源码里有直接同构物：

- **Codex（Rust）**：压缩后会**重新注入 initial context**——`insert_initial_context_before_last_real_user_or_summary()`（`compact.rs:489`）把 `build_initial_context()` 的内容插回摘要历史。`InitialContextInjection` 这个枚举（`compact.rs:54-76`）专门控制"替换历史里要不要带上 initial context"。即：压缩后绝不让 agent 在"裸摘要"上裸奔，而是把锚点重注。
- **Hermes（Python）**：`protect_first_n=3`、`protect_last_n=20`（`context_compressor.py:675-676`）——**首 3 条 + 尾 20 条永不进摘要、原样保留**。"保护首部"对应 attention sink / 锚点，"保护尾部"对应"当前工作的真实上下文"，与 Claude Code"重注最近文件 + boundary marker"异曲同工。

**B. continuation message 的"别复述、直接干"——这是给自主 agent 的注意力锚点与防污染开关。**

这一点原文一笔带过，但对**自主（autonomous）agent** 至关重要，值得展开两层：

**(1) 防止"摘要污染行为"（summary contaminating behavior）。**
压缩后，上下文里**最新、最显眼的一大块内容就是那段 9 段摘要**。LLM 有强烈的"近因偏好（recency bias）"和"对显著内容做出回应"的倾向。如果不加约束，agent 很可能把"这里有一份摘要"误读为"用户/系统要我对这份摘要做点什么"——于是它**开始复述摘要、确认收到、向用户汇报进度**，而不是**继续手头那个被打断的编码任务**。这就是作者说的"技术上能跑、却在任务中途悄悄搞砸"的典型失败模式：压缩没崩，但 agent 的**行为轨迹被摘要带偏了**。

`continuation message` 就是一个**显式的行为校正信号**：它告诉模型"这段摘要是给你回忆用的脚手架，不是新任务；你的真实任务还在继续，闭嘴接着干。"

**(2) 充当"注意力锚点（attention anchor）"。**
continuation message 作为**最末尾的消息**，享有最高的近因权重。它把模型的注意力从"那段醒目的摘要"重新拉回到"当前动作"上。结合前面重注的最近 5 文件，模型得到的信号是连贯的：**"任务上下文（文件）在这、任务状态（摘要）在这、现在该做的动作（继续）在这。"** 三者拼成一个让 agent 能**无缝续跑**的最小完备上下文。

> **工程启示**：压缩的成败，**一半在"压"，一半在"接"**。很多 harness 把全部精力放在"如何把历史压小"，却忽视"压完之后 agent 怎么继续"。Barazany 这一节点出的"重建 + continuation message"恰恰是区分"玩具压缩"和"生产级压缩"的真正分水岭——它管的是**压缩后的行为正确性**，而不只是 token 数字好看。

---

## 六、Cache Economics Shaped All of It（缓存经济学塑造了一切）

### 原文要点

纵观整个系统，**有一条主线贯穿每一个架构决策：cache hits are everything（缓存命中即一切）。**

- 用外科式 `cache_edits` 而非修改消息 —— **为缓存**；
- forked 摘要调用搭便车复用主对话前缀 —— **为缓存**；
- 三层架构尽可能推迟摘要 —— **也是为缓存**，因为摘要是唯一一条"无法干净复用既有 key"的路径。

作者收束全文（金句，原话大意）：**"这不只是 context engineering，这是成本约束下的 context engineering（context engineering under a cost constraint）。同时解决这两者，才是你能拥有稳定、长时运行的会话而不烧光配额的原因。"**

最后作者埋了下一篇的引子：**5 小时用量上限（5-hour usage cap）** 近来引发大量用户不满；本文讲的压缩只是 Claude Code 拉长这个窗口的**其中一块**，下一篇将深入**压缩之外的所有缓存优化**，以及它们在实践中究竟买到了什么。

### 【技术展开】为什么"缓存经济学"是 agent 架构的隐形第一性原理

**1）把三个决策还原到同一个目标函数。**

把这套系统看成一个**带约束的优化问题**：

```
最小化：每会话总成本 = Σ(prefill token × 价) + Σ(cache write × 1.25价) + Σ(output token × 价)
约束：上下文 ≤ 有效窗口；任务正确性不被破坏
```

在这个目标函数下，三个看似独立的决策其实都是**同一项的不同写法**——它们都在压低 `Σ(prefill token)` 这一最大头：

- `cache_edits` → 删旧时**不触发前缀重 prefill**（避免一次几万 token 的全价重算 + 1.25× cache write）；
- forked 摘要复用前缀 → 摘要时**不触发前缀重 prefill**（避免 98% miss）；
- 三层推迟摘要 → **减少摘要发生的频次**（摘要是唯一会顺带产生新前缀、可能扰动缓存的路径）。

**三个决策，一个目标。** 这就是作者"single thread runs through every decision"的精确数学含义。

**2）"90% 折扣 vs 1.25× 罚金"这个 ~17.5× 的价差，是所有设计的引力源。**

把数字摆出来感受量级：缓存命中的 token 约为全价的 **0.1×（九折优惠后只付一成）**，而缓存写入是 **1.25×**。两者比值约 **12.5×**；若再算上"失效后既要重 prefill（全价 1.0×）又要重写（1.25×）"，相对于"本可只付 0.1×"，**实际惩罚高达约 22.5×**。

> 一个 token 走对路径 0.1×、走错路径 ~22.5×——**两个数量级的价差**。任何架构师面对这种引力场，都会被迫把"保缓存"提到第一优先级。这解释了为何 2026 年所有严肃 harness 的压缩设计**都长得越来越像**：它们不是在抄彼此，而是在被同一个价格引力场拉向同一个吸引子（attractor）。

**3）一手开源印证缓存经济学的普适性——Hermes 的 `system_and_3` 是最干净的样本。**

Hermes 的 `prompt_caching.py` 把这套经济学写成了**纯函数**：只用 4 个 `cache_control` 断点（system + 最近 3 条），文档注释直接量化收益——`Reduces input token costs by ~75% on multi-turn conversations`（`prompt_caching.py:5-7`）。

它为什么只放 4 个断点、且钉在"头 + 滚动尾"？因为 Anthropic 的 cache_control 断点数量有限（一般 4 个），而**断点要放在"前缀最长公共部分的末端"才划算**：

- system prompt（最稳定的前缀头）→ 几乎永远命中；
- 最近 3 条消息（滚动尾）→ 让"新一轮请求"能复用"上一轮的尾部前缀"。

这与 Claude Code"system prompt 不变 + 复用消息前缀"的取向**在数学上是同一个解**。Hermes 用开源、可见、带注释的代码，**替 Barazany 对 Claude Code 的逆向陈述做了第一性原理的背书**：缓存经济学不是 Claude Code 的特殊招式，而是任何多轮 agent 在 Anthropic 计费模型下的**最优响应**。

**4）与 5 小时用量上限的因果链。**

作者把压缩与"5 小时用量上限"挂钩，背后逻辑是：用量上限本质是**对算力（token×价）的总闸**。每一次"删旧导致的前缀重算""摘要换 prompt 导致的 98% miss"，都在**白白消耗用户配额里的算力额度**却不产生任何价值。把这些浪费堵住，等价于**在不涨上限的前提下，让同样的 5 小时窗口能干更多的活**。所以"缓存优化"对用户的可感价值，不是抽象的"省钱"，而是具体的"少撞墙、多干活"。

---

## 七、博客之外：还原源码揭示的更多机制

Barazany 原文聚焦"三层架构 + 缓存经济学"这条主线，但 v2.1.88 还原源码里，`src/services/compact/` 目录下还躺着一批**原文完全没讲、却同样精妙**的机制。本节点名列出 6 个，均标真实文件:行号——它们把"压缩引擎"的版图扩出原文一大块。

### 7.1 服务端 API microcompact：另一套 180K / 40K 阈值

原文讲的 Tier 1 microcompact 是**客户端**清理；但还原源码里还有一条**服务端原生上下文管理**路径，常量与客户端**刻意对齐却数值不同**：`apiMicrocompact.ts:15-17`

```
const DEFAULT_MAX_INPUT_TOKENS = 180_000 // Typical warning threshold
const DEFAULT_TARGET_INPUT_TOKENS = 40_000 // Keep last 40k tokens like client-side
```

它不是改本地消息，而是给 API 下发一组"上下文编辑策略"。`apiMicrocompact.ts:34-55` 定义了两种策略类型：`clear_tool_uses_20250919`（按 `input_tokens` 触发、按 `tool_uses` 个数保留、可选 `clear_tool_inputs`/`exclude_tools`/`clear_at_least`）和 `clear_thinking_20251015`（按 `thinking_turns` 清 thinking）。可被服务端清结果的工具白名单 `TOOLS_CLEARABLE_RESULTS`（`apiMicrocompact.ts:18-25`）涵盖 shell / glob / grep / 文件读 / web fetch / web search。**这等于把"保留最近 N 个工具结果"的逻辑下推到 API 端原生执行**——比客户端字符串抹除更彻底，且日期化的策略名（`20250919`/`20251015`）暗示这是按版本演进的服务端契约。

### 7.2 时间维度的 microcompact：靠"间隔"而非"token"触发

原文的三层全是**按 token 量**触发的；还原源码却有一条**按时间间隔**触发的 microcompact，原文只字未提。`timeBasedMCConfig.ts:18-34` 定义配置：`gapThresholdMinutes`（默认 `60`）、`keepRecent`（默认 `5`）、`enabled`（默认 `false`）。触发逻辑在 `microCompact.ts:402-443`：当"距上一条主循环 assistant 消息的间隔（分钟）"超过阈值就清旧工具结果。

它的设计动机写在 `timeBasedMCConfig.ts:21-24` 注释里——**和服务端缓存 TTL 对齐**：

> `60 是安全选择：服务端 1h 缓存 TTL 对所有用户都已保证过期，所以我们绝不会强制一次本不会发生的 miss。`

换句话说：**既然 prompt cache 反正已经凉了、整条前缀本就要重写，那就趁这次重写顺便把旧工具结果清掉**，让被重写的内容更少。`microCompact.ts:261-269` 还点明它**优先于**普通 microcompact 短路执行。清理后写入的占位符正是那条 `[Old tool result content cleared]`（`microCompact.ts:36`、`483`）。这是把"缓存经济学"用到极致的一笔：**连缓存失效的时机都被拿来做顺手的免费清理**。

### 7.3 grouping：从"human-turn 分组"升级到"API-round 边界"

压缩要把消息切成组再处理，**切在哪**很关键。`grouping.ts:22` 的 `groupMessagesByApiRound()` 用一条规则建组：**每个 API 往返一组，边界在"出现一个新的 assistant 响应（`message.id` 与上一条 assistant 不同）"时触发**。它**取代了旧的 human-turn 分组**——`grouping.ts:13-16` 注释直言：

> `Replaces the prior human-turn grouping (boundaries only at real user prompts) with finer-grained API-round grouping, allowing reactive compact to operate on single-prompt agentic sessions...`

为什么要改？因为 SDK/CCR/eval 这类调用，**整个工作负载可能就是一个 human turn**（用户只发了一句"帮我把这个项目重构完"，后面全是 agent 自主跑几百轮）。旧的 human-turn 分组在这种会话里**只有一个组**，reactive compact 根本无从下手；改成 API-round 边界后，每一轮 agent 自主往返都成了可压缩的切点。`grouping.ts:34-42` 还解释了为何不追踪未闭合的 `tool_use`：良构会话里 API 契约保证每个 `tool_use` 在下一个 assistant turn 前必被解决，所以 `lastAssistantId` 单独就是充分的边界判据；malformed 输入则交给 fork 的 `ensureToolResultPairing` 在 API 时修复。

### 7.4 postCompactCleanup：skill 内容"故意"跨多次压缩存活

压缩后要清各种缓存，但 `postCompactCleanup.ts` 里有一条**反直觉的"故意不清"**注释，原文从未提及。`postCompactCleanup.ts:17-20`：

> `Note: We intentionally do NOT clear invoked skill content here. Skill content must survive across multiple compactions so that createSkillAttachmentIfNeeded() can include the full skill text in subsequent compaction attachments.`

即：**被调用过的 skill 全文，必须跨多次压缩存活**，否则压缩后的附件里就拼不回完整 skill 文本。`postCompactCleanup.ts:65-69` 进一步解释为何也**不**重置 `sentSkillNames`：压缩后重新注入约 4K token 的 `skill_listing` 纯属 `cache_creation` 浪费，模型 schema 里还留着 `SkillTool`、`invoked_skills` 也保留了已用 skill，没必要重发。

这里还藏着一个**主线程 vs 子 agent 的并发陷阱**，对我们这种多 agent 系统极有参考价值：`postCompactCleanup.ts:31-49` 说明，子 agent（`agent:*`）和主线程**跑在同一进程、共享模块级状态**（context-collapse store、getMemoryFiles 钩子标志、getUserContext 缓存）；如果子 agent 压缩时去重置这些，会**污染主线程状态**。所以 `runPostCompactCleanup(querySource)` 用 `querySource` 区分，只有主线程压缩（`repl_main_thread*` / `sdk` / `undefined`）才重置这些共享态。

### 7.5 Session Memory Compact 还是个 EXPERIMENT

还原源码里有整整一个 `sessionMemoryCompact.ts`（630 行），但它**第一行就标着实验**：`sessionMemoryCompact.ts:1-3`

```
/**
 * EXPERIMENT: Session memory compaction
 */
```

它的思路是把"会话记忆"持久化、压缩时用 `createCompactBoundaryMessage`（`sessionMemoryCompact.ts:11`、`447`）造边界标记，再把截断后的 session memory 注回。阈值配置 `DEFAULT_SM_COMPACT_CONFIG`（`sessionMemoryCompact.ts:55-60`）：`minTokens: 10_000`、`minTextBlockMessages: 5`、`maxTokens: 40_000`。是否启用由两个 GrowthBook flag 同时为真决定（`shouldUse = sessionMemoryFlag && smCompactFlag`，`sessionMemoryCompact.ts:412-420`）。**点出"它仍是实验"很重要**：博客读者容易把所有看到的机制当成稳定生产特性，而还原源码诚实地告诉我们——这条线还在灰度。

### 7.6 cache-sharing fork + Sonnet 4.6 的真实兜底数据

原文说摘要调用"复用主对话缓存"，还原源码进一步揭示这是一条 **cache-sharing fork** 路径，且带着一组**只有线上数据才知道的兜底率**。`prompt.ts:11-17` 注释：

> `The cache-sharing fork path inherits the parent's full tool set (required for cache-key match), and on Sonnet 4.6+ adaptive-thinking models the model sometimes attempts a tool call despite the weaker trailer instruction. With maxTurns: 1, a denied tool call means no text output → falls through to the streaming fallback (2.79% on 4.6 vs 0.01% on 4.5).`

拆开看这条机制：为了缓存命中，fork 出来的摘要调用**必须继承父对话的完整工具集**（否则 cache key 不匹配）。但工具集在场 + Sonnet 4.6 的自适应思考特性，会让模型**偶尔无视"别调工具"的尾部指令、真去发起一次 tool call**；而 `maxTurns: 1` 下这次调用被拒 = 这一轮没有文本产出 = 只能落到流式兜底。真实兜底率：**Sonnet 4.6 上 2.79%，4.5 上仅 0.01%**——**新模型把这个失败率抬高了近 280 倍**。于是源码把那段"禁止调工具"的 `NO_TOOLS_PREAMBLE`（`prompt.ts:19-26`）**前置并写得极硬**（"工具调用会被拒绝、会浪费你唯一的一轮、你会任务失败"），就是为了把这 2.79% 压回去。**这种"模型升级反而带出新失败模式、再用 prompt 工程补救"的真实拉锯，是逆向和自析都给不出的一手细节。**

> **小结**：以上 6 个机制——服务端 API microcompact(180K/40K)、时间维度 microcompact(gap 触发)、API-round grouping、skill 跨压缩存活、Session Memory 实验、cache-sharing fork + Sonnet 4.6 兜底数据——**全部是 Barazany 原文未覆盖、靠还原源码才看见的版图**。它们和原文的三层主线拼在一起，才是 Claude Code 压缩引擎在 v2.1.88 这一快照下的较完整面貌。再次提醒：这仍是社区从发布包反混淆的还原源码，命名/数值可能随版本变化。

---

## 八、横向印证：三个一手开源 harness 如何为 Barazany 论点背书

Barazany 谈的是闭源 Claude Code（逆向 + 自析）。为检验其论点是否"普适"还是"孤例"，下表用三个**可见源码**的 harness 逐条对照。结论：**原文每一个核心论点，都能在至少一个一手开源实现里找到同向证据。**

| Barazany 的论点（基于 Claude Code 逆向） | Codex（Rust，一手） | OpenCode（TS，一手） | Hermes（Python，一手） |
|---|---|---|---|
| **成本阶梯：先抹除/截断，摘要最后** | 90% 触发摘要；撞墙再退头部 trim（`compact.rs:258`） | `TOOL_OUTPUT_MAX_CHARS=2_000` 先截断，溢出才摘要（`compaction.ts:13,236`） | Phase1 占位符抹除 → 不够才 `_generate_summary`（`context_compressor.py:150,1305`） |
| **只保留最近 N 个工具结果，其余占位符替换** | 头部 trim（粒度为消息） | `pruned` 时间戳隐藏（`message.ts:120`） | `[Old tool output cleared to save context space]`（`context_compressor.py:150`），首3尾20保护 |
| **保护缓存前缀，删旧不动前缀** | `remove_first_item()` 只删一条，注释 `preserve cache (prefix-based)`（`compact.rs:258-262`） | 估算超 `context-max(output,buffer)` 才动（`compaction.ts:236`） | `system_and_3` 4 断点钉头+滚动尾（`prompt_caching.py:49-86`） |
| **摘要调用复用主对话前缀，不换 system prompt** | 本地在同会话追加压缩 turn；远程走 `/responses/compact`（`client.rs:152`） | `buildPrompt` 续写既有 context，迭代复用 `previousSummary`（`compaction.ts:166,182`） | 失败回退主对话压缩 `_fallback_to_main_for_compression`（`context_compressor.py:1278`） |
| **压缩后重建：重注锚点/文件/工具** | `insert_initial_context_before_last_real_user_or_summary`（`compact.rs:489`） | 重放最后用户消息 + `recent` 字段（`compaction.ts:226`） | 重注首3尾20（`protect_first_n/last_n`，`context_compressor.py:675`） |
| **缓存经济学是隐形主线** | 远程 compact 端点为复用会话状态优化 | 减少冗余读、buffer 设计 | 注释量化 `~75%` 成本下降（`prompt_caching.py:5`） |
| **结构化多段摘要模板** | 4 点 handoff | 8 段模板（Goal/Constraints/Progress/Decisions/Next/Critical/Files…，`compaction.ts:19-52`） | 7 段模板 |

> **判读**：原文 6 节论点在三套独立源码里**全部有同向印证**，没有一条是 Claude Code 独有的"魔法"。这把 Barazany 的个案观察提升为**行业级规律**：成本阶梯 + 前缀保护 + 摘要复用前缀 + 压缩后重建，是 2026 年 agentic 上下文管理的"四大公理"。**唯一的先进度差异在于"删旧时能否做到无损保缓存"**——Claude Code（据原文）有服务端 `cache_edits` 这一最优解，开源阵营目前多用"少删/隐藏/固定断点"等次优但同向的近似。

---

## 九、洞察升华

**1）压缩的真正难点不是"压"，是"在成本约束下压且不破坏任务"。**
Barazany 全文最大的认知升级，是把"context engineering"重新定义为"**context engineering under a cost constraint**"。脱离缓存经济学谈压缩，就像脱离散热谈超频——能跑，但活不久。三层架构、cache_edits、摘要复用前缀，没有一个是为了"压得更狠"，全都是为了"压得**更省**且**不掉链子**"。

**2）"删旧"与"保缓存"的对立，是 agent 架构的一道分水岭题。**
这道题有三档答案：(a) 朴素删除——简单但烧钱（前缀全失效）；(b) 少删/隐藏/固定断点——Codex/OpenCode/Hermes 的次优解，接受部分损失换实现简单；(c) 服务端 `cache_edits` 定向删除——Claude Code 据称达到的"无损外科手术"。一个 harness 在这道题上的答案，基本决定了它长会话的经济性上限。

**3）压缩后行为正确性 = 重建 + continuation message，被严重低估。**
工业界对"压缩"的讨论几乎全在"摘要质量/触发阈值"，而 Barazany 点出**真正区分生产级与玩具级的是"接得住"**：重读最近文件防过期、continuation message 防摘要污染行为。这部分是"行为工程"，不是"token 工程"，却决定了自主 agent 在压缩边界会不会"突然失忆并开始复述"。

**4）价格引力场导致架构收敛。**
0.1× vs ~22.5× 的两数量级价差，是一个强引力场。它解释了为何独立团队、不同语言、互不抄袭的 harness，最终都收敛到几乎相同的压缩架构——它们是被同一个成本函数拉向同一个吸引子。**理解了缓存经济学，就能预测一个新 harness 的压缩设计大概会长什么样。**

**5）对 OpenClaw/我们自身的启示。**
我们的 LCM（Lossless Context Management，grep + DAG 展开）路线，与 Barazany 描述的"确定性 curation 优先"在哲学上完全同向，且更激进地追求**无损**——把"换出"的历史留在可检索的外部存储，需要时按需召回，而非有损摘要。结合本文：(a) 我们的"删旧"也应优先走"保前缀"的路径；(b) 压缩/换出后同样需要"重建 + continuation"防止行为漂移；(c) 缓存断点布局可借鉴 Hermes `system_and_3` 的"头 + 滚动尾"。

---

## 十、参考来源

**主文献（本报告剖析对象）**
- Jonathan Barazany，《Claude Code's Compaction Engine: What the Source Code Actually Reveals》，barazany.dev，<https://barazany.dev/blog/claude-codes-compaction-engine>（作者第二篇）
- Jonathan Barazany，《Context Engineering — What Keeps AI Agents From Losing Their Minds》，barazany.dev（作者第一篇，原文反复引用）

**还原源码（本次逐行确证的核心资源，社区逆向、非官方）**
- Claude Code `v2.1.88` 社区从 npm 发布包反混淆得到的还原源码，本地路径 `repos/claude-code-source-code/src/services/compact/`：`autoCompact.ts:30,33,62,67-70,73,300`、`apiMicrocompact.ts:15-17,18-25,34-55`、`microCompact.ts:36,52,84-118,261-269,276,295-336,402-443`、`timeBasedMCConfig.ts:18-34`、`grouping.ts:13-16,22,34-42`、`postCompactCleanup.ts:17-20,31-49,65-69`、`sessionMemoryCompact.ts:1-3,11,55-60,412-420`、`prompt.ts:11-26,358-359`、`compact.ts:122-124,328-341,1441`。**声明：这是社区反混淆的还原源码，非 Anthropic 官方一手源码，命名/数值可能随版本变化。**

**一手开源源码（本地 clone，交叉印证，真实路径/行号）**
- `openai/codex`（Rust）：`codex-rs/core/src/compact.rs:54-76,258-262,489`；`codex-rs/core/src/client.rs:152,486`
- `sst/opencode`（TS/Effect-TS）：`packages/core/src/session/compaction.ts:13-52,166,182-186,236-238`；`packages/core/src/session/message.ts:120`
- `NousResearch/hermes-agent`（Python）：`agent/prompt_caching.py:5-7,49-86`；`agent/context_compressor.py:150,675-676,1278,1305`

**我们已有研究**
- 黄山，《代表性 Agent Harness 的「自动上下文压缩」机制深度研究》，`research/2026-06-16-agent-context-compaction.md`
- 关联：`research/2026-06-17-justin3go-compaction-deepread.md`、`research/2026-06-09-harness-engineering-deep-research.md`

**学术理论（原理层支撑）**
- MemGPT: Towards LLMs as Operating Systems，arXiv 2310.08560（main/external context 分页 → "换出可重取" 的理论根基）
- StreamingLLM: Efficient Streaming Language Models with Attention Sinks，arXiv 2309.17453（attention sink → "保护头部锚点/首部消息" 的根据）
- RoPE / 因果注意力相关基础（解释"删头致前缀 KV 全失效"的位置编码机理）

---

> **再次声明**：本文为对 Jonathan Barazany 原文的**深度剖析与技术延展**，原文要点版权归原作者所有；本次在原文逆向之上引入社区从 **v2.1.88 npm 发布包反混淆的还原源码**逐行确证（比原文逆向精确一个量级），但**仍属社区逆向、非 Anthropic 官方一手源码**，命名/数值可能随版本变化；服务端（API侧）实现仍属合理推断。本报告另以三个一手开源 harness 的可见源码交叉印证并标明边界。原文出处：<https://barazany.dev/blog/claude-codes-compaction-engine>。
