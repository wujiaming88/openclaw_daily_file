# OpenClaw 新记忆特性深度研究报告：Active Memory / Dreaming / Memory Wiki

> **研究员**：黄山（wairesearch）| **日期**：2026-04-13 | **版本**：1.1（增加配置详解、场景推荐、lossless-claw 协作分析）

---

## 执行摘要

OpenClaw 近期发布了三个革命性的记忆特性：**Active Memory**（主动记忆，2026.4.10）、**Dreaming**（梦境整理，实验性）和 **Memory Wiki**（编译式知识库）。它们分别解决了记忆系统的三个根本问题：**记忆不被主动使用**（Active Memory）、**长期记忆质量失控**（Dreaming）、**知识缺乏结构和溯源**（Memory Wiki）。三者形成一个完整的记忆生命周期：Active Memory 让记忆在对话中主动发挥作用，Dreaming 让短期信号经过严格筛选进入长期记忆，Memory Wiki 让持久知识有结构、可追溯、可质疑。

---

## 一、全景架构

```
┌────────────────────────────────────────────────┐
│           用户/Agent 交互层                      │
│     "帮我点外卖" / memory_search                 │
└───────────────┬────────────────────────────────┘
                ↓
┌────────────────────────────────────────────────┐
│      Active Memory（主动记忆层）       [NEW]     │
│  Blocking Sub-Agent → 主动搜索 → 注入上下文      │
│  在主回复前运行，用户无感知                       │
└───────────────┬────────────────────────────────┘
                ↓
┌────────────────────────────────────────────────┐
│   Active Memory Plugin（记忆运行时层）            │
│   memory-core / QMD / Honcho                    │
│   ┌─────────┬─────────┬──────────┐             │
│   │ Recall  │ Search  │ Dreaming │  [NEW]      │
│   │ 召回    │ 搜索    │ Light→REM→Deep          │
│   └─────────┴─────────┴──────────┘             │
│   Compaction 前自动 Flush                        │
└───────────────┬────────────────────────────────┘
                ↓
┌────────────────────────────────────────────────┐
│      Memory Wiki（知识编译层）         [NEW]      │
│   Claims / Evidence / Provenance                │
│   Dashboards / Obsidian 集成                     │
└───────────────┬────────────────────────────────┘
                ↓
┌────────────────────────────────────────────────┐
│            存储引擎层                            │
│   SQLite + FTS5 + Embeddings + Hybrid Search    │
└────────────────────────────────────────────────┘
```

**职责分工**：
| 组件 | 职责 |
|------|------|
| Active Memory | 主动搜索、主回复前注入 |
| memory-core | 召回、搜索、索引、Dreaming、晋升 |
| Memory Wiki | 知识编译、溯源、矛盾追踪、仪表板 |

---

## 二、Active Memory —— 让记忆从被动变主动

### 2.1 解决什么问题

传统记忆系统的致命缺陷：**能力强但被动**。依赖用户主动触发搜索，否则形同虚设。

> "那不是真正的记忆。那是一个有着糟糕 UX 的文件柜。"

### 2.2 工作原理

```
用户消息 → 构建查询 → Blocking Sub-Agent
  ├── 找到记忆 → 摘要(≤220字符) → 隐藏注入 system context → 主回复
  └── 无记忆 → NONE → 正常主回复
```

- **阻塞式**运行（主回复前），不是异步
- 只能用 `memory_search` / `memory_get`
- 隐藏注入 → 用户看不到技术标签
- 超时 → 返回 NONE → 不影响主回复

### 2.3 六种提示风格

| 风格 | 策略 |
|------|------|
| balanced | 通用默认 |
| strict | 几乎不返回 |
| contextual | 重视对话连续性 |
| recall-heavy | 软匹配也返回 |
| precision-heavy | 只返回明显匹配 |
| preference-only | 只关注个人偏好/习惯 |

### 2.4 价值

**之前**："帮我点外卖" → "你喜欢什么？" → 用户反复解释
**之后**："帮我点外卖" → Active Memory 后台搜到"柠椒翅+蓝芝士" → "老样子——柠椒翅配蓝芝士？"

---

## 三、Dreaming —— 人类睡眠启发的记忆整理

### 3.1 解决什么问题

MEMORY.md 不加控制地增长 → 质量参差不齐 → 上下文窗口污染 → 长期记忆信噪比下降。

### 3.2 三个相位

| 相位 | 人类类比 | 功能 | 写 MEMORY.md |
|------|---------|------|------------|
| **Light** | 浅睡眠 | 分类暂存、去重、记录强化信号 | ❌ |
| **REM** | 快速眼动 | 主题反思、模式提取 | ❌ |
| **Deep** | 深睡眠 | 评分晋升、写入长期记忆 | ✅ 唯一 |

### 3.3 六维评分系统

