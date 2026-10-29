# 全球 AI+产业研究周报 · 第 20261030 期 · 验证器与规则先行（冻结研究母稿）

- 本期窗口：2026-10-23 00:00 ~ 2026-10-29 24:00（Asia/Shanghai）。「本周」只指此区间；窗外信息标「背景，非本周」。
- 版本：master.md v1（冻结 2026-10-30，Asia/Shanghai）。读者稿 article.md 只从本稿取材；证据级 A–D 与审计只留在本稿。
- 依据：shards/A1、A2、B、C、D 全部分片 + coverage/discovery；shards/topic/topic.md；wow.md v2；browser-checks.md；上期母稿 ref/prev-research.md（第 20261023 期）。
- 证据级：A 可核原始事实｜B 具名披露（据 X 披露，未独立核实）｜C 不同来源原文实质相符｜D 欠证/争议。
- 边界裁定：Amazon Q3（美东 10-29 盘后 = 上海 10-30）窗外，记背景/下期；JPMorgan、Goldman Sachs、Uber、美团（10-22）记背景；科大讯飞 1024 开发者节（10-22 开幕）记背景。C 组固定名单不含微软与中国办公 Agent，「AI 办公席位之争」本期未覆盖，不判降温。

## 1 导语

**一句话主线：本周 AI 在各行业放量之前，买方先把「凭什么信它」定成了规则——工程和工业用求解器、机理模型、签核引擎当裁判，受监管金融与平台用只读权限、令牌和争议规则设准入，政府用立项评估、采购方式和按量计价管后果。**

铺垫：上期（10-16~10-22）的关键词是「验收与计价」：工位节拍、装置 KPI、事后奖补、计价单位。本期三类信号同周出现，把重心推到「信任边界」：（1）至少 6 个彼此独立的工程/工业案例把确定性验证器放在大模型之后（南钢×华为元冶、Honeywell×Dangote、Cadence Maestro、华大九天 .aix、ChipAgents、Circuit Mind）；（2）HSBC、Shopify、SAP 把数据与入口开放给外部 Agent 但限定在只读、商家签发或治理网关内，Mastercard、Visa、Verizon 先谈令牌、争议规则与真客户确认；（3）国办发〔2026〕29 号把就业风险评估写进 AI 场景项目评审，南京条例让场景清单绑定预算、验收标准与采购方式，GSA 与贵州把 AI 采购改为按用量付费。共同代价也清楚：本周所有效果数字都来自厂商、客户或主管部门自述，没有一家披露验证器拦截率，财务口径多为毛收益。

## 2 TOP5（按产业化信号价值排序；每条含证据级）

### TOP1｜验证器在大模型之后：工程与流程工业的 AI 先找裁判，再谈自主
- **判断**：本周最完整的工业/工程 AI 落地都采用同一分工——大模型理解意图、拆任务、生成候选，确定性的求解器/机理模型/签核引擎判定对错。护城河从「接了哪个大模型」移到「谁拥有被行业信任的验证器」。
- **南钢×华为「元冶」（10-27，南京）**：宣布多个场景规模商用〔A，华为官网〕。截至 2026 年 10 月上线 25 个业务智能体、300 多个 AI 模型，一线员工自建低代码智能体和轻应用超过 1000 个，年降本超 1 亿元〔B，据南钢/华为披露〕。架构为「左右脑」：「右脑」感知认知模型做概率统计与归纳，「左脑」运筹优化与冶金机理模型做精确计算〔A，官方稿架构描述〕。分场景：炉温提前 2 小时预测、准确率 >90%；轧制力命中率 88%→98%，厚度公差 ±0.2mm，综合成材率 +0.5%；金相单样 10 分钟→3–5 分钟、准确率 >95%；S-Link 硫控智能体接入 602 个工艺参数、提前 1 小时预警，年效益 60 多万元〔B〕。AI 决策经可视化人机协同界面「受控嵌入现有调度流程」〔A〕。代价：前提是关键设备联网率 100%、数百万 OT 点位，计划与华为共建专用数据中心（金额未披露）〔B〕。
- **Honeywell Forge Plant Cognition × Dangote Lekki 炼厂（10-26）**：面向炼油/石化/LNG 的平台，首站 Dangote〔A〕。Nemotron 智能体解读运行数据，Cosmos + Metropolis VSS 做视觉告警，PhysicsNeMo 训练物理 AI 模型，叠加 UOP 工艺专长、「trusted calculations」和物理模型，本地跑在 Dell AI Factory with NVIDIA〔A〕。Honeywell 按初步数据估算 >0.29 美元/桶运营收益、满负荷年毛收益 >6000 万美元；脚注写明未扣实施成本、不作保证、只适用于本厂〔B，据 Honeywell 披露〕。
- **Cadence Maestro（10-26 美东）**：领域后训练 LLM + 决策模型 + 自改进 agent skills；「deterministic solvers evaluate outputs against engineering objectives, constraints and ground truth」，构成 RL 闭环奖励〔A，新闻稿〕。首批模型 2026 Q4 向精选早期客户开放〔A〕；相对通用基础模型「质量最高 +30%、token 效率最高 5×」为初始工作流结果〔B〕；Socionext 称将 InnoStack 部署进生产设计环境〔B，客户引语〕。同日 Q3：AI Super Agents「超过 100 个活跃客户接触」、营收 16.33 亿美元、积压订单 82 亿美元〔A，财报〕。
- **华大九天 .aix（10-23 HUG 北京，报道 10-27）**：基于国产开源大模型为每款 EDA 工具配 Copilot，「Design by AI，验证靠签核」，配安全沙箱、灾难处理与基于签核计算引擎的评测系统〔A〕；Argus 已支撑 >18,000 颗芯片流片验证、国产先进工艺 PDK 覆盖率 >80%〔B，据华大披露〕；案例为单一 IP（0.18μm Bandgap）与开源 CPU，非客户量产项目〔B〕。
- **改变了什么**：上期只有 Siemens Fuse EDA Agent 的 benchmark 口径（背景）；本期验证器进入具名客户落地与商业化产品，并出现第三方基准 NAFEMS×Rescale AIPhysics.org（10-28）〔A〕。采购核心条款转向「验证器归属、能否本地运行、拦截证据」。
- 证据级摘要：发布/架构 A；效果数字 B；无拦截率披露。来源：huawei.com/en/news/2026/10/nisco-yuanye-steelmodel；honeywell.com 10-26 新闻稿；nasdaq.com 转 BusinessWire（Maestro、Q3）；eet-china.com/news/202610278083.html；nafems.org 10-28。

### TOP2｜政府开始管交付与后果：立项评估、场景预算、交付团队、标杆名单同周出现
- **判断**：中国政策工具从上期的「给结果付费、应用考核技术」进一步前移到立项与采购程序——AI 场景项目要评估就业后果，场景清单要写明预算与采购方式，服务商要报交付团队。
- **国办发〔2026〕29 号**（成文 10-16，gov.cn 发布 10-23）《关于适应人工智能技术发展助力构建就业友好型发展方式的意见》，8 部分 18 条〔A，全文〕。第（七）条：「对市场准入领域可能造成较大就业冲击的人工智能应用场景项目，在评审时同步开展就业风险评估」；第（六）条：优先在劳动力紧缺、环境高危等岗位推广，「稳慎把握人工智能在劳动密集型行业应用的范围、力度、节奏」，鼓励企业探索失业缓冲期制度〔A〕。未载明评估标准、评估主体、缓冲期时长与资金规模〔A，未载明〕。
- **南京市人工智能产业发展和创新应用促进条例**（10-28 市人大常委会表决通过）〔A，事件〕：场景清单同步明确牵头单位、开放数据接口、试点预算、验收标准和采购方式；「发现需求—发布场景—付费试点—评估验收—创新采购—全市复制」闭环；国有资本对 AI 产业基金「不以单个项目或单一年度盈亏作为考核依据」〔B，据交汇点新闻转述；条例全文未取得〕。尚需省人大常委会批准，施行日未见报道〔D，常规程序推断待核〕。
- **江苏省工信厅 AI 应用服务商征集**（成文 10-22，公开 10-26）：服务商档案「另设『前线部署工程师（FDE）团队』专项选项」，省厅组建资源池、服务团和 FDE 团队库，择优向工信部推荐；填报 10-22 至 11-10〔A，转载全文〕。新疆、山西此前仅为倡议句式，江苏首次「填报+建库」〔B，第三方比较〕。
- **工信部 2026 年度领航级智能工厂项目培育名单公示**（10-26 20:36 发布，公示 10-27~11-02，装备工业一司）：34 个项目〔A，官方原文经浏览器取得〕；项目名写明 AI/智能体/工业智能的至少 7 个，如小米汽车「AI 驱动的敏捷制造…」（序号 1）、中兴通讯（南京）「多智能体驱动『双流』自主流转…」、江西铜业「AI 赋能…」、泸州老窖「非遗技艺传承与 AI 融合创新…」〔A〕。公示不等于最终认定；项目 AI 方案与投入未披露。
- **改变了什么**：对解决方案商，投标材料重心从技术方案转向「交付团队 + 验收指标 + 社会影响说明」；南京式场景采购有望减少免费 POC。
- 证据级摘要：29 号文 A；南京条款 B；江苏 A；工信部 A。来源：gov.cn/zhengce/zhengceku/202610/content_7084108.htm；finance.sina.com.cn/jjxw/2026-10-28/doc-iniwuvct9400874.shtml；ntrjw.cn/news/366；miit.gov.cn 公示页。

