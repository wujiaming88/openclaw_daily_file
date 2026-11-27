# 全球 AI+产业研究周报 · 第 20261127 期（母稿·冻结）

- 运行日：2026-11-27（周五，Asia/Shanghai）
- 观察窗口：**2026-11-20 00:00 → 2026-11-26 24:00**（上周五 00:00 → 本周四 24:00）。全文「本周」仅指该窗口。
- 期号：第 20261127 期；周环比对照第 20261120 期（窗口 2026-11-13~11-19，主线「可验收的放行 / 放行写入，留下验收」）。
- 缺期说明：第 20261106 期未完成，本期不补做、不改窗口、不改期号；涉及该窗口事项一律标「补登/上期未刊，非本周」。
- 读者：行业解决方案负责人 / 产业观察者（主责 R2，协同 R3）。研究「AI 如何落入各行各业」，不以大模型公司本身为研究对象。范围不含大健康一级。
- 范围：工业制造、创意与内容、商业与公共服务、教育科研四个一级行业；地域以中美（含香港）为主，兼顾新马/东南亚/欧洲、中东。

---

## §0 一句话结论

**上周的问题是「放行之后怎么验」；这一周的问题变成了「放行到多小的单位、按什么结算」。**

工业侧，本周（SPS 2026，纽伦堡 11-24~26）最有分量的动作都不是「上线一条 AI 产线」，而是把 AI 装进**单个工位**：西门子在埃尔朗根电子厂做一个会自动拆包的机械臂工位（因为箱型差异太大，固定程序做不了），在奔驰的 E/E 返修线上加一层 add-on，在三一的臂架焊接工位做到「一人两机」。与工位同步落地的是**交付形态**：Eigen 流程工业版是「既有 PCS 7 许可之上的独立订阅」，Universal Robots 把 Inbolt 的视觉引导做成「每个新单元的标配选项」，ABB 把传感与边缘塞进电机本体。

商业侧做的是同一件事，只是单位换成了「一笔」：Walmart 给 agent 发绑定「商户+购物车+金额+会话」的一次性令牌，PayPal 给 agent 发一张排除卖家保护的虚拟卡，美国几家大行则把免责写进客户协议——agent 的交易「视同你本人发起」。创意侧，Canva 把设计能力从「席位」改成「调用」（MCP GA + API 计费）。

一句话：**AI 不再按项目卖，也不再按项目担责；本周各方都在定义那个「单元」——工位、许可、一笔令牌、一次调用。**

据此选定本期主线专题：**按工位交付、按单元结算**。核心案例簇为四个工位（Siemens 拆包 / Mercedes 返修 / 三一焊接 / UR 上料），横向对照三种「单元」形态（Schneider 的功能块、ABB 的电机、Canva 的调用），并在 §7 与上期「可验收的放行」逐条对照。

---

## §0.1 本期 TOP5（母稿锚点，均窗内）

| # | 日期 | 主体 | 事实（摘要） | 机制（一句话） | 证据级 | 一手来源 |
|---|---|---|---|---|---|---|
| 1 | 11-24/25 | Siemens（SPS 2026） | 三个层次同时落地：规划（Autonomous Production Planner，多 agent 排产，先在物理数字孪生验证再释放）、工程（Eigen for Process Industries，PCS 7 v10 起，独立订阅，BASF 试用，许可数 7→10 月增逾三倍、30+ 国）、现场（Erlangen 拆包工位 + Industrial AI Suite 经 Industrial Edge/PROFINET 接 S7 实时推理） | 把 AI 放在「工程环境 + 仿真器 + 标准数据（12 万+ 产品 AAS）」三件自有资产之间，按层卖订阅 | A（发布）/B（70%、20–60%、三倍） | https://www.webwire.com/ViewPressRel.asp?aId=364669 |
| 2 | 11-23 | Mercedes-Benz × Arena Physica（Atlas） | 全球协议，首发美国 Tuscaloosa 工厂（GLE/GLS），E/E 返修初测诊断与返修快 **20–30%**，新老技师两个层级都有效 | 把整车引脚/连接器/线束做成 Metagraph 图（含功能重要度与物理位置），确定性+概率混合推理在图上收缩根因；以 **add-on** 挂进既有返修系统，不换系统 | A（发布事实）/B（20–30%） | https://www.tmcnet.com/usubmit/2026/11/23/10486393.htm |
| 3 | 11-22/24 | Wells Fargo / Chase / Citi（+ Reuters 11-23） | Wells Fargo 客户协议新增 Section 15，**11-24 生效**：「Your use of any AI Agent is AT YOUR OWN RISK」，经授权 agent 的交易视同本人、银行不再额外验证；Chase 要求客户对「agent 的错误理解、非预期或越权行为」负责，Citi 写「视为你授权」 | 「授权即代理」：把 agent 当作客户交出去的密码或副卡，从而把未授权交易争议挡在门外 | A/B（条款引语经媒体摘录，未见银行条款页原文） | https://www.pcworld.com/article/3292942/your-ai-shopping-agent-screws-up-the-bank-says-thats-your-problem.html |
| 4 | 11-23 | Walmart（+ PayPal 11-23/24） | Walmart 上线 Agent Gateway，首发支持 Meta Muse：agent 只能拿到账户内受限角色，拿不到卡号；每笔交易一枚绑定商户+购物车+金额+会话的短期令牌，用后即失效。PayPal 的 Agentic Virtual Card 把该类交易**排除在 Seller Protection 之外**，退款只能退回同一虚拟卡 | 不把凭证交给 agent，而是把 agent 变成一个**受限账户角色**：身份隔离、额度封顶、逐笔授权 | B（Walmart 条款经逐条引述；PayPal 条款经德文财经媒体转述） | https://www.theverge.com/ai-artificial-intelligence/1039874/walmart-agent-gateway-meta-muse-black-friday |
| 5 | 11-24 | Canva | MCP 正式 GA 并取消 waitlist，同时上线 REST API、service account 与 **API billing**；10 月 CLI 命令 **72% 由 agent 输入**，MCP 注册近 50 万、用量环比 +93% | 从「按席位卖软件」改成「按调用卖能力」：终端用户不必有 Canva 账号，由集成方按用量结算 | A（GA 与计费模式）/B（规模与增速为公司口径） | https://cxotoday.com/media-coverage/building-the-design-layer-of-the-internet-opening-canva-to-every-agent-and-developer/ |

选择口径：按「是否改变交付结构、责任边界、计量单位或采购方式」排序，不按声量。第 1、2 条是「交付单位」下沉到工位；第 3、4 条是「授权单位」下沉到单笔；第 5 条是「计价单位」下沉到调用。

---

## §1 发现层摘要

### 1.1 扫面结构与执行说明

| 组 | 范围 | 固定对象 | 有料 | 静默/无动态 | 未取得 | 名单外纳入（深写） |
|---|---|---|---|---|---|---|
| A1 | 工业·现场与产线 | 28 | 17 | 11 | 0 | 3 |
| A2 | 工业·工程工艺与基座 | 27 | 17 | 9 | 1 | 4 |
| B | 创意与内容 | 30 | 23（强 18 / 弱 5） | 7 | 0 | 5 |
| C | 商业与公共服务 | 35 | 22 | 12 | 1 | 5（另 6 条仅记录） |
| D | 教育科研 + 政策 | 46 | 29 | 11 | 6 | 4 |
| 合计 | — | **166** | **108** | **50** | **8** | **21** |

**执行说明**：五组均实际落盘并完成名单外宽口径发现（各组 `discovery.md`）。固定对象合计 166 条含跨组重复主体（Siemens、Schneider 在 A1/A2 各计一次；UAE、工信部在 C/D 各计一次），去重后按一级行业统计见下。**覆盖广度本期显著高于上期（上期 97 个固定对象、17 个有料）**，主因是撞上 SPS 2026（11-24~26）与 bauma CHINA 2026 展期，工业侧集中发布；同时 D 组把学区、政策与教育厂商铺到 48 个对象。**覆盖数不等于行业景气**。

**一级行业有料对象数（去重、含名单外纳入，供 fig1 使用）：工业制造 32｜创意与内容 23｜商业与公共服务 22｜教育科研与政策 27。**

口径＝该行业在窗内至少有一条可核条目的对象数（固定对象 + 名单外纳入，含 C 级弱信号）；同一主体跨组不重复计（Siemens、Schneider 计入工业一次；UAE Agentic AI 战略与工信部智能体进网计入商业一次）。合计 104 个去重对象。

![本周各一级行业「有料」对象数柱状图：工业制造 32、创意与内容 23、商业与公共服务 22、教育科研与政策 29](assets/images/posts/2026-11-27-ai-industry-weekly-fig1.png)

*图 1｜本周各一级行业「有料」对象数（2026-11-20~11-26）。口径：窗内至少 1 条可核条目的对象（固定名单 + 名单外纳入），同一主体不重复计，共 104 个。本图为**覆盖广度**指标，不是行业活跃度指标——本期为 SPS 展会周，工业侧与教育政策侧覆盖对象最多。数据来源：本期 master.md §1.1；原始数据 `charts/data-industry-covered.csv`。*

### 1.2 覆盖表结论（明细见 `shards/*/coverage.md`）

- **工业制造（A1+A2）**：有料 32 个去重对象。核心是 SPS 2026 四家（Siemens、Schneider、ABB、Universal Robots）＋ Mercedes×Atlas ＋ 中国装备三家（三一、徐工、中联）＋ 标准与行业组织（OPC Foundation、ZVEI）＋ 中国工业基座（华为云、华大九天、中控、思谋、格创东智）。Rockwell 工程 AI 窗内静默；FANUC/KUKA/Yaskawa 主场无发布被记录；卡奥斯、创新奇智、蘑菇物联无窗内条目；树根互联/徐工汉云未取得。
- **创意与内容**：有料 23（强 18）。Canva 的 API 计费、TIDAL 的删除、Spotify 的同意池、Disney 的集中化、Netflix 的舆论危机、即梦的「整部剧」对象模型、可灵的财务压力是主线；Getty 的 Chapter 11 是「按张授权」模式的破产样本。YouTube、Omnicom、Udio、阅文、光线静默。
- **商业与公共服务**：有料 22。责任条款（Wells Fargo/Chase/Citi/PayPal）、零售网关（Walmart）、agent 商务的规模分裂（Salesforce 21% vs Bain <1%）、公共部门（UAE 战略、MIIT 进网、MAS KYA）是主线；Visa/Mastercard 只有增量（新参与方、新 MoU），无新规则。
- **教育科研与政策**：有料 29（去重后 27）。韩国考场作弊治理（探测器 8,300→约 20,000 台）、美国学区与 Google 的捆绑反噬（550+ 员工请愿、Fairfax 自研拦截）、欧盟 DFA 第 26 条、湖南省级五年方案、UNESCO 教师报告是主线；中国教育部本级、好未来、学堂在线、哈佛/斯坦福/MIT 未取得。

