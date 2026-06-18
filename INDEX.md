# 📌 文件索引

> 按日期倒序排列，Ctrl+F 搜关键词快速定位

---

## 2026-06-18

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [全球 AI Agent 基础设施研究周报 · 第1期（2026-06-11~06-17）](research/2026-06-18-global-ai-agent-infra-weekly.md) | research | 黄山×3+小帅 | 聚焦 Agent 基础设施（运行时/编排层/框架托管）的首期周报，11/11 对象全覆盖（A组三大云厂 100%+字节 Coze 必覆盖）。分3组并行深研，每对象深度笔记≥250字+原文URL+四维（产品/生态/采用/竞争）扫描。四维质量门控全过（覆盖11/11·原文抽查URL真实·每对象洞察+四维趋势齐·数据多源交叉验证）。TOP5（按基础设施格局信号价值排序）：①AWS AgentCore harness 正式 GA+Managed Knowledge Base+原生 Web Search（6/17 Summit NY·model-agnostic 中途切 provider 不丢 context）②Anthropic Claude Fable 5/Mythos 5（6/12·长任务记忆增益 3×Opus4.8·Stripe 一天迁 5000万行 Ruby）③Databricks Agent Bricks 升级开发者 Agent 平台（DAIS·10万+agents/年超1quadrillion tokens·SpaceX 接 Grok）④Google Gemini Enterprise 商业化提速+ADK 2.0 Workflow Runtime（Macy's 4周建成·A2A 150家 production）⑤字节 Coze 3.0+Coze Loop（中国 Agent 做开放编排中枢·接入 Claude Code/Codex/OpenClaw）。主线：三大云厂路线分化（AWS拼组件密度·Google拼商业落地·微软拼开放信任栈），框架托管化+知识接入+可观测评测成标配战场，Agent 平台竞争进入「生产可靠性与治理」下半场。已发布博客 |
| [全球 AI 创业公司研究周报 · 第2期（2026-06-10~06-16）](research/2026-06-17-global-ai-startup-weekly.md) | research | 黄山×4+小帅 | 全球早期AI创业公司纵深周报第2期，19家估值<$10亿公司（美5/中6/欧洲+以色列5/新加坡+其他3），分4组并行深研，每家五维（产品/融资/创始人/竞争力/赛道）≥300字。四维质量门控全过（覆盖美5中6其他8=19家·原文抽查5/5 URL真实·五维齐全19/19·数据多源交叉验证）。TOP5（按决策信号价值排序）：①硅基流动（20亿B轮·国产算力中间层全产业链国资天团押注）②星尘智能（绳驱量产全球首家·3个月3轮超10亿估值破百亿）③NewCore（出隐$66M·给AI agent发工牌硬刚Okta/微软）④THEKER（$85M欧洲最大机器人A轮·三星+LVMH罕见联手）⑤Probably（a16z押注更弱模型+更强工程的降本逆向路线）。主线：资本从模型层下沉到落地层，Agentic时代身份/数据/采纳三层基础设施集体爆发，国产算力+具身智能在中国10亿级大手笔。已发布博客 |
| [从源码深挖 Claude Code 的 cache_edits（一次"既删旧又保缓存"的外科手术）](research/2026-06-17-claude-code-cache-edits-deepdive.md) | research | 黄山+小帅 | 基于 v2.1.88 还原源码的 cache_edits 专题深度文（306行/20KB·8章）。把 Claude Code 压缩引擎里最精巧的机制拆到状态机层面：①问题起点（KV cache 因果注意力+RoPE 决定前缀"全有或全无"+成本账 0.1×命中vs1.25×重写）②warm/cold 分流（缓存凉时直接本地清，热时才走 cache_edits）③服务端策略契约 clear_tool_uses_20250919/clear_thinking_20251015 是日期版本化的 API 一等公民+180K/40K 阈值+幂等可重取工具白名单 ④**pin/consume/getPinned 三件套状态机**（博客没讲透的精髓：edits 是"会话上的持久化注解"，必须每轮原位重发以维持前缀逐字节一致）⑤模型门控四把锁（feature/runtime/model/CACHE_EDITING_BETA_HEADER）+ ant-only 模块边界（cachedMicrocompact.js 在公开 bundle 中已剥离，仅剩调用点）⑥codex/opencode/hermes 横向对照（都做不到"删了但前缀没变一字节"，这是垂直整合护城河）⑦五条洞察+对自研 harness 启示。源码确证 ≥10 处真实 file:line（microCompact.ts:243-369、apiMicrocompact.ts:13-58、claude.ts:1188-1207）。已发布博客 |
| [深度剖析 Barazany《Claude Code 的压缩引擎——源码究竟揭示了什么》](research/2026-06-17-barazany-claude-compaction-deepread.md) | research | 黄山+小帅 | 对 Jonathan Barazany 名文的深度剖析+技术延展（信息覆盖≥90%·400行/39KB·约原文7倍厚）。原文是作者第二篇，用 Claude Code 泄漏源码验证其第一篇预测（确定性 curation>LLM摘要·摘要是最后手段）。逐节剖原文6节+6处【技术展开】：①curation哲学（有损/无损/可调试/可重放四维）②三层架构成本阶梯+Tier3 scratchpad先推理再剥除的质量/洁净权衡③**cache_edits（最硬核·用Transformer因果注意力+RoPE讲透删头致前缀KV全失效·tool_use_id定向删除解开删旧vs保缓存矛盾）**④摘要复用主对话缓存（cache key=前缀逐字节哈希·换system prompt即98%miss·全球级算力账）⑤压缩后重建（重读5文件50K防过期代码+continuation message注意力锚点防摘要污染）⑥缓存经济学=隐形第一性原理（0.1×命中vs~1.25×重写·与5小时上限因果链）。横向印证表：原文6论点×codex/opencode/hermes三个一手harness源码逐条对照。源码印证≥6处真实行号已sed验证（compact.rs:258 preserve-cache注释·message.ts:120 pruned字段·prompt_caching.py:5 ~75%·client.rs:152 /responses/compact等）。明确声明Claude Code闭源属逆向边界。四维门控全过。已发布博客 |

