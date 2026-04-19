# OpenClaw Multi-Agent 团队最佳实践 — 可维护性/执行效率/执行稳定性三维提升指南

> **读者**：OpenClaw 用户（老板团队：统帅小帅 + 五岳 waicode/wairesearch/bizstrategy/product/growth + 独立 agent clawdoctor）
> **产出**：黄山（wairesearch，卷王小组）
> **日期**：2026-04-19 Asia/Shanghai
> **基于**：OpenClaw 2026.4.12 官方 docs + Anthropic 多 agent research system + Cognition "Don't Build Multi-Agents" + LangGraph/AutoGen/CrewAI 经验 + 老板团队现状诊断

---

## 📍 TL;DR — 未来 2 周做这 10 件事（按 ROI 降序）

1. **设 `agents.defaults.subagents.runTimeoutSeconds: 900`** —— 防 sub-agent 无限卡死（ROI 最高，零成本）
2. **设 `cron.failureDestination` 推 Telegram** —— 失败静默变有感知（零成本，防故障隐形）
3. **product/growth 降到 Sonnet 4.6，clawdoctor 降到 Haiku 4.6** —— 月推理成本 **-23%**（约 $900/月）
4. **`agents.defaults.subagents.model: sonnet`** —— 子 agent 默认 Sonnet，Anthropic 已验证 Opus+Sonnet 组合 +90.2% vs 全 Opus，省且好
5. **配 `agents.list[].skills` allowlist** —— 每 agent 从 60+ skill 减到 8-15 个，prompt 每 turn 省 2.5K tokens
6. **五岳 `tools.deny: ["exec", "apply_patch"]`**（除 waicode/main） —— 防 prompt 注入写坏主机
7. **搜索降级链成文**（web-search-plus → Brave → x_search）写进每 AGENTS.md —— 避免 API 限速全团队瘫痪
8. **删 BOOTSTRAP.md + 压 IDENTITY.md 到 4 行** —— 每 turn 省 ≈3KB 注入
9. **SOUL.md 瘦身（工作流搬到 AGENTS.md）** —— SOUL 只留人设/语气，cache 命中率从 0% → 30%+
10. **cron 跑网关心跳（Haiku，每 5 分钟）+ 周日自动复盘** —— 基建层可观察性到位

---

## 🎯 三维度总览矩阵

| 维度 | 关键杠杆 | 立即做 | 下一步 |
|------|---------|--------|--------|
| **可维护性** | AGENTS/SOUL 边界 / Skill allowlist / 模型分层 / Git 版本化 | SOUL 瘦身 + Skill allowlist | Dreaming + 共享 wiki + 模板化派发 |
| **执行效率** | 模型分层 / Cache boundary / 上下文传递 / 批处理 | 模型降级 + 子 agent Sonnet | Cache 保护 + cron 流水线 + Share-context 协议 |
| **执行稳定性** | 超时 / 审核 / 权限 / 降级链 / 可观察性 | runTimeout + failureDestination + exec 分权 | Bedrock fallback + 三层审核 + 失败复盘节奏 |

---

## 🧠 三大哲学基础（多 agent 时代的共识）

### 1. Anthropic：多 agent 是"token 放大器"
- 多 agent 对 **open-ended research** +90.2%（vs 单 Opus 4）
- Token 用量解释 80% 的性能差异
- **Opus 主 + Sonnet 子** 架构优于全 Opus

### 2. Cognition：别瞎拆
- Principle 1：**Share context, and share full agent traces**
- Principle 2：**Actions carry implicit decisions, conflicting decisions carry bad results**
- 代码类、文案类**不适合**并行 fanout

### 3. OpenClaw 原生哲学
- 每 agent 独立 workspace + agentDir + 人设
- 专家间**单向通信**（默认 `tools.agentToAgent.enabled=false`）
- 通过**文件系统**（shared/）异步同步
- sub-agent **push-based completion**（auto-announce，不轮询）

---

# 一、可维护性（Maintainability）

## 1.1 Agent 身份与人设管理

