# 深度解读：《Shedding Heavy Memories》——Codex、Claude Code、OpenCode 三家上下文压缩机制的技术展开

> **本文性质**：这是对一篇优秀技术博客的**深度解读 + 技术延展**，不是翻译搬运。
>
> **原文出处**
> - 标题：*Shedding Heavy Memories: Context Compaction in Codex, Claude Code, and OpenCode*
> - 作者：**justin3go**
> - 发布日期：**2026-04-09**
> - 原文链接：<https://justin3go.com/en/posts/2026/04/09-context-compaction-in-codex-claude-code-and-opencode>
>
> **声明**：原文用一个"15,400-token 登录 bug 修复"场景，系统对比了三家主流 CLI Agent 的上下文压缩策略，并提炼出"精准遗忘 > 无限记忆"的核心洞察。本文逐节复述其全部技术要点（信息覆盖 ≥90%），并在每节后追加【技术展开】，结合本地 clone 的**真实源码**（`openai/codex`、`sst/opencode`）把原文点到为止处讲透。原文那个 26 条消息的登录 bug 场景是**作者 justin3go 的原创示例**，本文引用并标注，绝不冒充原创。
>
> 解读人：黄山（System Architect & Technology Researcher）· 解读日期：2026-06-16

---

## 〇、为什么要读这篇文章——"越聊越笨"的工程根因

原文开篇抛出了一个所有重度 AI 编程用户都体感强烈的现象：**对话刚开始时 AI 思路清晰、指哪打哪；但随着轮次累积，它好像越来越"笨"**。等到上下文快用尽时，AI 会"赶进度"草草收尾，效果反而更差——社区称之为 **Context Anxiety（上下文焦虑）**，正如人类"忙中出错"。

原文给出的解法主线是：要让对话持续下去，Agent 必须**主动卸下一部分记忆（压缩 / compact）**。但"怎么卸、卸什么、卸完之后怎么恢复"，恰恰是衡量一个 Agent runtime 是否成熟的关键分水岭。原文随后用同一个登录 bug 场景，把 Codex CLI、Claude Code、OpenCode 三家的"压缩魔法"逐一拆开。

原文还特别注明了取证方法（这点很重要，决定了可信度边界）：**Codex CLI 与 OpenCode 基于开源仓库逻辑**；**Claude Code 基于社区逆向工程 + 泄漏源码验证**（闭源）。本文沿用同一边界，凡涉及 Claude Code 的常量/实现细节均标注"逆向"。

### 【技术展开】"越聊越笨"不是错觉——context rot 的三重机理

原文用"haste makes waste"做了通俗类比，但没有展开"为什么窗口还没满，模型就开始变笨"。这背后有三个可量化的机理：

1. **注意力稀释（attention dilution）**：Transformer 的自注意力对每个 query token 要在所有 key 上做 softmax 归一化（分数和为 1）。上下文越长，单位"注意力预算"被摊薄得越薄——真正关键的那几条指令，和成百上千行无关的工具输出抢同一份 softmax 概率质量。历史越长，关键信号的相对权重越低。

2. **Lost-in-the-middle（迷失在中间）**：实证研究反复发现，LLM 对**上下文头部和尾部**的信息检索准确率显著高于**中部**。一个 15,000 token 的会话里，第 8 条消息里的"保持向后兼容"这种关键约束，恰好落在最容易被忽略的中间地带。

3. **上下文腐烂（context rot）**：随着噪声（过期的工具输出、已被推翻的中间假设、失败的尝试）不断堆积，模型越来越难分辨"哪些还成立、哪些已作废"。前一篇研究报告引用的 mem0 / Zylos 数据指出：**2025 年约 65% 的企业 Agent 失败源于"多步推理中的上下文退化"，而非原始 token 耗尽**——这正是"窗口没满就变笨"的数据印证，也是各家倾向"提前压缩"而非"撞墙才压"的根本动因。

> 所以原文说的"卸下记忆"，本质不是"省空间"，而是**主动剔除噪声、提高信噪比**。压缩的价值不在压缩本身，而在"精准丢弃"。

---

## 一、场景重放：15,400-Token 的登录 bug 修复

> **作者原创示例声明**：以下场景是原文作者 justin3go 设计的教学示例，用来给三家方案提供同一把"标尺"。本文引用并复述其结构与数据，归功原作者。

原文设想：你在修一个登录接口返回 **401 Unauthorized** 的 bug，召唤 AI Agent 进入一场高强度调试。整段对话共 **26 条消息**，角色与 token 估算如下（复述原文表格）：

| # | 角色 | 摘要 | 估算 token |
|---|------|------|-----------|
| #1 | System | 系统提示（40+ 工具定义） | ~800 |
| #2 | User | "登录页返回 401，帮我 debug" | ~100 |
| #3 | Assistant | "我来搜一下 auth 相关逻辑" | ~150 |
| #4 | Tool Call | `grep "auth" --include="*.ts"` | ~50 |
| **#5** | **Tool Result** | **（返回 50 条搜索结果）** | **~2,000** |
| #6 | Assistant | "找到几处命中，看看 auth.ts" | ~150 |
| #7 | Tool Call | `read_file "src/auth.ts"` | ~50 |
| **#8** | **Tool Result** | **（整文件内容，~300 行）** | **~3,500** |
| #9 | Assistant | "找到了——token 校验没处理过期" | ~300 |
| #10 | User | "OK，但要保持对旧会话的向后兼容" | ~80 |
| #11 | Assistant | "明白，我再看看 middleware" | ~150 |
| #12 | Tool Call | `read_file "src/middleware.ts"` | ~50 |
| **#13** | **Tool Result** | **（middleware 全文）** | **~2,500** |
| #14 | Assistant | "middleware 也要改，我来处理" | ~200 |
| #15 | Tool Call | `edit_file "src/auth.ts"` (patch) | ~100 |
| #16 | Tool Result | "Successfully applied." | ~30 |
| #17 | Tool Call | `edit_file "src/middleware.ts"` (patch) | ~100 |
| #18 | Tool Result | "Successfully applied." | ~30 |
| #19 | Assistant | "代码改完，跑测试" | ~100 |
| #20 | Tool Call | `bash "npm test"` | ~50 |
| **#21** | **Tool Result** | **（3 个测试失败 + 堆栈）** | **~3,000** |
| #22 | Assistant | "3 个测试挂了，修测试用例" | ~200 |
| #23 | Tool Call | `edit_file "src/auth.test.ts"` (patch) | ~150 |
| #24 | Tool Result | "Successfully applied." | ~30 |
| #25 | Tool Call | `bash "npm test"` | ~50 |
| **#26** | **Tool Result** | **（全部通过，完整输出）** | **~1,500** |