---

## 2026-06-16

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [深度解读 justin3go《Shedding Heavy Memories》——三家上下文压缩机制技术展开](research/2026-06-16-justin3go-compaction-deepread.md) | research | 黄山+小帅 | 对 justin3go 2026-04-09 名文的高保真深度解读（信息覆盖≥90%）+ 技术延展（576行/48.9KB）。逐节复述原文7大节（引言Context Anxiety/15400-token登录bug场景表/Codex handoff/Claude三层/OpenCode阶梯/对比表/三比喻），每节后追加【技术展开】共14处，结合本地clone真实源码把原文点到为止处讲透：①context rot三重机理(注意力稀释/lost-in-middle/腐烂)②工具结果81%占比的信息单调累积本质③Codex双路径+/responses/compact工程意义+用户意图不可篡改④**缓存经济学(全文最深点：前缀全有或全无/98%miss/0.1×命中vs1.25×重写/cache_edits外科手术删除)**⑤OpenCode时间戳软删除(compacted=Date.now)的reachability可逆性⑥三种删除语义哲学光谱。合规：开头结尾双标原文出处+声明26条场景为作者原创示例+全文自有语言重组无照搬。源码印证≥3处真实行号(openai_models.rs:433/compact.rs:52/client.rs:152/overflow.ts:8/compaction.ts:38)。已发布博客 |
| [代表性 Agent Harness 的「自动上下文压缩」机制深度研究](research/2026-06-16-agent-context-compaction.md) | research | 黄山+小帅 | 从 harness engineering 出发，理论×架构×工程三层深挖 Codex CLI / Claude Code / OpenCode / Hermes Agent 的自动上下文压缩机制（+5 个加分对象 Gemini CLI/Cline/Goose/Aider/框架原语）。本地 clone codex/opencode/hermes-agent 三仓库逐行读源码（小帅实地抽验 4 处源码声明 100% 命中：`openai_models.rs:433` 的 `(ctx*9)/10`、`context_compressor.py:145` 的 `_SUMMARY_RATIO=0.20`、`compaction.ts:38` 的 `PRUNE_MINIMUM=20K`、`client.rs:152` 的 `/responses/compact`）。5 大发现：①「精准遗忘」是 2026 共识 ②成本阶梯铁律（零成本本地规则→缓存友好→最后才用昂贵有损 LLM 摘要）③缓存经济学是隐形第一性原理（删尾不删头为保 Prompt Cache 前缀·删头付 1.25× 重写费）④学术层(StreamingLLM/H2O/LLMLingua 攻 KV/token 层)vs 工程层(全在消息编排层·把 attention sink 朴素复刻为保护首尾消息)几乎不交叉 ⑤路线分化：Codex/Claude 不可逆摘要 vs OpenCode 时间戳隐藏(可回溯) vs Hermes 可插拔无损 LCM 引擎(前沿)。含 12 维×5 对象对比表 + 7 类压缩策略分类学 + MemGPT/StreamingLLM/LLMLingua 论文精读 + 逐对象源码剖析。四维质量门控全过。已发布博客 |
| [全球 AI 投资研究周报 · 第2期（2026-06-09~06-15）](research/2026-06-16-global-ai-investment-weekly.md) | research | 黄山×4+小帅 | 投资视角周报第2期：产业链自底向上 5 层 + 4 横切全覆盖（~43/47 主题≈91%）。五维质量门控全过（覆盖≈91%·原文抽查5/5·政策3篇均读原文摘条款·收敛层五项齐·数据全有源）。TOP5（按决策信号价值排序）：①国家大基金洽谈领投 DeepSeek（450 亿美元·国资从补芯片升级到持模型）②美国出口管制「从芯片爬升到模型」（Anthropic Fable 5/Mythos 5 全球下架·监管首入软件API层）③KKR/Nvidia/Vistra/科威特推出 Helix Digital（>100 亿美元·电力一体化平台化拐点）④Oracle RPO 6380 亿但>50%来自 OpenAI+FCF -237 亿（AI capex 回报周期拐点）⑤SpaceX 含 xAI 史上最大 IPO（募资 750 亿·首日市值 2.1 万亿·一级转二级）。so what 收敛层：两条传导链（地缘→国产化、电力→证券化）+ 景气信号 + 资本流向 + 一级机会风险 + 4 个领先指标。已发布博客 |