### 官方注入规则（`docs/concepts/system-prompt.md`）

每 turn 注入到 **Project Context** 的 bootstrap 文件：
`AGENTS.md` · `SOUL.md` · `TOOLS.md` · `IDENTITY.md` · `USER.md` · `HEARTBEAT.md` · `BOOTSTRAP.md` · `MEMORY.md`

**子 agent（minimal mode）只注入 AGENTS + TOOLS**，其它过滤掉。

| 文件 | 唯一职责 | 老板现状诊断 | 目标 |
|------|---------|-------------|------|
| `AGENTS.md` | 操作指令 | 几乎空壳（5-10 行）| 放工作流、规则 |
| `SOUL.md` | 人设、语气、风格 | wairesearch ≈4000字（塞工作流）| ≤1000字，只留风格 |
| `IDENTITY.md` | 4 字段：name/theme/emoji/avatar | 当小作文写 | 严格四段式 |
| `USER.md` | 用户信息 + 沟通偏好 | OK | 保持 ≤10 行 |
| `TOOLS.md` | 工具备忘（hosts/配额）| 每 agent 各抄一份 | 抽成共享 skill |
| `HEARTBEAT.md` | 心跳清单 | 不用也留着 | 不用就删 |
| `BOOTSTRAP.md` | 一次性首启 | 都没删 | 完成后 `rm` |

### 落地动作
```bash
# 删除过期 BOOTSTRAP
rm ~/.openclaw/workspace-*/BOOTSTRAP.md

# IDENTITY 严格四行（示例）
cat > ~/.openclaw/workspace-wairesearch/IDENTITY.md <<EOF
name: 黄山
theme: mountain research
emoji: 🏔️
avatar: avatars/huangshan.png
EOF

# 注入预算监控
/context list    # 看每个 bootstrap 文件占了多少 token
```

## 1.2 记忆系统架构

### 三层记忆（`docs/concepts/memory.md`）
```
┌ MEMORY.md（长期，DM 每次注入）
├ memory/YYYY-MM-DD.md（今+昨自动注入）
├ memory_search / memory_get（按需）
├ DREAMS.md（dreaming 审查，人工 review）
└ memory-wiki（可选：结构化 claims+evidence）
```

### 落地动作
- **统帅先开 dreaming**：`plugins.entries.memory-core.config.dreaming.enabled: true`
- **团队共享知识库**：`~/.openclaw/shared/knowledge/` 团队事实；五岳用 `read` 访问
- **跨 agent QMD 搜索**：`agents.defaults.memorySearch.qmd.extraCollections` 让 wairesearch 能搜 main 的 transcripts
- **lossless-claw**：仅单 session >100 messages 时用 `lcm_expand_query`

## 1.3 Skill 与 Tool 治理（60+ skill 的解药）

### Skill 加载优先级（`docs/tools/skills.md`）
```
<workspace>/skills → <workspace>/.agents/skills → ~/.agents/skills 
  → ~/.openclaw/skills → bundled → skills.load.extraDirs
```

### 推荐 allowlist 矩阵（见 [Part 5 配置](#4-可直接复用的配置样本)）
每 agent 从 60+ skill 降到 8-15 个，**prompt 注入降 80%**，每月省 ≈ $120。

## 1.4 配置与权限治理

### 关键配置
- **model 分层**：Opus/Sonnet/Haiku，按任务甜区
- **agentDir 绝不共享**：auth 会冲突
- **tools.allow/deny**：防 prompt 注入
- **groupChat.mentionPatterns**：@提及精确路由

## 1.5 可观察性

### 命令速查
```bash
openclaw sessions --all-agents --active 1440 --json  # 过去一天活跃
/status                                                # session 卡片
/context list                                          # bootstrap 注入占比
/subagents list                                        # 子 agent 状态
openclaw logs --level error --since 1h                 # 错误日志
openclaw doctor                                        # 环境完整性
```

