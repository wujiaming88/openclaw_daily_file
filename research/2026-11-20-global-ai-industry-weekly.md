# 全球 AI+产业研究周报 · 第 20261120 期（母稿·冻结）

- 运行日：2026-11-20（周五，Asia/Shanghai）
- 观察窗口：**2026-11-13 00:00 → 2026-11-19 24:00**（上周五 00:00 → 本周四 24:00）。全文「本周」仅指该窗口。
- 期号：第 20261120 期；周环比对照第 20261113 期（窗口 2026-11-06~11-12，主线「开门不放权」）。
- 缺期说明：第 20261106 期未完成，本期不补做、不改窗口、不改期号；涉及该窗口的事项一律标「补登/上期未刊，非本周」。
- 读者：行业解决方案负责人 / 产业观察者（主责 R2，协同 R3）。研究「AI 如何落入各行各业」，不以大模型公司本身为研究对象。
- 范围：工业制造、创意与内容、商业与公共服务、教育科研四个一级行业；地域以中美（含香港）为主，兼顾新马/东南亚/欧洲、印度。

---

## §0 一句话结论

**上周把门关上了（读可以、写不行）；本周开始放行写入，但放行的条件从「信谁」换成了「验什么」。**

工业侧，Siemens 让 agent 在 TIA Portal 里直接生成 PLC 代码、HMI 与设备组态，代价是把工程资产先做成 AI 可读的文本、并由人负责最终部署；商业侧，AWS 给 agent 开出「带预算上限的支付会话」，用签名报价与 5 分钟令牌把「能花多少、向谁花」写成系统约束；创意侧，Canva 给生成式 AI 装上关闭开关，UMG 直接把「kill switch」说出口；教育侧，纽约、洛杉矶、芝加哥三大学区因为「搜索不能不带 AI」而公开考虑弃用 Google。

一句话：**买方不再问「你有没有 AI」，而是问「能不能只开一半、关掉之后还剩什么、出错时谁的日志能当证据」。**

据此选定本期主线专题：**可验收的放行——写权限怎么交出去，验收怎么留下来**。核心案例簇为 Siemens（TIA Portal V21.1 + Simatic AX + Eigen，11-17/18/19），横向对照 Rockwell FactoryTalk Conductor（11-18）、AWS AgentCore（11-19）、Visa Agentic Ready（11-17/19）、Canva（11-19）与三大学区（11-18/19）。

---

## §0.1 本期 TOP5（母稿锚点，均窗内）

| # | 日期 | 主体 | 事实（摘要） | 机制（一句话） | 证据级 | 一手来源 |
|---|---|---|---|---|---|---|
| 1 | 11-17/18/19 | Siemens（+Rockwell 同周） | Eigen 在印度 16 家客户试点后上市，可写 PLC/HMI/组态，人负责最终部署；TIA Portal V21.1 把工程内容文本化并覆盖硬件组态、安装与许可解耦 | 先让工程资产可被机器读写（文本化+连续版本），再让 agent 在里面生成并按基准自校验 | A/B | https://press.siemens.com/global/en/pressrelease/continuous-access-new-software-siemens-ends-project-upgrades-tia-portal-within-v21 |
| 2 | 11-19 | AWS | AgentCore 让 agent 用 x402 在 Marketplace 买软件：签名报价、5 分钟令牌、预算会话、角色分离、CloudTrail | 把「花钱权限」拆成预算+报价+短时令牌+角色+审计五件套 | A/B | https://www.unite.ai/aws-lets-agentcore-agents-buy-marketplace-products-through-aws-billing/ |
| 3 | 11-17/19 | Visa（+Mastercard×Ant） | Agentic Ready 扩到受理侧：140+ 参与方、175+ 发卡行/45 市场；Mastercard×Ant 在亚太跑「已验证消费者指令」与 AP4M | agent 支付的关键从发卡侧移到受理侧的「识别与鉴权」 | A/B | https://www.thecanadianpressnews.ca/businesswire_press_releases/correcting-and-replacing-visa-expands-agentic-ready-to-help-scale-trusted-ai-commerce-globally/article_0995aafc-e1e9-5311-aa51-f4c42ceae3fb.html |
| 4 | 11-18/19 | 纽约/洛杉矶/芝加哥学区 vs Google | 三大学区公开考虑弃用 Google 搜索；LAUSD 已关 AI Overviews，CIO 称可一夜更换默认引擎 | 搜索与 AI 概览共用入口，学区要「只买检索」的 SKU，买不到就用采购退出 | A/B | https://www.nbcnewyork.com/news/local/nyc-department-of-education-considers-dropping-google-from-its-schools-because-of-ai/6574489/ |
| 5 | 11-19 | Canva / UMG | Canva 给生成式 AI 加关闭开关（非生成式不关）；UMG 称 68% 听众想要 kill switch | 能关的前提是先按「是否生成新内容」把功能分类 | A/B | https://www.theverge.com/ai-artificial-intelligence/1037126/canva-ai-features-off-button |

选择口径：按「是否改变交付结构、责任边界、计量单位或采购方式」排序，不按声量；每条窗内日期、证据级与一手链接可回溯到 §8 与分片。

---

## §1 发现层摘要

### 1.1 扫面结构与执行说明

