# 全球 AI 动态周报 · 第 24 期 · 研究母稿（冻结）

- **窗口**：2026-10-31 00:00 ~ 2026-11-05 24:00（Asia/Shanghai）。「本周」只指此区间；窗外信息一律标「背景，非本周」。
- **上期**：第 23 期（窗口 2026-10-24 ~ 2026-10-29）。
- **期号**：第 24 期。**运行日**：2026-11-06。
- **冻结时间**：2026-11-06（Asia/Shanghai）。
- **读者透镜**：公司战略观察者 / 投资人（R1 主责，R4 协同）。开源 Agent 工程细节不展开，仅在公司战略层一句。
- **版本**：master.md v1（冻结）。读者稿只从本稿取材；证据级 A–D、覆盖与局限、完整对比表只留在本稿与 archive。
- **依据**：`raw/group-a-primary.md`、`group-a-discovery-candidates.md`、`group-b-primary.md`、`group-c-primary.md`、`group-c-discovery-candidates.md`、`group-d-primary.md`、`group-d-discovery-candidates.md`、`prior-wow.md`、`prior-master.md`；以及 `shards/A|B|C|D/` 全部分片与 discovery。
- **证据级**：**A** 可核原始事实（官方稿/SEC/监管/公司财报）｜**B** 具名披露或权威媒体对一手的精读转述｜**C** 多源交叉/行情转述｜**D** 欠证/传闻/日程未定。
- **纪律**：**结论强度 ≤ 证据强度**；数字紧邻出处；传闻标 D 不进 TOP 确定句；材料没有的写「机制未取得」；「未核到」不写成「未发生」。
- **已知空档**：**10-30** 不在上期窗口（止于 10-29）也不在本期窗口（始于 10-31）。落在此日的事件（Sierra $400M+ ARR、OpenAI GPT-6 Rosalind Research 扩容等）按窗外处理，仅作背景。见 §9。

---

## 本期一句话主线

**Agent 工作台并购周——模型能力已经便宜到可以随便买，于是钱开始买「模型之外那一层」：谁存你的 diff、谁调度你的多个 agent、谁替你登录那个没有 API 的网站。**

---

## 1. 覆盖统计

| 组 | 固定对象 | 有料 | 弱（仅被他方引用） | 静默（已核验） | 名单外纳入 | 分片 |
|---|---|---|---|---|---|---|
| A 全球巨头与平台 | 8 | **8** | 0 | 0 | 7（Pierre、Conductor、Anon、Jus Mundi、World Labs、Taalas、Fireworks） | `shards/A/` |
| B 中国头部 | 9 | **3** | 2（月之暗面、智谱） | 4（阿里、百度、华为、MiniMax） | 2（豆包工作三方模型、DeepSeek Harness 生态） | `shards/B/` |
| C 应用与垂直头部 | 12 | **10** | — | 2（Midjourney、Scale AI） | 4（Anon、Jus Mundi、Fireworks、Lopezmarqués） | `shards/C/` |
| D 算力云硬件与具身 | 8 | **4** | — | 4（CoreWeave、Tesla Optimus、Figure、宇树） | 2（World Labs/Taalas、Helios 五客户） | `shards/D/` |
| **合计** | **37** | **25** | **2** | **10** | **约 8**（去重后） | — |

**窗内一手事件（紧口径，去重）**：A 组 **17** + B 组 **3** + C 组 **14** + D 组 **7** = **41**。

> 计数口径说明：A 组 17 = OpenAI×6（Cyber / Linux 管线 / Pierre / Images 2.6 / GovCloud / Dots）、Google×3、Anthropic×1、Meta×2、Microsoft×2（Studio + Foundry 汇总）、AWS×1、xAI×1、NVIDIA×1；不含 NVIDIA 三条垂直 feature、Meta GSLM2 题录、OpenAI 澳洲高校。B 组 3 不含豆包三方模型（媒体级）。C 组 14 = 把 Glean 两条并为「平台更新」、Harvey 客户采用并入合作条（分开计为 16）。D 组 7 全为官方稿（优必选为 B）。

**体量与结构**：本周是**并购与账本周**，不是模型发布周。37 个固定对象中，**11-04 → 11-05 两天内**集中了 3 笔 Agent 栈并购、1 份 S-1/A 修正案、1 份硬财报；最大的模型发布是腾讯 Hy4（国产开源）与 OpenAI GPT-6 Cyber（垂类专用），无通用旗舰基座换代。

### 1.1 固定对象覆盖明细

| 组 | 对象 | 窗内状态 | 一句话 |
|---|---|---|---|
| A | OpenAI | 有动态（强） | GPT-6 Cyber 判 Critical；收购 Pierre；948 个 Linux LPE 管线；Daybreak Red 进 AWS GovCloud |
| A | Google / Gemini / Alphabet | 有动态 | Omni 1.2 Flash（15s、$0.07/秒、−30%）；Antigravity 化学技能；英国 PlanAssist 扩至 15 地 |
| A | Anthropic | 有动态（资本侧） | S-1/A：9M 收入 $33,242M、Q3 $17.0B、承诺 ~$895.4B、现金 $131,845M；产品静默 |
| A | Meta AI | 有动态 | Conductor 加入（云 11-20 删数据）；Muse 实时语音 + 形象先美国 |
| A | Microsoft | 有动态 | Copilot Studio 持久化 agent（自带凭证 + 业务记忆 + 触发器）；Foundry Browser Automation GA |
| A | Amazon / AWS | 有动态 | Web Answer on AgentCore GA：一次 MCP 调用、带引用、$10/1,000 次 |
| A | xAI | 有动态 | Data Bot：常驻 Slack 的团队数据科学 bot，xAI 称一周约 70 小时工作量 |
| A | NVIDIA | 有动态 | Vera：1.6× agents/watt、2× agent 速度（厂商与伙伴自测）；财报 11-17 |
| B | 腾讯 / 混元 | 有动态（强） | Hy4：首次视觉理解 + Computer Use（CLI+GUI）；定价 6/18 元不变；权重「将近期开源」 |
| B | 字节 / 豆包 / 火山 | 有动态 | doubao-seed-evolving 强化规划/验收；豆包工作接三方模型（据媒体） |
| B | DeepSeek | 有动态（开源） | MIT 开源 dsh-superagent-prototype（单仓主动编码 agent 研究原型） |
| B | 月之暗面 / Kimi | 弱 | 无自有窗内发布；K3.1 Pro 被他方引为对照；「≤11/4 开源」**未核到**兑现 |
| B | 智谱 | 弱 | GLM-5.3 出现在腾讯对照与豆包接入报道（后者据媒体） |
| B | 阿里 / 千问 / 百炼 | 静默 | 未核到窗内官方一手（媒体「神秘新模型」无官方页，D） |
| B | 百度 / 文心 | 静默 | 未核到窗内官方一手 |
| B | 华为昇腾 / 盘古 | 静默 | 未核到窗内官方一手（盘古无公司级大版本） |
| B | MiniMax | 静默 | 未核到窗内官方一手 |
| C | Sierra | 有动态（强） | 收购 Anon：agent 的浏览器登录/表单基础设施；条款未披露 |
| C | Perplexity | 有动态 | Teammates 常驻 agent（含 agent 间交接）；Agent API 各档改进（数值待核） |
| C | Runway | 有动态 | Characters 57B 实时：8×H100 → 4×H100，24.5fps，99.5% 会话达标 |
| C | Harvey | 有动态 | Jus Mundi A2A 接入；西班牙律所全所采用 |
| C | Glean | 有动态 | Fireworks 生态 + Release 567（Auto 路由、75%/90% 成本闸） |
| C | Databricks | 有动态 | Spark 4.3（P99 136–141ms）；Claude 原生 OTel → MLflow；Lakebase on GCP GA |
| C | Cohere | 有动态 | Model Vault 上架开源模型（默认零留存）；Embed/Rerank 5 上 OpenRouter |
| C | Mistral | 有动态 | Studio 扩展：托管 agent / workflow / 企业应用 / OTel / evals，可 on-prem |
| C | Cursor / Anysphere | 有动态 | Build Live Apps：云 agent 生成 app + Postgres + SSO + 托管 |
| C | Cognition / Devin | 有动态 | 多仓扫描上限 500 → 1,000；Findings 对话化 |
| C | Midjourney | 静默 | 最近官方稿 10-08；V9「30 天内」仅 Discord 转述（D） |
| C | Scale AI | 静默 | 窗内无官方发布；UAE/Qatar/FineART 均 10 月下旬窗外 |
| D | AMD | 有动态（强） | Q3 营收 $13.377B（+45%）、DC $8.546B（+97%）；Helios 在五家运行；Q4 ~$17B |
| D | Broadcom | 有动态 | VCF 私有 AI 组合；Tanzu 数据底座 GA（含嵌入式 MCP）；1.5× BDP 网络规则 |
| D | Oracle Cloud | 有动态（轻） | FDI Fusion Agents Repository：agent 以 ZIP 构件分发 |
| D | 优必选 | 有动态（披露级） | Thinker-Sim Real2Sim2Real 仿真平台（B，官微经媒体） |
| D | CoreWeave | 静默 | 最近一手 10-27（丹麦 22.5MW）；Q3 电话会 11-10 |
| D | Tesla Optimus | 静默 | 无官方稿；12 月预订仅媒体 + Musk 否认（D） |
| D | Figure | 静默 | figure.ai/news 窗内无条目；全 hands 停在约 10-22 |
| D | 宇树 / Unitree | 静默 | 官网新闻中心窗内无稿；Q3 数字仅媒体（B/C，不进数字句） |

---

## 2. TOP5（公司向；含评分与证据；每条三问）

**评分方法**：战略格局冲击（0–5）× 证据强度（A=1.0 / B=0.85 / C=0.7 / D=0.4）× 窗内新鲜度。分数只用于内部排序，不构成对公司的评价。

**本期 TOP5 的设计逻辑**（便于读者理解取舍）：TOP1 是**资本侧锚点**，TOP2/3/5 是**主线三角的三条边**，TOP4 是**供给侧反证**。四类证据合起来回答同一个问题：为什么这一周的钱流向了流程层而不是算力层。

---

### TOP1｜Anthropic S-1/A：$17.0B 单季、$895.4B 承诺、ANT

- **评分**：格局 5 × 证据 **A** ≈ **5.0**
- **判断**：第一家纯前沿实验室把完整账本摊到公开市场面前。真正刺眼的不是收入增速，而是**承诺/收入的比例结构**——它把「AI 需求是否可持续」从叙事问题变成了可验算的算术题。

**① 发生了什么（A，SEC S-1/A 修正案 No.1，2026-11-02，注册号 333-299633）**

| 项 | 数值 |
|---|---|
| 前九个月收入（截至 2026-09-30） | **$33,242M**（上年同期 9M **$2,545M**） |
| Q3 单季 Claude 收入 | **$17.0B**（招股书表述：grew to $17.0B for the three months ended 2026-09-30） |
| 净亏损（9M） | **$(104,039)M**，其中 **$(94,324)M** 为可转换证券/衍生品/SAFE 公允价值变动 |
| 算力与基建采购承诺 + 租赁 | **约 $895.4B**（约 **$447.5B** 预计 2030-12-31 前发生；约 **$69.8B** 在 2026-09-30 后 12 个月内到期） |
| 现金及短期投资 | **$131,845M**（2026-09-30） |
| 累计募资 | **$141.1B** |
| 代码 / 治理 | 拟纳斯达克 **ANT**；PBC + LTBT / Class F |

