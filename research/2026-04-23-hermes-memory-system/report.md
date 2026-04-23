# Hermes Agent 记忆系统深度研究报告

> 研究时间：2026-04-23 | 研究员：黄山（wairesearch）
> 数据时效：截至 2026 年 4 月，Hermes Agent v0.9.0

---

## 执行摘要

Hermes Agent 是 Nous Research 开发的开源自进化 AI Agent 框架（GitHub 90k+ Stars，MIT 协议）。其核心差异化在于**多层记忆系统 + 闭环技能学习**，解决了 AI Agent "失忆"问题。记忆架构分为**三层内建记忆 + 外部记忆提供者插件**，选择了 SQLite FTS5 而非向量数据库作为核心检索方案，是一个务实且高效的设计选择。

---

## 1. Hermes Agent 是什么

| 属性 | 内容 |
|------|------|
| **开发者** | Nous Research（美国开源 AI 研究组织，Hermes 模型系列作者） |
| **仓库** | https://github.com/NousResearch/hermes-agent |
| **官网** | https://hermes-agent.nousresearch.com |
| **Stars** | 90,300+（截至 2026-04） |
| **版本** | v0.9.0（2026-04） |
| **协议** | MIT |
| **定位** | "The agent that grows with you" — 自进化 AI Agent |
| **支持模型** | 200+（Nous Portal、OpenRouter、OpenAI、Anthropic 等） |
| **平台** | Telegram、Discord、Slack、WhatsApp、Signal、Matrix、Email 等 15+ 平台 |
| **部署后端** | Local / Docker / SSH / Daytona / Singularity / Modal |

**核心理念**：传统 Agent 每次对话后遗忘一切；Hermes 通过持久化记忆 + 自动技能提炼，实现经验的累积和复用。