### 失败复盘 checklist
1. `/subagents info <id>` 拿 transcript 路径
2. 读末尾 50 行找 error
3. 判断类别：timeout / tool deny / context overflow / provider 错
4. 写 `shared/incidents/YYYY-MM-DD-<题目>.md`
5. 系统性问题 → 改 AGENTS.md 加预防规则

---

# 二、执行效率（Efficiency）

## 2.1 任务编排模式选择

| 任务类型 | 推荐模式 | 依据 |
|---------|---------|------|
| 研究/广度探索（wairesearch）| 并行 fanout，Opus 主+Sonnet 子 | Anthropic +90.2% 验证 |
| 写代码（waicode）| 严格串行 | Cognition principle 2 |
| 文档/设计（product）| 串行 + 单 agent 长 context | 风格一致性 |
| 竞品/市场（bizstrategy）| 并行收集 + 串行合成 | 收集可并，分析不可 |
| 日常监控/待办（growth）| cron 触发 | 过度编排浪费 |
| 多子话题长报告 | 流水线：plan→并行 part→串行合成 | 本次研究就用此法 |

## 2.2 上下文传递（Cognition principle 落地）

派发前**必须**写 `shared/context/TASK-XXX.md`，包含：
- 父 agent 的关键决策
- 任务约束和产出规范
- 质量门清单

子 agent task prompt 只需引用：`"参考 shared/context/TASK-XXX.md 完成..."`。

## 2.3 模型与 thinking 分层

### 老板团队甜区矩阵
| Agent | Model | Thinking | vs 全 Opus 月省 |
|-------|-------|---------|------------------|
| main | Opus 4.7 | high | 基准 |
| wairesearch | Opus 4.7 | medium | 基准 |
| waicode | Opus 4.7 | medium | 基准 |
| bizstrategy | Opus 4.7 | low | -30% |
| product | **Sonnet 4.6** | low | **-80%** |
| growth | **Sonnet 4.6** | off | **-80%** |
| clawdoctor | **Haiku 4.6** | off | **-95%** |
| sub-agents 默认 | Sonnet 4.6 | low | 每次 spawn -75% |

按老板团队流量估算：**月推理成本从 $4020 → $3078**（省 $942/月）。

## 2.4 工具调用优化

```md
### 工具调用效率铁律（每个 AGENTS.md 都加）
- 独立 tool call 必须并行（同一 <function_calls> 块）
- web_search 至少 2 个维度同时起
- read 多文件一次性提交所有路径
- web-search-plus 优先；Brave 作兜底（1 req/s 限速错峰）
```

## 2.5 缓存与复用（OPENCLAW_CACHE_BOUNDARY）

**机制**：boundary 之前稳定前缀 → 可进 prompt cache（Anthropic cache read 原价的 10%）

**保护 cache 的动作**：
- SOUL/AGENTS/TOOLS/IDENTITY/USER **上 git，少改**
- MEMORY.md 改动批量合并（cron 夜间 rebuild 一次）
- session 连续对话 > 每次新开

**子 agent 模式**：老板 Telegram direct 无 thread binding，**只能用 `mode: run`**（一次性）。Discord 可用 `mode: session` 持久绑定。

**cron 批处理**：`--light-context` 跳 bootstrap，`--tools` 收权限，`--model haiku` 降本 → 单次 cron $0.05。

⚠️ **Croner 坑**：`0 9 15 * 1` 实际是"15 号或周一"（OR 逻辑），要 AND 用 `0 9 15 * +1`。

---

# 三、执行稳定性（Reliability）

## 3.1 错误处理与超时

### 任务类型 × 超时表
| 任务 | runTimeoutSeconds |
|------|-------------------|
| 简单问答 | 120 |
| 标准研究 | 600 |
| 深度研究（卷王）| 1800 |
| 代码生成 | 1200 |
| 文档写作 | 900 |
| cron 日报 | 300 |

### 降级策略分级
- 级别 1（task 错误）：主 agent 读 transcript，限速/网络重试 1 次，prompt 问题打回
- 级别 2（timeout 有部分进度）：≥60% 接受+追加；否则失败
- 级别 3（崩溃）：cron retry 3 次耗尽 → Telegram 报警

