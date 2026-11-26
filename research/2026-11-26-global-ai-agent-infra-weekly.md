# 全球 AI Agent 基础设施研究周报 · 第 23 期（冻结母稿）

- 运行日：2026-11-26（周四，Asia/Shanghai）
- 本期窗口：**2026-11-19 00:00 ~ 2026-11-25 24:00 CST**（= 2026-11-18 16:00Z ~ 2026-11-25 16:00Z）
- 期号：第 23 期｜上期：第 22 期（2026-11-19，窗口 11-12~11-18，主线「Agent 长跑，进度要自己存」）
- 缺期说明：第 20 期（2026-11-05）仍缺，不补做、不扩窗、不改号。
- 证据级：A 可核原始事实｜B 具名披露｜C 有限独立佐证｜D 欠证/争议。等级只在本文件与 status 出现。
- 口径：全文「本周」只指上述区间；GMT/Z 时间戳均换算为 CST 后判归属；窗外一律标「背景，非本周」。

---

## 摘要（给编辑，不直接进读者稿）

**本期主线：Agent 的治理执行点，从 agent 内部搬到了企业既有的网络、网关与身份目录。**

四条互不依赖的一手证据在同一周出现，指向同一件事：

1. **AWS**（11-24 02:47 CST）让 WAF 直接识别并阻断 MCP/A2A 流量的协议违规消息，发现层由 API Gateway 的 API Portal 从流量日志与服务配置里做，不需要在 agent 或 MCP server 里装任何东西。
2. **Microsoft**（11-19 01:00 ~ 11-25 00:52 CST）把托管 agent 的出口策略放到沙箱之外求值、默认拒绝，并用 Azure Policy 在**创建 agent 版本之前**强制绑定；MCP 工具流量改为经客户自带的 AI Gateway / APIM 路由，Foundry 不再自动注册。
3. **Google**（11-24）把 Agent Gateway 定义为承载 LLM/MCP/A2A 的 protocol-native 网关，授权输入直接是 Agent Registry 里的 Agent Identity，出站默认拒绝。
4. **身份侧**（11-25 14:00 CST）AWS 把 trusted identity propagation 扩到 IAM federation 与 Roles Anywhere，并明确 context 跨组织即被丢弃；IETF 同周四条草案在定义「授权上界」与「撤销如何沿派生树传播」。

一句话判断：**平台不再承诺「替你管住 agent」，而是把 agent 流量交给企业已经有的执法点，并要求客户自己保证「连得对」。**

---

## §0 主线专题：Agent 出网，先过企业的门

### 0.1 判断

上周的主线是时间维度——平台卖档期、检查点、档案，进度仍归应用。本周的主线换到空间维度：**谁允许 agent 出网、以谁的身份出去、在哪一层被拦下**。四家云厂给出的答案形状一致，但都不是发一个新产品，而是把 agent 协议（MCP/A2A/LLM 调用）塞进既有的 API 网关、WAF、策略引擎与身份目录。

这条转变对架构负责人的实际含义是：**「agent 网关」不再是一个可以单独招标的品类**。你要么已经有 APIM / WAF / IAM 并能写策略，要么就得先补这一层；平台只保证「能连出去」，不保证「连得对」。

### 0.2 四条一手证据与机制

**（1）AWS：发现靠 API Portal，执行靠 WAF 规则组（A）**

- 事实：11-23T18:47Z（= 11-24 02:47 CST）WAF 上线 LLM/MCP/A2A 端点的自动发现与保护，范围覆盖整个 AWS Organization，端点可位于 API Gateway、ALB、CloudFront 之后；可选接 Bedrock Guardrails 做内容检查。同日 API Gateway 上线 API Portal。API Portal 覆盖 32 个 Region；WAF AI Security 覆盖 7 个（N. Virginia、Ohio、Oregon、London、Stockholm、Tokyo、Sydney），额外计费。
- 机制：分两层。**发现层**在 API Gateway 控制面——读 AWS 侧流量日志与服务配置记录，产出 API/AI 端点清单，新发现的先标 `shadow API`，再由人决定是否纳管；不要求在 agent 或 MCP server 里装 SDK，也不要求把日志搬到第三方。**执行层**在 WAF 规则组——在请求路径上解析 MCP/A2A 消息结构做协议合规校验，畸形消息直接阻断；语义判断外包给 Guardrails 的 `InvokeGuardrailsCheck` 同步 API，检测 prompt injection、越狱、有害请求与响应中的敏感数据。
- 边界：只有经过 API Gateway / ALB / CloudFront 的流量在视野内；内容检查多一次跨服务调用（延迟与费用另计）。

**（2）Microsoft：出口策略在沙箱外求值，且成为发版门槛（A/B）**

- 事实：托管 agent 的 network egress controls 转 GA、Azure Policy 出口治理 preview（Canada Central、Spain Central、Korea Central 起步，11-25 00:42 CST 公告）；MCP 工具流量改由客户自带 AI Gateway / APIM 路由（11-25 00:50 CST）；A2A 直通（11-25 00:48 CST）；成本控制在请求运行时计数（11-25 00:43 CST）。
- 机制：出口策略是**附加到 agent 的有序规则表**（allow/deny host、加 header、转客户自有网关），在**沙箱外、请求到达目的地之前**执行；策略无法求值即拒绝。Audit 模式记录「本会拦但放行」的请求；切到 Enforce 后，**已在运行的会话保持启动时的策略**，必须发新 agent version 才生效。Azure Policy 则把「出站白名单」变成版本元数据：作者在创建 agent 版本前必须挂上合规 egress policy，未挂不许发版。
- 机制（MCP 侧）：Foundry 只保存一个 MCP endpoint 字符串，当 project connection 的 endpoint 与工具自身的 `server_url` 不一致时以 connection 为准——这解释了「配了网关但工具仍直连」的常见误判。治理动作（限流、IP 白名单、header 清洗、相关 ID、日志）全部由 APIM 既有策略引擎执行，Foundry 侧不再自动注册 MCP server、不再改写 endpoint；存量工具必须逐个手改。官方 how-to 明确写了这是行为变更（"Foundry no longer performs this registration"）。
- 边界：出口策略只管「去哪儿」，不管「带什么出去」；私有 CA 不覆盖平台自身的 Entra / managed identity 流量；hosted agent 的 network injection 必须在创建 Foundry account 时设置，事后不能补。

**（3）Google：网关的授权输入就是身份目录（B，厂商博客；A，IAM principal 文档）**

- 事实：11-24 安全博客把 Agent Gateway 定位为 protocol-native gateway，同一入口承载 LLM / MCP / A2A；对 Agent Registry 校验 Agent Identity，执行 IAM 策略与默认拒绝的出站规则，用 Model Armor 筛查请求；自定义检查经 Service Extensions 转给 IAP、客户自建策略引擎或第三方。
- 机制：入站校验的身份不在网关本地 ACL，而在 Agent Registry（cloud agent 获得独立身份、无共享或长期密钥，受 IAM 与 org/folder/project 配额约束）；授权求值走 IAM；出站默认拒绝，放行项由策略显式给出；语义筛查外包 Model Armor，深度定制外包 Service Extensions。IAM 侧 principal 形如 `principal://TRUST_DOMAIN/resources/...`，trust domain 分组织级与项目级。
- 边界：Agent Gateway 的价值取决于是否已用 Agent Registry；Workspace 侧另有硬约束——MCP server 拒绝非 agent 的 OAuth client，2027-02-01 起技术上强制 agent 只走 Workspace MCP server / CLI。

**（4）身份：传播有边界，撤销还在草案（A）**

- 事实：11-25 14:00 CST，AWS TIP 扩到 IAM federation（SAML/OIDC）与 IAM Roles Anywhere（X.509），覆盖全部商业 Region、GovCloud、European Sovereign Cloud；context key 族 `aws:OriginIdentity/{Subject,SubjectType,Issuer,IdentityProviderAccount,IdentityProviderOrgID,FederatedProviderArn}`，federation 另带 `aws:TransactionContext/IdentityProvider/*`。
- 机制：TIP 不是把用户 token 传下去，而是由 STS 在 `AssumeRole` 时给 role session 附加一组调用方不可修改的 context；role 决定「这个会话能做什么」，context 决定「这次请求是谁发起的」。**传播边界由 origin account + origin organization 决定**：同组织内续传，跨组织或独立账号在新角色会话创建时丢弃 context（切换本身仍可成功）。出站可用 `GetWebIdentityToken` 换成带 `origin_identity` / `transaction_context` claim 的 AWS 签名 JWT；TIP 不会自动把 context 送出境。context 本身不授予权限。
- 配套：IETF OAuth WG 窗内四条个人草案——intent token（11-25，把 RAR 上界包络 + 累计配额 + PoP 做成只给 AS/PDP 消费的 `intent+jwt`）、delegation revocation（11-19，用 SET 事件按 `(iss, jti)` 撤销整棵派生树）、DNS link（11-22，用 `_agent-oauth.<name>` TXT 把 agent 名绑到 OAuth client）、OAuth over AGTP（11-23，用每请求签名 + Agent-ID 取代 client_secret）。

### 0.3 四家的执行点对照

| 维度 | Microsoft Foundry | AWS | Google | 国内（阿里/火山/腾讯） |
|---|---|---|---|---|
| 发现层 | 平台内工具清单 + Toolbox | API Portal 读流量日志与服务配置，产出 shadow API | Agent Registry | 无对应公开能力 |
| 执行层 | 沙箱外出口规则表 + Azure Policy | WAF 规则组（协议合规）+ Guardrails API | Agent Gateway（IAM + Model Armor + Service Extensions） | 无对应公开能力 |
| 身份输入 | Entra Agent ID / agent user account / blueprint | IAM role session + TIP context | Agent Registry 的 Agent Identity | — |
| 默认姿态 | 出口默认拒绝、策略不可求值即拒绝 | 发现先标 shadow、保护需显式启用 | 出站默认拒绝 | — |
| 生效时点 | 发版前绑定策略；运行中会话保持旧策略 | 规则组更新即时生效 | 策略即时 | — |
| 可核验性 | 博客正文 A；Azure Updates 详情页 JS 外壳，仅标题/摘要 | 公告正文 A | 博客 B；IAM 文档 A | 月档/JS 外壳 |

### 0.4 责任切分：平台保证「能连」，客户保证「连得对」

| 事项 | 平台负责 | 客户负责 |
|---|---|---|
| 出站目的地 | 提供策略挂点、默认拒绝、审计模式 | 维护 host 规则表；升级时发新版本才生效 |
| MCP 路由 | 提供 endpoint 字段与凭证注入 | 在 APIM/AI Gateway 配 MCP route、改每个存量工具 endpoint |
| 身份 | 签发/校验 agent 身份、提供角色 scope | 决定 OBO 还是 service identity、维护角色边界 |
| 语义安全 | 提供 Guardrails / Model Armor 接口 | 判定哪些内容算敏感、是否接受额外延迟与费用 |
| 失败语义 | 拒绝不可求值的策略、记录审计 | 处理 400/403、保证工具端重试幂等 |

### 0.5 这一层挡不住什么（本周的反面证据）

- **语义层脱敏遗漏**：11-24 的 AWS 公告 2026-200（CVE-2026-135614）里，ECS MCP Server < 0.1.36 在敏感数据为默认值时，troubleshooting 工具未按预期脱敏就返回容器环境变量值与 secret 引用；能影响 agent 输入的一方（如 prompt injection）即可取得。WAF 能挡畸形消息，挡不住「格式合法但内容是秘密」。
- **内容被当指令**：11-25 的 2026-202（CVE-2026-136267），Kiro Web 把 agent 读到的内容里的 tool-call markup 当成命令执行；受影响模型包括 DeepSeek v3.2、GLM-5、MiniMax M2.1/M2.5、Qwen3-coder-next。
- **路径与边界检查可绕**：11-20 的 2026-195（CVE-2026-130901），document-loader-mcp-server 的 base dir 限制在特定环境变量组合下可被文档内容绕过。
- 结论：**边缘治理解决「流量形状」，不解决「工具进程的权限 ≥ 它读到的内容」**。MCP server 的版本必须像依赖库一样纳管。

### 0.6 与上期主线的关系

上期问「跑久了、断过一次之后，还算不算同一次作业」，答案是检查点与档案，且平台只保证续命。本期问「跑出去之后，算谁的身份、在哪被拦」，答案是既有网络与身份部件，且平台只保证能连。两期共同点是同一句：**托管不等于免运维，而是责任重新切分**；区别是上期切的是时间轴上的状态，本期切的是空间轴上的边界。

---

## §1 模块 1 · Harness / Agent OS

### 结论

1. Harness 的竞争主轴从「多 agent 编排」转到**长跑恢复与状态持久化**：OpenClaw 2026.11.10 把「Gateway 重启后子 agent 结果不丢、被中断的 turn 可续、后台 exec 进程跨重启存活」做成一整组语义；Claude Code 2.1.328–2.1.332 修 resume 丢工具调用/丢 compaction 摘要；OpenAI Agents SDK 1.0.0-alpha.2 把 `ResumableSession` + 待审批恢复写进 SDK。三家收敛到同一组语义：会话状态必须可序列化、可 CAS 写入、可在进程外恢复。
2. **托管与自托管控制面在收权**：Claude Code 2.1.330 接入 Enterprise Admin Console 组织级登录（登录后使用组织设置与其云厂商/网关）；2.1.328 给 self-hosted runner 加队列等待与放弃指标；OpenClaw 加 `operator.cron` 作用域与自动化所有权。
3. **技能/提示已成为供应链对象**：Claude Code 2.1.332 让 MCP server 提供 skills（beta，`server:skill`），并加 `PreSkillShellCommand` 钩子拦截 skill 的内联 shell；OpenClaw 把插件权限键 `allowPromptInjection` 改名为 `allowPromptModification`。权限模型从「工具级」下沉到「提示/技能级」。
4. **默认值迁移是本窗最被低估的破坏面**：Claude Code 2.1.328 让无权限模式的交互会话默认进 auto mode；2.1.332 把 Foundry 默认模型改为 Sonnet 5.5（`opus` 别名到 Opus 5.5，Bedrock 的 `sonnet` 仍为 4.5），Sonnet 4/Opus 4/4.1 在 Foundry 计为 retired；ADK 2.15.0 默认开 `DYNAMIC_INSTRUCTION_ROUTING`；OpenAI Agents SDK 0.25.0 把 compaction 默认模型改为 `gpt-6-luna`。这些都不打 breaking 标记，却改变生产行为。
5. 其余：LangGraph 只有补丁级（1.2.23/1.2.24）；Microsoft Agent Framework 无窗内发布且 GitHub 变更说明仍 404；Databricks 仍月档；Dify 窗内无版本。

### 状态表

