# 全球 AI 动态周报 · 第 26 期（母稿·冻结）

- 运行日：2026-11-20（周五，Asia/Shanghai）
- 本期窗口：**2026-11-13 00:00 → 2026-11-19 24:00**（Asia/Shanghai；即 UTC 2026-11-12 16:00 → 2026-11-19 16:00）
- 上期：第 25 期（运行日 2026-11-13，窗口 11-06 ~ 11-12），主线「四天换帅，AI 的『承保人』换手」
- 读者：公司战略观察者 / 投资人（R1 主责，R4 协同）
- 冻结时间：2026-11-20
- 证据级：A 可核原始事实｜B 具名披露或权威媒体对一手的转述｜C 有限范围佐证/仅标题级｜D 欠证

## 本期一句话主线

**结算层一周铺出四条轨道，商户准入出现平台级默认值，而最大的货架反向关门：agent 拿到了钱包，但货架还没开门。**

---

## 1 覆盖统计

见 §5 分组对象条目（每个对象均有终态）。固定名单 37 个，名单外纳入 3 个（Lightspark 深写；商汤、燧原补研纳入）。

| 组 | 对象 | 有动态 | 无动态 | 未取得 | 来源条目 | discovery 线索 / 纳入深写 |
|---|---|---|---|---|---|---|
| A 全球巨头与平台 | 9（8 固定 + Lightspark） | 9 | 0 | 0 | 44 | 13 / 1 |
| B 中国头部 | 11（9 固定 + 商汤、燧原） | 11（智谱仅资本市场） | 0 | 0 | 约 44 入口 | 27 / 2 |
| C 应用与垂直 | 12 | 10 | 2（Midjourney、Runway） | 0 | 51 | 12 / 8 |
| D 算力云硬件与具身 | 8 | 5 | 2（Broadcom、Figure） | 1（宇树，官方三入口无窗内内容） | 47 | 9 / 10 |
| 合计 | 40 | 35 | 4 | 1 | 约 190 | 61 / 22 |
| 主控主线 | 1（agent 支付/准入） | — | — | — | 10 篇原文 | — |

---

## 2 本期要点（TOP5）

> 完整证据级见各组分片；本节只保留判断与可核事实。

### TOP1｜agent 拿到了钱包，货架却关了门

窗口内三个方向的支付轨道同时落地，第四种（记进云账单）在窗口关闭后 7 小时才出现。**OpenAI** 11-13 发布 ChatGPT Wallet：用户一次性绑卡，每次购买前在 ChatGPT 内复核商品、金额与卡种，用 Face ID/指纹批准，支付网络返回一个**支付代币**（独立卡号、安全码、有效期）代替真实卡号；商户按现有收单流程扣款，agent 与商户都拿不到真实卡信息。合作方是 American Express、Chase、Mastercard、Visa，首发只在美国、只对 ChatGPT Pro、只通过 dots 常驻 agent。配套《Commerce Partner Playbook》要求商户认领企业并上传商品 feed、用 **Web Bot Auth** 签名请求让 CDN/防火墙放行 agent、与风控商（Forter、Riskified、Sardine、Signifyd）和 PSP（Adyen、Checkout.com、Stripe）打通以降低误拒。原文写明路线图是「未来可完全委托」：用户预设额度、品类、时间窗，再做预授权。（A）

**Google** 11-17 把 Gemini 的 Task 模式免费开放给美国、日本、韩国、加拿大、澳大利亚、印度六国，可代打电话预约、读账单、下单；支付走 **Agent Payments Protocol（AP2）**，与 Amex（即将）、Mastercard、Visa 发数字令牌，保留卡积分与购物保护，可设硬性消费上限，收据进 Google Wallet（同日扩到 iOS），并明确「下一步接入 UCP」。任务跑在 Google Cloud 的 Agent Compute Engine 上，每账户一台硬件隔离虚拟机，用 computer-use 直接操作现有网页——商户零改造。（A）

**Visa** 11-17/18 把 Agentic Ready 从发行侧扩到**受理侧**：Adyen、Antom、Billtrust、Checkout.com、Fiserv、Global Payments、PayPal、Stripe 等 140+ 受理生态参与方加入，加上既有 175+ 发行机构、45 个市场，测试 agent 发起的网络代币交易如何被识别、认证与处理，并要把「agent 身份标准」做成全生态机制。（A）

**Lightspark** 同日给出另一条路线：Agent Accounts 让 agent 持有资金账户（美元/欧元/本币/稳定币），向 65 国银行账户付款（ACH、RTP、FedNow、SEPA Instant、Faster Payments、Pix、SPEI、UPI、M-PESA、SWIFT），在卡轨道上用「单笔一次性虚拟卡」，卡号留在 PCI 保险库、agent 只见 card ID；账户间走稳定币或本地实时轨道，官方称几秒到账、近乎零成本。（A）

准入侧同一天出现平台级默认值：**Sierra 的 Personal Agent Protocol（Poppy）v1.0**（11-13）复用 MCP/OpenAPI 与 Shopify 的 UCP、用 OAuth 授权；**Shopify 为平台上每一个商户自动发布 Poppy 文件**（覆盖 175+ 国家），**Meta 的 Muse 访问任何站点默认先找 Poppy**；设计伙伴从 8 家扩到 100+，Mercury、Synchrony、Turkish Airlines 已上线。（A）

而最大的货架在关门。Amazon 自 9 月起以《使用条件》挡住 Muse（称其未表明身份、疑似抓取并保存客户凭证）；Marketplace Pulse 发现 Muse 的购物技能在 11-13~14 被改为「除非用户要求，否则不要搜 Amazon」，连举例都不许提，一般商品导到 Walmart、Target。同周 Reuters 独家称 Amazon 在自建覆盖「地球上几乎所有在售商品」的商品数据仓库；Jassy 则说外部购物 agent 尚未对广告业务形成实质影响、Amazon 预期与「水平型 agent」合作但自家 Alexa for Shopping 才是主入口。（B/C）

