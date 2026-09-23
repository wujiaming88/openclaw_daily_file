---
layout: single
title: "判断层进框架：OpenClaw 把「决策模型」接成了模型角色"
date: 2026-09-23 07:30:00 +0800
categories: [AI]
tags: [AI Agent, OpenClaw, Decision Model, Jev, TypeSafe, Kev, ONNX, Agent Infra, Model Routing, Harness Engineering]
header:
  overlay_image: /assets/images/posts/2026-09-23-openclaw-decision-models-header.png
  overlay_filter: 0.18
  caption: "示意图｜决策模型作为一等「模型角色」接入 Agent 框架；据 OpenClaw 官方博客与文档整理，2026-09-23，非性能评测"
excerpt: "Jev 发布一周后，OpenClaw 把「决策模型」做成了与主模型并列的一等角色。本文拆解它的接口契约、本地 ONNX 与托管 TypeSafe 两条路线的取舍，以及「角色而非工具」这个选择背后的架构含义。"
toc: true
toc_sticky: true
---

2026 年 9 月 15 日，TypeSafe 发布 Jev，一个不生成文本、只返回类型化判断的模型。一周后，OpenClaw 宣布把这类模型接进框架——但接法值得细看：**它没有把 Jev 做成一个工具，而是把「决策模型」做成了与主模型并列的一种模型角色。**<a href="#ref-1">[1]</a>

这个区别不是措辞问题。它决定了判断是在模型循环里"被决定要不要调用"，还是在确定性代码的路径上被直接调用。本文据官方博客与文档，拆解这次集成加了什么、两条 provider 路线怎么取舍，以及规范里那些容易被跳过的条款说明了什么。

*本文依据截至 2026 年 9 月 23 日（Asia/Shanghai）的 OpenClaw 官方博客、文档与公开仓库整理。当前安装的 OpenClaw 版本为 2026.9.4，**不含**该特性，因此本文未做本机实测；所有接口描述均来自官方文档原文。*

## 它加了什么：一个与主模型并列的角色

在此之前，OpenClaw 的模型配置里有两类角色：**主模型**（负责对话与 Agent 工作，产出消息和工具调用）和 **utilityModel**（负责起标题、写摘要这类短语言任务，产出文本）。<a href="#ref-2">[2]</a>

现在多了第三种。官方文档的定位是：**`decisionModel` 是一个"模型角色，带一套共享 API"**，用来做分类、按 rubric 评分和谓词判定，返回的是**类型化答案与概率估计**，而不是文本。<a href="#ref-2">[2]</a>

| 角色 | 典型工作 | 返回结果 |
|---|---|---|
| 主模型 Primary | 对话与 Agent 工作 | 消息与工具调用 |
| `utilityModel` | 起标题、写摘要等短语言任务 | 生成的文本 |
| **`decisionModel`** | **分类、rubric 评分、谓词判定** | **类型化答案与概率估计** |

工程上它被安置得很干净：Control UI 里有一个**独立的 Decision 选择器**，与对话模型的选择器分开；选它不会启动后台任务，也不会替换对话模型；配置落在 agent 层级上。<a href="#ref-2">[2]</a>

```json5
{
  agents: {
    ownership: "explicit",
    defaults: { decisionModel: "onnx/gliclass-edge-v3.0" },
    entries: {
      support: { decisionModel: "typesafe/jev-latest" },
      quiet: { decisionModel: "" },        // 空字符串 = 为该 agent 关掉
    },
  },
}
```

三种继承语义写得很明确：agent 未设置则继承全局默认；agent 显式设为空字符串则**为该 agent 关闭**；全局未设置或为空则整个角色**默认关闭**。文档补了一句关键的话：**"不会自动回退到对话模型。"**<a href="#ref-2">[2]</a>

一次判断请求由两部分组成：共享的 `state`（文本、JSON 对象或数组，或 `null`）与一个 `questions` 映射。问题只有三种类型，与 Jev 的原语一一对应：<a href="#ref-2">[2]</a><a href="#ref-3">[3]</a>

