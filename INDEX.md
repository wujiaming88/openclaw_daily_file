# 📌 文件索引

> 按日期倒序排列，Ctrl+F 搜关键词快速定位

---

## 2026-06-11

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [中国武汉光谷资讯周报 · 第1期（2026-05-31~06-05）](news/2026-06-11-wuhan-guanggu-weekly-vol1.md) | news | 黄山×3+小帅 | 光谷本地资讯周报首期，覆盖投融资/企业动态/政策/人才/招商/土地/营商/城建 6 大口径，四大重点产业(AI/互联网/半导体/具身机器人)优先。TOP3：①湖北日报6/4「光+AI」全链条爆发(中信科移动6G现场测试10Gbps+长飞空芯光纤Token快50%+华工AI激光2030营收占比>60%·光谷Q1 GDP约833亿+13.2%)②锐科激光发布激光OS AI智能体「小锐」+6/3盘中涨停(收涨17.73%·创4年新高)③中科酷原「汉原2号」双核中性原子量子计算机首单商用签约(量子+金融)。两主线：光谷「光+AI」进入资本定价与商用落地拐点(通信板块融资净买入60.03亿居首) + 政策从「补供给」转向「激需求+降门槛」聚焦「AI+制造」赋能存量中小企业(东湖高新区AI赋能包双征集+湖北省OPC措施公报生效) |
| [Amazon Bedrock AgentCore 全景深度研究](research/2026-06-11-amazon-bedrock-agentcore.md) | research | 黄山+小帅 | AWS 押注 Agent 时代的「水电煤」serverless 底座深度拆解：定位/七大组件（Runtime/Memory/Gateway/Identity/Browser/Code Interpreter/Observability）/框架与模型中立性/MCP+A2A 协议生态/企业级安全/12 组件 consumption-based 定价/竞品横评（vs LangGraph、OpenAI Agents SDK、Vertex Agent Engine、Azure AI Foundry、Cloudflare）/实战代码骨架/趋势研判。GitHub 实测（2026-06-11）：strands harness-sdk 6098★、agentcore-samples 3046★、SDK 720★。核心判断：AWS 用「卖铲子」战略复刻 Lambda 剧本，赌所有 Agent 最终都要落到企业级运行时上付费——对 LangChain 类中间层是降维平台化（不竞争而托管之）。差异化优势=microVM 物理隔离+8 小时超长运行+真模型中立（含 OpenAI/Gemini）；最大短板=12 组件计费复杂、Observability 易超支 |
| [现在可以合上笔记本了：深度解读 AWS 在 AgentCore 上托管 Coding Agent](research/2026-06-11-coding-agents-on-agentcore.md) | research | 黄山+小帅 | 深度解读 AWS ML Blog《It's safe to close your laptop now》官方实战长文。核心叙事：开发者不敢合笔记本(合盖=杀死里面跑的 coding agent)→ 笔记本从来是「最近」不是「最对」的宿主。拆解：①笔记本是错宿主的4条(爆炸半径=整机/密钥贴着代码/git worktree只是半个补丁/盖子=物理kill switch)②Runtime=每session独立Firecracker microVM③四能力(持久/mnt/workspace保留14天+真交互shell agentcore exec --it+应用层确定性命令绕过LLM+BYO文件系统S3/EFS挂载)④Identity+Gateway三种凭证模式(bot/on-behalf-of RFC8693/broker)+VPC网络层杀数据外泄⑤四agent竞速实测(Claude Code-Opus4.8/Codex-GPT5.5/Kiro-auto/Hermes-Llama4)Race/Bench/Watch三实验⑥客户实证(TR CoCounsel/Cox 17agent/Druva 8-10安全agent/TR平台15x)。判断:三件套(物理隔离+凭证外置+VPC管控)是本地harness最难自建部分;与我们小帅+五岳多agent架构高度同构,AgentCore把这套做成AWS托管商品 |
| [AgentCore Harness 深度研究](research/2026-06-11-agentcore-harness-deep-research.md) | research | 黄山+小帅 | AgentCore 家族最新成员 harness（Public Preview·2026-04-22 起·4 区域·不单独收费）深度拆解。自顶向下：①顶层定位（架在 Runtime 之上的「托管壳」、CloudTrail 落到 AWS::BedrockAgentCore::Runtime 上、不是第八个并列组件而是其余六大原语的缝合层）②核心范式「defaults at creation, overrides at invocation」（配置即编排、调用时可临时覆盖模型/prompt/MCP）③逐能力下钻 7 节（声明式配置/接工具/记忆与文件系统/环境与 Skills/可观测与成本/安全/Get started CLI 骨架）④由 Strands Agents 驱动（GitHub 实测 2026-06-11：strands-agents 主仓 6098★、harness-sdk 重定向、生态 org 合计破万★）⑤三种做法对比表（裸 Bedrock vs Runtime+自写 vs harness）⑥趋势：harness 把铲子组装成挖掘机，对 LangGraph/CrewAI 是降维挤压；preview 期短板=SigV4 不透传 per-user 身份+复杂多 agent 编排短期仍需自写。9 张对比表+CLI/SDK 代码骨架+信息源齐备 |