**本报计算（非披露值，引用须标注）**：H1 = 33,242 − 17,000 = **$16,242M**，即 **Q3 单季略高于上半年全部**（前提：Claude 收入为该期总收入的主要构成——分部对账表未取得，见 §9.2）；承诺/9M 收入 ≈ **26.9×**，按年化 ≈ **20.2×**；剔除公允价值项后余额 ≈ **$(9,715)M**（仍含其他非经营项，**不等同经营亏损**）；现金对 12 个月内到期 $69.8B 覆盖 ≈ **1.9×**。

**② 机制**

1. **增长斜率与承诺规模同时到达极值**。Q3 一个季度做了上半年全部的量，说明企业采用在加速；但 $895.4B 的承诺是按多年签的，收入却只有一个季度的可见度。这个不对称是招股书的核心风险结构。
2. **亏损被非现金项主导**。$104.0B 净亏中 $94.3B 是公允价值变动——这是融资工具估值上升的会计结果，不是现金流出。真正的现金消耗要看去掉该项后的余额与经营现金流，而**经营现金流数字本期材料未取得**。
3. **流动性够近、不够远**。现金 $131.8B 对 12 个月内 $69.8B 到期是 1.9 倍覆盖，短期无虞；但 2030 年前 $447.5B 的到期墙需要 IPO 募资 + 经营现金流 + 新增融资三者接续。累计已募 $141.1B 说明这条路已反复走过。
4. **治理条款本身是定价变量**。PBC + LTBT / Class F 意味着公开市场买到的是「带使命约束的现金流」。对被动资金是配置对象，对主动资金是治理折价的讨论起点——这类结构在科技 IPO 里罕见，会成为同类实验室上市的模板或警示。
5. **与同周并购的对照是本期的核心张力**：Anthropic 把资本压在**算力**（可替换、可定价、有二手市场）上；OpenAI / Meta / Sierra 把资本压在**流程层**（不可替换、无二手市场、按时间积累）上。两种资本配置在同一周并行，市场会在未来 4–6 个季度给出裁决。

**③ 格局含义**

- 对 OpenAI / xAI：Anthropic 的公开披露会成为同类公司的估值锚与披露基准——「你有没有 $895B 级别的承诺」将变成投资人必问项。
- 对云厂商：承诺是它们的 backlog，也是 Anthropic 的负债；客户集中度双向透明化。
- 对本期主线：**这是唯一一份能算出「token 生意需要多大体量才能覆盖算力账单」的文件**，它为「为什么资本开始往流程层走」提供了量化理由。
- **不可写的话**：不得写「Anthropic 估值 X」「11 月上市」——S-1/A 未给发行价区间与日程，上期的估值/日程口径仍为 **D**。

**来源**：`sec.gov/Archives/edgar/data/2130357/000162828026068676/anthropicpbc-sx1ax1.htm`（WebFetch 直取成功）；`anthropic.com/news`（产品侧静默核验）。
**局限**：未逐页读完风险因素与脚注；「Claude 收入」与「总收入」的分部对账表未取得；经营现金流未取得。

---

### TOP2｜OpenAI：买下「源码审阅」，同时把网安做成产品线

- **评分**：格局 4.8 × 证据 **A** ≈ **4.8**
- **判断**：一周之内，OpenAI 同时做了两件互补的事——用并购补齐「agent 产出的代码如何被存储与审阅」，用 GPT-6 Cyber 证明「agent 能自己找出并修掉漏洞」。前者是流程，后者是能力；合起来是「安全 + 源码工作台」的完整叙事。

**① 发生了什么**

| 日期 | 事件 | 关键事实（A） |
|---|---|---|
| 11-04 | **收购 Pierre Computer Company** | Pierre 提供 Code Storage 与开源 Trees / Diffs / Highlights，已被 Codex 使用；目标是改造 Git/审阅工作流以适配 agent；**开源部分保持开源**；交割需监管批准，交割前两家独立；**对价未披露** |
| 11-05 | **GPT-6 Cyber** | 授权漏洞发现/验证/修复；ExploitGym **48.5%** vs GPT-5.6 Cyber **32.1%**（相对约 +51%）；Honeypot 保持在范围内 **99.93%**（无提示）/ **100%**（有提示）；Preparedness Framework 网络安全类判 **Critical**；初期仅限 Daybreak Red API/Codex |
| 11-04 | **A thousand fewer paths to root** | Linux 管线：**2,308** 候选 → **1,724** 动态复现 → **948** 个 LPE；API 成本约 **$1.213M**（≈ **$1,279/LPE**）；7 月同管线 166 个 LPE；经 Patch the Planet 披露 |
| 11-04 | Daybreak Red 进 AWS GovCloud (US-East) | GPT-5.6 Cyber 经 Bedrock 提供；需双重审批；推理不用于训练；数据无需回传 OpenAI |
| 11-04 | Images 2.6 | 约 **+50%** 生成速度；GIF；API Flare / Sunburst；约 **40 亿张/周** |

**② 机制**

1. **Pierre 是「产出物层」的卡口**。Git 是为人类的提交节奏设计的：一个人一天几次提交，agent 一小时几十次。当提交频率上升两个数量级，「diff 如何存储、如何被审、如何被回滚」就成了独立问题。Pierre 的 Trees/Diffs/Highlights 已在 Codex 内部使用——收购等于把这个数据结构的所有权收进来，而不是继续依赖外部依赖。
2. **开源部分保留是双向策略**：既维持 Codex 生态的采用面（开发者能继续用开放格式），也降低监管对「基础设施被独占」的顾虑。这是「开放数据结构、封闭工作台」的组合。
3. **网安被做成产品线，并用分发闸门管理风险**。判 Critical 意味着公司自己承认能力已到高风险区；应对不是延迟发布，而是**只给已审核的防御方**（Daybreak Red + GovCloud 双重审批）。99.93%/100% 的「不离范围」指标是给监管与客户的可控性证据。
4. **成本口径被公开，单位经济可算**。$1,279/LPE 与 $1.213M 总成本把「AI 找漏洞」变成可报价的服务。对比 7 月 166 个 LPE，同一管线在同一 OS 上产出提高约 **5.7 倍**（本报据 948/166 计算）——这是能力曲线，也是给企业安全预算的锚。
5. **两条线的耦合**：agent 找出的漏洞最终要以 patch 形式进入代码库，而 patch 的审阅正是 Pierre 的领域。**能力（Cyber）产生工作量，流程（Pierre）承接工作量**——这是本期最完整的「能力 + 卡口」配对。

**③ 格局含义**

- **对 Anthropic**：GPT-6 Cyber 的 ExploitGym 48.5% 仍低于 Google Gemini 4 Carbon 的 **54.8%**（10-28，窗外）。OpenAI 公布的是自家代际跃升，**不是行业 SOTA**——这一句必须写进正文，否则会误导读者。
- **对安全厂商**：$1,279/LPE 是「外包渗透测试」的替代价格；但该数字仅为 API 成本，不含人工验证与修复，不能当总成本。
- **对工作台竞争**：Pierre 与 Meta×Conductor、Sierra×Anon 形成三层分工；OpenAI 选的是「可审计性」，这与其企业/政府客户结构一致（GovCloud 同日落地）。
- **对并购市场**：一周内三笔中的第一笔，为「Agent 基础设施标的」定价提供锚——但条款未披露，锚是定性的。

**来源**：`openai.com/index/openai-to-acquire-pierre/`；`openai.com/index/introducing-gpt-6-cyber/`；`openai.com/index/a-thousand-fewer-paths-to-root/`；`openai.com/index/daybreak-red-aws-govcloud/`；`openai.com/index/introducing-images-2-6/`。
**局限**：Pierre 对价与交割时点未披露；ExploitGym/Honeypot/Images 速度均为**厂商自测**，正文标「OpenAI 称」。

---

### TOP3｜Meta：买下「多 Agent 编排」，顺带把 Muse 推到语音

- **评分**：格局 4.3（并购层结构性成立，但条款未披露、买方侧无对应稿）× 证据 **A** ≈ **4.3**
- **判断**：三笔并购里金额最不透明的一笔，但结构性意义明确——**「并行跑多个 coding agent」从独立 SaaS 变成平台内部能力**。Conductor 的云服务关停时间表，是这条路径的代价清单。

**① 发生了什么**

| 日期 | 事件 | 关键事实 |
|---|---|---|
| 11-04 | **Conductor 加入 Meta** | Conductor 的产品形态：在**隔离工作区**中并行运行多个 AI 编码 agent。**云服务**：11-04 起停止新注册；**11-13** 云变只读；**11-20** 云数据删除；本地应用更新支持至 **2027 年初**。交易条款**未披露**（Axios/TechCrunch 口径） |
| 11-05 | **Muse 语音与表达型形象** | Muse app（移动/网页/Mac）上线 Muse Realtime Voice + Realtime Avatar；**数百种**声线风格；**美国先行**；AI Glasses / Muse Charm「即将推出」 |
| 11-04 | GSLM2 论文 | 多流语音表征 / 生成式口语语言模型（研究题录，非产品） |

**② 机制**

1. **买的是并发原语，不是客户**。三条时间戳（停注册 → 只读 → 删数据）在公告日就已排定，只保留本地版更新到 2027 年初——这是 acquihire 形态：要团队与工程经验，不要 SaaS 业务。对 Conductor 现有客户，迁移窗口只有 **16 天**（11-04 → 11-20）。
2. **为什么买而不做**：隔离工作区 + 多 agent 并行，难点不在调度算法，而在**状态隔离与合并冲突**的工程细节，需要长期在真实仓库上迭代。这类「时间密集型」资产无法用算力换，只能买。
3. **与 OpenAI×Pierre 的分工**：Meta 优化**吞吐**（同时跑 N 个），OpenAI 优化**可审计**（每个 diff 可被审）。两者互补，不重叠——说明工作台是多层的，不同公司按自己的客户结构选层。
4. **Muse 语音是交互模态扩张，不是模型能力**。数百种声线 + 实时 avatar + 先美国 + 硬件（眼镜/Charm）排队，路径是「文本 → 语音 → 形象 → 眼镜」。它对企业市场无直接影响，但为硬件预置了语音栈。
5. **研究（GSLM2）与产品（Muse Voice）同日不同层**：底层表征与消费封装并行推进，但窗内没有把研究转为权重的动作（已核验静默）。

**③ 格局含义**

- **对独立多 agent 编排工具**：Conductor 的结局是**估值天花板参照**——独立编排 SaaS 的退出路径可能只剩并购，且是被关停云业务的那种。
- **对 OpenAI**：两家相隔一天各买一层，构成主线三角的第一、二条边；真正的竞争不在模型，而在「谁的工作台先成为企业默认」。
- **对 Meta 自身**：用未披露金额的小额并购补工程能力，与上期 ~$95B 股权融资形成鲜明对比——**大钱给算力，小钱给流程**，这是同一家公司的两本账。
- **证据强度提示**：Conductor 公告由**标的方**发布，Meta 侧未见对应新闻稿。正文写「Conductor 宣布加入 Meta」，不写「Meta 宣布收购」。

