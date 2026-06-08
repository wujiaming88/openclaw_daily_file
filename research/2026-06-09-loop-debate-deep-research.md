# WTF Is a Loop? 拆解 2026 年初 AI Coding 圈最火的一场嘴仗

> **深度研究报告** · 2026-06-09
> 作者:黄山(System Architect & Technology Researcher)
> 用途:博客发布 + 团队资料库
> 关联主题:**Harness Engineering**(本报告与之互为镜像,见第五节)

---

## 摘要(TL;DR)

2026 年 6 月初,AI coding 圈被一句六个词的话刷屏:**"designing loops that prompt your agents"**(设计能驱动你的 agent 的循环)。这句话出自 OpenClaw 之父 **Peter Steinberger(@steipete)** 一条 4.7M 浏览量的爆款推文,瞬间"卡住了整条时间线"。随后整个圈子陷入一种奇特的状态:**所有人都在说 "loop",但几乎没人能说清自己嘴里的 "loop" 到底指什么。** 作家、连续创业者 **Matt Van Horn(@mvanhorn)** 用他自己的 `/last30days` 研究工具复盘了这场风波,写成长文 **《WTF Is a Loop? Peter Steinberger vs. Boris Cherny》**。

这场"论战"的两个主角——极简派的 Steinberger 与 Claude Code 负责人 **Boris Cherny(@bcherny)**——表面上像在对立,实则是在 **同一个技术坐标系的不同图层上各说各话**:Steinberger 喊的是"别再手动喂 prompt,去设计外层的自动化循环";Cherny 给出的是一条抽象阶梯——**"2025 你写循环来 prompt Claude,2026 你写驱动这些循环的 harness(脚手架)"**。一个说 loop 是终点,一个说 loop 只是通往 harness 的中间站。

**核心判断**:这其实不是一场真正的对立,而是 **术语坍缩(term collapse)** 引发的集体误读。"Loop" 一词同时承载了三层完全不同的含义(内层 agentic loop / 外层编排 loop / 元层 harness),争吵的人站在不同图层互相开火。真正有价值的结论藏在 Van Horn 文章的收尾里:**"stop being the thing in the loop"(别再让自己当那个循环里的零件)**。这与团队正在研究的 **Harness Engineering** 是同一枚硬币的两面——loop 是极简派的口号,harness 是工程派的答卷,二者注定收敛。

---

## 一、事件起因:那条"卡住时间线"的推文

### 1.1 导火索(已核实,逐字引用)

2026 年 6 月 7 日 11:58 AM,Peter Steinberger 发出一条后来被反复转引的推文:

> **"Here's your monthly reminder that you shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."**
>
> —— @steipete,2026-06-07,约 **4.7M Views**(来源:Digg 对该 X 帖的聚合页,逐字转录)

那句"六个词、人人都在说却没人能定义"的核心短语,就是后半句:**"designing loops that prompt your agents"**(严格数是五个实词 + 语法词;Van Horn 文中将其概括为"六个词长的句子",指的就是这半句口号)。

这条推文在 Digg 的情感聚合里显示:**正面 57.6% / 负面 42.4%**(417 条带情感的评论)。正面阵营认为"用循环自动化 prompt 比手动重复高效得多";负面阵营则"反感这套术语,把鼓吹者视为炒作"。这个接近五五开的撕裂,正是它能霸屏的原因——**它同时是方法论宣言和被群嘲的 buzzword。**

### 1.2 评论区已经预演了整场争论(已核实,逐字引用)

爆款推文下方,有人一针见血地把它接进了一条"术语进化链":

> **"Context Engineering -> Harness Engineering -> Intent Engineering -> (Loop Engineering?) @steipete"**
> （来源:Digg 聚合的该帖高赞回复,逐字)

也有人当场质疑其可行性边界:

> **"@steipete but you kinda still need to be in the loop to test stuff unless you literally have infinite tokens"**
> （你总还得待在循环里测东西吧,除非你真有无限 token)——逐字引用

Steinberger 本人在评论区进一步加码,把"loop"推向"fleet(舰队)":

> **"Don't worry it'll take 3 months until it's there. We'll be talking about fleets that design your loops then."**
> （别急,3 个月后我们就该聊"设计你的循环的舰队"了)——逐字引用

