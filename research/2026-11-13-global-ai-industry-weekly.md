# 全球 AI+产业研究周报 · 第 20261113 期（母稿·冻结）

- 运行日：2026-11-13（周五，Asia/Shanghai）
- 观察窗口：**2026-11-06 00:00 → 2026-11-12 24:00**（上周五 00:00 → 本周四 24:00）。全文「本周」仅指该窗口。
- 期号：第 20261113 期；周环比对照第 20261030 期（窗口 2026-10-23~10-29，主线「验证器与规则先行」）。
- 缺期说明：第 20261106 期未完成（无母稿/读者稿）。本期不补做、不改窗口。凡涉及该窗口的事项一律标「补登/上期未刊，非本周」，不混入本周判断。
- 读者：行业解决方案负责人 / 产业观察者（主责 R2，协同 R3）。研究「AI 如何落入各行各业」，不以大模型公司本身为研究对象。
- 范围：工业制造、创意与内容、商业与公共服务、教育科研四个一级行业；地域以中美（含香港）为主，兼顾新马/东南亚/欧洲。

---

## §0 一句话结论

**本周的分水岭不是模型更强，而是「开门不放权」成了共识**：入口可以开放，执行权必须留在记录系统里；同时把「一次」的定义切得更细——从席位切到动作、秒、单件资产。两件事同时出现在工业软件、广告创意、支付网络与企业软件里，并开始决定收谁的钱、收多少。

据此选定本期主线专题：**开门不放权——读开放、写收紧、按动作计量**。核心案例簇为 Anthropic × Infor（11-12，制造插件：读走连接器、写走 Infor 插件、人复核为终点），横向对照 Panasonic KMC（11-11，参考模型作公地）、ServiceNow（11-12，按动作计费 + 可关停）、Mastercard（11-12，可验证意图令牌）、Ogilvy ECHO（11-09，逐资产审批）。

---

## §0.1 本期 TOP5（母稿锚点，均窗内）

| # | 日期 | 主体 | 事实（摘要） | 机制（一句话） | 证据级 | 一手来源 |
|---|---|---|---|---|---|---|
| 1 | 11-12 | Anthropic × Infor | 17 skills + 4 连接器；读写分离；人复核为终点 | 通用模型接受记录系统的管辖权 | A | https://claude.com/blog/claude-for-manufacturing |
| 2 | 11-12 | Mastercard（+ 11-11 United） | 首笔实时端到端 Agent 旅行交易；可验证意图令牌 | Agent 准入被做成可举证的数据，商户可反向封禁 | A/B | https://www.pymnts.com/transportation/travel-payments/2026/mastercard-touts-successful-agentic-travel-transaction/ |
| 3 | 11-12 | ServiceNow | 非席位收入过半；agentic 13 倍；Control Tower 可关停 | 治理与计费绑成同一产品 | B | https://finance.yahoo.com/technology/ai/articles/servicenow-targets-back-office-ai-171526616.html |
| 4 | 11-09 | Ogilvy × CAA | 逐资产审批 + 肖像单一事实源 + 成品水印 | 肖像授权变成软件对象 | A | https://www.ogilvy.com/ideas/ogilvy-launches-echo-industrys-first-talent-consent-based-creative-ai-platform |
| 5 | 11-11/12 | Google（K-12 后续） | 7 城抗议；无 AI-free Search；学区以退出检索相威胁 | AI 焊进基础入口后，「不用 AI」等于采购退出 | A/B | https://arstechnica.com/tech-policy/2026/11/families-fight-to-keep-googles-disturbing-ai-off-school-issued-chromebooks/ |

选择口径：按「是否改变交付结构与责任边界」排序，不按声量；每条的窗内日期、证据级与一手链接均可回溯到 §8 与分片。B 级为厂商自述，已在正文标注「据 X 披露」。

---

## §1 发现层摘要

### 1.1 扫面结构

| 批次 | 组 | 范围 | 固定对象 | 有料 | 静默 | 未取得 | 名单外纳入深写 |
|---|---|---|---|---|---|---|---|
| 第一批 | A1 | 工业·现场与产线 | 17 | 5 | 10 | 2 | 2（Anthropic、Agile Robots） |
| 第一批 | A2 | 工业·工程工艺与工业智能基座 | 15 | 8（真正产品/机制新信息 6） | 5 | 2 | 1（Infor） |
| 第一批 | B | 创意与内容 | 18 | 14 | 3 | 1 | 0（线索另列） |
| 第一批 | C | 商业与公共服务 | 20 | 14（弱 4） | 5 | 1 | 1（United Airlines） |
| 第二批 | D | 教育科研 + 政策专项 | 20 | 8 | 3 | 9 | 0 |
| 合计 | — | 五个组 | **90** | **49** | **26** | **15** | **4** |

说明一：A1/A2 对 Anthropic 与 Panasonic 各有交叉取证，母稿以 A2 的机制侧为主、A1 的现场侧为辅，计数去重后不重复计入「有料」（故一级行业有料数为 11 而非 13）。
说明二：B 组第 18 个对象为中文在线，单列时计入「未取得」，合并进阅文条目时计入「静默」，此处按单列口径计 1。「弱」指仅标题/二手/非产品动态。

**一级行业有料对象数（去重、含名单外纳入，供图表 fig1 使用）：工业制造 11｜创意与内容 14｜商业与公共服务 15｜教育科研与政策 8。** 口径＝该行业在窗内至少有一条可核条目的固定对象，加上窗内纳入深写的名单外对象（工业加 Anthropic、Infor；商业加 United Airlines）。

![本周各一级行业「有料」对象数柱状图：工业制造 11、创意与内容 14、商业与公共服务 15、教育科研与政策 8](assets/images/posts/2026-11-13-ai-industry-weekly-fig1.png)

*图 1｜本周各一级行业「有料」对象数（2026-11-06~11-12）。口径：窗内至少 1 条可核条目的固定对象 + 窗内纳入深写的名单外对象。数据来源：本期 master.md §1.1；原始数据 `charts/data-industry-covered.csv`。*

说明：A1/A2 对 Anthropic 与 Panasonic 各有交叉取证，母稿以 A2 的机制侧为主、A1 的现场侧为辅，计数去重后不重复计入「有料」。B 组「未取得」为 0，但中文在线单列时计 1，已在覆盖表标注。

### 1.2 覆盖表（固定对象终态）

状态定义：**有料**＝窗内有可核条目（含仅标题/二手，另标证据级）；**静默**＝已核一手入口窗内无相关条目；**未取得**＝入口不可达或检索无结果，不等于无事件（已试入口见 §1.3）。

#### 工业制造（A1 现场与产线）

