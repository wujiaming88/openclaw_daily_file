# 全球 AI 动态周报 · 第 20 期（2026-10-02 ~ 2026-10-08）

- run_id: run-e88c5a0d-d434-45da-a4f3-88b763854583
- 窗口：2026-10-02 00:00 ~ 2026-10-09 00:00（Asia/Shanghai，含头不含尾；UTC 2026-10-01 16:00 ~ 2026-10-08 16:00）
- 性质：冻结研究母稿（research-master）。下游文章（report2article）唯一内容输入；不新增事实、不发布。
- 来源：综合 A/B/C/D 四组已交回分片 + 组 audit + D组-evidence-to-A + 父级 research-gate。研究准入 PASS（带透明局限）。

## 内容边界（内部标注）

- `PUBLIC_CONTENT`：公司条目、关键数据、来源 URL+日期、企业维度分析、影响判断、事件 ID —— 构成读者稿基线，可进文章。
- `AUDIT_METADATA`：工具检索日志、provider、计数、门控过程、静默核验过程 —— 仅留资料库，不进文章。
- 分工：A/B/C/D 四组，37 家固定对象（实质覆盖 30 家、静默 7 家、不可核验 0）。NVIDIA 以 A 组为主干，并入 D组-evidence-to-A 的具身投资与 Vera Rubin 部署证据（标注来源）。

## 章节

1. 本期执行摘要
2. TOP5 候选（附紧随其后）
3. 企业竞争雷达
4. 企业竞争主线（三条）
5. 分章正文 · A 组
6. 分章正文 · B 组
7. 分章正文 · C 组
8. 分章正文 · D 组
9. 各组洞察
10. 下周观察点
11. 口径与局限
12. 工具证据账本（AUDIT_METADATA）

## 一、本期执行摘要 {#s1}

**一句话判断**：本周企业竞争的重心继续从「模型分数」转向「Agent 入口 + 治理/成本 + 资本债务化」——头部厂商把 Agent 下沉到 OS/设备/企业平台层（OpenAI Intelligent UI、Google Gemini agent、Microsoft MXC/Windows、Meta Muse、NVIDIA RTX Spark），价格战外溢到高并发生产层（Anthropic Haiku 5.5 与 GPT‑6 Luna 同价），同时「中国大模型上市板块」（DeepSeek ≥¥800 亿、月之暗面 $500 亿 Pre‑IPO）与「AI 算力债务化」（Broadcom 为 OpenAI 定制芯片 >$500 亿债务融资、Oracle 芯片融资）两条资本线同步成形。

- 竞争焦点：谁掌握「任务起点与执行环境」，并把它做成可计费、可治理、可植入企业流程的平台。
- 成本/治理：小模型价格对齐、per‑agent token 封顶、Agent Identity、记忆治理、MCP Policy Engine 成为新的差异化维度。
- 资本：一级市场为「真实营收/客户/落地闭环」与「数据/治理底座」付溢价；算力采购从经营性现金转向上游债务驱动。
- 具身：从「演示」进入「量产与估值验证」，本体量产能力与资本市场定价出现明显背离。

## 二、TOP5 候选 {#s2}

筛选口径：战略影响力 × 商业化信号 × 资本/组织信号 × 市场格局影响 × 新颖度。

1. **OpenAI GPT‑6 + Intelligent UI 面向全体 ChatGPT 用户（A01，2026‑10‑07）**：GPT‑6 按层级下发（Sol→Plus/Pro/Business/Enterprise，Luna→Free/Go），Intelligent UI 让模型自主组合文本/图表/按钮/表单作答，把 ChatGPT 从「答案终点」改造成「任务起点与执行层」；覆盖 >1.2B 周活（官方/9to5Mac）。
2. **Google Cloud 发布单一通用工作 Agent「Gemini agent」（A06，2026‑10‑08）**：内联 Gmail/Drive/Docs/Slides/Sheets/Chat/Calendar，跨端常驻记忆 + 多 Agent 编排 + 「同事 Agent」（@agents.company.com 邮箱/持久存储）；CEO 披露近 500 家客户单家 >1 万亿 tokens/年、~80% 客户用其 AI 产品、~90% Fortune 100 用 Gemini Enterprise。
3. **OS/设备层 Agent 入口：Microsoft Windows·MXC + NVIDIA RTX Spark（A13、A19，2026‑10‑07/08）**：微软把 Copilot 内建进 Windows 核心并推出 MXC 策略驱动隔离/沙箱；NVIDIA RTX Spark 提供最高 1 petaflop、最高 128GB 统一内存，本地跑最高 120B 参数 LLM，绑定 Surface/ASUS/Dell/HP/Lenovo/MSI 与 Adobe——Agent 安全与算力被同时下沉到 PC。
4. **Anthropic Claude Haiku 5.5 与 OpenAI GPT‑6 Luna 小模型价格完全对齐（A09，2026‑10‑07）**：Haiku 5.5 短请求 $0.10/$0.50 每百万 tokens（较 Haiku 4.5 降 ~90%），与 GPT‑6 Luna 四档同价，价格战从前沿旗舰外溢到高并发生产层；官方自报 OSWorld 2.1 15.7%→72.4%（厂商口径）。
5. **中国大模型「上市板块」成形：DeepSeek ≥¥800 亿、月之暗面 $500 亿 Pre‑IPO（B02、B03，2026‑10‑06）**：彭博/知情人士称 DeepSeek 新一轮融资≥800 亿元（腾讯、宁德时代领投，目标估值约 ¥5000 亿，冲刺 2027 IPO）；月之暗面以约 $500 亿估值完成 Pre‑IPO、拟 2027 Q1 港股集资约 $50 亿——两条均为未获公司确认的披露。

**紧随其后（未入 TOP5，但属强信号）**：Broadcom 为 OpenAI 定制芯片安排 >$500 亿债务融资 + Oracle 芯片融资（D02/D06）；Databricks $5B@$190B（SBVA 出资披露，C15）；Cohere 与 Aleph Alpha 合并约 $20B + North 2 发布（C16/C18）；CoreWeave 印度 240MW 部署 Vera Rubin（D05）；Sierra Agent OS + PAP 开放标准（C10/C11）；Scale AI 国防订单五倍扩容至 $500M（C21）；Mistral Large 4（1T 参数）公开预览（C19）。

## 三、企业竞争雷达 {#s3}

跨组雷达（对象 × 维度）；✓=本周有实质动作，○=本周静默，背景=窗口外仅作背景。

| 对象（组） | Agent 入口 | 价格与成本 | 资本/算力 | 具身/物理 AI |
|---|---|---|---|---|
| OpenAI（A） | ✓ GPT‑6+Intelligent UI；广告/归因 | ✓ GPT‑6 Luna 小模型 | — | — |
| Google（A） | ✓ Gemini agent 单一通用 | ✓ Smart Routing/花销上限 | — | — |
| Anthropic（A） | ✓ 初创生态/政策 | ✓ Haiku 5.5 降 ~90% | — | — |
| Meta（A） | ✓ Muse 进 Windows（无时间表） | — | — | — |
| Microsoft（A） | ✓ Windows/MXC/本地 Copilot | — | —（硬件生态） | — |
| Amazon/AWS（A） | ✓ Bedrock Managed Agents | ✓ 预览期无额外收费 | 背景 CapEx | — |
| xAI（A） | ○（仅更名表态） | — | — | — |
| NVIDIA（A） | ✓ RTX Spark/OpenShell | — | ✓ $10 亿科研承诺 | ✓→Figure $10 亿（D 回填） |
| 阿里（B） | — | — | — | —（百炼图像托管） |
| 字节/腾讯/百度/智谱/MiniMax（B） | ○ 静默 | — | — | — |
| 华为（B） | — | — | ✓ 昇腾份额/950 节奏 | — |
| DeepSeek（B） | — | ✓ 低成本旗舰 | ✓ ≥¥800 亿融资 | — |
| 月之暗面（B） | — | — | ✓ $500 亿 Pre‑IPO | — |
| Perplexity（C） | ✓ Computer 连接器 | — | — | — |
| Midjourney（C） | — | — | —（自筹） | — |
| Runway（C） | — | ✓ Ads~$12/月 | — | ✓ Praxis‑1 开放权重 |
| Harvey（C） | ✓ MTD 工作流/MCP 治理 | — | 背景 $15.5B | — |
| Sierra（C） | ✓ Agent OS/PAP | ✓ 按结果计费 | 背景 $15.8B | — |
| Glean（C） | ✓ Enterprise Context/MCP | — | 背景 ARR $300M | — |
| Databricks（C） | — | — | ✓ $5B@$190B（SBVA） | — |
| Cohere（C） | ✓ North 2 | ✓ per‑agent token 封顶 | ✓ 合并约 $20B | — |
| Mistral（C） | — | ✓ ML4 定价 | ✓ >€21B | — |
| Scale（C） | — | — | ✓ 国防 $500M | ✓ 物理 AI 数据 |
| Cursor（C） | ○ 静默 | — | 背景 $60B 收购 | — |
| Cognition（C） | ✓ Memory/Dreaming | — | 背景 $48B | — |
| AMD（D） | — | — | ✓ 2027 保供 | — |
| Broadcom（D） | — | — | ✓ >$500 亿债务融资 | — |
| CoreWeave（D） | — | — | ✓ 印度 240MW Vera Rubin | — |
| Oracle（D） | — | — | ✓ 芯片融资 | — |
| Tesla Optimus（D） | — | — | — | ✓ 千台/周目标 |
| Figure（D） | — | — | ✓ NVIDIA 或再投 $10 亿 | ✓ 世代切换 |
| 宇树/优必选（D） | — | — | ✓ 估值回调/股权激励 | ✓ 量产交付 |

## 四、企业竞争主线（三条） {#s4}

### 主线一：Agent 入口下沉到 OS/设备/企业平台层（A01、A06、A12、A13、A19）
同一周内，OpenAI（Intelligent UI + 广告）、Google（Gemini agent 单一通用工作 Agent）、微软（Windows 内建 Copilot + MXC 沙箱 + 本地 MAI‑Code）、Meta（Muse 以原生应用登陆 Windows PC）、NVIDIA（RTX Spark + OpenShell）不约而同把「个人/企业 Agent 的落点」推到操作系统与设备层。竞争焦点由「模型分数」转为「谁掌握任务起点与执行环境」，企业侧则由 AWS Bedrock Managed Agents（A16）、Google Gemini agent、微软 Copilot 三朵云同时把「治理/安全/成本控制」写进平台卖点。

### 主线二：价格战与成本/治理成为新的差异化（A09、A01、C16、C14、C22、C10）
Anthropic Haiku 5.5 与 OpenAI GPT‑6 Luna 在短请求四档价格完全对齐，小模型价格战从旗舰外溢到高并发生产层；同时企业 Agent 的「治理/成本」被做成产品级能力——Cohere North 2 按用户/agent 的 token 花费追踪与组织级封顶（C16）、Glean Agent Identity + AI gateway + 权限治理（C14）、Cognition 的跨会话记忆与 Dreaming 治理（C22）、Harvey MCP Policy Engine 工具固定与结果净化（C09）、Sierra 结果计费（C10）。差异化不再只是「模型多强」，而是「成本可控与合规可用」。

### 主线三：资本与算力债务化、中国大模型上市板块成形（B02、B03、D02、D06、C15、C18、C19、C22）
中国侧：DeepSeek 据披露新一轮融资 ≥¥800 亿元（目标估值约 ¥5000 亿、冲刺 2027 IPO），月之暗面以约 $500 亿估值完成 Pre‑IPO、拟 2027 Q1 港股上市——叠加智谱（02513.HK）、MiniMax（00100.HK）已上市，构成「中国大模型上市板块」。海外算力侧：Broadcom 为 OpenAI 定制芯片安排 >$500 亿债务融资（据 WSJ）、Oracle 亦为芯片采购寻求大额融资，算力采购从经营性现金转向债务驱动；同时 Databricks $5B@$190B、Cohere 合并约 $20B、Mistral >€21B、Cognition $48B，一级市场为「有闭环的应用层/数据治理底座」持续付溢价。

## 五、分章正文 · A 组（OpenAI、Google、Anthropic、Meta、Microsoft、Amazon/AWS、xAI、NVIDIA） {#s5}

> 标记：`PUBLIC_CONTENT`。A 组唯一主责 8 家；窗口内事件 ID A01–A20。除注明「背景，非本周」者外，均落在冻结窗内。

### OpenAI
- 本周动态：OpenAI 于 10 月 7 日把新一代 GPT‑6 面向全体 ChatGPT 用户推送（A01）。据 OpenAI 官方博客《GPT‑6 and Intelligent UI for everyone》，本次为「每周 1.2 亿+ ChatGPT 用户」带来新一代 GPT‑6，并按付费层级分层下发：9to5Mac（10/7）报道，GPT‑6 Sol 面向 Plus/Pro/Business/Enterprise，GPT‑6 Luna 次日起向 Free/Go 逐步放开。同一更新引入 **Intelligent UI**：GPT‑6 依据问题类型自主组合文本、图表、可点按钮、表单与交互组件作答，官方称配套了原生、可流式的组件库与编译器，界面随模型生成逐步渲染；官方内部评测称 GPT‑6 Extra High 可在 GPT‑5.6 Medium 的时延内开始作答，总体得分优于 GPT‑5.6 Extra High，需联网搜索时 GPT‑6 Instant 平均提前 44% 开始作答。10 月 5 日 OpenAI 发布 **ChatGPT 广告新视觉格式与测量体系**（A02），宣布在图片生成中测试新广告位（先面向美国 Free/Go），并接入 Hightouch、Tealium、LiveRamp 及 AppsFlyer、Triple Whale 等归因伙伴，披露早期伙伴数据（WeightWatchers 在 ChatGPT Ads 的归因 CPA 比其付费搜索混合基准低 15.3%）。10 月 4–8 日另有 EU 文本溯源方案（A04）、与 Atlassian 扩大合作（A03）、安全博客「打击 AI 支撑的假前线行动」（A05）等密集动作。
- 企业维度分析：
  - 战略：一手抓「前沿模型普惠化 + 入口扩张」，一手抓「广告变现」。GPT‑6 同时进入 ChatGPT 与 API，并通过 Intelligent UI 把 ChatGPT 从问答框改造成可产出交互工具/界面的执行层，指向「AI 原生消费平台 + Agent 商业入口」（事实：官方博客；分析判断：Intelligent UI 是抢占「任务起点」而非「答案终点」的战略动作）。
  - 产品/市场：>1.2B 周活；Intelligent UI 走 WEB+移动；广告从免费层切入、以测量/归因体系补齐广告主信心（事实）。企业侧以 Atlassian 为样板：GPT‑6 家族驱动 Rovo 与 Atlassian 平台 Agents，3,000+ Atlassian 开发者使用 Codex（事实，官方）。
  - 资本/组织/人才：本周未公开新增融资/估值/高管变动（未公开）。
  - 风险：广告进入消费入口的隐私与品牌安全争议；Intelligent UI 的实际可用性与时延为厂商自评、未独立验证；开源/监管对文本水印的要求（EU）带来合规改造成本（分析判断）。
- 关键数据：>1.2B 每周 ChatGPT 用户；GPT‑6 Instant 联网搜索平均提前 44% 作答；3,000+ Atlassian 开发者使用 Codex；WeightWatchers 归因 CPA 低 15.3%（来源见下，均厂商自报/伙伴数据）。
  - 来源：https://openai.com/index/gpt-6-for-everyone/ （2026-10-07）；https://9to5mac.com/2026/10/07/openai-brings-gpt-6-to-chatgpt-and-debuts-intelligent-ui/ （2026-10-07）；https://openai.com/index/new-chatgpt-ads-format-and-measurement/ （2026-10-05）；https://openai.com/index/atlassian-partnership/ （2026-10-06）
- 原文链接：https://openai.com/news/ （2026-10-08 got）；https://openai.com/index/gpt-6-for-everyone/ ；https://openai.com/index/new-chatgpt-ads-format-and-measurement/ ；https://openai.com/index/atlassian-partnership/
- 影响判断：GPT‑6 把「前沿能力 + 交互界面 + 广告变现」三件事绑在一起，标志头部厂商的竞争从「模型分数」转向「任务入口与商业闭环」；对解决方案从业者，Intelligent UI 意味着可直接在会话内产出轻量工具/可视化，减少自建 UI 的集成成本，但也提高对厂商入口的依赖（R1）；广告+归因体系的搭建说明「消费级 AI 流量」正在被定价（R4）。

### Google（含 DeepMind / Gemini / Google Cloud）
- 本周动态：Google Cloud 于 10 月 8 日在「Gemini at Work 2026」发布 **Gemini agent**——一个「单一通用工作 Agent」（A06）：可回答问题、处理知识工作、生成图像/媒体、写并运行代码，从单一 prompt 框完成；内联进 Gmail/Drive/Docs/Slides/Sheets/Chat/Calendar，具备跨端（web/iOS/Android/Windows/Mac，CLI/Workspace/Microsoft 365/Slack）常驻记忆与多 Agent 编排——可临时生成带独立身份的 sub-agents，并为公司内部「同事 Agent」分配 @agents.company.com 邮箱与持久存储。CEO Thomas Kurian 披露：过去一年**近 500 家** Google Cloud 客户每家处理超 **1 万亿 tokens**；**近 80%** Google Cloud 客户在使用其 AI 产品；**近 90% 财富 100 强**使用 Gemini Enterprise。同日 Google Cloud 公布与 Zip US 合作打造「AI 原生产品工厂」的 Gemini Enterprise 案例（A07）。10 月 7 日前后 Google 扩展 **SynthID Detector** 内容识别（A08，官方博客 10-07）。DeepMind 侧近期发布为 Gemini 4 Argon（9 月）、EmbeddingGemma 2（10 月）等，未落入本周窗（背景，非本周）。
- 企业维度分析：
  - 战略：把碎片化产品（Vertex AI / Agentspace / Code Assist）收敛为「Gemini Enterprise / Gemini agent」单一企业 Agent 入口，走「一个 Agent + 一个 API + Workspace 内生」的开放但强绑定路线（事实）。
  - 产品/市场：企业渗透数据强（80% 客户用 AI 产品、90% Fortune 100 用 Gemini Enterprise、500 家客户单家 >1 万亿 tokens）；以行业化（金融服务/法律）与成本控制（多模型编排、Smart Routing、实时花销上限）为卖点（事实）。
  - 资本/组织/人才：本周未公开新增融资/估值/高管变动（未公开）。
  - 风险：单一通用 Agent 的可靠性与权限治理是落地难点；对 Workspace/Google Cloud 生态的强绑定可能限制非 Google 客户采用（分析判断）。
- 关键数据：近 500 家 Google Cloud 客户每家 >1 万亿 tokens/年；~80% Google Cloud 客户使用 AI 产品；~90% Fortune 100 使用 Gemini Enterprise（来源：Google Cloud 博客 2026-10-08）。
  - 来源：https://cloud.google.com/blog/products/ai-machine-learning/welcome-to-gemini-at-work-2026 （2026-10-08）；https://www.googlecloudpresscorner.com/press-releases （Zip US，2026-10-08）；https://blog.google/innovation-and-ai/models-and-research/google-deepmind/synth-id-ai-content/ （2026-10-07）
- 原文链接：https://cloud.google.com/blog/products/ai-machine-learning/welcome-to-gemini-at-work-2026 ；https://www.googlecloudpresscorner.com/press-releases ；https://blog.google/innovation-and-ai/models-and-research/google-deepmind/synth-id-ai-content/
- 影响判断：Google 用「单一通用 Agent」正面狙击 OpenAI 的企业入口与 Microsoft Copilot；对搭方案的从业者，Gemini agent 的「@company.com 同事 Agent + 云端常驻记忆」提供了可参照的企业级 Agent 落地范式（R1），但其开放性与跨云兼容性仍需验证。

