# OpenAI Agents API 与 Claude Managed Agents：托管 Agent 运行平台比较

> 研究日期：2026-09-15，Asia/Shanghai。
> 方法：核对两家官方公告、产品指南、定价与安全文档；本文涉及的服务均未进行付费API实测，未验证具体账户的地区资格、配额、性能或SLA。
> 口径：把“官方文档支持”“本次未找到直接对应接口”“研究判断”分开；不把普通模型API、Agent SDK或历史营销页的能力自动算到新托管API上。

## 一、先给结论

**两家都在把 Agent 的运行系统做成服务：不只返回模型答案，而是负责持续调用模型、使用工具、管理上下文、保存会话并协调工作。**

- **OpenAI Agents API**：2026年9月10日宣布公开beta，核心是把 **Codex harness** 作为托管API开放。优势方向是现成的Codex运行循环、自动上下文压缩、工具搜索、程序化工具调用、多Agent，以及OpenAI托管/自托管/伙伴沙箱之间的选择。[O1–O3]
- **Claude Managed Agents**：Anthropic的托管Agent服务，当前仍为beta；文档已明确提供 **原生定时部署、版本化跨会话记忆、Outcome独立上下文评审、会话预算、权限策略与Vault**。对周期性知识工作，它提供的配套模块更齐全。[A1–A8]
- **不能据此宣布谁“更聪明、更稳定或更便宜”**：本次没有同任务评测；运行系统、所选模型、工具质量和业务验收是不同问题。
- **针对已有OpenClaw或自有多Agent系统，建议先接成可替换执行端，而不是整体搬家**：自己的控制层继续掌握任务状态、审批、资料、产物验收、幂等发布和投递。

## 二、到底在比较哪一层

| 层次 | OpenAI | Anthropic | 主要责任 |
|---|---|---|---|
| 模型接口 | Responses API等 | Messages API | 应用决定循环、工具执行、状态和恢复 |
| 自行运行的Agent框架 | Agents SDK | Claude Agent SDK | SDK提供框架；运行部署责任仍需自行承担 |
| 本文比较的托管服务 | **Agents API** | **Claude Managed Agents** | 厂商运行harness与会话；执行环境可托管或自管 |

Agents API不是Agents SDK改名；Managed Agents也不是把Claude Code订阅通过HTTP包装。两家托管产品的参数、事件、定价和数据政策，都应按各自文档判断。

一个通俗类比：

- 模型API：请一位专家回答问题。
- Agent SDK：给你一套组织专家工作的程序框架。
- 托管Agent API：连“持续工作的运行系统”一起租用，但你的公司仍要定义权限、检查成果并对业务动作负责。

### 两家的共同架构

```text
你的产品 / OpenClaw / 企业工作流
        │ 下发任务、审批、接收事件
        ▼
厂商托管 Harness + 模型调用 + 会话状态
        │
        ├── 内置工具、MCP、自定义函数
        └── 执行环境：厂商沙箱 / 自己的基础设施
        │
        ▼
你的验收、制品归档、发布与投递系统
```

**自托管执行环境不等于私有化模型或控制面。** 工具输入输出依然会进入厂商运行系统；接入内部网络也不等于数据不离开内部网络。[O3,O7,A9,A10]

## 三、核心能力比较

| 维度 | OpenAI Agents API | Claude Managed Agents |
|---|---|---|
| 当前状态 | Public beta | Beta；API账号默认开放，部分能力另有限定preview |
| 核心运行系统 | OpenAI托管Codex harness | Anthropic托管可配置harness |
| 原语 | Agent / Environment / Session / Events与Items | Agent / Environment / Session / Events |
| 执行环境 | `none`、`openai_hosted`、`self_hosted` | `cloud`、`self_hosted` |
| 长任务与上下文 | 持久session、自动compaction、继续/引导工作 | 持久session、compaction、继续/中断、临时错误重调度 |
| 工具 | MCP、functions、web search、tool search、programmatic tool calling、文件/命令工具 | Bash、文件操作、web search/fetch、MCP、custom tools |
| 多Agent | 原生支持；默认最多6个并发子Agent，不含协调者，可配置 | 原生coordinator；最多20种roster、25个并发thread，advisor有例外 |
| 跨会话记忆 | 本次已读Agents API指南与目录中，未找到与memory stores直接对应的原生产品接口；可自己通过工具/存储实现 | Memory stores：可跨session复用、版本审计、只读/读写控制 |
| 原生定时 | 本次未核到直接对应scheduled deployments的接口；可用自己的调度器创建session | Deployments API支持cron与时区，每次创建session |
| 结果评审 | 需自建或接外部验收；不把Agents SDK/其他产品的评测能力自动等同本API | Outcome + rubric + 独立上下文grader，支持反馈迭代 |
| 会话花费上限 | 本次未核到与Claude session budget直接等价的接口，不能只凭普通账户预算推断 | 创建时设置session budget，达到阈值暂停新模型调用 |
| 秘密管理 | Vault用于由OpenAI服务发起的MCP连接；环境端凭据另管 | MCP Vault；云沙箱环境变量支持opaque placeholder出站替换 |
| 观测 | SSE、webhooks、items/turns、平台trace；beta不支持外部trace exporter | SSE、webhooks、完整持久事件、thread/outcome/usage相关事件 |
| ZDR | 当前不支持；文档限定美国data residency | 当前不支持；Managed Agents也无HIPAA BAA覆盖 |

