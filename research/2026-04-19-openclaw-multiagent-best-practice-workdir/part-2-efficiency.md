# Part 2 — 执行效率（Efficiency）最佳实践

> **核心洞察（来自 Anthropic + Cognition）**：
> - Anthropic（2025 Research System）：多 agent 主要是为了"花够 token"——token 用量解释 80% 的性能差异。Opus 主 + Sonnet 子比单 Opus **高 90.2%**。
> - Cognition（Don't Build Multi-Agents）：并行 sub-agent 是**脆弱架构**，因为 "Actions carry implicit decisions, and conflicting decisions carry bad results"。
> - **老板团队的甜区**：Research/breadth-first 任务（wairesearch 本职）适合多 agent；**代码和设计**（waicode/product）要警惕过度拆分。

---

## 1. 任务编排模式（串行 / 并行 / 流水线）

### OpenClaw 原生能力

从 `docs/tools/subagents.md`：
- `sessions_spawn` 总是**非阻塞**，返回 `{ runId, childSessionKey }`
- 配合 `sessions_yield` 让父 agent 主动结束 turn，等 announce 回来
- 并发由 `agents.defaults.subagents.maxConcurrent`（默认 8）控制
- `maxSpawnDepth=2` 允许 **statue-1 orchestrator → 多 leaf** 的金字塔

### 选择标准（基于 Anthropic + Cognition 的教训）

| 任务类型 | 推荐模式 | 依据 |
|---------|---------|------|
| **研究/广度探索**（wairesearch） | 并行 fanout，Opus 主 + Sonnet 子 | Anthropic 确认适合 |
| **写代码**（waicode） | 严格**串行**，不拆并行子任务 | Cognition principle 2：implicit decisions 冲突 |
| **文档起草/设计**（product） | 串行 + 单 agent 长 context | 风格一致性优先 |
| **竞品/市场扫描**（bizstrategy） | 并行 fanout 收集 + 串行合成 | 收集可并行，分析不可 |
| **日常监控/待办**（growth） | cron 触发串行，不用 sub-agent | 简单工作流过度编排浪费 |
| **多子话题长报告**（任一 agent） | 流水线：拆→并行做→串行合成 | 每个 part 写入文件持久化 |

### Cognition 两大 principle（老板要内化）

1. **Share context, and share full agent traces, not just individual messages**——别只把"子任务描述"丢给 sub-agent，要附上父 agent 的完整 trace（或至少关键决策）
2. **Actions carry implicit decisions, and conflicting decisions carry bad results**——两个并行 sub-agent 做同一个大任务的两半，必然在风格/假设上冲突

### 老板现状诊断

- 现在统帅→五岳是**严格 fan-out**（一 turn 派发多个），但 Cognition 原则 1 要求**传递完整 trace**
- 老板的 "共享文件在 `shared/` 目录" 是正确方向——让子 agent 读 `shared/status/*/current.md` 了解兄弟在做什么（被动同步）

### 落地动作

| 动作 | 命令/配置 |
|------|----------|
| **写 ORCHESTRATION.md 给统帅** | 在 `workspace-main/AGENTS.md` 里规定：派发 sub-agent 前必须 `write shared/context/<task-id>.md` 把"父 agent 的决策+上下文"写入文件，子 agent 开头必须 `read` 这个文件 |
| **禁止超过 3 个并行**（代码类任务） | `agents.defaults.subagents.maxConcurrent: 3` |
| **研究类任务用串行 fanout**：一个一个起、一个一个 yield | 统帅 AGENTS.md 里写明 |
| **使用 sessions_yield 正确姿势**：spawn 完所有子 → 调用 sessions_yield → 等 announce | 已在 OpenClaw 系统提示里强调 |
| **TaskFlow 适用场景**（skill 已装）| 仅用于需要跨 turn 状态保留的长流程；普通 spawn+yield 不用上 TaskFlow |

---

## 2. 上下文传递效率

### light context vs full context

从 `docs/automation/cron-jobs.md`：cron isolated job 支持 `--light-context` 跳过 bootstrap 文件注入。普通 sub-agent 只注入 `AGENTS.md + TOOLS.md`（已是 light mode）。

| 场景 | 选择 | 节省 |
|------|------|------|
| 子 agent 接简单独立任务（如"查一个 API 文档"）| light | -10K tokens/turn |
| 子 agent 需要人设和语气（如客服）| full | 保留 SOUL/USER |
| cron 跑批处理（如每日简报）| `--light-context` | 每次跑省 10-15K |

### attachAs / attachments

OpenClaw `sessions_spawn.task` 字段本身就是 prompt，**但支持**在文件系统级别挂载：

```
# 方式 1：直接让 task 引用文件
sessions_spawn task="读 /workspace/shared/ctx/task-001.md 后完成研究任务"

# 方式 2：上下文写入 workspace-<agent>/memory/，子 agent 会自动看到（如果不是 light）
```

**关键**：`sessions_spawn` 不接受 channel-delivery 参数（没有 `attachAs`），要传图片/文件只能通过文件系统。