**来源**：`conductor.build/announcement`；`about.fb.com/news/2026/11/introducing-muse-ai-voice-expressive-avatars/`；`ai.meta.com`（GSLM2 题录）。
**局限**：对价、团队归属、Meta 侧确认均**机制未取得**；Conductor 的原客户规模未披露。

---

### TOP4｜AMD Q3：DC +97%，Helios 五客户，Q4 指引 ~$17B

- **评分**：格局 4.2 × 证据 **A** ≈ **4.2**
- **判断**：本周唯一带完整财务口径的一手，也是「第二供应商」从叙事变成订单的一刻。五客户名单里有三家恰好是本周的主角——这让「算力可替换、工作台不可替换」从推断变成可核对的对照。

**① 发生了什么（A，AMD newsroom，2026-11-03）**

| 项 | 数值 |
|---|---|
| 营收 | **$13.377B**（同比 **+45%**，环比 **+16%**，创纪录） |
| 数据中心 | **$8.546B**（同比 **+97%**）；财报点名 **Instinct MI450 系列** |
| EPS | GAAP **$1.46** / 非 GAAP **$2.09** |
| Q4 指引 | 约 **$17B** ±3%（同比约 **+66%**） |
| Helios 机柜级 | 运行于 **Anthropic、Meta、Microsoft、OpenAI、OCI** |
| 软件 | **ROCm 10**；**Helion** 参考架构 |
| 并购 | 已签署协议收购 **World Labs** 与 **Taalas**（业务描述未给） |

**本报计算（标注）**：DC 占营收 ≈ **63.9%**（8.546 ÷ 13.377）；Q4 指引隐含环比 ≈ **+27.1%**（17 ÷ 13.377）。

**② 机制**

1. **收入结构已完成切换**。DC 占 63.9%、增速是整体的两倍多——AMD 的估值框架从「PC + 服务器 CPU」变成「AI 加速器 + 服务器 CPU」。这是本周所有算力叙事里最硬的一条事实。
2. **Q4 指引隐含「供给已锁」**。环比 +27% 的指引，在 HBM 紧供给背景下等于宣称产能已落实。这是最值得交叉验证的数字：要么被 2027 HBM 产能证实，要么成为下修起点。
3. **五客户名单是本期的结构性证据**。Anthropic、Meta、Microsoft、OpenAI、OCI——其中 **OpenAI 与 Meta 是本周两笔工作台并购的买方**，**Anthropic 是本周 S-1/A 的披露方**。同一周里，这三家既在买流程层，又在用第二供应商的整机柜。机制含义：**算力可替换，工作台不可替换**。如果连前沿实验室都在多源采购整机柜，「算力锁定」叙事进一步弱化，「工作台/数据/身份锁定」相对升值。
4. **Google 不在名单里**，与其 TPU 自用 + 外售给 Oracle 的路线一致——加速器自研者不买对手的机柜，这是结构性而非偶然。
5. **ROCm 10 + Helion 参考架构**是软件护城河：硬件可替换，迁移成本才是留存。Helion 是给 OEM/云厂商的「照抄模板」，缩短上架时间。
6. **硅厂开始买「跑在硅上的东西」**。World Labs 与 Taalas 的收购协议是纵向整合信号——从卖硅到买模型/编译资产。业务细节**机制未取得**，但协议签署本身是 A 级事实。

**③ 格局含义**

- **对 NVIDIA**：DC +97% + $17B 指引证明第二供应商已是主力采购项；NVIDIA 同日（11-05）发 Vera 每瓦 agent 数，是在 CPU 侧守住配比话语权。
- **对云厂商**：OCI 同时是 Helios 客户与 Google TPU 承租方（上期），多架构「按 workload 分配」已成常态。
- **对 Anthropic**：$895.4B 承诺中 Helios 是可替换项——供应商多元化是它的议价工具，对 AMD 是订单确定性。
- **对本期主线**：这是反证——如果算力紧张到无法替代，本周的资本动作就不会集中在流程层。

**来源**：`newsroom.amd.com/news/amd-reports-third-quarter-2026-earnings/`。
**局限**：五客户各自部署规模未披露（只能写「正在运行」，不能写装机量）；World Labs / Taalas 的业务与对价未取得；MI450 出货量未披露。

---

### TOP5｜Sierra：买下「浏览器登录」，让 agent 真的把事办完

- **评分**：格局 3.9 × 证据 **A** ≈ **3.9**
- **判断**：三笔并购里最小、也最容易被低估的一笔。它补的不是能力，是**行动半径**——agent 能不能登录、能不能填表、能不能在没有 API 的网站上完成交易。这一层不解决，前面所有的智能都停在「建议」。

**① 发生了什么（A，Sierra 官方博客，2026-11-05）**

| 项 | 内容 |
|---|---|
| 事件 | Sierra 收购 **Anon** |
| Anon 是什么 | 为 agent 提供浏览器登录与身份基础设施（被称为「AI agent 的 Plaid」）：让 agent **登录、填表、在无 API 的网站上执行动作** |
| Anon 规模 | 累计融资 **>$13M**；**数百家**客户 |
| 战略意图 | 支撑更长时间的 **Horizon** 目标——agent 不止于建议，而要完成 |
| 交易条款 | **未披露**（金额、对价形式、监管步骤） |

**② 机制**

1. **最后一公里是身份，不是智能**。企业 agent 的价值断点长期在这里：能想出该做什么，但登录不了供应商门户、过不了二次验证、填不了没有 API 的老系统表单。Anon 解决的正是身份与会话维持。
2. **这是三层里最「时间密集」的资产**。登录不是通用算法，而是逐站点积累的适配（表单结构、验证流程、会话保持、失败回退）。无法用算力买，只能用时间堆——所以买公司比自建快。
3. **与 Poppy 互补**。Sierra 此前推 Poppy 草案（10-09，窗外）解决「agent 之间如何被授权与代表」；Anon 解决「agent 如何证明自己是谁」。一条是协议，一条是实现。协议定规则，Anon 给执行力。
4. **计价基础可能换轨**。一旦 agent 能自主登录并完成交易，客服从成本中心变成渠道；Sierra 的计价基础可能从「解决的会话数」转向「完成的交易数」。**但公司未披露结果型定价**，这是推断（B）。
5. **三种并购动机并列**：OpenAI 买「产出物可审阅」（质量与合规）、Meta 买「并发度」（吞吐）、Sierra 买「身份与行动」（闭环）。三家买的不是同一件东西——**工作台不是一层，是三层各自独立成市**。

**③ 格局含义**

- **对本期主线**：三角补齐——**存储/审阅（Pierre）→ 调度（Conductor）→ 身份/执行（Anon）**，三家在同一周拼出一个完整的 agent 工作台栈，且互不重叠。
- **对身份/安全厂商（Okta、Auth0 类）**：agent 成为新的认证主体类别，传统 IAM 的「人 / 服务账号」二分不够用。Microsoft 同周把「agent 自带凭证」列进 Copilot Studio，是同一问题的另一种解法。
- **对合规**：agent 代客户登录第三方系统涉及授权链与责任归属；Anon 的「数百客户」说明这套做法已有事实标准，但**监管口径未取得**。
- **对估值参照**：Sierra 在 10-30 刚披露 $400M+ ARR（**空档日，窗外**），一周后出手并购——收入体量支撑的并购能力，与 Conductor（被买、云关停）形成两端样本。

**来源**：`sierra.ai/blog/sierra-acquires-anon`。
**局限**：对价、团队归属、既有客户合同迁移、是否保留独立产品均**机制未取得**；「Plaid for AI agents」是比喻，不作能力证明。

---

## 3. 主线专题深挖｜Agent 工作台并购周

### 3.1 问题定义

过去两年的竞争问题是「谁的模型更强」，过去半年的问题是「谁的算力更多」，本周出现的是第三个问题：**当模型能力便宜到可以随便买、算力可以多源采购之后，agent 到底卡在哪？**

三家公司在 24 小时内给出了三个不同答案，且都不是模型：

- OpenAI 说卡在**产出物**：agent 写出的代码要能被存储、版本化、审阅、回滚。它买了 Pierre。
- Meta 说卡在**并发**：一个工程师要同时驱动多个 agent，工作区不能互相污染。它买了 Conductor。
- Sierra 说卡在**身份**：agent 要登录、要填表、要在没有 API 的网站上完成动作。它买了 Anon。

三个答案互不重叠，说明这不是跟风，而是**同一个瓶颈的三个面被同时发现**。本期的核心判断因此是：

> **Agent 的竞争前沿，已经从「生成」移到「生成之后」——存哪、谁审、怎么登录、几个一起跑。**

### 3.2 机制一：三层卡口为什么「买」比「做」快

| 层 | 标的 | 买方 | 买的是什么 | 为什么买而不做 | 证据 |
|---|---|---|---|---|---|
| 产出物（存储/审阅） | **Pierre** | OpenAI | Code Storage + 开源 Trees / Diffs / Highlights，已在 Codex 内使用 | 已是自家产品的底层依赖，重写等于替换正在跑的依赖；数据结构的所有权比实现更重要 | A |
| 调度（多 agent 编排） | **Conductor** | Meta | 隔离工作区并行多 agent 的工程经验 | 难点在状态隔离与合并冲突的真实仓库迭代，无法用算力换时间 | A（卖方公告） |
| 身份（登录/执行边界） | **Anon** | Sierra | 逐站点的登录适配 + 数百客户验证过的会话维持 | 登录是长尾适配资产，只能靠时间堆；自建至少落后 1–2 年 | A |

**共同点**：三笔标的都是**时间密集型**而非**算力密集型**资产。买它们的原因不是「没钱做」，而是「没时间做」——而这恰好是模型降价之后唯一没有降价的资源。

**另一共同点：三笔都不承诺产品延续。** Conductor 的云服务直接排定了关停时间表（11-04 / 11-13 / 11-20）；Pierre 只承诺「开源部分保持开源」，其余未说；Anon 的产品去留未披露。这是能力内化的典型形态，也提醒客户：**工作台层的供应商风险高于模型层**——模型停用可以换 API，工作台停用要迁移数据与流程。

### 3.3 机制二：为什么是这一周——三个前置条件同时成立

1. **模型价格已经低到不构成差异化**。窗内证据：Google Omni 1.2 Flash 降价 **30%** 至 **$0.07/秒**；腾讯 Hy4 能力增加（视觉理解 + Computer Use）但定价**不变**（6/18 元每百万 tokens）；上期 OpenAI Terra 已腰斩。当单位智能价格持续下行，「用哪个模型」的决策价值下降，「工作流怎么搭」的决策价值上升。
2. **agent 并发数正在成为新的容量单位**。NVIDIA 同日（11-05）把指标改成「每瓦 agent 数」（1.6× vs 最快 x86）与「agent 速度」（2× vs 最高效 x86），并用 Daytona「1,000 个沙箱 10.8 秒 vs 88.4 秒」举例。并发数一上升，调度与隔离就从「nice to have」变成瓶颈。
3. **资本周期偏好轻资产并购**。上期是 AI 资本的大周（Meta ~$95B 股权、Anthropic S-1、Broadcom $63B SPV、三云财报）；本周三笔并购的标的都是几十人规模、条款多数未披露的小额交易。在巨额算力承诺压顶的周期里，**小额、快速、能立刻改进产品的工作台并购，是资本效率最高的动作**。

### 3.4 机制三：四种替代解——不是所有公司都选择买

同一周、同样的三层需求，四类公司给出了四种解法。这是本期最干净的一组横向对照：

