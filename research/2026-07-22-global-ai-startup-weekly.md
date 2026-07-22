# 全球 AI 创业公司研究周报 · 第 7 期（2026-07-15 ~ 2026-07-21）

> **覆盖区间**：2026-07-15 00:00 → 2026-07-21 23:59（上海时区）的完整一周
> **本期公司数**：18 家（🇺🇸 美国 5 · 🇨🇳 中国 5 · 其他地区 8），主清单均按估值 < $10 亿口径筛选；未披露估值的公司以融资阶段、公开报道与无独角兽披露作为纳入依据，并在正文标注。
> **数据口径**：每家公司均保留产品、融资、创始人、竞争力、赛道五维研究；融资额/估值/创始人背景等关键数据要求来源 URL + 日期，查不到则标注“未披露”。
> **质量门控**：美 5/中 5/其他 8，合计 18；原文抽查 5/5 通过；五维齐全 18/18；关键数据均附来源或标注未披露。

---

## 本周一句话

> 本周早期 AI 资本继续离开“再做一个通用聊天模型”的叙事，集中流向三类更接近真实支付的控制点：企业/医疗/工业里的 **agentic system of action**，具身与物理世界的模型和硬件底座，以及 AI agent 时代新增的身份、安全、边缘运营和主权基础设施。

---

## 🔥 本周 TOP 5 创业公司

### 1. Oak（以色列/美国 · AI-native 身份安全 / IAM for AI agents）

- **一句话**：Oak 是面向 AI agent 时代的 Identity Operating System，用统一实时身份图谱治理 human、machine 与 AI agent identities，替代碎片化 IAM/IGA/identity security 工具栈。
- **本周动态**：2026-07-15，Oak 从 stealth 公开，并宣布获得 $60M seed funding；TechCrunch 同日/本周报道其产品已 generally available 且已部署在 enterprise clients。融资由 Accel、Greylock Partners、CRV 共同领投，Hetz Ventures、AlphaDrive Ventures 和战略天使参与。
- **五维判断**：产品上，Oak 的产品目标是把身份发现、治理、风险决策和修复放到一个持续更新的 control plane 中，而不是由多个季度审计、权限目录、IGA、PAM、NHI 工具拼接。官网称其“born complete”，一个 data model/graph 覆盖 human、machine、AI agent identities，并能连接 on-prem、cloud、SaaS、homegrown applications；PRNewswire 披露其 AI connector framework 能在数小时内构建新 connector，而 legacy systems 可能需要数月。 融资上，公开可查融资为 $60M seed，时间 2026-07-15；co-led by Accel, Greylock Partners, CRV；Hetz Ventures、AlphaDrive Ventures、strategic angel investors 参投；估值未披露。TechCrunch 指出这笔 seed by local standards 很大，且 Oak 在 2025 年底已悄悄筹到该资金、2026-07 产品 GA 时正式公开；The SaaS News 复核 Funding Date: July 15, 2026、Round: Seed、Lead Investor: Accel/Greylock/CRV。 团队上，CEO/联合创始人 Shai Morag 是连续网络安全创业者，在安全领域超过 20 年，曾创办并出售三家公司：Integrity-Project 于 2014 年被 NVIDIA Mellanox 收购，Secdo 于 2018 年被 Palo Alto Networks 收购，Ermetic（cloud identity/security）于 2023 年被 Tenable 以 $265M 收购，随后他在 Tenable 任 CPO。 竞争力上，最强信号是团队和资本：Accel 曾领投 Ermetic Series A，Tenable 收购后 Accel 对 Morag 有“下一个项目继续支持”的站位；Greylock、CRV 共同领投 $60M seed 表明美国顶级基金认为 identity stack 在 AI agent 时代会重构。产品层面，Oak 已 GA 且有企业客户部署，并在隐身期访谈 100+ CISOs and IAM leaders，验证痛点包括工具过多、无法看见 access usage、无法治理 AI agents。 赛道上，AI agents 和 machine identities 的爆发让身份成为新的攻击面：API tokens、service accounts、agent permissions、MCP/tool access 都会让传统以人为中心的 IAM/IGA 模型失效。未来 1-2 年，企业会从静态权限审批转向 continuous identity intelligence：实时身份图谱、权限使用行为、最小权限自动收敛、AI agent 行为治理和 incident response 联动。
- **为何关注**：Oak 是本周最强“全球榜单新秀/顶级基金背书”信号之一，适合关注 AI agent security、non-human identity、企业 IAM 重构。投资风险是 seed 金额巨大、创始人溢价高、估值虽未披露但可能不低；合作上可从 CISO 渠道、AI agent 平台、MCP/tool governance、云安全集成和身份数据图谱互补切入。

### 2. Applied Computing（英国 · 工业/能源 Foundation AI）

- **一句话**：Applied Computing 是一家伦敦 AI 公司，面向油气、炼化、石化等复杂能源运营场景构建“Energy’s foundation model”，用 Orbital 将时间序列、物理/化工模型与语言模型组合成可解释的工业 AI 操作系统。
- **本周动态**：2026-07-15/16，TechCrunch、Tech.eu 与 EU-Startups 报道公司完成 $20M（约 €17.4M）融资，由工程与能源服务巨头 KBR 领投，Databricks Ventures 参投；同时公司宣布在美国休斯敦开设办公室，以贴近北美能源客户。TechCrunch 称该轮为 Series A，并披露公司从 stealth 到“double-digit millions in ARR”不到 18 个月；EU-Startups/Tech.eu 披露资金将用于国际扩张、Orbital 商业部署、AI 研究组织与工程团队扩张，并提及公司将在数周内宣布与一家欧洲油气巨头的首个合作。
- **五维判断**：产品上，核心产品 Orbital 不是通用 LLM，而是面向炼厂、油气与石化装置的多基础模型系统：时间序列模型接入 DCS、historian、LIMS 等传感器与实验数据，预测趋势、异常与漂移；物理模型从手册与文献中抽取质量守恒、能量守恒、反应动力学等约束；语言模型理解 P&ID、SOP、工单与化工术语，向工程师解释原因并推荐操作。与 AspenTech、AVEVA、Cognite、Seeq 等工业软件/数据平台相比，Applied Computing 强调“physics-grounded + explainable + real-time”的组合，以及用 100% 可用运营数据而非传统约 8% 数据做预测和优化。 融资上，2025-05-28，公司宣布 £9M seed，由 Stride.VC 领投、Repeat.vc 参与，官方称为英国 AI 公司较大的种子轮之一；Imperial College 2025-06-02 交叉验证了该轮为 £9M。2026-03-23，KBR 官宣对 Applied Computing 做战略投资并取得董事席位，同时签署多年联合开发协议，金额未披露。 团队上，公司由 Callum Adamson（CEO）和 Dr. Samyakh/Sam Tukra（Chief AI Officer）于 2023 年创立。 竞争力上，护城河来自三层叠加：第一，复杂工业现场非公开运营数据与 KBR 渠道带来的数据/客户飞轮；第二，物理约束与工程语义结合，使系统更适合安全关键、高价值资产，而不是只做聊天式分析；第三，KBR、Wipro、Databricks 与北美客户等伙伴证明了早期 go-to-market。增长信号强：TechCrunch 披露不到 18 个月达到数千万美元 ARR，Orbital 已在公开上市的大型上游、下游炼化与石化企业中使用。 赛道上，工业 AI 正从“数据湖/可视化/预测维护”进入“可解释自治优化”阶段，尤其能源、化工、重工业因能耗、排放、停机成本巨大，ROI 容易量化。未来 1-2 年，赢家可能不是最大通用模型提供商，而是能把现场数据、仿真、约束、工程知识和闭环优化做进工作流的垂直基础模型公司。
- **为何关注**：这是本周 C 组中信号最强的一家：ARR、战略客户/投资方、垂直基础模型叙事与能源巨头落地同时出现，值得优先安排专家访谈与客户验证。早期投资窗口可能已从 seed 进入高质量 A 轮后阶段；若估值仍在合理区间，重点看 KBR 绑定是否限制其多渠道扩张，以及 Orbital 在不同工艺/客户间的可迁移性。

### 3. Bunkerhill Health（美国 · 医疗 AI Agent/医院创新平台）

- **一句话**：Bunkerhill Health 是一家旧金山医疗 AI 公司，构建 Carebricks agentic AI platform，让医院和健康系统把临床、运营、行政场景中的想法快速变成可部署 AI agents。
- **本周动态**：2026-07-16，Bunkerhill Health 官方公告完成 Series B，Khosla Ventures 领投，Sequoia Capital、Felicis、Optum Ventures、Y Combinator 继续参与；公告称本轮使公司包括 Seed 与 Series A 在内的 total funding to date 达到 $55M。Fortune/Thenextweb 等媒体搜索摘要进一步披露 fresh Series B 为 $25M，领投方与总融资 $55M 口径一致；由于官方公告强调累计融资，本报告将“本轮金额”标注为媒体披露 $25M、官方披露累计 $55M。
- **五维判断**：产品上，Carebricks 是面向医院的“system of action”：不是单个诊断模型，而是让健康系统把内部流程/临床想法编排成可运行的 AI agents。官方列举场景包括 cardiology imaging 早期心脏病风险审查、识别需要 follow-up 的患者、prior authorization、registry management、肾脏科分诊、肺结节随访等。 融资上，Bunkerhill 为 YC W19/2019 相关公司，官网与 YC 页面显示其获 Sequoia、Khosla 支持。2026-07-16 官方披露 Series B close，Khosla Ventures 领投，Sequoia、Felicis、Optum Ventures、YC 继续参与；官方披露 total funding to date（含 Seed、Series A、Series B）为 $55M，媒体披露新资金 Series B 为 $25M。 团队上，公司由 Nishith Khandwala 与 David Eng 共同创立。 竞争力上，Bunkerhill 的护城河来自医疗系统客户、临床部署经验、合规能力和 agent 工作流模板。官方披露 UTMB 已有 20+ AI agents live；首月一个 coronary calcium detection agent 识别出 imminent heart attack 风险患者并路由至 cardiology，后续完成 triple bypass；肾脏科 triage agent 将平均专科等待时间减少 50%+；lung nodule agent 让紧急病例处理快 80%，并使 guideline-concordant follow-up 翻倍。 赛道上，美国医疗支出在 2024 年达到 $5.3T（官方公告引用 CMS），但医疗劳动力短缺和流程碎片化使医院难以把新医学知识转成实际患者收益。医疗 AI 第一阶段偏影像/文书/辅助诊断，下一阶段会转向跨流程的 agentic automation：分诊、随访、授权、登记、质控、运营调度。
- **为何关注**：Bunkerhill 是本周美国组里最接近“医疗 AI 基础设施层”的标的，客户质量和效果数据强，且 Khosla/Sequoia/Optum/YC 的组合很有信号价值。投资风险集中在估值未披露、医疗合规与临床责任、以及是否能从少数标杆系统复制到更广医院网络；合作上适合与医院创新部门、影像/随访/授权流程改造项目对接。

### 4. 日冕开物（中国 · 具身智能世界模型）

- **一句话**：面向机器人跨场景泛化的具身智能世界模型公司，核心产品是自研物理世界基础模型 LaMPA 与配套数据/强化学习闭环。
- **本周动态**：36氪/硬氪于2026-07-17 09:52（页面内 publishTime）首发披露，日冕开物（北京日冕机器人有限公司）近期完成连续两轮种子轮融资，合计金额达数亿元人民币，投资方包括鼎峰科创、远图未来、百度风投、沃衍资本、武岳峰科创、万林国际；新一轮融资同步交割中。资金主要用于自研世界模型 LaMPA 的研发迭代、强化学习体系建设、数据闭环和产品交付能力完善。
- **五维判断**：产品上，日冕开物的 LaMPA 不是单一机器人控制算法，而是将环境表征（物体位置、关系、空间结构）、本体表征（关节位置、受力、传感器反馈）和经验表征（可供性、操作先验）统一到物理世界隐空间，再学习因果关系以预测未来状态并生成动作。团队在基础模型架构上采用更适合世界模型训练的 Block Diffusion，目标是在推理效率、数据利用效率和模型可扩展性之间取得平衡；在后训练环节，引入 World Reward Model，用基座世界模型蒸馏出“评价器”，为强化学习提供更稳定反馈，减少新工位因光照、布局、噪声变化而重复采数/重训的成本。 融资上，公开可确认融资为2026年连续两轮种子轮，合计数亿元人民币；36氪披露投资方为鼎峰科创、远图未来、百度风投、沃衍资本、武岳峰科创、万林国际，资金用途为 LaMPA、强化学习、数据闭环与交付能力建设；估值未披露。本报告未发现更早公开融资历史，公司成立时间为2026年3月，仍处种子期，公开资料未显示达到独角兽或10亿美元估值门槛。 团队上，创始团队均为清华自动驾驶背景，具备智驾世界模型与具身强化学习落地经验。 竞争力上，核心壁垒在于自动驾驶世界模型工程经验向具身智能迁移、三重物理表征、World Reward Model 与工业场景数据闭环。短期优势是团队已拿到服务器装配高精度场景，可形成“真实工况数据—训练—部署—反馈”的闭环；风险在于公司成立时间极短，工业交付、数据采集规模、模型泛化能力仍需在更多工厂和更长运行周期中验证，且具身世界模型方向竞争者密集。 赛道上，具身智能正从“本体硬件展示”进入“工位可交付”阶段，世界模型被视为解决机器人跨场景泛化的关键路线之一。未来1-2年，行业会从比拼机器人单点动作，转向比拼数据分布、仿真/真机闭环、奖励模型和低成本部署能力；日冕开物卡位在工业装配这种高价值但复杂度高的场景，若能跑通标准化 Workflow Agent，有机会成为机器人厂商和工厂自动化方案商的模型层供应商。
- **为何关注**：对早期投资而言，日冕开物是“智驾世界模型人才迁移到工业具身”的典型样本，种子期但融资规模和产业投资方质量都释放强信号。合作上宜优先验证其在服务器装配之外的复制能力、部署周期和真机良率，而不是只看模型叙事；主要风险是技术路线尚早、商业化样本少。

### 5. Whale（新加坡 · 企业 AI OS / 物理世界运营智能）

- **一句话**：Whale 把门店、展厅、工厂等线下空间中的摄像头、传感器和语音数据接入 AI Operating System，用 Business World Model（BWM）把真实运营活动转成可审计、可执行的企业智能。
- **本周动态**：2026-07-15（PRNewswire 发布日；DealStreetAsia 2026-07-16 跟进），Whale 宣布完成 $40M Series C3 extension，使 Series C 总额达到 $100M。此轮由 CMB International 旗下 AI/frontier tech 基金与 SMBC Asia Rising Fund 领投，Krungsri Finnovate、Singtel Innov8、Hyundai Motor Group、Charisma Partners 参投；此前 Series C 参与方包括 Bosch Ventures、MTR Lab、MDI Ventures、Gentree Fund、Linear Capital。
- **五维判断**：产品上，Whale 的核心不是单点 AI 工具，而是面向企业运营的 AIOS，入口产品包括 SpaceSight（视频/IoT 空间智能）、Echo（销售与客服对话智能）、Lume（AI 内容分发）、Alivia（工作流自动化与智能代理）、Harbor（知识管理与合规）和 Novus（AI 基础设施与治理）。其关键技术路线是用专有 BWM 解释摄像头、传感器、音频等“物理世界信号”，类似 LLM 处理文本，再把 SpaceSight 与 Echo 的感知层信号流入代理、内容与治理模块形成“感知-认知-执行”闭环。 融资上，2017 年起源于杭州，2022 年将总部设在新加坡；2021 年曾完成 $50M Series B，Temasek 领投，NIO Capital、Linear、Alpha Startups 参投（DealStreetAsia 2026-07-16 回顾）。Series C1 于 2023 年完成，参与方含 Temasek 与 Linear Capital；2025-05 Series C2 引入 Bosch Ventures、MTR Lab、Singtel Innov8、MDI Ventures、Gentree Fund，C1+C2 合计 over $60M（Whale 官网公告 2025-05-20）。 团队上，创始人兼 CEO Jerry Ye 曾任 Meta 数据科学家，DealStreetAsia 称其负责过大规模机器学习基础设施相关工作；Whale 官网还写明其为 California Institute of Technology 毕业生。 竞争力上，最强信号是商业化与部署规模：PRNewswire 称其服务 1,600+ enterprises、45+ countries、600,000+ edge AI nodes；官网 2025 公告披露当时服务 600+ enterprise customers、20+ countries，说明一年内口径增长明显。技术护城河来自七年积累的 BWM、行业私有模型、跨设备边缘节点和企业工作流集成；渠道护城河来自 Singtel、SMBC、Hyundai、Krungsri/MUFG、MTR、Bosch 等战略投资人网络。 赛道上，企业 AI 正从“文本 copilots”走向“运营系统重构”，尤其零售、汽车、F&B、制造、金融服务等物理网点密集行业，痛点是人工巡检成本高、服务质量不稳定、线下数据结构化程度低。未来 1-2 年，VLM、多模态 agent、edge AI 与企业知识库会融合，赢家需要同时有模型能力、硬件/边缘部署能力和行业 workflow know-how。
- **为何关注**：对早期 AI 投资/合作来说，Whale 是“非 LLM、强落地、多模态运营智能”的代表，特别适合寻找 APAC/MENA 零售、汽车、金融网点数字化合作机会。风险是它已到 Series C 且融资额较大，纯早期财务投资窗口可能不便宜；更适合通过行业客户、渠道、区域合资或数据/边缘基础设施合作切入。