| 信号 | 权重 |
|------|------|
| Relevance（相关性） | 0.30 |
| Frequency（频率） | 0.24 |
| Query Diversity（查询多样性） | 0.15 |
| Recency（新近性） | 0.15 |
| Consolidation（巩固度） | 0.10 |
| Conceptual Richness（概念丰富度） | 0.06 |

**三重门控**：minScore + minRecallCount + minUniqueQueries → 全部通过才能晋升。

### 3.4 双输出

- `memory/.dreams/` → 机器面（召回、信号、检查点）
- `DREAMS.md` → 人类面（梦境日记，可审查）

### 3.5 Grounded Historical Backfill

可以对历史笔记进行回放审查，但**不直接写 MEMORY.md**——暂存到短期存储，由正常 Deep Phase 决定是否晋升。

### 3.6 价值

**之前**：MEMORY.md 无节制膨胀，噪音与信号混杂
**之后**：六维评分 + 三重门控 → 只有"真正持久"的内容才进入长期记忆 → **MEMORY.md 保持精简高信噪比**

---

## 四、Memory Wiki —— 编译式知识库

### 4.1 解决什么问题

MEMORY.md 是扁平 Markdown：没有溯源、没有矛盾检测、没有置信度、没有结构化查询。

### 4.2 核心能力

**结构化 Claims（声明）**：每个知识点有 id、text、status、confidence、evidence[]。可追踪、可评分、可质疑、可追溯到原始来源。

**编译管道**：Wiki Pages → 标准化摘要 → `agent-digest.json` + `claims.jsonl`

**自动健康报告**：
- `contradictions.md` — 矛盾集群
- `low-confidence.md` — 低置信度
- `stale-pages.md` — 过时页面
- `open-questions.md` — 未解决问题
- `claim-health.md` — 证据缺口

### 4.3 三种 Vault 模式

| 模式 | 数据来源 |
|------|---------|
| **isolated** | 自有内容（推荐起步） |
| **bridge** | 从 Active Memory Plugin 读取公开产物 |
| **unsafe-local** | 本地文件系统（实验性） |

### 4.4 Obsidian 集成

可选开启 → 在 Obsidian 中浏览和操作 Wiki vault，获得可视化知识图谱体验。

### 4.5 价值

**之前**：知识是"一堆 Markdown 文件"
**之后**：知识是"有结构、有溯源、有置信度、可质疑的知识库"

---

## 五、综合对比：有这些特性 vs 没有

| 维度 | 之前（基础记忆） | 之后（三大新特性） |
|------|----------------|-----------------|
| **记忆使用** | 被动（用户/Agent 主动搜索） | 主动（Active Memory 自动注入） |
| **长期记忆质量** | 无控制（Agent 随意写入） | 六维评分 + 三重门控（Dreaming） |
| **知识结构** | 扁平 Markdown | 分类页面 + 结构化 Claims（Wiki） |
| **溯源** | 无 | 每个 Claim 有 evidence 链 |
| **矛盾检测** | 无 | 自动仪表板 |
| **置信度** | 无（同等权重） | 每个 Claim 有 confidence |
| **过时检测** | 无 | stale-pages 报告 |
| **人类审查** | 直接读 MEMORY.md | DREAMS.md + Obsidian + Dashboards |
| **个性化感知** | "这 AI 没记性" | "它记得我的偏好" |
| **信噪比** | 随时间下降 | Dreaming 持续维护 |

---

## 六、三特性的协同效应

三个特性形成一个**完整的记忆生命周期**：

```
每日交互 → 每日笔记 (memory/YYYY-MM-DD.md)
                     ↓
              Dreaming (Light → REM → Deep)
                     ↓
              通过三重门控 → MEMORY.md（精简的长期记忆）
                     ↓
              Memory Wiki 编译 → 结构化知识库 + 健康报告
                     ↓
              Active Memory → 每次对话自动注入相关记忆
                     ↓
              更好的回复 → 更好的每日交互 → 正循环
```

**这是一个闭环**：好的交互产生好的笔记 → Dreaming 筛选出高质量长期记忆 → Wiki 编译成结构化知识 → Active Memory 主动运用 → 产生更好的交互。

---

## 七、使用建议

### 基础配置（推荐起步）

```json
{
  "plugins": {
    "entries": {
      "memory-core": {
        "config": {
          "dreaming": { "enabled": true, "timezone": "Asia/Shanghai" }
        }
      },
      "active-memory": {
        "enabled": true,
        "config": {
          "agents": ["main"],
          "allowedChatTypes": ["direct"],
          "queryMode": "recent",
          "promptStyle": "balanced",
          "timeoutMs": 15000
        }
      },
      "memory-wiki": {
        "enabled": true,
        "config": {
          "vaultMode": "isolated",
          "render": { "createDashboards": true }
        }
      }
    }
  }
}
```

