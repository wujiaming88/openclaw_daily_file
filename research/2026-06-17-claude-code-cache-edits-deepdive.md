# 从源码深挖 Claude Code 的 cache_edits：一次"既删旧又保缓存"的外科手术

> **源码边界声明**：本文基于社区从 Claude Code **v2.1.88** npm 发布包反混淆得到的**还原源码**，**非 Anthropic 官方一手源码**。变量/函数名经 minify 还原，数值与命名可能随版本变化；服务端（API 侧）的真实行为本文只能依据客户端可见的契约**推断**。凡"推断"处均已标注。所有引用标注真实 `文件:行号`，但请读者以"高置信逆向"而非"官方文档"对待。
>
> **一句话**：`cache_edits` 是 Claude Code 压缩引擎里最精巧的一招——它要同时满足两个看似互斥的目标：**删掉旧工具结果（省 token）**，又**不破坏 prompt cache 前缀（省钱）**。本文从还原源码出发，把这套"带外删除 + 前缀冻结"的机制拆到状态机层面。

---

## 一、矛盾的起点：为什么"删旧"和"缓存"天生打架

### 1.1 KV cache 与前缀匹配的"全有或全无"

Anthropic 的 Prompt Cache 按 **token 前缀**缓存：服务端把"从第 1 个 token 到某个断点"的 KV（Key/Value）注意力计算结果缓存下来。命中的**铁律是前缀逐字节一致**——这是 Transformer 因果注意力（causal attention）的数学必然：

- 第 N 个 token 的 KV 向量依赖它**前面所有** token（causal mask 只让它看到 ≤N 的位置）。
- 因此只要前缀里第 k 个 token 变了（k<N），第 k 之后**每一个** token 的 KV 都失效，必须从第 k 个重算。
- 叠加 RoPE（旋转位置编码）：删掉中间一条消息会让其后所有 token 的**绝对位置**整体平移，等价于全部 KV 作废。

结论：**缓存命中是"全有或全无"的**——前缀动一个字节，整条前缀的缓存红利清零。

### 1.2 成本账：删一条旧消息可能比不删更贵

把缓存折算成钱（量级参考，随定价变化）：

| 操作 | 相对成本 |
|---|---|
| 缓存命中（cache read） | ≈ 基础输入价的 **0.1×**（便宜约 10 倍） |
| 写入缓存（cache write） | ≈ **1.25×** |
| 未命中、全量重算前缀 | 付全价 1.0× + 可能的 1.25× 重写 |

于是出现一个反直觉的结论：**朴素地"删掉一条旧工具结果"，若它在缓存前缀里，会触发整条前缀失效 + 重写**——你为了省下那几千 token，反而付出了"重算几万 token 前缀"的代价。Barazany 在其文章里把这总结为一句话（原意）：你刚刚让压缩比它省下的 token 更贵。

这就是 `cache_edits` 要解决的核心矛盾。

---

## 二、Claude Code 的解法总览：把"删除"从客户端动作变成 API 层带外指令

还原源码里，工具结果的清理有**两条物理路径**，分流的关键变量是"缓存是热还是冷"：

1. **冷缓存 → 本地直接抹除**：反正前缀都要重写，干脆在请求前就把旧工具结果的本地内容替换成占位符 `[Old tool result content cleared]`，让"被重写的内容"更少。这条路径会修改本地消息。
2. **热缓存 → cache_edits 带外删除**：**绝不碰本地消息**，而是把"要删哪些 `tool_use_id`"打包成一个 `cache_edits` 块，随 API 请求一起下发，让**服务端**在不破坏缓存前缀的前提下"外科手术式"移除指定工具结果。

源码里这条分流写得非常直白。`microCompact.ts:262-269` 的注释（还原源码原文）：

```
// Time-based trigger runs first ... the server cache has expired
// and the full prefix will be rewritten regardless — so content-clear old
// tool results now, before the request, to shrink what gets rewritten.
// Cached MC (cache-editing) is skipped when this fires: editing assumes a
// warm cache, and we just established it's cold.
```

翻译这段设计意图：**时间维度的 microcompact 先跑**——如果距上一条 assistant 消息的间隔已超过阈值（默认 60 分钟，对齐服务端 1h 缓存 TTL），那么缓存**铁定已凉**，前缀反正要全量重写，此时直接本地 content-clear 最划算；而 `cache_edits`（代码里叫 cached MC / cache-editing）**假设缓存是热的**，既然已确定是冷的，就跳过它。

