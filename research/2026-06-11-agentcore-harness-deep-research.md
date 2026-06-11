# Amazon Bedrock AgentCore Harness 深度研究

> 自顶向下、由点及面：从"托管编排层"这个新定位出发，逐能力下钻，最后收敛到趋势研判。
> 资料基准：AWS 官方文档全文（harness.html + 7 子页，2026-06-11 抓取）+ 延伸调研（GitHub 实数、AWS 官方博客、第三方评测）。

---

## TL;DR（给老板的电梯陈述）

- **一句话定位**：AgentCore harness 把过去每个团队都要自己搭的"agent harness（编排层 + 底座基础设施）"变成了**一份声明式配置**。你只声明 agent「用什么模型、能调什么工具、遵循什么指令」，AWS 把环境、计算、工具、记忆、身份、VPC 网络、可观测全部托管起来。**换模型/加工具从"重写代码"降级成"改配置"。**
- **它在 AgentCore 全景里的位置**：不是第八个并列组件，而是**架在 Runtime 之上、把其余六大组件（Memory/Gateway/Identity/Browser/Code Interpreter/Observability）按需缝合在一起的"上层抽象"**。CloudTrail 里它甚至不以独立资源类型出现，而是落到 `AWS::BedrockAgentCore::Runtime` 上——足见它是 Runtime 的"托管壳"。
- **核心范式转变**：从「编排即代码（写 loop / 选框架 / 自己接工具）」转向「编排即配置（defaults 在创建时、overrides 在调用时）」。可以在一次重新部署的时间内测完 N 个 模型×prompt×工具 组合。
- **由谁驱动**：开源框架 **Strands Agents**（AWS 自家开源，Apache-2.0，主 SDK 仓 ~6.1k stars，生态 org 合计破万 star，6 月仍在高频提交）。harness = "Strands 的托管版"。
- **状态/计费**：Public Preview（2026-04-22 起），4 个区域（俄勒冈 / 弗吉尼亚北部 / 悉尼 / 法兰克福）。**harness 本身不单独收费**，只为底层用到的 AgentCore 能力付费。
- **最有价值的判断**：如果说昨天 AgentCore 是"卖铲子"（卖 7 个可组合的托管原语），那 harness 就是**把铲子组装成了一台开箱即用的挖掘机**——AWS 把"框架层 + 编排层"也吃进了托管边界。对自建 orchestration 和 LangGraph/CrewAI 这类框架是直接的降维挤压；但 preview 期的能力边界、SigV4 不透传 per-user 身份等限制，决定了它现在更适合"快速起步 / 内部 agent / 标准 ReAct 形态"，复杂多 agent 编排短期仍需自写。

---

## 目录