### 进阶配置

- Memory Wiki 切 `bridge` 模式 → 自动从 memory-core 导入
- QMD 替代 builtin 后端 → 更强的 reranking 和查询扩展
- Active Memory 用 `preference-only` 风格 → 个性化助手场景

---

## 八、配置详解与场景推荐

### 8.1 基础配置逐项解读

#### memory-core

| 字段 | 默认值 | 含义 |
|------|-------|------|
| `dreaming.enabled` | `false` | 开启 Dreaming 后台整理 |
| `dreaming.timezone` | UTC | cron 时区 |
| `dreaming.frequency` | `"0 3 * * *"` | sweep 频率（可改为 `"0 */6 * * *"` 或 `"0 3 * * 1"`） |

#### active-memory

| 字段 | 推荐值 | 含义 |
|------|-------|------|
| `config.agents` | `["main"]` | 哪些 Agent 启用 |
| `config.allowedChatTypes` | `["direct"]` | direct/group/channel |
| `config.queryMode` | `"recent"` | message(最快) / recent(平衡) / full(最准) |
| `config.promptStyle` | `"balanced"` | balanced/strict/contextual/recall-heavy/precision-heavy/preference-only |
| `config.timeoutMs` | `15000` | 硬超时(ms) |
| `config.maxSummaryChars` | `220` | 摘要最大字符 |
| `config.model` | 继承 session | 可指定 Sub-Agent 模型 |
| `config.thinking` | `"off"` | 开启增加延迟 |
| `config.logging` | `false` | 调优时开启 |

#### memory-wiki

| 字段 | 推荐值 | 含义 |
|------|-------|------|
| `config.vaultMode` | `"isolated"` | isolated(起步) / bridge(进阶) / unsafe-local(实验) |
| `vault.renderMode` | `"native"` | native / obsidian |
| `search.corpus` | `"wiki"` | wiki / memory / all |
| `render.createDashboards` | `true` | 自动健康报告 |

### 8.2 五种场景推荐配置

| 场景 | Active Memory | Dreaming | Wiki | 要点 |
|------|--------------|----------|------|------|
| **个人助理** | ✅ preference-only, 10s | ✅ 每天 | ❌ | 偏好/习惯召回 |
| **技术研究** | ✅ contextual, 15s, 多Agent | ✅ 每天 | ✅ bridge, corpus=all | 长对话连续性+知识溯源 |
| **团队群聊** | ✅ strict, message, 5s | ✅ 每天 | ❌ | 低延迟少噪音 |
| **后台自动化** | ❌ | ✅ 每天 | ✅ isolated | 不需个性化 |
| **极简省钱** | ✅ message, 5s | ✅ 每周 | ❌ | 纯FTS5零API成本 |

详细配置见 `part-5.md`。

---

## 九、与 lossless-claw 的协作关系

### 定位不同，完全互补

| | lossless-claw | Memory 新特性 |
|--|--------------|-------------|
| **管什么** | 对话历史（消息级） | 知识记忆（事实级） |
| **存在哪** | SQLite (LCM DB) | MEMORY.md / Wiki vault |
| **解决什么** | 上下文窗口装不下对话 | 跨会话不记得事实 |

### 协作流程

```
对话 → lossless-claw 持久化+压缩 → memory-core flush 保存事实
→ Dreaming 筛选 → Wiki 编译 → Active Memory 注入 → 更好的对话
```

### 搜索完全独立

- `lcm_grep` / `lcm_expand_query` → 对话历史
- `memory_search` → 记忆文件
- `wiki_search` → 知识库

**三者搜不同数据，不冲突。推荐全部一起使用。**

### Dreaming 与 memorySearch 的依赖

Deep Phase 评分 **69% 权重**依赖 memory_search 的召回追踪。禁用 memorySearch 会导致 Dreaming 几乎无法晋升。最省钱方案：不配 embedding provider → FTS5 自动可用 → 零 API 成本。

---

## 参考来源

1. [OpenClaw Memory Overview](https://github.com/openclaw/openclaw/blob/main/docs/concepts/memory.md)
2. [OpenClaw Dreaming (experimental)](https://github.com/openclaw/openclaw/blob/main/docs/concepts/dreaming.md)
3. [OpenClaw Memory Wiki](https://docs.openclaw.ai/plugins/memory-wiki)
4. [OpenClaw Active Memory](https://github.com/eohmig/openclaw_reference/blob/main/docs/concepts/active-memory.md)
5. [OpenClaw Builtin Memory Engine](https://github.com/openclaw/openclaw/blob/main/docs/concepts/memory-builtin.md)
6. [OpenClaw Playbook: 2026.4.10 Release](https://www.openclawplaybook.ai/blog/openclaw-2026-4-10-release-codex-active-memory/)
