# 全球 AI Agent 基础设施研究周报（2026-11-12 / 第 21 期）研究母稿

- 冻结窗口：2026-11-05 00:00 ~ 2026-11-11 24:00（Asia/Shanghai）；资料读取截至 2026-11-12 上午（+0800）
- 期号：第 21 期。上期已发布为第 19 期（2026-10-29，窗口 2026-10-22~10-28）；第 20 期（2026-11-05）缺期，本期不补做、不扩窗。周环比对照第 19 期。
- 口径：GitHub release 正文、官方 changelog/release notes/产品公告、官方文档为 A 级一手依据；厂商自述数字标 B；月级归档、未逐条标日的条目只写「11 月档」，不计为确定窗内事件；周档 changelog 标 D 级日期。GitHub 时间取 release 页显示的发布时刻折算 +0800。
- 工具约束：`WebSearch` 在本环境返回 403（Volcano Ark 未开通），本期发现层改用「已知一手入口直取 + GitHub Trending / Search API + HN 首页 + 厂商 blog index」；未使用需要搜索的入口。该约束与影响写入局限。
- 本期主线：**Agent 基础设施开始把 Agent 当「默认不可信」的租户来设计**——执行侧用硬件隔离与证明链换取密钥（AWS Nitro Sandboxes / EKS isolated & confidential pods），治理侧用可验证的 Agent 身份与跨云控制面统一裁决（Google Agent Gateway cross-cloud、Agent Registry），凭证侧则把「谁能看到 key」收紧到调用路径（Claude Code v2.1.321、OpenClaw v2026.11.3）。判断依据不再是网络位置或集群边界，而是**证明**（硬件度量 / 身份断言）。

## 0. 主线专题（机制级深挖）：默认不可信——证明取代位置

### 0.1 一句话与三条支撑

**本周的分水岭不是某个功能发布，而是信任假设改写：Agent 跑在哪里不再决定它被信任多少，能不能出示证明才决定。**

- **执行侧**：AWS 11-09 把「每个 pod 一个硬件隔离 microVM」做成 EC2 原语（Nitro Sandboxes），并在 confidential 模式下用 NSM 度量 + KMS 策略把密钥只释放给「度量值匹配」的沙箱。
- **治理侧**：Google 11-11 把 Agent Gateway 延伸到 EKS/AKS/OpenShift/裸金属，11-10 再把跨项目治理做成 hub-and-spoke；集群外 agent 靠 SPIFFE 式 Agent Identity、注册表与本地 Envoy 代理接受集中策略，默认拒绝。
- **凭证侧**：Claude Code v2.1.321 修「MCP OAuth 在重定向时把 refresh token 发给另一台主机」，OpenClaw v2026.11.3 把插件缓存与搜索结果按连接凭证作用域隔离——凭证不再因为「在同一次会话里」而被复用。

### 0.2 执行侧：Nitro Sandboxes 的隔离与证明链（A）

