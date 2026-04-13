# Part 5：配置详解与场景推荐 + lossless-claw 协作分析

## 一、基础配置逐项解读

### 1.1 memory-core（记忆核心引擎）

```json
"memory-core": {
  "config": {
    "dreaming": {
      "enabled": true,
      "timezone": "Asia/Shanghai"
    }
  }
}
```

| 字段 | 值 | 含义 |
|------|---|------|
| `dreaming.enabled` | `true` | 开启 Dreaming 后台整理，自动创建 cron job |
| `dreaming.timezone` | `"Asia/Shanghai"` | cron 使用的时区 |
| `dreaming.frequency`（隐含） | `"0 3 * * *"` | 每天凌晨 3:00 执行完整 sweep |

频率调整建议：

| 场景 | frequency | 理由 |
|------|-----------|------|
| 日常使用（推荐） | `"0 3 * * *"` | 每天一次，够用 |
| 高频交互 | `"0 */6 * * *"` | 每 6 小时，短期信号不积压 |
| 低频使用 | `"0 3 * * 1"` | 每周一次，省资源 |

### 1.2 active-memory（主动记忆）

```json
"active-memory": {
  "enabled": true,
  "config": {
    "agents": ["main"],
    "allowedChatTypes": ["direct"],
    "queryMode": "recent",
    "promptStyle": "balanced",
    "timeoutMs": 15000
  }
}
```

| 字段 | 值 | 含义 |
|------|---|------|
| `enabled` | `true` | 插件级开关。关掉后 `/active-memory` 命令也不可用 |
| `config.agents` | `["main"]` | 哪些 Agent 启用主动记忆 |
| `config.allowedChatTypes` | `["direct"]` | direct=私聊, group=群聊, channel=频道 |
| `config.queryMode` | `"recent"` | Sub-Agent 能看到多少对话上下文 |
| `config.promptStyle` | `"balanced"` | 搜索的积极程度/策略 |
| `config.timeoutMs` | `15000` | 硬超时（ms），超时返回 NONE |

#### queryMode 详解

| 模式 | Sub-Agent 看到 | 延迟 | 推荐超时 |
|------|---------------|------|---------|
| `"message"` | 仅最新一条消息 | 最低（1-3s） | 3000-5000 |
| `"recent"` | 最新消息 + 近几轮对话 | 中等（3-8s） | 10000-15000 |
| `"full"` | 完整对话历史 | 最高（5-15s+） | 15000-30000 |

#### promptStyle 详解

| 风格 | 行为 | 最佳场景 |
|------|------|---------|
| `"balanced"` | 通用默认 | 大多数场景 |
| `"strict"` | 非常保守 | 技术工作/不想被打扰 |
| `"contextual"` | 重视对话连续性 | 长对话/多轮讨论 |
| `"recall-heavy"` | 软匹配也返回 | 最大化记忆利用 |
| `"precision-heavy"` | 只返回明确匹配 | 减少噪音 |
| `"preference-only"` | 只关注偏好/习惯 | 个人助理/生活场景 |

#### 未写出但可用的高级字段

| 字段 | 默认值 | 含义 |
|------|-------|------|
| `config.model` | 继承 session model | 指定 Sub-Agent 模型 |
| `config.modelFallbackPolicy` | `"default-remote"` | 无模型时回退策略 |
| `config.maxSummaryChars` | `220` | 摘要最大字符数 |
| `config.thinking` | `"off"` | 思考级别（开启增加延迟） |
| `config.persistTranscripts` | `false` | 保留 Sub-Agent session 记录 |
| `config.logging` | `false` | 调试日志 |
| `config.cacheTtlMs` | — | 相同查询缓存复用 |

### 1.3 memory-wiki（知识 Wiki）

```json
"memory-wiki": {
  "enabled": true,
  "config": {
    "vaultMode": "isolated",
    "render": { "createDashboards": true }
  }
}
```

