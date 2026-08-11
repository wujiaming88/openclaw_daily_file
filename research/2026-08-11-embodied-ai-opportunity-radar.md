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

## 技术研究：世界模型、记忆、层级控制与安全中间层同时变厚

本节只把作者论文或项目页明确给出的内容写作“原文事实”；“作者主张”是论文对结果的解释；“我们的判断”是基于实验口径、对照与部署条件作出的独立分析。所有精确数值尚无第三方复现时均标注为作者报告。

### 1. LiLa-WAM：轻量世界—动作模型的价值不只是“单卡”，而是把未来预测变成训练时正则

**原文事实。** LiLa-WAM 冻结 DINOv3 ViT-L/16，先融合多个视觉层的 patch feature，再用 query adapter 压成固定数量 token。约 0.5B 的模型中约 0.2B 可训练；DiT action expert 把 noisy action chunk、proprioception、视觉 token 和 Visual Transition Token（VTT）放进同一 token stream，以 flow matching 预测动作速度，同时输出未来 latent。训练时，轻量 decoder 把未来 latent 对齐到未来图像的 DINO 特征；推理时 decoder 被丢弃，因此“预见未来”主要是共享表示的辅助监督，而不是在线生成一段视频。VTT 是同一任务多条示范首帧与末帧全局 embedding 差的平均值，部署时无需语言和目标图。官方仓库给出 Python 3.10、PyTorch 2.7.1/CUDA 12.8、处理后 RoboTwin 2.0 数据、权重和 eval 指南；作者报告 50 个 RoboTwin clean 任务平均成功率 90.48%，单 RTX 5090 联合训练约 110 GPU-hours。

**实验、对比与消融。** RoboTwin 由单模型覆盖 50 任务；LIBERO 则四个 suite 各训练一个策略，每任务 50 rollouts，不能把两个结果直接当成同一种“通用性”。论文称其在 RoboTwin 超过 8B Motus 与 5B GigaWorld，并以更小参数取得有竞争力表现，但不同方法的视觉输入、预训练和数据处理可能不完全一致。论文还做了 future-state supervision、VTT、视觉层融合等设计消融；真正应关注的是去掉未来监督后控制表现是否下降，而不是未来 latent 是否“看起来合理”。真机只覆盖 10 个桌面任务，能证明管线可落地，却不能证明开放世界组合泛化、长时序可靠性或跨本体迁移。

**作者主张。** 作者把主要贡献概括为：单 24GB GPU 可端到端训练、latent future prediction 与动作共享表示、VTT 免语言任务条件。

**我们的判断。** 这条路线的优势是研发门槛：小团队可以在一张消费卡上做可复核的 world-action ablation，而不必先获得视频生成模型级别算力。但 VTT 也是明显边界：它是“已知任务的平均视觉变化方向”，对同名任务中多个合法终态、组合指令、条件分支和在线新任务并不天然成立；任务 ID 实际被离线示范统计编码。90.48% 又是 clean 仿真口径，不能推导到真实车间。复现还依赖 DINOv3 权重、预处理、VTT 文件、stationary removal、outlier normalization 与 RoboTwin 版本锁定，仓库页面未明确展示许可证，商业使用要先清权。**工程/商业机会**不是再训练一个通用 VLA，而是做“一卡实验工作台”：数据 schema、VTT/goal-condition 生成、训练追踪、固定 benchmark runner、checkpoint/数据 lineage、TensorRT/ONNX 转换和真机 replay。对 Agent 工程的迁移点是把“任务条件”抽象成可版本化 artifact，并对每次 policy 变更建立任务级回归。