### 1.3 「未取得」对象与已试入口（≥2）

| 对象 | 已试入口（均失败或无窗内结果） |
|---|---|
| 美国教育部 / GSA / 联邦 AI 采购 | ① `GSA AI procurement federal`／`GSA AI acquisition memo`／`OMB AI policy federal agencies`；② `Department of Education AI guidance 2026`／`education department AI grant guidance K-12` |
| 中国教育部（部级文件） | ① 中文多组 query（教育部 人工智能 教育 2026年11月／新闻发布会／应用指南／试点）；② 直连 www.moe.gov.cn（HTTP 500） |
| 上海市教委 | ① `上海 教委 人工智能 中小学 2026`；② `上海 人工智能 教育 方案` |
| 好未来（学而思） | ① `好未来`；② `好未来 财报 2026`；③ `好未来 九章大模型`；④ `学而思 学习机 大模型`；⑤ `学而思 发布 2026年11月` |
| 学堂在线 | ① `学堂在线`；② `学堂在线 人工智能 课程`；③ `学堂在线 大模型`；④ `学堂在线 平台 升级` |
| 哈佛 / 斯坦福 / MIT AI 教学政策 | ① `Harvard artificial intelligence classroom guidelines`；② `Stanford AI teaching guidelines provost`；③ `MIT AI teaching policy 2026`；④ `Harvard Gazette AI classroom`／`MIT News AI education` |
| 树根互联 / 徐工汉云 | ① `树根互联 AI`／`树根互联 2026`；② `树根科技 bauma CHINA 2026`（网易稿正文被拦）；③ `徐工汉云 工业互联网` |
| Retail TouchPoints（收银台 readiness） | ① 原站（Cloudflare 人机校验）；② r.jina.ai 代理（401） |
| Shopify agentic checkout 官方变更日志 | ① `shopify.dev/changelog/feed`（截至 11-20 无该条）；② changelog 页面与 Help Center（Cloudflare/JS 阻断） |
| 欧盟 DFA 官方提案页与 consultation | ① `digital-strategy.ec.europa.eu/en/policies/digital-fairness-act`（404）；② presscorner 检索（未命中） |

### 1.4 名单外发现（宽口径，深写纳入 21 条，摘其要）

- **工业**：Anthropic Claude for Manufacturing（17 技能 + 4 连接器，不碰设备，11-12 发布、窗内 11-22 详述）；中重科技承认智能体业务「尚未形成收入」；富春染织工艺智能体（30 多种输入 → 参数推荐）；徐工威卡×谋先飞仿真基座；Exotec×Fnac Darty 的「旺季租 25 台机器人」；视比特 W1 人形焊接；XPeng IRON。
- **创意**：TIDAL 禁止 100% AI 音乐并删除 2,700 万首；香港 GREENLIGHT/INDEX.FILM 把版权核验做成 198/998 美元的产品；浙江广电 10 部 AI 综艺；Ubisoft Motherbrain；Beach House Labs。
- **商业**：英国 FCA（银行对外部 agent 负全责、高管担责）；美国财政部/BPI；Microsoft Ignite 的 agent 身份；Sierra 按「解决结果」计价；敦煌、OceanBase、千问 Go!。
- **教育/政策**：韩国考场治理与 2027 年 11.9 万亿韩元 AI 预算；湖南五年方案；新加坡 IMDA–CAICT 框架互认；NYU Tandon 的 AI 使用红黄绿分级（225 名学生投票）；加纳学校 AI 国家框架；欧盟 STEF 500 亿欧元主权科技股权基金。
- **仅记录不深写**：Scout Motors、FutureMain、HUCEEN、Raytron、Smartly、GetHookd 等展会/融资类条目。

### 1.5 窗口纪律记录（易误读项）

| 事项 | 事件日 | 处理 |
|---|---|---|
| Siemens Eigen 全球发布 | 2026-04（汉诺威） | **背景，非本周**；本周只写 PCS 7 版本、仿真验证与订阅形态 |
| Anthropic Claude for Manufacturing 发布 | 2026-11-12 | **本周新披露的历史事项**（11-22 详述） |
| Austin ISD 通过首个 AI 政策 | 2026-11-12 | **本周新披露的历史事项**（11-20 报道） |
| 工信部 34 家智能工厂名单 | 2026-11-19 | **上期已写、非本周**；本期新增的是「卓越级名单公示（11-22/23）」。另：上期称「卓越级」，本期组内原文称「领航级」，**两组称谓不一致**，本报告只沿用「34 家、累计 49 家」的数量口径，名称待核 |
| 谷歌 K-12「默认关闭」政策 | 2026-11-03 | **背景，非本周**；本周只写后果（员工请愿、学区自研拦截） |
| 芝加哥反 Google 抗议 | 2026-11-11 | **背景，非本周**（芝加哥论坛报现场图注日期） |
| 欧盟 DFA 提案本体 | 2026-11-11 | **背景**；本周是公开反馈开启（11-23 起、截止 2027-01-14） |
| AutomationML 并入 OPC Foundation 生效 | 2027-01-01 | **生效日在未来**；本周只是宣布与签署（11-25） |
| 新加坡-中国教育 MOU | 2026-11 底（JCBC） | **尚未签署**，本周是「宣布将签」 |
| Deezer「日上传 9 万首 AI 曲」 | 11-24 二手 | 标 C，仅作量级参考 |
## §2 主线专题：按工位交付、按单元结算

### 2.1 结论（先行）

本周四个工位案例共享同一个结构：**不动整条产线，只替换工位里的「识别 + 判断」，人退到上下料与签核，验收留在工位边界。**

Siemens 自动化业务总裁 Rainer Brehm 在 SPS 的说法是这句话的最好注脚：「**下一次生产力跃迁将来自自动化那些以前无法自动化的任务**」。这句话解释了为什么本周最受关注的三件工业 AI 都不是新产品品类，而是「原本只能靠人的工位」。

### 2.2 四个工位的机制拆解

**① Siemens 埃尔朗根电子厂：拆包工位（首次可自动化）**

- 事实：工厂每天收 80–200 个包裹；箱型与尺寸差异过大，固定机器人程序无法处理，拆包至今主要靠人工。系统用相机实时观察工位，由 **robot foundation models**（为物理任务训练的模型）判断下一步，开箱并取出元件料盘（reel）；模型从**人远程遥操作**中学习；推理跑在**西门子工业 PC + Nvidia 芯片**上；**上线时间未公布**，目前是测试单元。（A/B，包裹数系 TNW 引 All About Industries）
- 机制：传统机器人靠固定轨迹 + 夹具，包装多样性导致「编程不可穷举」；换成「看 → 判 → 生成动作」，把不可穷举的几何问题转成模型泛化问题。训练范式是模仿学习（遥操作示范），不是仿真合成。算力放在产线侧工业 PC，因为节拍与安全不允许回路出车间。
- 为什么是「工位」而不是「产线」：拆包是产线的**入口工位**，它不通，后面全堵；但它又高度非标准，无法用整线改造解决。选它做 AI，等于用最小的产线改动换最大的瓶颈解除。
- 代价：无上线时间、无误检率、无节拍、无人工兜底比例。同厂 4 月还做过一次 8 小时人形机器人试验（背景，非本周）。

**② Mercedes-Benz Tuscaloosa：E/E 返修工位（add-on，不换系统）**

- 事实：11-23 双方签全球协议，首发美国阿拉巴马 Tuscaloosa 工厂用于新 GLE 与 GLS；初测阶段技师诊断与返修速度提升 **20–30%**，新老技师两个层级都有效（公司口径）。Atlas **以 add-on 形式集成进奔驰现有的 E/E 返修辅助系统**，推理方式为**确定性推理 + 概率推理结合**，不是纯 LLM。
- 机制：底层是 **Metagraph**——把整车引脚、连接器、线束做成数字表征，并标注功能重要度与物理位置。诊断时在图上做因果收缩（哪些引脚/连接器可能导致该症状），再用每一次实测数据排除候选集，形成「指向根因 → 随新测量细化 → 记录结果回流知识库」的闭环。确定性部分保证可解释与可复现，概率部分负责排序候选——这是安全相关诊断里唯一可被工程接受的组合。
- 为什么重要：E/E 返修是产线末端最贵的瓶颈（拆装、返工、停线），20–30% 直接对应钱。而 add-on 形态意味着**不改既有系统、不动主线 IT 架构**，采购可以走单点立项。
- 对照：Siemens 的 Eigen 在**工程态**（改设计、改代码），Atlas 在**运行态**（修已经装坏的车）；后者离钱更近，也更容易算出 ROI。
- 缺口：20–30% 为初测口径，无样本量、无误诊率、无人工兜底比例；「全球协议」无金额与排期。

**③ 三一重起宁乡产业园：臂架焊接工位（一人两机）**

- 事实：起重机臂架焊接车间现有 **7 台**智能焊接机器人（树根科技打造）参与实际生产；一名焊工从「看守 1 台 + 手持遥控器调参」变成**同时照看 2 台**，只负责上下料；该线到 2026 年底累计焊接里程预计约 **10 万米**。训练方式是把焊接拆成「识别、计算、执行、判断、反馈」五段，用约 **1 年半**让多名资深焊工试板焊接、自研系统记录手法并打分，形成训练数据；臂架一次探伤合格率明显提高（未给数值）。
- 机制：传统焊接机器人只完成「执行」，识别与计算靠人（示教 + 遥控微调）。这条线把识别与计算交给模型，人退到上下料——**一人两机不是因为机器人变快，而是因为人被从回路里摘出来了**。数据路径同样是「人教机器」（遥操作 + 结果打分 → 监督学习），与 Siemens 拆包机器人同一条方法论。
- 为什么重要：「一人两机」是可核算的人效指标，比「效率提升 X%」更接近采购语言；工程机械多品种小批量、焊接又是质量红线，这条线示范了「先在一个车间 7 台跑通，再复制」的路径。
- 缺口：探伤合格率无具体数字、无节拍、无误检率、复制计划未披露。

