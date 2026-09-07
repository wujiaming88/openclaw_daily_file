# 全球AI企业周报研究母稿｜2026-09-07

**严格研究时间窗：2026-08-31 00:00—2026-09-06 24:00（Asia/Shanghai）**  
**成稿日期：2026-09-07**  
**用途：研究母稿；不等同对外发布文章。**

## 研究边界、来源口径与事件ID

本稿合并A、B、C、D四组已验收企业研究。组内合计候选来源 **147** 条、成功正文精读 **87** 条、采用来源 **86** 条；其中A为39/21/21，B为34/18/16，C为42/30/30，D为32/18/19。四组之间存在公司和URL重复，例如NVIDIA、AWS、Google Cloud、Microsoft Azure等跨组出现；上述数字是**组内统计之和**，不是全稿唯一URL数，最终引用按URL去重。研究对象仅为企业及企业级业务，不把开源项目、repo、CLI、SDK当作独立研究对象；模型卡、SDK或开放权重仅作为相应企业事件的证据。

证据等级统一为：**A**=公司公告、财报或可定位原始文件；**B**=权威媒体或多源交叉；**C**=单一行业媒体、公司自报案例、匿名信源或原始页受限后的替代证据。公司benchmark、客户覆盖、内部ROI均明确视为自报；媒体传闻和匿名信源不升格为已确认事实；窗口外信息只作背景。

事件ID用于后续保真追踪：有料对象至少一个E编号；静默、轻动态或边界对象使用V编号。重复公司在不同组的独立事实保留独立ID，不因汇总而消失。

## TOP5候选：按五维综合排序

排序维度为“战略影响力×商业化信号×资本/组织信号×市场格局影响×新颖度”，不是单看金额或模型跑分。

### TOP1｜E08 NVIDIA同意以129.303亿美元收购Hugging Face

- **证据**：NVIDIA 9月3日原始公告；CNBC、TechCrunch交叉。交易价129.303亿美元；目标平台拥有1800万以上用户、300万以上模型、50万数据集、100万应用，并被20万以上企业使用。
- **为什么重要**：NVIDIA从芯片、网络和系统软件继续向模型分发与开发者入口上移。若平台维持多云、多加速器和开放模型中立性，NVIDIA可把开发者网络转化为优化、推理与算力需求；若排序或服务被认为偏向自家硬件，生态信任会反向成为交易风险。
- **五维判断**：战略影响力极高；商业化信号高；资本/组织信号极高；格局影响极高；新颖度极高。
- **证据等级/不确定性**：**A/B**。交易为“同意收购”而非已完成；监管、交割和平台中立承诺仍待验证。媒体所述约1.5亿美元年化收入是历史背景，不能视为本周公司披露或确定交易倍数。

### TOP2｜E36 Broadcom FY2026 Q3与定制XPU的GW级可见性

- **证据**：9月2日公司财务公告及CNBC交叉。Q3总收入295.91亿美元、同比增长86%；AI半导体收入167亿美元、同比增长221%、环比增长54%；Q4 AI半导体收入指引217亿美元。管理层进一步给出Anthropic TPU 8i、OpenAI Jalapeno等GW级路线可见性。
- **为什么重要**：AI资本开支不再只流向通用GPU，定制ASIC/XPU和网络互连已形成可量化利润池。若远期GW计划兑现，头部模型公司将通过自研芯片改变算力议价结构。
- **五维判断**：战略影响力极高；商业化信号极高；资本/组织信号高；格局影响极高；新颖度高。
- **证据等级/不确定性**：当期财务数字为**A**；远期GW与FY2027/FY2028收入展望是公司前瞻口径，须按**A-前瞻**降级，受客户集中、流片、先进封装、融资担保和建设进度影响。

### TOP3｜E01 OpenAI GPT-6 Astra：Critical网络能力与高价企业分发

- **证据**：OpenAI 9月2日、3日公告。Astra在内部20个近期V8高危漏洞测试中利用两个零日漏洞，被认定达到Preparedness Framework网络安全Critical阈值；9月3日进入ChatGPT付费档、API、Azure与AWS Bedrock，API每百万输入/输出token 10/50美元；公司自报ExploitBench 100%、OSWorld 2.0为72.6%。
- **为什么重要**：Astra把高端代理能力、双云分发、分级准入和实时监控组合为一个企业产品。前沿模型的竞争单位从单一能力分数转向“能力+访问控制+渠道+运营安全”。
- **五维判断**：战略影响力极高；商业化信号高；资本/组织信号高（安全算力投入）；格局影响极高；新颖度极高。
- **证据等级/不确定性**：**A**，但benchmark和漏洞测试均为公司自报；Critical能力只向可信测试者及Daybreak计划逐步开放，不能把受限能力等同于普通客户可用能力。

### TOP4｜E40 Anthropic—Lambda 350亿美元、约350MW云合同传闻

- **证据**：Reuters 8月31日匿名信源，AOL授权转载全文；Bloomberg/WSJ同期交叉。报道所述合同链为NVIDIA承租/供芯—Hut 8建设—Lambda运营—Anthropic消费。
- **为什么重要**：若合同结构和规模属实，neocloud竞争被提升至数百MW和数百亿美元级，且芯片商开始用租约与信用支持园区融资。这会改变CoreWeave、四大云和模型公司之间的容量采购与风险分配。
- **五维判断**：战略影响力极高；商业化信号极高；资本/组织信号极高；格局影响极高；新颖度极高。
- **证据等级/不确定性**：**B/C**。金额、容量来自匿名信源，各方报道时未回应；期限、付款、取消条款和实际投产计划未知，必须保持“据报道/若属实”口径。

### TOP5｜E20 Sierra CFO到位与两亿美元ARR阶段

- **证据**：Sierra 8月31日公司公告。Julia Brau Donnelly出任CFO；公司自报成立约两年半，第7季度ARR达到1亿美元、第9季度达到2亿美元，并覆盖超过40%的Fortune 50、约三分之一头部银行、全球十大医疗公司中的5家和25%的IBEX 35。
- **为什么重要**：这同时给出组织成熟度和商业化速度信号。上市公司CFO经验补齐规模化治理角色；Sierra又把Voice AI定义为完整客户运营系统，开始直接争夺联络中心软件和外包服务预算。
- **五维判断**：战略影响力高；商业化信号极高；资本/组织信号极高；格局影响高；新颖度高。
- **证据等级/不确定性**：**A-公司自报**。ARR与客户覆盖缺独立审计；“覆盖”不等于全组织部署或高频使用，后续应验证净留存、使用量和交付成本。

## A组：全球基础模型与超大平台

### OpenAI｜有料｜E01、E02、E03