## 2026-06-10

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [全球 AI 创业公司研究周报 · 第 1 期（06-03~06-09）](research/2026-06-10-global-ai-startup-weekly.md) | research | 黄山×4+小帅 | 首期创业公司纵深周报：聚焦估值<$10亿早期/成长期 AI 创业公司，分 4 组并行深研，18 家（美6/中6/欧+以3/东南亚+其他4，A Security 归以色列后美国净6）。四维质量门控全过（美6/中6/其他6·原文抽查5/5·五维齐全18/18·数据≥2源交叉验证）。每家五维纵深（产品/融资/创始人/竞争力/赛道）≥300字。TOP5：Collate（生命科学版Harvey·近独角兽）、GIM（为金融打造的DeepSeek·阎焱赛富领投）、华超神控（超声脑机接口·1.5mm精度）、Lassie（a16z领投·AI替企业跑业务）、Companion.energy（19人管€500M能源盘）。主线=AI执行层崛起 vs 中国硬科技纵深 |

## 2026-06-09

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [世界模型(World Models)深度研究](research/2026-06-09-world-models-deep-research.md) | research | 黄山+小帅 | 由浅入深+理论到应用全覆盖+13篇一手论文/报告全文研读。三大路线之争:自回归生成派(Sora/Genie3/GAIA)/JEPA派(LeCun/V-JEPA2)/model-based RL派(DreamerV3),争输出像素还是抽象表征。经典论文拆到参数量(Ha&Schmidhuber2018 VAE+MDN-RNN+Controller/在梦里训练)。DreamerV3首个Minecraft从零挖钻石;V-JEPA2仅62h视频零样本部署Franka机械臂。企业深析:World Labs(李飞飞估值洽谈5B)/DeepMind Genie3/NVIDIA Cosmos/Wayve GAIA/Meta V-JEPA/Decart Oasis。趋势:通往AGI/具身关键路径,机器人走出实验室是1-2年定胜负信号。含mermaid架构图+三路线对比表 |
| [全球 AI 投资研究周报（06-02~06-08）](research/2026-06-09-global-ai-investment-weekly.md) | research | 黄山×4+小帅 | 首期投资视角周报：产业链自底向上 5 层（能源/基础设施/芯片存储/模型框架/应用商业化）+ 4 横切（政策/国资/资金/人才）全覆盖。五维质量门控全过（覆盖≥8成·原文抽查5/5·政策均读原文·收敛层齐·数据全有源）。TOP5：Anthropic/OpenAI 先后机密递表 IPO（估值逼万亿）、DeepSeek 首轮融资 74 亿美元（宁德入局）、存储超级周期三重确认、博通 ASIC +143%、电力成 AI 第一约束（聚变/液冷融资爆发）；so what 收敛层给出产业链传导链 + 资本流向 + 一级机会风险 + 领先指标 |
| [Harness Engineering 深度研究](research/2026-06-09-harness-engineering-deep-research.md) | research | 黄山+小帅 | 「Agentic Coding 工作机制」系列硬核篇。本质：Agent = Model + Harness，harness 给模型建闭环工作系统。三篇一手原文精华：OpenAI(5个月0行手写代码/Codex写100万行1500PR/人掌舰Agent执行)、Anthropic两篇(长程Agent轮班制失忆/两大死法:一口气做完+过早宣胜/Initializer+Coding+Evaluator三Agent架构/feature list用JSON不用MD)。震撼实测:同Opus 4.5裸跑20min不能用 vs 套harness 6h完全可玩。六大机制(环境/状态/验证/控制/可观测/防过早宣胜)。walkinglabs课程评测(learn-8k★/awesome-3k★ GitHub实查)。概念关系网(与context engineering谁包含谁有争)。趋势:后提示词时代核心范式但是过渡期范式 |
| [WTF Is a Loop？论战拆解](research/2026-06-09-loop-debate-deep-research.md) | research | 黄山+小帅 | 「Agentic Coding 工作机制」系列故事篇。拆解2026年6月初AI coding圈最火的loop之争。导火索:@steipete(Peter Steinberger,OpenClaw之父/2026年2月加入OpenAI)一条4.7M浏览爆款推文「designing loops that prompt your agents」刷屏。争论本质=术语坤塌(loop三层含义:内层agentic loop/外层编排loop/元层harness,各说各话)。两派:极简派(Steinberger)vs工程派(Boris Cherny,Claude Code之父/已回归Anthropic)。人物身份+言论严格取证(Steinberger推文逐字核实/Cherny阶梯二手转述标注存疑/Van Horn长文未取到均如实声明)。与Harness篇互为镜像 |