> **"I have my claw supervising my codex'es."**
> （我让我的 claw 去监督我的那些 codex)——逐字引用

**这里已经埋下全部伏笔**:Steinberger 嘴里的 "loop" 从一开始就 **不是 LLM 内部那个 agentic 循环**,而是 **外层的、人去编排的自动化层**——一个 agent 监督另一群 agent。这与 Cherny 后面说的"harness"几乎是同一个东西,只是名字不同。

---

## 二、Loop 到底是什么:把这个被滥用的概念讲透(硬核区)

要理解这场嘴仗为什么发生,必须先承认一个事实:**"loop" 在 agentic coding 语境里至少有三个互不相同的含义,而吵架的人很少声明自己说的是哪一个。**

### 2.1 第一层:内层 Agentic Loop(模型循环 / the canonical agent)

这是最经典、最"硬"的定义。一个 coding agent 的本质,就是一个 **带工具调用的 while 循环**。Braintrust 工程负责人 Ankur Goyal 在《The canonical agent architecture: A while loop with tools》(2025-08)里给出了被广泛引用的"标准答案"——他明确点名 **Claude Code 与 OpenAI Agents SDK 都是这个结构**(已核实,逐字引用代码):

```typescript
while (!done) {
  const response = await callLLM();
  messages.push(response);
  if (response.toolCalls) {
    messages.push(
      ...(await Promise.all(response.toolCalls.map((tc) => tool(tc.args)))),
    );
  } else {
    messages.push(getUserMessage());
  }
}
```

> **"That's it. Each iteration passes the current state into a language model, receives back a decision (usually a tool invocation or text response), and moves forward. The agent is just a system prompt and a handful of well-crafted tools."**
> —— Ankur Goyal / Braintrust(逐字引用)

用一句话概括这一层:**模型 → 工具调用 → 观察结果 → 再决策 → 直到完成。** 这就是 agentic loop 的全部。它惊人地简单——简单到 Goyal 直言"许多框架不过是给一个 while 循环套上了更好的营销话术"(Reddit/r/LLMDevs 上同期流行的说法:*"The loop itself is trivial. Most frameworks are just selling you a while loop with better marketing."*,逐字)。

**关键洞察**:正因为内层 loop 如此 trivial(平凡),Goyal 强调真正的功夫全在循环之外——**工具设计(tool design)、上下文工程(context engineering)、评估(evaluation)**。他引用数据:在典型 agent 对话里,**工具的输入输出占了约 80% 的 token(tool responses 67.6% + tool definitions 10.7%),system prompt 只占 3.4%**(逐字数据)。换句话说:**loop 是骨架,真正决定 agent 强弱的是骨架上挂的肉。** 这一点是后面理解"为什么有人说 loop 是 easy part"的钥匙。

OpenClaw 官方文档对这层也有正式定义(已核实):

> **"An agentic loop is the full 'real' run of an agent: intake → context assembly → model inference → tool execution → streaming replies → persistence."**
> —— OpenClaw Docs / Agent loop(逐字引用)

### 2.2 第二层:外层编排 Loop(Loop Engineering / "设计驱动 agent 的循环")

这正是 Steinberger 那条推文里的 "loop"。它 **不在模型内部**,而在模型外部、由人(或更高层的 agent)编写的 **自动化编排层**:你不再坐在终端手敲 prompt,而是写一段程序/脚本/调度,让它周期性地、带目标地去 prompt 一个或多个 agent,自动收集结果、自动决定下一步。

社区里典型的"外层 loop"实践,在爆款推文的回复区就有人晒出(已核实,逐字摘录):

> "My basic agent loop is this: 1. Organize my to do list: pull in context from email, slack, github, and linear... 2. Walk through the to do list... ask what to do 3. I delegate a sub-agent... 4. ...check on the ones that finished... I tried a more automated version where I skipped step '2', but eventually it resulted in a lot of slop, so I think the human decision step is still pretty useful."

注意最后一句——**连实践者自己都承认:把人完全踢出循环,结果是"a lot of slop"(一堆垃圾)。** 这是整场论战中最诚实、也最容易被口号掩盖的一条经验数据。

