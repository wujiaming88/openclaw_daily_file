# 全球 AI Agent 基础设施研究周报 · 第 8 期（2026-07-30 ~ 2026-08-05）

> 日期：2026-08-06  
> 覆盖区间：2026-07-30 00:00 → 2026-08-05 24:00（Asia/Shanghai）  
> 框架：Agent Harness 8 个能力栈模块

## 时间窗与本期主线

本期覆盖区间为 **2026-07-30 00:00 → 2026-08-05 24:00（Asia/Shanghai）**。本期周报已按新版框架执行：不再按厂商类型分组，而是按 **8 个 Agent Harness 能力栈模块** 组织，分别追踪控制层、运行时、执行环境、工具网关、身份权限、上下文记忆、可观测治理与企业平台控制面。

本周主线很清楚：Agent 基础设施正在从“能跑起来”转向“可恢复、可隔离、可授权、可审计、可评估、可计费”。AWS、Google、Microsoft 开始把 Runtime / Gateway / Identity / Observability 打成企业平台控制面；OpenViking、Mem0、Cognee、supermemory、Firecrawl、Crawl4AI 等高热项目则把 Memory / Context / Knowledge 变成独立基础设施模块；OpenClaw 的机会在开放 Agent OS 与多渠道 runtime，补课点在统一 Gateway 权限、trace schema、runtime health 与企业审计表达。

## 模块质量门控

- 第①关｜模块覆盖：通过，8/8 Harness 模块完整覆盖。
- 第②关｜平台矩阵：通过，AWS / Google / Microsoft / 阿里云 / 火山或字节 / 腾讯云 / Databricks 覆盖 7/7。
- 第③关｜GitHub 热度补漏：通过，完成 9 个查询方向；OpenViking / Cognee / supermemory / Crawl4AI / Mem0 / Letta / Zep-Graphiti / Firecrawl / E2B / Browserbase / Langfuse 等均进入对应模块或观察池。
- 第④关｜原文深度：通过，抽查 AWS AgentCore Gateway、Google Agent Gateway、Nango v0.71.3、OpenViking、Langfuse/Phoenix 5 类对象，URL 与正文对齐。
- 第⑤关｜判断质量：通过，每个模块均有模块洞察；TOP5 按基础设施信号价值排序。
- 第⑥关｜数据可信：通过，关键数据附 URL + 日期或标注“背景/非本周/未公开”；GitHub stars/forks 以 hot-scan/GitHub API 或页面直查为准。
- 第⑦关｜Identity / Auth / Permission：通过，OAuth/OIDC/MCP auth、token 托管、用户授权、tool permission、审计日志、越权与泄露防护均覆盖。
- 第⑧关｜OpenClaw 参照：通过，覆盖 OpenClaw 在 Agent OS、sessions/cron/Gateway、Memory、Browser/Sandbox、Tool permission、Observability 的机会与补课点。

## GitHub 热度补漏扫描

本期 hot scan 覆盖 9 个查询方向：`agent memory github`、`agent context database github`、`agent knowledge graph github`、`AI agent RAG memory skills github`、`MCP gateway github`、`agent auth permission OAuth MCP github`、`browser agent runtime github`、`agent observability eval github`、`agent harness runtime github`。

明确补入 / 强制检查对象包括：OpenViking、Cognee、supermemory、Crawl4AI、Mem0、Letta、Zep/Graphiti、Firecrawl、Composio、Arcade、Nango、Browserbase/Stagehand、E2B、Langfuse、AgentOps。过滤方向为 awesome-list、教程合集、纯模板和无基础设施模块定位项目。

### Hot scan 原始结果

#### GitHub 热度补漏扫描（2026-08-05 周报）

- 时间窗：2026-07-30 00:00 → 2026-08-05 24:00 Asia/Shanghai
- 查询方向：agent memory；agent context database；agent knowledge graph；AI agent RAG memory skills；MCP gateway；agent auth permission OAuth MCP；browser agent runtime；agent observability eval；agent harness runtime
- 数据源：GitHub Search API + GitHub Repos API（stars/forks/updated_at/pushed_at 直查）
- 补入标准：高 stars / 近周活跃 / 明确 Agent Harness 模块定位 / 社区引用；过滤 awesome-list、教程、模板、纯应用。

## Sandbox / Computer Use / Browser

| Repo | Stars | Forks | Updated | Pushed | 命中查询 | 说明 | URL |
|---|---:|---:|---|---|---|---|---|
| browserbase/stagehand | 23737 | 1633 | 2026-08-05T18:36:26Z | 2026-08-06T01:54:06Z | critical-list | The SDK For Browser Agents | https://github.com/browserbase/stagehand |

## Tool Gateway / Protocol / Integration

| Repo | Stars | Forks | Updated | Pushed | 命中查询 | 说明 | URL |
|---|---:|---:|---|---|---|---|---|
| e2b-dev/E2B | 13267 | 981 | 2026-08-06T01:36:43Z | 2026-08-05T17:08:13Z | critical-list | Open-source, secure environment with real-world tools for enterprise-grade agents. | https://github.com/e2b-dev/E2B |
| NangoHQ/nango | 11361 | 1242 | 2026-08-06T01:41:06Z | 2026-08-05T23:44:31Z | critical-list | Build product integrations with AI. | https://github.com/NangoHQ/nango |

## Context / Memory / Knowledge

| Repo | Stars | Forks | Updated | Pushed | 命中查询 | 说明 | URL |
|---|---:|---:|---|---|---|---|---|
| affaan-m/ECC | 238032 | 36151 | 2026-08-06T02:00:44Z | 2026-08-05T22:17:10Z | agent memory | The agent harness performance optimization system. Skills, instincts, memory, security, and research-first development for Claude Code, Code | https://github.com/affaan-m/ECC |
| firecrawl/firecrawl | 161777 | 9122 | 2026-08-06T02:02:57Z | 2026-08-05T21:35:01Z | critical-list | The context API to search, scrape, and interact with the web at scale. 🔥 | https://github.com/firecrawl/firecrawl |
| bytedance/deer-flow | 79371 | 10838 | 2026-08-06T02:03:25Z | 2026-08-05T09:57:14Z | agent memory | An open-source long-horizon SuperAgent harness that researches, codes, and creates. With the help of sandboxes, memories, tools, skill, suba | https://github.com/bytedance/deer-flow |
| unclecode/crawl4ai | 76297 | 7891 | 2026-08-06T02:03:39Z | 2026-07-30T13:51:44Z | critical-list | 🚀🤖 Crawl4AI: Open-source LLM Friendly Web Crawler & Scraper. Don't be shy, join here: https://discord.gg/jP8KfhDhyN | https://github.com/unclecode/crawl4ai |
| ruvnet/ruflo | 67129 | 8012 | 2026-08-06T01:19:29Z | 2026-08-05T06:09:57Z | agent memory | 🌊 The original agent meta-harness. Deploy intelligent multi-player swarms, coordinate autonomous workflows, and build conversational AI syst | https://github.com/ruvnet/ruflo |
| mem0ai/mem0 | 62613 | 7303 | 2026-08-06T01:51:35Z | 2026-08-05T18:44:42Z | agent memory | Universal memory layer for AI Agents | https://github.com/mem0ai/mem0 |
| HKUDS/nanobot | 46689 | 8255 | 2026-08-06T01:54:46Z | 2026-08-05T12:04:32Z | agent memory | Ultra-lightweight, open-source, self-hosted personal AI agent framework in Python with WebUI, tools, memory, MCP, multi-agent workflows, aut | https://github.com/HKUDS/nanobot |
| zhayujie/CowAgent | 46348 | 10295 | 2026-08-06T01:56:25Z | 2026-08-05T12:43:49Z | agent memory | Open-source super AI assistant & Agent Harness. Plans tasks, runs tools and skills, self-evolves with memory and knowledge. Multi-model, mul | https://github.com/zhayujie/CowAgent |
| pingcap/tidb | 40388 | 6226 | 2026-08-05T21:03:56Z | 2026-08-06T01:45:00Z | agent memory | TiDB is built for agentic workloads that grow unpredictably, with ACID guarantees and native support for transactions, analytics, and vector | https://github.com/pingcap/tidb |
| langchain-ai/langgraph | 38991 | 6565 | 2026-08-06T01:59:56Z | 2026-08-06T01:43:08Z | critical-list | Build resilient agents. | https://github.com/langchain-ai/langgraph |
| tinyhumansai/openhuman | 36004 | 3573 | 2026-08-06T01:50:29Z | 2026-08-05T19:28:56Z | agent memory | Your Personal AI super intelligence. A brain that builds a local-first memory of your life, a fantastic orchestrator of agent fleets and wor | https://github.com/tinyhumansai/openhuman |
| topoteretes/cognee | 29800 | 2882 | 2026-08-06T01:52:31Z | 2026-08-05T17:01:26Z | critical-list | Cognee is the open-source AI memory platform for agents. Give your AI agents persistent long-term memory across sessions with a self-hosted  | https://github.com/topoteretes/cognee |
| getzep/graphiti | 29597 | 2991 | 2026-08-06T00:53:01Z | 2026-08-05T07:38:13Z | critical-list | Build Real-Time Knowledge Graphs for AI Agents | https://github.com/getzep/graphiti |
| ComposioHQ/composio | 29554 | 4698 | 2026-08-06T01:42:22Z | 2026-08-05T20:32:35Z | critical-list | Composio powers 1000+ toolkits, tool search, context management, authentication, and a sandboxed workbench to help you build AI agents that  | https://github.com/ComposioHQ/composio |
| supermemoryai/supermemory | 28787 | 2509 | 2026-08-06T01:02:17Z | 2026-08-05T20:03:45Z | critical-list | Memory and context engine + app that is extremely fast, scalable, and can be run fully locally. The Memory API for the AI era. | https://github.com/supermemoryai/supermemory |

## Observability / Eval / Guardrails

| Repo | Stars | Forks | Updated | Pushed | 命中查询 | 说明 | URL |
|---|---:|---:|---|---|---|---|---|
| langfuse/langfuse | 32586 | 3496 | 2026-08-06T02:00:43Z | 2026-08-06T00:47:27Z | critical-list | 🪢 Open source AI engineering platform: LLM evals, observability, metrics, prompt management, playground, datasets. Integrates with OpenTelem | https://github.com/langfuse/langfuse |
| AgentOps-AI/agentops | 5751 | 613 | 2026-08-05T13:56:59Z | 2026-06-25T08:25:03Z | critical-list | Python SDK for AI agent monitoring, LLM cost tracking, benchmarking, and more. Integrates with most LLMs and agent frameworks including Crew | https://github.com/AgentOps-AI/agentops |

## 本期明确补入 / 强制检查对象

- OpenViking: GitHub API 未直接命中，交由对应模块用 web_search/web_fetch 补查。
- Cognee: topoteretes/cognee（29800 stars / 2882 forks / updated 2026-08-06T01:52:31Z）→ Context / Memory / Knowledge；https://github.com/topoteretes/cognee
- supermemory: supermemoryai/supermemory（28787 stars / 2509 forks / updated 2026-08-06T01:02:17Z）→ Context / Memory / Knowledge；https://github.com/supermemoryai/supermemory
- Crawl4AI: unclecode/crawl4ai（76297 stars / 7891 forks / updated 2026-08-06T02:03:39Z）→ Context / Memory / Knowledge；https://github.com/unclecode/crawl4ai
- Mem0: mem0ai/mem0（62613 stars / 7303 forks / updated 2026-08-06T01:51:35Z）→ Context / Memory / Knowledge；https://github.com/mem0ai/mem0
- Letta: letta-ai/letta（24102 stars / 2565 forks / updated 2026-08-06T00:49:51Z）→ Context / Memory / Knowledge；https://github.com/letta-ai/letta
- Zep: getzep/graphiti（29597 stars / 2991 forks / updated 2026-08-06T00:53:01Z）→ Context / Memory / Knowledge；https://github.com/getzep/graphiti
- Graphiti: getzep/graphiti（29597 stars / 2991 forks / updated 2026-08-06T00:53:01Z）→ Context / Memory / Knowledge；https://github.com/getzep/graphiti
- Firecrawl: firecrawl/firecrawl（161777 stars / 9122 forks / updated 2026-08-06T02:02:57Z）→ Context / Memory / Knowledge；https://github.com/firecrawl/firecrawl
- Composio: ComposioHQ/composio（29554 stars / 4698 forks / updated 2026-08-06T01:42:22Z）→ Context / Memory / Knowledge；https://github.com/ComposioHQ/composio
- Arcade: ArcadeAI/arcade-mcp（994 stars / 104 forks / updated 2026-08-05T17:47:15Z）→ Context / Memory / Knowledge；https://github.com/ArcadeAI/arcade-mcp
- Nango: NangoHQ/nango（11361 stars / 1242 forks / updated 2026-08-06T01:41:06Z）→ Tool Gateway / Protocol / Integration；https://github.com/NangoHQ/nango
- Browserbase: browserbase/stagehand（23737 stars / 1633 forks / updated 2026-08-05T18:36:26Z）→ Sandbox / Computer Use / Browser；https://github.com/browserbase/stagehand
- E2B: e2b-dev/E2B（13267 stars / 981 forks / updated 2026-08-06T01:36:43Z）→ Tool Gateway / Protocol / Integration；https://github.com/e2b-dev/E2B
- Langfuse: langfuse/langfuse（32586 stars / 3496 forks / updated 2026-08-06T02:00:43Z）→ Observability / Eval / Guardrails；https://github.com/langfuse/langfuse
- AgentOps: AgentOps-AI/agentops（5751 stars / 613 forks / updated 2026-08-05T13:56:59Z）→ Observability / Eval / Guardrails；https://github.com/AgentOps-AI/agentops

## 过滤对象样例

## 本期 TOP 5

1. **AWS AgentCore 把 Harness 六件套平台化。** Runtime、Gateway、Identity、Browser/Code、Memory、Observability 被组合成可配置企业控制面，dedicated microVM per session、8 小时长任务、MCP/A2A、OAuth 与 CloudWatch trace 形成完整生产 workload 叙事。

2. **MCP 2026-07-28 RC 与网关跟进。** MCP 进入新 revision 候选，AWS AgentCore Gateway、Google Agent Gateway、Google mcp-toolbox 都在围绕多版本协议、MCP attributes、Model Armor、healthz 与 toolsets 做生产化。

3. **Memory 层从向量库走向 Context Database。** OpenViking 用 `viking://`、L0/L1/L2、检索轨迹和 OpenClaw 集成把 memory/knowledge/skills 合成 Context DB；Mem0、Cognee、supermemory、Zep/Graphiti 则分别补 agent/user 归因、ingestion、skills 与 temporal graph。

4. **Browser/Sandbox 进入策略治理期。** E2B 本周补 BYOC、base image reproducibility、PTY/env/workdir 和 MCP 类型；Stagehand 加 domain allow/block policy、CUA fixes、MCP safe logging、截图 media evidence。

5. **Agent Identity 成为云厂正式控制对象。** AWS AgentCore Identity、Microsoft Entra Agent Identity、Google Agent identity/SPIFFE/IAP/Model Armor 都把 agent 视为可授权、可撤销、可审计的独立主体，而不是“拿用户 API key 的脚本”。


## 五条趋势主线

- **控制层**：OpenClaw、LangGraph、Microsoft Agent Framework、Google ADK 都在补 session replay、checkpoint、deployment packaging、approval 和安全边界，Harness 正从 SDK 变成控制平面。

- **运行时与沙箱**：AgentCore、E2B、Stagehand、Daytona 的信号说明 runtime 竞争已深入到 microVM、filesystem persistence、BYOC、domain policy、screenshot evidence 与 stream lifecycle。

- **工具与身份**：MCP/A2A 标准化叠加 Gateway/Identity，使工具调用从 function calling 变成受 IAM、OAuth、MFA、audit、Model Armor 约束的企业流量。

- **记忆与知识**：Context Database、Memory API、Temporal KG、Web context API 同时升温，Agent memory 开始要求来源、归因、权限、过期、检索轨迹与技能沉淀。

- **平台化竞争**：AWS 最完整，Google 在 Agent Gateway/Registry/Observability 强，Microsoft 强在 Entra/Copilot/Foundry 互联，阿里/火山/腾讯用订阅套餐、OpenViking、ADP/CloudBase 抢国内 agent workload。


---

## Harness / Agent OS 控制层

- 时间窗：2026-07-30 00:00 → 2026-08-05 24:00（Asia/Shanghai）。
- 口径：只有窗口内公开发布、文档更新、release、commit 或安全披露写入“本周动态”；旧能力只标“背景，非本周”。

## Harness / Agent OS 控制层

### 本周模块结论
- 本周最强信号不是“又多了一个 Agent 框架”，而是 Harness 进入生产工程化：OpenClaw 的状态安全/分支会话/自动化命名、Microsoft Agent Framework 的可重放 checkpoint 和持久 session store、LangGraph 的 checkpoint 修复，都在解决长期任务的可恢复性。
- 云厂与模型厂正在把 Harness 从 SDK 下沉为“可运营控制层”：OpenAI 用更低价的 GPT-5.6 Luna/Terra 与 Fast mode 降低多步工具调用成本；AWS AgentCore harness（详见模块 8）把模型、工具、memory、identity、observability 做成配置。
- 安全边界成为 Agent OS 的第一等公民：Google ADK 仓库自动化被披露存在“受信 bot 身份桥接”风险；OpenClaw release 同期修复 approvals、channel allowlist、secret redaction、session export 边界等问题。
- 对 OpenClaw 的参照：OpenClaw 继续领先在“真实多通道 Agent OS”与自托管 runtime，但云厂开始把同样的 sessions / tools / memory / observability 作为托管平台能力打包；OpenClaw 需要把安全审计、标准化 tool gateway、可解释 tracing 做成默认体验。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenClaw | 有动态：v2026.7.1-2 发布；releases 页含 2026.7.2 pre-release 大量 Harness 能力；GitHub 直查 385,267 stars / 80,986 forks | GitHub API 2026-08-06；https://github.com/openclaw/openclaw/releases；https://github.com/openclaw/openclaw/releases/tag/v2026.7.1-2 | 是 |
| OpenAI Agents SDK / Responses API | 有动态：GPT-5.6 Luna/Terra 降价、Sol Fast mode；Codex/ChatGPT desktop 任务与自定义 agent 模型迁移提示；官方 Terraform provider（窗口前一日，背景） | https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/；https://openai.com/products/release-notes；https://developers.openai.com/api/docs/models/gpt-5.6-luna；https://developers.openai.com/api/docs/models/gpt-5.6-terra | 是 |
| Anthropic Claude Agent SDK / MCP | 有生态动态：Claude Agent SDK 的 session / hook / subagent / MCP 能力被外部 Memory 层集成分析；官方 SDK 仓库页面直读；未见 Anthropic 官方窗口内重大 release | https://github.com/anthropics/claude-agent-sdk-python；https://mem0.ai/blog/persistent-memory-for-claude-agents-sdk | 是 |
| LangChain / LangGraph / LangSmith | 有动态：LangGraph checkpoint-sqlite 3.1.1（2026-07-30）与 LangChain core 1.5.3；GitHub 直查 LangGraph 38,991 stars / 6,565 forks、LangChain 143,515 stars / 23,913 forks | https://github.com/langchain-ai/langgraph/releases/tag/checkpointsqlite%3D%3D3.1.1；https://github.com/langchain-ai/langchain/releases/tag/langchain-core%3D%3D1.5.3 | 是 |
| Google ADK | 有动态：ADK Python 仓库 CI agent 工作流安全披露（本周文章/复核）；非产品 release；GitHub API 因限流未取得 stars/forks | https://thehackernews.com/2026/08/google-deletes-3-adk-ai-workflows-after.html | 是 |
| Microsoft Agent Framework / Semantic Kernel / AutoGen | 有动态：Agent Framework releases 页显示 1.13.0（2026-07-30）与后续 .NET 1.17.0；Semantic Kernel 首页确认 MAF 成为企业级继任者 | https://github.com/microsoft/agent-framework/releases；https://github.com/microsoft/semantic-kernel | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 本周未见明确 release；文档层面继续呈现 AI Playground、Agent Bricks、MCP tools、MLflow Tracing、Unity Catalog Agent services 的平台化组合（背景/文档补查） | https://docs.databricks.com/aws/en/agents/custom-agents/build-agents | 否 |