| 解法 | 代表 | 做法 | 优势 | 代价 | 证据 |
|---|---|---|---|---|---|
| **买公司** | OpenAI / Meta / Sierra | 收购 Pierre / Conductor / Anon | 立刻获得时间密集型资产 | 整合风险；标的业务关停；条款不透明 | A |
| **发原语** | Microsoft / AWS | Copilot Studio 持久化 agent（自带凭证 + 业务记忆 + 触发器）、Browser Automation **GA**、MCP/A2A 双支持；AgentCore **Web Answer GA**（一次 MCP 调用、带引用、$10/1,000 次、零外流） | 分发已在企业云合同里，不需要买客户 | 原语是通用的，难覆盖客户的特殊流程 | A |
| **做货架** | Glean / Cohere / 字节（据媒体） | Auto 路由（Economy/Balanced/Frontier）+ 75%/90% 成本闸；Model Vault 上架 DeepSeek/Gemma/GLM 等（默认零留存）；豆包工作接 Kimi/GLM/DeepSeek | 把模型选择变成成本旋钮，客户不锁定 | 品牌在终端消失；分成让给平台 | A / B |
| **底座化** | Databricks / Broadcom / Oracle | Claude 原生 OTel → MLflow → Unity Catalog；Tanzu 数据产品 + 嵌入式 MCP；FDI agent 目录（ZIP 交付） | 不下场竞争工作台，收工作台的数据与治理 | 价值实现慢，依赖上层生态繁荣 | A |

**这张表的读法**：四种解法的分界线是**分发结构**。已经有企业合同的（Microsoft/AWS/Oracle）发原语；有开发者入口的（Glean/Cohere/字节）做货架；有数据底座的（Databricks/Broadcom）做底座；**只有在产品形态上需要立刻改变、且没有现成分发的（OpenAI/Meta/Sierra），才选择买公司**。

这条规律也解释了为什么中国侧本周没有并购（见 §5.2）：入口集中在少数超级 App 与云平台手里，自建入口的边际价值低于买流程层，所以打法是「货架 + 折扣」，不是「买公司」。**此为推断，证据级 B。**

### 3.5 资本侧对照：Anthropic 的算术

把 S-1/A 的四个数放在一起，就能看出资本为什么往流程层走：

| 指标 | 数值 | 读法 |
|---|---|---|
| 9M 收入 | **$33,242M** | Q3 单季 $17.0B > H1 合计 $16.2B（本报计算）——采用在加速 |
| 算力与基建承诺 | **约 $895.4B** | 相当于 9M 收入的 **26.9 倍**、年化收入的 **20.2 倍**（本报计算） |
| 现金及短期投资 | **$131,845M** | 对 12 个月内到期 $69.8B 覆盖 **1.9 倍**（本报计算）——近端安全，远端靠融资 |
| 净亏损 | **$(104,039)M** | 其中 $(94,324)M 为公允价值变动，非现金；余额约 $(9,715)M 仍含其他非经营项（本报计算，**不等同经营亏损**） |

**读法**：Anthropic 的模式是「用承诺锁供给、用收入证明需求、用 IPO 补缺口」。这条路的每一环都需要资本市场配合。而同期 OpenAI / Meta / Sierra 买的资产**不需要多年承诺、没有 HBM 依赖、不受电价影响**——两相对照，流程层的资本效率在本周显得更高。这不意味着 Anthropic 的策略有问题（算力承诺同时是竞争壁垒），但**它解释了为什么本周的并购集中在轻资产侧**。

### 3.6 供给侧对照：AMD 的五客户名单

AMD 财报给出的 Helios 客户是：**Anthropic、Meta、Microsoft、OpenAI、OCI**。

把这五个名字与本周的事件对齐：

| 客户 | 本周在做什么 | 与 Helios 的关系 |
|---|---|---|
| OpenAI | 买 Pierre；发 GPT-6 Cyber | 既买工作台，也用第二供应商机柜 |
| Meta | 买 Conductor；发 Muse 语音 | 既买工作台，也用第二供应商机柜 |
| Anthropic | 发 S-1/A（$895.4B 算力承诺） | 承诺的一方，同时是多源采购的一方 |
| Microsoft | 发持久化 agent + Browser Automation GA | 卖原语的一方，也是 Helios 客户 |
| OCI | 发 FDI agent 目录 | 既是 Helios 客户，也是 Google TPU 承租方（上期） |

**机制结论**：同一批公司在**算力侧多源、在流程侧自建或并购**。这说明两层的替代性完全不同——算力有第二供应商、有二手市场、有标准化机柜；工作台没有。**资本往不可替代的地方走**，这是本周所有事件的共同解释。

### 3.7 竞争含义（对战略与投资观察者）

1. **工作台三层各自成市，投资标的要按层看**。产出物层（存储/审阅/版本）看数据结构的所有权；调度层（并发/隔离）看真实仓库的迭代量；身份层（登录/会话/授权）看站点覆盖与合规口径。三层的关键指标完全不同，不能用「Agent 平台」一个标签打包估值。
2. **「买」的窗口可能很短**。Conductor 的结局（云业务 16 天内关停）说明平台买方只要团队与经验，不要业务。对同类创业公司，这意味着**被收购不等于产品延续**，估值谈判应把「客户迁移成本」计入对价。
3. **云厂商的原语化是最强竞争**。Browser Automation GA + 持久化 agent + 一次 MCP 调用返回带引用答案——这些能力对客户是「加个配置」，对创业公司是「整个产品」。2027 年工作台创业公司的对手不是同行，是云的控制台。
4. **身份是新的锁**。Sierra 买 Anon、Cursor 用自家 SSO 做应用登录、Microsoft 让 agent 自带凭证——三家在同一周把身份放进产品核心。谁掌握 agent 的身份，谁就掌握切换成本。
5. **成本治理会成为采购门槛**。Glean 的 75%/90% 阈值、Microsoft 的 Copilot Credit 管理同周出现，说明企业已在月中撞额度。不能给出成本上限的工作台，会在采购评审里失分。
6. **Anthropic 的账本会改变披露基线**。$895.4B 这个量级一旦进入公开招股书，同类公司在下一轮融资时会被要求给出同等颗粒度的承诺披露。这会提高整个行业的透明度，也会提高融资门槛。

### 3.8 主线证据锚点（便于审计）

| 锚点 | 日期 | 关键值 |
|---|---|---|
| Anthropic S-1/A 修正案 No.1 | 2026-11-02 | 9M $33,242M；Q3 $17.0B；承诺 ~$895.4B；现金 $131,845M；ANT |
| OpenAI 收购 Pierre 公告 | 2026-11-04 | Code Storage + Trees/Diffs/Highlights；OSS 保留；交割待监管 |
| Conductor 加入 Meta 公告 | 2026-11-04 | 11-04 停注册 / 11-13 只读 / 11-20 删数据 / 本地版至 2027 初 |
| Sierra 收购 Anon | 2026-11-05 | 浏览器登录/表单；>$13M 累计融资；数百客户；条款未披露 |
| AMD FY2026 Q3 财报 | 2026-11-03 | $13.377B；DC $8.546B +97%；Q4 ~$17B；Helios 五客户 |
| OpenAI GPT-6 Cyber | 2026-11-05 | ExploitGym 48.5% vs 32.1%；Honeypot 99.93%/100%；Critical |
| OpenAI Linux 管线 | 2026-11-04 | 2,308 → 1,724 → 948 LPE；$1.213M；$1,279/LPE |
| Microsoft Copilot Studio 更新 | 2026-11-04 | 持久化 agent（凭证 + 记忆 + 触发器） |
| Microsoft Foundry 10 月汇总 | 2026-11-05 | Browser Automation GA；harness 预览（10-28 一手） |
| AWS Web Answer GA | 2026-11-05 | 一次 MCP 调用；带引用；$10/1,000 次；零外流 |
| 腾讯 Hy4 | 2026-11-04 | 视觉理解 + Computer Use（CLI+GUI）；6/18 元不变；权重将开源 |
| NVIDIA Vera 性能博客 | 2026-11-05 | 1.6× agents/watt；2× agent 速度；Daytona 10.8s vs 88.4s |

---

## 4. 企业竞争雷达｜上期三条主线的本周增量

上期三条主线是：**分发/云承诺/治理**、**Agent 系统级执行与授权**、**AI 资本（债务/现金流定价）**。本周三条均有增量，但重心从第三条（资本）转向前两条的产品化落地——资本议题由 Anthropic 一份文件承担，其余让位给并购与平台动作。

### 4.1 分发 / 云承诺 / 治理

| 增量 | 要点 | 证据 |
|---|---|---|
| **Oracle FDI Fusion Agents Repository** | agent 以 ZIP 构件（含 PDF 安装说明）在 Fusion Data Intelligence 内分发，按已购功能领域过滤 | A |
| **Databricks 接 Claude 原生 OTel** | Anthropic SDK / Messages API / Managed Agents 经 Zerobus 导出 OTel 到 MLflow → Unity Catalog | A |
| **Glean × Fireworks** | 开源模型经 Fireworks 进入 Glean Assistant/Agents，带权限继承与管理員治理；与 Auto 路由互补 | A |
| **Cohere Model Vault** | 上架 DeepSeek V4.1 Flash、Gemma 4、GPT-OSS、Phi、Nemotron、GLM、MiMo、Hy3 等；**默认零数据留存**；US/EU/Canada | A |
| **Mistral Studio** | 托管 agent / workflow / 企业应用 / OTel / evals；Large 4 可用于 cloud / VPC / on-prem；客户含 ABANCA、BNP Paribas、CMA CGM、Accenture、Capgemini、TCS、Alten | A |
| **腾讯 Hy4 四端分发** | TokenHub / WorkBuddy / CodeBuddy / 元宝同时上线；11/4–11/15 免费额度；TokenHub 五折至 2026-12-31 | A |
| **字节豆包工作三方模型** | 接入 Kimi K3.1 Pro / GLM 5.3 / DeepSeek V4.1 Flash | **B（据媒体）** |
| **Cursor Build Live Apps** | coding agent 产出直接部署为内部应用（含 Postgres、SSO、托管、独立域名） | A |

### 4.2 Agent 系统级执行与授权

| 增量 | 要点 | 证据 |
|---|---|---|
| **Sierra × Anon** | agent 获得登录/表单/无 API 网站的执行能力 | A |
| **Meta × Conductor** | 多 agent 并行与隔离成为平台能力 | A（卖方公告） |
| **Microsoft 持久化 agent** | **自带凭证 + 业务记忆 + 触发器**（Frontier 私有预览）；Browser Automation **GA** | A |
| **Perplexity Teammates** | 常驻 agent 承接进行中项目；**agent 间交接**；独立环境 + 加密凭证 | A |
| **Harvey × Jus Mundi** | 垂直专用 agent 以 A2A 形式嵌入水平平台；联合客户年底前不加价 | A |
| **Cursor 双重安全检查** | 发布前确定性检查 + agentic 检查；管理员可见/可下线 | A |
| **腾讯 Hy4 Computer Use** | CLI + GUI 双通道，且计划开源权重 | A |
| **Cognition Devin 1,000 仓** | 多仓扫描上限翻倍；Findings 对话化 | A |
| **xAI Data Bot** | 常驻 Slack 的职能型 team bot，共享技能与记忆 | A（产能自述 B） |
| **Glean artifact 版本触发器** | 用内容变更事件驱动 agent，不需独立调度层 | A |