**④ Universal Robots × Inbolt：高混合上料工位（许可化）**

- 事实：Inbolt 的 AI 3D 视觉引导**原生跑在 UR Gen 7 机器人上**，不再需要外部 PC 与额外布线；腕部 3D 相机**按 CAD 文件识别零件**，定位后**每个循环都把示教轨迹修正到零件的实际位置**；单一程序可在 **80+ 个零件参考**之间切换，新零件由终端用户团队自行重训；许可名 **Inbolt Standard**，被定位为「每个新单元的标配选项」；**未公布价格**。
- 机制：视觉引导的落地成本大头不在算法，而在集成——外挂工控机、相机与机器人坐标标定、每换一个零件重做夹具与轨迹。Inbolt 把「零件 CAD → 位姿估计 → 轨迹修正」做成模型管线并放进 Gen 7 控制器算力，用 CAD 先验替代「示教 + 夹具定位」这一物理约束；换型从「改夹具 + 重新示教」变成「加一个零件参考」。
- 为什么重要：这是「工位」与「单元」重合得最干净的一例——**同一件事既是交付单位（一个工位），也是计价单位（一台机器人的一个许可选项）**。对集成商，视觉引导从项目工程变成勾选项，收入转向工艺与节拍优化；对甲方，「用户自行重训」意味着模型质量责任部分转移到工厂自己。
- 缺口：识别失败率、反光/光照鲁棒性、每循环位姿估计耗时、人工兜底比例。

### 2.3 支撑层：让「工位」可交付的三件基础设施

1. **实时回路留在车间。** Siemens 的措辞值得逐字读：AI 模型跑在 **Industrial Edge**，通过 **PROFINET** 接到 **SIMATIC S7**——推理不在 PLC 的实时任务里，而在控制器旁的边缘节点，用 PROFINET 做数据面。这样既保住 PLC 的确定性周期，又让 AI 参与机器自动化回路（含 AI 运动控制），并可在本地重训、验证、再部署。UR 把视觉塞进控制器、ABB 把传感与边缘封进电机，是同一约束下的三种解法。
2. **工程语义开始标准化。** 11-25，**AutomationML 宣布于 2027-01-01 并入 OPC Foundation**，把 IEC 62714 系列的工程信息语义与 OPC UA 的运行时信息模型合到一处，官方理由直指「消除工程信息与运营数据的传统割裂」，并明确与生成式/agentic AI 进入工程相关。同期 Siemens 把 **Asset Administration Shell（AAS）** 数据开放给 **12 万+ 硬件产品**。这两件事解决的是同一个问题：agent 要操作工位，得先有一份机器可读的设备与工程描述。
3. **验收与签核留在原位，但终于说清了怎么验。** 上期本报告问过「Eigen 到底怎么验」，本期有了明确回答：新增**仿真验证代码**（simulation-based testing）、排产先在**物理数字孪生**里验证再「release to production」、项目级**对照工程数据与客户标准检查**信号地址与缺失连接；工程师逐项批准后才进生产。同一场专访里 Siemens 也承认边界：**「创建安全配置仍是未来能力」**，回滚机制未披露。

### 2.4 横向对照：三种「单元」形态

| 形态 | 主体 | 单元是什么 | 怎么交付 | 谁承担验收 | 本周可核数字 |
|---|---|---|---|---|---|
| 旁路增强 | Siemens（Edge ↔ S7；Eigen 订阅） | 一个工位 / 一个工程环境 | 控制器旁挂 Edge；Eigen 为既有 PCS 7 许可之上的独立订阅 | 仿真验证 + 工程师逐项批准 | 70%/20% 为预期；20–60% 为选定用例口径；许可数 7→10 月增逾三倍 |
| 换地基 | Schneider（EAE + AWS） | 一个可移植功能块 | 软件定义自动化（IEC 61499 式），高级功能块本地跑，Bedrock/SageMaker 产出的 AI 由 Greengrass 批量下发 | 人 + 既有 OT 流程（本期未披露 agent 级校验） | 900+ 客户站点；时间关键负载留本地 |
| 部件即接口 | ABB（Intelleqt） | 一台电机 | 传感、边缘计算、连接在出厂时封进电机，开放架构、客户保留数据所有权 | 客户既有数字平台 | 共创阶段；2027 年铺开欧日中印；无价格 |
| 整场景 | CiDi（矿山） | 一座矿 | asset-light：CiDi 出技术与车队管理，OEM 造车，客户持资产运营 | 客户运营方 | 近/超 40 座矿（原文两处口径不一）、V2X 35+ 矿近 5,000 台、500+ 单 |

这张表说明「工位」为什么会在本周胜出：旁路增强与部件化都不要求客户换掉既有产线，迁移成本最低；换地基收益更大但要求客户接受新的编程范式；整场景只在封闭、低速、可改造的场景（矿山）成立。

### 2.5 代价、反证与未答

1. **四个工位没有一条披露误检率、节拍影响或人工兜底比例。** 唯一接近的是 TNW 提到的一家外部公司（华沙 Nomagic）自述「需要人工介入的频率减半」——这不是本期窗内可核事实，只作对照。
2. **数字全是卖方口径。** Siemens 的 70%/20%/20–60%/三倍、Mercedes 的 20–30%、三一的人效改善，均无第三方审计；Siemens 自己在专访里把 70% 归为「expects」。
3. **「人负责」既是安全阀也是风险转移。** Eigen 由工程师逐项批准、Mercedes 的结论仍由技师执行、UR 让终端用户自行重训——三处都把最终责任留在工厂，AI 供应商只对「建议」负责。
4. **责任条款正在反向收紧商业侧的「单元」。** 同一周，美国大行把 agent 误操作写成客户自担、PayPal 把卖家保护摘掉——当 AI 的单位从「项目」切到「一笔」时，承担风险的人也从供应商滑到了授权者。这条线在 §3.3 展开。
5. **行业自身的景气度并不支持「大爆发」。** ZVEI 在 SPS 公布：德国自动化行业 2026 年前三季度营收 **+7.8%**、订单 **+10.8%**、产量 **+5.3%**，但主席 Rainer Brehm 明确「还不能说出现了广泛的工业上行」，增长主要来自国际业务与**数据中心/能源基础设施**投资，机械、汽车、化工等传统客户仍显著低于往年水平。工业 AI 的预算，目前更像是「存量提效」而非「新增扩张」。

## §3 分行业发现

### 3.1 工业制造（A1 现场 + A2 工程基座）

**判断：本周工业 AI 的进展全部落在「接口」与「单位」上——不是模型更强，而是产品被改造成 agent 能读、能写、能计价、能被标准描述的样子；而这一切集中发生在 SPS 2026 的四天里。**

- **Siemens 把三层同时铺开。**（详见 §2）规划层是 Autonomous Production Planner（多 agent 排产 → 物理数字孪生验证 → 才释放到生产，公司预期减少 70% 人工计划工作量、成本最多降 20%）；工程层是 Eigen for Process Industries（PCS 7 v10 起，独立订阅，选定用例省 20–60%，BASF 首批试用，全球付费许可 7→10 月增逾三倍、覆盖 30+ 国）；现场层是 Erlangen 拆包工位与 Industrial AI Suite 经 Industrial Edge/PROFINET 接 S7 的实时推理。三层都指向同一个交付物：**工程环境 + 仿真器 + 标准数据（12 万+ 产品 AAS）**，而不是一个模型。
- **上期悬着的验证问题，本周有了答案。** 上期本报告写「Eigen 是否仿真、有哪些规则检查、失败如何回滚、是否覆盖安全相关代码，均未公开」。本期 Siemens 在 SPS 与专访中补上了三项：**AI 辅助 PLC 代码开发含 simulation-based testing**、排产**先在物理数字孪生里验证**、项目级**对照工程数据与客户标准检查信号地址与缺失连接**；工程师逐项批准后才进生产。仍未答的是**回滚机制**，以及 Siemens 自己承认「**创建安全配置仍是未来能力**」。（A/B）
- **标准层发生了十年一遇的合并。** 11-25，**AutomationML 宣布于 2027-01-01 并入 OPC Foundation**：把 IEC 62714 系列的工程信息语义（工具、学科、工作流之间的信息交换）与 OPC UA 的运行时信息模型合到一处，官方目标是「在工程、调试、生产、维护、退役全生命周期保留信息及其含义」，并明确点出与生成式/agentic AI 进入工程生产相关。OPC Foundation 现有 1,010+ 会员组织。**这条比任何一家的 Copilot 都更具长期影响：它决定 agent 读到的设备描述是否只有一种语义。**（A）
- **Schneider 走的是另一条路：开放接口，而不是自动改代码。** 11-22 新版 EcoStruxure Automation Expert 支持 open APIs、VS Code 与 Python，新增 web-native HMI 与「更开放的自动化数据访问」，配 Automate 360（把项目/设备管理、许可、协作、网络安全与 common data space 收进一个底座）、Modicon M380 ePAC、以 EAE 为工程层的新一代 DCS Foxboro SDA；11-25/26 与 AWS 的分工被写清：**高级功能块在车间本地运行，工程师在其中调用 Bedrock/SageMaker 构建的 AI，Greengrass 负责把验证过的应用批量下发，时间关键负载留在本地**。装机口径 900+ 客户站点。（A；900+ 为厂商口径）
- **中国装备三家把「物理 AI」写进公司定位，并开始给回收期。** 三一：无人装载机 SW956E 与无人叉车 CB30 接入大模型支持语音指令，已在**十余个项目**落地、累计约 **3,000 小时**，测算**1–2 年全生命周期成本打平**（副总裁易通口径）；焊接线见 §2。徐工：11-24 发布四台**去掉驾驶舱**的具身装备，首次做土石方全流程无人化集群演示，架构是**云端 X-VLM（看懂现场）+ 车端 X-VLA（规划执行）**；同日其合资公司徐工威卡与谋先飞签约，部署 MotrixSim 1.0 建「工程机械物理 AI 仿真训练基座」，适配华为鲲鹏/昇腾。中联：AI 原生工业互联网平台接入 **180 余万台**设备、覆盖 **170 多个国家**、沉淀 **5PB** 数据，配 RobotOps 与 Zbrain「一脑多型」。（B；均为企业口径）
- **政策侧把「用了多少 AI」写进考核，但本周的增量在「卓越级」公示。** 窗内（11-22/23）工信部等六部门 2026 年度**卓越级**智能工厂名单公示，海信家电平度工厂、上海三菱电梯、中微半导体等入选。上期已写的那批 34 家（累计 49 家）给出的是另一组口径：**AI 场景应用比例超 70%、工业智能体超 1,000 个、日均 Token 调用超 3 亿**——属**上期已写、非本周**。需注意：上期本报告称其为「卓越级」，本期组内原文称「领航级」，**两组称谓不一致**，本报告只沿用「34 家、累计 49 家」的数量口径，名称待核。（A/B，部委口径）
- **行业景气不支持「大爆发」叙事。** ZVEI 11-24 在 SPS 公布：德国自动化行业 2026 年前三季度营收 **+7.8%**、订单 **+10.8%**、产量 **+5.3%**，但增长主要来自国际业务与**数据中心/能源基础设施**，机械、汽车、化工等传统客户仍明显低于往年；主席 Brehm 明言「还不能说出现了广泛的工业上行」。另一侧，中重科技在投资者问答中承认工业 AI 智能体业务**尚未形成收入**，Gartner 预测到 2027 年底**超 40% 的 agentic 项目会被取消**。（A/B）
- **人形机器人在「训练期」，不在「生产期」。** Volvo 根特厂已开始训练 Hexagon 的 AEON（1.65 m 轮式、载重 10 kg），**2027 上半年扩大试点、2027 年中进生产**，是本周唯一带排期的计划；宇树、优必选窗内无新的产线部署披露；BMW 莱比锡试点属背景。Hyundai 工会则在薪资之外要求对机器人投资有话语权——本周唯一具名的组织阻力。（B/C）
- **静默与缺口**：Rockwell 工程 AI 窗内无新增量（官方 newsroom 被 Akamai 拒绝，改用全量检索；仅有 AGILOX 后续与 5 亿欧元债券）；FANUC、KUKA、Yaskawa 三家在 SPS 主场无窗内 AI 发布被记录（不据此判断技术落后）；美的、海尔/卡奥斯、创新奇智、蘑菇物联无窗内条目；**树根互联/徐工汉云本次未取得**（已试 3 个入口）。

