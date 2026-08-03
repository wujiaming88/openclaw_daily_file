# 全球 AI 动态周报 · 第 10 期（2026-07-27 ~ 2026-08-02）

> **覆盖区间**：2026-07-27（周一）00:00 ~ 2026-08-02（周日）24:00（上海时区）  
> **覆盖范围**：43 个组内企业研究对象 · 全球巨头、中国头部、应用垂直、算力云硬件具身四大板块  
> **数据声明**：只收录本区间内真实公开动态；区间外内容仅作背景并明确标注。开源模型或技术仅作为企业战略动作分析，不作为独立项目研究。  
> **四维门控自检**：覆盖 43/43（100%），有动态/可分析 34 个，静默 9 个；原文抽查 5/5 通过；企业竞争判断与三条主线到位；关键数据均附来源或标注未公开。

## 本周一句话

> 本周全球 AI 企业竞争的重心进一步从“模型发布”转向“单位任务成本、算力金融化、企业工作流治理与可审计商业化”：OpenAI、Microsoft、AWS、Cohere 把 Agent 和模型服务推向可控可计费的企业系统，Meta、NVIDIA、Azure、Oracle 把 AI 基础设施推向 GW 级数据中心和资本结构设计，中国头部模型公司与具身智能企业则在开放权重、订阅、国产算力和 IPO 估值锚之间加速分化。

## 🔥 本周 TOP5 企业事件

### 1. OpenAI：GPT-5.6 把能力竞争压到价格/性能线
OpenAI 本周围绕 GPT-5.6 连续释放商业化和效率信号：Luna 降价 80%、Terra 降价 20%，Sol 引入 Fast mode；工程文披露 Sol 参与生产 kernel 优化，帮助端到端服务成本下降 20%、speculative decoding token 生成效率提升 15% 以上。公司还把这些动作上升到 “abundant intelligence” 战略，并披露模型触达超过 10 亿活跃用户和 200 万家企业。

**为什么重要**：OpenAI 正把竞争焦点从“旗舰模型能力”压到“同等质量下完成一个任务的总成本”。如果效率收益能持续传导到 API、Codex 与 ChatGPT Work，企业采购会更关注单位结果成本，而不是单点 benchmark。

### 2. Meta：与 BlackRock 合资建设 1GW AI 数据中心
Meta 与 BlackRock 宣布 El Paso 数据中心园区合资项目，目标建设 1GW compute capacity，预计 2028 年开始上线。项目总开发成本约 140 亿美元，Meta / BlackRock 管理资金分别持有 20% / 80%，并包含 125 亿美元债务融资、长期租赁与残值担保安排。同周 Meta 还推进 EU AI Act 透明度承诺与 AI 眼镜影响力资助。

**为什么重要**：Meta 展示了“前端个人 Agent + 后端基础设施金融工程”的组合能力。AI 数据中心不再只是自建 CapEx，而是股权、债务、长期租赁、残值担保和云化算力需求共同组成的产业金融结构。

### 3. AWS：AI 云与自研芯片进入年化 250 亿美元级
Amazon Q2 披露 AWS 销售额 422 亿美元、同比增长 37%，为 18 个季度最快增速，折合 1690 亿美元年化收入 run rate。更关键的是，AWS AI 业务和芯片业务均超过 250 亿美元年化 run rate，且均同比三位数增长；Trainium 获得 Anthropic、OpenAI 多年多 GW 承诺，Bedrock 客户和消费也快速放大。

**为什么重要**：AWS 本周用硬数字回应“AI 云是否落后”的质疑。Trainium 若能在头部实验室承诺后形成大规模替代算力池，AWS 将在供给弹性、毛利和多模型平台控制面上获得更强筹码。

### 4. 月之暗面/Kimi：K3 开放权重与巨额融资报道同时放大关注
月之暗面本周发布 Kimi K3 模型权重、技术报告与关键训练基础设施，媒体称其为 2.8 万亿参数 MoE、原生视觉理解、100 万 token 上下文窗口；同周《科创板日报》报道称 Kimi 完成 F 轮超 35 亿美元融资、投后估值 350 亿美元，且 G 轮/Pre-IPO 轮提前启动。公司未公开回应融资报道，因此报告中按“权威媒体报道、非公司官宣”处理。

**为什么重要**：Kimi 同时占据技术生态与资本市场注意力，说明中国头部模型公司正在用开放权重争夺全球开发者，用巨额融资争夺算力、人才和上市窗口。后续关键是 API、企业版和 Kimi Work/Code 能否消化高估值。

### 5. Unitree 宇树：科创板 IPO 给人形机器人建立公开估值锚
宇树本周启动上海科创板 IPO，计划募资 42 亿元人民币，隐含估值 420 亿元人民币，审批流程 104 天。据 Forbes 引用招股书信息，宇树 2025 年收入约 17 亿元，人形机器人收入占比约 52%，毛利率接近 60%，2025 年出货约 5,500 台人形机器人。

**为什么重要**：Unitree IPO 把人形机器人从 Demo 叙事拉到公开市场审计：收入、出货、毛利、净利、量产能力都会成为行业估值锚。Figure、Tesla Optimus、UBTech 以及欧洲 Humanoid 都会被拿来与这个公开标尺比较。

## 🧭 三条企业竞争主线

**一，模型竞争开始被“单位任务成本”重新定价。** OpenAI GPT-5.6 降价与推理效率优化、AWS Bedrock prompt caching、Microsoft Maia/MAI 成本指标、Cohere North 的模型路由、Runway 的 API 用量审计，都指向同一件事：企业不再只为模型能力买单，而是为“可预测成本下完成可审计工作流”买单。

**二，AI 基础设施进入资本结构与交付速度竞争。** Meta/BlackRock 1GW 合资、Azure 单季新增 1GW 容量、AWS AI 与芯片 run rate、Oracle Project Jupiter、CoreWeave AI 工厂验证、NVIDIA 投资 SSI 与 Vera Rubin 绑定，共同说明算力竞争已经从芯片采购扩展到数据中心融资、电力许可、机架交付、客户承诺和资本回收周期。

**三，企业 AI 商业化从“功能演示”转向“治理、渠道和组织信任”。** Microsoft Copilot 付费席位、Cohere Carahsoft 公共部门渠道、Scale 新 CEO、Harvey 文档处理规模、Glean 企业上下文与成本治理、Cursor 印度本地化定价，都说明头部 AI 应用公司正在补齐销售、合规、审计、数据管线和全球支付能力。

## 📡 企业竞争雷达

### 战略雷达
- **OpenAI / Microsoft / AWS**：围绕模型效率、企业控制面和生产级 Agent 工程化展开正面竞争。
- **Meta / Google / NVIDIA**：把 AI 从聊天与办公推向个人 Agent、机器人/物理 AI 与下一代 AI 工厂。
- **中国头部模型公司**：阿里、字节、腾讯、DeepSeek、智谱、Kimi、MiniMax 都在把模型能力转成办公、视频、Coding、API 和国产算力生态入口。

### 市场/商业化雷达
- **云厂商**：AWS、Azure、Google Cloud 的 AI 收入与 CapEx 数字继续放大，市场关注从“有没有需求”转向“容量何时上线、利用率多高”。
- **垂直应用**：Harvey 的每周 2480 万份文档处理量、Cohere North Automations、Scale 领导层更替、Cursor 印度本地化，显示垂直和工具公司开始披露更贴近真实使用的指标。
- **多模态内容**：字节 Seedance 2.5、MiniMax H3、Runway API、Midjourney V8.2 共同把视频/图像/语音生成推向商业内容生产，但成本、版权与深伪治理仍是约束。

### 资本雷达
- **基础设施金融化**：Meta 140 亿美元 El Paso 合资、AWS 与 Azure 超大 CapEx、Oracle 数据中心社区收益披露、Eliyan 1.45 亿美元融资，说明资本正在向数据中心、互连、chiplet 和能源许可流动。
- **模型公司估值集中**：Kimi 媒体报道 F 轮超 35 亿美元、350 亿美元投后估值；Cohere 累计融资约 16 亿美元；Mistral 和 Sierra 本周静默但仍受前期融资背景影响。
- **机器人公开估值锚**：Unitree IPO 将迫使具身智能公司拿出出货、收入、毛利和交付数据，而不是只展示演示视频。

### 人才/组织雷达
- **Scale AI**：任命 Francis deSouza 为 CEO，强化企业、政府、医疗和安全行业可信度。
- **字节跳动**：飞书产品团队与豆包产品团队整合，To B GTM 与火山引擎对应团队整合，AI 商业化组织优先级上升。
- **NVIDIA / SSI**：与 Ilya Sutskever 创办的 SSI 建立长期战略合作，用算力平台绑定前沿研究人才与需求。

### 风险雷达
- **成本与折旧压力**：AWS、Azure、Google Cloud、Meta、Tesla 都在承受高 CapEx 与自由现金流/折旧压力，后续要看利用率和客户承诺兑现。
- **Agent 权限与数据治理**：Microsoft Scout/Cowork、AWS AgentCore、Cohere North、Glean、Cursor、Meta 个人 Agent 都涉及身份、权限、审计、误操作和敏感数据边界。
- **物理 AI 安全与估值波动**：Google Robotics、Tesla Optimus、Unitree、Figure、UBTech、Humanoid 都面临硬件安全、供应链、量产良率和公开市场重新定价。

## 📚 企业深度正文
## 全球巨头与平台公司

### OpenAI
- 本周动态：OpenAI在本周连续发布GPT‑5.6相关商业化与效率叙事，核心动作是把模型能力提升转化为API与企业产品的价格/性能优势。7月30日，OpenAI宣布GPT‑5.6 Luna降价80%、Terra降价20%，API新价分别为Luna输入$0.20/百万tokens、输出$1.20/百万tokens，Terra输入$2/百万tokens、输出$12/百万tokens；GPT‑5.6 Sol引入Fast mode，较标准处理最高快2.5倍、价格为2倍，替代Priority Processing并兼容旧priority标记。7月29日工程文进一步解释效率来源：GPT‑5.6 Sol参与生产kernel优化，令端到端服务成本下降20%，并通过改进speculative decoding使token生成效率提升15%以上；OpenAI还把“agentic harness”作为效率栈的一部分，强调Codex和ChatGPT Work通过上下文管理、工具调用与缓存减少重复工作。7月31日公司层文章把这些动作上升到“abundant intelligence”战略：以更便宜、更可用的智能扩大需求，再用收入、反馈和需求可见性支持下一轮研究与基础设施投资；文中披露模型触达超过10亿活跃用户和超过200万家企业，六个月后用户日均消息数增加约50%、用途种类约翻倍。7月29日另推“ChatGPT for Academic Researchers”，计划到2027年为10万名科研人员免费提供前沿模型，今夏先覆盖1万人，作为超过2.5亿美元外部科研支持承诺的一部分。
- 企业维度分析：
  - 战略：OpenAI把“前沿模型路线”从单点能力竞争转为全栈效率竞争：模型、推理系统、agent harness、产品和商业价格形成闭环，以“每个成功结果的成本”而非单token价格定义价值。
  - 产品/市场：GPT‑5.6 Sol/Terra/Luna覆盖高推理、均衡生产、高吞吐任务；降价直接利好文档分析、客户交互分类、例行代码实现等高量工作，也提高ChatGPT Work、Codex和API在企业工作流中的渗透率。科研项目则把教育/科研生态纳入分发入口。
  - 资本/组织/人才：本周未公开新融资或并购；基础设施策略披露为“own, partner, or buy”，按可信需求推进容量。关键组织信号是Sol已被用于内部生产优化实验、kernel重写和训练监控，体现“模型改进模型服务效率”的研发工作法。
  - 风险：高频降价会压缩单位毛利并推高需求/算力压力；Fast mode差异化定价需证明高价低延迟价值；科研和生命科学连接器扩大使用面后，隐私、安全和双用途研究治理要求更高。
