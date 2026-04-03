# OpenClaw Lossless Context Management (LCM) 插件研究报告

> 研究员: 黄山 (wairesearch)  
> 日期: 2026-04-03  
> 来源: GitHub Martian-Engineering/lossless-claw、官方文档、社区反馈

---

## 执行摘要

**Lossless-Claw 是一个革新性的 OpenClaw 插件，用 DAG 结构替代传统滑动窗口压缩，实现真正的「无损上下文管理」。**

核心创新：
- ✅ **无消息丢失**：所有对话持久化到 SQLite，支持完整回溯
- ✅ **智能摘要 DAG**：多层次摘要树，保留展开能力
- ✅ **主动遗忘**：只压缩旧对话，最近 N 条消息始终完整可见
- ✅ **低成本检索**：lcm_grep（正则搜索）、lcm_describe（快速查询）、lcm_expand_query（子 agent 深度挖掘）

**与 OpenClaw 原生 Compaction 的本质区别**：
- 原生：滑动窗口 → 无法回顾被摘要的细节
- LCM：DAG 摘要树 → 随时可按需展开回溯任何细节

---

## 一、核心架构

### 1.1 数据模型

```
SQLite 数据库（~/.openclaw/lcm.db）
├── conversations
│   └── 每个 sessionKey 对应一条 conversation
├── messages
│   ├── seq、role、content、tokenCount
│   └── message_parts（保留原始结构：文本、工具调用、文件等）
├── summaries（DAG 节点）
│   ├── 深度 0（leaf）：从原始消息生成
│   ├── 深度 1+（condensed）：从上层摘要生成
│   └── 每个摘要：sum_abc123 格式，包含时间范围、descendantCount
└── context_items（当前上下文清单）
    └── 有序列表：[summary₁, summary₂, ..., message₁, message₂, ...]
```

### 1.2 信息流

```
用户消息
    ↓
[ingest] → SQLite 持久化 + context_items 追加
    ↓
模型处理 → 回复
    ↓
[afterTurn] → 检查 token 使用，触发增量 compaction
    ↓
Leaf Pass（消息 → 摘要）
    ↓
Condensed Pass（摘要 → 高层摘要）
    ↓
DAG 更新，context_items 替换
```

### 1.3 核心指标

| 配置项 | 默认值 | 含义 |
|--------|--------|------|
| `freshTailCount` | 64 | 最后 64 条消息保持完整，不压缩 |
| `leafChunkTokens` | 20000 | 单个 leaf chunk 的 token 上限 |
| `contextThreshold` | 0.75 | 触发 compaction 的上下文使用率（75%） |
| `incrementalMaxDepth` | 1 | 每次 turn 后的压缩深度（0=仅 leaf，1=one pass，-1=无限） |
| `newSessionRetainDepth` | 2 | /new 后保留的摘要深度 |

---

## 二、Compaction 生命周期

### 2.1 三种模式

#### 增量 Compaction（每 turn 后自动）
```
1. 检查 freshTail 外的原始 token 是否超 leafChunkTokens
2. 触发 ≤1 次 leaf pass
3. 可选：1 次 condensed pass（incrementalMaxDepth=1）
4. 轻量级，确保不阻塞对话
```

#### 完整扫描（手动 /compact 或溢出恢复）
```
Phase 1: 重复 leaf pass 直到无可压缩
Phase 2: 重复 condensed pass 直到到达最高层或无 token 收益
目标：最大化压缩率
```

#### 预算目标（溢出恢复）
```
运行多达 10 轮完整扫描
直到 context ≤ 目标 token 数
```

### 2.2 摘要生成（三层降级）

```
尝试 1: 标准摘要
  ├─ 温度 0.2，标准提示
  └─ 目标 token：1200（leaf）/ 2000（condensed）

尝试 2: 激进摘要（失败时）
  ├─ 温度 0.1，压缩提示（仅关键事实）
  └─ 目标 token：800（leaf）/ 1500（condensed）

尝试 3: 确定性截断（LLM 失败时）
  └─ ~512 token，标记为 "[Truncated for context management]"
```

