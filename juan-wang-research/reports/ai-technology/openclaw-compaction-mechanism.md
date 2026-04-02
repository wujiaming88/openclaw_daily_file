# OpenClaw Compaction 机制研究报告

> 研究员: 黄山 (wairesearch)  
> 日期: 2026-04-02  
> 来源: OpenClaw 官方文档、GitHub 源码、社区博客

---

## 执行摘要

OpenClaw 的 Compaction（压缩/摘要化）机制是解决 AI 模型上下文窗口有限问题的核心方案。当对话长度接近模型上下文上限时，OpenClaw 会将较旧的对话历史**摘要为一段压缩条目**，保留最近的消息不变，从而让对话可以持续进行。全部原始历史始终保留在磁盘上，Compaction 只改变模型「看到」的内容。

---

## 一、核心问题：为什么需要 Compaction？

每个 AI 模型都有**上下文窗口限制**（如 200k tokens）。长时间运行的对话会不断积累消息和工具调用结果，最终超出这个限制。OpenClaw 通过两层机制解决：

| 机制 | 作用 | 是否持久化 | 作用范围 |
|------|------|-----------|----------|
| **Compaction** | 摘要旧对话 | ✅ 写入 session 脚本 | 整个对话 |
| **Session Pruning** | 裁剪旧工具输出 | ❌ 仅内存中 | 仅工具结果 |

两者互补：Pruning 在 Compaction 周期之间保持工具输出精简。

---

## 二、Compaction 工作原理

### 2.1 基本流程

```
1. 旧的对话轮次 → 被模型读取并生成摘要
2. 摘要保存为 session 脚本中的 compaction 条目
3. 最近的消息保持不变
```

**Compaction 之后，模型看到的上下文变为：**
```
系统提示词 + 最新的 compaction 摘要 + 最近的消息
```

**关键区别：**
- **JSONL 文件（历史）**：包含所有原始对话、compaction 摘要、元数据
- **当前上下文（模型看到的）**：仅包含系统提示 + 最新摘要 + 近期消息

### 2.2 举例说明

假设一个 session 经历了 2 次 compaction：

```
JSONL 文件 (500KB) 包含:
├── 旧对话 1-1000（已被 compaction，不再发送给模型）
├── Compaction 摘要 1
├── 旧对话 1001-2000（已被 compaction，不再发送给模型）
├── Compaction 摘要 2
└── 近期对话 2001-2500

当前上下文 (约 93k tokens) 包含:
├── 系统提示词
├── Compaction 摘要 2（包含之前所有内容的摘要）
└── 近期对话 2001-2500
```

---

## 三、触发机制

### 3.1 自动触发（Auto-Compaction）

默认开启，两种触发场景：

1. **溢出恢复**：模型返回上下文溢出错误 → 压缩 → 重试
2. **阈值维护**：成功执行一轮后，当：

```
contextTokens > contextWindow - reserveTokens
```

其中：
- `contextWindow`：模型的上下文窗口大小
- `reserveTokens`：为提示词和下一次模型输出预留的空间

### 3.2 手动触发

在任意对话中输入 `/compact`：

```
/compact                              # 直接压缩
/compact 重点关注 API 设计决策          # 带指引的压缩
```

---

## 四、配置参数详解

### 4.1 核心配置

```json5
{
  compaction: {
    enabled: true,              // 是否启用
    reserveTokens: 16384,       // 预留 token 数
    keepRecentTokens: 20000,    // 保留最近消息的 token 数
  }
}
```

### 4.2 使用不同模型做摘要

默认使用 agent 的主模型，可配置更强的模型：

```json5
{
  agents: {
    defaults: {
      compaction: {
        model: "openrouter/anthropic/claude-sonnet-4-6",
      },
    },
  },
}
```

### 4.3 通知用户

默认静默运行，可启用通知：

```json5
{
  agents: {
    defaults: {
      compaction: {
        notifyUser: true,  // 开始时显示 "Compacting context..."
      },
    },
  },
}
```

### 4.4 安全下限（reserveTokensFloor）

OpenClaw 强制一个安全下限：

- 默认 `20000` tokens
- 如果 `reserveTokens < reserveTokensFloor`，自动提升
- 设 `reserveTokensFloor: 0` 可禁用
- 目的：为 compaction 前的多轮「内务操作」（如记忆写入）留出足够空间

---

## 五、Memory Flush：Compaction 前的记忆保存

为防止 compaction 丢失重要信息，OpenClaw 有**预压缩记忆刷新**机制：

```
Token 增长 → 超过软阈值 → 触发 memoryFlush（保存到 MEMORY.md）
         → 继续对话 → 超过 compaction 阈值 → 触发 Compaction
```

### 配置

```json5
{
  agents: {
    defaults: {
      compaction: {
        memoryFlush: {
          enabled: true,                    // 默认开启
          softThresholdTokens: 4000,        // 软阈值
          prompt: "...",                     // flush 时的用户消息
          systemPrompt: "...",              // flush 时的系统提示
        },
      },
    },
  },
}
```