另一个被广泛引用的同源技术是 **"Ralph Wiggum / Ralph loop" 技术**:利用 Claude Code 的 Stop hook(当 Claude 试图结束会话时触发的钩子)把 agent 强行"踹回"循环,让它持续干活(来源:codewithandrea 2026-01 newsletter、LinkedIn"Agent Harnessing"一文,均提及该机制)。这说明 **外层 loop 的可靠性高度依赖底层工具暴露出的 hook/控制点**——又一次指向"loop 之外才是难点"。

### 2.3 第三层:元层 Harness(脚手架 / "驱动循环的循环")

当外层 loop 本身也变得复杂、需要被系统化管理时,它就升格成了 **harness(脚手架)**。这是 Cherny 抛出的抽象,也是与团队另一份研究《Harness Engineering》直接接榫的地方。Rajiv Shah 的定义(2026-05,已核实,逐字):

> **"2023 — RAG, long context. 2024 — tools, skills, MCP. And now, in 2026, the outermost layer — the harness — is where the action is."**

学术界也已跟进:arXiv 2604.25850《Agentic Harness Engineering》(2026-04)把 harness 形式化为 **"a closed loop"**(一个闭环)——注意,**连最严肃的论文都把 harness 定义成一种 loop**。这正是术语坍缩的最佳证据:**当所有层都叫 "loop" 时,这个词就什么都不是了。**

### 2.4 一张图看懂三层(及"谁在说哪一层")

| 层级 | 名称 | 含义 | 谁在这一层发言 | 难度 |
|------|------|------|----------------|------|
| 内层 | **Agentic Loop** | LLM→工具→观察→决策 的 while 循环 | Goyal、Cherny(说它 trivial) | 简单(刻意保持简单) |
| 外层 | **编排 Loop / Loop Engineering** | 人写程序去自动 prompt agent 群 | **Steinberger** | 中等,易产 slop |
| 元层 | **Harness** | 管理/进化这些循环的系统 | **Cherny**、Rajiv Shah、学术界 | 难(2026 的新前沿) |

**这张表就是整场嘴仗的解剖图:Steinberger 站在"外层"喊口号,Cherny 站在"元层"往上指,而群嘲者站在"内层"说"这不就是个 while 循环吗"。三方都没错,只是站在不同楼层。**

---

## 三、论战双方:他们到底说了什么、立场在哪

> ⚠️ **取证说明**:本节力求一手引用。**Steinberger 的核心推文**经 Digg 聚合页逐字转录,可信度高;**Cherny 的"抽象阶梯"**目前最强证据来自 @sairahul1 转述的 X 长文卡片(下方标注),**属"广泛转引的二手转述",未能拿到 Cherny 本人原帖逐字截图**,故以"据转述"标注。两人**并非互相 @ 对骂**——这场"vs."很大程度上是 Van Horn 在文章里把两种立场 **并置/对照** 而成的框架,而非一场指名道姓的对喷。这一点必须对读者诚实交代。

### 3.1 关键人物身份核实(重要,已尽力查准)

- **Peter Steinberger(@steipete)**:PSPDFKit 创始人(已退出),资深 iOS 开发者,近一两年 All-in AI coding 的高产内容创作者。**OpenClaw 的创造者**(其个人站 steipete.me 与多处来源一致)。**身份变动(已核实):2026 年 2 月,他在博客《OpenClaw, OpenAI and the future》(2026-02-14)宣布加入 OpenAI"把 agent 带给所有人",OpenClaw 转入基金会保持开源独立。** 故本报告涉及他时,职位应表述为"OpenClaw 创造者 / 2026 年 2 月起加入 OpenAI"。

