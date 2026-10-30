# 全球 AI 动态周报 · 第 23 期 · 研究母稿（冻结）

- **窗口**：2026-10-24 00:00 ~ 2026-10-29 24:00（Asia/Shanghai）。「本周」只指此区间；窗外信息标「背景，非本周」。
- **上期**：第 22 期（窗口 2026-10-16 ~ 2026-10-22）。
- **冻结时间**：2026-10-30 11:20 Asia/Shanghai（CST）。
- **读者透镜**：公司战略观察者 / 投资人（R1）；开源仅在公司战略层面提及。
- **版本**：master.md v1（冻结）。读者稿只从本稿取材；证据级 A–D、覆盖与局限、完整对比表只留在本稿与 archive。
- **依据**：shards/A|B|C|D 全部分片 + coverage/discovery；primary-notes.md；prior/wow-seed.md；wow.md。
- **证据级**：A 可核原始事实（官方稿/SEC/监管）｜B 具名披露或权威媒体对一手的精读转述（据 X 披露，未独立全文核每一页）｜C 多源交叉/行情转述｜D 欠证/传闻/日程未定。
- **结论强度 ≤ 证据强度**。未在分片或一手笔记出现的数字一律不写。

## 本期一句话主线

**AI 基建的融资与算力供给重组——账单到期之后，谁出钱、谁供硅、谁分发。**

---

## 1. 覆盖统计

| 组 | 固定对象 | 有料 | 弱/流量 | 静默 | 名单外纳入 | 分片 |
|---|---|---|---|---|---|---|
| A 全球巨头与平台 | 8 | 8 | 0 | 0 | ~5（Oracle×OpenAI、TPU 传闻 D、EXL、DOJ×HF、Verizon 短记等） | shards/A/ |
| B 中国头部 | 9 | 7（含 DeepSeek 流量） | 2（智谱、MiniMax） | 0 | 2（蚂蚁 Ling 并入阿里；启元/魔芯 discovery） | shards/B/ |
| C 应用与垂直头部 | 12 | 9 | — | 2（Midjourney、Cursor） | 2（Serval、Guidewire×hx） | shards/C/ |
| D 算力云硬件与具身 | 8 | 6 | — | 2（Tesla Optimus、Figure） | 3（Agility、Samsung HBM、OpenAI-TPU 传闻） | shards/D/ |
| **合计** | **37** | **30** | **2** | **4** | **~12** | — |

### 1.1 固定对象覆盖明细

| 组 | 对象 | 窗内状态 | 一句话 |
|---|---|---|---|
| A | OpenAI | 有动态 | GPT-6.1 Terra 半价 computer-use；Oracle 企业栈；TPU 采购传闻〔D〕 |
| A | Google/Gemini/Alphabet | 有动态 | Q3 Cloud +103%、Search +12% AI Mode 承压；Gemini 4 Carbon；App 10 亿用户 |
| A | Anthropic | 有动态 | S-1（ANT）；红队真实软件攻击链 |
| A | Meta AI | 有动态 | ~$95B 股权计划；Nvidia/AMD/Broadcom 角石意向至多 $5B |
| A | Microsoft | 有动态 | VEO（约 6 万 eligible，媒体）；FY27Q1 Azure +48%、首次披露 Azure $33.2B |
| A | Amazon/AWS | 有动态 | AWS +39%、CapEx $220B；TorchNeuron；Trainium 或 2027 末外售 |
| A | xAI | 弱–中 | Grok Bot 外呼；v0.78.1 changelog |
| A | NVIDIA（战略） | 有动态 | 投 Meta $3B + Muse/Vera/Spectrum；DOJ 问询 HF 收购 |
| B | 阿里/千问/百炼 | 有动态 | 千问×夸克网盘；百炼 qwen-audio realtime + 蚂蚁 Ling |
| B | 字节/豆包/火山 | 有动态 | 方舟上架 K3.1 Pro；豆包工作三方模型；IDC MaaS 份额 45.1% |
| B | 腾讯/混元/WorkBuddy | 有动态 | 生态大会 Hy4/Buddy One/腾讯网盘；WorkBuddy 90 亿次任务 |
| B | 百度/文心/千帆 | 有动态 | Unlimited OCR 2 开源；武汉超级智能体大会 |
| B | 华为昇腾/盘古 | 有动态（算力） | 武汉 950DT 1024 卡集群点亮；盘古无大版本 |
| B | DeepSeek | 有动态（流量） | OpenRouter 周榜 Flash-1017 登顶；融资窗外 |
| B | 智谱 | 弱 | 无官方新版本；港股押 GLM-5.5 传闻〔D〕 |
| B | 月之暗面/Kimi | 有动态 | K3.1 Pro + Highspeed；计划 ≤11/4 开源；Google 插件 |
| B | MiniMax | 弱 | M3.1 Flash 居 OpenRouter 前三；无窗内官方新品 |
| C | Perplexity | 有动态 | FedRAMP Class C (Moderate) |
| C | Midjourney | 无动态 | 最近官方 10-08 |
| C | Runway | 有动态 | App Studio（10-26） |
| C | Harvey | 有动态 | FedRAMP Class D；Intake×Claude；Latham 合作 |
| C | Sierra | 有动态 | PAP v0.2；Compliance Console |
| C | Glean | 有动态 | Claude Marketplace |
| C | Databricks | 有动态 | AI Search / Lakeflow / Serverless 成本闸 |
| C | Cohere | 有动态 | Series E 首关，目标最高 CAD $7B |
| C | Mistral | 有动态 | Large 4 开源权重 |
| C | Scale | 有动态 | UAE DIFC；Qatar Pearl；FineART |
| C | Cursor/Anysphere | 无窗内重大 | Agent SDK 10-20 背景 |
| C | Cognition/Devin | 有动态 | Security 2.0；Corridor 并入 |
| D | AMD | 有动态 | Meta Helios 装机 + 投 $1B；Oracle E7/Pensando |
| D | Broadcom | 有动态 | $63B Anthropic XPU SPV；Meta 角石意向 |
| D | CoreWeave | 有动态 | 丹麦 22.5MW + 全球 AI 骨干网 |
| D | Oracle Cloud | 有动态 | Google TPU→OCI（2027）；多架构菜单 |
| D | Tesla Optimus | 无动态 | 量产确认 10-21 窗外 |
| D | Figure | 无动态 | design lock ~10-22 窗外 |
| D | 宇树 | 有动态 | 三季报：收入高增、扣非下滑、研发暴增 |
| D | 优必选 | 有动态（披露） | 中欧数字协会 MoU |