### 4.3 资本 / 债务 / 现金流

见 §3.5（Anthropic）与 TOP4（AMD）。补充两点：

- **资本事件的密度显著下降**：上期是「三云财报 + Meta $95B 股权 + Anthropic S-1 + Broadcom $63B SPV」的密集周；本周只有 Anthropic S-1/A 与 AMD 财报两份，其余是并购（金额多未披露）。**叙事从「谁出钱」转向「钱买了什么」**。
- **AMD 的两项收购协议**（World Labs、Taalas）是本周唯一新增的硅厂并购线索，业务细节未取得，只作信号。

### 4.4 上期 TOP5 的本周追踪

| 上期 TOP | 本周增量 | 证据 |
|---|---|---|
| TOP1 Alphabet Q3（Cloud +103%/FCF 转负） | 无财报；产品侧 Omni 1.2 Flash 降价 30%、Antigravity 化学技能、PlanAssist 扩至 15 地 | A |
| TOP2 Meta ~$95B 股权 + 角石 | 无增量；转为小额并购（Conductor）+ 消费产品（Muse 语音） | — |
| TOP3 Anthropic Form S-1 | **升级为 S-1/A 完整口径**（本期 TOP1） | A |
| TOP4 Oracle×Google TPU + Broadcom $63B SPV | 无增量；Broadcom 转软件组合、Oracle 转 agent 目录。**信用结构议题暂停 ≠ 解决** | — |
| TOP5 OpenAI GPT-6.1 Terra | 升级为 GPT-6 Cyber（垂类专用）+ 收购 Pierre | A |

---

## 5. 分组对象条目

> 有料对象写机制级摘要；弱动态与静默写核验说明。完整事实链、URL 与失败重试见 `shards/`。数字均来自分片或原始材料，未在此新增。

### 5.1 A 组｜全球巨头与平台（8/8 有料）

#### OpenAI｜有动态（强）
- **GPT-6 Cyber（11-05）**：授权漏洞发现/验证/修复；ExploitGym **48.5%** vs GPT-5.6 Cyber **32.1%**；Honeypot 保持在范围内 **99.93%/100%**；Preparedness **Critical**；初期仅 Daybreak Red API/Codex〔A，厂商自测基准〕。
- **Linux 管线（11-04）**：**2,308** 候选 → **1,724** 复现 → **948** 个 LPE；API 成本 **$1.213M**（**$1,279/LPE**）；7 月同管线 166 个〔A〕。
- **收购 Pierre（11-04）**：Code Storage + 开源 Trees/Diffs/Highlights（已在 Codex 用）；OSS 保持开源；交割待监管；对价未披露〔A〕。
- **Daybreak Red 进 AWS GovCloud US-East（11-04）**：GPT-5.6 Cyber on Bedrock；双重审批；推理不入训练；数据可不回传〔A〕。
- **Images 2.6（11-04）**：约 +50% 速度；GIF；API Flare/Sunburst；约 40 亿张/周〔A，厂商自测〕。
- **Dots 企业/教育/医疗 GA（11-04）**：管理员预览至 2026-11-18 后默认开启；数据驻留/EKM/HIPAA〔A〕。
- 分片：`shards/A/A-part-01.md`

#### Google DeepMind / Gemini / Alphabet｜有动态
- **Gemini Omni 1.2 Flash GA（11-05）**：原生视频 **15 秒**（原 10 秒）；多轮对话式编辑；较 Omni 1.1 **−30%** → **$0.07/秒（720p）**；草稿上采样至 1080p/4K；SynthID〔A〕。
- **Antigravity 化学信息学技能（11-03）**：RDKit/ChEMBL/PubChem；多日工作流压缩到约 **1 小时**；**10,000 名**科学家最高档免费 6 个月〔A〕。
- **PlanAssist 英国（10-31）**：住宅类评估时间最多 **−58%**；**>70%** 草稿零修改获批；扩至 **15** 个地方当局；2027 全国目标〔A〕。
- **竞争**：视频线打「时长 + 单价」，与 OpenAI Images 2.6 的「速度 + GIF」形成两条不同的价格战。
- 窗外背景：Gemini 4 Carbon（10-28，ExploitGym **54.8%**，高于 GPT-6 Cyber）。
- 分片：`shards/A/A-part-01.md`

#### Anthropic｜有动态（资本侧；产品静默）
- **S-1/A（11-02）**：见 TOP1。所有金额为招股书原文。
- **产品侧**：新闻索引 10-31→11-05 **无新产品稿**（已核验静默）——可解释的静默，带宽在 IPO 文件上。
- 分片：`shards/A/A-part-01.md`

#### Meta AI｜有动态
- **Conductor 加入（11-04）**：见 TOP3。云 11-04 停注册 / 11-13 只读 / 11-20 删数据 / 本地版至 2027 初；条款未披露〔A，卖方公告〕。
- **Muse 语音（11-05）**：Realtime Voice + Realtime Avatar；数百种声线；美国先行；AI Glasses / Muse Charm 即将推出〔A〕。
- **GSLM2 论文（11-04）**：多流语音表征/生成式口语 LM（题录，非产品）〔A〕。
- 分片：`shards/A/A-part-01.md`

#### Microsoft AI / Copilot / Azure｜有动态
- **Copilot Studio（11-04）**：持久化/主动式 agent（**自带凭证 + 业务流程记忆 + 触发器**，Frontier 私有预览）；客户对话 harness 预览；Work IQ GA；A2A；MCP server；Copilot Credit 成本管理预览〔A〕。
- **Foundry 10 月汇总（11-05）**：**Browser Automation GA**；长时运行托管 agent 韧性 GA；Decisions API GA；MAI Image 2.6 预览（6 区域）；Model Router +8 模型；Ignite 11-17→20〔A；多数功能日期在 10 月，本周为汇总披露〕。
- **竞争姿态**：不并购，发原语——分发已在企业云合同里。
- 分片：`shards/A/A-part-01.md`

#### Amazon / AWS｜有动态
- **Web Answer on AgentCore GA（11-05）**：**一次 MCP 工具调用**返回经综合、有依据、带引用的答案；域名包含/排除 + 发布日期过滤；IAM；**零数据外流**；us-east-1；**$10 / 1,000 次调用**〔A〕。
- 11-02 周报中的 Terra on Bedrock（10-26）、Step Functions as tools（10-29）均窗外，仅背景〔BORDER〕。
- 分片：`shards/A/A-part-01.md`

#### xAI｜有动态
- **Data Bot（11-02）**：Team Bot 查询数仓、跑分析、出图表/看板（Databricks/Hex）、实验读数；常驻 Slack；技能与记忆由 DS 团队维护；xAI 称一周约 **70 小时** DS 工作量〔A；产能自述 B〕。
- 无新基础模型（已核验相对静默）。
- 分片：`shards/A/A-part-01.md`

#### NVIDIA｜有动态（性能叙事；无财报）
- **Vera（11-05）**：100MW 对比中 **1.6× agents/watt**（vs 最快 x86）、**2× agent 速度**（vs 最高效 x86）；伙伴：Perplexity 1.5×、DeepInfra 最高 2.2×、Daytona 1,000 沙箱 **10.8s vs 88.4s**、Modal 最高 2× /核〔A；全部为厂商与伙伴自测〕。
- 11-02/03/05 三条垂直 feature（城市、晶圆厂、内存协同设计）为 PR 级〔A〕。
- **财报（FY2027 Q3）定于 2026-11-17**，未在窗内发布〔A〕。
- 分片：`shards/A/A-part-01.md`

### 5.2 B 组｜中国头部（3 有料 / 2 弱 / 4 静默）

#### 腾讯 / 混元｜有动态（强）
- **Hy4（11-04）**：相较 preview 扩展预训练/后训练；**首次视觉理解**；提升指令遵循、长文、长程智能体；**首次支持 Computer Use（CLI + GUI）**；「金融众测开源第一」**3.04** vs Kimi K3.1 Pro **2.68** / GLM-5.3 **2.68** / DeepSeek-V4.1-Flash-1017 **2.97**；幻觉 **12.95% → 7.2%**；**定价不变 6/18 元每百万 tokens**；权重「将近期开源」（未给日期）；上线 TokenHub / WorkBuddy / CodeBuddy / 元宝；11/4–11/15 免费额度；TokenHub 五折至 2026-12-31〔A；基准与幻觉率 B，厂商口径〕。
- **机制**：能力加、价格不动 = 单位智能降价；开源 GUI 执行会放大对身份层（Anon 类）的需求，而非替代。
- 分片：`shards/B/B-part-01.md`

#### 字节 / 豆包 / 火山｜有动态
- **doubao-seed-evolving（202611 档）**：Agent 复杂任务规划/验收、工具调用与事实一致性改善；时延与单次成本下降；统一 Model ID 自动生效（客户不改接入）〔A，**无量化数字**〕。
- **豆包工作接三方模型（11-05）**：Kimi K3.1 Pro、GLM 5.3、DeepSeek V4.1 Flash〔**B，据媒体**，未获官方确认〕。
- 分片：`shards/B/B-part-01.md`

#### DeepSeek｜有动态（开源，仅战略层）
- **10-31**：MIT 许可开源 `dsh-superagent-prototype`（面向单一 GitHub 仓的主动编码 agent 研究原型，打包给 DeepSeek Harness，监听 GitHub / 可选飞书；**非官方产品**，首 commit 2026-10-31T12:05:39Z）〔A〕。**工程细节归 Agent 研究周报，本报只记一条战略意图：用开源维持开发者心智份额、把 harness 做成入口。**
- 分片：`shards/B/B-part-01.md`

#### 月之暗面 / Kimi｜弱
- 无自有窗内发布（已核验）。K3.1 Pro 被两处**他方**文本引用：腾讯 Hy4 对照（**2.68**）、火山方舟 202610 货架。
- 上期记录「完整权重计划 ≤11/4 开源」——本周材料**未见兑现公告**，记「**未核到**」，不作否定结论〔B〕。

#### 智谱｜弱
- 无官方窗内新旗舰稿。GLM-5.3 出现在腾讯对照（**2.68**）与豆包接入报道（**据媒体**）〔B〕。

#### 阿里 / 千问 / 百炼｜静默
- 未核到窗内官方一手；媒体「神秘新模型」无官方页（**D**，不采用）。

#### 百度 / 文心｜静默
- 未核到窗内官方一手。

#### 华为昇腾 / 盘古｜静默
- 未核到窗内官方一手（盘古无公司级大版本）。

#### MiniMax｜静默
- 未核到窗内官方一手。

> **B 组整体判断（B，推断）**：中国侧本周没有并购，只有货架与折扣。机制解释是分发结构——入口集中在少数超级 App 与云平台，自建入口的边际价值低于买流程层。这与美国侧「买公司改产品形态」形成镜像。

### 5.3 C 组｜应用与垂直头部（10 有料 / 2 静默）

#### Sierra｜有动态（强）
- **收购 Anon（11-05）**：见 TOP5。agent 浏览器登录/表单/无 API 操作；累计融资 **>$13M**；数百客户；条款未披露〔A〕。
- 窗外背景：10-30 $400M+ ARR（空档日）；Poppy 草案 10-09。
- 分片：`shards/C/C-part-01.md`

