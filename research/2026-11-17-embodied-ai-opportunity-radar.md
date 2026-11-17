<!--
role: 研究母稿（冻结），非公开文章
window: 2026-11-10 00:00 ~ 2026-11-16 24:00 (Asia/Shanghai)
inputs: shards/A-D、mainline-deep.md、wow.md
publication: 资料库 research/2026-11-17-embodied-ai-opportunity-radar.md；博客 _posts/2026-11-17-embodied-ai-opportunity-radar.md
-->

# 全球具身智能产业链研究周报｜2026-11-10 ~ 2026-11-16

- 期号：第 12 期
- 报道窗口（冻结）：2026-11-10 00:00 ~ 2026-11-16 24:00（Asia/Shanghai）。仅窗口内发生或首次披露的事件写为「本周」；区间外材料标「背景，非本周」；窗口内首次披露的历史事项标「本周新披露的历史事项」。美东/美西日期按原文标注。
- 读者定位：主责 R3（上下游与价值分配），协同 R2（交付、场景与可复制性）。
- 证据级：A 可核原始事实｜B 具名披露/研究结果｜C 有限独立佐证｜D 欠证或争议（仅母稿使用）。

## 导语

**本周一句话**：模型与数据在加速开放，入口与中间件在被收购——当权重变成公共品，价值迁移到「谁维护默认路径」；而这条默认路径的最大买家，本周进入治理空窗。

本周的开放侧有三件硬事：Runway 以 Apache 2.0 放出 27B 世界动作模型 Praxis-1（RoboLab-120 成功率 46.2%，高于 π0.5 的 28.0%）；Hugging Face 以 CC-BY-4.0 放出首版 10,124 小时第一视角数据；Newton v1.8.0 把接触求解做成可复现的开源路径。集中侧同样清楚：Hugging Face 待并入 NVIDIA（约 129 亿美元，2027 上半年交割）、MoveIt 维护方 PickNik 已被 Qualcomm 宣布收购（待交割）、NVIDIA 董事会 11-11 接受黄仁勋辞任、由 CFO 兼任临时 CEO。下游则第一次把 RaaS 写成可审计的合同与报表：GXO 与 Apptronik 签 LOI（4 年最多 1,000 台）、Serve 把运力做成按次计价的 API、Agility 的三季报显示 9 个月收入 36.1 万美元而净亏 4.587 亿美元。

## 本期主线专题（摘要；全文见 mainline-deep.md，核心论证并入下文）

**模型在开放，入口在集中**：①开放侧：Praxis-1（27B MoE、Apache 2.0、视频预测全程保留在训练目标中）【B；权重存在 A】；HubEgo-100K（10,124 小时、12,227 贡献者、CC-BY-4.0）【A】；Newton v1.8.0（SolverSteel、bitwise 确定性、CUDA graph）【A】。②集中侧：NVIDIA 8-K 载明 Hugging Face 交易约 119 亿美元购买价 + 最多约 10 亿美元保留计划，2027H1 交割、含监管批准条件，并承诺平台开放、支持其他芯片厂商【A】；Qualcomm 宣布收购 PickNik 并承诺 MoveIt 1/2 继续开源【B】。③治理变量：NVIDIA 董事会 11-11 接受黄仁勋辞任、CFO Kress 任临时 CEO、首设董事长、启动正式 CEO 搜寻【A】；媒体称前一周股价跌约 18.5%、董事会已就国家安全关切启动独立调查【B/C，公司文件未载原因】。

机制：开放权重把「模型能力」的边际价格压向零，任何本体厂都能拿到 46% 级的开放模型与 1 万小时级公共数据；此时差异化转移到训练管线、评测协议、部署运维与**默认入口**。算力厂商买入口，是因为入口决定训练与推理落在谁的芯片上；它们用「保持开放、支持其他硅」的书面承诺换取监管批准与社区不迁移。承诺的可靠性取决于治理结构，而本周恰好证明：治理层的突变，是这套结构里唯一无法用许可证对冲的风险。

## TOP 5（按实质产业变化与证据强度排序）

