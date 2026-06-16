# 代表性 Agent Harness 的「自动上下文压缩」机制深度研究

> 研究日期：2026-06-16 · 研究员：黄山（System Architect & Technology Researcher）
> 方法：官方文档 + 工程师深度博客 + **本地 clone 源码逐行研读** + arXiv 论文原文 + 社区交叉验证
> 本地源码仓库：`openai/codex`、`sst/opencode`、`NousResearch/hermes-agent`（均已 clone 并标注真实文件路径/行号）

---

## 一、执行摘要

### 核心发现

1. **「精准遗忘」已成为 2026 年 Agent Harness 的核心竞争力**，而非无限扩大上下文。所有成熟 harness 都遵循同一条「成本阶梯」原则：**先用零成本的本地规则（截断/裁剪工具结果），再用缓存友好的手段，最后才动用昂贵且有损的 LLM 摘要**。

2. **触发器普遍是 token 阈值占比**，但各家定的值差异巨大，反映不同哲学：
   - Codex CLI：**90%**（`context_window * 9 / 10`，激进榨干窗口）
   - Claude Code：**~有效窗口 - 13K**（约 70% 处主动触发，留 20K 给摘要本身）
   - OpenCode：**isOverflow**（约 `context - max(output, 20K buffer)`，即接近满才触发）
   - Hermes Agent：**50%**（agent 层）+ **85%**（gateway 安全网），双层
   - Gemini CLI：**70%**（保守）

3. **「自摘要」是主流**：几乎所有 harness 都用**同一个/同系列模型**对自己的历史做摘要，且都用**固定章节模板**（Goal / Progress / Decisions / Files / Next Steps），强制具体化、禁止泛泛而谈。

4. **缓存经济学（Prompt Cache）是隐藏的架构主线**：Claude Code 的 `cache_edits`、Hermes 的 `system_and_3` 4 断点缓存、Codex 从头部 trim 以保前缀——本质都是「宁可少删，也要保住缓存前缀」。

5. **无损 vs 有损的路线分化**：OpenCode 用**时间戳标记隐藏（非物理删除）**，数据留在 DB 中可回溯；Hermes 通过 `ContextEngine` ABC 支持**插件式 LCM（Lossless Context Management）**替换默认有损压缩器。这是 2026 年的新趋势——把「压缩」抽象成可插拔策略。

### 各 Harness 压缩机制对比表

| 维度 | **Codex CLI** | **Claude Code** | **OpenCode** | **Hermes Agent** | Gemini CLI |
|------|--------------|-----------------|--------------|------------------|-----------|
| 开源 | ✅ Rust | ❌（社区逆向） | ✅ TS/Effect-TS | ✅ Python | ✅ TS |
| 触发阈值 | 90% 窗口 | ~有效窗口-13K（≈70%） | isOverflow(≈满-20K) | 50%(agent)+85%(gateway) | 70% |
| 压缩层数 | 单层（摘要） | 5 策略阶梯 | 2 层（prune+summary） | 4 阶段 pipeline | 单层摘要 |
| 工具结果处理 | 物理删除 | 占位替换+cache_edits | 时间戳隐藏（非删除） | 占位替换 `[Old tool output cleared]` | 随历史摘要 |
| 摘要结构 | 4 点 handoff | 9 段结构化 | 8 段模板 | 7 段模板 | 状态快照 |
| 用户消息 | **逐字永久保留**(≤20K tok) | 摘要进 9 段 | 摘要+重放末条 | 摘要(保护首3/尾20) | 摘要 |
| 缓存优化 | 头部 trim 保前缀 | cache_edits（核心） | 减少冗余读 | system_and_3 4断点 | — |
| 迭代再压缩 | 否（叠加新摘要） | 是 | 是（update previous） | 是(`_previous_summary`) | 是 |
| 压缩后行为 | 被动等待 | 主动重读≤5文件/50K | 重放最后用户消息 | 重注首尾 | 继续 |
| 失败处理 | 头部 trim 兜底→报错 | 3 次失败熔断 | 返回 false 跳过 | catch→丢中段(无摘要) | — |
| 可关闭 | 可配 limit | — | `OPENCODE_DISABLE_AUTOCOMPACT` | `enabled:false` | 可配 |
| 远程压缩 | ✅ `/responses/compact` | ✅ 服务端 compaction API | ❌ | ❌ | ❌ |

---

## 二、理论框架

### 2.1 本质问题：有限窗口 vs 长程信息累积

Transformer 的注意力是 O(n²)，上下文窗口在预训练时被钉死（StreamingLLM 论文指出 Llama-2 仅 4K 训练窗口）。Agentic 任务却天然「信息单调累积」——每一次工具调用（读文件、grep、跑测试）都把大块文本压入历史。justin3go 的实测场景显示：一个 26 条消息的登录 bug 修复会话消耗 ~15,400 token，其中 5 条工具结果就占 **81%**。矛盾由此产生：**任务需要长程记忆，但窗口塞不下，且「上下文腐烂（context rot）」会让模型在窗口未满时就开始变笨**。

mem0 引用 Zylos Research 2026 调查：**2025 年 65% 的企业 Agent 失败源于「多步推理中的上下文退化」，而非原始 token 耗尽**——这解释了为何各家都倾向「提前压缩」而非「撞墙才压」。

### 2.2 压缩策略分类学（7 类原语）