| 组 | 范围 | 固定对象 | 固定对象有料 | 静默/线索（检索层） | 未取得 | 名单外纳入 |
|---|---|---|---|---|---|---|
| A1 | 工业·现场与产线 | 18 | 3 | 10 | 5 | 1 |
| A2 | 工业·工程工艺与基座 | 18 | 4 | 11 | 3 | 1 |
| B | 创意与内容 | 18 | 5（含弱 1） | 9 | 4 | 1 |
| C | 商业与公共服务 | 22 | 4 | 12 | 6 | 0 |
| D | 教育科研 + 政策 | 21 | 1 | 13 | 7 | 2 |
| 合计 | — | **97** | **17** | **55** | **25** | **5** |

**执行说明（重要）**：原计划五个子代理并行扫面，但本环境子代理均在启动阶段失联（无任何分片落盘）。按「任一组失败只重派该组一次」，主控接管全部五组：以 Bing News RSS（近 7 天窗内过滤）逐对象检索 + 原文直抓复核的方式重做，全部拟采用主张由主控本人打开原文。代价是**逐站打开官网的比例低于往期**，静默对象统一标「静默（检索层）」，不等于「无事件」。该局限已写入 §9 与 `delivery.md`。

**一级行业有料对象数（去重、含名单外纳入，供 fig1 使用）：工业制造 9｜创意与内容 6｜商业与公共服务 4｜教育科研与政策 3。**

口径＝该行业在窗内至少有一条可核条目的对象数（固定对象 + 名单外纳入），同一主体跨组不重复计（Siemens 计入工业一次；名单外纳入 5 个：工信部、OpenAI×AMD、Bona/Vidu、UNESCO–UCL、Baltimore/Omnilert）。合计 22 个有料对象。与上期的 11/14/15/8 相比整体下降，主要原因是**扫面方式从「逐站」降为「检索层」**，属覆盖问题，不据此判断行业降温。

![本周各一级行业「有料」对象数柱状图：工业制造 9、创意与内容 6、商业与公共服务 4、教育科研与政策 3](assets/images/posts/2026-11-20-ai-industry-weekly-fig1.png)

*图 1｜本周各一级行业「有料」对象数（2026-11-13~11-19）。口径：窗内至少 1 条可核条目的对象（固定名单 + 名单外纳入），同一主体不重复计，共 22 个。数据来源：本期 master.md §1.1；原始数据 `charts/data-industry-covered.csv`。*

### 1.2 覆盖表结论（明细见 `shards/*/coverage.md`）

- **工业制造（A1+A2）**：有料 7 个固定对象 + 2 个名单外（工信部、OpenAI×AMD）。核心是 Siemens 三条（TIA V21.1、Simatic AX、Eigen 印度）、Rockwell（Automation Fair + Conductor + AGILOX）、Schneider×BCG、Emerson×Databricks、AVEVA×PETROJET、PTC FedRAMP。中国侧 5 个固定对象未取得（三一/徐工、美的/海尔、中控），华为云/华大九天/卡奥斯入口失败。
- **创意与内容**：有料 6（Canva、UMG、Warner、Disney、Adobe 弱、名单外 Bona/Vidu），线索 3（Spotify、DistroKid、Suno）。YouTube、Netflix、WPP、Publicis、Sony 静默；中国平台（即梦/可灵/美图/阅文/芒果）未取得。
- **商业与公共服务**：有料 4（Visa、Mastercard、AWS、United 弱），线索 2（BigCommerce、ChatGPT Wallet）。ServiceNow、SAP、Salesforce、Shopify、Stripe、PayPal、阿里/京东/蚂蚁静默；中国政务与美国 GSA 未取得。
- **教育科研与政策**：有料 3（Google 教育/三大学区、UNESCO-UCL、Baltimore/Omnilert 名单外），补登 1（Austin ISD，11-12，非本周），线索 2（Sarasota、Anne Arundel）。中国教育部/地方、讯飞、好未来/作业帮/有道、欧盟官方文件未取得。

### 1.3 「未取得」对象与已试入口（≥2）

| 对象 | 已试入口（均失败或无窗内结果） |
|---|---|
| 三一重工 / 徐工 | ①「三一重工 人工智能 工厂」②「徐工 智能制造 AI」 |
| 美的 / 海尔 | ①「美的 智能工厂 人工智能」②「海尔 卡奥斯 人工智能」 |
| 中控技术 | ①「中控技术 工业AI」②「中控 流程工业 大模型」 |
| 华为云 / 盘古工业 | ① e.huawei.com/cn/news（Akamai 拦截，往期）② huaweicloud.com/news（404）③ 中文 query |
| 华大九天 | ①「华大九天 EDA」②「Empyrean EDA AI」 |
| 卡奥斯 | ①「卡奥斯 工业互联网 AI」②「海尔 卡奥斯」 |
| 中国平台（即梦/可灵/美图/阅文/芒果） | ① 各平台中文 query ② 行业词组合 query（窗内均无产品/客户条目） |
| 中国教育部 / 地方教委 | ①「教育部 人工智能 教育 政策」②「教育数字化 AI 文件」③「北京/广东 中小学 人工智能」 |
| 科大讯飞 / 好未来 / 作业帮 / 有道 | 各自中文 query（均无窗内条目） |
| 中国政务 / 美国 GSA | ①「北京 政务 人工智能」②「GSA AI acquisition」③「federal AI procurement」 |

### 1.4 名单外发现（宽口径，纳入深写 6 条）