| # | 变化 | 为什么重要 | 证据与局限 | 证据级 |
|---|---|---|---|---|
| 1 | 11-11 NVIDIA 董事会接受黄仁勋辞去总裁、CEO 与董事职务（立即生效），任命 CFO Colette Kress 为临时 CEO（兼 CFO），Harvey Jones 出任公司史上首任董事长，启动内外部正式 CEO 搜寻；8-K 于 11-12 提交，新闻稿称产品路线图与客户承诺不变，Q3 FY2027 财报仍按原计划 11-17 发布。The Robot Report 同日报道：前一周股价跌约 18.5%，黄 11-08 声明承认婚外情并称董事会已就「国家安全关切」启动独立调查；报道称 Hugging Face 交易将受更严审查，AMD/Qualcomm/Arm/Intel 可能抢位 | 具身智能的训练、仿真、模型与边缘算力高度集中于 NVIDIA；平台方的治理事件会经「算力供给—软件版本—开源治理—CVC」四条管道传导到本体厂，且没有金融对冲工具。首次把「关键人风险」计入物理 AI 的估值 | 8-K Item 5.02 与 Ex-99.1【A】；股价、调查与指控细节仅 TRR 单篇【B/C】，公司文件不载原因；未触发 Item 8.01 | A（公司文件）/B-C（媒体归因） |
| 2 | 11-12 GXO 与 Apptronik 签署 LOI：扩大 Apollo 在真实仓库的联合试验（goods-to-person / person-to-goods 拣选、箱与周转箱搬运、打包、分拣）；2027 年起按双方约定的生产力/安全/运营 KPI 逐项验证并排序；在达标前提下，计划未来 4 年全球推广最多 1,000 台，2027 年底先从北美开始，商业框架预计为 RaaS。合作始于 2024 年 PoC，此前完成美国小件消费品自主拣选试点，并在 Apptronik Robot Park 对 50+ 物流任务做数据采集与在线评估 | 全球最大纯合同物流商给出了人形采购的模板合同：先定 KPI、再按用例排序、最后转服务合同；资产与停机风险留在本体厂。对同行 3PL 是可参照的结构，对本体厂意味着「先垫资、后按服务收费」 | GXO 官方新闻稿全文【A】；LOI 非订单，「最多 1,000 台」是意向上限，2027 年底才首落；未披露单价与 KPI 阈值 | A |
| 3 | 11-12 Agile Robots（思灵）宣布 5 亿美元 F 轮，投后估值 85 亿美元，累计融资 20 亿美元；软银集团领投，NVIDIA、日立（含 Hitachi Ventures）、T.Capital 参投；资金用于美国扩张与德国产能。2026 年初启用的慕尼黑附近 Fürstenfeldbruck 基地设计年产最多 1 万台足式+轮式人形；公司累计部署 2 万台工业机器人、3,500 名员工、650+ 专利，子公司含 Franka Robotics 与收购自蒂森克虏伯的 Krause Automation | 本周唯一带估值条款的人形融资，且投资方同时含「资本（软银）、算力（NVIDIA）、制造与渠道（日立）、欧洲运营商（T.Capital）」四类股东；给出一级市场「工业基本盘 + 人形期权」的定价锚 85 亿美元，与 Agility 约 27.8 亿美元市值形成对照 | 公司新闻稿【A（原文经 D 组读取）】；TRR 11-16【B】；年产能为设计值，未披露实际产量/订单簿；NVIDIA 参投与其 CEO 空缺同周，构成「治理震荡但继续用股权锁生态」的镜像 | A |
| 4 | 11-13 Agility 提交 10-Q（季末 2026-09-30）与 8-K/A：前 9 个月净销售 36.1 万美元（上年同期 173.9 万，−79%），销货成本 578.3 万美元、毛利 −542.2 万美元，SG&A 1.947 亿美元（+468%）、研发 2.447 亿美元（+292%），经营亏损 4.449 亿美元、净亏损 4.587 亿美元；交割净募资 3.341 亿美元（信托 1.641 亿 + PIPE 2.010 亿 + 7 月 SAFE 1.0 亿，合计毛募资 4.651 亿）；总股本 242,089,880 股。MD&A 明确 deployment 模式：公司保留机器人所有权、按服务期匀速确认收入、机器人预计 5 年可用寿命 | RaaS/deployment 的会计真相第一次摊开：资本开支留在表内、收入要等机器人可运行后才按服务期确认，所以「订单簿」与「收入表」会长期背离；按 9 个月经营亏损速度，3.341 亿美元净募资约覆盖 7 个月经营亏损（本刊估算，未计资本开支），扩张速度受现金而非订单约束 | 10-Q、8-K/A、Ex-99.4 MD&A【A】；关联方收入占比过半（9 个月 18.2 万美元）；未取得窗内 AGLT 行情，市值仍用 11-05 收盘口径 | A |
| 5 | 11-11 Runway 发布 Praxis-1 世界动作模型并以 Apache 2.0 开放权重（含推理与微调代码，支持全参与 LoRA、允许商用）；27B 参数 MoE 扩散 Transformer，同时预测视频与动作，训练全程保留视频预测目标；RoboLab-120（1,200 episodes）成功率 46.2%，对比 FLUX 3 Action 42.9%、Cosmos3 Nano 36.8%、π0.5 28.0%，总榜第 5；微调 RT-1 后 SimplerEnv 80.0%（原 RT-1 52.4%）；分发含 GitHub、Hugging Face（原生 LeRobot 支持）、vLLM-Omni，可跑 H100/B200、RTX 5090/RTX PRO 6000、Jetson Thor | 「世界动作模型」第一次以开放权重 + 可复现榜单成绩进入选型池：闭源 API 的替代出现，采购比较维度从「模型能力」转向「推理成本 + 适配工时」；同时把价值进一步推向数据、后训练与部署 | TRR 11-12 全文【B，含公司口径】；权重/仓库存在【A】；46.2%/80.0% 均为厂商自述与同一榜单，无第三方复现 | B/A |

> 其余增量（未入 TOP5）：Serve Robotics 11-11 上线 AV Delivery Developer Portal，把运力做成「Quote（美分+ETA）→ Create → Track」三调用的公共 API，报价 5 分钟单次有效、共享机队、非自助邀约制【A，开发者文档】；小鹏 11-16 Q3 电话会称 2027Q1 首批量产 IRON 进自有门店试用、2027Q2 面向外部商业客户发布【B】；优必选 11-11 与永达汽车签约，永达采购 400 台 U1 Pro、年内交付，按 16.98 万元/台计超 6,700 万元，而公司此前称全渠道订单 13,361 台、8 月底将年内交付下调至 1,500–2,000 台【C】；智元 6 台 G2 在上海在营便利店 24 小时完成 1,730 项任务、4/6 通过最终考核（事件 11-02/03，TRR 11-13 披露）【B/C】；智平方 7 台人形进驻 APEC 新闻中心服务 5,000+ 记者，入场前约 2,000 名志愿者做压力与红队测试（11-16）【C】；优必选×沐曦合资「曦选创智」5 亿元天使轮（11-11）【C】；三星 SDI 为 Atlas 初期主供（70 节 2170、约 1.3kWh、约 4h），LG 新能源二供但产能受限（披露 11-10，事件 11-09）【C】；帕西尼足底触觉 PX-FOOTRIX 与清华 TactileStep 实证（落地冲击 −48.8%、下楼噪声 −30.1dB）【B/C】；京东京造 48V30Ah 标准化换电包（11-15 亮相）【C】；Newton v1.8.0（11-11）【A】；HubEgo-100K（11-12）【A】；大晓 ACE-CaP-0 真机 240 次成功 221 次、92.1%（11-13）【B/C】；Ambi 旺季前 8 站点安装新版 AmbiSort（11-10）【C】；Gemini Robotics 2.5 + Apollo 2 在奔驰两厂线边拣配成功率 96%（中文源 11-10/11，Google 一手未取得）【C】。

## 发现层摘要

