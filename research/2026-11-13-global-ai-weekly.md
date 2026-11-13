# 全球 AI 动态周报 · 第 25 期（母稿·冻结）

- 期号：25
- 窗口：2026-11-06 00:00 — 2026-11-12 24:00（Asia/Shanghai）
- 运行日：2026-11-13（周五）
- 读者：公司战略观察者 / 投资人（R1 主，R4 协同）
- 冻结时间：2026-11-13 13:15 CST
- 状态：冻结。此后只允许事实性更正，不允许改主线。
- 证据级：**A** 可核原始事实（官方稿/监管文件/财报/定价页）｜**B** 具名披露或权威媒体对一手的转述｜**C** 多源交叉或有限佐证｜**D** 欠证/传闻/日程未定。
- 纪律：结论强度 ≤ 证据强度；数字紧邻出处；传闻标 D 不进 TOP 确定句；未核到不写成未发生。

## 本期一句话主线

这周 AI 行业第一次公开给「关键人」定价：英伟达董事会用四天从「对创始人有信心」走到「即刻接受辞呈」，同一周 Anthropic 把公司按 1.404 万亿美元写在招股书封面上——AI 的信用基础正从创始人叙事，移交给董事会、供应商股东与公开市场。

---

## 1 覆盖统计

见 §5 分组对象条目（每个对象均有终态：有动态 / 无动态+核验入口 / 未取得+已试入口）。

| 组 | 固定对象 | 有动态 | 无动态 | 未取得 | 窗内条目（约） | discovery 线索 / 深写 |
|---|---|---|---|---|---|---|
| A 全球巨头与平台 | 8 | 7 | 1（xAI 官方） | 0 | 41 | 21 / 5 |
| B 中国头部 | 9 | 5 | 3（DeepSeek、月之暗面、智谱） | 1（华为） | 22 | 16 / 0 |
| C 应用与垂直 | 12 | 10 | 1（Mistral） | 1（Midjourney） | 28 | 16 / 8 |
| D 算力云硬件与具身 | 8 | 8 | 0 | 0（Oracle/Tesla/Figure 一手 403，仅标题/媒体级） | 24 | 14 / 3 |
| 合计 | 37 | 30 | 5 | 2 | 115 | 67 / 16 |
| 主控主线 | — | 1（NVIDIA CEO 交接） | — | — | 8 | — |


---

## 2 本期要点（TOP5）

> 说明：完整证据级标注见各组分片；本节只保留判断与可核事实。

### TOP1｜英伟达：四天，从「对创始人有信心」到「即刻接受辞呈」

11-08 董事会就「创始人兼 CEO 成为外国情报活动目标」的报道启动独立调查，同时声明「对 Jensen 及其领导团队有信心」；11-10 独立董事聘请前纽约南区代理联邦检察官 Joon H. Kim 与 Wachtell, Lipton, Rosen & Katz 主持调查；11-11，在 NYT 报道第二段关系涉及一名直接向其汇报的高管后，董事会当日接受黄仁勋辞去总裁、CEO 与董事职务，即刻生效（8-K Item 5.02 事件日 11-11）；11-12 公告 CFO Colette Kress 兼任临时 CEO、1993 年起任董事的 Harvey C. Jones 出任公司史上首位董事会主席、启动内外部搜寻，Q3 FY2027 财报仍按原计划 11-17 发布。

压垮董事会的不是尚未完成的间谍调查，而是「CEO 与直接汇报者的关系」——这类问题董事会可以独立判断，不必等外部结论。处置方式暴露了接班结构：黄直接管理约 60 名汇报者、极少授权，公司没有公开的继任计划（B，TechCrunch 引述黄本人说法）。「临时 CEO + 首任董事长 + 外部搜寻」三件套里，选财务背景的 Kress 而非产品/工程负责人，是稳住资产负债表与客户承诺的信号；把董事长职位从 CEO 手里分离，是对「创始人中心制」的结构性修正。

英伟达早已不只是卖芯片：据 TechCrunch 汇总，截至 7 月公司约有 $750B 循环交易承诺、8 月为 OpenAI 俄亥俄数据中心 $105B 融资兜底、并说服 Apollo/BlackRock/Blackstone/Brookfield/Goldman/KKR 承诺至多 $500B 用于数据中心建设，以 GPU 保值作为抵押逻辑（B，媒体汇总，未独立核实）。这套「以算力为抵押」的融资结构，信用基础很大程度上是创始人本人持续在场。市场给出的即时定价是 11-11 盘后跌约 8%、五日累计约 -11%（B，媒体口径）。同一天 AMD 发布 MI455X 对英伟达 Vera Rubin 的「领先」推理成绩——第二供应商的叙事恰好赶上窗口。

### TOP2｜Anthropic 的一周：先给能力定价，再给公司定价

11-09 发布 Claude Fable 5.2 与 Mythos 5.2：同一底层模型的两个分发版本，Fable 带网络安全与生物安全护栏面向所有用户，Mythos 面向通过审核的网络安全与生命科学研究方；定价 $8 / 百万输入、$40 / 百万输出，低于 5.1；可选 fast mode $16 / $80，生成速度至多 2.5 倍。厂商标称 FrontierCode 2.0 49.1%（Xhigh）、OSWorld 2.1 89.3%、Humanity's Last Exam（带工具）74.2%；并称 Anthropic 核心代码库中超过 90% 的合并改动由 Claude 撰写，一名工程师让模型协调 1,000+ 子代理、连续 8 天从空目录造出可在笔记本启动的操作系统。