#### Perplexity｜有动态
- **Teammates（11-04）**：Computer 内常驻个人 agent，承接进行中项目（规划/协调、监控、跟进、Slack 交接、**agent 间交接**）；网页先行、iOS 即将；Max 优先；独立环境 + 加密凭证〔A〕。
- **Agent API effort 档改进（11-05）**：每档成本下降、质量持平或更好；新增 **ultra**（3 并行研究 agent + 第 4 个合并去重）；ultra **$21.71/任务**、WANDR **85.9%**——**页面抓取超时，数值待核，不进确定句**〔A 日期 / 数值待核〕。
- 分片：`shards/C/C-part-01.md`

#### Runway｜有动态（研究级）
- **Characters 实时服务（11-05）**：约 **57B** 自回归视频 DiT；**24 fps**、每 **166.7ms** 4 帧；上线 **8×H100** → 优化后 **4×H100** 实时（**159.3ms/步、24.5fps**；融合 kernel **147.4ms**）；缓存维护 **69.7 → 6.2ms/步**；7 周遥测 **99.5%** 会话 >23.5fps〔A，公司自述〕。
- 与 Google Omni 的路线分野：批量素材 vs 实时在场。
- 分片：`shards/C/C-part-01.md`

#### Harvey｜有动态
- **Jus Mundi A2A（11-04）**：Jus AI 接入 Assistant/Agents/Vault/Workflows；国际仲裁与跨境争议；带引用检索 + 案卷 Vault 对照；机构内容（ICC、AAA-ICDR、LCIA、SIAC 等）；联合客户**年底前不额外收费**〔A〕。
- **Lopezmarqués（11-04）**：西班牙律所全所部署，覆盖诉讼/仲裁、商事/公司、白领犯罪〔A〕。
- 窗外：Aida 并入（10-29，第 5 笔）；FedRAMP Class D（10-28）。
- 分片：`shards/C/C-part-01.md`

#### Glean｜有动态
- **Fireworks Frontier Ecosystem（11-03）**：开源模型经 Fireworks 服务进入 Assistant/Agents，带权限与管理员治理〔A〕。
- **Release 567（11-03）**：Otter.ai 连接器公测；15Five GA；artifact 版本触发器；GPT-6.1 Terra；**Auto 模式**（Economy/Balanced/Frontier，含 **75%/90%** 用量成本优化）；Deep Research 作为技能；上下文面板 GA 计划 **2026-11-24**〔A〕。
- 分片：`shards/C/C-part-01.md`

#### Databricks｜有动态
- **Spark 4.3 / Runtime 19（11-05）**：Stateful Real-Time Mode；三基准 P99 **136–141ms**；SCD Type 2 Auto CDC；Project Feather；季度节奏〔A〕。
- **Claude 原生 OTel → MLflow（11-03）**：公测；经 Zerobus → Unity Catalog；支持 issue 检测与 Agent Evaluation〔A〕。
- **Lakebase Postgres on GCP GA（11-02）**：99.99% SLA；asia-southeast1 / europe-west3 / us-central1 / east4 / west1〔A〕。
- 分片：`shards/C/C-part-01.md`

#### Cohere｜有动态
- **Model Vault 上架开源模型（11-03）**：DeepSeek V4.1 Flash、Gemma 4、GPT-OSS、Phi、Nemotron、GLM、MiMo、Hy3 等；**默认零数据留存**；US/EU/Canada（Encrypted：US 已上线）〔A〕。
- **Embed 5 + Rerank 5 上 OpenRouter（11-04）**：单一 API/key/计费；Pro/Fast 共享嵌入空间；Rerank 分数校准〔A〕。
- **未采用**：Series E 媒体口径（无一手，按纪律不采）。
- 分片：`shards/C/C-part-01.md`

#### Mistral｜有动态
- **Studio 扩展（11-05）**：托管 agent（skills/sandboxes/subagents/hooks）、workflows（事件触发 + 可视化图）、企业应用（托管 + 鉴权）、OTel 可观测、evals；MCP server 可从 Vibe 部署；Large 4 用于 cloud / VPC / on-prem；客户 ABANCA、BNP Paribas、CMA CGM、Accenture、Capgemini、TCS、Alten〔A〕。
- 分片：`shards/C/C-part-01.md`

#### Cursor / Anysphere｜有动态
- **Build Live Apps（11-05）**：云 agent 生成 web app + **Postgres** + **Cursor SSO 鉴权** + 托管；独立域名；发布前**确定性 + agentic 双重安全检查**；管理员可见/可下线；源 Origin + GitHub（GitLab 即将）〔A〕。
- 分片：`shards/C/C-part-01.md`

#### Cognition / Devin｜有动态（增量级）
- **发布说明（11-02）**：多仓扫描 **500 → 1,000**；自动扫描控制与排期；Findings 对话化；Slack「不在某频道」条件；多文件附件；401 发现 OAuth；API `provider_repository_id`〔A〕。
- **D 不采用**：融资谈至 $80B（无公司确认）。
- 分片：`shards/C/C-part-01.md`

#### Midjourney｜静默
- 最近官方稿 **10-08** Thinking Mode Alpha（窗外）；V9「约 30 天内」仅 Discord 转述〔**D**，不采用〕。已核验。

#### Scale AI｜静默
- 窗内无官方发布；UAE（10-26）、Qatar Pearl（10-28）、FineART（10-29）、NVIDIA Nemotron 后训练（10-15）均窗外。已核验。

### 5.4 D 组｜算力云硬件与具身（4 有料 / 4 静默）

#### AMD｜有动态（强）
- **Q3（11-03）**：见 TOP4。营收 **$13.377B**（+45%/+16%）；DC **$8.546B**（+97%）；GAAP $1.46 / 非 GAAP $2.09；Q4 指引 **~$17B** ±3%（同比约 +66%）；**Helios 在 Anthropic / Meta / Microsoft / OpenAI / OCI**；ROCm 10；Helion；拟收购 **World Labs / Taalas**〔A〕。
- 窗外：AMD×Meta Helios + $1B 股权（10-27）；Oracle E7（10-27）。
- 分片：`shards/D/D-part-01.md`

#### Broadcom（含 VMware / Tanzu）｜有动态
- **VCF 组合更新（11-04）**：AI Infrastructure Quickstart（计划 **Q1 FY27**）；多租户模型共享（9.1.1）；vSAN 原生 S3 即将；HyperArmor ESX；Live Recovery + Compliance/Config Advanced Services；**vSphere Express（128 核）立即可用**〔A〕。
- **Tanzu AI-Ready Data Foundations GA（11-03）**：联邦查询；受治理数据产品 + **嵌入式 MCP**〔A〕。
- **多站点 AI 网络（11-05）**：buffer ≥ **1.5× BDP** → 10/30/100 km **0% 重传**（NSCC/RCCC）；Jericho 深 HBM + Thor NIC〔A，仿真〕。
- **VMC on AWS SDDC 9.1 路径（11-03）**：Early Access → CY2027 新 SDDC GA → 全队列升级〔A〕。
- **D 不采用**：媒体「Anthropic TPU $43B 兜底」——无 IR 一手。
- 分片：`shards/D/D-part-01.md`

#### Oracle Cloud｜有动态（轻）
- **FDI Fusion Agents Repository（11-04）**：Fusion Data Intelligence 管理内的目录；下载 ZIP（构件 + PDF 安装说明）装入 AI Agent Studio；按已启用功能领域过滤〔A〕。
- 窗外：AI World 一系列（10-26/27）。
- 分片：`shards/D/D-part-01.md`

#### 优必选 / Ubtech｜有动态（披露级）
- **Thinker-Sim（11-02）**：Real2Sim2Real 平台（真实场景数字化、大规模仿真数据合成、机器人能力评估）；针对真实数据成本高、仿真搭建复杂、验证周期长〔**B**，官微经每经网转述〕。
- **D 不采用**：UAE RAK / 新华网机器人主播。
- 分片：`shards/D/D-part-01.md`

#### CoreWeave｜静默
- 窗内无新容量/产品稿；最近一手 10-27（丹麦 DEN01 约 **22.5MW** + 全球 AI 网络 PoP）。**Q3 电话会 2026-11-10**——下期观察点。已核验。

#### Tesla Optimus｜静默
- 无官方博客/IR；12 月预订仅媒体 + Musk 否认〔**D**〕。已核验。

#### Figure｜静默
- figure.ai/news 窗内无条目；全 hands（04 设计冻结、Index **3,750 万**条视频、>$2B 现金、Nscale $3.5B→$6B、Helix 3.0 预告）约 10-22，窗外且二手〔B，背景〕。已核验。

#### 宇树 / Unitree｜静默
- 官网新闻中心窗内无稿；10-27 异动公告窗外。媒体 Q3 数字（+69.9% 至 6.65 亿元、利润 −17.4%）未见 IR 一手〔B/C，**不进数字句**〕。已核验。

---

## 6. 必出对比表（强信号 24 行）