- 固定名单扫面：A 组 39 个对象行、B 组 30 个、C 组 22 个、D 组 14 个（含 OpenClaw 行）；四组均写出 `discovery.md`。
- 一手/原文入口约 90 个（A 28、B 25、C 10、D 18，含重叠）：SEC 8-K/10-Q/8-K-A/13D/Form 144、NVIDIA 8-K 与 Ex-99.1、Agile Robots 新闻稿、GXO 新闻稿、Serve 开发者文档、Newton/Isaac/LeRobot/ROS 2/Zenoh releases、Hugging Face 模型与数据集 API、arXiv 摘要、Gov.cn 检索、NDRC/上海/北京列表、TRR 6 篇、IT之家 8 篇、中国机器人网 10 篇。
- 名单外线索共 67 条，纳入本期深写 17 条（A 2、B 8、C 2、D 5）：Agile Robots F 轮、京东京造电池（A）；Praxis-1、HubEgo-100K、ACE-CaP-0、Alloy、Genie Sim Benchmark、SALA/TouchTwin/XInfer/Agentic-Teacher（B）；智平方 APEC、小鹏 IRON（C）；Serve Form 144、Axon×Skydio（D，窗外背景）。
- 不纳入并记录理由：OpenClaw（非具身，agent 产品/插件生态）；Axon×Skydio 12 亿美元（事件 11-02~06，窗外）；Liber-0、lingbot-touch、MotionBricks、SenseNova-RoboRSI（窗外或窗内无更新）；EgoX、Robo-SWE（仅题录，机制未读）；京东 Ceconomy 收购、李彦宏行业判断（非机器人交付/无事件锚点）；特斯拉 Cybercab 扩产（自动驾驶整车，非具身本体）。

## 八环节本周增量

### ① 核心零部件与制造

**结论：约束从「关节」移到「能量包」与「足底触觉」，标准侧本周无法评估。**

- **电池成为整车级供应链**：三星 SDI 被报为 Atlas 初期主供，70 节 2170（单节 5,000mAh）成包约 1.3kWh，LG 新能源二供但产能受限；Atlas 计划 2028 年或之后量产，现代把 Atlas 相关业务交现代摩比斯承接 pack/系统集成。【C，披露 11-10/11-13】按 3.6V 标称反推，70×5Ah×3.6V≈1.26kWh，与 1.3kWh 吻合；1.3kWh 支撑约 4h 对应平均功耗约 325W（本刊估算，非厂商数据）。
- **标准化换电包出现**：京东京造「锂电 3 号」48V30Ah（≈1.54kWh）、双包并联热插拔、10 秒换电不断电、统一尺寸/接口/通信协议、每包数字身份证，与欣旺达合作；11-15 在 APEC 现场亮相。【C】它把电池从定制件推向标准件，但 48V/1.54kWh 只覆盖中小型/陪伴类，高功率人形仍需高压平台。
- **触觉从手扩到足底**：帕西尼 PX-FOOTRIX（6D 阵列、200Hz、IP67/68、出厂预标定，2026-08 发布）配 Feelix World 仿真；清华 TactileStep 在 Unitree G1 足部部署压力鞋垫，真机上平台落地冲击最高降 48.8%、下楼梯峰值噪声最高降 30.1dB，消融实验切断实时触觉后收益回落。【B/C，披露 11-13】机制是把足底压力作为闭环观测进 RL 分阶段奖励，弥补视觉只能预判落点、无法感知接触瞬间受力。
- **减速器/丝杠/电机**：绿的谐波、来福谐波、双环传动、中大力德、三花智控、拓普集团、鸣志电器、贝斯特、兆威机电、灵心巧手、因时、傲意、强脑、坤维、汉威本周均无窗内公开动态，行业媒体零条（核验入口：各公司官网新闻中心 + 中国机器人网 11/10–16 列表）。**标准四条（GB/T 12601-2026、GB/T 14118-2026、工信部标识码征求意见稿、ISO 21423:2026）三入口均未取得**（openstd SSL/500、MIIT JS 空壳、Bing 无效），本周不能评估「国标宣贯与二供」。

### ② 本体与控制

**结论：本周是「渠道周」，不是「产品周」；订单与交付的口径差第一次被公开摆在一起。**

- **优必选**：11-11 与永达汽车签战略合作，永达采购 400 台 U1 Pro、年内交付，按 16.98 万元/台计订单超 6,700 万元，首批用于体验/销售/客服，并计划在上海共建体验中心；永达有 203 个网点（豪华品牌占 59.1%）。【C，披露 11-13】对照公司口径：U1 系列发布时称全渠道订单 13,361 台，8 月底财报电话会把年内实际交付下调至 1,500–2,000 台（约 11%–15%），U1 Pro 从 9-16 延至 11-30 有货。【C】机制是渠道杠杆（汽车展厅→机器人体验点）+ 运营商集采（11-11 天翼终端三年 100 万台行业规模目标），瓶颈在产线爬坡而非算法。
- **小鹏 IRON**：11-16 Q3 电话会，何小鹏称 2027Q1 首批量产机器人进入小鹏部分门店试用、2027Q2 面向外部商业客户正式发布，科技日与广州车展将亮相新版本；护城河表述为「硬件本体 + 规模化商业/生产/销售 + 高质量多样性数据」。【B】门店既是零获客成本的验证场，也是首批交付客户与展示厅。
- **Agility**：窗内无新增公司披露，但 11-13 的 10-Q/8-K-A 补齐了单位经济（见 TOP4）。11-12 联合创始人 Jonathan Hurst 报 13D：12,652,759 股、5.2%。【A】
- **启元**：11-08 第 10,000 台个人机器人下线（10-25 为第 5,000 台，14 天新增 5,000 台≈357 台/天），同日武汉华中首店开业。【C，披露 11-10/11，事件在窗外，标「本周新披露的历史事项」】这是消费级「个人机器人」节拍，不能外推到双足人形。
- **静默与未取得**：Figure 官网 news 最新 2026-09-30、1X 最新 2026-07-09（A，官网列表）；宇树窗内无新品发布，H2-X 产品页在架（双电池热插拔、磁吸充电，未标发布日）【B】；Tesla Optimus（tesla.com/ir 403）、Apptronik（news 403/newsroom 404）、傅利叶（526）三入口均未取得，不补写。

### ③ 数据与采集

**结论：数据竞争从「采多少」转向「schema 能否零改造接入训练栈」。**

- **HubEgo-100K**：Hugging Face 首版 10,124 小时第一人称熟练劳动视频、12,227 名贡献者、RGB+IMU、LeRobot 与 MCAP 双格式、CC-BY-4.0、gated auto。【A，数据集元数据】一次采集可同时用于策略与世界模型/状态估计，公共许可直接抬高「人类视频预训练」基线，对靠独家 ego 数据讲故事的数据商形成价格压力。
- **Memories.ai**：以模块化相机 + 统一采集流程做标准化 ego 管线，Memories-H0 标手部位姿、EgoAction 做动作分段，再用 Cosmos 解读进入数据湖、后训练客户任务模型；定位数据基础设施伙伴，可排他/非排他授权。【B/C，11-11】机制价值在「消除设备/机位差异，使不同采集者素材可被同一套模型标注」。
- **Rhoda AI**：DVA 以视频帧历史 + action token + language token 预测未来约 0.5 秒视频，再由 action converter 转动作，形成 0.5 秒闭环；预训练用互联网级视频、后训练每任务 10–20 小时；公司称只用精选 ego 操作视频不如更宽泛数据。【B/C，11-13】代价是每 0.5 秒一次视频生成的推理成本。
- **未取得**：EgoDex/EgoHand、智元/银河通用/国地中心数采工厂窗内均无更新（HF datasets API + arXiv cs.RO 150 条 + 中文列表三入口）。