**确保 compaction 总能成功**（不会卡死）。

### 2.3 Leaf 摘要结构

```xml
<summary id="sum_abc123def456" kind="leaf" depth="0" 
         earliest_at="2026-02-17T07:37:00" latest_at="2026-02-17T08:23:00"
         descendant_count="0">
  <content>
    [2026-02-17 07:37] User asked about database migration...
    [2026-02-17 07:45] Assistant explained the three-phase approach...
    
    Expand for details about:
    - Exact SQL migration commands
    - Rollback procedure
    - Data validation checks
  </content>
</summary>
```

**"Expand for details about" 列表告诉 agent 哪些细节被压缩了**。

### 2.4 Condensed 摘要结构

```xml
<summary id="sum_def456ghi789" kind="condensed" depth="1" 
         descendant_count="8">
  <parents>
    <summary_ref id="sum_aaa111" />
    <summary_ref id="sum_bbb222" />
  </parents>
  <content>
    [2026-02-17 07:00–09:00] 数据库迁移讨论：三阶段方案...
    
    Expand for details about:
    - 各阶段的具体时间表
    - 潜在风险和缓解措施
  </content>
</summary>
```

**节点链接：每个 condensed 摘要记录其父摘要 ID，形成可导航的 DAG**。

---

## 三、Context Assembly（上下文组装）

### 3.1 组装流程

```
从 context_items 表读取有序列表
    ↓
分为两部分：
├─ 可驱逐前缀（最早的摘要/消息）
└─ 受保护的 freshTail（最后 64 条原始消息）

预算计算：
├─ freshTail 成本（固定包含，即使超预算）
└─ 填充剩余预算从可驱逐部分（新 → 旧）

结果：[摘要₁, 摘要₂, ..., 消息₁, 消息₂, ...]
      ├─ 预算内摘要
      └─ 总是完整的最近消息
```

### 3.2 消息重建

从 `message_parts` 表重建原始结构：
- 文本块 → 保留格式
- 工具调用 → 完整调用定义
- 工具结果 → 完整输出
- 文件块 → 如果 > 25k token，替换为 `file_xxx` 引用 + 200 token 探索摘要

---

## 四、Agent Tools

### 4.1 lcm_grep（搜索）

```javascript
lcm_grep({
  pattern: "database",           // 正则或全文本查询
  mode: "full_text",             // "regex" 或 "full_text"
  scope: "both",                 // "messages" / "summaries" / "both"
  allConversations: false,       // 跨所有 session
  since: "2026-02-17T00:00:00Z", // 时间范围
  limit: 50                      // 最多 50 条
})
```

**返回**：匹配的消息/摘要列表，包含片段、ID、深度、创建时间。

### 4.2 lcm_describe（快速查询）

```javascript
lcm_describe({
  id: "sum_abc123",              // 摘要 ID 或 file_xxx
  allConversations: false
})
```

**返回**：
- 完整摘要内容
- 元数据（深度、kind、token 数、时间范围）
- 父/子摘要 ID（可导航）
- 源消息 ID（可回溯）
- 文件引用

### 4.3 lcm_expand_query（深度回溯）

```javascript
lcm_expand_query({
  prompt: "What was the root cause of the OAuth bug?",
  query: "OAuth authentication error",        // 或指定 summaryIds
  maxTokens: 2000,                            // 答案长度限制
  allConversations: false
})
```

**工作流**：
1. lcm_grep 找到相关摘要
2. 创建委托授权（delegation grant），限制子 agent 的访问范围和 token 配额
3. 生成子 agent session，赋予 lcm_expand（低级工具）权限
4. 子 agent 走 DAG：读摘要 → 跟随父链接 → 访问源消息 → 检查存储文件
5. 返回焦点化答案 + 引用的摘要 ID
6. 清理授权和子 session

