# 全球 AI 动态周报 · 第 2 期（2026-05-31 ~ 06-06）

> **覆盖区间**　2026-05-31（周日）00:00 → 06-06（周六）24:00｜上海时区
> **覆盖范围**　38 个 AI 主体 · 6 大赛道 · 实质覆盖 38/38（100%）
> 全部信息严格限定在上述自然周内；窗口外动态仅作背景标注，不计入"本周动态"。

---

## 本周一句话

> **模型发布相对沉寂，平台 / Agent / 资本 / 算力动作密集。** 行业正从"模型军备竞赛"迈入"Agent 生产化与商业化落地"新阶段：基座厂转向发平台、发 Agent、发资本；编码 Agent 全面企业化 + 多智能体编排；NVIDIA 算力全栈通吃；中国具身机器人量产元年坐实。

---

## 🔥 本周 TOP 5

### 1. NVIDIA GTC Taipei：算力从云端杀向 PC 与机器人本体 ｜ 6/1
黄仁勋在台北 Computex 期间的 GTC Taipei 2026 主题演讲一口气抛出三条新战线。①**消费 PC 线**：发布 **RTX Spark 超级芯片**，将 CPU 与 GPU 融合于一颗芯片，定位"AI 个人电脑"，可本地运行 AI agent，微软、戴尔等将于 2026 秋季推出搭载机型；黄仁勋称这是"40 年来首次跨产品线的 PC 重新发明"。②**数据中心线**：新一代 **Vera CPU 已全面量产**，早期客户含 Anthropic、OpenAI、SpaceXAI。③**机器人线**：发布 **NVIDIA Isaac GR00T 人形机器人参考设计**（本体用宇树 H2 Plus、大脑用 Jetson AGX Thor T5000，内含 Blackwell GPU、2070 FP4 TFLOPS）。消息刺激 NVDA 盘前涨近 4%，Intel、AMD 均跌超 3%。
**↳ 为什么重要**：NVIDIA 正从"数据中心 GPU 霸主"向"端-边-云全栈算力"扩张，RTX Spark 直插 Intel/AMD 腹地，Jetson Thor + Isaac GR00T 卡位具身智能本体算力，意图通吃 AI 每一层。
[Fortune 报道](https://fortune.com/2026/06/01/jensen-huang-nvidia-pc-reinvention-ai-chips/) · [NVIDIA 官方](https://nvidianews.nvidia.com/news/nvidia-open-humanoid-robot-reference-design)

### 2. 宇树"三喜临门"：产能破万 + IPO 过会 + 英伟达联姻 ｜ 6/1–6/2
中国人形机器人量产元年的标志性一周。①**产能破万**：6/2 官宣，截至 2026 年 5 月单款双足人形累计下线约 **11000 台**，新基地设计年产能达 7.5 万台、较 2025 年增约 12 倍。②**IPO 闪电过会**：6/1 上交所科创板上市审核委审议通过宇树首发申请，从 3/20 受理到过会仅 **73 天**刷新最快纪录，拟募资 42.02 亿元，整体估值约 420 亿元，有望成 A 股"人形机器人第一股"。③**英伟达联姻**：黄仁勋在 GTC 台北宣布与宇树战略合作，以宇树 H2 Plus 为本体、英伟达提供 Jetson Thor + Isaac GR00T 大脑。
**↳ 为什么重要**：三重利好叠加于一周，是宇树乃至中国人形机器人产业的"奇点时刻"；被英伟达选为首个开放人形参考设计本体，等同获得全球算力龙头的"出货背书"。
[新浪财经](https://finance.sina.com.cn/wm/2026-06-02/doc-inhzzivp1611572.shtml) · [NVIDIA 官方](https://nvidianews.nvidia.com/news/nvidia-open-humanoid-robot-reference-design)

### 3. MiniMax M3 发布：中国首个集齐"前沿 Coding + 1M 上下文 + 原生多模态"的开源模型 ｜ 6/1
儿童节正式发布第三代旗舰 **MiniMax M3**，采用自研稀疏注意力架构 **MiniMax Sparse Attention（MSA）**：索引分支快速扫描筛选关键 Token，再交稀疏计算分支精算，把长上下文复杂度从 O(n²) 大幅压缩。官方称 M3 是国内首个同时具备"前沿 Coding + 1M 超长上下文 + 原生多模态"三项能力、且**全球唯一具备完整能力组合的开源选项**。性能：100 万上下文下单 token 计算量仅为上代约 **1/20**，对比 M2 Prefilling 提速 **9.7×**、Decoding 提速 **15.6×**；**SWE-Bench Pro 59.0%**（超 GPT-5.5 和 Gemini 3.1 Pro、接近 Opus 4.7）、Terminal Bench 2.1 66.0%。同日 MiniMax Code 更新，Token Plan 拉入"百元时代"（Plus 49 元/6 亿 token、Max 119 元/18 亿、Ultra 469 元/55 亿）。
**↳ 为什么重要**：中国开源模型首次集齐三项核心能力，对海外闭源旗舰构成实质挑战；MSA 把长上下文推理成本砍到 1/20，是"Agent 经济学"的关键突破；百元 Token Plan 意在抢占全球开发者生态。
[凤凰财经](https://finance.ifeng.com/c/8tbcJ4uwXfq) · [36氪](https://eu.36kr.com/zh/p/3837463161244161) · [官方](https://www.minimaxi.com/news/minimax-m3-zh)

### 4. DeepSeek 首次对外融资：约 74 亿美元、估值 590 亿美元 ｜ 6/3
据路透社等报道，长期靠母公司幻方资金自给的 DeepSeek 正筹备**首轮融资约 74 亿美元（约 500 亿元人民币）**，投资方包括**腾讯与宁德时代 CATL** 等，估值最高可达 **590 亿美元**，有望跻身中国规模最大的私募科技融资之一。这是这家以低成本高性能开源模型闻名的中国 AI 公司**首次对外融资**，标志其从"研究驱动的隐形冠军"转向资本化扩张。
**↳ 为什么重要**：74 亿美元融资 + 590 亿估值是中国 AI 资本市场的标志性事件；腾讯 + CATL 入局意味"互联网巨头 + 硬科技/能源"对算力时代的押注，资金或解决 DeepSeek 长期算力瓶颈；也意味其从纯研究走向商业化扩张，需关注开源策略是否持续。
[Reuters](https://www.reuters.com/business/retail-consumer/deepseek-slated-draw-7-billion-maiden-fundraising-sources-say-2026-06-03/) · [Tech Startups](https://techstartups.com/2026/06/03/deepseek-set-to-raise-7-4-billion-in-first-funding-round-targeting-valuation-as-high-as-59-billion/)

### 5. 微软 Build 2026：全栈"AI Agent 平台"+ 自研 MAI 模型去 OpenAI 依赖 ｜ 6/2–6/3
微软在旧金山 Build 2026 把 Windows + Copilot + Azure 整体重塑为"AI Agent 平台"。①**Microsoft Agent Framework** 编排构建块转 stable（与 GitHub Copilot SDK、Claude Agent SDK 集成）；**Hosted agents** 预计 7 月初 GA；Memory in Foundry、Toolboxes、Foundry IQ（含 Web IQ 实时联网 grounding）全线公开预览。②**自研 MAI 模型家族**：MAI-Code-1-Flash（vibe coding，已接入 GitHub Copilot）、MAI-Thinking-1（推理，Foundry 私有预览）、Aion 小模型（Windows 本地）；Suleyman 称定制后成本效率比 GPT-5.5 高 **10 倍**。③下一代 Phi-4 已驱动部分 Copilot 功能。
**↳ 为什么重要**：微软从"OpenAI 独家分销商"转向"自建前沿模型 + 多模型并存"，既降本又夺回模型层控制权；全栈 agent 平台把治理/可观测/记忆/grounding 做成开箱即用，直击企业生产化痛点。
[Foundry 博客](https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-build-2026/) · [CNBC](https://www.cnbc.com/2026/06/02/microsoft-unveils-new-ai-models-lessen-reliance-on-openai-lower-costs.html)

---

## 🧭 三条主线趋势

**① 从"发模型"集体转向"发平台 / 发 Agent / 发资本"。**
本周真正有硬动态的基座厂高度集中在产品化与生态：Google（Gemma 4 12B，encoder-free 端侧多模态）、Microsoft（Build 2026 全栈 agent 平台）、OpenAI（求职入口/记忆翻倍/Lockdown Mode/英国广告）、DeepSeek（74 亿美元首轮融资）。"模型即基础设施、Agent 即产品"成为主线，竞争焦点从参数/benchmark 转向 agent 运行时、记忆、grounding、治理。

**② "本地通用 Agent + Agent 经济学"成为最强共振信号。**
Kimi Work（300 子 Agent 集群、本地干活）、Perplexity 混合本地-服务器推理编排器、Cursor Design Mode、Devin Desktop 的 Agent Command Center——头部产品本周不约而同把"Agent 从云端 Chat 下沉到端侧/桌面、跨应用自主执行真实任务"作为主攻方向。底层则是 token 经济学之争：Glean Waldo（延迟 -50%/token -25%）、MiniMax MSA（计算量 1/20）、Perplexity 端云路由——谁能在不牺牲能力的前提下把推理成本压下来，谁就能让 Agent 规模化普及。

**③ 算力全栈化 + 具身机器人量产元年坐实。**
NVIDIA 以 RTX Spark 杀入 PC、Vera 量产卡数据中心、Jetson Thor + Isaac GR00T 卡机器人本体，意图通吃端-边-云；AWS/Azure 在模型层激烈卡位（OpenAI 模型登陆 AWS 打破 Azure 独占，微软反手推自研 MAI）。具身侧宇树产能破万 + IPO 过会、优必选下探 C 端超仿生陪伴、Figure 拿下零售仓储订单，三条路径同周坐实"商业订单替代试点"。

---

## 📊 赛道速查表（导航索引）

> 🔥重大 ｜ 🟢一般 ｜ 🟡边缘 ｜ ⚪️静默

### 🧠 大模型基座
| 对象 | 本周 | 一句话 |
|------|------|--------|
| Google DeepMind | 🔥 | Gemma 4 12B：encoder-free 统一多模态，16GB 笔记本可跑 |
| Microsoft | 🔥 | Build 2026 全栈 agent 平台 + 自研 MAI 模型（详见 TOP 5） |
| OpenAI | 🟢 | 求职入口/记忆翻倍/Lockdown Mode/英国广告四线并进 |
| DeepSeek | 🔥 | 首轮融资 74 亿美元、估值 590 亿（详见 TOP 5） |
| xAI | 🟢 | Grok Imagine 上线 Quality Mode、Composer 2.5 |
| Anthropic | 🟡 | 仅企业自定义角色新增 admin 权限（Opus 4.8 在窗前） |
| Meta AI | 🟡 | Behemoth 延迟、EU 许可争议、股价承压（多为二手） |
| Databricks | 🟡 | Summit 预热 + Vector Search 更名 AI Search |
| Mistral AI | 🟡 | 仅 mistral-common v1.11.2/1.11.3 SDK 迭代 |
| 字节跳动 | ⚪️ | 静默期，弹药集中到 6 月中 Force 大会 |

### 🤖 垂直 Agent 产品
| 对象 | 本周 | 一句话 |
|------|------|--------|
| Anysphere (Cursor) | 🔥 | 3.7 版 Design Mode 多选元素 + 语音输入 + SDK 升级 |
| Cognition (Devin) | 🔥 | Windsurf 升级 Devin Desktop，首发支持开源 ACP 协议 |
| Perplexity | 🔥 | 首个混合本地-服务器推理编排器 |
| Glean | 🟢 | 新增 NVIDIA Nemotron 3 Ultra 支持，平台接入 30+ 模型 |
| Harvey | 🟢 | 《为每个事项定制法律 Agent》+ 大律所计时收费被动摇 |
| Midjourney | 🟡 | Office Hours：v8.2 待发、v8.1 转默认 |
| Sierra | ⚪️ | 5 月 megaround 后消化期，无新公开动作 |

### 🇨🇳 中国公司
| 对象 | 本周 | 一句话 |
|------|------|--------|
| MiniMax | 🔥 | M3 发布，国内首个集齐三项能力的开源模型（详见 TOP 5） |
| 月之暗面 (Kimi) | 🔥 | Kimi Work Beta 内测，300 子 Agent 集群、92% 代码 AI 生成 |
| 阿里云 (Qwen) | ⚪️ | 5/20 峰会发 Qwen3.7-Max 后执行期 |
| 智谱 (GLM) | ⚪️ | 2 月 GLM-5、4 月 GLM-5.1 后迭代消化期 |
| 腾讯 (混元) | ⚪️ | "先偿内债"，4 月混元 3.0 后内部落地期 |

### 🛠️ Agent 框架工具
| 对象 | 本周 | 一句话 |
|------|------|--------|
| Claude Code | 🔥 | 每日发布：fallbackModel、managed settings 版本锁定、跨会话安全 |
| Codex CLI | 🔥 | rust-v0.137.0 + 多智能体 v2 + goal extension + 远程控制 |
| Google ADK | 🔥 | v2.2.0：默认模型切 gemini-3-flash-preview + OTel 原生 |
| OpenClaw | 🟢 | 2026.6.5 月度补丁：新增 Parallel 搜索 provider + 错误恢复 |
| OpenCode | 🟢 | 仓库迁 anomalyco、启动 +38%、新增 Snowflake Cortex |
| Hermes Agent | 🔥 | NVIDIA 官方将其选为 NemoClaw 蓝图 harness 层 |
| Dify | ⚪️ | v1.14.2（5/19）后发布间隙，无新 tag |
| Scale AI | ⚪️ | Scale Labs 评测榜单常态更新，无里程碑 |
| Cohere | 🟢 | 开源数据可视化工具 co/plot 发布 |
| SSI | ⚪️ | 零产品纯研究，仅外部估值梳理（$32B） |

### ⚡ 算力云硬件
| 对象 | 本周 | 一句话 |
|------|------|--------|
| NVIDIA | 🔥 | GTC Taipei：RTX Spark + Vera 量产 + Isaac GR00T（详见 TOP 5） |
| AWS | 🔥 | GPT-5.5/5.4 + Codex 登陆 Bedrock GA，打破 Azure 独占 |
| Azure | 🔥 | Build 推自研 MAI 去 OpenAI 依赖（详见 TOP 5） |

### 🦾 具身机器人
| 对象 | 本周 | 一句话 |
|------|------|--------|
| 宇树 Unitree | 🔥 | 产能破万 + IPO 过会 + 英伟达联姻（详见 TOP 5） |
| 优必选 UBTech | 🔥 | "优世界"品牌下探 C 端超仿生陪伴，3000 元定金预售 |
| Figure AI | 🟢 | 签 Catalyst Brands，进零售仓储物流 |

---

## 🧠 大模型基座 · 深度正文

**Google DeepMind · Gemma 4 12B（6/3）**
本周 DeepMind 的核心动作是发布 **Gemma 4 12B**——一款"无编码器（encoder-free）的统一多模态开放模型"，定位"把 agentic 多模态智能直接带到笔记本电脑"。架构创新：摒弃传统多模态模型的独立视觉/音频编码器，视觉用"单次矩阵乘法 + 位置嵌入 + 归一化"的轻量 embedding 模块替代，音频则完全移除编码器、把原始音频信号直接投射到与文本 token 相同的维度空间，由 LLM 主干统一处理（降低延迟与内存占用）。它填补了边缘端 E4B 与更强 26B MoE 之间的空档，是 Gemma 系列首个具备原生音频输入的中型模型。性能上标准 benchmark "接近其 26B MoE 模型"，但总内存占用不到一半，可在仅 **16GB VRAM/统一内存**的消费级笔记本本地运行。生态：Apache 2.0 许可证开源，内置 Multi-Token Prediction（MTP）drafter 降低延迟；官方称 Gemma 4 系列累计下载已突破 **1.5 亿次**，已上线 LM Studio、Ollama、Google AI Edge Gallery。背景：Gemma 4 初代于 2026-03-31 发布；6/11 还将在 London Tech Week 办"Gemma 4 Startups"活动（含 Gemini 3.1、Genie、Veo 预告）。encoder-free 统一多模态是端侧 AI 的范式转变，瞄准"本地笔记本跑 agent"场景，是 Google 在开源端侧与 Meta Llama、Qwen 正面竞争的关键落子。
[Google 博客](https://blog.google/innovation-and-ai/technology/developers-tools/introducing-gemma-4-12b/) · [版本时间线](https://ai.google.dev/gemma/docs/releases)

**Microsoft · Build 2026 全栈 agent 平台 + MAI**（详见 TOP 5）
除 TOP 5 所述，本届 Build 还交付：Foundry Toolkit for VS Code 正式 GA；Toolboxes in Foundry 公开预览（统一治理工具/技能/MCP 客户端/企业数据的单一端点）；Voice Live 新增实时语音路径；Foundry agent 可发布到 Teams 与 M365 Copilot（计划 6 月 GA）；Memory in Foundry Agent Service 新增 procedural/user/session 三类记忆；Foundry IQ 升级为更广知识平面（serverless 检索、Web IQ 实时联网 grounding，Work IQ APIs 2026-06-16 GA）；基础设施侧推出 Azure Cobalt 200 VMs、Azure HorizonDB（面向 AI 时代的企业级 Postgres）。与 Claude Agent SDK、GitHub Copilot SDK 深度集成，显示微软走"开放编排 + 多模型"而非单一模型路线。
[Foundry 博客](https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-build-2026/) · [Build 2026](https://blogs.microsoft.com/blog/2026/06/02/microsoft-build-2026-be-yourself-at-work/)

**OpenAI · ChatGPT 产品侧四线并进（6/1–6/4）**
本周 OpenAI 重心从"发模型"转向"产品化 + 安全合规 + 商业化"。①6/1：ChatGPT 上线"求职"能力——可在对话中搜索实时在招岗位（live roles）并针对特定职位定制简历（resume tailoring），把 ChatGPT 推向求职工作流入口。②6/2：上线"Active sessions（活跃会话）"安全功能，用户可在 Settings>Security 查看与账户关联的所有会话（设备、App、大致位置、登录时间、可信设备状态）并单独或一次性登出，覆盖 ChatGPT/Codex/API Platform 会话；同日开发者侧官宣 GPT-5.2 与 GPT-5.3-Codex 进入 sunset 退役时间表。③6/4：升级 Memory 系统——记忆自动更新、减少陈旧/矛盾记忆，Plus/Pro 用户**记忆容量翻倍**；同日"Lockdown Mode（锁定模式）"面向所有登录用户开放（限制联网/深度研究/agent 模式/文件下载以降低提示注入数据外泄风险）；并开始在英国对 Free/Go 用户**推送广告**（付费层保持无广告）。OpenAI 把"反提示注入"做成 C 端产品功能，英国广告落地是 ChatGPT 商业模式的关键拐点。
[ChatGPT Release Notes](https://help.openai.com/en/articles/6825453-chatgpt-release-notes) · [Codex Changelog](https://developers.openai.com/codex/changelog)

**DeepSeek · 首轮融资 74 亿美元**（详见 TOP 5）
背景补充：deepseek-chat 与 deepseek-reasoner 已于此前升级至 DeepSeek-V3；DeepSeek-V3.2 & V3.2-Speciale（reasoning-first、为 agent 构建）于 2025 年 12 月发布；R1 于 2025 年 1 月发布（性能对标 OpenAI-o1、全开源）。本周核心是"资本拐点"——首次引入外部战投（腾讯 + CATL），590 亿美元估值反映市场对中国开源大模型龙头的重估。
[Reuters](https://www.reuters.com/business/retail-consumer/deepseek-slated-draw-7-billion-maiden-fundraising-sources-say-2026-06-03/) · [API 更新](https://api-docs.deepseek.com/updates)

**xAI · Grok Imagine Quality Mode + Composer 2.5**
本周 xAI 在产品工具侧更新。①Grok Imagine API 上线"Quality Mode"，面向企业开发者与团队，主打更高写实度、更强多语种文字渲染、更精准提示遵循与品牌一致性，瞄准产品可视化、营销素材、UGC 风格内容；据其引用的 LMArena Text-to-Image Arena（截至 2026-05-04）排名，OpenAI 1398/Google 1268/xAI 1223。②Composer 2.5 在 Grok Build 中上线（本周初），定位擅长长任务与复杂指令遵循的快速 SOTA 模型，同期新增 Smart Turn 对话轮次结束检测。背景：5/25 马斯克称 Grok V9-Medium（约 1.5T 参数级编码模型）已完成训练、预计 mid-June 出货（尚未发布）。xAI 从消费级 Grok 聊天向企业开发者工具与多模态内容生产延伸，但本周无实质模型发布，需警惕"预告先行、交付滞后"。
[xAI Releasebot](https://releasebot.io/updates/xai)

**Anthropic · 企业自定义角色新增 admin 权限（6/2）**
本周 Anthropic 无重大模型发布，仅有企业管理功能小更新：Enterprise 套餐的自定义角色（custom roles）框架新增"管理员权限"，可让成员获得计费/隐私等特定管理区域访问权而无需设为 Owner（精细化权限治理）。背景：最重磅的 **Claude Opus 4.8 于 5/28 发布**（窗前 3 天，不计入本周）。本周节奏放缓属正常——刚在窗前发完旗舰，进入企业治理打磨期，把"可治理、可合规"作为对抗 OpenAI 的护城河。
[Release Notes](https://support.claude.com/en/articles/12138966-release-notes)

**Meta AI · Llama 4 调整期（二手为主）**
本周 Meta 无 Llama 新模型发布，但有两条相关动态。①Llama 4 许可证/EU 可用性争议：Meta 托管服务与自托管 Llama 权重为不同路径，EU 企业在自建开源模型策略前需直接确认当前许可条款。②资本市场承压：据 TipRanks（6/5），Meta 股价当日下跌，部分因 Llama 4 发布令投资者失望，且 Meta 推迟了更大的 **Llama 4 Behemoth** 模型发布。本周 Meta 在 Llama 侧处于"调整期"，开源旗舰高地出现松动；注：本周核心动态多为二手来源，需以 Meta 官方博客交叉验证。
[digitalapplied 分析](https://www.digitalapplied.com/blog/meta-ai-business-agents-enterprise-llama-launch-2026)

**Databricks · Summit 预热 + AI Search 更名**
本周 Databricks 无新基座模型发布，重心在大会预热与平台更新。①6/2 官宣 Data + AI Summit 2026 完整议程：6/15-18 旧金山 Moscone，预计超 3 万人，主题演讲嘉宾含微软 Satya Nadella（预录）、OpenAI 的 Greg Brockman 等。②平台更新：Azure Databricks Vector Search 正式更名为 **AI Search**（现可创建无需向量/嵌入的全文检索索引）。背景：2/9 宣布跨越 54 亿美元营收 run-rate、估值 1340 亿美元。Databricks 持续走"数据 + AI 一体化平台"路线，基座模型（DBRX）已非其叙事重点。
[Summit 新闻](https://www.databricks.com/company/newsroom/press-releases/databricks-announces-2026-data-ai-summit-keynote-lineup-and) · [6 月平台更新](https://learn.microsoft.com/en-us/azure/databricks/release-notes/product/2026/june)

**Mistral AI · mistral-common SDK 迭代**
本周 Mistral 无新旗舰基座发布，仅开源工具库小版本迭代：6/3 mistral-common v1.11.2、6/4 v1.11.3（扩展 OpenAI 转换的 reasoning 格式支持、修复 tokenizer guidance 与 tekken normalizers）。背景：5/28 发布"Vibe"——把 Le Chat 升级为统一 AI agent（含 Work Mode、Code Mode、VS Code 扩展），卡在窗前 3 天。Mistral 近期重心明显从"发基座"转向"agent 产品化 + 开发者工具链"。
[Mistral Releasebot](https://releasebot.io/updates/mistral)

> 💤 本周静默：**字节跳动**（重大发布节奏与火山引擎 Force 大会绑定，历史多在 6 月中举办，本周处大会前静默期，弹药蓄势待发）。

---

## 🤖 垂直 Agent 产品 · 深度正文

**Anysphere (Cursor) · 3.7 版 Design Mode（6/5）**
本周 Cursor 发布 3.7 版本，核心是"Design Mode（设计模式）"的重大增强，让开发者可在 Cursor 浏览器中直接对实时运行的应用做可视化操作：①**多选元素**——同时点选两个或以上 UI 元素，Cursor 能读取所选元素的代码、周边布局及视觉关系，可让 agent"把 A 改成和 B 一致"、批量调整一组组件；②**语音输入**——通过 Design Mode 浮层用语音口述改动，且 agent 运行中麦克风保持可用，可语音排队下一个改动。配套更新：**Cursor SDK 升级（TS/Python）**，新增自定义工具（通过 local.customTools 把自有函数作为 MCP 工具暴露）、auto-review（本地 headless agent 的工具调用经分类器审核）、JSONL 持久化、可无限嵌套的 subagent；**Canvas Design Mode** + 上下文用量报告（拆解 token 在 system prompt/tool 定义/rules/skills 等处的分布）；**Enterprise Organizations**（企业版组织管理，支持多 Team 多 Group 的安全/治理/预算/功能分权，已对所有企业客户 GA）。Cursor 正从"代码编辑器"全面转向"agent 编排平台"——Design Mode 把前端可视化操作纳入 agent 闭环，SDK 的嵌套 subagent + 自定义工具是在搭建生产级 agent 基础设施。背景：据 Wikipedia 摘要 Cursor 估值达数百亿美元、ARR 超 30 亿美元。
[Cursor Changelog](https://cursor.com/changelog)

**Cognition (Devin) · Windsurf 升级 Devin Desktop（6/2）**
本周 Cognition 正式将 Windsurf 更名/升级为 **"Devin Desktop"**（老用户 OTA 自动获得，计划/价格/扩展/功能不变）。核心：把 Windsurf 和 Devin 合二为一，将 **Agent Command Center（智能体指挥中心）**设为默认界面——用户在单一 Kanban 看板里管理所有本地与云端 agent；新增 **Spaces** 在 agent 之间共享上下文。最关键的开放性举措：Devin Desktop 首发即支持 **ACP（Agent Client Protocol，开源协议）**，让任何兼容 agent 能在任何 ACP 兼容编辑器内运行；首发支持 Codex、Claude Agent、OpenCode 等第三方 agent（含企业自建），第三方 agent 获得与 Devin 相同的界面。同时推出 **Devin Local**——用 Rust 从头重写的本地 agent（Cascade 继任者），token 效率提升最高 30%、支持 subagents。形成"一个 Devin、多个 surface"（Desktop/Cloud/CLI/Review）。背景：5/27-28 宣布完成超 10 亿美元融资、估值 260 亿美元，营收 12 个月从 $37M 增至 $492M、90% 自有代码由 AI 编写。Cognition 用 ACP 开放性吸纳竞品 agent 入驻自家 command center，是典型的"做平台、做入口"打法。
[Devin 博客](https://devin.ai/blog/windsurf-is-now-devin-desktop/)

**Perplexity · 混合本地-服务器推理编排器（Computex 2026）**
Perplexity 发布其所称"首个混合本地-服务器推理编排器"，官方技术博客标题《The data center moves to your machine》。核心机制"**混合智能体推理**"：在用户设备上运行一个紧凑的本地模型作为"路由器"，对每个进入的任务/子任务评估——是否涉及敏感数据、是否需要重计算、是否能完全在端上完成——据此决定任务留在本地还是发往云端前沿模型，发送敏感任务到云端前会征求用户许可，明确把金融/健康/个人文件保持在本地。它建立在 Perplexity Computer（2026-02，云端多模型 agentic 产品、可协调多达 20 个 AI 模型）和 Personal Computer（2026-04 在 Mac 上线）之上，进步在于对"任务的每一部分该在哪执行"做推理。框架模型无关、芯片无关，已确认可在 Intel Core Ultra Series 3 和 NVIDIA RTX Spark 硬件运行，预计 2026 年 7 月先在 Windows 上随 Perplexity Computer 到来。"端云混合推理路由"若成主流，将重塑 AI 产品的成本结构与隐私架构。
[MarkTechPost](https://www.marktechpost.com/2026/06/05/perplexity-ai-introduces-hybrid-local-server-inference-orchestrator-for-personal-computer-automatic-on-device-and-cloud-task-routing/)

**Glean · 新增 NVIDIA Nemotron 3 Ultra 支持（6/4）**
Glean 官方发布新增对 **NVIDIA Nemotron 3 Ultra 开源模型**的支持，为客户提供"高性价比 agentic 工作"的新开放模型选项。官方称 Nemotron 3 Ultra "以开源模型的成本结构交付前沿 LLM **91% 的完整度**"。此举强化 Glean 的**模型无关平台战略**：现平台已接入 **30+ 模型**（含开源与闭源）。原文还披露与 NVIDIA 的延续合作：Glean 的 agentic 搜索模型 **Glean Waldo** 基于 Nemotron 3 Nano 做后训练，实现**延迟降低 50%、token 减少 25%**——Waldo 承接原本由前沿模型处理的搜索任务，体现 Glean 的"token 经济学"思路。背景：据报道 5/28 宣布 ARR 突破 3 亿美元、15 个月内 3 倍增长。Glean 把自己定位为"企业 AI 的可信上下文与智能层"。
[Glean 官方](https://www.glean.com/press/glean-adds-support-for-nvidia-nemotron-3-ultra-expanding-model-choice-for-cost-effective-enterprise-ai)

**Harvey (Legal) · 为每个事项定制法律 Agent**
本周 Harvey 官方博客核心产品博文《Legal Agents for Every Matter, Tailored to You》，宣布引入"改进的 agentic 能力"，使法律团队能快速产出一致、高质量的结果。同时重要行业背景：**洛杉矶时报 6/1** 刊文《AI shakes up big law, threatening the billable hour》，指出顶尖律所正大规模部署 Harvey 等定制平台以加速文档审查、推行分层定价，同时 AI 生成的错误在法庭文件中堆积、威胁传统计时收费模式。背景：3/25 完成 $200M 成长轮、估值 110 亿美元、总融资超 12 亿美元；ARR 1.9 亿美元、服务 60 国 1300+ 客户、平台上运行 25000+ 定制 AI agent；与 LexisNexis、Docusign 整合。"每个法律事项都配定制 agent"是 legal AI 从工具到平台的关键演进，LA Times 报道揭示 legal AI 正实质动摇律所计时收费模式。
[Harvey 博客](https://www.harvey.ai/blog) · [LA Times](https://www.latimes.com/business/story/2026-06-01/ai-shakes-up-big-law-threatening-billable-hour)

**Midjourney · Office Hours（6/3）**
本周无新模型正式发布，但有官方周度 Office Hours：团队两大优先级是 **v8.2 发布**和**新的 editor model（编辑模型）**。v8.2 主要聚焦修复并扩展 v8.1 的美学表现，创始人 David Holz 估计约还要 2 周才会发布；在此之前 **v8.1 将先成为主站和 Discord 的默认模型**（取代 v8.0）。版本脉络澄清：题述"v7"已是旧版（2025-04-03 发布），2026 年主线已推进到 V8 系列（V8.1 于 2026-04-30 发布，渲染比早期快约 4-5 倍）。Midjourney 拆分出独立"editor model"，显示图像编辑正成为与生成并重的能力轴；本周属过渡期，不代表停滞。
[社区 Office Hours 记录](https://medium.com/enthusiastically-midjourney/my-midjourney-info-17-week-of-june-1st-2026-7872c6d017ef)

> 💤 本周静默：**Sierra**（5/4 完成 $950M E 轮、估值 $15.8B 并在 Sierra Summit 集中发布 8 款新品后，本周处发布后消化期，无新增公开动作）。

---

## 🇨🇳 中国公司 · 深度正文

**MiniMax · M3 发布**（详见 TOP 5）
补充技术细节：M3 官方六大关键词为 Coding 能力、1M 上下文、原生多模态、Computer Use、低价 Token Plan、开源。此前能集齐"前沿 Coding + 1M 上下文 + 原生多模态"三项的仅 Claude Opus 4.7、Gemini 3.1 Pro、GPT-5.5 等海外闭源旗舰。完整 benchmark：SWE-Bench Pro 59.0%、Terminal Bench 2.1 66.0%、SWE-fficiency 34.8%、KernelBench Hard 28.8%、MCP Atlas 74.2%；SVG-Bench 超 Opus 4.7；多模态 OmniDocBench 超 Gemini 3.1 Pro；Claw-Eval 拿最高分。同日 MiniMax Code 更新（Agent Team 可将大任务拆解为多阶段可并发 Workflow）。背景：截至 5/28 全球企业开发者客户超百万、全球用户约 3 亿、过去两月 ARR 增长超 100%。
[凤凰财经](https://finance.ifeng.com/c/8tbcJ4uwXfq) · [36氪](https://eu.36kr.com/zh/p/3837463161244161) · [官方](https://www.minimaxi.com/news/minimax-m3-zh)

**月之暗面 (Kimi) · Kimi Work Beta 内测（6/3）**
本周月之暗面宣布"**Kimi Work Beta 版**"开启内测，随 Kimi 最新测试版 Mac 和 Windows 客户端推出。官方定位：Kimi Work 是**面向知识工作者的通用型本地 Agent**——用户无需打开终端、写命令、配置环境，只需用自然语言描述目标，Kimi Work 即可在用户电脑上拆解任务、并行执行、调用工具、使用浏览器、创建整理文件夹，并交付文档/表格/PPT 等工作产物。关键能力：支持 **Agent 集群**，最高可根据任务复杂度自主创建包含 **300 个子 Agent** 的团队。最具信号意义的细节：Kimi Work 自身由 Kimi Code 深度参与写出——工程师用 Kimi Code 等 Coding Agent 工具一周内完成 Beta 版客户端，开发中累计产出超 **5 万行有效代码，其中 92% 由 AI 自主生成**。背景：Kimi K2 于 2025-07-11 发布（万亿参数/320 亿激活、开源），旗舰 Kimi K2.6 于 2026-04-20 发布并开源。Kimi 从"模型 + Chat"向"本地通用 Agent + Agent 集群"延伸，主打"AI 替知识工作者干活"的落地叙事。
[新浪科技转 IT 之家](https://finance.sina.com.cn/tech/digi/2026-06-03/doc-iniacxkk4001164.shtml)

> 💤 本周静默：
> **阿里云（Qwen/夸克）**——重磅集中在窗前 5/20 阿里云峰会（发布 Qwen3.7-Max + 自研真武 M890 芯片 + 千问云、完成"芯片-云-模型-推理"全栈 Agent 化升级），本周处发布后落地执行期；通义千问 Plus 预计 6 月全量开放，本周未见正式公告。
> **智谱（GLM/清言）**——旗舰 GLM-5（2 月、744B 参数）、GLM-5.1（4 月并提价 10%）密集发布后处迭代消化期；已在港交所上市（02513.HK），本周无新版本对外。
> **腾讯（混元/元宝）**——AI 战略明确"先偿内债"，优先在元宝/QQ/腾讯文档等十余款产品内铺开混元 3.0（4/23 发布、5/7 以 3.66 万亿 Token 登顶 OpenRouter 周榜）能力，本周处内部落地期；"腾讯元器"6 月分发能力本周未见正式上线确认。

---

## 🛠️ Agent 框架工具 · 深度正文

**Claude Code · 高频发布周（5/31–6/6）**
本周是 Claude Code 的高频发布周，节奏接近每日一发。核心新功能：①**fallbackModel 设置**（6/6）——可配置最多三个 fallback 模型，主模型过载/不可用时按序尝试，--fallback-model 现也作用于交互式会话；②**deny 规则支持 glob 通配**——deny 规则工具名位置支持 "*"（拒绝所有工具）；③**跨会话消息安全加固**——经 SendMessage 从其他 Claude 会话转发的消息不再携带 user authority，接收方拒绝转发的权限请求；④**managed settings 强化**（6/4）——新增 requiredMinimumVersion/requiredMaximumVersion，版本越界则拒绝启动；新增 /plugin list 命令；⑤**思考控制**——MAX_THINKING_TOKENS=0 现可关闭默认思考的模型；⑥触发词从 workflow 改为 **ultracode**（6/2）。另有大量 background agents 稳定性、Windows 权限规则反斜杠匹配、MCP 密钥脱敏、OTEL 指标维度切片修复。Claude Code 本周明显聚焦"企业治理 + 模型容错 + 多会话/后台 agent 编排稳定性"，正从单机编码工具向团队级、可治理、多 agent 并行的工程平台演进。
[GitHub Releases](https://github.com/anthropics/claude-code/releases)

**Codex CLI · rust-v0.137.0 + 多智能体 v2（6/4–6/6）**
Codex 本周发布极其密集，正式版 **rust-v0.137.0 于 6/4** 发布，随后 0.138.0-alpha.1~alpha.6 在 6/4-6/6 连续滚出。v0.137.0 核心：①**多智能体 v2**——每个 thread 保留运行时选择，为 spawned agents 暴露更干净的 follow-up 与 metadata，assign_task 重命名为 followup_task，新增 multi-agent runtime metadata 类型与持久化；②**企业/管理流**——状态栏显示月度 credit 限额，可应用 cloud-managed config bundles（含 EDU 工作区）；③**远程控制**——remote-control 客户端可通过 app-server v2 RPC 发起配对、列出/撤销 controller 授权；④**插件工作流**——codex plugin list --json 机器可读输出；⑤**托管 Web/图像工具**——独立 web 搜索可并行运行；⑥**goal extension**——新增 GoalApi、idle continuation、目标引导提示模板化。Codex 正全力投入"多智能体编排 + 企业级配置治理 + 远程控制"，goal extension 与 idle continuation 显示其向"自主长任务 agent"演进，与 Claude Code 的企业治理路线高度趋同。
[GitHub Releases](https://github.com/openai/codex/releases)

**Google ADK · v2.2.0（6/4）**
ADK 本周有两个在窗发布：v2.2.0（6/4）与 v1.34.2（6/1）。v2.2.0 含**破坏性变更**：①LlmAgent 默认模型从 gemini-2.5-flash 改为 **gemini-3-flash-preview**，为 2026-10-16 gemini-2.5-flash 下线做准备；②interactions 适配 GenAI SDK v2.0.0，术语从 "turns" 改为 "steps"。新特性：AutoTracingPlugin（OpenTelemetry 自动插桩）、RubricBasedMultiTurnTrajectoryEvaluator（基于评分标准的多轮轨迹评估器）、原生发射 OTel gen_ai.client.* 指标、BaseSessionService 新增 get_user_state。安全修复：升级 starlette/fastapi 修复 CVE-2026-48710、GCS skill 解压修复 Zip Slip。默认模型切到 gemini-3-flash-preview 是强信号——Google 正以框架默认值推动开发者迁移到 Gemini 3 系列；OTel 原生指标 + Rubric 评估器显示 ADK 向"可观测、可评估的生产级 agent 平台"成熟。
[GitHub Releases](https://github.com/google/adk-python/releases)

**Hermes Agent · NVIDIA 官方背书（约 6/2）**
Hermes Agent（Nous Research 出品的自改进 AI agent）本周最重磅信号是 **NVIDIA 官方技术博客发布深度集成案例**：《Deploy Self-Evolving Agents for Faster, More Secure Research with a Hermes Agent and NVIDIA NemoClaw》。该文将 Hermes 定位为 NemoClaw 蓝图的 "harness" 层（提供 skills/sessions/memory/bridges/hooks），与 NVIDIA Nemotron 3 Super（120B-A12B-FP8）模型层、OpenShell 运行时层组成三层自进化 agent 架构。案例演示 agent 从对话中学习报告格式并自动写出 SKILL.md，通过 snapshot/tear-down/rebuild/restore 让习得技能跨部署存活；网络策略以 policy.yaml 代码声明，越界访问返回 403。Hermes 核心卖点：内置学习闭环、6 种终端后端、多平台 gateway、兼容 agentskills.io 标准、原生 Windows 支持。值得注意：README 明确提供 `hermes claw migrate` 从 **OpenClaw 迁移**功能。NVIDIA 把 Hermes 选为其 NemoClaw 开放 agent 蓝图的官方 harness，是自进化 agent 赛道的里程碑级背书。
[NVIDIA 博客](https://developer.nvidia.com/blog/deploy-self-evolving-agents-for-faster-more-secure-research-with-a-hermes-agent-and-nvidia-nemoclaw/) · [GitHub](https://github.com/nousresearch/hermes-agent)

**OpenClaw · 2026.6.5 月度补丁（6/6）**
正式版 **2026.6.5** 于 6/6 发布。核心改动三条线：①**搜索 Provider 扩展**——新增 Parallel（api.parallel.ai/v1/search）作为内置 web_search 提供商，支持自动发现、guarded endpoint、onboarding 选择器；②**协议/通道稳健性**——MCP 工具结果现在在 materialize 边界对非文本块做强制 coerce，避免 Anthropic 400 错误；Anthropic 扩展思考会话在 prompt-cache 过期或 Gateway 重启后可恢复；③**通道内容边界**——QQBot 在原生投递前剥离模型 reasoning/thinking 脚手架。此外 auth profile 迁入 SQLite、cron 旧版 JSON 存储迁移至 SQLite。发布流程切换为 YYYY.M.PATCH 月度补丁编号。OpenClaw 月度补丁化 + 错误恢复深耕，标志其进入"生产可用稳定期"；新增 Parallel 搜索 provider 说明 Agent OS 正在做搜索后端多元化。
[GitHub Releases](https://github.com/openclaw/openclaw/releases)

**OpenCode · 仓库迁移 + 启动 +38%（6/5）**
本周两个在窗发布。值得注意：仓库已从 `sst/opencode` **重定向到 `anomalyco/opencode`**（疑似维护方/品牌归属变更）。核心：managed workspace cloning、跨 workspace 移动会话、通过 AWS Bedrock 支持 OpenAI 模型、skill discovery 与基于文件的 agent 加载、**启动时间提升 38%**；reasoning summaries 仅在支持的 provider 运行、running subagents 可发送到后台、新增 **Snowflake Cortex provider**。组织迁移 + 启动性能大幅优化 + 多 provider 扩张，是 OpenCode 从社区项目走向规模化/可能商业化的拐点信号。
[GitHub Releases](https://github.com/anomalyco/opencode/releases)

**Cohere · 开源 co/plot（6/5）**
Cohere 发布开源数据可视化工具 **co/plot**。该工具由 Cohere Labs 内部研究可视化需求催生（Matplotlib 迭代慢、Figma 出图美但无法可靠接入数据），co/plot 填补"可快速原型 + 预设可定制样式 + 忠于底层数据"的空白，在构建 Tiny Aya 模型（评估 70+ 语言）过程中被打磨。背景：Command A+ 开源企业模型于 5 月底发布（窗前）。co/plot 是小而精的开源动作，配合主权 AI 定位与潜在 IPO 路径，显示 Cohere 以"开放科学 + 企业/政府主权部署"双轮做差异化。
[Cohere 博客](https://cohere.com/blog/coplot)

> 💤 本周静默：
> **Dify**——最新正式版 v1.14.2（5/19）后处发布间隙，本周 GitHub releases 无新 tag，属 1.14 稳定补丁周期的正常节奏波动。
> **Scale AI**——Scale Labs 的 Showdown/Leaderboard 评测榜单本周保持常态化更新，无方向性新动作或里程碑事件。
> **SSI**——坚持"零产品、纯研究、超长周期"路线，本周无任何技术信号，仅有外部财务梳理（累计融资约 $6B、估值 $32B）。

---

## ⚡ 算力云硬件 · 深度正文

**NVIDIA · GTC Taipei 大爆发周**（详见 TOP 5）
补充：6/2 黄仁勋对外表态 NVIDIA "有足够产能支撑 CPU/GPU 强劲增长"，回应供给约束担忧。Jetson AGX Thor T5000 规格：Blackwell GPU、2070 FP4 TFLOPS AI 算力、14 核 Arm CPU、128GB 统一内存、40–130W 可配置功耗。Vera CPU 全面量产，被定位为"新的主要增长驱动力"。NVIDIA 从云端 GPU 单点垄断走向"端-边-云"全栈通吃，RTX Spark 把战火烧到 PC 芯片，直接动 Intel/AMD 蛋糕。
[Fortune](https://fortune.com/2026/06/01/jensen-huang-nvidia-pc-reinvention-ai-chips/) · [NVIDIA](https://nvidianews.nvidia.com/news/nvidia-open-humanoid-robot-reference-design) · [Reuters](https://www.reuters.com/world/asia-pacific/nvidia-ceo-says-has-capacity-supply-robust-cpu-gpu-growth-2026-06-02/)

**AWS · OpenAI 模型登陆 Bedrock GA（6/1）**
AWS 本周核心动作是把 OpenAI 前沿模型全面接入 Bedrock——**GPT-5.5、GPT-5.4 与编码 agent Codex 在 Amazon Bedrock 正式 GA**。这是继 4/27 微软与 OpenAI 重组协议、独占条款被取消后，OpenAI 模型首次大规模登陆 AWS 云。要点：①GPT-5.5 面向"最难的客户工作负载"，GPT-5.4 主打"最佳性价比"，均通过 Bedrock 以 Responses API 调用；②Codex 据 OpenAI 称每周有超 **400 万开发者**使用；③数据驻留：所选 Bedrock 区域内完成全部处理，按 token 计费，无席位许可。同时 Bedrock 推出 AgentCore（端到端 agent 平台）、与 Coinbase/Stripe 合作的 AgentCore Payments、Bedrock Managed Agents（powered by OpenAI）。OpenAI 模型登陆 AWS 是云竞争格局的拐点信号——OpenAI 不再被微软 Azure 独占，AWS 得以用"全模型超市 + Trainium 成本优势"争夺企业 agent 工作负载。
[AWS 博客](https://aws.amazon.com/blogs/aws/get-started-with-openai-gpt-5-5-gpt-5-4-models-and-codex-on-amazon-bedrock/)

**Azure · 自研 MAI 模型去 OpenAI 依赖**（详见 TOP 5）
补充：MAI-Thinking-1 跑在 Azure 自有基础设施上，直接改善 Azure AI 的毛利结构；Azure AI Agent Service（托管调度/记忆/工具调用/多 agent 协同）首日开放注册、首小时超 1 万开发团队报名。背景：Anthropic 6/1 已秘密递交 IPO；微软已投 OpenAI 130 亿美元、Anthropic 50 亿美元。这是微软 AI 战略的关键拐点——从深度绑定 OpenAI 转向"自研 MAI + 多供应商并行"，既降本又夺回模型层控制权。
[CNBC](https://www.cnbc.com/2026/06/02/microsoft-unveils-new-ai-models-lessen-reliance-on-openai-lower-costs.html) · [WindowsNews](https://windowsnews.ai/article/microsoft-build-2026-windows-becomes-the-home-for-ai-agents.423082)

## 🦾 具身机器人 · 深度正文

**宇树 Unitree · 三喜临门**（详见 TOP 5）
补充：宇树 2025 年纯人形出货超 5500 台、全球份额约 32.4%、居全球第一（高工机器人/IDC）。被英伟达选为首个开放人形参考设计本体（H2 Plus），"身体来自宇树、大脑来自英伟达"的分工绑定全球 AI 算力龙头。NVIDIA-宇树"美脑中身"组合，在中美科技博弈背景下耐人寻味——英伟达同时强调将与美欧厂商合作，留有对冲。
[新浪财经](https://finance.sina.com.cn/wm/2026-06-02/doc-inhzzivp1611572.shtml) · [Reuters](https://www.reuters.com/world/asia-pacific/nvidia-work-with-us-european-humanoid-robot-makers-addition-chinas-unitree-2026-06-01/)

**优必选 UBTech · "优世界"下探 C 端（6/2）**
优必选本周最大动作不在 Walker S 工业线，而是杀入消费级——6/2 旗下全新消费级人形机器人品牌"**优世界**"官宣，推出"全球首款全尺寸超仿生人形机器人"并开启预售，6/30 正式发布。产品分男女两款 SKU：男款 183cm/42kg、女款 168cm/35.2kg，全系标配 **88 个自由度**，支持 Wi-Fi、续航 2-4 小时，明确标注"不支持二次开发"——面向 C 端家庭消费者而非开发者。预售政策：即日起至 7/15 预付 **3000 元定金**锁首批名额（已在京东等平台上线），9 月开始交付，定位"情感陪伴 + 服务型机器人"。背景：Walker S 系列 2026 出货目标已上调至 5000 台、产能规划 1 万台，已落地蔚来 F2 工厂、极氪智慧仓等汽车产线。优世界是优必选把工业人形积累的关节/控制/AI 能力下放到消费陪伴市场，标志人形机器人商业化从"B 端产线"向"C 端家庭"开辟第二战场。
[IT 之家](https://www.ithome.com/0/958/486.htm) · [myzaker](https://app.myzaker.com/news/article.php?pk=6a1fc0348e9f09496036664d)

**Figure AI · 签 Catalyst Brands 进零售仓储（6/5）**
Figure AI 本周落下一笔标志性商业订单——与 **Catalyst Brands**（JCPenney、Aéropostale、Brooks Brothers、Eddie Bauer、Lucky Brand、Nautica 等品牌母公司）签署商用协议，首批部署落在内华达州 Reno 的配送物流中心。机器人先承担仓储/供应链环节中重复、体力消耗大的分拣与打包任务，接入 Catalyst 现有的 Joey Pouch 分拣系统。财务暗线：**Brookfield 既是 Figure 投资方、又持有 Catalyst Brands 股份**——Figure 称这是其与 Brookfield 投资组合公司之间"首座商业桥梁"。部署数量/启动日期/采购模式（含 RaaS）/岗位影响均未公开。这是 Figure 从"汽车工厂（如 BMW）"向"零售/电商仓储物流"横向扩张的关键落子，但 Brookfield 资本闭环（投资方撮合自家组合公司订单）需警惕"关联交易式"需求的真实性。
[Fox News](https://www.foxnews.com/tech/humanoid-robots-coming-retail-jobs)

---

## 📋 关于本周报

- **数据口径**：覆盖区间严格限定 2026-05-31（周日）00:00 → 06-06（周六）24:00（上海时区）；窗口外动态仅作背景标注，不计入"本周动态"。
- **覆盖率**：实质覆盖 **38/38（100%）**——有动态对象均附原文链接与深度笔记，静默对象均经搜索验证并附具体原因。
- **图标说明**：🔥重大 ｜ 🟢一般 ｜ 🟡边缘 ｜ ⚪️静默。
- **来源说明**：官方博客 / 论文 / GitHub release / 官方公告优先于二手新闻；关键数据标注来源 URL 与日期，查不到写"未公开"。
- **下期预告**：6 月中将密集迎来字节火山引擎 Force 大会、Databricks Data + AI Summit（6/15-18）、DeepMind Gemma 4 Startups（6/11）、xAI Grok V9-Medium 预计出货、优必选优世界 6/30 正式发布定价——下期重点跟踪。