### 动态池 / 补漏对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| CrewAI AMP / Studio / crewAI | 有动态：crewAI 1.15.12（2026-08-05）发布，含 URLReadTool、platform action tools metadata、统一 scaffolding | https://github.com/crewAIInc/crewAI/releases/tag/1.15.12；GitHub API 56,660 stars / 8,079 forks | 是 |
| Dify Agent Runtime | 有动态：Dify agent runtime backend 修复 E2B shellctl readiness；GitHub API 151,469 stars / 23,909 forks | https://github.com/langgenius/dify/commit/1369a2c | 是 |
| n8n | 有动态：n8n@2.33.4（2026-08-05）修复 task broker / task runners；GitHub API 199,494 stars / 59,934 forks | https://github.com/n8n-io/n8n/releases/tag/n8n%402.33.4 | 是 |
| Flowise | 静默：latest release flowise@3.1.4 发布于 2026-07-29 15:51 UTC（上海时间仍在窗口前），本周仅少量安全/bug commits；不写为本周动态 | GitHub API；https://github.com/FlowiseAI/Flowise/releases/tag/flowise%403.1.4 | 否 |

### 深度笔记

#### OpenClaw
- 本周动态：OpenClaw 在 2026-08-04 发布 `v2026.7.1-2`；GitHub API 直查显示 2026-08-06 时点为 385,267 stars / 80,986 forks，最近窗口内 commits 包括 2026-08-05 的 `fix(ci): preserve stdin through Docker heartbeat logging`、Android active session sidebar、以及 `refactor(openai): simplify ChatGPT OAuth credential flow`。releases 页同时展示 2026.7.2 pre-release 的核心方向：状态安全与恢复、durable channel delivery、session rewind/branching、Interactive MCP Apps and dashboards、structured questions/approvals、meetings/realtime Talk、local inference、Automations 命名、DuckDuckGo 插件边界、以及安全授权修复。尤其是“session rewind and branching”与“durable channel delivery”把 Agent OS 从单轮聊天推向“可回放、可分支、可跨渠道恢复”的控制层；“Automations naming”把 cron/scheduler 的用户心智上移为更产品化的 automation 控制面；MCP Apps 与 dashboards 则说明工具协议正在进入可交互 UI 容器，而不只是 backend function call。
- 关键数据：385,267 stars / 80,986 forks（GitHub API 直查，2026-08-06）；latest release `v2026.7.1-2` published 2026-08-04T00:41:26Z；窗口内 sample commits：113af2f、238c8bf、3ec8af6（GitHub API 直查）。
- 原文链接：https://github.com/openclaw/openclaw/releases；https://github.com/openclaw/openclaw/releases/tag/v2026.7.1-2
- 影响判断：OpenClaw 是本周模块内最完整的 Agent OS 参照：sessions、automations、approvals、MCP Apps、channels、memory、browser、plugins 都在一个自托管 gateway 中闭环。压力来自 AWS/Microsoft/Google 正在把同类能力托管化；OpenClaw 的机会是保持开放插件与多模型/多渠道优势，同时把 release 中已经出现的安全边界和审计能力显性产品化。

#### OpenAI Agents SDK / Responses API
- 本周动态：OpenAI 2026-07-30 官方宣布 GPT-5.6 Luna/Terra 降价与 Sol Fast mode。原文明确 Luna 降价 80%、Terra 降价 20%；API pricing 为 Terra $2/M input、$12/M output，Luna $0.20/M input、$1.20/M output；Sol Fast mode 替代 Priority Processing，提供最高 2.5× 标准处理速度、价格为 2 倍，且旧 `priority` 标记自动映射。模型文档显示 Luna/Terra 都支持 Responses API、Batch、streaming、structured outputs、function calling、file_search、web_search、prompt caching，并在 Responses API 下支持 `web_search`、`file_search`、`image_generation`、`code_interpreter`、`hosted_shell`、`apply_patch`、`skills`、`computer_use`、`mcp`、`tool_search`。OpenAI release notes 还提示 2026-07-31 Codex 中 GPT-5.4/GPT-5.4 mini 将在 8 月 31 日退役，并要求更新 workspace defaults、managed configurations、custom agents、scheduled tasks；这说明 OpenAI 已把“agent 配置资产”作为需要治理迁移的对象。
- 关键数据：Luna input $0.20/M、cached input $0.02/M、output $1.20/M；Terra input $2/M、cached input $0.20/M、output $12/M；两者 context window 1,050,000，max input 922,000，max output 128,000；Sol Fast mode up to 2.5×，2× price（OpenAI 官方，2026-07-30）。
- 原文链接：https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/；https://openai.com/products/release-notes；https://developers.openai.com/api/docs/models/gpt-5.6-luna；https://developers.openai.com/api/docs/models/gpt-5.6-terra
- 影响判断：这不是单纯模型降价，而是对多步 agent loop 成本结构的直接压缩：低价模型可承担实施、测试、检索等大量工具步骤，高价模型用于规划与不确定性消解。对 OpenClaw 的启发是需要把“按步骤动态选模 + 成本/延迟 tracing + scheduled task 配置迁移”做成 Harness 控制层能力。

#### Anthropic Claude Agent SDK / MCP
- 本周动态：未发现 Anthropic 官方在时间窗内发布 Claude Agent SDK/MCP 重大 release；但 Mem0 在 2026-07-31 发布文章，围绕 Claude Agents SDK 说明其 session state 与 persistent user memory 的边界，属于生态侧对 Agent SDK 生产缺口的明确补位。Mem0 文中指出 SDK 暴露 Python/TypeScript 接口，提供 `Read`、`Write`、`Edit`、`Glob`、`Grep`、`Bash`、`WebSearch`、`WebFetch`、`Monitor`、`AskUserQuestion` 等工具，允许通过 `ClaudeAgentOptions(allowed_tools=[...])` 控制可用/自动批准工具；hooks 覆盖 `PreToolUse`、`PostToolUse`、`PostToolUseFailure`、`Stop`、`SubagentStart`、`SubagentStop`、`PreCompact`、`UserPromptSubmit`、`Notification`、`PermissionRequest`；subagents 可通过 `AgentDefinition` 定义；MCP servers 可接外部系统。官方 GitHub README 直读也确认 Python SDK 自动捆绑 Claude Code CLI，并支持 in-process SDK MCP server、custom tools、hooks、permissions。Mem0 的核心判断是：SDK 的 `SessionStore` 管理一次 run/session 内上下文，但没有用户身份维度、跨 session 用户记忆需要外部层。
- 关键数据：Mem0 页面显示 GitHub Star 62,590（页面内）；Claude Agent SDK GitHub 搜索显示约 7.8k stars / 1.2k forks（GitHub API 因全局限流未复核，需后续复查）；文章 published Aug 5 UTC / 页面正文标 Jul 31, 2026，均在窗口内。
- 原文链接：https://github.com/anthropics/claude-agent-sdk-python；https://mem0.ai/blog/persistent-memory-for-claude-agents-sdk
- 影响判断：Claude Agent SDK 把“Agent loop + tool permissions + hooks + subagents + MCP”留在开发者进程内，控制权强但持久身份/跨会话记忆需外部设施。对 OpenClaw 的参照是：OpenClaw 已有 memory/session 体系，应清晰区分 session replay、user memory、workspace memory，并提供 MCP/skills 的细粒度 permission hooks。

#### LangChain / LangGraph / LangSmith
- 本周动态：LangGraph 在 2026-07-30 发布 `langgraph-checkpoint-sqlite==3.1.1`，核心修复是 `checkpoint-postgres, checkpoint-sqlite` 的 namespace matching 限定到 segment boundaries；LangChain 同日发布 `langchain-core==1.5.3`，修复 core fallback to `LANGSMITH_API_KEY` for gateway。GitHub API 直查显示 LangGraph 38,991 stars / 6,565 forks，LangChain 143,515 stars / 23,913 forks；窗口内 LangChain commits 包括 `fix(langchain): prevent orphaned tool_calls in ToolCallLimitMiddleware end behavior`、model profile refresh、Bedrock mantle aliases；LangGraph commits 主要是依赖与 examples 更新。虽然 release 看似小，但 checkpoint 命名空间边界、tool_calls 中止行为、gateway API key fallback 都是生产 Agent Harness 常见故障点：状态隔离、工具调用终止一致性、观测/网关凭证兜底。
- 关键数据：LangGraph latest release `checkpointsqlite==3.1.1` published 2026-07-30T19:19:47Z；LangChain latest release `langchain-core==1.5.3` published 2026-07-30T14:56:10Z；GitHub stars/forks 如上（GitHub API 直查，2026-08-06）。
- 原文链接：https://github.com/langchain-ai/langgraph/releases/tag/checkpointsqlite%3D%3D3.1.1；https://github.com/langchain-ai/langchain/releases/tag/langchain-core%3D%3D1.5.3
- 影响判断：LangGraph 的护城河仍是“可恢复图执行 + checkpoint + deployment/observability 生态”，正在成为开源 Harness 的事实基座之一。OpenClaw 可吸收其 checkpoint/store/checkpointer 设计，但需要保持自身在多渠道 sessions、cron/automations、tool runtime 上的端到端优势。

#### Google ADK
- 本周动态：本周不是 ADK 正常 release，而是安全披露。The Hacker News 2026-08-04 报道称 Google 删除 ADK Python 仓库中的 3 个 AI agent workflows；Pillar Security 展示公共 GitHub issue 可 prompt-inject triage agent，使其以 `adk-bot` 发出 `/adk-issue-fix`，从而触发受 collaborator gate 保护的 privileged code-fixing agent。文章称研究者证明可在 CI runner 上任意代码执行并外泄 bot PAT；受影响的是 repository automation，不是分发的 ADK Python package。细节包括 public `issue-analyze.yml` 自动处理 issue、使用 ADK_GCP_SA_KEY / ADK_TRIAGE_AGENT / GOOGLE_API_KEY 调用 Antigravity coding agent；`issue-fix.yml` 检查发命令者是否 owner/member/collaborator，但没有识别“外部文本诱导受信 bot 发命令”的授权桥接问题。Google 删除 workflow 的 commit metadata 作者日期在 6 月 9 日，Pillar 称 7 月 2 日已验证缺失、Google 7 月 21 日确认修复；THN 8 月 4 日复核主分支无相关文件。
- 关键数据：3 个 workflow（issue-analyze.yml、issue-fix.yml、pr-analyze.yml）；THN 发布时间 2026-08-04；修复确认 2026-07-21（报道引用）；未发现窗口内 ADK package release 数据。
- 原文链接：https://thehackernews.com/2026/08/google-deletes-3-adk-ai-workflows-after.html
- 影响判断：这条动态说明 Agent Harness 的身份边界不能只看“谁发出了命令”，还要看命令是否由不可信内容间接生成。OpenClaw 的 approval IDs、channel allowlists、tool requests、subagent outputs 都应默认采用“不可由模型文本伪造的授权信号”，并把 bot identity 与 privileged workflow identity 分离。

#### Microsoft Agent Framework / Semantic Kernel / AutoGen
- 本周动态：Microsoft Agent Framework releases 页显示 1.13.0 于 2026-07-30 发布，包含一组非常 Harness 化的能力：Foundry hosting 中为 MCP sources 增加 bounded in-memory archive skill discovery，并通过 FoundryToolbox 暴露 archive controls；hosting/Responses/Telegram 等组件增加 reusable session stores，并持久化完整 Foundry Responses sessions；全框架增加 process-wide feature-usage telemetry 与 first-party User-Agent reporting；OpenAI provider 增加 cache-write token usage 到 observability；OpenAI 支持 Responses API 的 ephemeral per-request instructions；AG-UI/Core 将 workflow checkpoints 改为可从 initial input 与 human-in-the-loop responses 完整 replay。fix 部分覆盖 MCP header_provider、approval decisions across Responses API continuations、function-call/result compaction 原子性、FoundryToolbox credentials reconnect、FileSystemAgentFileStore 拒绝 Windows junctions 等。Semantic Kernel 首页同时明确：Semantic Kernel is now Microsoft Agent Framework，MAF 是企业级继任者，1.0 production-ready，支持多 agent orchestration、多 provider、A2A 和 MCP。
- 关键数据：MAF release `1.13.0` dated 2026-07-30；后续 releases 页还显示 .NET 1.17.0 变更（窗口内/临近）；GitHub API 因全局限流未取得 stars/forks，GitHub 页面已直读 release 原文。
- 原文链接：https://github.com/microsoft/agent-framework/releases；https://github.com/microsoft/semantic-kernel
- 影响判断：Microsoft 正把 AutoGen/Semantic Kernel 的历史资产整合成“企业可重放、可观测、可托管”的 Agent Framework，并把 Foundry hosting / Copilot Studio / MCP / A2A 串起来。OpenClaw 需要重点关注其 replayable checkpoint、approval continuation、credential reconnect 三类生产细节。

#### Databricks Mosaic AI Agent Framework / Agent Bricks
- 本周动态：本周未确认窗口内官方 release；作为背景，Databricks agents 文档展示其 Agent Platform 结构：AI Playground 用于 no-code 原型，Knowledge Assistant 与 Supervisor Agent 属于 Agent Bricks；custom agents 支持 LangGraph、LangChain、OpenAI、LlamaIndex 并集成 MLflow Tracing；MCPs and agent tools 提供结构化/非结构化数据、代码运行、外部 API 连接；Unity Catalog Agent services（Beta）用于注册、发现与授权；MLflow Tracing、Agent Evaluation、production monitoring 用于调试、评估与审计。
- 关键数据：官方文档未在抓取正文中展示明确更新时间；搜索命中显示约 3 days ago，未作为强日期证据使用。
- 原文链接：https://docs.databricks.com/aws/en/agents/custom-agents/build-agents
- 影响判断：Databricks 的差异化不在通用 Harness API，而在“数据/模型/工具/agent 都进 Unity Catalog 与 MLflow 治理面”。对 OpenClaw 的启发是：企业控制层最终会要求 agent、tools、skills、memory、datasets 全部有 catalog、权限与 lineage。

#### CrewAI AMP / Studio / crewAI（补漏）
- 本周动态：crewAI 1.15.12 于 2026-08-05 发布。release notes 包含：新增 `URLReadTool` 读取任意 URL；为 platform action tools 添加 app metadata；将 scaffolding 统一到 `crewai create <resource>`；修复 conversational route/handler name collision errors；更新 scaffold AGENTS.md。GitHub API 直查显示 crewAI 56,660 stars / 8,079 forks，窗口内 commits 多为 CI/CodeQL 与 release 相关。虽然这不是完整 managed control plane，但 URL 读取工具、platform action metadata、统一资源创建 CLI 都属于 Agent Harness 工具/资源声明层的基础设施信号。
- 关键数据：release 1.15.12 published 2026-08-05T22:56:34Z；GitHub stars/forks 如上（API 直查）。
- 原文链接：https://github.com/crewAIInc/crewAI/releases/tag/1.15.12
- 影响判断：CrewAI 正从多 agent workflow 框架补齐平台化开发体验。OpenClaw 可参考其 `create <resource>` 的低摩擦 scaffold，但更关键是把资源定义落到 skills/plugins/approvals 的统一 schema。

#### Dify Agent Runtime（补漏）
- 本周动态：Dify 在 2026-08-05 commit `1369a2c` 修复 `dify-agent: wait for E2B shellctl readiness`。diff 直读显示在 `dify_agent.runtime_backend.e2b` 测试中新增对 transient shellctl failures 的重试：ReadTimeout、ConnectError 后等待 0.5s，最多三次；503 starting 会重试后关闭 transport 并 pause sandbox；401 unauthorized 不重试；并在 close/pause 失败时保留 primary health failure。这属于非常典型的 Agent Runtime 生产化补丁：不是“会调 E2B”即可，而是要正确处理 sandbox shell control plane 尚未就绪、权限错误、资源清理与错误传播。GitHub API 直查 Dify 151,469 stars / 23,909 forks，最近 release 1.16.1 于 2026-07-28（窗口外）。
- 关键数据：commit 1369a2c dated 2026-08-05T11:03:06Z；Dify stars/forks 如上（API 直查）。
- 原文链接：https://github.com/langgenius/dify/commit/1369a2c
- 影响判断：Dify 的 Agent Runtime 正接近真正执行层问题：sandbox readiness、lease/release、workspace preservation。OpenClaw 的 runtime 也应把 browser/code/shell 的 readiness 和 recoverability 暴露为 traceable state，而不是隐藏在 tool error 中。