- **O（对象/事件）**：E01为GPT-6 Astra发布与Critical网络安全分级；E02为GPT-5.6 Sol/Terra/Luna分层预览；E03为ChatGPT Ads商业化里程碑。
- **F（事实）**：9月3日Astra进入ChatGPT付费档、API、Azure和AWS Bedrock，网络能力按可信测试者和Daybreak分级开放。9月1日GPT-5.6形成旗舰、均衡和低成本三档。8月31日公司披露ChatGPT Ads上线不足200天达到10亿美元年化收入运行率，覆盖40多个国家，ChatGPT周活跃用户超过10亿，并扩展自助广告购买区域。
- **D（关键数据）**：Astra API 10/50美元/百万输入输出token，OSWorld 2.0为72.6%、ExploitBench 100%（OpenAI，2026-09-03，公司自报）；内部20个近期V8漏洞中利用2个零日（OpenAI，2026-09-02）。GPT-5.6 Sol、Terra、Luna价格依次为5/30、2.5/15、1/6美元；自动红队投入超过70万A100等效GPU小时（OpenAI，2026-09-01）。Ads 10亿美元年化运行率、10亿以上周活、40多个国家（OpenAI，2026-08-31）。
- **J（判断）**：OpenAI已形成广告、订阅、企业服务和API并行的经营架构：低价层守开发者规模，高价Astra拉升复杂任务价值，广告补贴免费流量。高危能力的安全成本已显性化为算力、发布节奏和准入制度；网络误用、实时监控误拦截、企业隐私与广告独立性是主要风险。
- **L（原文链接）**：[ChatGPT Ads里程碑](https://openai.com/index/expanding-access-to-ai-with-chatgpt-ads/)（08-31）；[GPT-5.6预览](https://openai.com/index/previewing-gpt-5-6-sol/)（09-01）；[Path to Astra](https://openai.com/index/path-to-astra/)（09-02）；[GPT-6 Astra](https://openai.com/index/gpt-6-astra/)（09-03）。

### Google DeepMind / Google AI / Gemini｜有料｜E04、E05

- **O**：E04为Gemini 3.8 Flash/Cyber；E05为Gemini向Workspace与企业定价、治理扩展。
- **F**：9月2日Google发布六周内第三个Flash版本，Cyber版通过Fairwind Program限量给可信政府、关键基础设施运营者和软件维护者。同期Vids支持从Docs/PDF/Word生成视频摘要，持久指令扩至Drive、Chat、Slides、Sheets和Gmail，Workspace Studio增加跨应用动作，Notebook增加审计日志和BigQuery导出。CNBC报道企业版新增按量计价、最高20% token折扣、代理月度开支上限及零美元基础订阅。
- **D**：3.8 Flash价格0.75/3.75美元/百万token，HLE-Verified 54.9%；内部漏洞基准成功率超过70%，CWE-Bench补丁pass@1为47.2%（Google，2026-09-02，公司自报）。近四分之三Google Cloud客户使用AI产品，相关支出约比原承诺高50%（CNBC，2026-09-02）。
- **J**：Google用低价模型、Workspace入口和Cloud治理形成组合销售，单位任务成本将比单一benchmark更重要。Cyber能力误用、版本碎片化，以及Notebook数据全球存储且不支持区域化，是政企采用的明确风险。
- **L**：[Gemini 3.8 Flash/Cyber](https://blog.google/innovation-and-ai/models-and-research/gemini-models/3-8-flash-and-3-8-flash-cyber/)；[CNBC分析](https://www.cnbc.com/2026/09/02/google-starts-september-with-ai-momentum-after-long-losing-streak.html)；[Workspace Updates](https://workspaceupdates.googleblog.com/2026/)。

### Anthropic｜有料｜E06、E07

- **O**：E06为Enterprise Frontier Safeguards（EFS）；E07为训练安全整改、暗网蒸馏与运营风险。
- **F**：9月1日Anthropic宣布EFS，将活动数据保存于客户自有AWS、Azure或Google Cloud账户，客户控制密钥、访问和审计；自动检测无需员工人工查看，风险标记交还客户。公司还披露过去一个月外部网络评测、部分内部评测及较高风险RL环境曾暂停；4月生产RL环境冻结约一个月重构。9月3日CNBC报道暗网生态批量账号蒸馏Claude输出；Claude同日发生多模型停机并恢复。
- **D**：EFS由100多家客户共创，覆盖约四分之一财富100强和所有美国全球系统重要性银行；超过10%的生产RL环境组合曾被标记存在奖励作弊、任务损坏或配置问题（Anthropic，2026-09-01及本周更新）。
- **J**：EFS把安全和数据主权产品化，差异点是多云与客户托管日志；但训练环境缺陷、越权评测、蒸馏与停机表明竞争焦点已进入运营安全和IP防御。共创与覆盖数字均为公司口径，不能推导合同规模。
- **L**：[Enterprise Frontier Safeguards](https://www.anthropic.com/news/enterprise-frontier-safeguards)；[安全实践整改](https://www.anthropic.com/news/improving-alignment-security-efforts)；[CNBC蒸馏调查](https://www.cnbc.com/2026/09/03/anthropic-distillation-battle-turns-to-dark-web-china-concerns-swell.html)。

### Meta AI｜有料｜E08A

- **O**：Muse Spark 1.3、API商业化与贡献者定价。
- **F**：9月3日媒体报道Meta推出Muse Spark 1.3并通过Meta Model API收费，之后计划进入Instagram、Facebook和Meta AI；重点提升编码和代理任务，支持并行工作流、长指令保持、局限性认知及不可逆动作前确认。Meta尚未决定是否开放1.3权重，但仍计划开放1.2。公司以大幅折扣交换客户允许将提示和输出用于未来训练。
- **D**：相较1.2所需token减少25%；标准价每百万输入/输出token 1.25/4.25美元，贡献者价0.10/0.20美元，平均折扣约95%（Bloomberg转载/TechCrunch，2026-09-03）。部分开发者每周调用达数万亿token为媒体口径。CNBC提到最高1450亿美元2026 CapEx，属背景非本周新指引。
- **J**：Meta把开放权重叙事部分转向收费API和数据飞轮，低价同时是获客与购买真实代理轨迹。企业必须严格隔离可贡献与不可贡献数据，否则商业折扣会转化为机密、IP和合规风险。
- **L**：[Bloomberg转载](https://www.mercurynews.com/2026/09/03/meta-releases-more-powerful-ai-model-edging-closer-to-rivals/)；[TechCrunch定价分析](https://techcrunch.com/2026/09/03/meta-is-paying-to-peek-at-how-you-use-their-latest-ai-model/)；[CNBC法律与CapEx背景](https://www.cnbc.com/2026/09/02/meta-18-billion-settlement-ai-products.html)。

### Microsoft AI / Copilot / Azure AI｜有料｜E09、E38

- **O**：E09为Copilot—Work IQ—代理—工作流一体化；E38为Microsoft与HUMAIN扩大Azure合作。
- **F**：9月3日Microsoft提出“代理推理+确定性自动化+人工审批+数据治理”的企业流程范式，以采购为例连接Copilot、Work IQ、应用、Dataverse和工作流。8月31日更新伙伴技能体系，两项旧认证被AI导向认证替代。另据8月31日联合稿，HUMAIN ONE与Microsoft 365（含Copilot、Microsoft IQ）拟打包并托管于Azure，ALLAM模型计划接入Microsoft Foundry，前线部署工程师支持生产落地；HUMAIN AI PC采用Windows。
- **D**：两项旧认证于8月31日退役；PPCC规划200多场活动、24场工作坊（Microsoft，08-31/09-03）。HUMAIN初始目标覆盖中东和非洲100万企业用户，AI PC计划9月20日企业开售并以2030年100万台为目标（联合新闻稿，2026-08-31）；均为目标，不是已实现收入。
- **J**：微软胜负不依赖单一模型，而在M365入口、上下文、Power Platform与Azure闭环。HUMAIN显示主权AI客户可把应用和云交给Microsoft、底层算力拆给AMD/Cisco。主要风险是集成锁定、治理复杂度、不可预测推理账单，以及目标用户向付费使用转化不足。
- **L**：[PPCC 2026](https://www.microsoft.com/en-us/microsoft-365/blog/2026/09/03/ppcc-2026-bringing-ai-and-your-business-processes-together/)；[Partner Center](https://learn.microsoft.com/en-us/partner-center/announcements/2026-august)；[Microsoft—HUMAIN](https://www.prnewswire.com/news-releases/microsoft-and-humain-expand-strategic-collaboration-at-leap-2026-with-new-enterprise-ai-offering-and-ai-pc-302865157.html)；[Azure端到端平台](https://azure.microsoft.com/en-us/blog/enterprise-ai-transformation-relies-on-the-end-to-end-platform-azure-was-built-for-this-moment/)。

### Amazon / AWS AI｜平台有动态、自研静默｜V01、E10

- **O**：V01为AWS自研重大AI公告静默核验；E10为Bedrock渠道价值上升。
- **F**：在AWS Machine Learning Announcements、News Blog、What’s New和Bedrock定价页定向核验后，窗口内未见同量级自研前沿模型、重大AI合同、GPU/Trainium容量投产或CapEx公告。OpenAI Astra进入Bedrock；Anthropic EFS支持Bedrock并允许活动数据留在客户自有S3。Amazon Linux 2027预览支持Neuron和AI/ML工作负载，但仅属基础系统预览，不升格为重大AI商业动态。
- **D**：Bedrock动态定价页显示部分模型批量推理较按需低50%，只表示当前价格状态，未证实为本周新增。
- **J**：AWS的本周价值是模型中立采购、计费、权限和服务等级聚合，而非自研能力跃迁。多模型越多，治理价值越高，但政策、版本、审批和渠道支持责任也更复杂。静默仅限公开渠道，不能排除未公开客户项目。
- **L**：[Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)；[AWS Weekly Roundup](https://aws.amazon.com/blogs/aws/aws-weekly-roundup-welcome-ducklabs-to-the-team-agentic-resource-discovery-ard-and-more-august-31-2026/)；[Amazon Linux 2027](https://aws.amazon.com/about-aws/whats-new/2026/09/announcing-amazon-linux-2027/)；[Anthropic EFS](https://www.anthropic.com/news/enterprise-frontier-safeguards)；[OpenAI Astra](https://openai.com/index/gpt-6-astra/)。

### xAI｜轻动态、重大首发静默｜V02

- **O**：模型生命周期公告与9月3日停机；无可确认重大首发。
- **F**：xAI文档在9月新增`grok-imagine-image-quality`退役计划，11月2日后路由到2.0低质量档，价格更低且接口不变。官方Release Notes把Grok 4.6与Grok Bot列在“August”且未给具体日，Grok Build 0.1搜索摘要与官方月份归类冲突，因此不记为本周首发。9月3日Grok与ChatGPT、Claude同日中断并恢复；媒体猜测Azure原因但Microsoft否认，根因不归因。
- **D**：Grok 4.6的50万上下文与2/0.5/6美元、4/1/12美元价格仅作8月背景，非本周。
- **J**：可核验信号主要是生命周期与运营可靠性。官方只标月份增加审计难度；企业客户应要求多模型回退和故障降级。Grok 4.7若下周发布，应进入下一时间窗。
- **L**：[xAI Release Notes](https://docs.x.ai/developers/release-notes)；[xAI News](https://x.ai/news)；[停机报道](https://9to5google.com/2026/09/03/chatgpt-claude-grok-outages/)。

### NVIDIA｜有料｜E08、E34、E40

- **O**：E08为收购Hugging Face；E34为Blackwell专业卡价格与内存压力；E40为Lambda合同链中的租约/供芯角色。
- **F**：9月3日NVIDIA同意以129.303亿美元收购Hugging Face并承诺继续支持多云、多加速器与各家开放模型。8月31日Reuters称NVIDIA在Anthropic—Lambda—Hut 8得州项目中据称持有数据中心租约。9月4日Thunder Compute核查RTX PRO 6000 Blackwell工作站版公开价单和云价，认为GDDR7紧缺推动专业卡价格上涨。
- **D**：Hugging Face拥有1800万以上用户、300万以上模型、50万数据集、100万应用、20万以上企业用户；NVIDIA已贡献500多个模型和250多个数据集（NVIDIA，2026-09-03）。RTX PRO 6000官方价1.6万美元，较2025年3月8565美元MSRP高约87%；云价约CoreWeave 2.50、AWS 3.36、Google/Oracle 4.50、Azure 5.50美元/GPU小时（Thunder Compute，2026-09-04）。350亿美元/350MW合同和NVIDIA租约为匿名信源报道。
- **J**：NVIDIA护城河已延伸到开发者分发和园区融资信用。收购带来平台中立与反垄断风险；租约/供芯/投资的循环依赖带来或有责任。专业卡价格不能外推所有训练GPU供需，但显示高显存与内存约束。
- **L**：[NVIDIA收购公告](https://blogs.nvidia.com/blog/nvidia-to-acquire-hugging-face/)；[CNBC](https://www.cnbc.com/2026/09/03/nvidia-agrees-to-buy-hugging-face-for-almost-13-billion-ai-expansion.html)；[TechCrunch](https://techcrunch.com/2026/09/03/nvidia-confirms-it-will-buy-hugging-face-for-12-9-billion/)；[Reuters合同报道](https://www.reuters.com/technology/anthropic-signs-35-billion-cloud-deal-with-nvidia-backed-lambda-source-says-2026-08-31/)；[Reuters授权转载](https://www.aol.com/articles/anthropic-signs-35-billion-cloud-235939000.html)；[RTX PRO价格研究](https://www.thundercompute.com/blog/nvidia-rtx-pro-6000-pricing)。

## B组：中国大模型、平台与应用企业

### 阿里 / Qwen / 夸克｜轻动态｜E11

- **O**：夸克开学季教育用户拉新；Qwen本周无新基座模型。
- **F**：9月1日活动显示，大学生和教师认证后可领取3个月扫描王VIP与网盘VIP，权益持续至9月30日。Qwen3.8等8月发布仅作背景。阿里把AI搜索、扫描和云盘包装为校园资料工作流，而不是以新模型榜单作为本周主线。
- **D**：两类认证用户各获3个月两项会员（新浪财经/封面新闻，2026-09-02）。
- **J**：短期不是高收入事件，但可沉淀资料资产、搜索习惯和网盘留存；风险是免费转付费、学生数据合规和促销同质化。
- **L**：[开学季Token战](https://finance.sina.com.cn/stock/t/2026-09-02/doc-iniqmfta2981602.shtml)；[IT之家背景核对](https://www.ithome.com/0/995/648.htm)。

### 字节跳动 / 豆包 / 火山引擎｜有料｜E12

- **O**：豆包手机助手进入量产旗舰合规链路，并同步校园拉新。
- **F**：9月1日努比亚NaviX Ultra获工信部入网许可，将搭载豆包手机助手并计划9月上市；北京日报称该机完成端侧大模型备案到终端入网的合规链路。同期豆包向大学生提供3个月订阅权益和一次额度重置。
- **D**：工程测试机M153定价3499元、3万台售罄属背景；本周核心是量产机获许可与上市计划（北京日报、每日经济新闻，2026-09-01）。
- **J**：字节通过与中兴/努比亚合作验证跨应用Agent的系统级入口，并降低自造硬件风险。若量产顺利，将给手机厂商的入口控制权、隐私授权、系统权限和第三方应用兼容带来直接挑战。
- **L**：[每日经济新闻](https://www.nbd.com.cn/articles/2026-09-01/4569224.html)；[北京日报](https://news.bjd.com.cn/2026/09/01/11941684.shtml)；[新浪财经](https://finance.sina.com.cn/roll/2026-09-01/doc-iniqipiw3595519.shtml)。

### 腾讯 / 混元 / 元宝｜轻动态｜E13

- **O**：WorkBuddy校园Agent积分活动；混元、元宝无重大新公告。
- **F**：9月1日大学生认证可领1000积分至10月31日，教师可领1000积分至9月30日，用于资料查询、备考、就业咨询和教学办公。Hy4 preview于8月28日发布，属于背景。
- **D**：大学生、教师各1000积分（新浪财经/封面新闻，2026-09-02）。
- **J**：腾讯在把模型升级转成高校生产力使用，但促销活跃不等于留存；WorkBuddy、元宝、ima入口分散，真正效果取决于与微信和腾讯文档的协同。
- **L**：[校园权益报道](https://finance.sina.com.cn/stock/t/2026-09-02/doc-iniqmfta2981602.shtml)；[Hy4背景](https://www.tencent.com/zh-cn/tencent-releases-and-open-sources-tencent-hy4-preview/)。

### 百度 / 文心 / 千帆｜静默｜V03

- **核验结论**：检索百度新闻、文心/千帆入口及主流科技媒体，使用“百度 文心 千帆 2026年9月1日”“文心 9月2日 2026”“千帆 9月 2026”等组合，权威结果主要为1月文心5.0和5月文心5.1等旧闻。窗口内未发现新的基座模型、千帆定价/客户、重大资本或组织变化。
- **判断与风险**：公开声量相对竞品偏弱，但静默不等于业务停滞，也不排除未公开客户项目。后续需要可量化调用、收入、客户或新品重新建立节奏。
- **核验链接**：[文心模型入口](https://yiyan.baidu.com/model/intro?lang=zh)；[文心5.1背景，非本周](https://www.qbitai.com/2026/05/414496.html)。

### 华为 / 昇腾 / 盘古｜相关动态｜E14

- **O**：麒麟2026量产芯片“韬定律/逻辑折叠”实测及对华为AI全栈的外溢。
- **F**：9月4日公开的ChinaXiv预印本更新经媒体转述，核心是以3D混合键合和短垂直互连减少数据搬运，不是单纯制程微缩。直接对象是移动SoC而非昇腾/盘古新品；“未来可能优先在昇腾验证”为媒体判断，不升格事实。
- **D**：晶体管密度从1.55亿/mm²升至2.38亿/mm²、增55%；同等性能下NPU/GPU/CPU大核功耗降66%/58%/41%；NPU在29 TOPS下频率降63%、电压0.85V降至0.55V、功率密度降73%；1.5μm键合间距、5000万垂直互连（IT之家，09-04；科创板日报，09-06）。原始论文入口访问受限。
- **J**：这为国产AI硬件提供从线宽转向互连、封装、EDA和软硬协同的路线证据，但移动SoC结果不能等同数据中心昇腾规模验证。DSP功率密度、晶圆翘曲、对准精度、EDA适配和第三方复刻仍是风险。
- **L**：[IT之家](https://www.ithome.com/0/998/598.htm)；[科创板日报转载](https://www.163.com/dy/article/L65I8IO10550B1DU.html)；[ChinaXiv原始入口](https://chinaxiv.org/abs/202609.00031)。

### DeepSeek｜有料｜E15

- **O**：V4-Flash-Vision-Exp开放权重，多模态Agent方向。
- **F**：8月31日DeepSeek开放V4系列首个实验性多模态版本，MIT许可，融合视觉、文本推理和Agent能力。完整权重和推理实现降低私有化门槛；模型仍是实验版，稳定性和生产成本未验证。
- **D**：总参数约305B、每token激活13B（约4.6%）；模型卡自报DeepSWE 59.3%、ZeroBench 35.0、Agents’ Last Exam 27.3。部分榜项领先对照模型，NL2Repo、DSBench-Hard仍落后（2026-09-01多源转述）。
- **J**：DeepSeek从低价文本推理扩至“看界面+操作软件”，对闭源定价及智谱、Kimi、Qwen开发者生态形成压力。跑分主要来自模型卡，缺独立生产评测；稀疏路由在长尾任务上的稳定性需验证。
- **L**：[官方模型卡](https://huggingface.co/deepseek-ai/DeepSeek-V4-Flash-Vision-Exp)；[网易转述](https://www.163.com/dy/article/L5NTS4080556OXHR.html)；[腾讯研究院转载](https://www.sohu.com/a/1070192038_455313)；[新浪交叉来源](https://k.sina.cn/article_7879777297_1d5abdc1106801lyw2.html)。

### 智谱AI｜有料｜E16

- **O**：GLM Coding Plan进天猫，Token电商零售化；中报商业结构被本周报道集中解读。
- **F**：9月2日智谱在天猫销售个人Lite/Pro/Max和团队席位，基于GLM-5.3并适配20余款编程Agent。报道结合中报显示收入结构从项目交付向平台/API持续调用迁移；同时研发投入和亏损仍高。
- **D**：个人月费118/538/1078元；团队版598元/席且至少两席。2026H1收入9.54亿元、同比+399.7%；毛利2.52亿元、+163.7%；归母净亏损20.7亿元、收窄12.1%；开放平台及API收入8.25亿元、占86.5%、同比约+2736%（新浪科技/观察者网，2026-09-02）。中报数据为本周报道引用，不等于9月2日首次披露。
- **J**：把Token变成标准电商商品可拓展个人开发者和中小团队，并测试固定月费的价格接受度。Pro从149元升至538元约3.6倍；报道时缺可见销量，单位经济与高亏损之间仍未闭合。
- **L**：[新浪科技](https://finance.sina.com.cn/tech/roll/2026-09-02/doc-iniqmfta7809871.shtml)；[观察者网](https://www.guancha.cn/economy/2026_09_02_829711.shtml)；[东方财富/上证报转载](https://finance.eastmoney.com/a/202609023862763890.html)。

### 月之暗面 / Kimi｜传闻型动态｜E17

- **O**：秘密递交港股A1与Pre-IPO融资传闻。
- **F**：9月2日至3日多家媒体称月之暗面以保密形式向港交所递交A1并推进融资；公司回应“不予置评，暂无可披露信息”。因此只能记录为市场报道，不能表述为已确认递表。
- **D**：媒体/知情人士口径包括投前估值约500亿美元、7月F轮超过35亿美元且投后估值350亿美元、ARR从3月1亿美元升至6月中旬3亿美元、K3后日销售额增长超过6倍。以上均待招股书或公司正式文件验证。
- **J**：若递表属实，中国大模型竞争将进入财报、算力开支和资本效率透明化阶段；但高估值、VIE、审核、ARR真实性和递表状态均是重大不确定性。
- **L**：[澎湃](https://www.thepaper.cn/newsDetail_forward_34000023)；[腾讯新闻](https://news.qq.com/rain/a/20260903A056P500)；[香港商报](https://www.hkcd.com.hk/hkcdweb/content/2026/09/03/content_8773028.html)。

### MiniMax｜有料｜E18

- **O**：H3 Max进入官方平台，实时音视频生成被用于连续内容实验。
- **F**：8月31日MiniMax将fal基于开放权重H3优化的H3 Max 768P、480P接入开放平台和MiniMax Design；开发者随后搭建互动频道、24小时AI直播站、状态化虚拟世界和数字人直播。社区实验是场景验证，不等于客户订单。
- **D**：公开演示称5秒768p带声音视频生成少于3秒，吞吐约原H3的35倍；H3三周下载超2400万次、衍生模型超300个；小样本4条视频成本4.95元（AI TNT、腾讯研究院AI速递，2026-09-01）。
- **J**：竞争轴从画质转向“延迟×成本×连续性”，开放权重让伙伴优化后再回接官方平台。审核、版权、角色一致性、稳定性和持续调用成本决定能否从实验变为商业基础设施。
- **L**：[腾讯研究院转载](https://www.sohu.com/a/1070192038_455313)；[AI TNT](https://m.aitntnews.com/newDetail.html?newId=28828)。

## C组：企业Agent、垂直应用与创意平台

### Perplexity｜有料｜E19

- **O**：Mac版Hybrid Compute，以云端编排和本地敏感步骤建立混合隐私边界。
- **F**：9月1日Computer可把同一任务拆给云端前沿模型和Mac本地模型；私密文件或敏感信息步骤在本机完成，离机前可保持本地、掩码、拒绝或请求同意，姓名、地址、账号等以占位替换。公司开放相关PII分类器。官方原页受403，事实由两篇已打开媒体交叉。
- **D**：支持Apple Silicon、macOS 15+，至少24GB统一内存、建议32GB；PII-TRACE的13,148段合成对话、13种语言、37,431个标识符提及仅有技术媒体复述，作单源警示（2026-09-01）。
- **J**：Perplexity从答案引擎走向可执行Computer，并把数据边界纳入任务编排，切入法律、医疗、财税等高敏场景。风险是本地步骤仍由云端代理编排，用户需要审计输出、轨迹和哪些信息离机；高内存门槛限制设备基数，PII识别也不能保证零漏检。
- **L**：[官方公告入口](https://www.perplexity.ai/hub/blog/introducing-hybrid-compute-on-mac)；[9to5Mac](https://9to5mac.com/2026/09/01/perplexity-launches-privacy-minded-hybrid-compute-ai-feature-for-mac/)；[MarkTechPost](https://www.marktechpost.com/2026/09/01/perplexity-releases-hybrid-compute-on-mac-cloud-agents-orchestrate-down-to-a-local-model-gated-on-device/)。

### Midjourney｜静默｜V04

- **核验结论**：官方Updates受Cloudflare 403，结合官网与“Midjourney September 2026 company news”“Midjourney Sep 2026 AI image”等公开检索，结果主要是V8.1教程、价格盘点和背景页，没有可确认的本周公司战略、产品、商业化、资本或组织事件。
- **判断与风险**：静默只表示公开信息空档。Runway推进团队协作和世界模型时，Midjourney若长期缺席企业工作流，入口可能承压；但抓取受限带来残余漏报风险。
- **核验链接**：[Midjourney Updates](https://www.midjourney.com/updates)。

### Runway｜有料｜E21、E22

- **O**：E21为Solaris交互世界模型研究；E22为2—9人Team套餐与Ruby工具更新。
- **F**：Solaris逐帧实时渲染可交互数字环境，点击、拖拽等作为条件信号继续生成，语言模型决定界面演化；公司未说明客户可用时间。9月4日Team自助套餐上线，提供共享credits、项目、存储、评论、agent skills与连接器；8月31日Ruby调色模型作为独立Tool Mode开放付费用户。
- **D**：Team每席每月6900 credits，100个共享项目、1TB存储、最多20项共享skills；69美元/月席，年付折合55美元/月席（Runway，2026-09-04）。
- **J**：Solaris把长期边界从视频工具推向交互模拟，Team则把个人订阅升级为组织席位和共享资产。Solaris仍是研究能力展示，规模化时延、推理成本和交付日期未知；Team能否提高ARPU和团队留存需后续数据。
- **L**：[Team Plan](https://runway.com/news/company-news/introducing-team-plan)；[Changelog](https://runway.com/changelog)；[CNET Solaris报道](https://www.cnet.com/tech/services-and-software/runways-new-ai-model-creates-digital-worlds-without-code/)。

### Harvey｜有料｜E23

- **O**：GE Aerospace与Macpherson Kelley两项机构级部署。
- **F**：9月1日GE Aerospace在整个Legal & Compliance组织部署Harvey，并成为Contract Intelligence设计伙伴。9月2日，澳大利亚商业律所Macpherson Kelley在全部律师和八个业务组全面部署，决定建立在持续一年的试点与多平台评估上；Harvey的Customer Success和Legal Engineering团队曾现场识别高价值工作流。
- **D**：Macpherson Kelley拥有121年历史、8个业务组、试点一年（Harvey/客户联合公告，2026-09-02）；GE为整个法务与合规组织部署（09-01）。未披露席位、合同额或效率基线。
- **J**：Harvey以“试点—现场法律工程—全组织铺开—共同设计”深化法律AI壁垒，兼顾律所和企业法务。长销售周期和高接触交付提升切换成本，但可能压缩毛利与复制速度；部署也不等于高频使用。
- **L**：[GE Aerospace部署](https://www.harvey.ai/blog/ge-aerospace-deploys-harvey-across-its-legal-and-compliance-organization)；[Macpherson Kelley全所部署](https://www.harvey.ai/blog/macpherson-kelley-rolls-out-harvey-firmwide)；[Harvey Newsroom](https://www.harvey.ai/newsroom)。

### Sierra｜有料｜E20、E24

- **O**：E20为CFO与ARR阶段；E24为Voice AI评估及呼叫中心上线框架。
- **F**：8月31日Julia Brau Donnelly出任CFO，带来投行、私募股权、Wayfair运营和Pinterest CFO经验。9月1日、4日公司发布企业Voice AI评估与上线指南，要求测试时延、打断、听辨、上下文、行动、护栏和转人工，并把队列、人员、故障恢复、成本和回滚纳入运营。
- **D**：公司成立约两年半，第7季度ARR 1亿美元、第9季度2亿美元；客户覆盖超过40%的Fortune 50、约三分之一头部银行、5/10最大医疗公司、25%的IBEX 35（Sierra，2026-08-31，公司自报）。tau-voice含278项客服任务（09-01）。
- **J**：Sierra从创业高速增长转入大型软件公司治理阶段，且把Voice定义为完整客户运营系统而非语音合成点产品。ARR和覆盖未独立审计；语音代理仍面临误操作、身份、监管和高风险转人工问题。
- **L**：[CFO公告](https://sierra.ai/blog/julia-brau-donnelly-joins-sierra)；[Voice AI指南](https://sierra.ai/blog/what-is-voice-ai)；[呼叫中心上线指南](https://sierra.ai/blog/ai-for-call-centers)。

### Glean｜有料（战略/市场教育）｜E25

- **O**：从enterprise search重定义为enterprise context。
- **F**：9月2日Glean强调Agent需要权威来源、实时索引、混合检索、知识图谱、逐次权限执行和多步骤上下文交付，并把MCP/联邦连接定义为“可达性”而不是上下文质量。本周没有新合同或价格。
- **D**：自有评测称复杂企业查询中，偏好评审将基于Glean上下文层答案判为正确的频率，是基于ChatGPT company knowledge答案的1.9倍（Glean，2026-09-02，自评）。
- **J**：护城河从搜索UI迁向权限、知识图谱和索引层，企业采购标准可能从连接器数量转向深度、时效、权限和关系理解。1.9倍不能外推；Databricks与办公套件巨头均可向上下文层竞争。
- **L**：[Glean原文](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need)；[Glean Blog](https://www.glean.com/blog)。

### Databricks｜有料｜E26、E27、E28

- **O**：E26为Genie Agents深度分析与文件推理；E27为AgentOps内部成本案例；E28为Proteus GPU kernel系统。
- **F**：9月2日Agent mode向全部Genie Agents开放多步研究，API支持SSE、连续对话、监控和可视化附件；可同时分析Unity Catalog表与Volumes中的文档、PDF、幻灯片和图像并继承权限。9月1日内部案例用Gateway trace配合Genie One约一小时定位7个工具服务bug。9月4日Proteus在Qwen 3.5 122B部分kernel上相对vLLM取得性能提升。
- **D**：每个agent最多挂载10个Volumes（Databricks，09-02）。内部估算：7个bug、每日1409次错误、每年49.9万美元token浪费、12023小时等待，合计约120万美元生产力损失，约一小时修复（09-01）。Proteus部分kernel提升1.8—5.2倍（09-04，公司实验）。
- **J**：Databricks把数据治理、Agent分析、可观测性和推理效率串成闭环，能把湖仓预算吸收进Agent运行层。120万美元不是经审计客户ROI，kernel提升也不能外推所有工作负载；平台扩张会加大锁定和复杂分析错误风险。
- **L**：[Genie Agents](https://www.databricks.com/blog/expanding-genie-agents-deep-analysis-file-reasoning-and-more)；[AgentOps案例](https://www.databricks.com/blog/how-we-eliminated-1-million-year-wasted-ai-agent-spend-one-hour)；[Proteus](https://www.databricks.com/blog/achieving-extreme-efficiency-through-specialized-gpu-kernel-generation)。

### Cohere｜静默｜V05

- **核验结论**：核验Blog、Newsroom、Events及“Cohere September 2026 company news”等检索，未发现日期明确落在窗口内的新产品、客户、融资或组织公告。主权AI报告约两周前发布，调查在4—5月，属背景；9月8日活动在未来。
- **判断与风险**：主权AI和私有部署是持续定位，不是本周变化。动态渲染可能造成列表提取不完整；Perplexity已用混合计算切入隐私边界，Cohere需要以可量化部署证明差异化。
- **核验链接**：[Blog](https://cohere.com/blog)；[Newsroom](https://cohere.com/newsroom)；[Events](https://cohere.com/events)；[主权AI背景](https://cohere.com/blog/state-of-sovereign-ai-adoption-2026)。

### Mistral AI｜静默｜V06

- **核验结论**：官方News与定向检索可见Agentic Search、Shieldstral、OCR 4等条目，但没有可确认本周日期；搜索把Agentic Search标为约三周前。第三方September聚合不能替代原始发布日期，故不计。
- **判断与风险**：欧洲主权AI和开放模型是背景。本周无产品、资本或组织增量证据；News日期不可抓取带来有限漏报风险。
- **核验链接**：[Mistral News](https://mistral.ai/news/)；[Agentic Search背景](https://mistral.ai/news/agentic-search/)。

### Scale AI｜静默｜V07

- **核验结论**：Scale Blog、Events和定向检索未发现窗口内新融资、重大客户、产品或组织公告。Francis deSouza于8月10日生效，属窗口外背景。
- **判断与风险**：公共部门、评估/数据和主权AI为持续定位。本周静默；在Meta交易后，公司仍需证明客户中立性和高端评估价值。Blog条目日期不足，保守处理。
- **核验链接**：[Scale Blog](https://scale.com/blog)；[Scale Events](https://scale.com/events)。

### Anysphere / Cursor｜有料｜E29、E30

- **O**：E29为Self-Hosted Machines；E30为Nokia和Basis客户案例。
- **F**：9月2日Cloud Agents可在客户自管网络和机器执行工具、编辑代码和运行命令，但推理、规划和agent loop仍在Cursor云端；机器通过长期出站HTTPS连接worker，支持单机和弹性Pools。9月2日Nokia案例、9月4日Basis案例展示代码分析和长周期会计Agent。
- **D**：Cursor自报内部合并PR中超过60%由Cloud Agents创建。Nokia称2名工程师两周分析超过5000万行代码，另一工具约80%自动化原需6—10名管理人员协调的流程。Basis称Form 1065从人类30—40小时降至Agent 6—7小时，服务40%的Top 25 firms；均为供应商/客户自报。
- **J**：Cursor从IDE席位升级为企业Agent执行控制面。所谓自托管只迁移执行环境，不等同完全本地；工具输出、代码和轨迹的回传边界需要客户审计。案例ROI缺独立验证，但产品方向直接压迫Cognition/Devin和传统开发平台。
- **L**：[Self-Hosted Machines](https://cursor.com/blog/self-hosted-machines)；[Nokia案例](https://cursor.com/blog/nokia)；[Basis案例](https://cursor.com/blog/basis)。

### Cognition / Devin / Windsurf｜静默｜V08

- **核验结论**：官方Blog及“Cognition Devin Windsurf September 2026 company news”等检索未发现窗口内公司原始公告。2026年5月融资、6月品牌动作和8月融资谈判均在窗口外；二手收入和估值不采用。
- **判断与风险**：本周无可靠新客户、价格或组织事件。Cursor在企业执行控制和案例披露上领先；Cognition需披露Windsurf整合成果、可验证ROI和企业部署控制。官方Blog信息少，仍有漏报风险。
- **核验链接**：[Cognition Blog](https://cognition.com/blog)。

## D组：算力、云、芯片与具身智能

### AMD｜有料｜E35

- **O**：AMD—Cisco—HUMAIN生产级AI基础设施上线、远期扩容、LUMI-AI与开发者生态。
- **F**：8月31日生产级设施已上线并服务客户，采用Instinct MI355X、EPYC、Cisco Silicon One和800G光学互连。下一阶段计划自2027年开始部署最高250MW的MI400/ROCm设施，维持2030年最高1GW目标。MI430X与第六代EPYC将用于欧洲LUMI-AI超算；与沙特通信部、DCO启动开发者生态项目。
- **D**：MI355X已上线；2027年起最高250MW；2030年最高1GW（AMD，2026-08-31）。250MW和1GW为规划，不是收入或已交付容量。
- **J**：AMD以开放软硬栈和主权AI成为NVIDIA外的第二供应源，且Cisco网络+AMD计算构成开放以太网量产样板。建设、电力、出口、HBM/封装和ROCm生态决定远期规划兑现。
- **L**：[HUMAIN设施](https://newsroom.amd.com/news/amd-cisco-humain-expand-saudi-arabia-ai-infrastructure/)；[LUMI-AI](https://newsroom.amd.com/news/amd-instinct-gpus-epyc-cpus-power-lumi-ai-supercomputer/)；[开发者生态](https://newsroom.amd.com/news/amd-saudi-arabia-digital-cooperation-organization-open-developer-ecosystem/)。

### Broadcom｜有料｜E36

- **O**：FY2026 Q3高增长与定制XPU远期GW路线。
- **F**：9月2日Broadcom公布财报，AI半导体收入大增并上调Q4指引。管理层称2027年Anthropic TPU 8i约5GW、另有10GW可见性；OpenAI Jalapeno约1.3GW、另有超过5GW可见性，并预计FY2027/FY2028 AI收入达到1150亿/2300亿美元。CNBC称公司可能为AI实验室提供残值担保。
- **D**：Q3总收入295.91亿美元、同比+86%；AI半导体收入167亿美元、同比+221%、环比+54%；Q4 AI半导体收入指引217亿美元、同比+236%，总收入348亿美元，非GAAP营业利润率约66%（Broadcom，2026-09-02）。
- **J**：定制ASIC/XPU和网络已成为通用GPU的互补与替代，头部模型客户正把自研芯片写入多年容量路线。远期数字是管理层展望而非订单收入；客户集中、流片、封装、建设、高估值和残值担保是主要风险。
- **L**：[财务公告](https://www.prnewswire.com/news-releases/broadcom-inc-announces-third-quarter-fiscal-year-2026-financial-results-and-quarterly-dividend-302868129.html)；[CNBC](https://www.cnbc.com/2026/09/02/broadcom-avgo-q3-earnings-report-2026.html)。

### CoreWeave｜静默｜V09

- **核验结论**：核验IR、Reuters技术频道及“CoreWeave contract financing AI cloud”“CoreWeave September 2026 backlog customer”等检索，未见窗口内新合同、融资、并购、订单或产能投产公告；IR受403，结果主要为二级市场分析和旧交易回顾。
- **判断与风险**：静默不代表业务转弱，但Lambda新大单提高neocloud的客户与融资竞争强度。CoreWeave长期风险仍是客户集中、高杠杆、设备残值和代际切换；公开核验受限带来小型更新漏报可能。
- **核验链接**：[CoreWeave IR](https://investors.coreweave.com/)。

### Oracle Cloud｜有料（资本市场复盘）｜E37

- **O**：窗口内研究对Oracle AI云资金结构、超长RPO与CapEx错配的复盘；不是新合同公告。
- **F**：8月31日Trefis更新Oracle AI云资本结构：收入转化节奏显著慢于建设和融资需求，客户预付和BYOH降低部分自有资本负担。Oracle Newsroom核验未见本周重大新公告。
- **D**：FY2026收入首次超过670亿美元；RPO 6380亿美元、同比+363%；从FY2026 Q4起未来12个月预计仅12%转收入，随后两年再转34%；FY2027净现金CapEx指引约700亿美元，已扣除预计200亿—250亿美元客户预付款；拟筹约400亿美元债务与股权，其中200亿美元ATM；BYOH或预付合同约750亿美元（Trefis，2026-08-31，底层财务为背景复盘）。
- **J**：Oracle的关键问题从需求验证转为融资和建设日历。CapEx高于全年收入、RPO久期长，会放大容量延迟、客户集中、债务、摊薄和利润率压力。单篇财经研究不能替代公司新披露，故不升格为本周新经营事实。
- **L**：[Trefis复盘](https://www.trefis.com/stock/orcl/articles/613728/the-bill-for-oracles-ai-build-arrived-before-the-revenue/2026-08-31)；[Oracle Newsroom](https://www.oracle.com/news/)。

### Google Cloud｜有料（产品）｜E39

- **O**：企业AI成本工具、金融/法律行业版与Kotlin SDK 1.0。
- **F**：官方月度更新聚焦代理工作负载的灵活计费与成本控制，推出Gemini Enterprise for Financial Services、Gemini Enterprise for Legal；Antigravity纳入符合条件的Gemini Enterprise订阅，并提供管理与支出控制。9月4日发布Google Gen AI SDK for Kotlin 1.0，用统一接口连接Gemini Developer API与Enterprise Agent Platform。
- **D**：本周未披露合同金额、使用量、CapEx或重大新增云合同。月度汇总页持续更新且部分段落无明确发布日期，因此仅作窗口周产品汇总；Kotlin SDK有明确9月4日日期。
- **J**：Google Cloud从模型API走向受治理的垂直行业代理平台，回应Azure的企业渠道优势。行业版和成本治理能否转成付费扩张，仍缺合同和用量证据。
- **L**：[Google Cloud月度AI更新](https://cloud.google.com/blog/products/ai-machine-learning/what-google-cloud-announced-in-ai-this-month)；[Kotlin SDK 1.0](https://cloud.google.com/blog/topics/developers-practitioners/announcing-the-google-gen-ai-sdk-for-kotlin-10-idiomatic-multiplatform-access-to-gemini)。

### Tesla Optimus｜静默｜V10

- **核验结论**：Tesla IR、AI页面、Reuters及“Tesla Optimus production September 2026”“Optimus order factory”等检索未发现窗口内新订单、量产数字、客户部署或融资。Fremont产线和2026生产预期为旧背景，不纳入。
- **判断与风险**：继续等待量产、良率、灵巧手可靠性、外部付费客户和审计数字。本周不能用演示或旧计划替代商业化证据。
- **核验链接**：[Tesla IR](https://ir.tesla.com/)；[Tesla AI](https://www.tesla.com/AI)。

### Figure AI｜静默｜V11

- **核验结论**：Figure News、Reuters和“Figure AI funding production BMW September 2026”等检索未发现窗口内新融资、订单、量产或部署；旧融资估值、BMW贡献和BotQ规划均排除。
- **判断与风险**：本周无新的商业化证据。“贡献汽车产量”不能替代利用率、收入、单位经济和外部客户验证；公开披露有限仍是核验风险。
- **核验链接**：[Figure News](https://www.figure.ai/news)。

### Unitree 宇树｜有料（资本市场）｜E41

- **O**：上市后估值快速重定价；IPO本身为窗口外背景。
- **F**：9月2日宇树股价盘中跌破550元，较8月19日上市首日1100元开盘高点约减半，市值跌破2230亿元人民币。报道同步引用公司H1财务与创始人对具身智能成熟时间的判断。
- **D**：2026H1收入11.52亿元、同比+48.54%，归母净利润2.74亿元，扣非净利润2.44亿元、同比-19.34%；这些为报道引用的背景财务。创始人称具身智能“ChatGPT时刻”可能尚需2—3年、甚至5—10年。
- **J**：本周事件是公开市场对估值和商业成熟度重新定价，而不是IPO。展示能力、规模收入和合理估值之间仍有鸿沟；低成本、高机动与开发者生态需要转化为收入质量、售后与安全责任能力。
- **L**：[Gasgoo](https://autonews.gasgoo.com/articles/news/unitree-stock-price-halves-2095127594570960896)。

### UBTech 优必选｜有料（业绩消化）｜E42

- **O**：9月1日市场对8月28日中报的完整拆解与商业化验证；财报原始发布明确为窗口外背景。
- **F**：本周精读报道显示优必选收入、毛利和全尺寸人形机器人销售显著增长；同时仍亏损，U1累计订单属于预订而非确认收入。
- **D**：2026H1收入12.69亿元、同比+104.2%；毛利5.67亿元、+160.9%，毛利率44.7%、提升9.7个百分点；净亏损3.39亿元、收窄23%；全尺寸具身智能人形机器人收入5.90亿元、+1445%，占46.5%，销量921台、+1946.7%；所有人形品类合计16123台；U1累计订单13361台（Gasgoo，2026-09-01，引用公司中报）。研发费用3.03亿元、+38.9%，研发人员1103人。
- **J**：这是具身智能中较强的量化收入证据，但必须区分工业定制收入、消费数量与预订。项目化、交付、售后成本、消费持续性和亏损是下一阶段门槛。
- **L**：[Gasgoo中报拆解](https://autonews.gasgoo.com/articles/market-industry/ubtech-reports-127-billion-yuan-in-first-half-revenue-sells-921-full-size-humanoid-robots-2094660109459607553)；[优必选IR](https://www.ubtrobot.com/investor-relations)。

### Lambda｜新增代表性企业、有料｜E40

- **O**：Anthropic据报签署350亿美元、约350MW云协议，改变neocloud竞争格局。
- **F**：Reuters 8月31日称项目使用Hut 8在得州Nueces County开发的园区，用于Claude算力；NVIDIA据称持租约，形成芯片商信用支持、数据中心建设、云运营与模型消费的合同链。Hut 8此前15年、196亿美元租约为窗口外背景。
- **D**：350亿美元、约350MW（Reuters匿名信源，2026-08-31；Bloomberg/WSJ同期交叉）。各方当时未回应，合同期限、付款、取消和投产条款未知。
- **J**：若属实，Lambda从GPU租赁升级为能承接前沿实验室园区级长期合同的neocloud，直接挑战CoreWeave并验证模型公司继续采用专用云分散容量风险。客户集中、建设、电力、芯片交付、利用率和循环交易是核心风险。
- **L**：[Reuters](https://www.reuters.com/technology/anthropic-signs-35-billion-cloud-deal-with-nvidia-backed-lambda-source-says-2026-08-31/)；[AOL授权转载](https://www.aol.com/articles/anthropic-signs-35-billion-cloud-235939000.html)；[Bloomberg](https://www.bloomberg.com/news/articles/2026-08-31/anthropic-seals-35-billion-cloud-deal-with-nvidia-backed-lambda)。

## 三条企业竞争主线

### 主线一｜前沿能力竞争已变成“能力—准入—监控—数据边界”的系统竞争

**支撑事件：E01、E04、E06、E19、E29。** OpenAI用Critical分级、Daybreak与实时监控发布Astra；Google用Fairwind把Cyber能力限于可信防御者；Anthropic用EFS把活动日志留在客户云账户；Perplexity把敏感步骤下沉Mac；Cursor则把执行环境放入客户网络但保留云端推理和控制循环。

关系判断不是“大家都重视安全”，而是**安全边界正在成为产品架构和销售边界**。五家公司提供的“私有/受控”含义不同：有的是模型访问名单，有的是日志归属，有的是本地敏感步骤，有的是客户执行面。采购方需要逐层问清推理、执行、日志、轨迹、密钥、控制面在哪里。谁能在高危能力、数据主权和误拦截之间提供可审计权衡，谁更容易进入金融、政府、医疗和关键基础设施；营销上都叫“私有”不能视为同等安全。

### 主线二｜AI资本开支进入“芯片—网络—园区—融资信用—长期客户”的联盟竞争

**支撑事件：E08、E34、E35、E36、E37、E40。** NVIDIA一边收购开发者入口，一边据报以租约参与Lambda园区链；AMD与Cisco、HUMAIN形成开放机架样板；Broadcom用定制XPU和网络获得GW级客户可见性；Oracle以预付、BYOH、债务与股权支撑超长RPO；Lambda若落实350亿美元合同，将neocloud竞争提升到园区级。

关系判断是：**算力供应商正用资产负债表、开发者分发或客户预付把未来需求锁定，竞争不再只是每卡性能。** NVIDIA拥有通用GPU和生态入口，Broadcom占定制芯片与网络，AMD押注开放第二供应源，Oracle和Lambda负责不同形式的容量融资。由此带来的新风险是循环交易、残值担保、客户集中、建设延期和远期GW计划无法兑现。资本信用会成为新护城河，也可能成为下一轮系统性脆弱点。

### 主线三｜企业Agent的利润池向“上下文、执行控制、可观测性和垂直交付”迁移

**支撑事件：E20、E23、E25、E26、E27、E29、E30、E09。** Glean争夺权限感知上下文，Databricks把Unity治理、Genie和Gateway trace合并，Cursor争夺客户执行面，Microsoft把代理嵌入确定性工作流与人工审批；Harvey和Sierra则用法律工程、Voice运营和组织级部署攻占垂直流程。

关系判断是：**通用模型逐渐成为可替换供给，真正难替换的是企业记录、权限、执行位置、故障成本和领域责任。** 平台公司可借已有数据与治理体系吸收Agent预算；垂直公司以高接触交付建立深度，但要承受长销售周期与毛利压力。未来应少看“部署客户数”，多看活跃使用、净留存、任务成功率、人工接管率和交付成本。

## 企业竞争雷达

| 维度 | 领先信号 | 本周变化 | 主要风险 | 下周验证指标 |
|---|---|---|---|---|
| 模型/平台 | OpenAI E01/E02以高低价分层和Astra树立高端能力；Google E04/E05以低价Flash+Workspace形成单位任务成本优势；Anthropic E06以客户托管安全切受监管市场 | Meta E08A用95%折扣购买工作流数据；DeepSeek E15进入开放多模态Agent | benchmark多为公司自报；高危能力误用；价格战牺牲毛利；数据换折扣的IP风险 | Astra实际开放范围与企业接入；Flash独立复测；EFS上线客户；Muse贡献者定价采用率；DeepSeek稳定性/推理成本 |
| 应用/垂直 | Sierra E20/E24拥有ARR和组织成熟度信号；Harvey E23获得企业法务与全所部署；Runway E22形成团队席位 | Perplexity E19把隐私边界编入任务；智谱 E16把Token零售化；MiniMax E18把视频推向实时连续运行 | 公司自报覆盖不等于使用；现场交付压毛利；社区实验不等于订单 | 席位/使用量、净留存、任务成功率、转人工率、Team付费升级、天猫销量与复购、实时视频单位成本 |
| 企业数据与Agent基础设施 | Databricks E26/E27、Glean E25、Cursor E29构成上下文—可观测—执行控制三层；Microsoft E09具备办公与流程入口 | 自托管/混合架构细分；平台从连接器数量转向权限、语义和运行控制 | 数据回传边界模糊；平台锁定；自有ROI评测偏差；复杂任务错误 | 轨迹和代码回传政策；第三方ROI；Gateway/Genie使用量；Glean上下文独立评测；Cursor企业定价与安全证明 |
| 算力/云 | NVIDIA E08/E34/E40兼具硬件、生态入口与融资信用；Broadcom E36定制XPU增速强；AMD E35形成开放第二供应源 | Lambda E40据报获超大合同；Azure E38以应用席位分发，AWS E10维持模型中立聚合，Google Cloud E39推行业代理 | GW规划与合同不等于投产；循环交易、客户集中、内存/封装、电力、融资成本 | Lambda各方确认与条款；Broadcom Q4兑现；AMD上线利用率；Hugging Face交割/中立措施；云合同金额、容量投产与价格变化 |
| 具身/硬件 | 优必选 E42有921台全尺寸与5.9亿元收入；字节 E12推进手机Agent量产入口；华为 E14展示NPU能效路线 | 宇树 E41上市后估值重定价；Tesla V10、Figure V11无新硬证据 | 预订不等于收入；项目化交付、良率、售后、安全；移动SoC不可外推数据中心 | 优必选预订转交付与毛利；宇树新订单和收入质量；豆包手机上市/激活；Tesla/Figure外部订单；华为第三方复刻与昇腾验证 |
| 中国企业 | DeepSeek E15、智谱 E16、MiniMax E18分别代表开放模型、MaaS零售和实时视频；Kimi E17代表潜在资本化路径 | 阿里 E11、腾讯 E13用校园权益争入口；百度 V03静默；字节 E12抢系统级入口 | 传闻估值、促销留存、亏损、模型自评、数据与终端权限合规 | Kimi港交所文件；智谱单位经济；校园福利转付费；DeepSeek独立评测；MiniMax订单；百度可量化新品/调用 |

## 下周观察点与来源口径

1. **OpenAI Astra的实际放量与安全边界**：只接受OpenAI产品页、状态页、Azure/AWS正式上架页及可核验客户公告；重点看普通企业可用范围、Daybreak准入、误拦截和监控数据政策，不用转载跑分替代产品可用性。
2. **NVIDIA—Hugging Face交易进展**：以双方公告、监管文件和正式交割信息为主；验证平台治理、排序、硬件中立、模型托管和员工留任，不把“宣布收购”写成“完成收购”。
3. **Anthropic—Lambda合同确认**：等待Anthropic、Lambda、NVIDIA、Hut 8或可核验监管/融资文件；匿名信源金额继续保留降级，重点查期限、预付、取消、租约与投产时间。
4. **Broadcom Q4与GW路线**：财务数据以公司IR/公告和法定文件为准，媒体只作交叉；区分已确认收入、季度指引、客户项目可见性和多年预测。
5. **Sierra商业化质量**：公司公告只能证明自报ARR；进一步寻找客户侧使用量、净留存、席位、语音任务成功率、人工接管和交付成本。
6. **Databricks AgentOps可复现性**：关注产品文档、客户案例和第三方实践；把内部估算与外部客户ROI分开，验证trace覆盖、工具错误率、token节省和修复时间。
7. **Kimi递表传闻**：只有港交所文件或公司正式确认才能升级；媒体的500亿美元估值、ARR和融资继续标记传闻。
8. **豆包手机与中国终端Agent**：以工信部、厂商上市公告、销售/激活及权限说明为主；关注实际发售、应用兼容、隐私授权、退货和活跃使用，不以工程机售罄推导量产成功。
9. **具身智能从预订到收入**：优必选以公司财报/交付公告验证U1订单；宇树、Tesla、Figure须提供外部客户、量产、利用率和收入硬证据，演示视频不计商业化。
10. **静默对象补核**：Midjourney、Cohere、Mistral、Scale、Cognition、CoreWeave因页面403/动态渲染/日期缺失存在漏报风险，下周仍以官网、IR、Newsroom、状态页和权威媒体交叉，不用聚合站发布日期替代原始日期。

## 本周静默、轻动态与核验风险清单

| 对象 | 状态ID | 结论 | 已核验范围 | 残余风险 |
|---|---|---|---|---|
| AWS | V01 | 自研重大动态静默；Bedrock分发有动态E10 | ML Announcements、News Blog、What’s New、Bedrock价格、OpenAI/Anthropic交叉 | 动态页更新日与未公开客户项目 |
| xAI | V02 | 生命周期与停机轻动态；无可确认重大首发 | Release Notes、News、状态报道、日期冲突排除 | 官方只标月份；新闻页403；搜索摘要冲突 |
| 百度 | V03 | 静默 | 百度新闻、文心/千帆入口、主流媒体和多组日期检索 | 未公开客户项目、搜索索引延迟 |
| Midjourney | V04 | 静默 | 官方Updates、官网、公开新闻检索 | Cloudflare 403造成漏报 |
| Cohere | V05 | 静默 | Blog、Newsroom、Events、主权AI背景日期 | 动态渲染、活动在窗口后 |
| Mistral AI | V06 | 静默 | News、条目日期搜索、旧Agentic Search排除 | News列表日期不可抓取 |
| Scale AI | V07 | 静默 | Blog、Events、CEO旧闻排除 | Blog日期不足 |
| Cognition/Devin/Windsurf | V08 | 静默 | 官方Blog、融资/客户日期检索 | 官方信息稀少、二手估值泛滥 |
| CoreWeave | V09 | 静默 | IR入口、Reuters及合同/融资/产能定向检索 | IR 403；小型更新或索引延迟 |
| Tesla Optimus | V10 | 静默 | Tesla IR、AI页、Reuters、量产/订单检索 | 公司披露有限，旧目标易被误作本周 |
| Figure AI | V11 | 静默 | Figure News、Reuters、融资/生产/BMW检索 | 旧融资和贡献口径反复转载 |
| 阿里/Qwen/夸克 | E11 | 轻动态 | 校园权益报道、Qwen博客旧模型排除 | 权益转化和留存未知 |
| 腾讯/混元/元宝 | E13 | 轻动态 | 校园权益、腾讯官网、混元官网 | 多入口分散；促销不等于使用 |

## 来源可信与现存缺口总括

- **公司自报/内部评测**：OpenAI Astra、Google Flash/Cyber、DeepSeek模型卡、Sierra ARR、Glean 1.9倍、Databricks内部节省、Cursor客户ROI、MiniMax速度均不能视为独立审计结论。
- **传闻/匿名信源**：Kimi递表及估值/ARR、Anthropic—Lambda合同结构均保留“据报道”；后者虽有多家媒体交叉，核心仍可能来自相关信源链，不能视为多份独立合同文件。
- **背景非本周**：Meta 1450亿美元CapEx、xAI Grok 4.6规格、宇树IPO与H1财务、优必选8月28日中报发布、Oracle底层财务、智谱中报、工程机M153、Hut 8旧租约等只用于解释本周事件，未冒充窗口内新发布。
- **原始页受限**：Perplexity、Midjourney、Broadcom IR、CoreWeave IR、ChinaXiv、部分媒体页面存在403/401/500；已用公司转载、权威媒体或多渠道搜索补足，但静默对象仍有有限漏报风险。
- **重复对象处理**：NVIDIA、AWS、Google Cloud、Microsoft Azure跨组重复，合并时保留不同独立事实，并按URL去重引用；不把同一公司不同事件压成一句结论。

## 固定对象覆盖总表

| 组别 | 固定对象覆盖 | 有料/静默口径 | 备注 |
|---|---:|---|---|
| A组 | 8/8 | 6家重大/战略有料；AWS平台有动态且自研静默；xAI轻动态 | NVIDIA在D组还有独立算力事实 |
| B组 | 9/9 | 8家有动态（阿里、腾讯为轻动态）；百度静默 | 华为事件为移动SoC对AI全栈外溢，不冒充昇腾新品 |
| C组 | 12/12 | 7家有料、5家静默 | 无新增对象；静默页有抓取风险 |
| D组 | 12/12 | 8家有料、4家静默 | 新增代表企业Lambda，不计入固定12家 |

四组固定对象合计覆盖41个组内席位；由于NVIDIA、AWS、Google Cloud、Microsoft Azure等跨组重复，这不是41家唯一企业。所有固定席位均已给出有料、轻动态或静默结论，实质覆盖率100%。

## 事件ID总登记与保真映射

本登记用于后续文章化时逐项检查，不能用TOP5或主线替代企业事实。E08A用于避免与既有E08冲突，仍计作一个独立事件ID；V编号为静默/状态核验ID。

| 事件ID | 企业 | 事件短名 | 状态/证据口径 |
|---|---|---|---|
| E01 | OpenAI | GPT-6 Astra与Critical网络能力 | 有料；公司原文，benchmark自报 |
| E02 | OpenAI | GPT-5.6三档分层 | 有料；公司原文 |
| E03 | OpenAI | ChatGPT Ads十亿美元年化运行率 | 有料；公司自报 |
| E04 | Google | Gemini 3.8 Flash/Cyber | 有料；公司原文，性能自报 |
| E05 | Google | Workspace与企业计费扩展 | 有料；公司/权威媒体 |
| E06 | Anthropic | EFS客户托管安全监控 | 有料；公司原文 |
| E07 | Anthropic | 安全整改、蒸馏与停机风险 | 有料；公司+媒体 |
| E08A | Meta | Muse Spark 1.3与贡献者定价 | 有料；媒体双源，缺Meta可抓取原文 |
| E08 | NVIDIA | 收购Hugging Face | 有料；公司原文+双媒体 |
| E09 | Microsoft | 企业AI流程组合 | 有料；公司原文 |
| E10 | AWS | Bedrock承接Astra/EFS | 平台动态；跨公司原文 |
| E11 | 阿里 | 夸克校园权益 | 轻动态；财经媒体 |
| E12 | 字节 | 豆包手机量产机入网 | 有料；多媒体交叉 |
| E13 | 腾讯 | WorkBuddy校园积分 | 轻动态；媒体+官网背景 |
| E14 | 华为 | 逻辑折叠量产实测外溢 | 相关动态；原论文受限、媒体交叉 |
| E15 | DeepSeek | V4多模态开放权重 | 有料；模型卡/媒体，跑分自报 |
| E16 | 智谱 | 天猫销售Coding Plan | 有料；多财经媒体 |
| E17 | Kimi | 秘密递表与融资传闻 | 传闻；公司不予置评 |
| E18 | MiniMax | H3 Max实时视频生态 | 有料；媒体/社区实测，非订单 |
| E19 | Perplexity | Hybrid Compute on Mac | 有料；官方页403、媒体交叉 |
| E20 | Sierra | CFO与2亿美元ARR阶段 | 有料；公司自报 |
| E21 | Runway | Solaris交互世界模型 | 研究动态；无可用日期 |
| E22 | Runway | Team套餐与Ruby | 有料；公司原文 |
| E23 | Harvey | 两项机构级部署 | 有料；公司/客户联合公告 |
| E24 | Sierra | Voice AI运营框架 | 有料；公司市场教育 |
| E25 | Glean | Enterprise Context定位 | 战略动态；自有评测 |
| E26 | Databricks | Genie Agents深度分析 | 有料；公司原文 |
| E27 | Databricks | AgentOps成本案例 | 有料；内部估算 |
| E28 | Databricks | Proteus kernel系统 | 研究动态；公司实验 |
| E29 | Cursor | Self-Hosted Machines | 有料；公司原文 |
| E30 | Cursor | Nokia/Basis客户案例 | 有料；客户/公司自报 |
| E34 | NVIDIA | Blackwell专业卡价格压力 | 市场动态；行业价单研究 |
| E35 | AMD | HUMAIN设施上线与扩容规划 | 有料；公司原文，远期规划降级 |
| E36 | Broadcom | FY2026 Q3及GW路线 | 有料；财报为A，远期为前瞻 |
| E37 | Oracle | AI云资金结构复盘 | 窗口内复盘；非新合同 |
| E38 | Azure | HUMAIN百万用户目标 | 有料；联合稿，目标非收入 |
| E39 | Google Cloud | 行业Agent与Kotlin SDK | 产品动态；无大单数字 |
| E40 | Lambda/NVIDIA/Anthropic | 350亿美元、350MW合同链 | 匿名信源传闻，多媒体交叉 |
| E41 | 宇树 | 上市后估值重定价 | 有料；IPO为背景 |
| E42 | 优必选 | 中报市场消化与交付数据 | 有料；原财报发布时间在窗口外 |
| V01 | AWS | 自研重大公告静默 | 多官方渠道核验 |
| V02 | xAI | 重大首发静默、轻动态 | 日期冲突与按月披露风险 |
| V03 | 百度 | 文心/千帆静默 | 官网+主流媒体核验 |
| V04 | Midjourney | 静默 | Updates 403，搜索交叉 |
| V05 | Cohere | 静默 | Blog/Newsroom/Events |
| V06 | Mistral | 静默 | News日期不可抓取 |
| V07 | Scale AI | 静默 | Blog日期不足 |
| V08 | Cognition | 静默 | 官方信息稀少 |
| V09 | CoreWeave | 静默 | IR 403+媒体搜索 |
| V10 | Tesla Optimus | 静默 | IR/AI页/Reuters |
| V11 | Figure AI | 静默 | News/Reuters |

**事件ID数量口径**：E类共39个独立事件ID（含E08A；编号存在E31—E33空缺，不虚增事件），V类11个状态ID，合计50个追踪ID。编号空缺是汇编过程保留，不代表遗漏或未披露事件。