### TOP3｜广告创意的价格结构被改写，创意工具转向「被智能体调用」
- **判断**：投放端学会「读创意」后，价值从创意构思迁往大量可测试的素材变体；同周创意工具把能力拆成 MCP/插件/Skills/API，入口之争从「谁被打开」变成「谁被调用」。
- **WPP Q3 交易更新（10-29）**：WPP Creative（含 Enterprise Solutions）-5.1%（Q2 -3.5%），WPP Production +2.5%，WPP Media +0.3%；电信/媒体/娱乐客户 -15.7%；扣除转付成本收入 24.11 亿英镑（-2.1% LFL）〔A，RNS〕。
- **Meta GenRecs（10-28）**：LLM 读取广告文本与图片，用共享「语义 token」描述品牌、颜色、风格等属性，替代以广告 ID 为单位的学习，缩短冷启动〔A/B，AdExchanger 专访 + 工程博客标题〕；Meta 称排序改进在 Q2 带来 Facebook 点击 +8.3%、转化 +15.7%〔B〕。
- **Runway Ads GA（10-27）**：连接 Meta/Google/TikTok 广告账户读成效，生成「只改一个变量」的变体，所有广告须团队成员审批后发布〔A〕；Runway 自述内部周广告产量 <100→约 1,000、订阅获客成本 -41%〔B〕。
- **工具被调用**：Canva MCP 自助 GA（10-27；只支持个人 OAuth，不支持组织级/服务账号认证）〔A〕；Runway App Studio（10-26，把工作流冻结成带界面的应用，按积分计费）〔A〕与 Runway Dev 上架 Codex（10-28）〔B〕；可灵 4.0 API 面向全球企业开放（10-28）〔A/B〕；美图 RoboNeo 以 Skills 上架 WorkBuddy（10-27）〔A〕。
- **改变了什么**：按工时计价的整合创意代理首先承压，代理商护城河收缩到数据层与托管运营；企业内容中台选型要看「能否被通用智能体无人值守调用、按席位还是按调用计价」。
- 证据级摘要：WPP A；Meta 机制 A/B、效果 B；Runway 功能 A、ROI B；Canva A。来源：investegate.co.uk WPP RNS 9846880；adexchanger.com 10-28；runway.com/news（App Studio、Ads）；canva.dev/blog/developers/canva-mcp-ga/；stock.10jqka.com.cn/20261029/c681256095.shtml。

### TOP4｜受监管金融把数据交给 Agent，动作留在既有审批；卡组织先定令牌与争议规则
- **判断**：银行与卡组织的 Agent 化先开放「读」、后开放「做」；放量前提是身份、授权与争议处理闭环，而不是模型能力。
- **HSBCnio（10-26，香港）**：面向企业与机构客户的交易银行方案；客户自有 AI 工具可经「HSBC Model Context Protocol」以只读方式访问已授权的账户与交易信息，用于流动性预测、差异分析、跨境现金报告；复用 HSBCnet 既有登录与权限；提供 API 文档、SDK、沙箱；「Ask HSBC」后续上线〔A，新闻稿 PDF〕。写操作沿原渠道为分片推断，新闻稿只写只读〔D，推断〕。
- **Mastercard Q3 电话会（10-29）**：Miebach 原话：「For trust in the payment, tokenization is embedded in Agent Pay」；「With OpenAI this quarter, we signed a broad strategic partnership that includes the use of Agent Pay and goes well beyond」；「It is still early days, and the numbers are not yet significant」〔A，电话会转录原话经浏览器取得；内容为公司表述〕。一次性虚拟卡「not a long-term solution that we will support」〔B，据 PYMNTS 引述，转录中对应答复未逐字摘录〕；CFO 把面向 Agent 的额外令牌功能列为定价方向〔B〕。
- **Visa FY26（10-27）**：CEO 称 agentic 处于「nascent」阶段，需先确保出问题时有清晰的争议、规则、流程路径〔B，据 Payments Dive〕。
- **Shopify Fall '26（10-28）**：Shop Pay 进入个人 Agent（Meta Muse、Claude Duet、Instinct 首批）；非 Shopify 商家的 Agent 购买用 Mastercard/Visa/Discover 网络令牌，Amex「即将」〔A〕。
- **改变了什么**：财资 SaaS/ERP 厂商获得「银行 MCP」新接入点；Agent 支付路线出现「网络令牌直通 vs 虚拟卡」分歧（Stripe Link 虚拟卡模式为 10-21 背景），2027 年前放量取决于规则发布与令牌定价。
- 证据级摘要：HSBC A；Mastercard 原话 A（内容 B）、VCN 表述 B；Visa B；Shopify A。来源：about.hsbc.com.hk 261026 PDF；fool.com Mastercard Q3 2026 转录；pymnts.com 10-29；paymentsdive.com 10-28；shopify.com/news/fall-26-edition-merchant。

### TOP5｜公共采购转向按量计价：从联邦政府到乡村学校
- **判断**：政府与公共服务买 AI 的方式从「席位/项目一次性建设」改为「用多少付多少」，价格锚点与可替换性成为竞争焦点。
- **GSA × Anthropic OneGov（10-27）**：所有政府可用 Claude 模型 token 用量 40% 折扣，含 FedRAMP 授权环境；无最低订购、按用量付费；联邦、州、地方、部落政府均可购买〔A，GSA 新闻稿〕。OneGov 累计为联邦节省 18 亿美元+〔B，据 GSA〕。背景：OpenAI OneGov（09-10）50% token 折扣。
- **贵州乡村学校 AI「以购代建、按量付费」（10-27 活动，10-28 报道）**：教育厅称欠发达地区 AI 教育「从买硬件转向买服务」「由一次性建设转变为持续性运营，通过按量付费模式」〔A，官方表态经中新网贵州转述〕；在 20 个国家乡村振兴重点帮扶县 100 所中小学试点，覆盖 1292 个试点班、22.8 万名师生〔B，据贵州省教育厅〕；省—县—校三级平台，汇聚多元厂商模型能力、「优胜劣汰」〔B〕。单价、年度预算、厂商名单与效果口径未披露。
- **同向信号**：重庆南岸「教育算力券」（B，报道 10-26）；英国 £50m 公务员 AI 转型基金绑定「再节省 £600m 后台成本」（B，CSW 10-28）。
- **改变了什么**：厂商收入随用量波动、需接受多厂商竞价与淘汰；政府市场形成 token 价格锚（OpenAI 50%、Anthropic 40%）。
- 证据级摘要：GSA A；贵州模式 A、规模 B。来源：gsa.gov 10-27 新闻稿；gz.chinanews.com.cn/jjgz/2026-10-28/doc-ihfmppat9986350.shtml。

### 候补（未进 TOP5）
英国 AIBL（政府 £1 亿 + OpenAI/Anthropic 模型额度）；Xaira X-Automate（HPLC 利用率 53.6%→97.2%，自述）；Salesforce Agent Fabric 评测/熔断/硬预算；UMG 要求 DSP 对 AI 内容差异化结算；美的 2025 年 AI 降本约 6 亿元、2026 年目标 9 亿元；纽约州儿童聊天机器人安全法；Dassault ArisGlobal 交割的 AI 收入里程碑对价。

## 3 四行业分节（含有料/静默标注）

> 计数口径（全刊统一，亦用于图 1）：各组 coverage.md 固定对象行中「窗内有动态」（含弱动态、窗内报道）的行数；名单外纳入另计；边界项与静默不计。工业制造 = A1（24 行）+ A2（22 行），华为在两组各计一次，去重后有料 18 个对象。

### 3.1 工业制造（A1 现场与产线 + A2 工程工艺与工业智能基座）｜有料

