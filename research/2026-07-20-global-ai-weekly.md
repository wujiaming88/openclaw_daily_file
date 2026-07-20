# 全球 AI 动态周报 · 第 8 期（2026-07-13~07-19）

> **覆盖区间**：2026-07-13（周一）00:00 ~ 2026-07-19（周日）24:00（上海时区）  
> **覆盖范围**：38 个研究对象 · 6 个赛道 · 80+ 一手/官方来源  
> **四维门控自检**：覆盖 38/38（100%），有动态 23 个；原文抽查 5/5 通过；洞察与三主线到位；关键数据均附来源 URL/日期，重大数据优先官方源并交叉验证。

## 本周一句话

> 本周最大主线不是单个模型刷新榜单，而是 **AI 从“更聪明”转向“更能在真实组织里长期干活”**：Kimi K3 与 Mistral 扩大开放/专业模型供给，OpenAI、Dify、Claude Code、OpenCode 补安全与执行地基，Sierra/Glean/Harvey 把身份、上下文和结果计费推到台前，NVIDIA/AWS/Azure 则把算力、推理、agent runtime 打包成平台能力。

## 🔥 本周 TOP 5

### 1. 月之暗面：Kimi K3 开放 3T 级长程工作模型 ｜ 7-17

- 本周动态：月之暗面本周发布 Kimi K3，虽然本组对象名沿用“Kimi K2”，但本期真实公开动态已经切换到新一代 K3。Kimi 官方技术博客称，Kimi K3 是其“most capable model”，拥有 2.8T 参数，基于 Kimi Delta Attention（KDA）和 Attention Residuals，原生支持视觉能力和 1-million-token context window，并称为全球首个 open 3T-class model，面向 long-horizon coding、knowledge work 和 reasoning。架构上，K3 结合 Stable LatentMoE 后在 896 个专家中激活 16 个，整体 scaling efficiency 相比 Kimi K2 提升约 2.5×；训练和推理侧引入 quantization-aware training、MXFP4 weights、MXFP8 activations，并建议在 64+ accelerators supernode 上部署。能力案例非常偏 Agent：24 小时 kernel optimization、从零构建 MiniTriton GPU compiler、48 小时自主芯片设计、复现 I–Love–Q universal relations 时阅读交叉验证 20+ papers、评估 300+ equations of state、生成 3,000+ lines Python code。产品可用性上，K3 已在 Kimi.com、Kimi Work、Kimi Code、Kimi API 可用；完整模型权重将于 2026-07-27 前发布。官方 API 文档进一步确认 K3 始终开启思考模式，支持 reasoning_effort=low/high/max，支持视觉输入、结构化输出、Partial Mode、tool_choice、动态加载工具、1M 上下文自动缓存等。
- 关键数据：2.8T 参数、1M token 上下文、896 experts / activate 16、scaling efficiency 相比 K2 约 2.5×、完整权重 2026-07-27 前发布、Kimi API 定价 cache-hit input $0.30/MTok、cache-miss input $3.00/MTok、output $15.00/MTok（[来源](https://www.kimi.com/blog/kimi-k3，页面素材与内容为) 2026-07-17 发布周；[来源](https://platform.kimi.com/docs/guide/kimi-k3-quickstart.md）；阿里云百炼亦记录) `kimi/kimi-k3` 于 2026-07-17 上架并描述 2.8 万亿参数、100 万 token 上下文（[来源](https://help.aliyun.com/zh/model-studio/newly-released-models)）。
- 原文链接：[来源](https://www.kimi.com/blog/kimi-k3；https://platform.kimi.com/docs/guide/kimi-k3-quickstart.md；https://platform.kimi.com/docs/llms.txt；https://help.aliyun.com/zh/model-studio/newly-released-models)
- 影响判断：Kimi K3 是本周中国模型公司最强信号之一：开源规模、长上下文、Agent coding、知识工作和视觉能力被打包成统一旗舰。其路线不是只追通用榜单，而是把“长程任务 + 工具/终端 + 多模态反馈 + 工作产物生成”作为核心评测场，直接对标 Claude Code/Codex 式 agentic workflow。

↳ **为什么重要**：Kimi K3 把 2.8T 参数、1M 上下文、视觉、长程编程/知识工作、开放权重计划集中到一个旗舰事件里，是本周最强模型发布信号。

### 2. Mistral：专业模型矩阵与 Vibe agent 同周推进 ｜ 7月中旬

- 本周动态：本周 Mistral 在大模型基座与专业模型方向非常活跃，重点是 Mistral Medium 3.5、Vibe remote agents、Leanstral 1.5、Robostral Navigate 与 OCR 4。官方《Remote agents in Vibe. Powered by Mistral Medium 3.5》披露，Mistral Medium 3.5 进入 public preview，是 dense 128B 模型、256k context window，合并 instruction-following、reasoning、coding 于一组权重，支持 self-hosting 至少四张 GPU，reasoning effort 可按请求配置；其 SWE-Bench Verified 得分 77.6%，τ³-Telecom 91.4，并成为 Le Chat 默认模型、替换 Vibe CLI 中的 Devstral 2，API 价格为 input $1.5/M、output $7.5/M，开源权重以 modified MIT license 发布。Leanstral 1.5 则是 Apache-2.0、119B total/6B active 的 Lean 4 formal verification 模型，miniF2F validation/test 100%，PutnamBench 587/672，FATE-H 87、FATE-X 34，FLTEval pass@8 从 31.9 提至 43.2，并在 57 个仓库中发现 47 个 violated properties、11 个真实 bug、5 个此前 GitHub 未报告。Robostral Navigate 是 8B embodied navigation model，仅用单 RGB camera，在 R2R-CE validation unseen 达 76.6%，比最佳单摄方案高 9.7 点、比最佳 depth/multi-camera 系统高 4.5 点。OCR 4 支持 170 种语言、bounding boxes、block classification、inline confidence，OlmOCRBench 85.20，API $4/千页、Batch API $2/千页。Mistral 本周呈现“旗舰通用 + 垂直专业 + agent 产品”同步推进。
- 关键数据：Mistral Medium 3.5：128B dense、256k context、SWE-Bench Verified 77.6%、τ³-Telecom 91.4、$1.5/M input、$7.5/M output（[来源](https://mistral.ai/news/vibe-remote-agents-mistral-medium-3-5/）；Leanstral) 1.5：119B total/6B active、Apache-2.0、miniF2F 100%、PutnamBench 587/672、FATE-H 87、FATE-X 34、FLTEval pass@8 43.2（[来源](https://mistral.ai/news/leanstral-1-5/）；Robostral) Navigate：8B、R2R-CE validation unseen 76.6%、seen 79.4%、2.4M trajectories/350k scenes、token reduction 22×、RL +3.2%（[来源](https://mistral.ai/news/robostral-navigate/）；OCR) 4：170 languages、OlmOCRBench 85.20、$4/1,000 pages、Batch $2/1,000 pages（[来源](https://mistral.ai/news/ocr-4/)）。
- 原文链接：[来源](https://mistral.ai/news/；https://mistral.ai/news/vibe-remote-agents-mistral-medium-3-5/；https://mistral.ai/news/leanstral-1-5/；https://mistral.ai/news/robostral-navigate/；https://mistral.ai/news/ocr-4/；https://docs.mistral.ai/models/overview)
- 影响判断：Mistral 本周显示出与 OpenAI/Anthropic 不同的路线：用开放权重与专业模型矩阵切入 coding、formal proof、robotics、OCR，并通过 Vibe 把模型能力封装成远程 agent 产品。其核心拐点是“中等规模高可部署性 + 垂直 SOTA”，对欧洲与企业私有化市场尤其有吸引力。

↳ **为什么重要**：Mistral 用 Medium 3.5、Leanstral、Robostral、OCR 4 与 Vibe 组合，展示“可部署中等规模模型 + 垂直 SOTA + agent 产品”的欧洲路线。

### 3. NVIDIA：Rubin AI 工厂与 Jetson Thor 进入 physical AI 落地层 ｜ 7-15~7-17

- 本周动态：本周 NVIDIA 公开动作很密集，核心信号是把 Blackwell/Thor/Rubin 从“芯片发布”推进到国家级 AI 工厂与机器人边缘计算落地。7月16日 NVIDIA Newsroom 宣布与 Noetra Corp. 合作，为日本 FRONTia Project 建设面向 physical AI 的 Vera Rubin AI factory；原文明确写到该工厂包含 13,750 颗 Vera CPU、27,500 颗 Rubin GPU，基于 Vera Rubin NVL72 与 DSX 平台，配套 Spectrum-X Ethernet、BlueField DPU，目标是 140MW 数据中心容量，并训练开放多模态基础模型，服务 AI agents、digital twins、robotics 和 physical AI。7月15日官方博客又发布 Jetson Thor 新模块 T3000/T2000：T3000 以约 T5000 一半尺寸和功耗给出 865 FP4 TFLOPS，Blackwell GPU + 8核 Neoverse Arm CPU + 32GB LPDDR5X + 273GB/s 带宽；T2000 提供 400 FP4 TFLOPS 和 16GB 内存。NVIDIA 同时把 Cosmos 3 Edge 4B 模型带到 Thor 平台，并称开发者可在 JetPack 7.2.1 中使用 T3000 emulation，T3000/T2000 计划 2027Q1 供货。7月17日 Vera Rubin 博客则把叙事转向 agentic AI 后训练经济性：连续 post-training 与 cost per token/intelligence per dollar 绑定，Vera Rubin 被定位为比 Blackwell 代际更进一步的 AI factory 平台。
- 关键数据：13,750 Vera CPUs、27,500 Rubin GPUs、140MW（NVIDIA Newsroom，2026-07-16，[来源](https://nvidianews.nvidia.com/news/japan-government-industrial-leaders-and-nvidia-launch-the-worlds-first-national-ai-infrastructure）；Jetson) T3000 865 FP4 TFLOPS、32GB LPDDR5X、273GB/s、25GbE，T2000 400 FP4 TFLOPS/16GB，2027Q1 可用（NVIDIA Blog，2026-07-15，[来源](https://blogs.nvidia.com/blog/jetson-thor-robotics-edge-ai-agent/）；Vera) 平均 CPU 吞吐较替代 x86 架构高 30%（NVIDIA Blog，2026-07-17，[来源](https://blogs.nvidia.com/blog/nvidia-vera-rubin-post-training-intelligence-per-dollar/)）。
- 原文链接：[来源](https://nvidianews.nvidia.com/news/japan-government-industrial-leaders-and-nvidia-launch-the-worlds-first-national-ai-infrastructure；https://blogs.nvidia.com/blog/jetson-thor-robotics-edge-ai-agent/；https://blogs.nvidia.com/blog/nvidia-vera-rubin-post-training-intelligence-per-dollar/)
- 影响判断：NVIDIA 本周把算力叙事从单卡性能转为“AI 工厂—机器人—边缘端”的整栈路线：Rubin 负责国家/产业级训练，Thor 负责机器人端侧推理。对竞争者而言，难点不只是 GPU，而是 CPU、网络、DPU、软件栈、模型和开发者迁移路径的组合锁定。

↳ **为什么重要**：NVIDIA 同周推进国家级 Vera Rubin AI factory、Jetson Thor T3000/T2000 与 Cosmos 3 Edge，把训练、后训练、端侧机器人推理连成整栈。

### 4. Sierra：Horizon 把客服 Agent 推向长期业务结果 ｜ 7-16

- 本周动态：Sierra 本周（2026-07-16）发布 Horizon，定位为让 Agent 追求“long-horizon goals”的平台，例子包括 originating a loan、getting prior authorization for healthcare procedure、closing a sale、upgrading a subscription plan、scheduling a test drive。官方原文强调 Horizon agents 会在 days、weeks、months 内主动与客户互动，而不是只处理一次对话；它引入 context engine 与 long-horizon planning，把多次 inbound/outbound 交互串起来，并在每次互动后学习改进决策。文章给出的医疗 design partner 场景很具体：从 primary care physician 到 specialist 的 referral scheduling 可能涉及 dozens of texts and phone calls，覆盖患者、专科医生和转诊医生；现有 AI 平台缺少能 stitch together every interaction 的 context engine，以及在 engagements 之间决定下一步动作的 planning。商业模式上，Sierra 明确把 Horizon 连接到 outcomes-based model：客户不是按 tokens 付费，而是为 delivered business outcomes 付费；公司承担 token spend 管理。它还披露 Agent OS 已为数百家公司提供 phone calls and chats，客户包括 Santander、Rocket Mortgage、Cigna，并“including almost half of the Fortune 50”。这表明 Sierra 从客服问答升级到可主动推进收入/留存/授权等业务目标的客户交互 Agent。
- 关键数据：发布日期 2026-07-16（[来源](https://sierra.ai/blog/horizon）；Agent) OS powers phone calls and chats for hundreds of companies，包括 Santander、Rocket Mortgage、Cigna，且覆盖 almost half of the Fortune 50（同源）；Horizon 时间跨度为 days/weeks/months，定价叙述为 pay for business outcomes, not tokens（同源）。
- 原文链接：[来源](https://sierra.ai/blog/horizon；https://sierra.ai/blog)
- 影响判断：Sierra 把“Agent 即服务”推进到长期目标执行和结果计费，是客服 Agent 的重要商业拐点。它试图把客户关系上下文变成企业私有 moat，并把 token 成本风险从客户侧转移到供应商侧，这会倒逼 Agent 平台在记忆、规划和成本优化上形成系统能力。

↳ **为什么重要**：Horizon 强调 days/weeks/months 的 long-horizon planning、context engine 与 outcome-based pricing，是垂直 Agent 商业模式从对话到结果的关键拐点。

### 5. OpenAI：Codex/GPT-5.6 安全与执行层持续修补 ｜ 7-13~7-18

- 本周动态：本周 OpenAI 在大模型基座方向的公开动态主要集中在 Codex/GPT-5.6 生态与安全训练，而不是发布全新 GPT-5 主模型。官方 Codex changelog 显示，2026-07-13 至 2026-07-18 连续发布 Codex CLI 0.144.2、0.144.3、0.144.4、0.144.5、0.144.6；其中 0.144.2 “Restored the previous Guardian auto-review policy… after rolling back a prompting regression”，0.144.5 强化危险命令检测（“more forced rm forms”并给出更清晰拒绝理由），0.144.6 刷新 GPT-5.6 Sol/Terra/Luna 的内置指令并把上下文窗口修正为 272,000 tokens。7月15日官方安全文章《GPT-Red: Unlocking Self-Improvement for Robustness》披露，OpenAI 训练内部自动红队模型 GPT-Red，通过自博弈强化学习生成提示注入攻击，并把其产物用于 GPT-5.6 训练；原文称 GPT-5.6 Sol 相比四个月前最佳生产模型，在最难直接提示注入基准上失败少 6 倍，GPT-Red 在复现的间接提示注入 arena 中成功率 84% 对比人类 13%，且 GPT-5.6 Sol 对 GPT-Red 直接提示注入失败率仅 0.05%。路线判断上，OpenAI 本周信号是“模型能力发布”之后迅速补齐 agent 安全与开发者执行层：Codex 修补危险命令、审批、模型元数据，GPT-Red 则把安全从人工评测扩展为可训练、可规模化的基座能力。
- 关键数据：Codex CLI 0.144.6 发布于 2026-07-18，修正 GPT-5.6 Sol/Terra/Luna 上下文窗口为 272,000 tokens（[来源](https://github.com/openai/codex/releases/tag/rust-v0.144.6；2026-07-18）；GPT-Red) 对 GPT-5.1 间接提示注入 arena 成功率 84% vs 人类 13%，GPT-5.6 Sol 对 GPT-Red 直接提示注入失败率 0.05%，GPT-5.6 Sol 在 hardest direct prompt injection benchmark 失败减少 6x（[来源](https://openai.com/index/unlocking-self-improvement-gpt-red/；2026-07-15)）。
- 原文链接：[来源](https://developers.openai.com/codex/changelog；https://github.com/openai/codex/releases/tag/rust-v0.144.6；https://github.com/openai/codex/releases/tag/rust-v0.144.5；https://github.com/openai/codex/releases/tag/rust-v0.144.2；https://openai.com/index/unlocking-self-improvement-gpt-red/)
- 影响判断：OpenAI 本周把“agent 可用性”的短板从模型能力转向执行安全、审批和上下文元数据正确性。GPT-Red 若能持续规模化，意味着前沿模型竞争会出现“红队模型/防御模型共训练”的新基础设施门槛，不只是 benchmark 榜单竞争。

↳ **为什么重要**：Codex 连续修 Guardian、危险命令和 GPT-5.6 元数据，GPT-Red 则把提示注入红队训练规模化，说明前沿模型竞争进入 agent 安全基础设施阶段。


## 🧭 三条主线趋势

**一 · 基座竞争从“模型发布”转向“agent 基础设施”。** 本周最有信号的动作并不只是参数规模：OpenAI 在 Codex 与 GPT-Red 上补安全和执行层，Microsoft/Azure 与 Databricks 在多模型治理、运行时、观测、上下文和成本审计上加速，字节与 Mistral 则把 1M 上下文、长程任务和 coding agent 作为模型交付形态。前沿模型正在变成更大的 agent 控制面。

**二 · 企业 Agent 的核心门槛变成身份、权限、上下文与结果计费。** Sierra Horizon、Glean agent identity、Harvey 法律工作流、Cursor Slack 多仓环境、Dify Agent Beta、Claude Code/OpenCode 的权限与子代理边界，都指向同一件事：Agent 要进入真实组织，必须可审计、可恢复、可限额、可接入企业数据，并能对业务结果负责。

**三 · physical AI 与云算力进入“平台打包”阶段。** NVIDIA 用 Rubin AI factory + Jetson Thor 把国家级算力和机器人端侧推理连起来；AWS 用 Bedrock/Mantle/HyperPod 组合模型市场与训练拓扑；Azure 用 Foundry Agent Framework 把云运行时推到应用层。相对地，Unitree/Figure 本周产品静默，说明具身落地仍受真实部署、供应链和资本周期约束。

## 📊 赛道速查表

### 🧠 大模型基座

| 对象 | 本周 | 一句话 |
|------|------|--------|
| OpenAI（GPT-5/ChatGPT/Codex） | 🔥 | Codex/GPT-5.6 生态与 GPT-Red 安全训练同周推进，agent 执行安全成为基座能力。 |
| Google DeepMind（Gemini/Gemma） | ⚪️ | 本周无 Gemini/Gemma 新模型发布；Managed Agents 与 Interactions API 仍是背景主线。 |
| Anthropic（Claude Opus/Sonnet） | 🟢 | Claude Enterprise Admin API beta 与 mid-conversation system messages 强化企业治理与长会话控制。 |
| Meta AI（Llama 4） | 🟡 | Llama 4 模型静默，但 Meta 数据中心扩张与 AI 安全治理提供底层背景。 |
| xAI（Grok） | ⚪️ | Grok 模型线本周无新增发布；API 产品化与长上下文价格体系延续。 |
| Microsoft（Copilot/Azure AI/Phi） | 🟢 | Foundry/Agent Framework 将 Copilot、Claude Code 与多智能体运行时整合进平台。 |
| DeepSeek（V3/R1） | ⚪️ | V3/R1 无新发布；API 迁移至 V4-flash/pro 的服务化路线继续推进。 |
| Databricks（DBRX/Mosaic ML） | 🟢 | Unity AI Gateway 与 Genie One 把多模型治理、上下文和成本审计产品化。 |
| 字节跳动（豆包/Coze） | 🟢 | 火山方舟上线 doubao-seed-evolving，1M 上下文面向 Coding/Agent 周级迭代。 |
| Mistral AI（Mistral Large/Codestral） | 🔥 | Medium 3.5、Vibe、Leanstral、Robostral、OCR 4 同周形成专业模型矩阵攻势。 |

### 🤖 垂直 Agent 产品

| 对象 | 本周 | 一句话 |
|------|------|--------|
| Anysphere（Cursor） | 🟢 | Cursor in Slack 加 plan、多仓环境与跨频道上下文，云端 coding agent 进入协作入口。 |
| Perplexity | 🟢 | Agent API 新增 GPT-5.6、Grok 4.5 并透明化模型/工具/沙箱价格。 |
| Cognition（Devin/Windsurf） | 🟢 | Devin Desktop v3.5.17 改进长会话、网络策略、hooks 与 worktree-backed sessions。 |
| Harvey（Legal） | 🟢 | 法律 Agent 更新 Thread、Review Table、组织上下文、Playbook 与 Microsoft 365 集成。 |
| Sierra | 🔥 | Horizon 推出 long-horizon planning 与 outcome-based pricing，客服 Agent 转向业务结果。 |
| Glean | 🔥 | Agent identity public beta + Databricks Assistant，把企业 Agent 身份、审计和数据上下文打通。 |
| Midjourney（v7） | ⚪️ | 官方 v7 相关发布静默，更新节奏已转向 V8.1/draft mode。 |

### 🇨🇳 中国公司

| 对象 | 本周 | 一句话 |
|------|------|--------|
| 阿里云（Qwen/夸克AI） | 🟢 | 百炼上线 Qwen-Audio 实时语音/TTS，并宣布 Managed Agent 商业化。 |
| 智谱（GLM/清言） | ⚪️ | 本周无官方新增模型发布，GLM-5.2 仍为对外叙事核心。 |
| 月之暗面（Kimi K2） | 🔥 | Kimi K3 发布：2.8T、1M 上下文、开放 3T 级长程工作模型。 |
| MiniMax（海螺/abab） | ⚪️ | 本周无可确认官方新发布，M3/Hailuo 多模态 Agent 仍待正式窗口内公告。 |
| 腾讯（混元/元宝） | ⚪️ | 混元/元宝本周无新增官方发布，站点更新不足以计入产品动态。 |

### 🛠️ Agent 框架工具

| 对象 | 本周 | 一句话 |
|------|------|--------|
| OpenClaw（Agent OS） | 🔥 | v2026.7.1 与 7.2 beta 推进 Control UI、远程编码、节点自动化与安全通道。 |
| Dify | 🔥 | v1.16.0 推出 Dify Agent Beta：Linux sandbox、Skills、Workflow 与 MCP 升级。 |
| Hermes Agent（自进化，增长最快） | 🟡 | 本周无新 release，但仓库高活跃，自进化 skills/memory 路线延续。 |
| Claude Code | 🔥 | v2.1.209~215 密集更新，收紧权限、子代理预算、后台 session 与滥用防护。 |
| Codex CLI（SWE-bench #1） | 🟢 | 0.144 稳定线修危险命令检测和 GPT-5.6 元数据，0.145 alpha 高频迭代。 |
| Google ADK | ⚪️ | 本周发布静默，仅仓库活跃；v2.4.0 的托管 Agent 能力作为背景。 |
| OpenCode | 🟢 | v1.18 完成 Desktop v2 迁移并默认阻断嵌套 subagent。 |
| Scale AI（SEAL） | ⚪️ | SEAL 本周无新 release，Scale Labs 评测体系作为背景持续存在。 |
| Cohere（Command R+） | ⚪️ | Command R+ 本周未见官方新模型或 benchmark 发布。 |
| SSI（SSI-1） | ⚪️ | SSI-1 无公开模型/技术报告/API，继续高度静默。 |

### ⚡ 算力云硬件

| 对象 | 本周 | 一句话 |
|------|------|--------|
| NVIDIA（GPU/CUDA/Blackwell） | 🔥 | Rubin AI factory 与 Jetson Thor T3000/T2000，把国家级算力和机器人边缘端贯通。 |
| AWS（Bedrock/Trainium/SageMaker） | 🔥 | Bedrock 上线 GPT-5.6 与 Grok 4.3，HyperPod 增强训练拓扑调度。 |
| Azure（Azure AI/OpenAI Service，独立追踪云业务） | 🟢 | Foundry Agent Framework、Agent Harness 与 coding connectors 进入 GA/预览组合。 |

### 🦾 具身机器人

| 对象 | 本周 | 一句话 |
|------|------|--------|
| 宇树 Unitree（H1/G1） | ⚪️ | H1/G1 本周官方静默，未见产品/交付/融资原始公告。 |
| 优必选 UBTech（Walker S） | 🟡 | Walker S 产品静默，但 H 股全流通完成改善资本市场流动性。 |
| Figure AI（Figure 02） | ⚪️ | Figure 02/03 本周无新增官方节点，BMW 场景为 6月背景。 |


## 📚 赛道深度正文

### 🧠 大模型基座

### OpenAI（GPT-5/ChatGPT/Codex）
- 本周动态：本周 OpenAI 在大模型基座方向的公开动态主要集中在 Codex/GPT-5.6 生态与安全训练，而不是发布全新 GPT-5 主模型。官方 Codex changelog 显示，2026-07-13 至 2026-07-18 连续发布 Codex CLI 0.144.2、0.144.3、0.144.4、0.144.5、0.144.6；其中 0.144.2 “Restored the previous Guardian auto-review policy… after rolling back a prompting regression”，0.144.5 强化危险命令检测（“more forced rm forms”并给出更清晰拒绝理由），0.144.6 刷新 GPT-5.6 Sol/Terra/Luna 的内置指令并把上下文窗口修正为 272,000 tokens。7月15日官方安全文章《GPT-Red: Unlocking Self-Improvement for Robustness》披露，OpenAI 训练内部自动红队模型 GPT-Red，通过自博弈强化学习生成提示注入攻击，并把其产物用于 GPT-5.6 训练；原文称 GPT-5.6 Sol 相比四个月前最佳生产模型，在最难直接提示注入基准上失败少 6 倍，GPT-Red 在复现的间接提示注入 arena 中成功率 84% 对比人类 13%，且 GPT-5.6 Sol 对 GPT-Red 直接提示注入失败率仅 0.05%。路线判断上，OpenAI 本周信号是“模型能力发布”之后迅速补齐 agent 安全与开发者执行层：Codex 修补危险命令、审批、模型元数据，GPT-Red 则把安全从人工评测扩展为可训练、可规模化的基座能力。
- 关键数据：Codex CLI 0.144.6 发布于 2026-07-18，修正 GPT-5.6 Sol/Terra/Luna 上下文窗口为 272,000 tokens（https://github.com/openai/codex/releases/tag/rust-v0.144.6；2026-07-18）；GPT-Red 对 GPT-5.1 间接提示注入 arena 成功率 84% vs 人类 13%，GPT-5.6 Sol 对 GPT-Red 直接提示注入失败率 0.05%，GPT-5.6 Sol 在 hardest direct prompt injection benchmark 失败减少 6x（https://openai.com/index/unlocking-self-improvement-gpt-red/；2026-07-15）。
- 原文链接：https://developers.openai.com/codex/changelog；https://github.com/openai/codex/releases/tag/rust-v0.144.6；https://github.com/openai/codex/releases/tag/rust-v0.144.5；https://github.com/openai/codex/releases/tag/rust-v0.144.2；https://openai.com/index/unlocking-self-improvement-gpt-red/
- 影响判断：OpenAI 本周把“agent 可用性”的短板从模型能力转向执行安全、审批和上下文元数据正确性。GPT-Red 若能持续规模化，意味着前沿模型竞争会出现“红队模型/防御模型共训练”的新基础设施门槛，不只是 benchmark 榜单竞争。

### Google DeepMind（Gemini/Gemma）
- 本周动态：本周未发现 Gemini/Gemma 在 2026-07-13 至 2026-07-19 时间窗内的重大原始发布；Google AI 与 DeepMind 官方页面在本窗内更偏向研究/责任主题，Gemini/Gemma 关键开发者动态主要集中在窗口前。已核验的官方原始来源显示，7月7日 Google 发布 Managed Agents in Gemini API 更新，新增后台执行、远程 MCP server 集成、自定义函数调用和凭据刷新；6月22日发布 Interactions API GA，称其成为 Gemini 模型与 agents 的 primary API，具备稳定 schema、server-side state、background execution、工具组合、Managed Agents、Deep Research 升级，并明确新项目推荐 Interactions API，legacy generateContent 仍支持但长期的 agentic/frontier 能力将更偏向新接口；6月10日发布 DiffusionGemma，26B MoE、推理激活 3.8B 参数、Apache 2.0，主打低并发/本地交互场景最高 4x 更快、单 H100 1000+ tokens/s、RTX 5090 700+ tokens/s。但这些均为背景，非本周。对本期而言，Google DeepMind 的“静默”并不代表路线停滞，而是其大模型基座更新节奏本周处于消化期：Gemini API 的统一交互层、Managed Agents 与 Gemma/DiffusionGemma 的开放模型路线已经在前几周奠定，7月13-19 未见新的本周模型发布或官方 release note。
- 关键数据：背景，非本周：Interactions API GA 2026-06-22（https://blog.google/innovation-and-ai/technology/developers-tools/interactions-api-general-availability/）；Managed Agents 更新 2026-07-07（https://blog.google/innovation-and-ai/technology/developers-tools/expanding-managed-agents-gemini-api/）；DiffusionGemma 2026-06-10，26B MoE、激活 3.8B 参数、最高 4x、更高硬件数据见原文（https://blog.google/innovation-and-ai/technology/developers-tools/diffusion-gemma-faster-text-generation/）。
- 原文链接：https://blog.google/innovation-and-ai/；https://deepmind.google/blog/；https://blog.google/innovation-and-ai/technology/developers-tools/expanding-managed-agents-gemini-api/；https://blog.google/innovation-and-ai/technology/developers-tools/interactions-api-general-availability/；https://blog.google/innovation-and-ai/technology/developers-tools/diffusion-gemma-faster-text-generation/
- 影响判断：本周 Google 在目标时间窗内没有可计入的 Gemini/Gemma 重大新动态，应标为静默。其已形成的路线仍值得跟踪：统一 Interactions API 与 Managed Agents 会把模型调用、沙箱执行、工具和长期任务绑定为平台能力，后续模型更新可能优先通过这一接口释放。

### Anthropic（Claude Opus/Sonnet）
- 本周动态：本周 Anthropic 在 Claude 基座层没有发布新的 Opus/Sonnet 主模型，但 Claude Platform 在企业组织管理与长会话控制方面有实质更新。官方 release notes 显示，2026-07-14 Claude Enterprise（claude.ai）组织管理 Admin API 进入 beta，覆盖成员列表、按邮箱查找、变更成员角色、移除成员、发送/撤回邀请、管理群组及其成员、读取自定义角色等；其中群组与自定义角色请求需 `anthropic-beta: ce-user-management-2026-07-13` beta header，member/invite 请求无需 beta header，带 `read:org_audit` scope 的 Admin API key 可调用所有 user-management GET 端点。2026-07-15，mid-conversation system messages 对 Claude Fable 5、Mythos 5、Opus 4.8 在 Claude API、Amazon Bedrock 与 Google Cloud 上可用且不再需要 beta header，修正此前 availability notes。虽然这不是 Claude Opus/Sonnet 新模型发布，但它直接影响企业级 agent/长上下文应用：中途系统消息允许在多轮任务中变更指令而不破坏既有会话结构，Admin API 则把 Claude 企业部署从“人工控制台管理”推进到可编程 IAM/组织治理。
- 关键数据：Admin API beta 发布 2026-07-14，beta header 为 `ce-user-management-2026-07-13`（https://platform.claude.com/docs/en/release-notes/overview；2026-07-14）；mid-conversation system messages 对 Claude Fable 5、Mythos 5、Opus 4.8 可用且无需 beta header（https://platform.claude.com/docs/en/release-notes/overview；2026-07-15）。背景，非本周：Claude Sonnet 5 于 2026-06-30 发布，1M context、128k max output、intro pricing $2/$10 per MTok 至 2026-08-31。
- 原文链接：https://platform.claude.com/docs/en/release-notes/overview；https://www.anthropic.com/news
- 影响判断：Anthropic 本周的重点是把 Claude 从模型 API 进一步产品化为企业可治理平台。对于大模型基座竞争，这类控制面与长会话指令机制会影响企业迁移成本和 agent 应用可靠性，短期信号弱于模型发布，但对商业落地更关键。

### Meta AI（Llama 4）
- 本周动态：本周未发现 Llama 4 在 2026-07-13 至 2026-07-19 时间窗内的重大公开模型动态；已核验的 Meta 官方 Newsroom 与 Llama 相关公开页面显示，本周 Meta 的 AI 相关公开内容主要是应用/安全/算力基础设施，而非 Llama 4 权重、论文、API 或 benchmark 更新。Meta Newsroom 在 7月13日发布 Richland Parish 路易斯安那数据中心扩建消息，称该数据中心扩张为“more than $50 billion”投资、总算力容量扩至 5GW，并包含对 Louisiana Delta Community College 的 500万美元捐赠、能源协议预计 20年为 Entergy Louisiana 用户节省超过 20亿美元；这与 Meta AI 长期算力供给强相关，但不是 Llama 4 模型发布。7月16日 Meta AI 青少年安全更新宣布，当受监督青少年与 Meta AI 的聊天涉及自杀/自伤风险时，将通知家长，并由专门 AI 系统识别且人工复核后发送；这属于 Meta AI 产品安全治理。Llama 公开仓库方面，`meta-llama/llama-models` 最新 release 仍为 2026-04-05 的 v0.2.0“Llama 4 Support”，不在本周窗口。
- 关键数据：本周无 Llama 4 新模型关键数据；本周相关但非模型：Meta Richland Parish 数据中心扩张超 $50B、5GW、LDCC 捐赠 $5M、能源协议预计 20年节省超 $2B（https://about.fb.com/news/2026/07/teachers-local-businesses-win-as-meta-expands-louisiana-data-center/；2026-07-13）；Meta AI 青少年风险家长提醒先在 US/UK/Australia/Canada 的 Instagram parental supervision 上线，年底全球扩展（https://about.fb.com/news/2026/07/keeping-parents-informed-teens-distress-conversations-meta-ai/；2026-07-16）。
- 原文链接：https://about.fb.com/news/；https://about.fb.com/news/2026/07/teachers-local-businesses-win-as-meta-expands-louisiana-data-center/；https://about.fb.com/news/2026/07/keeping-parents-informed-teens-distress-conversations-meta-ai/；https://github.com/meta-llama/llama-models/releases；https://huggingface.co/meta-llama
- 影响判断：Llama 4 本周应标为静默，但 Meta 的算力与安全治理动作说明其开放模型竞争背后继续加码基础设施与消费者级 AI 风控。后续若 Llama 4 更新，5GW 级数据中心扩张会是支撑训练/推理供给的关键背景，而非本周可计入模型动态。

### xAI（Grok）
- 本周动态：本周未发现 xAI/Grok 在 2026-07-13 至 2026-07-19 时间窗内有新的官方模型发布或重大公开动态；x.ai 新闻页在本环境中返回 403（Blocked due to abusive traffic patterns），因此以可访问的官方 xAI Docs 作为验证来源。官方 Models 文档显示当前文本模型线包括 Grok 4.5、Grok 4.3、Grok 4.20 reasoning/non-reasoning、grok-build-0.1 与 multi-agent 版本，并给出上下文、价格、速率与区域等参数；页面元数据可见 Models 文档 datePublished/dateModified 为 2026-07-09，早于本周窗口。Grok 4.5 页面称其为用于 agentic software、engineering、workflow tasks 的智能编码模型，模态为 text/image→text，context window 500,000 tokens，支持 function calling、structured outputs 和 reasoning，别名包括 `grok-4.5-latest` 与 `grok-build-latest`，价格在 <200k prompt tokens 时为 input $2/M、cached input $0.30/M、output $6/M，≥200k prompt tokens 价格翻倍；Grok 4.20 页则显示 1,000,000 tokens context、reasoning aliases 与更低价格。由于这些页面发布时间均不在 7月13-19，本期不能计为“本周有料”，但可作为对“无重大公开动态”的验证依据。
- 关键数据：本周无新数据。验证背景：xAI Models 文档 datePublished/dateModified 为 2026-07-09（https://docs.x.ai/developers/models）；Grok 4.5 context 500,000 tokens、<200k input $2/M、cached $0.30/M、output $6/M、rate limit 150 RPS/50,000,000 TPM（https://docs.x.ai/developers/models/grok-4.5）；Grok 4.20 context 1,000,000 tokens、<200k input $1.25/M、output $2.50/M（https://docs.x.ai/developers/models/grok-4.20-0309-reasoning）。
- 原文链接：https://docs.x.ai/developers/models；https://docs.x.ai/developers/models/grok-4.5；https://docs.x.ai/developers/models/grok-4.20-0309-reasoning；https://docs.x.ai/developers/rest-api-reference/inference
- 影响判断：xAI 本周处于静默期，主要可见信息仍是 API 产品化与编码/agent 模型线。其高上下文、长提示分段定价与 OpenAI-compatible API 形态说明 xAI 在争夺开发者后端模型份额，但本期没有足够证据表明出现了新模型拐点。

### Microsoft（Copilot/Azure AI/Phi）
- 本周动态：本周 Microsoft 没有发现 Phi 系列新基座模型发布；公开动态集中在 Microsoft Foundry / Agent Framework，把 Copilot、Claude Code、AutoGen/Semantic Kernel 多智能体能力整合为企业开发平台。Azure Release Communications RSS 在 2026-07-15 连续发布多条 AI + machine learning / Microsoft Foundry 更新：Agent Framework 引入 C# 与 Python 的统一 multi-agent orchestration SDK，整合此前分散在 AutoGen 与 Semantic Kernel 的模式；Agent Harness 达到 GA，作为生产 runtime 让 preview harness 的试点用户用相同 agent code 迁移到生产；multi-agent orchestration patterns（含 Magentic）GA，RSS 摘要称 Magentic 在公开 benchmark 中 GAIA 达到 38%，并在 AssistantBench、WebArena 具竞争结果；同时发布 GitHub Copilot 与 Claude Code connectors，使 .NET/Python agent 可委派 coding tasks 给两者；CodeAct pattern 与 Hyperlight containers 进入 public preview，允许 agent 将多步计划折叠成单个可执行代码块以降低端到端延迟；还包括 tracing、episodic procedural memory、Agent Channel、DevUI Agent Inspector。路线判断上，Microsoft 本周不是“造新模型”，而是在模型之上构建 agent 操作系统，把 Copilot、第三方 coding agent 与 Foundry runtime 统一接入。
- 关键数据：2026-07-15 Microsoft Foundry / Agent Framework 多项更新：Magentic pattern GA，RSS 摘要披露 GAIA 38%（https://www.microsoft.com/releasecommunications/api/v2/azure/rss；2026-07-15）；GitHub Copilot and Claude Code connectors GA（https://www.microsoft.com/releasecommunications/api/v2/azure/rss；2026-07-15）；Agent Harness GA、CodeAct/Hyperlight public preview、tracing/memory/channel/inspector 等同日发布（同 RSS）。Phi 新模型：未发现本周原始发布。
- 原文链接：https://www.microsoft.com/releasecommunications/api/v2/azure/rss；https://azure.microsoft.com/en-us/updates/?category=ai-machine-learning；https://huggingface.co/microsoft；https://github.com/microsoft/onnxruntime-genai/releases
- 影响判断：Microsoft 的本周信号是“模型中立的 agent 控制面”增强：把自家 Copilot、Anthropic Claude Code 与 Foundry 统一到编排、观测、内存、通道和生产运行时。对大模型基座格局的意义在于，Azure/Copilot 可能通过平台抽象削弱单一模型品牌的重要性，同时把企业客户锁定在 Foundry agent 生命周期中。

### DeepSeek（V3/R1）
- 本周动态：本周未发现 DeepSeek 在 2026-07-13 至 2026-07-19 时间窗内针对 V3/R1 或 V4 的新模型/论文/权重发布；官方 API 文档与 GitHub/Hugging Face 页面显示，最近可核验的重大模型动态是 2026-04-24 的 DeepSeek-V4 Preview（背景，非本周），以及 DeepSeek-V3 GitHub 2026-06-27 v1.0.0 archival release（背景，非本周）。不过在本周时间窗内，DeepSeek API 文档已明确提示 `deepseek-chat` 与 `deepseek-reasoner` 将在 2026/07/24 15:59 UTC 后弃用，当前兼容映射到 deepseek-v4-flash 的非思考/思考模式；Pricing 页面显示正式 API 模型为 deepseek-v4-flash 与 deepseek-v4-pro，二者均支持 1M context、最高 384K max output、thinking/non-thinking 双模式、Json Output、Tool Calls、Chat Prefix Completion beta，FIM Completion 仅 non-thinking mode。由于文档没有本周发布日期/变更日志，不能把它认定为本周新发布，只作为验证当前无 V3/R1 新动态与模型线迁移方向的依据。
- 关键数据：本周无新模型数据。验证背景：DeepSeek-V4-Pro 1.6T total / 49B active params，V4-Flash 284B total / 13B active params，1M context（https://api-docs.deepseek.com/news/news260424；2026-04-24，背景非本周）；当前 pricing：deepseek-v4-flash cache hit $0.0028/M、cache miss $0.14/M、output $0.28/M、concurrency 2500；deepseek-v4-pro cache hit $0.003625/M、cache miss $0.435/M、output $0.87/M、concurrency 500（https://api-docs.deepseek.com/quick_start/pricing/；页面未公开本周日期）；`deepseek-chat`/`deepseek-reasoner` 2026/07/24 15:59 UTC 弃用（https://api-docs.deepseek.com/）。
- 原文链接：https://api-docs.deepseek.com/；https://api-docs.deepseek.com/quick_start/pricing/；https://api-docs.deepseek.com/news/news260424；https://github.com/deepseek-ai/DeepSeek-V3/releases；https://huggingface.co/deepseek-ai
- 影响判断：DeepSeek 本周应标为静默，但 API 模型命名从 V3/R1 兼容别名转向 V4-flash/pro 的趋势已经清晰。若 7月24日弃用如期执行，开发者生态会被迫完成新模型名迁移，DeepSeek 的竞争重点也会从“V3/R1 单点爆款”切换到 1M 上下文、低价缓存与 agent 工具调用的服务化路线。

### Databricks（DBRX/Mosaic ML）
- 本周动态：本周 Databricks 未发布新的 DBRX/Mosaic ML 基座模型，但在大模型“接入、治理、上下文与企业 AI coworker”层面有多项可计入动态。7月17日 Databricks 官方博客宣布 Meta’s Spark Muse 1.1 可通过 Unity AI Gateway 的 Model Provider Services（MPS）接入 Databricks，文章强调 MPS 是 Unity Catalog securable：外部 provider 的连接配置与 API key 在 Unity Catalog 中登记，调用方使用 Databricks 凭据访问，网关在请求时附加 provider key，key 通过 Unity Catalog connection 加密保存且不暴露给客户端；权限使用标准 GRANT/REVOKE 管理（EXECUTE、READ_METADATA、MANAGE），并可附加 rate limits、service policies、inference tables、usage/spend tracking。7月16日博客《Unified context》提出 Genie One 与 Genie Ontology 的 enterprise AI coworker 路线：把 Databricks 数据、文档、SaaS 与 operational systems 形成统一业务上下文，继承 Unity Catalog 权限与治理。7月15日 release notes 还显示 AI Search High QPS GA，可为搜索框、推荐、entity matching 等实时负载设置标准 AI Search endpoints 的 target QPS。整体看，Databricks 本周不是训练新模型，而是把“任意模型 + 统一数据上下文 + 成本/权限/审计治理”产品化，延续 MosaicML 之后从模型公司转向企业 AI data/control plane 的定位。
- 关键数据：Model Provider Services / Muse Spark 1.1 支持发布于 2026-07-17，MPS 支持 OpenAI、Anthropic、Amazon Bedrock 和 Muse Spark 1.1 等 provider，并记录 token counts、latency、status codes，spend 写入 `system.ai_gateway.external_model_spend`（https://www.databricks.com/blog/metas-spark-muse-11-now-available-databricks-fully-governed-unity-ai-gateway；2026-07-17）；Anthropic managed ingestion connector Beta、Databricks Genie app in Microsoft Teams Public Preview 均为 2026-07-17，AI Search High QPS GA 为 2026-07-15（https://docs.databricks.com/aws/en/release-notes/product/2026/july）。
- 原文链接：https://www.databricks.com/blog；https://www.databricks.com/blog/metas-spark-muse-11-now-available-databricks-fully-governed-unity-ai-gateway；https://www.databricks.com/blog/unified-context-missing-layer-enterprise-ai-coworkers；https://docs.databricks.com/aws/en/release-notes/product/2026/july；https://huggingface.co/databricks
- 影响判断：Databricks 本周信号是“模型供应商越多，治理网关越值钱”。MPS/Unity AI Gateway 让企业在不绑定单一模型的情况下保留权限、审计、成本和上下文控制，这会强化 Databricks 在企业 AI 基础设施中的中立层价值。\n

### 字节跳动（豆包/Coze）
- 本周动态：本周字节跳动豆包/火山方舟有明确模型动态。火山方舟文档“最新模型：Seed-Evolving”显示，Seed-Evolving 是面向 Agent 与 Coding 场景打造的 Seed 系列模型，统一调用 Model ID `doubao-seed-evolving`，无需关注版本切换即可持续获得最新模型能力；页面标注“版本更新时间：2026/07/14”，本次围绕超长上下文、长程任务与调用效率三大方向优化。核心更新包括：1M 超长上下文，单次任务可处理大型代码仓、长篇文档、多轮对话记录、跨文件资料；长程任务能力提升，在时间更长、步骤更多、依赖更复杂的任务中更稳定，并称在 Claude Code、Hermes、OpenClaw 众测首评中长程任务质量优于上一版本（0623）；tokens 效率提升，Coding/Agent 任务相较 0623 版本消耗更少 tokens、工具调用轮次更简洁。模型限制页给出上下文窗口 1024k、最大输入 1024k、最大思维链内容长度 256k、最大输出 256k，最大 RPM 500、TPM 1,000,000。7月17日 Agent Plan 个人版“模型上线公告”进一步列出 07.15 上线 `doubao-seed-evolving`，说明其“面向 Coding 与 Agent 场景，持续周级升级，以统一模型 ID 提供最新能力”。这说明豆包把 Agent/Coding 基座从固定版本推进到 rolling model ID，目标是降低开发者迁移成本并通过高频迭代追赶 Claude Code/Codex 类工具链。
- 关键数据：`doubao-seed-evolving` 版本更新时间 2026/07/14；上下文窗口 1024k、最大输入 1024k、最大思维链 256k、最大输出 256k、最大 RPM 500、最大 TPM 1,000,000（https://www.volcengine.com/docs/82379/2549861；2026-07-14）；Agent Plan 模型上线公告显示 07.15 上线 `doubao-seed-evolving`（https://www.volcengine.com/docs/82379/2578669；页面最近更新时间 2026.07.17 10:40:50）；模型列表页最近更新时间 2026.07.14 23:12:52，推荐模型列出 `doubao-seed-evolving`（https://www.volcengine.com/docs/82379/1330310）。
- 原文链接：https://www.volcengine.com/docs/82379/2549861；https://www.volcengine.com/docs/82379/2578669；https://www.volcengine.com/docs/82379/1330310；https://www.coze.cn/open/docs/developer_guides/changelog
- 影响判断：豆包本周最重要的变化是把 Coding/Agent 模型做成“统一 ID + 周级迭代”的持续交付形态。1M context、长程任务、工具调用效率和第三方 agent 工具适配一起出现，说明国内基座厂商正在从聊天模型竞争转向 coding agent runtime 的可用性竞争。

### Mistral AI（Mistral Large/Codestral）
- 本周动态：本周 Mistral 在大模型基座与专业模型方向非常活跃，重点是 Mistral Medium 3.5、Vibe remote agents、Leanstral 1.5、Robostral Navigate 与 OCR 4。官方《Remote agents in Vibe. Powered by Mistral Medium 3.5》披露，Mistral Medium 3.5 进入 public preview，是 dense 128B 模型、256k context window，合并 instruction-following、reasoning、coding 于一组权重，支持 self-hosting 至少四张 GPU，reasoning effort 可按请求配置；其 SWE-Bench Verified 得分 77.6%，τ³-Telecom 91.4，并成为 Le Chat 默认模型、替换 Vibe CLI 中的 Devstral 2，API 价格为 input $1.5/M、output $7.5/M，开源权重以 modified MIT license 发布。Leanstral 1.5 则是 Apache-2.0、119B total/6B active 的 Lean 4 formal verification 模型，miniF2F validation/test 100%，PutnamBench 587/672，FATE-H 87、FATE-X 34，FLTEval pass@8 从 31.9 提至 43.2，并在 57 个仓库中发现 47 个 violated properties、11 个真实 bug、5 个此前 GitHub 未报告。Robostral Navigate 是 8B embodied navigation model，仅用单 RGB camera，在 R2R-CE validation unseen 达 76.6%，比最佳单摄方案高 9.7 点、比最佳 depth/multi-camera 系统高 4.5 点。OCR 4 支持 170 种语言、bounding boxes、block classification、inline confidence，OlmOCRBench 85.20，API $4/千页、Batch API $2/千页。Mistral 本周呈现“旗舰通用 + 垂直专业 + agent 产品”同步推进。
- 关键数据：Mistral Medium 3.5：128B dense、256k context、SWE-Bench Verified 77.6%、τ³-Telecom 91.4、$1.5/M input、$7.5/M output（https://mistral.ai/news/vibe-remote-agents-mistral-medium-3-5/）；Leanstral 1.5：119B total/6B active、Apache-2.0、miniF2F 100%、PutnamBench 587/672、FATE-H 87、FATE-X 34、FLTEval pass@8 43.2（https://mistral.ai/news/leanstral-1-5/）；Robostral Navigate：8B、R2R-CE validation unseen 76.6%、seen 79.4%、2.4M trajectories/350k scenes、token reduction 22×、RL +3.2%（https://mistral.ai/news/robostral-navigate/）；OCR 4：170 languages、OlmOCRBench 85.20、$4/1,000 pages、Batch $2/1,000 pages（https://mistral.ai/news/ocr-4/）。
- 原文链接：https://mistral.ai/news/；https://mistral.ai/news/vibe-remote-agents-mistral-medium-3-5/；https://mistral.ai/news/leanstral-1-5/；https://mistral.ai/news/robostral-navigate/；https://mistral.ai/news/ocr-4/；https://docs.mistral.ai/models/overview
- 影响判断：Mistral 本周显示出与 OpenAI/Anthropic 不同的路线：用开放权重与专业模型矩阵切入 coding、formal proof、robotics、OCR，并通过 Vibe 把模型能力封装成远程 agent 产品。其核心拐点是“中等规模高可部署性 + 垂直 SOTA”，对欧洲与企业私有化市场尤其有吸引力。

---

### 🤖 垂直 Agent 产品

### Anysphere（Cursor）
- 本周动态：Cursor 本周（官方页面源码标注 2026-07-17）更新了 Slack 场景的 Agent 协作能力，重点不是 IDE 内模型升级，而是把“代码 Agent”推向团队协作入口。官方 changelog 写明：Cursor in Slack 现在会在开始前先分享 plan，工作中持续更新状态；交互上移除消息内按钮，改为更紧凑的 footer links，并优化 tables、PRs、artifacts 的呈现。更关键的是 multi-repo environment：从 Slack 发起任务时，Cursor 可进入一个命名的多仓环境，而不是单一默认仓库；当任务中途需要当前环境之外的 repo 时，会提示 Switch repository，用户选择后继续上下文。第三个变化是 cross-channel workflows：Agent 可读取其他 Slack channel/thread 的上下文，并把更新发回原始线程或相关频道。结合 7 月 10 日“side chats / conversation search / cloud-agent hooks”（背景，非本周）和 iOS beta（背景，非本周），Cursor 的路线明显从“本地 AI IDE”扩展为“异步云 Agent + 企业协作操作面”：Slack、移动端、云 Agent hooks 都在解决真实团队中长任务的可观测、可干预、多仓上下文和审计问题。
- 关键数据：发布日期 2026-07-17（Cursor changelog 页面源码日期；https://cursor.com/changelog/slack-improvements）；功能点包括 plan-before-start、multi-repo environments、cross-channel workflows（同源）。
- 原文链接：https://cursor.com/changelog/slack-improvements；https://cursor.com/changelog；https://cursor.com/blog/ios-mobile-app（背景，非本周）
- 影响判断：这是 Cursor 从“开发者个人生产力工具”转向“企业软件工程工作流层”的信号。多仓与跨频道上下文解决的是大型组织采用 Agent 的真实阻塞点：代码分布、上下文分散、任务可追踪；若落地顺畅，Cursor 会更像 DevOps 协作平台而不只是 IDE 插件。

### Perplexity
- 本周动态：Perplexity 官方 API 文档在 July 2026 changelog 中披露 Agent API 新增多组模型，并在 models reference 中给出 first-party token pricing。变更包括 GPT-5.6 family：`openai/gpt-5.6-sol`、`openai/gpt-5.6-terra`、`openai/gpt-5.6-luna`；新增 `xai/grok-4.5`；同时退役 `google/gemini-3.1-flash-lite-preview`，因 Google 移除了底层 preview model，请求该 id 会返回 `model not supported`，建议改用稳定版 `google/gemini-3.1-flash-lite`。models 页面还显示 Agent API 将工具、沙箱、搜索、模型费用整合到一张可比价表：例如 Agent tools 中 web_search/fetch_url/people_search/finance_search 分别列价，sandbox session 也单独计价；模型侧包含 Perplexity、Anthropic、OpenAI、Google、xAI、Z.AI、Moonshot AI、NVIDIA 等。这里的核心不在单个模型能力，而在 Perplexity 将自己定位为“多模型 + 搜索 + 工具 + 沙箱”的 Agent API 汇聚层：开发者可通过一个 Agent endpoint 做模型 fallback、web search、fetch_url、sandbox、结构化输出和背景任务。对垂直 Agent 产品而言，这比传统问答搜索更接近基础设施生意。
- 关键数据：July 2026 Agent API 新增 `openai/gpt-5.6-sol`、`openai/gpt-5.6-terra`、`openai/gpt-5.6-luna`、`xai/grok-4.5`，退役 `google/gemini-3.1-flash-lite-preview`（https://docs.perplexity.ai/docs/resources/changelog，July 2026）；模型价格示例：`openai/gpt-5.6-sol` input $5/$10 per 1M tokens、output $30/$45 per 1M tokens，threshold 272k；Agent `web_search` $0.005/invocation，sandbox session $0.03（https://docs.perplexity.ai/docs/agent-api/models.md，July 2026）。
- 原文链接：https://docs.perplexity.ai/docs/resources/changelog；https://docs.perplexity.ai/docs/agent-api/models.md；https://docs.perplexity.ai/llms.txt
- 影响判断：Perplexity 本周动态显示其 API 战略从 Sonar 搜索问答继续上移到 Agent 基础设施。把模型、搜索、工具、沙箱和价格透明化，有利于吸引企业把 Perplexity 当作 agentic workflow 的统一入口，而非只作为消费端搜索替代品。

### Cognition（Devin/Windsurf）
- 本周动态：Cognition/Devin 本周在官方 Devin Desktop（Windsurf）changelog 发布 v3.5.17（2026-07-19）。该版本覆盖 Devin Desktop、Devin Cloud 和 Devin Local 三条线：桌面端改进 Cascade 的 @-mention pills 图标、Agent Command Center 命令面板样式，并默认隐藏 status bar；更重要的是新 worktree-backed sessions 会“instantly”打开，并在后台创建 worktree 时保持交互，降低从提示到可操作环境的等待。Devin Cloud 侧强调长会话性能：长 Cloud sessions 的渲染、滚动、输入和 streaming 更快，短暂远程连接掉线不再闪出 disconnected banner；并新增可在 chat 内直接配置 session network policy、批准/拒绝网络访问请求，而不用切到 web app。Devin Local 则把 customizations 和 sidebar skills count 扩展到所有打开的 workspace folders，Hooks tab 展示 hook source/trigger events，并提供把 Windsurf hooks 迁移到 Devin hooks 的命令，同时加入 timeline navigator 和 Fast Context。整体看，这不是一次模型发布，而是 Agent IDE/云端执行环境的工程化迭代：Cognition 收购/整合 Windsurf 后，正在把本地 IDE、云会话、网络权限、hooks、skills、workspace folder 统一成 Devin 操作系统，重点解决长任务可用性、权限边界和迁移摩擦。
- 关键数据：Devin Desktop v3.5.17，发布日期 2026-07-19（https://docs.devin.ai/desktop/changelog）；官方列出 Devin Desktop/Cloud/Local 三类更新，包括 inline network policy、Fast Context、Windsurf hooks migration。
- 原文链接：https://docs.devin.ai/desktop/changelog；https://windsurf.com/changelog
- 影响判断：Devin/Windsurf 的竞争重点正在从“单次 coding benchmark”转向“可持续运行的开发环境”。网络策略内联审批、长会话性能和 hooks 迁移说明其面向企业落地时，权限、审计、稳定性和已有工作流兼容性比 demo 能力更关键。\n

### Harvey（Legal）
- 本周动态：Harvey 本周发布《The Brief: July 2026》（官方结构化数据 datePublished=2026-07-17T15:00:00Z），集中披露法律垂直 Agent 的一批产品升级。核心主题是“更复杂的 drafting、reviews、contracting，但减少人工步骤”。Agent 侧新增 Thread Experience Update：用户可在复杂多步任务前请求并验证 agent plan、并行运行多个任务，结果 ready for review 时再被拉回；Review Table 支持 inline 编辑任意 cell、把文件作为列级 context 以便每行对照固定模板/监管标准，还增加长任务完成/共享/导出的邮件通知。组织知识方面，in-house admins 可设置 organization-wide context，使 Word Add-In 的 redlines/suggestions 自动反映内部优先级和谈判立场。输入/输出层面，Harvey 支持上传音频到 Assistant 或 Vault 生成 speaker-labeled editable transcript；Custom Workflows 可创建/编辑 PowerPoint 和 Excel；Assistant 里新增 Playbook Creation Agent。集成和模型方面，Harvey 接入 Microsoft 365 Copilot & Cowork，可在 Copilot 中问法律问题、分析文档、检索 Vault 内容，并在 Cowork 中跑多步工作流；Android/iOS 和法语本地化增强；模型 selector 中新增 Claude Sonnet 5 和 GPT-5.6 Sol；法律研究源新增 245+。这组更新显示 Harvey 继续把法律工作拆成可审计、可复用、可异步交付的 workflow，而不是只做法律问答。
- 关键数据：发布日期 2026-07-17（https://www.harvey.ai/blog/the-brief-july-2026）；新增 245+ legal research sources；模型新增 Claude Sonnet 5、GPT-5.6 Sol；功能包括 Thread Experience Update、file as column context、Microsoft 365 Copilot & Cowork integration（同源）。
- 原文链接：https://www.harvey.ai/blog/the-brief-july-2026；https://www.harvey.ai/blog
- 影响判断：Harvey 的本周更新体现法律 Agent 的产品化路径：计划验证、表格审阅、组织上下文、Playbook、Office 文件生成、权限控制组成了可交付法律工作的闭环。其壁垒不只是模型，而是把法律知识、文档结构、审阅流程和企业权限沉淀进专用工作台。

### Sierra
- 本周动态：Sierra 本周（2026-07-16）发布 Horizon，定位为让 Agent 追求“long-horizon goals”的平台，例子包括 originating a loan、getting prior authorization for healthcare procedure、closing a sale、upgrading a subscription plan、scheduling a test drive。官方原文强调 Horizon agents 会在 days、weeks、months 内主动与客户互动，而不是只处理一次对话；它引入 context engine 与 long-horizon planning，把多次 inbound/outbound 交互串起来，并在每次互动后学习改进决策。文章给出的医疗 design partner 场景很具体：从 primary care physician 到 specialist 的 referral scheduling 可能涉及 dozens of texts and phone calls，覆盖患者、专科医生和转诊医生；现有 AI 平台缺少能 stitch together every interaction 的 context engine，以及在 engagements 之间决定下一步动作的 planning。商业模式上，Sierra 明确把 Horizon 连接到 outcomes-based model：客户不是按 tokens 付费，而是为 delivered business outcomes 付费；公司承担 token spend 管理。它还披露 Agent OS 已为数百家公司提供 phone calls and chats，客户包括 Santander、Rocket Mortgage、Cigna，并“including almost half of the Fortune 50”。这表明 Sierra 从客服问答升级到可主动推进收入/留存/授权等业务目标的客户交互 Agent。
- 关键数据：发布日期 2026-07-16（https://sierra.ai/blog/horizon）；Agent OS powers phone calls and chats for hundreds of companies，包括 Santander、Rocket Mortgage、Cigna，且覆盖 almost half of the Fortune 50（同源）；Horizon 时间跨度为 days/weeks/months，定价叙述为 pay for business outcomes, not tokens（同源）。
- 原文链接：https://sierra.ai/blog/horizon；https://sierra.ai/blog
- 影响判断：Sierra 把“Agent 即服务”推进到长期目标执行和结果计费，是客服 Agent 的重要商业拐点。它试图把客户关系上下文变成企业私有 moat，并把 token 成本风险从客户侧转移到供应商侧，这会倒逼 Agent 平台在记忆、规划和成本优化上形成系统能力。

### Glean
- 本周动态：Glean 本周连续发布企业 Agent/Assistant 更新，重点是“身份治理 + 数据分析入口”。7 月 15 日，Glean 将 agent identity 作为 public beta 向客户开放：agent 可通过自己的 service account credentials 行动，例如 Slack bot、Jira account、GitHub App，由管理员注册并 scope；同一个 agent 对所有运行者保持一致凭据。官方解释了企业落地痛点：如果 agent 借用运行者身份，普通用户可能无权访问所需系统，高权限用户又会让 agent 继承过多权限，长任务还会受用户 token 过期影响，审计轨迹也会把 agent 工作错误归到人名下。agent identity 让 who can invoke 与 what the agent is trusted to do 解耦，并在 audit trail 中记录 agent account 及触发人/计划任务。7 月 17 日，Glean 又发布 Databricks in Glean Assistant：用户可在 Glean 中用自然语言询问分析问题，或对获批 Databricks 数据运行 read-only SQL；Glean 调用 Databricks Genie 把自然语言转成 SQL，再把 Databricks insights 与 docs、tickets、notes、Slack、email、rollout plans 等企业上下文合并，进一步生成 polished documents、charts、slides 或 interactive artifacts。两篇合看，Glean 的路线是把 Agent 变成企业内“有身份、有权限、有上下文、有数据分析能力”的工作主体。
- 关键数据：Agent identity public beta，Last updated Jul 15, 2026（https://www.glean.com/blog/introducing-agent-identity）；Databricks in Glean Assistant，Last updated Jul 17, 2026（https://www.glean.com/blog/query-databricks-with-glean）；支持 agent 自有 Slack/Jira/GitHub App 凭据、Databricks Genie NL-to-SQL、read-only SQL、所有相关 integrations generally available（同源）。
- 原文链接：https://www.glean.com/blog/introducing-agent-identity；https://www.glean.com/blog/query-databricks-with-glean；https://www.glean.com/blog
- 影响判断：Glean 的信号非常清晰：企业 Agent 的关键不再是“能不能答”，而是能否以合规身份访问系统、留下可审计轨迹，并把结构化数据与非结构化企业上下文拼接成行动。agent identity 可能成为企业 Agent 平台的标配能力。

### Midjourney（v7）
- 本周动态：本周无重大公开动态。验证依据：Midjourney 官方 updates 页面截至本期时间窗内最近条目仍为 2026 年 6 月 25 日 “Random styles in draft mode”，6 月 16 日 “Draft mode for V8.1 and new feature previews”，6 月 11 日 “V8.1 is now the default model on Midjourney”；未发现 2026-07-13 至 2026-07-19 内关于 Midjourney v7 的官方新发布。补充搜索结果也显示 v7 属于更早版本背景，且 2026 年 7 月讨论多为第三方评测/教程，并非本周官方发布。
- 关键数据：—
- 原文链接：https://updates.midjourney.com/；未发现时间窗内原始发布
- 影响判断：Midjourney 本周在官方渠道静默，且当前官方更新节奏已转向 V8.1/draft mode 等后续能力，v7 不再是本周产品节奏中心。对周报而言不应把第三方评测或旧版本介绍当作本周动态。

---

### 🇨🇳 中国公司

### 阿里云（Qwen/夸克AI）
- 本周动态：阿里云百炼本周在官方“模型上下架与更新”和“模型平台功能更新”中出现多项与 Agent/多模态有关的更新。7 月 14 日，百炼上线 `qwen-audio-3.0-realtime-plus`、`qwen-audio-3.0-realtime-flash`，官方说明 Qwen-Audio 端到端实时语音大模型兼顾语音推理能力与双工对话节奏，通过并行推理、全向流式等工程优化控制端到端响应时延；同日上线 `qwen-audio-3.0-tts-plus`、`qwen-audio-3.0-tts-flash`，新增更多小语种和中文方言支持，增强指令遵循与细粒度标签控制，Plus 面向高品质专业场景，Flash 面向低延迟实时交互，首包延时控制在 200ms 以内。7 月 16 日，百炼发布 Managed Agent 商业化通知，影响产品为大模型服务平台百炼，影响时间为北京时间 2026-08-17 09:00:00。7 月 13 日至 15 日还上架 Vidu 图像/视频生成及 PixVerse 对口型、动作模仿、视频超清等第三方模型，说明百炼继续做“模型货架 + Agent 托管 + 实时多模态”的平台层。值得注意的是，搜索结果出现 7 月 19 日 36氪关于 Qwen3.8-Max 预览版的报道，但未在官方 Qwen blog/百炼模型更新中找到对应原始官方发布，因此仅作为待验证外部信号，不纳入有源核心事实。
- 关键数据：`qwen-audio-3.0-realtime-plus/flash`、`qwen-audio-3.0-tts-plus/flash` 上架日期 2026-07-14（https://help.aliyun.com/zh/model-studio/newly-released-models）；TTS Flash 首包延时 200ms 以内（同源）；Managed Agent 商业化通知发布时间 2026-07-16 18:29:11，影响时间 2026-08-17 09:00:00（https://www.aliyun.com/notice/118456）。
- 原文链接：https://help.aliyun.com/zh/model-studio/newly-released-models；https://help.aliyun.com/zh/model-studio/model-release-notes；https://www.aliyun.com/notice/118456；https://qwenlm.github.io/blog/（验证未见时间窗内新官方博客）
- 影响判断：阿里云本周信号是把千问能力进一步商品化、实时化、平台化：实时语音与 TTS 补齐交互入口，Managed Agent 商业化则把托管会话和工具执行从功能试用推向计费产品。对中国企业 Agent 市场，百炼更像“AI PaaS/模型超市”，而不只是单一 Qwen 模型发布渠道。

### 智谱（GLM/清言）
- 本周动态：本周无重大公开动态。验证依据：本期检索到的 2026-07-13 至 2026-07-19 结果主要为媒体/社区对 GLM-5.2、上市融资及二级市场表现的转述或评论；官方站点与官方文档页面可见的核心模型仍围绕 GLM-5.2（1M 上下文、128K 最大输出、Function Call、MCP、上下文缓存等）展开，但未在时间窗内发现新的官方博客、release notes 或模型上架公告。官方新闻页抓取内容也没有显示 7 月 13-19 日的新发布条目。因此本期不将旧的 GLM-5.2 发布、ZCode 3.0 或二级市场报道包装成本周产品动态。
- 关键数据：—
- 原文链接：https://www.zhipuai.cn/news；https://docs.bigmodel.cn/cn/guide/models；未发现时间窗内原始发布
- 影响判断：智谱本周公开产品节奏相对静默，但 GLM-5.2 仍是其对外叙事核心：长上下文、工程 Agent、开源 SOTA 和 Coding Plan 团队版。短期看，市场关注点从发布转向商业化与资本化；周报应把本周缺乏官方新增发布与旧模型持续传播区分开。

### 月之暗面（Kimi K2）
- 本周动态：月之暗面本周发布 Kimi K3，虽然本组对象名沿用“Kimi K2”，但本期真实公开动态已经切换到新一代 K3。Kimi 官方技术博客称，Kimi K3 是其“most capable model”，拥有 2.8T 参数，基于 Kimi Delta Attention（KDA）和 Attention Residuals，原生支持视觉能力和 1-million-token context window，并称为全球首个 open 3T-class model，面向 long-horizon coding、knowledge work 和 reasoning。架构上，K3 结合 Stable LatentMoE 后在 896 个专家中激活 16 个，整体 scaling efficiency 相比 Kimi K2 提升约 2.5×；训练和推理侧引入 quantization-aware training、MXFP4 weights、MXFP8 activations，并建议在 64+ accelerators supernode 上部署。能力案例非常偏 Agent：24 小时 kernel optimization、从零构建 MiniTriton GPU compiler、48 小时自主芯片设计、复现 I–Love–Q universal relations 时阅读交叉验证 20+ papers、评估 300+ equations of state、生成 3,000+ lines Python code。产品可用性上，K3 已在 Kimi.com、Kimi Work、Kimi Code、Kimi API 可用；完整模型权重将于 2026-07-27 前发布。官方 API 文档进一步确认 K3 始终开启思考模式，支持 reasoning_effort=low/high/max，支持视觉输入、结构化输出、Partial Mode、tool_choice、动态加载工具、1M 上下文自动缓存等。
- 关键数据：2.8T 参数、1M token 上下文、896 experts / activate 16、scaling efficiency 相比 K2 约 2.5×、完整权重 2026-07-27 前发布、Kimi API 定价 cache-hit input $0.30/MTok、cache-miss input $3.00/MTok、output $15.00/MTok（https://www.kimi.com/blog/kimi-k3，页面素材与内容为 2026-07-17 发布周；https://platform.kimi.com/docs/guide/kimi-k3-quickstart.md）；阿里云百炼亦记录 `kimi/kimi-k3` 于 2026-07-17 上架并描述 2.8 万亿参数、100 万 token 上下文（https://help.aliyun.com/zh/model-studio/newly-released-models）。
- 原文链接：https://www.kimi.com/blog/kimi-k3；https://platform.kimi.com/docs/guide/kimi-k3-quickstart.md；https://platform.kimi.com/docs/llms.txt；https://help.aliyun.com/zh/model-studio/newly-released-models
- 影响判断：Kimi K3 是本周中国模型公司最强信号之一：开源规模、长上下文、Agent coding、知识工作和视觉能力被打包成统一旗舰。其路线不是只追通用榜单，而是把“长程任务 + 工具/终端 + 多模态反馈 + 工作产物生成”作为核心评测场，直接对标 Claude Code/Codex 式 agentic workflow。

### MiniMax（海螺/abab）
- 本周动态：MiniMax 本周没有在 2026-07-13 至 2026-07-19 窗口内发现新的官方原始发布；其官网导航和模型页显示当前重点产品为 MiniMax M3、MiniMax Hailuo 2.3 / 2.3 Fast、MiniMax Speech 2.8、MiniMax Music 3.0、MiniMax Code 等，但这些页面的可读正文或结构化日期要么是 2026-07-20 页面生成/修改时间（已超出本期窗口），要么正文显示 Hailuo 2.3 为 2025.10.28，不能计入本周动态。作为背景，M3 页面强调“Coding & Agentic Frontier、1M-context MSA、Native Multimodality”，称 API 支持最高 1M tokens、保证最低 512K tokens，BrowseComp 83.5，并给出 12 小时论文复现、24 小时 CUDA kernel optimization（147 次 benchmark submissions、1,959 tool calls、9.4× speedup）等 Agent 案例；但页面结构化 dateModified 为 2026-07-20，且未能验证为本周自然周内发布。因此本期按静默处理，避免把 7 月 20 日之后或旧闻混入。
- 关键数据：—
- 原文链接：https://www.minimax.io/news；https://www.minimax.io/models/text/m3；https://www.minimax.io/news/minimax-hailuo-23；https://platform.minimax.io/docs/guides/music-generation；未发现时间窗内原始发布
- 影响判断：MiniMax 的公开叙事已明显转向多模态 Agent 与内容生成平台，但本周缺少可确认的窗口内官方发布。后续应重点跟踪 M3、MiniMax Code 与 Hailuo Media Agent 是否有正式日期清晰的 API/开源/产品公告。

### 腾讯（混元/元宝）
- 本周动态：本周无重大公开动态。验证依据：腾讯混元官网在 2026-07-17 有站点 build-time，但页面抓取内容主要是站点/博客前端资源与基础介绍，不等同于公开产品发布；腾讯云混元产品概述页可见当前主要模型信息包括 `hunyuan-a13b`（日期 2025-06-25）和 `hunyuan-translation`（日期 2025-10-14），均不在本期窗口内。检索与官方页面验证未发现 2026-07-13 至 2026-07-19 期间混元或元宝的新增模型、Agent 产品、官方博客或 release notes。背景上，混元站点介绍其研究方向包含大语言模型、多模态理解、强化学习算法及 Agent 能力演进，产品导航包含 Hy AI Studio、元宝、WorkBuddy，但本周没有可引用的新增事实。
- 关键数据：—
- 原文链接：https://hunyuan.tencent.com/；https://cloud.tencent.com/document/product/1729/104753；未发现时间窗内原始发布
- 影响判断：腾讯本周在本组口径下保持静默，公开页面更多体现基础能力和站点改版，而非新产品。对比阿里云、Kimi、Glean 等明确发布，腾讯混元/元宝本期缺少可写入的 agentic 产品拐点。

---

### 🛠️ Agent 框架工具

### OpenClaw（Agent OS）
- 本周动态：本周 OpenClaw 有连续发布。GitHub Releases 显示，稳定版 `v2026.7.1` 于 2026-07-13 22:33:14 UTC 发布（上海时间 7月14日 06:33），随后 `v2026.7.2-beta.1/.2/.3` 分别在 7月16日、17日、19日（上海时间）进入测试。`v2026.7.1` 的原始说明写明“major Control UI and onboarding overhauls”“expanded model and provider support including GPT-5.6 compatibility”，并披露“3,063 contributions from 532 contributors”。这说明 OpenClaw 的本周重点不是单点模型能力，而是把 Agent OS 的入口、控制台、移动端、消息渠道、远程浏览器、工作区终端和 Codex/Claude 等编码代理工作流打通。随后 `v2026.7.2-beta.3` 的 highlights 又把方向推到“Remote coding sessions”（云 worker 上运行 Control UI session，在拥有主机上打开 Codex/Claude catalog terminal，并能恢复 OpenCode/Pi sessions）、“Native automation and nodes”（移动端自动化、Android Voice Wake、headless Linux node 暴露 camera/location/notification）、“Safer channel operation”（Telegram durable-ingress、Signal stop/approval、allowlist 权限边界）以及 deb/AppImage/Windows winget 安装链路。我的判断是：OpenClaw 正在把“聊天代理”扩成跨端、跨主机、跨渠道的操作系统层，核心竞争点从单模型调用转向会话恢复、权限/审批、节点能力和远程编码工作流编排。
- 关键数据：`v2026.7.1` 发布于 2026-07-13T22:33:14Z，3,063 contributions / 532 contributors；`v2026.7.2-beta.3` 发布于 2026-07-18T23:16:53Z；截至 2026-07-20 GitHub API 抓取，383,533 Stars、80,563 Forks、6,922 open issues。来源：https://api.github.com/repos/openclaw/openclaw/releases?per_page=20 ，https://api.github.com/repos/openclaw/openclaw
- 原文链接：https://github.com/openclaw/openclaw/releases/tag/v2026.7.1 ；https://github.com/openclaw/openclaw/releases/tag/v2026.7.2-beta.3 ；https://api.github.com/repos/openclaw/openclaw/releases?per_page=20
- 影响判断：这是 Agent OS 方向的典型信号：产品力不只在模型回答，而在把 agent session、审批、移动端、云 worker 和本地/远端终端做成可恢复的运行时。对开发者而言，OpenClaw 本周更像“代理工作台基础设施”升级，降低了把 Claude Code、Codex、OpenCode 等工具统一纳管的摩擦。

### Dify
- 本周动态：Dify 本周发布 `v1.16.0`（GitHub Releases 显示 2026-07-17 11:14:06 UTC，上海时间 7月17日 19:14），核心是把 Dify Agent 从实验/预览推进到“Agent App Open Beta”。官方 release note 标题即为“Introducing Dify Agent (Beta): A New Agent Experience in Dify”，并明确警告“only to trusted, non-malicious users”，说明它引入了 shell/Linux sandbox 类能力但仍把安全边界作为首要注意事项。原文列出三块关键能力：其一，UI 中可设置 base prompt、上传 Skills/files，并连接 Dify 生态中的 tools/knowledge；其二，有一个“agent that helps you build Dify Agents”，可通过对话配置 Linux sandbox、安装包、创建 Skills/files；其三，Dify Workflow 可引用既有 Agent 或临时 inline Agent，执行 node 定义任务并把输出传给下游。除此以外，1.16.0 还把 workflow-as-MCP server 升到 MCP protocol 2025-06-18，支持 version negotiation、structured tool output，并允许 MCPClient 运行时注入动态 HTTP headers；同时把 OpenAI 插件新配置默认 API 类型从 Chat Completions 改为 Responses，以适配 GPT-5.6 系列的参数限制。我的判断是：Dify 正从“可视化 LLM workflow/RAG 平台”跨到“可发布的 sandbox agent 平台”，其优势是把 Agent、Workflow、MCP 和企业现有工具链整合在同一个低代码产品里。
- 关键数据：`v1.16.0` 发布于 2026-07-17T11:14:06Z；发布资产包含 `difyctl-v0.2.0-alpha` 多平台二进制（如 linux-x64 102,174,701 bytes、windows-x64.exe 117,276,160 bytes）；截至 2026-07-20 GitHub API 抓取，149,431 Stars、23,552 Forks、1,079 open issues。来源：https://api.github.com/repos/langgenius/dify/releases?per_page=20 ，https://api.github.com/repos/langgenius/dify
- 原文链接：https://github.com/langgenius/dify/releases/tag/1.16.0 ；https://api.github.com/repos/langgenius/dify/releases?per_page=20
- 影响判断：Dify Agent Open Beta 是本组最明确的产品拐点之一：低代码 workflow 厂商开始直接吸收 Claude Code/Codex 式 Linux sandbox agent 范式。若安全和多租户边界能稳定，Dify 对企业内部 agent 应用的落地速度会明显提升。

### Hermes Agent（自进化，增长最快）
- 本周动态：严格按本期时间窗（2026-07-13 至 2026-07-19 上海时间）核验，Hermes Agent 本周未发布新的 GitHub release；最近的正式发布是 `v2026.7.7.2 / Hermes Agent v0.18.2`，GitHub API 显示 published_at 为 2026-07-08T03:11:22Z，属于背景，非本周。不过它本周仍有显著公开信号：GitHub repo 元数据在 2026-07-20 抓取时显示 217,445 Stars、40,973 Forks，且 `pushed_at` 为 2026-07-20T08:19:49Z（已在本周窗口之后），说明主干仍高频活跃。原始 README 把它定位为“the self-improving AI agent built by Nous Research”，并称其有“built-in learning loop”，会从经验创建 skills、在使用中改进 skills、主动持久化知识、搜索过去会话，并跨 session 构建用户模型；同时支持 Telegram/Discord/Slack/WhatsApp/Signal/CLI、cron、subagents、RPC 工具调用、local/Docker/SSH/Singularity/Modal/Daytona 六类 terminal backend。最近的 `v0.18.2` 背景 patch 只是修 WhatsApp Baileys 依赖，`v0.18.1` 背景 release 披露 6 天内约 667 commits / 990 files / +89.5k/-10.4k，验证了“增长最快/自进化 agent”的工程节奏，但本周没有可写作“新版本发布”的重大公开动态。
- 关键数据：本周无新 release；背景：`v2026.7.7.2` 发布于 2026-07-08T03:11:22Z，修复 WhatsApp Baileys 依赖；截至 2026-07-20 GitHub API 抓取，217,445 Stars、40,973 Forks、24,015 open issues。来源：https://api.github.com/repos/NousResearch/hermes-agent/releases?per_page=10 ，https://api.github.com/repos/NousResearch/hermes-agent ，https://raw.githubusercontent.com/NousResearch/hermes-agent/main/README.md
- 原文链接：https://github.com/NousResearch/hermes-agent/releases/tag/v2026.7.7.2 ；https://github.com/NousResearch/hermes-agent ；https://raw.githubusercontent.com/NousResearch/hermes-agent/main/README.md
- 影响判断：本周结论应标为“静默但高活跃”。Hermes 的长期信号是把 memory、skills、自我改进、subagents 和多渠道运行时合并成完整 agent product；但本期时间窗内无正式发布，不能把 7月8日 release 误写成本周动态。

### Claude Code
- 本周动态：Claude Code 本周连续小步快跑，GitHub Releases 从 `v2.1.209` 到 `v2.1.215` 都落在 2026-07-14 至 2026-07-19。最值得关注的是安全/权限与并发 agent 工作流两条线。`v2.1.212`（2026-07-17 UTC）把 `/fork` 改成“copies your conversation into a new background session”，原来的 in-session subagent 语义改为 `/subtask`；并新增 session-wide WebSearch cap（默认 200，可用 `CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION` 调整）、subagent spawn cap（默认 200，可用 `CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION` 调整），长于 2 分钟的 MCP tool call 自动转后台。这说明 Claude Code 正在把“单会话编码助手”变成有后台 session、子任务、资源预算和长任务管理的 agent runner。`v2.1.214`（2026-07-18 UTC）则集中修权限绕过：修复 `dir/**` allow rule 错误放大到任意嵌套目录、Windows PowerShell 5.1 command permission-check bypass、Bash fd redirect 解析差异、超过 10,000 字符命令强制 prompt、zsh subscripts/modifiers 判断、help/man auto-approve 风险，以及 remote session confirmation race；同版还加入 EndConversation tool（用于 highly abusive users 或 jailbreak attempts）。`v2.1.215`（2026-07-19 UTC）进一步禁止 Claude 自行运行 `/verify` 和 `/code-review` skills，要求用户显式调用。整体看，Anthropic 本周重点是把自治能力收紧到可审计、可限额、可显式触发的轨道上。
- 关键数据：`v2.1.209` 2026-07-14T06:36:28Z；`v2.1.210` 2026-07-14T23:45:25Z；`v2.1.211` 2026-07-15T23:02:35Z；`v2.1.212` 2026-07-17T00:26:27Z；`v2.1.214` 2026-07-18T01:20:30Z；`v2.1.215` 2026-07-19T02:56:01Z。默认 WebSearch/subagent cap 均为 200，MCP auto-background 默认阈值 2 分钟，长命令 >10,000 characters 强制 prompt；截至 2026-07-20 GitHub API 抓取，138,390 Stars、22,205 Forks。来源：https://api.github.com/repos/anthropics/claude-code/releases?per_page=20 ，https://api.github.com/repos/anthropics/claude-code
- 原文链接：https://github.com/anthropics/claude-code/releases/tag/v2.1.212 ；https://github.com/anthropics/claude-code/releases/tag/v2.1.214 ；https://github.com/anthropics/claude-code/releases/tag/v2.1.215
- 影响判断：Claude Code 的路线从“强能力 coding agent”转向“强能力但带硬预算/硬权限边界的工程 agent”。这些修复并不花哨，但决定了企业把代理接入真实 repo、shell 和远程 session 时能否放心。

### Codex CLI（SWE-bench #1）
- 本周动态：OpenAI Codex CLI 本周在 0.144 稳定线和 0.145 alpha 线同时迭代。稳定线 `rust-v0.144.5` 于 2026-07-16T02:54:48Z 发布，原文写明“Improved dangerous-command detection, including more forced rm forms, and provides clearer rejection reasons when commands are denied”，说明其继续把 shell 执行安全作为 coding agent 的核心工程问题。`rust-v0.144.6` 于 2026-07-18T13:51:52Z 发布，主要“Refreshed bundled instructions for GPT-5.6 Sol, Terra, and Luna, and corrected their context windows to 272,000 tokens”，这类 bundled model metadata/instructions 对 CLI 体验非常关键：agent 是否正确估计上下文、是否选用合适 prompt、是否能在长任务里保持稳定，都依赖这些内置元数据。与此同时，`rust-v0.145.0-alpha.20/.22/.23/.24` 在 7月17日至18日持续放出，但 release note 只写“Release 0.145.0-alpha.xx”，未公开细节，因此不能扩写功能。关于用户给定的“SWE-bench #1”，本期我只在 Scale Labs leaderboard 页面发现与 coding/agentic benchmark 相关的数据片段，例如 leaderboard HTML 中出现 Meta “1 (Mini-SWE-Agent) xHigh” rank 2 score 42.2、GPT 5.4 (Codex) xHigh score 40.8 等，但未在 Codex CLI release note 本身看到本周新的 #1 声明；因此本周正文只记录可核验的 CLI 发布与安全/模型元数据变化。
- 关键数据：`rust-v0.144.5` 发布于 2026-07-16T02:54:48Z；`rust-v0.144.6` 发布于 2026-07-18T13:51:52Z；GPT-5.6 Sol/Terra/Luna context windows 更正为 272,000 tokens；截至 2026-07-20 GitHub API 抓取，99,846 Stars、14,942 Forks、10,241 open issues。来源：https://api.github.com/repos/openai/codex/releases?per_page=20 ，https://api.github.com/repos/openai/codex ，https://labs.scale.com/leaderboard
- 原文链接：https://github.com/openai/codex/releases/tag/rust-v0.144.5 ；https://github.com/openai/codex/releases/tag/rust-v0.144.6 ；https://api.github.com/repos/openai/codex/releases?per_page=20
- 影响判断：Codex CLI 本周的信号是“可靠性/安全性优先于新功能叙事”：危险命令检测、拒绝原因、模型上下文元数据，都是 agent 在真实工程目录里减少误操作的基础。0.145 alpha 高频发布说明下一轮功能在路上，但公开说明不足，暂不解读。

### Google ADK
- 本周动态：Google ADK 本周无重大公开动态。按 GitHub Releases 核验，`google/adk-python` 最近的主版本 `v2.4.0` 发布于 2026-07-07T19:45:22Z，`v1.36.1`/`v1.36.0` 也都是 2026-07-07 UTC，均不在本期 2026-07-13 至 2026-07-19 上海时间窗口内；本周窗口内没有新的 release。为了避免漏报，我同时查看了 GitHub repo 元数据，`pushed_at` 为 2026-07-17T21:15:08Z，说明仓库本周仍有代码活动，但没有对应 release note 或官方公告可作为“重大公开动态”。背景（非本周）中，v2.4.0 的方向仍值得记住：它加入 OpenAI Responses API support in labs、ManagedAgent backed by Managed Agents API、Workflow as Tool core feature、DaytonaEnvironment for remote sandbox workspaces、stream thought/media/code-exec/function-result deltas、Vertex AI session TTL/expiration、Anthropic effort/thinking 参数传递，以及多处 mTLS、MCP、security/path traversal 修复。这些表明 ADK 的路线是把 Google/Vertex 企业 agent runtime、managed agents、workflow-as-tool 和跨模型适配做厚，但本周没有新的公开发布可以写成动态。
- 关键数据：本周无 release；最近 `v2.4.0` 发布于 2026-07-07T19:45:22Z（背景，非本周）；截至 2026-07-20 GitHub API 抓取，20,771 Stars、3,721 Forks、639 open issues，仓库 `pushed_at` 为 2026-07-17T21:15:08Z。来源：https://api.github.com/repos/google/adk-python/releases?per_page=20 ，https://api.github.com/repos/google/adk-python
- 原文链接：https://github.com/google/adk-python/releases/tag/v2.4.0 ；https://api.github.com/repos/google/adk-python/releases?per_page=20
- 影响判断：ADK 本周属于“开发活跃、发布静默”。企业 agent 框架的底层能力在 7月7日已完成一轮大更新，本周没有新增公开节点，周报应保守标静默而非用背景凑数。

### OpenCode
- 本周动态：OpenCode 本周有密集 release，GitHub API 显示项目已重定向到 `anomalyco/opencode`，并在 2026-07-13 至 7月16日发布 `v1.17.19`、`v1.17.20`、`v1.18.0`、`v1.18.1`、`v1.18.2`、`v1.18.3`。核心变化集中在 Desktop v2、子代理安全边界和模型/提供商适配。`v1.18.0`（2026-07-14T20:29:48Z）说明“Completed the Desktop v2 migration”，包括新布局升级处理、first-launch onboarding，并提供新旧 layout 切换；还修复远程 session auto-accept permissions、terminal tab focus、timeline backfill/reconnect、composer caret、Home cold-load 等大量桌面体验问题。`v1.18.2`（2026-07-15T16:15:38Z）明确“Stopped subagents from launching nested subagents by default”，并允许通过 `subagent_depth` 配置需要时的深度，这是与 Claude Code 同方向的 agent 资源/风险边界收紧。`v1.17.19`/`v1.17.20` 还涉及 OpenAI pro reasoning mode、Luna Responses Lite OAuth、GPT-5.6 Codex context limits、Azure AI GPT-5.6 support，以及移除可能影响 OpenAI Luna Responses Lite 的旧 Codex workaround。`v1.18.3`（2026-07-16T15:34:33Z）继续改善 subagent picker、Desktop home page/session search、WSL server readiness。整体看，OpenCode 的本周路线是把开源 coding agent 从 TUI/CLI 推向更成熟的 Desktop 工作台，同时对 subagent 递归和权限自动接受做边界化。
- 关键数据：`v1.17.19` 2026-07-13T16:34:56Z；`v1.17.20` 2026-07-13T21:09:56Z；`v1.18.0` 2026-07-14T20:29:48Z；`v1.18.2` 2026-07-15T16:15:38Z；`v1.18.3` 2026-07-16T15:34:33Z；截至 2026-07-20 GitHub API 抓取，187,643 Stars、23,599 Forks、4,746 open issues。来源：https://api.github.com/repos/sst/opencode/releases?per_page=20 （重定向至 anomalyco/opencode），https://api.github.com/repos/sst/opencode
- 原文链接：https://github.com/anomalyco/opencode/releases/tag/v1.18.0 ；https://github.com/anomalyco/opencode/releases/tag/v1.18.2 ；https://github.com/anomalyco/opencode/releases/tag/v1.18.3
- 影响判断：OpenCode 本周显示开源 coding agent 正从命令行工具进入桌面化、多会话化阶段。`subagent_depth` 的引入说明生态已经意识到递归代理调用的成本与安全问题，未来 agent framework 的默认策略会更保守。

### Scale AI（SEAL）
- 本周动态：Scale AI / Scale Labs 本周有公开页面更新，但没有发现单独的 SEAL 产品 release note 或博客公告。可核验的本周动态是 Scale Labs leaderboards / Showdown 页面在 2026-07-20 抓取时的 schema `datePublished/dateModified` 显示为 2026-07-20（上海时间触发日当天，严格说已超出本期自然周），而 Brave 搜索在时间过滤内返回 Scale Labs leaderboard 结果“published 10 hours ago”、Instruction-Following leaderboard “published 2 days ago”。不过本任务时间窗截止到 7月19日 24:00，因此我不把 7月20日页面时间写成本周动态。作为验证依据，我打开了原始 Scale Labs 页面：`/leaderboard` 是 AI model leaderboards & benchmarks 汇总；`/leaderboard/instruction_following` 的原文 Dataset schema 写明“Scale SEAL Instruction-Following Leaderboard ranks top AI models on their ability to interpret and execute detailed, precise, and specific commands”，并说明 Precise Instruction Following Prompts Dataset 有 1,054 prompts、9 categories，使用 private prompts + human evaluations，页面标注“Deprecated (as of January 2025)”；当前榜单片段显示 o1 (Dec 2024) 91.96±1.60、DeepSeek R1 87.75±1.91 等旧榜。`/showdown` 原文定位为“Real people. Real conversations. Real rankings.”，强调盲选、可选、自然投票。结论：本期没有可确认的 7月13-19 SEAL 新发布；可写的是 Scale Labs 评测体系持续作为行业基准背景。
- 关键数据：本周窗口内未发现 SEAL 新 release；背景验证：Instruction-Following 页面 Dataset 描述称 1,054 prompts、9 categories、private prompts + human evaluations；榜单片段 o1 91.96±1.60、DeepSeek R1 87.75±1.91；Showdown 页面显示“Prompts compared 0 / Active users 0”（web_fetch 可见文本，可能为未加载 JS 前的占位）。来源：https://labs.scale.com/leaderboard/instruction_following ，https://labs.scale.com/leaderboard ，https://labs.scale.com/showdown
- 原文链接：https://labs.scale.com/leaderboard ；https://labs.scale.com/leaderboard/instruction_following ；https://labs.scale.com/showdown
- 影响判断：Scale 的价值仍在“第三方评测基础设施”，但本期不应制造新品叙事。值得跟踪的是其 SEAL/Scale Labs 是否把 agentic coding、安全、真实用户偏好评测合并成更权威的企业采购基准。

### Cohere（Command R+）
- 本周动态：Cohere / Command R+ 本周无重大公开动态。按时间窗搜索与官网验证，我没有发现 2026-07-13 至 2026-07-19 期间 Cohere 官方博客、模型卡或 release note 中关于 Command R+ 的新版本发布。打开 Cohere 官方博客首页，页面只抽取到订阅与更新说明，未呈现本周 Command R+ 相关文章；Brave 时间过滤搜索结果主要是第三方价格页、AWS Bedrock 上 Cohere 模型页、百科/awesome 列表等，不能作为“本周官方动态”。背景信息上，Command R+ 仍是 Cohere 面向 RAG、企业工具调用和多语言/检索增强场景的代表模型；第三方搜索摘要提到 2026 自助生产 key 仍列 Command R+、Command R、Command R7B、Embed v3、Rerank v3 等产品线，但这不是本周官方发布，且价格/参数没有在本次原始官方页面中交叉验证，因此不写入关键结论。对本组任务而言，本周只能保守记录：未发现 Command R+ 在时间窗内有新的官方模型 release、benchmark 声明或重要 API 变更。
- 关键数据：—（本周未发现官方新 release / benchmark / 参数变更）；验证搜索命中多为第三方价格页与 AWS Bedrock 产品页，非 Cohere 本周原始发布。来源：https://cohere.com/blog ，https://aws.amazon.com/bedrock/cohere/
- 原文链接：https://cohere.com/blog ；https://aws.amazon.com/bedrock/cohere/ ；未发现时间窗内 Command R+ 原始发布
- 影响判断：Command R+ 本周处于公开静默期。Cohere 的企业 RAG/工具调用定位仍清晰，但在 agent 框架工具周报里，本期没有足够证据显示其路线发生新拐点。

### SSI（SSI-1）
- 本周动态：SSI / SSI-1 本周无重大公开动态。按时间窗搜索和官网验证，我没有发现 Safe Superintelligence Inc. 在 2026-07-13 至 2026-07-19 发布 SSI-1 模型、技术报告、benchmark、API 或产品公告。打开 SSI 官网原始页面，页面仍是公司使命介绍：称“Building safe superintelligence (SSI) is the most important technical problem of our time”，并写明“one goal and one product: a safe superintelligence”，强调 safety and capabilities in tandem、scale in peace、无 product cycles 干扰、办公室在 Palo Alto 和 Tel Aviv、招聘 lean team。官网页脚为 © 2024-2026，包含 Apply / Updates / Contact 链接，但本次抓取未看到 SSI-1 模型发布。GitHub 搜索 `SSI-1 safe superintelligence` 结果 total_count 为 0，也未提供可核验代码/模型卡线索。因此本期必须标注“本周无重大公开动态”，不能把 SSI 的长期使命或市场传闻改写成 SSI-1 发布。
- 关键数据：—（未发现 SSI-1 本周公开发布）；官网验证时间 2026-07-20 抓取，页面仅含公司使命与招聘入口；GitHub Search `SSI-1 safe superintelligence` total_count=0。来源：https://ssi.inc/ ，https://api.github.com/search/repositories?q=SSI-1%20safe%20superintelligence&sort=updated&order=desc&per_page=10
- 原文链接：https://ssi.inc/ ；未发现时间窗内 SSI-1 原始发布
- 影响判断：SSI 本周的信号是“高度静默”。对周报读者而言，真正需要关注的是其何时从使命叙事进入可验证模型/技术报告阶段；在没有公开材料前，应避免将招聘页或传闻包装成模型进展。

---

### ⚡ 算力云硬件

### NVIDIA（GPU/CUDA/Blackwell）
- 本周动态：本周 NVIDIA 公开动作很密集，核心信号是把 Blackwell/Thor/Rubin 从“芯片发布”推进到国家级 AI 工厂与机器人边缘计算落地。7月16日 NVIDIA Newsroom 宣布与 Noetra Corp. 合作，为日本 FRONTia Project 建设面向 physical AI 的 Vera Rubin AI factory；原文明确写到该工厂包含 13,750 颗 Vera CPU、27,500 颗 Rubin GPU，基于 Vera Rubin NVL72 与 DSX 平台，配套 Spectrum-X Ethernet、BlueField DPU，目标是 140MW 数据中心容量，并训练开放多模态基础模型，服务 AI agents、digital twins、robotics 和 physical AI。7月15日官方博客又发布 Jetson Thor 新模块 T3000/T2000：T3000 以约 T5000 一半尺寸和功耗给出 865 FP4 TFLOPS，Blackwell GPU + 8核 Neoverse Arm CPU + 32GB LPDDR5X + 273GB/s 带宽；T2000 提供 400 FP4 TFLOPS 和 16GB 内存。NVIDIA 同时把 Cosmos 3 Edge 4B 模型带到 Thor 平台，并称开发者可在 JetPack 7.2.1 中使用 T3000 emulation，T3000/T2000 计划 2027Q1 供货。7月17日 Vera Rubin 博客则把叙事转向 agentic AI 后训练经济性：连续 post-training 与 cost per token/intelligence per dollar 绑定，Vera Rubin 被定位为比 Blackwell 代际更进一步的 AI factory 平台。
- 关键数据：13,750 Vera CPUs、27,500 Rubin GPUs、140MW（NVIDIA Newsroom，2026-07-16，https://nvidianews.nvidia.com/news/japan-government-industrial-leaders-and-nvidia-launch-the-worlds-first-national-ai-infrastructure）；Jetson T3000 865 FP4 TFLOPS、32GB LPDDR5X、273GB/s、25GbE，T2000 400 FP4 TFLOPS/16GB，2027Q1 可用（NVIDIA Blog，2026-07-15，https://blogs.nvidia.com/blog/jetson-thor-robotics-edge-ai-agent/）；Vera 平均 CPU 吞吐较替代 x86 架构高 30%（NVIDIA Blog，2026-07-17，https://blogs.nvidia.com/blog/nvidia-vera-rubin-post-training-intelligence-per-dollar/）。
- 原文链接：https://nvidianews.nvidia.com/news/japan-government-industrial-leaders-and-nvidia-launch-the-worlds-first-national-ai-infrastructure；https://blogs.nvidia.com/blog/jetson-thor-robotics-edge-ai-agent/；https://blogs.nvidia.com/blog/nvidia-vera-rubin-post-training-intelligence-per-dollar/
- 影响判断：NVIDIA 本周把算力叙事从单卡性能转为“AI 工厂—机器人—边缘端”的整栈路线：Rubin 负责国家/产业级训练，Thor 负责机器人端侧推理。对竞争者而言，难点不只是 GPU，而是 CPU、网络、DPU、软件栈、模型和开发者迁移路径的组合锁定。

### AWS（Bedrock/Trainium/SageMaker）
- 本周动态：AWS 本周有多条 AI 云服务更新，其中更值得算力/云硬件组关注的是 Bedrock 模型供给和 SageMaker HyperPod 训练集群调度。7月13日 AWS Machine Learning Blog 宣布 OpenAI GPT-5.6 Sol、Terra、Luna 在 Amazon Bedrock GA，强调这些模型运行在 Bedrock 的下一代推理引擎 Mantle 上，价格匹配 OpenAI first-party rates，使用量计入现有 AWS commitments；原文给出 Sol 在 Artificial Analysis Coding Agent Index 达 80 分、ExploitBench 73.5%（对比 GPT-5.5 47.9%）、Agents’ Last Exam 53.6 等基准，并将其定位到 autonomous coding、漏洞研究和药物发现等长链路 agentic 工作流。7月16日 AWS 又宣布 xAI Grok 4.3 在 Bedrock GA，关键规格是 100万 token 上下文、文本和图像输入、可配置 reasoning effort（none/low/medium/high），同样跑在 Mantle 并通过 OpenAI-compatible APIs 访问。训练侧，7月17日 AWS What’s New 发布 SageMaker HyperPod Slurm 集群 partition-level topology：同一集群不同 partition 可分别使用 block/tree topology，p6e-gb200 UltraServer 用 block，p5/p5e/p5en 这类分层互联实例用 tree，且随扩缩容/节点替换自动维护。这个更新虽不是 Trainium 新硬件，但直接指向大模型分布式训练的 GPU 网络拓扑利用率和 NCCL collective 效率。
- 关键数据：GPT-5.6 Sol：AA Coding Agent Index 80、ExploitBench 73.5%、Agents’ Last Exam 53.6（AWS Blog，2026-07-13，https://aws.amazon.com/blogs/machine-learning/openai-gpt-5-6-sol-terra-and-luna-are-now-generally-available-on-amazon-bedrock/）；Grok 4.3：100万 token context、text/image input、reasoning effort none/low/medium/high（AWS Blog，2026-07-16，https://aws.amazon.com/blogs/machine-learning/introducing-grok-on-amazon-bedrock/）；HyperPod：p6e-gb200.36xlarge block topology，p5/p5e/p5en tree topology，Slurm 25.11+，默认启用（AWS What’s New，2026-07-17，https://aws.amazon.com/about-aws/whats-new/2026/07/hyperpod-partition-topology-slurm/）。
- 原文链接：https://aws.amazon.com/blogs/machine-learning/openai-gpt-5-6-sol-terra-and-luna-are-now-generally-available-on-amazon-bedrock/；https://aws.amazon.com/blogs/machine-learning/introducing-grok-on-amazon-bedrock/；https://aws.amazon.com/about-aws/whats-new/2026/07/hyperpod-partition-topology-slurm/
- 影响判断：AWS 的路线是“模型市场 + 托管推理引擎 + 训练集群运维抽象”并进，Bedrock 持续补齐前沿模型供给，HyperPod 则把底层拓扑细节产品化。对企业客户的价值在于减少选型和运维摩擦，但 AWS 自研 Trainium 本周未见重大新公开动态，GPU/UltraServer 仍在关键训练更新中占据显著位置。

### Azure（Azure AI/OpenAI Service，独立追踪云业务）
- 本周动态：Azure 本周在 AI 云业务侧的主要公开动态集中在 Microsoft Foundry / Agent Framework，而非单独的 Azure OpenAI Service 模型上新。根据 Microsoft Azure service updates RSS，7月15日 Microsoft Foundry 连续发布 Agent Framework 相关更新：多智能体编排 SDK 支持 C# 与 Python，整合此前分散在 AutoGen 与 Semantic Kernel 的模式；Agent Harness 作为生产运行时进入 GA；多智能体 orchestration patterns（含 Magentic）GA，官方描述中给出 Magentic 在 GAIA 上 38% 的结果，并在 AssistantBench、WebArena 上有竞争力表现；同时发布 GitHub Copilot 与 Claude Code connectors，使 .NET/Python agents 可把编码任务委托给两类 coding agents；另有 Tracing、DevUI Agent Inspector、Agent Channel、episodic procedural memory、CodeAct pattern + Hyperlight containers 等预览能力，用于观测、调试、通信和降低多步骤工具调用开销。技术判断上，Azure 的重点不是单一模型参数，而是把 agent 开发框架、运行时、可观测性、企业工具连接器放入 Foundry 体系，形成对 AWS Bedrock AgentCore / Google Vertex AI Agent 的平台级对抗。云业务上，这类“agent middleware”会拉动模型调用、托管运行时、监控和数据源连接消费，属于 Azure AI 从模型 API 向应用运行层上移的信号。
- 关键数据：2026-07-15 多项 Microsoft Foundry / Agent Framework 更新；Magentic orchestration pattern 官方描述 GAIA 38%（Microsoft Azure service updates RSS，2026-07-15，https://www.microsoft.com/releasecommunications/api/v2/azure/rss）；Agent Harness GA、GitHub Copilot/Claude Code connectors GA，Tracing/DevUI/Agent Channel/CodeAct 等多项 public preview（同源 RSS 各 item：563546、563701、564071、563551、563556、563566）。
- 原文链接：https://www.microsoft.com/releasecommunications/api/v2/azure/rss；https://azure.microsoft.com/en-us/updates/
- 影响判断：Azure 本周的信号是“AI 应用平台化”而不是“底层 GPU/CPU 容量扩张”。对企业客户来说，Foundry Agent Framework 把多智能体编排、生产运行、调试和工具接入做成云原生能力，未来会增强 Azure AI 与 Microsoft 365/GitHub/数据平台的粘性。

---

### 🦾 具身机器人

### 宇树 Unitree（H1/G1）
- 本周动态：本周无重大公开动态。验证依据：已检索 2026-07-13 至 2026-07-19 时间窗的 Unitree H1/G1 相关公开消息，并打开 Unitree 官方 News Center 与官网；官方 News Center 在本次抓取中显示的最新条目为 2026-06-01 “Unitree Announces H2 Plus, an NVIDIA Isaac GR00T Reference Humanoid Robot for Academic Research”，再前为 2026-05-31 春晚/功夫展示等，G1/H1 页面相关公开条目为 2024-07-05 G1 和 2025-02-05 H1 旧闻，未发现时间窗内 H1/G1 的官方产品发布、量产交付、客户部署、融资或关键技术公告。搜索结果中有若干 7月中旬第三方博客/行业站提及 Unitree IPO、G1/H1 价格与 H1 Pro 未来发布节奏，但未能在 Unitree 官方站或可核验原始公告中确认，且部分信息超出本周窗口或指向未来日期，因此不纳入本周动态。
- 关键数据：—
- 原文链接：https://www.unitree.com/news/；https://www.unitree.com/；未发现时间窗内 H1/G1 原始发布。
- 影响判断：Unitree 本周在官方信源层面相对静默，说明其 H1/G1 线没有可确认的新节点。第三方舆论仍围绕低成本量产、IPO 和全球化展开，但在缺少原始公告前不宜把它当成本周事实。

### 优必选 UBTech（Walker S）
- 本周动态：本周 UBTECH 没有发现 Walker S 系列的新产品、交付或客户部署原始公告，但有一条与公司资本流动性相关的官方动态。7月16日 22:00，港交所披露 UBTECH ROBOTICS CORP LTD《INSIDE INFORMATION - COMPLETION OF THE H SHARE FULL CIRCULATION BY THE COMPANY》公告；公告称公司 5,453,931 股内资股转换为 H 股已于 2026年7月16日完成，转换后 H 股将于 2026年7月17日上午9:00 在港交所开始上市交易，参与股东可在完成适用境内安排程序后买卖转换 H 股。转换完成后，公司内资股从 70,665,977 股降至 65,212,046 股，占比由 14.04% 降至 12.95%；H 股从 432,735,396 股增至 438,189,327 股，占比由 85.96% 升至 87.05%，总股本仍为 503,401,373 股。技术/商业判断：这不是 Walker S 的技术节点，但对 UBTECH 这类重研发、重供应链投入的具身机器人公司而言，H 股全流通提高二级市场可交易股份比例和资本灵活性，可能为后续工业人形机器人量产、渠道和客户交付提供更顺畅的资本市场基础。Walker S 本周的产品侧仍应标为未见新增公开原始动态。
- 关键数据：5,453,931 股内资股完成 H 股转换；H 股 438,189,327 股、87.05%；内资股 65,212,046 股、12.95%；总股本 503,401,373 股；转换完成日 2026-07-16，上市交易开始 2026-07-17 09:00（HKEX/UBTECH 公告，2026-07-16，https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0716/2026071601337.pdf）。
- 原文链接：https://www1.hkexnews.hk/search/titleSearchServlet.do（按股票 09880、2026-07-13 至 2026-07-19 查询得公告）；https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0716/2026071601337.pdf
- 影响判断：UBTECH 本周的可验证新增信号偏资本市场而非机器人本体，不能外推为 Walker S 新交付或新客户。其意义在于改善上市股份流通结构，给人形机器人量产周期中的融资、股权激励或股东退出预期提供更高弹性。

### Figure AI（Figure 02）
- 本周动态：本周无重大公开动态。验证依据：已检索 2026-07-13 至 2026-07-19 的 Figure AI / Figure 02 相关新闻，并打开 Figure 官网 News 页面和首页；Figure 新闻页本次抓取仅显示订阅入口及社交媒体链接，未呈现时间窗内公司原始公告。搜索结果中 7月13日有媒体转述 BMW Group 在 Spartanburg 推进 Figure 03 物流排序应用，并提到 Figure 02 曾在 10个月内支持超过 30,000 辆 BMW X3 生产；但打开 BMW Group PressClub 原始来源后，原始发布时间为 2026-06-25，属于“背景，非本周”，不能计为本期新动态。该 BMW 原文确认的背景信息包括：Figure 02 在 BMW Spartanburg body shop 插入焊接所需钣金件，Figure 03 将转向 logistics sequencing，新增软组件、无线充电、speech-to-speech audio、带触觉传感器和掌心摄像头的改进手部。因这些关键事实均来自 6月25日原始发布，本周只记录为背景核验，不计入有料。
- 关键数据：—
- 原文链接：https://www.figure.ai/news；https://www.figure.ai/；背景，非本周：https://www.press.bmwgroup.com/global/article/detail/T0458778EN/bmw-group-advances-the-use-of-physical-ai-in-production-with-figure-03-project-in-spartanburg?language=en
- 影响判断：Figure 02/03 与 BMW 的生产线验证仍是具身机器人商业化的重要背景，但本周没有新的官方节点。当前应避免把媒体在 7月13日的再报道误记为 Figure 本周新增交付或部署。

---

## 📋 质量门控自检

- 覆盖率：38/38（100%），其中有动态 23 个、静默/无重大公开动态 15 个。
- 原文深度抽查：5/5 通过；抽查对象为 OpenAI Codex changelog、Kimi K3、NVIDIA Jetson Thor、Dify v1.16.0、Sierra Horizon。URL 可访问，关键数据与原文对齐。
- 判断质量：每个有料对象均含影响判断；三条主线覆盖基座/企业 Agent/算力具身。
- 数据可信：关键数据均带 URL + 日期或明确标注未公开/背景非本周；未发现编造数据。