原文的关键观察：仅 26 条消息就吃掉约 **15,400 token**；其中 5 条加粗的工具结果（#5/#8/#13/#21/#26）合计约 **12,500 token，占总量 81%**。这些数据在调试当下是关键的，但**bug 一旦修好，它们就变成上下文里的死重（dead weight）**。若不清理，下一轮就可能溢出窗口，丢掉系统提示或用户的核心诉求。

### 【技术展开】为什么"工具结果"是上下文膨胀的元凶

原文点出"81% 是工具结果"，但没展开这个比例背后的结构性必然。这要从 agentic 任务的本质说起：

- **信息单调累积（monotonic accumulation）**：普通聊天里，user/assistant 文本量大致均衡。但 agentic coding 的每一次"行动"——grep、read_file、npm test——都会把**一大块外部文本**灌进历史。一次 `read_file` 300 行就是 ~3,500 token，而触发它的 assistant 决策只有 ~50 token。**输入决策与输出数据的体量比可达 1:50 以上**。

- **结果是"一次性消费品"**：#8 读出的 auth.ts 全文，在 #9 模型"找到了"之后，其原始全文的价值就急剧衰减——模型真正要记住的是"token 校验没处理过期"这个结论，而不是 300 行源码。但默认情况下，那 300 行会**原封不动地占着上下文，直到会话结束**。

- **复算放大成本**：更隐蔽的是，这 12,500 token 不是只付一次。在没有缓存优化的实现里，**之后每一轮 API 请求都要重新把它们发一遍、重新计费、重新参与注意力计算**。26 条消息的会话里，#5 那 2,000 token 可能被重复发送十几次。

这正是三家方案都把"工具结果"当作**头号压缩目标**的根因——它体量最大、价值衰减最快、且最适合"用占位符替换 / 隐藏 / 重取"。原文后面三家的差异，本质都是在回答同一个问题：**这 81% 的死重，到底该删、该藏、还是该摘要？**


---

## 二、Codex CLI：写一份干净利落的"交接备忘录"