### 3.2 创意与内容（B）

**判断：创意业这一周不再争论「要不要 AI」，而是开始按「是不是 100% AI」分类处置——删、滤、同意；同时计价单位分裂成五种，谁定单位谁定规则。**

- **Canva 把设计从「席位」改成「调用」。** 11-24 MCP 正式 GA、取消 waitlist，同时上线 REST API、service account 与 **API billing**：客户产品里的终端用户不必各自有 Canva 账号，由集成方按用量结算。公司口径：MCP 注册近 **50 万**、10 月用量环比 **+93%**、新开发者月增速从 9 月 22% 升至 10 月近 **46%**；10 月 CLI 命令 **72% 由 agent 输入**；自研图像模型 Craft 通过 MCP/API 对外开放。官方还提到重组 MCP 时「合并重叠工具、减少歧义」，让跑在小模型上的 agent 也能选对工具——**工具描述本身成了产品设计**。（A；规模数字为 B）
- **TIDAL 直接把「100% AI」删掉。** 11-24 宣布全面禁止完全由 AI 生成的音乐，**12-09** 删除约 **2,700 万首**（占目录 **6.3%**）；自述过去 90 天新上传中 **43%** 为完全 AI 生成（11-06 单日 60%），AI 标注曲目中 **96%** 过去 90 天零播放，已因冒充艺人删除约 **6.6 万首**。技术线索：**94% 的 AI 曲来自 Suno**（今年已加水印），并引 Google Lyria 的 SynthID；即 TIDAL 主要靠**生成方水印**识别，而非自研分类器——未加水印的开源模型可绕过。（A/B）
- **Deezer 与 Spotify 选了另两条路。** Deezer 做「过滤开关」（12 月上线，日上传约 9 万首 AI 曲为二手口径）；Spotify CFO 11-21 称 AI remix 已与 UMG、Believe、Kobalt 签约但**尚未在任何用户身上测试**，且仍需艺人同意；生成的翻唱/remix 会链回原曲，播放**从既有流媒体版税池分成，不另设制作费**。三种治理强度依次为：删除（TIDAL）、过滤（Deezer）、同意池（Spotify）。（B）
- **诉讼焦点从版权扩到公开权。** 11-20 Eminem 的出版商 Eight Mile Style 在 4,770 万美元索赔基础上补进 **108 个**具体侵权输出（涉及 26 部作品）；11-25 法官驳回 Suno 对**公开权（NIL）集体诉讼**的撤案动议，新增 **16 位**音乐人（含 The Chicks、Willie Colón）。逐条固定生成物、绕开「模型是否复制」的抽象争论，是这批诉讼的共同打法；而 NIL 比版权更难用集体授权和解。（A/B）
- **影视侧：集中化与合法性同时推进。** Disney 把 AI 收归**首任 CTO** 统一管理，经理层背**年度 20% 成本节省**目标、目标 FY2029 实现 **30 亿美元**年度 run-rate 节省；近**一半**新广告 campaign 已走 agentic 工具；研究院 + ILM 自研渲染工具把算力需求削减**近三分之一**；合作侧是 Adobe 用迪士尼自有 IP 训 Firefly、Google 共研行程 agent、巴黎 Animaj 的《Ozzy Fox》12-05 上 Disney+。代价是组织摩擦：TheWrap 称前技术赋能办公室烧掉数千万美元后遭创意团队抵制、负责人离职，公司否认「以裁员强迫采用」。（B）
- **Netflix 撞上「看得见的 AI」。** Fincher 新片被影评人指在关键场景使用生成式 AI，片尾字幕列有 **generative supervisor**；影片 RT 84%，但出现抵制声浪。Netflix 今年以 **6 亿美元**收购 Ben Affleck 的 InterPositive（定位「ethical AI」）。**合规叙事没能抵消观感**——这可能是影视 AI 最重要的一条负面证据。（B）
- **中国平台把「一部剧」当成管理单元。** 即梦（字节）11-22/24 的机制被拆开：以**整部短剧项目**为对象，上传剧本后自动解析全剧资产（人物、场景、道具、音色、服装）并统一入库，资产全局复用，**一处修改、全部分镜与镜头同步更新**；先生成低画质样片确认、再出高画质成片，把算力花在已确认的镜头上。芒果 TV 反其道：**先 AIGC 样片、后真人实拍**，用样片指导实拍再融合——真人短剧成本百万级，AI 短剧压到 **20 万元内**。可灵（快手）则是财务侧的反面：Q3 营收 315.92 亿元、同比 -11.1%，期内亏损 9.59 亿元，研发开支 51.78 亿元（+41.9%，主要投可灵），商业化负责人 11-17 离职（距接手约 4 个月）。（B）
- **长片的现金流仍在院线之外。** 《三星堆：未来往事》上映一月累计 **187.8 万元**、当日 54 场、仅 4 城有票，下一部 AI 长片已开机；90 分钟全 AIGC 的《奇妙连接》11-23 走深圳卫视、湖南卫视与芒果 TV，而非院线。**渠道决定成败**：院线要求 100 分钟内角色与叙事连贯、经得起大银幕，AI 长片目前做不到；卫视/OTT 可按电视电影结算。（B/C）
- **计价单位的分裂已经可见**：按 API 调用（Canva）、按生成次数与成本预估（EloElo 在生成前显示成本）、按集/条（抖音 AI 综艺单期 3,000–5,000 元）、按项目与服务收入（博纳的 AI 影视剧业务）、按版权核验费 + 佣金（香港 GREENLIGHT 的 INDEX.FILM：198/998 美元 + 10–20% 抽成）。**广告侧则相反——计量单位仍是「消耗」不是「素材」**：微博称 AI 广告素材消耗占比稳定在 50%，快手称全自动投放工具在客户与消耗两端渗透率均 >90%、AIGC 素材日均消耗同比 +20%。（B/A）
- **静默**：YouTube、Omnicom、Udio、阅文、光线传媒窗内无 AI 相关一手条目；DistroKid 交文件发生在 11-16~18（背景，非本周）。

### 3.3 商业与公共服务（C）

**判断：本周是「条款周」不是「产品周」。责任分配第一次从讨论变成文本，四种范式同时出现；而 agent 成交的真实规模远小于声量。**