表中的“未核到”是**本次文档证据边界，不是断言厂商绝无此能力**。存储文件、保存session、自动compaction也不等于带治理的跨会话长期记忆。[O2–O12,A1–A11]

## 四、OpenAI：把Codex运行系统变成通用执行服务

### 4.1 不局限于写代码

Codex harness虽然来自编码Agent，但官方示例包括事故调查、Slack工作助手、数据分析、GitHub问题调查和文档审阅。实际价值是让模型可以持续运用工具和文件完成任务，而不是只能生成代码。[O1,O2]

### 4.2 三种执行模式带来组合空间

- `none`：不提供自己的Linux工作区；可调用远程MCP和应用functions。适合工具驱动的流程，不强迫每个任务开完整沙箱。
- `openai_hosted`：OpenAI准备Linux环境；可预装packages、初始文件、setup commands、skills和plugins。
- `self_hosted`：自己管理环境与executor，适合私网、定制镜像和特殊计算资源；官方列有E2B、Modal、Daytona、Cloudflare等伙伴集成。

伙伴能提供不同CPU/GPU、VPC或存储配置，**不代表OpenAI默认沙箱就具备所有这些规格**。[O1,O3,O6]

### 4.3 工具效率是重要设计点

- 自动compaction：降低自己实现长上下文维护的负担；不能理解成无损无限记忆。
- Tool search：按需载入工具定义，避免每轮把所有工具描述塞入prompt。
- Programmatic tool calling：通过代码并行、串联、过滤工具结果，减少无必要内容进入模型上下文；不是一台完整Node/Linux机器的替代。
- 原生subagents：由harness提供创建、通信、等待与中断工具，不必自己搭最基础的委派循环。[O1,O4]

### 4.4 多Agent有一个直接影响接入的限制

**子Agent目前不支持function tools。** 它们继承配置的MCP、凭据与web search，可访问共同环境中的文件/命令工具。若已有业务能力全做成应用function工具，不能假定每个子Agent都能直接使用；应考虑让协调者调用，或设计适当的MCP/执行端包装。[O4]

协调者与子Agent共享环境文件系统；新增子Agent不新增安全隔离边界。默认并发6是默认值，不是公布的硬最大并发配额。

### 4.5 运维能力仍有明确边界

- SSE不补发错过的事件。重连时先开流并缓冲，再获取session和items，按item ID重建状态。
- `idle`或关闭stream不是成功；`turn.completed`也不代表所有工具成功。
- 自托管环境在输入时等待连接最多5分钟；超时的输入不会因稍后重连自动重放。中途断连不自动重启被杀命令，也不会自动发重连请求webhook。
- 重用environment ID不会自动还原替换机器上的文件；持久卷/快照需要自己负责。
- 详细trace可在平台看，但公共beta不提供外部trace exporter或受支持的详细trace读取API。usage是best effort，可能为空或后补，不是最终账单。[O5,O7,O11]

## 五、Anthropic：把周期性Agent工作的配套也纳入平台

### 5.1 原生定时不只是“能后台运行”

Scheduled deployments提供POSIX五段cron和IANA时区，每次触发建立session；可以为每次执行配置预算。

但它不是精确计时器：官方允许按间隔最高15%的抖动，抖动窗口下限5秒、上限9分钟。deployment run的成功只代表成功启动，不代表报告写完或邮件投递成功。每组织最多1000个scheduled deployments。[A2]

对周报、日报、定期检查很实用；对秒级交易或精确时间承诺不应直接使用这套语义。

### 5.2 长期记忆被做成可审计资源

Memory stores是一组带路径的文本文件，可通过API维护，挂载到session供工具读写，每次修改形成不可变版本。

- 每session最多8个store。
- 每store最多10000条memory，每条上限100kB。
- 公共规范/资料宜只读；用户或项目记忆可按需要独立分配读写权限。
- 默认读写存在跨会话提示注入污染风险，不能把模型写下的内容自动视为事实。
- self-hosted需SDK worker同步；CLI worker不挂载memory。自托管只读模式阻止上传，但不保证bash无法改变本地副本。[A3,A9,A10]