- **覆盖**：固定 46 行（A1 24 + A2 22），有料 19 行（去重 18 个对象），静默 27，未取得 0；名单外纳入 A1 7 条、A2 4 条。
- 有料：Rockwell、Schneider、ABB（弱）、Honeywell、Foxconn、Hitachi、海尔卡奥斯、美的、华为（南钢）、工信部（A1）；Dassault、Siemens DISW（弱）、Cadence、Hexagon、Cognite、中望、华大九天、索辰、华为（A2）。
- 静默（核验入口见各组 coverage）：Siemens（Industrial Copilot，10-21/22 背景）、GE Vernova/Aerospace、NVIDIA 工业（作为底座出现）、Microsoft/AWS/Google Cloud 制造、Bosch、宁德时代、比亚迪（事件 10-21 背景）、三一、树根互联、阿里云/百度智能云工业、中控（10-27 仅二次报道，事件 10-16）；Autodesk、PTC、Synopsys/Ansys、Bentley、AVEVA、AspenTech、Palantir、C3 AI、NVIDIA Omniverse、PhysicsX、浪潮、阿里。

**3.1.1 架构收敛：大模型编排 + 机理/物理模型约束 + 本地推理**（详见 TOP1 与 §4）。海尔卡奥斯（10-26 新华网、10-28 重庆站）：大模型负责工业语义理解、任务拆解、智能体编排，4700 多个机理模型、200 多种专家算法负责数值计算与执行约束；落地 93 个高价值智能体〔B〕；IDC MarketScape 将 COSMOPlat 列为领导者〔A，转述，IDC 原文未取得〕；重庆冰箱互联工厂 GenAI 维修助理使维修效率 +75%、新员工培训时间 -50%〔B〕。与南钢「左右脑」、Honeywell「UOP + Nemotron」同构。背景：GB/Z 195-2026 工业智能体参考架构（07-30 发布）把「大模型库 + 小模型库（含机理模型）」写进参考架构〔B，二手解读〕。

**3.1.2 价值口径从工位 KPI 升到集团财务账本，但多为毛口径。** 美的（10-23 WAIE）：Factory Agent 在 32 座工厂落地，795 个垂域模型算法、私有模型占比 >80%，2025 年 AI 相关降本约 6 亿元、2026 年目标 9 亿元〔B，经 OFweek→万有知兴二手转载〕；10-29 三季报：超过 2 万个智能体、排产响应提速 50%，机器人与自动化营收 249 亿元（+10%），自研 CDU 落地阿里云 CUBE5.0〔A 三季报口径 / B 智能体效果〕。富士康（10-26 官网）：排产人工工时 -25%、注塑换型工程量 -50%、SMT 20 多个主要缺陷根因纠正率 >90%，智能体部署到 200 多个厂区〔B，Foxconn/NVIDIA 联合披露，基线未披露〕。判断：大型制造集团已把 AI 当经营 KPI 管，但是否扣成本、基线是什么普遍不透明。

**3.1.3 质检是本周最可复制的现场场景，范式切到「良品建模/VLM」。** 联想天津（10-23 论坛，天津日报 10-25）：屏幕检测引入视觉语言大模型识别新型缺陷（如水波纹），不良率 3.5%→0.4%；AI 巡检机器人一天覆盖原需一周的高风险工站，效率提升 4 倍以上〔B〕。LSK iRobot / One Touch AI 越南载盘产线（10-27）：穹顶 RTI 成像 + 良品三维基准比对，不依赖缺陷库，单件节拍 10 秒→0.5 秒、准确率 70%–95%→98%，11 月起分阶段投用〔B〕。微链道爱 ACI（10-26，软文）：单块良品冷启动，累计部署超 1000 台套〔B，仅作趋势佐证〕。

**3.1.4 编排层争夺：控制层、业务层、算力层三方入场。** Rockwell Automation Fair（10-27）：LogixEdge 跑 AI 负载、FactoryTalk Conductor（10-21 首发背景，2027 Q1 商用）、Plex AI 质量管理〔A〕；食品饮料调研：约 45% 采集数据被有效利用〔B〕。SAP Physical AI（10-27 TechEd）：EWM/PM 业务系统触发机器人或无人机动作、结果回写 SAP 留审计轨迹；富士康、Arçelik-LG、Intel 成都（PoC）、Holcim 为客户样本〔A 发布 / B 效果〕。NVIDIA 在 Honeywell、Foxconn、Schneider 稿件中以「Nemotron + Omniverse + Cosmos/Metropolis」组合出现，由 Dell/HPE 打包本地交付〔A，第三方稿件〕。富士康同周出现在 NVIDIA 栈与 SAP 栈，说明头部客户多栈并用。

**3.1.5 交付人力被定义为瓶颈。** Hitachi（10-27/28）：2027-04-01 将 GlobalLogic 与 Hitachi Digital Services 合并为 Hitachi Digital，约 35,000 人，以前置工程师（FDE）进驻客户现场为交付核心〔A〕；Hitachi Energy×Celonis 用 Context Model 做缺料预警〔A，无量化〕。与江苏 FDE 团队库（TOP2）同频。

**3.1.6 工业孪生的新客户是 AI 数据中心。** Schneider/AVEVA×Nscale×Start Campus（10-27）：在葡萄牙 1.2GW SINES 园区 SIN01 完成 Omniverse DSX「Immersive Twin」现场试点，用 OpenUSD 连通供电、冷却、电气与运营模型做 what-if，无量化结果〔A 试点 / B 预期〕。美的 CDU 落地阿里云为供给侧对照。判断：数据中心本质上是流程工业（电和冷），工业孪生厂商正把流程工业孪生能力转卖给「AI 工厂」。

**3.1.7 工程软件的 AI 价值写进交易与价格条款。** Dassault（10-28）：宣布完成 ArisGlobal 收购，交割现金 18 亿美元，另有最高 2 亿美元与多年期 AI 相关收入里程碑挂钩的或有对价〔A〕；Q3 3DEXPERIENCE 软件营收 +25%〔A〕（注：交割实为 9 月下半月，10-28 为宣布日）。Hexagon PC-DMIS 2026.2（10-29）AI 边缘检测，AI 细节未披露〔A/D〕。Circuit Mind（10-28）：融资 2,500 万美元并发布 AVE 验证 Agent，Schneider CTO 称早期评估架构探索工作量可降 >90%〔A 融资 / B 效果〕。Dream（10-29）：a16z 领投 1,700 万美元种子，建筑世界模型已在 10 个在建项目部署〔B，机制未取得〕。国产侧：中望 Q3 营收 2.198 亿元（+7.61%），AI 尚未单列收入〔A〕；索辰 Q3 营收 9,977 万元（+105.46%）、归母净利 -1,654 万元，自述物理 AI「处于布局初期」〔A〕——资本预期领先于工程交付。背景：Autodesk Fusion agent 动作消耗 Flex Token（10-06，D）。

**3.1.8 仓储成为人形机器人多仓复制现场（与具身周报去重，仅保留现场视角）。** GXO×Agility（10-26）：Digit 扩到 Statesville、Lebanon 两个新仓，2027 年初部署，RaaS 模式〔A〕；Flowery Branch 累计搬运超过 10 万个料箱〔B〕。京东物流×智元 G2 Max（10-26）：每小时拆垛 80 箱、码垛 75 箱，作业成功率 >99%〔B〕。制造工位人形机器人本周无新节拍数据（A1 范围），Schaeffler 太仓（10-20）为背景。

**3.1.9 地方场景清单撮合。** 贵州（10-27）：第三批 150 个 AI 应用场景开放清单；磷化集团煤化工能耗优化大模型「机理 + 数据 + CV」，工艺参数波动 -42%、年减排约 2 万吨 CO₂〔B〕。工信部领航级 34 项见 TOP2。

模块洞察：①竞争维度从「模型强不强」变成「谁拥有机理模型库、工艺包和验证技能库」；②价值口径上移但缺净收益与基线，采购方应按「净收益 + 基线」验收；③质检与供应链 AI 由品牌方推向供应商与海外工厂。

### 3.2 创意与内容｜有料

- **覆盖**：固定 27 行，有料 17，静默 10（Figma、OpenAI Sora 合作方、Netflix、Disney、Warner/Lionsgate、Ubisoft、网易、Spotify、Sony Music、阿里通义万相），未取得 0（Luma 原始页 403，以二手入表 C/D）；名单外纳入 5。
- 有料：Adobe（弱）、Canva、Runway、Pika（Luma C/D）、Google Veo/Flow、Meta、WPP、EA（负面 C/D）、腾讯游戏、UMG、Suno、新闻出版商×AI、快手可灵、字节即梦/Seedance、美图、SAG-AFTRA、AIGC 标识监管。

**3.2.1 价格结构与工具被调用**：见 TOP3。补充：Pika H3 Flex（10-29）对 MiniMax H3 后训练、采样步数 50→6，开放 adapter 与推理代码，4K 上采样与音频分轨留在托管 API〔A〕——「开放权重换生态、托管收费锁价值」；Utopai 也基于开源 MiniMax H3 改造自有模型〔B〕。Adobe 窗内仅合规与管控动作：APAC 渠道称 Firefly 输出被诉时合同赔付〔B，单一报道〕；企业管理员需分别治理助手入口与模型白名单〔C〕。