**做了什么。** 2026-11-09，AWS 发布 [Nitro Sandboxes](https://aws.amazon.com/about-aws/whats-new/2026/11/nitro-sandboxes-eks-ecs-ec2/)，并在 EKS 以 [isolated / confidential pods](https://docs.aws.amazon.com/eks/latest/userguide/sandboxing.html) 形式提供：每个 pod 跑在自己的轻量 VM 里（EC2 文档写明 VMM 当前为 Firecracker），由 Nitro Hypervisor 强制内存与 CPU 隔离；EKS 侧只需把 `runtimeClassName` 设为 `isolated-sandbox` 或 `confidential-sandbox`（要求 Kubernetes 1.36+），官方称对 EKS/ECS 是「one-line change」。同一周 11-11，[Lambda MicroVMs 增加 x86](https://aws.amazon.com/about-aws/whats-new/2026/11/aws-lambda-microvms-x86-architecture/)，把「不为 agent 生成的代码管实例和网络」的另一条路径补齐到 x86。

**怎么做到的（机制）。** 按 [EC2 用户指南](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-ec2-nitro-sandboxes.html) 与 EKS 文档，链路是：

1. **边界**：Nitro Sandbox 是 parent EC2 实例旁的轻量 VM，VMM（当前只有 Firecracker）通过 Nitro Enclaves driver 创建，Nitro System 执行隔离；沙箱代码不能访问 parent 内存，只能经虚拟设备通信。confidential 模式下 Nitro System 把沙箱内存从 parent 中移除，parent 及其管理员既不能读也不能改。
2. **证明**：confidential 模式在沙箱内提供 Nitro Security Module（NSM），度量启动镜像、启动设置、启动时的虚拟设备与 parent 实例身份，并签出 parent 无法伪造的 attestation document。**AWS KMS 只在 document 匹配 key policy 时释放密钥**；EKS 文档明确要求用 `kms:RecipientAttestation:PCR<PCR_ID>` 条件绑定具体 PCR 值，否则「度量被记录但从不校验，confidential 的保证不完整」。
3. **策略也在证明范围内**：EKS 侧每个 pod 有一份 Cedar 策略，由 `eks-nitro-sandbox-genpolicy` 从 pod spec 生成，作为 annotation 下发到 parent 的 shim 与 guest 内 agent；策略在 guest 内执行，因此 parent 不可信时仍然生效，且**策略被度量进 attestation register**——被攻陷的 parent 无法悄悄替换策略而不改变度量值。
4. **镜像与数据**：OCI 镜像层可在沙箱内用 KMS 解密（parent 只搬密文）；镜像启动前校验 AWS Signer（Notation）签名与吊销状态。
5. **两种信任模式**：isolated 模式信任 parent、保护节点与其他 pod（允许 exec/logs/stats，不复制 service account token）；confidential 模式不信任 parent，策略钉死所有 admission 字段（镜像 digest、args、env、mounts、capabilities、安全设置），拒绝 exec/stdin/进程列表，允许 IMDS 与 service account token 以便向 KMS 取密钥。
6. **断网模式**：`sandbox.amazonaws.com/network-isolated: "true"` 让沙箱**根本没有网络设备**（无 TAP、无 virtio-net、无 DNS/NTP/IMDS/Pod Identity），而不是靠过滤；但 guest 内 vsock 仍可达 guest-bound 端口，官方明确「不是绝对隔离」。

**约束要一起读**：不支持 flex 实例；无 GPU passthrough；不支持 snapshot/restore、pause/resume、live migration；parent 能读它呈现给沙箱的每个块设备（EBS 加密也不防 parent），机密数据必须在沙箱内加密；沙箱经 NAT 可到达 parent 的 IMDS 并读到其 IAM 角色凭证，需在 parent 上拒绝到 `169.254.169.254` 的流量。

**意味着什么。** 对平台工程师，「跑不可信代码」的选择从「容器 + seccomp + 网络策略」变成「microVM + 度量 + KMS 条件」；隔离强度第一次可以用「密钥是否释放」来验证，而不是靠配置审计。代价是密度与运维复杂度：vCPU 超额分配、每沙箱 256 MiB 内存下限、每 vCPU 最多 5 个沙箱、单实例最多 896 个，且不能热迁移。

### 0.3 治理侧：Agent Gateway 跨云与跨项目（A）

**做了什么。** 2026-11-11，Google 以 Limited Preview 发布 [Agent Gateway for cross-cloud](https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes)：把 Agent Platform 的治理扩展到 Google Cloud 之外的 CNCF 兼容 Kubernetes（EKS、AKS、OpenShift、裸金属），agent 留在原环境，身份、注册表与 LLM/MCP/A2A 流量由集中控制面治理。11-10 的 [cross-project governance](https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/policies/configure-semantic-governance.md.txt) 则把同一套策略做成 hub-and-spoke：一个管理项目对多个成员项目的 agent 统一授权与执行策略。

**怎么做到的（机制）。** 按 [overview](https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents/governance/agent-gateway-cross-cloud/overview.md.txt)、[setup](https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents/governance/agent-gateway-cross-cloud/setup.md.txt)、[enforce-policies](https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents/governance/agent-gateway-cross-cloud/enforce-policies.md.txt) 与 [deploy-agents](https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents/governance/agent-gateway-cross-cloud/deploy-agents.md.txt)：

1. **三面分离**：SaaS 管理面（Agent Registry、Model Armor、IAP、Workload Identity Federation、Cloud Observability）在 Google；跨云控制面是「全局共管的 xDS 控制面」，控制器 `agent-governance-cross-cloud-controller` 跑在客户集群里，watch Service/工作负载/CR 并同步到云端；数据面是客户命名空间里的 Envoy Agent Gateway 代理，每个代理带一个 **AIR（Agent Identity Runtime）sidecar** 代理工作负载身份与证书。
2. **接入**：用集群的 OIDC issuer + JWKS 注册集群（`gcloud alpha network-services registered-clusters create`），建 Workload Identity Federation pool/provider，claim 映射 `google.subject`、`namespace`、`service_account`；Helm 安装控制面 `0.1.0-preview` 到固定命名空间 `geap-system`。
3. **身份**：工作负载用 projected KSA OIDC token（`expirationSeconds: 3600`）放在 `Proxy-Authorization`，经 WIF 换成 Agent Identity；代理转发前剥掉该 header。`Model Armor and IAP policies identify agents by their Agent Identity`，principal URI 含组织/项目、项目号、location、集群、命名空间与 KSA。
4. **注册**：给 Deployment 打 `apphub.cloud.google.com/functional-type: AGENT`（或 `MCP_SERVER`）标签，控制器自动注册；它按 `a2a-protocol.org/agent-card` 注解（默认 `/.well-known/agent-card.json`、HTTP、8080）抓 Agent Card 填充注册项，MCP 能力取自 `modelcontextprotocol.info/urls` 与 `.../capabilities` 注解，成功后写入 `agentregistry.cloud.google.com/service-uri`。若 Agent Card 需要认证，抓取失败但 agent 仍注册，只是缺详情。
5. **策略求值**：用 `GCPExtensionBinding` 把云端的 Model Armor 模板与 IAP 策略绑到本地网关；`targetRefs` 选网关，`producerExtension` 选 `modelarmor.LOCATION.rep.googleapis.com` 或 `iap.googleapis.com`，`failOpen` 控制未筛查流量（官方建议 false）。Model Armor 筛 prompt injection / jailbreak / 有害内容；IAP 按 Agent Identity 求值 IAM allow 策略。**代理连不上 Google Cloud 时一律阻断（403/500），即使 `failOpen: true`**；模板不存在返回 404。IAP 支持 `DRY_RUN` 先看日志不拦。
6. **跨项目**：在 folder/org 上配 `BoundaryConfig` 与带 `AGENT_MANAGEMENT` 能力的 `CapabilityConfig`，指定管理项目；Agent Registry 自动发现成员项目的 Agent Runtime agent，并保留其 `RuntimeIdentity`（`principal://...`）。成员 agent 需以 `identity_type=AGENT_IDENTITY` 部署，且 `agent_to_anywhere_config.agent_gateway` 指向 hub 网关；**只有管理项目里定义的策略生效**，成员项目不需要各自的策略引擎。
7. **统一点**：管理面文档把 Agent Gateway 描述为「所有 agentic 交互的软件定义网络出入口」，每个 agent 分配 SPIFFE ID，mTLS + DPoP 保护，IAM 默认拒绝（`all connections are blocked unless an explicit IAM policy grants access`），单网关最多治理 5,000 个注册资源。

**限制与风险**：Limited Preview 需申请；控制器创建的根 CA 私钥存在 `geap-system` 与网关命名空间的 Secret 中，「能读这些 Secret 的人可以冒充外部端点」，文档要求隔离命名空间、禁用默认 SA 的 token 自动挂载、KMS 加密 Secret、审计 Secret 读取；网关报告 ready 后最多还有 2 分钟才在 8443 接受连接；同一项目下不同集群的 service URL 必须唯一。

**意味着什么。** 控制面第一次明确「可以不在运行时所在的云」：治理的落点是身份 + 注册表 + 本地代理，而不是把工作负载迁进某家云。对架构负责人，这改变了平台选型的问题——从「用哪家云的 agent runtime」变成「谁的目录、身份与策略能覆盖我所有集群」。同时它把一个新的高危面摆上台面：本地根 CA 的私钥就是新的信任根。

### 0.4 凭证侧：从「会话内复用」到「按调用作用域」

- **Claude Code v2.1.321（11-09）**：修 `MCP OAuth requests sending secrets such as refresh tokens to another host when a server redirected them`；v2.1.319（11-06）新增 `permissions.denyInsteadOfPrompting`——会等待授权提示的工具调用直接拒绝、回合继续，把「无人值守时默认放行」改成「默认拒绝」。
- **Claude Code v2.1.319 同时修三处沙箱/权限边界**：只读 Bash 命令不经提示在沙箱外执行、`cp`/`mv` 写入目录时 deny 规则与受保护文件提示不生效、Bash 权限检查用错目录；另有 `Fixed a sandbox escape when creating a worktree`。
- **OpenClaw v2026.11.3（11-10）**：复用与缓存的插件结果按连接凭证作用域隔离、其他插件的 transport hook 留在 provider origin；Firecrawl 搜索/抓取 key 绑定各自 scoped endpoint、embedding 凭证绑定目的地；配置读取中的内联环境凭证与 Exa 错误中的搜索凭证做脱敏；托管 Signal daemon 与语言服务器不再继承无关 Gateway secret。
- **OpenClaw v2026.11.2（11-08）**：`CLI child PATH excludes workspace-controlled mise/XDG paths`、条件配置变更不再把 secret 写进审计历史、沙箱化 web search 执行 provider trust policy。

**意味着什么。** 「Agent 能用的凭证」与「Agent 能看见的凭证」正在被拆成两件事：凭证可以注入执行环境，但不出现在模型上下文、子进程环境、错误日志与跨主机重定向里。自建 Harness 可以把这四条当检查清单。

### 0.5 与上期的关系（周环比锚点）

第 19 期的主线是「恢复不重放 + 策略执行点下沉到工具网关」：策略被放进网关，网关是单点。本期这条线继续走了一步——**网关本身离开云、目录成为治理清单、身份成为策略主语**。上期问「策略在哪个点执行」，本期问「这个点凭什么是可信的」：Nitro 用硬件度量回答，Google 用 Agent Identity 与默认拒绝回答，Claude Code/OpenClaw 用凭证作用域回答。
## 1. Harness / Agent OS 控制层

### 本周模块结论

1. **主战场从「能不能跑 agent」移到「执行期的控制语义」**：权限遇到提示怎么降级、长时工具调用怎么脱离前台、沙箱边界怎么守、会话被中断后状态怎么续。五个主要框架里四个发出需要改代码或改配置的变更，且方向一致——**默认更严**。
2. **「拒绝」成为一等控制流。** Anthropic `permissions.denyInsteadOfPrompting` 把本该弹窗等待的调用直接判 deny 且不终止 turn；微软把空 HTTP allowlist 定义为拒绝一切；ADK 对自由形式 `command` 返回 `INVALID_ARGUMENTS`。三者都把「不确定时」从「问人」改成「确定性失败」——这是无人值守编排的前提，代价是升级后会出现「以前能跑、现在被拒」。
3. **长任务从「占前台」转为「可后台」，并要求归属可持久化。** MCP task 进入 Claude Code 终端与 TS SDK；OpenClaw 处理「取消子任务后的交接回执」；LangGraph 给每个 `interrupt()` 独立 id 并加 strict resume。共同问题是：异步完成必须能回答「这是谁的、对应哪一次请求」。
4. **「判定」独立成原语，三周内三家撞车。** `langchain-core 1.8.0` 的 `BaseDecisionModel`、OpenAI 的 Decisions API、Google 11-11 的 `gemini-decision-1` 指向同一抽象：把路由/准入/评审从「生成文本再解析」变成结构化调用。LangChain 同日把 ModelRouter 做成中间件，但 classifier 必填、仍是 beta。
5. **沙箱安全从「隔离存在」转向「判定实现正确」。** 本周密集出现的是路径大小写、符号链接、引号包裹、env 前缀、`cp`/`mv` 目标文件、worktree 创建这类实现级漏洞（Anthropic 一批、OpenClaw 一批）。沙箱的价值取决于权限判定与目标解析是否一致，而不取决于是否用了 VM。

### 固定对象状态表

| 对象 | 窗口内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| OpenClaw | 有动态（4 个版本） | v2026.11.1 / 11.2 / 11.3 / 9.37 | A |
| Anthropic Claude Code / Agent SDK | 有动态（CC 3 个、TS SDK 3 个、Py SDK 2 个） | v2.1.319 / 321 / 322 | A |
| OpenAI Agents SDK | 有动态（py/js 各 1 个 alpha，同日） | v0.24.0-alpha.7 / v0.22.0-alpha.2（11-08） | A/B |
| LangChain / LangGraph / LangSmith | 有动态 | LangGraph 1.2.20（11-05）、langchain 1.5.0 + core 1.8.0（11-11） | A |
| Google ADK | 有动态（仅 Python） | v2.14.0（11-07，notes 标 11-04） | A |
| Microsoft Agent Framework / SK / AutoGen | 有动态（AF 2 个、SK 2 个、AutoGen 无） | python-1.25.0、dotnet-1.28.0 | A |
| Databricks Mosaic AI / Agent Bricks | 本次未取得日级日期（月档） | 页面戳 2026-10-29 | D |
| Dify | 无动态（v1.19.0 = 11-04，窗外） | — | A |
| CrewAI | 有动态（5 个补丁版） | 1.15.36–1.15.40 | B |
| pydantic-ai | 有动态 | v2.67.0（11-10） | B |
| trueforge | 本次未取得（2 个入口 404） | — | — |

### 深拆条目

#### Anthropic Claude Code：permission prompt 变成可编程的拒绝点（A）

**做了什么。** v2.1.319（11-06）三件事：`permissions.denyInsteadOfPrompting`——本该等权限弹窗的工具调用直接判 deny、turn 继续，覆盖终端、subagent 与 teammate；MCP tasks 进终端——MCP server 以 task 运行工具调用时，Claude Code 立即移到后台、完成后再告知 Claude，并提供 `CLAUDE_CODE_DISABLE_MCP_TASK_BACKGROUND` 退回同步等待；修一批权限判定漏洞（引号包裹的 Bash 命令漏判、`sed` 在 accept-edits/auto 模式可跳过检查、构造 env 前缀隐藏命令片段、`/rewind` 经目录符号链接恢复/删除文件、创建 worktree 时的沙箱逃逸）。v2.1.321（11-09）修 **MCP OAuth 重定向把 refresh token 等凭据发往另一 host**；v2.1.322（11-10）把 fast mode 扩到 Vertex 的 global/us/eu。TS SDK v0.3.319 对齐：`CLAUDE_AUTO_BACKGROUND_TASKS=1` + `task_type: "mcp_task"`。

**怎么做到的。** `denyInsteadOfPrompting` 的控制流改动很小、语义很大：原本 prompt 是等待态（阻塞 turn），新设置把它改成**拒绝态且不终止 turn**——deny 结果作为工具结果返回，模型可自行改道。这把人工审批从必经路径降级为可选路径，默认更保守（拒绝而非放行）。MCP task 后台化要求 harness 维护「任务 → 会话」归属表，否则 `--resume` 后结果会丢（同版本修了「恢复后长时 MCP 调用不报结果」）。OAuth 泄密的修法是按 issuer/origin 绑定凭据，重定向到异源即不附带。

**意味着什么。** 这是本周最可直接采购的能力：CI、后台 agent、teammate 编排在「无人应答」时**确定性失败而非挂死**。迁移动作是审查现有 allow/ask 规则——原来靠「反正会弹窗」兜底的危险工具，现在会直接 deny。一周内 3 个补丁版本密集修沙箱逃逸与权限绕过，说明攻击面已从「提示注入」转向「权限判定的实现细节」。

#### OpenClaw：把「未应答的工具失败」从静默成功改成显式失败（A，必覆盖）

**做了什么。** 四个版本（会话/cron/Gateway 侧见模块 2）。harness 侧的实质变更：v2026.11.1 新增 `plugins.entries.anthropic.config.managedNativeTools` 开关控制原生 Agent/Workflow 编排（默认关）、Claude CLI 保存的订阅账号可在不原生登录时暴露配置模型；v2026.11.2 把敏感回复/postback/SDK/tool-error/language-server 内容从日志脱敏、审批需单一 target、**工作区可控的可执行路径从子进程 `PATH` 剔除**、暖复用 CLI 后清空 MCP grants；v2026.11.3 的 #182458 把「工具没有回音」从静默成功改为显式失败（`Report unanswered tool failures instead of silently ending a user-addressed turn as a success`），#176203 让 required-sandbox 的图片预览即使在 Full Access 模式下也不越出允许目录，#178444/#177974/#189423 把插件结果绑定到连接凭据、其他插件 transport hook 留在 provider origin，#190706/#184966 把 Firecrawl key 绑定到 scoped endpoint，#179198/#179415 让 Signal daemon 与内置语言服务器不继承无关 Gateway secrets。

**怎么做到的。** 这里的共同机制是**凭证与执行路径的绑定**：`PATH` 剔除是防止工作区里的同名二进制被当成系统命令执行；插件结果绑定连接凭据是防止 A 插件的输出被 B 插件当作可信输入；Firecrawl key 绑定 scoped endpoint 是让一个 key 只对一类端点有效。而 #182458 是控制流修复：工具调用无响应时，turn 不能以「成功」结束——否则上层编排会把「没做事」当成「做完了」。

**意味着什么。** 对自建 agent 平台，这三类修复可直接抄进评审清单：子进程 `PATH`、插件间的凭据/结果隔离、工具无响应的失败语义。OpenClaw 一周四版（含一次退役线回补）说明高频迭代的 harness 已进入「安全债偿还」阶段；采购方应锁定 `extended-stable`（9.37）而非 latest。

#### OpenAI Agents SDK：两个语言同日同构，会话存储交给应用（A/B）

**做了什么。** 11-08 Python `v0.24.0-alpha.7` 与 JS `v0.22.0-alpha.2` 同日发布同一批能力：应用自有会话存储 `SessionStore`/`SQLiteSessionStore`/`CustomStorage` 持久化 root history；`RunBudget` 限制 root 请求准入并上报 token 或估算成本；provider 托管工具 `FileSearch`/`CodeInterpreter`/`ImageGeneration`；MCP 资源与提示（`list_mcp_resources()`、`read_mcp_resource()`）与**重连不重放**；`Environment.local()` 让受支持的工具本地执行 + `project_glob`/`project_grep`；JS 侧另有 exact-step steering（`turn.steerExact()`）、`maxModelSteps`、A2A 1.0、`TraceContext` 显式传播、`responseIntegrityReason`。平台侧窗口内只有 11-05 的 `gpt-6-cyber`。

**怎么做到的。** `RunBudget` 只对 **root request admissions** 计数，子代理继承而非各自新开预算——成本闸门放在编排树根，避免递归放大。`steerExact()` 把「用户插话」从「下一轮再说」改成对**当前 step** 的精确干预，并以 acceptance receipt 确认被采纳；配合 `maxModelSteps` 形成「可中断且可终止」的执行环。`response_mode="buffered"` 读完整 HTTP JSON 再解析，等价于放弃 SSE 增量换取可重放/可校验，与只读的 `responseIntegrityReason` 配套。MCP 重连不重放：结果未知的调用不自动重试，把不确定性上抛。

**意味着什么。** 两个 SDK 同日同构说明 OpenAI 把 harness 语义做成了**跨语言一致契约**，迁移成本从「重写」降为「换包名」。`SessionStore` 由应用拥有，等于把会话状态从 SDK 内部挪到开发者数据库——企业采购「数据不出域」的硬要求。仍是 alpha，不建议生产锁定。

#### LangGraph strict resume + LangChain decision model：恢复要可验证，判定要可类型化（A）

**做了什么。** LangGraph 1.2.20（11-05）：每个 task 内的 `interrupt()` 获得独立 id；新增 strict resume 模式，**拒绝陈旧的 interrupt 答案**；SDK 把 `strict_resume` 暴露到 `runs.create`/`stream`/`wait`。LangChain 1.5.0 / core 1.8.0（11-11）：`BaseDecisionModel` 进 core，选项类型含 `Choice`、`Score`、`Noul`（未知键一律拒绝）、`Box`（图像区域 + 可选置信度）；`ModelRouterMiddleware` + `AutoModeMiddleware` 从 `langchain-typesafe` 移植进来，classifier 变为**必填**（理由：「LangChain cannot choose a provider by default」），判定阈值 0.5。

**怎么做到的。** interrupt 身份化 + strict resume 是把 durable execution 的「至少一次」收紧为「恰好一次语义可验证」：过去同一 task 内多个 interrupt 共享标识，恢复时无法区分「回答的是哪一个」，现在答案对不上就失败。decision model 把「判定」抽象成带类型的 question→answer，provider 只提供后端，中间件消费结果；`Noul` 拒绝未知字段保证跨 provider 反序列化不静默丢字段。值得注意的是 AutoMode 文档删掉了早期「fail-closed」与「仅显式用户消息授权执行」的表述，`trace_policy` 从 authorization context 改为 conversation context——实际语义比宣传弱，接入方需在外层自加 deny 规则。

**意味着什么。** strict resume 直接决定 HITL 工作流能否安全重放：以前「用户批了但批的是旧中断」会静默放行，现在会失败，升级方需处理新的拒绝路径。decision model 与云的 decision API 同周出现，说明「路由/判定」正从 prompt 技巧变成 SDK 内建中间件；但 LangChain 版本 classifier 必填、仍 beta，落地成本高于托管 API。

#### Google ADK 2.14：沙箱抽象转 stable，脚本执行改结构化参数（A）

**做了什么。** v2.14.0（releases 标 11-07，notes 标 11-04）：`BaseEnvironment`、`LocalEnvironment`、`EnvironmentToolset`、`DaytonaEnvironment`、`E2BEnvironment` 转 stable（本轮 26 个 auth/environment/app/CLI/cache 模块与 16 个 toolset/integration 特性转 stable），A2A 集成转 stable，CLI 新增 `adk generate_agent_card`；Local/E2B/Daytona 支持分块流式读文件、`ReadFileTool` 可按行区间读取；`AgentEngineEnvironment` 把超过 570 秒的命令判超时；`RunSkillScriptTool` 不再接受自由形式 `command`，改为 `args`/`short_options`/`positional_args`，脚本从 skill 目录运行、仅支持 `.py`/`.sh`/`.bash`；breaking：枚举类型工具参数现在收到 enum 成员而非字符串，`VertexAiSessionService.create_session` 只接受白名单参数。

**怎么做到的。** `BaseEnvironment` 把「执行环境」抽象成可插拔后端（本地/E2B/Daytona/Agent Engine），`EnvironmentToolset` 在其上暴露文件与命令工具；分块流式读取让工具不再把整个文件读进上下文。`RunSkillScriptTool` 的改动是**以参数化替代 shell 字符串**：把注入面从「字符串转义是否正确」降为「参数是否在允许集合内」——同类修复里成本最低、收益最确定的一种。官方原话：「The change closes a prompt-injection path to arbitrary shell execution.」

**意味着什么。** 环境/沙箱层转 stable 意味着 ADK 可承接代码执行类 agent 的生产部署。枚举参数 breaking 会静默打断既有工具实现（字符串比较、字典查找、`match`、`json.dumps` 都可能失效），升级前需全局搜 `Enum` 类型工具签名。

#### Microsoft Agent Framework：一批 breaking，方向全是「默认更严」（A）

**做了什么。** `python-1.25.0`（11-07）与 `dotnet-1.28.0`（11-06）集中五项 breaking：live workflow-agent executor 与会话绑定**单一授权作用域**，跨作用域在模型调用前拒绝，`WorkflowAgent.as_tool()` 在 AG-UI 端点被拒；workflow 遥测改按 OTel GenAI 约定（span 名与属性变化）；declarative MCP 每次 handler 调用新建协议会话、不再缓存，`cache_max_size` 弃用；Hyperlight 与 Monty 默认对 host-tool 异常细节脱敏；declarative workflow HTTP 需显式 host/port allowlist，**空 allowlist 拒绝所有请求**。另有 MCP 发现审批策略（按工具名/只读过滤、刷新时重新评估）与 Foundry Toolbox 审批元数据、dotnet 侧 Foundry GA computer tool 与 A2A 改 message-only。

**怎么做到的。** 单授权作用域绑定解决的是多租户复用同一进程时的凭据串用；每次调用新建 MCP 会话是主动放弃「服务端用上下文关联两次调用」的能力，换取无隐式会话连续性；空 allowlist 拒绝一切是修「忘了配就是全开」的默认值错误。`as_tool()` 在 AG-UI 被拒、A2A 改 message-only，说明微软在收紧「agent 即工具」的递归编排，减少不可控调用树。

**意味着什么。** 升级即行为变更，必须按清单回归。Semantic Kernel 同期也移除 Python 3.10（python-1.47.0 要求 3.11+），微软系 SDK 运行时基线整体抬到 3.11+。

#### Databricks/Dify/CrewAI/pydantic-ai：月档、窗外与补丁（B/D）

- **Databricks**：产品 release notes 为月档索引，页面戳 2026-10-29，11 月条目未标日，索引未出现 Agent Bricks/Mosaic AI 字样。月档可见 Unity Gateway 上架 Fable 5.2、Gemini 4 Carbon、Kimi K3.1 Pro，Smart Routing「只路由子代理」（Beta），AI Functions 用量纳入网关预算——**全部标背景，非本周**，不作事件计入。
- **Dify**：v1.19.0 发布于 11-04，窗外一天，本周无动态。
- **CrewAI**：1.15.36–1.15.40 五个补丁版，引入实验性会话式 `sessions`、全系默认模型改 `gpt-6-luna`、从 embedding 层移除 ChromaDB——机制细节未取得，按 B 级记录。
- **pydantic-ai**：v2.67.0（11-10）扩展 durable execution——动态 `SubAgents`、DBOS 子工作流、`task_control` 把取消/暂停/优先级交给 Temporal/DBOS 而非进程内调度，新增 `dequeue` 与 `set_enqueue_priority`。
- **trueforge**：两个入口（`github.com/trueforge`、`github.com/trueforge-ai`）均 404，本次未取得，不计入。

### 模块洞察

1. **「拒绝」成为一等控制流，默认可用性换默认安全。** 迁移评估要新增一栏：「升级后哪些原本靠人工兜底的路径会确定性失败」。这类变更不会在测试里报错，会在无人值守的凌晨暴露。
2. **异步完成的归属表是 harness 的硬基础设施。** MCP task、子代理 handoff、interrupt id 三件事都要回答「这是谁的」。把归属表做进持久层的项目，才能在 `--resume`/重启后不丢结果；没做的，会在长任务上反复踩「完成回执找不到主人」。
3. **沙箱的价值取决于判定实现，不取决于隔离技术。** 本周的漏洞全在路径解析、符号链接、引号、env 前缀、`cp`/`mv` 目标这些实现层。采购时应问「权限判定与文件写入是否用同一套目标解析」，而不是「你用了什么沙箱」。
4. **判定模型正在成为跨厂商原语。** `BaseDecisionModel`、OpenAI Decisions API、`gemini-decision-1` 三家在三周内撞车。对架构的含义：路由、准入、评审可以作为结构化调用嵌入中间件，但「谁来定义阈值与回退」仍留在应用侧。
5. **托管 harness 正在成形（见模块 8）。** 微软 Copilot harness 与 AWS Strands-powered harness 把「循环 + 沙箱 + 工具」打包成服务；开源 harness 的差异化将集中到**权限语义与可观测性**，而不是工具数量。

### 来源（模块 1）

- OpenClaw Releases｜https://github.com/openclaw/openclaw/releases ｜https://docs.openclaw.ai/releases/2026.11.2
- Claude Code Releases / CHANGELOG｜https://github.com/anthropics/claude-code/releases ；https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
- Claude Agent SDK (TS / Python)｜https://github.com/anthropics/claude-agent-sdk-typescript/releases ；https://github.com/anthropics/claude-agent-sdk-python/releases
- OpenAI Agents SDK｜https://github.com/openai/openai-agents-python/releases ；https://github.com/openai/openai-agents-js/releases
- LangGraph / LangChain｜https://github.com/langchain-ai/langgraph/releases ；https://github.com/langchain-ai/langchain/releases ；PR #41765 / #41766
- LangSmith Changelog｜https://docs.langchain.com/langsmith/changelog
- Google ADK｜https://github.com/google/adk-python/releases/tag/v2.14.0
- Microsoft Agent Framework / SK / AutoGen｜https://github.com/microsoft/agent-framework/releases ；https://github.com/microsoft/semantic-kernel/releases
- Databricks｜https://docs.databricks.com/aws/en/release-notes/product/
- CrewAI｜https://github.com/crewAIInc/crewAI/releases ｜pydantic-ai｜https://github.com/pydantic/pydantic-ai/releases ｜Dify｜https://github.com/langgenius/dify/releases
## 2. Runtime / Session / State 运行时与会话状态

### 本周模块结论

1. **runtime 层的变量不是「更快」，而是「会话成为计价与隔离的单位」。** AWS AgentCore Runtime V2 把「每会话独占一份预热环境」换成「从快照恢复 + 内存按需伸缩」，200MB–2GB 镜像的 P75 冷启动压到约 2 秒（旧 runtime 同区间从 5.4 秒恶化到接近 30 秒），单会话并发连接从 16 提到 250；Anthropic 把对话历史留在服务端按增量计费；OpenClaw 把 `/reset` 的权威写入方移到 Gateway。三件事指向同一处：平台不再承诺「你的进程一直活着」，而是承诺「你的会话可以被重建」。
2. **状态模型在向「服务端持有会话」收敛，但各层的「服务端」不是同一个。** Anthropic 放在模型 API，OpenClaw 放在 Gateway，AWS 放在 runtime 控制面。迁移平台时最容易被撞的是这一层：会话存在哪、谁有权重置、按什么计量。
3. **控制面先于执行面跨云。** Google 11-10 / 11-11 连发跨项目语义治理与跨云 Agent Gateway，把 EKS/AKS/OpenShift 上的 agent 纳入同一策略面；AWS 把 Agent Registry 推进 GovCloud。治理层可以先行统一，执行层仍长期多云。
4. **国内三家分化明显。** 百炼更新日志窗口内零条目（最新 2026-10-21，已核验）；腾讯只有 11-09《AgentPortal 开放使用公告》标题；火山方舟两个入口均无可机读的带日期条目。这是「没有可核验的公开动作」，不是「没有动作」。

### 固定对象状态表

| 对象 | 窗口内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| AWS AgentCore Runtime | 有动态（月级日期 + 11-09 旁证） | V2 快照启动、P75≈2s、250 并发/会话、MCP `2026-07-28`、`OverheadLatency` | A/B |
| Google Agent Runtime / Agent Gateway | 有动态 | 11-11 跨云 Gateway、11-10 跨项目治理、11-06 Memory Bank 控制台 | A |
| Microsoft Foundry Hosted Agents | 有动态（1 条窗内 + 1 条月度综述） | 11-05 `microsoft.foundry` azd 扩展 1.0 GA；长时任务韧性 GA（属 10 月） | A/B |
| 阿里云百炼 / Model Studio | 无动态（已核验） | 更新日志最新 2026-10-21 | A |
| 火山方舟 / Coze | 本次未取得 | 两入口均为导航页/空页 | — |
| 腾讯云 ADP | 有动态（仅标题） | 11-09 AgentPortal 开放使用公告 | C |
| OpenClaw sessions/cron/Gateway | 有动态（4 个版本） | v2026.11.3 / 11.2 / 11.1 / 9.37 | A |
| E2B / Modal / Daytona | 无窗内 runtime 语义变更 | E2B 最新 11-04；Modal 10-27 exit snapshot；Daytona 11-05/11-07 薄 | A/B |

### 深拆条目

#### AWS AgentCore Runtime V2：快照恢复取代冷引导（A/B）

**做了什么。** 平台先准备一次环境并打快照，新实例从快照恢复；创建/更新时设 `platformVersion=V2` 加入，新增法兰克福、斯德哥尔摩、孟买、新加坡、悉尼 5 个 Region（合计 10 个）。单会话并发连接默认 2 vCPU 下 250（旧上限 8 连接/vCPU，即 16）。新增 `OverheadLatency` 指标（`AWS/Bedrock-AgentCore` 命名空间），度量「平台收到请求 → agent 返回首字节」中剔除 agent 自身处理的部分，覆盖四个 Invoke API。MCP 侧支持 `2026-07-28`，用 `X-Amzn-Bedrock-AgentCore-Runtime-Session-Id` 头做会话亲和，并要求 MCP server 在服务端口实现 `GET /ping`。**日期精度必须说明**：官方 release notes 只到「November 2026」，V2 的存在由 11-09 的 AWS Weekly Roundup 独立确认，故判窗内但不标具体日。

**怎么做到的。** 传统路径是拉镜像→启动进程→初始化依赖，镜像越大越慢，这解释了旧 runtime 随镜像增大从 5.4 秒线性恶化到 30 秒。V2 把这段固化成一次性「准备 + 快照」，运行时只做恢复，因此对 200MB–2GB 的镜像区间保持平坦。代价是**快照准备要几分钟**，且容器必须在初始化完成后 120 秒内在 `/ping` 上报健康。会话保持靠请求头而非长连接；`GET /ping` 的价值是把「健康」从 MCP 语义里解耦出来，使平台不解析协议也能判断存活。

**意味着什么。** 冷启动从「选 region 时赌一把」变成可承诺的 SLA 项；250 并发/会话让团队可以放弃「一会话一连接池」的绕行设计。真正的迁移成本在 `/ping`：没有健康端点的存量 MCP server 上 V2 会丢失故障区分能力，升级前必须补这段代码。

#### Microsoft Foundry：azd 扩展 GA 把 agent 纳入既有流水线（A）

11-05 `microsoft.foundry` azd 扩展 1.0 GA：agent 与部署配置留在 `azure.yaml`，流程覆盖 init→provision→Agent Inspector 本地跑→远程部署（服务端构建）→监控诊断，`azd up` + `azd pipeline config` 接 CI/CD；要求 `azd` ≥1.37.0、`uv`、Python ≥3.13。示例配额 **0.5 CPU / 1Gi 内存**——默认按小规格、可水平复制设计，不是一会话一重容器。**机制含义**：托管 runtime 的边界写进了 `azure.yaml`，agent 是「开发者自有代码 + 托管算力」，扩展只负责把代码、依赖、配额装配成可部署单元。真正影响架构的是同月 GA 的韧性模型：**接受「会重启」、正确性由应用 checkpoint + 幂等保证**——平台把至少一次语义显式推给开发者。

#### OpenClaw：Gateway 成为会话状态的唯一写入方（A，必覆盖）

窗口内 4 个版本，全部日级可核。**v2026.11.1（11-05）**：subagent follow-up 可跨模型与会话变更保留；父会话在自定义 session store 下也能收到子 agent 审批请求；会话工具定义跨轮保持稳定以降低 prompt-cache 失配。**v2026.11.2（11-08，166 commits/113 PRs/64 contributors）**：启动可挺过另一命令访问 state 造成的短暂 SQLite schema 争用；大 session 开 OTel 时 Gateway 卡顿减少；cron 保留策略不再清理正在运行 job 的会话。**v2026.11.3（11-10）**：`/reset` 改为**把 soft reset 转发给 Gateway，而非硬重置会话**；cron 队列化存储失败时不退出 Gateway；父任务取消子任务后可交接替代工作，被取消子任务的完成回执不再阻塞交接；provider 认证卡死会在 run deadline 截止并传播取消。**v2026.9.37（11-10）**：gateway-only `extended-stable` 维护版，模型账号选择在 `/new`、`/reset`、空闲与每日 rollover 后均存活；中断的快照写入保留上一回滚点；无法序列化的 SQLite 写入不被不安全重放。

**机制。** `/reset` 是窗口内最锋利的一刀：此前 reset 在终端侧硬清，Gateway 侧状态可能与终端不一致；改为转发后，**Gateway 成为会话状态的唯一写入方，终端只是视图**。11.1 的「工具定义跨轮稳定」是同一目标的反向优化——减少因定义抖动导致的缓存重建。11.3 的三处修复（cron 存储失败不退 Gateway、取消后回执不阻塞交接、认证卡死传播取消）把「单个子系统故障」与「整个 Gateway 死亡」解耦，Gateway 从进程变成监督者。9.37 的存在说明发布节奏已进入「稳定线 + 快车线」双轨。

**意味着什么。** 对自建 agent 平台的团队，11.3 的 `/reset` 语义与「取消-交接」回执处理是可直接抄的两条设计；采购方应锁定 `extended-stable` 而非 latest。跨模型保留 follow-up 的能力意味着子 agent 可以换模型继续同一任务，这会影响「模型路由」的设计位置——从会话建立时决定，变成轮次中可换。

#### 国内三家：百炼真空、腾讯标题级、火山不可机读（A/C/未取得）

- **阿里云百炼**：应用发布记录页按日期倒序，**最新条目 2026-10-21**，其下一条 10-15；窗口内应用/智能体、运行时、会话、沙箱、代码解释器、浏览器、记忆、插件各主题均无条目。辅助入口 `help.aliyun.com/zh/model-studio/` 为概览页、「更新时间」字段为空；`aliyun.com/notice` 返回「暂未搜索到任何内容」。**结论可用**：无破坏性变更需跟进，但上一版会话/沙箱规格仍是当前边界。
- **腾讯云 ADP**：11-09 两条公告，其中《腾讯云 AgentPortal 开放使用公告》标「重要」。**仅读到标题，未读正文**，AgentPortal 是新增入口还是既有能力改名不作判断。产品首页可见「云端沙箱执行」「长时任务运行」「会话多端互通」等能力描述，**无版本与日期**，不进结论。
- **火山方舟 / Coze**：`docs.volcengine.com/docs/82379` 返回文档首页导航（有「产品动态」栏目链接，页面本身无带日期条目）；`volcengine.com/product/ark` 返回空内容。**不推断**是否有窗内更新，列入 `delivery.md`「需 Bot 补证」。

#### E2B / Modal / Daytona：本周是背景，不是事件（A/B）

E2B 11-05~11-11 **确认为真空窗**（最新 11-04 `e2b@2.63.0`）；上一个版本刚改过暂停语义（`pause({strict})`：guest 无响应则拒绝暂停并抛 `ServiceBusyError`，恢复带病沙箱须 `onResume: 'reboot'`），正处于观察期。Modal 窗内只有账单 UI 与模型上架，无 sandbox 语义变更；exit snapshots 是 10-27 的 Beta（覆盖 terminate/entrypoint 完成/idle 超时/生命周期到期/OOM 五条退出路径）。Daytona 11-05/11-07 两个版本均非沙箱语义变更，且 `daytonaio/daytona` 已于 2026-10-03 归档，GitHub 发布通道失效。

### 模块洞察

1. **容量规划的方法要换。** 从「预留多少实例」变成「峰值同时活跃会话数 × 单会话内存曲线」。AgentCore 按实际 GB-hour 计费、会话空闲释放内存，意味着成本模型与实例数脱钩；反过来，评估托管平台时要问「空闲会话收不收钱、快照算不算存储」。
2. **「会话重建」是比「进程常驻」更强的承诺，但需要应用配合。** Foundry 要求自存 checkpoint 与幂等标识，AWS 要求 `/ping`，OpenClaw 要求回执可吞。三家的共同前提是：平台保证能重启，正确性由应用保证。
3. **隔离边界按「代码是否可信」分层。** 同一家 AWS 给两条产品线两种答案：AgentCore Browser/Code Interpreter 是容器 + TTL（默认 15 分钟、最长 8 小时），Nitro Sandboxes 是每 Pod 一个 guest kernel。可信代码用容器换密度，不可信代码用 VM 换边界。
4. **国内厂商的公开节奏与能力节奏脱钩。** 百炼零条目、火山不可机读、腾讯只有标题。这不等于没有发布，但意味着外部团队无法做基于公开信息的迁移决策；在本报告体系里只能记为情报缺口。

### 来源（模块 2）

- AWS AgentCore Release Notes｜https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- AWS Weekly Roundup（AgentCore Runtime V2，11-09）｜https://aws.amazon.com/blogs/aws/aws-weekly-roundup-agentcore-runtime-v2-amazon-dynamodb-bulk-put-items-and-more-november-9-2026/
- AWS What's New feed｜https://aws.amazon.com/about-aws/whats-new/recent/feed/
- Google Agent Platform Release Notes｜https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- Microsoft Foundry Blog｜https://devblogs.microsoft.com/foundry/feed/
- 阿里云百炼发布记录｜https://help.aliyun.com/zh/model-studio/application-release-notes
- 腾讯云公告中心｜https://cloud.tencent.com/announce
- 火山方舟文档｜https://docs.volcengine.com/docs/82379
- OpenClaw Releases｜https://github.com/openclaw/openclaw/releases
- E2B Releases｜https://github.com/e2b-dev/E2B/releases ｜Modal Changelog｜https://modal.com/changelog ｜Daytona Changelog｜https://www.daytona.io/changelog
## 3. Sandbox / Computer Use / Browser 沙箱与浏览器

### 本周模块结论

1. **分水岭是 AWS Nitro Sandboxes（11-09）：隔离边界从「共享内核的容器」上移到「每 Pod 一个 guest kernel」。** 它不是 AgentCore 的一个功能，而是一个新的 EC2 原语（Nitro Partition）——EKS 用它给 Pod 起一台轻量 VM，`runtimeClassName: isolated-sandbox` 一行接入。不可信 agent 代码的爆炸半径第一次由**硬件 + 独立内核**兜底，而不是 seccomp/用户命名空间。（机制深拆见 §0.2。）
2. **浏览器 agent 的范式被重写：browser-use 1.0（11-10）不再「每步选一个 DOM 动作」，而是让模型写 Python 进一个常驻 REPL、直接打 CDP。** Python 代码量 68,815 → 13,154 行，云浏览成为默认，0.x 参数不兼容直接 `TypeError`。
3. **Browserbase 两条线同时加固「会话」**：Stagehand 4.4 让浏览器连接可断开而不销毁（11-05），Navigation Policies 让策略在每一个重定向跳上生效（11-04）。前者解决 agent 进程崩溃后的会话孤儿化，后者解决「允许域」被 302 绕过。
4. **托管浏览器 / 代码解释器的真实天花板是 8 小时。** AWS Browser 与 Code Interpreter 均默认 15 分钟、最长 8 小时；超过 8 小时的 always-on agent 必须自建会话续接。这一点本周几乎无人提，却决定长跑 agent 能否落在托管平台上。

### 固定对象状态表

| 对象 | 窗口内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| AWS Nitro Sandboxes | 有动态（新增关注，深拆） | 11-09、Nitro Partition、独立 guest kernel、K8s ≥1.36 | A |
| E2B（沙箱侧） | 无窗内动态（真空窗确认） | 最新 11-04 `e2b@2.63.0` | A |
| Browserbase / Stagehand | 有动态 | 11-05 Stagehand 4.4、11-04 Navigation Policies、11-10 Secrets | A |
| browser-use | 有动态（架构重写） | 11-10 1.0.0 / 1.0.1、11-11 1.0.2 | A |
| vercel-labs/agent-browser | 有动态 | 11-10 v0.42.0 saved flows | A |
| Modal / Daytona | 窗内无 sandbox 语义变更 | Modal 10-27 Exit Snapshots（背景）；Daytona 仓库已归档 | A/B |
| OpenAI Computer Use | 无窗内动态 | 最近 10-26 GPT-6.1 Terra（背景） | A |
| Anthropic Computer Use | 有动态 | 11-09 `computer_toolset_20260801`，旧工具集非 Bedrock 400 | A |
| AWS AgentCore Browser / Code Interpreter | 窗内无发布条目（能力面已核） | 容器化、会话 15min / 最长 8h | A |
| Azure Browser Automation | 窗内无独立条目 | Playwright Workspaces + Toolbox MCP（属 10 月，背景） | B |

### 深拆条目

#### AWS Nitro Sandboxes：分区，而不是嵌套虚拟化（A）

**做了什么。** 11-09 官方博客：每 Pod 一台轻量 VM，自带 guest OS 与内核（「no syscall can reach anything outside the guest kernel」）。底层是 **Nitro Partition**——Nitro Hypervisor 从一台运行中的实例里切出硬件隔离的 CPU 与内存切片，EKS 经容器运行时申请 Partition 并在其中起 VM。两种模式：`isolated`（保护宿主与邻居）与 `confidential`（把运维者也视为不可信，证明 → Cedar 策略 → KMS 放行密钥）。接入是 `runtimeClassName: isolated-sandbox` / `confidential-sandbox`，要求 **Kubernetes ≥1.36**（示例 1.37），标准 EKS 需 sandbox-enabled AMI。注解 `sandbox.amazonaws.com/network-isolated: "true"` 产出「除 loopback 外无地址、无路由出口」的 VM。网络带宽、磁盘 I/O、DNS 查询、日志输出、conntrack 条目均**默认限流且可配**。

**怎么做到的。** 关键在**分区而不是嵌套虚拟化**：在已运行实例内部划硬件隔离的 CPU/内存切片，Pod 的 VM 直接跑在切片上，避免「VM 里再跑 hypervisor」的双层开销，也解释了为什么能「一行 runtimeClass」而不需要专用节点规格。兼容性靠**桥接**：kubelet 看到的是普通 Pod，logs/exec/port-forward/probes/metrics/Pod Identity/CSI/VPC CNI 全部桥接进 guest——运维工具链零改动，代价是这些桥接路径本身成为需要信任的面。机密模式的信任链是三段：度量值 → 证明 → Cedar 判定是否匹配预期镜像 → KMS 放行。

**边界（必须声明）。** 博客只讲 EKS；`whats-new` 标题含 ECS 与 EC2（tasks、VMs），但接入方式未取得，不推断。官方**未给** CPU/内存开销、实例类型清单、启动耗时、Region 列表、价格；文中 300 秒是 `kubectl wait` 超时，**不是启动时间**。`whats-new` 摘要称商业区无额外费用，博客未重复，需在报价单复核，本报告不作为结论。

#### browser-use 1.0：把动作空间交给 Python（A）

**做了什么。** 11-09 起密集发布 rc，11-10 `1.0.0`/`1.0.1`，11-11 `1.0.2`。引擎不再「从 DOM dump 每步选一个动作」，改为模型**写 Python 进常驻 REPL**，经 browser-harness 与裸 CDP 在 Pydantic AI 上执行；Python 代码量 68,815 → 13,154 行，核心 0.x API 保留。默认值：模型 `bu-fast`、云 `Browser()`、单一 Browser Use key、`max_steps=100`、`timeout=1700`。**云浏览成为 1.0 默认**，本地/私有站点需 `Browser('chromium')`。破坏性：不支持的选项抛 `TypeError`，已移除的 import 抛 `ImportError`。1.0.1 补 MCP 无 Chrome 时驱动自带 Chromium、`http_get` 本地取、`allowed_domains` 不能经云浏览器绕过；1.0.2 让 `report_issue` 的反馈文本**离机前先擦除**。

**怎么做到的。** 旧范式是「观察 → 选择动作 → 执行」三段循环，每步一次模型请求、动作空间由预定义集合限定。新范式把动作空间交给语言运行时：一次请求可完成多步组合，大量动作适配层被 Python 取代——这是代码量下降 81% 的来源。代价是**执行面变大**：模型生成的代码在浏览器进程旁跑，因此同版加了域名限制、密钥脱敏、`DevToolsActivePort` 校验、`file:` URL 阻断、MCP 重定向校验、私有 daemon 目录、剥离终端转义码、镜像 pin。100 步 / 1700 秒的预算下上下文必然撞墙，所以「压缩 + 一次瞬时重试」是必需项，不是优化项。

**意味着什么。** 0.x → 1.0 不是升级而是重写适配。对竞品，「动作集」这个护城河被打掉——如果模型能写代码，预定义动作的价值转移到**沙箱安全**与**可观测性**上：谁能约束这段 Python、谁能复盘它做了什么，谁才有壁垒。

#### Browserbase / Stagehand：把控制连接与浏览器生命周期解耦（A）

**做了什么。** 11-05 Stagehand 4.4：`browser.disconnect()` 断开 SDK 与浏览器的连接但**不关闭浏览器、不释放 Browserbase 会话**，tabs/cookies/登录态保留，之后用 `localBrowser.connect({cdpUrl})` 或 `browserbase.connect({sessionId})` 重连；**crash-safe sessions** 由**浏览器内的扩展**检测 SDK 进程死亡（不用心跳），本地未开 `keepAlive` 的 Chrome 直接关闭而非变孤儿；要求 Chrome ≥137。11-04 Navigation Policies：按站点类别与域定义规则、可跨会话复用、域覆盖优先于类别并向子域生效，检查点覆盖**页面加载、iframe 导航、弹窗、每一跳重定向**；策略变更只对新会话生效。11-10 Secrets：dashboard 配置加密凭据供 Functions 调用外部 API。

**怎么做到的。** `disconnect` + `keepAlive` 的本质是把「控制连接」与「浏览器生命周期」解耦：此前 agent 进程即会话所有者，进程死则浏览器成孤儿；现在浏览器是独立存活体，SDK 是可替换的控制器。crash-safe 的检测点放在**浏览器扩展内**而非客户端心跳——客户端已死时心跳必然停，只有从内部观测「控制器没了」才可靠。Navigation Policies 的强度在检查点粒度：不是只查首跳 URL，而是每一跳都查，直接针对「允许域 302 到禁止域」这类绕过。

**注意。** Stagehand 4.4 发布在 Browserbase changelog（11-05），而 GitHub releases 最新 tag 仍是 `server-v3 v3.7.7`（10-23）；两者版本序列不同，**不能据 GitHub 判定未发布**。

#### agent-browser v0.42.0：录制回放从脆弱脚本变成自愈路径（A）

11-10 的 saved flows：录制一个浏览器任务后可重放其请求，按三层降级尝试——先直连 HTTP，再从页面内发同一请求，最后回放录制命令，**保存实际成功的那一层**；只向公网地址发请求，保存前等待在途请求并跟随重定向到终点。同版把会话复用与重启决策收敛到单一 daemon 位置，连接目标仅在成功 attach 后保留（防半连接污染），安全设置在 daemon 重启后存活。**机制含义**：直连最快但常被反爬/鉴权挡住，页面内请求带 cookie 与同源身份，录制命令最慢但保真；按成功层落盘等于让每次运行自动选最省的可行层。路线与 browser-use 相反：一个让模型写代码，一个让 agent 调稳定 CLI/MCP 工具，把重复任务从「每次推理」降级为「一次录制多次回放」。

#### Anthropic computer use：用工具集版本号做硬切换（A）

11-09，Fable 5.2 与 Mythos 5.2 通过 **`computer_toolset_20260801`** 支持 computer use；旧 `computer_20251124` 的请求在**除 Amazon Bedrock 外的所有平台返回 400**（Bedrock 上旧工具仍可用）。同日 advisor tool（beta）约束：两模型作 executor 时 advisor 也只能是这两个模型之一，否则 400。**机制**：能力边界由工具集版本而非模型名界定，且是强制迁移、不是弃用告警；Bedrock 例外说明托管渠道与一方 API 的版本节奏不同步。**影响**：生产中的 computer use 在 11-09 是一次硬切换；跨云部署会出现「一方已切、Bedrock 未切」的版本分裂，需按渠道分支。

#### 托管浏览器 / 代码解释器：容器 + TTL，8 小时是天花板（A）

AWS AgentCore Browser 与 Code Interpreter 均为**容器化**、会话制：默认 15 分钟、最长 8 小时；Browser 通过 WebSocket 流式 API 提供 Automation 与 Live View（人可实时观看接管），会话录制捕获 DOM 变更、用户动作、console、网络事件并存 S3 回放，**每次会话重置**（cookie/登录态默认不跨会话）；Code Interpreter 预置 Python/JS/TS，内联上传 100MB、经终端传 S3 可达 5GB。Azure 走相反路线：浏览器放在**单独开通的 Playwright Workspaces**，agent 通过 Toolbox 远程 MCP 端点访问，支持私有网络、Live View 与 Take control，官方建议最小权限浏览器身份、后果性动作人工批准、页面内容视为不可信。**对比**：内置（AWS）耦合紧、上手快；外接（Azure）权限与网络边界更清晰。

### 模块洞察

1. **隔离边界出现「按代码可信度分层」的清晰分工。** Nitro Sandboxes 给不可信代码独立内核；AgentCore Browser/Code Interpreter 用容器 + TTL 给「半可信」的模型生成代码；browser-use 1.0 把模型生成的 Python 直接放在浏览器旁跑，于是必须自己补域名限制、密钥脱敏、`DevToolsActivePort` 校验。三者不是竞争关系，是同一条信任梯度上的三个价位。选型第一问不再是「哪个沙箱快」，而是「这段代码谁写的、错了会怎样」。
2. **浏览器 agent 的护城河从「动作集」转向「会话存活 + 策略执行」。** 四家（browser-use、Browserbase、agent-browser、Stagehand）都在把浏览器做成「可长期持有、可治理的资源」，而不是比谁的工具多。
3. **「暂停/恢复」成为沙箱标配语义，但有两种哲学。** Modal 把快照挂到全部退出路径（含 OOM）求**可恢复**；Nitro Sandboxes 用「VM 销毁即清态」求**保证清态**；E2B 的 `strict` 让暂停可信。同一团队可能两个都要——取决于这段代码是「我的」还是「别人的」。
4. **托管平台的 8 小时上限决定了 always-on agent 的架构。** 超时必须把状态外置到 context/文件再开新会话；这意味着「长跑」这件事最终仍要由 harness 的 session/state 层解决，而不是沙箱层。

### 来源（模块 3）

- AWS Containers Blog（Nitro Sandboxes）｜https://aws.amazon.com/blogs/containers/aws-nitro-sandboxes-hardware-enforced-workload-isolation-on-amazon-eks/ ｜2026-11-09
- AWS What's New feed｜https://aws.amazon.com/about-aws/whats-new/recent/feed/ ｜2026-11-09
- Browserbase Changelog｜https://www.browserbase.com/changelog ｜2026-11-04/05/10
- browser-use Releases｜https://github.com/browser-use/browser-use/releases
- agent-browser Releases｜https://github.com/vercel-labs/agent-browser/releases
- Claude Platform Release Notes｜https://platform.claude.com/docs/en/release-notes/overview ｜2026-11-09
- AgentCore Browser / Code Interpreter 文档｜https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html
- E2B Releases｜https://github.com/e2b-dev/E2B/releases ｜Modal Changelog｜https://modal.com/changelog ｜Daytona Changelog｜https://www.daytona.io/changelog
## 4. Tool Gateway / Protocol 工具与协议层

### 本周模块结论

1. **本窗口没有新的 MCP 规范修订，也没有 SEP 合并进规范**：当前版本仍是 `2026-07-28`；窗内 modelcontextprotocol 仓库提交全部是文档、社区治理与 SEP 自动化（#3532/#3533/#3534/#3535/#3441）。
2. **真正的新语义来自 MCP 文件扩展草案（11-10）**：`io.modelcontextprotocol/files` 把文件字节移出 JSON-RPC，改走直连 HTTPS PUT/GET，并用 `credentials: omit|include` 明确「MCP 令牌是否随请求带到目标 URL」。这是本期协议侧最实质的凭证边界设计。
3. **A2A 未发版，但 11-05 把 OAuth Client ID Metadata Document 发布到站点根目录**，`client_id` 直接等于文档 URL；与 MCP `2026-07-28` 弃用 RFC 7591 动态注册、转向 CIMD 同向，两个协议在客户端身份上收敛。
4. **Registry v1.8.8 起「不同 server name 可共享同一 remote URL」**，条目身份必须按 (name, version) 而非 URL 识别——对做镜像/聚合的网关是破坏性假设。
5. **云厂分化在「控制面放哪」**：AWS 用 `X-Amzn-Bedrock-AgentCore-Runtime-Session-Id` 做平台级会话粘性，把 Web Search 收进托管原语；Google 11-11 把 Agent Gateway 推到跨云 K8s（EKS/AKS/OpenShift/裸金属），控制面留在云上、数据面推到客户网络。

### 固定对象状态表

| 对象 | 窗口内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| MCP 规范 | 无新修订；有 1 个扩展草案 | 现行 `2026-07-28`；files 扩展 11-10 | A |
| MCP Registry | 有动态 | v1.8.8（11-06）、v1.8.9（11-10） | B |
| MCP TS SDK | 无动态 | 最新 v2.4.0（10-23） | B |
| MCP Python SDK | 无动态 | 最新 v2.3.0（10-02） | B |
| A2A | 无发版；2 个提交 | CIMD 文档 11-05；spec 首页改版 11-11 | B |
| Composio | 有动态（4 个 beta） | beta.535–538（11-06~11-10） | B |
| Arcade | 有动态 | 1.13.0 preview（11-11）；#996（11-10） | A/B |
| Nango | 有动态（3 个 release） | v0.72.2/.3/.4（11-05~11-09） | B |
| Pipedream Connect | 无动态 | changelog 停在 2025-10-01 | A |
| AWS AgentCore Gateway | 有动态（月份级） | Web Answer connector；Runtime 支持 2026-07-28 | A |
| Google Agent Gateway | 有动态 | 11-11 跨云 Limited Preview | A/C |
| Azure API Center / Foundry toolbox | 本次未取得 | 2 入口 404 / 0 结果 | — |
| mcp-gateway-registry | 无动态（1.36.0=11-03，窗外） | — | B |

### 深拆条目

#### MCP 文件扩展草案：把数据面从 JSON-RPC 里拆出去（A）

**做了什么。** 2026-11-10，MCP 官方博客发布文件上传/下载扩展草案，标识 `io.modelcontextprotocol/files`，适用于 `2026-07-28` 及以后，状态为 Experimental draft、无参考实现，作者希望在年底前定稿。

**怎么做到的。** 核心是把「大对象传输」从 JSON-RPC 消息体剥离：服务端在工具参数上标 `x-mcp-file`；客户端先只发元数据，服务端返回 `upload_required` + 目标 URL + 不透明 `requestState`；客户端用 HTTPS PUT（或 multipart POST）直连目标上传，不经 JSON-RPC；2xx 后带同一 `requestState`、同一参数重试原工具调用，服务端校验落盘后再执行。下载方向相反：工具结果 `_meta` 给 targets，客户端 HTTPS GET 取回，内容不进入模型上下文。凭证是硬约束：每个 target 带 `credentials` 字段，`omit` 表示不附带任何 MCP token/cookie、目标须自带授权（如预签名 URL）；`include` 仅当目标在 MCP 服务地址之下或同源时才附带 MCP 凭证；客户端必须拒绝重定向、拒收自带 `Authorization` 头的 target。容量侧有 `maxInlineBytes`、`maxSize` 与可选 SHA-256 `digest`；因为 `2026-07-28` 已删除协议级 session，`requestState` 被设计成另一个实例也能验证并续做的凭据。

**意味着什么。** 这是 MCP 第一次在规范层面承认「工具调用会产生 JSON-RPC 之外的数据面」。网关若要做 DLP/审计，必须能拦 HTTPS 直连或强制 `omit` + 预签名，否则会出现「日志里有调用、没有内容」的盲区；`include` 的同源约束则给「网关把 MCP 凭证转发给第三方存储」划了红线。

#### MCP Registry v1.8.8：URL 不再是身份（B）

11-06 的 v1.8.8 允许不同 server name 共享同一 remote URL，条目识别改为 (name, version)，无需数据库迁移；11-10 的 v1.8.9 改增量同步分页（先选索引页键再取 payload、复用 prepared statement）并加入分阶段自动扩缩配置。**机制含义**：以 URL 做去重键的镜像/聚合网关会把两个不同 server 合并成一个；对做企业目录的团队，唯一键设计要从「端点」改为「名字 + 版本」。

#### A2A 与 CIMD：客户端身份变成可解引用 URL（B）

11-05，a2a-cli 的 OAuth Client ID Metadata Document 发布到站点根目录，`client_id` 即文档 URL——授权服务器无需预注册即可识别客户端。这与 MCP 在 `2026-07-28` 弃用 RFC 7591 动态客户端注册、转向 CIMD 是同一方向：**客户端身份从「注册表里的一条记录」变成「一个可验证的 URL」**，减少了授权服务器侧的预配置，但把可用性绑到了该 URL 的持续可访问与内容完整性上。

#### Composio：toolkit 可以是一个远端 MCP 端点（B）

beta.536（11-09）给 custom toolkit 的 create/upsert 加 `mcpUrl`（`feat(core)!` 破坏性），并把 Custom Tools 改名 `localTools`；beta.538（11-10）把 custom toolkits 移出 experimental 命名空间。机制上这是两条执行路径：`localTools` 在调用方进程内跑、凭证由宿主持有；`mcpUrl` 指向远端 MCP server，Composio 只做注册、鉴权注入与审计。同日新增 audit logs 页。**影响**：数据不必流经 Composio 云端执行，敏感工具可留在 VPC 内，但信任边界转移到 `mcpUrl` 指向的端点。

#### Arcade #996：缺失 client claim 不再回落到共享桶（B）

11-10 的 `fix(arcade-mcp-server): don't give tokens without a client claim a shared client_id (#996)` 移除 `"unknown"` 兜底：缺 `client_id`/`azp` 的 token 现在得到 `None`，任务模式调用因授权上下文不完整而失败，而不是共用同一命名空间。这是「fail closed 到缺失值」而非「fail open 到公共桶」的写法，对多租户 MCP 托管方是可复制的模式。1.13.0 preview（11-11）另加「按每次执行记录 API key 与 gateway」、Office 文件共享盘与多处 OAuth/MCP 修复。

#### Nango：工具发现改为连接级求值（B）

v0.72.2（11-05）为中途加入会话的连接新增 MCP 工具发现；v0.72.3（11-06）支持 OAuth2 public client（`token_request_auth_method=none`，安全前提转到 PKCE 与精确 redirect URI）、`providers_shared_credentials` 可禁用 Nango 托管 app、webhook 签名密钥可轮换导入。**机制含义**：MCP `2026-07-28` 删除协议级 session 后，连接可在任意时刻完成授权，工具清单不能只在会话建立时快照，必须以 connection 为单位动态求值。

#### AWS：Web Search 变成托管原语，Web Answer 变成网关内置 connector（A）

11-10 的 `InvokeWebSearch` 让应用无需建 gateway 即可搜索：返回 Amazon 索引的排序结果（文本摘录 + 标题/URL/发布时间），支持按域名与发布时间过滤，IAM 授权、PrivateLink 可达、CloudTrail 数据事件可记录，定价 **$7 / 1,000 次查询**，覆盖 6 个区域。11 月档（未标日）另有 Gateway 的 Web Answer connector 在 `us-east-1` GA：一次工具调用返回带引用的合成答案。**影响**：第三方 search MCP server 在这一场景被平台吸收；对采购方，搜索从「自建连接器」变成按次计费的云原语，成本与审计口径都变了。

#### Google Agent Gateway（详见主线专题 §0.3）

11-11 跨云 Limited Preview：控制面在 Google（策略、Registry、Model Armor 模板），数据面是客户集群里的 Envoy + AIR sidecar；身份链是 KSA token → Workload Identity Federation → 可验证工作负载身份 → 证书。策略求值点在本地代理，`failOpen` 在无法连云时不生效（等于默认更严格）。

### 模块洞察

1. **协议层本月的主线不是「新版本」，而是把数据面和身份面从 JSON-RPC 里拆出去。** 文件走直连 HTTPS、客户端身份走 URL，网关不能再假设「一次工具调用 = 一条 JSON-RPC 消息」；审计、DLP、配额必须同时覆盖控制面与数据面。
2. **「无状态协议 + 有状态平台」是本期最容易被忽略的错位。** MCP 删了 session，AWS 用平台头做亲和，Nango 按 connection 重算工具清单。选型时要问清「跨调用状态存在哪一层」，否则迁移平台会撞墙。
3. **租户隔离的失败模式高度一致：一个可共享的默认值。** Arcade 的 `"unknown"`、Registry 的「URL 即身份」、Claude Code 的重定向带凭证，本质都是「缺失或歧义时回落到所有人共享的桶」；本期三处修复说明问题在被逐个清理，但没有规范级约束。
4. **云厂分化已从「有没有网关」变成「控制面放哪」。** Google 把控制面留在云上、数据面推到客户 K8s；AWS 把网关、运行时、搜索都收进 AgentCore 托管栈；Azure 本期只在开发工具链（azd 扩展 GA）发力。

### 来源（模块 4）

- MCP 规范｜https://modelcontextprotocol.io/specification/versioning ；https://modelcontextprotocol.io/specification/2026-07-28/changelog
- MCP 文件扩展草案｜https://raw.githubusercontent.com/modelcontextprotocol/modelcontextprotocol/main/blog/content/posts/exploring-file-uploads-and-downloads-in-mcp.md （11-10）
- MCP Registry｜https://github.com/modelcontextprotocol/registry/releases
- A2A｜https://github.com/a2aproject/A2A/commits
- Composio｜https://github.com/ComposioHQ/composio/releases
- Arcade｜https://releases.arcade.dev/preview/ ；https://github.com/ArcadeAI/arcade-ai/commits
- Nango｜https://github.com/NangoHQ/nango/releases
- AWS｜https://aws.amazon.com/about-aws/whats-new/2026/11/amazon-bedrock-agentcore-web-search-api/ ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- Google｜https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes

## 5. Identity / Auth / Permission 身份与权限层

### 本周模块结论

1. **窗口内没有新的 agent 身份标准，但「身份 → 权限」的求值点从 IdP 前移到了网关/代理。** Google 11-10 的跨项目语义治理把策略引擎挂在 Agent Gateway 的授权扩展上，11-11 的跨云网关把同一套策略下沉到客户集群的 Envoy。身份仍由 IdP/工作负载身份签发，**授权判断发生在流量路径上**。
2. **语义治理不等于工具治理。** Google 文档明示：策略的 `when` 条件**排除 gRPC，只把模型推理路径**（`:generateContent`、`:rawPredict`、`/v1/messages`、`/chat/completions`）送引擎，**MCP 工具调用流量不被评估**。若合规目标是「agent 不能调用某类工具」，必须落在网关访问策略或工具侧授权上。
3. **AWS 补了两块身份拼图**：Agent Registry 在 GovCloud GA（11-06，带原生 MCP 端点）、STS 跨 partition 联邦（11-09，`GetWebIdentityToken` + `AssumeRoleWithWebIdentity`）。后者让 GovCloud 与商业区的 agent 之间用临时凭证互认，不必持有长期密钥。
4. **两起「凭证边界」修复值得单独记**：Claude Code v2.1.321 修 MCP OAuth 在服务端重定向时把 refresh token 等秘密发到另一主机；OpenClaw v2026.11.3 做插件结果的**按连接凭证隔离**与凭证脱敏。两者都不是新功能，而是把「凭证跟着谁走」在实现层钉死。
5. **企业 IdP 侧本期公开面静默**：Entra 的 what's-new 最新只到 2026 年 6 月，Agent ID 专页 updated 2026-08-13；M365 Message Center 需管理员登录。这是**公开可核验面缺失**，不等于无变更。

### 固定对象状态表

| 对象 | 窗口内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| AWS AgentCore Identity | 无 Identity 条目；关联两项有动态 | Registry GovCloud GA（11-06）；STS 跨 partition（11-09） | A |
| Microsoft Entra Agent ID | 无动态（公开页停在 6 月） | what's-new 最新 June 2026 | A |
| M365 Message Center | 本次未取得 | 需租户管理员登录 | — |
| Google Agent Identity / 语义治理 | 有动态（2 条） | 11-10 跨项目治理；11-11 跨云网关 | A/C |
| Arcade auth | 有动态 | #996 `client_id` 隔离（11-10） | B |
| Composio auth | 有动态 | audit logs、Approvals/Firewall（11-09） | B |
| Nango auth | 有动态 | public client、共享凭证开关（11-06） | B |
| Pipedream auth | 无动态 | changelog 停在 2025-10-01 | B |
| Claude Code v2.1.321 | 有动态 | MCP OAuth 重定向泄密修复（11-09） | A/B |
| OpenClaw v2026.11.3 | 有动态 | 凭证隔离 + 脱敏（11-10） | B |

### 深拆条目

#### Google 语义治理：只判模型调用，不判工具调用（A/C）

**做了什么。** 11-10 跨项目治理：用 Resource Manager 的 `AGENT_MANAGEMENT` 管理边界，让中心项目的 Agent Registry 自动发现成员项目 agent，**保留各 agent 的 `RuntimeIdentity`（`principal://…`）不变**，在管理项目部署单一 Agent Gateway + 语义策略引擎统一授权。准入条件（机制页）：reasoning engine 必须以 `identity_type=AGENT_IDENTITY` 且带 `agent_gateway_config` 部署，有效身份以 `agents.global.` 开头，成员 agent 通过管理项目的 gateway 资源路径绑定，跨项目访问权授予每个成员项目的 Agent Runtime service agent。

**怎么做到的。** 身份链是「KSA token → Workload Identity Federation → `RuntimeIdentity`（`principal://…`）→ 短期证书」；跨项目发现时身份不被重写，因此中心策略可按原始主体授权，而不是按「被代理后的匿名身份」。授权求值走 gateway 扩展点：请求进 Envoy 后，`when` 条件先做路径过滤，命中模型推理路径的才转发给策略引擎；引擎是生成式 AI 服务，**按区域、按项目作用域**，只评估本项目创建的策略，对被提议的工具/skill 调用做「约束遵循」与「用户意图匹配」两项判断，返回 `ALLOW`/`DENY` 与逐动作理由，写 Cloud Logging，支持 dry-run。因是 LLM 判断，结果具概率性。

**意味着什么。** 企业最容易误读的一点：语义治理不覆盖 tool call。要限制工具，用访问策略或工具侧授权。跨项目保留 `RuntimeIdentity` 解决了「hub 代签」导致的归因丢失——日志里仍是成员项目 agent 的真实主体。这是本周身份层最实质的设计决策：**治理可以集中，身份不能代持**。

#### AWS：Registry 自带 MCP 端点，STS 跨 partition 换临时凭证（A）

**做了什么。** 11-06 Agent Registry 在 GovCloud (US-West) GA：托管目录，发布与发现 agents、tools、MCP servers、skills，审批流控制可见性，CloudTrail 记录，**含原生 MCP 端点**。11-09 STS 支持跨 partition 联邦：用 `GetWebIdentityToken` 与 `AssumeRoleWithWebIdentity` 在 AWS partition 之间获取临时凭证，无需长期凭证。

**怎么做到的。** AgentCore 把「agent 是谁」拆两层：入站用 JWT authorizer 校验调用方令牌（issuer/audience/签名），出站用 credential provider 换取目标服务可接受的凭证（SigV4/OAuth/API key），令牌由服务托管而非写进 agent 代码；**对每次请求独立验证，不因来源可信而跳过**。跨 partition 联邦补的是「分区之间没有共同信任根」：源 partition 的 identity 先换成 OIDC/web identity token，目标 partition 的 `AssumeRoleWithWebIdentity` 以该 token 为输入签发本 partition 的临时角色凭证——信任通过 **issuer 与 audience** 建立，而不是共享长期 access key。Registry 的原生 MCP 端点让「发现」也走 MCP，客户端不必为目录单独实现 API。

**意味着什么。** 对同时跑 GovCloud 与商业区的团队，跨 partition 联邦把「两套长期密钥 + 手工轮换」换成「一次 token 交换」，审计对象从密钥持有者变成角色会话。Registry 的 MCP 端点意味着**治理链上又多了一个需要鉴权的 MCP 端点**——采购时应确认该端点的 authorizer 是否与业务工具一致，否则它会成为策略盲区。

#### Claude Code v2.1.321：OAuth 重定向把凭据发给了错误的 host（A）

**做了什么。** changelog 原文：「Fixed MCP OAuth requests sending secrets such as refresh tokens to another host when a server redirected them」。npm 元数据显示 2.1.321 发布于 2026-11-09T19:02:47Z（CST 11-10 03:02）。

**怎么做到的。** OAuth 客户端在令牌请求或受保护资源请求中跟随 HTTP 3xx 到**不同主机**时，若仍携带 `Authorization` 头或请求体中的 `refresh_token`/`client_secret`，接收方就拿到了本应只属于原授权服务器的秘密。修复把凭证发送范围绑定到**原始主机**：重定向到其他 host 不再附带凭证（或直接拒绝跨 host 重定向）。这与 MCP `2026-07-28` files 扩展草案「客户端必须拒绝重定向、拒收自带 Authorization 的 target」是同一条原则的两个落点——一个在规范、一个在实现。

**意味着什么。** 这是凭证外泄而非功能缺陷，影响所有使用 MCP OAuth 的客户端，利用条件是「恶意或被接管的 MCP server 返回 302」。企业应把客户端版本下限设到 2.1.321；自研 MCP 客户端需自查重定向处理是否按 host 剥离凭证。规范侧直到 11-10 的 files 草案才把「拒绝重定向」写成硬要求，说明这类问题的规范覆盖是滞后的。

#### OpenClaw：插件结果的缓存键必须含凭证身份（B）

**做了什么。** v2026.11.3 的 `Credential isolation`：「Keep reused and cached plugin results scoped to their connection credentials」「keep other plugins' transport hooks on the provider's origin」（PR #178444/#177974/#189423）；`Credential redaction`：配置读取中的内联环境凭证脱敏、Exa 错误回显的搜索凭证脱敏（#190618/#178745）。

**怎么做到的。** 两处都指向「凭证的作用域没有跟着数据走」。**隔离**：插件结果会被复用与缓存，若缓存键只含「工具名 + 参数」而不含「用哪个连接凭证取得的」，A 用户凭证下取回的结果就会被 B 用户命中——修复把连接凭证纳入缓存作用域；同时把各插件的 transport hook 钉在 provider 的 origin 上，防止一个插件注册的 hook 拦截另一个 provider 的流量。**脱敏**：配置读取会把内联环境变量回显到日志/界面，Exa 的错误信息会把搜索凭证反射回来，修复在这两个出口做模式化脱敏，而不是依赖调用方自觉。

**意味着什么。** 这是 agent 插件生态特有的风险面：与 MCP 的 server 边界不同，插件在同一进程内共享 transport 与缓存，凭证串味**不需要漏洞，只需要一个不完整的缓存键**。三条可直接进安全基线：缓存键是否含凭证身份、hook 是否按 origin 隔离、错误信息是否反射凭证。

#### Arcade / Composio / Nango：多租户隔离的键是什么、缺失时怎么办（B）

- **Arcade #996（11-10）**：无 `client_id`/`azp` 的 token 不再回落到共享 `"unknown"`，而是 `client_id=None` 并使任务模式调用失败——**缺失即失败**，是本周最可复制的多租户修复。11-06 #987 部署后 API key 不回显。
- **Composio beta.536（11-09）**：audit logs 页（哪个凭证执行了哪个工具）、Approvals/Firewall 文档、custom toolkit 支持 `mcpUrl`。求值点在**调用前审批**。
- **Nango v0.72.3（11-06）**：OAuth2 public client（`token_request_auth_method=none`，安全前提转到 PKCE 与精确 redirect URI）、`providers_shared_credentials` 可禁用 Nango 托管 app、webhook 签名密钥可轮换导入。求值点在**连接建立时**。
- **Pipedream**：窗口内无更新，凭证静态加密、不存 payload、以 `external_user_id` 标识终端用户。

**对比结论**：四家共同趋势是「凭证属于哪个主体」显式化，差异在求值时机——Arcade 运行时按 claim 隔离、Nango 连接建立时确定凭证域、Composio 调用前审批。采购第一问应是「多租户隔离的键是什么、键缺失时回落到哪里」；任何回落到共享默认值的实现都是结构性跨租户风险。

### 模块洞察

1. **授权求值点分裂成语义层与策略层，覆盖面不同。** 语义引擎只判模型推理路径，工具调用仍靠网关访问策略与 Model Armor。「上了语义治理」不等于「工具调用被治理」——合规要求写成「不得调用某类工具」时，必须落在策略层。
2. **身份的可移植性比身份的数量更重要。** 跨项目治理保留 `principal://`、AWS 跨 partition 用 web identity 换临时角色、Entra 用 blueprint + sponsor 绑定责任人——共同点是**不复制身份、只传递证明**。反面做法（hub 代签、共享长期密钥、共享 client）都会在审计里丢失归因。
3. **「凭证跟随数据」是最薄弱环节。** Claude Code 的重定向泄密是「凭证跟随了错误的 host」，OpenClaw 的缓存串味是「结果跟随了错误的凭证」。两者都不是密码学问题，而是**作用域绑定**问题；MCP files 扩展的 `credentials: omit|include` 是目前少见的、把作用域写成字段的设计。
4. **公开可核验面正在收窄。** Microsoft 的 agent 变更向 Message Center / Agent 365 集中，公开文档滞后一个季度；Google 把关键机制写进 `.md.txt` 机制文档而非 release notes 正文。研究侧必须同时抓 release notes、机制文档与仓库 commit，单看发布页会漏掉真正的语义。

### 来源（模块 5）

- AWS AgentCore Identity｜https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity.html ；Release notes｜https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- AWS What's New feed｜https://aws.amazon.com/about-aws/whats-new/recent/feed/ ｜11-06 / 11-09
- Google 语义治理机制｜https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/policies/configure-semantic-governance.md.txt
- Google 跨云网关｜https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents/governance/agent-gateway-cross-cloud/overview.md.txt
- Entra what's new｜https://learn.microsoft.com/en-us/entra/fundamentals/whats-new ｜Agent ID｜https://learn.microsoft.com/en-us/entra/agent-id/whats-new-agent-id
- Arcade commits｜https://api.github.com/repos/ArcadeAI/arcade-ai/commits?since=2026-11-05
- Composio releases｜https://api.github.com/repos/ComposioHQ/composio/releases
- Nango releases｜https://api.github.com/repos/NangoHQ/nango/releases
- Claude Code CHANGELOG｜https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
- OpenClaw releases｜https://api.github.com/repos/openclaw/openclaw/releases
## 6. Context / Memory / Knowledge 记忆与知识层

### 本周模块结论

1. **记忆层的本周主线不是「又一个框架发版」，而是上下文资源的形态在变**：OpenViking 把工具输出挂成 `viking://` 下的可读文档节点，Google 把 Memory Bank 变成带 schema / retention / revision 的控制台资源，Firecrawl 把抓取下沉成本地单二进制，NVIDIA 把企业元数据做成 ontology 上下文层。**context 正在从「应用内的一段 prompt 拼装」变成「有命名空间、有生命周期、有 schema、可被 agent 通过协议读取的外部资源」。**
2. **第二条主线是写入语义的正确性债务**：OpenViking 0.5.4.1、Cognee 1.6.7、Zep 11-08 三条独立修复落在同一处——异步摄取里「等到什么算写完」「失败/限流怎么记账」「scope 过滤是否真生效」。记忆系统的瓶颈已从召回质量转到**写入与删除的一致性**。
3. **删除与身份收口**：OpenViking 0.5.4.1 让 OIDC 非法账户/用户标识直接拒绝（#7116），Cognee 默认拒绝原始数据库连接串与远端路径——记忆系统天然汇聚多源凭证，这一层开始被当作安全边界处理。

### 固定对象状态表

| 对象 | 窗口内状态 | 锚点 | 证据 |
|---|---|---|---|
| OpenViking | 有动态（7 个发布） | v0.5.4（11-09）、v0.5.4.1（11-11）、langchain-openviking 0.2.0（11-06）等 | A |
| Mem0 | 无动态 | 最新 v2.2.1（2026-09-25） | A/B |
| Cognee | 有动态 | v1.6.7（11-06） | A |
| supermemory | 无动态 | releases 最新 server-v0.0.9（10-12） | A/B |
| Letta | 无动态 | GitHub releases 停 0.16.8（05-14）；PyPI 0.34.12（10-12） | A/B |
| Zep / Graphiti | 有动态（仅 Zep API 层） | Zep changelog 11-08 三条；Graphiti v0.31.2（10-20） | A |
| Firecrawl | 有动态（5 条语料公告 + 临界 PR） | 11-05~11-11 语料索引；PR #5685 | A/B |
| Crawl4AI | 无动态 | v0.9.5（10-14） | B |
| Google Memory Bank | 有动态 | 11-06 Console 功能 | A |
| NVIDIA Auto Ontology（名单外） | 有动态 | v1.2.0 提交 11-05 | B |

### 深拆条目

#### OpenViking v0.5.4 / v0.5.4.1：工具输出成为一等上下文，锁协议不再支持滚动升级（A）

**做了什么。** 11-09 的 v0.5.4 把 MCP 工具挂载成 `viking://` 下的可读 Markdown 节点（#6263）；11-11 的 v0.5.4.1 修正异步写入衔接（#7383）与 OIDC 身份混淆（#7116）。同版三项破坏性变更：共享存储不能新旧混跑（锁租约协议变化，须先停全部锁参与者含队列 worker，SQLite 自动加 `holders` 列）；组成员移除从 `DELETE .../members/{user_id}` 改为 `DELETE .../members` + body；单文件恢复改用 `restore_commit_id` / `current_commit_id`（完整 40 位 commit ID）。

**怎么做到的。** 注册 Streamable HTTP MCP Server 后可检索、调用工具，并把工具挂载为可读节点：`ov mcps add` → `ov mcps find` → `ov mcps mount <tool.json> viking://resources/live/xxx.md --args ... --wait` → `ov read`。语义边界写在工具声明里：**读实时节点只透明调用「符合只读要求」的工具；显式声明为非只读/破坏性的工具必须走 `ov mcps invoke`**——读写分权不是调用点判定，而是预声明。检索路径统一到 `viking://`（记忆、资源、工具挂载点共用 URI 与 L0/L1/L2 摘要层级）。写入是两级异步流水：文件自身（摘要 + 索引）与父目录（L0/L1 + 目录索引）分开刷新，0.5.4.1 后 `wait=true` **只等文件自身完成，不等父目录与目录索引**。另有「规则检索前移」（#7005）：执行操作前按需查规则，而不是把规则常驻 system prompt。

**意味着什么。** 对平台架构，这是「文件系统式上下文」的一次完整实现；代价是**目录摘要最终一致**——`wait=true` 不等于「可检索」，ingestion 后立刻做目录级检索会读到旧摘要，这是语义陷阱而非 bug。对自托管，锁租约变化意味着共享存储部署需要停机窗口，滚动升级不被支持。

#### Google Memory Bank：记忆成为带 schema、TTL、版本的控制台资源（A）

11-06，Memory Bank 获得独立 Console 功能：创建/配置/检查实例、standalone memory banks、标签编辑删除、Memories 页签分 Unstructured / Structured 两视图、`key:value` scope 过滤、记忆编辑与删除、revision history；Configuration 分五段 Details / Generation / Retrieval / Retention / Schemas；「Link to an agent」给 ADK / Python 片段，Agent Runtime 部署同步获得 scope 过滤与生成/检索/保留控制。**机制**：配置被切成五个正交面，抽取不再是固定 pipeline 而是 **schema 驱动**；scope 用多标签键值而非层级路径，与 OpenViking 的单树命名空间是两种隔离哲学。**影响**：记忆的治理动作（改、删、回滚、按 scope 隔离、按 retention 过期）第一次能在控制台完成而不写代码；迁移语义（schema 变更是否重抽已有记忆）官方未披露。

#### Cognee v1.6.7：摄取口默认拒绝连接串，路由规则拆成两套（A）

11-06 的 v1.6.7（PR #6266…#6564 共 14 个）把「不安全网络输入」与「不安全数据库连接串」合并成一条默认拒绝规则，`ACCEPT_LOCAL_FILE_PATH` 现在同时 gate `s3://` 输入；文件摄取被拒从 415 改为 403 + 可读信息。检索侧把「哪些文档送 LLM」与「按 scope 路由」拆成两套规则（`Separated routing constraints for scopes and LLMs`），typed/scoped 查询在 chunk 检索与 quoted/scoped 查询中一致生效，quoted 短语不再触发不必要的 LLM 路由；PGVector / Turso / LanceDB 打分改为批量 + 并行；DLT 新增 column graph anchors（把表行指回图的指针）。

**意味着什么。** 这是供应链安全的正向收紧，但会打断既有 connector——评估清单要新增「你的管道是否把 DB 连接串或 `s3://` 路径当普通字符串传进摄取口」。三存模型（图 + 向量 + 关系）的主要故障模式仍是「删除/压实后图与向量不同步」，采购时应要求厂商给出「删除一个 dataset 后三处如何一致回收」的书面语义。

#### Zep：限流不再消耗重试预算（A）

11-08 三条同日变更：失败的 v4 batch item 带 `error` 对象（`code` + `message`）；命中速率上限的 batch item 等待并重试、**不消耗 processing attempt**，持续被限流最终以 `rate_limited` 失败；文档新增 Agent Skills 示例。**机制**：此前「限流」与「失败」共用 attempt 计数器，客户端无法区分「我写坏了」与「服务端让我慢点」；改后限流变成纯背压。对长跑批量写入（历史会话回灌、文档全量重建）直接解除「限流烧完重试预算」的失败模式。Graphiti 开源侧停在 v0.31.x（10-20），与托管 API 的迭代形成剪刀差。

#### Firecrawl：把抓取压成 11 MB 的本地二进制（B，窗内公开/窗外交付）

窗内五条公告全部是垂直语料索引（11-05 生命科学 4,100 万+ 论文、11-06 SEC 8,000+ 上市公司、11-09 200K stars、11-10 职位、11-11 AI/ML 论文），没有一条是爬虫能力升级。`firecrawl-local` PR #5685 创建于 11-11 15:09 CST（窗内）、合并于 11-12 06:47 CST（窗外）：Rust 单二进制、无数据库/队列/容器、idle 约 11 MB；`serve` 提供 `/v2/*`（不服务 v0/v1）；`mcp` 在 loopback 起 API 并跑同一个 `firecrawl-mcp` 包，本地能答的四个工具本地答、其余透传云端（需 Node ≥22）；直接编译 `apps/api/native/src`，本地与云端清洗同一套规则。基准（11-10，6 vCPU/12 GB，静态 216 页）：本地 c=32 为 237 pages/s、错误率 0%、峰值 594 MB；自托管 server 为 0.9 pages/s、18.5% 错误、峰值 4,844 MB。**影响**：摄取层可以下沉到终端（数据不出机、不需要 key），但混合路由意味着「本地化」不等于「离线」，需确认 `FIRECRAWL_CLOUD` 默认值。

#### NVIDIA Auto Ontology v1.2.0（名单外）：知识层而非记忆层（B/C）

11-05 版本提交至 1.2.0（#426），仓库 11,830 stars、窗内仅 3 个提交、无 GitHub Release。定位「上下文层」：从企业元数据生成 ontology，跨系统调和定义，通过 MCP / CLI / API 暴露给任意 harness。存储上 ontology 与它描述的 catalog 同库（Postgres）；查询是自然语言 → SQL，推理由 NIM 提供；生成 SQL 后用**已认证定义与 lineage 校验，每个答案带 provenance**，「Learn」步骤把已认证修正折回 ontology。**影响**：它解决的是 agentic analytics 里「答得快但数字错」的问题，provenance 是它与向量 RAG 的分界；但闭门贡献 + 无 release 产物，目前只能当参考架构读。

### 模块洞察

1. **上下文正在获得「命名空间 + 生命周期 + schema」三件套，但三家选了不同的隔离哲学。** OpenViking 用单树路径、Google 用多标签键值、Cognee 用类型化 namespace。差别不在 API 美观，而在**能否跨 agent 复用同一份记忆**：树只能挂一处，标签可多挂。多租户平台选型时这一条比召回率更早决定架构。
2. **「写完」的定义成了本周最集中的 bug 面。** OpenViking 明确 `wait=true` 只等文件不等目录（最终一致）；Cognee 把 scope 路由与 LLM 路由拆开；Zep 把限流从 attempt 计数里摘出来。方向一致：把隐式语义显式化。集成方的动作是——不要假设「返回 200 就能检索到」。
3. **安全边界从「API key」移到「凭证与端点的绑定关系」。** OpenClaw 三处修复、OpenViking 的 OIDC 拒绝非法标识、Cognee 的默认拒绝连接串，是同一类问题的四种表现。
4. **抓取层在分化：云端卖索引，本地卖合规。** 索引是收入，本地是获客与合规门票；对 RAG 团队，抓取正在变成可嵌入组件，摄取层不再必须是一个集群。
5. **开源记忆项目出现「托管快、开源慢」的剪刀差。** Zep 托管 API 在改批量语义而 Graphiti 停在 10-20；Letta 的 GitHub Releases 停在 5 月而 PyPI 已到 10 月——版本入口本身已不可靠，不查 PyPI 会误判 Letta 停滞半年。

### 来源（模块 6）

- OpenViking｜https://github.com/volcengine/OpenViking/releases （v0.5.4 / v0.5.4.1 / langchain-openviking 0.2.0）
- Cognee｜https://github.com/topoteretes/cognee/releases （v1.6.7）
- Zep｜https://help.getzep.com/changelog （11-08）
- Google｜https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes （11-06）
- Firecrawl｜https://www.firecrawl.dev/changelog ；https://github.com/firecrawl/firecrawl/pull/5685
- NVIDIA Auto Ontology｜https://github.com/NVIDIA/auto-ontology
## 7. Observability / Eval / Guardrails 可观测与治理层

### 本周模块结论

1. **本周模块 7 最重要的不是任何一家厂商发版，而是 agent 的可观测数据模型被推倒重画**：OTel GenAI 语义约定从核心 semconv 仓库整体拆出到 `open-telemetry/semantic-conventions-genai`，窗内 19 个提交把 `invoke_agent`（内部/客户端两分）、`execute_tool`（独立 span）、`fetch_response` 三类 agent 信号重排，并为每一类补齐标准异常事件，同时强制结构化内容属性。该仓 CHANGELOG 只有 `Unreleased`、Schema URL 仍是 `TODO`——**整个行业正在用的 `gen_ai.*` 属性，其权威定义此刻没有稳定版本**。
2. **第二条主线是「可观测性不许猜」**：Langfuse 11-06 退役 automatic tokenization，宁可把「usage 缺失」暴露在 generation header 里，也不再估算成本；Arize Phoenix 的 OTel JS 3 迁移让 `register()` 不再应用 `OTEL_TRACES_SAMPLER` / `OTEL_BSP_*` 等环境变量——采样与批处理配置从「约定」变成「必须显式传对象」。
3. **机器身份进入策略求值域**：LangSmith 的 agent API key 调用按该 agent 的 tool policy 校验，Langfuse 的 USER api key scope 对 user 策略与 key 策略双求值——两家独立实现、同一周出现。
4. **护栏层洗牌已成型**：Guardrails AI 已被 Harvey 收购（2026-09-08，窗外）且窗内 0 提交；Helicone、AgentOps 双双停更一年以上；开源护栏的事实供给方只剩 NVIDIA NeMo Guardrails（窗内无版本，但主干在换判定模型）。

### 固定对象状态表

| 对象 | 窗口内状态 | 锚点 | 证据 |
|---|---|---|---|
| OpenTelemetry GenAI semconv | 有动态（结构性迁移，无版本） | 拆仓完成；新仓窗内 19 提交（11-05~11-06） | A/B |
| LangSmith | 有动态（周档 11-02~11-09，无逐条日期） | Online Insights、AI search、scoped tool policies、Gateway 单 trace | A（周档，D 级日期） |
| Arize Phoenix | 有动态（8 个发布） | phoenix-otel 3.0.0（11-11）、client 8.0.0、evals 3.10.0（11-10） | A |
| Langfuse | 有动态（4 个发布 + 1 changelog） | v4.76.0（11-05）、v4.77.0（11-09）、v4.78.0（11-10）、v3.227.1（11-10） | A |
| Braintrust | 有动态 | py 0.49.3（11-06）、js 3.44.0（11-11）、claude-plugin 3.0.6（11-10） | A |
| Guardrails AI | 无动态（项目已易主） | 最新 v0.11.0（08-14）；窗内 0 提交 | A/B/C |
| Helicone | 无动态 | releases 最新 2025-08-21；窗内 0 提交 | A/B |
| AgentOps | 无动态 | 最新 0.4.21（2025-08-29） | A/B |
| NeMo Guardrails | 有动态（无版本，主干 15 提交） | drop Python 3.10（11-06）；迁 nemotron-3.5-content-safety（11-10） | B |
| AWS AgentCore | 有动态（检索/注册表，非观测） | Web Search API GA（11-10） | A |
| Google Agent Platform | 有动态（治理侧） | 跨项目语义治理（11-10）、跨云 Gateway（11-11） | A |
| Databricks | 本次未取得日粒度 | 月档 | D |
| Coze Loop | 无动态 | 最新 v1.5.1（2026-01-20） | B |

### 深拆条目

#### OTel GenAI 约定拆仓：行业标准进入「无版本」状态（A/B）

**做了什么。** 旧文档页 `opentelemetry.io/docs/specs/semconv/gen-ai/` 现在只剩迁移公告：GenAI 约定「has moved and is no longer maintained in this repository」，指向新仓 `open-telemetry/semantic-conventions-genai`。新仓 11-11 仍在推送、532 stars，**无 GitHub Release**，`CHANGELOG.md` 只有 `## Unreleased`，Schema URL 一栏写着 `TODO`。窗内 19 个提交（11-05~11-06）做三类事：信号重排（`Fold invoke_workflow into gen_ai.invoke_agent.internal` #571、`Move execute tool signals to execute-tool.md, rename span type to gen_ai.execute_tool` #636、`Use gen_ai.client.invoke_agent.duration metric for remote agent invocations` #635）；内容模型收紧（`Require structured GenAI content attributes` #634、BlobPart content 可选化 #144、`gen_ai.request.stream` #513）；六类异常事件标准化（#658/#659/#667/#668/#669/#670）。

**怎么做到的。** 拆分动机的可见证据是依赖管理：新仓用 Weaver 声明对核心 semconv 的依赖，GenAI 面获得独立演进节奏，不再被核心仓的稳定化流程卡住；核心仓本周只剩 k8s、直方图桶、策略文件迁移。agent 信号从「一个 invoke_agent」变成三层：客户端侧（`gen_ai.client.invoke_agent`，含 `gen_ai.request.stream`）、内部侧（`gen_ai.invoke_agent.internal`，吸收原 `invoke_workflow` 并新增 `invoke_{framework_entrypoint}`）、工具侧（`gen_ai.execute_tool`，独立文档）。`Require structured GenAI content attributes` 让 prompt/response 可机器解析、可做 PII 扫描与回放；六类异常事件的价值是**可聚合**——此前「agent 失败」只能从 span status 推断。

**意味着什么。** 现在没有稳定版本可对齐，按 `gen_ai.*` 埋点的生产系统在跟一个会变的靶子；理性做法是把属性名收敛到**一层适配器**。采购时可以问厂商「发的是 `gen_ai.invoke_agent` 还是 `.internal`、异常走 event 还是 span status」——答不上来说明其 OTel 对齐停在拆分之前。

#### Langfuse：退役 token 估算，宁可缺失也不猜（A）

11-06 changelog「See when token usage is missing」：退役 automatic tokenization，理由是估算会在 thinking 模型与 cached-token 定价上系统性失真，且**掩盖坏掉的埋点**。替代路径是 usage 只来自 provider 上报、成本 = usage × 价格、缺失即显式缺失（generation header 显示并附修埋点链接），仍支持直接提交 cost；迁移影响新写入与 reprocess，历史不批量重写。同周 v4.78.0（11-10）新增 external HTTP code eval dispatcher（评测器可远程 dispatch 到自建规则服务或沙箱执行器）与 USER api key scope（user 策略 + key 策略双求值）；v4.76.0 让 audit logs 记录 trace/session/score 的**读**访问。**影响**：依赖 Langfuse 估算做 chargeback 的团队，本周之后数字会变空，必须让 SDK/网关上报 provider usage。

#### Arize Phoenix 3.0.0：环境变量这条路断了（A）

11-11 的 `@arizeai/phoenix-otel@3.0.0` 迁到 OTel JS 3：`register()` 返回 sdk-trace 的 `TracerProvider`、不再有 `register()` 方法；`spanProcessors` 必须来自 `@opentelemetry/sdk-trace` 且接 options 对象；**`register()` 不再应用 `OTEL_TRACES_SAMPLER`、`OTEL_SPAN_*`、`OTEL_ATTRIBUTE_*`、`OTEL_BSP_*` 环境变量**；要求 Node ≥22.15。机制实质是「所有权转移」：采样器与 span processor 的配置权回到调用方，代价是靠环境变量控制采样率的部署在升级后**采样率会静默回默认**（通常 100%），成本与噪声同时上升。同批 client 8.0.0、cli 1.22.0；evals 3.10.0（11-10）接入 OpenAI Decisions API 与 Anthropic 原生 structured output。

#### LangSmith：策略下沉到 agent API key（A 内容 / D 日期）

周档「November 2-9, 2026」：Online Insights 改为持续分析（每条新 insight 每周采样约 1,000 条 trace）；Full AI search 把自然语言编译成结构化 + 语义 + 时间三元过滤；**Scoped tool policies with call approvals** 可「阻断」或「要求批准」、同时命中阻断优先，作用域为 workspace / 单 workspace / 特定 agent 环境，**agent API key 的调用按该 agent 策略校验**；Gateway 每请求 1 trace、每次尝试 1 run，**在任何 provider 调用前被拒的请求也产生 trace**。日期只能定位到周区间，首公开可能早于窗口，按 D 级日期处理。

#### 护栏供给收缩：Guardrails AI 易主、NeMo 换模型（B/C）

Guardrails AI 于 2026-09-08 被 Harvey 收购（联合创始人 Shreya Rajpal、Zayd Simjee 及团队加入），公告未说明开源项目与 Hub 的归属安排、未给维护承诺；窗内 0 提交，最新 release 仍是 v0.11.0（08-14）。Helicone 最新 release 停在 2025-08-21、AgentOps 停在 2025-08-29。NeMo Guardrails 窗内 15 个提交：`build!: drop Python 3.10 support`（11-06，破坏性）、教程迁到 `nemotron-3.5-content-safety`（11-10）、修「并行 output rails 失败但流未结束」（11-11）。**影响**：护栏质量不再由 validator 数量决定，而由底层安全模型的版本决定；换模型会改变误报/漏报分布，升级须重跑自己的红队集。

### 模块洞察

1. **语义层重新分家，商业产品都没跟上。** 约定拆仓 + 无版本 + Schema URL 为 `TODO`，同时 Phoenix 做 OTel JS 3 硬迁移、Braintrust 加深私有属性、Langfuse 改成本语义——未来 1~2 季跨厂商 trace 可移植性处于历史低点；设计时把「属性名收敛在一层适配器」写成约束。
2. **「不猜」成为价值取向。** Langfuse 退役估算、Phoenix 取消环境变量隐式配置、OpenClaw 把缺失凭证显式报错而非当作「没有凭证」——共同点是把不确定性暴露给操作者，而不是用默认值掩盖。
3. **机器身份进入策略求值域。** LangSmith 与 Langfuse 两家独立实现同一周出现，agent 的 key 不再等于万能通行证，这是多租户平台落地的必要条件。
4. **护栏市场完成一轮出清。** Guardrails AI 并入 Harvey 且无维护承诺、Helicone/AgentOps 停更一年以上、Coze Loop 停在 1 月；开源护栏只剩 NeMo 一条主线且它在换判定模型。选型逻辑要从「生态丰富度」改为「模型换代节奏与红队可控性」。
5. **云厂的观测是治理的副产品，不是产品。** Google 用 Agent Gateway 把 trace 顺手送进 Cloud Trace，AWS 用 CloudTrail + 计价把检索变成可审计原语；两家本周都无独立 eval/observability 发布。这给第三方留出「跨云、跨 harness 统一视图」的空位。

### 来源（模块 7）

- OTel GenAI｜https://opentelemetry.io/docs/specs/semconv/gen-ai/ ；https://github.com/open-telemetry/semantic-conventions-genai
- Langfuse｜https://github.com/langfuse/langfuse/releases ；https://langfuse.com/changelog/2026-11-06-retiring-tokenization
- Phoenix｜https://github.com/Arize-ai/phoenix/releases
- LangSmith｜https://docs.langchain.com/langsmith/changelog
- Braintrust｜https://github.com/braintrustdata/braintrust-sdk-python/releases
- NeMo Guardrails｜https://github.com/NVIDIA-NeMo/Guardrails
- Guardrails AI｜https://guardrailsai.com/blog/guardrails-ai-joins-harvey
- AWS / Google｜https://aws.amazon.com/about-aws/whats-new/recent/feed/ ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
## 8. Managed Agent Platform / 企业控制面

### 本周模块结论

1. **企业控制面的共同答案是三件套：Registry（身份与目录）、Gateway（流量与策略）、Sandbox（执行隔离）。** 三家 hyperscaler 在同一周各补齐一块，且都把治理点从「agent 内部」上移到「网络与身份层」。
2. **Google 把治理推到云外。** 11-11 Agent Gateway for cross-cloud（Limited Preview）明确支持 EKS、AKS、OpenShift 与裸金属 K8s：agent 留在原地，由本地代理发身份、走 Registry、把 LLM/MCP/A2A 流量纳入 Model Armor 与访问策略，日志与 trace 回传 Cloud Logging/Cloud Trace。这是「控制面与数据面分离」的直接落地。
3. **AWS 把 AgentCore 从「运行时」扩成「运行时 + 目录 + 搜索」。** 11-06 Agent Registry 进 GovCloud；11-10 `InvokeWebSearch` 独立成 API（$7/1,000 次）；加上 11-05 Web Answer GA，「检索」被拆成三层不同计价的原语。
4. **微软把 harness 产品化。** Foundry 的 Copilot harness（preview）提供 managed loop and sandbox，创建 agent 时选定、之后**不可切换**，CPU/内存/空闲由 Foundry 托管；配合 11-05 GA 的 azd 扩展，形成「声明式定义 + 托管执行」。
5. **计价单位正在从 token 分裂出「查询/工具调用」。** Web Search $7/1k、Web Answer 按 tool call、PrivateLink 可达。企业采购口径要从「每百万 token」改成「每完成任务成本」，否则会低估检索密集 agent。

### 固定对象状态表

| 对象 | 窗口内状态 | 关键锚点 | 证据级 |
|---|---|---|---|
| AWS | 有动态（8 条） | Web Answer 11-05、Registry GovCloud 11-06、Web Search 11-10、Lambda MicroVMs x86 11-11、Emulator 11-11 | A |
| Google | 有动态（4 条） | Memory Bank 11-06、跨项目治理 11-10、跨云 Gateway 11-11 | A |
| Microsoft Foundry | 有动态（4 条） | azd 扩展 1.0 GA 11-05；Copilot harness（属 10 月，背景） | A/B |
| Databricks | 本次未取得日级日期（月档） | 页面戳 2026-10-29 | D |
| 阿里云百炼 | 本次未取得（2 入口，最新 2026-10-21） | — | — |
| 火山方舟 / Coze | 本次未取得（2 入口，仅文档导航） | — | — |
| 腾讯云 ADP | 本次未取得（产品页无发布记录） | 11-09 公告标题（见模块 2） | C |

### 深拆条目

#### AWS：检索拆成三层，控制面补齐目录与本地仿真（A）

**做了什么（窗口内 8 条）。**
- **11-05 Web Answer GA**：托管工具，一次调用返回**带引用的合成答案**，「plans and runs searches in parallel」，支持 domain allow/deny 与 publish-date 过滤，通过 MCP 挂到 AgentCore Gateway，IAM 鉴权，先在美国东部（弗吉尼亚北部）提供，按 tool call 计价。
- **11-05 Lambda durable functions 配额上调**：运行中的 durable execution 从 1,000,000 提到 5,000,000/account，API 请求速率同步上调；durable functions 支持最长一年、带 checkpoint 与自动重试的多步/AI 工作流。
- **11-05 OpenSearch optimized engine 支持 agent traces**：可摄入 OTel traces 与日志同栈，保留 span events/span links/prompts/tool calls 的嵌套结构，字段级查询无需扁平化，OpenSearch 3.7，不额外收费。
- **11-05 WAF AI traffic monetization 支持 Stripe 法币结算**：无有效凭据时返回 HTTP 402 并列出可接受的支付凭据类型，付款以本地货币结算到 Stripe 余额（不再依赖稳定币/加密钱包）。
- **11-06 Agent Registry 在 GovCloud (US-West) GA**：发布与发现 MCP servers、tools、agents、skills，审批流控制可见性，CloudTrail 记录。
- **11-10 `InvokeWebSearch`**：免 Gateway 直连，返回排序结果含文本摘录/标题/URL/发布时间，支持 domain 与 time 过滤，IAM、PrivateLink、CloudTrail，6 个区域，**$7 / 1,000 次查询**。
- **11-11 Lambda MicroVMs 支持 x86**：创建 MicroVM 镜像时可选 x86 或 Arm/Graviton，现有 x86 负载无需重编译；卖点「VM-level isolation, near-instant launch and resume, and state preservation」，定位 AI coding assistants、CI/CD runner、开发环境、漏洞扫描器。
- **11-11 AWS Emulator**：本地/CI 内跑 SDK/CLI 调用，毫秒级响应、无需账号、状态驻留内存、按端口/密钥/状态隔离实例、未实现操作返回 **501**、由 AWS API 模型生成、CC0 发布。

**怎么做到的。** 检索三层拆分是同一后端的三种粒度：Web Answer 是「问题 → 带引用答案」（内部并行多次搜索再合成），Web Search API 是「查询 → 排序结果集」，MCP 工具是「给 agent 的协议化入口」，因此可按答案/查询/工具调用分别计价与授权。Registry 的准入模型是发布与发现分离，审批流决定「可见性」而非「是否存在」，未获批资产不出现在发现结果里。MicroVM 的三项承诺（VM 级隔离 + 近即时启动/恢复 + 状态保留）同时成立才适合跑不可信代码；x86 的意义是免去为 Arm 重编译现有工具链。Emulator 由 API 模型生成而非手写 mock，覆盖率随 API 更新，501 避免「假成功」污染本地测试结论。

**意味着什么。** 采购口径必须改：一个每天 10 万次检索的 agent，仅检索成本即 $700/天，可能超过同等工作量的模型 token 支出。合规上，Registry + CloudTrail 使公共部门能回答「我们有哪些 agent、谁批准、谁用过」。架构上，Web Answer 把「检索 + 合成」合并成一次调用、减少编排步数，但把「引用如何选择」变成平台黑箱，需确认引用可回溯。

#### Microsoft Foundry：harness 的「创建时绑定、之后不可切换」（A/B）

**做了什么。** 11-05 `microsoft.foundry` azd 扩展 1.0 GA：agent 与部署配置保存在 `azure.yaml`，覆盖本地测试、评估、部署与 CI/CD。同在 11-05 发布的十月月度综述（内容属 10 月，标背景）披露 Copilot harness public preview：提供「managed loop and sandbox for work that needs more than a single model response」，agent 可读文件、跑代码、用工具、套用可复用 skills；**创建 agent 时选定 harness，之后切换不支持**；Foundry 管理沙箱的 CPU/内存/空闲设置；既有 agent 行为不变。同综述另有 hosted agents 韧性 GA：「After interruption, Foundry can restart work with its original input」，但应用须自存中间结果、已完成步骤与幂等标识——「Checkpointing and idempotency belong together.」

**怎么做到的。** harness 是「循环 + 沙箱」的托管实现：模型只负责「下一步」，harness 把下一步变成实际动作并在平台沙箱里执行。**创建时绑定**说明 harness 与 agent 定义是编译期关系（影响工具协议、状态格式），不是运行期开关。韧性靠「重启 + 幂等」而非「不失败」：平台只兜住「进程没了」，兜不住「外部系统被调了两次」。浏览器自动化则把 Playwright Workspace 独立预置、经 Toolbox 远程 MCP 端点接入，浏览器身份与 agent 身份分离。

**意味着什么。** harness 托管把「执行环境」从客户责任变成平台责任，但不可事后切换是硬约束——**选型即架构决策，迁移等同重建 agent**。这也给开源 harness 留出空间：可替换性本身就是卖点。

#### Databricks / 国内三家：月档与不可核验（D/未取得）

- **Databricks**：月档索引（页面戳 2026-10-29）。Unity Gateway 上架 Gemini 4 Carbon、Claude Fable 5.2、Kimi K3.1 Pro，BYO ChatGPT 订阅到 Codex，MDM 预置 Claude desktop，SSH tunnel 内跑 Claude Code 与 Codex，Smart Routing「routes subagents only」（Beta），AI Functions 用量纳入网关预算。路线与 Google Agent Gateway 同构（网关做治理、客户端可替换），但**缺日级锚点，全部标背景，不计入本周事件**。
- **阿里云百炼**：2 个入口，应用发布记录最新 2026-10-21，release notes 仅分类索引无日期条目。**火山方舟**：2 个入口，均 301 至文档导航、无 release notes。**腾讯云 ADP**：产品概览与定价页无发布记录；11-09 公告仅标题（见模块 2）。三家本模块**不作事实陈述**。

### 模块洞察

1. **控制面三件套成形，且都落在「身份」上。** AWS 的 Registry（审批 + CloudTrail）、Google 的 Registry + Gateway（可验证身份 + 策略）、微软的 harness（创建时绑定、平台管沙箱）都在回答「这个动作是谁发的、被允许吗」。差异在落点：AWS 落在目录与审计，Google 落在网络代理，微软落在执行环境。已有多云的企业，Google 的 cross-cloud gateway 是唯一不要求迁移的方案。
2. **「跨云治理」比「跨云运行」更早成熟。** 下一轮竞争不在算力价格，而在**策略表达能力**（能否用同一套策略描述 LLM、MCP、A2A 三类流量）与**身份连续性**（跨项目/跨云不换主体）。
3. **检索成为独立计价品类。** $7/1k queries、按 tool call、PrivateLink 可达，把检索从「模型上下文的一部分」拆成可单独采购、单独限流、单独审计的服务。对成本模型的影响大于对能力的影响。
4. **托管 harness 的「不可切换」是本周最被低估的约束。** 它说明 harness 已深入影响工具协议与状态格式；选型即架构决策。
5. **中国区三家本周不可核验。** 百炼/方舟/ADP 的发布记录要么无日级条目、要么为 JS 渲染索引页。建议下一期改用厂商公众号/产品动态 RSS 或控制台公告作为回退入口，并在方法上坚持「日级锚点」而非列表页相对时间。

### 来源（模块 8）

- AWS What's New feed｜https://aws.amazon.com/about-aws/whats-new/recent/feed/ ｜2026-11-05~11-11
- AgentCore Release Notes｜https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html
- Google Agent Platform Release Notes｜https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes
- Microsoft Foundry Blog｜https://devblogs.microsoft.com/foundry/feed/ ；https://devblogs.microsoft.com/foundry/
- Databricks Product Release Notes｜https://docs.databricks.com/aws/en/release-notes/product/
- 阿里云百炼｜https://help.aliyun.com/zh/model-studio/application-release-notes ；https://help.aliyun.com/zh/model-studio/release-notes
- 火山方舟｜https://docs.volcengine.com/docs/82379 ；腾讯云 ADP｜https://cloud.tencent.com/product/adp
## 9. 汇总：对比表、能力矩阵与判断

### 9.1 必出对比表

| 模块 | 产品/厂商 | 版本或日期 | 变化 | 是否破坏性 | 证据级 |
|---|---|---|---|---|---|
| 1 | OpenClaw | v2026.11.3（11-10） | `/reset` 改为向 Gateway 转发 soft reset；未应答工具失败显式化；插件结果按连接凭证隔离 | 是 | A |
| 1 | OpenClaw | v2026.11.1 / 11.2（11-05/11-08） | 子代理 follow-up 跨模型保留；`PATH` 剔除工作区可执行路径；日志脱敏 | 部分 | A |
| 1 | OpenClaw | v2026.9.37（11-10） | gateway-only `extended-stable` 维护版，28 PR | 否 | A |
| 1 | Anthropic Claude Code | v2.1.319（11-06） | `permissions.denyInsteadOfPrompting`；MCP tasks 后台化；修 worktree 沙箱逃逸 | 是 | A |
| 1 | Anthropic Claude Code | v2.1.321（11-09） | 修 MCP OAuth 重定向把 refresh token 发往他主机；Fable 5.2 设为默认 | 否（安全修复） | A |
| 1 | Anthropic Claude Code | v2.1.322（11-10） | Vertex 三区域 fast mode | 否 | A |
| 1 | OpenAI Agents SDK | py 0.24.0-alpha.7 / js 0.22.0-alpha.2（11-08） | 应用自有 `SessionStore`；`RunBudget` 只计 root；MCP 重连不重放；exact-step steering | 是（alpha） | A/B |
| 1 | LangGraph | 1.2.20（11-05） | 每个 `interrupt()` 独立 id；strict resume 拒绝陈旧答案 | 是 | A |
| 1 | LangChain / core | 1.5.0 / 1.8.0（11-11） | `BaseDecisionModel` 进 core；ModelRouter/AutoMode 中间件（classifier 必填、beta） | 否（新增） | A |
| 1 | LangSmith | Nov 2–9 周档 | scoped tool policies + call approvals；Gateway 每请求 1 trace | 否 | A（日期 D） |
| 1 | Google ADK | 2.14.0（11-07） | Environment/Daytona/E2B 转 stable；枚举参数 breaking；`RunSkillScriptTool` 结构化参数 | 是 | A |
| 1 | Microsoft Agent Framework | python-1.25.0 / dotnet-1.28.0（11-06/07） | 单授权作用域；空 allowlist 拒绝一切；异常默认脱敏；A2A message-only | 是 | A |
| 1 | Semantic Kernel | python-1.47.0（11-05） | 要求 Python 3.11+ | 是 | A |
| 1 | CrewAI | 1.15.36–1.15.40（11-06~11） | 实验性会话式 sessions；默认模型 `gpt-6-luna`；移除 ChromaDB | 部分 | B |
| 1 | pydantic-ai | 2.67.0（11-10） | durable execution 扩展：DBOS 子工作流、`task_control`、队列优先级 | 否 | B |
| 1 | Dify | v1.19.0（11-04，窗外） | 补登背景，不计入本周 | — | A |
| 2 | AWS AgentCore Runtime | V2（11-09 旁证，月级日期） | 快照恢复，P75 冷启动≈2s；单会话并发 16→250；`OverheadLatency`；MCP `2026-07-28` + `GET /ping` | 是 | A/B |
| 2 | AWS | 11-10 | `InvokeWebSearch` 独立 API，$7/1,000 次 | 否 | A |
| 2 | AWS | 11-05 | Web Answer GA（带引用合成答案，按 tool call 计价） | 否 | A |
| 2 | Google | 11-11 | Agent Gateway for cross-cloud（EKS/AKS/OpenShift/裸金属，Limited Preview） | 否（preview） | A |
| 2 | Google | 11-10 | 语义治理跨项目：`AGENT_MANAGEMENT` 边界 + 保留 `RuntimeIdentity` | 是（部署约束） | A |
| 2 | Google | 11-06 | Memory Bank 独立 Console（五段配置、`key:value` scope、revision） | 否 | A |
| 2 | Microsoft Foundry | 11-05 | `microsoft.foundry` azd 扩展 1.0 GA；要求 azd≥1.37 / Python≥3.13 | 否 | A |
| 2 | 阿里云百炼 | 最新 2026-10-21 | 窗口内零条目（已核验） | — | A |
| 2 | 腾讯云 ADP | 11-09 | 《AgentPortal 开放使用公告》仅标题 | 未知 | C |
| 2 | 火山方舟 / Coze | — | 本次未取得（两入口不可机读） | — | — |
| 3 | AWS Nitro Sandboxes | 11-09 | 每 Pod 一台 guest kernel；Nitro Partition；`runtimeClassName: isolated-sandbox`；K8s≥1.36 | 是 | A |
| 3 | browser-use | 1.0.0/1.0.1（11-10）、1.0.2（11-11） | 常驻 Python REPL + 裸 CDP；代码 68,815→13,154 行；云浏览默认 | 是 | A |
| 3 | Browserbase | 11-04 | Navigation Policies：页面/iframe/弹窗/每一跳重定向检查 | 否 | A |
| 3 | Stagehand | 4.4（11-05） | `disconnect()` 不断会话；crash-safe（扩展检测）；Chrome≥137 | 否 | A |
| 3 | agent-browser | v0.42.0（11-10） | saved flows 三层降级回放；单一 daemon 会话决策 | 否 | A |
| 3 | Anthropic | 11-09 | `computer_toolset_20260801`；旧工具集非 Bedrock 平台返回 400 | 是 | A |
| 3 | E2B | 11-05~11-11 | 真空窗（最新 11-04 `e2b@2.63.0`） | — | A |
| 3 | Modal / Daytona | 11-05/11-07 | 无 sandbox 语义变更；Daytona 仓库已归档 | — | A/B |
| 4 | MCP | 11-10 | files 扩展草案：直连 HTTPS PUT/GET、`credentials: omit\|include`、`requestState` | 否（草案） | A |
| 4 | MCP Registry | v1.8.8 / 1.8.9（11-06/11-10） | 不同 name 可共享 remote URL；身份改（name, version） | 是（对镜像网关） | B |
| 4 | A2A | 11-05 | CIMD 发布到站点根目录，`client_id` = 文档 URL | 否 | B |
| 4 | Composio | beta.535–538（11-06~11-10） | custom toolkit 支持 `mcpUrl`（`feat(core)!`）；Custom Tools 改名 `localTools`；audit logs | 是 | B |
| 4 | Arcade | #996（11-10）、1.13.0 preview（11-11） | 无 `client_id` 不再回落共享 `"unknown"`；按执行记录 key/gateway | 是 | B |
| 4 | Nango | v0.72.2–.4（11-05~11-09） | 连接级工具发现；OAuth2 public client；可禁用托管 app | 部分 | B |
| 4 | AWS AgentCore Gateway | 11-05 | Web Answer connector GA（`us-east-1`） | 否 | A |
| 5 | AWS | 11-09 | STS 跨 partition 联邦：`GetWebIdentityToken` + `AssumeRoleWithWebIdentity` | 否 | A |
| 5 | AWS Agent Registry | 11-06 | GovCloud (US-West) GA，原生 MCP 端点、审批流、CloudTrail | 否 | A |
| 5 | Microsoft Entra Agent ID | — | 公开页停在 2026-06；窗口内无可核验条目 | — | A |
| 5 | Claude Code | v2.1.321（11-09） | MCP OAuth 跨 host 重定向剥离凭据 | 是（客户端下限） | A |
| 5 | OpenClaw | v2026.11.3（11-10） | 缓存键含连接凭证；hook 钉在 provider origin；凭证脱敏 | 否（修复） | B |
| 6 | OpenViking | v0.5.4 / 0.5.4.1（11-09/11-11） | MCP 工具挂成 `viking://` 文档节点；锁租约变更；`wait=true` 只等文件 | 是 | A |
| 6 | Cognee | v1.6.7（11-06） | 默认拒绝原始 DB 连接串与 `s3://`；scope 与 LLM 路由拆分 | 是（connector 被打断） | A |
| 6 | Zep | 11-08 | 限流不消耗 processing attempt；batch item 带 `error` 对象 | 否 | A |
| 6 | Firecrawl | PR #5685（11-11 建，11-12 合） | 本地 Rust 单二进制，idle≈11MB；基准 237 pages/s | 否 | B |
| 6 | NVIDIA Auto Ontology | v1.2.0（11-05） | 企业元数据 → ontology，MCP/CLI/API 暴露，答案带 provenance | 否 | B |
| 7 | OTel GenAI semconv | 11-05/11-06 拆仓 | 迁至 `semantic-conventions-genai`；信号重排；无 Release、Schema URL `TODO` | 是 | A/B |
| 7 | Langfuse | 11-06 | 退役 automatic tokenization，成本缺失即显式缺失 | 是 | A |
| 7 | Arize Phoenix | phoenix-otel 3.0.0（11-11） | 迁 OTel JS 3；`register()` 不再应用 `OTEL_*` 环境变量 | 是 | A |
| 7 | LangSmith | Nov 2–9 | 工具策略按 agent API key 求值；Gateway 单 trace | 否 | A（日期 D） |
| 7 | NeMo Guardrails | 11-06/11-10 | drop Python 3.10；迁 `nemotron-3.5-content-safety` | 是 | B |
| 7 | Guardrails AI | 2026-09-08（窗外） | 被 Harvey 收购；窗内 0 提交 | 已迁出 | A/B |
| 8 | AWS | 11-11 | Lambda MicroVMs 支持 x86；AWS Emulator（CC0、501 语义） | 否 | A |
| 8 | AWS AgentCore Harness | 11 月档 | Strands-powered managed defaults（推荐模型、内建工具） | 否 | A |
| 8 | Microsoft Copilot harness | 10-28（背景） | managed loop + sandbox；创建时绑定、事后不可切换 | 是（选型） | B |
| 8 | Databricks | 月档 | Unity Gateway 扩模型/客户端；Smart Routing 仅子代理 | 未知 | D |

### 9.2 云厂能力矩阵（截至 2026-11-11，仅列可核验项）

| 能力 | AWS | Google | Microsoft | 阿里云 | 腾讯云 | 火山方舟 |
|---|---|---|---|---|---|---|
| 托管 Agent Runtime | AgentCore Runtime V2（快照启动、250 并发/会话） | Agent Runtime + Agent Engine | Foundry Hosted Agents（azd 1.0） | 百炼（窗内无公开更新） | ADP（AgentPortal 仅标题） | 未取得 |
| 会话/状态 | 会话级计费、MCP 会话头、`/ping` | Memory Bank + Session | 服务端会话 + checkpoint 责任在应用 | 未取得 | 「会话多端互通」无日期 | 未取得 |
| 沙箱隔离 | **Nitro Sandboxes（每 Pod 独立内核）** + Lambda MicroVMs | 容器化 Code Interpreter | Foundry 托管沙箱（CPU/内存/空闲托管） | 未取得 | 「云端沙箱执行」无日期 | 未取得 |
| 浏览器 / 代码解释器 | AgentCore Browser / Code Interpreter（容器、15min~8h） | 无窗内条目 | Playwright Workspaces + Toolbox MCP（10 月 GA） | 未取得 | 未取得 | 未取得 |
| 工具网关 / MCP | AgentCore Gateway（Web Answer、Registry 原生 MCP） | Agent Gateway（跨云、策略扩展） | Foundry Toolbox MCP | 未取得 | 未取得 | 未取得 |
| Agent 身份 | AgentCore Identity + STS 跨 partition | Agent Identity（`principal://`、AIR sidecar） | Entra Agent ID（公开面停在 6 月） | 未取得 | 未取得 | 未取得 |
| 记忆 | 无独立产品（靠外部） | Memory Bank（Console、schema/TTL/revision） | Foundry 内记忆能力（未单列） | 未取得 | 未取得 | OpenViking（开源，非云产品） |
| 可观测 | CloudTrail + `OverheadLatency` + OpenSearch traces | Cloud Logging / Cloud Trace（Gateway 副产品） | Azure Monitor（未单列） | 未取得 | 未取得 | 未取得 |
| 跨云治理 | 无（Registry 扩 GovCloud） | **有（cross-cloud Gateway，Limited Preview）** | 无 | 无 | 无 | 无 |
| 计价单位 | token + 查询（$7/1k）+ tool call | token + 模型档位 | token + 托管沙箱 | 未取得 | 未取得 | 未取得 |

### 9.3 模块 × 厂商信号强度（图 1 数据源）

强度定义：**0** = 窗口内无信号；**1** = 仅有背景/窗外信息；**2** = 有窗内单一更新（A/B 级）；**3** = 窗内有结构性变化（影响架构或契约）。空白表示该厂商不属于此模块的主要对象。

| 模块 \ 对象 | OpenClaw | Anthropic | OpenAI | LangChain | Google | Microsoft | AWS | Databricks | 阿里/腾讯/火山 | 中立/开源厂商 |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 Harness/Agent OS | 3 | 3 | 2 | 3 | 2 | 3 | 1 | 1 | 1 | 2 |
| 2 Runtime/Session | 3 | 1 | 1 | 1 | 3 | 2 | 3 | 1 | 1 | 2 |
| 3 Sandbox/Browser | 1 | 3 | 1 | 0 | 1 | 2 | 3 | 0 | 0 | 3 |
| 4 Tool Gateway/Protocol | 1 | 1 | 1 | 1 | 3 | 1 | 2 | 0 | 0 | 3 |
| 5 Identity/Auth | 2 | 2 | 1 | 1 | 3 | 1 | 2 | 0 | 0 | 2 |
| 6 Context/Memory | 1 | 0 | 0 | 1 | 3 | 1 | 1 | 0 | 1 | 3 |
| 7 Observability/Guardrails | 1 | 1 | 1 | 2 | 1 | 1 | 1 | 0 | 0 | 3 |
| 8 Managed Platform | 0 | 0 | 0 | 0 | 3 | 3 | 3 | 1 | 1 | 0 |

> 读法：横向看「这一层本周谁在动」，纵向看「这家本周在几层同时动」。Google 与 AWS 是纵向最宽的两家（各 4 层为 3），OpenClaw 与 Anthropic 在控制层最密集；国内三家在 8 个模块中均只有 1 分或空白——这是**公开信号缺失**，不是能力判断。

### 9.4 TOP5 及依据

**1. AWS Nitro Sandboxes（11-09）——执行侧：隔离从容器上移到内核。**
依据：官方博客 A 级原文，机制可逐条核（Nitro Partition、`runtimeClassName: isolated-sandbox`、confidential 模式的证明→Cedar→KMS 链）。入选理由：它把「不可信 agent 代码」的边界从共享内核换成每 Pod 独立 guest kernel，且接入成本是一行字段——这是本周唯一改变**信任基座**的发布。局限：只覆盖 EKS，ECS/EC2 细节未取得；官方未给价格与启动耗时。

**2. Google Agent Gateway for cross-cloud（11-11）+ 跨项目语义治理（11-10）——治理侧：控制面离开云。**
依据：release notes 两条 A 级 + 机制页 C 级（KSA token→WIF→`principal://`→证书；Envoy + AIR sidecar；`AGENT_MANAGEMENT` 边界保留身份）。入选理由：它是唯一不要求迁移工作负载的跨云治理方案，且明确「语义治理不覆盖 MCP 工具调用」这条边界，避免企业误判合规覆盖。局限：Limited Preview，计价未公布；跨云 `failOpen` 断连不生效。

**3. Anthropic Claude Code 权限降级 + OAuth 修复（11-06/11-09）——凭证侧：拒绝成为控制流。**
依据：CHANGELOG 原文 A 级（`denyInsteadOfPrompting`、MCP tasks 后台化、OAuth 重定向泄密修复）+ OpenClaw v2026.11.3 的凭证隔离 B 级作交叉印证。入选理由：把「无人应答」从挂死改成确定性失败，是所有后台/子代理编排的前置条件；同周的 OAuth 修复则说明凭证作用域仍是最薄弱环节。局限：Anthropic 单厂商实现，其他 harness 需自行等价。

**4. MCP 文件扩展草案（11-10）——协议侧：数据面从 JSON-RPC 拆出。**
依据：官方博客草案 A 级（`io.modelcontextprotocol/files`、`credentials: omit|include`、`requestState`、`maxInlineBytes`/`maxSize`/digest）。入选理由：它第一次在协议层承认「工具调用会产生 JSON-RPC 之外的数据面」，并把「MCP 令牌是否随请求走」写成字段；对网关审计/DLP 是结构性影响。局限：Experimental、无参考实现，年底前能否定稿未知。

**5. AWS AgentCore Runtime V2（11-09 旁证）——运行时：会话取代实例成为单位。**
依据：官方 release notes（版本/Region/并发/`OverheadLatency` 为 A）+ 11-09 Weekly Roundup（P75≈2s、旧 runtime 5.4s→30s 为 B）。入选理由：冷启动从「选 region 赌一把」变成可承诺项，250 并发/会话让「一会话一连接池」的绕行设计可以退役；同周 OTel GenAI 拆仓与 browser-use 1.0 分别重画了「可观测单位」与「浏览器执行单位」，三件事共同指向「执行单位被重新定义」。局限：V2 具体日期只有月级；`/ping` 是存量 MCP server 的迁移门槛。

**未入 TOP5 但值得单列**：browser-use 1.0 的架构重写（模块 3 深拆）、OTel GenAI 拆仓（模块 7 深拆）、OpenClaw 四版本（模块 1/2 双覆盖）。

### 9.5 覆盖表（8 模块固定对象 + OpenClaw 终端状态）

| 模块 | 对象 | 终端状态 | 说明 |
|---|---|---|---|
| 1 | OpenClaw | **有动态（4 版本）** | 控制层 + 运行时双覆盖；`extended-stable` 9.37 为采购推荐线 |
| 1 | Anthropic Claude Code / Agent SDK | 有动态 | 3 个 CC 版本、TS 3 个、Py 2 个 |
| 1 | OpenAI Agents SDK | 有动态（alpha） | 双语言同日 |
| 1 | LangChain / LangGraph / LangSmith | 有动态 | 含 decision model 与 strict resume |
| 1 | Google ADK | 有动态（仅 Python） | js/java 无动态 |
| 1 | Microsoft Agent Framework / SK / AutoGen | 有动态（AF/SK） | AutoGen 无 release |
| 1 | Databricks Mosaic / Agent Bricks | 未取得日级 | 月档，标背景 |
| 1 | Dify | 无动态 | v1.19.0 窗外一天 |
| 1 | CrewAI / pydantic-ai | 有动态 | 动态池，B 级 |
| 1 | trueforge | 未取得 | 2 入口 404，不计入 |
| 2 | AWS AgentCore Runtime | 有动态 | V2 月级 + 11-09 旁证 |
| 2 | Google Agent Runtime / Gateway | 有动态 | 3 条日级 |
| 2 | Microsoft Foundry Hosted Agents | 有动态 | 1 条窗内 + 1 条月度综述 |
| 2 | 阿里云百炼 | 无动态（已核验） | 最新 2026-10-21 |
| 2 | 腾讯云 ADP | 有动态（标题级） | AgentPortal 公告，正文未取得 |
| 2 | 火山方舟 / Coze | 未取得 | 两入口不可机读 |
| 2 | OpenClaw sessions/cron/Gateway | 有动态 | 4 版本 |
| 2 | E2B / Modal / Daytona | 无 runtime 语义变更 | E2B 真空窗；Daytona 仓库归档（迁出 GitHub） |
| 3 | AWS Nitro Sandboxes | 有动态（新增关注） | 11-09，A 级 |
| 3 | E2B（沙箱侧） | 无动态 | 真空窗 |
| 3 | Browserbase / Stagehand | 有动态 | 3 条 |
| 3 | browser-use | 有动态 | 1.0 重写 |
| 3 | agent-browser | 有动态 | 0.42.0 |
| 3 | Modal / Daytona | 无 sandbox 语义变更 | — |
| 3 | OpenAI Computer Use | 无窗内动态 | 最近 10-26（背景） |
| 3 | Anthropic Computer Use | 有动态 | 11-09 工具集硬切换 |
| 3 | AWS Browser / Code Interpreter | 无发布条目 | 能力面已核 |
| 3 | Azure Browser Automation | 无独立条目 | GA 属 10 月（背景） |
| 4 | MCP 规范 / Registry / SDK | 无新版；有扩展草案 | 规范 `2026-07-28` |
| 4 | A2A | 无发版；CIMD | 11-05 |
| 4 | Composio / Arcade / Nango / Pipedream | 前三有动态，Pipedream 无 | — |
| 4 | AWS AgentCore Gateway | 有动态 | Web Answer connector |
| 4 | Google Agent Gateway | 有动态 | 11-11 |
| 4 | Azure API Center / Foundry toolbox | 未取得 | 3 入口 404/0 结果 |
| 5 | AWS AgentCore Identity | 无 Identity 条目；关联 2 项 | Registry / STS |
| 5 | Entra Agent ID | 无公开动态 | 公开页停在 6 月 |
| 5 | M365 Message Center | 未取得 | 需管理员登录 |
| 5 | Google Agent Identity / 语义治理 | 有动态 | 2 条 |
| 5 | Arcade / Composio / Nango / Pipedream auth | 前三有动态 | — |
| 5 | Claude Code / OpenClaw 凭证修复 | 有动态 | 2 条 |
| 6 | OpenViking | 有动态 | 2 个版本 |
| 6 | Mem0 / supermemory / Letta / Crawl4AI | 无动态 | Letta 版本入口不可靠（PyPI 到 10-12） |
| 6 | Cognee / Zep | 有动态 | — |
| 6 | Firecrawl | 有动态（语料）+ 临界 PR | PR 合并于窗外 |
| 6 | Google Memory Bank | 有动态 | 11-06 |
| 6 | NVIDIA Auto Ontology（名单外） | 有动态 | v1.2.0 |
| 7 | OTel GenAI semconv | 有动态（结构性） | 无版本 |
| 7 | LangSmith / Phoenix / Langfuse / Braintrust | 有动态 | — |
| 7 | Guardrails AI | **已迁出**（被 Harvey 收购） | 保留覆盖行 |
| 7 | Helicone / AgentOps / Coze Loop | 无动态 | 停更 12 个月以上 |
| 7 | NeMo Guardrails | 有动态（无版本） | 换判定模型 |
| 7 | Databricks | 未取得日级 | 月档 |
| 8 | AWS / Google / Microsoft | 有动态 | 各 4~8 条 |
| 8 | Databricks / 阿里 / 腾讯 / 火山 | 月档或未取得 | — |

### 9.6 名单外发现（discovery layer）

四组共记录 40+ 条名单外线索，进入正文的只有 3 条（NVIDIA Auto Ontology、Google Decisions API、MCP files 扩展草案——后者已成模块 4 主条）。其余按纪律保留为下期候选，理由是「无法确认窗内首发」或「仅 README 级、机制不可核」。

- **A 组**：herdr（后台会话 + blocked/idle 状态机）、agent-desktop（无障碍树 computer use，22.1k stars）、Atuin Threads（跨机会话同步，一手页 404 未核实）、Agent Skills 四仓同时进周榜。A 组的一句话判断值得保留：**「多 agent 并发的人机交接状态机」正在成为 harness 的第四个核心原语**（次于循环、工具、沙箱）。
- **B 组**：OpenMausBot（每 bot 一台机器，消费级）、Pomerado（任意网站 → MCP）、United Airlines 禁止 agent 代订（需求侧对抗）、AWS Emulator（CI 无账号跑云 API）。B 组结论：**本周没有新的沙箱厂商**，沙箱新闻全部来自既有玩家。
- **C 组**：IETF OAuth 的 agent 授权草案群（均早于 11-05，只能作背景）、Ianua（IdP 与 agent 网关合并）、agentkeygate（临时授权）、toolsmith-mcp（审批门控）。C 组观察：GitHub 上 `created:>2026-11-01` 的 agent gateway 仓库有 494 个——**「网关 + 策略层」已成开源默认组合**，差异只剩策略语言与凭证模型。
- **D 组**：NVIDIA Auto Ontology（已纳入）、Firecrawl Local PR #5685（窗内创建、窗外合并）、Atuin Threads（未取得正文）、Databricks 日粒度（未取得）。

### 9.7 覆盖与局限

1. **第 20 期缺号**：本期与第 19 期直接对比，10-29 ~ 11-04 的事实只作背景（标「补登/上期未刊，非本周」），不补做、不扩窗。
2. **WebSearch 在本环境返回 403**，全部取证改用 `WebFetch` 直取一手 URL；因此可能漏掉没有稳定入口的公告（国内云最明显）。
3. **国内三家公开面不可核验**：百炼零条目（最新 10-21）、火山两入口仅导航页、腾讯仅 11-09 标题。已写入 `delivery.md`「需 Bot 补证」，未作任何机制推断。
4. **日期精度**：AgentCore Runtime V2 只有月级日期（由 11-09 roundup 旁证）；LangSmith 为周档（D 级日期）；Databricks 为月档。正文均已标注。
5. **单一来源风险**：AWS Nitro Sandboxes 的机制全部来自一篇官方博客，未取得独立复核；其 ECS/EC2 细节、价格、启动耗时均为缺口。
6. **未取得清单**（均列 ≥2 个已试入口）：火山方舟、腾讯 ADP 正文、Azure API Center/Foundry toolbox、M365 Message Center、Atuin Threads 正文、Databricks 日粒度、Nitro 的 ECS/EC2 细节。

### 9.8 来源总表

- **AWS**：https://aws.amazon.com/about-aws/whats-new/recent/feed/ ；https://aws.amazon.com/blogs/containers/aws-nitro-sandboxes-hardware-enforced-workload-isolation-on-amazon-eks/ ；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ；https://aws.amazon.com/blogs/aws/aws-weekly-roundup-agentcore-runtime-v2-amazon-dynamodb-bulk-put-items-and-more-november-9-2026/
- **Google**：https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/policies/configure-semantic-governance.md.txt ；https://docs.cloud.google.com/gemini-enterprise-agent-platform/agents/governance/agent-gateway-cross-cloud/overview.md.txt ；https://aistudio.google.com/docs/changelog
- **Microsoft**：https://devblogs.microsoft.com/foundry/feed/ ；https://learn.microsoft.com/en-us/entra/fundamentals/whats-new
- **Anthropic**：https://github.com/anthropics/claude-code/releases ；https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md ；https://platform.claude.com/docs/en/release-notes/overview
- **OpenAI**：https://github.com/openai/openai-agents-python/releases ；https://github.com/openai/openai-agents-js/releases ；https://developers.openai.com/api/docs/changelog
- **OpenClaw**：https://github.com/openclaw/openclaw/releases ；https://docs.openclaw.ai/releases/2026.11.2
- **MCP / A2A**：https://modelcontextprotocol.io/specification/2026-07-28/changelog ；https://github.com/modelcontextprotocol/registry/releases ；https://github.com/a2aproject/A2A/commits
- **中立厂商**：https://github.com/langchain-ai/langgraph/releases ；https://github.com/langchain-ai/langchain/releases ；https://github.com/google/adk-python/releases ；https://github.com/microsoft/agent-framework/releases ；https://github.com/crewAIInc/crewAI/releases ；https://github.com/pydantic/pydantic-ai/releases
- **沙箱/浏览器**：https://github.com/browser-use/browser-use/releases ；https://www.browserbase.com/changelog ；https://github.com/vercel-labs/agent-browser/releases ；https://github.com/e2b-dev/E2B/releases ；https://modal.com/changelog ；https://www.daytona.io/changelog
- **记忆**：https://github.com/volcengine/OpenViking/releases ；https://github.com/topoteretes/cognee/releases ；https://help.getzep.com/changelog ；https://www.firecrawl.dev/changelog ；https://github.com/NVIDIA/auto-ontology
- **可观测**：https://opentelemetry.io/docs/specs/semconv/gen-ai/ ；https://github.com/open-telemetry/semantic-conventions-genai ；https://github.com/langfuse/langfuse/releases ；https://github.com/Arize-ai/phoenix/releases ；https://docs.langchain.com/langsmith/changelog ；https://github.com/NVIDIA-NeMo/Guardrails
- **国内**：https://help.aliyun.com/zh/model-studio/application-release-notes ；https://cloud.tencent.com/announce ；https://docs.volcengine.com/docs/82379