- **Boris Cherny(@bcherny)**:**Claude Code 的创造者 / Anthropic"Head of Claude Code"**(多源一致:Latent.Space 播客、Lenny's Podcast、LinkedIn 本人页 linkedin.com/in/bcherny、个人站 borischerny.com)。**人才流动核实(重要,易写错):据 Lenny's Podcast 节目章节描述,Cherny 曾"briefly left Anthropic for Cursor"(短暂离开 Anthropic 去了 Cursor)"and what brought him back"(又回来了)——即 2026 年的状态是 **已回归 Anthropic、仍是 Claude Code 负责人**。** 切勿写成"现在在 Cursor"。他公开称自己今年的代码"100% 由 AI(Claude Code)写成",且"今年没有亲手写过一行代码"(来源:Lenny's / AI Ascent 2026,经 LinkedIn、YouTube 章节佐证)。

- **Matt Van Horn(@mvanhorn)**:连续创业者,据其 GitHub 简介:联合创办 June("self-driving oven",被 Weber 收购)与"后来成为 Lyft 的公司";开源项目 **last30days(27k★)**、Printing Press(4.2k★)。本文主角文章《WTF Is a Loop?》即由他用自研的 `/last30days` 复盘工具产出。**他是这场风波的"复盘者/史官",不是当事方。**

### 3.2 Steinberger 的立场:极简派 + "把自己踢出循环"

Steinberger 的主张一以贯之(综合其推文串 + 个人博客标题,如《Claude Code is My Computer》《Commanding Your Claude Code Army》《My Current AI Dev Workflow》):

1. **手动 prompt 已过时**——"you shouldn't be prompting coding agents anymore"(逐字)。
2. **价值在于设计外层循环**——让 agent 自动被驱动,人退到"设计者"位置。
3. **进一步是 fleet/舰队**——一个 agent 监督一群 agent("I have my claw supervising my codex'es",逐字)。
4. **极简哲学**:他长期主张 CLI-first、把工具做薄(如其 Peekaboo 2.0 "Free the CLI from its MCP shackles")。在他眼里,**loop 不需要重型框架,需要的是把人从重复劳动里解放出来。**

他在另一条被 Tavily 抓到的串里说得更直白(逐字):

> **"the jump from 'write me a function' to 'design the feedback loop that writes the functions' is where most people stall out for about six months."**
> （从"给我写个函数"跃迁到"设计那个能写函数的反馈循环",是大多数人卡住约半年的地方)

**一句话立场:Loop 是终点,极简是美德,人应该站在循环之外当设计者。**

### 3.3 Cherny 的立场:loop 只是中间站,harness 才是 2026

据 @sairahul1 转述的 Cherny X 长文(广泛转引的二手转述,未拿到本人原帖逐字):

> **"The next transition is coming this year. 2023: you wrote the code. 2024: you prompted Claude to write the code. 2025: you wrote loops that prompted Claude. 2026: you build the harness that runs the loops. Each transition, the engineers who understood the new abstraction first moved ahead permanently."**
> —— 据 @sairahul1 转述 Boris Cherny(二手转述,标注存疑)

与此同时,Cherny 关于 **Claude Code 本身的设计哲学是出了名的极简**。Latent.Space 播客里他最被引用的一句(已核实,逐字):

> **"Claude Code is not a product as much as it's a Unix utility."**

播客作者进一步总结其团队信条:**"do the simple thing first"**——无论是记忆实现(就是一个自动加载的 markdown 文件)还是 prompt 摘要(就是让 Claude 自己总结),都"挑最小、可用、可扩展的积木"(已核实,逐字转述)。

**这就是 Cherny 立场的精妙之处,也是误读的根源**:
- 在 **内层(agentic loop)**,他是 **极简主义者**——agent 就是个 while 循环 + Unix 小工具,别搞复杂。
- 在 **系统层面**,他又指向 **harness 工程**——真正的复杂度和价值正在从"写循环"上移到"建造驱动循环的脚手架"。

**一句话立场:内层 loop 要极简(它是 easy part),但 2026 的竞争发生在 loop 之上的 harness 层。**

### 3.4 所以,他们真在"对立"吗?

**不全是。** 把两人摆在一起看:
- Steinberger 说"去设计 loop(外层编排)" ≈ Cherny 说"2025: you wrote loops that prompted Claude"。**他俩在描述同一件事。**
- 真正的"温差"在于 **下一步指向哪里**:Steinberger 把外层 loop/fleet 当作主战场和身份(极简、个人英雄、把人踢出循环);Cherny 则说 loop 只是 2025 的抽象,**2026 要往上走到 harness**,暗示"光会写 loop 还不够"。

换句话说,Van Horn 标题里的"vs."更像是 **"极简口号 vs. 系统抽象"的张力**,而非人身对喷。Reddit/r/openclaw 上一个高赞帖标题精准捕捉了这层(已核实):**"Claude Code shows why the agent loop is the easy part"**(Claude Code 证明了 agent 循环才是简单的那部分)。

---

## 四、这场嘴仗为什么重要:极简 Loop 派 vs. Harness 工程派

剥掉术语,这场争论暴露的是 agentic coding 领域一条 **真实的方法论断层线**:

### 4.1 两种世界观

**极简派(Loop Minimalism)**——代表:Steinberger、Goyal 的"canonical while loop"、Cherny 谈内层时的"Unix utility"。
- 信条:**Agent 本质是个聪明的 loop,别过度工程化。** 模型越来越强,你该"let them do more, not less"(爆款推文回复区原话,逐字)。
- 赌注:押在 **模型能力的指数级增长** 上——今天需要脚手架兜住的,明天更强的模型自己就兜住了(即"The Bitter Lesson"在 agent 设计上的延伸,Goyal 明确引用)。
- 风险:把人踢出循环 = "a lot of slop"(实践者自述);无限 loop = 烧钱(负面阵营 42.4% 的核心吐槽:**高 token 成本只有大预算玩家玩得起**)。

**工程派(Harness Engineering)**——代表:Cherny 的"build the harness"、Rajiv Shah、arXiv 2604.25850。
- 信条:**模型固然强,但"系统决定 agent 表现"**(Rajiv Shah 文章副标题:"Why the System Around the Model Decides Agent Performance",逐字)。价值正从模型/loop 上移到 **harness**:可观测性、组件化、任务编排、错误恢复。
- 赌注:押在 **工程杠杆** 上——同样的模型,更好的 harness 能多榨出一个数量级的可靠性(arXiv 论文用"observability-driven automatic evolution"佐证)。
- 风险:**重新发明 framework 的复杂度**,以及 Goyal 警告的"很多团队最终发现简单方案在生产里更可靠"。

### 4.2 这不是新冲突,是老冲突的新一轮

这场嘴仗本质上是软件工程史上反复上演的 **"简单 vs. 框架" / "约定 vs. 配置" / "UNIX 小工具 vs. 大教堂"** 之争,在 agentic coding 时代的复现。有趣的是:**Cherny 一个人就同时站在两边**——他用极简哲学造了 Claude Code(内层),却又预言 harness(元层)是下一个战场。这恰恰说明:**极简与工程不是对立,而是分层。** 内层保持极简,复杂度被"挤"到边缘(工具设计、上下文工程、harness),这正是 Goyal 说的"absorbs complexity at the edges while keeping the core understandable"(逐字)。

### 4.3 与团队《Harness Engineering》研究的呼应(关键接榫)

**Loop 是极简派的口号,Harness 是工程派的答卷,二者描述的是同一条价值迁移曲线的两端。**
- "Loop Engineering"这个词,在爆款推文回复区就被网友顺手接进了进化链:**Context Engineering → Harness Engineering → Intent Engineering → Loop Engineering**(逐字)。
- Cherny 的阶梯则把顺序讲成:**code → prompt → loop → harness**。
- 两条链都指向同一个终局:**人不断向上抽象,从"写代码"退到"写循环",再退到"建造驱动循环的系统"。** 这正是 Harness Engineering 研究的核心命题。

> **建议团队在两份报告间互相链接**:本报告负责讲清"loop 的术语坍缩与极简派立场",Harness 报告负责讲清"元层系统如何工程化"。二者拼起来,才是 2026 agentic coding 方法论的完整地图。

---

## 五、社区反应:大家怎么站队

**情感大盘(已核实数据,来自 Digg 对 Steinberger 爆款帖的聚合):正面 57.6% / 负面 42.4%**,接近五五开——这本身就说明它是个争议性 buzzword 而非共识。

**正面阵营(认同"循环>手动 prompt"):**
- "This is the ultimate shift from 'prompt engineering' to 'process engineering.'"(逐字,Digg 聚合)
- "the real leverage is treating them like a component in an automated pipeline."(逐字)
- "boris is a loop master 👀"(逐字)——把 Cherny 当作这套打法的标杆。

**负面/质疑阵营(反感术语 / 戳破炒作):**
- **"Writing loops that prompt the model is just prompt engineering with extra steps."**(逐字,@rohanpaul_ai 风格回复)——直指这是"换皮的 prompt engineering"。
- **"The loop itself is trivial. Most frameworks are just selling you a while loop with better marketing."**(逐字,r/LLMDevs)——技术派的祛魅。
- **成本质疑**:"you kinda still need to be in the loop to test stuff unless you literally have infinite tokens"(逐字)——无限 loop 烧 token,普通人玩不起。
- **slop 警告**:实践者亲测"跳过人类决策步骤 → a lot of slop"(逐字)。

**中间/建设性:**
- 有人把它接进术语进化链(Context→Harness→Intent→Loop Engineering),试图给它一个体系位置。
- Reddit/r/openclaw 高赞标题 **"Claude Code shows why the agent loop is the easy part"** 成为"祛魅派"的旗帜。
- r/ClaudeAI 帖《Loops are the future - Boris Cherny creator of claude code in podcast》引发"我也想留在 loop 里"(Except I want to be part of the loop,逐字)的人本主义反弹。

**一句话社区画像:技术老手祛魅("不就是 while 循环"),实践者务实("跳过人会出 slop"),布道者亢奋("process engineering 革命"),旁观者疲惫于又一个 buzzword。**

---

## 六、判断与洞察(不只搬运)

### 6.1 这是不是一场伪命题?——部分是

**"Steinberger vs. Cherny"在严格意义上是一场被建构出来的对立**:没有证据显示两人指名对喷,更像 Van Horn 把"极简口号"与"系统抽象"两种立场并置成戏剧冲突(这是优秀的内容产品手法,但读者应知情)。真正的"伪命题成分"在于:**当 'loop' 同时指三样东西时,争论双方根本没在反驳对方。** 这是典型的 **术语坍缩导致的鬼打墙**。

### 6.2 但它指向的分歧是真的

剥掉术语后,真问题是清晰且重要的:**Agent 的价值杠杆,在模型/内层 loop,还是在外层编排/harness?** 我的判断:

1. **内层 loop 确实 trivial,且应保持 trivial。** Goyal 与 Cherny 在这点上是对的——Claude Code 用一个 Unix 小工具式的 while 循环就打穿了市场,证明 **核心架构越简单越耐用**(模型一升级,复杂脚手架就贬值)。
2. **但 trivial 不等于 unimportant 的反面**:难度被挤到了边缘——**工具设计、上下文工程、harness**。说"loop 是 easy part"的人和说"loop 是一切"的人,其实都对了一半:**loop 本体简单,但围绕 loop 的工程不简单。**
3. **Steinberger 的"把自己踢出循环"是方向正确、剂量危险的处方。** 实践数据(slop、token 成本、"还得留在循环里测")反复证明:**2026 年的现实是 human-in-the-loop 仍是可靠性的压舱石。** 完全自动化是愿景,不是当下的默认配置。

### 6.3 对开发者的实践启示

- **别买"框架税"**:从一个 while 循环 + 几个好工具起步,真有瓶颈再加复杂度(Goyal 的"path through complexity")。
- **把精力投在边缘**:80% 的 token 来自工具 I/O——**优化工具的输入输出格式,比调 prompt 性价比高得多。**
- **外层 loop 要带"人类决策闸门"**:跳过它=slop。先做"半自动"(agent 跑、人在关键节点裁决),再逐步收紧。
- **盯住 harness 这一层**:这是 2026 真正的增量战场,也是与团队 Harness 研究衔接的落点。
- **警惕 token 经济学**:无限 loop 是大预算玩家的游戏;中小团队要为"循环"设预算上限与熔断。

### 6.4 极简 Loop 派 与 Harness 工程派 会怎么收敛?

**我的预测:收敛于"极简内核 + 可进化外壳"。**
- **内层**永远保持 while-loop 式极简(被 Bitter Lesson 强制——模型进步会持续吃掉中间层复杂度)。
- **外层/元层**会工程化、产品化为 **harness**(可观测、可回滚、自动进化——arXiv 2604.25850 已是早期形态)。
- 两派的口号之争会平息,因为大家会意识到 **它们是同一栈的不同层**。最终胜出的不是"loop 派"或"harness 派",而是 **同时尊重"核心要薄、边缘要厚"这条铁律的人。** Cherny 一人横跨两层,恰是这个收敛形态的预演。

---

## 七、取证与可信度声明(对外发布必读)

| 关键事实 / 引语 | 可信度 | 来源 |
|------|--------|------|
| Steinberger 爆款推文逐字("...designing loops that prompt your agents") | **高(逐字)** | Digg AI 聚合页对该 X 帖的转录,4.7M views,2026-06-07 |
| 评论区"Context→Harness→Intent→Loop Engineering"等回复 | **高(逐字)** | 同上 Digg 聚合 |
| Goyal 的 while-loop 代码与"agent is just a system prompt + tools" | **高(逐字)** | braintrust.dev/blog/agent-while-loop(2025-08) |
| token 占比 80% / 67.6% / 3.4% 数据 | **高(逐字)** | 同上 Braintrust |
| OpenClaw 官方 agentic loop 定义 | **高(逐字)** | docs.openclaw.ai/concepts/agent-loop |
| Cherny "code→prompt→loop→harness" 抽象阶梯 | **中(二手转述,存疑)** | @sairahul1 转述 Cherny X 长文卡片;**未获 Cherny 本人原帖逐字** |
| Cherny "Claude Code is a Unix utility" / "do the simple thing first" | **高(逐字)** | Latent.Space 播客文章 |
| Cherny 曾短暂去 Cursor 又回 Anthropic、仍是 Claude Code 负责人 | **中高** | Lenny's Podcast 节目章节描述(YouTube/Lenny's newsletter) |
| Steinberger 2026-02 加入 OpenAI、OpenClaw 转基金会 | **高** | steipete.me 博客《OpenClaw, OpenAI and the future》2026-02-14 |
| Van Horn 文章结论"stop being the thing in the loop. Write the loop." | **高(逐字)** | Tavily 抓取的该 X 长文片段 |
| Van Horn 身份(June/Lyft 联创、last30days 作者) | **高** | github.com/mvanhorn 简介 |
| 情感 57.6%/42.4% | **高** | Digg 聚合统计 |