**3.2.2 代价侧从「训练合法性」转到「分配与入口规则」。** UMG Q3（10-29）：营收 33.94 亿欧元（+12.3%）〔A〕；Grainge 称「不道德生成的 AI 曲目永远不应与真正创造持续需求的音乐按同一基础计酬」「DSP 协议结构必须改变」，授权 AI 合作预计 FY27 开始贡献增量收入〔B，两家媒体相符引述〕。Suno 案（Billboard 10-27）：取证延伸至 Apple Music、MLC、DistroKid、Lightspeed、Bond；10-26 法院准许原告取证 Menlo Ventures 前合伙人〔A/B〕；取证持续到 2027 年中。挪威 10 家媒体（10-27）申请临时禁令阻止 Meta 新商业条款取得内容 AI 使用权，Meta 已推迟至 11/20〔A〕。猫王作品权利方诉 Anthropic（10-23 美西，274 首歌词）〔A 起诉事实 / D 指控〕；Poseidon 诉 Black Forest Labs FLUX（修订 10-22，报道 10-27），以 §1201 反规避为主轴〔A/D〕。工会：SAG-AFTRA TV 动画协议表决于 10-29 17:00 PT 截止（=10-30 08:00 上海，结果窗外未取得），AI 多语种配音需事先同意〔A 条款〕；IATSE 10-23 任命首位 AI 官（Labor and Technology Intelligence Officer），指向 2027 年谈判〔B〕。

**3.2.3 中国 AI 短剧「工作室化 + 合规化」。** Seedance 2.5 4K（10-23）：480P 样片验证分镜→4K 正片，仅部分企业客户试用〔A〕；即梦「短剧工作室」（10-26）：DreamScript 剧本模型、10 万字上传、100 集连续生成、团队版统一积分〔A〕。监管：北京截至 10-28 累计 325 款生成式 AI 服务完成备案，重申公示备案编号与标识义务〔A〕；《微短剧发展管理办法》按投资额三类审核，使用 AI 生成制作的微短剧须在每一集明显位置添加提示标识〔A/B，地方解读〕；AI 剧分档口径 80/30 万元〔C/D，未见总局原文〕。

**3.2.4 AI 原生制片商用格式化报价抢「非好莱坞」预算。** RisingJoy（10-26）：到 2027 年 Q1 末 30 部 AI 辅助竖屏动画，已交付 6 部，与 NTT Docomo Studio & Live 签非独家分发 MOU〔A/B〕；Inevitable：报价「25 万欧元起」/「30 万美元起」口径不一，两部在制影片无上映日期〔C〕；Utopai：据 The Information，以 10 亿美元估值融资 6,000 万美元，计划 2027 年三部院线 AI 长片〔B，单源〕。

**3.2.5 游戏：中台化插件 vs 自上而下强推。** 腾讯 Motus AI（10-28 报道）：3D 角色动画全链路，接入 90 余个项目〔B，单一媒体独家〕；EA（10-27 报道）：裁员 400 人、BioWare 关闭后强推 GenAI 致士气下滑〔C/D，匿名信源〕。Google×Akuna「From Script to Screen with AI」（10-28）以培训 + 少量资助 + 分发窗口导入非洲创作者〔A/B〕。

模块洞察：①计价锚分化——Canva 按席位、Runway/可灵按积分/调用，无人值守批量生产更易落在后者；②企业采购尽调应扩展到「集成的第三方模型（尤其带音频的视频模型）的数据获取方式、赔付是否覆盖第三方模型输出」；③合规成本推动 AI 短剧产能向有审核能力的工作室与平台集中。

### 3.3 商业与公共服务｜有料

- **覆盖**：固定 37 行，有料 20（含弱/窗内报道），边界 5（Amazon、JPMorgan、Goldman Sachs、Uber、美团，均记背景），静默 10，未取得 2（Klarna：klarna.com 403 + WebSearch 仅聚合站；滴滴：WebSearch + dpshk.com 软文 D 级）；名单外 2。**本期未覆盖**：微软与中国办公 Agent（不在固定名单）。
- 有料：Walmart（弱）、Shopify、Salesforce、ServiceNow、SAP、Oracle、HSBC、DBS（弱，调查）、工商银行（报道窗内、事件 10-19 背景）、Visa、Mastercard、PayPal（弱，无 agentic）、蚂蚁、Verizon、Harvey、LexisNexis、GSA、英国政府、中国政务（青浦）、德勤。
- 静默：Morgan Stanley、招商银行、Stripe（10-21 背景）、AT&T（背景）、中国移动、Grab（背景）、Thomson Reuters（背景）、新加坡 GovTech、埃森哲（背景）、麦肯锡。

**3.3.1 Agent 准入层做成产品与规则（新出现）**：开放受控一方——HSBCnio MCP 只读（TOP4）、Shopify 知识库（平台起草退货窗口等事实，商家审核发布后 Agent 才能拿到）与 shop.md 购物技能（10-28）〔A〕、SAP 第三方 Agent 经受治理 agent gateway 调用 Joule Agents + Enterprise AI Gateway（10-27）〔A〕。设门槛一方——Verizon（10-26 电话会）：「除非 100% 确定是真实客户而非流氓 Agent……否则不允许 Agent 访问我们的平台」〔B，转录〕；Visa 先建争议规则；JPMorgan 拒绝外部 Agent 操作（10-22 背景）。蚂蚁灵光 2.0（10-27）：独立云主机承载常驻任务，用户退出对话后任务继续运行，内置支付宝账单/会员/出行〔A〕——Agent 从「替你下单」推进到「替你盯账、发现被遗忘的自动续费」。判断：决定哪家开放的是身份 + 授权 + 争议闭环是否在自己控制内。

**3.3.2 Agent 运营治理成为 GA 功能。** Salesforce Agent Fabric（10-27）：Agent Kill Switch、FinOps Dashboard、Model Wallet（超预算前直接拒绝请求的硬上限）即日 GA；Agent Evals/API Evals 11 月 beta、2027-01 GA；成本优化策略「基于测试场景」最多减少 75% token〔A / B〕；官方头号场景是「零售商换低价模型后客服答错延迟订单」〔A〕。ServiceNow Q3（10-28）：2026 年 AI ACV 目标上调至 17 亿美元，生产环境 agentic AI 消耗同比 13x+，订阅收入 39.88 亿美元（+21%）〔A〕；GAAP 营业利润率 9.5%（去年同期 17%）〔A〕；Action Fabric 把工作流无头化暴露给 ChatGPT/Gemini，动作仍在 ServiceNow 治理下执行〔A〕。SAP 托管运行时部署自定义 Agent 免费至 2026-12〔A〕。Oracle（10-26）：25 个由 Fusion Claw 驱动的 Agentic Applications，普遍为「分析→准备方案→人审批→执行」，无具名客户〔A〕。判断：运营主矛盾从「能不能做」转向「便宜了会不会错」，采购清单出现评测覆盖率、熔断时延、预算硬上限。

**3.3.3 法律 AI 竞争转向验证与可审计。** LexisNexis Protégé（10-27）：Shepard's Verify 核对引证状态、引文以及被引权威是否支持所述主张；Workrooms 带防篡改审计日志〔A〕。Harvey（10-28）：获 FedRAMP Class D（运行于 Knox Systems 环境），并在 Claude 内推出 Intake artifact 经 Harvey MCP 路由法律请求〔A〕；FedRAMP 打通后可直接接上 GSA OneGov 同周的政府 AI 放量（C 组判断）。

**3.3.4 中国银行业：分层授权与平台化采购。** 工行刘珺（10-19 外滩年会，21 世纪经济报道 10-23）：按业务属性分层授权，以「收益证明」划定 AI 部署责任〔B，背景〕。遂宁银行 AI 大模型平台及场景建设采购项目中标结果公示（10-29，四川招投标网）〔A，标题与日期〕；中标方、金额与建设内容需会员登录，**本次未取得**（已试：scbid 移动页未登录浏览、WebFetch/curl）。

**3.3.5 公共部门：消耗计价、节省 KPI 与劳资阻力。** GSA 见 TOP5。英国（10-24 GOV.UK）：£600m+ AI 包，含 £60m National Cyber Shield（研究 agentic 网络安全监管沙箱）、AISI 追加 £120m〔A〕；HMRC「Ask HMRC」2025-26 年约 630 万次交互〔B〕；10-28 Budget：£50m 公务员 AI 转型基金由内阁办公室新团队 GovAI 管理，目标再节省 £600m 后台成本；Prospect、PCS、FDA 工会公开质疑〔B，CSW〕。上海青浦（10-27）：政务智能化「四个一批」，杜绝重建设轻应用，数字化建设纳入年度绩效考核〔A〕。德勤×Dayforce（10-27）：SOX 404 薪酬控制审查做成 Dayforce 原生应用并保留审计轨迹〔A〕。