| OpenClaw | TypeSafe | 判据形态 | 返回 |
|---|---|---|---|
| `choice` | Choice | 标签 → 描述的映射 | 选中标签 + 同标签的概率分布 |
| `score` | Score | 有序的 rubric 描述数组 | 可落在级间的分数 + 与下标对齐的概率 |
| `boolean` | **Noul** | `true` / `false` 各自的描述 | 0–1 的 `probabilityTrue` |

注意第三行：OpenClaw 侧叫 `boolean`，TypeSafe 侧叫 Noul——文档里明写这个映射关系。<a href="#ref-3">[3]</a> 同一原语在不同层的名字差异，是上一篇文章里提到过的第一笔"认知税"，这里它被显式写进了适配层。

## 关键：为什么是"角色"，不是"工具"

这是整次集成里最有信息量的一个细节。

OpenClaw 维护者 Josh Lehman 在官方博客里复盘了他的第一次实验：**给 agent 一个调用 Jev 的工具**。结果是——"能用，但它留下了一个**慢的语言模型在思考何时调用一个快 API**。"<a href="#ref-1">[1]</a>

这句话点破了判断层的核心矛盾。把决策模型做成工具，等于把它塞回模型循环里，于是每一次"要不要判断"本身又变成一次昂贵的生成式调用。省下来的钱和延迟，被"决定要不要省"的过程吃掉了。

博客因此明确区分了两件事：**把决策模型暴露给应用代码**，和**给 agent 一个可调用的工具**，是两种不同的东西。Josh 的第一次实验"并非无用，只是不是全部机会"。<a href="#ref-1">[1]</a> 现在两条路径并存：

- **对 Agent**：core 提供一个 `decision_evaluate` 工具，当该 agent 有有效的 `decisionModel` 时自动获得（仍受常规工具策略与显式拒绝约束）。<a href="#ref-2">[2]</a>
- **对插件作者**：通过 Plugin SDK 直接调用 `api.runtime.decisions.evaluate`，**消费方不需要任何 provider 的 SDK 或 API key**——主机负责按 agent 配置选好 provider 和模型。<a href="#ref-2">[2]</a>

```ts
const outcome = await api.runtime.decisions.evaluate(
  {
    state: { message: "Checkout is failing for all customers." },
    questions: {
      route: {
        type: "choice",
        instructions: "Which team should handle this?",
        criteria: {
          support: "Technical problems and service outages",
          billing: "Invoices, refunds, and incorrect charges",
          sales: "Pricing and purchasing questions",
        },
      },
      escalate: {
        type: "boolean",
        instructions: "Does this require human incident response?",
        criteria: {
          true: "A serious service incident needs human attention",
          false: "A routine request can follow normal handling",
        },
      },
    },
  },
  { agentId, purpose: "support.triage", rubricVersion: "1", timeoutMs: 30000, signal },
);
```

`purpose` 标识消费方操作，`rubricVersion` 把 rubric 版本写进结果溯源——两者都不替代问题的 `instructions`。文档特别提醒：**rubric 的含义变了就要改版本号。**<a href="#ref-2">[2]</a>

这解释了为什么必须是"角色"而不是"工具"：**角色的价值在于它是全局可寻址的配置**。任何插件、任何钩子，都能拿到当前 agent 已选定的那个决策模型，而不必各自重造一套 provider 集成，也不要求用户在每个地方重复配置同一个选择。<a href="#ref-1">[1]</a><a href="#ref-2">[2]</a>

## 两条路线，同一接口：本地 ONNX vs 托管 TypeSafe

同一个角色下，官方目前给了两个 provider 插件，取舍方向几乎相反。<a href="#ref-2">[2]</a><a href="#ref-3">[3]</a><a href="#ref-4">[4]</a>