- **工业**：中国工信部 34 家卓越级智能工厂（1,000+ 工业 agent、日均 3 亿 token）；OpenAI×AMD 的 RTL 改写。
- **创意**：Bona Film / 生数 Vidu 的全 AI 长片票房失败。
- **商业**：AWS AgentCore 的 agent 采购。
- **教育**：UNESCO–UCL 的反驳鲁棒性研究；巴尔的摩 Omnilert 误报诉讼。
- 仅列线索未深写：Scout Motors、Vetaion、Komatsu、Utopai、Sonilo、Sarasota/Anne Arundel 学区、AWS Marketplace 预授权采购（并入 AWS 条）。

### 1.5 窗口纪律记录（易误读项）

| 事项 | 事件日 | 处理 |
|---|---|---|
| Siemens Eigen Engineering Agent 全球发布 | 2026-04（汉诺威） | **背景，非本周**；本周只写印度上市（16 家试点）与 TIA V21.1 的 AI-ready 改造 |
| OpenAI×AMD 的 RTL 改写研究 | 11-19 披露 | 计入本周（窗内披露），效果为公司自述 |
| 巴尔的摩 Omnilert 误报事件 | 2025-10 | **本周新披露的历史事项**（诉讼与报道在 11-19） |
| Austin ISD 通过首个 AI 政策 | 11-12 | **补登/上期未刊，非本周** |
| 欧盟 AI Act 条款 | 上期已写（2026-12-02 截止等） | 本周无新官方文件，不重复、不延伸 |
| Google K-12 默认关闭政策本体 | 11-03 | **背景，非本周**；本周只写后果（学区考虑弃购） |

---

## §2 主线专题：可验收的放行

### 2.1 结论（先行）

本周五个行业出现了同一个动作的不同版本：**把「写」的权限交出去，但把「验收」留在原来的位置**。

- 工业：Siemens 让 agent 写 PLC/HMI/组态，但要求人负责最终部署，并把工程资产先做成机器可读的文本；
- 商业：AWS 让 agent 花钱买东西，但用预算会话、签名报价、5 分钟令牌与角色分离把额度锁死；
- 支付：Visa 让 agent 进受理侧，但先在 140+ 参与方里跑真实交易的识别与鉴权；
- 创意：Canva 让用户关掉生成式 AI，但先把功能分成「生成/非生成」两类；
- 教育：学区要「不带 AI 的搜索」，Google 拆不出来，学区就准备换供应商。

一句话：**放行不是信任，是把信任拆成可检查的动作。**

### 2.2 状态表：谁把「放行」做成了什么

| 位置 | 主体 | 本周动作 | 放行的单位 | 验收放在哪 | 证据级 |
|---|---|---|---|---|---|
| 工程环境 | Siemens | Eigen 印度上市（16 家）；TIA V21.1 文本化 | 一段 PLC 代码/HMI/组态 | 预设基准自校验 + 人负责最终部署 | A/B |
| 编排层 | Rockwell | FactoryTalk Conductor（2027 初） | 一个 agent 动作 | 治理与安全层、企业标准 | B |
| 预算层 | AWS | AgentCore x402 支付 | 一次请求/一个会话额度 | 签名报价、5 分钟令牌、CloudTrail | A/B |
| 受理层 | Visa | Agentic Ready 扩至受理侧 | 一笔 agent 发起的交易 | 140+ 参与方的识别与鉴权测试 | A |
| 主体层 | Mastercard×Ant | 消费者已验证指令 + AP4M | 一次授权 | 企业授权与机器支付试点 | B |
| 产品层 | Canva | 生成式 AI 开关 | 一个功能 | 生成/非生成分类 + 元数据标签 | A/B |
| 采购层 | 三大学区 | 考虑弃用 Google 搜索 | 一个 SKU（检索 vs 检索+AI） | 换默认搜索引擎 | A/B |

### 2.3 深拆：Siemens 的三块地基（核心案例簇）

**做了什么。** 三件事在同一周落地：11-17 Simatic AX 把 Motion Control 纳入文本化、Git 化的工程环境，Logic Control 全球 GA；11-18 TIA Portal V21.1 把「已安装软件」与「许可」解耦，并把 Simatic Source Documents 扩展到**硬件组态**；11-18/19 Eigen Engineering Agent 在印度上市，此前已在当地 16 家客户试点，可执行 **PLC 编码、HMI 可视化、设备组态**。

**怎么做到的（机制级）。**

1. **先文本化。** 官方明确：Source Documents 让工程内容以文本源文件提供，便于接 Git 与代码生成器，「这些文本源文件也可以被 AI 系统处理」。Simatic AX 更进一步，用文本代码、CLI 与脚本编程，官方称其产生「结构化、透明的项目数据——工业 AI 应用的基础」。**没有文本化，agent 的产出无法 diff、无法回滚、无法审计。**
2. **再连续化。** 过去每版 TIA Portal 升级都要同时更新所有已安装产品与许可，并对项目做升级与**再验证**；V21.1 把安装与许可解耦，V21 线内连续获取新版本，官方说法是「不再买版本，而是买功能」。**没有连续版本，agent 的每次产出都会被版本迁移打断。**
3. **然后才放行写入。** Eigen 在工程环境内「plan, execute, and validate」，并「迭代直到达到预设性能基准」；产品面向 60 万 TIA Portal 用户，通过既有 TIA Portal 使用。
4. **终点是人。** 印度上市报道明确「humans remain responsible for final deployment」——**人负责最终部署**。责任没有随权限一起转移。
5. **验证细节未公开。** 官方未说明是否调用 PLCSIM/Emulate3D 类仿真、有哪些规则检查、失败如何回滚、是否覆盖安全相关代码。→ **机制未取得（验证细节）**，这也是采购前必须问清的第一件事。