> **这是全文第一个值得记住的设计**：`cache_edits` 不是无脑启用的，它只在"缓存还热、值得保前缀"时才上场；缓存已凉时，朴素的本地抹除反而是最优解。**warm/cold 分流**本身就是缓存经济学的直接产物。

---

## 三、服务端策略契约：`clear_tool_uses_20250919`——cache_edits 是 Anthropic API 的一等公民

`apiMicrocompact.ts` 里有一组与服务端契约的 TypeScript 类型，揭示了服务端到底能接受什么指令。

### 3.1 两个"日期版本化"的策略类型

`apiMicrocompact.ts:34-58`（还原源码节选）：

```ts
export type ContextEditStrategy =
  | {
      type: 'clear_tool_uses_20250919'
      trigger?: { type: 'input_tokens'; value: number }
      keep?:    { type: 'tool_uses'; value: number }
      clear_tool_inputs?: boolean | string[]
      exclude_tools?: string[]
      clear_at_least?: { type: 'input_tokens'; value: number }
    }
  | {
      type: 'clear_thinking_20251015'
      keep: { type: 'thinking_turns'; value: number } | 'all'
    }
```

值得品味的设计细节：

- **日期版本化名字**（`20250919` / `20251015`）：说明这是 Anthropic API 的**一等公民特性**（不是客户端黑魔法），按日期演进、保证向后兼容。
- **双策略**：一类清工具结果（`clear_tool_uses`），一类清思考块（`clear_thinking`）。`thinking_turns` 说明服务端能独立识别 extended-thinking 轮次、单独裁剪。
- **双阈值表达力**：`trigger` 决定"什么时候动"（input_tokens 超某值时触发），`keep` / `clear_at_least` 决定"动多少"。意味着**服务端是在语义层面上裁剪**，而非机械屏蔽。
- **定向排除**：`exclude_tools` / `clear_tool_inputs` 让客户端表达"哪些工具别动"、"是否连工具调用的输入也清"等粒度。

### 3.2 默认阈值：180K 触发 / 保末尾 40K

`apiMicrocompact.ts:15-17`：

```ts
const DEFAULT_MAX_INPUT_TOKENS    = 180_000  // Typical warning threshold
const DEFAULT_TARGET_INPUT_TOKENS = 40_000   // Keep last 40k tokens like client-side
```

注意源码注释明确写"**Match client-side microcompact token values**"——服务端与客户端阈值刻意对齐，避免两边重叠触发。`clear_at_least: triggerThreshold - keepTarget = 140_000 tokens` 意味着**一旦超 180K，服务端一次性至少清 140K**，而非小打小闹裁个几千。这是典型的"要动就一次动够，别反复付重写费"。

### 3.3 可被服务端清除结果的工具白名单

`apiMicrocompact.ts:18-30`：

```ts
const TOOLS_CLEARABLE_RESULTS = [
  GREP_TOOL_NAME, GLOB_TOOL_NAME,
  ...SHELL_TOOL_NAMES,
  WEB_FETCH_TOOL_NAME, WEB_SEARCH_TOOL_NAME,
  FILE_READ_TOOL_NAME, FILE_WRITE_TOOL_NAME,
  NOTEBOOK_EDIT_TOOL_NAME,
]
```

这份名单里都是**可重现、可重取**的工具——读文件能再读、搜索能再搜、bash 输出同理。**只在"幂等可重取"的工具上使用 cache_edits**，是重要的安全边界：丢了最多重跳一次工具调用，不会造成不可恢复的状态损失。

---

## 四、pin/consume 状态机：cache_edits 的真正精髓（博客几乎没讲透的部分）

到这里我们只解释了"一次性把 cache_edits 块发出去"这件事。但**真正精巧的工程问题在后续**：

> 第二轮、第三轮请求时，前缀里之前发过的那些 `cache_edits` 指令，如果不带、或者位置变了，**前缀就又变了**——前缀变 → 缓存又失效。怎么办？

还原源码用一个**三件套状态机**解决了这个问题：`pin` + `consume` + `getPinned`。

### 4.1 三个 API 各司其职

`microCompact.ts:84-118` 的还原源码定义了三个互补的入口：