- **美国大行把「授权即代理」写进客户协议。** Wells Fargo 在 Online Access Agreement 新增 **Section 15**，**11-24 起生效**：原文措辞「Your use of any AI Agent is AT YOUR OWN RISK」，经授权 agent 发起的任何交易**视同客户本人发起**，银行不再做额外验证；客户须自行监控 agent、自行及时撤销并**保留已撤销的书面证据**。Chase 要求客户对「agent 对你指令的错误理解或执行、以及它实施的非预期或越权行为」负责，并要求 agent 声明自己是 agent；BofA 禁止共享 user ID/密码；Citi 写「视为你授权」；PNC 已加警示，Capital One 计划 2027 年初更新。反向信号只有一个：Amex 称在研究对部分 agent 误操作提供**有限赔付**，尚未成文。（A/B，条款引语经 PCWorld、Crypto Briefing 摘录；未见银行条款页原文）
- **银行对「自建 agent」的管控是另一套。** Reuters 11-23 独家（四名消息人士）：多家大中小型美国银行收紧自建 agent——与敏感系统隔离、限制持续运行时长、**不把密码与日志交给 agent**、收紧可访问数据、纳入身份与权限管理、限制凭证与授权活动范围、测试环境与生产系统隔离、提升有害行为检测与中止能力、并制定 agent 被关停后的业务连续性预案。**kill switch 的触发权在银行内部（运维/风控），不在客户、也不在模型厂商**；截至 11 月，银行正把 kill switch 嵌入放贷与合规相关的 AI 运营。业内定性（前 OCC 官员 Naresh Rajagopalan）：agent「在上线后可能表现出测试与验证阶段未发现的行为」。（B）
- **Walmart 用「受限账户角色」放行 agent。** 11-23 上线 Agent Gateway，首发支持 Meta Muse、经自家助手 Sparky 完成发现与结账。机制：首次加购在 Walmart 账户内建 **Agent Profile**，隔离 agent 活动、设消费上限、审批购买、查看购买历史；**只有消费者本人**能指定 agent 用哪张已存卡，外部 agent 不能新增卡片、不能改支付偏好、**拿不到原始卡号**；每笔交易一枚**绑定商户+购物车+金额+会话**的短期授权令牌，用后即失效，下一笔须重新授权；删除 Agent Profile 即撤销购买权。（B，条款经逐条引述）
- **PayPal 把 agent 交易「降级」成卡交易。** 其 Agentic Virtual Card 向 agentic commerce 服务发一张虚拟卡号用于结算：只能用于 PayPal 结算、退款必须退回同一虚拟卡号、网络费与 interchange 等全部成本按商户与收单合同由**商户**承担、该类交易**明确排除在 Seller Protection 之外**，争议走卡组织标准 chargeback。结果是风险被推回卡组织与商户，PayPal 只做结算通道。（B，条款经德文财经媒体逐条转述）
- **规模真相分裂。** Salesforce 预测 Cyber Week（11/24–11/30）全球线上销售 3,570 亿美元、**AI/agent 影响 758 亿美元（21%）**、20% 假日流量「非人类」、AI 引荐流量转化率约普通流量 2 倍；但 Bain 基于 Similarweb 的分析称 AI 助手占零售商网站流量**不到 1%**，Uber 10 月最后一周约 **3.2 亿笔**交易中仅约 **500 笔**来自 agent，Zappi 调查仅 1% 受访者主动提到用 AI 购物。Visa 的测试则显示 **42%** 的测试轮次未能推荐满足需求的产品，其中过半仍推荐了不匹配产品。**钱在「被 AI 推荐」，不在「被 AI 结账」。**（B）
- **Amazon 的反向封禁暴露了真战场。** Amazon 自 9 月起封禁 Meta Muse 在其主站购物（同期也封了 Perplexity 的 agent），理由是 Meta 未提前告知、agent 浏览时未表明身份；11-25 Fortune 报道双方已在谈解除，焦点是 **Muse 会推荐哪些商品**、对站内广告收入的冲击、搜索质量。**agent 商务的第一场平台战争不是支付战争，是注意力与广告库存的战争。**（B/C）
- **公共部门：战略与采购抓手同时出现。** 11-25 UAE 内阁批准官方所称「全球首个政府 agentic AI 战略」：目标 **50%** 政府运行/服务/流程转向 agentic、培训 **8 万**联邦雇员、**至少 90%** 模型与系统部署在政府基础设施内；政府礼宾 agent **Mira 于 2027-03 开放、2027 年底前全部政府服务上线**，所有联邦实体按内阁时间表接入；配套建 **FedAI** 底座与 **National AI Gateway** 单一入口、国家零信任政策，并在联邦财务政策中**新增「AI 采购」专章**。中国侧，工信部《关于加强智能体终端设备进网管理的通知》要求进网时做智能体适配验证与风险评估、终端上的智能体参考国家标准配**唯一身份码**，并按「实际控制能力」把责任分给开发者、终端生产企业与应用分发平台（**原文与发文日期本次未取得**，仅经媒体报道与专家解读）。（A/B + B/C）
- **agent 身份的四种体系并行**：Entra Agent ID、中国 MIIT 唯一身份码、新加坡 MAS 的 **know-your-agent（KYA）** 协议（要传递 agent 是谁、代表谁、获什么授权、在什么 mandate 下运行）、Walmart 的 Agent Profile。MAS 同时把 SGD Testnet 改造为 SG Digital Ledger，并设 Agentic Money Sandbox；上位框架 SAFR 的四条原则是「有界自主、身份与权限确立、mandate 写明允许动作与限额、控制强度随裁量权上升」。**2027 年前这四种不会收敛。**（B）
- **静默与缺口**：中国政务（北京/上海）窗内无原文；欧盟 AI Act 窗内无新文件；美国 GSA/联邦采购连续三期未取得。


### 3.4 教育科研与政策（D）

**判断：学区这一周不再等供应商「拆 SKU」，而是自己动手拆——用浏览器扩展把 AI 从搜索结果里挡掉；同一周，欧盟第一次把「agent 替消费者下单」写成条款，中国则把「AI+教育」的施工图下沉到省。**

**（一）美国学区：从「要求拆分」到「自己拆分」**

- **550+ Google 员工联名。** 11-20 起，代表 1,000 余名员工的 Alphabet Workers Union 组织联名，**550 余名 Google 员工**签署，要求撤回「学校关闭 Gemini 就失去 Search」的政策，收件人为 Pichai、教育副总裁 Chris Phillips 与搜索负责人 Elizabeth Reid。请愿书原话：「切断不愿使用 AI 的学校的 Search 访问，不会说服用户，反而更可能导致他们整体弃用 Google 产品。」公司领导层确认收到信，但**未回应任何具体诉求**；此前一周，家长与教育者在纽约、洛杉矶、芝加哥、波士顿、波特兰、博尔德、达勒姆等城市 Google 办公室外抗议。（B）
- **拆不开是法律立场，不只是产品选择。** Google 今年早些时候在**两起诉讼**中以「AI Overview 与搜索是同一个工具」抗辩并获驳回，因此把两者拆开在法律上同样困难；技术上二者也确实同栈——AI Overview / AI Mode 与搜索结果页同一个入口。（B，NPR 采访）
- **学区开始自研「AI 广告拦截器」。** 北弗吉尼亚 **Fairfax County** 学区已在自己开发并试点一种在校园设备上拦截 AI 的工具（NPR 形容为「类似广告拦截器」的浏览器扩展），以此保住搜索引擎；但 NPR 同时指出，小学区没有人力自建或维护扩展，即便能授权第三方工具也跟不上 IT 需求。**「拆分」由此从采购诉求变成一项技术能力，能力不均等会把学区进一步分层。**（B）
- **三个大学区的具体状态**（均为背景政策的窗内进展）：芝加哥公立学区自 **2025-12-22** 起禁学生使用 ChatGPT/Claude/Gemini 等第三方 AI，只允许经 **SOPPA**（伊利诺伊州学生数据隐私法）合规流程审核的 EdTech；11-23 评论版披露校董会可能快速通过**覆盖全区的三年禁令**，21 名新当选校董中约一半（含候任主席）签署了支持 pledge，评论作者主张应先做家庭征询再表决。纽约对 **2–8 年级**设一年禁令并在全年级禁 companion chatbot，市议会议长致信 Pichai，信中给出该区约 **130 万台 Chromebook**（其中 50 万台配发给学生）的装机量。洛杉矶联合学区在本学年对**所有年级**封锁生成式 AI（约 **37.8 万**学生），11-22 报道其**已关闭 AI Overviews** 并在复核 Google 搜索方案，同期通过按年级设限的**屏幕时间政策**。（B/C）
- **反向案例说明这不是统一方向。** 迈阿密-戴德 2025 年转向，向约 **10 万**高中生提供 Gemini for Education，2026 年 2 月继续合作；Austin ISD 校董会 **11-12** 通过该区首个 AI 政策（给学监最多 18 个月定细则，设 AI 咨询委员会与家长席位）——属**本周新披露的历史事项**，与芝加哥「直接禁令」形成「先立框架」与「先禁令」两条路。（B）
- **课堂现实与禁令有落差。** EdWeek 对 590 名教师的调查（2026 年 8–10 月）显示教师使用 AI 工具的比例**稳定在约 62%** 并进入平台期。禁令管的是学生账号，管不到教师备课。（B）

**（二）欧盟：Digital Fairness Act 第 26 条把「agent 代下单」写成义务**

- DFA 提案本体 **11-11** 发布，**11-23 起进入公开反馈、截止 2027-01-14**（因翻译延长）。形式是以**可直接适用的条例取代**《不公平商业行为指令》，不再需要 27 国转化；适用于交易前/中/后的全部 B2C 商业行为。（B/C）
- **AI agent 专条（第 26 条）三项义务**：①消费者**首次使用时自行选择**「哪些购买需要我批准」（26(2)）；②系统须披露建议背后的**付款或利益冲突**（26(4)(b)），且当推荐方收费或存在利益冲突时，**无论用户此前的设置如何都必须逐笔确认**；③商家不得强迫消费者使用此类工具（26(9)）。**金融服务被排除在本条例的 agent 条款之外**。罚则上限为**全球年营业额的 6%**，生效后 12 个月适用（第 40 条），文本仍待议会与理事会谈判。（A 级条文：D 组直接读取了委员会提案 PDF 第 26 条；罚则与时间表为 B 级）
- **机制**：它不限制 agent，而是把「代理决策」拆成可审计的授权点——首用授权范围、每笔推荐背后的商业动机、反强制使用。落到产品上就是「首用授权配置页 + 佣金/利益冲突披露 + 单笔审批」三件套。**这是本周唯一把 agent 商务的默认体验写进法律的文本**，且与中国 MIIT 的「身份码」、新加坡的「know-your-agent」构成三种不同的抓手：管体验、管准入、管身份。（B）
- 欠证：提案 PDF 已读到第 26 条正文（经 `commission.europa.eu` 法律页进入）；但**公开反馈（consultation）入口未取得**，反馈起止日期为媒体口径（C）。

**（三）中国：施工图下沉到省，部委本级仍未取得**