### Anthropic
- 本周动态：Anthropic 于 10 月 7 日发布 **Claude Haiku 5.5**（A09），官方定位为「迄今最快、最便宜、最强的小模型」，面向高并发、成本敏感的任务：据 VentureBeat 读取的发布材料，短请求（<10 万 tokens）定价为 $0.10/百万输入、$0.50/百万输出，较 Haiku 4.5 降价约 90%；超过 10 万 tokens 时升至 $0.50/$2.50（降 50%）。Anthropic 称约 90% 的 Haiku 4.5 请求属短请求，综合 tokenizer 变化后典型负载成本约降 75%。厂商自报 benchmark：OSWorld 2.1 计算机操作由 Haiku 4.5 的 15.7% 跃升至 72.4%，Terminal-Bench 4.0 agent 编程由 0.0% 升至 39.2%（均为厂商口径、未独立验证）。同期 Anthropic 在 SF Tech Week 宣布**扩大 Claude for Startups**（A11，TechCrunch 10/6）：符合条件（近 5 年成立或近 2 年融资）的初创可获 1 年免费 Claude Team（最多 5 个高级席位）、$1,000 API credits、Claude Marketplace 插件访问权。10 月 8 日发布**《2026 使用政策更新》**（A10）：新增「禁止欺骗性宣传与虚假活动」章节，聚焦影响行动、武器开发、监控滥用，并澄清健康/金融高风险用例与 Claude 自主执行物理动作的控制，政策 11 月 12 日生效。
- 企业维度分析：
  - 战略：以「价格战 + 入门小模型 + 初创生态」争夺高并发生产工作负载的默认入口，把小模型定位为 Opus/Sonnet 的「支撑工人」而非替代（事实）。
  - 产品/市场：Haiku 5.5 与 OpenAI GPT‑6 Luna 在短请求四档价格完全对齐，形成正面价格对攻；同时下调 Sonnet 5.5 缓存费、给 Max/Team 订阅者月度 API credits（事实）。创业补贴直接抢占 Builder 心智（分析判断）。
  - 资本/组织/人才：本周未公开新增融资/估值；政策与合规团队持续输出监管文档（事实）。
  - 风险：厂商自报 benchmark 未独立复核；Haiku 5.5 在长上下文的实际 token 消耗增加，降价的实际净值取决于工作负载；政策收紧可能影响部分高风险行业客户（分析判断）。
- 关键数据：Haiku 5.5 短请求 $0.10/$0.50（输入/输出，每百万 tokens，较 Haiku 4.5 降 ~90%），长请求 $0.50/$2.50；OSWorld 2.1 72.4%、Terminal-Bench 4.0 39.2%；初创计划 1 年免费 Claude Team（5 席位）+ $1,000 credits。
  - 来源：https://venturebeat.com/technology/anthropic-launches-claude-haiku-5-5-with-90-api-price-reduction-matching-gpt-6-luna （2026-10-07）；https://www.unite.ai/anthropic-releases-claude-haiku-5-5-cutting-small-model-api-prices/ （2026-10-07）；https://techcrunch.com/2026/10/06/anthropic-gives-startups-a-free-year-of-enterprise-service-and-1000-in-token-credits/ （2026-10-06）；https://www.anthropic.com/news/2026-usage-policy-update （2026-10-08）
- 原文链接：https://www.anthropic.com/news （2026-10-08）；https://venturebeat.com/...haiku-5-5... ；https://techcrunch.com/2026/10/06/anthropic-gives-startups... ；https://www.anthropic.com/news/2026-usage-policy-update
- 影响判断：Anthropic 用 Haiku 5.5 把「小模型性价比」拉到与 OpenAI 同价，标志前沿厂商的价格战从旗舰外溢到高并发生产层；对解决方案从业者，短请求单价跳水意味着文档处理/分类/检索类 Agent 的单位成本显著下降，可作为多 Agent 架构里「廉价执行层」的选型依据（R1）。初创补贴则说明头部厂商正用免费额度争夺开发者分发（R4）。

### Meta AI
- 本周动态：Meta 本周的公开动作主要经由 Windows 生态落地——在 10 月 7 日 Microsoft Windows and Surface 活动上，微软宣布 **Meta 的 Muse 个人 AI Agent 将以原生应用形式登陆 Windows PC**（A12，Microsoft 活动披露、Engadget 等现场报道），并采用微软「Microsoft Execution Containers（MXC）」沙箱安全机制；据报道 Muse for Windows 尚无发布时间表。Muse 是 Meta 9 月 8 日推出的「面向所有人」的安全私有个人 Agent（背景，非本周）：运行在自建 **Muse Secure VM** 云虚拟机，由 Meta 迄今最强模型 **Muse Spark** 驱动，可通过 Muse app 或 WhatsApp 对话，能开浏览器、填表、代为议价与下单，并接入 Stripe Link（含 Link 购买保护、一次性卡号隐藏真实卡）与即将支持的 Shop Pay/1Password。另 Meta 9 月 29 日 White House 场景随 Trump 与科技巨头会面（背景，非本周）。**Meta 在冻结窗内未发布自有前沿模型或重大融资/组织公告**；窗口内可核验的实质动态即为 Muse 的 Windows 原生分发落地。
- 企业维度分析：
  - 战略：走「消费级个人 Agent + 分发最大化（WhatsApp/Windows 预装）」路线，用 Muse Secure VM/Sentinel 双 Agent 架构对冲「把账号与支付交给 Agent」的安全顾虑（事实 + 分析判断）。
  - 产品/市场：Muse 强调零学习成本、「为数十亿人构建」；与 Windows 原生集成、叠加 Stripe Link 购买保护，是消费 Agent 商业化（代付/交易分成）的关键铺垫（分析判断）。
  - 资本/组织/人才：本周未公开新增融资/估值/高管变动（未公开）。背景口径：Meta 曾将 2026 CapEx 区间上调（据 Yahoo Finance 8 月报道），非本周数字。
  - 风险：消费 Agent 的支付与隐私责任（购买保护、审计轨迹）是核心风险点；尚无发布日期的 Windows 版本意味着落地时间不确定；与 OpenAI/Google 在企业入口的正面竞争尚未体现在 Meta 本周动作（分析判断）。
- 关键数据：Muse for Windows 无发布时间表（微软 2026-10-07 披露）；其余 9 月及更早数据为背景。本周可核验关键数字：无（未公开）。
  - 来源：https://www.engadget.com/2280298/everything-announced-at-microsofts-windows-and-surface-event/ （2026-10-07）；https://ai.meta.com/muse/ （2026-10-08 访问）；https://about.fb.com/news/2026/09/introducing-muse-personal-ai-agent/ （2026-09-08，背景）
- 原文链接：https://www.engadget.com/2280298/everything-announced-at-microsofts-windows-and-surface-event/ ；https://about.fb.com/news/2026/09/introducing-muse-personal-ai-agent/ （背景）；https://ai.meta.com/muse/
- 影响判断：Meta 把消费级个人 Agent 塞进 Windows 分发，标志「个人 Agent 之争」从手机/浏览器延伸到桌面 OS 入口，与 OpenAI/微软/Google 在同一战场交汇；对搭方案的从业者，Muse Secure VM + 支付保护的架构是可复用的「高信任消费 Agent」参考范式（R1），但其交易闭环能否形成可持续抽成仍待观察（R4）。

### Microsoft（含 Azure / Copilot）
- 本周动态：Microsoft 于 10 月 7 日在旧金山举行 **Windows and Surface 活动**，核心是把 Windows 定位为「AI Agent 最安全的平台」与「混合智能」操作系统（A13）。官方博客《Building Windows for hybrid intelligence》与《Microsoft Execution Containers: policy-driven containment for AI agents》同日发布：推出 **Microsoft Execution Containers（MXC）**，为本地 Agent 提供策略驱动的隔离/沙箱；Copilot 更深地「内建进 Windows 核心」，可在授权下基于本地文件执行操作、本地跑模型并调用云端算力补充；Windows 搜索被改造为类 Copilot 聊天入口（今秋起支持暗色模式、截图、音量、发短信等数千个快捷动作）；提供「Get Started」工具与 Portable Computer 等首批 Agent。硬件侧发布 **Surface Laptop Ultra**，搭载 **NVIDIA RTX Spark** SoC，NVIDIA CEO 黄仁勋到场与 Nadella 对谈；官方强调「为每家每户、每张桌子带来无限量智能」。同时微软把**本地版 MAI-Code-1.1-Flash**（编码优化的 MoE：137B 总参 / 6.8B 激活）带到 Windows 与 GitHub Copilot，实现沙箱化本地编码工具（A14）。Azure 侧本周以 Partner Center/FabCon Europe 的 AI 辅助运维与存储更新为主（A15）。
- 企业维度分析：
  - 战略：把「入口之战」从云上 Copilot 延伸到桌面 OS——用 MXC 安全原语 + 本地模型，抢占「个人 Agent 运行在用户主设备」这一战略高地，与 Meta Muse、Google Gemini 桌面对齐（分析判断 + 事实）。
  - 产品/市场：Copilot 从「应用」变为「OS 层」；Windows 搜索聊天化、Agent 开发平民化（Get Started/Portable Computer）；Surface Laptop Ultra + RTX Spark 打开高端本地 AI PC 硬件位（事实）。
  - 资本/组织/人才：本周未公开新增融资/估值/高管变动（未公开）。硬件与芯片合作（NVIDIA/MediaTek/Adobe）体现生态协同（事实）。
  - 风险：本地 Agent 的安全与权限边界（MXC 效果待验证）；Windows Agent 生态相对 Meta Muse 的用户规模仍在追赶；对 NVIDIA 芯片的依赖加深（分析判断）。
- 关键数据：MAI-Code-1.1-Flash 本地版 137B 总参 / 6.8B 激活（来源：commandline.microsoft.com 2026-10-07）；Surface Laptop Ultra 搭载 RTX Spark（来源：Engadget 2026-10-07）。其余为产品能力描述，未披露销量/收入。
  - 来源：https://blogs.windows.com/windowsexperience/2026/10/07/building-windows-for-hybrid-intelligence/ （2026-10-07）；https://blogs.windows.com/windowsdeveloper/2026/10/07/microsoft-execution-containers-policy-driven-containment-for-ai-agents/ （2026-10-07）；https://www.engadget.com/2280298/everything-announced-at-microsofts-windows-and-surface-event/ （2026-10-07）；https://commandline.microsoft.com/local-models-sandboxed-tools-github-windows/ （2026-10-07）；https://news.microsoft.com/windows-surface-october-2026-news/ （2026-10-08）
- 原文链接：https://blogs.windows.com/windowsexperience/2026/10/07/building-windows-for-hybrid-intelligence/ ；https://www.engadget.com/2280298/everything-announced-at-microsofts-windows-and-surface-event/ ；https://news.microsoft.com/windows-surface-october-2026-news/
- 影响判断：微软用 OS 层的 MXC 沙箱 + 本地模型，为「个人 Agent 跑在自己电脑上」提供安全底座，实质是把 Agent 安全从应用问题上升为操作系统问题；对解决方案从业者，MXC 的隔离/策略模型是本地 Agent 交付合规的关键参照，但也意味着深度绑定 Windows 生态（R1）。

### Amazon / AWS
- 本周动态：AWS 在 10 月 5 日《AWS Weekly Roundup》中回顾 **Amazon Bedrock Managed Agents（BMA）公开预览**——该能力由 AWS 与 OpenAI 联合开发，基于定制版 OpenAI Agents API、以 AWS 原生方式运行（A16）：可选自托管执行环境或 Bedrock AgentCore Runtime，每个 Agent 拥有独立 IAM 角色，支持高风险动作前的人工审批、CloudTrail 审计，并可通过 MCP 连接工具；预览期除底层资源消耗外不额外收费，已在 US East（N.Virginia）、US West（Oregon）、US East（Ohio）开放。同一轮更新还包括在 Bedrock 上引入新的前沿模型、Q3 服务可用性变更与 Kiro 工作流。10 月 7–8 日，AWS 在 IBC 2026 发布四项新的 AWS Elemental 能力，把 AI、个性化与智能变现引入直播视频工作流（A17）。**窗口内 AWS 未见重大融资/并购或独立 CapEx 公告**；可核验实质为「Bedrock 成为 OpenAI 模型在 AWS 上的托管 Agent 入口」。
- 企业维度分析：
  - 战略：把 Bedrock 从「模型市场」升级为「企业 Agent 运行底座」，并以「OpenAI 模型 + AWS 原生治理」的组合，把最热模型拉进自家云（事实 + 分析判断）。
  - 产品/市场：BMA 主打身份/权限/审计/审批等企业治理要素，与 Google Gemini agent、微软 Copilot 的「企业 Agent 平台」正面竞争；无额外费用是快速铺量的策略（事实）。
  - 资本/组织/人才：本周未公开新增融资/估值/高管变动（未公开）。背景：Amazon 2026 CapEx 计划约 $200B 量级（据 Reuters 2 月、fierce-network 7 月报道，非本周数字）。
  - 风险：托管 Agent 的定价可持续性（预览免费、GA 后涨价）；企业治理能力能否真正降低落地门槛仍是未知；对第三方模型（OpenAI）的依赖削弱自有模型差异化（分析判断）。
- 关键数据：BMA 预览期内除底层资源外不额外收费；开放 3 个美国区域；每 Agent 独立 IAM 角色 + CloudTrail 审计（来源：AWS What's New 2026-09-30 / AWS News Blog 2026-10-05）。CapEx 数字属背景，非本周。
  - 来源：https://aws.amazon.com/blogs/aws/aws-weekly-roundup-amazon-bedrock-managed-agents-powered-by-openai-q3-service-availability-updates-kiro-workflows-and-more-october-5-2026/ （2026-10-05）；https://aws.amazon.com/about-aws/whats-new/2026/09/bedrock-managed-agents-preview/ （2026-09-30）；https://aws.amazon.com/blogs/media/aws-ai-shines-at-ibc-2026/ （2026-10-07）
- 原文链接：https://aws.amazon.com/blogs/aws/aws-weekly-roundup-amazon-bedrock-managed-agents-powered-by-openai-...-october-5-2026/ ；https://aws.amazon.com/about-aws/whats-new/2026/09/bedrock-managed-agents-preview/ ；https://aws.amazon.com/blogs/media/aws-ai-shines-at-ibc-2026/
- 影响判断：AWS 用「OpenAI 模型 + 原生治理」托管 Agent，把云厂与模型厂的竞合摆到台面上——企业可以「用 OpenAI 的模型、留 AWS 的治理」；对解决方案从业者，BMA 的 IAM/审批/审计模型是云上 Agent 合规交付的直接抓手（R1）。免费预览到 GA 定价的落差，是后续观察其真实采用与成本的关键（R4）。

### xAI（SpaceXAI）
- 本周动态：xAI（现对外品牌 SpaceXAI）在冻结窗内的主要可核验动态是**组织/品牌层面**：据 Reuters 10 月 4 日报道，SpaceX CEO Elon Musk 于周日发帖称将把公司 AI 部门更名为 **SpaceXSI**，跟随美国总统 Trump 提出的把「Artificial Intelligence」改称「Super Intelligence」的号召；报道明确指出**尚未设定更名日期**（A18）。除此之外，**xAI 在 10 月 2–8 日未发布新的 Grok 模型或重大产品/融资公告**：其最新模型 Grok 4.7 于 **9 月 21 日**发布（背景，非本周），Grok Bot for Enterprise 于 9 月 3 日发布（背景，非本周）。核验范围：官方 x.ai/news 列表、xAI 文档 Release Notes、Reuters/TNW/Fox Business 等主流报道；上述来源在窗口内均无 xAI 自有重大发布。**结论：本周无重大公开产品/资本动态，仅有更名表态。**
- 企业维度分析：
  - 战略：跟随美国政策话语（「Super Intelligence」）做品牌对齐，强化与 SpaceX/政府叙事的绑定（分析判断，事实为更名表态）。
  - 产品/市场：窗口内无新品；Grok 系列此前已通过 Microsoft Foundry、Gemini Enterprise、Amazon Bedrock、GitHub Copilot 等第三方渠道分发（背景，非本周），显示其走「寄生式渠道」策略。
  - 资本/组织/人才：背景口径——xAI 于 2026 年 2 月被 SpaceX 以约 $250B 估值收购，7 月更名 SpaceXAI，8 月收购一家 AI 编程初创；本轮 1 月完成 $20B E 轮。窗口内无新增融资/高管变动（未公开）。
  - 风险：核心模型与团队随并入 SpaceX 而组织结构变动，产品节奏与人才稳定性存不确定性；在政府部门采用上落后于 OpenAI 等竞对（背景，据 Reuters 5 月报道）。本周未见新增重大风险。
- 关键数据：本周未公开新增数字。背景：Grok 4.7 发布日 2026-09-21；被 SpaceX 收购估值约 $250B（2026-02）；$20B E 轮（2026-01）——均为背景，非本周。
  - 来源：https://www.reuters.com/business/media-telecom/musk-says-he-will-rename-spacexai-spacexsi-2026-10-04/ （2026-10-04）；https://x.ai/news （2026-10-09 访问）；https://docs.x.ai/developers/release-notes （2026-10-09 访问）
- 原文链接：https://www.reuters.com/business/media-telecom/musk-says-he-will-rename-spacexai-spacexsi-2026-10-04/ ；https://x.ai/news
- 影响判断：xAI 本周是「静默 + 品牌表态」的组合，说明其近期重心在并入 SpaceX 后的组织与叙事整合而非产品迭代；对观察者，其模型分发已高度依赖第三方渠道，值得持续追踪的是更名后是否影响政府合同与渠道合作（R1/R4）。

### NVIDIA
> 主责：A 组（主干）；下列【D 回填】证据来自 D组-evidence-to-A.md，标注来源。
- 本周动态：NVIDIA 在 10 月 7–8 日连发两项动作。其一，与微软在旧金山 Windows and Surface 活动联合发布面向「个人 AI Agent 时代」的 Windows PC 方案，核心是 **NVIDIA RTX Spark 超级芯片**（A19）：官方称其为「世界首款专为个人 Agent 打造的 Windows PC」平台，提供最高 **1 petaflop** AI 算力、**最高 128GB 统一内存**，集成 Blackwell RTX GPU（6,144 CUDA cores、第五代 Tensor Core/FP4）、通过 NVLink-C2C 连接 **20 核 Grace CPU**（CPU 由 MediaTek 协同设计）；本地可运行最高 120B 参数 LLM（最高 100 万 token 上下文）、渲染 90GB+ 3D 场景、编辑 12K 视频、生成 4K AI 视频，并运行 **NVIDIA OpenShell** 与 Windows 新安全原语以安全承载 Agent。Adobe 正为 RTX Spark 重构 Photoshop/Premiere（称 AI 与图形性能 2×）；今秋起 ASUS、Dell、HP、Lenovo、Microsoft Surface、MSI 将推出相关笔记本/台式机，Acer、GIGABYTE 后续跟进（Reuters 10/7 现场确认）。其二，10 月 8 日 NVIDIA 在华盛顿「Science: A New Golden Age」活动宣布**未来五年投入价值 $10 亿**用于推进美国「超级智能」科研与量子计算、医疗、能源安全，并呼应 Trump 的 Genesis Mission（A20）。背景（非本周）：9 月 28 日 NVIDIA 授权**追加 $1500 亿**股票回购（总额升至 $2350 亿，史上最大），同日发布 Open Agent Safety Platform。
- 【D 回填】具身/物理 AI 生态投资：据 The Information 2026-10-07 报道，NVIDIA 曾考虑/正洽谈向人形机器人公司 Figure AI 投资 **10 亿美元**（一年前已参与 Figure 超 10 亿美元融资轮），意图把 GPU 从数据中心拓展到家庭场景、让用户本地运行 AI（来源：AzerNews 2026-10-07 转述，**未独立核实**）。
- 【D 回填】Vera Rubin 部署：CoreWeave 2026-10-07 公告其孟买 Navi Mumbai 240 MW 园区计划部署 **NVIDIA Vera Rubin 平台**（训练/推理/推理链/agentic 负载）；背景（非本周）：CoreWeave 2026-09-30 已开始向 Cognition 等客户生产级交付 NVIDIA Vera Rubin NVL72（来源：CoreWeave 官方 / D组-evidence-to-A）。
- 企业维度分析：
  - 战略：把算力从数据中心延伸到「个人 AI 电脑」，用 RTX Spark + OpenShell 抢占端侧 Agent 的芯片与运行时标准；同时以 $10 亿科研投入绑定美国政府/国家实验室叙事（事实 + 分析判断）。
  - 产品/市场：从 GPU 厂商向「PC SoC + Agent 运行时」扩张，绑定微软、Adobe、OEM 生态；本地 Agent 需求被定位为新的算力增长曲线（事实）。
  - 资本/组织/人才：本窗口无新增融资/高管变动；**强烈资本信号**为 9 月 28 日 $1500 亿回购（背景，非本周）与 Q2 FY2027 创纪录 $962 亿营收（背景，据 WSJ）。本周资本信号为 10 月 8 日 $10 亿科研承诺（事实）。
  - 风险：端侧 1 petaflop 的实际能效/散热与软件生态成熟度待验证；$10 亿科研投入回报周期长；美国政策绑定带来地缘与出口管制敞口（分析判断）。