11-10 的 S-1/A-2 给出：825,000,000 股 Class A、价格区间 $70–78，募资 $57.75B–64.35B，净募资 $84.6B–93.7B（含同步私募）；按上限、完全摊薄，TechCrunch 计算隐含估值 $1.404T（5 月融资为 $965B）。同步以 IPO 价向七家战略方私募 $26.0B 无投票权 Class N 股：Google $10B、NVIDIA $10B、AMD $2.5B、Broadcom $1B、Micron $1B、Microsoft $1B、TSMC $0.5B。治理上，创始人持有的 Class F 股占 50.1% 投票权，Long-Term Benefit Trust 通过 Class T 股选出董事会多数——公开股东买到的是经济份额而非控制权。预计 11-19 前后在纳斯达克挂牌，代码 ANT。

账本：9 个月收入 $33.2B、Q3 单季 $17.0B、9 个月净亏损 $104B（含可转换证券等公允价值变动）、现金及短期投资约 $132B；截至 10-31 的 run-rate 收入约 $81B。采购承诺与租赁合计 $900.9B，其中 $451.6B 在 2030 年底前发生、$70.7B 在 12 个月内到期；而剩余履约义务（RPO）仅 $13.8B。按本报计算：承诺约为 RPO 的 65 倍；IPO 净募资中位约覆盖 12 个月内到期承诺的 1.2 倍。公开市场买的不是已签约收入，而是「消费型收入继续陡增」的假设——而 Ramp 数据显示 8–9 月企业 token 支出仅增 1.5%（7 月为 42%），10 月回升 8.9%（B）。

模型降价（$8/$40）与 IPO 定价（$1.404T）是同一件事的两面：能力越便宜，越要靠规模与资本市场补足单位价格的下行；而供应商用股权锁定客户（$26B Class N），等于把「卖铲子的人」变成「矿的股东」。

### TOP3｜Google：两天两个模型，把「每任务成本」做成产品参数

11-10 Gemini 4 Carbon 正式可用，API 导入价与 Argon 相同（$2 / 百万输入、$10 / 百万输出）；Google 称其在 CursorBench 4.0、Perplexity WANDR、Zapier AutomationBench 三个独立基准上排名第一，且每任务成本比次优外部模型低 2 倍以上。Antigravity 预览 /swarm：一个提示词拆成可实时追踪的 agent 团队，Carbon 做架构/协调/审计，轻模型做并行执行与对抗验证。

11-12 Gemini 4 Hydrogen 接棒，取代 Gemini 3.8 Flash：100 万 token 上下文统一定价 $1.50 / 百万输入、$7.50 / 百万输出；Artificial Analysis 智能指数 51（Argon 为 50，xhigh 档 54）；Terminal-Bench 4.1 57%（3.8 Flash 为 18.2%），任务完成速度快 2.5 倍；同日 Hydrogen 成为 Search 迄今最大模型升级，全球全量用户可用。配套 Antigravity Orchestrator 在同一会话内自动在 Carbon 与 Hydrogen 之间切换，Terminal-Bench 4.0 上接近 Carbon 的成功率，平均少用 24% 配额、快 19%。11-11 另有 Gemini Decisions API：一次前向对最多 1,000 个候选打分，输入 $0.10/百万、输出不计费。

Google 这一周没有发布「更大的模型」，而是把模型做成分层定价的算力产品：Carbon 卖「最难的任务」，Hydrogen 卖「每 token 最便宜的可用智能」，Orchestrator 卖「自动选择」。这直接压向 OpenAI 与 Anthropic 的定价带——同一天 Anthropic 把 Fable 5.2 降到 $8/$40，两家在「前沿能力」与「日常执行」两个价位同时挤压。对企业的含义是：模型选型从「选最强」变成「选路由」。

### TOP4｜OpenAI：估值回落到 $1.25T，收入首次单季破 $10B

11-06 据 Bloomberg，OpenAI 新一轮已募 $11B、估值 $1.25T，本轮尚未关闭、预计总额约 $20B（9 月目标为 $30B @ $1.4T）。11-11 据 Bloomberg，Q3 收入首次单季超过 $10B（Q2 为 $6.7B，环比约 +50%），年化 run-rate $50B，调整后经营利润率从 -150% 收窄至 -109%。产品侧是分发周：11-10 ChatGPT Enterprise 上架 AWS Marketplace；同日推出 Businesses in ChatGPT（企业档案验证、专用 business agent、曝光与点击洞察）；另据 TechCrunch，11-10 收购 AI 旅行 agent 公司 Odessia，属 acqui-hire，产品已关停、条款未披露。

OpenAI 这一周的关键词不是模型，是渠道与单位经济：估值从 $1.4T 回落到 $1.25T、募资目标砍掉约三分之一，同时用 AWS 市场分销换企业渗透、用 Business Hub 试探搜索广告的腹地。与 Anthropic 的对比很清楚——Anthropic 用「供应商入股 + 公开市场」融资，OpenAI 用「云市场分销 + 私募」融资；两条路都在回答同一个问题：当收入增速开始被价格战侵蚀，钱和渠道哪个更稀缺。

### TOP5｜AMD：在英伟达换帅同一天，给出「性能 + 供给」的替代叙事