## 2026-06-08

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [Agent Client Protocol (ACP) 深度研究](research/2026-06-08-acp-deep-research.md) | research | 黄山+小帅 | Zed 主导的开源协议深挖：「AI 编码 Agent 时代的 LSP」。命名陷阱厘清(Agent_Client_Protocol vs IBM Agent_Communication_Protocol，后者已并入A2A)；技术架构(JSON-RPC over stdio+子进程模型+权限请求一等公民原语+复用MCP的JSON表示)；GitHub实况(主仓3342★/Rust/Apache-2.0/周更release/迁入中立组织/5语言SDK，2026-06-08 API实查)；生态采用(Zed/Neovim/JetBrains × Claude Code/Gemini CLI/Codex/Goose 17+)；与MCP/A2A/LSP横向对比表(MCP给工具·A2A给协作者·ACP给用户)；HN/Reddit社区评价；趋势研判(大概率成开放编辑器阵营事实标准，变量=VS Code/微软态度+远程能力)；8维度全覆盖+来源附录 |
| [全球 AI Agent 周报（06-01~06-07）](research/2026-06-08-global-ai-agent-weekly.md) | research | 黄山×4+小帅 | 首期 Agent 专题周报：28 个 Agent 对象分 4 组并行深研（编码CLI/通用框架/垂直企业/浏览器操作+中国），实质覆盖 28/28（100%）。TOP5：Cognition Devin Desktop+ACP开放协议、微软基于OpenClaw推出Scout、LangChain Interrupt+MS Build双会、中国Agent集体爆发(扣子3.0/Kimi Work/Qwen-VLA)、Token经济学成第一性约束；学术/工程/商业三维度覆盖，原文全文阅读+链接齐备，严格时间窗校验 |

## 2026-06-07

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [全球 AI 动态周报（05-31~06-06）](research/2026-06-07-global-ai-weekly.md) | research | 团队 | 第 2 期 AI 周报：38 主体全覆盖（38/38），大模型/垂直Agent/中国AI/框架工具/算力硬件/具身机器人 6 赛道。TOP5：NVIDIA GTC Taipei 全栈算力(RTX Spark/Vera/Isaac GR00T)、宇树三喜临门(产能破万+IPO过会+英伟达联姻)、MiniMax M3 开源集齐三能力、DeepSeek 首轮融资74亿美元、微软Build自研MAI；严格时间窗校验，原文链接齐备 |

