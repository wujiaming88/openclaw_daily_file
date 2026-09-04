# 全球 AI+产业研究周报（2026-08-28—09-03）

本期研究覆盖中国（含香港）与美国，并兼顾新加坡、东南亚和欧洲。严格时间窗为 **2026年8月28日00:00至9月3日24:00（Asia/Shanghai）**，研究于9月4日完成。四组研究覆盖五个一级行业，32个二级行业均逐项核验；母稿约有22个有料对象、约50个来源URL/全文页。有料对象均至少尝试web_search后web_fetch，随机抽查的小米CyberOne、Google Pics、Chowbus×Maple、OpenEvidence、Owkin×Boehringer与工信部通知都能回指事实及限定；受阻页面没有用搜索摘要代替全文。约50是研究抓取页的近似口径，正文实际保留48个去重后的唯一公开链接。

本周可靠信号集中在三个位置：模型如何接入设备和存量系统，代理如何进入受约束的组织流程，治理、支付与采购如何成为落地基础设施。它们并不自动等于规模化ROI；因此下文把已经出现运行量的项目、仍在PoC或研究预览的项目，以及静默或获取失败的方向分开呈现。

## 本周TOP 5

### 1. 工信部培育人工智能应用服务商

工信部专项不是一次单模型发布。它把咨询规划、现场交付、系统集成、运营维护、安全治理和首购首用放进全国资源池与采购机制，提出2026年底资源池突破2000家、2027年底不少于3000家，并强调“高频、刚需、可复用”的“小快轻准”产品服务。报告判断，这可能影响制造、医疗、政务和中小企业项目从PoC走向持续交付的能力；真正成效仍取决于资源池准入与淘汰、资金来源和首购项目能否复用。

### 2. 小米CyberOne进入汽车工位

小米披露CyberOne在汽车工厂“实习”数月，完成自攻螺母上件双侧作业，成功率从90.2%提高至98%。这是具身智能进入汽车装配小零件重复操作的具体信号，但来源没有样本量、节拍、连续无干预时长、人工接管率、可用率或部署台数，因此仍是具体工位PoC，而不是量产部署或规模化ROI证明。

### 3. Anthropic发布Model Hardware Standard研究预览

Model Hardware Standard（MHS）以统一driver、device manifest和read/write原语抽象液体处理器、机械臂、显微镜、plate reader、相机和量子系统。CMU案例称驱动与编排约8小时完成，传统厂商方案需数周；QuEra扰动测试700次成功695次，即99.3%。这些均为Anthropic或合作方口径。它指向实验室AI的系统瓶颈在异构仪器接口、安全编排和可复现执行，而不只是假设生成；申请制research preview和仍需人工介入的案例也说明，无人值守生产级实验尚未成立。

### 4. FDA TEMPO联动监管、支付与真实世界证据

FDA TEMPO把Cadence、Limbic、Dexcom、SonderMind等数字健康设备放入与Medicare ACCESS支付模型相关的受控真实世界探索。STAT称，部分产品在尚无marketing authorization时即可提供。FDA参与者页本轮抓取为404，STAT后段有付费墙，因此不进一步陈述具体适应证和数据义务。报告将监管与支付合并视为数字疗法和慢病管理的重要商业化信号，但版本追踪、入组退出、质量体系和知情同意仍需明确。

### 5. Owkin向Boehringer授权AI Scientist与多模态数据

9月2日，Owkin宣布Boehringer获得K Pro AI Scientist以及多模态肿瘤和免疫数据授权，用于可复现分析、假设生成、检验和排序，承接2025年的MOSAIC试点。金额、期限、候选靶点、命中率和临床结果均未公开。外部MOSAIC材料提到11个治疗领域、6种数据模态和2,725名患者，但不能据此认定本次授权覆盖全部数据。该交易显示药企采购对象可能从单一模型转向“数据资产+研究工作台”，目前仍只是研发基础设施信号，不是新药成功证明。

## 工业制造：从区域扩散到具体工位

工业制造包含六个二级行业，本周三个有料、三个静默。现有证据分别落在区域扩散、具体工位和中小工厂交付形态上，但都缺少足以证明规模化ROI的关键指标。

### 智能工厂/灯塔工厂｜有料