### 专家无状态下最小化重复传上下文

老板 SOUL.md 里已经说"你是无状态 agent"。最佳实践：

```
┌────────────────────────────────────────────────────┐
│  统帅（长 context）                                  │
│    ↓ 写 shared/context/TASK-XXX.md（含决策+约束）    │
│  五岳（每次都要 read 这个文件）                       │
│    ↓ 完成后写 shared/artifacts/TASK-XXX/*.md        │
│  统帅（读 artifacts 合成）                           │
└────────────────────────────────────────────────────┘
```

这对应 Cognition 的 **Share context** principle——用**文件系统**作为隐式的共享 context 通道。

---

## 3. 模型与 thinking 搭配

### Anthropic 官方验证结论

> "Multi-agent system with Claude Opus 4 as the lead agent and Claude Sonnet 4 subagents outperformed single-agent Claude Opus 4 by **90.2%**"
> "Token usage by itself explains 80% of the performance variance"

### 老板团队的甜区矩阵

| Agent | 角色 | 推荐 model | thinking | 月成本影响（vs 全 Opus） |
|-------|------|-----------|---------|------------------------|
| 小帅（main） | 编排大脑 | **Claude Opus 4.7** | high | 基准 |
| wairesearch | 深度调研 | Claude Opus 4.7（研究大脑）| medium | 基准 |
| waicode | 代码 | Claude Opus 4.7（或 Sonnet-for-coding）| medium | -0% 到 -60% |
| bizstrategy | 战略分析 | Claude Opus 4.7 | low（写分析可以快）| -0% 到 -30% |
| product | 产品设计/文案 | **Claude Sonnet 4.6** | low | **-80%** |
| growth | 增长执行 | **Claude Sonnet 4.6** | off | **-80%** |
| clawdoctor | 诊断工具 | **Claude Haiku 4.6** | off | **-95%** |
| sub-agents（研究子） | 子研究员 | **Claude Sonnet 4.6** | low | 每次 spawn 省 4x |

### 关键 OpenClaw 机制

```json5
{
  agents: {
    defaults: {
      subagents: {
        model: "anthropic/claude-sonnet-4-6",  // 默认子 agent 用 Sonnet
        thinking: "low"
      }
    },
    list: [
      {
        id: "wairesearch",
        model: "anthropic/claude-opus-4-7",    // 父用 Opus
        subagents: {
          model: "anthropic/claude-sonnet-4-6",  // 子用 Sonnet
          thinking: "medium"
        }
      }
    ]
  }
}
```

### thinking=on/off/stream 的选择

- `off`：结构化搜索、日程查询、批量文件操作、clawdoctor 诊断
- `low`：正常写作、简单研究
- `medium`：代码重构、战略分析、常规研究
- `high`：顶层规划、复杂代码审查、架构决策（统帅 only）
- `xhigh`：罕见，只在真正卡壳时用

**陷阱**：thinking 会乘法放大 token 成本。老板的 SOUL.md 里有 `reasoning off (hidden unless on/stream)`——合理保留了 thinking，但要**按任务调整**。

### 成本估算

按老板团队当前假设流量：
- 统帅每天 50 turns，每 turn 平均输入 30K/输出 5K
- 五岳平均每 agent 每天 20 turns，每 turn 输入 20K/输出 8K（含 thinking）
- clawdoctor 每天 5 turns

**全 Opus 4.7**（$15/MTok input, $75/MTok output）：
- 统帅：50 × (30 × $0.015 + 5 × $0.075) = 50 × $0.825 = $41.25/天
- 五岳（5 个）：5 × 20 × (20 × $0.015 + 8 × $0.075) = 100 × $0.9 = $90/天
- clawdoctor：5 × ($0.015 × 20 + $0.075 × 3) = 5 × $0.525 = $2.6/天
- **总计：约 $134/天，$4020/月**

**按本报告分层方案**（Opus + Sonnet + Haiku）：
- 统帅：不变，$41.25/天
- waicode + wairesearch + bizstrategy（仍 Opus）：3 × 20 × $0.9 = $54/天
- product + growth（Sonnet 4.6，$3/MTok input, $15/MTok output）：2 × 20 × (20 × $0.003 + 8 × $0.015) = 40 × $0.18 = $7.2/天
- clawdoctor（Haiku 4.6，$1/MTok input, $5/MTok output）：5 × (20 × $0.001 + 3 × $0.005) = 5 × $0.035 = $0.18/天
- **总计：约 $102.6/天，$3078/月**

**节省：$942/月（23%）**，且 90%+ 任务质量不受影响（因为 product/growth/clawdoctor 的任务难度不需要 Opus）。

---

## 4. 工具调用优化

### OpenClaw 明文规则（来自本次 subagent context）

> "If you intend to call multiple tools and there are no dependencies between the calls, make all of the independent calls in the same `<function_calls>` block"

**老板团队应用**：
- 五岳要养成**一次并行多个 read/search 的习惯**（本次 research 就在用）
- 但 **exec** 的并行要小心（见 security notes）

### web-search-plus 智能路由（老板已装）

