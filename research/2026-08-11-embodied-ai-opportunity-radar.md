# 具身智能机会雷达周报｜2026-08-04 ~ 2026-08-10

> 抓取/阅读日期：2026-08-11｜时区：Asia/Shanghai  
> 研究口径：本周动态只收录 2026-08-04 00:00—2026-08-10 24:00 内发布、生效或被官方公开的事件；窗口外材料均明确标注“背景，非本周”。一级来源优先，关键数字尽量双源核验；只有企业或论文单源时标注“待验证”。

## 本周一句话

具身智能本周最强信号不是“又一个通用人形演示”，而是**可部署化开始同时推进**：低成本世界—动作模型、长期记忆与分层规划进入技术栈，造船/焊接/卸货用可验收结果获得预算，监管与数据质量标准又把可观测、合规、测试、运维推成更靠近现金流的软件机会。

## TOP 5 进展

### 1. HII 给物理 AI 一份“按结果放量”的七年框架

HII 于 8 月 6 日与 Path Robotics、GrayMatter Robotics 签署七年绩效挂钩生产协议，拟授予合计**最高 9 亿美元**的造船工作。项目先进行海军级焊接、打磨、喷砂、涂装、装配与检测开发、验证和资格认证，只有满足成本、进度、质量里程碑后才进入交付。HII 还披露 2026 年计划外包**超过 250 万工时，同比增加 30%**。

这不是 9 亿美元已确认收入，而是“认证型 PoC→有条件规模部署”的采购框架。它的重要性在于，客户开始为**合格工时、质量与交期**而不是机器人台数付费。最直接的软件机会是工艺规划 Agent、跨设备任务编排、质量追溯、数字线程和证据自动归档。

