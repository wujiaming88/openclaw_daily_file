# 全球AI创业公司研究周报 · 第 9 期（2026-07-29～2026-08-04）

- 发布日期：2026-08-05
- 覆盖区间：2026-07-29 00:00 → 2026-08-04 24:00（Asia/Shanghai）
- 覆盖公司：美国 6 家 / 中国 6 家 / 其他 6 家，合计 18 家
- 研究口径：仅纳入估值 < 10 亿美元，或估值未披露但按融资阶段/总融资额/公开描述推断未达独角兽的 AI 创业公司；估值未知均不作确定估值。
- 头图：/assets/images/posts/2026-08-05-global-ai-startup-weekly-header.png

## 四维质量门控自检

- 覆盖率：美国 6 家 / 中国 6 家 / 其他 6 家，合计 18 家；美国、中国均满足 ≥5 家硬下限。
- 原文深度：随机抽查 Polar Browser、Aavalynx、Sigvi、Smallest.ai、丘脑智能共 5 家，原始/近原始来源均可访问且融资金额、日期、产品描述与笔记一致，5/5 通过。
- 五维完整：18/18 家均包含产品深研、融资记录、创始人、竞争力、赛道分析、关键数据、原文链接与投资/合作视角。
- 数据可信：融资额、轮次、创始人背景、客户/增长数据均附来源；估值未披露者均标注未披露并按阶段推断，不作确定估值；Onyx Security 估值约 6.4 亿美元，仍低于 10 亿美元；独角兽/大厂已排除。
- 信息校验：18 对象 / 120+ 关键数据点 / 18 项投资判断 / 去重 79 个来源链接，全部对应。

## 本周一句话

> 本周 AI 创业投资的主线从“模型更强”转向“AI 能安全、可审计地接管真实流程”：企业 Agent、安全控制面、垂直运营 AI 与具身智能，都在用可量化 ROI 证明下一阶段价值。

## 🔥 本周 TOP 5 创业公司