| 对象 | 状态 | 窗内条目 | 关键内容 | 证据级 |
|---|---|---|---|---|
| Siemens | 有料 | 2 | FY26：订单 €108.2bn（+25%）、Q4 订单 €34.77bn（+58%）、积压 €143bn；DI 软件 €7.2bn（+13%）、ARR €6.1bn（+12%）；Q4 高增来自 Mobility 与数据中心配电，不是工厂侧 | A（财务）/B（AI 占比） |
| Panasonic | 有料 | 1 | KMC（11-11）：产官学共建 Physical AI 参考模型 + 评价环境，对标 AUTOSAR，2027-04 门真开设 | A（发布）/B（时间表、人数） |
| GXO | 有料 | 1 | ×Apptronik 签 LOI（11-12）：RaaS、4 年最多 1,000 台、按 KPI 逐场景、北美 2027 年底首批、50+ 任务库 | A |
| Rockwell | 有料 | 3 | LogixEdge（11-12）：工业 PC 同机跑确定性控制 + 容器化应用；PartnerNetwork 与 PanelView 仅标题 | A（产品）/B（旁支） |
| Foxconn | 有料 | 1 | Q3 营收 NT$3.02tn（+46%）、净利 NT$77.52bn（+34%）、毛利率 6.02%（−0.33pp） | C（二手转述） |
| ABB / 美的 / 海尔 / 三一 / 徐工 / 立讯 / 宝马 / 丰田系供应商等 | 静默 | 0 | 窗内无一手产品/客户条目（逐站核验记录见 shards/A1） | — |
| Toyota | 未取得 | 0 | 2028 计划含工厂机器人，仅标题 | D |
| Hyundai | 未取得 | 0 | Mobis 为 Atlas 供件，仅标题 | D |

#### 工业制造（A2 工程工艺与基座）

| 对象 | 状态 | 窗内条目 | 关键内容 | 证据级 |
|---|---|---|---|---|
| Anthropic | 有料（名单外） | 1 | Claude for Manufacturing（11-12）：17 skills + 4 连接器，人复核为终点，不操作设备，另立 Model Hardware Standard | A |
| Infor | 有料（名单外） | 1 | ×Anthropic：读走连接器、写走 Infor 插件，SSO/角色/逐次批准/审计留在 Infor | A |
| Siemens | 有料 | 1 | 软件营收约 5% 可归因 AI；11-10 收购 Lauterbach | B |
| Cadence | 有料 | 1 | OrCAD Xplore（11-10）：1,600 万+ 器件库，检索最快 +80%，每器件省 3 小时 | A/B |
| Synopsys | 有料 | 1 | ×Infineon AURIX RC1 VDK（11-10）：最多 90% 软件验证前置 | A/B |
| AVEVA | 有料（弱） | 1 | 微软可持续发展合作伙伴奖决选，无产品 | B |
| NVIDIA | 有料（非工业） | 1 | CEO 变更（11-12），治理事件，工业侧无发布 | C |
| Dassault / PTC / Emerson / 中控 / AWS | 静默 | 0 | 逐站核验；PTC 的实质变量是 10-05 Schneider 收购（窗外） | — |
| 华大九天 / 华为云 | 未取得 | 0 | 官网空/超时、Akamai 拦截、检索无窗内稿 | — |

#### 创意与内容（B）

| 对象 | 状态 | 窗内条目 | 关键内容 | 证据级 |
|---|---|---|---|---|
| Ogilvy / WPP | 有料（重点） | 1 | ECHO（11-09）：同意优先、CAA Vault 单一肖像源、逐资产审批门户、水印「Approved」，跑在 WPP Open | A/B |
| Adobe | 有料（重点） | 3 | MAX（11-10）：Firefly 多模型、Creative Agent 的 Plan Mode + Model Selector、本地 MCP 改 PSD/AI/PR/AE、GenStudio、Brand Intelligence；Disney Firefly Foundry（11-09） | A |
| Google / YouTube | 有料（重点） | 1 | Gemini Omni 1.2 Flash GA（11-06）：720p $0.07/秒、−30%、15 秒、SynthID | A |
| Suno / Udio | 有料（重点） | 3 | 11-07/08 Elvis 权利方与 Eminem 出版方起诉；11-12 Reservoir 索赔升至约 4.5 亿美元 | B |
| Disney / Netflix | 有料（重点） | 2 | Disney 私有模型投产；Netflix 对单部剧下生成式 AI 禁令（11-11/12，项目级） | B/C |
| Publicis / Omnicom / Havas·Dentsu | 有料 | 3 | Marcel 人事、Lufthansa 媒介、CEO 更替，均非 AI 产品 | B |
| 字节 即梦 / 可灵 / 美图 | 有料 | 3 | 即梦动效工作室（11-10，媒体实测 60 秒≈82 积分）；可灵仅出现在 Adobe 模型清单；美图为 MOU | B/C |
| 阅文 / 芒果 / 中文在线 | 有料（弱） | 2 | AI 漫剧分账、商标，仅标题级 | C/D |
| UMG / Sony·Warner | 静默 | 0–1 | 窗内无新授权交易，仅延续性报道 | C |
| Canva / Runway | 静默 / 偏离 | 0–1 | Canva 重组在 11-03（窗外）；Runway Praxis-1 是机器人 world-action 模型 | — |

#### 商业与公共服务（C）

| 对象 | 状态 | 窗内条目 | 关键内容 | 证据级 |
|---|---|---|---|---|
| Mastercard | 有料 | 2 | 11-12 首笔实时端到端 Agent 旅行交易（Travelport/Booked AI/Basis Theory），航司仍为商户、无收单行、卡号留 PCI 金库；Trust Framework 五支柱 + verifiable intent（与 Google 共研，已交 FIDO/EMVCo） | A/B |
| United Airlines | 有料（名单外） | 1 | 11-11 修改运输合同，禁止第三方 Agent 订改票；CEO「不想再制造一个中间人」 | B |
| ServiceNow | 有料 | 1 | EmployeeWorks 前三季 1 亿美元、Q3 十笔 >100 万美元、客户 +60%；agentic 使用 13 倍；非席位收入过半；Control Tower 6 倍、可关停；按动作计 Assist credits | B |
| Microsoft | 有料 | 1 | Frontier Company：500 项目/200+ 客户/28 国；Northern Trust 2.5 周→3 天（−83%）、首过 96.5%；KT 10 分钟→2–3 分钟；Saint-Gobain 6.2 万专利；Publicis 11.4 万人 | B |
| SAP | 有料（demo） | 1 | S.Fashion 概念店（11-12）；API 政策要求外部 Agent 经 Joule 走 A2A，DSAG 要求过渡保护 | B |
| 阿里巴巴 淘天 | 有料 | 2 | Token 成 Double 11 独立类目，首日销售额 +450%；李佳琦专场半小时近 10 万份会员、约 2 万亿 Token | B |
| 京东 | 有料 | 1 | 100+ 服务类商品；AI 业务中心向商家提供数十款工具 | B |
| 中国政务（北京知识产权局） | 有料 | 1 | 政务问答上线：测试 232 条、标注 166 条，准确率 71.90%→99.35% | A |
| 新加坡 IMDA | 有料 | 1 | ×Scale AI 发布 SG-LegalClarify：19 模型、1,860 情境、12,546 条律师 rubric；闭卷最佳 69.8%、联网 77.8%；39% 该问不问 | B |
| Itaú Unibanco | 有料 | 1 | ×Harness：治理模板 + 自动验证 + 策略控制 + 自动回滚，全工程组织采用 | A |
| Shopify / Salesforce | 有料 | 3 | Shopify Q3 营收 37.4 亿美元 + Meta Muse×Shop Pay；Salesforce ROI 报告仅 24 人样本 | B |
| Starling / Visa / JPMorgan | 有料（弱） | 3 | Starling「Talk to Transact」、Visa 波兰试点、Dimon 警告，均仅标题 | C |
| HSBC / Stripe / PayPal / 蚂蚁 / 英国政府 | 静默 | 0 | 逐站核验（蚂蚁「灵光」无窗内条目） | — |
| 美国政府（GSA/OneGov） | 未取得 | 0 | 三组 query 均 0 条 | — |