| 对象 | 窗口内状态 | 版本 / 日期（CST） | 证据级 |
|---|---|---|---|
| OpenClaw | 有动态（3 正式版 + 1 beta） | 2026.11.10（11-25 16:59）、11.9（11-25 12:04）、11.8（11-25 04:50）、11.10-beta.3（11-24 11:28） | A |
| OpenAI Agents SDK (python) | 有动态（含破坏性 minor + 1.0 alpha） | 0.25.0（11-19 03:17）、1.0.0-alpha.1（11-21 04:51）、alpha.2（11-24 04:11）、0.26.0（11-24 11:22） | A |
| Anthropic Claude Code | 有动态（5 版） | 2.1.328（11-19 07:09）～2.1.332（11-25 06:06） | A |
| Anthropic Platform / Agent SDK | Platform 有动态；SDK 有版本无 changelog | Platform 11-20、11-23；SDK 0.2.185～0.2.189 | A / 机制未取得 |
| LangGraph / LangChain | 补丁级 | 1.2.23（11-19 13:33）、1.2.24（11-20 09:10） | A |
| Google ADK | 有动态（大版本） | 2.15.0（11-20 06:59）、2.15.1（11-25 09:01） | A |
| Microsoft Agent Framework | 无窗内发布；变更说明不可核 | PyPI 1.26.0（11-12）、NuGet 1.28.0（11-06）；GitHub 404 | A / 不可核 |
| Databricks Mosaic Agent | 无日级动态（月档） | 索引页 Last updated 2026-10-30 | A（核验） |
| CrewAI / Dify / pydantic-ai | CrewAI 功能级；Dify 无；pydantic-ai 安全修复 | CrewAI 1.15.45（11-24 11:54）；pydantic-ai 2.74.0（11-25 08:43） | A |

### 深拆 1：OpenClaw 2026.11.10——把「欠付的结果」写成可恢复台账（A）

- **做了什么**：2026.11.10 于 11-25 16:59 CST 发布（7,671 PR、633 直接提交、349 贡献者；npm tarball、integrity 与 release SHA `6ea542f` 均在正文）。11.9（10 PR）修 forked session 的 prompt cache、Tool Search 兼容、Claude CLI/ACP 回复投递、headed Chrome 截图与安全守卫；11.8（210 PR）是安装/更新/模型/自动化的可靠性补丁。2026.10.34 发布于 11-26 09:37 CST，**窗外**，只作背景。
- **怎么做到的**：子 agent 的「欠付结果」被持久化，跨 Gateway 重启保留；yielded 父会话在子任务完成或升级恢复后被唤醒；requester 中断后重试完成投递；`SIGKILL` 后诊断 wedged Gateway 并恢复会话；被中断的 turn 与已流式输出在重启/关机超时后保留。即把「谁欠谁一个结果」写成可恢复台账，而不是进程内的 future。后台 `exec` 在 Linux/macOS 上跨 Gateway 重启继续运行，输出写入 exit wake 指定文件。队列侧：待发 steer 可不停止当前 run 立即发送、队列消息可编辑、被拒发送退回 composer。cron 新增 `operator.cron` 作用域（含于 `operator.write`），调度器的 8 个运行槽不再被条件检查占用、3 个并发求值槽按到期时间排队，连续失败 10 次自动停用；owner 自动化从第一次失败即通知 owner 会话。更新侧：状态升级在启动时把数据库复制到私有 shadow，迁移校验完整性/行数后原子换入，保留上一代为回退，更新被 kill/Doctor 中断/机器重启后可恢复。
- **意味着什么**：OpenClaw 把差异化押在故障语义上——重启不是重置、中断不是丢失。对自托管团队，Gateway 可以当常驻服务；对企业，`operator.cron` 把自动化权限从管理员独占下放但保留 owner 归属。迁移注意两点：插件权限键改名（Doctor 自动迁移），更新日程默认 Hourly 会改变生产升级节奏。

### 深拆 2：Claude Code 2.1.328–2.1.332——恢复、组织登录与技能供应链（A）

- **做了什么**：五版均在窗内（npm 时间戳判定，CHANGELOG 本身不带日期）。2.1.328 修 resume 后 Code Mode 丢已加载 skill/hook 上下文与审批 note、cloud session 迟到保存丢 compaction 摘要、remote runner 丢失丢 turn 工具调用；新增 `CLAUDE_CODE_DISABLE_DEFERRED_TOOL_RESUME`。2.1.330 接入 Enterprise Admin Console 组织级登录，`/loop` 与周期任务最长运行从 7 天延到 30 天。2.1.331 让 Code Mode 支持 Bedrock/Agent Platform/Foundry/Claude Platform on AWS 的终端会话，gateway 加 `oidc.groups_jsonpath`，宣布 2026-11-30 起托管 `extraKnownMarketplaces` 默认自动更新（需 `"autoUpdate": false` 退出）。2.1.332 让 MCP server 提供 skills（beta），加 `PreSkillShellCommand` 钩子，Foundry 默认模型改 Sonnet 5.5。
- **怎么做到的**：Admin Console 组织登录后，Claude Code 拉取组织 settings 并选择组织指定的云厂商/网关，把「个人 OAuth + 本地 settings」升级为「组织身份 → 策略 → 模型路由」三段式；self-hosted runner 补 queue-wait/abandon 与 order→registered、order→first-session 四类指标，使自托管编排可观测。MCP skills 把「工具」与「可复用指令包」合并到同一 MCP 连接，`server:skill` 命名空间避免与本地 skill 冲突；`PreSkillShellCommand` 在 skill 加载时拦截内联 shell。
- **意味着什么**：对平台团队，组织登录 + Foundry 默认模型迁移是采购与部署路径变化（默认模型、区域变量 `VERTEX_REGION_CLAUDE_5_5_SONNET`、retired 清单都会影响既有 pin）。对安全团队，MCP server 从「工具提供方」变成「可执行指令提供方」，allowlist 需要重评。

### 深拆 3：OpenAI Agents SDK 1.0 alpha——把「审批中暂停→恢复」做进 SDK（A）

- **做了什么**：1.0.0-alpha.2（11-24 04:11 CST）引入 `ResumableSession`，持久化历史与待审批状态，支持原子条件写存储或 `RedisSessionStore`；`RunConfig.tool_execution` 提供 `prepare_tool_input/output/declaration` 与 `sdk_only_tool_hooks`；`RunConfig.redact_text` 与 tracing 的 `operation_detail: metadata|content`。alpha.1 内嵌 Codex Core `rust-v0.166.0`（PyO3），仅 GitHub Releases 提供 4 平台 wheel；读 schema 1.22、写 1.24，**alpha.1 无法读新快照**。0.25.0（11-19 03:17）是破坏性：移除 beta 的 Runloop sandbox provider、改 Pydantic run-context checkpointing、compaction 默认模型改 `gpt-6-luna`。
- **怎么做到的**：`ResumableSession` 用条件写（compare-and-swap）保证多 worker 下 checkpoint 不互相覆盖，恢复时重建模型配置；工具钩子分输入/输出/声明三段，在工具契约层拦截；redaction 与 tracing 粒度可选，解决「可观测 vs 敏感数据」冲突。
- **意味着什么**：schema 不兼容是硬迁移门槛；选 1.0 alpha 等于接受 GitHub-only wheel 分发（不在 PyPI），供应链需自建镜像；0.25.0 移除 Runloop provider 是「SDK 收敛到自家 runtime」的信号，用 Runloop 的工作负载必须迁出。

### 模块洞察

- **评估 Harness 时新增一列「重启后还剩什么」**：三家的实现路径不同（台账、CAS session、resume 修复），但都把「会话可序列化、可恢复」当成契约。它应当与上下文窗口、工具数并列进选型表。
- **默认值比版本号更能改变行为**：本窗至少四处默认变化（auto mode、Foundry 默认模型、ADK 动态路由、compaction 模型）。CI 应断言「解析后的有效默认值」，而不是只 pin 版本。
- **技能是新的权限面**：`server:skill`、`PreSkillShellCommand`、`allowPromptModification` 说明「一段可执行的自然语言」已被当作供应链对象；下一步可预期 skill 签名与来源证明。

---

## §2 模块 2 · Runtime / Session / State

### 结论

1. 运行时的竞争点从「能不能长跑」转到**密度 + 恢复语义**。Foundry 把会话改为共享委派子网 IP，规划口径从「每会话一个 IP、/24 约 250 并发」变为「/24 约 60,000 会话」，隔离仍靠每会话 microVM；但恢复被明确定义为**重跑 handler（reentry）**，不是确定性重放。
2. **AWS 本周唯一可给到日级的 AgentCore runtime 事件是 GovCloud Instances GA**（11-24 01:21 CST）：agent 跑在客户账号内的 EC2 上，平台管置备/更新/扩缩/生命周期，会话最长 14 天，计费 = EC2 + 管理费。AgentCore 发布说明页按月分组、无日级日期，11 月的 nested virtualization、G7 GPU、S3 挂载、`GET /ping` 等只能记「11 月月级」。
3. **Google 连续第二周静默**，且入口已迁移：旧 Vertex AI release notes 页首声明不再更新、2026 年条目止于 5-26；活入口是 Gemini Enterprise Agent Platform release notes，最新条目 11-17。
4. **国内云是「文档更新在窗内、公告分区没动」**：火山 Managed Agents 的 `manage-session` 页更新于 11-19 15:48、CUA 页 11-24 22:39，但公告分区仍停在 202610；阿里本模块窗内仅 11-24 知识库条目；腾讯只有 11-25 09:50 的 ADP 计费公告。Coze 公开面仍未取得。
5. Lambda durable functions 编排 MicroVM 的公告 pubDate 为 11-26 04:00 CST，**窗外 4 小时，只作背景**。

### 状态表

| 对象 | 窗口内状态 | 版本/日期（CST） | 证据级 |
|---|---|---|---|
| AWS AgentCore Runtime | 有动态（1 条日级 + 多条月级） | Instances GA in GovCloud：11-24 01:21；其余 11 月月级 | A / B |
| AWS Lambda durable functions | 窗外（背景） | 11-26 04:00 | A（时间戳） |
| Google Agent Runtime（GEAP） | 无动态 | 最新条目 11-17 | A |
| Microsoft Foundry Hosted Agents | 有动态（Ignite 稿入窗 + 运维深文） | 11-19 01:00；11-22 02:12；11-25 00:00 | A |
| OpenClaw sessions/cron/Gateway | 有动态（4 个版本） | 11-24 ~ 11-25 | A |
| 阿里云百炼 / Model Studio | 无本模块动态 | 窗内仅 11-24 知识库条目 | A |
| 火山方舟 Managed Agents | 有动态（文档更新） | 11-19 15:48；公告仍 202610 | A（文档）/ B（归因） |
| 火山方舟 CUA | 有动态（文档更新） | 11-24 22:39 | A（文档） |
| Coze | 本次未取得 | 3 入口均为 JS 壳/400 | — |
| 腾讯云 ADP | 无本模块动态 | 11-25 09:50 计费公告 | A |
| E2B / Modal / Daytona | 无窗内版本 | E2B 2.64.0（11-13）、Modal 11-14、Daytona 不可读 | A / 未取得 |

### 深拆 1：Foundry Hosted Agents——恢复是「租约重入」，不是重放（A）

- **做了什么**：Ignite 稿发布于 11-18T17:00:54Z = 11-19 01:00 CST，落在本期窗口内（上期只能作背景，本期转为正式条目）。给出四项 runtime 状态：long-running resilient execution GA、idle timeout 可配 GA、memory snapshots public preview、BYO-AKS limited preview（公开预览目标 12 月初）。但 11-25 00:00 的 Ignite 复盘文写「Resilient execution（GA since October）」——**能力 GA 在 10 月，11-19 是再披露**，按纪律属「本周新披露的历史事项」。
- **怎么做到的**：双身份 + 租约 + 重入。work identity 代表逻辑作业、input identity 代表该作业中的一轮输入；handler 启动前运行时先持久化输入并对 work record 取 lease，运行期续租；进程消失后租约被放弃，后续进程以**相同的两个身份与相同输入**重新进入 handler。恢复从 handler 开头重跑，不恢复局部变量与调用栈，handler 必须用 checkpoint/watermark 自己判断哪些已完成。流式侧每个请求/轮次用独立 stream identity，事件带 cursor，恢复后以新的 `response.in_progress` 作为快照重置点，客户端要丢弃不在快照内的输出。steering 允许新轮次排队并通知当前 handler 提前收尾，保证同一会话不出现两个并发 handler。
- **意味着什么**：判断标准不是「支不支持长跑」，而是「handler 从开头重跑一次会不会发两封邮件」。可写进 SLO 的数字：idle timeout 2 分钟–4 小时/版本、默认 15 分钟；非活跃会话 30 天后删除。BYO-AKS 则是「控制面用 Foundry、数据面留在自己集群」的路径（每会话一 pod + pod sandboxing）。

### 深拆 2：Foundry 共享子网 IP——密度提升 240 倍，配额才是真上限（B，厂商自述估算）

- **做了什么**：会话改为共享委派子网 IP；/24 ≈ 60,000 并发会话、最小 /27 ≈ 7,500；此前每会话独占 IP，/24 约 250。默认配额 1,000–2,000 会话/订阅/区域，提升需开工单。
- **怎么做到的**：agent 子网委派给 `Microsoft.App/environments`（Container Apps 环境），子网内容纳每会话 microVM + 每项目一个单租户 data proxy；工具调用经 proxy 出网，到 Cosmos DB / Storage / Key Vault 走 private endpoint，平台用子网托管身份向 Entra ID 认证。共享 IP 后靠端口/代理复用，隔离仍由 VM 边界承担。
- **意味着什么**：子网规划从「按 IP 数」改为「按配额 + /27 下限」；network injection 必须在创建 Foundry 账号时配置，事后不能补；私有端点地址不要落在 `192.168.0.0/24`（与内部沙箱网段冲突）；删除账号是软删除，子网被占到 `purge` 为止。

### 深拆 3：Foundry memory snapshots——版本基线，不是会话检查点（A，preview）

- **做了什么**：按 agent version 打开 `enable_memory_snapshot`（缺省 false；azd 需 `azure.ai.agents` 扩展 `1.0.0-beta.23` 与 `AZD_ALPHA_ENABLE_AGENTS_MEMORY_SNAPSHOT=true`）。
- **怎么做到的**：四阶段——初始化（起临时实例、等 readiness）→ 捕获（跑 `before_snapshot` 钩子后捕获已初始化进程）→ 会话启动（从该版本基线恢复隔离沙箱）→ 恢复初始化（SDK 注入会话级环境变量覆盖，再跑 `after_restore` 钩子，成功后才转发请求）。端点固定 `POST /_before_snapshot`、`POST /_after_restore`，默认端口 8088，`/readiness` 未过不监听；捕获失败让该版本直接 failed，不静默退回冷启动。
- **意味着什么**：**开启快照的会话在 idle 挂起/恢复后不保留 `$HOME`、其他本地文件与进程内存**，与普通托管会话的持久文件系统行为不同。它优化「冷启动里可复用的初始化」，代价是放弃会话现场。文档列的「不能在启动时生成的值」清单（请求 ID、调用者身份、当前时间、计时基线、凭证、实例 ID、连接池、加密随机状态）可直接复用于任何 fork/快照类方案。