### ④ 仿真、训练与评测

**结论：仿真的分水岭是「确定性 + 可被 agent 调参」；评测正在变成采购依据。**

- **Newton v1.8.0**（11-11 tag、11-12 changelog）：新增实验性 `SolverSteel`，把 Featherstone 铰接体动力学与投影 Gauss-Seidel 接触/Coulomb 摩擦放在同一迭代，矩阵无关、CPU/CUDA 均可跑；`solve_mode` 支持 serial/colored，`drive_mode="rows"` 把关节驱动并入 PGS 行；`deterministic=RUN_TO_RUN` 固定约束行顺序，同构建下 bitwise 一致并支持 CUDA graph；新增 island sleeping、持久摩擦锚点、`surface_gripper` 示例。【A】机制：不组装 mass matrix、按行做算子作用，显存随接触数而非自由度平方增长，才能单卡跑数千并行 world；确定性让仿真能进训练与回归，而不只生成数据。注意 Isaac Lab 3.0.0 目标 Newton 1.6.1，采用新 solver 需自行对齐。【A】
- **VABAR / GaP / RoboSimStudio**（CoRL 2026，Berkeley + NVIDIA）：VABAR 六任务（工具分拣、挂装、齿轮啮合、注射器装盒、线缆插入、走线）建在 Isaac Lab-Arena 与 Newton 上；GaP 把任务拆成感知/抓取/无碰撞运动节点，计算图可转 ROS 2；RoboSimStudio 把 Newton 数百参数暴露给 coding agent，GPT-6 Astra 约 1 小时由视频生成相近仿真。【C】
- **Isaac Lab / Arena / Cosmos 版本口径**：Isaac Lab v3.0.0 为 2026-10-20（背景）；Isaac Lab-Arena 主分支 `version = 0.3.0`、无 0.4；Cosmos3 为 Nano 16B / Super 64B / Edge 4B，窗内仅 checkpoint 元数据更新。【A】这三条纠正了上期「Arena 0.4 只在博客」的悬置：仓库仍是 0.3.0。
- **未取得**：Physicl、ToyBlocks、DexBench 在 arXiv API 与 cs.RO 窗内列表均无命中，记「本次未取得」。

### ⑤ 模型与算法

**结论：视频预测进入控制环，「后训练」取代预训练成为差异化环节。**

- **Praxis-1**（见 TOP5）：机制是把世界模型放在策略内环——不直接回归 action，而是先预测下一段可观测视频，再由 action converter 映射为动作；视频预训练目标全程保留，因此跨本体只需少量对齐（半小时示例学会码木板 15/15；未见过的杂乱堆 10 次清空 6 次）。【B/C】
- **大晓 ACE-CaP-0**：8 项精细真机任务、240 次评测成功 221 次（92.1%），7 项 ≥90%、插充电器 100%；平均执行时间从小时级压到 1 分钟内。【B/C，11-13；对应 arXiv 2611.16872】机制是「按需示范 + 按需仿真」：agent 判断缺口类型（不会动→请人示范；不知边界→开仿真批量试），结果回灌为代码策略并在真机验证后固化为可复用 Skill；冻结为代码而非蒸馏进权重，对工业客户更可审计。
- **arXiv 窗内高信号**：SALA（latent action 语义对齐，解决人类/机器人动作对不齐）；ESI（把模块化 agent 整体作为后训练单元）；Agentic-Teacher（失败驱动数据引擎）；TouchTwin（量化「力缺口」：纯位姿模仿只使出记录力的 0.31 倍，物理回放 1.55 倍）；XInfer（VLA 车队 serving，有效机器人容量为 SOTA 的 1.26–3.75 倍）；XBot-Omni（Thinker-Talker-Actor）。【A，摘要】
- **版本面静默**：GR00T N1.7-3B 权重自 2026-02-25 公开，11-10 仅元数据更新；LeRobot v0.7.0 为 11-05；π 系列、GroundingPI、戴盟 Touch-R1、Gemini ER 2 定价均未取得。【A 负向】Apple HALO 与 arXiv 2611.16439 同名论文机构未确认，按 D 隔离，不写入结论。

### ⑥ 软件平台与工具链

**结论：工具链开始按「调用」计价，交付物从 demo 变成 installation day。**

- **Serve Robotics**：11-11 上线 AV Delivery Developer Portal + 公共 API + 沙箱。官方文档写明三调用：Quote（传取/送点，返回美分计价 + ETA，不锁资源不扣费）→ Create（用 quote_id 转真实 job）→ Track（轮询至 dropoff_complete）；报价 5 分钟过期且只能用一次（复用返回 409），`couriers_busy` 属正常态，重试须带 Idempotency-Key，限流 600 req/min；真实调度需服务区 + 生产 key + 共享机队访问权，签约非自助。【A】这把「机器人运力」抽象成云服务：接入方只买结果，调度/路径/远程监督留在 Serve 侧。
- **Viam Launchpad**：6 个月孵化，提供 usage credits、工程支持、纽约办公室与含机械臂集群的实验室，毕业标准是 installation day 而非 demo day；客户例 Gambit（灶台上方双机械臂炒菜）用其遥测/远程调试/机队管理。【C，作者自述为该 Launchpad 顾问，存在利益关系】
- **版本面**：LeRobot v0.7.0（11-05）、ROS 2（09-14）、Zenoh（10-28）窗内均无新版本；OpenClaw 经 GitHub 检索为通用 agent 产品/插件生态，无机器人能力，本期排除（覆盖表保留该行）。【A】

### ⑦ 系统集成、交付与运维

**结论：RaaS 分叉为「按次动态计价」与「KPI 门控项目制」，交付价值向集成/运维层转移。**

