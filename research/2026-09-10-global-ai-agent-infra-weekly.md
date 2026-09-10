# 全球AI Agent基础设施周报｜2026-09-03—09-09

研究窗口：上海2026-09-03 00:00至09-09 24:00；UTC [2026-09-02T16:00:00Z,2026-09-09T16:00:00Z)。采集与补验截至2026-09-10。窗口按事件时间而非检索时间判定；代码合入、版本发布、文档更新、preview与托管GA分别标记。当前文档仅为采集日能力快照，不自动代表窗口内上线。厂商测试和收益主张均归因原文，未独立生产复现。

## 总结与TOP5：控制面的责任边界正在成为产品契约

本期最值得注意的不是又出现一种万能Agent循环，而是异步、恢复、授权、网络和记忆操作开始拥有可以检查的状态与失败语义。按对Harness基础设施格局的信号价值，而非新闻热度，TOP5如下：

1. **OpenAI异步工具与mid-turn steering、LangChain适配及Microsoft恢复契约**：provider开始吸收Harness控制原语，但后台作业、断线重放、审批归属仍由应用负责。价值是API契约改变了分工，不是模型代管所有执行。详见模块1。
2. **恢复正确性成为控制层的共同重点**：OpenClaw把升级候选验证放在停机之前；Anthropic不再让未恢复文件的rewind返回成功；ADK即使无新消息也持久化state_delta；Microsoft按具体调用保存审批与OAuth。共同价值是用确定性证据判断恢复，而不是用回复正常替代状态正确。详见模块1/2。
3. **工具和身份网关从“连得上”走向“明确允许哪一步”**：Google9/8将VPC出口做成Connectivity Template；社区Gateway1.30.0拒绝把MCP wildcard继承为REST写权限；Arcade把授权前移但不取消逐调用检查。身份、consent、网络和动作授权仍是不同边界。详见模块4/5。
4. **记忆层进入可组合摄取和治理阶段**：AWS9/8 IngestData不创建短期event也可提取长期记忆；OpenViking/Cognee等加强安全边界；Letta把常驻上下文预算变成Git提交门禁。差异不只是召回质量，还包括租户隔离、来源回取、写入与迁移失败语义。详见模块6。
5. **可观测从追踪日志推进到可重复评估闭环**：Braintrust9/3 public preview的Patterns/Debugger/Loop，Langfuse历史回填和导出freshness，Phoenix跨工具轨迹导入及Coze Loop实验配置说明，竞争焦点转向能否保留真实调用参数、可靠回放并验证修复。不是统一标准已GA，也没有独立证据证明通用故障率改善。详见模块7。

Google9/9沙箱GA、双Registry及VPC-SC增强确有官方日期条目，但缺时刻/时区，未确认在UTC9/9 16:00前，故不进入严格窗内TOP5。AWS Consent Portal及TypeScript evaluation只有月级日期，作为能力背景而非本周首发。

## 1. Harness / Agent OS控制层

### 本周模块结论

- 模型协议开始承接异步工具、中途纠偏和配置更新；框架必须保存call、approval、history的真实归属，而不是只增加模型名称。
- 控制面自己的升级、文件恢复和无消息状态恢复成为可验收事务；版本存在不等于每个托管环境已经部署。
- 数据平台的优势体现为有效数据权限和再授权边界，而非另一个Agent模板。

### 固定对象状态

