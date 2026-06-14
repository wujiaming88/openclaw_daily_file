# 全球 AI 动态周报 · 第 3 期（2026-06-07 ~ 06-13）

> **覆盖区间**：2026-06-07（周日）00:00 → 2026-06-13（周六）24:00（上海时区）的完整自然周
> **覆盖范围**：38 个研究对象 / 6 大赛道 / 50+ 信息源
> **时间窗声明**：本报告仅收录上述区间内的真实动态；区间外信息仅作背景并标注"（背景，非本周）"。

---

## 本周一句话

> **本周主线：AI 正式从"商业产品"跨入"战略管制物项"——Anthropic 顶级模型 Claude Fable 5（Mythos 级）发布即遭美国政府出口管制暂停；与此同时，竞争维度全面从"模型智能"转向"分发渠道、Agent 编排与商业化"，国产编程模型进入周级贴身肉搏，资本面 OpenAI 秘密递交 S-1。**

---

## 🔥 本周 TOP 5

### 1. Anthropic 发布 Claude Fable 5（Mythos 级），48 小时内遭美国政府出口管制暂停 ｜ 2026-06-09 / 06-12

6 月 9 日，Anthropic 向公众开放 **Fable 5**——其全新顶级 "Mythos class" 中首个广泛可用的模型，能力定位高于 Opus class，官方称"超过此前任何公开发布的模型"，默认含 1M 上下文，主打写代码与调试、复杂研究问答、图像分析。同时向已有访问权限的企业/机构（含 Project Glasswing 网络安全合作伙伴）提供不受限版本 **Claude Mythos 5**，该精选群体 6 月初已扩展至 15+ 国约 200 家组织。Anthropic 以网络安全为由限制 Mythos——称其能快速识别银行平台、电网等关键基础设施漏洞，大多数网络安全/生化类查询会被路由至较低层模型 Opus 4.8。**转折点出现在 6 月 12 日：美国政府发布出口管制指令（export control directive），暂停所有对 Fable 5 与 Mythos 5 的访问。** 白宫已建立"发布前测试最强模型"机制，Mythos 5 与美国政府合作部署。

↳ **为什么重要**：这是本周乃至本季度最具信号意义的事件——前沿模型首次被纳入国家出口管制框架，AI 从商业产品正式跨入战略管制物项。"能力越强、监管摩擦越大"的悖论开始显性化，将深刻影响所有前沿实验室的发布策略。