### 深拆 4：火山方舟 Managed Agents——本周国内云机制最完整的一份会话说明（A，事件日不可得）

- **做了什么**：`manage-session` 页更新于 2026-11-19 15:48:54（窗内），`agent-plan-personal-cua` 页 11-24 22:39:36；产品动态页标「最近更新时间 2026.11.19」，但最新公告分区仍是 202610、无 202611。
- **怎么做到的**：Session 是显式状态机，7 态 `idle/running/terminated/rescheduling/initializing/failed/upgrading`；收到 `user.message`/`user.tool_confirmation` 转 `running`，`end_turn` 或等待输入回 `idle`，暂时性错误转 `rescheduling` 由平台自动恢复（状态值 `rescheduling`，SSE 事件名 `session.status_rescheduled`）。**连续 idle 14 天转 `terminated`**；期间可恢复文件系统、已装软件包与沙箱临时文件；续期必须在到期前发一条 content 非空的 `user.message`（空数组不刷新）。归档 `POST /sessions/{id}/archive` 要求 idle 且无 queued/running 工具任务，幂等，归档后转 terminated、`archived_at` 记首次进入时间。事件历史默认保留 6 个月。升级 Agent/Environment 必须走升级接口并保持原 `session_id`。
- **意味着什么**：可以引用语义（14 天 idle、6 个月事件、归档幂等、升级不换 ID），**不能写「本周上线」**。这也是本期对国内云唯一不越界的判断方式。

### 深拆 5：火山 CUA / AWS WorkSpaces——「给 agent 一台机器」的三种计费（A）

- **做了什么**：火山 CUA 是用户专属 Windows 云桌面，本地发起、远端执行，私有临时 URL 约 30 分钟有效；需 Agent Plan Medium 及以上 + 实名 + 控制台 Harness 区开启 CUA 抵扣；任务状态 `in_progress/needs_input/completed/failed/cancelled`；浏览器自动化、视觉/桌面自动化（截图、鼠键、Windows UI Automation）、终端与文件、长程任务、虚拟外设。约束：同一桌面同一时间只能跑一个活动任务；关闭后机器只保留 7 天，超期销毁后重开是全新机器；标价 312.5 AFP/CU/小时，活动期 2 折至 62.5。
- **怎么做到的**：按小时抵扣积分，机器生命周期与套餐解耦（积分耗尽默认关闭入口但机器保留 7 天）。与 AWS WorkSpaces for AI agents（MCP 接口提供点击/输入/看屏，跑在有监控审计的桌面上）、Microsoft Browser Automation（Playwright Workspaces + take control）同类：**给 agent 一台有界面的机器，而不是 headless 浏览器**。
- **意味着什么**：采购要问「机器关掉后还能不能回来」——火山明确不能，AWS 取决于 EC2/卷生命周期，Microsoft 取决于 Playwright Workspaces 会话。

### 模块洞察

- **同一个「session」，三种恢复保证，不能混写**：Foundry 是租约 + 重入（进程死了从头再跑一遍）；火山是状态机 + 空闲快照（idle 14 天内可回文件系统，running 不保证）；阿里是磁盘单点快照（只存工作目录与环境修改，不存进程）。共同点是「进程内存一律不保」，差异在「谁能回来、回来的是哪一刻」。
- **密度、隔离、可恢复只能选两个**：Foundry 用共享 IP 换密度、隔离靠 microVM；AWS Instances 用客户账号 EC2 + 14 天会话换隔离与合规、密度交给客户买；火山 CUA 用一人一桌面 + 单活动任务换确定性、代价是 7 天销毁。
- **国内云的「文档更新日」不能当「事件日」**：火山三个页脚时间都在窗内，但公告分区停在 202610。机制可引用，发布不可断言。
- **「什么算一次会话」正在变成计费口径**：Anthropic 11-20 把 session 定义为「某 UTC 日内首次成功跑 Bash/建文件/改文件」，火山用 `active_seconds` + token + 服务端工具次数计量。session 从技术对象变成计费对象后，容量与席位模型要按新定义重建，切换点前后的历史序列不可直接同比。
---

## §3 模块 3 · Sandbox / Computer Use / Browser

### 结论

1. 浏览器 agent 的成本控制点从 token 移到**每次运行的固定开销**：browser-use 1.0.8 把 judge 改成「run 的额外一轮」以命中 provider 缓存，并把 gateway 额度预占从 32,768 降到 16,384 输出 token；1.0.7 用「50 秒先返回已有输出、再用空代码续取」绕开 MCP 客户端 60 秒硬超时。
2. **本地浏览器的隔离边界被显式收紧**：agent-browser 0.44.0 给 stream server 的 `/api` 加同源 + loopback Host 校验、WebSocket 升级要求 `Origin` 匹配 `Host`，并把「allowlist 为空」从「关闭管控」改成报错（fail-closed）。
3. **云厂浏览器侧本周真正落地的是 Foundry Browser Automation**：GA 底座是 Azure Playwright Workspaces，action batching / Live View / take control / 会话录制为 GA，VNet 注入、客户代理、Key Vault 密钥、Web Bot Auth 为 preview。它把浏览器搬出 agent 沙箱，使网络边界、凭证边界与人的边界可以各自独立配置。
4. Stagehand 稳定版连续第二期落在窗外（4.5.0 于 11-26 02:49 CST，超窗约 2 小时 50 分）；agent-browser 0.45.0 于 11-26 04:44 CST 窗外。**周报里的「最新稳定版」系统性晚一到两个版本**。
5. E2B / Modal / Daytona 三家托管执行时本周均无窗内版本。

### 状态表

| 对象 | 窗口内状态 | 版本/日期（CST） | 证据级 |
|---|---|---|---|
| E2B | 无动态 | 2.64.0（11-13） | A |
| Browserbase | 有动态 | Browser Sizes（11-23） | A |
| Stagehand | 稳定版窗外，窗内仅 dev 预发布 | 4.5.0 于 11-26 02:49 | A |
| Modal | 无动态 | changelog 最新 11-14 | A |
| browser-use | 有动态（2 版） | 1.0.7（11-21 04:01）、1.0.8（11-22 11:30） | A |
| agent-browser | 有动态 | 0.44.0（11-24 06:44） | A |
| OpenAI Computer Use | 无窗内变更 | changelog 最新 11-24（模型/语音） | A |
| Anthropic Computer Use | 有动态（计量口径） | 11-20 会话计数规则 | A |
| AWS AgentCore Browser / Code Interpreter | 无窗内条目 | 11 月发布说明零条 | A |
| Microsoft Browser Automation | 有动态 | GA（11-19 01:00 披露）+ 4 项 preview | A |
| Google Cloud Run / GKE agent sandbox | 无窗内变化 | Agent Sandbox on GKE GA 于 11-12（背景） | A |
| Daytona | 本次未取得 | 站点 JS 壳；GitHub releases 停 2026-06-25 | — |

### 深拆 1：browser-use——把「一次运行」的固定成本逐项拆掉（A）

- **做了什么**：1.0.7（11-21 04:01）`browser_exec` 的 MCP 调用在 50 秒时先返回「到目前为止的输出」，单元格继续跑，客户端再用空代码调用取剩余结果（#6477）。1.0.8（11-22 11:30）judge 作为 run 的又一轮发起、provider 从缓存读整段 run（#6457）；headless/SSH 环境用「打印链接 + 验证码、在任意设备批准」登录（#6427）；DeepSeek/Qwen thinking 模式下步数上限强制收尾被拒时不再强制追问（#6453）；`bu.type` 永不回显密码（#6455）；`Browser(cdp_url=...)` 附着已打开页面（#6456）；预占额度 32,768→16,384（#6461）。
- **怎么做到的**：分片返回把「一次 MCP 请求 = 一次完整执行」改成「请求返回窗口内快照、执行与请求解耦」，代价是调用方要实现空代码续取循环；judge 复用缓存省的是输入侧重复计费（前缀与 run 完全一致，命中 prompt cache），不是模型算力；预占减半是「按真实输出分布调闸」，防小额账户中途被拒。
- **意味着什么**：评估 browser-use 要问三件事：MCP 客户端超时多少秒、judge 是否双计费、账户余额下限是否够一次预占。预算单位应从「每 token」换成「每完成一次任务」。

### 深拆 2：agent-browser 0.44.0——把不确定变成明确失败（A）

- **做了什么**：新增 Ladybird provider（`-p ladybird`，WebDriver，默认 headless）；后台标签三态 `tab keep live|throttled|frozen`（命令前自动解冻）；`click`/`dblclick` 支持右键、中键与修饰键；WebMCP 公告按 `[origin] name [frame]: description` 列出页面工具并支持 `webmcp invoke`。
- **怎么做到的**：行为变更以收紧为主——被替换 document 上的 refs 在整页加载或 iframe 导航后直接报 "no longer loaded"，不再作用到错误元素；`fill/type/check/uncheck/select` 先校验目标，失败返回稳定 code（`not_editable`、`read_only`、`disabled`、`not_checkable`、`option_not_found`、`ambiguous`、`not_multiple`、`malformed_value`）且不改字段；`snapshot -s <sel>` 覆盖所有匹配而非第一个；stream server 的 `/api` 要求同源 + loopback Host，拒绝时不带 CORS 头；`AGENT_BROWSER_ALLOWED_DOMAINS` 为空直接报错。
- **意味着什么**：这是「升级即可能报错」的版本。依赖「refs 失效后仍能点」或「空 allowlist = 不限制」的脚本会失败；这是好事，但 CI 要预留错误码分支。

### 深拆 3：Foundry Browser Automation——把浏览器搬出沙箱（A）

- **做了什么**：11-19 01:00 CST 的 Ignite 稿：Browser Automation Tool GA，跑在 Azure Playwright Workspaces 上。GA：`run-code` 的 action batching（一段 Playwright 脚本替代多次 snapshot/click/type，因可执行任意代码而保持 opt-in）、Live View、take control、会话录制（opt-in，写入客户存储账号，用存储 RBAC 控权）、trace。Preview：VNet 注入（客户 VNet + 专用委派子网）、客户代理（代理池、按域路由、优先级、凭证放 Key Vault，API `2026-11-01-preview`）、Key Vault 密钥（远端 MCP server 服务端读取，代码与模型都看不到）、Web Bot Auth（IETF 草案的请求签名，与 Akamai/Cloudflare/F5 做平台注册，明确**不绕过 CAPTCHA**，API `2026-11-10-preview`）。
- **怎么做到的**：关键在「执行在哪」——浏览器不在 agent 沙箱里，而在 Playwright Workspaces 的托管浏览器会话里，agent 通过工具调用驱动；因此网络边界（VNet/代理）、凭证边界（Key Vault 服务端读取）、人的边界（take control）可以各自独立配置，不需要把凭据塞进 agent 容器。
- **意味着什么**：企业采购的三个硬条件第一次凑齐：内网可达、出网可审计、凭证不入模型。代价是 preview 项都带 `2026-1x-01-preview` API 版本，接口会变；profile reuse 的标注矛盾（标题写 coming soon、正文写 now in preview），不能写进方案。

### 深拆 4：Browserbase Browser Sizes——只加 CPU，不加内存（A）

- **做了什么**：11-23 上线，创建会话时设 `browserSettings.size` 为 `regular`（默认）/`large`/`xlarge`；会话对象回传实际 size。
- **怎么做到的**：官方描述克制：更大规格「增加 CPU，内存保持不变，并发上限不变」——纯 CPU 档位，针对多标签、复杂 Web 应用这类渲染/脚本密集负载；计费与并发配额不随 size 改变（是否另行计价未披露，不能主张加价）。
- **意味着什么**：这是「同一并发额度内提升单会话吞吐」的开关；内存瓶颈型任务（大 PDF、视频解码）买 size 无用。

### 模块洞察

- **「每任务固定开销」成为浏览器 agent 的一等指标**：judge、超时重试、预占额度、会话启动四项应单列预算，而不是折进 token 单价。
- **隔离边界与网络边界正在分离，且各自有了默认拒绝**：本地 daemon 靠进程边界（同源、loopback、allowlist 非空），云托管靠网络边界（VNet、代理、Key Vault）。两边解决同一件事：agent 能看到什么、能去哪、凭证在哪。
- **发版节奏与周报窗口存在系统性错位**：Stagehand 连续两期稳定版在窗口结束后 2–3 小时发布，agent-browser 0.45.0 也在 11-26 04:44。涉及破坏性变更时应直接看 release。

---

## §4 模块 4 · Tool Gateway / Protocol

### 结论

1. **网关的形态从「独立产品」变成「云厂既有网络/安全部件的一个策略点」**：AWS 用 WAF 识别并拦截 MCP/A2A 流量、发现层交给 API Portal；Azure 把 Foundry 的 MCP 工具流量改成客户自带 AI Gateway / APIM 路由，且不再自动注册；Google 把 Agent Gateway 定义为 protocol-native 网关、授权输入是 Agent Registry 身份；三家都不是新发一个 agent 网关。
2. **同一模式解释了「谁承担治理责任」**：Foundry 停止自动注册 MCP server、存量工具需逐个手改 endpoint；Azure Policy 在创建 agent 版本前强制绑定 egress policy。平台保证「能连」，客户保证「连得对」。
3. **协议侧本周没有新规范修订**：MCP 只有 11-24 两周年博客（路线：token 绑定请求方 client、cloud agent 用自己的身份、files 扩展原型、下一版 2027-03）；SEP 索引无新增（45 Final / 1 Accepted）；A2A 无发版，v1.1.0-rc 仍停 10-29，窗内 5 个提交全是 docs。
4. **MCP Registry 是本周唯一连续发版的对象（7 个版本，11-20→11-23）**，主题是注册表自身的供应链门禁：发布时与每日 OSV 恶意包检查、按需 malware sweep、多 proof 验签、publisher 私钥改为文件/环境变量注入、撤销版本保留 moderator hold。
5. Azure 的 A2A「passthrough」有明确机制也有明确收窄：托管 agent 侧只支持 v1.0、单轮 `SendMessage`、不支持 `GetTask`，所谓直通是无状态转发，不是完整 A2A 任务模型。

### 状态表