#### n8n（补漏）
- 本周动态：n8n@2.33.4 于 2026-08-05 发布，主要修复 task broker 与 task runner 韧性：`Improve task broker resilience when a runner dies`、`Recover unresponsive task runners`，并跳过 AI Assistant 中 redundant workflow edit approval。GitHub API 直查显示 n8n 199,494 stars / 59,934 forks；窗口内 commits 还包括 `Show Agent references in credential usage` 与 package import conflict policy 等。虽然 n8n 常被视为 workflow automation，但这次 release 的 task runner/broker 恢复与 AI Assistant approval 流程直接触及基础设施层：Agentic workflow 一旦进入生产，worker 死亡、runner 不响应、编辑审批重复都会成为可靠性/安全问题。
- 关键数据：release `n8n@2.33.4` dated 2026-08-05；GitHub stars/forks 如上（API 直查）。
- 原文链接：https://github.com/n8n-io/n8n/releases/tag/n8n%402.33.4
- 影响判断：n8n 的价值在于把 agent 与传统 workflow runner 接轨。对 OpenClaw 的参照是 automations/cron 不能只关注调度语义，也要补齐 runner health、dead letter、approval 去重、credential usage 引用追踪。

### 静默对象说明
- Flowise：latest release 在窗口前；本周未见基础设施级 release，静默。
- Databricks：本周未见明确 release；作为企业控制层背景保留，不写入“本周动态”。

### 模块洞察
- Harness / Agent OS 层正在从“开发者 SDK”进入“可恢复、可审计、可托管的控制平面”；开源框架在灵活性和生态扩展上仍快，云厂在 identity、observability、runtime isolation、governance 打包上追得很猛。OpenClaw 的战略位是开放 Agent OS，但必须把安全授权信号、session replay、tool/runtime health、成本 tracing 做成默认标准件。


---

## Runtime / Session / State 执行层

- 时间窗：2026-07-30 00:00 → 2026-08-05 24:00（Asia/Shanghai）。
- 口径：窗口内动态写入“本周动态”；窗口外能力只作为背景。

## Runtime / Session / State 执行层

### 本周模块结论
- 本周 runtime 层的最强信号来自 AWS AgentCore：Runtime 被定义为安全、serverless、purpose-built 的 agent/tool hosting environment，支持 dedicated microVM per session、最长 8 小时长任务、persistent filesystem、100MB payload、WebSocket 双向流、MCP/A2A 协议与内建身份/观测。
- Google 与 Microsoft 的路线更偏企业平台 runtime：Gemini Enterprise 在 2026-08-04 补 connector end-to-end tracing、2026-08-01 PAYG GA；Microsoft Foundry Agent Service 从 classic agents 迁到 GA service，并与 Copilot Studio standard harness 连接。
- 开源/独立执行层中，E2B 与 Stagehand 本周高频 release/commit 都集中在“session/worker 可用性”：E2B 处理 BYOC volume routing、sandbox create/connect 参数、base image reproducibility；Browserbase/Stagehand 处理 domain policy、CUA keypress、MCP integration logging、snapshot UTF-16 修复。
- 对 OpenClaw 的参照：OpenClaw sessions/cron/Gateway 已具备长期任务与多渠道 runtime 形态，但需要把 session isolation、runtime health、filesystem persistence、版本端点、dead runner 恢复与成本计量做成显式控制面。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore Runtime | 有动态/强文档信号：dedicated microVM per session、8 小时长任务、persistent filesystem、100MB payload、MCP/A2A、WebSocket | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agents-tools-runtime.html | 是 |
| Google Vertex AI Agent Engine / Managed Agents API | 有动态：Gemini Enterprise 2026-08-04 data connector tracing；2026-08-01 PAYG GA；Agent Platform runtime/gateway/registry 背景 | https://docs.cloud.google.com/gemini/enterprise/docs/release-notes | 是 |
| Microsoft Foundry Hosted Agents / Foundry Agent Service | 有动态：Copilot Studio 2026-08-03 连接 Foundry agent；Foundry classic agents 迁移到 GA Foundry Agents Service | https://learn.microsoft.com/en-us/microsoft-copilot-studio/add-agent-foundry-agent；https://learn.microsoft.com/en-us/azure/ai-foundry/agents/quickstart | 是 |
| 阿里云百炼 / Model Studio / PAI Agent 托管能力 | 有动态：百炼记忆库商业化；AgentScope 2.0 作为 Managed Agents Harness/Runtime 底座 | https://help.aliyun.com/zh/model-studio/memory-library；https://developer.aliyun.com/article/1753134 | 是 |
| 火山方舟 Ark / Coze / Coze Studio 运行时能力 | 有动态/背景：OpenViking hosted on Volcano Engine / BytePlus global hosting；Coze/Ark 本周未抓到足够官方 release | https://github.com/volcengine/OpenViking；https://docs.byteplus.com/en/docs/ModelArk/2165245 | 是 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 有动态：ADP Agentic RAG 2026-08-04；CloudBase 资源点价格 2026-08-03 | https://cloud.tencent.com/document/product/1759/132211；https://cloud.tencent.com/document/product/876/127357 | 是 |
| OpenClaw sessions / cron / Gateway runtime | 有动态：v2026.7.1-2 与 2026.7.2 pre-release 展示 sessions、cron/automations、durable channel delivery、state safety | https://github.com/openclaw/openclaw/releases | 是 |
| E2B / Modal / Daytona | E2B 有动态；Daytona 本周静默但近背景强；Modal 本周未发现 release | https://github.com/e2b-dev/E2B/releases；https://github.com/daytonaio/daytona/releases；https://github.com/modal-labs/modal-client/releases | 是/否 |

### 深度笔记

#### AWS Bedrock AgentCore Runtime
- 本周动态：AWS 文档把 AgentCore Runtime 定义为“secure, serverless and purpose-built hosting environment for deploying and running AI agents or tools”。关键能力非常明确：framework agnostic，可把任意本地 agent code 以少量代码变成 cloud-native deployment，兼容 LangGraph、Strands、CrewAI 与自定义 agent；model flexibility 支持 Bedrock、Anthropic Claude、Google Gemini、OpenAI；protocol support 支持 MCP 与 A2A；每个用户 session 运行在 dedicated microVM，CPU、memory、filesystem 隔离，session 完成后 microVM 终止并清理 memory，防止跨 session 污染；long-running workload 可达 8 小时；filesystem state 可跨 stop/resume 持久化；计费按 consumption-based pricing，对 I/O wait 这类等待 LLM 响应的时段尽量不按 CPU 活跃处理计费；payload 可达 100MB；支持 HTTP API 与 persistent WebSocket 双向流。
- 关键数据：最长执行 8 小时；payload 100MB；每用户 session dedicated microVM；支持 HTTP 与 WebSocket；原文列出 Runtime topics 包括 isolated sessions、long running agents、filesystem configurations、versioning/endpoints、shell execution、runtime observability。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agents-tools-runtime.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-getting-started.html
- 影响判断：AgentCore Runtime 是本周 runtime 层“生产 workload 化”的最完整样本。对 OpenClaw 的启发是 sessions/cron 不只是调度，还需要默认提供隔离、恢复、版本端点、文件系统持久化与 runtime observability；威胁是 AWS 可以把这些能力打包进企业采购路径。

#### Google Vertex AI Agent Engine / Managed Agents API
- 本周动态：Google 本周在 Gemini Enterprise release notes 中补齐 runtime 可观测与商业化信号：2026-08-04 为 data connector workflow 增加 end-to-end tracing，新增 `execute_tool` 与 `invoke_connector` 两个 trace spans，把 assistant prompt 到第三方 API 的 parent-child workflow 串起来；2026-08-01 Gemini Enterprise Pay-as-you-go edition GA，取消 pooled user license quotas，按 feature usage 付费，要求 invoiced Cloud Billing account 与 one-seat minimum，并可在 Cloud Console 监控 feature usage、设置 monthly spend limits。Agent Gateway 文档还说明 managed agent runtimes 与 Gemini Enterprise 会自动把 agent traffic 路由 through Agent Gateway。
- 关键数据：两个新 spans：`execute_tool`、`invoke_connector`；PAYG GA date 2026-08-01，一 seat minimum；Agent Gateway governed paths 包括 Client-to-Agent 与 Agent-to-Anywhere，Gateway 每实例可 govern up to 5,000 resources in Agent Registry。
- 原文链接：https://docs.cloud.google.com/gemini/enterprise/docs/release-notes；https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview
- 影响判断：Google runtime 的核心不是单一 SDK，而是 Agent Registry / Gateway / Observability / Billing 把 agent workload 放进企业控制面。OpenClaw 可学习其 assist token / W3C trace ID 查询方式，把长期 session 与 connector 调用串成可追踪链路。

#### Microsoft Foundry Hosted Agents / Foundry Agent Service
- 本周动态：Microsoft Copilot Studio 文档 2026-08-03 更新，支持连接 Microsoft Foundry agent（preview），让 Copilot Studio custom agent 调用外部 Foundry agent。Foundry quickstart 显示 classic agents deprecated，迁移到 GA Microsoft Foundry Agents Service；Copilot Studio 文档强调这些能力由 standard harness 驱动，并要求外部 agent 具备 data flows/data handling、quality/security/trustworthiness、permissions/boundaries/approvals、observability/identity/traceability/human oversight。Foundry agent identity 文档 updated_at 为 2026-07-31，说明 Foundry 自动 provision/manage agent identities，tool call 时通过 Entra ID token exchange 获得 downstream resource scoped access token。
- 关键数据：Copilot Studio doc updated 2026-08-03；Foundry classic agents retire 2027-03-31；Agent identity doc updated 2026-07-31；Microsoft Foundry 通过 agent identity blueprint + agent identity + scoped token request 实现 runtime tool auth。
- 原文链接：https://learn.microsoft.com/en-us/microsoft-copilot-studio/add-agent-foundry-agent；https://learn.microsoft.com/en-us/azure/ai-foundry/agents/quickstart；https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity
- 影响判断：Microsoft 把 runtime/session 放进 Copilot Studio + Foundry + Entra 的企业通道，强调身份、审批、人类监督与 traceability。OpenClaw 若要作为企业外部 agent，需要暴露可注册 endpoint、权限说明、approval 边界与 trace export。

#### 阿里云百炼 / Model Studio / PAI Agent 托管能力
- 本周动态：百炼记忆库文档显示 2026-08-20 10:00 开始商业化计费，虽然主动态在 Memory 层，但它直接影响 runtime：任意应用可通过 API 接入记忆库，多应用可共享同一记忆库，`AddMemory` / `SearchMemory` 可嵌入 agent runtime。阿里云开发者社区 2026-08-04 文章把 AgentScope 2.0 定位为 Managed Agents 的 Harness/Runtime 底座，强调 Harness 内核、Sandbox 隔离和 Runtime 组件协作。
- 关键数据：记忆片段/用户画像规则各最多 50 条；记忆过期可选 7 天、30 天、180 天、永不过期；限流总计 3000 QPM、add 120 QPM、search 300 QPM；AgentScope runtime 示例依赖 `agentscope-runtime`。
- 原文链接：https://help.aliyun.com/zh/model-studio/memory-library；https://developer.aliyun.com/article/1753134
- 影响判断：阿里本周信号说明国内云厂 runtime 正把 memory/agent runtime/sandbox 组合成托管能力，而非只卖模型调用。OpenClaw 可参考其规则、过期、QPM 与调试界面，把 memory/runtime 配置从代码迁到控制台。

#### 火山方舟 Ark / Coze / Coze Studio
- 本周动态：本周未抓到 Coze/Coze Studio 运行时层的高质量官方 release；可深写的字节/火山 runtime 信号来自 OpenViking 的 hosted service。OpenViking README 显示其 Personal 版本托管在 Volcano Engine in China，并规划 BytePlus global hosting service、private distributed enterprise edition / BYOC；它同时支持 OpenClaw、Claude Code、Codex、MCP clients、LangGraph 等 agent runtime 集成。火山 ModelArk FAQ 文档 2026-08-03 更新但抓取正文不足，不作为具体结论来源。
- 关键数据：OpenViking Helper 0.0.19；OpenViking 0.3.22 benchmark 数据见模块 6/8；托管路径包括 Volcano Engine 与 BytePlus global hosting 规划。
- 原文链接：https://github.com/volcengine/OpenViking；https://docs.byteplus.com/en/docs/ModelArk/2165245
- 影响判断：火山/字节本周 runtime 参照更像“context runtime + agent integration host”，不是通用 sandbox runtime。对 OpenClaw 的机会是把 OpenViking 作为外置 context runtime 接入，同时保留本地 sessions/cron/Gateway。

#### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit
- 本周动态：腾讯云 ADP 的 Agentic RAG 文档 2026-08-04 更新，配置在 Claw / Multi-Agent 模式应用中作为 `AgenticRAGSearch` 工具，支持反思模型、重排序模型、知识检索范围与反思轮数；CloudBase 资源点价格文档 2026-08-03 更新，把 AI 调用、知识库容量、身份认证、审计日志、组织成员、工作流/云函数/云托管纳入套餐/资源点控制面。
- 关键数据：Agentic RAG 反思轮数 0-10，默认 3；CloudBase 资源点换算 1000:1；AI 调用 10 点/万次，知识库容量 10 点/GB/天；免费体验版 3000 点/月，企业高级版 6,500,000 点/月。
- 原文链接：https://cloud.tencent.com/document/product/1759/132211；https://cloud.tencent.com/document/product/876/127357
- 影响判断：腾讯 runtime 的特点是与应用托管、低代码和套餐计费绑定。OpenClaw 可以借鉴“反思轮数/成本/延迟”这种 runtime 参数显式化，让决策者能在质量与成本之间做黑白决策。

#### OpenClaw sessions / cron / Gateway runtime
- 本周动态：OpenClaw v2026.7.1-2 与 2026.7.2 pre-release 显示 sessions、cron/Automations、Gateway runtime、channels、MCP Apps、approval、state safety、session rewind/branching、durable channel delivery 等集中更新。尤其是 session rewind/branching 与 durable channel delivery，说明 OpenClaw 正把长期任务从“单次对话”推向可回放、可分支、可跨渠道恢复的 Agent OS runtime；Automations 命名与 Gateway runtime 则把 cron、tool runtime、channel delivery 进一步产品化。
- 关键数据：OpenClaw GitHub API 直查 385,267 stars / 80,986 forks（2026-08-06）；latest release v2026.7.1-2 published 2026-08-04T00:41:26Z。
- 原文链接：https://github.com/openclaw/openclaw/releases；https://github.com/openclaw/openclaw/releases/tag/v2026.7.1-2
- 影响判断：OpenClaw 在真实 Agent OS runtime 上领先，但 runtime 的可靠性边界需要从“能调度”升级为“任务完成事件一定可回投、状态可恢复、超时有降级路径”。

#### E2B / Modal / Daytona
- 本周动态：E2B releases 本周非常活跃，包含 BYOC cluster volume content routing、Fedora/Alpine/Arch base-image helpers、Python/JS SDK base image defaults 对齐、MCP server option closed TypedDict、`e2b sandbox create/connect` 新增 `--user`、`--cwd`、`--env`，以及 sandbox RPC layer 迁到 official Connect RPC client。hot-scan 直查 E2B 13,267 stars / 981 forks / updated 2026-08-06 / pushed 2026-08-05。Daytona releases 本周无新版本，近背景 0.190.0（2026-06-23）已包括 pause action、sandbox domain allow list、OTel config、computer use docs、Datadog OTel 指南；Modal GitHub releases 页面显示没有 releases，本周未深写。
- 关键数据：E2B hot-scan 13,267 stars / 981 forks；E2B release 文本列出 e2b@2.37.0、2.36.1 等；Daytona latest release 0.190.0 为窗口外背景；Modal releases 页面“there aren’t any releases here”。
- 原文链接：https://github.com/e2b-dev/E2B/releases；https://github.com/daytonaio/daytona/releases；https://github.com/modal-labs/modal-client/releases
- 影响判断：E2B 的本周补丁说明 sandbox runtime 的真实竞争在 BYOC、base image reproducibility、PTY/env/workdir、stream cleanup、MCP 类型约束。OpenClaw 的 code/shell/browser runtime 应把这些低层参数提升为可审计配置，而不是隐藏在工具调用实现里。

### 模块洞察
- Runtime / Session / State 层正在从“API 调用容器”升级为“有身份、有隔离、有长任务、有持久状态、有版本端点、有观测计费的 agent workload runtime”。云厂在企业控制面领先，E2B/Browserbase 等独立基础设施在执行细节领先，OpenClaw 的机会是把自有 sessions/cron/Gateway 经验产品化为开放 runtime 标准件。


---

## Sandbox / Computer Use / Browser 执行环境层

## Sandbox / Computer Use / Browser 执行环境层

### 本周模块结论
- 本周执行环境层最强信号是“浏览器/代码/终端环境开始具备 policy 与 observability 语义”：Stagehand 加 domain allow/block policy、popup 自动关闭、CUA image payload mediaType、Google Gemini 3.5 Flash computer-use tools model 支持；E2B 补 BYOC、base image、PTY/env/workdir 与 MCP 类型。
- 云厂侧，AWS AgentCore 把 Browser、Code Interpreter、Runtime shell/filesystem 纳入同一 AgentCore 能力集；Google 侧通过 Agent Gateway、Model Armor、Cloud Trace 约束 MCP/tool 访问；Microsoft Foundry 通过 code interpreter 与 Entra agent identity 管住工具调用。
- 安全重点从“沙箱是否隔离”扩展到“沙箱能访问哪些域名、谁提供凭据、截图/快照是否可追踪、工具行为能否回放”。
- 对 OpenClaw 的参照：OpenClaw browser/computer use 需要默认输出可回放 session、domain policy、credential boundary、screenshot evidence、tool outcome telemetry，才能支撑生产审核。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| E2B | 有动态：BYOC volume routing、base image helpers、sandbox create/connect flags、MCP option types、RPC cleanup | https://github.com/e2b-dev/E2B/releases | 是 |
| Browserbase / Stagehand | 有动态：domain policy、CUA fixes、MCP integrations safe logging、Gemini computer-use tools model | https://github.com/browserbase/stagehand/releases | 是 |
| Daytona | 静默/近背景：0.190.0 含 pause、sandbox domain allow list、OTel、computer use docs | https://github.com/daytonaio/daytona/releases | 否 |
| Modal | 静默：modal-client releases 页面无 release；本周未见 agent sandbox 基础设施级动态 | https://github.com/modal-labs/modal-client/releases | 否 |
| OpenAI Computer Use / Browser / Code Interpreter | 有动态/背景：GPT-5.6 模型文档继续列出 `computer_use`、`code_interpreter`、`hosted_shell`、`mcp`、`skills` | https://developers.openai.com/api/docs/models/gpt-5.6-luna；https://developers.openai.com/api/docs/models/gpt-5.6-terra | 是 |
| Anthropic Computer Use | 静默/背景：Claude Agent SDK README 与 Mem0 文章确认 Bash/WebFetch/权限 hooks；本周未见官方 computer-use release | https://github.com/anthropics/claude-agent-sdk-python；https://mem0.ai/blog/persistent-memory-for-claude-agents-sdk | 否 |
| AWS AgentCore Browser / Code Interpreter | 有动态/强文档信号：Code Interpreter managed Python execution；Runtime shell/filesystem；Browser 文档抓取不足但 Harness/Gateway 引用 Browser | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-getting-started.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/harness.html | 是 |
| Azure Browser Automation / Code Interpreter / Playwright Workspaces | 有背景动态：Foundry Agent Service 与 agent identity 文档更新；独立 Browser Automation 本周未抓到 | https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity | 否 |
| Google Code Execution / Managed Agents sandbox | 有背景动态：AlphaEvolve secure client-side code execution（窗口前）；Agent Gateway/Model Armor 管 MCP/tool traffic | https://docs.cloud.google.com/gemini/enterprise/docs/release-notes；https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview | 否 |

