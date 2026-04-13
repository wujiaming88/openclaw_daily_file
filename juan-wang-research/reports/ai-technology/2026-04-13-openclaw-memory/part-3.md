# Part 3：Dreaming —— 梦境记忆整理系统

## 核心理念

Dreaming 是 memory-core 的**后台记忆整理系统**。它像人类的睡眠一样，收集短期信号、评分候选条目、只将合格的内容晋升到长期记忆（MEMORY.md）。

> 设计目标：保持长期记忆**高信噪比**。

## 三个相位

直接借鉴了人类睡眠科学的命名：

```
┌────────────────────────────────────────────────┐
│              Dreaming Sweep                      │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  Light   │→│   REM    │→│   Deep   │      │
│  │  浅睡眠   │  │  快速眼动 │  │   深睡眠  │      │
│  │          │  │          │  │          │      │
│  │ 分类&暂存 │  │ 主题反思  │  │ 评分&晋升 │      │
│  │          │  │          │  │          │      │
│  │ 不写     │  │ 不写     │  │ 写入     │      │
│  │ MEMORY.md│  │ MEMORY.md│  │ MEMORY.md│      │
│  └──────────┘  └──────────┘  └──────────┘      │
└────────────────────────────────────────────────┘
```

### Light Phase（浅睡眠）
- **输入**：短期召回状态、近期每日记忆文件、脱敏会话记录
- **操作**：去重、暂存候选行、记录强化信号
- **输出**：managed `## Light Sleep` 块
- **写 MEMORY.md**：❌ 从不

### REM Phase（快速眼动）
- **输入**：近期短期追踪记录
- **操作**：提取主题、构建反思摘要
- **输出**：managed `## REM Sleep` 块、REM 强化信号
- **写 MEMORY.md**：❌ 从不
- **价值**：为 Deep Phase 提供额外的排名信号

### Deep Phase（深睡眠）—— 唯一写入 MEMORY.md 的相位
- **输入**：候选条目 + 所有评分信号
- **操作**：加权评分 + 阈值门控
- **输出**：晋升的条目 → MEMORY.md，摘要 → DREAMS.md
- **写 MEMORY.md**：✅ 唯一可以写的相位
- **关键**：从活跃的每日文件中重新水合片段，确保过时/删除的片段被跳过

## 六维评分系统

| 信号 | 权重 | 说明 |
|------|------|------|
| **Relevance（相关性）** | 0.30 | 平均检索质量 |
| **Frequency（频率）** | 0.24 | 短期信号累积次数 |
| **Query Diversity（查询多样性）** | 0.15 | 不同查询/天上下文的去重数量 |
| **Recency（新近性）** | 0.15 | 时间衰减的新鲜度 |
| **Consolidation（巩固度）** | 0.10 | 多日复现强度 |
| **Conceptual Richness（概念丰富度）** | 0.06 | 片段/路径的概念标签密度 |

**晋升门控**（三重门）：
- `minScore`：最低总分
- `minRecallCount`：最低召回次数
- `minUniqueQueries`：最低独立查询数

**Light + REM 相位命中**会为候选条目增加一个小的、随新近性衰减的加成。

## 两种输出

| 输出 | 用途 | 面向 |
|------|------|------|
| `memory/.dreams/` | 召回存储、相位信号、摄取检查点、锁 | 机器 |
| `DREAMS.md` | 梦境日记（Dream Diary）、相位报告 | 人类审查 |

### Dream Diary（梦境日记）

每个相位完成后，memory-core 运行一个"尽力"的后台子 Agent 轮次，生成一个简短的日记条目追加到 DREAMS.md。**这个日记是给人看的，不是晋升来源。**

## Grounded Historical Backfill（接地式历史回填）

可以对历史的 `memory/YYYY-MM-DD.md` 文件进行回放：

```bash
# 预览：从历史笔记生成接地式日记
openclaw memory rem-harness --path ./memory --grounded

# 写入：生成可逆的接地式日记条目
openclaw memory rem-backfill --path ./memory

# 暂存到短期存储（让 Deep Phase 可以晋升它们）
openclaw memory rem-backfill --path ./memory --stage-short-term

# 回滚（不影响正常日记和召回）
openclaw memory rem-backfill --rollback
openclaw memory rem-backfill --rollback-short-term
```

**设计关键**：回填的候选条目**不直接写 MEMORY.md**，而是暂存到短期存储 → 由正常的 Deep Phase 评估是否晋升。

## 配置

```json
{
  "plugins": {
    "entries": {
      "memory-core": {
        "config": {
          "dreaming": {
            "enabled": true,
            "frequency": "0 3 * * *",
            "timezone": "Asia/Shanghai"
          }
        }
      }
    }
  }
}
```

- **默认关闭**（opt-in）
- 启用后自动管理一个 cron job
- 默认每天凌晨 3 点运行完整 sweep

## 价值分析

### 解决的核心痛点

**之前**：
- MEMORY.md 靠 Agent 随时写入 → 质量参差不齐
- 重要信息可能被遗漏，不重要的被频繁记录
- 长期记忆膨胀 → 上下文窗口污染
- 没有机制区分"暂时重要"和"真正持久"

**之后**：
- 短期信号被自动收集和评分
- 只有通过**三重门控**的条目才能进入长期记忆
- 六维评分确保高质量
- **MEMORY.md 保持精简高信噪比**
- 人类可通过 DREAMS.md 审查整个过程

### 类比

| 人类 | Dreaming |
|------|----------|
| 白天的经历 → 短期记忆 | 每日笔记 + 会话 → 短期召回 |
| 浅睡眠：初步分类整理 | Light Phase：去重、暂存 |
| REM：主题提取、模式识别 | REM Phase：反思摘要 |
| 深睡眠：巩固到长期记忆 | Deep Phase：评分、晋升到 MEMORY.md |
| 起床后还记得的 = 重要的 | 通过三重门控的 = 持久的 |