| 对象 | 窗口内状态 | 版本/日期（CST） | 证据级 |
|---|---|---|---|
| MCP 规范 / SEP | 无新修订、无新 SEP | 博客 11-24；最近 SEP 创建 2026-10-05 | A |
| MCP Registry | 有动态（7 版） | v1.8.10（11-20 17:35）→ v1.8.16（11-23 21:54） | A |
| MCP TS / Python SDK | 无发版 | TS 最近 1.32.2/2.4.0（10-23）；Python v2.3.0（10-02） | A |
| A2A | 无发版，仅 docs 提交 | v1.1.0-rc 仍 2026-10-29 | A |
| Composio | 有动态 | CLI 0.6.4（11-25） | A |
| Arcade | 无窗内发版 | PyPI 1.17.8（11-13） | A |
| Nango | 有 managed 发版，内容不可读 | managed-1.7.4（11-25 16:09） | A / 机制未取得 |
| Pipedream Connect | 无公开记录 | changelog 最新 2025-10-01 | A（静默事实） |
| Azure Foundry MCP 网关 | 有动态（preview） | 11-25 00:50 | A 标题 / B 机制 |
| Azure A2A passthrough | 有动态（preview） | 11-25 00:48 | A |
| AWS WAF / API Portal | 有动态（GA） | 11-24 02:47 | A |
| AWS AgentCore Gateway | 无窗内公告，能力面在月级文档 | 11 月月级 | A（条目）/ 日期未定 |
| Google Agent Gateway | 有动态（博客） | 11-24 | B |

### 深拆 1：AWS WAF AI Security + API Portal（本周最强机制条目，A）

- **做了什么**：见 §0.2(1)。补充：AI Security 托管规则组可与其他 AWS Managed Rules 或自定义规则叠加；Guardrails 内容检查单独计费。
- **怎么做到的**：见 §0.2(1)。一句话：**发现层在 API Gateway 控制面，执行层在 WAF 规则组，语义层外包 Guardrails 同步 API**；不要求在 agent 或 MCP server 里装 SDK。
- **意味着什么**：「MCP server 有没有被 WAF 覆盖」变成可查询的资产属性，shadow MCP 成为安全评审常规项；对 MCP/A2A 实现者，协议畸形消息从「服务端自己报错」上移为「边缘直接阻断」，互操作测试要覆盖边缘行为；安全预算从「agent 平台」转到「WAF + Guardrails」两个既有计费项。

### 深拆 2：Azure BYO MCP 网关——治理责任转移（A）

- **做了什么**：Foundry 可把 MCP 工具流量送到组织已有的 AI Gateway 或 Azure API Management；顺序被写死：先在网关里配 MCP route，再把 gateway-routed endpoint 填进 Foundry。文档明确这是行为变更：此前 Foundry 会自动注册 MCP server 并路由，现在不再注册、不再更新 endpoint，存量工具必须逐个手改。认证支持 managed identity、key-based、custom OAuth identity passthrough、unauthenticated；策略在网关侧配（AI Gateway portal 或 APIM policy XML），Foundry 内不编辑策略。
- **怎么做到的**：Foundry 只保存一个 endpoint 字符串；当 project connection 的 endpoint 与 `server_url` 不一致时采用 connection endpoint——所以「配了网关但工具仍直连」是因为工具没改 endpoint。治理能力（按 IP 的 rate-limit 60 次/60 秒、IP 白名单、注入 `X-Correlation-Id`、删除 `Cookie`/`Referer`、按 header 路由）全部由 APIM 既有策略引擎执行。与之并存的是 Foundry 自带 Toolbox：把 web search、file search、code interpreter、MCP server、自定义函数收敛成**一个受管 MCP 兼容端点**，集中凭证注入与刷新，并提供 `tool_search` / `call_tool` 两个元工具避免把上百个工具定义塞进上下文。
- **意味着什么**：网关不是 Foundry 的功能，而是客户的 APIM 资产。好处是沿用既有 API 治理、网络与计费；代价是迁移成本显性化（每个存量 MCP 工具改 endpoint、平台不回填），以及「配了网关 ≠ 被治理」这一常见误判。

### 深拆 3：Azure A2A passthrough——直通但收窄（A）

- **做了什么**：Foundry 为 agent 发布 agent card 并接受入站 A2A：v1.0 卡在 `…/endpoint/protocols/a2a/agentCard/v1.0`，v0.3 卡在 `…/agentCard/v0.3`；版本协商三种方式（卡内 `protocolVersion`、`A2A-Version` 头、`?a2a-version=1.0`），头与查询串不一致返回 400 `version-ambiguous`；**不指定版本时默认 v0.3（preview）**。A2A v1.0 GA 且仅 JSONRPC、仅文本、不支持 SSE；任务与上下文保留 60 天，每次写入重置。认证只接受 Entra ID，调用方需 Foundry Agent Consumer 角色（可授到 project 或单个 agent），支持 OBO 或 service identity。
- **怎么做到的**：入站由 Foundry 扮演 A2A server，终结请求、按 agent card 路由到 responses 端点，身份校验与授权在平台侧完成。但 hosted agent 的端点只支持 v1.0，每请求必须是单轮 `SendMessage`——不得设 `contextId`/`taskId`、不得 `returnImmediately=true`、`GetTask` 不支持，违反返回 `HOSTED_AGENT_NOT_SUPPORTED`；平台把 A2A 调用转成一次无状态请求交给容器，不代为保存任务/上下文。
- **意味着什么**：跨组织 agent 调用在 Azure 上收敛为「Entra 身份 + 角色范围」，A2A 的开放发现被有意限制（匿名读 agent card 不支持）。架构上要先设计角色边界（project 级 vs agent 级）；不要把 passthrough 当完整 A2A 任务模型。

### 深拆 4：MCP Registry——注册表把自己变成供应链门禁（A）

- **做了什么**：v1.8.10（11-20 17:35）改进稀疏窗口与深分页查询计划、运维要求两个替换索引并发构建验证后上线、含 HTTP 认证重试 / 多 proof 验签修复 / publisher 私钥支持文件与环境变量；v1.8.12（11-22 16:43）启用 usage collector、**发布时与每日执行 OSV 恶意包检查**；v1.8.13/14 启用 malware sweep 与按需 staging sweep、每次 sweep 出报告；v1.8.16（11-23 21:54）减少编辑期数据库工作量、跳过纯文档 staging 部署、分阶段隔离 usage-collector 与 backup 身份、**撤销的 server 版本保留 moderator hold**。
- **怎么做到的**：publish 路径同步查 OSV，另有一条每日全量/按需 sweep 旁路，两者共用同一套 findings 与告警通道（漏扫可由日扫兜底）；身份侧把「采集用量」与「备份」拆成不同 principal，缩小单点凭证权限面；moderator hold 保证撤销动作不因版本下架丢失审查状态。
- **意味着什么**：MCP server 的分发开始有「包管理器级」准入（类似 npm/PyPI 的恶意包扫描），企业可把 registry 扫描结果当供应链证据；多 proof 与私钥注入方式变化意味着签名发布的运维方式要改。

### 深拆 5：MCP 两周年博客的路线信号（B）

- **做了什么**：2,500+ 独立贡献者；SDK 累计 5B 下载（其中 4.5B 在过去一年），近 30 天超 700M；时间线 2026-07 无状态协议、2026-10 Skills beta、2026-11 Events beta。明确在做的三件事：把 access token 绑定到发起请求的 client、让 cloud agent 用自己的身份认证、files 上传/下载扩展仍在工作组原型；Enterprise-Managed Authorization 已 stable；下一次规范发布 2027-03。
- **怎么做到的**：token 绑定 client 直指「token 被转发到别的 client 后仍可用」的老问题；cloud agent 用自己的身份与本周 AWS/Azure 的 workload identity 路线同向。
- **意味着什么**：采购问法从「支持哪个 MCP 版本」转为「支持哪些扩展 revision + client 绑定策略」。

### 模块洞察

- **「网关即网络部件」的三个判定条件本周都出现**：发现靠既有流量面（API Portal 读日志与配置）、执行靠既有规则引擎（WAF managed rule group、APIM policy、Google Service Extensions）、身份靠既有目录（Entra / IAM / Agent Registry）。新产品的空间被压到「协议解析」这一层——谁能正确解析 MCP/A2A 消息并给出稳定错误语义，谁拿到定价权。
- **治理责任从平台回推给客户**：停止自动注册、发版前强制策略。平台保证「能连」，客户保证「连得对」。
- **协议标准让位于采用方**：MCP 无修订、A2A 无发版，但 Azure 已把 A2A v1.0 做成 GA 入站端点、AWS 已在 WAF 层校验 A2A 消息合规。互操作问题会先以「边缘 400 / 阻断」的形式暴露。
- **注册表在补供应链这一课**：OSV 发布时检查 + 每日 sweep + 多 proof + 私钥注入方式，目标是让「这个 MCP server 是谁发的、有没有被篡改、有没有恶意包」可被机器验证。

---

## §5 模块 5 · Identity / Auth / Permission

### 结论

1. **本周身份层的主线是「把身份传播画在管理边界上」**：AWS TIP 扩到 federation 与 Roles Anywhere，并明确 context 只在同一 Organization 或同一独立账号内传播；Google 用 Agent Registry 的 Agent Identity 做网关授权；Azure 用 Azure Policy 在发版前绑定 egress。三家都把「agent 能去哪、以谁的身份去」收敛到组织/项目/租户这一级。
2. **TIP 的机制不是传 token，而是给 role session 附加不可篡改的 context key**；context 不授予权限，只供 IAM policy condition 与 CloudTrail 使用；出站可换签名 JWT。
3. **IETF OAuth WG 窗内四条草案**从「怎么发凭证」转向「怎么表达委托的边界与撤销」：intent token（授权上界）、delegation revocation（撤销沿派生树）、DNS link（跨组织归属锚）、OAuth over AGTP（传输层自带身份时的映射）。均为个人草案，不能写成产品能力。
4. **云厂身份产品本周没有新版本**：AgentCore Identity 无独立发版（月级条目不可归窗）；Entra Agent ID 的 what's-new 停在 `ms.date` 2026-10-23；Google 的 Agent Identity 描述在博客而非版本页。
5. **本周有真实的 agent 凭证/越权类一手安全公告，集中在 MCP server 生态**：AWS 2026-195（11-20）、2026-200（11-24）、2026-202（11-25），加 GitHub Advisory 11-20~11-25 一批 MCP 相关 CVE。

### 状态表

| 对象 | 窗口内状态 | 版本/日期（CST） | 证据级 |
|---|---|---|---|
| AWS AgentCore Identity | 无独立发版 | 月级条目 | A / 日期未定 |
| AWS IAM TIP 扩展 | 有动态（重要） | 11-25 14:00 | A |
| Entra Agent ID | 无窗内更新 | what's-new ms.date 2026-10-23 | A |
| Google Agent Identity / Gateway | 有动态（博客） | 11-24 | B / A（principal 格式） |
| IETF OAuth agent 草案 | 有动态（4 条） | 11-19 / 11-22 / 11-23 / 11-25 | A |
| MCP OAuth / CIMD | 无新 SEP | SEP-991 Final；规范仍 CIMD SHOULD、DCR deprecated | A |
| 安全公告（agent 凭证） | 有动态（多条） | 11-20 / 11-24 / 11-25 + GHSA | A |
| Composio / Nango / Arcade / Pipedream auth | 仅 Composio 有动态 | CLI 0.6.4（11-25） | A |

### 深拆 1：AWS IAM TIP——身份传播的边界就是管理边界（A）

- **做了什么**：见 §0.2(4)。补充：IAM Identity Center 侧提供简化体验（身份源用户名与生成的 user ID 一并带上）；IAM outbound identity federation 的 JWT 也加入 TIP 身份数据；覆盖全部商业 Region、GovCloud (US)、European Sovereign Cloud（Germany）。
- **怎么做到的**：context 由 STS 在 `AssumeRole` 时附加，调用方在会话生命周期内不能修改，`aws:OriginIdentity/*` 由 AWS 派生、不来自调用方输入。策略侧用 condition key 读取（例如只允许 `SubjectType=workload` 且 `Issuer` 为指定 IdP 的请求访问某资源）；审计侧 CloudTrail 记录 origin identity 与 transaction context。出站经 `GetWebIdentityToken` 把同一份 context 编码成 `origin_identity` / `transaction_context` claim。
- **意味着什么**：agent 用自己的 workload 身份跑、下游仍能看到它代表谁，不必再靠可伪造的 `RoleSessionName`。**跨组织即丢 context** 是明确取舍：限制爆炸半径，但跨组织 agent 调用必须回到 OAuth/联邦。迁移上，federation 与 Roles Anywhere 的接入点要开始输出 source identity（SAML 属性 / OIDC claim / 证书 subject），否则下游拿不到 context。

### 深拆 2：Google Agent Gateway + Agent Identity（B）

- **做了什么**：见 §0.2(3)。补充 Workspace 侧：agent 必须用专用 OAuth client ID、最小权限 scope、限时批准（coming soon）与用量配额；Workspace MCP server 拒绝非 agent 的 OAuth client；2027-02-01 起技术强制 agent 只走 Workspace MCP server / Workspace CLI；撤销 Agent Identity 或 OAuth grant 立即停止访问。
- **怎么做到的**：Cloud 侧 agent 在 Agent Registry 获得独立身份、无共享或长期密钥，受 IAM 策略与 org/folder/project 配额约束；可作为 principal 参与 allow/deny 与 Unified Access Policies，标识形如 `principal://TRUST_DOMAIN/resources/...`，trust domain 分组织级 `agents.global.org-…system.id.goog` 与项目级；Principal Access Boundary 用 `attribute.container/projects/<num>` 绑定。
- **意味着什么**：网关与身份目录绑成闭环——授权输入就是 Registry 身份，不另建 ACL。Workspace 侧「MCP server 拒绝非 agent client」是少见的协议层强制，配合 2027-02-01 的 REST API 退场，实际在重画 Workspace 集成边界。agent 不能再用「一个共享 OAuth app 打天下」。

### 深拆 3：IETF 四条草案——委托生命周期的四个切面（A）