```ts
// 取出"本轮新产生、待随下一次请求发出"的 edits（取后清空）
export function consumePendingCacheEdits(): CacheEditsBlock | null { ... }

// 取出"历史已钉住、必须每轮按原位重发以维持缓存命中"的 edits
export function getPinnedCacheEdits(): PinnedCacheEdits[] { ... }

// 把一个新 edits 块"钉"到指定的 user 消息位置
export function pinCacheEdits(userMessageIndex: number, block: CacheEditsBlock): void {
  if (cachedMCState) {
    cachedMCState.pinnedEdits.push({ userMessageIndex, block })
  }
}
```

注释（源码原意）：

> `Pin a new cache_edits block to a specific user message position. Called after inserting new edits so they are re-sent in subsequent calls.`

这是状态机的核心：**新产生的 edits 是"流动的"（`pendingCacheEdits` 模块级变量，consume 后清空）；而一旦插入会话，它就被"钉"到具体的 user 消息位置（`PinnedCacheEdits[]`），此后每一次 API 请求都必须把它在原位重新发出去**。

### 4.2 为什么必须"原位重发"——前缀逐字节哈希的硬约束

回到 §1.1 的 KV cache 原理：服务端的缓存键是**前缀的逐字节哈希**。如果第 5 轮 user 消息上挂了一个 cache_edits 块，到第 6 轮请求时这个块**消失了**或**位置移了**，那从该点之后的整段前缀对服务端来说就是**新内容**——KV 缓存全部失效，前缀重写费照付。

所以 cache_edits 的工程契约是：

1. **第一次产生**：在某轮 user 消息后插入新的 edits 块 → 客户端用 `pinCacheEdits(userMessageIndex, block)` 把它"钉"在那一格。
2. **后续每一轮**：通过 `getPinnedCacheEdits()` 把所有历史钉住的块**按原位**重新塞进请求里——**这些块的存在和位置必须维持下去**，否则前缀缓存就废了。
3. **本轮如果又触发了新一次清理**：通过 `consumePendingCacheEdits()` 取出新块，发给 API 后，再次 `pinCacheEdits` 钉到本轮的 user 消息位置上。

换句话说，**cache_edits 块不是"一次性指令"，而是"会话上的持久化注解"**——它寄生在 user 消息的位置上，与该消息绑定终生。

### 4.3 cachedMicrocompactPath：实际编排流程

`microCompact.ts:305-369` 的 `cachedMicrocompactPath()` 把上面这套状态机运转起来。简化版流程（基于源码原意复述）：

```
1. compactableToolIds = collectCompactableToolIds(messages)
   // 收集本轮"理论上可清"的工具调用 id

2. for each user message:
     for each tool_result block in message:
       if tool_use_id ∈ compactableToolIds && 还没注册过:
         registerToolResult(state, tool_use_id)
     registerToolMessage(state, groupIds)
   // 把"哪些 tool_result 属于哪个 user 消息"记进 state

3. toolsToDelete = getToolResultsToDelete(state)
   // 由 cachedMicrocompact 模块按 GrowthBook 配置（triggerThreshold/keepRecent）选出本轮要删的

4. if toolsToDelete.length > 0:
     cacheEdits = createCacheEditsBlock(state, toolsToDelete)
     pendingCacheEdits = cacheEdits     // ← 等待 consume

5. logEvent('tengu_cached_microcompact', {...})
   suppressCompactWarning()
   notifyCacheDeletion(querySource)     // ← 提示缓存破断检测

6. return { messages }   // ← 关键：本地消息原样返回，没动一根头发
```

最后一行注释（源码原话）：

> `Return messages unchanged - cache_reference and cache_edits are added at API layer`

这是 `cache_edits` 全部精神的浓缩：**消息层面什么都没动；删除是发生在 API 层的、面向 `tool_use_id` 的带外指令**。

### 4.4 一个被源码注释揭穿的"潜在 bug"

源码里有一处特别值得品味的注释，揭示了"prefix-match"在分布式系统里的微妙之处。`microCompact.ts:243-249`：

```ts
// Prefix-match because promptCategory.ts sets the querySource to
// 'repl_main_thread:outputStyle:<style>' when a non-default output style
// is active. ... the pre-existing cached-MC `=== 'repl_main_thread'` check
// was a latent bug — users with a non-default output style were silently
// excluded from cached MC.
```

意思是：原先用 `===` 严格相等判断"是否主线程"，结果开了非默认 output style 的用户的 querySource 被打成 `repl_main_thread:outputStyle:dark`，**严格相等判断失败 → 被静默踢出 cache_edits 路径**——那些用户在不知不觉中失去了缓存优化。修复方案是改用 `startsWith('repl_main_thread')` 前缀匹配。这种"前缀匹配 vs 严格相等"在缓存敏感的代码里影响巨大，是工程师从生产事故里学回来的教训。

