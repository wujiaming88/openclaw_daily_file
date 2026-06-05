# 全球 AI 动态周报 · 第 1 期（2026-05-24 ~ 05-30）

> **覆盖区间**　2026-05-24（周日）→ 05-30（周六）｜上海时区
> **覆盖范围**　38 个 AI 主体 · 6 大赛道 · 61 条一手来源
> 全部信息严格限定在该自然周内；窗口外动态仅作背景标注。

---

## 本周一句话

> **模型趋同，战火转移。** 前沿模型的智能差距正在收窄，竞争重心整体迁移到三条新战线——**智能体编排**（谁的 Agent 更能干）、**资本化**（谁先上市、谁估值更高）、**真实落地**（谁拿到了商单）。

---

## 🔥 本周 TOP 5

### 1. Anthropic 发布 Claude Opus 4.8 ｜ 5/28
同价升级，计算机使用基准 Online-Mind2Web 达 **84%**（超 GPT-5.5 与 Gemini），fast 模式 **2.5× 速度、便宜 3 倍**。同步推出 Claude Code「动态工作流」——单会话可调度**数百个并行子 Agent**完成数十万行代码级迁移。
**↳ 为什么重要**：智能体编排成为头部厂商的主战场，模型本身反而成了底座。
[Anthropic 官方](https://www.anthropic.com/news/claude-opus-4-8)

### 2. Google I/O：一次性 ~100 项更新 ｜ 5/26
核心是 **Gemini Omni Flash**（世界模型家族首款，原生多模态、可生成/编辑视频并内嵌物理推理）与 **Gemini 3.5 Flash**（直接 GA，成为 Google 搜索默认后端）。
**↳ 为什么重要**：Google 试图「商品化智能体层」，用低价 Flash + 多智能体编排向对手的企业定价施压。
[发布详情](https://valasys.com/google-gemini-omni-flash-io/)

### 3. NVIDIA GTC Taipei：台湾年投资升至 1500 亿美元 ｜ 5/27
黄仁勋把叙事从「卖 GPU」升级为「**AI 工厂 + token 即营收**」，发布 Vera Rubin pod 级系统与 Vera CPU，以巨额投资深度绑定 TSMC 供应链。上季营收创纪录 **816 亿美元**。
**↳ 为什么重要**：算力厂商把「每瓦 token 吞吐」确立为数据中心采购的新经济标尺。
[CNBC 报道](https://www.cnbc.com/2026/05/27/nvidia-taiwan-investment-150-billion-spending.html)

### 4. 国产大模型密集冲刺 A 股 ｜ 5/29
**MiniMax** 与中信证券签署辅导协议，正式启动科创板 IPO 备案；**智谱**紧随其后推进「A+H」双平台（6/1 公告）。叠加阿里 5/26 新加坡 Qwen 大会、5/29 牵手欧足联，国产 AI 进入「资本化 + 全球化」双提速。
**↳ 为什么重要**：竞争从「拼模型」延伸到「拼资本平台与上市速度」。
[证券时报](https://www.stcn.com/article/detail/3936167.html)

### 5. 具身智能从演示转向商单 ｜ 5/26
**Figure** 与零售控股集团 Catalyst Brands（JCPenney 母公司）签商业协议，人形机器人落地 Reno 物流中心。同周宇树、优必选亮相天津世界智能博览会。
**↳ 为什么重要**：人形机器人正从「技术演示」切换到「产业订单 + 公开市场定价」。
[Figure 官方](https://www.figure.ai/news/figure-signs-agreement-with-catalyst-brands)

---

## 🧭 三条主线趋势

**① 从「模型竞赛」转向「智能体竞赛」**
Opus 4.8 的数百并行子 Agent、字节 Coze 3.0 多 Agent 协作（并可接入 Claude Code/Codex/OpenClaw）、OpenClaw 强化编排原语——智能体编排与可观测性成为新焦点。

**② 「世界模型 / 物理 AI」成为新差异化叙事**
Google Gemini Omni Flash（模拟现实）与 Mistral Physics AI（工业仿真）同周登场，前沿厂商在通用模型之外开辟「理解物理世界」的新赛道。

**③ 价格、可靠性、评测信任三重重构**
Opus 4.8 同价升级 + fast 模式降价、Gemini 3.5 Flash 压价；OpenAI 因训练数据污染停用 SWE-bench Verified、转向 Scale SEAL 的不可作弊私有评测——智能趋同后，成本与可信度成为新竞争点。

---

## 🧠 大模型基座

| 厂商 | 本周 | 一句话 |
|------|:---:|------|
| Anthropic | 🔥 | Claude Opus 4.8 发布，动态工作流（详见 TOP 5） |
| Google DeepMind | 🔥 | Gemini Omni Flash + 3.5 Flash GA（详见 TOP 5） |
| xAI | 🔥 | Grok Build 0.1 编程模型，$1/$2 低价高吞吐 |
| 字节跳动 | 🔥 | 扣子 Coze 3.0：多 Agent 协作，可接入 Claude Code/Codex/OpenClaw |
| Mistral AI | 🟢 | 开辟「工业物理 AI」赛道 + Vibe Agent |
| OpenAI | 🟡 | Codex CLI v0.134，模型层按兵不动 |
| Meta · Microsoft · DeepSeek · Databricks | ⚪️ | 本周静默，重磅压在下周 Build / 下月 Summit |

**字节跳动 · 扣子 Coze 3.0（5/30）**
支持多人多 Agent 协作、行业专家技能模板，并可一键接入 Claude Code、Codex CLI、OpenClaw 等本地 Agent，意在做国产智能体编排的开放平台底座。
[IT之家](https://www.ithome.com/0/958/372.htm)

**Mistral AI · 工业物理 AI（5/27）**
基于收购的 Emmi AI 推出「Physics AI」研究方向，面向航空航天/汽车/半导体/能源等工业工程，用神经代理模型加速 CFD 仿真；同周推出 Vibe Agent。走差异化的欧洲企业级 + 工程仿真路线。
[Mistral 官方](https://mistral.ai/news/physics-ai-research)

**OpenAI · Codex CLI v0.134（5/26）**
新增本地会话历史搜索、MCP 服务器粒度环境变量与 OAuth，把 Codex 从交互助手推向「持久化自主运行时」。本周无新基座模型。
[更新汇总](https://codersera.com/blog/openai-may-2026-updates-roundup/)

> 💤 **本周静默**：Meta（重心在 Superintelligence Labs，Connect 定于 9 月）、Microsoft（重磅压在下周 Build 大会）、DeepSeek（V4 系列过渡期）、Databricks（仅作 Opus 4.8 首发企业背书，Summit 在 6/15）。

---

## 🤖 垂直 Agent 产品

| 产品 | 本周 | 一句话 |
|------|:---:|------|
| Glean | 🔥 | ARR 突破 3 亿美元，15 个月增长 3 倍 |
| Cursor · Perplexity · Cognition · Harvey · Sierra · Midjourney | ⚪️ | 大事件均在窗口外，处于「融资后消化期」 |

**Glean · ARR 破 3 亿美元（5/28）**
在 Google、微软、OpenAI、Salesforce 等巨头纷纷入场企业搜索后，Glean 仍凭「上下文图谱」深度理解客户业务、并以「帮企业削减 AI 算力成本」作为差异化卖点，老牌先发者逆势加速。
[TechCrunch](https://techcrunch.com/2026/05/28/gleans-top-line-crosses-300m-as-ai-budget-cutting-becomes-its-major-selling-point)

> 💤 **本周静默**：Cursor（传 $50B+ 估值轮）、Sierra（5/4 刚融 $950M）、Harvey（估值 $11B）、Perplexity、Cognition、Midjourney（主线已推进至 V8 系列）——大事件均落在本周之前。

---

## 🇨🇳 中国 AI 公司

| 公司 | 本周 | 一句话 |
|------|:---:|------|
| 阿里云 | 🔥 | 新加坡 Qwen 大会 + 牵手欧足联，模型出海 |
| MiniMax | 🔥 | 启动 A 股科创板 IPO 辅导（详见 TOP 5） |
| 智谱 | 🟡 | 推进「A+H」，主体公告紧贴窗口（6/1） |
| 月之暗面 · 腾讯 | ⚪️ | 本周无新动作 |

**阿里云 · 双线出海（5/26 & 5/29）**
5/26 在新加坡举办首届国际通义千问大会，发布升级模型与 AI agent 产品线；5/29 与欧足联（UEFA）达成多年战略合作，成为欧冠等赛事 2027/28–2032/33 共 6 届及 2028 欧洲杯的独家 AI/云/电商伙伴。以顶级体育 IP + 海外大会强化 Qwen 国际心智。
[阿里云官方](https://www.alibabacloud.com/en/press-room/alibaba-cloud-unveil-advanced-agentic-ai-ecosystem)

> 💤 **本周静默**：月之暗面（估值/IPO 叙事仍在发酵，Kimi K2.6 发布于 4 月）、腾讯（混元仍处追赶重建期，重磅压在下一代旗舰）。

---

## 🛠️ AI Agent 框架 / 工具

| 项目 | 本周 | 一句话 |
|------|:---:|------|
| Claude Code | 🔥 | 动态工作流：数百并行子 Agent（详见 TOP 5） |
| Hermes Agent | 🔥 | 自进化框架，3 个月获 135K+ GitHub Stars |
| OpenClaw | 🔥 | 5/30 快照：编排原语 + 子 Agent 可观测性 |
| Codex CLI | 🟢 | Computer Use 登陆 Windows |
| OpenCode | 🟢 | v1.15.13，多 Provider 兼容持续强化 |
| Scale AI (SEAL) | 🟡 | SWE-bench Verified 退场，私有评测价值上升 |
| Google ADK · Dify · Cohere · SSI | ⚪️ | 本周无窗口内正式发布 |

**Hermes Agent · 增长最快的开源 Agent 框架**
内置「学习闭环」——从经验创建技能并持续自我改进，是其差异化核心。上市不足 3 个月即获 **135,000+ GitHub Stars**，支持 20+ 消息平台，MIT 许可。反映开发者对「自托管 + 跨会话记忆 + 自进化」范式的强烈需求。
[GitHub](https://github.com/NousResearch/hermes-agent)

**OpenClaw · 5/30 快照**
主打 beta 编排原语、更严格输入校验、可见的子 Agent 状态、插件信任面与频道投递修复，把「可重启、可检查、有边界、显式」作为 Agent 栈设计原则，定位生产级个人 Agent OS。
[更新日志](https://openclaw.com.au/updates)

**评测信任重构 · Scale SEAL**
OpenAI 因发现前沿模型训练数据污染，宣布停用 SWE-bench Verified，转向 Scale 的 SWE-Bench Pro（1,865 个长程任务 / 41 个真实仓库）。「不可作弊的私有数据集」评测方法论价值上升。
[Scale 排行榜](https://scale.com/blog/leaderboard)

> 💤 **本周静默**：Google ADK（v2.2.0 在 6/4）、Dify（v1.14.2 在 5/19）、Cohere（Command A+ 在 5/20）、SSI（一贯无产品周期）。

---

## ⚡ 算力 / 云 / 硬件

| 厂商 | 本周 | 一句话 |
|------|:---:|------|
| NVIDIA | 🔥 | GTC Taipei，台湾 1500 亿投资（详见 TOP 5） |
| AWS | 🔥 | 洽谈 Grok 上线 Bedrock，扩「全模型超市」 |
| Azure | ⚪️ | 本周无窗口内单点大新闻 |

**AWS · Bedrock 扩张（5/27–28）**
扩展 Bedrock Service Quotas；并被曝正洽谈将 SpaceX（已收购 xAI）的最新 Grok 模型上线 Bedrock，模型已交付、上线在即。持续把 Bedrock 做成「全模型超市」（Anthropic/Meta/Cohere/OpenAI + 拟加 Grok），目标打造「全球最大推理引擎」。
[Business Insider](https://www.businessinsider.com/amazon-spacex-grok-models-ai-offering-bedrock-2026-5)

> 💤 **本周静默**：Azure（5 月节奏体现为 Realtime 2.0/Translate/Whisper 实时多模态模型铺开，无窗口内单点大新闻）。

---

## 🦾 具身智能 / 机器人

| 公司 | 本周 | 一句话 |
|------|:---:|------|
| Figure AI | 🔥 | 签 Catalyst Brands 零售物流商单（详见 TOP 5） |
| 宇树 Unitree | 🟢 | 天津世界智能博览会高动态拳击展示 |
| 优必选 UBTech | 🟢 | Walker S2 工业人形机器人同台展出 |

**宇树 & 优必选 · 天津世界智能博览会（5/28–30）**
宇树人形机器人现场拳击对抗（出拳、踢腿、摔倒恢复）成为具身 AI 展区焦点，强化「运动控制最强」标签（紧随其后 6/1 科创板过会）；优必选展出 Walker S2，延续「工业量产落地」路线。两家代表了具身智能「运动表演」与「产业落地」两条路径。
[Global Times](https://www.globaltimes.cn/page/202605/1362322.shtml)

---

## 📋 关于本周报

- **数据口径**：所有「本周动态」严格限定在 2026-05-24 ~ 05-30 自然周内；窗口外事件仅作背景并明确标注。
- **图标说明**：🔥 重大动态 ｜ 🟢 一般动态 ｜ 🟡 边缘/间接动态 ｜ ⚪️ 本周静默
- **来源**：全程一手来源交叉验证，关键数据标注出处与日期；查不到的数据如实标注「未公开」，绝不编造。
- **下期**：每周日更新。下期看点——微软 Build、Databricks Data+AI Summit、Google ADK v2.2 等窗口外动态将进入新一期视野。

*本周报由自动化研究流程生成，人工审核校对。*