- **做了什么**：intent token（11-25）是 `typ: intent+jwt` 的 sender-constrained JWT，只给 AS/PDP 消费，必填 `iss/sub/aud/iat/exp/jti/client_id/cnf`（禁 bearer），`intent` 含 `approval_context`（`explicit_consent_ui` 或 `attested_instruction`）、`display_summary`、可选 `prompt_hash`，`authorization_details` 用 RAR 定义资源/动作/位置/数量上限，`return_to_user_actions` 标出必须运行时确认的敏感动作；换取下游 token 走 RFC 8693，AS 按 `intent_id` 原子执行累计配额并做 RAR 逐层包含校验（请求 ⊆ ADP ⊆ Intent）。delegation revocation（11-19）用 SET 事件 `delegation-revoked` 按 `(iss, jti)` 撤销命名 token 及其全部后代，跨信任边界时边界 AS 不转发上游事件、只针对自己签发的 token 发新事件；另有「拉」路径逐链检查 status 并设 staleness 上限。DNS link（11-22）在 `_agent-oauth.<agent-name>` 发 TXT `v=agent-oauth1; iss=…; client_id=…; aud=…`，三字段各一次否则 fail closed。OAuth over AGTP（11-23）把 `client_id` 映射为 Agent-ID、每请求带 JWS 签名（覆盖 method/path/Agent-ID/Authority-Scope/delegation-chain digest/body digest/timestamp/nonce）、不存在 client_secret，token 绑定 `cnf.agtp_aid`。
- **怎么做到的**：四者分别是授权上界、撤销传播、跨组织归属锚、传输层身份映射。共同前提是「委托不是一次性授权，而是一棵需要被表达和关闭的树」。
- **意味着什么**：企业身份集成的问题从「支持哪些 grant」变成「授权上界怎么表达、撤销传播多远、跨组织靠什么锚」。MCP 侧本周无新 auth SEP，说明协议层短期不会替企业回答。

### 深拆 4：MCP server 的安全债集中到期（A）

- **做了什么**：2026-195（11-20，CVE-2026-130901）`awslabs.document-loader-mcp-server` 1.0.10–1.0.20 路径限制不当，特定环境变量组合下文档内容可让文件访问越出 base dir；2026-200（11-24，CVE-2026-135614）Amazon ECS MCP Server < 0.1.36 脱敏绕过，troubleshooting 工具返回 task definition 里的容器环境变量值与 secret 引用，能影响 agent 输入的一方即可取得；2026-202（11-25，CVE-2026-136267）Kiro Web 命令注入，agent 读到的内容里的 tool-call markup 被部分模型复述并在托管开发环境无确认执行（受影响模型 DeepSeek v3.2、GLM-5、MiniMax M2.1/M2.5、Qwen3-coder-next，时间窗 2026-05-18~2026-10-30）。GHSA 侧另有 mcp-server-fetch、mcp-server-git、mcp-server-kubernetes、Pomerium、DBHub、LiteLLM MCP、ruflo MCP bridge、Apache IoTDB MCP Server 等。
- **怎么做到的**：三类失败模式反复出现——(a) 把内容当指令；(b) 默认配置不安全（脱敏默认开但实现漏、只读可绕、未认证默认部署）；(c) 边界检查可绕（SSRF 白名单、`--repository`、base dir）。都不是模型漏洞，而是「工具进程的权限 ≥ 它读到的内容」。
- **意味着什么**：MCP server 已成为独立漏洞类别。版本要像依赖库一样纳管，并对默认配置单独验证（脱敏、只读、认证开关）。WAF 的协议合规检查不覆盖这类语义问题，只能在 server 侧修。

### 模块洞察

- **身份边界 = 管理边界**：AWS 跨组织丢 context、Google 用 org/project trust domain + PAB、Azure 在订阅/项目层强制 egress。三家都把 agent 权限半径钉在云账号/组织的行政边界上——这决定出事后爆炸半径的形状。
- **凭证从「长期 secret」转向「可验证的 context」**：出站换凭证、CLI 排除 `.env.local`、Google 明说无共享长期密钥、TIP 用不可篡改 context 取代 `RoleSessionName`。共同点是 agent 进程不持有可复制的长期密钥。
- **撤销仍是草案，产品只做到「停发 + 立断」**：Google 的「撤销立即生效」是最强产品承诺但依赖单一目录；跨组织派生树的传播仍停在个人草案。评估供应商要追问「撤销一个用户后，派生出的 agent token 在对方组织里多久失效」。
---

## §6 模块 6 · Context / Memory / Knowledge

### 结论

1. **OpenViking v0.5.6 把「PostgreSQL 化」从向量层推到元数据层**：Account、Task/Work、Watch 三类 store 可各自独立切到 PostgreSQL，配合 QueueFS 持久化顺序键，多节点共享账号/任务/Watch 状态不再需要 Redis；代价是启动不建表、切后端不迁数据。但上期点名的 `disabled_tools` 默认值安全问题**没有公开修正证据**。
2. **图记忆的安全议题从提示注入扩到跨租户 UUID 越权**：Graphiti v0.32.0/0.32.1 把 `group_id` 校验下沉到 core，任何带 UUID 的读写只要属于别的 group 一律按不存在处理（404 语义而非 403，避免泄露存在性）；修复来源是 Codex Security 的一个发现（#2178）。
3. **检索从「一次搜索」变成「有预算的 agentic 循环」**：Zep Smart Query 把「查一条→用结果决定下一条→何时停」收进服务端（fast 最多 3 轮可并行、deep 先规划后枚举、上限 300 条、`truncated` 标记），API 标注 experimental、前 90 天免费后按次计费。
4. **记忆层的性能焦点转到「不要破坏 prompt cache」**：supermemory 一周三条同主题修复，让召回以不破坏稳定前缀的方式拼接，语音链路 recall 上限压到 1.5 秒；同时用 memory-graph 0.3.0 把整图读取挪到服务端，避免 API key 下发浏览器。
5. 其余：Cognee v1.6.10 收紧连接池默认值并加 LLM call `caller` 字段；Firecrawl 一周五条垂直数据目录；Crawl4AI 五周多来首个版本但 release 无变更说明；Mem0 连续第二周无版本；Letta 主仓静默、letta-code 五版。

### 状态表

| 对象 | 窗口内状态 | 关键锚点（CST） | 证据级 |
|---|---|---|---|
| OpenViking | 有动态 | v0.5.6（11-24 13:06）、SuperAgent 0.5.6-preview（11-25 13:57） | A |
| Mem0 | 无版本 | 最新 2026-09-25；#7985（11-23）、#8004（11-25）依赖安全 | A |
| Cognee | 有动态 | v1.6.10（11-19 05:49） | A |
| supermemory | 无版本，有代码动态 | memory-graph 0.3.0（11-25 06:27）、prompt cache 三条（11-21~22） | A |
| Letta | 主仓静默；letta-code 五版 | 0.34.66~0.34.70（11-19~11-23） | A |
| Zep / Graphiti | 两家有动态 | Graphiti v0.32.0（11-24 05:11）/0.32.1（11-25 00:29）；Zep 博客 11-24 | A / B（演示数字） |
| Firecrawl | 有动态（5 条） | 11-19 ~ 11-25 | A（站点日期）/ B（数字） |
| Crawl4AI | 有动态 | v0.9.6（11-20 17:46） | A / 机制未取得 |

### 深拆 1：OpenViking v0.5.6——共享状态从 Redis 搬到关系库，默认值问题未动（A）

- **做了什么**：11-24 13:06 发布 `openviking==0.5.6` / SDK 0.1.21 / CLI 0.5.4 / React 0.2.0；11-25 13:57 补 SuperAgent 0.5.6-preview。六组变化：① Account、Task/Work、Watch 三类 store 可分别选 `postgres`（保留 File/SQLite/MySQL），多进程/多节点可共享账号、用户、API key、任务与 Watch 状态且不需要 Redis；② QueueFS 按 `serial_key`/`group_key` 持久化顺序，重试/取消/恢复后仍保序，SessionCommit 等已接受的 memory batch 才 ack；③ Compile 拆分：配置改用 creator 作用域的 `compile_name`，每次运行有独立 task ID、冻结输入、增量基线与 Git 快照；④ `ov privacy run` 在子进程 stdout/stderr 遮蔽 owner 绑定引用，解析失败拒绝启动；⑤ MCP 检索支持 tag 过滤与上下文预算回填；⑥ `ls`/`tree`/`stat` 返回 effective `access`，ACL 拒绝资源账号之外的主体。
- **怎么做到的**：把「共享状态」从 Redis 搬到关系库——三类 store 各自是 provider 接口，切到 postgres 后行落在同一套数据库，多节点靠数据库原子更新竞争。代价写进迁移说明：启动不执行 DDL（必须先用打包 SQL 建表）、切后端不迁数据、Watch 表要补分页索引（`CREATE INDEX CONCURRENTLY`，缺索引只告警）。QueueFS 的顺序保证靠消息上持久化的 key，因此 Redis 格式变了，Rust 扩展与 Python server 必须同版本升级。
- **意味着什么**：部署栈可收敛到「PostgreSQL + 对象存储」，Redis 从必需变可选；但升级动作变重（建表权限、索引、混版窗口），Compile 的 API/数据模型是 breaking（create configuration → start run → query run/output）。安全侧本期是收紧（跨账号授权直接校验失败），但 **v0.5.6 的 highlights 与 12 条迁移说明均未提 `disabled_tools`**，核对 `openviking_gateway/config.py` 与 `profile.py` 也未见该字段，只能判「无公开修正证据」——上期「升级后必须显式列出要关闭的写工具」的检查项继续有效。

### 深拆 2：Graphiti——租户边界从工具层下沉到数据访问层（A）

- **做了什么**：v0.32.0（11-24 05:11）、v0.32.1（11-25 00:29，替代 0.32.0 的发布）；MCP 1.1.4（11-24 05:44，构建失败无镜像）、1.1.5（11-25 01:09）。核心：`delete_episode`、`get_episode_entities`、`get_entity_edge`、`delete_entity_edge`、`summarize_saga` 以及 `EntityEdge.get_by_uuid/get_by_uuids`、`add_triplet` 都开始校验 `group_id`；删除 Kuzu 驱动、新增内嵌 Relate 驱动；并发摄取随本版进正式 release。
- **怎么做到的**：此前 MCP server 只把「当前选中的 group」当过滤条件传给 core，core 的 UUID 直查不验证归属——知道一个 UUID 就能跨组读或删。修复后所有接受 UUID 的入口先做归属检查，不匹配按「不存在」处理。另有一条语义收紧：`add_episode(uuid=...)` 不带 `group_id` 时只在默认 group 内查找，未知前序 UUID 从「跳过」改为抛错。
- **意味着什么**：多租户 SaaS 必须升级，并检查是否有「跨 group 复用 UUID」的调用（会从能跑变成找不到）。MCP 1.1.5 要求 `graphiti-core>=0.32.0`、镜像内固定 0.32.1，混用旧 core 会失去隔离保证。

### 深拆 3：Zep Smart Query——把多跳循环收进一次 API，但策略不可调（B）

- **做了什么**：11-24 博客发布 `graph.query`：接受自然语言 query + 恰好一个 graph UUID，参数 `mode`（fast/deep）、`generate_answer`、可选 `guidance`、`stream`；只读、不保留会话状态。返回按类型分组（edges/facts、nodes/entities、episodes、observations、thread summaries），最多 300 条，截断时优先保留被引用记录并置 `truncated=true`。演示数字：邮件/日历图上 fast 约 1 秒找到目标会议；计数类查询 fast 给「20 个会议」、deep 约 7 秒找全 47 个。
- **怎么做到的**：fast 是有界循环——最多 3 轮搜索、每轮可并行，上下文足够或无新证据即停止；deep 是先规划后执行，可枚举某过滤条件下的全部节点/边，故能给出完整列表与计数。调用方不能选模型、工具或循环上限，策略完全由 Zep 托管；BYOM/BYOC 下 deep 把模型调用打到客户 provider，fast 还要求配置 decision model。
- **意味着什么**：省掉「自己写多跳循环 + 防死循环」，换来策略不可调。成本要按「一次 query 的实际模型调用数」估算；experimental 且可不经版本变更而改，不宜写进 SLA 关键路径。

### 深拆 4：Cognee / supermemory / Crawl4AI / Mem0（A）

- **Cognee v1.6.10**（11-19 05:49）：per-dataset Postgres 连接池默认 overflow 更低、等待有界，官方提示「大量短时写峰值会更早遇到 pool exhausted」，要求复核 `VECTOR_POOL_ARGS`、dataset 级设置与 `pool_timeout`；LLM call capture 写 JSONL 并新增 `caller` 字段；chunk identifier 集中打戳。机制是「用队列吸收突发、用有界池保护数据库」，代价是突发容量余量变小。
- **supermemory**：memory-graph 0.3.0 新增 `@supermemory/memory-graph/server` 的 `fetchMemoryGraph`（服务端取整图，失败抛 `MemoryGraphError` 并带 401/403/429），`<MemoryGraph endpoint>` 可指向应用自己的鉴权路由；导出类型 `DocumentsResponse` → `GraphPage` 是 breaking。prompt cache 三条让召回以不破坏稳定前缀的方式拼接、取记忆不阻塞模型调用，语音链路 1.5 秒上限。
- **Crawl4AI v0.9.6**（11-20 17:46）：五周多来首个版本，release body 只有安装命令与「See CHANGELOG.md」，无功能条目；同日 docker-rebuild 说明 arm64 构建从 QEMU 仿真改为每平台原生 runner（QEMU 下 Playwright 1.65 的 Chromium GPU 进程崩溃导致发布中断）。**机制未取得**：功能变更未读 CHANGELOG。
- **Mem0**：连续第二周无版本（最新 2026-09-25），窗内两条提交均为依赖安全批量修复（#7985 22 个 HIGH/CRITICAL、#8004 5 个 LOW）。功能面没有新东西，但依赖漏洞在被持续修。

### 模块洞察

- **记忆层的「正确性」分三层补齐**：写入一致性（上期）→ 租户隔离（本期 Graphiti）→ 元数据持久化（本期 OpenViking）。采购要分别问：写入状态机、UUID/主键级隔离、元数据存储的备份与迁移方式。
- **默认值安全问题不会随版本自然消失**：OpenViking 12 条迁移说明没有一条回滚 `disabled_tools`。升级检查单必须自己维护。
- **「检索预算」成为新产品参数**：Zep 用 fast/deep 把「查几轮、要不要查全」变成显式选择；Firecrawl 用垂直目录减少「要查几次」。评测应看「按预算的召回曲线」而非单点召回率。
- **prompt cache 命中率是记忆层被低估的 KPI**：记忆注入的方式直接决定长会话成本；POC 应测「注入前后 cached token 占比」与首 token 延迟。

---

## §7 模块 7 · Observability / Eval / Guardrails

### 结论

