---
report_type: research_master
window: 2026-09-01 ~ 2026-09-07
read_date: 2026-09-08
public_boundary: frozen
---

# 具身智能机会雷达周报（研究母稿）

> **本期时间窗**：2026-09-01 00:00—2026-09-07 24:00（Asia/Shanghai）
> **阅读日**：2026-09-08
> **定位**：面向拥有软件工程与 AI Agent 背景的入局者，区分论文结果、公司主张、客户试点、生产部署和可审计商业结果。
> **公开边界**：正文与来源链接为 `PUBLIC_CONTENT`；检索数量、内部文件清单和编辑审计为 `AUDIT_METADATA`；内部路径、团队代号与执行过程为 `PRIVATE_INTERNAL`，不得进入博客。

## 0. 研究门控与证据边界

本期研究门控结果为 **PASS**。

- **覆盖**：技术、产品、投资、政策、市场、用户、机会 7/7；产业链/技术栈 8/8。
- **技术**：候选 28 条、12 类入口、精读正文 21 份、一级来源 12 个；重点深拆 AnyWorld、REFACTOR-VLA、NS-VLA、LIBERO-Recover、GigaBrain-0.7，并补强 EmbodiedSkills、RoboSPA、World Labs Atlas，共 8 个对象。
- **产品**：候选 27 条、12 类入口、精读正文 20 份、一级来源 11 个；深拆 7 个产品/部署对象，超过 5 个硬门槛。
- **投资/市场/用户**：候选 21 条，其中严格窗内 13 条；精读正文 30 份，采用一级/原始发布主体 12 个、独立编辑来源主体 18 个。计划、承诺、试点和已交付均已分层。
- **政策**：精读 15 份官方/权威正文，覆盖中国、美国、欧盟、日本、韩国、新加坡；正式政策/标准 4 份。海外无专项新政处均明确写“本周未检出重大公开新政”，不外推为绝对没有。
- **抽查**：四组正文、台账与完成标记均已回读；重点技术、产品、融资和政策来源超过 10 份正文级材料。
- **主要缺口**：多数部署未披露节拍、在线率、MTBF、人工接管率、TCO 和审计 ROI；论文多为仿真或小样本真机；若干融资和市场规模为单源或公司口径。

## 1. 本周一句话

**具身智能的竞争重心正在从“单次成功演示”转向可验证的运行系统：数据要包含失败与干预，任务要有结构化计划，执行要有前后置契约与恢复评测，商业化则必须用客户工序、人工介入和持续运行指标验收。**

## 2. TOP 5 可复核信号

### TOP 1｜失败恢复成为独立 benchmark：LIBERO-Recover（全球·技术）