**特点**：
- 子 agent 只有 lcm_expand（防止递归）
- 120 秒超时 + token 上限（默认 4000）
- 成本低于完整重建

---

## 五、大文件处理

### 5.1 流程

```
用户消息包含文件块
    ↓
检查 token 数 > 25k（可配置）
    ↓
生成文件 ID（file_xxx）
    ↓
存储到 ~/.openclaw/lcm-files/{conversationId}/{fileId}/
    ↓
生成 ~200 token 探索摘要（结构分析、关键段落）
    ↓
在消息中用 <file> 引用替换
```

lcm_describe 可恢复完整文件。

---

## 六、与 OpenClaw 原生 Compaction 对比

| 维度 | OpenClaw 原生 | LCM |
|------|--------------|-----|
| **数据持久化** | Transcript JSONL 摘要字符串 | SQLite DAG 结构 |
| **消息丢失** | ✗ 被摘要消息不可回溯 | ✓ 所有消息保留，随时可展开 |
| **回溯成本** | 无法回溯 | lcm_expand_query（~30-120s） |
| **摘要质量** | 单次 LLM 摘要 | 多层 DAG，保留展开能力 |
| **Safeguard 模式** | 会产生假摘要 "Summary unavailable" | 不适用，LCM 自身是解决方案 |
| **错误恢复** | Compaction 失败 → 会话卡死 | 三层降级（标准 → 激进 → 截断），总能进度 |
| **搜索能力** | 无，只能看当前上下文 | lcm_grep（全对话正则/全文搜索） |
| **性能** | 低延迟 | 多了 SQLite 持久化，但异步 |

---

## 七、安装与配置

### 7.1 安装

```bash
openclaw plugins install @martian-engineering/lossless-claw
```

自动配置插件、启用、设置 contextEngine slot。

### 7.2 最小配置

```json
{
  "plugins": {
    "slots": {
      "contextEngine": "lossless-claw"
    }
  }
}
```

### 7.3 推荐配置

```json
{
  "plugins": {
    "entries": {
      "lossless-claw": {
        "enabled": true,
        "config": {
          "freshTailCount": 64,
          "leafChunkTokens": 20000,
          "contextThreshold": 0.75,
          "incrementalMaxDepth": 1,
          "newSessionRetainDepth": 2,
          "summaryModel": "anthropic/claude-haiku-4-5",
          "delegationTimeoutMs": 300000
        }
      }
    }
  },
  "session": {
    "reset": {
      "mode": "idle",
      "idleMinutes": 10080  // 7 天
    }
  }
}
```

环境变量覆盖优先级：`ENV VAR > Plugin Config > Defaults`。

---

## 八、应用场景

### 最适用

| 场景 | 原因 |
|------|------|
| **长期助手** | 无限期记忆，随时可查 |
| **研究工作流** | 需要回溯细节（代码片段、命令、错误日志） |
| **知识累积** | 多个对话可跨搜索（allConversations=true） |
| **审计/合规** | 完整历史持久化 |

### 成本考量

**额外成本**：
- SQLite 存储（每条消息 ~100 bytes metadata）
- Compaction 期间的 LLM 调用（可用便宜模型如 Haiku）
- lcm_expand_query 子 agent 成本（30-120s，代理费用）

**成本优化**：
```json
{
  "summaryModel": "anthropic/claude-haiku-4-5",     // 便宜摘要模型
  "leafChunkTokens": 30000,                         // 减少摘要频率
  "incrementalMaxDepth": 0                          // 仅 leaf，跳过 condensed
}
```

---

## 九、社区增强实现

### win4r/lossless-claw-enhanced

最近的 fork（4 天前），针对中文优化：

- ✅ CJK token 估算修复（中文、日文、韩文正确计算）
- ✅ 上游关键 bug 修复合并
- ✅ 生产可靠性改进