1. **模块 7 本周不冷，出了两个「第一次」**：NeMo Guardrails v0.25.0（11-19 17:28）是 2026-09-16 以来首个代码版本，首次同时提供面向模型 API 的网关与面向编码 agent 的 hooks server；OTel GenAI v0.1.0（11-21 08:29）是从主 semconv 仓独立后的首个版本，带 20 条 breaking。
2. **语义约定从「永远 development」进入「有版本可对齐」**，代价是一次性迁移：`invoke_workflow` 并入 `gen_ai.invoke_agent.internal`、`gen_ai.client.token.usage` 拆成 input/output 两个直方图、inference/embeddings/execute_tool/agent 各自拥有独立 duration、取消 span 属性的 JSON-string 回退、MCP 统一用 `rpc.status_code`，并新增 A2A 协议约定。
3. **独立 eval 平台的共同方向是「调查 + 成本核算」**：LangSmith Engine 把每类失败模式做成可执行 issue 并回查修复效果；Phoenix v22 给 DECISION/EMBEDDING span 记成本并把 model type 设为不可变；Langfuse 把计费迁到 billable-units ledger、Topics 转 public beta；Braintrust Patterns GA 并从 12-07 起计费。
4. **护栏供给恢复但仍是单腿**：NeMo 恢复发版并扩张到「守别人家的模型 API」；Guardrails AI 自 2026-08-26 起仍 0 提交、最新 release 停在 08-14。
5. **「平台内置观测吸收独立工具」只部分成立**：被吸收的是基础 trace + 人工标注层；独立厂商在往上走「调查/归因/成本」层，与平台正面相撞。

### 状态表

| 对象 | 窗口内状态 | 关键锚点（CST） | 证据级 |
|---|---|---|---|
| OTel GenAI semconv | 有动态（首版 + 语义提交） | v0.1.0（11-21 08:29）；service_tier（11-25 02:42）；tool.definitions opt-in（11-25 06:03） | A |
| LangSmith | 有动态（周档 11-16~11-23） | Engine 失败模式 issue、Sandbox volumes beta、User Groups breaking | A 内容 / D 日期 |
| Phoenix | 有动态（major + 小版 + 包） | v22.0.0（11-20 13:14）、v22.0.1（11-22 04:28）、evals 2.8.0（11-19 09:20） | A |
| Langfuse | 有动态（3 版） | v4.84.0（11-23 20:22）、v4.85.0（11-24 21:39）、v4.86.0（11-25 02:54） | A |
| Braintrust | 有动态 | py 0.52.0（11-19）；Patterns GA 与 12-07 计费 | A 版本 / B 产品档 / D 条目日期 |
| Guardrails AI | 无动态 | 最新 v0.11.0（08-14），最后提交 08-26 | A |
| NeMo Guardrails | 有动态 | v0.25.0（11-19 17:28）、文档快照 r2（11-20 02:47） | A |
| AgentOps / Helicone | 无基础设施级动态（未逐家扫） | — | — |

### 深拆 1：OTel GenAI v0.1.0——把指标维度从「一次操作」拆到「一类操作」（A）

- **做了什么**：11-21 08:29 发布 v0.1.0，基线是主 semconv v1.41.0 之后的改动，依赖 semantic-conventions v1.45.0，GitHub 标注 Immutable release。20 条 breaking 分四类：① 命名合并——`invoke_workflow` 并入 `gen_ai.invoke_agent.internal`，`gen_ai.workflow.name` 换 `gen_ai.agent.name`，`gen_ai.agent.id` 从 internal agent span 移除，`gen_ai.provider.name` 在 internal `invoke_agent` 上不再必需；② 指标拆分——`gen_ai.client.token.usage` 与 `gen_ai.token.type` 被 input/output 两个 token 直方图取代，新增 `gen_ai.client.inference.duration`、`gen_ai.client.embeddings.duration`、`gen_ai.client.invoke_agent.duration`、`gen_ai.execute_tool.duration`，四类操作不再上报到通用 `gen_ai.client.operation.duration`；③ 语义修正——`gen_ai.request.top_k` 从 double 改 int 且专指采样（检索用 `gen_ai.retrieval.top_k`）、`cache_creation` 改名 `cache_write`、MCP 用 `rpc.status_code`、`mistral_ai` 改 `mistral`；④ schema 严格化——畸形 part 与畸形 tool-function 定义由 JSON schema 直接拒绝，取消 span 的 JSON-string 回退。新增 A2A 协议约定（client/server span，覆盖 protocol/message/task/conversation/tenant/Agent Card 元数据与三种绑定的错误上报）。
- **怎么做到的**：旧模型用一个通用 duration 承载推理、embedding、agent 调用、工具执行、检索，靠属性区分，结果同一张直方图混着量级差几个数量级的分布，分位数没有意义。v0.1.0 让每类操作有自己的 duration 与 token 指标，代价是仪表盘与告警规则要重建。取消 JSON-string 回退是把校验从「消费端宽容」推到「生产端严格」。
- **意味着什么**：重点检查三处——是否还在用 `gen_ai.client.token.usage`、是否把工具执行/检索算进通用 duration、是否有属性靠 JSON 字符串传递。采购终于可以写「输出符合 v0.1.0」，但仍是 0.x，release notes 未给稳定性承诺。

### 深拆 2：NeMo Guardrails v0.25.0——护栏从库变成「网关 + hooks」（A）

- **做了什么**：① 实验性 Gateway——面向 buffered OpenAI Chat Completions 与 OpenAI Responses，保留已接受的 provider payload，只检查一个用户文本输入 + 一个助手文本输出；支持流式 SSE 窗口化检查并原样转发已接受的字节；显式选择 LiteLLM dialect；多 provider 实例；按 YAML manifest 校验并启动。② Hooks server——pre-tool-use 检查，通过 Claude Code 与 Codex 的 hooks、以及 NeMo Relay 插件接入；支持工具与参数 allowlist/blocklist、无模型策略、按工具检查；Prometheus 暴露 admission queue 指标。③ `/v1/checks` 返回 block 原因与结构化 `tool_violations`。Breaking：drop Python 3.10；流式工具调用改为 `ToolCallChunk` 结构化事件；jailbreak 检测拒绝超过 2,048 token 的输入；**检测器故障或结果非法现在直接 block**（此前可能放过）；`tool_output`/`tool_input` 改名 `tool_call`/`tool_result`；`LLMRails` 与 Colang runtime 弃用、最早 0.27.0 移除；hooks allowlist 必须显式选 `allow_unlisted_tools`。
- **怎么做到的**：网关的思路是不改调用方——应用仍按 OpenAI 协议发请求，网关在中间检查后原样保留 provider payload；但检查 profile 只覆盖单条用户文本 + 单条助手文本，不覆盖多轮历史、工具、音频、图像。hooks server 把护栏前移到工具执行之前，拒绝就不执行。检测器故障即 block 是一次 fail-closed 反转，代价是检测服务抖动直接变成用户侧错误。
- **意味着什么**：护栏的部署位置从「应用内嵌库」变成「模型 API 前的网关」与「agent 工具循环里的 hooks」两个可独立采购的点，不需要改业务代码；但网关只审单轮文本，多轮/多模态仍要应用自己补。迁移要一起排四件事：Python 3.10、流式工具调用、命名改名、`LLMRails`/Colang 弃用。

### 深拆 3：Phoenix v22 / Langfuse / LangSmith / Braintrust——把成本做成账本（A/B）

- **Phoenix v22.0.0**（11-20 13:14，major）：generative models 新增 type 列，DECISION 与 EMBEDDING span 开始记成本；GraphQL 与 cost manifest 暴露 model type；**model type 设为不可变**；SQLite 迁移放进显式事务；附 v21→v22 迁移说明。机制：此前成本只覆盖 LLM 生成 token，判定与向量化没有单价；加 type 后按 type 选价格表，三条成本线可分开看；不可变是为保护历史成本（改 type 会重算旧 span，账单不可复现）。`phoenix-evals 2.8.0` 给分类 evaluator 加 Gemini Decisions API（`gemini-decision-1`）。
- **Langfuse v4.84~4.86**：把计费迁到 billable-units ledger（Stripe metering 直接消费单元条目，Topics facet 也按单元计费）；Topics 在 Cloud 转 public beta，前提是 v4.85 加了 cost estimation 与 live/snapshot 成本；native OTEL 处理改为 opt-in，降低默认 schema 耦合风险。
- **LangSmith 周档（11-16~11-23）**：Engine 为每类失败模式开一个可执行 issue、关联 trace、看板优先级影响严重度，盯 GitLab CI 的修复 MR 并在合并后回查最近一天 run；Sandbox volumes 进 beta（停止时保留内存、快照含内存）；replica 关闭时在途 run 回到队列（step 边界），带 checkpoint 的 thread 在另一 worker 恢复（需 LangGraph 1.2.15+）。**日期只能到周区间**。
- **Braintrust**：py SDK 0.52.0（11-19）补 Pipecat 全双工 GPT-Live pipeline tracing 与 LiveKit `eou_wait`/`livekit.stt`/`livekit.tts`/`livekit.llm_response` span；Patterns GA（分析 trace 与应用日志找复发问题、按用户/会话排影响、跨 trace 与源码看证据），**Patterns 与 Loop 从 2026-12-07 起消耗 credits**；`bt trace disable` 改为「暂停但保留设置」（breaking）。

### 模块洞察

- **语义约定终于有版本，2026 Q4 的埋点债要现在清**：影响面最大的是 token 直方图拆分与四类操作离开通用 duration，会让所有现存仪表盘失真。建议按「属性名 → 指标名 → schema 严格性」三步迁移，迁移期双写。
- **护栏的部署位置比算法更重要**：先问「能插在哪」，再问「判得准不准」。
- **成本核算从估算变成账本**：要求供应商按「模型类型 × 操作类型」出账，而不是给一个总数。
- **major 集中出现，迁移成本被低估**：Phoenix v22、NeMo v0.25、OTel v0.1.0 同周，各有 breaking。应把这一周视为「观测栈的迁移窗口」。

---

## §8 模块 8 · 托管 Agent 平台与企业控制面

### 结论

1. 本窗是 **Foundry 的 Ignite 发布周**：9 篇官方博客（5 篇 11-19 01:00 CST 属本周新披露，4 篇 11-20~11-25 在窗内）+ 9 条 Azure Updates（11-21、11-24、11-25），覆盖托管运行时、VNet 注入、出口治理、成本控制、评测与网关，是目前最完整的一套 agent 控制面公开能力面。
2. Foundry 的控制面有一条清晰主线：**把 agent 当「有身份的员工」治理**——Entra Agent ID + 独立邮箱/日历/OneDrive + 经理 + 审计轨迹 + blueprint 模板 + 一键 kill switch，再叠加 Agent 365 做跨厂商 fleet 的观测/治理。
3. **网络出口治理是最具体的企业采购门槛**：出口策略 GA（沙箱外强制执行、默认拒绝、Audit→Enforce、运行中会话保持旧策略）、Azure Policy 跨订阅治理 preview、私有 CA 信任 preview、共享子网 IP GA（/24 规划约 6 万会话）。
4. **成本控制从账单前移到请求**：按 resource/project/model deployment/agent/session 设美元或 token 预算，请求运行时计数，80% 告警、100% 阻断；官方明确不是发票上限，且不覆盖工具费、托管计算、预置吞吐。
5. 其他云厂本窗相对静默：AWS 仅 AgentCore runtime instances 在 GovCloud GA 一条；Google 最新条目停在 11-17；国内阿里 11-24 有知识库控制面更新、火山只有月档、腾讯仅计费公告。**能力矩阵本周主要由 Microsoft 单边推进。**

### 状态表

| 对象 | 窗口内状态 | 版本/日期（CST） | 证据级 |
|---|---|---|---|
| Microsoft Foundry / Ignite 2026 | 有动态（9 博客 + 9 Azure Updates） | 11-19 01:00 ~ 11-25 00:52 | A（博客）/ B（Updates 机制） |
| Microsoft Agent 365 / Entra Agent ID | 无窗内公开更新 | 概述页 ms.date 2026-11-11 | A（核验） |
| AWS AgentCore（平台） | 有动态（1 条） | 11-24 01:21 | A |
| Google Gemini Enterprise Agent Platform | 无窗内条目 | 最新 11-17 | A |
| 阿里云百炼 | 有动态（1 条控制面） | 11-24 知识库 Wiki/图谱 | A |
| 火山方舟 | 无日级锚点（月档） | 页面最近更新 2026-11-19 | C |
| 腾讯云 ADP / TokenHub | 有计费/服务公告 | 11-20、11-24、11-25 | B（列表页标题+日期） |

### 深拆 1：Foundry 的 agent 身份——把 agent 放进 org chart（A）

- **做了什么**：Foundry agent 可获得 Microsoft Entra agent identity 与 agent user account，拥有独立邮箱、日历、OneDrive、Teams 存在感、组织图中的经理与审计轨迹；以 blueprint 模板分发，管理员批准后组织内每人可「hire」自己的实例；**一个 kill switch 可禁用一整类 agent**；由 Entra（身份/访问）、Purview（合规）、Defender（威胁）治理。Nous Research 的 Hermes Enterprise 是首个公开案例，可作为 SaaS 或客户 Azure 租户内自托管。
- **怎么做到的**：把 agent 建模为 org member 而非 app registration——有 user account 才能执行 M365 动作（发邮件、进群聊），有 manager 才能落到问责链，有 blueprint 才能把「能力定义」与「具体团队资源授权」分离（blueprint 本身不授予任何团队资源，由每个 manager 决定实例能访问哪个 ADO 项目/SharePoint 站点）。这解决两个真实失败模式：无登录用户的事件触发 agent 无法代表任何人行动；群聊中 agent 必须猜「代表谁」导致越权。
- **意味着什么**：这是目前公开材料里最完整的 agent 身份生命周期方案，直接对标 Agent 365 的跨厂商 registry/map。采购问题变成「我的 IdP 能否给 agent 发可控、可撤销、可审计的身份」；非 Microsoft 栈短期只能做到「服务账号 + 自建审计」，差距在撤销粒度与 org chart 问责。

### 深拆 2：出口治理与 VNet——平台给你一个委派 subnet，DNS/防火墙/软删除由你负责（A）

- **做了什么**：出口策略 GA、Azure Policy 出口治理 preview、私有 CA 信任 preview；11-22 02:12 的运维文给出五个检查：① 确认 agent subnet 委派 `Microsoft.App/environments`、/27 起、RFC1918、不与 peered VNet 重叠、每个 Foundry resource 独立 subnet（`az cognitiveservices account show --query properties.networkInjections`）；② 「Listing agents timed out after 8s」多为 data proxy 读不到 Cosmos DB，先查 private endpoint 与 `privatelink.documents.azure.com` 区域链接/DNS；③ 私有 CA 不覆盖平台自身的 Entra ID / managed identity 流量，TLS 解密防火墙须对 `login.microsoftonline.com`、`{region}.login.microsoft.com`、`control-{region}.identity.azure.net` 放行不解密；④ peered hub VNet 可用，但 private DNS zone 必须链接到 agent subnet 所在 VNet；⑤ 删除 Foundry account 是软删除，subnet 仍被占用，需 `az cognitiveservices account purge`。
- **怎么做到的**：agent subnet 里跑的是每会话 microVM + 每项目一个单租户 data proxy；工具调用经 data proxy 出网到存储/数据库/Key Vault，平台从该 subnet 用 managed identity 登录 Entra。所有检查都归约为「agent subnet 能否解析并到达它需要的东西」。出口策略在沙箱外求值，见 §0.2(2)。
- **意味着什么**：这是本周唯一一份可直接照做的故障定位手册，也暴露了托管 agent 的真实运维边界。硬约束：network injection 必须在创建 Foundry account 时设置，不能后加——架构决策前置。