- **GXO × Apptronik**（见 TOP2）：LOI + KPI 门控 + 4 年最多 1,000 台 + 2027 年底北美首落 + RaaS 框架。机制是把「人形进 3PL」拆成可审计的阶段门：先定 KPI、再按用例排序、最后转服务合同；GXO 保留按站点扩展的弹性，资产风险留给 Apptronik。
- **Agile Robots 的纵向整合**：F 轮资金用于产能与美国扩张，子公司 Krause Automation（收购自蒂森克虏伯）提供系统集成与汽车产线交付能力——集成能力被并入本体厂商，交付环节纵向整合。【A】
- **Ambi**：旺季前在 8 个设施安装新版 AmbiSort，客户预计本季吞吐较去年旺季 +9~10%（行业典型季节增幅 25–40%）；提效手段含加班次、加人、旺季前加密培训。【C】交付被定义为安装 + 培训 + 旺季驻场，培训被当作产能杠杆而非售后。
- **Narwal**：10 年研发、试过 30 条自清洁拖布技术路线、最初 3 年零收入；地毯深洁模块较传统机型 +40~50%；深圳 + 加州 Covina 双址，正筹备 IPO。【B/C，11-13】

### ⑧ 终端场景与需求

**结论：可复制场景的共同结构是「单工位/单任务、节拍可测、SKU 有界、失败可回滚」；跨任务门店运营仍是试点。**

- **物流/仓储**：GXO LOI（A）；Serve 2,000+ 台、20 城 150+ 社区、4,000+ 餐厅（B/C）；Ambi 8 站点（C）。这是本周证据最厚的场景。
- **汽车工厂**：Gemini Robotics 2.5 + Apptronik Apollo 2 在奔驰匈牙利凯奇凯梅特与德国辛德尔芬根在用产线做线边金属支架拣配/排序，成功率 96%，较基线 +30~100%、速度 +20~30%；机制是 ER 跟踪多步流程 + 2.5 控臂/手的动作模型分工。【C，中文源转述，Google 一手未取得】这仍是 PoC，不等于产线编制替换。
- **零售/便利店**：智元 6 台 G2 在上海在营便利店 24 小时 1,730 项任务（顾客互动 683、取送 369、咖啡 147、早餐 126、巡检补货 277、清洁 128），4/6 通过；Genie Master + EEP 把任务规划/执行/反馈串起来，失败经验写回长期记忆并转训练数据。【B/C，事件 11-02/03、披露 11-13】67% 通过率说明离无人值守仍有距离。
- **会展/媒体**：智平方 7 台人形在 APEC 新闻中心服务 5,000+ 记者，直接用人类咖啡机/冰淇淋机/果汁机；入场前约 2,000 名志愿者分波次做安全与压力/红队测试；已有近半 APEC 经济体商业沟通。【C，11-16】
- **家庭**：启元 1 万台是下线量、门店渠道扩张；优必选 U1 Pro 是固定站位陪伴机（不支持自主行走、无家务），400 台订单来自汽车经销商渠道——家庭场景仍以「陪伴终端 + 渠道」为主，不是通用家务。
- **排序（按本周证据强度）**：物流/仓储 > 汽车线边 > 零售便利店 > 会展服务 > 家庭陪伴。排序依据是「是否有可核的连续运行小时数 + 失败率 + 合同结构」，不是演示效果。

## 跨链综合：本周重划了三条线

### 1. 开放线：权重与数据的边际价格继续下降

Praxis-1 以 Apache 2.0 开放 27B 权重并给出可比榜单（46.2% vs π0.5 28.0%），HubEgo-100K 以 CC-BY-4.0 放出 10,124 小时，Newton v1.8.0 把接触求解做成可复现开源路径。三者共同压低「模型能力」的价格，把差异化推到数据 schema、后训练与部署。对采购方，这意味着**模型选型可以要求「可自托管 + 可 LoRA + 可复现评测」**，而不是接受黑盒 API。

### 2. 集中线：入口被算力厂商收编，且最大买家在换帅

Hugging Face（约 129 亿美元、2027H1 交割、含监管批准与开放承诺）、MoveIt（Qualcomm，承诺开源）、RAI（SoftBank，报道口径）——被买的不是技术，是默认路径。NVIDIA 11-11 的 CEO 变更把「入口方的治理」变成变量：8-K 只写辞职、不写原因，新闻稿称路线图不变、Q3 财报照常，但正式 CEO 搜寻期的不确定性会经算力供给、软件版本、开源治理、CVC 四条管道传导。

### 3. 合同线：RaaS 从概念变成可审计条款

GXO 的 LOI 给出「KPI 门控 + 4 年上限 + RaaS」；Serve 的 API 给出「按次动态报价」；Agility 的 10-Q 给出「保留所有权 + 5 年寿命 + 服务期确认收入」。三种写法共同说明：**收入确认的起点是「机器人可运行」，不是「签约」**。这会让 2027 年的收入表普遍比订单簿难看，也是本周 Agility 报表最重要的行业含义。

## 必出对比表