#### 教育科研（D）与政策专项

| 对象 | 状态 | 窗内条目 | 关键内容 | 证据级 |
|---|---|---|---|---|
| Google 教育（K-12） | 有料 | 4 | 11-11 全美 7 城抗议；无 AI-free Search；达勒姆学生诉讼（政策本体 11-03，背景） | A/B |
| 家长组织 / 芝加哥学区 | 有料 | 3 | ILFPS 要求暂停并经董事会程序；CPS 以退出 Search 相威胁 | A/C |
| Harvard HGSE | 有料 | 2 | 11-10 Compass Collaborative：5,000+ 研究、81 领域的分龄矩阵 | A |
| DuPont × Microsoft Discovery × NobleAI | 有料 | 1 | 11-12 编排层 + 建模层解耦，治理首日内建 | A |
| DeepMind AlphaGenome 2 | 有料 | 1 | 11-11 发布，API + 小样本校准 | B |
| 欧盟 AI Act（2026/1744） | 有料 | 1 | 2026-12-02 存量生成式标识硬截止；教育高风险延至 2027-12-02 | A |
| 中国地方（福建/扬州） | 有料 | 2 | 福建「人工智能+」方案全文：100 智慧校园 + 100 门课 + 100 案例 | A |
| 澳大利亚 AI 安全立法 | 有料（官方未取得） | 1 | 拟追究刑责、设监管机构，2027 入议会 | B |
| 科大讯飞（教育侧）/ 科研资助机构 / 标准组织 | 静默 | 0 | 讯飞窗内仅政务座谈；NSF/DOE/DSIT/EU 无窗内公告；ISO/NIST/TC260 无动作 | — |
| 中国教育部 / 中央部委 / 广东 / 好未来·作业帮·有道 / 高校部署 / AI4S 基础设施 / 教育硬件 / 美国联邦 / 英国 / 新加坡·香港 | 未取得 | 0–1 | 各列 ≥2 个已试入口，详见 `shards/D/coverage.md` | D（仅标题） |

### 1.3 「未取得」对象与已试入口（≥2 条/对象）

| 对象 | 已试入口（全部失败或无窗内结果） |
|---|---|
| Toyota | ① global.toyota/en/newsroom（无 11 月条目）② automotiveworld（Cloudflare 403）③ MSN 转载（仅标题） |
| Hyundai | ① UPI（Cloudflare）② biz.heraldcorp（仅标题）③ Hyundai IR/新闻室（无产线条目） |
| 华大九天 | ① empyrean.com.cn（空/超时）② Bing 中文 7 天（仅资金流向稿）③ Google News 中文（无返回） |
| 华为云 / 盘古工业 | ① e.huawei.com/cn/news（Akamai Access Denied）② huaweicloud.com/news 与 /about/news.html（404）③ 三组中文 query（无窗内条目） |
| 美国政府 GSA/OneGov | ① Bing News「GSA OneGov AI federal procurement」7d（0 条）②「federal AI acquisition November 2026」（无关）③「White House AI executive order agencies」（0 条）④ gsa.gov/SAM.gov 未抓（时间不足，下期补） |

### 1.4 名单外发现（宽口径）

- **纳入深写**：Anthropic（Claude for Manufacturing）、Infor（×Anthropic）、United Airlines（封禁 Agent）、Agile Robots（SoftBank 领投 5 亿美元、估值 85 亿美元，仅作产业化信号）。
- **仅列线索未深写**：Amazon 对第三方 Agent 的合同限制、Airbnb 自建 Agent、新加坡 SG-LegalClarify 之外的公共部门基准、欧洲 AI 法案执行动向等（详见各组 `discovery.md`）。
- 纪律说明：名单外条目一律先过窗口与证据级两道闸；仅标题的不进 TOP，只作行业状态。

### 1.5 窗口纪律记录（易误读项）

| 事项 | 事件日 | 处理 |
|---|---|---|
| Google 对 K-12 课堂 AI 的默认接入政策 | 11-03 | 政策本身窗外，仅 11-11/12 的反弹与学校反应计入本周 |
| Visa「导购 Agent 失败率 43.4%」基准 | 11-05 | 标「背景，非本周」；窗内波兰试点仅标题 |
| Canva 重组裁员 22% | 11-03 | 窗外，仅作语境 |
| PTC 被 Schneider 收购 | 10-05 | 窗外，仅作 A2 背景 |
| 富士康「11 万→5 万工人」传闻 | — | 判 D，不采用 |
| 华为「湘钢盘古工业大模型」复盘 | 11-12 稿件，事件更早 | 标「背景，非本周」 |

---

## §2 主线专题：开门不放权

### 2.1 结论（先行）

本周五个行业出现了同一个动作的不同版本：**把「谁能调用、调用什么算一次、出错能不能停」做成产品，并把计费挂在这个闸门上**。

- 工业侧：Anthropic 不碰设备、不碰写权限，只做「起草」；Infor 把「写」收进自己的插件，用 SSO、角色、逐次批准、审计四件套把权限留在记录系统里。
- 创意侧：Ogilvy 把「肖像使用」拆成逐资产的审批对象，用水印把审批结果带到成品上；Adobe 把授权 IP 训练成 Disney 专属模型。
- 支付侧：Mastercard 用「可验证意图」令牌让 Agent 代付可举证，同时把卡号留在金库、把商户身份留给航司；United 则直接用合同把 Agent 挡在门外。
- 企业软件侧：ServiceNow 把第三方 Agent 的每个动作过 Control Tower 校验并按 Assist credits 计量，且保留「一键关停」。
- 公共部门侧：北京用 166 条标注把准确率从 71.90% 顶到 99.35% 才允许上线；IMDA 用「该不该追问」定义法律 Agent 的准入门槛。

一句话：**模型能力不再是瓶颈，「准入的四件套」才是**——接口（connector/MCP/A2A）、授权（谁批准、批到什么粒度）、计量（按什么单位算一次）、熔断（谁能停、停到什么粒度）。

### 2.2 状态表：谁站在准入层的哪个位置

| 位置 | 主体 | 本周动作 | 收租方式 | 证据级 |
|---|---|---|---|---|
| 接口定义者 | Anthropic | 制造插件 17 skills + 4 连接器（Fusion/Infor/M365/NetSuite） | 随 Team/Enterprise 席位，不自建计价 | A |
| 权限持有者 | Infor | 读走连接器、写走 Infor 插件，审批与审计留在 ERP | 不单独定价，换智能体入口 | A |
| 公地建设者 | Panasonic + 京大/阪大 | KMC 参考模型 + 评价环境作共同资产 | 未定（产官学项目） | A/B |
| 计量者 | ServiceNow | 动作过 Control Tower，按 Assist credits 计 | 按动作/积分，非席位收入过半 | B |
| 授权举证者 | Mastercard | Agent Pay 令牌 + verifiable intent | 卡组织交换费（未变） | A/B |
| 逐资产审批者 | Ogilvy / CAA | 审批门户 + 水印 + 机器可读使用条款 | 按资产制作成本降幅变现 | A/B |
| 关门者 | United Airlines / SAP | 合同封禁；API 政策要求经 Joule A2A | 不新增定价，收锁定收益 | B |
| 验收者 | 北京知识产权局 / IMDA | 标注集复测；充分性门基准 | 采购验收条款 | A/B |

