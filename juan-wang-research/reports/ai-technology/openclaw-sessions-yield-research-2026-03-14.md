# 研究报告：OpenClaw `sessions_yield` 深度解析

> 研究员：黄山 (wairesearch) · 日期：2026-03-14

## 执行摘要

`sessions_yield` 是 OpenClaw 2026.3.12 版本新增的 agent 工具，**解决了多 Agent 编排中的"阻塞等待"问题**。它允许编排者（orchestrator）在派发子任务后立即结束当前回合，释放 token 上下文和计算资源，等子 Agent 完成后再自动唤醒继续处理。这是从"同步轮询"到"事件驱动"的关键进化。

---

## 1. 是什么（What）

### 1.1 工具定义

```typescript
// 工具签名
{
  name: "sessions_yield",
  description: "End your current turn. Use after spawning subagents to receive their results as the next message.",
  parameters: {
    message?: string  // 可选：携带到下一轮的隐藏 payload
  }
}
```

### 1.2 返回值

```json
{
  "status": "yielded",
  "message": "Turn yielded."
}
```

### 1.3 版本信息

- **引入版本**: 2026.3.12
- **PR**: #36537
- **贡献者**: @jriff
- **CHANGELOG 描述**: "add `sessions_yield` so orchestrators can end the current turn immediately, skip queued tool work, and carry a hidden follow-up payload into the next session turn"

---

## 2. 为什么需要它（Why）

### 2.1 核心问题

在 `sessions_yield` 出现之前，orchestrator 模式存在一个根本矛盾：

```
场景：orchestrator 派发 3 个子 Agent 并行执行

❌ 旧模式（无 yield）：
1. orchestrator 调用 sessions_spawn(task1)  → 非阻塞，立即返回
2. orchestrator 调用 sessions_spawn(task2)  → 非阻塞，立即返回
3. orchestrator 调用 sessions_spawn(task3)  → 非阻塞，立即返回
4. orchestrator 的当前回合继续执行...
   - 但此时 3 个子 Agent 还没完成
   - orchestrator 必须轮询（poll）或等待
   - 白白消耗 token 和上下文窗口
   - 或者回合结束后，子 Agent 的 announce 无法被同一回合处理
```

### 2.2 具体痛点

| 痛点 | 说明 |
|------|------|
| **Token 浪费** | orchestrator 占着上下文等待，持续消耗 token |
| **回合卡死** | LLM 回合是同步的，不能真正"暂停" |
| **上下文膨胀** | 轮询 `subagents list` 的结果不断累积在上下文中 |
| **编排受限** | 无法实现"派发 → 等待 → 汇总"的经典编排模式 |
| **竞态问题** | 子 Agent 的 announce 可能在 orchestrator 回合还在进行时到达 |

### 2.3 `sessions_yield` 的解决方案

```
✅ 新模式（有 yield）：
1. orchestrator 调用 sessions_spawn(task1)
2. orchestrator 调用 sessions_spawn(task2)
3. orchestrator 调用 sessions_spawn(task3)
4. orchestrator 调用 sessions_yield("等待 3 个子任务完成")
   → 当前回合立即结束
   → 跳过后续排队的工具调用
   → 释放 token/上下文
   → 隐藏 payload 保留到下一轮
5. 子 Agent 完成后 announce 回来
   → orchestrator 被唤醒，进入新回合
   → 上一轮的 yield message 作为上下文注入
   → 继续汇总处理
```

---

## 3. 实现机制（How）

### 3.1 内部执行流程

通过源码分析，`sessions_yield` 的完整机制如下：

```
Agent 调用 sessions_yield(message)
  │
  ├─ 1. onYield 回调触发
  │     ├─ yieldDetected = true
  │     ├─ yieldMessage = message
  │     ├─ queueYieldInterruptForSession() ← 注入中断消息
  │     └─ runAbortController.abort("sessions_yield") ← 中止当前运行
  │
  ├─ 2. 中断处理
  │     ├─ 跳过所有排队中的工具调用
  │     ├─ 创建空的 aborted 响应 (stopReason: "aborted")
  │     └─ 信号传播: signal.reason === "sessions_yield"
  │
  ├─ 3. 上下文清理 (stripSessionsYieldArtifacts)
  │     ├─ 移除 aborted 的 assistant 消息
  │     ├─ 移除 yield interrupt 自定义消息
  │     └─ 重写 session 文件（保持 transcript 干净）
  │
  └─ 4. 持久化 yield 上下文
        ├─ persistSessionsYieldContextMessage(session, message)
        ├─ 写入: "[message]\n\n[Context: The previous turn ended 
        │         intentionally via sessions_yield while waiting for 
        │         a follow-up event.]"
        └─ display: false（对用户不可见，但模型下一轮可读）
```