- 关键数据：GPT‑5.6 Luna降价80%、Terra降价20%，Luna $0.20/$1.20、Terra $2/$12（每百万输入/输出tokens），7月30日，[OpenAI](https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/)；Sol Fast mode最高2.5倍速度、2倍价格，7月30日，[OpenAI](https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/)；Sol帮助生产kernel优化降低端到端服务成本20%、speculative decoding提升token生成效率15%以上，7月29日，[OpenAI工程文](https://openai.com/index/gpt-5-6-frontier-intelligence-efficiency/)；超过10亿活跃用户、超过200万家企业，7月31日，[OpenAI](https://openai.com/index/building-abundant-intelligence/)；科研项目目标10万研究人员、今夏先1万人、外部科研承诺超过2.5亿美元至2027年，7月29日，[OpenAI](https://openai.com/index/chatgpt-for-academic-researchers/)。
- 原文链接：[Advancing the price-performance frontier with GPT-5.6](https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/)；[How GPT-5.6 fuses frontier intelligence with frontier efficiency](https://openai.com/index/gpt-5-6-frontier-intelligence-efficiency/)；[Building abundant intelligence](https://openai.com/index/building-abundant-intelligence/)；[Accelerating scientific discovery with ChatGPT for Academic Researchers](https://openai.com/index/chatgpt-for-academic-researchers/)。
- 影响判断：OpenAI本周的重点不是“又发一个模型”，而是把模型效率转成价格、速度和工作流可部署性，直接瞄准企业预算约束。若其效率数据在真实企业任务中成立，竞争焦点将从旗舰benchmark转向“同等质量下的任务成本”和云/产品入口绑定。

### Google DeepMind / Google AI / Gemini
- 本周动态：Google本周在Gemini体系内的重点是实体世界AI/机器人。7月30日，Google DeepMind发布Gemini Robotics 2，包含三类模型：Gemini Robotics 2（VLA，把视觉与语言输入转为电机控制，可控制全身人形机器人与双臂机器人）、Gemini Robotics ER 2（具身推理VLM，负责对话、物理世界理解、数分钟多步规划和多机器人协作）以及Gemini Robotics On-Device 2（本地运行的高效VLA，可用少量数据适配新机器人形态）。同日Google开发者博客宣布Gemini Robotics ER 2对开发者开放：可通过Gemini API、Google AI Studio使用，并在Gemini Enterprise Agent Platform私有预览。Google强调ER 2可观看连续视频流，跟踪任务进度、失败自我修正，并原生调用Google Search或用户函数；在moment-finding任务上达到91.3%准确率、平均绝对距离0.96秒，并称以4倍执行速度达到低延迟要求；progress classification为57.4%。安全侧，ER 2在Safety Instruction Following和Human Proximity基准优于ER 1.6，并能在人靠近时让人形机器人停止、清场后恢复。背景，非本周：7月21日Google发布Gemini 3.6 Flash、3.5 Flash-Lite和3.5 Flash Cyber，虽在本时间窗外，但为本周机器人开放提供模型效率背景；3.6 Flash价格$1.50/百万输入、$7.50/百万输出，Flash-Lite 350输出tokens/s、$0.3/$2.5。
- 企业维度分析：
  - 战略：Google把Gemini从数字工作流agent延伸到physical AI，形成“云API/AI Studio—企业Agent Platform—机器人VLA/ER—on-device边缘模型”的分层路线，强化多模态和具身智能差异化。
  - 产品/市场：ER 2面向开发者与企业私有预览，绑定Gemini API和Gemini Enterprise Agent Platform；合作/演示涉及Boston Dynamics Spot、Apptronik Apollo 2、Franka F3 Duo等硬件生态，目标是让机器人厂商和企业先接入Google高层推理能力。
  - 资本/组织/人才：本周未公开融资或并购；组织上由DeepMind robotics团队主导，文末列出大规模跨Google团队参与，并感谢Apptronik、Boston Dynamics、Agile Robots等伙伴，体现生态合作而非自研硬件闭环。
  - 风险：机器人从演示走向生产仍受速度、可靠性、硬件适配和安全认证制约；多机器人协作和外部工具调用扩大了物理安全与网络安全边界；私有预览到规模化收费路径仍未公开。
- 关键数据：Gemini Robotics ER 2于7月30日公开给开发者使用并在企业Agent Platform私有预览，[Google Blog](https://blog.google/innovation-and-ai/models-and-research/google-deepmind/gemini-robotics-er-2/)；moment-finding 91.3%准确率、0.96秒平均绝对距离、4倍执行速度，[同源](https://blog.google/innovation-and-ai/models-and-research/google-deepmind/gemini-robotics-er-2/)；progress classification 57.4%准确率，[同源](https://blog.google/innovation-and-ai/models-and-research/google-deepmind/gemini-robotics-er-2/)；On-Device 2通常少于200个样例、数小时适配新双臂机器人形态，7月30日，[DeepMind](https://deepmind.google/blog/gemini-robotics-2-brings-whole-body-intelligence-to-robots/)。
- 原文链接：[Gemini Robotics 2 brings whole body intelligence to robots](https://deepmind.google/blog/gemini-robotics-2-brings-whole-body-intelligence-to-robots/)；[Introducing Gemini Robotics ER 2](https://blog.google/innovation-and-ai/models-and-research/google-deepmind/gemini-robotics-er-2/)；背景，非本周：[Introducing Gemini 3.6 Flash, 3.5 Flash-Lite, and 3.5 Flash Cyber](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-6-flash-3-5-flash-lite-3-5-flash-cyber/)。
- 影响判断：Google本周把“agent”推进到真实空间中的工具编排和安全约束，区别于纯办公/编程agent。若ER模型能成为机器人高层大脑，Google的云API和企业Agent Platform可能进入机器人厂商、工业自动化和具身AI创业公司的默认技术栈。

### Anthropic
- 本周动态：Anthropic本周没有发布新的商业产品或融资公告，但7月28日发布了一篇重要前沿安全/能力研究《Discovering cryptographic weaknesses with Claude》，值得作为企业研究动态纳入。Anthropic称使用Claude Mythos Preview发现两类密码学攻击改进：一是针对后量子数字签名候选方案HAWK的改进攻击，在HAWK经过两年人类专家审查、进入NIST额外数字签名第三轮候选后，Mythos在约60小时工作中找到可利用的非平凡自同构，使该方案有效密钥强度约减半；二是针对7轮简化AES的meet-in-the-middle攻击优化，提出“Möbius Bridge”指纹方法，减少一个2^56级猜测阶段，较此前最强攻击快约200—800倍。Anthropic明确强调两项结果“不影响当前生产系统”：HAWK未部署，AES结果只针对10轮AES-128中的7轮弱化版本。但企业层面信号很强：Claude Mythos Preview不仅做软件漏洞利用，还能参与算法级数学/密码分析；每项主结果研发成本约10万美元API成本，并经过负责任披露，向HAWK作者、NIST公开邮件列表及政府/产业伙伴提前共享。Anthropic还与ETH Zurich、Tel Aviv University、TU Berlin合作推出CryptanalysisBench，以便评估LLM密码分析能力。
- 企业维度分析：
  - 战略：Anthropic继续把“安全能力即产品护城河”作为差异化路线，借前沿红队和双用途研究证明Claude在高风险科学/安全领域具备专家级辅助能力，同时以负责任披露降低监管阻力。
  - 产品/市场：短期没有直接商业化SKU，但Mythos Preview的表现可增强Claude在网络安全、政府、密码标准评审和高端研发市场的可信度；其价值更接近“受控专家代理”而非普通聊天助手。
  - 资本/组织/人才：本周未公开融资、估值、营收或高管变动；研究由Anthropic Frontier Red Team推进，并与多所高校合作构建基准，体现外部学术验证和政策沟通能力。
  - 风险：该成果同时证明前沿模型能发现算法级弱点，双用途风险显著；若未来模型可更便宜、更自主地进行密码分析或漏洞发现，Anthropic需在访问控制、披露流程、客户边界和政府关系上持续投入。
- 关键数据：HAWK攻击发现约60小时；两项主结果每项约10万美元API成本；7轮AES攻击较此前方法快约200—800倍；HAWK小参数预期恢复攻击成本从2^64被展示降至2^38，均为7月28日，[Anthropic](https://www.anthropic.com/research/discovering-cryptographic-weaknesses)。生产系统影响：Anthropic声明无当前生产系统需改变，[同源](https://www.anthropic.com/research/discovering-cryptographic-weaknesses)。
- 原文链接：[Discovering cryptographic weaknesses with Claude](https://www.anthropic.com/research/discovering-cryptographic-weaknesses)；核验范围还查看了[Anthropic News](https://www.anthropic.com/news)与[Anthropic Research](https://www.anthropic.com/research)，本周无其他重大企业公告。
- 影响判断：这不是传统“产品发布”，但会影响AI安全和网络安全市场对Anthropic的定位：Claude被展示为能在严肃数学安全问题上形成新发现的研究代理。其商业价值可能在高信任、受控部署场景释放，但监管和滥用压力也会同步升高。

### Meta AI
- 本周动态：Meta本周同时出现AI产品、基础设施融资和监管合规三条线。产品上，Meta在7月24日（背景，非本周）宣布由Muse Spark 1.1驱动的Meta AI可“计划并跟进执行”，但本周仍处于上线扩展窗口，功能包括一次性设置后持续推送每日简报、训练计划、餐厅/日程规划、Marketplace家居搜寻、网页/论文/平台内容研究和幻灯片生成，并支持用户在生成报告或计划过程中实时改方向；这是Meta把AI从问答推向个人agent入口的核心动作。基础设施上，7月28日Meta与BlackRock宣布成立El Paso数据中心园区合资项目，目标建设1GW compute capacity，2028年开始上线；Meta将是初始唯一租户并提供建设管理等服务。项目总开发成本约140亿美元，Meta保留20%、BlackRock管理资金持有80%；交割时Meta投入土地和在建资产约23亿美元，BlackRock现金投入约49亿美元，部分资金来自125亿美元债务融资，Meta还将获得约10亿美元一次性分配。Meta称该数据中心代表其超过100亿美元投资，将支持AI模型进展和核心业务增强。监管上，Meta 7月28日确认将签署《EU AI Act Code of Practice on Transparency of AI-Generated Content》，并强调与C2PA、Partnership on AI等合作推进AI生成内容识别。AI硬件生态方面，7月27日公布AI Glasses Impact Grants 30家美国组织获资助，项目总额近200万美元，收到近500份申请。
- 企业维度分析：
  - 战略：Meta把“个人superintelligence”入口放在Meta AI app、meta.ai、未来WhatsApp和AI glasses，同时通过资产轻重结合的数据中心融资为模型训练/推理扩容。
  - 产品/市场：Muse Spark 1.1驱动的Meta AI从内容生成走向计划、研究、购物和日程执行；AI眼镜资助计划强化可穿戴场景，覆盖无障碍、职业安全、教育、农业等现实用例，帮助Meta验证眼镜上的AI agent市场。
  - 资本/组织/人才：El Paso项目是本周最重大资本动作：BlackRock/GIP/HPS提供基础设施资本，Meta通过20%股权、长期租赁和残值担保获得容量灵活性；本周未公开重要AI高管流动。
  - 风险：1GW数据中心与长期租赁/残值担保带来资本开支和能源/水资源压力；EU AI透明度承诺降低监管风险但可能增加产品标签复杂度；个人agent与眼镜会触达日程、位置、视觉和交易意图，隐私与信任门槛高。
- 关键数据：El Paso园区1GW compute capacity、预计2028年起上线、总开发成本约140亿美元、Meta/BlackRock 20%/80%股权、Meta投入约23亿美元资产、BlackRock约49亿美元现金、125亿美元债务融资、Meta获约10亿美元一次性分配、Meta残值担保阈值约130亿美元，7月28日，[Meta](https://about.fb.com/news/2026/07/meta-announces-new-venture-with-blackrock-to-develop-data-center-in-el-paso/)；项目代表Meta超过100亿美元投资，支持峰值4000+建设岗位和300个运营岗位，[同源](https://about.fb.com/news/2026/07/meta-announces-new-venture-with-blackrock-to-develop-data-center-in-el-paso/)；AI Glasses Impact Grants近200万美元、30家组织、近500份申请，7月27日，[Meta](https://about.fb.com/news/2026/07/ai-glasses-helping-people-work-learn-live-independently/)。
- 原文链接：[Meta Announces New Strategic Venture With BlackRock to Develop Data Center in El Paso](https://about.fb.com/news/2026/07/meta-announces-new-venture-with-blackrock-to-develop-data-center-in-el-paso/)；[Meta is Signing the EU AI Act Code of Practice on Transparency of AI-Generated Content](https://about.fb.com/news/2026/07/meta-is-signing-the-eu-ai-act-code-of-practice-on-transparency-of-ai-generated-content/)；[AI Glasses Impact Grant Recipients](https://about.fb.com/news/2026/07/ai-glasses-helping-people-work-learn-live-independently/)；背景，非本周：[Meta AI Doesn’t Just Think, It Acts](https://about.fb.com/news/2026/07/meta-ai-muse-spark-doesnt-just-think-it-acts/)。
- 影响判断：Meta本周展示了“前端个人agent + 后端千亿美元级AI基础设施融资能力”的组合。相比OpenAI和Google，Meta的分发优势在社交、WhatsApp和眼镜；但重资产扩容和个人数据敏感度会让监管、信任和资本效率成为关键约束。

### Microsoft AI / Copilot / Azure AI
- 本周动态：Microsoft本周AI主线集中在Copilot商业化指标与“工作被改造”的企业叙事。7月30日，Microsoft 365博客引用前一日财报电话会数据称，Microsoft 365 Copilot已超过3000万付费席位，净新增席位环比超过翻倍；客户超过5万席位的数量同比增长超过7倍，企业客户把Copilot部署给多数信息工作者的数量环比增长近75%，达到高使用率（客户群体月活超过80%）的时间从过去数月缩短到数天。文章将AI从“助手”推进到“主动参与者”，重点讲Copilot Cowork和Microsoft Scout：Cowork可承接多步工作、端到端返回完成结果，多模型设计让不同任务使用不同模型，内部测试称相比单一模型方案便宜30%—40%；Scout则是后台常驻、有自身身份和权限的autopilot agent。客户案例方面，Microsoft披露Cloud Supply Chain部署70多个专用agent后，选定流程周期时间下降75%；Premera Blue Cross员工已构建900多个agent；Levi’s用agent在一天内分析1100份财务SOP并编目18000个任务；S&P Global的Teams内Copilot agent使数据提取快95%、比较分析快98%；Microsoft销售pilot中客户面对面时间从25%升至50%，收入/人提升9.4%，成交快20%。背景，非本周：Azure Cobalt 200 VM文章6月2日发布、7月9日修改，不纳入本周动态，但可作为Azure AI基础设施路线背景：Cobalt 200面向agentic AI工作负载，较Cobalt 100最高50% CPU性能提升。
- 企业维度分析：
  - 战略：Microsoft把AI竞争焦点从“卖Copilot席位”迁移到“重构组织流程与角色”，通过Work IQ、Microsoft 365数据、Agent 365治理和Copilot/Cowork/Scout形成企业agent控制面。
  - 产品/市场：Microsoft 365 Copilot已进入规模付费阶段，Cowork、Scout和Copilot Studio将AI从个人效率工具扩展为流程执行层；强绑定Teams、Outlook、Graph、Microsoft 365连接器和企业权限体系。
  - 资本/组织/人才：本周未公开AI并购或融资；组织案例显示Cowork核心团队从3名工程师增长到9名即GA，并称6个月内被半数Fortune 500使用，强调“frontier teams”小团队+agent工程方法。
  - 风险：Copilot指标虽强，但真实ROI取决于流程重构而非单纯席位扩张；agent拥有身份与权限后，治理、越权、数据泄漏和审计复杂度上升；客户案例多为选择性披露，需要持续验证可复制性。
- 关键数据：Microsoft 365 Copilot超过3000万付费席位、净新增席位环比超翻倍，7月30日，[Microsoft 365 Blog](https://www.microsoft.com/en-us/microsoft-365/blog/2026/07/30/the-next-measure-of-ai-momentum-is-work-transformed/)；>5万席位客户数同比超7倍、多数信息工作者部署客户数环比近75%，[同源](https://www.microsoft.com/en-us/microsoft-365/blog/2026/07/30/the-next-measure-of-ai-momentum-is-work-transformed/)；Cowork内部测试便宜30%—40%，[同源](https://www.microsoft.com/en-us/microsoft-365/blog/2026/07/30/the-next-measure-of-ai-momentum-is-work-transformed/)；Cloud Supply Chain 70+ agents、周期时间下降75%；Premera 900+ agents；S&P Global数据提取快95%、比较分析快98%；销售pilot收入/人+9.4%、成交快20%，均见7月30日同源。
- 原文链接：[The next measure of AI momentum is work transformed](https://www.microsoft.com/en-us/microsoft-365/blog/2026/07/30/the-next-measure-of-ai-momentum-is-work-transformed/)；核验范围还查看了[Microsoft 365 Blog](https://www.microsoft.com/en-us/microsoft-365/blog/)与[Azure Blog](https://azure.microsoft.com/en-us/blog/)；背景，非本周：[Azure Cobalt 200 VMs](https://azure.microsoft.com/en-us/blog/new-azure-cobalt-200-vms-deliver-50-performance-improvement-fully-optimized-for-modern-agentic-ai-workloads/)。
- 影响判断：Microsoft的优势正在从模型本身转向“企业工作图谱+权限+分发+治理”的组合。3000万付费席位说明Copilot已过早期采用门槛，但下一阶段竞争会看agent是否能把多系统流程真正自动化，而不是只停留在会议纪要和文档生成。

### Amazon / AWS AI
- 本周动态：Amazon/AWS本周有多项面向生产级agent和企业AI应用的动作。7月30日，AWS与OpenAI联合发布OpenAI GPT‑5.6 Sol、Terra、Luna在Amazon Bedrock上GA后的显式prompt caching指南：GPT‑5.6模型通过Bedrock的OpenAI-compatible Responses API在bedrock-mantle endpoint提供，Sol用于复杂推理和agentic coding，Terra用于平衡型生产负载，Luna用于分类、摘要等高吞吐任务；显式prompt caching允许开发者指定prompt哪些部分缓存复用，缓存输入按90%折扣计费并可复用30分钟，特别适合系统指令、工具定义和参考文档重复的agentic workflows。7月30日另一篇Bedrock文章推出Advanced Prompt Optimization，可在单个任务中为最多5个Bedrock模型优化/迁移prompt，输出原始与优化prompt、评估分数、TTFT和按需价格下推理成本估算，试图解决企业迁移到更快/更便宜模型时的prompt重调成本。7月31日，Amazon Quick宣布Agentic Catalog Experience：Quick Agent利用AWS Glue Data Catalog、Databricks Unity Catalog等上游语义/治理元数据，帮助数据管理员发现、继承和创建可供自然语言问答与仪表板使用的语义边界，减少“数据目录到AI分析”的最后一公里。7月31日AgentCore Observability文章则面向生产agent运营，给出CloudWatch/OpenTelemetry监控慢响应、顺序工具调用、内存增长和token膨胀的实践。财务侧，Amazon于7月31日向SEC提交10-Q，Q2 2026 AWS净销售额422.32亿美元、营业利润166.21亿美元；Q2现金资本支出531亿美元，六个月963亿美元，主要反映技术基础设施投资（多数支持AWS业务增长）和履约网络容量。
- 企业维度分析：
  - 战略：AWS继续用Bedrock做多模型中立入口，一边承接OpenAI GPT‑5.6，一边补齐prompt迁移、agent身份、observability、BI语义层等生产工具，把“模型调用”扩展为企业AI应用生命周期平台。
  - 产品/市场：OpenAI模型进入Bedrock并计入AWS既有commitments，降低企业采购摩擦；Quick Agentic Catalog Experience将AI分析嵌入BI/数据治理链路；AgentCore Observability瞄准agent上线后可靠性和成本控制。
  - 资本/组织/人才：本周未公开AI并购或高管变动；SEC 10-Q显示高CapEx持续，技术基础设施投资多数支持AWS增长，AI与云需求仍是资本支出的核心驱动。
  - 风险：多模型平台需在OpenAI、Anthropic、Meta等供应商间维持差异化；Bedrock封装虽利于治理，但客户可能比较直连模型商价格与能力；高CapEx要求AWS收入增速和利用率持续匹配。
- 关键数据：GPT‑5.6显式prompt caching在Bedrock上缓存输入90%折扣、缓存30分钟，7月30日，[AWS ML Blog](https://aws.amazon.com/blogs/machine-learning/introducing-explicit-prompt-caching-for-openai-gpt-5-6-models-on-amazon-bedrock/)；Advanced Prompt Optimization一次最多优化5个Bedrock模型，7月30日，[AWS ML Blog](https://aws.amazon.com/blogs/machine-learning/migrate-your-prompts-to-new-models-and-optimize-them-on-amazon-bedrock/)；AWS Q2 2026净销售额422.32亿美元、营业利润166.21亿美元，7月31日，[Amazon 10-Q SEC filing](https://www.sec.gov/Archives/edgar/data/1018724/000101872426000026/amzn-20260630.htm)；Q2 2026现金资本支出531亿美元、六个月963亿美元，主要为技术基础设施（多数支持AWS增长）与履约网络，7月31日，[Amazon 10-Q](https://www.sec.gov/Archives/edgar/data/1018724/000101872426000026/amzn-20260630.htm)。
- 原文链接：[Introducing explicit prompt caching for OpenAI GPT-5.6 models on Amazon Bedrock](https://aws.amazon.com/blogs/machine-learning/introducing-explicit-prompt-caching-for-openai-gpt-5-6-models-on-amazon-bedrock/)；[Migrate your prompts to new models and optimize them on Amazon Bedrock](https://aws.amazon.com/blogs/machine-learning/migrate-your-prompts-to-new-models-and-optimize-them-on-amazon-bedrock/)；[Announcing the Agentic Catalog Experience in Amazon Quick](https://aws.amazon.com/blogs/machine-learning/announcing-the-agentic-catalog-experience-in-amazon-quick/)；[Optimizing production agents with Amazon Bedrock AgentCore Observability](https://aws.amazon.com/blogs/machine-learning/optimizing-production-agents-with-amazon-bedrock-agentcore-observability/)；[Amazon Q2 2026 10-Q](https://www.sec.gov/Archives/edgar/data/1018724/000101872426000026/amzn-20260630.htm)。
- 影响判断：AWS本周的动作说明云厂商AI竞争已经进入“生产工程化工具”阶段：缓存、prompt迁移、身份、监控、语义目录都会影响企业能否大规模落地agent。其挑战是让这些平台能力成为客户迁移/留存理由，而不只是模型供应商API的转售层。

### xAI
- 本周动态：本周无重大公开动态。核验范围包括xAI主站/新闻页（`x.ai/news`、`x.ai/blog`、`x.ai/open-source`，访问时返回“Blocked due to abusive traffic patterns”）、xAI开发者文档首页、模型页、文本生成指南与Release Notes。可确认xAI文档在“July”项下列有Grok 4.5、Grok Voice Think Fast 2.0、Imagine video 1.5多模态、EU API可用等更新，但Release Notes未给出具体日粒度日期，且对应`x.ai/news/...`公告页本次无法读取全文；因此无法严格确认这些更新发生在2026-07-27至2026-08-02自然周内，按本周报质量规则不作为本周重大动态展开。背景，非本周/日期未核验：xAI文档显示Grok 4.5定位为用于coding、agentic tasks和knowledge work的模型，API价为输入$2/百万tokens、输出$6/百万tokens，支持500k上下文；Grok 4.3与4.20系列支持1M上下文；Responses API默认在xAI服务器保存请求/响应30天以便用response ID继续对话，也可设置`store:false`关闭保存。
- 企业维度分析：
  - 战略：本周未见可核验的新战略公告；从已读文档看，xAI仍围绕Grok 4.5、Grok Build、Imagine、Voice与Responses API扩展多模态和开发者入口。
  - 产品/市场：本周无可确认新产品发布；已公开文档显示API覆盖文本、代码、语音、图像、视频和工具调用，但日期无法精确落入本周。
  - 资本/组织/人才：本周未公开融资、估值、营收、并购、高管或核心研究员流动。
  - 风险：公开信息可访问性较弱，增加外部客户和研究者对发布时间、产品变更和合规细节的核验成本；Responses API默认保存30天的设计也需要企业客户关注数据留存设置。
- 关键数据：本周无可核验自然周内关键经营/产品数字；背景，日期未核验：Grok 4.5 API价$2/百万输入tokens、$6/百万输出tokens，500k上下文；Responses API默认保存30天，[xAI Models](https://docs.x.ai/developers/models)、[xAI Generate Text](https://docs.x.ai/developers/model-capabilities/text/generate-text)。
- 原文链接：[xAI Release Notes](https://docs.x.ai/developers/release-notes)；[xAI Models](https://docs.x.ai/developers/models)；[xAI Generate Text](https://docs.x.ai/developers/model-capabilities/text/generate-text)；主站新闻页访问受阻，未将无法全文核验内容纳入本周动态。
- 影响判断：xAI本周在可访问公开渠道中没有可严格落入时间窗的重大企业动态。后续需要重点监控Grok 4.5/Grok Build的开发者采用、语音/视频API商业化和数据留存/企业合规设置。

### NVIDIA
- 本周动态：NVIDIA本周有两条与AI巨头/平台生态高度相关的重大动态。7月27日，NVIDIA与Ilya Sutskever创办的Safe Superintelligence Inc.（SSI）宣布长期战略合作，NVIDIA同时投资SSI；SSI将获得下一代Vera Rubin平台访问权，使其compute提升一个数量级，双方还将围绕当前和未来计算平台进行技术协作。NVIDIA披露其在获得SSI严格保密研究的罕见访问后进入合作，Jensen Huang称期待SSI在Vera Rubin平台支持下取得新突破；Ilya Sutskever则表示SSI已有“worthy of scaling up”的研究。该动作把NVIDIA从通用GPU供应商进一步推向“前沿实验室战略资本+算力平台”的角色。7月27日，NVIDIA博客宣布Open Secure AI Alliance，联合Microsoft、Mistral、Hugging Face、IBM、Red Hat、CrowdStrike、Cloudflare、Databricks、Dell、GitHub、Palantir、Salesforce、ServiceNow、Snowflake、SpaceXAI等众多企业和开源/安全生态伙伴，主张开放模型、开放harness和工具是AI安全与网络防御资产；NVIDIA将贡献开放模型、权重、数据和agent harness研究，并介绍NOOA（NVIDIA Labs Object-Oriented Agent）用于提升agent harness的测试、追踪、审计和治理能力。7月28日，NVIDIA还面向Jetson发布“Build AI Anywhere”内容，强化Jetson Orin Nano Super、AGX Orin和AGX Thor在边缘AI/机器人中的开发者入口，披露Orin Nano Super 67 TOPS、AGX Orin 275 TOPS、AGX Thor最高2070 FP4 TFLOPS与128GB内存。
- 企业维度分析：
  - 战略：NVIDIA继续把自身定位从芯片卖方升级为AI工厂、前沿实验室资本伙伴、开放安全生态组织者和physical AI边缘平台提供者；SSI合作尤其强化其对下一代模型实验室的算力绑定。
  - 产品/市场：Vera Rubin被作为SSI扩算力的核心平台；Open Secure AI Alliance为NVIDIA在AI安全/agent安全工具栈中建立话语权；Jetson内容把开发者、学生、机器人创业团队引向NVIDIA边缘生态。
  - 资本/组织/人才：NVIDIA本周确认投资SSI，但金额未公开；与Ilya Sutskever绑定具有强人才/品牌信号。7月29日还宣布将于8月26日召开FY2027 Q2业绩电话会，Q2截至7月26日。
  - 风险：对前沿实验室的战略投资和算力承诺会增加客户/投资组合集中度与监管关注；开放AI安全联盟需处理开放模型滥用争议；Jetson与Vera Rubin路线分别面临边缘机器人落地周期长和高端算力供给/出口管制风险。
- 关键数据：SSI合作将使SSI compute提升一个数量级，NVIDIA投资金额未公开，7月27日，[NVIDIA Newsroom](https://nvidianews.nvidia.com/news/ilya-sutskevers-safe-superintelligence-inc-and-nvidia-announce-long-term-strategic-partnership)；Open Secure AI Alliance覆盖云、安全、企业软件、开源和AI研究大量首批伙伴，NVIDIA将贡献开放模型、模型权重、数据和agent harness研究，7月27日，[NVIDIA Blog](https://blogs.nvidia.com/blog/open-secure-ai-alliance/)；Jetson Orin Nano Super 67 TOPS、Jetson AGX Orin 275 TOPS、Jetson AGX Thor最高2070 FP4 TFLOPS与128GB内存，7月28日，[NVIDIA Blog](https://blogs.nvidia.com/blog/build-ai-with-nvidia-jetson/)；FY2027 Q2业绩电话会定于8月26日，Q2截至7月26日，7月29日，[NVIDIA Newsroom](https://nvidianews.nvidia.com/news/nvidia-sets-conference-call-for-second-quarter-financial-results-6927195)。
- 原文链接：[Ilya Sutskever’s Safe Superintelligence Inc. and NVIDIA Announce Long-Term Strategic Partnership](https://nvidianews.nvidia.com/news/ilya-sutskevers-safe-superintelligence-inc-and-nvidia-announce-long-term-strategic-partnership)；[Industry Leaders Unite in Open Secure AI Alliance for AI Safety and Security](https://blogs.nvidia.com/blog/open-secure-ai-alliance/)；[Powerful Compute So Compact, It’s Clutch — Build AI Anywhere With NVIDIA Jetson](https://blogs.nvidia.com/blog/build-ai-with-nvidia-jetson/)；[NVIDIA Sets Conference Call for Second-Quarter Financial Results](https://nvidianews.nvidia.com/news/nvidia-sets-conference-call-for-second-quarter-financial-results-6927195)。
- 影响判断：NVIDIA本周最关键的不是单个硬件发布，而是算力资本与生态治理能力的延伸：投资SSI锁定前沿模型需求，Open Secure AI Alliance争夺AI安全标准话语权，Jetson强化物理AI入口。其平台权力继续上升，但也更深卷入前沿AI安全、开放模型政策和算力地缘政治。

## 本组洞察
1. **价格/效率成为新一轮模型竞争主线。** OpenAI GPT‑5.6降价、AWS Bedrock prompt caching、xAI模型价格表、Microsoft Cowork成本比较，都在说明企业采购开始围绕“完成一个任务/流程的总成本”而非单纯benchmark或token单价决策。
2. **Agent商业入口从聊天转向流程控制面。** Microsoft用Copilot/Cowork/Scout绑定Microsoft 365工作图谱，AWS补AgentCore身份/可观测性/Quick语义目录，Meta把个人日程、购物、简报和眼镜变成consumer agent入口，Google则把agent推进到机器人编排。
3. **AI基础设施融资和算力绑定更像产业金融。** Meta用BlackRock合资+债务融资建设1GW数据中心，Amazon 10-Q显示Q2现金CapEx 531亿美元且多数技术基础设施支持AWS增长，NVIDIA投资SSI并提供Vera Rubin访问权；算力不再只是采购，而是战略合作、融资结构和长期租约组合。
4. **安全与监管从外围议题变成产品/生态卖点。** Anthropic用Claude做密码分析并强调负责任披露，NVIDIA组织Open Secure AI Alliance，Google发布机器人安全基准，Meta签署EU AI Act生成内容透明度代码；下一阶段企业客户会要求模型能力、治理、审计、内容标识和物理/网络安全一起交付。
5. **物理AI开始进入平台公司正式战线。** Google Gemini Robotics 2和NVIDIA Jetson/SSI动作共同显示，前沿AI竞争正从办公与编程agent外溢到机器人、边缘设备和AI工厂；但该方向的商业化周期、硬件适配和安全认证仍明显长于软件agent。

## 中国 AI 头部企业

### 阿里 / Qwen / 夸克
- 本周动态：本周阿里在AI办公与语音模型两条线上连续推进。7月27日，据《每日经济新闻》转述《科创板日报》，阿里新款AI Agent产品“千问办公”开始小范围测试，当前形态为本地桌面客户端，后续计划上线网页端与钉钉内置版；该产品整合QoderWork、悟空、MuleRun等Agent能力，由钉钉新任CEO陈宇森负责，体现阿里把分散Agent产品收束到办公入口的意图。7月28日，阿里云Qoder上线Qoder Voice，由Qwen-Audio-3.0-Realtime驱动，面向开发者提供语音创建任务、方案讨论、后台执行与中途打断/追问能力，国际版先行开放并提供3天免费试用。7月31日前后，阿里云百炼文档显示Qwen-Audio-3.0-ASR-Flash/Filetrans已进入语音识别模型序列：Flash适用于5分钟以内同步识别，Filetrans支持单个最长12小时、最大2GB音视频异步转写，并支持上下文增强、自定义热词、说话人分离、敏感词过滤、句/词级时间戳等。这些动作显示阿里本周的重点不是单纯“发模型”，而是把Qwen语音能力嵌入开发、办公、会议转写和行业语音场景。夸克方面，本周未检索到时间窗内重大公开AI产品/商业化公告。
- 企业维度分析：
  - 战略：阿里把Qwen模型能力沿“办公Agent + 语音交互 + 百炼API”三层分发：C端/个人生产力靠千问办公，开发者入口靠Qoder Voice，B端调用靠阿里云百炼，路线从模型榜单转向可执行工作流和企业交付。
  - 产品/市场：千问办公若后续进入钉钉，将直接触达既有企业协作客户；Qoder Voice以语音驱动AI编程，尝试提升开发者高频使用时长；ASR模型覆盖会议、客服、字幕、通话分析等付费API场景。
  - 资本/组织/人才：本周未公开AI相关融资；组织上千问办公由钉钉新任CEO陈宇森负责，说明阿里将AI办公与钉钉企业入口绑定。
  - 风险：办公Agent需要跨本地文件、企业数据与钉钉权限，数据安全和执行边界是核心风险；语音/转写场景还面临行业词准确率、隐私合规与低价竞争压力。
- 关键数据：Qwen-Audio-3.0-ASR-Flash适用于5分钟以内音频同步识别，Filetrans支持单个最长12小时、体积不超过2GB的音视频异步转写（来源：[阿里云帮助中心，抓取于2026-08-03](https://help.aliyun.com/zh/model-studio/non-realtime-speech-recognition-user-guide)）；Qoder Voice提供3天免费试用（来源：[站长之家，2026-07-28](https://www.chinaz.com/ainews/29950.shtml)）。千问办公、Qoder Voice收入/客户数未公开。
- 原文链接：[每日经济新闻｜阿里AI Agent“千问办公”小范围测试](https://www.nbd.com.cn/articles/2026-07-27/4517675.html)；[财闻网｜Qoder上线实时语音交互智能体Qoder Voice](https://www.caiwennews.com/article/1533138.shtml)；[阿里云帮助中心｜非实时语音识别](https://help.aliyun.com/zh/model-studio/non-realtime-speech-recognition-user-guide)
- 影响判断：阿里本周动作显示其AI战略正在从“大模型发布”转向“办公主入口与云API的双商业化”。如果千问办公能顺利接入钉钉，阿里将在企业工作流中获得高频AI入口；但执行式Agent对安全、权限和可靠性要求更高，短期仍需小范围验证。

### 字节跳动 / 豆包 / 火山引擎
- 本周动态：字节本周同时发生产品升级与组织整合。7月31日，财新报道字节跳动发布视频生成模型Seedance 2.5，陆续上线即梦AI、豆包专业版等平台，API服务近期将上线火山方舟；报道还提到，截至6月底，Seedance 2.0海外调用占比从1/3增长到1/2，说明字节AI视频能力已有明显海外需求。每日经济新闻同周报道补充称，Seedance 2.5延续Seedance 2.0统一的多模态音视频联合生成架构，重点突破长叙事、多模态参考和编辑能力，可单次生成30秒高质量视频片段并支持多轮延长，目标场景包括短剧、营销、培训和企业内容生产。组织方面，7月30日字节启动AI业务架构调整：飞书产品团队与豆包产品团队整合为新的豆包产品团队，由豆包负责人赵祺负责，飞书负责人谢欣向其汇报；原飞书GTM与火山引擎对应团队整合为“To B GTM组织”创造力服务平台，由火山引擎负责人谭待负责。这是字节将C端豆包、办公飞书与火山MaaS/SaaS商业化体系打通的重要信号。
- 企业维度分析：
  - 战略：字节把模型产品、办公协作和云服务销售合并推进，形成“豆包/即梦C端分发—飞书办公场景—火山方舟API/企业服务”的闭环，减少内部赛马，提高AI企业服务转化效率。
  - 产品/市场：Seedance 2.5直指AI视频长片段与可编辑性痛点；海外调用占比提升显示其不只服务国内短剧，也在全球创作工具和企业视频市场争夺份额。
  - 资本/组织/人才：未公开外部融资；组织调整涉及赵祺、谢欣、谭待等关键负责人，GTM合并表明商业化优先级升高。
  - 风险：AI视频成本高、版权与深伪监管压力大；组织整合可能带来飞书原有SaaS客户路线与豆包C端产品文化的磨合成本。
- 关键数据：Seedance 2.5于2026-07-31发布并上线即梦AI、豆包专业版等，API近期上线火山方舟（来源：[财新，2026-07-31](https://companies.caixin.com/m/2026-07-31/102469970.html)）；截至2026年6月底，Seedance 2.0海外调用占比从1/3增长到1/2（来源同上）；Seedance 2.5可单次生成30秒高质量视频片段（来源：[每日经济新闻，2026-08-02](https://www.nbd.com.cn/articles/2026-08-02/4529677.html)）。Seedance 2.5定价未公开。
- 原文链接：[财新｜字节跳动、MiniMax同日发布新模型 推AI一键完成视频创作](https://companies.caixin.com/m/2026-07-31/102469970.html)；[每日经济新闻｜一周未来商业](https://www.nbd.com.cn/articles/2026-08-02/4529677.html)
- 影响判断：字节本周是B组中“产品+组织”最完整的一次动作：AI视频负责拉动内容生态与海外调用，组织整合负责把飞书和火山的企业销售能力接上豆包模型。后续关键看API定价、生成成本和To B客户是否能规模化转化。

### 腾讯 / 混元 / 元宝
- 本周动态：本周腾讯主要公开动态集中在AI办公Agent而非元宝C端补贴。7月27日，多家媒体援引腾讯云消息称，腾讯WorkBuddy正式上架鸿蒙电脑应用市场，成为鸿蒙电脑首款第三方桌面办公智能体；《中国日报》转载稿称，WorkBuddy此前已于7月18日发布App，本次上架使其完成鸿蒙手机、平板、PC桌面的覆盖。文章披露，WorkBuddy定位为“全场景职场AI智能体桌面工作台”，可在用户授权后读写本地文件，执行批量重命名、跨表格数据提取、文件归档等任务；还支持主流大模型与私有模型切换，接入腾讯混元Hy3、MiniMax、Kimi、DeepSeek、GLM等模型，并内置12个行业的140+ AI顾问、兼容2.2万+技能插件。文中还称据腾讯2026年Q1财报及第三方报告，2026年6月WorkBuddy月访问量突破2000万，位居国内桌面端AI原生办公智能体平台首位。元宝、混元基础模型方面，本周未检索到时间窗内新的重大公开发布。
- 企业维度分析：
  - 战略：腾讯本周把重点放在办公Agent与鸿蒙生态入口，采用“混元自研+多模型接入”的平台化策略，弱化单一模型对抗，强化桌面执行、文件处理和插件生态。
  - 产品/市场：WorkBuddy从移动端扩展到鸿蒙PC端，有利于抢占桌面生产力场景；支持本地文件和跨端联动，贴近企业与个人办公高频需求。
  - 资本/组织/人才：本周未公开AI相关融资、并购或高管变化；产品由腾讯云消息体系对外释放，表明其更偏企业服务/云生态叙事。
  - 风险：桌面智能体直接读写本地文件，权限管理、误操作和数据泄露风险较高；多模型接入虽利于能力覆盖，但可能削弱混元自身品牌心智。
- 关键数据：2026年6月WorkBuddy月访问量突破2000万；内置12个行业140+ AI顾问、兼容2.2万+技能插件；腾讯Hy3限免开放延长至8月5日（来源：[中国日报中文网，2026-07-27](https://cn.chinadaily.com.cn/a/202607/27/WS6a6705a9a310d709c2fbfdfe.html)）。元宝本周新增用户/营收未公开。
- 原文链接：[中国日报中文网｜腾讯WorkBuddy重磅更新，鸿蒙电脑首款桌面办公智能体来了](https://cn.chinadaily.com.cn/a/202607/27/WS6a6705a9a310d709c2fbfdfe.html)；[每日经济新闻｜未来商业早参](https://www.nbd.com.cn/articles/2026-07-27/4517675.html)
- 影响判断：腾讯本周的看点是把AI办公从“聊天/总结”推向“桌面执行”。若WorkBuddy能凭鸿蒙PC形成先发样板，腾讯可在企业办公Agent中获得新的入口；但该入口仍需证明可持续付费和企业级安全能力。

### 百度 / 文心 / 千帆
- 本周动态：本周未检索到百度、文心、千帆在2026-07-27至2026-08-02期间的重大公开企业动态。核验范围包括：百度智能云千帆官网/产品页、百度文心相关搜索、权威媒体与科技媒体按时间窗检索。搜索结果中较多为背景信息：如百度千帆2月披露平台已累计支持企业构建超130万个Agents、工具日均调用次数达到数千万级；6月25日百度文心助手网页版整合为网页端AI服务统一入口；以及5月文心5.1发布等，均为“背景，非本周”。本周可观察到百度千帆产品页持续展示其工具/Skill/MCP生态，包括百度搜索、智能搜索生成、百度百科、百度网盘AI视频笔记、百度文库AI绘本、文档解析、百度地图、百度安全扫描等能力，但页面未体现本周新发布或重大商业化事件。
- 企业维度分析：
  - 战略：背景信息显示百度仍围绕搜索、知识库、文档、地图等自有数据资产构建千帆MCP/Skill生态，路径偏企业级AI应用底座和搜索增强。
  - 产品/市场：本周无重大公开新品；千帆产品页强调生成式AI检索、AI总结、视频笔记、文档解析和地图能力，说明百度继续把自有内容与工具作为差异化卖点。
  - 资本/组织/人才：本周未公开AI相关融资、并购、高管或组织调整。
  - 风险：在本周阿里、字节、腾讯、Kimi等密集推进Agent和模型商业化时，百度公开声量偏弱；其搜索/文档生态优势需要转化为可见的开发者与企业采用增长。
- 关键数据：本周无新增关键数字公开。背景，非本周：千帆2月披露累计支持企业构建超130万个Agents、工具日均调用数千万级（来源：[新京报，2026-02-06](https://m.bjnews.com.cn/detail/1770293094129484.html)）。
- 原文链接：[百度智能云千帆大模型平台产品页](https://cloud.baidu.com/product-s/qianfan_home)；背景，非本周：[新京报｜百度千帆披露AI落地成绩](https://m.bjnews.com.cn/detail/1770293094129484.html)
- 影响判断：百度本周处于公开信息静默期。其AI竞争力仍在搜索、知识和云平台工具链，但本周没有新的节点事件可证明商业化加速；后续应重点跟踪千帆Agent开发者生态和文心入口整合后的活跃度。

### 华为 / 昇腾 / 盘古
- 本周动态：7月31日，华为云宣布openPangu-2.0-Pro模型及技术报告正式开源上线，公开内容包括5050亿参数的openPangu-2.0-Pro模型权重、基础推理代码和技术报告。华为云在公告中强调，openPangu是华为开源AI模型品牌，基于昇腾原生训练与推理技术，目标是为业界用好昇腾提供最佳实践参考，并通过华为云MaaS模型即服务平台提供在线体验。按本周报边界，这一事件不作为“开源项目”单独研究，而视为华为围绕昇腾算力生态、模型分发和MaaS商业化的公司战略动作：通过开放权重和推理代码，降低开发者与伙伴在昇腾上迁移、部署和验证大模型的门槛，进而扩大国产AI芯片与基础软件的采用面。7月17日昇腾950超节点亮相WAIC属于背景，非本周，但与本周openPangu形成“硬件超节点+原生模型生态”的连续叙事。
- 企业维度分析：
  - 战略：华为把盘古开源品牌与昇腾原生训练/推理绑定，核心不是模型免费本身，而是以模型和技术报告作为昇腾最佳实践，带动国产算力生态、ModelArts/MaaS和行业伙伴适配。
  - 产品/市场：openPangu-2.0-Pro提供权重、基础推理代码和华为云MaaS在线体验，服务开发者、企业伙伴和研究人员；对B端客户而言，降低在昇腾环境验证Agent底座的技术摩擦。
  - 资本/组织/人才：本周未公开AI相关资本或组织变动。
  - 风险：开放模型能否转化为昇腾硬件和云服务订单仍需观察；生态兼容性、推理成本、开发工具成熟度会决定伙伴迁移速度。
- 关键数据：openPangu-2.0-Pro参数规模5050亿；2026-07-31公开模型权重、基础推理代码及技术报告（来源：[华为云，2026-07-31](https://www.huaweicloud.com/news/2026/20260731095113610.html)）。昇腾相关新增订单/收入未公开。
- 原文链接：[华为云｜openPangu-2.0-Pro模型及技术报告正式开源上线](https://www.huaweicloud.com/news/2026/20260731095113610.html)
- 影响判断：华为本周动作强化了“国产算力适配”主线。相比纯模型能力竞赛，openPangu更像昇腾生态的样板工程；若开发者能在昇腾上稳定复现推理和Agent应用，将有助于华为扩大AI基础设施话语权。

### DeepSeek
- 本周动态：7月31日，DeepSeek通过官方API文档更新日志宣布DeepSeek-V4-Flash正式版API上线公测，API调用方式不变，模型名设置为`deepseek-v4-flash`即可使用最新版本。官方称本次更新重点增强Agent能力，公开列出多项基准：Terminal Bench 2.1为82.7、NL2Repo为54.2、Cybergym为76.7、DeepSWE为54.4、Toolathlon verified为70.3、Agent Last Exam为25.2、Automation Bench (Public)为25.1、DSBench-FullStack为68.7、DSBench-Hard为59.6。正式版V4-Flash原生支持Responses API格式，并针对Codex做适配；DeepSeek-V4-Flash-0731的模型结构、尺寸与V4-Flash-Preview保持一致，仅重新进行了后训练。官方同时强调，本次只升级V4-Flash的API接口，V4-Pro API及APP/WEB端模型未做更改，V4-Pro正式版将尽快发布。该事件对企业研究的核心意义在于：DeepSeek继续以API端低摩擦升级和Agent能力为主线争夺开发者，而非在C端APP做大规模发布。
- 企业维度分析：
  - 战略：DeepSeek选择先升级Flash API，说明其本周优先级是低成本、高吞吐、面向Agent和编码工作流的开发者市场；Responses API与Codex适配有助于嵌入现有AI编程工具链。
  - 产品/市场：API调用方式不变降低迁移成本；Agent基准提升与后训练更新，将直接影响代码修改、工具调用、多步骤任务等付费API场景。
  - 资本/组织/人才：本周未见官方融资、上市或组织调整公告；此前IPO/融资传闻不纳入本周事实。
  - 风险：V4-Pro和APP/WEB端未同步升级，可能造成用户对“正式版只来一半”的预期落差；Agent基准表现需在真实客户工作流中验证，且价格战会压缩毛利。
- 关键数据：DeepSeek-V4-Flash正式版API于2026-07-31公测；Terminal Bench 2.1 82.7、DeepSWE 54.4、Toolathlon verified 70.3、DSBench-FullStack 68.7等（来源：[DeepSeek API更新日志，2026-07-31](https://api-docs.deepseek.com/zh-cn/updates/)）。API收入、客户数、价格变化本周未公开。
- 原文链接：[DeepSeek API Docs｜更新日志](https://api-docs.deepseek.com/zh-cn/updates/)；[IT之家｜DeepSeek-V4-Flash正式版API上线公测](https://www.ithome.com/0/984/116.htm)
- 影响判断：DeepSeek本周延续“API优先、开发者优先”的商业化路线。V4-Flash若能在Agent任务上稳定兑现，将加强其在AI Coding和工具调用场景的成本优势；但V4-Pro与C端未更新意味着短期声量可能不如全端发布。

### 智谱AI
- 本周动态：智谱本周围绕AI Coding订阅和国产算力供给释放商业化信号。7月30日，智谱官方文档发布GLM Coding Plan套餐改版与老用户权益说明：新版套餐采用以Token消耗为基础的积分制，老用户权益不受影响，V1老用户到期前可按V2价格订阅；文档还披露历史V2个人套餐的用量规则，例如Lite每5小时最多约80次prompts、每周约400次，Pro每5小时约400次、每周约2000次，Max每5小时约1600次、每周约8000次；团队套餐自7月30日起各席位额度统一上调30%，团队标准版每席位每5小时最多0.78亿tokens、每周最多3.9亿tokens，团队高级版每席位每5小时最多2.08亿tokens、每周最多10.4亿tokens。7月31日，经济观察网援引第一财经称，随着基础设施持续扩容，面向开发者的GLM Coding Plan开放订阅；此前因AI Coding需求爆发曾阶段性限制订阅名额，并称智谱已落地1GW级国产AI算力数据中心建设，全部采用国产AI芯片。
- 企业维度分析：
  - 战略：智谱把“可订阅的AI Coding服务”与“国产AI算力扩容”绑定，试图从模型能力竞争进入开发者付费和算力供给闭环。
  - 产品/市场：透明积分制提高用户对额度和成本的可预期性；团队套餐额度上调30%说明智谱在企业/团队开发场景争夺使用频次。
  - 资本/组织/人才：本周未公开新增融资或高管变动；1GW级国产AI算力数据中心属于重大基础设施投入信号，但投资额未公开。
  - 风险：AI Coding用户对价格和限额高度敏感，积分制若换算复杂可能影响体验；全部国产芯片部署有利于供应链安全，但也考验性能、稳定性和生态适配。
- 关键数据：GLM Coding Plan新版积分制于2026-07-30上线说明；团队套餐席位额度统一上调30%；团队标准版每周最多3.9亿tokens/席位，团队高级版每周最多10.4亿tokens/席位；智谱已落地1GW级国产AI算力数据中心建设，全部采用国产AI芯片（来源：[智谱官方文档，2026-07-30](https://docs.bigmodel.cn/cn/coding-plan/notice/usage-revision)；[经济观察网，2026-07-31](http://www.eeo.com.cn/2026/0731/980623.shtml)）。相关营收、订阅用户数未公开。
- 原文链接：[智谱文档｜老用户权益说明](https://docs.bigmodel.cn/cn/coding-plan/notice/usage-revision)；[经济观察网｜扩建算力数据中心后，智谱GLM Coding Plan开放订阅](http://www.eeo.com.cn/2026/0731/980623.shtml)；[IT之家｜智谱GLM Coding Plan订阅回归](https://www.ithome.com/0/983/934.htm)
- 影响判断：智谱本周的重点是把供给侧算力扩容转化为可售卖的AI Coding订阅。若国产芯片集群能支撑稳定低延迟服务，智谱将获得监管与供应链安全加分；但Coding订阅市场竞争激烈，价格、额度和模型体验仍会决定留存。

### 月之暗面 / Kimi
- 本周动态：月之暗面是本周最有资本与技术双重信号的公司。7月27日，第一财经报道月之暗面发布Kimi K3模型权重、技术报告，并开源支撑Kimi K3训练的关键Infra技术MoonEP、FlashKDA和AgentEnv；报道称Kimi K3是其能力最强模型，是拥有2.8万亿参数的混合专家（MoE）模型，具备原生视觉理解能力，并支持100万token上下文窗口。The Decoder同日英文报道也确认Moonshot AI发布Kimi K3权重和技术报告，并指出其同时开源高性能注意力内核、MoE通信库和大规模运行AI Agent的工具，公司宣称新架构单位算力智能产出提升2.5倍。7月29日，《科创板日报》独家称月之暗面Kimi完成F轮超35亿美元融资，投后估值升至350亿美元；因融资额超目标3倍多，本轮提前关闭，原定8月启动的G轮（Pre IPO轮）已提前开始，投前估值升至500亿美元。新浪科技转载时补充称，月之暗面方面未公开回应融资事宜，因此融资信息仍应视为权威媒体报道、非公司官宣。
- 企业维度分析：
  - 战略：Kimi以超大规模开放权重强化全球开发者和云推理生态，同时通过Kimi.com、Kimi Work、Kimi Code和API承接使用；开源模型在这里是公司分发、生态和算力效率叙事的一部分。
  - 产品/市场：2.8万亿参数、1M上下文、原生视觉理解和Agent基础设施，有助于吸引长程编程、知识工作、深度研究和企业自动化场景；API定价和缓存能力将影响商业化效率。
  - 资本/组织/人才：媒体称F轮融资超35亿美元、投后估值350亿美元，G轮/Pre-IPO提前启动，显示资本向中国头部模型公司集中；官方未回应，需继续跟踪工商/招股书/投资方确认。
  - 风险：超大模型推理成本和算力供给压力大；开放权重可能带来合规、安全和滥用风险；国际舆论中仍有蒸馏、网络安全能力等争议。
- 关键数据：Kimi K3参数规模2.8万亿、MoE架构、100万token上下文、原生视觉理解（来源：[第一财经，2026-07-27](https://www.yicai.com/news/103294204.html)；[Kimi官方技术博客，2026-07-16，背景，非本周](https://www.kimi.com/blog/kimi-k3)）；官方API价格为缓存命中输入0.30美元/MTok、缓存未命中输入3.00美元/MTok、输出15.00美元/MTok（来源：[Kimi官方技术博客，2026-07-16，背景，非本周](https://www.kimi.com/blog/kimi-k3)）；F轮超35亿美元、投后估值350亿美元、G轮投前估值500亿美元为媒体报道，非公司官宣（来源：[科创板日报，2026-07-29](https://www.cls.cn/detail/2440226)；[新浪科技，2026-07-29](https://finance.sina.com.cn/tech/it/2026-07-29/doc-iniknmic0034839.shtml)）。
- 原文链接：[第一财经｜月之暗面发布Kimi K3模型权重、技术报告](https://www.yicai.com/news/103294204.html)；[The Decoder｜Moonshot AI releases Kimi K3 open weights](https://the-decoder.com/moonshot-ai-releases-kimi-k3-open-weights-and-infrastructure-after-shaking-up-the-frontier-model-race/)；[科创板日报｜月之暗面Kimi完成F轮超35亿美元融资](https://www.cls.cn/detail/2440226)
- 影响判断：Kimi本周同时占据技术生态和资本市场注意力，显示中国头部模型公司正在以开放权重抢全球开发者、以巨额融资抢算力和人才窗口。短期最大约束是推理成本与监管风险；中期看，API、企业版和Kimi Work/Code能否形成收入闭环，将决定高估值能否被消化。

### MiniMax
- 本周动态：7月31日，MiniMax发布新一代多模态生成模型MiniMax H3，并宣布近期开放权重/开源。经济观察网援引北京商报报道称，H3是MiniMax从“特化任务模型”迈向“通用多模态智能”的重要探索，不再以图片、视频、声音的生成、编辑和参考等单一任务为边界，而是在多模态上下文中统一理解创作意图，完成更自然、连贯的生成与表达。模型支持文本、图片、音频、视频等多种输入形式，支持2K分辨率直出，可生成最长15秒的音画内容，具备商用级多场景内容生成能力，适用于广告、品牌、电商、产品设计、UI/UX、游戏等商业场景；报道还称其在Artificial Analysis视频模型榜单中视频编辑能力项排名全球第一。IT之家与新浪科技报道进一步补充，魔搭社区显示H3将于北京时间8月3日0点正式开源；模型可输出原生双声道音视频，最高支持15秒2K分辨率，2K分辨率下每秒价格不到主流模型的1/3，768P分辨率下是主流模型720P的1/2。每日经济新闻则称H3视频生成价格为0.8元/秒（2K分辨率），仅为业内同类旗舰视频模型的三分之一。
- 企业维度分析：
  - 战略：MiniMax以H3切入“商用级全模态生成”，通过低价和开放权重扩大开发者/产业生态，把模型能力导向广告、电商、游戏等可付费内容生产场景。
  - 产品/市场：15秒2K、原生双声道、视频编辑和动作迁移能力，直接面向营销视频、产品展示、短视频素材和游戏视觉资产；低价策略有利于抢占高频生成需求。
  - 资本/组织/人才：本周未公开新增融资或组织变化；作为已上市/资本市场关注公司，H3是其多模态商业化能力的重要展示。
  - 风险：视频生成模型算力成本高，低价策略可能牺牲毛利；开放权重会带来内容安全、版权、深伪和国产芯片适配执行压力。
- 关键数据：H3于2026-07-31发布；最高支持15秒2K分辨率、原生双声道音视频；2K分辨率每秒价格不到主流模型1/3、768P价格为主流模型720P的1/2（来源：[IT之家，2026-07-31](https://www.ithome.com/0/984/379.htm)；[新浪科技，2026-07-31](https://finance.sina.com.cn/tech/digi/2026-07-31/doc-iniktkaz4337287.shtml)）；H3视频生成价格0.8元/秒（2K分辨率）为媒体报道（来源：[每日经济新闻，2026-08-02](https://www.nbd.com.cn/articles/2026-08-02/4529677.html)）。
- 原文链接：[经济观察网｜MiniMax发布多模态生成模型MiniMax H3](http://www.eeo.com.cn/2026/0731/981299.shtml)；[IT之家｜MiniMax H3通用多模态视频模型将于8月3日开源](https://www.ithome.com/0/984/379.htm)；[每日经济新闻｜一周未来商业](https://www.nbd.com.cn/articles/2026-08-02/4529677.html)
- 影响判断：MiniMax本周用H3把竞争焦点从单一视频生成推进到全模态商用内容生产。低价和开放权重会加速生态扩散，但也把公司推入更激烈的视频模型价格战；能否把广告、电商、游戏客户转化为稳定收入，是后续关键。

## 本组洞察
1. **中国头部AI公司本周的关键词是“Agent商业化入口”**：阿里千问办公、腾讯WorkBuddy、字节飞书/豆包/火山整合、智谱GLM Coding Plan、DeepSeek V4-Flash API，均在争夺可执行任务与开发者工作流，而不是单纯聊天入口。
2. **视频与多模态成为价格战新战场**：字节Seedance 2.5强调30秒长视频和火山方舟API，MiniMax H3强调15秒2K、低至同类约1/3价格；短剧、广告、电商、游戏会成为最先付费的产业场景，但算力成本和版权/深伪治理会同步放大。
3. **国产算力适配从口号进入产品分发层**：华为openPangu绑定昇腾原生训练/推理，智谱披露1GW级国产AI算力数据中心，MiniMax提到开放权重推动国产芯片适配。模型公司和算力厂商正在通过开源权重、MaaS和订阅服务形成互相验证的生态。
4. **资本继续向头部集中，但估值验证压力上升**：Kimi媒体报道F轮超35亿美元、投后350亿美元，显示一级市场仍愿意押注头部模型；但推理成本、商业收入、监管与国际舆论风险会成为下一阶段估值能否成立的核心约束。
5. **静默并不等于落后，但公开节奏会影响市场心智**：百度本周无重大公开动态，千帆仍有搜索/知识/工具生态底座；在其他公司密集释放Agent和多模态进展时，百度需要用可量化的企业采用和C端活跃数据重新提高可见度。

## AI 应用与垂直头部企业

### Perplexity
- 本周动态：本周未发现可核验的重大公开动态。核验范围包括 Perplexity 官网 Hub/Blog、Discover 页面线索、Releasebot 对 Perplexity 发布记录的索引，以及以“Perplexity AI / funding / ARR / product / Comet / Projects”等关键词限定 2026-07-27 至 2026-08-02 的网页检索。检索中可见官网页面仍强调“AI answer engine”“实时网页研究”“多模型编排”“Answer Engine、Research、API、Comet Browser”等定位，但未抓到本周新增融资、ARR、客户、定价或组织变动的原始公告；搜索结果中出现的 ARR、估值统计多为二级统计页或时间窗外融资传闻，未作为本周动态采用。另检索到 Perplexity “Spaces are now Projects”页面线索，但原文抓取遇 403，未能核验发布时间与正文，因此不纳入有料动态。
- 企业维度分析：
  - 战略：本周无重大公开动态；可核验的背景定位仍是以可引用搜索、研究工作流和浏览器/ API 分发对抗通用聊天机器人，但本周未见新战略声明。
  - 产品/市场：本周无重大公开动态；官网可见产品线包括 Answer Engine、Research、API 与 Comet Browser等，但无本周新增可核验发布。
  - 资本/组织/人才：未公开；本周未发现可核验融资、估值、ARR、客户数或高管/人才变动。
  - 风险：AI 搜索赛道继续承受 Google、OpenAI、Anthropic 等通用入口挤压；若无新企业化/浏览器分发进展，增长叙事容易被旧估值数字主导。
- 关键数据：未公开（本周未发现可核验关键经营数字）。
- 原文链接：[Perplexity Hub](https://www.perplexity.ai/hub)；[Perplexity Discover](https://www.perplexity.ai/discover)
- 影响判断：本周可视为静默观察周。后续重点应继续盯 Comet Browser、Projects/Spaces、企业 API 与订阅转化是否披露真实使用与收入指标。

### Midjourney
- 本周动态：Midjourney 本周核心动态是 V8.2 图像模型进入公开使用后的市场发酵。官方更新页显示，Midjourney 于 2026-07-24 发布 V8.2（发布时间落在本周时间窗之前，背景，非本周），但本周内（7月27日-8月2日）围绕该默认模型的创作者评测、教程与商业讨论持续扩散。官方原文称 V8.2 聚焦 aesthetics、image quality 与 personalization，目标是让图像更“creative, bold, sophisticated, edgy and fresh”，并显著减少低质量随机输出；个性化系统会更好理解用户个人 taste，尤其是拥有大量评分记录的用户，创建 V8.2 个性化 profile 时也有更大、更优的候选图像池。对企业研究而言，这不是简单模型版本迭代，而是 Midjourney 继续用“审美质量 + 用户偏好数据”巩固付费创作社区护城河：其商业闭环依赖订阅用户不断评分、生成、沉淀偏好，再反哺模型个性化效果。本周未见融资、ARR、客户数或企业销售公告；Midjourney仍更像高毛利自助订阅型创意平台，而不是传统企业软件公司。
- 企业维度分析：
  - 战略：继续押注封闭式高审美模型与社区偏好数据，而非开源或通用 API 价格战；V8.2强化“默认模型”体验，有助于降低创作者迁移意愿。
  - 产品/市场：产品重点是图像质量、个性化 profile 与低质量输出减少，适配高频创作者、广告设计、概念视觉和社媒内容生产；本周未见官方企业客户或渠道合作披露。
  - 资本/组织/人才：融资、估值、ARR、员工数本周未公开；未发现本周高管/研究员变动。
  - 风险：版权与训练数据争议仍是长期风险；同时，若视频、多模态编辑或企业合规能力推进慢，可能被 Adobe、OpenAI、Google、Runway 等在商业工作流中分流。
- 关键数据：V8.2 发布日期 2026-07-24（官方更新页；背景，非本周）；本周 ARR/营收、客户数、融资、估值未公开。
- 原文链接：[Midjourney Version 8.2 官方更新](https://updates.midjourney.com/version-8-2)
- 影响判断：V8.2把 Midjourney 的竞争重点从“能生成图”进一步推向“懂个人审美并稳定产出高质量图”。短期利好订阅留存和高频创作者使用深度，但商业化透明度仍低。

### Runway
- 本周动态：Runway 本周有明确产品与企业化 API 动态。官方 API Changelog 显示，2026-07-30 起 Gen-3 Alpha Turbo（`gen3a_turbo`）和 Gen-4 Aleph（`gen4_aleph`）不再通过 Runway API 提供，调用这些模型标识会失败；官方建议从 Gen-3 Alpha Turbo 升级到 Gen-4.5（质量优先）或 Gen-4 Turbo（速度优先），从 Gen-4 Aleph 升级到 Aleph 2.0（`aleph2`）。同日，Runway API 接入 Eleven v3 文本转语音，按“每50字符1 credit、最低1 credit”计费；2026-07-28，企业计划组织可导出与 API 项目关联的 Runway web app workspace 的 per-generation credit usage 与 audit log history。这组更新说明 Runway 正从单点视频生成模型，转向多模态创意基础设施：一边淘汰旧模型、推动用户迁移到新定价/新能力栈，一边补齐企业采购最关心的使用量、审计、成本归因与治理能力。本周未见融资、估值、ARR或客户数新增披露。
- 企业维度分析：
  - 战略：通过 API 模型生命周期管理、路由、审计与计费透明度，把创意模型包装为可被企业和开发者长期集成的平台，而不是只服务网页端创作者。
  - 产品/市场：Gen-4 Aleph API 下线并迁移至 Aleph 2.0，说明视频编辑/生成能力持续迭代；Eleven v3 接入把音频纳入同一 API 账单体系，利于广告、影视、短视频工具链集成。
  - 资本/组织/人才：本周未公开融资、估值、ARR、客户数或重大组织变动。
  - 风险：模型下线会带来开发者迁移成本；视频生成领域竞争激烈，且成本、版权、品牌安全与内容审核要求高，企业客户会要求更强 SLA 和可解释审计。
- 关键数据：2026-07-30 Gen-3 Alpha Turbo 与 Gen-4 Aleph API 下线；Eleven v3 计费为每50字符1 credit、最低1 credit；2026-07-28 企业计划新增 per-generation credit usage 与 audit log export（均来自官方 API Changelog）。融资、估值、ARR未公开。
- 原文链接：[Runway API Changelog & Updates](https://docs.dev.runwayml.com/api-details/api_changelog/)
- 影响判断：Runway 的本周更新偏“商业化底座”而非营销发布。审计和用量导出能力会提升企业可采购性，但旧模型下线也考验生态兼容和客户迁移执行。

### Harvey
- 本周动态：Harvey 本周发布多篇法律 AI 产品/方法论内容，其中最具企业研究价值的是 2026-07-27《Scaling Document Processing Across Harvey》。官方披露，Harvey 的文档处理层支撑 Vault、Assistant 以及所有与客户自有数据交互的工作流；法律用户的查询经常涉及从单个文件到数百、数千份文档。文章给出罕见的规模数据：一年前繁忙周处理约94万份文档、1.44TB 原始文件数据；最近完整周处理2480万份文档、56TB数据，平均每天约350万份文档，文档量约26倍、数据量约39倍增长。增长来源从一次性上传转向客户把 Harvey 当作大型文档集合的中心系统，Vault 和 iManage、SharePoint、Box、Google Drive、NetDocuments、本地部署等连接器同步成为关键流量来源。技术上，Harvey 将抽取、切分/嵌入、索引拆成独立瓶颈系统，并在数据驻留、OCR、向量存储写入、失败隔离上做工程化升级。同期博客列表还显示 7月28-31日连续发布商标搜索、专利分析、法律研究工具对比、法学院大使等内容，说明 Harvey 正把垂直法律场景从“AI 助手”推向大规模文档基础设施与工作流平台。
- 企业维度分析：
  - 战略：从法律问答/起草工具升级为客户法律知识与文档系统的处理层，强化数据接入、检索、引用和端到端法律工作流护城河。
  - 产品/市场：Vault、Assistant、连接器与文档处理管线是商业闭环核心；规模数据表明客户正在把大量存量文档同步进 Harvey，而不只是临时上传少量材料。
  - 资本/组织/人才：本周未公开融资、估值、ARR；此前 Chicago office、Benchmark 等为背景，非本周；本周可见 Maude Tipton 法学院大使内容，偏生态/人才品牌而非高管变动。
  - 风险：法律数据高敏感，数据驻留、权限、错误引用、OCR/格式失败和审计责任都会放大；若平台成为系统 of record，可靠性与成本压力显著上升。
- 关键数据：2026-07-27 官方披露最近完整周处理2480万份文档、56TB数据，日均约350万份文档；一年前约94万份文档、1.44TB；文档量26x、数据量39x增长。融资、估值、ARR未公开。
- 原文链接：[Scaling Document Processing Across Harvey](https://www.harvey.ai/blog/scaling-document-processing-across-harvey)；[Harvey Blog 列表](https://www.harvey.ai/blog/all)
- 影响判断：Harvey 本周最重要信号是“规模化处理法律私有数据”的能力外显。它正在把法律 AI 的竞争从模型接入转向数据管线、连接器、可靠性和客户工作流深度，护城河更偏垂直基础设施。

### Sierra
- 本周动态：本周未发现 Sierra 在 2026-07-27 至 2026-08-02 期间发布新的重大融资、产品、客户或组织公告。核验范围包括 Sierra 官网 Blog、About、作者页，以及以“Sierra AI / Bret Taylor / funding / valuation / ARR / customer service AI / July 27 2026”等关键词进行限定时间检索。Sierra 官网 Blog 在本周时间窗内没有新增条目，最近的官方产品文章是 2026-07-16《The next Horizon in agents》（背景，非本周），官网 Blog 还展示 2026-02-06《Year two in review》（背景，非本周）披露公司进入第三年时 ARR 超过1.5亿美元、七个季度达到1亿美元 ARR、首个5000万美元季度、Fortune 20 adoption、客户包括 ADT、Cigna、DIRECTV、Gap、Hyvee、Ramp、Rivian、Safelite、Sutter Health 等。本周检索还出现二级文章引用 May 2026 Series E、估值等，但均非本周；因此本周按静默处理，不用旧融资凑数。
- 企业维度分析：
  - 战略：本周无重大公开动态；背景上，Sierra 仍围绕“jobs to be done”的企业客户体验代理，强调结果导向而非 AI tourism。
  - 产品/市场：本周无新增；背景数据显示其场景覆盖客服、销售、订阅、医疗、金融、零售等高交互行业，核心价值是把 AI agent 嵌入真实客户流程。
  - 资本/组织/人才：本周未公开；May 2026 的9.5亿美元融资、超150亿美元估值为背景，非本周；本周无新高管或并购公告。
  - 风险：结果付费与高自治 agent 要求稳定交付，若垂直流程失误会直接影响客户体验、合规和品牌信任；估值与增长预期也会放大执行压力。
- 关键数据：本周未公开。背景，非本周：Sierra 官网 2026-02-06 披露“over $150M in ARR”；May 2026 融资与估值数字为时间窗外，不作为本周动态。
- 原文链接：[Sierra Blog](https://sierra.ai/blog)；[Year two in review](https://sierra.ai/blog/year-two-in-review)
- 影响判断：Sierra 本周没有新增重大事件，但上一阶段披露的 ARR 与客户渗透仍说明其是企业 AI agent 商业化最强样本之一。后续应重点跟踪 Horizon、结果付费、国际扩张与大客户续约/扩容是否继续公开量化。

### Glean
- 本周动态：Glean 本周没有发现新的融资、ARR、客户数或组织变动公告，但官网持续推进 Glean:GO 2026（活动将在 2026-08-26 至 08-27 于旧金山 Fort Mason 举办，属未来事件预告）。本周可核验的公开页面显示，Glean 将该活动定位为企业 AI 从试验走向“next generation of AI in your enterprise”的蓝图，议程强调 keynote、deep-dive sessions、admin/builder/new user training、知识发现、agentic productivity、治理和企业采用。官网首页同时强调“Work AI that understands your company”，连接 Slack、Google Drive、Jira、Confluence、SharePoint、GitHub、Salesforce 等企业系统，并以“company knowledge into action without runaway model spend”为价值主张，突出权限、可观测性、治理和 token 成本控制。公开客户 logo/案例包括 Rivian、Samsung、Vanta、Wealthsimple、Intercom、SeatGeek、Webflow、BetterUp、Zillow、Motive、Intuit、Zapier、Booking.com、Canva、Reddit、Databricks、Pinterest、Rubrik；首页还披露 YTD token savings、35+ LLM、token usage reduction、每用户年节省时间、ROI周期等营销指标。由于这些多为官网持续页面和未来活动预热，本周按“无重大新增经营事件”处理，但仍记录其企业市场定位变化。
- 企业维度分析：
  - 战略：从企业搜索延伸到 Work AI / enterprise context / agent 平台，核心棋局是成为企业内部知识、权限与工具上下文层，帮助企业降低模型调用成本。
  - 产品/市场：产品卖点包括预连接企业上下文、权限感知、可观测性、治理、跨模型支持和 agent library；客户案例覆盖互联网、汽车、金融、媒体、通信等大型企业。
  - 资本/组织/人才：本周未公开融资、估值、ARR或高管变动；Glean:GO 议程和演讲嘉宾体现其生态经营，但不是资本事件。
  - 风险：企业搜索/Work AI 赛道与 Microsoft Copilot、Google Workspace、ServiceNow、Moveworks、Coveo 等竞争重叠；若成本节省或采用率指标不能转化为续费扩容，平台叙事会承压。
- 关键数据：官网披露 Average token savings YTD 12,442,032,540；支持35+ Unique LLMs；相较 off-the-shelf MCP tools token usage reduction 30%；110 hours saved per user/year；20% fewer internal support tickets；93% enterprise adoption in <2 years；<6 months to ROI（官网首页，抓取于本周后核验）。本周融资、估值、ARR未公开。
- 原文链接：[Glean 官网](https://www.glean.com)；[Glean:GO 2026](https://www.glean.com/events/glean-go-2026)
- 影响判断：Glean 的本周信号是“企业 AI 成本与治理”叙事继续强化。它的护城河不在单个 LLM，而在企业上下文、连接器、权限与组织采用；但必须持续证明可量化 ROI。

### Databricks
- 本周动态：Databricks 本周没有在公司官网直接发布新的融资公告，但有两条与企业 AI 商业化相关的公开动态需记录。第一，Microsoft 与 Databricks 于 2026-07-23 宣布扩大十年战略合作、延伸至2030年代（背景，非本周），本周 7月29日多家媒体继续解读其意义：Databricks 将更深使用 Azure Databricks 跑核心业务和统一 lakehouse，并利用 Azure Cobalt Arm 基础设施提升性能；Microsoft 将把 Databricks Data + AI Platform 的能力（如 Genie、Unity AI Gateway）更深集成到 Microsoft 365、Teams、Copilot、Power BI、Purview、Foundry 等企业栈。第二，Databricks 的 Context Engineer Associate beta exam 首考于 2026-07-29 举行；官方博客（7月16日，背景，非本周）将其定位为行业首个专门验证 context engineering 技能的认证，围绕 agentic AI 的可靠上下文、RAG agent、agent evaluation 与 AI-first 认证备考。融资方面，本周检索到 MarketScale/Reuters/Bloomberg 等引用的 7月17日 $3B、$188B 估值报道（背景，非本周），不能作为本周融资事件，但可作为资本背景。
- 企业维度分析：
  - 战略：Databricks 正把 Lakehouse、Unity Catalog/Unity AI Gateway、Genie 与 Microsoft 分发栈绑定，目标是成为企业“数据+AI+业务上下文”的治理与执行平台。
  - 产品/市场：与 Microsoft 的集成把 Databricks 能力嵌入日常办公与 BI 流程；Context Engineer 认证说明 Databricks 正通过人才认证建立平台标准和生态锁定。
  - 资本/组织/人才：本周未公开新融资；背景，非本周：7月17日市场报道其拟/已进行约30亿美元融资、估值1880亿美元；本周无高管变动。
  - 风险：高估值要求持续高增长；与 Microsoft 深度绑定提升分发但也带来云平台依赖，且 Snowflake、Microsoft Fabric、Google、AWS 在企业数据 AI 入口竞争激烈。
- 关键数据：2026-07-29 Databricks Context Engineer Associate beta exam 首考；Microsoft/Databricks 合作延伸至2030年代（官方 2026-07-23，背景，非本周）；背景，非本周：MarketScale 7月17日报道约30亿美元融资、1880亿美元估值，尚非本周事件。ARR/营收本周未公开。
- 原文链接：[Microsoft Source：Databricks and Microsoft expand partnership](https://news.microsoft.com/source/2026/07/23/databricks-and-microsoft-expand-partnership-to-help-enterprises-bring-business-context-to-enterprise-ai)；[Databricks Context Engineer Certification Blog](https://www.databricks.com/blog/skills-gap-behind-agentic-ai-and-how-databricks-closing-it-new-context-engineer-certification)
- 影响判断：Databricks 的本周看点不是单一融资，而是“企业 AI 上下文层”标准化：一手绑定 Microsoft 工作流入口，一手用认证教育市场。它的护城河正在从数据平台扩展到 agent 治理和人才生态。

### Cohere
- 本周动态：Cohere 是本周有料公司之一，动作集中在企业工作流、公部门渠道和欧洲合规三条线。2026-07-27，Cohere 发布 North Automations，称其目标是弥合企业 AI ROI gap：企业中孤立 agent 只能解决窄任务、缺乏统一治理、且在工作流每一步都使用同一模型会导致成本膨胀；North Automations 允许员工用自然语言描述目标、连接技术栈、设定计划运行、使用循环/分支形成可审计执行路径，并在每一步选择合适模型以平衡成本和性能，配套 Plan mode、版本控制、沙盒测试、审批、用量分析、token 成本监控和细粒度权限。官方还称 North 可部署在任意本地或云环境，支持一方集成、客户 MCP、自有 SDK、Cohere 模型或外部 LLM。2026-07-30，Cohere 与 Carahsoft 宣布合作，由 Carahsoft 担任美国公共部门分销商，通过 SEWP V、ITES-SW2、NASPO ValuePoint、TIPS、OMNIA 等合同载体向政府机构提供 Cohere 模型与 North；公告强调 FedRAMP High 授权（通过 Second Front Systems）、全隔离/本地部署、zero data egress、多模态/多语言模型，以及混合云、机密环境和战术边缘部署。2026-07-31，Cohere 宣布签署 EU Code of Practice on Transparency of AI-Generated Content，称其签署 Section 1，面向 AI system providers，服务 EU AI Act Article 50 透明度要求。
- 企业维度分析：
  - 战略：Cohere 从“企业模型供应商”升级为 sovereign AI + agentic workflow 平台，重点押注受监管企业和公共部门，而非消费者通用助手。
  - 产品/市场：North Automations 强调自然语言工作流、模型路由、治理、审批、token 成本管理；Carahsoft 合作打开美国政府采购渠道，欧洲签署透明度 Code 强化合规销售话术。
  - 资本/组织/人才：本周未公开新融资或估值；Carahsoft 公告背景介绍 Cohere 已累计融资约16亿美元，投资方包括 Nvidia、AMD Ventures、Salesforce Ventures、Oracle、Cisco、Radical Ventures 等。
  - 风险：公共部门销售周期长、合规承诺重；North 若要成为工作流编排层，需要与 Microsoft、ServiceNow、Palantir、Databricks 等平台竞争，并证明 ROI 超过集成成本。
- 关键数据：2026-07-27 North Automations 上线且“available today to all North customers”；2026-07-30 Carahsoft 成为公共部门分销商，合同载体包括 SEWP V、ITES-SW2、NASPO ValuePoint、TIPS、OMNIA；Cohere 累计融资约16亿美元（Carahsoft/GlobeNewswire 公告，2026-07-30）；2026-07-31 签署 EU AI-generated content transparency Code。ARR/营收未公开。
- 原文链接：[Introducing North Automations](https://cohere.com/blog/introducing-north-automations-ai-workflows)；[Carahsoft-Cohere 公共部门合作](https://www.carahsoft.com/news/cohere-and-carahsoft-partner-to-bring-secure-sovereign-ai-deployment-solutions-to-the-public-sector-2026)；[EU Code of Practice](https://cohere.com/blog/cohere-signs-eu-code-of-practice)
- 影响判断：Cohere 本周把“安全、主权、可控”从品牌定位落到渠道和产品功能：North Automations 解决企业 ROI 与治理，Carahsoft 解决政府采购路径，EU Code 解决监管可信度。这是典型企业 AI 商业化闭环动作。

### Mistral AI
- 本周动态：本周未发现 Mistral AI 在 2026-07-27 至 2026-08-02 发布新的重大官方产品、融资或组织公告；官网 News 最新条目集中在 7月上旬，如 Robostral Navigate（7月8日）、Studio prompts/skills system of record（7月9日）等，均为背景，非本周。时间窗内围绕 Mistral 的主要公开信息仍是 7月22日 Samsung 投资谈判与 Microsoft 基础设施合作报道的延续（背景，非本周）：Reuters/FT 转述称 Samsung 讨论向 Mistral 投资最高约10亿欧元，潜在估值约200亿欧元；微软 7月21日也与 Mistral 扩展欧洲计算基础设施与分发合作。由于这些均发生在本周前，不作为本周动态。值得注意的是，Mistral 官网 News 页显示其产品线已从 Le Chat、La Plateforme 拓展到 Studio、Vibe、Forge、Compute、Mistral for finance/public institutions/manufacturing/energy 等，说明其商业叙事继续围绕欧洲/主权 AI、企业生产化与垂直行业展开，但本周未见新增关键数字。
- 企业维度分析：
  - 战略：本周无重大公开动态；背景上，Mistral 继续以欧洲主权 AI、开放/可部署模型与企业平台组合对抗美国闭源模型巨头。
  - 产品/市场：官网产品矩阵覆盖 Le Chat、Vibe、Studio、Forge、Compute、文档智能、语音、行业方案；本周无新发布可核验。
  - 资本/组织/人才：本周未公开；背景，非本周：7月22日报道 Samsung 可能投资最高约10亿欧元、估值约200亿欧元，Reuters称无法独立核验且 Mistral/Samsung未回应。
  - 风险：模型训练与欧洲基础设施投入极重；若融资谈判未落地或商业收入增长不足，主权 AI 叙事可能难以支撑高估值；同时欧盟监管合规要求持续提高。
- 关键数据：本周未公开。背景，非本周：Samsung 投资谈判最高约10亿欧元、潜在估值约200亿欧元（Reuters/FT 转述，2026-07-22）；本周 ARR/营收、客户数未公开。
- 原文链接：[Mistral Latest news](https://mistral.ai/news/)；[Reuters sitemap: Samsung in talks to invest in Mistral](https://www.reuters.com/sitemap/2026-07/22/1)
- 影响判断：Mistral 本周是静默观察周。其价值主线仍在“欧洲主权 AI + 企业生产化平台 + 大额战略资本”，但需要等待融资成交、云/硬件合作或企业收入数字进一步坐实。

### Scale AI
- 本周动态：Scale AI 本周出现重大组织变化。2026-07-30，Scale 官方宣布董事会任命 Francis deSouza 为 CEO，2026-08-10 生效；Jason Droege 自 2025年6月起担任 interim CEO，将在未来数月协助过渡。公告称任命发生在 Scale 动能加速之际，数据与应用两大业务均有客户增长，近期新增企业客户包括 BP 和 Mayo Clinic，并扩大了美国及国际政府业务。Alexandr Wang（Scale 创始人兼董事会主席）称 deSouza 曾领导和扩展复杂技术业务，理解如何以最高信任和可靠性服务企业和政府。deSouza 近期曾任 Google Cloud COO 与 Security Products President，见证企业和政府大规模部署 AI 应用；此前任 Illumina CEO，将其收入提升至超过45亿美元、覆盖150多个国家；更早还在 Symantec 和创业公司任职。公告还重申 Scale 定位为 AI applications and data infrastructure company，服务 frontier AI labs、U.S. Department of War、Fortune 500，数据引擎支撑前沿模型开发，Generative AI Platform 支撑政府和全球企业 mission-critical AI 项目。这是 Meta 入股/创始人转向 Meta 之后，Scale 对外重塑领导力与企业/政府可信度的关键一步。
- 企业维度分析：
  - 战略：从数据标注/模型数据层进一步转向“可靠 AI 应用与数据基础设施”，通过引入成熟企业技术 CEO 强化政府、医疗、能源等高信任行业销售。
  - 产品/市场：近期客户 BP、Mayo Clinic 和政府扩展说明 Scale 正强调企业应用与公共部门；Generative AI Platform 与数据引擎共同服务模型训练、评测、部署。
  - 资本/组织/人才：核心动态是 CEO 任命；Francis deSouza 8月10日生效，Jason Droege 过渡；Alexandr Wang仍为创始人兼董事会主席。融资/估值/ARR本周未公开。
  - 风险：Meta 交易后客户中立性与大模型客户流失风险仍在；新 CEO 要在创始人光环减弱、数据业务竞争加剧、政府业务合规压力上同时稳住增长。
- 关键数据：2026-07-30 宣布 Francis deSouza 任 CEO，2026-08-10 生效；deSouza 在 Illumina 任内收入扩至超过45亿美元、业务覆盖150+国家（Scale 官方公告）；近期新增企业客户 BP、Mayo Clinic；本周融资、估值、ARR未公开。
- 原文链接：[Scale AI Appoints Francis deSouza as CEO](https://scale.com/blog/scale-appoints-new-ceo)
- 影响判断：Scale 本周的 CEO 更替是公司从创始人/Meta 交易叙事转向“可信企业与政府 AI 基础设施”的信号。deSouza 的生命科学、云安全和大型企业经验有助于打开高合规行业，但也意味着 Scale 必须用可交付的企业应用收入证明转型。

### Anysphere / Cursor
- 本周动态：Anysphere/Cursor 本周有明确商业化动作：2026-07-28，Cursor 发布 Cursor Start，这是面向印度开发者的新月付计划，定价 ₹649/月，税费包含在内，以 INR 计费，支持 UPI 或银行卡，旨在用本地价格和本地支付降低印度开发者使用 agentic development 的门槛。官方说明现有印度 Free 用户可从 dashboard 升级，新用户可在注册时选择 Start；计划包含较充足的 Cursor 模型访问（Grok 4.5 fixed medium effort non-fast、Composer non-fast）、always-on cloud agents（可在用户继续工作时构建、测试、交付代码）、Cursor for iOS remote control、以及 plugins、MCP servers、hooks、skills 等工作流扩展。对企业研究而言，这不是 IDE 细节，而是 Cursor 在高增长开发者市场做价格本地化与支付本地化：印度拥有庞大开发者群体，本地低价订阅可扩大付费漏斗，并训练用户在移动端、云 agent、插件生态中形成日常依赖。同期 status 页面显示 7月27-30日存在 cloud agents、IDE、模型推理等服务降级调查，说明高增长下稳定性仍是商业化风险。本周未发现新融资或 ARR 官方披露；搜索到的 $2B ARR、$50B/$60B估值等为二级报道/传闻，未纳入关键数据。
- 企业维度分析：
  - 战略：从高端开发者订阅向全球本地化扩张，印度 Start 计划体现“价格分层 + 本地支付 + 云 agent 习惯养成”的增长策略。
  - 产品/市场：Start 将模型、云 agent、iOS remote control、插件/MCP/hooks/skills 打包成入门付费层，利于提升印度自助付费转化和团队渗透。
  - 资本/组织/人才：本周未公开新融资、估值、ARR、员工数或高管变动；外部估值/ARR传闻未采用为本周关键数据。
  - 风险：本周 status 记录多次服务降级，说明 agent/cloud 推理稳定性是付费体验关键；同时依赖外部模型供应、GitHub Copilot、Cognition/Devin、Windsurf 等竞争持续挤压。
- 关键数据：Cursor Start 2026-07-28 起在印度可用；价格 ₹649/月，税费包含，INR 计费，支持 UPI 或 card；本周融资、估值、ARR未公开。
- 原文链接：[Cursor Start Changelog](https://cursor.com/changelog/cursor-start)；[Cursor Status](https://status.cursor.com)
- 影响判断：Cursor 本周用本地化价格切印度，是 AI 编程工具从“硅谷高 ARPU”走向全球开发者规模化的典型动作。若稳定性跟上，低价入口可扩大生态；若 cloud agent 频繁降级，则会削弱付费留存。

### Cognition / Devin / Windsurf
- 本周动态：本周未发现 Cognition 在 2026-07-27 至 2026-08-02 期间发布重大公司级融资、客户或组织公告。核验范围包括 Cognition 官方博客、Windsurf/Devin 关键词搜索、公司名+本周日期检索。官方可读的最近关键技术发布是 2026-07-08《SWE-1.7: Frontier Intelligence at a Fraction of the Cost》（背景，非本周），发布 SWE-1.7 模型，称其是 Cognition 迄今训练的最强模型，以更低成本达到 frontier-level intelligence，优化长周期异步软件工程任务，并在 Devin Web、Desktop、CLI 中通过 Cerebras 以 1000 TPS 提供。基准方面，官方给出 FrontierCode 1.1 Main 42.3%、Terminal-Bench 2.1 81.5%、SWE-Bench Multilingual 77.8%。另 2026-02-27 官方文章（背景，非本周）披露 Cognition 内部“用 Devin 构建 Devin”，一周合并659个 Devin PR，高于2025年最佳周154个，展示 Devin 在 Slack、Linear、CLI、API、PR review、bug triage、数据分析 agent、DeepWiki、Playbooks、MCP Marketplace 等内部工作流中的使用。本周搜索中还出现 Windsurf 收购与估值文章，但多为 2025 或二级回顾，非本周。
- 企业维度分析：
  - 战略：本周无重大公开动态；背景上，Cognition 继续把 Devin 定位为云端异步软件工程 agent，并通过 Windsurf/desktop/CLI 等入口扩展开发者监督与交付闭环。
  - 产品/市场：SWE-1.7 背景发布强调成本-性能与长周期任务；“Devin build Devin”案例展示内部 dogfooding 和从写代码扩展到 code review、数据分析、bug triage 的企业工作流。
  - 资本/组织/人才：本周未公开；Windsurf 相关收购与融资信息均为时间窗外或二级回顾，不作为本周动态。
  - 风险： autonomous coding agent 必须证明稳定、可审计、可控；与 Cursor、本地 IDE agent、Claude Code/Codex 等竞争加剧，且若模型成本高于开发者愿付价格，毛利会承压。
- 关键数据：本周未公开。背景，非本周：SWE-1.7 于2026-07-08发布，FrontierCode 1.1 Main 42.3%、Terminal-Bench 2.1 81.5%、SWE-Bench Multilingual 77.8%，Devin 通过 Cerebras 提供1000 TPS；2026-02-27披露一周合并659个 Devin PR。
- 原文链接：[SWE-1.7](https://cognition.com/blog/swe-1-7)；[How Cognition Uses Devin to Build Devin](https://cognition.com/blog/how-cognition-uses-devin-to-build-devin)
- 影响判断：Cognition 本周静默，但其近期技术叙事显示重点是把 Devin 从“演示型 agent”推向公司内部可复用生产力系统。下一步需要关注企业客户、ARR、Windsurf 整合进展和真实节省工时/交付质量指标。

## 本组洞察
1. **企业 AI 的竞争从“模型能力”转向“可采购、可治理、可核算”。** Cohere 的 North Automations、Runway 的企业用量/审计导出、Glean 的 token savings 与权限治理、Databricks 的 Unity AI Gateway/Context Engineer 认证，都指向同一趋势：客户不再只买更强模型，而是买能进入生产环境、能解释成本、能审计权限、能持续运营的系统。
2. **垂直头部企业开始用“真实工作流数据”构筑护城河。** Harvey 披露每周2480万份文档处理量，Sierra 背景中强调高价值客户交互，Scale 转向可靠 AI 应用与政府/企业任务，Cognition 背景中用 Devin 处理 PR、bug triage、数据分析。这些公司最重要资产不是单一模型，而是高频、专有、复杂的业务流程数据与执行反馈。
3. **渠道和合规成为商业化加速器。** Cohere 通过 Carahsoft 切入美国公共部门采购合同，并签 EU 透明度 Code；Scale 引入有 Google Cloud/Illumina 背景的新 CEO；Glean 用大型企业客户与合规资质强化信任。AI 应用公司要进入大客户预算，必须把产品、销售、合规、组织资历一起打包。
4. **开发者/创作者工具进入价格分层与全球化阶段。** Cursor Start 的印度本地化定价说明头部 AI 编程工具开始下探全球开发者市场；Midjourney 则继续通过高审美默认模型与个性化数据强化付费创作者留存。增长不只来自模型升级，也来自定价、支付、社区和用户偏好数据的复合设计。
5. **本周静默公司较多，但静默不等于弱势。** Perplexity、Sierra、Mistral、Cognition 本周缺乏重大新增公开动态；其中 Sierra/Mistral/Cognition 的关键叙事主要来自时间窗外背景。周报中严格不以旧闻凑数，有助于区分“真实本周增量”和“长期公司基本面”。

## AI 算力、云、硬件与具身企业

### NVIDIA
- 本周动态：NVIDIA在7月27日发布与Ilya Sutskever创办的Safe Superintelligence Inc.（SSI）的长期战略合作。原文明确写到，NVIDIA不仅投资SSI，还将让SSI获得下一代NVIDIA Vera Rubin平台，使SSI算力“提升一个数量级”；双方还会围绕当前和未来计算平台做技术协作，把SSI对未来AI的研究洞察反馈给NVIDIA平台演进。这条动态对D组最重要的信号不是“又投了一家模型公司”，而是NVIDIA在供应紧张的前沿算力中以股权/战略合作方式锁定超高质量需求方，并用Vera Rubin作为下一代平台的标杆客户与共同优化对象。7月29日，NVIDIA还公告将于8月26日召开FY2027二季度业绩电话会，披露截至7月26日季度业绩；这不是业务结果，但说明本周进入硬件供需与订单数据等待期。7月28日Jetson博客偏开发者营销，未见重大订单或供应链数据。整体看，本周NVIDIA的“有料”核心是：Rubin平台从路线图进入高端客户承诺与生态共研阶段，算力供给被进一步金融化、战略化分配。
- 企业维度分析：
  - 战略：通过对SSI投资+长期合作，把下一代Vera Rubin平台绑定到最稀缺的前沿研究负载，强化“硬件路线—模型需求—系统优化”的闭环，而不只是卖GPU。
  - 产品/市场：Vera Rubin被定位为下一代顶级AI计算平台；SSI使用场景是极大规模前沿训练/研究，能为NVIDIA验证Rubin在真实极端负载下的性能、稳定性与软件栈适配。
  - 资本/组织/人才：投资金额未公开；合作对象由Ilya Sutskever和Daniel Levy领导，SSI既有a16z、DST、Greenoaks、Sequoia等投资人。NVIDIA本周未披露相关招聘或组织调整。
  - 风险：Rubin供给若优先分配给少数头部实验室，可能加剧云客户和二线模型公司的取得难度；合作也有技术兑现风险，且前沿AI安全、出口管制与集中算力监管仍是外部不确定性。
- 关键数据：SSI可通过NVIDIA Vera Rubin平台将算力提升“一个数量级”（NVIDIA新闻稿，2026-07-27）；投资金额、具体GPU/机柜数、订单金额未公开。NVIDIA FY2027 Q2业绩电话会定于2026-08-26，季度截至2026-07-26（NVIDIA新闻稿，2026-07-29）。
- 原文链接：[Ilya Sutskever’s Safe Superintelligence Inc. and NVIDIA Announce Long-Term Strategic Partnership](https://nvidianews.nvidia.com/news/ilya-sutskevers-safe-superintelligence-inc-and-nvidia-announce-long-term-strategic-partnership)；[NVIDIA News Archive](https://nvidianews.nvidia.com/news)
- 影响判断：这强化了NVIDIA在下一代AI工厂中的“准基础设施分配者”角色：不是被动供应商，而是通过投资和平台共研选择未来大客户。对竞争者而言，Rubin生态若在SSI等前沿客户处率先优化，会进一步提高追赶门槛。

### AMD
- 本周动态：本周在AMD官网投资者新闻稿页与公司新闻页核验后，未发现2026-07-27至2026-08-02期间发布的AI数据中心GPU、云合同、重大客户、资本开支、并购或组织人才类公开动态。AMD投资者新闻稿页可见的最近条目停留在7月23日、7月22日、7月20日等，均早于本周窗口；这些可作为背景但不能纳入本周动态。因此本周对AMD的结论是“本周无重大公开动态”。考虑到AMD通常通过财报、客户联合新闻稿或产品发布会披露MI系列GPU、EPYC/Instinct平台与AI PC/边缘AI进展，本次核验范围覆盖AMD官网新闻稿、投资者新闻稿以及本周关键词检索；由于搜索API出现限流，后续采用官网/IR直访降级核验。
- 企业维度分析：
  - 战略：本周未有新战略披露；背景，非本周：AMD的AI竞争核心仍是Instinct GPU路线、开放软件生态和云厂/模型客户导入。
  - 产品/市场：本周未披露新增MI系列订单、AI云实例或客户采用数据。
  - 资本/组织/人才：本周未公开重大融资、并购、回购变化或高管/研究员流动。
  - 风险：静默本身不代表业务停滞，但在NVIDIA继续通过Rubin绑定前沿客户的同周，AMD若缺少可验证的大客户与软件性能进展披露，资本市场叙事容易继续承压。
- 关键数据：本周未公开新增订单、营收、客户数、CapEx或芯片关键数据。
- 原文链接：[AMD Investor Relations - Press Releases](https://ir.amd.com/news-events/press-releases)；[AMD Press Releases](https://www.amd.com/en/newsroom/press-releases.html)
- 影响判断：AMD本周属于静默公司。周报中不应用旧的MI系列发布或财报数字“凑数”；后续重点等待下一次财报/云厂实例公告是否给出AI GPU收入、供应和客户转化的硬数据。

### Broadcom
- 本周动态：本周在Broadcom投资者RSS新闻稿、官网投资者中心和关键词检索中，未发现2026-07-27至2026-08-02期间关于AI网络、定制AI加速器、云/数据中心客户订单、财报或组织资本动作的新公告。Broadcom RSS中最近的公司新闻是7月16日Standard Chartered选择VMware Cloud Foundation，早于本周；更早还有6月24日OpenAI与Broadcom发布LLM优化处理器、6月9日AI部署平台等，均为背景，非本周。因此本周按静默处理，不把6月的OpenAI ASIC或AI基础设施融资平台旧闻写成本周动态。
- 企业维度分析：
  - 战略：本周无新披露；背景，非本周：Broadcom在AI中的核心位置仍是定制加速器、以太网/交换芯片、VMware私有云基础设施。
  - 产品/市场：本周未披露新增AI ASIC量产客户、网络芯片路线、交换机订单或AI云客户扩展。
  - 资本/组织/人才：本周未公开融资、并购、债务、分红或高管/人才变动。
  - 风险：静默期内外部市场仍会围绕AI ASIC客户集中度、云厂自研芯片节奏、VMware整合与私有云需求弹性定价；但本周缺少可核验新增事实。
- 关键数据：本周未公开新增订单、营收、CapEx、客户数或硬件关键数据。
- 原文链接：[Broadcom News Releases RSS](https://investors.broadcom.com/rss/news-releases.xml)；[Broadcom Investor Center](https://investors.broadcom.com/)
- 影响判断：Broadcom本周不应被旧闻放大。后续需要重点等待其下一次财报或客户联合公告，验证AI ASIC与网络芯片增长是否继续从少数超大客户扩散到更多云厂/企业AI工厂。

### CoreWeave
- 本周动态：CoreWeave本周（7月31日发布）重点不是新融资或大客户合同，而是把“AI工厂从GPU采购变为全栈验证生命周期”的商业叙事进一步产品化。其博客《Why AI Factories Need Proof Before Production》明确写到，真实AI工作负载要验证计算、网络、存储、调度、恢复能否连续两周稳定运行；NVIDIA与CoreWeave从设计、建站、验证到上线共同优化，目标是让生产表现与验证表现一致。文章回顾1月双方扩展合作，在CoreWeave上部署NVIDIA DSX/Vera Rubin平台；并引用CoreWeave此前性能数据：Vera Rubin NVL72在DeepSeek R1同负载上，相比GB200 NVL72达到10倍tokens-per-second per megawatt。它还披露CoreWeave ARENA作为生产规模验证实验室，客户可以在部署前测试训练、推理和Agent流水线的性能与成本；MLPerf Training v6.0中CoreWeave在8,192块Blackwell Ultra GPU上用约2.02分钟完成DeepSeek-V3 671B训练基准。该文虽是博客，但对CoreWeave商业化有明确意义：把“拿到NVIDIA最新硬件”转化为“可被客户购买的确定性、验证和运维能力”。
- 企业维度分析：
  - 战略：从AI GPU云转向“AI工厂运营商/验证商”，通过与NVIDIA DSX、Exemplar Cloud、ARENA绑定，把硬件先发优势沉淀为可销售的工程确定性。
  - 产品/市场：产品侧强调CKS、SUNK、AI Object Storage with LOTA、Mission Control、ARENA等组合；市场侧瞄准模型公司、企业AI训练/推理和Agent生产负载，突出部署前验证与TCO可预估。
  - 资本/组织/人才：本周未披露融资、估值、并购或高管流动；但工程组织能力被包装成商业卖点，尤其是与NVIDIA联合bring-up和验证团队。
  - 风险：博客披露的大量性能/验证数据来自公司自有材料，需要客户案例和第三方持续验证；AI工厂资本密集，若客户需求或电力/冷却/供应链约束变化，回收周期会拉长。
- 关键数据：Vera Rubin NVL72相对GB200 NVL72在DeepSeek R1同负载上“10x tokens-per-second per megawatt”（CoreWeave博客引用此前7月23日测试，背景，非本周；7月31日再次引用）；MLPerf Training v6.0：8,192块Blackwell Ultra GPU、DeepSeek-V3 671B约2.02分钟（CoreWeave，2026-07-31）；Exemplar Cloud训练验证曾使用576块Blackwell GPU（CoreWeave，2026-07-31）。本周未披露新订单金额或营收。
- 原文链接：[Why AI Factories Need Proof Before Production](https://www.coreweave.com/blog/why-ai-factories-need-proof-before-production)；[CoreWeave Blog Archive](https://www.coreweave.com/blog)
- 影响判断：CoreWeave本周用工程验证叙事强化差异化：AI云竞争不只是GPU数量，而是客户能否把昂贵算力稳定转化为tokens和模型进度。若ARENA/Exemplar路径被更多客户采用，CoreWeave可在与AWS/Azure/GCP竞争时获得“高端AI工厂运营”溢价。

### Oracle Cloud
- 本周动态：Oracle本周7月28日发布Project Jupiter更新，披露其新墨西哥Doña Ana County数据中心项目已带来近8,000万美元税收，并预计通过税收、投资和商业活动为州和县带来超过47亿美元长期经济影响。原文给出多项基础设施与社区数据：项目已兑现其5,000万美元当地水务基础设施承诺的80%，剩余资金预计下月到位；2026年1-5月为Doña Ana County产生1,000万美元税收、为新墨西哥州产生2,990万美元税收；截至公告时近700名本地居民在现场工作，未来建设期预计创造7,000多个施工岗位，完工后支持1,500个长期岗位。对AI云研究而言，Project Jupiter的重点是Oracle Cloud Infrastructure围绕AI数据中心的“电力/水/社区许可”能力。本周公告还重申Bloom Energy燃料电池现场微电网将替代原计划燃气轮机和柴油发电机，氮氧化物排放预计降低约92%，冷却和燃料电池运行不使用饮用水；7月1日补充博客披露电力资源规模“超过2GW”，由Oracle支付能源基础设施和电费。
- 企业维度分析：
  - 战略：OCI继续以超大AI数据中心和低延迟云基础设施追赶头部云厂；Project Jupiter显示其战略重点已从“拿GPU/客户合同”延伸到能源、水资源、税收与社区许可的全栈落地。
  - 产品/市场：虽未披露具体AI客户或GPU数量，但该项目显然服务于OCI大规模云容量扩张，尤其是AI训练/推理基础设施。Oracle用税收、就业、水务和低排放方案争取地方接受度。
  - 资本/组织/人才：项目预计长期经济影响超47亿美元；建设期税收约6亿美元、运营期17年税收约6.8亿美元、IRB每年向县和学校支付1,200万美元、30年合计3.6亿美元。未披露Oracle自身CapEx会计口径或客户合同金额。
  - 风险：项目承诺明确受空气许可和管道审批影响；数据中心在水、电、排放和居民信任上仍有执行与监管风险。燃料电池当前仍使用天然气，低碳叙事需长期能源匹配兑现。
- 关键数据：长期经济影响超过47亿美元（Oracle，2026-07-28）；已产生近8,000万美元税收、县1,000万美元、州2,990万美元（2026年1-5月）；水务承诺5,000万美元已兑现80%；建设岗位预计7,000+、运营期支持1,500个岗位；运营期县税收超1,000万美元/年、州税收超3,000万美元/年、17年合计6.8亿美元；NOx预计降低约92%；电力资源超过2GW（Oracle，2026-07-01，背景，非本周）。
- 原文链接：[Project Jupiter Will Bring More Than $4.7 Billion to New Mexico and Hundreds of Jobs for State Residents](https://www.oracle.com/news/announcement/project-jupiter-2026-07-28/)；[We’ve Overhauled Project Jupiter’s Power Plan](https://www.oracle.com/news/announcement/blog/weve-overhauled-project-jupiters-power-plan-2026-07-01/)
- 影响判断：Oracle本周把AI云竞争的焦点拉到“算力项目能不能被地方批准并持续供电供水”。对OCI而言，地方许可、微电网和社区收益叙事可能成为其承接大模型客户合同的关键非芯片能力。

### Google Cloud
- 本周动态：Google Cloud本周公司博客“News in short”在7月27-31日更新中，只有面向8月12日墨西哥城Data Cloud/Apigee AI Agent活动和Vast Edge基于GCP的备份恢复产品上架等轻量动态；未见本周新增重大AI云合同或算力建设公告。不过，Alphabet在7月22日发布Q2 2026财报（背景，非本周，因财报发生在本周时间窗前）对本周资本市场和云厂竞争仍构成重要背景：Google Cloud收入同比增长82%至248亿美元，增长由GCP企业AI解决方案、企业AI基础设施和核心GCP服务推动；Alphabet季度CapEx（以购置物业设备计）达到449.24亿美元，季度自由现金流为-58.55亿美元；Google Cloud营业利润为88.14亿美元。公司还披露为扩大AI基础设施和全球计算进行资本募集，6月发行股票和强制可转优先股净筹496亿美元。本周内Google Cloud并未进一步披露新CapEx指引或单一客户大单，因此本公司在“本周动态”层面偏静默，但因财报背景与本周新闻短讯均经原文核验，保留为固定覆盖。
- 企业维度分析：
  - 战略：本周轻量更新延续“Agentic Enterprise”路线，即用Gemini、Apigee、数据云和治理把企业系统连接到Agent；背景财报显示Google Cloud增长高度受AI基础设施和AI解决方案拉动。
  - 产品/市场：本周短讯聚焦AI Agent Evolution活动和SaaS备份恢复Marketplace；无本周新增重大企业合同。背景财报中Google Cloud 248亿美元季度收入与82%增速说明其AI云需求强劲。
  - 资本/组织/人才：本周未披露组织/人才变化。背景财报显示Q2购置物业设备449.24亿美元、自由现金流-58.55亿美元，且此前融资净筹496亿美元用于包括AI基础设施和全球计算在内的一般公司用途。
  - 风险：高CapEx导致自由现金流转负，市场会继续追问AI基础设施回报周期；Gemini/Agent平台在企业落地还面临治理、成本和与Azure/AWS多云竞争。
- 关键数据：本周未公开新增合同/CapEx。背景，非本周：Google Cloud Q2 2026收入248亿美元、同比+82%；营业利润88.14亿美元；Alphabet Q2购置物业设备449.24亿美元、自由现金流-58.55亿美元；近90% Fortune 100使用Gemini Enterprise；Gemini模型处理220亿API tokens/分钟（Alphabet财报，2026-07-22）。
- 原文链接：[Google Cloud latest news and announcements](https://cloud.google.com/blog/topics/inside-google-cloud/whats-new-google-cloud)；[Alphabet Announces Second Quarter 2026 Results PDF](https://s206.q4cdn.com/479360582/files/doc_financials/2026/q2/2026q2-alphabet-earnings-release.pdf)
- 影响判断：Google Cloud本周没有新大单，但财报背景显示其AI基础设施增长已经进入极高资本强度阶段。短期看，云增长和现金流压力会同时存在；中期胜负取决于Gemini Enterprise与GCP基础设施能否把CapEx转成可持续企业消费。

### AWS
- 本周动态：Amazon于7月30日发布Q2 2026业绩，是本周云与AI硬件最重磅动态之一。公司披露Q2净销售额2006亿美元、同比+20%；AWS销售额422亿美元、同比+37%，为18个季度最快增速，折合1690亿美元年化收入run rate；AWS营业利润166亿美元。更关键的是AI与芯片业务均超过250亿美元年化收入run rate，并且均为同比三位数增长。Amazon称Trainium继续获得动能，Anthropic与OpenAI两家头部AI实验室做出多年、多GW承诺，AI初创公司NEURA Robotics、Odyssey以及TwelveLabs、Decart、Poolside等也采用Trainium，Uber、Pinterest等大客户也有承诺。Bedrock方面，公司新增10多个托管基础模型，包括OpenAI GPT-5.6、Anthropic Claude Opus 5、Google DeepMind Gemma 4、SpaceXAI Grok 4.3；Bedrock客户达数十万，过去六个月新增客户超过发布后前两年总和，Q2客户支出超过此前所有季度总和。公司还宣布投入10亿美元建立AWS Forward Deployed Engineering，把AI工程师嵌入客户侧。
- 企业维度分析：
  - 战略：AWS正把AI云战略拆成三层：自研芯片Trainium/Graviton降低供给约束和成本，Bedrock争夺模型中立入口，Forward Deployed Engineering加速企业Agent落地。
  - 产品/市场：AWS AI业务和芯片业务均超过250亿美元年化run rate；Trainium获得Anthropic、OpenAI多年多GW承诺，表明AWS不只转售NVIDIA，也在把自研芯片卖给最重负载客户。Bedrock消费与客户数快速放大，说明模型目录和治理能力正在变现。
  - 资本/组织/人才：本周公告披露10亿美元AWS Forward Deployed Engineering投资，早期客户包括Allen Institute、Cox Automotive、NBA、NFL、Ricoh、Southwest Airlines。新闻稿未在正文披露全年CapEx指引；第三方报道称管理层上调2026现金CapEx至约2200亿美元，但本文不把该数字作为主依据。
  - 风险：AI基础设施投入导致TTM自由现金流转为-76亿美元，且公司提示内存芯片等资源/供应波动风险。Trainium大客户承诺虽强，但生态、软件迁移和与NVIDIA CUDA习惯的竞争仍是执行风险。
- 关键数据：AWS Q2销售额422亿美元、同比+37%，年化收入run rate 1690亿美元；AWS营业利润166亿美元；AWS AI业务年化run rate >250亿美元、芯片业务年化run rate >250亿美元，均同比三位数增长；Amazon TTM经营现金流1614亿美元、TTM自由现金流-76亿美元，物业设备购买同比增加661亿美元且主要反映AI投资；AWS FDE投资10亿美元（Amazon，2026-07-30）。
- 原文链接：[Amazon Q2 2026 earnings report: Read the release](https://www.aboutamazon.com/news/company-news/amazon-earnings-q2-2026-report)
- 影响判断：AWS本周用硬数字回应“AI云是否落后”的质疑：云增速、AI业务run rate、自研芯片承诺都显著改善。最大看点是Trainium能否在OpenAI/Anthropic承诺后真正形成大规模替代性AI算力池，从而改善毛利与供给弹性。

### Azure / Microsoft Cloud
- 本周动态：Microsoft在7月29日举行FY2026 Q4业绩电话会，是本周AI云/算力供给的另一条核心动态。Satya Nadella披露全年Microsoft Cloud收入超过2140亿美元、同比+27%，Azure全年超过1000亿美元、同比+41%；本季度新增31个数据中心、全年新增88个，并且本季度新增1GW容量，计划约两年内整体容量翻倍。公司还称过去一个财年最大区域新GPU“dock-to-live”时间减少近50%，Copilot工作负载吞吐自年初以来提高4倍。硬件路线方面，Microsoft称Maia 200已支持OpenAI和MAI模型，较其机队最新一代硬件实现30%更好performance per dollar；运行MAI模型时Maia 200性能/瓦提升40%。公司还表示将成为首批部署基于AMD Helios和NVIDIA Vera Rubin下一代机架级AI基础设施的云服务商之一。财务侧，Amy Hood披露本季度CapEx为410亿美元，其中约三分之二为短寿命资产，主要是CPU和GPU；商业RPO达6780亿美元，同比+84%。Azure和其他云服务收入增长43%，客户需求仍超过可用容量。
- 企业维度分析：
  - 战略：Azure继续采取“超大CapEx扩容 + 自研硅Maia/Cobalt + 多模型平台Foundry + Copilot应用变现”的纵向整合路线，目标是降低每个AI结果的成本并提高客户锁定。
  - 产品/市场：Azure增长43%，需求超过容量，新增容量能被迅速货币化；Foundry客户达10万、收入同比翻倍，Copilot付费席位超过3000万，企业部署从试点转向大规模。Cobalt CPU也服务Adobe、Arm、Elastic、OpenAI等。
  - 资本/组织/人才：季度CapEx 410亿美元，三分之二投向CPU/GPU等短寿命资产；Microsoft Frontier Co.启动，将6000名行业和工程专家嵌入客户侧，过去一年已完成330个项目、覆盖164家客户。总员工数同比下降2%。
  - 风险：客户需求超过容量说明收入仍受供给约束；410亿美元单季CapEx与6780亿美元RPO意味着长期交付压力和折旧压力巨大。自研模型/芯片若不能持续降低单位成本，将承压于AI应用毛利。
- 关键数据：季度新增31个数据中心、全年88个；Q4新增1GW容量；GPU dock-to-live时间减少近50%；Copilot吞吐+4倍；Maia 200 performance per dollar +30%、MAI模型性能/瓦+40%；Azure和其他云服务收入+43%；Microsoft Cloud季度收入593亿美元、全年2140亿美元；季度CapEx 410亿美元，约2/3为CPU/GPU等短寿命资产；商业RPO 6780亿美元、同比+84%；Foundry客户10万、收入同比翻倍；M365 Copilot付费席位3000万+（Microsoft，2026-07-29）。
- 原文链接：[Microsoft Fiscal Year 2026 Fourth Quarter Earnings Conference Call](https://www.microsoft.com/en-us/investor/events/fy-2026/earnings-fy-2026-q4)
- 影响判断：Azure本周证明了AI云进入“容量交付速度”竞争：谁能更快把GPU从码头变成可计费服务，谁就能兑现需求。Microsoft同时押注Maia/Cobalt和NVIDIA/AMD下一代机架，显示头部云厂不会单一路线依赖NVIDIA，但短期仍离不开GPU大规模采购。

### Tesla Optimus
- 本周动态：本周没有Tesla官方新公告落在7月27-8月2日窗口内；但7月28日Motley Fool对Tesla Optimus的产线与资本开支做了本周内复盘，并结合Tesla 7月22日Q2 Update（背景，非本周）给出可核验事实。Tesla Q2 Update披露，Fremont工厂在Model S/X产线退役后开始Optimus施工，预计年内投产；机器人章节写到，公司正在安装第一代Optimus产线，初始Optimus将用于“Optimus Academy”的训练数据收集和功能开发，而不是客户交付；Gigafactory Texas的Optimus现场开发也在继续，建筑施工全面推进。支持基础设施部分披露，2026年上半年Texas现场AI训练算力（按MW of compute）已超过翻倍，Cortex 2同时支持车辆与人形机器人自主软件开发，并将在下半年继续扩张。财务方面，Tesla Q2经营现金流47亿美元，自由现金流为-10.92亿美元，CapEx为57.89亿美元；公司称现金和投资减少12亿美元，主要由CapEx环比增加33亿美元导致的负自由现金流驱动。本周媒体复盘强调：Optimus仍处于研发/内部数据闭环阶段，官方量产线产出为零，资本投入已先行。
- 企业维度分析：
  - 战略：Tesla继续把自己从车企叙事推向“real-world AI/physical AI”公司，Optimus、Robotaxi、FSD与AI训练算力共享底层数据和计算基础设施。
  - 产品/市场：Optimus第一代产线在Fremont安装，初始产品用于内部Optimus Academy而非客户销售；Gigafactory Texas为未来扩产做场地建设。商业化仍未披露单价、客户、订单或交付时间。
  - 资本/组织/人才：Q2 CapEx 57.89亿美元，显著上升；部分投入指向Optimus产线、Texas AI训练算力、半导体fab等。未披露Optimus团队规模或关键人才流动。
  - 风险：产线尚未真正产出客户可用机器人，量产爬坡存在机械臂/灵巧手、供应链、制造良率、监管和安全风险；自由现金流转负使投资者更敏感于长期机器人愿景与短期汽车利润的权衡。
- 关键数据：背景，非本周：Fremont第一代Optimus产线安装中、预计2026年开始生产；初始构建用于Optimus Academy；Texas onsite AI training compute上半年按MW超过翻倍；Q2经营现金流47亿美元、CapEx 57.89亿美元、自由现金流-10.92亿美元（Tesla Q2 Update，2026-07-22）。本周媒体复盘称正式产线产出仍为零、初始机器人不面向客户（Motley Fool，2026-07-28）。
- 原文链接：[Tesla Q2 2026 Update PDF](https://assets-ir.tesla.com/tesla-contents/IR/TSLA-Q2-2026-Update.pdf)；[Elon Musk Says Optimus Could Be "the Biggest Product Ever." Here's What Production Data Shows So Far.](https://www.fool.com/investing/2026/07/28/elon-musk-says-optimus-could-be-the-biggest-produc/)
- 影响判断：Optimus本周的真实状态是“资本开支和厂房准备领先于产品商业化”。这并不否定长期空间，但提醒投资者：Tesla机器人估值尚主要依赖制造能力和AI训练算力的期权，而不是订单或收入验证。

### Figure AI
- 本周动态：Figure AI本周未发布重大官方新闻，官网新闻页仅提供订阅入口，未列出7月27-8月2日的新融资、订单、产品或量产公告；公司首页当前主叙事为Figure 03面向家庭帮助、Helix作为具身智能系统。为核验其资本背景，本周读取了Figure在PR Newswire发布的Series C公告（背景，非本周）：Figure宣布Series C承诺资本超过10亿美元，投后估值390亿美元，资金用于把通用人形机器人带入真实环境规模化，包括扩大BotQ制造、建设下一代NVIDIA GPU基础设施以训练和仿真Helix、开展人体视频和多模态传感数据收集。本周Forbes在Unitree IPO分析中也引用这一390亿美元估值，把Figure作为“私募高估值、限制二级市场交易”的对照。由于该融资公告发布时间不在本周，本周不将其作为新动态，只作为估值背景。
- 企业维度分析：
  - 战略：本周无新披露；背景显示Figure路线是“Helix智能系统 + BotQ制造 + 家庭/商业双场景”，并通过GPU训练与真实数据扩大模型能力。
  - 产品/市场：本周未披露Figure 03订单、产能或客户交付；官网强调家庭任务与不可预测环境导航，但没有量产数据。
  - 资本/组织/人才：本周无新融资。背景，非本周：Series C承诺资本>10亿美元、投后估值390亿美元，投资方包括Parkway、Brookfield、NVIDIA、Intel Capital、LG、Salesforce、T-Mobile、Qualcomm Ventures等。
  - 风险：高估值与未公开收入/交付数据之间张力变大；Unitree上市后形成公开可交易估值基准，可能反向审视Figure私募估值。家庭场景安全、可靠性、成本和售后均未被公开验证。
- 关键数据：本周未公开新增订单、收入、交付、CapEx或融资。背景，非本周：Series C承诺资本超过10亿美元、投后估值390亿美元（Figure/PR Newswire，发布日期不在本周）；本周Forbes复盘引用Figure 390亿美元估值（2026-07-30）。
- 原文链接：[Figure News](https://www.figure.ai/news)；[Figure homepage](https://www.figure.ai/)；[Figure Exceeds $1B in Series C Funding at $39B Post-Money Valuation](https://www.prnewswire.com/news-releases/figure-exceeds-1b-in-series-c-funding-at-39b-post-money-valuation-302556936.html)
- 影响判断：Figure本周是静默但被动受影响公司：Unitree IPO把“真实收入、毛利、公开交易”引入人形机器人估值体系，Figure的390亿美元私募估值会被更多拿来与公开市场机器人公司比较。后续关键是BotQ制造与Helix部署是否披露可验证交付数据。

### Unitree 宇树
- 本周动态：Unitree是本周具身智能板块最重要公司。7月31日财新英文报道，宇树机器人正式启动上海科创板IPO，计划募资42亿元人民币（约6.2亿美元），隐含估值420亿元人民币；审批全流程104天，被报道为科创板最快纪录，体现中国监管对AI/机器人战略企业资本市场通道的支持。Forbes 7月30日进一步梳理称，Unitree计划发行至少10%股份，预计数周内上市；以42亿元募资和420亿元估值计，较2025年中约17亿美元私募估值提升约3.5倍。Forbes还引用招股书信息：Unitree收入从2023年1.59亿元增至2025年约17亿元；2025年人形机器人约占收入52%，超过机器狗；毛利率接近60%，净利率为十几个百分点；2025年出货约5,500台人形机器人。官网新闻页本周无新产品新闻，最近条目为6月H2 Plus与5月表演内容，因此本周新增事实集中于IPO/资本市场。
- 企业维度分析：
  - 战略：宇树从消费/教育/工业四足机器人的低价规模化，转向以人形机器人收入为核心，并用科创板上市建立“公开市场机器人纯标的”地位。
  - 产品/市场：据Forbes引用招股书，2025年人形机器人占收入52%、出货约5,500台，显示其优势是可销售、可规模化的硬件，而不是仅靠Demo。官网产品矩阵覆盖H2、R1、G1、H1等人形机器人与B2/Go2等四足机器人。
  - 资本/组织/人才：IPO募资42亿元人民币/约6.2亿美元，隐含估值420亿元人民币；创始人王兴兴通过10投票权Class A股保持控制。资金用途细节在可读原文中未完整披露，需招股书进一步核验。
  - 风险：上市后估值将被每日交易检验，首日热度不等于长期盈利能力；低价硬件路线可能压缩售后和质量冗余；海外市场还面临出口管制、供应链、数据安全和品牌信任挑战。
- 关键数据：IPO拟募资42亿元人民币/约6.2亿美元，隐含估值420亿元人民币（财新，2026-07-31）；审批104天（财新，2026-07-31）；背景/招股书引用：2023收入1.59亿元、2025约17亿元，2025人形机器人收入占比52%、毛利率近60%、净利率十几个百分点、2025出货约5,500台人形机器人（Forbes，2026-07-30）。
- 原文链接：[Robotics Startup Unitree Launches $620 Million STAR Market IPO](https://www.caixinglobal.com/2026-07-31/robotics-startup-unitree-launches-620-million-star-market-ipo-102469723.html)；[Unitree’s IPO Will Set The First Public Robot Valuation Benchmark](https://www.forbes.com/sites/jonmarkman/2026/07/30/unitrees-ipo-will-set-the-first-public-robot-valuation-benchmark/)；[Unitree News Center](https://www.unitree.com/news/)
- 影响判断：Unitree IPO为人形机器人行业建立第一个高流动性、相对纯粹的公开估值锚。它会同时影响Figure、Tesla Optimus、UBTech和中国一批机器人创业公司的叙事：资本市场将更重视出货、收入、毛利和净利，而不是只看演示视频。

### UBTech 优必选
- 本周动态：本周核验UBTech官网、英文首页、PR Newswire及关键词检索，未发现2026-07-27至2026-08-02窗口内由UBTech官方发布的重大新订单、融资、量产或组织动态。因此本周按“本周无重大公开动态”处理。为避免遗漏，核验范围包括UBTech英文官网（可读到其人形服务机器人、AI教育、智慧养老、消费级硬件等业务入口）、PR Newswire 7月1日UWORLD U1发布稿（背景，非本周）以及Walker S2价格/订单资料复核。背景资料显示，UBTech在6月30日发布UWORLD U1系列全尺寸超仿真人形机器人，起价119,800元人民币，发布当天累计订单13,361台；公司称工业Walker S系列已进入量产并开始交付。另有第三方资料基于年报测算2025年全尺寸人形产品与服务收入8.206亿元、售出1,079台，约等于76万元/台收入口径，但这不是本周新增事实，也不是Walker S2官方标价。
- 企业维度分析：
  - 战略：本周无新战略披露；背景，非本周：UBTech正从工业/商业应用扩展到消费陪伴机器人，以Walker工业线和UWORLD消费线形成双增长引擎。
  - 产品/市场：本周未披露新Walker S2订单或U1交付数据；官网仍展示人形服务、AI教育、养老和消费硬件业务。背景U1订单体现消费市场热度，但需观察转化和交付。
  - 资本/组织/人才：本周未公开融资、并购或高管变动；公司已在港交所上市（背景，非本周）。
  - 风险：U1消费订单可能包含预订/意向，与收入确认和交付质量不同；Walker系列价格不透明，第三方价格混杂；公开市场会拿UBTech与Unitree的盈利能力、出货和估值直接比较。
- 关键数据：本周未公开新增数据。背景，非本周：UWORLD U1起价119,800元人民币、发布当天累计订单13,361台、2026年计划捐赠100台定制U1机器人（UBTech/PR Newswire，2026-07-01）；第三方年报复核称2025年全尺寸人形产品与服务收入8.206亿元、售出1,079台，推算约76万元/台收入口径（RoboZaps，2026-07-17，非官方单价）。
- 原文链接：[UBTECH homepage](https://www.ubtrobot.com/en/)；[UBTECH Launches UWORLD U1](https://www.prnewswire.com/news-releases/ubtech-launches-uworld-u1-the-worlds-first-full-size-mass-produced-ultra-bionic-humanoid-robot-302815272.html)；[UBTech Walker S2: Price, Verified Specs & the 3-Minute Battery Swap](https://blog.robozaps.com/b/ubtech-walker-s-review)
- 影响判断：UBTech本周没有新催化，但在Unitree IPO启动后，它会被迫面对更直接的公开市场比较：收入质量、亏损/盈利能力、产能与订单兑现。U1若能把预订转成交付，会给其消费机器人叙事加分；否则市场仍会聚焦工业Walker的真实复购。

### Humanoid（英国）
- 本周动态：虽然融资公告原始日期为7月21日（背景，非本周），但Forbes在本周搜索结果中持续引用并讨论这笔融资，考虑到它是本轮窗口附近的具身智能重大资本事件，列为“背景，非本周”而非本周新动态。英国伦敦创业公司Humanoid完成1.52亿美元Series A，投后估值13.5亿美元，成为欧洲“pure-play”人形机器人独角兽之一；总融资达2.7亿美元。融资由Prime Movers Lab领投，Schaeffler、Bosch、台湾富邦金控创投、Aglaé Ventures等参与。公司此前与Schaeffler和Bosch达成合作，被Forbes描述为可支持未来五年10万台生产；Bosch将作为合同制造伙伴并提供供应链/硬件设计支持。产品HMND 01优先采用轮式平台，管理层称85%-90%用例可由轮式覆盖，且轮式平台更易按AMR和协作机器人标准做欧洲认证；计划今年晚些时候以Beta机器人启动3-6个月客户现场商业试点。公司已完成9个PoC，第10个进行中，覆盖物流、制造、零售。
- 企业维度分析：
  - 战略：Humanoid选择“轮式优先+工业场景+欧洲供应链认证”路线，避开双足安全标准缺失和能耗/稳定性难题，以更早商业试点换取数据和客户信任。
  - 产品/市场：HMND 01有轮式和双足版本，但研发重心在可认证轮式工业平台；客户/伙伴包括Schaeffler、Bosch、SAP、NVIDIA、Siemens等，场景为物流、制造、零售。
  - 资本/组织/人才：Series A 1.52亿美元、投后估值13.5亿美元、总融资2.7亿美元；团队引入50多名来自Boston Dynamics、Sanctuary AI、Apptronik、1X等公司的老兵。
  - 风险：该事件非本周，且量产和10万台能力仍依赖伙伴产线与未来订单兑现；轮式路线虽更容易认证，但也可能被市场认为“不是完整人形”；欧洲成本结构与中美竞争者相比存在压力。
- 关键数据：背景，非本周：Series A 1.52亿美元、投后估值13.5亿美元、总融资2.7亿美元；9个PoC完成、第10个进行中；计划Q4 Beta机器人并启动3-6个月商业试点；合作目标支持五年10万台生产（Forbes，2026-07-21）。
- 原文链接：[Humanoid Raises $152 Million At $1.35 Billion Valuation](https://www.forbes.com/sites/johnkoetsier/2026/07/21/humanoid-raises-152-million-at-135-billion-valuation-europes-newest-robot-unicorn/)
- 影响判断：Humanoid不是本周新融资，但它代表欧洲在人形机器人资本竞赛中的补位。与Unitree低价规模、Figure高估值家庭/商业通用路线相比，Humanoid更务实地押注轮式工业合规，可能更快产生可审计试点数据。

### Eliyan
- 本周动态：7月29日，AI基础设施互连创业公司Eliyan宣布完成1.45亿美元Series C，估值10亿美元，成为独角兽。该公司不是模型或开源项目，而是面向AI数据中心瓶颈的硬件/IP公司，切中D组“芯片/网络/内存路线”重点。Eliyan的核心判断是：AI加速器算力越来越强，但数据在处理器之间传输不够快，导致GPU/AI芯片无法充分利用。其CEO在报道中称，当前可能只有30%-40%的GPU被利用，主要受限于数据接收速度。Eliyan开发高速互连技术和光学chiplet，授权给半导体公司并提供可集成进AI芯片设计的chiplet，目标客户是超大规模云、云服务商和自研AI加速器公司。该轮由Seligman Ventures领投，Cisco Systems、Lumentum、Mellanox早期投资人Umesh Padval等参与；Umesh Padval将加入董事会。公司称首批chiplet产品预计今年开始出货，收入有望从2025年的低百万美元增长到2027年底数亿美元。
- 企业维度分析：
  - 战略：Eliyan不直接做AI处理器，而是站在“算力利用率瓶颈”位置，提供开放/独立互连替代方案，受益于云厂自研芯片和多供应商AI集群趋势。
  - 产品/市场：产品包括高速互连技术和光学chiplet，面向处理器间数据移动、带宽、功耗和封装复杂度问题；潜在客户包括hyperscalers、云服务商和半导体公司。
  - 资本/组织/人才：Series C 1.45亿美元、估值10亿美元；Cisco、Lumentum等战略投资人参与，Mellanox背景董事加入，增强其在AI网络/互连生态的可信度。
  - 风险：从IP/样片到大规模设计导入周期长，收入预测需要客户芯片流片和量产兑现；NVLink、Broadcom/Marvell定制网络和云厂自研互连均是强竞争；光电互连路线也有成本、封装和良率挑战。
- 关键数据：Series C融资1.45亿美元、估值10亿美元（Eliyan/TechStartups，2026-07-29）；CEO称GPU利用可能仅30%-40%受数据传输限制；首批chiplet产品预计2026年出货；收入目标从2025年低百万美元到2027年底数亿美元（TechStartups，2026-07-29）。
- 原文链接：[AI infrastructure startup Eliyan becomes unicorn after $145M Series C](https://techstartups.com/2026/07/29/ai-infrastructure-startup-eliyan-becomes-unicorn-after-145m-series-c-to-solve-ai-data-center-bottlenecks/)
- 影响判断：Eliyan融资说明AI硬件投资正从“买更多GPU”外溢到互连、封装、光电chiplet等利用率瓶颈。若其技术被云厂自研加速器采用，将对Broadcom/Marvell/NVIDIA网络生态形成边缘但重要的替代压力。

## 本组洞察
1. **AI云竞争进入“容量交付速度 + 能源许可”阶段。** Azure披露季度新增1GW容量、31个数据中心和GPU dock-to-live时间缩短近50%；AWS披露AI业务与芯片业务均超过250亿美元年化run rate；Oracle则把Project Jupiter的水、电、税收和就业细节公开化。算力供给不再只是GPU采购问题，而是土地、电力、冷却、地方社区、机房建设和上线效率共同决定收入兑现。
2. **头部云厂都在降低对单一GPU路线的依赖，但NVIDIA仍在下一代平台上保持定价权。** Microsoft同时押注Maia/Cobalt、AMD Helios和NVIDIA Vera Rubin；AWS用Trainium争取OpenAI/Anthropic多年多GW承诺；Google Cloud靠TPU/Gemini/GCP全栈增长。但NVIDIA通过SSI投资与Vera Rubin合作，继续把最稀缺的前沿模型需求绑定到自身路线图。
3. **机器人行业从Demo叙事转向公开市场审计。** Unitree启动科创板IPO，带来募资、估值、收入、出货和毛利等可交易锚点；这会反向影响Figure、Tesla Optimus、UBTech和欧洲Humanoid的估值表达。未来投资者会更关注“交付多少台、卖给谁、毛利多少、能否复购”，而不是只看灵巧演示。
4. **AI硬件投资正在外溢到互连/封装/光电瓶颈。** Eliyan以AI芯片间数据传输瓶颈完成1.45亿美元融资，说明市场认识到GPU利用率、内存带宽、机架级互连和光电chiplet将成为下一轮AI基础设施价值池。Broadcom虽本周静默，但其所处AI网络/ASIC赛道仍是云厂自研芯片潮的关键受益/竞争位置。
5. **资本开支回报压力全面上升。** Alphabet背景财报显示单季购置物业设备449亿美元、自由现金流转负；Microsoft单季CapEx 410亿美元；Amazon TTM自由现金流转为-76亿美元；Tesla Q2也因CapEx上升自由现金流转负。AI云和具身智能都在进入“先投基础设施、后验证单位经济”的阶段，后续核心观察指标是利用率、客户承诺兑现、折旧压力和推理/机器人收入转化。

## 下周观察点

1. **OpenAI 与 Microsoft 的成本控制分工**：观察 GPT-5.6 降价、MAI 模型、自研芯片和 Azure 容量扩张是否继续改变企业 AI 毛利结构。
2. **AWS Trainium 承诺兑现**：重点跟踪 OpenAI、Anthropic 多年多 GW 承诺是否转化为公开案例、性能数据与迁移工具。
3. **Meta El Paso 与 AI 基础设施融资**：关注类似 BlackRock 合资、长期租赁和残值担保结构是否被更多云厂/模型公司采用。
4. **Kimi 与中国模型商业化**：重点看 K3 开放权重带来的 API/企业版收入、算力消耗和监管反馈。
5. **Unitree IPO 后的人形机器人估值链条**：对比 UBTech、Figure、Tesla Optimus、Humanoid 的交付数据、订单质量和毛利路径。
6. **企业应用公司真实指标披露**：Harvey、Cohere、Scale、Glean、Cursor 是否继续披露使用量、ARR、客户扩容、审计和 ROI 指标。

## 关于本周报

本周报定位为「全球 AI 企业研究」，覆盖全球 AI 巨头、头部模型公司、AI 应用企业、AI 云/算力/硬件/具身智能公司。研究重点是企业战略、产品、商业化、资本、组织、人才、市场和监管变化；开源项目、Agent 框架、GitHub 工具项目不作为独立研究对象。

**门控结果**：覆盖 43/43；原文抽查 5/5（OpenAI、Meta、AWS、Cohere、Harvey）均可访问并与报告关键数据一致；企业判断到位；关键数据有源，未公开处已标注。  
**格式自检**：正文链接均使用 Markdown 超链；未将时间窗外旧闻写成本周事实；未把独立开源项目/GitHub 项目作为研究对象。