**意味着什么（交付级）。**

- **交付对象**是自动化工程团队与系统集成商，不是产线工人；印度侧点名 Pelican Rotoflex（印刷/软包装机械）与 Z System Intelligent Controls（PLC 代码理解/生成/验证/文档，重复工程 −50%+、生产率 +20–30%）。
- **计价**从「版本」转向「功能」；Eigen 本身是 SaaS（公司称其在已上市地区是增长最快的 SaaS 产品之一），但**未公开单价与计量单位**。
- **代价与坑（已披露）**：2–5 倍、80%、50% 均为公司口径；V21.1 发布时尚未普遍可得（11 月末下载、12 月盒装）；人负责最终部署意味着**责任仍在工程师**；安全相关代码的验证方式未披露；无第三方认证标准（本期检索未见 PLCopen/IEC 61131 相关新规）。
- **对采购方的三条合同建议**：①要求供应商说明「生成产物的验证方法」与「失败回滚」；②明确人签核的粒度（整项目/单功能块/单网络）；③约定版本连续更新期间的再验证责任归属。

### 2.4 横向对照：四种「放行」的验收位置

| 案例 | 放行对象 | 约束装置 | 验收位置 | 本周可核数字 |
|---|---|---|---|---|
| Siemens Eigen | PLC/HMI/组态 | 工程环境内生成 + 预设基准 | 人负责最终部署 | 印度 16 家试点；2–5 倍（公司口径） |
| Rockwell Conductor | agent 对 Studio 5000/Optix/Emulate3D 的操作 | 治理与安全层（2027 初） | 企业标准符合性 | 14,000 参观者、135 展商 |
| AWS AgentCore | 一次购买请求 | 预算会话 + 签名报价 + 5 分钟令牌 + 角色分离 | CloudTrail/Cost Explorer | 令牌约 5 分钟；首单生成 Marketplace 协议 |
| Visa Agentic Ready | 一笔 agent 交易 | 受理侧识别与鉴权 | 140+ 参与方真实交易测试 | 140+ 参与方、175+ 发卡行、45 市场 |
| Canva | 生成式功能 | 开关 + 生成/非生成分类 | 用户自己 | 关闭 9 类以上功能；背景移除等不关 |

这张表解释了为什么「放行」值得单独做一期主线：五个案例的放行对象各不相同，但都把**验收放在权限之外**——写的人不负责证明对，证明对的是另一套装置（基准、治理层、令牌、受理测试、用户开关）。

### 2.5 反证与风险

1. **数字全是卖方口径。** Siemens 的 2–5 倍/80%/50%、Rockwell 的「一半用户是 agent」、UMG 的 68%，均无第三方审计。
2. **验证细节缺失。** Eigen 的「按基准迭代」没有公开基准是什么、谁来定；OpenAI 的 RTL +14% 也没有硅片实测。**代码层提升 ≠ 系统层提升**。
3. **责任仍在人身上。** 「人负责最终部署」既是安全阀，也是风险转移：出错时，签字的人承担。
4. **开关可能被定义绕开。** Canva 只关「生成式」，背景移除等继续开；学区要的是「无 AI 搜索」，Google 说做不到。**「可关闭」的边界由厂商定义时，开关就是营销。**
5. **采购退出有代价。** 学区换默认搜索引擎「一夜之间」可做，但设备管理、账号体系、教师培训的迁移成本未披露。

---

## §3 分行业发现

### 3.1 工业制造

**判断：本周工业 AI 的进展全在「接口」上——不是模型更强，而是产品被改造成 agent 能读、能写、能调用的样子。**

- **Siemens 把地基打完了。**（详见 §2.3）文本化 + 连续版本 + 工程环境内生成，是「AI 写控制逻辑」的三件前置工程；Eigen 只是站在上面的产品。
- **Rockwell 把话说得最直。** Automation Fair 2026（波士顿，14,000+ 参观者、135 展商）上，Frontier Labs 副总裁 Ryan Gariepy 说：「**AI is now using our products, rather than our products having AI in them.**」FactoryTalk Conductor 被定位为「治理与安全层」，协调 agent 操作 Studio 5000 Logix Designer、FactoryTalk Optix Studio、Emulate3D，并可接 Google、Anthropic 的外部 agent；**2027 年初发布**。同周 Rockwell 宣布收购奥地利 AMR 厂商 AGILOX（AI 驱动叉车 + 群体组网），与 OTTO 合并，公司称将使 AMR 业务「不止翻倍」。
- **咨询公司成了交付通道。** Schneider Electric 与 BCG 在印度签 Exploration Agreement，用海得拉巴灯塔工厂做「Model Smart Factory」体验场；技术与供应商选择权仍归企业。对解决方案负责人，竞标对手可能是「咨询+厂商」联合体。
- **上下文层开始独立。** Emerson 把 AspenTech Inmation 的 OT 数据接进 Databricks，AVA 可在 Databricks 内调用；AVEVA 与 PETROJET 签 MoU 做「数字孪生移交」。两者都在解决同一件事：**让数据在换模型时不重做**。
- **中国给出存量规模。** 工信部 11-19 公布 34 家卓越级智能工厂（累计 49 家），称第二批 70%+ 应用场景涉 AI、已开发 **1,000+ 工业 AI agent**、**日均 token 超 3 亿**。这是本周唯一的需求侧装机口径。
- **最深的一次「写」在芯片。** OpenAI 称模型重写 SystemVerilog，使 AMD GPU IP 在已优化基线上最高提升 14%（PPA，未拆分），相当于「不到 5 个月完成约一年进展」；AMD 把部分改动放进已流片设计、部分放进未来版本，**尚无硅片实测**。

