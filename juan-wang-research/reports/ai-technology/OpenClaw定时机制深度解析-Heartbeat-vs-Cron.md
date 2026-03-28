# OpenClaw 定时机制深度解析：Heartbeat vs Cron，到底该用哪个？

> 很多 OpenClaw 用户在配置自动化时会困惑：HEARTBEAT.md 和 Cron 都能"定时做事"，到底有什么区别？本文从设计哲学、运行机制、适用场景三个维度彻底讲清楚。

---

## 一句话区分

**Heartbeat = 定期拍肩膀问"有事吗？"**

**Cron = 准时闹钟说"现在做这件事"**

看似都是"定时触发"，但一个让 Agent **自主判断**，一个让 Agent **执行指令**。这个区别决定了它们完全不同的使用场景。

---

## 一、Heartbeat：会思考的巡检员

### 它是什么

Heartbeat 是 OpenClaw 内置的"心跳"机制。每隔一段时间（默认 30 分钟），Gateway 会在 Agent 的**主会话（Main Session）**中注入一条系统消息：

```
"Read HEARTBEAT.md if it exists. Follow it strictly.
 Do not infer or repeat old tasks.
 If nothing needs attention, reply HEARTBEAT_OK."
```

Agent 收到这条消息后，会去读 HEARTBEAT.md，看看有没有需要处理的事情。

### 关键：在主会话中执行

这一点至关重要。因为 Heartbeat 在主会话中运行，Agent **拥有完整的上下文**：

- 它记得你昨天跟它说了什么
- 它知道上次检查的结果是什么
- 它能看到之前对话中积累的信息
- 它的记忆（MEMORY.md）是活的

这意味着 Heartbeat 能做**有状态的判断**。

### HEARTBEAT.md 怎么写

```markdown
# 检查清单

- 如果有未处理的 GitHub Issue（标签为 bug），汇总通知我
- 如果距离上次给客户发跟进邮件超过 3 天，提醒我
- 如果今天还没写日报，下午 6 点后提醒我
```

注意：这不是一个"每次都全部执行"的任务列表。Agent 会**自主判断**：

- 没有新 bug Issue？跳过
- 昨天刚发过跟进邮件？跳过
- 现在才上午 10 点？跳过
- 全部没事？回复 `HEARTBEAT_OK`，Gateway 静默吞掉，用户无感知

### 配置

```json5
{
  agents: {
    defaults: {
      heartbeat: {
        every: "30m",        // 间隔，默认 30 分钟
        activeHours: {       // 活跃时段（避免半夜唤醒）
          start: 8,
          end: 23,
          tz: "Asia/Shanghai"
        },
        target: "last",      // 结果发到哪：last（上次对话渠道）| none | channel
        showOk: false        // HEARTBEAT_OK 是否显示（默认不显示）
      }
    }
  }
}
```

### 行为细节

| 行为 | 说明 |
|------|------|
| 主会话忙（用户正在对话） | **跳过**本次心跳，下次再来 |
| Agent 回复 HEARTBEAT_OK | Gateway 静默吞掉，不推送 |
| Agent 回复其他内容 | 作为告警推送给用户 |
| 活跃时段外 | 不触发 |
| 多个 Agent | 各自独立心跳（可在 `agents.list[].heartbeat` 覆盖） |

---

## 二、Cron：精准的定时执行器

### 它是什么

Cron 是 OpenClaw Gateway 内置的定时任务调度器。到达预设时间点时，创建一个**全新的隔离 Session**，注入预设 prompt，Agent 执行，完成后推送结果。

```
时间到达 → 创建 cron:<jobId>:run:<uuid> session → 注入 prompt → 执行 → 推送/回调
```

### 关键：每次是全新 Session

每次 Cron 执行都是一个**干净的、无上下文的**独立会话：

- 它不记得上次执行了什么
- 它看不到主会话的对话历史
- 它不知道用户之前说过什么
- 执行完毕后，session 默认保留 24 小时，然后归档删除

这意味着 Cron 适合**无状态的、确定性的**任务。

### 三种调度方式

| 类型 | 配置 | 说明 |
|------|------|------|
| **cron 表达式** | `{ kind: "cron", expr: "0 9 * * *", tz: "Asia/Shanghai" }` | 每天早上 9 点 |
| **固定间隔** | `{ kind: "every", ms: 3600000 }` | 每小时 |
| **一次性** | `{ kind: "at", at: "2026-03-29T14:00:00+08:00" }` | 指定时间执行一次 |

### 三种交付方式