11-12 AMD 更新 Instinct MI400 系列：MI455X 在 Helios 机柜上跑 DeepSeek-R1，MLPerf Inference Offline 达 21,333 tokens/s/GPU，AMD 称比英伟达 Vera Rubin 最新公开 MLPerf 成绩高至多 30%，Helios 的 HBM 带宽高至多 20%（均为 AMD 基于公开规格的计算/自测）；新增 MI450X（288GB HBM4，与 MI455X 同计算、同带宽、同互联）；MI430X 面向科学计算，432GB HBM4、23.3TB/s 带宽、原生 FP64。11-09 另披露第五代 EPYC 为 Google Cloud TPU 8tx 的主机基础设施供电，并把 SEV 机密计算从 CPU 延伸到加速器——CPU 收入与加速器胜负解耦。

时点比数字更值得记：AMD 选择在黄仁勋辞职公告同日发布对 Vera Rubin 的对比成绩。对客户而言，这提供了「治理风险对冲」的现成话术——不是换供应商因为性能更好，而是因为不想把 2027 年的产能押在一家正在换 CEO 的公司上。需要克制的是：21,333 tok/s 与 +30% 均为 AMD 自测、对比的是英伟达「已公开」的 MLPerf 条目，不是同一台机器的 head-to-head。

---

## 3 主线专题：四天，AI 的「承保人」换手

（完整版见 `shards/main/nvidia-deep.md`；此处为母稿摘要）

### 3.1 时间线（当地日期）

| 日期 | 事件 | 证据级 |
|---|---|---|
| 10-29（窗外背景） | NYT 报道黄仁勋与 Megaspeed 高管 Alice Huang「关系密切」，美国官员怀疑后者为中国情报人员 | 背景，非本周 |
| 11-05（窗外背景） | 众议院三个委员会主席联名要求黄仁勋闭门简报 | 背景，非本周 |
| 11-08 | 董事会声明启动独立调查；黄致全员信承认对妻子不忠并道歉；特朗普表态支持留任 | A（前两项） |
| 11-09~10 | 媒体披露 Megaspeed/上海世纪利通与芯片流向细节；11-10 独立董事聘 Joon H. Kim + Wachtell | B / A |
| 11-11 | NYT 报道第二段关系涉及直接汇报高管；董事会当日接受辞呈（8-K 事件日）；盘后跌约 8% | A（辞呈）/ B（股价） |
| 11-12 | Kress 任临时 CEO、Jones 任首位董事长、启动搜寻；黄同意感恩节前国会闭门作证；特朗普提议 Tim Cook | A / B |

### 3.2 机制：为什么四天就结束

1. **问题性质换了**：11-08 是「国家安全的外部风险 + 支持 CEO」；11-11 变成「CEO 与直接下属的权力关系 + 治理失效」。后者董事会无需等待外部调查即可判断。
2. **接班结构暴露**：约 60 名直接汇报、极少授权、无公开继任计划（B）。因此只能「临时 + 外部搜寻」，且临时人选是 CFO——财务信号而非产品信号。
3. **协商式退出**：8-K 用 accepted the resignation，新闻稿保留正面评价，避免解雇所需的正式理由与诉讼风险；代价是调查结论、辞呈条款、离职补偿全部未披露。
4. **政治线独立运行**：黄过去是对华出口政策的首席企业游说者，这条渠道随他离场中断；接任者短期难以复制其在国会山的信用。

### 3.3 市场含义：关键人风险第一次被计价

- 11-11 盘后 -8%、五日约 -11%（B）。这不是对当期业绩的定价，是对「黄仁勋溢价」的重新估值。
- 临时 CEO 的第一场公开考验是 11-17 的 Q3 FY2027 财报会——没有创始人站台，她要重申客户承诺、路线图与供应计划。
- 窗内未见任何大客户公开表态（已核各公司新闻室/RSS）。采购暂按合同执行，但多源化动机增强。
- 未被定价的部分：$750B 循环交易、$105B 俄亥俄兜底、至多 $500B 的 PE/资管建设承诺，其信用基础含创始人本人。承保人离场 = 抽掉一根支柱。

### 3.4 竞争与资本的同周呼应

- AMD 同日给出 MI455X 对 Vera Rubin 的对比成绩，叙事上完成「第二供应商」的对照。
- Nebius 公布 $40B 基建支出计划（客户预付款 + 贷款）；今年约 $80B 数据中心债券中近半为高收益级（B）；SoftBank 因预订燃气轮机损失超 $30 亿（B）——算力扩张的融资成本在同一周上升。
- Anthropic 以 IPO 价向 NVIDIA、Google 各私募 $10B 无投票权股：算力供给方用股权锁定模型客户，而它自己的 CEO 位置空悬。**同一周，资本在给 AI 的两种信用定价：给公司（1.404 万亿），给个人（-11%）。**

---

## 4 企业竞争雷达（按机制，不按公司流水账）

### 4.1 承保层：谁为 AI 的资本开支签字

