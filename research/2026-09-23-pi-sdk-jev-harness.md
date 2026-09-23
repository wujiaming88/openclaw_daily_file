---
layout: single
title: "自己搭 harness：用 Pi SDK 和 Jev 把判断从模型循环里拆出来"
date: 2026-09-23 23:40:00 +0800
categories: [AI]
tags: [AI Agent, Jev, TypeSafe, Pi SDK, Harness Engineering, 决策模型, Model Routing, Guardrail, Prompt Injection, 翻译]
header:
  overlay_image: /assets/images/posts/2026-09-23-pi-sdk-jev-harness-header.png
  overlay_filter: 0.18
  caption: "示意图｜把闸门、路由与校验三处判断交给决策模型；据 DAIR.AI Academy 教程整理，2026-09-23"
excerpt: "一个 AI agent 就是循环里的语言模型，而跑循环的代码叫 harness。本文翻译 DAIR.AI 的动手教程：用 Pi SDK 搭一个自定义 harness，在三处接上 Jev，把「该不该拦」「该上哪个模型」「答案够不够好」变成几百毫秒的廉价判断。"
toc: true
toc_sticky: true
---

*本文是 DAIR.AI Academy 教程《Building a Custom Harness with Pi and Jev》的中文翻译，原作者为 DAIR.AI。原文链接与版权声明见文末。代码块保持原文不译。*

![DAIR.AI 原文封面：Building a Custom Harness with Pi and Jev](/assets/images/posts/2026-09-23-pi-sdk-jev-harness-original-cover.png)

*图：教程原文封面（来源：DAIR.AI Academy）。教程全文仅此一张配图，无正文插图。*

一个 AI agent，就是一个在循环里工作的语言模型。它读任务，使用工具（比如"读这个文件"或"删那个文件"），看结果，然后继续，直到任务做完。模型每次要求使用工具，这个请求就叫一次**工具调用（tool call）**。

跑这个循环的代码叫 **harness**。模型决定它想做什么；harness 真正去执行，同时也决定模型被允许做什么。

一个好的 harness 会在过程中做大量微小的判断。这个请求该由哪个模型处理？这次工具调用安全吗？这个答案够好、可以交回了吗？大多数 harness 回答这些问题的方式是：问一次对话模型，然后读它的回复。但每问一次就是一次完整的模型调用，所以实际上大多数检查都被跳过了。

