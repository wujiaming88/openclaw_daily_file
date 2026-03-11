# OpenClaw Pluggable Context Engine 研究报告

> 研究日期：2026-03-11
> 研究员：黄山 (wairesearch)
> 版本：OpenClaw 2026.3.7（发布于 2026-03-07）
> 数据来源：OpenClaw 官方文档、GitHub Release Notes、lossless-claw 仓库、36kr 量子位解读

---

## 执行摘要

OpenClaw 2026.3.7 版本引入了 **Pluggable Context Engine**（可插拔上下文引擎），这是一个允许插件**完全接管上下文管理生命周期**的插件槽（Plugin Slot）机制。在此之前，OpenClaw 的上下文压缩、组装和会话管理逻辑是硬编码的；现在，第三方插件可以通过注册自定义 Context Engine 来替换整个上下文管线。

**核心价值**：让"上下文如何管理"从固定实现变为**可选择的策略**——不同场景可以用不同的上下文引擎。

**标杆案例**：官方推荐的 `lossless-claw` 插件实现了 DAG 摘要树 + SQLite 持久化，做到"上下文永不丢失"，在 OOLONG benchmark 上以 74.8 分超过 Claude Code 的 70.3 分。

---

## 一、Pluggable Context Engine 是什么

### 1.1 核心概念

Context Engine 是 OpenClaw 插件系统中的一个**独占槽位**（Exclusive Slot），负责控制：

| 职责 | 说明 |
|------|------|
| **Ingest（摄入）** | 新消息进入时如何处理和存储 |
| **Assemble（组装）** | 每轮对话时如何拼装上下文发给模型 |
| **Compact（压缩）** | 上下文超限时如何压缩/总结旧消息 |
| **Bootstrap（启动）** | 引擎初始化时的准备工作 |
| **afterTurn（回合后）** | 每轮对话结束后的清理/持久化 |
| **prepareSubagentSpawn** | 子Agent生成前的上下文准备 |
| **onSubagentEnded** | 子Agent结束后的上下文回收 |

### 1.2 与旧系统的关系

```
┌──────────────────────────────────────────────────────┐
│  OpenClaw 2026.3.7 之前                               │
│  ┌────────────────────────────────────────┐           │
│  │  硬编码的上下文管线                       │           │
│  │  滑动窗口压缩 → 摘要 + 保留最近消息      │           │
│  │  无法自定义，插件无法介入                 │           │
│  └────────────────────────────────────────┘           │
└──────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────┐
│  OpenClaw 2026.3.7 之后                               │
│  ┌────────────────────────────────────────┐           │
│  │  Context Engine Plugin Slot             │           │
│  │  ┌──────────┐  ┌──────────────────────┐│           │
│  │  │ "legacy"  │  │ "lossless-claw"      ││           │
│  │  │ (内置默认) │  │ (DAG摘要,永不丢失)   ││           │
│  │  └──────────┘  └──────────────────────┘│           │
│  │  ┌──────────────────────────────────┐  │           │
│  │  │ 任何自定义 Context Engine 插件     │  │           │
│  │  └──────────────────────────────────┘  │           │
│  └────────────────────────────────────────┘           │
└──────────────────────────────────────────────────────┘
```

**零变更保证**：不安装任何 Context Engine 插件时，行为与之前完全一致（使用内置 `legacy` 引擎）。

### 1.3 配置方式

```json5
{
  plugins: {
    slots: {
      contextEngine: "lossless-claw"  // 或 "legacy"（默认）
    }
  }
}
```

### 1.4 开发接口

```typescript
// 插件注册 Context Engine
export default function (api) {
  api.registerContextEngine("my-engine", () => ({
    info: { id: "my-engine", name: "My Engine", ownsCompaction: true },
    
    async bootstrap()   { /* 初始化 */ },
    async ingest()      { /* 消息摄入 */ },
    async assemble({ messages }) { /* 上下文组装 */ 
      return { messages, estimatedTokens: 0 };
    },
    async compact()     { /* 压缩策略 */ },
    async afterTurn()   { /* 回合后处理 */ },
    async prepareSubagentSpawn() { /* 子Agent上下文准备 */ },
    async onSubagentEnded()      { /* 子Agent结束回调 */ },
  }));
}
```

**7 个生命周期钩子**覆盖了从消息进入到子Agent结束的完整上下文链路。

---

## 二、为什么这很重要（价值分析）

### 2.1 解决的核心痛点

