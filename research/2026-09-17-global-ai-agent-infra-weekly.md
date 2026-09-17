# 全球 AI Agent 基础设施研究周报

**本期：2026-09-10 00:00—2026-09-16 24:00（Asia/Shanghai）**

## 执行摘要

本周最值得关注的不是又多了几个“Agent”产品，而是 Agent Harness 的关键模块正在被拆成可独立治理的标准件：托管会话、可替换执行环境、工具/技能分发、用户授权、上下文数据库，以及能正确解释恢复与工具调用的 trace。

五条主线信号最强：

1. **OpenAI Agents API 于 9 月 10 日进入 public beta**，把 Codex harness、持久 session、compaction/recovery 和可替换 sandbox 接口上移为托管服务；但美国数据驻留、ZDR 与自托管执行环境的边界必须分开理解。来源：[OpenAI API changelog](https://developers.openai.com/api/docs/changelog)。
2. **Google ADK 2.9 把失败节点重执行写进恢复语义**，而 9 月 11 日公布的 GKE Agent Substrate 又从计算底座提供 RAM/文件快照与暂停空闲 compute。两者共同说明 checkpoint 不等于外部副作用 exactly-once。来源：[ADK v2.9.0](https://github.com/google/adk-python/releases/tag/v2.9.0)、Google Cloud 相关 release note。
3. **MCP Skills 正式扩展把技能发现、按需读取、来源身份、manifest 完整性与批准失效写进宿主契约**；同期 AWS Consent portal、Databricks 治理型 MCP 与 Nango session actor/审计表明 Tool Gateway 正从“schema 转换器”走向有身份、有版本、有策略的控制面。来源：[MCP ext-skills](https://github.com/modelcontextprotocol/ext-skills)、[AWS Consent portal](https://aws.amazon.com/blogs/machine-learning/manage-end-user-oauth-consent-for-ai-agents-with-amazon-bedrock-agentcore/)、[Nango v0.71.8](https://github.com/NangoHQ/nango/releases/tag/v0.71.8)。
4. **OpenViking v0.4.20 把 Compile 任务、来源与目标权限、执行记录、记忆策略和宿主捕获链路纳入 Context Database 职责**；Cognee v1.5.4rc1 则强化带 provenance 的结构化检索证据。Memory 的竞争点正从“多记一些”转向“谁写入、从哪里来、何时失效、怎样删除”。来源：[OpenViking v0.4.20](https://github.com/volcengine/OpenViking/releases/tag/v0.4.20)、[Cognee v1.5.4rc1](https://github.com/topoteretes/cognee/releases/tag/v1.5.4rc1)。
5. **可观测性开始校正 Agent 执行事实本身。** Braintrust bt v0.20.0 修复工具成功/失败、子 transcript 与 resume/compaction trace；OpenTelemetry GenAI 为 `execute_tool` 补 conversation 关联；Langfuse v4.37.0 区分响应头时延与 provider 完整执行周期并强化敏感字段脱敏；LangSmith 自 9 月 14 日起把新 SaaS extended traces 上限定为 180 天。来源：[Braintrust bt v0.20.0](https://github.com/braintrustdata/bt/releases/tag/v0.20.0)、[OTel GenAI #518](https://github.com/open-telemetry/semantic-conventions-genai/pull/518)、[Langfuse v4.37.0](https://github.com/langfuse/langfuse/releases/tag/v4.37.0)、[LangSmith usage and billing](https://docs.langchain.com/langsmith/usage-and-billing)。

整体判断：Harness 组件列正在趋同，但暂停/恢复、凭据撤销、memory scope、trace 留存与 sandbox 网络边界仍高度碎片化。下一代标准件的判别标准不是“有没有”，而是失败时能否给出明确、可验证、可审计的责任边界。

## 1. Harness / Agent OS 控制层

### 本周变化

- **OpenAI Agents API public beta（9 月 10 日）**：托管 Codex harness 与 durable sessions，允许接入自有或伙伴 sandbox。Session 可以长于执行环境；删除 API 侧 environment 不等于自动停止自有 compute。自托管 sandbox 也不自动获得 ZDR。
- **OpenClaw v2026.9.4** 的标签实际于上海时间 9 月 11 日发布，涉及配置所有权、安全重放、Codex 会话与最终答复恢复；发布验证仍有未完成/豁免项，不能写成所有平台验证全部通过。来源：[OpenClaw v2026.9.4](https://github.com/openclaw/openclaw/releases/tag/v2026.9.4)。
- **Anthropic 托管 auto permissions** 增加逐工具 allow/ask/deny 与 evaluation 事件。`auto` 不是人工审批点，custom tools 不自动受同一策略治理，默认也并非 auto。
- **Google ADK 2.9.0/2.9.1** 带来失败节点重执行、YAML graphs、FallbackModel 与 MCP2 opt-in。外部写操作若没有幂等键，恢复可能重新触发副作用。
- **Microsoft Agent Framework .NET 1.21.0** 在窗口内发布；Harness 文档的更新时间只证明当前文档边界，不证明相关功能本周首次上线。Semantic Kernel 与 AutoGen 在已查 release 入口未见可核本周重大发布。
- **Hermes Agent v0.21.2/v0.21.3** 围绕 `state.db`、多 profile 隔离和 refresh 并发修复，说明本地 Agent OS 的竞争也已进入数据库、凭据与后台恢复层。

### 模块判断

控制层正在标准化为 session、context、tools、approval、events 与 recovery 的组合，但状态和授权语义并未统一。托管路线把运维责任上移，开源 Agent OS 则以本地所有权、渠道与可组合性竞争。

## 2. Runtime / Session / State

### 本周变化

- **GKE Agent Substrate（9 月 11 日）** 提供面向 Agent 的专用数据面，可暂停闲置 Agent 并快照 RAM/文件；生产使用仍是 limited GA allowlist，默认 gVisor，microVM 需要额外配置。供应商性能数字未作为独立结论采用。
- **火山 AgentKit v0.8.7（9 月 15 日）** 在 SDK 中暴露 `PauseSession`/`ResumeSession`、snapshot 字段与 Exclusive Gateway 配置。这里能确认接口和版本，不能外推所有账号、区域或托管服务已统一 GA。
- **E2B** 在 9 月 10 日的文档型变更中提醒：旧控制面即便返回 2xx，也可能忽略请求的恢复模式；9 月 16 日 release 记录还包含旧模板 API 移除与诊断修复。成功响应不等于运行时按请求语义执行。
- **Daytona v0.214.0（9 月 15 日）** 聚焦构建与连接安全修复；其 Container、VM、GPU sandbox 的持久化语义不能互相泛化。
- **OpenClaw** 本周直接提交修复 cron 准备过程中的 runtime generation 竞态，说明长期任务的一致性从启动准备阶段就开始，而不是只看模型生成阶段。
- **腾讯 CloudBase AI Toolkit v2.34.4（9 月 16 日）** 有部署规则修复；它是接入与部署层变化，不等于腾讯 Agent Runtime 当周新上线。

### 模块判断

“有状态”必须拆成会话历史、文件、内存、输入输出事件和外部副作用分别由谁保存、恢复与清理。云厂正在收编产品组合，但恢复保证仍碎片化。

## 3. Sandbox / Computer Use / Browser

### 本周变化

- **OpenAI Agents API** 把托管 Harness 与可替换 sandbox 分离，使执行环境成为组合件，也增加了双重生命周期与凭据责任。
- **AWS AgentCore Code Interpreter** 的本周客户案例显示，可以只把最难的长尾样本交给 sandbox；相关规模是客户/供应商披露，未把邮件总量误写成 sandbox 调用量。
- **agent-browser v0.38.0** 的窗口内 release 记录包含稳定 refs、delta snapshot、条件截图和 CDP 恢复；v0.38.1 换算到上海时间已是 9 月 17 日，排除本期。它仍是 CLI，不是自动托管 sandbox。
- **Browserbase / Stagehand 4.1** 实际日期为 9 月 9 日，属于窗口外背景；云浏览器、录制和 replay 不能直接等同 workflow checkpoint。
- **Databricks Sandbox Beta** 目前存在不可配置开放 egress、停止时可能清理非 home 数据等边界；未取得专用托管 browser 的等价证据，写“未取得”而非“不具备”。
- **Anthropic Computer Use** 本次未发现可核本周 toolset 新发布；client toolset 仍是自备执行环境，不应称为托管桌面。

### 模块判断

内核隔离、网络策略、凭据可见性、动作审批和回放证据是不同能力。一个 `sandbox=true` 不能覆盖所有威胁，浏览器视频也不能替代业务断点。

## 4. Tool Gateway / Protocol / Integration

### 本周变化

- **MCP Skills 正式扩展** 把工作流内容分发纳入协议扩展，但并不代表所有客户端已实现；digest 只能证明内容一致性，不能证明内容可信。
- **A2A 路线图** 在窗口内更新，讨论 v1.1、双向流、CLI/harness 接入和多轮交互；它是规划，不是 v1.1 已发布。
- **Databricks** 于 9 月 10 日提供受 Unity Catalog/Unity Gateway 治理的 MCP connectors GA；9 月 16 日官方产品记录宣布 MCP service 管理 API/开发工具 GA，service policies 与 Bundles 仍 Beta，并存在逐账户 rollout。9 月 16 日页面未给时刻/时区，因此日末严格归窗仅作边界观察。
- **Postman Fabric Gateway** 于 9 月 10 日开放 early access，代表 Agent Gateway 进入产品化方向，但不能与 GA 等同。
- **Nango v0.71.8** 增强 session 日志/审计、过期 key 清理和 MCP auth 配置。
- **Kuadrant mcp-gateway** 本周修正旧 MCP 版本与无会话 HTTP 的耦合假设；原热扫 issue 未复原，采用的是可核 commit/PR，不冒称核过原 issue。

### 模块判断

Gateway 正从统一 URL/schema 走向有身份、有版本、有调用前后策略的治理资产；但内容分发、网络策略、token 托管和工具执行仍不是同一种标准件。

## 5. Identity / Auth / Permission

### 本周变化

- **AWS AgentCore Consent portal（9 月 14 日）** 托管组织登录、终端用户同意和 session binding，连接主 IdP、Gateway 与 token vault。主 IdP 需要 JWT/OIDC；删除 portal 不等于已证所有下游 token 即时撤销。
- **Nango v0.71.8** 把 session actor、创建/终止审计与过期 key 清理带入 release。终止 session 会拒绝后续请求，但不取消已在途操作。
- **pi-mcp-adapter v2.34.0** 增加显式 opt-in 的加密凭据后端、URL 绑定与 CIMD 支持；跨进程 OAuth 事务序列化仍不可用，未做密码学或并发实测。
- **Google Slack 集成升级** 需要管理员重装并由用户重新授权，说明权限扩展不能通过内容自动获得。
- **Microsoft Entra agent identity** 的 OBO、application-only 与新旧 Agent 资源模型需分开；新 principal 需要重新赋下游 RBAC。
- **Composio hosted MCP** 可能绕过 SDK hooks；Databricks 普通消费者不应直接获得底层 `USE CONNECTION`。网关之后仍可能存在旁路。

### 模块判断

Identity 正从“存一把 token”转向绑定用户、资源与执行路径的授权生命周期。存储安全、身份绑定、最小权限、撤销时序和审计覆盖必须分别验收。

## 6. Context / Memory / Knowledge

### 本周变化

- **OpenViking v0.4.20（上海时间 9 月 14 日）** 强化 Compile 任务、权限、执行事件和记忆策略；队列的精确目标互斥只在单实例成立，重试不保证 exactly-once，事件记录也有保留限制。
- **Cognee v1.5.4rc1（上海时间 9 月 16 日）** 将混合检索结果组织为带 provenance 的机器可读证据；必须保留 rc 身份，不能把准确率/成本改善当独立实测事实。
- **Mem0** 本周只有依赖维护与文档提交；9 月 9 日晚的插件 release 在窗口前，未挪入本周。
- **supermemory** 本周取得 UI 无障碍维护，没有证据支持重大 Memory API 新发布。
- **Letta** 有旧 Python server 安全报告范围文档变更；新版 SDK 本周增量未取得。
- **Zep/Graphiti** 有 MCP 依赖维护；Graphiti release 在窗前，Zep 商业 changelog 正文未取得。
- **Firecrawl** 有 Bigtable 后端读取提交；Crawl4AI 已查主分支窗口 commits 为空、最新 release 为 8 月 31 日。
- 热扫补入的 ai-memory、Engram、Graphify、CodeGraph 都是模块型基础设施，但没有周增速基线，不做“爆发”排名；Future AGI v1.38.0 于上海时间 9 月 11 日发布，约 2,022 stars 的存量只用于说明扫描优先级，不等于市场领导力。

### 模块判断

Memory 正在成为有身份、版本、来源、加工任务和删除契约的 Context Database。Embedding 只是底层材料，不能代表长期记忆治理已经完成。

## 7. Observability / Eval / Guardrails

### 本周变化

- **LangSmith** 自 9 月 14 日起对新 SaaS extended traces 设最长 180 天；旧 trace、BYOC/self-hosted、dataset 副本与部分 metadata 有不同规则，不能用“180 天”覆盖全部数据。
- **Langfuse v4.37.0（上海时间 9 月 16 日）** 增强 gateway telemetry、敏感字段脱敏以及 TTFB/完整 generation 时延区分；未做真实 provider/Datadog 部署测试。
- **Braintrust bt v0.20.0（上海时间 9 月 15 日）** 修复多 Harness 的 trace 正确性、flush、子任务与恢复/压缩事件。
- **Arize Phoenix v20.10.0 / evals v3.8.0** 在窗口内发布；v20.13.0 已越过上海截止，排除。PII 相关 factory/export 的最终可调用路径未核实，不称在线阻断已完备。
- **OpenTelemetry GenAI #518** 为 tool span 增加 conversation 关联；规范仍处 Development，不是稳定 GA，也不等于所有 SDK 已升级。
- **Coze Loop** 本周维护提交让自动评估标签带 evaluator name/version；没有据此称新平台 release。
- **Future AGI v1.38.0** 带来 Daytona diagnostics、guest collector、tenancy metadata 与 hosted simulation；仓库仍提示 nightly/early testing，release 非 prerelease 不代表全平台成熟 GA。

### 模块判断

Tracing、evaluation、simulation 与 guardrail 回答的是不同问题。LLM judge 不能替代执行前权限，模拟成功也不是生产用户成功率；权威 run/session/turn/tool ID 应先存在，再向 OTel 等后端导出。

## 8. Managed Agent Platform / Enterprise Control Plane

### 七平台能力矩阵

下表描述本次已读材料可支持的能力边界。除最后一列外，多数格是当前能力背景，不是本周全部新发布；“未取得”不等于产品不具备。

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Runtime、session microVM、异步长任务 | 短期 session + 跨 session 长期 store | Gateway 将 API/Lambda/MCP 统一为 tools | workload identity、JWT/OIDC、3LO、Consent portal | managed Browser、Code Interpreter | OTel、Eval sessions、simulation、Guardrails | 9/14 Consent portal；客户案例为具名披露，不外推规模 |
| Google | Agent Runtime/Sessions；GKE Substrate | Memory Bank、RAG Engine 分层 | Agent Gateway/Registry，ADK MCP2 opt-in | Agent Identity、mTLS/DPoP/IAM | Code Execution；Computer/Shell 9/9 仅背景 | Trace、online eval、multi-turn simulation | ADK2.9 恢复语义；9/11 Substrate limited GA allowlist |
| Microsoft | Foundry hosted/prompt agents、VM 隔离 session | Memory Store public preview | Toolbox MCP endpoint、OpenAPI/A2A | Entra dedicated identity、OBO/app-only | Code Interpreter、Playwright Workspaces | OTel/Application Insights、评测与 synthetic query preview | Framework 1.21.0 与文档更新；未核平台新 GA |
| 阿里云 | 百炼/PAI/AgentRun 分层 | Memory 库、RAG、第三方 memory 接入 | plugins/MCP/AgentRun 聚合 | workspace key、RAM/STS，不是统一 OBO | Managed sandbox、FC Agent Sandbox | 应用观测与自动评测有范围限制 | 已查列表未见可核本周重大 Agent 发布，日志滞后 |
| 火山/字节 | AgentKit Runtime；Coze 异步 workflow | OpenViking/Coze memory | Exclusive Gateway、MCP tools | gateway permissions；独立 workload identity 未核 | code/browser/terminal/filesystem | Coze Loop eval/trace | AgentKit 0.8.7、OpenViking 0.4.20 |
| 腾讯云 | ADP/Claw/CloudBase 分层 | 用户×应用隔离，跨模式不迁移 | connectors/tools/skills；统一 managed MCP gateway 未取得 | 企业/workspace 角色、共享凭证引用 | 独立 workspace/code；强 microVM/browser 未取得 | 日志/eval/monitor；OTel 出口未核 | Toolkit 2.34.4；凭证/memory 文档更新非首发 |
| Databricks | Apps/AgentServer/ResponsesAgent | UC、AI Search、managed memory Beta | Unity Gateway/UC MCP services | UC grants、service principal、per-user OAuth | Sandbox Beta；专用 browser 未取得 | MLflow trace/eval | 9/10 connectors GA；9/16 API/工具 GA 为日级边界观察 |

### 平台层判断

企业控制面正在统一管理 runtime、tools、credentials、memory 和 telemetry，但品牌统一不代表单一身份、SLA 或 session store。采购时应优先验证：资源身份是否贯穿 tool execution；恢复是否会重复外部副作用；memory/trace 能否按角色与保留期治理；版本/凭据变更是否能展示影响范围。

## TOP 5：按基础设施格局信号排序

1. **OpenAI Agents API public beta**：Harness 托管化与可替换 sandbox 分离，代表开发范式上移；同时暴露驻留、ZDR 与环境生命周期边界。
2. **MCP Skills + 治理型 Gateway/Consent 组合**：技能内容分发、网关资源治理与终端用户授权开始连接成控制面，而非单纯增加工具数量。
3. **Google ADK 2.9 + GKE Agent Substrate**：从 Harness 恢复语义到专用执行数据面都在处理暂停/恢复，但仍没有统一 exactly-once 保证。
4. **OpenViking v0.4.20**：Context Database 将记忆加工、权限、任务与事件纳入同一系统，Memory 进入治理阶段。
5. **Trace 真实性与保留契约成为核心产品面**：Braintrust、OTel、Langfuse 和 LangSmith 分别校正工具事件、会话关联、时延/脱敏和保留期，Observability 从仪表盘转为生产责任证据。

Databricks 9 月 16 日 Unity Gateway API/SDK GA、Anthropic auto permissions、火山 AgentKit 0.8.7、Langfuse v4.37.0 与 AWS Consent portal 都是强候选；部分被合并到同一结构性信号中，以避免将跨模块事件重复计为多条新闻。

## 对 OpenClaw 的参照建议

1. **把业务任务、conversation/session、sandbox ID、artifact 与外部副作用水位分开持久化。** Session 活着不代表任务完成，sandbox 结束也不应让业务任务凭空消失。
2. **为 resume 建立副作用契约。** 任务 ID、执行 ID、批准事件与幂等键应可关联；需要重执行的步骤显式标注，不可幂等写操作先核结果再重试。
3. **把 credential 与 memory 升级为一等治理资源。** 支持来源、引用详情、变更影响、用户/空间/agent scope、删除/过期和审计，不把“隔离”简化成一个布尔值。
4. **维护权威执行事件，再做 OTel 兼容导出。** Run/session/turn/tool 的真实 ID、resume/compaction、子任务和最终交付事件不能由旧 transcript 猜出来。
5. **分开业务完成、发布完成与投递完成。** UI 重连、runner 状态或消息发送结果都不能替代产物、Git、HTTP 与最终用户交付证据。

## 覆盖、取证与局限

- 实际覆盖：**8/8 模块、7/7 平台矩阵**。四条研究线共交回 66 个不可覆盖分片；对象口径各线去重后分别为 A 15、B 18、C 19、D 28，因跨模块对象和矩阵映射存在重叠，不相加为全刊唯一对象数。
- 固定对象责任：A 模块 1 为 7/7、模块 8 为 7/7；B 模块槽位 19/19；C 固定槽位 16/16；D 固定对象 19/19。
- 来源记录：A 75、B 82、C 83、D 121 条可定位记录。它们是 URL/原始记录，不等于相同数量的独立发布方或全文；同机构 release、PR、commit 也不算独立二源。
- GitHub/Web 热扫完成主题要求的 9 个方向。首次并发中 8 项入口遇到 xAI 403，随后通过 Brave 逐项重试；`agent context database github` 为 0 结果。0 结果不解释为市场无动态，OpenViking等固定对象另做直查。
- 风险导向抽查超过 5 项，重点覆盖 OpenAI 驻留/ZDR、ADK 重执行副作用、Anthropic custom tool 权限、OpenClaw 发布与重放、Databricks日末边界、AWS客户数字分母、MCP批准失效、Memory scope 与 trace 留存。
- 未做独立生产性能、攻击、密码学、多租户隔离、客户采用或 ROI 实测；供应商 benchmark 和效果数字没有被升级为独立事实。
- 多个页面只有文档更新时间、Atom `updated` 或自然日，不能证明首次发布精确时刻。窗口外或边界不明事件已排除、降为背景或边界观察。
- AWS个别博客、Zep商业 changelog、Coze SaaS与部分国内云发布入口未能完整取得；其余可信事实继续采用，不把“本次未取得”写成“不存在”。
- GitHub匿名 API 后段出现限流，改用公开 HTML/Atom；未换 IP、凭据或关闭检查。

## 研究准出结论

拟采用内容均已按原始事实、具名披露和有限佐证分开处理；重大无源数字、搜索摘要、误导性时间归属与未经验证的效果结论已排除或限述。剩余缺口不会破坏主体结论，也不存在隐私/授权风险。**研究母稿 PASS，可进入文章编辑；上述局限必须保留。**