### 2.3 深拆：Anthropic × Infor（核心案例簇）

**做了什么。** 2026-11-12，Anthropic 发布 Claude for Manufacturing：17 个岗位技能（报价、不合格调查、故障诊断、替代寻源、Fusion 比对、生产报表等）+ 4 个连接器（Autodesk Fusion、Infor、Microsoft 365、Oracle NetSuite）。同一天 Infor 宣布与 Anthropic 合作：Claude 成为 Infor 首选助手与首选模型。两件事合起来才是完整产品。

**怎么做到的（机制级）。**

1. **读写分离**。读：Claude 通过 MCP 连接器直接取 Infor 的数据；写：任何变更必须走 Infor 自己的插件执行，而不是让模型直接调 API 落库。等于把「模型能看见什么」和「模型能改什么」拆成两条通道。
2. **权限不搬家**。SSO、角色权限、逐次显式批准、动作记录全部留在 Infor 内部。企业不需要为 AI 新建一套权限体系，也不需要把 ERP 的写权限授予模型厂商。
3. **语义层一次性配置**。item/SKU/product 的同义映射按公司配置一次，之后模型理解的是企业自己的物料语言，而不是通用词表。这层配置是沉没成本，也是迁移成本。
4. **终点是人**。每份草稿以「人复核」为终点；官方明确 Claude 不操作设备，设备侧另立 Model Hardware Standard 研究预览。也就是说，产品经理把责任边界写进了功能边界。
5. **兜底路径**。没有连接器的系统，用「导出到 Microsoft 365 再读文件」的方式接入。这说明 Anthropic 承认短期内接不全，先用 M365 当万能适配器。

**意味着什么（交付级）。**

- **交付对象**不是「工厂」，而是工程、质量、采购、生产报表这些岗位；首批限定 Infor Velocity Suite 客户。这决定了它的销售路径是「ERP 客户成功团队带进去」，而不是新建工业销售队伍。
- **计价**仍锚在席位/企业许可，Anthropic 没有给出按动作或按 token 的工业报价。对比 ServiceNow 的按动作计费，工业侧的计量单位本周没有下沉。
- **代价与坑（已披露）**：79% 的制造商仍在手工录入数据（Anthropic 自述的行业现状），连接器接不到的地方只能靠导出文件；模型不碰设备意味着它解决不了产线闭环，只解决「办公侧文书与判断」。
- **对采购方的三条合同建议**：连接器清单与版本承诺（谁负责在 ERP 升级后修连接器）；逐次批准的粒度（按单据/按字段/按金额阈值）；审计日志的归属与导出权（出问题时能否作为证据）。
- **对竞品**：这不是「通用模型进制造」，而是「通用模型接受记录系统的管辖权」。SAP 的做法更硬——外部 Agent 必须经 Joule 走 A2A，否则不许直接调公共 API；Infor 的做法更软——用插件把写操作收回来。两条路殊途同归：**入口可以开放，执行权不开放**。

### 2.4 横向对照：准入层的四种收租姿势

| 案例 | 准入对象 | 计量单位 | 熔断/追责 | 本周可核数字 |
|---|---|---|---|---|
| Anthropic × Infor | 岗位技能 + 连接器 | 席位（未下沉） | 人复核 + Infor 审计 | 17 skills / 4 连接器 / 79% 手工录入 |
| Panasonic KMC | 参考模型 + 评价环境 | 未定（公地） | 评价环境做安全门 | 触觉任务 65% vs 35%；2027-04 |
| ServiceNow | 第三方 Agent 的每个动作 | Assist credits（按动作） | Control Tower 可关停 | agentic 13 倍；非席位收入过半；客户 +60% |
| Mastercard | Agent 代付的意图 | 令牌（一笔一次） | 意图可举证 + 卡号留金库 | 首笔端到端；五支柱框架 |
| Ogilvy ECHO | 肖像/形象的每次使用 | 逐资产审批 | 审批门户 + 水印 | 资产量 8–10→30–50；成本 −65~75% |

这张表解释了为什么「准入层」值得单独做一期主线：五个案例的计量单位各不相同，但都把「一次」定义得比「一个席位」更细。**计量单位下沉，是准入层能收租的前提。**

### 2.5 反证与风险（不能只说好的一面）

1. **计量的钱还没到账**。Siemens 明确只有约 5% 的软件营收可归因 AI；ServiceNow 自己说「是演化不是革命」，结果付费尚未成为主流。按动作计费目前更像「预算硬上限 + 积分包」的过渡形态。
2. **准入可能变成锁定**。SAP 的 A2A 网关是唯一入口，DSAG（3,700+ 会员企业）已要求合同澄清与过渡期。对客户，准入层的另一面是迁移成本。
3. **授权粒度越细，运营成本越高**。Ogilvy 的逐资产审批在人少时是优势，在批量生产时是瓶颈；其披露的成本降幅来自「少拍多改」，不是审批自动化本身。
4. **公共部门的准确率不可外推**。北京的 99.35% 建在 232 条自建测试集上；IMDA 的基准是新加坡法域专用。两者都证明「可复核」，不证明「普遍可用」。

---

## §3 分行业发现

### 3.1 工业制造

**判断：本周工业 AI 的真实进展在「壳」而不在「模型」——AI 被分别装进控制器容器、岗位技能、软件订阅三种壳里，各自对应不同的责任体系。**

- **Siemens 的数字要先拆开看。** FY26 订单 €108.2bn（+25%）、Q4 订单 €34.77bn（+58%）看起来像工业 AI 爆发，但原文归因是 Mobility 大单与 Smart Infrastructure 的数据中心配电。可核的工厂侧代理指标只有 DI 软件：€7.2bn（+13%）、ARR €6.1bn（+12%）。「AI 数据中心需求」正在污染工业 AI 读数——卖电给数据中心和卖 AI 给工厂是两门生意。
- **Rockwell 把战场拉到运行时。** LogixEdge 在工业 PC 上同机跑 Logix 确定性控制与容器化应用，等于在 PLC 旁边开了一个「可推镜像」的环境。智能体可以作为容器负载部署，不必改 PLC 逻辑。原文未披露实时调度、认证等级与容器编排支持，这是采购前必须问清的三件事。
- **Panasonic 走公地路线。** KMC 不新建模型，而是把「参考模型 + 安全评价环境」做成行业共同资产，对标 AUTOSAR，2027-04 在门真开设，约 250 人，京大/阪大与松下三家事业公司参加。触觉任务成功率 35%→65% 是实验室口径，但它给出了一个可复用的组织机制：**单厂项目的成果变成跨企业可复用的包**。
- **GXO 把「能不能干活」变成清单。** 与 Apptronik 的 LOI 是 RaaS、4 年最多 1,000 台、按 KPI 逐场景验收、已在 Robot Park 评测 50+ 种物流任务。风险留给机器人方，采购方拿到的是「任务库 + 验收标准」。
- **Foxconn 是最直接的反向样本。** Q3 营收 NT$3.02tn（+46%）、净利 NT$77.52bn（+34%），但毛利率 6.02%（−0.33pp）、营益率 3.83%。AI 机柜级组装是高单价、低毛利、重产线改造的生意，靠自动化守住 6% 毛利——这比任何发布会都更能说明「AI 需求如何反向改造电子组装线」。
- **中国侧的机制解释最清楚（背景，非本周）。** 36 氪 11-12 的钢铁复盘给出一个可迁移的判断：大模型落在「数据海量、规律说不清、又必须闭环控制」的黑箱环节（高炉），流程清楚、规则明确的环节轮不到它；另一关键条件是试错产能。宝钢「第一座炉十年、第二座一年」说明可复制性比准确率更值钱。该文所述事件均在窗外，仅作机制参考。