- 关键数据：RTX Spark 最高 1 petaflop、最高 128GB 统一内存、Blackwell RTX GPU 6,144 CUDA cores + 20 核 Grace CPU；本地支持最高 120B 参数 LLM / 100 万 token 上下文；$10 亿五年科研投入；背景：$1500 亿回购（2026-09-28）、Q2 营收 $962 亿。
  - 来源：https://nvidianews.nvidia.com/news/nvidia-microsoft-windows-pcs-agents-rtx-spark （2026-10-08）；https://www.reuters.com/business/microsoft-nvidia-ceos-unveil-new-ai-laptop-san-francisco-event-2026-10-07/ （2026-10-07）；https://nvidianews.nvidia.com/news/nvidia-commits-1-billion-to-advance-us-science-over-the-next-five-years （2026-10-08）；https://nvidianews.nvidia.com/news/nvidia-announces-a-150-billion-share-repurchase-authorization-increase （2026-09-28，背景）；D 回填：https://www.azernews.az/region/265146.html （2026-10-07）；https://www.coreweave.com/news/coreweave-enters-india-expanding-ai-cloud-platform-with-adaniconnex （2026-10-07）
- 影响判断：NVIDIA 借 RTX Spark 把「Agent 算力」下沉到 PC，等于在数据中心之外再开一条算力需求曲线，并绑定微软 OS 与 OEM；对解决方案从业者，端侧 1 petaflop + 128GB 统一内存使「本地跑大模型/多 Agent」首次具备硬件基础，但 OpenShell/MXC 的沙箱能力与生态工具成熟度仍是落地前提（R1）。$10 亿科研承诺是资本向政策/科研侧延伸的信号（R4）。

## 六、分章正文 · B 组（阿里/Qwen/夸克、字节/豆包/火山、腾讯/混元/元宝、百度/文心/千帆、华为/昇腾/盘古、DeepSeek、智谱、月之暗面/Kimi、MiniMax） {#s6}

> 标记：`PUBLIC_CONTENT`。B 组 9 家；事件 ID B01–B03 + 阿里（Qwen-Image）。窗口内 4 家有料、5 家静默（国庆假期）。

### 阿里 / Qwen / 夸克
- 本周动态：本周阿里在模型侧有一项可入刊动作——2026-10-02，阿里云「百炼」大模型服务平台上线 Qwen-Image-2.1-Pro（模型 ID `qwen-image-2.1-pro`），定位为一个统一的文生图与图像编辑模型，其视觉生成组件仅含 70 亿参数（32 层单流 DiT）。据阿里云官方文档，该版本含四项关键改进：①紧凑高效，采用轻量级架构、混合粒度注意力机制与前缀 KV 缓存复用，在低计算开销下实现高质量生成；②原生透明支持，可从文本生成普通或透明（RGBA）图像、编辑透明图层并从照片中提取主体，全部由单一模型完成；③多功能编辑，支持最多 10 张参考图像，可通过圆形、手绘标注或独立蒙版指定局部编辑区域，并保留人物与产品身份特征；④改进字体排印、人像光照与细节表现。背景（非本周）：Qwen-Image-2.1 的开源版此前于 2026-09-24 前后发布，阿里方面当时称其在图像能力上对标并「击败」Google 的 Nano Banana 2.0；本周动作是把该能力以托管 API 形式落到百炼商业化通道。另据 ITHome（2026-09-28，背景，非本周），千问 App 已与夸克网盘深度打通，可调用 Agent 技能实现资料查找、照片海报创作与自动上传分享。C 端（千问 App、夸克）与 B 端（百炼）双线本周均无新的分发/补贴级动作披露。
- 企业维度分析：
  - 战略：维持「模型能力持续迭代 + 通过百炼做 API 商业化」的双轮，把开源版当作生态入口、把托管版当作收入与合规通道；图像/多模态被继续当作差异化卖点。
  - 产品/市场：Qwen-Image-2.1-Pro 补齐百炼在图像生成与编辑的旗舰位（此前为 Qwen-Image-2.0-Pro，2026-06-22 上线），面向电商素材、营销海报、透明图层设计等可付费场景；对搭方案者的意义是「文生图/图像编辑」可直接走百炼托管，省去自建推理与 RGBA 处理链路，集成门槛降低。
  - 资本/组织/人才：本周无新增公开融资/组织/人事披露（未公开）。
  - 风险：图像生成赛道竞争激烈（Google Nano Banana 系列、字节 Seedream 等），价格与效果持续被拉平；托管版定价与开源授权条款（有媒体质疑其许可限制）仍是采用方的顾虑点。