| 痛点 | 旧方案的问题 | 新方案如何解决 |
|------|-------------|---------------|
| **长对话遗忘** | 滑动窗口压缩后丢失细节 | 插件可实现无损压缩（如 DAG 摘要树） |
| **压缩质量差** | 固定的压缩策略，一刀切 | 不同场景选择不同的压缩策略 |
| **Agent"变笨"** | 上下文被压缩后丢失关键计划 | 插件可保留原始消息，按需展开 |
| **无法定制** | 硬编码逻辑，用户无法干预 | 完整的插件 API，可完全替换 |
| **子Agent上下文隔离** | 子Agent看不到父Agent的上下文 | 生命周期钩子控制上下文传递 |

PR 作者 Josh Lehman 的核心观点：

> "You don't actually need an Agent memory system. What you need is a context that won't be reset."
> 
> 你不需要 Agent 记忆系统，你需要的是一个不会被重置的上下文。

### 2.2 架构意义

**从"硬编码管线"到"可插拔策略"** —— 这是 OpenClaw 架构演进的关键一步：

1. **关注点分离**：核心运行时不再关心"如何压缩上下文"，只关心"调用哪个引擎"
2. **生态赋能**：第三方开发者可以创建专用的上下文引擎，适配不同场景
3. **竞争力提升**：上下文管理质量成为可选择的"组件"，而非框架限制
4. **与模型解耦**：不同模型可以配合不同的上下文策略

### 2.3 生态影响

这个机制为 OpenClaw 插件生态打开了**最有价值的扩展点**之一。上下文管理直接影响：

- Agent 的长期记忆质量
- 多轮对话的连贯性
- 复杂任务的执行成功率
- Token 使用效率和成本

正如网友评论：**"比起用哪个模型，上下文才是关键。"**

---

## 三、标杆案例：lossless-claw

### 3.1 核心原理