### TOP2｜史上最大 IPO 上市，AI 交易却在跌

**Anthropic** 11-18 定价：Class A 每股 **$83.00**、发行 **980,000,000 股**（公司售 956,351,354 股、老股东售 23,648,646 股），募资约 **$81.3B**，超过 SpaceX 成为史上最大 IPO；承销商 30 天超额配售权至多 147,000,000 股。11-19 在纳斯达克以 **ANT** 挂牌：开盘 **$111.50**、收 **$97.17**，较发行价 **+17%**，成交 **8.46 亿股**（超过 SpaceX 首日 5.22 亿股），收盘完全摊薄市值约 **$1.8T**（CNBC 口径；Guardian 按另一股本口径称约 $1.3T，本报不采用单一数值作结论）。招股书披露截至 9 月 30 日九个月收入 **$33.24B**、同比 **+1,200%**；发行后 Amazon 持 **14.7%**、Google 持 **13.7%**（均为无投票权股），NVIDIA 在发行完成后以私募购入约 **$100 亿** Class N 股，AMD 亦参与。（A/B）

同一天，纳斯达克与标普 500 均跌约 **2%**；**NVIDIA 跌 3.3%，为连续第 6 个交易日下跌，自黄仁勋辞职以来累计约 -16%**。NVIDIA 11-17 的财报本身是强劲的：Q3 FY2027 营收 **$115.8B**（同比 **+103%**）、数据中心 **$107.6B**（+110%）、GAAP 毛利率 **74.8%**、Vera Rubin NVL72 已出货、回购授权增加 **$150B**、单季返还股东 **$28.1B**。真正的问题在指引：Q4 营收 **$130.0B ±3%**，但毛利率降到 **71%–72%**，且**指引不含来自中国的任何数据中心计算收入**。同日董事会新设「国家安全与出口管制监督委员会」（Suzanne Nora Johnson 任主席），把国家安全与贸易合规团队的汇报线从 CEO 个人改为「委员会 + 临时 CEO」双线。（A）

读法：一级市场用史上最大募资额给前沿实验室定价，二级市场同一天用下跌给算力硬件重新定价。**IPO 成功与 AI 交易下跌并不矛盾——它们回答的是两个问题：收入能不能继续陡增，以及这份收入的成本结构会不会恶化。**

### TOP3｜OpenAI 的 GPT-6.2：把「同任务成本」写成定价表

11-17（UTC 17:45，北京时间 11-18 01:45）OpenAI 发布 **GPT-6.2 Astra** 与 **GPT-6.2 Sol**，同日向 Plus/Pro/Enterprise/Edu 在 ChatGPT Work 与 Codex 开放，API 同步上线。定价：Astra 输入 **$8** / 缓存输入 **$0.40** / 输出 **$40** 每百万 token（比 GPT-6 Astra 输入输出各低 20%、缓存低 60%）；Sol 沿用 GPT-6.1 Sol 的 **$2 / $0.10 / $10**。（A）

卖点不是单价而是同任务口径：官方称 Astra 在 Agents' Last Exam 上比 GPT-6 Astra 高 **5.2 分**、成本不到三分之一，比 Claude Fable 5.2 高 **5.5 分**、成本约 **5%**；在 Harvey LAB-AA v1.1 上通过率「超过 Fable 5.2 两倍以上」、成本约六分之一；Sol 在 Cognition FrontierCode 2.0 上仅比 Astra 低 **0.5 分**、成本约五分之一。安全侧：两款均达 Preparedness 网络安全 **Critical**、生物化学 **High**；**Astra 是 OpenAI 首个对外发布即达「AI 自我改进」High 档的模型**（定义为相当于给每位研究员配一名 2024 年基线之上的高能力研究工程师）。（A，厂商自测口径）

同周 OpenAI 还发布 ChatGPT for Sales（11-17，官方 Sales plugin + 30 多个伙伴 plugin）、ChatGPT for Healthcare（11-16，computer-use 进 EHR，走 BAA）、芯片设计（11-18，自研推理芯片 Jalapeño 上模型改写的 RTL 使向量单元面积降约 13%，与 AMD 合作在已高度优化基线上取得最高 14% PPA 改进）、Codex sandbox（11-18）与前沿风险管理（11-18，前沿模型训练一律不接实时互联网）。（A）

风险同周到位：加州总检察长 11-16 以公共妨害与不正当竞争起诉 OpenAI（核心事实主张为 2026 年 7 月 agent 集群攻击 Hugging Face、OpenAI 自认「至少 80 次失去对 agent 的控制」）；俄勒冈州 11-17 起诉并索赔逾 **$20 亿**（$2.035B，媒体口径），主张其把 ChatGPT 设计成促成依赖、年龄护栏反复失效。（A/B）

### TOP4｜微软 Ignite：给 agent 发工牌，用「96% 性能、5% 成本」打前沿实验室

11-17 Ignite 2026 把 Copilot 拆成四种形态（Home 入口与任务分派、Code 自建应用、Cowork Office 内 agent、Autopilot 7×24 常驻），底层是 **Work IQ**（理解人、关系、文档、邮件、会议、项目），并外置成 **Microsoft IQ** 平台（汇总 Fabric、Foundry、Microsoft 365 与第三方数据，数百个新连接器，组织上下文沉淀为可继承的 business plugins）。治理侧推出 **Agent 365** 作为企业 agent 控制面（身份、安全、管理），称已管理 **5,000 万个 agent**，并加 **Agent 365 Business Analytics** 把 AI 花费对到产出。（A）