---

## 2. TOP5 候选（公司面向；含评分与证据）

评分维度（综合）：战略格局冲击（0–5）× 证据强度（A=1.0 / B=0.85 / C=0.7 / D=0.4）× 窗内新鲜度。下列为采用排序；分片未出现更强 A 级反证。

### TOP1｜Alphabet Q3：Cloud 翻倍、Search AI Mode 变现承压、FCF 转负
- **评分**：格局 5 × 证据 A ≈ **5.0**
- **判断**：Alphabet 把「查询涨、广告慢」与「Cloud+TPU 外售翻倍」同周交给市场；二级市场以约 12–13% 跌幅、市值蒸发约 $500B 量级定价——AI 搜索故事从流量切到单位广告收入，云故事从自用加速器切到可售货架。
- **关键数字〔A，SEC Exhibit 99.1，2026-10-28〕**：营收 $127.6B（+25%）；Google Cloud $30.7B（**+103%**），Cloud OI $11.1B；Search & other 约 $63.3–63.4B（+12%）；CapEx 当季 PPE purchase $51.4B；**FCF -$9.1B**（连续第二季负）；长期债务 9/30 **$125.1B**（vs 12/31/25 $46.5B）；ATM 季内净募约 $12.4B、剩余 $27.6B；Gemini App **10 亿**用户；first-party model APIs ~**32B tokens/min**。
- **Gemini 4 Carbon〔A，Google blog 10-28；primary-notes〕**：最强前沿、网安 SOTA；先限 Fairwind 网络防御方；入门价同 Argon **$2/$10**，之后 **$4/$20**。A 组 google 分片曾以财报表述为主、未单独精读产品页——**一手博客为权威补强**。
- **机制**：Cloud = 企业 AI 基建 + 解决方案 + **TPU 系统外售**；Search = AI Mode/Overviews 抬查询、拖单位变现，公司回应是扩大 AI 界面内广告覆盖〔B，电话会媒体〕。
- **格局含义**：唯一把自研加速器产品收入写进 Cloud 增长解释的一家；与同周 Oracle 上架 TPU、OpenAI 购 TPU 传闻〔D〕共振。对 OpenAI/Anthropic：既是云/芯片供应商又是 Gemini 对手。
- **来源**：SEC 99.1；abc.xyz IR；blog.google Gemini 4 Carbon；Guardian/CNBC/WSJ 交叉（股价 C）。

### TOP2｜Meta ~$95B AI 股权融资 + 芯片商角石（循环资本）
- **评分**：格局 5 × 证据 A/B ≈ **4.7**
- **判断**：超大规模训练/推理基建进入「发股续命」阶段；Nvidia/AMD/Broadcom 向最大客户注资，把卖铲人变成客户股东——循环资本从市场担忧变为可核条款。
- **关键数字〔A，Meta IR 10-26〕**：约 **$35B** 承销（~$22.5B Class A 远期售股 + ~$12.5B Series A 强制转优先存托）；约 **$60B ATM**（Class C 开盘后，预期约 2027 Q1，**尚未签署、不保证设立**）；2026 CapEx 指引 **$135–145B**；Cornerstone：Nvidia/AMD/Broadcom **分别非连带**有意合计最多 **$5.0B** Class A（非约束）。媒体后续：普通股最终约 $25B、~$625/股、认购约 5×；Nvidia **$3B**〔A，NVIDIA 新闻稿〕、AMD **$1B**〔A，AMD 新闻稿〕〔B 定价细节〕。
- **机制**：强制转优先 + 远期售股 + 未来无投票权 Class C ATM，稀释投票权可控；同步扩大 Muse 与 Vera Rubin/Vera CPU/Spectrum-X/BlueField-4/OpenShell 全栈绑定〔A〕。
- **格局含义**：公开市场历史上最大量级 AI 股权融资之一；与 Alphabet 负 FCF、Anthropic S-1、Broadcom $63B SPV 同框，定义「谁为 2027 算力账单签字」。
- **来源**：investor.atmeta.com；nvidianews；AMD Newsroom；SEC FWP；CNBC。

### TOP3｜Anthropic Form S-1（拟代码 ANT）
- **评分**：格局 5 × 证据 A（提交）/B（财务）≈ **4.5**
- **判断**：首家冲击万亿级估值预期的纯前沿实验室进入公开定价机；把「AI 资本开支能否兑付」从私有融资叙事搬上招股书。
- **关键事实〔A，anthropic.com/news/s1-sec，约 10-26〕**：提交 Form S-1，拟 Nasdaq Global Select、代码 **ANT**；股数与价格区间未定；Goldman/MS 等承销。
- **媒体据 S-1 转述〔B〕**：H1 2026 营收约 **$16.3B**（同比约 +1,300% 量级）；Q2 约 $11.6B；上半年净亏约 **$80.7B**（含大额非经营/估值相关项，口径需读风险因素）；企业客户 14,000+；约 250 家年贡献 ≥$10M；净收入留存约 900% 量级；算力/基建多年承诺报道约 **$600B+**；估值市场预期约 $1.5–2T、路演或 11 月中〔**D/C，非确定**〕。风险因素含灾难性/存在性风险、训练暂停、模型越权等〔B，Reuters 等〕。
- **同周对照〔A〕**：10-27 红队研究展示真实软件攻击链（Chrome RCE 等，协调披露）——一边上市融资，一边展示模型已能打穿浏览器/OS。
- **格局含义**：与 Meta 增发、三云财报同框；Amazon/Google 作为既有金主，上市后利益与治理更透明也更敏感。收入高度依赖 token 消费，对降价与用量弹性敏感〔B〕。
- **来源**：Anthropic S-1 公告；Reuters/CNBC/Fortune；红队研究页。**局限**：未宣称已读完 600+ 页招股书 PDF。