| 策略 | 机制 | 有损性 | 代表 |
|------|------|--------|------|
| **截断 Truncation** | 直接砍最旧消息 | 高损（破坏多步推理） | naive baseline；Codex 头部 trim 兜底 |
| **摘要 Summarization** | LLM 把历史压成结构化文本 | 中损（细节丢失/漂移） | 全部 harness 的最后一层 |
| **检索召回 RAG** | 历史外置向量库，按需召回 | 低损但有召回率风险 | mem0、LlamaIndex |
| **分层记忆 Hierarchical** | OS 式分页：主上下文↔外部存储 | 可控 | MemGPT/Letta |
| **工具结果外置/抹除 Offloading/Elision** | 旧工具输出替换为占位符 | 低损（可重取） | Claude Code Tier1、Hermes Phase1、OpenCode prune |
| **结构化状态 Scratchpad/State** | 外部文件存任务状态 | 无损 | CLAUDE.md、AGENTS.md、todo 文件 |
| **缓存边界保护 Cache-aware trim** | 只删尾部以保前缀缓存命中 | — | Claude Code cache_edits、Codex 头部 trim |

**无损 vs 有损权衡**：有损摘要省 token 但会「context drift」（模型复述时偏离原意）——Claude Code 用「强制直接引用原文关键短语」对抗；OpenCode 用「时间戳隐藏而非删除」保留回溯可能；OpenClaw/Hermes 的 LCM 插件路线则追求真正无损（grep + DAG 展开）。

**何时触发**：三种范式——(1) token 阈值占比（主流，70–90%）；(2) 显式命令 `/compact`/`/compress`；(3) 被动兜底（捕获 `prompt_too_long` 错误后反应式压缩，Claude Code & OpenCode 都有）。

### 2.3 相关学术理论（论文原文研读）

**① MemGPT: Towards LLMs as Operating Systems**（arXiv 2310.08560，UC Berkeley）
- 核心机制：借鉴 OS 虚拟内存/分页。把上下文分为 **main context（窗口内，类比 RAM）** 与 **external context（窗口外，类比 disk）**。LLM 通过**函数调用自主**在两者间「分页」——`memory.read/write`、检索旧对话。用「中断（interrupt）」机制在窗口将满时让模型自己决定换出什么。
- 与 harness 关联：这是「分层记忆」的奠基论文，Letta 框架的 Memory Blocks 即其产品化。Claude Code 的「Session Memory」、Hermes 的外置 summary 都是其精神后裔，但 harness 们用**确定性规则**取代了 MemGPT「让模型自主分页」的方案（因为后者不可靠、烧 token）。

**② StreamingLLM: Efficient Streaming Language Models with Attention Sinks**（arXiv 2309.17453，MIT Han Lab）
- 核心机制：发现 **attention sink** 现象——自回归 LLM 把大量注意力分数无脑分配给**最初几个 token**（即使无语义意义），因为 Softmax 要求分数和为 1，模型需要一个「泄洪口」。仅缓存 **4 个初始 sink token + 滑动窗口 KV**，即可让模型稳定处理 **400 万 token** 而无需微调，比滑动窗口重计算快 22.2×。
- 与 harness 关联：解释了为何**保护「头部消息」（system prompt + 首次交换）如此关键**——Hermes 硬编码 `protect_first_n=3`、Codex 压缩后重注 initial context、Claude Code 永久驻留 CLAUDE.md，本质都暗合「头部 token 是注意力锚点，删了就崩」。这是 KV-cache 层的发现，但在消息层被工程师复刻为「首尾保护」直觉。

**③ LLMLingua / LongLLMLingua**（arXiv 2310.05736，Microsoft）
- 核心机制：用一个**小模型（如 GPT-2/LLaMA-7B）计算 token 困惑度（perplexity）**，删除「低信息量、高可预测」的 token，实现 coarse-to-fine 的提示压缩，最高 20× 压缩比而性能基本不掉。LongLLMLingua 进一步解决长上下文的「position bias（迷失在中间）」。
- 与 harness 关联：这是**token 级别的有损压缩**，与 harness 的**消息级摘要**正交。目前主流 coding agent **未直接采用**（因为代码对精确性敏感，删 token 风险高），但属于「提示压缩」这一支的代表，理论上可作为摘要的补充。

**④ 其他相关支线**（标题+核心机制，未逐篇全文精读，如实标注）：
- **H2O (Heavy-Hitter Oracle)**：KV-cache 驱逐策略，保留累积注意力高的「重击者」token。
- **RECOMP / AutoCompressors**：把检索文档压成「摘要向量/soft prompt」喂给 LLM。
- **Activation Beacon**：训练专门的 beacon token 压缩激活值，扩展有效窗口。
- 这几支均属**模型/推理层**压缩，与本研究关注的 **harness 应用层（消息编排）** 不同层次——harness 工程师几乎不碰 KV-cache，而是在「消息列表」这一抽象上做文章。

> **关键理论洞察**：学术界主攻「模型/KV 层」（StreamingLLM、H2O、LLMLingua），而 harness 工程界几乎全部停留在「消息编排层」（摘要 + 工具结果抹除 + 缓存边界）。两者几乎不交叉。harness 偏爱消息层的原因：**可移植（不依赖特定模型）、可调试、可回退、配合 Prompt Cache 经济学**。

---

## 三、逐对象深度剖析

### 3.1 Codex CLI（openai/codex，Rust）

**辨析**：研究对象是 **codex-cli agent harness**（GPT-5/5.5 系列），而非已退役的旧 codex 代码补全模型。Rust 实现位于 `codex-rs/`。

**触发器（源码精确值）**——`codex-rs/protocol/src/openai_models.rs:433`：
```rust
pub fn auto_compact_token_limit(&self) -> Option<i64> {
    let context_limit = self
        .resolved_context_window()
        .map(|context_window| (context_window * 9) / 10);   // ← 默认 90% 窗口
    let config_limit = self.auto_compact_token_limit;
    if let Some(context_limit) = context_limit {
        return Some(config_limit.map_or(context_limit, |limit| std::cmp::min(limit, context_limit)));
    }
    config_limit
}
```
即默认在 **90% 上下文窗口**触发；若用户配置了 `model_auto_compact_token_limit`，取两者较小值。判断逻辑在 `codex-rs/core/src/session/turn.rs:745-775` 的 `auto_compact_token_status()`：`token_limit_reached = auto_compact_scope_tokens >= auto_compact_scope_limit || full_context_window_limit_reached`。在 `run_pre_sampling_compact()`（turn.rs:790）每个采样前检查，超限即调 `run_auto_compact(...)`。