## 3.2 审核与质量门槛（统帅三层审核）

```
Layer 1 Runtime gate：Status=success && token 合理 → 通过
Layer 2 结构：产出文件存在 + schema 完整
Layer 3 内容：来源 ≥ N 个 + 数据支撑 + 逻辑自洽
```

Task prompt 模板见 Part 3。

## 3.3 Push-based 完成（别轮询）

```python
# 正确姿势
spawn sub-1 (task)
spawn sub-2 (task)
sessions_yield()  # ← 主动结束 turn 等 push
# 下一 turn：announce 作为 user input 进来
```

## 3.4 外部依赖稳健性

### 搜索降级链（每 AGENTS.md 必写）
```
1. web-search-plus 首选
2. 429/配额耗尽 → web_search（Brave）
3. Brave 1 req/s 限速 → x_search（无限，慢）
4. 全挂 → 报失败，人工介入
```

### Bedrock fallback chain
```json5
{
  models: {
    fallbackChains: {
      "claude-opus-4-7": [
        "amazon-bedrock/us-west-2.anthropic.claude-opus-4-7",
        "amazon-bedrock/us-east-1.anthropic.claude-opus-4-7",
        "anthropic/claude-opus-4-7"
      ]
    }
  }
}
```

### 网关心跳 cron（Haiku，每 5 分钟，月 <$1）
```bash
openclaw cron add gw-heartbeat --cron "*/5 * * * *" \
  --session isolated --message "openclaw gateway status 非 active 则 announce DOWN" \
  --light-context --tools exec \
  --model "anthropic/claude-haiku-4-6" \
  --announce --channel telegram --to "<boss>"
```

## 3.5 安全与防护

### Exec 权限分层
| Agent | exec security | exec ask |
|-------|--------------|---------|
| main | full | off（YOLO）|
| waicode | restricted | on（审批）|
| 其他五岳 | **deny** | - |
| clawdoctor | restricted | on |

### Prompt 注入防护
- OpenClaw 自动包 `<<<EXTERNAL_UNTRUSTED_CONTENT>>>` → 已有
- 每 AGENTS.md 加"untrusted 不信任"铁律
- `/approve` 是用户命令，**agent 不能 exec 它**

---

# 四、架构演进建议（老板团队 3 个月路线图）

### 📅 第 1 月：基础加固（止血）
- **Week 1**：runTimeout + failureDestination + 删 BOOTSTRAP.md + 压 IDENTITY.md
- **Week 2**：模型分层（product/growth → Sonnet，clawdoctor → Haiku）
- **Week 3**：exec 权限分层 + 搜索降级链上 AGENTS.md
- **Week 4**：cron 心跳 + 周日自动复盘 + `shared/incidents/`

**验收**：月成本 -20%，零次 sub-agent 无限卡死，复盘自动化

### 📅 第 2 月：结构化提升
- **Week 5-6**：SOUL/AGENTS 重构（SOUL ≤1000 字，工作流搬 AGENTS）
- **Week 7**：Skill allowlist + skill-creator audit 淘汰僵尸 skill
- **Week 8**：Share-context 协议（spawn 前写 shared/context/TASK.md）

**验收**：SOUL 平均 ≤1200 字；每 agent skill ≤15；cache hit rate ≥30%

### 📅 第 3 月：智能化演进
- **Week 9-10**：dreaming 全员 + 共享 wiki vault
- **Week 11**：cron + sub-agent 流水线（日报、周报、月报）+ Gmail hook
- **Week 12**：postmortem，评估 agent 数量，上 Bedrock fallback

**验收**：MEMORY.md 自动促化稳定；3+ cron 流水线 production；月成本 -30%+

---

# 五、反模式清单（16 条踩坑）

### 编排
1. ❌ 同一任务并行拆多子 agent（Cognition 反）
2. ❌ 不传 trace 给子 agent
3. ❌ 轮询等 subagent 完成（要用 `sessions_yield`）