### TOP4｜算力供给+融资改写：Oracle×Google TPU on OCI + Broadcom $63B Anthropic XPU SPV
- **评分**：格局 5 × 证据 A ≈ **4.8**（两条强信号合并为「供给架构」TOP）
- **判断**：本周最强的云侧多架构供给 + 芯片商结构化融资同周落地——竞争变量从「Nvidia 配额」变为「加速器可替换性 + 谁能把算力订单做成可信贷资产」。
- **Oracle〔A，双方 10-27〕**：OCI 将成为 **Google 之外首个提供 TPU 的 hyperscaler**；**CY2027** 起、多年爬坡；TPU **8t**（训练）/ **8i**（推理）；OCI 供电力冷却与租户网，TPU 芯片间走 Google ICI+OCS。同日多架构菜单：Vera Rubin NVL72 GA on OCI；计划部署 OpenAI **Jalapeño**（与 Broadcom）；Cerebras 2027；SambaNova SN50。FY2027 Q1 云基建收入 **$74 亿**（+121%）；当季新增容量 **850MW**〔B，公司披露〕。
- **Broadcom〔A，10-26 财务新闻稿〕**：**$63B** 交易，BofA/Blackstone/Citi/MS 与 Broadcom；SPV 购 Broadcom XPU 与网络方案再租赁给 Anthropic；交付预期 **2027** 起；Broadcom 提供与一优先债权**等额 residual value 支持**。一优先金额媒体有约 $43.5B 说法——**官方未拆分，不采用**。
- **格局含义**：Google 把十年 TPU 工程借 Oracle 企业客户与机房对外变现；Oracle 在上期信用压力后用订单多样性回应；Broadcom 锁定 XPU 出货同时把信用风险留在残值担保——若 Anthropic 或二手加速器弱于预期，损益表外承诺可能显性化。交叉：Samsung **2027 HBM 售罄**〔B〕是共同物理闸门。
- **来源**：oracle.com / cloud.google.com；broadcom.com/financial-releases/64786；Samsung newsroom + 电话会转写。

### TOP5｜OpenAI GPT-6.1 Terra：computer-use 半价下沉（附 Oracle 企业栈）
- **评分**：格局 4 × 证据 A ≈ **4.0**
- **判断**：中档 computer-use 价格腰斩，把「看屏→操作应用」从旗舰专属推到工作日默认档；同周 Oracle 应用层分发再建 Azure 之外的企业入口。
- **关键事实〔A，openai.com 10-26〕**：相对 GPT-5.6 Terra / GPT-6.1 Sol **低 50%**：**$1 / $0.05 / $5** per M input / cached / output；ChatGPT Work 与 Codex 对 Plus/Pro/Ent/Edu 开放；API `gpt-6.1-terra`。厂商自测：Agents’ Last Exam 中档相对 5.6 Terra 高约 15pp、成本约 1/3；Terminal-Bench 4.0 最大推理档 50.3% vs 5.6 Terra 21.5%〔B〕。
- **Oracle×OpenAI〔A，10-27〕**：AI Workspace（ChatGPT 插件打通 Fusion/NetSuite/AI Database/OCI）、AI Security Mesh、App Composer（Codex→OCI）、SMB Bundle（每年 $12,000 OCI 积分 + ChatGPT Business 等，有条款）。
- **格局含义**：直接压 Anthropic/Gemini 同档 API 性价比；对 Salesforce/ServiceNow/SAP 类应用层 AI 施压。OpenAI 购 TPU 传闻〔D，Reuters←The Information〕与 Oracle-TPU 同日共振，**不作确定事实**。
- **来源**：openai.com/index/introducing-gpt-6-1-terra；oracle.com OpenAI 合作新闻稿；EXL Select Partner 10-29〔A〕。

### 候补（未进 TOP5，母稿保留）
Microsoft Azure +48% / VEO；Amazon AWS +39% / CapEx $220B；Kimi K3.1 Pro；腾讯数字生态大会；Cohere Series E；Guidewire×hx $1.7B；Samsung HBM 售罄（并入 TOP4 机制）；NVIDIA $3B Meta + DOJ×HF。


---

## 3. 主线专题深挖｜AI 基建的融资与算力供给重组

### 3.1 问题定义

上期（第 22 期）已观察到：模型商品化后竞争迁往分发/云承诺/治理；Agent 进入系统级执行；AI 资本从股权叙事转向债务与现金流定价。本周三条未消失，但**主轴升级**：账单（CapEx、算力多年承诺、负 FCF、IPO 前亏损）集中到期——市场追问的不再是「谁的模型更好」，而是 **谁能以可持续资本结构，把硅、电力、分发同时交付到 2027**。

### 3.2 机制拆解：三张账单、三种签字人

**（1）已上市巨头：用经营性现金 + 发债/发股续写 CapEx**

| 主体 | 窗内关键信号 | 资本姿态 | 证据 |
|---|---|---|---|
| Alphabet | Cloud +103%；FCF -$9.1B；长期债 $125.1B；ATM 剩余 $27.6B | 负 FCF 第二季；用 ATM/债务撑 PPE | A |
| Meta | ~$35B 承销 + ~$60B ATM 意向；CapEx $135–145B；建 4 个 >1GW supercluster〔媒体/IR〕 | 创纪录股权；芯片商角石 | A/B |
| Microsoft | Azure $33.2B（+48%）；季度 CapEx+融资租赁约 $45.2B；FCF 仍正约 $18.6B（同比 -27%）；VEO 瘦身 | 「可控扩张」：加码基建同时自愿减员 | A/B |
| Amazon | AWS +39%；2026 现金 CapEx 仍约 $220B；TTM FCF 约 -$42.4B；指引 27/28 增速 >40% | 用 backlog（约 $578B）换取市场耐心 | B |

共同机制：AI 基础设施需求被三朵云同周增速确认（GCP +103% / Azure +48% / AWS +39%），但**增长质量 vs 现金消耗**成为定价主轴——Alphabet/Amazon/Meta 更「烧」、Microsoft 相对「控」。

**（2）前沿实验室：IPO + SPV 租赁，把算力承诺移出/部分移出表内**

- Anthropic S-1：把收入爆发与巨额亏损（含非现金项）、$600B+ 量级多年算力承诺〔B〕摊在阳光下；公开市场将直接定价「token 毛利能否覆盖算力账单」。
- Broadcom $63B SPV：银行/PE 出资买 XPU，Anthropic 付租赁，Broadcom 残值担保——**芯片商不直接借钱给客户买货，却用残值支持抬高债项可融资性**〔A〕。上期母稿已提示「为客户融资从优势变风险敞口」；本周规模化落地。

**（3）云与硅：供给从「Nvidia 配额」改为「多架构菜单 + 外售自研加速器」**