**双路径设计**（交叉验证：justin3go 博客 + 源码）：
- **本地路径** `codex-rs/core/src/compact.rs`：客户端构造 prompt，流式调 LLM 生成摘要，兼容任意 provider。
- **远程路径** `codex-rs/core/src/compact_remote.rs`：调 OpenAI 内部端点。源码 `client.rs:152` 确证：`const RESPONSES_COMPACT_ENDPOINT: &str = "/responses/compact";`，`client.rs:486` 的 `compact_conversation_history()`。仅当 `provider.supports_remote_compaction()`（`model-provider-info/src/lib.rs:399`，仅 OpenAI）为真时走远程。远程只外包「生成摘要」一步，前处理（trim 超长 function call）/后处理（过滤 stale developer 消息、恢复 ghost snapshot 供 /undo、重算 token）仍在客户端。

**压缩管线**（`compact.rs` `run_compact_task_inner_impl`，行 ~195-330）：
1. 把压缩 prompt 作为 user input 追加，流式请求 LLM 产出摘要 suffix。
2. `summary_text = format!("{SUMMARY_PREFIX}\n{summary_suffix}")`。
3. `collect_user_messages()`（compact.rs:453）**收集全部历史用户消息**（排除既有 summary 消息）。
4. `build_compacted_history()`（compact.rs:536）重建历史：**逐字保留用户消息**，但有 `COMPACT_USER_MESSAGE_MAX_TOKENS = 20_000` 上限（compact.rs:50），从尾部向前选，超限则 `truncate_text` 截断。
5. 末尾压入一条 role=user 的摘要消息。
6. 通过 `replace_compacted_history()` 替换会话历史。

**摘要 prompt**（`codex-rs/prompts/templates/compact/prompt.md`，源码原文）：
```
You are performing a CONTEXT CHECKPOINT COMPACTION. Create a handoff summary
for another LLM that will resume the task.
Include:
- Current progress and key decisions made
- Important context, constraints, or user preferences
- What remains to be done (clear next steps)
- Any critical data, examples, or references needed to continue
Be concise, structured, and focused on helping the next LLM seamlessly continue the work.
```
**摘要前缀**（`summary_prefix.md`）注入新上下文时前置：「Another language model started to solve this problem and produced a summary... Use this to build on the work that has already been done and avoid duplicating work.」——即「交接备忘录（handoff）」哲学。

**边界处理**：压缩请求本身若 `ContextWindowExceeded`，`compact.rs:259` 处理：`history.remove_first_item()` **从最旧开始砍（保前缀缓存、保最近消息）**，重试；砍到只剩 1 条仍超则报错。压缩完成后发 Warning：「Long threads and multiple compactions can cause the model to be less accurate. Start a new thread...」（compact.rs ~325）——OpenAI 官方承认多次压缩会掉精度。

**外置记忆**：`AGENTS.md`（项目级指令，类比 CLAUDE.md，作为 base_instructions 常驻）。

**工程权衡**：最「直觉化」（handoff 备忘录人人懂），但**最 all-or-nothing**——所有 assistant 回复与工具结果被摘要替换，摘要漏了细节就永久丢失。唯一缓和：用户消息逐字保留（≤20K）。

---

### 3.2 Claude Code（Anthropic，闭源；社区逆向 + 官方 API 文档交叉验证）

> 声明：Claude Code 不开源。以下基于（a）官方 Compaction API 文档与 Cookbook；（b）Jonathan Barazany（barazany.dev，让 Claude 分析其自身泄漏源码）；（c）Ken Huang Substack 引用的源码片段；（d）社区泄漏仓库。多源一致处标"已交叉验证"，单源标"待证"。

**五策略成本阶梯**（Ken Huang，引 `src/services/compact/autoCompact.ts`、`src/QueryEngine.ts`）：
1. **Snip**：本地删特定消息区间，无 API 调用
2. **Micro-compact**：编辑 prompt-cache 条目而非重发
3. **Context collapse**：归档旧消息，查询时投影一个折叠视图
4. **Auto-compact**：API 摘要旧历史（主动）
5. **Reactive compact**：捕获 `prompt_too_long` 的紧急兜底

**三层精准遗忘**（barazany.dev + justin3go 交叉验证）：
- **Tier 1 工具结果裁剪（零 LLM 成本）**：每次请求前跑的本地规则引擎。保留最近 ~5 个工具结果，更旧的替换为 `[Old tool result content cleared]`。保留 tool_call（模型记得"我搜过/读过"），只删 tool_result 内容（需要时重新 read_file）——"选择性失忆"而非"彻底遗忘"。
- **Tier 2 缓存友好策略（Prompt Cache）**：Claude Code 的招牌。**只在尾部裁剪，绝不动消息序列前半部**，以保 Anthropic Prompt Cache 前缀命中。关键创新 `cache_edits`：缓存温热时**不修改本地消息**，而是发送 `cache_edits` 块随请求一起，**按 `tool_use_id` 让服务端外科手术式删除工具结果块，不碰缓存前缀**。否则缓存失效要付 1.25× 重写费——实测过的替代方案有 98% 缓存未命中率。
- **Tier 3 九段结构化摘要（最后手段）**：阈值 = **有效窗口 - 13,000 tokens**，其中**有效窗口 = 模型窗口 - min(最大输出, 20,000)**（这 20K 是给摘要输出预留的）。