**静默与缺口**：ABB、FANUC、KUKA、Yaskawa、GXO、Amazon Robotics、Foxconn、CATL、BMW、Toyota、Hyundai 检索层无窗内 AI 条目；三一/徐工、美的/海尔、中控、华为云、华大九天、卡奥斯未取得（入口见 §1.3）。

### 3.2 创意与内容

**判断：创意业本周分成两条线——一条在装开关，一条在算账；两条都指向「AI 使用必须可计量」。**

- **Canva 给出了最干净的开关样本。** 用户可关闭 Magic Expand、图像生成、Magic Write、Magic Design、Magic Layers、Magic Edit、Dream Lab、Canva Code、AI Shapes 等生成式功能；**背景移除与 Magic Grab 不关**，理由是「让日常任务更快但不生成新内容」。另有开关让素材库优先展示人类创作内容，AI 素材带元数据标签。**能关的前提是分类**——这条对采购谈判直接可用。
- **权利方把 kill switch 说出口。** UMG 首席数字官 Michael Nash 在摩根士丹利 TMT 会议称，越来越多消费者在找「我们所说的 kill switch」；UMG 自有研究称 **68%** 听众想要关闭 AI 音乐的能力（Deezer 本周 survey 为 41%，口径不同）。
- **版税第一次进了财报叙事。** Warner Music FY26 Q4 营收 20.0 亿美元（预期 19.1 亿），全年 74.4 亿；全年调整后 OIBDA 利润率扩张 210bps；FY27 指引约 100bps（公司归因经营杠杆与成本节约）。公司称与 **Suno** 的合作为生成式 AI 公司**首次向权利方支付版税**。
- **AI 最实在的 ROI 在渲染。** Disney CEO Josh D'Amaro 在 FY Q4 电话会称，内部 AI 工具使**电影渲染算力需求下降 30%**；同时称与 Netflix 的授权协议是「smart bet」。
- **失败也被计价。** 中国首部全 AI 长片《三星堆：未来往事》（100 分钟，Bona Film，生数 Vidu 平台）三周票房约 **180 万元人民币**，据报道制作成本达数千万元，**不足以覆盖生成全片的 token 成本**；失败点在叙事连贯与付费意愿，不在生成画质。

**静默**：YouTube、Netflix、WPP/Ogilvy、Publicis、Sony Music 检索层无窗内条目；Spotify（deepfake 检测）、DistroKid（向 UMG/Sony 交出检测信息）、Suno（Visuals）仅有标题层线索。

### 3.3 商业与公共服务

**判断：agent 商务的门槛从「能不能付」移到「受理侧认不认、预算谁给、出错谁查」；三件事本周都有了工程答案。**

- **Visa 把战场移到受理侧。** Agentic Ready 从发卡机构扩到商户、PSP、收单与商务平台，首发 **140+ 参与方**（Adyen、Antom、Billtrust、Checkout.com、Fiserv、Global Payments、J.P. Morgan Payments、PayPal、Stripe），已有 **175+ 发卡机构**在 **45 个市场**参与；欧洲区 85+ 受理参与方。机制是「先在真实交易里跑识别与鉴权，再上生产」。
- **AWS 把「花钱权限」拆到最细。** AgentCore payments 走 **x402**：agent 请求 → 收到 **HTTP 402** 与**签名报价** → 预算足够才发**支付令牌**（约 5 分钟有效）→ 带签名重试取内容。约束包括每任务预算会话、核准卖家名单、Private Marketplace；**session 角色可设预算但不能付款，agent 角色可付款但不能建会话**（agent 无法给自己加预算）；记录进 CloudTrail 与 Cost Explorer。
- **Mastercard 区分授权主体。** 与 Ant International 在亚太完成两件事：通过 Antom 跑一笔**真实消费者交易**（agent 按已验证的消费者指令行动），以及在新加坡完成 **AP4M（Agent Pay for Machines）** 试点（企业如何控制与授权 agent 采购）。
- **商户侧仍在关门。** United Airlines 继续限制个人 AI agent 订票（上期合同封禁的延续，本周仅标题层）。
- **公共部门**：中国中央/北京政务、新加坡 IMDA、美国 GSA 窗内均无新条目（未取得/静默）。

### 3.4 教育科研与政策

**判断：教育侧本周把问题问到产品结构上——不是「要不要 AI」，而是「能不能只买检索」；同时，模型的「抗压性」第一次成为可测指标。**