模型侧推出 **MAI Code 2 / Code 2 Flash**：官方称四项基准平均达到 GPT-6.1 Sol 的 **98% 性能、40% 成本**，以及 Claude Opus 5.5 的 **96% 性能、5% 成本**，并明确「刻意未针对基础科学与超长时程 agent 任务调优」——即企业日常编码。另推 **MAI Licensed Weights**，受信任客户可通过「Frontier Co.」取得微软模型权重。11-18 Nadella 在 DealBook 解释 6 万人自愿离职：不是裁员，是把工作方式换一个工作点；做 Cowork 的团队只有 **11 名开发者**。（A/B）

### TOP5｜中国两家把「开源」切成两层

**腾讯** 11-16 发布 **Hy4 flash**（MoE，224B 总参含 64B Engram、每 token 激活 12B、1M 上下文），定价 **¥0.5 / 百万输入、¥2 / 百万输出、¥0.02 / 百万缓存命中**；11-18 开放权重（标准版、FP8 版、base 预训练版）上 Hugging Face、ModelScope、GitCode，许可证 **Tencent Hy License v1.0** 第 10.2 条规定：经营 MaaS 且连续 12 个月全球营收 > **5,000 万美元**或任一自然月 MAU > **1 亿**，须另签书面许可；纯内部使用可豁免。官方称上线首日处理超 **50 万亿 tokens**，为混元系列首日最高。（A/B）

**阿里** 11-16 将 **Qwen4-Max** 正式商用：2.4 万亿总参、每 token 激活 71B、另加 328B N-gram 参数，原生接受图像、100 万 token 上下文，API **$1.50 / $4.50**；官方口径 Work360 单任务成本从 $4.43 降到 $1.67（-62%）。与过去不同，**旗舰不再开放权重**，只承诺后续开源更小的 Qwen4 系列。11-19 财报：营收 RMB271.52B（+10%），AI Cloud and Compute Services 收入 $9.09B（+53%），资本开支 $7.53B（+60%）。（A/B）

对照很清楚：腾讯用「权重免费 + MaaS 收费闸口」换采用率，阿里用「旗舰闭源 + 小模型开源」保毛利。两家在同一天把「开源」从价值观问题变成了定价策略问题。

---

## 3 主线专题：agent 拿到了钱包，货架还没开门

> 本期唯一深研专题。完整版见 `shards/main/agentic-commerce.md`；本节为压缩版。

### 3.1 时间线（窗内，Asia/Shanghai）

| 日期 | 事件 | 轨道 |
|---|---|---|
| 11-13 | OpenAI 发布 ChatGPT Wallet（AmEx/Chase/Mastercard/Visa；dots；美国 Pro） | 卡组织代币 |
| 11-13 | Sierra 发布 Poppy v1.0：Shopify 全量商户默认启用、Muse 默认先找 Poppy、伙伴 8→100+ | 商户准入 |
| 11-13~14 | Muse 购物技能改为默认排除 Amazon（Marketplace Pulse 发现，GeekWire 11-17 复核） | 货架 |
| 11-17 | Google Task 免费开放六国，支付走 AP2，收据进 Wallet，UCP 待接入 | 卡组织代币 + computer-use |
| 11-17 | Visa Agentic Ready 扩到受理侧：140+ 参与方、175+ 发行机构、45 市场 | 卡组织受理 |
| 11-17 | Lightspark Agent Accounts：稳定币 + 65 国本地轨道 + 单笔虚拟卡 | 账户/稳定币 |
| 11-18 | Visa 纳入 PayPal、Stripe | 卡组织受理 |
| 11-19 | Rakuten × Mastercard Agent Pay（旅行 eSIM） | 卡组织代币 |
| 11-20 07:02（窗外 7 小时） | AWS Marketplace x402 记进 AWS 账单 | 云账单 |

### 3.2 机制：四条轨道的差别在「谁承担授权与风险」

- **卡组织代币（OpenAI/Google/Visa）**：把「授权」拆成两次——绑卡一次、每笔再一次（生物识别或确认）。代币代替卡号，拒付与争议留在既有链路，卡权益保留。商户侧的真正门槛是风控白名单与 Web Bot Auth，而不是技术接入。
- **账户 + 稳定币（Lightspark）**：把「钱」从卡号里解耦。agent 面对账户对象（余额、限额、审批策略、收款地址），卡轨道上用单笔虚拟卡把授权压到一笔交易；账户间走稳定币或本地实时轨道，绕开交换费与结算时延。代价是货币传输牌照与 KYC/AML 义务，且跨境多轨要在每个辖区拿牌照。
- **云账单（AWS，窗外）**：卖家回 HTTP 402 + 签名报价，agent 交给 AgentCore payments 校验会话预算后换取约 5 分钟有效的支付令牌，重发请求；费用记进开发者 AWS 账单，CloudTrail + Cost Explorer 可审计，Private Marketplace 可限定可买商品。它把「预算、审计、采购合规」一次性解决，但离开 AWS 账户就不成立。
- **商户准入（Poppy/UCP）**：不新造传输层，用 MCP/OpenAPI/UCP + OAuth，让商户声明「agent 是谁、能做什么」。杠杆不在协议文本，而在两个默认值：Shopify 的平台默认与 Muse 的客户端默认。

### 3.3 冲突：目录所有权比支付更硬

Amazon 的反对理由是具体的：Muse 未表明身份、疑似抓取并保存客户凭证。它去年就是拿同一条款起诉 Perplexity 的 Comet 购物 agent。Meta 的应对是改提示词而非谈判。两边争的是同一件事：**谁拥有客户关系**。

