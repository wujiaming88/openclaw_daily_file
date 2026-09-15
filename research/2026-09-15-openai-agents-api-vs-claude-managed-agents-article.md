# OpenAI Agents API 与 Claude Managed Agents：架构、能力与差异

OpenAI 于 2026 年 9 月 10 日推出公开 beta 的 Agents API，将 Codex 的核心运行系统以托管接口开放给开发者。Anthropic 的 Claude Managed Agents 同样处于 beta，文档注明 API 账号默认开放，部分能力另有限定 preview；它已经提供会话、执行环境，以及定时部署、跨会话记忆和结果评审等配套能力。两项服务比较的不是单次模型回答，而是**一个 Agent 如何持续使用工具、保存工作状态并完成任务**。[O1][A1][A2][A3][A4]

两者的共同方向，是把模型调用循环、上下文管理、工具编排和多 Agent 协作交给厂商运行。差异主要在于：执行环境如何组织，哪些工作流能力已成为原生资源，以及应用还需要承担哪些治理与交付责任。

> **资料截止：2026 年 9 月 15 日，Asia/Shanghai。** 本文依据官方公告、产品指南、定价和安全文档，不包含付费 API 实测，也未验证具体账户的地区资格、配额、性能或 SLA。文中的选型倾向是架构与接口判断，不是模型质量、稳定性或成本排名。“本次未核到对应接口”也不等于厂商不存在该能力。运行系统、所选模型、工具质量和业务验收是不同问题；本文不把普通模型 API、Agent SDK 或历史营销页的能力自动算到新的托管 API 上。

## 定义：托管的不是一次回答

模型 API、Agent SDK 和托管 Agent API 是三个不同层次。它们都可以用于构建 Agent，但向开发者交付的内容不同。

| 产品层次 | OpenAI | Anthropic | 应用的主要责任 |
|---|---|---|---|
| 模型接口 | Responses API 等 | Messages API | 决定循环、执行工具、管理状态与恢复 |
| 自行运行的框架 | Agents SDK | Claude Agent SDK | 使用框架组织 Agent，自行承担部署与运行 |
| 托管运行服务 | Agents API | Claude Managed Agents | 配置任务与工具，选择执行环境，管理业务权限和验收 |

模型接口提供模型调用能力；SDK 提供组织 Agent 的程序框架；托管服务则由厂商运行 Agent 的核心循环和会话系统。因此，**Agents API 不是 Agents SDK 改名，Managed Agents 也不是 Claude Code 订阅的远程包装**。两项托管产品的参数、事件、定价与数据政策，均应按各自文档判断。

![模型API由应用管理循环和状态，SDK提供框架但仍由应用运行，托管API由厂商运行harness和会话；最终授权与验收仍属应用责任](2026-09-15-openai-agents-api-vs-claude-managed-agents-article-assets/definitions.png)