新华社英文网8月29日报道，天津北辰区近年来在轻工、新材料、高端装备等行业建设了60家智能工厂，现场可见AGV、机械臂与工人协同。原文没有单厂投资额、OEE、良率、能耗或回收期，也未说明这些工厂是否按世界经济论坛灯塔标准验收。因此，“60家”只说明区域批量扩散广度，不能直接证明生产率提升。其产业价值在于智能工厂从头部汽车和电子企业向建材、日用品等传统行业扩展，可能惠及自动化集成、机器视觉、MES/WMS和工业网络服务商。中国有料，美国静默。[新华社英文原文](https://english.news.cn/20260829/7480b62a8670424b88508f24dd0f57f9/c.html)

### 工业质检与机器视觉｜静默

按工业质检、缺陷检测、AI inspection和machine vision检索，窗口内未找到同时具备制造客户、部署规模或质量指标，并且原始全文可打开的中美新增案例。IMTS预览、市场报告和指南多在窗外；美国、德国、日本、韩国和东南亚也未检出满足门槛的新增案例。静默不表示市场不存在，只表示本周合格新增案例为0。

### 预测性维护与设备健康｜静默

预测性维护和condition monitoring的命中主要是窗外营销指南与厂商名单。窗口内社交宣传没有客户、设备数、预警提前量、停机下降或ROI等可核验数据，因此不计为有料。后续核验对象仍是设备OEM、振动传感器及化工、钢铁、汽车客户公告。

### 工业机器人/具身智能进厂｜有料

新浪科技9月3日在IFA 2026现场报道并引用雷军此前披露：CyberOne在汽车工厂执行自攻螺母上件双侧作业，成功率由90.2%提升到98%。这使任务从搬箱或展示动作走向装配小零件，直接相关环节包括灵巧操作、3D视觉、力控、末端执行器和工位集成。由于缺少样本量、节拍、连续运行、人工接管、可用率和部署台数，本周只能把它定为试点；真正拐点要看长时间故障率、维护费与单位工件成本。中国有料，美国静默。[新浪科技](http://finance.sina.com.cn/jjxw/2026-09-03/doc-iniqqfvs6781787.shtml)

### 工业软件/供应链/数字孪生｜静默

工业软件、供应链优化、数字孪生、PLM/MES及制造企业公告的命中，多为西门子1月产品、7月指南或9月中旬会议。窗口内没有可核验的新签约、上线或量化运营效果全文，因此本周合格新增为0，不用旧产品补位。

### 工业大模型与工业知识库｜有料

宁波旭达8月29日的服务商文章描述了一种制造业AI智能体/知识库实施口径：连接MES、ERP、CRM、数据库和API，以八条产线的良率汇总切入，3周上线，首月节省40小时人工统计；车间主任原本每天花2小时汇总，项目价格为6万至30万元以上，问题答错率从第1周约30%降至第4周10%、第8周5%以下。全部数字来自服务商自述，客户匿名，且没有合同与独立验收，不能作为行业基准。

这份案例的价值不是证明模型性能，而是展示中小制造可采购的形态：私有化、模型解耦、少量高频Function、权限审计，以及先用MES/ERP接口跑通单点ROI。区域集成商因此可能比纯模型供应商更接近预算。中国有料，美国静默。[旭达原文](https://www.nbxuda.com/news/2026-08-29-ai-agent-6-checks-manufacturing.html)

工业本周的三组证据恰好对应三种深度：天津60家是扩散广度，小米98%是工位深度，旭达案例是可交付服务形态。但它们共同缺少OEE、节拍、连续无故障时间与回收期，工业AI仍处在“从示范到可验证ROI”的分化阶段。

## 创意与内容：生成进入协作与权利链条

创意与内容共有七个二级行业：六个出现了产品、合作、授权或治理线索，其中两个证据受限；游戏方向静默。变化重点不只在生成速度，而在品牌共同开发、区域翻拍、协作审批和权利合同化。

### 影视/短剧/广告AIGC｜有料

新加坡VIRTUE Asia、V47 Entertainment与中国COL Group于8月28日发布Inside Microdramas，计划在10月27日展示约10个可与品牌共同开发、融资和制作的2027项目。COL与泰国CP Group的合作还包括9月在TaTang by True ID上线FlareFlow Mini品牌内容专区、10月开始泰语翻拍，并纳入AIGC-enabled production capabilities和人才孵化。合作未披露完整项目数，不能写成全面无人化制作。[Campaign Brief Asia](https://campaignbriefasia.com/2026/08/28/virtue-asia-v47-entertainment-and-col-group-launch-inside-microdramas-upfront-in-singapore/)；[ContentAsia](https://www.contentasia.tv/news/col-seals-broad-vertical-videomicrodrama-alliance-thailands-cp-group-contentasia-live-2026)

美国方面，Sunny Hostin与Fountain 0签订经授权的姓名、肖像及小说改编许可并保留严格控制，使AI表演和数字人权利进入合同；母稿没有可公开的期限、具体用途和收益数字。Diageo旗下Astral Tequila则围绕《Practical Magic 2》制作五集社交微短剧，在YouTube Shorts、Instagram、TikTok分发并配合四城活动。两者共同说明，AI相关内容正在嵌入授权与品牌分发，而不是只比较生成工具。[Variety](https://variety.com/2026/biz/news/the-view-sunny-hostin-her-likeness-to-ai-studio-fountain-0-1236845286/)；[PR Newswire](https://www.prnewswire.com/news-releases/astral-tequila-becomes-the-official-tequila-partner-of-practical-magic-2s-iconic-midnight-margarita-bringing-the-celebration-to-life-with-an-original-social-microdrama-starring-brooks-and-grace-ann-nader-302860615.html)

### 游戏与互动娱乐｜静默

Gamescom、OpenAI Seoul Game Builders、Tripo AI等属于相邻信息，但本周没有取得直接属于游戏产品、发行或工作流，同时有原始全文和经营指标的事件。Gamescom内容多在8月27日或是泛行业评论，Tripo属于通用3D生成，因此本方向合格新增为0。

### 新闻与出版｜有料

Google于9月1日发布Google Pics，未来数周向Google AI Pro、Ultra和大多数Workspace企业客户开放。官方称其基于Nano Banana，既可独立使用，也能从Docs和Slides嵌入，Drive将在后续接入；功能包括对象分割、局部多轮修改、图片文字修改与翻译、多人协作和多版本生成。对出版流程，它把封面、社媒配图、插图和本地化视觉带入编辑协作空间，但没有披露客户数、编辑工时或事实核验结果。“数以百万用户每月处理数十亿图片”是Workspace总体规模，不能当作Pics活跃量。[Google官方](https://blog.google/products-and-platforms/products/workspace/google-pics/)；[TechCrunch](https://techcrunch.com/2026/09/01/googles-answer-to-canva-is-an-ai-tool-where-you-prompt-instead-of-design/)

### 设计/营销创意工具｜有料

Google Pics也把生成、局部精修、图中文字翻译和多人协作放进同一文件流，Docs与Slides先接入，Drive后接入。图中文字翻译有助于多市场资产变体，但品牌、商标、事实与版权审核必须同步。第三方所称一次生成四个选项、2K/4K和七个计划没有得到官方确认，不列为硬数据。报告判断，这一领域的竞争点正从“有没有生成按钮”转向能否进入协作、审批与资产管理链路；Google的既有优势在Workspace分发。[同一Google官方来源](https://blog.google/products-and-platforms/products/workspace/google-pics/)

### 虚拟人/数字人/直播电商｜有料但证据有限

Sunny Hostin与Fountain 0的姓名、肖像及小说改编授权，是窗口内最直接的AI likeness动态。它表明用途、衍生权、审批和收益分配需要合同化，但母稿没有足以展开这些条款的数字或原文细目。本周也没有找到直播电商量化落地全文，因此不能把这一授权合作扩写成直播商业化规模。[Variety授权报道](https://variety.com/2026/biz/news/the-view-sunny-hostin-her-likeness-to-ai-studio-fountain-0-1236845286/)

### 音乐与音频｜有料/治理型

音乐艺人起诉Suno、Apple Music拟给AI生成曲目加标签等为窗口内媒体线索，但研究没有取得Apple、Suno或法院文件原始全文，因此不写诉讼请求、数字或生效日期。可以确认的产业问题是：AI曲目进入分发后，平台要处理识别、标注、榜单资格、版税与训练数据许可；短期关键不只是生成质量，而是能否被标注、进榜及确定权利归属。[Google News RSS线索](https://news.google.com/rss/search?q=%28AI+OR+artificial+intelligence%29+%28music+OR+audio+OR+podcast%29+after%3A2026-08-27+before%3A2026-09-04&hl=en-US&gl=US&ceid=US%3Aen)；[Billboard](https://www.billboard.com/pro/how-music-streaming-platforms-treat-ai-music/)

### 版权保护与内容治理｜有料/获取失败

中国AI内容清理、美国《纽约时报》版权诉讼中政府支持OpenAI、Creative Commons AI许可指导都有线索，但SCMP、WIRED或Creative Commons材料至少有一项未取得全文。帖文数量、法律结论和新规生效均不能作为硬事实。可保留的治理判断是：平台需要同时建设生成标识、来源与许可记录、低质批量识别、申诉和人工复核；单靠检测器不能完成版权证明。本方向状态是有料/获取失败，后续仍需原始法规、诉讼文件或官方指导。

## 商业与公共服务：先接流程，再谈经营结果

商业与公共服务有七个二级行业，本周五个有料、两个静默。最完整的运行数据出现在餐饮和政务；办公与零售已有产品或蓝图，但本周量化新增不足；金融信号主要来自风险治理。

### AI办公与企业生产力｜有料但量化新增不足

Google Pics于9月1日进入Workspace，是窗口内最确定的新事件。个人可以在Docs和Slides中提示生成及修改视觉资产，团队可以多人协作，组织可以沿用Workspace权限、品牌审核和归档。Google在2024年9月24日发布的历史客户材料称，Gemini for Workspace平均每用户每周节省105分钟，75%日活用户认为质量提升；Elanco估算一年ROI 190万美元，SURA通话分析覆盖90%以上并使满意度提升10个百分点。这些数字都是历史厂商调查或客户故事，不是本周数据，且缺少样本与独立复核。[Google Pics](https://blog.google/products-and-platforms/products/workspace/google-pics/)；[历史客户基线](https://blog.google/innovation-and-ai/infrastructure-and-cloud/google-cloud/gemini-at-work-ai-agents/)

现阶段应分别看个人、团队和组织三层指标：每席每周净节省时间、活跃与付费席位、流程周期、返工率、质量和合规事故。本周没有新的席位、付费、ROI或组织工时硬数据。

### 零售与电商｜有料但量化不足

Anthropic于9月2日面向零售商发布Claude shopping/merchant agents技术蓝图。消费者侧覆盖商品发现、推荐、购物车和结账，商家侧覆盖库存、订单与供应商协同。Reuters原始页面返回401，研究也未取得Anthropic对应公开公告，因此只能由可读二手全文支持“蓝图和方向”；客户、价格、API、转化率和客单价均未披露。[Reuters线索](https://www.reuters.com/business/retail-consumer/anthropic-launches-ai-agent-blueprints-retailers-ahead-holiday-shopping-season-2026-09-02/)；[Inside AI全文](https://insideai.news/news/ai-in-business/anthropic-ai-agent-blueprints-retailers/9561/)

报告判断，商家后台代理可能更早产生ROI，因为采购、低库存、订单和供应商邮件更结构化且可审计；消费者代理仍要处理目录、价格、库存、支付权限和越权防护。这是中等强度的产业判断，不是已有转化率证明。

### 餐饮与本地生活｜有料

9月2日，Chowbus与Maple合作，为美国和加拿大商户提供多语言语音AI点单，支持英语、普通话、粤语和韩语，覆盖电话、kiosk、drive-thru；系统把菜单、规格、价格和可售状态实时同步POS，也可处理预约、团餐、营业时间和路线。企业披露，高峰期漏接21%—43%来电，单店每年约3万美元订单未实现；Maple自2023年12月处理逾100万次对话，92%无人介入解决，覆盖1000多家商户；Chowbus称年交易额超过40亿美元。[Financial Post/Business Wire](https://financialpost.com/pmn/business-wire-news-releases-pmn/chowbus-and-maple-announce-strategic-partnership-to-bring-multilingual-voice-ai-ordering-to-restaurants)；[Digital Transactions](https://www.digitaltransactions.net/shoplines-splitit-integration-and-other-digital-transactions-news-briefs-from-9-3-26/)

上述数据均为企业自报。两家媒体交叉确认了合作和部分规模，但没有独立复核漏接率与92%解决率。真正的产品价值在于语音层连接POS、厨房屏和打印机，而不是独立聊天；应继续看接通率、转人工率、点单错误、处理时长和增量订单，同时防范误识别、过敏原及支付确认错误。

### 客服/呼叫中心/销售自动化｜静默

Genesys、JLL、MarTech等命中内容主要是评论与案例，未取得窗口内能同时支撑新增客户量、席位、解决率、AHT、转化或销售pipeline的原始全文。Chowbus与Maple已归入餐饮，不在这里重复计数。因此本方向合格新增为0。

### 法律/咨询/专业服务｜静默

Thomson Reuters、Bloomberg Law、Law.com等命中AI转型、成本和岗位评论，但原文受限，也没有独立样本、小时节省、案件产能、计费小时或ROI。它们不能作为本周落地案例，故标静默。

### 金融服务/保险/风控｜有料

金融稳定委员会（FSB）8月31日发布主席致G20财长和央行行长的信及摘要。官方全文把前沿AI最直接的金融担忧落到网络风险，要求模型发布部署安全、负责，金融机构保持响应与恢复能力，并提高关键第三方技术和公共服务供应商的韧性。信中还指出，股票市场杠杆、高估值、市场集中度与AI乐观情绪可能放大修正。文件没有行业采用率或AI损失ROI，不能包装成经营案例。[FSB官方](https://www.fsb.org/2026/08/fsb-chair-warns-of-risks-arising-from-frontier-artificial-intelligence-ai-models/)

9月3日行业简报提到Finzly Assure防范rogue AI agents，以及Nasdaq Verafin与Alloy整合欺诈信号，但缺完整原始公告和客户或拦截率数字，只能作为线索。报告判断，金融AI的硬指标将从模型准确率转向代理权限、审计、第三方韧性、欺诈拦截和恢复时间。

### 政务服务/城市治理｜有料

内布拉斯加州DMV的Tyler Resident AI Assistant在5月至8月回答超过8.8万个问题，服务超过3.8万名用户；网站访客参与率59%，19%的交互发生在非办公时间，并产生3400多次在线服务转介。部分地区呼叫量下降20%，系统支持50多种语言。州政府随后决定全州扩展，并拟用Document Automation处理机动车运输业务和约50万条VIN验证记录，提供审计能力。[StateScoop](https://statescoop.com/after-successful-dmv-pilot-nebraska-expands-tyler-technologies-ai-tools-statewide/)；[Tyler线索](https://investors.tylertech.com/news/news-details/2026/Nebraska-Expands-Tyler-Technologies-AI-Enabled-Solutions-Footprint-Following-Successful-Pilot-Program/default.aspx)

这些数字来自州DMV、Tyler和StateScoop，没有独立审计；20%的下降只适用于部分地区，宣布扩展也不等于扩展已经完成。其价值在“已验证内容源+服务转介+非营业时间+人工/电话兜底”，评估应看问题解决率、转介完成率、语言覆盖和审计完整性，而不只是回答量。中国内地与香港本窗口没有找到达到原文标准的新增政务项目。

## 教育科研：工作流迭代快于效果证明

教育科研共有六个二级行业：五个出现产品、政策、培训、生命科学或实验室接口信号；AI for Science/材料发现为静默/获取失败。教育产品迭代和科研基础设施动作明确，但学习效果、新药结果和无人值守实验仍缺证据。

### AI教师/助教与个性化学习｜有料

香港团队HKUDS的DeepTutor在8月30日、31日、9月2日和3日连续发布v1.6.1至v1.6.4，把tutoring、problem solving、quiz、research、visualization、mastery practice和阅读放进同一可恢复工作区。新版本增加带来源的Mastery paths、Chat hand-offs、学习者与监护人账户、grounded Reading和沉浸式YouTube学习。项目称2026年4月19日达到2万stars，这是背景而非本周用户数据；没有学校部署、活跃学习者或学习成绩，因此只能定为开源产品和工作流迭代，不能称为教育效果。[GitHub](https://github.com/HKUDS/DeepTutor)；[论文](https://arxiv.org/abs/2604.26962)

纽约市公立学校（NYCPS）为2026—27学年发布AI与屏幕政策：2K至8年级禁止面对式生成AI，9至12年级只可使用批准项目；每名高中生完成两节各45分钟的AI literacy。Quill、Edia、Brisk、Playlab、Intel AI-Ready Schools五个试点获批，每人只能参加一个，剂量从每周15分钟到每周一课时不等。政策禁止AI用于评分、行为监控、安置、晋级或毕业决定，教师使用还需企业级隐私审核。官方未披露学习成绩、成本和覆盖学生数，因此“获批”不等于“成功”。[NYCPS官方](https://www.schools.nyc.gov/about-us/policies/guidance-on-artificial-intelligence)

### 智能批改/评测/学习硬件｜治理有料、硬件静默

NYCPS政策允许写作和数学支持工具试点，同时明确AI不得用于评分和重大学生决定。本周没有检出可靠的学习硬件新品或规模部署。因此，这一二级行业只在政策与评测治理层面有料，硬件子方向合格新增为0。[NYCPS政策](https://www.schools.nyc.gov/about-us/policies/guidance-on-artificial-intelligence)

### 职业培训与企业学习｜有料

NUS-ISS于8月28日启动第11届Learning Festival，主题为The Next AI Transformation，覆盖数据基础、治理、领导力、劳动力和技能。AWS支持的Show Me Your Agents黑客松用五周开发行政自动化、客服、供应链等真实业务agent，以9月5日和10月10日为节点，10月10日举行Demo Day。机构称累计服务近216,000名数字领导者和专业人士、覆盖8,854家企业组织，这是累计背景而非本周新增。培训价值在于与真实流程、治理和可演示原型绑定，但技能提升、生产率与上线率没有披露。[PR Newswire转载](https://www.manilatimes.net/2026/08/31/tmt-newswire/pr-newswire/nus-iss-learning-festival-2026-addresses-key-blockers-to-enterprise-ai-data-readiness-governance-and-workforce-capability/2414798)；[另一转载](https://ohsem.me/2026/08/nus-iss-learning-festival-2026-addresses-key-blockers-to-enterprise-ai-data-readiness-governance-and-workforce-capability/)

### AI for Science/材料发现｜静默/获取失败

MIT蛋白设计在8月27日，ORNL材料组装论文在2026年2月3日，无铅介电材料报道在8月20日或21日，均不在本期窗口。Phys.org的窗口内条目又多被403拦截。严格时间窗内没有可核验的材料发现新增原始来源，因此本方向合格新增为0，并保留获取失败状态，不能以延迟转载充数。

### AI制药/蛋白质/生命科学｜有料

**UToledo药物发现核心。** 8月28日，学校公开AI-Driven and Structure-Based Drug Discovery Core：用AI预测分子与靶蛋白结合，再以结构生物学实验验证，结果回流模型。研究所以FASN及lansoprazole/omeprazole方向为案例，NCI五年260万美元grant提供支持。当前项目不是临床试验或批准疗法，也没有命中率、耗时或候选数。[UToledo](https://news.utoledo.edu/index.php/08_28_2026/utoledos-northwest-ohio-cancer-research-institute-aims-to-speed-up-cancer-breakthroughs)；[研究全文](https://pmc.ncbi.nlm.nih.gov/articles/PMC12557586/)

**NUS叶酸药物再利用。** 团队把2,989种既有药物映射到8,739个糖尿病伤口愈合相关蛋白，将数百万组合收缩至35种候选药物和50个关键蛋白。叶酸在体外皮肤细胞实验中改善wound closure，报道称从文献到实验的时间缩短超过70%，但没有基线、样本量或统计值，而且仍非动物和临床证据。[Lower Extremity Review](https://lermagazine.com/industry-news/ai-guided-drug-search-flags-folic-acid-for-diabetic-wound-healing)

**Owkin与Boehringer。** 9月2日授权的内容、数据边界及局限见TOP5。公司官方未披露金额、期限、候选靶点、命中率或临床成果；外部MOSAIC的11个治疗领域、6种数据模态和2,725名患者口径不能外推为Boehringer本次获得的全部数据。产业价值是采购对象从单模型转向数据资产和研究工作台，仍不是新药成功证明。[Owkin官方](https://www.owkin.com/newsfeed/owkin-to-license-k-pro-ai-scientist-and-multimodal-oncology-and-immunology-data-to-boehringer-ingelheim)；[CNBC转载](https://www.cnbctv18.com/india/science/owkin-signs-ai-drug-discovery-deal-with-boehringer-for-cancer-immunology-19982583.htm)；[Unite.AI](https://www.unite.ai/boehringer-ingelheim-licenses-owkins-k-pro-ai-scientist-and-patient-data/)

### 科学计算/自动化实验室｜有料

MHS研究预览的设备范围、统一接口、CMU约8小时与QuEra 695/700的口径见TOP5。系统还可拒绝不良serial dilution、调整浓度后重跑；Genentech案例则显示，黏度差异会造成气泡与错误转移，最终需要人工指导。MHS可能降低异构仪器集成成本，但这些仍是小规模PoC；申请制research preview不替代ROS2、OPC UA或认证机器安全，也不证明无人值守生产级实验成立。[Anthropic原文](https://www.anthropic.com/news/model-hardware-standard-research-preview)；[MLQ核验](https://mlq.ai/news/anthropic-previews-model-hardware-standard-for-ai-controlled-lab-and-factory-equipment/)；[AI Weekly核验](https://aiweekly.co/alerts/anthropic-previews-model-hardware-standard-for-ai-lab-agents)

## 大健康：产品闭环与监管试点并行

大健康有六个二级行业：医学影像、临床决策、数字疗法、健康管理和医院运营五个方向有料；AI新药研发与临床试验为获取失败。本周证据支持的是工作流产品、模型编排、监管支付试点和医院劳动分配问题，不支持扩大为临床结局或规模化采用。

### 医学影像与辅助诊断｜有料

**RapidAI Rapid Aortic。** 9月2日报道称FDA授予Rapid Aortic 510(k) clearance，用于主动脉CT评估，提供自动测量与3D重建，可能帮助更早发现主动脉瘤或夹层。报道正文受Cloudflare阻挡，研究仅用FDA CDRH页面交叉核验监管语境，没有取得决定摘要中的扫描协议、验证集和禁忌，因此不能外推临床结局。其产品方向是从单次病灶识别走向结构化量化和跨时间随访，真实世界数据仍待验证。[Diagnostic Imaging](https://www.diagnosticimaging.com/view/fda-clears-ct-based-ai-aortic-assessment-monitoring)；[FDA CDRH](https://www.fda.gov/medical-devices/medical-devices-news-and-events/cdrh-new-news-and-updates)

**Pearl Second Opinion 3D。** 9月3日，Pearl发布商业产品，把FDA-cleared CBCT影像AI提供给普通牙医，支持自动分割颌骨、鼻腔、气道、神经管和牙齿，并把口腔颌面放射科报告请求和保险理赔文档放进椅旁流程，面向多院区与DSO标准化。这说明商业化对象可能是“模型+专科复核+理赔文档+沟通”的闭环，而非单独的分割模型；产品没有披露新增临床疗效数据，责任、隐私与过度依赖仍需防范。[GlobeNewswire](https://www.globenewswire.com/news-release/2026/09/03/3355988/0/en/pearl-launches-second-opinion-3d-bringing-fda-cleared-cbct-imaging-ai-to-general-dentists-for-the-first-time.html)

### 临床决策与医疗大模型｜有料

OpenEvidence于9月3日发布Osler、Sackett、Snow模型家族。官方指南称三者采用相同的临床准确性标准，区别在思考时长和检索深度：Osler数秒给出床旁直接回答，Sackett用数十秒至1分钟提供更全面结果并支持追问，Snow至少约5分钟形成文献调查或结构化报告；经验证的临床医生可免费不限量使用，Darwin则为申请制research preview。发布稿索引约称5秒、30秒和5分钟，这些都是厂商自述。[OpenEvidence官方指南](https://www.openevidence.com/user-guide/models)；[BusinessWire](https://www.businesswire.com/news/home/20260903878517/en/Introducing-the-OpenEvidence-Model-Family)；[STAT](https://www.statnews.com/2026/09/03/openevidence-launches-new-ai-models-clinicians-health-tech/)

产品价值在于按场景的延迟预算和证据深度路由，竞争焦点从万能聊天框转向模型编排、权限和证据链。但本周没有实际机构采用或临床结果，仍需前瞻性临床验证。

### AI新药研发与临床试验｜获取失败

窗口内命中9月2日AI与新兴药物技术综述，以及9月3日AI/ML临床患者建模访谈，但正文被403或Cloudflare阻挡，或内容属于综述，没有取得产业合作、融资或临床里程碑的原始全文。本方向合格新增为0，明确标记获取失败，不能包装为突破。[MDPI线索](https://www.mdpi.com/1422-0067/27/17/7864)；[Applied Clinical Trials线索](https://www.appliedclinicaltrialsonline.com/view/ai-and-machine-learning-diagnosing-clinical-trial-patients)

### 数字疗法与慢病管理｜有料

TEMPO的参与者、监管与Medicare ACCESS支付探索见TOP5。其商业价值在于监管、支付和真实世界证据开始联动；相应风险是生成式模型版本追踪、入组与退出、质量体系及知情同意必须明确。由于FDA参与者页404和STAT付费墙，本周不进一步写具体适应证、性能义务或各家产品细节。[STAT](https://www.statnews.com/2026/09/03/tempo-fda-pilor-generative-ai-medical-device-regulation/)；[FDA TEMPO](https://www.fda.gov/medical-devices/digital-health-center-excellence/participants-selected-tempo-digital-health-devices-pilot)

### 健康管理/可穿戴/保险健康｜有料

TEMPO也覆盖远程监测、连续血糖监测（CGM）和行为健康数字干预，因此构成本周健康管理、可穿戴与支付联动的主要信号。但母稿没有真实世界效果、保险赔付或成本下降数据，试点参与不能写成规模化采用。[FDA TEMPO](https://www.fda.gov/medical-devices/digital-health-center-excellence/participants-selected-tempo-digital-health-devices-pilot)

### AI医疗器械与医院运营｜有料

Doximity 2026医生薪酬报告基于约25万份、七年调查回复，其中包括近2.3万名2025年受访医生。报告称，66%的医生每天或每周在临床或行政工作中使用AI；30多岁医生每周使用比例为73%。36%认为，当AI显著减少时间或精力时应改变报酬；44%认为效率带来的财务收益应主要归医生。20%已经面对更高生产率预期，42%担心未来出现，67%认为掌握AI会在未来12个月带来收入优势。[Doximity](https://www.doximity.com/reports/physician-compensation-report/2026)；[Healthcare Dive](https://www.healthcaredive.com/news/physicians-say-they-should-benefit-financially-from-ais-time-savings-doximity/829046/)

这组数据来自平台自报和非随机抽样，还混合文书、决策等不同风险等级。它能支持的判断是：AI进入高频医院工作后，ROI会牵动收益分配、工作量、审校责任和职业倦怠；它不是单一厂商的经营案例。

## 政策专项：服务商资源池如何承接AI+交付

工信部办公厅《关于开展人工智能应用服务商培育专项行动的通知》文号为**工信厅科函〔2026〕414号**，于2026年8月31日公布，地方官方页面9月1日转载或解读。它在全国适用，面向提供咨询规划、交付实施、运营管理、安全治理和配套服务的企业与机构。通知未单列延后生效日期，按印发后组织实施，并设置2026年底和2027年底目标。[广州市工信局官方全文](https://gxj.gz.gov.cn/gkmlpt/content/10/10985/post_10985532.html)；[数字中国建设峰会官方页](https://www.szzg.gov.cn/2026/xwzx/szkx/202609/t20260901_5366208.htm)；[湖南省工信厅](https://gxt.hunan.gov.cn/gxt/xxgk_71033/gzdt/rdjj/202609/t20260901_34054712.html)

原文提出：“到2026年底，全国服务商资源池内服务商数量突破2000家……复杂场景交付能力显著增强；到2027年底……不少于3000家，支撑形成全要素协同、全链条贯通、全场景覆盖的人工智能应用服务生态。”重点任务是建立资源池、提升服务供给、推动规模化应用和加强支撑保障；同时要求围绕“高频、刚需、可复用”业务封装“‘小快轻准’的人工智能产品服务”，探索以“首购首用、风险补偿”加大大模型、智能体和Token服务采购，鼓励前线部署工程师（FDE）扎根现场，并支持有条件地区出海。

政策把AI+从模型、算力和示范场景进一步推到现场服务体系。直接相关的受益者包括行业ISV、系统集成、数据治理、安全合规和能持续运维的服务商；医院AI集成、制造MES/ERP改造和政务服务商也可能进入资源池。对创业者，机会是“单点高频流程+权限/安全+系统接口+持续运营”；风险则是资源池名录化、重复建设，以及只报调用量、不报经营结果。关键不在名录数字本身，而在准入和评价淘汰、资金来源，以及首购项目能否形成可复用交付。

本周符合时间窗、与中国AI+产业直接相关的新专项政策共**1篇**。研究没有发现专门针对大健康六个二级行业的新增国家级AI医疗专项政策；美国、欧盟和新加坡本周也未取得同等硬度的产业政策全文，因此不以较弱材料补凑。

## 三条产业化主线

### 主线一：从模型能力到现场接口与工作流闭环

**确定性：高。** MHS统一仪器接口，Chowbus连接POS，Pearl连接CBCT、报告与理赔，旭达连接MES/ERP，Tyler连接验证内容源和服务转介。这些案例共同表明，可采购单元正在变成“模型+权限+系统接口+人工兜底”，而不只是聊天窗口。成熟度仍有分化：餐饮点单、政务问答及部分影像工作流处于“试点到规模化”；工业知识库、MHS和机器人进厂多仍是试点。

### 主线二：代理进入受约束流程，ROI披露仍滞后

**确定性：中高。** 零售商家代理、NUS企业agent黑客松、Google Pics协作、DeepTutor学习状态机和OpenEvidence延迟分层，都把AI放进真实流程。但本周新增的席位、付费、净工时和独立ROI数据很少，105分钟/周仍是历史厂商基线。餐饮和政务已有局部运行指标，可归入“规模化局部”；AI办公、零售和教育agent仍以试点为主。

### 主线三：安全、治理与支付成为基础设施

**确定性：高。** 工信部通知以资源池、首购首用、风险补偿和FDE降低交付门槛；FSB强调网络韧性和第三方依赖；NYCPS限定年龄、使用剂量、评分用途与隐私；FDA TEMPO连接监管、Medicare ACCESS支付和真实世界证据；音乐、版权及AI likeness则要求标识、许可和收益规则。政策与治理在本周已先于许多业务ROI成熟。

## 产业化意味着什么

**规模化/局部成熟，确定性中高。** 多语言餐饮语音点单、美国政务问答与服务转介、部分医学影像和牙科工作流，已经出现运行量、用户数、服务转介或完整工作流产品。不过，企业自报和区域限制仍需复核。

**试点/拐点，确定性中。** 具身机器人进入汽车工位、工业Agent知识库、AI办公组织流程、AI制药的“数据+研究工作台”、自动化实验室接口标准，以及数字疗法监管支付融合，都已经有具体载体，但尚未形成充分的规模化结果证明。

**概念/证据不足，确定性高。** 严格窗口内的材料发现、客服和销售自动化、法律专业服务、游戏AI及AI新药临床里程碑，本周没有达到原文和指标门槛。这里的“静默”或“获取失败”不等于市场不存在，更不能写成有料。

创业和投资层面，报告建议优先关注能把模型接入存量系统并持续运营的垂直服务商，例如制造MES/ERP、医疗PACS/理赔/真实世界数据、餐饮POS、多语言语音和实验室设备接口，以及权限、审计和安全治理层。该判断的确定性为中高；主要风险是厂商自报ROI、匿名客户、监管和责任边界、集成成本与模型漂移。

## 下周要看八组指标

1. 工信部资源池准入规则与地方首购项目；
2. 小米机器人连续运行时长、节拍和人工接管率；
3. MHS是否开放以及是否出现第三方复测；
4. TEMPO的具体适应证、数据义务与支付结局；
5. OpenEvidence的实际机构采用与临床审校；
6. Google Pics的Workspace席位、活跃度与企业治理；
7. Chowbus的增量订单与转人工率；
8. 政务AI的转介完成率，而不只是回答量。

这组指标的判断确定性为高：它们直接对应当前证据最薄弱、也最能区分试点与可持续运营的环节。

## 证据边界

本期研究在检索阶段多次遇到Brave web_search 429，并按降级链使用可访问来源或Google News RSS；browser服务因系统缺少Chromium snap而启动失败。这没有改变已经成功抓取页面的内容，但造成部分候选覆盖缺口。Rapid Aortic正文、FDA TEMPO参与者页、部分音乐、版权、零售原始稿和AI新药材料还受到Cloudflare、403、401或404影响，文中均按“获取失败”或“方向性”处理，没有用搜索摘要补关键数字。

小米98%、旭达40小时与答错率、Chowbus和Maple的21%—43%、92%、100万次与1000多家商户、Anthropic约8小时和695/700、Doximity问卷，以及Google历史客户基线，均保留厂商或机构自报、历史数据和非独立审计的限定。由此能得出的收束仍然克制：本周整体并不冷清，可靠产业化信号集中于流程接入和受约束试点；规模化ROI仍需持续跟踪。

---

**信息校验：O=32个对象 / F=44条事实 / D=46个数据点 / J=24条判断 / L=48个唯一链接，全部可追溯。**