| 公司 | 事件类型 | 日期 | 要点 | 竞争/格局含义 | 证据级 |
|---|---|---|---|---|---|
| Anthropic | IPO 申报修订 | 11-02 | 9M 收入 **$33,242M**；Q3 **$17.0B**；承诺 **~$895.4B**；净亏 **$(104,039)M** 含 $(94,324)M 公允价值；现金 $131,845M；**ANT** | 首家纯前沿实验室公开定价；承诺/收入 ≈27× 成核心变量；PBC/LTBT 治理影响定价 | A |
| OpenAI | 并购 | 11-04 | 收购 **Pierre**（Code Storage + 开源 Trees/Diffs/Highlights，已在 Codex 用）；OSS 保持开源；交割待监管；对价未披露 | Agent 产出物的存储/审阅层内化；Git 工作流为 agent 改造 | A |
| OpenAI | 产品发布 | 11-05 | **GPT-6 Cyber**：ExploitGym **48.5%** vs 32.1%；Honeypot 99.93%/100%；Preparedness **Critical**；仅 Daybreak Red | 网安成独立产品线且自认高风险；仍低于 Gemini 4 Carbon 的 54.8% | A（厂商自测） |
| OpenAI | 安全分发 | 11-04 | **Daybreak Red 进 AWS GovCloud US-East**；GPT-5.6 Cyber on Bedrock；双重审批；推理不入训练 | 政府采购从直签变「云合同 + 审批」双闸 | A |
| OpenAI | 产品发布 | 11-04 | **Images 2.6**：约 +50% 速度、GIF、API Flare/Sunburst；约 40 亿张/周 | 多模态吞吐成为消费级默认；与 Google 视频降价同向 | A（厂商自测） |
| Meta | 并购 | 11-04 | **Conductor 加入 Meta**；多 agent 隔离并行；云 **11-04 停注册 / 11-13 只读 / 11-20 删数据**；本地版至 2027 初；条款未披露 | 多 Agent 编排被平台内化；独立编排 SaaS 的退出天花板样本 | A（卖方公告） |
| Meta | 产品发布 | 11-05 | **Muse 实时语音 + 表达型 avatar**；数百种声线；美国先行；AI Glasses / Muse Charm 即将推出 | 消费端交互从文本扩到语音+形象，为硬件预置 | A |
| Sierra | 并购 | 11-05 | 收购 **Anon**：agent 浏览器登录/表单/无 API 操作（「AI agent 的 Plaid」）；累计融资 >$13M；数百客户；条款未披露 | 补上「行动半径」，agent 从建议到完成；身份成新的锁 | A |
| AMD | 财报 | 11-03 | 营收 **$13.377B**（+45%）；DC **$8.546B**（+97%）；Q4 **~$17B** ±3%；**Helios 在 Anthropic/Meta/Microsoft/OpenAI/OCI**；拟收购 World Labs/Taalas | 第二供应商五客户落地；算力可替换性可核 | A |
| NVIDIA | 性能叙事 | 11-05 | Vera：**1.6× agents/watt**、**2× agent 速度**；Daytona 1,000 沙箱 **10.8s vs 88.4s** | 容量单位从 GPU 数变为每瓦 agent 数；CPU 侧回归 | A（厂商/伙伴自测） |
| 腾讯 | 模型发布 | 11-04 | **Hy4**：首次视觉理解 + **Computer Use（CLI+GUI）**；金融众测 3.04（对照 2.68/2.68/2.97）；幻觉 12.95%→7.2%；**定价 6/18 元不变**；权重将开源 | 国产开源补上 GUI 执行；不涨价换份额；放大身份层需求 | A（基准 B） |
| 字节 | 平台策略 | 11-05 | 豆包工作接入 **Kimi K3.1 Pro / GLM 5.3 / DeepSeek V4.1 Flash** | 工作台多模型化，模型厂沦为 SKU | **B（据媒体）** |
| AWS | 产品 GA | 11-05 | **Web Answer on AgentCore**：一次 MCP 调用返回带引用答案；域名/日期过滤；零外流；**$10/1,000 次** | 检索→引用→答案被压成云原语；RAG 工程量转云账单 | A |
| Microsoft | 平台能力 | 11-04/05 | Copilot Studio **持久化 agent**（自带凭证 + 业务记忆 + 触发器）；Foundry **Browser Automation GA**；MCP + A2A 双支持 | 云厂商用原语化替代并购；agent 身份管理成新科目 | A |
| Databricks | 平台集成 | 11-03 | **Claude 原生 OTel → MLflow**（经 Zerobus → Unity Catalog），公测 | 第三方 agent 观测被数据平台收编；Anthropic 失去观测层差异化 | A |
| Broadcom | 产品组合 | 11-03/04 | Tanzu **AI-Ready Data Foundations GA**（含嵌入式 MCP）；VCF 私有 AI Quickstart 计划 Q1 FY27；vSphere Express 128 核可用 | 私有云「跑 agent」端到端配方，对公有云原语形成替代 | A |
| Broadcom | 技术规则 | 11-05 | buffer ≥ **1.5× BDP** → 10/30/100 km **0% 重传**（NSCC/RCCC）；Jericho 深 HBM + Thor NIC | 跨园区 AI 集群首个可写进标书的网络参数 | A（仿真） |
| Mistral | 平台发布 | 11-05 | **Studio** 扩展：托管 agent/workflow/企业应用/OTel/evals；可 cloud/VPC/on-prem；客户 ABANCA、BNP、CMA CGM 等 | 主权部署 + 平台化，绕开权重价格战 | A |
| Cohere | 平台发布 | 11-03 | **Model Vault** 上架 DeepSeek V4.1 Flash、Gemma 4、GLM 等；**默认零数据留存**；US/EU/Canada | 主权推理做多模型货架；合规即定价 | A |
| Cursor | 产品发布 | 11-05 | **Build Live Apps**：云 agent 生成 app + Postgres + **SSO** + 托管；发布前双重安全检查 | IDE 变部署面；身份握在自己手里 | A |
| Perplexity | 产品发布 | 11-04 | **Teammates**：常驻 agent 承接进行中项目；**agent 间交接**；独立环境 + 加密凭证；Max 先行 | 从问答到「拥有任务」；应用层自建小型 A2A | A |
| Harvey | 合作 | 11-04 | **Jus Mundi A2A** 接入 Assistant/Agents/Vault/Workflows；带引用；联合客户年底前**不加价** | 垂直专用 agent 嵌进水平平台；A2A 靠分发而非调用收费 | A |
| Google | 产品发布 | 11-05 | **Omni 1.2 Flash**：15 秒视频（原 10 秒）、多轮编辑、**−30%** → **$0.07/秒（720p）** | 视频竞争轴从秒数转向单位秒价与可编辑性 | A |
| xAI | 产品发布 | 11-02 | **Data Bot**：常驻 Slack 的团队数据科学 bot，接 Databricks/Hex，xAI 称一周约 70 小时工作量 | 职能型常驻 bot 模板；BI 席位模型受冲击 | A（产能自述 B） |
| 优必选 | 产品发布 | 11-02 | **Thinker-Sim**：Real2Sim2Real（场景数字化、仿真数据合成、能力评估） | 具身数据成本前移；评估成独立产品 | **B** |

> 不入本表主行：Perplexity ultra **$21.71/任务**（待核）、Cognition 融资 **$80B**（D）、Midjourney V9（D）、Tesla 12 月预订（D）、Broadcom $43B 兜底（D）、World Labs/Taalas 业务细节（机制未取得）。

---

## 7. 周环比素材

详见同目录 **`wow.md`**。摘要：

- **延续**：Anthropic 从 S-1（10-26）到 **S-1/A 完整口径**；AMD 从「Helios 装机 Meta」到 **五客户名单**；Sierra 从 Poppy 协议到**买 Anon 补实现**；Devin 从 Security 2.0 到 **1,000 仓扫描**；Oracle 从「×OpenAI 应用栈」到 **agent 目录**；Cursor 从 Agent SDK 到 **Build Live Apps**。
- **新出现**：**三笔工作台并购同周成立**（Pierre/Conductor/Anon，三层互不重叠）；云厂商**原语化替代解**（持久化 agent + Browser Automation GA + Web Answer）；Anthropic 账本的**三个衍生事实**（Q3 > H1、承诺 ≈27×、现金覆盖 1.9×）；**算力可替换 vs 工作台不可替换**的接合点（AMD 五客户与并购买方重叠）；硅厂买软件资产（World Labs/Taalas）；**1.5× BDP** 网络设计规则；Hy4 把 **GUI 执行**纳入开源路线；常驻 agent 产品化（Teammates、Data Bot）；成本治理成为产品功能（75%/90%、Copilot Credit）。
- **消失/降温**：**三云财报叙事**（上期 TOP1 与主体）本周无；**Meta ~$95B 股权**无增量；**Broadcom $63B SPV / Oracle×TPU** 无新增（信用议题暂停 ≠ 解决）；Tesla Optimus 与 Figure **连续第二周官方静默**；宇树官网静默；Midjourney / Scale 静默；**具身整体降温**（D 组唯一实质为 B 级）；**Kimi K3.1 Pro 开源承诺「未核到」**（不写「未开源」）；OpenAI 购 TPU 传闻未再出现（仍 D）。

**主线迁移**：上期问「钱从哪来」（股权/SPV/负 FCF/IPO），本期问「钱买到什么」（三层工作台）。同为价值链定价，但标的从**可替换的重资产**转向**不可替换的时间密集型资产**。

---

## 8. 洞察｜对投资与战略观察者

1. **竞争前沿移到「生成之后」**。过去 18 个月的投资逻辑是「模型能力 → 用量 → 收入」；本周三家买的东西说明，真正的瓶颈在产出物的存储与审阅、多 agent 的隔离与调度、以及 agent 的身份与登录。**这三层没有一个是模型公司的主场，也没有一个能靠算力加速。**
2. **「不可替代性」成为新的估值轴**。AMD 五客户名单证明算力可多源；Anthropic 的 $895.4B 承诺证明算力可签约；而 Pierre 的 Trees/Diffs 是 Codex 的底层依赖、Anon 的站点适配要靠时间积累——**这类资产没有第二供应商**。资本在同一周流向后者，是估值轴迁移的信号。
3. **并购条款要看「关停时间表」而不是「协同故事」**。Conductor 三条时间戳（11-04/11-13/11-20）说明平台买方只要团队与经验。对同类公司的估值谈判，「客户迁移成本」应单独计价；对买方，这是一次性获得时间密集型资产的最低成本方式。
4. **云厂商的原语化是工作台创业公司的主对手**。Browser Automation GA、持久化 agent、一次 MCP 调用返回带引用答案——客户只需改配置。创业公司能守的只剩「云不愿做的长尾」与「云做不了的合规特例」。
5. **身份是被低估的战场**。Sierra 买 Anon、Cursor 用自家 SSO、Microsoft 让 agent 自带凭证——三家在同一周把身份放进核心。理由很简单：模型可以换、算力可以换，**身份关系换不了**。
6. **成本治理会成为采购门槛而非加分项**。Glean 的 75%/90% 阈值与 Copilot Credit 管理同周出现，说明企业已在月中撞额度。2027 年的工作台投标，给不出成本上限的一方会被直接排除。
7. **Anthropic 的披露会提高全行业的融资门槛**。$895.4B 承诺 + 26.9× 覆盖比一旦成为公开基准，下一轮实验室融资会被要求同等颗粒度。这对头部是护城河（只有它们能承受披露），对长尾是门槛。
8. **中国侧是另一道题**。B 组 9 家中 6 家静默，信号集中在「货架 + 折扣」（Hy4 不涨价、TokenHub 五折、豆包接三方模型）。不是能力差距，而是**分发结构不同**：入口在超级 App 与云平台手里，买流程层的边际收益低于美国。判断中国工作台竞争，要看入口而非模型榜。
9. **勿升格清单**：Perplexity ultra $21.71（待核）、Cognition $80B（D）、Midjourney V9（D）、Tesla 12 月预订（D）、Broadcom $43B 兜底（D）、Anthropic 估值与上市日（D）、OpenAI 购 TPU（D）、Kimi 开源（未核到）、World Labs/Taalas 业务（机制未取得）。

---

## 9. 覆盖与局限

### 9.1 已覆盖

- **固定对象 37**：有料 **25** + 弱 **2** + 静默 **10**；名单外深写约 **8** 条（Pierre、Conductor、Anon、Jus Mundi、World Labs、Taalas、Fireworks、Lopezmarqués）。
- **窗内一手事件**：A 17 / B 3 / C 14 / D 7 = **41**（紧口径）。
- **一手核验**：SEC S-1/A 归档原文；OpenAI 6 个官方页；Google 4 个官方页；Meta/Conductor 公告与 Meta 新闻室；Microsoft 2 个官方博客；AWS what's-new + ML 博客；xAI 博客；NVIDIA 博客；腾讯新闻稿；火山方舟公告；DeepSeek GitHub 仓库；Sierra / Perplexity / Runway / Harvey / Glean / Databricks / Cohere / Mistral / Cursor / Cognition 官方页；AMD 财报新闻稿；Broadcom/VMware 4 篇；Oracle 博客；优必选官微（经媒体）。
- **主线三问**（发生了什么 / 机制 / 格局）已在 §3 回答；WoW 见 §7 与 `wow.md`；完整对比表见 §6。

### 9.2 局限与未取得