这是“可维护的长期知识资源”，但不是模型自动可靠地学习了所有经验。

### 5.3 Outcome把“做完”变成可表达的目标

用户给出rubric，平台以独立上下文grader检查产物，把反馈交给执行Agent迭代。[A4]

例如：研究报告每条关键结论是否有来源、Excel是否包含指定sheet、结果文件是否符合schema。

其价值在于减少自己搭评审循环的工程量，但**独立上下文不是独立事实来源**：grader仍可能漏错。对计算、数据准确性、真实发布和合规动作，仍需程序测试与外部凭证。

### 5.4 预算、审批与Vault更明确，但不是全自动保险

- 权限策略支持`always_allow`、`always_ask`、`auto`；内置agent toolset默认allow，MCP默认ask。
- `auto`可能直接放行，不是人工审批。custom tools不受这些策略管理，应用必须自行做授权和审批。
- session budget按公开list cost限制新模型请求。金额是**美分整数字符串**，`"125"`表示$1.25。
- cap检查发生在请求之间，进行中的请求仍会完成；多thread下可能各有一次请求的超额，不是精确到分的断电开关。
- budget要在创建时设置；不能给原本无预算的session中途新增。移除后不能重新添加。[A5,A6]

云环境变量Vault以占位符出站替换真实secret，可限定目标host及header/body位置。它不适用于需在本地用secret计算签名的客户端，也不保证换取的新token返回沙箱时被遮蔽；environment_variable Vault当前不支持self-hosted。[A7]

### 5.5 多Agent是上下文分工，不是权限分区

每个thread有自己的上下文、工具配置与会话历史，可继续给同一个子Agent追加工作；但共享sandbox、filesystem和session vault credentials。

coordinator只能委派一层，roster最多20种Agent，最多25个并发thread（advisor thread有例外）。需要自己避免文件并发覆盖，并且不能把上下文隔离当成租户隔离。[A8]

## 六、成本：不能只比“每小时”或“API免费”

### 6.1 OpenAI

官方公告说 **Agents API本身无额外管理费**；不是执行免费。总成本通常为：

```text
模型tokens（主Agent + 子Agent + 重试 + 压缩等实际调用）
+ 工具费用
+ OpenAI沙箱费用，或自有/第三方执行环境费用
+ 其他外部服务费用
```

官方hosted环境指南引用标准container定价；当前价格表为：

| 内存规格 | 公布的每container / 每20分钟session价格 |
|---|---:|
| 1 GiB | $0.03 |
| 4 GiB | $0.12 |
| 16 GiB | $0.48 |
| 64 GiB | $1.92 |

**必须保留的计费不确定性**：同一价格页另注明“符合条件的container sessions按分钟计费，最少5分钟”。本次未核清具体Agents sandbox适用资格，也没有由文档证明上表每个规格都能在该API中选择；不能把价格表直接推导为任何Agent任务的确定小时价。[O6,O12]

主Agent及子Agentusage可能后补；缓存写入也可能收费而usage未单列计数。必须最终对账单，不以观测字段冒充准确计费。[O11]

### 6.2 Anthropic

当前官方价格为：

**模型tokens + $0.08 / running session-hour + 搜索等相关费用。**

- runtime按毫秒计，仅`running`计费；`idle`、`rescheduling`、`terminated`不计这项费用。
- 不另外叠加code-execution container-hour。
- 多thread重叠的session运行时间只算一次，但各thread的tokens仍分别收费。
- Web search $10/1000次；缓存按所选模型政策处理。
- 托管session不适用Messages Batch折扣。[A11,A5]

举例：4小时running产生的**runtime项**为$0.32；不代表一份4小时研究报告只花$0.32。

### 6.3 正确的比较指标

应比较：

> **每份通过同一验收标准的任务总成本**，以及成功率、人工介入时间和P95交付时延。

不同模型单价不能自动转换为不同平台性价比。更好的模型可能减少轮次，更完整的平台可能节约开发运维，更多子Agent也可能带来更高tokens与合并成本；都需要同任务实测。

## 七、最容易被营销表述遮住的六个坑

### 1. 持久会话 ≠ 永久沙箱

OpenAI-hosted文档：连接中的沙箱接收keep-alive，包括轮次之间；活动与keep-alive都停止1小时后，沙箱可删除。它不是“用户一小时没说话必删”。`/workspace/outputs`在turn完成时发布的不可变产物可在沙箱过期后下载。[O6]

Anthropic文档：会话历史保留至删除；cloud sandbox从创建日起只保留30天，活动不延长窗口。重要产物要输出并归档，不要把沙箱当长期资料库。[A12]

两者语义不同，不能简单用“1小时 vs 30天”给可靠性打分。