**触发阶梯**（Ken Huang）：~70% 有效窗口主动 auto-compact；~90% 警告用户；~98% 阻断新请求强制手动压缩。getEffectiveContextWindowSize 源码：
```javascript
// src/services/compact/autoCompact.ts
export function getEffectiveContextWindowSize(model: string): number {
  const reservedTokensForSummary = Math.min(
    getMaxOutputTokensForModel(model),
    MAX_OUTPUT_TOKENS_FOR_SUMMARY,   // 20,000
  )
  return getContextWindowForModel(model, getSdkBetas()) - reservedTokensForSummary
}
```

**九段摘要结构**（justin3go，社区逆向）：① 用户原始意图 ② 核心技术概念 ③ 关注的文件与代码 ④ 遇到的错误及修复 ⑤ 问题求解逻辑链 ⑥ 所有用户消息摘要 ⑦ TODO ⑧ 当前工作 ⑨ 建议下一步。**强制要求模型直接引用原文关键短语**而非全部转述——对抗 context drift。

**Session Memory Compact 优先**（justin3go）：达到阈值时，系统**先试 Session Memory Compact**（利用会话内存中已有的结构化信息替代完整 LLM 调用），大多数 auto-compact **根本不需要 LLM 调用**；仅当 session memory 路径不可用/不足才回退传统 LLM 摘要。

**压缩后状态重建**（barazany.dev + justin3go 交叉验证）：① 注入 lead-in（"本会话续自之前对话…"）；② **自动重读最近编辑的文件（最多 5 个，总预算 50,000 tokens，单文件 5,000）**；③ 重声明 tool/skill 定义；④ CLAUDE.md 作为 system prompt 一部分永久驻留不受压缩影响；⑤ 若压缩前 agent 在自主运行，continuation message 告诉它"你本来就在干活，别理会摘要、别复述、直接继续"。

**缓存复用的摘要调用**（barazany.dev）：Tier 3 摘要**不另起 system prompt**，而是复用与主对话**完全相同的 system prompt/tools/model/消息前缀**，压缩指令作为新 user 消息追加在末尾——服务端看到相同 cache key 直接命中。

**熔断与崩溃恢复**（Ken Huang，源码）：
```javascript
// 连续 3 次压缩失败即停（MAX_CONSECUTIVE_AUTOCOMPACT_FAILURES = 3），避免烧钱
if (tracking?.consecutiveFailures >= MAX_CONSECUTIVE_AUTOCOMPACT_FAILURES) {
  return { wasCompacted: false }
}
// 压缩边界写入时记录 tailUuid（最后保留消息），崩溃后用它精确定位重启点
// QueryEngine.ts：compact_boundary 后 splice 掉 pre-compact 消息，防内存泄漏
```

**官方化**：2026 年 Anthropic 推出**服务端 Compaction API**（`compact-2026-01-12` beta header，Opus 4.6 推荐），及 SDK 级 `compaction_control` 参数（自动在 `<summary></summary>` 中压缩，可指定更便宜的摘要模型）——把上述能力产品化为一个参数。

**工程权衡**：最复杂但最"高性价比"——多数时候只跑 Tier 1 规则引擎或 Session Memory 路径，零额外 LLM 调用；缓存经济学贯穿每个设计决策（cache_edits / 摘要复用前缀 / 三层延迟摘要）。代价：闭源、依赖 Anthropic 专有缓存特性。

---

### 3.3 OpenCode（sst/opencode，TypeScript + Effect-TS）

> 源码注记：仓库内现存**两套实现**——较新的 `packages/core/src/session/compaction.ts`（head/recent split + 摘要）与较成熟的 `packages/opencode/src/session/compaction.ts`（prune 隐藏 + summary，含 overflow.ts）。justin3go 描述的「时间戳隐藏」对应后者。两套均逐行读过，以下为综合。

**触发器（源码精确）**——`packages/opencode/src/session/overflow.ts`：
```typescript
const COMPACTION_BUFFER = 20_000
export function usable(input) {
  const reserved = input.cfg.compaction?.reserved ??
    Math.min(COMPACTION_BUFFER, ProviderTransform.maxOutputTokens(input.model, input.outputTokenMax))
  return input.model.limit.input
    ? Math.max(0, input.model.limit.input - reserved)
    : Math.max(0, context - ProviderTransform.maxOutputTokens(...))
}
export function isOverflow(input) {
  if (input.cfg.compaction?.auto === false) return false       // 可关闭
  const count = input.tokens.total || (input.tokens.input + output + cache.read + cache.write)
  return count >= usable(input)   // ← 接近满（窗口 - 20K buffer）才触发
}
```
注：社区 issue #11314 提到可配置 `threshold`（默认 0.75）的提案，但当前主干以 `isOverflow`（≈满）为实际触发；二者反映版本演进。**已交叉验证**：环境变量 `OPENCODE_DISABLE_AUTOCOMPACT` 可禁用（badlogic gist）。

**两步阶梯治理**：

**Step 1 — Prune（标记隐藏，非物理删除）**`compaction.ts:253` `prune()`：
```typescript
export const PRUNE_MINIMUM = 20_000    // 至少能省 20K 才动手
export const PRUNE_PROTECT = 40_000    // 最近 40K token 工具输出为安全垫
const PRUNE_PROTECTED_TOOLS = ["skill"]  // skill 类工具输出永不裁剪
// 从尾部倒序遍历；turns<2 跳过（保护最近 2 个用户轮）；
// 遇到带 summary 的 assistant 消息 break；累计工具输出超 PRUNE_PROTECT 后的旧工具结果加入 toPrune
if (pruned > PRUNE_MINIMUM) {
  for (const part of toPrune) {
    part.state.time.compacted = Date.now()   // ← 关键：盖时间戳"隐藏"而非删除
    yield* session.updatePart(part)
  }
}
```
**核心设计**：盖 `compacted = Date.now()` 时间戳使其在后续请求"不可见"，**数据仍在数据库**——为未来历史回溯/审计/回滚留门。这是三家中唯一非破坏性的。