- **供应商变股东**：Anthropic 的 $26B Class N 把七家芯片/云厂变成无投票权股东（Google、NVIDIA 各 $10B）。采购关系资本化后，「中立云」的定价与优先级会被股东身份影响；对 AWS/Azure 这类既是投资方又是渠道方的角色，是新的利益冲突披露问题。
- **一级市场降温、二级市场接棒**：OpenAI 估值从 $1.4T 目标回落到 $1.25T、募资目标从 $30B 砍到约 $20B；Anthropic 从 $965B 跳到 $1.404T 并转向公开市场。两家对向而行，说明私募资金对美国前沿实验室的边际承接力在下降，公开市场成为下一段资本开支的来源。
- **债务侧收紧，且已经出现在报表里**：CoreWeave Q3 营收 $3.661B（同比 +168%）、净亏损 $709M，而当季净利息支出 $846M——利息已超过净亏损；backlog $132.5B、capex 指引 $37–39B，融资靠 $4.2B 可转债、最高 3,500 万股的 ATM 与 $2.6B 短期客户合同贷款，电话会称未来三个月还有约 $9B 客户预付款与押金（B）。约 $80B 数据中心债券近半为高收益级；Nebius 用客户预付款 + 贷款支撑 $40B；SoftBank 因轮机预订损失 >$30 亿。资本开支的融资结构正从「股权故事」转向「项目融资 + 预付款」，对客户预付款的依赖度上升。
- **并购退潮**：本周唯一并购是 OpenAI 对 Odessia 的 acqui-hire 与 Oura 以 $6.25 亿收购 AI 原生诊所 Counsel Health。相比第 24 期的三笔平台型收购，本周资本更愿意买「资质与团队」，而不是买「入口」。

### 4.2 模型层：定价单位从「每 token」转向「每任务」

- **Google 三层编队 + 自动路由**：Carbon（$2/$10，难任务）→ Hydrogen（$1.50/$7.50，Flat 覆盖 1M 上下文）→ Orchestrator（-24% 配额、-19% 时间）。把「贵模型做判断、便宜模型做量」从客户自建变成平台默认。
- **Anthropic 双型号 + effort 分层**：Fable/Mythos 同权重、双分发；五档 effort 与 fast mode 构成两套成本杠杆，官方用「精度 vs 单任务成本」曲线卖「更少 token 达到同等分」。
- **Meta 补最轻一档**：11-09 Muse Ember，$0.10/M 输入，官方定位「Wonder 规划、Ember 跑量」；Muse 家族形成 Spark/Glimmer/Wonder/Ember 四层。
- **Decisions API 是另一种计价**：一次前向对最多 1,000 个候选打分，输出不计费、端到端 150–250ms——把「生成」换成「判别」，成本不随输出长度增长。
- 结论：模型竞争的主战场从「榜单第一」转为「同一预算下完成多少任务」。这对按 token 计收的厂商是结构性降价压力；对采购方意味着招标口径要改成「每完成任务成本 + 人工复核率」。

### 4.3 分发层：模型进入别人的入口，平台做「被调用的上下文层」

- **Databricks Genie**：11-11 插件原生进入 ChatGPT、Claude、Copilot Cowork、Grok Bot，11-12 Genie in Slack GA。选择不做入口、做「被四个入口调用的企业上下文层」；权限随提问者、MCP 动作需审批。
- **Adobe**：MAX 上把 agent 做成常驻，同时发布 MCP 让 ChatGPT/Claude/Gemini 调用 Adobe 能力——既做入口也做被调用方。
- **OpenAI**：ChatGPT Enterprise 上 AWS Marketplace；Businesses in ChatGPT 做「可验证企业档案 + 专用 business agent + 曝光洞察」，从「回答里顺带提到你」变成「可运营的发现入口」，但 3 月电商闭环的失败说明转化链仍是短板。
- **Google**：Hydrogen 当天全量进入 Search，是 Google 首次把前沿模型同步到 Search 全球流量；对 OpenAI 的消费端分发优势与 Perplexity 类产品是直接压力。
- **Glean**：Release 568 的 service credentials 让 agent 用共享服务账号访问工具，不再依赖逐用户授权——企业 agent 从「个人助手」走向「有身份的系统账户」。

### 4.4 Agent 落地：渠道反制与「身份」缺口

- **United Airlines（11-12）**：修改预订、出票与分销政策，禁止第三方个人 AI agent 代订与操作里程，并同步约束旅行社与聚合商；抓手是「必须由人完成的动作」（值机危险品申报）与凭据共享风险。这是 agent 商业化本周最强的反向信号。
- **Meta Muse 代打电话（11-12）**：美国付费订阅用户可用，$20/月起；另一端体验不佳——商家听出 AI 就挂断。落地瓶颈不在模型，在「被叫方是否承认 agent 身份」。
- **Grok Build 暴露（11-12，C 级）**：43,551 个应用地址中 37,571 个在线，94.7% 无需登录即可打开，估计 650–800 个含私密数据；成因是随机词域名可被被动 DNS 枚举 + 发布面板默认「任何持有链接的人」。
- 结论：agent 的瓶颈从「能力」转向「被授权」。谁先提供可验证的 agent 身份（去电签名、OAuth 代理、平台授权通道），谁就拿到交易类场景的入场券。

### 4.5 算力与具身：替代供给在同一周集体到位