- 湖南省教育厅、发改委、工信厅、科技厅、数据局**五部门联合印发**《湖南省推进"人工智能＋教育"行动实施方案（2026—2030年）》：**18 项任务**、六大场景（智学、智教、智评、智管、智研、智创）。（B，文件原文未直接读到）
- 三处机制值得记：**算力「审核备案」**——以国家超算长沙中心为汇聚点、省统一调度平台为枢纽、组建高校算力联盟，把分散自建收口为统一共建，等于先建配额与计费再谈应用；**教师侧改制度而非发工具**——AI 应用能力纳入教师培训、资格认证与师范生培养体系，省级教学成果奖新设 AI 类别；**评价侧留人工位**——「智评」探索 AI 辅助命题、评卷与测评，并明确「人机协同审核机制」。（B）
- 教育部本级、北京、上海**本次未取得**（已试入口见 `shards/D/coverage.md`）；广东窗内为活动与经验报道，非政策原文。（C）
- 新加坡与中国：两国将签**第三份教育 MOU**（预计 11 月底第 22 届 JCBC 期间，牵头为新加坡国立大学 AI Centre for Educational Technologies 与华东师大上海智能教育研究院），并把 **AI Verify 测试框架与中国 YD/T 7173-2026 完成互认映射**。**注意时点：本周是「宣布将签」，不得写成已签。**（B）

**（四）其它政策与机构动作**

- **韩国**：2027 年 AI 预算 **11.9 万亿韩元（约 119 亿美元）**，主题为「把 AI 从实验室推向工厂」；教育侧把 AI 作弊从考场纪律升级为**设备管控工程**——11-19 高考当天政府用灾难警报在考场排查违禁设备，当场查出 **54 人**（连同其它手段累计 **111 人**）；11-25 教育部下发《学校评价智能设备作弊防治考场管理指引》；11-26 宣布全国金属探测器从约 **8,300 台**增购到**约 20,000 台**，用于 12 月第 1–2 周的高一高二期末考；长期解是转向简答/论述型评价并联合研发 AI 辅助评分。（B/C）
- **UAE**：教育部与人工智能国务部长办公室 11-26 发布《家长 AI 指南》，并说明自 **2025-26 学年**在公立学校开设的 AI 课程覆盖**七大领域**；内阁 11-25 批准的 Agentic AI 战略见 §3.3。（B）
- **UNESCO**：11-23 在亚的斯亚贝巴发布《Global Report on Teachers》，关键数字为**仅 45%** 有完整数据的国家要求从学前到中学全阶段的持续专业发展；报告把 AI 列为教师需持续更新能力的动因，但不给工具清单，主张把专业发展认定为「权利」并保障工作时间内学习时间。**对采购的含义：一次性 AI 培训在证据上被弱化，口径会转向「带课时保障的持续机制」。**（B）
- **其它机构**：UNU Macau AI Conference 2026（11-26，以人为本的 AI 与教育）；University of Dubai 与 AIJRF 联合 5 所阿拉伯高校发布首个阿拉伯语 agentic AI 治理指南（11-22）；Ball State 获 Lilly Endowment **1,200 万美元** AI 教育资助（11-24）；孟加拉 12-01 起全国各县推免费 AI 培训（11-26）。（B/C）
- **静默与缺口**：美国联邦（教育部/GSA/联邦 AI 采购）**连续多期未取得**；欧盟 AI Act 窗内无新指南或实施条例（仅 11-25 提出 500 亿欧元主权科技股权基金，属产业政策而非监管）；NIST、ISO/IEC、OECD 窗内无新文件；讯飞、好未来、作业帮、有道、学堂在线**本次仍未取得**（各试 ≥2 个中文入口）。
## §4 五要素对比表（母稿必出）

| 行业/场景 | 主体 | 怎么搭（摘要） | 交付对象 | 代价/坑（已披露） | 证据级 |
|---|---|---|---|---|---|
| 工业·拆包工位 | Siemens（Erlangen 电子厂） | 相机实时取景 + robot foundation models 判定动作；遥操作示范学习；推理跑在工业 PC + Nvidia | 自有工厂的入口工位 | 箱型差异大是前提；**无上线时间**、无误检率/节拍/兜底比例 | A/B |
| 工业·返修工位 | Mercedes-Benz × Arena Physica（Atlas） | Metagraph（引脚/连接器/线束图 + 功能重要度 + 物理位置）+ 确定性/概率混合推理；以 add-on 挂进既有 E/E 返修系统 | Tuscaloosa 工厂（新 GLE/GLS） | 20–30% 为**初测**口径；无样本量、无误诊率；全球协议无金额与排期 | A/B |
| 工业·焊接工位 | 三一重起 × 树根科技 | 焊接拆成五段；1.5 年焊工试板数据 + 结果打分；模型接管识别与计算，人退到上下料 | 宁乡臂架车间 7 台 | 探伤合格率无具体数字；无节拍、无复制计划；集团内 SI 结构外部难切入 | B |
| 工业·上料工位 | Universal Robots × Inbolt | 腕部 3D 相机按 CAD 识别零件，每循环修正示教轨迹，算法跑在 Gen 7 控制器；每单元一个许可 | 高混合电子/服务器上料工位 | 无价格；失败率、节拍、兜底比例未披露；用户自行重训＝质量责任部分转移 | A/B |
| 工业·规划层 | Siemens（Autonomous Production Planner） | 多 agent 生成并优化排程 → 物理数字孪生验证 → 才释放到生产 | 计划部门 | 70%/20% 为公司**预期**；无第三方审计 | A/B |
| 工业·工程态 | Siemens（Eigen for Process Industries） | 在 PCS 7 工程环境内读既有 CFC、按 CMT 从清单生成控制模块、对照客户标准校验；工程师逐项批准 | 流程工业工程团队（BASF 首批试用） | 独立订阅**价格未公开**；无回滚机制；安全配置生成仍是「未来能力」 | A/B |
| 工业·开放底座 | Schneider（EAE + AWS） | IEC 61499 式可移植功能块；Bedrock/SageMaker 训练、Greengrass 下发、时间关键负载留本地 | 机器制造商、工厂 | 900+ 站点为厂商口径；**未披露 agent 级校验**；无价格 | A/B |
| 工业·部件 | ABB（Intelleqt 电机） | 传感 + 边缘计算 + 连接在出厂时封进电机；开放架构、客户保留数据所有权 | 存量电机替换 | 共创阶段、2027 才铺开；传感类型/算力/诊断模型未披露；无价格 | A |
| 工业·整场景 | CiDi（希迪智驾，矿山） | asset-light：技术 + 集成 + 车队管理由 CiDi，整车由 OEM，客户持资产运营 | 矿山客户 | 「近 40 座 / 超 40 座」原文口径矛盾；Yura 的安全责任边界未披露 | A/B |
| 工业·标准 | OPC Foundation × AutomationML | IEC 62714 工程信息语义并入 OPC UA，2027-01-01 生效 | 全体工业软件与设备商 | 生效在 2027；映射工作量与改造成本未披露 | A |
| 工业·需求侧 | 工信部（领航级 34 家） | 四级梯度 + 名单 + 指标考核（AI 场景>70%、工业智能体>1,000、日均 Token>3 亿） | 49 家领航级工厂及地方 | 名单与验收细则原文未取得；口径为部委转述 | A/B |
| 创意·设计工具 | Canva | MCP GA + REST API + service account + API billing；自研 Craft 模型对外开放 | 集成方、开发者 | 调用单价未公开；50 万注册/+93% 为公司口径 | A/B |
| 创意·平台治理 | TIDAL | 以「是否 100% AI」为分类键，12-09 删除约 2,700 万首（占目录 6.3%） | 平台曲库 | 主要靠生成方水印识别，未加水印的开源模型可绕过；申诉机制未披露 | A/B |
| 创意·授权池 | Spotify | 封闭曲库 + 双向同意 + 链回原曲；播放从既有流媒体版税池分成 | 权利人、艺人 | 尚未做任何用户测试；单位播放收入被稀释 | B |
| 创意·影视集中化 | Disney | 首任 CTO 统一 AI；自有 IP 训 Firefly；渲染算力 −1/3；近半新广告 campaign 走 agentic 工具 | 制片、营销 | 组织抵制与高管流失（公司部分否认）；20% 降本为经理层指标 | B |
| 创意·中国短剧 | 即梦（字节）/ 芒果 TV | 以「整部剧」为管理对象（资产库 + 引用）；即梦先样片后成片，芒果先 AIGC 样片后实拍 | 短剧团队 | 跨集角色漂移未解；样片与实拍融合质量未披露 | B |
| 商业·银行条款 | Wells Fargo / Chase / Citi | 「授权即代理」：经授权 agent 的交易视同本人，撤销由客户自行完成并留证 | 零售银行客户 | 客户承担全部风险；无机构承诺赔付（Amex 仅「研究中」） | A/B |
| 商业·银行内控 | 多家美国银行（Reuters 11-23） | 削凭证、限运行时长、与敏感系统隔离、身份与权限管理、kill switch + 业务连续性预案 | 银行自建 agent | 无具名公告；kill switch 的触发权限模型未公开 | B |
| 商业·零售网关 | Walmart | Agent Profile（隔离/限额/审批）+ 绑定商户/购物车/金额/会话的一次性令牌；原始卡号不出域 | 消费者账户 | 条款经二手逐条引述；退货与拒付规则未写清 | B |
| 商业·支付凭证 | PayPal | Agentic Virtual Card：虚拟卡号结算、退款回原卡、排除 Seller Protection、成本归商户 | 商户、收单机构 | 商户承担全部成本与拒付风险 | B |
| 商业·公共部门 | UAE 内阁 | FedAI 底座 + National AI Gateway 单一入口 + 强制接入时间表 + 联邦财务政策 AI 采购专章 | 联邦实体 | 目标为官方口径、完成度未验证；Mira 2027-03 才上线 | A |
| 商业·终端准入 | 中国工信部 | 进网适配验证与风险评估 + 智能体唯一身份码 + 按「实际控制能力」分配责任 | 终端厂商、开发者、分发平台 | 原文与发文日期未取得，仅媒体与专家解读 | B/C |
| 教育·检索入口 | 学区 vs Google | 终端侧拦截扩展（Fairfax 自研）、关闭 AI Overview（LAUSD）、一年/三年禁令（NYC/芝加哥） | 学区、校董会 | 小学区无人力自建；教师使用率已 62%，禁令与课堂现实有落差 | B/C |
| 教育·省级施工图 | 湖南五部门 | 算力「审核备案」收口 + AI 纳入教师认证 + 智评「人机协同审核」 | 省平台、高校、中小学 | 文件原文未读到；资金依赖专项债与省级基金 | B |
| 政策·agent 消费 | 欧盟 DFA 第 26 条 | 首次使用时三选一授权 + 推荐方收费/利益冲突时强制逐笔确认 + 反强制使用；罚则上限全球营业额 6% | agent 厂商、零售商 | **金融服务除外**；仍待议会与理事会谈判；公开反馈入口未取得 | A（条文）/B（罚则） |