### 特点
- 使用 `NO_REPLY` 机制，用户完全无感
- 每个 compaction 周期只运行一次
- 仅对嵌入式 Pi session 生效
- workspace 为只读时跳过

---

## 六、Session Pruning（轻量补充）

Pruning 是 Compaction 的轻量补充，仅裁剪工具输出：

### 工作流程
1. 等待缓存 TTL 过期（默认 5 分钟）
2. 找到旧的工具结果（不触碰用户/助手消息）
3. **软裁剪**：保留头尾，中间插入 `...`
4. **硬清除**：替换为占位符
5. 重置 TTL

### 配置
```json5
{
  agents: {
    defaults: {
      contextPruning: { mode: "cache-ttl", ttl: "5m" },
    },
  },
}
```

### 对 Anthropic 的特殊优化
Anthropic provider 自动启用 pruning，降低 prompt caching 成本。

---

## 七、持久化与存储结构

### 7.1 两层持久化

| 层级 | 文件 | 内容 | 特点 |
|------|------|------|------|
| Session Store | `sessions.json` | 会话元数据、token 计数器 | KV 结构，可编辑 |
| Transcript | `<sessionId>.jsonl` | 完整对话+工具调用+compaction 摘要 | 追加写入，树结构 |

### 7.2 磁盘路径

```
~/.openclaw/agents/<agentId>/sessions/
├── sessions.json                           # 会话存储
├── <sessionId>.jsonl                       # 对话脚本
└── <sessionId>-topic-<threadId>.jsonl      # Telegram topic session
```

### 7.3 Transcript 条目类型

| 类型 | 说明 |
|------|------|
| `message` | 用户/助手/工具结果消息 |
| `custom_message` | 扩展注入的消息（进入模型上下文） |
| `custom` | 扩展状态（不进入模型上下文） |
| `compaction` | Compaction 摘要，含 `firstKeptEntryId` 和 `tokensBefore` |
| `branch_summary` | 树分支导航时的摘要 |

### 7.4 Session Store 关键字段

```
sessionId          → 当前 transcript ID
compactionCount    → 该 session 完成的 compaction 次数
memoryFlushAt      → 上次 memory flush 时间戳
contextTokens      → 运行时 token 估算值
inputTokens/outputTokens/totalTokens → 滚动统计
```

---

## 八、Session 维护与磁盘控制

```json5
{
  session: {
    maintenance: {
      mode: "warn",           // 或 "enforce"
      pruneAfter: "30d",      // 过期清理时间
      maxEntries: 500,        // sessions.json 最大条目数
      rotateBytes: "10mb",    // sessions.json 轮转大小
      maxDiskBytes: "...",    // 可选磁盘预算
      highWaterBytes: "80%",  // 清理目标
    },
  },
}
```

CLI 命令：
```bash
openclaw sessions cleanup --dry-run    # 预览
openclaw sessions cleanup --enforce    # 执行
```

---

## 九、Compaction vs Pruning 对比总结

| 维度 | Compaction | Session Pruning |
|------|-----------|-----------------|
| **做什么** | 摘要旧对话 | 裁剪工具输出 |
| **持久化** | ✅ 写入 transcript | ❌ 仅内存 |
| **范围** | 整个对话 | 仅工具结果 |
| **需要模型** | ✅ 需要 | ❌ 不需要 |
| **触发时机** | 接近上下文上限 | 每次 LLM 调用前 |
| **成本** | 消耗 token（模型要读旧内容生成摘要） | 无额外成本 |

---

## 十、实用建议

### 频繁 Compaction？
- 模型上下文窗口可能太小
- 工具输出可能太大 → 启用 Session Pruning
- `reserveTokens` 设置过高

### Compaction 后上下文感觉过时？
- 使用 `/compact 重点关注 <主题>` 引导摘要
- 启用 Memory Flush 确保重要笔记存活

### 想要干净起步？
- `/new` 开始新 session，不触发 compaction

### 观察 Compaction 状态
- `/status` 查看 session 信息
- `openclaw status` CLI 查看
- `openclaw sessions --json` 查看详细
- Verbose 模式：`🧹 Auto-compaction complete`

---

## 参考来源

1. [OpenClaw 官方文档 - Compaction](https://docs.openclaw.ai/concepts/compaction)
2. [OpenClaw 官方文档 - Session Management Deep Dive](https://docs.openclaw.ai/reference/session-management-compaction)
3. [OpenClaw 官方文档 - Session Pruning](https://docs.openclaw.ai/concepts/session-pruning)
4. [GitHub - openclaw/docs/concepts/compaction.md](https://github.com/openclaw/openclaw/blob/main/docs/concepts/compaction.md)
5. [OpenClaw Context Management 博客](https://agi-xiaobai-no1.github.io/posts/context-management/)
6. [How OpenClaw Works - Medium](https://bibek-poudel.medium.com/how-openclaw-works-understanding-ai-agents-through-a-real-architecture-5d59cc7a4764)