- **AMD**：MI455X/MI450X/MI430X 三档覆盖推理、通用与科学计算；EPYC 进入 Google TPU 8tx 主机侧。第二供应商从「有芯片」走到「有机柜 + 有主机」。
- **Google TPU**：第八代两个变体——TPU 8tx（与 AMD 合作、机密训练/推理）与 TPU 8i Max（双芯合封、内存/算力/带宽翻倍）；另有接盘 Crusoe 怀俄明在建数据中心（B）。
- **电力成为硬约束**：Anthropic 购入 $3.4B 燃气轮机；SoftBank 因轮机预订损失 >$30 亿；X-energy 获准建造首批 SMR（B）。
- **具身**：Google Gemini Robotics 2.5（200 项任务、成功率 +30%–100%，Mercedes 匈牙利/德国产线概念验证、Apollo 2 kitting 96%）；Runway 以 Apache 2.0 开放 27B MoE 世界动作模型 Praxis-1（RoboLab-120 成功率 46.2%，超过 FLUX 3 Action 的 42.9%、Cosmos3 Nano 的 36.8% 与 π0.5 的 28.0%，厂商自测）；Tesla 的 Musk 在 11-06 Baron 投资会议上称 Optimus 未来「大概率出租（rent them）」、单台成本 $20,000–30,000，未给条款与时间表（C）。具身的基础模型层开始出现「开放权重 + 硬件伙伴」的组合，本体厂商则转向「按使用收费」。
- **私有云与代理层**：Broadcom 在 VMware Explore 周期发布 AI ReadyNodes、KubeVM Service 与 Agent Substrate on VKS（A），把 agent 运行时塞进企业私有云；Oracle 发布 OCI Atlas（用 agent 管 OCI 运维，C）。另有媒体称 Microsoft 未续签 Oracle 的 AI 算力租约（D，单一媒体转述，未见双方确认）——若成立，是「循环算力合同开始被重新审视」的第一个信号。
- **本体侧**：Figure 在 11-07 由 CEO 发布数十台 F.03 从 BotQ 列队出厂的视频（C，媒体称推进 10 万台，非官方数字）；宇树在 11-10 获均胜电子交付首台「机器人高算力大脑背包」（端侧具身推理，兼容人形/四足/轮式，B）；优必选在 11-12 获永达汽车首批 400 台 U1 Pro 采购，同日曦选创智完成 5 亿元天使轮、投后 40 亿元，端侧具身芯片 275 TOPS 对标 Thor、计划 2028 量产（B/C）。三家共同的信号是：本体厂商开始用「算力背包 + 渠道订单 + 专用芯片」拼交付能力，而不是只拼演示。

---

## 5 分组对象条目

> 每个对象一个终态：**有动态** / **无动态 + 核验入口** / **未取得 + 已试入口（≥2）**。日期为发布地当地日；「级」为该条最高证据级。

### 5.1 A 组｜全球巨头与平台（8/8 终态：7 有动态 / 1 无动态 / 0 未取得）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| OpenAI | 有动态（8 条，无前沿模型） | 11-10 Business Hub、ChatGPT Enterprise 上架 AWS Marketplace、收购 Odessia；11-11 Q3 收入首破 $10B；11-06 新轮已募 $11B @ $1.25T；11-09 Control Room | A/B |
| Google | 有动态（9 条） | 11-10 Carbon GA、AlphaProof Code、Robotics 2.5；11-11 Decisions API；11-12 Hydrogen + Search 全量 + Orchestrator；11-09 TPU 8tx/8i Max（B） | A |
| Anthropic | 有动态（7 条） | 11-09 Fable/Mythos 5.2；11-10 IPO 路演与 S-1/A-2、Claude Meetings；11-09 $3.4B 轮机（B）；11-12 Glasswing 质疑（C） | A |
| Meta | 有动态（6 条） | 11-09 Muse Ember（$0.10/M 输入）；11-12 数据中心清洁制造四类长期采购协议（水泥/钢/运输/再生塑料） | A/B |
| Microsoft | 有动态（仅 1 条事故） | 11-12 Outlook/Teams/SharePoint/Copilot/Defender 全球宕机，官方归因「大量服务器意外不可用」；**窗内无 Copilot/Azure AI 发布**（Ignite 11-17 起，窗外） | B/C |
| AWS | 有动态（3 条） | 11-12 Emulator 正式可用（Rust、开源、由 agent 维护）；11-10 AgentCore Runtime V2（P75 冷启动约 2 秒）；Web Answer / DynamoDB bulk put | A |
| xAI | **无动态（官方）** | 核验入口 https://x.ai/news 最新 2026-11-02（Grok Bot 1.0）；第三方：11-12 Grok Build 94.7% 无鉴权（C） | C |
| NVIDIA | 有动态（CEO 3 条 + 非 CEO 4 条） | 11-08/11-10/11-12 CEO 线（见 §3）；11-10 OpenShell 捐 CNCF Sandbox、Agent Substrate、NVKE/NVKR/Snapshot；11-09 韩国四项投资 | A |

### 5.2 B 组｜中国头部（9/9 终态：5 有动态 / 3 无动态 / 1 未取得）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| 阿里 / Qwen | 有动态 | 11-11 阿里云百炼上线 qwen4-max-preview（旗舰多模态、兼容 OpenAI/Anthropic 协议），**仅 Token Plan 订阅通道**；窗内无新开源权重 | A |
| MiniMax | 有动态 | 11-11 开源 **MiniMax-H3-Image**：33.1B DiT、原生 4K、6 步采样，示例 4K 约 $0.06879/张（发布周 5 折 ≈ $0.03439）；社区许可非 Apache | A |
| 百度 / 文心 | 有动态 | 11-11 文心 5.5 Flash Preview 上架千帆：1M 输入 / 1M 输出上下文、RPM 300 / TPM 300 万；总参 2800 亿 / 激活 140 亿、>200 token/s 为媒体口径，官方称「即将开源」；HF 窗内无权重 | A（上架与规格）/ B（参数与速度） |
| 字节 / 豆包 | 有动态（研究侧） | 11-06 Seed 开源 **Cola2**（连续潜空间语言模型，346.03B source tokens，8 项评测均值 60.10）；产品侧窗内无一手公告，官方文档仅有 `doubao-seed-evolving` 月度滚动更新页（月级、无日） | A |
| 腾讯 / 混元 | 有动态 | 11-12 元宝搜索网页版 so.qq.com 对外开放（可设为 QQ 浏览器默认搜索，底座支撑 50+ 业务）；11-07 开源投机解码 draft 模型 Qwen3.8-27B-DSpine-b16 | B/A |
| DeepSeek | **无动态** | 核验：api-docs.deepseek.com/updates 顶部仍为 2026-10-17；HF 最新 2026-10-17 | A（负） |
| 智谱 | **无动态** | 核验：docs.z.ai release-notes 最新 2026-08-26；zhipuai.cn/news 与 open.bigmodel.cn 为前端空壳，HF zai-org 最新 2026-08-25 | A（负） |
| 月之暗面 / Kimi | **无动态** | 核验：kimi.com/blog 最新 2026-10-24（K3.1 Pro，窗外）；HF 最新 2026-11-02（窗外） | A（负） |
| 华为 / 昇腾·盘古 | **未取得** | 已试：huawei.com/cn/news（JS 加载）、hiascend.com/activities/news（显示「暂无数据」）、hiascend.com、huaweicloud.com/news（404） | — |

