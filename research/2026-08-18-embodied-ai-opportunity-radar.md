# 具身智能机会雷达周报｜2026-08-11 ~ 2026-08-17

> 抓取/阅读日期：2026-08-18｜时区：Asia/Shanghai  
> 研究口径：本周动态只收录 2026-08-11 00:00—2026-08-17 24:00 内发布、生效或被官方公开的事件；窗口外材料明确标注“背景，非本周”。一级来源优先，关键数字尽量双源核验；公司或论文单源均标注“待验证”。  
> 检索规模：技术候选 27 条、产品候选 25 条；技术与产品分别覆盖至少 10 类入口，合计精读正文超过 40 份。中国、美国为重点，欧洲、日本、韩国、新加坡/东南亚均完成定向检索。

## 本周一句话

本周最强信号不是通用人形机器人突然成熟，而是**机器人软件基础设施、专用工序自动化和地方全栈政策同时变得更可交付**：GigaBrain-0.7、SBLR、EcoVLA 分别把模型、触觉 Sim2Real 和云边运行时向工程化推进；Alloy Robotics 的融资与 Serve 的经营反证共同说明，最接近现金流的软件机会是可观测性、验收、数据闭环、安全证据和多机运维，而不是从零造本体。

## TOP 5 进展

### 1. Alloy Robotics 获 800 万美元融资：机器人故障诊断成为独立软件品类

Alloy Robotics 于本周披露完成 **800 万美元融资、投后估值 8000 万美元**，Square Peg 领投。其产品把日志、遥测、视频、Slack、Jira 和代码上下文统一到任务时间线上，再由 AI Agent 定位异常、回归与重复故障。公司称平台已覆盖近 1,000 台机器人、分析 1 万余次任务；客户 Advanced Navigation 称单次现场测试分析从约 1 天缩短到 10 分钟以内。融资额由 Forbes 与公司稿交叉确认，运营数字和客户 ROI 仍是公司/客户口径。

**为什么重要**：这是具身智能最适合软件工程与 Agent 能力迁移的明确楔子。客户不需要相信“通用智能”叙事，只需验证 MTTR、误换件、停机时间和单工程师可支持机队规模是否改善。

**商业化距离与风险**：已进入付费验证，但机器人日志格式碎片化、视频与遥测时间同步、国防/工业数据驻留、模型幻觉式根因解释仍是规模化门槛。