### 深度笔记

#### E2B
- 本周动态：E2B release 页面显示多组与 sandbox runtime 直接相关的变更。BYOC 方面，commit 2821fb0 让 volume content requests route 到 team custom cluster，团队连接 custom cluster 时 volume create/get endpoints 返回该 cluster domain；默认 cluster 不受影响。模板方面，新增 `fromFedoraImage`、`fromAlpineImage`、`fromArchImage` base-image helpers，Fedora/Alpine 使用 pinned tags（fedora:44、alpine:3.24）保证 reproducible builds；Python SDK 默认也对齐。CLI 方面，`e2b sandbox create/connect` 增加 `--user`、`--cwd`、`--env`，转发到底层 PTY session。MCP 方面，`sandbox/mcp.py` regenerated，MCP server option types 使用 builtin generics 与 closed TypedDicts，对齐 spec `additionalProperties: false`。RPC 方面，sandbox RPC layer 从 vendored e2b_connect 迁到 official Connect RPC client，早关 command/watch stream 会发送 RST_STREAM，避免 HTTP/2 stream 泄漏。
- 关键数据：hot-scan 直查 13,267 stars / 981 forks / updated 2026-08-06T01:36:43Z / pushed 2026-08-05T17:08:13Z；release 文本列出 e2b@2.37.0、2.36.1；Base image defaults：fedora:44、alpine:3.24。
- 原文链接：https://github.com/e2b-dev/E2B/releases
- 影响判断：E2B 本周变更体现 sandbox 执行环境正在企业化：BYOC、可复现镜像、PTY 参数、MCP 类型严约束和连接清理，都是生产 agent 运行代码/终端时绕不开的细节。OpenClaw 可优先补齐 `user/cwd/env`、stream lifecycle、MCP schema closed validation。

#### Browserbase / Stagehand
- 本周动态：Stagehand releases 本周出现多条 browser agent runtime 关键变更：新增 `context.setDomainPolicy({ allowedDomains })` 与 `blockedDomains`，并自动关闭违反 domain policy 的 popup；支持 new google/gemini-3.5-flash computer-use tools model；修复 CUA keypress actions，使 key combinations 作为 single chord；setScreenshotProvider 返回 `{base64, mediaType}` 而非裸 base64，以使用截图 provider 声明的 media type；修复 agent creation 时 MCP integrations 中 live Client circular serialization，改为 safe descriptor；修复 malformed UTF-16 snapshot text 进入模型 prompt；browse screenshot 默认写文件而非 stdout base64；WebMCP 支持、Azure OpenAI Microsoft Entra ID model auth、canonical verifier evidence normalization 等近项也显示其正从浏览器自动化 SDK 变为可治理浏览器 runtime。
- 关键数据：hot-scan 直查 browserbase/stagehand 23,737 stars / 1,633 forks / updated 2026-08-05T18:36:26Z；release 原文包含 PR #2283/#2274 domain policy、#2294 popup close、#2273 Gemini computer-use tools model、#2278 MCP integrations safe descriptor。
- 原文链接：https://github.com/browserbase/stagehand/releases
- 影响判断：Stagehand 的信号非常接近 OpenClaw browser automation 的生产需求：domain policy、popup policy、screenshot media evidence、MCP client logging、snapshot sanitization。OpenClaw 应把这些作为 browser tool runtime 的默认安全/观测字段。

#### Daytona
- 本周动态：本周未见窗口内 release；近背景 0.190.0（2026-06-23）仍值得保留：新增 pause action、sandbox domain allow list、OTel config notice、Datadog OTel instructions、computer use access/screenshot format docs、Gemini CLI guide。0.189/0.188 等背景还涉及 async Python SDK connection resilience、sandbox state-change lock、proxy auth cookie 1h lifetime、TLS verification hardening。
- 关键数据：0.190.0 dated 2026-06-23，非本周；本周不写为动态。
- 原文链接：https://github.com/daytonaio/daytona/releases
- 影响判断：Daytona 虽本周静默，但其 pause/domain allow list/OTel/Computer Use 组合与 OpenClaw runtime/sandbox 方向一致，值得继续观察。

#### OpenAI Computer Use / Browser / Code Interpreter
- 本周动态：OpenAI 本周主要是 GPT-5.6 Luna/Terra 与 Sol Fast mode；模型文档显示在 Responses API 下继续支持 `web_search`、`file_search`、`image_generation`、`code_interpreter`、`hosted_shell`、`apply_patch`、`skills`、`computer_use`、`mcp`、`tool_search` 等工具能力。这说明 OpenAI 的 Computer Use/Code Interpreter 正作为 Responses API/Agents SDK 的一组 hosted execution tools，而非单独产品新闻。
- 关键数据：Luna/Terra context window 1,050,000，max input 922,000，max output 128,000；Luna $0.20/M input、$1.20/M output；Terra $2/M input、$12/M output；Sol Fast mode up to 2.5× speed、2× price。
- 原文链接：https://openai.com/index/advancing-the-price-performance-frontier-with-gpt-5-6/；https://developers.openai.com/api/docs/models/gpt-5.6-luna；https://developers.openai.com/api/docs/models/gpt-5.6-terra
- 影响判断：OpenAI 的执行环境优势在于模型工具一体化与 hosted shell/code/computer use 的低集成成本。OpenClaw 的差异化应是开放多 provider、多 browser/profile、多 sandbox 后端，同时保留更强的本地审计与回放。

#### AWS AgentCore Browser / Code Interpreter
- 本周动态：AgentCore Code Interpreter 文档说明其让 agents 在 secure managed environment 中执行 Python code，可做 calculations、data analysis、visualizations、answer validation；提供 Strands framework 与 direct SDK/Boto3 两种路径。IAM policy 需要 `bedrock-agentcore:CreateCodeInterpreter`、`StartCodeInterpreterSession`、`InvokeCodeInterpreter`、`StopCodeInterpreterSession`、`DeleteCodeInterpreter`、`List/Get` 等权限。AgentCore Harness 文档同时把 built-in browser、code interpreter、filesystem and shell、Gateway/MCP/tools 作为 harness 可配置工具。
- 关键数据：Code Interpreter prerequisites 包括 Python 3.10+、Boto3、IAM execution role、Claude Sonnet 4.0 model access（可用不同 model provider）；Resource ARN 形态 `arn:aws:bedrock-agentcore:<region>:<account_id>:code-interpreter/*`。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-getting-started.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/harness.html
- 影响判断：AWS 正把 browser/code/shell 作为 AgentCore 的托管执行环境 SKU。OpenClaw 如果不想被云厂替代，需要在自托管与可插拔后端上更强：用户可选本地浏览器、Browserbase、E2B、AWS AgentCore 等，同时统一权限和 trace。

### 静默对象说明
- Modal：modal-client releases 页面无 release；本周未发现 agent sandbox 基础设施级动态。
- Anthropic Computer Use：本周无官方 release；Claude Agent SDK 的 Bash/WebFetch/hooks/permissions 保持背景。
- Azure Browser Automation / Google Code Execution：本周未抓到独立 sandbox release；相关能力进入 Foundry/Gemini Enterprise 控制面背景。

### 模块洞察
- Sandbox / Computer Use / Browser 层正在从“可运行代码/浏览器”走向“带域名策略、凭据边界、截图证据、MCP 工具语义、连接生命周期与观测数据的可治理执行环境”。这一层会成为 Agent Harness 可信生产化的关键门槛。


---

## Tool Gateway / Protocol / Integration 工具层

## Tool Gateway / Protocol / Integration 工具层

### 本周模块结论
- 本周工具层最强信号是 MCP 2026-07-28 RC：协议进入新 revision 候选，SDK/网关需要处理版本协商与渐进迁移；Google mcp-toolbox 1.8.0 同步 draft spec，说明云厂工具网关已经跟进。
- 云厂网关开始从“把 API 转成工具”升级为 agentic traffic gateway：AWS AgentCore Gateway 覆盖 tools、other agents、LLMs，支持 MCP、A2A、model routing、OAuth、credential injection、semantic tool selection；Google Agent Gateway 则把 MCP/A2A/REST/gRPC、Agent Registry、IAM/IAP/Model Armor、Agent identity 合成企业治理网关。
- 集成平台继续占据 managed auth + tool registry 入口：Nango v0.71.3 增加 self-hosted Management MCP setup、MFA、audit trail；Pipedream Connect 宣称 3,000+ apps / 10,000+ tools，并提供 MCP server 与 managed auth。
- 对 OpenClaw 的参照：OpenClaw tool runtime 需要从“工具列表 + function call”升级为带 schema validation、tool discovery、MCP/A2A version negotiation、credential boundary、audit trail、semantic tool search 的 Gateway 层。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| MCP | 有动态：2026-07-28 RC release candidate | https://github.com/modelcontextprotocol/modelcontextprotocol/releases | 是 |
| A2A | 静默/背景：latest v1.0.1 2026-05-26；无本周 release | https://github.com/a2aproject/A2A/releases | 否 |
| Composio | 有动态/弱 release：releases 页显示 pre-release/TS SDK dependency refresh；hot-scan 29,554 stars | https://github.com/ComposioHQ/composio/releases；https://github.com/ComposioHQ/composio | 是 |
| Arcade | 静默/背景：Arcade MCP releases 无 release；hot-scan arcade-mcp 994 stars | https://github.com/ArcadeAI/arcade-mcp/releases | 否 |
| Nango | 有动态：v0.71.3 2026-08-03，MFA、audit、Management MCP、integrations list tool | https://github.com/NangoHQ/nango/releases | 是 |
| Pipedream Connect | 有动态/文档信号：Connect docs 明确 AI agent use case、3,000+ apps、10,000+ tools、MCP server、managed auth | https://pipedream.com/docs/connect | 是 |
| AWS AgentCore Gateway | 有动态/强文档信号：managed AI gateway，MCP/A2A/model routing、OAuth、credential exchange、semantic tool selection | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html | 是 |
| Google Agent Gateway | 有动态/强文档信号：Agent Gateway governs users/agents/tools/agent-to-agent，mTLS、DPoP、IAP、Model Armor、MCP attributes | https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview | 是 |
| Microsoft Toolbox / MCP-compatible endpoint | 有动态：Microsoft Foundry/Agent Framework 支持 MCP/A2A；Google mcp-toolbox 1.8.0 为“Toolbox”类强信号 | https://github.com/googleapis/mcp-toolbox/releases；https://github.com/microsoft/agent-framework/releases | 是 |

### 深度笔记

#### MCP
- 本周动态：Model Context Protocol 官方 releases 页显示 2026-07-28 revision 的 release candidate（RC），specification 处于 draft form，并提醒 implementer 该版本非 final，SDK 会按各自节奏采用，旧版本会并存一段时间；文档要求通过 Version Negotiation 确定 client/server 使用的协议版本。这个信号直接影响所有 tool gateway：网关必须能在 MCP 旧/新版本之间兼容，不能假设单一 schema。
- 关键数据：release candidate date 2026-07-28；官方指向 draft changelog 与 version negotiation documentation；本周窗口内仍属于需要跟踪的协议动态。
- 原文链接：https://github.com/modelcontextprotocol/modelcontextprotocol/releases；https://modelcontextprotocol.io/specification/draft/changelog
- 影响判断：MCP 正从爆发式接入进入协议治理期。OpenClaw 需要在 Gateway 层显式记录 MCP server version、negotiated capabilities、auth scope 与 tool outcome telemetry，避免未来版本漂移导致工具不可用或越权。

#### A2A
- 本周动态：A2A 本周无新 release；latest v1.0.1 于 2026-05-26，v1.0.0 于 2026-03-12 已完成大重构：把 application protocol 与 transport mapping 分离，加入 tasks/list、multi-tenancy scope、OAuth 2.0 device code / PKCE，移除 implicit/password flow。窗口内无新动态，作为跨 agent 协议背景保留。
- 关键数据：v1.0.1 2026-05-26；v1.0.0 2026-03-12；v0.3.0 2025-07-30 曾加入 mTLS、oauth2 metadata url、Skills security、AgentCard signatures。
- 原文链接：https://github.com/a2aproject/A2A/releases
- 影响判断：A2A 本周静默，但已成为 AWS/Google Gateway 文档中的基础协议之一。OpenClaw 若要支持多 Agent 互操作，应把 A2A 作为 Gateway 的 peer-agent protocol，而非只靠内部 subagent 消息。

#### Composio
- 本周动态：Composio releases 页本周显示若干 pre-release 与 TS SDK runtime dependency refresh；hot-scan 直查 ComposioHQ/composio 29,554 stars / 4,698 forks / updated 2026-08-06 / pushed 2026-08-05。项目描述强调 1000+ toolkits、tool search、context management、authentication、sandboxed workbench，用于构建 AI agents。虽然 release 内容不如 Nango/AWS 细，但其定位覆盖 tool integration + auth + sandbox workbench，仍是工具网关动态池重点。
- 关键数据：29,554 stars / 4,698 forks（hot-scan 2026-08-06）；release 页显示 patch change：Refresh runtime dependencies across TypeScript SDK packages。
- 原文链接：https://github.com/ComposioHQ/composio/releases；https://github.com/ComposioHQ/composio
- 影响判断：Composio 的价值在工具生态广度与 auth 抽象。OpenClaw 可把 Composio 视为外部 managed tool gateway，同时需保留本地 MCP/skills 以避免被单一集成平台锁定。

#### Nango
- 本周动态：Nango v0.71.3（2026-08-03）是本模块最有料的独立平台 release。它新增 MFA sign-in challenge、RBAC-gated account-scoped audit trail read API、audit-log dashboard UI、audit event pub/sub + metering、dedicated audit ClickHouse database、control-plane mutation events、authentication events、billing payment-method add/remove、sync command actions、create/deploy/invite/pause-start lifecycle events，以及 `Add self-hosted Management MCP setup`、`mcp Add integrations list tool`。同时增加 chatgpt-enterprise、glean、zoom-cc 等 integrations。对 agent tool gateway 来说，OAuth/token 管理平台开始补齐 MFA、audit、MCP 管理与计费事件。
- 关键数据：v0.71.3 date 2026-08-03；hot-scan 11,361 stars / 1,242 forks / updated 2026-08-06 / pushed 2026-08-05；release 包含 NAN-6343/NAN-6444/NAN-6339/NAN-6271 等 audit work items。
- 原文链接：https://github.com/NangoHQ/nango/releases
- 影响判断：Nango 的本周信号说明集成平台正从“帮你拿 OAuth token”升级为“连接控制面 + 审计账本 + MCP 管理面”。OpenClaw 的 Gateway 若接入 Nango，应同步其 connectionId/audit event，而不是只取 token。

#### Pipedream Connect
- 本周动态：Pipedream Connect docs 明确定位为可把 3,000+ integrations 加入 app 或 AI agent 的 developer toolkit；提供 managed auth，支持通过 Client SDK 或 Connect Link 接受用户授权，使用 Pipedream approved OAuth clients 或自有 OAuth client；还提供 Pipedream MCP server，让 AI agent 可调用 3,000+ APIs 的 10,000+ tools；Connect proxy 可代表用户发 custom API requests 而不处理 customer credentials。安全部分说明 credentials/tokens 通过 HTTPS 发送并 encrypted at rest，不存储 API request payloads or response bodies。
- 关键数据：PUBLIC_APPS = 3,000；MCP server 提供 10,000+ tools；开发模式免费，生产看 pricing；安全说明包括 encrypted at rest、SOC 2 Type 2、HIPAA BAAs。
- 原文链接：https://pipedream.com/docs/connect
- 影响判断：Pipedream Connect 是 tool gateway 的“开发者体验版本”：规模化集成、managed auth、MCP、proxy 一体。OpenClaw 可把它作为外部工具目录接入，但必须在本地保留用户授权确认、数据最小化与调用审计。

#### AWS AgentCore Gateway
- 本周动态：AWS AgentCore Gateway 文档把它定义为 fully managed AI gateway，提供 single secure entry point for agentic traffic，连接 agents to tools、other agents、LLMs；不仅是 MCP gateway，还能把 APIs、Lambda、existing services 转成 MCP-compatible tools，front other agents and HTTP services through passthrough targets（including A2A traffic），并通过 unified model-based routing endpoint 路由多 provider inference。输入类型包括 OpenAPI、Smithy、Lambda；能力包括 OAuth authorization、protocol translation、composition、secure credential exchange、semantic tool selection、serverless infra、observability/auditing；还提供 Salesforce、Slack、Jira、Asana、Zendesk 1-click integrations。
- 关键数据：支持 MCP、A2A、OpenAPI、Smithy、Lambda、model-based routing；key capabilities：Security Guard、Translation、Composition、Secure Credential Exchange、Semantic Tool Selection、Infrastructure Manager。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html
- 影响判断：AWS 重新定义了 tool gateway 的边界：它不仅是 function calling adapter，而是 agentic traffic gateway。OpenClaw 的 Gateway 若要对标，需要把 model routing、tool routing、agent routing 与 credential exchange 统一起来。

#### Google Agent Gateway
- 本周动态：Google Agent Gateway overview 将其定义为 Gemini Enterprise Agent Platform 的 networking component，governs connectivity for all agentic interactions：users ↔ agents、agents ↔ tools、agents ↔ agents。它集成 Agent Registry、Agent identity、managed agent runtimes、Agent Platform Policies、Agent Observability。Agent identity 使用 mTLS 与 DPoP，Gateway 支持 MCP/A2A/REST/gRPC，Client-to-Agent 与 Agent-to-Anywhere 两种路径；默认未注册 remote MCP servers/agents/tools 被阻断，可基于 tool name、read-only/read-write 属性、SPIFFE ID、OAuth client ID、service name 等做授权；可把 Model Armor 接到 MCP prompt/response sanitization，阻止 prompt injection 与敏感数据泄露。
- 关键数据：每个 Agent Gateway instance 可 govern up to 5,000 resources registered in Agent Registry；Agent Gateway regional in scope；Gemini Enterprise 仅支持 egress mode；MCP tools/list 可无需 authentication，但实际 tool call 权限由 IAM/IAP/Model Armor 控制。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview；https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/use-agent-platform-mcp
- 影响判断：Google 的 gateway 重点是安全治理：agent identity 作为 principal、Registry 白名单、MCP attribute authorization、Model Armor。OpenClaw 可借鉴“默认阻断未注册工具 + audit-only dry-run + tool read/write 属性”的策略。