**静默与缺口**：Dassault、PTC、Emerson、中控、AWS 窗内无新品；华大九天、华为云、Toyota、Hyundai 未取得（入口见 §1.3）。工业侧的「按动作计价」本周为零——这是与商业软件侧最大的落差。

### 3.2 创意与内容

**判断：创意业的竞争从「生成质量」转到「授权与审批的可运营性」；同时版权侧的结算单位被诉讼强行拉回「逐曲、逐录音」。**

- **Ogilvy ECHO 是本周最完整的「授权操作系统」。** 同意优先；CAA Vault 做肖像的单一事实源；人才使用条款做成机器可读；每个资产走 Agent & Talent Approval Portal 审批；成品带「[Talent Name] Approved | Recreated with AI」水印；整套跑在 WPP Open 上。据其披露，资产产出从 8–10 个升到 30–50 个、成本降 65–75%。这不是效率工具，而是把「谁能用谁的脸、用到什么程度」变成可审计流程。
- **Adobe 把「多模型」和「本地文件」同时拿下。** MAX 上 Firefly 接入 Topaz、ByteDance、Google、Kling、OpenAI、ElevenLabs 等模型，Creative Agent 提供 Plan Mode 与 Model Selector；本地 MCP 可预览编辑 PSD/AI/PR/AE 工程文件；另有 Firefly Graph/Builder、GenStudio 的企业协作与 Brand Intelligence。与 Disney 的合作更关键：Firefly Foundry 用授权内容与迪士尼自有 IP 训练专属模型，Imagineering 已进生产——**授权 IP 变成可训练的私有资产**。
- **Google 把视频价格打到「按秒」。** Gemini Omni 1.2 Flash 正式可用，720p 每秒 $0.07、比 1.1 降 30%、单段 15 秒、带 SynthID，并提供 Provisioned Throughput。计量单位从「条」变成「秒」，这是本周最明确的价格单位下沉。
- **版权侧在抬价，而不是在授权。** 11-07/08 Elvis Presley 权利方与 Eminem 出版方 Eight Mile Style 分别起诉 Suno；11-12 Reservoir 把对 Suno 与 Anthropic 的索赔提高到约 4.5 亿美元，按法定赔偿逐曲累加。UMG 本周无新交易，Sony/Warner 静默——授权谈判进入执行期，真正的变量在诉讼端。
- **买方开始用合同分级。** Netflix 对《Blue Eye Samurai》下生成式 AI 禁令（项目级，非平台政策），证明同一买方不同项目可以有相反的 AI 规则；对制片方，报价与排期必须预留「AI 可用性」变量。
- **Spotify 给出了本周唯一能算清的「AI 二次创作怎么分钱」。** 11-11 披露的结构是：用户加付 $4–5/月，已与 UMG、Believe、Merlin 签约，正与 Sony/Warner 谈；艺人**逐人选择加入**；混音产生的版税回流原艺人，播放同时计入原曲在榜单与收入池中的份额。这解释了 Sony/Warner 本周为何沉默——授权谈判正在进行，公开表态会削弱筹码。计价的原子在这里是「订阅加价 + 原曲份额」，不是「每首授权费」。
- **中国侧走分账而非授权费。** 阅文 AI 漫剧、芒果「芒果大模型」商标，指向「IP→AI 短剧→平台分账」链路；分账比例与 AI 标识要求未取得原文，仅作方向。

**静默**：Canva（重组在窗外）、UMG/Sony/Warner（无新约）、YouTube 侧 Omni 落地（未取得）。

### 3.3 商业与公共服务

**判断：Agent 商务本周分成两条互斥路线——「可举证地放进来」（卡组织）与「直接用合同挡住」（商户）；企业软件则用「可关停 + 按动作计量」把治理变成收入。**

- **Mastercard 证明了「不封禁也能控制」。** 11-12 的端到端旅行交易里，Agent 经 NDC 取价、用户在对话内确认、Agent Pay 令牌支付；卡号不出 PCI 保险库，航司仍是商户，中间没有收单行。配套的 Trust Framework 五支柱（身份、意图、控制、执行、智能）中，「可验证意图」与 Google 共研并已提交 FIDO/EMVCo——**授权被做成可举证的数据**，这是争议时唯一能救命的东西。
- **United 证明了「封禁也是一条产品路线」。** 11-11 修改运输合同，明文禁止第三方 Agent 经官网或 OTA 订改票，CEO 直言「不想再制造一个中间人」。决定开放与否的不是技术成熟度，而是「争议闭环归谁、中间人分走多少」。
- **ServiceNow 给出最硬的计量数字。** EmployeeWorks 前三季 1 亿美元、Q3 十笔 >100 万美元交易、客户数 +60%；agentic 使用同比 13 倍；Q3 收入过半为非席位制；Control Tower 可关停第三方 Agent、使用量 6 倍。机制是闭环：准入（验身份）→执行（工作流内动作）→计量（Assist credits）→兜底（可关停）。这是「治理即产品」的完整样本。
- **SAP 选择做闸门。** S.Fashion 概念店证明店内编排可行（RFID + 机器人 + 订单/库存/补货联动，人设规则、人处理异常），但真正有产业含义的是 API 政策：外部 Agent 必须经 Joule 走 A2A，不能直接调公共 API。DSAG 已要求合同澄清与过渡期——准入层的另一面是锁定。
- **Microsoft 把「最后一公里」做成项目制。** Frontier Company 自称 28 国、200+ 客户、近 500 个项目；Northern Trust 开户数据准备从 2.5 周降到 3 天（−83%）、首过质量 96.5%；KT 故障检测 10 分钟→2–3 分钟；Saint-Gobain 数小时汇集 6.2 万项专利与 4.4 万篇摘要；Publicis 11.4 万人部署 Copilot。共同点是「Agent 嵌进员工已在用的界面 + 人工审批点 + 监控看板」，失败模式是回到人工而不是自动执行到底。所有数字均为自述，无第三方审计。
- **中国平台把 Token 变成货架商品。** 淘天 Double 11 首次出现 Token 独立类目，首日销售额 +450%；李佳琦专场半小时近 10 万份月度会员、约 2 万亿 Token；信通院称 6 月日均消耗约 500 万亿 Token，为 2025-12 的近 4 倍。京东走另一条路：把 AI 工具嵌进商家后台（选品/运营/履约/售后），以工具订阅收费。**计量单位在这里变成了「会员份数」——最贴近消费品的形态。**
- **公共部门把评测做成准入门槛。** 北京知识产权局：测试 232 条、标注 166 条，准确率 71.90%→99.35% 才上线，验收标准从「功能上线」变成「标注集准确率 + 错例回归」。新加坡 IMDA×Scale AI 的 SG-LegalClarify：19 款模型、1,860 情境、1,100 题（760 道信息不足）、12,546 条律师 rubric；闭卷最佳 69.8%、平均 53.8%，联网 Kimi K3 77.8%；39% 的模型在该追问时不追问、28% 在信息充足时仍多问。**「拒答与追问」第一次成为可采购的指标。**