模块洞察：①准入分两条路线，取决于身份/授权/争议闭环归属；②成本与质量权衡正变成合同条款；③公共采购机制改变与劳资阻力同周公开。

### 3.4 教育科研｜有料

- **覆盖**：D 组教育 13 行 + 科研 10 行 = 23 行，有料 11（教育 6：教育部、地方教育局、美国 K12 学区、Google Gemini for Education、Microsoft 教育、英国 DfE；科研 5：Anthropic、DOE Genesis、中科院/科学大模型生态、自动化实验室、英国 AIBL），边界/线索 2（讯飞 1024、高校算力采购），其余静默（高校部署、Khanmigo、ChatGPT Edu、Claude for Education、作业帮等、考试诚信、DeepMind/Isomorphic、Microsoft Discovery、FutureHouse/Periodic/Lila、之江/上海 AI 实验室）。

**3.4.1 采购方开始给教育 AI 设计计量与效果门槛。** 贵州按量付费见 TOP5。重庆南岸区教委十条措施（据多知报道，10-26）：每 6 个班配 1 名专（兼）职 AI 教师；通识课时小学 1–2 年级 ≥10、3–6 年级 ≥25、初高中 ≥30；探索「教育算力券」〔B，原文未取得〕。Loudoun County（10-28 官方公告）：11 月起 8 校试点 Gemini Notebook，走学区 Workspace for Education 账号〔A〕；背景：9-22 董事会称 Chromebook 从 $365 涨到 $500 以上〔B，窗外〕。Bloomington ISD 271（10-26）：董事会批准 Colleague AI 小范围教师试点，并与华盛顿大学研究其是否与学生学习可测提升相关〔B〕。教育部「扶光计划」中小学 AI 素养提升项目（10-28 南宁首站）〔A 事件 / B 内容〕。Microsoft 扩展版 AI Classroom Toolkit（10-27，免费）〔A〕。Oxford×DfE（10-26）：六个月研究学生数据作为公共品，产出「Pupil Data Commons」指南与 AI 保证/认证建议〔A〕。判断：教育 AI 瓶颈从「能不能用」转到「谁来管、怎么计费、怎么证明有效」；讯飞 1024 推批阅机、AI 黑板等专用硬件（10-22，背景）与「买服务」趋势存在张力。

**3.4.2 前沿模型公司成为国家科研的「实物出资方」。** 英国 AIBL（10-24 gov.uk）：政府出资 £1 亿；OpenAI 提供 £1 亿算力与模型额度；Anthropic 提供最高 £1 亿模型额度；DeepMind、Basecamp Research 为研究合作方；国家 AI 生物安全计划合计 £1.65 亿〔A〕。Anthropic AI for Science（10-28）：扩展到 NSF、Simons、Sloan、EMBL、Sanger 等 20 家资助方与机构，并与 HHMI Janelia 共建 Model Hardware Standard（MHS）〔A〕。DOE Genesis Mission：10-26/10-29 新增国家科技挑战页；10-29 Cadence 加入 Genesis Mission Consortium〔A〕；PNNL 闭环选择性沉淀工艺已回收高纯镁、钐、稀土〔A/B〕。中科闻歌 ScienceOra（10-26）上线腾讯 WorkBuddy，首批 30+ 科研专家智能体〔B〕——中国 AI4S 走互联网平台分发，美英走资助机构发额度。

**3.4.3 自动化实验室的瓶颈是仪器接口。** Xaira X-Automate（10-23）：7 天现场部署，自主转运、上样并分析 18 块 96 孔板，HPLC 利用率 97.2% vs 人工模拟 53.6%；VLM 代理经 API 与 Windows Accessibility 控件操作仪器软件，绕开 HPLC 自动化 API 许可；上游冷藏存板 4 次中断需人工恢复〔A 发布 / B 数字〕。判断：「仪器利用率」口径比「发现速度」更易被采购方复核，可能成为自动化实验室的主流卖点（D 组洞察）。

模块洞察：①计量方式替代硬件清单成为教育 AI 采购核心；②「有效性证据」开始写进合同；③AI4S 采购越来越经资助与联盟协议而非招标；仪器接口规范（MHS、SCP-Lab 背景）将决定自动化实验室分发。

### 3.5 政策专项（单列）｜有料

- **覆盖**：D 组政策 15 行，有料 6（国务院/国办、中国地方 AI+、科罗拉多、纽约、英国、新加坡），静默 9（发改委、工信部 D 无新增〔领航级归 A1〕、网信办、TC260/TC28、美国联邦、加州、欧盟、香港、马来西亚/东南亚），未取得子项 2（云南 AI「一人公司」措施：转载站 502；TC28：无官方入口命中）。
- 中国：国办 29 号文、南京条例、江苏 FDE 库见 TOP2；江苏省数据局/发改委 10-23 发布 100 个「人工智能+」典型应用场景〔A/B〕。
- **部署方责任入法（海外）**：纽约州 S.9051B/A.10379C（10-28 签署）：禁止对未成年人或未确认非未成年人的用户提供假装真人、恋爱关系、鼓励自残等功能；须年龄验证；每次违规最高 $25,000，AG 可要求销毁非法收集的数据或以其训练的 AI 模型〔A〕；施行日 2027-01-01 据第三方报道〔C〕。科罗拉多（10-26）：SB 26-189 ADMT 规则与 Chatbot Safety Act 正式听证，二者 2027-01-01 生效〔A〕。新加坡总理黄循财（10-28）提议自愿参与的国际 AI 事故报告试点，先统一事故类别与共享字段〔A〕。
- 静默核验：欧盟窗内仅 DSA 执法，AI Act 高风险分类指南仍为 05-19 草案；香港数字政策办公室窗内仅 10-29 网络攻防演练；TC260 最近为 10-13〔A，入口列表〕。
- 洞察：中美监管共同落点是「部署方责任」（国内 29 号文的失业缓冲期同样落在推广 AI 的企业）——下游行业客户将承担更多合规成本，采购合同的责任分配条款随之改变。

## 4 主线专题：验证器在大模型之后（topic.md 压缩）

**结论**：本周至少 6 个彼此独立的工程/工业案例（南钢×华为元冶、Honeywell Forge Plant Cognition、Cadence Maestro、华大九天 .aix、ChipAgents IC-star、Circuit Mind AVE，覆盖钢铁、炼化、芯片设计、PCB）让大模型负责理解意图、拆任务、生成候选，由确定性的求解器、机理模型或签核引擎判定对错。没有确定性验证器的商业场景改用权限、评测与熔断兜底（HSBCnio、Salesforce Agent Fabric）；法律是商业侧少见的例外（LexisNexis Shepard's Verify 基于引证知识图谱）。

**验证器接入的三个位置**（topic §1、§4）：

| 位置 | 案例 | 经济性 |
|---|---|---|
| 推理时把关 | 华大 .aix 签核评测；Circuit Mind AVE 按 datasheet 与企业规则核查原理图；南网「云睿」安全校核（系统 2025 年落地，窗内披露，背景） | 降低出错率，但每次生成都要付一次求解成本 |
| 训练时做奖励 | Cadence Maestro 求解器打分构成 RL 回路；ChipAgents 用仿真与验证反馈后训练 Nemotron（10-27，「engineers retain control over requirements and signoff」） | 求解成本前置到训练；Cadence「token 效率最高 5×」对应此点〔B〕 |
| 运行时分工 | 南钢「左脑机理/右脑概率」；Honeywell「物理模型 + Nemotron 智能体」 | 概率模型只做预警与语义，数值决策交给机理与运筹模型 |

**机制解释**：①错误代价不对称——Circuit Mind 原文：「'99%' right means months of delay」〔A，新闻稿原话〕；②这些行业早有 ground truth 生产机器（签核、仿真、机理、潮流计算），大模型接入后它们从「工程师工具」变成「智能体裁判」，所以最完整的案例来自持有验证器的老牌厂商（Cadence、华大、UOP）；③验证器的边界就是自动化的边界——有验证器的环节可多轮自主迭代（华大 Custom.aix 近百次迭代），没有的环节走只读、人审批、熔断；南钢原文「受控嵌入现有调度流程」说明工业现场的执行仍走既有审批链；④下一层问题是谁验证验证器：NAFEMS×Rescale AIPhysics.org（10-28 慕尼黑）用公开训练数据、盲测保留集和公开方法评估 AI 仿真模型，首批 5 个问题覆盖结构、流体与碰撞〔A〕。

**代价与局限**：验证器要算力与数据底座（南钢 100% 设备联网、计划共建数据中心）；所有效果数字为厂商/客户自述（B）；没有一家披露验证器拦截率或误拦率；Cadence 签核责任分配、华大「灾难处理」、Honeywell 是否闭环写控制回路原文均未披露（topic §7）。背景对照（窗外）：和利时 XWorld「不可行方案必须说明冲突约束」、Agent「不直接写入 DCS 控制回路」（10-10/14）。