---

## 2026-06-15

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [小红书起号作战手册 · B方向「我用 AI 组建了一支虚拟公司」](growth/2026-06-15-xiaohongshu-startup-playbook-b.md) | growth | 衡山+小帅 | 小红书账号起号完整作战手册（B方向·过程纪实·全程不露脸·约3.1万字·可直接执行）。定位铁律=主角是真实在跑的五岳AI团队不是真人/不是神器盘点。13章：第0章调研分析(真实账号拆解+build in public表现+竞争格局·先调研后定策略)/1账号定位(人设·价值主张·账号名·简介钩子)/2不露脸内容呈现体系(终端录屏/对话截图/看板/大字报)/3四大固定栏目(成果纪实35%+人设连载25%+翻车复盘20%+幕后搭建20%)/4开局10个爆款选题+标题/5封面设计规范(命门)/6博客→笔记改造SOP/7前30天内容日历/8冷启动方法论/9变现路径/10数据复盘指标/11合规红线(平台规则逐条对照·绝不站外导流)/12护城河反抄袭(真团队×时间沉淀+连载叙事+人格化IP+真实翻车·工具号抄不走)。三条最高优先约束：①结论先有调研支撑②绝不踩平台红线③死磕不可复制护城河。配套 xhs-content-forge / xhs-cover-maker 双 skill 落地执行 |
| [全球 AI Agent 赛道周报 · 第2期（2026-06-08~06-14）](research/2026-06-15-global-ai-agent-weekly.md) | research | 黄山×4+小帅 | 全球AI Agent赛道周报第2期，4大板块28个对象全覆盖(28/28=100%)。TOP5：①Anthropic Claude Fable 5发布3天即紧急暂停(纯视觉通关游戏+截图重建代码SOTA·因网安dual-use风险6/12暂停·能力跑赢安全)②Manus被Meta强制拆解(应北京要求·NDRC国家安全审查·创始人独立募资10亿设中国JV拟港股·地缘政治重塑Agent资本逻辑)③智谱GLM-5.2用MIT协议开源(接近Opus4.5级·下周开源·ZCode每天300万token免费)④Cursor Auto-review(循环内小分类器Agent·把自主性从开关变旋钮·治审批疲劳)⑤OpenAI Codex "Migrate from Claude Code"(一键迁移挖墙脚·Browser/Computer Use全面铺开·编码Agent白热化)。三维度趋势：形态拐点(CLI→可托管后台Agent OS/多Agent指挥中心) + 两阵营(垂直整合派Codex/Claude Code vs 开放协议互联派OpenClaw/OpenCode/Devin Desktop·MCP+ACP成标配) + 定价集体转向结果/用量制+护城河从模型转向专有数据+安全合规。四维门控全过：覆盖28/28、原文抽查5/5、洞察+三维度到位、数据有源交叉验证。已发布博客 |

---