| | **ONNX**（本地） | **TypeSafe AI**（托管 / 本地 Kev） |
|---|---|---|
| 推理位置 | 本机 CPU，常驻子进程 | TypeSafe 托管端点，或显式配置的 loopback 本地服务 |
| 凭据 | **不需要**（本地推理） | 托管需受保护凭据；本地 Kev 不需要 |
| 选项上限 | 2–64 | **2–255** |
| 分数级数 | 2–64 | 2–10 |
| 输入预算 | 每个编码输入 512 token | 受主机批量限制与厂商输入契约约束 |
| 模型 | DeBERTa Zero-shot v2、GLiClass Base/Edge v3、GLiClass Instruct Base/Edge v1、GLiNER 2.5 Base/Small（共 7 个） | `jev-1.13.0`、`jev-latest`、`kev-latest`（本地 Kev） |
| 数据去向 | 不出本机 | **所选证据会发送到 TypeSafe** |

最值得记的一条，是文档里那句几乎像警示语的话：

> `decisionModel` 是一个带共享 API 的模型角色。它的 provider 可以使用不同的模型架构和推理后端。**共享接口并不会让它们的推理能力或概率变得可以互换。**<a href="#ref-2">[2]</a>

这是把"统一接口"和"统一能力"明确切开。一个 GLiClass 边缘模型和一个托管 Jev 挂在同一个 `choice` 接口下，意味着**调用方式一样，不代表答案质量一样**——阈值必须针对具体 provider 重校。

**本地 Kev 这条路值得单独说。** 它把"判断层可以自托管降级"从一个社区观点变成了框架里的一等选项：<a href="#ref-3">[3]</a>

- 只接受 loopback 地址（`localhost` / `127.0.0.1` / `[::1]`），**LAN 与远程主机不被接受**；请求不走常规 HTTP 代理变量。
- `baseUrl` 填 origin（不带 `/v1`），插件自己拼 `/v1/systemone`。
- **一个服务进程只跑一个 checkpoint**，请求里的模型标签不会加载或切换权重；换档位要在启动服务时决定，并用 `GET /v1/models` 核对。
- 服务串行推理，并发 HTTP 调用只会增加排队时间；`kev-latest` 标签要求 `baseUrl`，且**永远不会被发往托管端点**。

这里还有一处版本漂移值得记录：OpenClaw 的适配器文档写的是"**基于 Qwen3 的 Kev-0.6B / Kev-4B / Kev-8B 已通过该适配器测试**"，而 kev 仓库当前提供的是"**基于 Qwen3.5 的 0.8B / 4B / 9B 家族**"（Apache-2.0，可训练、可自托管）。<a href="#ref-3">[3]</a><a href="#ref-5">[5]</a> 两边的档位命名与底座代次并不一致，接之前要以自己实际拉取的 checkpoint 为准。

## 把"失败姿态"写进规范

这是我认为整份文档里**最值得学**的一段。判断层能不能进生产，往往不取决于它判断得多准，而取决于**它失败时会发生什么**。OpenClaw 把这件事写成了硬性条款。<a href="#ref-2">[2]</a><a href="#ref-3">[3]</a>

**一、失败必须显式。** `unavailable` 结果带明确原因：`disabled`、`not-configured`、`unsupported-input`、`overloaded`、`deadline`。由**消费方**决定是跳过、推迟，还是走自己的既有回退。

**二、三条明令禁止。** 文档原文：

- **不得**在已配置 provider 不可用时，改用 shell 或 HTTP 调用来顶替；
- **不得**在聊天里索要凭据；
- **不得**把一次失败当作否定答案。

最后一条尤其关键。"判断服务挂了"和"答案是 False"，在数据流里必须是可以区分的两种状态——否则一次网络抖动会被系统性地翻译成"不危险""不需要处理"。

**三、不回退，也不许被取消触发回退。** 角色未配置就保持关闭，不自动回退到对话模型；调用方取消（cancellation）时，**不得**启动回退工作。

**四、概率不是许可。** 文档反复强调：概率与可选的 `confidence` 是估计值，**不是已证实的准确率保证**；"一个答案不授予发送消息或执行其他副作用的权限"。有消费者策略（比如 `probabilityTrue ≥ 0.9` 就升级）时，必须"在代表性样本上验证该阈值"。