`lossless-claw` 基于 [LCM（Lossless Context Management）论文](https://papers.voltropy.com/LCM)，用 **DAG（有向无环图）摘要树** 替代传统的滑动窗口压缩：

```
传统方式：                          lossless-claw：
                                    
消息1 ──┐                          消息1 ──┐
消息2 ──┤                          消息2 ──┼── 叶节点摘要A ──┐
消息3 ──┤→ 压缩摘要（丢失细节）     消息3 ──┘                ├── 高层摘要X
消息4 ──┤                          消息4 ──┐                │
消息5 ──┘                          消息5 ──┼── 叶节点摘要B ──┘
                                   消息6 ──┘
消息6 ── 保留                       消息7 ── 保留（最近N条）
消息7 ── 保留                       消息8 ── 保留
```

**关键差异**：
- ❌ 传统方式：压缩后原始消息**被丢弃**
- ✅ lossless-claw：原始消息**持久化在 SQLite 中**，摘要层层聚合成 DAG

### 3.2 工作流程

```
1. 新消息到达
   ↓
2. 消息存入 SQLite 数据库（按会话组织）
   ↓
3. 上下文接近阈值（默认 75% 窗口）
   ↓
4. 将旧消息块生成叶节点摘要
   ↓
5. 叶节点摘要达到一定数量 → 聚合为高层摘要
   ↓
6. 上下文组装：高层摘要 + 叶节点摘要 + 最近 N 条原始消息
   ↓
7. Agent 需要细节？→ 用工具展开摘要查看原始消息
```

### 3.3 提供的 Agent 工具

| 工具 | 功能 | 用途 |
|------|------|------|
| `lcm_grep` | 搜索历史消息 | 精确查找之前提到的内容 |
| `lcm_describe` | 描述上下文结构 | 了解 DAG 摘要树的组织方式 |
| `lcm_expand` | 展开摘要 | 从摘要追溯到原始消息 |
| `lcm_expand_query` | 查询式展开 | 主 Agent 按需查看被压缩的历史 |

### 3.4 性能表现

**OOLONG Benchmark**（长上下文编程任务）：

| 方案 | 分数 |
|------|------|
| **lossless-claw** | **74.8** |
| Claude Code | 70.3 |

> 上下文越长，差距越大。在所有测试的上下文长度下，lossless-claw 的分数都高于 Claude Code。

### 3.5 配置参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `freshTailCount` | 32 | 保护的最近消息数量 |
| `contextThreshold` | 0.75 | 触发压缩的上下文窗口占比 |
| `incrementalMaxDepth` | 0 | 增量压缩深度（-1=无限） |
| `leafMinFanout` | 8 | 叶节点最少消息数 |
| `leafChunkTokens` | 20000 | 叶节点最大源 token 数 |
| `leafTargetTokens` | 1200 | 叶节点摘要目标 token 数 |
| `condensedTargetTokens` | 2000 | 聚合摘要目标 token 数 |

---

## 四、使用场景分析

### 4.1 场景一：长期编程助手

**问题**：Agent 在长时间编程任务中逐渐忘记之前的修改和计划
**方案**：使用 lossless-claw，所有代码修改历史保留在 DAG 中
**效果**：Agent 可以随时回忆"之前改了哪些文件"、"原来的计划是什么"

### 4.2 场景二：多轮研究对话

**问题**：研究类对话在压缩后丢失关键发现和引用来源
**方案**：Context Engine 保留完整研究历史，Agent 可以用 `lcm_grep` 搜索
**效果**：即使对话很长，也能精确找到之前的研究发现

### 4.3 场景三：项目管理 Agent

**问题**：项目管理 Agent 需要记住所有任务状态、决策和交办事项
**方案**：DAG 摘要树按主题聚合，高层摘要保持全局视野
**效果**：Agent 在项目全周期保持一致的上下文认知

### 4.4 场景四：客服 Agent

**问题**：客服对话需要快速回溯历史问题和解决方案
**方案**：可以开发专门的客服 Context Engine，按工单/问题类型组织
**效果**：比通用压缩更高效地利用上下文窗口

### 4.5 场景五：自定义领域 Agent

**问题**：特定领域（医疗/法律/金融）需要特殊的上下文保留策略
**方案**：开发领域专用 Context Engine，优先保留关键术语和事实
**效果**：在有限的上下文窗口中最大化领域相关信息的密度

---

## 五、与上一篇报告的关联

在 [OpenClaw 多Agent记忆系统与上下文共享](./openclaw-multi-agent-memory-and-context-sharing.md) 报告中，我们分析了 OpenClaw 的记忆架构。Pluggable Context Engine 是对该架构的**重大增强**：

| 维度 | 之前（Memory + Compaction） | 现在（+ Context Engine） |
|------|---------------------------|------------------------|
| 记忆持久化 | Markdown 文件（memory/） | 不变，仍然是 Markdown |
| 上下文压缩 | 固定的滑动窗口 | **可插拔策略** |
| 信息保留 | 压缩后丢失细节 | **可做到无损保留** |
| 子Agent上下文 | 仅注入 AGENTS.md + TOOLS.md | **生命周期钩子控制** |
| 定制能力 | 仅 memoryFlush 可配置 | **完整 7 个生命周期钩子** |

**互补关系**：
- **Memory 系统**（MEMORY.md + memory/）：**跨会话**的持久记忆
- **Context Engine**：**会话内**的上下文管理策略

两者不冲突，而是覆盖不同的记忆层级。

---

## 六、总结

### 关键价值

1. **"不再遗忘"** — 从根本上解决长对话上下文丢失问题
2. **策略可选** — 不同场景用不同引擎，而非一刀切
3. **生态赋能** — 第三方开发者可以创建专用的上下文策略
4. **零侵入** — 不安装插件时行为完全不变
5. **子Agent 覆盖** — 生命周期钩子延伸到子Agent

### 行业意义

这标志着 Agent 框架从"提供一种上下文管理方案"到"提供上下文管理的可扩展平台"的转变。正如容器编排不再绑定特定的网络方案（CNI 可插拔），AI Agent 的上下文管理也走向了**可插拔化**。

> **上下文管理是 Agent 质量的最后一公里。** Pluggable Context Engine 让这一公里从"框架决定"变为"用户选择"。

---

## 参考来源

1. [OpenClaw v2026.3.7 Release Notes](https://github.com/openclaw/openclaw/releases/tag/v2026.3.7) — 官方 Changelog
2. [PR #22201](https://github.com/openclaw/openclaw/pull/22201) — Context Engine Plugin 核心 PR
3. [lossless-claw GitHub 仓库](https://github.com/Martian-Engineering/lossless-claw) — 标杆插件实现
4. [LCM 论文](https://papers.voltropy.com/LCM) — Lossless Context Management 理论基础
5. [OOLONG Benchmark 可视化](https://losslesscontext.ai) — lossless-claw 性能演示
6. `/usr/lib/node_modules/openclaw/docs/tools/plugin.md` — OpenClaw 插件系统文档
7. `/usr/lib/node_modules/openclaw/docs/concepts/context.md` — 上下文概念文档
8. `/usr/lib/node_modules/openclaw/docs/plugins/manifest.md` — 插件清单规范
9. [量子位解读文章](https://eu.36kr.com/en/p/3715485040324742) — 36kr 量子位对此次更新的分析