### 深拆 3：评测、洞察与成本——把 FinOps 嵌进请求路径（A/B）

- **做了什么**：Insights GA、multi-turn evaluation GA；human annotation / rubric evaluators / Agent Optimizer preview；audio evaluation 增加 4 个对话级评估器（Task Completion / Groundedness / Customer Satisfaction / Coherence Audio）；Microsoft-Decision-1 作 judge（preview，返回固定答案概率而非生成解释，官方测试中位延迟 0.59s、约 $0.12/1,000 次评估调用）；cost views preview 按 project/agent/model 拆分 Cost Management 数据；cost controls preview 按 resource/project/deployment/agent/session 设预算、运行时计数、80% Event Grid 告警、100% 阻断；caller attribution private preview 按应用/成本中心/团队打标。
- **怎么做到的**：Insights 对生产 trace 聚类成可行动 finding；human annotation 把专家评分/标签/期望输出转成评测数据集并为每个测试用例生成 rubric（官方称 HelpSteer3 测试中人机一致率从 65% 升到 81%，人类间为 89%）；Insights→Agent Optimizer 把复发问题送进候选修复（改 instruction、工具描述、模型选择）并在评测集上对比。
- **意味着什么**：评测从离线数据集转向「生产 trace → 人工标注 → rubric → 回归」闭环；成本控制把 FinOps 嵌进请求路径。采购注意三条官方限制：只覆盖受支持 GPT/o-series token，不含工具费/托管计算/预置吞吐；model router 未被完全覆盖；**不是发票上限**。

### 深拆 4：Dev Pack 与 Browser Automation——向竞品宿主分发（A）

- **做了什么**：Foundry Dev Pack GA：一条命令安装 Foundry CLI（`azd ai`）+ Microsoft Foundry Skill，并在存在时安装 VS Code Foundry Toolkit 与 GitHub Copilot app 的 Foundry 插件；四个入口共享同一套项目文件（`azure.yaml`）。Browser Automation 见 §3 深拆 3。
- **怎么做到的**：Dev Pack 把「agent 即代码」落到 `azure.yaml` + Bicep/Terraform，CLI 覆盖 init/provision/run/invoke/deploy/monitor/doctor/pipeline；Microsoft Foundry Skill 是给**任意兼容 coding agent**（GitHub Copilot、Claude Code、Cursor）的领域技能包，内置确定性命令行工作流以减少试错 token。
- **意味着什么**：控制面厂商向竞品宿主分发开发面，是少见策略；对团队意味着 Foundry 项目可以进现有 coding agent 工作流，但也把「技能包」变成新的供应链条目（与 §1 的 MCP skills 同题）。

### 模块洞察

- **控制面竞争的分水岭是「执行点在哪」**：Foundry 出口策略在沙箱外、Azure Policy 在订阅层；AWS 把 runtime 放进客户 EC2；Google 把 gateway 放在 GKE。三家都在回答「安全策略不能依赖 agent 代码自觉」。
- **「托管」不是免运维，而是责任重新切分**：长跑恢复要 handler 幂等；VNet 注入要客户管 DNS/防火墙/软删除；memory snapshot 不保留内存与本地文件。采购应把「平台承诺」与「开发者义务」分列。
- **身份是本窗真正的差异化**：其他厂商还在讲 runtime/SDK 时，Microsoft 已把 agent 放进 org chart。这不是功能数量差，而是治理模型代差；代价是深度绑定 Entra/M365/Purview。
- **可核验性本身是矩阵的一列**：Microsoft 博客正文可读、Azure Updates 详情页不可读；AWS 公告正文可读、AgentCore 概览页营销级；Google 无窗内条目；国内三家分别 A/B/C。

---

## §9 综合层

### 9.1 必出对比表（模块｜产品/厂商｜版本或日期｜变化｜是否破坏性｜证据级）

| 模块 | 产品/厂商 | 版本或日期（CST） | 变化 | 是否破坏性 | 证据级 |
|---|---|---|---|---|---|
| 4 | AWS WAF + API Gateway | 11-24 02:47 | WAF 自动发现并保护 LLM/MCP/A2A 端点；API Portal 从流量日志发现 shadow API | 否（新能力，额外计费） | A |
| 8 | Microsoft Foundry | 11-19 01:00 ~ 11-25 00:52 | 出口策略 GA/沙箱外求值、Azure Policy 出口治理、MCP 经客户网关、A2A 直通、cost controls、agent 身份 | 是（MCP 不再自动注册，存量工具需手改） | A/B |
| 5 | AWS IAM | 11-25 14:00 | TIP 扩到 federation 与 Roles Anywhere；context 跨组织丢弃；`GetWebIdentityToken` 出站 JWT | 否（新增覆盖） | A |
| 4/5 | Google Agent Gateway | 11-24 | protocol-native 网关，授权输入是 Agent Registry 身份，出站默认拒绝 | 否（博客口径） | B |
| 1 | OpenClaw | 2026.11.10（11-25 16:59） | 子 agent 欠付结果跨重启、后台 exec 跨重启、`operator.cron`、插件权限键改名 | 是（插件权限键改名；更新日程默认 Hourly） | A |
| 1 | Claude Code | 2.1.328–2.1.332（11-19~11-25） | resume 修复、Admin Console 组织登录、MCP skills beta、Foundry 默认 Sonnet 5.5 | 是（默认模型与 auto mode 默认值） | A |
| 1 | OpenAI Agents SDK | 1.0.0-alpha.2（11-24 04:11） | `ResumableSession` + 待审批恢复 + 条件写；alpha.1 内嵌 Codex Core | 是（schema 1.22→1.24，alpha.1 读不了新快照） | A |
| 1 | Google ADK | 2.15.0（11-20 06:59） | 评测 `pass@k`/`pass^k`、scoped sandbox、移除 Visual Agent Builder、默认开动态 instruction 路由 | 是（默认值 + 移除功能） | A |
| 2 | Foundry Hosted Agents | 11-19 01:00 披露 | 共享子网 IP（/24 约 6 万会话）、resilient execution 重入、memory snapshot 版本基线 | 否（新能力，恢复需幂等） | A/B |
| 2 | AWS AgentCore Runtime | 11-24 01:21 | Instances 计算类型在 GovCloud GA，客户账号 EC2，会话最长 14 天 | 否 | A |
| 2 | 火山方舟 Managed Agents | 文档 11-19 / 11-24 | 7 态会话状态机、idle 14 天终止、事件保留 6 个月、归档幂等 | 未知（事件日不可得） | A（文档） |
| 3 | browser-use | 1.0.7（11-21）/1.0.8（11-22） | MCP 50 秒分片、judge 复用缓存、预占减半 | 否（行为优化） | A |
| 3 | agent-browser | 0.44.0（11-24 06:44） | stream server 同源/loopback 校验、空 allowlist 报错、refs 失效显式报错 | 是（旧脚本会失败） | A |
| 3 | Foundry Browser Automation | 11-19 01:00 | Playwright Workspaces 托管、action batching、take control、VNet/代理/Key Vault preview | 否（preview 接口会变） | A |
| 4 | MCP Registry | v1.8.10~v1.8.16（11-20~11-23） | 发布时与每日 OSV 扫描、malware sweep、多 proof、私钥注入、moderator hold | 否 | A |
| 4 | Azure A2A passthrough | 11-25 00:48 | v1.0 GA 仅 JSONRPC、Entra-only；hosted agent 单轮 SendMessage、不支持 GetTask | 否（新端点，能力收窄） | A |
| 5 | IETF OAuth WG | 11-19 / 11-22 / 11-23 / 11-25 | intent token、delegation revocation、DNS link、OAuth over AGTP | 否（个人草案） | A |
| 6 | OpenViking | v0.5.6（11-24 13:06） | Account/Task/Watch 可切 PostgreSQL、QueueFS 顺序键、Compile 拆分 | 是（Compile API/数据模型） | A |
| 6 | Graphiti | v0.32.0/0.32.1（11-24/25） | UUID 级 group 校验下沉 core、删 Kuzu、加 Relate | 是（跨 group UUID 会报错） | A |
| 7 | OTel GenAI | v0.1.0（11-21 08:29） | 20 条 breaking：token 直方图拆分、四类 duration 独立、schema 严格化、A2A 约定 | 是 | A |
| 7 | NeMo Guardrails | v0.25.0（11-19 17:28） | 模型 API 网关 + agent hooks server、检测器故障即 block、drop Python 3.10 | 是 | A |
| 7 | Phoenix | v22.0.0（11-20 13:14） | DECISION/EMBEDDING 记成本、model type 不可变 | 是（major 迁移） | A |

### 9.2 模块 × 厂商矩阵素材（图 1 数据源）

评分口径：0 = 窗内无公开信号；1 = 仅单一条目/仅背景；2 = 窗内单一实质更新；3 = 窗内有结构性变化。评分为编辑判断，依据各模块状态表，不是能力评分。

| 模块 | Microsoft | AWS | Google | 阿里云 | 火山方舟 | 腾讯云 |
|---|---|---|---|---|---|---|
| 1 Harness / Agent OS | 2（Dev Pack / Copilot harness） | 1（AgentCore 仅 runtime） | 1（ADK 2.15 大版本） | 0 | 0 | 0 |
| 2 Runtime / Session | 3（重入语义 + 密度） | 2（Instances GovCloud） | 0（连续静默） | 1（知识库控制面，非 runtime） | 1（文档更新，事件日不可得） | 0 |
| 3 Sandbox / Browser | 3（Browser Automation GA + 4 preview） | 0（零条目） | 0（停在 11-12） | 0 | 1（CUA 文档） | 0 |
| 4 Tool Gateway / Protocol | 3（BYO MCP 网关 + A2A 直通） | 3（WAF + API Portal） | 2（Agent Gateway 博客） | 0 | 0 | 0 |
| 5 Identity / Auth | 3（Entra Agent ID 作为员工） | 3（TIP 扩 federation/Roles Anywhere） | 2（Agent Registry 身份） | 0 | 0 | 0 |
| 6 Context / Memory | 1（Foundry IQ 图谱） | 0 | 0 | 2（Wiki + 图谱） | 0 | 0 |
| 7 Observability / Eval | 2（Insights GA / 标注 / 成本） | 1（CloudWatch Omni 集成，窗外） | 0 | 0 | 0 | 0 |
| 8 Managed Platform | 3（Ignite 9 博客 + 9 Updates） | 1（GovCloud GA） | 0 | 1（知识库） | 0（月档） | 0（计费公告） |

CSV 见 `charts/module-vendor-matrix.csv`；图见 `assets/images/posts/2026-11-26-agent-infra-fig1-matrix.png`。

### 9.3 周环比（对照第 22 期，详见 `wow.md`）

- **延续**：Foundry 长跑能力（上期作背景，本期转正并扩到治理面）；AgentCore Runtime 计价与容量；Claude Code 版本节律；OpenClaw 会话所有权；MCP 扩展/Registry；OpenViking/Graphiti 记忆正确性；OTel GenAI 无版本状态（本期终于有版本）；browser-use 成本优化；国内云「晚披露/错位披露」；A2A 与 Guardrails AI 静默。
- **新出现**：WAF 级 AI 端点治理与 shadow API 发现；Foundry BYO MCP 网关与「发版前绑定出口策略」；Google Agent Gateway 以身份目录为授权输入；AWS TIP 扩 federation 并明确跨组织丢弃；IETF intent token / delegation revocation；MCP Registry OSV 扫描；MCP server CVE 波；OpenClaw 欠付结果台账；OpenAI `ResumableSession`；Claude Code MCP skills；OTel v0.1.0；NeMo 0.25 网关 + hooks；Graphiti UUID 级租户隔离；Foundry agent-as-employee。
- **消失/降温**：Google 连续第二周无 runtime 条目且旧入口冻结；AgentCore Identity 无发版；Entra Agent ID what's-new 停在 10-23；A2A 无发版；Pipedream 无公开记录；Mem0 连续第二周无版本；Guardrails AI 仍 0 提交；Databricks 月档；MAF 变更说明 404；E2B/Modal/Daytona 无窗内版本；Stagehand 稳定版再次滑出窗口；Coze 不可取得。

### 9.4 覆盖表（固定对象终态）