| 环节 | 主体/产品 | 变化 | 商业/产能含义 | 证据级 |
|---|---|---|---|---|
| ① 零部件 | 三星 SDI / LG 新能源 × Atlas | 三星初期主供 70 节 2170、约 1.3kWh；LG 二供但产能受限（披露 11-10） | 人形电池按整车级项目锁定；pack/热管理流向摩比斯等 Tier1 | C |
| ① 零部件 | 京东京造「锂电 3 号」 | 48V30Ah、双包热插拔、10 秒换电、统一接口/协议（11-15 亮相） | 电池从定制件变标准件；中小型机器人可复用，高功率人形仍需高压平台 | C |
| ① 零部件 | 帕西尼 PX-FOOTRIX + 清华 TactileStep | 足底 6D 阵列 200Hz；落地冲击 −48.8%、下楼噪声 −30.1dB（11-13） | 触觉从手扩到足，BOM 新增「每脚一片」；单卖器件难，需 sim-real 配套 | B/C |
| ② 本体 | 优必选 × 永达 | 400 台 U1 Pro、年内交付、超 6,700 万元（11-11） | 汽车经销商渠道卖陪伴机器人；对照 13,361 台订单 vs 1,500–2,000 台年交付 | C |
| ② 本体 | 小鹏 IRON | 2027Q1 门店试用、2027Q2 对外商业发布（11-16） | 门店=数据场+首批客户+展厅；给供应链一个可被招标引用的时点 | B |
| ② 本体 | Agility AGLT | 9 个月收入 36.1 万美元、净亏 4.587 亿美元、净募资 3.341 亿美元；deployment 5 年寿命（11-13） | RaaS 资本开支留在表内、收入按服务期确认；现金约覆盖 7 个月经营亏损（估算） | A |
| ② 本体 | Agile Robots（思灵） | 5 亿美元 F 轮、投后 85 亿美元；软银领投，NVIDIA/日立/T.Capital 参投（11-12） | 工业基本盘 + 人形期权的一级定价锚；德国 1 万台/年设计产能 | A |
| ③ 数据 | HubEgo-100K | 首版 10,124 小时 ego 视频、12,227 贡献者、CC-BY-4.0、LeRobot+MCAP（11-12） | 公共数据抬高预训练基线；数据商议价转向 schema 与授权 | A |
| ③ 数据 | Memories.ai / Rhoda AI | 标准化采集+标注管线；DVA 0.5 秒视频-动作闭环（11-11/13） | 数采从「建工厂」转向「统一规范」；视频预训练替代部分遥操作数据 | B/C |
| ④ 仿真评测 | Newton v1.8.0 | SolverSteel、矩阵无关 PGS 接触、bitwise 确定性、CUDA graph（11-11） | 仿真可进训练与回归；与 Isaac Lab 3.0（target 1.6.1）存在版本对齐成本 | A |
| ④ 仿真评测 | VABAR / GaP / RoboSimStudio | 六任务工业接触基准；agent 写仿真图并可转 ROS 2（CoRL 2026） | 评测从「榜单」变成可复现采购依据 | C |
| ⑤ 模型 | Runway Praxis-1 | 27B MoE、Apache 2.0、RoboLab-120 46.2%（vs π0.5 28.0%）（11-11） | 世界动作模型可自托管/可 LoRA；闭源 API 出现替代，价格锚下移 | B/A |
| ⑤ 模型 | 大晓 ACE-CaP-0 | 8 任务 240 次真机 92.1%，执行时间压到 1 分钟内（11-13） | 技能冻结为代码、可审计；价值从权重转向技能库与调度器 | B/C |
| ⑥ 工具链 | Serve AV Delivery API | Quote/Create/Track 三调用、美分计价、5 分钟单次有效、共享机队（11-11） | 运力按次计价；集成商可嵌入而不持有资产 | A |
| ⑥ 工具链 | Viam Launchpad | 6 个月孵化、纽约实验室、以 installation day 为终点（11-12） | 交付瓶颈从「造」转向「上线与运维」，平台层获议价权 | C |
| ⑦ 交付运维 | GXO × Apptronik | LOI、KPI 门控、2027 验证、4 年最多 1,000 台、RaaS（11-12） | 人形采购模板：先 KPI 后服务合同；LOI 非订单 | A |
| ⑦ 交付运维 | Ambi / Narwal | 8 站点旺季前安装+培训；Narwal 30 条技术路线、筹备 IPO（11-10/13） | 成熟品类按季扩容；交付=安装+培训+驻场 | C |
| ⑧ 终端场景 | 智元 G2 × 便利店 | 6 台 24h、1,730 任务、4/6 通过（披露 11-13） | 单任务可复制、跨任务仍是试点；验收应写通过率与未达标项 | B/C |
| ⑧ 终端场景 | Gemini Robotics 2.5 × 奔驰 | 在用车线边拣配 96%、速度 +20~30%（中文源 11-10/11） | 线边物料是 ROI 最清晰的工位；仍是 PoC | C |
| ⑧ 终端场景 | 智平方 × APEC | 7 台、5,000+ 记者、入场前 2,000 人压力/红队测试（11-16） | 「认证式交付」可写进采购模板；复购与经济性未披露 | C |

## 竞争与价值分配

**利润正在向「算力 + 入口」与「渠道 + 场景」两端移动，本体在中段被挤压。**

- **算力/入口端拿两层**：NVIDIA 既卖 GPU/Isaac，又以 CVC 身份参投 Agile Robots（本周 5 亿美元 F 轮），同时待收购 Hugging Face（模型社区 + LeRobot）。Qualcomm 以 PickNik/MoveIt 绑定 Dragonwing。平台方的收入不依赖某一家本体成败。
- **渠道/场景端收租**：Serve 把 2,000 台车队做成 API（按次计价）；小鹏用自有门店做首批场景；优必选用永达 203 个网点与电信渠道卖陪伴终端。谁拥有场景与账单，谁拿走服务层的定价权。
- **本体中段**：Agility 9 个月收入 36.1 万美元、净亏 4.587 亿美元，deployment 模式把资本开支留在表内；Agile Robots 用 2 万台工业装机与集成能力撑起 85 亿美元估值。**有现金流与集成能力的本体，估值逻辑接近工业公司；纯人形标的仍靠稀缺性定价。**
- **零部件**：电池与触觉出现「整包/阵列」级的新 BOM 项，标准侧本周空窗，竞争仍由客户定点而非国标决定。

## 风险与反证

1. **NVIDIA 事件的原因只有媒体归因**：8-K 与新闻稿均不载原因，未触发 Item 8.01；「婚外情/涉华间谍/独立调查」中，只有「独立调查」有黄 11-08 声明引语，其余为 TRR 叙述。不能写成公司确认，也不能据此推断业务中断。
2. **「最多 1,000 台」是 LOI 上限**：GXO 明确 2027 年起才验证 KPI、2027 年底才北美首落；把它写成订单或收入会高估 2027 年。
3. **Agility 现金覆盖期为本刊估算**：3.341 亿美元净募资 ÷（4.449 亿美元经营亏损/9 个月）≈7 个月，未计资本开支与营运资金变化；公司未给 runway 指引。
4. **优必选订单与交付口径来自媒体**：13,361 台订单、1,500–2,000 台年交付、400 台永达订单均未见港交所公告原文；「订单≠收入」成立，但具体数字应打问号。
5. **Praxis-1 与 ACE-CaP-0 的成绩均为厂商口径**：46.2%、92.1% 无第三方复现；Praxis-1 的权重存在可核（A），成绩不可核（B/C）。
6. **Gemini Robotics 2.5 × 奔驰 96% 仅中文源**：Google 一手 blog 未取得，按 C 限述。
7. **中国政策本周空窗**：gov.cn 政策库「机器人」无 2026 年条目、NDRC 三场发布会无机器人议题、上海/北京无专项；工信部标识码征求意见稿仍未取得原文——「未取得」不等于「没发生」。

## 对你意味着什么