**Step 2 — LLM 摘要**（`select()` 选 head/tail 边界，`tail_turns` 默认 2，`preserveRecentBudget` = `min(8K, max(2K, usable*0.25))`）：用隐藏的专用 agent（不打扰用户当前交互）调 LLM 生成**结构化摘要**。`packages/core` 版模板为 8 段（Goal / Constraints & Preferences / Progress[Done/In Progress/Blocked] / Key Decisions / Next Steps / Critical Context / Relevant Files）。

**摘要 prompt**（`packages/opencode/src/agent/prompt/compaction.txt` 原文）：
```
You are an anchored context summarization assistant for coding sessions.
Summarize only the conversation history you are given. The newest turns may be
kept verbatim outside your summary, so focus on the older context that still matters...
If the prompt includes a <previous-summary> block, treat it as the current
anchored summary. Update it with the new history by preserving still-true
details, removing stale details, and merging in new facts.
... Respond in the same language as the conversation.
```

**两大贴心设计**（justin3go）：① **自动重放最后一条用户消息**——压缩后 agent 的记忆锚点停在用户最新指令而非冷冰冰的摘要，用户完全无感；② **跟随用户语言**——中文交流则摘要也用中文（源码 prompt 末句 "Respond in the same language"）。

**迭代再压缩**（`compaction.ts` core 版 `buildPrompt`）：有 `<previous-summary>` 块时指示 LLM "Update the anchored summary... Preserve still-true details, remove stale details, and merge in the new facts"——锚定式更新而非从头摘要。

**边界处理**：摘要 LLM 报错/失败 → 返回 `false` 跳过本次压缩（core 版 `compactAfterOverflow` 多处 `return false`）；大媒体附件超限时有专门 synthetic 消息解释"附件太大已移除"。工具结果序列化时 `TOOL_OUTPUT_MAX_CHARS = 2_000` 截断。

**外置记忆**：`AGENTS.md`（项目指令）。

**工程权衡**：最"开发者友好"——全开源 TS、Effect-TS 现代架构、非物理删除留扩展空间。最易深度定制压缩行为。

---

### 3.4 Hermes Agent（NousResearch/hermes-agent，Python）

**辨析结论**：「Hermes」此处 = **Nous Research 的 Hermes Agent harness**（GitHub `NousResearch/hermes-agent`），**不是** Nous Hermes 系列模型本身。已确认存在真实开源 Python 仓库，含 `agent/context_compressor.py`（2426 行）、`agent/context_engine.py`（ABC）、`agent/prompt_caching.py`。官方文档站 `hermes-agent.nousresearch.com`。本节为**官方文档 + clone 源码逐行**双重验证，是四对象中验证最扎实者。

**可插拔 ContextEngine（2026 新趋势）**`agent/context_engine.py`（ABC）：上下文管理抽象为 `ContextEngine`，内置 `ContextCompressor` 为默认（有损摘要），但插件可替换为如 **LCM（Lossless Context Management）** 引擎（`context.engine: "lcm"`）。插件**永不自动激活**，必须用户显式配置。`should_compress()` / `compress()` / `lcm_grep` 为引擎接口。——这正是 OpenClaw lossless-claw 插件的对接点。

**双层压缩系统**（官方文档「Dual Compression System」+ 源码）：
- **Gateway Session Hygiene（85% 阈值）**`gateway/run.py`：pre-agent 安全网，用 `estimate_messages_tokens_rough` 粗估，防止会话在两轮间（如 Telegram/Discord 隔夜累积）撑爆 API。`len(history) >= 4` 才动。
- **Agent ContextCompressor（50% 默认，可配）**`agent/context_compressor.py`：主压缩系统，跑在 agent 工具循环内，用 API 报告的精确 token 数。两层故意错开：都设 50% 会导致长 gateway 会话每轮都压。

**触发器（源码精确值）**`context_compressor.py`：
```python
_SUMMARY_RATIO = 0.20
_PRUNED_TOOL_PLACEHOLDER = "[Old tool output cleared to save context space]"
# __init__ 默认参数（行 674-695）：
threshold_percent: float = 0.50      # 50% 触发
protect_first_n: int = 3             # system + 首 3 条非 system 永久保护
protect_last_n: int = 20            # 最少保护尾部 20 条
summary_target_ratio: float = 0.20
# 行 712:
self.threshold_tokens = max(int(self.context_length * threshold_percent), ...)
# should_compress (行 815): if tokens < self.threshold_tokens: return False
```
`threshold_tokens = threshold × 主 agent 模型上下文窗口`（**永远是主模型窗口，非摘要模型窗口**）。200K 模型默认：阈值 100K，尾部预算 = 100K×0.20 = 20K，max_summary = min(200K×0.05, 12K) = 10K。

**preflight 预检（无 LLM）**`should_compress_preflight()`（Ken Huang 引）：每次 API 调用前用字符数粗估（`estimate_tokens_rough`：`len(text) // 4`，~4 字符/token）抢先判断，必要时在请求发出前就压缩。另有 `should_defer_preflight_to_real_usage()`（行 785）处理粗估噪声：粗估高但真实 token 历史低于阈值时容忍 `max(4096, threshold×0.05)` 的增长，避免误触发。

**Codex gpt-5.5 阈值自动抬升**（文档独有细节）：ChatGPT Codex OAuth 后端把 gpt-5.5 硬限 272K（同 slug 在 OpenAI 直连/OpenRouter 是 1.05M）。默认 50% 会在 ~136K 触发——浪费一半可用窗口。故当路由是 `provider: openai-codex` 且模型 gpt-5.5 时，Hermes 自动把触发抬到 **85%**（~231K）。`hermes config set compression.codex_gpt55_autoraise false` 可退回。