1. [顶层：harness 是什么、解决什么、在全景里的位置](#1-顶层)
2. [核心范式：声明式配置 vs 编排代码](#2-核心范式)
3. [逐能力下钻（点）](#3-逐能力下钻)
   - 3.1 [配置与模型](#31-配置与模型)
   - 3.2 [接工具](#32-接工具)
   - 3.3 [记忆与文件系统](#33-记忆与文件系统)
   - 3.4 [环境与 Skills](#34-环境与-skills)
   - 3.5 [可观测与成本控制](#35-可观测与成本控制)
   - 3.6 [安全（重点）](#36-安全)
   - 3.7 [Get started：可落地代码骨架](#37-get-started)
4. [Strands Agents 关系（延伸调研）](#4-strands-agents)
5. [横向定位（面）：harness vs 自写 vs LangGraph/CrewAI](#5-横向定位)
6. [趋势研判](#6-趋势研判)
7. [信息源清单](#7-信息源清单)

---

## 1. 顶层

### 1.1 什么是 "agent harness"

官方给了一个很硬核的定义：**每个 agent 都有一个编排层（orchestration layer）**——那个 loop：调模型 → 决定调哪个工具 → 把结果喂回去 → 管理上下文窗口 → 处理失败。而跑这个 loop 需要底下一整套基础设施：托管 agent 的计算、安全执行代码的沙箱、连工具的安全通道、持久存储、记忆、身份、可观测。**这一整套基础设施合起来，就叫 agent harness——让 agent 真正能跑起来的那个系统。**

痛点提炼（AWS 官方博客原话佐证）：在此之前，每个团队都得**从零搭这套 harness**——选框架、写编排代码、接工具和记忆、配认证、开环境。"在 agent 处理第一个真实任务之前，先花掉好几天做管道工"。AWS 调研过的多数团队在跑第一个真实测试前都要在这套基础设施上耗费数天。

### 1.2 harness 怎么解决

**managed agent harness** 用一份简单配置替换掉这个前期搭建。你声明 agent 做什么（用哪个模型、能调哪些工具、遵循什么指令），AgentCore 负责其余一切：环境、计算、工具、记忆、身份、VPC 网络、可观测。**试不同模型或加新工具，是一次配置变更，不是一次代码重写。**

Forbes 的概括很到位：AWS 把 AI agent 的搭建砍到了 **3 个 API 调用**（create → deploy/get → invoke），让开发者用配置而非编排代码就能立起一个能跑的自治 agent。

### 1.3 在 AgentCore 全景里的位置

AgentCore 七大组件：Runtime / Memory / Gateway / Identity / Browser / Code Interpreter / Observability。**harness 不是第八个并列原语，而是一个"上层抽象（managed abstraction）"**，它在一次调用里按你的配置把这些原语缝合起来：

- 计算与隔离 ← **Runtime**（每 session 一个 Firecracker microVM）
- 工具 ← **Gateway / MCP / Browser / Code Interpreter**
- 记忆 ← **Memory**（短期 + 长期策略）
- 身份与凭证 ← **Identity**（token vault、Inbound OAuth、API key 凭证）
- 监控 ← **Observability**（CloudWatch / X-Ray）
- 工具级访问控制 ← **Policy**（Gateway 上的 Cedar 策略）

**关键证据**：官方"CloudTrail"一节明说——harness 资源在 CloudTrail 里不以 harness 专属类型出现，而是落在 `AWS::BedrockAgentCore::Runtime` 资源类型下；数据面操作记录为 `InvokeAgentRuntime` / `InvokeAgentRuntimeCommand`。一句话：**harness 是 Runtime 之上的托管壳**，控制面是 `*Harness` API，数据面落到 Runtime。这也解释了为什么 IAM 要"双权限"（见 §3.6）。

### 1.4 与"裸用 Runtime + 自写 orchestration"的区别

裸用 Runtime（AgentCore 自 2025-10 GA 起的玩法）：你仍要**自己写 agent 代码**——选框架（Strands/LangGraph/自定义）、实现编排 loop、把 agent 打包成 Docker 镜像或代码包、上传到 Runtime，AWS 把容器托管成 serverless 端点。**loop 逻辑仍归你维护、更新、调试。**

harness：你**不部署 agent 代码**，loop 由 AWS（用 Strands）跑。你只 `invoke_harness(model, tools, systemPrompt, messages)`。这就是"管道工作量"被彻底吸收的那一刀。

### 1.5 状态 / 区域 / 计费

- **Public Preview**，起始 2026-04-22。
- 4 区域：US West (Oregon)、US East (N. Virginia)、Asia Pacific (Sydney)、Europe (Frankfurt)。
- **无单独 harness 费用**；只为底层用到的 AgentCore 能力付费（Runtime 计算、Memory、Browser、Code Interpreter、模型 token 等）。CLI 和 Skills 也不额外收费。
- 默认模型：不指定时用 **Anthropic Claude Sonnet 4.6 on Bedrock**（`global.anthropic.claude-sonnet-4-6`）。

---

## 2. 核心范式

### 2.1 「defaults at creation, overrides at invocation」

这是 config-based 模型的核心：**创建时设默认值，调用时按需覆盖。** harness 资源本身不变，单次调用用 override。官方原话：「你能在重新部署一次的时间里，测完 N 个 模型/prompt/工具 组合。」

可在 invoke 时覆盖的字段：`--model-id`、`--tools`、`--system-prompt`、`--max-iterations`、`--max-tokens`、`--harness-timeout`、`--skills`、`--allowed-tools`、`--actor-id`。要永久改默认，编辑 `app/<name>/harness.json` 后 `agentcore deploy`，或用 `update-harness`。

### 2.2 范式转变的本质

传统「编排即代码」：模型、工具、记忆、身份这些**编织进代码**，换任何一个都要改代码 → 测试 → 重新打包 → 重新部署。

harness「编排即配置」：这些都变成**声明式参数**，且支持三个层次的灵活度——

1. **创建期默认**（harness.json / create-harness）：团队级基线。
2. **调用期覆盖**（invoke_harness 入参）：单次实验，资源不变。
3. **会话中切换**（同一 session 跨 turn 换 provider）：连模型 provider 都能中途换且不丢上下文。

意义：把 agent 开发从「软件工程问题」拉回到「配置 + 评测问题」。这对快速迭代 prompt/model 选型是质变，但也意味着**复杂、非标准的编排逻辑（条件分支、多 agent 协作、自定义 loop 控制）受这套声明式框架表达力上限约束**——这是 harness 的隐含边界（见 §5）。

---

## 3. 逐能力下钻

### 3.1 配置与模型

**多 provider**：可用 Amazon Bedrock、OpenAI、Google Gemini，或通过 **LiteLLM** 接任何它支持的 provider（含 OpenAI 兼容端点）。

**中途换 provider 不丢上下文**：在同一 session 的不同 turn 之间切换 provider，对话继续、上下文延续。这是 harness 一个很硬的差异化点——把“模型选择”从架构决策降级为运行时参数。

**三种模型配置块**：

- `bedrockModelConfig`：`apiFormat` 可选 `converse_stream`（默认，走 `bedrock-runtime`）、`responses`、`chat_completions`（后两者走 `bedrock-mantle` 端点，支持不同的模型/能力集）。
- `openAiModelConfig`：`apiFormat` 可选 `responses`（默认）、`chat_completions`；需 `apiKeyArn`。
- `liteLlmModelConfig`：`modelId` 用 provider 前缀（如 `anthropic/claude-sonnet-4-6`、`openai/gpt-5.4`）；支持 `apiKeyArn`、`apiBase`（自定义 OpenAI 兼容网关）、`additionalParams`、以及 `maxTokens`/`temperature`/`topP`。`bedrock/` 前缀模型用执行角色权限、无需 API key。

**第三方密钥不进 agent 代码**：OpenAI/Gemini 等 key 存进 **AgentCore Identity 的 token vault**（API key credential provider），harness 调用时按 ARN 拉取，agent 代码永远看不到原始凭证。

**三种模型配置对比：**

| 配置块 | 典型场景 | 是否需 API key | apiFormat 默认 |
| --- | --- | --- | --- |
| `bedrockModelConfig` | Bedrock 上的 Claude/Nova 等 | 否（用执行角色） | `converse_stream` |
| `openAiModelConfig` | 直连 OpenAI | 是（`apiKeyArn`） | `responses` |
| `liteLlmModelConfig` | 其它 provider / 自托管 / OpenAI 兼容 | 视 provider 而定 | 由 LiteLLM 决定 |

### 3.2 接工具

工具也是**声明式**：你列出 agent 能调什么，AgentCore 负责调用、凭证、结果。支持**五种工具类型** + 内置 `shell` 和 `file_operations`：

1. **MCP servers**：按 URL 连任意远程 Model Context Protocol 端点，简单场景无需 Gateway。
2. **AgentCore Gateway**：受治理的连接（inbound/outbound auth、访问控制、Cedar 策略）。引用一个 gateway ARN，该网关上配的所有工具都可用。
3. **AgentCore Browser**：托管网页浏览/自动化。
4. **AgentCore Code Interpreter**：沙箱化 Python/JS/TS 代码执行。
5. **Inline functions**：工具 schema 在**客户端**执行（不在 harness VM 上）。agent 调用时 harness 暂停、把调用返回给你的代码，你决定怎么做再把结果送回——这是 **human-in-the-loop 审批**和自定义集成的模式。

**内置默认工具**：每个 session 都有 `shell`（执行 bash）和 `file_operations`（看/建/改文件），除非用 `allowedTools` 限制。

**`allowedTools` 匹配模式：**

| Pattern | 示例 | 匹配 |
| --- | --- | --- |
| `*` | `"*"` | 所有工具 |
| Plain name | `"shell"` | 按名字的 builtin |
| Builtin glob | `"file_*"` | `file_operations`、`file_read` |
| `@builtin` | `"@builtin"` | 所有 builtin |
| `@builtin/name` | `"@builtin/shell"` | 指定 builtin |
| `@server` | `"@git"` | 某 MCP server 全部工具 |
| `@server/tool` | `"@git/git_status"` | 指定 MCP 工具 |
| `@server/glob` | `"@git/read_*"` | server 内 glob |
| `@*/tool` | `"@*-mcp/status"` | 跨 server glob |

**⚠️ 一个关键安全陷阱**：`allowedTools` 只约束 `InvokeHarness` 期间 LLM 的工具选择，**不影响 `InvokeAgentRuntimeCommand`**——后者是独立 API、有独立 IAM action（`bedrock-agentcore:InvokeAgentRuntimeCommand`），不经过 LLM 直接执行命令。要彻底禁止直接命令执行，**不要在 IAM 策略里授予该 action**。

**凭证引用**：MCP header 里可用 `${arn:...}` 语法引用 Identity token vault 里的凭证，调用时解析为真实 key；OAuth 保护的工具走 Gateway + Identity 而非裸 header。

### 3.3 记忆与文件系统

harness 在**两个层面**持久化状态：对话状态在 AgentCore Memory，文件状态在 agent 的文件系统。

**Memory（对话状态）**：给 harness 挂一个 AgentCore Memory 实例，每次调用自动按 session ID（外加 actor ID，如果提供）保存对话。后续用同一 session ID 调用时，在 agent 推理前从 Memory 加载历史——**即使底层 microVM session 已过期，也记得之前发生了什么**。你不用自己回传历史消息，只发新消息即可。

- **短期记忆**：捕获 session 内的原始事件（消息、工具调用）。
- **长期记忆**：通过可配置策略（semantic / summarization / user preference / episodic / custom）抽取持久知识，在后续 session 里经语义检索取回。
- **Actor ID**：标识与 agent 交互的实体（用户/另一个 agent/系统）。Memory 事件按 `actorId + sessionId` 隔离，每个 actor 有独立记忆命名空间；长期检索用 actorId 作命名空间路径模板变量（如 `/summary/{actorId}/{sessionId}/`）。

**长期记忆零配置取回**：挂上带活跃策略的 Memory 实例后，harness 自动从这些策略**派生**检索配置（默认 `topK=10`, `relevanceScore=0.2`），开箱即用、无需手写 `retrievalConfig`。显式提供 `retrievalConfig` 则你的值优先、不再自动派生。⚠️ 创建 harness 后若增删 Memory 策略，要调 `UpdateHarness` 刷新检索配置，否则继续用旧配置。

**Filesystem（文件状态）**：启用后每个 session 跑在带工作文件系统的 Firecracker microVM 里，session 期间写的文件在该 session 生命周期内持久。要跨 session 持久，挂 S3 等存储。**三种文件系统类型：**

| 类型 | 说明 | 是否需 VPC | 共享范围 |
| --- | --- | --- | --- |
| Session storage | 服务托管、按 session 持久，跨 stop/resume 保留（同 `runtimeSessionId`） | 否 | 单 session |
| Amazon EFS access point | 自带 EFS，挂在 `/mnt` 下 | 是 | 跨 session/agent 共享 |
| Amazon S3 Files access point | 自带 S3 Files，与 S3 桶双向同步 | 是 | 跨 session + S3 桶 |

⚠️ `UpdateHarness` 会**整体替换** `filesystemConfigurations` 列表。要给已有文件系统的 harness 加新挂载，先 `GetHarness` 再把"现有 + 新增"完整列表一起发。

### 3.4 环境与 Skills

**直接在环境上跑命令（不经模型、不耗 token）**：`InvokeAgentRuntimeCommand` 给你对 harness microVM 的直接 shell 访问——确定性命令执行，无模型推理、无 token 成本、无歧义。用途：跑确定性前/后置脚本、调用前准备环境（clone repo / 装依赖 / 拷输入文件）、对 agent 产出做后处理（跑测试 / commit & push / 提取构建产物）、开发期巡检 VM（`ls` `cat` `env` `python --version`）。TUI 里按 `!` 进 exec 模式。

⚠️ **命令以 root（uid 0）运行**——类比你自己 EC2 上的 root；IAM 权限才是访问闸门，而非 VM 内权限级别。Dockerfile 的 `USER` 指令只作用于 agent 进程；`InvokeAgentRuntimeCommand` 为运维目的以更高权限运行（类似 `docker exec` 默认 root）。

**自定义环境（容器镜像）**：基础环境含 Python + bash。需要更多时，把源码/依赖/运行时/工具打进容器镜像、推到 ECR、在 harness 上引用。⚠️ 镜像必须为 **`linux/arm64`** 平台构建。harness 会**覆盖你容器的 `ENTRYPOINT`/`CMD`** 以保持其作为环境运行——你装的软件、文件系统、环境变量对 agent 可用，但你容器的启动命令**不会执行**；需要后台进程（如 dev server）就在 session 开始后用 `InvokeAgentRuntimeCommand` 起。

**环境变量**：`environmentVariables` 传给运行时容器，对 agent 和自定义容器都可用。

**Agent Skills**：来自 Strands 的机制——markdown + 脚本的捆绑包，按需给 agent 领域知识（如怎么处理 Excel、怎么用某 API）。`skills` 列表每项要么是环境里已有 skill 的 `path`，要么是 `s3`/`git` 源（harness 在调用时帮你拉取）。可设为 harness 默认或按调用覆盖。

- **S3 源**：`s3.uri` 指向 skill 目录；执行角色需 `s3:GetObject` + `s3:ListBucket`；无需公网。
- **Git over HTTPS**：`git.url` + `git.path`（拉子目录单个 skill）；私库用 `git.auth.credentialArn` 指向存 PAT 的 Identity 凭证；需公网出口。
- 约束：每个源必须含 `SKILL.md`；S3 skill ≤ 1 GB；Git 拉取须 60 秒内完成，否则调用失败并报描述性错误。harness 在 session 首次调用时拉取、新 session 重新拉取（始终拿到最新版）。
- 进环境的三种方式：① **烤进容器镜像**（生产推荐，如 `.agents/skills/xlsx`）② **session 启动时装**（`InvokeAgentRuntimeCommand` 跑 `npx @anthropic-ai/agent-skills add ...`）③ 用 `--skill-path` 持久到 harness。

### 3.5 可观测与成本控制

**可观测（零配置）**：每次 harness 调用自动经 AgentCore Observability 生成 traces/logs/metrics 到 CloudWatch。模型调用、工具调用、记忆操作、shell 命令——每步都带时序和 payload 细节。首次调用即有 trace。CLI：`agentcore logs --harness X --since 1h --level error`、`agentcore traces list/get`。⚠️ 前提：账号级一次性**启用 CloudWatch Transaction Search**。

**CloudTrail**：管理事件（控制面）：`CreateHarness`/`UpdateHarness`/`DeleteHarness`/`GetHarness`/`ListHarnesses`；数据事件（数据面）：`InvokeAgentRuntime`/`InvokeAgentRuntimeCommand`。所有事件 `resources.type` = `AWS::BedrockAgentCore::Runtime`（再次印证 harness 是 Runtime 的托管壳）。

**成本/资源硬上限：**

| 参数 | 含义 | 默认 |
| --- | --- | --- |
| `maxIterations` | 每次调用的推理/动作循环数 | 75 |
| `timeoutSeconds` | 单次调用墙钟超时 | 3600 |
| `maxTokens` | 每次调用 token 预算 | N/A |
| `idleRuntimeSessionTimeout` | 空闲 microVM 保温时长 | 900 |
| `maxLifetime` | microVM session 最大寿命 | 28800 |

截断策略 `--truncation-strategy`：`sliding_window` 或 `summarization`。限制可在 create 设默认、invoke 单次覆盖。因 harness 背靠 Runtime，还受 Runtime 服务配额约束。

**Tags**：用于成本分摊和访问控制，透传到部署的 CloudFormation 资源。

### 3.6 安全（重点）

harness 把 AgentCore 全套安全原语用配置接好。五大支柱：

1. **隔离执行**：每 session 独立 Firecracker microVM，无共享状态、无共享文件系统。
2. **IAM 执行角色**：harness 假设你拥有的 IAM 角色（可含 Bedrock/ECR/CloudWatch 及它触及的 AgentCore 原语）。信任策略须允许 `bedrock-agentcore.amazonaws.com` 假设。
3. **IAM 双权限模型**（很关键）：harness API 需要**同时**在 harness 资源和底层 Runtime 资源上有权限。

**API ↔ IAM 双权限映射：**

| API | 所需 IAM actions |
| --- | --- |
| `InvokeHarness` | `bedrock-agentcore:InvokeHarness` + `InvokeAgentRuntime` |
| `InvokeAgentRuntimeCommand` | `InvokeAgentRuntimeCommand` + `InvokeAgentRuntime` |
| `CreateHarness` | `CreateHarness` + `CreateAgentRuntime` |
| `UpdateHarness` | `UpdateHarness` + `UpdateAgentRuntime` |
| `DeleteHarness` | `DeleteHarness` + `DeleteAgentRuntime` |
| `GetHarness` | `GetHarness` |
| `ListHarnesses` | `ListHarnesses` |

4. **Inbound OAuth**：配 JWT 的 harness 要求调用方先出示合法 JWT（由配置的 IdP 签发）。Identity 把终端用户身份串到 agent，下游工具能用**用户范围**的凭证而非共享服务账号调 API。
5. **VPC**：把 harness session 接进你的 VPC 以私网访问内部资源；6. **Gateway 上的 Cedar 策略**：逐调用门禁（谁能调哪个工具、什么条件、带什么参数）。

**⚠️ SigV4 不透传 per-user 身份（preview 期重要限制）**：当调用方用 SigV4（AWS IAM）认证时，harness **不**把 per-user 身份透传到下游工具调用——即 Identity Token Vault 的用户范围 OAuth、on-behalf-of token 交换等**只在 Bearer JWT（OAuth inbound 路径）下可用**。需要 per-user 凭证范围就**必须配 inbound OAuth**。SigV4 的 per-user 支持"计划在未来版本提供"。

**⚠️ VPC 模式的强制网络要求**：harness 每次 session 开始时从 **Amazon ECR Public** 拉应用容器。VPC 模式下你的 VPC 必须能出站访问 `public.ecr.aws`；ECR Public 不支持 VPC 端点，所以**必须有 NAT 网关 + 到 IGW 的路由**，否则 session 因镜像拉取超时而启动失败。

**执行角色 sample policy 覆盖的 Sid**（CLI 脚手架会自动建）：`BedrockModelInvocation`、`EcrPublicTokenAccess`、`StsForEcrPublicPull`、`XRayTracingAccess`、`CloudWatchLogs*`、`CloudWatchMetricsPublish`、`AgentCoreWorkloadIdentity`、`AgentCoreBrowserDefault`、`AgentCoreCodeInterpreterDefault`。可选追加策略：私有 ECR、Memory、自定义 Browser/Code Interpreter、Gateway(SigV4)、Skill 的 S3/Git、API key 凭证、OAuth2 凭证。生产建议把 `Resource` 收窄到具体 ARN（用 inference profile）而非 `"*"`。

### 3.7 Get started

**两条路径**：AgentCore CLI（`npm install -g @aws/agentcore@preview`，需 Node.js 20+）最快；SDK/boto3（Python 3.10+ + 执行角色）用于程序化。`runtimeSessionId` 至少 33 字符（用 UUID），同 session ID 续聊。

**CLI 三步骨架：**

```bash
# 1. 创建（非交互，带 flags）
agentcore create --name myresearchagent --model-provider bedrock
# 2. 部署
agentcore deploy
# 3. 调用（流式返回；复用同一 session-id 续聊）
agentcore invoke --harness myresearchagent \
  --session-id "$(uuidgen)" \
  "Research three tropical vacation options under \$3k, within five hours of NYC."
```

`agentcore create` 不带 flag 进交互向导（项目名 → 选 Harness 类型 → 选 model provider → 选环境 → 配 memory → 高级设置 → 确认）。`agentcore dev` 起本地 dev server + 浏览器 agent inspector（会先把资源部署到 AWS）。`agentcore status` 看项目状态。

**SDK/boto3 骨架：**

```python
import boto3
client = boto3.client("bedrock-agentcore", region_name="us-west-2")
response = client.invoke_harness(
    harnessArn="arn:aws:bedrock-agentcore:us-west-2:123456789012:harness/MyHarness-XyZ123",
    runtimeSessionId="1234abcd-12ab-34cd-56ef-1234567890ab",  # ≥33 字符
    messages=[{"role": "user",
               "content": [{"text": "Research three tropical vacation options under $3k."}]}],
)
for event in response["stream"]:
    if "contentBlockDelta" in event:
        delta = event["contentBlockDelta"].get("delta", {})
        if "text" in delta:
            print(delta["text"], end="", flush=True)
    elif "runtimeClientError" in event:
        print(f"\nError: {event['runtimeClientError']['message']}")
```

**控制面**：`create-harness --harness-name --execution-role-arn` → 轮询 `get-harness` 到 `"status":"READY"` → 拿 `arn`。**流式事件类型**：`messageStart` / `contentBlockStart` / `contentBlockDelta` / `contentBlockStop` / `messageStop` / `metadata` / `runtimeClientError`。**`stopReason`**：`end_turn` / `tool_use` / `max_tokens` / `max_iterations_exceeded` / `timeout_exceeded` / `max_output_tokens_exceeded`。

**API 集合**：`CreateHarness`/`GetHarness`/`UpdateHarness`/`DeleteHarness`/`ListHarnesses`（控制面）+ `InvokeHarness`/`InvokeAgentRuntimeCommand`（数据面）。

---

## 4. Strands Agents

### 4.1 harness "由 Strands 驱动"意味着什么

官方明说：harness is powered by **Strands Agents**, the open-source agent framework from AWS。换言之，harness 不是 AWS 闭门造的黑盒编排引擎，而是**把自家开源框架 Strands 托管化**——你在 harness 里看到的"声明 model + tools + instructions、自动跑 ReAct loop、接 MCP/记忆/可观测"这套，本质就是 Strands 的能力模型。Agent Skills 机制的文档链接也直接指向 `strandsagents.com`，进一步印证。

战略含义：①AWS 对 harness 的演进有完整掌控力（自家框架）；②本地用 Strands 写的 agent 与 harness 上的行为高度同构，**"本地 Strands 原型 → harness 托管"迁移路径平滑**；③开源框架是"试用入口"，harness 是"托管变现"，二者形成漏斗。

### 4.2 Strands GitHub 活跃度（实数，2026-06-11 查 GitHub API）

| 仓库 | stars | forks | 最近 push | 说明 |
| --- | --- | --- | --- | --- |
| strands-agents/harness-sdk（主 SDK，Python） | 6,099 | 874 | 2026-06-10 | Apache-2.0；"model-driven approach to building AI agents in just a few lines of code" |
| strands-agents/tools | 1,086 | 308 | 2026-06-08 | 工具集 |
| strands-agents/agent-sop | 999 | 93 | 2026-06-04 | — |
| strands-agents/samples | 783 | 413 | 2026-06-04 | 示例 |
| strands-agents/sdk-typescript | 700 | 102 | 2026-06-03 | TS SDK |
| strands-agents/agent-builder | 420 | 88 | 2026-05-12 | — |
| strands-agents/mcp-server | 285 | 70 | 2026-05-20 | — |
| strands-agents/docs | 197 | 225 | 2026-06-02 | — |
| strands-agents/evals | 136 | 37 | 2026-06-10 | 评测 |

判断：主 SDK 仓 ~6.1k stars、648 open issues、6 月仍在每日级提交，整个 org 多仓合计破万 star——**对一个 2025-05 才建仓的 AWS 系开源框架，这是健康且高速的活跃度**，但绝对量级仍**显著小于 LangChain/LangGraph（数万~十万级 star）**。Strands 的护城河不在社区规模，而在**与 AWS 托管栈（AgentCore/Bedrock）的原生耦合**。topics 里同时挂着 anthropic/openai/litellm/ollama/llama，印证其 model-agnostic 定位。

> 注：主 SDK 仓名为 `harness-sdk` 而非常见的 `sdk-python`，与 AgentCore harness 同名，暗示 Strands 的"harness/agent loop"概念与 AgentCore harness 是同根设计。

---

## 5. 横向定位

### 5.1 三种做法对比

**harness vs 自写 orchestration vs 第三方框架托管：**

| 维度 | 裸 Bedrock 端点 | AgentCore Runtime + 自写代码 | AgentCore harness |
| --- | --- | --- | --- |
| 编排 loop | 全自写 | 自写（Strands/LangGraph/自定义） | AWS 托管（Strands 驱动） |
| 部署物 | 自建一切 | Docker 镜像/代码包上传 | 无代码，3 个 API 调用 |
| 换模型 | 改代码 | 改代码 | 改配置（甚至 session 中途切） |
| 记忆/身份/可观测 | 自建 | 用 AgentCore 原语（自接） | 配置即接好 |
| 灵活度上限 | 无限 | 无限 | 受声明式框架表达力约束 |
| 适合 | 极致定制 | 复杂/多 agent/自定义 loop | 快速起步、标准 ReAct、内部 agent |

### 5.2 AWS 把 orchestration 也吃掉，对框架层意味着什么

AWS 官方博客自己点名："working with frameworks you already use, including **LangGraph, LlamaIndex, CrewAI, Strands Agents**"——即 AgentCore（Runtime 层）一直定位"框架中立的托管底座"，欢迎你带任何框架来跑。但 harness 这一步是**质的不同**：它不再"托管你的框架代码"，而是**用 AWS 自家框架（Strands）把编排层本身替换掉**。

对 LangGraph/CrewAI 等：
- **不是直接替换**——它们仍能作为"自带代码"跑在 Runtime 上（AgentCore 仍支持），复杂图编排、多 agent 协作仍是它们的主场。
- **但是入口挤压**——对"标准 ReAct + 接几个工具 + 要记忆和可观测"这类**最常见的 80% 场景**，harness 用"零代码 + 零运维 + 不额外收费"直接抢走了新手和快速原型的默认选择。框架们被推向"复杂编排"的窄缝。

第三方评测（awsfundamentals）一针见血：AgentCore 之前"你仍要自己写 agent 代码、打包成镜像、自己维护 loop 逻辑"；harness 之后"你不部署 agent 代码——调 invoke 传 model/instructions/tools，AWS 替你跑 loop"。这是从"管基础设施"到"管编排逻辑"的边界再外推一格。

---

## 6. 趋势研判

**1) harness 是"把铲子升级成挖掘机"。** 若昨天的判断是"AgentCore = 卖铲子"（7 个可组合托管原语，你自己拼），那 harness 就是 AWS 把这些铲子**预先组装成一台开箱即用的挖掘机**：你不用懂铲子怎么拼，配一下就能开挖。卖点从"我给你最好的零件"升级到"我给你整机、还不另收整机费、只收零件用量"——**用 harness 不另收费、只为底层 AgentCore 用量付费**，这正是经典的"抽象层免费、底层资源变现"打法，目的是把更多负载吸进 AgentCore 计费底座。

**2) 范式信号：编排正在从"代码"沉为"配置 + 评测"。** harness 的"defaults/overrides/mid-session switch"三层灵活度，把模型选型、工具组合、prompt 调优都变成运行时参数。这对应一个更大趋势——**agent 开发的价值重心从"写 loop"上移到"配能力 + 做评测 + 控成本"**。`evals` 仓的存在和成本硬上限的内置都是佐证。

**3) 边界清醒：preview 期不要 all-in 关键路径。** 限制清单：仅 4 区域 preview；SigV4 不透传 per-user 身份（要 per-user 凭证就被迫上 OAuth）；VPC 模式强依赖 NAT + ECR Public 出口；容器须 arm64；`InvokeAgentRuntimeCommand` 绕过 `allowedTools` 的安全陷阱需主动在 IAM 里堵；声明式框架对复杂/多 agent 编排表达力有上限；API/console 在 GA 前仍可能变。

**4) 该用 / 不该用的边界：**
- **该用**：快速验证 agent 想法、内部工具型 agent、标准 ReAct + 工具 + 记忆、想低成本试多模型/多 prompt、不想养 orchestration 运维的小团队。
- **暂缓**：强 per-user 合规且只能用 SigV4、需要复杂自定义编排/多 agent 图、生产关键路径要确定性 SLA、对 vendor lock-in 敏感（harness = 深度绑定 AWS + Strands）。

**5) 给老板的一句话判断：**
> **harness 是 AWS 把"agent 编排层"也纳入托管收费底座的关键一步——用"零代码起步 + 不另收费"换"把你的 agent 负载和数据彻底沉进 AgentCore"；对 80% 的标准 agent 场景这是降维好用的加速器，但 preview 期的身份/网络/编排表达力限制 + 深度 lock-in，决定了现在适合"快速起步与内部 agent"，复杂编排和强合规关键路径仍应观望或自持。**

---

## 7. 信息源清单

**一手（官方文档全文，已落盘精读）**
- AgentCore harness 主页 + 7 子页：`harness.html` / `harness-get-started` / `harness-config-and-models` / `harness-tools` / `harness-memory` / `harness-environment` / `harness-operations` / `harness-security`（https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/harness.html ）
- AWS 官方博客：Get to your first working agent in minutes: Announcing new features in Amazon Bedrock AgentCore（2026-05-07，aws.amazon.com/blogs/machine-learning/...）
- AWS What's New：AgentCore new features to build agents faster（2026-04-22）

**GitHub 实数（2026-06-11 查 GitHub API）**
- strands-agents org 各仓 stars/forks/push（主 SDK `harness-sdk` 6,099★ 等，见 §4.2）

**第三方/媒体**
- awsfundamentals.com：AWS AgentCore Harness — Building Agents on AWS Just Got Easier（含 Bedrock/AgentCore/Strands/harness 关系梳理与 before/after 对比；preview 起 2026-04-22）
- Forbes（Janakiram MSV，2026-04-26）：AWS Cuts AI Agent Setup To 3 API Calls In AgentCore Update

> 说明：资料包未明确给出的延伸结论（如 GitHub 量级、媒体观点）均已标注来源；关键 API 名、配置字段、默认值、限制条件均忠于官方文档全文，未编造。