## 2026-06-05

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [SpaceX IPO 深度解读报告](business/2026-06-05-spacex-ipo-deep-analysis.md) | business | 黄山+小帅 | 史上最大 IPO 全景拆解：基于 SEC S-1 原文一手数据。$1.69 万亿估值/$750 亿募资/马斯克 82.4% 投票权/Starlink 1030万用户 ARPU 拆解/累计赤字 $413 亿；含 AI 转向研判(xAI/Grok 并表+Cursor $600亿期权+卖算力给 Anthropic)、沙特阿美/英伟达对标、7 大风险、投资视角；9 节完整 |
| [全球 AI 动态周报（05-24~05-30）](research/2026-06-05-global-ai-weekly.md) | research | 黄山×4+小帅 | 首期 AI 周报：38 主体分 4 组并行深研，覆盖大模型/垂直Agent/中国AI/框架工具/算力硬件/具身机器人。TOP5：Claude Opus 4.8、Gemini Omni Flash、NVIDIA 台湾1500亿、国产AI上市潮(MiniMax/智谱)、Figure 零售商单；61 条原文链接，严格时间窗校验 |

## 2026-06-02

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [OpenClaw MCP 深度调研报告](research/2026-06-02-openclaw-mcp-deep-dive.md) | research | 黄山 | 源码级深挖：MCP 双重身份(serve/client registry) + 3 种 transport + stdio env 黑名单 + Codex 投影 + 生命周期治理 + 5 客户端对比 + 4 实战玩法 + 7 类安全风险 + 故障排查；2 张 mermaid 架构图，11 条外部参考 |

## 2026-04-27

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [Gemini Enterprise Agent Platform 深度研究](research/2026-04-27-gemini-enterprise-agent-platform.md) | research | 黄山 | 7维全面分析：架构演进(Vertex AI→Agent Platform)、核心能力、ADK 2.0、5大竞品矩阵、定价详解、12+客户案例、Cloud Next 2026最新发布 |

## 2026-04-22

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [Hermes Agent 自动 Skill 创建机制深度研究](research/2026-04-22-hermes-agent-skill-creation-deep-research.md) | research | 黄山 | 源码级分析 skill_manage 实现 + 三层记忆架构 + GEPA Self-Evolution + Periodic Nudge 机制 + OpenClaw 对比与移植方案 |

## 2026-04-19

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [OpenClaw Multi-Agent 团队最佳实践三维指南](research/2026-04-19-openclaw-multiagent-best-practice.md) | research | 黄山(卷王) | 可维护性/效率/稳定性三维 + 老板团队 3 个月路线图 + 16 条反模式 + 可复用配置样本；基于 Anthropic+Cognition+OpenClaw docs |
| [AWS Bedrock 顶级 LLM 决策清单](research/2026-04-19-aws-bedrock-top-models.md) | research | 黄山(卷王) | Top 8 模型对比 + 场景推荐矩阵 + 价格陷阱；含 Opus 4.7 / Nova 2 Lite / Llama 4 Scout 最新数据 |

## 2026-04-15

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [OpenClaw + Obsidian 记忆方案调研](juan-wang-research/2026-04-15-openclaw-obsidian-memory-research.md) | juan-wang-research | 黄山(卷王) | Dave Swift 方案深度分析，结论：增量有限，暂不集成 |

## 2026-04-10

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [全球 TOP30 AI 公司 v2](research/2026-04-10-global-top30-ai-companies.md) | research | 黄山 | 30 家公司深度分析，含编程 Agent 赛道 |
| [OpenClaw × 传统行业](business/2026-04-10-openclaw-traditional-industries.md) | business | 黄山 | 12 个行业结合点，TOP3 切入点 |

## 2026-04-09

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [OpenClaw 商业化分析](business/2026-04-09-openclaw-commercialization-analysis.md) | business | 华山 | 三阶飞轮策略，90 天路线图 |

## 2026-04-08 及更早

> 历史文件在 [juan-wang-research/](juan-wang-research/) 目录下，详见其 [README](juan-wang-research/README.md)

---

*最后更新：2026-06-02*