|对象|窗口状态与主要来源|深写边界|
|---|---|---|
|OpenClaw|[v2026.9.3](https://github.com/openclaw/openclaw/releases/tag/v2026.9.3)，实际9/8发布|开源稳定版及升级PR；非托管GA|
|OpenAI Agents SDK/Responses|[async tools](https://developers.openai.com/api/docs/guides/async-tool-calling)、[steering](https://developers.openai.com/api/docs/guides/steering)，9/3；SDK9/8、9/9|客户端仍负责执行与恢复|
|Anthropic Agent SDK/MCP|TS0.3.259/260/265初发均窗内；Python0.2.152为CLI更新|SDK深写；MCP/Computer Use另见模块3/4|
|LangChain/LangGraph/LangSmith|langchain-openai1.6.1于9/8初发；所查LangGraph release旧；LangSmith Cloud跨窗|适配器深写；不能说全平台静默|
|Google ADK|[state_delta patch](https://github.com/google/adk-python/commit/6de43b05a07f8ca89909664b3a21049646d7336c.patch)，9/9|代码合入；未确认进稳定包或云端|
|Microsoft AF/Semantic Kernel/AutoGen|[AF Python1.17.0](https://github.com/microsoft/agent-framework/releases/tag/python-1.17.0)，9/3|SK推荐迁移AF、AutoGen maintenance为当前README背景，非本周迁移公告|
|Databricks Mosaic AI/Agent Bricks|[9月月报](https://docs.databricks.com/aws/en/release-notes/product/2026/september)，9/8 ABAC DENY Beta|通用数据治理底座，详见模块8；非Agent runtime全面升级|

### OpenClaw：把升级本身当作可恢复事务

稳定版`v2026.9.3`实际`published_at=2026-09-08T14:15:53Z`，即上海9/8 22:15:53；版本名称的9/3不是发布日期。`updated_at=9/8 19:18:34Z`又是另一字段。发布概要包括候选环境验证、升级恢复、跨工作区agent-owned Skill Workshop、持久session及有界递归委派；核心深度依据为PR #138839，而不是声称已完整读遍巨型release。

PR将候选包/Git代码的stage、lint、配置/插件检查、隔离SQLite快照canary移到旧Gateway仍在服务的阶段；同版本/同SHA no-op不停止服务，停机窗口收窄到swap、受管迁移与start。保留旧包和launcher直至完成验证；记录版本/build、插件、channel、readiness、advisory inference、停机与失败账本。激活后验证真实服务及ownership readiness，不能以文件恢复成功等同于恢复在线。

这不是零停机或万能回滚：仅在配置/状态schema不变时可恢复旧代际；新schema需要候选代码负责finalization。原生包共享项目的兄弟组件若已变化，会拒绝回滚，保留候选与备份并记录`rollback-project-changed`；插件维护可能形成第二停机窗口。较旧降级目标没有新migration continuation worker时，不获得新schema-neutral回滚保证。Windows等平台专项补偿和测试不等于跨平台生产SLA；独立并发升级准入仍需审慎验证。维护者不同阶段的测试数量与耗时不拼成统一性能结论。

**判断与OpenClaw参照**：Agent OS的差异化是控制面自身也有可审计、可验证、可恢复的变更边界。应验收真实Gateway readiness、版本代际、失败账本与回滚条件，跨工作区技能迁移先证明归属和可恢复性；不能用LLM修复替代确定性schema检查。

来源：[单tag API](https://api.github.com/repos/openclaw/openclaw/releases/tags/v2026.9.3)、[升级PR #138839](https://github.com/openclaw/openclaw/pull/138839)、[技能归属线索PR #135528](https://api.github.com/repos/openclaw/openclaw/pulls/135528)。最后一项仅概要定位，不据此扩展新能力保证。

### OpenAI：异步、中途转向与成本诊断进入API契约

官方[changelog](https://platform.openai.com/docs/changelog)9/3列出GPT-6 Astra的Responses异步工具、mid-turn steering及会话中修改reasoning effort；9/8将Prompt Cache Diagnostics列为GA。异步指南规定function/custom tool可设`async:true`，模型不必等结果即可继续；实际工具由客户应用执行，OpenAI不接管执行或客户后台作业。结果沿原`call_id`返回，应用提供的`wait_for_tasks`是自定义同步工具，不是内建调度器。支持GPT-6 Astra及后续模型，不适用hosted built-in tools，不应与programmatic tool calling组合；multi-agent mode不可和parallel tool calls混用。

steering仅GPT-6 Astra和Responses WebSocket；收到`response.created`后在同连接发送`response.steer`，`previous_response_id`指向正在运行的response。`response.steer.accepted`只说明排队，不代表执行；服务器完成当前output item和已运行hosted工具后才自动续答。原response可因`incomplete_details.reason:"steered"`结束，也可能先正常完成；续答按每个response分别计token/tool限制。已启动工具不取消，动作不回滚，旧输出不重写。

若还需客户端工具结果或approval，队列继续等待；`response.steer.pending.required_input`说明所需内容。按原response ID回传结果，不重复已accepted的steer；显式`response.create`使用自身tools/instructions等设置。用`steer.id`关联后续失败，`response.steer.failed`表示不会自动应用。队列仅在当前连接，不随原response持久化；断线须保存输入、核对事件与历史后再决定重放，不能盲目重发。

Python Agents SDK [v0.22.1](https://github.com/openai/openai-agents-python/releases/tag/v0.22.1)9/8 09:18Z新增MCP server-wide guardrails、Unix-local环境隔离配置，修复序列化审批归属、compaction期间并发写入及恢复session写失败；[v0.22.2](https://api.github.com/repos/openai/openai-agents-python/releases/tags/v0.22.2)9/9 12:36:10Z修复UnixLocal文件API symlink race及pop后compaction response chain重置。SDK发行不等于所有托管能力GA。

Cache Diagnostics以`prompt_cache_options.comparison_response_id`比较，返回`tools_changed`、`input_changed`等首个分类原因，适用于GPT-5.6及后续受支持模型。它不加载旧会话、不改变缓存行为；best-effort、诊断记录短期过期。官方称功能无额外费用且兼容ZDR，但额外测试请求正常计费；diagnostic token估计不是账单，应读usage核对实际命中/费用。未独立验证成本收益。

**判断与参照**：provider正在吸收Harness原语，但持久化、后台执行、幂等和授权仍归应用。OpenClaw可接入新协议，必须共同持久化call_id、steer id、原审批归属及会话写入结果，不得把provider accepted当任务完成。

来源：[异步全文](https://developers.openai.com/api/docs/guides/async-tool-calling)、[steering全文](https://developers.openai.com/api/docs/guides/steering)、[cache diagnostics](https://developers.openai.com/api/docs/guides/prompt-caching/diagnostics)。

### Anthropic：无人值守fail-closed，回滚报告必须与实物一致

TypeScript SDK v0.3.259加入`permissionPrompts:'none'`，无人接收权限弹窗时自动拒绝，但不关闭auto mode分类器；`user_message_uuids`与单数UUID并存，标识一次回复覆盖多条合并消息。v0.3.260修复`managedSettings`的`disableAutoMode:"disable"`被restrictive-only过滤器丢弃；`rewindFiles()`在checkpoint备份缺失、没有文件可恢复时改为失败，不再虚报成功。另有thinking_tokens消息关联UUID，`first_content_frame_ms`、`first_stream_post_ms`、`first_stream_post_ack_ms`、`first_stream_post_wall_ms`远端延迟分解字段；结构化输出重试耗尽附最后tool error，并指出key、允许值和实际长度/数量；重复429期间约每限流窗口30秒重新发rate_limit_event，避免消费者状态陈旧。

v0.3.265补齐synthetic turn、resume自行开始的turn及无API请求的slash command成功结果UUID；每次所回答消息改变后的首帧都会更新归属，而非每turn仅一次。Agent执行的`cd`跨turn保留，不再每条消息重置为初始`cwd`。单tag API确认三者初次published_at分别为2026-09-02T22:33:48Z、09-03T23:48:13Z、09-08T20:37:33Z，均在上海周窗内；不是从Atom updated推定。

Python v0.2.152于9/2 22:48:51Z发布，仅bundled CLI至2.1.259；TS0.3.266于9/8 23:55:30Z初发，仅Code parity。TS0.3.267于9/9 19:58:41Z越窗，SSE追赶/systemPrompt snapshot不纳本期。

**判断与参照**：消息UUID连接UI、日志、账单及恢复归属，cwd是显式跨轮状态；无人审批策略和文件回滚实物验证，比更大的自动权限更重要。OpenClaw可建立一对多消息映射与无接收者审批策略。以上是SDK修复，不是托管runtime、MCP或Computer Use全面GA，无独立事故率/可靠性收益数据。

来源：[0.3.259](https://api.github.com/repos/anthropics/claude-agent-sdk-typescript/releases/tags/v0.3.259)、[0.3.260](https://api.github.com/repos/anthropics/claude-agent-sdk-typescript/releases/tags/v0.3.260)、[0.3.265](https://api.github.com/repos/anthropics/claude-agent-sdk-typescript/releases/tags/v0.3.265)、[Python0.2.152](https://github.com/anthropics/claude-agent-sdk-python/releases/tag/v0.2.152)、[TS日期入口](https://api.github.com/repos/anthropics/claude-agent-sdk-typescript/releases?per_page=1&page=2)。

### LangChain/LangGraph/LangSmith：承接提供方状态协议，不能偷换云端周更日期

`langchain-openai==1.6.1`支持async tools（#40208）与`configuration_update`（#40201），修复OpenAI3.8环境Azure AD认证（#40190），将`gpt-5.6-sol`路由到Responses。单tag API确认初发2026-09-08T14:20:40Z，updated为14:20:42Z。1.6.2对GPT-6 Astra reasoning effort的支持于9/9 21:22Z发布，越窗排除。

所查LangGraph SDK0.4.4（8/27）和0.4.3（8/19）是旧release，只说明该入口未见窗内新版，不代表整仓或云端静默。LangSmith Cloud“August31–September7”周更跨窗，单条无发布日期：MCP连接器Client ID Metadata Documents、OAuth会话`owner_type/owner_id`与workspace owner、Gateway fallback保留认证上下文、dataset export同时要求read/download权限，均作为跨窗候选而非严格本周新发。`langchain.mcp`1.4.0a2 alpha缺日期，不纳本期；LangSmith自托管制品另见模块7。

**判断与参照**：统一adapter接入异步协议不等于后台生命周期、幂等、审批及trace因果已托管。OpenClaw应把provider能力探测与运行契约分开，只在确定性事件持久化后改变状态；未做跨provider一致性实验，不称实测兼容性提升。

来源：[1.6.1单tag API](https://api.github.com/repos/langchain-ai/langchain/releases/tags/langchain-openai%3D%3D1.6.1)、[release全文](https://github.com/langchain-ai/langchain/releases/tag/langchain-openai%3D%3D1.6.1)、[LangGraph发行入口](https://api.github.com/repos/langchain-ai/langgraph/releases?per_page=2)、[LangSmith Cloud日志](https://docs.langchain.com/langsmith/changelog)。

### Google ADK：无新消息恢复也要持久化state_delta

提交`6de43b05a07f8ca89909664b3a21049646d7336c`的committer时间为9/9 05:56:08Z，patch作者时间05:55:22Z；二者不是冲突。修复通过`invocation_id`恢复、不传`new_message`时调用者`state_delta`被忽略。新增`_append_state_delta_event()`构造无content的`Event(author='user',actions=EventActions(state_delta=...))`，继承isolation scope、run-config metadata和branch context，经session service `append_event`持久化；普通Runner和workflow node runner都覆盖。`yield_user_message`只控制是否向外yield，不决定state是否写入。

patch包含普通agent、LLM agent和workflow两种yield设置测试，验证resumed_key存在，LLM无content增量事件branch为None；未独立运行测试，不承诺所有session后端已通过。所见release v1.39.1（8/27）、v2.8.0（8/26）均旧，故为窗内代码合入、未确认正式包或Vertex部署。

**判断与参照**：审批、外部状态或管理员纠偏可能不伴随用户消息。状态和聊天解耦并保留scope/branch/metadata，才有事件日志驱动的恢复。OpenClaw应测试无新消息、仅状态变化、前端不展示事件时持久化仍正确，而非看模型输出是否正常。

来源：[完整patch](https://github.com/google/adk-python/commit/6de43b05a07f8ca89909664b3a21049646d7336c.patch)、[窗口commit元数据](https://api.github.com/repos/google/adk-python/commits?since=2026-09-02T16:00:00Z&until=2026-09-09T16:00:00Z&per_page=2)。

### Microsoft：审批、OAuth与history所有者进入稳定版本契约

Python1.17.0于9/3发布。Foundry-hosting明确由Agent Server或agent拥有model history，避免双重conversation replay；审批绑定稳定function-call occurrence并保留legacy兼容；有效OAuth consent responses持久化并在恢复中还原；workflow-as-agent恢复审批时保留client tools和request correlation。provider refusal跨history/replay/hosting/UI保留marked text，并行function结果不丢，compaction mutation跨tool loop保存，Responses续答/媒体schema对齐。

sequence-only middleware inputs恢复、删除experimental agent-hooks core extra为BREAKING；共享chat client只在同event-loop的并发契约下使用，不能推定跨loop安全。支持OpenAI SDK3.x不降低既有支持下限，Mistral客户端迁官方SDK；底层MCP初始化失败即使被取消掩盖也需呈现。DevUI保留message边界、多模态、实测usage和stream response ID；转换保存falsey结果、JSON-safe参数、shell limits及replay metadata。Foundry-hosted Telegram sample是样例，不证明Hosted Agents、Copilot Studio或M365 SDK同期全面GA。

**判断与参照**：微软在框架和托管接缝处统一最容易丢的授权与历史。OpenClaw应将许可绑定一次具体调用而非工具名/会话泛授权，区分历史所有者并在恢复时保存用户意图，防重复副作用。没有独立生产故障率/采用数据，不量化可靠性改善。

来源：[完整release](https://github.com/microsoft/agent-framework/releases/tag/python-1.17.0)、[Semantic Kernel README](https://raw.githubusercontent.com/microsoft/semantic-kernel/main/README.md)、[AutoGen README](https://raw.githubusercontent.com/microsoft/autogen/main/README.md)。后两者仅当前迁移/maintenance背景。

### 模块洞察

控制层正在标准化“恢复后属于谁、实际完成什么、权限是否仍有效”，不是标准化万能循环；状态事件、审批归属和副作用验证，比工具数量更能形成长期可靠性。

## 2. Runtime / Session / State执行层

### 本周模块结论与固定对象状态

本周确认的托管执行信号集中于E2B、Daytona；OpenClaw有代码及稳定版本活动。云厂Runtime的新发没有被全部证实，Google9/9边界待核、Microsoft仅文档更新时间、国内部分入口核验受限，不能据此说云厂没有更新。

|对象|本周状态|主要来源/深写|
|---|---|---|
|AWS AgentCore Runtime|未确认窗内产品新发；现状背景|[Runtime原理](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-how-it-works.html)|
|Google Agent Engine/Managed Agents|9/9pause/resume周界待核；Managed Agents本体首发未证|[管理沙箱](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/manage-sandboxes)、[Managed Agents](https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents)|
|Microsoft Hosted Agents|9/8文档updated而非功能首发|[hosted](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents)、[resilience](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/long-running-agent-resilience)|
|百炼/PAI|所查应用/PAI日志未确认窗内runtime事件|[百炼](https://help.aliyun.com/zh/model-studio/application-release-notes)、[PAI](https://help.aliyun.com/zh/pai/product-overview/feature-release-notes)|
|Ark/Coze|正文失败/壳，核验受限而非静默|[Ark公告入口](https://www.volcengine.com/docs/82379/1159177)、[Coze日志入口](https://www.coze.cn/open/docs/guides/changelog)|
|元器/CloudBase|未确认窗内发布，不能将分发与serverless后端混称runtime|[CloudBase概述](https://cloud.tencent.com/document/product/876/46894)、[元器](https://yuanqi.tencent.com/)|
|OpenClaw session/cron|版本9/8，合并/代码活动；cron新发未单独证实|[PR140840](https://github.com/openclaw/openclaw/pull/140840)、[session](https://docs.openclaw.ai/concepts/session)|
|E2B|9/7Workspaces rollout、恢复正确性、Cursor worker|[周更](https://docs.e2b.dev/changelog)、[workspace](https://docs.e2b.dev/workspaces)|
|Daytona|9/3 0.210.0、9/8 0.211.2|[日志](https://www.daytona.io/changelog)|
|Modal|所见SDK最新1.5.5为8/28，窗内未确认|[SDK releases](https://modal.com/docs/sdk/py/releases)|

### E2B：恢复正确性、Cursor隔离worker与组织权限

9/7官方周更宣布Workspaces开始rollout，不是全量GA。API key仍归project，既有project ID、keys、templates、sandboxes、volumes和计费不改；workspace成员能访问全部project，只需单项目权限应加到project而非workspace。当前同project成员权限相同，workspace统一账单仍是roadmap，不能称已有细粒度RBAC或统一计费。

Cursor集成把agent loop留在Cursor云侧，每请求分配E2B独立worker sandbox；需Cursor Enterprise开启Self-Hosted Machines并使用service-account API key，个人/管理员key不能起worker。worker默认hibernate、闲置pause、后续消息resume；dispatcher必须运行，Cursor排队流量不能唤醒暂停的dispatcher。默认20个并发worker，更多请求在Cursor排队；私库token经egress proxy供应，不写worker。这是工具执行面外置，不是完整推理控制面迁到客户环境。

Python SDK2.46.4把单sandbox命令/文件流分到默认4个连接池，缓解单连接HTTP/2流上限，不是算力或API配额增加；`E2B_ENVD_POOL_SHARDS`需import前设置。`network.httpsPorts`跨pause/resume保留，恢复后误用root、暂停前日志丢失、pause途中进程退出误报失败获修复。关联PR有Draft/merged状态获取不足，出货依据采用9/7官方周更而不是9/1开PR日期。

**判断与参照**：长期执行的可信度取决于恢复UID、最后日志、TLS端口和dispatcher真实唤醒来源，不只resume速度；OpenClaw接入workspace时须防止跨项目权限放大。这些是官方版本/能力证据，不是全服务SLA。

来源：[9/7周更](https://docs.e2b.dev/changelog)、[Workspaces全文](https://docs.e2b.dev/workspaces)、[Cursor全文](https://docs.e2b.dev/agents/cursor)、[SDK PR1793](https://github.com/e2b-dev/E2B/pull/1793)、[infra变更](https://github.com/e2b-dev/infra/commit/b5f419a2b122f8ff881497681bde0d109cbbf0fe)。后二者仅辅助，不能把截断diff称全文。

### Daytona：上传可靠性与端点配置破坏性变更

官方索引将0.210.0列为9/3、0.211.2列为9/8。0.210.0新增API client的MI355X GPU类型，并改善Python SDK S3上传可靠性；枚举字段不证明所有region有可用GPU或资源GA。0.211.2对Go/Python/Ruby构建context做multipart流式上传，修复CLI archive路径/COPY source解析，遵循文档SSH命令格式，TypeScript遇stale连接重试。

重要breaking change是Python/Ruby/TypeScript SDK不再从`.env`/`.env.local`解析`DAYTONA_API_URL`、`DAYTONA_SERVER_URL`，需用进程环境或constructor `api_url`。依赖项目dotenv切换公有/私有环境的部署可能落到错误默认端点或连接失败；应在空进程环境和真实worker镜像中验证，而非仅本地shell。重试不是exactly-once，也未保证所有调用幂等。

**参照**：OpenClaw环境adapter启动诊断应显示脱敏后的实际URL、配置来源与SDK版本，升级验收覆盖上传/COPY语义，不只create sandbox成功。

来源：[日期索引](https://www.daytona.io/changelog)、[0.211.2全文](https://www.daytona.io/changelog/streamed-context-uploads-and-cli-ssh-format-fixes)、[0.210.0全文](https://www.daytona.io/changelog/mi355x-gpu-type-and-python-sdk-s3-upload-reliability)。

### OpenClaw：降低事件循环阻塞，不能把快照、活性和投递混为完成

v2026.9.3发布日已确认9/8。release概要包含cold session减阻、memory检索启动优化和worker build重用。PR #141141的9/7活动与Merged支持cloud runtime preparation变动；#140730减少隔离vector-search子进程重复启动，统一私有host入口仍保留SQLite/sqlite-vec/text helpers、取消及索引发布语义。作者86.3%来自特定native-child对照，不是Gateway或cron整体提速。

#140840将cold durable preparation和commit reopen放入现有writer queue的异步数据库准入，排队前捕获环境、state root和物理database path，防止排队期间环境改变导致维护交给错误owner。schema、retention、公开RPC形状不改；作者承认冷操作总耗时可能增加，以换取较短event-loop连续停顿，并非普遍低延迟。该PR网页未含合并时刻，只按release关联说明采用，不另报精确合并日。

当前cron设计是Gateway进程内自动化，schedule、run state/history在SQLite；Gateway不运行就不能准时触发。browser/process/MCP teardown为best-effort；失败/不明的必需投递保留disabled job供检查，不重新放送payload。超时先abort并清理ownership；startup catch-up和lost-task reconciliation不能以会话记录存在判断活性。session区分`sessionStartedAt/lastInteractionAt/updatedAt`，cron/heartbeat bookkeeping不延长用户idle freshness。此段是现行设计背景，未以滚动文档冒充本周cron新发。

**参照**：执行所有权、输出完成、投递确认及外部副作用分别落账；“有最后一条消息”不是绿灯。应把阻塞时长与完成耗时分开测。

来源：[141141](https://github.com/openclaw/openclaw/pull/141141)、[140730](https://github.com/openclaw/openclaw/pull/140730)、[140840](https://github.com/openclaw/openclaw/pull/140840)、[cron原理](https://docs.openclaw.ai/automation/cron-jobs/how-it-works)、[session](https://docs.openclaw.ai/concepts/session)。

### 云端Runtime的现状边界（背景，不是本周首发）

**AWS**每session独立microVM隔离CPU/内存/文件，最长8小时、页面给出空闲终止15分钟；终止销毁VM并清内存，同`runtimeSessionId`再次调用是新环境而非恢复旧进程。持久上下文需另接存储。配置更新产生不可变版本，DEFAULT endpoint自动转新版本，生产固定版本应使用受控endpoint；支持HTTP/MCP/A2A/双向WebSocket，不赋予异步任务无限生命周期或持久工作流语义。[来源](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-how-it-works.html)

**Google**pause释放compute但保留文件系统、sandbox ID、连接metadata和PSC端点；STATE_PAUSED数据面返回错误，resume完成才可用；配置变更需删建，管理需要`roles/aiplatform.user`。这不保留应用内存/栈，不是所有长任务无损续跑；“秒级恢复”“更便宜”为官方定性说法，无实测SLA/账单。Managed Agents由Agents API配置/挂源/网络allowlist，Interactions API执行；每agent隔离sandbox，默认无外网、系统或凭证访问，须开发者开启并供最小权限凭证。其GA/preview未从本次概述确证，不随9/9其他沙箱GA一并升级。[生命周期](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/manage-sandboxes)、[Managed Agents](https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/managed-agents)

**Microsoft**Hosted Agents `updated_at=9/8 17:20Z`，但ms.date仍8/19，只证明文档更新。自带容器/框架，每session VM隔离，$HOME与/files跨idle持久；Responses平台管conversation，Invocations应用自管。长任务resilience明确preview无SLA：background只解除HTTP连接生命期限制，恢复依赖持久work/input identity、落盘、lease回收及handler从头重入，不保存局部变量/调用栈，也非确定性回放。只有stored background responses显式resilient才有完整crash恢复，foreground不自动重调；checkpoint、副作用幂等、清理由应用负责，流cursor回放不是workflow checkpoint。[hosted](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents)、[resilience](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/long-running-agent-resilience)

**阿里**所查百炼应用日志最新明列2月，1/15工作流异步、2025高代码均旧；PAI最新可见7/21 DSW MCP Server化，6/30 AgentBox/Agentic Readiness V1.0、2/26 DSW部署OpenClaw均窗外。模型上下架、开发机和应用托管不能混为runtime升级。**火山/Coze**官方公告、Ark入口和团队文档提取失败，Coze日志为标题壳，故为核验受限；不可承诺PAI/Ark/Coze能无缝替换session/cron/browser。[百炼](https://help.aliyun.com/zh/model-studio/application-release-notes)、[PAI](https://help.aliyun.com/zh/pai/product-overview/feature-release-notes)、[Ark](https://docs.volcengine.com/docs/82379/1099503?lang=zh)、[扣子团队](https://www.volcengine.com/docs/84458/1529727)

**腾讯**CloudBase概述更新于4/21，提供数据库、认证、云函数、云托管、存储，云函数SSE/Streamable支持Agent应用，但AI coding/MCP/Skills不证明逐次执行强隔离浏览器或微VM pause/resume。元器可读内容是分发列表，无窗口日期与生命周期证据；同属腾讯不代表共用runtime。[CloudBase](https://cloud.tencent.com/document/product/876/46894)、[元器](https://yuanqi.tencent.com/)

**Modal**所查SDK1.5.5（8/28）Sandbox.logs只存entrypoint日志、可fetch/tail而不stream；1.5.4（8/12）`MODAL_SANDBOX_V2=1`是新backend opt-in，旧FileIO filesystem不兼容，计划1.6.0默认开启。均非本周；changelog空页/旧日志只能支持有限未发现结论。[SDK](https://modal.com/docs/sdk/py/releases)、[日志](https://modal.com/changelog)

### 模块洞察

长任务的标准件正在从“异步执行”细化为计算租约、状态持久化、恢复粒度、所有权和投递证据；文件回来、输出重放、handler重入与业务只执行一次是四个不同验收项。

## 3. Sandbox / Computer Use / Browser执行环境层

### 本周模块结论与固定对象状态

模型支持Computer Use不等于获得托管桌面；sandbox平台维护的是隔离执行、恢复正确性和网络/权限边界。E2B/Daytona的窗内变化见模块2；Google9/9官方GA内容明确但上海周界仍待核。

|对象|窗口判定|证据/边界|
|---|---|---|
|E2B|9/7有料|恢复UID/日志/TLS与SDK连接池，不是统一SLA|
|Browserbase/Stagehand|未取到可核日期；背景|[changelog](https://www.browserbase.com/changelog)、[缓存博客](https://www.browserbase.com/blog/stagehand-caching)|
|Daytona|9/3、9/8有料|上传、API类型和端点配置见模块2|
|Modal|未确认窗内新增|旧SDK/backend背景见模块2|
|OpenAI Computer Use/Code Interpreter|9/3新模型工具兼容事件|[模型卡](https://developers.openai.com/api/docs/models/gpt-6-astra)，非桌面GA|
|Anthropic Computer Use|未确认本周新发|[指南](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool)，客户端执行|
|AWS Browser/Code Interpreter|未确认本周产品新发|[Browser](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html)、[Interpreter](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html)|
|Azure Browser/Code Interpreter/Playwright|背景/preview按单项判定|[Browser quickstart](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/browser-automation-hosted-agent-quickstart)|
|Google Code Execution/Managed Sandbox|9/9日期周界待核|[release notes](https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes)|

### OpenAI与Anthropic：工具协议和执行环境由不同主体负责

OpenAI9/3发布的`gpt-6-astra`模型卡在Responses列computer_use/code_interpreter/hosted_shell，属于新模型进入工具栈，不是通用托管桌面新GA。当前Computer Use指南要求开发者提供环境，应用执行模型请求并回传截图/结果；可用Playwright/PyAutoGUI等code execution或结构化computer工具，当前建议Astra用前者但仍支持后者，指南无新发日不能说建议本周才改变。

工具需Responses；模型也能用Chat Completions不代表同样工具都可用。`reasoning.effort=none`、自定义temperature/top_p、logprobs不支持，旧client透传可能失败。任务应维持同一浏览器/桌面session，隔离浏览器不继承host环境变量。async tools/steering是控制协议，不是sandbox pause/resume；不能因模型升级放松敏感写操作确认。模型卡唯一列出alias/snapshot为gpt-6-astra，不编造日期版本。

Anthropic当前`computer_toolset_20260801`为17个member tools的客户端toolset，环境由开发者控制，当前不在Claude Managed Agents提供。Claude API/Google Cloud支持该toolset，其他平台仍限较早beta工具，不能全平台统称GA。版本名日期不是已证发布日；9/3可见Platform条目为ant CLI1.30.0 resources-as-code及Google Cloud mid-conversation effort beta，并非Computer Use新发，9/1模型更新也不纳本周。

**参照**：OpenClaw应分开模型adapter与环境adapter，code支持不等于任意host shell适宜直连；UI动作、截图、会话存活与用户确认分别验收。

来源：[OpenAI模型卡](https://developers.openai.com/api/docs/models/gpt-6-astra)、[API日志](https://developers.openai.com/api/docs/changelog)、[Computer Use指南](https://developers.openai.com/api/docs/guides/tools-computer-use)、[集成边界](https://developers.openai.com/api/docs/guides/tools-computer-use-integration)、[Claude工具指南](https://platform.claude.com/docs/en/agents-and-tools/tool-use/computer-use-tool)、[Claude日志](https://platform.claude.com/docs/en/release-notes/overview)。长指南只采用已核区块，不声称整站全文。

### Google：浏览器/Shell与企业边界打包，仍须保留周界和配置限定

官方9/9条目称Computer Use/Shell GA，同批pause/resume、VPC-SC、PSC、CMEK；具体时区未提供，因此本期只列日期边界待核。Computer Use在容器浏览器执行导航/点击/输入/截图，支持API、CDP/Playwright及VNC观察。Shell用`/exec`，不能调用Python Code Execution的`send_command()/execute_code()`；示例helper为`client.sandboxes.execute_bash`。无sudo的appuser、每次新shell、cwd及shell变量不自动跨调用保持，应通过/workspace文件存状态；默认网络关闭，迁移需适配stdout/stderr/returncode。

PSC私有入口仅同consumer project；VPC-SC保护资源不提供request/response logging；出网仍需NAT、防火墙或Secure Web Proxy。CMEK仅父Agent Platform实例创建时设置、同区域单region key；可轮转同key版本，换key须重建；覆盖根文件系统和snapshot，不覆盖resource metadata、环境变量及service-account email。撤销key权限会阻断provision/resume/snapshot写。配置示例v1beta1不推翻产品公告GA，SDK vertexai/agentplatform命名混用需锁版本验证。

**判断**：云厂争夺独立sandbox企业执行面，但网络隔离、密钥控制不等于业务授权，也不代表全部metadata客户密钥加密。OpenClaw跨后端adapter应显式呈现状态粒度、网络和恢复失败条件。

来源：[Computer Use](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/computer-use)、[Shell](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/shell-sandbox-quickstart)、[VPC-SC](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/configure-vpc-sc)、[CMEK](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale/sandbox/configure-cmek)。9/2deferred tier 50%折扣也缺左边界时刻，不纳本周。

### AWS与Microsoft：浏览器录制和资源权限不是默认附赠

AWS默认`aws.browser.v1`与custom Browser不同：session默认15分钟、最长8小时，WebSocket Automation可接Playwright/Strands/Nova Act，Live View可实时观察/人工交互；只有custom Browser支持记录DOM变化、用户动作、控制台/网络事件到客户S3。会话TTL结束即终止，不是默认所有浏览器都录像。Code Interpreter支持Python/JavaScript/TypeScript，默认15分钟、最长8小时；inline上传100MB，终端命令至S3最高5GB是不同通道，不应合成一个API限额。网络模式/执行角色可配置，“安全隔离”不是任意代码无风险或已获业务授权。[Browser](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html)、[Interpreter](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html)

Microsoft浏览器quickstart要求独立Playwright Workspace、resource ID和wss endpoint，再部署container Hosted Agent；需Playwright Workspace Contributor角色。文中“project managed identity”与在agent Identity查看object ID的步骤有歧义，实施须核对实际主体而非任意授予。preview按标记能力处理，不把所有Foundry一概preview。Browser/Code Interpreter主文档均8/24更新，前者隔离Playwright，后者sandbox Python；未从扫描扩大语言/时长/网络承诺。[quickstart](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/browser-automation-hosted-agent-quickstart)、[Browser](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/browser-automation)、[Code Interpreter](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/code-interpreter)

### Browserbase/Stagehand：缓存是经过验证的动作重用，不是记忆或durability

changelog可见Functions webhook pending/running/completed/failed、Context命名、Stagehand v4服务端缓存控制，但日期丢失，不认定本周发布。v4文档所见act/observe/extract服务端缓存需Browserbase browser/API key，本地browser cache选项不生效，model config不入key。

完整缓存博客却链接v3，描述project作用域、selector/prompt/action配置、DOM校验及48小时TTL，并把model config归一化哈希；因此TTL与model config语义不能移植成v4保证。博客“最高约80%加速”是同动作先写再读缓存的两次运行，不是全任务SLA或新网页普遍收益。DOM/URL漂移应miss后回退模型，不能硬复用selector；Functions webhook也不证明durability/exactly-once。

**参照**：缓存键隔离project/account/session，命中仍验证页面与授权；动作缓存、模型prompt cache、conversation记忆、文件snapshot和stream replay解决不同问题。

来源：[v4缓存](https://docs.stagehand.dev/v4/best-practices/caching)、[v3关联缓存博客](https://www.browserbase.com/blog/stagehand-caching)、[changelog](https://www.browserbase.com/changelog)。

### 模块洞察

执行环境正在商品化，但可移植性取决于最小权限、恢复粒度、网络默认值和可观测证据；“支持Computer Use”不能替代对实际运行环境的安全验收。

## 4. Tool Gateway / Protocol / Integration工具层

### 本周模块结论与对象状态

网关从MCP工具目录扩展到推理、HTTP与A2A，真正难点是协议间权限语义、出网路径与升级默认值；统一endpoint不是统一业务授权。

|对象|本周状态|主要证据/深写|
|---|---|---|
|MCP/官方Registry|Registry当前preview；本周commit核验不足|[Registry about](https://modelcontextprotocol.io/registry/about)|
|A2A|Google/AWS/社区网关可转发背景；独立协议新发未证|各网关原文，不能从转发推定语义授权等价|
|Composio|9/4竞争文章窗内；非新功能发行|[比较文章](https://composio.dev/content/composio-vs-pipedream)|
|Arcade|9/2 16:00Z恰在左界，bundled pre-authorization|[发布原文](https://www.arcade.dev/blog/pre-authorize-agent-tools/)|
|Nango|9/3 Audit trail；Agent sessions9/2日期边界待核|[日志](https://nango.dev/docs/updates/changelog.md)|
|Pipedream Connect|背景，未确认窗内首发|[MCP](https://pipedream.com/docs/connect/mcp)、[Connect Link](https://pipedream.com/docs/connect/managed-auth/connect-link)|
|AWS Gateway|当前多协议托管背景，未证本周首发|[Gateway](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html)|
|Google Gateway|9/8 Connectivity Template确认；9/9增强待核|[release](https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes)|
|Microsoft Toolbox/MCP端点|Foundry当前能力背景，无本周独立新发证据|[overview](https://learn.microsoft.com/en-us/azure/foundry/agents/overview)|
|社区MCP Gateway & Registry|1.30.0于9/9 03:38:18Z初发|[单tag API](https://api.github.com/repos/agentic-community/mcp-gateway-registry/releases/tags/1.30.0)|
|OpenAI/Anthropic MCP|本周独立MCP新增未确认，见下文边界|官方Tunnel/connector文档|

### Google：把出口路由变为Agent控制面资源

9/8的`agentConnectivityTemplate`用`egressNetworkConfig.networkAttachment`引用PSC attachment，以`vpcEgress`区分默认PRIVATE_RANGES_ONLY和ALL_TRAFFIC。默认仅指定私网地址段进入VPC，Internet流量不经企业VPC；ALL_TRAFFIC把公网/非RFC1918也送入VPC，客户负责默认路由、安全设备和通常必要的Cloud NAT。模板还含`accessPath:AGENT_TO_ANYWHERE`；单Gateway子网至少/28，多实例扩大地址池，attachment字段配置后不可变。网络attachment与DNS peering目标须同VPC；DNS只配明确域后缀，不应根域/通配/googleapis.com兜底。Shared VPC/跨project需要provisioning identity和Gateway service agent分别具备network/DNS权限，不是给agent业务权限就足够。

当前overview支持HTTP/MCP/A2A过网关，但仅MCP有属性解析及tool name细粒度策略；A2A转发不等于同级语义授权。Gemini Enterprise仅支持egress，ingress不受相同IAM/IAP管控。官方9/9另列最多两Registry（一global加一regional/multi-region）及VPC-SC，当前配置要求Connectivity Template设ALL_TRAFFIC；无时刻/时区，不纳严格本周新发，更不能把全部安全套件算到9/8。

**判断与参照**：企业竞争转向每条出口走哪里、谁负责路由和授权，代价是跨project角色与网络配置成为发布依赖。OpenClaw应把工具allowlist/审批、workload身份和强制出口路径分别验收，不以连接成功证明数据边界达标。

来源：[配置全文](https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/set-up-vpc-connectivity)、[Gateway overview](https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview)、[日期条目](https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes)。

### 社区Gateway1.30.0与官方Registry：协议扩张不应隐式扩权

agentic-community的1.30.0“The Gateway for Any Resource: Inference, MCP, A2A, and REST”初发为2026-09-09T03:38:18Z，API已区分created/published/updated。它将MCP入口扩到推理、A2A、REST；generic proxy默认关闭，不能说升级即自动启用所有代理。

#1732说明MCP `methods:["all"]`不能转换成HTTP DELETE/PUT等权限，二者属于不同授权命名空间；管理员原只有MCP wildcard会导致通用代理403，因此registry-admins显式获HTTP verbs，普通组保持跨协议不提权。#1697在公网listener阻断`/api/internal/*`，将原可被public `/api/`兜底路由的egress-token等内部路径隔离，运维转用户JWT管理接口；这是关闭网络路径，不是由此证明新业务授权洞被修。部分讨论在8/31，作为本版收录的升级边界，而非每条代码都首次发生于本周。扫描失败自动禁用依赖toggle_service权限，说明有扫描器不等于失败时必然隔离。

metrics迁移也会制造假健康：`target_kind`由unknown改generic_proxy_skill/agent/custom，server持实体authz key而非gateway，success统一小写true/false，旧True查询可能返回空值而非错误；duration指标不再携server标签，按target_kind分组。服务启动成功不能替代dashboard/报警升级验收。原文测试均维护者自述。

官方MCP Registry是另一个项目，about页当前preview，可能破坏性变更/数据重置；存server.json元数据并指向npm/PyPI/Docker，不托管代码。GitHub/域名验证只证明命名空间控制，不证明代码安全；扫描交上游包注册表/下游aggregator。官方目录不支持仅私网/私有包仓库服务，企业应实现兼容OpenAPI接口；官方代码并非面向自托管设计，fork运维自担。host宜消费策展目录；本周commit提取不足不能说无提交。

**参照**：OpenClaw动态工具分为发现、可安装、向模型暴露、执行写入四种状态；跨协议默认拒绝wildcard继承，审核与注册失败可见，命名空间验证不能代替依赖安全和运行许可。

来源：[1.30.0](https://github.com/agentic-community/mcp-gateway-registry/releases/tag/1.30.0)、[HTTP verbs PR](https://github.com/agentic-community/mcp-gateway-registry/pull/1732)、[内部listener PR](https://github.com/agentic-community/mcp-gateway-registry/pull/1697)、[官方Registry](https://modelcontextprotocol.io/registry/about)。

### Composio与Pipedream：竞争叙事必须与对方原文对照

Composio9/4 00:00Z比较文章把自己定位为Agent action infrastructure：少数meta tools动态发现、读schema、管理连接、执行；Tool Router按已连接账户路由，统一OAuth refresh、限流退避/重试和结构化输出。`COMPOSIO_MANAGE_CONNECTIONS`可生成Connect Link，用户完成OAuth后平台持有凭证，同用户同toolkit支持多账户；官方称每调用集中审计。以上是本周公开竞争说明，不证明功能均9/4首发。

其将Pipedream说成只能dashboard预授权、不能动态连接的线性工作流产品，但Pipedream Connect Link原文支持按终端用户生成连接链接，MCP支持应用代表用户执行。因此“不支持会话中授权”不采纳。Composio调用量、成功率、tool总数、价格缺独立双源，不作胜负/采用指标，也不混同页不同目录口径。

Pipedream按应用提供MCP server，个人连自己账户或嵌入应用代表用户；凭证加密、服务器执行，官方称不直接暴露给模型/客户端，用户可撤销。Connect Link绑定特定终端用户，4小时过期，无需自建授权前端；4小时是链接寿命，不是第三方access/refresh token TTL。文档未说明每次API写入是否单独批准、撤销对在途请求传播或审计完整性，不能扩展承诺。

**判断与参照**：独立执行平台把API/schema/OAuth维护成本外移，却引入托管凭证、目录和运行记录依赖。OpenClaw须把发现、连接、执行分层，凭证留模型外，多账户显式选择；逐工具验参数、scope、错误恢复、幂等键和重试关联，不用managed OAuth替代高风险写入批准。

来源：[Composio全文](https://composio.dev/content/composio-vs-pipedream)、[Pipedream MCP全文](https://pipedream.com/docs/connect/mcp)、[Connect Link全文](https://pipedream.com/docs/connect/managed-auth/connect-link)。

### OpenAI Tunnel与Anthropic connector：私网可达、schema加载和授权是不同层

OpenAI Secure MCP Tunnel由私网主机主动出站HTTPS长轮询，本地client转发MCP JSON-RPC，无需私有服务开公网入站；支持stdio/HTTP后端和可选控制面/后端mTLS。但OAuth授权服务器不会自动一同隧道化，仍须可达。组织Tunnels Read/Manage/Use与ChatGPT workspace developer-mode权限独立，个人Platform组织绑定不会自动出现企业workspace。

tunnel-client0.0.14的Atom updated=9/2 00:16:48Z早于左界，作为窗外背景。其正文说MCP2026-07-28无会话请求能力在该tag前已落地，本版验证多副本OAuth/Harpoon，不能归为无会话首发；startup HMAC一致只证明启动目录一致，不证明副本健康、同时轮询/共享状态/动态收敛。跨origin redirect/转发头收紧，support archive额外header secret脱敏是维护者说明。Harpoon只允许管理员配置目标/HTTP方法，非用户任意主机代理。

Tunnel元数据创建/修改/删除有Platform audit，但传输请求、控制面鉴权、长轮询不成为ChatGPT Compliance app事件；应用调用与关联/解除日志仍走应用路径。“有合规日志”不是全传输审计。

Anthropic远程MCP connector当前beta标识`mcp-client-2025-11-20`，支持Claude API、Claude Platform on AWS、Microsoft Foundry，不适用Amazon Bedrock/Google Cloud。仅tool calls，后端须公开HTTPS，SSE/Streamable HTTP而非本地stdio；`mcp_servers`连服务，`mcp_toolset`暴露工具。默认enabled=true，仅denylist会自动允许未来新增工具；最小权限宜default_config.enabled=false后显式启用。未知工具名只warning不error，拼错denylist不能由请求成功排除风险；defer_loading是schema进入上下文时机，不是授权。

OAuth access token由调用方事先授权/自行刷新，authorization_token不等于平台代管全生命周期；connector不被ZDR覆盖，工具定义/结果遵循标准留存。SDK helpers能自行管stdio/prompts/resources再转API，与平台connector范围不同。本周9/3 ant apply/per-message effort不能借作MCP新发。

来源：[Secure Tunnel](https://developers.openai.com/api/docs/guides/secure-mcp-tunnels)、[0.0.14](https://github.com/openai/tunnel-client/releases/tag/v0.0.14)、[Anthropic connector](https://platform.claude.com/docs/en/agents-and-tools/mcp-connector)。

### MCP Skills：扩展协议与客户端信任规则不能仅靠“MCP兼容”概括

Arcade9/8文章（JSON-LD9/8 16:00Z，上海9/9）讨论Skills Over MCP，属于本周生态观点而不是MCP核心版本发布。固定SHA的SEP2640标Accepted、Extensions Track、Created4/23，接受/合并时刻未核，不能据此宣称本周正式标准新发；文章称写作时尚未合并，与固定规范状态属于不同证据快照，采用规范状态但不猜时序。官方release feed所见首条为7月；A2A feed所见v1.0.1为5月更新，均未证本周独立新版。[MCP release入口](https://github.com/modelcontextprotocol/modelcontextprotocol/releases.atom)、[A2A release入口](https://github.com/a2aproject/A2A/releases.atom)

规范复用Resources传输SKILL.md目录，skills/list、skills/get发现/取元数据，可选resources/directory/read导航、resources/read取文件；URI scheme本身不证明是skill，需目录/明确引用经get确认。skills/list可为空或部分，不代表服务没有skill；嵌套SKILL.md普通读取是内容，独立激活须新用户同意，父skill批准不覆盖子skill。Arcade指出手册随工具分发、渐进披露和manifest hash帮助一致性，但远程内容仍不可信，摘要/哈希不替代来源、用户批准或业务授权；能读resources不等于完整激活/信任模型。

其对OpenAI8/26提交期snapshot与实时server updates的对比为厂商对他方实现的分析，本文未另核客户端文档，不把所列各家容量限制写成事实或迁移承诺。对OpenClaw，应区分传输、安装、激活、自动更新及allowed-tools批准；技能分发不能改变既有执行授权边界。

来源：[Arcade全文](https://www.arcade.dev/blog/skills-over-mcp-explained/)、[固定版本SEP](https://raw.githubusercontent.com/modelcontextprotocol/modelcontextprotocol/d6b31a03504c15677d49b922b6b6ace0ef65728d/docs/seps/2640-skills-extension.mdx)。规范只核相关前部，未将长规范全篇计精读。

### AWS、Microsoft与国内工具入口（背景）

AWS Gateway可由OpenAPI/Smithy/Lambda生成工具，passthrough接HTTP/A2A，模型推理统一路由；入站验证agent、出站处理OAuth/refresh/凭证注入。语义工具选择降低schema负担，不等于业务资源授权；“only solution/省数周”等无独立证据不采用。Registry GA在8月，不算本周。Microsoft Toolbox集中MCP端点/版本/认证，须和Foundry实际部署/身份区分，未证本周新增。[AWS](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html)、[Foundry](https://learn.microsoft.com/en-us/azure/foundry/agents/overview)

阿里AI网关MCP支持原生代理/HTTP转换/Nacos同步，消费者认证默认关闭且该授权路径仅API Key；启用而无授权关系则不可访问。不能将后端Basic/Bearer/API Key误作前端OAuth。Nacos需MSE铂金3.0+、网关引擎2.1.6+；长连接升级可能重建。[MCP管理](https://help.aliyun.com/zh/api-gateway/ai-gateway/getting-started/mcp-service-management)

腾讯MCP广场8/13文档为背景，Local本机注入SecretId/SecretKey或token，Hosted填写KEY/TOKEN后产生用户专属SSE URL；URL路径带token应按凭证保护，不能进普通日志/截图/转发。暂无第三方MCP上架与更新服务不等于平台停服；Local样例autoApprove空数组不代表全平台审批保证，TTL/轮换/撤销/双主体审计未证。火山两个官方MCP入口提取失败，导航里的API Key/HMAC/OAuth2名称不证明适用于MCP或本周新发。[腾讯](https://cloud.tencent.com/document/product/1212/123193)、[火山失败入口](https://www.volcengine.com/docs/6569/1816086)

### 模块洞察

工具连接在商品化，差异化移向协议语义、动态发现审核、凭证代理与审计覆盖；目录不是认证，网络接通不是授权，重试不是幂等。

## 5. Identity / Auth / Permission权限层

### 本周模块结论与固定对象状态

consent前移可减少无人值守中断，但不能免除逐动作授权。必须分开身份验证、用户consent、网络可达、工具许可和资源权限；认证证明谁，不证明这次动作应当执行。

|对象|窗口状态|主要来源|
|---|---|---|
|AWS AgentCore Identity|9月门户公告，具体日未证；背景|[consent portal](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-consent-portal.html)|
|Microsoft Entra/Foundry identity|当前背景；9月候选正文403，不能判静默|[Agent identities](https://learn.microsoft.com/en-us/entra/agent-id/what-are-agent-identities)|
|Google Agent Identity/Gateway|Identity本体新发未证；9/8网络模板见模块4|[identity overview](https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/agent-identity-overview)|
|Arcade Auth|窗内bundled pre-authorization|[原文](https://www.arcade.dev/blog/pre-authorize-agent-tools/)|
|Composio Auth|9/4竞争说明，不是功能首发|模块4，原文与Pipedream交叉纠偏|
|Nango OAuth/token|9/3 Audit trail确认|[audit trail](https://nango.dev/docs/guides/platform/audit-trail)|
|Pipedream managed auth|背景，窗内新发未确认|模块4，Link TTL与token TTL分开|
|阿里/腾讯/火山|前两者背景；火山取证失败|国内身份边界见下文|

### Arcade：启动前聚合授权，而非永久免审

bundled pre-authorization在长任务开始前汇总预计工具scope，每服务一个approval link，例如多个Google工具合并一次Google授权，不是所有服务共用一链接。页面显示美国9/2，但JSON-LD `datePublished=2026-09-02T16:00:00.000Z`恰为上海左界，应纳入。执行时仍按用户、资源、许可逐调用检查：认证、OAuth consent、动作policy三层不能混为“登录一次全部可用”。

价值在把授权从中途报错后补救前移到计划阶段，减少用户不在时空转。原文没有token TTL、撤销传播、失败回滚、计划工具集改变的精确API行为；最小权限主张仍受第三方OAuth粗scope限制，无独立攻击测试。配套“approve foundation once”强调统一runtime/policy/audit，匿名银行案例、成功率与成本无独立第二源，不采用数字，也不能一次平台审核后永久免审新工具/高风险写入。

**参照**：OpenClaw启动前列授权清单、按服务聚合consent，运行中继续逐调用检查；不靠关闭审批或扩大长期权限消除中断。

来源：[产品全文](https://www.arcade.dev/blog/pre-authorize-agent-tools/)、[治理观点全文](https://www.arcade.dev/blog/approve-once-scale-every-agent/)。

### Nango：控制面可追责加强，执行数据面仍需另接日志

9/3 Audit trail记录connection变更、integration设置、团队角色/登录，含actor/action/resource/outcome并覆盖所有environment。一般不记读取，读取connection credentials、读/删sync records、/proxy和POST /action/trigger不在本日志；`connection.metadata_updated`、`sync.triggered`从dashboard发起记录，对应API视数据面不记录。不能称所有Agent工具已有不可变全链审计。

官方称保留期内条目不可改删，默认1年、Enterprise plan；CSV最多50,000条，超量下载成功但提示截断。actor包括dashboard user、api_key、connect_session终端用户、anonymous、legacy public_key；support session以via标记但operator仅内部ID，客户要询问真人对应。secret剥离降低二次泄露风险，不弥补数据面盲点；未独立验证不可变存储实施。

9/2 Agent sessions public beta只有日期，左界待核，作为背景：backend设tenant/toolset/discovery后发独立MCP URL与session bearer token；session不可扩展，终止后401但不取消在途调用。默认toolset含已解析连接全部工具，宜显式最小化；nango_proxy默认关，开启可访问该integration任意endpoint，不受toolset path限制。Agent不能改自身scope不等于绝无扩大调用面；当前Agent不能为未连integration主动请用户连接。

**参照**：OpenClaw分开连接/角色配置日志与每次工具执行日志，导出必须展示截断标志，不能以下载成功判断证据完整。

来源：[日期日志](https://nango.dev/docs/updates/changelog.md)、[Audit trail全文](https://nango.dev/docs/guides/platform/audit-trail)、[Agent sessions全文](https://nango.dev/docs/guides/agent-sessions)。

### Google与AWS：身份、凭证代理与用户委托的组合限定

Google Identity当前每agent有SPIFFE唯一身份、自动轮换X.509证书，而非默认复用service account；Google API token与证书绑定，经Gateway用DPoP。Auth Manager分别管API key、2-legged机器OAuth和3-legged用户委托，三种权限来源不同；用户模式有登录/consent/撤销，IAM管谁访问Auth Manager，审计可同时记用户与agent。**只有与Agent Gateway、Gemini Enterprise共同使用的组合**，终端用户凭证由Auth Manager加密、网关解密，agent不接触原始凭证；不能外推任意runtime/集成。删除agent不删IAM binding，需清inactive grants；同名重建resource ID不同，不继承旧授权。tool name/read-only policy、Model Armor/VPC-SC另配，不是身份认证自带，也未经本次攻击复现。[来源](https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/agent-identity-overview)

AWS managed consent portal的9月公告全文可核，具体日仍未证。每门户绑定一个Gateway，OAuth在server端完成、浏览器不持token；管理员可会话前分享URL，用户自查连接，解决3LO callback及部分IDE不能展示consent/绑定session的问题。Gateway须JWT inbound，主IdP须OIDC且发JWT access token，portal OAuth2 provider与authorizer同issuer、scope含openid；GitHub/Slack/Salesforce可作出站OAuth目标，却不能以OAuth-only身份作门户主IdP。execution role还需读网关/凭证配置和OAuth client secret，不能说无需身份架构。覆盖Identity支持的commercial regions，未证撤销对在途请求传播时限。不能宣称断连即取消全部动作。[公告](https://aws.amazon.com/about-aws/whats-new/2026/09/amazon-bedrock-agentcore/)、[portal](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-consent-portal.html)、[前置条件](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity-consent-portal-prerequisites.html)

### Microsoft与国内平台：身份归因、许可和实际用户不能被省略

Microsoft6/15更新的身份说明把agent视为Entra独立身份，区别人/一般workload；自主权限直接授予agent，委托访问按用户授权。兼容M365的某些场景可配一对一特殊user account，不等于复用人的密码/MFA。Copilot Studio创建者为sponsor，认证记录为AI Agent。基础Agent ID与高级安全/跨M365能力许可不同，后者涉及Agent365，不推定所有条件访问/治理免费，也不把避免孤儿权限当实测保证。9月Entra候选遭403，摘要“9月底rollout”不采纳。[身份全文](https://learn.microsoft.com/en-us/entra/agent-id/what-are-agent-identities)

阿里OpenAPI MCP Core可语义发现全云API，自定义版仅选定API，发现不等于授权。程序身份采用Agent绑定RAM角色/静态AK，与提问用户无关；须Agent层限制访问者，ActionTrail只记Agent RAM，端到端需关联调用者日志；用户OAuth才按实际用户权限执行。复用本地CLI凭证方便但引入隐含权限，宜最小RAM、轮换、不把AK进版本控制，官方建议不给模型删除资源API，不能为减少consent而使用主账号AK。Core宽发现与程序身份权限并集可能扩大误用面，应展示最终RAM主体而非只说MCP连接成功。[OpenAPI MCP](https://help.aliyun.com/zh/openapi/user-guide/openapi-mcp-server-guide)

腾讯Hosted SSE URL本身为敏感访问材料，token TTL/撤销/委托用户映射/scope/双主体日志均未获充分说明，不能从“专属URL、安全可靠”推导完整企业授权。火山MCP/AgentKit正文获取失败，API Key/HMAC/OAuth2导航名不作为能力事实，不能判静默。国内平台托管GA均不得从README或连接样例推导。

### WorkOS MCP Auth / Cross App Access：资源侧最终接受委托，而非直接复用企业登录token（背景）

WorkOS比较文章把Okta8/24、Auth08/31、Descope9/1归为CIMD识别调用软件、ID-JAG exchange表达企业用户委托的两层模式；所述发布全在窗外，文章自身首发日未提供，因此不是本周三厂新发。资源authorization server仍需验证issuer/claims/scope，决定是否签发自己的access token；不是把企业OIDC登录token直接当任意工具access token。身份厂商收敛是其分析，未独立核其客户数/安全覆盖百分比，不据此排名。

当前AuthKit为Authorization Server、MCP服务为Resource Server，PKCE S256及authorization_code/refresh_token；资源端验JWT签名/JWKS、issuer、audience，401带WWW-Authenticate resource_metadata以发现受保护资源元数据。CIMD默认关闭、DCR保兼容；Resource Indicator把endpoint设为aud，未配置则aud退为环境client ID，resource被忽略。可设默认Indicator供漏resource的CIMD/DCR客户端，显式resource仍校验；手工OAuth/M2M应用不用默认，旧refresh token授权的audience不自动变。

XAA为early access，Standalone MCP Auth不支持；Standalone保留现有登录、应用完成身份认证并调completion API，AuthKit处理consent/token，Login URI需external_auth_id。它不取消资源端工具参数policy或高风险写批准。OpenClaw接入时应区分身份token与授权token、软件client与被代表用户，资源侧接受委托才算链路完整。

来源：[比较全文](https://workos.com/blog/cross-app-access-converged-in-eight-days)、[官方MCP auth全文](https://workos.com/docs/authkit/mcp)。

### 安全验收与OpenClaw参照

至少分开记录调用者—Agent—凭证主体—tool/action—资源—审批/重试关联；OAuth/OIDC认证、token托管、scope、业务写许可、网络出口与审计覆盖分别验收。OpenClaw可参考双主体日志、模型外token broker、Agent下线同步清grant、默认deny与审批绑定具体调用。不得宣称已杜绝越权/泄漏；本文没有独立安全测试。

### 模块洞察

权限层的商业化不是“自动登录”，而是持续回答谁以何身份、在哪个scope、代表谁、对什么资源执行了哪一步；预授权与统一网关只减少交互成本，不消除授权和撤销责任。

## 6. Context / Memory / Knowledge记忆知识层

### 本周模块结论与固定对象状态

记忆层的标准化重点正在从add/search转向宿主生命周期、租户隔离、凭证、预算及证据回取。Context Database会调度后台加工任务，因而也必须承担Harness式执行授权与恢复责任；选择性长期记忆不是全量无损归档。

|对象|窗口状态|核心来源/边界|
|---|---|---|
|OpenViking|9/9 compile密钥隔离代码|[patch](https://github.com/volcengine/OpenViking/commit/f60a71d0030618488f5f32ccbdda56aa9b1ef0f7.patch)，非新GA|
|Mem0|9/8共享agent-plugin runtime与文档|[core](https://raw.githubusercontent.com/mem0ai/mem0/02f7a9b2c4fe38dedb96631e48c85c74ad58b605/integrations/agent-plugin-core/README.md)|
|Cognee|9/9 15:40:15Z，MCP transport安全修复|[PR4994](https://github.com/topoteretes/cognee/pull/4994)|
|supermemory|9/2 21:49:57Z跨space读取；9/7 19:56:46Z迁移|[读取patch](https://github.com/supermemoryai/supermemory/commit/4d8a4ebfddadc3430f7f59a752cd374670833f50.patch)、[迁移PR](https://github.com/supermemoryai/supermemory/pull/1651)|
|Letta|9/8 Letta Code MemFS/Teleport合入|[PR4185](https://github.com/letta-ai/letta-code/pull/4185)，非平台核心发行|
|Zep/Graphiti|Graphiti0.30.2版本及多租户/清理/查询修复|[release](https://github.com/getzep/graphiti/releases/tag/v0.30.2)，非Zep Cloud GA|
|Firecrawl|9/8 SDK版本触发、9/9可信内部流量限流|[版本patch](https://github.com/firecrawl/firecrawl/commit/f544d065ef9f8c2f3218599b09aaa22f942a04e8.patch)|
|Crawl4AI|所查入口无可核窗内新增，0.9.3日志8/31窗外|[release](https://github.com/unclecode/crawl4ai/releases/tag/v0.9.3)|
|TencentDB-Agent-Memory（热扫补入）|9/8 OpenCode适配；Team Memory Beta|[固定SHA适配](https://raw.githubusercontent.com/TencentCloud/TencentDB-Agent-Memory/08e2442e16a8ddb0412c4d5c7c24661539065fbf/adapters/opencode/README.md)|
|engram（观察补入）|9/7 compact搜索|[PR1068](https://github.com/Gentleman-Programming/engram/pull/1068)，明确Go/SQLite同名项目|
|AWS Memory（跨模块）|9/8 IngestData直接摄取|[公告](https://aws.amazon.com/about-aws/whats-new/2026/09/agentcore-memory-direct-ingest/)|

### OpenViking：公开任务状态与执行凭证分离

9/9 19:47:55+08的`f60a71d`/#4865修compile转发参数的密钥隔离：task_tracker过滤从仅user_key变为`SENSITIVE_TASK_KEYS=frozenset({"api_key","user_key"})`，compile_service从普通args剥离二者为私密参数；任务metadata及结果嵌套dict/list递归过滤。测试覆盖持久化、重启恢复、任务列表不泄密，执行仍把必要key给真实下游，完成后get_task_auth为空。Context Database不只是检索存储，开始承担knowledge/skills异步compile，因此状态可展示不等于执行授权可公开。

相邻#4822 embedding缓存线索以embedder实例身份而非同名模型作key，并保护共享任务免受单一等待者取消；大HTML截断，只保留次要待全文补核线索，不作已验性能结论。9/10 pushed_at不能当本周发布，也无本周新GA/许可证证据。当前README将memory/resource/skills统一viking URI及L0/L1/L2层级并提供检索trajectory，这是背景能力而非托管Ark Memory GA。

旧版本v0.4.17的release背景说明92 commits，URI从旧uid-less当前用户写法改为viking://~或显式user ID，旧写法400、旧服务不认识~，客户端/服务端须成组升级；session commit archive锁修复、ov-memory-doctor、按memory type/action/result抽取指标及受控模型错误码/真实耗时，支持其向Context control plane演进的判断。该页未取得首发日，不判定具体周别，也不计本周新发。session提交与后续提取应分层观察，memory/resources/skills统一命名空间带来权限治理复杂度；AGPL-3.0仅9/10元数据背景，非本周许可变化。[旧版原文](https://github.com/volcengine/OpenViking/releases/tag/v0.4.17)

**参照**：OpenClaw连接上下文数据库应验收恢复后可执行、导出状态无key、任务完成授权清理；凭证不能进入模型/日志/共享记忆。这是设计建议，不指控现有部署有已证漏洞。

来源：[完整安全patch](https://github.com/volcengine/OpenViking/commit/f60a71d0030618488f5f32ccbdda56aa9b1ef0f7.patch)、[同commit核对](https://github.com/volcengine/OpenViking/commit/f60a71d0030618488f5f32ccbdda56aa9b1ef0f7)、[缓存线索](https://github.com/volcengine/OpenViking/commit/c82ae5f66485f1fe02f1267ee039a2bd7bd9a343)、[README](https://raw.githubusercontent.com/volcengine/OpenViking/main/README.md)。官方代码/测试同源，不是第三方安全审计。

### TencentDB-Agent-Memory：团队资产代理接入，Beta与实验后端不等于云GA

9/8 13:29:07Z的08e2442/#999增加OpenCode适配，路径必须`/opencode/<spaceId>/v1/chat/completions`，不能误用/codebuddy/；第一路径段决定agentSource，误路由会破坏原生question工具的Team→Agent→Task选择。每轮将绑定agent的L2/L3记忆、skills、knowledge注入system prompt，保存L0对话供蒸馏；业务用户sk-mem key而非原始admin key，模型ID需与PROXY_UPSTREAM_MODEL一致。LLM代理可免逐客户端安装插件，但引入模型流量/提示经过中介的信任边界，不能以“零代码”忽略维护和注入风险。

9/8 13:36:31Z的MongoDB模式持久写环境配置，防以后启动静默回SQLite；明确experimental、off by default、切后端不迁移数据。仓库Team Memory Beta、默认分支feat/server_team；Memory v3 API与v2.0.0 images不是可互换版本，也非云发布证明。

当前Chat Memory/Skill/LLM-Wiki/CodeGraph归统一Memory Assets，先Team/User/Agent/visibility缩范围再检索；private归owner连team admin不可读、restricted用User/Role/Agent ACL是项目自述。CodeGraph优先公开HTTPS仓库，私库/SSH凭证与自动路由仍完善。PersonaMem48%→76%、相对+59%未独立复现，不作为本周性能/竞争排名。

**参照**：OpenClaw可借鉴业务身份→团队→agent→任务绑定、默认私有及审核后共享；不能把开源Beta直接填入腾讯元器/CloudBase生产Memory格。

来源：[项目](https://github.com/TencentCloud/TencentDB-Agent-Memory)、[OpenCode固定SHA全文](https://raw.githubusercontent.com/TencentCloud/TencentDB-Agent-Memory/08e2442e16a8ddb0412c4d5c7c24661539065fbf/adapters/opencode/README.md)、[MongoDB变化](https://github.com/TencentCloud/TencentDB-Agent-Memory/commit/30eda54d77b0887c8fa3cbab9e911a9b7ef4ebae)。

### Mem0：共享core减少安全漂移，但宿主捕获契约不能虚构统一

9/8 18:02:25Z #7203共享agent-plugin runtimes/原生适配，19:33:26Z #7269对齐文档。Python共享捕获、召回、MCP、scope、遥测，TypeScript共享生命周期、身份、格式/脱敏但保留各自事件工具。Python仅本地只读search_memories加六skills，run_id可在repo/dir/mine scope按已知session过滤、省略则跨session。仓库身份改用Git remote哈希，检索/显式删除兼顾旧ID，但旧数据同名跨host歧义未重写消除。

portable Agent Plugins v1无capture hooks/flush worker，remember skill不能独自写记忆；可载MCP+skills不等于原生自动捕获。OpenClaw适配选择近期消息与更早工作摘要，去噪/脱敏后保留被选消息全文，不再单条截2,000字符；仍非全会话归档，非交互触发、子代理session、已用记忆变更工具的turn跳过捕获。构建一致性检查含生成/缺失/陈旧文件及symlink，但离线conformance不证明真实宿主加载，未实装发行包。

两个文档searchThreshold默认0.3/0.1冲突未核实现，故不推荐默认配置；“agent forgets everything”是营销，不采用为OpenClaw事实。**判断**：壁垒是捕获生命周期、scope和证据保真，不只add/search。OpenClaw应公开宿主事件能力矩阵：哪些turn捕获、子代理如何关联、何时召回、哪些字段脱敏；selected durable memory与lossless conversation archive分开。

来源：[共享core](https://raw.githubusercontent.com/mem0ai/mem0/02f7a9b2c4fe38dedb96631e48c85c74ad58b605/integrations/agent-plugin-core/README.md)、[OpenClaw适配](https://raw.githubusercontent.com/mem0ai/mem0/02f7a9b2c4fe38dedb96631e48c85c74ad58b605/integrations/openclaw/README.md)、[冲突文档](https://raw.githubusercontent.com/mem0ai/mem0/02f7a9b2c4fe38dedb96631e48c85c74ad58b605/docs/integrations/openclaw.mdx)。

### Cognee：启动日志说防护启用，不代表transport真的挂载

6fe95f6/#4994 committer9/9 15:40:15Z（上海23:40:15）在窗内。FastMCP streamable-http转发Host/Origin参数，旧SSE静默丢弃但banner显示enabled；本次compose改Streamable HTTP、/sse→/mcp，保留SSE也直接挂相同middleware。--path此前只打印不生效，默认改None尊重各transport路径。LAN/custom hostname需allowlist，否则421，Origin拒绝403；这是DNS rebinding防护，不是模型内容安全。

旧client不改URL会404；cognee-cli -ui另容器保留/sse、不随此次迁移。MCP包0.5.5→0.5.6、修错报FastMCP版本，Python限定>=3.10,<3.14；核心1.5.4、MCP0.5.6、FastMCP3.4.6不能混名。作者68项回归通过未经独立复测；不同段落四/五工具和README三主工具按需发现口径不同，不报工具数增长。

**参照**：知识服务引入远程MCP后，要验Host/Origin负例、实际transport/路径及真实tool list，不只连接绿灯或banner。来源：[PR全文](https://github.com/topoteretes/cognee/pull/4994)、[commit说明](https://api.github.com/repos/topoteretes/cognee/git/commits/6fe95f6a30df03b144bb7ce0f2bcfee1ce9937a5)、[固定SHA说明](https://raw.githubusercontent.com/topoteretes/cognee/6fe95f6a30df03b144bb7ce0f2bcfee1ce9937a5/cognee-mcp/README.md)。

### Letta：MemFS v2预算变成提交门禁，消息渠道决定迁移边界

Letta Code170a6d1/#4185于9/8 18:29:06Z合入，最终默认单文件20,000字符、根目录核心Markdown合计65,536字符、最大目录深度2；含frontmatter，非token。早稿80,000已改为2^16，采用最终固定SHA。v2根MEMORY.md为layout标记，子目录路径须有MEMORY.md索引，skills/不在该记忆集合；无配置v2也应用默认，旧配置缺字段补默认，并非显式opt-in才受约束。

验证完整暂存仓库而非只改文件，旧超限仓库可在无关提交遭拒；报错明确未提交、暂存保留，建议拆文件/将非核心详情移出根。`.memfs.config.json`修改另需人工批准。`validateMemoryConstraintsHead`用临时Git index审计已提交HEAD、不动真实index/工作树；旧超限仓库应先审计修复再release。这是治理/迁移成本，不是降低持久记忆容量或算法召回提升。

9/8 20:50:23Z e073938/#4223阻止绑定本机消息渠道会话Teleport：若agent/conversation有enabled且允许outbound路由，报错且不开始目标sandbox连接解析，因为MessageChannel暂不能随会话迁往另一电脑。状态迁移不仅是记忆文件，还包括外部路由，不能写成渠道无缝迁移。

Letta平台核心latest0.16.8正文5/14非本周；Code0.32.0虽收录相关变更，但版本提交d043d46在9/9 19:23:12Z越窗，只报道窗内合入，不计本周正式发行。**参照**：OpenClaw分常驻上下文预算与按需检索容量，“写记忆”有可解释检查/失败保留，迁移前同时验记忆、权限、消息路由。

来源：[PR4185](https://github.com/letta-ai/letta-code/pull/4185)、[验证器](https://raw.githubusercontent.com/letta-ai/letta-code/170a6d190eb70b65ebf0d4e1683f971e18633997/src/agent/memory-constraints.ts)、[最终默认](https://raw.githubusercontent.com/letta-ai/letta-code/170a6d190eb70b65ebf0d4e1683f971e18633997/src/memory-constraints.ts)、[HEAD审计](https://raw.githubusercontent.com/letta-ai/letta-code/170a6d190eb70b65ebf0d4e1683f971e18633997/src/agent/memory-constraints-audit.ts)、[Teleport patch](https://github.com/letta-ai/letta-code/commit/e0739382c5c02af12cc5c72266f8f948e6918ac8.patch)、[越窗0.32.0](https://github.com/letta-ai/letta-code/releases/tag/v0.32.0)。

### supermemory：检索命中的合法ID必须可以回读，入口迁移保持OAuth连续性

9/2 21:49:57Z的4d8a4eb/#1641修MCP getDocument对active space外误报not found：去本地resolveContainerTag/containerTags过滤，直接API按document ID读，说明改为任何有权space可回读。作者说API已按org隔离，activeSpace空回sm_project_default反而破坏合法跨space；本地测同space/跨space成功、外org仍404，是上游自述，不是本报告渗透测试，更不意味着所有space ACL均可删除。价值在listDocuments发现的ID可用getDocument获取证据。

5258cb74迁移提交由Atom明确绑定9/7 19:56:46Z，确认窗内代码活动：app.supermemory.ai变console跳转壳，plugin/OAuth/invite立即308并保留query，其他路径5秒提示；删除browser-extension workspace、改中英文README/API-key链接至console、清company-brain文档标签并重定向。只证明提交，不证明生产部署、旧API停止、扩展全停或用户迁移完毕，也非新记忆引擎。巨大diff未完整不影响已精读PR的这些范围。

**参照**：OpenClaw验同org跨space回读、跨org拒绝、OAuth query连续，不以搜索可见证明授权完整；仓库删除workspace不等于远程服务关闭。

来源：[读取patch](https://github.com/supermemoryai/supermemory/commit/4d8a4ebfddadc3430f7f59a752cd374670833f50.patch)、[迁移PR](https://github.com/supermemoryai/supermemory/pull/1651)、[SHA日期索引](https://github.com/supermemoryai/supermemory/commits/main.atom?since=2026-09-02&until=2026-09-09)。

### Graphiti：正确写入、彻底删除和后端查询计划三套验收

graphiti-core0.30.2版本提交9/8 20:37:55Z，release汇总Neo4j数据库路由/NEO4J_DATABASE、Saga清理、多group参数、并发隔离和FalkorDB全文检索。#1699此前add_episode/bulk按group_id改共享self.driver及self.clients.driver，LLM/embedding/数据库多个await中另一group可改路由，造成前请求后续写错图；这是作者生产问题描述，不是独立事故审计。请求级driver及GraphitiClients副本逐层传递，相同数据库复用实例，不再共享可变状态；依赖add_episode改driver后直接search的旧调用者须显式group_ids。

9/8 14:12:19Z 7db9684在FalkorDB/Kuzu/Neo4j/Neptune的group-scoped清理和共享maintenance把Saga加入Entity/Episodic/Community集合；FalkorDB测试清g1后保g2，针对选择性删除，不是所有全库删除都失败。14:22:10Z ef68089修multi-group装饰器去位置group_ids后driver位置/关键词冲突，每task从原调用独立signature.bind再改group/driver，不能共享BoundArguments。

14:29:12Z 2d96f2仅为FalkorDB关系全文检索直接用startNode/endNode、保Entity标签约束，避免每命中全扫Entity。作者在5,665节点、20,263 RELATES_TO、3,725实体图上，相同306行由33,383ms→1.6ms；这只是特定图/计划自测，非通用Graphiti快两万倍，Neo4j/Kuzu未改，未独立复现。release包含旧PR不等于全是本周首提；Zep Cloud只有rollout提示，无窗内完整事件，不外推云GA。

**参照**：OpenClaw跨租户交错读写须检查每个await后路由，把group/database作为请求不可变上下文；删除查Saga辅助节点残留并保负例，性能报告附后端、规模、命中数。

来源：[release](https://github.com/getzep/graphiti/releases/tag/v0.30.2)、[版本patch](https://github.com/getzep/graphiti/commit/eaa4128681bc53487138a4bbc22d58336ebe70d2.patch)、[隔离PR](https://github.com/getzep/graphiti/pull/1699)、[Saga](https://github.com/getzep/graphiti/commit/7db96847d96b0196c1f9bc5d46a682f73b92a715.patch)、[参数](https://github.com/getzep/graphiti/commit/ef68089a4f36d30689a1d7c5e3e3942fc7921413.patch)、[FalkorDB性能](https://github.com/getzep/graphiti/commit/2d96f27138d21b723d6ad4f21fc9e0422f29e94e.patch)。

### Firecrawl：任务扇出进入配额语义，源码支持不等于安装包到货

7812a4a/#4583 patch为9/10 01:30+1000，即UTC9/9 15:30、上海23:30，在窗内。可信内部agent interop设hobby倍率下限10，不是所有外部MCP自动10倍；__agentInterop存在不算可信，须恒定时间secret验证，无配置/错误key不提升。付费倍率更高保持，团队rateLimitOverrides覆盖整个基数×倍率且优先，甚至不需查Autumn；统一API-key/OAuth/MCP-delegated路径，测试含各正负例。作者单任务约扇出10子请求是解释而非行业p99/采用数据，非统一涨配额/改价/质量提升，未证生产部署。

9/8 14:41:05Z f544d06/#4575补v2 search可选country的七SDK minor版本，因为#4574先加参数未升版，按版本触发的registry不会发布：Go1.15.0、JS4.39.0、Python4.42.0、Rust2.19.0、Java1.18.0、PHP1.16.0、Ruby1.17.0；Java同步SDK_ORIGIN、Rust Cargo.lock、PHP/Rust日志9/8，.NET/Elixir/CLI未改。不设country不发字段。仅验版本/changelog补丁，非七语言全部测试、registry到货/生产部署；这是修复发布条件。

9/9 16:31:27Z重定向后blocklist重查、18:03:30Z pdf-inspector升级均越窗排除。**参照**：OpenClaw同时观测父任务预算、子请求扇出、429与重试开销，遵守供应商内部标记，不能伪造提额；地区检索锁SDK并查序列化请求，不只看文档字段。

来源：[限流完整patch](https://github.com/firecrawl/firecrawl/commit/7812a4a324d8ec152ffaffba47a56e02491f2ba7.patch)、[SDK版本patch](https://github.com/firecrawl/firecrawl/commit/f544d065ef9f8c2f3218599b09aaa22f942a04e8.patch)。

### engram与Crawl4AI：精简检索载荷，不精简证据边界

Gentleman-Programming/engram为Go单二进制、SQLite FTS5本地权威存储，CLI/HTTP/MCP/TUI，保存精选决定/约束/修复而非原始对话倾倒；Cloud和Git Sync是不同复制方式，不因当前README推本周云上线。

9/7 07:29:31Z 100398a/#1068增加可选response_format=compact，数据库直接substr(content,1,300)并length>300，复用FTS/LIKE排序/过滤；compact文本只留命中数，preview/truncated/relations进结构化结果。测试“世界”验证300 Unicode字符边界及全文仍保留；默认详细意图不代表严格字节兼容，旧省略号可能消失、加入[preview]，依赖文本格式的client须回归。审查要求runtime/内存/payload/排序基准，尚无独立量化token节省/加速。OpenClaw的预览须稳定ID/截断/关系和全文回读通道，不能当完整证据或删持久正文。9/9 22:38:31Z mem_list_projects、22:32:53Z Claude配置修复均越窗。[PR](https://github.com/Gentleman-Programming/engram/pull/1068)、[patch](https://github.com/Gentleman-Programming/engram/commit/100398a99e3934788a8bf67ee76b731539b324b4.patch)、[项目](https://github.com/Gentleman-Programming/engram)

Crawl4AI精确UTC main及默认分支历史无可见commit，REST限流；只支持所查渠道未核实新增，非项目停止维护。latest跳v0.9.3，固定tag CHANGELOG首节8/31、PDF路径/Docker Playground五项安全修复窗外，全部排除本周。release“Docker images正在构建”是发布时文本，不证明9/10仍未完工；既有安全版本运维不属本周新闻。[release](https://github.com/unclecode/crawl4ai/releases/tag/v0.9.3)、[固定日志](https://raw.githubusercontent.com/unclecode/crawl4ai/v0.9.3/CHANGELOG.md)、[窗口历史](https://github.com/unclecode/crawl4ai/commits/main/?since=2026-09-02T16%3A00%3A00Z&until=2026-09-09T15%3A59%3A59Z)

### AWS Memory：长期摄取与短期事件解耦

9/8 AgentCore Memory direct ingestion新增IngestData，不创建short-term event即可送长期提取策略；支持USER/ASSISTANT对话和JSON行为/活动/系统事件，metadata走与CreateEvent相同pipeline。结果经ListMemoryRecords/RetrieveMemoryRecords验证，Kinesis通知、ListMemoryExtractionJobs定位/redrive失败，公告称全部支持Memory的区域可用，非新全平台GA。

**判断与参照**：自管session的Harness可只用AWS长期提取/检索，降低存储商绑定；不建短期event不等于不处理/保留数据，仍需记忆对象/任务及服务政策。提交摄取不等于记忆生成，OpenClaw应分短期账本、长期提取/检索/删除生命周期并检查任务/检索结果。

来源：[9/8完整公告](https://aws.amazon.com/about-aws/whats-new/2026/09/agentcore-memory-direct-ingest/)。

### 模块洞察

记忆仍碎片化，通用provenance/forget契约尚未由本期证据证明；可靠性需同时验捕获、作用域、后台授权、预算、删除与回取，不是盲目接更多memory API。LightRAG/GraphRAG/LlamaIndex/LangMem/Onyx/Haystack/Jina/Unstructured及向量数据库属强观察池，本期未逐项深验，不宣称它们静默。

## 7. Observability / Eval / Guardrails可观测治理层

### 本周模块结论

- 观测从dashboard向证据调查、可回填/可公平调度的评估作业和可追溯语义扩展：Braintrust、Langfuse、Coze Loop、Phoenix、OTel分别补不同环节。
- trace接收成功不等于字段语义正确，字段正确不等于评估可复现；未测量不能补零、离线导入不能伪造耗时。
- 产品public preview、client制品、main合入、Stable维护chart和网络治理是不同成熟度/层次，不能合称全面GA。

### 固定对象状态

|对象|本周状态|主要来源/范围|
|---|---|---|
|LangSmith|9/5 Stable Helm0.16.16/app0.16.50，仅维护|[release](https://github.com/langchain-ai/helm/releases/tag/langsmith-0.16.16)|
|Langfuse|9/8 v4.32.0；9/7、9/8回填/评论代码合入|[release](https://github.com/langfuse/langfuse/releases/tag/v4.32.0)、[17071](https://github.com/langfuse/langfuse/pull/17071)|
|Helicone|所查官网/main渠道未见窗内新料|[changelog](https://www.helicone.ai/changelog)、[main Atom](https://github.com/Helicone/helicone/commits/main.atom)|
|AgentOps|主仓库渠道无窗内提交；文档路径404|[main Atom](https://github.com/AgentOps-AI/agentops/commits/main.atom)|
|Braintrust|9/3 public preview；上海9/4 Python SDK0.37.0|[产品原文](https://www.braintrust.dev/blog/active-observability-loop-patterns-debugger)|
|Arize Phoenix|client3.5.0、9/9键盘解释控件修复|[client release](https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-client-v3.5.0)|
|Coze Loop|9/8实验Skills、9/9重试让位合入|[PR652](https://github.com/coze-dev/coze-loop/pull/652)、[654](https://github.com/coze-dev/coze-loop/pull/654)|
|OpenTelemetry agents/tracing|GenAI新仓库Groq参考metrics，非标准GA|[PR479](https://github.com/open-telemetry/semantic-conventions-genai/pull/479)|
|AWS观测/评估/护栏|9月TypeScript候选全文，缺具体日|[支持矩阵](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/supported-frameworks.html)|
|Google观测/评估/护栏|9/8出口模板属于治理资源；无独立新eval事件|模块4；9/9VPC-SC仍周界待核|
|Azure观测/评估/护栏|所查两个官方更新页无可确认窗内事件|[Foundry what's new](https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry)|

### LangSmith：稳定部署制品不是新增评估能力

9/5 Stable Helm chart langsmith-0.16.16对应应用0.16.50，仅“Internal improvements and maintenance updates”，GitHub正文只说明部署应用/依赖服务；不能宣称新增评估、轨迹或护栏。9/3 Preview chart0.17.0-rc.22仍应用0.17.18rc1，与rc.20相同，不把rc.20跨周功能归9/3首发；自托管为Enterprise附加项，不证明免费/云版同步。

Cloud“Aug31–Sep7”栏目跨窗，轨迹批读独立gRPC、dataset下载权限、变量映射等缺单项日期/完整独立正文，只作为跨窗背景；RSS404不是静默。Helm Atom rc.24 9/9 17:21:35Z、0.16.17 21:24:43Z、rc.25 21:51:03Z均越窗，且updated非可靠published。**参照**：OpenClaw外部观测升级同时固定chart、backend app及迁移状态，不能以chart升版宣称eval行为改变。

来源：[Stable制品](https://github.com/langchain-ai/helm/releases/tag/langsmith-0.16.16)、[Preview制品](https://github.com/langchain-ai/helm/releases/tag/langsmith-0.17.0-rc.22)、[自托管映射](https://docs.langchain.com/langsmith/self-hosted-changelog)、[Cloud日志](https://docs.langchain.com/langsmith/changelog.md)。

### Langfuse：有界回填、人工证据查询和导出freshness

v4.32.0为9/8窗口内发行；其entry updated9/8 12:53:51Z只是更新字段，未拿feed总updated代替。v4.33.0 entry9/9 16:04:02Z越窗，不混入本期。

PR17071 main合入9/7 13:40:29Z，保存evaluator可选historical-backfill：预设/自定义窗不早于六个月，最多25,000 observations或更低实例限制；UI分别呈持续评估和一次回填成本，展开匹配量×sampling×单次成本。复用batch-evaluation、增加可选sampling/rowLimit，最新优先流式调度；旧调用省略仍100%采样/原实例上限。事件只加hasBackfill/backfillWindow/backfillMaxItems，不采正文、筛选值、具体日期/ID。自动审查曾指出绑定已成但排队失败时重试唯一约束，合入含幂等修复，但未独立复测。代码不证明Cloud全租户上线。

PR17195 main合入9/8 15:33:27Z，评论可选objectStartTime帮助ClickHouse events_full.start_time分区裁剪，避免验证observation引用时扫数百至数千parts。UI从header到drawer/list传startTime，REST亦可用；这是hint非主键，省略走旧无界查询，错/过期导致miss时捕获LangfuseNotFoundError再无界回查，真正不存在才404。最终修正初稿以falsy检测但异常提前抛出导致回退不可达的问题；不能为了性能让已有证据消失，未证百分比收益或具体发布版本。

v4.32.0收录的PR17177给scheduled blob/PostHog/Mixpanel export记runStart减watermark的lag分布，用于建立P95 baseline后再定SLO。失败沿不变lastSyncAt采样，stall表现为lag上升；blob水位推进即算freshness成功，后续Redis catch-up排队失败不能误报旧水位stale；Mixpanel decrypt在export try前抛错也记failure。export成功、下批排队成功、数据新鲜度是不同状态，不把这一指标当已承诺SLO。

**判断与参照**：评估平台必须先是可靠作业系统；OpenClaw可做有上限、采样预算、可幂等重试的历史工具回归集，trace引用带定位hint但不改变正确性，导出同时观察新鲜度与流水线错误。

来源：[4.32.0](https://github.com/langfuse/langfuse/releases/tag/v4.32.0)、[回填](https://github.com/langfuse/langfuse/pull/17071)、[评论](https://github.com/langfuse/langfuse/pull/17195)、[freshness](https://github.com/langfuse/langfuse/pull/17177)。

### Braintrust：证据发现—候选诊断—评估—审批变更的闭环

9/3 Patterns、Debugger、增强Loop进入public preview，非GA，后续定价待GA前说明。Patterns查生产traces的重复失败/意外成功，附描述、影响、支持trace/引用与建议，可Slack摘要、Useful/Noise反馈、追踪active状态；Debugger基于代表trace的span/tool/result/model output提出可能失败模式，不是已证根因。Loop可SQL/代码找反例、持续线程、计划重做调查；改prompt/scorer/classifier/dataset/dashboard/automation需审批，开发者/领域专家验证evaluator并决定发布。公开MCP提供相同工具，可接Codex/Claude Code/Cursor等，不只内置agent。

配置背景默认每天本地默认时区09:00，查询近30天，启用即排一次，每次分析完整窗而非增量，宽窗增加推理成本。需可付款内置credits或兼容自有provider及project create-automation权限，Owners/Engineers默认有；要求data plane v2.13+，9月日志还提示自托管版本未发，不能据文档推普遍自托管可用。无证据不写Pattern属正常静默，不等于任务失败；聊天写的Pattern不自动触发automation Slack/webhook目标。

Python SDK0.37.0上海9/4发行，早期API published9/3 16:00:30Z与Atom updated16:01:21Z不同；PR729本身9/1更早，但随本次release交付。Pydantic AI有效model settings进入leaf LLM span `metadata.invocation_params`，与LangGraph体验对齐，temperature/max tokens有VCR regression；未经本报告复跑，不称通用兼容性提升。0.36.0窗外，0.38.0 entry9/9 16:17:45Z越窗，均不挪入。

**判断与参照**：带证据的运维agent增加调查费用和带写权限自动化风险。OpenClaw先做证据→候选模式→小回归集→审批后修改→再评估，区分无证据静默、取证失败、通知失败；观察agent发现问题不应自动改系统。

来源：[9/3产品全文](https://www.braintrust.dev/blog/active-observability-loop-patterns-debugger)、[Patterns配置](https://www.braintrust.dev/docs/observe/patterns/enable)、[SDK0.37.0](https://github.com/braintrustdata/braintrust-sdk-python/releases/tag/py-sdk-v0.37.0)、[PR729](https://github.com/braintrustdata/braintrust-sdk-python/pull/729)。

### Phoenix：离线轨迹导入以数据诚实性优先

arize-phoenix-client3.5.0标9/8，release commit9/8 22:22:24Z（上海9/9 06:22）窗内，非Phoenix服务端3.5.0。新增MiniMax provider、Harbor ATIF tracing、Python/TS get_traces error/latency筛选，annotation验全部配置ID列而非首列。

PR15715每新操作步骤建CHAIN span，复制上下文只重构prompt，不伪造执行span/轮数/耗时。ATIF时间戳是点事件，未测LLM/TOOL以零时长表示并用_phoenix.span_order排序，不捏造微小偏移；只有metrics.extra.latency_ms等生产者实测才赋LLM时长。子Agent优先source_call_id连可证父tool，否则挂操作步骤；Harbor最低0.21.0，防御缺TrialConfig.user_agent。trace按trial为harbor:<trace_id>，恢复用harbor_job_id/harbor_agent_digest，避免共享dataset版本变化重复experiment。cache-write/reasoning token只在extra存在才映射；到verifier的步骤异常可为可评分结果，不应全当基础设施失败，测试/Terminal Bench覆盖为维护者自述。

9/9 23:47:44+08 patch7d1c463修annotation explanation键盘可达：最终diff去按钮excludeFromTabOrder，加Tab可达、disabled跳过、Enter打开并聚焦输入测试，同时保留annotation edit hotkey行为；不能把初稿“全移除focus manager排除”当最终实现。这是人工评审可用性，不是新评估算法。

**参照**：OpenClaw压缩上下文、retry、subagent和重放保存独立标识；离线表示零时长和真实测得零须上层区分，不为时序图好看造数据。

来源：[client release](https://github.com/Arize-ai/phoenix/releases/tag/arize-phoenix-client-v3.5.0)、[ATIF PR](https://github.com/Arize-ai/phoenix/pull/15715)、[键盘patch](https://github.com/Arize-ai/phoenix/commit/7d1c463141b4ac5958c007c52f4060f062bb5306.patch)。

### Coze Loop：重试公平性与实验Skill声明分别落地

PR652 main合入9/9 03:53:15Z。旧可重试错误保持Processing并占slot，并发3时三项重试会饿死健康Queueing。新retry_times为unsigned非空默认0、按expt_run计，让位将run_log/item_result改回Queueing并配平统计，停旧MQ重投，由调度retry_times asc,id asc重取，防scheduler/MQ双跑。业务retry_yield_enabled在实验开始固到event.Ext，旧事件缺省关，不能半程改语义。

最终方案推翻早稿“先建六列复合索引”：只加列，不交付该index定义。index_ready=false默认不ForceIndex，可optimizer/filesort；true才用idx_expt_run_retry_pick，缺索引报错。index_ready是实时schema事实，不同于固定run的业务开关。维护者99.6M行/36.1GB热表观察用于内部取舍，非公共benchmark，不建议照搬。

PR654于9/8 11:59:40Z合入，SkillDistDeclare/AgentSkillDeclare把实验Skill传runtime，RunModeConfig IDL field12=skills，与testcase.Skill线协议对齐；第三个skills_mode=merge_exp_first，同skill_key实验声明胜。OpenAPI→domain拒空skills[i].skill_key，CommonInvalidParamCode含索引；非空才写domain/OpenAPI与DO/DTO回转，保旧无Skills配置结果。测试含dist透传、空key、往返、新模式，非已证Coze SaaS所有空间启用。

PR646中心调度虽9/3 06:16:11Z合入，正文过长未完整精读，不采用前半段推“开源完整中心调度”。**参照**：OpenClaw回评先验重试是否释放slot、重投幂等/统计守恒、同run配置稳定；A/B固定模型/prompt/Skill版本及冲突规则，防表面只改prompt实际依赖不同。

来源：[PR652完整最终方案](https://github.com/coze-dev/coze-loop/pull/652)、[PR654](https://github.com/coze-dev/coze-loop/pull/654)。

### OTel：参考metrics补齐，未知token不能补0

GenAI规范已迁独立semantic-conventions-genai，旧目录Atom停5/5不是社区沉寂。PR479于9/3 23:30:36Z合入，为Groq参考scenario补`gen_ai.client.token.usage`及`gen_ai.client.operation.duration`，沿Anthropic属性集合；按gen_ai.token.type分别记usage，显式规范histogram bucket而非SDK默认。streaming无usage block就只记duration，规范MUST NOT无法得token还上报usage，不能猜或补0。属性在SDK调用点构造，可追溯请求/响应来源，生成data.json不变。

这是参考实现覆盖，不是Agent全套span新协议、GenAI规范Stable/GA；“28 scenario仅2展示metrics”是维护者覆盖说明，非生态采用率。**参照**：OpenClaw保存scope/schema/版本及测量来源；trace完整和成本完整不是一个信号，未知与零必须分开。

来源：[PR479](https://github.com/open-telemetry/semantic-conventions-genai/pull/479)、[官方迁移页](https://opentelemetry.io/docs/specs/semconv/gen-ai/)。

### 云评估与无确认事件的边界

AWS9月日志列TypeScript支持但无日；完整frameworks页支持TS Strands/LangGraph/OpenAI Agents/Vercel AI SDK，不同语言instrumentation scope不同，服务由span/event scope.name提取prompt/response/tool。推荐@strands-agents/sdk>=1.5.0，ADOT-native LangGraph/OpenAI/Vercel instrumentation>=0.12.0，LangGraph Traceloop>=0.27.0、OpenInference>=4.0.14；Python旧行不全算新增。必须启observability并导CloudWatch，仅装instrumentation或OTLP接收不等于托管eval可读。具体日期仍待核，保留背景而非静默。[supported-frameworks](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/supported-frameworks.html)、[release notes](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html)

Google9/8Connectivity Template是组织网络治理资源，不是新评估算法，独立计数去重到模块4；9/9VPC-SC/双Registry不计严格周内。Azure正确Foundry更新页为August2026，ms.date9/1，updated9/9 22:15Z越窗；agent optimizer/autopilot/长任务新文档不能改为本周新品。classic页最新正文2025/10、metadata2026/6，未证本周模块7事件；最初404路径已恢复，不说网站整体失败，也未穷尽Azure其他渠道。[新Foundry](https://learn.microsoft.com/en-us/azure/foundry/whats-new-foundry)、[classic](https://learn.microsoft.com/en-us/azure/foundry-classic/agents/whats-new)

Helicone官网最新可见2025/11/26，main最新8/31 04:30:56Z安全hardening窗外，限定这两个渠道静默，不外推SaaS私有/其他分支。AgentOps文档/changelog404属失败；日期历史无commit，main最新6/25 08:25:03Z旧OpenAI可选tool字段修复，主仓库静默证据独立成立，两种状态分开。[Helicone](https://www.helicone.ai/changelog)、[Helicone main](https://github.com/Helicone/helicone/commits/main.atom)、[AgentOps main](https://github.com/AgentOps-AI/agentops/commits/main.atom)、[失败文档入口](https://docs.agentops.ai/changelog)

### 模块洞察

可观测性由收span转向运行参数、freshness、回填预算、重试公平性和可审批调查；共享tool-call事件可被trace/eval/cost/policy/audit消费，但OTel还未替应用完成数据最小化与硬执行阻断。先保证字段诚实与有界回归，再考虑自动调查；模型“安全”评分不能替代权限和网络策略。

## 8. Managed Agent Platform / Enterprise Control Plane平台层

### 本周模块结论

- AWS9/8长期记忆直接摄取、Google9/8网络模板、Databricks9/8 ABAC DENY分别将记忆、网络、授权管理切成可组合资源，不是同一场全栈GA。
- Foundry把agent identity/project identity、conversation/session/compute分开，是平台契约参考；文档updated不能说明首发。
- 国内平台须按产品拆开：百炼长期记忆API不等于Agent2.0已支持；Coze/OpenViking开源不等于Ark托管；腾讯元器分发、ADP托管、CloudBase工具不构成统一GA证明。

### 七平台×六能力矩阵

“托管”仅指官方文档说明平台运行；“开源”指代码可部署，不代表云上线；“待证”指当前材料不足而非没有能力。除明确GA/Beta/Preview，不擅自标全平台成熟度。本表是截至9/10的能力快照，本周事件另列；同事件跨模块不重复计新闻。

|平台|Runtime / Session|Memory / Context|Gateway / Tools|Identity / Auth|Sandbox / Browser / Code|Observability / Eval|本周强信号与限定|
|---|---|---|---|---|---|---|---|
|AWS|AgentCore托管Runtime，session microVM隔离/异步；最长8h、终止非原进程恢复；overview另列managed Harness|短期/长期Memory；9/8 IngestData不建short-term event提取长期记忆|Gateway将API/Lambda/既有MCP转工具；Policy拦截；HTTP/A2A/推理路由背景|Identity接既有IdP；JWT inbound与outbound OAuth分开；consent portal日待证|托管Browser/Code Interpreter；custom Browser才有S3录制；临时session|OTel兼容Observability/Evaluations，需CloudWatch及正确scope映射|9/8直接摄取、Memory支持区域可用；不是整套AgentCore本周GA|
|Google|Agent Platform托管Runtime，旧Agent Engine入口重定向；Managed Agents状态单独待证|Sessions/Memory Bank分离，长期偏好/事实|Agent Gateway9/8模板，PRIVATE_RANGES_ONLY/ALL_TRAFFIC；MCP与A2A策略粒度不同|SPIFFE agent identity、service accounts/OAuth clients；provisioner与service agent分权|Code Execution；9/9 Computer Use/Shell GA有官方条目但周界待核；网络/密钥须配置|Cloud Trace/Logging/Monitoring/Evaluation Service；网络模板是治理资源非新eval算法|9/8出口模板；9/9沙箱/双Registry/VPC-SC保边界；ADK合入非云部署|
|Microsoft|Foundry prompt/hosted agents，每session VM；Responses/Invocations history归属不同；长任务resilience preview|conversation独立compute，session文件持久不等于长期语义记忆；overview内memory工具|Toolbox集中MCP端点/版本/认证，OpenAPI/MCP/custom工具；A2A标preview|每agent Entra与project managed identity分开；OBO/agent identity/key auth|VM session、Code Interpreter、BYO VNet；Browser需Playwright资源权限，不能全标GA|OTel/Application Insights/trace/eval；Copilot Studio analytics/evaluation|AF Python1.17.0窗内；Hosted/Studio更新日期不证明新功能首发|
|阿里百炼/PAI|Agent2.0托管规划/工具loop及版本；PAI仅证DSW/DLC/EAS定位，专项托管待证|Agent2.0短期0—30轮，长期记忆仍计划支持；独立长期API旧动态不自动移植|统一knowledge/MCP/app组件/Skills；不等于独立企业Tool Gateway；AI网关另产品|技能环境可注凭证，独立agent identity/委托撤销待证；OpenAPI MCP有RAM/用户OAuth不同模式|内置bash/read/write/edit/glob/grep隔离sandbox且默认关闭|卡片流展示tool入参/结果/轨迹；平台评测/OTel旧背景|所查窗内重大新发未确认；PAI导航/部分专项不足，不判全平台静默|
|火山/字节|Coze Studio开源agent/app/workflow；Ark托管详情抽取失败|OpenViking开源Context DB、viking URI/L0/L1/L2；非Ark托管Memory GA|Coze插件/workflow/API；Ark专属gateway待证|Coze社区API PAT；托管独立agent身份/委托待证|Coze README提示Python code node、公网注册/SSRF风险，不能视为已证安全隔离|Coze Loop开源trace/eval/prompt版本，OpenViking检索trajectory|OpenViking/Coze Loop窗内代码有料；不以stars/README/live demo推托管GA|
|腾讯云/元器/CloudBase|ADP官网自述云端Harness/长任务；元器分发列表；CloudBase旧Agent入口壳、session契约待证|ADP自述Agentic RAG；独立长期服务待证，Team Memory Beta不直接算元器/CloudBase内置|CloudBase插件MCP+Skills+Hooks操作数据库/函数/托管；ADP connectors/Skills|ADP自述RBAC/操作审核；CloudBase认证工具不等于独立agent identity GA|ADP自述云端coding sandbox，隔离级别/恢复/区域未证|ADP自述审计/运行可观测；CloudBase日志工具非完整agent eval|未证托管本周首发；Team Memory开源适配单列，不混平台|
|Databricks|任意authoring library与Apps；UC Agent Services Beta仅登记/权限，runtime invocation尚不可用|RAG/AI Search，独立长期session memory未证；9/8 generate_citations Beta|Unity Gateway文档GA，但Agent Services Beta独立启用；MCP/UC functions工具|UC grants/service principals；9/8 ABAC DENY Beta仅MANAGE ACCESS CONTROL|通用code tools入口，agent专属隔离sandbox/browser GA未核|MLflow Tracing/Agent Evaluation/online monitoring|9/8 DENY与引用chunks、9/4模型可用；9/1Genie定时GA窗外|

### Databricks：数据治理的显式拒绝，不等于Agent runtime全面升级

9/8 Unity Catalog ABAC DENY policies Beta，以governed tags匹配、附catalog/schema；覆盖显式授权、组继承和owner隐含权限，多DENY取更严格。当前仅拒MANAGE ACCESS CONTROL，不直接拒SELECT/MODIFY；metastore admin隐式豁免保恢复通道，SQL管理需classic compute Databricks Runtime18 LTS+。这是再授权职责分离，不是防外泄总开关；CTAS复制、view暴露、tag修改、OpenSharing、credential vending、group management仍需独立权限。

SHOW GRANTS/GetPermissions/GetEffectivePermissions不反映DENY，要SHOW EFFECTIVE POLICIES；Agent只缓存grants会误判有效权限。分阶段release，账号可能比首发晚一周或更久，Beta非全客户同日可用。9/4 Unity Gateway加GPT-6 Astra仅模型接入，9/8 AI Search generate_citations返回引用chunks为Beta，均不能充作持久执行新特性；9/1 Genie Code scheduled tasks GA明确窗外。

旧Agent Bricks入口重定向Use agents on Databricks，当前支持任意authoring library、Apps、MCP/UC tools、MLflow tracing/evaluation；只是页面组织/能力背景，不是本周品牌合并。Agent Services页前部EXECUTE表述与尾部Beta runtime invocation unavailable不一致，采用具体限制“仅登记和权限管理”，Unity Gateway GA不自动使Agent Services GA。

**判断与参照**：Databricks从已有数据资产授权进入Agent控制面，agent拥有对象不应天然有再授权能力；OpenClaw应将可调工具、可读数据、可转授权拆三权，恢复时重查有效policy而非缓存旧grants。

来源：[9月产品月报](https://docs.databricks.com/aws/en/release-notes/product/2026/september)、[DENY完整文档](https://docs.databricks.com/aws/en/data-governance/unity-catalog/abac/deny-policies)、[Agent架构](https://docs.databricks.com/aws/en/agents/custom-agents/build-agents)、[Agent Services限制](https://docs.databricks.com/aws/en/ai-gateway/agent-services)。

### 平台能力来源与公开边界

- **AWS**：[overview](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html)、[9/8 Memory](https://aws.amazon.com/about-aws/whats-new/2026/09/agentcore-memory-direct-ingest/)。overview还列Harness/Payments/Optimization/Registry，无本周完整GA说明，不能拼“本周全栈新增”。
- **Google**：[scale](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale)、[Gateway配置](https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/set-up-vpc-connectivity)。旧Vertex/Agent Engine重定向不证明本周更名。9/9时区缺口已全篇保留。
- **Microsoft**：[Foundry overview](https://learn.microsoft.com/en-us/azure/foundry/agents/overview)、[Hosted](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents)、[Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/fundamentals-what-is-copilot-studio)、[M365 SDK入口](https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/)、[Toolbox](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/toolbox-overview)。Studio窗内文档updated并非功能首发，M365目录仅证明扫过；第三方工具可在微软合规边界外处理数据，平台托管不能自动覆盖外部数据流。
- **阿里**：[Agent2.0完整指南](https://help.aliyun.com/zh/model-studio/new-single-agent-application)、[应用历史](https://help.aliyun.com/zh/model-studio/application-release-notes)、[PAI定位](https://help.aliyun.com/zh/pai/)。不能把独立长期API旧动态归到Agent2.0，沙箱工具默认关须保留；未给全平台GA/服务SLA结论。
- **火山/字节**：[Coze Studio](https://github.com/coze-dev/coze-studio)、[Coze Loop](https://github.com/coze-dev/coze-loop)、[OpenViking](https://raw.githubusercontent.com/volcengine/OpenViking/main/README.md)。Ark两个官方正文入口失败，不以这些README代证托管runtime/identity；开源安全风险也不能外推所有商用部署状态。
- **腾讯**：[ADP产品](https://cloud.tencent.com/product/adp)、[CloudBase插件](https://docs.cloudbase.net/ai/cloudbase-ai-toolkit/ai-agent-plugins)、[CloudBase概述](https://cloud.tencent.com/document/product/876/46894)、[元器](https://yuanqi.tencent.com/)。ADP7×24等为官网自述，未独立证服务SLA/区域/恢复；AI Toolkit的MCP/Skills/Hooks与元器分发不是一个runtime产品。

### 模块洞察

七家在补相近能力图，但默认取向不同：AWS可组合服务、Google Runtime/Context/Quality/Sandbox平台资源、Microsoft企业身份/Toolbox/分发、国内云模型与应用生态、Databricks数据治理/UC/MLflow。可托管、可登记、可授权、可恢复、已GA是五个命题；OpenClaw不必与云比资源规模，应保持Gateway/session/cron/tool policy的可见性和可迁移性，以标准事件/协议接云runtime/memory/observability。

## GitHub / Web热度补漏结果

本期九方向发现扫描用于补漏；扫描只发现候选，不构成本周发布证据。

|查询方向|本期发现与归类|
|---|---|
|agent memory github|TencentDB-Agent-Memory、engram、OpenViking及ai-memory/memanto/Hermes线索，进模块6/1候选|
|agent context database github|Context Database/文件系统上下文，重点OpenViking，模块6|
|agent knowledge graph github|Graphiti/Cognee及代码图谱，模块6|
|AI agent RAG memory skills github|OpenViking/自演化记忆/通用Harness，过滤纯应用模板|
|MCP gateway github|Docker MCP Gateway、企业Registry/网关候选，模块4/5|
|agent auth permission OAuth MCP github|原长查询无结果，缩MCP OAuth后命中Agent IAM、持久会话CLI、Atlassian官方MCP线索|
|browser agent runtime github|CDP runtime/WebContainer/Hermes连接器，模块2/3候选|
|agent observability eval github|评估/回放/仿真候选，过滤awesome/tool合集|
|agent harness runtime github|Harness/durable session/凭证隔离/审计回放，模块1/2候选|

只有识别真实仓库并核窗内原文者深写；Hermes、Docker MCP Gateway、Agent IAM、Atlassian等仅发现线索，未完成具体当期事实核验，不纳本周新闻或静默结论。过滤awesome-list、教程/YouTube transcript skills合集、纯应用workflow、无原始仓库片段。

|对象|2026-09-10官方API快照stars / forks|补入决定与限制|
|---|---|---|
|TencentCloud/TencentDB-Agent-Memory|26,250 / 2,463|新增动态对象，模块6/8；默认feat/server_team、Beta，9/8push仍须具体commit核验，已完成|
|volcengine/OpenViking|36,317 / 2,774|固定对象非新补入；当前元数据AGPL-3.0不代表本周许可变更；9/10push不能当窗内发布|
|Gentleman-Programming/engram|6,476 / 678|不足10k但模块定位清晰，补观察池不升级固定竞争对象；9/7 compact已核|

来源：[TencentDB API](https://api.github.com/repos/TencentCloud/TencentDB-Agent-Memory)、[OpenViking API](https://api.github.com/repos/volcengine/OpenViking)、[engram API](https://api.github.com/repos/Gentleman-Programming/engram)。stars/forks只是该日平台快照，不是周增长、客户采用率、收入或排名；无独立第二统计源，不据此推胜负。OpenViking/Cognee/supermemory/Crawl4AI四个易漏对象均在模块6，未因搜索排序遗漏。

## 横向结论与OpenClaw优先参照

1. **先验完成语义**：接受请求、输出完成、状态持久化、实际副作用、投递确认分开；升级/恢复用真实readiness与幂等账本，不让正常回复掩盖失败。
2. **再验权限与出口**：用户consent、Agent身份、token代理、tool参数许可、资源ACL、网络路径分别有证据。预授权便利不替代运行时审批，目录/skill来源校验不等于安全授权。
3. **记忆集成先做少而可靠**：宿主捕获矩阵、公开状态与执行密钥分离、租户并发负例、预算失败语义、预览→全文证据链优先于同时接更多产品。
4. **可观测先诚实后自动**：保存scope/schema/版本、真实call与parent ID，未知token不补零；小规模有界回填、重试公平与Skill冲突规则稳定，再试证据驱动的自动调查。观察和变更必须有审批隔离。
5. **保留多后端而不虚构统一**：计算租约、文件、内存、连接身份、消息渠道是不同迁移单元；SDK/API类型/源码合入/包发布/服务部署/GA分别展示，不能承诺跨云无损恢复。

本期无独立验证的客户采用率、收入、生产SLA或普遍性能/成本改善。本文所述规模、性能数字仅用于准确交代作者主张及边界，不作为客观比较结论；未确证时间的内容明确背景/待核，不能在编辑时移入“本周新发”。

