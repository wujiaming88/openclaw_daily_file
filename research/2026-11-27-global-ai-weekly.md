# 全球 AI 动态周报 · 第 27 期（母稿·冻结）

- 运行日：2026-11-27（周五，Asia/Shanghai）
- 本期窗口：**2026-11-20 00:00 → 2026-11-26 24:00**（Asia/Shanghai；等价 UTC 2026-11-19 16:00 → 2026-11-26 16:00）
- 期号：第 27 期（上期第 26 期，运行日 2026-11-20）
- 读者：公司战略观察者 / 投资人（R1 主责，R4 协同）
- 说明：11-26 为美国感恩节休市，美股价格路径止于 11-25。

## 本期一句话主线

**供应商成了股东，资本循环开始计息**：Anthropic 以 $119.5B 完成史上最大 IPO，其中 $26.0B 由 AMD、Broadcom、Google、Micron、Microsoft、NVIDIA、TSMC 七家供应商/客户以发行价认购；四天后股价跌破 $83。同一周，黄仁勋在辞职 11 天后被董事会全票请回，标普随即把英伟达列入负面观察；CoreWeave 的无担保债收益率约 18%、CDS 破 1,300bp；而 Databricks、Sierra、Cognition 在一级市场继续抬价。**一级市场把「客户/供应商变股东」写进交易结构，二级与信贷市场开始给这个循环定价。**

## 1 覆盖统计

- 固定名单：**37 个对象**（A 8 + B 9 + C 12 + D 8），全部有终态。
- 有动态：**35**；无动态（附核验入口）：**2**（Midjourney、Glean）。
- 整体未取得：0；子项未取得 8 项（见 `shards/B/bot-needed.md`）与 3 项（见 `shards/C/bot-needed.md`）。
- 独立来源 URL：约 **120 个**（A 28 / B 24 / C 36 / D 36，含重叠）；已读全文为主，付费墙/403 均注明。
- 名单外发现：A 14 条、B 14 条、C 10 条、D 12 条、主控 19 条；纳入深写或正文引用约 20 条。
- 分组与分片：
  - A 全球巨头与平台：`shards/A/`（anthropic / openai / google / meta / microsoft / amazon / xai / nvidia + discovery + top-candidates）8/8 有动态。
  - B 中国头部：`shards/B/`（part-01 平台、part-02 模型与算力、part-03 模型公司与资产 + discovery + bot-needed）9/9 有动态。
  - C 应用与垂直：`shards/C/`（part-01 资本与单位经济、part-02 渠道地缘与垂类、part-03 主权资本与静默对象）10 有动态 / 2 无动态。
  - D 算力云硬件与具身：`shards/D/`（amd / broadcom / coreweave / oracle / embodied + discovery）8/8 有动态。
  - 主控主线：`shards/main/capital-loop.md`、`shards/main/discovery-main.md`。

## 2 本期要点（TOP5）

### TOP1｜供应商掏了 $26B 买自己的客户：Anthropic 的史上最大 IPO，四天破发

Anthropic 11-20 公告完成 IPO：以每股 $83 发行 11.27 亿股（含承销商超额配售 1.47 亿股全额行使），IPO 募资约 **$93.5B**；同日完成 **3.13 亿股 Class N、$83/股、约 $26.0B** 的同步私募，认购方是 **AMD、Broadcom、Google、Micron、Microsoft、NVIDIA、TSMC Partners**；两项合计 **$119.5B**，公司从 IPO 实收约 **$91.6B**。这不是普通的战略配售：七家既是 Anthropic 的算力供给方，也是它的渠道与股东，等于把未来几年的采购毛利提前折成股权收益。