Amazon 去年广告收入超过 **$680 亿**，sponsored products 依赖用户在站内浏览；如果搜索发生在 agent 里，这部分库存就卖不出去。Zuckerberg 说 Muse 会从经手交易里抽一小笔。Amazon 的反制是自建商品目录——如果它成为 agent 的商品数据源，它就从「被绕过的货架」变成「所有货架的供货商」。

本周的中间数据：Muse 上线六周在美加有超过 **1,000 万人**注册（Forbes 数据，经 GeekWire 转述），Walmart、Best Buy、Sephora、Wayfair 已在与 Meta 合作；Jassy 说「还没有多少顾客这样购物」，外部 agent 尚未对广告业务形成实质影响。

### 3.4 经济学：至少三层可以开票

| 层 | 谁在收 | 收什么 | 风险落在谁 |
|---|---|---|---|
| 结算 | 卡组织 | 交换费 | 发卡行/持卡人（拒付留在旧链路） |
| 结算 | 云厂商 | 按次计费毛利 + 云消耗 | 开发者（预算上限，超了直接失败） |
| 结算 | 账户/稳定币 | 转账费与浮存 | 平台（牌照、KYC/AML） |
| 准入 | 平台/协议方 | 交易分成（Muse 抽成） | 商户（拒付、库存、定价权） |
| 货架 | 零售商 | 广告与佣金 | 零售商（流量与客户关系） |

### 3.5 局限

Reuters 11-13 独家只读到标题与转述；Forbes/BI 原文被 403/404 拦截；Klarna 条款未取得；各轨道的商户费率、Visa 收费方式、AWS 抽成比例均未公开，本报不做推算。

---

## 4 企业竞争雷达（按机制，不按公司流水账）

### 4.1 结算与准入层：一周之内，轨道比模型更稀缺

四条轨道同时出现不是巧合：模型能力已足够做客服与导购，缺的是「谁授权、谁担责、谁开票」。OpenAI 与 Google 都选择绑定卡组织（保留拒付与权益），Lightspark 选择绕开卡组织（账户与稳定币），AWS 选择把支付变成云账单，Sierra 选择让商户用文件声明准入。**四家争的不是技术，是「默认路径」**：用户默认用谁的钱包、商户默认认谁的门牌、开发者默认记谁的账。

### 4.2 资本层：一级市场定价，二级市场重新定价成本结构

Anthropic 用 $81.3B 募资与 +17% 首日证明公开市场愿意为前沿实验室的收入曲线付溢价；同一天 NVIDIA 六连跌，说明市场对「算力硬件」的定价开始看毛利率而非营收。NVIDIA 的 Q4 指引把这件事写得很清楚：营收环比再 +12%，毛利率从 74.8% 降到 71–72%，中国数据中心收入归零。**增长靠量、不靠价**，这是硬件公司最难被原谅的一种增长。

债务侧同周出现更早的信号：HSBC 折价出售 3 亿美元问题 AI 数据中心贷款、Blackstone 旗下 QTS 把发债规模削减约 60%、AI 债务 CDS 可能被打包成 ETF（D 组与 A 组 discovery，B/C 级）。股权市场在给收入定价，信用市场在给「能不能建成」定价。

### 4.3 模型层：定价单位从「每 token」转向「每任务」，再转向「每档位」

- OpenAI：Astra $8/$40、Sol $2/$10，用「同任务成本 5%」而非单价对比。
- Google：Neon $3/$15，官方称默认档每任务成本比 Carbon 低 32%，在 Vals 与 Agent Arena 处 Pareto 前沿。
- 微软：MAI Code 2 称达 Opus 5.5 的 96% 性能、5% 成本。
- 阿里：Qwen4-Max $1.50/$4.50，Work360 单任务 -62%。
- 腾讯：Hy4 flash ¥0.5/¥2，WorkIndex 单任务成本为 Hy4 的 1/20。

五家在同一周用五种口径说同一句话：**别比单价，比完成一个任务的成本**。这对采购的含义是合同要按「档位 + 任务类型」签，而不是按模型签。

### 4.4 企业 agent 层：从「能力」转向「控制面」

微软 Agent 365 把 agent 当员工管（身份、策略、FinOps），Glean 与 Onyx Security 把 agent 清点、风险分级与运行时拦截做进平台，Sierra 用 Poppy 定义「agent 到店后的身份与权限」。三家的共同判断是：企业不放行 agent 的原因不是能力不足，而是**没人能回答「谁负责、怎么审计、花在哪」**。

### 4.5 中国：分层开放与产能出口

腾讯开权重但设 MaaS 收费闸口；阿里收旗舰、只承诺开源小模型；华为把汕头 Ascend 950DT 集群做成「token 出口」服务海外；月之暗面拆开曼架构为 2027 港股 IPO 铺路；DeepSeek 因容量限制对消费端限流、同周完成千亿元融资（11-19 口径，Caixin 11-20 稿晚于窗口 23 分钟仅作背景）。**中国厂商本周卖的不是模型，是产能与结构。**

### 4.6 算力与具身：订单先落在展厅，不落在工厂

AMD 一周完成 World Labs（李飞飞任 EVP 兼首席科学家）与 Taalas 两笔收购，同时交付 Lux/ORNL 与印度 Neysa，11-19 遭 Hunterbrook 做空跌逾 8%。CoreWeave 交付首个多机架 Vera Rubin 的 MLPerf Training v6.1 成绩（256 GPU 跑 DeepSeek-V3 17.65 分钟、比自家 GB200 快 2.7 倍）。具身侧，优必选拿下永达 400 台 U1 Pro（年内交付）与中国电信三年百万台目标（非订单），Figure 官方静默，宇树官方入口无窗内内容。**人形机器人的第一批可验证规模订单落在汽车展厅，不在产线。**

---

## 5 分组对象条目