### 2. 能恢复运行 ≠ 外部动作只发生一次

发送邮件、创建工单、修改数据库后，回传结果可能丢失。重试时应先查真实结果，保存任务ID、调用ID、产物ID与副作用凭证。OpenAI function文档明确要求持久保存结果；同样的工程原则也适用于Claude custom tools。[O9]

### 3. 多Agent独立上下文 ≠ 安全隔离

两家同session中的多Agent都可能共享文件系统和凭据能力。不同用户/租户需要真正分离的session与执行环境，而非只换system prompt。

### 4. 工具由厂商执行 ≠ 授权由厂商替你负责

Claude custom tools由应用授权；OpenAI functions由应用处理。高风险动作必须有应用层准入和审批。工具返回、网页、文档都可能含恶意指令，不能让它们取得与用户授权同等地位。

### 5. self-hosted ≠ ZDR

OpenAI Agents API当前仅美国data residency且不支持ZDR；选择self-hosted不会改变这一点。Claude Managed Agents也不适用ZDR及HIPAA BAA。严格合规场景需逐端点与合同确认，不能把基础模型API的资格直接套用。[O2,A1]

### 6. 云端agent完成 ≠ 用户收到成果

状态里“成功”只解决局部问题。还需要产物存在、文件可读、数据正确、外部发布成功、渠道回执等证据。不要以`idle`、流关闭、部署run成功或某次grader通过替代最终业务验收。

## 八、怎么选，以及对现有系统的意义

| 场景 | 建议 | 理由与保留条件 |
|---|---|---|
| 希望快速复用Codex运行方式，重点是代码/文件/工具密集任务 | 先评估OpenAI Agents API | harness与沙箱组合清晰，工具搜索/PTC值得测；不代表质量必胜 |
| 周报、运营研究、周期检查，需要定时+记忆+评审+预算 | 先评估Claude Managed Agents | 当前原生配套更完整；审批和业务验收仍自行掌握 |
| 多模型、复杂权限、已有成熟OpenClaw/工作流 | 保留自己的控制层，两家都做可替换执行端 | 不把用户状态、资产和交付全锁进厂商session |
| 只需简短一次性调用、步骤完全固定 | 优先考虑基础模型API | 不一定值得引入完整托管Agent状态模型 |
| 必须ZDR/严格数据本地化 | 不直接选本次两项托管服务 | 单独评估合规端点、合同、自管harness与可用模型 |

建议架构：

```text
统一任务入口 / OpenClaw
        │
        ├── 自有任务账本、租户权限、审批、预算和最终期限
        │
        ├── OpenAI Agents执行适配器
        ├── Claude Managed Agents执行适配器
        └── 原有本地/其他模型执行器
        │
        └── 统一产物校验 → 资料库 → 幂等发布 → 渠道投递与回执
```

这是一项架构建议，**不是宣称当前OpenClaw已开箱支持两者的新API**。模型provider兼容也不等于支持托管session/事件/制品协议，需要单独适配与验收。

### 商业判断

两家正在把通用循环、压缩、沙箱和基础委派做成商品。仅靠“封装prompt并能调用几个工具”的产品差异会缩小。

更持久的应用价值在于：行业数据、工作流权限、可信结果验收、业务系统集成、失败恢复、审计与跨供应商交付。这个判断来自能力边界，不是对任何厂商未来市场份额的预测。

## 九、建议的小型POC：先测任务交付，不先做全量迁移

此处为下一步建议，本次未实际创建或运行。

1. **固定三类任务**：带来源的研究摘要；文档/表格结构化产物；带人工审批的模拟外部动作。用公开或合成数据，真实发布关闭。
2. **定义共同验收**：来源真实性、字段/数值正确、文件可打开、失败有记录、审批前无副作用。
3. **测试故障**：客户端SSE断连；自托管executor断连；工具超时；结果已执行但回执丢失；需要输入时暂停；预算或期限到达。
4. **记录指标**：验收成功率、全任务tokens/工具/沙箱账单、总耗时/P95、人工介入次数、重复副作用次数、恢复后是否丢失文件。
5. **决定迁移范围**：只在验收通过且总成本/维护负担确实改善的任务上替换执行器；保留回退路线。

小样本POC用于发现集成问题，不足以证明总体稳定性。并发配额、账户资格、真实计费颗粒度、最长运行时间与SLA仍需生产前核实。

## 十、官方来源

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

### 取证与未验证事项

本次以取到的官方正文为依据；OpenAI部分方法reference链接读取失败，不据此虚构方法或缺失能力。Anthropic部分产品博客仅取得标题，未用其营销数字证明性能。没有复现示例、运行付费任务或证明任何账户已可调用。所有选型倾向都是基于当前接口与责任范围的研究判断，尚不是性能或成本排名。