**推荐使用**：
```bash
openclaw plugins install git+https://github.com/win4r/lossless-claw-enhanced.git
```

---

## 十、已知限制 & 注意事项

| 限制 | 影响 | 缓解 |
|------|------|------|
| **SQLite 数据库** | 单机存储，无分布式 | 定期备份 ~/.openclaw/lcm.db |
| **子 agent 超时** | lcm_expand_query 最多 120s | 不执行极复杂的展开，分解为多个查询 |
| **stateless session** | 某些 cron/subagent 不记录 LCM | 配置 ignoreSessionPatterns 明确排除 |
| **/new 后内存** | newSessionRetainDepth 控制保留量 | -1 保留全部，2（推荐）保留 d2+ 摘要 |
| **模型兼容性** | 需要支持 XML 包装的消息格式 | 主流模型（Claude、GPT）都支持 |

---

## 十一、实施路线图

### Phase 1：评估（1 小时）
- [ ] 检查 OpenClaw 版本（需 plugin engine support）
- [ ] 预估存储成本（当前对话量 × 增长因子）
- [ ] 确认摘要模型可用性（Haiku 或等价）

### Phase 2：安装与测试（30 分钟）
- [ ] 安装插件
- [ ] 配置推荐参数
- [ ] 在非关键 session 测试 1-2 天

### Phase 3：监控与调优（1 周）
- [ ] 监测数据库大小增长
- [ ] 观察 compaction 频率和延迟
- [ ] 调整 leafChunkTokens / incrementalMaxDepth
- [ ] 测试 lcm_grep / lcm_describe

### Phase 4：生产部署
- [ ] 全量启用
- [ ] 启用定期 DB 备份
- [ ] 文档化团队工作流

---

## 十二、对你 arkclaw 部署的建议

考虑到你最近遇到的 Ark 问题（contextWindow 配置偏高、safeguard 假摘要），**LCM 可能是根本解决方案**。

**迁移方案**：

```yaml
# 第一步：修复当前问题（快速）
agents:
  defaults:
    compaction:
      mode: "default"
      reserveTokensFloor: 40000

models:
  overrides:
    doubao-seed-2.0-pro:
      contextWindow: 128000

# 第二步：长期方案（LCM）
plugins:
  slots:
    contextEngine: "lossless-claw"
  entries:
    lossless-claw:
      enabled: true
      config:
        freshTailCount: 64
        leafChunkTokens: 20000
        contextThreshold: 0.75
        summaryModel: "doubao-seed-2.0-lite"  # 用便宜模型摘要
        delegationTimeoutMs: 300000
```

**优势**：
1. ✅ 彻底解决 contextWindow 误判（LCM 自管理）
2. ✅ 消除 safeguard 假摘要问题
3. ✅ 完整对话历史可回溯
4. ✅ 支持跨 session 知识搜索

---

## 参考来源

1. [GitHub: Martian-Engineering/lossless-claw](https://github.com/Martian-Engineering/lossless-claw)
2. [LCM 可视化](https://losslesscontext.ai)
3. [LCM 论文](https://papers.voltropy.com/LCM) - Voltropy
4. [Architecture 文档](https://github.com/Martian-Engineering/lossless-claw/blob/main/docs/architecture.md)
5. [Agent Tools 文档](https://github.com/Martian-Engineering/lossless-claw/blob/main/docs/agent-tools.md)
6. [win4r/lossless-claw-enhanced](https://github.com/win4r/lossless-claw-enhanced) - CJK 优化

---

## 建议后续行动

1. **对标评估**：LCM vs 原生 Compaction + Session Pruning
2. **性能测试**：长期对话下的 token 成本对比
3. **试点部署**：在非关键 session 运行 1-2 周
4. **集成评估**：与你的 doubao 模型配置的兼容性测试

**预期收益**：无消息丢失 + 完整可回溯 + 错误自恢复。