### 5.3 C 组｜应用与垂直头部（12/12 终态：10 有动态 / 1 无动态 / 1 未取得）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| Perplexity | 有动态（弱） | 11-11 Agent API effort 版本更新；新增 gemini-4-carbon（$2/$10）；ultra 档跑 opus-5-5 | A |
| Midjourney | **未取得** | 4 个入口均 403/404（官网、新闻页等） | — |
| Runway | 有动态 | 11-11 开源 Praxis-1（27B MoE 世界动作模型，Apache 2.0，RoboLab-120 46.2%）；11-12 内容审核改用 LLM 判策 | A/B |
| Harvey | 有动态 | 11-10 $550M @ $15.5B（Diffusion + Lightspeed 领投），Am Law 100 覆盖 80%；11-12 Contract Intelligence、Outlook agents | B/A |
| Sierra | 有动态（弱） | 11-09 Mossy 设计文、APX 两周年；无产品/融资级发布 | A |
| Glean | 有动态 | 11-06 Release 568：service credentials MCP、评论锚定、AI 透明度提示；11-11 记忆机制（compaction/consolidation） | A |
| Databricks | 有动态 | 11-11 Genie 插件进 ChatGPT/Claude/Copilot Cowork/Grok Bot、Genie Search、100+ MCP；11-12 Genie in Slack GA、Lakehouse//RT | A |
| Cohere | 有动态 | 11-12 Jaya Baloo 任首任 CISO（AISLE 联合创始人，10-15 收购 AISLE 的后续） | A |
| Mistral | **无动态** | 核验：mistral.ai/news 最近 2026-11-05 | — |
| Scale | 有动态 | 11-12 与新加坡 IMDA 发布 SG-LegalClarify（1,100 题、1,860 场景、19 模型） | A |
| Cursor / Anysphere | 有动态 | 11-06 Voice Chat with Agents（Grok Voice 底座）；11-10 Projects 多人协作 | A |
| Cognition / Devin | 有动态（弱） | 11-06~11-12 四条 changelog（子会话、secret pill、合并审批卡、Design Mode） | A |

### 5.4 D 组｜算力、云、硬件与具身（8/8 终态：8 有动态，质量分层）

| 对象 | 状态 | 窗内要点 | 级 |
|---|---|---|---|
| AMD | 有动态 | 11-12 MI455X 21,333 tok/s/GPU（称 +30% vs Vera Rubin）、MI450X 288GB、MI430X 432GB/23.3TB/s；11-10 第六代 EPYC GA | A/B |
| Broadcom | 有动态 | 11-12 VMware AI ReadyNodes；11-10 VM API / KubeVM Service、Agent Substrate on VKS | A |
| CoreWeave | 有动态 | 11-10 Q3：营收 $3.661B（+168%）、净亏损 $709M、净利息支出 $846M；backlog $132.5B；capex 指引 $37–39B；$4.2B 可转债 + ATM + $2.6B DDTL | A/B |
| Oracle Cloud | 有动态（C 级） | 11-12 OCI Atlas（agent 管 OCI）；11-11 金融机构 AI 分析；媒体称 Microsoft 未续签 Oracle 算力租约（D，未确认） | C/D |
| Tesla Optimus | 有动态（C 级） | 11-06 Musk 称 Optimus 未来「大概率出租」、成本 $20,000–30,000；官方无稿 | C |
| Figure | 有动态（C 级） | 11-07 CEO 视频：数十台 F.03 从 BotQ 列队；媒体称推进 10 万台（非官方数字） | C |
| 宇树 | 有动态（B 级） | 11-10 均胜电子交付首台「机器人高算力大脑背包」（兼容人形/四足/轮式，端侧具身推理），年内还有灵巧手与固态电池管理合作 | B |
| 优必选 | 有动态（B/C 级） | 11-12 永达汽车首批采购 400 台 U1 Pro；曦选创智 5 亿元天使轮、投后 40 亿元，端侧具身芯片 275 TOPS 对标 Thor、2028 量产 | B/C |

### 5.5 发现层（名单外）