- **三大学区考虑弃用 Google 搜索。** 起因是 Google 教育副总裁 Chris Phillips 对 NYT 称，学区禁 AI 则学生「无法使用搜索」。纽约市长指责其用垄断力量强推 AI，教育总监 Samuels 称「拒绝伪二选一」；LAUSD CIO Kelanic 称「可以一夜之间更换默认搜索引擎」，报道称 LAUSD 已关闭 AI Overviews；芝加哥表示要非 AI 版搜索，否则另寻方案。Google 员工也呼吁给学校「不带 AI 的搜索」。
- **机制**：搜索与 AI 概览共用一个入口，学区要的是**可拆分的 SKU**；杠杆不在内容过滤，而在**默认搜索引擎可替换**。这与 Canva 的开关形成对照：能拆，是因为功能可按「是否生成」分类；拆不开，是因为检索与生成被焊在一起。
- **UNESCO–UCL 给出「抗压性」数据。** 33 个模型、600 道事实题；IPCC 置信度类问题旗舰约 78%、最小开源权重约 47%；15 个模型在用户**持续反驳**后准确率下降 **30–35%**，多数在**第一轮**「我不认为这是对的」就改口；非英语下降更多（乌尔都语 −7、斯瓦希里语 −10 个百分点）；两项政策组合题的正确率不优于随机。**教学场景里，学生一质疑就改口，比答错更麻烦。**
- **误报的代价由谁承担。** 巴尔的摩县四名学生起诉学校与警方：Omnilert 把一袋多力多滋误判为枪，校方两分钟内已取消警报，警方仍到场（至少 6 辆警车、部分拔枪），学生被按跪戴铐。**事件在 2025-10（窗外），诉讼与报道在 11-19（本周新披露的历史事项）**。教训是误报后的**处置链**缺少阻断。
- **学区在批量立规。** Sarasota 11-18 通过 AI 政策（学生抗议）、Anne Arundel 在审议禁 AI；Austin ISD 11-12 通过首个 AI 政策属**上期窗口，补登**。决策权都在董事会，不在 IT。

**静默与缺口**：中国教育部/地方教委、讯飞、好未来/作业帮/有道未取得；哈佛、斯坦福、欧盟官方文件窗内无新发布。

---

## §4 五要素对比表（母稿必出）

| 行业/场景 | 主体 | 怎么搭(摘要) | 交付对象 | 代价/坑(已披露) | 证据级 |
|---|---|---|---|---|---|
| 工业·自动化工程 | Siemens（Eigen + TIA V21.1） | 工程资产文本化（Source Documents 含硬件组态）+ 安装/许可解耦 + 工程环境内生成并按基准自校验；人负责最终部署 | 自动化工程团队、系统集成商（Pelican Rotoflex、Z System） | 2–5 倍/80%/50% 为公司口径；验证细节未公开；V21.1 发布时未普遍可得；安全代码验证方式缺失 | A/B |
| 工业·编排治理 | Rockwell（FactoryTalk Conductor） | AI 原生编排层，协调 agent 操作 Studio 5000/Optix/Emulate3D，接外部 agent；定位治理与安全层 | 产线/OT 工程团队、集成商 | 2027 年初才发布；具体权限模型未公开；「一半用户是 agent」为高管预测 | B |
| 工业·交付通道 | Schneider × BCG | 以海得拉巴灯塔工厂为体验场，做 Model Smart Factory；BCG 做诊断与转型 | 印度制造企业（含中小企业） | 探索协议，无金额与排期；供应商选择权仍归企业，转化率未知 | B |
| 工业·需求侧规模 | 中国工信部（卓越级工厂） | 四级培育 + 名单；推动高质量数据集与工业 agent | 49 家卓越级工厂及地方政策 | 名单与验收细则未取得原文；1,000+ agent/3 亿 token 为部委口径 | A |
| 工业·上下文层 | Emerson × Databricks | AspenTech Inmation 的 OT 数据原生接入 Databricks，保留上下文；AVA 可在其中调用 | 流程工业、能源 | 客户可用性「forthcoming」；价格与迁移成本未披露 | B |
| 工业·芯片设计 | OpenAI × AMD | 模型重写 SystemVerilog，对已优化基线最高 +14%（PPA） | 芯片设计团队 | 未拆分 PPA；无硅片实测；发布方与受益方同一 | B |
| 创意·工具控制 | Canva | 生成式功能可关闭（9 类以上）；非生成式不关；素材库 AI 标签 | 设计团队、企业品牌方 | 开关边界由厂商定义；非生成式功能仍默认开启 | A/B |
| 创意·权利管理 | UMG / Warner | 标识 + kill switch 诉求；与 Suno 的版税合作 | 流媒体平台、艺人 | 68% 为 UMG 自有研究；版税单位与审计方式未公开 | B |
| 创意·生产 | Disney | 内部 AI 工具用于渲染管线，算力需求 −30% | 制片厂、视效团队 | 单一公司口径；对创作端影响未披露 | B |
| 创意·全 AI 制作 | Bona Film / 生数 Vidu | 全 AI 生成片段再拼接成长片 | 院线、流媒体 | 三周票房约 180 万元，未覆盖 token 成本；叙事断裂 | B/C |
| 商业·Agent 支付（受理） | Visa | Agentic Ready 扩至受理侧：识别、鉴权、走现有清算；140+ 参与方真实交易测试 | 商户、PSP、收单机构 | 仍在测试阶段；2027 年才扩量；责任与拒付规则未公开 | A |
| 商业·Agent 采购 | AWS | x402：签名报价 + 预算会话 + 5 分钟令牌 + 角色分离 + CloudTrail | 开发者、采购与财务 | 仅支持 x402 exact 方案；卖家需改造端点；预算策略需人工配置 | A/B |
| 商业·机器支付 | Mastercard × Ant | Antom 真实消费交易（已验证指令）+ AP4M 企业授权试点 | 商户、企业财务 | 试点阶段；企业授权粒度未公开 | B |
| 教育·检索入口 | 纽约/洛杉矶/芝加哥学区 vs Google | 要求「无 AI 的搜索」SKU；以更换默认搜索引擎为杠杆 | 学区、学生、家长 | 迁移成本未披露；Google 称无法拆分；合同数据条款缺失 | A/B |
| 教育·模型鲁棒性 | UNESCO–UCL | 33 模型 × 600 题 + 多轮反驳实验 + 12 语种 | 教育采购方、教师 | 气候领域专用；报告原文未取得；未覆盖教学场景实测 | B |
| 公共·校园安防 | Baltimore 县学校 / Omnilert | AI 枪械识别告警直连警方；人工复核未阻断出警 | 学区、警方 | 误报致武装出警与诉讼；联动缺二次确认（事件 2025-10） | B |