### 3.2 关键数据结构

```typescript
// Yield 中断消息（内部）
{
  role: "custom",
  customType: "openclaw.sessions_yield_interrupt",
  content: "[sessions_yield interrupt]",
  display: false,
  details: { source: "sessions_yield" },
  timestamp: Date.now()
}

// Yield 上下文消息（持久化到下一轮）
{
  customType: "openclaw.sessions_yield",
  content: `${message}\n\n[Context: The previous turn ended intentionally via sessions_yield while waiting for a follow-up event.]`,
  display: false,
  details: { source: "sessions_yield", message }
}
```

### 3.3 与 `sessions_spawn` 的协作

```
sessions_spawn → 非阻塞，返回 { status: "accepted", runId, childSessionKey }
                  ↓
sessions_yield → 结束当前回合
                  ↓
子 Agent 完成 → announce 回来
                  ↓
orchestrator 新回合开始 → 
  1. 收到 announce 事件
  2. yield context 注入到上下文
  3. 模型看到之前的意图 + 子 Agent 的结果
  4. 继续编排逻辑
```

---

## 4. 使用场景（Where）

### 场景 1：经典 Orchestrator 编排

**最核心的场景**：main → orchestrator → 多个 worker

```
用户: "帮我调研 React、Vue、Angular 并生成对比报告"

orchestrator:
  1. sessions_spawn(task="调研 React", label="react-research")
  2. sessions_spawn(task="调研 Vue", label="vue-research") 
  3. sessions_spawn(task="调研 Angular", label="angular-research")
  4. sessions_yield("已派发 3 个调研任务，等待结果后汇总")
  → 回合结束，等待

[3 个子 Agent 各自完成，依次 announce 回来]

orchestrator 新回合:
  - 看到 3 个 announce 结果
  - 汇总生成对比报告
  - 返回给用户
```

### 场景 2：分阶段流水线

```
orchestrator:
  Phase 1: sessions_spawn("需求分析")
           sessions_yield("等待需求分析完成")
  
  [需求分析完成, announce 回来]
  
  Phase 2: sessions_spawn("架构设计", 基于 Phase 1 结果)
           sessions_yield("等待架构设计完成")
  
  [架构设计完成, announce 回来]
  
  Phase 3: sessions_spawn("代码实现", 基于 Phase 2 结果)
           sessions_yield("等待代码实现完成")
```

### 场景 3：扇出-汇总（Fan-out / Fan-in）

```
orchestrator:
  // Fan-out: 同时搜索多个来源
  sessions_spawn("搜索 arXiv 论文")
  sessions_spawn("搜索 GitHub 项目")
  sessions_spawn("搜索技术博客")
  sessions_yield("等待所有搜索完成后综合分析")

  // Fan-in: 收到所有结果后汇总
  → 生成综合分析报告
```

### 场景 4：长任务委托

```
主 Agent:
  sessions_spawn("运行完整测试套件并分析结果", runTimeoutSeconds=900)
  sessions_yield("测试任务已委托，完成后处理")
  → 主 Agent 释放资源，可以处理其他消息

  [15 分钟后测试完成, announce 回来]
  → 主 Agent 被唤醒，处理测试结果
```

### 场景 5：人机协作中转

```
orchestrator:
  sessions_spawn("生成初稿", label="draft")
  sessions_yield("等待初稿完成，后续需要用户审核")
  
  [初稿完成]
  → orchestrator 收到结果
  → 将初稿发给用户
  → 等待用户反馈
  → 派发修改任务
```

---

## 5. 价值分析（Value）

### 5.1 技术价值

| 维度 | 改进 |
|------|------|
| **Token 效率** | 不再空等，yield 后上下文被清理，下一轮从干净状态开始 |
| **资源利用** | 释放 LLM API 连接和内存，不占用并发槽位 |
| **上下文管理** | yield 产生的中间 artifact 被自动清理（`stripSessionsYieldArtifacts`） |
| **可靠性** | 用事件驱动替代轮询，避免竞态和重复执行 |
| **嵌套编排** | 配合 `maxSpawnDepth: 2`，支持 main → orchestrator → workers 模式 |