---

## §5 综合层：四条跨行业判断

1. **单元越细，责任越往外推。** 工业侧把交付切到工位，验收就落在工位边界（工程师批准、技师执行、用户重训）；商业侧把授权切到单笔，成本就落在授权者（Wells Fargo「AT YOUR OWN RISK」、Citi「视为你授权」、PayPal 摘掉卖家保护、Walmart 让消费者自设限额）。**共同点是供应商只对「建议/通道」负责，不对结果负责**。这意味着采购谈判的重心会从「功能清单」转向「失败时的默认归属」。
2. **竞争轴从「模型强弱」移到「语义与凭证」。** 工业侧，本周的实质进展是 Asset Administration Shell 覆盖 12 万+ 产品、AutomationML 于 2027-01-01 并入 OPC UA、AVEVA 走 MCP Server、Schneider 开放 API/VS Code/Python；商业侧，是 Agent Profile、一次性令牌、虚拟卡、KYA、唯一身份码。**谁定义语义（设备怎么描述）与凭证（谁授权了这一笔），谁就定义验收。**
3. **「可关闭」升级为「可分类处置」，但判定权仍在卖方。** TIDAL 删、Deezer 滤、Spotify 只做同意池，三条路都以「是否 100% AI」为分类键；学区要「无 AI 搜索」而 Google 以「同一工具」抗辩。**买方的真实诉求不是开关，而是「谁判定、能否申诉、删了之后钱怎么算」**——这三问本周没有一家给出完整答案。
4. **景气与预算错位，2027 前比的是单位经济而不是规模。** ZVEI 的 +7.8% 增长来自数据中心与能源基础设施而非机械/汽车/化工；agent 成交占零售流量不到 1%（Bain），而 Salesforce 的「21% 影响」是发现与比价；中重科技承认工业 AI 智能体「尚未形成收入」，Gartner 预计 2027 年底超 40% 的 agentic 项目被取消。**在这种预算结构下，「按工位/按调用/按单笔」计价不是潮流，而是让买方能把试点预算转成运营预算的唯一办法。**

---

## §6 证据等级说明与分布

| 等级 | 含义 | 本期典型 |
|---|---|---|
| A | 可核原始事实（官方新闻稿、监管文件、财报、标准组织公告、法院程序） | Siemens SPS 发布与 AAS/AutomationML–OPC UA；Mercedes×Atlas 协议；ZVEI 行业数据；Walmart/PayPal 条款要点；Canva MCP GA；TIDAL 公告；工信部名单；UNESCO 报告 |
| B | 具名披露/厂商自述/媒体转述（须写「据 X 披露」） | Siemens 70%/20%/20–60%/三倍；Mercedes 20–30%；三一回收期与一人两机；银行条款引语；Salesforce 21% 与 Bain <1%；UAE 目标；湖南方案（原文未读到） |
| C | 仅标题层/单一二手/弱信号 | 芝加哥三年禁令 pledge；Toyota/Nikkei；日本 AI 法草案；中国 MIIT 通知（原文未取得）；TIDAL 检测方法分析 |
| D | 欠证/争议/未采用 | 富士康「买人形机器人」类 AI 生成稿件（文末自述由 AI 生成，数据无法核）；未采用进正文 |

分布（按母稿直接引用的条目粗计）：A 约 16 条，B 约 55 条，C 约 18 条，D 0 条（D 级仅记于分片）。凡 B 级数字均已在正文标注来源方；所有「预期/目标」与「已完成」分开写。

---

## §7 本周 vs 上周

（三列素材见 `wow.md`；读者稿用其中 8 行主线表。）核心迁移：上期问「放行之后怎么验」，本期问「放行到多小的单位、按什么结算、出错算谁的」。

| 主线 | 上期（11-13~11-19） | 本期（11-20~11-26） | 走向 |
|---|---|---|---|
| 交付单位 | 工程环境内生成（TIA Portal V21.1 + Eigen），人负责最终部署 | 单工位替换：拆包、返修、焊接、上料；验收留在工位边界 | 从「改环境」到「换工位」 |
| 计价方式 | 「买功能不买版本」；支付会话与 5 分钟令牌 | Eigen 流程工业版为既有许可之上的独立订阅；UR 每台机器人一个许可选项；Canva 按 API 调用计费 | 从「会话」到「单元」 |
| 责任归属 | 学区问「能不能只买检索」；Canva 开关边界由厂商划 | 大行把 agent 误操作写成客户自担；PayPal 摘掉卖家保护；欧盟 DFA 要求逐笔审批与利益冲突披露 | 从「谁能关」到「谁承担」 |
| Agent 商务 | 受理侧扩容（Visa 140+）、AWS x402 预算会话 | 零售商自建网关（Walmart 令牌）、支付机构发虚拟卡、agent 成交 <1% 流量 | 从「受理侧认不认」到「谁发凭证」 |
| 创意授权 | Canva 开关、UMG kill switch、Warner 版税入账 | TIDAL 删除 2,700 万首、Deezer 过滤、Spotify 同意池；Canva 转向按调用计费 | 从「开关」到「分类处置 + 计价分裂」 |
| 教育入口 | 三大学区考虑弃购 Google | 550+ 员工请愿；Fairfax 自研拦截扩展；芝加哥三年禁令待表决 | 从「要求拆」到「自己拆」 |
| 工业标准 | 无（上期检索未见 PLCopen/IEC 新规） | AutomationML 并入 OPC Foundation（2027-01-01）；AAS 覆盖 12 万+ 产品 | 从「无标准」到「语义合并」 |
| 评测与代价 | UNESCO 反驳鲁棒性（−30~35%） | Visa 测试 42% 推荐失败；Nomagic 称人工介入减半（背景）；中重科技称尚未形成收入 | 从「扛不扛压」到「成交可不可靠、赚不赚钱」 |

---

## §8 来源清单（仅列母稿直接引用）

**工业制造**
- Siemens 官方稿（Eigen for Process Industries）｜https://www.webwire.com/ViewPressRel.asp?aId=364669｜2026-11-25
- Siemens 专访（Matthias Loskyll，SPS 2026）｜https://www.computer-automation.de/engineering-en/siemens-sps-industrial-ai-needs-clear-guidelines.htm｜2026-11-24
- Automation World（SPS 组合与 Edge↔S7 机制）｜https://www.automationworld.com/factory/digital-transformation/news/55421630/siemens-expands-automation-portfolio-toward-ai-powered-autonomous-production｜2026-11-25
- The Next Web（Erlangen 拆包机器人 / Brehm 引语）｜https://thenextweb.com/news/siemens-ai-unpacking-robot-production-planner-sps-2026｜2026-11-25
- Unite.AI（Siemens 规划/拆包）｜https://www.unite.ai/siemens-expands-industrial-ai-across-planning-and-robot-unpacking/｜2026-11-25
- Schneider 官方稿（SPS 2026 平台）｜https://finance.yahoo.com/technology/articles/schneider-electric-turns-industrial-intelligence-120000960.html｜2026-11-22
- Schneider × AWS 官方稿｜https://www.tmcnet.com/usubmit/2026/11/25/10487325.htm｜2026-11-25
- ABB Intelleqt 官方稿｜https://www.tmcnet.com/usubmit/2026/11/24/10486557.htm｜2026-11-24
- Universal Robots × Inbolt｜https://www.logisticsmanager.com/3d-ai-vision-powered-robots-ready-for-industrial-applications/｜2026-11-24
- Mercedes-Benz × Arena Physica（Atlas）｜https://www.tmcnet.com/usubmit/2026/11/23/10486393.htm｜2026-11-23
- 三一（bauma CHINA，回收期口径）｜https://finance.sina.com.cn/jjxw/2026-11-25/doc-inizwsex4516600.shtml｜2026-11-25
- 三一宁乡焊接线（一人两机）｜https://www.sohu.com/a/1103958149_362225｜2026-11-20
- 徐工（四台无驾驶舱装备 + 威卡×谋先飞）｜https://js.ifeng.com/c/8yLMRKUHMsZ｜2026-11-25
- 中联重科（物理 AI 生态）｜https://news.qq.com/rain/a/20261125A069IO00｜2026-11-25
- CiDi（bauma CHINA）｜https://www.tmcnet.com/usubmit/2026/11/25/10487214.htm｜2026-11-25
- 京东物流（奥伯豪森仓）｜https://cj.sina.com.cn/articles/view/1644983660/620c756c02001yijc｜2026-11-24
- Volvo × Hexagon（AEON 排期）｜https://thenextweb.com/news/volvo-humanoid-robots-hexagon-aeon-ghent｜2026-11-26
- ZVEI（SPS 2026 行业数据）｜https://www.computer-automation.de/engineering-en/zvei--the-automation-industry-is-growing-again.htm｜2026-11-24
- OPC Foundation × AutomationML｜https://roboticsandautomationnews.com/2026/11/25/automationml-to-join-opc-foundation-to-strengthen-industrial-interoperability/107519/｜2026-11-25
- AVEVA（Marine Design to Build，MCP 路线）｜https://tradearabia.com/News/490129/AVEVA-launches-next-generation-Marine-Design-to-Build-Solution｜2026-11-24
- Autodesk（MaintainX 10-Q）｜https://www.techi.com/autodesk-maintainx-10q-revenue-goodwill-not-material/｜2026-11-26
- 华为云（智能体伙伴开放计划）｜https://news.qq.com/rain/a/20261125A06LW300｜2026-11-25
- 华大九天/新禹思（EDA 与 AI 可控性）｜https://www.sohu.com/a/1105666994_119709｜2026-11-24
- 中控技术（TPT 与 6,000 亿价值空间）｜https://finance.sina.com.cn/roll/2026-11-24/doc-inizvuza0002420.shtml｜2026-11-24
- 思谋科技（14 万+ 工业智能体）｜https://news.qq.com/rain/a/20261126A0ESTB00｜2026-11-26
- 格创东智（章鱼智脑）｜https://www.sohu.com/a/1106267124_123020981｜2026-11-25
- 工信部领航级名单（34 家）｜https://english.news.cn/20261119/bf1cbae731534b8da028566abaf2a987/c.html｜2026-11-19（本周新披露的历史事项）