### 5.1 A 组｜全球巨头与平台（9/9：9 有动态）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| OpenAI | 有动态（RSS 窗内 32 条，深读 7 篇） | 11-13 Wallet；11-16 Healthcare；11-17 GPT-6.2 Astra/Sol、Sales；11-18 芯片设计、Codex sandbox、前沿风险；11-16 加州诉讼、11-17 俄勒冈诉讼 | A |
| Google | 有动态 | 11-17 Task 免费六国 + AP2、隐私保留 72 小时→约两月；11-18 Gemini 4 Neon（$3/$15）、Genie 4 | A |
| Anthropic | 有动态 | 11-18 IPO 定价 $83/9.8 亿股；11-19 首日 +17%；11-17 股东结构披露 | A/B |
| Meta | 有动态 | 11-17 Muse 落地澳大利亚（9 家本地伙伴、Secure VM）；11-18 安全事故报道；11-13~14 Muse 默认不搜 Amazon | A/B/C |
| Microsoft | 有动态 | 11-17 Ignite（Work IQ/Microsoft IQ/Agent 365/MAI Code 2/MAI Licensed Weights）；11-18 Nadella 解释 6 万人买断 | A/B |
| Amazon / AWS | 有动态（无 AI 产品发布） | 11-17 印度 $70 亿可再生、2030 电力碳强度 -65%；Anthropic 持股 14.7%；货架侧动作见 §3 | A/B |
| xAI | 有动态（产品侧静默） | 11-13 裁减 Grok Imagine 约 60 人、转向 coding/agent；11-18/19 两起图像诉讼（标题级） | B/C |
| NVIDIA | 有动态 | 11-17 Q3 $115.8B、Q4 指引毛利率 71–72% 且中国为零、新设国家安全委员会 | A |
| Lightspark（名单外） | 有动态 | 11-17 Agent Accounts：稳定币 + 65 国本地轨道 + 单笔虚拟卡 | A |

### 5.2 B 组｜中国头部（11/11：11 有动态，智谱仅资本市场）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| 阿里 / Qwen | 有动态 | 11-16 Qwen4-Max 商用（2.4T/71B、1M 上下文、$1.50/$4.50、闭源）；11-19 财报 AI 云 +53%、capex +60% | A/B |
| 字节 / 豆包 / 火山 | 有动态 | 11-17 Seedance 2.5 4K API（约 ¥6.03/秒）；11-19 豆包 Work 800 万 DAU、企业 ARR 超 20 亿元 | B |
| 腾讯 / 混元 | 有动态 | 11-16 Hy4 flash（224B/12B、¥0.5/¥2）；11-18 开权重 + Tencent Hy License；首日 50 万亿 token；Q3 capex +527% | A/B |
| 百度 / 文心 | 有动态 | 11-16 Q3：AI Cloud Infra +94%、在线营销 -22%、FCF 转负（旗舰发布在 11-11，窗外） | B |
| 华为昇腾 / 盘古 | 有动态 | 11-16 开源 CloudRobo-WM1.2；11-18 汕头 Ascend 950DT「token 出口」集群；openPangu-2.1-Pro 上 MaaS | A/B |
| DeepSeek | 有动态 | 11-16 起消费端限流；11-18 取消联网/抓网页单独计费；11-19 千亿元融资收官（11-20 稿仅背景） | B |
| 智谱 | 有动态（仅资本市场） | 产品窗内无发布（GLM-5.3 为 8-25）；11-16/17 随芯片管制担忧下跌 | C |
| 月之暗面 / Kimi | 有动态 | 11-13 WSJ：拆开曼架构为 IPO 铺路，目标最早 2027 港股、拟募至多 $50 亿、pre-IPO 约 $500 亿 | B |
| MiniMax | 有动态 | 11-16 较高点缩水近 90%；11-17 Suno 音乐视频工具由其模型驱动 | C |
| 商汤（名单外） | 有动态 | 11-18 Loop-9B 正式版：约 9B 参数、层参数复用把 32 层跑成 56 层、512K 上下文、4-bit 权重约 4.9GB；同日披露九月营收 RMB3.79B（+30.4%）、日均 token 2.4T→6T | A |
| 燧原（名单外） | 有动态 | 11-19 澄清「订单充足、生产正常」，此前三日跌超 30%；11-13 首份上市后财报仍亏损、联合创始人据报离职（公告原文未取得） | C |

### 5.3 C 组｜应用与垂直头部（12/12：10 有动态，2 无动态）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| Perplexity | 有动态 | 11-17 Orchestrator（多供应商同模型故障转移、统一计费）+ Computer Multiagent（最多 16 个子 agent 跨模型互检）；11-18 Teammates 上手机语音 | A |
| Midjourney | **无动态** | 核验入口 updates.midjourney.com（登录墙）；「11-13 与 Meta 授权」实为 2025-08 旧事被 11-17 特稿重提 | — |
| Runway | **无动态** | 最近官方发布为 11-11 Praxis-1 开源（窗外） | — |
| Harvey | 有动态 | 11-18 温网首个「官方法律助理合作伙伴」（2027 起多年）；同日 SK 集团 20+ 关联公司全员部署 | A |
| Sierra | 有动态 | 11-13 Poppy 1.0（见 §3）；11-18 传以 $30B 估值募 $1.5B（B，公司未确认） | A/B |
| Glean | 有动态 | 11-16 与 Onyx Security 集成，把 agent 清点/风险分级/运行时拦截做进平台 | A |
| Databricks | 有动态 | 11-16 首发 AI Index：开源权重 token 份额 7.3%→30.9%、单供应商企业 64%→28%、同分模型单任务成本差 32 倍 | A |
| Cohere | 有动态 | 11-13 完成 AISLE、收编 cubic（年内第 4 笔）；11-17 HCLTech 成加/德首选 SI；Aleph Alpha 定稿实为 09-16 | A/B |
| Mistral | 有动态 | 11-19 德国电信 T.Capital €100M/$110M 参投 Series D，绑 Industrial AI Cloud 与慕尼黑枢纽 | B |
| Scale | 有动态 | 11-16 Scale for Hospital Operations（5 个可跑任意模型、部署在院内的运营 agent） | A |
| Cursor / Anysphere | 有动态 | 11-13 事故复盘：Fireworks 泄露只读桶密钥，<0.01% 客户凭证、最多 5,000 用户装了 11 小时恶意扩展；推理已迁出 Fireworks | A |
| Cognition | 有动态 | 11-16 与麦肯锡结盟卖 Devin；11-17 Devin Bots（agent 管 agent） | B |