---

## 📊 本周创业市场观察

本周 18 家样本呈现出一个很清楚的结构：美国侧重企业 Agent、医疗 Agent、AI 芯片/推理软件和垂直系统记录层；中国交易集中在具身智能、灵巧手、人形机器人 ODM、AI 角色硬件和企业记忆系统；欧洲与以色列更强调工业能源、建筑机器人、TechBio、食品感官智能以及 AI-native 身份安全；新加坡、印度和沙特则把 AI 与线下运营、硬件交互、主权基础设施绑定。

对投资/合作的含义是：AI 创业公司的核心壁垒正在从“模型参数”转向“工作流位置”。能拿到非公开行业数据、嵌入关键系统、证明 ROI、承担合规责任的公司更值得跟踪；只讲模型能力但缺少客户闭环的公司，信号价值明显下降。

---

## 🌍 分地域详情

### 🇺🇸 美国


### Self Inspection（美国 · AI 车辆检测/汽车金融基础设施）
- 一句话定位：Self Inspection 是一家总部位于美国圣迭戈的 AI 车辆检测公司，用智能手机采集车辆照片/数据，输出可审计的车况、损伤识别、维修估价与检测报告，目标成为汽车交易、租赁、金融与再营销场景里的“Vehicle Condition Intelligence / System of Record”。
- 本周动态：2026-07-16，TechCrunch 披露 Sheryl Sandberg 通过 Sandberg Bernthal Venture Partners 领投 Self Inspection 的 $10M 投资；战略投资方包括 U.S. AutoForce 与 Westlake Financial，Costanoa Ventures、Rebellion Ventures、BrightCap Ventures 等参投，DVx Ventures（前 Tesla 总裁 Jon McNeill 相关机构）为既有支持方。公司同期官方新闻页标题为“Self Inspection Raises $10M to Lead Vehicle Condition AI”，日期为 July 16, 2026。TechCrunch 同文披露，公司已完成 1M+ 车辆检测，客户覆盖 rental fleets、automotive finance companies、auctions、marketplaces，并被 Stellantis 的金融服务部门用于企业自有车辆和租约结束检测；平台已帮助客户节省 $80M+ 成本与 300K+ 运营小时。来源：[来源](https://techcrunch.com/2026/07/16/sheryl-sandberg-leads-10-million-investment-in-ai-powered-vehicle-inspection-service/) （2026-07-16）；[来源](https://www.selfinspection.com/press-releases/self-inspection-raises-10-million-vehicle-condition-intelligence) （2026-07-16）。
- 产品深研：Self Inspection 的核心产品是手机端自助车辆检测工作流：客户向车主/司机发送链接，用户无需安装独立 App，只需按引导拍摄车辆，系统校验覆盖完整性并上传照片。AI 模型将照片与“one of the largest datasets of damaged vehicles”比对，识别损伤位置、类型和严重程度，再生成维修成本估算及详细 PDF 报告；TechCrunch 2025 年报道还提到可结合 OBD2 数据，增强机械层面的判断。差异化在于轻资产、可配置、嵌入客户既有工作流，而不是像 UVeye 一样依赖固定式检测硬件；这使它更适合金融、租赁、拍卖、二手车交易等分布式场景。本周官网也展示了 1M+ inspections、300K+ hours saved、$80M+ costs saved，并标注“AI-enabled trusted results in minutes, not days”，与本轮融资后的扩张叙事一致。来源：[来源](https://www.selfinspection.com/) ；[来源](https://techcrunch.com/2025/02/07/self-inspection-raises-3m-for-its-ai-powered-vehicle-inspections/) 。
- 融资记录：2025-02，Self Inspection 完成 $3M seed，Costanoa Ventures 与 DVx Ventures 共同领投，Westlake Financial 参投；当时 TechCrunch 披露客户包括 Avis、CarOffer（CarGurus 旗下数字批发商）和 Westlake Financial。2026-07-16，公司获 $10M 投资，SBVP 领投，U.S. AutoForce、Westlake Financial、Costanoa、Rebellion、BrightCap、DVx 等参与；累计公开融资至少 $13M。估值未披露；未发现独角兽或估值 ≥$1B 披露，按本报告规则纳入主清单。资金用途：TechCrunch 披露将用于构建更多产品、触达更多企业客户并扩展至欧洲。来源：[来源](https://techcrunch.com/2025/02/07/self-inspection-raises-3m-for-its-ai-powered-vehicle-inspections/) （2025-02-07）；[来源](https://techcrunch.com/2026/07/16/sheryl-sandberg-leads-10-million-investment-in-ai-powered-vehicle-inspection-service/) （2026-07-16）。
- 创始人：公司由 Constantine Yaremtso 于 2021 年创立并担任 CEO。TechCrunch 2025/2026 两篇报道均引用其对产品路径的解释：传统车检慢、贵、误差大，而“everyone has a good camera”使智能手机成为更低摩擦的采集入口。第三方报道与公司资料显示，团队具有 Apple、NVIDIA、Tesla、Coinbase 及汽车行业经验；结合 DVx/Tesla 系投资人和 Karim Bousta（前 Tesla 全球服务 VP）等支持，团队在汽车服务流程、AI 视觉和企业落地上具备较强行业贴近度。
- 竞争力：护城河首先来自车辆损伤数据集与报告标准化能力，其次是已嵌入汽车金融、租赁、拍卖和市场平台工作流后的客户数据回流。1M+ 检测量、$80M+ 成本节省、300K+ 运营小时节省是早期规模化证据；Stellantis Financial、Avis/CarOffer/Westlake 等客户则验证了大客户销售能力。风险在于：车损识别与维修估价需跨车型、地区、保险/维修价格体系持续校准；一旦大型汽车金融/保险软件厂商自建或收购类似能力，Self Inspection 需要以数据网络与系统集成深度守住位置。
- 赛道分析：车辆车况数据是二手车、租赁、金融、保险、再营销的底层信用基础，传统流程依赖人工/线下检测，交付慢且争议多。AI 视觉和手机端采集降低了边际成本，使“每次交易都有可信车况记录”更可行。未来 1-2 年，赛道会从单点损伤识别扩展到车辆全生命周期 condition record、融资残值管理、保险理赔自动化和跨市场标准化；Self Inspection 的轻部署路线有机会吃到中小租赁/金融机构与大型 OEM 金融服务的双重需求。
- 关键数据：$10M 投资（TechCrunch，2026-07-16，[来源](https://techcrunch.com/2026/07/16/sheryl-sandberg-leads-10-million-investment-in-ai-powered-vehicle-inspection-service/)）；$3M seed（TechCrunch，2025-02-07，[来源](https://techcrunch.com/2025/02/07/self-inspection-raises-3m-for-its-ai-powered-vehicle-inspections/)）；1M+ inspections、$80M+ costs saved、300K+ operational hours saved（TechCrunch 与官网，2026-07-16/2026-07-22 访问，[来源](https://www.selfinspection.com/)）；2021 founded（TechCrunch，2025-02-07）。
- 原文链接：[来源](https://techcrunch.com/2026/07/16/sheryl-sandberg-leads-10-million-investment-in-ai-powered-vehicle-inspection-service/) ；[来源](https://www.selfinspection.com/press-releases/self-inspection-raises-10-million-vehicle-condition-intelligence) ；[来源](https://www.selfinspection.com/) ；[来源](https://techcrunch.com/2025/02/07/self-inspection-raises-3m-for-its-ai-powered-vehicle-inspections/) 。
- 投资/合作视角：这是一个“AI 替换高摩擦线下流程”的清晰案例，资金体量不大但客户 ROI 数据强，适合关注汽车金融、二手车交易和保险理赔基础设施的合作。主要风险是估值未披露、收入规模未披露，以及损伤估价在不同市场的合规/责任边界；若能验证企业续约和单位经济，可作为垂直 AI system-of-record 标的继续跟踪。


---


### DeweyLearn（美国 · 多模态 AI 教育评估/技能测评）
- 一句话定位：DeweyLearn 是一家纽约 AI EdTech 公司，用音频、视频和学习数据理解真实学习过程，把专家级观察与反馈规模化到临床/医疗教育、高等教育、职业培训和 K-12 场景。
- 本周动态：2026-07-16，DeweyLearn 通过 PR Newswire 官方公告完成 $5M oversubscribed Series A，SJF Ventures 领投，Catalysis Capital、Morningside、Owl Ventures 等参投。公告称其多模态 AI 将 audio、video、learning data 与领域知识、learning science 结合，用于“real-world performance”观察和专家反馈；公司近期还获得 2026 ASU+GSV Cup，从 3,000+ 公司中被选为全球最佳教育科技初创公司。FinSMEs 同日交叉报道其为 NYC-based multimodal AI platform，融资金额与投资方一致。来源：[来源](https://www.prnewswire.com/news-releases/deweylearn-secures-5-million-in-series-a-funding-to-scale-ai-that-assesses-real-world-skill-at-expert-level-302827161.html) （2026-07-16）；[来源](https://www.finsmes.com/2026/07/deweylearn-raises-5m-in-series-a-funding.html) （2026-07-16）。
- 产品深研：DeweyLearn 解决的是“技能不是会背知识，而是能否在真实场景中做出来”的评估难题。官网将流程拆成三步：Understand & define（把机构领域知识、rubrics、standards 结构化成评估框架）、Deliver（面向每个学习者/教师提供一致、准确的表现评估）、Reveal & optimize（持续发现优势、差距和改进机会）。技术上，公司强调“快速构建每个客户的知识图谱”，例如刀工技术、学生厨师成功要素等，同时形成更高层的“how people learn”元知识图谱；这意味着其不是通用视频打分器，而是将多模态感知、客户课程/标准和学习科学耦合。差异化在于进入实际教学现场（厨房、模拟医院、治疗师训练等），把过去只能由专家现场旁观完成的评估变成可规模化、可回溯的数据系统。
- 融资记录：本轮为 $5M Series A，SJF Ventures 领投，Catalysis Capital、Morningside、Owl Ventures 等参投；公告称为 oversubscribed。公开可核实融资历史中，本轮为主要披露轮次；总融资额至少 $5M，估值未披露，未发现独角兽或估值 ≥$1B 披露。资金用途在公告标题与内容中体现为“Scale AI That Assesses Real-World Skill at Expert Level”，即扩展多模态评估平台、服务更多教育/培训场景。来源：PR Newswire 官方公告（2026-07-16）与 FinSMEs 交叉报道（2026-07-16）。
- 创始人：DeweyLearn 由 Luyen Chou 与 Dirk Liebich 创立。Luyen Chou 是长期 EdTech 领导者，曾任 2U Chief Learning Officer、Pearson Chief Product Officer，并创办 The School at Columbia University；这使他理解课程、院校采购、学习结果和教育产品化。Dirk Liebich 是 applied AI、data analytics、predictive analytics 专家，公告中由其解释知识图谱和“world model of learning”路径。创始组合体现了教育行业 know-how 与 AI/数据建模能力互补，是该类垂直多模态产品能否落地的关键。
- 竞争力：护城河来自三层：一是机构专属课程、rubric 与领域知识结构化；二是跨客户/跨领域积累的表现数据和学习模式；三是高信任场景中的客户嵌入。公告给出 Auguste Escoffier School of Culinary Arts 的案例：DeweyLearn 已评分 20,000+ 学生作业，节省数百小时教师评分时间，并让学生获得即时反馈；Riverside Insights 与 NARM 也被列为使用/探索场景。风险在于教育与医疗培训的采购周期长、数据隐私和算法公平性要求高，且“专家级反馈”需要持续证明准确性与可解释性。
- 赛道分析：教育 AI 正从内容生成/作业辅导转向“表现评估”和“技能证明”。在护理、治疗师培训、烹饪、IT/职业技能等场景，雇主和院校更关心能否完成动作、沟通、判断和流程，而多模态 AI 刚好能捕捉文本测验无法覆盖的现场行为。未来 1-2 年，成熟方向会是与 LMS、模拟训练中心、职业认证和企业 L&D 系统集成；DeweyLearn 若能形成跨行业评估标准与可验证学习改进数据，有机会成为“skills assessment infrastructure”。
- 关键数据：$5M Series A（PR Newswire，2026-07-16，[来源](https://www.prnewswire.com/news-releases/deweylearn-secures-5-million-in-series-a-funding-to-scale-ai-that-assesses-real-world-skill-at-expert-level-302827161.html)）；3,000+ ASU+GSV Cup 参赛/候选公司中获 2026 冠军（PR Newswire，2026-07-16）；20,000+ student homework submissions graded、hundreds of instructor grading hours saved（PR Newswire，2026-07-16）；Founded 2023、NYC-based（PitchBook 搜索摘要/FinSMEs，2026-07-16，[来源](https://www.finsmes.com/2026/07/deweylearn-raises-5m-in-series-a-funding.html)）。
- 原文链接：[来源](https://www.prnewswire.com/news-releases/deweylearn-secures-5-million-in-series-a-funding-to-scale-ai-that-assesses-real-world-skill-at-expert-level-302827161.html) ；[来源](https://www.deweylearn.com/) ；[来源](https://www.finsmes.com/2026/07/deweylearn-raises-5m-in-series-a-funding.html) 。
- 投资/合作视角：DeweyLearn 不是“AI 课件生成”泛红海，而是更接近技能评估基础设施，客户愿付费点来自教师时间节省、认证可信度和学习结果改进。投资上需重点验证：评分与反馈的准确性是否能通过专家盲评、是否能跨学科复制、以及院校/医疗培训采购是否足够快；合作上可优先看职业教育、医疗模拟训练和企业技能认证场景。


---


### Infinity（美国 · AI 芯片/推理软件自动化）
- 一句话定位：Infinity 是一家旧金山 AI 基础设施公司，开发自动生成和优化 AI 推理底层代码的软件，让新型半导体架构更快支持主流 AI 模型，降低对少数 GPU 软件生态的依赖。
- 本周动态：2026-07-21，Citybiz 披露 Infinity 完成 $15M seed，post-money valuation 为 $100M；搜索结果中 Las Vegas Sun/其他转载显示新闻在 2026-07-20 已发布，仍落在本周窗口内。该轮投资方包括 Touring Capital、Principal VC、主要芯片公司高管、OpenAI 与 Anthropic 研究人员以及其他天使。披露称资金将用于扩展工程团队、继续开发 automated AI research platform，并加深与芯片制造商（包括 d-Matrix）的商业合作。来源：[来源](https://www.citybiz.co/article/876663/infinity-secures-15m-to-push-ai-software-for-chipmakers/) （2026-07-21）。
- 产品深研：Infinity 的核心产品 Ignition 面向 AI inference software：当新处理器出现时，过去需要工程师手工编写优化库和低层 kernel，周期可能长达数月或数年；Ignition 则自动生成、测试、调优 compute kernels，使 AI 模型能在不同硬件架构上高效运行。其技术路线更像“AI 研究/代码生成代理 + 编译/性能调优 + 硬件适配”组合，目标是把 PyTorch、TensorFlow 等生态对新芯片的支持周期压缩。差异化在于它不直接造芯片，而是抓住 AI 芯片商业化最痛的“软件栈不足”问题；当市场上 Nvidia 之外的推理芯片增加时，Infinity 有机会成为连接模型、框架与新硬件的中间层。Citybiz 还披露公司已通过 chip design collaborations 产生 recurring revenue，说明不是纯研发 demo。
- 融资记录：本轮为 $15M seed，$100M post-money valuation；投资方包括 Touring Capital、Principal VC、芯片公司高管、OpenAI/Anthropic 研究人员与天使。公开可核实融资历史中，本轮为主要披露轮次；总融资额至少 $15M。资金用途包括扩展工程团队、开发自动化研究平台、推进与 d-Matrix 等芯片制造商合作。估值 $100M 明确低于 $1B，符合主清单铁律。来源：[来源](https://www.citybiz.co/article/876663/infinity-secures-15m-to-push-ai-software-for-chipmakers/) （2026-07-21）。
- 创始人：创始人兼 CEO Jeremy Nixon 曾是 Google Brain 工程师/机器学习研究员，后担任大语言模型检索创业公司 Omniscience CEO。Citybiz 引用 Nixon 的观点：AI 行业长期受制于“只有少数芯片能跑好 AI”，原因不是硬件本身，而是 Nvidia 多年构建的软件生态；Ignition 的目标正是消除这一约束。该背景使他对模型、检索、基础设施和自动化研究均有经验，适合切入推理软件栈自动化这一技术密集型问题。
- 竞争力：Infinity 的护城河在于自动化 kernel 生成/调优能力、与芯片厂商的早期合作数据、以及对模型架构变化的持续跟踪。若 Ignition 能让芯片公司少花数月构建软件栈，它的价值直接映射到芯片上市时间、性能利用率和客户采用率。风险也很硬：该领域技术门槛高，客户集中在少数芯片公司，且需与 TVM、Triton、XLA、MLIR、厂商自研 compiler stack 等生态竞争；此外，Nvidia 软件生态仍有强网络效应，替代链条需要持续性能证明。
- 赛道分析：AI 训练与推理算力紧缺推动了 GPU 替代、ASIC、RISC-V/自研加速器等多样化，但硬件多样化的瓶颈往往是软件：没有成熟 kernel、compiler、framework 支持，再好的芯片也难被开发者采用。未来 1-2 年，推理成本优化会成为企业 AI 部署核心议题，新芯片厂商会更愿意购买“软件加速器/自动化适配”能力而不是从零堆团队。Infinity 的卡位是 AI infrastructure 中被低估但关键的“chip enablement layer”，如果能绑定多家芯片公司，战略价值可能高于当前融资体量。
- 关键数据：$15M seed（Citybiz，2026-07-21，[来源](https://www.citybiz.co/article/876663/infinity-secures-15m-to-push-ai-software-for-chipmakers/)）；$100M post-money valuation（Citybiz，2026-07-21）；Founded in 2025（Citybiz，2026-07-21）；Touring Capital inaugural fund $330M、Principal VC inaugural fund $100M（Citybiz，2026-07-21）；合作方包含 d-Matrix（Citybiz，2026-07-21）。
- 原文链接：[来源](https://www.citybiz.co/article/876663/infinity-secures-15m-to-push-ai-software-for-chipmakers/) ；[来源](https://infinity.inc/#home) 。
- 投资/合作视角：Infinity 是典型“卖铲子给 AI 芯片淘金热”的早期基础设施标的，估值 $100M、融资 $15M，若能在多芯片架构上证明性能与适配速度，潜在并购方和战略伙伴都很多。主要风险是技术验证难、销售对象窄、依赖芯片替代 Nvidia 的真实进展；建议后续尽调重点看 benchmark、付费合作合同、d-Matrix 等客户深度和生成代码的可维护性。


---


### Sable（美国 · 企业 AI Agent/客户面对面工作自动化）
- 一句话定位：Sable 是一家旧金山企业 AI Agent 公司，推出名为 Aidan 的“AI employee”，用实时浏览器操作、视觉、语音和视频来完成产品演示、客户问答、资格判断、入门培训等客户互动。
- 本周动态：2026-07-16，Sable 通过 Access Newswire/Morningstar 披露完成 $45M financing round，由 Sequoia Capital 与 8VC 领投，BoxGroup、SV Angel、Valor Atreides AI Fund、Sabrina Hahn、Evan Hahn 参投；Sequoia 的 Shaun Maguire 与 8VC 的 Joe Lonsdale 加入董事会。公司成立不到一年，已在 Notion、Decagon 以及大型上市公司生产环境上线。新闻稿称 Sable “founded by a group of Harvard graduates”，产品 Aidan 可在共享环境中看屏幕、点击、解释并与用户协作。来源：[来源](https://www.morningstar.com/news/accesswire/1191719msn/sable-raises-45m-to-build-the-first-ai-employee-that-can-click-see-and-explain) （2026-07-16）。
- 产品深研：Aidan 的核心不是传统客服聊天机器人，而是客户面对面的实时产品体验代理：它能进行 live product experiences、回答复杂问题、引导买家在产品中完成操作，同时记录 engagement、feedback 和每次互动洞察。技术路线由 Sable 称为 Interactive Intelligence，结合 real-time browser navigation、vision、voice、video；其 LiveBox 是一个虚拟机/共享工作区，让 Aidan 可以演示产品完整能力。公司还构建“Brain”——把销售通话录音、最佳员工访谈、文档和营销材料转成统一的 enterprise customer context graph，并通过交互持续发现知识缺口和成功模式。官网也强调 Aidan 可在数天内部署产品 demo/qualification，无需集成，并可扩展到 onboarding、新功能发布、伙伴认证、用户培训、国际化等用例。
- 融资记录：本轮披露为 $45M 融资，Sequoia Capital 与 8VC 领投，BoxGroup、SV Angel、Valor Atreides AI Fund、Sabrina/Evan Hahn 参投；公开稿未披露估值、历史轮次和累计融资之外的细节。考虑公司成立不到一年且本轮 $45M，未发现独角兽/估值 ≥$1B 披露，按估值未披露但无独角兽证据纳入主清单。资金用途未以单独段落列明，但从新闻稿与官网看，重点是扩展 Aidan、产品研发、客户生产部署和企业级安全/合规能力。来源：Access Newswire/Morningstar（2026-07-16）与官网（访问 2026-07-22）。
- 创始人：Sable 由 Nim Ravid、Leon Chen、Linda He、Itamar Rocha 创立，四人在 Harvard University 相识，并从事 post-training、reinforcement learning、multimodality 方向 AI 研究。新闻稿披露，团队成员在创业前曾任职 SpaceX、Google、Meta、Together AI；更广团队包括 AI researchers、former quantitative traders 和 International Math Olympiad winners。这个背景与产品需要解决的低延迟多模态交互、computer-use agent 准确率、企业知识图谱学习等问题高度匹配。
- 竞争力：Sable 的竞争力在于将前沿模型能力直接嵌入收入相关工作流：客户演示、购买评估、onboarding 和 expansion。Notion、Decagon 与大型上市公司生产使用是强早期 traction；Sequoia/8VC 董事会级别投入也增强招聘与商业化能力。风险在于 customer-facing agent 的容错率低，错误演示或错误承诺会直接影响销售和品牌；此外，OpenAI/Anthropic/Google、CRM 厂商和 sales enablement 平台可能快速推出相似能力。Sable 必须证明 Aidan 不只是酷炫 demo，而能提升转化率、缩短销售周期、减少售前/CS 人力成本。
- 赛道分析：企业 AI Agent 正从后台自动化走向客户一线。过去 1-2 年，浏览器操作、视觉理解、语音对话和多模态 latency 的改善，使“AI 直接与买家共享屏幕完成产品体验”变得可行。这个赛道的成熟度仍早，但潜在预算来自销售工程、售前、客户成功、培训和国际化团队，ROI 计算相对直接。未来趋势会是：AI agent 与 CRM、产品分析、知识库和权限系统深度集成；有行业/产品上下文图谱的公司将比单纯调用大模型的包装层更有防御性。
- 关键数据：$45M financing round（Morningstar/Access Newswire，2026-07-16，[来源](https://www.morningstar.com/news/accesswire/1191719msn/sable-raises-45m-to-build-the-first-ai-employee-that-can-click-see-and-explain)）；成立不到一年（同源，2026-07-16）；生产客户包括 Notion、Decagon、大型上市公司（同源，2026-07-16）；领投 Sequoia Capital 与 8VC，Shaun Maguire/Joe Lonsdale 加入董事会（同源，2026-07-16）。
- 原文链接：[来源](https://www.morningstar.com/news/accesswire/1191719msn/sable-raises-45m-to-build-the-first-ai-employee-that-can-click-see-and-explain) ；[来源](https://www.accessnewswire.com/newsroom/en/computers-technology-and-internet/sable-raises-45m-to-build-the-first-ai-employee-that-can-click-se-1191719) ；[来源](https://withsable.com/) 。
- 投资/合作视角：Sable 是高风险高上限的 agentic sales/customer engagement 标的，若能把“实时产品演示 + 企业知识图谱 + 自动学习”跑通，可能成为新一代售前/CS 操作层。投资风险在于估值未披露、产品仍很新、错误成本高；合作建议从低风险 demo、培训和 onboarding 用例试点，再进入关键销售流程。


---


### Bunkerhill Health（美国 · 医疗 AI Agent/医院创新平台）
- 一句话定位：Bunkerhill Health 是一家旧金山医疗 AI 公司，构建 Carebricks agentic AI platform，让医院和健康系统把临床、运营、行政场景中的想法快速变成可部署 AI agents。
- 本周动态：2026-07-16，Bunkerhill Health 官方公告完成 Series B，Khosla Ventures 领投，Sequoia Capital、Felicis、Optum Ventures、Y Combinator 继续参与；公告称本轮使公司包括 Seed 与 Series A 在内的 total funding to date 达到 $55M。Fortune/Thenextweb 等媒体搜索摘要进一步披露 fresh Series B 为 $25M，领投方与总融资 $55M 口径一致；由于官方公告强调累计融资，本报告将“本轮金额”标注为媒体披露 $25M、官方披露累计 $55M。公告还披露客户包括 Cleveland Clinic、University of Texas Medical Branch (UTMB)、Intermountain Health，并在 UTMB 有 20+ AI agents live。来源：[来源](https://www.bunkerhillhealth.com/resources/series-b-announcement) （2026-07-16）；搜索摘要指向 Fortune 2026-07-16。
- 产品深研：Carebricks 是面向医院的“system of action”：不是单个诊断模型，而是让健康系统把内部流程/临床想法编排成可运行的 AI agents。官方列举场景包括 cardiology imaging 早期心脏病风险审查、识别需要 follow-up 的患者、prior authorization、registry management、肾脏科分诊、肺结节随访等。产品的架构特征在于跨临床、运营、行政数据推理并“take real action”，同时提供健康系统需要的 governance、monitoring、safeguards；官网还披露 SOC 2 Type II、HIPAA compliant、ISO 27001 certified。与单点 AI 算法公司相比，Bunkerhill 的差异化是部署层和工作流层：把医院自己的最佳实践、算法和运营目标转成可管理 agent，而不是让医院采购 100 个点状 AI 产品。
- 融资记录：Bunkerhill 为 YC W19/2019 相关公司，官网与 YC 页面显示其获 Sequoia、Khosla 支持。2026-07-16 官方披露 Series B close，Khosla Ventures 领投，Sequoia、Felicis、Optum Ventures、YC 继续参与；官方披露 total funding to date（含 Seed、Series A、Series B）为 $55M，媒体披露新资金 Series B 为 $25M。估值未披露，未发现独角兽或 ≥$1B 估值报道，按本报告规则纳入。资金用途：扩展 Carebricks 平台，帮助健康系统把更广泛临床与运营想法变成 production-grade AI agents，并推进治理、监控和安全保障。来源：[来源](https://www.bunkerhillhealth.com/resources/series-b-announcement) （2026-07-16）；[来源](https://www.ycombinator.com/companies/bunkerhill-health) 。
- 创始人：公司由 Nishith Khandwala 与 David Eng 共同创立。Nishith 个人主页显示其为 Bunkerhill Health co-founder（YC W19），此前在 Stanford AIMI center 做 researcher，方向是 medical imaging AI algorithms 的 validation and translation into clinical practice；这直接对应医疗 AI 最大难点——不是模型论文，而是临床验证、落地和工作流转化。Forbes 资料（搜索摘要）也显示 David Eng 与 Nishith Khandwala 共同创立 Bunkerhill，早期定位为与 20+ academic medical centers 合作开发/验证可用于患者的 AI algorithms 并作为 distribution network 商业化。
- 竞争力：Bunkerhill 的护城河来自医疗系统客户、临床部署经验、合规能力和 agent 工作流模板。官方披露 UTMB 已有 20+ AI agents live；首月一个 coronary calcium detection agent 识别出 imminent heart attack 风险患者并路由至 cardiology，后续完成 triple bypass；肾脏科 triage agent 将平均专科等待时间减少 50%+；lung nodule agent 让紧急病例处理快 80%，并使 guideline-concordant follow-up 翻倍。这些数据展示了从 AI insight 到 clinical action 的闭环。风险包括医疗责任、EHR 集成复杂度、医院采购周期、算法偏差与监管审计要求；一旦扩展过快，安全治理可能成为瓶颈。
- 赛道分析：美国医疗支出在 2024 年达到 $5.3T（官方公告引用 CMS），但医疗劳动力短缺和流程碎片化使医院难以把新医学知识转成实际患者收益。医疗 AI 第一阶段偏影像/文书/辅助诊断，下一阶段会转向跨流程的 agentic automation：分诊、随访、授权、登记、质控、运营调度。Bunkerhill 卡位在医院内部“AI agent deployment platform”，既承接模型能力，也承接流程编排与治理；未来 1-2 年，能证明临床结局、等待时间和行政成本改善的公司更容易穿越医疗采购周期。
- 关键数据：官方 total funding to date $55M（Bunkerhill 官方公告，2026-07-16，[来源](https://www.bunkerhillhealth.com/resources/series-b-announcement)）；媒体披露 $25M Series B led by Khosla Ventures（Fortune/Thenextweb 搜索摘要，2026-07-16）；U.S. healthcare spending $5.3T in 2024（官方公告引用 CMS，2026-07-16）；UTMB 20+ AI agents live（官方公告，2026-07-16）；nephrology wait times reduced 50%+、urgent lung nodule cases addressed 80% faster、follow-up doubled（官方公告，2026-07-16）；YC W19 / founded 2021 / team size 30（YC 页面搜索与抓取，[来源](https://www.ycombinator.com/companies/bunkerhill-health)）。
- 原文链接：[来源](https://www.bunkerhillhealth.com/resources/series-b-announcement) ；[来源](https://www.bunkerhillhealth.com/) ；[来源](https://www.ycombinator.com/companies/bunkerhill-health) ；[来源](https://nishithbsk.github.io) 。
- 投资/合作视角：Bunkerhill 是本周美国组里最接近“医疗 AI 基础设施层”的标的，客户质量和效果数据强，且 Khosla/Sequoia/Optum/YC 的组合很有信号价值。投资风险集中在估值未披露、医疗合规与临床责任、以及是否能从少数标杆系统复制到更广医院网络；合作上适合与医院创新部门、影像/随访/授权流程改造项目对接。


---


### 🇨🇳 中国


### 日冕开物（中国 · 具身智能世界模型）
- 一句话定位：面向机器人跨场景泛化的具身智能世界模型公司，核心产品是自研物理世界基础模型 LaMPA 与配套数据/强化学习闭环。
- 本周动态：36氪/硬氪于2026-07-17 09:52（页面内 publishTime）首发披露，日冕开物（北京日冕机器人有限公司）近期完成连续两轮种子轮融资，合计金额达数亿元人民币，投资方包括鼎峰科创、远图未来、百度风投、沃衍资本、武岳峰科创、万林国际；新一轮融资同步交割中。资金主要用于自研世界模型 LaMPA 的研发迭代、强化学习体系建设、数据闭环和产品交付能力完善。腾讯新闻/36氪镜像亦在同周转载该融资信息，SVTR 市场事件页也收录该公司种子轮事件。
- 产品深研：日冕开物的 LaMPA 不是单一机器人控制算法，而是将环境表征（物体位置、关系、空间结构）、本体表征（关节位置、受力、传感器反馈）和经验表征（可供性、操作先验）统一到物理世界隐空间，再学习因果关系以预测未来状态并生成动作。团队在基础模型架构上采用更适合世界模型训练的 Block Diffusion，目标是在推理效率、数据利用效率和模型可扩展性之间取得平衡；在后训练环节，引入 World Reward Model，用基座世界模型蒸馏出“评价器”，为强化学习提供更稳定反馈，减少新工位因光照、布局、噪声变化而重复采数/重训的成本。产品化上，公司强调“模型+硬件+训练系统+Workflow Agent”整套标准化方案，已与远图未来达成战略合作，切入服务器制造的高精度工业装配场景，并计划从服务器制造全流程延伸到前后道工序。
- 融资记录：公开可确认融资为2026年连续两轮种子轮，合计数亿元人民币；36氪披露投资方为鼎峰科创、远图未来、百度风投、沃衍资本、武岳峰科创、万林国际，资金用途为 LaMPA、强化学习、数据闭环与交付能力建设；估值未披露。本报告未发现更早公开融资历史，公司成立时间为2026年3月，仍处种子期，公开资料未显示达到独角兽或10亿美元估值门槛。
- 创始人：创始团队均为清华自动驾驶背景，具备智驾世界模型与具身强化学习落地经验。创始人肖中阳博士曾主导智驾行业首个复杂交互场景世界模型交付，该模型据36氪报道已搭载超过70万辆蔚来汽车；基座模型负责人钟元鑫博士为“华为天才少年”，曾主导华为新一代智驾世界模型基模设计与量产落地；模型后训练与交付负责人王云龙博士曾在智元机器人负责大模型与真机强化学习算法，并推动行业首批进厂打工项目交付；市场负责人戴亚奇博士曾任武岳峰科创合伙人。
- 竞争力：核心壁垒在于自动驾驶世界模型工程经验向具身智能迁移、三重物理表征、World Reward Model 与工业场景数据闭环。短期优势是团队已拿到服务器装配高精度场景，可形成“真实工况数据—训练—部署—反馈”的闭环；风险在于公司成立时间极短，工业交付、数据采集规模、模型泛化能力仍需在更多工厂和更长运行周期中验证，且具身世界模型方向竞争者密集。
- 赛道分析：具身智能正从“本体硬件展示”进入“工位可交付”阶段，世界模型被视为解决机器人跨场景泛化的关键路线之一。未来1-2年，行业会从比拼机器人单点动作，转向比拼数据分布、仿真/真机闭环、奖励模型和低成本部署能力；日冕开物卡位在工业装配这种高价值但复杂度高的场景，若能跑通标准化 Workflow Agent，有机会成为机器人厂商和工厂自动化方案商的模型层供应商。
- 关键数据：成立时间：2026年3月（36氪，2026-07-17）；连续两轮种子轮合计：数亿元人民币（36氪，2026-07-17）；融资投资方：鼎峰科创、远图未来、百度风投、沃衍资本、武岳峰科创、万林国际（36氪，2026-07-17）；蔚来量产搭载经验：超过70万辆汽车（36氪，2026-07-17）；合作场景：远图未来服务器制造高精度工业装配（36氪，2026-07-17）；估值：未披露，未见公开独角兽披露。
- 原文链接：
  - [来源](https://www.36kr.com/p/3899081603483525) （36氪首发，2026-07-17）
  - [来源](https://view.inews.qq.com/a/20260717A036JB00) （腾讯新闻转载36氪，2026-07-17）
  - [来源](https://svtr.ai/funding) （SVTR市场事件页，本周收录）
- 投资/合作视角：对早期投资而言，日冕开物是“智驾世界模型人才迁移到工业具身”的典型样本，种子期但融资规模和产业投资方质量都释放强信号。合作上宜优先验证其在服务器装配之外的复制能力、部署周期和真机良率，而不是只看模型叙事；主要风险是技术路线尚早、商业化样本少。


---


### 半醒具身 BXI Robotics（中国 · 人形机器人ODM/物理AI硬件底座）
- 一句话定位：为品牌方、车企、机器人“大脑”公司和垂直场景客户提供人形机器人白牌整机、关节电机模组、运动控制算法与应用软件开发的ODM方案商。
- 本周动态：36氪/硬氪于2026-07-17 09:26（页面内 publishTime）披露，半醒具身近期完成千万元级新一轮融资，投资方为A股上市公司索辰科技；本轮资金将主要用于下一代人形机器人研发及海外市场拓展。网易订阅在2026-07-17亦披露同一事件，称本轮由索辰科技投资，此前飞荣达作为首轮投资方参与公司融资。公司还披露，2026年7月至2027年7月单月订单金额有望超过千万元、全年营收预计过亿。
- 产品深研：半醒具身选择ODM路线，本质上是在“人形机器人品牌快速入局”与“自研周期通常2-3年、团队难组、工程风险高”之间提供工程化捷径。公司强调全栈自研，从关节电机做起，补齐电控、结构设计、运动控制算法和应用软件，并形成 BXI-50/70/85 三款标准化行星中空关节电机模组，覆盖人形机器人全身31个自由度；早期为满足后空翻等高动态需求，自研峰值扭矩800牛米的行星关节电机、内水冷方案和1000Hz电控系统。与纯方案集成商不同，半醒的差异化在“整机需求倒推零部件设计”和“量产/赛场验证”：其精灵2、精灵3均参加北京人形机器人半程马拉松，2025年量产未改装版以4小时2分19秒完赛，2026年精灵3以150分钟净时间完赛。下一阶段研发重点是末端执行器、感知与计算模块，目标从“自由移动”走向“自由执行任务”。
- 融资记录：2025年完成首轮机构融资，投资方为A股上市公司飞荣达；2026年7月完成千万元级新一轮融资，投资方为索辰科技。融资金额为“千万元级”，具体金额、投后估值和股权比例未披露；公开信息未显示公司估值达到10亿美元。资金用途为下一代人形机器人研发、海外市场拓展。网易、36氪对本轮投资方和用途形成交叉验证。
- 创始人：公司成立于2022年，但团队2020年开始做人形机器人研发。联合创始人兼CEO陈彦2003年毕业于东南大学计算机专业，在机器人创业前有多年二级市场量化交易经验；联合创始人刘福强本科毕业于西南科技大学，大学期间连续四年参加全国大学生机器人大赛并多次获奖。团队的组合特点是“工程硬件+运动控制+量产交付”，而非单纯算法创业。
- 竞争力：护城河主要来自全栈工程能力、标准化关节电机模组、量产验证、上市公司产业股东和ODM商业模式。飞荣达的制造基地支持使其当前月产能可达数十台、短期可扩至月产百台以上；索辰科技的CAE仿真能力与其底层硬件和运动控制可形成“仿真训练—真机落地—数据回传—模型优化”的物理AI闭环。风险在于ODM毛利和品牌溢价通常弱于自有品牌，客户需求可能高度定制化，且人形机器人终端市场仍以科研、实验室和资本开支为主，实际大规模需求兑现节奏不确定。
- 赛道分析：人形机器人产业从样机展示进入供应链分工阶段，品牌方和场景方需要“花钱买时间”的整机底座，ODM模式因此具备阶段性窗口。未来1-2年，竞争会从“机器人能走能跑”转向“可执行任务、可量产、可维护、可海外交付”；半醒卡在中上游硬件底座与应用软件之间，适合作为具身智能大脑公司、车企机器人项目、科研平台的供应商。但长期看，若头部整机厂自研能力成熟，ODM厂商需通过成本、可靠性和迭代速度保持议价权。
- 关键数据：成立时间：2022年（36氪，2026-07-17）；团队启动研发：2020年（36氪，2026-07-17）；本轮融资：千万元级（36氪/网易，2026-07-17）；投资方：索辰科技（36氪/网易，2026-07-17）；历史投资方：飞荣达（36氪/网易，2026-07-17）；标准化关节模组：BXI-50/70/85，覆盖31个自由度（36氪，2026-07-17）；峰值扭矩：800牛米，电控频率：1000Hz（36氪，2026-07-17）；产能：当前月产数十台、短期可扩至百台以上（36氪，2026-07-17）；订单/营收预期：2026年7月至2027年7月单月订单金额有望超过千万元，全年营收预计过亿（36氪，2026-07-17）；估值：未披露。
- 原文链接：
  - [来源](https://m.36kr.com/p/3899057634363266) （36氪首发，2026-07-17）
  - [来源](https://www.163.com/dy/article/L22BCAR0055651K9.html) （网易订阅，2026-07-17）
  - [来源](https://www.163.com/dy/article/L21FMCM905118DFD.html) （网易转载36氪，2026-07-17）
- 投资/合作视角：半醒具身适合关注“人形机器人量产底座”和“物理AI真机数据入口”的早期投资人/产业方跟踪。合作上可以优先验证其关节模组可靠性、海外交付能力、百台级产能爬坡和客户复购；风险是ODM模式易被价格战压缩利润，且公司对下游人形机器人需求爆发时间高度敏感。


---


### 酷奇奇 Coolqq（中国 · AI角色硬件/AI陪伴）
- 一句话定位：把AI角色引擎与分布式消费硬件结合的AI陪伴创业公司，主产品 CookiePi 让数字角色以玩偶、手办、家居物件等具身形态进入生活空间。
- 本周动态：36氪游戏于2026-07-17 08:00（页面内 publishTime；新浪财经转载显示07.17 08:06）披露，酷奇奇科技（Coolqq.com）完成数千万元种子轮融资，由上海浦东人工智能种子基金领投，商汤科技、零以创投跟投，云杉资本Spruce Capital担任长期独家财务顾问。同篇文章披露，酷奇奇CookiePi预计在2026-07-31结束第四批百人付费用户测试，并正式发出现货；公司已与科技家居博主“小狮日记”达成深度战略合作。
- 产品深研：酷奇奇的核心产品 CookiePi 角色互动伙伴由1个Cookie触发器和N个Pi角色端组成，多个AI互动伙伴可散落在家居、玩偶、手办等物理载体中，主动探索、聊天和即兴演剧。其核心技术 K.ALife OS（AI角色引擎）不是把角色简单做成“prompt + RAG”，而是维护三类持续更新的文件：角色是什么、用户是谁、这段关系中发生过什么，使角色随着每次交互刷新记忆、偏好与状态；这让公司试图把护城河从对话质量转向“用户沉淀的角色资产”。硬件上，公司坚持“Cookie控制中心 + Pi物理载体”的分离式架构，避免一体机局限在固定位置，让不同角色拥有不同生活空间位置，并支持群聊、私聊、角色互相“串门”等玩法；软件上还自研“未说之事”，让角色主动生成日记或内心独白，增加陪伴感和关系连续性。
- 融资记录：公开可确认融资为2026年7月数千万元种子轮，投资方为上海浦东人工智能种子基金、商汤科技、零以创投，财务顾问为云杉资本Spruce Capital；具体金额、估值、股权比例未披露。公司创办于2025年，目前处种子期，公开资料未显示估值达到10亿美元。资金用途未在原文中逐项披露，但投资方观点强调“AI主动交互在实体硬件上的落地”和AI消费应用生态布局。
- 创始人：创始人徐持衡是商汤科技001号员工，师从汤晓鸥教授，与团队共同开发的人脸识别技术，是商汤早期重要技术里程碑之一；他还曾在灵宇宙担任CTO，带领AI教育产品“Ling”从概念落地到完整实现。公司AI Infra线由前商汤/百度IDL的王琳负责，硬件团队负责人来自小米生态链企业，具备消费级硬件量产经验；团队约25人，专业覆盖计算机、汉语言文学、哲学、环境设计、数字媒体技术等。
- 竞争力：酷奇奇的潜在护城河在于“角色长期记忆/关系资产+分布式硬件+内容运营”的组合，而不是单纯大模型能力。内测数据显示，单个用户付费1000元，7天测试中人均创建4个角色；一位用户基于《海绵宝宝》NPC自创的两个角色进入近百人社群并产生串门剧情，说明UGC/社群传播有早期信号。风险在于AI陪伴硬件处于消费品验证期，用户新鲜感、隐私合规、内容安全、硬件售后和规模化获客成本都可能成为关键瓶颈；同时大厂和玩具/IP公司也可能快速进入。
- 赛道分析：AI陪伴正从App内对话框走向“有实体感、主动交互、长期记忆”的新形态，尤其在二次元、乙游、娃妈、智能家居女性用户中有早期需求。未来1-2年，赛道会比拼三件事：角色记忆是否真的形成长期留存、硬件成本/体验是否可规模化、内容/IP生态是否能持续供给。酷奇奇当前处在“付费内测—现货上线”前夕，若7月31日后能证明复购、日活和角色资产迁移，其种子轮估值上行空间较大；若仅停留在情绪价值玩具，天花板和留存都需谨慎。
- 关键数据：创办时间：2025年（36氪/新浪财经，2026-07-17）；融资：数千万元种子轮（36氪/新浪财经，2026-07-17）；投资方：上海浦东人工智能种子基金领投，商汤科技、零以创投跟投（36氪/新浪财经，2026-07-17）；团队规模：约25人，超过一半为实习生（36氪/新浪财经，2026-07-17）；用户测试：已完成3次用户测试，单次7天（36氪/新浪财经，2026-07-17）；内测付费：单用户付费1000元，人均创建4个角色（36氪/新浪财经，2026-07-17）；小狮日记相关视频全网播放：超过2000万（36氪/新浪财经，2026-07-17）；第四批百人付费测试结束/现货上线：预计2026-07-31（36氪/新浪财经，2026-07-17）；估值：未披露。
- 原文链接：
  - [来源](https://m.36kr.com/p/3898370289846153) （36氪游戏首发，2026-07-17）
  - [来源](https://finance.sina.cn/stock/jdts/2026-07-17/detail-iniiahrp8111860.d.html) （新浪财经转载，2026-07-17）
  - [来源](https://mp.weixin.qq.com/s/vLNgEV3R0A_2qbgljpDDhg) （36氪游戏公众号原文入口，36氪文末标注）
- 投资/合作视角：酷奇奇是AI消费硬件里“关系资产”路线的早期样本，适合观察付费用户是否愿意为角色成长和实体载体持续买单。合作上可围绕IP、玩具、智能家居渠道或内容社区做小规模验证；投资风险集中在量产、内容安全、留存与用户情感依赖边界。


---


### 红熊AI（中国 · AI记忆科学/企业Agent）
- 一句话定位：围绕“AI记忆科学”构建 OpenBear 通用大模型、MemoryBear 记忆系统与原生Agent架构的企业级AI应用公司。
- 本周动态：36氪于2026-07-20 09:00（页面内 publishTime）披露，红熊AI完成数亿元人民币A+轮融资，投后估值接近30亿元人民币，由浙江九纬私募基金、嘉兴彰元创业投资与老股东格睿丰联合投资；这是公司15个月内完成的第6轮融资。腾讯新闻早报在2026-07-21同步提及“红熊AI昨日宣布完成数亿元人民币A+轮融资，投后估值接近30亿元”。资金将用于深化AI记忆科学类人大脑基础研究、加速OpenBear通用大模型与MemoryBear记忆科学系统深度融合，并扩大智能客服、智能营销、ChatBI、智能教育四大场景覆盖。
- 产品深研：红熊AI的产品体系围绕“模型+记忆+Agent”三角矩阵展开：OpenBear 是面向记忆设计的通用大模型，采用 MoE 稀疏混合专家架构，并预留与外部记忆系统高频低延迟交互的接口；MemoryBear 借鉴 ACT-R 双记忆架构、艾宾浩斯遗忘曲线、激活度模型、智能语义剪枝和3D自我反思引擎，构建工作记忆、短期记忆、长期记忆的分层动态体系；原生Agent架构则把“记住用户交互、执行结果并用于后续调优”作为默认能力。与普通RAG或长上下文方案相比，红熊强调时间记忆、动态语义网络、语义剪枝和最小化记忆共享，以降低长期任务中的上下文断裂、token成本和幻觉率。商业产品已落到智能客服、智能营销、ChatBI和智能教育，其中智能客服/营销是主要收入来源，ChatBI已有营收，智能教育已签约2所大学。
- 融资记录：2024年4月创立后15个月内完成6轮融资；本周A+轮为数亿元人民币，投后估值接近30亿元人民币，投资方为浙江九纬私募基金、嘉兴彰元创业投资与老股东格睿丰。36氪未逐一披露此前5轮的轮次、金额和机构，本报告不补造；估值按30亿元人民币约合4.1亿美元（按约7.2人民币/美元粗略折算）低于10亿美元。资金用途为OpenBear/MemoryBear/Agent融合和四大场景市场扩张。
- 创始人：红熊AI创始人为温德亮，2024年4月创立公司即确立“记忆驱动AGI”的技术路线。原文对其前东家/学历披露有限，但从公司产品看，团队能力集中在大模型预训练、记忆系统、Agent架构与企业应用落地。投资方格睿丰评价其为国内少数拥有原创核心技术的AI公司之一，商业化能力强；这需要后续通过客户留存、续费和技术指标复测进一步验证。
- 竞争力：红熊AI的关键竞争力是把“记忆层”从功能模块提升为技术路线，并用企业应用收入验证。公司披露 MemoryBear 支持下基础大模型知识遗忘率控制在1%以下、token消耗降低25倍、行业歧义预处理率控制在1%以下、幻觉率降至0.2%左右；商业化方面，2026年上半年确收超1.7亿元、ARR突破0.5亿元、客户超过500家，其中包括世界500强和上市公司。风险在于这些指标主要来自公司披露，需第三方评测和客户案例交叉验证；同时AI记忆赛道拥挤，Clipto、记忆张量、MemoraX AI等国内外玩家已获融资，技术标准尚未确定。
- 赛道分析：企业AI应用从“模型能力演示”进入“长期任务与业务闭环”阶段，记忆层成为Agent系统的基础设施之一。未来1-2年，企业会更关注AI系统能否跨多轮、多天、多角色保持一致、可追溯、低成本并接入业务权限；红熊AI以客服、营销、BI、教育切入，覆盖高频企业流程，有利于沉淀行业记忆和数据闭环。若OpenBear和MemoryBear能证明可迁移到开发者工具CodeBear及C端通用模型，可能从应用公司上探到AI基础设施；但若大模型厂商原生记忆能力快速补齐，其差异化需靠客户数据、系统稳定性和行业Know-how维持。
- 关键数据：创立时间：2024年4月（36氪，2026-07-20）；本轮融资：数亿元人民币A+轮（36氪，2026-07-20；腾讯新闻，2026-07-21）；投后估值：接近30亿元人民币（36氪，2026-07-20；腾讯新闻，2026-07-21）；15个月融资次数：6轮（36氪，2026-07-20）；投资方：浙江九纬私募基金、嘉兴彰元创业投资、格睿丰（36氪，2026-07-20）；MemoryBear指标：知识遗忘率1%以下、token消耗降低25倍、行业歧义预处理率1%以下、幻觉率约0.2%（公司披露于36氪，2026-07-20）；客户数：超过500家（36氪，2026-07-20）；2026上半年确收：超1.7亿元（36氪，2026-07-20）；ARR：突破0.5亿元（36氪，2026-07-20）；智能教育：已签约2所大学，今年预估约2000万元流水（36氪，2026-07-20）。
- 原文链接：
  - [来源](https://www.36kr.com/p/3899612612494976) （36氪首发，2026-07-20）
  - [来源](https://news.qq.com/rain/a/20260721A02TV300) （腾讯新闻早报，2026-07-21）
  - [来源](https://www.facebook.com/rpi.werls.top/posts/1655534799907282/) （转载摘录，检索到7月19日传播痕迹）
- 投资/合作视角：红熊AI已经不是纯概念早期项目，而是有收入、ARR和客户数披露的“应用型基础设施”公司，适合重点尽调其客户质量、续费率、毛利和技术指标真实性。合作上，客服、营销、BI、教育场景可快速试点；风险是估值已接近30亿元人民币，下一轮需要更强的可审计收入和可复现技术壁垒支撑。


---


### 月泉仿生（中国 · 仿生灵巧手/具身智能）
- 一句话定位：基于仿生拉压体机器人理论，研发仿生灵巧手、人形机器人整机、电机和世界-行为大模型的具身智能硬件公司。
- 本周动态：36氪于2026-07-21 08:00（页面内 publishTime）独家披露，月泉仿生完成数亿元Pre-A+轮融资，由长发基金、华控基金、华夏基金、国力民生、星科创投基金等联合投资，老股东中关村启航投资跟投。投资界同日（2026-07-21）报道了同一融资事件，并说明资金将用于团队建设、核心产品技术研发、产能提升、强化全栈自研能力，推动超仿生神经骨骼肌肉机器人研发，打造“大脑-身体-环境”一体化仿生具身智能体系。公司还在本周WAIC展示Y-Hand M1/M2、X-Hand M1、YQ Motors和博文W-Bot 2.0等产品。
- 产品深研：月泉仿生的底层差异化来自“仿生拉压体”理论：模仿人体骨骼、肌肉、韧带协同逻辑，让硬质构件承担压力、柔性构件承担拉力，从机械结构层面改善传统刚性灵巧手在轻量化、抓取力量、柔顺性和精细操作之间的矛盾。公司已形成自研空心杯电机、人工肌肉模组、仿生灵巧手、人形机器人整机、世界-行为大模型的全栈产品矩阵；旗舰“应手Y-Hand”系列聚焦类人柔顺操作，M1掌部仅299.7g，却集成26个自由度、五指抓握力200N，拇指配置8个自由度；M2具备38个自由度，公司称其为全球自由度最高的仿生灵巧手。面向工业强度场景，公司另有“信手X-Hand M1”，最大50kg负重、百万次循环寿命；轮式人形整机“博文W-Bot 2.0”搭载0.238㎡小底盘，工作空间覆盖0-2.2m，可用于工厂自动化装配、仓储分拣、机房巡检、展厅接待等场景。
- 融资记录：本周融资为数亿元Pre-A+轮，投资方包括长发基金、华控基金、华夏基金、国力民生、星科创投基金，中关村启航投资继续跟投；具体金额、投后估值未披露。投资界和36氪均披露本轮融资与资金用途，形成交叉验证。原文未列出完整历史融资时间表，仅可确认中关村启航投资为老股东；公开资料未显示月泉仿生估值达到10亿美元或已成独角兽。
- 创始人：月泉仿生依托国家特聘专家、教育部长江学者、英国曼彻斯特大学终身教授任雷教授提出的“仿生拉压体机器人理论与技术”完成科研成果转化。36氪和投资界还提到CTO赵迪曾对外说明公司在设计之初同步规划量产路径，核心零部件具备直接切换量产的能力。由此看，公司创始/技术团队的核心优势是高校原创理论、仿生结构与工程量产结合，而非单纯从外部集成零部件。
- 竞争力：月泉仿生的护城河在底层机械结构原创性、全栈自研矩阵、量产规划和订单验证。与堆自由度、扭矩参数的灵巧手不同，仿生拉压体路线试图从结构上同时解决柔顺、负载、成本和可靠性问题；公司位于北京昌平的生产基地建设中，商业化上已面向智能制造、仓储物流、巡检运维、医疗健康、家政服务等多个场景输出方案，累计取得过亿元订单。风险在于灵巧手行业资本热度高、同质化叙事多，真实量产良率、成本、寿命和场景ROI仍需持续验证；“全球自由度最高”等表述来自公司披露，需第三方测试佐证。
- 赛道分析：灵巧手是人形机器人从移动展示走向真实作业的核心部件，2026年国内灵巧手融资和出货预期均快速升温。高工产业研究院（GGII）预计2026年中国灵巧手产品全年销量有望突破7万只，这意味着供应链将从小批量科研件转向标准化量产件；未来1-2年，灵巧手竞争会从自由度指标转向寿命、成本、可维护性、触觉/力控、与大脑模型协同。月泉仿生卡在“高仿生灵巧操作+工业刚性手+整机方案”交叉位置，若量产和订单兑现，既可卖部件，也可卖整机/解决方案。
- 关键数据：本轮融资：数亿元Pre-A+轮（36氪，2026-07-21；投资界，2026-07-21）；投资方：长发基金、华控基金、华夏基金、国力民生、星科创投基金，中关村启航投资跟投（36氪/投资界，2026-07-21）；Y-Hand M1：掌部重299.7g、26个自由度、五指抓握力200N、拇指8个自由度（36氪，2026-07-21）；Y-Hand M2：38个自由度（36氪，2026-07-21）；X-Hand M1：最大50kg负重、百万次循环寿命（36氪，2026-07-21）；YQ Motors：4–22mm全尺寸7个系列（36氪，2026-07-21）；W-Bot 2.0：0.238㎡小底盘、工作空间0-2.2m（36氪，2026-07-21）；GGII预测：2026年中国灵巧手销量有望突破7万只（36氪/投资界，2026-07-21）；商业订单：累计过亿元（36氪/投资界，2026-07-21）；估值：未披露。
- 原文链接：
  - [来源](https://www.36kr.com/p/3899174356387718) （36氪首发，2026-07-21）
  - [来源](https://news.pedaily.cn/202607/566622.shtml) （投资界，2026-07-21）
  - [来源](https://m.sohu.com/a/1052865831_313745) （搜狐转载科创板日报，2026-07-21）
  - [来源](https://i.gasgoo.com/news/70466584.html) （盖世汽车，2026-07-20）
- 投资/合作视角：月泉仿生是灵巧手从“参数竞赛”转向“仿生结构与量产交付”的代表标的，适合机器人整机厂、工业自动化客户和具身智能基金重点跟踪。合作建议从标准化灵巧手/电机小批量测试开始，重点看寿命、维护成本和真实工位效率；投资风险在于赛道拥挤、硬件量产爬坡慢、订单收入确认周期可能长。


---


### 🇪🇺 欧洲+以色列


### Applied Computing（英国 · 工业/能源 Foundation AI）
- 一句话定位：Applied Computing 是一家伦敦 AI 公司，面向油气、炼化、石化等复杂能源运营场景构建“Energy’s foundation model”，用 Orbital 将时间序列、物理/化工模型与语言模型组合成可解释的工业 AI 操作系统。
- 本周动态：2026-07-15/16，TechCrunch、Tech.eu 与 EU-Startups 报道公司完成 $20M（约 €17.4M）融资，由工程与能源服务巨头 KBR 领投，Databricks Ventures 参投；同时公司宣布在美国休斯敦开设办公室，以贴近北美能源客户。TechCrunch 称该轮为 Series A，并披露公司从 stealth 到“double-digit millions in ARR”不到 18 个月；EU-Startups/Tech.eu 披露资金将用于国际扩张、Orbital 商业部署、AI 研究组织与工程团队扩张，并提及公司将在数周内宣布与一家欧洲油气巨头的首个合作。
- 产品深研：核心产品 Orbital 不是通用 LLM，而是面向炼厂、油气与石化装置的多基础模型系统：时间序列模型接入 DCS、historian、LIMS 等传感器与实验数据，预测趋势、异常与漂移；物理模型从手册与文献中抽取质量守恒、能量守恒、反应动力学等约束；语言模型理解 P&ID、SOP、工单与化工术语，向工程师解释原因并推荐操作。与 AspenTech、AVEVA、Cognite、Seeq 等工业软件/数据平台相比，Applied Computing 强调“physics-grounded + explainable + real-time”的组合，以及用 100% 可用运营数据而非传统约 8% 数据做预测和优化。KBR 的 INSITE 3.0 已在 2026-03 集成 Orbital，KBR 官方称该系统可识别数学可追溯的根因、预测问题并给出实时建议；这说明本周融资不是孤立资本事件，而是围绕巨头渠道、现场数据与行业 know-how 的产品商业化加速。
- 融资记录：2025-05-28，公司宣布 £9M seed，由 Stride.VC 领投、Repeat.vc 参与，官方称为英国 AI 公司较大的种子轮之一；Imperial College 2025-06-02 交叉验证了该轮为 £9M。2026-03-23，KBR 官宣对 Applied Computing 做战略投资并取得董事席位，同时签署多年联合开发协议，金额未披露。2026-07-15/16，本周 $20M / €17.4M 融资由 KBR 领投、Databricks Ventures 参投；TechCrunch 明确为 Series A，EU-Startups/Tech.eu 披露用途为美国/国际扩张、研发工程招聘与能源客户部署。PitchBook 搜索摘要显示累计融资 $34.7M；公开估值未披露，StartupHub 低置信估算约 $104.4M，仅作为非权威参考，主判断为“未披露但显著低于 $1B”。
- 创始人：公司由 Callum Adamson（CEO）和 Dr. Samyakh/Sam Tukra（Chief AI Officer）于 2023 年创立。Imperial College 报道称 Dr. Tukra 是 Imperial 校友，2022 年在 Hamlyn Centre for Robotic Surgery 完成 AI 与 3D computer vision 博士，并曾创办 Third Eye Intelligence；Callum Adamson 是连续创业者、Imperial AI/ML Expert-in-Residence，曾在 Imperial Enterprise Lab 指导 Tukra，后来共同启动 Applied Computing。团队还吸纳了 Shell、Palantir、BP Launchpad、Imperial 等背景的人才；公司任命前 Shell AI leader Dan Jeavons 为 President，强化能源工业落地能力。
- 竞争力：护城河来自三层叠加：第一，复杂工业现场非公开运营数据与 KBR 渠道带来的数据/客户飞轮；第二，物理约束与工程语义结合，使系统更适合安全关键、高价值资产，而不是只做聊天式分析；第三，KBR、Wipro、Databricks 与北美客户等伙伴证明了早期 go-to-market。增长信号强：TechCrunch 披露不到 18 个月达到数千万美元 ARR，Orbital 已在公开上市的大型上游、下游炼化与石化企业中使用。风险也明显：能源客户销售周期长、现场集成复杂、AI 建议在安全关键场景的责任边界高；同时 AspenTech/AVEVA 等老牌工业软件厂商客户关系深，可能通过并购或内生 AI 功能反击。
- 赛道分析：工业 AI 正从“数据湖/可视化/预测维护”进入“可解释自治优化”阶段，尤其能源、化工、重工业因能耗、排放、停机成本巨大，ROI 容易量化。未来 1-2 年，赢家可能不是最大通用模型提供商，而是能把现场数据、仿真、约束、工程知识和闭环优化做进工作流的垂直基础模型公司。Applied Computing 卡位在炼化与石化这一高复杂度、高付费意愿场景；若能借 KBR 复制到资本项目、运维优化、氨/氢/LNG、风电/水电等多资产场景，具备从点状模型供应商成长为工业 AI 基础层的潜力。
- 关键数据：$20M/€17.4M 本周融资，KBR 领投、Databricks Ventures 参投（TechCrunch 2026-07-15；Tech.eu/EU-Startups 2026-07-16）；£9M seed，Stride.VC 领投、Repeat.vc 参与（Applied Computing PR 2025-05-28；Imperial College 2025-06-02）；公司成立 2023 年，伦敦总部、Bengaluru operations、Houston 新办公室（EU-Startups/Tech.eu 2026-07-16）；Orbital 使用 100% 可用下游设施数据 vs 传统方法 8%，关键指标较已 benchmark SOTA 软件高 90%（EU-Startups 2026-07-16；公司 PR 2025-05-28）；TechCrunch 披露 <18 个月达到 double-digit millions ARR（2026-07-15）；Imperial 测试中 CO₂ 浓度预测提升 53.7%、早期异常检测 99.1% accuracy（Imperial College 2025-06-02）。
- 原文链接：
  - [来源](https://techcrunch.com/2026/07/15/applied-computing-wants-to-give-oil-and-gas-operators-an-ai-model-for-the-entire-plant/)
  - [来源](https://tech.eu/2026/07/16/applied-computing-lands-20m-to-expand-foundation-ai-for-energy/)
  - [来源](https://www.eu-startups.com/2026/07/london-based-applied-computing-raises-e17-4-million-to-scale-ai-that-works-for-the-energy-industry/)
  - [来源](https://appliedcomputing.com/)
  - [来源](https://appliedcomputing.com/press-release-28052025)
  - [来源](https://www.imperial.ac.uk/news/264573/ai-startup-driven-imperial-alumni-closes/)
  - [来源](https://www.kbr.com/en/insights-news/press-release/kbr-launches-insite-30-expanding-digital-platform-and-advancing-ai-driven-growth-strategy)
  - [来源](https://www.kbr.com/en/insights-news/press-release/kbr-announces-strategic-investment-applied-computing-accelerate-ai-driven-innovation-across-energy-and-industrial-markets)
- 投资/合作视角：这是本周 C 组中信号最强的一家：ARR、战略客户/投资方、垂直基础模型叙事与能源巨头落地同时出现，值得优先安排专家访谈与客户验证。早期投资窗口可能已从 seed 进入高质量 A 轮后阶段；若估值仍在合理区间，重点看 KBR 绑定是否限制其多渠道扩张，以及 Orbital 在不同工艺/客户间的可迁移性。


---


### Hyperion Robotics（芬兰 · Physical AI / 建筑机器人）
- 一句话定位：Hyperion Robotics 是一家总部位于 Espoo 的 physical AI 公司，用计算设计、机器人增材制造和本地化“微工厂”生产低碳混凝土基础设施组件，目标让建筑基础施工更快、更便宜、更低碳。
- 本周动态：2026-07-16，EU-Startups 与 Tech.eu 报道 Hyperion 完成 €6.4M（$7.4M）growth funding，用于在欧洲扩张机器人微工厂；该轮由 Course Corrected 与 European Innovation Council Fund（EIC Fund）共同领投，RE Ventures（Romande Energie Group 旗下）以及老股东 Lifeline Ventures、Übermorgen Ventures、PC Rettig Impact & Co. 参投。公司披露本轮后累计融资接近 €17.4M（$20M），并将从项目制交付转向工业规模生产；首个英国 Forge I 微工厂将在 Scunthorpe 附近 Flixborough 与 LKAB 合作启动，服务能源、公用事业、水务、数据中心和碳捕集等基础设施需求。
- 产品深研：Hyperion 的核心不是单纯 3D 打印混凝土，而是把 physical AI、结构工程、合规、机器人与工厂运营串成一套 Forge 平台。其产品路径是：用软件做设计和结构优化，用机器人微工厂就近生产低碳混凝土组件，再把标准化组件安装到项目现场，从而减少现场劳动、物流、材料浪费与安全暴露。与传统现浇/预制混凝土相比，公司宣称可最多减少 75% 材料、最多减少 70% CO₂、最多降低 50% 成本，并让基础设施组件生产速度提升至 3 倍；这使它更像“AI-enabled distributed manufacturing for infrastructure”，而不是传统 construction tech 工具。
- 融资记录：公开早期融资记录不完整。公司官网称截至页面信息有 €10M capital raised；2024-07，Hyperion 入选 EIC Accelerator，官网披露获得 €2.37M grant，并带有欧盟 equity investment 支持碳负材料开发；2026-07-16 本周 €6.4M growth funding 由 Course Corrected 与 EIC Fund 共同领投，RE Ventures 及 Lifeline Ventures、Übermorgen Ventures、PC Rettig Impact & Co. 参投，使累计资本接近 €17.4M。估值未披露；搜索摘要中 StartupHub 的低置信估算约 $30.9M，仅供线索，不作为正式估值依据，按已披露规模与非独角兽报道纳入主清单。
- 创始人：公司成立于 2020 年，创始团队包括 Fernando De los Rios（Co-founder & CEO）、Ashish Mohite（Co-founder & CTO）和 Henry Unterreiner（Co-founder & Head of Engineering）。公司官网介绍 Fernando 是连续创业者，曾在硅谷创办两家公司，并有金融、建筑、3D 打印和 EY 工业客户优化/审计经验；Ashish 是欧洲机器人与 3D 打印专家，拥有 3D printing and construction 博士，结合建筑现场经验、技术与材料科学；Henry 是 chartered structural engineer，曾在 Arup 设计和交付世界级工程项目，具备结构设计与产品化能力。三人组合覆盖融资/商业、机器人增材制造、结构工程，契合“把混凝土基础设施工业化”的跨学科需求。
- 竞争力：公司护城河在于工程闭环而非单点机器人：Forge 平台、结构设计知识、材料/合规、现场项目经验与微工厂部署能力相互耦合。客户信号较强，EU-Startups 披露 notable clients 包括 National Grid、Costain、Mott MacDonald Bentley、Anglian Water、United Utilities；公司官网案例包括 Fastned EV charging infrastructure、Costain 的 East Coast Cluster CO₂ pipeline、Usk Reservoir pad foundations。风险在于建筑业采购与验收保守、各国规范/认证差异大、微工厂资本开支与利用率管理复杂；此外“physical AI”叙事需要持续证明软件智能能带来可复制毛利，而不只是工程项目服务收入。
- 赛道分析：欧洲基础设施正进入电网、水务、工业设施、数据中心、碳捕集与新能源相关基础的大规模更新周期，同时面临劳动力短缺、公共预算约束和减碳压力。建筑机器人/增材制造此前常受困于演示项目多、规模化难；Hyperion 的差异化在于从“现场打印”转向“靠近项目的工厂化生产”，更容易控制质量、合规、成本和交付节奏。未来 1-2 年，若数据中心电力基础、输配电升级、碳捕集管网等高重复需求增长，公司有机会形成标准组件库和区域微工厂网络；但其扩张速度会受工程认证、合作承包商能力和资本效率约束。
- 关键数据：€6.4M / $7.4M 本周 growth funding（EU-Startups、Tech.eu 2026-07-16）；累计资本接近 €17.4M / $20M（EU-Startups 2026-07-16）；2024-07 EIC Accelerator €2.37M grant + equity investment（Hyperion 官网）；成立 2020 年、总部 Espoo/Finland（EU-Startups 2026-07-16；公司官网）；低碳基础可减少最多 70% embodied carbon、最多 75% 材料、最多 3x 生产/交付速度、最多 50% 成本（EU-Startups/Tech.eu 2026-07-16；公司官网）；公司官网另列 70% less CO₂ emissions、30% cost savings、3x faster delivery、80% less site exposure。
- 原文链接：
  - [来源](https://www.eu-startups.com/2026/07/espoo-based-hyperion-robotics-raises-e6-4-million-to-bring-physical-ai-to-european-infrastructure/)
  - [来源](https://tech.eu/2026/07/16/hyperion-robotics-secures-74m-to-expand-robotic-construction/)
  - [来源](https://www.hyperionrobotics.com/)
  - [来源](https://www.hyperionrobotics.com/about-company/)
  - [来源](https://www.hyperionrobotics.com/eicfunding/)
- 投资/合作视角：这家公司适合作为“AI + hard infrastructure + decarbonisation”的合作/投资观察标的，尤其对能源、数据中心、水务、碳捕集项目方有直接合作价值。投资尽调要重点看单位经济：每个 Forge 微工厂的 CAPEX、产能利用率、项目毛利、合规复制周期，以及 AI/软件在成本优势中到底贡献多少。


---


### Sightera Biosciences（比利时 · AI 药物发现 / TechBio）
- 一句话定位：Sightera Biosciences 是 University of Antwerp 与 Antwerp University Hospital（UZA）孵化的 AI-native drug discovery 公司，用治疗抵抗/终末期患者来源组织生成专有药物反应数据，反向驱动小分子与 molecular glue 设计。
- 本周动态：2026-07-17，EU-Startups 与 Tech.eu 报道 Sightera 完成 €3M pre-seed，投资方包括 Entourage、Anacura 和 QBIC。资金将用于扩充团队、扩展 AI-native drug discovery 平台与临床前资产组合、推动 lead molecular glue oncology programme SIGHT001 走向 preclinical candidate selection，并加强与 pharma / BioTech 的平台合作。European Biotechnology 2026-07-20 进一步确认该轮用于推进 AI-generated molecular glues，并披露 SIGHT001 面向 KRAS-mutant pancreatic、biliary tract 与 colorectal cancers。
- 产品深研：Sightera 的关键差异是“不让 AI 先预测 biology，而让 biology 教 AI”：公司从 advanced、therapy-resistant、end-stage disease 患者组织中建立 patient-derived organoids 等可规模化临床前模型，再通过 robotic high-throughput screening 生成动态、纵向、带临床注释的药物反应数据。AI 平台不是只围绕公开数据或预定义靶点做 molecule generation，而是学习分子特征如何在真实患者来源疾病模型中触发目标生物反应，再设计新的小分子。其 pipeline 以 SIGHT001 molecular glue degrader 为 lead，另有 SIGHT002（HER2+ 食管/胃癌 molecular glue）、SIGHT101（纤维化小分子）与 SIGHT-00X（molecular glue antibody conjugate / MAC）探索，形成平台 + 管线 + out-licensing 的 TechBio 商业模式。
- 融资记录：公司于 2025-01 创立，2026-01 从 UA/UZA spin out；2026-07-17 本周完成 €3M pre-seed，由 Entourage、Anacura、QBIC 领投/参与。EU-Startups 披露该 €3M 是走向更大融资的一步，目标是最终把 SIGHT001 推入临床试验；Vestbee 与 Tech.eu 对金额、阶段、投资方与资金用途进行了交叉验证。公开估值未披露；Seedtable 搜索摘要显示约 $3.5M pre-seed，StartupHub 有约 $10.6M 的低置信估算，但均不作为正式估值。当前仅 1 轮小额 pre-seed，合理判断远低于 $1B。
- 创始人：创始团队包括 Hendrik Vercammen, PhD（Co-founder & CEO）、Maxim Le Compte, PhD（Co-founder & CSO）、Christophe Deben, PhD（Co-founder & CDO）和 Lars Vanlommel, MSc（Co-founder & CBO）。官网介绍 Hendrik 是药剂师，具备 drug discovery / development 与 biotech 市场洞察；Maxim 有 patient-derived robotic high-throughput screening 与 cheminformatics 经验；Christophe 结合科研与数据科学，背景包括 robotic high-throughput drug screening 与自动化数据分析，并领导 Tumoroid Screening Group；Lars 有 5 年以上 corporate finance、M&A、equity/debt 交易经验。团队结构覆盖患者来源模型、筛选、数据/AI、药物开发和融资 BD，是做 patient-derived AI drug discovery 所需的多学科组合。
- 竞争力：护城河主要在专有数据生成能力，而不只是模型算法。治疗抵抗与高度预处理肿瘤样本、patient-derived organoids、高通量筛选、临床注释与纵向反应数据如果持续积累，会形成其他纯计算平台难以复制的数据资产。公司策略也避开“AI 生成分子后再做复杂 biology 验证”的常见失败路径，强调从人类疾病 biology 出发，提高临床转化概率。风险在于：pre-seed 阶段数据披露有限，SIGHT001 靶点与详细体内/体外结果尚未公开；molecular glue / TPD 赛道竞争激烈且机制复杂，进入 IND 和人体临床需要大量资本；患者样本获取、实验标准化与数据规模也会限制模型迭代速度。
- 赛道分析：AI 药物发现经历了“公开数据 + 生成模型”的第一阶段后，投资者越来越关注 wet-lab 数据质量、临床相关性和转化成功率。Molecular glue/targeted protein degradation 因可触达传统小分子难以成药靶点而受关注，但同样面临选择性、毒性与机制验证挑战。未来 1-2 年，TechBio 公司会分化为两类：一类卖平台合作，另一类靠自有资产拿到临床里程碑；Sightera 试图兼具二者，早期管线 out-license 给大药企，同时用平台 discovery partnerships 变现。如果 SIGHT001 候选物选择与后续临床前数据扎实，可能成为比利时/欧洲 AI biotech 中值得跟踪的早期资产型平台。
- 关键数据：€3M pre-seed（EU-Startups 2026-07-17；Tech.eu 2026-07-17；Vestbee 2026-07-17；European Biotechnology 2026-07-20）；投资方 Entourage、Anacura、QBIC（同上）；公司 2025-01 创立、2026-01 从 UA/UZA spin out（EU-Startups 2026-07-17）；平台使用 therapy-resistant / heavily pre-treated / end-stage patient-derived tissues 和 organoids 生成 proprietary drug-response datasets（EU-Startups、Tech.eu、公司官网）；SIGHT001 面向 KRAS-mutant pancreatic、biliary tract、colorectal cancers，已有 pancreatic cancer models in vivo 与 colorectal/bile duct samples ex vivo 活动线索但未披露详细数据（Vestbee 2026-07-17；European Biotechnology 2026-07-20）；管线含 SIGHT001、SIGHT002、SIGHT101、SIGHT-00X（公司官网）。
- 原文链接：
  - [来源](https://www.eu-startups.com/2026/07/antwerps-sightera-biosciences-raises-e3-million-to-scale-its-patient-derived-ai-drug-discovery-platform/)
  - [来源](https://tech.eu/2026/07/17/sightera-biosciences-closes-eur3m-pre-seed-to-expand-its-patient-derived-ai-drug-discovery-platform/)
  - [来源](https://vestbee.com/insights/articles/sightera-biosciences-lands-3-m)
  - [来源](https://european-biotechnology.com/latest-news/sightera-raises-e3m-to-advance-ai-generated-molecular-glues/)
  - [来源](https://htworld.co.uk/news/ai/sightera-bio-secures-e3-million-for-ai-drug-discovery-platform-htcomp26/)
  - [来源](https://www.sightera-biosciences.com/)
  - [来源](https://www.businessinantwerp.eu/en/innovators/sightera-biosciences)
- 投资/合作视角：Sightera 是典型“早、深、风险高但 upside 大”的 TechBio 标的，适合先做科学顾问评审与数据室跟进，而不是只看融资新闻。合作层面，若老板有药企/biotech BD 资源，可关注其 patient-derived screening 平台是否能为特定肿瘤或纤维化资产做联合 discovery；投资层面关键问题是样本/数据规模、SIGHT001 机制与可成药性、下一轮进入临床所需资金量。


---


### Sensesbit（西班牙 · FoodTech AI / 感官智能 SaaS）
- 一句话定位：Sensesbit 是 Lugo-based FoodTech SaaS 公司，把食品感官分析、统计学与 AI 结合，帮助食品饮料企业把消费者味觉/嗅觉/口感等感官数据转化为新品开发、质量与上市决策。
- 本周动态：2026-07-15，公司官网西语博客宣布完成 €1M 融资，用于欧洲与美洲国际扩张，并继续开发面向食品行业的 AI Sensory Intelligence 平台；2026-07-20，EU-Startups 与 The SaaS News 英文报道交叉验证该轮融资。投资方包括 Clave Capital、Eoniq Fund、WindOne Consultores、Paraíso Natural Ventures（Grupo Central Lechera Asturiana 推动的投资工具）。公司官网进一步披露已在 10+ 国家运营、服务 100+ recurring industrial clients，并计划 2026 年引入/扩展 agentic AI，用于分析大规模感官数据、识别模式、生成建议并帮助团队更快做出产品 go/no-go 决策。
- 产品深研：Sensesbit 的产品是面向食品行业的感官分析 SaaS，把过去高度依赖专家、人工流程和分散表格的 sensory analysis 数字化、标准化。平台将消费者/品评员数据、样本、属性、hedonic scales、研究设计等输入转化为统计证据，并通过“Data Booster”进行最高 10,000 次 bootstrapping 模拟，给出置信区间、排名稳定性、成对证据与风险判断。其 agentic sensory AI 不只是生成报告，而是结合 sensory science、统计、业务阈值（如 Tau value）、claim safeguards 与 generative executive insights，输出可辩护的 go/no-go 推荐；这使它区别于通用 ChatGPT/Claude 报告生成，也区别于传统只展示结果的感官分析工具。
- 融资记录：公开可核验融资主要为本周 €1M round；EU-Startups、The SaaS News 与公司官网均确认金额、用途与投资方，轮次未明确披露（The SaaS News 标注为 “Other”，部分数据站称 seed，但原文未正式定性）。公司为 USC 与 UNIRISCO 参与/支持的 joint venture，前身/关联 TasteLab 为 University of Santiago de Compostela spin-off，并长期从事食品饮料感官分析服务。估值未披露；AIFunding.me 搜索摘要给出 $7M 估算但非权威，按本轮 €1M 与未见独角兽信息纳入 < $1B 主清单。
- 创始人：EU-Startups 与公司官网披露 Sensesbit 由 University of Santiago de Compostela 研究组的四位科学家创立；公开报道中 CEO/co-founder 为 Maruxa Quiroga。Maruxa 的公开资料显示其为 Sensesbit & TasteLab CEO，拥有 Industrial Processes PhD，并在 AEPAS 任董事会成员；UNIRISCO 页面也显示 TasteLab CEO 为 Maruxa Quiroga。公司官网/UNIRISCO 强调其技术来自 USC 感官分析与消费者感知研究，拥有 20-25 年以上研究积累；这解释了为什么团队能把传统感官科学产品化为 SaaS，而不是从通用 AI 角度切入。
- 竞争力：Sensesbit 的优势在于垂直行业知识和已有工业客户基础：公司官网披露 10+ 国家与 100+ recurring industrial clients，说明它不是纯 MVP 阶段。食品企业新品失败成本高、感官测试频繁但数据分散，Sensesbit 若能沉淀跨品类/跨市场的感官-购买意愿模式，可能形成行业数据与流程黏性。风险在于：食品感官分析市场相对细分，客单价和扩张速度可能不如通用企业 SaaS；通用调研平台、消费者洞察公司、食品巨头内部研发数据平台都可能竞争；“agentic AI”需要证明 recommendations 能降低真实上市失败率，而不仅是提高报告效率。
- 赛道分析：FoodTech AI 在欧洲从替代蛋白、供应链、质量检测延伸到消费者洞察与产品研发决策。食品饮料公司面对高通胀、SKU 精简、健康化和本地化口味变化，越来越需要在上市前降低 sensory mismatch 风险。未来 1-2 年，食品研发中的 AI 会从配方生成和趋势洞察，扩展到“感官证据 + 业务决策”的闭环；Sensesbit 卡位在研发/质量/创新团队的高频工作流，若在欧洲和拉美形成标准平台，有机会成为食品行业的垂直决策智能层。
- 关键数据：€1M 本周融资（Sensesbit 官网 2026-07-15；EU-Startups 2026-07-20；The SaaS News 2026-07-20）；投资方 Clave Capital、Eoniq Fund、WindOne Consultores、Paraíso Natural Ventures（同上）；已在 10+ 国家运营、100+ recurring industrial clients（Sensesbit 官网 2026-07-15）；技术源自 USC 研究组，USC 与 UNIRISCO 参与，25+ 年感官分析与消费者感知研究转化为 SaaS（Sensesbit 官网 2026-07-15；UNIRISCO TasteLab 页面）；2025 年获 ftalks Food Summit Startup Awards 最具创新 startup 认可（Sensesbit 官网 2026-07-15）；agentic sensory AI 的 Data Booster 支持最高 10,000 simulations（Sensesbit agentic AI 页面）。
- 原文链接：
  - [来源](https://sensesbit.com/es/blog/sensesbit-ronda-financiacion-1m-expansion-internacional)
  - [来源](https://www.eu-startups.com/2026/07/spains-female-led-foodtech-startup-sensesbit-raises-e1-million-to-scale-its-ai-powered-sensory-intelligence-platform/)
  - [来源](https://www.thesaasnews.com/news/sensesbit-raises-1m-other/)
  - [来源](https://sensesbit.com/es/ia-sensorial-sensesbit)
  - [来源](https://www.unirisco.com/en/portfolio/tastelab/)
- 投资/合作视角：Sensesbit 适合关注“垂直 AI SaaS + 明确工业客户”的早期标的，尤其若老板有食品饮料、消费品或农业食品产业资源，可从合作试点切入验证其对新品成功率和研发周期的真实改善。投资上它可能不是爆发式基础模型公司，但有机会成为稳健的行业工作流 SaaS；需重点核验 ARR、留存、客单价、客户行业集中度和 agentic AI 是否带来提价能力。


---


### 🌏 新加坡+其他


### Whale（新加坡 · 企业 AI OS / 物理世界运营智能）
- 一句话定位：Whale 把门店、展厅、工厂等线下空间中的摄像头、传感器和语音数据接入 AI Operating System，用 Business World Model（BWM）把真实运营活动转成可审计、可执行的企业智能。
- 本周动态：2026-07-15（PRNewswire 发布日；DealStreetAsia 2026-07-16 跟进），Whale 宣布完成 $40M Series C3 extension，使 Series C 总额达到 $100M。此轮由 CMB International 旗下 AI/frontier tech 基金与 SMBC Asia Rising Fund 领投，Krungsri Finnovate、Singtel Innov8、Hyundai Motor Group、Charisma Partners 参投；此前 Series C 参与方包括 Bosch Ventures、MTR Lab、MDI Ventures、Gentree Fund、Linear Capital。公司称资金将用于扩大北美和 APAC 部署，并准备进入 MENA 与欧洲。来源：[来源](https://www.prnewswire.com/news-releases/whale-raises-40m-series-c3-extension-bringing-total-series-c-to-100m-to-scale-global-enterprise-ai-operations-302827069.html（2026-07-15)）；[来源](https://www.dealstreetasia.com/stories/singapore-enterprise-ai-startup-whale-raises-40m-more-in-series-c-489268（2026-07-16)）。
- 产品深研：Whale 的核心不是单点 AI 工具，而是面向企业运营的 AIOS，入口产品包括 SpaceSight（视频/IoT 空间智能）、Echo（销售与客服对话智能）、Lume（AI 内容分发）、Alivia（工作流自动化与智能代理）、Harbor（知识管理与合规）和 Novus（AI 基础设施与治理）。其关键技术路线是用专有 BWM 解释摄像头、传感器、音频等“物理世界信号”，类似 LLM 处理文本，再把 SpaceSight 与 Echo 的感知层信号流入代理、内容与治理模块形成“感知-认知-执行”闭环。与传统 BI、门店摄像头审计或客服质检工具相比，Whale 的差异在于覆盖物理空间 + 语音 + 内容 + agent workflow 的全栈，并已管理 600,000+ edge AI nodes，适合多门店、多国家、多业态企业用统一操作系统降本增效。本周融资新闻强调其从 APAC 向北美、MENA、欧洲扩张，说明产品已从区域化解决方案进入全球企业部署阶段。
- 融资记录：2017 年起源于杭州，2022 年将总部设在新加坡；2021 年曾完成 $50M Series B，Temasek 领投，NIO Capital、Linear、Alpha Startups 参投（DealStreetAsia 2026-07-16 回顾）。Series C1 于 2023 年完成，参与方含 Temasek 与 Linear Capital；2025-05 Series C2 引入 Bosch Ventures、MTR Lab、Singtel Innov8、MDI Ventures、Gentree Fund，C1+C2 合计 over $60M（Whale 官网公告 2025-05-20）。2026-07 Series C3 追加 $40M 后，Series C 总额达 $100M；估值未披露，但 DealStreetAsia 2025 年报道标题称其为“Singapore's $300m AI startup”，低于 $10 亿。资金用途：扩大 North America/APAC 部署，准备 MENA/Europe，扩张全球团队、深化企业合作和本地基础设施集成。来源：[来源](https://www.meetwhale.ai/Whale_Secures_60_Million_USD_to_Expand_its_Enterpr/1118.html（2025-05-20)）；[来源](https://www.dealstreetasia.com/stories/singapore-enterprise-ai-startup-whale-raises-40m-more-in-series-c-489268（2026-07-16)）；[来源](https://www.prnewswire.com/news-releases/whale-raises-40m-series-c3-extension-bringing-total-series-c-to-100m-to-scale-global-enterprise-ai-operations-302827069.html（2026-07-15)）。
- 创始人：创始人兼 CEO Jerry Ye 曾任 Meta 数据科学家，DealStreetAsia 称其负责过大规模机器学习基础设施相关工作；Whale 官网还写明其为 California Institute of Technology 毕业生。CTO Shukun Xie 拥有 Illinois Institute of Technology 计算机科学背景，曾在 Meta Feed Ranking Infrastructure and Machine Learning 团队担任 tech lead，具备分布式训练、实时推理和大规模推荐系统经验。这个团队适合做 Whale 的原因在于其问题本质是“企业级多模态数据基础设施 + 实时推理 + 大规模部署”，而非简单 SaaS 应用。
- 竞争力：最强信号是商业化与部署规模：PRNewswire 称其服务 1,600+ enterprises、45+ countries、600,000+ edge AI nodes；官网 2025 公告披露当时服务 600+ enterprise customers、20+ countries，说明一年内口径增长明显。技术护城河来自七年积累的 BWM、行业私有模型、跨设备边缘节点和企业工作流集成；渠道护城河来自 Singtel、SMBC、Hyundai、Krungsri/MUFG、MTR、Bosch 等战略投资人网络。风险在于：跨国线下部署交付重、行业差异大，和传统视频分析、语音质检、RPA/agent 平台、云厂商 IoT/AI 服务均有竞争；同时其“中国起源 + 新加坡总部 + 全球客户”的数据治理和合规复杂度需要持续关注。
- 赛道分析：企业 AI 正从“文本 copilots”走向“运营系统重构”，尤其零售、汽车、F&B、制造、金融服务等物理网点密集行业，痛点是人工巡检成本高、服务质量不稳定、线下数据结构化程度低。未来 1-2 年，VLM、多模态 agent、edge AI 与企业知识库会融合，赢家需要同时有模型能力、硬件/边缘部署能力和行业 workflow know-how。Whale 的卡位是 APAC 线下商业场景的 AI OS，如果能通过战略投资方进入金融、汽车、通信、交通网络，有机会成为“线下运营数据层”的区域龙头。
- 关键数据：$40M Series C3、Series C total $100M（PRNewswire，2026-07-15，[来源](https://www.prnewswire.com/news-releases/whale-raises-40m-series-c3-extension-bringing-total-series-c-to-100m-to-scale-global-enterprise-ai-operations-302827069.html)）；1,600+ enterprises、45+ countries、600,000+ edge AI nodes（同上，2026-07-15）；2021 $50M Series B（DealStreetAsia，2026-07-16，[来源](https://www.dealstreetasia.com/stories/singapore-enterprise-ai-startup-whale-raises-40m-more-in-series-c-489268)）；2025 C1+C2 over $60M、600+ customers、20+ countries、300,000+ stores、200M audit tasks annually、40M voice minutes/day、800M daily content views、7M AI requests/day、60+ fine-tuned private AI models、70% team in R&D（Whale 官网公告，2025-05-20，[来源](https://www.meetwhale.ai/Whale_Secures_60_Million_USD_to_Expand_its_Enterpr/1118.html)）；估值线索“$300m AI startup”（DealStreetAsia 标题，2025-05-20，[来源](https://www.dealstreetasia.com/stories/whale-temasek-440995)）。
- 原文链接：
  - [来源](https://www.prnewswire.com/news-releases/whale-raises-40m-series-c3-extension-bringing-total-series-c-to-100m-to-scale-global-enterprise-ai-operations-302827069.html)
  - [来源](https://www.dealstreetasia.com/stories/singapore-enterprise-ai-startup-whale-raises-40m-more-in-series-c-489268)
  - [来源](https://www.citybiz.co/article/875504/whale-extends-series-c-to-100-million-to-accelerate-global-enterprise-ai-expansion/)
  - [来源](https://www.meetwhale.ai/Whale_Secures_60_Million_USD_to_Expand_its_Enterpr/1118.html)
  - [来源](https://www.meetwhale.ai/)
  - [来源](https://www.dealstreetasia.com/stories/whale-temasek-440995)
- 投资/合作视角：对早期 AI 投资/合作来说，Whale 是“非 LLM、强落地、多模态运营智能”的代表，特别适合寻找 APAC/MENA 零售、汽车、金融网点数字化合作机会。风险是它已到 Series C 且融资额较大，纯早期财务投资窗口可能不便宜；更适合通过行业客户、渠道、区域合资或数据/边缘基础设施合作切入。


---


### Aina（印度/美国 · AI-native 消费硬件 / Agent 控制界面）
- 一句话定位：Aina 试图做“AI 时代的通用物理交互层”，用可感知上下文的硬件按钮/键盘/未来设备帮助用户触发 AI agents 与跨应用工作流，而不只是被动录音或记录。
- 本周动态：2026-07-16，TechCrunch 报道 Aina 宣布完成 $5.5M seed round；Inc42 2026-07-16/17 报道称公司从 stealth 中公开，融资约 ₹53 Cr，由 Redstart Labs（Info Edge India/Info Edge Ventures 相关投资平台）和 360 ONE Asset 共同领投，MIXI Global Investments、Antler、Blume Founders Fund 参投，天使投资人包括 WhatsApp 新任负责人 Kunal Shah、Razorpay 联合创始人 Harshil Mathur 与 Shashank Kumar、Scribd 创始人 Tikhon Bernstam、Better Capital 创始人 Vaibhav Domkundwar 等。Aina 官网在 2026-07-21 标注“Private pilot now open / Apply now”，与本周融资发布同步构成产品进入私测/候补阶段的动态。来源：[来源](https://techcrunch.com/2026/07/16/ultrahumans-former-hardware-vp-raises-5-5m-for-devices-that-control-ai-agents-not-just-record-you/（2026-07-16)）；[来源](https://inc42.com/buzz/aina-raises-5-5-mn-from-info-edge-ventures-360-one-asset-to-build-ai-native-interfaces/（2026-07-16/17)）；[来源](https://www.aina.com/（页面) published: 2026-07-21）。
- 产品深研：Aina 的产品假设是：生成式 AI 和 agents 能完成复杂任务，但手机、触屏、键盘、传统 GUI 仍迫使用户在多个 app 和菜单中手工导航，因此需要一个“捕捉人类选择 + 调用 agent”的新接口。公司此前以 Project Mirage 名义做 HCI 研究，CES 2026 展示过三个原型：Radiance（会议桌面遥控器，控制音量、麦克风、摄像头、AI notetaker、变声、入会等）、Shift（连接手机的单击 agentic button，可触发重复任务）、Dune（三键上下文感知 Mac macro keyboard）。早期测试后，Aina 发现 Dune 最受欢迎，因此先发 Dune：它会根据当前 app 改变按键功能，可控制会议麦克风/摄像头、运行快捷方式或脚本；公司同时把 Dune 反馈用于训练/定义更广义的 flagship AI-native interface。与 Plaud、Bee、Friend、Rabbit、Humane Pin 等“记录/陪伴/语音助手”硬件相比，Aina 明确强调 action-oriented、control/invoke agents，而不是被动 context capture；差异化在于 context-aware physical control + natural language workflow builder + 对电脑/手机跨应用动作的抽象。
- 融资记录：本周为公开可查的首轮机构融资：$5.5M seed（约 ₹53 Cr），时间 2026-07-16，Redstart Labs 与 360 ONE Asset 共同领投，MIXI Global Investments、Antler、Blume Founders Fund 参投，多位印度/全球互联网创业者天使跟投；估值未披露。资金用途包括将 flagship AI-native interface 推向市场、扩大 Bengaluru 与 San Francisco 的工程和产品团队、完成早期 pilot；Inc42 披露 Aina 当时约 35 名员工，并在 Bengaluru 有制造设施。未查到更早外部融资披露，故融资历史记录为“seed 之前未披露”。来源：[来源](https://techcrunch.com/2026/07/16/ultrahumans-former-hardware-vp-raises-5-5m-for-devices-that-control-ai-agents-not-just-record-you/)；[来源](https://inc42.com/buzz/aina-raises-5-5-mn-from-info-edge-ventures-360-one-asset-to-build-ai-native-interfaces/)；[来源](https://pulse2.com/aina-raises-5-5-million-to-develop-ai-hardware-interface-beyond-touchscreens-and-keyboards/)。
- 创始人：Aina 创始人 Apoorv Shankar 是前 Ultrahuman VP of Hardware；更早前他创办 LazyCo，做硬件交互设计，产品包括可控制手机等设备的 ring，LazyCo 于 2022 年被 Ultrahuman 收购。Shankar 在 Ultrahuman 参与消费硬件和制造能力建设三年以上，具备小型消费硬件、可穿戴、供应链/制造与交互设计经验。为什么是他做：AI 硬件失败案例很多，关键不只是模型，而是 form factor、用户触发意图、低摩擦交互和制造落地；Shankar 的履历正覆盖 HCI + consumer hardware + 印度制造 + AI agent 早期需求探索。
- 竞争力：Aina 的优势在于切入点更具体——不是宣称替代手机，而是先从可验证的“控制 agents/workflows”物理入口切入，并用 Dune 的数百台早期出货学习真实任务需求。投资人组合也有信号价值：Info Edge/Redstart、360 ONE、Antler、Blume Founders Fund 与 Kunal Shah、Razorpay founders 等能提供印度消费互联网、硬件、支付与分发网络。挑战同样明显：AI 硬件赛道拥挤，Rabbit、Humane、Meta Ray-Bans、Plaud、Bee、Friend、Sandbar、Pocket、OpenAI/Work Louder keypad 等都在争夺新交互形态；硬件毛利、退货、供应链、隐私与“用户到底愿不愿多带一个设备”是核心风险。
- 赛道分析：AI agents 的能力提升正在制造“输入/控制层”的空缺：纯聊天框适合生成内容，但不适合高频、多应用、需要确认和权限边界的日常动作。未来 1-2 年，AI hardware 很可能从“全天候记录”分化出“专用控制器/确认器/安全授权器”路线，尤其面向开发者、知识工作者、会议重度用户和移动端高频服务。Aina 的位置介于消费电子与 productivity hardware 之间，若能建立跨 app action schema、权限确认体验和开发者生态，有机会成为 agentic workflow 的物理入口；若只是宏键盘升级，则 TAM 会受限。
- 关键数据：$5.5M seed（TechCrunch，2026-07-16，[来源](https://techcrunch.com/2026/07/16/ultrahumans-former-hardware-vp-raises-5-5m-for-devices-that-control-ai-agents-not-just-record-you/)）；约 ₹53 Cr、35 employees、Bengaluru + San Francisco、Bengaluru manufacturing facility、Founded in 2025、Dune launched in April 2026、shipped hundreds of units、India wearable AI market $3.17B in 2026 and forecast $19.1B by 2033、India AI hardware market expected $46.5B by 2033 / CAGR 28.1%（Inc42，2026-07-16/17，[来源](https://inc42.com/buzz/aina-raises-5-5-mn-from-info-edge-ventures-360-one-asset-to-build-ai-native-interfaces/)）；incorporated in May 2025、CES 2026 three prototypes、private pilot/waitlist（Pulse2，2026-07-18/19，[来源](https://pulse2.com/aina-raises-5-5-million-to-develop-ai-hardware-interface-beyond-touchscreens-and-keyboards/)；官网 published 2026-07-21，[来源](https://www.aina.com/)）。
- 原文链接：
  - [来源](https://techcrunch.com/2026/07/16/ultrahumans-former-hardware-vp-raises-5-5m-for-devices-that-control-ai-agents-not-just-record-you/)
  - [来源](https://inc42.com/buzz/aina-raises-5-5-mn-from-info-edge-ventures-360-one-asset-to-build-ai-native-interfaces/)
  - [来源](https://pulse2.com/aina-raises-5-5-million-to-develop-ai-hardware-interface-beyond-touchscreens-and-keyboards/)
  - [来源](https://www.aina.com/)
- 投资/合作视角：Aina 是一个适合早期观察的“AI 交互层”标的，投资信号是创始人硬件履历强、融资小而高质量、产品假设明确。合作上可从开发者工具、企业会议、支付/本地服务 action、设备制造链切入；最大风险是 AI 硬件 category 尚未证明 PMF，需重点看 pilot 留存、复购、单位经济和实际被触发的 agent 任务频次。


---


### Think（沙特阿拉伯 · 主权 AI 基础设施 / GPU 编排硬件软件）
- 一句话定位：Think 用液冷多 GPU compute nodes + 裸金属 orchestration 软件 ILM，帮助企业和政府在本地/私有环境中更高效、更低成本地部署、训练和推理 AI 模型，主打 sovereign AI infrastructure。
- 本周动态：2026-07-15，Think 宣布完成 over $8M pre-seed funding，并称这是 MENA 迄今最大的 AI infrastructure and deeptech pre-seed round。该轮由 RAED Ventures 和 Wa'ed Ventures 共同领投，Dhahran Techno Valley 的 VC arm 与战略天使投资人参与；资金将用于团队扩张、制造放量、产品开发、在沙特的商业部署以及 GCC 和部分国际市场扩张。公司公告称其已在沙特进行多个 POC、production deployments 和 strategic partnerships，并参与包括 HUMAIN 在内的沙特 AI 生态。来源：[来源](https://www.prnewswire.com/news-releases/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million-302825409.html（2026-07-15)）；[来源](https://raed.vc/news/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million/（2026-07-15)）；[来源](https://lucidityinsights.com/news/ai-startup-think-raises-us8m-pre-seed（2026-07)）。
- 产品深研：Think 的核心产品由两层组成：一是高密度、液冷、多 GPU 的 AI Node/Supernode 硬件，二是 ILM（hardware-aware AI orchestration platform / bare-metal orchestration software），根据实时 VRAM、LLM workload 和热 telemetry 动态分配 GPU 工作负载。官方称平台使用现成、广泛可得 GPU，不要求专有推理芯片；未来将支持 mixed-vendor 和 specialist inferencing silicon 协同用于训练和推理。与直接购买云端 frontier model API 或建设传统数据中心相比，Think 强调在现有 GPU 上提高利用率、降低 per-million-token cost，并把安全、隐私、数据主权和 CAPEX/ROI 逻辑打包给政府、企业、实验室和边缘环境。本周官网还强调“Office by day, Supercompute cluster by night”的 Constellation 概念，说明其尝试把分散办公/边缘计算资源整合成夜间超算集群。
- 融资记录：公开记录显示本轮为 pre-seed：over $8M，时间 2026-07-15，co-led by RAED Ventures and Wa'ed Ventures，Dhahran Techno Valley's VC arm 与战略天使参与；估值未披露。The SaaS News 2026-07-20 复核了 Funding Date: July 15, 2026、Raised: $8M、Round: Pre-seed、Lead Investor: RAED Ventures, Waed Ventures、Additional Investors: Dhahran Techno Valley。资金用途包括 team expansion、manufacturing scale-up、product development、commercial deployments across Saudi Arabia、GCC expansion、selected international markets、继续开发 ILM standalone software platform。未发现更早融资披露。来源：[来源](https://www.thesaasnews.com/news/think-raises-8m-pre-seed/（2026-07-20)）；[来源](https://www.prnewswire.com/news-releases/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million-302825409.html（2026-07-15)）。
- 创始人：Think 由 Ahmed AlSharif 与 Ammar Enaya 创立。Ahmed AlSharif 的职业经历包括 Meta、Sony PlayStation Europe 和 EA Games，兼具大规模消费者/游戏平台和技术领导经验；Ammar Enaya 是企业技术老兵，曾在 Cisco、HPE Aruba、Vectra AI 担任领导职位，熟悉企业网络、基础设施与安全销售/交付。为什么是他们做：Think 的客户不是个人开发者，而是政府、企业和主权 AI 项目，既需要硬件/系统工程，也需要企业级部署、网络安全、合规和本地化交付能力；两位创始人的游戏/大规模计算与企业基础设施背景形成互补。
- 竞争力：Think 的核心卖点是效率和主权：官方披露 production benchmark sustained GPU utilisation >90%，高于 industry averages 30–50%，并声称 per-million-token cost 接近 Google/OpenAI/Anthropic frontier models 平均成本的 1/10。其竞争力还来自沙特本地窗口：Vision 2030、HUMAIN、政府数字化和数据主权需求为本土 AI 基础设施提供政策与客户牵引；投资方 RAED、Wa'ed（Aramco 旗下 VC）和 DTV 能带来本地产业网络。风险包括：benchmark 需第三方验证；硬件制造和液冷部署资本开支大；与 NVIDIA ecosystem、云厂商私有云、CoreWeave/Crusoe 等 GPU 云、区域数据中心和开源编排栈竞争；此外 pre-seed 阶段商业交付能力仍需验证。
- 赛道分析：AI 基础设施正从“买更多 GPU”转向“提高利用率、降低能耗、满足主权部署”。中东尤其是沙特和阿联酋在 AI 数据中心、主权模型、国家 AI 平台上投入巨大，但对外部 hyperscale cloud 的依赖、数据出境和单位推理成本是痛点。未来 1-2 年，主权 AI 基础设施会在政府、金融、能源、科研和大型企业形成采购潮，技术趋势包括液冷、GPU 池化、裸金属编排、混合 accelerator 和边缘/办公室资源聚合。Think 卡位早、叙事贴合国家战略，但必须证明在真实生产 workload 下的可靠性、TCO、生态兼容和规模化制造。
- 关键数据：over $8M pre-seed、2026-07-15 announcement、MENA largest AI infrastructure and deeptech pre-seed（PRNewswire/RAED，2026-07-15，[来源](https://www.prnewswire.com/news-releases/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million-302825409.html)；[来源](https://raed.vc/news/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million/)）；GPU utilisation >90% vs industry averages 30–50%、per-million-token cost almost 10x lower than average cost of frontier models from Google/OpenAI/Anthropic（同上）；GCC expansion over next 18 months、multiple POCs/production deployments/strategic partnerships in Saudi Arabia（同上）；RAED Ventures >$550M AUM、Wa'ed Ventures $500M institutional VC wholly owned by Aramco、Wa'ed portfolio 100+ startups、DTV 15+ multinational research centres/65 deep-tech startups/20+ Fortune Global 500 collaborators（PRNewswire，2026-07-15）；The SaaS News 复核 Raised $8M / Funding Date July 15, 2026 / Lead RAED & Waed / Additional Dhahran Techno Valley（[来源](https://www.thesaasnews.com/news/think-raises-8m-pre-seed/)，2026-07-20）。
- 原文链接：
  - [来源](https://www.prnewswire.com/news-releases/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million-302825409.html)
  - [来源](https://raed.vc/news/think-closes-menas-largest-ai-infrastructure-pre-seed-round-at-over-8-million/)
  - [来源](https://lucidityinsights.com/news/ai-startup-think-raises-us8m-pre-seed)
  - [来源](https://www.thesaasnews.com/news/think-raises-8m-pre-seed/)
  - [来源](https://www.think-ai.com/)
- 投资/合作视角：Think 是中东主权 AI 基础设施里非常早期但信号强的标的，适合关注政府/能源/金融客户落地和本地数据中心合作。投资上需要严查技术 benchmark、硬件 BOM、供应链、客户 POC 转生产的周期；合作上可考虑模型私有化部署、GPU 资源优化、液冷数据中心、边缘 AI 节点和沙特/GCC 市场进入。


---


### Oak（以色列/美国 · AI-native 身份安全 / IAM for AI agents）
- 一句话定位：Oak 是面向 AI agent 时代的 Identity Operating System，用统一实时身份图谱治理 human、machine 与 AI agent identities，替代碎片化 IAM/IGA/identity security 工具栈。
- 本周动态：2026-07-15，Oak 从 stealth 公开，并宣布获得 $60M seed funding；TechCrunch 同日/本周报道其产品已 generally available 且已部署在 enterprise clients。融资由 Accel、Greylock Partners、CRV 共同领投，Hetz Ventures、AlphaDrive Ventures 和战略天使参与。Oak 同时表示将在 2026 年 8 月 Black Hat USA 展示技术（Booth 4203）。来源：[来源](https://www.prnewswire.com/news-releases/oak-raises-60m-in-seed-funding-to-build-the-ai-native-identity-operating-system-302826349.html（2026-07-15)）；[来源](https://techcrunch.com/2026/07/15/backed-by-60m-in-funding-oak-steps-out-of-stealth-to-fix-the-identity-mess-that-ai-agents-are-making-worse/（2026-07-15)）；[来源](https://www.thesaasnews.com/news/oak-raises-60m-seed/（2026-07-16)）。
- 产品深研：Oak 的产品目标是把身份发现、治理、风险决策和修复放到一个持续更新的 control plane 中，而不是由多个季度审计、权限目录、IGA、PAM、NHI 工具拼接。官网称其“born complete”，一个 data model/graph 覆盖 human、machine、AI agent identities，并能连接 on-prem、cloud、SaaS、homegrown applications；PRNewswire 披露其 AI connector framework 能在数小时内构建新 connector，而 legacy systems 可能需要数月。技术路线是从 raw evidence 构建 live identity graph，再把每个 identity 拥有的 access 与实际 usage 映射，做 real-time risk decisions 和 root-cause remediation；TechCrunch 补充其会把访问映射到真实 app usage，并实时移除不再需要的权限。与 Okta/SailPoint/CyberArk/Saviynt 等传统身份厂商相比，Oak 的差异化叙事是 AI-native、覆盖 AI agents/non-human identities、从第一天做统一图谱与自动 remediation，而不是给旧平台加 AI 插件。
- 融资记录：公开可查融资为 $60M seed，时间 2026-07-15；co-led by Accel, Greylock Partners, CRV；Hetz Ventures、AlphaDrive Ventures、strategic angel investors 参投；估值未披露。TechCrunch 指出这笔 seed by local standards 很大，且 Oak 在 2025 年底已悄悄筹到该资金、2026-07 产品 GA 时正式公开；The SaaS News 复核 Funding Date: July 15, 2026、Round: Seed、Lead Investor: Accel/Greylock/CRV。资金用途包括扩充 security 与 AI 专家团队、构建完整平台，TechCrunch 还披露公司隐身期已建立 50 人团队，并正在招聘，尤其是美国团队。来源：[来源](https://www.prnewswire.com/news-releases/oak-raises-60m-in-seed-funding-to-build-the-ai-native-identity-operating-system-302826349.html)；[来源](https://techcrunch.com/2026/07/15/backed-by-60m-in-funding-oak-steps-out-of-stealth-to-fix-the-identity-mess-that-ai-agents-are-making-worse/)；[来源](https://www.thesaasnews.com/news/oak-raises-60m-seed/)。
- 创始人：CEO/联合创始人 Shai Morag 是连续网络安全创业者，在安全领域超过 20 年，曾创办并出售三家公司：Integrity-Project 于 2014 年被 NVIDIA Mellanox 收购，Secdo 于 2018 年被 Palo Alto Networks 收购，Ermetic（cloud identity/security）于 2023 年被 Tenable 以 $265M 收购，随后他在 Tenable 任 CPO。联合创始人/CPO Tal Marom 曾在 Tenable 与 Salesforce 领导产品团队，也有以色列军方产品/技术背景（TechCrunch 提及）。为什么是他们做：identity security 的销售和产品复杂度极高，需要理解 CISO、IAM leader、企业权限模型与组织采购；Morag 的 Ermetic/云身份经验和连续退出记录显著降低了早期执行风险。
- 竞争力：最强信号是团队和资本：Accel 曾领投 Ermetic Series A，Tenable 收购后 Accel 对 Morag 有“下一个项目继续支持”的站位；Greylock、CRV 共同领投 $60M seed 表明美国顶级基金认为 identity stack 在 AI agent 时代会重构。产品层面，Oak 已 GA 且有企业客户部署，并在隐身期访谈 100+ CISOs and IAM leaders，验证痛点包括工具过多、无法看见 access usage、无法治理 AI agents。风险在于身份安全是巨头和成熟独角兽密集区，现有 Okta、Microsoft Entra、SailPoint、CyberArk、Saviynt、Wiz/CNAPP/NHI 新厂商都可能扩张；Oak 需证明 connector 覆盖、低误报、自动 remediation 安全性和迁移成本优势。
- 赛道分析：AI agents 和 machine identities 的爆发让身份成为新的攻击面：API tokens、service accounts、agent permissions、MCP/tool access 都会让传统以人为中心的 IAM/IGA 模型失效。未来 1-2 年，企业会从静态权限审批转向 continuous identity intelligence：实时身份图谱、权限使用行为、最小权限自动收敛、AI agent 行为治理和 incident response 联动。Oak 卡位为“identity OS”，如果能成为 AI agent 权限与生命周期的底层图谱，就可能在现有 IGA/IAM 工具之上形成控制面；但 category 仍早，需防止产品范围过大导致交付周期变长。
- 关键数据：$60M seed、co-led by Accel/Greylock/CRV、Hetz Ventures/AlphaDrive/angels 参投（PRNewswire，2026-07-15，[来源](https://www.prnewswire.com/news-releases/oak-raises-60m-in-seed-funding-to-build-the-ai-native-identity-operating-system-302826349.html)）；100+ CISOs and IAM leaders 访谈、connectors built in hours vs months、产品 GA and deployed across enterprise customers（PRNewswire，2026-07-15；TechCrunch，2026-07-15）；50-person team and hiring, majority of staff soon U.S.-based（TechCrunch，2026-07-15，[来源](https://techcrunch.com/2026/07/15/backed-by-60m-in-funding-oak-steps-out-of-stealth-to-fix-the-identity-mess-that-ai-agents-are-making-worse/)）；Ermetic acquired by Tenable for $265M in 2023（TechCrunch，2026-07-15）；Gartner/PwC 引用：identity as primary attack vector、by 2028 70% of CISOs will adopt identity visibility and intelligence capabilities（PRNewswire，2026-07-15，引用链接见原文）。
- 原文链接：
  - [来源](https://www.prnewswire.com/news-releases/oak-raises-60m-in-seed-funding-to-build-the-ai-native-identity-operating-system-302826349.html)
  - [来源](https://techcrunch.com/2026/07/15/backed-by-60m-in-funding-oak-steps-out-of-stealth-to-fix-the-identity-mess-that-ai-agents-are-making-worse/)
  - [来源](https://www.oak.id/)
  - [来源](https://pulse2.com/oak-raises-60-million-in-seed-funding-to-build-the-ai-native-identity-operating-system/)
  - [来源](https://www.thesaasnews.com/news/oak-raises-60m-seed/)
- 投资/合作视角：Oak 是本周最强“全球榜单新秀/顶级基金背书”信号之一，适合关注 AI agent security、non-human identity、企业 IAM 重构。投资风险是 seed 金额巨大、创始人溢价高、估值虽未披露但可能不低；合作上可从 CISO 渠道、AI agent 平台、MCP/tool governance、云安全集成和身份数据图谱互补切入。

---

## 📋 关于本周报

- **研究对象**：本周窗口内有真实融资、产品发布、重大客户/营收里程碑、榜单/公开发布等动态的全球 AI 创业公司，主清单估值口径为 < $10 亿。
- **地域口径**：美国与中国为硬下限，各不少于 5 家；欧洲、以色列、新加坡、印度、沙特等作为全球补充样本。
- **信息校验**：18 对象 / 128 数据点 / 27 结论 / 90 链接（去重后），全量对应 ✅。
- **下期预告**：继续追踪早期 AI 公司从“模型能力展示”转向“系统级交付”的融资与产品信号，尤其关注 Agent 安全、物理 AI、医疗/工业高合规场景与主权 AI 基础设施。