- Google：TPU 系统销售写入 Cloud 增长解释〔A〕；并授权 Oracle 2027 起对外租 TPU〔A〕。
- Oracle：TPU + Vera Rubin + Jalapeño + Cerebras + SambaNova 并列〔A〕——客户按 workload 选加速器。
- Amazon：电话会提及 Trainium 需求强劲，考虑约 **2027 年末起对外提供**〔B〕；TorchNeuron 降低 `.to('neuron')` 迁移摩擦〔A〕。
- 芯片商角石：Nvidia $3B / AMD $1B / Broadcom 意向 → Meta 股权〔A〕；Helios 机柜已在 Meta 装机测试〔A〕。
- **物理闸门**：Samsung 称 **2027 HBM 供给已在约定目标价售罄**，紧供给或延续至 2028〔B，电话会〕——所有 GPU/XPU/TPU/MW 叙事最终撞上存储。

### 3.3 竞争含义（对战略与投资观察者）

1. **分发权与供硅权开始拆开**：Google 可同时做 Gemini 对手、TPU 供应商、Cloud 房东；Oracle 可同时分发 OpenAI 应用层与出租 Google TPU。采购合同需显式拆「模型 SLA / 加速器世代 / 残值与提前终止」。
2. **循环资本成为可审计条款**：角石意向非约束，但 Nvidia/AMD 已公开落袋金额；市场将跟踪「芯片商持股客户 ↔ 客户采购芯片」的关联交易披露密度。
3. **信用与残值是同一根系**：Broadcom residual-value、$63B 规模、Anthropic 公开亏损同周出现——若 2027 交付或二手加速器价格不及预期，担保可能显性化。CoreWeave 本周用丹麦 22.5MW + 骨干网做交付叙事〔A〕，不改变高杠杆结构本身。
4. **HBM 校准乐观度**：任何「GW 级 supercluster / 850MW 季度新增」的外推，须用 2027 HBM 售罄做分母。
5. **OpenAI 购 TPU〔D〕**：与 Oracle-TPU 官方公告同日共振，强化「去单一依赖」叙事，但双方未确认——**不得升格为事实**。

### 3.4 主线专题证据锚点（便于审计）

- Alphabet Q3 SEC 99.1｜2026-10-28
- Gemini 4 Carbon blog｜2026-10-28
- Meta IR 股权发行｜2026-10-26；NVIDIA/AMD 新闻稿｜2026-10-26/27
- Anthropic S-1 公告｜约 2026-10-26
- Broadcom $63B｜2026-10-26
- Oracle×Google TPU｜2026-10-27
- Samsung Q3 + 电话会｜2026-10-28/29
- OpenAI Terra｜2026-10-26；Oracle×OpenAI｜2026-10-27

---

## 4. 企业竞争雷达｜上期三条主线的本周增量

上期三条（分发/治理；Agent 执行；资本债务）本周均有增量；资本债务条与 §3 主线专题重叠处不重复展开数字。

### 4.1 分发 / 云承诺 / 治理

| 增量 | 要点 | 证据 |
|---|---|---|
| Oracle×OpenAI 应用层 | Workspace / Security Mesh / App Composer / SMB Bundle——Azure 之外第二条企业分发 | A |
| Oracle 多架构 + TPU | 2027 起 TPU；加速器可替换菜单 | A |
| 字节豆包工作 | 默认开放 Kimi / GLM / DeepSeek，按既有点数结算 | A/B |
| 腾讯 Buddy One + TokenHub | 统一账号/积分/数据池；TokenHub 多模型 | A/B |
| Claude Marketplace | Glean、Runway（窗前上架，本周 Glean 页面更新）把 Anthropic 承诺 spend 变获客 | A |
| Harvey Intake×Claude | 业务侧 Claude 提问，法务 Harvey 控制面 | A |
| FedRAMP 潮 | Perplexity Moderate；Harvey Class D——公共部门管道 | A |
| 主权叙事 | Cohere Series E（加政府最高 C$1.6B）；Mistral Large 4 开源 + MaaS 许可闸 | A |
| NVIDIA×Hugging Face | DOJ 问询约 $12.93B 收购对竞争影响〔B〕——开源分发入口所有权进入监管视野 | B |

### 4.2 Agent 系统级执行与授权

| 增量 | 要点 | 证据 |
|---|---|---|
| GPT-6.1 Terra | computer-use 半价；批处理/桌面流程可规模化 | A |
| Gemini 4 Carbon | 网安 SOTA，Fairwind 限放 | A |
| Anthropic 红队 | 真实攻击链；与 S-1 风险因素互证 | A |
| Sierra | PAP v0.2 冻结；Compliance Console 管主动触达合规 | A/B |
| Cognition | Devin Security 2.0 + Corridor 并入——编码 Agent 付费扩展转向安全 | A |
| xAI Grok Bot | 电话外呼（社交一手 + changelog 滞后争议） | B/C |
| Kimi K3.1 Pro | 长程 Agent/代码；Google 邮件日历插件 | A |
| Databricks | AI Search 吃 Streaming/Iceberg；Serverless 成本闸回应 Agent 账单失控 | A |
| Agility×GXO | Digit 扩至 NC/TN 仓，2027 初——具身「第 N 站点」计量 | A |

### 4.3 资本 / 债务 / 现金流（本周升级摘要）

见 §3。补充：Microsoft VEO（约 6 万 eligible〔B〕）显示「加码 AI 与组织瘦身并行」；宇树三季报收入 +70% 但扣非下滑、研发 +250%〔B〕——中国具身侧「用资产负债表换模型」镜像海外 CapEx 叙事。


---

## 5. 分组对象条目

> 有料对象写机制级摘要；静默写一行核验说明。完整事实链与 URL 见对应 shards。数字均来自分片/primary-notes。

### 5.1 A 组｜全球巨头与平台

#### OpenAI｜有动态
- **GPT-6.1 Terra（10-26）**：computer-use 高效档；API **$1/$0.05/$5** per M，相对 5.6 Terra / 6.1 Sol **低 50%**；Work/Codex 对 Plus/Pro/Ent/Edu〔A〕。Benchmark 为厂商自测〔B〕。
- **Oracle AI World（10-27）**：Workspace / Security Mesh / App Composer / SMB Bundle〔A〕——应用层分发，不只卖 API。
- **EXL Select Partner（10-29）**：强监管行业渠道下沉〔A〕。
- **ChatGPT 订阅附赠 API credits（约 10-28）**：最高约 $500/月促销额度〔C，第三方转述〕。
- **购 Google TPU 传闻（10-27/28）**：Reuters←The Information；双方未确认〔**D**〕。
- **背景非本周**：训练环境 hardening（~10-23）、NASK 波兰、Orchestra Bio、科学发现主帖等。
- 分片：`shards/A/openai.md`

