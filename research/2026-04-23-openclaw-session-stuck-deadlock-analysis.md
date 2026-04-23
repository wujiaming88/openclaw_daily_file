# OpenClaw Session 状态管理机制 & Stuck/死锁问题深度分析

> 研究时间：2026-04-23 | 研究员：黄山 (wairesearch)
> 基于：OpenClaw v2026.4.12 源码 + 官方文档 + GitHub Issues

---

## 目录

1. [Session 状态管理机制](#1-session-状态管理机制)
2. [Stuck Session 原因分析](#2-stuck-session-原因分析)
3. [Session 死锁原因分析](#3-session-死锁原因分析)
4. [解决方法与最佳实践](#4-解决方法与最佳实践)
5. [排查手册（实操指南）](#5-排查手册)

---

## 1. Session 状态管理机制

### 1.1 Session 完整生命周期

```
消息到达 → 路由(sessionKey) → 入队(Command Queue) → 获取 Session 锁
    → 加载 SessionManager → 构建 System Prompt → LLM 推理
    → 工具执行 → 流式回复 → Compaction 检查 → 释放锁 → 排队下一个
```

**状态机模型（从源码和文档推断）：**

```
                    ┌──────────┐
    新消息到达 ──→  │  queued   │  ← 在 Command Queue 等待
                    └────┬─────┘
                         │ lane 空闲，获取 session 写锁
                         ▼
                    ┌──────────┐
                    │ running   │  ← LLM 推理 + 工具执行
                    └────┬─────┘
                         │
              ┌──────────┼──────────┐
              │          │          │
              ▼          ▼          ▼
         ┌────────┐ ┌────────┐ ┌────────┐
         │complete│ │aborted │ │ error  │
         └────┬───┘ └────┬───┘ └────┬───┘
              │          │          │
              ▼          ▼          ▼
         ┌─────────────────────────────┐
         │  compaction（可选触发）       │
         └─────────────────────────────┘
              │
              ▼
         释放锁 → drain 下一个排队任务
```

**关键状态说明：**

| 状态 | 含义 | 源码位置 |
|------|------|---------|
| `queued` | 消息入队，等待 lane 空闲 | `dist/command-queue-Deq0-o7-.js` |
| `running` | 嵌入式 Pi agent 正在执行 | `dist/runs-CiwSS2N4.js` |
| `aborted` | 被用户或超时中止 | `abortWithReason()` in runs |
| `complete` | 成功完成 | lifecycle `phase: "end"` |
| `error` | 执行出错 | lifecycle `phase: "error"` |
| `compacting` | 自动压缩进行中 | compaction-safeguard.ts |

### 1.2 Session 存储方式

**两层持久化架构：**

| 层 | 文件 | 用途 | 特性 |
|----|------|------|------|
| Session Store | `~/.openclaw/agents/<agentId>/sessions/sessions.json` | 键值映射：sessionKey → SessionEntry | 小文件、可变、安全编辑 |
| Transcript | `~/.openclaw/agents/<agentId>/sessions/<sessionId>.jsonl` | 追加写入的对话树 | JSONL、有 id+parentId 树结构 |

**SessionEntry 关键字段：**
- `sessionId`: 当前 transcript ID
- `updatedAt`: 最后活动时间戳
- `compactionCount`: 自动压缩次数
- `inputTokens/outputTokens/totalTokens/contextTokens`: token 计数器
- `providerOverride/modelOverride`: 模型覆盖

**Transcript 结构：**
- 第一行：session header（`type: "session"`，含 `id`, `cwd`, `timestamp`, `parentSession`）
- 后续：带 `id` + `parentId` 的树结构 entries
- 类型：`message`, `custom_message`, `custom`, `compaction`, `branch_summary`

> **来源**：`docs/reference/session-management-compaction.md`

### 1.3 Session 与 Gateway 的关系

**核心原则：Gateway 是唯一的 Session 状态 owner。**

```
┌────────────────────────────────────────────┐
│              Gateway Process                │
│                                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │ Channel  │  │ Command  │  │ Session  │ │
│  │ Handlers │→ │  Queue   │→ │ Manager  │ │
│  │(TG/WA/DC)│  │(per-lane)│  │(per-key) │ │
│  └──────────┘  └──────────┘  └──────────┘ │
│                                            │
│  ┌──────────┐  ┌──────────┐               │
│  │  Pi      │  │ Session  │               │
│  │ Runtime  │  │  Store   │               │
│  │(embedded)│  │(.json)   │               │
│  └──────────┘  └──────────┘               │
└────────────────────────────────────────────┘
```

- UI 客户端（macOS app、Web UI、TUI）通过 WebSocket 查询 Gateway 的 session 数据
- 远程模式下，session 文件在远程主机上
- Gateway 是单进程架构，一个 host 只运行一个 Gateway

> **来源**：`docs/concepts/architecture.md`, `docs/reference/session-management-compaction.md`

### 1.4 并发控制机制

**三层并发控制：**

#### 层 1：Command Queue（Lane 系统）

```javascript
// dist/command-queue-Deq0-o7-.js
CommandLane = {
  Main: "main",        // 入站消息 + 心跳
  Cron: "cron",        // 定时任务
  Subagent: "subagent", // 子 agent
  Nested: "nested"      // 嵌套调用
}
```

- **per-session lane**：每个 sessionKey 一个 lane，保证同一 session 同一时间只有一个 active run
- **global lane**：`main` lane 限制整体并发，默认 `maxConcurrent: 4`（main）和 `8`（subagent）
- 实现：纯 TypeScript + Promises，无外部依赖

#### 层 2：Session 文件锁

- Transcript `.jsonl` 文件使用 `.jsonl.lock` 锁文件
- 锁超时：10000ms（10 秒）
- 锁获取失败 → 错误 → session 不可用

> **来源**：GitHub Issue #31489 — `session file locked (timeout 10000ms)`

#### 层 3：Gateway 进程级隔离

- 单进程模型，全部状态在进程内
- Gateway restart 时的 drain 机制：`markGatewayDraining()` → 拒绝新任务 → 等待活跃任务完成
- drain 超时：30 秒

### 1.5 Sub-agent Session 管理

**父子关系模型：**

```
父 session (agent:main:telegram:direct:xxx)
    │
    ├── 子 session 1 (agent:main:subagent:uuid-1)
    ├── 子 session 2 (agent:main:subagent:uuid-2)
    └── ...
```

- `sessions_spawn` 创建隔离 session，**始终非阻塞**，立即返回 `runId` + `childSessionKey`
- 子 session 运行在 `subagent` lane（并发上限 8）
- 完成后通过 announce 机制将结果推送给父 session
- 默认叶子 sub-agent 不获得 session tools，防止递归失控
- `maxSpawnDepth >= 2` 时，depth-1 orchestrator 可获得 `sessions_spawn` 等工具

> **来源**：`docs/concepts/session-tool.md`

---

## 2. Stuck Session 原因分析

### 2.1 已确认的 Stuck 模式（来自 GitHub Issues）

#### 模式 1：LLM API 流式挂起（#17258）— 最高频

**频率**：20+ 次/天（活跃实例）
**根因**：上游 LLM API 接受了流式请求但不产生任何 token

```
T+0s    工具结果发给 API，流式请求开始
T+0-2s  API 返回 HTTP 200 headers
T+2s    ...静默，无 token 到达...
T+120s  Typing indicator TTL 过期 — 用户不再看到"输入中"
T+300s  per-attempt timeout 触发，session abort
```

**核心问题**：OpenClaw 唯一的超时是绝对超时（默认 600s），没有**流式不活跃超时**。HTTP 连接保持打开但无 SSE chunks 时，系统一直等到绝对超时。

**解决状态**：v2026.2.x 引入了 `agents.defaults.llm.idleTimeoutSeconds`（LLM 空闲超时），默认值取 `timeoutSeconds`（若设定）否则 120s。

> **来源**：GitHub Issue #17258 + `docs/concepts/agent-loop.md`

#### 模式 2：Compaction 死循环 + 锁文件残留（#21621）— Browser Tool 触发

**频率**：100% 使用 Browser Tool 时触发（特定版本）
**根因**：Browser Tool 执行后触发 compaction，compaction 进入 retry 循环永不完成

```
embedded run tool start: tool=browser
embedded run tool end: tool=browser
embedded run agent end: isError=false
embedded run compaction start
embedded run compaction retry    <-- 卡在这里
typing TTL reached (2m)          <-- 2 分钟后 bot 显示"离线"
```

**关键证据**：没有 `embedded run done` 日志 — session 永远不完成。残留 `.jsonl.lock` 文件阻止后续操作。

> **来源**：GitHub Issue #21621

#### 模式 3：Gateway 自请求死锁（#18470）— 内部命令阻塞

**根因**：Agent 在 active turn 中调用内部 OpenClaw 命令（如 `openclaw sessions --json`），Gateway 无法处理自我查询

```
Agent turn 开始 → Agent 调用 exec("openclaw sessions --json")
    → 命令需要查询 Gateway 状态
    → Gateway 正在等 agent turn 完成才能处理新请求
    → 死锁！等待 10 分钟后超时
```

**影响链**：超时 → spend limit 耗尽 → failover 到备用 provider → 备用 provider 也限速 → 费用失控

> **来源**：GitHub Issue #18470

#### 模式 4：Session 文件锁超时（#31489）

**根因**：`.jsonl.lock` 文件残留（崩溃、异常退出、compaction 中断）
**超时**：10000ms（10 秒）
**后果**：锁获取失败 → agent 无法回复

**Workaround**：重启 Gateway 或删除 lock 文件（`rm -f ~/.openclaw/agents/*/sessions/*.lock`）

> **来源**：GitHub Issue #31489

#### 模式 5：Gateway restart 时 Compaction 中断（#17635）

**根因**：config.apply 触发 SIGUSR1 restart 时 session 正在 compaction，30 秒 drain timeout 不够 compaction 完成

**后果**：Gateway 强制 restart → session 处于 inconsistent state → 后续操作失败

> **来源**：GitHub Issue #17635

#### 模式 6：Context 超限导致 Compaction 死循环（#25620）

**根因**：session context 超过模型 token 限制后，`/compact` 命令的 summarization 请求本身也超限

**悖论**：context 太长无法 compact → 不 compact 就无法缩短 context → 死循环

> **来源**：GitHub Issue #25620

#### 模式 7：工具调用失败无恢复（#8288）

**根因**：工具调用挂起后无超时、无恢复、无 fallback。没有 `openclaw run abort --all` 这样的命令。

**唯一恢复方式**：`/new` 或 `/reset` — 但会丢失全部 session context

> **来源**：GitHub Issue #8288

### 2.2 Stuck 原因分类汇总

| 类别 | 根因 | 频率 | 严重度 | Issues |
|------|------|------|--------|--------|
| LLM 挂起 | API 流式不活跃 | 极高 | 🔴 | #17258 |
| Compaction 死锁 | Lock 文件残留 + retry 循环 | 高 | 🔴 | #21621, #25620 |
| 自请求死锁 | Gateway 不能处理活跃 turn 中的内部查询 | 中 | 🔴 | #18470 |
| 文件锁超时 | .lock 残留 | 中 | 🟡 | #31489 |
| Restart 中断 | Drain timeout 不够 | 低 | 🟡 | #17635 |
| 工具无超时 | 工具执行无 timeout/fallback | 中 | 🔴 | #8288 |
| Sub-agent 未返回 | 子 agent 卡住，父 agent 等待 | 中 | 🟡 | #4173 |

---

## 3. Session 死锁原因分析

### 3.1 死锁经典四条件在 OpenClaw 中的映射

| 条件 | OpenClaw 中的表现 | 是否成立 |
|------|-------------------|---------|
| **互斥** | Session 写锁、文件锁、per-session lane 串行 | ✅ |
| **占有且等待** | Agent turn 占有 session lane，同时等待 LLM/工具/内部命令 | ✅ |
| **不可剥夺** | 锁只在 turn 完成后释放（除非 abort） | ✅ |
| **循环等待** | Gateway 自请求场景：turn 等内部命令 → 内部命令等 turn 完成 | ✅ |

**结论**：死锁四条件在特定场景下全部成立。

### 3.2 已确认的死锁场景

#### 死锁 1：Gateway 自请求死锁（最常见）

```
┌──────────────┐          ┌──────────────┐
│ Agent Turn   │ ──等待─→ │ 内部命令     │
│ (session lane│          │ (需查 Gateway │
│  被占)       │ ←─阻塞── │  状态)       │
└──────────────┘          └──────────────┘
```

Agent turn 通过 `exec` 工具调用 `openclaw sessions --json`，该 CLI 命令需要通过 WS 查询 Gateway，但 Gateway 的请求处理可能被 active session lane 阻塞。

#### 死锁 2：Compaction Lock 死锁

```
┌──────────────┐          ┌──────────────┐
│ 新消息到达   │ ──等锁─→ │ .jsonl.lock  │
│ (要写 trans- │          │ (compaction   │
│  cript)      │ ←─残留── │  异常退出)   │
└──────────────┘          └──────────────┘
```

Compaction 过程中 Gateway crash 或 restart → lock 文件残留 → 所有后续操作 10s 超时。

#### 死锁 3：Compaction 超限悖论

```
Context 过大 → 触发 Compaction → Compaction 的 summarization 请求也超限
    → Compaction 失败 → Context 仍然过大 → 再触发 Compaction → 循环
```

### 3.3 死锁检测机制

**OpenClaw 目前没有显式的死锁检测机制。** 但有以下间接保护：

| 机制 | 作用 | 默认值 |
|------|------|--------|
| Agent 超时 | 终止超时的 agent run | 172800s (48h) |
| LLM 空闲超时 | 终止无响应的 LLM 请求 | 120s (或 timeoutSeconds) |
| Drain 超时 | Gateway restart 时强制结束 | 30s |
| 文件锁超时 | lock 获取失败 | 10s |
| Lane 重置 | `resetAllLanes()` 清除 stale task IDs | 手动触发 |

**独立洞察**：缺少主动死锁检测是架构缺陷。建议添加：
1. Session 活跃时间 watchdog（超过 N 分钟自动 abort）
2. Lock 文件 TTL（带时间戳的 lock，过期自动清除）
3. 自请求检测（agent turn 中的内部命令走独立通道）

---

## 4. 解决方法与最佳实践

### 4.1 OpenClaw 内建恢复机制

| 机制 | 配置项 | 默认值 | 说明 |
|------|--------|--------|------|
| Agent 超时 | `agents.defaults.timeoutSeconds` | 172800s (48h) | 过长，建议缩短到 600-1800s |
| LLM 空闲超时 | `agents.defaults.llm.idleTimeoutSeconds` | 120s | 检测 API 流式挂起 |
| Compaction 安全下限 | `agents.defaults.compaction.reserveTokensFloor` | 20000 | 防止 headroom 不足 |
| Session 日重置 | 默认 4:00 AM | 自动 | 防止 session 无限增长 |
| 空闲重置 | `session.reset.idleMinutes` | 可选 | 超时后新 session |
| Queue 模式 | `messages.queue.mode` | `collect` | 合并排队消息 |
| Drain 机制 | Gateway restart 时 | 30s | 等待活跃任务完成 |

### 4.2 手动恢复命令

```bash
# 1. 检查 session 状态
openclaw sessions --json
openclaw sessions --active 120  # 近 2 小时活跃的 session

# 2. 在 chat 中重置 session
/new              # 新建 session（丢失上下文）
/new claude-opus-4-6  # 新建并切换模型
/reset            # 重置当前 session
/stop             # 停止当前 agent run

# 3. 检查和清除锁文件
ls ~/.openclaw/agents/*/sessions/*.lock
rm -f ~/.openclaw/agents/*/sessions/*.lock  # ⚠️ 确保无活跃 run

# 4. 重启 Gateway
openclaw gateway restart    # 优雅重启（drain 30s）
openclaw gateway stop       # 强制停止
openclaw gateway start      # 重新启动

# 5. Session 清理
openclaw sessions cleanup --dry-run     # 预览
openclaw sessions cleanup --enforce     # 执行

# 6. 完整重置（核弹选项）
openclaw reset --scope config+creds+sessions --yes
```

### 4.3 推荐配置调优

```json5
{
  // 1. 缩短 agent 超时（从 48h 到 30min）
  agents: {
    defaults: {
      timeoutSeconds: 1800,
      
      // 2. LLM 空闲超时
      llm: {
        idleTimeoutSeconds: 90,  // API 90s 无响应则中止
      },
      
      // 3. 并发控制
      maxConcurrent: 4,  // 全局并发上限
      
      // 4. Compaction 安全设置
      compaction: {
        enabled: true,
        reserveTokens: 20000,
        keepRecentTokens: 20000,
        reserveTokensFloor: 20000,
        memoryFlush: {
          enabled: true,
          softThresholdTokens: 4000,
        },
      },
    },
  },
  
  // 5. Session 维护
  session: {
    maintenance: {
      mode: "enforce",     // 自动清理（默认只警告）
      pruneAfter: "30d",
      maxEntries: 500,
    },
    reset: {
      idleMinutes: 120,    // 2h 无活动重置
    },
  },
  
  // 6. 消息队列
  messages: {
    queue: {
      mode: "collect",     // 合并排队消息
      debounceMs: 1000,
      cap: 20,
      drop: "summarize",
    },
  },
}
```

### 4.4 预防 Stuck 的最佳实践

1. **避免 Agent Turn 中调用内部命令**
   - 不要用 `exec("openclaw sessions --json")`
   - 改用 `session_status` 工具或 `sessions_list` 工具（这些是 Gateway 内部 RPC，不走外部 CLI）

2. **设置合理超时**
   - `timeoutSeconds: 1800`（不要用默认的 48h）
   - `llm.idleTimeoutSeconds: 90`

3. **监控 lock 文件**
   - 定期检查 `~/.openclaw/agents/*/sessions/*.lock`
   - 脚本自动清除超过 5 分钟的 lock 文件

4. **使用 systemd/launchd 监管**
   - Gateway 异常退出自动重启
   - 配合 watchdog 检测 hanging

5. **Compaction 预防**
   - 开启 `memoryFlush` 在压缩前保存关键上下文
   - 使用 session pruning 控制工具结果大小
   - 避免小 context window 模型处理大对话

6. **Sub-agent 最佳实践**
   - 使用 `sessions_yield` 而不是 poll 循环等待子 agent
   - 子 agent 设置独立超时
   - 用 `subagents` 工具的 `kill` action 清理卡住的子 agent

---

## 5. 排查手册

### 症状 → 原因 → 解决 速查表

| 症状 | 可能原因 | 排查步骤 | 解决方案 |
|------|---------|---------|---------|
| Bot 显示"输入中"然后消失 | LLM API 挂起 | 查日志：是否有 `idleTimeout` | 设置 `llm.idleTimeoutSeconds: 90` |
| Bot 完全无响应 | Session lock 残留 | `ls ~/.openclaw/agents/*/sessions/*.lock` | 删除 lock 文件 + 重启 |
| Compaction 后卡住 | Compaction retry 循环 | 查日志：`compaction retry` | 重启 Gateway + 删 lock |
| 内部命令 10 分钟超时 | Gateway 自请求死锁 | 确认是否在 agent turn 中调用 CLI | 改用 session tools API |
| 费用异常高 | Stuck → timeout → retry 风暴 | 查 token 使用量 | 缩短 timeout + 设置 spend limit |
| /compact 失败 | Context 超限悖论 | `/status` 检查 token 数 | `/new` 重建 session |
| Sub-agent 不返回 | 子 agent 卡在工具调用 | `subagents list` | `subagents kill all` |

### 日志关键词速查

```bash
# 搜索 stuck 相关日志
grep -i "stuck\|timeout\|abort\|compaction retry\|lock\|deadlock\|drain" \
  ~/.openclaw/logs/*.log

# 搜索 session 活动
grep "embedded run" ~/.openclaw/logs/*.log | tail -20

# 搜索超时
grep "idleTimeout\|timeoutSeconds\|10000ms" ~/.openclaw/logs/*.log
```

---

## 附录

### A. 关键源码文件索引

| 文件（dist/） | 内容 |
|---------------|------|
| `command-queue-Deq0-o7-.js` | Lane 系统、并发控制、drain 逻辑 |
| `runs-CiwSS2N4.js` | Agent run 生命周期、abort 逻辑 |
| `queue-JsNnvcW2.js` | Session lane 解析、followup drain |
| `pi-embedded-Cokqx7hf.js` | 嵌入式 agent runner 入口 |
| `timeouts-D9CqMacu.js` | Discord 超时工具 |

### B. 关键文档索引

| 文档 | 内容 |
|------|------|
| `docs/concepts/session.md` | Session 路由、生命周期、DM 隔离 |
| `docs/concepts/queue.md` | Command Queue 设计、lane 并发 |
| `docs/concepts/agent-loop.md` | Agent 循环生命周期、超时配置 |
| `docs/reference/session-management-compaction.md` | Session 存储深度解析、Compaction 机制 |
| `docs/concepts/session-tool.md` | Session 工具、sub-agent 管理 |
| `docs/concepts/multi-agent.md` | 多 agent 路由、隔离 |

### C. 相关 GitHub Issues

| Issue | 标题 | 状态 |
|-------|------|------|
| #17258 | Streaming inactivity timeout: sessions stuck when API produces no tokens | 已修复（idleTimeoutSeconds） |
| #21621 | Browser Tool Triggers Compaction Deadlock | 报告中 |
| #18470 | Gateway Deadlock: Internal Commands Hang During Active Turn | 报告中 |
| #31489 | Session file locked (timeout 10000ms) | 报告中 |
| #17635 | Gateway restart during compaction causes session deadlock | 报告中 |
| #25620 | Compaction fails when context exceeds model token limit | 报告中 |
| #8288 | Agent hangs indefinitely on failed tool calls | 报告中 |
| #4410 | Auto-restart gateway on stuck sessions | Feature Request |
| #28576 | OpenClaw keeps hanging | 报告中 |

### D. 独立判断与洞察

1. **架构根因**：OpenClaw 的单进程 Gateway + per-session 串行化设计在简单场景下有效，但对于长时间运行的 agent turn（特别是使用外部工具的场景），缺乏足够的超时和恢复机制。

2. **最大风险点**：默认 48h 的 agent timeout 几乎等于没有超时。这是多数 stuck session 问题的放大器 — 即使出了问题，系统也要等很久才会超时。

3. **自请求死锁是设计缺陷**：Agent 能通过 `exec` 工具调用 `openclaw` CLI，而 CLI 需要查询 Gateway，形成循环依赖。这应该在架构层面解决（如内部命令走独立通道）。

4. **Lock 文件机制脆弱**：基于文件锁的并发控制在进程崩溃时会残留，导致后续操作全部失败。建议改为带 PID + 时间戳的锁，或使用进程内锁（单进程架构下完全可行）。

5. **Compaction 是 stuck 的高频触发器**：多个 Issue 都与 compaction 相关。Compaction 涉及 LLM 调用（summarization）+ 文件锁 + 可能的 retry，任一环节卡住都导致 session 不可用。

---

*研究完成。所有数据标明来源，搜不到的已如实标注。*