**四阶段压缩算法**`ContextCompressor.compress()`：
- **Phase 1 — Prune 旧工具结果（无 LLM）**：保护尾部外、>200 字符的旧工具结果替换为 `[Old tool output cleared to save context space]`。
- **Phase 2 — 确定边界**：`[0..protect_first_n]` 头部保护；`[3..N]` 中段 SUMMARIZED；`[N..end]` 尾部（token 预算优先，回退 `protect_last_n` 计数）。`_align_boundary_backward()`（行 1832）走过连续 tool_result 找到父 assistant 消息，**不切断 tool_call/tool_result 组**。
- **Phase 3 — 生成结构化摘要**：整个中段单次 `call_llm(task="compression")` 发给摘要模型。**摘要模型窗口必须 ≥ 主模型窗口**，否则 API 报 context-length error，`_generate_summary()` catch、log warning、返回 `None`——压缩器随后**无摘要地丢弃中段，静默丢失上下文（这是压缩质量退化最常见原因）**。7 段模板：Goal / Constraints & Preferences / Progress(Done/In Progress/Blocked) / Key Decisions / Relevant Files / Next Steps / Critical Context。摘要预算 `content_tokens × 0.20`，上限 `min(context×0.05, 12000)`，调用时 `max_tokens = int(summary_budget × 1.3)`。模板强制具体（"NEVER include API keys... write [REDACTED]"，且输出再过 `redact_sensitive_text` 二次脱敏）。
- **Phase 4 — 组装**：`_sanitize_tool_pairs()` 清理孤立 tool_call/tool_result 对。

**迭代再压缩**`_previous_summary`（行 613/1462-1523）：后续压缩把上次摘要传给 LLM 指示**更新而非重摘**——条目从 In Progress→Done，加新进展，删过时。带 `/compress <focus>` 时 focus topic 获 60-70% 预算。

**Prompt 缓存**`prompt_caching.py` `system_and_3` 策略：放最多 4 个 `cache_control` 断点 = system prompt（断点1）+ 最后 3 条非 system 消息（断点2-4），TTL 5m/1h，多轮对话省 ~75% 输入成本。配合**frozen snapshot**（system prompt 会话开始构建一次、永不中途变更）保证缓存前缀稳定。

**工程权衡**：单主策略 + 缓存，比 Claude Code 简单聚焦。最大隐患：摘要模型窗口 < 主模型窗口时静默丢中段。亮点：ContextEngine ABC 的可插拔无损路线（LCM）代表 2026 前沿。

---

### 3.5 加分对象（对比补充）

**① Gemini CLI（google-gemini/gemini-cli，TS）**：`tryCompressChat` / `compressChatHistory`，常量 `COMPRESSION_TOKEN_THRESHOLD = 0.7`（issue #12068 确证）——**70% 保守触发**，社区争论是否抬到 90%。`compressionThreshold` 可配（issue #21792）。机制为整段历史摘要成状态快照后续接。属"早压、保守"派（vs Codex 的 90% 激进派）。

**② Cline（cline/cline，VS Code 扩展）**：Auto Compact（docs.cline.bot/features/auto-compact）——接近窗口限制时自动生成"保留所有技术决策与代码改动"的综合摘要，然后从断点精确续接，宣称 5M token 任务可在 200K 窗口完成。支持压缩前状态恢复。issue #5616 反映新 condense 特性曾导致过度烧 token/上下文丢失——印证摘要式压缩的固有风险。

**③ Goose（Block，Rust）**：Smart Context Management（goose-docs.ai）——接近 token 限制时自动 compact（摘要）旧对话，保留关键信息，无需手动干预。标准的阈值触发 + LLM 摘要范式。

**④ Aider（Aider-AI/aider，Python）**：路线**不同**——不做对话摘要，而靠 **Repo Map**（用 tree-sitter + PageRank 提取仓库关键符号/签名，按 token 预算动态裁剪），把"代码库理解"压进固定预算，而非压缩对话历史。代表"检索/结构化外置"而非"摘要"路线。issue #752 显示其 repo map token 上限曾不被严格遵守。

**⑤ 框架原语**：
- **MemGPT/Letta**：分层记忆 + Memory Blocks，模型自主分页（见 2.3）。
- **LangChain**：`ConversationSummaryBufferMemory`（缓冲+摘要混合）、`ConversationSummaryMemory`（滚动摘要）。
- **LlamaIndex**：`SummaryIndex`、`ChatSummaryMemoryBuffer`，及 RAG 召回原语。
- 框架提供"原语积木"，harness 提供"端到端策略"——前者灵活但需自己拼，后者开箱即用。

---

## 四、横向对比与工程权衡分析

### 4.1 触发哲学的光谱

```
保守(早压, 牺牲窗口换稳定)  ←─────────────────────────→  激进(榨干窗口, 赌摘要质量)
   Hermes 50%   Gemini 70%   Claude ~70%(有效窗-13K)        OpenCode≈满    Codex 90%
```
- **Hermes 50% + gateway 85%** 双层最保守：mem0 指出"context drift 在 token 满之前就杀死 agent"，提前压缩留质量裕度。
- **Codex 90%** 最激进：最大化利用付费窗口，但官方自己警告多次压缩掉精度。
- truefoundry 生产经验：**主动压（well below limit, ~75%）优于反应式压**，否则 agent 已在"高风险区"运行数轮、质量滑坡。

### 4.2 五大工程权衡轴