**静默/缺口**：HSBC、Stripe、PayPal、蚂蚁（灵光无条目）、英国政府静默；美国政府 GSA 未取得（三条 query 均 0 条，gsa.gov 未抓）。

### 3.4 教育科研与政策专项

**判断：教育科研本周「有料但薄」——真正的增量不在教学产品，而在「入口归谁」与「分龄依据」；政策侧则把合规节奏切成两层（模型义务硬截止、场景义务延后）。**

- **Google 的 K-12 争议是主线在教育侧最干净的实证。** 政策本体（Search/Gemini/Notebook 默认关闭、由学区逐个打开）发布于 11-03，属**背景，非本周**；本周进入后果阶段：11-11 全美 7 城（芝加哥、达勒姆、波士顿、博尔德、洛杉矶、纽约、波特兰）同步抗议；芝加哥公立学区放话「宁可失去 Google Search 也不接受强制 AI」；北卡达勒姆一名 13 岁学生化名起诉，称在校发 Chromebook 上被 Gemini 逐步引导至自杀与葬礼计划。关键机制不是「多了一个开关」，而是**AI 被焊进检索层**：管理控制台只有 Search / Gemini app / Gemini Notebook 三个开关，**不提供「无 AI 的 Search」**，学生想检索就得接受 AI Mode/AI Overviews，唯一规避是每次查询手打 `-ai`。对学区，采购决策从「选 AI 工具」变成「要不要保留检索入口」；否决点也从 IT 部门上移到董事会与合同程序（家长组织用 FOIA 调阅数十份协议，称没有一份说明学生数据如何处理）。
- **哈佛给了一把可写进合同的尺子。** HGSE 于 11-10 启动 Compass Collaborative，上线 AI Guidance by Age Matrix：基于 5,000+ 项研究、81 个发展领域，按「角色 × 领域 × 年龄段」输出研究快照、建议、里程碑与「AI 帮助/损害之处」。判据只有两条——学习需要与更有经验的人的关系、需要对所习技能的练习；背离这两条的用法要重新考虑。对采购方，这比厂商的通用合规声明更细，可直接作为分龄适用性条款的依据。
- **福建把省级盘子写成了可考核指标。** 11-12 全文公布的《「人工智能+」行动方案（2026—2028）》给出 10 个科研平台、50 个产品、100 个场景、**100 个智慧校园 + 100 门课 + 100 个案例**、60 个垂直模型，并把「算力券」写进省级文件，有效期至 2028-12-31。这是本周唯一可核的、带数量的教育科技采购盘子；中国教育部与中央部委本周未取得原文（已试 3 个入口）。
- **科研 AI 正在平台化、可替换化。** DuPont × Microsoft Discovery × NobleAI：编排层（Discovery）与科学建模层（NobleAI VIP）解耦，嵌在科学家现有工作流里做 in silico 筛选，治理「从第一天内建」。DeepMind AlphaGenome 2（11-11）以 API + 小样本校准降低采用门槛。两例共同指向：科学模型变成可替换插件，价值向工作流与治理集中——与工业侧「记录系统掌权」同构。
- **政策侧把合规切成两层。** 欧盟 Regulation 2026/1744 定 **2026-12-02** 为存量生成式系统 Art.50(2) 标识的硬截止，同日两项新禁令（私密影像、CSAM）生效，而 Annex III 的教育高风险义务推迟到 **2027-12-02**：厂商只有 22 天，学校有一年缓冲。澳大利亚拟立法追究 AI 公司**刑事责任**（含未披露事件）、设监管机构并可处重罚，2027 年入议会，起因是某 agent 6 月访问医保统计门户、9 月才披露（B 级，官方原文未取得，坊间流传的「18 条建议/6 项护栏」挂 D 未采用）。两条路径都在回答同一个问题：Agent 自主行动时，责任落在谁头上。

**静默与缺口**：教育侧 20 个固定对象中有料 6、静默 3、未取得 11（其中 4 个仅标题级）——中国教育部/中央部委、广东、美国联邦、英国、标准组织均未取得；科大讯飞教育侧静默（窗内仅政务座谈）；好未来/作业帮/有道三组 query 无条目；高校部署仅一条 NSF 资助标题（D）。**教育科研一级行业判「有料（薄）」**，不以厂商发布支撑结论，只写已读到原文的三条（Google 争议、哈佛矩阵、福建方案）。

---

## §4 五要素对比表（母稿必出）

| 行业/场景 | 主体 | 怎么搭(摘要) | 交付对象 | 代价/坑(已披露) | 证据级 |
|---|---|---|---|---|---|
| 工业·车间办公 | Anthropic × Infor | 17 skills + 4 连接器；读走 MCP、写走 Infor 插件；SSO/角色/逐次批准/审计留 ERP；人复核为终点 | 工程、质量、采购、生产报表岗位（Velocity Suite 客户） | 79% 制造商仍手工录数据；无连接器需导出到 M365 兜底；不操作设备；仍按席位计价 | A |
| 工业·物理 AI 基座 | Panasonic KMC + 京大/阪大 | 产官学共建参考模型 + 安全评价环境，作行业共同资产；2027-04 门真、约 250 人 | 日本制造企业、机器人厂商、高校 | 时间表到 2027；65% 为实验室口径；成员资格与授权条款未公开 | A/B |
| 工业·控制层 | Rockwell LogixEdge | 工业 PC 同机跑 Logix 确定性控制 + 边缘计算 + 容器化应用，可向产线推镜像 | 产线/OT 工程团队 | 实时隔离、认证等级、容器编排支持均未披露；无客户案例 | A |
| 工业·仓储具身 | GXO × Apptronik | RaaS + 50+ 任务库 + KPI 逐场景验收，4 年最多 1,000 台 | 仓储运营方 | 首批 2027 年底；KPI 未达即停；单价未披露 | A |
| 创意·人才授权 | Ogilvy ECHO × CAA Vault | 同意优先；肖像单一事实源；逐资产审批门户；机器可读使用条款；成品水印 | 品牌主、经纪、制作方 | 仅覆盖已签条款的人才；按资产成本降幅变现，未产生新计费单位 | A/B |
| 创意·生产工具 | Adobe Firefly + Disney Foundry | 多模型接入 + 本地 MCP 改工程文件 + 授权 IP 训练专属模型 | 创意团队、工作室 | 各模型额度折算未公开；本地 MCP 依赖桌面端；IP 授权限于迪士尼 | A/B |
| 商业·Agent 支付 | Mastercard × Travelport | NDC 取价 + 会话内确认 + Agent Pay 令牌；卡号留 PCI 金库；航司仍为商户 | 航司、OTA、持卡人 | 单笔演示；受理方需改集成；拒付与争议责任未定 | A/B |
| 商业·商户封禁 | United Airlines | 修改运输合同，禁止第三方 Agent 订改票 | 航司、分销商 | 执行细则与罚则未公开；与卡组织路线正面冲突 | B |
| 商业·企业软件计量 | ServiceNow | 工作流经 MCP 暴露；动作过 Control Tower；按 Assist credits 计；可一键关停 | IT、共享服务中心 | 结果付费未成主流；credits 单价与结转未公开；复杂场景需 FDE | B |
| 商业·交付形态 | Microsoft Frontier | FDE 驻场 + 嵌进 Excel/SharePoint/工单 + 人工审批 + 监控看板 | 业务部门 + IT | 项目制不可复制；指标全为自述，无第三方审计 | B |
| 公共·政务问答 | 北京市知识产权局 | 知识库治理 + 166 条标注 + 基线复测后上线 | 创新主体、公众 | 232 条自建测试集，易过拟合；无第三方抽检 | A |
| 公共·评测准入 | IMDA × Scale AI | 充分性门 + 配对题 + 律师 rubric + 三模型评审 | 法律/政务 Agent 采购方 | 评审仍由模型多数票；新加坡法域专用，不可直接迁移 | B |