| # | 模块 | 对象 | 窗口内状态 | 核验入口 / 已试入口 |
|---|---|---|---|---|
| 1 | 1 | OpenClaw | 有动态（2026.11.8/11.9/11.10） | releases.atom + CHANGELOG |
| 2 | 1 | OpenAI Agents SDK | 有动态（0.25.0 / 1.0 alpha.1-2 / 0.26.0） | releases.atom |
| 3 | 1 | Anthropic Claude Code | 有动态（2.1.328–332） | CHANGELOG + npm registry time |
| 4 | 1 | Anthropic Agent SDK / Platform | Platform 有动态；SDK 版本无 changelog | platform release notes / releases.atom |
| 5 | 1 | LangGraph / LangChain / LangSmith | 补丁级；LangSmith 周档 | releases.atom / changelog |
| 6 | 1 | Google ADK | 有动态（2.15.0/2.15.1） | releases.atom |
| 7 | 1 | Microsoft Agent Framework | 无窗内发布；变更说明不可核 | PyPI + NuGet + GitHub（404） |
| 8 | 1 | Databricks Mosaic Agent | 无日级动态（月档） | release notes 索引 |
| 9 | 1 | CrewAI / Dify / pydantic-ai | 功能级 / 无 / 安全修复 | releases.atom |
| 10 | 2 | AWS AgentCore Runtime | 有动态（GovCloud Instances） | What's New + release notes（月级） |
| 11 | 2 | Google Agent Runtime（GEAP） | 无动态（最新 11-17） | GEAP release notes |
| 12 | 2 | Foundry Hosted Agents | 有动态（披露 + 运维文） | Foundry 博客 + Learn |
| 13 | 2 | 阿里云百炼 | 无本模块动态 | 百炼发布记录 + 沙箱页 |
| 14 | 2 | 火山方舟 Managed Agents / CUA | 有动态（文档更新，事件日不可得） | docs.volcengine.com |
| 15 | 2 | Coze | 本次未取得 | coze.cn/open/docs、/docs、docs.coze.cn（400） |
| 16 | 2 | 腾讯云 ADP | 无本模块动态 | cloud.tencent.com/announce + 文档索引 |
| 17 | 2 | OpenClaw sessions/cron/Gateway | 有动态 | releases.atom + CHANGELOG |
| 18 | 2/3 | E2B / Modal / Daytona | 无窗内版本 / Daytona 未取得 | releases.atom / changelog（JS 壳） |
| 19 | 3 | Browserbase | 有动态（Browser Sizes） | changelog |
| 20 | 3 | Stagehand | 稳定版窗外，dev 预发布在窗内 | releases.atom |
| 21 | 3 | browser-use | 有动态（1.0.7/1.0.8） | releases.atom |
| 22 | 3 | agent-browser | 有动态（0.44.0） | releases.atom |
| 23 | 3 | OpenAI / Anthropic Computer Use | OpenAI 无；Anthropic 计量口径变更 | changelog / release notes |
| 24 | 3 | AWS AgentCore Browser / Code Interpreter | 无窗内条目 | release notes |
| 25 | 3 | Microsoft Browser Automation | 有动态（GA + preview） | Foundry 博客 |
| 26 | 3 | Google Cloud Run / GKE agent sandbox | 无窗内变化 | GKE release notes |
| 27 | 4 | MCP 规范 / SEP | 无新修订、无新 SEP | spec + SEP 索引 |
| 28 | 4 | MCP Registry | 有动态（7 版） | releases.atom |
| 29 | 4 | MCP TS / Python SDK | 无发版 | releases.atom |
| 30 | 4 | A2A | 无发版（docs 提交） | releases.atom + commits |
| 31 | 4 | Composio | 有动态（CLI 0.6.4） | changelog |
| 32 | 4 | Arcade | 无窗内发版 | releases + PyPI |
| 33 | 4 | Nango | managed 发版，机制未取得 | releases.atom + 2 个 changelog URL（404） |
| 34 | 4 | Pipedream Connect | 无公开记录 | changelog + GitHub releases |
| 35 | 4 | Azure Foundry MCP 网关 / A2A | 有动态（preview） | Azure Updates + Learn how-to |
| 36 | 4 | AWS WAF / API Portal | 有动态（GA） | What's New 正文 |
| 37 | 4 | AWS AgentCore Gateway | 无窗内公告（月级） | release notes + What's New |
| 38 | 4 | Google Agent Gateway | 有动态（博客） | Google Cloud 博客 + IAM 文档 |
| 39 | 5 | AWS AgentCore Identity | 无独立发版 | identity 文档 + release notes |
| 40 | 5 | AWS IAM TIP | 有动态 | What's New + IAM 文档 |
| 41 | 5 | Entra Agent ID | 无窗内更新 | what's-new（ms.date 10-23） |
| 42 | 5 | Google Agent Identity | 有动态（博客） | 博客 + IAM principal 文档 |
| 43 | 5 | IETF OAuth agent 草案 | 有动态（4 条） | Datatracker |
| 44 | 5 | MCP OAuth / CIMD | 无新 SEP | spec authorization |
| 45 | 5 | Arcade/Composio/Nango/Pipedream auth | 仅 Composio 有动态 | 各 changelog |
| 46 | 5 | Agent 凭证安全公告 | 有动态（3 条 AWS + GHSA） | AWS Security Bulletins / GHSA |
| 47 | 6 | OpenViking | 有动态（v0.5.6） | releases + 源码检索 |
| 48 | 6 | Mem0 | 无版本（依赖安全修复） | releases + PyPI + commits |
| 49 | 6 | Cognee | 有动态（v1.6.10） | releases.atom |
| 50 | 6 | supermemory | 无版本，有代码动态 | commits + PR |
| 51 | 6 | Letta | 主仓静默；letta-code 五版 | releases.atom |
| 52 | 6 | Zep / Graphiti | 有动态（v0.32.x + Smart Query） | releases + 博客 |
| 53 | 6 | Firecrawl | 有动态（5 条） | changelog |
| 54 | 6 | Crawl4AI | 有动态（v0.9.6，机制未取得） | releases.atom |
| 55 | 7 | LangSmith | 有动态（周档） | changelog |
| 56 | 7 | Phoenix | 有动态（v22） | releases.atom |
| 57 | 7 | Langfuse | 有动态（v4.84–4.86） | releases.atom |
| 58 | 7 | Braintrust | 有动态（py 0.52.0 + 产品档） | changelog + PyPI |
| 59 | 7 | Guardrails AI | 无动态（0 提交） | releases + commits |
| 60 | 7 | NeMo Guardrails | 有动态（v0.25.0） | releases.atom |
| 61 | 7 | OTel GenAI | 有动态（v0.1.0） | releases.atom |
| 62 | 7 | AgentOps / Helicone | 无基础设施级动态（未逐家扫） | — |
| 63 | 8 | Microsoft Foundry / Ignite | 有动态（9 博客 + 9 Updates） | devblogs feed + Azure RSS |
| 64 | 8 | Microsoft Agent 365 | 无窗内更新 | Learn 概述页 |
| 65 | 8 | AWS AgentCore（平台） | 有动态（GovCloud） | What's New |
| 66 | 8 | Google GEAP | 无窗内条目 | release notes |
| 67 | 8 | 阿里云百炼 / 火山方舟 / 腾讯云 | 阿里 1 条；火山月档；腾讯计费 | 各发布页 |

**OpenClaw 终态行**：有动态（3 个正式版 + 1 beta 在窗内），无迁出或更名，覆盖行保留。

### 9.5 发现层摘要（4 份 `discovery.md`）

- **A 组（14 条，纳入 6）**：Foundry Dev Pack/CLI GA；MCP Skills extension（与 Claude Code MCP skills 同周，形成「skill 作为 MCP 资源」的跨厂商约定）；A2A 1.0 在 Foundry 采用；Temporal × Foundry（early access，无可核 API，观察）；Nous Hermes Enterprise 案例；OpenClaw Cloudflare Kitesurf 浏览器引擎（交 B）；OpenClaw Deep Research/Knowledge（交 D）；OpenAI 内嵌 Codex Core（纳入）。
- **B 组（12 条，纳入 4）**：AWS WorkSpaces for AI agents（MCP 桌面，机制未读，下期三方对比）；AWS Agent Registry skill packages（`.zip` + `SKILL.md`，S3/GitHub 同步 + SHA-256）；Foundry Skills through Shell；Browserbase Runtime 产品线（无条目）；GKE Agent Substrate（机制未取得）；Azure Agent Sandbox cluster extension 与 Pod Sandboxing（11-18 窗外）；Azure Firewall for Containers（窗内，网络边界背景）。
- **C 组（15 条，纳入 3）**：AWS API Portal 作为 WAF 发现层（纳入）；AWS Quick 3LO + TIP（纳入）；AWS Sign-In 90 天（未纳入）；Lambda MicroVM（转 B）；Azure Storage 权限用于 AI Search/Foundry IQ（机制未取得）；Foundry Toolbox（一句）。
- **D 组（14 条，深写 0）**：Milvus RLS SDK、Weaviate namespaces RF3、受约束选择式 judge 三家同周扩散（Braintrust/Phoenix/Azure Decision-1）；均属检索/评测邻域，留待专题。

### 9.6 局限

1. **Azure Updates 详情页不可读**：9 条窗内条目的机制来自 RSS `<description>`（约 250 字符截断）与同日 Foundry 博客互证；配额、区域、API 形态、价格未取得。已试入口：详情页直取、RSS。
2. **单一来源**：§0 的四条机制均来自厂商官方原文（博客/公告/文档），未取得第三方独立复核；厂商自述数字（Foundry 6 万会话、Zep 1 秒/7 秒、MCP 5B 下载、Firecrawl 21%）均标 B，未独立复现。
3. **AWS AgentCore 发布说明无日级日期**：11 月的 nested virtualization、G7 GPU、S3 挂载、`GET /ping` 只能记「11 月月级」，不计入本周；What's New RSS 仅回溯约 2 天，窗口结束后无法再复核日级归属。
4. **国内云**：Coze 3 入口未取得（JS 壳 + UA 400）；火山公告分区停在 202610，只有文档页脚时间；腾讯公告详情页 JS 外壳，仅标题+时间；阿里沙箱页无更新时间字段。均未作能力推断。
5. **日期粒度**：LangSmith 周档、Braintrust 月档、Databricks 月档、火山月档；Stagehand 4.5.0、agent-browser 0.45.0、Lambda MicroVM 均窗外 2–4 小时，只作背景。
6. **未取得机制**：Nango managed release 内容（3 入口）、Crawl4AI v0.9.6 功能条目、Agent SDK changelog、Daytona changelog、Microsoft Agent Framework 变更说明。
7. **第 20 期缺号**：直接与第 22 期对比，未补做、未扩窗。

### 9.7 来源（按厂商，正文已逐条标注）

- **Microsoft**：Foundry 博客 feed https://devblogs.microsoft.com/foundry/feed/ ｜《What's new in Microsoft Foundry | Ignite 2026》https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-ignite-2026/ ｜Hosted agents Ignite https://devblogs.microsoft.com/foundry/hosted-agents-foundry-agent-service-ignite-2026/ ｜Tools & Toolboxes https://devblogs.microsoft.com/foundry/build-once-reuse-across-your-agent-fleet-tools-and-toolboxes-in-foundry/ ｜Dev Pack https://devblogs.microsoft.com/foundry/the-foundry-dev-pack-is-here-build-foundry-agents-your-way/ ｜Browser Automation https://devblogs.microsoft.com/foundry/browser-automation-tool-ignite/ ｜VNet 五检查 https://devblogs.microsoft.com/foundry/hosted-agents-private-network-setup/ ｜Azure Updates RSS https://www.microsoft.com/releasecommunications/api/v2/azure/rss ｜Foundry MCP 治理 https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/tools/governance ｜A2A how-to https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/enable-agent-to-agent-endpoint ｜Hosted agents 概念 https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents ｜Toolbox https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/toolbox-overview ｜Agent 365 https://learn.microsoft.com/en-us/microsoft-agent-365/overview
- **AWS**：What's New feed https://aws.amazon.com/about-aws/whats-new/recent/feed/ ｜WAF AI 端点保护 https://aws.amazon.com/about-aws/whats-new/2026/11/waf-ai-endpoint-discovery-protection/ ｜API Portal https://aws.amazon.com/about-aws/whats-new/2026/11/amazon-api-gateway-announces-api-portal/ ｜IAM TIP https://aws.amazon.com/about-aws/whats-new/2026/11/aws-iam/ ｜IAM TIP 文档 https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_tip.html ｜AgentCore GovCloud https://aws.amazon.com/about-aws/whats-new/2026/11/agentcore-runtime-instances-govcloud ｜AgentCore release notes https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/release-notes.html ｜Lambda MicroVM（窗外）https://aws.amazon.com/about-aws/whats-new/2026/11/lambda-durable-microvm/ ｜安全公告 feed https://aws.amazon.com/security/security-bulletins/rss/feed/
- **Google**：Agent Gateway 博客 https://cloud.google.com/blog/products/identity-security/deploying-agents-safely-in-your-enterprise ｜GEAP release notes https://docs.cloud.google.com/gemini-enterprise-agent-platform/release-notes ｜IAM principal 标识 https://docs.cloud.google.com/iam/docs/principal-identifiers ｜ADK https://github.com/google/adk-python/releases.atom
- **OpenClaw**：releases https://github.com/openclaw/openclaw/releases.atom ｜CHANGELOG/2026.11.10.md https://raw.githubusercontent.com/openclaw/openclaw/main/CHANGELOG/2026.11.10.md
- **MCP / A2A**：spec https://modelcontextprotocol.io/specification/ ｜SEP https://modelcontextprotocol.io/seps ｜两周年博客 https://blog.modelcontextprotocol.io/posts/mcp-turns-two/ ｜Registry https://github.com/modelcontextprotocol/registry/releases.atom ｜TS SDK https://github.com/modelcontextprotocol/typescript-sdk/releases.atom ｜A2A https://github.com/a2aproject/A2A/releases.atom
- **Anthropic**：Claude Code CHANGELOG https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md ｜Platform release notes https://platform.claude.com/docs/en/release-notes/overview ｜Agent SDK https://github.com/anthropics/claude-agent-sdk-python/releases.atom
- **框架**：OpenAI Agents SDK https://github.com/openai/openai-agents-python/releases.atom ｜LangGraph https://github.com/langchain-ai/langgraph/releases.atom ｜LangSmith https://docs.langchain.com/langsmith/changelog ｜CrewAI https://github.com/crewAIInc/crewAI/releases.atom ｜pydantic-ai https://github.com/pydantic/pydantic-ai/releases.atom
- **沙箱 / 浏览器**：browser-use https://github.com/browser-use/browser-use/releases.atom ｜agent-browser https://github.com/vercel-labs/agent-browser/releases.atom ｜Browserbase https://www.browserbase.com/changelog ｜Stagehand https://github.com/browserbase/stagehand/releases.atom ｜E2B https://github.com/e2b-dev/E2B/releases.atom ｜Modal https://modal.com/docs/guide/changelog
- **工具网关 / 身份**：Composio https://docs.composio.dev/docs/changelog.md ｜Nango https://github.com/NangoHQ/nango/releases.atom ｜Arcade https://github.com/ArcadeAI/arcade-mcp/releases ｜Pipedream https://pipedream.com/docs/changelog ｜IETF OAuth https://datatracker.ietf.org/wg/oauth/documents/
- **记忆 / 观测**：OpenViking https://github.com/volcengine/OpenViking/releases.atom ｜Graphiti https://github.com/getzep/graphiti/releases.atom ｜Zep Smart Query https://www.getzep.com/blog/smart-query-api/ ｜supermemory https://github.com/supermemoryai/supermemory/commits/main.atom ｜Cognee https://github.com/topoteretes/cognee/releases.atom ｜Firecrawl https://www.firecrawl.dev/changelog ｜Crawl4AI https://github.com/unclecode/crawl4ai/releases.atom ｜OTel GenAI https://github.com/open-telemetry/semantic-conventions-genai/releases.atom ｜NeMo Guardrails https://github.com/NVIDIA/NeMo-Guardrails/releases.atom ｜Phoenix https://github.com/Arize-ai/phoenix/releases.atom ｜Langfuse https://github.com/langfuse/langfuse/releases.atom ｜Braintrust https://docs.braintrust.dev/changelog ｜Guardrails AI https://github.com/guardrails-ai/guardrails/commits/main.atom
- **国内云**：百炼发布记录 https://help.aliyun.com/zh/model-studio/application-release-notes ｜百炼沙箱 https://help.aliyun.com/zh/model-studio/managed-agents-session-operations ｜火山产品动态 https://docs.volcengine.com/docs/82379/1159177 ｜腾讯云公告 https://cloud.tencent.com/announce