#### Microsoft Toolbox / MCP-compatible endpoint
- 本周动态：Microsoft Agent Framework release 与 Foundry docs 显示 Microsoft 侧 MCP/A2A 已融入 agent hosting 与 enterprise orchestration；同时 Google mcp-toolbox 1.8.0（2026-07-28）是“Toolbox/MCP-compatible endpoint”方向的强信号：新增 groups support、prebuilt skills-repo toolsets 迁移到 kind: group、server `/healthz` endpoint、skills `--group` flag、Looker/Dataplex tools、更新 draft specs to 2026-07-28，并修复 default SSRF guard block CGNAT 100.64.0.0/10、tool validation、request/response traces log level。虽然这是 Google 仓库，不是 Microsoft，但说明 MCP toolbox 正快速产品化。
- 关键数据：mcp-toolbox v1.8.0 date 2026-07-28；新增 `/healthz`；更新 MCP draft specs to 2026-07-28；binary artifacts 覆盖 linux/darwin/windows amd64/arm64；v1.5.0 曾要求 auth/google 对 mcpEnabled 需要 audience 或 clientId。
- 原文链接：https://github.com/googleapis/mcp-toolbox/releases；https://github.com/microsoft/agent-framework/releases
- 影响判断：Toolbox 类项目正在把“数据库/企业系统工具”变成可分组、可健康检查、可签名、可 SSRF 防护的 MCP endpoints。OpenClaw 的 skills/tool registry 可参考 groups/toolsets/healthz/SSRF guard 结构。

### 模块洞察
- Tool Gateway / Protocol 层正在标准化和云厂收编：MCP/A2A 提供协议，AWS/Google 把协议变成安全网关，Nango/Pipedream/Composio 负责 auth + integration scale。OpenClaw 的机会是做开放 Gateway 编排层，把这些外部网关统一成可审计、可替换、可本地优先的工具面。


---

## Identity / Auth / Permission 权限层

## Identity / Auth / Permission 权限层

### 本周模块结论
- 本周权限层最强信号是“Agent Identity”成为云厂正式控制对象：AWS AgentCore Identity 专为 AI agents / automated workloads 设计，Microsoft Foundry Agent Identity 文档 2026-07-31 更新并解释 Entra token exchange，Google Agent Gateway 用 SPIFFE ID、mTLS、DPoP、IAM/IAP 与 Model Armor 管理 agent 权限。
- 独立集成平台正在补审计与用户授权：Nango v0.71.3 把 MFA、audit trail、control-plane mutation events、Management MCP、sync lifecycle events 合进 release；Pipedream Connect 强调 user credentials encrypted at rest、不存储 payload、managed auth。
- 权限不再只是 OAuth token：本周重点已经扩展到 token 托管、user/agent attribution、tool read/write scope、audit log、prompt injection 防护、敏感数据泄露拦截、MCP tool 属性授权。
- 对 OpenClaw 的参照：OpenClaw 必须把“谁授权、agent 代表谁、tool 用谁的凭据、scope 是什么、是否可撤销、是否审计”做成一等实体；approval 文本不能替代不可伪造的授权信号。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS AgentCore Identity | 有动态/强文档信号：agent workload identity、inbound JWT、credential providers、OAuth/API key outbound | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity.html | 是 |
| Microsoft Entra Agent Identity / Foundry agent identity | 有动态：文档 updated_at 2026-07-31，解释 agent identity blueprint、OBO/client credentials、scoped token exchange | https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity | 是 |
| Google Agent Identity / Gateway / Gemini Enterprise auth | 有动态/强文档信号：Agent identity、SPIFFE ID、mTLS、DPoP、IAM/IAP、OAuth scopes、Model Armor MCP sanitization | https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview；https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/use-agent-platform-mcp | 是 |
| Arcade Auth / tool permission | 静默/背景：Arcade MCP releases 无 release；继续作为 tool permission 专门平台观察 | https://github.com/ArcadeAI/arcade-mcp/releases | 否 |
| Composio Auth | 有动态/弱 release：auth/context/toolkit 定位明确，release 仅依赖刷新 | https://github.com/ComposioHQ/composio | 否 |
| Nango OAuth / token management | 有动态：v0.71.3 MFA、audit、Management MCP、integrations list tool | https://github.com/NangoHQ/nango/releases | 是 |
| Pipedream Connect managed auth | 有动态/文档信号：managed auth、OAuth clients、encrypted credentials/tokens、no payload storage | https://pipedream.com/docs/connect | 是 |

### 深度笔记

#### AWS AgentCore Identity
- 本周动态：AgentCore Identity 文档将其定义为 identity and credential management service designed specifically for AI agents and automated workloads，提供 authentication、authorization、credential management，让 agents/tools 代表用户访问 AWS 与第三方服务，同时保持 strict security controls and audit trails。它将 agent identities 实现为 workload identities，并与 Runtime、Gateway 原生集成；目录包括 manage workload identities、configure inbound JWT authorizer、manage credential providers、provider setup、private identity providers、data protection、tagging。Runtime 文档进一步说明 AgentCore Identity 可接 Okta、Microsoft Entra ID、Amazon Cognito，并支持 outbound auth flows 访问 Slack、Zoom、GitHub，既可代表用户也可 autonomous，OAuth/API keys 均可。
- 关键数据：Identity topics 包含 inbound JWT authorizer、outbound credential provider、private IdP；Runtime 文档明确 built-in authentication 与 corporate IdP；Gateway 文档说明 comprehensive ingress authentication and egress authentication。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/identity.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agents-tools-runtime.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/gateway.html
- 影响判断：AWS 将 identity 放在 AgentCore 中央，说明 agent 平台采购会默认要求 workload identity、credential providers 与 audit trail。OpenClaw 需要补“agent identity provider”抽象，而非只依赖用户 API key 环境变量。

#### Microsoft Entra Agent Identity / Foundry agent identity
- 本周动态：Microsoft Foundry agent identity 文档 updated_at 2026-07-31，定义 agent identity 是 Microsoft Entra ID 中专为 AI agents 设计的 specialized identity type。Foundry 自动 provision/manage agent identities；tool call 时执行四阶段 OAuth token exchange：blueprint authentication、agent identity token issuance、scoped token request、authenticated tool call。文档同时区分 attended OBO flow 与 unattended client credentials flow；agent identity blueprint 作为 agent 类型/类的治理模板，可应用 Conditional Access、禁用/撤销同类 agent、审计治理；federated credential with managed identity 是生产推荐路径，避免 blueprint 中存储 secret。
- 关键数据：文档 updated_at 2026-07-31；common audience values 包括 `https://storage.azure.com`、`https://logic.azure.com`、`https://cosmos.azure.com`、`https://graph.microsoft.com`、`https://vault.azure.net`；credential types：client secret、certificate、federated credential。
- 原文链接：https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/agent-identity
- 影响判断：Microsoft 是 agent identity 概念最清晰的一家：agent 是独立 principal，不是用户 token 的影子。OpenClaw 可参考 blueprint/instance 分层，为不同技能/自动化/子代理创建可撤销、可审计的 agent identities。

#### Google Agent Identity / Gateway / Gemini Enterprise auth
- 本周动态：Google Agent Gateway 文档把 Agent identity 描述为每个 agent 的 unique, trackable persona，并使用 mTLS、DPoP 做 end-to-end cryptographic authentication；Gateway 用这些 identities 作为 authorization principal。远程 MCP server 文档说明 Gemini Enterprise Agent Platform MCP 使用 OAuth 2.0 + IAM，要求 roles/mcp.toolUser 才能 make MCP tool calls，roles/aiplatform.user 管理 Agent Platform resources；支持 Google Cloud identities、agent identity and credentials，推荐为使用 MCP tools 的 agents 创建 separate identity；OAuth scopes 包括 `https://www.googleapis.com/auth/aiplatform` 与 `https://www.googleapis.com/auth/cloud-platform`。安全上，Model Armor 可对 MCP prompt/response 做 INSPECT_AND_BLOCK；IAM deny/allow policies 可按 principal、tool read-only 属性、service/tool name、OAuth client ID 授权。
- 关键数据：MCP tool calls role：MCP Tool User `roles/mcp.toolUser`；Agent Platform User `roles/aiplatform.user`；Gateway 每实例 up to 5,000 registered resources；未注册 remote MCP servers/agents/tools 默认 blocked；Model Armor floor setting 可设置 GOOGLE_MCP_SERVER enforcement type `INSPECT_AND_BLOCK`。
- 原文链接：https://docs.cloud.google.com/gemini-enterprise-agent-platform/govern/gateways/agent-gateway-overview；https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/use-agent-platform-mcp
- 影响判断：Google 的权限层最强调 runtime policy：agent identity、registry、gateway、IAM/IAP、Model Armor 共同决策。OpenClaw 可借鉴默认拒绝未注册工具、read/write tool attributes、OAuth client ID 维度审计与 prompt injection scanning。

#### Nango OAuth / token management
- 本周动态：Nango v0.71.3 是本周独立 auth 平台最强动态。它把 sign-in 置于 MFA 后、增加 MFA challenge、per-member 2FA status、admin impersonation 需自身 MFA；审计侧增加 RBAC-gated account-scoped audit trail read API、dashboard UI、control-plane mutation events、dedicated audit ClickHouse database、batch writes、MFA/auth/billing/sync/create-deploy-invite-pause-start lifecycle events；MCP 侧增加 self-hosted Management MCP setup 与 integrations list tool。它还增加 mTLS internal service-to-service calls。
- 关键数据：v0.71.3 2026-08-03；hot-scan 11,361 stars / 1,242 forks；release PRs 包括 #6822/#6832 MFA，#6831/#6859 audit API/UI，#6937 Management MCP，#6977 integrations list tool，#6928 mTLS。
- 原文链接：https://github.com/NangoHQ/nango/releases
- 影响判断：Nango 显示 token management 的生产需求已经扩展到 MFA、impersonation control、audit database、metering 与 MCP admin。OpenClaw 若集成 Nango，应把 external_user_id、connection id、audit event 与 OpenClaw session/tool call 绑定，避免“拿到 token 但无法追责”。

#### Pipedream Connect managed auth
- 本周动态：Pipedream Connect docs 明确 managed auth：可代表用户处理 authorization 或 API keys，使用 Client SDK 或 Connect Link 接受授权；可用 Pipedream approved OAuth clients 或自有 OAuth client。Connect proxy 允许代表用户发 custom API requests，同时避免处理 customer credentials。安全章节说明 Connect 不存储 API request payloads or response bodies；credentials/tokens over HTTPS 且 encrypted at rest；建议 secure session-based auth、HTTPS、保护 OAuth client credentials，并可提供 SOC 2 Type 2、HIPAA BAA 等材料。
- 关键数据：3,000+ APIs/apps；10,000+ tools through Pipedream MCP server；Connect development mode free；credentials/tokens encrypted at rest；payload/response body 不存储。
- 原文链接：https://pipedream.com/docs/connect
- 影响判断：Pipedream 的优势是把 end-user managed auth 变成开发者可快速嵌入的组件。OpenClaw 需要在接入时补本地授权确认和最小权限提示，避免 agent 获得过宽 SaaS 权限。

#### Arcade / Composio Auth
- 本周动态：Arcade MCP releases 页面无 release，本周静默；Composio release 仅见依赖刷新，但项目本身定位包括 authentication、context management、sandboxed workbench 与 1000+ toolkits。二者仍是 tool permission / managed auth 赛道观察对象，但本周不强写新动态。
- 关键数据：ArcadeAI/arcade-mcp hot-scan 994 stars / 104 forks / updated 2026-08-05；Composio hot-scan 29,554 stars / 4,698 forks / updated 2026-08-06。
- 原文链接：https://github.com/ArcadeAI/arcade-mcp/releases；https://github.com/ComposioHQ/composio
- 影响判断：Arcade/Composio 代表独立 tool auth 平台方向。OpenClaw 可保留适配器，但自身必须有统一 permission ledger，否则外部 auth 平台之间无法横向审计。

### 权限覆盖检查
- OAuth/OIDC/MCP auth：AWS inbound JWT/outbound credential provider；Google OAuth2 + IAM + MCP roles；Microsoft Entra OAuth token exchange；Nango/Pipedream managed OAuth。
- Token 托管：AWS credential providers、Microsoft Entra scoped token、Pipedream encrypted at rest、Nango token management/audit。
- 用户授权：Google roles/mcp.toolUser、Microsoft OBO flow、Pipedream external_user_id、Nango account-scoped audit。
- Tool permission：Google tool name/read-write/IAM policy、AWS Gateway security guard/semantic tool selection、Microsoft RBAC audience、OpenClaw 待补统一 tool permission ledger。
- 审计与泄露防护：AWS audit trails、Google Cloud Trace/Logging + Model Armor、Nango audit ClickHouse、Pipedream no payload storage；越权风险集中在 prompt injection 间接触发 privileged tool call，需要不可伪造授权信号。

### 模块洞察
- Identity / Auth / Permission 层已经从“连接 OAuth”升级为“Agent 作为独立主体的权限治理”：谁创建 agent、agent 代表谁、能调用哪些工具、token 如何托管、调用如何审计，正在成为企业 Agent Harness 的采购硬门槛。


---

## Context / Memory / Knowledge 记忆知识层

> 本模块固定对象全部过筛。GitHub 热度扫描显示本周必须检查 OpenViking、Cognee、supermemory、Crawl4AI、Mem0、Letta、Zep/Graphiti、Firecrawl；有动态对象均已打开 GitHub / release / docs 原文。

## 6 Context / Memory / Knowledge

### 本周模块结论
- 本周最强信号不是传统向量库，而是“Context Database / Memory API / Agent Memory Graph”三类形态加速分化：OpenViking 明确把 memory、knowledge RAG、skills 统一为 `viking://` 虚拟文件系统；Mem0 把 agent-scoped memory extraction 做成 SDK/API 字段；Zep 把 ingestion、plugin、eval harness 拉到一个工程流里。
- 外部知识摄取入口继续商品化：Firecrawl 已从 scrape/crawl 扩展到 search、interact、agent、MCP；Crawl4AI 虽本窗口没有新大版本，但其 v0.9 系列安全默认与 Docker API 修复仍是知识摄取基础设施的近两周重要背景。
- 对 OpenClaw 的参照：OpenClaw 自带 memory/knowledge 能力若要进入生产化，需要补齐 OpenViking 式可观察检索轨迹、Mem0 式 agent/user 记忆归因、Firecrawl/Crawl4AI 式高质量 Web ingest；同时保留 OpenClaw 的 session/tool/runtime 原生优势。
- 赛道判断：Memory 正从“给 agent 一个 vector store”转向“带权限边界、归因、摄取、调试轨迹、SDK/插件入口的 Context OS”，而这一层正在成为 Harness 标准件。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| OpenViking | 有动态 | hot-scan 未命中但 web_search 命中 GitHub；GitHub 原文 fetched 2026-08-06；docs OpenCode 插件 fetched 2026-08-06 | 是 |
| Mem0 | 有动态 | GitHub API：62,613 stars / 7,303 forks / pushed 2026-08-05；v2.0.17、ts-v3.1.5、n8n-v0.1.3 release 原文 | 是 |
| Cognee | 有动态 | GitHub API：29,800 stars / 2,882 forks；v1.4.1 2026-07-31、v1.4.1.dev0 2026-08-05 release 原文 | 是 |
| supermemory | 有动态 | GitHub API：28,787 stars / 2,509 forks / pushed 2026-08-05；README 与 commit 570ed22 原文 | 是 |
| Letta | 静默/治理更新 | GitHub API：24,102 stars / 2,565 forks；commit ff19ffe 2026-08-01 原文 | 否 |
| Zep / Graphiti | 有动态 | Graphiti GitHub API：29,597 stars / 2,991 forks；Zep zep-ingest-v0.1.0 release 2026-07-30 原文 | 是 |
| Firecrawl | 有动态 | GitHub API：161,779 stars / 9,122 forks / pushed 2026-08-05；README 与 commit b1371d2 原文 | 是 |
| Crawl4AI | 静默/近两周背景 | hot-scan：76,297 stars / 7,891 forks；README 与 v0.9.2 release/blog 原文（release 2026-07-15，非本周） | 否 |

### 深度笔记

#### OpenViking
- 本周动态：OpenViking 是本周 hot-scan 明确要求补查的对象，GitHub 页面显示项目定位为“Self-evolving Context Database for AI Agents. Unify Agent Memory, Knowledge RAG and Skills.”，web_search 在窗口内命中 GitHub 与 docs；GitHub 原文进一步说明它把 memories、resources、skills 存成一个 `viking://` 虚拟文件系统，让 agent 通过 `ls/tree/find/grep/read` 一类确定性操作浏览上下文，而不是只对黑盒向量库发 query。其上下文写入后会被加工成 L0 abstract、L1 overview、L2 details 三层，检索时先定位高分目录再递归下钻，并保留“directory-browsing trajectory”，可回看错误结果来自哪条路径。README 还列出 Claude Code、Codex、OpenClaw、Hermes、Cursor、Trae、OpenCode、MCP clients、LangChain/LangGraph 等集成；OpenCode 插件文档显示其通过 plugin hooks 自动 recall/capture，并通过同一个 OpenViking stdio MCP proxy 暴露 `openviking_recall/search/find/read/list/grep/glob/remember/add_resource/forget/health` 等工具。本周值得注意的是 OpenViking 从“记忆库”讲法升级为“context database + agent integrations + helper + hosted service”，并把 OpenClaw 列为一等集成对象。
- 关键数据：GitHub 页面 sidebar 显示 27,976 stars / 2,198 forks / 1,906 commits（fetch 2026-08-06）；benchmark 原文称 OpenViking 0.3.22 在 LoCoMo 上将 OpenClaw/Hermes/Claude Code 集成 accuracy 提升到 80–83%，input tokens 下降 34.3–91.0%，query latency 下降 58.45–66.10%；tau2-bench task success retail +6.87pp、airline +11.87pp；OpenViking Helper 0.0.19 提供 macOS/Windows beta 下载。来源：https://github.com/volcengine/OpenViking；https://docs.openviking.ai/en/agent-integrations/10-opencode。
- 原文链接：https://github.com/volcengine/OpenViking；https://docs.openviking.ai/en/agent-integrations/10-opencode。
- 影响判断：OpenViking 对 OpenClaw 的直接参照价值很高：它把 context 的目录结构、层级压缩、检索轨迹、session commit、MCP/插件入口全部显式化，补齐了“记忆为何被召回、怎么调试”的可解释性。OpenClaw 若接入/对标，应优先学习其 URI + tiered context + traceable recall，而不是只复制 vector store。

