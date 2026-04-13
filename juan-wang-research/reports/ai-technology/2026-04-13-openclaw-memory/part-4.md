# Part 4：Memory Wiki —— 编译式知识库

## 核心定位

> Memory Wiki 把持久记忆变成一个**编译式知识库**。它不替代 Active Memory Plugin，而是在旁边提供一个有溯源、有结构、有矛盾追踪的知识层。

**类比**：
- Active Memory Plugin = **笔记本**（快速记录、搜索、整理）
- Memory Wiki = **维基百科**（编译、溯源、结构化、可导航）

## 与 Active Memory 的分工

| 层 | 负责 |
|---|------|
| Active Memory Plugin (memory-core/QMD/Honcho) | 召回、语义搜索、晋升、Dreaming、记忆运行时 |
| Memory Wiki | 编译后的 wiki 页面、溯源合成、仪表板、wiki 特有的搜索/获取/应用 |

两者可以联合搜索：`memory_search corpus=all`

## Vault 模式

| 模式 | 说明 | 数据来源 |
|------|------|---------|
| **isolated** | 独立 vault，自有来源 | 自己的内容 |
| **bridge** | 从 Active Memory Plugin 读取公开产物 | 导出的记忆产物、梦境报告、每日笔记、记忆事件 |
| **unsafe-local** | 本地文件系统直接访问 | 实验性，非便携 |

**推荐组合**：QMD (Active Memory 后端) + Memory Wiki (bridge 模式)

## Vault 布局

```
<vault>/
  AGENTS.md           ← Agent 指令
  WIKI.md             ← Wiki 元信息
  index.md            ← 索引页
  inbox.md            ← 收件箱
  entities/           ← 持久事物：人、系统、项目、对象
  concepts/           ← 想法、抽象、模式、策略
  syntheses/          ← 编译摘要、维护的汇总
  sources/            ← 导入的原始材料、bridge 支持的页面
  reports/            ← 生成的仪表板
  _attachments/       ← 附件
  _views/             ← 视图
  .openclaw-wiki/     ← 编译缓存
```

## 结构化 Claims（核心创新）

Wiki 页面不只是自由文本——可以携带**结构化的 Claims（声明）**：

```yaml
claims:
  - id: claim-001
    text: "TypeScript 是团队主要后端语言"
    status: active
    confidence: 0.9
    evidence:
      - sourceId: source-meeting-2026-03
        path: "entities/tech-stack.md"
        weight: 0.8
        note: "CTO 在 3 月会议中确认"
    updatedAt: 2026-03-15
```

每个 Claim 可以：
- 被追踪、评分、质疑
- 链接到证据（source + path + lines）
- 标注 confidence、status
- **追溯到原始来源**

> 这让 Wiki 像一个**信念层（Belief Layer）**而非被动笔记。

## 编译管道

```
Wiki Pages → 标准化摘要 → 机器可读产物
                              ↓
                    .openclaw-wiki/cache/
                    ├── agent-digest.json    ← Agent 消化摘要
                    └── claims.jsonl         ← 所有 Claims
```

编译产物用于：
- Wiki 索引（search/get 首轮查询）
- Claim ID 反查到页面
- 紧凑提示补充
- 仪表板/报告生成

## 仪表板（自动健康报告）

启用 `render.createDashboards` 后自动维护：

| 报告 | 追踪内容 |
|------|---------|
| `reports/open-questions.md` | 未解决的问题 |
| `reports/contradictions.md` | 矛盾的声明集群 |
| `reports/low-confidence.md` | 低置信度页面和声明 |
| `reports/claim-health.md` | 缺少结构化证据的声明 |
| `reports/stale-pages.md` | 过时或新鲜度未知的页面 |

## Wiki 工具

| 工具 | 用途 |
|------|------|
| `wiki_status` | Vault 模式、健康状况、Obsidian CLI 状态 |
| `wiki_search` | 搜索 wiki 页面（可选跨记忆语料库） |
| `wiki_get` | 读取指定 wiki 页面 |
| `wiki_apply` | 窄范围合成/元数据变更（不是自由编辑） |
| `wiki_lint` | 结构检查、溯源缺口、矛盾、未解决问题 |

## Obsidian 集成

设置 `vault.renderMode: "obsidian"` 后：
- 输出 Obsidian 友好的 Markdown
- 可用 Obsidian CLI 打开页面、搜索、执行命令、跳转每日笔记
- **完全可选**，原生模式同样完整可用

## 价值分析

### 解决的核心痛点

**之前**：
- MEMORY.md 是一个扁平的 Markdown 文件 → "一堆笔记"
- 没有溯源：某个记忆条目从哪来的？什么时候记的？
- 没有矛盾检测：记忆 A 说"喜欢 Python"，记忆 B 说"团队转向 TypeScript"
- 没有置信度：所有记忆同等权重
- 没有结构化查询：只能全文搜索

**之后**：
- Wiki 页面有**确定性结构**（entities / concepts / syntheses / sources）
- 每个声明有**证据链**追溯到原始来源
- 自动检测**矛盾**并在仪表板展示
- **置信度评分**让 Agent 知道什么信息可以信赖
- 编译产物让机器高效消费
- 可选 Obsidian 集成 → 人类也能舒适浏览

| 维度 | 之前（纯 MEMORY.md） | 之后（+ Memory Wiki） |
|------|---------------------|---------------------|
| 知识结构 | 扁平 Markdown | 分类页面（entities/concepts/syntheses） |
| 溯源能力 | 无 | 每个 Claim 有 evidence 链 |
| 矛盾检测 | 无 | 自动仪表板 |
| 置信度 | 无（同等权重） | 每个 Claim 有 confidence |
| 过时检测 | 无 | stale-pages 报告 |
| 机器消费 | 读原始 Markdown | 编译 JSON digest |
| 人类浏览 | 文本编辑器 | Obsidian vault |
