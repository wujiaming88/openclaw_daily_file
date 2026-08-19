# 全球 AI 创业公司研究周报 · 第 11 期（2026-08-12—2026-08-18）

> **本期：** 2026-08-12—2026-08-18（上海时间）  
> **覆盖：** 美国 5 家、中国 5 家、欧洲与以色列 4 家、其他地区 3 家，共 17 家  
> **估值口径：** 仅纳入公开估值低于 10 亿美元，或最新估值未披露但无可信独角兽证据的非大厂创业公司；不以融资额反推估值。  
> **窗口口径：** 动态须发生或正式披露于上海时间 2026-08-12 00:00—2026-08-18 24:00；集中披露历史融资、此前完成但本周首次正式公告等情形均在公司条目中明确说明。

## 本周一句话

AI 创业投资继续沿“可量化业务闭环”展开：代码验证、机器人核心零部件、实时数据基础设施、金融催收、实体门店运营与专业知识工作流，均以生产部署、效率指标或产业协同争夺差异化。

---

## 🔥 本周 TOP 5创业公司

### Blacksmith

**为何关注：** AI 生成代码将验证、测试与合并推成新约束；Blacksmith 已用专用 CI 云、自动修复闭环和可量化客户/收入增长占据“代码生成之后、进入生产之前”的控制点。


**一句话定位：** 为AI生成代码激增后的“验证瓶颈”提供专用CI云，并以可自动修复失败检查的代码代理把构建、测试、修复和合并串成闭环。

**本周动态（日期与来源）：** 2026-08-12（上海时间窗口内），Blacksmith官网全文公告其4500万美元B轮，Peak XV领投，YC与GV跟投；交易实际于2026年3月完成，但本周才正式公布，投后估值5.5亿美元。TechCrunch同日独家采访确认融资、估值、客户与收入，并报道客户已超过5,000家；官网更新口径为超过6,000家公司，属于发布时间/统计口径差异，而非混用。官网还披露CI作业自年初每周增长5%—10%，本周公开的增长与融资公告构成真实动态。

**产品深研：** 核心是替代/加速GitHub Actions的CI运行云：用自管裸金属、面向高性能负载的CPU和缓存/调度基础设施运行构建与测试，而非简单转售通用云虚机；早期公开测试称可将速度提升至约2倍、计算成本降低最高75%。产品已扩展到[code]smith云端编码代理：代理可实现功能、修复bug，尤其深入CI反馈回路，诊断并自动修复失败检查；下一步[code]smith QA将做合并前自主测试。差异化不是再造一个IDE，而是占据“代码生成之后、进入生产之前”的验证控制点，兼有专用算力经济性、低迁移成本（改一行工作流配置）和跨客户失败数据的学习效应。本周数据：官网称6,000+企业、管理数十万CPU核并计划数月内扩大10倍；TechCrunch称收入由1,000万美元ARR增长至“数千万美元”，约30名员工，部分大客户年支出超100万美元。

**融资记录：** 2025-05种子轮350万美元，GV领投/参与（估值未披露）；2025-09 A轮1,000万美元，GV领投，14天内完成，彼时估值约6,000万美元；2026-03完成、2026-08-12披露B轮4,500万美元，Peak XV领投，YC、GV跟投，投后估值5.5亿美元；公开累计融资5,850万美元。用途明确为扩张自有计算资源、提前承接AI编码带来的CI需求，并在纽约和旧金山招聘。除此之外未发现其他已披露机构轮次。

**创始人：** Aditya Jayaprakash（CEO）、Aayush Shah、Aditya Maru于滑铁卢大学相识，后在Faire、Cockroach Labs从事大规模分布式系统，亲历构建与单元测试成本高、性能不可预测，问题—能力匹配度很高。团队由2025年2月4人、2025年9月约11人增至本周约30人；创始团队既懂分布式计算，又有PLG开发者工具经验，这是比纯模型团队更适合做重基础设施生意的组合。

**竞争力（护城河、地位、增长、风险）：** 护城河来自裸金属算力供应与调度、CI历史数据、和GitHub工作流的嵌入及验证代理闭环。客户从不到一年前700+增至5,000—6,000+，估值约10倍提升、收入达到数千万美元，显示产品市场契合度强。风险是GitHub Actions、AWS/Azure/GCP可价格反击，Cursor/Codex/Claude Code把验证内置后可能挤压独立层；自持算力也带来资本开支、利用率和可靠性压力。判断：Blacksmith目前是高增长挑战者，不是通用云替代者，其最佳防守是把CI数据转化为代理评测与自动修复能力，而非只打价格战。

**赛道分析：** AI编码已把“写代码”边际成本压低，验证、测试、安全与合并成为新约束；CI/CD是成熟大市场，但AI原生代码验证仍在早期重构。主要玩家有GitHub Actions、GitLab CI、CircleCI、Buildkite、云厂商，以及Cursor Automations、Codex、Claude Code等代理内建验证。Blacksmith卡位在模型无关的执行与验证层，既服务人类开发者也服务代理。未来1—2年，企业会从单个编码助手转向并行代理流水线，CI负载和评测需求大增；胜负手将是单位测试成本、失败自动修复率、可观测性与企业合规，独立厂商也面临被代码平台并购或捆绑的窗口。

