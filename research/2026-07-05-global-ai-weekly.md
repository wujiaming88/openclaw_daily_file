# 全球 AI 动态周报 · 第 6 期（2026-06-28 ~ 2026-07-04）

> 覆盖区间：2026-06-28 00:00 → 2026-07-04 24:00（上海时区）的完整自然周
> 覆盖范围：38 个研究对象 / 6 大赛道（大模型基座 · 垂直Agent · 中国公司 · 框架工具 · 算力硬件 · 具身机器人）
> 数据口径：所有本周动态均在时间窗内，关键数据标注来源 URL + 日期；窗口外内容标注"（背景，非本周）"。

---

## 🔥 本周 TOP 5

### 1. Claude Sonnet 5 发布，"接近旗舰 × 腰斩价"引爆编码代理迁移战 ｜ 2026-06-30
Anthropic 于 6/30 正式发布 Claude Sonnet 5，官方定位"迄今最具 agentic 能力的 Sonnet"——性能逼近旗舰 Opus 4.8，但价格大幅下探：introductory 定价 $2/百万 input token、$10/百万 output token（有效期至 2026-08-31），之后转 $3/$15，仍显著低于 Opus 4.8 的 $5/$25。即日成为 Free/Pro 默认模型，并上线 Claude Code（v2.1.197 当日设为默认模型，原生 1M 上下文）。同一周，OpenAI Codex 上线 `/import` 从 Claude Code 导入配置/聊天，OpenCode 当周即为 Sonnet 5 加 adaptive thinking——三方在同一周直接争夺对方存量用户。
- ↳ **为什么重要**：前沿能力已足够溢出，竞争焦点从"谁最强"转向"谁能以更低成本跑 agent"；编码代理竞争进入"抢迁移"阶段。
- 来源：[Anthropic 官方](https://www.anthropic.com/news/claude-sonnet-5)、[VentureBeat](https://venturebeat.com/technology/anthropic-launches-claude-sonnet-5-at-a-steep-discount-to-its-top-model-as-the-company-races-toward-a-blockbuster-ipo)

### 2. 宇树科创板 IPO 获批，中国人形机器人第一股 ｜ 2026-07-02
中国证监会 7/2 批准宇树科创板 IPO 注册，宇树将成为中国首家上市的人形机器人公司。从 3/20 受理到过会仅 73 天、注册获批仅 104 天，创科创板预审最快纪录。计划募资 42.02 亿元人民币（约 6.198 亿美元），用于扩产、具身智能研发与新制造基地。消息带动 A 股机器人板块 7/3 逾 40 只个股涨停。同时宇树与合作方开发的人形机器人已进入东京羽田机场试运营（日本航空发起，测试地勤作业至 2028 年）。
- ↳ **为什么重要**：为整个具身智能赛道打开资本通道；羽田落地验证"从演示到产业"的商业闭环。中国人形机器人进入"资本化+规模化+海外实战"三重加速期。
- 来源：[China Daily](http://global.chinadaily.com.cn/a/202607/04/WS6a483c65a310986e2b46378c.html)

### 3. GPT-5.6 政府协调下分阶段发布，frontier release 监管新范式 ｜ 2026-06-末
OpenAI 本周限量预览 GPT-5.6 系列（Sol 旗舰 / Terra 均衡 / Luna 廉价），Terra 性能对标 GPT-5.5 但成本便宜 2 倍。引入 max reasoning effort 与 ultra mode（subagent 加速）两项新机制，Sol 在 Terminal-Bench 2.1 创 SOTA。因涉及网络安全高危能力，应美国政府要求先向"名单已报备政府"的受信伙伴限量预览；OpenAI 明确表态"不认为这种政府准入流程应成为长期默认"，并称 Sol 未越过 Preparedness 框架的 Cyber Critical 门槛。
- ↳ **为什么重要**：frontier release 首次被纳入政府协调框架，可能成为后续前沿模型发布模板；ultra/subagent 机制标志产品重心从对话向 agent 编排迁移。
- 来源：[OpenAI 发布说明转载](https://releasebot.io/updates/openai)、[Codex changelog](https://developers.openai.com/codex/changelog)

### 4. 元宝下线情感智能体，中国 C 端 AI 监管落地 ｜ 2026-06-30
腾讯元宝 6/30 率先下线 AI 应用智能体功能，是三家（元宝/豆包/千问）中最早行动的——豆包、千问 7/4 才通知将于 7/15 下线。而 7/15 正是《人工智能拟人化互动服务管理暂行办法》正式施行之日（4/10 由国家网信办等五部门公布）。《办法》规范"持续性情感互动服务"，明确不得向未成年人提供虚拟伴侣，注册用户 100 万以上须做安全评估；但明确智能客服/知识问答/工作助手等不适用，目前三家"一刀切"是否重新上架工具类智能体尚未回应。
- ↳ **为什么重要**：本周中国 AI 监管落地的标志性事件——倒逼头部 C 端 AI 产品下架情感类智能体，行业竞争焦点或从"情感陪伴"回归"工具/生产力 Agent"。
- 来源：[南方都市报（东方财富转载）](https://wap.eastmoney.com/a/202607043794207023.html)

### 5. Kimi K2.7 Code 成 GitHub Copilot 首个开源模型，中美开源生态互嵌 ｜ 2026-07-01
GitHub Copilot 正式接入月之暗面开源模型 Kimi K2.7 Code——这是 Copilot 首次接入开源模型，由 GitHub 托管于微软 Azure，按量计费，逐步向 Pro/Pro+/Max 开放。K2.7 Code 为 1 万亿参数、256K 上下文（6/12 发布），官方称长程编程任务性能显著提升、平均 token 消耗减少约 30%。
- ↳ **为什么重要**：国产开源编程模型首次进入西方头部开发者工具链并获"官方分发"，标志中美开源模型竞争进入"生态互嵌"阶段。
- 来源：[新浪财经](https://finance.sina.com.cn/tech/digi/2026-07-03/doc-inifpkau5637518.shtml)

---

## 🧭 三条主线趋势

**主线一：中端"性价比 agentic"成为本周主战场。** 三大西方前沿实验室不约而同下沉中端——Anthropic Sonnet 5（$2/$10，逼近 Opus 4.8）、OpenAI GPT-5.6 Terra/Luna（Terra 比 5.5 便宜 2x）、Google Gemini 3.5 Flash（主打 intelligence per dollar）。前沿能力已足够溢出，竞争焦点从"谁最强"转向"谁能以更低成本跑 agent"，旗舰的商业价值正被次旗舰蚕食。

**主线二：从单模型走向多智能体编排 + 框架层集体转向"图 + 可恢复 + HITL"。** OpenAI ultra mode（subagent 加速）、Gemini 3.5 Flash 并行 subagent、Hermes MoA 一等化（多 frontier 模型开会）、Google ADK Go 2.0（graph workflow engine + 内建 HITL + 跨运行时可恢复）——行业从"更强的单模型"转向"更会协作、可暂停、可人工介入的 agent 系统"。

**主线三：中国力量双线爆发——细分赛道进入全球第一梯队 + 监管与资本同步落地。** 模型侧：字节 Seed 2.1 Pro 前端 Code Arena 全球 #8 追平 Opus 4.6、成本 1/5；DeepSeek V4 以 1M 上下文+超低价延续冲击；智谱 ZCode、Kimi K2.7 Code 生态互嵌。具身侧：宇树 IPO 第一股、优必选 UWORLD U1+Walker S2 边境部署。监管侧：《AI 拟人化互动办法》倒逼元宝等下架情感智能体。资本、场景、监管三轮驱动，2026 是中国 AI 产业化拐点年。

---

## 📚 赛道深度正文

### 🧠 大模型基座（10）

### 1. OpenAI（GPT-5.6 / ChatGPT / Codex）
- 本周动态：本周OpenAI最重磅动态是**GPT-5.6系列限量预览发布**（约2026-06-26起在help center文档露出，本周内在Codex/API向受信合作伙伴放出）。该系列包含三款模型：**Sol（旗舰）、Terra（日常均衡款）、Luna（快速廉价款）**。据OpenAI官方发布说明：Terra性能对标GPT-5.5但**成本便宜2倍**；Luna以最低成本提供强能力。GPT-5.6引入两项新机制：**max reasoning effort（最大推理深度档）**与**ultra mode（利用subagent子代理加速复杂任务的超模式）**。Sol在编码基准**Terminal-Bench 2.1**上创下SOTA；在生物学基准**GeneBench v1**上以更少token超越GPT-5.5；在网络安全基准**ExploitBench²**上仅用约1/3输出token即与Mythos Preview持平。值得注意的是本次采取**政府协调下的分阶段发布**：因涉及网络安全高危能力，应美国政府要求先向"参与者名单已报备政府"的小圈子受信伙伴限量预览，OpenAI在博客中明确表态"不认为这种政府准入流程应成为长期默认"。官方称Sol"未越过Preparedness框架的Cyber Critical门槛"——在Chromium/Firefox测试中能识别bug和利用原语，但未能在测试条件下自主产出完整攻击链。同时Codex侧发生模型切换：**GPT-5.3-Codex与GPT-5.2在Codex中已弃用为可选模型**（针对ChatGPT登录用户），Codex GitHub仓库本周持续高频迭代（0.142.x正式版与0.143.0-alpha系列）。**路线判断**：OpenAI正把前沿能力（尤其agentic coding+cyber）与"安全叙事+政府协调"深度绑定，用分阶段发布换取监管缓冲；ultra mode与subagent方向印证"单模型→多智能体编排"的产品化拐点。
- 关键数据：
  - GPT-5.6 Sol/Terra/Luna 三档，Terra比GPT-5.5便宜2x — https://releasebot.io/updates/openai （fetched 2026-07-05）
  - Sol在Terminal-Bench 2.1创SOTA；ExploitBench²仅约1/3 token持平Mythos Preview — 同上
  - GPT-5.3-Codex/GPT-5.2在Codex弃用 — https://developers.openai.com/codex/changelog （published ~2026-07-02）
- 原文链接：
  - https://releasebot.io/updates/openai （GPT-5.6 Preview 官方发布说明转载，含system card引用）
  - https://developers.openai.com/codex/changelog
- 影响判断：GPT-5.6以"cyber能力+政府协调发布"开创前沿模型监管新范式，可能成为后续frontier release模板；ultra/subagent机制标志OpenAI产品重心从对话向agent编排迁移，对Codex竞争格局冲击最大。

### 2. Google DeepMind（Gemini 3.5 Flash / Gemini 3.5 Pro）
- 本周动态：本周DeepMind核心动态是**Gemini 3.5 Flash正式广泛可用**（deepmind.google/models/gemini 页面本周更新，被多源标注为"newest broadly available Gemini release"）。官方定位其"advances the frontier for intelligence per dollar（推进每美元智能的前沿）"，在长程多轮cyber基准上**比Flash 3提升42%**，同时**token效率提升68%**。官方基准表（对比Gemini 3 Flash / 3.1 Pro / Claude Sonnet 4.6 / Opus 4.7 / GPT-5.5）关键数据：Terminal-bench 2.1 **76.2%**（超3.1 Pro的70.3%、Opus 4.7的66.1%，逼近GPT-5.5的78.2%）；SWE-Bench Pro Public **55.1%**；AgenticMCP Atlas **83.6%**（组内最高）；OSWorld-Verified **78.4%**；GDPval-AA Elo **1656**；MMMU-Pro **83.6%**；ARC-AGI-2 **72.1%**；Humanity's Last Exam **40.2%**。Flash定位主打agentic coding+高速并行（演示60秒生成6个支付UI、并行生成64个分形变体），企业侧Shopify/Macquarie Bank/Salesforce Agentforce/Ramp均已在跑subagent并行工作流。**另一条重要动态**：多个二手源报道**Gemini 3.5 Pro从6月延期至2026年7月**，与一批资深研究员离职处于同一10天窗口，传闻定价约US$2 in/US$12 out（较早期传言的$15/$60大幅下调）——此为二手来源，Pro本身本周未见官方发布，需交叉验证。**路线判断**：DeepMind用Flash抢占"性价比agentic"心智，把并行subagent作为Flash卖点直接对标OpenAI ultra mode；Pro延期+人才流动透露旗舰节奏承压。
- 关键数据：
  - Gemini 3.5 Flash：Terminal-bench 2.1=76.2%，AgenticMCP Atlas=83.6%，GDPval-AA Elo=1656，ARC-AGI-2=72.1% — https://deepmind.google/models/gemini/ （fetched 2026-07-05）
  - 比Flash 3 cyber基准+42%，token效率+68% — 同上
  - Gemini 3.5 Pro延期至7月，传闻定价$2/$12（二手，未官方证实）— https://neuriflux.com/en/blog/gemini-3-5-pro-delayed-july-2026 ; https://tech-insider.org/au/gemini-3-5-pro-delayed-july-2026/ （published ~2026-07-02）
- 原文链接：
  - https://deepmind.google/models/gemini/ （官方模型页含完整基准表）
- 影响判断：Flash 3.5把"intelligence per dollar"作为主战场，直接压制中端市场并对标GPT-5.6 Luna/Terra；Pro延期若属实说明旗舰竞赛难度上升，Google在中端以量取胜、旗舰谨慎的双轨策略成型。

### 3. Anthropic（Claude Sonnet 5 / Opus 4.8）
- 本周动态：Anthropic于**2026-06-30（周二）正式发布Claude Sonnet 5**，官方定位"the most agentic Sonnet model yet（迄今最具agent能力的Sonnet）"。核心卖点：**以远低于Opus 4.8的价格逼近Opus 4.8性能**。官方博客明确：Sonnet 5能自主制定计划、使用浏览器/终端等工具、autonomous运行到"几个月前需更大更贵模型才能达到"的水平；相比前代Sonnet 4.6在推理、工具使用、编码、知识工作等agentic维度大幅提升。**定价**：introductory定价$2/百万input token、$10/百万output token（有效期至2026-08-31），之后转正常定价$3/$15——仍显著低于Opus 4.8的$5 input/$25 output。**产品分发**：即日起成为Free和Pro计划默认模型，并向Max/Team/Enterprise开放，同时上线Claude Code与Claude Platform，API标识claude-sonnet-5。**技术细节**：Sonnet 5是对Sonnet 4.6的升级但**采用了更新的tokenizer**（改变文本处理方式以提升性能）；官方称其在agentic场景更安全，undesirable behaviors率低于4.6，且cybersecurity能力**显著低于当前Opus模型**（有意为之的安全设计）。早期合作伙伴（Salesforce工作流、Lovable、法律AI Eve、ClickHouse等）反馈其"能独立跑完复杂PR并自测、race condition/brownfield代码修根因而非补症状"。另据二手源（gHacks），Anthropic在美国放松出口管制后**恢复Fable 5和Mythos 5的访问**。商业层面VentureBeat报道此次降价发生在Anthropic"冲刺重磅IPO"背景下。**路线判断**：Anthropic用Sonnet 5打"agentic性价比"牌下沉中端，effort档位机制让Sonnet 5覆盖比Opus 4.8更宽的成本-性能区间，是典型的"次旗舰蚕食旗舰价格带"策略，IPO前做营收规模。
- 关键数据：
  - Sonnet 5定价$2/$10（至8/31）→$3/$15；Opus 4.8为$5/$25 — https://www.anthropic.com/news/claude-sonnet-5 ; https://venturebeat.com/technology/anthropic-launches-claude-sonnet-5-at-a-steep-discount-to-its-top-model-as-the-company-races-toward-a-blockbuster-ipo （published 2026-07-01/02）
  - 发布日2026-06-30；默认模型覆盖Free/Pro — https://techcrunch.com/2026/06/30/anthropic-launches-claude-sonnet-5-as-a-cheaper-way-to-run-agents/
  - 采用更新tokenizer；cyber能力低于Opus — https://www.anthropic.com/news/claude-sonnet-5
- 原文链接：
  - https://www.anthropic.com/news/claude-sonnet-5 （官方发布博客，含system card引用）
- 影响判断：Sonnet 5把"接近旗舰的agentic能力+腰斩价格"推向所有付费/免费用户，直接挤压GPT-5.6 Terra与Gemini 3.5 Flash的中端市场；IPO前用价格战抢agent市场份额，是Anthropic商业化关键落子。

### 4. Meta AI（Llama 4 / Muse Spark / Watermelon）
- 本周动态：Meta本周核心动态是**Alexandr Wang（Meta Superintelligence Labs超级智能负责人、Scale AI联创）在内部全员会（town hall，约7月2-3日）披露下一代模型"Watermelon"进展**：据Business Insider/Benzinga/AOL/Windows Report多源交叉报道，Wang称"Watermelon目前正在训练中，在关键基准上已追平OpenAI的GPT-5.5"，且"Watermelon使用的算力比Avocado高一个数量级（an order of magnitude more compute）"。其中**Avocado是Muse Spark的内部代号**——Muse Spark是Meta今年4月推出的、Wang加入九个月来的首个重大AI模型，也是Meta Superintelligence Labs新模型家族的第一款。另一条本周相关动态：多源报道**Meta正悄悄搭建AI算力租赁业务**（首次曝光约7月1日），让企业按需调用Llama系列而无需自建硬件，直接对标AWS/Azure/Google Cloud。此外Muse Spark已在Meta多数智能眼镜上替代原有Meta AI（对Llama 4的显著升级）。**注意**：Watermelon为训练中、未发布，GPT-5.5持平说法来自内部town hall转述（一手为内部会议、公开为二手媒体），需谨慎；Llama 4 Maverick仍是当前公开旗舰但已被Muse Spark路线取代。**路线判断**：Meta正明确从"Llama开源家族"向"Superintelligence Labs闭源前沿模型（Muse Spark→Watermelon）"战略转轨，Wang主导下走"堆算力追赶前沿"路线；同时用算力租赁把GPU资产变现，商业模式从纯开源分发转向云基础设施+闭源模型双轮。
- 关键数据：
  - Watermelon训练中，关键基准追平GPT-5.5，算力比Avocado高一个数量级 — https://www.businessinsider.com/meta-ai-model-catches-up-openai-gpt-5-says-2026-7 ; https://www.benzinga.com/markets/tech/26/07/60264651/... （published 2026-07-03/04，均转述Wang town hall）
  - Avocado=Muse Spark内部代号，Muse Spark为4月发布 — 同上
  - Meta算力租赁业务首曝2026-07-01 — https://windowsnews.ai/article/meta-challenges-aws-with-ai-compute-rentals-llama-models-available-on-demand.433356
- 原文链接：
  - https://www.businessinsider.com/meta-ai-model-catches-up-openai-gpt-5-says-2026-7 （BI原报道，town hall转述）
  - https://africa.businessinsider.com/news/alexandr-wang-says-metas-coming-ai-has-caught-up-with-openais-flagship-model/xehdvwb
- 影响判断：Meta以"追平GPT-5.5"信号对内提振士气、对外重塑落后叙事，Watermelon是Wang超级智能实验室的成败之作；从Llama开源转向闭源前沿+算力租赁，标志Meta AI战略重大转向，若Watermelon兑现将改变开源阵营格局。

### 5. xAI（Grok 4.5 / Grok Voice / Grok Build）
- 本周动态：xAI本周多线推进。①**Grok 4.5私测**：据Wikipedia等源，Elon Musk于**2026-06-28宣布Grok 4.5已在SpaceX和Tesla私测**，该版本建立在**1.5万亿参数的V9基座**上，并整合了AI编码平台Cursor的数据（未公开发布）。②**Grok Voice Agent Builder发布**（2026-07-01，官方@xai推特+x.ai/news）：一个no-code语音agent平台，号称2分钟内用自然语言呼叫流程搭出生产级电话agent，集成STT/推理/TTS/电话/工具/护栏/MCP/可观测性全栈。技术细节：主打speech-to-speech整合路径、亚秒级延迟、支持25+语言；声称**Grok Voice Think Fast 1.0在τ-voice Bench以67.3%登顶，超Gemini 3.1 Flash Live的43.8%与GPT Realtime 1.5的35.3%**。定价$0.05/分钟音频（xAI号码另加$0.01/分钟电话费），含80+内置音色+约2分钟音频品牌克隆，无平台费。③**Grok Voice进入Grok Build**（2026-07-02）：语音能力从API层扩展到编码agent平台，Grok Build内STT上线，可对编码agent口述prompt。④Grok Build changelog本周持续迭代（v0.2.70/0.2.71，6月27日修Windows stdio hang、加grok wrap）。背景：4月SpaceX已收购xAI（背景，非本周）。**路线判断**：xAI正把Grok从聊天机器人拓展为"语音+编码+企业agent"全栈平台，Voice Agent Builder以极致价格（$0.05/min）+整合speech-to-speech技术差异化切入企业呼叫市场，直接对标OpenAI Realtime与Gemini Live。
- 关键数据：
  - Grok 4.5私测，1.5T参数V9基座，整合Cursor数据 — https://en.wikipedia.org/wiki/Grok_(chatbot) （published ~2026-07-02，转述Musk 6/28声明）
  - Grok Voice Think Fast 1.0 τ-voice Bench 67.3% vs Gemini 3.1 Flash Live 43.8% vs GPT Realtime 1.5 35.3% — https://www.testingcatalog.com/icymi-xai-debuts-grok-voice-agent-builder-for-enterprises/ （fetched 2026-07-05，引x.ai/news）
  - Voice定价$0.05/min音频+$0.01/min电话 — 同上
- 原文链接：
  - https://www.testingcatalog.com/icymi-xai-debuts-grok-voice-agent-builder-for-enterprises/ （详述Voice Agent Builder，引x.ai官方）
  - https://x.ai/news
- 影响判断：Grok Voice以benchmark领先+激进定价抢占语音agent赛道，是xAi商业化重要一步；Grok 4.5的1.5T V9基座+Cursor数据显示xAI仍在猛推基座+编码，与SpaceX/Tesla场景绑定形成独特护城河。

### 6. Microsoft（Copilot / Azure AI / Phi）
- 本周动态：Microsoft本周无单一重磅基座模型发布，但生态侧多线密集更新（多在6/17–7/1窗口）。①**GitHub Copilot新增Moonshot Kimi K2.7 Code并GA（2026-07-01）**：Business/Enterprise需管理员启用，模型为开源权重、Azure托管，其低成本来自MoE架构（仅激活部分专家）——Microsoft把第三方开源中国模型纳入Copilot自选池，值得注意。②**Copilot Autofix for Azure DevOps有限公测**：AI驱动的漏洞自动修复，为用Azure Repos的团队自动分析并修复安全漏洞。③**Azure Copilot observability agent正式GA**+FinOps MCP Server预览：Microsoft在打造"连接可观测性、治理、优化的闭环agentic云运维模型"。④**GitHub Models将于2026-07-30全面关停**：Playground（原可直接测Llama 3/Mistral/Phi-3的浏览器界面）等全部组件下线，团队须在7/30前迁移——对Phi生态是负面信号。⑤M365 Copilot发布release notes（6/17–7/1更新）；Copilot for Security被纳入M365 E5/E7；Windows将于7月起第二轮强制预装Copilot（扩展到Semi-Annual Enterprise Channel）。⑥M365定价2026-07-01起调整。**注意**：本周Phi系列无新模型发布，且GitHub Models关停波及Phi试用入口。**路线判断**：Microsoft本周主线是"agentic运维闭环+把最强第三方模型（含Kimi K2.7、OpenAI GPT-5.6）纳入Copilot分发"，走"平台聚合+企业渗透"路线，自研Phi小模型热度下降，战略重心明显偏向Copilot生态与Azure agent基础设施。
- 关键数据：
  - Kimi K2.7 Code在Copilot GA 2026-07-01，MoE开源权重、Azure托管 — https://windowsforum.com/threads/github-copilot-adds-moonshot-kimi-k2-7-code-... （published 2026-07-03）
  - GitHub Models 2026-07-30全面关停 — https://windowsnews.ai/article/github-models-shutdown-windows-teams-have-until-july-30-to-migrate.433587
  - Azure Copilot observability agent GA — https://finopsweekly.com/news/azure-updates-2026-07-02/
  - Copilot Autofix for Azure DevOps有限公测 — https://techgig.com/news/software-devops/microsoft-introduces-ai-driven-copilot-autofix-for-azure-devops/132105909
- 原文链接：
  - https://learn.microsoft.com/en-us/microsoft-365/copilot/release-notes （M365 Copilot官方release notes，6/17–7/1）
  - https://techgig.com/news/software-devops/microsoft-introduces-ai-driven-copilot-autofix-for-azure-devops/132105909
- 影响判断：Microsoft把Kimi K2.7等第三方开源模型纳入Copilot、关停GitHub Models、强推Copilot运维闭环，显示其定位从"模型自研者"转向"最强模型聚合分发+企业agent平台"；Phi自研线本周边缘化是值得跟踪的信号。

### 7. DeepSeek（V4-Flash / V4-Pro / V4正式版）
- 本周动态：DeepSeek本周核心动态是**2026-06-29晚官方宣布DeepSeek V4正式版将于7月中旬发布**（通过用户通知邮件，知乎数小时内2.91M浏览；TechNode/Pandaily/36氪/Reddit多源交叉）。据TechNode转官方：V4正式版在现有preview基础上做功能优化和性能提升，**全系标配100万token上下文窗口**，在**agent任务执行、数学推理、代码生成**方面性能更强。同时首次推出**峰谷分时API定价**：**高峰时段为每日北京时间9:00–12:00与14:00–18:00，此期间API按平峰2倍计费**（被类比分时电价）。当前API文档已上线**deepseek-v4-flash与deepseek-v4-pro**两款：均支持思考/非思考双模式、1M上下文、最大输出384K、JSON/Tool Calls/FIM。**定价（当前preview）**：V4-Flash——input cache hit $0.0028、cache miss $0.14、output $0.28/百万token，并发上限2500；V4-Pro——input cache hit $0.003625、cache miss $0.435、output $0.87/百万token，并发500。旧模型名deepseek-chat/deepseek-reasoner将于**2026-07-24 15:59 UTC弃用**，分别对应v4-flash的非思考/思考模式。有二手源提及DeepSeek新一轮融资（"400亿""募资50亿"，未核实，标注存疑）。**路线判断**：DeepSeek以"1M上下文+agent/代码/数学强化+极致低价（较GPT-5.5便宜约17倍）"延续性价比屠夫路线，但首推分时定价说明推理集群在高峰时段承压，用价格杠杆削峰填谷，是算力紧张下的务实商业化手段。
- 关键数据：
  - V4正式版2026年7月中旬发布，全系1M上下文；峰谷定价高峰2x（9-12点、14-18点北京时间）— https://technode.com/2026/06/30/deepseek-to-launch-v4-in-mid-july-with-new-peak-time-api-pricing/ ; https://pandaily.com/deepseek-v4-official-july-peak-pricing-jun2026 （published 2026-06-30）
  - V4-Flash: cache miss $0.14 in/$0.28 out；V4-Pro: $0.435 in/$0.87 out（百万token）— https://api-docs.deepseek.com/quick_start/pricing （fetched 2026-07-05）
  - deepseek-chat/reasoner 2026-07-24 15:59 UTC弃用 — 同上
- 原文链接：
  - https://api-docs.deepseek.com/quick_start/pricing （官方定价文档，V4-Flash/Pro规格）
  - https://technode.com/2026/06/30/deepseek-to-launch-v4-in-mid-july-with-new-peak-time-api-pricing/
- 影响判断：V4以1M上下文+agent强化+超低价延续开源性价比冲击，峰谷定价是国产大模型首次将"分时电价"逻辑用于API，既是算力削峰工具也是行业定价创新，可能被同行效仿。

### 8. Databricks（DBRX / Mosaic ML / 企业AI平台）
- 本周动态：**本周无重大公开的新模型/新平台发布**。Databricks的核心大事件——Data + AI Summit 2026（DAIS，发布Genie One、Lakebase、LTAP、Unity AI Gateway、Agent Bricks等20+项）以及IPO/融资动向，均发生在本周时间窗（6/28–7/4）之前，属背景。相关背景要点（非本周）：①（背景，非本周）CEO Ali Ghodsi于2026-06-04对Bloomberg TV表示"2026是上市的糟糕年份"，明确排除2026年IPO，指向最早2027；②（背景，非本周）2026-06-08/09 The Information报道Databricks正洽谈新一轮私募，估值**$165–175B**，较半年前$134B跳涨23–31%；③公司自证财务：**$5.4B收入run rate、同比增长>65%、$1.4B AI产品收入、净留存率>140%、正向自由现金流**（另有二手源称6月年化收入达$6.9B，口径不一，需谨慎）。本周期内仅有常规产品release notes（6月）滚动更新，无单独重磅公告。DBRX作为2024年3月发布的开源MoE模型早已非重心，Mosaic ML能力已融入AI Pretraining/Model Serving等企业平台。**判断依据**：遍历官方June release notes、DAIS recap、IPO分析多源，未见6/28–7/4区间内新基座模型或标志性平台GA公告。
- 关键数据：
  - （背景，非本周）新一轮估值$165–175B洽谈，前值$134B — https://tech-insider.org/databricks-134-billion-ipo-enterprise-software-2026/ （报道时间2026-06-08/09）
  - （背景）$5.4B run rate、$1.4B AI收入、净留存>140% — 同上
- 原文链接：
  - https://tech-insider.org/databricks-134-billion-ipo-enterprise-software-2026/ （IPO/财务/融资综合分析，含6月更新）
  - https://docs.databricks.com/aws/en/release-notes/product/2026/june （官方6月release notes）
- 影响判断：Databricks本周静默，战略主线（DAIS的Agent Bricks/Lakebase企业agent栈 + 推迟IPO转私募扩融资）已在此前落定；作为企业数据+AI平台，其打法是"不追前沿基座、专注企业agent与数据一体化"，本周无新增信号但方向清晰。

### 9. 字节跳动（豆包 / Seed 2.1 / Coze）
- 本周动态：字节本周动态密集，围绕**豆包/Seed 2.1 Pro**展开。核心模型豆包2.1系列（Doubao-Seed-2.1，含Pro/Turbo）于**2026-06-23火山引擎FORCE大会发布**（略早于本窗口，属临界背景），定位"面向Coding与Agent时代的基础模型"；6月24日发布接入2.1 Pro的**豆包专业版**（办公任务模式，可操作本地电脑/浏览器/调用Skills/定时任务，内置Office套件）。**本周（6/28–7/4）内的真实新动态**：①**Seed 2.1 Pro Preview在Code Arena: Frontend榜以1539分位列全球#8、追平Claude Opus 4.6**（Arena.ai榜单，本周多篇评测published），7个子类中5类进前十（Brand&Marketing #6、React #7最强，raw HTML #14最弱），显示其被专门调优为"设计感强的成品级前端"而非骨架代码；字节称该preview仍处Arena早期访问，**数周内将公开发布**，率先接入Feishu Spark（飞书）和Coze。②据国内深度报道，豆包2.1 Pro官方称在Coding/Agent/VLM三方向"首次超越Claude Opus 4.6"、多项测试接近或追平GPT-5.5与Claude Opus 4.7，**日均Token调用量突破180万亿、市场份额49.5%、使用成本仅为Claude的约1/5**。③另有Seedance 2.5（视频）传闻早7月企业closed beta（未确认）、Seedance 2.0已发布。**注意**：模型本体发布日6/23在窗口前；本周落在窗口内的是Arena榜单成绩、公开发布倒计时与生态接入进展。**路线判断**：字节走"极致低价（1/5 Claude）+超大调用量（180万亿/日）+全栈生态（TRAE/CLI/企业版/火山方舟/Coze）"路线，用规模和成本碾压式打法在国内Coding/Agent市场建壁垒。
- 关键数据：
  - Seed 2.1 Pro Preview Code Arena Frontend #8、1539分、追平Opus 4.6 — https://felloai.com/seed-2-1-pro/ （fetched 2026-07-05，引arena.ai/leaderboard/code）
  - 豆包2.1 Pro日均Token 180万亿、份额49.5%、成本约Claude 1/5 — https://www.aitoollab.cn/articles/doubao-2-1-pro-comprehensive-analysis/ ; https://36kr.com/p/3867326839117063 （published 2026-06-25起，本周持续发酵）
  - 豆包2.1系列/专业版发布2026-06-23/24（背景，临界窗口前）— https://awtmt.com/articles/3775738
- 原文链接：
  - https://felloai.com/seed-2-1-pro/ （Seed 2.1 Pro Code Arena榜单详解，含子类breakdown）
  - https://seed.bytedance.com/en/models （字节Seed官方模型页）
- 影响判断：Seed 2.1 Pro以"追平Opus 4.6的前端能力+1/5成本"标志国产模型首次在前端Coding进入全球第一梯队；180万亿日调用量说明字节已把豆包做成国内规模最大的模型分发入口，成本战+生态战是其核心武器。

### 10. Mistral AI（Leanstral 1.5 / Mistral Large / Codestral）
- 本周动态：Mistral本周有明确新发布——**2026-07-03发布Leanstral 1.5**（官方mistral.ai/news/leanstral-1-5）。这是一款**Apache-2.0开源、面向Lean 4形式化验证/自动定理证明的code agent模型**，采用MoE架构：**总参数119B、激活仅6B**。官方基准：**完全saturate miniF2F（验证集+测试集均100%）**；**PutnamBench 672题解出587题**；FATE-H达**87%（SOTA）**、FATE-X达**34%（SOTA）**。训练分三阶段：mid-training→SFT→用CISPO做RL，含"多轮证明环境"（提交proof→Lean编译器反馈→迭代）与"code agent环境"（在真实文件系统编辑文件、跑bash、用Lean language server查goal/error/类型）。**成本亮点**：PutnamBench上以约**$4/题**险胜Seed-Prover 1.5 high 7题，而后者估算**$300+/题**（每题10 H20-day预算）；Aleph Prover则$54–68/题。实用价值上，Leanstral 1.5在57个代码仓库中**发现5个此前未知bug**。已通过Hugging Face+免费API开放。**注意**：本周未见Mistral Large/Codestral旗舰新版本，主线是垂直形式化推理模型。**路线判断**：Mistral延续"开源权重+垂直专精+极致性价比"欧洲路线，Leanstral瞄准形式化验证这一高价值窄赛道，用1/75的成本挑战字节Seed-Prover等对手，是"小而精、开源可信"的差异化打法。
- 关键数据：
  - Leanstral 1.5：119B总参/6B激活，Apache-2.0；miniF2F 100%、PutnamBench 587/672、FATE-H 87%、FATE-X 34% — https://mistral.ai/news/leanstral-1-5/ （published 2026-07-03）
  - 成本约$4/题 vs Seed-Prover 1.5 high $300+/题 — 同上
  - 57仓库发现5个未知bug — 同上
- 原文链接：
  - https://mistral.ai/news/leanstral-1-5/ （官方发布博客，含训练/评测细节）
- 影响判断：Leanstral 1.5把"前沿形式化证明能力"以开源+近乎白菜价放出，冲击昂贵闭源定理证明器；Mistral以垂直专精+开源可信在被巨头夹击中守住独特生态位，形式化验证是其押注的高壁垒方向。

---


---

### 🤖 垂直 Agent 产品 + 🇨🇳 中国公司（12）

### 1. Anysphere（Cursor）
- 本周动态：本周Cursor最重磅的动态是**Cursor iOS 移动端 App 正式进入公开测试（public beta）**，面向所有付费计划开放（官方 changelog 页面《Cursor Mobile App for iOS》）。核心能力包括：①**云端 Agent 上手机**——在手机 App 里选仓库、启动 always-on 云端 Agent，可选任意前沿模型、用语音口述需求、用斜杠命令引导；云端 Agent 跑在隔离虚拟机里，可合上笔记本让会话在云端继续跑；②**Remote Control（远程控制）**——通过 Agents Window 把电脑上正在跑的 Agent 从手机继续指挥，并可设置保持电脑唤醒以维持可达；③**Live Activities + 推送通知**——在锁屏追踪 Agent 状态，Agent 完成/需要输入/待审时推送；④**Artifacts & SCM**——手机上审查 demo/截图/日志/diff，留后续指令或直接合并 PR。下载地址 apps.apple.com/app/cursor/id6767085653。同周 changelog 还密集更新：Team Marketplaces 支持 Team MCP 与组织组分发、Customize 统一页面（plugins/skills/MCPs/subagents/rules/commands/hooks 分层管理）、Automations 增加 /automate 技能与 Slack emoji 触发器+5个新 GitHub 触发器+computer use 工具、云端环境一键搭建（<10分钟生成可复用快照）与 /in-cloud 云端子Agent。技术/商业路线判断：Cursor 正把"编码 Agent"从 IDE 内推向**多端、always-on、企业级编排**——移动端+云端 Agent+自动化触发，本质是把 Cursor 从"编辑器"重塑为"随时随地运行的软件工程自动化平台"，对标 Devin 式后台 Agent 但更贴近既有开发者工作流。
- 关键数据：iOS App 公开测试，付费计划可用（cursor.com/changelog《Cursor Mobile App for iOS》，本周）；App Store ID 6767085653。背景（非本周）：SpaceX 拟以约 $60B 收购 Anysphere，预计 2026 Q3 完成（Wikipedia 引 6/16 公告）。
- 原文链接：https://cursor.com/changelog ; https://cursor.com/blog/ios-mobile-app
- 影响判断：移动端+云端 always-on Agent 标志编码 Agent 竞争从"补全/对话"升级到"远程自主执行+移动指挥"，Cursor 意在锁定企业开发全流程；若 SpaceX 收购落地，资本与算力加持将进一步拉开与二线编码工具差距。

### 2. Perplexity
- 本周动态：本周 Perplexity 以**企业销售落地 + 生态数据集成 + 垂直法律应用**三线并进。①**Tech Mahindra 全面部署 Perplexity Enterprise Pro**（6/29 官方联合公告）——印度 IT 巨头 Tech Mahindra（NSE: TECHM，14.7万+员工、90+国家、1100+客户）在其销售与客户团队全面部署 Enterprise Pro，为高级销售领导与客户合伙人提供实时、带来源引用的行业/技术洞察；Perplexity CEO Aravind Srinivas 亲自站台称"把 Enterprise Pro 交到他们销售团队手里，在最关键时刻给出有来源支撑的答案"。②**Forge Global 集成**（约 7/2 报道）——Forge Global 把 Forge Price 等私募市场专有数据接入 Perplexity Computer，用于私募市场研究。③**法律垂直**（Law.com 6/30）——Perplexity 近期推出面向法律工作的 agentic AI 工具，已被 Hecker Fink 律所测试评估。官方口径中 Perplexity 每月回答**超 15 亿个问题**（webwire 公告"About Perplexity"），并强调其产品矩阵：answer engine、Comet 浏览器（首个 AI 原生浏览器+Comet Assistant）、Perplexity Computer（跨工具/文件/代码/持久记忆/开放网络的多模态编排）。技术/商业路线判断：Perplexity 正从"AI 搜索"向"企业级 agentic 工作平台 + 生态数据枢纽"扩张——用 Enterprise Pro 打 B 端销售场景、用 Computer 编排承接 Agent 化、用第三方数据（Forge/金融）构建垂直护城河，商业化明显提速。
- 关键数据：月回答问题 >15 亿（webwire 6/29 公告）；估值/用户第三方口径 $20B 估值、45M 用户、780M 月查询、$200M ARR（aibusinessweekly.net，标注 1 week ago，非官方，需谨慎）；Tech Mahindra 规模 147,000+ 员工/90+ 国/1100+ 客户（6/29 公告）。
- 原文链接：https://www.webwire.com/ViewPressRel.asp?aId=356901 （Tech Mahindra×Perplexity 6/29 官方公告全文）
- 影响判断：与 Tech Mahindra 这类大型 IT 服务商合作，等于把 Perplexity Enterprise Pro 通过其 1100+ 客户渠道二次分发，是典型的"借船出海"企业获客；叠加金融/法律垂直，Perplexity 在 B 端与 Google/OpenAI 的差异化正在成型。

### 3. Cognition（Devin/Windsurf）
- 本周动态：本周 Cognition 三件大事密集落地。①**Windsurf 正式更名 Devin Desktop**——windsurf.com 域名已跳转 Devin，IDE 更名"Devin Desktop"，以 OTA 更新推送，用户的计划/定价/扩展/设置/进行中工作自动迁移（devin.ai/desktop；developersdigest 于 7/1 核实 devin.ai/pricing）。Devin Desktop 定位"Agent Command Center"，主打管理本地+云端 Agent 舰队、内置完整 IDE、基于 **Agent Client Protocol（ACP）** 跨模型跨 Agent、Spaces 共享上下文与 Git worktree、Supercomplete、Fast Context（毫秒级定位相关文件行）、免费无限使用**SWE-1.6（号称全球最快编码模型）**；官网称 1M+ 用户、4000+ 企业客户。②**Devin Security Swarm 全球上线**（PRNewswire 官方稿）——面向企业安全团队，基于 agentic map-reduce 架构，多个并行 Agent 跨文件推理，在隔离沙箱运行时复现确认漏洞可利用性，并直接写补丁开 PR。基准：50 个真实漏洞（对应已发布 GitHub 安全公告、14 种语言）中找到 36 个（超过所有受测 AI 扫描器），每发现成本比次优方案低 30%，3 个严重漏洞仅 Devin 独家发现。配套 6 周"Devin Security Program"清理漏洞积压。③**Devin Fusion**（官方 Reddit r/windsurf 公布）——多模型 harness，在保持 frontier/Fable 级性能的同时降本 35%。技术/商业路线判断：Cognition 正把 Windsurf 品牌彻底并入 Devin，形成"IDE（Devin Desktop）+自主 Agent（Devin）+垂直安全（Security Swarm）+多模型降本（Fusion）"的完整栈，用 ACP 开放协议对抗 Cursor 的封闭生态，安全 Swarm 则切入"AI 生成代码激增导致漏洞暴增"这一新刚需。
- 关键数据：Security Swarm 基准 50 漏洞找到 36、成本低 30%（PRNewswire 官方稿，本周）；Devin Fusion 降本 35%（Reddit r/windsurf，约 6/30）；Devin Desktop 1M+ 用户、4000+ 企业客户（devin.ai/desktop）。背景（非本周）：Series D 披露企业用量 2026 年初以来增 10x+、run-rate 收入达 $492M；估值第三方口径约 $26B（newmarketpitch，非本周官方）。
- 原文链接：https://www.prnewswire.com/news-releases/cognition-launches-devin-security-swarm-to-tackle-the-vulnerability-backlog-302814800.html ; https://devin.ai/desktop
- 影响判断：Windsurf→Devin Desktop 收束品牌，标志 Cognition 从"单一 Agent 公司"转向"编码 Agent 全平台"；Security Swarm 用可验证 benchmark + 直接开 PR 的闭环，把安全从"发现"推进到"修复"，是编码 Agent 向企业刚需场景纵深的重要信号。

### 4. Harvey（Legal）
- 本周动态：本周 Harvey 两条实锤动态。①**Claude Sonnet 5 上线 Harvey**（6/30，Harvey 应用研究负责人 Niko Grupen 具名评价）——Anthropic 最新中端模型 Sonnet 5 在 Harvey 平台正式可用，面向诉讼与交易类工作流。关键 benchmark：在 Harvey 自研 **Legal Agent Benchmark（LAB）** 上取得 5.8% all-pass（模拟律所复杂法律任务的严苛评测），在起草类任务（能源与自然资源、房地产、资本市场）表现突出；在 **BigLaw Bench** 上取得 **91.3%**，超越此前所有 Sonnet 和 Opus 模型，风险评估/合规/案件管理为强项。Grupen 称"相比 Sonnet 4.6 是法律质量的实质跃升，更准更精、用更少的字给更强答案"，但坦言在税务、结构化金融等密集专业分析任务上仍有挑战、复杂多步任务仍难做到每步无误。Harvey 计划先向符合条件的美国客户推送，随后 EU、澳洲。②**韩国大所 Bae Kim & Lee（太平洋律师事务所）采用 Harvey**（7/1，Seoul Economic Daily）——计划把 Harvey 扩展为全所成员使用的工作平台，是韩国主要律所中首个让全体成员使用全球法律 AI 平台的。技术/商业路线判断：Harvey 走"多模型平台+自研法律 benchmark+全球大所渗透"路线，通过第一时间接入前沿模型（Sonnet 5）保持产品前沿性，同时用 LAB/BigLaw Bench 建立行业评测话语权。
- 关键数据：Sonnet 5 在 BigLaw Bench 得分 91.3%、LAB all-pass 5.8%（blockchain.news 引 Harvey，6/30）；Harvey 四大产品（Assistant/Vault/Knowledge/Workflow Agents，gc.ai 截至 2026-06）；背景（非本周）：2026-05 推出 500+ 律师构建的 agent 库+升级版 Agent Builder（UC Davis libguide）。
- 原文链接：https://blockchain.news/news/claude-sonnet-5-launches-harvey
- 影响判断：Harvey 抢先集成 Sonnet 5 并公开 benchmark，既保持对律所客户的技术领先叙事，也把自研 LAB/BigLaw Bench 打造成法律 AI 事实标准；韩国头部大所全员采用，显示 Harvey 全球化从欧美向亚洲高端法律市场扩张。

### 5. Sierra
- 本周动态：本周 Sierra（Bret Taylor 与 Clay Bavor 创办的企业级客服 Agent 公司，Taylor 现任 OpenAI 董事会主席）最主要的本周动态是**收购 YC 支持的法国初创公司 Fragment**（ZoomInfo 转载报道，约 7/2"announced today"；具体金额未公开）。这是 Sierra 在 2026 年 5 月完成 $950M E 轮、估值升至 $15.8B 后的首笔公开并购，延续其"Agent OS"平台扩张路线。结合本周同期的行业背景：Sierra 的产品核心是 **Agent OS 2.0**（多渠道部署 chat/voice/email/SMS/messaging+ChatGPT+呼叫中心；Agent SDK 声明式目标与确定性护栏、可组合技能、GitHub Actions CI/CD、多 Agent 编排；Agent Studio 低代码 Journeys；Agent Data Platform 跨会话记忆；监督型 Agent+护栏；"constellation of models"多模型编排），并以**按结果付费（outcome-based pricing）**闻名——只有 Agent 达成"已解决对话/挽回取消/追加销售"等约定结果才收费。公开客户含 WeightWatchers、Sonos、ADT、SiriusXM、Cigna、Nordstrom、Nubank、Rivian、Rocket Mortgage 等（WeightWatchers 的 Sierra Agent 号称处理近 70% 客户会话、满意度 4.6/5，为厂商口径）。技术/商业路线判断：并购 Fragment 大概率是补强团队/技术（acquihire 或能力并入 Agent OS），Sierra 正用充沛资本（累计融资 >$14 亿）横向扩张，巩固其在高端企业客服 Agent 的领先地位；但 G2 用户反馈其定价不透明、长对话上下文丢失、自助编辑受限仍是短板。
- 关键数据：收购法国 YC 初创 Fragment（金额未公开，ZoomInfo 转载，约 7/2）；背景（非本周）：2026-05 E 轮 $950M、估值 $15.8B（Tech Startups/CMSWire），此前 $350M 轮估值 $10B，累计融资 >$14 亿（voiceflow 引，2024 起）。
- 原文链接：https://www.zoominfo.com/c/sierra-technologies-inc/1333837177 ; https://www.getmacha.com/blog/sierra-ai-complete-guide （2026-07-01 更新，含 Agent OS 2.0/定价细节）
- 影响判断：在客服 Agent 赛道（Decagon、Intercom Fin、Salesforce Agentforce 竞争白热化，Salesforce 6/15 拟 $36 亿收购 Fin）中，Sierra 用并购+超高估值巩固头部地位；Fragment 并入是其从"融资扩张"转向"能力整合"的信号。

### 6. Glean
- 本周动态：本周 Glean 最实锤的本周动态是**成为 Okta 扩展版 Cross App Access（XAA）生态的早期采用者之一**（Okta 官方新闻稿，6/30–7/1 窗口）。Okta 宣布扩展 XAA 生态，25+ 早期采用者含 Anthropic、Cursor、Glean、Slack、Atlassian、Figma、Zoom 等；Glean 被列为 **XAA "resource app"（下游应用/MCP 服务器）**——即 AI Agent 可通过用户的 Okta 身份、在企业策略校验下安全拉取 Glean 里的"内部知识与公司上下文"。XAA 是基于 OAuth 的扩展、并被正式纳入 MCP 授权扩展（Enterprise-Managed Authorization），为跨应用 Agent 访问提供厂商中立的身份治理标准。对 Glean 而言，接入 XAA 意味着其企业知识平台被纳入"安全 Agent 企业蓝图"的可信数据源层。另有 TipRanks（时间戳存疑，内容对应 Gartner 2026-06 象限）报道 Glean 获 Gartner "No-Code Agent Builders 初创厂商 Market Shaper"认可、任命 Shoji Ozawa 为日本 Country Manager 推进国际扩张——此为 6 月动态，作背景。技术/商业路线判断：Glean 的护城河是"索引企业已有全部数据+尊重每条权限+一个答案框+一群 Agent"，本周接入 Okta XAA 正是把"权限尊重/安全治理"这一核心卖点标准化、生态化，绑定 Okta 身份体系以对抗 Microsoft Copilot、Gemini Enterprise。
- 关键数据：XAA 25+ 早期采用者含 Glean（Okta 官方稿，6/30–7/1）；背景（非本周官方）：$300M ARR（截至 2026-05，YoY +89%）、估值 $7.2B（F 轮 $150M 后，valueaddvc 第三方口径）；Gartner 2026-06 No-Code Agent Builders Market Shaper。
- 原文链接：https://www.okta.com/newsroom/press-releases/okta-announces-cross-app-access-partners/
- 影响判断：企业 AI 竞争正从"谁的模型强"转向"谁能安全地让 Agent 跨应用取数"，Glean 抢先接入 Okta 中立身份标准，把自己钉在"企业 Agent 可信数据枢纽"位置，是其对抗微软/谷歌捆绑打法的关键防御动作。

### 7. Midjourney（v7）
- 本周动态：**本周（2026-06-28~07-04）无经官方一手来源确认的重大公开动态**。原因：Midjourney 本轮大动作集中在窗口之前——①V8.1 于 2026-06-11 被提升为默认模型（V7 仍可选，blakecrosley 指南，背景，非本周）；②2026-06-18 Midjourney 高调发布"Midjourney Medical"及全身超声扫描仪原型（基于与 NYSE 上市公司 Butterfly Network 的 5 年、最高 $74M 授权协议，letsdatascience/futurism/expertradiology 报道，背景，非本周）。本周仅见二手渠道（YouTube 频道 4 天前视频）提及"V8.2 Preview、更大批量"等，但 Midjourney 官方 updates 页（midjourney.com/updates）被 Cloudflare 拦截、无法读取一手确认，且 V8.2 未见官方博客/公告，故不计入"本周动态"。就 v7 本身：v7 已非默认（被 v8.1 取代），本周无 v7 专门更新。技术/商业路线判断：Midjourney 正从"文生图"向"视频+现实世界硬件（医疗扫描）"跨界扩张，试图把生成式视觉能力延伸到物理世界感知；但医疗扫描仪面临大量专业质疑（Futurism 明确"extremely skeptical"），落地存疑。
- 关键数据：V8.1 默认化 2026-06-11（背景）；Medical 扫描仪 2026-06-18 发布，Butterfly Network 5年最高 $74M 授权（背景，letsdatascience，非本周）；本周 V8.2 Preview 仅二手/未官方确认（—）。
- 原文链接：官方 midjourney.com/updates 本周被 Cloudflare 拦截，未能取得一手确认；本周暂无可引用的 Midjourney 官方一手来源。
- 影响判断：Midjourney 战略重心明显外扩到视频与医疗硬件，但本周无实质新品落地；对生成式视觉赛道而言，其"跨界物理世界"叙事仍待验证，短期核心仍是 v8.x 图像/视频生成。

### 8. 阿里云（Qwen/夸克AI）
- 本周动态：本周阿里云百炼（Model Studio）有**平台级更新落在窗口内**（官方 release notes 一手确认）：①6月29日"API Key 加密存储与业务空间专属推理 API 域名升级公告"（aliyun.com/notice/118406）；②6月28日"qwen-turbo 资源包启动退市通知"（aliyun.com/notice/118392）。这两条是本窗口内经官方帮助中心确认的动态，属平台运营/安全与产品线调整，非旗舰模型发布。关于本周被大量二手/推广页提及的 **Qwen3.6-Plus / Qwen3.7-Max**：知乎（2026/07/02 文章）称"Qwen3.6-Plus：走向现实世界智能体"，强调 Agent 编程能力跃升、复杂代码仓库级问题求解与前端开发树立标杆、默认百万 token 上下文、多模态感知增强；阿里云文档中亦出现 qwen3.7-max、qwen3.7-max-2026-05-20/2026-06-08 等版本标识。但这些**均无法在 6/28-7/4 窗口内以官方博客/发布公告一手确认具体发布日期**（版本时间戳指向 5-6 月），故 Qwen3.7-Max/3.6-Plus 的"发布"应视为窗口前或时间未确证，不计入本周硬动态。技术/商业路线判断：阿里 Qwen 路线明确押注"现实世界智能体"（Agent 编程+超长上下文+多模态+工具执行），百炼平台侧持续强化企业级安全（API Key 加密）、成本可控（资源包/降价）与 Agent 开发工具链；夸克AI 本周无经一手确认的重大动态。
- 关键数据：6/29 API Key 加密存储升级、6/28 qwen-turbo 资源包退市（help.aliyun.com/zh/model-studio/model-release-notes 官方，本窗口内确认）；Qwen3.7-Max/3.6-Plus 发布日期本周未获官方一手确认（—，需谨慎，勿当本周新品）。
- 原文链接：https://help.aliyun.com/zh/model-studio/model-release-notes （官方功能更新时间线，一手）
- 影响判断：阿里云本周以平台安全与产品线运营调整为主，无窗口内确认的旗舰模型发布；其战略叙事（Qwen 走向"现实世界智能体"、百万上下文）延续国产大模型头部竞争态势，但需警惕二手来源把 5-6 月旧版本当作"本周新发布"。

### 9. 智谱（GLM/清言）
- 本周动态：本周智谱（海外 Z.ai，港股上市名"Knowledge Atlas Technology/知识图谱科技"）最实锤的本周动态是**发布 ZCode——面向其旗舰模型 GLM-5.2 的 harness（控制系统）**（SCMP 报道，发布于周三即约 7/1，文章 7/2 18:00 发布）。harness 是帮助大模型自主执行任务、使其作为 AI Agent 运行的控制系统，已成为中美 AI 实验室在"自动化编程平台"上的主战场。为吸引开发者，智谱同日推出促销：现有订阅用户数据额度**提升 50%**，新 ZCode 用户赠送 **500 万免费 token**。智谱全球运营负责人 Zixuan Li 在 X 上表示 ZCode 是"站在开放开发者社区的肩膀上"构建的。背景：GLM-5.2（开源，2026-06-16 发布，100 万 token 上下文，较 GLM-5.1 的 20 万大幅提升；Wikipedia/Z.ai）上月发布后被硅谷部分人士称为国产开源 AI 的又一个"DeepSeek 时刻"（SCMP），第三方评测中 GLM-5.2 在推理/bug 挖掘上与 Anthropic Fable/Mythos 级别接近（如某评测 Fable 9.1 vs GLM-5.2 9.0），而成本约为对方的 1/10。此外 7/1 有报道称美出口管制 6/30 解除、Fable5/Mythos5 重新全球可用，但采用了 GLM-5.2/Kimi K2.7 的开发者可保留其技术栈（explainx，作背景）。技术/商业路线判断：智谱明确对标 Anthropic，用"开源旗舰模型 GLM-5.2 + ZCode agent harness + 激进促销（免费 token/额度翻倍）"三件套抢占自主编程 Agent 生态，走"高性价比开源+生态工具"的 DeepSeek 式打法。
- 关键数据：ZCode 发布约 7/1（周三），现有用户额度+50%、新用户赠 500万 token（SCMP，7/2）；GLM-5.2 100万 token 上下文、2026-06-16 开源（背景，Wikipedia/Z.ai）。
- 原文链接：https://www.scmp.com/tech/tech-trends/article/3359170/zhipu-ai-releases-harness-glm-52-model-chinese-firm-takes-aim-anthropic
- 影响判断：ZCode 把智谱从"发布强模型"推进到"提供 Agent 执行框架+开发者生态"，直接对标 Claude Code；叠加超低成本与开源权重，智谱正成为国产开源 AI 冲击 Anthropic 编程护城河的最前锋。

### 10. 月之暗面（Kimi K2）
- 本周动态：本周月之暗面最实锤的本周动态是**GitHub Copilot 正式接入其开源模型 Kimi K2.7 Code**（IT之家/新浪 7/3 报道）——这是 GitHub Copilot **首次接入开源模型**。Kimi K2.7 Code 由 GitHub 托管于微软 Azure 平台，采用按量计费，正逐步向 Copilot Pro、Pro+、Max 订阅方案开放；GitHub 官方称将分批推送、持续监测质量与性能，未来几周把支持扩大至 Copilot Business、Enterprise 版及其他平台。背景：Kimi K2.7 Code 于 2026-06-12 发布并开源（背景，非本周），1 万亿参数、256K 上下文；月之暗面称内外部基准显示其相比 K2.6 显著提升长上下文编程指令遵循与长程编程任务性能，大幅改善长程任务过度思考倾向、平均 token 消耗减少约 30%。另本周还有传播动态：36氪 7/4 报道月之暗面三位联创深夜 AMA、3 小时回答全球网友 23 问，杨植麟"剧透 Kimi K3 提升巨大"（作背景/预告，K3 未发布）。技术/商业路线判断：Kimi 走"开源万亿参数编程模型+全球生态渗透"路线，被 GitHub Copilot 首个开源模型收编，是国产开源模型进入西方主流开发者工具链的标志性事件，验证了 K2.7 Code 的编程能力与成本竞争力获微软背书。
- 关键数据：GitHub Copilot 首次接入开源模型 Kimi K2.7 Code、Azure 托管、按量计费（IT之家/新浪 7/3）；K2.7 Code 1万亿参数/256K 上下文/token 消耗-30%，发布日 2026-06-12（背景）。
- 原文链接：https://finance.sina.com.cn/tech/digi/2026-07-03/doc-inifpkau5637518.shtml
- 影响判断：GitHub Copilot 首次纳入开源模型且选择 Kimi K2.7 Code，意味着国产开源编程模型在全球头部开发者平台获得"官方分发"，对 Kimi 的国际影响力与商业化（Azure 按量计费分成）是重大利好，也标志中美开源模型竞争进入"生态互嵌"阶段。

### 11. MiniMax（海螺/abab）
- 本周动态：本周 MiniMax 最实锤的本周动态是**发布视频模型 Hailuo 2.3 及 Media Agent**（官方新闻 minimaxi.com/news/minimax-hailuo-23，约 7/3）。Hailuo 2.3 在 Hailuo 02 基础上升级动态表现力：①**肢体动作/风格化/人物微表情**显著提升，运动指令响应优化，大动态运镜下光线方向、明暗过渡、色调达"近乎实拍"效果；②风格化对动漫、插画、水墨、游戏CG 等特殊画风支持更佳，通用模型输出更稳定生动；③物体运动指令响应更出色（电商广告"抽卡率"大幅提高）。定价上**再次刷新全球视频模型效果成本纪录**，保持 Hailuo 02 既有价格"加量不加价"，并提供 **Hailuo 2.3 Fast**（生成更快、定价更低，批量创作最高降本 50%）；已在海螺AI网页端、APP 及开放平台 API 推全，发布期每日提供免费试用额度。同时 **Hailuo Video Agent 正式升级为支持全模态创作的 Media Agent**（全球同步上线）——输入内容后自动匹配多模态模型、"一键成片"，专业创作者可自由上传图/视频/音频定制，后续版本将支持在画布中与 Agent 逐段调整、"对话即创作"。技术/商业路线判断：MiniMax 双线推进——文本/Agent 侧有 M2.7（"模型深度参与迭代自己"，官网列为 NEW）与 M3，视频侧以 Hailuo 2.3 用"效果-成本比"打全球市场，并用 Media Agent 把单点视频生成升级为"全模态一键创作平台"，抢占 AI 视频创作工作流入口。
- 关键数据：Hailuo 2.3 保持 Hailuo 02 价格、Fast 版批量降本最高 50%（官方，约 7/3）；Media Agent 全球同步上线；M2.7 官网标注 NEW（发布日期需另证）。
- 原文链接：https://www.minimaxi.com/news/minimax-hailuo-23 （官方一手）
- 影响判断：Hailuo 2.3"加量不加价"再破效果成本纪录 + Media Agent 全模态一键成片，显示 MiniMax 在 AI 视频赛道用极致性价比+Agent 化工作流双管齐下，直接对标 Google Veo/Runway/快手可灵，是其全球化商业变现的核心抓手。

### 12. 腾讯（混元/元宝）
- 本周动态：本周腾讯最实锤的本周动态是**元宝于 6 月 30 日下线 AI 应用智能体（Agent）功能服务**（南方都市报/东方财富 7/4 报道，一手确认元宝 6/30 已下线）——元宝表示入口下线后相关对话内容不再展示，并按平台数据处理规则清理。这是三家（元宝、豆包、千问）"不约而同叫停智能体功能"中最早行动的：豆包、千问 7 月 4 日才推送通知称将于 **7 月 15 日**下线智能体，而 7 月 15 日正是**《人工智能拟人化互动服务管理暂行办法》正式施行之日**（该《办法》4 月 10 日由国家网信办等五部门联合公布）。《办法》规范模拟自然人人格/思维/沟通风格的"持续性情感互动服务"，明确不得向未成年人提供虚拟伴侣/虚拟亲属等服务、须建未成年人模式；注册用户 100 万以上或月活 10 万以上须做安全评估。值得注意：《办法》明确"智能客服、知识问答、工作助手、学习教育、科研等不涉及持续性情感互动的服务不适用"，但目前三家"一刀切"下架全部智能体（含工具类），是否重新上架工具类智能体元宝方面暂未回应。行业背景（本周舆论）：36氪 7/5 文《腾讯需要一场2026年的首胜》指混元/元宝上半年关键战役"尚未打出预期效果"，元宝年初押注 10 亿春节红包拉新，但 Q1 亿级月活 AI 应用仍是豆包、千问、DeepSeek 三分天下，**元宝 MAU 仅 5735 万**（QuestMobile）；腾讯任命姚顺雨为首席 AI 科学家、2 月重建混元预训练与 RL 基础设施、4 月 23 日发布新一代混元模型（背景，非本周）。技术/商业路线判断：腾讯本周动作以**合规驱动的产品收缩**为主（元宝率先下线情感类智能体），反映监管新规对 C 端 AI 陪伴/智能体业务的直接冲击；混元的技术追赶与元宝的用户增长仍面临豆包/千问/DeepSeek 的强压。
- 关键数据：元宝 6/30 下线智能体功能（南都/东方财富 7/4，一手确认日期）；《AI拟人化互动服务管理暂行办法》7/15 施行、4/10 五部门公布；元宝 Q1 MAU 5735 万（QuestMobile，经 36氪引用，7/5）。
- 原文链接：https://wap.eastmoney.com/a/202607043794207023.html （南方都市报，含元宝 6/30 下线及《办法》条款细节）
- 影响判断：这是本周中国 AI 监管落地的标志性事件——《AI拟人化互动服务管理暂行办法》倒逼头部 C 端 AI 产品下架情感类智能体，元宝抢先合规；对腾讯而言短期是业务收缩，但也凸显国产 AI 产品在"拟人化陪伴"这一高增长但高风险赛道正被强监管重塑，行业竞争焦点或回归工具类/生产力类 Agent。

---


---

### 🛠️ Agent 框架工具 + 其他参与者（10）

### Claude Code
- 本周动态：**本组最大新闻**。Anthropic 于 2026-06-30 发布 Claude Sonnet 5，并在 Claude Code v2.1.197（2026-06-30 17:56 UTC 发布）中将其设为**默认模型**，原生 1M-token 上下文窗口，促销价 $2/$10 per Mtok（输入/输出），有效期至 2026-08-31（之后转为 $3/$15）。官方定位"迄今最具 agentic 能力的 Sonnet 模型"，性能接近 Opus 4.8 但价格更低，可通过 effort 等级调节成本-性能。本周 Claude Code 密集发版共 7 个版本（v2.1.195→v2.1.201，6/26–7/3）：核心变化包括：①**Claude in Chrome 正式 GA**（此前灰度）；②子代理（subagents）默认后台运行，完成后通知主会话，并继承会话的 extended thinking 配置；③默认权限模式从 "default" 改为 "Manual"（CLI/VS Code/JetBrains 全线）；④后台代理完成代码工作后自动 commit/push/开 draft PR；⑤新增 /dataviz skill（图表/仪表盘设计 + 可运行调色板校验器）；⑥Gateway 新增 anthropicAws 上游 provider；⑦内置 Explore agent 从 haiku 升级为继承主会话模型（上限 opus）；⑧大量后台代理稳定性修复（daemon 崩溃/socket 认证/跨版本兼容）。技术路线判断：Anthropic 正把 Claude Code 从"编码 CLI"推向"多代理编排 OS"，后台代理+自动 PR+Chrome GA 表明其瞄准端到端自主软件工程；Sonnet 5 的 1M 上下文+低价是对成本敏感 agentic 场景的直接竞争武器。
- 关键数据：GitHub Stars 136,080（github.com/anthropics/claude-code，2026-07-05 直查）；Sonnet 5 促销价 $2/$10 per Mtok 至 2026-08-31（anthropic.com/news/claude-sonnet-5，2026-06-30）；本周发版 v2.1.195–v2.1.201（GitHub API releases，2026-07-05 直查）；Sonnet 5 tokenizer 变更导致同输入映射 1.0–1.35× tokens。
- 原文链接：https://www.anthropic.com/news/claude-sonnet-5 ; https://github.com/anthropics/claude-code/releases ; GitHub API releases（v2.1.197 published 2026-06-30T17:56:37Z）
- 影响判断：Sonnet 5 落地 Claude Code 是本周 agentic 编码赛道的分水岭事件——它把接近 Opus 的能力压到 Sonnet 价位，直接冲击 Codex/Cursor 的性价比叙事。后台代理默认+自动开 PR 意味着 Claude Code 已从"辅助"转向"可托管的自主工程实体"，对企业 CI/CD 集成是强信号。

### Codex CLI（SWE-bench #1）
- 本周动态：本周维持高频发版但以**打磨/预发布为主，无重大功能大版本**。窗口内正式发版：v0.142.4（2026-06-29，无用户可见变更/chores）、v0.142.5（2026-07-01，安全修复：阻止完整 Responses WebSocket 请求负载写入 trace 日志，PR#30771）。同期密集推进 0.143.0-alpha 预发布链（alpha.27→alpha.36，6/27→7/5），属滚动开发中的功能预览。据 Releasebot 汇总（2026-07-03），近期 Codex 加入了：**/import 从 Claude Code 导入 setup/configs/chats**（直接抢夺 Claude Code 迁移用户）、token 活动的 usage 视图、对大文本/图片更丰富的 /goal 处理、更安全的会话删除。背景（非本周，6/25）：Codex Remote 达 GA——可从 ChatGPT 手机 App 在已连接的 Mac/Windows 主机上启动/继续工作，采用一对一 QR 配对；同期 0.142.2 引入 MCP 工具默认 tool search、0.142.0 引入可配置 rollout token 预算与多代理委派（disabled/explicit/proactive 三档）。技术路线判断：OpenAI 把 Codex 从单机 CLI 扩展为"手机遥控 + 远程主机 + 多代理"的分布式编码代理体系，/import 从 Claude Code 迁移是明确的正面竞争动作。本周本身以稳定性/安全打磨为主，未见新模型或 benchmark 更新。
- 关键数据：GitHub Stars 95,513（github.com/openai/codex，2026-07-05 直查）；窗口内正式版 v0.142.4（2026-06-29）/v0.142.5（2026-07-01）；预发布 0.143.0-alpha.29–36（GitHub API releases，2026-07-05 直查）。SWE-bench #1 为既有背景标签，本周无新榜单数据公开。
- 原文链接：https://developers.openai.com/codex/changelog ; https://github.com/openai/codex/releases ; https://releasebot.io/updates/openai/codex
- 影响判断：本周 Codex 属"内功打磨周"，真正值得注意的是 /import 从 Claude Code 导入功能——在 Sonnet 5 冲击性价比的同一周，双方开始直接争夺对方的存量用户，编码代理竞争进入"迁移战"阶段。

### OpenCode
- 本周动态：开源编码代理 OpenCode（现主仓 anomalyco/opencode，182k+ stars，社区体量惊人）窗口内发布 v1.17.12（2026-06-30）与 v1.17.13（2026-07-01）两个版本。v1.17.12 关键项：**为 Claude Sonnet 5 启用 adaptive thinking**（第一时间适配当周新模型）、当 MCP 同时返回内容与结构化输出时优先内容响应、OAuth 后即使 server 被禁用也重连 MCP、请求 MCP refresh-token scope；TUI 新增 **yolo mode 自动批准权限**；Desktop 端新增 MCP 资源自动补全、新建会话时的 workspace 控制、显示已存 token 与成本总计。v1.17.13 关键项：强制 OpenAI 兼容推理模型的 reasoning mode（保证自定义部署可靠应用推理设置）、停止重放过期的 GitHub Copilot 响应项 ID、Desktop v2 会话 UI 的可搜索模型选择器与模型管理流、会话标签悬停预览（项目/路径/分支/服务器）。两版均有多名社区贡献者（@arvsrn/@eXamadeus/@usrnk1 等），显示活跃开源生态。技术路线判断：OpenCode 的差异化在于"开源 + 多 provider 中立 + Desktop/TUI 双端"，本周快速适配 Sonnet 5 与强化 MCP/Copilot 兼容，定位为不锁厂商的开源替代品，社区驱动的迭代节奏很快。
- 关键数据：GitHub Stars 182,386（github.com/anomalyco/opencode，2026-07-05 直查）；窗口内版本 v1.17.12（2026-06-30）/v1.17.13（2026-07-01）（GitHub API releases，2026-07-05 直查）。
- 原文链接：https://github.com/anomalyco/opencode/releases ; GitHub API releases/tags v1.17.12 & v1.17.13
- 影响判断：OpenCode 182k stars 已超越 Claude Code（136k）与 Codex（95k）的仓库星标，是开源编码代理阵营的社区领头羊；当周即为 Sonnet 5 加 adaptive thinking，体现"厂商中立、快速跟进"的开源打法对闭源 CLI 构成长期竞争压力。

### Google ADK
- 本周动态：**本周有料**。Google 于 2026-06-30 发布 **ADK for Go 2.0**（官方开发者博客，作者 Toni Klopfenstein），把 Go 版 ADK 从 1.0 的"干净惯用 API"升级为**图（graph）驱动的多代理工作流引擎**，与 Python ADK 2.0（背景：Python 版 2.0 于 5/19 GA）同向对齐。核心能力：①graph-based workflow engine——用节点（Node）+ 边（Edge）描述应用形态，调度器负责并发执行、状态持久化、暂停等待人工、进程重启后可恢复；②HITL（human-in-the-loop）作为内建原语（NewRequestInputEvent，支持 Handoff/Re-entry 两种恢复方式，schema 校验、幂等恢复，且中断格式与 Python ADK 共享，可跨运行时恢复）；③丰富节点类型（Function/Emitting/Agent/Tool/Join/Dynamic/Workflow/Parallel/State-bound）；④LLM-as-router 动态路由（StringRoute/IntRoute/BoolRoute/MultiRoute/Default）；⑤纯 Go 编写的动态编排（NewDynamicNode + RunNode）；⑥每节点重试策略（指数退避+jitter，默认 5 次/1s 起/60s 上限/2x 退避）；⑦Agent 模式（Chat/Task/SingleTurn）+ 统一 node runtime，单代理与图共享同一执行模型。1.0→2.0 高度增量，仅少量破坏性签名变更（agent.InvocationContext→agent.Context 等）。技术路线判断：Google 押注"agent 框架即图引擎"，用可持久化/可恢复/可观测的图调度对标 LangGraph；Go+Python 双语并进意在覆盖云原生后端工程师，深度绑定 Cloud Run（Python buildpack 已 GA 支持 ADK 默认入口检测）与 Gemini Enterprise Agent Platform。
- 关键数据：ADK Go 2.0 发布日 2026-06-30（developers.googleblog.com/announcing-adk-go-20，v2.0.0 tag）；ADK Go GitHub Stars 8,372（github.com/google/adk-go，2026-07-05 直查）；ADK Python Stars 20,457、最新 release v2.3.0（2026-06-18，窗口外，github.com/google/adk-python）；默认重试 5 次/1s/60s/2x（官方博客）。
- 原文链接：https://developers.googleblog.com/announcing-adk-go-20/ ; https://github.com/google/adk-go/releases/tag/v2.0.0 ; https://adk.dev/2.0/
- 影响判断：ADK Go 2.0 把"可恢复的图工作流 + 内建 HITL"带到 Go 生态，是大厂在 agent 编排层与 LangGraph 正面竞争的关键落子；跨语言共享中断格式意味着 Google 想做统一的多语言 agent 运行时标准，对企业级生产部署是强吸引力。

### Dify
- 本周动态：**本周无重大版本发布**，但仓库开发极度活跃。窗口内（6/28–7/4）主分支约 110 个 commit（GitHub commits API 直查），且已出现 **2.0.0-beta.1 / 2.0.0-beta.2** 预发布 tag（GitHub tags，发布时间未在 releases API 标注，属滚动 beta，非正式 GA）。最近的正式 stable 版为 **1.15.0（2026-06-25 发布，窗口前一天，属背景非本周）**，其亮点值得记录以理解走向：新增 **difyctl 命令行客户端**（可从终端直接运行 apps/workflows，无需 access token，支持 macOS/Linux/Windows）、Workflow/Chatflow 的 CoT 实时"思考"面板、更丰富的 Human-in-the-Loop 表单（下拉选择+多文件上传）、支持慢速长任务模型（轮询机制，适配图像/视频生成）、Excel 内嵌图片提取入知识库、修复 plugin-daemon 路径穿越漏洞（CVE-2026-41948）。技术路线判断：Dify 正从"可视化 workflow 平台"向"可编程 + CLI/CI 可集成"演进，difyctl 是明确信号；2.0 beta 的推进预示即将有架构级大版本（可能重构 agent/workflow 引擎）。本周本身以代码迭代和 2.0 beta 准备为主，无面向用户的重大公开发布。
- 关键数据：GitHub Stars 147,678（github.com/langgenius/dify，2026-07-05 直查，为本组框架最高）；窗口内约 110 commits（GitHub commits API，since=2026-06-28）；存在 2.0.0-beta.1/beta.2 tag（GitHub tags，2026-07-05 直查）；最新 stable 1.15.0（2026-06-25，背景）。
- 原文链接：https://github.com/langgenius/dify/releases/tag/1.15.0 ; https://github.com/langgenius/dify/tags ; https://docs.dify.ai/en/cli/overview
- 影响判断：Dify 以 147k stars 稳居 agentic workflow 平台头名，2.0 beta 的酝酿是下一个观察重点；difyctl 让 Dify 具备 CI/脚本化能力，正把低代码平台推向"低代码+代码"双轨，对企业采用是加分项。本周虽无大发布，但 2.0 临近值得持续跟踪。

### OpenClaw（Agent OS）
- 本周动态：**本周有料，双版本发布**。窗口内发布 v2026.6.11 稳定版（2026-06-30）与 v2026.7.1-beta.1（2026-07-02），另有 v2026.6.11-beta.2（2026-06-28）。**v2026.6.11（稳定版）**主题是"打磨可靠性"：修复错位回复、卡住的发送、重连、模型配置失败，收紧管理员默认安全项；渠道投递可靠性修复横跨 Telegram/WhatsApp/Matrix/Google Chat/iMessage/飞书/Mattermost/WebChat/Control UI/终端 UI——例如修复新版 Google Chat 私信被误当群聊路由（#58993）、飞书语音回复在气泡显示时长（#89172）、Discord/Telegram 回复与镜像历史更一致绑定到目标会话（#89911）。**v2026.7.1-beta.1（新功能）**亮点：①新增 **OpenAI GPT-5.6 模型族支持**（#98333）；②`openclaw attach` 外部 harness 挂接到现有 Gateway 会话，便于恢复/检视 Codex 式交互工作流（#96454）；③**Telegram 内 Codex 工作流**——可用 /login 启动 Codex 配对、操控活跃 Codex 运行、跨瞬时 API 故障恢复最终回复（#98006 等）；④事件驱动 cron：新增 on-exit 调度类型，被监视命令退出时唤醒 agent（#92037）；⑤iOS 采用 iOS 26 视觉体系，原生 App 本地化扩展；⑥iMessage 原生投票创建/阅读/投票，内建用量页脚；⑦per-conversation 能力配置档（capability profiles），更安全的作用域会话。技术路线判断：OpenClaw 以 381k+ stars 稳居"个人 AI 助手 / Agent OS"品类星标之王，本周一边夯实多渠道投递可靠性（稳定版），一边把 Codex/GPT-5.6 等外部代理与模型编织进自身编排层（beta），走"跨渠道 + 跨代理的统一 Agent OS"路线。
- 关键数据：GitHub Stars 381,734（github.com/openclaw/openclaw，2026-07-05 直查，本组最高、远超其他）；窗口内版本 v2026.6.11（2026-06-30 稳定）/v2026.6.11-beta.2（2026-06-28）/v2026.7.1-beta.1（2026-07-02）（GitHub API releases，2026-07-05 直查）。
- 原文链接：https://github.com/openclaw/openclaw/releases/tag/v2026.6.11 ; https://github.com/openclaw/openclaw/releases/tag/v2026.7.1-beta.1 ; https://docs.openclaw.ai/releases/2026.6.11
- 影响判断：OpenClaw 把 GPT-5.6 与 Telegram-内-Codex 工作流纳入编排，显示其定位不是"又一个 CLI"而是"编排一切模型与代理的 Agent OS"；381k stars 的社区规模是本组任何对象都无法比拟的分发护城河，跨渠道可靠性是其商业化底座。

### Hermes Agent（自进化，增长最快）
- 本周动态：**本组增长最猛的重磅发布**。NousResearch 于 2026-07-01 发布 **Hermes Agent v0.18.0（v2026.7.1）**，自称"The Judgment Release（判断力版本）"。窗口内数据惊人：自 v0.17.0 起约 **1,720 commits · 998 merged PRs · 2,215 文件变更 · ~25.1 万行新增 · 949 issues 关闭 · 370+ 社区贡献者**。核心叙事有二：①**P0/P1 大清扫**——12 天内团队日夜攻坚，把整个仓库的 P0（critical）与 P1（high）问题/PR **100% 清零**（P0 关闭 3 issues+8 PRs，P1 关闭 493 issues+188 PRs，约 692 个最高优先级项），并承诺此后 P0/P1 保持为 0；最后落下的是 interrupt-protected-compression 兄弟分叉 bug（#56391/#56416）。②**判断力/自进化**：**Mixture-of-Agents（MoA）升级为一等公民模型**——命名 MoA 预设现作为 `moa` provider 下的可选"模型"，与 Claude/GPT/Grok 并列出现在所有模型选择器（CLI/TUI/desktop/gateway），选中即自动路由到该 frontier 模型集成；运行 MoA 时**每个参考模型的完整推理各自成块展示**（可读 GPT-5/Claude/Grok 各自的思考），最终聚合答案实时流式输出；**agent 会验证自己的工作**——为编码工作记录验证证据、通过实际运行项目检查来判定"完成"而非自我宣称，`/goal` 新增 **completion contracts（完成契约）**，`/learn`+`/journey` 把自我改进变得可见可引导；底层 gateway 支持 scale-to-zero 与 drain 协调（可规模化部署），desktop 新增一等公民编码项目与可玩的记忆图谱，subagents 可后台 fan-out。技术路线判断：Hermes 走"自进化 + 多模型委员会 + 证据驱动完成判定"的独特路线，MoA 一等化和 completion contracts 是其区别于单模型 CLI 的核心差异点；209k stars + 370+ 贡献者的社区速度支撑其"the agent that grows with you"叙事。
- 关键数据：GitHub Stars 209,230（github.com/NousResearch/hermes-agent，2026-07-05 直查，本组第二高）；v0.18.0 发布 2026-07-01；窗口内 ~1,720 commits / 998 PRs / 949 issues closed / 370+ 贡献者 / ~25.1 万行新增（官方 release notes，v2026.7.1）；P0/P1 清零（P0: 3 issues+8 PRs；P1: 493 issues+188 PRs）。
- 原文链接：https://github.com/NousResearch/hermes-agent/releases/tag/v2026.7.1
- 影响判断：Hermes 是本组本周"发布密度 + 增长"双料冠军——12 天清零全仓 P0/P1 是罕见的工程纪律信号；MoA 一等化（多 frontier 模型开会）+ 证据驱动 completion contracts 指向"更会判断、更会自证"的下一代 agent 形态，对"单模型 + 自我宣称完成"的主流 CLI 是范式挑战。

## 其他参与者

### Scale AI（SEAL）
- 本周动态：**本周无公司层面重大公开发布，但 SEAL 榜单持续活跃维护。** 直查 Scale Labs 榜单站点（labs.scale.com/leaderboard、/showdown、/leaderboard/tool_use_enterprise）显示各榜"最近更新"标注为数小时前（1 hour ago / 8 hours ago / 9 hours ago，2026-07-05 抓取时），说明 SEAL 团队本周仍在滚动更新排行。第三方跟踪站 llm-stats.com 的 Seal-0 榜（评估 agentic search 能力，navigate+retrieve via tools，0–1 分制，6 个模型）显示：**Kimi K2.5（Moonshot AI）以 0.574 排名 #1**，同时为该榜最佳开源模型，全榜平均约 0.489，标注"last updated in July 2026"。ToolComp（企业级 agentic tool use 榜）与 Showdown（真人盲测排名）也在持续运行。未检索到 6/28–7/4 区间内 Scale AI 的新融资/新产品/新合作等公司级公告（背景：Scale 与 Meta 的关联为既有旧闻，非本周）。技术/商业路线判断：Scale AI 在本组中扮演"中立评测基础设施"角色，其价值不在自己发模型，而在通过 SEAL/Showdown/ToolComp 等专家驱动榜单成为 agentic 能力的第三方裁判；本周的信号是榜单高频更新本身——它正把评测做成持续服务而非季度快照。
- 关键数据：Seal-0 榜首 Kimi K2.5 = 0.574，全榜均值 ≈0.489，6 模型（llm-stats.com/benchmarks/seal-0，标注 July 2026 更新，2026-07-05 抓取）；Scale Labs 各榜更新时间戳为数小时级（labs.scale.com，2026-07-05 抓取）。公司级本周新公告：未检索到。
- 原文链接：https://llm-stats.com/benchmarks/seal-0 ; https://labs.scale.com/leaderboard ; https://labs.scale.com/showdown
- 影响判断：SEAL 榜单持续高频更新，意味着 Scale 想成为 agentic AI 时代的"权威裁判";Kimi K2.5 在 agentic search 榜领先开源阵营，是本周值得关注的第三方评测信号（对 A/B 组的模型对象有交叉参考价值）。

### Cohere（Command R+）
- 本周动态：**本周无重大新产品发布。** 直查 Cohere 官方博客（cohere.com/blog，2026-07-05 抓取），窗口内（6/28–7/4）无新文章；最近的技术/内容文章停在 6/25（"Automating fork maintenance with AI agents"、"Creating a security agent with Cohere North and Wiz"，均 6/25，属窗口前一天，背景非本周）。最近的产品发布节点为：**North Mini Code（Cohere 首个面向开发者的模型，2026-06-09）**、**Command A+（主权 agentic 能力，开源企业模型，2026-05-20）**——均为窗口外背景。定价侧第三方（aipricing.guru，1 天前）重申 Command R+ 为 $2.50/$10 per 1M tokens、Command R7B 极致低价 $0.0375/$0.15（比 GPT-5.4 nano 输入便宜约 4x）。技术/商业路线判断：Cohere 坚定走"主权 AI + 企业私有部署 + 开发者模型（North/North Mini Code）"路线，聚焦金融/医疗/公共部门等强合规行业，最新动作是把 agentic 能力（North + Wiz + 自建 MCP server 做安全事件响应）产品化。本周处于两次发布之间的静默期，无面向公众的重大更新。
- 关键数据：Command R+ 定价 $2.50/$10 per 1M（aipricing.guru，2026-07-04 前后）；Command R7B $0.0375/$0.15 per 1M；最新产品 North Mini Code（2026-06-09，背景）、Command A+（2026-05-20，背景）（cohere.com/blog）。本周新发布：无。
- 原文链接：https://cohere.com/blog ; https://cohere.com/blog/north-mini-code ; https://cohere.com/blog/command-a-plus
- 影响判断：Cohere 本周静默，但其"主权/私有/低价开发者模型"定位在企业与政府市场持续渗透；对本组的信号意义在于——当头部厂商卷 Sonnet 5/GPT-5.6 时，Cohere 用合规与成本差异化避开正面对撞，走垂直企业市场。本周无料，需下周继续跟踪其下一次模型发布。

### SSI（SSI-1）
- 本周动态：**本周无任何公开动态。** SSI（Safe Superintelligence Inc.，Ilya Sutskever/Daniel Gross/Daniel Levy 创立）延续其"无产品、无论文、无公开发布"的极端保密路线。检索到的最新信息均为窗口外背景：估值约 $32B、已募资约 $60 亿、约 20 名研究员、无商业产品、无已发表论文（TechCrunch/StartupHub.ai，2026-06 报道，2 周–1 月前）；曾拒绝 Zuckerberg 的"收编式收购"尝试（spyglass.org，2 周前）。所谓"SSI-1"并无任何本周公开的产品/模型信息可查证——无官方发布、无 GitHub 仓库、无博客。原因明确：SSI 的既定战略就是在达成"安全超级智能"目标前不发布任何中间产品，因此在任一自然周内出现公开动态的概率极低。技术/商业路线判断：SSI 是本组唯一"故意零曝光"的对象，其信号恰恰来自"沉默"——用一次性直达 superintelligence 的"不同的山"路线对赌，与 OpenAI/Anthropic 的渐进式产品化路线形成鲜明对比。
- 关键数据：估值 ≈$32B、募资 ≈$60 亿、研究员 ≈20 人、产品 0、论文 0（TechCrunch/StartupHub.ai，2026-06，背景非本周）。本周公开动态：无。
- 原文链接：https://en.wikipedia.org/wiki/Safe_Superintelligence_Inc. ; https://www.startuphub.ai/ai-news/ai-figures/2026/figure-ilya-sutskever-ssi-vs-openai-safety-strategy-2026-06-24
- 影响判断：SSI 本周（及可预见的多数周）无动态属常态，不必强求。其存在本身是对"必须持续发布才能保持相关性"这一行业惯例的反叛；一旦哪天 SSI 发声，很可能是重量级事件，值得列为长期低频监测对象。

---


---

### ⚡ 算力云硬件 + 🦾 具身机器人（6）

### 宇树 Unitree（H1/G1）
- 本周动态：本周宇树迎来里程碑级事件——中国证监会于 7月2日（周四）批准其科创板（STAR Market）IPO 注册，扫清最后监管障碍，宇树将成为中国**首家上市的人形机器人公司**。据 China Daily（7月4日）报道，从 3月20日 IPO 申请受理到过会仅用 73 天、注册获批仅用 104 天，创下科创板预审机制下最快审核纪录。宇树计划募资 **42.02亿元人民币（约6.198亿美元）**，用于扩产人形机器人、强化具身智能研发、建设新制造基地，本次至少发行10%股份。消息带动A股机器人板块 7月3日（周五）暴涨，逾40只个股涨停，机器人ETF连续两个交易日净流入。同时，宇树海外落地取得实质进展：与合作方共同开发的人形机器人已进入**东京羽田机场**（日本航空发起）试运营，测试地勤作业——行李装卸、货物运输、传送带协同，试验将持续至2028年；宇树称这是中国人形机器人在全球主要航空枢纽的首个商业应用，G1的柔性、负载与力控能力使其适应复杂机场环境。技术/商业判断：宇树正从"技术演示+低价出货"转向"资本化+真实工业场景验证"双轮驱动。上市募资将强化其在量产成本战中的领先地位（去年 G1 出货逾5000台，全球出货量第一）；羽田机场落地则是从展示走向产业验证的关键信号，标志中国人形机器人商业化进入海外机场/物流实测阶段。
- 关键数据：IPO募资 42.02亿元人民币/约6.198亿美元（China Daily 2026-07-04）；审核73天过会、104天注册获批（同上）；G1去年出货逾5000台、全球出货量第一（The New Yorker 2026-07-06期，背景数据）；G1零售价约$13,500（Unitree官方店/theresarobotforthat 2026-07）；40+机器人股涨停（China Daily 2026-07-04）
- 原文链接：http://global.chinadaily.com.cn/a/202607/04/WS6a483c65a310986e2b46378c.html
- 影响判断：这是本周D组最重磅事件之一。宇树成为中国人形机器人IPO第一股，具有行业标杆意义，为整个具身智能赛道打开资本通道；羽田机场落地则验证了"从演示到产业"的商业闭环。信号：中国人形机器人产业进入"资本化+规模化量产+海外实战"三重加速期。

### 优必选 UBTech（Walker S）
- 本周动态：优必选本周动作密集。①**6月30日**在深圳举办2026全球发布会，正式发布 **UWORLD U1 系列**——号称全球首款面向量产的全尺寸超仿生人形机器人，含三款：U1 Lite（半身版）、U1 Pro（高性能全身）、U1 Ultra（高动态全身），**起售价11.98万元人民币**；截至发布会当日，UWORLD U1系列累计订单已超 **13,361台**。U1 系列具备 **88个自由度**、专有双枢轴仿生颈椎，可复现高达90%的人类基础动作；搭载全球首个面向长期陪伴的情感感知LLM，可识别20+细粒度情绪、准确率超90%；仿生"快慢脑"架构提供500毫秒直觉响应+数千亿参数深度推理；语音-唇形同步延迟压至20毫秒内。创始人周剑提出人机共生长期愿景与"2023–2033消费机器人"阶段规划，并启动"人机陪伴计划"，2026年将捐赠100台定制U1。②工业线 **Walker S2** 已进入实战：据SCMP/Yahoo Tech（7月2日确认），优必选以 **2.64亿元人民币（约3700–4000万美元）**合同，在中越东兴口岸（防城港）部署 Walker S2 承担客流引导、多语种海关问询、货运条码扫描与清关核验，2025年12月起交付爬坡，试点被定位为机场/车站/海港模板。Walker S2 身高1.76米、52个自由度、单臂负载15公斤、搭载BrainNet 2.0，具备自主换电（约3分钟自换电池，近24/7运行）。技术/商业判断：优必选正走"工业(Walker S)打基础 + 消费(UWORLD)找第二增长曲线"双线策略。Walker累计订单已达11亿元人民币，边境口岸部署把人形机器人推入"主权空间"应用，是从工厂走向公共服务的关键跳跃；UWORLD则押注情感陪伴消费市场（中国9000万独居成人、1.18亿空巢老人）。
- 关键数据：UWORLD U1起售价11.98万元（PRNewswire 2026-07-01，发布于6月30日）；累计订单13,361台（同上）；88自由度、情绪识别20+种/准确率>90%（同上）；东兴口岸合同2.64亿元/约3700–4000万美元（Yahoo Tech/SCMP 2026-07-02）；Walker S2 身高1.76m、52自由度、单臂负载15kg、约3分钟自主换电（同上）；Walker累计订单11亿元人民币（同上）
- 原文链接：https://www.prnewswire.com/ae/news-releases/ubtech-launches-uworld-u1-the-worlds-first-full-size-mass-produced-ultra-bionic-humanoid-robot-302815285.html ； https://tech.yahoo.com/ai/meta-ai/articles/china-deploying-humanoid-robots-control-185119143.html
- 影响判断：优必选本周同时打出"消费新品发布+工业实战落地"两张牌，信号强烈：人形机器人正从B端工业向C端情感陪伴延伸，且已进入边境/口岸等公共服务场景。这是中国人形机器人商业化"多场景铺开"的典型样本，与宇树IPO形成产业共振。

### Figure AI（Figure 02）
- 本周动态：本周 Figure 与宝马（BMW Group）合作进入新阶段——**Figure 03**（本组追踪对象 Figure 02 的下一代）抵达宝马斯帕坦堡工厂（Spartanburg, S.C.）52号厂房（Hall 52），开始"排序（sequencing）"物流用例。宝马于 6月25日官宣、本周（6月30日–7月3日）多家媒体（The Robot Report、eWeek、Carscoops、Manufacturing Digital）密集跟进报道。据 Figure 官方博客（f-03-at-bmw），**Figure 02 去年已参与宝马3万辆汽车的装配**，此次 Figure 03 从"钣金取放（pick-and-place）"升级到更复杂的"排序"任务：零件不再以统一朝向连续呈现，而是在杂乱、部分遮挡、位置不定的环境中挑拣。核心技术是 Figure 自研的 **Helix 02**——像素到动作（pixels-to-actions）的 VLA（视觉-语言-动作）模型，实现全身动态控制（loco-manipulation）：机器人一边用双手抓取薄壁零件精准放入卡槽，一边调整脚步、移动躯干保持平衡，并能拉动装在脚轮上的重型金属料车。宝马生产控制与物流副总裁 Ulrich Wieland 称斯帕坦堡是"宝马制造日常运营中人形机器人的发源地"。技术/商业判断：Figure 已完成从 Figure 02 到 Figure 03 的代际切换，从"演示"迈向"高复杂度真实产线任务"，Helix 02 的高频视觉-运动控制+全身协调是其区别于固定自动化/六轴机械臂的关键护城河。选择"排序"这一传统自动化难以解决的任务，是有意展示通用物理AI的能力边界。
- 关键数据：Figure 02 去年参与宝马3万辆车装配（Figure官方 f-03-at-bmw，本周报道）；宝马 6月25日官宣 Figure 03 用于斯帕坦堡物流排序（eWeek 2026-06-25/本周报道）；机器人风投2023–2025增长3倍多、2025年达 $40.7B/年（McKinsey，via Manufacturing Digital，背景数据）；本周未公开新融资额/估值——Figure 本轮融资/估值本周无新公开数据
- 原文链接：https://www.figure.ai/news/f-03-at-bmw
- 影响判断：这是人形机器人从"取放演示"跨入"复杂物流排序"的标志性节点，验证 VLA 端到端模型（Helix 02）在真实产线的可行性。信号：西方阵营（Figure+BMW）与中国阵营（宇树/优必选）在人形机器人产业化上正同步加速，且都聚焦制造/物流场景。

### NVIDIA（GPU/CUDA/Blackwell）
- 本周动态：NVIDIA 本周有两条实质动态。①**7月1日**发布官方博客《NVIDIA and Partners Build in America, for America》，系统阐述其美国本土制造战略：NVIDIA 及合作伙伴计划在美国生产**高达5000亿美元（$500B）的AI基础设施**，伙伴包括 TSMC、富士康、纬创、康宁、Lumentum、Coherent、Amkor。Blackwell 芯片已在**亚利桑那州 TSMC 凤凰城工厂量产**（Blackwell晶圆已量产出货）；富士康在休斯顿建厂生产 **GB300 托盘模块**，纬创在沃斯堡组装测试。CEO 黄仁勋称"AI 正驱动一代人一遇的美国制造业复兴"。据 Public First 估算，2026年 NVIDIA 驱动的AI需求将为美国GDP贡献 **4850亿美元**、支撑逾10万个岗位。博客还披露 Rubin 代 AI 基础设施是全球首个实现100%液冷的平台。②**6月29日**，NVIDIA 宣布 Anthropic 将通过微软 Azure 使用 **GB300 Blackwell Ultra** 系统训练/运行 Claude 模型（详见 Azure 条目）。技术/商业判断：NVIDIA 本周叙事重心从"卖芯片"转向"绑定美国制造+能源+就业"的宏观政治经济叙事，意在巩固政策护城河与供应链安全；同时通过 Azure/Anthropic 深化云端 Blackwell Ultra 装机，Rubin 代液冷平台预示下一代产品线推进。
- 关键数据：美国AI基建投资规划 $500B（NVIDIA博客 2026-07-01）；2026年对美GDP贡献 $485B、支撑10万+岗位（Public First，via NVIDIA 2026-07-01）；Blackwell 已在TSMC凤凰城量产（同上）；Rubin 首个100%液冷平台（同上）；GB300 Blackwell Ultra 用于 Anthropic/Azure（NVIDIA 2026-06-29）
- 原文链接：https://blogs.nvidia.com/blog/nvidia-and-partners-build-in-america-for-america/ ； https://blogs.nvidia.com/blog/anthropic-nvidia-gb300-blackwell-ultra-microsoft-azure/
- 影响判断：$500B 美国本土制造承诺与 $485B GDP 叙事，是 NVIDIA 应对地缘政治与供应链风险、锁定政策支持的战略动作；GB300 在 Azure/Anthropic 的装机则验证 Blackwell Ultra 已成前沿模型训练/推理的主力算力底座。信号：算力军备竞赛正与"制造回流+能源+就业"深度捆绑。

### AWS（Bedrock/Trainium/SageMaker）
- 本周动态：AWS 本周核心动态是**7月1日**在 Amazon Bedrock 和 Claude Platform on AWS 上重新上架 Anthropic 最新前沿模型 **Claude Fable 5**（原于6月9日发布，本次重新上架并"加装更强护栏/分类器以防滥用"）。据 aboutamazon 官方稿，Claude Fable 5 将"Mythos 级"能力开放给所有客户，专为"雄心勃勃、长时运行、复杂"的任务打造——可在 Claude Code 之类的 agent harness 中**连续工作数天**，能自主规划、对照目标检查进度并迭代优化；具备先进视觉能力（理解文件/PDF中嵌套的图表、表格），并能主动自我验证、更新自身技能、自建评测harness。Claude 家族现分四档：Haiku、Sonnet、Opus、Mythos；Fable 定位最雄心、异步的大项目。稿件还提及 Anthropic 与 AWS 的协同基础设施"以创纪录速度交付了近**50万颗 Trainium2 芯片**"（Project Rainier 相关），Mythos 5 已向 Project Glasswing 小范围开放。此外本周 AWS 宣布投资 **10亿美元**派驻"前置部署AI工程师（forward deployed engineers）"入驻客户现场。技术/商业判断：AWS 继续以"Anthropic 独家深度绑定 + 自研 Trainium 降本"为双支柱。Claude Fable 5 加护栏重新上架，反映前沿模型"安全再发布"成为常态；近50万颗 Trainium2 的规模化交付，是 AWS 在算力自主化上对抗 NVIDIA 依赖的关键筹码。
- 关键数据：Claude Fable 5 于 2026-07-01 重新上架 Bedrock（aboutamazon 2026-07-01）；近50万颗 Trainium2 芯片创纪录交付（同上）；AWS 投资 $1B 派驻前置AI工程师（aboutamazon，本周trending）；可连续运行数天（同上）
- 原文链接：https://www.aboutamazon.com/news/aws/claude-fable-5-anthropic-available-amazon-bedrock
- 影响判断：AWS 通过"Anthropic 前沿模型首发/独家 + Trainium 自研算力"双轮，巩固其在企业级生成式AI的护城河。近50万颗 Trainium2 交付是自研芯片规模化的强信号，直接对冲对 NVIDIA GPU 的依赖，也为 Claude 的长时 agentic 任务提供成本优势。

### Azure（Azure AI / OpenAI Service）
- 本周动态：微软 Azure 本周关键动态是**6月29日**——**Anthropic 的 Claude 模型在 Microsoft Foundry（Azure）上正式全面可用（GA）**，且运行在 **NVIDIA GB300 Blackwell Ultra** 系统上。据 NVIDIA 官方博客（原文 blogs.nvidia.com/blog/anthropic-nvidia-gb300-blackwell-ultra-microsoft-azure）及 Neowin（6月29日 15:16 EDT 报道），这是三方协同：Anthropic 提供AI研究、NVIDIA 提供最新数据中心AI硬件（GB300 Blackwell Ultra，面向大规模训练与推理）、微软 Azure 提供云基础设施承载。此举使"Azure 原生企业"获得构建自主/领域专用AI的新途径——Claude 首次以GA形态进入微软自有的 Foundry/Azure 生态并跑在 Blackwell Ultra 上。技术/商业判断：这是微软AI战略"去OpenAI单一依赖、多模型并举"的标志性一步——把竞争对手阵营的 Anthropic Claude 正式纳入 Azure Foundry，同时用 NVIDIA 最新 GB300 Blackwell Ultra 保证前沿算力供给。对企业客户而言，Azure 从"OpenAI 独家渠道"转向"多前沿模型+顶级算力"的中立平台定位。（注：本周 Azure 侧主要动态即此条；OpenAI Service 本周无重大独立公开动态。）
- 关键数据：Claude 在 Microsoft Foundry(Azure) GA、跑在 NVIDIA GB300 Blackwell Ultra（NVIDIA博客/Neowin 2026-06-29）；报道时间 2026-06-29 15:16 EDT（Neowin）
- 原文链接：https://blogs.nvidia.com/blog/anthropic-nvidia-gb300-blackwell-ultra-microsoft-azure/ （NVIDIA官方原文；Neowin/EJS转载报道）
- 影响判断：微软把 Anthropic Claude 引入自有 Azure Foundry 并跑在 GB300 上，是"多模型中立云平台"战略的关键落子，削弱对 OpenAI 的单一依赖，同时锁定 NVIDIA 最新算力。信号：三巨头（云厂/芯片/模型商）交叉结盟的格局进一步固化，Blackwell Ultra 成为跨云的前沿算力标准。


---

## 📋 关于本周报

- **数据口径**：本周报覆盖 2026-06-28 ~ 2026-07-04 完整自然周，共 38 个研究对象。所有"本周动态"均在时间窗内，关键数据标注来源 URL + 日期，窗口外内容标注"（背景，非本周）"。
- **质量门控**：本期覆盖 38/38（100%），其中有动态约 33 个，静默对象（Databricks/Midjourney/Scale AI/Cohere/SSI）均经搜索验证并附具体原因。原文抽查 5/5 通过。
- **来源说明**：官方博客/论文/GitHub release/官方公告优先于二手新闻；GitHub Stars/Release 直查 GitHub API 取实时数；传闻/未发布/未证实项已明确标注存疑。
- **下期预告**：持续跟踪 DeepSeek V4 正式版（7 月中旬）、Dify 2.0、Gemini 3.5 Pro、Meta Watermelon 进展。