| 项 | 说明 |
|---|---|
| **10-30 空档日** | 上期窗口止于 10-29，本期始于 10-31，**10-30 无期覆盖**。Sierra $400M+ ARR、OpenAI GPT-6 Rosalind Research 扩容等落在该日，本期仅作背景。这是两期之间的系统性盲区，需在流程上修正（窗口应为「上期结束次日 00:00」起算）。 |
| Anthropic 经营现金流 | S-1/A 折旧/现金流细项未取；$(104,039)M 净亏剔除公允价值后的余额含其他非经营项，**不等同经营亏损**，本稿已加口径警示。 |
| Anthropic 分部对账 | 「Claude 收入」与「总收入」的分部对账表未取得，仅能确认前者为后者主要构成。 |
| Pierre / Anon 交易条款 | 均未披露金额与对价形式；Conductor 条款亦未披露。三笔并购的**规模排序无法建立**。 |
| Conductor 买方确认 | 仅卖方公告（conductor.build），Meta 侧无对应新闻稿；正文写「Conductor 宣布加入 Meta」，不写「Meta 宣布收购」。 |
| Perplexity Agent API 数值 | 官方页抓取超时；ultra **$21.71/任务**、**85.9% WANDR** 标「待核」，**不进任何确定句**。 |
| Perplexity Teammates 计价 | 是否含在 Max 内、并发上限、数据保留策略均未披露。 |
| AMD 五客户部署规模 | 仅「正在运行」，无装机量/机柜数；MI450 出货量未披露。 |
| World Labs / Taalas | 仅有「已签署收购协议」，业务描述与对价未取得（**机制未取得**）。 |
| 腾讯 Hy4 技术细节 | 参数规模、上下文长度、许可证、Computer Use 沙箱边界均未取得；全部基准为厂商自测。 |
| 字节 -evolving | 公告无任何量化指标；豆包工作接三方模型仅媒体（**B**）。 |
| 中国侧静默的成因 | 阿里/百度/华为/MiniMax 静默可能是抓取覆盖不足，也可能是确实无发布——**本期无法区分**，统一写「静默（未核到）」，不写「无动作」。 |
| Kimi 开源承诺 | 「≤11/4 开源」**未核到**兑现公告；这是核验结论，不是否定事实。 |
| 具身侧 | Tesla / Figure / 宇树 官方静默；优必选为 B 级（官微经媒体）。本期无可用于规模比较的一手。 |
| 性能数字的独立性 | NVIDIA Vera、OpenAI ExploitGym/Images、Runway Characters、Databricks Spark、Broadcom 1.5× BDP 均为**厂商或伙伴自测/仿真**，无第三方复现；正文一律标「厂商称」。 |
| 竞品基准缺位 | Anthropic 窗内无产品，无法与 Hy4 / Omni / GPT-6 Cyber 做同期横评；OpenAI 的网安对比只能引用窗外 Gemini 4 Carbon 的 54.8%。 |
| 抓取失败 | 各 `*-search.json` 均未生成；SEC browse-edgar 被拦；Perplexity Cloudflare；Midjourney 公告索引 500；若干首猜 URL 404。补救方式见各 `discovery.md`。 |
| 开源 Agent 工程细节 | 本报不覆盖（归 Agent 研究周报），仅在公司战略层提及（Mistral Large 4 权重、腾讯 Hy4 将开源、DeepSeek harness 原型）。 |

### 9.3 证据纪律提醒

- **厂商自测**：ExploitGym 48.5%/32.1%、Honeypot 99.93%/100%、Images 2.6「~50%」、Hy4 基准 3.04/2.68/2.68/2.97 与幻觉 12.95%→7.2%、Vera 1.6×/2×、Runway 99.5%、Spark P99 136–141ms、Broadcom 0% 重传、AMD 五客户「运行」——全部标厂商/伙伴口径。
- **本报计算值**（H1 $16,242M、承诺/收入 26.9×、年化 20.2×、余额 $(9,715)M、现金覆盖 1.9×、DC 占比 63.9%、Q4 环比 +27.1%、948/166 ≈ 5.7×）**不是披露值**，引用必须标注「本报计算」。
- **媒体级**：豆包工作接三方模型（B，据媒体）。
- **D 级不入正文**：Cognition $80B、Midjourney V9、Tesla 12 月预订、Broadcom $43B、Anthropic 估值/上市日、OpenAI 购 TPU、阿里「神秘新模型」、智谱 GLM-5.5。

---

## 10. 来源清单

### 一手 / 官方（本期直接引用）

**OpenAI**
- GPT-6 Cyber｜https://openai.com/index/introducing-gpt-6-cyber/
- A thousand fewer paths to root｜https://openai.com/index/a-thousand-fewer-paths-to-root/
- 收购 Pierre｜https://openai.com/index/openai-to-acquire-pierre/
- Images 2.6｜https://openai.com/index/introducing-images-2-6/
- Daybreak Red on AWS GovCloud｜https://openai.com/index/daybreak-red-aws-govcloud/
- Release notes（Dots）｜https://openai.com/products/release-notes/

**Google**
- Gemini Omni 1.2 Flash｜https://blog.google/innovation-and-ai/technology/developers-tools/introducing-gemini-omni-1-2-flash/
- 同上（Cloud）｜https://cloud.google.com/blog/products/ai-machine-learning/gemini-omni-1-2-flash-generally-available
- Antigravity 化学信息学｜https://deepmind.google/blog/agentic-cheminformatics-with-google-antigravity/
- PlanAssist｜https://deepmind.google/blog/speeding-up-planning-decisions-with-ai/

**Anthropic**
- Form S-1/A Amendment No.1（Reg. 333-299633）｜https://www.sec.gov/Archives/edgar/data/2130357/000162828026068676/anthropicpbc-sx1ax1.htm
- 新闻索引（静默核验）｜https://www.anthropic.com/news

**Meta**
- Conductor 加入 Meta｜https://www.conductor.build/announcement
- Muse 语音/形象｜https://about.fb.com/news/2026/11/introducing-muse-ai-voice-expressive-avatars/
- ai.meta.com（GSLM2 题录）

**Microsoft**
- Copilot Studio 10 月更新｜https://www.microsoft.com/en-us/copilot/blog/copilot-studio/new-and-improved-agents-that-are-persistent-agents-for-customer-conversations-and-improved-maker-experience-in-microsoft-copilot-studio/
- Foundry 10 月汇总｜https://devblogs.microsoft.com/foundry/whats-new-in-microsoft-foundry-october-2026/

**AWS**
- Web Answer GA｜https://aws.amazon.com/about-aws/whats-new/2026/11/web-answer-amazon-bedrock/
- Web Answer how-to｜https://aws.amazon.com/blogs/machine-learning/getting-started-with-web-answer-on-amazon-bedrock-agentcore/

**xAI / NVIDIA**
- Data Bot｜https://x.ai/news/data-bot
- Vera 性能｜https://blogs.nvidia.com/blog/vera-cpu-highest-throughput-fastest-agents/
- NVIDIA 财报电话会（11-17）｜https://nvidianews.nvidia.com/news/nvidia-sets-conference-call-for-third-quarter-financial-results-6928873

**中国**
- 腾讯混元 Hy4｜https://www.tencent.com/zh-cn/tencent-launches-hy4-joining-the-ranks-of-the-worlds-leading-open-source-ai-models/
- 火山方舟模型发布公告｜https://ark.volcengine.com/region:cn-beijing/docs/model-release-announcement
- DeepSeek dsh-superagent-prototype｜https://github.com/deepseek-ai/dsh-superagent-prototype/

**应用与垂直**
- Sierra × Anon｜https://sierra.ai/blog/sierra-acquires-anon
- Perplexity Teammates｜https://www.perplexity.ai/hub/blog/teammates-are-agents-for-complex-ongoing-work
- Perplexity Agent API（待核）｜https://www.perplexity.ai/hub/blog/improvements-to-every-agent-api-effort-level
- Runway Characters｜https://runway.com/news/research/real-time-video-at-batch-size-one
- Harvey × Jus Mundi｜https://www.harvey.ai/blog/harvey-and-jus-mundi-announce-an-agent-to-agent-partnership
- Harvey × Lopezmarqués｜https://www.harvey.ai/blog/lopezmarques-adopts-harvey
- Glean × Fireworks｜https://www.glean.com/blog/glean-fireworks-ecosystem
- Glean Release 567｜https://docs.glean.com/release-notes/releases/2026-11-03-november-release
- Databricks Spark 4.3｜https://www.databricks.com/blog/introducing-apache-spark-43-now-available-databricks-runtime-19
- Databricks × Claude OTel｜https://www.databricks.com/blog/claude-platform-now-supports-native-opentelemetry-observability-databricks-mlflow
- Databricks Lakebase on GCP｜https://www.databricks.com/blog/lakebase-postgres-now-generally-available-google-cloud
- Cohere Model Vault｜https://cohere.com/blog/open-source-model-vault
- Cohere Embed/Rerank on OpenRouter｜https://cohere.com/blog/embed-rerank-5-openrouter
- Mistral Studio｜https://mistral.ai/news/build-with-studio/
- Cursor Build Live Apps｜https://cursor.com/changelog/build-live-apps
- Cognition 发布说明｜https://docs.devin.ai/release-notes/2026

**算力 / 云 / 硬件 / 具身**
- AMD Q3 FY2026｜https://newsroom.amd.com/news/amd-reports-third-quarter-2026-earnings/
- Broadcom VCF 组合｜https://blogs.vmware.com/cloud-foundation/2026/11/04/broadcom-vcf-portfolio-updates/
- Broadcom Tanzu 数据底座｜https://blogs.vmware.com/tanzu/announcing-ai-ready-data-foundations-in-tanzu-platform-trusted-data-for-reliable-agentic-ai/
- Broadcom 多站点网络｜https://www.broadcom.com/company/news/articles/ai-infrastructure/scaling-ai-beyond-data-center-buffer-depth-multi-site-clusters
- VMware Cloud on AWS 9.1｜https://blogs.vmware.com/cloud-foundation/2026/11/03/whats-coming-next-vmware-cloud-on-aws-sddc-upgrade-to-version-9-1/
- Oracle FDI Agents Repository｜https://blogs.oracle.com/analytics/from-discovery-to-use-introducing-the-fdi-fusion-agents-repository-for-oracle-ai-agent-studio
- 优必选 Thinker-Sim（官微经媒体）｜https://www.nbd.com.cn/articles/2026-11-02/4633792.html

### 媒体 / 二级（B/C，仅辅助）

- 经济观察网（豆包工作接三方模型，11-05）｜http://www.eeo.com.cn/2026/1105/1084503.shtml —— **B，据媒体**
- Axios / TechCrunch（Conductor 条款未披露）
- Digg（Perplexity ultra，二手佐证，待核）

### 内部

- `raw/`（7 份原始材料）｜`shards/A|B|C|D/`（8 份分片）｜`prior-wow.md`｜`prior-master.md`｜`wow.md`

---

## 冻结声明

本稿为**第 24 期研究母稿冻结版**（2026-11-06，Asia/Shanghai）。

后续读者稿（report2article 等）**只许压缩与改写表述，不得新增未在本稿或分片出现的事实、数字、日期、URL**。证据级 A–D、覆盖与局限、完整对比表保留于 archive，不进入读者正文。

**三条不可越界的表述**：

1. 不得写 OpenAI 在网安取得 SOTA（Gemini 4 Carbon 的 ExploitGym 54.8% 高于 GPT-6 Cyber 的 48.5%，且后者为厂商自测）。
2. 不得写「Meta 宣布收购 Conductor」（仅卖方公告，条款未披露）。
3. 不得把本报计算值（26.9×、20.2×、1.9×、63.9%、+27.1%、5.7×、$16,242M、$(9,715)M）当作披露值引用。
