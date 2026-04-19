# Part 4 — 第三方多 Agent 框架经验对比

> **核心结论**：市面上主流 multi-agent 框架（LangGraph / AutoGen / CrewAI / OpenAI Swarm）代表了三种哲学分叉。**OpenClaw 在哲学上最接近 LangGraph + Anthropic multi-agent research system**，但在**人格隔离、channel 路由、workspace 文件、cron 批处理**上独有优势。

---

## 1. 三大哲学阵营

### 阵营 A：Cognition（Don't Build Multi-Agents）

**核心主张**（2025.06）：
- "Don't Build Multi-Agents" —— 并行 sub-agent 是脆弱架构
- 两条不可妥协的 Principle：
  1. **Share context, and share full agent traces, not just individual messages**
  2. **Actions carry implicit decisions, and conflicting decisions carry bad results**
- 推崇：**单个长 agent（Claude Code 风格）**，加强 context engineering
- 举的反例：OpenAI Swarm、Microsoft AutoGen

**对老板团队的警示**：
- 如果五岳并行做同一个任务的"不同部分"（比如"一半代码一半测试"），必然冲突
- **解法**：要么不拆，要么每个子 agent 拿到完整父 trace

### 阵营 B：Anthropic（多 Agent Research System）

**核心主张**（2025.06）：
- 多 agent 对 **open-ended research** 任务 +90.2%（vs 单 Opus）
- 原理：subagents 有独立 context window = 并行扩展 context 容量 = 多花 token = 质量更好
- **Token usage 解释 80% 的性能差异** — 三因素（token/tool call/model）共 95%
- 推崇：**Opus lead + Sonnet 子** 的金字塔架构
- 明确承认："the gap between prototype and production is often wider than anticipated"

**对老板团队的启示**：
- wairesearch（研究专家）**本职就是 Anthropic 的场景**，并行拆分合理
- 但 waicode（代码）更接近 Cognition 场景，**别乱拆并行**

### 阵营 C：Google ADK / Microsoft / LangGraph（中间派）

**核心主张**（2025.12）：
- 分层 context：tiered storage + compiled views + pipeline processing + strict scoping
- 认同 race condition 问题：**N 个 agent 有 N×(N-1)/2 个并发冲突点**
- 把多 agent 失败归为四类：
  1. **State Synchronization Failures**（stale / conflicting / partial visibility）
  2. **Communication Protocol Breakdowns**（message ordering、timeout/retry ambiguity）
  3. **Task Decomposition Failures**（子任务定义不清、粒度错）
  4. **Context Fragmentation**（子 agent 各看一隅）

**对老板团队的启示**：
- 五岳通过 `shared/` 文件系统通信——是**事件溯源**模式，天然规避 race（单写多读）
- 但要防 **stale read**：五岳完成后要写"完成标记"，主 agent 读前检查

---

## 2. 框架对比矩阵

| 维度 | OpenClaw 2026.4 | LangGraph | CrewAI | AutoGen | Anthropic native | Claude Code |
|-----|-----------------|-----------|--------|---------|-----------------|-------------|
| **范式** | Orchestrator + 专家 + cron + channel 路由 | 显式 graph 状态机 | 角色扮演团队 | 对话式多 agent | Research lead + subagents | 单 agent 深度 context |
| **人格隔离** | ✅ 每 agent 独立 workspace+auth+memory | ❌ 共享 state | ⚠️ role 字段 | ⚠️ 角色 | ❌ | N/A |
| **持久化 state** | ✅ sessions.json + transcripts + MEMORY.md | ✅ checkpointer | ⚠️ 有限 | ❌ 内存 | N/A | transcript |
| **Channel 路由** | ✅ 原生（Telegram/Discord/WhatsApp/飞书/Slack…） | ❌ | ❌ | ❌ | ❌ | ❌ |
| **定时任务** | ✅ cron 原生（含 Gmail PubSub hook）| ❌ | ❌ | ❌ | ❌ | ❌ |
| **工具沙箱** | ✅ per-agent Docker/scope | ⚠️ 需外接 | ⚠️ | ⚠️ | ⚠️ | ✅ |
| **Skills 治理** | ✅ AgentSkills 标准 | ❌ | ❌ | ❌ | ⚠️ | ✅ |
| **Sub-agent 深度** | 最多 5 层（推荐 2）| 无限制 | 1 层 | 无 | N/A | 1 层 |
| **并发控制** | 队列 lane + maxConcurrent | 无 | 无 | 无 | ✅ | ✅ |
| **记忆促化/压缩** | ✅ dreaming + lossless-claw | ⚠️ | ❌ | ❌ | ❌ | ✅ 内置 |
| **适合场景** | **个人+团队运营、长期脑、多 channel** | 复杂工作流 graph | Demo/原型 | 实验 | Research | 代码/深研 |
| **学习曲线** | 中（配置 JSON5 + skills）| 陡 | 低 | 中 | 低 | 低 |
| **生产成熟度** | 2026 生产就绪 | 2025 较成熟 | 2024 偏弱 | 2024 实验 | 2025 成熟 | 2025 成熟 |