价格随即给出另一面。11-19 首日开盘 $111.50、收 $97.17；11-20 收 $88.91；11-24 收 **$81.91**、跌 6.5%，上市第 4 个交易日跌破发行价；11-25 盘中最低 $73.85、收 $82.79。**发行端全额行使超额配售，说明一级需求仍强；二级在四天内把 22% 的产业资本配售打成浮亏**。承销商与分析师仍给 $120–150 的目标价，但市场先交易的是「谁在为这 $26B 的循环背书」。（[Anthropic IPO 交割](https://www.anthropic.com/news/ipo-close)、[CNBC 11-24](https://www.cnbc.com/2026/11/24/anthropic-stock-ipo-price.html)）

### TOP2｜辞职 11 天后，董事会全票请回黄仁勋；标普把「治理」写进了评级

11-08 黄仁勋承认婚外情，11-12 辞任，CFO Colette Kress 任临时 CEO；11-17 董事长 Harvey Jones 还拒绝恢复其职务。11-23 董事会**一致投票、立即生效**地恢复其为总裁、CEO 兼董事，理由是满意其「candor and ability to lead NVIDIA」，并在听取「美国政府在高级层面的意见」后确信回归「不构成国家安全风险」。Kress 回任 CFO，Jones 留任董事长；作为交换，董事会新设全部由独立董事组成的**国家安全与出口管制委员会**、新设首席合规官，并让涉外情报调查「进行到底」。

市场先给了 +31.48%（收 $165.05、成交 7.725 亿股、市值增加近 $1 万亿，S&P +4.74%、Nasdaq +6.51%），随后回吐，至 11-25 较周一收盘跌约 12.5%。**11-25 标普把英伟达 AA 列入 CreditWatch negative**，90 天内可能下调一档，理由直指董事任期过长、缺乏继任计划与「关键人风险」；穆迪已在 11-18 把展望从正面调至稳定。加州司法部与 SEC 的调查未结，12 月还有两场国会听证。**回归解决了经营连续性，却把「政府干预」写进了信用利差**。（[NVIDIA 新闻稿](https://nvidianews.nvidia.com/news/nvidia-board-reinstates-jensen-huang-as-president-ceo-and-board-director)、[CNBC 11-23](https://www.cnbc.com/2026/11/23/nvidia-jensen-huang-ceo.html)、[CNBC 11-26 标普](https://www.cnbc.com/2026/11/26/nvidia-market-governance-risk.html)）

### TOP3｜信贷先开价：18% 的债、1,314bp 的 CDS，与一条帖文抹去的 $191B

英伟达的回归没有缓解信用市场。11-24 至 11-25：CoreWeave 2031 年到期的 9.75% 债券收益率约 **18%**（不同时点口径 17%–19%）、5 年期 CDS 达 **1,314bp**（隐含 5 年违约概率约 68%）；Oracle 的 5 年期 CDS 升至 **355.68bp**；英伟达自身 CDS 走阔 3.4%，其披露的对外担保截至 10-25 达 **$118B**。按 PIMCO 引用的高盛口径，最大 AI 公司今年可能发债约 **$250B**，广义 AI 行业 **$300–570B**；数据中心债定价 200–300bp over 10Y，投资者拿到约 8%，而微软借款成本约 5%。微软、Amazon、Meta、Alphabet 的资本开支预计在 2026 与 2027 两年都超过经营性现金流。

同一周，客户集中度也被重新定价：11-20 郭明錤称 Google 把 2027 年 Broadcom 设计的 TPU 8i 削减约 **100 万颗（约 20%）**，主要砍高价的 8i Max，转向与 MediaTek 合作的 8t；双方未确认，Broadcom 当日仍跌 **12% 至 $306.55**（盘中口径）、市值蒸发约 **$191B**（另一报道记 -11%、$307.69，时点不同）。**股权市场给增长定价，信贷市场给「能不能建成、谁兜底」定价；一条未经证实的供应链帖文就足以让 $191B 消失，说明市场已不给「AI 收入可持续性」容错。**（[CNBC 11-24 信用](https://www.cnbc.com/2026/11/24/nvidia-jensen-huang-ai-credit-markets.html)、[CNBC 11-25 AI 债务](https://www.cnbc.com/2026/11/25/ai-debt-big-tech-spending-nvidia.html)、[Broadcom 报道](https://finance.yahoo.com/markets/stocks/articles/broadcom-stock-plunges-12-loses-191304321.html)）

### TOP4｜中国资产同周分化：华为被定罪，模型股回撤 40%，机器人还在涨停

11-24，美国纽约东区联邦陪审团裁定**华为及三家子公司有罪**，罪名包括共谋窃取商业秘密、电汇/银行欺诈、共谋违反 IEEPA 与洗钱共谋；量刑定于 2027-09-14。这与中文媒体同期「昇腾 950 卖到韩国」的叙事形成对照——后者没有客户、没有合同、华为也未确认。

资本市场上，中国 AI 资产出现清晰分层：智谱一周 **-12.3%**、较 11-11 高点回撤 **-41.3%**；MiniMax 一周 **-8.3%**、较 11-12 回撤 **-43.4%**；而同周宇树科技 **+12.9%**，11-23 涨停收 708 元、市值超 2,800 亿元（11-26 为 2,693.73 亿元，PE 约 522 倍）。**模型公司跟着全球同类一起被重定价，具身资产仍被追高**；华为判决则提醒，算力出海的公关叙事与合规现实是两条线。（[DOJ](https://www.justice.gov/opa/pr/chinese-tech-giant-huawei-and-subsidiaries-convicted-sanctions-violations-fraud-conspiracy)、行情：智谱 02513.HK、MiniMax 00100.HK、宇树 688836.SH）

### TOP5｜个人 agent 从「能聊」到「能办事」：入口战开打，货架从关门转为谈条件

字节 11-23 开启个人智能体「小豆」邀请制公测，官方产品页写明可连接抖音、飞书、日历、健康与位置，授权后可代打餐厅订座电话；11-24 豆包 App 灰度「豆包购物」，一级入口直连抖音商城。阿里「千问 Go」11-25 全面开放**免费代打电话**（订餐厅、找快递、查失物），逐次授权、通话中表明 AI 身份。海外，Meta 的 Muse 11-23 在英国上线（18+，iOS/Android/muse.ai/WhatsApp），合作方含 M&S、ASOS、Currys、Ocado、Trainline，结账走 Stripe Onelink 的 agent 专用卡或 Shop Pay；Walmart 同日把黑五接入 Muse 的 Agent Gateway，用消费上限与 Agent Profile 控权。11-25–26 传出 **Amazon 与 Meta 正在谈判解除 Muse 在 Amazon 的封锁**，议题包括赞助位如何标注、agent 订单如何归因。

一周之内，中美两家把「个人 agent」做成了 App 的一级入口，竞争点从模型能力转到**授权粒度与责任边界**：谁能让用户放心把电话、购物车和支付交出去，谁就拿到下一个分发入口。上周关上的货架门，这周开始谈条件。（[豆包小豆](https://www.doubao.com/xiaodou/)、[Meta Muse UK](https://about.fb.com/news/2026/11/introducing-muse-in-the-uk-a-personal-ai-agent-you-control/)；Walmart 接入与 Amazon-Meta 谈判据 Unite.AI 11-23、TechRepublic 11-26 报道，原文链接本次未定位）

## 3 主线专题：资本循环的四个齿轮

本期专题不再讲「agent 怎么付钱」，而是讲**为 agent 与模型提供算力的钱从哪里来、由谁承担风险**。窗口内出现的四类交易结构，指向同一个变化：AI 公司的采购价格正在从利润表搬到股权表与担保表。

### 3.1 齿轮一：供应商以发行价入股（Anthropic，$26.0B）

Anthropic 的交割公告给出完整条款：IPO 1,127,000,000 股 @ $83（公司售 1,103,351,354 股、老股东售 23,648,646 股），超额配售 147,000,000 股全额行使，IPO 毛募资约 $93.5B；同步私募 313,253,007 股 Class N @ $83，约 $26.0B，认购方为 AMD、Broadcom、Google、Micron、Microsoft、NVIDIA、TSMC Partners；合计 $119.5B，公司实收约 $91.6B。公告未披露 Class N 的投票安排、各买家认购额与锁定期。

机制：七家认购方同时是 Anthropic 的芯片、云与分发供应商。以发行价拿股，相当于把「未来算力采购的毛利」部分折成「供应商的股权收益」——对 Anthropic 是把未来 capex 提前货币化，对供应商是把「卖铲子」的收入变成「铲子公司的股东回报」，同时锁定客户。风险在四天后显形：11-24 ANT 收 $81.91（-6.5%），七家配售即浮亏；它们下一轮资本开支的账面回报开始与 ANT 股价绑定，循环从「收入—采购」扩展到「市值—采购」。

### 3.2 齿轮二：客户认股权证（AMD，3.2 亿股 @ $0.01）

11-23 AMD 向 SEC 提交 S-3ASR，登记 336,934,324 股供现有股东转售，公司不卖股、不收款。构成中含 **OpenAI 认股权证 160,000,000 股、Meta 认股权证 160,000,000 股**，行权价均 $0.01，按采购 Instinct GPU 的里程碑分批归属，首批挂钩交付首个 1GW 的 MI450 系列。以 11-24 收盘 $413.27 计，两份权证名义价值约 $1,322 亿，行权成本仅 $320 万；11-24 AMD 收跌 8.86%、成交量为三个月均值的 1.64 倍。

机制：这是「采购返利」的股权版——AMD 用极低价权证换 1GW 级采购承诺，客户拿到股价上涨的期权，代价是未来 3.2 亿股潜在稀释。与 Anthropic 互为镜像：一个是「供应商买发行人的股票」，一个是「发行人把股票期权给客户」。市场当日交易的是稀释与治理折价，不是订单。

### 3.3 齿轮三：厂商担保（NVIDIA，$118B）

CNBC 11-24 引英伟达披露：截至 10-25，公司对外担保 **$118B**。机制是英伟达为 neocloud（如 CoreWeave）的 GPU 采购/债务提供担保，使客户能以更低成本加杠杆买卡，英伟达确认收入；风险被搬到资产负债表之外，但 CDS 市场会把它算回英伟达的信用。黄仁勋回归被解读为「继续 circular financing」的概率上升（Steve Eisman 语），Stifel 的 Ruben Roy 则认为不会快速恢复对客户融资。英伟达 CFO Kress 表示将「严格评估未来投资」。

### 3.4 齿轮四：信贷定价（CoreWeave / Oracle / 行业）

- CoreWeave：9.75%、2031 年到期债券收益率约 18%（CNBC 称 >17%，Tradeweb 口径约 18%，另有接近 19%），5 年期 CDS 1,314bp、隐含 5 年违约概率约 68%；11-25 股价 -13%。
- 但同一家公司 11-25 由 Morgan Stanley、MUFG 牵头的 **$45 亿** delayed-draw 定期贷款，以「为 Meta 部署的 GPU + Meta 合同」作抵押，定价 **7%–7.5%**、预期被评为投资级。**同一借款人，无担保债 18%、项目级贷款 7%，价差 10 个百分点以上**——这是「用客户信用隔离风险」的资本结构套利。
- Oracle：5 年期 CDS 355.68bp；11-20 称 OpenAI 五年 $300B 合同「已全额融资」，融资上限 $200 亿（$100 亿股权 + $100 亿毛债务）加 $200 亿 ATM，辅以 vendor financing 与客户预付；11-23 股价 +12.34%，11-25 仍 -8%。
- 行业：PIMCO 引高盛称最大 AI 公司今年发债约 $250B，广义 AI 行业 $300–570B；数据中心债 200–300bp over 10Y；Microsoft、Amazon、Meta、Alphabet 的 capex 预计 2026、2027 两年均超过经营性现金流。

### 3.5 为什么是这周：三个触发器

1. **IPO 窗口给出了公开定价**：Anthropic 把「AI 龙头值多少钱」变成一个每日可查的数字；四天破发让所有以它为锚的一级估值需要重算。
2. **治理事件把「人」变成信用变量**：黄仁勋回归 + 标普负面观察，使「关键人风险」第一次进入英伟达的评级与利差。
3. **政策把「租」纳入管制**：BIS 11-16 宣布、11-19 生效的远程访问规则，要求 neocloud 只要有**任何**算力租给中国公司就不能买英伟达芯片（此前英伟达自设门槛是 50%）；卖家开始为原服务中国租户的 GPU 寻找新买家，数千颗 B300 被转售。供给端的政策冲击与需求端的融资成本同时上升。

### 3.6 反证：一级市场还在抬价

- **Databricks**：WSJ 11-20 称在谈约 **$225B** 估值新募「数十亿美元」，比 8 月的 $190B 高 20%；primary/secondary 与领投方均未披露；公司称 run-rate 超 $7B、Q2 同比 +80%（约 32×）。
- **Sierra**：11-23 官方 Series F **$1.75B、投后 $30B**，六个月翻倍；领投 Greenoaks 与 Lightspeed；run-rate **$400M**、五个月翻倍（约 **75×**）；官方明确按「已完成业务结果」计费、不按 token，但单价与判定口径未披露。
- **Cognition**：Bloomberg 11-20 称在谈 **$2B+、$75B**；财联社 11-25 的「$400 亿」与前者相差近一倍、疑为旧档，按 D 级并列、不采用。
- **ElevenLabs**：11-26 报道以 **$33B** 估值融资。
- **Cohere**：加拿大政府 C$16 亿投资含「罕见的私营公司直接股权」，保守党推动议会伦理审查——主权资本成为 IPO 之外的另一种资产负债表。

**结论**：公开市场按现金流与资本结构打折，私募市场仍按 run-rate 抬价；两套定价体系尚未收敛。最先感受到压力的是 IPO 窗口与公开可比公司，而不是一级市场的成交价。

### 3.7 中国侧镜像

智谱一周 -12.3%、较 11-11 高点 -41.3%；MiniMax 一周 -8.3%、较 11-12 -43.4%；宇树同周 +12.9%、11-23 涨停。模型公司跟着全球同类被重定价，具身资产仍被追高。与此同时，「去英伟达化」的表态密集出现：MiniMax 创始人称加快采用华为与阿里芯片（B），DeepSeek 传 12 月发 V4.1 Pro 并转国产芯（D），智谱称上万张国产卡进展顺利（D）。这些是表态与传闻，不是既成事实，但方向与「算力—资本」循环被美国信贷市场重新定价一致：把资本开支从美元供应链转向国内供应链，短期降单位推理成本，长期改变供应链的资本去向。

### 3.8 局限

- Class N 的投票权、各买家认购额、锁定期未披露；私募配售对 IPO 定价的影响无法量化。
- 英伟达 $118B 担保的口径（对象、期限、是否含回购承诺）仅有 CNBC 转述，未取得原始披露。
- CoreWeave 债券收益率与 CDS 为报道/盘中口径，非收盘终值；Oracle CDS 355.68 单位为 bp（报道写法）。
- Databricks/Sierra/Cognition/ElevenLabs 估值均为媒体或公司口径，未独立核实；Databricks 的 primary/secondary 结构是本条最关键的未决点。
- 标普报告原文未取得，仅 CNBC 转述；穆迪 11-18 展望调整同样为转述。

## 4 竞争雷达（按机制，不按公司流水账）

### 4.1 资本与治理：从「谁签字」到「谁付息」

上上期问「谁为资本开支签字」，上期问「谁在成交上开票」，本期问「谁为算力付利息」。三个问题对应三层结构：董事会与承销商（股权）→ 支付轨道与商户（结算）→ 银行、评级机构与供应商（信用）。本周的边际变化全在第三层：

- **股权层出现「供应商即股东」**：Anthropic $26.0B 私募、AMD 3.2 亿股客户权证，都是把采购价格折成股权；两者的区别是「供应商买发行人」与「发行人送客户期权」。
- **信用层开始给循环定价**：CoreWeave 无担保债 18% vs Meta 背书项目贷 7%；Oracle BBB 被交易成 single-B；英伟达 $118B 担保与 CDS 走阔。
- **评级层把治理纳入**：标普 AA 负面观察、穆迪展望转稳；「关键人风险」第一次成为英伟达的信用变量。
- **监管层的背景音**（背景，非本周）：美联储 11-13《金融稳定报告》称先进计算相关债务已超 **$6,800 亿**、约占非金融投资级发债 **31%**（三年前不足 6%），87% 的市场联系人把 AI 列为首要金融稳定风险（前次 50%）；含未来租约与担保的总义务可能超 **$3 万亿**。Barr 11-16 讲话、10 月 FOMC 纪要 11-18 均在此列——三项均在窗口前，本报只作背景，不当作本周事件。

### 4.2 巨头：把 agent 做成入口，也做成账单

- **OpenAI**：11-22 首席科学家 Pachocki 发文，提议用 **对数困惑度（log-perplexity）/交叉熵**作为跨实验室的「能力速度表」，在监测手段成熟前不越过共同门槛；给出自家序列 GPT-3.5 约 0.99、GPT-4 约 0.91、低于 0.80 出现网安/数学能力、约 0.76 出现突破性数学结果、下一窗口 0.68–0.7。文章没有具体阈值与执行机构，短期是话语权动作。11-23 与 Cisco 发布 **Shirudo**：基于 eBPF 的 Linux 运行时防护，签名盾牌 + TPM 度量，演示用 Codex 生成的盾牌挡住 Java4Shell。11-25 起小范围把 Chat 与 Work 合并为**单一用量表**，Instant 仍不限量，12 月扩大。11-24 官方研究给出 GPT-6 的蛋白设计湿实验：322 个 minibinder、35 个结合（10.9%），但整蛋白结构预测 TM-score 仅 0.26（ESMFold2 为 0.93），官方自认短板。资本侧：11-20 Oracle 称 OpenAI 五年 **$300B** 算力合同已全额融资；11-25 预测市场把 OpenAI IPO 推到 2027（Kalshi 2027-06 前宣布的概率从 >50% 降至约 28%）。
- **Google**：11-23 DeepMind 用 Gemini 4 agent 找更快量子算法，聚变模拟成本降 11.8×、纠错量子比特 5,650→4,338、arcsin 290×，想法先在 Lean 中形式化再进共享 notebook（A）。11-25 称 Cogentic 一天产出六篇数学论文（含整数分解 L[1/3] 算法，但对 RSA 无实际威胁），均未经同行评审、Lean 证明未公开（B/C）。产品侧 AI Mode 接入 Wallet（只读）/Drive/Gemini，购物 overlay 用截屏做跨店比价；11-20 公布 Nest app 2027-01-25 关闭、Assistant 2027-08-02 退役。芯片侧即 TOP3 的 TPU 订单转向。
- **Microsoft**：Ignite 会后核验——Agent 365 增加 FinOps、工具注册表 GA、Dynamic Agent Risk、MCP 治理；MAI-Code-2 在 GitHub GA；Copilot Autopilot 拿到独立邮箱、VM 与 Entra 身份。11-25 Nadella 称「落后三到六个月是好位置，只要花 5%–20% 的算力」，Copilot 在 OpenAI/Anthropic/MAI 间自动路由。11-24/25 披露对 11-12–13 持续约 24 小时的全球中断启动「Code Red」（本周新披露的历史事项）。
- **Amazon**：11-22/23 收购 Decart 的优化栈（DOS）与团队，媒体称 **$7.5B**，资产/团队而非股权，现金+股票、大部分递延、创始人留任 5 年，不含世界模型；目的是用软件抹平 Trainium 与 NVIDIA 的差距。11-20 07:02 CST 的 **AWS Marketplace x402 / AgentCore payments** 博文本期入窗：agent 按次购买，HTTP 402 签名报价 + 5 分钟支付 token，结算进 AWS Billing，默认会话预算 $0.05、单请求上限 $0.02。11-24 Bedrock Trusted Access API GA（EFS 模式客户自持 KMS/S3，provider 不访问数据）。
- **Meta**：Muse 英国上线（11-23，18+，独立云 VM，Onelink/Shop Pay 结账）；Walmart 黑五接入 Agent Gateway（登录 handoff、消费上限）；Amazon-Meta 谈解除封锁（11-25/26，未达成）；Muse 经 Android 通知权限与 macOS 辅助功能读到 Signal 聊天（Reuters 11-18 报道、窗内转述）；Meta 拒绝英国 FCA 的联合沙箱测试（11-25 Wired）。
- **xAI**：弗吉尼亚、俄勒冈两州 11-23 依消费者保护法起诉 X/xAI/SpaceX，指 Grok 生成 CSAM 与报复色情；诉状引用 CCDH 研究称 2025 年 12 月下旬 8 天内 X 上出现约 300 万张性化图像、其中 2.3 万张涉儿童。x.ai 官网窗内 403，公司未置评。

### 4.3 中国：开源三连、入口战与「算力换轨」

- **开源密集**：百度 11-24 以 Apache 2.0 开源文心 5.5 Flash Preview（280B 总参/14B 激活、1M 上下文、FP4 专家权重）；腾讯 11-24 Hy-MT3（102 语言）、11-25 Hy4 flash GGUF（220B 可跑 64GB 终端）、11-26 DFly2（草稿层复用 KV/索引，长文最高 4.2×）；智谱 11-23 GLM-5.4（750B、28 层 Loop Transformer 跑两遍，官方称可比 2T–3T 模型）。
- **入口战**：字节小豆（11-23）、豆包购物（11-24）、千问 Go 免费代打电话（11-25）——三家都把「代办」做成一级入口，授权与责任条款均未披露。
- **算力换轨**：MiniMax 创始人称加快采用华为与平头哥（B）；DeepSeek 传 12 月 V4.1 Pro 转国产芯（D）；智谱称上万张国产卡（D）。华为 11-24 被美国联邦陪审团定罪，量刑 2027-09-14；「昇腾 950 卖到韩国」无客户/合同/官方确认（D）。
- **资产定价**：智谱 -12.3%（较高点 -41.3%）、MiniMax -8.3%（较高点 -43.4%） vs 宇树 +12.9%（11-23 涨停）。

### 4.4 应用层：按结果计费，还是按算力限流

- **Sierra**：$1.75B @ $30B，ARR >$400M（约 75×）；官方明确按「已完成的业务结果」计费（problem resolved / loan originated 等），不按 token；单价与判定口径未披露。
- **Databricks**：$225B 估值谈判（vs 8 月 $190B），run-rate >$7B（约 32×）；primary/secondary 未明，Ghodsi 明确回避当前周期 IPO。
- **Cognition**：SWE-2.1 官方发布（FrontierCode 2.0 41.3 等，厂商口径），关键在「pure RL on Kimi K3」——中国开源底座；融资传 $2B+ @ $75B。
- **Cursor**：向国会称「探索淘汰 PRC 开源权重模型」，而 Composer 2 基于 Kimi K2.5；报告自估替换最长 6 个月、强制切换会抬高成本。与 Cognition 构成同一供应链上的两种相反策略。
- **Perplexity**：Time Machine 的 `snapshot_as_of` 支持最长 365 天时点检索（Search API $5/1k、Context API $1/1k）；Pro 的 Computer 改为每周配额 + effort 分级。
- **Harvey**：用后训练把 Meta Muse Spark Open 在 Legal Agent Bench 的 all-pass 推到 30.3%（首个破 30%），每任务输出 token 少 36%。
- **Runway**：11-22 发布 Praxis-1 开源世界动作模型（Apache 2.0、27B，RoboLab-120 成功率 46.2%），从视频生成跨到机器人基础模型。
- **Cohere**：加拿大 C$16 亿投资含直接股权，议会伦理审查启动；主权资本成为 IPO 之外的资产负债表。
- **Midjourney、Glean**：窗内无官方动态（Midjourney 官网 403、已试 3 入口；Glean 博客最新 11-19）。

### 4.5 算力与具身：订单、指数与演示

- **AMD**：S-3ASR 3.37 亿股上架（含 OpenAI/Meta 各 1.6 亿股权证），11-24 -8.86%；同日微软在 Azure 接收首套 **Helios** 机架级系统（MI455X + Venice + Pensando + ROCm，validation 非量产）。
- **Broadcom**：TPU 订单转向 MediaTek，-11%～-12%、-$191B；FY27 $115B 目标是 9-02 口径，12-09 财报是验证点。
- **CoreWeave**：$45 亿 Meta 相关贷款 7%–7.5%、预期投资级；无担保债 18%、CDS 1,314bp；Q3 净利息 $8.46 亿、Q4 指引超 $10 亿。
- **Oracle**：$200 亿融资（8,620 万股 @ $116 + $100 亿票据 7.000%–8.650%）到账，称 OpenAI 合同全额融资；CDS 356bp。
- **Tesla**：AI5 专供 Optimus、汽车留 AI4；11-25 在德国 EMAG 总部注册实体（HRB 315756），拟接收约 220 名工艺人员做柔轮/波发生器；本周无 Optimus 订单/售价/产量。
- **Figure**：41 秒「苹果测试」视频回应 Musk，宣称 zero-shot、全自主；未排除遥操作、无第三方验证。
- **宇树**：11-23 涨停 708 元、市值超 2,800 亿；11-26 收 666 元、市值 2,693.73 亿、PE 约 522×；王兴兴称 5–10 年中国机器人年产量超 2,000 万台，并预警上市后利润可能下滑。
- **优必选**：获纳入恒生科技指数（12-07 生效），摩根大通上调至增持；11-23 的「400 台订单」为上期永达订单复盘，非新增。

## 5 分组对象条目（覆盖表与要点）

### 5.1 A 组｜全球巨头与平台（8/8 有动态）

- **OpenAI｜有动态**：Perplexity 减速线提案（11-22，A）；Shirudo（11-23，A）；GPT-6 蛋白设计（11-24，A）；Chat/Work 合并计费（11-25，B）；广告不做 prompt 级报告（11-25，B）；OpenWorks（11-22/24，B）；Oracle 称 $300B 合同全额融资（11-20，B）；IPO 预期后移至 2027（11-25，B）；Athena 未取得（D）。
- **Google DeepMind / Gemini｜有动态**：量子算法 agent（11-23，A）；Cogentic 六篇数学论文（11-25，B/C）；AI Mode 接入 Wallet/Drive（11-23，B）；购物 overlay（11-25，B）；Nest/Assistant 退场（11-20，B）；TPU 订单转 MediaTek（11-20，B）；DeepMind agent 接管部分算力（11-25，C）。
- **Anthropic｜有动态**：IPO 交割 $119.5B（11-20，A）；四日破发（11-24，B）；创始人减持合计 $560.8M（11-23/24，B）；Siren 蜜罐评测（11-24，B）；Messages API 迁 Rust（11-25，B）；Amodei 否认「交出自由意志」（11-25，C）。
- **Meta AI｜有动态**：Muse 英国上线（11-23，A）；Walmart Agent Gateway（11-23，B）；Amazon-Meta 解封谈判（11-25/26，B）；Signal 读取事件（11-18 报道、窗内转述，B）；拒绝 FCA 联合测试（11-25，B）。
- **Microsoft｜有动态**：Ignite 会后核验（11-17/25，A/B）；Autopilot 独立身份（11-23，B）；Nadella「落后六个月」（11-25，B）；Code Red（11-24/25，本周新披露的历史事项，B）；Copilot without M365 未取得（D）。
- **Amazon / AWS｜有动态**：Decart 优化栈与团队（11-22/23，B，$7.5B）；AWS Marketplace x402/AgentCore payments（11-20 07:02 CST，A/B）；Bedrock Trusted Access API GA（11-24，B）；AWS 品牌对 agent（11-24，B）；$220B capex 访谈未取得（D）。
- **xAI｜有动态**：弗吉尼亚/俄勒冈两州起诉（11-23，B）；x.ai 官网 403，公司未置评；「11-22 起诉/DOJ/科罗拉多」线索未核实（D）。
- **NVIDIA｜有动态**：黄仁勋复职（11-23，A）；+31.48%、市值增近 $1 万亿（11-23，B）；BIS 远程访问规则传导（11-19 生效，B）；暂停对东南亚四国发服务器（11-26，B）；对华许可记录 87.9 万颗（11-20，B/C）；UBS 中国芯片 2030 年增近六倍（11-24，B）。

### 5.2 B 组｜中国头部（9/9 有动态）

- **阿里 / Qwen｜有动态**：千问 Go 11-25 全面开放免费代打电话，逐次授权、表明 AI 身份（B，IT之家；官方未取得）。
- **字节 / 豆包 / 火山｜有动态**：小豆 11-23 邀请制公测（官方页 A）；豆包购物 11-24 灰度、一级入口直连抖音商城（B）。
- **腾讯 / 混元｜有动态**：Hy-MT3 11-24（A，GitHub）；Hy4 flash GGUF 11-25（A/B）；DFly2 11-26（B）；「12-01 全员默认 HY4」为 D。
- **百度 / 文心｜有动态**：文心 5.5 Flash Preview 11-24 开源（280B/14B、Apache 2.0、1M 上下文，A，HF 模型卡）。
- **华为 / 昇腾｜有动态**：11-24 美国联邦陪审团裁定华为及三家子公司有罪（A，DOJ），量刑 2027-09-14；「昇腾 950 卖到韩国」无客户/合同/官方（D）。
- **DeepSeek｜有动态（间接）**：V4.1-Flash 权重已在社区流通（A）；V4.1 Pro 12 月发布、增值电信均为 D。
- **智谱｜有动态**：GLM-5.4 11-23（A，docs）；发布次日 -6.23%、第三日 -15.05%，一周 -12.3%、较高点 -41.3%（A，行情）；GLM-5.5 延期传闻与否认（D）。
- **月之暗面 / Kimi｜有动态（一手部分）**：官方文档列 kimi-k3.1-pro、1M 上下文、Batch 六折（A）；百炼上架 Prime 变体仅标题级（D）。
- **MiniMax｜有动态**：H3 Family 按秒定价 $0.08/$0.04/$0.025 每秒、H3-Image $3.80/$7.60 每百万 token（11-26，A）；开源百日 1,472 个衍生、1.48 亿下载（B）；创始人称加快用华为/平头哥（B）；Talkie 被苹果下架（B）。

### 5.3 C 组｜应用与垂直（10 有动态 / 2 无动态）

- **Sierra｜有动态**：$1.75B @ $30B（11-23，A）；ARR >$400M、按结果计费（A）；约 75×（算术）。
- **Databricks｜有动态**：$225B 估值早期谈判（11-20 WSJ，B）；primary/secondary 未明（D）。
- **Cognition｜有动态**：SWE-2.1 11-24（A）；pure RL on Kimi K3（A）；融资 $2B+ @ $75B（11-20 Bloomberg，B）；$40B 为 D。
- **Cursor / Anysphere｜有动态**：向国会称探索淘汰 PRC 开源权重（11-20，C）；Composer 2 基于 Kimi K2.5（C）。
- **Harvey｜有动态**：11-24 后训练研究，Muse Spark Open LAB all-pass 30.3%、token -36%（A）；iManage 双向同步、信息治理（11-20，A）。
- **Perplexity｜有动态**：Time Machine（11-25，A）；Pro 每周 Computer 配额（11-25，A）。
- **Runway｜有动态**：Praxis-1 开源世界动作模型（11-22，A；27B/46.2% 为 B）。
- **Cohere｜有动态**：C$16 亿投资含直接股权、议会伦理审查（11-26，C）；官方窗内静默。
- **Mistral｜有动态**：Large 4 官方页（A）；Dense200 42% vs GPT-6 Astra 41% 为厂商自报（C）；Cloudera 主权 AI 集成（11-24，C）。
- **Scale AI｜有动态**：红队研究称某未命名开放权重模型 44% 违规（11-24，A；主体 D）。
- **Glean｜无动态**：博客最新 11-19；Glean×Onyx 实为 11-13（窗外）。
- **Midjourney｜无动态**：官网/文档 403（已试 3 入口），媒体无窗内官方发布。

### 5.4 D 组｜算力云硬件与具身（8/8 有动态）

- **AMD｜有动态**：S-3ASR 3.37 亿股（11-23，A）；OpenAI/Meta 各 1.6 亿股权证 @ $0.01（A）；11-24 -8.86%（B）；微软首套 Helios（11-23，A）。
- **Broadcom｜有动态**：Google 削减 2027 TPU 8i 约 20%（11-20，B）；-11%～-12%、-$191B（B）；FY27 $115B 为 9-02 口径。
- **CoreWeave｜有动态**：$45 亿 Meta 相关贷款 7%–7.5%、预期投资级（11-25，B）；无担保债 18%、CDS 1,314bp（B）；11-23 +22%、随后回吐。
- **Oracle｜有动态**：$200 亿融资完成、称 OpenAI 合同全额融资（11-20，B）；CDS 356bp、11-25 -8%（B）。
- **Tesla Optimus｜有动态**：AI5 专供 Optimus（11-22，B）；德国 EMAG 实体与约 220 人（11-25，B/C）；无订单/售价/产量。
- **Figure｜有动态**：41 秒苹果视频（11-23，B）；未排除遥操作、无第三方验证（C）。
- **宇树｜有动态**：11-23 涨停 708 元、市值超 2,800 亿；11-26 666 元、2,693.73 亿、PE 约 522×（A/B）；王兴兴产量预测与利润预警（B）。
- **优必选｜有动态**：纳入恒生科技指数（12-07 生效，B）；摩根大通上调至增持（B）；「400 台订单」为上期复盘，非新增。

## 6 必出对比表｜本周公司事件

| 公司 | 事件类型 | 日期 | 要点 | 竞争/格局含义 | 证据级 |
|---|---|---|---|---|---|
| Anthropic | IPO 交割 | 11-20 | 11.27 亿股 @$83，IPO $93.5B；同步私募 $26.0B 由 AMD/Broadcom/Google/Micron/Microsoft/NVIDIA/TSMC 认购；合计 $119.5B | 供应商成为股东，采购毛利折成股权收益 | A |
| Anthropic | 二级市场 | 11-24 | 收 $81.91（-6.5%），上市第 4 日破发；11-25 盘中低 $73.85 | 一级需求强、二级承接弱；$26B 配售浮亏 | B |
| NVIDIA | 治理 | 11-23 | 董事会全票恢复黄仁勋为总裁/CEO/董事，即刻生效；新设国家安全与出口管制委员会、CCO；调查继续 | 政府意见进入董事会决议；治理风险未出清 | A |
| NVIDIA | 评级 | 11-25 | 标普 AA 列入 CreditWatch negative，90 天内或降一档；穆迪 11-18 展望转稳 | 「关键人风险」首次进入信用定价 | B |
| Broadcom | 客户订单 | 11-20 | 郭明錤称 Google 削减 2027 TPU 8i 约 100 万颗（~20%），转 MediaTek 8t；AVGO -11%~-12%、-$191B | 定制 ASIC 的客户集中度被公开定价 | B |
| CoreWeave | 融资/信用 | 11-25 | $45 亿 Meta 相关 GPU 抵押贷款，7%–7.5%、预期投资级；无担保债约 18%、CDS 1,314bp | 同一借款人两种信用，价差 10pct+；neocloud 分层 | B |
| AMD | 股权/资本 | 11-23 | S-3ASR 登记 3.37 亿股，含 OpenAI/Meta 各 1.6 亿股权证 @$0.01、按 1GW 交付归属；11-24 -8.86% | 客户即股东；稀释压制估值 | A |
| Amazon | 并购 | 11-22/23 | 收购 Decart 优化栈与团队，媒体称 $7.5B；资产/团队、现金+股票、递延、留任 5 年 | 云厂用并购补芯片软件栈，对标 Trainium | B |
| Amazon | 产品 | 11-20 | AWS Marketplace x402 + AgentCore payments：HTTP 402 签名报价、5 分钟 token、结算进 AWS Billing | agent 按次付费进入企业账单；零售端仍封 agent | A/B |
| OpenAI | 产品/安全 | 11-23 | 与 Cisco 发布 Shirudo：eBPF 运行时防护、签名盾牌 + TPM | agent 从写代码到部署内核级防护 | A |
| Google | 研究 | 11-23 | Gemini 4 agent 找量子算法：聚变 11.8×、arcsin 290×；Lean 形式化验证 | agent 产出进入可验证科研流程 | A |
| Meta | 产品/合作 | 11-23 | Muse 英国上线；Walmart 黑五接入 Agent Gateway（消费上限、Agent Profile） | 社交分发转 agent 分发；支付用代理卡 | A/B |
| 字节 | 产品 | 11-23/24 | 小豆邀请制公测（抖音/飞书/日历/位置授权、代打电话）；豆包购物灰测直连抖音商城 | 个人 agent 成为 App 一级入口 | A/B |
| 阿里 | 产品 | 11-25 | 千问 Go 全面开放免费代打电话，逐次授权、表明 AI 身份 | 用免费换授权习惯；成本承担未披露 | B |
| 华为 | 法律 | 11-24 | 美国联邦陪审团裁定华为及三家子公司有罪（窃密、欺诈、IEEPA、洗钱共谋）；量刑 2027-09-14 | 海外合规风险上升，与「昇腾出海」叙事相反 | A |
| 智谱 | 产品/市场 | 11-23 | GLM-5.4：750B、28 层 Loop 跑两遍、1M 上下文；一周 -12.3%、较高点 -41.3% | 架构创新未托住估值 | A |
| Sierra | 融资 | 11-23 | $1.75B Series F @$30B；ARR >$400M；按结果计费 | 应用层头部仍被追高（约 75×） | A |
| Databricks | 融资 | 11-20 | 约 $225B 估值早期谈判（vs 8 月 $190B）；结构未明 | 一级与二级定价背离 | B |
| 宇树 | 市场 | 11-23 | 涨停 708 元、市值超 2,800 亿；11-26 2,693.73 亿、PE 约 522× | 具身资产仍按叙事/产能定价 | A/B |
| 优必选 | 指数 | 11-21/24 | 纳入恒生科技指数（12-07 生效）；摩根大通上调至增持 | 被动资金与卖方评级同步 | B |

## 7 周环比（vs 第 26 期）

| 主线 | 第 26 期（11-13~19） | 第 27 期（11-20~26） | 走向 |
|---|---|---|---|
| Anthropic 上市 | 11-18 定价 $83；11-19 首日 +17%、收 $97.17 | 11-20 交割 $119.5B（含 $26B 供应商私募）；11-24 收 $81.91 破发 | 延续并反转 |
| NVIDIA 治理 | 黄仁勋 11-12 辞任，董事会四天换帅，11-17 拒绝恢复 | 11-23 全票请回、+31%；11-25 标普负面观察 | 反转：制度回到关键人，代价是评级 |
| agent 支付/货架 | 四条轨道落地；Amazon 关门、Muse 默认不搜 Amazon | 无新轨道；AWS x402 博文入窗；Amazon-Meta 谈解封；Walmart 接入 | 从铺轨转向入口与谈判 |
| 前沿模型 | GPT-6.2、Gemini 4 Neon 同周 | 无新前沿模型；开源小模型密集（文心 5.5 Flash、Hy-MT3、GLM-5.4） | 降温：注意力转向资本与入口 |
| 中国开源 | 腾讯 Hy4 flash 开权重设闸口、阿里 Qwen4-Max 闭源 | 百度 Apache 2.0 开源 280B、腾讯 GGUF/DFly2、智谱 Loop 架构 | 延续：开源作为获客与生态手段 |
| 中国资产 | 智谱、MiniMax 受 Anthropic IPO 冲击下跌 | 智谱 -12.3%（高点 -41.3%）、MiniMax -8.3%（高点 -43.4%）vs 宇树 +12.9% | 分化：模型降、具身升 |
| 具身 | 订单落在展厅 | 宇树涨停/高 PE；优必选入指数；Tesla 买工艺；Figure 演示争议 | 资产化，但订单仍稀缺 |
| 一级市场 | Anthropic 一个标尺 | Databricks $225B、Sierra $30B、Cognition $75B、ElevenLabs $33B | 抬价延续，与二级背离 |

一段收束：上期的主线是「结算层铺轨、货架关门」，本期的主线换成「谁为铺轨的钱付息」。轨道的数量没有增加，账单的利息开始出现——Anthropic 破发、英伟达被列入评级观察、CoreWeave 的债与 CDS 同时创纪录、Broadcom 因一条客户订单传闻蒸发 $191B。**签字的人、开票的人都已就位，接下来要看的是现金流能不能覆盖资本成本。**

## 8 洞察

1. **「客户即股东」正在成为 AI 资本开支的默认结构**：Anthropic 让供应商以发行价买 $26B，AMD 给客户 $0.01 行权价的 3.2 亿股权证，英伟达为 neocloud 提供 $118B 担保。三者的共同点是把采购价格从利润表移到股权表/担保表，短期让买方「买得起」、卖方「确认收入」，长期把双方的市值与信用绑在同一根绳上。
2. **信用市场比股市更早给出约束**：同一周 NVDA +31%、ANT 破发、CoreWeave 债 18%/贷 7%。股权在交易叙事，信用在交易「能不能建成、谁兜底」。当标普把治理写进评级，AI 资本链的加权资本成本会整体上移。
3. **一级与二级的定价体系尚未收敛**：Databricks 32×、Sierra 75×、Cognition 传 $75B，而公开市场 AI 资产自 6 月高点回撤 25%–45%。若 IPO 窗口继续关闭，私募 mark 的滞后调整会在下一轮融资或退出时集中体现。
4. **中国的「去英伟达化」是资本决策，不只是技术决策**：MiniMax 公开表态、DeepSeek 传闻、智谱称国产卡——在美国信贷与出口双重收紧下，把 capex 转向国内供应链，等于把资本去向从美元体系里拿出来；但本周多为表态，不能当既成事实。
5. **个人 agent 的护城河是授权与责任，不是模型**：小豆、豆包购物、千问 Go、Muse 都在解决「让 agent 代打电话/下单，但拿不到支付凭证、出错有人负责」。谁能把授权粒度、审计与赔付做成标准，谁就拿到入口。
6. **具身资产与模型资产的定价逻辑分叉**：模型公司按 token/秒计价、可被价格战压缩；机器人公司按台交付、锚在订单与产能。宇树的 522× PE 与智谱的 -41% 是同一枚硬币的两面——账单先到期在「卖 token」的公司身上。

## 9 覆盖与局限

### 9.1 覆盖
- 固定名单 37 个对象全部有终态；有动态 35、无动态 2（Midjourney、Glean），无「整体未取得」对象。
- 名单外纳入正文/一句话：ElevenLabs（$33B 融资）、CrowdStrike×Zscaler（$43.9B 并购）、Nebius/IREN（neocloud 信用）、MediaTek（TPU 8t）、Signal（限制截图）、FTC（AI 安全调查）、美联储金融稳定报告（背景）、Cohere 主权资本。
- 每组 discovery.md 均已落盘（A 14 / B 14 / C 10 / D 12 / 主控 19）。

### 9.2 未取得与已试入口
- **xAI 官网**：news/、/、/blog 均 403；两州诉讼仅具名媒体（CyberScoop、The Record）。
- **AWS Marketplace x402 官方博客**：正文两次抓取仅返回导航；机制来自 Unite.AI 与 The Register 全文（A/B）。
- **付费墙**：WSJ（Databricks、BoE）、Bloomberg（CoreWeave 贷款、Cognition）、FT（Anthropic 破发）、The Information（Athena）、Business Insider（AWS CFO）均未取得原文，用 Reuters/TechCrunch/PYMNTS/TNW 同事件报道替代。
- **中国官网**：qianwen.com、hunyuan.tencent.com、z.ai/blog、36kr 为 JS 空壳/反爬；阿里、字节商业条款仅具名媒体（IT之家、界面、财联社、36Kr）。
- **X 原帖**：Musk 关于 Optimus/AI5、Adcock 关于 Figure、Musk 关于 Cursor 的帖子均为媒体逐字转述，未取得原帖。
- **Decart 官方新闻稿**：未定位；金额与结构据 Calcalist/TechCrunch（B）。

### 9.3 口径冲突与处理
- **Broadcom 跌幅**：-12% 至 $306.55（Yahoo/24-7，下午 1:43 口径）与 -11% 至 $307.69（另一 24-7 稿）并存；正文写「-11%～-12%」。
- **Anthropic 11-20 收盘**：Yahoo 历史行情 $88.91；24/7 Wall St. 称 $88.30；差 $0.61，未解，正文不引用该日精确收盘。
- **CoreWeave 债券收益率**：CNBC >17%、Tradeweb 约 18%、另有接近 19%；正文写「约 18%（17%–19%）」。
- **Cognition 估值**：Bloomberg $75B vs 财联社 $40B（疑旧档）；采用 $75B（B），$40B 列 D，不入结论。
- **华为对华许可**：「58 万颗售予军方关联企业」与「87.9 万颗（NVIDIA+AMD、半年）」口径不同，未合并；后者按 B/C。
- **优必选 400 台**：为上期永达订单复盘，非本周新增，正文不写为新增订单。
- **Tesla $30K**：为 11-06 Baron 会议的制造成本口径（窗外），不是售价/租金，正文不用。
- **AMD「OpenAI 改进 GPU 设计 14%」**：原始出处未定位，C 级，不入正文。

### 9.4 其他局限
- 厂商自测/自报：GPT-6 蛋白设计、Gemini/Cogentic 数学结果、Cognition SWE-2.1、Harvey LAB、Mistral Dense200、Scale 44% 均为厂商口径；读者稿统一写「官方称/公司称」。
- 私募配售与权证的锁定期、投票权、各买家金额未披露；英伟达 $118B 担保口径仅有转述。
- 美联储报告（11-13）、Barr 讲话（11-16）、FOMC 纪要（11-18）均在窗口前，只作「背景，非本周」。
- 11-26 美股休市，所有美股价格止于 11-25。

## 10 来源清单（主要）

- Anthropic｜IPO 交割公告｜https://www.anthropic.com/news/ipo-close｜2026-11-20｜全文
- Anthropic｜IPO 定价公告｜https://www.anthropic.com/news/anthropic-prices-initial-public-offering｜2026-11-18｜全文
- CNBC｜Anthropic 跌破发行价｜https://www.cnbc.com/2026/11/24/anthropic-stock-ipo-price.html｜2026-11-24｜全文
- CNBC｜黄仁勋复职与市场｜https://www.cnbc.com/2026/11/23/nvidia-jensen-huang-ceo.html｜2026-11-23｜全文
- NVIDIA｜董事会复职新闻稿｜https://nvidianews.nvidia.com/news/nvidia-board-reinstates-jensen-huang-as-president-ceo-and-board-director｜2026-11-23｜全文
- CNBC｜标普负面观察｜https://www.cnbc.com/2026/11/26/nvidia-market-governance-risk.html｜2026-11-25/26｜全文
- CNBC｜AI 信用与 CDS｜https://www.cnbc.com/2026/11/24/nvidia-jensen-huang-ai-credit-markets.html｜2026-11-24｜全文
- CNBC｜AI 债务与 capex｜https://www.cnbc.com/2026/11/25/ai-debt-big-tech-spending-nvidia.html｜2026-11-25｜全文
- CNBC｜科技股回吐｜https://www.cnbc.com/2026/11/25/nvidia-ai-stock-tech-selloff.html｜2026-11-25｜全文
- CNBC｜远程访问规则与转售｜https://www.cnbc.com/2026/11/25/nvidia-china-ai-chip-remote-access.html｜2026-11-25｜全文
- CNBC｜neocloud 与 BIS 规则｜https://www.cnbc.com/2026/11/26/neoclouds-nvidia-china-ai.html｜2026-11-26｜全文
- Yahoo Finance / 24-7｜Broadcom -12%、-$191B｜https://finance.yahoo.com/markets/stocks/articles/broadcom-stock-plunges-12-loses-191304321.html｜2026-11-20｜全文
- SEC｜AMD S-3ASR｜https://www.sec.gov/Archives/edgar/data/2488/000119312526472370/d171551ds3asr.htm｜2026-11-23｜关键段
- AMD｜Microsoft Helios 验证｜https://newsroom.amd.com/news/microsoft-running-workload-validation-amd-helios-rackscale-solution/｜2026-11-23｜全文
- Crypto.news｜CoreWeave $4.5B Meta 贷款｜https://crypto.news/morgan-stanley-and-mufg-prepare-4-5-billion-coreweave-loan-tied-to-meta/｜2026-11-25｜全文
- 24/7 Wall St.｜CoreWeave 7% vs 18%｜https://247wallst.com/investing/2026/11/26/coreweave-can-now-borrow-at-7-with-metas-name-on-the-loan/｜2026-11-26｜全文
- TNW｜Oracle 称 OpenAI 合同全额融资｜https://thenextweb.com/news/oracle-openai-contract-fully-funded-20bn-raise｜2026-11-20｜全文
- 24/7 Wall St.｜Broadcom 与 TPU 订单｜https://247wallst.com/investing/2026/11/20/broadcom-stock-plunges-12-and-loses-191-billion-after-a-report-that-google-cut-its-plans-for-broadcom-ai-chips/｜2026-11-20｜全文
- OpenAI｜Perplexity and Intelligence｜https://openai.com/index/perplexity-and-intelligence/｜2026-11-22｜全文
- OpenAI｜Shirudo｜https://openai.com/index/introducing-shirudo/｜2026-11-23｜全文
- OpenAI｜GPT-6 蛋白设计｜https://openai.com/index/gpt-6-models-demonstrate-intrinsic-protein-design-capabilities/｜2026-11-24｜全文
- TechCrunch｜Chat/Work 合并｜https://techcrunch.com/2026/11/25/openai-says-heavy-chatgpt-users-may-hit-limits-sooner-as-it-merges-chat-and-work/｜2026-11-25｜全文
- DeepMind｜量子算法 agent｜https://deepmind.google/blog/finding-faster-quantum-algorithms-with-agents-and-formal-verification/｜2026-11-23｜全文
- 9to5Google｜AI Mode 接入 Wallet/Drive｜2026-11-23｜全文（原文链接本次未定位，分片 A/google.md 记录）
- Meta｜Muse 英国上线｜https://about.fb.com/news/2026/11/introducing-muse-in-the-uk-a-personal-ai-agent-you-control/｜2026-11-23｜全文
- Microsoft｜Ignite 2026｜https://news.microsoft.com/source/2026/11/17/microsoft-ignite-2026-empowering-human-ambition-intelligence-and-trust/｜2026-11-17｜全文
- Calcalist｜Amazon×Decart 结构｜https://www.calcalistech.com/ctechnews/article/vwpi0qn1d｜2026-11-24｜全文
- Unite.AI｜AWS AgentCore x402 payments｜2026-11-19/20｜全文（原文链接本次未定位，分片 A/amazon.md 记录）
- DOJ｜华为有罪判决｜https://www.justice.gov/opa/pr/chinese-tech-giant-huawei-and-subsidiaries-convicted-sanctions-violations-fraud-conspiracy｜2026-11-24｜全文
- HF｜文心 5.5 Flash Preview｜https://huggingface.co/baidu/ERNIE-5.5-Flash-Preview｜2026-11-24｜模型卡
- docs.z.ai｜GLM-5.4｜https://docs.z.ai/guides/llm/glm-5.4｜2026-11-23｜全文
- MiniMax｜H3 Family｜https://www.minimax.io/blog/minimax-h3-family｜2026-11-26｜全文
- 腾讯新闻｜DFly2｜https://news.qq.com/rain/a/20261126A0CW1I00｜2026-11-26｜全文
- GitHub｜Hy-MT3｜https://github.com/Tencent-Hunyuan/Hy-MT3｜2026-11-24｜README
- 豆包｜小豆产品页｜https://www.doubao.com/xiaodou/｜读取 2026-11-27｜全文
- IT之家｜千问 Go 代打电话｜https://www.ithome.com/1/031/977.htm｜2026-11-25｜全文
- Sierra｜Series F｜https://sierra.ai/blog/series-f-30b｜2026-11-23｜全文
- TechCrunch｜Sierra $30B｜https://techcrunch.com/2026/11/23/sierra-doubles-valuation-to-30b-within-six-months-as-demand-for-ai-in-cx-takes-off/｜2026-11-23｜全文
- PYMNTS｜Databricks $225B｜https://www.pymnts.com/news/investment-tracker/2026/databricks-pursues-225-billion-valuation-months-after-5-billion-raise/｜2026-11-24｜全文
- Cognition｜SWE-2.1｜https://cognition.com/blog/swe-2-1｜2026-11-24｜全文
- TNW｜Cognition $75B｜https://thenextweb.com/news/cognition-funding-75bn-valuation-bloomberg-devin｜2026-11-20｜全文
- TNW｜Cursor 与国会｜https://thenextweb.com/news/cursor-chinese-ai-models-house-report-sarvam-deepseek｜2026-11-21｜全文
- Harvey｜开源权重后训练｜https://www.harvey.ai/blog/applying-the-harvey-tenet-training-recipe-to-us-open-weight-models｜2026-11-24｜全文
- Perplexity｜Time Machine｜https://www.perplexity.ai/hub/blog/freeze-the-web-with-perplexity-time-machine｜2026-11-25｜全文
- Runway｜Praxis-1｜https://runway.com/product/praxis｜读取 2026-11-27｜产品页
- Globe and Mail｜Cohere 伦理审查｜https://www.theglobeandmail.com/politics/article-conservatives-push-ethics-review-ottawa-16-billion-cohere-investment/｜2026-11-26｜全文
- 美联储报告（背景）｜Crypto Briefing 转述｜https://cryptobriefing.com/federal-reserve-ai-infrastructure-debt-warning/｜2026-11-25｜全文

## 11 冻结声明

- 本稿为第 27 期冻结母稿，窗口 2026-11-20 00:00 → 2026-11-26 24:00（Asia/Shanghai）。
- 所有拟采用主张均可追溯到已读原文；付费墙/403/JS 空壳均标注「未取得」与已试入口。
- 读者稿 `reader.md` 由本稿经 report2article 编辑，证据等级、覆盖统计与过程只保留在本稿与 `status.md`。