原文将 OpenAI 的 Codex CLI（[openai/codex](https://github.com/openai/codex)，Rust 实现）的思路概括成一句话：**把整段对话交给 LLM 写一份"交接摘要（handoff summary）"，再用这份摘要替换掉原始历史**。这是最符合人类直觉的"总结—替换"范式。

### 2.1 双路径设计（local / remote）

原文指出 Codex 提供两条压缩路径：

- **本地路径（`compact.rs`）**：客户端调用 LLM 生成摘要，**兼容任意模型 provider**。
- **远程路径（`compact_remote.rs`）**：直接调 OpenAI 内部端点 `responses/compact`，由服务端完成压缩，**仅限 OpenAI 模型**。

原文澄清了一个易混点：**"local / remote" 不是指"要不要调 LLM"——两条路都要调 LLM**。区别在于"生成摘要"这一核心步骤跑在哪：
- 本地路径里，客户端自己构造摘要 prompt（从内置模板 `templates/compact/prompt.md` 加载）、用 `ModelClientSession` 流式调 API、自己处理返回——整套编排都在你的机器上，所以兼容任意 provider。
- 远程路径里，客户端把准备好的对话历史 + 工具定义发给 OpenAI 的 `compact_conversation_history` 端点做服务端摘要——**但客户端绝非甩手掌柜**：调用前要裁剪过长的 function call 历史、组装含工具规格与系统指令的完整 prompt 对象；调用后要过滤结果（如丢弃过期的 developer 角色消息，只留真正的 user/assistant 内容）、为 `/undo` 功能恢复 ghost snapshot、重算 token 用量。

原文一句话点睛：**远程路径只把"压缩"这一步外包给 OpenAI 服务端，前处理/后处理仍在客户端**。其好处是 OpenAI 服务端很可能对该端点有专门优化（更便宜的模型、内部缓存），这是通用 API 拿不到的——体现了 OpenAI 对自家基础设施的**垂直整合**。

#### 【技术展开】用真实源码印证双路径

打开本地 clone 的源码，原文的描述逐一坐实：

```
// repos/codex/codex-rs/core/src/client.rs:152
const RESPONSES_COMPACT_ENDPOINT: &str = "/responses/compact";
// 行 153 注释：`/responses/compact` is unary, so the timeout covers the full response...
// 行 486：pub(crate) async fn compact_conversation_history(...)
// 行 508：RequestRouteTelemetry::for_endpoint(RESPONSES_COMPACT_ENDPOINT)
```

`/responses/compact` 端点字符串、unary（一次性非流式）语义、`compact_conversation_history()` 入口，全部与原文吻合。

**远程路径的工程意义（延展）**：为什么 OpenAI 要做垂直整合的远程压缩？三个深层理由——
1. **专用摘要模型更便宜**：摘要任务对"前沿推理能力"要求不高，但量大、频繁。服务端可路由到一个蒸馏过的、单价低得多的小模型，用户却仍按主模型体验得到结果。
2. **内部缓存复用**：服务端能在自家基础设施里缓存"对话历史 → 摘要"的中间计算，跨请求/跨用户层面优化，这是无状态通用 API 端点做不到的。
3. **协议级一致性**：把压缩沉到服务端，意味着不同客户端（CLI、IDE 插件、Web）共享同一套压缩语义，避免端侧各自实现导致的行为漂移。

代价是**厂商锁定**——`supports_remote_compaction()` 只对 OpenAI provider 为真，第三方模型只能走本地路径。

### 2.2 压缩流程详解

原文描述本地路径流程：Codex 先**抽取最近的用户消息（硬上限 ~20,000 token）**，再向 LLM 发一份简短的摘要 prompt。这份 prompt 只有 4 个核心点（原文转述，本文用源码原文印证）：

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
（源码原文：`repos/codex/codex-rs/prompts/templates/compact/prompt.md`）

原文强调关键词是 **"handoff"（交接）**——这不是写"会议纪要"，而是一份让"下一个人（模型）"能立刻上手的**交接简报**。

应用到登录 bug 场景，原文给出"压缩前后"的对照：**所有消息坍缩成仅 4 条**。Codex 深度尊重"用户意图"——它**物理删除所有 assistant 回复和工具相关消息，但逐字保留所有用户消息（#2 和 #10）**，然后插入一条"伪造的 assistant 消息"，里面装着结构化的交接摘要（任务目标、已完成项、关键架构决策、剩余 TODO）。对新模型来说，它根本不需要看那些海量文件转储和测试堆栈，**只要知道"测试已修好"就够了**。

#### 【技术展开】"逐字保留用户消息 ≤20K"背后的哲学，用源码坐实

原文说"逐字保留用户消息"，源码给出了精确的实现与边界：

```
// repos/codex/codex-rs/core/src/compact.rs:52
const COMPACT_USER_MESSAGE_MAX_TOKENS: usize = 20_000;

// :297  summary_text = format!("{SUMMARY_PREFIX}\n{summary_suffix}");
// :298  let user_messages = collect_user_messages(history_items);   // 收集全部历史用户消息
// :300  build_compacted_history(Vec::new(), &user_messages, &summary_text);
// :536  pub(crate) fn build_compacted_history(...)  // 重建历史：逐字保留用户消息 + 末尾压入摘要
```

`collect_user_messages()`（compact.rs:453）收集除既有 summary 外的全部用户消息；`build_compacted_history_with_limit()` 以 `COMPACT_USER_MESSAGE_MAX_TOKENS = 20_000` 为上限，**从尾部向前选取**，超限才 `truncate_text` 截断。

**"用户意图不可篡改"哲学（延展）**：为什么唯独用户消息享受"逐字保留"特权？因为在 Codex 的设计观里——
- **用户消息是"宪法"，模型回复和工具结果是"执行记录"**。执行记录可以被摘要（结论比过程重要），但用户的原始诉求一旦被 LLM 转述，就可能引入"context drift"：模型在复述"保持向后兼容"时，可能悄悄改成"尽量兼容"或干脆漏掉。逐字保留 = **杜绝意图在压缩中被稀释或篡改**。
- 20K 上限是务实妥协：若用户消息本身极长（粘贴了大段日志），也不能无限占用，于是给一个硬天花板，并优先保留**最近的**用户消息（从尾部选取）。

这是三家中独一份的设计——Claude Code 和 OpenCode 都会把用户消息一并卷进摘要。

### 2.3 自动触发与兜底

原文：当 token 用量逼近模型上下文窗口上限时，Codex **自动触发**压缩（无需手动 `/compact`）；若压缩后空间仍不够，它会退化到更激进的**"头部裁剪（head trimming）"**——从最旧的消息开始砍，确保对话能继续。

原文总结 Codex 的优劣：最大优点是**直觉化**（交接备忘录人人秒懂）；缺点是相当**"all-or-nothing"**——所有 AI 回复和工具结果被一份摘要替换，**一旦摘要漏了关键细节，就真的永久丢失了**。

#### 【技术展开】90% 触发阈值 + 头部 trim 兜底，源码精确印证

原文说"逼近窗口上限"，源码给出了精确的"90%"：

```rust
// repos/codex/codex-rs/protocol/src/openai_models.rs:433
pub fn auto_compact_token_limit(&self) -> Option<i64> {
    let context_limit = self
        .resolved_context_window()
        .map(|context_window| (context_window * 9) / 10);   // ← 默认 90% 窗口
    let config_limit = self.auto_compact_token_limit;
    if let Some(context_limit) = context_limit {
        return Some(config_limit.map_or(context_limit,
            |limit| std::cmp::min(limit, context_limit)));   // 用户配置与 90% 取较小值
    }
    config_limit
}
```

**90% 是三家中最激进的触发点**（Claude Code ≈ 有效窗口-13K≈70%，OpenCode ≈ 满-20K）。它的哲学是"最大化榨干付费窗口"——但 OpenAI 自己在压缩完成后会发一条 Warning："Long threads and multiple compactions can cause the model to be less accurate. Start a new thread..."，等于官方承认多次压缩会掉精度。激进触发 + 不可逆摘要，是一对需要权衡的组合。

头部 trim 兜底也有源码（这正是原文"更激进的头部裁剪"）：

```rust
// repos/codex/codex-rs/core/src/compact.rs:262
history.remove_first_item();   // 压缩请求自身若仍 ContextWindowExceeded，从最旧开始砍
```

**为什么是"砍头部"而不是"砍尾部"？（延展）** 这看似与 Claude Code 的"删尾保头"矛盾，实则统一于同一逻辑：这里被砍的是**压缩 prompt 内部已经准备好的历史 item**，砍最旧的能同时（a）保住最近消息（活跃信息）、（b）尽量保住前缀以利缓存。砍到只剩 1 条仍超限才报错。这是"摘要请求本身也可能溢出"的极端兜底，而非常规清理路径。

### 2.4 Codex 外置记忆

Codex 用 `AGENTS.md`（项目级指令，类比 Claude 的 CLAUDE.md）作为常驻 base instructions，不受压缩影响——这是它在"摘要会丢细节"之外，保留长期项目约束的逃生口。


---

## 三、Claude Code：三层"精准遗忘"

原文指出 Anthropic 的 Claude Code 走更精细的路线：**不追求一次性物理删除，而是设计了三层由轻到重、能不调 LLM 就不调的清理机制**。（原文声明：Claude Code 不开源，以下基于社区逆向 + 公开材料，实现可能随版本变化。）

### 3.1 Layer 1：工具结果裁剪（零 LLM 成本）

原文：这是最频繁、最轻量的一层。**不需要 LLM 调用**，纯本地规则引擎，每次请求前自动跑。逻辑很简单：

- **永远保护最近若干次工具调用的结果**（活跃数据不能删）；
- **超出保护窗口的旧工具结果 → 替换为 `[Old tool result content cleared]` 占位符**。

原文盛赞这层设计的精妙：它维持了 AI 的"心流状态（flow state）"——AI 记得自己**搜过代码**（#4 的 tool_call 还在）、记得**读过文件**（#7 的 tool_call 还在），只是**不记得搜索返回了什么、文件内容是什么**。若真需要再看，它会重新发一个 `read_file`。原文称之为**"选择性失忆（selective amnesia）"而非"彻底遗忘"**——就像你记得去年读过一本好书，却忘了具体内容，需要时随时能再翻一遍。

#### 【技术展开】"保留 tool_call、删 tool_result"为何是神来之笔

原文的比喻很美，但工程上"为什么必须保留 tool_call"值得讲透：

- **保留 tool_call 维持了"因果链完整性"**：在 messages 协议里，一个 `tool_use`（assistant 发起）必须与一个 `tool_result`（工具返回）配对。如果把 tool_call 也删了，模型会看到一段"无因之果"或"有因无果"的断裂历史，反而困惑。保留 tool_call、只把 tool_result **内容**替换为占位符，等于告诉模型："你在这里做过一次读取，结果我先收起来了，需要可以再读"——**保留了行动的记忆，丢弃了行动的负载**。

- **"可重取性（re-fetchability）"是关键前提**：这一招之所以低损，是因为被清理的是**确定性可复现**的数据。`read_file` 同一个文件、`grep` 同一个模式，随时能拿回一模一样的结果。所以删它几乎无损——这与"删掉一段无法重现的推理过程"有本质区别。

- **对比 Codex 的物理删除**：Codex 把 tool_call 和 tool_result 一起删，靠摘要兜住；Claude Code 保留 tool_call 骨架。前者更省空间，后者更省"未来重取"的认知成本。

### 3.2 Layer 2：缓存友好策略（Prompt Cache）

原文称这是 Claude Code 的**招牌动作（signature move）**，也是三家中**独一份的差异化优势**。

原文解释：Anthropic 的 API 支持 **Prompt Cache**——如果你这次发给 API 的消息**前缀**与上一次请求匹配，服务端就能复用之前的计算结果，**大幅降低成本与延迟**。这意味着什么？Claude Code 在清理消息时，**竭力避免修改消息序列的前半部分**。它采取"外科手术式"做法：**只在尾部裁剪，确保消息序列的开头与上一次请求绝对一致**。代价是清理效率略低，回报是**缓存命中率最大化**。

原文用场景说明：假设 Layer 1 清理后序列还是 #1-#26（工具结果已替换为占位符），上下文仍超限需进一步裁剪。**"朴素"做法会从最旧消息删起——但 Claude Code 偏不**。原文给出左右对照：左边的朴素策略删最旧消息看似合理，代价却是**整个前缀变了——API 缓存彻底失效，下一次请求要从头计算**；右边 Claude Code 的策略相反，**宁可少删，只要前缀与上次请求保持一致，就能命中 Anthropic 的 Prompt Cache**。对于长时间运行的任务（如让 AI 重构整个模块），这一策略带来**可观的成本节约**——因为每次请求的大部分内容都能命中缓存，你只为新增的尾部内容付费。

#### 【技术展开】缓存经济学——全文最该深挖的技术点

原文把"删头会让缓存失效"点到为止，但这背后的**缓存经济学**才是整篇文章最深的技术主线，值得彻底展开。

**1. Prompt Cache 是怎么工作的——前缀匹配的"全有或全无"**

Anthropic 的 Prompt Cache 按 **token 前缀**做缓存：服务端缓存"从第 1 个 token 到某个断点"的 KV 计算结果。命中的**铁律是前缀逐字节一致**——只要前缀第 N 个 token 变了，第 N 个 token 之后的所有缓存全部作废，必须从第 N 个重新计算。这是由 Transformer 的因果注意力决定的：第 N 个 token 的 KV 依赖它前面所有 token，前面一变，后面的 KV 全失效。

**2. 为什么"删头部"是缓存灾难**

设想会话前缀是 `[#1 系统提示][#2 用户][#3...]`。
- **删头部（朴素策略）**：删掉 #2，序列变成 `[#1][#3...]`。从 #3 开始，**每个 token 的绝对位置和前文都变了**，缓存从 #1 之后即告失效——**几乎 100% miss**。前一篇研究报告记录的实测数据：某替代方案有 **98% 的缓存未命中率**。
- **删尾部（Claude Code 策略）**：前缀 `[#1][#2][#3...]` 原封不动，只动序列末端。前缀部分**全部命中缓存**，只有新增/改动的尾部需要计算。

**3. 省了多少钱——量化缓存的价值**

Anthropic 的定价里：**缓存命中 token 约为基础输入价的 0.1×（便宜 10 倍），而写入缓存约为 1.25×**。这意味着：
- 命中缓存：原本要付 1.0× 的前缀，现在只付 ~0.1×，**省 90% 输入成本** + 大幅降延迟（省去重算）。
- 删头失效：不仅丢掉这 90% 折扣，还要**重新付全价计算整个前缀**，外加可能的 1.25× 重写费。

对一个跑几十轮、前缀稳定在数万 token 的重构任务，"删尾不删头"与"删头"的成本差可达**一个数量级**。

**4. Claude Code 把缓存经济学贯穿到每个设计**（结合前篇源码研究延展）

- Layer 1 用占位符替换而非删除，**保持消息数量与结构稳定**，利于前缀稳定。
- Layer 2 显式"只删尾"。
- 据逆向，Claude Code 还有 `cache_edits` 机制：缓存温热时**不修改本地消息**，而是随请求发送 `cache_edits` 块，**按 `tool_use_id` 让服务端外科手术式删除工具结果块，且不碰缓存前缀**——这是同时解决"删旧"与"保缓存"冲突的最精巧设计。
- 连 Layer 3 的摘要调用都复用主对话**完全相同的 system prompt / tools / 消息前缀**，把压缩指令作为新 user 消息追加在末尾，让摘要请求本身也能命中缓存。

> **一句话洞察**：删尾不删头成为行业铁律，**不是因为旧消息不重要，而是删头会让整条缓存前缀失效，付出"全量重算 + 重写费"的代价**。压缩从来不只是 context engineering，而是**成本约束下的 context engineering**。

### 3.3 Layer 3：九段结构化 LLM 摘要（最后手段）

原文：当前两层都拦不住上下文继续增长时，系统触发最终的全量摘要。据源码，**自动压缩阈值 = 有效上下文窗口 - 13,000 tokens**，其中**有效窗口 = 模型上下文窗口 - min(最大输出 token, 20,000)**。

但原文强调一个关键细节：**即便到了阈值，系统也不会直接跳到 LLM 摘要**。auto-compaction 触发时，系统**先试 Session Memory Compact**——利用会话内存中已有的结构化信息，替代完整的 LLM 调用。这意味着**大多数 auto-compaction 根本不需要 LLM 调用**。只有当 session memory 路径不可用或不足时，才回退到传统 LLM 摘要流程，生成含 **9 个固定章节**的结构化摘要：

1. 用户的原始意图（User's original intent）
2. 核心技术概念（Core technical concepts）
3. 关注的文件与代码（Files and code of interest）
4. 遇到的错误及如何修复（Errors encountered and how they were fixed）
5. 问题求解逻辑链（Problem-solving logic chain）
6. 所有用户消息的摘要（Summary of all user messages）
7. TODO 项
8. 当前正在做的工作（What's currently being worked on）
9. 建议的下一步（Suggested next steps）

原文：这份摘要有**极严格的要求**——prompt 命令模型**直接引用原文关键短语，而非全部转述**，以此**防止 "context drift"（模型在复述时悄悄偏离原意）**。

压缩后，Claude Code 还有一系列后处理，原文称为**"状态重建（state reconstruction）"**：

- 在新对话开头注入一段引子（"This session continues from a previous conversation..."）；
- **自动重读最近编辑过的文件（最多 5 个，总预算 50,000 token，单文件 5,000 token）**，确保 AI 拿到最新代码；
- 重新声明工具与 skill 定义；
- **CLAUDE.md 里的项目规范作为系统提示的一部分，永久驻留、不受压缩影响**。

原文补充：用户在手动压缩时还能附加自定义指令，如 `/compact Focus on API changes`，把压缩导向特定焦点。此外还有**被动兜底路径**：当 API 返回 `prompt_too_long` 错误时，系统**自动发起反应式压缩并重试**，确保用户不会撞上突兀的溢出报错。为防压缩反复失败陷入死循环，**连续 3 次失败后自动压缩暂停**。

原文总评：Claude Code 是三家中**最复杂但也最"高性价比"**的——大多数时候只需跑 Layer 1 规则引擎，或经 Session Memory 路径完成压缩，**完全不需要额外 LLM 调用**。

#### 【技术展开一】九段模板与"强制引用原文"的反 drift 机理

为什么是"九段"而不是 Codex 的"四点"？因为 Codex 逐字保留了用户消息，摘要只需覆盖"模型侧执行过程"；而 Claude Code 把**用户消息也卷进摘要**（见第 6 章对比表），所以必须用第①段"用户原始意图"和第⑥段"所有用户消息摘要"两个专门章节来兜住用户意图——**章节越多，越是在用结构对抗信息丢失**。

"强制直接引用原文关键短语"是对抗 context drift 的核心技巧，机理在于：
- **转述（paraphrase）是有损且会累积漂移的**：模型复述"保持向后兼容旧会话"时，可能写成"注意兼容性"，下一次再压缩又变成"考虑兼容"，多次压缩后原意被稀释殆尽。
- **直接引用（quote）是无损锚点**：强制模型把 `"keep backward compatibility with old sessions"` 原样抄进摘要，等于在有损摘要里**钉入若干无损的事实锚点**，跨多次压缩仍保真。这与 OpenCode "保留 exact file paths and identifiers" 的指令异曲同工。

#### 【技术展开二】Session Memory 优先——大多数压缩"零 LLM 调用"的奥义

原文这个细节常被忽略，但它是 Claude Code"高性价比"的真正来源。"Session Memory Compact"的思路是：**在会话进行中，系统就持续维护一份结构化的状态记录（已读文件、已做决策、TODO 等）**。当需要压缩时，与其临时调一次昂贵的 LLM 把整段历史重读一遍生成摘要，不如**直接把这份早已增量维护好的结构化记忆投影成压缩结果**。

这本质是 **MemGPT 式"分层记忆"的工程落地**——把"外部记忆"持续写好，压缩时直接取用，避免临时 LLM 摘要。其经济意义巨大：LLM 摘要是整条成本阶梯里**最贵的一步**，能用"读现成的结构化记忆"替代，就省掉了绝大多数压缩的 LLM 开销。

#### 【技术展开三】状态重建——压缩不是终点，是"重新启动"

原文列了状态重建的四步，但没点破其统一逻辑：**压缩后模型相当于"换了个人接班"，必须重建工作现场**，否则会出现"摘要说改过 auth.ts，但模型手里没有 auth.ts 最新内容"的脱节。所以：
- **重读≤5 文件/50K 预算**：解决"摘要有结论、但没有最新代码实体"——重读保证模型看到的是磁盘上**当前真实**的代码，而非压缩前的旧版本。
- **重注工具/skill 定义**：解决"摘要里没有工具规格"——否则新接班的模型不知道能调哪些工具。
- **CLAUDE.md 常驻**：项目宪法级约束**根本不进压缩流程**，永远在 system prompt 里——这是"长期记忆"与"工作记忆"的分层。
- **3 次失败熔断**：防止"压缩失败→重试→又失败"的烧钱死循环，是一个朴素但关键的可靠性护栏。
- **`prompt_too_long` 反应式兜底**：90% 主动触发还没拦住时的最后安全网，把"用户撞墙报错"转成"系统静默自愈重试"。


---

## 四、OpenCode：先 Prune 再摘要的"阶梯式治理"

原文：开源新秀 OpenCode（[源码](https://github.com/anomalyco/opencode)，TypeScript + Effect-TS）提供更均衡的策略。在 `session/compaction.ts` 里，它实现了一套**阶梯式治理（stepped governance）**流程：**先用低成本手段腾空间，真正必要时才动用 LLM**。

### 4.1 Step 1：Prune（标记隐藏，而非物理删除）

原文：OpenCode 的第一招不是删除，而是**"标记"**。规则非常清晰：

- **只在 prune 能腾出 >20,000 token 时才执行**（小打小闹不值当）；
- **永远保留最近 40,000 token 作为"安全垫"**（活跃工作不能碰）；
- **`skill` 类型的工具输出永不被 prune**（它们含操作指令）；
- **保护最后 2 个用户轮次的完整内容**。

原文点出**关键设计**：与 Claude Code 的占位符替换不同，**OpenCode 的 prune 不是物理删除**，而是给旧消息盖一个 `compacted = Date.now()` 时间戳，使其在后续请求中**"不可见"**。**数据仍在数据库里，只是被隐藏了**。

原文升华：**数据并未真正丢失**。这为未来的历史回溯功能留了空间——如果开发者需要审计，或 agent 触发某种回滚逻辑，这些数据可以被重新拉回上下文。**这是一个非常有前瞻性的设计**。

#### 【技术展开】"时间戳隐藏 vs 物理删除"——用源码坐实非破坏性设计

打开本地源码，原文描述的常量与逻辑全部坐实：

```
// repos/opencode/packages/opencode/src/session/compaction.ts
export const PRUNE_MINIMUM = 20_000          // :38  至少能省 20K 才动手
export const PRUNE_PROTECT = 40_000          // :39  最近 40K token 工具输出为安全垫
const TOOL_OUTPUT_MAX_CHARS = 2_000          // :40  工具输出序列化截断
const PRUNE_PROTECTED_TOOLS = ["skill"]      // :41  skill 类输出永不 prune
```

prune 的核心循环（compaction.ts:268-300，源码摘录）从尾部倒序遍历：

```typescript
loop: for (let msgIndex = msgs.length - 1; msgIndex >= 0; msgIndex--) {
  const msg = msgs[msgIndex]
  if (msg.info.role === "user") turns++
  if (turns < 2) continue                                  // 保护最近 2 个用户轮
  if (msg.info.role === "assistant" && msg.info.summary) break loop  // 遇旧摘要停
  for (...) {
    if (part.type !== "tool") continue
    if (PRUNE_PROTECTED_TOOLS.includes(part.tool)) continue   // skill 豁免
    const estimate = Token.estimate(part.state.output)
    total += estimate
    if (total <= PRUNE_PROTECT) continue                      // 40K 安全垫内全保留
    pruned += estimate
    toPrune.push(part)
  }
}
if (pruned > PRUNE_MINIMUM) {                                // 够 20K 才真动手
  for (const part of toPrune) {
    part.state.time.compacted = Date.now()                  // ← 盖时间戳"隐藏"，非删除
    yield* session.updatePart(part)
  }
}
```

**"非破坏性 + 可回溯"的前瞻性（延展）**：
- **物理删除（Codex） / 占位符替换（Claude Code）都是不可逆的**——被替换成 `[Old tool result content cleared]` 的内容，原始数据在内存里已不存在。
- **OpenCode 的时间戳隐藏是可逆的**——`compacted` 字段只是一个"软删除标记"，原始 output 仍躺在 DB（session part 表）里。这等价于数据库领域的 **soft delete（软删除）**模式，带来三个未来可能：
  1. **审计回溯**：开发者可以完整重放一次会话的真实历史，用于调试"模型当时为什么这么决策"。
  2. **回滚（rollback）**：若 agent 触发某种"撤销"逻辑，可把隐藏的数据重新激活进上下文。
  3. **无损升级路径**：当未来出现更好的压缩/检索算法时，历史数据还在，可重新处理——而物理删除的方案则永久失去了这个机会。
- 这与 OpenClaw 的 lossless-claw（LCM）路线、Hermes 的可插拔 ContextEngine 同属 2026 年的"**非破坏性 / 无损**"新潮流。

### 4.2 Step 2：LLM 五段式摘要

原文：若 prune 后仍然臃肿，OpenCode 用一个**隐藏的、专用的 agent**（不打扰用户当前交互）调用 LLM 生成摘要，遵循固定的 **5 段结构**。

原文重点表扬两个"贴心设计"：

1. **自动重放最后一条用户消息**：摘要完成后，OpenCode 会自动重发用户的最后一条消息。这确保 agent 最近的记忆锚点停在**用户的最新指令**上，而非冷冰冰的摘要文本。**用户完全感知不到压缩发生过**——你的最后一条消息被重发，AI 继续响应，仿佛什么都没发生。
2. **跟随用户语言**：如果你一直用中文交流，它的摘要也会用中文。对非英语母语开发者非常友好。

原文总评：OpenCode 是三家中**最"开发者友好"**的——完全开源（TypeScript）、现代架构（Effect-TS）、非物理删除的设计留足了扩展空间。要深度定制压缩行为，OpenCode 最容易上手。

#### 【技术展开】"自动重放末条用户消息"的无感设计 + 摘要 prompt 源码印证

OpenCode 的摘要 prompt（源码原文，`repos/opencode/packages/opencode/src/agent/prompt/compaction.txt`）印证了原文的"锚定摘要 + 跟随语言"两点：

```
You are an anchored context summarization assistant for coding sessions.
Summarize only the conversation history you are given. The newest turns may be
kept verbatim outside your summary, so focus on the older context that still matters...
If the prompt includes a <previous-summary> block, treat it as the current anchored
summary. Update it with the new history by preserving still-true details, removing
stale details, and merging in new facts.
... Keep every section, preserve exact file paths and identifiers when known...
Do not mention that you are summarizing, compacting, or merging context.
Respond in the same language as the conversation.
```

逐句对应原文要点：
- `Respond in the same language as the conversation` → **跟随用户语言**（中文交流则中文摘要）。
- `Do not mention that you are summarizing...` → 配合"自动重放末条用户消息"，实现**完全无感压缩**：摘要绝口不提"我在压缩"，模型续接时也不会冒出"根据之前的摘要……"这种破坏沉浸感的话。
- `preserve exact file paths and identifiers` → 与 Claude Code"强制引用原文关键短语"同源，都是**用无损锚点对抗 context drift**。
- `<previous-summary> ... preserving still-true details, removing stale details` → **迭代再压缩**：后续压缩是"锚定式更新"上一份摘要（条目从进行中→完成、删过时、并入新事实），而非每次从头重摘——跨多次压缩保信息不流失。

**"重放末条用户消息"的设计精髓（延展）**：普通摘要式压缩有个隐疾——压缩完成那一刻，模型的"最近记忆"是一段它自己生成的冷摘要文本，而**用户真正想让它做的那件事（最新指令）反而被埋在摘要里、不在"最显眼的尾部"**。OpenCode 的解法是：压缩后**把用户最后一条消息原样重发到序列尾部**，让模型的注意力锚点（最受关注的尾部位置，见第 0 章 lost-in-the-middle）牢牢落在"用户现在要什么"上。这是把"attention 偏好尾部"的特性**反过来为产品体验服务**的巧思。

### 4.3 OpenCode 触发器（源码精确值）

原文说"prune 后仍臃肿才摘要"，触发"臃肿"判断的源码在 `overflow.ts`：

```typescript
// repos/opencode/packages/opencode/src/session/overflow.ts
const COMPACTION_BUFFER = 20_000           // :8
export function usable(input) {            // :10
  const reserved = input.cfg.compaction?.reserved ??
    Math.min(COMPACTION_BUFFER, ProviderTransform.maxOutputTokens(input.model, input.outputTokenMax))
  return input.model.limit.input
    ? Math.max(0, input.model.limit.input - reserved)   // 可用 = 输入窗口 - 20K 预留
    : ...
}
export function isOverflow(input) {        // :22
  if (input.cfg.compaction?.auto === false) return false   // 可关闭
  const count = input.tokens.total || (...)
  return count >= usable(input)            // ← 接近满（窗口 - 20K buffer）才触发
}
```

即 OpenCode 的触发点是 **"窗口 - 20K 预留"≈ 接近满**——这是三家中**最克制的触发哲学**（Codex 90% 最激进），与它"先 prune 后摘要、能不调 LLM 就不调"的阶梯治理一脉相承。`OPENCODE_DISABLE_AUTOCOMPACT` 环境变量可整体关闭。


---

## 五、三剑客正面对决

原文把三家方案并排比较（输入统一为：26 条消息、~15,400 token 的"修登录 bug"场景）。本文完整保留原文对比维度，并在其上**增列从源码挖到的更多维度**（标 ⊕ 为本文补充）。

| 维度 | Codex CLI | Claude Code | OpenCode |
|------|-----------|-------------|----------|
| 压缩层数 | 单层（摘要） | 三层（裁剪/缓存/摘要） | 两层（隐藏/摘要） |
| LLM 调用 | 必需 | 仅 Layer 3，且 Session Memory 优先常免 | 仅 Step 2 |
| 用户消息 | 永久逐字保留 | 摘要进 9 段 | 摘要 + 末条重放 |
| 工具结果处理 | 物理删除 | 占位符替换 | 时间戳隐藏 |
| 缓存优化 | 无特别设计（仅头部 trim 间接保前缀） | 深度 Prompt Cache 集成（招牌） | 聚焦减少冗余读 |
| 压缩后行为 | 被动等待 | 主动重读相关文件 | 自动重放末条指令 |
| ⊕ 触发阈值（源码） | 90% 窗口（最激进） | ≈有效窗口-13K（≈70%） | ≈满-20K（最克制） |
| ⊕ 摘要章节数 | 4 点 handoff | 9 段 | 5 段 |
| ⊕ 可逆性 | 不可逆 | 不可逆 | **可逆**（软删除/时间戳） |
| ⊕ 迭代再压缩 | 叠加新摘要 | 支持 | `<previous-summary>` 锚定更新 |
| ⊕ 失败/兜底 | 头部 trim 兜底→报错 | `prompt_too_long` 反应式 + 3 次熔断 | 摘要失败则跳过 |
| ⊕ 可关闭 | 可配 limit | — | `OPENCODE_DISABLE_AUTOCOMPACT` |
| ⊕ 远程压缩 | ✅ `/responses/compact` | ✅ 服务端 Compaction API | ❌ |
| ⊕ 开源 | ✅ Rust | ❌（社区逆向） | ✅ TS/Effect-TS |

### 原文强调的三个"值得展开的差异"

**① 是否逐字保留用户消息**：Codex 选择保留用户消息原文、只压缩模型回复——好处是 AI 永远能回看你说过什么，代价是用户消息本身很长时压缩效率下降。Claude Code 和 OpenCode 选择把一切都压成摘要——更激进但更省空间。

**② 缓存**：这是 Claude Code 最独特的优势。另两家在压缩后 API 请求内容大变，等于让之前的缓存全部失效；Claude Code 刻意维持前缀稳定，让压缩后的请求仍能复用旧缓存。对长任务意味着可观的成本节约。

**③ 非物理删除**：OpenCode 的时间戳标记是前瞻性设计。虽然当前版本未实现历史回溯，但数据并未真正丢失，为未来留了门。Codex 和 Claude Code 的压缩都是不可逆的。

#### 【技术展开】三种"删除语义"的本质差异——一张哲学光谱

把"工具结果处理"这一行抽出来看，三家恰好覆盖了"删除"的三种语义层级，构成一条从"硬"到"软"的光谱：

```
物理删除(Codex) ──→ 占位符替换(Claude Code) ──→ 时间戳隐藏(OpenCode)
   最硬/最省                折中/可重取                 最软/可回溯
 数据即刻消失           骨架在、内容清空           数据全留、仅标记隐藏
 靠摘要兜底             靠 re-fetch 兜底           靠 DB 持久化兜底
 不可逆                 不可逆（内容已弃）          可逆（软删除）
```

- **Codex 的物理删除**追求极致空间效率，把"恢复"的全部赌注押在那一份摘要质量上——all-or-nothing。
- **Claude Code 的占位符替换**保留了 tool_call 骨架与 re-fetch 能力，是"工作记忆"层面的精准遗忘。
- **OpenCode 的时间戳隐藏**则把数据沉淀到持久层，是"存储"层面的可逆软删除。

这条光谱也对应**信任的对象不同**：Codex 信任"摘要"，Claude Code 信任"可重取性"，OpenCode 信任"持久化存储"。没有绝对最优——它取决于你更怕"丢细节"还是更在意"省空间"。


---

## 六、作者的核心洞察与三个比喻

原文在结尾用三个比喻为三家方案画像，本文复述并升华。

> **Codex CLI** 像一位**写交接备忘录的资深员工**。他撕掉之前的所有草稿，递给你一份清晰的状态报告——直白但有效。
>
> **Claude Code** 像一位**拥有"精准遗忘"能力的学者**。他先擦掉书里的次要批注，只有当书架实在塞不下时，才把整本书浓缩成一页提纲。他**极在意翻书的效率（缓存）**。
>
> **OpenCode** 像一位**务实的阶梯式治理者**——先用低成本手段腾地方，真到了必要关头才请出 LLM。

### 6.1 复述并升华三个比喻

- **资深员工写交接备忘（Codex）**：这个比喻的精髓是**"面向接班人而非面向归档"**——交接备忘录不是流水账，而是"让下一个人立刻能干活"的行动简报。这正是 prompt 里 `handoff summary`、`seamlessly continue` 的设计意图。升华：好的压缩摘要应该是**"未来导向"的（我接下来要干什么），而非"过去导向"的（我们做过什么）**。

- **能精准遗忘的学者（Claude Code）**：这个比喻藏着两层。表层是"由轻到重的遗忘梯度"（先擦批注、再缩成提纲）；深层是"**极在意翻书效率**"——这句话点的就是缓存经济学。升华：真正成熟的记忆管理者，不只懂"忘什么"，更懂"忘的动作本身要便宜"（不破坏缓存前缀）。

- **务实的阶梯式治理者（OpenCode）**：精髓是**"成本意识驱动的分级响应"**——小问题用小手段（prune），大问题才上重武器（LLM 摘要）。升华：这其实是一条所有成熟系统都遵循的工程原则——**用最便宜的手段解决最多的问题，把昂贵手段留给少数真正需要的场景**。

### 6.2 全文主旨：精准遗忘 > 无限记忆

原文最终落点（AI 摘要概括）：**最好的上下文管理不是无限扩大记忆容量，而是学会精准遗忘（learning to forget with precision）**。

本文从三个独立证据把这个主旨钉死：

1. **数据证据**：前篇研究引用的 mem0 / Zylos 数据——65% 的 Agent 失败源于"上下文退化"而非 token 耗尽。**记住一切的 agent 最容易被噪声分心**。
2. **官方自承**：Codex 在压缩后主动警告"多次压缩会掉精度"——连最激进榨干窗口的厂商，都承认无限累积是有害的。
3. **架构趋同**：三家虽路线各异，却**不约而同地把"主动丢弃"做成核心能力**，而非把"无限扩窗"当解法。

> **升华**：上下文窗口从 4K 涨到 1M+ 的这几年，行业一度以为"窗口够大就不用压缩了"。但实践给出了相反答案——**窗口越大，"精准遗忘"反而越重要**，因为大窗口让"信息单调累积"的惯性更难察觉，context rot 在你意识到之前就已经发生。压缩的本质，是用工程手段守护模型的"信噪比"。这是 2026 年 Agent runtime 成熟度的真正分水岭。

### 6.3 三家共同遵循的"成本阶梯"（本文提炼）

跳出比喻，三家在工程上其实收敛到同一条**成本阶梯**：

```
零成本本地规则        缓存友好手段           昂贵的 LLM 摘要
(裁剪/隐藏工具结果) → (删尾保前缀/重取)  →  (结构化模板, 最后才用)
   Claude L1            Claude L2             Claude L3
   OpenCode prune       OpenCode 减冗余读     OpenCode summary
   Codex 头部 trim       Codex 保前缀          Codex handoff(其唯一手段)
```

差异只在"阶梯有几级、每级阈值定在哪"。**Codex 把阶梯压成一级（直接摘要）**，所以最直觉但最 all-or-nothing；**Claude Code 阶梯最长（三层）**，所以最复杂但最省 LLM；**OpenCode 居中（两级）**，且把第一级做成可逆的软删除。

---

## 七、参考来源

### 原文（本文解读对象）
- justin3go, *Shedding Heavy Memories: Context Compaction in Codex, Claude Code, and OpenCode*, 2026-04-09 — <https://justin3go.com/en/posts/2026/04/09-context-compaction-in-codex-claude-code-and-opencode>

### 本地 clone 源码（标注真实文件/行号，本文技术展开的一手依据）
- **Codex CLI** `openai/codex`：
  - `codex-rs/protocol/src/openai_models.rs:433` — `auto_compact_token_limit`，`(context_window * 9) / 10`（90% 触发）
  - `codex-rs/core/src/compact.rs:52` — `COMPACT_USER_MESSAGE_MAX_TOKENS = 20_000`；`:262` `remove_first_item()` 头部 trim；`:297` `SUMMARY_PREFIX`；`:453` `collect_user_messages`；`:536` `build_compacted_history`
  - `codex-rs/core/src/client.rs:152` — `RESPONSES_COMPACT_ENDPOINT = "/responses/compact"`；`:486` `compact_conversation_history`
  - `codex-rs/core/src/compact_remote.rs` — 远程压缩路径
  - `codex-rs/prompts/templates/compact/prompt.md` — handoff 摘要 prompt 原文
- **OpenCode** `sst/opencode`：
  - `packages/opencode/src/session/overflow.ts:8` — `COMPACTION_BUFFER = 20_000`；`isOverflow` / `usable`
  - `packages/opencode/src/session/compaction.ts:38-41` — `PRUNE_MINIMUM=20_000`、`PRUNE_PROTECT=40_000`、`TOOL_OUTPUT_MAX_CHARS=2_000`、`PRUNE_PROTECTED_TOOLS=["skill"]`；`:291` `compacted = Date.now()` 时间戳隐藏
  - `packages/opencode/src/agent/prompt/compaction.txt` — 锚定式摘要 prompt 原文（跟随语言/不提压缩/保留标识符）

### 交叉印证与延展依据
- 本团队前序研究报告：《代表性 Agent Harness 的"自动上下文压缩"机制深度研究》（2026-06-16，黄山）—— `/root/.openclaw/workspace/project/openclaw_daily_file/research/2026-06-16-agent-context-compaction.md`（含 Claude Code 逆向源码片段、缓存经济学量化、Hermes 对照、学术论文 MemGPT/StreamingLLM/LLMLingua 机理）
- Claude Code 相关（闭源逆向，前序报告已交叉验证）：Jonathan Barazany《Claude Code's Compaction Engine》(barazany.dev)；Ken Huang《Context Management at Scale》(Substack)；Anthropic 官方 Compaction API Cookbook

---

> **解读声明（再次重申）**：本文是对 justin3go《Shedding Heavy Memories》（2026-04-09）的深度解读与技术延展。原文的 26 条消息 / 15,400-token 登录 bug 场景为作者原创示例，本文引用并标注。所有技术展开均基于本地真实源码与前序研究，用本文自己的组织结构与语言重述，未大段照搬原文原创表达。