#### Google DeepMind / Gemini / Alphabet｜有动态
- **Q3（10-28）**：见 TOP1；Cloud +103%、Search +12%、FCF -$9.1B、债 $125.1B、Gemini App 10 亿、~32B tok/min〔A〕。
- **Gemini 4 Carbon（10-28 blog）**：前沿 + 网安 SOTA；Fairwind 限放；$2/$10→$4/$20〔A，primary-notes / 官方博客〕。Argon/Carbon 财报亦称「处于前沿领先」〔A〕。
- **竞争**：唯一把 TPU 外售写入 Cloud 增长解释；对 Nvidia 形成结构性替代叙事（与 Oracle-TPU、OpenAI-TPU 传闻共振，后二者 D 或 2027 才爬坡）。
- 分片：`shards/A/google.md`（注：分片曾低估 Carbon 独立产品页；以一手博客为准）

#### Anthropic｜有动态
- **S-1 / ANT（约 10-26）**：见 TOP3〔A/B；估值日程 D〕。
- **红队（10-27）**：内部模型打出真实攻击链；协调披露 90+45 天〔A〕。
- **背景**：Agent Skills 捐赠 AAIF（10-22 窗外）。
- 分片：`shards/A/anthropic.md`

#### Meta AI｜有动态
- **~$95B 股权计划（10-26）**：见 TOP2〔A/B〕。
- **NVIDIA 扩大 Muse 合作**：Vera Rubin/CPU、Spectrum-X、BlueField-4、OpenShell；Nvidia 投 $3B〔A〕。
- **背景**：Muse 产品首发早于本周；本周是融资与供应绑定增量。
- 分片：`shards/A/meta.md`

#### Microsoft AI / Copilot / Azure｜有动态
- **VEO（10-26）**：美加印英、level≤70、参与组织内自愿限时；官方未写 6 万，媒体称约 60,000 eligible〔A 条款 / B 规模〕。
- **FY27 Q1（10-28）**：营收 $92.3B（+19%）；Microsoft Cloud $63.9B（+30%）；**Azure +48%、首次披露 $33.165B**；Agents and Infra $76.8B（+25%）；商业 RPO $677B（+73%）；季度 CapEx+融资租赁约 $45.2B〔A/B〕；FCF 约 $18.6B（同比 -27%）〔B〕；Copilot 日活环比约 +50% 等〔B〕。
- **格局**：三云加速中唯一保持较「可控」正 FCF；VEO 进入费用指引。
- 分片：`shards/A/microsoft.md`

#### Amazon / AWS｜有动态
- **Q3（10-29）**：集团营收约 $201.9B（+12%）；AWS 约 **$46.0B（+39%）**、OI 约 $17.8B；run-rate 约 $184B；backlog 约 $578B；指引 27/28 **>40%**；2026 CapEx 仍约 **$220B**；TTM FCF 约 **-$42.4B**；Bedrock 含 OpenAI 用量上升；Trainium 或 **2027 末外售**〔B〕。
- **产品（10-26 周报）**：TorchNeuron 公开测试；Polly Generative；Continuum GA〔A〕。
- **Verizon >$20 亿光纤合作（10-26）**〔B〕。
- 分片：`shards/A/amazon.md`

#### xAI｜弱–中
- Musk 10-25 宣布 Grok Bot 外呼〔B〕；changelog 是否同步存在滞后争议〔C〕。
- v0.78.1（10-27）：购物卡片、Shop Pay、团队 Vault 等〔A〕。
- 无窗内独立融资一手；Partner Network/$40B GPU 债务等不纳入〔D/背景〕。
- 分片：`shards/A/xai.md`

#### NVIDIA（战略）｜有动态
- 投 Meta **$3B** + Muse/Vera/Spectrum/BlueField/OpenShell〔A，10-26〕。
- **DOJ 问询 Hugging Face 收购**（约 $12.93B；预计 2027 H1 完成）〔B，Reuters 10-28〕。
- Minerva/OpenShell 产品稿多标 10-22 → 窗外背景。
- 分片：`shards/A/nvidia.md`

### 5.2 B 组｜中国头部

#### 阿里 / 千问 / 百炼｜有动态
- 10-25 千问×夸克网盘：自然语言检索/整理/回存〔B〕。
- 10-27 百炼 `qwen-audio-3.1-realtime-flash` 实时双工〔A〕。
- 10-29 上架蚂蚁 `Ling-3.1-flash`（平台货架，非自研旗舰）〔A〕。
- 无窗内 Qwen 旗舰大版本。
- 分片：`shards/B/B-part-01.md`

#### 字节 / 豆包 / 火山｜有动态
- 10-24 方舟上架 `kimi-k3-1-pro-261024`〔A〕。
- 10-29 豆包工作默认开放 Kimi 3.1 Pro / GLM 5.3 / DeepSeek V4.1 Flash，按既有 AI 点数〔A/B〕。
- IDC 26H1 中国 MaaS 106.3 亿元，火山份额 **45.1%** 第一〔B，本周新披露半年度〕。
- 分片：`shards/B/B-part-01.md`

#### 腾讯 / 混元 / WorkBuddy｜有动态
- 10-29 全球数字生态大会：Hy4 正式版将发（首次视觉理解）+ Hy4 Flash；Buddy One；正式发布「腾讯网盘」作 Agent 记忆；WorkBuddy 累计约 **90 亿次**任务、覆盖中国 500 强约 50%〔A 产品 / B 经营数字〕。
- 10-26 元宝 PC 换肤弱动态。
- 分片：`shards/B/B-part-02.md`

#### 百度 / 文心 / 千帆｜有动态
- 10-27 Unlimited OCR 2 开源（任意页数文档解析；机制 SR-SWA）〔A；基准 B〕。
- 10-29 武汉超级智能体大会；称前三季度大模型项目中标金额云厂商第一〔B〕。
- 百度世界 11/12 预告（窗外举行）。千帆窗内无新 LLM 条目。
- 分片：`shards/B/B-part-02.md`

#### 华为昇腾 / 盘古｜有动态（算力）
- 10-28 武汉：全国首个昇腾 **950DT 1024 卡**液冷超节点点亮；FP8 约 1 EFLOPS 等规格〔A，大会报道〕。
- 10-24 南都：DeepSeek–华为「共生」、昇腾组件开源、驻场等〔B/C〕。
- 盘古：无公司级模型大版本。
- 分片：`shards/B/B-part-02.md`