#### Mem0
- 本周动态：Mem0 本周连发 Python SDK v2.0.17、Node SDK ts-v3.1.5、n8n integration v0.1.3。Python/Node SDK 的核心变化是新增 agent-scoped memory extraction 指令：Python 侧在 `project.update()/update_project()`、`ProjectUpdateOptions`、`AddMemoryOptions` 中加入 `agent_custom_instructions`；Node 侧加入 `agentCustomInstructions` 到 `PromptUpdatePayload`、`AddMemoryOptions`、`ProjectResponse`。release 说明这个字段会设置第二套 extraction instruction，仅用于 agent-scoped memories：只传 `agent_id` 不传 `user_id` 的 add 会使用该指令，同时传 user 与 agent 时会按 attribution 拆分；未设置时 `custom_instructions` 仍作用于所有 memory。n8n integration v0.1.3 则把发布包许可证从 Apache-2.0 改为 MIT，以满足 n8n Creator Portal 的 verified community nodes 要求，并改用 light/dark themed icons。
- 关键数据：GitHub API 直查：62,613 stars、7,303 forks、updated 2026-08-06T01:51:35Z、pushed 2026-08-05T18:44:42Z；release：v2.0.17 published 2026-08-05T16:42:46Z，ts-v3.1.5 published 2026-08-05T16:42:55Z，n8n-nodes-mem0-v0.1.3 published 2026-08-05T18:32:36Z。来源：https://github.com/mem0ai/mem0/releases/tag/v2.0.17；https://github.com/mem0ai/mem0/releases/tag/ts-v3.1.5；https://github.com/mem0ai/mem0/releases/tag/n8n-nodes-mem0-v0.1.3。
- 原文链接：https://github.com/mem0ai/mem0/releases/tag/v2.0.17；https://github.com/mem0ai/mem0/releases/tag/ts-v3.1.5；https://github.com/mem0ai/mem0/releases/tag/n8n-nodes-mem0-v0.1.3。
- 影响判断：Mem0 正在把“记忆属于用户还是 agent”做成 API 级归因，而不是靠 prompt 约定。对 OpenClaw 来说，这提示 memory schema 至少应显式区分 user memory、agent experience、project memory，并允许不同 extraction policy；否则长期记忆会在多 agent / 多用户场景中污染。

#### Cognee
- 本周动态：Cognee 本周发布 v1.4.1（2026-07-31）和 v1.4.1.dev0（2026-08-05）。v1.4.1 是 reliability & search improvements：改进 search relevance、提高 ingestion robustness、降低大文件 ingestion 的 memory usage 与常见 query latency，并增加 search result previews、clearer ingestion error messages、streaming ingestion、metadata cleanup、upload/search diagnostics、malformed document validation。v1.4.1.dev0 则延续 usability/stability：更相关的 recent documents ranking、导入进度与更清晰错误、更快 large-file ingestion、更低 query latency、dependency updates 与 stricter input validation。Cognee 的产品路线仍是 self-hosted knowledge graph engine for agents，本周变化集中在“摄取稳定 + 搜索质量 + 用户可诊断性”，这正是 Memory/Knowledge 平台从 demo 到生产要跨过的门槛。
- 关键数据：GitHub API：29,800 stars、2,882 forks、updated 2026-08-06T01:52:31Z、pushed 2026-08-05T17:01:26Z；v1.4.1 release date 2026-07-31；v1.4.1.dev0 release date 2026-08-05；兼容性：Python >=3.10,<3.15，pydantic >=2.10.5，litellm >=1.83.7，fastapi >=0.116.2,<1.0.0，lancedb >=0.24.3,<1.0.0 等。来源：https://github.com/topoteretes/cognee/releases/tag/v1.4.1；https://github.com/topoteretes/cognee/releases/tag/v1.4.1.dev0。
- 原文链接：https://github.com/topoteretes/cognee/releases/tag/v1.4.1；https://github.com/topoteretes/cognee/releases/tag/v1.4.1.dev0。
- 影响判断：Cognee 的信号说明 agent memory 的竞争点已从“能否建图”转向“能否稳定 ingest 大文件、返回可预览可解释的搜索结果”。OpenClaw 若做知识库/技能库，应把 ingest progress、错误可恢复、search preview 作为基础能力，而非后置 UI polish。

#### supermemory
- 本周动态：supermemory 本周没有正式 release，但 repo 在窗口内有多次与 agent memory productization 相关的 commit。README 将其定位为“Memory and context layer for AI”，声称在 LongMemEval、LoCoMo、ConvoMem 三大 memory benchmark 上排名第一，并提供 95% Recall@15、99.4% context reduction、约 50ms user profiles 等指标；功能上把 conversation fact extraction、temporal changes、contradictions、automatic forgetting、user profiles、hybrid search、connectors、multi-modal extractors 合成一个 Memory API。对 agent 生态尤其关键的是，README 明确列出 Claude Code、OpenCode、OpenClaw、Hermes 插件，以及 MCP server `https://mcp.supermemory.ai/mcp`，工具包括 `memory`、`recall`、`context`。本周 commit 570ed22 `feat(skills): surface Company Brain-created skills` 则显示 supermemory 正把“公司脑产生的 skills”纳入可见 skill list，并增加 `origin: slack` 与 “Created by Company Brain” badge、15 秒 refetch 等 UI/数据模型逻辑。
- 关键数据：GitHub API：28,787 stars、2,509 forks、updated 2026-08-06T01:02:17Z、pushed 2026-08-05T20:03:45Z；commit 570ed22 时间 2026-08-05T03:42:37Z；README 数据：95% Recall@15、99.4% context reduction、~50ms user profiles。来源：https://github.com/supermemoryai/supermemory；https://github.com/supermemoryai/supermemory/commit/570ed22。
- 原文链接：https://github.com/supermemoryai/supermemory；https://github.com/supermemoryai/supermemory/commit/570ed22。
- 影响判断：supermemory 把 Memory API、MCP、插件、Company Brain/skills 结合，已经非常接近 OpenClaw 的 skill+memory 场景。OpenClaw 参照点是：memory 不只召回事实，也能生成/分发“组织级技能”；风险是如果缺少 origin、scope、permission，自动生成的 skills 会带来治理问题。

#### Zep / Graphiti
- 本周动态：Zep/Graphiti 本周核心动态来自 `getzep/zep` 的 `zep-ingest-v0.1.0` release（2026-07-30），以及 Graphiti repo 在窗口内持续活跃。release 列出 `feat(ingestion): add hardened zep-ingest pipeline`、`fix(ingestion): resolve Slack authors by real_name, not display_name`、`fix(python): ship PEP 561 markers for all published packages`，并围绕“building-with-zep”增加 dual Claude + Codex plugin sharing one skill + MCP、Cursor as third plugin ecosystem、restore key skill guidance + document placement rule。它还出现一次 `feat(eval-harness): agentic retrieval via configurable Zep tools` 后又 revert，并补文档说明 single-shot retrieval scope vs tool-based agents。这说明 Zep/Graphiti 仍在把 temporal knowledge graph 从后端能力向 coding-agent 插件、MCP、ingestion pipeline、eval harness 迁移。
- 关键数据：Graphiti GitHub API：29,597 stars、2,991 forks、updated 2026-08-06T00:53:01Z、pushed 2026-08-05T07:38:13Z；Zep GitHub API：4,813 stars、646 forks、updated 2026-08-05T10:58:17Z、pushed 2026-08-05T17:03:05Z；`zep-ingest-v0.1.0` published 2026-07-30T02:11:54Z。来源：https://github.com/getzep/zep/releases/tag/zep-ingest-v0.1.0；https://github.com/getzep/graphiti。
- 原文链接：https://github.com/getzep/zep/releases/tag/zep-ingest-v0.1.0；https://github.com/getzep/graphiti。
- 影响判断：Zep/Graphiti 强项是 temporal KG 与 conversational/enterprise data ingestion；本周 release 暗示它正补“从 Slack/IDE/agent 插件进入知识图”的入口。OpenClaw 若需要企业知识沉淀，可把 Zep/Graphiti 看作 temporal graph backend 候选，但需验证 MCP/tool-based retrieval 是否稳定。

#### Firecrawl
- 本周动态：Firecrawl 本周仍是外部知识获取入口中的最大热度项目。README 将其定位为“the web context API to find sources, extract content, and turn it into clean Markdown or structured data your agents can ship with”，核心端点包括 Search、Scrape、Interact、Agent、Crawl、Map、Batch Scrape，并支持 MCP client 一键连接与 `firecrawl-cli init --all --browser`。窗口内 commit b1371d2 / PR #4232 修复 `text/plain` markdown escaping：原先 text/plain 内容（例如 `llms.txt`）经过 HTML-to-markdown converter 会转义 `_`，导致 URL 或标识符如 `access_policies` 被破坏；修复后对 `content-type` 做 case-insensitive normalize，对 `text/plain` 直接透传 raw body，并增加测试。这个改动看似小，但对 agent ingest 特别关键，因为 `llms.txt`、docs plain text、API list 等常是 RAG/agent grounding 的输入。
- 关键数据：GitHub API：161,779 stars、9,122 forks、updated 2026-08-06T02:04:46Z、pushed 2026-08-05T21:35:01Z；latest fetched releases：v2.11.0 published 2026-06-19（背景，非本周）；commit b1371d2 2026-08-05T03:53:21Z。README 声称 covers 96% of the web、P95 latency 3.4s、`spark-1-mini` 比 pro/standard 便宜 60%（原文表述：spark-1-mini default, 60% cheaper）。来源：https://github.com/firecrawl/firecrawl；https://github.com/firecrawl/firecrawl/commit/b1371d2。
- 原文链接：https://github.com/firecrawl/firecrawl；https://github.com/firecrawl/firecrawl/commit/b1371d2。
- 影响判断：Firecrawl 正从“爬虫”变成“agent web context gateway”。对 OpenClaw 而言，它可作为 web ingest/tool gateway 的短期接入对象；同时要关注成本、数据版权、浏览器动作可回放与 auth 边界，避免 agent 在网页交互中产生不可审计状态。

### 静默对象与观察池
- Letta：本周无重大 Memory 产品动态。repo 在 2026-08-01 有治理/贡献流程 commit，要求 issue 明确 AI tool disclosure 与 repo acknowledgment；这与 memory 产品无直接关系。近背景：Letta 仍定位为 stateful agents / persistent context / self-improving memory。证据：https://github.com/letta-ai/letta/commit/ff19ffe。
- Crawl4AI：本周无重大公开 release；hot-scan 仍显示高热（约 76k stars）且 README/文档展示 LLM-ready Markdown、structured extraction、browser profiles、Docker API、JWT auth、remote browser control 等能力。背景（非本周）：v0.9.2 于 2026-07-15 发布，修复 MemoryAdaptiveDispatcher streaming crawl 关闭后的 task/page leak、Docker Playground Advanced Config 400、Monitor WebSocket JWT auth 500、Playwright headless-shell packaging、ENABLE_GPU=true Docker build。证据：https://github.com/unclecode/crawl4ai；https://github.com/unclecode/crawl4ai/blob/main/docs/blog/release-v0.9.2.md。
- LightRAG / Microsoft GraphRAG / LlamaIndex / LangMem / Onyx / Haystack / Jina Reader / Unstructured / Chroma/Qdrant/Milvus/Weaviate agent memory：本周未发现足以进入本模块深写的、明确面向 Agent Memory/Context Database/Skills 的基础设施级动态；可继续作为观察池。注意 LangGraph Store/LangMem 与 LlamaIndex 仍是框架侧长期 memory 组件背景，不应把本模块稀释成泛向量数据库周报。

### 模块洞察
- Context / Memory / Knowledge 层正在标准化为“可调试的上下文数据库 + 可归因的长期记忆 + 可治理的知识摄取入口”；开源项目在形态创新上领先，云厂与 Harness 会逐步把这一层收编为 Agent Platform 的内建模块。


---

## Observability / Eval / Guardrails 可观测治理层

> 时间窗：2026-07-30 00:00 → 2026-08-05 24:00 Asia/Shanghai。固定对象均过筛；有动态对象已打开官方博客、文档、GitHub releases/README 原文。GitHub API 后半程触发 rate limit，优先采用 hot-scan 直查数据、GitHub 页面 / release 原文与项目官网补证；无法直查的数字不编造。

## 7 Observability / Eval / Guardrails

### 本周模块结论
- 本周可观测治理层最强信号是“agent trace → eval → policy/guardrail → optimization”开始合成闭环：AWS AgentCore 在文档/公告中把 Observability、Evaluations、Policy、Optimization、CloudWatch 串成同一套生产控制面；Phoenix、Langfuse、Braintrust 则在开源/SDK层快速补 agent spans、session filters、tool call counting、OpenTelemetry/agent instrumentation。
- Agent eval 继续从“最终答案打分”转向“轨迹级质量判断”：LangSmith 的 voice agent eval 强调 execution/outcome/experience，ReviewBench 强调真实 PR feedback、coverage/precision/F1；Phoenix 19.11-19.18 则补 project evaluation metrics charts、subagent tool call counts、sessions expression filter DSL。
- Guardrails 正从 prompt 层迁到 gateway/policy 层：AWS AgentCore Policy 用 Cedar / natural-language authoring 在 Gateway tool call 前拦截；OpenTelemetry / Microsoft / Redis 等讨论都指向跨 agent、跨 tool、跨 MCP 的 trace context 与 identity/permission scope。
- 对 OpenClaw 的参照：OpenClaw 需要把 sessions/tool/runtime 的原生日志上升为标准化 trace schema，至少补齐 agent→tool→memory→subagent 的因果链、eval 运行 ID、permission scope、召回轨迹与可回放视图；否则难以支撑生产级 guardrail 与回归评测。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| LangSmith | 有动态 | LangChain blog：voice agents eval（搜索显示 1 day ago）；ReviewBench（5 days ago）；LangSmith docs fetched | 是 |
| Langfuse | 有动态 | hot-scan：32,586 stars / 3,496 forks / updated 2026-08-06；GitHub releases v4.4.0/v4.3.x 原文 | 是 |
| Helicone | 静默/背景 | GitHub README fetched；本周未发现官方 release 级动态 | 否 |
| AgentOps | 静默/背景 | hot-scan：5,751 stars / 613 forks；GitHub README fetched；本周无 release | 否 |
| Braintrust | 有动态 | GitHub releases braintrust SDK JS 3.27.0/3.26.0 原文；Braintrust docs/repo fetched | 是 |
| Arize Phoenix | 有动态 | GitHub releases 19.11.0→19.18.0 原文；README fetched | 是 |
| Coze Loop | 有动态/背景 | GitHub README 与 releases 原文；open-source release 列出大量 eval/observability PR，但 release 页面显示 Jan 20（非本周） | 是（背景化） |
| OpenTelemetry for Agents / tracing standards | 有动态 | OTel GenAI semconv moved repo；Redis multi-agent observability 2026-08-03；Microsoft Foundry tracing docs | 是 |
| AWS/Google/Azure agent observability/evaluation/simulation/guardrails | 有动态 | AWS AgentCore overview/observability/evaluations/policy docs and blog；Google Agent Platform scale docs；Microsoft Foundry tracing docs | 是 |

### 深度笔记

#### LangSmith
- 本周动态：LangSmith 本周围绕“agent eval 方法论”连续输出两条强信号。其 voice agents eval 文章提出 voice agent 要从 Execution、Outcome、Experience 三个维度评估，而不是只看最终 transcript：Execution 包括工具调用顺序、参数、privacy/disclosure/consent policy、是否收集确认必要信息；Outcome 要连到下游业务结果，如 booking success、resolution rate、transfer success、reopened issue rate；Experience 则看 end-of-turn latency、STT/model/tool/TTS 分段延迟、time to first audio、语音自然度、打断恢复、clarification loops 等。文章明确说在 LangSmith 中可以 trace full interaction、用多个 evaluators 打分、inspect recording and tool activity、compare changes over time。另一篇 ReviewBench 文章则披露 LangChain 从 LangSmith mono-repo 的真实 PR feedback 构建 code review agent benchmark：59 个 Harbor tasks、64 个 baseline issues，用 coverage 和 precision 打 F1；当前 basic harness 的最强模型只能 recover about 30% baseline issues，20-task slice 上 tuned Luna structured review prompt 得分 0.32，说明 harness strategy/prompt 对 agent eval 结果影响很大。
- 关键数据：ReviewBench：59 tasks、64 baseline issues、3 attempts per task；strongest runs recover about 30% curated baseline issues；tuned Luna 20-task slice score 0.32；Voice eval 建议 P50/P95/P99 latency 分项。来源：https://www.langchain.com/blog/evaluating-code-review-agents-with-reviewbench；https://www.langchain.com/blog/how-to-evaluate-voice-agents-execution-outcomes-and-experience。LangSmith docs 说明 Observability 提供 traces、dashboards、alerts、rules/webhooks/online evaluations、feedback、Engine。来源：https://docs.langchain.com/langsmith/observability.md。
- 原文链接：https://www.langchain.com/blog/how-to-evaluate-voice-agents-execution-outcomes-and-experience；https://www.langchain.com/blog/evaluating-code-review-agents-with-reviewbench；https://docs.langchain.com/langsmith/observability.md。
- 影响判断：LangSmith 把 eval 从静态 prompt regression 拉到真实流程/业务结果/音频体验/代码审查任务，这对 OpenClaw 很关键：OpenClaw 的 eval 不应只比较最终回答，而要保留工具顺序、权限检查、延迟分解、subagent handoff、用户反馈与业务 outcome 的关联。