**产业链从业者/战略负责人。**
- 如果做本体：把「连续性条款」写进平台采购——版本锁定、离线推理、权重与数据可导出、6 个月内可切换的备份栈；同时把验收从「任务总数」改成「连续运行小时数 + 通过率 + 未达标项 + 接管次数」。
- 如果做部件：本周的增量在能量包与足底触觉，不在减速器价格；争取进入「整包/阵列」级 BOM，而不是单件送样。标准侧本期无新依据，投标仍以客户定点为准。
- 如果做集成/交付：RaaS 已分叉——标准化、低货值、短距选「按次 API」；高货值、多工位、需安全认证选「KPI 门控 + 服务合同」。先问按次还是按 KPI，再谈单价。
- 如果做模型/数据：开放权重把模型价格压低，护城河在数据 schema、失败日志与后训练；合同里明确场景数据与失败日志归属。

**投资人。**
- 用「可计费产出 × 单位价格」而不是「规划产能」做估值起点；对只有下线台数、没有在线时长与通过率的标的给产能折扣。
- 两个估值锚同时存在：Agile Robots 85 亿美元（有 2 万台工业装机与集成收入）vs Agility 约 27.8 亿美元（9 个月收入 36.1 万美元）。问清楚标的「凭什么享受另一个的倍数」。
- 关注现金覆盖期：Agility 3.341 亿美元净募资对 9 个月 4.449 亿美元经营亏损，约 7 个月（估算），2027 年前仍有融资需求。
- 平台层：NVIDIA 的治理事件不改变短期份额，但改变风险溢价；HF 交割的监管节点（至 2027H1）是下一个可交易的时间点。

**政策/标准关注者。**
- 本周无国家级机器人新政；跟踪三条线：工信部机器人产品标识码（原文仍未取得）、谐波两项国标（2027-04-01 实施）、ISO 21423:2026 互操作。标准决定招标文件怎么写，也决定差异化能否留在交付层。

## 八环节 × 六横向矩阵

| 环节 | 产品 | 技术 | 商业 | 投融资 | 政策 | 竞争与价值分配 |
|---|---|---|---|---|---|---|
| ① 零部件 | 2 | 2 | 2 | 0 | 0 | 2 |
| ② 本体 | 1 | 2 | 3 | 3 | 0 | 3 |
| ③ 数据 | 2 | 2 | 1 | 0 | 0 | 1 |
| ④ 仿真评测 | 2 | 3 | 1 | 0 | 0 | 2 |
| ⑤ 模型 | 3 | 3 | 2 | 0 | 0 | 3 |
| ⑥ 工具链 | 2 | 2 | 2 | 0 | 0 | 2 |
| ⑦ 交付运维 | 1 | 2 | 3 | 1 | 0 | 2 |
| ⑧ 终端场景 | 1 | 2 | 3 | 0 | 0 | 2 |

> 计数口径：本期母稿中可核条目数，同一条目可跨列，0–3 封顶；用于看材料厚度，不作精确统计。材料最厚的是本体、模型、交付与场景；政策列全周为 0，是本期的结构性空窗。

## 周环比（摘要；全表见 wow.md）

| 主线 | 上周（第 11 期，11-03~09） | 本周（第 12 期，11-10~16） | 走向 |
|---|---|---|---|
| 计价单位 | Agility RaaS 价目表、Tesla 只租不售、电信集采目标 | GXO LOI + KPI 门控；Serve 按次 API；小鹏门店自营 | 延续并分叉：三种合同写法 |
| 公开市场 | AGLT 首日 11.49 美元、市值约 27.8 亿美元 | Agility 10-Q：9 个月收入 36.1 万、净亏 4.587 亿、净募资 3.341 亿 | 从「上市定价」进入「财报检验」 |
| 产能叙事 | 启元 1 万台、Agility 1 万台/年、Atlas 备料 | Agile Robots 5 亿美元 F、85 亿美元估值、德国 1 万台/年 | 产能被一级资本定价 |
| 数据供给 | 10 万小时 ego、合成数据、HALO | HubEgo-100K 10,124 小时 CC-BY-4.0；Memories.ai/Rhoda | 从「规模」转向「schema 与许可」 |
| 仿真评测 | Cosmos 3、Isaac 3.0、Arena/DexBench | Newton 1.8.0、VABAR、Praxis-1 开放权重 | 确定性与可复现成为卖点 |
| 模型 | GR00T 2、GroundingPI、HALO | Praxis-1 Apache 2.0、ACE-CaP-0 92.1% | 开放权重把价格锚下移 |
| 平台与入口 | NVIDIA 发布训练栈；HF/LeRobot v0.7.0 | NVIDIA 换帅；HF 交易审查；MoveIt 维护方被 Qualcomm 收购（待交割） | 治理与所有权成为变量 |
| 零部件 | 灵巧手 2.5 万台、谐波国标、Atlas 电芯 | Atlas 电池主供披露、帕西尼足底、京造换电包 | 从关节转向能量包与触觉 |
| 本体形态 | Agility 上市、Atlas 装轮、云深处 X50 | 小鹏 IRON 时间表、优必选渠道订单、Figure/1X 静默 | 渠道与交付分化 |
| 中国场景 | 小米 8h/76s/98%、智元便利店、启元万台 | 智元 4/6、智平方 APEC、GXO 3PL | 从单点验收转向合同结构 |

**收束**：上周建立了「三张表」（市值、租金、工时）；本周三张表开始互相校验——公开市场给出 Agility 的亏损与现金，一级市场给 Agile 85 亿美元，合同侧给出 GXO 的 KPI 与 Serve 的按次计价。降温的是软银×ABB（窗内无新披露）、上海方案细则（无）、四条标准（未取得）、Figure/1X（静默）；升温的是「入口所有权」与「RaaS 合同结构」。

## 覆盖与局限

**覆盖**：四组固定名单共 105 个对象行（A 39、B 30、C 22、D 14），有料 34 个、无动态 44 个、未取得 27 个（均列 ≥2 入口）。名单外线索 67 条、纳入深写 17 条。

| 组 | 对象行 | 有料 | 无动态 | 未取得 | 名单外线索/深写 | 重派 | 分片 |
|---|---|---|---|---|---|---|---|
| A ①② | 39 | 9 | 22 | 8 | 18 / 2 | 0 | part-01、part-02、discovery |
| B ③–⑥ | 30 | 10 | 11 | 9 | 18 / 8 | 0 | part-01、discovery |
| C ⑦⑧ | 22 | 10 | 7 | 5 | 14 / 2 | 0 | part-01、discovery |
| D 跨链 | 14 | 5 | 4 | 5 | 17 / 5 | 0 | part-01、discovery |