| 字段 | 值 | 含义 |
|------|---|------|
| `enabled` | `true` | 插件开关 |
| `config.vaultMode` | `"isolated"` | 数据来源模式 |
| `render.createDashboards` | `true` | 自动生成健康报告 |

#### vaultMode 详解

| 模式 | 数据来源 | 适用 |
|------|---------|------|
| `"isolated"` | 自有内容，不依赖 memory-core | 起步推荐 |
| `"bridge"` | 自动从 memory-core 导入 | 进阶，自动化 |
| `"unsafe-local"` | 本地文件系统直接访问 | 实验性 |

#### 完整可用字段

```json
"memory-wiki": {
  "enabled": true,
  "config": {
    "vaultMode": "bridge",
    "vault": {
      "path": "~/.openclaw/wiki/main",
      "renderMode": "obsidian"             // "native" 或 "obsidian"
    },
    "bridge": {
      "enabled": true,
      "readMemoryArtifacts": true,
      "indexDreamReports": true,
      "indexDailyNotes": true,
      "indexMemoryRoot": true,
      "followMemoryEvents": true
    },
    "search": {
      "backend": "shared",                 // "shared" 或 "local"
      "corpus": "wiki"                     // "wiki" / "memory" / "all"
    },
    "context": {
      "includeCompiledDigestPrompt": false
    },
    "render": {
      "preserveHumanBlocks": true,
      "createBacklinks": true,
      "createDashboards": true
    },
    "obsidian": {
      "enabled": false,
      "vaultName": "OpenClaw Wiki"
    }
  }
}
```

---

## 二、场景推荐配置

### 场景 1：个人助理（重视个性化）

```json
{
  "plugins": { "entries": {
    "memory-core": { "config": { "dreaming": { "enabled": true, "timezone": "Asia/Shanghai" } } },
    "active-memory": { "enabled": true, "config": {
      "agents": ["main"], "allowedChatTypes": ["direct"],
      "queryMode": "recent", "promptStyle": "preference-only",
      "timeoutMs": 10000, "maxSummaryChars": 300
    }}
  }}
}
```
- `preference-only` → 只召回偏好/习惯
- 不需要 Memory Wiki
- `maxSummaryChars: 300` → 稍多个性化上下文

### 场景 2：技术研究（多 Agent 团队）

```json
{
  "plugins": { "entries": {
    "memory-core": { "config": { "dreaming": { "enabled": true, "timezone": "Asia/Shanghai" } } },
    "active-memory": { "enabled": true, "config": {
      "agents": ["main", "wairesearch"], "allowedChatTypes": ["direct"],
      "queryMode": "recent", "promptStyle": "contextual", "timeoutMs": 15000
    }},
    "memory-wiki": { "enabled": true, "config": {
      "vaultMode": "bridge",
      "bridge": { "enabled": true, "readMemoryArtifacts": true, "indexDreamReports": true, "indexDailyNotes": true, "indexMemoryRoot": true },
      "search": { "backend": "shared", "corpus": "all" },
      "render": { "createDashboards": true, "createBacklinks": true }
    }}
  }}
}
```
- 多 Agent 启用 Active Memory
- `contextual` → 长研究对话重视连续性
- Wiki `bridge` 模式 → 自动从记忆导入
- `corpus: "all"` → 搜索覆盖 memory + wiki

### 场景 3：团队群聊（低延迟、少噪音）

```json
{
  "plugins": { "entries": {
    "memory-core": { "config": { "dreaming": { "enabled": true, "timezone": "Asia/Shanghai" } } },
    "active-memory": { "enabled": true, "config": {
      "agents": ["main"], "allowedChatTypes": ["direct", "group"],
      "queryMode": "message", "promptStyle": "strict",
      "timeoutMs": 5000, "maxSummaryChars": 150
    }}
  }}
}
```
- `message` + `strict` → 最低延迟 + 最少误召回
- 群聊超时 5s