来源：[论文（2026-08-04）](https://arxiv.org/html/2608.03701v1)；[官方 GitHub](https://github.com/teee000/LiLa-WAM)。

### 2. GeniWorld：把动作渲染成“机器人运动视频”，目标是成为可交互的策略评测器

**原文事实。** GeniWorld 不把关节/末端数值直接塞给视频模型，而是利用目标机器人的 URDF 和正向运动学，从目标相机视角渲染不含背景与物体的机器人运动序列。视觉动作经 causal 3D VAE 编码后与 video latent 在通道维拼接，输入 causal DiT，以 flow matching 自回归预测下一段观察；KV cache 保留历史。其核心假设是把 embodiment kinematics 显式空间对齐后，模型可把“机器人如何动”与“环境如何变化”部分解耦。RoboTwin 2.0 使用 50 任务×45=2,250 条 clean 训练轨迹、250 条 clean holdout，并把 250 条 random 轨迹作为零样本 OOD 测试；每条 121 帧、24fps。真机部分每任务以 25 条真实示范为起点，再生成 65 条空间随机轨迹和 65 条多样条件轨迹；H20、5 sampling steps 下约 8Hz。

**实验、对比与消融。** 论文用 PSNR/SSIM、LPIPS、FID/FVD 比较视频质量，并比较 clean→clean 与 clean→random，消融显示 dense visual action 比低维动作或弱空间条件更能保持命令运动。更关键的下游实验不是视频观感：四个真机任务（Move Bowl、Fold Towel、Place Mug、Open Drawer），每种设置各 20 次。只用真实数据时五类设置 overall 为 40.8%；加入 spatial-gen 后 51.0%；再加 diverse-gen 后 69.0%。例如 novel instance 均值从 30.0% 到 70.0%，distractor 从 33.8% 到 72.5%。项目页目前明确写着 Code “Coming soon”。

**作者主张。** 作者认为视觉动作改善 OOD 可控性，使世界模型可用于 policy evaluation 与生成新的操作轨迹。

**我们的判断。** 40.8→69.0 是本周最值得跟的合成数据结果之一，因为它来自真实机器人策略的多设置试验，而不是仅看 FVD。但“视频世界模型”仍不等于物理模拟器：接触力、摩擦、柔性物体、遮挡后的状态和不可见失败可能被生成模型用视觉先验“补得合理”，造成 evaluator 过度乐观。8Hz/H20 也离多数低层闭环 20–100Hz 有距离，更适合离线筛选、遥操作预演和中高层滚动预测，不宜直连安全关键控制。复现需要 URDF、精确相机外参、动作重放/渲染器、视频 backbone、H20 级显存以及真实—合成数据配比；代码未发是当前最大阻塞。**工程机会**是 world-model evaluator：定义 policy adapter、scenario manifest、real-vs-model calibration、counterfactual rollout、相关性报告、假阳性案例库；另一个机会是合成数据 provenance，把原始真机轨迹、图像编辑条件、生成轨迹和最终 policy 版本串成可审计谱系。Agent 团队可把人类遥操作和 policy 统一成 action provider，并在模型中先运行计划、只把通过风险门限的计划送真机。

来源：[论文（2026-08-06）](https://arxiv.org/html/2608.06332)；[官方项目页](https://chenghaogu.github.io/GeniWorld/)。

### 3. AtlasVLA：VLA 的“记忆”开始从上下文窗口变成可写、可忘、可检索的 4D 状态

**原文事实。** AtlasVLA 严格只用 wrist RGB、机器人状态与语言指令。它用冻结视觉编码器提 token，以 Depth Anything v3 流式深度、相机内参、手眼标定和末端位姿回投到 3D；token 加空间/时间 embedding 后写入 voxel-hash world memory，同一 voxel 按深度置信度融合，并通过 temporal sliding window 遗忘，同时保留首帧 anchor。另一条 Ego-Working Memory 用 learnable query 压缩历史、做冗余感知 consolidation，表征任务进度。动作端是约 300M 的 step-wise conditioned DiT，顺序读取 ego 与 world context；LLM 规模 7B。训练用 8×A100、FSDP、global batch 256；推理 10 步 DDIM。作者报告 LIBERO 97.6%、RLBench 70.8%，RLBench 每任务验证 20 episodes；真实长程任务相对 π0 提升 17.5 个百分点。

**实验、对比与消融。** 论文与 wrist-only、multi-view VLA 及 π0 等基线比较。消融比总榜单更能说明价值：真实任务 full system 为 69.5%，去掉 world state memory 降到 54.0%；去掉 ego-working memory下降 13 个百分点；naive accumulation 相比时空更新低 11.5 个百分点；去掉 world-state conditioning 也明显下降。这说明“有历史”不等于“有用记忆”，写入、去重、空间融合和遗忘策略才是主要技术增量。

**作者主张。** 作者认为 dual memory 解决 wrist camera 的视野遗忘和长任务的进度遗忘，让单视角系统超过部分多视角基线。

**我们的判断。** 这是最贴近 Agent memory 工程的 VLA 工作，但物理世界记忆比文本 memory 更难：Depth Anything 的尺度/局部误差、手眼标定漂移、末端柔顺变形都会把同一物体写进错误 voxel；物体被机器人移动后，旧 token 可能继续存在，形成“幽灵状态”。滑窗和首帧 anchor 也存在冲突：首帧对静态布局有用，对被移动物体可能永久过期。作者没有提供公开代码，8×A100 与 7B+300M 使复现门槛高；真实任务规模仍不足以证明数小时运行的地图稳定性。**软件机会**是具身 memory service，而非训练整个 AtlasVLA：统一 world-state schema、对象/voxel TTL、置信度衰减、写冲突检测、relocalization、memory snapshot/replay、任务进度 state machine 和“证据指针”。Agent 工程可迁移 event sourcing、vector retrieval、working/episodic memory，但必须增加几何一致性、时间有效性与传感器来源可信度。

来源：[论文（2026-08-07）](https://arxiv.org/html/2608.06729v1)（方法、实验、消融、附录均已读；本周未发现独立官方代码/项目正文，指标为单一一级来源）。

### 4. HiRoC：真正的增量是 planner–executor 对齐，而不只是“给 VLA 外挂一个 LLM”

**原文事实。** HiRoC 把高层 planner 与低层 VLA executor 分开。planner 使用从 VLA-OS 清洗、统一标签并重标冲突样本的数据做 SFT，预测“当前观察下的下一个 subgoal”；随后冻结 planner。executor 原本只理解全局任务，为避免直接切换到 subgoal 后的分布错位，先把轨迹拆成 `(observation, subgoal, action chunk)` 做 subgoal-conditioned SFT，再在 planner 生成的 subgoal 下进行在线 RL。Hierarchical GRPO 同时利用整条任务回报与 subgoal 进展，group size 8。实验使用 Qwen2.5-VL-3B planner、OpenVLA-OFT executor，8×H200；每任务 50 test episodes，与十个代表性基线比较。作者报告跨基准平均提升 10.06%，LIBERO-Long 达 98%。

**实验、对比与消融。** 对照包括平坦 RL、显式规划、world-model/reward-model 等路线。去 planner 会显著降低最终性能并使学习曲线波动；global GRPO 是主要增益，local/subgoal GRPO 进一步改善。论文有真机部署展示，说明能执行 approach—grasp—transport—place，但没有像仿真一样披露足够的多任务、重复次数和置信区间，因此不能把“真机成功演示”写成量化泛化证明。

**作者主张。** 作者认为显式 subgoal 让长时序任务具备阶段锚点，SFT 解决 planner/executor 冷启动，层级 reward 提供比最终成败更密集的学习信号。

**我们的判断。** 这和软件 Agent 的 planner/executor 模式高度同构，但机器人版本的错误代价更高：planner 可能产生语义合理却动力学不可执行的 subgoal；executor 在局部奖励下可能 reward hack；planner 冻结意味着执行失败不能反向修正规划器；subgoal completion detector 一旦误判，会提前切阶段。8×H200 也使在线 RL 很难成为普通团队的近期产品。**最可迁移机会**不是复制训练，而是定义“具身 subgoal 协议”：typed object/action/constraint、precondition/postcondition、可达性检查、超时与恢复、trace ID、planner/executor 版本、人工批准和失败重规划。可做一个 ROS 2 + 仿真的 hierarchical trace/eval：比较全局任务成功率、每 subgoal 成功率、重规划次数、级联失败和人类接管率。这样既复用 Agent orchestration，又能在不拥有大模型训练预算的情况下进入具身栈。

来源：[论文（2026-08-06）](https://arxiv.org/html/2608.05999v1)（方法、实验、真机展示、消融均已读；未找到独立官方代码正文，量化结果为单一一级来源）。

### 5. RoboReact：生成视频不是动作真值；可执行性的来源是对象中心技能编译与 15 轮校准

**原文事实。** RoboReact 从一个第一视角 RGB-D 帧和任务语言生成候选人类操作视频，VLM 选择视频并挑出关键交互帧；系统用深度感知 3D 重建和手姿恢复，把视频编译为对象中心 keyframe skill。每个 keyframe 记录阶段（approach/align/fixed）、参考物体、左右末端 SE(3)、手指命令和有效 mask。相对物体的手—物几何在测试时按当前物体位姿重新落地；候选编辑必须通过结构、物体位姿新鲜度、支持的编辑类型、关节限位与 IK 可行性检查。冻结 VLM 只在校准 rollout 中看第一/第三人称 RGB-D、命令/实际末端、手指和 proprioception，提出有边界的局部编辑；测试时 VLM 不在控制环，技能冻结后交给 whole-body controller。

**实验、对比与消融。** 四个真机长任务为 Hand Over、Open Box、Pour Water、Open Drawer。终态成功率：ReKep 为 35/15/40/20，YOTO 为 75/65/80/75，one-shot real prior 为 85/70/80/85，RoboReact 为 85/70/85/85，平均 81.3%。这组结果说明生成视频先验已接近真实视频先验，但差距主要被后续校准吸收。校准并非小成本：主要结果采用 15 rounds；Pour Water 的逐步平均长度从无关键帧选择 3.69、无 memory 3.92、无第三视角 4.77，提高到 full 5.62。项目页还报告 Seedance 2.0 相比 1.5 Pro 提高 Pour Water / Open Drawer，证明视频先验质量有影响，但完整系统不是“一次生成就执行”。

**作者主张。** 作者将其定位为无需任务专用遥操作/人类示范、可从生成视频蒸馏全身技能的框架，并强调对象中心重落地与 VLM trial-and-error 可处理几何偏差。

**我们的判断。** 这项工作的工程价值在“skill compiler”，不在视频生成本身。生成视频没有可靠尺度、力、摩擦和遮挡后状态；可用性来自把连续视频压成少量可解释 keyframe，再以真实 rollout 校准。失败边界包括：物体检测/位姿错、透明反光物、双手接触力、软物体拓扑变化、IK 可达但动力学不稳、第三视角不可用，以及 15 轮真机校准对设备时间和安全员的消耗。81.3% 也不足以直接进入无人值守生产。复现需要 RGB-D、生成视频服务、手/物重建、对象位姿、whole-body controller、第三人称相机和严格的可行性投影；代码公开状态不明确。**软件/Agent 机会**是做可解释技能资产平台：keyframe DSL、对象坐标系绑定、版本 diff、rollout memory、VLM 建议审计、IK/碰撞 validator、校准预算调度、冻结/发布/回滚。它比让 VLM 在线输出关节命令安全，也更适合软件团队做跨本体 adapter。

来源：[论文 v2（2026-08-05）](https://arxiv.org/html/2608.03387v2)；[官方项目页](https://roboreact.github.io/)。

### 6. VLAff / EgoAffordance：用“哪里—怎么抓—怎么动”作为人类视频到机器人的中间 API

**原文事实。** 东京大学团队从带语言和时间段标注的第一视角视频出发，用大 VLM 找接触关键帧、动作/物体/手信息，再串联 hand-object detector、分割、2D 手点、MANO 3D 手重建、ego segmentation/inpainting、单目深度、内参估计、SfM 相机位姿和 3D 手轨迹，生成 EgoAffordance。最终规模为 204,025 episodes、5,782,431 visual heatmaps、11,612,524 trajectories；论文摘要和表格对对象/动作计数口径略有不同，写作时应采用实验设置中的精确全量数字而非混用“5.6M”。VLAff 以 Qwen2.5-VL 为核心，另接 DINOv2 密集视觉编码器；`<SEG>` 驱动 heatmap decoder，`<GRASP>` 回归 96D MANO（global wrist + 15 joints 的 6D rotation），轨迹被量化成自回归 6D pose token。预测后再用深度/相机信息把 2D contact anchor 抬升到 3D，输出对象中心 grasp 与 trajectory。

**实验、对比与消融。** 视觉 affordance 指标上，VLAff 的 IoU/NSS/SIM/KLD 为 0.121/1.542/0.142/2.517，优于 VRB、UAD、3DOI、LISA。零样本 manipulation 每任务仅 10 trials：10 个仿真任务平均 83%，略低于 VidBot 85%；5 个真机任务平均 68%，高于 VidBot 52%、其他基线 24–28%。这比“全面 SOTA”更准确：它在真机整体更强，但仿真平均并非最高。论文还在真实 Open Fridge 做去掉某一 affordance 模态的消融，说明 heatmap、grasp、trajectory 是互补信号。基线因本身不输出抓姿，统一外接 GraspNet；VLAff 用 human-hand→gripper retarget，比较仍包含不同接口带来的混杂。

**作者主张。** 作者认为对象中心 actionable affordance 能跨越人/机器人 embodiment gap，统一模型学习三种表示的相关性，从而支持零样本操作和 affordance-guided policy learning。

**我们的判断。** 这是比“直接把人类视频翻译成机器人 action”更可工程化的路线，因为 affordance 可以成为稳定中间 API。但自动标注链很长：接触帧、检测、分割、MANO、inpainting、深度、SfM、轨迹任一环节偏差都会被后续模型学成标签噪声；96D 人手姿到二指夹爪/不同灵巧手仍需 embodiment-specific retarget。每项 10 次的真机样本太小，68% 不能说明耐久或跨场景 SLA；数据、模型、代码许可也需核验。**软件机会**是 affordance DataOps：逐阶段置信度、自动异常检测、人工 active review、对象中心坐标规范、数据 lineage、跨本体 retarget plugin、heatmap/grasp/trajectory 一致性检查和评测服务。Agent 机会是让高层任务只输出 affordance intent，由受约束的 geometry/runtime 层生成动作，而不是把自然语言直接变成控制量。

来源：[论文（2026-08-05，IROS 2026 accepted）](https://arxiv.org/html/2608.05215v1)（全文方法、数据、实验与消融已读；本周未发现独立官方项目/代码正文，属单一一级来源）。

### 7. TRACE + 物理 Prompt Injection：端侧状态估计与高层语义安全，构成“Agent 不可越权”的上下护栏

#### 7.1 TRACE：0.2M 参数的价值在 contact-aware sensor fusion，而不是替代所有定位传感器

**原文事实。** TRACE 读取 30 步、每步 47D 的 IMU、12 关节位置/速度/目标力矩、上一时刻 roll/pitch 和水平速度、采样间隔，输出 3D 相对位移、Lie algebra 相对旋转和 body-frame velocity 共 9D。历史 body motion 经 temporal CNN 形成 query，当前加速度、角速度和四条腿形成 6 个 token，以两头 cross-attention 自适应加权；上下文进入 128 hidden GRU 与 `[256,128]` MLP。损失包含 Smooth-L1 estimation、速度积分与位移一致性、按 leg attention 加权的 contact-point velocity physics loss。RaiSim 中 400 并行环境，policy 100Hz、estimator 500Hz、simulator 4kHz，RTX 4060 约 20h；domain randomization 覆盖地形、摩擦、突发滑移、动力学、传感器/时序和外扰，再只微调 temporal encoder/head 到真机。

**实验事实与边界。** Raibo2 在 flat/rough/slippery/soft 室内与 grass/hard ground/stairs/full course 室外测试。比如 soft terrain position ATE 0.1530，对 IEKF-SR 0.7027、Legolas 0.7620、NMN-IEKF 0.3309；作者概括相对强基线降约 53.8%。0.2M 参数在 CPU 约 0.2774ms。消融支持 physics loss、policy randomization 和 real fine-tuning 的贡献。但真机参考轨迹来自 FAST-LIO2，论文主要是记录数据上的 odometry 评估；没有证明在闭环导航中长期替代 LiDAR/GNSS，也没有跨机器人形态验证。**我们的判断**：它适合作为 exteroception 失效时的短时 fallback/融合 measurement，而不是单独承担全球定位。产品机会是可移植 estimator SDK、传感器 timestamp/校准、domain-randomization recipe、硬件在环 replay、drift dashboard 和 OOD/contact uncertainty gate。

来源：[TRACE 论文（2026-08-06）](https://arxiv.org/html/2608.05975v1)（全文方法、训练、室内外实验与消融已读；无独立代码正文）。

#### 7.2 物理 Prompt Injection：5,670 次不是机器人执行，而是现实布景照片上的规划攻击

**原文事实。** 研究在 Kinova 机械臂、RealSense D435i 和真实水果/篮子工作台上拍摄三种 layout，把 20 种纸面攻击分为 indirect signage、task redefinition、authority impersonation、conflict injection；再配三种命令表达、三模型、21 条文本（含 neutral control）、每格 10 次，得到 `3×3×3×21×10=5,670` 次静态图像 VLM 规划评测。GPT-4o、Gemini 2.5 Flash、Qwen3-VL-32B 攻击成功率为 27.0%、29.4%、5.0%；成功攻击中 99.9% reasoning trace 明确认知了恶意文字。prompt defense、two-stage verification、text masking 分别可降低攻击，masking 在本 benchmark 达 100% 阻断，但会损伤必须读取标签的任务。

**作者主张。** 作者认为人可读纸条能通过模型正常的视觉—语言通道劫持规划，且简单防御有效但存在功能权衡。

**我们的判断。** 现文必须纠正：5,670 次不是机械臂真实执行，而是现实物理场景图像上的计划输出；因此它证明 planner vulnerability，不直接量化动作执行后的碰撞/伤害。静态顶视、单一分拣规则和三个模型也限制外推。不过，这个攻击面非常真实：视觉内容是“不可信数据”，不能与 operator/system command 同权。推荐的系统架构是：OCR/场景文字单独标记来源；VLM 只产生 typed proposal；独立 verifier 根据 operator intent、policy-as-code、空间/速度约束判定；高风险 action 要人工批准；低层 safety PLC/急停不接受 VLM 覆盖。可产品化为具身 Agent 安全网关、攻击场景库、仿真红队、权限与审计日志。不能简单全 mask，因为仓储条码、药品标签、工牌和安全标识本身就是任务输入。

来源：[论文（2026-08-06）](https://arxiv.org/html/2608.05715v1)（方法、完整 factorial 设计、结果和 mitigation 均已读；无独立项目正文）。

### 技术结论与机会优先级

1. **立即做：具身评测与回放控制平面。** 接 ROS 2/仿真，固定任务 manifest、policy/version、rosbag/video、成功/干预/恢复/时延，并加入 world-model 与真机相关性校准。
2. **立即做：typed subgoal + safety gateway。** 把 planner 输出限制在有 schema、precondition/postcondition 和权限的动作；视觉文字、用户指令、系统策略分信任域。
3. **可做 demo：具身 memory service。** 以对象/voxel 为实体，支持 TTL、置信度衰减、来源、冲突、快照与 replay；先在仿真测试“物体移动后的幽灵记忆”。
4. **可找合作：affordance/DataOps。** 给数据场/实验室做 heatmap—grasp—trajectory 自动质检、跨本体 adapter 和 lineage，而不是按小时堆采集量。
5. **观察而非重押：视频世界模型直接控制。** 当前 8Hz/H20、代码未发、接触物理可信度不足；先用于离线 evaluator 和数据合成。
6. **暂不建议：未经隔离的 VLM 在线关节控制。** planner 错误、视觉 prompt injection、memory 污染都可能变成物理风险，必须经约束投影、独立 verifier 和硬件安全层。

---

## 产品与部署：从“会动”转向“可验收、可运维、算得过账”

本周产品侧不应再按“厂商发布了什么”罗列，而应按客户采购成熟度观察。我们从 28 条候选中筛出 6 个值得保留的对象：两个已出现跨站点或持续运营数据（Tate、Serve），两个处于明确客户首站部署或扩场阶段（goodBytz、States Logistics），一个是认证后才放量的七年绩效框架（HII/HYPR），一个仍停留在无客户指标的产品方案（Avnet/Weston）。这六者恰好构成从发布、试点、生产验证到规模运营的证据阶梯。

### 2.1 HII × Path Robotics × GrayMatter：不是“9 亿美元订单”，而是一条要先过海军级资格认证的自主造船产线（美国·造船）

**成熟度：认证型 PoC → 条件性规模部署；不是已确认收入。**【原文事实】HII 8 月 6 日公告称，与 Path Robotics、GrayMatter Robotics 签署七年绩效型生产协议，拟授予合计最高 9 亿美元造船工作，但前提是两家公司达到技术、制造成熟度以及成本、进度、质量里程碑。协议分两阶段：先开发、验证并认证自主焊接、打磨、喷砂、涂装、装配、检测等工艺，再由 HII 根据表现把小型钢结构逐步扩展到单元和模块。HII 还称 2026 年计划外包超过 250 万工时，同比增加 30%。4 月 20 日的项目原文（背景，非本周）补充：2026 年跑概念验证，2027 年才计划启动完整 pilot；HYPR 不是孤立机器人单元，而是把焊接、物料移动、表面处理和质量检查串成一条连续结构制造线。

**目标用户与工序。** 用户不是普通焊接车间，而是 HII 及其分布式供应网络，最终产品要进入航母、潜艇、驱逐舰、两栖舰、护卫舰与无人水面舰。工序从钢板切配、组对、焊接，到打磨/喷砂/涂装、视觉或传感检测，核心痛点是船体结构高混流、尺寸大、焊缝和表面几何变化多，传统固定自动化难覆盖。Path 提供以 Obsidian 焊接模型为核心的视觉/机器学习自适应焊接及 Rove 移动焊接；GrayMatter 提供表面处理、涂装、检测的 Factory SuperIntelligence；HII 提供工艺知识、需求、资格认证和最终验收。公开材料没有说明具体机器人品牌、传感器 BOM、节拍、焊缝一次合格率或各家金额分配。

**部署流程与人在环。** 先选标准件/小钢结构建立工艺包，做海军级 coupon/结构件测试，验证焊接参数、表面质量、NDT/检测结果与追溯数据；再把多设备接到同一产线，经过 HII 的监督、资格认证和过程审计后，才进入交付。人在环不只是远程接管：焊接工程师制定 WPS/PQR，质量人员审批缺陷与返修，安全人员管理受限空间和喷涂/喷砂风险，HII 负责放行。异常工件、传感遮挡、装配偏差和质量判定都需要人工升级路径。

**验收、TCO/ROI 与运维。** 验收应该落在每合格工时成本、一次合格率/返修率、节拍、准时交付、设备可用率、NDT 通过率、材料追溯和安全事件，而不是“机器人完成一条焊缝”。9 亿美元是七年上限且附条件，不能直接当 Path/GrayMatter 收入。ROI 来自减少每船体工时、降低返修、提高外包结构件按期交付率；TCO 则必须计入厂房/产线、工装、传感与边缘算力、耗材、标定、海军资格认证、网络隔离、备件、驻场工程师、停机和返修。运维还要覆盖配方/模型版本控制、离线回放、工艺变更审批和数字线程归档。

**客户侧证据与规模瓶颈。** 最强证据来自买方 HII 的正式公告和按结果放量的合同结构；Path 的同步稿本质上仍复述同一交易，不能算独立客户。瓶颈是多工序耦合、军工资格周期、供应商产能、现场安全、跨工厂一致性以及“看起来焊好”与 NDT 真正合格之间的差距。【独立判断】它是本周商业含金量最高的信号，但价值不在 9 亿美元标题，而在客户已经把机器人采购改写成“认证—里程碑—合格产出”的机制。软件机会是工艺规划 Agent、产线编排、质量证据图谱、模型/配方审批、跨设备可观测性和自动生成资格认证包。

### 2.2 Tate × Hirebotics：58 套焊接 cobot 跨三厂，真正的产品是“焊接配方与权限的云控制面”（美国·数据中心制造）

**成熟度：跨三厂规模部署；生产率口径仍需独立审计。**【原文事实】8 月 6 日 Business Wire 全文（Morningstar 镜像）披露，数据中心基础设施厂商 Tate 在 Arkansas、Virginia、Kentucky 三处工厂部署 58 套 Hirebotics Cobot Welder，2024 年开始从手工焊转向自动化，已经运行约两年。供应商案例称关键结构件“每名焊工吞吐提高 12 倍”，无机器人经验的焊工 10—20 分钟可上手；Tate 操作员 Jonathon Cook 说明，可在软件中控制电流、热输入、行走速度和轨迹，让焊缝按规范执行。该材料有客户员工引语和明确地点/数量，但发布与案例由供应商组织，“12×”未给分母、产品组合、良率、OEE 或审计方法，因此只能标成公司/客户联合口径。

**目标用户、工序和栈。** 目标是面临数据中心建设高峰、交期紧且不能容忍结构错误的金属制造团队。cobot 承担重复焊缝、点固和预装，认证焊工转向需要判断、认证或复杂手工技能的工作。硬件是完整 Cobot Welder 单元（Hirebotics 为 Universal Robots OEM 伙伴，同时具 FANUC 集成资质；本案例未逐台披露机械臂型号）、焊机、焊枪、工装与安全配置；软件是云端 Beacon Pro，无代码编程、手机/平板运行与监控、角色权限、参数和 playlist 跨厂共享。Arkansas 厂还让 cobot 做上游点固和预组装，给下游工业机器人稳定供件，显示它不是单点替人，而是重新切分整条工序。

**部署与人在环。** 先由认证程序员建立焊接程序、角度、速度、热输入等“黄金配方”，用试件验证，再把低风险重复任务交给现场操作员；操作员装夹、选程序、启动、检查并处理异常，焊接工程师负责配方和变更，认证焊工处理复杂件，维护人员负责枪嘴、送丝、耗材、标定与机器人故障。Beacon Pro 允许跨厂复制配方，但这也要求版本冻结、权限、审计和回滚，避免一次错误参数同步到 58 台设备。

**验收、价格与 ROI。** 供应商官网搜索结果给出 Cobot Welder Core Package 起价约 10.5 万美元，但案例没有披露 Tate 的成交价，不能据此计算精确资本开支；若简单乘 58 也会忽略焊机、治具、培训、云订阅、集成和批量折扣。验收至少应看每班合格焊缝长度/合格件数、一次合格率、返工、换型时间、稼动率、操作员覆盖台数、耗材、停机与安全事件。ROI 的可信来源应是减少返工和焊工短缺造成的延期，而不仅是 12×峰值吞吐。交付运维的关键是远程诊断、配方库、设备健康、耗材预测和跨厂 SLA。

**证据边界与瓶颈。** 没有 Tate 自有官网案例、财务披露或第三方审计支撑 12×，多个转载基本同源，不能算多源独立验证。规模化瓶颈包括工件一致性与夹具、焊前准备、工艺资格、云连接/账号安全、跨厂配方治理和维护技能。【独立判断】这比人形机器人视频更接近现金流，因为目标工序、用户、数量、软件和生产改造都可描述；但真正护城河不是 cobot 本体，而是把焊接知识编码、分发、监控、回放并审计的控制平面。对软件/Agent 团队，机会在焊接参数建议、视觉质检、配方 GitOps、异常归因和多厂 OEE，而不是再做一台通用机械臂。

### 2.3 Serve Robotics：有 792 台日活和财务数据，也暴露“规模增长不等于单位经济成立”（美国·配送/医院）

**成熟度：规模运营，而非试点。**【原文事实】Serve 8 月 6 日 Q2 公告披露：季度平均日活机器人 792 台（上季 812、去年同期 160），日均可供服务小时 9,809（上季 10,295）；季度收入 323.8 万美元，其中 fleet services 230.5 万、software services 93.3 万；收入同比增 404%，但成本收入 1,201.7 万美元、毛亏 877.9 万，净亏 6,412.7 万。公司把全年收入指引降至 900万—1,000 万美元，原因之一是 Uber Eats 配送量低于预期并移除下半年预测需求。同时 DoorDash 收入环比增长近 50%，医院业务上半年新增 2 家医院并续签 7 份多年合同。公司称累计部署超过 2,000 台、覆盖约 300 万人口和 4,000 多家餐厅；这项累计口径与“日活 792”不是同一概念。

**用户、工序与系统栈。** 户外产品服务餐厅、平台和末端消费者，完成取餐、道路/人行道导航、交付和异常处置；收购 Diligent 后，室内机器人服务医院内部物资运输。硬件至少包含移动底盘、感知、通信、货舱/交互设备与充电运维设施；软件包括定位导航、障碍预测、车队调度、订单平台连接、远程监督、广告/媒体运营和医院工作流。公告没有披露每次配送成功率、每英里接管、续航、机器人单价、维修频率和具体远程操作比例。

**部署流程和人在环。** 新城市需要地图/运营区域验证、法规与道路许可、商户接入、取放点设计、充电/维护站、远程运营中心和平台订单路由；医院则需要电梯、门禁、消毒、感染控制、护士站/供应链系统和 SLA 集成。人在环应覆盖道路阻塞、身份核验、货舱问题、路线恢复、急停、医院紧急任务和维修派单。公司只公布 supply hours，没有公布其中多少小时有人远程关注，也没有披露每百单人工介入分钟，这是判断毛利是否会退化为“机器人外壳+远程劳务”的关键。

**验收、TCO/ROI 和运维。** 对平台/餐厅，应按每成功订单成本、准时率、取消/丢失、每机器人每日订单、利用率、远程干预、事故和客户满意度验收；医院则看每班完成任务、护士节省步行时间、任务超时、消毒合规与设备可用率。Serve 的公开财务让 TCO 风险可见：本季收入约 324 万美元而成本收入约 1,202 万美元，说明现阶段整体单位经济尚未证明；不能用“收入增长 404%”替代毛利。公司现金与证券 2.404 亿美元可支持扩张，但低于预期的 Uber Eats 量也证明需求侧和平台集中度会直接打击利用率。

**客户证据、交付运维与瓶颈。** 财报、客户续签数量和可供服务小时比发布视频强得多；但 DoorDash/Uber Eats 和医院具体站点的客户侧全文仍有限。规模瓶颈包括城市许可、天气/道路长尾、破坏与盗窃、充电维护、人类监督成本、平台订单密度和室内外两套运维体系。【独立判断】Serve 是本周最有反证价值的对象：它证明“已经规模运营”仍不代表 ROI 成立。软件机会不只在导航模型，而在远程运营编排、每单成本归因、自动恢复、跨城市版本发布、事故回放、平台需求预测，以及把室外配送和医院机器人统一到可观测的 fleet control plane。

### 2.4 goodBytz × Leonardo Hotels：8 平方米模块把“机器人厨师”收缩为可补货、可清洗、可验收的 24/7 Food Station（德国/奥地利·酒店餐饮）

**成熟度：客户首站部署/商业试点；不是连锁规模铺开。**【原文事实】goodBytz 与 Leonardo Hotels 8 月 5—6 日共同宣布，首台 luca 将部署于拥有 510 间客房的 Leonardo Smart Vienna Airport，提供全天候沙拉和 bowl。客户 Leonardo 的独立新闻稿补充：Food Station 从 8 月起成为酒店 24 小时自助服务的一部分，菜品几分钟内制作，冷菜直接食用、热菜需客人在 lobby 微波加热；系统有冷藏单元，每日补货并每日清洁，使用可重复餐具。客户 COO 明确称技术用于增加灵活性而非替代个人服务。这里的“deploys”是新站点投入使用/启动阶段，尚无订单量、利用率、故障率或多酒店扩张数字。

**目标用户与工序。** 目标用户是机场酒店、夜间到店客人和受夜班/厨工短缺影响的运营方。机器人负责从冷藏原料取料、按菜谱计量、在炉位烹饪/混配、出餐及部分集成清洗；人仍负责采购、食安、每日补货、清洁、菜单/过敏原、前台服务和异常处置。背景材料（FANUC，5 月；非本周）揭示硬件：约 8 平方米金属模块内，一台食品级 FANUC LR Mate 操作 8 个炉位、冰箱和集成清洗功能；软件对每张订单动态重算并行工序，以调度炉位、时间和机械臂动作。

**软硬件栈与部署流程。** 硬件包含工业机械臂、食品级密封/材料、高防护等级、炉位、冷藏、配料/容器与清洗模块；软件包括菜谱和批次、订单队列、峰值调度、温度/时间控制、库存、过敏原与清洗日志。部署不能只“把机器人搬进酒店”：要完成给排水、电力、通风/消防、冷链、HACCP/本地食安、菜单工程、原料规格化、POS/支付、动线和重复餐具回收。上线后应先影子运行和食品抽检，再扩大时段与菜单。

**人在环、验收与 TCO/ROI。** 人在环主要是每日补货/清洁、品质抽检、卡料或溢出处理、食品安全放行和客户服务，不是完全无人餐厅。验收要看每份出餐时间、订单完成率、峰值排队、温度/克重偏差、清洗合规、食品浪费、停机、人工分钟/餐、夜间销售增量和顾客评分。价格未披露，TCO 必须计入模块改造、原料规格化、清洗和补货人工、维护、食品损耗、支付/POS、停机时替代餐饮；ROI 应与新增夜间餐饮毛利、减少厨房常驻班次及更长服务时段比较，而不是简单用“替代厨师工资”。

**客户侧证据、运维与瓶颈。** 本对象达到“厂商原文+客户原文”：Leonardo 说明了实际菜品、清洁、冷链、微波加热与人员定位，比厂商的“自主厨房”口号更可验收。交付后需要远程监控、食材批次/保质期、菜谱版本、预防维护和本地 FANUC/模块备件。规模瓶颈是菜单与原料标准化、清洗可靠性、食品法规、峰值吞吐、客人接受度和酒店厨房基础设施差异。【独立判断】这是本周欧洲最有产品意义的案例：不是追求通用人形，而是把工业臂封装进一个边界清晰的服务单元。软件/Agent 机会在订单—菜谱—库存联合调度、HACCP 证据自动化、预测补货、异常客服和跨门店菜谱发布。

### 2.5 States Logistics × Contoro × KUKA：卸柜吞吐翻倍背后，人工仍负责移位、对接和极端货墙（美国·3PL；背景对照）

**时间与成熟度：客户生产部署；原始案例 2026-04-25，背景，非本周。本周 8 月 5 日行业报道只是再次传播，不能冒充本周首发。**之所以保留，是因为它提供现有文章其他对象缺失的部署流程、人工边界和 RaaS 计价证据。【原文事实】客户 States Logistics 每月处理 50 多个 floor-loaded trailer/container；过去一个 8 小时班由 2—3 人卸 2—3 柜，引入系统后可卸 4—5 柜。方案以可预测的“按 trailer 计价”RaaS 提供，并要求最低月量，但单价未公开。

**目标用户、工序与栈。** 用户是 3PL 仓库，工序是把无托盘、不同尺寸/重量、可能移位或破损的纸箱从热而狭窄的挂车卸到输送线，再码垛入库。硬件为装在移动底座上的 KUKA KR IONTEC 工业臂、Contoro DuoGrasp 双侧抓具、多摄像头、前向 LiDAR、真空系统、空气压缩机、控制箱和动力输送线；第二台机器人完成从输送线到托盘。软件 AdaptAI 根据货墙、箱体位置/尺寸/状态/重量生成大量无碰撞路径，通过 KUKA.SensorInterface 消化视觉与空间数据，决定顶部或侧面抓取。

**部署流程和人在环。** 操作员用手持控制器像开叉车一样在仓内移机、对准 dock，约 15 分钟完成设置；系统随后随货墙后退自主向 trailer 内推进。冷藏柜的沟槽地板要求改轮子和感知阵列，说明现场调试不可省。严重移位时人工先把货墙纠正，破损件由摄像头记录；工业臂在 trailer 封闭空间作业，入口有便携围栏和磁锁，破锁即停。也就是说“自主卸柜”并非无人：人负责移动、dock 对接、安全区、极端货墙、破损与恢复。

**验收、TCO/ROI、交付运维。** 可核验指标是每班 4—5 柜对 2—3 柜、15 分钟换 dock、箱损、每柜人工、接管次数、抓取成功、卡箱/掉箱、安全事件和设备可用率。RaaS 将 CAPEX 转为 OPEX并把部分设备残值/维修风险留给 Contoro，但最低月量会使低利用率客户失去经济性。真正 ROI 还包括背部工伤索赔、合同工波动、可预测排班和货损；TCO 包括客户电源、dock 改造、网络、最低量承诺、围栏、安全培训、现场响应和备件。运维需按箱型/冷藏柜维护感知与抓取策略，并持续跟踪每柜例外率。

**客户证据与规模瓶颈。** KUKA 案例大量引用 States Logistics 销售运营总监 Jesse Sevilla，且客户官网有“一年运行”相关页面线索；它比只看供应商标题强，但完整量化仍由合作方案例提供。瓶颈是严重移位、破损软包装、异形/透明/反光箱、冷藏柜地面、dock 差异和最低任务密度。【独立判断】按柜付费把供应商与客户结果对齐，是比“买机器人”更成熟的产品设计；但也会把长尾例外、维护和低利用率留在供应商损益表。适合软件团队做例外分类、远程协助、每柜成本归因、WMS 接口与跨站点策略版本管理。

### 2.6 Avnet × Weston Robot：技术栈完整，但没有客户、误报率和价格，只能标为产品方案/早期 PoC（新加坡/亚太·工业巡检）

**成熟度：产品发布/演示，不是客户部署。**【原文事实】8 月 5—6 日公告描述了一套面向工厂、能源、公用事业、交通、物流和关键基础设施的自主巡检平台：AMD Ryzen AI Embedded 端侧算力最高 50 TOPS，3D LiDAR SLAM 支持 GPS 拒止环境，视觉/热成像用于物体与异常、人员车辆、PPE、入侵、热点、泄漏和设备异常检测。公开全文没有客户名、机器人本体型号/价格、续航、IP 等级、爬坡、传感器精度、误报/漏报、部署台数或售后 SLA。

**用户与部署假设。** 目标用户是巡检员、EHS 与设施运维团队。典型部署应先做区域勘测和基线地图，定义巡检点、热阈值/PPE/入侵规则，接入 CMMS/告警平台，受控试跑并与人工巡检对照，再决定是否无人值守。人在环包括告警复核、禁区审批、遥控脱困、传感器清洁、充电和工单闭环。验收不能用“50 TOPS”，而要看路线完成率、定位丢失、每公里接管、热异常检出、误报/漏报、连续工作小时、充电占比、告警到工单关闭时间及危险暴露减少。

**价格、TCO/ROI 与瓶颈。** 所有价格均未披露，ROI 只能建立模型：节省的例行巡检工时+提前发现故障的避免损失+减少危险暴露，减去本体/传感器、现场建图、网络、充电、模型适配、误报处理、维护和折旧。规模瓶颈是粉尘/雨雾/反光、热像标定、跨场景 domain shift、GPS 拒止定位、网络和关键设施数据主权。【独立判断】现文把它写成“可用平台/早期 PoC”方向正确，但还应明确：这是厂商联合 PR，没有客户侧证据，因此不能与 Tate 或 Serve 同列为商业部署。可迁移软件机会在巡检任务编排、告警证据包、CMMS Agent、边缘模型版本/回滚和假阳性运营，而不是 50 TOPS 硬件本身。

### 背景对照：FedEx × Dexterity 为何只能写“7 月 30 日事件，本周被再报道”

Supply Chain Dive 8 月 10 日的正文确实在时间窗内，但其核心事实回指 FedEx 7 月 30 日官方公告。因此正确写法是：**背景，非本周首发**。FedEx 称 Hagerstown 从多年 pilot 扩展到更大生产验证，Mech 双臂用 Foresight 融合视觉、深度和触觉做 trailer loading；但官方没有披露台数、每小时箱数、空间利用率、接管、可用率和 TCO。它可作为“客户生产验证如何表述”的对照，不能为了凑本周对象写成 8 月新部署。

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