[The Guardian 报道](https://www.theguardian.com/technology/2026/jun/09/anthropic-claude-mythos-ai-model) ｜ [Anthropic Newsroom](https://www.anthropic.com/news)

### 2. OpenAI 秘密递交 S-1 + 收购 Ona，Codex 周活破 500 万同比 +400% ｜ 2026-06-08 / 06-11

6 月 8 日 OpenAI 公告称已**向 SEC 秘密递交 S-1 招股书草案**（援引 1933 年证券法 Rule 135），措辞极坦诚："We recently submitted a confidential S-1. We expect it to leak so we're just announcing it." 尚未定 IPO 时点但保留尽早上市选项。6 月 11 日宣布**收购云端开发平台 Ona**，并入 Codex 生态——官方数据：Codex 每周活跃用户超 **500 万**，较年初增长 **400%**；Ona 此前已服务 200 万开发者的安全可复现云环境。收购意图是让 Codex agent 摆脱"绑定单台设备/单次会话"的限制，在客户云中持续运行数小时至数天。同期还宣布企业可通过 Oracle 云承诺额度访问 OpenAI 模型与 Codex。

↳ **为什么重要**：S-1 递交是 OpenAI 迈向 IPO 的实质性一步，将重塑整个行业的资本预期；Ona 收购 + Oracle 分销标志竞争焦点从"模型能力"转向"agent 在企业生产环境的持久化部署与治理"。

[OpenAI 递交 S-1 公告](https://openai.com/index/openai-submits-confidential-s-1/) ｜ [收购 Ona 公告](https://openai.com/index/openai-to-acquire-ona/)

### 3. 国产编程旗舰周级肉搏：智谱 GLM-5.2、月之暗面 Kimi K2.7 Code、阿里 Qwen3.7-Max 多模态 ｜ 2026-06-10 ~ 06-13

中国三家头部几乎同周密集发布编程/智能体旗舰：①**智谱 GLM-5.2**（6/13 全量开放，API 与开源"下周上线、MIT 协议"）面向 Agentic Engineering，强调"真正可用的 1M 上下文"；②**月之暗面 Kimi K2.7 Code**（6/12 开源）参数 1.1T、256K 上下文，最大亮点是 **Token 消耗直降约 30%**，标准输入/输出 6.5/27 元/M，6 倍速高速版下周一上线；③**阿里 Qwen3.7-Max**（6/10 上线 qwen3.7-max-2026-06-08 快照）从纯文本旗舰升级为**具备视觉理解的多模态混合智能体**，可感知真实世界场景、操作 GUI。

↳ **为什么重要**：国产编程模型竞赛已白热化到以周计，均押注"长上下文（1M）+ Agentic Coding + 开源/降本"，正面争夺 Coding Agent 工具链（Claude Code、OpenCode、Cline）的默认模型位置。

[智谱 GLM-5.2](https://www.aihub.cn/news/zhipu-glm-5-2/) ｜ [Kimi K2.7 Code](https://www.oschina.net/news/457565) ｜ [阿里云模型上新](https://help.aliyun.com/zh/model-studio/newly-released-models)

### 4. xAI Grok V9-Medium（1.5 万亿参数）推入 Tesla 车队与 X，"分发飞轮"正式转动 ｜ 2026-06-10

Elon Musk 于 6 月 5 日宣布 **Grok V9-Medium 完成训练**，参数规模 **1.5 万亿**，约为当前生产模型 v8-small（约 5000 亿）的 3 倍，公开发布目标定在 6 月中旬。6 月 10 日报道，xAI 已开始将 Grok V9-Medium 推入 Tesla 车队与 X 社交网络——Musk 构建多年的"垂直整合分发飞轮"正式转动：可同时把新模型直推数亿 X 账号与数百万联网 Tesla（Grok 是车内 AI 助手，并不驱动车辆，FSD 仍独立）。配套发布 Grok Voice 与 Grok Imagine 1.5 图像生成预览。

↳ **为什么重要**：当模型能力趋同，分发渠道成为决定性变量。xAI 借 X+Tesla 双渠道一次性触达数亿终端的能力，是 OpenAI/Google 通过 app 与云合作所不具备的结构性护城河。

[TechTimes 报道](https://www.techtimes.com/articles/318165/20260610/grok-v9-rolls-tesla-cars-x-why-musks-distribution-flywheel-worries-ai-rivals.htm)

### 5. 优必选 U1 消费级人形机器人 8 天小订破 3000 台，验证 C 端情感陪伴拐点 ｜ 2026-06-09

优必选旗下消费级品牌"优世界（UWORLD）"首款全尺寸超仿生人形机器人 **U1 系列**在京东开启预售仅 8 天，小订（定金锁单）数量突破 **3000 台**——而 2025 年优必选全尺寸人形全年累计销量仅 1079 台，C 端预订量已是全年 B 端销量近 3 倍。U1 分男/女款（男款 183cm/42kg、女款 168cm/35.2kg），均搭载 88 个自由度关节、续航 2–4 小时，定位情感陪伴，将搭载"养成系情感大模型"、本地加密存储记忆。

↳ **为什么重要**：3000 台小订是行业首个规模化的 C 端人形需求验证，标志人形机器人商业模式从重资产工业交付向高毛利消费市场延伸的拐点。

[盖世汽车报道](https://m.gasgoo.com/news/70461292.html)

---

## 🧭 三条主线趋势

**① AI 跨入"战略管制物项"，监管开始直接介入前沿模型发布节奏。** Anthropic 的 Fable 5 / Mythos 5 因网络安全能力遭美国政府 6 月 12 日出口管制暂停，是前沿模型首次被纳入国家出口管制框架。白宫"发布前测试最强模型"机制、DeepSeek"美企直接向中国平台发数据"引发的数据主权担忧，共同指向同一拐点：模型能力越接近国家安全边界，监管摩擦越大，发布策略将被重塑。

**② 竞争维度从"模型智能"转向"分发渠道 + Agent 编排 + 单位成本"。** 模型能力趋同（Meta Muse Spark 52 vs GPT-5.5 60 vs Claude ~61，差距收窄）后，xAI 的 X+Tesla 飞轮、字节 2 亿 DAU、腾讯微信全量小程序 AI 化、Microsoft 的 M365 嵌入，证明"谁能触达用户"比"谁最聪明"更具护城河价值；与此同时 Cognition（ACP 调度中枢）、Glean（知识图谱 + MCP Gateway）、Claude Code（子代理 5 层嵌套）、Codex（"从 Claude Code 迁移"抢用户）共同把战场推向"多 Agent 编排 + 模型迁移战争"。

**③ 云厂商与具身机器人深度绑定，"自研硅 + 多模型货架 + 物理 AI 延伸"成三巨头共识。** AWS（Trainium/Inferentia/Graviton5 下沉托管层 + Bedrock 集齐 OpenAI/Anthropic）、Azure（Claude Fable 5 上 Foundry + 自研 MAI）、NVIDIA（Blackwell 生态外溢到 robotaxi/本地/工作站）三家不约而同；而 NVIDIA Isaac GR00T 正成为宇树 H2 Plus、Figure 等全球人形机器人的共同算力底座，算力云与具身智能的交汇加深。

---

## 📚 赛道深度正文

> 以下为 38 个研究对象的完整深度笔记，按赛道分组。已进 TOP 5 的对象标注"详见 TOP 5"。


### 🧠 大模型基座

### OpenAI（GPT-5/ChatGPT/Codex）
- 本周动态：本周OpenAI公司层面动作密集。①6月8日OpenAI发布公告称已**向SEC秘密递交S-1招股书草案**（draft S-1），援引1933年证券法Rule 135。原文措辞极坦诚："We recently submitted a confidential S-1. We expect it to leak so we're just announcing it."——尚未定IPO时点，称作为私有公司更易推进部分事项，但保留尽早上市的选项。这是OpenAI走向公开市场的关键信号。②6月11日宣布**收购云端开发平台Ona（ona.com）**，将其安全云执行与编排技术并入Codex生态。原文数据：Codex每周活跃用户超**500万**，较今年早些时候增长**400%**；Ona此前已服务**200万**开发者的安全可复现云环境。收购意图是让Codex agent摆脱"绑定单台设备/单次会话"的限制，在客户云中持续运行数小时至数天。③6月10日宣布企业可**通过Oracle云承诺额度（Oracle cloud commitment）访问OpenAI模型与Codex**。④Codex app 26.609（6月11日）上线：Plus/Pro用户rate-limit重置银行、Chrome/内置浏览器Developer mode（CDP访问）、/init命令、Computer Use扩展至EEA/UK/瑞士以外企业用户、Browser use速度提升至2倍。⑤6月8日推出OpenAI Economic Research Exchange及"Built to benefit everyone"治理计划，6月12日上新OpenAI Academy课程。技术/商业判断：本周OpenAI主线是**资本化（S-1）+ Codex agent生产化（Ona收购+Oracle分销+持久化执行环境）**，模型层无新基座发布，重心明显转向把agentic能力变成可在企业生产环境长时运行的商业产品。
- 关键数据：Codex周活>500万、同比+400%（https://openai.com/index/openai-to-acquire-ona/ ，2026-06-11）；Ona累计服务200万开发者（同上）；秘密递交S-1（https://openai.com/index/openai-submits-confidential-s-1/ ，2026-06-08）
- 原文链接：https://openai.com/index/openai-submits-confidential-s-1/ ；https://openai.com/index/openai-to-acquire-ona/ ；https://developers.openai.com/codex/changelog ；https://openai.com/news/
- 影响判断：S-1递交是OpenAI迈向IPO的实质性一步，将重塑整个行业的资本预期；Ona收购+Oracle分销标志着竞争焦点从"模型能力"转向"agent在企业生产环境的持久化部署与治理"，这是2026年大模型商业化的核心拐点。

### Google DeepMind（Gemini/Gemma）
- 本周动态：本周Google无新基座模型发布，动作集中在产品线生命周期管理与旧版收敛。①Gemini for Google Cloud发布公告（约6月9日）：Gemini Code Assist IDE扩展与Gemini CLI将于**2026年6月18日**起停止为个人版、Google AI Pro、Google AI Ultra层级服务请求——意味着免费/个人开发者层的CLI/IDE接入被收紧。②Gemini Enterprise公告：**Gemini 3.5 Flash的功能管理开关在2026年6月8日后不再可用**，推动用户迁移至更新版本。③背景（非本周）：Gemini仍稳居3.x代（3月3日发布Gemini 3.1 Flash Lite，4月2日发布面向高级推理与agentic工作流的Gemma 4）；Polymarket预测市场显示截至6月中旬Gemini仍未进入4.0代。技术/商业判断：Google本周处于**两代之间的过渡期**——3.x家族进入收敛/淘汰旧版阶段，Gemini 4.0尚未落地。收紧个人层CLI/IDE接入反映其将免费资源向付费企业层倾斜的商业策略。整体本周属"维护性动作"，无重大技术信号。
- 关键数据：Gemini Code Assist个人/Pro/Ultra层CLI停服日2026-06-18（https://docs.cloud.google.com/gemini/docs/release-notes ）；Gemini 3.5 Flash开关6-08后下线（https://docs.cloud.google.com/gemini/enterprise/docs/release-notes ）
- 原文链接：https://docs.cloud.google.com/gemini/docs/release-notes ；https://docs.cloud.google.com/gemini/enterprise/docs/release-notes ；https://en.wikipedia.org/wiki/Gemini_(language_model)
- 影响判断：本周Google无重大基座动态，但旧版收敛+个人层接入收紧透露其商业化重心转向企业付费层；市场对Gemini 4.0的预期仍在累积，是下半年关键观察点。

### Anthropic（Claude Opus/Sonnet）
- 本周动态：本周Anthropic是A组最大新闻源。①6月9日（周二）正式向公众开放**Fable 5**——其全新顶级"Mythos class"中首个广泛可用的模型，定位高于Opus class。Mythos class于4月首次披露但因网络安全顾虑仅限少数合作机构数月。Fable 5主打：写代码与调试、复杂研究问答、图像分析。②同时向已有访问权限的企业/机构（含Project Glasswing网络安全合作伙伴）提供不受限版本**Claude Mythos 5**；该精选群体6月初已扩展至**15+国约200家组织**。Anthropic以网络安全为由限制Mythos——称其能快速识别银行平台、电网等关键基础设施漏洞。③重大监管事件：**6月12日美国政府发布出口管制指令（export control directive），暂停所有对Fable 5与Mythos 5的访问**（来源：Anthropic官网newsroom 6-12）。④安全机制细节：Fable 5上大多数网络安全/生物化学类查询将被路由至较低层模型**Opus 4.8**（5月底公开）；Anthropic还称发现威权国家大规模尝试蒸馏其技术训练竞品，此类查询也降级。⑤白宫已建立"发布前测试最强模型"机制，Mythos 5与美国政府合作部署。技术/商业判断：Anthropic新建**Mythos>Opus**的能力层级，把前沿能力与国家安全深度绑定，是"模型即受控战略资产"的范式标志；但6月12日的出口管制暂停意味着其商业化节奏被监管强力介入打断。
- 关键数据：Mythos class访问扩至15+国约200家组织（https://www.theguardian.com/technology/2026/jun/09/anthropic-claude-mythos-ai-model ，2026-06-09）；6-12美政府出口管制暂停Fable5/Mythos5（https://www.anthropic.com/news ，2026-06-12）；Opus 4.8 5月底公开
- 原文链接：https://www.theguardian.com/technology/2026/jun/09/anthropic-claude-mythos-ai-model ；https://www.anthropic.com/news
- 影响判断：这是本周乃至本季度最具信号意义的事件——前沿模型首次被纳入国家出口管制框架，AI从"商业产品"正式跨入"战略管制物项"。能力越强、监管摩擦越大的悖论开始显性化，将深刻影响所有前沿实验室的发布策略。

### Meta AI（Llama 4）
- 本周动态：本周Meta的核心信号是**Llama谱系正式被取代**。①6月8日，Meta宣布**Muse Spark已在其大部分智能眼镜上取代Llama 4驱动Meta AI**。Muse Spark是Meta Superintelligence Labs（MSL，扎克伯格去年豪掷数十亿美元高薪挖人组建的部门）公开发布的首个模型，于4月首次宣布（背景，非本周）。关键定性：Muse系列**继承（succeeds）Llama系列**；Llama为开源，Muse Spark**不开源**（但称"希望未来版本开源"）。Meta直言Llama已显著落后于OpenAI(GPT)、Google(Gemini)、Anthropic(Claude)、xAI(Grok)，正是这一失败促使扎克伯格裁撤Llama团队并启动巨额挖人。②性能数据：Muse Spark在Artificial Analysis Intelligence Index得分**52**（对比Gemini 3.1 Pro 57、GPT-5.5 60、Claude约61）；Meta称其以**1/10算力**匹配前最强模型Llama 4 Maverick的性能，主打"小而快"、智能眼镜上的即时响应。③6月10日，**Reliance Industries与Meta合作在印度推出基于Llama模型的企业AI解决方案**，覆盖销售、IT、客服等场景。技术/商业判断：Meta战略性放弃"开源Llama"旗帜转向闭源Muse，承认在前沿竞赛中掉队并重金重建；"小而快+端侧（眼镜）"是其差异化突围口，但绝对智能水平（52分）仍落后第一梯队约8-9分。
- 关键数据：Muse Spark AA Intelligence Index 52分 vs GPT-5.5 60/Claude~61（https://www.uploadvr.com/meta-muse-spark-ai-model-replaces-llama-on-smart-glasses/ ，2026-06-08）；1/10算力匹配Llama 4 Maverick（同上）
- 原文链接：https://www.uploadvr.com/meta-muse-spark-ai-model-replaces-llama-on-smart-glasses/ ；https://www.newsbytesapp.com/news/business/reliance-industries-meta-launch-llama-enterprise-ai-in-india/tldr
- 影响判断：Meta放弃开源旗舰、用闭源Muse取代Llama，是开源大模型阵营的重大挫折，可能改变行业开源/闭源力量对比；同时印证"端侧小模型+硬件分发"成为落后者差异化生存的路径。

### xAI（Grok）
- 本周动态：本周xAI是发布节奏最猛的一家。①Elon Musk于**6月5日**宣布**Grok V9-Medium完成训练**，参数规模**1.5万亿**，约为当前生产模型v8-small（约5000亿参数）的3倍；公开发布目标定在**6月中旬**。②6月10日报道，xAI已开始将Grok V9-Medium**推入Tesla车队与X社交网络**——Musk构建多年的"垂直整合分发飞轮"正式转动：可同时把新模型直推数亿X账号与数百万联网Tesla，这是OpenAI/Google通过app与云合作触达用户所不具备的分发优势。需厘清：Grok是车内AI助手（"Hey, Grok"语音交互、对话查询、自然语言导航），**并不驱动车辆**，Tesla FSD仍是独立系统。③配套发布：**Grok Voice**（语音交互）、**Grok Imagine 1.5**图像生成预览（经API）。④任命SpaceX Starlink资深经理Jack Garabedian领导Grok数据标注。⑤API当前生产模型为**grok-4.3**（x.ai官网）。技术/商业判断：xAI的核心竞争壁垒不在绝对智能，而在**Musk生态的独家分发渠道（X+Tesla）**——这是竞品最难复制的护城河；1.5T参数的3倍跃升预示推理/编码/多模态能力上限大幅提升。
- 关键数据：Grok V9-Medium 1.5万亿参数、6-05完成训练、6月中发布（https://www.techtimes.com/articles/318165/20260610/grok-v9-rolls-tesla-cars-x-why-musks-distribution-flywheel-worries-ai-rivals.htm ，2026-06-10）；v8-small约5000亿参数（同上）；API当前grok-4.3（https://x.ai/ ）
- 原文链接：https://www.techtimes.com/articles/318165/20260610/grok-v9-rolls-tesla-cars-x-why-musks-distribution-flywheel-worries-ai-rivals.htm ；https://x.ai/
- 影响判断：Grok V9借X+Tesla双渠道一次性触达数亿终端，是AI分发模式的范式级威胁；当模型能力趋同，分发渠道成为决定性变量，这是Musk生态对所有纯模型公司的结构性压制。

### Microsoft（Copilot/Azure AI/Phi）
- 本周动态：本周Microsoft有正反两面信号。①负面：**Copilot本月第二次大规模宕机**——6月11日业务高峰期，一次故障的软件部署切断了连接Copilot前端与Microsoft Graph、Azure OpenAI的联合身份认证层，"token exchange"服务开始拒绝有效用户凭证，重试风暴级联过载节点。Downdetector上14:03(PT)有超**4500**份故障报告，14:15峰值超**12000**份。更严重的是认证层失败连带portal.office.com一同瘫痪——被许多企业归类为"AI助手"的工具竟拖垮了整个Web版生产力套件入口。此时距CEO在开发者大会宣称Copilot是"首个真正agentic的操作系统"仅数天，凸显企业AI无SLA停机保障的风险。②正面（Build 2026，6月初，部分属本周窗口边缘）：**MAI-Code-1**（针对GitHub调优的推理高效编码模型）已在Copilot与VS Code可用；MAI系列还将上架Fireworks AI、Baseten、Open Router；Fireworks AI在Foundry正式可用。③**Phi-4模型家族**已可在Snapdragon X Elite与Intel Lunar Lake芯片上原生运行（端侧推理）。④背景（非本周）：与Anthropic扩大合作，Claude上架Azure AI Foundry；2026前4个月新增的Copilot付费M365用户占现有2000万的1/4。技术/商业判断：Microsoft走**多模型（OpenAI+Anthropic+自研MAI/Phi）+端侧化（Phi-4 on-device）**降本路线减少对OpenAI依赖，但本周两次宕机暴露其agentic OS愿景与可靠性现实的鸿沟。
- 关键数据：6-11宕机Downdetector峰值>12000报告（https://www.techtimes.com/articles/318290/20260612/microsoft-copilot-fails-twice-june-enterprise-it-has-no-sla-protection-ai-downtime.htm ，2026-06-12）；MAI-Code-1上线Copilot/VS Code（https://blogs.microsoft.com/blog/2026/06/02/microsoft-build-2026-be-yourself-at-work/ ）
- 原文链接：https://www.techtimes.com/articles/318290/20260612/microsoft-copilot-fails-twice-june-enterprise-it-has-no-sla-protection-ai-downtime.htm ；https://blogs.microsoft.com/blog/2026/06/02/microsoft-build-2026-be-yourself-at-work/
- 影响判断：当AI助手深度嵌入生产力套件，其宕机不再是"功能不可用"而是"整个工作入口瘫痪"，企业AI可靠性与SLA缺失成为下一个治理焦点；Microsoft的多模型+端侧降本是其对冲OpenAI依赖与算力成本的关键战略。

### DeepSeek（V3/R1）
- 本周动态：本周DeepSeek无新模型发布，核心信号是**商业采用度爆发**。①据费用管理平台Ramp数据（the-decoder报道，6月初），**DeepSeek登顶Ramp 2026年6月"增长最快软件供应商"趋势榜**（该榜衡量相对规模的爆发式增长）。Ramp首席经济学家Ara Kharazian指出：美国企业是**直接付费并把数据发送至DeepSeek平台**（而非自托管开源版），他警告直接使用中国模型的安全与竞争风险，并怀疑趋势能否持续。②对比基准：DeepSeek曾在2025年1月有过短暂热度（美国企业采用率0.3%），随后回落至0.1%；本轮"五月爆发"数据覆盖50000+家公司真实交易。③产品背景（非本周）：DeepSeek V4于4月底发布，为最大开源权重模型，1.6T MoE、1M上下文、输出$0.87/M tokens；总性能不及最佳西方模型但价格仅为零头，"性能差距远小于价格差距"。截至6月9日，CSA压缩比、indexer内部、优化器细节、训练token数仍未第一方公开。④行业背景：2025年12月报告显示DeepSeek与阿里Qwen等中国模型在Hugging Face下载量首次超越美国对手，占热门新模型下载量44%+。技术/商业判断：DeepSeek走**极致性价比+开源权重**路线，本周的采用度登顶说明"good enough+极低价"策略在成本敏感的美国企业端成功撕开缺口，但数据出境安全成为最大悬念。
- 关键数据：登顶Ramp 6月趋势榜（https://the-decoder.com/deepseek-topped-ramps-trending-software-vendors-in-june-2026-as-us-companies-chase-cheaper-ai/ ，2026-06）；V4 1.6T MoE/1M上下文/$0.87每M输出（https://www.morphllm.com/deepseek-v4 ，2026-04底，背景）；中国模型占HF下载44%+（2025-12，背景）
- 原文链接：https://the-decoder.com/deepseek-topped-ramps-trending-software-vendors-in-june-2026-as-us-companies-chase-cheaper-ai/ ；https://www.morphllm.com/deepseek-v4
- 影响判断：DeepSeek以价格-性能比在美国企业端实现采用度登顶，印证中国开源模型正以成本优势侵蚀西方闭源模型的商业腹地；但"美企直接向中国平台发数据"触及数据主权红线，监管反弹是最大变量。

### Databricks（DBRX/Mosaic ML）
- 本周动态：本周Databricks的核心事件是**Data + AI Summit 2026（DAIS，旧金山）召开**。①规模：预计超**30000名**参会者（线下+线上），AWS作为Legend Sponsor回归。②技术主线全面转向**agentic stack（智能体技术栈）**："Agents are only as good as the data and runtime behind them"。展示AWS agentic栈与Databricks平台的组合：Amazon Bedrock（托管前沿模型Anthropic Claude/Amazon Nova/Meta Llama+内置Guardrails）+ Bedrock AgentCore（企业级agent运行时：memory、identity、code-interpreter/browser工具、可观测性）通过受治理的MCP连接（经Databricks Apps）安全查询Unity Catalog治理数据。③定位Databricks Mosaic AI + Genie为agent的"受治理大脑（governed brain）"。④客户案例：Mastercard、Talkdesk、nCino、Addepar、Workday等在AWS上用Databricks规模化AI。⑤资本背景（非本周）：tech-insider报道Databricks估值瞄准**1750亿美元**、ARR约**54亿美元**，截至6月中旬无正式IPO申报确认；Mosaic AI源于2023年约14亿美元收购MosaicML。技术/商业判断：Databricks不做前沿基座模型竞赛，而是卡位**"数据治理层+agent运行时大脑"**——把自身定位为企业agent落地的数据与治理底座，与Anthropic/Google/AWS多方结盟而非对抗。
- 关键数据：DAIS 2026参会者30000+（https://www.databricks.com/blog/aws-and-databricks-data-ai-summit-2026-accelerating-real-world-ai-innovation ，2026-06）；估值瞄准1750亿美元/ARR约54亿美元（https://tech-insider.org/databricks-valuation-175-billion-2026/ ，2026-06中，背景）
- 原文链接：https://www.databricks.com/blog/aws-and-databricks-data-ai-summit-2026-accelerating-real-world-ai-innovation ；https://tech-insider.org/databricks-valuation-175-billion-2026/
- 影响判断：Databricks以"数据治理+agent运行时大脑"卡位企业AI落地的关键中间层，避开基座模型军备竞赛而做所有人的数据底座，这是平台型公司在LLM时代的差异化生存范式；1750亿估值反映资本对"AI数据治理层"的高预期。

### 字节跳动（豆包/Coze）
- 本周动态：本周字节无新基座模型发布，信号集中在**战略方向与商业化节奏**。①据kr-asia/Let's Data Science报道（约6月9日，本周窗口内），**字节为2026年设定四大AI优先级**：加大世界模型（world models）投入；保持视频模型Seedance全球第一梯队；强化编码基座；加速agent化。Seed负责人吴永辉团队定下目标：**2026年底前至少发布一个世界模型**并对标顶尖水平。②商业化：据维基百科（6月更新），**豆包付费服务预计2026年6月下旬上线**——目前细节仍在测试，普通用户仍可用免费版。③用户规模：豆包2026春节期间DAU突破1亿（aiwiki），36Kr称春节后不久DAU达**2亿**，为中国DAU第一的AI应用，由自研Seed模型家族驱动。④模型背景（非本周）：2026年2月发布Doubao-Seed-2.0（Lite适配通用生产、Mini优化高并发），视觉推理与时序/运动感知显著提升，复杂Agent能力评估达业界第一梯队。技术/商业判断：字节走**应用规模（2亿DAU）+全栈自研（语言/视频/世界模型）+ 即将商业化**路线，本周的"四大优先级"显示其押注世界模型与视频生成（Seedance）作为差异化，编码与agent化紧跟主流。
- 关键数据：豆包DAU约2亿（https://letsdatascience.com/news/bytedance-outlines-four-ai-priorities-for-2026-7781e8bf ，2026-06）；付费服务预计6月下旬上线（https://zh.wikipedia.org/wiki/豆包_(聊天机器人) ，2026-06）；2026年底前发布≥1个世界模型目标（同letsdatascience）
- 原文链接：https://letsdatascience.com/news/bytedance-outlines-four-ai-priorities-for-2026-7781e8bf ；https://kr-asia.com/bytedance-sets-four-ai-priorities-for-2026
- 影响判断：字节凭2亿DAU的应用分发优势+全栈自研，是中国AI商业化最接近规模盈利的玩家；押注世界模型与视频生成（Seedance）显示其试图在多模态/具身智能开辟差异化战场，而非在纯语言模型上正面硬碰。

### Mistral AI（Mistral Large/Codestral）
- 本周动态：本周Mistral产品线动作密集（官网news流，部分条目日期需以官网为准）。核心主线是**Vibe agent生态扩张**：①推出**"Vibe gets to work"**——统一的长程生产力与编码agent，首发Work与Code两种模式，并配套**新Vibe VS Code扩展**。②**Remote agents in Vibe**：由**Mistral Medium 3.5**驱动的远程编码agent，Le Chat新增处理复杂任务的Work模式（Le Chat已于5月底更名为Vibe，背景）。③企业工具链：推出**Search Toolkit**（生产级搜索流水线）、**Studio中的MCP连接器**（内置+自定义MCP、直接工具调用、human-in-the-loop审批）、**Workflows**进入公开预览、**Forge**（企业基于专有知识构建前沿模型的系统）。④新模型方向：**Physics AI**（预测物理系统行为的新类模型，面向工程加速）、**Mistral Small 4**、**Leanstral**（可信vibe-coding开源基座）、**Voxtral TTS**（前沿开源权重TTS）。⑤生态：与**NVIDIA合作**加速开放前沿模型；Emmi加入Mistral。⑥定价背景（非本周）：Pro订阅$14.99/月；Mistral Large 2支持128K上下文，Codestral为32K优化仓库级代码补全。技术/商业判断：Mistral以**开源权重+企业agent平台（Vibe/Studio/Forge）+ 垂直新方向（Physics AI）**多线并进，定位"欧洲最强企业AI平台"，强调可定制/微调/自部署的开放路线对冲美系闭源巨头。
- 关键数据：Vibe远程agent由Mistral Medium 3.5驱动（https://mistral.ai/news/vibe-remote-agents-mistral-medium-3-5 ）；Pro订阅$14.99/月（https://en.wikipedia.org/wiki/Mistral_AI ，背景）；Mistral Large 2 128K上下文（https://www.aipricing.guru/mistral-ai-pricing/ ，背景）
- 原文链接：https://mistral.ai/news/ ；https://mistral.ai/news/vibe-remote-agents-mistral-medium-3-5
- 影响判断：Mistral以开源权重+全栈企业agent平台（Vibe/Studio/Forge/Workflows）构建差异化，并向Physics AI等垂直科学计算延伸，是欧洲对抗美中AI双极、争夺企业可控/可部署市场的关键力量；多产品线并发显示其从"模型公司"向"企业AI平台公司"转型。

---


---

### 🤖 垂直 Agent 产品

### Anysphere（Cursor）
- 本周动态：Cursor 本周连续放出两项产品更新。①**6月10日**官方博客《Bugbot is now over 3x faster, 22% cheaper, and finds 10% more bugs》正式发布——Bugbot（PR 自动审查机器人）运行速度提升3倍以上、成本降低22%、每次审查多发现10%的 bug，90%的 Bugbot 运行现已在3分钟内完成。原文关键摘录："Bugbot is now over 3x faster to run, 22% cheaper, and finds 10% more bugs per review. In practice, 90% of Bugbot runs now finish in under three minutes." 性能提升来自 harness 改进以及 **Composer 2.5** 模型训练进展，Composer 2.5 现已驱动 Bugbot。同时新增 `/review`、`/review-bugbot`、`/review-security` 命令，可在 push 代码前本地预审，并与 GitHub/GitLab Bugbot 同步去重。需 Cursor 3.7+。②稍早（约6月5日）Cursor 3.7 为 Design Mode 增加语音编辑 UI 与多选元素能力。技术/商业判断：Cursor 正把自研模型 Composer 2.5 作为护城河，从单纯套壳前沿模型转向"自研模型+Agent harness"双轮驱动，Bugbot 的提速降本是其自研模型商业化变现的直接体现。背景（非本周）：Anysphere 估值已达约 $9.9B，ARR 超 $300M，并有 SpaceX $60B 收购传闻。
- 关键数据：Bugbot 提速 3x+、成本 -22%、多发现 10% bug、90% 运行 <3 分钟（https://cursor.com/blog/bugbot-updates-june-2026 ，2026-06-10）；Composer 2.5 驱动 Bugbot（同源）；估值 ~$9.9B / ARR $300M+（背景，valueaddvc.com，非本周）
- 原文链接：https://cursor.com/blog/bugbot-updates-june-2026
- 影响判断：自研模型 Composer 2.5 落地到核心审查产品，标志 Cursor 不再纯依赖第三方前沿模型；提速降本对企业团队采购有直接吸引力，也是其高估值的支撑逻辑。

### Cognition（Devin/Windsurf）
- 本周动态：Cognition 本周（约6月7日报道，6月2日品牌切换）正式推出 **Devin Desktop**，定位为"Windsurf 的下一代"，将 Windsurf 编辑器升级为带 Agent 管理层的开发环境。核心三点：①**Devin Desktop**=IDE+本地/云端 Agent 管理面板，引入 **Spaces** 功能按项目分组 Agent 并跨会话/PR/文件/任务共享上下文；②全面支持 **ACP（Agent Client Protocol）** 开放标准，发布即支持 Codex、Claude Agent、OpenCode 等第三方及自研 Agent 在同一面板内与 Devin 并行运行，未来几周还将推出 agent router 按性能/成本自动路由任务；③**Devin Local** 取代原 Cascade，由 Cognition 重写，效率较前代提升最高 30%（厂商口径，未提供 benchmark 方法）。原 Cascade 保留至 **2026年7月1日**作为迁移窗口。产品线现覆盖 Desktop/Cloud/CLI/Review 多端，同一 Devin agent 可跨桌面、云、命令行运行。Ramp、Harvey AI、NVIDIA、Modal、Intact Financial 等提供了背书评论。技术/商业判断：Cognition 在吞下 Windsurf 后，正用 ACP 开放协议把自己做成"Agent 操作系统/调度中枢"，而非单一编码 Agent——这是与 Cursor 闭环路线的明显分野，押注多 Agent 协同时代的"指挥中心"位置。
- 关键数据：Devin Local 效率较 Cascade +30%（厂商口径，未公开 benchmark，techedt.com，2026-06-07）；Cascade 迁移截止 2026-07-01（byteiota.com）；定价/可用性/安全控制未公开
- 原文链接：https://www.techedt.com/cognition-launches-devin-desktop-for-managing-ai-coding-agents-across-engineering-workflows ；https://windsurf.com/
- 影响判断：ACP 开放标准+agent router 是把"管理多个 Agent"做成平台级入口的关键一步，若被广泛采纳，Cognition 可能成为 Agent 编排层的事实标准，对纯编码 Agent 形成降维。

### Harvey（Legal）
- 本周动态：Harvey 于 **6月（The Brief June 2026 月度产品更新博客）** 集中发布大批法律 Agent 功能，本周（6/9-6/12）官网博客与发布说明密集更新。重点：①**Opus 4.8 上线**——Anthropic 最新模型 Opus 4.8 已通过 Model Selector 在 Assistant、Vault、Agent Builder 全线可用；②**Harvey for Word** 增强红线（redlining）质量与上下文理解、Agentic Word 支持复杂格式/脚注编辑、新增 Writing Styles 与 Model Selector；③**Playbook** 编辑器重构（侧栏规则组织、富文本、超范围条款标记、审查模式）；④文档审查支持 **.pst 邮件归档文件**、审查表格持久化指令与单元格级刷新；⑤研究端新增**美国判例法知识源**、印度 SCC Online 集成、160+ 新法律研究数据源；⑥**Harvey Mobile 上线 Android**，支持图片上传/Magic Prompt/邮件问答；⑦与 **DeepJudge 合作**把律所机构知识接入 Harvey。原文摘录（6/10 博客）："AI adoption is no longer the issue for legal teams"。技术/商业判断：Harvey 正从"聊天助手"全面转向"端到端法律工作流 Agent"，重点补齐 Word 深度集成、判例法权威数据源与机构知识沉淀（DeepJudge），构筑数据+工作流双护城河。
- 关键数据：Opus 4.8 全线可用、160+ 新研究数据源、Playbook 批量上传至多 500 条 prompt（CSV）（https://www.harvey.ai/blog/the-brief-june-2026 ，2026-06）；多篇博客发布日 6/9、6/10、6/12
- 原文链接：https://www.harvey.ai/blog/the-brief-june-2026
- 影响判断：接入最新 Opus 4.8 + 权威判例库 + 机构知识（DeepJudge），强化"准确性与引用可溯"这一法律行业刚需，进一步拉开与通用助手的差距，巩固企业级法律 Agent 头部地位。

### Perplexity
- 本周动态：本周 Perplexity 最大公开事件是 **6月9日 CEO Aravind Srinivas 接受 CNBC 专访**，明确表态公司计划 **2028年 IPO**，且"无论 Anthropic、OpenAI 上市表现如何"都维持该时间表。原文摘录："Agnostic of these two companies, we were planning for something in 2028 so that still remains the case." 背景是上周 Anthropic（估值近 $1万亿）与 OpenAI 相继秘密递交 IPO 申请。Srinivas 还谈到关键路线观点：①批评行业"tokenmaxxing"（员工为显示生产力而堆砌 AI 用量）；②Perplexity 产品基于多家模型，会按任务+成本自动选最优模型，"如果开源模型能 90% 完成任务且便宜 10-20 倍，我会用开源模型"；③认为前沿模型若"连续6个月无能力提升就是问题"。技术/商业判断：Srinivas 公开押注"模型路由+成本意识"而非盲目烧钱，这与其答案引擎商业模式一致——Perplexity 定位为模型中立的应用层入口，靠分发与成本优化盈利，而非自研前沿模型。背景（非本周）：与 Snapchat 达成 $400M 合作成为其默认答案引擎；与 Azure 三年 $750M 承诺（均为背景，非本周）。
- 关键数据：计划 2028 IPO（https://www.cnbc.com/2026/06/09/perplexity-ipo-2028-as-anthropic-openai-prepare-listings.html ，2026-06-09）；Anthropic 估值近 $1万亿（CNBC，背景）；Snapchat $400M、Azure $750M（背景，非本周）
- 原文链接：https://www.cnbc.com/2026/06/09/perplexity-ipo-2028-as-anthropic-openai-prepare-listings.html
- 影响判断：在 Anthropic/OpenAI 冲刺 IPO 的当口主动给出 2028 时间表，是 Perplexity 稳定投资者预期、强化"应用层独立玩家"定位的姿态；"模型中立+成本优化"路线若成立，对烧钱自研路线是一种差异化对冲。

### Sierra
- 本周动态：Sierra（Bret Taylor 创办的客服 Agent 公司）本周两条实锤：①**6月10日获得 FedRAMP® High 认证**——美国联邦机构云服务最高合规标准，意味 Sierra 可进入美国联邦政府客户市场；②**6月11日（Axios 独家）宣布进军公用事业（utility）软件领域**，与 Kraken Technologies 合作，把客服 Agent 从零售、金融、医疗扩展到能源公司，深入能源行业软件层。③6月12日发布博客系列《Discovering what's possible with AI for CX》，6月3日发布《Outcomemaxxing》提出"应用 AI 的未来不以消耗量衡量，而以达成的结果（outcome）衡量"的理念。技术/商业判断：Sierra 正沿"行业纵深+合规壁垒"双线扩张——FedRAMP High 打开政府市场、Kraken 合作切入能源垂直，同时用"outcome-based（按结果计价）"叙事区别于按 token/席位收费的竞品。背景（非本周）：Sierra 已超 $150M ARR（2026年2月披露），底层为 Agent OS 2.0 + Agent Data Platform（2025年11月发布）。
- 关键数据：FedRAMP High 认证 2026-06-10（https://sierra.ai/blog/certified-fedramp-high）；进军公用事业 2026-06-11（axios.com）；ARR >$150M（2026-02 披露，背景）
- 原文链接：https://sierra.ai/blog （含 certified-fedramp-high、discovering-what-s-possible-with-ai-for-cx 等本周条目）
- 影响判断：FedRAMP High 是企业级/政府市场的硬门槛，叠加能源垂直拓展，显示 Sierra 从"通用客服 Agent"转向"受监管行业纵深"，护城河从技术转向合规+行业 know-how，商业天花板被打开。

### Glean
- 本周动态：Glean（企业级 Work AI 搜索/Agent 平台）本周围绕 **"June Drop"（六月产品发布周）** 密集更新。①**企业内容创作新范式博客**（约6/10）：在 Canvas 中新增"可刷新的交互式 artifacts"（动态页面，如 ROI 计算器、动态任务清单、客户简报页，可一次构建、按需刷新、直接分享）与 **AI 构建电子表格**能力（让普通员工无需分析师即可基于公司数据做产品采用分析、活动效果追踪、交易复盘、客户反馈优先级排序）；强调一切输出由"个人图谱+企业知识图谱"grounding，做"AI coworker"而非通用助手。②**6月4日集成 NVIDIA Nemotron 3 Ultra** 模型进入企业 AI 平台。③**6月3日发布 Glean MCP Gateway**——在 MCP 之上加企业级上下文层，用预计算索引+知识图谱提前跨系统连接数据，提升答案质量与 token 效率。技术/商业判断：Glean 的核心战略是把"企业知识图谱"做成不可替代的上下文底座，无论接入哪个模型（Nemotron）或哪个协议（MCP），都通过自有知识图谱+预计算索引强化 grounding，从"企业搜索"升级为"企业内容生产与数据分析 AI coworker"。
- 关键数据：集成 NVIDIA Nemotron 3 Ultra 2026-06-04（itbrief.news/asanify.com）；MCP Gateway 更新 2026-06-03（glean.com）；artifacts 可能采用 usage-based 计价（官方博客注明）
- 原文链接：https://www.glean.com/blog/enterprise-content-creation-artifacts ；https://www.glean.com/blog/introducing-glean-mcp-gateway
- 影响判断：交互式 artifacts + AI 电子表格把 Glean 从"找信息"推向"产出可交付物"，直接侵入 Office/BI 工具腹地；MCP Gateway + 知识图谱则是其在 Agent 时代守住"企业上下文层"入口的关键防御，决定它能否成为企业 AI 的数据中枢。

### Midjourney（v7）
- 本周动态：Midjourney 本周（约6月10-11日）官方更新公告宣布 **V8.1 正式取代 V7 成为默认模型**。原文摘录（updates.midjourney.com）："After your testing and feedback, we've updated the default model from V7 to V8.1!" V8.1 相比 V7 的关键改进：①模型更智能、连贯性更强、更好遵循详细 prompt、**文字渲染能力空前提升**（这是 Midjourney 历来短板）；②开启 HD 模式时，V8.1 渲染尺寸是 V7 的2倍、分辨率是 V7 的 **4倍**；③速度极快——SD 模式 **4秒**出图、HD 模式 **12秒**；④Style references、个性化、美学风格在 V7 与 V8.1 间保持一致。注意事项：V7 的 omni-reference 仍可用（V8 改进版仍在训练）；V8.1 成为默认后，**V8.0 alpha 模型将在两周内弃用**。技术/商业判断：本周事件标志 Midjourney 完成从 V7 到 V8.1 的代际切换，重点补齐"文字渲染"与"速度/分辨率"两大竞争维度——直接对标 GPT Image、Google 等在文字与可控性上的优势，巩固其在艺术/照片级生成的领先地位。本任务清单标注的"v7"已非最新，本周实际主线是 V8.1 上位。
- 关键数据：V8.1 HD 模式 2x 尺寸/4x 分辨率 vs V7；SD 4秒、HD 12秒出图；V8.0 alpha 两周内弃用（https://updates.midjourney.com/v8-1-is-now-the-default-model/ ，约2026-06-10）
- 原文链接：https://updates.midjourney.com/v8-1-is-now-the-default-model/
- 影响判断：默认模型从 V7 升至 V8.1 是面向全体用户的代际跃迁；文字渲染+4x 分辨率+极速出图三项齐进，直接回应竞品压力，对设计/营销等商业场景采用是实质性利好。


---

### 🇨🇳 中国公司

### 阿里云（Qwen/夸克AI）
- 本周动态：据阿里云百炼（Model Studio）官方"模型上下架与更新"页面，**2026-06-10 上线 qwen3.7-max-2026-06-08 快照**——这是本周区间内的核心动态。官方说明："Qwen3.7系列中规模最大、综合能力最强的Max模型，相较于5月20日快照增加了视觉模态理解能力，能够感知真实世界场景，具备多模态交互混合智能体能力。"即 Qwen3.7-Max 从纯文本旗舰升级为**具备视觉理解的多模态混合智能体**，可感知真实世界场景。同期（6-08）还上线 pixverse-v6-r2v 参考生视频模型。背景（非本周）：Qwen3.7-Max 于 2026年5月20日杭州阿里云峰会由 CTO 周靖人正式发布，官方称综合能力国内第一、部分指标逼近 GPT-5.4；第三方 RadarAI 称其在 Chatbot Arena 盲测登顶中国模型第一、进入全球 top-10（第三方口径，存在 V2EX 等用户"不及预期"的争议声音）。技术/商业判断：本周快照的关键信号是 Qwen 把旗舰 Max 从"文本推理"推向"视觉+GUI 操作+多模态混合智能体"，与产品页主推的"Qwen3.7-Plus/Max 多模态智能体模型（看懂界面、操作应用、写代码交付结果）"路线一致——阿里正全力押注"能感知现实、能操作 GUI"的 Agent 旗舰，并以限时折扣（5折/8折）抢占开发者生产测试队列。
- 关键数据：qwen3.7-max-2026-06-08 上线日 2026-06-10，新增视觉模态（https://help.aliyun.com/zh/model-studio/newly-released-models ，官方）；原始发布 2026-05-20、号称国内综合第一（背景，aitoollab.cn/radarai.top）；Arena 中国第一/全球 top-10（第三方口径，有争议）
- 原文链接：https://help.aliyun.com/zh/model-studio/newly-released-models ；https://www.aliyun.com/product/tongyi
- 影响判断：旗舰模型加入视觉+真实场景感知，是 Qwen 向"通用智能体"演进的实质一步；多模态混合 Agent 直接对标 GPT-5.x 与国内 GLM/Kimi，强化阿里在中国开发者生态的旗舰心智。


### 智谱（GLM/清言）
- 本周动态：**2026年6月13日下午5:21**，智谱宣布新一代模型 **GLM-5.2** 面向 GLM Coding Plan 全量用户开放，覆盖 Lite/Pro/Max/团队版全套餐。官方明确：**GLM-5.2 的 API 将于下周上线，模型下周正式开源，遵循 MIT 协议**。GLM-5.2 延续 GLM-5 系列面向 Agentic Coding 与长程 Agent 任务的定位，被定义为"面向 Agentic Engineering 打造的基座模型"，强调复杂系统工程、长程 Agent、代码生成、工具调用与多步骤执行能力。本次最值得关注的升级是官方强调其支持**"真正可用的 1M 上下文"**——对 AI 编程意味可处理更大代码仓库、更长需求文档与更复杂任务链路。GLM Coding Plan 主要用于在 Claude Code、OpenCode、Cline 等 Coding Agent 工具中调用 GLM。注意：截至发布，GLM-5.2 完整模型卡、API 价格、开源权重地址、参数规模与详细评测**尚未完全公开**。背景：智谱"三个月发布三个版本"（GLM-5 于2月、GLM-5.1 于4月、GLM-5.2 于6月），迭代节奏极快。技术/商业判断：智谱坚定走"开源（MIT）+Coding Agent 订阅"双轮路线，用高频迭代+激进开源+长上下文（1M）抢占国内外开发者 Coding Agent 工具链的默认模型位置，与 Kimi、Qwen 在编程 Agent 赛道正面交锋。
- 关键数据：GLM-5.2 全量开放 2026-06-13、API/开源"下周"上线、MIT 协议、支持 1M 上下文（https://www.aihub.cn/news/zhipu-glm-5-2/ ；finance.sina.com.cn 人民财讯 2026-06-13）；参数/价格/评测未公开
- 原文链接：https://www.aihub.cn/news/zhipu-glm-5-2/ ；https://finance.sina.com.cn/jjxw/2026-06-13/doc-inicfvns9660224.shtml
- 影响判断：MIT 开源+1M 上下文+Coding Plan 全量开放三连击，强化智谱在"开源 Agentic Coding 基座"的标杆地位；若下周开源权重与定价具竞争力，对国内 Agent 应用团队是重要选项，也对闭源竞品施压。

### 月之暗面（Kimi K2）
- 本周动态：**2026年6月12日，月之暗面发布并开源 Kimi K2.7 Code 编程模型**（基于 Kimi K2.6 构建的编程专用智能体模型，已在 Hugging Face 开源）。核心数据：**参数量达 1.1 万亿（1.1T）**，提供 **256K 上下文窗口**，针对真实世界长周期编程任务深度优化。最大亮点是**Token 消耗直降约 30%**，缓解"过度思考"问题。定价：1M token 标准输入/输出价格与 K2.6 一致，分别为 **6.5 元和 27 元**；命中缓存输入价格下调至约 1 元/M。月之暗面同时宣布 **6 倍速高速版下周一上线**。背景（非本周）：3月25日中关村论坛月之暗面已推 Kimi-K2 Thinking（Agentic 思考模型）；6月8日有报道称 Kimi 估值飙升至约 **300亿美元**（背景，新浪财经）。技术/商业判断：Kimi K2.7 Code 是典型的"垂直 Coding Agent"打法——在万亿参数基座上针对编程长周期任务专项优化，主打"降本（token -30%）+开源+高速版"，直接对标 GLM-5.2、Qwen3-Coder，争夺 Coding Agent 工具链调用份额。
- 关键数据：Kimi K2.7 Code 发布 2026-06-12、1.1T 参数、256K 上下文、token 消耗 -30%、输入/输出 6.5/27 元/M、缓存输入约 1 元/M、6倍速版下周一上线（智东西/智能 via finance.sina.cn 2026-06-13；oschina.net；80aj.com）；Kimi 估值约 $300 亿（背景，新浪财经 2026-06-08）
- 原文链接：https://www.oschina.net/news/457565 ；https://finance.sina.cn/stock/jdts/2026-06-13/detail-inicetzk8727520.d.html
- 影响判断：万亿参数+开源+显著降本（token -30%）的组合，使 Kimi 在国内开源 Coding 模型竞赛中保持第一梯队；与同周 GLM-5.2 几乎贴身发布，凸显国产编程 Agent 模型已进入"周级别"贴身肉搏。


### MiniMax（海螺/abab）
- 本周动态：MiniMax 本周两条重磅。①**MiniMax M3 旗舰语言模型发布**（6月，官方称"首个三项能力兼备的国产旗舰"）：在编码与智能体评测达行业顶尖，基于自研 **MiniMax Sparse Attention（MSA）架构**，API 最高支持 **1M tokens 上下文**（保障≥512K 可用），原生多模态（从第零步多模态训练）。官方 benchmark：在 **BrowseComp 智能体评测中得 83.5 分，超越 Opus 4.7（79.3）**；PostTrainBench 得 37.1 列第三（次于 Opus 4.7 的 42.4、GPT-5.5 的 39.3）。展示案例：M3 连续自主运行近12小时复现 ICLR 2025 杰出论文（18次commit、23张图表）；在 NVIDIA Hopper 上优化 FP8 矩阵乘 kernel，约24小时147次迭代、1959次工具调用，将硬件峰值利用率从7.6%推到71.3%、实现 **9.4× 加速**。M3 即将在 HuggingFace/GitHub 开源。②**Hailuo 2.3 / 2.3 Fast 视频模型**（本周）：升级肢体动作、微表情、风格化（动漫/水墨/游戏CG）与运动指令响应，号称刷新"全球视频模型效果成本纪录"，保持 Hailuo 02 价格"加量不加价"，Fast 版最高降本50%；同时 Hailuo Video Agent 升级为全模态 **Media Agent**（一键成片）。技术/商业判断：MiniMax 走"语言旗舰（M3，编码+长上下文+多模态）+ 视频/Media Agent（海螺）"双线，押注"开源 frontier + 多模态创作 Agent"，以 benchmark 超 Opus 与极致性价比为卖点。
- 关键数据：M3 BrowseComp 83.5 vs Opus 4.7 的 79.3、PostTrainBench 37.1（第三）、MSA 架构、1M 上下文、CUDA 优化 9.4×加速（https://www.minimaxi.com/models/text/m3 ，官方）；Hailuo 2.3 Fast 降本最高 50%（https://www.minimaxi.com/news/minimax-hailuo-23 ，官方）。注：部分发布日精确日期官方页未标注
- 原文链接：https://www.minimaxi.com/models/text/m3 ；https://www.minimaxi.com/news/minimax-hailuo-23
- 影响判断：M3 用自研稀疏注意力把"编码前沿+1M上下文+原生多模态"三合一并计划开源，是国产开源旗舰的重要突破；BrowseComp 超 Opus 4.7 若获第三方验证，将显著提升 MiniMax 在 Agent 赛道话语权。Hailuo 2.3 巩固其全球 AI 视频性价比标杆地位。


### 腾讯（混元/元宝）
- 本周动态：本周腾讯无新版混元基础模型发布，但围绕"AI 战略换船"有多条本周实锤动态。①**6月8日，微信低调发布《关于开发者接入微信AI生态的指引》，正式面向全量小程序开发者开放 AI 生态接入能力**——这是本周最关键的平台级动作。里昂证券报告指出腾讯拥有 400万+ 小程序、10亿用户的微信生态，在 AI Agent 领域竞争优势甚至优于苹果 iOS，竞品复制需"10年以上"。②**6月5日腾讯云 AI 产业应用大会**披露：AI 办公智能体 **WorkBuddy** 个人版发布3个月累计迭代 **43个版本**；多篇本周报道（6/11新浪财经/网易、6/13 36氪、6/13 火龙果频道）确认腾讯 AI 重心"换船"——WorkBuddy 成为混元系列**战略优先级最高**产品（资源排序 WorkBuddy>DataBuddy>其他），重要性超过元宝；并曝光可在微信上跑的 Agent 产品 **QClaw** 内测。WorkBuddy 主打非技术打工人办公场景（单句指令、自动拆解、直出成果），今年3月月访问量达885万、环比增速831%。③背景（非本周）：腾讯挖来 OpenAI 研究科学家姚顺雨（ReAct 框架/CUA/Deep Research 主导者）补基础模型；混元3.0预览版 Hy3 preview 于2026-04-23 发布，强推理+256K 上下文曾登顶 OpenRouter 周榜、市占升至12.8%列行业第三，但复杂任务仍落后 DeepSeek V4 Flash、Claude Sonnet 4.6。马化腾在2026年5月股东大会以"换船"比喻腾讯 AI 心路。技术/商业判断：腾讯本周路线信号极清晰——**放弃在通用助手（元宝）正面硬刚，转向"生态平台（微信小程序AI化）+垂直办公Agent（WorkBuddy）"打法**，用社交/生态优势做 Agent 超级入口，但底层自研模型仍是其最大短板与风险（生态越繁荣，对外部模型依赖越深、议价空间越小）。
- 关键数据：微信全量小程序 AI 生态开放 2026-06-08；WorkBuddy 3个月迭代43版（腾讯云大会2026-06-05）；WorkBuddy 3月月访问885万、环比+831%；微信 400万+小程序/10亿用户（里昂证券）（来源：https://finance.sina.com.cn/jjxw/2026-06-11/doc-iniazyek2255481.shtml ，2026-06-11）。Hy3 preview 市占12.8%列第三（背景，非本周）
- 原文链接：https://finance.sina.com.cn/jjxw/2026-06-11/doc-iniazyek2255481.shtml ；https://news.ai7788.cn/daily/6567 ；https://36kr.com/p/3718579744437636
- 影响判断：微信全量小程序开放 AI 接入是潜在的"中国版 Agent 超级入口"事件，叠加 WorkBuddy 战略升位，标志腾讯找到差异化打法（生态>模型）；但自研混元与第一梯队的差距，决定其能否把生态优势转化为可持续的 AI 护城河，是最大悬念。

---


---

### 🛠️ Agent 框架工具与其他参与者

### Dify
- 本周动态：**本周无重大公开版本发布**。原因：截至 2026-06-14 检索 GitHub Releases 页，Dify 最新正式版本仍停留在 **v1.14.2（2026-05-19 发布）**，本周（06-07~06-13）未发布新 Release tag。v1.14.2 为补丁版，聚焦安全加固（租户隔离、工具凭证权限收紧 admin/owner、修复 /account/avatar IDOR）、工作流可靠性（HITL 恢复后追踪修复、GraphEngine 最小 worker 数提升）、RAG/知识库稳定性（LLM 节点可访问检索到的知识文件、文档摘要重生成）、以及 Web UI 向 @langgenius/dify-ui 组件库迁移。值得注意：v1.14.1 已为 CVE-2026-42208 升级 LiteLLM。本周开发活动仍在 main 分支持续（PR 合并不断），但未切版本。判断：Dify 进入 1.14.x 维护稳定期，产品重心从功能堆叠转向企业级安全与多租户隔离，符合其商业化（SaaS+私有部署）路线。
- 关键数据：最新版本 v1.14.2，2026-05-19（GitHub Releases，2026-06-14 查）；本周新版本：无
- 原文链接：https://github.com/langgenius/dify/releases
- 影响判断：本周静默不代表停滞，而是版本节奏问题。Dify 作为最主流的开源 LLMOps/Agent 编排平台之一，其安全加固方向（CVE 响应、IDOR 修复）对大量自托管企业用户是刚需信号。

---

### OpenCode
- 本周动态：**本周高频发布，是 C 组工具中迭代最活跃的对象之一**。GitHub Releases（仓库已迁移至 anomalyco/opencode）显示 06-07~06-13 区间内至少 6 个 immutable release：①06-13 22:39 声明 OpenCode 支持的 client capabilities 改善 MCP 服务器兼容性；②06-13 19:59 新增 Snowflake Cortex provider 的外部浏览器 OAuth、v2 项目副本管理与会话迁移流程改进、修复过期 MCP 会话恢复、修复 $ARGUMENTS 命令文件内容重复注入（#31245）；③06-12 02:19 本地 MCP 服务器支持 cwd（工作区相对目录启动 #30676）、新增 connector-based 认证流、新增 v2 API 端点（创建/获取会话、列出会话问题、解析活动位置）、修复 Gemini 多类型字段工具 schema（#31877）、快照创建复用 Git 对象避免大仓库重哈希延迟（#31798）；④06-10 多个补丁修复企业远程配置过期认证、子代理权限、Linux launcher 身份、设备附件选择器。早前 06-10 03:12 版本新增 fff-backed 搜索工具（大项目更快文件搜索）、Cohere North 模型支持、MiniMax M3 thinking 开关、WSL Desktop 支持、启动时间优化 38%（#30453）。判断：OpenCode 正全力推进 v2 架构（API/SDK/Desktop 三端）、强化 MCP 生态与多 provider 覆盖，社区贡献极活跃（单版本 10+ 贡献者）。
- 关键数据：本周 release ≥6 个，最新 06-13 22:39；启动时间优化 38%（#30453）；MCP/v2 API 大量端点新增（GitHub Releases，2026-06-14 查）
- 原文链接：https://github.com/sst/opencode/releases （重定向 anomalyco/opencode）
- 影响判断：OpenCode 以"开源 Claude Code 替代品"定位，本周的 MCP 兼容性、多 provider（含 Cohere North、MiniMax M3）、v2 API 化是其平台化野心的明确信号。高频 immutable release 节奏显示其工程交付能力强，正争夺终端 AI 编码工具的开源主导权。

---

### Codex CLI（SWE-bench #1）
- 本周动态：**本周密集发布，CLI 与桌面/移动端全线更新**。据 OpenAI 官方 Codex Changelog：①**Codex CLI 0.139.0（2026-06-09，npm install -g @openai/codex@0.139.0）**——Code mode 现可直接调用独立 web search（含嵌套 JS 工具调用、返回纯文本结果 #26719）；工具/连接器输入 schema 现保留 oneOf/allOf，大 schema 压缩时保留更多浅层结构以提升富 MCP 工具兼容性（#24118/#27084）；codex doctor 增加编辑器/分页器环境细节；插件 marketplace 自动化更智能（缓存远程目录先返回再后台刷新）；修复沙箱执行保留已批准的提权决策、强制 proxy-only 网络（#24981/#27035）。②**Codex CLI 0.138.0（2026-06-08）**——/app 命令可将当前 CLI 线程移交至 macOS/Windows 的 Codex Desktop；本地图片附件暴露保存路径给模型；reasoning effort 选择更灵活；app-server 支持读取账户 token 用量、v2 personal access token；插件自动化富结构化输出（--json）。③**Codex app 26.609（2026-06-11）**——新增 Plus/Pro 用户的 rate-limit reset banking（含发布即送一次免费 reset）+推荐邀请赚额度；Chrome/内置浏览器新增 Developer mode（受控 CDP 访问做性能分析与调试）；Browser use 提速最高 2x。④**26.608（2026-06-09）**——新增"Migrate to Codex"流程，支持从 Claude Code/Claude Cowork 导入设置。判断：OpenAI 正把 Codex 从单一 CLI 推向 CLI+Desktop+Mobile 全平台生态，且明确以"从 Claude Code 迁移"为获客抓手，竞争意图直白。
- 关键数据：CLI 0.139.0（2026-06-09）、0.138.0（2026-06-08）、app 26.609（2026-06-11）、26.608（2026-06-09）；Browser use 提速最高 2x（OpenAI Codex Changelog，2026-06-14 查）
- 原文链接：https://developers.openai.com/codex/changelog ；https://github.com/openai/codex/releases/tag/rust-v0.139.0
- 影响判断：本周最大信号是"Migrate to Codex"导入 Claude Code/Cowork 配置——OpenAI 直接抢 Anthropic 编码工具用户。多智能体 v2（MAv2）相关 PR 密集（residency lru、并发计数、interrupt_agent），显示 Codex 正构建终端内多智能体编排能力。

---

### Google ADK
- 本周动态：**本周发布 adk-python v1.35.0（2026-06-10）**，属 1.x 维护线小版本。核心变更：live 模块针对 **Gemini Live 3.1 模型**差异化处理输入转写（#6045）；修复 base_llm_flow 缺失的 Gemini imports（#5943）；连接成功后重置重连尝试次数（#6042）；为 Gemini 3.1 live 默认 grounding metadata（#6018）；支持 Vertex AI 上 Gemini 3.1 Live 的通用化 history config 注入（#5999）。注意：ADK 主力已进入 **2.x（v2.2.0 于 2026-06-04 发布，刚好在窗口前）**，2.2.0 含重大破坏性变更——LlmAgent 默认模型从 gemini-2.5-flash 改为 gemini-3-flash-preview（应对 2.5-flash 将于 2026-10-16 下线）、升级支持 GenAI SDK v2.0.0（turns→steps 术语迁移），并新增 AutoTracingPlugin（OTel 自动埋点）、RubricBasedMultiTurnTrajectoryEvaluator、A2A input/auth 区分、修复 Zip Slip 路径穿越、为 CVE-2026-48710 升级 starlette/fastapi。本周 1.35.0 主要是为仍在 1.x 的用户兜底 Gemini 3.1 Live 兼容性。判断：ADK 双线并行（1.x 维护 + 2.x 主推），紧贴 Gemini 3.1 模型迭代节奏。
- 关键数据：v1.35.0（2026-06-10）；2.x 主线 v2.2.0（2026-06-04，窗口前背景）；默认模型 gemini-3-flash-preview（GitHub Releases，2026-06-14 查）
- 原文链接：https://github.com/google/adk-python/releases ；https://github.com/google/adk-python/releases/tag/v2.2.0
- 影响判断：本周 1.35.0 信号偏小，真正大动作是窗口前的 2.2.0 GA 化与默认模型切换到 Gemini 3 Flash 预览版——ADK 用模型默认值绑定 Gemini 生态，是 Google 全栈 Agent 战略的工程落地。A2A 协议持续强化（input-required vs auth-required 区分）显示其押注跨智能体互操作标准。

---

### Claude Code
- 本周动态：**本周重磅——Anthropic 发布全新旗舰模型 Claude Fable 5**。据 Claude Code GitHub Releases：**2026-06-09 起（需更新至 2.1.170）可访问 Claude Fable 5——一款 "Mythos-class" 模型，官方称其能力超过 Anthropic 此前任何公开发布的模型**，发布页 anthropic.com/news/claude-fable-5-mythos-5。围绕 Fable 5 的多项配套修复随后跟进：①修复 Fable 5 模型名 [1m] 后缀未规范化问题（Fable 5 默认含 1M 上下文，后缀自动剥离，06-11）；②修复 auto mode 在未启用 Opus 4.8 的组织上对 Fable 5 失败——分类器回退到最佳可用 Opus（06-12）；③修复 "Fable 5 正在消耗用量额度" 横幅对企业按量计费账户错误显示。其他重要工程动态：**子代理现可生成自己的子代理（最深 5 层，06-10）**——多智能体编排能力显著增强；新增 enforceAvailableModels 托管设置（模型白名单约束默认模型）；新增 --safe-mode 标志（禁用所有自定义项排障，06-08）、/cd 命令（不破坏 prompt cache 切换工作目录）；VSCode 用量归因仪表盘（/usage 显示 cache miss、长上下文、子代理、per-skill/agent/plugin/MCP 分解）。本周发布节奏极密（06-06 至 06-13 近乎每日多版本）。判断：Anthropic 用 Fable 5 这款"超越以往一切"的 Mythos 级模型重夺前沿能力高地，同时 Claude Code 工程上深化多层子代理编排与企业级模型管控。
- 关键数据：Claude Fable 5（2026-06-09，需 v2.1.170）；子代理嵌套最深 5 层（06-10）；默认含 1M 上下文（GitHub Releases，2026-06-14 查）
- 原文链接：https://github.com/anthropics/claude-code/releases ；https://www.anthropic.com/news/claude-fable-5-mythos-5
- 影响判断：Fable 5 是本周全球 AI 最大单点事件之一——"Mythos-class 且对通用使用安全"的措辞暗示 Anthropic 在能力与安全对齐上同时突破。配合 Codex 本周推"从 Claude Code 迁移"，Anthropic vs OpenAI 的编码 Agent + 旗舰模型双线战争本周白热化。子代理 5 层嵌套使 Claude Code 从单 agent 工具进化为可编排的 agent 系统。

---

### OpenClaw（Agent OS）
- 本周动态：**本周高频预发布，工程交付节奏极密**。GitHub Releases 显示 06-13 当天连发 **2026.6.7（09:42）与 2026.6.8（21:49）两个 pre-release**（更早 06-07~06-12 亦有多个滚动 pre-release）。本周核心变更：①**多模型扩张**——新增 GLM-5.2 支持、Claude Haiku 4.5 catalog 行、Kimi K2.7 Code、修复 Kimi 原生 tool-call id 与 reasoning_content 回放、OpenRouter/Google Vertex provider 前缀归一化；②**渠道交付增强**——Telegram 支持结构化富文本（表格/列表/可展开引用块）、WhatsApp 支持 ACP 绑定、Slack 出站 message_sent hook；③**安全加固**——Feishu 不再泄漏 prompt-preface 运行时上下文到回复、WebSocket 负载处理加固、Skill Workshop 符号链接写入需校验后才写回滚元数据、HTTP session/model override 需 admin 权限；④Agent/Gateway 恢复增强（账户级 DM 发送、生成媒体补全、yielded 子代理暂停、心跳去重、拒绝未知 OpenAI agent selector）；⑤/usage hook 原生全 footer 渲染。判断：OpenClaw 以日更级 pre-release 节奏持续打磨企业级多渠道网关能力，本周明显在补强国产模型生态（GLM-5.2、Kimi K2.7）与中文/飞书场景的安全边界，社区贡献者中出现大量中文 ID，显示其在中国市场的工程参与度极高。
- 关键数据：本周 pre-release ≥2（2026.6.7、2026.6.8 均 06-13）；新增 GLM-5.2/Kimi K2.7 Code/Claude Haiku 4.5（GitHub Releases，2026-06-14 查）
- 原文链接：https://github.com/openclaw/openclaw/releases
- 影响判断：OpenClaw 作为被 OpenAI 收购（据背景报道 2026-02 以约 1.16 亿美元）的"Agent OS/网关"型项目，本周对 GLM-5.2、Kimi K2.7 等国产模型的快速纳入，以及飞书上下文泄漏修复，是其平台中立性与多市场覆盖战略的明确信号。日更级 pre-release 显示其仍是 Agent 框架中工程迭代最快的项目之一。

---

### Hermes Agent（自进化，增长最快）
- 本周动态：**本周无新 Release tag，但开发活动剧烈**。最近一个正式版是 **v0.16.0（v2026.6.5，2026-06-05 发布）**——恰好落在本期窗口前 2 天（背景，非本周）。该版自 v0.15.2 起累计 **874 commits、542 merged PR、1962 文件变更、170 名社区贡献者**，主题为"The Surface Release"：①全新原生桌面应用（macOS/Linux/Windows Electron 应用，单周 100 PR/159 commit 造出，支持一键安装、应用内自更新、拖拽文件、状态栏内联模型选择、多 profile 并发会话、完整简体中文翻译、OAuth/账密连接远程 Hermes 网关）；②Web 仪表盘升级为完整浏览器管理面板（MCP 目录、消息渠道、凭证、webhook、记忆、OIDC/账密登录）；③NVIDIA/skills 加入可信 Skills Hub；④模糊模型选择器全端覆盖，新增 deepseek-v4-flash、MiniMax-M3（1M 上下文）、qwen3.7-plus；⑤/undo [N] 撤回最近 N 轮；⑥安全轮（CVE-2026-48710 Starlette pin、SSRF off-loop 加固、子进程凭证剥离）。GitHub 显示仓库 **2026-06-13 仍在更新，Stars 达 192k**（org 页 192,236，MIT 协议）。本周（06-07~06-13）处于 v0.16.0 之后、下个 tag 之前的高强度开发期。判断：Hermes 用"自进化+桌面化"双轮驱动，v0.16.0 的桌面 App 是其从"极客 CLI"走向大众化产品的关键一跃。
- 关键数据：v0.16.0（2026-06-05，窗口前2天，背景）；Stars 192,236（GitHub org 页，2026-06-14 查，仓库更新于 06-13）；874 commits/170 贡献者
- 原文链接：https://github.com/NousResearch/hermes-agent/releases/tag/v2026.6.5 ；https://github.com/NousResearch/hermes-agent
- 影响判断：Hermes 是增长最快的开源 Agent，Stars 已达 192k（远超历史报道的 11.4 万，显示持续高速增长）。本周虽无新 tag 但 06-13 仍有提交，开发不停。v0.16.0 桌面化叠加 NVIDIA skills 接入，标志自进化 Agent 正从研究项目走向可分发的消费级产品，对 OpenClaw 的"网关广度"形成"自学习深度"侧翼竞争。

---

### Scale AI（SEAL）
- 本周动态：**SEAL 榜单本周成为衡量 Claude Fable 5 的权威标尺**。据 morphllm 整理的 SWE-bench Pro 榜单（数据源 Scale AI SEAL Public Set，731 任务，Pass@1，截至 **2026-06-09**）：Claude Fable 5 在 Anthropic 自有 scaffold 下报 80.3%，而在 **Scale 标准化 SEAL 榜单上 gpt-5.4 xHigh 为 59.1%**，Scale 私有商业集上 Opus 4.6 为 47.1%——三个数字反映"模型能力 vs harness 质量"的隔离。Scale 的核心价值在于"用相同 scaffolding 跑所有模型"，剥离工具链差异。背景：Scale 于 2026-06-01 推出 **SEAL Showdown**——基于 100+ 国家、70 种语言、200+ 专业领域真实用户偏好的全新公开榜单，直接挑战 LMArena 的评测主导地位。注意：DeepSeek V4 Flash/Pro 截至 06-09 尚无 SEAL SWE-bench Pro 条目。判断：本周 Scale 的角色是"中立裁判"——当 Anthropic 报 Fable 5 80.3% 时，SEAL 标准化榜单提供了交叉验证基准，凸显厂商自报分数与标准化分数的鸿沟（80.3% vs 59.1%）。
- 关键数据：SEAL Public Set 731 任务，gpt-5.4 xHigh 59.1%、Opus 4.6 私有集 47.1%（Scale SEAL，2026-06-09）；SEAL Showdown 2026-06-01 上线
- 原文链接：https://www.morphllm.com/swe-bench-pro ；https://labs.scale.com/leaderboard/swe_bench_pro_public ；https://scale.com/blog/showdown
- 影响判断：在 Fable 5 等新模型刷榜的本周，SEAL 标准化榜单的"去 scaffold 化"价值更突出——它是判断"模型真实能力 vs 厂商营销分数"的关键参照系。SEAL Showdown 押注"真实世界多语言用户偏好"，是评测赛道从实验室基准向真实使用迁移的重要信号。

---

### Cohere（Command R+）
- 本周动态：**本周无重大模型/产品发布**。原因：Cohere 最近的旗舰发布是 **Command A+（2026-05-20，窗口前）**——218B 参数 MoE（25B 激活）、Apache 2.0 开源、原生引用生成、W4A4 无损量化（可在 2 张 H100 或单张 B200 部署）、48 语言支持，定位"主权关键基础设施"。本期窗口内（06-07~06-13）Cohere 官网 newsroom/blog 未见新模型或重大公告；最近的相关内容是 **Co/plot（2026-06-03，窗口前）**——一个支持研究过程可视化的工具，及 RWS 合作（06-01）。判断：Cohere 在 Command A+ 大版本发布后进入消化期，本周战略重心仍在企业/政府主权 AI 的落地合作（RWS、Mila/魁北克法语合作），而非模型迭代。注：任务清单标注的"Command R+"为 Cohere 历史产品线，当前主力已是 Command A/A+ 系列。
- 关键数据：Command A+（2026-05-20，218B MoE/25B 激活，Apache 2.0，窗口前背景）；本周新发布：无
- 原文链接：https://cohere.com/newsroom ；https://cohere.com/blog/command-a-plus
- 影响判断：Cohere 本周静默符合其节奏——大模型发布后转向商业落地。其差异化战略清晰：不追前沿能力刷榜，而以"主权 AI+开源+低部署门槛+多语言"切政府与受监管行业，与 Anthropic/OpenAI 的前沿竞赛错位竞争。

---

### SSI（SSI-1）
- 本周动态：**本周无产品/技术公开动态，仅有财务背景信息流出**。据 startuphub.ai（2026-06-06）援引 Globe and Mail：**Safe Superintelligence Inc. 自 2024-06 成立以来已累计融资 60 亿美元、估值达 320 亿美元**，成为"无任何商用产品却估值最高的 AI 实验室"。SSI 由 Ilya Sutskever、Daniel Gross（原 Apple AI 负责人，已于 2025-06-29 离职被 Meta 挖角）、Daniel Levy（原 OpenAI 研究员，现任 SSI 总裁）三人创立，Sutskever 现兼任 CEO。其 320 亿估值"完全建立在 Sutskever 的声誉与一个尚未公开的研究方向上"。SSI 官网仍只有一句使命宣言："one goal and one product: a safe superintelligence"，本周窗口内无任何技术论文、模型或产品发布。任务清单中的"SSI-1"目前无公开实证。判断：SSI 维持其"直线冲刺、零产品、不受短期商业压力干扰"的极端保密策略，本周亦不例外。
- 关键数据：累计融资 60 亿美元、估值 320 亿美元（startuphub.ai 援引 Globe and Mail，2026-06-06）；成立 2024-06；无商用产品
- 原文链接：https://www.startuphub.ai/ai-news/ai-figures/2026/figure-ilya-sutskever-ssi-financial-breakdown-2026-06-06 ；https://ssi.inc
- 影响判断：SSI 是本组最大"黑箱"——在 Anthropic（Fable 5）、OpenAI（Codex 全平台）本周高调竞争的对比下，SSI 的完全沉默本身就是信号：它押注一条不依赖渐进式产品迭代的"直线超智能"路径，320 亿估值与零产品的反差，是 2026 年 AI 资本市场对"纯研究豪赌"容忍度的极端样本。

---


---

### ⚡ 算力云硬件

### NVIDIA（GPU/CUDA/Blackwell）
- 本周动态：本周 NVIDIA 主要动态集中在机器人/物理AI与本地AI两条线，以及消费级 Blackwell 工作站 GPU 的渠道定价。①**机器人安全（6/10）**：NVIDIA 官方博客发文《For Robotaxis, Safety Must Be Built In, Not Bolted On》，推广其 HALOS 安全架构与 robotaxi 安全方案，强调安全应内建于自动驾驶系统底层而非事后叠加，呼应其 DRIVE/Halos OS 在已落地数十城的 robotaxi 商业化背景。②**本地AI生态（6/10）**：同日发文宣布已对 Google DeepMind 当日发布的实验性开放模型 **DiffusionGemma**（主打超快文本生成）完成优化，使其在 GeForce RTX、RTX PRO 平台及相关硬件上"跑得更快"——延续 NVIDIA 把第三方新模型第一时间适配自家 RTX 生态、巩固本地推理护城河的打法。③**Blackwell 工作站 GPU 定价（6/13 前后）**：NVIDIA 官方 Marketplace 将 **RTX PRO 6000 Blackwell Workstation Edition（96GB）** 标价 **$13,250**，目前显示缺货；该价格显著高于 2025 年初零售/预购价，反映高端 Blackwell 工作站卡在 AI 本地开发需求下的溢价。④**公司治理**：NVIDIA 宣布将于 6/24 线上召开 2026 年度股东大会。技术/商业判断：本周无新一代数据中心 GPU 发布，主线是"把 Blackwell 生态向边缘/本地/机器人延伸"——RTX Spark（6/1 Computex 发布，背景，非本周）、DiffusionGemma 适配、Halos 机器人安全，都是把 CUDA 生态从训练集群向"物理AI + 本地推理"扩张的连续动作。
- 关键数据：RTX PRO 6000 Blackwell 96GB 官方标价 $13,250（缺货）——videocardz/Thunder Compute，约 2026-06-12~13；年度股东大会 6/24 线上——NVIDIA Newsroom，约 2026-06-10。
- 原文链接：https://nvidianews.nvidia.com/news ; https://blogs.nvidia.com/blog/halos-os-robotaxi-safety/ ; https://blogs.nvidia.com/blog/rtx-ai-garage-local-gemma-diffusion/ ; https://videocardz.com/newz/nvidia-now-lists-rtx-pro-6000-blackwell-96gb-gpu-at-13250
- 影响判断：本周信号是"Blackwell 生态外溢"——NVIDIA 不再只靠数据中心训练卡，而是把 CUDA 优势同步压到 robotaxi 安全栈、本地扩散模型推理、工作站 AI 三个新战场，进一步抬高竞争对手的生态迁移成本。RTX PRO 6000 的高定价也说明高端推理/创作硬件仍是卖方市场。

### AWS（Bedrock/Trainium/SageMaker）
- 本周动态：AWS 本周通过 **6/8 的官方 Weekly Roundup** 集中披露多项更新，与本组算力云主题高度相关：①**Trainium/Inferentia 上 ECS（本周）**：Amazon ECS Managed Instances 现已支持 AWS Trainium 与 Inferentia——可用 Inferentia2、Trainium1、Trainium2 实例类型创建 ECS Managed Instances 容量提供者，由 ECS 自动为 AI/ML 工作负载分配资源，降低自管 AI 加速实例的运维门槛。②**Graviton5 新实例（本周）**：AWS 推出 **EC2 M9g 与 M9gd 实例**，搭载 **AWS Graviton5** 处理器，官方称是"迄今最强、能效最高"的自研处理器，相比 Graviton4 实例算力提升最高 **25%**。③**OpenAI 模型在 Bedrock 转生产可用（本周确认）**：OpenAI 的 **GPT-5.5、GPT-5.4 与 Codex** 现已在 Amazon Bedrock 生产可用，定价对齐 OpenAI 官方费率，且用量计入 AWS 承诺消费额度。技术/商业判断：本周 AWS 的主线是"自研芯片(Trainium/Inferentia/Graviton5)持续渗透托管服务 + 在 Bedrock 上集齐 OpenAI/Anthropic 双巨头模型"，把"省钱的自研硅"与"最全的模型货架"两手都做厚。背景（非本周）：Anthropic 此前承诺未来十年在 AWS 基础设施(含各代 Trainium)投入超 $100B，是 Trainium 路线的最大需求锚。
- 关键数据：Graviton5 相比 Graviton4 算力最高 +25%——AWS News Blog，2026-06-08；GPT-5.5/5.4/Codex 在 Bedrock 生产可用，定价对齐 OpenAI——AWS Weekly Roundup，2026-06-08；Anthropic 承诺 10 年 $100B+ AWS（背景，非本周）。
- 原文链接：https://aws.amazon.com/blogs/aws/aws-weekly-roundup-byom-for-amazon-rds-for-sql-server-aws-iot-device-sdk-for-swift-and-more-june-8-2026/ ; https://aws.amazon.com/blogs/aws/category/post-types/announcements/
- 影响判断：AWS 正用"自研芯片下沉到托管层(ECS/SageMaker)"对冲 NVIDIA GPU 成本，同时靠 Bedrock 同时承载 OpenAI 与 Anthropic 两大模型阵营，强化"中立模型货架"定位。Graviton5 落地说明 AWS 通用算力也在持续自研替代。

### Azure（Azure AI / OpenAI Service）
- 本周动态：①**Claude Fable 5 上线 Microsoft Foundry（6/9）**：微软宣布 Microsoft Foundry 现已支持 Anthropic 的 **Claude Fable 5**，主打长时任务、企业级工作流与受治理的 AI 智能体能力（governed agents），延续微软"在自家 Foundry 平台上多模型并存、弱化对单一 OpenAI 依赖"的策略。②**Azure AI Services 持续更新（6/4 前后，窗口边缘）**：APIM 支持 Foundry Models、Azure AI Search 私有连接、内容理解分块等多项更新（部分时间点 6/4，紧贴窗口前沿，作背景）。③**Build 2026 余波（背景，6/2）**：Microsoft Build 2026 发布 Foundry IQ、HorizonDB、Claude 正式集成、Foundry Local 主权 AI、Anyscale on Azure 预览、Fireworks AI 在 Foundry GA 等，并宣布自研 MAI 模型——这些为 6/2，属窗口前背景。技术/商业判断：本周 Azure 的核心信号是"在 Foundry 上继续把 Anthropic Claude 系列做深(Fable 5)"，配合 Build 2026 公布的自研 MAI 模型，微软"OpenAI + Anthropic + 自研 MAI"的三轨模型战略在本周以 Claude Fable 5 落地的形式继续推进，降低对 OpenAI 的单点依赖。
- 关键数据：Claude Fable 5 上线 Microsoft Foundry——Microsoft Azure，2026-06-09 17:00 GMT；Fireworks AI 在 Foundry GA、MAI 模型公布（背景，2026-06-02）。
- 原文链接：https://windowsforum.com/threads/claude-fable-5-in-microsoft-foundry-governed-ai-agents-for-azure-enterprises.424414/ ; https://azurecharts.com/updates?service=6 ; https://blogs.microsoft.com/blog/2026/06/02/microsoft-build-2026-be-yourself-at-work/
- 影响判断：Azure 把 Claude Fable 5 接进 Foundry，标志着"受治理的企业级 Agent"成为云厂商新竞争焦点，且微软在 Build 后持续以"多模型 + 自研 MAI"对冲 OpenAI 依赖，是云 AI 平台格局的重要风向。


---

### 🦾 具身机器人

### 宇树 Unitree（H1/G1）
- 本周动态：宇树本周无重磅产品发布或融资交割，主线是"IPO 冲刺 + 媒体造势"的延续。本周可确认的窗口内动态主要是**舆论层面**：6/8 台媒《財訊快報》等以"宇树被点名中国下一个硬件巨头、低成本人形机器人冲击全球产业版图"为题报道，强化其"用智能手机式规模效应 + 极致成本工程"打全球市场的叙事。产品层面，本周相关的重磅设计 **H2 Plus**（首款基于 NVIDIA Isaac GR00T 开发平台的学术研究参考人形，近1.82米/约68kg/整机31自由度+双 Sharpa Wave 触觉五指手共75自由度、搭载 Jetson AGX Thor T5000、Blackwell GPU 算力 2070 FP4 TFLOPS、续航约3小时）实为 **6/1 GTC Taipei 期间** 发布，属窗口前背景；该机计划 2026 年底/10 月面向科研单位开售。IPO 方面，上交所上市委 **6/1** 审议宇树科创板 IPO（背景）；6/2 宇树宣布单款双足人形累计下线约 **11000 台**（截至 2026 年 5 月，背景）。技术/商业判断：本周宇树处于"发布间歇期+上市静默/造势期"，无新硬件，但其与 NVIDIA 深度绑定(H2 Plus 作为 GR00T 参考整机)的战略卡位，是本周值得标注的产业信号——中国本体厂商成为美国 AI 算力栈在物理AI领域的"标杆载体"。
- 关键数据：2025 年营收 ¥16.99 亿（同比 +333%），2026Q1 营收 ¥4.23 亿（同比 +68.49%）——上交所 IPO 披露/Gasgoo，2026-06-01（背景）；单款双足人形累计下线约 11000 台（截至 2026-05）——界面新闻，2026-06-02（背景）；H2 Plus 算力 2070 FP4 TFLOPS——新浪财经/HK01，2026-06-01（背景）。
- 原文链接：https://finance.sina.com.cn/stock/usstock/summary/2026-06-01/doc-inhzwpyp8539146.shtml ; https://www.jiemian.com/article/14521458.html ; https://autonews.gasgoo.com/articles/news/unitree-robotics-ipo-to-be-reviewed-on-june-1-2059995013390594049
- 影响判断：宇树本周虽无新发布，但"H2 Plus = NVIDIA Isaac GR00T 全球首款学术参考整机"的定位，使其成为中美 AI 算力栈向具身智能延伸的关键交汇点；叠加科创板 IPO 上会，宇树正从"硬件先锋"向"资本市场+生态平台"双线升级。

### 优必选 UBTech（Walker S）
- 本周动态：优必选本周是 D 组机器人侧最有料的对象。①**消费级 C 端爆单（6/9）**：优必选宣布旗下消费级品牌"优世界（UWORLD）"首款全尺寸超仿生人形机器人 **U1 系列** 在京东开启预售仅 8 天，小订（定金锁单）数量突破 **3000 台**——而 2025 年优必选全尺寸人形全年累计销量仅 1079 台，C 端预订量已是全年 B 端销量的近 3 倍。②**产品参数**：U1 分男/女款，男款身高 183cm/42kg、女款 168cm/35.2kg，均搭载 **88 个自由度**关节、支持 WiFi、单次充电续航 2–4 小时，标注不支持二次开发；定位情感陪伴，将搭载"养成系情感大模型"、本地加密存储记忆、多维外观定制，已开启 IP 合作。预售自 6/2 启动（背景），支付 3000 元定金锁首批名额，预计最晚 9/15 发货，6/30 正式发布。③**B 端基本盘**：工业机型 Walker S 系列（S/S1/S2）已进入奥迪一汽、比亚迪、蔚来、极氪等车厂实训，2025 全年营收 20.01 亿元(+53.3%)，全尺寸人形收入从 3560 万暴增至 8.21 亿（+22 倍）；2026 目标冲刺万台工业产能。技术/商业判断：优必选本周完成"从 B 端工业到 C 端情感陪伴"的关键卡位，U1 的 3000 台小订验证了"有人愿为情感陪伴付费"这一需求拐点，是其商业模式从重资产工业交付向高毛利消费市场延伸的重要信号。
- 关键数据：U1 预售 8 天小订破 3000 台——盖世汽车/优必选，2026-06-09；U1 男款 183cm/42kg、女款 168cm/35.2kg、88 自由度、续航 2-4h——优必选预售页，2026-06-02；2025 营收 20.01 亿(+53.3%)、全尺寸人形收入 8.21 亿(+2203.7%)、全年交付 1079 台——优必选 2025 年报（背景）。
- 原文链接：https://m.gasgoo.com/news/70461292.html ; https://www.ubtrobot.com/en/humanoid/products/walker-s
- 影响判断：优必选率先在 C 端情感陪伴赛道用"全尺寸超仿生+情感大模型"撕开市场，3000 台小订是行业首个规模化的 C 端人形需求验证；叠加 Walker S2 工业量产，优必选正成为"B+C 双轮驱动"商业化最快的人形机器人上市公司。

### Figure AI（Figure 02）
- 本周动态：Figure AI 在本严格时间窗（6/7–6/13）内**无新的官方重大公开发布**。其近期密集动态均落在窗口前：①约 **6/2** 在 CNET/TechCrunch 等渠道露出新一代人形机器人（媒体报道集中于 6/2 前后）；②约 5 月下旬其 4 台 Helix-02 驱动人形在直播中连续自主分拣包裹近 **40 小时、约 5 万件**（最初计划 8 小时的测试持续多日，机器人 Bob/Frank/Gary/Rose），展示 Helix-02 在仓储场景的长时全自主能力——该测试为窗口前（约 5 月）事件。本周可见的仅为这些事件的二手回顾与行业综述（如各家"2026 最佳人形机器人"盘点仍将 Figure 列为第一梯队，估值约 390 亿美元，背景）。一句原因：Figure 在 6 月初密集释放新机型与长时自主分拣 demo 后，进入"落地验证+产能爬坡(BotQ 工厂年产能 1.2 万台 Figure 03)"的执行期，本周无新增官方发布节点。技术/商业判断：Figure 的主线已从"发布会驱动"转向"真实工时验证驱动"（24/7 仓储分拣、BMW 产线 X3 装配），本周静默属正常产品节奏。
- 关键数据：Helix-02 连续自主分拣近 40 小时/约 5 万件（4 台机，窗口前约 5 月）——TechRepublic/Reddit；估值约 390 亿美元（2025-09，背景）；BotQ 工厂年产能 1.2 万台 Figure 03（背景）。
- 原文链接：https://www.techrepublic.com/article/news-figure-robot-demo-tests-24-7-humanoid-fleet-work/ ; https://blogs.nvidia.com/blog/figure-humanoid-robot-autonomous
- 影响判断：Figure 本周无新发布，但其"长时全自主分拣 + 车厂产线落地"路线已是西方人形阵营商业化标杆；与优必选/宇树相比，Figure 更强调"自研 Helix VLA 大脑 + 工业级可靠性"，是中美人形竞赛中美方一侧的关键参照系。

---


---

## 📋 关于本周报

- **数据口径**：覆盖区间 2026-06-07 ~ 06-13（上海时区）的完整自然周。版本号、融资额、估值、benchmark、Stars、发布日期等关键数据均标注来源 URL + 日期；查不到的标注"未公开"，不编造。
- **覆盖范围**：38 个研究对象，6 大赛道（大模型基座 / 垂直 Agent / 中国公司 / 框架工具与其他参与者 / 算力云硬件 / 具身机器人），50+ 信息源。本期 38/38 全覆盖。
- **静默对象**：本周无重大公开动态的对象（Dify、Hermes Agent、Cohere、SSI、宇树、Figure AI）均经搜索验证并标注具体原因（多为版本节奏处于发布间歇期或进入落地执行期）。
- **质量门控**：覆盖率 38/38（100%）、原文深度抽查 5/5 通过、每对象含具体洞察 + 三条主线趋势、关键数据有源且交叉验证。
- **下期预告**：关注 GLM-5.2 开源权重与定价落地、Kimi K2.7 高速版表现、Anthropic Fable 5 出口管制后续、xAI Grok V9 正式公开发布、Databricks/OpenAI IPO 进程。