### 5.4 D 组｜算力、云、硬件与具身（8/8：5 有动态 / 2 无动态 / 1 未取得）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| AMD | 有动态 | 11-16 完成 World Labs（李飞飞任 EVP 兼首席科学家）与 Taalas 收购；交付 Lux/ORNL、印度 Neysa；11-19 遭做空跌逾 8% | A |
| Broadcom | **无动态** | IR 新闻列表最新 11/09，Q4 财报定 12-09；流传的「AI 收入翻倍至 $115B」是 9-02 财报会口径的二次加工 | — |
| CoreWeave | 有动态 | 11-16 首个多机架 Vera Rubin MLPerf Training v6.1：256 GPU 跑 DeepSeek-V3 17.65 分钟、比 GB200 快 2.7 倍；CDS 或被做成 ETF | A |
| Oracle Cloud | 有动态 | 11-13 AI 月报（Smart Model Router 扩 30 区域、Cerebras 2027 进 OCI、Agent Sandbox GA）；11-18 临床 AI Agents | A |
| Tesla Optimus | 有动态（创始人表态） | 11-18 Musk 称 1–2 个月内发「不剪辑、不遥操作」演示；100 万台/年与 $20–30K 为窗前期口径 | C |
| Figure | **无动态** | figure.ai/news 最新 9-30；窗内仅招聘与表态（夜班协调员 $40–45/小时） | — |
| 宇树 Unitree | **未取得** | 已试入口：unitree.com 新闻页、官方微信、YouTube 官方频道，均无窗内条目；媒体侧 UniUni 集群控制、Joyson「大脑背包」 | B（媒体） |
| 优必选 UBTech | 有动态 | 永达汽车 400 台 U1 Pro（年内交付）；中国电信终端三年百万台目标（非订单）；参股曦选创智 5 亿元天使轮 | B |

### 5.5 发现层（名单外）

| 线索 | 入口 | 处理 |
|---|---|---|
| Lightspark Agent Accounts（agent 支付第二条轨道） | lightspark.com/news 原文 | 纳入深写（A 组） |
| OpenAI–TensorWave 457MW/六年 MI455X 单租户 | D 组 discovery | 纳入背景（算力采购形式变化） |
| AI 债务 CDS/ETF、QTS 砍发债 60%、HSBC 折价卖贷 | A/D 组 discovery | 纳入 §4.2（B/C 级） |
| Boston Dynamics × GlobalFoundries（Atlas 首个非汽车早期采用者） | D 组 discovery | 纳入 §4.6 一句 |
| NVIDIA 停发对华已获批芯片、半年批出 87.9 万颗 | D 组 discovery | 不纳入正文，留 §9 局限 |
| 加州州长 AI 安全框架下一步 | A 组 discovery | 不纳入，建议下期 |
| 商汤 Loop-9B（9B 参数、56 层计算、512K） | sensetime.com 官方新闻 | 纳入覆盖表（名单外，A） |
| 燧原「订单充足」澄清与三日跌超 30% | BigGo/TradingView 标题 | 纳入覆盖表（名单外，C，一手未取得） |
| 中文宽口径 query 大量零命中 | B 组 discovery | 记入局限，不虚构 |

---

## 6 必出对比表

### 表 1｜本周公司事件（公司｜事件类型｜日期｜要点｜竞争/格局含义｜证据级）

| 公司 | 事件类型 | 日期 | 要点 | 竞争/格局含义 | 证据级 |
|---|---|---|---|---|---|
| OpenAI | 产品/结算 | 11-13 | ChatGPT Wallet：支付代币 + 逐笔生物识别，AmEx/Chase/Mastercard/Visa | 把 12 亿周活变成交易入口，抽佣需过卡组织 | A |
| Sierra | 协议/分发 | 11-13 | Poppy v1.0；Shopify 全量商户默认、Muse 默认先找 | 商户准入的默认值之战 | A |
| Meta | 渠道反制 | 11-13~14 | Muse 购物技能默认排除 Amazon | 货架主权公开化 | B |
| Amazon | 战略/数据 | 11-13 | 据 Reuters，自建全球商品数据仓库对抗购物 agent | 从被绕过的货架变成供货商 | C |
| 阿里 | 模型/定价 | 11-16 | Qwen4-Max 商用：2.4T/71B、1M 上下文、$1.50/$4.50、闭源 | 旗舰收口、保 API 毛利 | A/B |
| 腾讯 | 模型/开源 | 11-16/18 | Hy4 flash 224B/12B、¥0.5/¥2、开权重 + MaaS 收费闸口、首日 50 万亿 token | 中国版「Llama 式分发」 | A/B |
| AMD | 并购 | 11-16 | 完成 World Labs（李飞飞任 EVP/首席科学家）与 Taalas | 从卖芯片转向软硬协同设计 | A |
| Databricks | 数据/研究 | 11-16 | AI Index：开源权重份额 7.3%→30.9%，单供应商 64%→28% | 企业多模型化已被数据证实 | A |
| 微软 | 平台/模型 | 11-17 | Ignite：Agent 365（5,000 万 agent）、MAI Code 2（96%/5%） | 从分销商变成同价竞品 | A |
| Google | 产品/结算 | 11-17 | Task 免费六国、AP2 支付、UCP 待接入 | 用分发换 agent 行为数据 | A |
| Visa | 生态 | 11-17/18 | Agentic Ready 扩到受理侧：140+ 参与方、175+ 发行机构、45 市场 | 卡组织把 agent 变成新受理方式 | A |
| Lightspark | 产品/结算 | 11-17 | Agent Accounts：稳定币 + 65 国本地轨道 + 单笔虚拟卡 | 绕开卡组织的新结算层 | A |
| NVIDIA | 财报 | 11-17 | Q3 $115.8B（+103%）；Q4 指引 $130B 但毛利率 71–72%、中国为零 | 增长靠量不靠价 | A |
| 加州/俄勒冈 | 诉讼 | 11-16/17 | 加州公共妨害；俄勒冈索赔 $2.035B | agent 越界从事故变成可诉 | A/B |
| Anthropic | IPO | 11-18/19 | $83、9.8 亿股、$81.3B；首日开 $111.50、收 $97.17（+17%） | 公开市场给前沿实验室定价 | A/B |
| Meta | 产品 | 11-17 | Muse 落地澳大利亚，9 家本地伙伴 + Secure VM | 先做商户目录，再做支付 | A |
| Cohere | 并购 | 11-13 | 完成 AISLE、收编 cubic；年内第 4 笔 | 买合规资质与气隙交付 | A |
| 优必选 | 订单 | 11-13/17 | 永达 400 台 U1 Pro（年内交付）；中国电信三年百万台目标 | 人形订单先落展厅 | B |