#### DeepSeek｜有动态（流量）
- OpenRouter 约 10/19–25 周：V4.1-Flash-1017 约 **33.6 万亿 Token** 登顶，环比约 +801%〔B/C，10-26 披露〕。
- 千亿融资为 **10-22 窗外背景**；V5 标识〔D〕不升格。
- 分片：`shards/B/B-part-03.md`

#### 智谱｜弱动态
- 官方发布记录无 10/24–29 新模型〔A〕。
- 10-28 港股异动押 GLM-5.5〔B 股价 / D 即将发布〕。
- 豆包工作接入 GLM 5.3 为确定分发增量（见字节）。
- 分片：`shards/B/B-part-03.md`

#### 月之暗面 / Kimi｜有动态（强）
- 10-24 **Kimi K3.1 Pro**（约 3 万亿参、1M 上下文）+ Highspeed（约 2–3× 输出速）；**完整权重计划 11/4 前**〔A〕；官方基准〔B〕。
- 10-24 当日进火山方舟；10-29 Google 插件（Gmail/Drive/日历）〔A〕。
- 分片：`shards/B/B-part-03.md`

#### MiniMax｜弱动态
- OpenRouter：M3.1 Flash（**10-19 窗外发布**）约 13.7 万亿 Token 居全球前三〔B/C〕。
- 无窗内官方新品/融资；破发深度稿多在 10-22 窗外。
- 分片：`shards/B/B-part-03.md`

### 5.3 C 组｜应用与垂直头部

#### Perplexity｜有动态
- 10-28 FedRAMP Class C (Moderate)；自称唯一带 live web search 的 Moderate SI；GSA MAS 可采〔A，博客正文片段；官网 Cloudflare〕。分片：`C-part-01.md`

#### Midjourney｜无动态
- 核验 updates：最近官方 10-08 Thinking Mode。静默。

#### Runway｜有动态
- 10-26 App Studio：自然语言生成创意应用，含在付费计划、走积分〔A〕。Claude Marketplace 为 10-20 背景。

#### Harvey｜有动态
- 10-28 FedRAMP Class D；Intake×Claude artifact；10-27 Latham 基金形成设计合作〔A〕。

#### Sierra｜有动态
- 10-24 PAP/Poppy v0.2 冻结〔A〕；10-28 Compliance Console〔A/B，Unite.AI 转述〕。

#### Glean｜有动态
- Claude Marketplace（页面更新 10-26）：可用 Anthropic 承诺 spend 购买〔A〕。

#### Databricks｜有动态
- 10-26 AI Search 接 Streaming/MV/Iceberg；Lakeflow 生产力+OpenAI/Anthropic 用量连接器；10-29 Serverless 成本控制 GA/Beta〔A〕。

#### Cohere｜有动态
- 10-29 Series E 首关，目标最高 **CAD $7B**、估值 CAD $35.7B；Schwarz 领投；加政府最高 **C$1.6B** 股权；承诺 2030 前 ≥1000 加国技术岗、≥C$1.7B 算力等〔A〕；ARR 同比 +165%、客户至 300〔B〕。

#### Mistral｜有动态
- 10-29 Large 4（Le Chonk）开源权重：~1T/52B MoE；API $0.70/$2.10；MaaS 商用需另许可〔A〕；编码/网络榜〔B〕。

#### Scale｜有动态
- 10-26 UAE DIFC 实体；10-28 Qatar Pearl 长租；10-29 FineART 开源机器人数据/模型〔A〕。

#### Cursor/Anysphere｜无窗内重大公司动态
- Agent SDK 10-20 背景；无窗内融资/并购一手。

#### Cognition / Devin｜有动态
- 10-26 Devin Security 2.0；10-28 Corridor 并入〔A〕。

#### 名单外 · Serval｜有动态
- 10-29 $150M Series C @$3B，Sequoia 领投〔B，SiliconANGLE〕。

#### 名单外 · Guidewire × Hyperexponential｜有动态
- 10-27 **$1.7B 现金** + 最高 $400M 或有；agentic 核保；预计 FY2027 Q2 交割〔A〕。

### 5.4 D 组｜算力云硬件与具身

#### AMD｜有动态
- 10-27：Helios 已在 Meta 装机测试；投 Meta **$1B**；定制 Instinct / MI450 早期定义；路线至 MI500〔A〕。同日 Oracle E7=第6代 EPYC、Pensando 入 Acceleron〔A〕。

#### Broadcom｜有动态
- 10-26 **$63B** Anthropic XPU SPV + residual value〔A〕。Meta 角石意向（非约束）〔A〕。

#### CoreWeave｜有动态
- 10-27 丹麦 DEN01 大部 **22.5MW** 上线（Blackwell）；欧洲 5 地理 9 DC；骨干网中东/亚太 PoP，完整环路目标 2027 中〔A〕。上期信用压力后的交付叙事。

#### Oracle Cloud｜有动态
- 见 TOP4：TPU 2027 + 多架构；云基建 $74 亿 +121%、850MW〔A/B〕。交叉 OpenAI 企业栈。

#### Tesla Optimus｜无动态（窗内）
- 量产确认 10-21 窗外；本周无新 IR/博客。静默核验。

#### Figure｜无动态（窗内）
- design lock ~10-22 窗外；figure.ai 无窗内新条。静默核验。

#### 宇树｜有动态
- 三季报（10-28 披露，媒体转述）：Q3 营收 6.65 亿（+69.93%）；归母净利 1.13 亿（-17.37%）；扣非 -17.42%；Q3 研发 1.27 亿（**+249.58%**）；前三季度经营现金流净额同比 -54.69%；货币资金约 73.54 亿〔**B**；cninfo PDF 本次未取得〕。中试基地增资 2000 万〔B〕。银河星仔事件日 10-22 窗外。

#### 优必选｜有动态（披露级）
- 中欧数字协会 MoU（披露 10-25；签署约 10-22）〔B〕。MoU≠订单。

#### 名单外 · Agility × GXO｜有动态
- 10-26：Digit 扩至 NC Statesville 与 TN Lebanon；佐治亚已转运 >100,000 箱；2027 初先 Digit 4〔A〕。本周唯一海外具身「多站点扩部署」一手。

#### 名单外 · Samsung HBM｜有动态
- Q3 营收 195.3 万亿韩元、营业利润 107.4 万亿〔A〕；HBM4 销量环比 >3×、占 HBM 约 60%；**2027 HBM 售罄**，紧供给或至 2028〔B〕。

#### 名单外 · OpenAI×Google TPU｜传闻
- Reuters←TI 10-27；双方未确认〔**D**〕。


---

## 6. 必出对比表（强信号 16 行）