**未能证实/需谨慎之处(如实标注):**
1. **Van Horn 长文全文未取到**(x.com/i/article 正文被 X 反爬挡住,浏览器在沙箱内启动超时)。本报告的论战脉络是 **基于 Steinberger 推文串 + Cherny 二手转述 + 各方公开发言重建**,文章的开头导语与结尾金句为逐字,中段论证为合理推断。
2. **Cherny 的"harness 阶梯"原帖**未拿到一手截图,目前依赖 @sairahul1 的转述卡片;若要对外发布,建议补一张 Cherny 本人原帖截图再下定论。
3. **"Steinberger vs. Cherny"的"对立"性质** 系 Van Horn 框架,非实证的指名对喷——报告中已明确区分。
4. 本环境为 2026 年情境,部分平台数据(浏览量、stars)取自聚合页,数量级可信,精确值可能随时间漂移。

> **底线**:本报告所有带引号的"逐字"内容均来自上述可追溯来源;凡推断均已标注"综合/推断/据转述"。**未对任何人物虚构言论。**

---

## 八、延伸阅读(一手源)

- Steinberger 爆款帖聚合:digg.com/ai/7ifyvmb9
- Cherny harness 阶梯(转述):x.com/sairahul1/status/2063547299167711308
- Braintrust《The canonical agent architecture: A while loop with tools》
- OpenClaw Docs · Agent loop:docs.openclaw.ai/concepts/agent-loop
- Latent.Space《Claude Code: Anthropic's Agent in Your Terminal》
- Lenny's Podcast《Head of Claude Code: What happens after coding is solved》
- Rajiv Shah《Harness Engineering》(2026-05)
- arXiv 2604.25850《Agentic Harness Engineering》
- steipete.me《OpenClaw, OpenAI and the future》(2026-02-14)
- Van Horn 原文:x.com/i/article/2063850827694096385(《WTF Is a Loop? Peter Steinberger vs. Boris Cherny》)

---

*报告完 · 黄山 · 2026-06-09 · 配套主题见《Harness Engineering》研究*