| 权衡轴 | A 方案 | B 方案 | 谁选谁 |
|--------|--------|--------|--------|
| 用户消息 | 逐字保留(Codex) | 一并摘要(其余) | Codex 重"用户意图不可篡改"；其余重空间效率 |
| 工具结果 | 物理删除(Codex) | 占位(Claude/Hermes)/隐藏(OpenCode) | 可重取性 vs 简单性 |
| 删除方向 | 删头部(naive) | 只删尾保前缀(Claude/Codex trim) | **缓存命中是关键经济动机** |
| 摘要时机 | 阈值即摘(Codex/Gemini) | 阶梯延迟(Claude/Hermes/OpenCode) | LLM 摘要昂贵且有损，能不调就不调 |
| 可逆性 | 不可逆(Codex/Claude) | 时间戳隐藏可逆(OpenCode)/无损插件(Hermes LCM) | 审计/回溯需求 |

### 4.3 共性收敛（4 条"行业事实标准"）

1. **成本阶梯**：零成本本地规则 → 缓存友好 → LLM 摘要（最后）。无一例外。
2. **首尾保护**：保 system prompt + 首交换（attention sink 直觉）+ 最近 N 轮（活跃工作）。
3. **结构化模板摘要**：Goal/Progress/Decisions/Files/Next Steps 五要素几乎成行业模板，强制具体化反 drift。
4. **迭代更新摘要**：再压缩时 update previous 而非从头摘——跨多次压缩保信息。

### 4.4 分歧点（真正的设计取舍）

- **缓存策略**：Claude Code 的 `cache_edits`（服务端按 tool_use_id 删，不动前缀）是最精巧的，因为它同时解决了"删旧"与"保缓存"的冲突；其余只能靠"删尾保头"近似。
- **无损 vs 有损**：OpenCode 时间戳隐藏 + Hermes LCM 插件代表"可逆/无损"新潮流，与 Codex/Claude 的"不可逆摘要"形成路线分歧。
- **谁来摘要**：多数用主模型自摘要（复用缓存）；Hermes/Claude SDK 允许配独立（更便宜）摘要模型——但 Hermes 要求摘要模型窗口 ≥ 主模型，否则静默丢上下文。

---

## 五、关键洞察

1. **缓存经济学是隐形的第一性原理**。表面看是"省 token / 防溢出"，深层是"省钱"。Claude Code 的全部三层设计、Codex 的头部 trim、Hermes 的 frozen system prompt + system_and_3，本质都服务于"保住 Prompt Cache 前缀"。**压缩不只是 context engineering，是成本约束下的 context engineering**（barazany.dev 原话）。这解释了为何"删尾不删头"成为铁律——不是因为旧消息不重要，而是删头会让整个缓存前缀失效，付 1.25× 重写费 + 全量重算。

2. **harness 层与模型层的压缩几乎不交叉**。学术界（StreamingLLM/H2O/LLMLingua）攻 KV/token 层；工程界全在消息编排层。原因：消息层可移植、可调试、可回退、配合缓存。harness 工程师把 StreamingLLM 的"attention sink"直觉**朴素地复刻为"保护首尾消息"**——虽然机制完全不同层，但直觉惊人一致。

3. **"精准遗忘 > 无限记忆"是 2026 共识**。justin3go 的结论、mem0 的 65% 失败数据、Codex 官方的"多次压缩掉精度"警告，三方独立指向同一点：**记住一切的 agent 最易被噪声分心**。压缩的价值不在压缩本身，而在"主动丢弃噪声、保留信号"。

4. **趋势预判**：
   - **可插拔上下文引擎**（Hermes ContextEngine ABC + LCM 插件、OpenClaw lossless-claw）将普及——把"压缩"从硬编码变成可替换策略，无损/有损按需切换。
   - **非破坏性 + 可回溯**（OpenCode 时间戳隐藏）会成默认——数据留底，支持审计/回滚/历史遍历。
   - **服务端压缩官方化**（Codex `/responses/compact`、Anthropic Compaction API）会让端侧 harness 逐渐瘦身，把压缩外包给 provider 的优化基础设施（更便宜的摘要模型 + 内部缓存）。
   - **行为层监控**兴起（gist 评论提到的 compression-monitor：ghost lexicon、behavioral fingerprint、drift score）——从"何时/如何压"转向"压完模型行为怎么变"。

5. **给自研 harness 的启示**：若要做 OpenClaw 类系统的压缩，应：(a) 默认走成本阶梯（先 prune 工具结果再摘要）；(b) 用结构化模板 + 强制引用原文反 drift；(c) 保首尾 + 删尾不删头保缓存；(d) 迭代更新摘要；(e) 提供可插拔无损引擎逃生口（LCM）；(f) 摘要失败要熔断（3 次）而非死循环；(g) 压缩后主动重建（重读关键文件、重注工具定义、续接指令）。

---

## 六、参考来源清单（全部可验证）

### 论文（arXiv 原文，已研读核心机制）
- MemGPT: Towards LLMs as Operating Systems — https://arxiv.org/pdf/2310.08560 （虚拟上下文管理/OS 分页）
- Efficient Streaming Language Models with Attention Sinks (StreamingLLM) — https://arxiv.org/html/2309.17453v3 （attention sink，4 初始 token + 滑窗）
- LLMLingua: Compressing Prompts for Accelerated Inference — https://arxiv.org/html/2310.05736v2 （困惑度驱动 token 级压缩）
- LongLLMLingua — https://www.microsoft.com/en-us/research/project/llmlingua/longllmlingua （长上下文 position bias）
- Letta Memory Blocks — https://www.letta.com/blog/memory-blocks

### 源码（本地 clone，标注真实路径/行号）
- **Codex CLI** openai/codex：
  - `codex-rs/protocol/src/openai_models.rs:433` auto_compact_token_limit（90%）
  - `codex-rs/core/src/session/turn.rs:745-790` 触发判断
  - `codex-rs/core/src/compact.rs`（compact.rs:50 MAX_TOKENS、:259 头部trim、:453 collect_user_messages、:536 build_compacted_history）
  - `codex-rs/core/src/compact_remote.rs` + `client.rs:152` `/responses/compact`
  - `codex-rs/prompts/templates/compact/prompt.md` & `summary_prefix.md`（摘要 prompt 原文）