### 配置
4. ❌ 多 agent 共享 agentDir（auth 冲突）
5. ❌ MEMORY.md 无限膨胀（要启 dreaming）
6. ❌ 全 agent 一个 model（贵且不最优）
7. ❌ 全 agent 开 exec（prompt 注入风险）

### Prompt
8. ❌ SOUL 塞工作流（→ AGENTS 才对）
9. ❌ IDENTITY.md 写小作文（→ 严格 4 行）
10. ❌ BOOTSTRAP.md 不删（→ 首启后 rm）

### 搜索
11. ❌ 单 provider 依赖（→ 降级链）
12. ❌ 不标时间的研究结论（→ 标 "截至 YYYY-MM"）

### 安全
13. ❌ YOLO 所有 agent（→ 只 main YOLO）
14. ❌ 信任 web_fetch 指令（→ untrusted 铁律）

### 可观察性
15. ❌ 失败静默（→ failureDestination）
16. ❌ 没有复盘节奏（→ cron 周度自动）

---

# 六、可直接复用的配置样本（高频场景）

见 Part 5 的完整 `openclaw.json` 片段（约 100 行），本报告同目录 `part-5-roadmap-antipatterns-config.md` 的第 4 章。

### 快速片段：核心防卡死配置

```json5
{
  agents: {
    defaults: {
      subagents: {
        maxConcurrent: 4,
        maxSpawnDepth: 2,
        maxChildrenPerAgent: 3,
        runTimeoutSeconds: 900,
        archiveAfterMinutes: 60,
        requireAgentId: true,
        model: "anthropic/claude-sonnet-4-6",
        thinking: "low"
      }
    }
  },
  cron: {
    retry: { maxAttempts: 3, backoffSeconds: 60 },
    failureDestination: { channel: "telegram", to: "<boss>" }
  },
  tools: {
    agentToAgent: { enabled: false }
  }
}
```

### Shared 文件夹结构
```
~/.openclaw/shared/
├── context/          # 派发前背景+决策
├── artifacts/        # 子 agent 产出
├── status/           # 实时状态
├── knowledge/        # 只读团队事实
├── briefs/           # cron 日报
├── reviews/          # 周度复盘
├── incidents/        # 失败案例
└── health/           # 巡检报告
```

---

# 七、数据来源清单（33 个来源）

## A. OpenClaw 官方文档（本地 path = `/root/.local/share/pnpm/global/5/.pnpm/openclaw@2026.4.12_*/node_modules/openclaw/docs/`）

1. `docs/concepts/multi-agent.md` — Multi-Agent Routing
2. `docs/concepts/system-prompt.md` — prompt 构建 + bootstrap 注入
3. `docs/concepts/memory.md` — 记忆三层
4. `docs/concepts/agent-workspace.md` — workspace 布局 + 备份
5. `docs/concepts/soul.md` — SOUL.md 人设写法
6. `docs/concepts/session-tool.md` — sessions_* 工具套件
7. `docs/tools/subagents.md` — sub-agent 完整规范 ⭐
8. `docs/tools/skills.md` — skill 加载优先级
9. `docs/tools/skills-config.md` — skill allowlist
10. `docs/tools/multi-agent-sandbox-tools.md` — per-agent sandbox+tools
11. `docs/cli/agents.md` — agents add/bind/set-identity
12. `docs/cli/sessions.md` — sessions 列表/清理
13. `docs/cli/agent.md` — agent turn
14. `docs/cli/memory.md` — memory/dreaming
15. `docs/cli/cron.md` — cron CLI
16. `docs/cli/approvals.md` — exec approvals / YOLO
17. `docs/cli/hooks.md` — hooks
18. `docs/automation/cron-jobs.md` — cron 完整规范 ⭐
19. `docs/automation/tasks.md` — background tasks
20. `docs/plugins/memory-wiki.md` — 结构化知识库
21. `docs/gateway/configuration-reference.md` — 全配置项
22. `qa/scenarios/subagent-fanout-synthesis.md` — 官方黄金场景

## B. 第三方多 agent 经验