- **本周动态**：论文与项目页于 2026-09-04 发布。
- **原始证据**：[arXiv](https://arxiv.org/abs/2609.05178)、[HTML 正文](https://arxiv.org/html/2609.05178v1)、[项目页](https://liulin815.github.io/LIBERO-Recovery/)。
- **关键数据**：从多模型自然执行失败中形成 2,178 个恢复场景、16 个评测维度；4 名遥操作员在 413 个失败场景采集 3,184 条恢复示范、625,731 帧。六个代表模型在真实失败状态上性能都下降超过 50%；动作 chunk 从 4 增至 32 时恢复率持续下降。
- **为什么重要**：机器人排行榜接近满分，不等于故障后还能继续完成任务。生产验收应同时报告恢复成功率 RSR、失败前后退化 RD 和跨失败状态一致性 RC。
- **证据边界**：这里的“真实失败”是模型在 LIBERO 仿真中自然产生的失败，不是真机事故；项目页截至阅读日未见明确下载入口。
- **软件/Agent 机会**：把真实失败 trace 编译为恢复态回归集，保留初始状态快照，按 retry、adapt、state repair、environment repair 分级，并以短 chunk、高频状态重读和补偿事务提升恢复能力。

### TOP 2｜人类视频开始被编译为机器人原生经验：AnyWorld v2（中国·技术）

- **本周动态**：arXiv v2 于 2026-09-01 发布。
- **原始证据**：[arXiv](https://arxiv.org/abs/2608.29242)、[HTML 正文](https://arxiv.org/html/2608.29242)、[项目页](https://xpeng-robotics.github.io/anyworld/)。
- **技术路线**：将第一视角交互拆为动作、相机几何和执行体上下文，用 latent video diffusion/DiT 重组为目标机器人视觉经验，再与语言和标定动作组成策略训练数据。
- **关键数据**：world-model 可控性 0.778；RoboCasa GR1 18 个任务成功率 49.8%→54.6%；IRON 真机 20 次抓取试验 20%→55%。
- **为什么重要**：world model 从“预测未来”转向针对策略缺口生成训练经验，可能降低跨本体真实数据成本。
- **证据边界**：接触物理与动力学仍近似，真机仅 20 次，论文页未给出可直接下载的代码/权重入口。
- **软件/Agent 机会**：将失败日志拆成动作、视角、执行体与上下文，自动生成同观察、不同指令和动作的反事实回归集。

### TOP 3｜真实包装线给出比展会更强的客户证据：CJ Logistics × Olive Young（韩国·产品）

- **本周动态**：9 月 3 日，CJ Logistics 在 Olive Young 龙仁物流中心部署两台双臂人形机器人，在真实订单包装线上放入缓冲纸。
- **证据**：[Seoul Economic Daily](https://en.sedaily.com/finance/2026/09/03/cj-logistics-deploys-humanoid-robots-at-warehouse-in-korean)、[The Korea Times](https://www.koreatimes.co.kr/business/companies/20260903/cj-logistics-deploys-humanoid-robots-at-warehouses-in-korea)、[Humanoid Guide](https://humanoid.guide/cj-logistics-deploys-two-humanoids-on-olive-young-packing-line/)。
- **阶段判断**：**两台、单工序的小规模生产部署**，高于受控测试，但不是规模部署。
- **技术/产品栈**：Robotis 本体、Aidin Robotics 机器人手、CJ 控制技术与 RealWorld AI 的 Robot Foundation Model；公开描述为融合视觉、传感器和仿真数据。
- **为什么重要**：价值不在“像人”，而在复用为人设计的工位，并以真实包装数据迭代跨 SKU 泛化。
- **未披露**：节拍、吞吐、成功率、在线率、人工介入、MTBF、售价、租赁和单位订单成本均未公开。
- **软件/Agent 机会**：做按工序计费的验收与运维平台，把每小时合格箱数、每千箱介入次数、重试率、占线时间和版本回滚关联起来。

### TOP 4｜机器人智能控制栈首次以国家标准分层：GB/T 47245—2026（中国·政策）

- **本周动态**：GB/T 47245—2026《机器人智能控制系统总体架构》于 2026-09-01 实施。
- **官方来源**：[市场监管总局](https://www.samr.gov.cn/xw/zj/art/2026/art_26c874532f4c4f318d3dcaf04e7cdfac.html)、[上海市药监局转载清单](https://yjj.sh.gov.cn/zjyw/20260901/4eafb0cb26424fdfa60955a00a.html)。
- **核心内容**：从硬件层、操作系统层、中间层到算法层规定机器人智能控制系统的逻辑架构与主要功能。
- **为什么重要**：项目技术规范、接口适配、测试验收和招投标语言可能逐步采用分层表达，为国产边缘芯片、实时 OS、中间件、运动控制和安全组件提供按层接入机会。
- **边界**：这是推荐性国标，不等于立即实施强制认证。
- **软件/Agent 机会**：围绕分层接口做一致性测试、能力描述、时延预算、版本兼容、仿真模型、SBOM 和合规证据生成。

### TOP 5｜资本开始为“模型—感知—仿真—部署”分层定价（全球·市场）

- **Figure × Nscale**：9 月 3 日宣布多年度算力合作，潜在最多 100,000 枚 NVIDIA GPU，初始计算承诺 35 亿美元，可扩至超过 60 亿美元，首批目标为 2027 年下半年；这是未来承诺，不是现金融资或已安装算力。来源：[Nscale](https://www.nscale.com/press-releases/nscale-and-figure)、[Reuters](https://www.reuters.com/technology/ai-cloud-firm-nscale-commits-compute-worth-35-billion-figures-robotics-ambitions-2026-09-03/)。
- **PlusAI**：拟通过 SPAC 上市，投前股权估值约 8 亿美元，潜在资本约 3 亿美元；HyperFoundry 公司披露已产生 2,500 万美元收入。交易仍受赎回、监管和交割条件影响。来源：[交易公告](https://www.cohencm.com/news/plusai-a-leader-in-physical-ai-pioneering-ai-based-virtual-driver-software-to-become-publicly-listed-through-business-combination-with-texas-ventures-acquisition-iii-corp)、[CNA/Reuters](https://www.channelnewsasia.com/business/autonomous-trucking-software-firm-plusai-go-public-in-800-million-spac-deal-6360441)。
- **Lyte**：完成 1.65 亿美元 C 轮、投后估值 16 亿美元，资本投向同步感知芯片、4D coherent vision 与空间软件。来源：[Globes](https://en.globes.co.il/en/article-physical-ai-perception-co-lyte-raises-165m-at-16b-valuation-1001554229)、[Pulse 2.0](https://pulse2.com/lyte-raises-165-million-series-c-at-1-6-billion-valuation/)。
- **判断**：资本结构不再只押机器人本体，也押感知、数据、仿真、算力和部署。对软件团队，更可行的路线是先以工具收入、RaaS/HaaS 或运维服务验证价值。

## 3. 七面雷达

### 3.1 技术：结构、反馈和恢复比盲目扩参更关键

**REFACTOR-VLA** 于 9 月 1 日提出 wake/sleep 技能归纳：用 latent world model 和行为等价核判断动作片段是否可替换，再以 typed program induction 抽象技能。188M world model 配监督对比目标在 LIBERO 四套件的技能聚类优于所比较基线，但扩大到 430M 反而变差。局限是没有真机，LIBERO 又没有 reward 字段，因此论文的 return-preservation gate 未真正受测。近期更适合离线技能挖掘、压缩和审计，而不是替换生产控制器。来源：[论文](https://arxiv.org/abs/2609.01215)、[Apple Research](https://machinelearning.apple.com/research/refactor-vla-motor-programs)。

**NS-VLA v2** 于 9 月 2 日增加 primitive plan、单调 pointer 和分层奖励，把高层里程碑与低层连续动作的信用分配分开。LIBERO 1-shot 平均 69.1，LIBERO-Plus 49.8；代码、Apache-2.0 许可、模型和数据入口较完整。它能限制乱序和跳步，但难以自然表达回退、循环和动态重规划，且没有发现真机结果。来源：[论文](https://arxiv.org/abs/2603.09542v2)、[GitHub](https://github.com/Zuzuzzy/NS-VLA)。

**EmbodiedSkills** 把高层技能选择视为 execution proposal，用可执行技能契约检查 precondition、参数、artifact freshness、状态迁移和 postcondition，并记录恢复。任务适配后的低层 VLA 在 RoboTwin 2.0 平均 86.20%、LIBERO 平均 97.40%，但 RMBench 记忆依赖任务平均仅 12.5%，说明长时持久状态仍是瓶颈。实验主要为仿真，完整 AgentLoop 不能直接继承低层成功率。来源：[论文](https://arxiv.org/abs/2609.01281)。

**RoboSPA** 用空间推理与长程序规划两条难度轴构造 10 类任务、56 个基础任务、280 个难度变体和 527K 轨迹；截至 9 月 8 日官方仓库仍写明代码和数据准备中，因此只能说论文承诺开放，不能说资产已经可复现。来源：[论文](https://arxiv.org/abs/2609.05324)、[GitHub](https://github.com/fanzhenxuan/RoboSPA)。

**GigaBrain-0.7** 的论文、模型主体在窗口外，本周新增训练、benchmark 和 ROS server/client workflow。它以行动控制、理解规划、预测评估三个系统组织 3.5B 多本体 VLA，使用 LeRobot 作为数据交换层，并提供 PiPER/H01 真机客户端和默认 dry-run 安全门。公开资源不等于 37.3k 小时全量训练数据公开；GPU inference server + ROS client 也不是完全端侧。来源：[GitHub](https://github.com/open-gigaai/giga-brain-0)、[论文](https://arxiv.org/abs/2608.15875)、[模型卡](https://huggingface.co/open-gigaai/GigaBrain-0.7-3.5B-Base)。

**World Labs Atlas** 于 9 月 1 日向选定伙伴开放 early access。它用多模态自回归扩散 Transformer 原生处理文本、图像、视频、相机位姿和深度，支持新视角、3D/4D 世界及 real-to-sim。公司没有公开参数、训练数据、可审计数值、机器人闭环成功率、SLA 或成本；少视图补全会产生潜在物理幻觉，不能单独承担安全验证。来源：[官方技术博客](https://www.worldlabs.ai/blog/atlas)。

**技术横向判断**：world model 已从单纯未来预测扩展为经验生成、行为等价判定、subgoal/value 条件和恢复一致性工具。LeRobot 趋向数据交换层，ROS/Isaac/MuJoCo 继续承担执行与仿真；现实部署仍更接近 GPU server + 边缘感知/控制。对 Agent 工程的直接迁移是 typed skill、preflight、postcondition、短 chunk、恢复态回归和 trace provenance。

### 3.2 产品：阶段分层比“有没有机器人”更重要

本周 7 个重点产品/部署对象覆盖预售、概念机、展会演示、客户试点、小规模生产部署和平台多 OEM 采用。

1. **CJ Logistics × Olive Young**：两台机器人进入真实包装线，证据最接近生产，但仍是单工序小规模部署，关键运行指标未披露。
2. **Galbot ET1/G1**：ET1 于 9 月 3 日开订，公司称 24 小时 200+ 预订；这只能证明预售兴趣。G1 在 IFA 做完整取货演示，并有公司称 170+ 无人零售单元、40+ 城市与药房背景，成熟度高于 ET1。ET1 参数又出现 1,230mm/30kg 与 173cm/65kg 冲突，本文采用开订稿口径并保留警示。来源：[开订信息](https://post.smzdm.com/p/avgwzmvn/)、[官方 X](https://x.com/GalbotRobotics/status/2095983489673810356)、[IFA 报道](https://www.techtimes.com/articles/326666/20260904/galbot-g1-ifa-2026-robot-working-real-pharmacy-shifts-brings-china-spy-law-europe.htm)。
3. **Tuya Doova**：9 月 4—5 日在 IFA 发布，面向独居老人，以移动感知、对话、告警和 AIoT 联动为核心。呼救后 60 秒无响应则向家属发起双向视频告警，明确由家属/照护者判断救援。没有价格、上市、家庭试点或长期运行数据，阶段是展会发布/受控展示。来源：[Tuya](https://www.tuya.com/news-details/tuya-smart-brings-full-stack-ai-into-everyday-life-at-ifa-2026-Kfxbtt88aw2t0)、[PRNewswire](https://www.prnewswire.com/news-releases/tuya-smart-unveils-doova-at-ifa-2026-an-ai-home-companion-robot-designed-to-support-independently-living-seniors-302870623.html)。
4. **iRobot Roomba Duo**：主机携带并投放超薄子机，共享地图与维护基站。官方明确称 prototype/concept；现场记者被禁止触摸或查看内部，设备需两人搬运。因此只能视作受控展台概念验证，无价格、发售日和长期耐久数据。来源：[iRobot](https://media.irobot.com/2026-09-04-iRobot-Unveils-Roomba-R-Duo-at-IFA-2026,-Proving-the-Future-of-Floor-Care-Has-a-Familiar-Name)、[The Verge](https://www.theverge.com/tech/990045/irobot-roomba-duo-concept-robot-vacuum)。
5. **Realbotix × 欧洲电信公司**：未具名客户试点人形演讲、活动支持和多人互动；没有客户名、机器人数量、地点、周期、合同额或转采购条件。企业现场的真正成本可能是内容审核、提词、敏感问题拦截、现场安全员与后台接管，而非硬件本身。来源：[GlobeNewswire](https://www.globenewswire.com/news-release/2026/09/03/3355897/0/en/onconetix-acquisition-target-realbotix-launches-pilot-with-leading-european-telecommunications-company-to-deploy-humanoid-robots-in-live-presentations-and-events.html)。
6. **MagicLab**：X1 与 D1 在 IFA 共享模拟生产环境，属于受控 Demo；D1 在追觅工厂执行抓取、跨区运输和上料，是更强的真实部署证据；AliExpress Brand+ 是渠道商业化。订单簿 11 亿元、累计交付 12,000 台、90%+ 长流程成功率等均是公司口径，缺独立审计。来源：[深度报道](https://www.techtimes.com/articles/326650/20260904/magiclab-humanoid-robots-reach-ifa-2026-vla-models-deployed-spy-law-applies.htm)、[渠道公告](https://www.prnewswire.com/news-releases/aliexpress-brand-emerges-as-a-global-launchpad-for-cutting-edge-innovation-at-ifa-2026-302869997.html)。
7. **D-Robotics Sunrise/RDK**：从 5 到 560 TOPS 的芯片、开发板、OS 和软件栈已被 TCL hey AiMe、Vbot SuperDog、xLean TR1 等多个 OEM 采用。终端采用比单纯发布芯片更有意义，但稿件未给出具体板卡、功耗、价格、软件 SLA 和出货拆分。来源：[IFA 一级发布](https://www.prnewswire.com/news-releases/d-robotics-at-ifa-2026-the-computing-platform-powering-the-next-generation-of-home-robots-302869818.html)、[产品页](https://en.d-robotics.cc/)。

**产品判断**：展会 Demo 应看机械耐久、异常恢复和人在环；客户试点应看转采购标准；生产部署应看节拍、在线率、接管率和单位任务成本。预订、渠道合作和公司订单口径均不能替代交付与客户验收。

### 3.3 投资与并购：大算力承诺与窄场景融资并存

除 TOP 5 的 Figure、PlusAI 和 Lyte 外，本周还有三类信号：

- **Hivebotics** 获 600 万美元 A 轮，Abluo 在公司口径下于 20 个站点累计约 10,000 小时，以 5 分钟人工检查替代约 30 分钟人工清洁。融资由媒体确认，但运行小时、站点与节省均未见客户侧运维记录。任务边界与质量验收清晰，使其比开放通用人形更接近商业闭环。来源：[The Business Times](https://www.businesstimes.com.sg/companies-markets/robotics-startup-hivebotics-raises-us6-million-series-round-led-vertex-ventures)。
- **WorldMind** 成立当月获元生资本“数千万元”种子轮，投向世界模型训练基础设施、多模态数据和团队；金额和赛事成绩的报道高度同源，仍是单源待验证。来源：[创业邦](https://www.cyzone.cn/article/845618.html)、[智东西](https://zhidx.com/p/591288.html)。
- **Locus Robotics** 据报 G 轮已募 4,160 万美元，但未找到公司公告或 SEC Form D；估值、规模和用途均需降级为单源待验证。来源：[FinSMEs](https://www.finsmes.com/2026/09/locus-robotics-raises-41-6m-in-series-g-funding.html)。

窗口外但仍有结构价值的背景包括：Motion 以 200 万美元 pre-seed 做 Humanoids-as-a-Service，承担选型、融资、数据、IT 集成、保险、合规和车队管理；Reframe Systems 以机器人微工厂和制造软件切入住宅建造。它们说明“部署运营商”和垂直生产系统可能比通用本体更快形成收费入口。

### 3.4 政策：标准、创业要素与城市级场景同步推进

中国本周出现三条高相关政策线：

1. **GB/T 47245—2026 实施**：机器人控制栈进入分层架构表达，但为推荐性标准。
2. **工信部《人工智能中小企业创业支持计划（2026—2028年）》**：9 月 4 日公开，目标包括新培育科技和创新型中小企业 1 万家以上、专精特新“小巨人”突破 2,000 家，各建设 10 个孵化器、公共服务平台和特色产业集群。与具身智能直接相关的是普惠算力、工业数据、链主场景、孵化空间、耐心资本和安全合规服务，而不是全国统一单企现金补贴。来源：[工信部](https://www.miit.gov.cn/jgsj/qyj/wjfb/art/2026/art_86c400b4473849818629663a94a6d44b.html)。
3. **深圳《推动人工智能与应用发展行动计划（2026—2028年）》**：到 2028 年智能终端/智能体应用普及率超过 90%、AI 核心产业超过 3,000 亿元、企业超过 3,000 家；文件点名人形与服务机器人、养老设备、具身数据平台、世界模型、产业基金和国际标准，但未披露单项补贴上限或新增基金规模。来源：[深圳市政府](https://www.sz.gov.cn/cn/xxgk/zfxxgj/tzgg/content/post_12966979.html)。

海外严格窗口内，没有出现与中国本周三项政策/标准同量级的专项新政。欧盟 9 月 2 日在欧洲议会举行 AI 机器人战略讨论并展示 20—30 台机器人，属于政策议程与协调信号，不是正式立法或新增拨款。美国本周 G20 声明不是机器人专项；日本、韩国、新加坡未检出新增专项政策。韩国 2026 年 Physical AI 预算、日本 AI Robotics Strategy、新加坡 Punggol Digital District 测试场和 NIST 数字孪生标准研究均只能作为窗口外背景。

### 3.5 市场与商业化：政府需求与企业采购都开始要求“工作系统”

- **美国 ARM Institute** 获近 9,000 万美元，为 10 个项目在两年内向 12 个军事制造基地交付可运行方案；每个方案必须包含 workforce readiness。它不是某家机器人公司的订单，而是本周较强的需求侧信号：买方要求机器人/physical AI、培训和组织准备共同交付。来源：[ARM Institute](https://arminstitute.org/news/oib-2026/)。
- **Wandercraft Calvin-40** 公司称已有 12 家蓝筹客户，Renault 计划未来 18 个月部署 350 台。350 台是计划，不是已交付或已验收订单；客户合同额、任务成功率、接管率和每小时成本未披露。来源：[公司稿](https://www.globenewswire.com/news-release/2026/09/04/3356576/0/en/wandercraft-secures-12-calvin-40-customers-as-it-accelerates-commercial-dominance-in-industrial-humanoids.html)。
- **韩国 2027 预算草案** 将半导体、physical AI 和 AI 数据中心列为三大项目，合计 21.3 万亿韩元；媒体对 physical AI 子项给出 5,000 亿与 2.6 万亿韩元两种口径，不能相加，需等官方预算书。预算仍需国会审议，不能当作已拨款合同。来源：[Korea Times](https://www.koreatimes.co.kr/economy/policy/20260901/govt-bets-big-on-ai-chips-for-2027-budget-to-compete-in-global-tech-race)、[Seoul Economic Daily](https://en.sedaily.com/finance/2026/09/01/korea-earmarks-44-trillion-won-for-housing-213-trillion-for)。
- **AGIBOT WORLD 第三期** 据两家媒体报道开放 11,430 条真机交互轨迹、14 类任务，包含成功、失败和人工介入，并有 98,000+ 细粒度状态标注的公司口径。数据产品开始从“成功示范”转向失败、干预和奖励信号，但仍需实际下载、许可和传感器完整性审计。来源：[Interesting Engineering](https://interestingengineering.com/ai-robotics/video-chinese-firm-releases-11430-robot-trajectories-to-advance-research)、[钛媒体](https://www.tmtpost.com/8129653.html)。
- 新华网 9 月 7 日援引业内数据称，2026 年中国人形机器人累计交付客户约 1.5 万台、市场规模 20 余亿元；未附统计方法，按单源待验证。报道更重要的判断是工业客户通常要求 2—3 年回本，99% 成功率在重复任务中仍可能频繁失败。来源：[新华网](https://www.news.cn/tech/20260907/91eff00212a84c0bba1ca6894b460a61/c.html)。

### 3.6 用户：采购条件从能力清单转向失败责任和数据治理

客户侧证据形成六个稳定需求：

1. **任务边界要窄且可验收**：清洁、包装、搬运、导览、实验器具操作更容易定义成功。
2. **连续运行和人工接管优先于单次 Demo**：至少应披露成功率、在线率、接管分钟/运行小时、MTTR 和恢复率。
3. **数据与隐私进入合同**：Osaka Metro 的 Gemini 人形站员实证明确披露 RGBD、麦克风、眼球相机用途与部分数据处理，并提醒生成式回答不保证准确完整。它是客户侧实验，不是正式采购。来源：[Osaka Metro](https://www.osakametro.co.jp/page/20260821_humanoid_ekiin.php)。
4. **养老必须保留责任升级链**：Doova 和 Donut Robotics 的 cinnamon 都应优先做对话、巡逻、告警和护士呼叫分级，不能在 VLA 与安全体系不成熟时承担身体护理。
5. **本地集成、融资和售后不可缺**：GMO AIR 在日本代理 Unitree 时同时提供软件开发、租赁和运维，说明渠道层自身可形成利润池。来源：[GMO AIR](https://prtimes.jp/main/html/rd/p/000005506.000000136.html)。
6. **99% 仍不够**：重复 100 次可能失败 1 次；必须建立安全降级、失败证据链和可撤销操作。

### 3.7 入局机会：优先做控制平面，不与本体厂拼资本

#### 立即学习

1. **ROS2 + LeRobot + 一套仿真环境**：跑通数据采集、策略评测、server/client 和 dry-run，不追求先买昂贵本体。
2. **任务与技能契约**：掌握 typed skill、precondition、postcondition、artifact freshness、补偿事务和单调 workflow pointer。
3. **机器人 SRE 与安全**：学习日志/视频/轨迹关联、SBOM、签名 OTA、最小权限、安全急停、HIL 回归和事故复现。

#### 可做 Demo

1. **VLA Runtime + Replay Debugger**：高层模型只提出技能，运行时做前置检查、权限/空间约束、结果验证与恢复；首版只接 RoboTwin/LIBERO。
2. **Failure Recovery Bench**：把真实失败 trace 生成恢复态用例，输出 RSR、RD、RC、接管率和版本差异。
3. **Real-to-Sim 可信编排层**：连接 Atlas/生成式重建与 Isaac、MuJoCo、ROS、LeRobot，对生成区域做标注、物理负控、批量回放和差异报告。

#### 可找合作

1. 有真实窄工序的物流、清洁、工业系统集成商，先拿失败日志和人工接管数据做验收工具。
2. 本体厂与多 OEM 平台，合作定义跨本体能力描述、动作 schema、标定与驱动兼容测试。
3. 数据/遥操作团队，共建失败、干预、恢复和奖励标签的数据闭环，而不只卖成功示范。

#### 可投资观察

1. 六维力/力矩、触觉阵列、微型执行器、一体化关节等高壁垒部件。
2. 机器人任务编排、车队运维、仿真回归、合规证据与远程接管平台。
3. 能公开客户侧持续运行、复购、接管率和单位任务成本的窄任务机器人公司。

#### 暂不建议

1. 无供应链、客户工序与长期资本情况下从零造通用人形本体。
2. 没有独家数据、客户或硬件渠道的通用 VLA 包装层。
3. 把展会 Demo、预订、框架合作、计划部署和算力承诺直接当作收入或规模化证明。

## 4. 产业链 / 技术栈地图

| 环节 | 本周证据与判断 | 软件 / Agent 切入 |
|---|---|---|
| 上游硬件与供应链 | 力觉、触觉、关节、灵巧手和边缘计算仍决定接触能力、寿命和成本；D-Robotics 展示多 OEM 采用。 | 标定自动化、驱动/BSP、热与功耗观测、供应商兼容测试、数字模型和 SBOM。 |
| 本体与运动控制 | 双足、轮式、双臂、清洁双机各有适用工序；真实工厂仍依赖控制器、ROS 与安全门。 | 动作 mask、限位、坐标/维度适配、HIL、dry-run、异常停机与恢复。 |
| 数据层 | AnyWorld 做跨本体生成，AGIBOT 和 LIBERO-Recover强调失败、干预与恢复数据。 | 轨迹质量评分、失败聚类、数据血缘、许可、LeRobot 转换、反事实集生成。 |
| 仿真与训练基础设施 | Atlas 降低 real-to-sim 捕获门槛，但生成区域存在物理幻觉；RoboSPA/Recover推动复杂度与失败态评测。 | 场景版本化、物理负控、回放、回归、sim-real 差异报告和 ROI 模拟。 |
| 模型与算法 | world model 用于经验生成、技能等价、预测/价值条件；层级计划与短反馈更受重视。 | planner/predictor/executor 接口、typed workflow、置信度路由、memory provenance。 |
| 软件工程与开发工具链 | GigaBrain 展示模型仓、训练评测、server/client、默认 dry-run；EmbodiedSkills展示运行时契约。 | Robotics CI/CD、技能 SDK、replay debugger、可观测性、版本灰度和回滚。 |
| 系统集成与应用层 | CJ 包装线、Hivebotics 清洁、MagicLab 工厂工序表明窄任务先落地；养老/公共空间须保留人在环。 | WMS/MES/SAP/AIoT 适配、SLA、工单、接管调度、隐私与内容安全。 |
| 商业生态 | 大算力承诺与小额场景融资并存；Motion/GMO提示部署运营、融资租赁和本地售后可独立收费。 | 多 OEM 控制平面、按任务计费、合规证据、租赁资产监控和客户 ROI 仪表盘。 |

## 5. 供应链与国产化优先级

1. **力觉/触觉**：六维力/力矩传感器、触觉阵列和电子皮肤需要量产一致性、温漂补偿、封装耐久与自动标定。窗口外权威产业材料称，2025 年中国灵巧手销量约 1.92 万只，2026 年预计 7.02 万只，带触觉产品占比超过 60%；这些数字只作产业背景。
2. **执行器与关节**：无框力矩/空心杯电机、谐波/行星/RV 减速器、行星滚柱丝杠、编码器、伺服驱动和一体化关节决定功率密度、背隙、寿命、热和维修成本。
3. **灵巧手**：不能只比自由度，应比较负载、速度、寿命、触觉、可换指尖、故障诊断和成本。窗口外材料称主流产品单只价格从 2023 年约 5 万元降至约 2 万元，多数寿命在 30 万次以上，但仍未普遍满足工业长期使用。
4. **边缘芯片/实时软件**：重点不是峰值 TOPS，而是确定性时延、功耗、内存带宽、多传感同步、ROS/中间件适配、OTA 和长期供货。
5. **工控安全**：机器人联网、学习和远程更新后，传感欺骗、策略篡改、固件供应链、工业网络横向移动会与机械伤害耦合。设备身份、可信启动、签名固件、VEX/SBOM、异常检测和安全降级将进入采购清单。
6. **数字孪生接口**：国产关节、夹爪、传感器若同时交付数字模型、标定文件、寿命数据和仿真接口，更容易进入主机厂与海外供应链。

## 6. 风险与反共识

1. **恢复能力比干净初态成功率更接近生产价值**：标准任务 90%+ 并不能说明失败后可继续执行。
2. **长任务问题不等于模型不够大**：REFACTOR-VLA 的 430M world model 反而弱于 188M；任务结构、目标函数与反馈频率更关键。
3. **后台人是隐藏成本**：遥操作、内容审核、现场安全员、人工复位、维护和异常处理若不计入 TCO，ROI 会被高估。
4. **生成式世界不等于可信数字孪生**：视觉自洽的深度、遮挡和接触结果可能物理错误，必须与确定性引擎和真机回放对齐。
5. **计划、承诺、预订不等于交付**：Figure 算力、Wandercraft 350 台、ET1 预订、SPAC 潜在资本都不能计为已到账收入或已上线产能。
6. **高风险养老和公共空间不能只靠免责声明**：需要数据目的限制、错误路由、人工接管、责任升级和离线降级。
7. **国产化不能按零件数量统计**：应看成本、技术控制权、关键失效点、工具链、测试与生命周期服务。
8. **定制集成会吞掉毛利**：若每个工厂都重做 WMS/MES/PLC/SAP 和安全适配，出货增长不等于软件利润增长。

## 7. 关键数据来源表

| 数据点 | 数值/结论 | 来源 | 发布时间 | 是否本周 | 验证状态 |
|---|---:|---|---|---|---|
| LIBERO-Recover 场景/示范 | 2,178 场景；3,184 示范 | [论文](https://arxiv.org/abs/2609.05178) | 2026-09-04 | 是 | 论文/项目页，仿真 |
| AnyWorld GR1 | 49.8%→54.6% | [论文](https://arxiv.org/abs/2608.29242) | 2026-09-01 v2 | 是 | 作者结果 |
| AnyWorld IRON | 20%→55%，20 trials | 同上 | 2026-09-01 v2 | 是 | 小样本真机 |
| NS-VLA 1-shot | LIBERO 69.1；Plus 49.8 | [论文](https://arxiv.org/abs/2603.09542v2) | 2026-09-02 v2 | 是 | 作者仿真结果 |
| EmbodiedSkills 低层 VLA | RoboTwin 86.20%；LIBERO 97.40% | [论文](https://arxiv.org/abs/2609.01281) | 2026-09-01 | 是 | 仿真；不代表完整 AgentLoop |
| EmbodiedSkills RMBench | 记忆依赖任务 12.5% | 同上 | 2026-09-01 | 是 | 作者结果 |
| RoboSPA | 527K 轨迹；56 基础任务；280 变体 | [论文](https://arxiv.org/abs/2609.05324) | 2026-09-04 | 是 | 仓库尚未放出代码/数据 |
| CJ 包装线 | 2 台、单工序 | [Seoul Economic Daily](https://en.sedaily.com/finance/2026/09/03/cj-logistics-deploys-humanoid-robots-at-warehouse-in-korean) | 2026-09-03 | 是 | 客户现场；KPI 未披露 |
| Galbot ET1 预订 | 公司称 24h 200+ | [官方 X](https://x.com/GalbotRobotics/status/2095983489673810356) | 2026-09-05 | 是 | 公司口径，非交付 |
| Figure-Nscale | 35 亿美元初始承诺；最多 10 万 GPU | [Nscale](https://www.nscale.com/press-releases/nscale-and-figure)、Reuters | 2026-09-03 | 是 | 双源；未来承诺 |
| PlusAI SPAC | 8 亿美元投前估值；潜在约 3 亿美元资本 | [交易公告](https://www.cohencm.com/news/plusai-a-leader-in-physical-ai-pioneering-ai-based-virtual-driver-software-to-become-publicly-listed-through-business-combination-with-texas-ventures-acquisition-iii-corp)、CNA/Reuters | 2026-09-03 | 是 | 双源；未交割 |
| Lyte C 轮 | 1.65 亿美元；投后 16 亿美元 | [Globes](https://en.globes.co.il/en/article-physical-ai-perception-co-lyte-raises-165m-at-16b-valuation-1001554229)、Pulse2 | 2026-09-02 | 是 | 双源 |
| ARM 项目 | 近 9,000 万美元；10 项目；12 基地 | [ARM Institute](https://arminstitute.org/news/oib-2026/) | 2026-09-03 | 是 | 官方项目总额，非单企订单 |
| 韩国三大 AI 项目 | 21.3 万亿韩元 | Korea Times、Seoul Economic Daily | 2026-09-01 | 是 | 双源；预算草案 |
| 韩国 physical AI 子项 | 5,000 亿 / 2.6 万亿韩元口径冲突 | 同上 | 2026-09-01 | 是 | 待官方预算书 |
| AGIBOT 数据 | 11,430 轨迹、14 类任务 | Interesting Engineering、钛媒体 | 2026-09-03/04 | 是 | 双媒体，仍主要公司材料 |
| 中国人形市场 | 约 1.5 万台、20 余亿元 | [新华网](https://www.news.cn/tech/20260907/91eff00212a84c0bba1ca6894b460a61/c.html) | 2026-09-07 | 是 | 单源，方法未附 |
| 深圳目标 | >90%；>3,000 亿元；>3,000 家 | [深圳市政府](https://www.sz.gov.cn/cn/xxgk/zfxxgj/tzgg/content/post_12966979.html) | 2026-09-04 | 是 | 官方计划目标 |

## 8. 下周跟踪指标

1. LIBERO-Recover、RoboSPA 是否实际开放数据、代码和许可证；是否出现第三方复现。
2. AnyWorld 是否增加更大样本真机、接触物理过滤和跨本体泛化验证。
3. CJ 包装线是否披露节拍、介入率、在线率、连续运行时间和扩展工序。
4. Figure-Nscale 的最低采购、付款义务、GPU 部署里程碑和融资安排。
5. PlusAI S-4、SPAC 赎回、净现金与 HyperFoundry 收入确认。
6. Wandercraft 350 台计划是否转为采购合同、交付和客户验收。
7. 韩国预算中 5,000 亿与 2.6 万亿 physical AI 口径的官方拆分。
8. AGIBOT 数据集下载、许可、传感器字段、任务分布与失败标签质量。

## 9. 质量门控记录

`PASS｜覆盖7/7·产业链8/8·技术候选28/入口12类/正文21/深拆8·产品候选27/入口12类/正文20/深拆7·市场候选21/正文30·政策正文15/正式政策标准4·关键数据表18条·机会15条·风险8条`

## 10. 审计说明

- 技术、产品、市场、政策的分片与检索台账均保留在当期审计目录。
- 博客编辑只能以本母稿为唯一内容输入，不得从分组文件另行补事实。
- 旧信息只作明确背景；公司口径、单源数据、计划和承诺均不得在读者稿中升级为已验证事实。