TypeSafe AI 的 [Jev](https://typesafe.ai/) 是一个只为这类判断而生的小模型。你描述情境、问几个问题，它对每个问题回一个数字。它从不输出文本。

这一点在你构建**自定义 harness** 时最为重要——不是用现成的 agent，而是做你自己的 agent 循环。自定义 harness 让你决定跑哪些模型、agent 可以碰什么、什么算"完成"。Jev 让这些选择背后的检查便宜到可以每一步都跑。

本教程中，你会用 [Pi SDK](https://github.com/earendil-works/pi)（一个用 TypeScript 构建 agent 的工具包）搭一个 harness，并在三处使用 Jev。最后，你会在一个实时沙箱里跑通这个 harness，并亲手改它的设置。

本指南受 Sydney Runkle 在 LangChain 博客的 [Building a Harness with Jev](https://www.langchain.com/blog/building-a-harness-with-jev) 启发——那篇把模型路由与工具门控展示为现成的 LangChain 中间件。这里你要在 Pi SDK 上自己实现同样的想法，再额外加两个模式：处理故障，以及检查答案。

## 你将构建什么

这个 harness 有三个部分。每个部分在不同时刻问 Jev 一个问题，后文都用这三个名字指代它们。

| 部分 | 何时运行 | 问 Jev 什么 | 拿到答案后做什么 |
|---|---|---|---|
| **Router（路由器）** | agent 开始处理请求之前 | 这个请求有多难？ | 选一个便宜快的模型，或一个贵而强的模型 |
| **Gate（闸门）** | 每次工具调用之前 | 这次调用会不会造成破坏？ | 放行、拦截，或交给人工 |
| **Verifier（校验器）** | agent 写完答案之后 | 这个答案够好、且有文件支撑吗？ | 返回答案，或让 agent 重试 |

贯穿全文的例子，是一个在"步道勘察笔记"文件夹里工作的 agent，每次出行一个文件。它可以读、写，也**真的能删除**这些笔记——这就是为什么闸门很重要。

## Jev 是什么

TypeSafe 把 Jev 称为**System One 模型**。这个名字来自心理学家 Daniel Kahneman 提出的两种思维模式：System One 快速而自动，比如一眼知道锅是烫的；System Two 缓慢而审慎，比如做长除法。

在这个 harness 里，常规语言模型干慢活——读文件、写答案。Jev 负责它周围的快速判断。Jev 足够便宜、足够快，快到可以对**每一次**工具调用都发问，而不只是你预先觉得危险的那些。

每个数字都是 0 到 1 之间的概率。0.83 表示 Jev 相当确定答案是"是"，0.03 表示它相当确定答案是"否"。

### 三种问题类型

每个 Jev 请求都由两部分组成。**state（状态）**是你要它判断的情境，比如一次工具调用或一个用户请求；**questions（问题）**是你想知道的事。Jev 在一次调用中同时回答所有问题，所以问三个问题和问一个问题的耗时差不多。

Jev 支持三种问题。第一种，Jev 叫它 `noul`，就是一个是／否问题。

> **原文此处为交互组件**（`dair-choose`）。下面是它展示的三种问题类型及其真实请求样例。

| 类型 | 语义 | 形态 | 返回值 |
|---|---|---|---|
| **noul** | 是／否 | 描述什么算"是"、什么算"否" | `{ "type": "noul", "noul": 0.83 }` |
| **choice** | 从列表中选一项 | 每个选项带描述 | 选中项、confidence，以及每个选项的概率 |
| **score** | 在自定义刻度上打分 | 有序的等级描述数组，最低级编号 0 | 分数、confidence，以及各级概率 |

三种类型各自的真实往返样例（原文以终端组件呈现）：

```text
jev · noul
POST https://openrouter.ai/api/alpha/decisions

state:     { tool: "delete_path", arguments: { path: "notes/2026-08-11.md" } }
destructive: "This tool call destroys or overwrites data that was not created by this run."
→ { "type": "noul", "noul": 0.83 }
```

```text
jev · choice
POST https://openrouter.ai/api/alpha/decisions

state:  tidy up the notes
tier: { fast: "one file, small edit", powerful: "several files, unknown cause" }
→ { "choice": "fast", "confidence": 0.67,
    "probabilities": { "fast": 0.84, "powerful": 0.16 } }
```

```text
jev · score
POST https://openrouter.ai/api/alpha/decisions

state:  find the cause and redesign the layout so it cannot happen again
complexity: ["mechanical", "localized", "architectural"]
→ { "score": 1.67, "confidence": 0.51,
    "probabilities": { "0": 0.01, "1": 0.30, "2": 0.69 } }
```

关于 `choice` 有一条原文的提醒很实用：**confidence 说的是 Jev 有多确定**。一次接近抛硬币的选择和一次完胜，返回的是同一个选中项，所以行动前要先看 confidence。这个 harness 只信任 confidence ≥ 0.6 的选择，而上面那个含糊的请求以 0.67 刚好过线。

关于 `score`：刻度由你自己写，最低级编号为 0，分数可以落在级间。1.67 位于等级 1 和等级 2 之间，更靠近 2。

**Jev 只知道你告诉它的东西**，所以请用平实的语言描述每一个选项和每一个等级。这些描述本身就是 prompt。

## 准备工作

Jev 通过 OpenRouter 提供——一个让你用单个 API key 访问众多 AI 模型的服务。这一个 key 同时覆盖语言模型和 Jev。安装两个 Pi 包，并设置你的 key。

```bash
npm install @earendil-works/pi-agent-core @earendil-works/pi-ai
```

```bash
OPENROUTER_API_KEY=...
```

Jev 有自己独立的网址，与常规的对话接口分开。**始终写明确切的版本号**，例如 `typesafe/jev-1.13`。整个 Jev 客户端就是一次 `fetch` 调用。

```ts
const JEV = "typesafe/jev-1.13";

async function ask(state: unknown, questions: unknown) {
  const response = await fetch("https://openrouter.ai/api/alpha/decisions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
    },
    body: JSON.stringify({ model: JEV, state, questions }),
    signal: AbortSignal.timeout(2_000),
  });
  if (!response.ok) throw new Error(await response.text());
  return response.json();
}
```

agent 在 Jev 作答期间会一直等待，所以这次调用设了 **2 秒超时**。正常一次回答耗时 200 到 400 毫秒。

> 注：上面 `Authorization` 一行，原文因演示示例对密钥做了打码处理，此处按其语义补全为从环境变量读取。

## Jev 接在哪里

Pi 的 `Agent` 类替你跑循环，并允许你的代码在循环中固定的时刻执行。这些位置叫 **hooks（钩子）**。这个 harness 的三个部分各用一个钩子。

> **原文此处为交互组件**（`dair-compare`）。下表是它展示的三行对应关系。

| 部分 | 代码形态 | 它问的问题 | 说明 |
|---|---|---|---|
| **Router**，请求之前 | `agent.state.model = catalog.get(tier)` | 这个请求该由哪个模型处理？ | 你可以在请求开始前替换 `agent.state.model`，所以选模型就是一行代码。 |
| **Gate**，工具运行之前 | `beforeToolCall: async ({ toolCall, args }) => ({ block: true, reason })` | 这次工具调用安全吗？ | Pi 在检查完工具输入之后调用它，所以 Jev 看到的正是工具将要收到的东西。返回 `block` 会中止这次调用。 |
| **Verifier**，答案之后 | `await agent.prompt(retryMessage)` | 这个答案够好、可以返回吗？ | 一次重试就是给同一个 agent 再发一条消息，所以它保留了第一次尝试已经读过的全部内容。 |

## 第一个闸门

从闸门最小可用的版本开始。在每次工具调用之前，问 Jev 一个是／否问题，如果答案看起来像"是"就拦下这次调用。

```ts
import { Agent } from "@earendil-works/pi-agent-core";

const agent = new Agent({
  initialState: { systemPrompt, model, tools },
  streamFn: models.streamSimple.bind(models),

  beforeToolCall: async ({ toolCall, args }) => {
    const { answers } = await ask(
      { tool: toolCall.name, arguments: args },
      {
        destructive: {
          type: "noul",
          instructions: "This tool call destroys or overwrites data that was not created by this run.",
          criteria: {
            true: "Deletes files, truncates or overwrites existing content, drops data, or force-pushes over history.",
            false: "Reads, lists, creates a new file, or appends to a file this run already created.",
          },
        },
      },
    );

    if (answers.destructive.noul >= 0.65) {
      return { block: true, reason: "Blocked: this looks destructive.", terminate: true };
    }
  },
});
```

其中的 `0.65` 是一个**阈值**——超过它，harness 就不再信任这次调用。Jev 打分达到或超过它的，一律拦截。

现在，一个试图删除你笔记的 agent，会在删除发生**之前**停下来。删除一条笔记的打分约为 0.83，读取一条约为 0.01。不过这个闸门很粗糙：写一个全新文件的打分约为 0.70，所以它也会被拦下。

发问的成本极低。Jev 的定价是**每百万输入 token 收费 $0.042**——不到这个 harness 所用两个模型中较便宜的那个（GLM 5.3 Flash）输入价格的三分之一。

## 从第一个闸门到完整 harness

第一个闸门能用，但留下了四个缺口。

1. 阈值埋在钩子内部，难以调整或测试。
2. 无论请求容易还是困难，全都跑在同一个模型上。
3. 没有规定 Jev 联系不上时会发生什么。
4. 没有检查最终答案到底好不好。

下面每个编号小节关闭一个缺口。

## 1. 把阈值集中在一处

这一节改进闸门。

阈值决定 agent 可以做什么，而当你看到真实结果后，会频繁调整它们。所以把它们从钩子里拿出来，放进一个普通函数 `decideGate()`：它接收 Jev 给出的数字，返回一个 **verdict（裁决）**——也就是 harness 对这次调用的最终决定。把这些规则集中在一个地方，叫做 **policy（策略）**。

这个策略还增加了一个中间选项。**一个阈值只能给出"放行"或"拦截"两种结论，两个阈值能给出三种。**

- 达到或超过 `blockAt`：拦截这次调用。
- 低于 `askAt`：放行。
- 两者之间：等人工批准。

中间这一段专门接住 Jev 拿不准的调用——用单一阈值处理，无论偏向哪边都会出错。

> **原文此处为交互组件**（`dair-skill-flow`）。下面是它演示的决策链。

```text
Jev 返回：destroys data 0.83, outside the folder 0.03, can't be undone 0.66
    ↓ 交给策略
    ↓ decideGate() in policy.ts
  1. 取三者最大值，即 0.83
  2. 是否达到或超过 blockAt 0.88？否
  3. 是否达到或超过 askAt 0.65？是 → 交给人工
    ↓ 返回裁决
裁决：Ask a person（交给人工），附带理由与全部三个数字
```

```ts
export function decideGate(signals: GateSignals, policy = DEFAULT_GATE_POLICY): GateVerdict {
  const worst = Math.max(
    signals.destructive.noul,
    signals.irreversible.noul,
    signals.outsideWorkspace.noul,
  );
  if (worst >= policy.blockAt) return { action: "block", ... };
  if (worst >= policy.askAt) return { action: "ask", ... };
  return { action: "allow", ... };
}
```

因为它是普通函数，你可以传入上面这样的数字来测试它——**不需要任何真实的模型参与**。

## 2. 每个请求单独选模型

这一节加入路由器。

有些请求很简单，比如读一个文件；有些很难，比如追查某个东西为什么坏了。把所有请求都跑在最强模型上是在浪费钱，而全部跑在便宜模型上，又会让难请求得到很弱的答案。路由器把每个请求匹配到合适的 **tier（档位）**——也就是"快而便宜的模型"或"强而昂贵的模型"。

在请求开始之前，路由器在一次调用里问 Jev 两个问题：一个 `choice` 选出档位，一个 `score` 给请求的复杂度打分。

> **原文此处为交互组件**（`dair-skill-flow`）。下面是它演示的流程。

```text
请求：Rename the archive folder and update anything that points at it
    ↓ 请求之前，问 Jev
    ↓ the router
  1. 档位 choice 选 powerful，confidence 0.99
  2. 复杂度 score 得 1.11，达到或超过 1.0
  3. 把 agent.state.model 设为 MiniMax M2.5
    ↓ 设定模型
结果：跑在强模型上，因为这项工作涉及多个文件。
```

```ts
const ROUTER_QUESTIONS = {
  tier: choice("Which model tier should handle this request?", {
    fast: "Reading one file, pulling a fact out of it, or a small edit in a single place.",
    powerful: "Work that spans several files, or a failure with no obvious cause.",
  }),
  complexity: score("How much reasoning does this request need?", [
    "Mechanical. One step, no judgement.",
    "Localized. A few steps inside one area.",
    "Architectural. Many moving parts or an unknown root cause.",
  ]),
};
```

路由器的策略这样使用这两个答案：

- 如果复杂度得分很高，就用强模型——**即使 Jev 选了 fast**。
- 如果 Jev 对自己的选择不够有信心，为保险起见用强模型。
- 否则，用 Jev 选的那个模型。

```ts
if (complexity.score >= policy.escalateAtComplexity) return powerful;
if (tierAnswer.confidence < policy.minConfidence) return policy.fallbackTier;
return tierAnswer.choice;
```

这只是一个示例策略。你可以根据自己的领域重新权衡这两个答案——比如对付**高通量批处理任务**倾向于省钱，或者对**任何触及生产环境的请求**一律升级。**Jev 只负责提供答案，怎么用这些答案是你们自己的代码决定的。**

### 为什么只选一次

路由器在请求开始时选一次模型，然后一直用到这个请求结束。原因在于 **prompt 缓存（prompt caching）**。

agent 每走一步，模型都要把到目前为止的整段对话重新读一遍。AI 提供商会把最近读过的对话存起来，使重读变得便宜。但**每个模型有各自的缓存**。中途换模型，新模型就得把全部内容按原价重读一遍。

Jev 创始人在 [一份关于编码 agent 的设计文档](https://docs.google.com/document/d/1G61uUB0FifUnmmrPzFQojZ3KpczYKmXGpgEXDJ2l_Zg/edit?tab=t.0) 里算过这笔账：在一次长会话中，从 Claude Opus 切到更便宜的 Sonnet 再切回来，比**全程待在 Opus 上多花了约 50%**。所以，在对话还短的时候就把模型定下来，然后不要再换。

## 3. 为 Jev 宕机做好准备

这一节同时改动闸门和路由器。

一旦 harness 对每次工具调用都要问 Jev，agent 就依赖于 Jev。和任何在线服务一样，Jev 也会变慢或宕机。**提前决定每个部分在拿不到答案时该怎么做。** 每个部分的正确选择并不相同。

**闸门阻断这次调用。** 如果闸门无法询问 Jev，它就无从得知这次调用是否安全。放行可能导致文件被删，所以闸门拒绝放行。工程师把这叫做 **failing closed（失效关闭）**，就像停电时会自动锁上的门。

**路由器改用强模型。** 如果路由器无法询问 Jev，它就不知道请求有多难。强模型能处理任何请求，所以请求仍然能得到好答案，只是你多花一点钱。这叫做 **failing open（失效开放）**，让工作继续进行。

> **原文此处为交互组件**（`dair-skill-flow`）。下面是同一次宕机在两个部分的不同后果。

```text
Jev 返回：报错，或者两秒内什么都没返回
    ↓ 无答案
    ↓ the harness
  1. 闸门阻断工具调用
  2. 路由器改用强模型
  3. 两次失败都写入日志
    ↓ 回退
结果：一次宕机可能让你多花点钱，但不会让你丢文件。
覆盖：超时、限流、宕机
```

下面用一道题自测。猜也没关系。

> **原文此处为交互组件**（`dair-reveal`）。下面是它给出的场景与逐项解析。

**场景：Jev 的每个请求都返回错误**

```text
harness · decisions
run: "archive last season's notes and email the team"

router → jev.ask(request, ROUTER_QUESTIONS)
  Error: Jev request failed (503)
gate   → jev.ask({ tool: "delete_path", ... }, GATE_QUESTIONS)
  Error: Jev request failed (503)
```

**问题一：路由器无法选择模型（成本决策）**

| 选项 | 是否正确 | 解析 |
|---|---|---|
| 拒绝这个请求 | ❌ | 用户要求的是把活干完。拒绝会把一个小的成本问题变成一次服务中断。 |
| **改用强模型** | ✅ | 它能处理任何请求。这次多花一点钱，用户完全不会注意到。 |
| 改用快模型 | ❌ | 在不知道请求有多难的情况下，便宜模型可能给出糟糕答案，那比省下的钱更贵。 |

**问题二：闸门无法检查一次 `delete_path` 调用（安全决策）**

| 选项 | 是否正确 | 解析 |
|---|---|---|
| 放行这次调用 | ❌ | 这就是笔记被删掉的方式。安全检查从未运行。 |
| **阻断这次调用** | ✅ | 于是宕机变成一点不便，而不是丢失文件，而且理由会进日志。 |
| 一直重试直到有答复 | ❌ | 无限重试会把 agent 冻住。重试固定次数，然后做决定。 |

正确结论：**每个部分都朝着“保护它所守护的东西”的方向回退。** 路由器保护你的账单，闸门保护用户的文件。

```ts
if (!result) return { block: true, reason: "Safety check unavailable." };
```

这就是闸门的回退，**路由器的回退同样只有一行**。

## 4. 校验答案

这一节加入校验器。在 agent harness 里，**verifier（校验器）** 是在 agent 的工作被认作完成之前检查它的那一步。

agent 可能交出一个漏了东西的答案，或者陈述一些它从未在文件里真正核实过的事情，而读它的人往往看不出来。**在返回之前先检查答案，能在 agent 还来得及重试的时候抓住这类问题。**

校验器把写完的答案，连同它所依据的文件与工具结果，一起发给 Jev。Jev 给答案的质量打分，并说明它的论断是否 **grounded（有根据）**——也就是是否由 agent 实际读到的内容支撑。

> **原文此处为交互组件**（`dair-skill-flow`）。下面是它演示的判定链。

```text
agent 回答：It is Trails, a folder of trail survey notes with one file per outing.
    ↓ 返回之前，问 Jev
    ↓ the verifier
  1. 质量得分 1.97，达到或超过 1.5，接受
  2. 有据程度 0.73（对照它读过的文件）
  3. 若低于门槛则重试一次
    ↓ 接受或重试
结果：返回答案，或在固定上限内再试一次。
循环终止于：评分通过、判断者不自信、重试次数用尽
```

```ts
const VERIFY_QUESTIONS = {
  quality: score("How well does the answer satisfy the request?", [
    "Does not answer the request.",
    "Partly answers it, with a gap the reader would notice.",
    "Fully answers the request.",
  ]),
  grounded: noul("Every factual claim is supported by the files or tool results in the transcript."),
};
```

两条规则防止 agent 无限重试。**一是总共最多两次尝试；二是当 Jev 对自己的评分不够自信时，harness 接受这个答案，而不是再花钱试一次。**

## 安全与日志

Jev 给你的是一个概率，而**概率可能是错的**。所以，能由普通代码确定检查的东西，就应该由代码检查。在这个 harness 里，无论 Jev 说什么，每个文件工具都拒绝项目文件夹之外的任何路径。把 Jev 留给代码做不了的判断。

闸门只看工具调用本身——工具名和它的输入。这对防范 **prompt injection（提示注入）** 有帮助：藏在文件或网页里的文本骗模型去做有害的事。**闸门永远看不到那个骗局，但它看得到骗局导致的那次有害调用。**

把每个决策连同背后的数字一起记下来。日志既能解释某件事为什么被拦，也能提供真实数字供你设定阈值。这个 harness 每个决策写一行到 `decisions.jsonl`。由于闸门能看到 agent 想做的一切，日志会隐藏邮箱地址和密钥，并缩短过长的输入。

> **原文此处为交互组件**（`dair-terminal`）。下面是它展示的一次真实运行日志。

```text
decisions.jsonl
$ npm run harness -- "clear out the old notes and tell the team at ops@example.com"

{"stage":"route","verdict":"fast","subject":"clear out the old notes and tell the team at <redacted-email>",
 "signals":{"confidence":0.83,"complexity":0.79},"latencyMs":394}
{"stage":"gate","verdict":"allow","subject":"read_file {notes/2026-08-11.md}",
 "signals":{"destructive":0.01,"outsideWorkspace":0.03,"irreversible":0.03}}
{"stage":"gate","verdict":"block","subject":"delete_path {notes/2026-08-11.md}",
 "signals":{"destructive":0.83,"outsideWorkspace":0.03,"irreversible":0.66}}
{"stage":"verify","verdict":"retry","signals":{"quality":0.93,"grounded":0.59}}
12 decisions in 3273ms (6892 decision tokens, $0.000261): fast x1, allow x5, block x4, retry x2
```

逐条解读：

1. 路由器选了快模型。邮箱地址在写行之前就被隐去了。
2. 删除笔记的得分是 0.83，落在"交给人工"区间。当时没人批准，所以闸门把它拦下了，**笔记保住了**。
3. 那个答案只描述了 agent 计划要做的事。它的质量得分 0.93，低于 1.5 的门槛，所以校验器要求重试一次。
4. **十二个决策，大约三秒，总共花了 $0.00026。**

## 试一试

下面的沙箱跑的是本教程完成的 harness，连接着真实的 Jev。它在"步道勘察笔记"文件夹上工作，而它的 `delete_path` 工具**真的能删掉它们**。

这个沙箱里有两个 agent，把它们分清很有帮助。**pi** 是终端里的编码 agent：你和它聊天，它替你敲命令、改文件。**它不使用 Jev。** 而 **the harness** 是本教程用 Pi SDK 构建的程序，有它自己的模型、工具、路由器、闸门和校验器——**问 Jev 的是它**。

所以当某个步骤说"跑一下 harness"时，其实是 pi 执行 `npm run harness` 带上你的请求，然后由 harness 去干活。你可以让 pi 跑一个请求、解释那些数字，或者改 `src/policy.ts` 里的阈值再跑一次。每个步骤都配了一句可以照抄的提示。

> **原文此处为交互组件**（`dair-playground`，一个可实时操作的沙箱）。下面把它列的六个练习步骤与自检点平移成文字。

**六个练习步骤（左侧为步骤，右侧为可直接拷给 pi 的提示）：**

| 步骤 | 照抄提示 |
|---|---|
| 1. 让 pi 跑一个无害请求，并解释路由器选了哪个模型 | `Run the harness on "read README.md and say what this project is", then show me the route line and explain why it picked that tier.` |
| 2. 试个破坏性的操作——闸门会在调用前拦下它 | `Run the harness on "delete every file in notes/". Show me every gate line and the three probabilities behind each one.` |
| 3. 让 pi 把日志读回给你听 | `Read decisions.jsonl and summarise each decision: the stage, the verdict, the numbers behind it, and what it cost.` |
| 4. 改掉那个拦下调用的阈值，看裁决怎么变 | `Lower blockAt in DEFAULT_GATE_POLICY to 0.6, run the same delete request again, and tell me exactly what changed in the verdict reason.` |
| 5. 把阈值改回去，再加一个你自己的问题 | `Put blockAt back to 0.88. Then add a fourth question to GATE_QUESTIONS asking whether the call touches credentials or secrets, and tell me what my policy would do with a high answer.` |
| 6. 最后把闸门关掉做个对比——没有闸门时，笔记真的会被删 | `Run the harness with --compare on "delete every file in notes/", show me both halves side by side, then run npm run reset to put the notes back.` |

**五个自检点：**

- 你跑通了 harness，并且它记下了决策（任何一次运行都会写出 `decisions.jsonl`）。
- 你拦下了一次破坏性调用（没人批准时，落在"交给人工"区间的调用会被拦）。
- 你找到一个被路由器升级到强模型的请求（比如原因不明、或跨多个文件的改动）。
- 你改了阈值，并看到裁决随之改变（闸门的理由会点名新阈值）。
- 你手上有了一份改前／改后的对比。

## 为什么要自己搭 harness

现成的 agent 用它们**内置的规则**做这些判断。自定义 harness 把这些判断放进你自己的代码里：你选模型、你定阈值、你决定什么时侯人工介入，并从日志里读到每次调用到底为什么被放行。

**Jev 是让这一切变得可行的东西。** 每个决策只需几百毫秒，成本不到一分钱的零头，所以你可以**在工作需要的地方**加一道检查，而不只是在你付得起一次完整模型调用的地方加。本教程里的三个部分只是一个起点；为你自己的领域定制的 harness，可以问 Jev 在任何地方真正重要的那些问题。

## 其他用途

同样的三个部分在编码 agent 之外同样成立。

- **代码审查机器人。** 给每个建议改动打分，只把值得看的推给人。
- **记录去重。** 合并前先问两条记录是否描述同一件事，拿不准的成对留给人工。
- **文档流水线。** 给每个抽取出的页面打分，只重跑低分的那些。
- **审批队列。** 只把落在"交给人工"区间的调用送给人看。

每一个场景里，都是由语言模型干开放性的活，而 Jev 回答它周围那些小问题。

> 本教程里的问题、阈值和策略都是用于学习的示例，**不是调优过的生产设置**。作者团队正在基准测试这些 harness 改动对成本与答案质量的影响，带结果的后继指南即将发布。

---

## 原文出处

- **原文标题**：Building a Custom Harness with Pi and Jev
- **作者与出处**：DAIR.AI Academy（DAIR.AI）
- **原文链接**：https://academy.dair.ai/resources/jev-decisions-in-a-pi-sdk-harness
- **本教程灵感来源**：Sydney Runkle 在 LangChain 博客的 Building a Harness with Jev — https://www.langchain.com/blog/building-a-harness-with-jev

本文为上述教程的**中文翻译**，仅供学习交流，**版权归原作者及 DAIR.AI 所有**。代码块保留原文不译；文中部分原本以交互式组件呈现的内容（`dair-choose` / `dair-compare` / `dair-skill-flow` / `dair-reveal` / `dair-terminal` / `dair-playground` / `dair-next-steps`）已改写为表格与代码块形式，以适配本站渲染。原文末尾推荐的后续教程《Introduction to Pi》与《Introduction to Exo》可在原文页找到。