| 模式 | 说明 |
|------|------|
| `announce` | 将结果推送到指定渠道（飞书/Telegram/WhatsApp 等） |
| `webhook` | POST 结果到指定 URL |
| `none` | 仅内部执行，不推送 |

### 配置示例

```json5
{
  cron: {
    maxConcurrentRuns: 3,     // 最多同时跑 3 个任务
    sessionRetention: "24h",  // session 保留 24 小时
    retry: {
      maxAttempts: 3,
      backoffMs: [30000, 60000, 300000]  // 30s → 1m → 5m
    },
    jobs: [
      // 每天早 9 点发日报
      {
        id: "daily-report",
        schedule: { kind: "cron", expr: "0 9 * * *", tz: "Asia/Shanghai" },
        agent: "main",
        payload: {
          kind: "agentTurn",
          command: "生成今日工作日报，包含：\n1. 昨日完成的任务\n2. 今日重点\n3. 待处理事项",
          model: "anthropic/claude-haiku-3-5",
          delivery: { mode: "announce", to: "tg:8577482651" }
        }
      },
      // 每小时健康检查（不推送，除非异常）
      {
        id: "health-check",
        schedule: { kind: "every", ms: 3600000 },
        payload: {
          kind: "agentTurn",
          command: "执行服务健康检查，一切正常回复 OK，发现异常则详细报告",
          delivery: { mode: "announce" }
        }
      },
      // 一次性提醒
      {
        id: "meeting-reminder",
        schedule: { kind: "at", at: "2026-03-29T13:50:00+08:00" },
        payload: {
          kind: "agentTurn",
          command: "提醒：10 分钟后有产品评审会议",
          delivery: { mode: "announce" }
        }
      },
      // 每周一早上发周报
      {
        id: "weekly-report",
        schedule: { kind: "cron", expr: "0 9 * * 1", tz: "Asia/Shanghai" },
        payload: {
          kind: "agentTurn",
          command: "生成上周工作周报，汇总本周完成的所有任务、关键指标变化、下周计划",
          model: "anthropic/claude-sonnet-4-5",
          delivery: { mode: "announce", to: "tg:8577482651" }
        }
      }
    ]
  }
}
```

### 错误处理与重试

| 错误类型 | 处理 |
|---------|------|
| **瞬态错误**（rate limit、网络超时、5xx） | 指数退避重试（30s → 1m → 5m），最多 3 次 |
| **永久错误**（认证失败、参数错误） | 立即禁用任务 |
| **调度计算错误** | 连续 3 次失败后禁用，发系统通知 |

### 防撞车设计

多个 Cron 任务设在同一时间（如"整点"）时，OpenClaw 通过 **SHA256(jobId) % staggerMs** 计算确定性偏移，将任务分散到 0-5 分钟窗口内，避免同时开跑造成负载尖峰。

---

## 三、正面对比

### 机制差异

| 维度 | Heartbeat | Cron |
|------|-----------|------|
| **执行位置** | 主会话（Main Session） | 独立隔离 Session |
| **上下文** | ✅ 完整（历史、记忆、状态） | ❌ 无（每次全新） |
| **触发精度** | 固定间隔（可能跳过） | 精确到分钟（cron 表达式） |
| **任务定义** | HEARTBEAT.md（Agent 自主判断） | 配置中的 prompt（明确指令） |
| **输出** | 有事说事，没事静默 | announce / webhook / none |
| **有状态** | ✅ 在主会话中积累 | ❌ session 用完即弃 |
| **模型** | 用 Agent 主模型 | 可单独指定（省钱用 Haiku） |
| **并发** | 主会话排队（忙则跳过） | 独立并发池 |
| **重试** | 无（下次心跳再来） | 指数退避重试 |
| **API 成本** | 低（批量检查，没事就 HEARTBEAT_OK） | 每次执行都消耗 token |

### 场景速查表

| 场景 | Heartbeat | Cron | 选择理由 |
|------|:---------:|:----:|---------|
| 每天 9 点发日报 | | ✅ | 精确时间 + 固定任务 |
| 检查有没有新 GitHub Issue | ✅ | | 需要判断"有没有"，不是每次都执行 |
| 监控服务状态 | ✅ | ✅ | 都行，Heartbeat 能记住上次状态 |
| 批量检查 5 项待办 | ✅ | | 一次唤醒检查多项，省 API 调用 |
| 定时推送周报到飞书 | | ✅ | 需要精确时间 + 指定推送渠道 |
| 客户 3 天没跟进就提醒 | ✅ | | 需要记忆（上次跟进时间在上下文中） |
| 一次性提醒"下午 2 点开会" | | ✅ | `kind: "at"` 一次性定时 |
| 用便宜模型跑后台任务 | | ✅ | Cron 可单独指定 model |
| 每小时抓取数据 | | ✅ | 无状态，独立执行 |
| 下班前汇总今天的工作 | ✅ | | 需要上下文（今天做了什么在主会话里） |