**关键数据（逐项来源URL+日期）：**
- B轮4,500万美元、估值5.5亿美元、Peak XV领投；2026-08-12：[blacksmith.sh](https://www.blacksmith.sh/blog/announcing-blacksmiths-series-b-led-by-peak-xv-partners)
- 6,000+企业、CI作业周增5%—10%、数十万CPU核；2026-08-12：同上。
- 累计融资5,850万美元、5,000+客户、约30人、收入“数千万美元”；2026-08-12：[techcrunch.com](https://techcrunch.com/2026/08/12/blacksmiths-valuation-jumps-10x-to-550m-as-ai-coding-fuels-software-validation/)
- 种子轮350万美元、A轮1,000万美元、创始团队履历、速度/成本指标；2025-09-17：[techcrunch.com](https://techcrunch.com/2025/09/17/google-ventures-doubles-down-on-dev-tool-startup-blacksmith-just-4-months-after-its-seed-round/)

**原文链接：**
- 官网融资公告（2026-08-12）：[blacksmith.sh](https://www.blacksmith.sh/blog/announcing-blacksmiths-series-b-led-by-peak-xv-partners)
- TechCrunch本周独家（2026-08-12）：[techcrunch.com](https://techcrunch.com/2026/08/12/blacksmiths-valuation-jumps-10x-to-550m-as-ai-coding-fuels-software-validation/)
- TechCrunch A轮深访（2025-09-17）：[techcrunch.com](https://techcrunch.com/2025/09/17/google-ventures-doubles-down-on-dev-tool-startup-blacksmith-just-4-months-after-its-seed-round/)

**投资/合作视角：** 这是“AI卖铲人”中少数已有强收入和可量化基础设施优势、且估值仍低于10亿美元的标的，值得关注下一轮单位经济与净留存。合作上，代码托管、AI编码代理、安全测试与企业研发效能平台都可把Blacksmith作为验证执行层；投资前应重点核验大客户集中度、裸金属利用率和[code]smith自动修复的真实成功率。


### Pathway

**为何关注：** Pathway 同时掌握企业实时数据层与后 Transformer 模型研究，若公开基准能在生产负载中复现，有机会形成欧洲少见的模型架构与生产数据双栈。


**一句话定位：** Pathway从“让企业AI持续读取实时数据”的流式计算底座，向兼具持续记忆、低成本推理的后Transformer基础模型公司跃迁。

**本周动态（日期与来源）：** 2026-08-13（上海时间窗内），公司官网宣布获得一笔金额未单列的追加融资，使累计种子融资达到3000万美元，投后估值5亿美元；官方还宣布采购NVIDIA GB300扩充算力，并任命前Google DeepMind Gemini Group Product Manager Adam Kurzrok为CPO。Vestbee同日/本周报道及Dealroom报道交叉确认累计额、估值、投资方和用途；注意“3000万美元”是累计种子融资，不应误写为本轮单笔融资。

**产品深研：** 其商业底座是统一处理结构化/非结构化流数据的实时引擎，可连接300多个来源，支撑实时向量检索、异常检测和在线特征服务；新研究主线BDH（Dragon Hatchling）则是生物启发、尺度无关的状态空间序列架构，在潜空间内用持久状态、稀疏激活、局部交互和循环推理实现持续学习，试图绕开Transformer依赖超长生成式思维链及反复全量训练的成本。官方披露BDH在约25万道Sudoku Extreme中解出97.4%，无需CoT、回溯或外部工具；150M参数BDH-CQ在ARC-AGI-1得29.5%，估算每题推理成本约0.0007美元。差异化不只是“更小模型”，而是把企业实时数据层、记忆与新模型架构连成一体；但结果目前以公司自报和公开基准为主，尚需独立复现及真实生产负载验证。

**融资记录：** 公开可核实的完整节点为：2024-12种子轮1000万美元，TQ Ventures领投，Kadmos、Inovo.vc、Market One Capital、Id4及包括Łukasz Kaiser在内的天使参与，用于增强Live AI、基础设施和实时数据集成；2026-08追加资本（单笔金额未披露），累计种子融资3000万美元、估值5亿美元，参与方Id4 Ventures、TQ Ventures、Red Bridge Ventures、Kadmos Capital、WS Investment Co.及Databricks首席AI科学家Jonathan Frankle，主要用于GB300算力和BDH扩展。2024年前若有小额轮次，金额/日期未由本次所读官方材料逐项披露，故不推算。

**创始人：** 公司2020年创立；公开资料列出CEO Zuzanna Stamirowska、Claire Nouet、CTO Jan Chorowski与CSO Adrian Kosowski为创始团队。Stamirowska毕业于École Polytechnique，复杂系统博士研究涉及海运贸易预测；Chorowski与Kosowski具机器学习、算法/图计算研究背景。这种“复杂系统预测+ML研究+高性能数据系统”的组合与实时学习问题高度适配。团队规模未披露；新任CPO及由Transformer共同发明者Łukasz Kaiser、Jonathan Frankle等组成的顾问阵容提升模型产品化能力，但顾问不等同全职研发人数。

**竞争力：** 护城河是自研流式引擎、企业数据连接经验、BDH架构IP与高密度学术网络的叠加，而非单一模型参数规模；已有NATO、La Poste、Formula 1等被报道客户，显示底层产品曾进入高要求环境。其5亿美元估值仍严格低于10亿美元。最大风险是架构路线能否在语言、多模态和长时间在线学习中保持基准优势，以及训练算力、生态工具链和客户迁移成本均落后于Transformer阵营；“架构革命”叙事也可能跑在收入前面。

**赛道分析：** 实时AI基础设施已进入成长期，Confluent、Databricks、Pinecone、Weaviate等分别占据事件流、湖仓与向量检索；基础模型则由OpenAI、Anthropic、Google及Mistral主导。Pathway卡位两层交界：先用实时数据管道进入企业，再以持续学习模型提高“每美元智能”。未来1—2年关键不是再发一个漂亮基准，而是公开可复现评测、在金融/医疗/科技场景形成低延迟低成本案例，并证明模型可安全遗忘、审计与回滚。若成功，它可能成为欧洲少数拥有模型架构与生产数据层双栈的公司；若失败，仍可回归实时RAG/数据基础设施市场。

**关键数据（来源URL+日期）：**
- 累计种子融资3000万美元、估值5亿美元、GB300用途、投资方：Pathway官网，2026-08-13左右发布（搜索索引显示8天前，抓取于2026-08-19），[pathway.com](https://pathway.com/blog/pathway-strikes-a-500m-valuation)
- 150M模型ARC-AGI-1 29.5%、约0.0007美元/题：Vestbee，2026-08-13，[vestbee.com](https://www.vestbee.com/insights/articles/pathway-lands-30-m)
- BDH Sudoku Extreme 97.4%、追加融资单笔未披露：Dealroom，2026-08-13前后，[dealroom.co](https://dealroom.co/news/144373-pathway-reaches-500m-valuation-on-30m-seed-funding/)
- 2024种子轮1000万美元、300+数据源、客户：Vestbee，2024-12-02，[vestbee.com](https://www.vestbee.com/insights/articles/pathway-secures-10-m)

**原文链接：**
- 官方融资/技术公告（全文）：[pathway.com](https://pathway.com/blog/pathway-strikes-a-500m-valuation)
- 官方BDH论文入口：[arxiv.org](https://arxiv.org/abs/2509.26507)
- Vestbee本周报道：[vestbee.com](https://www.vestbee.com/insights/articles/pathway-lands-30-m)
- Dealroom交叉验证：[dealroom.co](https://dealroom.co/news/144373-pathway-reaches-500m-valuation-on-30m-seed-funding/)

**投资/合作视角：** 值得以“技术验证里程碑”而非估值叙事推进：要求独立复现ARC/Sudoku、查看企业续费和单位推理经济性。产业合作可从实时风控、设备遥测、医疗事件流等必须持续更新的场景切入；投资上应把下一轮条款绑定多用途模型公开基准与付费生产部署，防止5亿美元估值提前透支科研成果。


### 奇点智控

**为何关注：** 奇点智控以光学路线、解耦算法和自动标定切入具身智能六维力觉，目标把万元级小批量传感器推向千元级量产，核心看点是头部整机定点与长期可靠性验证。


**一句话定位：** 用非接触式光学路线把六维力传感器从“万元级、小批量”压向“千元级、可量产”，瞄准人形机器人手腕、灵巧手和微型机械臂的核心力觉入口。

**本周动态（日期与来源）：** 2026年8月13日公司官微信息经投资界全文转载，宣布完成近亿元人民币天使轮，由隐峰资本领投，张江科投、浦东创投、傅利叶及两家未具名上市公司跟投；8月14日投中网再次确认金额、轮次与投资方。上海市企业走出去综合服务平台8月18日披露公司实际成立于6月5日、已导入多家头部AI硬件企业供应链，并说明傅利叶兼具投资人、产业合作方和潜在首批客户身份。

**产品深研：** 产品不是传统应变片的微调，而是“外力→光学元件微位移→光信号变化→算法解算六轴力/力矩”的物理路线切换。它绕开应变片接触式形变测量导致的疲劳、蠕变、温漂和轴间串扰，且结构更容易小型化。工程架构包括光学敏感结构、自研解耦算法、超高精度自动标定与测试设备，重点不只在实验室精度，而在批次一致性和量产节拍。公司称核心性能对标海外万元级产品、定价做到千元级；这一“十分之一成本”的说法仍需客户长期寿命、温漂和动态标定数据验证。本周可核验数据为已通过多项行业标准测试、导入多家头部AI硬件企业，但客户名称、订单额、良率均未披露。

**融资记录：** 公司2026-06-05成立；目前仅核验到本次天使轮：2026-08-13披露，近1亿元，隐峰资本领投，张江科投、浦东创投、傅利叶及两家上市公司跟投，用于市场推广、产品持续迭代和量产交付。更早轮次：无。投后估值：未披露。公开数据库亦显示估值栏为空；结合仅一轮天使融资及注册资本100万元，可确认没有“估值≥10亿美元”的公开证据，符合本组排除独角兽口径，但不能据融资额反推精确估值。

**创始人：** 创始人庞丹任法定代表人、董事及财务负责人，通过直接和持股平台合计控制约90%股权；公开来源未披露其学历、前职与技术履历。专利线索显示六维力传感相关发明人与傅利叶创始人顾捷存在关联，说明技术可能带有产业孵化属性；这对场景验证和首单获取有利，但也形成对傅利叶技术/客户关系依赖。团队规模未披露。庞丹的商业运营适配性尚待更多履历验证，当前更清晰的是“商业操盘+产业技术底座”的双核组织，而非单一明星科学家模式。

**竞争力：** 护城河来自光学物理路线、结构专利、解耦算法、自动标定设备和产业客户共研的组合；其中标定数据库与量产一致性比单个样机参数更关键。卡位上处于具身智能上游“卖铲子”，不押注某一家整机形态。增长抓手是灵巧手自由度提升和力控闭环普及。风险包括光学器件在粉尘、冲击、温漂和长期漂移下的可靠性，早期公司产能与质量体系，以及投资方傅利叶既合作又可能造成客户中立性顾虑。

**赛道分析：** 六维力觉仍处商业化早期，国际玩家包括ATI、Kistler，国内有宇立仪器、坤维科技、蓝点触控等，应变片路线仍占主流。GGII 2026年5月预测2030年全球人形机器人力传感器市场约328.06亿元；MIR此前估计中国人形机器人六维力传感出货2024—2030年复合增速超120%。奇点智控卡的是“小型化+低成本+量产”缺口。未来1—2年胜负不在发布更多型号，而在获得头部整机定点、通过百万次循环与极端工况验证，并把标定自动化转为稳定毛利。

**关键数据（逐项来源URL+日期）：** ①近亿元天使轮、投资方与用途：投资界，2026-08-13，[news.pedaily.cn](https://news.pedaily.cn/202608/567655.shtml)；②投中网交叉确认，2026-08-14，[chinaventure.com.cn](https://www.chinaventure.com.cn/news/114-20260813-392746.html)；③成立日期、庞丹持股约90%、成本目标和供应链导入：上海市企业走出去综合服务平台，2026-08-18，[segg.sh.gov.cn](https://segg.sh.gov.cn/pdfpt/gzdt/20260818/779e020555e54ad2a5d2e23f9b15a690.html)；④2030年全球人形机器人力传感器市场预测328.06亿元：东方财富转引GGII，2026-05-26，[emcreative.eastmoney.com](https://emcreative.eastmoney.com/app_fortune/article/index.html?artCode=20260526153618860426600&postId=1714836937)。

**原文链接：** [news.pedaily.cn](https://news.pedaily.cn/202608/567655.shtml) ｜ [chinaventure.com.cn](https://www.chinaventure.com.cn/news/114-20260813-392746.html) ｜ [segg.sh.gov.cn](https://segg.sh.gov.cn/pdfpt/gzdt/20260818/779e020555e54ad2a5d2e23f9b15a690.html)

**投资/合作视角：** 值得以“验证里程碑”而非概念估值推进：重点索取循环寿命、温漂、串扰、良率和在手定点数据。整机厂可尝试联合定义腕部/指端规格，但应保留第二供应商；投资人则需核清专利归属及与傅利叶的关联交易边界。


### Rezolv

**为何关注：** Rezolv 从回收效果可量化的催收入口切入，以多语种语音智能体、策略编排和借贷领域数据闭环向信贷全生命周期扩张，已呈现初步产品市场匹配。


**一句话定位：** Rezolv是一家孟买AI原生贷后与信贷工作流平台，用多语种实时语音智能体、策略编排和分析层，替代银行及非银金融机构割裂、静态且高度依赖人工的催收系统。

**本周动态（日期与来源）：** 2026-08-18，Rezolv完成**1250万美元A轮**，由Norwest领投，Vertex Ventures Southeast Asia and India与老股东3one4 Capital参投；The SaaS News（8月18日）和TechNode Global（8月18日）均披露本轮，Dealroom同日进一步给出约**5120万美元估值**。本轮使累计融资达到1600万美元，资金用于把AI能力从催收扩展至销售、风控、承保等完整借贷周期，并推动印度以外国际市场。

**产品深研：** 官网原文显示，产品瞄准金融机构常见的多系统不互通、报表滞后、策略静态、人工合规和坐席过载。其技术栈可拆为三层：第一层是面向电话场景的低延迟语音智能体，强调自然停顿、打断处理、回合检测、降噪以及11种印度语言和通话中无缝换语；第二层把通话接入销售、欢迎、线索资格判断、客服与催收流程，并抽取意图、还款承诺与处置结果；第三层通过Strategy Builder和生命周期分析，让业务人员配置分群、触达与解决策略而非每次依赖IT。媒体称Strategy Builder可把催收/解决率提升35%。这不是通用外呼机器人，而是以真实借贷对话训练、以回收额和转化率优化的垂直系统；关键差异是语言本地化、领域工作流、合规和结果数据闭环。

**融资记录：** 2025-03种子轮**350万美元**，3one4 Capital领投，投后估值约1280万美元；2026-08-18 A轮**1250万美元**，Norwest领投，Vertex Ventures SEA & India和3one4 Capital参投，Dealroom披露估值约5120万美元；累计1600万美元。除此之外未查到更早机构轮次。用途为强化销售、风险、承保、催收全套AI能力及全球化。估值低于10亿美元，符合本组口径。

**创始人：** Karan Mehta与Sonali Jindal于2024年创办Rezolv，两人此前共同创办印度数字贷款公司Kissht。这个履历与产品高度适配：他们不是从通用LLM寻找场景，而是从放贷机构的获客、风险、回款及监管摩擦反向设计产品，拥有客户关系、历史工作流认知与数据语义优势。公开可核实团队规模未披露。

**竞争力：** 护城河首先是印度复杂语言、口音、噪声和催收合规中的生产数据；其次是从通话模型延伸至信贷全生命周期后的系统嵌入与迁移成本；再次是创始人Kissht网络带来的快速分发。公司首个完整经营年度末（2026年3月）年化收入运行率约3亿印度卢比，且A轮估值较种子轮约四倍，显示初步产品市场匹配。风险是银行采购周期长、催收AI容易引发消费者保护与偏见争议，且语音基础模型趋于商品化；若不能证明合规审计、回收提升和单位经济性，差异会被大型核心银行软件或通用语音AI吞噬。

**赛道分析：** AI借贷软件已从“坐席辅助”进入可执行任务的智能体阶段，市场成熟度处于早中期：传统玩家包括FICO、Experian、核心银行系统和大型BPO，新玩家则以语音AI、替代数据承保和自动催收切入。印度数字信贷规模、语言碎片化与人工坐席成本构成天然试验场。Rezolv卡位在贷后现金回收这一ROI最容易量化的入口，再向贷前销售、风险和承保扩张，路径合理。未来1—2年胜负点将是：能否形成跨机构可迁移而不泄露隐私的领域模型；能否在RBI监管下提供可解释、可审计的人机升级机制；以及国际化时能否适配不同催收法律。判断上，它具备成为区域信贷AI操作层的潜力，但尚未证明海外复制能力。

**关键数据（逐项来源URL+日期）：**
- A轮1250万美元、累计1600万美元、投资方及用途：The SaaS News，2026-08-18，[thesaasnews.com](https://www.thesaasnews.com/news/rezolv-raises-12-5m-series-a/)
- A轮估值5120万美元；种子轮350万美元、投后估值1280万美元；2026年3月ARR运行率约3亿卢比：Dealroom，2026-08-18，[dealroom.co](https://dealroom.co/news/145453-rezolv-raises-12-5m-series-a-to-push-ai-beyond-debt-collection/)
- 11种印度语言、低延迟语音栈、适用工作流：Rezolv官网，访问/核验于2026-08-19，[rezolv.com](https://www.rezolv.com/)
- 融资新闻交叉验证：TechNode Global，2026-08-18，[technode.global](https://technode.global/2026/08/18/indias-software-firm-rezolv-raises-12-5m-series-a-led-by-norwest-for-ai-lending-platform/)

**原文链接：** [rezolv.com](https://www.rezolv.com/) ；[thesaasnews.com](https://www.thesaasnews.com/news/rezolv-raises-12-5m-series-a/) ；[dealroom.co](https://dealroom.co/news/145453-rezolv-raises-12-5m-series-a-to-push-ai-beyond-debt-collection/) ；[technode.global](https://technode.global/2026/08/18/indias-software-firm-rezolv-raises-12-5m-series-a-led-by-norwest-for-ai-lending-platform/)

**投资/合作视角：** 投资上值得继续跟踪其净收入留存、每通电话成本、真实回收率提升和监管投诉率，而不应只看演示中的自然语音。合作上，中国/东南亚金融软件商可与其共建本地语言与合规模块，以催收单点POC切入；若Rezolv能以隐私安全方式积累跨机构策略反馈，其数据飞轮会比语音模型本身更有价值。


### Palona AI

**为何关注：** Palona AI 已把语音、现场视觉与 POS/预订系统接成“捕获—理解—行动—学习”闭环，并以门店订单和团餐线索数据验证实体商业多模态操作层。


**一句话定位：** 用语音、视觉和业务系统信号理解线下门店正在发生什么，并调度专用智能体把漏接电话、团餐线索和运营异常转成收入与动作。

**本周动态（日期与来源）：** 2026-08-17，Palona正式发布面向实体商业的多模态AI operating layer并完成A轮，累计融资达到2,000万美元（含转换的SAFE）。SiliconANGLE阅读全文称本轮由Ardenwood Ventures领投，CrimsonOx、UpHonest、Turbo、Llama Ventures、Neo、Fusion Fund、Defy、Maynard Webb等参与；FastCasual同日独立确认产品、投资者和生产数据。公司已部署Din Tai Fung、Mountain Mike's Pizza、Giordano's、Rooted Hospitality、Cali BBQ等连锁品牌。

**产品深研：** 产品由Revenue Expansion、Revenue Intelligence、Operations Intelligence构成。Ordering Agent接听漏接电话、回答菜单/营业时间/预订并把订单直接写入POS；Catering Agent依据人数、预算、饮食限制持续跟进高价值询盘；收入智能按门店、时段、渠道识别线索流失；运营智能连接既有安防摄像头，监测食安、清洁、排队和员工合规并实时告警。底层“capture-understand-act-learn”闭环使用专有Interaction Model for Physical AI，将视觉目标检测与空间、时间、语义关系结合，再按意图、模型表现和实时算力调度多智能体；相关编排获美国专利US 12,481,517。差异化是同时连接对话需求、现场视频与POS/预订系统，而非单点语音机器人。本周生产研究覆盖3品牌、194个门店日，完成481单，并在7家餐厅识别305条大单/团餐询盘；Cali BBQ父亲节收入同比增20%以上。

**融资记录：** 2025-01种子轮1,000万美元，UpHonest Capital领投，Fusion Fund、Neo及其他投资者参与；2026-08 A轮后累计融资2,000万美元，含转换SAFE，Ardenwood Ventures领投，另有CrimsonOx、UpHonest、Turbo、Llama Ventures、Neo、Fusion Fund、Defy、Maynard Webb等。由于公告只给“累计2,000万美元”而未明确本轮新增现金与SAFE各自金额，严禁把A轮简单写成新增2,000万美元；本轮估值和此前估值均未披露。用途为拓展餐饮平台、连接更多现场/客户信号，并向酒店、商场和娱乐场所扩张。

**创始人：** CEO Maria Zhang曾任Google工程副总裁，并有Meta、LinkedIn经历、曾任Tinder CTO；CTO Tim Howes是企业软件与身份/目录技术老兵；首席科学家Steve Liu曾任Samsung AI Center与Tinder首席科学家，并有高校终身教职背景。三人组合覆盖大规模产品、AI研究与企业系统，尤其适合把模型落到碎片化门店软件。官网称团队来自Google、Meta、Tinder、DoorDash；公开口径约30人/LinkedIn为11—50人区间，精确人数未由公司披露。

**竞争力（护城河、地位、增长、风险）：** 护城河可能来自多模态门店交互数据、POS/摄像头集成、跨门店运营benchmark与专利化代理编排。已有多家知名餐饮链和可量化订单数据，地位已从“客服聊天机器人”升级为餐饮AI操作层挑战者。风险包括语音点餐赛道拥挤（SoundHound、Presto、ConverseNow、Slang AI等）、摄像头分析引发员工隐私与合规问题、门店系统集成成本高，以及公司自行披露的收入提升缺少第三方审计。判断：其多模态闭环优于纯电话代理，但必须证明部署复制速度和同店增量，而非依赖定制服务。

**赛道分析：** 美国餐饮数字化成熟但软件高度割裂，AI点餐已进入商业化中期，真正理解线下运营的Physical AI仍属早期。主要玩家包括Toast、Olo等交易平台，SoundHound/ConverseNow/Slang AI等语音厂商，以及Spot AI等视频智能。Palona卡在这些系统之上做模型无关的动作编排，先用高频餐饮建立数据，再扩展其他实体业态。未来1—2年，语音接单会快速同质化，价值上移到跨渠道收入归因、现场异常闭环和可证明ROI；平台能否成为POS生态伙伴而非竞争者，是扩张关键。

**关键数据（逐项来源URL+日期）：**
- A轮后累计融资2,000万美元（含SAFE）、投资方、产品架构；2026-08-17：[siliconangle.com](https://siliconangle.com/2026/08/17/palona-raises-20m-in-funding-to-bring-ai-automation-to-brick-and-mortar-businesses/)
- 3品牌194门店日、481单、305条大单询盘、客户名单、专利号；2026-08-17：[fastcasual.com](https://www.fastcasual.com/news/palona-ai-debuts-ai-platform-for-restaurants-after-20m-funding-round/)
- Ordering/Catering/Operations Intelligence能力与客户证言；访问核验2026-08-19：[palona.ai](https://palona.ai/)
- 创始团队来自Google、Meta、Tinder、DoorDash；访问核验2026-08-19：[palona.ai](https://palona.ai/about)
- 种子轮1,000万美元及创始人履历；2025-01-23：[geekwire.com](https://www.geekwire.com/2025/former-google-vp-raises-10m-for-new-startup-building-ai-agents-for-retail-businesses/)

**原文链接：**
- 公司产品官网：[palona.ai](https://palona.ai/)
- 公司团队页：[palona.ai](https://palona.ai/about)
- SiliconANGLE融资全文（2026-08-17）：[siliconangle.com](https://siliconangle.com/2026/08/17/palona-raises-20m-in-funding-to-bring-ai-automation-to-brick-and-mortar-businesses/)
- FastCasual行业验证（2026-08-17）：[fastcasual.com](https://www.fastcasual.com/news/palona-ai-debuts-ai-platform-for-restaurants-after-20m-funding-round/)
- GeekWire种子轮与创始人背景（2025-01-23）：[geekwire.com](https://www.geekwire.com/2025/former-google-vp-raises-10m-for-new-startup-building-ai-agents-for-retail-businesses/)

**投资/合作视角：** 餐饮POS、支付、连锁加盟管理和摄像头厂商适合把Palona作为增收模块联合销售，避免自建多模态代理。投资前建议抽样核验订单归因、门店上线周期、人工兜底成本及毛利；若7—14天可复制部署且收入分成可持续，它会比按席位收费的通用Agent更具垂直价值。


---

## 🌍 分地域详情

### 🇺🇸 美国

#### Blacksmith（美国·AI代码验证/CI基础设施）

> 完整五维研究、关键数据与投资/合作视角详见「本周 TOP 5创业公司」。

#### Harell Data（美国·科学数据云/AI药物发现）

**一句话定位：** 让AI模型在不拿走原始专有数据的安全云中训练，并把训练计算收入直接分给科学数据生产者，以解锁长期沉睡的生物医药数据孤岛。

**本周动态（日期与来源）：** 2026-08-17（GeekWire页面显示美西17日17:15；对应上海时间2026-08-18 08:15）Harell Data公开亮相并宣布已融资1,500万美元，投资方包括Fuse、Cercano Management等，同时本周开放Early Access；2026-08-18 Life Science Washington与Timmerman Report分别确认。首批数据来自A-Alpha Bio的蛋白—蛋白结合亲和力和Adaptive Biotechnologies的T细胞受体结合数据。公司官网原始产品页已公开Harell Cloud、模型实时基准和抗体/T细胞推理方向。

**产品深研：** Harell Cloud同时面向数据拥有者和模型开发者。数据方把专有数据置于安全环境，原始数据不离开平台；模型方在CoreWeave Cloud、Nvidia GPU上训练、微调和运行预测，免去逐项授权与自建昂贵算力。商业架构把传统“卖数据一次”或多年后药物里程碑分成，改成训练计算收入即时分成：数据方随训练运行获得收入，优秀数据因模型表现可持续增值。平台还计划对模型实时benchmark和leaderboard，形成数据—模型双边市场。差异化在于把保密计算环境、数据授权、GPU供应和收益结算绑定，而非只做数据目录。首批推理用例为抗体结合位点/强度、T细胞生理结合位点和激活阈值。本周尚未披露客户数、收入、模型精度或分成比例，必须视为商业验证初期。

**融资记录：** 当前可核验的完整公开融资仅一轮：1,500万美元早期融资（PitchBook记录日期2026-02-04；公司在2026-08-17/18公开亮相时披露），Fuse、Cercano Management及其他未具名投资者参与；轮次名称、投前/投后估值均未披露。资金用途为建设安全科学计算云、引入高质量数据集、补贴/扩展GPU算力并拓展模型开发者生态。没有可信来源显示后续轮次或估值达到10亿美元；因此按“估值未披露、无独角兽证据”纳入，而非自行估值。

**创始人：** Harlan Robins是Adaptive Biotechnologies科学创始人、前首席科学官，长期建设用于解析免疫系统的大型专有数据集，目前仍任Adaptive科学战略顾问。他既理解实验数据为何昂贵，也懂模型训练需要何种标签与质量控制，创始人—问题匹配度极高。11人团队分布于华盛顿州Bellevue和Palo Alto，关键成员包括CTO Rakesh Nair、运营负责人Saray Covey、销售负责人Analise Polsky；没有从Adaptive直接挖团队，降低关联交易/人才转移疑虑。

**竞争力（护城河、地位、增长、风险）：** 潜在护城河是独家高价值实验数据、可信执行环境、以及数据贡献者收益网络效应；A-Alpha Bio和Adaptive两套首发数据为冷启动提供稀缺性。Robins的产业信誉能降低生物技术公司的授权顾虑。风险更突出：双边市场需要同时吸引数据方和模型方；云厂商、药企或数据平台可复制收益分成；数据质量责任、患者隐私、跨境和衍生模型权属复杂；分成比例未披露，单位经济尚无法判断。判断：它不是已有增长证明的平台，而是一个由强创始人和稀缺供给驱动、值得跟踪早期使用率的市场机制创新。

**赛道分析：** AI药物发现已从分子生成走向“高质量实验数据+算力+闭环验证”，赛道资金充足但成熟度分化。主要玩家包括Recursion、Schrödinger、Insilico Medicine、Generate Biomedicines、Owkin及云厂商生命科学平台；数据侧还有健康数据网络和各类生物知识库。Harell不直接押注某个药物管线，而卡位模型训练的专有数据基础设施，理论上可横向扩展到材料科学和成像。未来1—2年，公开数据边际收益下降，数据授权与可追溯将更重要；若其leaderboard能证明专有数据带来可重复模型提升，可能成为科学AI的数据交易层，否则容易退化成垂直GPU云。

**关键数据（逐项来源URL+日期）：**
- 融资1,500万美元、Fuse/Cercano、CoreWeave+Nvidia架构、两套首发数据、11人；2026-08-17：[timmermanreport.com](https://timmermanreport.com/2026/08/harell-data-debuts-with-15m-to-change-incentives-speed-up-ai-drug-discovery/)
- Early Access、11人、团队成员、数据不离开安全环境；2026-08-17/18：[geekwire.com](https://www.geekwire.com/2026/adaptive-biotech-co-founder-raises-15m-for-new-startup-to-rethink-how-ai-trains-on-science/)
- Bellevue公司亮相及1,500万美元；2026-08-18：[lifesciencewa.org](https://lifesciencewa.org/2026/08/18/harell-data-debuts-with-15m-to-change-incentives-for-ai-drug-discovery/)
- 官方产品、实时基准/榜单、抗体和T细胞推理场景；访问核验2026-08-19：[harelldata.com](https://harelldata.com/)

**原文链接：**
- 公司官网产品原文：[harelldata.com](https://harelldata.com/)
- Timmerman Report创始人深访（2026-08-17）：[timmermanreport.com](https://timmermanreport.com/2026/08/harell-data-debuts-with-15m-to-change-incentives-speed-up-ai-drug-discovery/)
- GeekWire全文（2026-08-17，美西；上海时间8月18日）：[geekwire.com](https://www.geekwire.com/2026/adaptive-biotech-co-founder-raises-15m-for-new-startup-to-rethink-how-ai-trains-on-science/)
- Life Science Washington（2026-08-18）：[lifesciencewa.org](https://lifesciencewa.org/2026/08/18/harell-data-debuts-with-15m-to-change-incentives-for-ai-drug-discovery/)

**投资/合作视角：** 对拥有实验数据但缺乏AI商业化渠道的生物科技公司，Harell是低泄露风险的合作入口；对模型公司，则可节省谈判和数据清洗成本。投资上应把“数据集独家期、付费训练次数、每GPU小时毛利、数据方续约率”设为下一阶段门槛，而不能仅凭Adaptive创始人光环定价。


#### Palona AI（美国·实体商业多模态智能体/餐饮科技）

> 完整五维研究、关键数据与投资/合作视角详见「本周 TOP 5创业公司」。

#### Portnox（美国·AI智能体身份与零信任网络安全）

**一句话定位：** 在网络层持续验证人类、设备和AI智能体身份，并在风险信号变化时即时阻断、隔离或撤销访问，充当企业AI代理的“kill switch”。

**本周动态（日期与来源）：** 2026-08-18，Portnox官网原始公告与PR Newswire同步发布面向风险AI智能体的网络“断路器”，新增Microsoft Defender集成；此前已有CrowdStrike和SentinelOne。本周SiliconANGLE全文交叉验证：任一端点平台发现威胁或设备不合规后，Portnox策略引擎可实时按客户规则断连、隔离身份或完全撤权，并留下身份、时间、位置、资源与策略审计轨迹。这不是旧闻翻炒，而是产品重大能力更新，发布时间在上海时间窗口内。

**产品深研：** Portnox Cloud原本覆盖云原生NAC、应用条件访问、RADIUS和TACACS+，把网络、SaaS和管理访问统一到零信任策略。新增AI能力面向non-human identities：代理会持续认证、读取敏感数据并机器速度执行任务，传统“一次登录+长期静态凭证”无法控制行为漂移。其三步架构是：Defender/CrowdStrike/SentinelOne产生风险信号；Portnox实时策略引擎结合访问规则重新评估信任；网络执行层自动封锁/隔离/撤权。差异化在于并非又一个只报警的AI安全仪表盘，而是能在身份提供商撤销令牌前从网络层执行。SiliconANGLE引用VentureBeat Q2调查：54%企业已发生确认的代理安全事件，69%仍让代理共享凭证，需求紧迫。

**融资记录：** 2022-01 A轮2,200万美元，Elsewhere Partners领投，用于云原生平台和在Austin设全球总部；2025-04 B轮3,750万美元，Updata Partners领投、Elsewhere参投，Jon Seeber加入董事会，用于产品创新、市场扩张和帮助资源有限的安全团队；累计融资5,950万美元。更早自筹/未披露融资未见可靠金额。历轮估值均未披露，未发现独角兽融资或10亿美元估值证据。需注意Portnox早年源自以色列研发团队，但当前全球总部、CEO与商业运营在Austin，本报告按美国公司口径纳入并明确保留以色列研发中心。

**创始人：** Ofer Amitai为联合创始人，2022年转任CTO并负责以色列工程和国际产品团队；Idan Kuperman为联合创始人兼客户体验负责人。CEO Denny LeCompte是企业IT/安全管理老兵、曾任Elsewhere Partners operating advisor，2022年接任并推动总部迁Austin。技术创始人与增长型CEO组合适合从传统NAC向云原生统一访问扩张。当前精确团队人数未由公司本周披露，写“未披露”；不能用招聘网站估算冒充官方规模。

**竞争力（护城河、地位、增长、风险）：** 护城河是网络执行点、既有设备/身份策略和近1,000家全球客户形成的部署粘性；与三大端点安全平台联动使其成为跨厂商执行层。2025年已有Dr. Martens、Ford Foundation、Enova、ScienceLogic、Talend、Tishman Speyer等客户，2026上半年官方称渠道贡献同比增306%（收入绝对值未披露），显示增长。风险包括Cisco/Aruba/Fortinet/Microsoft等捆绑NAC与身份安全，AI智能体身份标准未定；公司2020年自身曾被入侵，信任恢复是长期审查项。判断：其价值在“最后一公里强制执行”，但需证明AI代理场景产生新增ARR而不只是市场包装。

**赛道分析：** 零信任访问是成熟赛道，AI Agent Security/NHI治理则处于早期爆发。主要玩家包括CyberArk、Okta、Microsoft Entra、Wiz、Palo Alto Networks、Cisco及新兴Astrix、Oasis、Noma Security。多数产品侧重发现密钥、身份权限或行为检测；Portnox卡位网络层即时执行，可与上游检测互补。未来1—2年，企业将为每个Agent配置可撤销身份、最小权限和持续姿态评估，MCP/Agent协议也会催生机器身份标准。Portnox若能成为多云、多模型的中立执行层，有并购和渠道价值；若身份厂商直接控制网络，其空间会受压。

**关键数据（逐项来源URL+日期）：**
- Defender新集成、阻断/隔离/撤权机制；2026-08-18：[portnox.com](https://www.portnox.com/press-releases/portnox-gives-enterprises-a-network-kill-switch-to-instantly-cut-off-risky-ai-agents/)
- 三步架构、54%事件率、69%共享凭证、累计融资约5,950万美元；2026-08-18：[siliconangle.com](https://siliconangle.com/2026/08/18/portnox-adds-microsoft-defender-integration-to-police-ai-agent-access/)
- B轮3,750万美元、近1,000客户、Updata/Elsewhere、累计融资；2025-04-08：[siliconangle.com](https://siliconangle.com/2025/04/08/portnox-raises-37-5-million-scale-cloud-native-zero-trust-access-control/)
- A轮2,200万美元、CEO/创始人职责、Austin总部和以色列研发；2022-01-27：[calcalistech.com](https://www.calcalistech.com/ctech/articles/0,7340,L-3928070,00.html)
- 官方B轮公告（搜索及页面元数据核验，页面受Cloudflare限制）；2025-04-08：[portnox.com](https://www.portnox.com/press-releases/portnox-secures-37-5-million-series-b-funding-to-revolutionize-zero-trust-security-with-unified-access-control/)

**原文链接：**
- 官网本周产品公告（2026-08-18）：[portnox.com](https://www.portnox.com/press-releases/portnox-gives-enterprises-a-network-kill-switch-to-instantly-cut-off-risky-ai-agents/)
- PR Newswire原始分发（2026-08-18）：[prnewswire.com](https://www.prnewswire.com/news-releases/portnox-gives-enterprises-a-network-kill-switch-to-instantly-cut-off-risky-ai-agents-302853478.html)
- SiliconANGLE本周全文（2026-08-18）：[siliconangle.com](https://siliconangle.com/2026/08/18/portnox-adds-microsoft-defender-integration-to-police-ai-agent-access/)
- SiliconANGLE B轮（2025-04-08）：[siliconangle.com](https://siliconangle.com/2025/04/08/portnox-raises-37-5-million-scale-cloud-native-zero-trust-access-control/)

**投资/合作视角：** EDR、IAM、AI Agent平台与托管安全服务商可把Portnox作为实时网络执行器，合作价值明确。投资判断应观察AI身份控制的独立付费率、渠道306%增长能否转成ARR，以及自家安全控制与历史入侵整改；若能证明跨Microsoft/CrowdStrike/SentinelOne中立性，战略价值高于单一NAC倍数。

#### Relay.app（美国·AI工作流自动化，关停案例）

**一句话定位：** 曾以AI步骤、多人协作和human-in-the-loop审批挑战Zapier，如今关停产品、核心团队转入Google Chrome，成为AI自动化赛道产品强但分发/规模化失败的反面样本。

**本周动态（日期与来源）：** 2026-08-15 23:59 PT（上海时间2026-08-16 14:59），Relay按官方关停计划终止所有免费账户并永久删除其数据；2026-08-17，TechCrunch阅读全文报道公司关闭、创始人Jacob Bank及部分员工加入Google Chrome团队，Bank任产品副总裁，负责Chrome产品和开发者关系。付费客户可免费使用至2026-09-14并获未使用年费按比例退款。关停最初于7月宣布，但“免费用户实际停止服务”和“团队流向公开确认”均发生在本周窗口，属于真实重大动态。

**产品深研：** Relay位于Zapier与Asana之间，不只搬运字段，而是编排需要多方参与的重复流程。其AI Autofill负责生成、摘要、抽取与字段填充，AI Classify无需预写全部规则即可做条件路由；每一步可加入人工审批、补充数据或个性化内容，避免敏感动作自动发出。后期产品还能导出Workflow、Sequence、MCP Server的JSON、AI prompts、运行历史和表格CSV，说明架构已从SaaS流程扩展至Agent/MCP编排。差异化human-in-loop曾适合招聘入职、董事会材料、客服分类和财务月报，但并未形成足以独立生存的规模。官方未披露本周活跃用户、收入、付费客户数或关停原因，不能把加入Google等同于收购；TechCrunch也未确认Google购买资产。

**融资记录：** 2022-10种子轮500万美元，Khosla Ventures领投；2023-10追加融资310万美元，Andreessen Horowitz（a16z）领投，累计融资810万美元。公开估值均未披露，没有后续融资或10亿美元估值证据。早期客户包括Ramp、Skyflow、Warp、Motion、Lumos、Tavus。资金主要用于从重复任务清单扩展为完整工作流自动化平台、增加数百个触发器/动作与AI能力。关停后剩余资本、投资人回收、员工转入Google的交易对价均未披露。

**创始人：** Jacob Bank此前创办智能日程应用Timeful，2015年被Google收购；之后在Google超过6年，做过Gmail、Google Calendar、Google Chat产品负责人，2021年离职创办Relay。本周回归Google任Chrome VP Product，方向是让用户在浏览器中与Agent协作。创始人对生产力、日历和工作流高度适配。2023年Relay为11人（美国3人、加拿大1人、欧洲7人，多为前Google合作伙伴）；2026关停时团队总规模和加入Google人数未披露，只能写“部分员工”。

**竞争力（护城河、地位、增长、风险）：** 产品优势是将AI、不确定性决策与人工审批原生组合，且跨应用集成；但集成连接器并非强护城河，Zapier、Make、n8n、Microsoft Power Automate、Gumloop、Lindy和大模型原生工具都能快速复制。公司曾获a16z/Khosla背书和优质早期客户，却最终关停，说明工作流赛道获客、连接器维护和低价竞争可能压垮小团队。风险已兑现为持续经营终止、客户迁移和信任损失。判断：团队人才价值高于独立公司价值，本周更像“人才回流/软着陆”，但无正式收购证据，必须避免写成并购。

**赛道分析：** 工作流自动化是成熟市场，生成式AI把规则流程升级成能理解非结构化内容的Agent，成熟度正从试点走向企业治理。主要玩家包括Zapier、Make、n8n、UiPath、Microsoft Power Automate，以及Gumloop、Lindy、Bardeen、Activepieces等AI原生创业公司。Relay卡位“协作+人工复核”合理，但缺少专属数据、垂直渠道或底层执行壁垒。未来1—2年，浏览器和操作系统会成为Agent入口，Chrome、Microsoft 365等大平台可直接吸收工作流能力；独立厂商需开源、自托管或深耕高价值垂直流程，通用编排层将持续整合。

**关键数据（逐项来源URL+日期）：**
- 免费账户2026-08-15 PT关停、付费账户9月14日关停、退款与导出/删除机制；官网持续公告，窗口事件日2026-08-15：[relay.app](https://relay.app/)
- 创始人及部分员工加入Google Chrome、Bank任VP Product；2026-08-17：[techcrunch.com](https://techcrunch.com/2026/08/17/ai-automation-startup-relay-shuts-down-staff-joins-googles-chrome-team/)
- 种子轮500万美元、追加310万美元、团队11人、AI与human-in-loop架构；2023-10-11：[techcrunch.com](https://techcrunch.com/2023/10/11/relay-a16z-zapier-google/)
- 追加融资310万美元、a16z领投、早期客户；2023-10-15：[thesaasnews.com](https://www.thesaasnews.com/news/relay-app-raises-3-1-million-in-funding/)

**原文链接：**
- 公司关停原文：[relay.app](https://relay.app/)
- TechCrunch本周团队变化全文（2026-08-17）：[techcrunch.com](https://techcrunch.com/2026/08/17/ai-automation-startup-relay-shuts-down-staff-joins-googles-chrome-team/)
- TechCrunch产品/融资深访（2023-10-11）：[techcrunch.com](https://techcrunch.com/2023/10/11/relay-a16z-zapier-google/)
- The SaaS News融资交叉验证（2023-10-15）：[thesaasnews.com](https://www.thesaasnews.com/news/relay-app-raises-3-1-million-in-funding/)

**投资/合作视角：** 不建议以持续经营公司视角投资Relay；更有价值的是分析其团队、human-in-loop设计和Chrome后续Agent产品迁移。合作方/现有客户应立即完成JSON、prompt、运行历史和凭证迁移，并评估n8n/Zapier/Make等替代；任何“Google收购Relay”的说法在官方确认前都应视为未经证实。


### 🇨🇳 中国

#### 奇点智控（中国上海·具身智能力觉传感）

> 完整五维研究、关键数据与投资/合作视角详见「本周 TOP 5创业公司」。

#### 诺仕机器人（中国深圳·机器人精密传动）

**一句话定位：** 以微型行星滚柱丝杠和一体化智能电缸，解决灵巧手、人形机器人线性关节的“小体积、高推力、长寿命”传动瓶颈。

**本周动态（日期与来源）：** 2026年8月13日，诺仕披露近亿元A+轮，顺为资本领投、望千铭诚跟投，资金用于微型行星滚柱丝杠扩产、产品迭代与海外布局。新浪财经完整转载投资界/硬氪原文；凤凰网与亿欧投融资日报同日/次日交叉确认，后者写“数千万”与公司稿“近亿元”口径略有差异，因此本文保留公司正式口径并提示区间不确定。

**产品深研：** 诺仕从丝杠、螺母、滚柱到执行器做正向设计与全套工艺自产，核心是直径1.5mm、螺母直径5.5mm的C5级微型行星滚柱丝杠，重复定位精度±0.01mm、最大承载50N；集成后的U盘体积微型电缸可输出15kg推力。路线价值在于利用丝杠自锁降低电机持续堵转发热和能耗，再把力、位置、温度反馈集成进下一代电缸，形成“机械传动+多传感闭环”。差异化不是只卖标准件，而是掌握高精度金属成型、量产工艺和执行器集成，减少对进口磨床依赖。本周披露已成为灵心巧手微型电缸主力供应商并覆盖头部客户，但收入、产能和良率未披露。

**融资记录：** ①2024-12，数千万元天使轮，成为资本、险峰长青、璞跃中国联合领投，用于交付、商业拓展、招聘；②2025-04披露天使+轮，上汽创投独家投资，金额未披露，用于C5丝杠量产；③2026-03，超亿元A轮，上海半导体装备材料产业基金、浦东科创领投，联想创投、琥珀资本等跟投；④2026-08-13，近亿元A+轮，顺为领投、望千铭诚跟投。公司称累计四轮。各轮投后估值均未披露，未发现十亿美元或以上估值报道，且融资仍处A+轮，符合非独角兽口径。

**创始人：** 徐杨为同济大学机械制造硕士，曾任法雷奥集团，在汽车传动与精密制造有产业经验；联合创始人王晓斌同样来自法雷奥，是连续创业者，曾把团队从0带到Pre-IPO；技术顾问/第一代创始人徐根林教授长期研究丝杠与机械制造，公开来源对其积累描述为30余年至近50年。三者分别补齐理论工艺、汽车级质量体系与商业组织，和精密制造创业高度匹配。团队规模未披露；深圳研发、上海及苏州制造的跨地组织对供应链有利，但管理复杂度上升。

**竞争力：** 护城河是30余年工艺Know-how、C5微型化能力、全工序自产、客户联合验证和扩产后的良率曲线。相较只做样机的团队，诺仕已有头部客户订单和产业资本背书。风险在于人形机器人放量节奏不确定、客户可能自研、精密件扩产时良率下降，以及滚柱丝杠与旋转关节/腱绳等路线仍在竞争。其“丝杠是最终解”是创始人判断，不是行业定论。

**赛道分析：** 全球丝杠是成熟工业品，但机器人微型滚柱丝杠是快速成长期，海外主要玩家包括Rollvis、GSA、Schaeffler，国内鼎智科技、贝斯特、恒立液压等加速进入。顺为援引数据称2024年全球丝杠市场超230亿美元，2030年具身场景滚柱丝杠约298亿元、微型电缸约1069亿元；不同机构预测差异较大，说明终局高度依赖机器人出货。未来1—2年关键是从灵巧手单点切到腕、小臂、颈面等更多自由度，同时用汽车/半导体订单平滑机器人周期。

**关键数据（逐项来源URL+日期）：** ①A+轮、产品参数、客户与市场预测：新浪财经，2026-08-13，[finance.sina.com.cn](https://finance.sina.com.cn/jjxw/2026-08-13/doc-ininctas4819399.shtml)；②天使轮与创始团队：投中网，2024-12-04，[chinaventure.com.cn](https://www.chinaventure.com.cn/news/114-20241204-384152.html)；③天使+轮、C5量产与头部订单：投资界，2025-04-25，[news.pedaily.cn](https://news.pedaily.cn/202504/548861.shtml)；④A轮交叉信息：东方财富，2026-03-11，[wap.eastmoney.com](https://wap.eastmoney.com/a/202603113668651522.html)。

**原文链接：** [finance.sina.com.cn](https://finance.sina.com.cn/jjxw/2026-08-13/doc-ininctas4819399.shtml) ｜ [news.pedaily.cn](https://news.pedaily.cn/202504/548861.shtml) ｜ [chinaventure.com.cn](https://www.chinaventure.com.cn/news/114-20241204-384152.html)

**投资/合作视角：** 这是偏制造兑现的标的，应围绕月产能、Cpk、良率、寿命曲线和客户集中度估值，而非只看“全球最小”。合作方可先以灵巧手小批量导入，再把反馈数据用于电缸闭环迭代；投资人需验证设备资本开支与扩产现金消耗。

#### PandaAI（中国·AI交易基础设施）

**一句话定位：** 把数据、因子研究、策略生成、回测、风控与执行编排为可审计的多智能体工作流，降低量化研究的工程门槛。

**本周动态（日期与来源）：** 2026年8月17日，投资界首发披露PandaAI连续完成种子、天使、天使+三轮，累计数千万元，天使及天使+由L2F光源创业者基金领投；36氪获授权发布全文，亿欧亦在同日独立收录并确认轮次、金额与投资人。本次属于“集中披露历史三轮”而非三轮均在本周交割，实际外部融资始于2025年下半年、两个月完成，时间口径必须区分。

**产品深研：** PandaAI OS面向自然语言策略研究，EVO是A2A多智能体基础设施，QUBE覆盖深度投研，QuantSkills则把专业因子、数据处理和交易技能封装成可复用组件。系统把模糊观点拆成数据获取、因子构建、代码生成、参数调整、回测、风险评估、交易连接等节点，由不同Agent分工并相互反馈；用户能查看数据和中间结果，优于“黑箱荐股”。真正技术难点不是聊天界面，而是点时数据防未来函数、回测可重复、权限隔离、低延迟交易连接和合规留痕。本周披露海内外用户超过10万，正与券商、期货、基金等推进合作，但付费率、资产规模、实盘收益均未披露，不能把用户数等同商业验证。

**融资记录：** 公司2024年创立；2025年下半年首次外部融资，并在随后两个月连续完成种子轮、天使轮、天使+轮；累计数千万元，种子轮投资方未披露，天使及天使+由L2F光源创业者基金领投，单轮金额与估值均未披露。2026-08-17为集中公开日期。本轮/累计资金用于交易大模型、QuantSkills、多智能体基础设施、Agent开发环境、PandaAI OS/EVO/A2A及全球市场。未发现其他轮次，也未见≥10亿美元估值；以数千万元累计早期融资判断属于明显非独角兽，但不推算具体估值。

**创始人：** CEO李昱琦生于1999年，哥伦比亚大学金融工程本硕，20岁开始量化私募创业，仍为量化私募合伙人并参与管理超10亿元；其“量化李不白”IP粉丝超20万，带来低成本获客和交易者需求洞察。CTO刘炳君曾任恒生电子、埃森哲系统架构师，参与中国首个线上证券开户系统核心开发，适配金融级基础设施。团队覆盖量化、AI、金融数据、交易系统和产品工程；人数未披露。优势是创始人懂交易、CTO懂系统，风险是创始人兼任私募角色可能带来利益冲突与数据隔离要求。

**竞争力：** 潜在护城河是用户沉淀的可复用研究工作流、QuantSkills生态、券商连接和真实反馈闭环，而非基础模型本身。10万用户和20万内容粉丝构成早期分发优势。竞争对手既包括聚宽、米筐、BigQuant等量化平台，也包括券商自研Copilot和通用Coding Agent。最大风险是回测过拟合、幻觉生成错误策略、金融监管、行情数据授权、实盘事故责任，以及“高用户低付费”。

**赛道分析：** AI交易平台由问答工具进入Agent编排早期，MRFR 2026年报告估计全球市场2024年约92.56亿美元、2035年649.7亿美元。市场规模口径宽泛，仅作方向参考。PandaAI卡位在研究基础设施而非直接资管，能减少牌照压力，但只要进入交易执行就必须强化适当性、风控和审计。未来1—2年关键是拿到可公布的机构合同、建立策略沙箱/仿真评估标准，并证明付费留存，而不是宣传单次收益。

**关键数据（逐项来源URL+日期）：** ①三轮累计数千万元、产品架构、10万用户、创始人背景：投资界，2026-08-17，[news.pedaily.cn](https://news.pedaily.cn/202608/567741.shtml)；②36氪交叉全文，2026-08-18页面，[36kr.com](https://www.36kr.com/p/3944470122151044)；③亿欧交叉确认，2026-08-17，[iyiou.com](https://www.iyiou.com/news/202608171138240)；④AI交易平台市场预测：Market Research Future，2026-05-15，[marketresearchfuture.com](https://www.marketresearchfuture.com/zh-cn/reports/ai-trading-platform-market-34436)。

**原文链接：** [news.pedaily.cn](https://news.pedaily.cn/202608/567741.shtml) ｜ [36kr.com](https://www.36kr.com/p/3944470122151044) ｜ [iyiou.com](https://www.iyiou.com/news/202608171138240)

**投资/合作视角：** 建议把尽调重点放在付费机构数、净收入留存、回测与实盘偏差、数据授权和安全审计。券商合作可从研究沙箱与私有部署开始，不宜直接让生成式Agent无人工审批下单；若能形成合规工作流标准，平台价值会明显高于单一选股助手。

#### 万卷智能（中国宁波·工程行业智能体）

**一句话定位：** 将资深交通、高铁和房屋工程师的推理流程封装为能读图纸、做计算、写评审材料并连接现场硬件的“数字工程师”。

**本周动态（日期与来源）：** 投资界2026年8月18日全文披露公司完成超千万元Pre-A轮，由天际资本领投，用于研发、市场和出海；亿欧8月18日投融资简报、DoNews 8月17/18页面交叉确认。注意DoNews称注册主体“北京万卷智能”，投资界称“万卷智能（宁波）有限公司”，本文以融资原文主体为准，关联主体结构需工商尽调核实。

**产品深研：** 核心不是通用办公Agent，而是以顶尖工程师思维链做启发式训练，让Agent自主规划、推理、执行。交通产品采用“1+8+1”：一个超级助手、风险专评/方案编制/图纸复核等八类专业能力、一个Pocket Engineer便携终端；后者在工地采集照片、视频和语音，结合项目资料计算分析并自动生成台账。公司同时拓展高铁运维与房屋体检/合约成本管理，目标覆盖工程师50%内业+50%外业中的80%以上工作量。技术架构可理解为多模态采集、行业知识/RAG、专业工具调用、长任务Agent和成果文档生成。已在6省数十个真实项目投入使用；年初披露超过20家企业订阅。需要警惕“覆盖80%”为公司表述，尚无第三方准确率或节省工时审计。

**融资记录：** ①2026-01披露1000万元天使轮，见识资本独家投资；②2026-08-18披露超1000万元Pre-A轮，天际资本领投，产业方嘉涵实业表述为跟投/合作方，但原文未完整列出全部投资人，按“其他未披露”处理。用途为加速研发、拓展市场、探索出海。更早融资：未查到。投后估值：未披露；累计公开融资约“2000万元以上”，没有任何十亿美元估值证据，明显处于早期非独角兽阶段。

**创始人：** CEO李天翔为浙大本科、博士，国家公派至UBC Smart Structure Lab联合培养，曾参与住建部智能建造标准体系课题，并在新加坡仁恒置地任职，兼具结构工程、政策标准和项目全生命周期管理，和工程Agent问题高度适配。CTO卢立群为UIUC博士、前阿里AI高级专家，有大模型工业部署经验，历史项目披露供应链降本20%、追踪效率提升50%。COO葛明辉有央企及十年以上产业项目管理经验。团队规模未披露。

**竞争力：** 护城河应来自工程专家流程数据、项目知识图谱、专业评测集、国央企实施经验和软硬一体现场入口，而不是模型参数。客户资料极其封闭，越早获得真实项目反馈越可能形成数据飞轮。风险包括长任务错误累积、图纸/规范版本幻觉、工程责任归属、项目制交付拖累毛利，以及政府/基建客户回款周期。多赛道扩张到交通、高铁、房屋也可能稀释早期研发。

**赛道分析：** 建筑工程AI正从BIM识别走向能交付完整成果的垂类Agent，成熟度仍在早期。竞争来自广联达等工程软件巨头、设计院自研系统及通用模型厂商。Fortune Business Insights 2026年7月估计全球建筑AI市场2025年48.6亿美元、2034年355.3亿美元，CAGR 24.8%；不同机构口径差异较大。万卷以“工程师工作流+现场终端”卡位，未来1—2年必须证明标准化部署、可追责审核链和跨项目复用率，才能从咨询项目转向软件收入。

**关键数据（逐项来源URL+日期）：** ①Pre-A金额、产品架构、6省数十项目与团队：投资界，2026-08-18，[news.pedaily.cn](https://news.pedaily.cn/202608/567787.shtml)；②亿欧交叉确认，2026-08-18，[iyiou.com](https://www.iyiou.com/briefing/202608181929902)；③天使轮1000万元、20+订阅客户、COO背景：凤凰网转硬氪/投资界，2026-01-28，[i.ifeng.com](https://i.ifeng.com/c/8qHPu8GWMvm)；④建筑AI市场规模：Fortune Business Insights，2026-07-27，[fortunebusinessinsights.com](https://www.fortunebusinessinsights.com/zh/ai-in-construction-market-109848)。

**原文链接：** [news.pedaily.cn](https://news.pedaily.cn/202608/567787.shtml) ｜ [iyiou.com](https://www.iyiou.com/briefing/202608181929902) ｜ [i.ifeng.com](https://i.ifeng.com/c/8qHPu8GWMvm)

**投资/合作视角：** 适合用“单项目节省工时—复购—跨项目复用”三段指标验证，尤其要看毛利和回款。工程集团可先从图纸复核、报告初稿等有人审闭环场景切入；投资人应要求主体结构、客户合同、错误责任和数据合规清单。

#### 灵锶智能（中国深圳·工业四足机器人）

**一句话定位：** 以重载四足机器人切入电力、石化、警用与应急等高危刚需场景，强调关节、运动控制和AI感知全栈自研。

**本周动态（日期与来源）：** 2026年8月18日，公司宣布7000万元战略融资，由中山高新智光创业投资基金（中山创业投资有限公司）领投，资金投向新一代产品、智能产线扩产和国内外渠道。投资界全文、投中网和新浪财经同日交叉确认，亿欧8月19日投融资日报亦记录7000万元。本轮是明确落在窗口内的新增融资。

**产品深研：** 主力D50/重载机器狗面向巡检、安防和救援，公开实测口径为自重约60—65kg、稳定/长时负载50kg、瞬时120kg（官网展示称超100kg），具IP67和宽温能力的报道，但后两项来自行业报道，合作前需查检测证书。架构由自研关节模组、运动控制、感知融合、自主导航和行业载荷接口组成，模块化平台可延展到机械臂、灵巧手及其他移动构型。公司强调“测距感知融合”处理野外GNSS缺失与复杂地形，比消费/表演机器狗更偏工业可靠性。本周数据为已在电力巡检、石化安防、应急救援等行业批量落地；2025年权威采访披露已量产数百台、研发占比近80%，但本周未更新累计出货和营收。

**融资记录：** 公开检索仅能可靠确认2026-08-18这轮7000万元战略融资，中山国资产业基金领投；更早是否存在未公开股权融资：未披露。资金用途为研发、扩产和渠道。轮次被称为“新一轮战略融资”，但历史轮次、累计金额、投后估值和其他股东均未披露，不能编造。未见任何来源称其估值达到10亿美元；以7000万元战略轮、数百台量产规模和非上市状态看符合本组非独角兽筛选，但具体估值仍标“未披露”。

**创始人：** CEO/创始人肖恺，公开报道显示其持续主导产品与场景战略并在ICRA 2026分享野外自主技术；个人学历、前职未获可靠公开披露。融资稿称核心成员来自卡内基梅隆、哈工大、中科院，并汇集小鹏、广汽、宁德时代人才，兼具算法、汽车工程与量产经验；研发人员占比近80%，总人数未披露。团队对“工业硬件+智驾算法”适配较强，但创始人履历透明度是尽调缺口。

**竞争力：** 护城河是重载关节与运动控制、真实高危场景数据、工程化量产和大湾区供应链，而非炫技动作。相较宇树等通用平台，灵锶更聚焦高负载行业方案；相较传统巡检机器人，越障与多载荷能力更强。风险包括工业客户项目周期长、维护成本高、四足在平整场景不如轮式经济、宇树/云深处/ANYbotics竞争，以及海外关键场所的数据安全审查。

**赛道分析：** 四足机器人已从科研演示进入早期规模化，主要玩家有宇树、云深处、蔚蓝、波士顿动力、ANYbotics。IDC 2025年称全球市场超1.8亿美元、约2万台，中国厂商依靠供应链和价格领先；GGII预测中国2030年销量接近40万台、规模超48亿元，2024—2030年销量CAGR超50%。灵锶卡位重载和高危工业，不必与轻型消费机拼价格。未来1—2年关键是形成标准行业套件、经销/服务网络和可量化ROI，并提高软件服务收入。

**关键数据（逐项来源URL+日期）：** ①7000万元融资、用途、团队来源与批量落地：投资界，2026-08-18，[news.pedaily.cn](https://news.pedaily.cn/202608/567811.shtml)；②投中网交叉确认，2026-08-18，[chinaventure.com.cn](https://www.chinaventure.com.cn/news/114-20260818-392810.html)；③公司产品/应用官方页面（访问核验2026-08-19，页面条目日期2026-06-03等）：[gdlinxai.com](https://www.gdlinxai.com/)；④量产数百台、研发占比近80%、负载参数：21世纪经济报道，2025-06-23，[21jingji.com](https://www.21jingji.com/article/20250623/herald/b50a530d9e001a4772b36ed44ef8595d.html)；⑤全球四足市场数据：IDC，2025-06-26，[mfe-prod.idc.com](https://mfe-prod.idc.com/getdoc.jsp?containerId=prCHC53644125)。

**原文链接：** [news.pedaily.cn](https://news.pedaily.cn/202608/567811.shtml) ｜ [chinaventure.com.cn](https://www.chinaventure.com.cn/news/114-20260818-392810.html) ｜ [gdlinxai.com](https://www.gdlinxai.com/) ｜ [21jingji.com](https://www.21jingji.com/article/20250623/herald/b50a530d9e001a4772b36ed44ef8595d.html)

**投资/合作视角：** 应按行业订单质量而非演示视频判断：核查付费出货、复购、故障间隔、现场可用率和售后成本。中山国资可带来制造与场景资源；潜在合作方宜以电力/石化单场景验收指标试点，再扩为多载荷平台。


### 🇪🇺 欧洲与以色列

#### Pathway（波兰/法国·实时AI数据基础设施与后Transformer模型）

> 完整五维研究、关键数据与投资/合作视角详见「本周 TOP 5创业公司」。

#### amber（德国·企业知识管理与自主业务AI）

**一句话定位：** amber为欧洲中型企业搭建“先治理数据、再调用大模型”的AI Data Layer，把分散知识转成可检索、可授权、最终可由代理执行的业务上下文。

**本周动态（日期与来源）：** 2026-08-17，公司官网及投资方Ventech全文公告700万欧元A轮，由Ventech与NRW.Venture（NRW.BANK旗下基金）共同领投；资金用于从德国向比荷卢扩张、扩充团队、加深企业系统集成并把用户触发的助手演进为主动执行任务的自主AI。Tech.eu和Vestbee同日/本周报道交叉确认金额、轮次、投资者和用途。估值、各投资者持股与收入均未披露；因此只可判断公开资料未显示其达到独角兽门槛，不能反推估值。

**产品深研：** amber连接邮件、文档、云应用、ERP/CRM及内部系统，先在专有AI Data Layer中对实体、权限、关联和业务语境进行连接、结构化与上下文化，再将相关片段供LLM推理。这一路线实质是“企业知识图谱/检索治理层+生成式AI+工作流代理”，解决普通RAG因数据碎片、权限泄漏和上下文不全而答非所问的问题。其插件式架构兼容欧美软件、云与本地部署，保留既有访问权限；公司称客户搜索时间可降低40%以上，2025年已有200多家德奥瑞中小企业使用。当前产品仍以提问、检索、洞察和辅助流程为主，本轮目标是让系统识别待办并跨系统调用动作。差异点是面向Mittelstand的低IT门槛、GDPR/ISO27001与数据主权，而非训练自己的通用大模型。

**融资记录：** 2021年以ambeRoad名称获得5位商业天使的pre-seed，金额未披露；2025-03-25完成210万欧元种子轮，Ventech领投、天使跟投，用于扩展AI搜索、companyGPT、助手及工作流自动化；2026-08-17完成700万欧元A轮，Ventech与NRW.Venture共同领投，用于欧洲扩张、团队和AI Data Layer/集成。三轮累计可确认金额至少910万欧元，另加未披露pre-seed；历次估值均未披露。官方称Ventech是首个机构投资者，距A轮约18个月再次加注。

**创始人：** 2021年由RWTH Aachen校友Philipp Reißel（CEO）、Bastian Maiworm（CRO）和Igli Manaj共同创办。团队把Maiworm经营家族企业时对“隐性知识流失”的体验，与RWTH的AI研究结合，创始人—问题适配度较高：既理解德国制造业采购、权限与部署限制，又有数据/AI工程能力。2025年官方披露团队30人，位于亚琛和科隆；此后新增地拉那办公室，但2026最新准确人数未披露（LinkedIn页面展示约53名关联员工仅可作旁证，不等同审计口径）。

**竞争力：** 护城河来自跨系统连接器、权限继承、积累的中型企业数据映射模板及200+客户部署经验；Scheidt & Bachmann、Ritter Sport、Zentis、Dalli、Hailo等客户验证其对制造和消费品行业的适配。相比Microsoft Copilot、Glean、Moveworks或Aleph Alpha生态，amber更强调欧洲数据主权和本地/混合系统。风险在于通用办公套件快速补齐连接与代理功能、SME客单价和实施成本不匹配，以及从“可靠检索”跨到“自主写操作”后权限、审计、误操作责任陡增。公司未披露收入与2026客户净增长，增长质量仍需尽调。

**赛道分析：** 企业知识助手已从试验期进入规模部署早期，市场玩家包括Glean、Microsoft 365 Copilot、Google Agentspace、Coveo及欧洲本土主权AI供应商。技术焦点从向量搜索转向上下文工程、权限图谱、代理注册与可观测性。amber的卡位是欧洲约数千万SME中IT资源有限但数据复杂的一层，避开超大型企业正面竞争。未来1—2年，胜负取决于连接器覆盖、部署周期、可量化ROI和自主代理的安全治理；若能把制造业模板产品化并在比荷卢复用，可能形成区域型平台，否则容易成为高实施服务商。

**关键数据（来源URL+日期）：**
- 700万欧元A轮、共同领投、用途、客户名单：Ventech，2026-08-17，[ventechvc.com](https://www.ventechvc.com/stories/amber-raises-eu7-million-to-define-the-next-paradigm-of-business-ai-for-europe)
- 官方德文公告、AI Data Layer与三地布局：amber，2026-08（公告页面），[amber.de](https://amber.de/series-a/)
- 210万欧元种子轮、200+ SME、搜索节省40%+、30人：Ventech，2025-03-25，[ventechvc.com](https://www.ventechvc.com/stories/ambersearch-secures-eu2-1m-from-ventech-to-accelerate-ai-adoption-for-smes)
- 三次融资、估值/收入未披露：Trending Topics，2026-08-17，[trendingtopics.eu](https://www.trendingtopics.eu/amber-ai-startup-for-smes-raises-7-million-euros/)

**原文链接：**
- 公司A轮公告全文：[amber.de](https://amber.de/series-a/)
- 投资方A轮公告全文：[ventechvc.com](https://www.ventechvc.com/stories/amber-raises-eu7-million-to-define-the-next-paradigm-of-business-ai-for-europe)
- 公司2025种子轮产品说明：[amber.de](https://amber.de/en/seed-funding/)
- Tech.eu交叉报道：[tech.eu](https://tech.eu/2026/08/17/amber-raises-eur7m-to-expand-its-ai-powered-business-knowledge-platform/)

**投资/合作视角：** 合作方可优先用售后知识、工程变更与新人入职等低风险只读场景验证40%节时，再逐步开放写操作。投资上看重其连接器和行业模板复用率，应重点索取ARR、部署毛利、200+客户的活跃/续费分布及代理误操作治理数据；若这些指标健康，700万欧元A轮提供了相对克制的欧洲扩张窗口。

#### DiscreteStack（保加利亚·主权/私有AI基础设施）

**一句话定位：** DiscreteStack把开放权重模型编译、调度和治理成可在单台企业服务器或隔离环境运行的“私有AI操作系统”，用固定年费替代按token租用云端智能。

**本周动态（日期与来源）：** 公司官网页面标注2026-08-17正式公告完成80万欧元种子轮，CleverPine Ventures领投，战略天使Milen Manev（Next Solutions/RE:Benefit）与Stoil Vasilev（Paypercut）等参与；资金用于金融、保险、公共部门扩张及新增GPU资源。Vestbee在本周较早发布的报道和The Recursive于2026-08-18的全文报道均交叉确认金额、轮次、投资方及用途。估值未披露；公司成立不足一年且仅80万欧元种子轮，公开资料不存在独角兽迹象。

**产品深研：** 产品不训练基础模型，而是选用领先开放权重模型，为客户具体GPU拓扑编译驱动、attention backend、原生精度优化、tensor布局和内存方案，再以预测式准入队列、非对称节点路由、GPU-CPU混合推理、缓存和并发调度提高利用率；上层提供身份、数据连接器、逐用户审计与用量洞察。可部署于自有数据中心、私有云或完全air-gapped环境。公司自报相较vanilla inference，同芯片吞吐最高13倍、缓存命中率90%+、decode速度4.3倍、并发3.2倍；这些数据尚无第三方基准，必须视为待验证营销指标。单机化让成本从token变量支出变成每执行节点年度许可，并让夜间闲置GPU承载索引、批推理和代理任务。

**融资记录：** 目前可核实的机构融资只有本次2026-08种子轮80万欧元；领投CleverPine Ventures，Milen Manev、Stoil Vasilev及其他未具名投资者参与。此前外部融资金额/轮次未披露，估值未披露，累计可确认融资即80万欧元。资金明确投向监管行业GTM与GPU研发容量。需披露一个潜在关联：创始人此前创建并壮大CleverPine，而本轮领投方名为CleverPine Ventures；公开报道未说明治理/关联交易结构，尽调应核验基金独立性和定价过程。

**创始人：** Hristo Todorov是唯一公开创始人兼CEO，早期在电信与金融科技任工程师，2015年共同创办东欧首家Google认证开发机构Upnetix并于2018年退出；随后把CleverPine扩到110多名工程师，为航空、金融科技和企业软件交付关键系统，并与Lufthansa Technik组建VAeroLabs。该履历与“监管企业可运营AI”高度适配，强项是生产工程和企业交付而非前沿模型训练。官网公开领导层包括产品负责人Stoyan Yanev、两位Lead Engineer、财务运营和市场负责人，另有两名顾问；准确全职团队总数未披露。

**竞争力：** 护城河候选是专利申请中的硬件优化、针对客户机器的编译产物、调度遥测及监管行业交付经验；EU公司主体、air-gap、ISO 27001/9001/42001和固定成本对政府/金融采购具有明确卖点。成立八个月已称获得保加利亚及国际首批企业客户，并获EIC Accelerator Seal of Excellence、加入190+成员的AI Partnership Corporation及NVIDIA Inception。风险是vLLM、SGLang、TensorRT-LLM等开源/厂商栈迭代极快，13倍优势可能被复现；单机无法覆盖所有超大模型和峰值并发，硬件采购、现场支持会压低软件毛利，专利状态也只是pending。

**赛道分析：** 欧盟AI Act全面执行、US CLOUD Act顾虑和推理成本上升推动主权AI从政策概念进入采购期。主要替代包括Azure/AWS私有方案、NVIDIA AI Enterprise、Red Hat/OpenShift AI、欧洲云OVHcloud/IONOS及企业自建vLLM。DiscreteStack卡位在“不想给美系API数据、又养不起ML平台团队”的中型监管机构。未来1—2年需要把单机性能做成公开可复现矩阵，建立硬件/OEM与系统集成商渠道，并证明升级、漏洞修复和模型治理可在air-gap下持续完成；否则易被压缩成项目制集成商。

**关键数据（来源URL+日期）：**
- 80万欧元种子轮、用途、投资者：公司官网，2026-08-17，[discretestack.com](https://discretestack.com/blog/discretestack-raises-e800000-to-give-european-businesses-their-own-ai-infrastructure)
- 成立于2025、单机/离线部署、专利申请中优化：Vestbee，2026-08-14左右（本周页面），[vestbee.com](https://www.vestbee.com/insights/articles/discrete-stack-raises-800k)
- 成立八个月、首批客户、EIC/NVIDIA Inception/190+联盟：The Recursive，2026-08-18，[therecursive.com](https://www.therecursive.com/bulgarian-discretestack-secures-seed-funding-for-european-ai-infrastructure/)
- 13倍吞吐、90%+缓存、4.3倍decode、3.2倍并发（均为公司自报）：公司产品首页，抓取于2026-08-19，[discretestack.com](https://discretestack.com/)

**原文链接：**
- 官方融资公告：[discretestack.com](https://discretestack.com/blog/discretestack-raises-e800000-to-give-european-businesses-their-own-ai-infrastructure)
- 官方产品架构全文：[discretestack.com](https://discretestack.com/)
- 官方创始人/团队页：[discretestack.com](https://discretestack.com/about)
- The Recursive深度报道：[therecursive.com](https://www.therecursive.com/bulgarian-discretestack-secures-seed-funding-for-european-ai-infrastructure/)
- Vestbee交叉报道：[vestbee.com](https://www.vestbee.com/insights/articles/discrete-stack-raises-800k)

**投资/合作视角：** 适合以监管数据、代码助手或内网知识问答做单服务器POC，并与同硬件vLLM基线盲测吞吐、延迟、能耗和三年TCO。投资前应核验专利权利要求、80万欧元 runway、客户是否付费及领投方与创始人旧公司的关系；若性能可复现，欧洲系统集成商/OEM渠道比直接扩销售团队更能放大这笔小额种子资金。

#### STRGY AI（芬兰·AI战略执行与管理软件）

**一句话定位：** STRGY AI用StrategyOS把年度战略拆成可持续观测的日常执行图，面向Chief of Staff、战略负责人和COO自动发现偏航并生成董事会级报告。

**本周动态（日期与来源）：** 2026-08-12，STRGY AI通过PR Newswire发布原始融资公告：获得100万欧元天使融资，私人投资者来自英国、挪威、瑞士和芬兰，Innovestor Angel CoFund提供股权资金，Business Finland提供非稀释支持；资金用于商业团队、产品开发和增长，并计划年内推出更多产品。Tech.eu于同日、Finnish AI Region于2026-08-13交叉确认金额、融资性质、投资来源与用途。部分二手稿称“seed”，但公司原文明确为angel funding，本报告采用官方口径。估值未披露。

**产品深研：** StrategyOS针对战略执行长期依赖PPT、季度复盘和人工汇报的问题，将公司战略优先级与日常工作/进度连接，持续展示执行是否推动目标、提前标记偏航、保持跨团队对齐并自动形成board-ready reporting。目标用户是中型企业Chief of Staff、Head of Strategy和COO，早期客户来自消费品牌与PE被投企业，另有企业部署进行中。产品名称及团队岗位显示其将代理系统与“agentic design”用于信息汇集、判断和报告，但公司本周全文未披露底层模型、连接器清单、数据存储、评价体系或人在回路架构，故不能把营销词扩写为自研模型。核心差异应被验证为“战略语义模型+持续证据链+管理工作流”，否则很容易只是LLM套壳的OKR仪表盘。

**融资记录：** 公司2026年成立；当前唯一公开可核实融资为2026-08-12的100万欧元天使轮。私人投资者跨英、挪、瑞、芬，公告具名投资者包括试用产品后投资的管理者/董事Maryne Lemvik；另有Innovestor Angel CoFund股权参与及Business Finland非稀释资助，但两部分各自金额未披露。此前融资未披露，估值未披露，累计可确认外部资金为100万欧元（公告未说明其中是否把非稀释资金计入总额，尽调需拆分）。用途为商业化、产品与增长。

**创始人：** 官方将Samuli Bäck列为联合创始人兼CEO、Anton Skarp为联合创始人；核心创始团队还包括Head of Agentic Systems Oskari Listomaa和Head of Agentic Design Niko Savander。公开职业资料显示Skarp拥有赫尔辛基大学统计学硕士背景，并做过B2B SaaS后端、集成、机器学习和基础设施，适合技术落地；Bäck负责把战略执行痛点转成商业产品。对Bäck、Listomaa、Savander更完整的前职和成功项目，本次可靠来源未充分披露，不能编造。公告仅明确4人核心阵容，准确团队规模未披露；现阶段是小型创始团队配合新增商业招聘。

**竞争力：** 潜在护城河不是通用生成能力，而是战略目标—业务活动映射、历史决策/偏航数据、董事会报告模板及在PE组合公司中的多企业复制。跨四国天使和由实际试用者转投资者，提供早期需求信号；但客户名称、收入、留存、节省工时和判断准确率均未披露。最大风险是Asana、WorkBoard、Quantive、Cascade、Jira/Atlassian Intelligence和Microsoft Copilot都可加入战略汇总；若无法证明数据连接深度及偏航预警优于人工，产品会被视作可选管理层工具。另一个风险是AI把噪声包装成“战略洞察”，导致错误升级。

**赛道分析：** OKR/战略执行软件已成熟，但生成式AI推动其从手动录入仪表盘向自动读业务证据、解释偏差和建议行动迁移，处于新一轮产品重构早期。主要玩家包括WorkBoard、Quantive、Cascade、Betterworks，以及项目管理套件的AI功能。STRGY AI卡位中型企业和PE被投公司：这类组织既需要快速形成董事会可见性，又缺少大型战略办公室。未来1—2年必须完成主流项目、CRM、财务和HR系统连接，建立可追溯引用与权限，并用“发现偏航提前多少天/报告节省多少小时/目标完成率变化”证明价值；否则低代码和办公套件会迅速商品化其功能。

**关键数据（来源URL+日期）：**
- 100万欧元天使轮、四国投资者、Innovestor/Business Finland、用途、4人核心团队：STRGY AI原始新闻稿，2026-08-12，[prnewswire.com](https://www.prnewswire.com/news-releases/strgy-ai-raises-1m-to-bring-always-on-strategy-execution-to-growing-companies-302848311.html)
- 目标用户、偏航预警、早期消费品牌/PE客户：Tech.eu，2026-08-12，[tech.eu](https://tech.eu/2026/08/12/strgy-ai-raises-eur1m-to-scale-its-ai-powered-strategy-execution-platform/)
- 成立于2026、企业部署及融资公告日期：Finnish AI Region，2026-08-13，[fairedih.fi](https://www.fairedih.fi/en/2026/08/13/helsinki-startup-strgy-ai-raises-e1m-in-angel-funding-for-ai-strategy-platform/)
- 公司注册号3559076-8及赫尔辛基地址：STRGY官网，抓取于2026-08-19，[strgy.com](https://www.strgy.com/)

**原文链接：**
- 公司原始融资稿全文（PR Newswire承载）：[prnewswire.com](https://www.prnewswire.com/news-releases/strgy-ai-raises-1m-to-bring-always-on-strategy-execution-to-growing-companies-302848311.html)
- 公司官网：[strgy.com](https://www.strgy.com/)
- Tech.eu交叉报道：[tech.eu](https://tech.eu/2026/08/12/strgy-ai-raises-eur1m-to-scale-its-ai-powered-strategy-execution-platform/)
- Finnish AI Region报道：[fairedih.fi](https://www.fairedih.fi/en/2026/08/13/helsinki-startup-strgy-ai-raises-e1m-in-angel-funding-for-ai-strategy-platform/)

**投资/合作视角：** 最合适的设计伙伴是同时管理多家公司的PE运营团队，可用同一模板比较目标、证据与偏航，并快速产生跨客户数据网络效应。投资判断应等待3—6个月内客户具名案例、连接器深度、月活管理者、预警采纳率和续费；100万欧元足够验证产品市场匹配，但不足以同时重投入研发与四国销售，必须聚焦一类买家。

### 🌏 其他地区

#### Rezolv（印度·AI借贷基础设施/智能催收）

> 完整五维研究、关键数据与投资/合作视角详见「本周 TOP 5创业公司」。

#### Peripheral（加拿大·体育空间智能/三维视频）

**一句话定位：** Peripheral把自动驾驶感知与神经渲染迁移到体育场，用少量普通相机和大型重建模型（LRM）把二维直播快速还原为可自由导航、可测量的三维比赛空间。

**本周动态（日期与来源）：** 公司于2026-08-17通过Business Wire发布新增**870万美元种子融资**，Inovia Capital与Deloitte Ventures共同领投，Khosla Ventures和Entrepreneurs First跟投；BetaKit于8月18日完整报道并确认总融资**1250万美元**。资金将扩充工程团队、加速联赛和场馆部署，并在2026年稍晚推出首款面向消费者的浏览器回放系统。融资发生于公司向NBA、WNBA官员演示技术并参与NBA Launchpad测试之后，属于产品验证与资本事件同步。

**产品深研：** Peripheral的核心不是摄像头硬件，而是实时3D LRM：多台机位采集二维帧，模型结合标定、深度/姿态估计、跨视角对应与神经渲染，生成可任意改变观察角度的照片级体积视频。其36台普通相机实验场可做全场采集，65点追踪测量球员姿态、出手轨迹和释放动作；早期技术说明称把传统体积捕捉所需100多台相机降至最少约32台，直接降低场馆改造与运营成本。输出一端服务转播——冻结关键时刻、跟随持球队员、游戏化观看；另一端服务教练、裁判和运动科学——分析手指、膝踝屈曲，辅助动作优化、伤病预防及出界判罚。差异化在于把自动驾驶的机器人感知、实时性和大空间鲁棒性用于“流动型体育”，而非棚拍式体积视频。

**融资记录：** 2024年成立初期另有约25万美元前置资本（依据BetaKit 2026年5月报道中“累计385万美元、其中360万美元种子轮”的差额，具体轮次/投资方未披露）；2025-05种子轮360万美元，Khosla Ventures领投，Daybreak Capital、Entrepreneurs First、Transpose Platform参投；2026-08-17种子扩展轮870万美元，Inovia与Deloitte Ventures共同领投，Khosla、Entrepreneurs First参投；公司本周口径累计1250万美元。估值与资金用途拆分未披露；已知用于工程招聘、降低系统成本/延迟、提高重建分辨率及联赛与场馆部署。

**创始人：** CEO Kelvin Cui与CTO Mustafa Khan均为多伦多大学机器人专业背景，曾共同建造自动驾驶赛车并获奖。Cui曾在Cisco、AMD、无人驾驶飞机公司Ribbit及Tesla底盘系统工作；Khan曾任Huawei和Vector Institute研究岗位。二人既懂多传感器几何和边缘实时系统，又是体育参与者/球迷，因此“从自动驾驶转体育”不是表面换场景，而是把成熟感知能力放到资本强度更低、可先产生媒体收入的市场。团队从2025年底约10名工程师增至2026年5月近20人；本轮后计划继续扩招。

**竞争力：** 技术护城河来自跨场馆、不同照明、遮挡和高速动作的多视角训练数据，以及从32—36台普通相机做到实时高保真重建的系统工程；商业护城河则来自联盟测试、场馆集成和多年合同。NBA Launchpad、QSLA北美首个非NBA竞技篮球生物力学实验室及猛龙社媒“数百万观看”提供早期信号。风险包括实时算力成本、相机同步/标定维护、转播权与球员生物数据权属，以及Apple/Meta等空间媒体平台或Arcturus等体积视频厂商下压。更关键的是，炫酷视角是否能持续提升付费和留存仍未证明。

**赛道分析：** 体育空间计算介于计算机视觉、转播科技和运动分析三类市场，目前是技术可用但商业模式未定型的早期阶段。Sony Hawk-Eye、Second Spectrum、Pixellot、Arcturus及传统多机位自由视角方案覆盖裁判、追踪、自动制作和体积内容。Peripheral选择篮球作为高频测试床，再扩展冰球、网球、羽毛球、排球，最终进入足球/美式橄榄球大场馆，卡位顺序合理。未来1—2年，浏览器回放若降低终端门槛，可把B2B基础设施延伸为B2B2C；但真正决定地位的是每场部署成本、端到端延迟、覆盖遮挡时的误差，以及能否拿到联赛长期权利。判断：它是少数兼顾媒体体验与可量化生物力学的团队，但仍处于项目制向平台化转折点。

**关键数据（逐项来源URL+日期）：**
- 本轮870万美元、累计1250万美元、投资方、产品发布与NBA/WNBA演示：BetaKit，2026-08-18，[betakit.com](https://betakit.com/peripheral-nets-8-7-million-usd-to-bring-spatial-intelligence-tech-to-sports/)
- 官方融资公告：Business Wire，2026-08-17，[businesswire.com](https://www.businesswire.com/news/home/20260817508636/en/Peripheral-Raises-%248.7M-co-led-by-Inovia-Capital-and-Deloitte-Ventures-to-Expand-Spatial-Intelligence-Platform-for-Live-Sports)
- 36台相机、近20人、65点追踪、LRM、NBA Launchpad与创始人详细背景：BetaKit，2026-05（文章页），[betakit.com](https://betakit.com/peripheral-establishes-first-biomechanics-basketball-shooting-lab-in-toronto/)
- 最少约32台相机、初轮360万美元、当时10名工程师、竞品Arcturus：TechCrunch，2025-12-18，[techcrunch.com](https://techcrunch.com/2025/12/18/peripheral-labs-taps-into-self-driving-car-sensors-to-bring-sports-fans-right-into-the-game/)
- 公司产品入口：Peripheral官网，访问/核验于2026-08-19，[peripheral.so](https://www.peripheral.so/)

**原文链接：** [businesswire.com](https://www.businesswire.com/news/home/20260817508636/en/Peripheral-Raises-%248.7M-co-led-by-Inovia-Capital-and-Deloitte-Ventures-to-Expand-Spatial-Intelligence-Platform-for-Live-Sports) ；[betakit.com](https://betakit.com/peripheral-nets-8-7-million-usd-to-bring-spatial-intelligence-tech-to-sports/) ；[betakit.com](https://betakit.com/peripheral-establishes-first-biomechanics-basketball-shooting-lab-in-toronto/) ；[techcrunch.com](https://techcrunch.com/2025/12/18/peripheral-labs-taps-into-self-driving-car-sensors-to-bring-sports-fans-right-into-the-game/) ；[peripheral.so](https://www.peripheral.so/)

**投资/合作视角：** 投资应重点索取单场GPU/带宽成本、安装工时、延迟与付费联赛合同，而不是把社媒观看量等同收入。对场馆、转播商或体育学院，最合适的是从固定训练馆和回放切入，复用同一数据同时服务教练、裁判与粉丝；多用途收入若成立，能显著改善昂贵采集系统的单位经济性。

#### Clerq（加拿大·法律AI/专利智能）

**一句话定位：** Clerq（原NLPatent）是面向专利律师与企业IP团队的“AI法务助理”，以自研专利语言模型和检索引擎为底座，在律师监督下端到端完成可引用、可审阅的专利研究工作。

**本周动态（日期与来源）：** 2026-08-18，公司正式从NLPatent更名为Clerq，并上线首批智能体工作流：批量发明披露的快速分诊，以及按技术特征逐项推理、附引文的完整可专利性报告；公司称可把原需数天或数周的任务压至约10分钟。同期宣布与专利风险管理商RPX、翻译/海外申请服务商Park IP双向集成，并聘请前USPTO审查员、Murgitroyd 30人检索团队负责人Michael Chernoff任IP战略总监。官方PR Newswire原文、BetaKit和SiliconANGLE均于8月18日交叉确认。

**产品深研：** 旧产品解决关键词检索无法理解发明语义的问题：用户用自然语言描述技术，领域调优语言模型在数亿件专利与非专利文献中做语义检索、监控、景观分析和可视化。新Clerq在该“研究引擎”上增加任务规划、证据检索、特征拆解、对比推理、报告生成与引用验证的智能体层，而非把通用聊天模型套在专利数据库上。上线工作流输出完整的可专利性意见材料，但明确保留律师复核；下一步为无效性和自由实施（FTO）分析。架构差异包括：五年专利专用检索基础、自研模型私有云运行、不用客户数据训练、ISO 27001和SOC 2 Type II。RPX与Park IP把研究能力嵌入风险管理、翻译和海外申请执行链，强化从孤立工具到IP操作层的定位。

**融资记录：** 2023-10完成**100万加元股权种子轮**，Storytime Capital领投，The LegalTech Fund和The51参投；其后通过SAFE累计**40万加元**，具体日期和投资方拆分未披露。2025-09完成**300万美元**全股权、全一级融资（2025-11-11对外公布），Draper Associates与Mighty Capital共同领投，The LegalTech Fund、Storytime Capital、The51跟投，用于北美/欧洲扩张及智能体工作流。不同数据库有“累计450万美元”口径，但币种混合且公司未在本周统一披露，因此准确美元累计额与估值均记为**未披露**；未发现其估值达到10亿美元。

**创始人：** CEO Stephanie Curcio是前专利/IP律师，亲历关键词检索耗时和发明表述细微差异；CTO James Stonehill是资深软件工程师，二人于2021年共同创办公司。法律问题定义能力与模型/平台实现能力互补，是典型的垂直AI创始人匹配。新任Chernoff兼具USPTO审查、律所检索、财富500强首席专利顾问及投行CIPO经验，能补足企业销售和报告质量标准。公司约25名员工，服务约100家组织、数千用户；2025年口径为2000多名IP与研发专业人士。

**竞争力：** 护城河不在基础模型规模，而在专利语料的检索相关性、引用可追溯性、专业评测和客户工作流。公司在ChatGPT发布前已开发领域模型，Gowling WLG等律所及企业IP团队的使用、约100家组织和数千用户形成信任资产；合规认证、私有云和不训练客户数据也适合高度保密的未公开发明。风险是“10分钟报告”仍是公司自报，错误遗漏会带来巨额法律责任；Perplexity、Patlytics、Solve Intelligence以及LexisNexis/Clarivate等既有数据库都可能快速增强智能体，且律师工时计费会减缓内部采用。名称重塑能扩产品边界，但也有稀释原有品牌认知的代价。

**赛道分析：** 专利AI已从语义搜索进入执行型工作流早期阶段。成熟玩家掌握全球数据库、引文网络和事务所渠道；新创公司以更好的自然语言检索、生成式起草、无效性/FTO自动化切入。生成式AI同时增加专利申请数量和文本长度：BetaKit援引统计称2024—2025年生成式AI相关新专利族超过5.6万，超过此前十年总和，这既创造积压，也提高检索复杂度。Clerq卡位于“研究证据层+可审阅工作产品”，比单纯起草更容易建立可验证标准。未来1—2年，行业将从按席位SaaS走向按完成任务/成果计价的service-as-software；胜负取决于召回率、引用正确率、跨法域覆盖及责任边界。判断上，Clerq拥有先发领域底座，但必须用第三方基准证明报告质量。

**关键数据（逐项来源URL+日期）：**
- 更名、约10分钟工作流、两项首发功能、RPX/Park IP合作、安全架构：Clerq官方新闻稿（PR Newswire），2026-08-18，[prnewswire.com](https://www.prnewswire.com/news-releases/nlpatent-rebrands-to-clerq-unveils-the-next-generation-of-ip-intelligence-built-to-execute-patent-work-end-to-end-302853676.html)
- 约25名员工、约100家客户组织、数千用户、5.6万生成式AI专利族：BetaKit，2026-08-18，[betakit.com](https://betakit.com/nlpatent-rebrands-to-clerq-to-meet-growing-demand-for-patent-automation/)
- 创始人、300万美元投资方、私有云与路线图：SiliconANGLE，2026-08-18，[siliconangle.com](https://siliconangle.com/2026/08/18/nlpatent-rebrands-as-clerq-launches-agentic-patent-research-workflows/)
- 2023年100万加元种子轮、40万加元SAFE、2025年300万美元融资详情、2000+用户：BetaKit，2025-11-11，[betakit.com](https://betakit.com/nlpatents-3m-usd-raise-helps-it-power-patent-research-with-ai/)

**原文链接：** [prnewswire.com](https://www.prnewswire.com/news-releases/nlpatent-rebrands-to-clerq-unveils-the-next-generation-of-ip-intelligence-built-to-execute-patent-work-end-to-end-302853676.html) ；[betakit.com](https://betakit.com/nlpatent-rebrands-to-clerq-to-meet-growing-demand-for-patent-automation/) ；[siliconangle.com](https://siliconangle.com/2026/08/18/nlpatent-rebrands-as-clerq-launches-agentic-patent-research-workflows/) ；[betakit.com](https://betakit.com/nlpatents-3m-usd-raise-helps-it-power-patent-research-with-ai/) ；[clerq-ip.com](https://clerq-ip.com/)

**投资/合作视角：** 投资前应要求盲测其先前技术召回率、引文幻觉率、律师修改时间和任务毛利，并确认专业责任险与客户赔偿条款。合作上，专利代理所可先用“批量分诊+律师复核”处理积压，企业研发部门则可把Clerq接入发明披露入口；RPX/Park IP式渠道合作可能比逐所直销更快建立网络效应。

---

## 📊 本周创业市场观察

- **资本更偏好可验证的业务闭环。** Blacksmith 已披露客户、CI 作业增长和收入区间；Palona AI 给出订单及团餐线索数据；Rezolv 披露年化收入运行率；机器人零部件与工业机器人公司则把扩产、供应链导入和批量落地作为融资用途或验证信号。
- **AI Agent 正从通用对话转向垂直执行。** 本期覆盖代码验证、实体门店、金融催收、工程评审、交易研究、战略执行、专利研究与企业知识等工作流；共同重点是连接业务系统、保留审计或人工复核，并以真实结果而非单次生成衡量价值。
- **基础设施机会分布在数据、算力与安全三层。** Pathway 强调实时数据与持续学习，Harell Data 连接科学数据与 GPU 训练收益，DiscreteStack 聚焦私有/隔离部署，Portnox 则从网络层控制 AI 智能体身份风险。
- **具身智能投资继续向上游与工业场景集中。** 奇点智控、诺仕机器人分别切入力觉与精密传动，灵锶智能聚焦重载四足机器人；三者的核心验证均落在量产一致性、可靠性、付费出货与场景复购，而非演示能力。
- **分发、合规与系统集成仍是主要约束。** Relay.app 的关停说明通用自动化产品即使具备 AI 与人在回路能力，也可能受连接器维护、获客和平台竞争挤压；金融、法律、科学数据、视频与企业知识产品则分别面临监管、权属、隐私、审计和误操作责任。

---

## 📋 关于本周报

本报告仅整理上海时间 2026-08-12 00:00—2026-08-18 24:00 窗口内发生或正式披露的动态，共覆盖美国 5 家、中国 5 家、欧洲与以色列 4 家、其他地区 3 家，合计 17 家。筛选对象为非大厂 AI 创业公司，公开估值须低于 10 亿美元；估值未披露者仅在无可信独角兽证据时纳入，并明确标注“未披露”，不根据融资额自行推算。

融资金额严格区分本轮、累计融资与集中披露历史轮次；公司自报性能、市场规模预测、客户成效和媒体数据库估值均保留其来源与日期，并在正文提示独立验证需求。每家公司按产品深研、融资记录、创始人、竞争力、赛道分析、关键数据与投资/合作视角展开，结论仅基于本文所列资料。