## 2026-06-14

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [全球 AI 动态周报 · 第3期（2026-06-07~06-13）](research/2026-06-14-global-ai-weekly.md) | research | 黄山×4+小帅 | 全球AI动态周报第3期，38个对象/6大赛道全覆盖(38/38=100%)。TOP5：①Anthropic发布Claude Fable 5(Mythos级·1M上下文)48小时内遭美国政府出口管制暂停——前沿模型首次成「战略管制物项」②OpenAI秘密递交S-1+收购Ona·Codex周活破500万同比+400%③国产编程旗舰周级肉搏(智谱GLM-5.2全量开放MIT开源·月之暗面Kimi K2.7 Code开源1.1T参数token降30%·阿里Qwen3.7-Max升级多模态混合智能体)④xAI Grok V9-Medium(1.5万亿参数)推入Tesla+X分发飞轮⑤优必选U1消费级人形8天小订破3000台验证C端拐点。三主线：AI跨入战略管制物项(监管直接介入前沿发布) + 竞争从「模型智能」转向「分发渠道+Agent编排+单位成本」 + 云厂商与具身机器人深度绑定(NVIDIA Isaac GR00T成全球人形共同算力底座)。四维门控全过：覆盖38/38、原文抽查5/5、洞察+三主线到位、数据有源交叉验证。已发布博客 |

---

## 2026-06-13

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [中国武汉光谷资讯周报 · 第2期（2026-06-07~06-12）](news/2026-06-13-wuhan-guanggu-weekly.md) | news | 黄山×3+小帅 | 光谷本地资讯周报第2期，7大板块全覆盖（投融资/企业动态/政策/人才引进招商/人才招聘/土地营商/城建），四大重点产业(AI/互联网/半导体/具身机器人)优先。TOP3：①光谷光纤光缆"光+AI"资本兑现(长飞601869涨停、一年涨超10倍·烽火涨超8%·亚马逊-康宁数十亿美元大单·CRU预测2026全球光纤缺口16.4%·A2预制棒涨近550%)②中信科移动688387完成全国首次6G多终端现场测试10Gbps+武汉6G基地年中投产(超1500项6G专利·工信部本周连发两份6G/AI政策)③武汉光谷新材料产业园揭牌(东湖高新+青山跨区共建·首开区125亩18个月建成·补光电子材料端卡脖子短板)。两主线：光谷"光通信优势"向"光+AI+6G+具身智能"多维跃迁(华工科技6G光模块送样+拾光S1家庭机器人光谷实测+脑机接口创新中心投用) + 政策从"补供给"转"搭平台建机构打地基"(新材料园+AI创意研究院+省工业软件创新中心同周落地)。四维门控全过：覆盖7/7、原文抽查3/3、洞察+两主线到位、数据有源交叉验证。已发布博客 |

---

## 2026-06-12

| 文件 | 目录 | 产出人 | 说明 |
|------|------|--------|------|
| [AI Agent 沙箱（Sandbox）技术体系全景研究](research/2026-06-12-ai-agent-sandbox-research.md) | research | 黄山+小帅 | AI Agent 沙箱技术体系深度研究（面向技术决策者·约1.2万字）。核心论点：沙箱把 Agent 的「意图信任」问题转化为「边界强制」问题——LLM 输出是不可信代码，必须隔离执行。2026 格局两条主线：①本地 Coding Agent（Codex/Claude Code/OpenClaw）走 OS 原语轻量隔离（macOS Seatbelt + Linux Landlock/seccomp/bubblewrap + 网络代理白名单 + approval）开销近零；②云端沙箱即服务（E2B/Modal/Daytona/Cloudflare/Northflank）走轻量级虚拟化（Firecracker microVM/gVisor）~150ms 冷启动+多租户隔离。选型判据=跑自己代码用 OS 原语/跑不可信代码必上 microVM（容器共享内核已知不充分）。覆盖：演进史(chroot→Docker→gVisor/Firecracker→Agent原生)+七类底层技术原理(seccomp/namespaces/Landlock/Seatbelt/容器/microVM/WASM/浏览器/网络出口/文件系统)+权衡对比表+主流方案横评(Codex源码级/Claude Code srt/OpenClaw信任模型/Google ADK/E2B等18对象)+对比矩阵+现状研判(Firecracker为何成事实标准)+未来(机密计算SEV/TDX+MCP时代WASM工具隔离+沙箱标准化)。5条洞察：跨公司架构趋同是正确路线信号/OS原语syscall层不懂应用语义必走混合架构/Firecracker独占强隔离+低启动+高密度三角/OpenClaw个人助理信任模型与E2B多租户SaaS是两种产品形态/没有银弹(微架构侧信道+policy易写错)。已发布博客 |

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