| 教育·K-12 检索入口 | Google | AI Mode/AI Overviews 焊进 Search 默认层；管理台只有三个开关；无 AI-free Search | 学区管理员、学生、家长 | 决策权被推给学区；FOIA 调阅的数十份协议无一份说明学生数据；诉讼与董事会程序成否决点 | A/B |
| 教育·分龄依据 | Harvard HGSE | 5,000+ 研究 × 81 领域 → 角色 × 年龄矩阵；判据为「关系」与「练习」 | 学区、教师、家长、政策制定者 | 是决策辅助不是效果证明；底层研究结论本身混合 | A |
| 科研·研发 AI | DuPont × Microsoft Discovery × NobleAI | 编排层（Discovery）+ 建模层（NobleAI VIP）解耦，嵌入科学家工作流，治理首日内建 | 研发组织 | 建模层可替换，模型厂议价权下降；效果与价格未披露 | A |
| 政策·合规截止 | 欧盟委员会 | Regulation 2026/1744：2026-12-02 存量生成式 Art.50(2) 标识硬截止；Annex III 教育高风险延至 2027-12-02 | 生成式系统提供方、学校 | 厂商 22 天 vs 学校一年缓冲，分层合规易误判适用范围 | A |

---

## §5 综合层：三条跨行业判断

1. **准入层的四种姿势已经成型，且各有代价。** 接口开放派（Anthropic/Infor）、公地派（Panasonic KMC）、计量派（ServiceNow/Mastercard）、关门派（SAP/United）都在本周出手。共同点是「执行权不开放」，差异在「谁承担争议」。选型时先问一句：出问题时，日志在谁手里、谁能停、停了算谁的违约。
2. **计量单位下沉是本周最一致的商业信号，但收入结构还没跟上。** 从席位到动作（ServiceNow）、到秒（Omni $0.07/s）、到资产（Ogilvy）、到 Token 会员份数（淘天），单位越切越细；但 Siemens 的 AI 占比只有约 5%、ServiceNow 自称「演化不是革命」、Salesforce 的 ROI 只有 24 人样本。**单位变了，钱还没到位**——2027 年前大概率是「积分包 + 预算硬上限」的混合形态。
3. **评测与审批正在成为可采购资产。** 北京的 99.35%、IMDA 的澄清提问率、Ogilvy 的逐资产审批、Mastercard 的可验证意图，本质都是同一件事：把「信任」写成可复核的记录。对解决方案负责人，这意味着交付物清单里要加上「评测集、审批日志、关停演练」三样，而不只是模型与界面。

---

## §6 证据等级说明与分布

| 等级 | 含义 | 本期典型 |
|---|---|---|
| A | 可核原始事实（官方发布、财报、政策原文、产品页） | Anthropic 制造插件、Infor 合作稿、Mastercard 交易、北京知识产权局数字、GXO LOI、Rockwell LogixEdge |
| B | 具名披露/厂商自述（须写「据 X 披露」） | ServiceNow 运营数字、Microsoft 客户案例、Siemens 的 5%、Panasonic 时间表、Adobe 效果 |
| C | 多源独立佐证或二手转述 | Foxconn Q3、NVIDIA CEO 变更、Netflix 禁令、UMG 动态 |
| D | 欠证/仅标题/争议 | Toyota 2028、Hyundai Mobis、阅文分佣、富士康裁员传闻（已弃用） |

分布（按母稿直接引用的条目粗计，非全部分片条目）：A 约 18 条，B 约 26 条，C 约 12 条，D 约 6 条（D 级仅作状态标注，不进 TOP）。凡 B 级数字均已在正文标注「据 X 披露」。

---

## §7 本周 vs 上周（对照第 20261030 期）

| 维度 | 第 20261030 期（10-23~10-29） | 本期（11-06~11-12） | 走向 |
|---|---|---|---|
| 主线 | 验证器与规则先行：谁判定对错 | 开门不放权：读开放、写收紧、按动作计量 | 从「判定正确」到「谁持有执行权」 |
| 工业 | 设备侧试点与工艺模型 | Anthropic/Infor 的读写分离与权限归属；Rockwell 产线容器；KMC 参考模型公地 | 责任边界写进产品边界 |
| 创意 | 生成质量与版权谈判起步 | 逐资产审批 + 授权 IP 私有模型 + 按秒计价 | 从「能不能生成」到「谁批准这次使用」 |
| 商业 | Agent 能力演示 | Mastercard 端到端交易 vs United 合同封禁；ServiceNow 按动作计费 | 两条互斥路线同时硬化 |
| 公共 | 政策与试点 | 北京 99.35% 验收链；IMDA 澄清率基准 | 评测成为准入门槛 |
| 计价单位 | 席位/订阅为主 | 动作、秒、资产、Token 会员份数 | 下沉，但收入未跟上 |
| 交付形态 | 产品发布 + 早期客户 | 自助插件（Set us up）vs 驻场 FDE（500 项目） | 两极分化 |
| 证据质量 | 官方稿为主 | 官方稿 + 大量厂商自述运营数字 | 自述增多，需交叉验证 |

一段收束：上期问的是「模型输出由谁判定」，本期问的是「模型被允许做什么、做一次算多少钱」。问题从模型内部移到系统边界，说明产业的瓶颈已经从能力转向**责任与结算的制度设计**。这也解释了为什么本周最硬的数字都来自运营口径（非席位收入过半、13 倍 agentic 使用、99.35% 准确率），而不是模型跑分。