## 5 解决方案五要素对比表（精选 16 行，含证据级）

| 行业/场景 | 主体 | 怎么搭(摘要) | 交付对象 | 代价/坑(已披露) | 证据级 |
|---|---|---|---|---|---|
| 钢铁·全工序 | 南钢×华为「元冶」 | 左脑机理运筹 + 右脑 AI 模型集群；百万级 OT 点位孪生；昇腾/鲲鹏/HCS/盘古 | 南钢炼铁、轧钢、质检、能环部门 | 需 100% 联网前置并新建专用数据中心；单个智能体效益有限（硫控年 60 多万元） | A/B |
| 炼油·全厂优化 | Honeywell×Dangote | UOP 工艺知识 + 物理模型 + Nemotron 智能体 + Omniverse 孪生；Dell 本地部署 | Dangote 炼厂运营与工程团队 | 年 6000 万美元为未扣实施成本的毛估算，不作保证 | A/B |
| 芯片设计 EDA | Cadence Maestro | 领域后训练 LLM + 决策模型 + skills，确定性求解器打分做 RL；云/本地 | 芯片/系统设计团队（Socionext、Silicon Labs） | 仅 Q4 早期访问；性能为初始结果；定价未披露 | A/B |
| 国产 EDA | 华大九天 .aix | 国产开源底模 + 工具 Copilot + 沙箱 + 签核引擎评测 | 模拟/面板/数字/制造团队 | 案例为自选 IP/开源 CPU；底模未具名 | A/B |
| 家电·多工厂 | 美的 Factory Agent | 通用—垂域—专属三层模型，795 个垂域模型，私有占比 >80% | 美的 32 座工厂；美云智数外部客户 | 6 亿元降本口径未拆分；千卡算力投入未披露 | B |
| 电子·质量管理 | 联想天津 | 质量智能体分步审核、人逐步把关；VLM 屏检；巡检机器人生成稽核任务 | 联想质量团队与供应商工厂 | 未披露 | B |
| 仓储/巡检·ERP 驱动 | SAP Physical AI | EWM/PM 触发机器人或无人机任务，结果回写 SAP，可审计 | 富士康、Arçelik-LG、Intel 成都、Holcim | Intel 为 PoC；Arçelik-LG 只给「潜在节省」 | A/B |
| 广告·效果创意 | Runway Ads | 读 Meta/Google/TikTok 成效→单变量变体→人工审批→直投 | 品牌/代理营销团队 | 必须人工审批；耗积分；CAC -41% 为自述 | A/B |
| 设计·智能体接入 | Canva MCP | 远程 MCP 生成/检索/编辑/导出，长任务轮询 | 第三方 AI 应用开发者及其用户 | 仅个人 OAuth，不支持服务账号 | A |
| AI 短剧·全流程 | 即梦短剧工作室 | 剧本模型→全剧资产解析绑定→分镜画布→团队版积分 | AI 短剧/漫剧工作室 | 性能数据为厂商自测；需配合每集 AI 标识 | A/B |
| 企业银行·财资 | HSBCnio | 银行数据面做成 MCP Server，复用 HSBCnet 身份权限，只读 | 在港跨国企业司库 | 仅只读；Ask HSBC 未上线；定价未披露 | A |
| 电商·Agent 渠道 | Shopify | Catalog 结构化数据 + 商家签发知识库 + shop.md + Shop Pay 令牌 | 商家与第三方 Agent 用户 | Amex 令牌未上线；不合规店铺进不了 Agent 流量 | A |
| 客服·Agent 治理 | Salesforce Agent Fabric | 评测→告警→隔离→复测闭环；Model Wallet 硬预算；Kill Switch | CIO/预算 owner（ASICS、Capita、GE Appliances、Newell） | Evals 2027-01 才 GA；75% token 节省为测试值 | A/B |
| 政府采购 | GSA×Anthropic OneGov | 消耗计价 40% 折扣，无最低订购，州/地方可搭车 | 各级政府 | 续签不确定；厂商收入随用量波动 | A |
| 基础教育·乡村普惠 | 贵州省教育厅 | 省-县-校三级平台，多厂商模型聚合，以购代建、按量付费 | 20 县 100 校 22.8 万师生 | 单价、预算、效果口径未披露 | A/B |
| 药物研发·自动化实验室 | Xaira X-Automate | 廉价 6 轴臂 + 视觉 + VLM 代理经 Accessibility 操作仪器软件 | Xaira 内部 | 每台仪器需配置测试；上游存储 4 次人工恢复 | A/B |

## 6 对你意味着什么（编辑建议，面向行业解决方案负责人；均由本稿事实推导）

1. **选型先问「验证器归谁」**：求解器、机理库、签核引擎、规则库属于厂商还是客户，能否本地运行、能否用私有数据再校准（Cadence、ChipAgents 强调本地；Honeywell 跑在本地 Dell AI Factory；南钢计划自建数据中心）。
2. **验收拆两层**：第一层要验证器拦截证据（拦截率、误拦率、被否方案的冲突约束说明）；第二层要净收益 + 基线。本周无一家披露第一层，第二层多为毛口径（Honeywell 脚注、美的降本口径）。
3. **按 ground truth 决定自主度**：EDA/CAE、工艺数值优化可让智能体多轮自主迭代；客服、财资、支付走只读、评测、熔断与人工批准，合同写明评测覆盖率、熔断时延、预算硬上限（Salesforce、HSBCnio）。
4. **成本分两项报价**：要求厂商分开报「LLM token」与「求解器/仿真算力」；推理时把关每次都要求解，训练时做奖励把成本前置。
5. **准备政府项目的新材料**：涉及劳动密集场景的政府/国企 AI 项目，预备就业影响说明与转岗方案（29 号文）；在江苏等地，FDE 驻场团队将成为入库与申报条件，纯模型/纯 SaaS 公司需与集成商组团（服务团）。
6. **按量计价的报价模型**：面向 GSA、贵州式采购，准备 token/用量单价、可替换性与退出条款；收入将随用量波动。
7. **创意与内容采购尽调**：除「是否授权训练」外，加问集成的第三方模型（尤其带音频的视频模型）的数据获取方式、赔付是否覆盖第三方模型输出；Meta 新商业条款 11/20 生效前评估内容权利。
8. **下周跟踪**：AIPhysics.org 首批结果；南京条例全文与施行日；江苏 FDE 附表字段；贵州按量付费单价；Mastercard/Visa 争议规则或令牌定价；Amazon Q3 Alexa for Shopping（窗外，下期）；SAG-AFTRA 动画协议表决结果。

## 7 周环比（本期 10-23~10-29 vs 上期 10-16~10-22；详版见 wow.md v2）

| 主线 | 上周（10-16~10-22） | 本周（10-23~10-29） | 走向 |
|---|---|---|---|
| 可验证工程 AI → 验证器在大模型之后 | Siemens Fuse EDA Agent 7 个求解器自验证（benchmark 口径）；Mistral×NVIDIA 物理 AI 基准计划 | Cadence Maestro、华大 .aix、Circuit Mind AVE、ChipAgents；南钢、Honeywell；AIPhysics.org 盲测基准 | 延续·升级为主线 |
| 流程工业「大模型编排 + 机理约束」 | 中控 TPT + AOP 四家企业 KPI；柳钢转炉预测 | 南钢元冶 25 个智能体/300+ 模型；卡奥斯 4700+ 机理模型；Honeywell×Dangote | 延续 |
| 价值口径 | 兆丰节拍 35–40 秒、成功率 98%、约 3 年回收；中控单装置效益 | Honeywell >0.29 美元/桶（毛）；南钢年降本超 1 亿元；美的 6→9 亿元 | 延续·层级上移到财务账本 |
| 政策工具 | 中办国办「应用考核技术」；工信部四级梯队、卓越级 253 家；广东事后奖补 | 国办 29 号文就业风险评估；南京条例场景预算/验收/采购方式；江苏 FDE 库；领航级 34 项 | 延续·转向管交付与后果 |
| 计价单位 | Copilot 可单独购买 + Credits；可灵按 30 秒/2 分钟计价 | GSA token 40% 折扣；贵州按量付费；Salesforce 硬预算；SAP 运行时免费至 12 月；Mastercard 令牌功能将定价 | 延续·扩展到政府采购、教育与运营 |
| Agent 准入层 | 无对应条目 | HSBCnio MCP 只读；Shopify 商家签发知识库；SAP 治理网关；Verizon 真客户确认；Visa 争议规则 | 新出现 |
| 创意：工具被调用 + 结算规则 | 可灵 4.0 接 MCP/CLI；阅文分成；阿里云数字人退市 | Canva MCP GA、Runway App Studio/Codex、美图 Skills；WPP 创意 -5.1%/制作 +2.5%；UMG 要求 DSP 差异化计酬 | 延续·扩散；广告价格结构新出现 |
| 教育科研 | 讯飞三季报（智慧教育 +20% 以上、扣非 -7.63 亿元）；UNESCO 12 项教师 AI 成果；OpenAI 收购 Orchestra Bio | 贵州/南岸/LCPS/Bloomington 计量与效果门槛；AIBL 公共资金 + 模型额度；Anthropic 20 家机构；Xaira 仪器利用率 | 转向（厂商叙事→采购方规则） |
| 人形机器人进制造工位 | 兆丰×乐聚 15 台常态化上料；特斯拉 Optimus 推迟到 2027 年底 | A1 范围无制造工位新数据；转向仓储（GXO×Agility、京东×智元） | 降温（制造→仓储） |