**创意与内容**
- Canva 官方博客（MCP GA 与计费）｜https://cxotoday.com/media-coverage/building-the-design-layer-of-the-internet-opening-canva-to-every-agent-and-developer/｜2026-11-24
- The Next Web（Canva MCP）｜https://thenextweb.com/news/canva-mcp-ai-agents-developers｜2026-11-24
- TIDAL 禁令｜https://arstechnica.com/ai/2026/11/tidal-will-ban-fully-ai-generated-music-on-december-9/｜2026-11-24
- The Guardian（TIDAL）｜https://www.theguardian.com/music/2026/nov/25/tidal-streaming-service-bans-ai-generated-music｜2026-11-25
- Spotify CFO（remix 与版税池）｜https://allhiphop.com/news/spotify-ai-remixes-no-user-testing-artist-opt-in/｜2026-11-22
- UMG（walled garden / 80% 民调）｜https://www.ad-hoc-news.de/boerse/news/corporate-news/universal-music-group-stock-doubles-down-on-walled-garden-ai-strategy/70546199｜2026-11-20
- Eight Mile Style v. Suno（修订诉状）｜https://www.digitalmusicnews.com/2026/11/20/eight-mile-style-v-suno-amended-suit/｜2026-11-20
- Suno NIL 案（撤案动议被驳）｜https://completemusicupdate.com/judge-declines-to-dismiss-suno-publicity-rights-case-as-sixteen-more-musicians-join-the-legal-batt/｜2026-11-26
- Disney（CTO 集中化与代价）｜https://businesschief.com/news/disney-ceo-josh-damaro-centralises-ai-and-meets-resistance｜2026-11-26
- Netflix（Fincher 片与 generative supervisor）｜https://kotaku.com/critics-arent-happy-with-david-fincher-generative-ai-tarantino-cliff-booth-sequel-2000758811｜2026-11-20
- 即梦（以整部剧为管理单元）｜https://www.thepaper.cn/newsDetail_forward_34402130｜2026-11-24
- 可灵/快手 Q3（研发与亏损）｜https://www.thepaper.cn/newsDetail_forward_34520506｜2026-11-20
- 博纳《三星堆》票房与下一部｜https://news.qq.com/rain/a/20261124A0DAAB00｜2026-11-24
- 香港 GREENLIGHT FAST-TRACK（INDEX.FILM 版权核验定价）｜B-part-03 所引联合新闻稿｜2026-11-26

**商业与公共服务**
- PCWorld（银行 agent 条款）｜https://www.pcworld.com/article/3292942/your-ai-shopping-agent-screws-up-the-bank-says-thats-your-problem.html｜2026-11-23
- Wired（银行反制 agent）｜https://www.wired.com/story/banks-are-cracking-down-on-ai-agents/｜2026-11-22
- Reuters（银行内控，经 SANA 转述）｜https://sana.sy/en/economic/2361319/｜2026-11-23
- The Verge（Walmart Agent Gateway）｜https://www.theverge.com/ai-artificial-intelligence/1039874/walmart-agent-gateway-meta-muse-black-friday｜2026-11-23
- CryptoSlate（Walmart 条款逐条）｜https://cryptoslate.com/walmarts-black-friday-rollout-reveals-how-ai-agents-could-spend-money-without-controlling-your-wallet/｜2026-11-26
- PayPal Agentic Virtual Card（条款转述）｜https://www.ad-hoc-news.de/wissenschaft/paypal-agentic-virtual-card-haendler-tragen-gebuehren-verkaeuferschutz-entfaellt/70547978｜2026-11-24
- The Verge（Amazon × Meta Muse 谈判）｜https://www.theverge.com/tech/1042071/meta-amazon-muse-ai-shopping-discussions｜2026-11-25
- Business Insider（Bain：agent 成交 <1%）｜https://www.businessinsider.com/ai-agents-holiday-shopping-not-yet-trusted-consumers-retailers｜2026-11-22
- SGB Online（Salesforce Cyber Week 预测）｜https://sgbonline.com/salesforce-predicts-record-357-billion-cyber-week-with-ai-influencing-21-percent-of-sales/｜2026-11-26
- NPR/KUNC（Visa 42% 测试与 NRF 59%）｜https://www.kunc.org/npr-news/2026-11-25/what-to-know-before-using-ai-agents-for-black-friday-shopping｜2026-11-25
- Sharjah24/WAM（UAE Agentic AI 战略）｜https://sharjah24.ae/en/Articles/2026/11/25/d62｜2026-11-25
- 中国经济时报（MIIT 智能体终端进网，转载）｜https://cj.sina.com.cn/articles/view/1749604875/6848da0b01901qdak｜2026-11-20
- Unite.AI（MAS KYA）｜https://www.unite.ai/mas-sets-out-know-your-agent-protocol-and-sg-digital-ledger-plans/｜2026-11-20

**教育科研与政策**
- NPR（Google 员工请愿 / Fairfax 自研拦截）｜https://www.npr.org/2026/11/21/nx-s1-6048599/google-employees-protest-ai-in-schools-policy｜2026-11-21
- Mother Jones（请愿书与六城抗议）｜https://www.motherjones.com/politics/2026/11/google-alphabet-union-school-ai-protest-gemini-workers-petition/｜2026-11-20
- Fortune via Yahoo（三大学区与 Miami-Dade）｜https://www.yahoo.com/news/us/articles/google-told-schools-accept-ai-114000908.html｜2026-11-21
- Chicago Tribune（三年禁令评论）｜https://www.chicagotribune.com/2026/11/23/opinion-ai-decision-chicago-schools/｜2026-11-23
- Community Impact（Austin ISD，11-12 通过）｜https://communityimpact.com/central-austin/education/austin-isd-adopts-first-ai-policy-sets-18-month-timeline-for-rules/｜2026-11-20
- BCLP/JD Supra（DFA 逐条解读）｜https://www.jdsupra.com/legalnews/new-eu-digital-fairness-act-proposal-2558635/｜2026-11-23
- Massively Overpowered（DFA 公开反馈期）｜https://massivelyop.com/2026/11/24/the-european-commission-opens-public-feedback-on-the-eus-digital-fairness-act-through-january/｜2026-11-24
- 华声在线（湖南「人工智能+教育」方案）｜https://news.qq.com/rain/a/20261122A00IJ400｜2026-11-22
- Mothership（新中教育 MOU 与框架互认）｜https://mothership.sg/2026/11/singapore-china-mou/｜2026-11-22
- Devdiscourse（UNESCO 全球教师报告）｜https://www.devdiscourse.com/article/education/4011231-from-mentoring-to-ai-unesco-calls-for-training-that-fits-teachers-real-work｜2026-11-24
- Gulf Business/Yahoo（韩国 2027 AI 预算）｜https://finance.yahoo.com/technology/ai/articles/south-korea-plans-11-9-084041323.html｜2026-11-25
- Dubai Eye（UAE 家长 AI 指南）｜https://www.dubaieye1038.com/news/local/uae-launches-guide-to-help-parents-navigate-ai-in-education/｜2026-11-26
- GovTech/EdWeek（教师 AI 使用率 62%）｜https://www.govtech.com/education/k-12/proportion-of-teachers-using-ai-powered-tools-plateaus-around-62｜2026-11-25

---

## §9 覆盖与局限

1. **覆盖方式**：本期五组均实际落盘（A1 28 对象 / A2 27 / B 30 / C 32 / D 待补），固定对象合计 117+，有料率显著高于上期。原因是本期撞上 SPS 2026（11-24~26）与 bauma CHINA 2026 展期，工业侧集中发布；**覆盖数字的高低不能直接当作行业活跃度**。
2. **WebSearch 工具在本环境返回 403**（Access denied），全部检索改用 Bing News RSS（`tools/news.py`/`scan.py`，按窗内日期过滤）加原文 `curl` 直抓（`tools/grab.py`）。这意味着**未被 Bing 索引的公告可能漏检**，静默对象只代表「检索层无窗内条目」。
3. **付费墙与反爬未取得**：Reuters 原站、Bloomberg、Nikkei Asia（Toyota）、Forbes（Sony/Warner 分析）、Law360、Retail TouchPoints（Cloudflare）、Shopify changelog（Cloudflare）、press.siemens.com（只返回导航壳）、UAE WAM 原文、欧盟委员会 DFA 提案页（404）。相关条目或降级为 C，或只写已读部分。
4. **政策原文缺口（重要）**：欧盟 Digital Fairness Act 第 26 条已由 D 组直接读取提案 PDF（A 级），但**公开反馈入口未取得**；中国 MIIT 智能体终端进网通知**原文与发文日期未取得**（仅媒体与专家解读）；湖南省方案仅读到媒体报道；美国教育部/GSA 窗内公告未取得（连续多期）。**上述政策主张均按「据媒体/律所解读」措辞，未当条文引用。**
5. **厂商自述占比高**：Siemens 的 70%/20%/20–60%/三倍、Mercedes 的 20–30%、三一的回收期、ABB 的停机与损失金额、Canva 的 50 万/+93%、UAE 的 50%/90%、湖南的 2030 目标，均无第三方审计；已在正文逐处标注来源方。
6. **数字冲突已并列保留**：CiDi 的「近 40 座矿」与「超 40 座矿」在同一稿中出现，按原文并列；Salesforce 的「AI 影响 21%」与 Bain 的「agent 成交 <1%」口径不同，未相互抵消。
7. **未取得对象**：Retail TouchPoints 收银台稿、树根互联/徐工汉云、Shopify agentic checkout 官方变更日志、讯飞/好未来/作业帮/有道/学堂在线、中国教育部本级与北京/上海、美国 GSA/联邦采购、欧盟 AI Act 窗内文件——均已试 ≥2 入口，明细见各组 `coverage.md`。
8. **本报告不做的事**：不评估模型能力本身；不把「公司预期/目标」写成已完成；不引用无法打开原文的二手解读当条款。