**主要未取得（已试入口）**：
- 工信部《机器人产品标识码》征求意见稿原文（MIIT 检索 JS 空壳、MIIT 政策栏、gov.cn 政策库）；GB/T 12601-2026、GB/T 14118-2026（openstd SSL/500、MIIT、Bing）；ISO 21423:2026（无 iso.org 入口）。
- Tesla Optimus（tesla.com 403、ir.tesla.com 403、TRR 站内搜索）；Apptronik（/news 403、/newsroom 404、/press 404）；傅利叶（news 526、行业媒体 0 条）。
- 港股机器人 IPO（HKEXnews titleSearch 返回 0，stockId 参数未解）；AGLT 窗内行情（stooq/Yahoo 接口失败）；网信办数据出境、EU AI Act/机械法规。
- Physicl、ToyBlocks、DexBench（arXiv API + cs.RO 窗内列表）；π 系列（官网 429、HF 无新模型）；GroundingPI、Touch-R1、Gemini ER 2 定价。
- 京东（jd.com/news 500、ir.jd.com 403）、顺丰（news 404）、富士康（press-center 404）、UniX（域名待售/SSL 失败）、启元（官网空响应）。
- Serve Q3 财报（investors 403）；NVIDIA 辞职原因一手文件（8-K 不载）。

**方法局限**：WebSearch 工具 403，发现层依赖站点索引页、WP REST（TRR）、RSS（IT之家）、HF/arXiv API 与 SEC submissions；搜索引擎（Bing/Google）结果不可用，未做全市场新闻穷举。SEC daily-index 对脚本 UA 403，未做全市场 8-K 全扫，仅按已知 CIK 核验。

## 来源

- NVIDIA 治理：8-K（[事件 11-11](https://www.sec.gov/Archives/edgar/data/1045810/000104581026000082/nvda-20261111.htm)）、[Ex-99.1](https://www.sec.gov/Archives/edgar/data/1045810/000104581026000082/nvidiaannouncesceotransiti.htm)；[TRR 11-12](https://www.therobotreport.com/nvidia-replaces-ceo-amid-china-ai-and-robotics-concerns/)
- Hugging Face 交易：[NVIDIA 8-K 2026-09-02](https://www.sec.gov/Archives/edgar/data/1045810/000104581026000078/nvda-20260902.htm)；[Qualcomm×PickNik（TRR 09-23）](https://www.therobotreport.com/qualcomm-acquires-picknik-robotics-keep-moveit-open-source/)；[Hugging Face](https://huggingface.co/)；[LeRobot releases](https://github.com/huggingface/lerobot/releases)
- Agile Robots：[公司新闻稿](https://www.agile-robots.com/en/news/detail/physical-ai-leader-agile-robots-raises-500-million-series-f-funding/)；[TRR 11-16](https://www.therobotreport.com/agile-robots-raises-500m-to-increase-production-capacity/)；[中国机器人网 11-12](https://www.robot-china.com/news/202611/12/97417.html)
- Agility：[10-Q](https://www.sec.gov/Archives/edgar/data/2074973/000121390026119801/ea0311936-10q_agility.htm)、[8-K/A](https://www.sec.gov/Archives/edgar/data/2074973/000121390026119809/ea0311959-8ka1_agility.htm)、[Ex-99.4 MD&A](https://www.sec.gov/Archives/edgar/data/2074973/000121390026119809/ea031195901ex99-4.htm)、[13D](https://www.sec.gov/Archives/edgar/data/2074973/000121390026118976/xslSCHEDULE_13D_X02/primary_doc.xml)
- GXO：[新闻稿 11-12](https://gxo.com/news_article/gxo-apptronik-expand-humanoid-robotics-partnership/)
- Serve：[开发者文档](https://developer.serverobotics.com/docs/getting-started.md)；[TRR 11-11](https://www.therobotreport.com/serve-robotics-opens-robot-delivery-network-for-others-to-build-on/)
- 模型与仿真：[Praxis-1（TRR 11-12）](https://www.therobotreport.com/runways-praxis-1-world-action-model-for-robotics-is-now-available/)；[Newton v1.8.0](https://github.com/newton-physics/newton/releases/tag/v1.8.0)；[HubEgo-100K](https://huggingface.co/datasets/HubLabs/HubEgo-100K)；[ACE-CaP-0（中国机器人网 11-13）](https://www.robot-china.com/news/202611/13/97429.html)；[VABAR/GaP（TRR 11-11）](https://www.therobotreport.com/can-ai-agents-program-industrial-robots-without-training-data-berkeley-says-yes/)
- 数据与工具：[Memories.ai（TRR 11-11）](https://www.therobotreport.com/memories-ai-builds-standardized-egocentric-video-pipeline/)；[Rhoda AI（TRR 11-13）](https://www.therobotreport.com/how-rhoda-ai-is-using-video-data-to-create-generalized-ai-models-for-robots/)；[Viam（TRR 11-12）](https://www.therobotreport.com/viam-launchpad-aims-to-accelerate-robotics-deployments/)
- 本体与场景：[优必选×永达（中国机器人网 11-13）](https://www.robot-china.com/news/202611/13/97418.html)；[小鹏 IRON（IT之家 11-16）](https://www.ithome.com/1/027/964.htm)；[智元便利店（TRR 11-13）](https://www.therobotreport.com/six-agibot-g2-robots-complete-1730-tasks-in-24-hour-shanghai-convenience-store-trial/)；[智平方 APEC（IT之家 11-16）](https://www.ithome.com/1/027/735.htm)；[Gemini 2.5×奔驰（IT之家）](https://www.ithome.com/1/025/188.htm)
- 零部件：[三星 SDI×Atlas（中国机器人网 11-10）](https://www.robot-china.com/news/202611/10/97367.html)；[帕西尼（11-13）](https://www.robot-china.com/news/202611/13/97435.html)；[京造电池（11-16）](https://www.robot-china.com/news/202611/16/97448.html)

## 研究结论（一句话）

**当模型与数据变成公共品，产业链的定价权移到「谁维护默认入口、谁掌握场景账单」；本周这两端分别被算力厂商与渠道方加固，而本体中段第一次用财报证明：产能可以先建，收入必须等机器人跑起来。**