#### Langfuse
- 本周动态：Langfuse 本周 GitHub releases 展示 v4.4.0/v4.3.x 方向：v4.4.0 的 features 包括 media association origin、semantic root filters forward to v4 tables、modern sidebar 加 span list、experiment instrumentation migration handling、ClickHouse writer time distribution metrics，以及 `feat(agent): Add client/web support for 'in-app agent' background execution (with a canonical hydration contract)` 和 `feat(in-app-agent): increase maximum agent steps`。fixes 包括 `fix(otel): reject spans with missing or malformed ids with a 400`、`fix(evals): propagate evaluator metadata to generation spans`、`fix(evals): prevent recursion through OpenRouter Broadcast`、expose release in observation views、preserve trace names across v4 surfaces。v4.2/v4.3 附近还出现 `feat(mcp): Add canonical MCP tool outcome telemetry to DD`、metrics query discovery metadata、observation scope requirements 等。README 则强调 Langfuse 是 open source AI engineering platform，支持 tracing、prompt management、evaluations、datasets、playground、API，集成 OpenTelemetry、LangChain、OpenAI SDK、LiteLLM 等。
- 关键数据：hot-scan 直查：langfuse/langfuse 32,586 stars / 3,496 forks / updated 2026-08-06T02:00:43Z / pushed 2026-08-06T00:47:27Z；GitHub releases 原文列出 v4.4.0 full changelog v4.3.1...v4.4.0，v4.3.0 full changelog v4.2.0...v4.3.0；README 提到 2026 年 1 月起 Langfuse part of ClickHouse（背景，非本周）。来源：https://github.com/langfuse/langfuse/releases；https://github.com/langfuse/langfuse。
- 原文链接：https://github.com/langfuse/langfuse/releases；https://github.com/langfuse/langfuse。
- 影响判断：Langfuse 的本周方向是“trace 数据模型更标准 + eval metadata 回写 span + in-app agent 自身运行可观察”。OpenClaw 可借鉴其 v4 化思路：把 session/observation/span root、eval metadata、MCP tool outcome 统一到可查询 schema，而不是分散在日志、tool result 和 memory 中。

#### Braintrust
- 本周动态：Braintrust 的 JS SDK releases 本周集中补 agent instrumentation 与 OpenTelemetry 兼容。3.27.0 加入 `anthropic.beta.sessions` instrumentation、`@cloudflare/think` instrumentation、ollama instrumentation、vitest-evals 的 `meta.eval.input`，并支持 flue v2；3.26.0 加入 agents instrumentation、`@cloudflare/ai-chat`、`@huggingface/transformers`，并修复 Strands agent model span input、Google GenAI / Google ADK token count、AI SDK telemetry type compatibility。release 页面更早的 3.24/3.23/3.21 还显示 `@braintrust/otel`、span origin provenance metadata、LangSmith tracing、Eve turns as traces、distributed tracing inject/extract APIs、helpers to evaluate agents、Workflow Agent instrumentation 等。repo README 确认该仓库包含 JS/TS tracing & evals SDK，包包括 `braintrust`、`@braintrust/openai-agents`、`@braintrust/otel`、`@braintrust/temporal`、LangChain integration。
- 关键数据：release 原文：3.27.0、3.26.0、3.25.0、3.24.0、@braintrust/otel 0.3.0 等；README 包列表含 `@braintrust/openai-agents`、`@braintrust/otel`、`@braintrust/temporal`。来源：https://github.com/braintrustdata/braintrust-sdk-javascript/releases；https://github.com/braintrustdata/braintrust-sdk-javascript。
- 原文链接：https://github.com/braintrustdata/braintrust-sdk-javascript/releases；https://github.com/braintrustdata/braintrust-sdk-javascript。
- 影响判断：Braintrust 在 SDK 层快速覆盖多 agent/framework/provider，是“评测平台争夺 instrumentation surface area”的典型打法。OpenClaw 若想让外部 eval 平台接入，必须提供标准 trace export 与 span provenance，否则生态工具只能在 LLM wrapper 层看到碎片。

#### Arize Phoenix
- 本周动态：Phoenix 本周 release 密度最高。19.11.0（2026-07-30）新增 project evaluation metrics charts、online count subagent tool calls、show tool and tool call counts in LLM span card headers、span annotations export、trace pinned note-taking bar，并把 root-span scoping 移到 filter condition。19.13/19.15 继续提升 experiment metric chart selection 与 project annotation metric chart loading。19.16.0（2026-08-04）新增 OpenAI-compatible `v1/chat/completions` proxy with server-side credentials、UI collapsed preview card，并优化 span export streaming downloads。19.18.0（2026-08-05）新增 REST endpoint for prompt metadata updates、sessions expression filter DSL，并修复 LiteLLM threshold customizations、Safari time range UI。README 还把 Phoenix 定位为 open-source AI observability platform，提供 tracing、evaluation、datasets、experiments、playground、prompt management、PXI、Remote MCP Server，并支持 OpenAI Agents SDK、Claude Agent SDK、LangGraph、Vercel AI SDK、Mastra、CrewAI、Google ADK、AWS Bedrock 等。
- 关键数据：Release dates：19.11.0 2026-07-30、19.13.0 2026-08-01、19.15.0 2026-08-03、19.16.0 2026-08-04、19.18.0 2026-08-05；star-history 搜索结果显示 Arize-ai/phoenix 约 10.7k stars（间接来源，GitHub API 当时限流，待后续直查复核）。来源：https://github.com/Arize-ai/phoenix/releases；https://github.com/Arize-ai/phoenix。
- 原文链接：https://github.com/Arize-ai/phoenix/releases；https://github.com/Arize-ai/phoenix。
- 影响判断：Phoenix 的核心信号是把 agent 轨迹变成可筛选、可计数、可评测、可导出的对象，尤其是 subagent tool call counts 与 sessions expression filter DSL。OpenClaw 的 subagent/session 模型与 Phoenix 思路高度相关，可优先对齐 OpenInference/OTel 数据模型，复用 Phoenix 做本地/开源观测端。

#### Coze Loop
- 本周动态：Coze Loop 的 GitHub README 将其定义为 next-generation AI Agent Optimization Platform，覆盖 AI agent development、debugging、evaluation、monitoring 的全生命周期。虽然 release 页面显示当前大 release 时间为 Jan 20（非本周），不应算“本周发布”，但 release changelog 本身对本模块很有参考价值：其中包括 custom target、code evaluator route、observability add panic proc、search trace tree open API、observability metrics、A2A agentkit、trace original tag、response API trace、evaluator ecosystem、feedback auto task、workflow automation tasks、prompt sync、trace implementation multi repo 等。README 说明开源版包含 prompt development、evaluation、observation 三大模块；trace reporting supports SDK trace reporting and trace data observation；evaluation 管理 evaluation sets、evaluator、experiments；部署支持 Docker Compose 与 Helm，并明确公共网络部署需评估 registration、Coze Server listen address、SSRF、horizontal privilege escalation 等风险。
- 关键数据：release 页面 image version：`cozedev/coze-loop:1.5.1`、`cozedev/coze-loop-python-faas:1.0.0`（release dated Jan 20，背景非本周）；README 支持 OpenAI、Volcengine Ark 等模型，Docker Compose 本地默认访问 `http://localhost:8082`，Helm chart version `1.0.0-helm`。来源：https://github.com/coze-dev/coze-loop；https://github.com/coze-dev/coze-loop/releases。
- 原文链接：https://github.com/coze-dev/coze-loop；https://github.com/coze-dev/coze-loop/releases。
- 影响判断：Coze Loop 是国内体系里少数把 prompt、eval、trace monitoring 作为 agent optimization platform 开源的对象。对 OpenClaw 而言，它提示“观测治理”不应只是日志页面，而要和 prompt/dataset/evaluator/experiment/feedback workflow 一起设计；同时公共网络安全红线值得借鉴。

#### OpenTelemetry for Agents / tracing standards
- 本周动态：OpenTelemetry GenAI semantic conventions 本周最重要的状态是规范迁移：官方 docs 明确提示 GenAI semantic conventions 已移到新的 `open-telemetry/semantic-conventions-genai` 仓库，原页面不再维护；新 repo README 说明覆盖 GenAI clients、MCP、provider-specific conventions、spans、metrics、events，并用 Weaver 管理与 core semantic conventions 的依赖。与此同时，Redis 在 2026-08-03 发布 multi-agent observability 文章，指出单 agent 一条 trace 还能读，多 agent 系统里 delegation、tool calls、memory reads/writes、inter-agent messages 会分裂为多条 trace；OpenTelemetry GenAI semconv 描述了 top-level `invoke_agent` span 与 LLM/tool child spans，但 MCP/agent-to-agent transport boundary 处 trace context 容易丢失，导致 LLM calls、tool executions、agent messages 分散在不同 trace。Microsoft Foundry tracing docs（背景，非本周更新）则写到 Microsoft 与 Outshift/Cisco 基于 OpenTelemetry 与 W3C Trace Context 增强 multi-agent observability semantic conventions。
- 关键数据：Redis 文章 published 2026-08-03 / updated 2026-08-05；其引用研究称 75.17% observed failures 是 silent gray errors，完整 traces 将 responsible-agent attribution 从 53.5% 提升到 65.9% 但仍不足；OTel docs 状态：GenAI semantic conventions moved to `open-telemetry/semantic-conventions-genai`。来源：https://opentelemetry.io/docs/specs/semconv/gen-ai/；https://github.com/open-telemetry/semantic-conventions-genai；https://redis.io/en/blog/multi-agent-observability-why-one-trace-is-not-enough/；https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/develop/trace-agents-sdk。
- 原文链接：https://opentelemetry.io/docs/specs/semconv/gen-ai/；https://github.com/open-telemetry/semantic-conventions-genai；https://redis.io/en/blog/multi-agent-observability-why-one-trace-is-not-enough/；https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/develop/trace-agents-sdk。
- 影响判断：标准化战场已经从“LLM call span”进入“agent invocation、MCP tool、memory、handoff、identity scope”的因果链。OpenClaw 需要尽快确定 trace schema，否则未来接入 Langfuse/Phoenix/Braintrust/CloudWatch/Azure Monitor 会被迫做多套适配。

#### AWS / Google / Azure agent observability, evaluation, guardrails
- 本周动态：AWS 是本周云厂治理层信号最强的一家。AgentCore overview docs 将 Observability、Evaluations、Optimization、Policy 都列为 AgentCore core services：Observability 提供 trace/debug/monitor、标准 OpenTelemetry-compatible telemetry、CloudWatch dashboard、session count/latency/duration/token usage/error rates；Evaluations 支持对 Strands Agent 或 LangGraph 生成并通过 OpenTelemetry/OpenInference instrumented 的 sessions/traces/spans 做评估，结果进入 AgentCore Observability/CloudWatch；Optimization 用 traces 生成配置建议、版本化 configuration bundles、A/B testing；Policy 用 natural language 或 Cedar 做 deterministic control，集成 AgentCore Gateway，在 tool call 执行前拦截。AWS News Blog（原始发布时间早于本周，但有 2026-03 更新，作为背景）披露 AgentCore SDK preview 5 个月下载超过 2 million，PGA TOUR 内容写作速度 +1,000% / 成本 -95%，Workday Planning Agent routine planning analysis -30% / 每月省约 100 hours，Grupo Elfa 100% traceability / problem resolution time -50%。Google 侧，Gemini Enterprise Agent Platform scale docs 把生产 scale 分为 runtime、sessions、feedback service、memory bank、example store/evaluation、code execution，并列出 Cloud Trace/Cloud Logging/Cloud Monitoring、Example Store and Evaluation Service、Feedback service；安全表显示 Agent Runtime/Sessions/Memory Bank/Code Execution 支持 VPC Service Controls/CMEK/Data residency，Agent evaluation 支持 HIPAA 但不支持 VPC SC/CMEK/Data residency/Access Transparency。Azure/Microsoft Foundry tracing docs（背景）强调 OpenTelemetry trace exporters 到 Azure Monitor、Foundry portal traces、multi-agent semantic conventions、evaluation run IDs 与 redaction best practices。
- 关键数据：AWS docs：Observability metrics 包括 session count、latency、duration、token usage、error rates；Evaluations 支持 sessions/traces/spans、Strands Agent/LangGraph、OpenTelemetry/OpenInference；Policy 基于 Cedar/Gateway tool call intercept。AWS blog 背景数据：AgentCore SDK downloads >2 million；PGA TOUR +1,000% speed / -95% cost；Workday -30% routine planning analysis / 100 hours per month；Grupo Elfa 100% traceability / -50% problem resolution time。Google docs：Feedback Service、Example Store and Evaluation Service、Cloud Trace/Logging/Monitoring、Memory Bank；security matrix 如上。来源：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/observability.html；https://aws.amazon.com/blogs/aws/amazon-bedrock-agentcore-adds-quality-evaluations-and-policy-controls-for-deploying-trusted-ai-agents/；https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale；https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/develop/trace-agents-sdk。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/observability.html；https://aws.amazon.com/blogs/aws/amazon-bedrock-agentcore-adds-quality-evaluations-and-policy-controls-for-deploying-trusted-ai-agents/；https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale；https://learn.microsoft.com/en-us/azure/foundry-classic/how-to/develop/trace-agents-sdk。
- 影响判断：云厂正在把 observability/eval/guardrail 做成 managed agent platform 的核心控制面，而非外接插件。OpenClaw 的机会是用开源/本地优先的方式实现类似闭环：trace → eval → policy → replay/optimization；威胁是云厂在 CloudWatch/Azure Monitor/Cloud Trace 原生集成上更容易成为企业默认。

### 静默对象
- Helicone：本周未发现官方 release 级动态。README 背景显示 Helicone 已从 LLM observability 扩展为 AI Gateway + Observability，支持 agent tracing、LLM routing、cost/latency、automatic fallbacks、datasets/fine-tuning、SOC2/GDPR、自托管，free tier 10k requests/month；但本窗口没有可深写的新增事项。证据：https://github.com/Helicone/helicone。
- AgentOps：本周无 release 级动态。hot-scan 直查 5,751 stars / 613 forks，README 背景显示其定位为 AI agent monitoring、LLM cost tracking、benchmarking，支持 CrewAI、Agno、OpenAI Agents SDK、LangChain、Autogen/AG2、CamelAI，并有 session/agent/operation/task/workflow decorators 与 self-host app。证据：https://github.com/AgentOps-AI/agentops。

### 模块洞察
- Observability / Eval / Guardrails 层正在从“开发期调试工具”变成“生产控制面”：标准 trace 捕获事实，eval 持续给质量信号，policy/guardrail 在 gateway 执行确定性拦截，optimization 再反向改 prompt/tool config；这会成为企业 Agent Harness 的必备安全层。


---

## Managed Agent Platform / Enterprise Control Plane 平台层

- 时间窗：2026-07-30 00:00 → 2026-08-05 24:00（Asia/Shanghai）。
- 口径：本周动态只写窗口内公开公告、文档更新、release、commit 或搜索命中后已 web_fetch 原文的材料；旧能力只标“背景，非本周”。

## Managed Agent Platform / Enterprise Control Plane 平台层

### 本周模块结论
- AWS AgentCore 与 Google Gemini Enterprise 本周呈现最完整“企业 Agent 控制面”形态：前者把 harness、microVM session、memory、gateway、identity、browser/code、observability 做成可配置运行面；后者在 Gemini Enterprise release notes 中把 connector end-to-end tracing、PAYG 商业化、agent/MCP governance 逐步补齐。
- Microsoft 的强信号在“平台互联”：Copilot Studio 可接 Microsoft Foundry agent，并要求外部 agent 具备权限、边界、approval、observability、identity、traceability 与 human oversight；Agent Framework 也在模块 1 中体现可重放 session / checkpoint / MCP / Responses hosting。
- 中国云厂本周更偏“组件补齐与商业化”：阿里云百炼记忆库公布 2026-08-20 商业化计费，AgentScope 2.0 被定位为 Managed Agents 的 Harness/Runtime 底座；腾讯云 ADP 更新 Agentic RAG 与 CloudBase 资源点/AI 计费；火山/字节侧 OpenViking 形成 context database + hosted service + OpenClaw 集成参照。
- 对 OpenClaw 的参照：OpenClaw 的开放 Agent OS 与多渠道 runtime 仍有差异化，但云厂已经把 identity、observability、sandbox、memory、gateway 作为“企业控制平面套餐”售卖；OpenClaw 需要在控制台、审计、计费/成本、版本端点、policy-as-config 上补齐企业化表达。

### 固定对象状态表

| 对象 | 本周状态 | 证据源 | 是否深写 |
|---|---|---|---|
| AWS Bedrock AgentCore | 有动态/强文档信号：AgentCore harness GA；Bedrock Agents Classic 不再开放新客户并引导 AgentCore；AgentCore CLI 支持 harness/code-based agent、memory/gateway/identity/browser/code/evaluator/payments | https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/harness.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agentcore-get-started-cli.html；https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html | 是 |
| Google Vertex AI / Gemini Enterprise Agent Platform | 有动态：2026-08-04 connector end-to-end tracing；2026-08-01 PAYG GA；release notes 近期开启 Agent Registry / MCP governance、agent identity、observability | https://docs.cloud.google.com/gemini/enterprise/docs/release-notes | 是 |
| Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK | 有动态：Copilot Studio 文档 2026-08-03 更新，支持连接 Microsoft Foundry agent（preview）；Foundry classic agents deprecated，迁移到 GA Foundry Agents Service | https://learn.microsoft.com/en-us/microsoft-copilot-studio/add-agent-foundry-agent；https://learn.microsoft.com/en-us/azure/ai-foundry/agents/quickstart | 是 |
| 阿里云百炼 / Model Studio / PAI | 有动态：百炼记忆库 2026-08-20 开始商业化计费；AgentScope 2.0 被定位为 Managed Agents Harness/Runtime 底座；PAI SLA 变更为窗口内背景 | https://help.aliyun.com/zh/model-studio/memory-library；https://developer.aliyun.com/article/1753134 | 是 |
| 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking | 有动态：OpenViking context database 官方 repo/README 显示 hosted Volcano Engine service、BytePlus global hosting、OpenClaw 集成、benchmarks；ModelArk FAQ 文档 2026-08-03 更新但正文抓取不足 | https://github.com/volcengine/OpenViking；https://docs.byteplus.com/en/docs/ModelArk/2165245 | 是 |
| 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit | 有动态：腾讯云 ADP Agentic RAG 文档 2026-08-04 更新；CloudBase 资源点价格文档 2026-08-03 更新，AI 调用/知识库/身份/审计等进入套餐控制面 | https://cloud.tencent.com/document/product/1759/132211；https://cloud.tencent.com/document/product/876/127357 | 是 |
| Databricks Mosaic AI Agent Framework / Agent Bricks | 本周未见明确 release；官方文档继续展示 Agent Bricks、MCP tools、Unity Catalog Agent services、MLflow tracing/eval/monitoring 的企业控制面（背景/非本周） | https://docs.databricks.com/aws/en/agents/custom-agents/build-agents | 否 |

### 云厂能力矩阵