- A 组 `discovery.md` 21 条线索，纳入深写 5 条（OpenAI 融资、Odessia、Anthropic 估值结构、Claude Meetings、Google TPU），其余移交主控或 D 组。
- B 组 `discovery.md` 16 条线索，**名单外深写 0 条**（文心、MiniMax、元宝搜索均属固定名单对象）；另登记联想「词元工厂」、百度千帆订阅制转向、昇腾超节点在售阵列等背景线索。
- C 组 `discovery.md` 16 条线索，深写 8 条（United 封堵 agent、Meta Muse 代打电话、Nectar、Phota、Otter、Adobe MAX、Oura×Counsel Health、Reddit Reviews）。
- D 组 `discovery.md` 14 条线索，深写 3 条（Nebius $40B、Oracle/Microsoft 租约传闻、均胜×宇树）；另登记 SoftBank 轮机损失、Crusoe→Google、Fractile $720M、X-energy SMR、联想「万全混合词元工厂」等。

## 6 必出对比表

### 表 1｜三家前沿实验室：本周各自把什么做成了产品

| 维度 | OpenAI | Anthropic | Google |
|---|---|---|---|
| 本周模型动作 | 无新前沿模型（GPT-6 Cyber 为 11-05，窗外） | Fable/Mythos 5.2（11-09），同权重双分发 | Carbon GA（11-10）+ Hydrogen（11-12） |
| 定价信号 | 未调价；靠渠道与企业分销 | $8/$40，fast $16/$80；effort 分层 | $2/$10；$1.50/$7.50 Flat 1M；Decisions $0.10、输出免费 |
| 资本动作 | 已募 $11B @ $1.25T，目标降至约 $20B | IPO $70–78、隐含 $1.404T、$26B 供应商私募 | 认购 Anthropic $10B；接盘 Crusoe 数据中心 |
| 分发 | AWS Marketplace、Business Hub | Claude Meetings、Sheets/Whiteboards | Search 全球全量、Antigravity、Android Studio |
| 治理/风险 | 估值回落、盈利 -109% | 50.1% 投票权 + LTBT；RPO 覆盖 65x 缺口 | 反垄断与 Search 依赖；TPU 外售 |
| 一句话 | 把能力卖出去 | 把公司卖出去 | 把成本卖出去 |

### 表 2｜算力供给：本周谁给了「替代」

| 供应商 | 本周动作 | 对标 | 证据强度 |
|---|---|---|---|
| NVIDIA | CEO 交接、首位董事长、临时 CFO | — | A（公告/8-K） |
| AMD | MI455X 21,333 tok/s/GPU，称 +30% vs Vera Rubin；MI450X/MI430X | Vera Rubin / Helios | B（自测/自算） |
| Google | TPU 8tx（机密）、8i Max（双芯合封） | GPU 通用推理 | B（媒体引博文） |
| 新云 | Nebius $40B 计划；CoreWeave 等详见 D 组 | — | B |
| 电力 | Anthropic $3.4B 轮机；SoftBank 损失 >$30 亿；X-energy SMR | — | B |

---

## 7 周环比（vs 第 24 期）

第 24 期主线是「买下 Agent 的存储、调度与登录」：OpenAI×Pierre、Meta×Conductor、Sierra×Anon 三笔收购，加上 Anthropic S-1/A 与 AMD Helios。那一周的关键词是**用并购补齐 agent 的基础设施**。

| 上周（第 24 期） | 本周（第 25 期） | 走向 |
|---|---|---|
| 并购补 agent 基础设施（OpenAI×Pierre、Meta×Conductor、Sierra×Anon） | 并购退潮：仅 Odessia acqui-hire、Oura×Counsel Health | 降温 |
| Anthropic 递交 S-1/A（未定价） | Anthropic 定价 $70–78、$1.404T、$26B 供应商私募 | 延续并升级 |
| AMD Helios 机柜亮相 | AMD MI455X 对 Vera Rubin 的对比成绩 | 延续 |
| 模型能力竞赛（各家旗舰迭代） | 定价与路由竞赛（Carbon/Hydrogen/Ember、Orchestrator、Decisions） | 新出现 |
| 创始人/CEO 作为公司叙事中心 | 创始人关键人风险被公开定价（NVIDIA 四天换帅） | 新出现 |
| agent 能力演示 | 渠道反制 agent（United）、agent 身份缺口（Grok Build 默认公开） | 新出现 |
| 中国头部 | 腾讯 Hy4 开源、旗舰能力迭代 | MiniMax H3-Image 开源、阿里 qwen4-max 仅 Token Plan、文心 5.5 Flash 预告开源 | 延续（路线分化） |
| 算力扩张的股权故事 | 债务与预付款结构、电力约束（轮机、SMR、junk 债） | 转向 |

一句话：上周在**买入口**，本周在**给信用定价**；上周的收购是「把 agent 的零件买下来」，本周的董事会与招股书是「把 AI 的担保人换掉」。

---

## 8 洞察

1. **关键人风险成为可交易因子。** 英伟达的 -11% 不是业绩折价，是治理折价。2027 年的采购合同会出现三类新条款：双源/多源、源代码与权重托管（escrow）、关键人离职的供应连续性条款。卖方要开始像对待「单点故障」一样对待「单点创始人」。
2. **供应商变股东，是采购承诺的资本化。** Anthropic 用 $26B 无投票权股把七家供应商锁定，等于把未来的采购承诺提前折成股权。好处是供给确定性与估值背书，代价是云/芯片厂商的「中立性」需要重新披露——客户会问：我的推理跑在「我的供应商的股东」的云上，优先级怎么排？
3. **承诺与收入的缺口，是本期最硬的数字。** $900.9B 采购与租赁承诺 vs $13.8B RPO（65 倍），12 个月内到期 $70.7B vs run-rate $81B。公开市场在为「消费型收入继续陡增」定价，而 Ramp 的企业 token 支出在 8–9 月只增 1.5%。这个缺口只能由两种东西填：更快的企业采用，或更便宜的资金。
4. **定价单位从 token 迁到任务。** Flat 1M 上下文、Decisions 按输入计价、Orchestrator 省 24% 配额——买家开始按「完成一个任务多少钱」招标。按 token 计收的厂商会同时面对单价下行与用量被路由压缩的双重压力。
5. **agent 的瓶颈是被授权，不是能力。** United 用条款关门、商家挂断 AI 来电、Grok Build 默认公开——三个案例指向同一件事：agent 需要可验证身份与授权通道。下一批基础设施机会在「agent 身份」而非「agent 能力」。