---

## 四、最佳实践：组合使用

实际生产中，Heartbeat 和 Cron 不是二选一，而是**各司其职、互补配合**。

### 推荐架构

```
Heartbeat（智能巡检员）              Cron（准时执行器）
  │                                   │
  ├── 每 30 分钟醒来                    ├── 每天 9:00 发日报
  ├── 检查 HEARTBEAT.md                 ├── 每周一 9:00 发周报
  ├── 有事处理，没事静默                  ├── 每小时健康检查
  └── 在主会话中，有完整上下文             └── 独立 session，无上下文
```

### 组合示例：智能告警 + 定时汇总

**HEARTBEAT.md**（巡检发现问题）：
```markdown
# 巡检清单
- 检查是否有客户投诉未处理（超过 2 小时未回复的）
- 如果发现异常，写入 shared/alerts/pending.md
```

**Cron**（定时汇总推送）：
```json5
{
  cron: {
    jobs: [{
      id: "alert-digest",
      schedule: { kind: "cron", expr: "0 18 * * *", tz: "Asia/Shanghai" },
      payload: {
        kind: "agentTurn",
        command: "读取 shared/alerts/pending.md，汇总今日所有告警，生成告警日报",
        delivery: { mode: "announce", to: "tg:8577482651" }
      }
    }]
  }
}
```

**流程**：
```
Heartbeat 每 30 分钟 → 发现投诉 → 写入 shared/alerts/pending.md
                                          │
Cron 每天 18:00 ────────────────────→ 读取 + 汇总 → 推送告警日报
```

### 组合示例：上下文感知的定时报告

**问题**：Cron 没有上下文，但日报需要知道"今天做了什么"。

**方案**：Heartbeat 持续积累信息，Cron 定时读取产出。

**HEARTBEAT.md**：
```markdown
# 工作记录
- 每次醒来时，将主会话中新处理的任务追加到 shared/daily-log.md
- 格式：[时间] 完成了什么
```

**Cron**：
```json5
{
  id: "daily-report",
  schedule: { kind: "cron", expr: "0 21 * * *", tz: "Asia/Shanghai" },
  payload: {
    kind: "agentTurn",
    command: "读取 shared/daily-log.md，生成今日工作日报，完成后清空文件",
    delivery: { mode: "announce" }
  }
}
```

---

## 五、决策流程图

当你不确定用哪个时，按这个流程判断：

```
需要定时做的事
    │
    ├── 需要精确的时间点吗？（每天 9:00、每周一、某个具体时间）
    │     └── 是 → 用 Cron
    │
    ├── 需要上下文吗？（依赖之前的对话/记忆/状态）
    │     └── 是 → 用 Heartbeat
    │
    ├── 是"检查有没有"还是"执行一个确定任务"？
    │     ├── 检查有没有 → Heartbeat
    │     └── 确定任务 → Cron
    │
    ├── 需要推送到特定渠道吗？
    │     └── 是 → Cron（announce + to）
    │
    ├── 想用便宜模型单独跑吗？
    │     └── 是 → Cron（可指定 model）
    │
    └── 以上都不确定
          └── 先写进 HEARTBEAT.md 试试
              不满足再改成 Cron
```

---

## 总结

| | Heartbeat | Cron |
|---|---|---|
| **一句话** | 定期问 Agent"有事吗？" | 定时告诉 Agent"做这件事" |
| **核心优势** | 有上下文、能判断、批量检查 | 精确定时、独立隔离、可指定模型和推送 |
| **核心劣势** | 时间不精确、忙则跳过 | 无上下文、每次全新 |
| **成本** | 低（没事就 HEARTBEAT_OK） | 每次执行都消耗 token |
| **最佳用法** | 巡检、监控、有状态检查 | 日报、周报、数据同步、定时推送 |

**生产建议**：两者组合使用——Heartbeat 做智能巡检，Cron 做定时执行。通过共享文件（`shared/`）打通两者的信息流。

---

*文档由 wairesearch (黄山) 研究整理 | 2026-03-28*
*基于 OpenClaw 官方文档 + 源码分析（system-events.ts / cron scheduler）*