### 场景 4：后台自动化（不需要 Active Memory）

```json
{
  "plugins": { "entries": {
    "memory-core": { "config": { "dreaming": { "enabled": true, "timezone": "Asia/Shanghai" } } },
    "active-memory": { "enabled": false },
    "memory-wiki": { "enabled": true, "config": { "vaultMode": "isolated", "render": { "createDashboards": true } } }
  }}
}
```
- Active Memory 关闭（后台任务不需要个性化）
- Dreaming 照常 + Wiki 用于知识积累

### 场景 5：极简省钱

```json
{
  "plugins": { "entries": {
    "memory-core": { "config": { "dreaming": { "enabled": true, "timezone": "Asia/Shanghai", "frequency": "0 3 * * 1" } } },
    "active-memory": { "enabled": true, "config": {
      "agents": ["main"], "queryMode": "message", "promptStyle": "balanced", "timeoutMs": 5000
    }}
  }}
}
```
- Dreaming 每周一次
- Active Memory `message` 模式（最低成本）
- 不配 embedding provider → 纯 FTS5（零 API 成本）

---

## 三、与 lossless-claw 插件的协作关系

### 3.1 定位完全不同

| | lossless-claw | Active Memory / Dreaming / Memory Wiki |
|--|--------------|---------------------------------------|
| **管什么** | 对话历史（消息级） | 知识记忆（事实级） |
| **存在哪** | SQLite（LCM 数据库） | MEMORY.md / memory/*.md / Wiki vault |
| **解决什么** | 上下文窗口塞不下完整对话 | Agent 跨会话不记得事实 |
| **触发时机** | 对话变长 → 自动 compact | 会话间 / 定时 cron |

### 3.2 协作流程

```
对话发生
    ↓
lossless-claw: 持久化消息 → 压缩旧消息为摘要 DAG → 保持上下文窗口可控
    ↓（同时）
memory-core: Compaction 前 flush → 重要事实写入 memory 文件
    ↓
Dreaming: 定时扫描 memory 文件 → 评分 → 晋升到 MEMORY.md
    ↓
Memory Wiki: 编译 MEMORY.md → 结构化知识
    ↓
Active Memory: 下次对话时主动注入相关记忆
```

### 3.3 搜索层完全独立

| 工具 | 搜索什么 |
|------|---------|
| `lcm_grep` / `lcm_expand_query` | 对话历史（原始消息 + 摘要） |
| `memory_search` | 记忆文件（MEMORY.md + daily notes） |
| `wiki_search` | Wiki 知识库 |

**三者搜索不同数据源，不会冲突或覆盖。**

### 3.4 Compaction 时的协作

唯一的交叉点在 Compaction 触发时：
1. **memory-core 先执行** silent flush（保存事实到 memory 文件）
2. **lossless-claw 再压缩**（管理对话历史的摘要 DAG）

这是**串行协作**，不是竞争。

### 3.5 结论

| 问题 | 答案 |
|------|------|
| 能同时启用吗？ | ✅ 推荐一起用 |
| 会互相干扰吗？ | ❌ 不同层不同数据 |
| 有协作点吗？ | ✅ Compaction 时协作 |
| 搜索冲突吗？ | ❌ 搜不同东西 |

**最佳实践**：lossless-claw 管"说过什么"（对话级），memory 系统管"知道什么"（知识级），完整覆盖。

### 3.6 关于 Dreaming 与 memorySearch 的依赖

如果要使用 Dreaming，**不建议禁用 memorySearch**。Deep Phase 六维评分中 **69% 的权重**（Relevance 0.30 + Frequency 0.24 + Query Diversity 0.15）依赖 memory_search 产生的召回追踪。禁用后门控阈值几乎无法通过。

**最省钱方案**：不配 embedding provider → FTS5 关键词搜索自动可用 → 召回追踪正常 → Dreaming 正常评分 → **零 API 成本**。