---

## 9 覆盖与局限

- **中国组（B）**：qwen.ai、alibabagroup 新闻页、腾讯新闻中心、百度 IR、字节 Seed 博客等入口为 JS 空壳或 403，部分对象仅能以 Hugging Face API、云厂商公告、量子位/36氪转述补证；详见 §5 B 组终态与 `delivery.md` 的「需 Bot 补证」。
- **X / 微信 / 小红书**：本周未做站内取证；Musk 相关表态仅以中文媒体转述（C 级）。
- **交易所数据**：股价与市值只有媒体口径（-8% 盘后、-11% 五日），未取得收盘价（stockanalysis 被 Cloudflare 拦截）。
- **私有公司估值**：Anthropic $1.404T 为 TechCrunch 按完全摊薄计算，招股书原文未直接给估值；OpenAI $1.25T 为 Bloomberg 匿名信源。
- **benchmark**：Fable 5.2、Carbon/Hydrogen、MI455X 的成绩均为厂商自测或自算，非同机对比；本报在正文中一律标注。
- **未完成调查**：英伟达独立调查结论、辞呈条款、离职补偿未披露；本报不复述未经证实的私人指控。
- **日期边界**：美国公司按当地发布日记；11-12 美东事件对应 11-12 深夜/11-13 凌晨 CST，沿用第 24 期口径。Databricks Genie Migrate 的官网索引日为 11-12、RSS 时间戳为 11-13 02:00 CST，本稿按当地发布日计为窗内备注、不计入主条目。

---

## 10 来源清单

一手（A/B）：

- NVIDIA Newsroom：11-08 董事会声明、11-10 独立董事声明、11-12 CEO Transition；NVIDIA Form 8-K（Acc-no 0001045810-26-000082）。
- Anthropic：Fable/Mythos 5.2 发布页（11-09）、IPO 路演稿（11-10）、S-1/A-2（SEC EDGAR）。
- Google：Gemini 4 Carbon（11-10）、Gemini 4 Hydrogen（11-12）、Search 升级、AlphaProof Code、Gemini Robotics 2.5、Decisions API、智能眼镜预售。
- OpenAI News RSS（11-06~11-12 条目，正文 403 仅摘要）。
- AWS：Emulator、AgentCore Runtime V2、Web Answer、DynamoDB bulk put。
- Meta：Muse Ember、数据中心清洁制造采购协议。
- Microsoft：365 Status / admin center（经媒体转述）。
- 应用层：Databricks 博客、Glean release notes、Harvey newsroom、Runway、Cursor changelog、Devin changelog、Scale、Cohere、Perplexity docs changelog、Sierra blog。

媒体（B/C）：TechCrunch（按日归档 11-06~11-12）、The Verge、Ars Technica、Bloomberg（经 TechCrunch 转述）、WSJ/NYT/Reuters（经转述）、量子位、36氪。

### 10.1 读者稿引用的一手链接（逐条已核 200）

- NVIDIA：https://nvidianews.nvidia.com/news/statement-from-nvidia-board-of-directors ｜ https://nvidianews.nvidia.com/news/statement-from-the-independent-members-of-the-nvidia-board ｜ https://nvidianews.nvidia.com/news/nvidia-announces-ceo-transition ｜ 8-K：https://www.sec.gov/Archives/edgar/data/1045810/000104581026000082/0001045810-26-000082-index.htm
- Anthropic：https://www.anthropic.com/news/claude-fable-and-mythos-5-2 ｜ https://www.anthropic.com/news/roadshow-launch
- Google：https://deepmind.google/blog/gemini-4-carbon-is-now-available/ ｜ https://blog.google/innovation-and-ai/models-and-research/gemini-models/introducing-gemini-4-hydrogen/ ｜ https://blog.google/products-and-platforms/products/search/gemini-4-hydrogen-search-upgrade/ ｜ https://deepmind.google/blog/introducing-alphaproof-code/ ｜ https://blog.google/innovation-and-ai/technology/developers-tools/gemini-decisions-api/
- AMD：https://newsroom.amd.com/news/amd-advances-instinct-mi400-series-ai-scientific-computing/
- OpenAI（媒体口径）：https://techcrunch.com/2026/11/06/openai-reportedly-raises-an-additional-11-billion-at-a-1-25-trillion-valuation/ ｜ https://techcrunch.com/2026/11/11/openais-quarterly-revenue-reportedly-crosses-10b-for-the-first-time/
- xAI 核验入口：https://x.ai/news

完整 URL 见 `shards/A|B|C|D/*.md` 与各组 `discovery.md`。

---

## 11 冻结声明

本稿于 2026-11-13 13:15 CST 冻结。窗口内事实以一手公告与监管文件为准；媒体口径均标注证据级；厂商自测数据一律注明。窗口外事项仅作「背景，非本周」出现。冻结后如有一手更正，在 `status.md` 记录并同步 reader 稿，不改主线。