| 公司 | 事件类型 | 日期 | 要点 | 竞争/格局含义 | 证据级 |
|---|---|---|---|---|---|
| Alphabet | 财报 | 10-28 | 营收 $127.6B；Cloud $30.7B +103%；Search +12%；FCF -$9.1B；债 $125.1B | Cloud+TPU 外售 vs AI Mode 单位广告承压；市场杀估值 | A |
| Google | 产品发布 | 10-28 | Gemini 4 Carbon：网安 SOTA；Fairwind 限放；$2/$10→$4/$20 | 前沿+安全双叙事；与 Anthropic 红队同周对照 | A |
| Meta | 股权融资 | 10-26 | ~$35B 承销 + ~$60B ATM 意向；CapEx $135–145B；角石至多 $5B | 发股续命；循环资本坐实 | A |
| NVIDIA | 战略投资 | 10-26 | 投 Meta $3B；扩大 Muse/Vera/Spectrum/OpenShell | 卖硅→入股+全栈+安全框架捆绑 | A |
| AMD | 战略投资/产品 | 10-27 | 投 Meta $1B；Helios 装机；Oracle E7/Pensando | 第二供应商整机柜可核 | A |
| Anthropic | IPO 申报 | ~10-26 | Form S-1，代码 ANT；H1 收约 $16.3B、亏约 $80.7B（媒体） | 实验室进入公开定价机 | A/B |
| Broadcom | 结构化融资 | 10-26 | $63B SPV 购 XPU 租给 Anthropic；残值支持=一优先 | 芯片商变信用担保人；2027 交付资产化 | A |
| Oracle | 云供给+伙伴 | 10-27 | Google TPU→OCI（2027）；多架构菜单；×OpenAI 企业栈 | 加速器可替换 + Azure 外应用分发 | A |
| OpenAI | 产品+分发 | 10-26/27 | GPT-6.1 Terra 半价 computer-use；Oracle Workspace 等 | 中档 agent 性价比下沉；企业入口多元化 | A |
| Microsoft | 组织+财报 | 10-26/28 | VEO（约 6 万 eligible）；Azure +48% 首披露 $33.2B | 加码基建与自愿减员并行；FCF 相对可控 | A/B |
| Amazon | 财报+产品 | 10-26/29 | AWS +39%；CapEx $220B；TorchNeuron；Trainium 或 2027 末外售 | 三云需求确认；自研硅外售意向 | B/A |
| Samsung | 财报/供给 | 10-28/29 | 2027 HBM 售罄；紧供给或至 2028 | 全行业物理闸门 | A/B |
| 月之暗面 | 产品发布 | 10-24 | K3.1 Pro + 计划 ≤11/4 开源；进方舟与豆包工作 | 国内独立实验室旗舰+开源节奏 | A |
| 字节跳动 | 平台策略 | 10-24/29 | 方舟上架 Kimi；豆包工作默认三方模型；IDC MaaS 45.1% | 工作台多模型 > 单模型绑死 | A/B |
| 腾讯 | 战略发布 | 10-29 | Hy4 将发；Buddy One；腾讯网盘；WorkBuddy 90 亿次 | Agent 办公 OS 叙事 vs 字节多模型默认 | A/B |
| Cohere | 融资 | 10-29 | Series E 目标最高 CAD $7B；加政府最高 C$1.6B | 主权 AI 资本化锚 | A |
| Guidewire | 并购 | 10-27 | $1.7B 现金购 Hyperexponential（+最高 $400M 或有） | 垂直 Agent 被核心系统内化 | A |
| CoreWeave | 扩容/网络 | 10-27 | 丹麦 22.5MW；全球 AI 骨干网 PoP | 信用压力后的交付叙事 | A |

（OpenAI 购 TPU、Anthropic 估值/上市日、GLM-5.5 即将发布等 **D 级**不入本表主行。）

---

## 7. 周环比素材

详见同目录 **`wow.md`**（延续 / 新出现 / 消失）。摘要：

- **延续**：分发（Oracle×OpenAI、多模型工作台、Claude Marketplace）；Agent 执行（Terra、Carbon、红队、PAP、Devin Security、Kimi）；资本从「债务定价」升级为「股权+SPV+负 FCF 同框」。
- **新出现**：Alphabet AI Mode 杀估值；Meta $95B+角石；Anthropic S-1；Broadcom $63B；Oracle-TPU；Samsung HBM 售罄；Gemini 4 Carbon；Kimi K3.1 Pro；Cohere/Mistral 主权双路径；Guidewire×hx。
- **消失/降温**：Tesla Optimus / Figure 窗内静默；DeepSeek 融资窗外（本周改流量）；Muse 首发叙事让位于融资绑定；CoreWeave/Oracle「纯信用危机」叙事被交付/多架构增量改写（信用风险未消）。

---

## 8. 洞察｜对投资与战略观察者意味着什么

1. **定价轴迁移**：从「模型榜单 / 用户数」迁到「单位广告收入、FCF、算力承诺覆盖、HBM 可得性」。Alphabet 同周 Cloud 暴增与 Search 承压被市场拆开定价，是教学样本。
2. **资本结构成为产品战略**：Meta 发股、Anthropic IPO、Broadcom SPV、Oracle 多架构——2027 算力交付的竞争，一半在机房，一半在招股书与信贷文件。尽调清单应增加：残值担保条款、角石是否最终交割、ATM 是否设立、TPU/Trainium 外售 SLA。
3. **分发比基座更稀缺**：OpenAI 借 Oracle 应用层、字节/腾讯抢企业工作台、Glean/Harvey 借 Claude 预算池——「谁出现在客户已有合同与积分池里」决定短期收入弹性。
4. **安全是双刃剑需求侧**：Carbon 限 Fairwind、Anthropic 红队、Devin Security、AWS Continuum、Oracle Security Mesh 同周——企业安全预算↑，同时抬高滥用与监管溢价；S-1 风险因素将持续定价。
5. **中国对照**：平台侧（豆包三方模型、Buddy One）与独立实验室（Kimi 旗舰+限时开源）并行；昇腾 950DT 点亮是供给曲线观察点；DeepSeek 流量登顶≠收入确认；智谱/MiniMax 本周可读信号偏情绪。
6. **具身计量尺**：Agility「第 2/3 商业仓」vs Tesla/Figure 静默 vs 宇树「收入高增、扣非与研发」——交付地理学与费用结构开始替代演示视频。
7. **勿升格**：OpenAI 购 TPU、Anthropic 万亿估值与 11 月上市日、GLM-5.5、DeepSeek V5——一律 D 或窗外。