---

## §5 综合层：三条跨行业判断

1. **放行的单位越细，验收的位置越要靠外。** Siemens 把放行单位切到「一段 PLC 代码」，验收放在「预设基准 + 人签核」；AWS 切到「一次请求」，验收放在「签名报价 + 令牌 + CloudTrail」；Visa 切到「一笔交易」，验收放在「受理侧测试」。共同点是：**写的人不负责证明对**。
2. **「可关闭」正在成为可采购的功能项，但边界由卖方定义。** Canva 能关生成式、不关非生成式；学区要「无 AI 搜索」，Google 说拆不开。买方真正要的不是开关，是**可拆分的 SKU 与可审计的默认值**。谈判时要把「哪些功能必须可关、关掉后默认行为是什么」写进条款。
3. **需求侧已经有装机基数，供给侧的验收标准还没跟上。** 中国 49 家卓越级工厂、1,000+ 工业 agent、日均 3 亿 token，说明 agent 已进产线；但本周没有任何一份「AI 生成控制代码」的认证或验收规范发布（PLCopen/IEC 61131 检索无结果）。**规模跑在标准前面**，这是 2027 年前最大的落地风险。

---

## §6 证据等级说明与分布

| 等级 | 含义 | 本期典型 |
|---|---|---|
| A | 可核原始事实（官方新闻稿、BusinessWire、部委数据、产品变更原文） | Siemens TIA V21.1/Simatic AX、Visa 更正稿、工信部 34 家工厂、Canva 开关 |
| B | 具名披露/厂商自述/媒体转述（须写「据 X 披露」） | Eigen 印度 16 家试点与倍数、Rockwell Conductor、AWS x402 细节、Warner/Disney 数字、UNESCO-UCL 研究 |
| C | 仅标题/二手转述/弱信号 | Adobe Coworker、Spotify deepfake、DistroKid、BigCommerce、United 跟进 |
| D | 欠证/争议/传闻 | 未采用进正文；如「agent 安全 92%/36%」调研（样本未取得） |

分布（按母稿直接引用的条目粗计）：A 约 9 条，B 约 26 条，C 约 8 条，D 0 条（D 级仅记于分片）。凡 B 级数字均已在正文标注来源方。

---

## §7 本周 vs 上周

（三列素材见 `wow.md`；读者稿用其中 8 行主线表。）核心迁移：上期问「谁被允许做什么」，本期问「能不能只开一半、关掉之后还剩什么、出错时谁的日志能当证据」。

---

## §8 来源清单（仅列母稿直接引用）

**工业制造**
- Siemens TIA Portal V21.1｜https://press.siemens.com/global/en/pressrelease/continuous-access-new-software-siemens-ends-project-upgrades-tia-portal-within-v21｜2026-11-18
- Siemens Simatic AX MCE/LCE｜https://press.siemens.com/global/en/pressrelease/software-defined-automation-siemens-announces-major-milestone-simatic-ax-engineering｜2026-11-17
- Siemens Eigen 官方稿（背景）｜https://press.siemens.com/global/en/pressrelease/siemens-brings-ai-physical-world-eigen-engineering-agent｜2026-04
- India Today（Eigen 印度）｜https://www.indiatoday.in/technology/news/story/siemens-launches-eigen-engineering-agent-in-india-says-it-frees-up-humans-for-complex-work-3042061-2026-11-19｜2026-11-19
- Express Computer（16 家试点/客户）｜https://www.expresscomputer.in/news/siemens-asks-indian-industry-to-trust-ai-with-control-logic-and-has-16-pilots-to-back-it-up/141512/｜2026-11-19
- ControlGlobal（Automation Fair / Conductor）｜https://www.controlglobal.com/show-coverage/rockwell-automation-automation-fair/article/55420186/rockwell-automation-ai-agents-everywhere-at-rockwell-automation-fair-2026｜2026-11-18
- ControlGlobal（治理场）｜https://www.controlglobal.com/show-coverage/rockwell-automation-automation-fair/article/55420185/goals-with-guardrails-evolving-ai-and-ai-governance｜2026-11-18
- Logistics Business（AGILOX）｜https://logisticsbusiness.com/materials-handling/amr-agv/rockwell-acquire-agilox/｜2026-11-19
- The Machine Maker（Schneider×BCG）｜https://themachinemaker.com/news/schneider-electric-and-bcg-join-forces-to-accelerate-ai-driven-smart-manufacturing-in-india/｜2026-11-19
- Unite.AI（Emerson×Databricks）｜https://www.unite.ai/emerson-to-link-aspentech-inmation-with-databricks-for-industrial-ai/｜2026-11-19
- Utilities ME（AVEVA×PETROJET）｜https://www.utilities-me.com/news/aveva-and-petrojet-collaborate｜2026-11-19
- 247wallst（OpenAI×AMD）｜https://247wallst.com/investing/2026/11/19/openai-says-its-ai-improved-amds-best-chip-design-by-up-to-14/｜2026-11-19
- Xinhua（34 家卓越级工厂）｜https://english.news.cn/20261119/bf1cbae731534b8da028566abaf2a987/c.html｜2026-11-19