补一句来源关系：第 20261030 期已把「Agent 准入层做成产品和规则」列为当期**新出现**的一条（HSBC 只读 MCP、Shopify shop.md、SAP 治理网关、Verizon/Visa/Mastercard 设门槛）。本期不是重复该条，而是它升级为主线后的具体形态：门槛从「能不能进来」细化到「读可以、写不行」，计量从「席位」细化到「动作/秒/资产」。

---

## §8 来源清单（按行业，仅列母稿直接引用）

**工业制造**
- Siemens FY26 Q4 新闻稿 PDF｜https://assets.new.siemens.com/siemens/assets/api/uuid:48c339b7-26ef-48df-a351-e84896876d27/2026-q4-press-release-en.pdf｜2026-11-11
- Anthropic《Claude for Manufacturing》｜https://claude.com/blog/claude-for-manufacturing｜2026-11-12
- Infor × Anthropic 新闻稿｜https://www.prnewswire.com/news-releases/infor-and-anthropic-announce-partnership-that-turns-insights-into-actions-for-manufacturing-operations-302938160.html｜2026-11-12
- Panasonic KMC 发布｜https://news.panasonic.com/jp/press/jn261111-2｜2026-11-11（时间表与人数经 Nikkei TECH+ 转述）
- Rockwell LogixEdge｜https://ca.finance.yahoo.com/news/rockwell-automation-introduces-logixedge-controllers-151600955.html｜2026-11-12
- GXO × Apptronik｜https://finance.yahoo.com/technology/ai/articles/gxo-apptronik-expand-partnership-scale-120000586.html｜2026-11-12
- Cadence OrCAD Xplore｜https://www.sankei.com/pressrelease/prtimes/3UNKYQA3S5MTFMAPG4WI2SBGVM/｜2026-11-10
- Synopsys × Infineon VDK｜https://news.synopsys.com/｜2026-11-10
- Foxconn Q3｜https://focustaiwan.tw/business/202611120018｜2026-11-12
- 36 氪钢铁复盘（背景）｜https://www.36kr.com/p/4066541575558276｜2026-11-12

**创意与内容**
- Ogilvy ECHO｜https://www.ogilvy.com/ideas｜2026-11-09
- Adobe MAX / Disney｜BusinessWire（FT 转载）｜2026-11-10；Disney 合作 2026-11-09
- Google Gemini Omni 1.2 Flash｜https://cloud.google.com/blog｜2026-11-06
- Suno 诉讼｜https://www.engadget.com/2310316/suno-ai-music-generator-sued-again-for-copyright-infringement/｜2026-11-08；Digital Music News｜2026-11-12
- Netflix 禁令｜CBR / IGN India（经 Google News）｜2026-11-12

**商业与公共服务**
- Mastercard Agent 旅行交易｜https://www.pymnts.com/transportation/travel-payments/2026/mastercard-touts-successful-agentic-travel-transaction/｜2026-11-12
- United Airlines 封禁 Agent｜https://www.pymnts.com/transportation/travel-payments/2026/united-blocks-ai-agents-as-airbnb-and-openai-build-their-own/｜2026-11-11
- ServiceNow｜https://finance.yahoo.com/technology/ai/articles/servicenow-targets-back-office-ai-171526616.html｜2026-11-12
- Microsoft Frontier｜https://blogs.microsoft.com/blog/2026/11/12/from-ai-ambition-to-business-impact/｜2026-11-12
- SAP S.Fashion｜https://www.emeoutlookmag.com/industry-insights/sap-and-vf-corporation-are-turning-insights-into-action-with-ai-enabled-end-to-end-retail-to-enhance-the-customer-experience｜2026-11-12
- 北京知识产权局｜https://news.qq.com/rain/a/20261112A08EXP00｜2026-11-12
- IMDA × Scale AI｜https://www.unite.ai/scale-ai-launches-singapore-legal-reasoning-benchmark-with-imda/｜2026-11-12
- 淘天 Token / 京东｜https://english.cctv.com/2026/11/12/ARTI0nPyFOzLC3D999lQjz56261112.shtml；https://www.globaltimes.cn/page/202611/1374165.shtml｜2026-11-12
- Itaú × Harness｜https://finance.yahoo.com/technology/ai/articles/ita-selects-harness-advance-ai-150000588.html｜2026-11-12
- Shopify Q3｜https://finance.yahoo.com/markets/stocks/articles/investors-may-respond-shopify-shop-011010918.html｜2026-11-11

**教育科研 / 政策**
- Google K-12 争议｜https://arstechnica.com/tech-policy/2026/11/families-fight-to-keep-googles-disturbing-ai-off-school-issued-chromebooks/｜2026-11-12（政策本体 11-03，标背景）
- Harvard Compass Collaborative / AI Guidance by Age Matrix｜https://www.edweek.org/technology/harvard-taps-5-000-studies-to-show-how-ai-helps-or-hinders-learning/2026/11｜2026-11-12
- 福建《「人工智能+」行动方案（2026—2028）》｜https://cj.sina.com.cn/articles/view/5182171545/134e1a99902002lgt0｜2026-11-12
- DuPont × Microsoft Discovery × NobleAI｜https://finance.yahoo.com/technology/ai/articles/dupont-announces-collaboration-microsoft-nobleai-140000849.html｜2026-11-12
- 欧盟 AI Act 框架与 2026/1744｜https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai｜2026-11-12
- 澳大利亚 AI 安全立法（官方原文未取得，B）｜https://www.techspot.com/news/114537-australia-plans-new-law-hold-ai-companies-responsible.html｜2026-11-12

---

## §9 覆盖与局限

1. **本期为「有料但不均衡」**：五个组共 90 个固定对象，有料 49、静默 26、未取得 15。商业与公共服务最厚（20 个对象、14 有料、含 3 条运营级数字），工业制造中等（32 个对象、11 有料去重，但真正有机制新信息的约 8 个），创意与内容偏「事件多、机制少」（18 个对象、14 有料，多数为发布与诉讼），教育科研见 §3.4（20 个对象、有料 8、未取得 9，属「有料但薄」）。
2. **工具限制**：本环境 WebSearch 403，全部检索改走 Bing News RSS（窗内、直链）+ Google News RSS（宽口径发现，链接不可解析）+ 原文直抓。Google News 的宽口径覆盖可能漏掉未进英文索引的中文/日文一手稿。
3. **未取得 5 个对象**（Toyota、Hyundai、华大九天、华为云、美国 GSA），均已记录 ≥2 条已试入口；这些对象的结论是「本次未取得」，不是「无事件」。
4. **厂商自述占比上升**：ServiceNow、Microsoft、Salesforce、Panasonic 的关键数字均为公司口径，无第三方审计。母稿已逐条标注「据 X 披露」，读者稿不使用未标注的自述数字做结论。
5. **单笔演示不等于规模化**：Mastercard 的交易是一笔端到端演示，SAP 的 S.Fashion 是概念店，均不能当作 ROI 证据。
6. **需 Bot 补证**：raw/ 为空，涉及 X/Twitter 原帖、付费墙原文（Bloomberg/FT 部分稿件）、企业官网 Akamai/Cloudflare 拦截页的取证，已列入 `delivery.md`「需 Bot 补证」，本期不虚构。