- **本期未覆盖（不判降温）**：AI 办公席位之争（QuestMobile、中国办公 Agent、微软 Copilot SKU）——C 组固定名单不含该对象，下期补入。
- **消失/降温（含核验范围）**：通用数字人出清无后续（B 组全部分片）；「事后奖补」类工具无新增，政策工具转向程序与交付规则（D 政策 15 行）；AI 制药 BD 群无后续（D 科研 #14–16）；教育公司财报/硬件叙事无窗内新动态（D 教育 #1–13，讯飞 1024 为背景）。
- **重心迁移**：上期重心是「验收与计价」；本期迁到「信任边界」——AI 的输出凭什么被信、谁来兜底，分三条路：工程/工业用确定性验证器当裁判；商业/金融用准入、权限、评测、熔断与硬预算；政府/公共部门把后果写进程序（就业风险评估、场景预算与采购方式、FDE 团队库、部署方责任），并用计量方式管支出。采购核心条款从「模型能力与单价」转向「验证器归属、拦截证据、兜底责任与计量方式」。

## 8 覆盖与局限

**一级行业 4/4 覆盖，政策专项单列。** 固定对象计数（各组 coverage.md）：

| 一级行业 | 组 | 固定对象（行） | 有料 | 静默 | 边界/线索 | 未取得 | 名单外纳入 |
|---|---|---|---|---|---|---|---|
| 工业制造 | A1 + A2 | 46（24 + 22） | 19（去重 18） | 27 | 0 | 0 | 11（7 + 4） |
| 创意与内容 | B | 27 | 17 | 10 | 0 | 0 | 5 |
| 商业与公共服务 | C | 37 | 20 | 10 | 5 | 2（Klarna、滴滴） | 2 |
| 教育科研 | D（教育 13 + 科研 10） | 23 | 11 | 10 | 2 | 0 | 4 |
| 政策专项 | D（政策 15） | 15 | 6 | 9 | 0 | 2 子项（云南 OPC、TC28） | 4 |
| 合计 | — | 148 | 73（去重 72） | 66 | 7 | 4 | 26 |

注：D 组 38 行合计有料 17、静默/无动态 19、边界/线索 2；名单外纳入 8（教育 2：Bloomington、Oxford×DfE；科研 2：Xaira、ScienceOra；政策 4：纽约、新加坡、江苏 FDE、南京条例）。另：主线专题新读名单外来源 13 篇（ChipAgents、AIPhysics.org、南网云睿、无锡供电等）。已读原文约：A1 55、A2 ~32、B 82（全文 ~50）、C 39、D ~40、topic 21（新 13 + 重读 8）。

**未取得及已试入口**：
1. 遂宁银行 AI 大模型平台中标详情（中标方/金额/场景）——已试：scbid 移动页（需会员登录）、WebFetch/curl；仅取得标题与日期 10-29。
2. Klarna——klarna.com/international/press（403）、WebSearch（仅 LinkedIn 帖与聚合站）。
3. 滴滴一手公告——WebSearch 中文、dpshk.com 转载（SEO 软文，D，不采信）。
4. 云南 AI「一人公司」措施——wenzhourcw 转载（502）、搜索；发布日期未核。
5. TC28——搜索「TC28 人工智能 2026年10月」无窗内条目、工信部 AI 标委会 WG10（10-04 窗外）。
6. 部分原文未读：南京条例全文（据交汇点转述）、南岸十条措施原文、贵州行动方案原文、江苏 FDE 附表 3（docx）、IDC MarketScape 原文、Meta 工程博客全文、UMG 财报原文、《读佳》Motus 原稿、Foundry Robotics BusinessWire 稿（超时）、Luma 原始页（403）、Vertical Slice 原稿。
7. SAG-AFTRA 动画协议表决结果在窗外（10-30 08:00 上海）。

**局限**：
- 几乎所有效果数字来自厂商、客户或主管单位自述（B），缺投入侧、基线与第三方复核；没有一家披露验证器拦截率。
- 智能工厂先进级存量口径：新华社 10-26 报道「截至 9 月底 1.3 万余家先进级」与国新办上半年发布会「9000 余家先进级」时点不同，本稿并列保留、不相加。
- 华大 Custom.aix 周期两处报道不一致，以华大署名稿「7 天以内」为准（D）。
- Dassault ArisGlobal 实际交割在 9 月下半月，10-28 为宣布日。
- HSBC「写操作沿原渠道」、Honeywell「不闭环写 DCS」为保守解读，原文未直接写明。
- Mastercard「虚拟卡只是过渡」为 PYMNTS 引述（B）；浏览器取得的转录原话只覆盖 Agent Pay、令牌化、OpenAI 合作与「early days」表述。
- 微软与中国办公 Agent 不在 C 组固定名单，本期未覆盖；人形机器人与具身相关条目与具身周报去重，仅保留仓储现场视角。
- 名单外搜索中东南亚与欧洲工业现场同类案例未专门检索（topic §7）。

## 9 发现层摘要

- 每组均完成 ≥1 轮宽口径并行多 query 名单外发现（各组 discovery.md）。纳入深写：
  - A1（7）：联想天津质量智能体、LSK iRobot 越南、微链道爱 ACI（软文佐证）、SAP Physical AI、GXO×Agility、京东物流×智元、Foundry Robotics（机制未取得）。
  - A2（4）：Honeywell Forge Plant Cognition（与 A1 重叠）、Circuit Mind、Dream、贵州工业垂类大模型发布。
  - B（5）：RisingJoy、Inevitable、Utopai、猫王权利方诉 Anthropic、Poseidon 诉 Black Forest Labs（IATSE 并入工会条目）。
  - C（2）：遂宁银行中标（详情未取得）、Dayforce×德勤（并入德勤）；另 ServiceNow/Salesforce 具名客户与 HMRC 数据并入既有对象。
  - D（8）：Xaira、Bloomington×Colleague AI、Oxford×DfE、纽约儿童聊天机器人法、新加坡事故报告试点、江苏 FDE 团队库、南京条例、中科闻歌 ScienceOra。
  - 专题（topic §5）：ChipAgents IC-star、NAFEMS×Rescale AIPhysics.org、南网「云睿」（背景）、无锡供电保护校核智能体（弱）、中望 CAx（日期待核）。
- 不纳入的主要理由：窗外（Neuron Industries 上海 10-30 03:53、Schaeffler 太仓 10-20、Tractian、Reservoir 诉讼 10-21、Stripe 10-21、Visa×BILL 10-20、HKMA ART 10-15 等）；未开原文或日期未核（柳州第六批场景清单、陕西 AI+制造申报、连云港路演、东南大学算力中标 73.74 万元等）；信号弱或偏具身。
- 下期线索：Neuron Industries（AI 原生 PLC）、Amazon Q3 Alexa for Shopping、SAG-AFTRA 表决结果、柳州/陕西场景清单、东南大学算力平台中标、Seven.One AI 配音、微软/中国办公 Agent 补入名单。

## 10 来源（主要原文；完整来源见各分片）