**创意与内容**
- The Verge（Canva 开关）｜https://www.theverge.com/ai-artificial-intelligence/1037126/canva-ai-features-off-button｜2026-11-19
- Music Ally（UMG kill switch）｜https://musically.com/2026/11/19/umg-says-68-of-listeners-want-a-kill-switch-for-ai-music/｜2026-11-19
- Yahoo Finance（WMG FY26 Q4 电话会要点）｜https://finance.yahoo.com/media-advertising/articles/warner-music-group-corp-wmg-210116140.html｜2026-11-19
- Yahoo Finance（Disney CEO 渲染 −30%）｜https://finance.yahoo.com/technology/ai/articles/disney-ceo-calls-netflix-licensing-130008863.html｜2026-11-19
- TechSpot（全 AI 长片票房）｜https://www.techspot.com/news/114616-china-first-fully-ai-generated-movie-flops-box.html｜2026-11-19

**商业与公共服务**
- BusinessWire 更正稿（Visa Agentic Ready）｜https://www.thecanadianpressnews.ca/businesswire_press_releases/correcting-and-replacing-visa-expands-agentic-ready-to-help-scale-trusted-ai-commerce-globally/article_0995aafc-e1e9-5311-aa51-f4c42ceae3fb.html｜2026-11-17
- Fintech Magazine（Visa 欧洲 85+）｜https://fintechmagazine.com/news/visa-agentic-ready-brings-ai-agents-into-european-payments｜2026-11-19
- Unite.AI（AWS AgentCore x402）｜https://www.unite.ai/aws-lets-agentcore-agents-buy-marketplace-products-through-aws-billing/｜2026-11-19
- Financial IT（Mastercard×Ant）｜https://financialit.net/news/artificial-intelligence/mastercard-and-ant-international-advance-trusted-agentic-commerce-asia｜2026-11-19

**教育科研 / 政策**
- NBC New York（NYC 学区）｜https://www.nbcnewyork.com/news/local/nyc-department-of-education-considers-dropping-google-from-its-schools-because-of-ai/6574489/｜2026-11-19
- Gizmodo（三大学区/LAUSD/芝加哥）｜https://gizmodo.com/nyc-la-and-chicago-school-districts-all-discussing-alternatives-to-ai-pilled-google-2000842174｜2026-11-19
- Ars Technica（UNESCO–UCL）｜https://arstechnica.com/science/2026/11/llms-will-provide-accurate-climate-info-except-when-they-wont/｜2026-11-19
- Ars Technica（Baltimore Omnilert）｜https://arstechnica.com/tech-policy/2026/11/traumatized-teens-sue-school-cops-after-doritos-bag-triggers-ai-gun-alert/｜2026-11-19
- Austin Chronicle（补登，非本周）｜https://www.austinchronicle.com/news/aisd-writes-ai-policy-into-the-books/｜2026-11-18

---

## §9 覆盖与局限

1. **子代理全线失联，主控接管五组。** 原计划的并行分组扫面未能执行：四个子代理在启动阶段停止响应、未落盘，第五个运行约 2.5 小时后被终止且无产出。按「失败只重派一次」，主控以「Bing News RSS 逐对象检索 + 原文直抓」重做五组。直接后果：**静默对象只做了检索层核验，未逐站打开官网**，覆盖强度低于上期。
2. **一级行业有料数下降是覆盖问题，不是行业降温。** 上期 11/14/15/8，本期 8/7/5/5；同一批对象在本期被标「静默（检索层）」，不能据此判断行业活动减少。
3. **检索工具限制**：WebSearch 在本环境不可用（子代理侧），主控改用 Bing News RSS（近 7 天、窗内过滤）+ 原文 curl 直抓；中文/日文一手稿覆盖可能不足（即梦、可灵、讯飞、好未来等均无结果）。
4. **入口拦截**：华为云（Akamai）、press.siemens.com 搜索页（JS/鉴权）、Bloomberg/NYT/SeekingAlpha（付费墙）、MSN（反爬）均未取得全文；相关条目只写已读部分或标「仅标题层」。
5. **厂商自述占比高**：Siemens 的效率倍数、Rockwell 的「一半用户是 agent」、UMG 的 68%、Warner/Disney 的财务口径均为公司自述，无第三方审计。
6. **未能回答的机制问题**：Eigen 的验证细节（是否仿真、规则检查、回滚）、Conductor 的权限模型、Visa 的拒付责任、AWS 的卖家改造清单——均已列入 `delivery.md`「需 Bot 补证」。
7. **政策原文缺口**：中国教育部/中央部委、欧盟 AI Act 窗内文件均未取得；本期不引用二手解读当条款。