*图 1｜三种接口的责任分配示意图。根据 [OpenAI 架构指南](https://developers.openai.com/api/docs/guides/agents-api/architecture)与 [Claude Managed Agents 概览](https://platform.claude.com/docs/en/managed-agents/overview)整理，2026-09-15。图中比较运行责任，不表示模型能力高低。*

两项托管服务都使用 **Agent、Environment、Session、Events** 等原语；OpenAI 还列出 **Items**。在 OpenAI 的事件恢复流程中，应用先打开事件流并缓冲，再获取 session 和 items，按 item ID 重建状态。参数和事件仍需按各自产品文档判断。[O2][O5][A1]

这也解释了为什么“保存聊天历史”不足以描述这类产品。会话、执行环境和业务结果有不同的生命周期；保存 session、压缩上下文或存储文件，也不能直接等同于一套有版本与权限治理的跨会话记忆系统。

## 架构：控制面与执行面

两家都把控制面与执行环境分开。厂商运行模型调用和工具循环，维护上下文与会话；应用提交任务、接收事件、处理业务工具，并选择命令和文件操作在哪里执行。

**自托管只改变执行位置，不把模型与控制面一起搬回本地。** 工具输入输出仍会进入厂商系统；让 Agent 访问内部网络，不代表业务数据不会流出内部网络。[O3][O7][A9][A10]

![企业应用下发任务和审批，厂商控制面运行模型循环与会话，工具可在厂商沙箱或自托管环境执行；工具输入输出跨越两层边界](2026-09-15-openai-agents-api-vs-claude-managed-agents-article-assets/architecture.png)

*图 2｜控制面与执行面边界示意图。根据 [OpenAI Architecture](https://developers.openai.com/api/docs/guides/agents-api/architecture)与 [Claude 自托管沙箱指南](https://platform.claude.com/docs/en/managed-agents/self-hosted-sandboxes)整理，2026-09-15。自托管改变工具执行位置，不意味着所有数据留在本地。*

### 执行环境的选择

OpenAI 提供三种环境模式：

- **`none`**：没有自己的 Linux 工作区，可以调用远程 MCP 和应用 function tools。工具驱动的任务不一定需要完整沙箱。
- **`openai_hosted`**：由 OpenAI 准备 Linux 环境，支持预装 packages、初始文件、setup commands、skills 和 plugins。
- **`self_hosted`**：应用管理环境与 executor，适用于私网、定制镜像和特殊计算资源。官方伙伴包括 E2B、Modal、Daytona、Cloudflare 等。

伙伴可以提供不同的 CPU、GPU、VPC 或存储配置，但不能据此认为 OpenAI 默认沙箱具有这些全部规格。[O1][O3][O6]

Claude Managed Agents 提供 `cloud` 与 `self_hosted` 两种环境，执行环境可以由厂商托管，也可以放在应用自己的基础设施。服务支持 Bash、文件操作、Web Search 与 Web Fetch 等工具。[A1][A9][A14]

两项服务都支持持续会话、上下文压缩和追加输入以继续或引导工作。Claude 文档还明确提供中断与临时错误重调度。它们减少的是运行系统的维护负担，而不是取消应用对任务成败的责任。

### Codex 不只对应编码

OpenAI 使用 Codex harness，但官方示例覆盖事故调查、Slack 工作助手、数据分析、GitHub 问题调查和文档审阅。这里复用的是持续运用工具、文件和代码的能力，而不是把应用范围限定为生成程序。[O1][O2]

从架构上看，OpenAI 的重点是开放 Codex 运行系统，并让执行环境可以组合；Claude 则在托管运行之外，将更多周期性知识工作需要的模块纳入平台。这个差异来自当前文档中的产品范围，不能直接推出谁的任务质量更高。

## 能力：工具效率与多 Agent

两家都有原生多 Agent 协作，也都支持 MCP 和自定义业务工具，但工具如何提供给模型、如何进入子 Agent，上下文如何分配，存在需要在接入前确认的差别。

| 维度 | OpenAI Agents API | Claude Managed Agents |
|---|---|---|
| 运行系统 | 托管 Codex harness | 托管可配置 harness |
| 内置与业务工具 | 文件与命令、MCP、functions、Web Search | Bash、文件、Web Search/Fetch、MCP、custom tools |
| 工具效率机制 | 自动 compaction、tool search、programmatic tool calling | 上下文压缩及托管工具执行 |
| 原生协作 | 创建、通信、等待、中断子 Agent | coordinator 委派并接续子 Agent thread |
| 并发口径 | 默认 6 个子 Agent，不含协调者，可配置 | 最多 25 个并发 thread，advisor 有例外 |
| 共享边界 | 协调者和子 Agent 共享环境文件系统 | 共享 sandbox、文件系统和 session vault credentials |

### 工具的载入与使用

OpenAI 的 **tool search** 按需载入工具定义，避免每轮都把全部工具描述放入上下文。**Programmatic tool calling** 则允许用代码并行、串联或过滤工具结果，只把必要信息带回模型上下文。它可以减少无必要内容，但不是完整 Node/Linux 环境的替代品。[O1][O4]

自动 **compaction** 降低了开发者自己维护长上下文的负担，却不能理解为无损的无限记忆。这项边界与会话是否持久化无关：记录可以保存，模型当前使用的上下文仍需要管理。

### 子 Agent 的能力不是简单复制

OpenAI harness 提供子 Agent 的创建、通信、等待与中断工具。默认并发数为 **6**，不包含协调者；这是可配置默认值，不是公布的硬最大并发配额。[O4]

一个直接影响业务接口设计的限制是：**OpenAI 子 Agent 当前不支持 function tools**。它们可以继承配置的 MCP、凭据和 Web Search，也能访问共享环境中的文件与命令工具。如果业务能力全部封装成应用函数，就不能假定子 Agent 都能调用；需要由协调者处理，或设计合适的 MCP／执行端包装。[O4][O9]

Claude 的 coordinator 只能委派 **一层**，roster 最多包含 **20 种 Agent**，最多 **25 个并发 thread**，advisor thread 有例外。每个 thread 的上下文、工具配置和历史独立，也可以继续追加工作；但它们共享 sandbox、文件系统和 session 的 Vault 凭据。[A8]

因此，两家的多 Agent 都首先是**上下文与任务的分工机制**，而不是租户隔离机制。增加子 Agent 不会自动获得新的安全边界，写入相同文件的任务仍需协调。不同用户或租户需要真正分离的 session 与执行环境，而不只是不同的 system prompt。

## 状态治理：原生配套的差别

运行循环之外，周期任务通常还需要调度、长期知识、结果检查和预算控制。Claude 已将这些功能做成原生资源；本次读取的 OpenAI Agents API 指南与目录中，尚未核到与 Memory stores、Scheduled deployments、session budget 直接对应的接口。OpenAI 可以通过自有工具和存储实现跨会话记忆，也可以由自己的调度器创建 session，但这与厂商提供原生模块是不同的责任分配。

| 需求 | OpenAI Agents API 的已核证据 | Claude Managed Agents 的已核证据 |
|---|---|---|
| 跨会话记忆 | 未核到直接对应的原生记忆库；可自建 | 版本化 Memory stores |
| 周期执行 | 未核到直接对应的原生定时部署；可外部调度 | POSIX cron + IANA 时区 |
| 结果检查 | 需要自建或接外部验收 | Outcome、rubric 与独立上下文 grader |
| 会话费用上限 | 未核到直接等价接口，不能以普通账户预算代替判断 | 创建 session 时设置 budget |

这张表不应被读成“OpenAI 不支持这些工作”。它描述的是当前文档明确提供的模块，也不把 Agents SDK 或其他产品的评测功能自动算到新托管 API 上。

### 定时部署并非精确计时器

Claude Scheduled deployments 支持 POSIX 五段 cron 和 IANA 时区，每次触发创建 session，并可设置单次运行预算。每个组织最多支持 **1,000 个 scheduled deployments**。[A2]

官方允许实际执行出现抖动：按运行间隔最高 **15%**，抖动窗口下限 **5 秒**、上限 **9 分钟**。这适合日报、周报和周期检查，不应被当作秒级交易或精确时刻承诺。另一个关键区别是：**deployment run 成功只表示任务启动成功，不表示报告已写完或消息已送达。**

### 记忆是可以治理的资源

Claude Memory stores 是带路径的文本集合，可以经 API 维护、挂载到 session 供工具读写，并在不同 session 中复用；每次修改生成不可变版本，支持版本审计。容量限制为每个 session 最多 **8 个 store**，每个 store 最多 **10,000 条 memory**，每条最多 **100 kB**。[A3]

公共规范或资料宜设为只读，用户或项目记忆可以按需求独立分配读写权限。但默认可写也带来跨会话提示注入污染风险：模型写下的内容，不会因此变成可信事实。可维护的长期知识资源，也不代表模型已经自动可靠地学习了所有经验。

自托管还有实现差异。SDK worker 负责 memory 同步，CLI worker 不挂载 memory；只读模式可以阻止修改上传，但不保证 Bash 无法改变本地副本。因此，“只读记忆”不能不加区分地理解为所有运行形态下相同的文件隔离。[A3][A9][A10]

### Outcome 提供评审循环

Outcome 允许应用给出 rubric，由独立上下文的 grader 检查产物，再让执行 Agent 根据反馈迭代。例如，检查研究报告每条关键结论是否有来源、Excel 是否包含指定 sheet，或结果是否符合 schema。[A4]

它减少了应用自行搭评审循环的工程量，却不等于可靠的业务验收。**独立上下文不是独立事实来源**，grader 仍可能漏错。计算、数据准确性、真实发布和合规动作，仍需要程序测试、必要的人工审批及外部交付凭证。

### 预算在模型请求之间生效

Claude session budget 依据公开 list cost 限制新的模型请求，达到阈值后暂停新模型调用。金额是以美分表示的整数字符串：`"125"` 表示 **$1.25**，而不是 $125。[A5]

预算不是精确到分的硬切断。系统在新模型请求开始前检查阈值，已开始的请求仍会完成；多 thread 下，可能各自超出一次模型请求的费用。预算还必须在创建 session 时设置：原本没有预算的 session 不能中途新增；移除后也不能重新添加。

## 安全：权限不随托管消失

托管工具执行，并不意味着厂商能够替应用决定业务授权。Claude 的权限策略包括 `always_allow`、`always_ask` 和 `auto`；内置 agent toolset 默认允许，MCP 默认询问。`auto` 是平台自动判断，可能直接放行，并非人工审批。[A6]

**Claude custom tools 不受这些权限策略治理，授权与审批仍由应用实现。** OpenAI function tools 同样由应用处理。[O9][A6]

从应用的授权责任出发，高风险动作必须有应用层准入和审批；网页、工具返回和文档可能含有恶意指令，不能让它们获得与用户授权相同的地位。

### Vault 的适用范围不同

OpenAI Vault 适用于由 OpenAI 服务发起的 MCP 连接；环境端凭据需要另外管理。[O8]

Claude 除 MCP Vault 外，还在云环境变量中提供 opaque placeholder：真实 secret 不直接放进沙箱，而是在出站请求中替换，并可限定目标 host 及 header/body 位置。不过，这不是通用的凭据兼容层：[A7]

- 需要在本地用 secret 计算签名的客户端，无法直接使用占位符。
- 换取的新 token 返回沙箱时，不保证继续受到遮蔽。
- `environment_variable` Vault 当前不支持 self-hosted。

### 自托管不改变 ZDR 资格

OpenAI Agents API 当前仅支持美国 data residency，且不支持 ZDR；选择自托管执行环境不会使它获得 ZDR 资格。Claude Managed Agents 当前同样不支持 ZDR，也不适用 HIPAA BAA覆盖。[O2][A1]

因此，合规判断必须细化到产品端点和合同。基础模型 API 具有某项资格，不能直接推导托管 Agent 服务也具有；工具在内网运行，更不能自动推导内容不会进入厂商控制面。

## 恢复：会话、沙箱与业务结果

长任务可靠性至少涉及三件不同的事：工作记录是否还在，执行环境能否继续，业务动作是否真正完成。混淆这三层，容易把“可恢复会话”误读成“任何失败都可无损恢复”。

### 事件恢复不是重新提交任务

两家都提供 SSE 与 webhooks。OpenAI 可获取 items 和 turns、在平台查看 trace；Claude 提供完整持久事件，以及 thread、outcome、usage 等相关事件。[O5][O11][A12]

OpenAI 的 SSE 不重放遗漏事件。恢复客户端视图时，应先打开新流并缓冲事件，再获取 session 与已保存 items，按 item ID 重建状态。**`idle` 或关闭 stream 不表示成功，`turn.completed` 也不保证每个工具都成功**，还要检查最终输出与工具结果。[O5]

OpenAI 自托管环境在提交输入时，等待连接最多 **5 分钟**。超时输入不会因稍后连上而自动重放；中途断连不会自动重启被杀命令，也不会自动发出重连请求 webhook。复用相同 environment ID，不会还原替换机器上的文件，持久卷与快照仍需自己管理。[O7]

观测也有边界。OpenAI 的详细 trace 可在平台查看，但公共 beta 不提供外部 trace exporter 或受支持的详细 trace 读取 API；usage 是 best effort，可能为空或后补，不能作为最终账单。[O11]

### 会话寿命不是沙箱寿命

OpenAI-hosted 的已连接沙箱会接收 keep-alive，包括两个 turn 之间。只有活动与 keep-alive 都停止 **1 小时**后，沙箱才可能删除；并不是用户一小时没说话就必然删除。`/workspace/outputs` 中的文件会在 turn 完成时发布为不可变产物，这些副本可以在沙箱过期后下载。[O6]

Claude 的会话历史保留到删除，但 cloud sandbox 从创建日起只保留 **30 天**，活动不延长该窗口。重要产物应输出并进入自己的资料库，不应把沙箱作为永久存储。[A12][A13]

两家的触发条件不同，简单用“1 小时对 30 天”比较可靠性没有意义。

### 工具重试需要业务幂等

发送邮件、创建工单或修改数据库后，结果回传可能丢失。此时重新运行工具，可能重复已经成功的动作。应保存任务 ID、调用 ID、产物 ID 与副作用凭证；不确定是否执行成功时，先查询真实结果，而不是直接重试。OpenAI function 文档明确要求持久保存调用结果，这一工程原则也适用于 Claude custom tools。[O9]

最终交付还要检查：产物存在且可读、字段或数值正确、外部发布成功、渠道收到消息。运行结束、部署 run 成功、某次 grader 通过，都不能单独替代这些证据。

## 计费：比较完整任务成本

OpenAI 公告表示，Agents API 本身不收取额外管理费，但模型、工具与执行环境仍会产生费用。一次任务的账单可能包括主 Agent、子 Agent、重试和压缩等实际模型调用，工具费用，以及 OpenAI 沙箱、自有或第三方计算资源和其他外部服务。[O1][O11][O12]

OpenAI-hosted 文档引用标准 container 定价，当前价格表为：

| 内存规格 | 每 container／每 20 分钟 session 公布价格 |
|---|---:|
| 1 GiB | $0.03 |
| 4 GiB | $0.12 |
| 16 GiB | $0.48 |
| 64 GiB | $1.92 |

但同一价格页另注明，**符合条件的 container sessions 按分钟计费，最少 5 分钟**。本次未核清具体 Agents sandbox 的适用资格，也没有证明上述每个规格都能在该 API 中选择。因此，不能据此推导任意 Agent 任务的确定小时价。缓存写入可能另外收费，而 usage 没有独立计数，最终还需对账单。[O6][O11][O12]

Claude 当前的计费结构为：**模型 tokens + $0.08／running session-hour + 搜索等相关费用**。[A11][A5]

运行费精确到毫秒，仅对 `running` 状态计费；`idle`、`rescheduling` 与 `terminated` 不收这一项，也不另外叠加 code-execution container-hour。多个 thread 重叠运行的时间，在 session runtime 中只计一次，但每个 thread 的模型 tokens 分别计费。

Web Search 为 **$10／1,000 次**；缓存遵循所选模型政策，托管 session 不适用 Messages Batch 折扣。运行 4 小时产生的 runtime 项是 **$0.32**，不代表整份研究报告总共只花 $0.32。[A11][A5]

公平的比较指标应是：**每份通过同一验收标准的任务总成本**，结合成功率、人工介入时间和 P95 交付时延。更合适的模型可能减少轮次，更完整的平台可能节约开发运维，更多子 Agent 则可能增加 tokens 与合并成本。这些都需要同任务实测；不同模型单价不能自动转换为平台性价比，也不能从“API 免费”或某个小时单价直接推断性价比。

## 差异如何影响选择

OpenAI 更值得优先评估的场景，是希望复用 Codex 运行方式、处理代码和文件、密集调用工具，并在不同执行环境之间选择。Claude 更值得优先评估的场景，是周期性研究、运营与检查，需要定时、记忆、评审和预算一起工作。两者是基于产品范围的试用顺序，而不是质量胜负结论。

| 需求 | 建议的评估起点 | 必须保留的条件 |
|---|---|---|
| 代码、文件、工具密集任务 | OpenAI Agents API | 实测 harness、沙箱、tool search 与 PTC；不预设质量领先 |
| 周报、运营研究、周期检查 | Claude Managed Agents | 原生配套较完整，但业务验收与审批仍由应用负责 |
| 多模型、复杂权限、已有控制系统 | 将两家作为可替换执行端 | 用户状态、资产和交付不全部锁在厂商 session |
| 简短一次性调用、步骤完全固定 | 优先考虑基础模型 API | 未必需要完整托管 Agent 状态模型 |
| 必须 ZDR 或严格数据本地化 | 不直接选用本次两项托管服务 | 另评合规端点、合同、自管 harness 与可用模型 |

### 保留自己的交付控制层

对已有 OpenClaw 或自有多 Agent 系统，更稳妥的接入方向是保留任务入口和业务控制，把两家服务作为执行适配器。自己的系统继续管理任务账本、租户权限、审批、预算与最终期限，并统一验收和投递。

![自有任务控制层管理权限审批和期限，向OpenAI、Claude或原有执行端派发任务，结果统一经过产物校验、归档、幂等发布与投递回执](2026-09-15-openai-agents-api-vs-claude-managed-agents-article-assets/delivery.png)

*图 3｜可替换执行端与统一交付层示意图。依据本文研究结论绘制；运行责任参考 [OpenAI Architecture](https://developers.openai.com/api/docs/guides/agents-api/architecture)与 [Claude Managed Agents 概览](https://platform.claude.com/docs/en/managed-agents/overview)，2026-09-15。此图是接入建议，不代表 OpenClaw 已开箱实现这些适配器。*

模型 provider 兼容不等于支持托管 session、事件与制品协议，仍需要单独适配和验收。这样做不是否定托管平台，而是把厂商负责的运行系统，与应用必须掌握的业务结果分开。

### 用小型 POC 验证判断

下一步可以固定三类任务：带来源的研究摘要、文档或表格结构化产物、带人工审批的模拟外部动作。使用公开或合成数据，关闭真实发布；共同验收来源真实性、字段与数值正确性、文件可打开、失败有记录，以及审批前没有副作用。

故障测试应覆盖客户端 SSE 断连、自托管 executor 断连、工具超时、动作已执行但回执丢失、等待输入时暂停，以及预算或期限到达。记录验收成功率、全任务 tokens／工具／沙箱账单、总耗时与 P95、人工介入次数、重复副作用次数和恢复后的文件完整性。

只对验收通过、且总成本／维护负担确实改善的任务替换执行器，并保留回退路线。**这是一份建议方案，本次没有实际创建或运行 POC。** 小样本可以发现集成问题，不能证明总体稳定性；并发配额、账户资格、真实计费粒度、最长运行时间与 SLA 仍需在生产前核实。

### 运行能力与应用价值

从当前能力范围看，两家正在把通用循环、上下文压缩、沙箱和基础委派做成标准服务。本研究的判断是：仅靠封装 prompt 并调用几个工具的产品，差异会缩小。

更持久的应用价值在于行业数据、工作流权限、可信结果验收、业务系统集成、失败恢复、审计与跨供应商交付。这是根据产品责任边界作出的研究判断，不是对厂商未来市场份额的预测。选择哪一家，最终仍要回到同一个问题：**在应用要求的权限、成本与交付标准下，哪种运行方式更合适。**

## 资料与方法

本文以实际取得的官方正文为依据。OpenAI 部分方法 reference 链接读取失败，未据此虚构方法或认定能力缺失；Anthropic 部分产品博客仅取得标题，未用其营销数字证明性能。没有复现示例、运行付费任务或验证任何具体账户已经可用。

### OpenAI

- [O1 Introducing the Agents API](https://openai.com/index/introducing-the-agents-api/)：公告、public beta、Codex harness、生态与管理费口径；日期另以官方RSS交叉核对。
- [O2 Agents API overview](https://developers.openai.com/api/docs/guides/agents-api/overview)：产品原语、定价引用、US residency与ZDR。
- [O3 Architecture](https://developers.openai.com/api/docs/guides/agents-api/architecture)：none/hosted/self-hosted与责任划分。
- [O4 Multi-agent](https://developers.openai.com/api/docs/guides/agents-api/multi-agent)：默认并发、共享环境、function工具限制。
- [O5 Events and items](https://developers.openai.com/api/docs/guides/agents-api/sessions/events)：流恢复与完成语义。
- [O6 OpenAI-hosted sandboxes](https://developers.openai.com/api/docs/guides/agents-api/environments/openai-hosted)：环境、网络、产物和到期规则。
- [O7 Sandbox lifecycle](https://developers.openai.com/api/docs/guides/agents-api/environments/lifecycle)：连接5分钟、断连、输入与文件恢复限制。
- [O8 Vaults](https://developers.openai.com/api/docs/guides/agents-api/tools/vaults)：service-origin MCP秘密管理。
- [O9 Functions](https://developers.openai.com/api/docs/guides/agents-api/tools/functions)：应用执行、恢复、幂等结果记录。
- [O10 Sandbox security](https://developers.openai.com/api/docs/guides/agents-api/environments/security)：隔离、出口、应用key与environment key分离。
- [O11 Observability and usage](https://developers.openai.com/api/docs/guides/agents-api/observability)：trace边界、usage非最终账单、缓存写费。
- [O12 Pricing](https://developers.openai.com/api/docs/pricing)：tokens、tools、container价格及分钟计费注记。
- [O13 Configuration](https://developers.openai.com/api/docs/guides/agents-api/configuration)：可复用配置、session覆盖与环境设置。

### Anthropic

- [A1 Managed Agents overview](https://platform.claude.com/docs/en/managed-agents/overview)：beta、访问、架构、ZDR/BAA。
- [A2 Scheduled deployments](https://platform.claude.com/docs/en/managed-agents/scheduled-deployments)：cron、timezone、jitter、run记录与上限。
- [A3 Memory](https://platform.claude.com/docs/en/managed-agents/memory)：版本化记忆、容量、访问控制与同步。
- [A4 Define outcomes](https://platform.claude.com/docs/en/managed-agents/define-outcomes)：rubric、独立上下文grader与迭代。
- [A5 Budgets](https://platform.claude.com/docs/en/managed-agents/budgets)：list cost、金额单位、阈值与超额边界。
- [A6 Permission policies](https://platform.claude.com/docs/en/managed-agents/permission-policies)：工具默认权限、auto与custom边界。
- [A7 Vaults](https://platform.claude.com/docs/en/managed-agents/vaults)：MCP、出站secret替换、host/header/body与兼容性。
- [A8 Multiagent orchestration](https://platform.claude.com/docs/en/managed-agents/multiagent-orchestration)：共享环境、thread/roster上限与版本固定。
- [A9 Self-hosted sandboxes](https://platform.claude.com/docs/en/managed-agents/self-hosted-sandboxes)：worker、自托管内网与memory同步。
- [A10 Self-hosted security](https://platform.claude.com/docs/en/managed-agents/self-hosted-sandboxes-security)：责任分界与本地只读副本限制。
- [A11 Pricing](https://platform.claude.com/docs/en/about-claude/pricing#claude-managed-agents-pricing)：$0.08/running session-hour与token/搜索计费。
- [A12 Events and streaming](https://platform.claude.com/docs/en/managed-agents/events-and-streaming)：事件恢复、预览、30天sandbox窗口与usage。
- [A13 Session operations](https://platform.claude.com/docs/en/managed-agents/session-operations)：idle/terminated与删除语义。
- [A14 Cloud sandbox reference](https://platform.claude.com/docs/en/managed-agents/cloud-sandboxes-reference)：预装工具与规格。