**工业制造**
- 华为「元冶」：https://www.huawei.com/en/news/2026/10/nisco-yuanye-steelmodel （10-27）；转载 https://field.10jqka.com.cn/20261027/c681155769.shtml
- Honeywell Forge Plant Cognition：https://www.honeywell.com/us/en/news/press-releases/2026/10/honeywell-technologies-launches-forge-plant-cognition-with-dangote-built-with-ndivia-ai-dell-technologies （10-26）
- Cadence Maestro：https://www.nasdaq.com/press-release/cadence-introduces-maestro-domain-specialized-ai-model-portfolio-revolutionize （10-26）；Q3：https://www.nasdaq.com/press-release/cadence-reports-third-quarter-2026-financial-results-2026-10-26
- 华大九天 .aix：https://www.eet-china.com/news/202610278083.html （10-27）
- ChipAgents：https://chipagents.ai/newsroom/chipagents-ic-star-full-stack-agentic-ai （10-27）
- Circuit Mind：https://www.globenewswire.com/news-release/2026/10/28/3390091/0/en/circuit-mind-announces-25m-in-funding-to-accelerate-the-rise-of-electronic-design-intelligence.html （10-28）
- AIPhysics.org：https://www.nafems.org/about-us/media/news/nafems/nafems-and-rescale-launch-aiphysics-org-an-independent-industry-initiative-to-establish-benchmarks-for-ai-methods-in-cae-simulation/ （10-28）
- 工信部领航级公示：https://www.miit.gov.cn/jgsj/zbys/znzz/art/2026/art_9b66cbd1acce49118fef59e698f40112.html （10-26）
- 美的：https://wanyodata.com/news/n-20261026-02 ；https://stock.10jqka.com.cn/20261029/c681261306.shtml
- 海尔卡奥斯：https://www.news.cn/tech/20261026/4162ede5ce344e30a58e06e7519edac7/c.html
- 富士康：https://www.foxconn.com/en-us/press-center/press-releases/latest-news/2129 （10-26）
- 联想天津：https://www.tj.gov.cn/sy/tjxw/202610/t20261025_7641173.html
- LSK iRobot：https://www.asiae.co.kr/cn/article/2026102708381457986
- SAP Physical AI：https://news.sap.com/2026/10/sap-unveils-physical-ai-extends-autonomous-enterprise-real-world-sap-teched/
- Rockwell：https://www.prnewswire.com/news-releases/rockwell-automation-unveils-record-breaking-innovation-lineup-at-automation-fair-2026-302907266.html
- Schneider/Nscale：https://www.globenewswire.com/news-release/2026/10/27/3388947/0/en/schneider-electric-nscale-and-start-campus-bring-the-nvidia-omniverse-dsx-blueprint-into-a-live-ai-factory-environment.html
- Hitachi Digital：https://www.hitachidigital.com/about/news-room/press-release/hitachi-launches-digital-services-company/
- Dassault：https://www.3ds.com/newsroom/press-releases/dassault-systemes-takes-its-life-sciences-ambition-next-level-unified-ai-platform-connecting-science-medicine-and-patients
- GXO×Agility：https://investors.gxo.com/news-releases/news-release-details/gxo-and-agility-robotics-expand-partnership-accelerate/
- 京东物流×智元：https://finance.sina.com.cn/roll/2026-10-26/doc-iniwqarr5367103.shtml
- 贵州工业大模型：http://www.gz.chinanews.com.cn/szfc/guiyang/2026-10-28/doc-ihfmppat9986378.shtml

**创意与内容**
- WPP Q3：https://www.investegate.co.uk/announcement/rns/wpp--wpp/third-quarter-2026-trading-update/9846880 （10-29）
- Meta GenRecs：https://www.adexchanger.com/ai/meta-has-a-new-ad-ranking-system-built-on-llms-plus-upgrades-to-andromeda-and-gem/ （10-28）
- Runway：https://runway.com/news/company-news/runway-ads ；https://runway.com/news/company-news/introducing-runway-app-studio
- Canva MCP：https://www.canva.dev/blog/developers/canva-mcp-ga/ （10-27）
- 可灵 4.0 API：https://stock.10jqka.com.cn/20261029/c681256095.shtml
- Seedance 2.5 4K：https://www.yicai.com/news/103406482.html ；即梦：https://www.ithome.com/1/017/943.htm
- Pika H3 Flex：https://pika.art/blog/pika-h3-flex
- UMG：https://www.digitalmusicnews.com/2026/10/29/universal-music-earnings-q3-2026/ ；Suno 取证：https://www.billboard.com/pro/suno-vs-universal-sony-music-ai-lawsuit-companies-subpoenas/
- 挪威媒体 v. Meta：https://www.euronews.com/2026/10/27/norwegian-media-sue-meta-over-plans-to-use-their-journalism-for-ai
- 北京备案：https://www.beijing.gov.cn/fuwu/lqfw/gggs/202610/t20261029_4922929.html ；微短剧标识：https://www.dianyingjie.com.cn/2026/1023/408763.shtml
- RisingJoy：https://www.advanced-television.com/2026/10/26/risingjoy-backs-vertical-anime/

**商业与公共服务**
- HSBCnio：https://www.about.hsbc.com.hk/-/media/hong-kong/en/news-and-media/261026-hsbc-launches-new-ai-enabled-solution-to-transform-transaction-banking-en.pdf （10-26）
- Mastercard Q3 电话会：https://www.fool.com/earnings/call-transcripts/2026/10/29/mastercard-ma-q3-2026-earnings-call-transcript/ ；PYMNTS：https://www.pymnts.com/earnings/2026/mastercard-backs-tokenized-card-payments-agentic-commerce/
- Visa：https://www.paymentsdive.com/news/visa-adapts-to-tech-innovations/873045/
- Shopify：https://www.shopify.com/news/fall-26-edition-merchant （10-28）
- Salesforce：https://www.salesforce.com/news/stories/agent-fabric-catch-failures-control-ai-costs/
- ServiceNow：https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-Reports-Third-Quarter-2026-Financial-Results/default.aspx
- SAP TechEd：https://www.prnewswire.com/news-releases/sap-empowers-ai-developers-to-build-what-matters-and-turn-intent-into-autonomous-execution-302920376.html
- Verizon：https://www.fool.com/earnings/call-transcripts/2026/10/26/verizon-vz-q3-2026-earnings-call-transcript/
- 蚂蚁灵光 2.0：https://www.cs.com.cn/ssgs/cj2020/2026/10/27/detail_2026102710047464.html
- LexisNexis：https://www.lexisnexis.com/community/pressroom/b/news/posts/as-lawyers-face-ai-switching-overload-lexis-with-protege-redefines-integrated-verified-legal-work-in-a-single-prompt-box
- Harvey：https://www.harvey.ai/blog/harvey-achieves-fedramp-class-d-certification
- GSA OneGov：https://www.gsa.gov/about-gsa/newsroom/news-releases/gsa-anthropic-reach-onegov-agreement-on-discounted-consumptionbased-pricing-10272026 （10-27）
- 英国：https://www.gov.uk/government/news/chancellor-unveils-britains-ambitious-plan-for-ai ；https://www.civilserviceworld.com/professions/article/new-civil-service-ai-fund-to-reduce-admin-burdens
- 上海青浦：https://www.shanghai.gov.cn/nw15343/20261028/d28fb59038dc49fc993d3b84cd3c2542.html

**教育科研与政策**
- 国办发〔2026〕29 号：https://www.gov.cn/zhengce/zhengceku/202610/content_7084108.htm （10-23）
- 南京条例：https://finance.sina.com.cn/jjxw/2026-10-28/doc-iniwuvct9400874.shtml
- 江苏 FDE 团队库：https://www.ntrjw.cn/news/366
- 贵州教育：http://www.gz.chinanews.com.cn/jjgz/2026-10-28/doc-ihfmppat9986350.shtml
- 重庆南岸：https://finance.sina.com.cn/roll/2026-10-27/doc-iniwrkmc1598107.shtml
- Loudoun County：https://www.lcps.org/o/lcps/article/3217638
- Bloomington ISD 271：https://bloomingtonai.com/news/isd-271-colleague-ai-teacher-pilot
- Oxford×DfE：https://www.education.ox.ac.uk/news/research-project-to-inform-policy-on-the-responsible-use-of-childrens-data-in-ai/
- 英国 AIBL：https://www.gov.uk/government/news/introducing-the-ai-biosecurity-lab （10-24）
- Anthropic AI for Science：https://www.anthropic.com/news/ai-for-science-expands-foundations-research-institutions （10-28）
- DOE Genesis：https://www.energy.gov/undersecretaryforscience/genesis-mission/genesis-mission-national-science-and-technology-challenges
- Xaira：https://www.xaira.com/news/x-automate-brings-physical-and-agentic-ai-to-labs （10-23）
- 纽约州：https://www.governor.ny.gov/news/governor-hochul-signs-nation-leading-legislation-protect-kids-ai-chatbots-and-ensure-baby
- 科罗拉多：https://coag.gov/ai/
- 新加坡：https://www.pmo.gov.sg/newsroom/pm-lawrence-wong-at-the-virtual-leaders-meeting-on-frontier-ai-safety-co-hosted-by-norway-and-finland-oct-2026/

## 审计（简）
- 拟采用写法：TOP 与主体均按「判断 → 1–3 个最强证据 → 改变了什么」；B 级数字紧邻写「据 X 披露/自述」。
- 排除：EA 内部 AI 工具链机制（未取得）、dpshk 滴滴软文（D）、Walmart Agent Gateway（10-21 未读原文）、Foundry Robotics 机制（原稿超时）不进读者稿主张。
- 边界：Amazon Q3、JPM/GS/Uber/美团、讯飞 1024 只作背景，不进 TOP。
- 图 1 数据：charts/data-industry.csv（固定对象有料数：工业制造 18〔去重〕、创意与内容 17、商业与公共服务 20、教育科研 11、政策专项 6），口径见 §3 开头。