---

## 9. 覆盖与局限

### 9.1 已覆盖
- 固定对象 37：有料 30 + 弱 2 + 静默 4；名单外深写约 12 条线索。
- 一手核验：Alphabet SEC 99.1、Gemini 4 Carbon blog、Meta IR、Microsoft VEO 博客、OpenAI Terra、Oracle×Google TPU、Oracle×OpenAI、Broadcom $63B、AMD/NVIDIA Meta、Anthropic S-1 公告页、红队研究、CoreWeave、Samsung newsroom、GXO×Agility、Cohere/Mistral/Harvey/Runway/Databricks/Scale/Cognition 等官方稿；中国侧百炼/方舟文档、科技日报/智东西/新华网等。
- 主线专题三问（发生了什么 / 机制 / 格局）已在 §3 回答；WoW 见 wow.md；对比表见 §6。

### 9.2 局限与未取得
| 项 | 说明 |
|---|---|
| Anthropic 完整 S-1 PDF | 以公告 + 主流媒体交叉；未宣称读完 600+ 页；财务脚注口径标 B |
| Amazon IR 原始 PDF | 依赖 CNBC/Seeking Alpha 等对官方声明与电话会转述〔B〕 |
| 宇树 cninfo 三季报 PDF | HTTP 500 未取得；关键数字 B，建议补读升 A |
| 优必选官网 IR / 协会原文 | 仅二手转述公司发文〔B〕 |
| Perplexity / Sierra 官网全文 | Cloudflare / WebFetch 超时；主张限述搜索返回正文或二手（见 needs-browser） |
| Gemini Carbon | A 组 google 分片曾未单独精读产品页；**已用 primary-notes + 官方博客补强为 A** |
| Broadcom 是否最终买入 Meta 股份 | 窗内未确认交割；角石为非约束意向 |
| OpenAI 购 TPU | D，双方未确认 |
| Microsoft Cosmos DB scaling 线索 | 窗内无可靠一手，落空 |
| 科大讯飞 1024 | 主会 10-22 窗外，仅 discovery 备忘 |
| DeepSeek 千亿融资 | 10-22 窗外背景 |
| Tesla Optimus / Figure | 窗内静默；背景见上期 |
| 开源 Agent 工程细节 | 本报不覆盖（归 Agent 周报）；仅公司战略层提及开源（Mistral 权重、Kimi 计划开源、OCR 2、FineART 等） |

### 9.3 证据纪律提醒
- 媒体股价跌幅、市值蒸发、认购倍数等标 C。
- 经营自述（90 亿次任务、ARR +165%、中标第一等）标 B。
- 传闻与未定日程标 D，不进入 TOP5 确定事实句。

---

## 10. 来源清单（主入口；完整 URL 见各分片）

### 一手 / 官方
- Alphabet SEC Exhibit 99.1 Q3 2026｜https://www.sec.gov/Archives/edgar/data/1652044/000165204426000080/googexhibit991q32026.htm
- Gemini 4 Carbon｜https://blog.google/innovation-and-ai/models-and-research/gemini-models/introducing-gemini-4-carbon/
- Meta IR 股权发行｜investor.atmeta.com（2026-10-26）
- Meta SEC FWP｜sec.gov .../d116268dfwp.htm
- NVIDIA×Meta｜nvidianews.nvidia.com（2026-10-26）
- AMD×Meta / AMD×Oracle｜newsroom.amd.com（2026-10-27）
- Anthropic S-1 公告｜https://www.anthropic.com/news/s1-sec
- Anthropic 红队｜https://www.anthropic.com/research/discovering-vulnerabilities-with-claude
- OpenAI GPT-6.1 Terra｜https://openai.com/index/introducing-gpt-6-1-terra/
- Oracle×Google TPU｜oracle.com/.../google-tpus-to-oracle-cloud-infrastructure-2026-10-27/
- Google Cloud TPU on OCI 博客｜cloud.google.com/blog/.../bringing-google-tpus-to-oracle-cloud-infrastructure
- Oracle×OpenAI｜oracle.com/.../oracle-reinvents-enterprise-computing-...-openai-2026-10-27/
- Broadcom $63B｜https://www.broadcom.com/company/news/financial-releases/64786
- Microsoft VEO｜https://blogs.microsoft.com/blog/2026/10/26/introducing-a-voluntary-exit-offer/
- Microsoft FY27 Q1｜microsoft.com/investor
- AWS Weekly Roundup｜aws.amazon.com/blogs（2026-10-26）
- CoreWeave｜investors.coreweave.com（2026-10-27）
- Samsung Q3｜news.samsung.com（2026-10-29）
- GXO×Agility｜investors.gxo.com（2026-10-26）
- Cohere Series E｜cohere.com/blog；pm.gc.ca；PR Newswire（2026-10-29）
- Mistral Large 4 OSS｜mistral.ai/news/mistral-large-4-oss/
- Harvey / Runway / Glean / Databricks / Scale / Cognition / Sierra PAP 等｜见 shards/C
- 火山方舟模型发布公告｜docs.volcengine.com（更新 10-24）
- 阿里云百炼模型上下架｜help.aliyun.com
- 智谱发布记录｜docs.bigmodel.cn

### 权威媒体交叉（B/C）
- CNBC：Meta 融资、Microsoft/Amazon/AWS 财报、Nvidia 投 Meta
- Reuters：OpenAI-TPU 传闻、DOJ×Hugging Face、Anthropic S-1 风险因素、VEO 规模
- 科技日报 / 智东西：腾讯数字生态大会
- 新华网：百度 Unlimited OCR 2
- 第一财经 / 新浪科技 / IT之家：Kimi K3.1 Pro、Google 插件、昇腾集群
- 界面 / 每经：OpenRouter 周榜、豆包工作、IDC MaaS
- 华尔街见闻 / 每经：宇树三季报
- SiliconANGLE：Serval Series C
- Guidewire 新闻稿：Hyperexponential 收购

### 内部
- `primary-notes.md`｜`prior/wow-seed.md`｜`wow.md`｜`shards/A|B|C|D/**`

---

## 冻结声明

本稿为第 23 期研究母稿冻结版（2026-10-30 11:20 Asia/Shanghai）。后续读者稿（report2article）只许压缩与改写表述，不得新增未在本稿或分片出现的事实与数字；证据级 A–D、覆盖与局限、完整对比表保留于 archive，不进入读者正文。