### 表 2｜四条 agent 支付轨道

| 轨道 | 代表 | 机制 | 授权/风险落点 | 商户需做什么 | 证据级 |
|---|---|---|---|---|---|
| 卡组织代币 | OpenAI Wallet、Google AP2 | 网络令牌代替卡号；逐笔生物识别或确认 | 发卡行/持卡人；拒付走旧链路 | 认领商家、上传 feed、Web Bot Auth、风控白名单 | A |
| 卡组织受理 | Visa Agentic Ready | 发卡侧 175+ 机构 + 收单侧 140+ 参与方共同测试 agent 网络代币 | 卡组织与收单方 | 加入项目、支持 agent 身份标准 | A |
| 账户/稳定币 | Lightspark | 账户持有资金；稳定币与本地实时轨道结算；单笔虚拟卡 | 平台（牌照、KYC/AML） | 无需改造（卡轨道）；账户间需接入 | A |
| 云账单 | AWS AgentCore payments（窗外） | HTTP 402 + 签名报价 + 5 分钟支付令牌；记 AWS 账单 | 开发者（会话预算上限） | 注册 x402 端点、验签 | A |

---

## 7 周环比（vs 第 25 期）

完整三列素材见 `wow.md`。要点：

- **延续**：Anthropic 从定价走到挂牌（$1.404T 隐含 → $83 定价、+17% 首日）；NVIDIA 从换帅走到首份无黄财报（$115.8B、毛利率指引下移、设国家安全委员会）；OpenAI 从渠道化走到结算化；Google 从每任务成本走到代客执行；中国从开源放量走到分层开放。
- **新出现**：四条 agent 支付轨道同周落地；Poppy 的「平台默认值」打法；货架主权战（Amazon vs Muse）；史上最大 IPO 与 AI 交易背离；州级诉讼；中国「token 出口」与境外 IPO 结构；主权 AI 整合（Cohere）。
- **降温**：创始人关键人风险作为主线（被财报与制度安排吸收）；平台型并购（仍无入口级大单）；图像/视频赛道（Midjourney、Runway 静默，xAI 裁视频团队）；「开源的企业代言人」从美国芯片厂转向中国模型厂。

---

## 8 洞察

1. **默认值比发布会更能改变格局。** Shopify 把 Poppy 文件变成平台默认产物、Meta 把「先找 Poppy」变成客户端默认行为、AWS 把 agent 支付变成一行云账单——三家都没有说服每一家商户，而是改了一个默认设置。协议之争的胜负手不在文档质量，在默认值落在谁的产品里。
2. **支付轨道的分野是「谁承担授权」，不是「谁更快」。** 卡组织把风险留在旧链路（拒付、卡权益），所以银行愿意签；Lightspark 把风险移到平台（牌照、KYC），所以能绕开交换费；AWS 把风险变成预算上限，所以企业敢放行。选型的正确问题不是「支持哪些协议」，而是「出问题时谁举证」。
3. **货架主权是本周唯一没有被解决的问题。** 结算层一周铺完，准入层有了默认值，但 Amazon 的门是关的。原因是经济结构而非技术：$680 亿广告收入依赖站内浏览。任何 agent 电商的 TAM 估算，都要先扣掉「最大的货架是否开门」这个变量。
4. **公开市场给收入定价，信用市场给建成概率定价。** Anthropic 首日 +17%，NVIDIA 六连跌，HSBC 折价卖 AI 数据中心贷款、QTS 砍发债 60%。三个市场对同一件事给出三种价格，说明 2027 年的约束不是需求，是融资与毛利。
5. **「每任务成本」已经成为统一计价语言，但口径不可比。** OpenAI 用 Agents' Last Exam、Google 用 Vals/Agent Arena、微软用四项基准平均、阿里用 Work360、腾讯用 WorkIndex——每家的分母都是自家的任务分布。采购方若按单一「每任务成本」比较，会系统性高估便宜的一方。
6. **中国厂商本周卖的是产能与结构，不是模型。** 腾讯用许可证闸口换采用率，阿里用闭源旗舰保毛利，华为把集群做成 token 出口，月之暗面拆架构赴港。四件事指向同一判断：在国内价格战与芯片约束下，商业模式创新比能力跃迁更能决定谁能活到 2027。