---

## 五、模型门控：cache_edits 不是所有人都能用

`claude.ts:1188-1207` 把 cache_edits 的"启用门"建得非常严密：

```ts
let cachedMCEnabled = false
let cacheEditingBetaHeader = ''
if (feature('CACHED_MICROCOMPACT')) {
  const {
    isCachedMicrocompactEnabled,
    isModelSupportedForCacheEditing,
    getCachedMCConfig,
  } = await import('../compact/cachedMicrocompact.js')
  const betas = await import('src/constants/betas.js')
  cacheEditingBetaHeader = betas.CACHE_EDITING_BETA_HEADER
  const featureEnabled = isCachedMicrocompactEnabled()
  const modelSupported = isModelSupportedForCacheEditing(options.model)
  cachedMCEnabled = featureEnabled && modelSupported
  ...
}
```

启用门必须四把锁同时打开：

1. **bundle feature**：`feature('CACHED_MICROCOMPACT')` 编译期开关
2. **运行时配置**：`isCachedMicrocompactEnabled()`（GrowthBook 等动态配置可控）
3. **模型支持**：`isModelSupportedForCacheEditing(options.model)` —— 不是所有模型都支持
4. **API beta header**：`CACHE_EDITING_BETA_HEADER` —— 这是个未在 beta 文档里公开的 header

源码里两处注释（`claude.ts:1186-1187` 和 `:1194` 附近）明确把这条 import 称为 "**ant-only**"——说明 `cachedMicrocompact.js` 模块本身、`CACHE_EDITING_BETA_HEADER` 常量本身，在公开的 npm 发布包里**只剩调用点可见，定义被剥离了**。`createCacheEditsBlock` / `registerToolResult` / `getCachedMCConfig` 等核心函数在还原源码里**也搜不到一手定义**——它们是 Anthropic 内部模块，不发给外部用户。

> **这是 cache_edits 性质的根本边界**：它不是"开源的客户端技术"，而是 **Anthropic 垂直整合栈（自家模型 + 自家 API + 自家客户端）**的内部协同机制。外部用户能看到调用契约，但看不到也复现不了内部实现。我们这种"还原源码逆向"的能力是 push 到极限了——再下一层就要靠抓包/逆向 API 行为才能继续推进。

---

## 六、横向对照：codex / opencode / hermes 都做不到这种事

cache_edits 的能力是**有 API 层主动权**的产物。如果你只是"通用 LLM API 客户端"（无法让服务端执行带外删除），那再聪明也只能近似——这正是 codex / opencode / hermes 三个一手开源 harness 的共同处境。

| 维度 | Claude Code（cache_edits） | Codex CLI | OpenCode | Hermes |
|------|---|---|---|---|
| 关键源码位置 | `microCompact.ts:305-369` 调用 ant-only `cachedMicrocompact.js` | `compact.rs:258` `remove_first_item()` 注释 `preserve cache (prefix-based)` | `message.ts:120` `pruned: V2Schema.DateTimeUtcFromMillis` 时间戳 | `prompt_caching.py:5-7` 注释 `Reduces input token costs by ~75%` |
| 删除发生在哪 | **服务端 API 层**（cache_edits 块） | 客户端（remove 一条最旧消息） | 客户端（盖时间戳标记隐藏） | 客户端（占位符替换） |
| 是否动本地消息 | **不动** | 动（物理 remove） | 不动（数据留 DB） | 动（替换 content） |
| 前缀缓存命中策略 | **服务端按 tool_use_id 精确删除，前缀完全不变** | "删尾不删头"近似——只删一条最旧、最小化前缀变动 | "标记隐藏"近似——隐藏 ≠ 删除，但渲染时不带，前缀仍变 | `system_and_3` 4 断点缓存 system + 最近 3 条 |
| 谁能用 | 仅 Claude Code + Anthropic API 自家组合 | 任意 provider（local 路径） | 任意 provider | 任意 provider（断点是 Anthropic-only 但策略本身通用） |
| 设计前提 | 客户端能发"带外指令"让服务端动手 | 假设服务端是黑盒，只能从客户端动 | 同左 | 同左 |