来源：[Forbes，2026-08-11](https://www.forbes.com/sites/davidprosser/2026/08/11/alloy-robotics-raises-8-million-to-help-stop-robots-failing/)；[Alloy/PR Newswire，2026-08-13](https://www.prnewswire.com/news-releases/alloy-robotics-raises-8m-to-help-engineers-debug-robot-fleets-with-ai-agents-302849699.html)。

### 2. GigaBrain-0.7 把理解、预测、行动放进三系统架构，但“将开源”尚不是“已开源”

GigaBrain-0.7 在本周论文中披露三系统架构：System 1 以 flow matching 生成连续动作；System 2 以时序视觉和层级提示做理解、任务进度跟踪与子任务分解；System 3 用世界模型预测未来视觉状态并估值。论文称预训练使用 **超过 37,000 小时、16 种机器人形态、约 2.7 亿视觉语言样本**，并统一转换为 LeRobot v3.0、做跨本体动作归一化、指令改写和质量控制。

作者报告四个真实机器人任务中，SFT、离线 RL、在线 RL 平均成功率从 30.0% 提高到 57.5% 和 100%。但这是同一团队内部、任务和试次数有限的结果，不能外推为通用可靠性。GitHub 8 月 15 日只写 0.7 “will be released soon”；现有可用代码和权重主要仍为 0/0.1。

**为什么重要**：具身模型开始从单一 reactive policy 转向可分解、可观测的“理解—预测—动作”系统。软件机会在 LeRobot 数据治理、三系统 trace、world-model evaluator、跨本体 action adapter 和 rollout 纠错，而不是复制大规模预训练。

来源：[论文，UTC 2026-08-16](https://arxiv.org/html/2608.15875)；[官方 GitHub，2026-08-15 更新](https://github.com/open-gigaai/giga-brain-0)。关键数字为单团队一级来源，待独立复现。

### 3. Geekplus 发布 RoboShuttle Hyper：专机用可验收吞吐继续领先通用形态

Geekplus 8 月 12 日发布爬架箱到人系统 RoboShuttle Hyper，厂商额定性能为每 1,000 平方米每小时 **6,000 箱**、Max 工作站每小时超过 **800 箱**、爬升速度 1.5m/s；调度系统声称可协调 5,000 台机器人、覆盖 50,000 平方米和 300 万储位。系统采用双深位、双通道、双向取货、相邻列并发和同列双机器人，并提供箱体偏移检测与回正。

**为什么重要**：这套产品直接用吞吐、密度、并发、充放电比和安全结构说话，比“人形机器人会搬箱”更接近招标验收语言。它也说明最有价值的软件仍是 WMS 波次、拥堵预测、充电编排、故障隔离和数字孪生压测。

**商业化距离与风险**：已是完整产品发布，但本周没有点名首个客户或 FAT/SAT 数据。所有性能为供应商口径，仍需在 SKU、箱重、峰谷、可用率、消防和褐地仓改造条件下验证。

来源：[Geekplus 官方，2026-08-12](https://www.geekplus.com/resources/news/geekplus-unveils-roboshuttle-hyper-raising-the-throughput-ceiling-for-tote-to-person-fulfillment)；[GlobeNewswire，2026-08-12](https://www.globenewswire.com/news-release/2026/08/12/3343911/0/en/geekplus-unveils-roboshuttle-hyper-raising-the-throughput-ceiling-for-tote-to-person-fulfillment.html)。两份材料同源，客户验收待验证。

### 4. 湖南机器人实施意见覆盖 BOM、数据、仿真、场景和资本

湖南省政府 8 月 17 日公开《关于加快智能机器人产业发展的实施意见》，提出 2028 年产业链营收突破 **1,000 亿元**、2030 年突破 **2,000 亿元**，依法加快设立目标规模 **100 亿元未来产业子基金**，每年支持约 20 个典型场景、约 30 款创新产品。文件不仅点名 RV/谐波减速器、一体化伺服关节、编码器、视觉/力觉传感、机器人专用芯片和轻量材料，也提出可信数据空间、机器人算力池、数字孪生、仿真测试和开源 OS/工具链。

**为什么重要**：政策从“支持整机”转为覆盖材料—部件—本体—数据—软件—中试—场景的全链条。对软件/Agent 团队，仿真评测、数据治理、场景 Agent、OTA、动作审计和安全证据比押注单一硬件更可切入。

**风险**：产业目标和基金目标不等于已形成订单或已到位财政资金；需要追踪基金设立公告、场景复购、设备稼动率和真实企业收入。

来源：[湖南省政府原文，公开 2026-08-17、发文 2026-08-15](http://www.hunan.gov.cn/xxgk/wjk/szfbgt/202608/t20260817_34045718.html)。官方单源。

### 5. Serve 扩平台与城市，但财务反证提醒“部署规模不等于单位经济”

Serve Robotics 8 月 17 日宣布将 Grubhub/Wonder 接入配送网络，覆盖芝加哥 100 多家、洛杉矶近 200 家参与商户，并推进 San Jose、Washington DC 和 Miami 微型运营站；Diligent Moxi 2.0 也开始向点名医院滚动部署。与此同时，Serve 8 月 6 日披露的 Q2 背景数据必须配套阅读：平均日活机器人 792 台、收入 **323.8 万美元**、成本收入 **1,201.7 万美元**、毛亏损 **877.9 万美元**，并因 Uber Eats 配送量低于预期把全年收入指引下调至 900万—1,000 万美元。

**为什么重要**：多平台接入、微型运营站、门店 Beacon 和医院续约都是真实商业化进展；但订单密度、远程人工、维护和站点成本决定最终毛利。部署台数不能替代每单成本、接管率和利用率。

来源：[Serve 8 月 17 日公告](https://ir.serverobotics.com/news-releases/news-release-details/serve-launches-robot-delivery-wonder-adding-grubhub-its-growing)；[Serve 2026Q2 财报，背景，非本周](https://investors.serverobotics.com/news-releases/news-release-details/serve-robotics-announces-second-quarter-2026-results)。

---

# 一、7 面雷达

## 1. 技术进展

### GigaBrain-0.7：三系统协同与大规模跨本体数据

**原文事实。** GigaBrain-0.7 将 Action & Control、Understanding & Planning、Prediction & Evaluation 分为三套系统。动作专家以 flow matching 生成 action chunk；规划系统基于当前与历史视觉做任务进度理解和层级提示分解；预测系统生成未来视觉子目标并估值。预训练使用超过 37,000 小时异构轨迹、16 种机器人形态和约 2.7 亿视觉语言样本，并以 LeRobot v3.0 统一格式、跨本体状态动作归一化、LLM 辅助改写和多阶段质检处理数据。

**指标与对照。** 作者称模型在仿真、AgileX PiPER/PiPER-X 与 Maker H01 上完成零样本、多任务、语言跟随、OOD 和长时序评测；四个真实任务的 SFT→离线 RL→在线 RL 平均成功率为 30.0%→57.5%→100%。这些数字来自论文单源，缺第三方复现、置信区间和更长运行周期。

**瓶颈与失败边界。** 多源数据会产生 embodiment interference；跨本体归一化可能掩盖动力学差异；三系统串联增加时延和故障点；在线 RL 的安全、样本成本与回滚机制未因“100%”被解决。0.7 的训练代码和权重仍未实际发布，当前只能部分复现。

**商业化距离。** 中等。数据治理和部署客户端已具工程形态，但生产可靠性、功能安全、端侧算力与可复现开源仍缺。

**可迁移机会。** 做 LeRobot 数据 schema/血缘/质量门禁；给三系统统一 trace ID、子任务图和回放；建设跨本体 action adapter、world-model evaluator 与人工纠错闭环。

来源：[论文](https://arxiv.org/html/2608.15875)；[GitHub](https://github.com/open-gigaai/giga-brain-0)。

### SBLR：用 latent bridge 绕过高成本触觉仿真

**原文事实。** SBLR 在仿真中使用物体/指尖点云和接触力形成的 privileged force-contact（PFC）训练策略；真实触觉图像先经 MAE 编码，再由基于最近邻伪配对的双向 Rectified Flow 映射到 PFC latent。第二阶段把 oracle→real→oracle 的信息瓶颈带回训练，使策略适应跨模态映射损失。每任务、每传感器采集 256 个真实 random-play episodes 和 4,096 个仿真 episodes，真实采集约 40 分钟。

**指标与对照。** 在 Peg Insertion、Gear Meshing 等固定接触任务和 GelSight Mini/DIGIT 上，作者报告零样本真机成功率 85%—97.5%，比物理触觉仿真基线高 7.5—15 个百分点，每项硬件评测 40 episodes。

**瓶颈与失败边界。** 这不是“零真实数据”：每个任务/物体仍需真实随机接触覆盖；论文假设物体姿态和部署分布相对稳定。RF 伪配对错误、传感器漂移、不同触觉设备信息量差异以及动力学 gap 都可能导致失效。截至阅读日未见代码、权重或数据公开。

**商业化距离。** 固定工位插装、齿轮啮合较近；多 SKU、柔性物体和开放世界较远。

**可迁移机会。** 传感器适配 SDK、自动 random-play 采集、latent 版本管理、漂移监控、sim/real 配对、采集覆盖 Agent 和触觉回归测试。

来源：[SBLR 论文，UTC 2026-08-16](https://arxiv.org/html/2608.15897)。单源待复现。

### EcoVLA：把 VLA 变成受 20Hz SLO 约束的云边流水线

**原文事实。** EcoVLA 把不同 VLA 抽象为 stage DAG，通过离线 profiling 与在线网络/边缘负载感知估算端到端时延和能耗，在满足 20Hz 动作输出 SLO 的候选中选择 Actions/J 更高的设备—边缘切分。测试台为 Jetson AGX Orin 32GB + RTX 4090，控制面采用 Ray RPC，数据面采用 torch.distributed/Gloo，权重在双端预载。

**指标与对照。** 作者称相对固定切分，π0、π0.5、SmolVLA、RDT-1B、OpenVLA 的能效分别提高 58%、84%、100%、182%、236%，预测落入 20% 误差带的比例超过 95%。

**瓶颈与失败边界。** Actions/J 不是任务成功率；实验是异构硬件测试台，不是带机器人任务的物理闭环。权重双端常驻抬高内存成本，Gloo/RPC 与生产网络不同；P99 时延、断网、安全动作缓存、多机器人拥塞和控制稳定性仍待验证。

**商业化距离。** 中等偏近，适合工厂边缘集群；家庭环境必须有本地安全降级。

**可迁移机会。** VLA profiler、stage compiler、SLO scheduler、OpenTelemetry 观测、灰度/回滚、断网 fallback 和自动切分 Agent。

来源：[EcoVLA 论文，UTC 2026-08-16](https://arxiv.org/html/2608.15502)。单源待复现。

### HAF：分阶段生成全身动作并在低维流空间做安全后训练（背景，非本周）

HAF 论文的 UTC 提交日是 8 月 17 日，但按严格北京时间落在 8 月 18 日，因此只作背景。HAF-VLA 将动作流分为移动+头、腰、双臂三阶段，共享 action expert 并通过 stage embedding 与跨阶段 clean-action KV cache 传递依赖；HAF-Steer 将 flow noise 映射到时间 DCT 空间，只保留前 8 个系数，在冻结 VLA 的条件下做 BC 初始化和混合离线—在线 SAC。

作者在两台人形、7 个家庭任务上报告平均归一化得分 70.5%，π0.5 为 53.3%，每任务 10 次；OOD 障碍和起点扰动也有改善。其价值在于显式编码运动链层级，但三阶段 denoise 增加推理时延，归一化里程碑分不等于完整任务成功率，在线 RL 还出现不安全探索终止。代码和权重未见公开。

**可迁移机会。** action schema、跨阶段 runtime/cache、离线—在线 replay、安全探索审批和人类接管编排。

来源：[论文](https://arxiv.org/html/2608.16837)；[项目页](https://grange007.github.io/HAF/)。

### τ0-VLA：用世界模型和价值模型在动作提交前做测试时搜索（背景，非本周）

τ0-VLA 同样因 UTC/北京时间边界被排除本周。其高层 VLM 提议子任务，world model 预测终态图像，value model 打分，再经 beam search 和 reflection 后提交；低层以 VLM+MoT action expert 输出统一 40 维 state/action。论文称使用 40,115 小时真实数据，四项 13—25 步、最长 12 分钟的实机长任务中，层级系统平均成功率 45.0%，direct 为 27.5%，每任务 10 次；在 OOD Book Organization 中，选择性测试时计算为 74.0%，Plan Once 为 50.0%。

**瓶颈。** world model 可能生成视觉上合理、物理上错误的后果；beam 宽深增加时延；子任务边界和价值模型偏差会造成错误提交；最终接触动作仍是主要失败点。未见代码和权重。

**可迁移机会。** 可审计 subtask graph、事件溯源 memory、world-model evaluator、置信度路由、失败回放和人工批准。Agent 工程经验可以迁移，但动作必须经过确定性约束与安全层。

来源：[论文](https://arxiv.org/html/2608.16885)；[项目页](https://tau0-vla.github.io/)。

> **技术高质量增量说明**：严格窗口内达到“至少两份正文且有足够方法/实验细节”的重点对象只有 GigaBrain-0.7、SBLR、EcoVLA 三项；为达到技术对照深度而纳入 HAF、τ0-VLA 两项北京时间边界背景，均已明确标注，未用低质量线索凑数。另有 Baton、RAPAC-DP、ViTaR、Tac4Loco、Adaptive Bridge、PhaseLoRA、GaussMemory、SkillComposer 等 20 余条候选，未进入重点不代表价值低，而是正文/代码/时间窗/实机证据未同时过闸。

## 2. 产品与公司动态

### Serve Robotics：配送网络的软件与运营栈在扩张

Serve 本周新增 Grubhub/Wonder 平台接入，推进 San Jose、Washington DC、Miami 微型运营站，并发布面向门店后场的蜂窝 Beacon 和广告角色。目标工序是平台订单接入、门店装载、人行道配送、用户取货和异常恢复。公告未披露传感器 BOM、远程辅助率或每单人工分钟，因此“autonomous”不能等同无人运营。

验收应看准时率、成功交付率、每千英里安全干预、每台日订单、商户等待、可用率和每单全成本。本周披露的是商户覆盖和城市扩张，非这些核心 SLA。Q2 背景财务显示规模增长仍由高运维成本支撑。

**成熟度**：多城市规模运营；单位经济未成立。  
**软件机会**：订单异常 Agent、门店交接、远程协助排序、充电维护排程、事故回放和每单成本归因。

### Diligent Moxi 2.0：医院移动操作的护城河是工作流、续约与实施

Moxi 2.0 面向药品、检验样本、PPE 和物资配送。公司称新版本具备 10 倍机载算力、升级传感器、最长 18 小时运行、快充 30%，感知解释速度提高 15 倍，并以 fleet World Model 汇聚经验。产品通过现场数字学习、Wi‑Fi 接入、医院工作流配置和约 12 周实施进入日常班次；人类仍需定义任务、处理药品/样本合规和异常恢复。

点名部署医院包括 Endeavor Health Edward Hospital、Providence Saint John’s、Children’s Hospital Los Angeles；已有 25 家以上医院经验，Serve Q2 还披露 7 份多年续约。历史公司口径为百万次配送、节省 575,000 工时和 125,000 次自主乘梯，但未披露任务失败、人工救援、停机和 RaaS 毛利。

**成熟度**：客户现场持续运营/早期规模商业化；新硬件 KPI 待客户验收。  
**软件机会**：医院系统连接器、临床优先级任务 Agent、药品交接审计、电梯异常恢复、跨院数据治理和仿真回归。

### Geekplus RoboShuttle Hyper：箱到人的完整系统发布

Hyper 以爬架 AMR、列轨一体机架、Max 工作站和调度系统构成箱到人系统，可对接机械臂拣选站与 Gino 1。部署需要仓内数据建模、机架/消防规划、WMS/RMS 集成、FAT/SAT、波次上线与峰值压测。只有接入自动拣选站后才接近无人闭环；补货、异常箱和维护仍需人。

本周所有吞吐和并发数字均来自供应商，未点名首个客户或现场验收。TCO 需包含机架、地坪、消防、接口、电池、备件、峰值冗余和停机损失，不能套用其他产品“1—2 年 ROI”口径。

**成熟度**：受控测试/产品发布，商业项目距离近，客户 SAT 尚未过。  
**软件机会**：波次优化、拥堵预测、充电编排、故障隔离、数字孪生压力测试和自动生成验收报告。

### AiMOGA：汽车制造与渠道体系帮助机器人出海，但任务价值仍待验证

AiMOGA 8 月 17 日称累计海外交付超过 2,000 台、覆盖 60 多个国家和地区，马来西亚首波为数十台，并披露 2026 上半年 110 台交警机器人投入使用。此前资料显示总量混合人形、四足和服务产品，不能写成“2,000 台人形”。Mornine M1 约 167cm、70kg、40 自由度（不含灵巧手）、最大步速 1m/s、臂端负载 1.5kg、0.7kWh 电池，充电 2 小时、运行约 2 小时，支持 VR 遥操作。

其优势主要是奇瑞的制造、物流、4S 店、海外经销和售后网络，而不是公开可证的模型领先。展厅和交警场景已有批量现场部署，但缺在线率、付费结构、任务 SLA、续约和事故数据。

**成熟度**：可卖可交付，价值与续费未证明。  
**软件机会**：多品牌车型知识 Agent、CRM 线索闭环、跨语言话术评测、远程运营、设备健康和内容合规。

来源：[AiMOGA 8 月 17 日稿](https://www.prnewswire.com/apac/news-releases/aimoga-robotics-crosses-2-000-global-deliveries-with-robots-to-serve-chery-omodajaecoo-icaur-and-lepas-showrooms-across-key-destination-malaysia-302852789.html)；[价格与规格背景，2026-04-13](https://carnewschina.com/2026/04/13/chery-begins-online-sales-of-humanoid-robot-with-a-0-7-kwh-battery-at-41400-usd/)。

### Seeing Machines Physical AI Platform：汽车人因感知向机器人迁移

Seeing Machines 8 月 17 日发布 Physical AI Platform，提出结合 AI、嵌入式处理和光学构建动态 3D 人—物—环境图，面向制造、物流、医院、康养、仓储和矿业。公司已有 800 万辆以上 DMS/OMS 装车基线，但未公布机器人 OEM、SDK、支持传感器、ROS 接口、模型大小、端到端延迟、价格或功能安全认证。

汽车驾驶舱内相对受控的人因监测迁移到多人、遮挡、动态机器人工作区，域差异很大。发布视频只能归为受控 Demo，不能当客户部署。

**成熟度**：平台发布/受控演示，距商业化还隔设计伙伴、开发套件与认证案例。  
**软件机会**：风险解释 Agent、安全事件回放、合成场景生成、标定助手、隐私匿名化和安全证据自动编译。

来源：[Seeing Machines，2026-08-17](https://www.prnewswire.com/news-releases/seeing-machines-launches-physical-ai-platform-to-power-the-next-generation-of-humanoid-robots-302852638.html)。

## 3. 投资融资与并购

- **Alloy Robotics**：800 万美元融资、投后估值 8000 万美元，金额由 Forbes 与公司稿交叉确认；这是本周最明确的具身软件融资。
- **JFB × XTEND**：S-4 于 8 月 11 日获 SEC 生效，拟 9 月 1 日交割、合并后代码 XTND；监管生效不等于交易已完成，仍有上市、最低现金和交割条件。
- **SunScout IPO**：发行 310 万股、每股 5 美元，募资 1,550 万美元，上市时市值约 1.155 亿美元；由交易/IPO材料交叉确认。
- **本周反共识**：严格窗口内可核纯 VC 融资并不多，市场主体更多在发布 MOU、新品和未来部署计划。融资热度不能替代客户订单、收入确认与毛利。

## 4. 政策与产业扶持

### 中国

- **湖南**：全链条实施意见是本周最重要政策，覆盖核心部件、本体、数据、仿真、算力、OS、场景和资本。所有目标为官方单源，不能等同已实现市场规模。
- **上海**：8 月 11 日发布软件和信息服务业“十五五”规划，提出到 2030 年产业规模力争 4 万亿元、增加值不低于 1.1 万亿元；建设 100 个制造业高质量数据集、约 60 家智能化服务商、约 10 家 AI 原生工厂，并明确具身智能专用 OS、主控/嵌入式软件、世界模型、合成数据、运动策略和仿真。对 Agent/软件团队比纯硬件补贴更直接。来源：[上海市经信委原文](https://www.sheitc.sh.gov.cn/cyfz/20260811/7ff732b1c470421c86e46d14c0270ead.html)。
- **北京亦庄**：8 月 15 日启动机器人消费节，专项资金 1,800 万元、六大商场配套 350 万元消费券、京东专区 600 余款商品。属于促消费执行事件，不是新产业法规。来源：[北京经开区](https://kfqgw.beijing.gov.cn/ywdt/tt/cxfw/202608/t20260815_4823940.html)。
- **吉林采购**：焊接机器人与检验切割实训设备预算/限价 649.7624 万元，说明采购需要工艺与教学系统而非单机。来源：[政府采购原文](http://www.jl.gov.cn/ggzy/jlsggzy/jlsjyxx/jlszfcg/ccszccggg/202608/t20260817_9683023.html)。
- **中央部委**：经国务院、工信部、发改委、科技部窗口检索，本周未发现重大公开新增具身智能专项政策。

### 海外

经 White House、Commerce、NIST、欧盟委员会、METI、韩国 MOTIR、新加坡 MTI/IMDA/NRP 官方入口检索，本周未发现重大公开新增机器人/具身智能专项政策。欧盟 AI Act 自 2026-08-02 开始执法属于背景，持续影响工作场所、生物识别、安全组件和关键基础设施类具身系统，不能写成本周新政。

## 5. 市场与商业化

1. **可观测性开始有独立预算**：Alloy 的融资和客户工时证据说明，日志、视频、遥测、代码与工单统一诊断正在从内部工具变成产品。
2. **专用工序优先于通用形态**：RoboShuttle Hyper、X Square 包裹上料、PUDU ET1 小空间清洁、Duke 电网绝缘子清洗，都能以节拍、面积、风险和人工班次验收。
3. **规模运营仍可能亏损**：Serve 的活跃机队、城市扩张和毛亏损并存；需求密度、远程人工、维修和站点 CAPEX 是关键。
4. **资产、流量和技术开始拆分**：Pony.ai × Uber 计划在欧洲部署 2,000 辆以上 Robotaxi，由本地伙伴持有车辆、Uber 负责获客支付客服、Pony 提供 L4 技术。模式值得机器人 RaaS 借鉴，但仍是计划不是交付。
5. **销售周期由客户现场支配**：Nauticus 即使 ToolKITT 已商业发布并进入任务，Q2 仍只有 90 万美元收入、1,110 万美元净亏、约 200 万美元现金；机器人软件不能消除油气项目预算周期和现场可用性约束。

## 6. 用户与需求侧信号

- **客户买停机时间下降，不买模型参数**：Alloy 客户强调从一天到十分钟的测试分析，而非 Agent benchmark。
- **客户买吞吐、密度、接管率与恢复**：物流产品必须披露 P50/P95/P99 节拍、异常件、连续运行、人工接管与恢复，不应只报峰值。
- **医院买工作流和续约**：Moxi 的点名医院、百万次历史任务和多年度续约比“15×感知”更有商业含金量；价格、失败率和院内实施成本仍缺。
- **小空间与脏险累场景预算更清晰**：100—800㎡门店清洁、包裹上料、电网清洗、海底检查更容易形成可算 ROI。
- **出海客户需要本地化运营**：语言、内容、数据驻留、远程运维、备件和隐私合规比一次交付更难。AiMOGA 的汽车渠道优势值得观察，但在线率和续费才是验证。
- **需求落差必须进入模型**：Serve 因 Uber Eats 量低预期下调指引，说明技术可用不代表订单密度足够。

## 7. 入局机会与行动建议

### 立即学习

1. **机器人数据与时间同步**：ROS 2 bag/MCAP、LeRobot v3、视频—遥测—控制命令对齐、时序数据库和数据血缘。
2. **机器人运行指标**：任务成功率、人工接管率、P95/P99 节拍、MTBF、MTTR、tail latency、Actions/J、每任务全成本。
3. **安全与可信执行**：typed skill、前置/后置条件、权限、超时、补偿动作、硬件急停、ISO 10218/13482 与欧盟 AI Act 证据要求。

### 可做 Demo

1. **机器人故障调查 Agent**：接入 rosbag/MCAP、视频、Git、Jira/Slack，输出带时间戳证据、相似历史事件、候选根因和复现步骤。
2. **部署验收 Agent**：自动生成 P50/P95/P99 节拍、成功率、接管率、MTBF/MTTR、异常件分布和版本对照报告。
3. **具身 skill runtime**：把 VLA/传统控制技能封装为带 schema、precondition/postcondition、verifier、fallback、审计日志和回滚的工具。
4. **VLA 云边 profiler**：在 Orin/桌面 GPU 上测 stage 延迟、能耗、显存和网络抖动，自动选择切分并提供断网 fallback。
5. **机器人安全 Case Agent**：把危险分析、测试证据、模型卡、SBOM、固件签名、版本和事故记录串成可审计图谱。

### 可找合作

1. 找已有 **10—100 台客户机队**的 AMR、清洁机器人或系统集成商，做多品牌控制、可观测、工单、备件和 OTA。
2. 找仓储/工厂做 FAT/SAT 自动化与数字孪生压测，以“验收工时下降、异常覆盖提高”计费。
3. 找机器人出海厂商做分区数据驻留、日志脱敏、远程运维和合规证据中间层。

### 可投资观察

1. Alloy 式机器人可观测性/数据平台：跟踪净留存、集成周期、每千任务成本和真实 MTTR 改善。
2. 专用任务自动化：包裹上料、小空间清洁、电网/海底维护，只看连续运行、客户复购和毛利。
3. 机器人电源、触觉与关节 EOL 测试：关注 Wh/kg、循环、标定、批次一致性、寿命和总拥有成本。

### 暂不建议

1. **从零造通用双足本体**：资本、供应链、安全、数据和渠道门槛与现有能力不匹配。
2. **未经约束让 VLM/VLA 直出关节控制**：必须通过技能 schema、独立 verifier、碰撞/动力学约束和硬件安全层。
3. **只靠“机器人+广告屏”叙事**：应先证明主任务单位经济与设备利用率，再谈广告填充。

---

# 二、产业链 / 技术栈地图

|环节|本周信号|主要瓶颈|软件/Agent切口|
|---|---|---|---|
|上游硬件与供应链|湖南点名减速器、伺服关节、编码器、视觉/力觉、芯片与材料；瑞萨展示视觉/力觉/触控与九轴关节控制参考方案；EnPower×Echion推进北美快充电芯MOU|批次一致性、寿命、温漂、功能安全、能量密度、量产良率|部件数据协议、标定、关节EOL测试、寿命预测、BMS/IMU诊断|
|本体与运动控制|Hyper专机以爬架并发提高吞吐；HAF背景工作以分阶段动作流适配全身移动操作|平衡、接触、实时性、安全冗余；高层VLA不能替代WBC|action schema、运动阶段trace、安全探索审批、跨本体adapter|
|数据层|GigaBrain使用37k小时/16形态并统一至LeRobot；SBLR用random-play采真实触觉|数据权属、异构schema、低质示范、sim/real覆盖、隐私|数据血缘、质检、回放、active review、采集覆盖Agent|
|仿真与训练基础设施|SBLR以latent bridge降低触觉仿真依赖；上海/湖南支持世界模型、合成数据、数字孪生与仿真|接触物理、柔性物体、world-model幻觉、仿真指标与真机相关性|scenario manifest、仿真回归、相关性校准、自动FAT/SAT|
|模型与算法|GigaBrain三系统；SBLR跨模态；EcoVLA云边；HAF/τ0作为边界背景|内部小样本“100%”、代码未发、延迟、在线RL安全|subtask graph、world-model evaluator、置信度路由、模型版本治理|
|软件工程与工具链|Alloy可观测性融资；EcoVLA SLO调度；上海规划具身OS、主控和嵌入式软件|中间件碎片、tail latency、断网、OTA风险、审计缺失|OTel/MCAP、skill runtime、灰度回滚、根因Agent、安全Case|
|系统集成与应用|Moxi医院续约、Serve配送扩城、Hyper仓储新品、AiMOGA展厅/交警|实施成本、人工接管、建筑/工艺差异、客户ROI|工作流连接器、任务调度、异常恢复、站点ROI与运维|
|商业生态|湖南/上海政策、Alloy融资、平台—资产—流量拆分、汽车渠道出海|政策目标不等于订单；订单不等于收入；部署不等于毛利|按效果计费、证据化验收、渠道运营控制面、订单到收入跟踪|

> Isaac/Genesis/MuJoCo/Gazebo 本周未发现同时满足严格窗口、显著版本增量和高质量一级正文三项条件的更新；不强行填充。ROS 2 方向有 Adaptive Bridge 候选，LeRobot 由 GigaBrain 与工程数据闭环覆盖。

---

# 三、融资、供应链与商业反证

## 供应链重点

- **力觉/触觉**：本周产业展示把灵巧手竞争从自由度推向低噪声 AFE、温漂补偿、触觉协议、封装和数据工具链。SBLR 又说明传感器适配软件能减少高成本物理仿真。
- **执行器/伺服**：双编码器、EtherCAT、控制周期与抖动比峰值 TOPS 更接近工业价值；国产化机会是“器件+参考设计+算法库+EOL测试”。
- **减速器/关节**：机会从本体扩展到在线误差辨识、寿命预测和批次一致性；样机参数无法替代长期耐久。
- **灵巧手**：高自由度会放大线束、驱动、标定与维修成本；模块化指尖和少自由度方案可能更早商业化。
- **电池/IMU**：窗口内没有经一级来源确认的重大新增量产事件。续航与姿态传感仍常被整机宣传掩盖，应重点看 BMS、热管理和在线标定。

## 商业反证

1. Serve：已规模运营但毛亏显著，证明部署数量不是单位经济。
2. Nauticus：软件已商业发布并进入任务，但现金和收入仍受现场周期制约。
3. Duke Robotics：预计全年采购单超过 100 万美元，Q2 收入仅 14.9 万美元；订单转收入受服务队伍、季节和验收影响。
4. Geekplus/X Square：峰值吞吐来自厂商，不含异常件、利用率、维护和集成停机。
5. 医疗产品：FDA/产品许可只是起点，培训、陪同、报销、院内IT和合规决定真实采用。

---

# 四、风险与反共识

1. **通用人形不是本周最强商业形态。** 可量化需求来自爬架 AMR、移动医疗机器人、包裹上料、清洁和电网/海底作业。
2. **“已交付”不等于“已激活、常使用、会续费”。** AiMOGA 的混合产品交付、Serve 的累计部署与日活差异都需要拆解。
3. **论文 100% 不等于生产可靠。** 小任务、小样本、同源评测、无第三方复现必须降权。
4. **政策目标不等于市场规模。** 湖南 1,000/2,000 亿元包含传统工业机器人、部件、材料和服务，不能推导人形销量。
5. **云边效率不等于控制安全。** EcoVLA 的 Actions/J 改善必须与任务成功、P99 时延、断网和物理闭环共同验证。
6. **世界模型可能“看起来正确、物理上错误”。** 不能让生成后果未经实机相关性校准就充当安全 verifier。
7. **数据和 Agent 接入会扩大工控风险。** PLC/控制器误动作后果远高于普通 SaaS，必须做权限、隔离、签名、回滚和硬件急停。
8. **地方产业园易重复建设。** 应追踪订单、场景复购、设备稼动率和基金实缴，而不是揭牌数。

---

# 五、关键数据来源表

|数据点|数值|来源|发布时间/更新日期|统计周期|是否本周|验证状态|
|---|---:|---|---|---|---|---|
|Alloy融资/估值|800万美元 / 8000万美元|[Forbes](https://www.forbes.com/sites/davidprosser/2026/08/11/alloy-robotics-raises-8-million-to-help-stop-robots-failing/)；[公司稿](https://www.prnewswire.com/news-releases/alloy-robotics-raises-8m-to-help-engineers-debug-robot-fleets-with-ai-agents-302849699.html)|8/11、8/13|本轮融资|是|双源确认金额；估值/运营待进一步文件|
|Alloy客户效率|约1天→<10分钟；44项测试约1天|同上客户引述|8/13|客户案例|是|公司/客户口径，待审计|
|GigaBrain数据|>37k小时、16形态、约270M VL样本|[论文](https://arxiv.org/html/2608.15875)|UTC 8/16|预训练总语料|是|单团队一级来源，待复现|
|GigaBrain后训练|30.0%→57.5%→100%|同上|UTC 8/16|4真实任务|是|单源，小样本|
|SBLR真机成功率|85%—97.5%，领先7.5—15pp|[论文](https://arxiv.org/html/2608.15897)|UTC 8/16|两硬件任务、每项40 episodes|是|单源待复现|
|SBLR采集|256 real + 4096 sim；约40分钟|同上|UTC 8/16|每任务/传感器|是|论文正文已核|
|EcoVLA能效|58/84/100/182/236%提升|[论文](https://arxiv.org/html/2608.15502)|UTC 8/16|五VLA、20Hz、Orin+4090|是|单源；非实机任务成功率|
|Hyper吞吐|6,000箱/h/1,000㎡；工作站>800箱/h|[Geekplus](https://www.geekplus.com/resources/news/geekplus-unveils-roboshuttle-hyper-raising-the-throughput-ceiling-for-tote-to-person-fulfillment)|8/12|额定性能|是|厂商单源，SAT待验证|
|Hyper调度|5,000机器人、50,000㎡、300万储位|同上|8/12|系统能力声明|是|厂商单源|
|Serve平台覆盖|芝加哥100+、洛杉矶近200商户|[Serve](https://ir.serverobotics.com/news-releases/news-release-details/serve-launches-robot-delivery-wonder-adding-grubhub-its-growing)|8/17|披露时点|是|公司/SEC附件同源；订单量未知|
|Serve经营背景|收入$3.238m；成本收入$12.017m；毛亏$8.779m；日活792|[Q2财报](https://investors.serverobotics.com/news-releases/news-release-details/serve-robotics-announces-second-quarter-2026-results)|8/6|2026Q2|否，背景|一级财报|
|Moxi 2.0规格|15×感知、10×算力、18小时、快充30%|Serve/Diligent 8/17公告|8/17|新品规格|是|厂商单源，客户验收待验证|
|AiMOGA交付|>2,000、60+国家/地区；H1 110台交警机器人|[公司稿](https://www.prnewswire.com/apac/news-releases/aimoga-robotics-crosses-2-000-global-deliveries-with-robots-to-serve-chery-omodajaecoo-icaur-and-lepas-showrooms-across-key-destination-malaysia-302852789.html)|8/17|累计/H1|是披露|产品构成、激活与效果待验证|
|湖南产业目标|2028>1000亿元；2030>2000亿元；100亿元基金目标|[湖南省政府](http://www.hunan.gov.cn/xxgk/wjk/szfbgt/202608/t20260817_34045718.html)|公开8/17，发文8/15|2028/2030目标|是|官方单源；非已实现|
|上海软信规划|2030年4万亿元、增加值≥1.1万亿元|[上海经信委](https://www.sheitc.sh.gov.cn/cyfz/20260811/7ff732b1c470421c86e46d14c0270ead.html)|发布8/11，成文8/4|至2030规划|是|官方单源|
|亦庄消费节|1800万元+350万元；600余款商品|[北京经开区](https://kfqgw.beijing.gov.cn/ywdt/tt/cxfw/202608/t20260815_4823940.html)|8/15|本次活动|是|官方单源|
|吉林采购|649.7624万元|[采购原文](http://www.jl.gov.cn/ggzy/jlsggzy/jlsjyxx/jlszfcg/ccszccggg/202608/t20260817_9683023.html)|8/17|本次招标|是|官方单源|
|Pony/Uber计划|欧洲2,000+辆、另4城|[Uber IR](https://investor.uber.com/news-events/news/press-release-details/2026/Pony-ai-and-Uber-Expand-Partnership-to-Deploy-Over-2000-Robotaxis-in-Europe/default.aspx)；[TechCrunch](https://techcrunch.com/2026/08/14/uber-and-pony-ai-plan-to-bring-2000-robotaxis-to-europe/)|8/13、8/14|未来计划|是|双源确认计划；未交付|
|Nauticus经营|收入$0.9m、净亏$11.1m、现金$2.0m|[公司财报](https://www.prnewswire.com/news-releases/nauticus-robotics-inc-reports-second-quarter-2026-results-and-advances-commercialization-strategy-302850169.html)|8/12|2026Q2|是|一级单源财报|

---

# 六、来源抽查

阅读日均为 2026-08-18，以下重点来源已打开正文并核对：

1. GigaBrain 论文：HTTP 200；核到 37k 小时、16 形态、270M 样本、三系统结构；GitHub 同步核到“0.7 将发布”，未误写为已开源。
2. SBLR 论文：HTTP 200；核到跨模态 Rectified Flow、真实/仿真采集量和硬件成功率。
3. EcoVLA 论文：HTTP 200；核到 20Hz、Orin+4090、五模型 Actions/J 结果；明确不是机器人闭环任务评测。
4. Geekplus 官方页：HTTP 200；核到 6,000箱/h/1,000㎡、800箱/h、1.5m/s、5,000台调度；页面没有客户名。
5. Serve 8/17公告与Q2财报：HTTP 200；分别核到平台/商户/城市扩张与收入、成本、日活、指引反证。
6. 湖南省政府原文：HTTP 200；核到文号、日期、产业目标、基金目标、场景/产品和全链条条款。
7. 上海经信委规划：HTTP 200；核到软件产业目标、制造数据集、具身OS、仿真和工业智能体条款。
8. AiMOGA 稿与历史价格/产品构成材料：HTTP 200；核到交付、地域、交警数量，并明确不能等同2,000台人形。
9. Alloy 公司稿与 Forbes：HTTP 200；融资额一致，运营覆盖和客户效率仍按公司/客户口径。
10. Pony/Uber 两份正文：HTTP 200；核到2,000+为未来计划，不是已部署。

抽查结论：**10/10 链接可打开或正文可读，日期与窗口/背景标注一致，报告表述未超出原文。**

---

# 七、下周跟踪指标

1. GigaBrain-0.7 是否真正发布权重、训练代码、许可证和可复现实验。
2. HAF、τ0-VLA 在北京时间窗口内的后续代码、外部复现和真实任务失败分布。
3. Serve 各城市每机器人日订单、远程协助分钟/单、micro-depot CAPEX、Grubhub实际订单密度。
4. Moxi 2.0 三家医院的任务成功率、停机、人工救援、World Model 跨院数据治理和 RaaS 价格。
5. Geekplus Hyper 首个点名客户、FAT/SAT工况、峰值可用率、安全认证和项目总价。
6. AiMOGA 2,000台产品构成、收入确认、在线率、续费与海外售后成本。
7. 湖南100亿元基金的设立/实缴、首批场景名单、上海具身OS/工业智能体项目申报细则。
8. Alloy Robotics 的付费客户、净留存、单客户集成周期、每千任务成本和真实 MTTR 改善。

---

## 质量门控

`时间窗2026-08-11~08-17·覆盖7/7·产业链8/8·技术候选27/重点5（严格窗口3+边界背景2）·产品候选25/重点5·技术/产品检索入口各≥10类·重点正文抽查10/10·关键数据19条·政策官方原文4篇+海外无新政检索·机会14条·风险8条`