- **OpenCode** sst/opencode：
  - `packages/opencode/src/session/overflow.ts`（isOverflow/usable，COMPACTION_BUFFER=20K）
  - `packages/opencode/src/session/compaction.ts`（PRUNE_MINIMUM=20K, PRUNE_PROTECT=40K, prune 时间戳）
  - `packages/core/src/session/compaction.ts`（8 段 SUMMARY_TEMPLATE）
  - `packages/opencode/src/agent/prompt/compaction.txt`（摘要 prompt 原文）
- **Hermes Agent** NousResearch/hermes-agent：
  - `agent/context_compressor.py`（2426 行：threshold 0.50, protect_first_n 3, protect_last_n 20, _SUMMARY_RATIO 0.20, 占位符, 四阶段, _previous_summary）
  - `agent/prompt_caching.py`（system_and_3，4 断点）
  - `agent/context_engine.py`（ContextEngine ABC，LCM 插件点）
  - 官方文档 https://hermes-agent.nousresearch.com/docs/developer-guide/context-compression-and-caching

### 工程师深度博客 / 官方文档（已深读）
- justin3go《Shedding Heavy Memories: Context Compaction in Codex, Claude Code, and OpenCode》 — https://justin3go.com/en/posts/2026/04/09-context-compaction-in-codex-claude-code-and-opencode
- Jonathan Barazany《Claude Code's Compaction Engine: What the Source Code Actually Reveals》 — https://barazany.dev/blog/claude-codes-compaction-engine （cache_edits 关键来源）
- Ken Huang《Chapter 6: Context Management at Scale (Claude Code vs. Hermes Agent)》 — https://kenhuangus.substack.com/p/chapter-6-context-management-at-scale （Claude 5 策略 + 源码片段）
- mem0《Context Compression in AI Agents: Hermes vs. Claude Code》 — https://mem0.ai/blog/how-hermes-and-claude-handle-context-compression... （65% 失败数据、双层阈值交叉验证）
- badlogic（Mario Zechner）compaction.md gist — https://gist.github.com/badlogic/cd2ef65b0697c4dbe2d13fbecb0a0a5f （Codex/Claude/OpenCode/Amp prompt 原文）
- Anthropic Cookbook: Automatic context compaction — https://platform.claude.com/cookbook/tool-use-automatic-context-compaction
- Steve Kinney: Claude Code Compaction — https://stevekinney.com/courses/ai-development/claude-code-compaction
- TrueFoundry: Context Engineering Gateway — https://www.truefoundry.com/blog/context-engineering-gateway-session-management（75% 主动压缩生产经验）

### 加分对象来源
- Gemini CLI threshold 0.7 — https://github.com/google-gemini/gemini-cli/issues/12068 ；compressionThreshold — issue #21792
- Cline Auto Compact — https://docs.cline.bot/features/auto-compact ；issue #5616（过度压缩）
- Goose Smart Context Management — https://goose-docs.ai/docs/guides/sessions/smart-context-management
- Aider Repo Map — https://aider.chat/docs/repomap.html ；issue #752

---

## 七、质量门控自检（四维逐条）

**① 覆盖率**：4 个核心对象**全部实质覆盖**，且深度递减如下：
- Codex CLI ✅ 本地 clone 源码逐行（触发常量、双路径、prompt 模板、trim 兜底）——**最高源码深度**
- Hermes Agent ✅ 本地 clone 源码逐行（2426 行 compressor + 缓存 + ABC）+ 官方文档双验——**最高源码深度**
- OpenCode ✅ 本地 clone 源码逐行（两套实现 + overflow + prompt）——**最高源码深度**
- Claude Code ✅ 闭源，但官方 API/Cookbook + 3 篇含源码片段的逆向博客交叉验证——**充分但非一手源码**（已明确声明）
- 加分对象覆盖 **5 个**：Gemini CLI、Cline、Goose、Aider、LangChain/LlamaIndex/MemGPT 框架原语。

**② 源码深度**：真打开了本地 clone 的源码并摘录真实片段。随机自验 3 处真实存在：
- `codex-rs/protocol/src/openai_models.rs:433` `(context_window * 9) / 10` ✅ 已 sed 读出
- `hermes-agent/agent/context_compressor.py:145` `_SUMMARY_RATIO = 0.20`、:150 占位符、:674 默认参数 ✅ 已 grep 读出
- `opencode/packages/opencode/src/session/compaction.ts:38-39` `PRUNE_MINIMUM=20_000 / PRUNE_PROTECT=40_000` ✅ 已 sed 读出
- 另：`codex-rs/core/src/client.rs:152` `/responses/compact` 端点 ✅ grep 确证。

**③ 论文深度**：3 篇核心论文给出真实核心机制（非抄标题）：MemGPT=OS 虚拟内存分页/中断；StreamingLLM=attention sink（Softmax 泄洪口）+ 4 初始 token；LLMLingua=困惑度驱动 coarse-to-fine token 删除。H2O/RECOMP/AutoCompressors/Activation Beacon 如实标注为"标题+机制概述、未逐篇全文精读"。

**④ 数据可信**：每个关键结论标 URL/源码路径。关键机制做了交叉验证：
- Codex 90%（源码）+ justin3go + badlogic gist 三方一致；
- Claude Code 三层 + cache_edits：barazany + Ken Huang + justin3go 三方一致；
- Hermes 50%/85% 双层 + 四阶段：官方文档 + clone 源码 + mem0 三方一致；
- 矛盾/争议已标注：OpenCode 触发器存在 `isOverflow(≈满)` vs issue 提案 `threshold 0.75` 的版本差异；Claude Code 系闭源逆向、"actual implementation may vary across versions"已声明。
- **无编造**：未找到一手源码处（Claude Code、Gemini CLI 具体常量）均明确标注来源性质。