### 5.2 架构价值

```
Before sessions_yield:
  Agent = 同步执行者（一次性完成所有工作）

After sessions_yield:
  Agent = 异步编排者（可以暂停/恢复/等待）
```

这使得 OpenClaw 的 Agent 模型从**请求-响应**进化为**事件驱动协程**。

### 5.3 成本价值

假设一个 orchestrator 需要等待 3 个子 Agent（平均 5 分钟）：

- **无 yield**: orchestrator 持续占用 token（轮询检查状态），估计额外消耗 5000-10000 tokens
- **有 yield**: orchestrator yield 后零消耗，仅在子 Agent 完成时消耗 announce 处理 token

对于频繁使用多 Agent 编排的团队，**token 成本可降低 30-50%**。

---

## 6. 配置与限制

### 6.1 工具可用性

`sessions_yield` 默认包含在以下配置中：
- `coding` 工具 profile
- sandbox 默认允许工具列表
- `group:sessions` 工具组

### 6.2 限制

| 限制 | 说明 |
|------|------|
| **非用户可见** | yield 上下文消息 `display: false`，用户不会看到 |
| **需要 session 上下文** | 无 session 时返回错误 |
| **单向的** | yield 后不能取消，必须等待下一个事件唤醒 |
| **Announce 依赖** | 如果子 Agent 没有 announce（如 gateway 重启），orchestrator 可能不会被唤醒 |
| **不是真正的挂起** | 本质是结束回合 + 注入上下文到下一轮 |

### 6.3 与相关工具的对比

| 工具 | 用途 | 阻塞? |
|------|------|-------|
| `sessions_spawn` | 派发子 Agent | 非阻塞（立即返回） |
| `sessions_send` | 向其他 session 发消息 | 可选阻塞（timeoutSeconds） |
| `sessions_yield` | 结束当前回合等待事件 | 终止当前回合 |
| `subagents` | 管理子 Agent（list/kill/steer） | 同步 |

---

## 7. 最佳实践

### 7.1 推荐模式

```
✅ spawn → spawn → spawn → yield
   (先派发所有任务，最后 yield)

✅ spawn → yield → (收到结果) → spawn → yield
   (分阶段执行)

❌ yield → spawn
   (yield 必须在 spawn 之后，否则无意义)

❌ 单个简单任务也用 yield
   (如果子任务很快完成，直接 sessions_send 更高效)
```

### 7.2 yield message 的使用技巧

```typescript
// ✅ 好的 yield message — 携带编排意图
sessions_yield("已派发3个调研任务(React/Vue/Angular)，收到结果后请生成对比表格和推荐方案")

// ❌ 差的 yield message — 没有有用信息
sessions_yield("等待中")
```

yield message 会作为隐藏上下文注入到下一轮，帮助模型理解"我为什么在这里"和"接下来该做什么"。

---

## 8. 总结

`sessions_yield` 是 OpenClaw 多 Agent 编排能力的**关键基础设施**。它将 Agent 从同步执行者升级为异步编排者，解决了：

1. **效率问题** — 不再空等浪费 token
2. **架构问题** — 支持真正的 orchestrator 模式
3. **可靠性问题** — 事件驱动替代轮询
4. **成本问题** — 减少无效 token 消耗

配合 `sessions_spawn`（非阻塞派发）和 `maxSpawnDepth: 2`（嵌套编排），三者共同构成了 OpenClaw 多 Agent 协作的完整范式：

```
sessions_spawn  = 派发（非阻塞）
sessions_yield  = 暂停（释放资源）
announce        = 唤醒（事件驱动）
```

---

## 参考来源

1. OpenClaw CHANGELOG 2026.3.12 — PR #36537
2. OpenClaw 源码 `sessions-yield-tool.ts`
3. OpenClaw 源码 `attempt.ts`（yield 中断处理逻辑）
4. OpenClaw 官方文档 https://docs.openclaw.ai/tools/subagents
5. OpenClaw GitHub Releases https://github.com/openclaw/openclaw/releases
6. GitHub Issue #23414 — orchestrator pattern requirements