来源：[HII 官方公告，2026-08-06](https://www.hii.com/news/hii-signs-performance-based-production-agreements-with-path-robotics-and-graymatter-robotics)；[Path Robotics 同步公告](https://www.path-robotics.com/news/hii-signs-performance-based-production-agreements-with-path-robotics-and-graymatter-robotics)。金额与期限由两家当事方交叉确认。

### 2. LiLa-WAM 把世界—动作模型压到单张 24GB GPU

8 月 4 日发布的 LiLa-WAM 冻结 DINOv3 视觉编码器，用 query adapter 压缩 patch，并让约 0.5B 的 DiT action expert 在同一 token 流中联合预测 flow-matching action 与未来 latent。Visual Transition Token 用示范首尾帧特征差编码任务，部署时不必输入语言或目标图像。

作者报告在 RoboTwin 2.0 的 50 个任务上平均成功率为**90.48%**，全模型 0.5B、可训练参数 0.2B，单 RTX 5090 约 110 GPU-hours；论文与官方 README 一致，但仍无第三方复现。其意义不是单一榜单第一，而是把“预测未来再行动”的训练门槛降到个人或小团队可承受区间。瓶颈是 VTT 对开放语言与组合泛化的适应性、仿真 clean 指标向真机迁移，以及仓库许可证尚未明确。

商业化距离：**中等，6—18 个月可做垂直工位试点**。可迁移机会：一卡训练/部署套件、数据 schema、实验追踪、benchmark runner、ONNX/TensorRT、回放诊断。

来源：[论文，2026-08-04](https://arxiv.org/html/2608.03701v1)；[官方代码仓库](https://github.com/teee000/LiLa-WAM)。

### 3. Tate 的 58 套焊接 cobot 给出本周最清晰的制造 ROI 证据

数据中心基础设施厂商 Tate 在三座工厂部署 58 套 Hirebotics Cobot Welder，以 Beacon Pro 统一编程、运行和监控。供应商与客户案例称，每名焊工产出达到此前 **12 倍**，非机器人背景焊工可在 10—20 分钟内完成上手培训。

客户名、部署数量、跨厂规模和生产率同时披露，使其比单台 PoC 更接近真实商业化；但“12 倍”仍缺少基线工件、良率、稼动率和 TCO 的独立审计。它证明近期预算更愿意流向明确工序，而不是泛化口号。软件机会在自然语言/示教转焊接程序、参数推荐、质量预测、跨厂配方版本控制和异常升级 Agent。

来源：[Hirebotics 案例全文，2026-08-06](https://www.roboticstomorrow.com/news/2026/08/06/hirebotics-cobots-help-tate-deliver-12x-output-per-welder/26922/)；[Yahoo Finance 同步稿](https://sg.finance.yahoo.com/news/hirebotics-cobots-help-tate-deliver-140000460.html)。

### 4. Hadrian 获 13.7 亿美元，把“软件定义工厂”推向重资产扩张

Hadrian 8 月 6 日宣布完成**13.7 亿美元 Series D**，估值**78.7 亿美元**，用于新工厂、研发和完整任务系统产能。公司现有四处设施合计接近 300 万平方英尺，Factories-as-a-Service 面向国防、航天、弹药与造船。

金额与估值由公司公告和 TechCrunch 交叉确认，但融资不能替代客户订单、产能利用率与毛利。它反映的机会不是再造一座工厂，而是把报价、工艺规划、机器/人员联合排程、质量证据图谱和跨厂数字线程做成软件层。

来源：[Hadrian 公告，2026-08-06](https://www.prnewswire.com/news-releases/hadrian-raises-1-37b-series-d-to-build-highly-automated-factories-to-accelerate-americas-industrial-renewal-302844408.html)；[TechCrunch，2026-08-06](https://techcrunch.com/2026/08/06/defense-tech-hadrian-raises-1-37b-at-8b-valuation/)。

### 5. 政策从补整机转向场景、标准与可审计性

本周中国中央层面未发现新的具身智能大额专项补贴原文，增量主要是地方承接七部门“揭榜挂帅”、深圳龙岗机器人场景项目申报、深圳建筑机器人需求清单，以及具身智能数据集八维质量要求公开。海外方面，欧盟 AI Act 自 8 月 2 日进入实施与执法阶段；日本经产省 8 月 5 日完成 AI 与机器人主管事务合并。

这意味着软件团队更适合切入需求结构化、测评验收、数据血缘、仿真回归、安全日志、SBOM 和合规证据链，而不是把所有产业扶持理解成“补贴整机”。

来源：[深圳住建局官方通知，2026-08-10](https://zjj.sz.gov.cn/xxgk/tzgg/content/post_12929446.html)；[欧盟委员会 AI Act 页面](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)；[日本经产省组织令修正](https://www.meti.go.jp/press/2026/07/20260731003.html)。

---

# 一、7 面雷达

## 1. 技术进展：从“大模型”转向可部署闭环

### 世界模型与合成数据

**GeniWorld**（8 月 6 日）把数值动作通过 URDF 和正向运动学渲染为像素对齐的 embodiment motion，再与视频 latent 一同输入 causal DiT，以 flow matching、自回归预测和 KV cache 建模场景变化。RoboTwin 2.0 使用 2,250 条训练、250 条测试轨迹；作者称合成数据加入 π0 后，四项真机 OOD overall success 从 **40.8% 提升到 69.0%**。精确数字仍为论文单源，代码页显示“Coming soon”。

相比直接把低维动作注入视频模型，视觉动作改善空间对齐；相比传统仿真，它减少手工建模，却仍可能生成“看起来对、物理上错”的接触过程。近期更适合作离线 policy evaluator 与数据增强器，而不是直接进入实时控制环。

来源：[论文，2026-08-06](https://arxiv.org/html/2608.06332)；[项目页](https://chenghaogu.github.io/GeniWorld/)。

### 长期记忆与层级 Agent

**AtlasVLA**（8 月 7 日）以 DINOv2/SigLIP、Depth Anything v3、外参回投影和 voxel hash 构建 4D Persistent World State，再以 Ego-Working Memory 跟踪任务进度；作者报告 LIBERO **97.6%**、RLBench **70.8%**，真机长程相对 π0 提升 17.5 个百分点。瓶颈是深度与手眼标定误差、voxel 旧状态污染、7B+300M 部署成本；没有公开代码，指标待验证。

来源：[论文，2026-08-07](https://arxiv.org/html/2608.06729v1)。

**HiRoC**（8 月 6 日）用 Qwen2.5-VL-3B planner 拆 subgoal，OpenVLA-OFT executor 先做 subgoal-conditioned SFT，再用 task-level + subgoal-level hierarchical GRPO 在线强化。作者报告 LIBERO-Long 98%，但没有真机指标，训练需要 8×H200。它与 AI Agent 的 planner/executor、typed subgoal、trace/eval、失败重规划高度同构，但 planner 错误级联与 reward hacking 仍是核心风险。

来源：[论文，2026-08-06](https://arxiv.org/html/2608.05999v1)。

### 人类视频到技能与数据层

**RoboReact**（8 月 4—5 日）从单帧 RGB-D 生成第一视角操作视频，经 3D 重建、object-centric keyframe、高自由度 retarget 和有界 VLM 编辑校准，最后把冻结技能重新落到物体位姿。四项真机任务平均 terminal success **81.3%**，论文与项目页数据一致；但任务仅 4 项、依赖多轮真机校准，代码与权重尚不完整。

来源：[论文 v2，2026-08-05](https://arxiv.org/html/2608.03387v2)；[项目页](https://roboreact.github.io/)。

**VLAff / EgoAffordance**（东京大学，8 月 5 日）把第一视角视频抽取为交互热图、96 维手抓姿与 6D 轨迹，数据集含 **204,025 episodes、5,782,431 heatmaps、11,612,524 trajectories**。作者报告 10 项仿真零样本平均 83%、5 项真机平均 68%。价值在于建立 object-centric affordance 中间层，避免动作完全绑定某一机器人；风险是 HOI、分割、MANO、SfM、深度和位姿估计形成长误差链。

来源：[论文，2026-08-05](https://arxiv.org/html/2608.05215v1)。

### 运动控制、固件与安全

韩国 KAIST 的 **TRACE**（8 月 6 日）用 30 步 IMU+关节历史、foot-aware cross-attention、GRU 与物理损失做足式里程计；0.2M 参数在 Raibo2 CPU 推理约 **0.2774ms**，作者称多地形 position ATE 相对最强基线降低 39.2%—53.8%。目前真机微调依赖 FAST-LIO2 参考，且主要是记录数据离线评估。

来源：[论文，2026-08-06](https://arxiv.org/html/2608.05975v1)。

**FineMote**（8 月 5 日）从 URDF/xacro 类树结构生成 device object，把 Update/Handle 两阶段和依赖/period 在编译期静态调度。FINS-ROV 真机中，最远 sensor→motor 平均间隔从 **1610.00μs 降到 53.64μs**，actuator jitter 从 18.87μs 降到 5.34μs。单平台结果待复现，但 URDF→固件代码生成、WCET profiler、CI timing regression 是很近的软件产品机会。

来源：[论文，2026-08-05](https://arxiv.org/html/2608.04600)。

ROS 2 于本周发布 **Lyrical Luth Patch Release 2**，覆盖 RHEL 10、Ubuntu 26.04 和 Windows 二进制包。它没有性能 benchmark，却提供了一个现实切口：企业升级验证、跨架构构建、SBOM/CVE、launch graph 测试和 bag replay CI。

来源：[GitHub Release，2026-08-07/08](https://github.com/ros2/ros2/releases/tag/release-lyrical-20260807)。

一项真实世界物理 prompt injection 研究在 Kinova + RealSense 分拣场景测试纸面文字攻击，5,670 次试验中，GPT-4o、Gemini 2.5 Flash、Qwen3-VL-32B 攻击成功率分别为 **27.0%、29.4%、5.0%**；two-stage verification 和文字 masking 能显著降低攻击，但 masking 会伤害必须读标签的任务。它说明具身 Agent 必须把视觉内容与控制权限分离，保留双模型验证、policy-as-code、人工批准和硬件急停。

来源：[论文，2026-08-06](https://arxiv.org/html/2608.05715v1)。

## 2. 产品与公司：明确工序胜过通用演示

- **Tate × Hirebotics**：58 套焊接 cobot 跨三厂部署，供应商/客户称每名焊工产出 12 倍；属规模部署，但 TCO 和良率待独立审计。
- **KUKA × Contoro × States Logistics**：非结构化卸货从人工 2—3 柜/8 小时提高到机器人 4—5 柜/班，采用按柜计价 RaaS。KUKA 原始案例在窗口外，本周报道属于窗口内，因此部署数字作为背景引用。破损箱和严重位移仍需人工。
- **FedEx × Dexterity**：本周权威报道延续 7 月 30 日官方公告，Mech 双臂与 Foresight 世界模型从试点扩大到较大生产验证；原始公告明确为“背景，非本周”，且未披露台数、装载速率、可用率和成本。
- **Avnet × Weston Robot**：以最高 50 TOPS AMD Ryzen AI Embedded、3D LiDAR SLAM、视觉/热成像异常检测做 GPS 拒止环境巡检；没有客户名、台数、价格与误报率，判为早期 PoC。
- **DOBOT LUMO**：近 1.3 米双足人形定位家庭、教育、陪伴和商演，宣称有视觉/语音情绪识别与长期学习；无价格、开售、续航、载荷、安全认证与客户数据，仍是产品发布/演示阶段。
- **Robo Inc.**：RoboStore 新设美国本地制造与系统集成公司，计划建设 6.6 万平方英尺设施，2027 年 Q1 全面运营。公司自报销售/部署 1,500+ 台、4,500 客户、4,000+ 开发者，均为单源待验证；但“硬件无关集成+安全测试+售后”本身代表价值链迁移。
- **VicOne Radeis Extension**：把 DEF CON 机器人攻击研究做成免费的 NVIDIA Isaac Sim 扩展，能观察网络攻击如何改变机器人行为。它是安全开发工具发布，不是客户规模部署。
- **Blue Water Autonomy**：进入美国海军 NAVOCEANO 多供应商 IDIQ 合同池，以无人水面船执行深海测绘。**4,000 万美元是合同池上限，不是该公司独占订单**。

## 3. 投资融资与资本市场：硬件、数据、自动化工厂三线并行

- **Hadrian**：13.7 亿美元 Series D、估值 78.7 亿美元，双源确认；融资规模不能替代订单与毛利。
- **Avatar Robotics**：650 万美元种子轮，多源确认；路线是“移动操作机器人+远程人类”，先解决仓储连续履约，再用遥操作轨迹提升自治。公司称自 2025 年 12 月以来协助处理 90 万+件商品，但这是公司口径，不等于自主完成件数。
- **恺望数据**：获超 1 亿元战略融资，亦庄产业升级基金、华方资本、天际资本联合领投，多家具身公司跟投；金额与投资方有二级双源，官方单月“有效数据约 10 万小时”缺少任务分布、有效率、权益与审计口径，待验证。
- **橡木果机器人**：完成天使轮，招商局创投、蔚来资本共同领投；本轮金额未披露，累计金额与前轮时间存在报道差异，不纳入本周融资总额。
- **Vangrid**：900 万美元种子轮，拟用手机传感器建立可溯源空间数据网络；二级聚合可能同源，MOU 不等于收入，待公司或投资方确认。
- **宇树科技 IPO**：Reuters、Bloomberg 等报道申购价格 150.80 元/股、估值约 610 亿元；2025 财务数据来自招股书转述，主报告不将约 219 倍历史盈利当作精确投资结论，需继续核验上交所原件。

本周融资结构说明：资本既押注本体与自动化产能，也在押注数据、空间智能和远程运营层。但“融资=商业化”仍是最大误读。

## 4. 政策与产业扶持：本周没有“大补贴”，有更具体的执行入口

### 中国

1. **工业和信息化领域创新任务“揭榜挂帅”地方承接**：沈阳 8 月 7 日、湖南 8 月 4 日组织申报，中央原通知在窗口外。方向覆盖人形机器人与具身智能、工业专用软件、AI 底座、智能装备和网络安全；每主体每专题最多 3 项任务，攻关期不超过 2 年。公开网页没有统一补助金额。
   - [沈阳官方通知](https://jxw.shenyang.gov.cn/tzgg/202608/t20260807_5069771.html)
   - [湖南官方通知](https://gxt.hunan.gov.cn/gxt/xxgk_71033/tzgg/202608/t20260804_34039387.html)
2. **深圳龙岗人工智能和机器人专项申报**：8 月 5 日启动信息与对接平台、场景应用揭榜两类申报；可读正文未稳定呈现补助额度，金额待附件复核。
   - [龙岗官方指南](https://www.lg.gov.cn/gkmlpt/content/12/12923/post_12923461.html)
3. **深圳建筑机器人场景征集**：8 月 10 日官方通知，8 月 15 日前提交需求；入选广东省清单的项目同步进入深圳市需求清单，无直接资金承诺。
   - [深圳住建局通知](https://zjj.sz.gov.cn/xxgk/tzgg/content/post_12929446.html)
4. **具身智能数据集质量要求公开**：政府网站 8 月 5 日披露完整性、一致性、多样性、真实性、易用性、实用性、可扩展性、安全性八维评价；标准批准日期和公告编号仍需工信部原件复核。
   - [河北省委网信办页面](https://www.caheb.gov.cn/system/2026/08/05/030391506.shtml)
5. 中央、北京、上海、浙江、江苏本周未发现新的、直接针对具身智能整机或关键部件的大额专项补贴官方原文；上海“AI+制造”最高支持 2,000 万元为 7 月政策，**背景，非本周**。

### 海外

- **欧盟**：AI Act 于 8 月 2 日进入适用与执法阶段，AI Office 与成员国主管机关开始监督执行；透明度规则自 2026 年 8 月起生效。机器人中的 AI 安全部件、关键基础设施应用可能进入高风险框架，要求风险管理、高质量数据、日志、技术文档、人类监督、鲁棒性与网络安全。产品内嵌高风险 AI 的部分义务有延长期，不能笼统说“所有机器人本周全部合规”。
- **日本**：经产省将机器人事务从制造产业局移至商务信息政策局，新设“信息处理系统开发・机器人课（AI 产业战略课）”，统一推进 AI 与机器人。无直接补贴金额，但后续资助、标准和示范项目更可能按软硬一体组织。
- **美国、韩国、新加坡**：本时间窗内未发现同等强度的重大机器人专项新政官方原文。美国 FCC 机器人国家安全认定文件为 7 月 27 日，属于背景；本周的法律和行业解读显示其会影响移动机器人准入与供应链证明。

## 5. 市场与商业化：客户正在购买“任务结果”

本周可见的商业化证据按成熟度分层：

| 阶段 | 案例 | 判断 |
|---|---|---|
| 发布/演示 | DOBOT LUMO | 无价格、交付、安全与客户指标 |
| 试点准备 | Avatar Robotics、Gene.01 | 人在环或联合开发，自治率与成本未披露 |
| 可用平台/早期 PoC | Avnet–Weston 巡检 | 技术栈完整，缺客户和误报率 |
| 认证型 PoC→条件放量 | HII–Path–GrayMatter | 以成本、进度、质量里程碑决定交付 |
| 较大生产验证 | FedEx–Dexterity | 客户称超越 pilot，缺台数与 TCO |
| 生产部署 | Tate–Hirebotics、States–Contoro | 有台数或吞吐，但仍需独立审计单位经济性 |

真实 ROI 应统一折算为每合格件、每柜、每装载拖车、每合格工时成本，并计入人工看护、远程操作、集成、停机、耗材、维护、网络、安全认证、返工和资本成本。演示速度不能替代这一核算。

## 6. 用户与需求侧：人兜底、可验收、合规本地化

1. **客户要可验收结果**：HII 把采购与成熟度、成本、进度、质量绑定；焊接和卸货案例也以产出与吞吐衡量。
2. **人在环不是失败，而是早期商业模式**：Avatar、Nucleus 等先用远程监督保证连续履约，再积累数据；但必须公开每台机器人每班的远程人力分钟数，否则毛利可能退化为劳务外包。
3. **数据小时数不等于训练价值**：恺望数据“10 万小时/月”如果没有场景分布、失败标签、版权、复用权与质检口径，不能与高质量训练资产等价。
4. **合规与本地服务进入采购清单**：美国准入、BOM 原产地、固件更新、数据流与售后会拉长销售周期，也提高本地系统集成、SBOM、OTA 治理和证据包的价值。
5. **负面信号必须看完整上下文**：社交媒体中的“机器人倒地”若无原始视频、设备身份和报告，只能作为噪声；BYD“小迪”规格与 Figure 爬梯视频没有可核成功率，不能转化为采购判断。

## 7. 入局机会：软件/Agent 能力比造本体更短路径

### 立即学习

1. **ROS 2 + rosbag2 + lifecycle + DDS/实时性**：目标不是会跑 demo，而是能做版本升级、回放、故障隔离和跨架构构建。
2. **机器人任务评测方法**：成功率之外，学习干预率、MTBF、任务时延、恢复率、能耗、良率、TCO 和安全事件口径。
3. **仿真与数据闭环**：Isaac Sim / MuJoCo / Gazebo 中至少选一套，理解 domain randomization、Sim2Real、真机 holdout 和合成数据 provenance。

### 可做 demo

1. **机器人运维/遥操作控制平面**：任务队列、权限、视频/rosbag 回放、远程接管、干预率与 SLA 看板。
2. **仿真—实机回归 CI**：给同一 policy 建固定场景集、版本门禁、失败聚类、回滚与报告；加入视觉 prompt injection 安全用例。
3. **具身数据质量 Agent**：按完整性、一致性、多样性、真实性等维度做规则检查、抽样复核、场景覆盖与数据血缘。
4. **planner/executor 安全中间件**：typed subgoal、策略白名单、约束投影、失败重规划、人工批准、硬件急停接口。
5. **ROS/固件确定性工具**：URDF→设备依赖图、WCET profiler、时序回归、跨架构构建和 SBOM。

### 可找合作

1. **工业焊接、打磨、巡检、卸货集成商**：场景明确、验收指标清晰，适合共同做任务编排、质量闭环与运维中台。
2. **机器人数据采集/训练场**：不卷采集人力，提供数据版本、质检、权益、交付验收与跨本体 adapter。
3. **地方场景方与联合体**：围绕建筑机器人需求清单或揭榜任务，用“需求—能力—测试—验收”平台进入项目，而不是只做代理申报。

### 可投资观察

1. **Robotics Ops / 安全与合规**：SBOM、设备身份、OTA、回放、审计、FCC/EU 证据链。
2. **垂直工艺软件**：焊接、打磨、巡检、卸货等每个场景的自然语言示教、质量检测和异常处置。
3. **数据质量与跨本体表示**：affordance、空间数据、合成数据校准、可溯源数据资产，而非单纯按小时采集。

### 暂不建议

1. **从零自研通用人形本体**：资本、供应链、安全认证、售后和量产一致性不匹配当前软件背景。
2. **只做“大而全”通用 VLA**：算力和数据投入高，客户采购指标仍落在具体工序；优先做评测、部署、记忆与安全层。
3. **把演示、框架上限或融资额当收入**：HII 9 亿美元、Blue Water 4,000 万美元都不是已确认独占收入；应建立分阶段收入和验收模型。

---

# 二、产业链 / 技术栈地图

| 环节 | 本周信号 | 核心瓶颈 | 对软件/Agent 背景的迁移机会 | 商业化距离 |
|---|---|---|---|---|
| 1. 上游硬件与供应链 | 多模态触觉手指融合静压力与振动；政策项目要求实机验证；FCC 背景规则强化 BOM 溯源 | 耐久、温漂、封装、标定、批量一致性、原产地证明 | 触觉标定 SDK、时序采集、sensor simulation、部件兼容矩阵、SBOM | 近中到中远 |
| 2. 本体与运动控制 | RoboReact 全身技能、TRACE 足式状态估计、焊接/卸货固定工序放量 | 接触物理、闭环稳定、标定漂移、异常恢复、安全冗余 | skill compiler、状态估计回放、任务安全网关、远程接管 | 近中 |
| 3. 数据层 | EgoAffordance、恺望数据融资、具身数据质量八维要求 | 小时数虚高、版权/复用权、失败标签、跨本体差异 | DataOps、lineage、自动质检、active review、action adapter | **近，推荐** |
| 4. 仿真与训练基础设施 | GeniWorld、HiRoC、RaiSim、VicOne Isaac Sim 安全扩展 | 仿真—真机相关性、接触失真、成本与场景覆盖 | benchmark runner、world-model evaluator、仿真回归 CI、攻击场景库 | **近中，推荐** |
| 5. 模型与算法 | LiLa-WAM、AtlasVLA、HiRoC、VLAff | 真机泛化、长期记忆污染、planner 级联、端侧算力 | 一卡训练部署、memory store、planner/executor 协议、安全策略 | 中 |
| 6. 软件工程与工具链 | FineMote、ROS 2 Patch 2、物理 prompt injection 基准 | 实时性、版本碎片、OTA、可观测性、回滚和网络安全 | Robotics Ops、ROS CI、固件时序、审计日志、policy-as-code | **最近，最推荐** |
| 7. 系统集成与应用 | 造船、焊接、卸货、物流、巡检、建筑场景清单 | OT 接入、工艺认证、售后、客户流程改造、TCO | MES/WMS/TMS/CMMS 集成、工艺 Agent、数字验收、SLA | 近 |
| 8. 商业生态 | HII 绩效合同、RaaS、Robo Inc. 本地集成、Hadrian 自动化工厂 | 销售周期、条件性收入、资本密集、远程人工吞噬毛利 | RaaS 计费、合同里程碑、伙伴市场、合规与本地化平台 | 近中 |

## 上游硬件专项观察

8 月 7 日中国团队发布多模态触觉手指，将多孔压阻层的静压力与 microphone 宽带振动结合，在 UR5、定制触觉指、灵巧手和 Azure Kinect V4 组合上验证古琴按弦等接触任务。它说明触觉正在从“单力值”走向多模态事件流，但耐久性、批量一致性、温漂、封装、标定、BOM 与采购价格均未公开，商业化距离仍偏远。软件团队更适合做 calibration SDK、触觉事件 API、数据采集和仿真 sensor model。

来源：[论文，2026-08-07](https://arxiv.org/html/2608.07002v1)。

---

# 三、风险与反共识

1. **短期最大软件机会可能不是机器人“大脑”，而是人工监督、验收和运维基础设施。** 真部署仍靠人处理长尾，能持续量化并降低接管率的系统才更接近规模毛利。
2. **“数据小时数”可能成为新的“参数量泡沫”。** 没有任务分布、失败标签、版权、复用权和质检标准，10 万小时并不比 1 万小时更有价值。
3. **条件性框架上限不等于订单。** HII 的 9 亿美元受技术与制造里程碑约束；Blue Water 的 4,000 万美元是多供应商合同池。必须区分上限、已授予、已交付、已确认收入。
4. **RaaS 可能降低客户门槛，却反转供应商毛利。** 维修、折旧、远程操作员、低利用率和 SLA 罚则都留在供应商端；若不披露每台每班人工占用，收入增长可能伴随负贡献毛利。
5. **高仿真分数不等于量产可靠性。** 本周多数论文缺第三方复现、长期耐久、故障率、安全认证和价格；SOTA 不能直接推导采购。
6. **Agent 与低层控制必须隔离。** 视觉文字注入、planner 错误级联和记忆污染都可能把软件错误转成物理风险；高层规划应通过 typed action、约束投影、人工审批与安全 PLC/急停执行。
7. **地缘合规会同时打击“海外公司”和“美国总部、海外制造”的产品。** BOM、软件来源、固件更新、数据流与本地化计划正成为投标材料；只做模型而忽视供应链证据会在采购阶段出局。

---

# 四、关键数据来源表

| 数据点 | 数值 | 来源 | 发布时间/更新日期 | 统计周期 | 是否本周 | 验证状态 |
|---|---:|---|---|---|---|---|
| HII 生产协议上限 | 最高 9 亿美元 | [HII](https://www.hii.com/news/hii-signs-performance-based-production-agreements-with-path-robotics-and-graymatter-robotics)、[Path](https://www.path-robotics.com/news/hii-signs-performance-based-production-agreements-with-path-robotics-and-graymatter-robotics) | 2026-08-06 | 7 年、附里程碑 | 是 | 双方交叉；不是确认收入 |
| HII 外包计划 | >250 万工时，+30% | [HII](https://www.hii.com/news/hii-signs-performance-based-production-agreements-with-path-robotics-and-graymatter-robotics) | 2026-08-06 | 2026 年 | 是 | 客户一手，单源待财务披露 |
| LiLa-WAM 成功率 | 90.48% | [论文](https://arxiv.org/html/2608.03701v1)、[GitHub](https://github.com/teee000/LiLa-WAM) | 2026-08-04 | RoboTwin 2.0 50 tasks | 是 | 论文/README 一致；无第三方复现 |
| GeniWorld OOD success | 40.8%→69.0% | [论文](https://arxiv.org/html/2608.06332)、[项目页](https://chenghaogu.github.io/GeniWorld/) | 2026-08-06 | 4 真机任务、每 setting 20 次 | 是 | 精确数为论文单源，待验证 |
| RoboReact 真机平均成功率 | 81.3% | [论文](https://arxiv.org/html/2608.03387v2)、[项目页](https://roboreact.github.io/) | 2026-08-04/05 | 4 项长程任务 | 是 | 双源一致；任务范围小 |
| EgoAffordance 数据规模 | 204,025 episodes；5,782,431 heatmaps；11,612,524 trajectories | [论文](https://arxiv.org/html/2608.05215v1) | 2026-08-05 | 数据集全量 | 是 | 单源待复现 |
| Tate cobot 部署 | 58 套；供应商称 12×产出 | [案例](https://www.roboticstomorrow.com/news/2026/08/06/hirebotics-cobots-help-tate-deliver-12x-output-per-welder/26922/)、[同步稿](https://sg.finance.yahoo.com/news/hirebotics-cobots-help-tate-deliver-140000460.html) | 2026-08-06 | 三座工厂 | 是 | 两处同源性较高；TCO 待审计 |
| Hadrian 融资/估值 | 13.7 亿/78.7 亿美元 | [公司公告](https://www.prnewswire.com/news-releases/hadrian-raises-1-37b-series-d-to-build-highly-automated-factories-to-accelerate-americas-industrial-renewal-302844408.html)、[TechCrunch](https://techcrunch.com/2026/08/06/defense-tech-hadrian-raises-1-37b-at-8b-valuation/) | 2026-08-06 | Series D | 是 | 双源确认 |
| Avatar Robotics 融资 | 650 万美元 | [The Robot Report](https://www.therobotreport.com/avatar-robotics-raises-6-5-m-seed-round-address-industrial-labor-constraints/)、[Robotics Tomorrow](https://www.roboticstomorrow.com/story/2026/08/avatar-robotics-raises-65-million-seed-to-build-the-unlimited-industrial-workforce/26917/) | 2026-08-05—08 | Seed | 是 | 多源；90 万件为公司口径 |
| 恺望数据融资 | >1 亿元人民币 | [中国基金报转载](https://finance.sina.com.cn/jjxw/2026-08-04/doc-inimekpi1955000.shtml)、[东方财富](https://wap.eastmoney.com/a/202608043831530732.html) | 2026-08-04 | 本轮 | 是 | 二级双源；10 万小时/月待验证 |
| 宇树 IPO 定价/估值 | 150.80 元/股；约 610 亿元 | [Reuters](https://www.reuters.com/world/asia-pacific/chinese-robot-maker-unitree-prices-shanghai-ipo-2026-08-06/)、[Bloomberg](https://www.bloomberg.com/news/articles/2026-08-06/china-s-unitree-seeks-904-million-in-first-mainland-robotic-ipo) | 2026-08-06 | IPO；2025 财务为背景 | 是 | 多源；招股书原件仍需核验 |
| Robo Inc. 设施 | 6.6 万平方英尺，2027Q1 全面运营 | [公司稿](https://www.prnewswire.com/news-releases/robostore-to-advance-us-localization-of-robotics-with-launch-of-robo-inc-302847020.html) | 2026-08-10 | 规划 | 是 | 单源待验证；尚未投产 |
| TRACE CPU 推理 | 0.2774±0.0188ms | [论文](https://arxiv.org/html/2608.05975v1) | 2026-08-06 | Raibo2 CPU 测试 | 是 | 单源待复现 |
| FineMote sensor→motor | 53.64±4.29μs vs 1610.00±10.68μs | [论文](https://arxiv.org/html/2608.04600) | 2026-08-05 | FINS-ROV 单平台 | 是 | 单源待复现 |
| 欧盟 AI Act 执法 | 2026-08-02 起 | [欧盟委员会](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai) | 页面本周有效 | 法规时间线 | 是（生效事件） | 官方原文核验 |
| 深圳建筑机器人申报 | 截止 2026-08-15 | [深圳住建局](https://zjj.sz.gov.cn/xxgk/tzgg/content/post_12929446.html) | 2026-08-10 | 本轮征集 | 是 | 官方原文核验；无资金承诺 |

---

# 五、重点来源抽查

抓取/阅读日期均为 2026-08-11。

1. **LiLa-WAM 论文**：URL HTTP 200；页面内容与 24GB 单卡、90.48%、VTT、未来 latent 表述一致；日期在窗口内。**通过**。
2. **HII 官方公告**：URL HTTP 200；明确 2026-08-06、七年、最高 9 亿美元、两阶段和 250 万工时；报告未把上限写成收入。**通过**。
3. **欧盟委员会 AI Act 页面**：URL HTTP 200；明确 2026-08-02 起 AI Office 与成员国机构负责实施、监督和执法，透明度规则 2026 年 8 月生效；高风险义务存在延长期。**通过**。
4. **日本经产省组织令页面**：URL HTTP 200；原决定日期 2026-07-31，8 月 5 日公布/施行、8 月 7 日更新；报告将组织生效列为本周、原决定作为背景。**通过**。
5. **深圳住建局建筑机器人通知**：URL HTTP 200；明确发布时间 2026-08-10 11:45、8 月 15 日截止、进入省市需求清单，未承诺资金。**通过**。
6. **ROS 2 Lyrical Patch Release 2**：URL HTTP 200；标题和正文均明确 2026-08-07 patch release，未虚构性能指标。**通过**。
7. **Hadrian 公告**：URL HTTP 200；13.7 亿美元、78.7 亿美元估值、四处设施/近 300 万平方英尺与报告一致。**通过**。
8. **Robo Inc. 公告**：URL HTTP 200；6.6 万平方英尺、2027Q1、1,500+ 台与 4,500 客户均来自公司自报，报告已标单源待验证。**通过**。

---

# 六、下周跟踪指标

1. LiLa-WAM 是否补充明确开源许可证、第三方复现和真机长程结果。
2. GeniWorld 是否发布代码、checkpoint，以及合成数据的真机相关性校准方法。
3. HII–Path–GrayMatter 首批通过资格认证的工艺数、实际授予工作量和每合格工时成本。
4. Tate 58 套 cobot 的良率、稼动率、停机、耗材和总拥有成本，而不只看 12×口径。
5. Avatar/Nucleus 每台机器人每班远程人力分钟、自主率、例外率和单位毛利。
6. 恺望数据“10 万小时/月”的有效定义、任务分布、失败标签、权益和客户验收口径。
7. 龙岗申报附件的补助上限、工信部具身数据质量标准公告编号与正式文本。
8. 欧盟成员国执法机构对机器人 AI 的高风险分类、日志和人工监督实践。
9. FCC 背景规则下新型号、固件更新、BOM 成本占比与本地化证明的落地案例。
10. 宇树 IPO 后的二级市场定价、招股书原件中的收入结构、毛利与交付口径。

---

## 结论：老板本周该怎么做

优先顺序应是：**先做 Robotics Ops / 回放评测 / 安全合规 demo，再进入单一工业工序的任务编排与验收，最后才考虑训练模型或绑定本体**。这一顺序既复用软件工程与 Agent 经验，也能在真机数据、客户流程和商业指标中形成护城河。

最值得本周启动的项目是“**机器人任务运行与证据控制平面**”：接 ROS 2/仿真，提供任务队列、typed action、远程接管、rosbag/视频回放、版本门禁、失败聚类、SLA、SBOM 和审计报告。它同时命中 Avatar 的人在环、HII 的里程碑验收、EU AI Act 的可审计性和数据质量标准，是无需重资产硬件、又能逐步靠近真实部署的切口。

**质量门控：覆盖 7/7｜产业链/技术栈 8/8｜重点技术事件含路线/指标/瓶颈/商业化距离/可迁移机会｜原文抽查 8/8｜关键数据表 16 条｜政策官方原文 6+｜入局机会 14 条｜风险/反共识 7 条。**