顺带一个容易误读的澄清：**Score 是"零基 rubric 位置"，不是置信度。** 四个 urgency 描述定义的是一条 0–3 的刻度，`2.85` 表示接近最高影响档，把它显示成 `(100 × 2.85) / 3` 是一个**位置换算，不是"正确率 95%"**。除数是 `criteria.length - 1`。<a href="#ref-2">[2]</a>

还有一条与上一篇文章的独立审计结论直接呼应的建议：**当"证据不足"本身是个需要区分的结果时，要显式加一个"证据不足"的 Choice 选项**；文档同时提醒，低概率偏向 false，但"证据缺失并不保证概率接近 0.5"。<a href="#ref-2">[2]</a> 这和那份校准审计里"删掉 abstain 选项会让模型自信地偏向刻板印象"是同一个工程动作。

## 边界与数值

需要记住的上限（**可移植 rubric**）：最多 32 个问题、Choice 2–64 个选项、Score 2–10 个有意义的锚点、显式给出 true/false 描述。<a href="#ref-2">[2]</a>

主机侧还有一层硬边界：请求上限 **1 MiB、20,000 个 JSON 节点、深度 32、256 个问题**；每个 provider 最多**同时 4 个请求**，单次 deadline 上限 **30 秒**；超出返回 `overloaded`。**不支持或超界的输入会被直接拒绝，而不是静默截断或拆分**——这条比上限数字本身更重要。<a href="#ref-2">[2]</a><a href="#ref-3">[3]</a>

给插件作者的 provider 契约也一并开放了：实现 `openclaw/plugin-sdk/decisions` 的 `DecisionProviderV1`，用 `api.registerDecisionProvider(provider)` 注册，`id` 与 `contractVersion: 1` 标识契约；在插件清单里声明 `contracts.decisionProviders` 与 `decisionModels`，选择器就会出现在独立的 Decision 目录中。<a href="#ref-2">[2]</a>

## 社区：一周内约 15 个 PR

官方博客给出的采用信号是硬的：到录制时，**社区已经提了约 15 个 PR**，讨论"决策模型可以放在 OpenClaw 的哪些位置"。一个具体例子是**过滤工具与技能定义**，让主模型不必花时间判断哪些能力相关。<a href="#ref-1">[1]</a>

被提到的方向还包括：<a href="#ref-1">[1]</a>

- **技能整理**：把"更频繁地复查与合并学到的技能"变得足够便宜；
- **上下文管理**：在压缩时识别有用消息，或收窄对历史会话的检索；
- **模型选择**：从用户已配置的模型里为新任务挑一个。

最能说明问题的是一个具体痛点。Peter 的 agent **Molty** 住在团队 Discord 里，"有个习惯：在两个人之间插话，而那两个人并没有在跟它说话。我们只好让它安静，然后过一会儿又把同样的话说一遍。" 现在如果要在 agent 开口前先问一个模型"该不该回应"，就是**在一个已经很慢的模型调用前面再加一个模型调用**——每一条消息都加。博客的结论是：**一个快的决策模型能让这个检查变得实际可行。**<a href="#ref-1">[1]</a>

（官方在这个位置放了个自嘲："我们不会替换麦当劳。我们只想要一个知道何时该闭嘴的 agent。"）<a href="#ref-1">[1]</a>

采用数据来自 Vercel：Jev 在 AI Gateway 的采用速度超过历史上任何模型，**首日触达约 13% 的团队，是 GPT-5.6 家族的 2 倍、Fable 5.1 的 6 倍**。<a href="#ref-1">[1]</a>

但框架侧留了刹车：自动化的实验性消费者需要**显式的 "Decision assistance" 开关**（Labs 里的 opt-in），而该 Labs 条目**目前只提供闸门基础，尚未接入任何自动消费者**；显式的 `decision_evaluate` 则独立于 Labs 存在。<a href="#ref-2">[2]</a>

## 我的判断