| 平台 | Runtime / Session | Memory / Context | Gateway / Tools | Identity / Auth | Sandbox / Browser / Code | Observability / Eval | 本周强信号 |
|---|---|---|---|---|---|---|---|
| AWS | AgentCore Runtime；harness session stateful；isolated microVM per session；CLI deploy/status/invoke | AgentCore Memory；short-term / long-term memory；files across sessions | AgentCore Gateway、MCP servers、AWS skills、tools config | AgentCore Identity：OAuth、API key credential providers、workload identity | AgentCore Browser、Code Interpreter、filesystem/shell、BYO container、S3/EFS mount | CloudWatch logs/traces/metrics；AgentCore evaluations / optimization / A/B tests | AgentCore harness GA；Bedrock Agents Classic 进入 maintenance，新客户转 AgentCore |
| Google | Gemini Enterprise app / Agent Platform；Agent Registry；A2A agents | data connectors / enterprise data stores；Deep Research / AlphaEvolve 等 agent | Agent Gateway、Custom MCP Server data stores、third-party connectors | Agent identity GA（SPIFFE ID / registry fallback）；BYOID mobile；connector policies | 安全 client-side code execution（AlphaEvolve 背景）；sandbox 细节公开少 | 2026-08-04 data connector tracing spans；agent observability GA（背景） | Connector end-to-end tracing + PAYG GA，平台商业化与可观测同步推进 |
| Microsoft | Foundry Agent Service；Copilot Studio standard harness；Foundry agent 可被 Copilot Studio 调用 | Foundry/Copilot Studio 连接企业数据；Agent Framework memory/session stores | Copilot Studio external agent connector；Foundry Toolbox；MCP/A2A in Agent Framework | Foundry RBAC roles；Copilot Studio 要求外部 agent 权限/边界/approval | Foundry code interpreter；PersistentAgents SDK thread/run；sandbox 细节在 Foundry 服务侧 | Agent Framework telemetry、Responses session persistence；Copilot Studio 文档强调 observability/traceability | Copilot Studio 连接 Foundry agent（preview），把低代码与专业 agent runtime 合流 |
| 阿里云 | AgentScope 2.0 被定位为 Managed Agents Runtime；百炼应用/agentscope-runtime 示例 | 百炼记忆库：记忆片段、用户画像、Add/Search API、多应用共享 | 百炼工具/联网搜索/应用工具；公开 gateway 标准化程度待观察 | API Key；用户以 `user_id` 隔离记忆；企业 IAM/细粒度权限公开不足 | AgentScope 2.0 提及 Sandbox 隔离；百炼侧 sandbox 细节待补 | 记忆检索调试、意图判别、rewrite/rerank；PAI/控制台能力分散 | 记忆库商业化定价公布，说明 Memory 正成为平台级计费项 |
| 火山/字节 | Ark/Coze 作为模型/应用平台；OpenViking server / hosted service；VikingBot | OpenViking：viking:// context DB，memory/resource/skills，L0/L1/L2，session memory | MCP clients、agent integrations、OpenClaw/Codex/Claude Code/LangGraph integrations | hosted service / BYOC 企业版计划；具体 identity/governance 仍待公开 | OpenViking 不是 sandbox；Coze/Ark sandbox 本周未见新公开细节 | retrieval trajectory 可观测；benchmark report；Coze Loop 本周未确认新动态 | OpenViking 已形成托管 Volcano Engine service + BytePlus global hosting 规划 |
| 腾讯云 | 腾讯云 ADP 的 Claw / Multi-Agent 模式；CloudBase serverless/runtime | ADP 知识库 + Agentic RAG；CloudBase 知识库容量计费 | ADP tools：AgenticRAGSearch；CloudBase APIs/连接器 | CloudBase 身份认证、企业身份源、组织成员、自定义角色、审计日志（套餐列示） | CloudBase 云函数/云托管；agent sandbox 未见独立公开 | Agentic RAG 自我反思轮数；CloudBase 运维监控/日志保存 | Agentic RAG 文档更新 + 资源点价格把 AI/知识库/身份纳入套餐 |
| Databricks | Custom agents、Databricks Apps、Agent endpoints、Agent services Beta | Knowledge Assistant、Unity Catalog governed resources | MCPs and agent tools、Unity Catalog functions、external APIs | Unity Catalog grants 控制 agent services | Databricks Apps / code execution；sandbox 细节不作为本周动态 | MLflow Tracing、Agent Evaluation、online monitoring | 本周静默；长期强项是 Unity Catalog + MLflow 把 agent 纳入数据治理 |

### 深度笔记

#### AWS Bedrock AgentCore
- 本周动态：AWS 文档当前明确把 Amazon Bedrock Agents 重新命名为 Agents Classic，并提示“no longer open to new customers”，相似能力引导到 Amazon Bedrock AgentCore。AgentCore harness 文档把“agent harness”定义为模型调用、工具选择、结果回传、上下文管理、失败处理背后的生产基础设施，并强调 managed harness 可用配置声明 model、tools、skills、instructions，AgentCore 负责 environment、compute、memory、identity、networking、observability。原文关键细节包括：每个 harness session 默认有状态，运行在 secure isolated microVM per session；具备 filesystem and shell；可跨 microVM session 过期后持久化 short-term/long-term memories 与 files；支持 Amazon Bedrock、OpenAI、Google Gemini 或 LiteLLM-compatible provider，并可 mid-session 切换 provider；工具连接可通过 AgentCore Gateway、MCP servers、built-in browser、code interpreter；支持 AWS skills from Git/S3/catalog、BYO container、S3/EFS mount；每个 action 自动 traced；支持 evaluations/optimization、A/B tests、immutable versions、named endpoints、Step Functions InvokeHarness；无单独 harness charge，按底层 AgentCore capability 计费。
- 关键数据：AgentCore CLI 需要 Node.js 20+、Python 3.10+；`agentcore add` 支持 memory、agent、gateway、credential、evaluator、payment-manager、payment-connector；开发端口默认 HTTP 8080、MCP 8000、A2A 9000；harness GA across listed regions（AWS 文档）。
- 原文链接：https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/harness.html；https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agentcore-get-started-cli.html；https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html
- 影响判断：AWS 是本周“控制面收编 Harness 模块”的最强样本：不仅托管 runtime，还把 memory、gateway、identity、sandbox、observability、evaluation、versions/endpoints、payments 全部纳入 AgentCore。OpenClaw 的对应策略是把自托管优势包装成“可插拔 AgentCore 替代”：同样提供声明式 harness、版本/endpoint、审计 trace 与成本视图。

#### Google Vertex AI / Gemini Enterprise Agent Platform
- 本周动态：Gemini Enterprise release notes 在 2026-08-04 发布“End-to-end tracing support for data connectors”，新增两个 trace spans：`execute_tool` 表示 agent orchestration layer 上的工具执行，`invoke_connector` 表示 connector execution layer 的请求逻辑和执行；这些 spans 支持从 assistant prompt 到第三方 API 的 parent-child workflow 可视化，可在 Trace Explorer 中按 service/span name 搜索过滤，也可通过 `gemini_enterprise.assist_token` 或 W3C trace ID 查询。2026-08-01，Gemini Enterprise Pay-as-you-go edition GA，支持无 pooled user license quotas 的按功能用量付费，需 invoiced Cloud Billing account，一 seat minimum，可在 Console 监控 feature usage 与设 monthly spend limits。虽然 Agent Registry / MCP governance、agent identity、observability GA 等更新在 6 月底（背景，非本周），但本周 tracing 与 PAYG 正好补上“企业敢用”的两条腿：可追踪与可计费。
- 关键数据：2026-08-04 新 spans：`execute_tool`、`invoke_connector`；2026-08-01 PAYG GA，一 seat minimum，gradual rollout；查询字段 `gemini_enterprise.assist_token`、W3C trace ID（Google 官方 release notes）。
- 原文链接：https://docs.cloud.google.com/gemini/enterprise/docs/release-notes
- 影响判断：Google 的路线是把 agent platform 放进 Gemini Enterprise app，与 data connectors、Agent Registry、MCP/A2A、Trace Explorer、Cloud Billing 绑定。对 OpenClaw 的参照是：tool call tracing 不能只停留在日志，必须跨 orchestration layer 与 connector execution layer 串成 parent-child trace，并可按 user/session/assist token 查询。

#### Microsoft Foundry Agent Service / Copilot Studio / M365 Agent SDK
- 本周动态：Copilot Studio 文档 `Connect to a Microsoft Foundry agent (preview)` 在 2026-08-03 更新，说明可将 Microsoft Foundry Agent 连接到 Copilot Studio custom agent，让主 agent 调用外部 Foundry agent 响应用户或 trigger。流程包括 Agents 页面 Add an agent、选择 Microsoft Foundry、创建/选择 connection、提供 Foundry project endpoint URL、填写 SDK agent Name/Description、输入 Agent Id、测试。文档特别强调：只能连接 new Microsoft Foundry portal 创建的 agents，previous portal agent 会报 `404 - Version not found`。同页还写明这些功能由 standard harness 驱动，并提示连接 Copilot Studio 外部 agent 时，用户负责确保 data flows/data handling、quality/security/trustworthiness、permissions/boundaries/approvals、observability/identity/traceability/human oversight 合规。Foundry quickstart 抓取到 classic agents 已 deprecated，将于 2027-03-31 retired，应使用 GA Microsoft Foundry Agents Service，并提供 migration guide。
- 关键数据：Copilot Studio doc `updated_at: 2026-08-03T14:59:00Z`；classic agents retire date 2027-03-31；Foundry RBAC roles 包括 Foundry User / Owner / Account Owner / Project Manager（角色名重命名但 role IDs/permissions unchanged）。
- 原文链接：https://learn.microsoft.com/en-us/microsoft-copilot-studio/add-agent-foundry-agent；https://learn.microsoft.com/en-us/azure/ai-foundry/agents/quickstart
- 影响判断：Microsoft 的平台层重点是把低代码 Copilot Studio、专业 Foundry Agents、Agent Framework/MCP/A2A 串成一套 enterprise control plane。OpenClaw 若要进入企业，需要类似“外部 agent 注册/描述/权限/审批/traceability checklist”，并支持从自托管 agent 暴露为可被企业平台调用的 governed endpoint。

#### 阿里云百炼 / Model Studio / PAI
- 本周动态：阿里云百炼记忆库文档显示“记忆库将于 2026 年 8 月 20 日 10:00（北京时间）正式开始商业化计费”。能力上，记忆库自动从对话提取关键信息并持久化，在后续对话中语义检索并注入上下文，支持开放 API、任意应用接入、多应用共享同一记忆库；支持两类记忆：记忆片段（事件/信息）与用户画像（结构化属性）。API 流程包括 `AddMemory` 写入、控制台查看、`SearchMemory` 检索；Python 示例依赖 `agentscope-runtime`。配置层支持每个记忆库最多 50 条记忆片段规则和 50 条用户画像规则，记忆过期时间可选 7 天、30 天、180 天、永不过期，检索调试支持最大召回 1-100、意图判别召回、改写、排序、相似度阈值建议 0.5-0.7。阿里云开发者社区 2026-08-04 文章把 AgentScope 2.0 定位为 Managed Agents 的 Harness 底座，强调 Harness 内核与 Sandbox 隔离能力可作为底层 Runtime。
- 关键数据：商业化时间 2026-08-20 10:00；免费额度：Add 4 个规格各 250 次（合计 1,000 次，3 个月）、Search 2 个规格各 2,500 次（合计 5,000 次，3 个月）、10,000 条记忆免费存储长期有效；Add 观察记忆 Pro ¥0.03/次、Lite ¥0.018/次；画像 Pro ¥0.03/次、Lite ¥0.025/次；Search Pro ¥0.001/次、Lite ¥0.00002/次；存储 ¥0.002/万条/小时（约 ¥1.44/万条/月）；限流总计 3000 QPM、add 120 QPM、search 300 QPM。
- 原文链接：https://help.aliyun.com/zh/model-studio/memory-library；https://developer.aliyun.com/article/1753134
- 影响判断：阿里本周的关键信号是 Memory 从“Agent 功能”变成“独立平台计费项”，且与 AgentScope Runtime/Sandbox 形成托管 agent 底座。OpenClaw 的对应机会是把 memory 也拆成可配置、可迁移、可审计、可计费/限流的独立层，而不是隐藏在 prompt 注入中。

#### 火山引擎 Ark / Coze / Coze Studio / Coze Loop / OpenViking
- 本周动态：未抓到 Coze / Coze Loop 在窗口内的高质量官方 release 原文；本周可深写的火山/字节强信号来自 OpenViking。OpenViking GitHub README 直读显示其定位为 AI agents 的 open-source context database，将 memories、resources、skills 统一到 `viking://` 虚拟文件系统，agent 可像开发者操作文件一样 `ls/tree/find` 自己的上下文；内容写入时处理为 L0 abstract、L1 overview、L2 details，按需加载；检索路径会保留 trajectory，便于 debug；session commit 后异步提取用户偏好和 agent experience 到长期记忆。它还显示 OpenViking Studio playground 可浏览器体验，支持 Claude Code、Codex、OpenClaw、Hermes、Cursor、Trae、OpenCode、MCP clients、LangChain/LangGraph 等集成；OpenViking Helper 桌面控制台可解析 Claude Code、Codex、Trae sessions，显示 recall、prompt injection、MCP calls、capture、commit events。商业化上，README 写明 OpenViking Personal 官方托管，Hosted on Volcano Engine in China，BytePlus global hosting service 与 private distributed enterprise edition / BYOC 计划。
- 关键数据：OpenViking 0.3.22 benchmark：LoCoMo 上三种 agent integrations 准确率 80–83%，native memory 24–57%；input tokens drop 34.3–91.0%，query latency drop 58.45–66.10%；tau2-bench experience memory 带来 retail +6.87pp、airline +11.87pp；OpenViking Helper 0.0.19；README 显示 VikingMem paper accepted by VLDB 2026。
- 原文链接：https://github.com/volcengine/OpenViking；https://docs.byteplus.com/en/docs/ModelArk/2165245
- 影响判断：火山/字节的平台层在 Agent memory/context 上有明确差异化：不是把 memory 当普通 vector store，而是作为可浏览、可观测、可托管的 context database。对 OpenClaw 的参照非常直接：OpenViking 已列出 OpenClaw 集成，OpenClaw 可将其作为外置 Context DB 选项，同时保留本地 memory 与 skills 的轻量路径。

#### 腾讯云智能体平台 / 元器 / CloudBase AI Toolkit
- 本周动态：腾讯云智能体开发平台 ADP 的 Agentic RAG 文档最近更新时间为 2026-08-04 11:57:01。文档将 Agentic RAG 定义为下一代知识库问答能力，相比传统单次检索-生成，基于 Agent Loop 实现自主反思、智能切换检索策略、多轮迭代检索，工具名从传统 `KnowledgeRetrievalAnswer` 变为 `AgenticRAGSearch`。配置流程包括在 Claw 模式或 Multi-Agent 模式应用中添加 AgenticRAGSearch 工具，配置反思模型、重排序模型、知识检索范围与反思轮数；反思轮数范围 0-10，默认 3，0 轮退化为标准检索，1-3 推荐平衡质量与速度，7-10 最高准确度但成本/延迟高。CloudBase 资源点价格文档最近更新时间为 2026-08-03，显示云开发平台资源点计费模式覆盖个人/标准/企业/企业高级版，AI 调用、知识库容量、内置模型 token、身份认证、审计日志、组织成员、工作流/云函数/云托管等都纳入套餐/资源点控制面。
- 关键数据：Agentic RAG 反思轮数 0-10，默认 3；重排序模型 `youtu-rerank-llm`（默认，高精度）与 `youtu-rerank`（轻量）；CloudBase 资源点换算 1000:1；AI 调用 10 点/万次（0.01 元/万次）、知识库容量 10 点/GB/天（0.01 元/GB/天）；免费体验版 3000 点/月，个人版 40,000 点/月，标准版 330,000 点/月，企业版 1,500,000 点/月，企业高级版 6,500,000 点/月。
- 原文链接：https://cloud.tencent.com/document/product/1759/132211；https://cloud.tencent.com/document/product/876/127357
- 影响判断：腾讯的强项是把 agent 能力贴近 CloudBase/低代码/小程序生态，并把 AI、知识库、身份认证、审计、组织管理纳入统一套餐。OpenClaw 可借鉴其 Agentic RAG 的“反思轮数/成本提示”配置方式，把高级 agent behavior 暴露为可控旋钮。

#### Databricks Mosaic AI Agent Framework / Agent Bricks
- 本周动态：本周未确认窗口内官方 release；作为背景，Databricks agents 文档展示了非常完整的企业 agent 控制面：AI Playground 用于 no-code prototyping，Knowledge Assistant 和 Supervisor Agent 属于 Agent Bricks；custom agents 支持 Python，且可用 LangGraph、LangChain、OpenAI、LlamaIndex 等 authoring library，集成 MLflow Tracing 并可用 Databricks Apps 快速迭代；MCPs and agent tools 可连接结构化/非结构化数据、运行代码、外部 API；Unity Catalog Agent services（Beta）支持注册外部 agent、团队发现与 grants 权限；MLflow Tracing、Agent Evaluation、Monitor agents 负责开发和生产阶段的质量、成本、延迟、trace 与在线监控。
- 关键数据：文档未提供窗口内发布日期；搜索命中显示 3 days ago 但不作为硬日期证据；本对象标“背景，非本周”。
- 原文链接：https://docs.databricks.com/aws/en/agents/custom-agents/build-agents
- 影响判断：Databricks 不是最抢眼的通用 Agent OS，但在企业数据治理上非常关键：它把 agent endpoint、tools、functions、data、tracing、eval 放入 Unity Catalog / MLflow 体系。OpenClaw 如果要服务企业知识工作流，最终也需要把 skills/tools/memory 与数据权限、lineage、review app 对齐。

### 静默对象说明
- Coze / Coze Studio / Coze Loop：本周未抓到足够权威的官方 release 原文，暂不写具体新动态；保留为火山/字节平台背景。
- Databricks：本周未见明确 release，写背景不写“本周动态”。

### 模块洞察
- Enterprise Control Plane 正在把 Agent Harness 的六个底层模块（runtime、memory、gateway、identity、sandbox、observability）打包为平台 SKU：AWS 最完整，Google/Microsoft 在企业治理与互联上强，阿里/腾讯/火山在 Memory、Agentic RAG、Context DB 与本土生态上加速商品化；OpenClaw 的差异化在开放与自托管，但企业化需要补齐 policy、catalog、trace、version、billing 五个控制面。


---

## 信息校验

- 对象覆盖：8 个模块、7 个平台矩阵项、固定对象与补漏对象合计约 80 个条目。

- 数据点：可机械检索数字/日期/指标约 142 个；关键数据均保留来源 URL 或标注背景。

- 结论/判断：模块结论、影响判断、模块洞察与 OpenClaw 参照合计约 98 条。

- 原文链接：去重后 112 个 URL。