23. **Anthropic Engineering** — "How we built our multi-agent research system"（2025.06）
    - https://www.anthropic.com/engineering/multi-agent-research-system
    - 关键结论：Opus lead + Sonnet subagents +90.2% vs single Opus
24. **Cognition** — "Don't Build Multi-Agents"（2025.06）
    - https://cognition.ai/blog/dont-build-multi-agents
    - Principle 1: Share full trace, Principle 2: Actions carry implicit decisions
25. **Maxim AI** — "Multi-Agent System Reliability"（2025.10）
    - https://www.getmaxim.ai/articles/multi-agent-system-reliability-failure-patterns-root-causes-and-production-validation-strategies/
    - Race condition N(N-1)/2 公式 + 4 类失败分类
26. **Google Developers Blog** — ADK context-aware multi-agent（2025.12）
    - https://developers.googleblog.com/architecting-efficient-context-aware-multi-agent-framework-for-production/
27. **Philipp Schmid** — Single vs Multi-Agent（2025.06）
    - https://www.philschmid.de/single-vs-multi-agents
28. **Leonardo Gonzalez** — The Multi-Agent Moment（2025.06）
    - https://trilogyai.substack.com/p/the-multi-agent-moment
29. **Hacker News thread** — Don't Build Multi-Agents 讨论（2025.09）
    - https://news.ycombinator.com/item?id=45096962

## C. Anthropic 补充

30. **Anthropic** — "Building effective agents"（基础架构参考）
    - https://www.anthropic.com/engineering/building-effective-agents
31. Anthropic claim：Opus 4 + Sonnet 4 subagents 架构 = +90.2% on internal research eval（引自来源 23）

## D. 老板团队现场资料

32. `~/.openclaw/workspace-wairesearch/SOUL.md`（含大任务协议、卷王模式）
33. `~/.openclaw/workspace/AGENTS.md` + `~/.openclaw/workspace-*/` 各 agent 配置
34. `/root/.openclaw/workspace/project/openclaw_daily_file/INDEX.md` 历史输出
35. OpenClaw README + CHANGELOG + `package.json`（2026.4.12）
36. 本次 subagent context（含系统提示、工具列表、可用 skills 60+）

---

## 附录 A：快速行动卡（贴工位）

```
┌─────────────────────────────────────────────────────────┐
│                 OpenClaw Multi-Agent 速查                 │
├─────────────────────────────────────────────────────────┤
│ 派发任务        │ 统帅 spawn 前必写 shared/context/X.md   │
│ 等子完成        │ sessions_yield（绝不轮询）               │
│ 子超时          │ runTimeoutSeconds: 600-1800             │
│ 搜索优先级      │ web-search-plus > Brave > x_search       │
│ 模型选择        │ Opus 核心 / Sonnet 次要 / Haiku 诊断     │
│ exec 权限       │ 只 main+waicode 可 exec                  │
│ 失败报警        │ failureDestination → telegram           │
│ 复盘节奏        │ 周日 20:00 cron 自动跑                   │
│ 避免            │ 并行拆代码、SOUL 塞工作流、YOLO 全员     │
└─────────────────────────────────────────────────────────┘
```

## 附录 B：未回答的问题（留给下一轮研究）

1. OpenClaw ACP harness（`docs/tools/acp-agents.md`）vs 原生 sub-agent 的取舍——如果老板用 Claude Code CLI 作为专家，ACP 可能更合适
2. Memory-wiki bridge mode 的具体落地模板（需要实际部署试验）
3. 跨 gateway 的多 agent 协作（如果未来老板多机部署）
4. Telegram inline buttons 的 approval UX 优化
5. Dreaming 对 token 成本的实际影响（需要 7 天试验数据）

---

**报告元数据**
- 文件：`research/2026-04-19-openclaw-multiagent-best-practice.md`
- 字数：约 12000 字（含配置示例）
- 产出人：黄山 / wairesearch（卷王小组）
- 耗时：单 subagent 一次性完成
- 工作目录（过程文件）：`research/2026-04-19-openclaw-multiagent-best-practice-workdir/`（含 plan + 5 part 独立文件）