来源：[官方文档](https://hermes-agent.nousresearch.com/docs)，[GitHub README](https://github.com/nousresearch/hermes-agent)

---

## 2. 记忆系统架构总览

Hermes 的记忆系统是**分层 + 可插拔**的设计：

```
┌─────────────────────────────────────────────────────┐
│              Always Active (内建)                     │
│                                                      │
│  Layer 1: 冻结系统提示记忆                             │
│    MEMORY.md (2,200 chars) + USER.md (1,375 chars)  │
│    → 每次会话注入 system prompt                       │
│                                                      │
│  Layer 2: 程序性技能记忆                               │
│    ~/.hermes/skills/*.skill                          │
│    → agentskills.io 开放标准                          │
│                                                      │
│  Layer 3: 会话搜索                                    │
│    SQLite FTS5 全文索引 (~/.hermes/state.db)          │
│    → LLM 摘要化检索结果                               │
└─────────────────────────────────────────────────────┘
                        +
┌─────────────────────────────────────────────────────┐
│         Optional (外部记忆提供者插件，8 选 1)           │
│                                                      │
│  Honcho     — 辩证用户建模 + 语义搜索                  │
│  OpenViking — 分层知识库（字节跳动/火山引擎）            │
│  Mem0       — 自动事实提取 + 语义搜索                   │
│  Hindsight  — 知识图谱 + 实体关系                      │
│  Holographic— 本地 SQLite + HRR 代数查询               │
│  RetainDB   — 未公开详情                               │
│  ByteRover  — 未公开详情                               │
│  Supermemory— 未公开详情                               │
└─────────────────────────────────────────────────────┘
```

### 设计哲学

- **内建记忆永远在线**，外部提供者是加法（additive），不替代
- **冻结快照模式**：记忆在会话开始时注入 system prompt，会话中修改立即写盘但不更新 prompt（保护 LLM prefix cache 性能）
- **容量有限制**：memory 2,200 chars + user 1,375 chars ≈ 总共 ~1,300 tokens。刻意限制，逼迫 Agent 策展高质量记忆

---

## 3. 三层内建记忆详解

### 3.1 Layer 1: 冻结系统提示记忆（MEMORY.md + USER.md）

| 属性 | MEMORY.md | USER.md |
|------|-----------|---------|
| **用途** | Agent 的个人笔记（环境、项目、经验） | 用户画像（偏好、沟通风格） |
| **容量** | 2,200 chars (~800 tokens) | 1,375 chars (~500 tokens) |
| **典型条目数** | 8-15 条 | 5-10 条 |
| **存储位置** | ~/.hermes/memories/ | ~/.hermes/memories/ |
| **管理方式** | Agent 自动策展（add/replace/remove） | Agent 自动策展 |
| **注入时机** | 会话开始时冻结注入 | 会话开始时冻结注入 |

**操作机制**：
- **add**：添加新条目
- **replace**：通过子串匹配替换（无需完整文本，唯一子串即可）
- **remove**：通过子串匹配删除
- **无 read 操作**：记忆已在 system prompt 中，Agent 直接"看到"

**容量管理**：
- 超过 80% 容量时，Agent 主动合并压缩条目
- 满时返回错误，Agent 必须先清理再添加
- 自动去重 + 注入安全扫描（防 prompt injection）

**什么该存/不该存**：
- ✅ 用户偏好、环境事实、项目约定、经验教训、修正纠错
- ❌ 琐碎信息、可搜索的通用知识、大段代码/日志、临时会话信息

来源：[官方 Memory 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory)

### 3.2 Layer 2: 程序性技能记忆（Skills）

技能是 Hermes 最核心的创新 — **将任务执行经验提炼为可复用的代码单元**。

```json
{
  "name": "deploy-to-staging",
  "description": "Deploy current project to staging environment",
  "trigger_patterns": ["deploy to staging", "push to staging"],
  "parameters": {
    "project_path": {"type": "string", "required": true}
  },
  "steps": [
    {"tool": "shell", "command": "docker build -t {project}:{tag} ."},
    {"tool": "shell", "command": "docker push registry/{project}:{tag}"},
    {"tool": "shell", "command": "kubectl rollout restart deployment/{project}"}
  ],
  "success_rate": 0.94,
  "usage_count": 47,
  "last_optimized": "2026-04-10"
}
```

**技能生命周期**：

| 阶段 | 描述 |
|------|------|
| **创建** | Agent 完成复杂任务后，分析执行步骤，抽象为可复用模式，保存为 .skill 文件 |
| **检索** | 新任务到达 → 语义匹配 trigger_patterns → 召回最相关技能 → 注入执行上下文 |
| **优化** | 执行后记录成功/失败 → 更新 success_rate → 必要时重写步骤 |
| **分享** | 通过 agentskills.io 开放标准 → 社区共享 → 跨 Agent 复用 |

**存储**：~/.hermes/skills/，遵循 agentskills.io 标准的 Markdown 文件

来源：[DEV.to 深度分析](https://dev.to/wonderlab/one-open-source-project-a-day-no40-hermes-agent-nous-researchs-self-improving-ai-agent-4ale)

### 3.3 Layer 3: 会话搜索（SQLite FTS5）

```sql
CREATE VIRTUAL TABLE conversation_fts USING fts5(
    content, speaker, timestamp, session_id
);

CREATE TABLE long_term_memory (
    id INTEGER PRIMARY KEY,
    fact TEXT NOT NULL,
    confidence REAL,
    source_session TEXT,
    created_at TIMESTAMP,
    last_reinforced TIMESTAMP
);
```

**检索流程**：
```
过去会话 → FTS5 索引 → 查询触发 → 匹配结果 → LLM 摘要化 → 注入上下文
```

**为什么选 SQLite FTS5 而非向量数据库？**

| 考量 | FTS5 | 向量数据库 |
|------|------|-----------|
| 运维开销 | 零（SQLite 内建） | 需要额外服务（Milvus/Pinecone/Weaviate） |
| 精确匹配 | 优秀（人名、项目名、命令） | 较弱（语义相似但不精确） |
| 语义补偿 | LLM 摘要层补偿 | 原生语义 |
| 部署场景 | 本地/轻量部署友好 | 需要更多资源 |
| 成本 | 免费 | 云服务有成本 |

**Agent 自动 nudge 机制**：Agent 周期性地"提醒自己"，主动将重要信息从会话历史整合到长期记忆。

来源：[官方 Memory 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory)，[DEV.to 分析](https://dev.to/wonderlab)

---

## 4. 外部记忆提供者系统

Hermes 支持 8 个外部记忆提供者插件（同时只能激活一个）：

### 4.1 Honcho（重点 — 辩证用户建模）

Honcho 由 Plastic Labs 开发，是 Hermes 最深度集成的记忆提供者。

**核心机制：两层上下文注入**

```
Base Context（基础层）
  ├── 会话摘要（Session Summary）
  ├── 用户表征（User Representation）
  ├── 用户 Peer Card
  ├── AI 自我表征（AI Self-Representation）
  └── AI Identity Card
  → 按 contextCadence 刷新

Dialectic Supplement（辩证补充层）
  └── LLM 合成推理：用户当前状态 + 需求
  → 按 dialecticCadence 刷新
```

**辩证深度（Multi-Pass）**：

| Pass | 内容 |
|------|------|
| Pass 0 | 冷启动（通用用户事实）或 暖启动（会话上下文） |
| Pass 1 | 自审计 — 识别初始评估的空白并综合近期证据 |
| Pass 2 | 调和 — 检查前几轮推理的矛盾，产出最终综合 |

**三个正交调节旋钮**：

| 旋钮 | 控制 | 默认值 |
|------|------|--------|
| contextCadence | 基础层刷新频率（每 N 轮） | 1 |
| dialecticCadence | 辩证 LLM 调用频率（每 N 轮） | 2 |
| dialecticDepth | 每次辩证调用的推理深度（1-3 pass） | 1 |

**Multi-Peer 架构**：

```
Workspace（共享环境）
  ├── User Peer（用户身份，全局共享）
  ├── AI Peer: hermes（默认 profile）
  ├── AI Peer: coder（代码 profile）
  └── AI Peer: writer（写作 profile）
```

每个 AI Peer 独立构建用户表征，互不污染。编码 profile 保持技术导向，写作 profile 保持编辑导向。

**5 个工具**：honcho_profile / honcho_search / honcho_context / honcho_reasoning / honcho_conclude

来源：[官方 Honcho 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/honcho)

### 4.2 其他提供者速览

| 提供者 | 特色 | 数据存储 | 成本 |
|--------|------|----------|------|
| **OpenViking** | 文件系统式知识层级，分层读取（L0→L1→L2），6 类自动提取 | 自托管 | 免费（AGPL） |
| **Mem0** | 服务端 LLM 事实提取 + 语义搜索 + 自动去重 | Mem0 Cloud | 付费 |
| **Hindsight** | 知识图谱 + 实体消歧 + 多策略检索 + reflect 跨记忆综合 | Cloud 或本地 | Cloud 付费/本地免费 |
| **Holographic** | 本地 SQLite + FTS5 + 信任评分 + HRR 代数查询 | 本地 SQLite | 免费 |
| **RetainDB** | 未公开详细信息 | — | — |
| **ByteRover** | 未公开详细信息 | — | — |
| **Supermemory** | 未公开详细信息 | — | — |

来源：[Memory Providers 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory-providers)

---

## 5. 记忆系统核心数据结构

### 文件系统布局

```
~/.hermes/
├── memories/
│   ├── MEMORY.md          ← Agent 个人笔记（2,200 chars）
│   └── USER.md            ← 用户画像（1,375 chars）
├── skills/                ← 技能文件（.skill, agentskills.io 标准）
├── state.db               ← SQLite 数据库（FTS5 会话索引）
├── memory/                ← 扩展记忆数据
│   ├── sessions/          ← 索引会话历史
│   ├── user_profile.json  ← 辩证用户模型
│   ├── insights.json      ← 综合洞察
│   └── preferences.json   ← 声明偏好
└── config.yaml            ← 配置文件
```

### 会话存储

- **SQLite**（state.db）：所有 CLI 和消息平台会话
- **FTS5 虚拟表**：全文索引，支持关键词搜索
- **LLM 摘要**：使用 Gemini Flash 对搜索结果进行语义摘要

### 记忆条目格式

```
══════════════════════════════════════════════
MEMORY (your personal notes) [67% — 1,474/2,200 chars]
══════════════════════════════════════════════
User's project is a Rust web service at ~/code/myapi using Axum + SQLx
§
This machine runs Ubuntu 22.04, has Docker and Podman installed
§
User prefers concise responses, dislikes verbose explanations
```

- `§` 分隔符分隔条目
- 头部显示使用百分比
- 支持多行条目

---

## 6. 与主流记忆系统对比

| 维度 | Hermes Agent | MemGPT (Letta) | LangChain Memory | LlamaIndex | OpenClaw |
|------|-------------|-----------------|------------------|------------|----------|
| **记忆层级** | 3 层内建 + 8 外部插件 | 2 层（Main/Archival） | 单层（多种 Memory 类型） | 单层（Index + Storage） | 2 层（MEMORY.md + session search） |
| **持久化** | ✅ 文件 + SQLite | ✅ 数据库 | 依赖配置 | ✅ 多种后端 | ✅ 文件 + SQLite |
| **检索方式** | FTS5 + LLM 摘要 | 向量嵌入 | 向量/关键词 | 向量嵌入 | FTS5 + LLM 摘要 |
| **技能学习** | ✅ 自动提炼 + 自优化 | ❌ | ❌ | ❌ | ❌ |
| **用户建模** | ✅ Honcho 12 层辩证 | ❌ | ❌ | ❌ | ❌ |
| **容量管理** | 严格上限 + 自动策展 | 无限（分页管理） | 无限（但无策展） | 无限 | 严格上限 + 自动策展 |
| **上下文管理** | 冻结快照 + 按需搜索 | 虚拟分页（OS 隐喻） | 全量加载或截断 | 按需检索 | 冻结快照 + 按需搜索 |
| **RL 训练集成** | ✅ Atropos | ❌ | ❌ | ❌ | ❌ |
| **多 Agent 隔离** | ✅ Multi-Peer | ❌ | ❌ | ❌ | ✅ Workspace 隔离 |
| **开源** | MIT | Apache 2.0 | MIT | MIT | 部分开源 |

### Hermes 的独特创新点

1. **闭环技能学习**：唯一实现"任务→技能提炼→技能优化→技能共享"完整闭环的 Agent 框架
2. **辩证用户建模**：Honcho 的 12 层身份追踪不仅记住"你说了什么"，还推理"你是怎样思考的"
3. **刻意有限的核心记忆**：2,200+1,375 chars 的硬上限是设计选择，逼迫 Agent 像人类一样策展和压缩记忆
4. **FTS5 而非向量数据库**：务实选择，零运维、精确匹配、LLM 补偿语义
5. **RL 飞轮**：Agent 执行轨迹 → 训练数据 → 更好的模型 → 更好的 Agent，自我强化循环

---

## 7. 实际应用场景与效果

### 适用场景

| 场景 | 说明 |
|------|------|
| **个人 AI 助手** | 长期使用，Agent 越来越了解你的偏好和工作方式 |
| **DevOps 自动化** | 技能积累：部署流程自动提炼为可复用技能 |
| **多平台统一入口** | 在 Telegram 开始任务，在 CLI 继续，Agent 保持上下文 |
| **团队技能共享** | 通过 agentskills.io 标准，团队成员共享 Agent 技能 |
| **AI 研究** | 轨迹数据导出 + Atropos RL 训练，研究 Agent 自进化 |

### 性能特点

- **会话搜索延迟**：FTS5 本地搜索 + LLM 摘要（取决于摘要模型，通常 1-3 秒）
- **记忆注入成本**：固定 ~1,300 tokens/会话（内建记忆），可控
- **Honcho 辩证成本**：可通过 contextCadence/dialecticCadence/dialecticDepth 三旋钮精细控制

### 已知局限性

| 局限 | 分析 |
|------|------|
| **核心记忆容量极小** | 2,200+1,375 chars 对于复杂项目可能不够，依赖外部提供者补充 |
| **FTS5 缺乏语义搜索** | 同义词、概念关联搜索弱于向量数据库，LLM 摘要层是"补丁"而非原生方案 |
| **技能质量无保证** | 自动提炼的技能可能包含错误，success_rate 追踪有助于缓解但不解决 |
| **外部提供者单选** | 同时只能激活一个外部记忆提供者，无法混合使用 |
| **Honcho 依赖外部服务** | 辩证用户建模是最强功能，但需要 Honcho Cloud 或自托管实例 |
| **多语言记忆提取** | GitHub Issue #9135 记录了多语言场景下记忆提取的改进需求 |
| **冻结快照延迟** | 会话中更新的记忆需要下一次会话才生效（为了 prefix cache 性能的权衡） |

---

## 8. 独立判断与洞察

### 架构评价

**Hermes 的记忆系统设计体现了"务实工程"而非"论文驱动"的思路。** FTS5 + LLM 摘要的组合看似"土"，但解决了几个实际痛点：零运维（无需部署向量数据库）、精确匹配（人名/项目名/命令不丢失）、轻量部署（$5 VPS 就能跑）。这是面向个人用户和小团队的正确选择。

**冻结快照模式是一个被低估的优秀设计。** 它牺牲了实时性（记忆更新延迟一个会话），换取了 LLM prefix cache 的性能收益。在高频对话场景中，这个优化非常实际。

**技能学习系统是真正的差异化壁垒。** MemGPT、LangChain、LlamaIndex 都有记忆方案，但没有人做到"任务→技能→自优化→社区共享"的完整闭环。这让 Hermes 不仅"记住"，还"学会"。

### 潜在风险

1. **记忆安全**：虽然有注入扫描，但记忆内容注入 system prompt 本身是一个持续的攻击面
2. **技能漂移**：自动优化的技能可能在某些边界条件下"学偏"，需要人类审核机制
3. **Honcho 锁定**：辩证用户建模是核心功能但依赖外部服务，如果 Honcho 停服或改变定价会受影响

### 对 OpenClaw 的启示

Hermes Agent 的记忆系统与 OpenClaw 有高度相似性（MEMORY.md、FTS5、冻结快照），这不是巧合 — Hermes Agent 官方支持从 OpenClaw 迁移（导入 SOUL.md、MEMORY.md、Skills、API Keys）。核心差异在于：

- Hermes 有**技能自动提炼**（OpenClaw 需手动编写 SKILL.md）
- Hermes 有 **Honcho 辩证用户建模**（OpenClaw 无）
- Hermes 有 **8 个外部记忆提供者**（OpenClaw 有 lossless-claw 等扩展）
- OpenClaw 有 **lossless-claw 无损压缩回忆**（Hermes 无对等方案）

---

## 9. 参考来源

| # | 来源 | URL | 日期 |
|---|------|-----|------|
| 1 | Hermes Agent 官方文档 - Memory | https://hermes-agent.nousresearch.com/docs/user-guide/features/memory | 2026-04 |
| 2 | Hermes Agent 官方文档 - Memory Providers | https://hermes-agent.nousresearch.com/docs/user-guide/features/memory-providers | 2026-04 |
| 3 | Hermes Agent 官方文档 - Honcho | https://hermes-agent.nousresearch.com/docs/user-guide/features/honcho | 2026-04 |
| 4 | GitHub - NousResearch/hermes-agent | https://github.com/nousresearch/hermes-agent | 2026-04-22 |
| 5 | DEV.to - One Open Source Project a Day (No.40) | https://dev.to/wonderlab/one-open-source-project-a-day-no40-hermes-agent-nous-researchs-self-improving-ai-agent-4ale | 2026-04-16 |
| 6 | MarkTechPost - Hermes Agent Release | https://www.marktechpost.com/2026/02/26/nous-research-releases-hermes-agent/ | 2026-02-26 |
| 7 | Vectorize.io - How Hermes Agent Memory Works | https://vectorize.io/articles/hermes-agent-memory-explained | 2026-04 |
| 8 | CrabTalk - Hermes Memory Five Layers | https://openwalrus.xyz/blog/hermes-memory-system | 2026-03-15 |
| 9 | GitHub Issue #9135 - Multilingual Memory | https://github.com/NousResearch/hermes-agent/issues/9135 | 2026-04 |
| 10 | hermes-agent.ai - 3-Layer System Explained | https://hermes-agent.ai/blog/hermes-agent-memory-system | 2026-04 |

---

*报告完成。所有结论基于官方文档和多源交叉验证。标注"未公开"的提供者（RetainDB、ByteRover、Supermemory）截至研究时间尚无公开详细文档。*