**关键对比点**：codex 在源码注释里直白承认它的"删一条最旧消息"是**接受**前缀缓存的损失但**最小化**它（一次只删一条、保住最近消息）；opencode 用时间戳标记但实际渲染给 API 时仍要重排消息列表、前缀仍变；hermes 走的是"主动设置缓存断点"的反向思路（不去删，改为告诉服务端"在这几个位置帮我建立缓存"）。

**只有 Claude Code 能做到"删了，但前缀没变一个字节"**——因为它能改服务端的行为。这是垂直整合的真正威力。

---

## 七、洞察：cache_edits 教会我们什么

1. **缓存经济学是 agent 工程的隐形第一性原理**。`cache_edits` 整套设计的每一行代码都在围绕"前缀逐字节一致"这个硬约束转。从 warm/cold 分流、pin/consume 状态机、API 策略契约、模型门控，没有一处不是为了"少付一次重写费"。

2. **"压缩"在成熟的 harness 里早已不是一个动作，而是一个跨客户端/服务端的协议**。日期版本化的策略名 `clear_tool_uses_20250919` 说明 Anthropic 把"上下文管理"从"客户端 trick"提升到了"API 一等公民"。这是行业方向。

3. **真正的工程难度在状态机层面**。把"一次清理"做对不难，把"一系列清理跨多轮请求始终维持前缀稳定"做对极难——pin/consume/getPinned 三件套就是为这个而生。任何想抄 cache_edits 的 harness，**抄能力容易，抄状态机难**。

4. **垂直整合是终极护城河**。codex/opencode/hermes 不是不想要 cache_edits，是**做不到**——没有自家 API 就没有"让服务端外科手术删除"的能力。这给所有"基于第三方 LLM API 的 harness"敲响一个警钟：你能做到的最优解，有一个由 API 能力决定的天花板。

5. **对自研 harness 的启示**：
   - 没有自家 API 的，老老实实"删尾不删头"（codex 模式）；
   - 想做 reachability/audit 的，用时间戳软删除（opencode 模式）；
   - 自有 API 控制权的（如 OpenClaw 自己的 LCM 引擎），可以考虑把"压缩协议"做成一等公民——这正是 Hermes 的 `ContextEngine` ABC 想做的事；
   - 不论哪条路，**warm/cold 分流**的思想都值得抄——缓存已凉时直接本地清最划算。

---

## 八、参考来源

### 还原源码（v2.1.88，本文一手依据）

- `src/services/compact/microCompact.ts`：`:36`（`TIME_BASED_MC_CLEARED_MESSAGE`）、`:58/88/100/111`（`pendingCacheEdits` 状态 + 三件套 API）、`:243-300`（warm/cold 分流核心 + prefix-match 修复彩蛋）、`:305-369`（`cachedMicrocompactPath` 编排）
- `src/services/compact/apiMicrocompact.ts`：`:13-30`（白名单 + 默认阈值注释）、`:34-58`（`ContextEditStrategy` 类型定义）、`:113/137`（`clear_tool_uses_20250919` 策略实例化）
- `src/services/api/claude.ts`：`:1188-1207`（cache_edits 启用门 + ant-only `cachedMicrocompact.js` 动态 import + `CACHE_EDITING_BETA_HEADER`）
- 性质声明：来自社区从 npm 发布包反混淆，**非 Anthropic 官方一手**；`cachedMicrocompact.js` / `CACHE_EDITING_BETA_HEADER` 等核心定义在公开 bundle 中**已被剥离**，本文对其行为的描述基于调用点契约**推断**。

### 同主题前作

- 《代表性 Agent Harness 的"自动上下文压缩"机制深度研究》——逐对象源码剖析与论文综述
- 《深度剖析：Claude Code 的压缩引擎——源码究竟揭示了什么》——基于 v2.1.88 还原源码深化的 Barazany 解读

### 原始博客（作者 Jonathan Barazany、justin3go）

- Jonathan Barazany《Claude Code's Compaction Engine: What the Source Code Actually Reveals》 — <https://barazany.dev/blog/claude-codes-compaction-engine>
- Jonathan Barazany《Context Engineering — What Keeps AI Agents From Losing Their Minds》（前作） — <https://barazany.dev/blog/context-engineering-what-keeps-ai-agents-from-losing-their-minds>
- justin3go《Shedding Heavy Memories: Context Compaction in Codex, Claude Code, and OpenCode》 — <https://justin3go.com/en/posts/2026/04/09-context-compaction-in-codex-claude-code-and-opencode>