**一、这是"抽象层"的胜利，不是"接了个模型"。** 把决策模型做成角色，等于承认"判断"是 Agent 框架里一种与"对话"和"短文本生成"并列的原语。这个位置一旦被官方抽象出来，它就会像 utilityModel 一样，被插件生态反复复用——而不是每个插件各自接一遍 Jev。

**二、本地与托管放进同一接口，说明判断层正在被商品化。** ONNX 那一列（本地、免费、无凭据、512 token）和 TypeSafe 那一列（托管、255 选项、数据出本机）在同一个 `choice`/`score`/`boolean` 接口下竞争。文档那句"共享接口不等于能力可互换"是这个阶段最诚实的一句话——**接口统一了，能力没有，阈值要重校。**

**三、真正决定它能否进生产的是失败姿态条款。** "不得把失败当否定答案""不得用 shell/HTTP 顶替""取消不得触发回退"——这些约束比任何加速比数字都更能说明一个判断层是否被当作**基础设施**而不是**玩具**对待。

**要保留的怀疑：** 这仍是实验。两个 provider 插件都还是**未发布的候选**（TypeSafe 插件需 ≥ 2026.9.6 的主机与插件 API），自动消费者尚未接通，官方也明说"我们还不确定所有有用的地方在哪"。而概率是估计、不是保证——把阈值搬到一个新 provider 或新任务上之前，**先在代表性样本上验证**，这条建议在文档里出现了不止一次。

## 结论

**一、判断层的战场，从"模型"转到了"角色"。** 上一周的问题还是"Jev 值不值得用"；这一周 OpenClaw 给出的答案是：把它变成一个任何插件都能寻址的角色，让判断从模型循环里搬到确定性代码的路径上。

**二、这次集成最值得抄的是三件事：** 一个**与对话模型分开的选择器**；一套**provider 中立的调用契约**（消费方不碰 key、不碰 SDK）；一组**把失败写成显式状态**的规范条款。

**三、对做 Agent 的人，现在可以做的一件事：** 把自己 Agent 循环里那些高频、重复、答案空间封闭的判断点列出来——**"该不该回应""这条消息要不要留""该上哪个模型""这个工具要不要暴露"**——然后对着这份清单看，哪一条已经能挂上 `decision_evaluate`。框架已经把插槽留好了，缺的是你的清单。

## 来源

<a id="ref-1"></a>[1] OpenClaw Blog, *Decision models in OpenClaw*（含 Josh Lehman、Graham McBain 访谈与 Vercel 采用数据）— https://openclaw.ai/blog/decision-models-in-openclaw
<a id="ref-2"></a>[2] OpenClaw Docs, *Decision models*（模型角色、问题类型、`decision_evaluate`、插件 API、边界与失败语义）— https://docs.openclaw.ai/concepts/decision-models
<a id="ref-3"></a>[3] OpenClaw Docs, *TypeSafe AI*（插件安装、托管凭据、本地 Kev 部署、Choice/Score/Boolean → Choice/Score/Noul 映射）— https://docs.openclaw.ai/plugins/typesafe
<a id="ref-4"></a>[4] OpenClaw Docs, *ONNX*（本地 CPU 分类器与模型清单）— https://docs.openclaw.ai/plugins/onnx
<a id="ref-5"></a>[5] GitHub, *jaredpalmer/kev*（Apache-2.0，基于 Qwen3.5 的可训练决策模型族，System One 兼容 API）— https://github.com/jaredpalmer/kev
<a id="ref-6"></a>[6] TypeSafe AI Docs, *System One / API*（Jev 原语与端点）— https://docs.typesafe.ai/api
<a id="ref-7"></a>[7] OpenClaw Docs, *Experimental features → Decision assistance*（Labs opt-in 闸门）— https://docs.openclaw.ai/concepts/experimental-features#decision-assistance
<a id="ref-8"></a>[8] OpenClaw Docs, *Plugin SDK capabilities → Decision models contract v1* — https://docs.openclaw.ai/plugins/sdk-overview/capabilities#decision-models-contract-version-1