老板 TOOLS.md 明确策略：
```
首选：web-search-plus（智能多源）
兜底：web_search（Brave，1 req/s 限速）
```

**为什么重要**：Brave 的 2000 次/月 + 1 req/s 限速会让五个五岳很快互相打架。web-search-plus 自动路由到 Serper/Tavily/Exa/Perplexity 分散压力。

### 减少往返次数（batch 化）

| 坏模式 | 好模式 |
|-------|-------|
| 一次 web_search，读结果，再 web_search 深化 | 第一次就做 3 个 query 的并行 web_search |
| read 一个文件再决定 read 下一个 | 已知相关路径就 `ls` + 并行 `read` |
| 依次 git log、git diff、git blame | 一次 exec `git log --stat && git diff HEAD~1` |

### 落地建议

在每个五岳的 AGENTS.md 加一行：
```md
### 工具调用效率
- 独立 tool call 必须并行（同一个 function_calls 块）
- web_search 至少 2 个维度同时起
- read 多文件时一次性提交所有路径
- web-search-plus 优先；Brave 作为兜底（1 req/s 限速要错峰）
```

---

## 5. 缓存与复用

### OPENCLAW_CACHE_BOUNDARY 的作用

查老板的 subagent context 可见：
```
<!-- OPENCLAW_CACHE_BOUNDARY -->
## Subagent Context
```

**机制**（来自 `docs/concepts/system-prompt.md`）：
- boundary 之前的内容是**稳定前缀**，可以进入 Anthropic/Bedrock 的 prompt cache
- boundary 之后是每次 turn 变化的动态后缀
- 命中 cache 可以把 input token 成本降到 **1/10**（Anthropic cache read 是原价的 10%）

### 影响老板团队的关键动作

| 动作 | 效果 |
|------|------|
| **保持 SOUL/AGENTS/TOOLS/IDENTITY/USER 稳定**（上 git，少改）| 这些注入在 cache boundary 之前，稳定 = cache hit rate 高 |
| **频繁改 MEMORY.md 是 cache 杀手** | MEMORY.md 也在 boundary 之前，每改一次 cache 失效。**建议**：MEMORY.md 改动批量合并（比如 cron 每天晚上 rebuild 一次） |
| **session 连续对话 > 每次新开** | 同一 session 的 turn N+1 可以复用 turn N 的 cache prefix |
| **subagent 每次 spawn 都是新 session**，不享受 cache | 接受这个代价；用 Sonnet 降低子 agent 成本 |

### 子 agent 复用（mode=session vs mode=run）

从 `docs/tools/subagents.md`：
- `mode: "run"`（默认）：一次性，结束后 session 就归档
- `mode: "session"`（必须配 `thread: true`）：持久 session，多次调用复用

| 场景 | 推荐 mode |
|------|----------|
| 一次性调研、一次性写代码 | `run` |
| Discord 频道绑定的持续讨论 | `session`（配合 `/focus`） |
| 老板当前场景（Telegram direct，无 thread binding）| 只能 `run` |

**注意**：Telegram 不支持 thread binding（目前只有 Discord 支持），所以老板团队目前**只能用 `mode: "run"`**。

### Cron + isolated session 批处理

从 `docs/automation/cron-jobs.md`：

```bash
# 每天凌晨 3 点跑团队复盘（独立 session，不烧主 session）
openclaw cron add \
  --name "daily-review" \
  --cron "0 3 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "跑 openclaw sessions --all-agents --json，找出昨天的失败 sub-agent，总结 top 3 问题。结果写入 shared/reviews/$(date +%F).md" \
  --light-context \
  --tools exec,read,write \
  --model "anthropic/claude-haiku-4-6" \
  --announce --channel telegram --to "<boss-chat>"
```

`--light-context` 跳过 bootstrap；`--tools` 收紧权限；`--model haiku` 降本——单次跑成本 ≈ $0.05。

### Cron 踩坑（重要）

从 `docs/automation/cron-jobs.md`：**croner 的 day-of-month + day-of-week OR 语义**：
```
0 9 15 * 1  # 实际是 "每月15号OR每周一 9 点"，不是"15号恰逢周一"
# 要强制 AND：用 + 修饰符 → 0 9 15 * +1
```

---

## 📌 Part 2 小结（执行效率）

**Top 3 立即做**：
1. **模型分层落地** —— product/growth 降到 Sonnet，clawdoctor 降到 Haiku（月省 $900+）
2. **子 agent 默认 Sonnet** —— `agents.defaults.subagents.model: sonnet`（Anthropic 已验证 Opus+Sonnet 组合好于全 Opus）
3. **保护 cache boundary** —— SOUL/AGENTS 稳定化、MEMORY.md 批量改（cache hit 率从 0% 到 40%+）

**Top 3 下一步**：
4. 共享 context 机制：统帅 spawn 前必写 `shared/context/TASK-XXX.md`
5. cron + isolated 把每日复盘/简报从主 session 剥离
6. 任务模式表上墙：研究类并行、代码类串行、日常用 cron

---
*产出人：黄山 | 日期：2026-04-19*