### 1. Onyx Security（以色列/美国 · AI Agent 安全控制平面）
- 一句话定位：Onyx Security 为企业提供 secure AI control plane，用于发现、治理、审计并实时控制 SaaS、云、终端和代码环境中的 AI agents、模型和 AI 应用。
- 本周动态：2026-07-29，公司博客宣布完成 1.13 亿美元 Series B，Bessemer Venture Partners 领投，Cyberstarts、TCV、Conviction、FirstMark、Vintage Investment Partners、QuantumLight、G Squared 参投；The SaaS News 2026-07-30 交叉确认总融资 1.53 亿美元，Calcalist/CTech 标题披露估值约 6.4 亿美元，低于 10 亿美元门槛。公司称自四个月前出 stealth 后收入翻 4 倍，并已保护 110 万+ agents、实时检查 6,620 万+ AI sessions。
- 产品深研：Onyx 的核心产品是 Secure AI Control Plane：持续发现企业内的 agents、models、AI-powered applications、MCP-connected tool ecosystems，并把治理策略转成 runtime enforcement。其 Onyx Guardian Agent 作为监督 AI，可以在动作进入下游系统前阻止高风险行为、要求人工审批、缩小 agent 权限范围或重定向到更安全路径。官网强调覆盖 SaaS、Cloud、Endpoint、Code 四类表面，常见用例包括 AI marketing/customer service/business operations、公司自建 agentic applications、模型托管、聊天机器人、coding agents、个人助手和自定义应用中的 AI 组件；这意味着它不是单一 DLP，而是为 agentic era 做“身份、权限、行为、审计”统一层。
- 融资记录：公开轮次包括 2026-03 出 stealth 时宣布 4,000 万美元融资，来自 Conviction Partners 与 Cyberstarts，媒体披露由 500 万美元 seed 与 3,500 万美元 Series A 组成；2026-07-29 完成 1.13 亿美元 Series B，Bessemer Venture Partners 领投，Cyberstarts、TCV、Conviction、FirstMark、Vintage、QuantumLight、G Squared 参投。总融资约 1.53 亿美元；本轮估值约 6.4 亿美元，符合估值 <10 亿美元要求。
- 创始人：公司由 Maxim Bar Kogan 与 Gil Elbaz 创立，官网列 Maxim 为 CEO & Co-Founder、Gil 为 Chief AI Officer & Co-Founder。Onyx 出 stealth 博客中 Maxim 写到自己职业生涯长期在 AI 与 offensive cyber 交叉领域，主要在以色列 IDF Unit 8200；Gil 是 AI architect，曾在现代 AI 前沿系统上工作，最近与 Nvidia CTO 团队领导 agentic AI 工作。团队规模方面，Onyx 2026-03 出 stealth 时已约 70 人，强调 AI researchers 与 security researchers 混合配置。
- 竞争力：Onyx 的核心竞争力在于抓住企业 agent 爆发后的“可见性 + runtime control”空白：传统安全工具处理的是确定性软件和人类驱动流程，而 agents 在浏览器、终端、SaaS、云之间以非确定性方式调用工具和访问敏感数据，风险难以用旧 IAM/DLP/EDR 单独覆盖。公司披露已保护 110 万+ agents、覆盖 180 万+ employees、分析 6,620 万+ sessions，这些规模数据说明它已不只是概念 demo。风险在于云安全、SaaS security posture、identity、DLP、browser security、AI gateway 厂商都会向 AI agent governance 延展；此外估值已达 6.4 亿美元，后续需用收入留存和平台深度证明不是短期安全热点。
- 赛道分析：随着企业从 copilots 进入 autonomous agents，安全问题从“谁能访问哪个应用”升级为“一个 agent 在什么上下文下能替人做哪些不可逆动作”。能源、金融、医疗等关键基础设施行业尤其需要实时审批、行为拦截、审计和权限收敛，因为错误动作可能引发系统中断、市场事件或生命风险。未来 1-2 年，AI agent security/control plane 可能成为独立安全预算项，也可能被现有 CSPM/SSPM/IAM/SASE 平台并购整合；早期赢家需要跨 SaaS、cloud、endpoint、code 建立足够深的 telemetry 和 policy enforcement，才能成为真正的控制面。
- 关键数据：1.13 亿美元 Series B（Onyx 官方，2026-07-29）；总融资 1.53 亿美元（The SaaS News，2026-07-30）；估值 6.4 亿美元（Calcalist/CTech 标题，2026-07-30）；此前 4,000 万美元融资，含 500 万美元 Seed 与 3,500 万美元 Series A（Onyx 出 stealth 博客及媒体，2026-03）；110 万+ agents secured、180 万+ employees covered、6,620 万+ sessions analyzed（Onyx 官网/博客，2026-07-29）；团队约 70 人（Onyx 出 stealth 博客，2026-03）。
- 原文链接：[onyx.security](https://www.onyx.security/blog/onyx-113m-series-b-keeping-humans-in-control-as-ai-becomes-smarter)；[onyx.security](https://www.onyx.security/)；[onyx.security](https://www.onyx.security/about)；[onyx.security](https://www.onyx.security/blog/introducing-onyx-security-the-secure-ai-control-plane-for-enterprises)；[thesaasnews.com](https://www.thesaasnews.com/news/onyx-security-raises-113m-series-b/)；[calcalistech.com](https://www.calcalistech.com/ctechnews/article/b1fsjydszg)
- 投资/合作视角：Onyx 是本周窗口内最强的 AI 安全融资信号之一，估值仍低于 10 亿美元但融资规模和客户覆盖已接近准独角兽；适合从安全生态合作、AI governance 产品集成、关键行业客户 PoC 角度跟踪。风险是赛道竞争和估值前置，若收入增长无法持续 4x 或被平台厂商快速商品化，下一轮空间会受压。
- 为何关注：AI Agent 安全控制面已经从概念变成独立预算项，Onyx 在低于独角兽门槛时拿到 1.13 亿美元 Series B、6.4 亿美元估值和百万级 agent 覆盖，是安全生态合作和投资跟踪的最高信号。

---

### 2. Freehand（美国/印度创始团队 · 企业供应链支出管理 AI Agents）
- 一句话定位：Freehand 为 Fortune 500 企业构建自治 AI Teams，接管供应链支出中的采购、供应商管理、发票核对、付款、合同合规与数据对账等复杂流程。
- 本周动态：2026-07-29，Freehand 官方宣布完成 7,500 万美元融资，由 Battery Ventures 与 NewRoad Capital Partners 共同领投，PSP Growth（由美国前商务部长 Penny Pritzker 支持/领导的基金）、Nexus Venture Partners 等参投；Inc42 在同周确认该轮融资并披露公司由 Pando 联合创始人 Nitin Jayakrishnan 与 Abhijeet Manohar 创立。公司称其 AI Agents 已在 Meta、Unilever、Johnson & Johnson、Dunkin’、Pfizer、Cardinal Health 等客户部署。来源：[freehand.ai](https://www.freehand.ai/press-release/freehand-raises-75m-to-scale-ai-teams-managing-supply-chain-spend-for-fortune-500-companies（2026-07-29)）；[inc42.com](https://inc42.com/buzz/freehand-raises-75-mn-to-expand-enterprise-ai-platform/（2026-07-29/本周)）。
- 产品深研：Freehand 切入的第一个深水区是供应链 spend 中最耗人工的发票检查与支付闭环：系统读取合同、与供应商谈判、发现 leakage、处理付款、再把结果同步给采购和财务系统。其核心 IP 是 Category Context Graph，把合同、政策、历史交易、异常、沟通渠道中的非结构化信息与 ERP/采购系统里的结构化数据统一，给 agent 提供类似资深供应链专家的上下文，并保留可审计的决策轨迹。Freehand 官网强调“AI does the job and shows its work”，即不只给异常提示，而是在客户定义的 guardrails 内 audit、resolve、close；这与传统采购 SaaS/外包 BPO 的差异在于软件本身成为执行者。
- 融资记录：本周官方披露 7,500 万美元融资/报道口径称 Series B（Crunchbase 搜索结果写 Series B，并称总融资 1 亿美元；AI Weekly 搜索结果亦称本轮使累计融资达 1 亿美元），Battery Ventures、NewRoad Capital Partners 共同领投，PSP Growth、Nexus Venture Partners 等参投；若按累计 1 亿美元倒推，此前约有 2,500 万美元融资，但具体轮次、日期和估值公开资料有限。估值未披露；公开报道未见 ≥10 亿美元估值证据，按本任务要求纳入。来源：Freehand 官方新闻稿（2026-07-29）、Inc42（2026-07-29/本周）、Serper 搜索结果指向 Crunchbase News/AI Weekly（2026-07-29）。
- 创始人：Freehand 由 Nitin Jayakrishnan 与 Abhijeet Manohar 创立，二人此前共同创立 Pando，Pando 是企业物流/供应链 SaaS 平台；官方新闻稿明确写到 Nitin 曾 built and sold Pando，Inc42 也称两人是 Pando cofounders。Nitin 现任 co-founder and CEO，提出企业每年在供应链软件上花 160 亿美元、又花 3,480 亿美元雇人做软件做不了的事；Abhijeet 强调从“为用户做软件”转向“软件就是用户”，agent 与 chatbot 的差别在于上下文。这个连续创业背景让团队天然理解大型企业供应链的系统集成、异常处理和采购周期。
- 竞争力：Freehand 的护城河在“高价值垂直场景 + 大客户生产部署 + 可审计上下文图谱”。供应链 spend 管理非常复杂，合同条款、供应商例外、税费/关税、物流、付款条款都高度非结构化，通用 agent 很难安全执行；Freehand 用 Category Context Graph 形成专用知识与审计轨迹，适合 Fortune 500 级客户的风控要求。客户指标强：官方披露早期部署可在复杂采购类别中追回 5-10% spend、工作流完成速度提升 5-7 倍、procure-to-pay 周期缩短 70% 以上；Unilever 全球供应链 VP 的引用说明它已进入核心流程。主要风险是企业采购/集成周期长、结果归因复杂、以及 SAP/Oracle/Coupa/ServiceNow/Microsoft 等平台可能把 agentic workflow 向内延伸。
- 赛道分析：企业 agentic AI 的下一波价值不在写邮件或总结会议，而在能直接影响现金流和成本结构的运营流程；供应链支出管理是典型高 ROI 场景，因为大企业每年在原材料、物流、数据中心、服务采购上支出巨大，哪怕减少少量 overpayment 都足以覆盖软件费用。官方引用美国 BEA 数据称美国公司每年在相关原材料、物流、数据中心和服务上花费超过 20 万亿美元，说明总市场空间足够大；而关税、税务、移民政策等变化正在削弱传统外包运营模式。未来 1-2 年，赛道会从采购 copilot 转向可执行、可审计、可追责的 AI operator，垂直图谱和真实客户工作流数据将成为关键资产。
- 关键数据：7,500 万美元融资（Freehand 官方，2026-07-29）；投资方 Battery Ventures、NewRoad Capital Partners、PSP Growth、Nexus Venture Partners 等（Freehand 官方/Inc42，2026-07-29）；客户 Meta、Unilever、Johnson & Johnson、Dunkin’、Pfizer、Cardinal Health（Freehand 官方，2026-07-29）；客户节省 5-10% spend、流程 5-7x 更快、procure-to-pay 周期缩短 70%+（Freehand 官方，2026-07-29）；美国公司每年相关供应链/运营支出超过 20 万亿美元、供应链软件 160 亿美元、人力 3,480 亿美元（Freehand 官方引用，2026-07-29）；估值未披露，未见 ≥10 亿美元证据。
- 原文链接：
  - [freehand.ai](https://www.freehand.ai/press-release/freehand-raises-75m-to-scale-ai-teams-managing-supply-chain-spend-for-fortune-500-companies)
  - [freehand.ai](https://www.freehand.ai/about-us)
  - [inc42.com](https://inc42.com/buzz/freehand-raises-75-mn-to-expand-enterprise-ai-platform/)
  - [finance.yahoo.com](https://finance.yahoo.com/technology/ai/articles/freehand-raises-75m-scale-ai-130000037.html)
- 投资/合作视角：Freehand 是本周最有“企业 AI 从建议走向执行”代表性的公司之一，客户质量和 ROI 数据非常强，若估值仍未过高，值得列入供应链/企业运营 AI 重点跟踪。合作上可从制造、零售、医药、物流客户引入 PoC；风险是大客户依赖度、长周期实施和与现有 ERP/采购系统的权限边界。
- 为何关注：企业 AI 的价值正在从建议走向执行，Freehand 直接切供应链支出、发票、合同和付款闭环，客户质量与 ROI 数据强，代表 AI operator 进入现金流核心流程。

---

### 3. 破壳机器人 PokeBot（中国 · 家庭具身智能/AI硬件）
- 一句话定位：清华系通用具身智能公司，瞄准家庭服务场景，用世界动作模型、真机强化学习和真实数据闭环打造能“进家干活”的机器人。
- 本周动态：2026年8月3日，破壳机器人宣布完成亿美元级Pre-A轮融资；证券时报、北京商报/新浪、财新、中国基金报/新浪等均报道本轮由顺为资本与经纬创投共同领投，多家财务及产业资本参与，云启资本、小米战投等老股东持续加注。中国基金报还披露公司计划8月底至9月初推出首款硬件产品，聚焦物体传递、收纳、精细清洁等10件核心家务任务，预计万元级起步。
- 产品深研：破壳机器人聚焦家庭等服务类环境中的高灵巧、长时序复杂任务，试图从厨房、收纳、清洁等非结构化场景切入通用操作能力。其技术体系由WAM（世界动作模型）、RL（全链路真机强化学习）和DATA（高质量真实世界数据）三条链路构成：WAM建模动作与环境变化的物理因果关系，RL让机器人从真实交互成败经验中持续学习，DATA通过自研精细操作数据采集设备降低高质量数据门槛，形成“采集—基础模型训练—真机强化学习—新数据回流”闭环。2026年6月公司发布9分钟全自主真机演示，机器人独立完成麻婆豆腐全流程制作，还展示叠衣服、穿扎带、系香囊等精细家务动作，用真实长时序任务验证规划、力控、双臂协同和现场抗干扰能力。
- 融资记录：公司2026年3月/4月成立（不同媒体口径略有差异，财新和北京商报均称成立于2026年4月，智东西称2026年3月），4月完成数千万美元天使轮，由云启资本领投，顺为资本、弘晖基金、小米战投、星海图、BV百度风投、英诺天使基金、水木清华校友种子基金、东方嘉富等参与。2026年8月3日完成亿美元级Pre-A轮，由顺为资本与经纬创投共同领投，九坤创投、钧山资本、SEE Fund、猎聘投资、元诺资本、钟鼎资本等参与，云启资本、小米战投、弘晖基金、英诺天使基金、东方嘉富等老股东加注。估值未披露；“亿美元级Pre-A”可能推高估值，但公开资料未显示达到10亿美元，本报告按未披露且需持续跟踪处理。
- 创始人：创始人许华哲本科毕业于清华大学电子工程系，在伯克利人工智能研究（BAIR）获博士学位，曾在斯坦福视觉与学习实验室担任博士后，现任清华大学交叉信息研究院/跨学科信息科学研究所助理教授、博士生导师，领导清华具身智能实验室，研究方向包括深度强化学习、机器人学、计算机视觉与触觉。商业合伙人方面，公开报道显示前美团无人机高管刘硕加盟，负责商业化、战略和业务拓展，曾任美团无人机商业管理负责人、美团机器人研究院秘书长。
- 竞争力：破壳的强信号是“学术世界模型+真实家务演示+小米/顺为/经纬/云启等资本与产业资源”组合，且家庭场景具备高频、高天花板和AI入口属性。不同于先做工业或商业服务机器人，公司直接挑战家庭非结构化任务，若首款硬件能闭环10件核心家务，品牌与数据飞轮会形成先发优势。主要风险也来自此：家庭场景对安全、成本、鲁棒性、售后和用户预期极苛刻，Demo到可量产产品之间差距大；同时宇树等二级市场标杆将加速行业估值校准，早期高估值项目会被要求拿出真实交付和留存。
- 赛道分析：具身智能正从“能动的本体”转向“大脑+小脑+数据”的全栈能力竞争，家庭机器人被资本视为最具想象力的终端市场之一，可承载家务、陪伴、看护、家庭助理和家庭AI入口。未来1-2年，行业会分化为低成本本体、垂直场景交付和机器人大脑/数据层三类胜者；破壳试图做家庭通用操作的端到端产品，需要同时解决硬件成本、模型泛化和真实数据规模三道难题。
- 关键数据：2026年4月/3月成立（北京商报/新浪2026-08-03：[finance.sina.com.cn](https://finance.sina.com.cn/jjxw/2026-08-03/doc-inikzzhm2645393.shtml)；智东西2026-08-03：[m.zhidx.com](https://m.zhidx.com/p/581667.html)）；2026年4月29日完成数千万美元天使轮（财新2026-08-03：[companies.caixin.com](https://companies.caixin.com/2026-08-03/102470931.html)；智东西2026-08-03）；2026年8月3日完成亿美元级Pre-A轮（证券时报2026-08-03：[stcn.com](https://www.stcn.com/article/detail/4054882.html)；财新2026-08-03）；2026年6月发布9分钟麻婆豆腐全自主真机演示（中国基金报/新浪2026-08-04：[finance.sina.cn](https://finance.sina.cn/stock/jdts/2026-08-04/detail-inimafqf5845228.d.html?vt=4&cid=76993&node_id=76993)）；计划8月底至9月初推出首款硬件、10件核心家务任务、万元级起步（同上）。估值：未披露。
- 原文链接：[stcn.com](https://www.stcn.com/article/detail/4054882.html)；[finance.sina.com.cn](https://finance.sina.com.cn/jjxw/2026-08-03/doc-inikzzhm2645393.shtml)；[companies.caixin.com](https://companies.caixin.com/2026-08-03/102470931.html)；[finance.sina.cn](https://finance.sina.cn/stock/jdts/2026-08-04/detail-inimafqf5845228.d.html?vt=4&cid=76993&node_id=76993)；[m.zhidx.com](https://m.zhidx.com/p/581667.html)
- 投资/合作视角：若老板关注家庭机器人入口，破壳是本周最值得跟踪的早期高热标的之一；小米战投和顺为持续加注说明其消费硬件生态价值突出。风险是“亿美元级Pre-A”可能带来高估值压力，合作上应优先看样机稳定性、量产BOM、首批交付计划、真实家庭测试数据和售后责任边界。
- 为何关注：家庭具身智能虽难，但破壳同时具备清华技术源头、小米/顺为/经纬等产业资本、真实家务 Demo 与即将推出硬件，是观察家庭机器人入口的关键早期标的。

---

### 4. Intelligence / Design Arena（美国 · 多模态评测/人类偏好数据）
- 一句话定位：Intelligence 运营 Design Arena，让用户在网站、图像、视频、游戏、应用等多模态输出中进行 A/B 选择，为 AI 模型提供可规模化的人类审美与设计偏好数据。
- 本周动态：2026-08-03，Design Arena 背后的公司 Intelligence 宣布 790万美元种子轮，Index Ventures 领投，Conviction（Sarah Guo 与 Mike Vernal）、A*、Valkyrie 等参与；TechCrunch 同日披露其产品已有 530万全球用户并生成约 6000万美元 ARR。来源：TechCrunch（2026-08-03，[techcrunch.com](https://techcrunch.com/2026/08/03/designarena-creators-raise-7-9-million-to-bring-taste-to-ai-models/)）；AI Weekly二次报道（2026-08-03，[aiweekly.co](https://aiweekly.co/alerts/design-arena-maker-intelligence-raises-79m-seed-at-60m-arr)）；公司官网与Design Arena页面。
- 产品深研：面向普通用户，Design Arena 像一个高级模型路由器：用户输入想做的网站、游戏、图像、视频、演示或应用，系统调用多个 AI 模型输出候选，然后让用户做一系列 A vs. B 排名。面向企业/模型实验室，真正价值在于把这些用户选择转成即时、规模化、难以被纯自动 benchmark 替代的人类反馈数据，用来衡量模型在“设计感”“好看”“有用”上的表现。公司官网显示 Intelligence 提供 leaderboard，并邀请 AI labs 合作；Design Arena 自述覆盖 190+国家的数百万用户，用于发现新模型和比较能力。
- 融资记录：790万美元种子轮，2026-08-03 宣布；Index Ventures 领投，Conviction、A*、Valkyrie 等参投。估值未披露；种子轮阶段且未见独角兽估值证据。此前融资未披露。
- 创始人：联合创始人 Grace Li 向 TechCrunch 表示，公司起源于 2025年毕业前几周，一群大学朋友试图做 AI 游戏引擎；模型能生成可运行游戏，但游戏不好玩，于是团队转向“如何判断一个游戏/设计是否有趣”。Y Combinator公开页显示 Design Arena 由 Grace Li 与 Kamryn Ohly 创立，团队位于 San Francisco；两人均为 Harvard 背景，Grace Li 为 Computer Science & Neuroscience、曾在 Apple，Kamryn Ohly 为 Computer Science & Education、曾在 Apple。这一问题引出了通过大量真实用户偏好获取“taste data”的方向，团队优势在于从产品体验和模型评测交界处切入，而不是单纯做模型或众包标注。
- 竞争力：Intelligence 的强点是把用户想要“获得最优输出”的消费行为与模型实验室需要的人类偏好反馈结合，形成双边网络：更多用户带来更多真实偏好，更多模型/实验室接入又提高平台输出质量。530万用户和 6000万美元 ARR 如果持续真实，将远超典型种子期公司。风险包括：TechCrunch 提到同类人类评测产品 Yupp 曾在融资 3300万美元后关闭；LM Arena 等文本评测平台、模型厂自建评测、合成评测都可能压缩价值；此外，人类偏好数据质量、刷榜、地域偏差和隐私同意需要治理。
- 赛道分析：多模态生成模型已经从“能生成”进入“谁更符合人类审美/业务目标”的阶段，传统自动 benchmark 难以捕捉设计品味、风格趋势和地域差异。未来 1-2年，模型实验室会更多购买高质量 human preference/eval 数据，尤其在网页、广告素材、UI、游戏、视频等商业场景；Intelligence 以 Design Arena 卡位“多模态LM Arena + 用户产品”，若能保持用户增长与企业收入，有机会成为模型评测和RLHF/RLAIF数据供应层。
- 关键数据：790万美元种子轮（TechCrunch，2026-08-03）；530万用户（TechCrunch，2026-08-03）；约6000万美元ARR（TechCrunch，2026-08-03）；Design Arena 覆盖 190+国家数百万用户（Design Arena官网读取）；投资方 Index Ventures、Conviction、A*、Valkyrie（TechCrunch，2026-08-03）；估值未披露。
- 原文链接：[techcrunch.com](https://techcrunch.com/2026/08/03/designarena-creators-raise-7-9-million-to-bring-taste-to-ai-models/)；[intelligence.ai](https://www.intelligence.ai/)；[designarena.ai](https://www.designarena.ai/)；[ycombinator.com](https://www.ycombinator.com/companies/design-arena)；[aiweekly.co](https://aiweekly.co/alerts/design-arena-maker-intelligence-raises-79m-seed-at-60m-arr（搜索/可访问链接用于交叉)）。
- 投资/合作视角：这是本周最值得重点跟踪的“数据飞轮型”早期公司之一，种子轮却披露高ARR，若经尽调确认，增长信号极强。建议验证收入来源集中度、frontier lab 合同期限、用户留存与反馈质量；合作上可帮助被投模型/应用公司做多模态输出评测与地区偏好分析。
- 为何关注：种子轮公司披露 530 万用户与约 6000 万美元 ARR，说明多模态模型评测与人类偏好数据可能形成强数据飞轮，是模型实验室与应用公司的基础设施机会。

---

### 5. 丘脑智能（中国 · AI记忆基础设施/多模态Agent）
- 一句话定位：面向Agent、陪伴硬件和垂类应用的多模态长记忆基础设施公司，以MemAura为模型与用户之间的独立记忆层。
- 本周动态：2026年7月31日前后，36氪披露丘脑智能已完成数千万元种子轮融资，投资方包括深圳一线基金和产业资本；DeepTech/新浪科技在7月28日发布对创始人张源的长访，披露其融资、技术路线和商业化进展；亿欧数据库7月29日记录公司完成种子轮融资，称资金用于核心产品OmniMemory研发与团队建设。该动态落在本周窗口内，且是明确融资信号。
- 产品深研：丘脑智能的核心产品是2026年6月上线的MemAura记忆基座，对外提供ADK和API，把“是否写入、写入什么、何时召回、召回多少”做成独立决策系统，而不是简单向量库或长上下文。技术路线经历从STKG时空知识图谱到仿生记忆架构的迭代，参考人类海马体的事件识别、编码、分区隔离和冷热存储机制，保留证据链以降低幻觉。产品指标上，36氪称输入侧Token综合消耗降低40%-49%，记忆检索延迟控制在400毫秒以内，端到端首次回答可做到1秒以内，综合准确率80%以上；DeepTech访谈中张源称商业化产品响应速度稳定在200-400毫秒，并可在大模型输入环节减少约40% Token消耗。
- 融资记录：公司成立于2025年11月19日（亿欧数据库），2026年7月获得数千万元种子轮融资；36氪称投资方包括深圳一线基金和产业资本，DeepTech/新浪科技表述为一线人民币基金及产业资本联合投资，融资用途为技术研发、人才队伍补充以及产业化落地。估值未披露；36氪文章提到多模态记忆赛道“估值最高的公司仅不到20亿元”，但未指明丘脑智能自身估值，因此本公司估值按未披露处理，且种子轮规模明显低于10亿美元门槛。
- 创始人：创始人兼CEO张源毕业于北京大学，具备电子与经济双学科背景，曾在创投行业工作，也曾在自动驾驶公司担任COO，并参与具身智能相关创业。团队平均年龄约26岁，核心成员来自阿里达摩院、腾讯、商汤、香港中文大学、港中深、北大、西交大、KIT、复旦等企业和高校。张源的关键判断是：基础模型会越来越强，但多模型共存会长期带来“记忆孤岛”，因此以用户为中心、跨模型存在的AI记忆层会成为独立基础设施。
- 竞争力：优势是进入了国内仍很早期的“Memory as Infrastructure”生态位，并在多模态长记忆上有公开Benchmark与真实客户测试双重验证；2026年5月公司联合英伟达、港科大、港中文发布并开源MEMLENS多模态长记忆Benchmark，进入Hugging Face AI领域Daily Paper前三。商业上优先绑定陪伴机器人、AI硬件、AI客服、数字员工和教育硬件等高频长期交互场景，有机会通过真实用户数据形成记忆决策壁垒。主要风险是基础模型厂商、Agent平台和硬件大客户可能自研记忆层；另外记忆产品涉及隐私、准确性、可审计和数据授权，若处理不好会放大长期错误。
- 赛道分析：Agent从“短对话工具”走向长期任务执行后，记忆会成为规划、个性化和主动智能的底层能力。长上下文、RAG、GraphRAG能解决部分检索问题，但在跨session、跨模态、低延迟和“该不该记”的决策上仍不足。未来1-2年，陪伴硬件、家庭机器人、AI客服、教育助手、数字员工都会需要独立记忆API；丘脑智能卡位的是基础模型与终端应用之间的中间层，类似Agent时代的用户状态与偏好操作系统。
- 关键数据：2025年11月19日成立（亿欧数据库2026-07-29：[iyiou.com](https://www.iyiou.com/data/202607291136676)）；2026年7月数千万元种子轮，投资方为深圳一线基金/产业资本或一线人民币基金/产业资本（36氪2026-07-31：[m.36kr.com](https://m.36kr.com/p/3919386961177985)；新浪科技/DeepTech 2026-07-28：[finance.sina.cn](https://finance.sina.cn/tech/2026-07-28/detail-inikkhkm3062380.d.html?vt=4)）；MemAura于2026年6月上线，Token降低40%-49%、检索延迟400ms以内、首次回答1秒以内、综合准确率80%以上（36氪2026-07-31）；商业化产品响应200-400ms、输入Token约降40%（新浪科技/DeepTech 2026-07-28）；2026年5月联合NVIDIA、港科大、港中文开源MEMLENS（36氪2026-07-31）。估值：未披露。
- 原文链接：[m.36kr.com](https://m.36kr.com/p/3919386961177985)；[finance.sina.cn](https://finance.sina.cn/tech/2026-07-28/detail-inikkhkm3062380.d.html?vt=4)；[iyiou.com](https://www.iyiou.com/data/202607291136676)；[firecat-web.com](https://www.firecat-web.com/daily-news/13279)
- 投资/合作视角：这是一个很早期但有基础设施属性的标的，适合与陪伴硬件、教育硬件、客服/数字员工产品做POC，看其是否能真实提升留存、转化和交互时长。需重点尽调隐私合规、客户数据归属、幻觉与错误记忆纠偏机制，以及是否能在头部客户自研压力下保住独立生态位。
- 为何关注：Agent 长期记忆仍是基础模型之外的空白层，丘脑智能用原生多模态记忆、低延迟与 Token 降本切入陪伴硬件/数字员工，适合做早期 PoC 验证。

---

## 🌍 分地域详情

### 🇺🇸 美国

### Polar Browser（美国 · AI浏览器/Agent）
- 一句话定位：Polar 是面向知识工作者的 AI 浏览器，目标不是“问答式标签页助手”，而是让代理在用户已登录的网站中完成多步骤浏览器任务。
- 本周动态：2026-07-29，Polar 宣布完成 570万美元种子轮，Madrona 领投，天使投资人包括前 GitHub CEO Thomas Dohmke、Modal 创始人 Erik Bernhardsson 等；同日 TechCrunch 报道其由曾参与 Perplexity Comet 的 Kevin Jiang 创办，产品正式面向知识工作场景推出。来源：AOL/BusinessWire转载（2026-07-29，[aol.com](https://www.aol.com/articles/polar-ai-browser-does-real-150000000.html)）；TechCrunch（2026-07-29，[techcrunch.com](https://techcrunch.com/2026/07/29/perplexity-employee-who-worked-on-comet-launches-an-ai-browser-aimed-at-knowledge-work/)）。
- 产品深研：Polar 的核心产品是一个可下载的 macOS AI 浏览器，用户用自然语言交代任务后，它在用户已有账户和会话中点击、输入、导航并执行任务。与第一代 AI 浏览器侧重搜索入口、总结标签页不同，Polar 主打“long, multi-step tasks”，可保存提示词为工作流并按小时、每日、每周或自定义周期运行，适用于研究、招聘、销售、运营、市场等横跨网站的重复劳动。公司官网强调可在任意标签页调用当前页面作为上下文，也能长时间自主运行；BusinessWire稿称其已完成超过 15小时无人干预任务、前 7个月累计执行 450万+ actions，并在 browser-agent benchmarks 上显著优于 OpenAI 和 Anthropic。商业模式上，TechCrunch 写到浏览器免费，日常 AI 任务给少量免费额度，高额度订阅从 20美元/月起。
- 融资记录：本周披露的种子轮为 570万美元，2026-07-29 宣布，Madrona 领投；Thomas Dohmke、Phoebe Gates、Erik Bernhardsson、Benjamin Spector、Rob Wachen、Robert Yang 等参与。估值未披露；以种子轮规模与未披露估值判断，未见达到 10亿美元估值的证据。此前融资未披露。来源：AOL/BusinessWire转载与 TechCrunch。
- 创始人：Polar 由 Kevin Jiang、Vishaal Ram、Howard Zhong 创立，团队背景包括 MIT、Perplexity 与量化基金；Kevin Jiang 此前在 Perplexity 参与 Comet 浏览器相关工作，对 AI 浏览器与浏览器代理产品路线有一线经验。Madrona 合伙人 Sabrina Albert 在报道中强调，难点在于让代理可靠地运行在开放、登录态 Web 上，而浏览器产品天然理解用户与网站交互并获得授权上下文。
- 竞争力：Polar 的差异化在于把浏览器从“AI搜索/总结入口”推进到“登录态任务执行层”，并有早期使用数据支撑：450万+ actions、可执行 15小时任务、口碑增长。护城河来自浏览器执行栈、任务轨迹数据、工作流模板和对真实网站变化的鲁棒性；风险是 OpenAI、Anthropic、Perplexity、Browser Use、The Browser Company/Atlassian 等都可能把浏览器代理作为入口，且登录态自动化涉及隐私、安全、权限边界和任务失败责任。
- 赛道分析：AI浏览器/浏览器代理正从消费者“聊天+搜索”转向知识工作自动化，核心买点是替代低价值复制粘贴、表格录入、候选人/客户调研和CRM更新等长尾工作。未来 1-2 年，竞争会围绕可靠执行、权限隔离、企业审计、RPA集成和垂直工作流模板展开；Polar 卡位偏早期、横向工具，适合先拿 prosumer/小团队增长，再向企业安全和团队协作升级。
- 关键数据：570万美元种子轮（AOL/BusinessWire转载，2026-07-29）；450万+ actions、15小时无人干预任务（AOL/BusinessWire转载，2026-07-29）；订阅从 20美元/月起（TechCrunch，2026-07-29）；Madrona 领投、Thomas Dohmke/Erik Bernhardsson等参与（AOL/BusinessWire转载与TechCrunch，2026-07-29）；估值未披露。
- 原文链接：[aol.com](https://www.aol.com/articles/polar-ai-browser-does-real-150000000.html)；[techcrunch.com](https://techcrunch.com/2026/07/29/perplexity-employee-who-worked-on-comet-launches-an-ai-browser-aimed-at-knowledge-work/)；[polarbrowser.com](https://polarbrowser.com/)。
- 投资/合作视角：这是“AI Agent 入口争夺”中更接近工作流落地的一类资产，早期数据质量不错，适合跟踪其在销售/招聘/运营垂直场景的留存与付费。合作可从内部知识工作自动化试点切入；投资风险主要是浏览器平台级竞争和企业安全合规门槛。

---

### Ellis AI（美国 · 金融/私募信贷Agent）
- 一句话定位：Ellis AI 为私募信贷管理人提供 AI 原生运营平台，把分散在文档、电子表格、会计与通讯系统中的工作流连接起来，让代理辅助组合监控、对账、报告和月结。
- 本周动态：2026-07-31 TechCrunch 报道，Ellis AI 于周四（2026-07-30，落在本窗口内）宣布从 stealth 亮相并完成 1000万美元种子轮，投资方包括 First Round Capital、645 Ventures、Harlem Capital、Khosla Ventures、Thrive Capital、Slow Capital、Kearny Jackson 和 Ariel Alternatives CEO Mellody Hobson。来源：TechCrunch（2026-07-31，[techcrunch.com](https://techcrunch.com/2026/07/31/repeat-founder-ryan-williams-raises-10m-seed-for-an-ai-startup-for-private-credit-managers/)）；TMC Insight二次报道（2026-08-02左右，[insight.tmcnet.com](https://insight.tmcnet.com/insight/ellis-ai-raises-10-million-to-automate-private-credit-operations-msamh85r)）。
- 产品深研：Ellis 面向私募信贷这一操作复杂、数据分散且高度依赖 Excel 的领域，连接公司已有软件、会计信息、文档、银行/服务商数据与通讯记录，而不是要求客户推倒重来。平台可集中数据、标记差异、让 AI agents 协助 portfolio monitoring、报表准备、对账和月末 close；TechCrunch 举例称，团队原本要从多个系统下载文件、重排格式、比对余额、调查差异并手工回填，Ellis 试图把这些步骤串成可审计的自动化流程。其产品哲学强调 human-in-the-loop：重大判断与动作仍由金融专家承担，AI 缩小人工循环而非消灭它。
- 融资记录：已披露融资为 1000万美元种子轮，2026-07-30宣布/2026-07-31报道；投资方包括 First Round Capital、645 Ventures、Harlem Capital、Khosla Ventures、Thrive Capital、Slow Capital、Kearny Jackson、Mellody Hobson。估值未披露；未见 10亿美元以上估值证据。创始人前公司 Cadre 累计融资 1.6亿美元以上，峰值估值 8亿美元，2024年被 Yieldstreet 收购，但这属于创始人历史背景，不计入 Ellis 估值。
- 创始人：创始人为 Ryan Williams，他曾在 2014年与 Josh Kushner、Jared Kushner 共创房地产投资平台 Cadre。Williams 在 Cadre 经历了私募市场前端数字化，但也观察到私募市场底层运营基础设施仍碎片化，于 2025年左右开始构思 Ellis。其优势在于既懂另类资产/私募市场业务，又有已退出金融科技公司的融资、产品和机构客户经验。
- 竞争力：Ellis 的竞争力在于选中“私募信贷后台运营”这个痛点强但通用软件覆盖不足的楔子，数据对象包含 loan servicing、fund admin、general ledger、bank feeds、Excel models 与邮件，天然适合用代理做例外识别和流程编排。风险是金融机构采用周期长、数据安全/权限/审计要求高，且 Canoe Intelligence、DealCloud、Allvue 等私募市场软件商可向 AI 工作流延伸；Ellis 必须证明代理的可解释性、数据血缘和异常处理足够可靠。
- 赛道分析：私募信贷资产增长推动更复杂的基金结构、投资人报告和合规需求，TMC Insight 引用行业数据称全球私募信贷 AUM 2024年约 1.7万亿美元，高于 2020年的 8750亿美元；同时大量管理人仍依赖电子表格。未来 1-2年，私募资本软件将从单点录入/报表工具升级到“统一数据层 + AI异常处理 + 审计工作流”，早期客户更可能来自中大型 private credit managers、secondaries、direct lending 团队。
- 关键数据：1000万美元种子轮（TechCrunch，2026-07-31）；投资方名单（TechCrunch，2026-07-31）；Cadre 历史融资 1.6亿美元+、峰值估值 8亿美元、2024年出售给 Yieldstreet（TechCrunch，2026-07-31）；全球私募信贷 AUM 2024年约 1.7万亿美元、2020年约 8750亿美元（TMC Insight）；估值未披露。
- 原文链接：[techcrunch.com](https://techcrunch.com/2026/07/31/repeat-founder-ryan-williams-raises-10m-seed-for-an-ai-startup-for-private-credit-managers/)；[insight.tmcnet.com](https://insight.tmcnet.com/insight/ellis-ai-raises-10-million-to-automate-private-credit-operations-msamh85r)；[ellisai.com](https://www.ellisai.com/（页面可访问但抽取不到正文)）。
- 投资/合作视角：这是垂直金融 AI Agent 的高质量样本，创始人市场理解强，种子轮投资人质量高。建议关注其是否能拿到真实私募信贷客户、完成核心系统集成并通过安全审计；合作上可从投后企业/金融机构的月结、LP reporting、portfolio monitoring 自动化试点切入。

---

### June AI（美国 · 企业AI部署/Agent实施基础设施）
- 一句话定位：June AI 把企业系统实施、数据迁移和 AI Agent 部署做成“AI implementation & deployment lab”，帮助大企业在 Salesforce、ServiceNow、Databricks、Workday 等复杂遗留系统上落地代理。
- 本周动态：2026-08-03，June 从 stealth 亮相并宣布 2000万美元 pre-seed，Marc Benioff 的 Time Ventures 领投，Michael Dell、Aaron Levie、George Kurtz 等参与；公司拒绝披露估值。来源：Yahoo/TechCrunch转载（2026-08-03，[tech.yahoo.com](https://tech.yahoo.com/ai/deals/articles/marc-benioff-backed-startup-thinks-100000920.html)）；TechCrunch原文页面（2026-08-03，[techcrunch.com](https://techcrunch.com/2026/08/03/a-marc-benioff-backed-startup-thinks-ai-can-solve-the-ai-deployment-problem/)，可访问但抽取正文不完整）；公司官网（[june.ai](https://www.june.ai/)）。
- 产品深研：June 的产品核心是扫描企业现有系统，理解业务流程、配置、重复字段、数据源和瓶颈，再生成实施 AI Agent 的路线图，并可点击构建每个任务。官网将能力拆成 Understand、Implement、Optimize、Adopt/Communicate：先映射工作如何发生，发现瓶颈和 ROI；再从 discovery、solution design 到 implementation、testing、ongoing management 端到端交付；同时主动识别 AI quick wins 和 heavier lifts，并把新流程转化成培训、沟通和模拟。与传统咨询/FDE服务不同，June 试图把复杂实施知识产品化、代理化，但仍保留 June Experts 作为一键真人专家支持，以满足大企业对责任和复核的要求。
- 融资记录：2000万美元 pre-seed，2026-08-03宣布；Time Ventures 领投，Michael Dell、Aaron Levie、George Kurtz 等科技行业人士参投。估值未披露；pre-seed 阶段且无独角兽估值公开证据，符合本清单 <10亿美元筛选。此前融资未披露。来源：Yahoo/TechCrunch转载。
- 创始人：创始团队包括 Efrat Rapoport、Ohad Hen、Barak Goldstein、Idan Tsitiat。四人曾创办 Bonobo AI，一个 2017年前后推出语音转文本服务的 pre-transformer 语言模型公司，2019年前后被 Salesforce 收购，之后团队在 Salesforce AI 项目工作多年。Rapoport 曾任 Salesforce 高管；他们在 Salesforce 客户现场看到大企业难以把 AI 接入遗留平台、复杂工作流和技术债，因此再创业做 June。
- 竞争力：June 站在企业 AI 落地最大瓶颈处：不是模型能力，而是把代理安全地接入复杂系统、重复字段、历史配置和跨团队流程。其创始团队经历 Bonobo AI + Salesforce 收购整合，懂企业系统语义和实施周期；本轮投资人含 Salesforce、Dell、Box、CrowdStrike 等企业科技网络，对客户获取有帮助。风险是产品与服务边界难把握，容易退化为高端咨询/FDE；同时 Accenture、Deloitte、Salesforce、ServiceNow、Palantir 及新一代 FDE 公司都在争夺 AI implementation budget。
- 赛道分析：2026年的企业 AI 预算开始从“买模型/试点聊天机器人”转向“部署可审计、可治理的业务代理”，FDE 和专业服务需求激增。未来 1-2年，能把系统理解、变更建议、自动构建、沙盒测试和审计合在一起的平台会成为企业代理落地的关键中间层；June 的卡位更像“AI时代的实施操作系统”，可在 CRM、ITSM、数据平台、财务审批、客服、销售审批等高频系统中横向扩展。
- 关键数据：2000万美元 pre-seed（Yahoo/TechCrunch转载，2026-08-03）；投资方 Time Ventures 领投，Michael Dell、Aaron Levie、George Kurtz参投（Yahoo/TechCrunch转载，2026-08-03）；估值未披露（同源）；Bonobo AI 2017推出语音转文本服务、约两年后被 Salesforce 收购（Yahoo/TechCrunch转载）；CMG 抵押贷款客户案例中目标为 100个agents（Yahoo/TechCrunch转载）。
- 原文链接：[tech.yahoo.com](https://tech.yahoo.com/ai/deals/articles/marc-benioff-backed-startup-thinks-100000920.html)；[june.ai](https://www.june.ai/)；[techcrunch.com](https://techcrunch.com/2026/08/03/a-marc-benioff-backed-startup-thinks-ai-can-solve-the-ai-deployment-problem/)。
- 投资/合作视角：June 是企业 AI 部署瓶颈的高杠杆方向，若产品化程度足够，可能比纯FDE公司更具规模性。建议重点验证客户中是否减少顾问人天、部署周期和 agent failure rate；合作可让被投企业在 Salesforce/ServiceNow/Workday 等场景跑一个低风险代理实施试点。

---

### Actualyze AI（美国 · 企业AI治理/模型网关）
- 一句话定位：Actualyze AI 为企业所有模型请求提供统一治理、访问控制、安全扫描、成本归因和智能路由，是企业 AI stack 中的“受治理请求路径”。
- 本周动态：2026-08-03，Pasadena, CA 的 Actualyze AI 从 stealth 亮相，发布 Early Access/Design Partner Program，并宣布 700万美元种子轮，投资方包括 Storm Ventures、Canaan Partners、Morado Ventures、Jerry Yang 的 AME Cloud Ventures；FinSMEs 在 2026-08-04 跟进。来源：PR Newswire（2026-08-03，[prnewswire.com](https://www.prnewswire.com/news-releases/actualyze-ai-emerges-from-stealth-with-7m-seed-round-to-deliver-enterprises-one-platform-for-every-ai-request-302840716.html)）；FinSMEs搜索结果（2026-08-04，[finsmes.com](https://www.finsmes.com/2026/08/actualyze-ai-raises-7m-in-seed-funding.html)，页面403但搜索结果可交叉金额/地点/投资方）；公司官网（[actualyze.ai](https://actualyze.ai/)）。
- 产品深研：Actualyze 位于组织人员、应用、代理与所有 AI 模型之间，每个 inference request 都经过同一受治理路径，绑定发起人、团队与应用，再进行访问检查、内容检查、预算扣费和日志记录。平台抽象模型供应商凭据，兼容 OpenAI-compatible models、AI client tools 和第三方平台，使企业在多模型时代保持模型不可知，同时可按能力、成本、质量进行 virtual models 智能路由与自动 failover。四个产品支柱为 Govern、Secure、Operate、Optimize：分别覆盖访问/审批/预算、敏感数据与 guardrails、模型目录与部署、按成本与质量优化路由。
- 融资记录：700万美元种子轮，2026-08-03 宣布；投资方为 Storm Ventures、Canaan Partners、Morado Ventures、AME Cloud Ventures。估值未披露；种子轮阶段且无独角兽估值公开证据，符合 <10亿美元筛选。此前融资未披露。
- 创始人：联合创始人包括 CEO Rafi Khardalian 与 CTO Sean Lynch。两人此前创办 managed private cloud 公司 Metacloud，并被 Cisco 收购；Actualyze 新闻稿称团队过去一年与大型企业的平台、安全、财务负责人交流并围绕这些需求构建产品。这个背景使团队熟悉企业基础设施、云治理、API流量控制和大客户采购周期。
- 竞争力：Actualyze 的关键判断是“模型调用看似普通 API 请求，但 prompt、敏感数据、代理链式调用和成本归因让传统 API 网关/FinOps工具不够用”。其护城河可能来自企业级请求遥测、策略引擎、模型路由与审计数据；如果企业把所有 AI 请求强制走一条 governed path，平台粘性会很高。风险是与 Kong、Cloudflare、Datadog、New Relic、OpenAI/Anthropic企业控制台、LangSmith、Portkey、LiteLLM 等基础设施/可观测性/网关产品重叠，早期公司需要证明易集成与策略深度。
- 赛道分析：企业 AI 从单模型试用进入多模型、多应用、多代理阶段后，成本失控、凭据散落、数据泄露和审计不可见会成为 CIO/CISO/CFO 的共同问题。未来 1-2年，“AI gateway + governance + observability + FinOps”会成为企业 AI 平台标准层，赢家要么是云/安全巨头内建，要么是中立层凭跨模型、跨工具和跨部门视角胜出。Actualyze 的卡位偏中立基础设施，适合作为 AI 请求控制平面。
- 关键数据：700万美元种子轮（PR Newswire，2026-08-03）；投资方 Storm Ventures、Canaan Partners、Morado Ventures、AME Cloud Ventures（PR Newswire，2026-08-03）；Early Access/Design Partner Program 已开放（PR Newswire与公司官网，2026-08-03/读取日）；四大支柱 Govern/Secure/Operate/Optimize（PR Newswire，2026-08-03）；估值未披露。
- 原文链接：[prnewswire.com](https://www.prnewswire.com/news-releases/actualyze-ai-emerges-from-stealth-with-7m-seed-round-to-deliver-enterprises-one-platform-for-every-ai-request-302840716.html)；[actualyze.ai](https://actualyze.ai/)；[actualyze.ai](https://actualyze.ai/insights/the-foundation-for-enterprise-ai-is-here)；[finsmes.com](https://www.finsmes.com/2026/08/actualyze-ai-raises-7m-in-seed-funding.html（访问403)，仅用于搜索结果交叉验证）。
- 投资/合作视角：Actualyze 是企业 AI 基础设施中“刚需但竞争密”的方向，适合关注其是否能成为模型供应商中立的控制面。合作上可用作被投企业/大型客户的 AI 请求审计与成本治理试点；投资风险在于云厂商和现有可观测性平台快速复制。

---

### Intelligence / Design Arena（美国 · 多模态评测/人类偏好数据）
- 详见 TOP5，本节不重复展开。

---

### Pangram（美国 · AI内容检测/多模态真实性）
- 一句话定位：Pangram 是纽约/布鲁克林 AI 检测研究公司，提供文本与图像 AI 生成内容识别工具，服务学校、大学、媒体、平台与企业内容审核场景。
- 本周动态：2026-07-29，Pangram 宣布完成 900万美元融资，Menlo Ventures 领投，Haystack、ScOp Venture Capital、Script Capital、Cadenza 参投；同时发布 Pangram 4 文本检测模型，并开放 Pangram AI Image Detector 研究预览。来源：TechCrunch（2026-07-29，[techcrunch.com](https://techcrunch.com/2026/07/29/as-ai-content-floods-the-internet-pangram-raises-9m-to-detect-it/)）；VentureBeat/BusinessWire转载（2026-07-29，[venturebeat.com](https://venturebeat.com/business/pangram-launches-new-worlds-best-ai-detector-expands-to-images-backed-by-9m-from-menlo-ventures)）；公司官网（[pangram.com](https://www.pangram.com/)）。
- 产品深研：Pangram 的文本检测系统不是依赖水印或元数据，而是用大型机器学习模型学习人类文本与 LLM 合成“镜像文本”之间的风格选择差异，因此能判断全AI生成、混合人机写作和AI润色痕迹。Pangram 4 针对短文本、AI-assisted writing、mixed human-AI content 与 humanizer 改写工具增强鲁棒性；图像检测处于 research preview，试图识别AI图像和真实照片中嵌入的AI图像区域。产品形态包括网页订阅、Chrome extension（实时标注 X、LinkedIn、Substack、Reddit、Medium 等内容）和 API；TechCrunch 报道其 API 客户包括 Substack、Quora、学校/大学、出版商、代理和招聘方。
- 融资记录：900万美元融资，2026-07-29宣布；Menlo Ventures 领投，Haystack、ScOp Venture Capital、Script Capital、Cadenza 参投。估值未披露；融资额和阶段均显示非独角兽，未见 ≥10亿美元估值证据。此前融资未披露。
- 创始人：TechCrunch 报道 Pangram 由 Stanford AI/机器学习背景的 Max Spero 与 Bradley Emi 于约两年前创建；公司官网写明 2023年成立于 Brooklyn, NY，创始人为来自 Tesla 和 Google 的 AI researchers。Max Spero 担任 CEO，Bradley Emi 担任 CTO；他们把问题定义为生成式 AI 让语言/图像生产成本接近零，从而需要新的真实性基础设施。
- 竞争力：Pangram 披露的强指标包括 1/10,000 人类文档误判为AI（0.01% false positive rate）、Pangram 4 可保持 0.01% false positive，同时图像检测内部 benchmark 准确率 99.5%；官网称整体 AI detector 准确率 99.98%，并被 Maryland、Chicago 等第三方研究者验证。其客户/集成如 Substack、Quora 提供真实分发场景。风险是 AI检测天然存在军备竞赛、误伤成本高、不同语言/风格/领域泛化难，且 Winston AI、Originality.ai、Copyleaks、GPTZero 以及模型厂水印/溯源方案都在竞争。
- 赛道分析：AI slop、SEO农场、学术/法律虚假引用、社交平台机器人和AI图像证据问题，让“内容真实性”从教育工具扩展到平台信任与媒体基础设施。未来 1-2年，单一文本检测会升级为跨文本、图像、视频、音频的 provenance stack，并与平台政策、浏览器扩展、API审核和内容供应链工具结合；Pangram 从文本扩到图像，方向正确，但必须持续证明低误判和抗规避。
- 关键数据：900万美元融资（TechCrunch与VentureBeat/BusinessWire转载，2026-07-29）；Menlo Ventures领投，Haystack、ScOp、Script、Cadenza参投（同源）；Pangram 4 对 AI辅助/混合文本与 humanizer 更鲁棒（VentureBeat/BusinessWire转载，2026-07-29）；0.01% false positive / 1 in 10,000（TechCrunch与VentureBeat/BusinessWire转载，2026-07-29）；图像检测内部 benchmark 99.5%准确率（VentureBeat/BusinessWire转载，2026-07-29）；官网称99.98%准确率、2023年Brooklyn成立（公司官网）。估值未披露。
- 原文链接：[techcrunch.com](https://techcrunch.com/2026/07/29/as-ai-content-floods-the-internet-pangram-raises-9m-to-detect-it/)；[venturebeat.com](https://venturebeat.com/business/pangram-launches-new-worlds-best-ai-detector-expands-to-images-backed-by-9m-from-menlo-ventures)；[pangram.com](https://www.pangram.com/)。
- 投资/合作视角：Pangram 抓住了生成式内容爆发后的信任基础设施需求，若低误判率可被独立持续验证，适合教育、媒体、招聘与UGC平台合作。投资风险在于检测赛道争议大、对抗性强，需重点尽调模型在中文/多语言、短文本、改写链条和图像复合场景下的真实误判率。

---

### 🇨🇳 中国

### 可达智灵（中国 · Agent/编码）
- 一句话定位：面向企业研发组织的工程级AI原生研发平台，用“织灵 Coda Loom 2.0”和ADE数字研发智能体把AI Coding从个人补全推进到团队级交付。
- 本周动态：2026年7月29日，公司官网与多家媒体披露可达智灵“2026年7月完成第三轮融资、10个月三轮融资”，同日网易智能/新浪刊出对创始人张宇的深访；7月30日投资界进一步报道其十个月内完成三轮密集融资、下一轮融资计划已提上日程，并称已获得芯片、金融、智能制造等头部企业客户订单。8月2日商道创投网称从官方获悉，公司三轮天使系列融资累计数千万元，由光环私募基金、国新思创等机构联合持续投资。
- 产品深研：核心产品“织灵 Coda Loom 2.0”于2026年5月20日发布，定位工程级AI原生研发平台，不是单人代码助手，而是面向需求、开发、测试、交付全流程的数字机器人研发团队（ADE）。技术路线强调多ADE协同交付、多智能体编排、工程级记忆、项目能效看板和分布式智能架构；在企业侧采用私有化部署，配专属安全ADE、异常预警和风险上报，解决代码、算法、文档和商业机密不可外流的问题。差异化在于把接口依赖、版本管理、测试覆盖、知识沉淀和安全审计纳入同一套组织系统，并通过云端大模型、开源小模型和私有算力的动态混合调度，优化“Token消耗—人类投入—研发产出”的能效比。
- 融资记录：公司2025年7月成立；公开资料显示成立半年时已连续完成两轮数千万级融资并启动Pre-A（投资界2026-05-21）；2026年7月完成第三轮融资，十个月内累计三轮。商道创投网2026-08-02披露三轮天使系列累计数千万元，投资方包括光环私募基金、国新思创等；投资界2026-07-30称投资方包括多家知名机构但未列全名单。估值未披露，按“数千万元天使系列”及早期轮次判断低于10亿美元；没有公开估值数据。
- 创始人：创始人兼CEO张宇拥有通信、互联网、芯片领域20余年从业经历，2019年以核心合伙人身份参与算力芯片创业，2025年7月创立可达智灵。公司核心团队汇聚中美AI领域技术专家与连续创业者，媒体称团队兼具芯片与AI双重产业经验。张宇对企业研发组织的判断是，复杂系统不再由个人完成，真正难点在接口、依赖、测试、版本、责任边界和全局上下文，因此团队级Agent应承载组织上下文，而非让个人Agent进入企业代码库。
- 竞争力：优势在于切中企业研发“安全+协同+ROI可度量”的真实采购门槛，并已拿到芯片、金融、智能制造标杆客户订单；投资人给出的案例是同一团队月度交付需求从12个提升到38个，说明产品已进入业务产出验证。风险是AI Coding赛道大厂、开源工具和模型公司迭代极快，单点功能壁垒会被压缩；可达智灵必须把工程闭环、私有化交付和客户组织经验沉淀做成迁移成本，否则容易被平台型模型厂商挤压。
- 赛道分析：AI Coding从“个人提效”进入“研发组织重构”，Gartner预测2028年75%的企业软件工程师会使用AI编码助手，较2023年初不足10%显著提升。中国企业在芯片、金融量化、制造、机器人和能源等高安全场景更偏好私有化、可审计、可度量的团队级工具，而非纯云端个人插件。未来1-2年，赛道竞争焦点会从补全准确率转向多智能体工程编排、私域代码与知识治理、成本调度和管理看板；可达智灵的卡位属于“企业AI研发基础设施”，若能跑出行业模板，有机会成为大客户合作/投资标的。
- 关键数据：2025年7月成立（投资界2026-07-30：[news.pedaily.cn](https://news.pedaily.cn/202607/567018.shtml)）；2026年5月20日发布织灵Coda Loom 2.0（光明网2026-07-29：[tech.gmw.cn](https://tech.gmw.cn/2026-07/29/content_38915147.htm)）；2026年7月完成第三轮融资、10个月三轮（公司官网2026-07-29：[aicoda.tech](https://www.aicoda.tech/media/)）；累计数千万元天使系列融资、投资方光环私募基金/国新思创等（商道创投网2026-08-02：[m.shangdaovc.cn](https://m.shangdaovc.cn/h-nd-14407.html)）；客户覆盖芯片、金融、智能制造等头部企业（投资界2026-07-30）。估值：未披露。
- 原文链接：[aicoda.tech](https://www.aicoda.tech/media/)；[news.pedaily.cn](https://news.pedaily.cn/202607/567018.shtml)；[tech.gmw.cn](https://tech.gmw.cn/2026-07/29/content_38915147.htm)；[finance.sina.com.cn](http://finance.sina.com.cn/stock/t/2026-07-29/doc-inikmumt2631565.shtml?wm=)；[m.shangdaovc.cn](https://m.shangdaovc.cn/h-nd-14407.html)
- 投资/合作视角：这是适合做企业客户验证和战略合作的早期Agent基础设施公司，信号是融资节奏快、已有高安全行业订单、创始人对组织级研发痛点理解较深。风险在于融资金额和估值透明度有限，需尽调客户留存、真实人效提升口径、私有化交付毛利以及与模型厂商的议价关系。

---

### 丘脑智能（中国 · AI记忆基础设施/多模态Agent）
- 详见 TOP5，本节不重复展开。

---

### 奇点逃逸（中国 · 多智能体协作/AI原生团队OS）
- 一句话定位：研发AI原生团队协作操作系统Nexus，让人、Agent、任务、知识和工具共享同一份组织状态，并让Agent从协作反馈中自进化。
- 本周动态：2026年8月3日，36氪首发并被新浪科技转载：奇点逃逸近日完成千万级种子轮融资，由星连资本与水木创投联合领投，奇绩创坛跟投；同日希鸥网、DoNews等转引确认该融资。本轮动态明确发生在时间窗内，属于多智能体协作基础设施方向的早期融资事件。
- 产品深研：Nexus的核心不是再做一个单体Agent，而是把组织中的人、Agent、任务、知识、工具表示成相互关联的对象，以“组织状态”替代“单次对话”作为协作底座。一项工作不再只是一段自然语言指令，而包含目标、负责人、依赖关系、权限、当前状态、执行证据和验收结果；新加入的Agent可理解前序任务、决策、上下游依赖与可调用资源。技术路线强调两层图结构：Agent内部的目标、规划、记忆、工具和验证节点，以及组织层面的人员、任务、知识与Agent工作图；协作反馈可定位到具体能力节点，再通过独立评测、治理采用和回滚机制进入下一轮协作，避免“系统自由改写自己”的失控风险。
- 融资记录：2026年8月完成千万级种子轮融资，星连资本与水木创投联合领投，奇绩创坛跟投；希鸥网称资金将用于加速产品研发与团队建设。亿欧项目信息显示奇点逃逸成立于2026年5月13日，是专注AI原生团队协作操作系统研发的科技公司。估值未披露；以千万级种子轮和成立不足三个月判断，远低于10亿美元。
- 创始人：创始人兼CEO薛传奕为清华大学本科、博士背景，研究方向覆盖强化学习与多智能体，曾以第一作者身份在NeurIPS、CJA等会议和期刊发表论文；在商汤、鉴智机器人实习期间参与自动驾驶算法研发与实车部署。其创业逻辑来自多智能体研究与真实工程经验的结合：Agent能力很强但仍像“单人助手”，组织中真正缺的是共享事实、过程证据、反馈评测和权限治理。
- 竞争力：奇点逃逸的差异化在于绕开垂直Agent功能堆叠，直接切入“AI进入组织后的协作协议与状态层”，与传统协作软件、项目管理系统、RPA和单一Agent平台形成错位。如果Nexus能沉淀客户真实任务中的状态、对象关系、评测基线和协作策略，这些数据资产会比单个Agent功能更难被模型升级复制。风险是产品尚早，组织级OS很难冷启动，需要找到高频刚需场景；同时企业客户已有飞书、钉钉、Jira、GitHub、Notion等工作流系统，Nexus必须证明自己不是又一个流程工具，而是能真实降低Agent协作断层。
- 赛道分析：随着Agent开始写代码、处理文档、调用工具并连续执行长程任务，企业会从“个人AI助手采购”进入“AI员工协作治理”阶段。未来1-2年，多Agent协作会出现三类机会：垂直业务Agent、Agent运行与评测平台、组织状态/权限/知识底座；奇点逃逸卡位第三类，若能与代码研发、产品运营、咨询分析等场景结合，有机会成为Agent时代的协作中间件。
- 关键数据：2026年8月3日36氪/新浪科技披露千万级种子轮融资，星连资本与水木创投联合领投、奇绩创坛跟投（[finance.sina.com.cn](http://finance.sina.com.cn/tech/roll/2026-08-03/doc-inikytnt6351138.shtml)）；成立于2026年5月13日（亿欧项目信息：[iyiou.com](https://www.iyiou.com/data/202608031137007)）；产品Nexus研发方向为AI原生团队协作操作系统（36氪/新浪科技2026-08-03；希鸥网2026-08-03：[xiouwang.cn](https://xiouwang.cn/oarticle/articles.php?id=7926)）。估值：未披露。
- 原文链接：[finance.sina.com.cn](http://finance.sina.com.cn/tech/roll/2026-08-03/doc-inikytnt6351138.shtml)；[k.sina.com.cn](https://k.sina.com.cn/article_7857201856_1d45362c001908i07a.html?from=tech)；[xiouwang.cn](https://xiouwang.cn/oarticle/articles.php?id=7926)；[iyiou.com](https://www.iyiou.com/data/202608031137007)
- 投资/合作视角：这是一个极早期、技术创始人驱动的Agent基础设施项目，适合小额跟踪或与内部AI研发/运营团队做试点验证。关键风险在商业化路径：需尽调Nexus是否已有可演示产品、接入哪些工具链、客户愿付费的具体岗位/流程，以及治理评测机制是否足以支撑生产环境。

---

### 破壳机器人 PokeBot（中国 · 家庭具身智能/AI硬件）
- 详见 TOP5，本节不重复展开。

---

### 方石机器人（中国 · 智能建造机器人/垂直具身智能）
- 一句话定位：以建筑施工刚需为入口的智能建造机器人公司，用“具身智能+建筑大模型”把机器人规模化带入地坪、墙面、铺贴等工地场景。
- 本周动态：2026年8月3日，投资界、证券时报、 新浪财经等披露北京方石机器人完成数千万元A+轮融资，投资方为济南鹊华科创投，资金主要用于新生产基地建设和产能扩充；本轮紧接其5月近亿元A轮，是公司从产品商业化加速到海外市场拓展和规模交付阶段的重要进展。
- 产品深研：方石机器人全栈自研智能建造机器人系统，围绕建筑施工现场的非结构化、动态、高危低效痛点，形成地坪施工、墙面处理、地砖及石材铺贴等模块化产品矩阵。技术路线是“具身智能+建筑大模型”：将环境感知、任务规划与机器人执行打通，形成从场景理解、产品开发到工程应用的闭环；其自研软硬件结合系统“阿尔戈斯系统”搭载灵光K1三维重建模块与高性能规划主机，融合多线激光雷达、4目视觉和自研神经网络算法，能在施工现场做360°移动扫描和智能规划。投资界5月报道披露，该系统相对精度1.2厘米、绝对精度3厘米，可在15分钟内完成单户型全流程智能规划并生成施工方案，发送给机器人终端执行。
- 融资记录：公司2019年成立。2026年5月13日完成近亿元A轮融资，由北京科创亦庄直投基金、航发基金等联合投资，资金用于核心产品研发迭代、批量化生产交付和海外市场体系布局。2026年8月3日完成数千万元A+轮融资，投资方济南鹊华科创投，资金用于济南新生产基地建设和产能扩充。估值未披露；按A/A+轮融资规模与垂直机器人公司阶段判断低于10亿美元，但需后续关注是否因具身智能热度被快速重估。
- 创始人：创始人为李思桥。其对建筑机器人产品化的核心判断是“标准化产品+参数化适配”和“平台通用化、应用场景化”：每款标准产品适配多种材料和施工工艺，并通过通用算法和运动平台做模块化增量开发，缩短研发周期与量产爬坡时间。团队能力体现为既懂建筑工艺、施工规范和现场工况，又能把多模态感知、运动控制和行业大模型嵌入可交付硬件。
- 竞争力：方石不是单纯Demo型人形机器人，而是已在建筑场景跑出商业化的垂直具身智能公司。2026年5月资料显示公司已服务中国建筑、中国铁建等100余家头部建筑企业，落地超500个标杆工程，累计施工面积突破1500万平方米，并进入中东、东南亚、东亚等十余个国家和地区市场；全国80多个城市有业务布局。其“机器人本体销售/租赁+完整施工服务解决方案”能覆盖成熟客户、试用客户和施工服务客户，平均投资回收期被报道为12个月以内。风险在于建筑业客户对稳定性、可靠性、经济性极敏感，产能扩张后若交付质量波动，会损害口碑；海外市场还涉及本地工法、售后和渠道建设。
- 赛道分析：建筑业是劳动力老龄化、工地安全和降本增效压力集中的传统行业，适合用机器人替代高强度、重复性、高危作业。与家庭机器人相比，建筑机器人任务边界更明确、ROI可量化，但现场非结构化程度又高于工业产线，因此“建筑大模型+具身执行”具备垂直壁垒。未来1-2年，智能建造机器人会从单机工具走向系统化施工方案，能拿到头部总包、劳务班组和海外渠道的公司更容易穿越具身智能泡沫。
- 关键数据：2019年成立（投资界2026-05-13：[news.pedaily.cn](https://news.pedaily.cn/202605/563803.shtml)）；2026年5月近亿元A轮，北京科创亦庄直投基金、航发基金等投资（投中网2026-05-13：[m.chinaventure.com.cn](https://m.chinaventure.com.cn/news/113-20260513-391337.html)）；2026年8月3日数千万元A+轮，济南鹊华科创投投资，资金用于新生产基地和产能扩充（投资界2026-08-03：[news.pedaily.cn](https://news.pedaily.cn/202608/567188.shtml)；证券时报2026-08-03：[stcn.com](https://www.stcn.com/article/detail/4054464.html)）；服务100余家头部建筑企业、超500个工程、累计施工面积1500万平方米、业务覆盖80多个城市、出海十余个国家和地区、平均回本周期12个月以内（投资界2026-05-13）。估值：未披露。
- 原文链接：[news.pedaily.cn](https://news.pedaily.cn/202608/567188.shtml)；[finance.sina.com.cn](https://finance.sina.com.cn/jjxw/2026-08-03/doc-inikzuyp2714116.shtml)；[stcn.com](https://www.stcn.com/article/detail/4054464.html)；[news.pedaily.cn](https://news.pedaily.cn/202605/563803.shtml)；[m.chinaventure.com.cn](https://m.chinaventure.com.cn/news/113-20260513-391337.html)
- 投资/合作视角：方石适合关注“AI+传统行业落地”的投资/产业合作，尤其是建筑央国企、地产施工和海外工程渠道。它的信号不在炫技，而在工程项目数量、回本周期和产能扩张；风险是工地交付重、售后重，需尽调单项目毛利、设备故障率、租赁回款和海外服务能力。

---

### 昆腾动力 Quantum Dynamics（中国 · Physical AI/物流具身智能）
- 一句话定位：菜鸟前CTO李强创立的Physical AI系统公司，从物流仓储真机部署切入，构建世界动作模型、数据飞轮和机器人集群自进化平台。
- 本周动态：2026年7月31日，36氪硬氪、钛媒体智客、智东西等披露昆腾动力成立仅月余即完成超亿元种子轮融资，由云启资本与商汤科技联合投资，多维资本参与孵化与团队组建。资金将用于Physical AI核心技术研发、人才梯队建设和全球化市场拓展，加速面向物理世界的智能系统从底层模型到场景化落地的全链路构建。
- 产品深研：昆腾动力不是单纯造一台机器人，而是做“机器人本体+模型+系统”的Physical AI平台。其首个落地场景是物流仓储，切入包裹称重、贴面单、翻面供包、补货上架、拣货下架、装箱打包等人力密集环节，并规划从仓库/分拨中心的封闭场景，走向网点门店半开放场景，再到末端送货上门全开放场景。技术上，公司自研具身原生World-Action Model，联合建模视觉、动作、本体状态和触觉信号，让模型学习“一次操作如何改变物理世界”；同时配合数据归集、模型更新、HITL、World Model Corrector、Test-Time Training、集群协同进化等模块，形成“真机部署—高价值数据自动识别回传—训练评测—模型更新—机群迭代”的闭环。李强还表示预计推出3-4B世界模型，第一代机器人预计2026年9月30日前推出。
- 融资记录：公司成立于2026年上半年/成立仅月余（36氪、钛媒体），2026年7月31日前后完成超亿元种子轮融资，云启资本与商汤科技联合投资，多维资本参与孵化与团队组建。公开报道未披露估值；种子轮虽达到超亿元，但仍属早期公司，未见10亿美元以上估值信息，本报告按估值未披露且低于10亿美元纳入。
- 创始人：创始人兼CEO李强在阿里巴巴体系任职17年，曾任菜鸟集团CTO、阿里国际数字商业板块CTO，管理全球数千人研发团队，并兼任菜鸟无人车总经理，推动L4无人车运营规模做到千台以上，与海外200个国家的邮政系统有业务对接经验。核心团队覆盖前沿研究、模型研发、硬件工程和全球商业落地：钛媒体称CTO来自头部自动驾驶公司在线算法负责人，首席科学家具北美具身智能实验室背景，硬件负责人来自上市公司人形机器人事业部，商业化负责人为马里兰大学物理系博士，曾在Meta和亚马逊做算法专家并创业服务联想、韩国乐天等客户。
- 竞争力：昆腾动力的护城河假设是“物流真实场景数据+规模化真机部署+系统工程”，而不是单纯模型参数。菜鸟无人车时期沉淀的数据采集、秒级检索、自动标注、训练、评测、发布和车队调度经验，可迁移到仓储机器人群；物流任务高频、反馈清晰、ROI可量化，适合作为Physical AI从垂直场景走向通用的训练场。风险在于公司成立时间极短，技术路线和机器人本体尚待验证；物流仓储客户对节拍、稳定性、安全和成本极敏感，若首代产品不能达到PMMF，数据飞轮难以启动。
- 赛道分析：Physical AI与Agentic AI不同，机器人天然受场地、地域、作业规则和安全约束分割，短期胜负不在“无所不能”，而在选定场景内可稳定部署、可持续产生真实数据。IDC数据被36氪引用称，2025年中国具身智能机器人用户支出预计超过14亿美元，到2030年将达770亿美元，年复合增长率94%；但物理世界数据无法像文本图像一样爬取，因此先部署真机、降低单位数据成本的团队更可能形成长期壁垒。未来1-2年，物流、仓储、工业产线会成为Physical AI最先兑现商业价值的场景。
- 关键数据：2026年上半年成立、成立仅月余完成融资（36氪2026-07-31：[m.36kr.com](https://m.36kr.com/p/3917874427555457)；钛媒体2026-07-31：[tmtpost.com](https://www.tmtpost.com/8086408.html)）；超亿元种子轮，云启资本与商汤科技联合投资，多维资本参与孵化（同上）；李强阿里17年、曾任菜鸟CTO/阿里国际数字商业CTO/菜鸟无人车总经理，菜鸟无人车千台以上L4运营（钛媒体2026-07-31）；第一代机器人预计2026年9月30日前推出、2026年底1-2个场景达到PMMF、2027年目标1000台机器人每天在物理世界工作（钛媒体2026-07-31）；IDC预测2025年中国具身智能机器人用户支出14亿美元、2030年770亿美元、CAGR 94%（36氪2026-07-31）。估值：未披露。
- 原文链接：[m.36kr.com](https://m.36kr.com/p/3917874427555457)；[tmtpost.com](https://www.tmtpost.com/8086408.html)；[m.zhidx.com](https://m.zhidx.com/p/581331.html)；[app.dahecube.com](https://app.dahecube.com/nweb/news/20260731/282123n38834cbe44c.htm)；[rccaijing.com](https://rccaijing.com/news-7488841414764852237.html)
- 投资/合作视角：这是“产业一号位+超早期大额融资+Physical AI实干场景”的强信号项目，适合与物流、仓储、跨境电商和工业自动化资源联动跟踪。核心尽调应落在首代构型、真实客户试点、每小时作业效率、安全停机率、单机BOM、数据闭环是否自动化，以及2026年底PMMF目标能否兑现。

---

### 🇪🇺 欧洲+以色列

### Aavalynx（英国 · AI LegalTech / 争议风险管理）
- 一句话定位：Aavalynx 是面向企业法务、律所与诉讼资助方的 AI 争议风险智能平台，把分散的争议数据结构化，用证据约束的 AI 帮助企业提前识别诉讼风险、控制法律支出并改善争议结果。
- 本周动态：2026-08-04，Tech.eu 报道 Aavalynx 完成 150 万英镑 / 约 175 万欧元 pre-seed 融资；EU-Startups、TechFundingNews、Nonbillable 等同日/近同日报道交叉确认金额与方向。Tech.eu 原文披露本轮由 European Omega Ventures 领投，West Coast 的 Two Ravens 参投，并有资深律所合伙人、前 Amazon 欧洲负责人等天使参与。公司成立于 2023 年，2024 年商业化上线，本轮资金用于把法律争议从“事后高成本处理”前移到“组合级风险管理”。
- 产品深研：Aavalynx 的产品不是通用法律 Copilot，而是围绕 dispute resolution 构建的企业级控制台：把案卷、合同、往来文件、外部律所工作、财务专家意见与本地法律团队输入集中到一个 repository，再用 AI 做结构化、分析、追问和证据引用。Tech.eu 访谈中创始人 Hanna Roos 将其类比为“飞机驾驶舱控制面板”：企业法务负责人需要看到争议组合中每个案件的事实、证据、风险、成本和下一步动作，而不是被外部律所按小时计费牵着走。技术上，公司强调 grounded AI：只基于用户上传的相关争议文件回答，每个结论链接回源文档和具体引用，避免通用 LLM 在法律场景中捏造案例或引用。产品还在开发 billing analytics，让客户不只看工时，而能理解法律工作如何创造价值、哪些争议可提前解决、哪些业务流程造成重复风险。
- 融资记录：公开可核验融资为 2026-08-04 pre-seed 150 万英镑 / 约 175 万欧元，European Omega Ventures 领投，Two Ravens 参投，另有资深律所合伙人和前 Amazon 欧洲负责人等天使投资人。此前轮次未公开披露。估值未披露；按 pre-seed 阶段和融资额判断远低于 10 亿美元，未见独角兽估值证据。
- 创始人：创始人兼 CEO Hanna Roos 拥有近 20 年复杂高风险国际争议经验，曾在 Freshfields、Latham & Watkins、Quinn Emanuel 等顶级律所处理重大争议。她的创业动机来自三类结构性问题：律所按小时计费导致效率与客户目标错位；企业法务缺少可系统化分析争议组合的数据；律师职业长期高压且容易被流程性劳动消耗。Two Ravens 投资人 Isaac Kato 评价其既有深厚 disputes expertise，也组建了由国际争议律师和 Nordic tech specialists 构成的团队。
- 竞争力：Aavalynx 的护城河在于垂直场景深度和创始人领域经验。Harvey、Legora 等法律 AI 多聚焦律师生产力，而 Aavalynx 直指企业争议组合的财务风险：30% 企业外部法律支出用于诉讼，80% 公司在 2025 年至少涉及一起诉讼，2026 年企业法务调查中 46% 以上预计诉讼增加。若其能用结构化争议数据帮助企业提前三年解决争议、减少数千万美元法律费或保住合同声誉，ROI 会非常明确。风险在于法律 AI 销售周期长、数据高度敏感、不同法域流程复杂，且输出必须可解释、可审计、可被律师复核；产品若不能进入客户真实争议工作流，就会停留在咨询式工具。
- 赛道分析：法律 AI 正从“律师写作/检索提效”进入“企业法务经营指标化”阶段。未来 1-2 年，胜出的法律 AI 不只减少起草时间，而会绑定预算、风险暴露、胜败概率、和解策略、外部律所绩效等商业指标。Aavalynx 卡位 dispute intelligence，市场不如通用 legal copilot 大众化，但高客单价、高痛点、高数据壁垒明显；适合从大型跨国企业、诉讼密集行业、争议基金与顶级律所生态切入。
- 关键数据：150 万英镑 / 约 175 万欧元 pre-seed（Tech.eu，2026-08-04）；成立 2023、商业化上线 2024（Tech.eu，2026-08-04）；30% 企业外部法律支出用于 litigation，80% 公司 2025 年至少有一起 lawsuit，46%+ 企业法务预计诉讼增加（Tech.eu 引用 ACC/Norton Rose Fulbright 资料，2026-08-04）；投资方 European Omega Ventures、Two Ravens、资深律所合伙人与前 Amazon 欧洲负责人等天使（Tech.eu，2026-08-04）。估值未披露。
- 原文链接：[tech.eu](https://tech.eu/2026/08/04/legal-ai-startup-aavalynx-raises-ps15m-to-cut-the-cost-of-corporate-disputes/)；[eu-startups.com](https://www.eu-startups.com/2026/08/female-founded-ai-legaltech-startup-aavalynx-raises-e1-75-million-to-bring-death-to-disputes)；[techfundingnews.com](https://techfundingnews.com/aavalynx-1-5m-pre-seed-legal-ai-dispute-resolution/)；[nonbillable.co.uk](https://www.nonbillable.co.uk/news/city-lawyer-disputes-ai-startup-hanna-roos-aavalynx)；[aavalynx.ai](https://www.aavalynx.ai/)
- 投资/合作视角：Aavalynx 是法律 AI 中更接近“企业财务风险控制”的早期标的，适合与大型企业法务、争议基金、国际律所和合规咨询资源做 PoC。投资侧重点看真实案件数据接入难度、AI 引用准确率、客户是否愿意把核心争议组合放进平台，以及能否用节省法律费/缩短争议周期证明 ROI。

---

### Sigvi（立陶宛 · AI 车队运营 / 出行平台）
- 一句话定位：Sigvi 是面向独立车队运营商与私人车主的 AI 租车运营系统，用动态定价、自动预订、无钥匙取车、自动验车、预测性维护和客服自动化，把碎片化车辆连接到欧洲旅行需求。
- 本周动态：2026-07-29，Tech.eu 报道 Sigvi 完成 120 万欧元 pre-seed 融资，由 Superhero Capital 领投，Lithuanian Business Angel Network 主席、Carbon War Room 联合创始人 Vladas Lašas 及其他天使参投；EU-Startups、Vestbee、AIPressRoom 等在窗口期内交叉报道。Sigvi 2026 年 6 月在波兰启动运营，目前管理 200 多辆车，计划用新资金继续开发 AI 自动化平台并扩大欧洲车辆网络。
- 产品深研：Sigvi 的产品不是自己买车重资产运营，而是把现有独立车队和私人车辆聚合到一个 AI revenue agent / operating system 中。平台自动处理车辆上线、动态定价、订单、无钥匙 24/7 取还车、自动车辆检查、预测性维护排期和客户支持，目标是让租车像订住宿一样数字化。Tech.eu 报道称，Sigvi 的平台通常比传统国际租车品牌便宜约 30%，同时提高已有二周期车辆利用率；Vestbee 报道补充其目标是在两年内把管理车辆从 200 多辆扩至 2,000 辆。产品差异在于同时服务供给侧和需求侧：对车主/独立车队，它提供自动运营和获客；对旅行者，它提供更便宜、更数字化、更灵活的取车体验。
- 融资记录：本轮为 2026-07-29 pre-seed 120 万欧元，Superhero Capital 领投，Vladas Lašas 及其他天使投资人参投。此前公开融资未披露。估值未披露；pre-seed 融资额与阶段均显示远低于 10 亿美元，未见独角兽证据。
- 创始人：Tech.eu 披露创始人为 Vytis Šliažas（CEO）、Ignas Gibas（COO）和 Mindaugas Banaitis（CTO）；Vestbee 报道还列出 Darius Verseckas 参与早期创立。团队从立陶宛出发，先切入波兰市场，说明其选择的不是全球通用出行巨头硬碰硬，而是先从欧洲独立租车运营商的数字化缺口入手。CEO Vytis Šliažas 在 Tech.eu 中指出，欧洲旅游强劲复苏，但租车体验没有同步升级，许多优质车辆因缺少技术触达客户而闲置。
- 竞争力：Sigvi 的竞争力在轻资产供给网络与垂直运营自动化。如果能稳定接入区域独立车队，平台可绕开传统租车巨头的资产负担，用软件提升车辆利用率、降低人工柜台/纸质流程成本，并以 30% 价格差吸引游客。其挑战是租车行业线下环节多：保险、损坏责任、车辆清洁、钥匙/硬件、身份验证、跨境法规、当地停车和售后都可能拖累纯软件效率；同时 Turo、传统租车公司、OTA 与本地车队管理软件都可能竞争。
- 赛道分析：欧洲旅游住宿夜数增长与租车流程落后之间形成供需缺口。Eurostat 数据显示 2025 年欧盟旅客在旅游住宿中度过近 31 亿晚，但租车流程仍大量依赖柜台、人工验车和固定价格。未来 1-2 年，AI 出行运营平台会围绕动态定价、无钥匙接入、保险风控、车况识别和需求预测形成垂直闭环。Sigvi 若能把 AI 运营系统沉淀成独立车队的数字基础设施，而不是只做一个租车 marketplace，就有机会形成区域网络效应。
- 关键数据：120 万欧元 pre-seed（Tech.eu、Vestbee，2026-07-29）；Superhero Capital 领投，Vladas Lašas 等天使参投（Tech.eu、Vestbee，2026-07-29）；2026 年 6 月波兰启动运营（Tech.eu，2026-07-29）；当前管理 200+ 车辆（Tech.eu、Vestbee，2026-07-29）；目标两年内扩至 2,000 辆（Vestbee，2026-07-29）；价格通常较传统国际品牌低约 30%（Tech.eu，2026-07-29）；2025 年欧盟旅游住宿近 31 亿晚（Tech.eu 引用 Eurostat）。估值未披露。
- 原文链接：[tech.eu](https://tech.eu/2026/07/29/sigvi-raises-eur12m-to-expand-automated-car-rental-operations/)；[vestbee.com](https://www.vestbee.com/insights/articles/sigvi-lands-1-2-m)；[aipressroom.com](https://aipressroom.com/sigvi-1m-car-rental/)；[eu-startups.com](https://www.eu-startups.com/2026/07/vilnius-based-sigvi-raises-e1-2-million-to-scale-its-ai-powered-car-rental-platform-across-europe)；[sigvi.com](https://sigvi.com/en/)
- 投资/合作视角：Sigvi 是“AI agent 改造传统本地服务运营”的小而美样本，短期不一定是大模型核心资产，但若车辆网络扩张和单位经济模型成立，能成为欧洲碎片化租车供给的运营层。合作可关注旅游、OTA、车队金融和保险；投资风险在于线下履约复杂度和区域扩张速度。

---

### Onyx Security（以色列/美国 · AI Agent 安全控制平面）
- 详见 TOP5，本节不重复展开。

---

### 🌏 新加坡/东南亚+其他

### Smallest.ai（美国/印度团队 · 实时语音AI基础设施）
- 一句话定位：Smallest.ai 用小型专用语音模型和实时架构，为企业客服、金融服务、医疗、联系中心提供低延迟、可私有化部署的语音智能基础设施。
- 本周动态：2026-07-31，公司宣布完成 1,300 万美元 Series A，Seligman Ventures 领投，Sierra Ventures、3one4 Capital 参投；总融资超过 2,100 万美元。TechCrunch 同日/本周报道确认本轮融资，并披露公司成立于 2024 年末、现有客户包括 RingCentral 和 Truecaller；公司博客称本轮将投入实时 speech-to-speech 系统，面向金融服务、医疗、contact centers 等行业。来源：[smallest.ai](https://smallest.ai/blog/series-a-funding-13m-next-generation-voice-ai（2026-07-31)）；[techcrunch.com](https://techcrunch.com/2026/07/31/smallest-ai-raises-13m-to-build-ultra-fast-voice-ai-that-sounds-genuinely-human/（2026-07-31)）。
- 产品深研：Smallest.ai 的核心判断是“语音交互的瓶颈不是模型规模而是架构”：传统 LLM 等待完整输入后再思考，放到电话场景会产生不自然停顿；Smallest.ai 将实时语音小模型作为交互层，让系统边听、边思考、边回应，复杂问题再切给离线大模型处理。产品栈包括 Lightning（TTS）、Pulse（STT）、Electron（SLM）、Hydra/S2S 架构等，CMSWire 披露其支持 speech-to-text、text-to-speech、speech-to-speech、小语言模型，并提供 on-prem/private cloud 部署与 SOC 2 Type II、GDPR、HIPAA、ISO 27001、PCI 等合规能力。3one4 Capital 对早期投资的解读中提到 Lightning 可在 100ms 生成 10 秒类人语音、低于 1GB VRAM 运行，Electron 在实时对话场景质量和延迟上优于 GPT mini；平台强调自有 ASR/SLM/TTS 的全栈整合，而不是拼接第三方组件。
- 融资记录：公开可核实轮次包括：2025-10 左右完成 800 万美元 Seed，Sierra Ventures 领投，3one4 Capital、Better Capital 参投，3one4 称此前还有由 3one4 领投的 pre-seed；2026-07-31 完成 1,300 万美元 Series A，Seligman Ventures 领投，Sierra Ventures、3one4 Capital 参投，Better Capital、Upsparks Capital、Schema Ventures、Tiny VC、DeVC、Mission Street Capital 及天使跟投。总融资超过 2,100 万美元（公司博客与 TechCrunch 一致）。估值未披露；从融资规模和未公布估值看，未见超过 10 亿美元证据，本清单按“估值未披露但显著低于独角兽门槛风险可控”处理。来源：[3one4capital.com](https://3one4capital.com/blogs/precision-over-scale-smallest-ai-and-the-future-of-voice-ai（2025-10-13) 搜索结果/投资方文章）；[smallest.ai](https://smallest.ai/blog/series-a-funding-13m-next-generation-voice-ai（2026-07-31)）；[techcrunch.com](https://techcrunch.com/2026/07/31/smallest-ai-raises-13m-to-build-ultra-fast-voice-ai-that-sounds-genuinely-human/（2026-07-31)）。
- 创始人：TechCrunch 与公司资料显示 CEO/创始人为 Sudarshan Kamath；3one4 与 Sierra Ventures 披露公司由 Sudarshan Kamath 与 Akshat Mandloi 创立，二人是 IIT Guwahati 同学，被投资人评价为 AI researchers。LinkedIn 公共页显示 Sudarshan 曾在 Bosch 做自动驾驶相关高级工程师、Toppr 做产品，并有 ICCV 2021 LVIS Challenge 的 CopyPaste++ 相关发表；公司官网作者页称他在 2023 年创立 Smallest AI，目标是让语音 AI 快、便宜、可规模化。公司博客感谢“nearly 60 people building Smallest AI”，CMSWire 也确认近 60 名员工。
- 竞争力：最大护城河在“低延迟全栈语音闭环 + 企业可部署性”：Smallest.ai 不只是 TTS 或客服应用，而是从 STT、SLM、TTS 到 S2S 的实时架构，目标是在嘈杂环境、多口音、多语言与合规部署中控制延迟和成本。客户信号包括 RingCentral、Truecaller，以及面向金融/医疗/联系中心的私有化合规能力；3one4 披露平台已支撑每月数百万企业通话、TTS 成本从约 0.20 美元/分钟降至 0.01 美元/分钟，性能指标具有可量化吸引力。风险在于 ElevenLabs、Cartesia、Sarvam、OpenAI/Google 等模型厂商和语音应用层公司均会向实时对话延伸，若模型差距缩小，Smallest.ai 必须持续证明企业级部署、成本与延迟优势，而不是被大平台打包替代。
- 赛道分析：实时语音 AI 正从 demo 进入客服、销售、医疗预约、金融合规和呼叫中心生产环境，核心指标从“音色好听”转为“端到端延迟、可打断、抗噪、多语言、合规、成本”。3one4 估算企业每年在 contact centers 和人力资本上花费超过 4,000 亿美元，说明替代/增效空间巨大；但采购方通常要求稳定性、审计、数据隔离和系统集成，给专注基础设施的创业公司留下机会。未来 1-2 年，赛道会从 TTS/STT 单点工具整合为实时 speech-to-speech agent stack，胜者可能是既能与现有客服/CRM 集成，又能提供私有化和可观测性的基础设施公司。
- 关键数据：1,300 万美元 Series A（公司博客/TechCrunch，2026-07-31）；总融资超过 2,100 万美元（公司博客/TechCrunch，2026-07-31）；800 万美元 Seed（3one4/Sierra，2025-10）；近 60 名员工（公司博客/CMSWire，2026-07-31）；RingCentral、Truecaller 客户（TechCrunch，2026-07-31）；Lightning 约 100ms 生成 10 秒语音、低于 1GB VRAM，TTS 成本 0.01 美元/分钟、每月数百万企业通话（3one4，2025-10-13）；估值未披露，未见 ≥10 亿美元证据。
- 原文链接：
  - [smallest.ai](https://smallest.ai/blog/series-a-funding-13m-next-generation-voice-ai)
  - [techcrunch.com](https://techcrunch.com/2026/07/31/smallest-ai-raises-13m-to-build-ultra-fast-voice-ai-that-sounds-genuinely-human/)
  - [3one4capital.com](https://3one4capital.com/blogs/precision-over-scale-smallest-ai-and-the-future-of-voice-ai)
  - [sierraventures.com](https://www.sierraventures.com/content/sierra-ventures-our-early-stage-investment-in-smallest-ai)
  - [cmswire.com](https://www.cmswire.com/customer-experience/smallestai-lands-13m-series-a-for-voice-ai/)
  - [smallest.ai](https://smallest.ai/author/sudarshan-kamath)
  - [linkedin.com](https://www.linkedin.com/in/sudarshankamath)
- 投资/合作视角：这是一个值得关注的“模型基础设施 + 垂直企业落地”标的，融资金额不大但客户和技术指标清晰；若我们有客服、金融、医疗或出海 SaaS 资源，可测试其私有化、低延迟、成本优势。主要风险是大模型厂商快速压低实时语音 API 价格，以及企业采购周期长导致 ARR 扩张不及技术叙事。

---

### Kily（印度 · 电商/快商 Agentic AI）
- 一句话定位：Kily 为消费品牌和电商卖家提供自治 AI agents，跨 Amazon、Flipkart、Blinkit、Zepto、Swiggy Instamart 等平台自动管理 listing、定价、广告、库存与市场运营决策。
- 本周动态：2026-08-04/05 左右，Inc42 披露 Kily 完成 3,000 万卢比（约 320 万美元）融资，由 Sorin Investments 领投，Razorpay 与 Wyser Capital 参投；Economic Times 同步报道确认融资、投资方、用途及客户信号。资金将用于强化产品能力、go-to-market，并加速在印度大型消费品牌中的采用。来源：[inc42.com](https://inc42.com/buzz/agentic-ai-startup-kily-raises-%E2%82%B930-cr-to-accelerate-platform-deployment/（搜索结果显示) 1 day ago，本周窗口内）；[economictimes.indiatimes.com](https://economictimes.indiatimes.com/tech/funding/ai-startup-kily-secures-rs-30-crore-from-sorin-razorpay-wyser/articleshow/132850014.cms（本周窗口内)）。
- 产品深研：Kily 的产品不是简单的 BI dashboard，而是把电商运营拆成一组“可执行 agent”：Listing Manager 检查平台规范、关键词与 SEO，Pricing Manager 根据竞品、流量和销售速率动态调价，Autonomous Ads Manager 自动发现适合投放的 SKU、启动广告并持续调优。官网还列出 RoAS/ACoS 估算、促销与组合建议、价格弹性检查、流量与销售速率跟踪、缺货风险预测、需求预测等工具，核心是把“每小时监控、跨平台比较、即时执行”的运营动作自动化。与传统电商代运营或广告工具相比，Kily 试图在 marketplace 数据、品牌目标、约束条件之间形成闭环决策，让品牌从“看报表后人工执行”转向“AI 24x7 执行并反馈”。
- 融资记录：公开披露的融资为 2026 年本轮 3,000 万卢比/约 320 万美元，Sorin Investments 领投，Razorpay 与 Wyser Capital 参投；Inc42 公司页搜索结果显示 Kily 成立于 2025 年、累计融资约 320 万美元、目前可见仅 1 轮。估值未披露；以融资额、阶段和公开信息判断，未见 ≥10 亿美元估值证据。来源：Inc42 本周融资报道；Economic Times 本周融资报道；Kily 官网。完整轮次：Seed/未明确命名轮次，3,000 万卢比，2026-08，Sorin Investments 领投，Razorpay/Wyser Capital 参投，估值未披露。
- 创始人：Inc42 与 Economic Times 均披露 Kily 由 Sankalp Mehrotra、Anurag Singh、Sharad Chitlangia 于 2025 年创立；Inc42 称三人为前 Flipkart 与 Affle 高管，Economic Times 进一步写到创始团队来自 Flipkart、Amazon、Affle。这个背景与 Kily 的问题域高度匹配：创始团队熟悉 marketplace 流量分发、广告、价格、库存与品牌商运营痛点，也理解印度电商/quick commerce 平台碎片化带来的执行复杂度。CEO Sankalp Mehrotra 在报道中强调品牌和 online sellers 每天需要在多个 marketplace 上做成千上万次决策，Kily 要把 commerce management 带入自治执行阶段。
- 竞争力：Kily 的早期竞争力来自“印度电商/快商平台本地化 + 可执行 agent”的组合：它直接支持 Amazon、Flipkart、Blinkit、Zepto、Swiggy Instamart 等平台，切入品牌方最痛的增长和利润杠杆——listing 可见性、广告效率、动态价格和库存可得性。客户方面，Inc42 与 ET 均披露公司已与 ITC 等消费品牌合作，说明并非纯概念产品。风险在于电商平台本身也在加强广告自动化和 seller tools，第三方工具需要稳定 API/数据访问和可解释 ROI；同时 Kily 仍处非常早期，若 agent 自动执行出现价格误判、库存误判或广告浪费，品牌客户会要求强审计与人类审批机制。
- 赛道分析：印度电商与 quick commerce 正在进入高频运营阶段，品牌需要同时管理搜索排名、广告竞价、促销、库存、竞品价格与多平台差异，人工或传统 SaaS 很难做到小时级响应。Inc42 报道指出印度 AI 创业公司 2026 年上半年融资 6.76 亿美元、同比 4 倍增长，企业 workflow agent 与 commerce agent 是资金关注方向之一。未来 1-2 年，电商 AI agent 赛道会从“建议型 analytics”走向“带 guardrails 的自动执行”，关键胜负手是可接入平台数量、对 GMV/RoAS/毛利的直接提升、以及对品牌内部审批与财务流程的适配。
- 关键数据：3,000 万卢比融资/约 320 万美元（Inc42、Economic Times，本周）；投资方 Sorin Investments、Razorpay、Wyser Capital（Inc42、ET，本周）；成立年份 2025（Inc42/ET）；创始人 Sankalp Mehrotra、Anurag Singh、Sharad Chitlangia（Inc42/ET）；支持 Amazon、Flipkart、Blinkit、Zepto 等平台（官网/ET）；已合作 ITC 等品牌（Inc42/ET）；官网价格示例 Lite 3,500 美元/年起、Advanced 10,000 美元/年起、Expert 20,000 美元/年起并可叠加 GMV outcome-based 收费（官网，页面发布 2026-03-17）。估值未披露，未见 ≥10 亿美元证据。
- 原文链接：
  - [inc42.com](https://inc42.com/buzz/agentic-ai-startup-kily-raises-%E2%82%B930-cr-to-accelerate-platform-deployment/)
  - [economictimes.indiatimes.com](https://economictimes.indiatimes.com/tech/funding/ai-startup-kily-secures-rs-30-crore-from-sorin-razorpay-wyser/articleshow/132850014.cms)
  - [kily.ai](https://www.kily.ai/)
  - [inc42.com](https://inc42.com/buzz/from-freehand-to-sids-farms-indian-startups-raised-142-mn-this-week/)
- 投资/合作视角：Kily 是“AI agent 进入电商经营核心动作”的早期样本，融资小、估值未披露，若其能把 ITC 这类大客户做成可量化案例，下一轮会很快。适合关注印度/东南亚品牌出海、电商服务商和支付/广告生态合作；风险是平台政策、数据接入、自动执行容错和早期团队交付能力。

---

### Freehand（美国/印度创始团队 · 企业供应链支出管理 AI Agents）
- 详见 TOP5，本节不重复展开。

---

## 📊 本周创业市场观察

本周最强的信号不是单一模型能力，而是 AI 正在进入企业和物理世界的“可执行层”：浏览器代理、私募信贷运营、供应链支出、企业 AI 部署、AI 安全控制面、车队/电商运营、家庭与物流机器人，都在把 AI 从建议、检索和生成推进到有权限、有审计、有 ROI 的流程闭环。

从投资视角看，估值仍低于 10 亿美元但已经出现强客户/收入/部署数据的公司更值得优先跟踪：Onyx、Freehand、Intelligence、Smallest.ai、方石机器人都给出了可量化信号；同时中国侧的破壳机器人、昆腾动力、丘脑智能、奇点逃逸代表“具身智能 + Agent 基础设施”继续升温。风险也同样集中：浏览器/Agent/AI 网关/法律 AI 等赛道容易被平台厂商快速复制，具身智能和企业流程 AI 则需要用真实交付、稳定性、合规与毛利证明不是融资叙事。

---

## 📋 关于本周报

- 数据口径：仅纳入估值低于 10 亿美元，或估值未披露但按融资阶段、总融资额、公开描述推断未达独角兽的 AI 创业公司；估值未知均不作确定估值。
- 时间口径：本期覆盖 2026-07-29 00:00 至 2026-08-04 24:00（上海时间）窗口内真实发生的融资、产品、客户、榜单或重大动态。
- 来源说明：优先采用公司公告、官网、TechCrunch、Tech.eu、36氪、投资界、证券时报、TechCrunch/Yahoo 转载、媒体交叉报道与投资方资料；融资额、轮次、创始人背景和关键指标均保留来源链接。
- 下期预告：继续跟踪 AI Agent 安全控制面、企业 AI operator、具身智能真实交付、AI 语音基础设施与多模态评测数据飞轮。