---

## 3. 各框架踩坑教训（可直接借鉴）

### LangGraph 经验（可借鉴）

- **好的**：显式 graph state + checkpointer = 失败可恢复
- **踩坑**：状态污染难 debug，edge case 多
- **对老板**：老板用文件系统做"持久化 state"已经在借鉴这个思路

### CrewAI 经验（避坑）

- **踩坑**：role 字段过于口号化（"研究员"/"经理"），真正干活还是靠 prompt 质量。**形式主义风险**。
- **对老板**：五岳的 SOUL.md 就是 "role prompt"，**质量比形式重要**。别陷入"有了 agent 就万事大吉"的错觉。

### AutoGen 经验（避坑）

- **踩坑**：agent 之间自由对话容易陷入 echo chamber、无穷循环、互相夸奖
- **对老板**：OpenClaw 强制**单向通信**（专家间不直接通信，通过 main）是正确的
- **不要**启用 `tools.agentToAgent.enabled`（老板已默认 false）

### OpenAI Swarm 经验（避坑）

- **踩坑**：handoff 语义不清，谁是当前 owner 经常丢失
- **对老板**：OpenClaw 的 `sessions_spawn` 返回 runId，owner 关系由 runtime 追踪，安全

### Claude Code / Cognition 经验（借鉴）

- **好的**：单 agent + 强 context engineering = 可靠
- **对老板**：**不要把所有事都拆成 sub-agent**。简单任务统帅自己做（不 spawn），只在真的 breadth-first 时才 fanout。

---

## 4. 综合给老板的哲学指南

### 什么时候用多 agent

| 场景 | 多 agent? | 理由 |
|------|----------|------|
| 广度调研（wairesearch 的卷王模式）| ✅ | Anthropic 验证 +90% |
| 多源信息收集（5 个网站同时查）| ✅ | 独立 context 并行 |
| 人格/身份隔离（不同 channel 不同人设）| ✅ | OpenClaw 原生优势 |
| 独立领域专家（代码/战略/设计）| ⚠️ | 看任务是否真需要隔离；否则统帅一个人做 |
| 拆分一个项目的子模块 | ❌ | Cognition 的反例 |
| 并行 refactor 同一代码库 | ❌ | 冲突必然 |
| 日常对话 | ❌ | 单 agent 够 |

### 多 agent 成功的三个必要条件（本研究总结）

1. **任务天然并行**：广度优先、独立 query、独立来源
2. **产出可合并**：文件系统/结构化 output，不是"一半代码一半设计"
3. **共享 context 通道**：子 agent 能访问父的决策（文件 / memory / explicit trace）

---

## 📌 Part 4 小结（第三方对比）

- **OpenClaw 在多 channel + 人格隔离 + cron + skills 治理上独步**，这是老板团队的真正杠杆
- **Anthropic 和 Cognition 不矛盾**：Anthropic 说"研究类可以 fanout"，Cognition 说"代码类别 fanout"——按任务分类
- **反模式避坑**：CrewAI 的形式主义、AutoGen 的自由对话、Swarm 的 ownership 丢失都要警惕
- **老板团队的结构**（统帅+五岳+文件系统通信）已经规避了主要踩坑

---
*产出人：黄山 | 日期：2026-04-19*