- 关键数据：Qwen-Image-2.1-Pro 视觉生成组件约 70 亿参数（32 层单流 DiT）；支持最多 10 张参考图；上架日期 2026-10-02（来源见下）。定价与调用量「本次未取得」。
- 原文链接：[阿里云文档｜模型上下架与更新](https://help.aliyun.com/zh/model-studio/newly-released-models)（2026-10-02 条目，6 天前更新，已读）、[阿里云文档｜qwen-image-2.1-pro 模型信息](https://help.aliyun.com/zh/model-studio/qwen-image-2-1-pro)（已读）
- 影响判断：这是一次常规但有信号意义的「能力—通道」落地：阿里把前沿图像能力从开源引流转向百炼托管变现，说明其 2026 下半年商业化优先级继续高于纯刷榜。对做解决方案的从业者，图像生成/编辑的可选托管供给又多一家旗舰级选项，集成与合规成本下降；下一步看百炼侧的定价与真实调用量是否公开。

### 字节跳动 / 豆包 / 火山引擎（静默）
- 本周动态：本周无重大公开动态。核验范围与检索记录：以「字节跳动 豆包 火山引擎 2026年10月」「豆包 火山引擎 10月8日」「火山引擎 豆包 发布 升级」「字节跳动 Seed 模型 10月 2026」「字节跳动 豆包 国庆 2026」等查询词，经 serper（Google）多轮检索并核对原文日期，可读到的最新官方/权威来源均落在冻结窗外——[36 氪｜豆包跨越「临界点」后，字节 AI 下一步怎么走？](https://m.36kr.com/p/3867066152713092)（发布于约 2026-10-01，窗口外）、[火山方舟｜产品更新公告](https://www.volcengine.com/docs/ark/product-update-announcements)（页面标注最近更新 2026-09-13）、[火山方舟｜模型列表](https://www.volcengine.com/docs/82379/1554521)（2026-09-28）、[Seed2.1 发布](https://seed.bytedance.com/zh/blog/seed2-1-officially-released-advancing-ai-productivity)（2026-06-23）、[Seedance 2.5 发布](https://seed.bytedance.com/zh/blog/one-take-creation-flexible-referencing-introducing-seedance-2-5)（2026-07-31）。结合国庆假期（10-01~10-05）与 10-06~10-08 未检索到豆包/火山引擎新模型、组织或商业化公告，判定本周为假期静默；若官方在窗口末段有未进索引的公告，属工具可及性缺口，非确认无动态。
- 企业维度分析：
  - 战略：无本周新增变化；近期主线仍是 Seed 系列（大模型 + Seedance 视频）与火山引擎 AI 云原生（Agent 开发到部署）的企业服务化。
  - 产品/市场：无本周新增发布；豆包 C 端与火山方舟 B 端既有格局未见变化。
  - 资本/组织/人才：本周无公开披露（未公开）。
  - 风险：本周未见重大新增风险；持续风险为模型迭代节奏一旦被竞品拉开，C 端入口与云调用份额会承压。
- 关键数据：本周无可入刊新数字；背景数据（非本周）：火山引擎 2026-04-03 曾披露豆包模型日均 Token 破 120 亿。
- 原文链接：[36 氪｜豆包跨越「临界点」后，字节 AI 下一步怎么走？](https://m.36kr.com/p/3867066152713092)（窗口外，仅作背景）、[火山方舟｜产品更新公告](https://www.volcengine.com/docs/ark/product-update-announcements)
- 影响判断：字节本周进入假期静默不改变其国内大模型第一梯队的定位；对从业者，本周无新增可依赖的模型/平台能力，春节与 Force 大会之外的投放节奏预计仍集中在下半月。下一步看 Force/秋季发布窗口与豆包 App 的 Agent 化动作。

### 腾讯 / 混元 / 元宝（静默）
- 本周动态：本周无重大公开动态。核验范围与检索记录：以「腾讯 混元 元宝 大模型 2026年10月」「腾讯 混元 元宝」「腾讯 混元 2026年10月 发布」「腾讯 混元 10月8日」等查询词，经 serper（Google）多轮检索并核对原文日期，可读到的最新官方/权威来源均在冻结窗外——[腾讯混元官网｜Hy4 preview 发布](https://hunyuan.tencent.com/research/hy4-preview)（页面标注 2026-09-21）、[新浪财经｜腾讯混元 Hy4 preview 发布并开源](https://finance.sina.com.cn/roll/2026-08-28/doc-inipwaiv5706885.shtml)（2026-08-28）、[东方财富｜腾讯二季度算力采购爆增](https://wap.eastmoney.com/a/202608133839523548.html)（2026-08-13）。另据[腾讯云开发者社区](https://cloud.tencent.com/developer/article/2745597)（2026-09-17），2026 腾讯全球数字生态大会定档 10 月 29 日，属窗口后事件、非本周动态。结合国庆假期，判定本周为静默；窗口末段若有未进索引公告，属工具可及性缺口。
- 企业维度分析：
  - 战略：无本周新增变化；此前主线为混元 Hy4 系列发布/开源（元宝接入 Hy4 preview）与「打造参数更大的混元 4」，以及云侧算力采购扩张。
  - 产品/市场：元宝已完成对最新混元 Hy4 preview 的接入，Agent 与深度推理能力宣传升级（背景，非本周）；本周无新发布。
  - 资本/组织/人才：本周无公开披露（未公开）。
  - 风险：本周未见重大新增风险；持续风险为 C 端元宝与豆包/千问的入口争夺、以及大模型自研与外部采购（如接入 DeepSeek）之间的定位平衡。
- 关键数据：本周无新数字；背景（非本周）：2026 腾讯全球数字生态大会 10-29 定档；混元 Hy4 preview 总参数 770B、激活 49B、上下文 1M（2026-09 官方页面）。
- 原文链接：[腾讯混元官网｜Hy4 preview 发布](https://hunyuan.tencent.com/research/hy4-preview)、[腾讯云开发者社区｜数字生态大会定档](https://cloud.tencent.com/developer/article/2745597)
- 影响判断：腾讯本周静默，但 10-29 数字生态大会是明确的下一个观察锚点，预计混元新版本与 Agent 落地成果届时集中释放。对从业者，本周无新增可依赖能力，10 月底的大会才是获取其企业侧 Agent 方案的关键时点。

### 百度 / 文心 / 千帆（静默）
- 本周动态：本周无重大公开动态。核验范围与检索记录：以「百度 文心 千帆 2026年10月」「百度 文心 千帆 10月 2026 最新」「百度 文心 10月8日」「百度 智能云 千帆 2026年10月」「百度 文心 国庆 2026」等查询词，经 serper（Google）多轮检索并核对原文日期，可读到的最新官方/权威来源均在冻结窗外——[STCN｜2.4 万亿参数原生全模态大模型百度文心 5.0 正式版上线](https://www.stcn.com/article/detail/3607461.html)（2026-01-22）、[新浪财经｜百度文心 5.0 正式版发布](https://finance.sina.com.cn/roll/2026-01-23/doc-inhihhae1052072.shtml)（2026-01-23）。官方文档 [百度千帆｜更新动态](https://cloud.baidu.com/doc/qianfan/s/Mmh8l4qwj) 通过 web_fetch 仅返回标题（正文由脚本渲染，未取得可读更新条目，属取证缺口）；[百度千帆｜模型更新记录](https://cloud.baidu.com/doc/qianfan/s/Kmh4stnjp) 亦同。结合国庆假期，判定本周为静默；未进索引公告属工具可及性缺口，非确认无动态。
- 企业维度分析：
  - 战略：无本周新增变化；此前主线为文心 5.0 原生全模态 + 千帆智能体平台（以 Agent 为核心）。
  - 产品/市场：本周无新发布；文心助手（含百度 App 嵌入式）月活与千帆智能体规模的既有宣传数字均非本周新增。
  - 资本/组织/人才：本周无公开披露（未公开）。
  - 风险：本周未见重大新增风险；持续风险为搜索/云 AI 商业化承压与千帆平台在国产模型价格战中的议价空间。
- 关键数据：本周无可入刊新数字；背景（非本周）：文心 5.0 参数规模 2.4 万亿（2026-01 报道，权威媒体报道口径，未独立复核）。
- 原文链接：[STCN｜百度文心 5.0 正式版上线](https://www.stcn.com/article/detail/3607461.html)、[百度千帆｜更新动态（正文渲染未取得）](https://cloud.baidu.com/doc/qianfan/s/Mmh8l4qwj)
- 影响判断：百度本周静默。对从业者，千帆文档正文抓取失败构成轻微取证缺口，但结合多渠道检索可判断本周无新增可依赖能力；下一步观察其云智一体与 Agent 平台的企业落地节奏。

### 华为 / 昇腾 / 盘古
- 事件 B01（事实+分析判断）
- 本周动态：本周（窗口内集中报道）华为围绕昇腾算力释放出一组强信号。2026-10-03 起，多家媒体转发/报道华为轮值董事长徐直军在 2026 华为全联接大会（HC2026，2026-09-17 举行，背景）期间的媒体问答要点：徐直军称「目前很难收集英伟达在中国市场份额的数据，但根据华为收集的数据，昇腾已经超越了英伟达（昇腾中国份额已超英伟达）」；并披露昇腾 950 系列节奏——先上市面向 AI 推理的 950PR，基于昇腾 950DT 的 Atlas 950 SuperPoD 面向 AI 训练、当前处于测试中，大规模供应将在「今年年底或明年年初」开始；徐直军还提到华为因产能不足以满足国内需求，没有计划全面拓展国际市场，仅向少数强需求国家有限供货。新浪财经同步刊出问答全文（2026-10-05），披露 Atlas 950 SuperPoD 基于华为自研 Peerium 计算架构（嵌套 BSP + 统一内存寻址 + 对等互连，目标百万处理器像一台计算机），配套自研 UnifiedBus（灵衢总线）以单一协议同时支持纵向/横向扩展，机架间带宽最高 800 GB/s；搭载 384 颗 910C 的 SuperPoD 已出货 1000 多套，25.6 万卡规模的 SuperCluster 正在部署测试。海思首席科学家廖恒称中国未来两年约 6–7 家前沿实验室将训练 10 万亿–40 万亿参数模型，20 万卡级集群是匹配需求的下限规模。本周动作的实质是：华为把「国产算力自给 + 超节点规模优势 + 份额超越」作为对外叙事主线集中输出（原始事件在 9 月大会，本周为报道与再披露，标注背景）。
- 企业维度分析：
  - 战略：以「芯片—总线—超节点—集群」全栈自研锁定国产 AI 算力底座，把供应能力（而非销售推力）作为扩张约束条件，优先保障国内训练集群。
  - 产品/市场：昇腾 950PR（推理）已上市但总量有限、950DT 超节点（训练）年底/明年初放量；UnifiedBus 单一协议方案对标英伟达 NVLink+InfiniBand 双协议，主打机架间高带宽与低转换开销。对搭方案者：国产训练/推理底座的可选性与供应链确定性上升，但当前供给偏紧、拿货节奏仍是瓶颈。
  - 资本/组织/人才：本周无新增融资/上市披露（未公开）；相关信息由轮值董事长与海思首席科学家对外释放，属管理层表态。
  - 风险：徐直军「昇腾份额超英伟达」为**华为单方口径、未独立复核**，不宜作为市场权威统计；先进制程产能受限、950DT 放量时点存在执行风险；高端光模块（Hi-ONE，NPO 7.2T）量产与供应链是另一约束。
- 关键数据：昇腾 950PR 面向推理、950DT 超节点面向训练（大规模供应「今年年底或明年年初」，据徐直军）；Atlas 950 SuperPoD 机架间带宽最高 800 GB/s、UnifiedBus 协议转换可低至约 150 纳秒；384 卡 SuperPoD 已出货 1000+ 套；25.6 万卡 SuperCluster 部署测试中；资深口径称中国 2 年内 6–7 家实验室将训练 10 万亿–40 万亿参数模型。以上均来自 2026-10-03~10-05 报道（来源见下），份额「超英伟达」为华为单方披露，未独立复核。
- 原文链接：[腾讯新闻｜华为徐直军：昇腾芯片中国份额已超英伟达](https://news.qq.com/rain/a/20261003A09FST00)（2026-10-03，已读全文）、[新浪财经｜徐直军：华为昇腾中国份额已超英伟达！（全文）](https://finance.sina.com.cn/roll/2026-10-05/doc-iniuevrx9438728.shtml)（2026-10-05，已读）、[华为官网｜华为发布全球首个采用 NPO 的超节点——昇腾 960 超节点](https://www.huawei.com/cn/news/2026/9/hc-ascend960-supernode)（2026-09-17，背景）
- 影响判断：华为本周把「国产算力已可自给、份额反超」作为主线释放，若 950DT 超节点如期在年底/明年初放量，将实质抬升国内前沿模型训练的国产化率，并挤压英伟达在华训练市场。对做解决方案者，国产训练底座从「可用」走向「规模化可交付」是重要转折，但需以实际供货与集群实测为准，而非仅凭管理层口径。下一步看 950DT 量产时点与首位客户的训练落地。

### DeepSeek（深度求索）
- 事件 B02（事实+分析判断）
- 本周动态：2026-10-06，彭博社援引知情人士消息（国内多家媒体转载）称，DeepSeek 接近在最新一轮融资中锁定**至少 800 亿元人民币（约合 120 亿美元）**，募资规模远超公司最初约 500 亿元的目标；出资额最高的投资方之一为宁德时代、腾讯控股。消息称已签署的投资条款清单下最终规模有望逼近 1000 亿元，公司最初目标估值约 5000 亿元人民币；本轮落定后下一步是推进公司重组，为 2027 年初潜在 IPO 铺路。此前 2026-06 公司完成首轮外部融资（超 500 亿元/约 74 亿美元，为当时中国 AI 行业最大单轮，梁文锋个人出资约 200 亿元、腾讯 100 亿元、宁德时代体系约 50 亿元），采用有限合伙架构、外部投资方多无投票权且锁定五年，梁文锋仍掌握近 100% 表决权。资本超募的产品支撑为 V4.1 Flash：2026-09-10 发布（官方更新日志确认），具备原生多模态视觉理解，GPQA Diamond 90.9；彭博行业研究 2026-10-05 报告称其中美顶尖模型基准差距已缩小至约 3%（5 月约 9%、年初约 15%）。另据凤凰网科技，国庆期间 DeepSeek Harness 发布新版本，强化插件化与跨平台能力并加入实验性 Claude Code Mods 兼容层；Harness 负责人崔添翼 10-04 发文称其大量时间用于为 DeepSeek 招人和面试，公司目标 AGI。腾讯、宁德时代、DeepSeek 对融资传闻均未予置评/未回复。
- 企业维度分析：
  - 战略：以「极致性价比 + 开源/低成本」路线持续拉高模型能力/价格比，同时启动资本化（重组→2027 IPO）与人员扩张，向 AGI 目标与国产化生态（华为云首发适配等）双线推进。
  - 产品/市场：V4.1 Flash 是资本叙事的核心资产，性价比与多模态 Agent 能力被视为重估依据；9 月 LiveBench 榜单位列第六（81.1），为 R1 之后其排名最高的一次。对搭方案者：高性价比旗舰模型 + 开源权重，进一步压低推理成本基线，Agent/Coding 场景可用性上升。
  - 资本/组织/人才：本轮 800 亿元+（未到账口径、属知情人士披露）；腾讯、宁德时代为战略出资方——腾讯意在把 AI 能力嵌入各平台，宁德时代看重为 AI/数据中心供货；同步大规模招聘（Harness 负责人亲述）。
  - 风险：融资金额、估值、IPO 时点均为**知情人士/媒体披露，未经公司确认，未独立核实**；V4.1 Pro 发布与迭代节奏关系到估值支撑；开源+低价策略对营收质量与长期议价的影响；监管与中美技术博弈（此前 UN 安全理事会简报等）属外部变量。
- 关键数据：本轮融资≥800 亿元（约 120 亿美元），或逼近 1000 亿元；目标估值约 5000 亿元；首轮 2026-06 超 500 亿元；V4.1 Flash 于 2026-09-10 发布，GPQA Diamond 90.9；LiveBench 第六、81.1；中美模型差距约 3%（彭博行业研究，2026-10-05）。融资数据为媒体/知情人士口径，未获公司确认。
- 原文链接：[搜狐/凤凰网科技｜至少 800 亿，DeepSeek 融资新进展](https://m.sohu.com/a/1084500708_114984)（2026-10-06，已读全文）、[联合早报｜DeepSeek 拟融资至少 800 亿人民币 腾讯等参与投资](https://www.zaobao.com.sg/news/china/story20261006-9792305)（2026-10-06）、[DeepSeek 官方 API 更新日志](https://api-docs.deepseek.com/zh-cn/updates/)（2026-09-10，已读）
- 影响判断：DeepSeek 若完成 800 亿元+融资，将成为中国 AI 单轮融资新极值，直接为 2027 IPO 与算力/人才扩张备弹，并强化「低成本旗舰模型」对全行业定价的压制。对做解决方案者，其开源权重 + 低价 API 继续是成本敏感场景的首选底座；对投资侧，这是一级市场对「能力性价比」重新定价的强信号。下一步看公司是否确认融资与重组、以及 V4.1 Pro 的发布节奏。

### 智谱 AI（静默）
- 本周动态：本周无重大公开动态。核验范围与检索记录：以「智谱AI GLM 2026年10月」「智谱 上市 IPO 2026年10月」「智谱 GLM 10月 2026 发布」「智谱 2026年10月 新模型」「智谱 股价 10月 2026」「智谱 国庆 2026」等查询词，经 serper（Google）多轮检索并核对原文日期，并直接读取智谱官方发布记录页。官方 [BigModel｜模型与产品发布记录](https://docs.bigmodel.cn/cn/update/new-releases)（已读 Markdown 版）最新条目为 **2026-08-26 GLM-5.3-Flash**（原生多模态，总参 320B/激活 18B），其前为 2026-08-19 GLM-5.3，均落在窗口外。可读到的公司层最新权威来源亦在窗外：[搜狐｜唐杰解读智谱半年报：Scaling 从未停止，GLM-6 方向是自进化](https://timeline.sohu.com/news/Vok4zrr2y1)（2026-09-02）、[搜狐｜AI 早报：智谱约 50 亿美元融资落定](https://m.sohu.com/a/1075674233_313745)（2026-09-14）、[观察者网｜半年亏 21 亿，智谱开网店卖 token](https://www.guancha.cn/economy/2026_09_02_829711.shtml)（2026-09-02）。结合国庆假期，判定本周为静默；窗口末段若有未进索引公告，属工具可及性缺口，非确认无动态。
- 企业维度分析：
  - 战略：无本周新增变化；近期主线为「All-in-Infra」（训练+推理双侧投入，把国产芯片纳入主力推理算力，官方口径称已实现 10 万级国产芯片规模化低成本推理）与 GLM-6 的「自进化」方向，以及港股上市后继续推进 A 股 IPO。
  - 产品/市场：GLM-5.3 系列（含 Flash/FlashX）为当前旗舰，主打编程与 Agent 能力、1M 上下文；本周无新发布。对搭方案者，GLM Coding Plan（团队版、透明积分制）仍是国产 Coding 订阅主力选项，但本周无新增能力。
  - 资本/组织/人才：本周无公开披露（未公开）；背景（非本周）：智谱 2026-01-08 港交所主板上市（02513.HK），公司推进 A 股 IPO。
  - 风险：本周未见重大新增风险；持续风险为高研发投入下的亏损（2026 上半年净亏约 21 亿元，报道口径）、模型迭代提速与国产芯片适配效率。
- 关键数据：本周无可入刊新数字；背景（非本周）：GLM-5.3-Flash 总参 320B/激活 18B（2026-08-26 官方）；智谱 2026 上半年亏损约 21 亿元（媒体报道口径，未独立复核）。
- 原文链接：[BigModel｜模型与产品发布记录](https://docs.bigmodel.cn/cn/update/new-releases)（已读，最新 2026-08-26）、[观察者网｜半年亏 21 亿，智谱开网店卖 token](https://www.guancha.cn/economy/2026_09_02_829711.shtml)（背景）
- 影响判断：智谱本周静默。作为「大模型第一股」，其估值已高度绑定模型迭代节奏，任何一周的空窗都会被市场用以对照竞品；对从业者，本周无新增可依赖能力，下一步观察 GLM-6 发布与国产算力规模化推理的成本披露。

### 月之暗面 / Kimi
- 事件 B03（事实+分析判断）
- 本周动态：2026-10-06，彭博社援引知情人士消息（国内多家媒体转载）称，月之暗面（Moonshot AI）**已完成 IPO 前最后一轮私募融资，估值约 500 亿美元**，并正推进 2027 年第一季度在香港 IPO，拟集资约 50 亿美元（约合 390 亿港元）；公司已开始为摸底投资者意向做准备，最快本月起与投资者初步会谈，但讨论仍在进行、IPO 时点可能变动。报道同时回顾其 2026 年极快的估值曲线：1–2 月连续完成 3 轮、估值从 100 亿美元升至 180 亿美元；5 月 D 轮达 200 亿美元；6 月 E 轮投前升至 315 亿美元；7 月 F 轮达 350 亿美元，年内 6 轮融资、半年估值大涨。核心驱动为旗舰模型 Kimi K3（2026-07 上线后引发轰动、30 分钟登顶 Hugging Face 趋势榜）；公司总裁张予彤 7-18 曾披露 K3 发布后企业 ARR 数倍增长，6 月中旬 ARR 突破 3 亿美元。此外公司已完成工商变更，市场主体类型由「有限责任公司」变更为「股份有限公司」，被视为筹备上市的前置信号。国内另有媒体将其与智谱、MiniMax 并列为「大模型第一股」角逐者。
- 企业维度分析：
  - 战略：以「最强开源旗舰模型（K3）+ 高成长 ARR」支撑估值，抢在窗口期完成 Pre-IPO 融资并冲刺港股，目标是成为继 DeepSeek 之后最受关注的中国大模型标的。
  - 产品/市场：Kimi K3 为估值叙事核心；开源权重换取开发者与生态影响力，企业 ARR 数月内数倍增长。对搭方案者，K3 的开源权重 + 前沿能力使其成为可自托管的高端选项，但需自行承担大规模推理成本。
  - 资本/组织/人才：Pre-IPO 轮估值约 500 亿美元（媒体/知情人士口径）；已完成股改；IPO 拟集资约 50 亿美元。创始人杨植麟曾任职 Google Brain、Meta AI。
  - 风险：估值与融资、IPO 时点均为**彭博/知情人士披露，未经公司确认，未独立核实**；此前曾被白宫顾问指控 Kimi K3 涉嫌「蒸馏」Anthropic 技术（2026-07 报道，监管/舆论风险）；算力供给紧张（K3 爆红后曾被迫暂停 C 端新增订阅）；IPO 时点可能变动。
- 关键数据：Pre-IPO 估值约 500 亿美元；拟港股集资约 50 亿美元（约 390 亿港元）；2027 Q1 上市计划；企业 ARR 2026-06 突破 3 亿美元；年内 6 轮融资、估值 100→350 亿美元（1→7 月）。均为媒体/知情人士口径，未获公司确认。
- 原文链接：[21 世纪经济报道｜月之暗面已完成 IPO 前最后一轮融资，正推进明年第一季度赴港上市](https://www.21jingji.com/article/20261006/herald/6ff81a98827897412c54be5ad82f0173.html)（2026-10-06，已读全文）、[有线宽频 i-CABLE｜彭博：月之暗面最新估值 500 亿美元 拟明年初在港上市](https://www.i-cable.com/%E8%B2%A1%E7%B6%93%E8%B3%87%E8%A8%8A/510582/)（2026-10-06，已读）
- 影响判断：月之暗面以 500 亿美元估值完成 Pre-IPO 并冲刺港股，是本周中国 AI 一级市场最强信号之一，说明资本对中国前沿开源模型的定价仍在快速抬升；若 2027 Q1 顺利上市，将与智谱、MiniMax 形成「中国大模型上市板块」。对做解决方案者，K3 的开源权重是高端自托管的重要选项；对投资侧，需注意估值/时点均为未确认披露。下一步看公司是否官宣与港交所备案进度。

### MiniMax（静默）
- 本周动态：本周无重大公开动态。核验范围与检索记录：以「MiniMax 大模型 2026年10月」「MiniMax M3 发布 开源」「MiniMax H3 发布 开源 视频」「MiniMax 2026年10月 发布 新」「MiniMax 2026年10月 A股 IPO 进展」等查询词，经 serper（Google）多轮检索并核对原文日期，并直接读取 [MiniMax 投资者关系｜New Releases](https://ir.minimax.io/news-events/new-releases)（已读，官方发布列表）。该页最新条目为 2026-08-26《MiniMax Announces First Half 2026 Financial Results》，其前为 2026-08-13 MiniMax Music 3.0、2026-08-03 MiniMax H3 开源（H3 官方博客 2026-07-31），均在窗口外。检索到的最接近窗口的第三方内容为 Reddit r/comfyui 一则《A quick Minimax H3 news round-up - 8th October 2026》（发布于约 13 小时前），内容为社区对 H3 的回顾性汇总，非公司新动态。结合国庆假期，判定本周为静默；官方 IR 页面未列任何 10 月条目，若窗口末段有未进索引公告，属工具可及性缺口。
- 企业维度分析：
  - 战略：无本周新增变化；近期主线为「全模态开源 + 全球化收入」（2025 年约 70% 收入来自国际市场）与港股（HKEX:00100）+ A 股科创板 IPO 双线资本化。
  - 产品/市场：旗舰为 M3（Coding/1M 上下文/原生多模态三合一开源）与 H3（开源通用视频模型，2K 分辨率）；本周无新发布。对搭方案者，M3/H3 开源权重仍是国产可自托管的高性价比选项，但本周无新增能力。
  - 资本/组织/人才：本周无公开披露（未公开）；背景（非本周）：公司已港股上市，2026 年 5–6 月启动 A 股科创板 IPO（财新 2026-06-01），2026 上半年业绩于 8-26 公布。
  - 风险：本周未见重大新增风险；持续风险为开源模型变现与推理成本、视频生成赛道竞争、以及 A 股上市进程不确定性。
- 关键数据：本周无可入刊新数字；背景（非本周）：2026 上半年业绩于 2026-08-26 公布（官方）；H3 于 2026-08-03 开源。
- 原文链接：[MiniMax 投资者关系｜New Releases](https://ir.minimax.io/news-events/new-releases)（已读，最新 2026-08-26）、[MiniMax 官方博客｜MiniMax H3](https://www.minimax.io/blog/minimax-h3)（2026-07-31，背景）
- 影响判断：MiniMax 本周静默。作为已上市的双市场标的，其节奏由财报与模型发布驱动，假期空窗不改其开源全模态的定位；对从业者，本周无新增可依赖能力，下一步观察 A 股 IPO 进度与 M/H 系列新版本。

## 七、分章正文 · C 组（Perplexity、Midjourney、Runway、Harvey、Sierra、Glean、Databricks、Cohere、Mistral、Scale、Anysphere/Cursor、Cognition） {#s7}

> 标记：`PUBLIC_CONTENT`。C 组 12 家；事件 ID C01–C22；窗口内 11 家有料、1 家静默（Cursor）。

### Perplexity
- 本周动态：本周 Perplexity 连续落三件事（C01、C02）。其一，10-05 更新 changelog 上线 Automations、内联可视化（含接入 TradingView Lightweight Charts 的图表能力）与新模型 **GPT-6.1 Sol**，向符合资格的付费订阅者在 Perplexity 与 Computer 中开放，并驱动 Computer 的 Light 档日常任务（[changelog](https://www.perplexity.ai/changelog/automations-inline-visualizations-and-gpt-6-1-sol)，2026-10-05）。其二，10-06 与 Rings AI 合作，把团队「关系图谱」（谁认识谁、关系强度、历史会议/邮件/机会、引荐路径）接入 Perplexity Computer 连接器目录，面向投资、客户覆盖、业务拓展与合伙人团队；连接器对 Pro/Max/Enterprise Pro/Enterprise Max 开放，Rings 各档计划内含不额外收费（[PR Newswire](https://www.prnewswire.com/news-releases/rings-ai-and-perplexity-partner-to-bring-team-relationship-intelligence-into-perplexity-computer-302899876.html)，2026-10-06）。其三也是本周技术分量最重的一件：10-07 由 Perplexity Research 发布 **pplx-…late** 多模态 late-interaction（ColBERT 式）嵌入模型，0.6B 与 9B 两档、MIT 许可、已上 Hugging Face，支持文本+图像/渲染 PDF 页检索、免 OCR，两档共享嵌入空间（可用 9B 建索引、0.6B 在边缘/客户端编码查询以压降推理成本）；公司自报 0.6B 在 ViDoRe V3 上可对标激活参数约五倍的模型（[Perplexity 官方博客](https://www.perplexity.ai/en-GB/hub/blog/multimodal-embeddings-beyond-a-single-vector)，2026-10-07；[CryptoBriefing](https://cryptobriefing.com/perplexity-pplx-embedding-models/)，2026-10-07）。
- 企业维度分析：
  - 战略：从「答案引擎」转向 **AI agent 平台 + 基础模型自研**双轮——旗舰是 model-agnostic 的 Perplexity Computer（编排跨工具/文件/芯片/设备的 agent），同时自研嵌入/检索底座，减少对被集成模型的依赖。
  - 产品/市场：本周打法是「平台能力开放 + 生态连接器 + 开源模型」三管齐下：连接器（Rings）深挖企业与专业服务场景，开源嵌入模型则向 RAG 开发者分发，托管 API 端点「计划中但未上线」，仍是开发者导向的分发动作（[AI Tool Herald](https://aitoolherald.com/articles/perplexity-releases-pplx-e-late-embedding/)，2026-10-08）。
  - 资本/组织/人才：本周窗口内无新增融资/估值动作（背景，非本周：9月 $20B 估值、Nvidia 讨论投资且估值或超 $30B 的报道均属窗口外，仅作背景）。
  - 风险：面向青少年安全的评级压力（Common Sense Media 曾评「不可接受风险」，窗口外背景）；隐私/数据流向与连接器授权；开源嵌入虽利于生态，但托管 API 未上线前难以直接变现。
- 关键数据：pplx-…late 两档 0.6B/9B、MIT 许可、约 340M/7.4B 激活参数（公司自报，[AI Tool Herald]，2026-10-08）；ViDoRe V3 为 0.6B 对标五倍激活参数模型（公司自报，官方博客 2026-10-07）；GPT-6.1 Sol 驱动 Computer Light 档（官方 changelog 2026-10-05）；订阅档 Pro/Max/Enterprise Pro/Enterprise Max（PR Newswire 2026-10-06）。融资/估值/ARR：本周未公开。
- 原文链接：perplexity.ai changelog；perplexity.ai hub blog；prnewswire.com；cryptobriefing.com；aitoolherald.com（均为已读取的原始/权威来源）。
- 影响判断：Perplexity 正把竞争焦点从「搜索引用」搬到「agent 编排 + 检索底座」。对搭方案者，MIT 许可的共享空间嵌入提供了「大模型建索引、小模型边缘查询」的低成本混合 RAG 路径，但托管 API 缺位、性能为公司自报，落地前需自测；对做解决方案者，Computer 的连接器目录正在成为企业关系/客户情报类数据的分发入口。

### Midjourney
- 本周动态（C03）：Midjourney 于 10-01 发布、10-02 可见的 **Alpha Changelog 10/1/26**，是一次以可用性/协作前置为主的界面迭代，主体落在 alpha.midjourney.com：侧边栏样式预览（选定样式前先看当前 prompt 在各 style 下的效果，点击即用该 style 生成，并保留 prompt-bar 设置）、create 视图更大图、**文件夹级默认参数**（prompt 参数按文件夹在标签会话内保存）、`--exp` 可设为文件夹默认、sref 在 prompt 中合并为单一「style pill」并悬停列出代码、搜索从 Create/Explore 顶部开始且 Back 恢复原页、编辑保留底图宽高比（避免杂散 `--ar` 拉伸）、修复 10 万+ 图片库深链崩溃等大量 bug 清理（[Midjourney 官方更新](https://updates.midjourney.com/alpha-changelog-10-1-26/)，2026-10-02；[Tutkit](https://www.tutkit.com/en/blog/840-midjourney-is-testing-style-previews-and-improving-editing-as-well-as-tiles)，2026-10-02）。官方在文末「UP NEXT」预告「下周」上线**协作类工具**，并把持久化编辑历史列为后续——两项目前均未交付，不应视为已可用（[Rise Productive](https://www.riseproductive.com/news/midjourney-alpha-edit-aspect-ratio-search-recovery)，2026-10-02；[ainewspro](https://www.ainewspro.com/article/midjourney-alpha-style-previews-folder-edit-update-2026)，2026-10-05）。本周仍无融资/营收/客户数公开动态。
- 企业维度分析：
  - 战略：坚持小型自筹独立实验室路线，把产品从 Discord 迁向自有 Web/alpha 站，并把「协作 + 项目化工作空间」作为下一阶段主线（文件夹默认参数即项目化的一步）。
  - 产品/市场：新增能力均为增量可用性改进，非模型代际升级；当前默认模型仍是 V8.2（7/24 起），窗口内未换版。产品力强但商业化外壳偏薄：无免费档、无官方 API、隐私档位从 $60/月起（均为窗口外既有事实，作背景）。
  - 资本/组织/人才：本周无公开动态（背景，非本周：自筹、2025-08 与 Meta 的美学技术授权、2025 起迪士尼/环球/华纳的版权诉讼均在窗口外）。
  - 风险：版权诉讼与训练数据来源争议持续；无官方 API 且 ToS 禁止自动化访问，第三方「MJ API」多靠驱动 Discord 账号，合规风险高；品牌口碑（第三方评测站记录偏低）与退款/封禁投诉是长期软肋。以上多属既有背景，本周无新增风险事件。
- 关键数据：本周未公开融资/ARR/客户数；模型版本 V8.2（默认，7/24，背景非本周）；窗口内可写数据为「样式预览/文件夹默认参数/`--exp` 默认」等界面能力（官方更新 2026-10-02）。
- 原文链接：updates.midjourney.com；tutkit.com；riseproductive.com；ainewspro.com（均已读取）。
- 影响判断：这是一次典型的「产品体验先行、商业化克制」的迭代；对做方案者，alpha 上的协作工具与持久化编辑历史值得下周再核（尚属预告），同时须评估无官方 API/自动化 ToS 限制对集成方案的红线。

### Runway
- 本周动态：Runway 在 9/30 于旧金山 Masonic 举办为期一天的 AI Summit，窗口内（10-02~10-03）多条报道披露其发布内容，本周是 Runway 战略重心从「创作工具」向「世界模型/物理 AI/营销自动化」扩张的高密度周。核心事件：**发布 Praxis-1**（C04），公司称首个开放权重「world action model」，建立在其通用世界模型的大规模视频预训练之上，把视频预训练转为机器人控制策略；官方称在自家世界模型中仿真机器人策略、与真机结果相关性达 0.95，且政策性能随第三人称视频规模增长（即瓶颈是「可得的视频数据」而非稀缺的遥操作机器人数据）。早期伙伴 Noble Machines、Standard Bots、Ultra 已在自有硬件（从双臂到人形）轻量微调运行，公开发布时将以 **open weights** 而非闭源交付，计划「数月内」面世（[The Robot Report](https://www.therobotreport.com/runway-introduces-praxis-1-world-action-model-robotics/)，2026-10-02；[Singularity.Kiwi](https://singularity.kiwi/runway-praxis1-world-action-model-2026/)，2026-10-03）。同周推出 **Runway Ads**（C05），定位自主绩效营销引擎，可生成并跨 Meta/Google/TikTok 发布与追踪广告；官方与媒体报道称转化率 +34%、CTR 持稳、广告投放量扩 1000%，付费约 $12/月起（[Adweek](https://www.adweek.com/programmatic/runways-ai-video-agent-creates-and-measures-ads-across-platforms/)，2026-09-30；Runway X/官方视频，报道 2026-10-01 前后）。峰会上 Runway Labs 还展示了 **Continuum**（自称实时视频操作系统）及 Interface World Models 家族首个模型 **Solaris**（逐帧生成界面、无中间代码表示），但公司未公布 Continuum 的访问/技术细节（C06）（[RenderU](https://renderu.com/en/news/post/28635)，2026-10-03；[The Deep View](https://www.thedeepview.com/newsletter/runway-ceo-sees-a-much-bigger-future-for-video-ai)，2026-10-04）。
- 企业维度分析：
  - 战略：把「视频生成」升格为「世界模型 + 物理 AI + agent」的公司叙事，Advertising 被 CEO Valenzuela 明确称为走向「像素级 agent」的第一步；机器人采用 open weights，主打「美国在物理 AI 的领导力 + 软硬件互操作性」。
  - 产品/市场：一条腿商业化（Runway Ads 直接卖营销结果），一条腿做前沿叙事（Praxis-1/Continuum/Solaris）。Praxis-1 面向机器人开发者与研究方，公开权重可下载自部署，直接渗透机器人/具身链条。
  - 资本/组织/人才：本周窗口内无新增融资/估值/高管变动公开动态（背景，非本周：2月及 2025-04 的 $308M@$3B+ 融资为窗口外）。
  - 风险：Praxis-1 与 Continuum 均未公布定价/访问条款，短期内无法纳入工程管线；公司自报的 0.95 相关性与 Ads 的 +34% 转化均为厂商口径、未独立验证；生成像素不可审阅带来透明度/可复现问题；视频生成的成本、连贯性、文本与版式稳定性仍是公司自认的待解清单。
- 关键数据：Praxis-1 相关性 0.95（公司自报，2026-10-02）；Ads 转化 +34%、投放量 +1000%、约 $12/月起（公司/报道，2026-09-30~10-01）；Praxis-1 早期伙伴 3 家（Noble Machines、Standard Bots、Ultra）；open weights 计划数月内发布。融资/估值：本周未公开。
- 原文链接：therobotreport.com；singularity.kiwi；adweek.com；renderu.com；thedeepview.com（均已读取）。
- 影响判断：Runway 正把自己从「AI 视频公司」重定位为「世界模型/物理 AI 公司」，并用开放权重换机器人生态位——对做具身方案者，这是除 NVIDIA/Figure 之外新的、可自部署的策略来源；对营销技术方案者，Runway Ads 提供端到端投放自动化，但需验证其自报转化数据。

### Harvey
- 本周动态：Harvey 本周以「客户落地 + 与 LexisNexis 的联合工作流 + 安全基建」三条线推进。其一（C08），10-05 宣布北美最大能源基建公司之一的 **TC Energy** 在其法务团队全面部署 Harvey，支持跨加拿大、美国、墨西哥的复杂法律工作；试点期引入「Harvey-First」指令（律师先用 Harvey 走一遍），覆盖诉讼、监管、公司交易与并购、商业合同、合规；公司称此关系也深化其在加拿大的存在（多伦多办公室与本地团队扩张）（[Harvey 官方博客](https://www.harvey.ai/blog/tc-energy-deploys-harvey-across-its-legal-team)，2026-10-05）。其二（C07），10-07 推出与 LexisNexis 联合开发的首个工作流 **Motion to Dismiss（MTD）起草代理**：四阶段 review-and-approve（规划代理读起诉状并按强度排序最多 8 个驳回理由 → 律师批准/调整 → 并行研究代理用 LexisNexis 美国法源检索、经 Shepard's 校验并标注 Signal → 起草代理产出含 TOC/TOA、符合特定法院程序（加州 demurrer、纽约 CPLR 3211、宾州初步异议、联邦 Rule 12(b)(6)）的成稿），官方称把原本 40~50+ 小时的助理工作压缩到数小时；向有 Ask LexisNexis 或 Lexis+ Protégé 的客户开放，下一步是 Motion for Summary Judgment（[Harvey 官方博客](https://www.harvey.ai/blog/motion-to-dismiss-workflow-lexisnexis)，2026-10-07）。其三（C09），同日发布 **MCP Policy Engine**：为 MCP 工具接入提供运行时控制（最小权限、工具动作全中介、信息流控制），含 Tool Pinner（追踪已批准工具的后改动，防「rug-pull」）与 Sanitizer（清除工具结果中的隐藏字符/恶意指令），直指提示注入与工具投毒；公司称其服务 3,000+ 客户、覆盖 70+ 国家（[BitInsider](https://bitinsider.io/articles/harvey-develops-mcp-policy-engine-to-enhance-ai-security)，2026-10-08）。另 10-07 有报道详述新一代 **Harvey ii**（用户级记忆 + 以「案件」组织的 spaces）及加拿大数据驻留安排：客户可选数据存于加拿大微软数据中心，但推理需出境经 OpenAI 在美国/欧盟/澳洲处理（[ITBrief.ca](https://itbrief.ca/story/how-harvey-ai-s-next-generation-deals-with-canadian-data)，2026-10-07）。
- 企业维度分析：
  - 战略：以「与 LexisNexis 等权威法源深度绑定 + 大客户法务整体部署」构建法律垂直的护城河，同时把 **agent 安全/治理**做成产品级能力，抢占企业级 agent 信任位。
  - 产品/市场：从「让律师用 AI」走向「用 agent 替代整段高耗时文书流程」（MTD）；客户结构向大型跨境企业/能源/金融延伸；数据驻留与合规能力是其进入受监管行业的关键卖点。
  - 资本/组织/人才：本周无新增融资（背景，非本周：9-09 完成 $550M@$15.5B，由 Diffusion 与 Lightspeed 联合领投；此前 $200M@$11B 等为窗口外）。多伦多本地团队在扩张（组织信号，10-05）。
  - 风险：MTD 是高风险法律产出，官方明示律师须逐段复核、存在幻觉/错误风险；加拿大推理出境带来跨境合规与数据主权的持续张力；与 LexisNexis 的深度绑定既是壁垒也是依赖。
- 关键数据：$550M@$15.5B（背景，非本周，2026-09-09，Harvey 官方/Reuters/TechCrunch）；3,000+ 客户、70+ 国家（公司称，2026-10-08）；MTD 由 40~50+ 小时压缩至数小时（公司称，2026-10-07）；TC Energy 跨 3 国法务部署（官方，2026-10-05）。本周新增融资/ARR：未公开。
- 原文链接：harvey.ai（TC Energy）；harvey.ai（MTD/LexisNexis）；bitinsider.io；itbrief.ca（均已读取）。
- 影响判断：Harvey 用「权威法源 + 端到端 agent 工作流 + 安全治理」三件套深耕法律垂直，把估值故事坐实为可交付流程；对搭企业 agent 的公司，其 MCP Policy Engine 思路（工具固定与结果净化）提供了可直接借鉴的生产级安全范式，值得在自有 agent 平台复刻。

### Sierra
- 本周动态：Sierra 本周密集发布，是其年度峰会后的产品/生态高密度周。其一（C10），10-06 峰会回顾（署名 Bret Taylor、Clay Bavor）发布 **Agent OS** 两项新模型：**Curie** 负责对话核心编排回路（决定路径、调用工具、撰写回复），**Fleming** 用于识别来电方是否为另一个 AI agent（应对机器人、欺诈与个人 agent）；同时发布 **Tandem Voice**（会话层实时响应 + 推理层慢思考的「快慢双轨」）、**Persona Studio**（上传自有声音样本、无需工程即可调人格），并预告重构版 **Ghostwriter**（持续监控 agent、主动发现改进点的「常驻队友」）；官方披露客户已覆盖 **约一半的 Fortune 50、三分之一的头部银行、80% 的 Fortune 50 医疗公司**（[Sierra 官方博客](https://sierra.ai/blog/summit-recap-2026)，2026-10-06）。其二，10-06 发布 **Sierra 合作伙伴生态**（技术平台、marketplace、服务伙伴），并宣布上架主流云与前沿实验室 marketplace，可用既有云承诺采购（[Sierra 官方博客](https://sierra.ai/blog/the-sierra-partner-ecosystem)，2026-10-06）。其三（C11），10-06 宣布与 **Meta** 及 Genesys、Instinct、Rocket、Shopify、Stripe、Walmart 等行业伙伴共同制定开放标准 **Personal Agent Protocol（PAP）**，定义个人 agent 如何与企业交互（认证、可开放的功能边界），并同步上线 Stripe App Marketplace（agent 可在对话中安全收集支付信息直送 Stripe）；Fleming-1 于 10-07 落地，任何基于 Sierra 的语音 agent「打开即用」（[aifuturefront](https://aifuturefront.com/sierra-launches-fleming-1-to-detect-ai-agents-calling-by-phone/)，2026-10-07）。其四（C12），10-07 客户案例披露 **菲律宾航空（PAL）** 用 Sierra+ibex 部署三语（英语/他加禄语/Taglish）语音 agent：2026-04 上线 3 条热线，后扩至美国线路（增约 7 万通话/月），900+ FAQ 场景准确率 98%+，CSAT 4.7/5，通过改写一条会员层级问题把误转人工率从 15.5% 降到 7.2%（[Sierra 官方客户页](https://sierra.ai/customers/philippine-airlines)，2026-10-07）。
- 企业维度分析：
  - 战略：以「结果计费（outcome-based，按解决量付费）+ Agent OS 平台」切入企业客服/营收场景，同时用 **PAP 开放标准 + marketplace 上架**抢渠道与生态位，把「关系/上下文归客户所有」作为对抗同质化模型的主张。
  - 产品/市场：从客服向「长周期目标（Horizon）」「语音+多语种」「支付闭环（Stripe）」扩展，企图把 agent 从问答推向真正驱动营收；客户含 Rocket Mortgage、SiriusXM、Vanguard、Wayfair、GAP、SoFi、Sutter Health、SoftBank、Singtel、Cigna、Nordstrom 等（多家为窗口外既有披露）。
  - 资本/组织/人才：本周无新增融资（背景，非本周：2026-05 完成 $950M@$15.8B post-money，Tiger Global 与 GV 领投；2026-02 ARR 超 $150M，据 airtrain 口径；Sacra 估 2026-05 达 $200M ARR，均为窗口外）。招聘信号强劲（New Grad 2027 Agent 岗，10-07，含 SF 及北美/欧洲/亚洲扩张，属组织信号）。
  - 风险：结果计费的「解决率」口径与真实满意度可能背离，需防刷单；PAP 为早期开放标准，部分 agent 可能不遵守，认证/防伪仍待落地；语音 agent 的多语种准确率、误转率与幻觉在受监管行业（银行/医疗）容错极低。
- 关键数据：客户覆盖「约 50% Fortune 50、1/3 头部银行、80% Fortune 50 医疗」（公司称，2026-10-06）；PAL 98%+ 准确率、4.7/5 CSAT、误转率 15.5%→7.2%（公司案例，2026-10-07）；$950M@$15.8B、ARR $150M+/$200M（背景，非本周）。本周新增融资/估值：未公开。
- 原文链接：sierra.ai（summit-recap-2026）；sierra.ai（partner ecosystem）；sierra.ai（philippine-airlines）；aifuturefront.com（均已读取）。
- 影响判断：Sierra 正把「AI 客服」升级为「企业客户关系 + 支付 + 生态」的开放平台，并用结果计费绑定客户价值——对做客服/营收 agent 方案者，PAP 与 Stripe/marketplace 上架意味着可复用的集成与采购路径，但需自建「防刷/防伪造来电」的治理层；对 CX 负责人，多语种语音 agent 已具备替代部分外包坐席的可验证案例。

### Glean
- 本周动态：Glean 本周以「连接器/MCP 生态扩张 + 模型与治理能力升级」为主。其一（C13），10-06 发布 Release 560：**GPT-6.1 Sol** 在支持的 Glean 体验中上线（可用性取决于部署的模型 Key 方案：Glean Universal Model Key 由 Glean 管访问，客户自带 Key 需自备 OpenAI 凭据）；**Showpad 连接器转正式可用**；**Vitally 连接器开放 beta**；**Assistant 模型选择器重构**，新增成本与智能评级及「各模型擅长什么」说明；浏览器扩展改在浏览器原生侧栏打开；安全加固（Agent Builder 的 prompt 增强更抗恶意指令注入）、子代理可接收全部 AI 生成输入（[Glean 官方 release notes](https://docs.glean.com/release-notes/releases/2026-10-06-october-release)，2026-10-06）。其二（C14），10-01 release 新增 **6 个远程 MCP 服务器模板**（GIS Cloud、Lightrun、MYOB、PaidSync、Avoma、Prisma Postgres，多为 per-user OAuth），并宣布 **Agent Identity GA**（给 agent 独立受治理账号、scoped 凭据与审计轨迹）；报道统计 Glean 在 9 天内四个版本共新增 **280 个 MCP 模板**（9/22 +182、9/24 +25、9/29 +67、10/1 +6）（[Aree Blog](https://areeblog.com/glean-adds-six-remote-mcp-server-templates/)，2026-10-04）。其三，生态与定位叙事：10-04 报道 Glean 以 **Enterprise Context** 为「工作 AI 地基」，用 **275+ 连接器**构建 Enterprise Graph，并通过 **Glean MCP** 把受治理上下文喂给 Claude Code、Codex、Gemini、Cursor、Copilot，配 AI gateway/模型 hub/用量控制/agent 治理（[DailySynapse](https://dailysynapse.com/news/glean-company-context-workplace-ai/)，2026-10-04）。其四，10-08 印度软件公司 **Evon Technologies** 宣布成为 Glean 的经销商/实施方并做 24×7 支持（渠道信号，[forpressrelease](https://www.forpressrelease.com/forpressrelease/643242/21/evon-technologies-partners-with-glean-for-ai-at-work)，2026-10-08）。
- 企业维度分析：
  - 战略：明确从「企业搜索」转向「公司上下文 + 治理的 Enterprise Context 平台」，把自身定位为多家前沿 agent（Claude Code/Codex/Cursor/Copilot）底下的**地面层（grounding + 权限 + MCP 网关）**，不与被集成模型正面竞争。
  - 产品/市场：靠连接器/MCP 模板的规模化（9 天 280 个）构建「数据接入面」护城河；Agent Identity、AI gateway、用量治理回应企业最担心的权限与成本两大问题；模型选择器把「成本 vs 智能」交给用户权衡。
  - 资本/组织/人才：本周无新增融资（背景，非本周：2026-05 宣布 ARR 超 $300M；8-29 有 $768M 增长轮报道；2025-06 $150M Series F@$7.2B；均属窗口外，仅作背景）。
  - 风险：MCP 模板数量的爆发带来治理与安全面扩大（工具投毒/rug-pull 风险，Glean 已在做 prompt 注入加固，但生态快速扩张与质量把关存在张力）；permissions-aware 索引若源系统权限本身配置错误会产生「快速泄漏」；模型选择器/Deep Research 计费口径变化需向客户明确。
- 关键数据：Release 560 = GPT-6.1 Sol + Showpad GA + Vitally beta（官方，2026-10-06）；9 天新增 280 个 MCP 模板、Agent Identity GA（报道/官方，2026-10-04）；275+ 连接器（报道，2026-10-04）；ARR 超 $300M（公司称，2026-05，背景非本周）。本周新增融资/估值：未公开。
- 原文链接：docs.glean.com（October release）；areeblog.com；dailysynapse.com；forpressrelease.com（均已读取）。
- 影响判断：Glean 的护城河正从「搜索质量」搬到「连接器规模 + 权限治理 + 作为多 agent 的 MCP 上下文底座」——对搭企业 agent 的团队，Glean MCP 提供了把公司数据受治理地接入 Claude Code/Cursor/Copilot 的现实路径；但 MCP 模板的高速扩张与企业级安全治理的平衡，是选型时必须验证的点。

### Databricks
- 本周动态：本周 Databricks 无新融资动作，但围绕其 8 月已完成的巨额轮出现关键**投资人披露**与并购叙事延续。其一（C15），10-02 韩国媒体 Financial News 与后续报道确认 **SBVA（原软银亚洲风投）** 作为新投资方加入 Databricks 那笔 **$5B 战略融资**，该轮将公司估值推至 **$190B**，由 Coatue 领投，Blackstone、MGX、Sixth Street Growth 等参与；报道同时给出经营口径：Databricks 2013 年成立，全球 **超 20,000 家企业/机构**使用，2026 财年 Q2 营收同比增 **超 80%**，年化营收 **超 $7B**（[Financial News](https://en.fnnews.com/news/202610020824535797)，2026-10-02）。需注意：这**不是新一轮 $5B 融资**，而是对 8 月已关闭轮「谁出资」的补充披露；Databricks 8 月公告未提及 SBVA（[Captables](https://captables.com/articles/databricks-sbva-investor-prior-5b-round)，2026-10-03）。其二，10-02 报道回顾其并购与经营：Databricks 于 9/24 收购西雅图电子表格初创 **Row Zero**（条款未披露，注入其 Genie AI 助手做受治理界面），是其 2026 年第四次收购，CEO Ali Ghodsi 表示还会有更多；Row Zero 累计融资约 $13M、末次估值约 $40M（[Pomerga](https://pomegra.io/startups/databricks-buys-row-zero-2026-spreadsheet-deal-explained-2026-10-02)，2026-10-02）。其三，本周多篇报道复述其融资逻辑——初始只想融 $1B，却收到 $15B 意向，最终定 $5B@$190B；Ghodsi 称大额云承诺、AI 研究与收购使业务「烧钱」（[Business Bearings](https://businessbearings.com/articles/sbva-buys-into-databricks-5-billion-round-at-190-billion-valuation-e6c29405)，2026-10-02）。
- 企业维度分析：
  - 战略：以「数据 + 分析 + AI 一体化平台」（Lakehouse、Unity、Genie、Lakebase）承接企业 AI 的「数据骨干」层，独立于模型层定价；用频繁并购补齐产品面（Row Zero 补受治理表格界面）。
  - 产品/市场：超 20,000 客户、Q2 营收同比 +80%、年化 >$7B，显示企业数据/AI 平台需求强劲；Genie + Row Zero 指向「自然语言操作数据 + 受治理电子表格」的产品方向。
  - 资本/组织/人才：$5B@$190B 已于 8 月关闭（背景，非本周）；本周新增的是 **SBVA 出资披露**；持续并购（年内第 4 笔）是组织/资本动作；CEO 称更多收购在途。
  - 风险：$190B 估值下 IPO 压力被推迟（暂无上市时间表）；重资产（云承诺、AI 研究、并购）烧钱模式依赖持续私募支持；并购整合（Row Zero 等）与产品线重叠的管理成本。
- 关键数据：$5B 轮、$190B 估值、Coatue 领投、SBVA 新加入（Financial News 2026-10-02；Captables 2026-10-03）；>20,000 客户、Q2 FY26 营收同比 +80%、年化 >$7B（Financial News 2026-10-02）；Row Zero 被收购、累计融资约 $13M（Pomerga 2026-10-02）。本轮金额 $5B 为公司公告口径，SBVA 出资金额未披露。
- 原文链接：en.fnnews.com；captables.com；pomegra.io；businessbearings.com（均已读取）。
- 影响判断：Databricks 的信号是「数据/AI 平台层独立于模型层被高价定价」，韩国主权资本入局显示私募对 late-stage AI 基础设施的持续胃口——对做数据/AI 方案者，Genie+Row Zero 代表「受治理的自然语言数据操作」正成为企业平台标配；对投资人，$190B 之下 IPO 窗口仍是观察点。

### Cohere
- 本周动态：本周 Cohere 三线并进，且首次给出「合并后公司」的完整叙事。其一（C16），10-05 发布 **North 2**（称 North 史上最大升级）：统一企业级安全、智能、成本治理与全栈控制于单一 agentic 平台，核心升级包括可跨组织共享的可复用 agent 与自动化、**跨会话记忆**、Skills/Libraries、从自然语言原型化并交付 deck/仪表盘/文档/轻应用、拖拽式工作流构建器与实时监控、以及新增 Slack/SharePoint/OneDrive/Outlook/Exchange/Jira/Linear/Notion/GitHub 连接器（并计划接入 PitchBook、Crunchbase、S&P Global、FactSet 等金融数据源）；**North Admin** 提供按用户/agent 的 token 花费追踪、角色权限、用量配额/速率限制/组织级封顶与阈值告警，平台 **模型无关**（可跑 Cohere 模型或自带模型）；官方称与 NVIDIA 合作在 Blackwell/Hopper 上提升每节点每秒 token 数、降低花费（[Cohere 官方博客](https://cohere.com/blog/introducing-north-2)，2026-10-05；[SiliconANGLE/aventure](https://aventure.vc/news/2026-10-05-cohere-unveils-north-2-ai-agent-platform-with-rebuilt-orchestration-and-token-spending-caps)，2026-10-05）。其二（C17），10-05 与 **PwC** 宣布全球联盟（从加拿大起步），Cohere 提供安全 AI 基座（North + 企业模型 + 搜索检索），PwC 负责用例识别、风险/合规评估、流程再造、治理与集成落地，直指受监管行业的数据主权与合规要求（[Newswire](https://www.newswire.ca/news-releases/pwc-and-cohere-announce-a-global-alliance-to-accelerate-secure-and-trusted-enterprise-ai-adoption-892514657.html)，2026-10-05）。其三（C18），10-05 相关报道复述其与德国 **Aleph Alpha** 的合并进展：双方于 **9/16 签署最终业务合并协议**（4/24 首次宣布），合并后仍以 Cohere 运营、双总部柏林与多伦多、海德堡聚焦研究；Aidan Gomez 任 CEO，Ilhan Scheer 加入任 COO、Samuel Weinbach 任 CRO；合并估值约 **$20B**，仍待监管批准，Schwarz Group 承诺向 Cohere 即将到来的 Series E 投约 €500M/$600M（[MRKT3.0](https://mrkt30.com/aleph-alpha-kolibri-cohere-deal/)，2026-10-05；[PMF Show](https://www.pmf.show/blog/cohere-nick-frosst-enterprise-llms-7b-valuation-240m-arr)，2026-10-05）。
- 企业维度分析：
  - 战略：坚定不移走「主权 AI + 私有化部署 + 企业 agent 平台（North）」路线，明确不做消费级聊天与 AGI 竞赛；通过 North 2 把「安全/智能/成本/控制」四难变四全，并用 PwC 联盟补交付与合规能力。
  - 产品/市场：North 2 的 token 花费治理（按用户/agent 计费与封顶）直击企业财务对 agent 成本失控的恐惧；模型无关 + 连接器扩张使其可被当作企业 agent 的「harness 层」；官方称相当比例营收来自 harness（Pineau 语，转述）。客户含 LG CNS（韩）、RBC、Dell、stc、Ensemble Health Partners 等。
  - 资本/组织/人才：本周无新轮关闭（背景，非本周：2025 末确认估值 $7B；2026-09 Bloomberg 报道其洽谈 $2B~$3B@$20B；与 Aleph Alpha 合并估值约 $20B，均待监管）。二季度内，Aleph Alpha 高管（Scheer→COO，Weinbach→CRO）进入合并后管理层，是组织信号。
  - 风险：合并仍待监管批准（跨大西洋交易不确定性）；$20B 估值对应的营收口径（如 2025 ARR $240M、约 70% 毛利、85% 营收来自私有部署）来自披露/报道，未经独立审计；私有化/气隙部署的重交付成本；North 2 效果为公司自述。
- 关键数据：North 2 于 2026-10-05 发布（官方）；与 PwC 全球联盟 2026-10-05；Aleph Alpha 合并协议 2026-09-16、合并估值约 $20B、Schwarz Group 承诺约 €500M~$600M（报道，2026-10-05）；背景：2025 ARR $240M、毛利约 70%、85% 营收来自私有部署（报道/披露，窗口外）；$2B~$3B@$20B 洽谈（Bloomberg 报道，2026-09，窗口外）。
- 原文链接：cohere.com/blog/introducing-north-2；aventure.vc；newswire.ca；mrkt30.com；pmf.show（均已读取）。
- 影响判断：Cohere 用「主权/私有化 + 成本治理 + 系统集成联盟」把自己定位为受监管企业与欧洲市场的可信 AI 层，合并 Aleph Alpha 后成为首个「跨大西洋主权 AI」标的——对做企业 agent 方案者，North 2 的 per-agent token 封顶与模型无关 harness 是可直接对标的设计；对采购方，$20B 估值与合并不确定性意味着合同需含价格保护与退出条款。

### Mistral AI
- 本周动态：Mistral 本周发布其迄今最大模型，且明确绑定「欧洲主权 AI」叙事。10-06 官方博客发布 **Mistral Large 4**（非正式名 **Le Chonk**）**公开预览**：一个 **1 万亿参数、原生多模态、52B 激活参数**的稀疏 MoE 模型，即日起在 Mistral Studio 的预览 API 可用，**权重本月底开放**（C19）。第三方（Unite.AI）记录其文档定价为 **$0.68 / 百万输入 token、$0.07 / 百万缓存输入、$2.09 / 百万输出 token**，支持结构化输出、函数调用、文档问答等（[Mistral 官方博客](https://mistral.ai/news/mistral-large-4/)，2026-10-06；[Unite.AI](https://www.unite.ai/mistral-unveils-1-05t-parameter-le-chonk-moe-model-in-public-preview/)，2026-10-06）。官方强调：ML4 **完全在欧洲自有数据中心、用 3,800 张 NVIDIA Grace Blackwell GPU 从零训练**，预览也跑在同一基础设施上；在网络安全、金融、法律等关键企业负载上自称开放模型中的 SOTA，视觉 grounding 等部分领域甚至超过前沿闭源模型（公司口径）；发布前正与网络安全领袖、审核伙伴与国家机关做「降低审核、扩展网络能力」的红队测试，主打「provider 级拒绝可能阻断合法漏洞研究」这一企业安全痛点（C20）（官方博客，2026-10-06）。Mistral 将此次发布定位为 9 月 **€3B Series D**（欧洲史上最大股权轮，将其估值推至 **超 €21B / 约 $24B**）资金落地的第一里程碑（背景，非本周：9-08 宣布，Samsung 领投）。另据同周报道，Mistral 已服务 **20 国 125+ 企业**（含 Airbus、ASML、HSBC），CEO Arthur Mensch 目标年内 ARR 达 **$1B**（[TechCEO Daily](https://www.techceodaily.com/ai/mistral-ai-3-billion-series-d-samsung)，2026-10-06）。
- 企业维度分析：
  - 战略：「开放权重 + 自有欧洲算力 + 全栈」作为主轴，把「主权 AI」从政策口号做成商业品类；用万亿级 MoE 打前沿、以开源换企业自部署与分发。
  - 产品/市场：ML4 直攻闭源前沿 API（定价具攻击性），并以网络安全等高监管垂直做差异化；客户结构偏工业/金融/政府（Airbus、ASML、HSBC），契合其「控制权优先」的卖点。
  - 资本/组织/人才：本周无新增融资（背景，非本周：2026-09-08 €3B Series D，Samsung 领投，Scaleup Europe Fund（EQT 管理）、PSG Equity 联席；新投资方含 Advent、BlackRock 基金、卢森堡大公国；老股东含 a16z、ASML、Bpifrance、General Catalyst、Lightspeed、Nvidia、Salesforce Ventures）；Mensch 称长期将完全依赖自建算力、自建算力五年增约 100%。
  - 风险：万亿模型的服务成本与自有数据中心重资产；权重月底才发布，当前仅预览 API，落地需等；自报的 SOTA/超越闭源结论均为厂商口径、未经独立复现；「降审核 + 扩网络能力」的红队安排若边界不清，可能引发滥用与监管争议。
- 关键数据：ML4 = 1T 总参 / 52B 激活（官方，2026-10-06；Unite.AI 记为 1.05T/49B，两源口径略异，以官方为准）；定价 $0.68 / $0.07 / $2.09 每百万 token（文档，转述 2026-10-06）；训练 3,800 张 Grace Blackwell（官方）；€3B Series D、>€21B 估值、Samsung 领投（背景，非本周，2026-09-08）；125+ 企业 / 20 国、$1B ARR 目标（报道，2026-10-06）。
- 原文链接：mistral.ai/news/mistral-large-4；unite.ai；techceodaily.com（均已读取）。
- 影响判断：Mistral 用「万亿开源 + 欧洲算力主权」抢占受监管企业与欧盟市场的默认选项——对做企业方案者，月底开放权重意味着可自部署的前沿级多模态模型将再添一个免锁定的选择，但需以自测复现其性能与成本；对采购方，Mensch 的 $1B ARR 目标与重资产模式是关键持续性观察点。

### Scale AI
- 本周动态：本周 Scale AI 的实质动向集中在**美国国防订单扩张**与**高层对经营口径的公开表态**。其一（C21），10-02（美国国防部合同公告，窗口内报道于 10-03/10-04）美国空军对 Scale AI 既有合同（FA875126C0001）作出 **$12,093,115 的固定价修改（P00003）**，用于 E-4C「可生存空中作战中心」项目的 **Agentic AI**，使合同累计面值从 **$32,247,194 增至 $44,340,309**（单次 +37%），当期拨付 FY2026 研发测试评估经费 $5M，工作将持续至 **2027-11-05**，承包方为 Hanscom 空军基地空军生命周期管理中心（[ClearanceJobs](https://news.clearancejobs.com/2026/10/03/scale-ai-lands-12m-air-force-deal-for-agentic-ai-on-e-4c/)，2026-10-03；[Govly](https://app.govly.com/public/signals/209585)，2026-10-03；[The Arsenal Report](https://the-arsenal-report.com/2026/10/04/scale-ais-agentic-ai-deal-for-the-e-4c-doomsday-jet-grows-to-44-3-million/)，2026-10-04）。其二，10-07 报道美国国防部 CDAO 将 **Thunderforge** 项目（Production OTA，2025-09 首授）的协议潜在价值从 **$100M 提升至 $500M**（五倍），Scale 提供 Data Engine/GenAI Platform/Donovan，微软供模型、Anduril 供兵棋与建模工具，部署到印太与欧洲司令部（[airtrain](https://airtrain.ai/ai-news/scale-ai-navigates-defense-windfalls-and-autonomous-vehicle-shifts/)，2026-10-07）。其三，10-04 报道新任 CEO **Jason Droege** 表态：Meta 入股后核心数据标注业务「逐月增长」，其应用业务已产生「数亿美元」收入，客户含 Mayo Clinic、卡塔尔政府、Cisco、Global Atlantic（[DailySynapse](https://dailysynapse.com/news/most-companies-artificial-intelligence-returns-scale-ai-ceo/)，2026-10-04）。其四，10-08 Alexandr Wang（Scale 创始人、现 Meta 首席 AI 官）确认 Scale AI 与 **Meta 的 Muse** 达成合作（[AGI Hunt](https://agihunt.info/en/p/1a0ccd6997edd103a1de72e1344)，2026-10-08）。此外 10-02 Scale Labs 发布大规模稠密视频描述技术（用于机器人操作数据标注，日增 >1,000 小时示范数据），是其在物理 AI 数据面的技术动作（[Scale Labs](https://labs.scale.com/blog/path-to-large-scale-dense-video-captioning)，2026-10-02）。
- 企业维度分析：
  - 战略：在 Meta 入股引发的商业客户流失后，**转向国防/政府应用**与「应用业务」（帮客户选对用例、搭定制数据集）作为第二增长曲线，同时保留物理 AI/机器人数据引擎。
  - 产品/市场：客户结构从大模型实验室（Google/Microsoft/OpenAI/xAI 相继缩减）转向政府、医疗（Mayo Clinic）、金融（Global Atlantic）、主权客户（卡塔尔）；国防订单含 E-4C、Thunderforge。
  - 资本/组织/人才：本周无新增融资（背景，非本周：2025-06 Meta 以 $14.3B 收购 49% 股权，创始人 Wang 转任 Meta 首席 AI 官，Jason Droege 出任 CEO）；CEO 公开表态属组织/经营信号。
  - 风险：Meta 持股导致商业客户数据隔离担忧、客户流失（Google 中止 $2 亿/年合同）是结构性风险；国防业务单一客户集中与采购政治风险；CEO 自述的「核心业务逐月增长」「应用业务数亿美元」为公司口径、未经独立审计；劳动用工争议（海外众包）历史包袱。
- 关键数据：E-4C 修改 $12.09M、累计 $32.25M→$44.34M、$5M FY26、至 2027-11-05（DoW 合同公告/报道，2026-10-02~10-04）；Thunderforge $100M→$500M（报道，2026-10-07）；应用业务「数亿美元」营收、核心标注逐月增长（CEO 表态，2026-10-04）；背景：Meta 49% 股权 $14.3B（2025-06）、约 24 万众包人员、年化约 $1.5B（窗口外）。
- 原文链接：clearancejobs.com；govly.com；the-arsenal-report.com；airtrain.ai；dailysynapse.com；agihunt.info；labs.scale.com（均已读取）。
- 影响判断：Scale AI 正从「大模型实验室的数据供应商」硬转为「美国国防/政府的 AI 应用与数据承包商」，国防订单五倍扩容是最强信号——对做政府/国防 AI 方案者，Thunderforge 这类「免竞争性招标、可追加拨付」的 OTA 模式值得研究；对商业客户，Meta 股权带来的数据隔离疑虑仍是选型红线。

### Anysphere / Cursor（静默）
- 本周动态：**本周无重大公开动态（静默）**。窗口内（2026-10-02~10-08）通过官方渠道（cursor.com、cursor.com/changelog、forum.cursor.com）、Exa 日期过滤（10-02~10-08）与 serper 多组查询核查，**未发现 Anysphere/Cursor 在窗内发布的新融资、估值、客户、营收或官方产品发布**。窗内可读到的 Cursor 相关内容均属以下两类，不能作为本周新知：① **二手综述/复盘**——10-05~10-08 多家媒体（The Index Today、DevPulse、DiffVibe、SQ Magazine、TechScreen）系对 8-14 已关闭的 **SpaceX $60B 全股票收购**及历史数据的回顾；② **社区/工程向**——10-02 forum 报 @cursor/sdk 1.0.35 本地 SQLite store 报错、10-05 Grok Bot 共享机卡死，属社区 bug 报告（按本期规则不计入公司研究）。因此本条目以「静默 + 核验范围」如实登记，背景数据仅作上下文并标「背景，非本周」。
- 核验范围与检索：官方域 cursor.com / cursor.com/changelog / forum.cursor.com；Exa `Cursor Anysphere news`（2026-10-05~10-09）、`Cursor Anysphere coding agent valuation funding`（2026-10-02~10-08）、`Cursor changelog release new feature`（include-domains=cursor.com，2026-10-01~10-08）；serper `Cursor Anysphere news`。命中均为收购复盘、定价快照、招聘/统计综述或社区帖。检索查询与结果已记 C组-audit.md。
- 企业维度分析：
  - 战略：**背景，非本周**——Cursor 已并入 SpaceX/xAI 体系（8-14 完成），战略重心转向与 Grok 协同；据公司 Materials，Cursor 在自研模型（Grok、Composer）与第三方模型（Claude、Gemini）间分层定价。窗内无新增战略表态。
  - 产品/市场：**背景，非本周**——10-04 读到的官方定价页快照显示 Hobby 免费、Pro $20/月、Teams $40/用户/月、Enterprise 定制，且付费档分「自研模型池」与「第三方模型池（按 API 价）」两个用量池；OpenAI 已宣布 2026-11-12 起从 Cursor 下架其模型（宣布于 8-29，窗口外）。窗内无新产品发布。
  - 资本/组织/人才：**背景，非本周**——SpaceX 全股票收购约 $60B，2026-08-14 完成，Anysphere 普通股/优先股转换为约 **3.893 亿股** SpaceX A 类股（估值按交割前 7 个交易日 VWAP），Cursor 作为全资子公司并入 SpaceXAI。窗内无新高管/招聘官方公告（仅有第三方面试流程综述，10-08）。
  - 风险：**背景，非本周**——模型中立性弱化（OpenAI 下架）、被收购后工程文化与产品路线是否被 Grok 优先化、负毛利/自研模型投入、企业客户对 SpaceX 整合的观望；窗内无新增风险事件。
- 关键数据（**均为背景，非本周**）：$60B 全股票收购、8-14 完成、约 3.893 亿股 SpaceX 股票（The Index Today，2026-10-05 报道）；Enterprise 定价 Hobby $0 / Pro $20 / Teams $40 / Enterprise 定制（官方定价页快照，读取于 2026-10-04）；历史 ARR（$1B @2025-11、$2B @2026-02、约 $3B @2026-05，各来源口径不一）、$29.3B Series D 估值（2025-11）——均窗口外。**本周新增数据：未公开。**
- 原文链接（已读取，但均为窗口外事件/静态页）：theindextoday.com；devpulsedaily.vercel.app；diffvibe.com；sqmagazine.co.uk；thefinancialcurrent.com；forum.cursor.com（bug 帖）。**窗口内无官方原件可引。**
- 影响判断：Cursor 本期静默，属收购交割后的「整合观察期」；对做编码 agent 方案者，关键变量是 OpenAI 11-12 下架后 Cursor 的模型中立性、Composer/Grok 自研模型的实际竞争力，以及 SpaceX 是否会把 Cursor 路线导向服务 Grok；建议下期重点复核其自研模型表现与企业留存。

### Cognition / Devin / Windsurf
- 本周动态：Cognition 本周发布 Devin 的**跨会话记忆与「做梦」机制**。10-05 公司博客（"Memory and dreaming: how Devin learns from working with you"）宣布两项能力（C22）：**Memory** 让 Devin 跨会话记住用户偏好、纠正与项目经验；**Dreaming** 是每日异步后台进程，重新审视历史对话与既有记忆，**合并重复、剪除临时/长期未用信息、解决矛盾、补录此前未记录的经验**（[Cognition 官方（经 nitter 转述）](https://nitter.cf/cognition/status/2107165034463867001)，2026-10-05；[TheNextGenTechInsider](https://thenextgentechinsider.com/pulse/cognition-enhances-devin-with-persistent-memory-and-asynchronous-dreaming)，2026-10-07；[BlockBeats](https://en.theblockbeats.news/flash/370466)，2026-10-06）。实现上，记忆存于个人 **Memory Drive**（持久化 Git 仓库、以 Markdown 组织、`MEMORY.md` 为入口索引，每会话独立 Git checkout、结束提交合并、用 Git 版本检查防陈旧写入）。Cognition 同时把该方案开源为独立标准 **Agent Memory Repo**（MIT）——其他 agent（Claude Code、Cursor 等）可用同法把长期记忆存成文件并以 Git 管理，但「像 Devin 一样每日自动 Dreaming」仍需自行额外配置（[AGI Hunt](https://agihunt.info/en/p/1a10d30f78488669da1811a87bf)，2026-10-08）。需注意：Cognition 未公布任何 benchmark、用户研究或「减少重复纠正/提速」的量化结果，且未说明错误记忆如何被编辑或标记（[AI Insiders](https://aiinsiders.net/article/devin-now-remembers-you-across-sessions-but-cognition-shows)，2026-10-06）。10-06 另有长文综述其企业落地（NVIDIA 芯片设计、GE Aerospace、Citi、Mercedes-Benz、Modal 等客户，与核心 Weights 融资均属窗口外背景）（[GoEarlyBirdLab](https://goearlybirdlab.com/2026/10/06/devin-the-ai-software-engineer-inside-cognitions-48-billion-bet-on-autonomous-coding-agents/)，2026-10-06）。Windsurf 品牌已更名 **Devin Desktop**（6-02，窗口外），本周仅有定价/迁移综述（窗口内报道，事件属窗口外）。
- 企业维度分析：
  - 战略：从「单个自治 agent」转向「agent 平台 + 记忆基础设施」，并把记忆方案开源成标准（Agent Memory Repo）以争夺 agent 生态的「记忆层」话语权；由 Devin、Devin Desktop（原 Windsurf）、Devin CLI、Devin Review、DeepWiki 构成统一产品面。
  - 产品/市场：Memory/Dreaming 直击 agent 长期上下文丢失这一核心可用性痛点，也是企业团队知识沉淀的卖点；但官方无效果量化，属「机制先行、效果量化本次未取得」。SWE-2（9-11 发布，窗口外）在 Devin Desktop/CLI 免费促销至 10 月中，是当前用量策略的一环。
  - 资本/组织/人才：本周无新增融资（背景，非本周：2026-05 >$1B @$26B post-money；2026-09-10 Series E 逾 $2B @$48B，由 a16z 与 Accel 领投；2026-09-25 年化营收据报破 $1B）；窗内无高管变动。开源 Agent Memory Repo 属生态/组织信号。
  - 风险：记忆正确性治理缺失（错误记忆可能被反复使用且存活性清理无法识别真伪）是用户最直接的质疑；Dreaming 的「自动改写记忆」若缺乏审计与可编辑性，在合规场景有风险；公司自报营收/估值口径未经审计；Devin 在长任务与 flaky 测试下的成本不可预测性（ACU 计费）。
- 关键数据：Memory/Dreaming 于 2026-10-05 发布（公司博客）；Agent Memory Repo 开源（MIT，2026-10-05/10-08）；无效果量化（公司未提供，报道 2026-10-06）。背景：Series E 逾 $2B @$48B（2026-09-10）、年化营收近 $900M→破 $1B（2026-09）、SWE-2 于 9-11 发布——均窗口外。
- 原文链接：nitter.cf/cognition（转公司帖）；thenextgentechinsider.com；en.theblockbeats.news；agihunt.info；aiinsiders.net（均已读取）。
- 影响判断：Cognition 把「长期记忆」做成产品级能力并开源标准，标志编码 agent 竞争从「模型强弱」转向「记忆与上下文工程」——对搭 agent 的团队，Agent Memory Repo 的「Git+Markdown 记忆」范式可低成本复刻到自有 agent；但「错误记忆如何被纠正」这一未被回答的问题，是企业规模化前必须自建治理的核心缺口。

## 八、分章正文 · D 组（AMD、Broadcom、CoreWeave、Oracle Cloud、Tesla Optimus、Figure AI、Unitree 宇树、UBTech 优必选） {#s8}

> 标记：`PUBLIC_CONTENT`。D 组 8 家；事件 ID D01–D16；窗口内 8 家均有可入刊信息（无静默）。NVIDIA/Google Cloud/AWS/Azure 仅回填证据（见第五部分）。

### AMD
- 本周动态：本周 AMD 两条主线。其一，CEO 苏姿丰 10 月 6 日在台北对记者表示，AMD 计划在 **2027 年「大幅增加」芯片供应**以应对 AI 需求；她说「我们在 2026 年全年一直在提升供应能力，2027 年将大幅增加」，并指公司需要更多先进晶圆产能来满足其预计会持续数年的需求（[Reuters 2026-10-06](https://www.reuters.com/world/asia-pacific/amd-plans-substantially-increase-supply-2027-ceo-says-2026-10-06/)）。同期她在台北会见富士康、台积电等供应链伙伴，随后将前往韩国（三星、SK 海力士所在地）与存储芯片厂洽谈，以保障 HBM/内存供给。其二，AMD 10 月 6 日公告将于 **11 月 3 日盘后发布 2026 财年第三季度财报**，并公布 12 月两场投资者活动（UBS 12/1、Barclays 12/9）（[AMD IR 2026-10-06](https://ir.amd.com/news-events/press-releases/detail/1300/amd-to-report-fiscal-third-quarter-2026-financial-results)）。市场层面，10 月 6 日 AMD 股价创历史新高（同日英伟达亦创历史新高，市值逼近 5.8 万亿美元）。背景（非本周）：AMD 此前已公布 OpenAI 6GW、Meta 6GW、Anthropic 2GW 等 MI450/Helios 部署承诺，并发出最多 3.2 亿股（每方 1.6 亿股、行权价 0.01 美元）认股权证绑定采购里程碑——本周的「保供」表态正是兑现这些承诺的上游产能前提。
- 企业维度分析：
  - 战略：从「卖芯片」转向「锁定上游产能+绑定大客户股权」的双向绑定；供给成为 2027 竞争胜负手，苏姿丰亲赴台、韩谈产能与 HBM 供应即信号。
  - 产品/市场：Instinct MI450/Helios 机架与第六代 EPYC（Venice）是主要增长引擎；管理层将 CPU 市场 TAM 上修至 2030 年超 2000 亿美元、目标份额 >50%（背景）。本周无新品发布。
  - 资本/组织/人才：无本周新增融资/高管变动；关注点为 11 月 3 日 Q3 财报。
  - 风险：内存/HBM 与先进制程产能受限可能拖累交付；客户端集中度高（OpenAI/Meta/Anthropic），股权-采购绑定的会计与现金流复杂度上升；与英伟达、各厂自研 XPU 的三线竞争挤压。
- 关键数据：2027 年「大幅增加」供应（定性，无量化）—Reuters 2026-10-06；Q3 财报日期 2026-11-03—AMD IR 2026-10-06；MI450/Helios 客户承诺 OpenAI 6GW、Meta 6GW、Anthropic 2GW（背景）—AMD 7 月投资者活动。未独立核实项：供应增幅、HBM 供应谈判结果均未量化。
- 原文链接：https://www.reuters.com/world/asia-pacific/amd-plans-substantially-increase-supply-2027-ceo-says-2026-10-06/ ；https://ir.amd.com/news-events/press-releases/detail/1300/amd-to-report-fiscal-third-quarter-2026-financial-results ；https://qz.com/amd-chip-supply-increase-2027-ai-demand-100626
- 影响判断：AMD 把 2027 产能前置锁定，等于对「AI 资本开支延续到 2027 以后」下注，也把自身命运更深绑定到少数超大客户。对搭方案的从业者意味着：2026H2~2027 的 MI450 供给量与定价仍取决于内存和先进封装，企业采购不应假定「供给充足即价格下行」；11 月 3 日财报是验证数据中心收入与毛利率（此前 Helios 投入压低毛利）的关键节点。

### Broadcom
- 本周动态：本周 Broadcom 出现「融资+技术」双事件。其一，据 **WSJ 10 月 7-8 日独家**，Broadcom 近几周正为与 OpenAI 联合开发的定制 AI 芯片安排 **超过 500 亿美元融资**（知情人士），这是 AI 巨头为算力硬件大举借款的连锁动作之一（[WSJ 2026-10-08](https://www.wsj.com/tech/oracle-broadcom-and-spacex-seek-blockbuster-debt-deals-to-pay-for-ai-chips-848e8032)；[Yahoo Finance 2026-10-08](https://finance.yahoo.com/technology/ai/articles/broadcom-arranging-50-billion-openai-060941579.html) 转述 WSJ）。其二，Broadcom 10 月 8 日公告将在 **10 月 12-15 日圣何塞 OCP Global Summit** 展示最新 scale-up/scale-out/scale-across AI 网络方案，包括 Tomahawk 6、Tomahawk Ultra、Jericho 4 交换芯片，Thor Ultra 800G 与 Thor 2 400G AI 以太网 NIC，以及第三代 TH6-Davisson 共封装光学（CPO），面向 ORV3 机架与 10 万+ 加速器集群（[GlobeNewswire/Business Insider 2026-10-08](https://markets.businessinsider.com/news/stocks/broadcom-redefines-ai-infrastructure-with-industry-leading-networking-innovations-at-2026-ocp-global-summit-1036609532)）。背景（非本周）：Broadcom 9 月 2 日已发布 FY2026 Q3 业绩，AI 半导体收入 167 亿美元、同比 +221%、占总营收 56%；管理层给出 Q4 AI 收入约 217 亿美元（同比 +236%）指引，并将 FY2027 AI 芯片收入预期由 1000 亿上调至约 1150 亿美元（[Reuters 2026-09-02](https://www.reuters.com/business/broadcom-forecasts-quarterly-revenue-below-estimates-2026-09-02/)）。
- 企业维度分析：
  - 战略：以太网+CPO 对抗英伟达 NVLink/InfiniBand 的开放路线；XPU（定制加速器）与网络双轮，把 OpenAI 深度绑为设计伙伴。
  - 产品/市场：Tomahawk 6/Jericho 4/Thor 系列构成 100 万卡级集群网络底座；XPU 面向 Alphabet、Meta、Anthropic、OpenAI。管理层称按「出货量」口径 XPU 已在头部客户中胜出（背景）。
  - 资本/组织/人才：以第三方债务（Apollo、Blackstone 等）为客户芯片项目融资，Broadcom 从供应商变为「融资安排者」，杠杆与供应链金融风险上升。
  - 风险：客户集中度极高；为 OpenAI 安排 500 亿美元融资若落地，将放大对单一客户的信用/回收风险；CPO 与以太网路线量产兑现节奏不确定。
- 关键数据：为 OpenAI 定制芯片安排 >500 亿美元融资（据 WSJ，未独立核实）—WSJ 2026-10-08；FY26Q3 AI 收入 167 亿美元 +221%（背景）—公司/Reuters 2026-09-02；FY27 AI 收入预期约 1150 亿美元（背景，由 1000 亿上调）。OCP 展示为会议预告，非收入数据。
- 原文链接：https://www.wsj.com/tech/oracle-broadcom-and-spacex-seek-blockbuster-debt-deals-to-pay-for-ai-chips-848e8032 ；https://markets.businessinsider.com/news/stocks/broadcom-redefines-ai-infrastructure-with-industry-leading-networking-innovations-at-2026-ocp-global-summit-1036609532 ；https://www.fool.com/investing/2026/10/07/broadcom-ai-revenue-grow-custom-chip-gpu/ ；https://www.reuters.com/business/broadcom-forecasts-quarterly-revenue-below-estimates-2026-09-02/
- 影响判断：500 亿美元融资一事若属实，标志 AI 芯片采购正从「经营性现金」转向「债务驱动」，Broadcom 的定制芯片订单与金融风险同时放大——这对方案商意味着 XPU/以太网生态会更快成熟、供应更足，但也把行业景气押在持续融资能力上。10 月 12-15 日 OCP 上 Tomahawk 6 与 CPO 的量产进展，是判断「开放以太网能否追上 NVLink 生态」的观察点。

### CoreWeave
- 本周动态：CoreWeave 10 月 6 日宣布**进入印度市场**，与印度数据中心合资公司 AdaniConneX（Adani 与 EdgeConneX 各 50%）合作，在孟买 Navi Mumbai 的 Taloja 园区规划 **240 MW** 数据中心容量；园区由 **三栋各 80 MW** 建筑组成，CoreWeave 将是三栋楼的**唯一租户**，并拥有在同一园区再加最多 240 MW、容量翻倍的选择权。CoreWeave 计划在该园区部署 **NVIDIA Vera Rubin 平台**，用于训练、推理、推理链（reasoning）与 agentic 负载；并将设立本地办公室、本地招聘。项目**首期预计 2028 年年中上线**，其余容量分期投产。公司表示该投资支持印度国家 AI 目标（IndiaAI Mission）（[CoreWeave 官方 2026-10-07](https://www.coreweave.com/news/coreweave-enters-india-expanding-ai-cloud-platform-with-adaniconnex)）。据公司 8 月 11 日财报电话会，CoreWeave 已签约电力约 **4.2 GW**；此次印度是其继印尼之后在亚太的第二站。背景（非本周）：CoreWeave 9 月 30 日已开始向 Cognition 等客户生产级交付 NVIDIA Vera Rubin NVL72，9 月 17 日披露 Q3 签下 3-6 个月短约且单价上行。
- 企业维度分析：
  - 战略：以「purpose-built AI cloud + 独家租户 + 长期电力锁定」扩张全球版图，用最新 NVIDIA 平台（Vera Rubin）换取区域先发。
  - 产品/市场：面向 AI lab 与企业提供 GPU 云、Kubernetes 服务与推理；印度扩张贴合当地 AI 与数据中心投资热潮。
  - 资本/组织/人才：本地设办公室并招聘，属资本开支前置；240 MW 为其近年最大单点扩张之一；未见本周新增融资。
  - 风险：重资产 + 长交付周期（首期 2028 年中），执行与资本开支/融资风险高；客户集中、短约占比上升与折旧压力；印度土地、电力与并网审批不确定。
- 关键数据：240 MW（可翻倍）、三栋 80 MW、首期 2028 年中—CoreWeave 官方 2026-10-07；已签约电力约 4.2 GW（8 月 11 日口径）。副证：Bloomberg 2026-10-07 指 240 MW 并含翻倍选择权。未独立核实：投资金额未公开。
- 原文链接：https://www.coreweave.com/news/coreweave-enters-india-expanding-ai-cloud-platform-with-adaniconnex ；https://www.datacenterdynamics.com/en/news/coreweave-teams-up-with-adaniconnex-for-ai-cloud-region-in-india/
- 影响判断：CoreWeave 用 AdaniConneX 的电力与土地、自己的运营能力切入印度，是「AI 云新势力抢地域+抢最新芯片代际」的模板；对搭方案的企业意味着 2028 年起印度将多一个 Vera Rubin 级算力选项，但 timeline 长、地缘与合规须评估。

### Oracle Cloud
- 本周动态：Oracle 本周动作集中在 OCI 的产品与生态。其一，**NetApp 与 Oracle 合作**（10 月 7 日公布）推出 **OCI NetApp Storage Service**：把 NetApp ONTAP 数据管理能力**原生**带入 OCI 的全托管存储服务，面向数据库、企业应用、虚拟化、EDA/HPC、受监管应用与 **AI 数据管道**，可用 OCI Console/SDK、ONTAP API 与既有运维流管理，计划**未来 12 个月内 GA**（[DBTA 2026-10-07](https://www.dbta.com/Editorial/News-Flashes/NetApp-and-Oracle-Partner-to-Provide-Fully-Managed-Cloud-Storage-Service-176891.aspx)）。其二，Oracle 10 月 6 日发布 **Console AI**（OCI 控制台 AI 助手）可用性说明，面向 Ashburn、Phoenix、London、Chicago、São Paulo、Osaka、Hyderabad、Riyadh 等区域商业客户开放（[Oracle Docs 2026-10-06](https://docs.oracle.com/en-us/iaas/releasenotes/console/consoleai-availability-oct-2026.htm)）；10 月并发布 OCI Enterprise AI 产品路线图更新。其三，据 **WSJ 10 月 7-8 日**报道，Oracle 亦在为大规模芯片采购寻求融资，与 Broadcom、SpaceX 同列「AI 芯片债务潮」（[TradingView/Benzinga 2026-10-08](https://www.tradingview.com/news/benzinga:6796e43b1094b:0-broadcom-eyes-over-50-billion-to-fund-openai-s-custom-ai-chips-as-oracle-also-pursues-major-chip-financing-report/)）。背景（非本周）：Oracle FY2026 Q4 显示资本开支约 500 亿美元、RPO 约 5530 亿美元，与 OpenAI 的 OCI 大单是核心驱动；年内曾大规模裁员。
- 企业维度分析：
  - 战略：以「AI 数据管道+企业存储+AI 助手」补齐 OCI 企业粘性，同时用债务融资支撑芯片采购抢占 AI 训练/推理容量。
  - 产品/市场：NetApp 原生存储降低企业迁移门槛（尤其受监管行业），Console AI 扩大 OCI 端侧可及性；OCI 的 AI 卖点仍绑定 OpenAI 等大客户合同。
  - 资本/组织/人才：为芯片采购寻求大额融资（据 WSJ，未独立核实）；重资本开支 + 高 RPO 的结构对现金流管理要求高。
  - 风险：资本开支与债务同步攀升、回报周期长；客户集中（OpenAI 单一超大单）；企业侧 AI 存储/助手面临 AWS/Azure/GCP 同类竞争。
- 关键数据：OCI NetApp Storage Service 计划 12 个月内 GA—NetApp/Oracle 2026-10-07；Console AI 8 个区域—Oracle Docs 2026-10-06；FY26Q4 资本开支约 500 亿美元、RPO 约 5530 亿美元（背景）。未独立核实：Oracle 芯片融资金额未公开。
- 原文链接：https://www.dbta.com/Editorial/News-Flashes/NetApp-and-Oracle-Partner-to-Provide-Fully-Managed-Cloud-Storage-Service-176891.aspx ；https://docs.oracle.com/en-us/iaas/releasenotes/console/consoleai-availability-oct-2026.htm ；https://www.tradingview.com/news/benzinga:6796e43b1094b:0-broadcom-eyes-over-50-billion-to-fund-openai-s-custom-ai-chips-as-oracle-also-pursues-major-chip-financing-report/
- 影响判断：Oracle 正从「卖 GPU 时长」转向「AI 数据+存储+助手」的企业全栈竞争，NetApp 原生集成是关键差异化——对企业意味着 OCI 上跑 AI 数据管道的迁移成本下降，但需等到 2027 年 GA。叠加债务融资扩产，Oracle 的 AI 叙事高度依赖大客户合同兑现与融资窗口，风险与弹性并存。

### Tesla Optimus
- 本周动态：本周 Tesla Optimus 的核心信号是**量产爬坡目标与产能切换**。据 10 月 8 日报道，Tesla 计划在 **2026 年底前把 Optimus 周产量提升到 1,000 台以上**，较 2026 年第二季度约 **10 倍**增长（[BGR 2026-10-08](https://www.bgr.com/2279995/tesla-optimus-robot-production-ramp-up/)；[Yahoo Tech 2026-10-08](https://tech.yahoo.com/home/articles/tesla-targets-1-000-optimus-151700577.html)）。为腾出产能，Tesla 已把 Model S 与 Model X 的生产区域在 **46 天**内改造为机器人产线。同时 Media 引述 The Information 独家指出，Optimus 的**手部与前臂制造仍是瓶颈**：需要大量手工装配，部分手部自动化装配站精度与一致性不足，拖慢放大节奏。Musk 曾称 Optimus 3 目标在 2026 年夏启动 S 型爬坡，并预计公众可在 **2027 年底**买到 Optimus；2024 年他给出的价格预期为 **2 万-3 万美元**，而部分分析师认为实际上市价可能在 5 万-10 万美元。需注意：**Tesla 从未公布 Optimus 实际产量数字**，此前可信报道称累计建造量为低三位数（背景/谨慎口径）。
- 企业维度分析：
  - 战略：把汽车产线改为机器人产线，押注 Optimus 为「史上最大产品发布」，以制造规模化作为竞争壁垒。
  - 产品/市场：Optimus 定位工厂内自用 + 未来对外销售；目前无住宅/商业预售渠道，未公布官方售价与上市日期。
  - 资本/组织/人才：无本周新增融资；产能与人力从汽车业务倾斜至机器人。
  - 风险：手部/前臂装配良率与自动化一致性是明确工程瓶颈；产量目标属管理层预期而非已实现；Musk 交付历史多次跳票；商业化时间表（2027 年底）不确定。
- 关键数据：>1,000 台/周（2026 年底目标，约 2026Q2 的 10 倍）—BGR/Yahoo 2026-10-08；Model S/X 产线改造 46 天—BGR 2026-10-08；价格预期 2-3 万美元（Musk 2024）/分析师估 5-10 万美元。均为预期/第三方口径，非已实现产量。
- 原文链接：https://www.bgr.com/2279995/tesla-optimus-robot-production-ramp-up/ ；https://tech.yahoo.com/home/articles/tesla-targets-1-000-optimus-151700577.html
- 影响判断：Optimus 从「演示」走向「产能切换」，但手部装配瓶颈说明人形机器人量产仍是制造问题而非算法问题——对供应链（灵巧手、执行器、减速器）从业者意味着高价值环节在手与前臂。周产量目标是关键观察锚，若兑现将重塑人形机器人出货格局。

### Figure AI
- 本周动态：本周 Figure 有两条新闻。其一，**Figure 02 整机队退役**：Figure 把大部分 Figure 02 人形机器人送往芬兰 Imatra 的钢厂，让它们在**熔融钢水**（75 吨电弧炉）中完成「最后一跳」进行拆解，公司称该方法可保护专有硬件、避免逐台拆机，少量 Figure 02 仍封存（[EE News Europe 2026-10-07](https://www.eenewseurope.com/en/figure-melts-f02-humanoid-robot-fleet/)、[IEN 2026-10-05](https://www.ien.com/operations/video/22975687/figure-trained-its-humanoid-robots-to-jump-into-molten-steel)）。这标志着 Figure 02 时代结束（其曾在宝马 Spartanburg 工厂处理 9 万+ 零件、参与 3 万+ 车辆），产线转向 Figure 03。其二，**英伟达或再投 10 亿美元**：据 The Information 10 月 7-8 日报道，Nvidia 曾考虑向 Figure AI 投资 **10 亿美元**（一年前已参与 Figure 超 10 亿美元融资轮），意图把 GPU 从数据中心拓展到家庭场景、让用户本地运行 AI（[AzerNews 2026-10-07](https://www.azernews.az/region/265146.html)）。背景（非本周）：Figure 于 **9 月 17 日**发布 Helix 2.5 通用化模型（30 个未见住宅零样本家务成功率 56% vs 基线 8%），并承诺初期 35 亿美元、最多超 60 亿美元的 AI 基础设施投入，与 Nscale 合作最多 10 万块 NVIDIA GPU（2027 下半年部署）——均属窗口外。
- 企业维度分析：
  - 战略：以 Helix 通用化模型 + Index 人类行为数据集 + 大规模算力/数据投入构建「机器人基础模型」护城河；快速迭代本体（02→03→04）。
  - 产品/市场：Figure 03 面向家庭（173cm/61kg、负载 20kg、5 小时续航），Figure 02 曾用于宝马产线；处于从工业走向家庭的过渡期。
  - 资本/组织/人才：Nvidia 潜在 10 亿美元新投资（据 The Information，未独立核实）；此前 C 轮超 10 亿美元、估值约 390 亿美元。
  - 风险：零样本成功率（56%）距实用仍有差距；家庭场景商业化与成本未验证；对 Nvidia 算力/资本依赖度上升。
- 关键数据：Nvidia 或再投 10 亿美元（据 The Information，未独立核实）—2026-10-07；Helix 2.5 零样本 56% vs 8%、30 户（背景，9 月 17 日）；AI 基建 35 亿→超 60 亿美元、Nscale 10 万 GPU（背景）。
- 原文链接：https://www.eenewseurope.com/en/figure-melts-f02-humanoid-robot-fleet/ ；https://www.azernews.az/region/265146.html ；https://www.futuretimeline.net/blog/2026/10/8-general-purpose-humanoid-robots-future-timeline.htm
- 影响判断：Figure 用「熔钢退役」完成世代切换，同时若拿到 Nvidia 第二笔大额投资，等于把「物理 AI 入口」进一步绑定 GPU 生态——对从业者意味着人形机器人竞争正从硬件转向「基础模型+数据+算力」的重资本赛道。观察点：Figure 03 量产节拍与 Helix 零样本率的后续提升。

### Unitree 宇树
- 本周动态：本周宇树的主线是**资本市场持续回调 + 供应链放量**。股价端，10 月 3 日**摩根大通首次覆盖即给「减持」评级、目标价 300 元**，认为当前股价对应 2027 财年市销率高达 46 倍、隐含预期难以达成；此前**美银证券**首覆给「跑输大市」、目标价 350 元，理由同为估值偏高（[163/网易号 2026-10-08](https://www.163.com/dy/article/L8NJT5K80550N21C.html)）。10 月 8 日宇树股价跌逾 4-5%，盘中低见 425.6-430.3 元，**再创上市以来新低**（已连跌四个交易日），收盘 427.80 元；相较 8 月 19 日上市首日盘中最高 1,100 元，股价已**跌逾六成**，市值自峰值蒸发逾 2,600 亿元（[ZAKER 2026-10-08](https://app.myzaker.com/news/article.php?pk=6ac778078e9f0917ed707b65)）。基本面：宇树 2026 上半年营收 **11.52 亿元**（同比 +48.54%），但**扣非净利 2.44 亿元、同比 -19.34%**（研发与销售费用大增）。供应链端，长盈精密 10 月 8 日回应称，2026 年 1-8 月已交付**超 110 万件人形机器人精密零组件**，三、四季度订单较上半年**增速更快**，正按客户需求扩产（[财闻 2026-10-08](https://www.caiwennews.com/article/1641735.shtml)）。背景（非本周）：宇树 8 月 19 日以 150.80 元/股登陆科创板，首日开盘暴涨 629%、市值一度冲上 4,449 亿元，募资约 9.05 亿美元；据 TechNode，2026 上半年生产约 1.8 万台双足人形机器人。
- 企业维度分析：
  - 战略：以低价全尺寸/准全尺寸机型（G1 约 1.35 万-1.5 万美元）走「出货量第一」路线，上市后承受高估值向业绩验证切换的压力。
  - 产品/市场：全球出货领先、价格下探，但客户仍以科研/表演/试点为主，工业持续订单稀缺；创始人王兴兴公开称最大瓶颈是「具身智能泛化能力不足」。
  - 资本/组织/人才：外资机构（JPM/美银）密集给谨慎评级压制估值；近期无新增融资，压力来自解禁与业绩验证。
  - 风险：估值与增速错配、扣非净利下滑、限售解禁与情绪波动；工业场景「试用≠订单」，商业化兑现存疑。
- 关键数据：10 月 8 日收盘 427.80 元、盘中新低 425.6 元、较高点跌逾六成—网易号/ZAKER 2026-10-08；JPM 目标价 300 元（10 月 3 日）、美银目标价 350 元；H1 营收 11.52 亿元 +48.54%、扣非净利 2.44 亿元 -19.34%—上市公告书；长盈精密 1-8 月交付 >110 万件—财闻 2026-10-08。
- 原文链接：https://www.163.com/dy/article/L8NJT5K80550N21C.html ；https://www.caiwennews.com/article/1641735.shtml ；https://app.myzaker.com/news/article.php?pk=6ac778078e9f0917ed707b65
- 影响判断：宇树从「市梦率」回归，标志 A 股人形机器人估值锚从「叙事」转向「业绩验证」，对整条产业链定价具有牵引作用。对从业者意味着：本体价格下探利于渗透，但「出货量第一」仍需工业持续订单与泛化能力才能支撑估值；供应链（精密零组件）放量已先于整机业绩改善。

### UBTech 优必选
- 本周动态：10 月 8 日，优必选宣布与**一汽-大众**达成**战略合作**，双方将共同推进具身智能机器人在**物流领域**的应用场景开发与测试，并构建示范应用场景，加速人形机器人在智能制造领域部署；这是在 Walker S Lite 此前已进入一汽-大众青岛国家级智能工厂开展车辆质检实训基础上的进一步拓展（[新浪财经/IT之家 2026-10-08](https://finance.sina.com.cn/tech/digi/2026-10-08/doc-iniunmim4395229.shtml)）。公司同时强调其「具身大脑-仿人小脑-高性能本体-群体智能」四大技术集群。资本市场方面，10 月 8 日优必选收报 **69.2 港元**，较 9 月 14 日的 78.9 港元累跌超 10%，较年初 131 港元累跌超 4 成——公司同期推出股权激励（9 月 14 日以 1 元/股向 409 名核心人员授出 362.447 万股 H 股）后股价不升反降。背景（非本周）：2026 上半年营收 **12.7 亿元**（+104.2%），人形机器人销量 16,123 台（+268.3%）；全尺寸具身智能人形机器人收入 5.9 亿元（+1445%）、销量 921 台，毛利率 44.7%（+9.7pp），Walker S2 毛利率超 70%；H1 新增订单超 10 亿元、含 3 笔亿元级；柳州万台级智慧工厂 9 月 12 日投产（每 10 分钟下线 1 台）。
- 企业维度分析：
  - 战略：以「工业/商用/家庭」三场景 + 车企标杆客户绑定，推动全尺寸人形机器人量产与交付；收购锋龙股份补末端执行器/伺服，与沐曦合资做端侧芯片。
  - 产品/市场：Walker S 系列落地汽车、3C、航空制造等，客户含比亚迪、富士康、本田贸易、空客；U1 消费级系列（6 月发布，订单曾超 1.3 万台）交付成色待考。
  - 资本/组织/人才：股权激励绑定 2026 销售目标（约 45.3% 激励挂钩销售绩效）；H1 亏损 3.39 亿元（同比收窄 24.7%），应收账款 16.8 亿元（+92%）、经营现金流 -7.49 亿元。
  - 风险：盈利与现金流压力大（六年累亏超 50 亿元）；应收账款与存货高企、坏账准备 5.46 亿元；股价低迷；「订单—交付—回款」闭环尚未验证。
- 关键数据：与一汽-大众战略合作—新浪/IT之家 2026-10-08；10 月 8 日收盘 69.2 港元（较年初 -40% 以上）；H1 营收 12.7 亿元 +104.2%、人形销量 16,123 台、全尺寸收入 5.9 亿元 +1445%（背景，中期业绩）；柳州工厂每 10 分钟 1 台（背景）。
- 原文链接：https://finance.sina.com.cn/tech/digi/2026-10-08/doc-iniunmim4395229.shtml ；https://www.163.com/dy/article/L8PPPJFD0519T4FA.html ；https://finance.sina.com.cn/wm/2026-10-09/doc-iniuqqhr3151160.shtml
- 影响判断：优必选用「车企标杆 + 万台工厂」讲交付故事，是全球少数已实现全尺寸人形机器人工商业交付的公司，但股价与现金流显示市场对「订单转收入、收入转现金」仍不买账。对从业者意味着：工业人形机器人的竞争已进入「交付与回款」阶段，客户复购与毛利率可持续性比参数更重要。

## 九、各组洞察 {#s9}

> 标记：`PUBLIC_CONTENT`（各组原文保留）。

### A 组洞察
1. **「Agent 入口」之争从云端打到桌面 OS。** 本周 OpenAI（Intelligent UI + 广告）、Google（Gemini agent 通用工作 Agent）、微软（Windows 内建 Copilot + MXC 沙箱 + 本地模型）、Meta（Muse 进 Windows）、NVIDIA（RTX Spark + OpenShell）在同一周把「个人/企业 Agent 的落点」推到操作系统与设备层；竞争焦点由「模型分数」转向「谁掌握任务起点与执行环境」。（支持事件：A01、A06、A12、A13、A19）
2. **小模型价格战白热化，生产层成本骤降。** Anthropic Haiku 5.5 与 OpenAI GPT‑6 Luna 在短请求四档价格完全对齐（$0.10/$0.50），Anthropic 自报 OSWorld 由 15.7%→72.4%，标志高并发生产负载成为厂商必争之地；对搭方案者意味着文档/分类/检索类 Agent 的单位成本显著下降。（支持事件：A09，及 A01 的 GPT‑6 Luna）
3. **云厂与模型厂「竞合」加深，企业 Agent 治理成标配。** AWS 用「OpenAI 模型 + AWS 原生 IAM/审批/审计」托管（Bedrock Managed Agents）、Google 用 Gemini agent 统一企业入口、微软用 MXC + 本地模型——三朵云不约而同把「治理/安全/成本控制」写进 Agent 平台卖点，企业 Agent 采购的评估维度正从「模型能力」转向「治理与集成」。（支持事件：A16、A06、A13）
   > 备注：NVIDIA 供应链/订单/硬件证据按分工由 D 组回填；本组 NVIDIA 条目为独立取证，若 D 组后续提供 `D组-evidence-to-A.md` 与本条目标注不一致，以父级整合为准。

### B 组洞察
本周（2026-10-02 ~ 10-08）恰逢国庆假期，中国 AI 九家头部企业中 **4 家有窗口内可入刊事件、5 家静默**，呈现「假期静默 + 资本与算力叙事集中」的特征。
1. **资本主线最强，且集中在「上市/融资」**：本周最重的两个信号都来自资本端——月之暗面据彭博披露以约 500 亿美元估值完成 Pre-IPO、拟 2027 Q1 赴港集资约 50 亿美元（B03）；DeepSeek 据披露新一轮融资≥800 亿元人民币、由腾讯与宁德时代领投、目标估值约 5000 亿元并冲刺 2027 IPO（B02）。两者叠加智谱（02513.HK）与 MiniMax（00100.HK）已上市，中国大模型「上市板块」轮廓进一步清晰。对做解决方案/投资的从业者，这说明一级市场正以「能力性价比 + 高成长 ARR」给中国前沿模型重新定价；但两条均为知情人士/媒体口径、未经公司确认，需以官宣为准（R4 视角）。
2. **算力自主化进入「份额叙事」阶段**：华为轮值董事长徐直军在窗口内被集中报道，称昇腾中国份额已超英伟达、950DT 训练超节点年底/明年初放量（B01）。这是国产算力从「可用」迈向「规模化可交付」的关键表述；但对搭方案者应以实际供货与集群实测为准，份额为华为单方口径、未独立复核。
3. **产品侧偏静默，能力竞争转入托管/通道**：本周唯一的产品级入刊事件是阿里云百炼 10-02 上线 Qwen-Image-2.1-Pro（阿里），即把 9 月已开源的前沿图像能力落到托管 API 变现。字节、腾讯、百度、智谱、MiniMax 均在假期静默，官方发布记录均停在 8–9 月。对从业者，本周无新增可依赖的模型能力，10 月底腾讯全球数字生态大会（10-29）与后续各厂大会是下阶段能力释放的锚点。
4. **风险与待观察**：静默不等于无事——字节、腾讯、百度、智谱、MiniMax 属「本周无重大公开动态」+ 工具可及性缺口（部分官方文档正文由脚本渲染、抓取受限），已在各自条目记录核验范围。下周观察点：①月之暗面/DeepSeek 是否官宣确认融资与上市进度；②华为 950DT 量产与首位训练客户；③腾讯 10-29 大会混元与 Agent 落地；④阿里百炼新模型的定价与调用量是否公开。
   > 证据边界：B 组本周事件的核心数字多来自权威媒体对知情人士/管理层口径的报道（B01 为管理层表态、B02/B03 为知情人士披露），均已注明「未独立核实」，不作强结论；5 家静默企业已记录检索查询、可读来源与日期、以及工具可及性缺口。

### C 组洞察（AI 应用与垂直头部企业竞争格局）
1. **垂直应用层集体「平台化 + agent 化」**：Perplexity（Computer 连接器）、Harvey（MTD 端到端工作流）、Sierra（Agent OS + PAP 开放标准）、Glean（Enterprise Context + MCP 底座）、Cohere（North 2 全栈 agent 平台）、Cognition（Memory/Dreaming）本周动作高度收敛到同一方向——把单点产品扩成「agent 平台 + 上下文/记忆/工具底座」。竞争焦点从「模型能力」转向**编排、记忆、工具接入与企业可用性**。
2. **治理/安全/成本控制成为新的差异化维度**：Harvey 的 MCP Policy Engine（工具固定+结果净化）、Glean 的 Agent Identity + AI gateway、Cohere 的按 agent/用户 token 封顶、Cognition 的记忆治理，都在把「企业最怕的三件事——数据外泄、成本失控、agent 乱跑」做成产品功能。**能力开放度与治理成熟度正在拉开头部差距。**
3. **资本向「可交付闭环」集中，并出现两条分化路径**：数据/基础设施与垂直头部估值高企（Databricks $190B、Cohere 合并约 $20B、Cognition $48B、Mistral >€21B、Cursor 被作价 $60B），说明私募愿为「真实营收/客户/落地」付溢价；同时① 应用层被大厂吸收（Cursor→SpaceX、Windsurf→Cognition、Meta 入股 Scale）；② 部分公司转向政府/国防第二曲线（Scale 五倍国防订单）。**R4 视角**：资本正在为「有闭环的应用层」与「数据/治理底座」定价，而非单纯的模型故事。
4. **开源权重/开放标准成为新兴公司的通用分发武器**：Mistral 万亿开源、Perplexity MIT 许可嵌入模型、Cognition 开源记忆标准、Runway 开放机器人权重、Cohere 模型无关——用开放换生态位、对抗闭源锁定。**R1 视角**：对做方案者，可自部署/免锁定的组件显著增多，但也意味着需自建评测与治理能力来兜底厂商自报口径。
5. **物理 AI/世界模型外溢，应用与硬件链条互补渗透**：Runway（Praxis-1 从视频跨到机器人控制）、Scale（物理 AI 数据引擎）显示内容/数据类公司正反向进入具身与硬件链条。
6. **计费模式创新**：Sierra 按结果计费、Cohere token 封顶、Cognition ACU、Devin Desktop 配额制——「按结果/按用量治理」正逐步替代纯席位订阅，为从业者的方案报价与成本模型提供新参照。

### D 组洞察
1. **算力供给与融资成为核心矛盾线**：AMD 抢 2027 产能、Broadcom 为 OpenAI 定制芯片筹组逾 500 亿美元债务融资、Oracle 亦寻求芯片融资——AI 算力已从「经营性现金采购」转向「绑定大客户+债务驱动」，Broadcom/CoreWeave/Oracle 的订单与财务风险同步放大。
2. **定制硅与开放网络对英伟达构成结构性挑战**：Broadcom XPU（AI 收入 +221%）与以太网/CPO 路线，叠加 CoreWeave 部署 NVIDIA Vera Rubin，显示算力栈正沿「自研加速器+开放网络」与「英伟达全栈」两条路线分化。
3. **具身智能从「演示」进入「量产与估值验证」**：Tesla Optimus 目标 2026 年底千台/周、Figure 世代切换、优必选万台工厂交付 vs 宇树股价腰斩——本体量产能力与资本定价出现明显背离，市场开始惩罚高估值、奖励真实交付与回款。

## 十、下周观察点 {#s10}

- **入口/平台**：OpenAI Intelligent UI 的实际可用性与时延、广告隐私与品牌安全反馈；Google Gemini agent 的单一通用 Agent 落地与跨云兼容；Meta Muse for Windows 是否给出发布时间表；微软 MXC/OpenShell 沙箱实效与企业采用；AWS Bedrock Managed Agents 从免费预览到 GA 的定价。
- **价格/成本/治理**：小模型价格对齐后 Haiku 5.5/GPT‑6 Luna 的真实负载成本；Cohere North 2 per‑agent token 封顶的落地；Harvey 从 MTD 到 Summary Judgment 的扩展；Sierra PAP 的采用与防伪造来电治理；Cognition 对「错误记忆如何被纠正」的补齐。
- **中国**：月之暗面/DeepSeek 是否官宣确认融资与上市进度；华为 950DT 量产与首位训练客户；腾讯 10‑29 全球数字生态大会（混元与 Agent 落地）；阿里百炼 Qwen‑Image‑2.1‑Pro 定价与调用量是否公开。
- **资本/算力**：Broadcom 为 OpenAI 定制芯片 >$500 亿债务融资是否落地；Oracle 芯片融资；CoreWeave 印度 240MW 执行进度；AMD 11-03 Q3 财报（数据中心收入与毛利率）。
- **C 组前沿**：Perplexity 托管嵌入 API 是否上线；Midjourney 协作工具/持久化编辑历史（尚为「UP NEXT」预告）；Runway Praxis‑1 开放权重与 Continuum 访问条款；Mistral Large 4 权重本月底开放后的自测复现；Scale 国防订单（E‑4C/Thunderforge）执行；Cursor 自研模型与企业留存（OpenAI 11‑12 下架后）。
- **具身/物理 AI**：Tesla Optimus 2026 年底千台/周目标兑现与手部装配瓶颈；Figure 03 量产节拍与 Helix 零样本率提升；宇树/优必选「订单—交付—回款」闭环。
- **行业会议**：Broadcom OCP Global Summit（10‑12~15，Tomahawk 6/CPO）；腾讯数字生态大会（10‑29）；AMD 12‑01/12‑09 投资者活动。

## 十一、口径与局限 {#s11}

**研究准入：PASS（带透明局限）。** 局限单列 WARNING，不阻断：

- **单源/未独立核实项**：关键数字均带来源+日期；融资/估值类（DeepSeek ≥¥800 亿、月之暗面 $500 亿、Broadcom >$500 亿、NVIDIA→Figure $10 亿）均为媒体/知情人口径，正文均明确标「未独立核实/未经公司确认」。
- **管理层/厂商单方口径**：华为「昇腾份额超英伟达」为管理层单方口径，已注明未独立复核；厂商自报 benchmark/效果（Anthropic Haiku 5.5、Runway 0.95、Sierra 客户占比等）均标「公司口径」。
- **入口失败/JS 渲染**：部分官方页 401/403/JS 未取得正文（AMD Reuters 401、百度千帆更新页、investors.broadcom 403、figure.ai/news JS、微软.commandline 403 等）；相关主张已限述并标注来源类型。
- **日期过滤失效**：serper 日期/news 过滤本次未生效，各线改按原文日期逐条核对；所有入刊事件原文日期均在窗内或明确标注背景。
- **静默项可及性缺口**：静默 7 家有工具可及性缺口（部分官方文档正文由脚本渲染、抓取受限、反爬），非确认无动态；已逐家记录核验范围、检索查询与可读来源日期。
- **NVIDIA 主责分工**：A 组交回时 D组-evidence-to-A.md 尚未生成；本次以 A 组为主干、D 组证据补全具身投资（$10 亿→Figure）与 Vera Rubin 部署，已标注来源。
- **未发现**仍拟发布的重大无源/虚假事实；无隐私/法律授权风险；核心结论矛盾可经限述隔离解决。

## 十二、工具证据账本（AUDIT_METADATA） {#s12}

> 标记：`AUDIT_METADATA`。仅留资料库，不进文章。以下为四组组级 audit 与父级门控过程的摘要；完整账本见下列文件。

- **A 组 audit**：`RUN_DIR/A组-audit.md`。provider：内置 web_search（实际 brave，一次 429，改用 serper）、`scripts/search.py -p serper`、`-p tavily --raw-content` + web_fetch。若干官方页 403（microsoft.com 系、ai.meta.com、commandline.microsoft.com、news.microsoft.com）、部分官方页截断（spill：openai 7379、google cloud 44332、venturebeat 7601 等）。排除背景：NVIDIA $150B 回购与 Agent Safety（9-28）、GTC $1T（03）、Meta Muse 发布（09-08）、xAI Grok 4.7（09-21）等。未公开：8 家本周均未见新增融资/估值/客户数/订单。
- **B 组 audit**：`RUN_DIR/B组-audit.md`。provider：`search.py -p serper`（均 `auto_routed:false`）；tavily 测一次。限制：`--start-date/--end-date` 与 `--type news/--time-range week` 未生效，改多查询词 + 逐条核对原文日期。取证失败：百度千帆更新/模型更新记录页仅得标题（脚本渲染）；reddit 403。
- **C 组 audit**：`RUN_DIR/C组-audit.md`。provider：serper（日期过滤不生效）、Exa（`--start-date/--end-date` 有效，主力窗口定位）、tavily、brave（429 限流）。403：therobotreport 首次。单源/公司自报项已限述。
- **D 组 audit**：`RUN_DIR/D组-audit.md`。provider：web_search/web_fetch + `search.py`（serper 默认、tavily raw_content）。错误：reuters.com 401、wsj.com 付费墙、investors.broadcom 403、coreweave investors 403、benzinga 403、figure.ai/news JS 渲染、arstechnica 405、qz.com 403；The Information/Bloomberg 付费未直读（二手转述）。
- **D→A 证据回填**：`RUN_DIR/D组-evidence-to-A.md`。NVIDIA 具身/物理 AI 投资与 Vera Rubin 部署证据已并入第五部分；Google Cloud/AWS/Azure 明示「无本周证据」，不冒充静默。
- **父级门控**：`RUN_DIR/research-gate.md`（研究准入 PASS）。机械检查通过；覆盖实绩 A8/B9/C12/D8，合计 37 家、30 家有料（≈81%）、7 家静默、0 不可核验、约 61 个事件 ID；风险导向抽查 5 家有料公司（4 家父级直读原文命中，1 家 AMD 入口 401 按限述保留）。
- **计数汇总**：A（有料 7/静默 1/xAI，A01–A20）；B（有料 4/静默 5/不可核验 0，B01–B03 + 阿里）；C（有料 11/静默 1/Cursor，C01–C22）；D（有料 8/静默 0，D01–D16）。
- **本稿版本**：research-master v1（整合者 wairesearch/黄山），内容综合四组分片与上述 audit，未新增事实、未修改任何分片。冻结并写 research.done 由父级执行。

<!-- END OF RESEARCH-MASTER -->