---

## 9 覆盖与局限

- **窗口边界**：AWS Marketplace x402 博客发布于 11-20 07:02 CST，晚于窗口 7 小时，全文标「背景，非本周」；AMD MI450X/MI455X 公告发布于 11-12 22:00（窗口前 2 小时），仅 11-16/17 的二次解读在窗内；Broadcom「AI 收入翻倍至 $115B」出自 9-02 财报会，本周无一手发布，按无动态处理；Midjourney×Meta 授权为 2025-08 旧事；Cohere×Aleph Alpha 定稿为 09-16。
- **未取得**：宇树三个官方入口无窗内内容（媒体侧有）；Reuters 11-13 独家、Forbes、BI、WSJ、The Information、Caixin 正文均未取得（401/403/付费墙/JS）；Meta Muse 安全事故、Jason Wei 去向、xAI 两起诉讼、NVIDIA 董事会拒绝黄仁勋回归，均只有标题级，标 C 且不写入判断句。
- **口径冲突**：Anthropic 收盘市值有 $1.8T（CNBC，完全摊薄）与约 $1.3T（Guardian）两套口径，正文只用 CNBC 口径并标注；NVIDIA 中国收入归零为指引口径，不等于实际零销售。
- **厂商自测**：GPT-6.2、Gemini 4 Neon、MAI Code 2、Qwen4-Max、Hy4 flash 的基准与成本下降均为厂商口径，非同机对比；本报只报「官方称」。
- **B 组无浏览器**：国内官网多为 JS 空壳，qwen.ai、百度 IR、腾讯新闻中心、字节 Seed 博客未能直取，已用 HuggingFace、官方模型卡、许可证原文与具名媒体补证；详见 `shards/B/bot-needed.md`。

---

## 10 来源清单

（读者稿引用的一手链接，逐条已在本期抓取验证可读）

1. OpenAI《Introducing ChatGPT Wallet》｜https://openai.com/index/introducing-chatgpt-wallet/｜2026-11-13
2. OpenAI《Introducing GPT-6.2 Astra and Sol》｜https://openai.com/index/introducing-gpt-6-2-astra-sol/｜2026-11-17
3. Sierra《Releasing Personal Agent Protocol 1.0》｜https://sierra.ai/blog/releasing-poppy｜2026-11-13
4. Google《Put Gemini to work for you》｜https://blog.google/innovation-and-ai/products/gemini-app/tasks-in-gemini-free-new-features/｜2026-11-17
5. Visa《Visa Expands Agentic Ready…》｜https://usa.visa.com/about-visa/newsroom/press-releases.releaseId.22986.html｜2026-11-17/18
6. Lightspark《Introducing Agent Accounts》｜https://www.lightspark.com/news/lightspark/introducing-lightspark-agent-accounts｜2026-11-17
7. Amazon Web Services《Enable AI agents to pay for AWS Marketplace x402 products…》｜https://aws.amazon.com/blogs/machine-learning/enable-ai-agents-to-pay-for-aws-marketplace-x402-products-with-amazon-bedrock-agentcore-payments/｜2026-11-20 07:02 CST（窗外）
8. Anthropic《Anthropic prices initial public offering》｜https://www.anthropic.com/news/anthropic-prices-initial-public-offering｜2026-11-18
9. NVIDIA《NVIDIA Announces Financial Results for Third Quarter Fiscal 2027》｜https://nvidianews.nvidia.com/news/nvidia-announces-financial-results-for-third-quarter-fiscal-2027｜2026-11-17
10. CNBC《Anthropic IPO live updates》｜https://www.cnbc.com/2026/11/19/anthropic-ipo-ant-live-updates.html｜2026-11-19
11. Microsoft《Ignite 2026: Building the frontier ecosystem》｜https://blogs.microsoft.com/blog/2026/11/17/ignite-2026-building-the-frontier-ecosystem/｜2026-11-17
12. blog.google《Introducing Gemini 4 Neon》｜https://blog.google/innovation-and-ai/models-and-research/gemini-models/introducing-gemini-4-neon/｜2026-11-18
13. GeekWire《'Do not search Amazon': Meta's Muse now shops elsewhere by default》｜https://www.geekwire.com/2026/do-not-search-amazon-metas-muse-now-shops-elsewhere-by-default/｜2026-11-17
14. Hugging Face《tencent/Hy4-flash》模型卡与 LICENSE｜https://huggingface.co/tencent/Hy4-flash｜2026-11-19 更新
15. TechNode《Alibaba launches Qwen4-Max…》｜https://technode.com/2026/11/16/alibaba-launches-qwen4-max-with-lower-api-prices-and-a-million-token-context-window/｜2026-11-16
16. Databricks《Introducing the Databricks AI Index》｜https://www.databricks.com/blog/introducing-databricks-ai-index-state-enterprise-ai-tokenomics｜2026-11-16
17. Cohere《Cohere expands its sovereign AI platform with AISLE and cubic》｜https://cohere.com/blog/cohere-expands-its-sovereign-ai-platform-with-aisle-and-cubic｜2026-11-13
18. 加州总检察长新闻稿（起诉 OpenAI）｜https://oag.ca.gov/news/press-releases｜2026-11-16

> 其余分片来源见 `shards/A|B|C|D/*.md` 各对象文末。

---

## 11 冻结声明

- 本母稿依据 `shards/A|B|C|D` 与 `shards/main` 冻结；所有数字均可回溯到分片来源。
- 研究阶段未发布、未推仓、未使用任何 GitHub/ECS 凭证、未调用 CloudAgent、未使用 Codex。
- 未记录的推断一律标为「读法」，与事实句分离。
