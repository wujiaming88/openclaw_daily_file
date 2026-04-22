# Hermes Agent 自动 Skill 创建机制深度研究报告

> **研究员**: 黄山 (wairesearch)  
> **日期**: 2026-04-22  
> **版本**: v1.0  
> **研究对象**: Hermes Agent by Nous Research  
> **GitHub**: https://github.com/NousResearch/hermes-agent  
> **官方文档**: https://hermes-agent.nousresearch.com/docs/

---

## 执行摘要

Hermes Agent 是 Nous Research 于 2026 年 2 月 25 日开源的 AI Agent 框架（MIT 协议），7 周内积累了 95,600 GitHub Stars（截至 2026 年 4 月中旬，来源：DEV.to 评测）。其核心差异化能力是**闭环学习系统**：Agent 在完成复杂任务后自动将工作流提取为可复用的 Skill 文件，后续使用中持续精炼，并通过周期性自省机制（每 10-15 个 turn/task）主动审视是否需要保存记忆或创建新 Skill。

本报告对其自动 Skill 创建机制进行源码级深度分析，覆盖触发条件、创建流程、记忆架构、Self-Evolution 系统，并与 OpenClaw 进行对比。

---

## 目录

1. [自动 Skill 创建的完整机制](#1-自动-skill-创建的完整机制)
2. [Skill 自我改进机制](#2-skill-自我改进机制)
3. [三层记忆架构](#3-三层记忆架构)
4. [Self-Evolution（DSPy + GEPA）](#4-self-evolutiondspy--gepa)
5. [源码级分析](#5-源码级分析)
6. [与 OpenClaw 的深度对比](#6-与-openclaw-的深度对比)
7. [实测数据和社区反馈](#7-实测数据和社区反馈)
8. [对我们的启示和可借鉴方向](#8-对我们的启示和可借鉴方向)

---

## 1. 自动 Skill 创建的完整机制

### 1.1 核心定位：程序性记忆

Hermes Agent 将 Skill 定义为 **Agent 的程序性记忆（Procedural Memory）**——区别于 MEMORY.md/USER.md 的陈述性记忆（Declarative Memory）。官方文档原文：

> *"Skills are the agent's procedural memory — when it figures out a non-trivial workflow, it saves the approach as a skill for future reuse."*
> — Skills System 文档

这一设计哲学的核心洞察是：**Agent 应该记住"怎么做"而不仅仅是"知道什么"**。成功的工作流被转化为可复用的程序，在下次遇到类似问题时直接加载执行。

### 1.2 触发条件

根据官方文档和社区评测，Skill 创建在以下场景触发：

| 触发条件 | 来源 |
|----------|------|
| 完成一个涉及 **5+ 次工具调用** 的复杂任务 | 官方 Skills 文档 |
| 执行过程中遇到错误/死胡同后找到正确路径 | 官方 Skills 文档 |
| 用户纠正了 Agent 的做法 | 官方 Skills 文档 |
| Agent 发现了一个非显而易见的工作流 | 官方 Skills 文档 |
| 用户主动要求创建 Skill | BetterStack 实测 |

**关键发现：5 次工具调用阈值**。这不是一个硬编码的自动触发器——Hermes 的 Skill 创建主要通过两个机制实现：

1. **System Prompt 中的行为指令**：系统提示告诉 LLM 在完成复杂任务后应该创建 Skill
2. **Periodic Nudge（周期性自省）**：每隔 10-15 个 turn，在对话中注入提醒，让 Agent 审视是否需要保存记忆或创建 Skill

> **重要洞察**：这不是传统意义上的"代码触发"，而是**通过 prompt engineering 引导 LLM 自主决策是否创建 Skill**。Agent 本身并没有一个硬编码的 `if tool_calls >= 5: create_skill()` 逻辑——而是在 system prompt 中给出指导原则，由 LLM 判断何时该调用 `skill_manage(action='create')` 工具。

### 1.3 创建流程（完整链路）

```
用户任务 → Agent Loop 执行 → 多次工具调用完成任务
                                    ↓
                        LLM 判断是否值得保存为 Skill
                        （基于 system prompt 中的指导原则）
                                    ↓
                        调用 skill_manage(action='create')
                                    ↓
                        skill_manager_tool.py 执行：
                          1. 验证 name（a-z0-9, 小写, ≤64字符）
                          2. 验证 YAML frontmatter（必须包含 name + description）
                          3. 验证内容大小（≤100,000 字符 ≈ 36k tokens）
                          4. 检查名称冲突（跨所有 skill 目录）
                          5. 创建目录 ~/.hermes/skills/[category/]name/
                          6. 原子写入 SKILL.md（tempfile + os.replace）
                          7. 安全扫描（skills_guard 检查注入/外泄模式）
                          8. 扫描失败则回滚（shutil.rmtree）
                                    ↓
                        Skill 可用：自动出现在 system prompt 索引中
                        可作为 /skill-name 斜杠命令使用
```

### 1.4 skill_manage 工具的完整 API

基于源码分析（`tools/skill_manager_tool.py`，795 行，28.5 KB）：

| Action | 用途 | 关键参数 |
|--------|------|----------|
| `create` | 从零创建新 Skill | `name`, `content`（完整 SKILL.md）, 可选 `category` |
| `edit` | 完全重写 SKILL.md | `name`, `content`（完整替换） |
| `patch` | 精确查找替换（**首选**） | `name`, `old_string`, `new_string`, 可选 `file_path`, `replace_all` |
| `delete` | 删除整个 Skill | `name` |
| `write_file` | 添加/覆盖辅助文件 | `name`, `file_path`, `file_content` |
| `remove_file` | 删除辅助文件 | `name`, `file_path` |

**设计哲学要点**：

- **patch 优先于 edit**：官方文档明确说明 patch 更 token 高效，因为只传输变更部分
- **原子写入**：所有写操作使用 `tempfile + os.replace()` 确保不会出现半写状态
- **安全扫描**：每次写入后都会运行 `skills_guard` 安全扫描，检测 prompt injection、数据外泄、破坏性命令等模式。Agent 创建的 Skill 与社区 Hub 安装的 Skill 接受**相同的安全审查**
- **fuzzy matching**：patch 操作使用 `tools/fuzzy_match.py` 的模糊匹配引擎，处理空白标准化和缩进差异

### 1.5 生成的 Skill 格式与存储

```
~/.hermes/skills/                    # 单一真实来源（Single Source of Truth）
├── social-media/                    # 类别目录（可选）
│   └── video-to-tweet/              # Agent 创建的 Skill
│       ├── SKILL.md                 # 主指令（必需）
│       ├── references/              # 参考文档
│       ├── templates/               # 输出模板
│       ├── scripts/                 # 辅助脚本
│       └── assets/                  # 补充文件
└── deploy-k8s/                      # 无类别的 Skill
    └── SKILL.md
```

**SKILL.md 格式要求**（源码验证）：

```yaml
---
name: my-skill                       # 必需，小写字母+数字+连字符
description: Brief description       # 必需，≤1024 字符
version: 1.0.0
metadata:
  hermes:
    tags: [category, keywords]
    category: devops
---

# Skill Title

## When to Use
触发条件

## Procedure
1. 步骤一
2. 步骤二

## Pitfalls
- 已知失败模式和修复方法

## Verification
确认成功的方法
```

### 1.6 Pattern Extraction 的实现机制

**关键发现：Hermes 的 Pattern Extraction 不是一个独立的代码模块，而是完全由 LLM 在运行时完成的。**

具体来说：
1. Agent 完成一个复杂任务后，LLM 基于其上下文中的完整执行轨迹（tool calls、结果、错误、修正）
2. System prompt 中的指导原则告诉 LLM："当你完成了一个复杂任务，应该将方法提取为 Skill"
3. LLM 自行决定提取哪些模式、如何组织 SKILL.md 的内容
4. 通过调用 `skill_manage(action='create')` 将提取的模式持久化

这意味着 Pattern Extraction 的质量**完全取决于底层 LLM 的能力**。使用 Claude Opus 4.6 创建的 Skill 质量会显著高于使用 Qwen3 创建的。

### 1.7 Progressive Disclosure（渐进式加载）

Skill 使用一个 token 高效的三级加载模式：

| 级别 | API 调用 | 返回内容 | Token 消耗 |
|------|---------|---------|-----------|
| Level 0 | `skills_list()` | `[{name, description, category}, ...]` | ~3k tokens（所有 Skill 的摘要） |
| Level 1 | `skill_view(name)` | 完整 SKILL.md 内容 + 元数据 | 变化 |
| Level 2 | `skill_view(name, path)` | 特定参考文件 | 变化 |

这意味着 Agent **只在实际需要时才加载完整 Skill 内容**，Level 0 的索引始终注入 system prompt，但完整内容按需加载。

---

## 2. Skill 自我改进机制

### 2.1 Patch vs Edit：精细化更新

Hermes 的 Skill 改进不是"删掉重建"，而是精细化更新：

- **patch**（首选）：使用 fuzzy find-and-replace，只修改需要变更的部分。Token 成本低，保留 Skill 的整体结构
- **edit**：完全重写 SKILL.md。用于重大结构重组
- **write_file**：添加新的参考文件、模板或脚本，丰富 Skill 的辅助材料

**自我改进的实际流程**（基于 BetterStack 实测文章）：

```
第1次使用 Skill → 发现边缘情况未覆盖
    → LLM 判断需要更新
    → 调用 skill_manage(action='patch')
    → 添加新的边缘情况处理步骤

第2次使用 → 用户反馈某个步骤不够好
    → LLM 根据反馈调用 patch
    → 修改该步骤的指令

第N次使用 → Skill 越来越精确和完善
```

### 2.2 Periodic Nudge 机制

这是 Hermes 学习闭环的关键机制之一：

- **频率**：根据不同来源，为每 **10 个 turn**（BetterStack 实测）或每 **15 个 task**（LushBinary 开发者指南）
- **机制**：在 Agent Loop 中，当 turn 计数达到阈值时，在用户消息中注入一条额外的提示（ephemeral prompt layer），让 Agent 审视：
  1. 最近的对话中是否有值得保存到 MEMORY.md 的信息？
  2. 是否有可以创建为新 Skill 的工作流模式？
  3. 现有 Skill 是否需要更新？

BetterStack 原文描述：

> *"Every 10 turns, Hermes runs an internal review of the recent conversation and asks whether anything should be saved to persistent memory or automated into a new skill. This is what drives the self-improvement behavior: the agent suggests saving preferences and creating skills without being asked."*

**技术实现推测**（基于架构文档中的 ephemeral prompt layer 描述）：

这些 nudge 是作为 **API-call-time-only layers** 注入的，不会修改缓存的 system prompt，从而不影响 prompt caching 效率。它们在特定 turn 被临时添加到 API 请求中，然后丢弃。

### 2.3 缓存感知设计

Hermes 采用 **Frozen Snapshot Pattern（冻结快照模式）**：

```
Session 开始 → 加载 MEMORY.md + USER.md + Skills 索引
            → 冻结为 System Prompt 的一部分
            → 整个 Session 期间不改变

Session 中 → Agent 调用 memory/skill_manage 写入新数据
          → 立即持久化到磁盘
          → 但 System Prompt 中的快照 **不更新**
          → 直到下一个 Session 才生效
```

**为什么这么设计？**

- **Prompt Caching**：Anthropic 和 OpenAI 的 API 对稳定的 system prompt 前缀提供缓存优惠。如果每次 memory write 都修改 system prompt，就会破坏缓存，大幅增加 token 成本
- **一致性**：避免 session 中途 system prompt 变化导致 LLM 行为不一致
- **性能**：冻结快照意味着高频 API 调用可以复用缓存的上下文

这是一个精妙的工程决策——**学习不会持续增加你的 token 账单**。

---

## 3. 三层记忆架构

### 3.1 架构总览

| 层级 | 存储 | 容量 | 用途 | 检索速度 |
|------|------|------|------|---------|
| **Session Context** | 内存（对话历史） | 模型上下文窗口 | 当前对话工作记忆 | 即时 |
| **Persistent Store** | SQLite + FTS5 + 文件 | 无限 | Skills、Session 历史、记忆 | <10ms（来源：DEV.to 评测） |
| **User Model** | Honcho / 插件系统 | 依赖配置 | 用户画像、偏好漂移跟踪 | 依赖配置 |

### 3.2 层级详解

#### Layer 1: Session Context（会话上下文）

- 标准的对话历史，使用 OpenAI 兼容的消息格式
- 当超过 50% 上下文窗口时触发压缩
- 压缩策略：保留最新 N 条消息（默认 20 条），中间部分摘要化
- 所有 session 完整保存到 SQLite 数据库

#### Layer 2: Persistent Store（持久存储）

**MEMORY.md**（Agent 笔记）：
- 容量：2,200 字符 ≈ 800 tokens
- 内容：环境信息、项目约定、工具技巧、完成的任务记录
- 管理：Agent 通过 `memory` 工具自动管理（add/replace/remove）

**USER.md**（用户画像）：
- 容量：1,375 字符 ≈ 500 tokens
- 内容：用户姓名、角色、时区、沟通偏好、技术水平
- 管理：同上

**SQLite + FTS5 Session Search**：
- 所有 CLI 和消息平台的 session 存储在 `~/.hermes/state.db`
- 使用 FTS5 全文搜索索引
- Agent 通过 `session_search` 工具检索过去的对话
- 支持 Gemini Flash 摘要化，从历史对话中提取相关信息

**容量管理的优雅设计**：
- 当 MEMORY 超过 80% 时，Agent 会主动合并相关条目
- 如果添加新条目会超限，工具返回错误并展示当前所有条目，让 Agent 决定淘汰哪些
- 自动去重：精确重复的条目被静默拒绝
- 安全扫描：所有记忆条目在接受前会被扫描 injection 和 exfiltration 模式

#### Layer 3: User Model（用户模型）

Hermes 通过插件系统支持 8 个外部记忆提供商，其中最核心的是 **Honcho**。

### 3.3 Honcho Dialectic User Modeling

Honcho（由 Plastic Labs 开发）是一个 AI 原生的跨 session 用户建模系统：

**核心概念：辩证推理（Dialectic Reasoning）**

Honcho 不是简单地存储用户偏好的 key-value 对，而是通过 **peer-to-peer 辩证模型** 建立用户理解：

- **User Peer**：代表人类用户，跨 profile 共享
- **AI Peer**：代表 AI Agent，每个 Hermes Profile 独立
- **Workspace**：共享环境，所有 Profile 共用
- **Observation**：每个 peer 可以独立配置是否观察自己和对方的消息

**两层上下文注入**：

1. **Base Layer**（基础层）：session 摘要 + 用户表征 + peer card，按 `contextCadence` 刷新
2. **Dialectic Supplement**（辩证补充）：LLM 推理结果，按 `dialecticCadence` 刷新

**三个独立控制旋钮**：

| 旋钮 | 控制 | 默认值 |
|------|------|--------|
| `contextCadence` | 基础层 API 调用频率 | 1（每 turn） |
| `dialecticCadence` | 辩证 LLM 调用频率 | 2（每 2 turn） |
| `dialecticDepth` | 每次辩证的 `.chat()` 轮数 | 1（1-3） |

**漂移调节**（Drift-Adjusting）：用户模型不会锁定早期假设，而是根据用户行为变化主动更新。这与简单的偏好存储有本质区别——它模拟的是对用户的"理解"，而非"记录"。

### 3.4 程序性记忆 vs 陈述性记忆

| 维度 | 陈述性记忆（MEMORY.md/USER.md） | 程序性记忆（Skills） |
|------|-------------------------------|---------------------|
| 存什么 | 事实、偏好、环境信息 | 工作流程、方法论、操作步骤 |
| 怎么用 | 每次 session 自动注入 system prompt | 按需加载（Progressive Disclosure） |
| 容量 | 严格限制（~1,300 tokens 总计） | 实际无限（每个 Skill 最大 100K 字符） |
| 更新方式 | add/replace/remove 原子操作 | patch/edit/write_file |
| 类比 | "知道北京是中国首都" | "知道怎么从机场到酒店" |

---

## 4. Self-Evolution（DSPy + GEPA）

### 4.1 hermes-agent-self-evolution 仓库概述

- **仓库**: https://github.com/NousResearch/hermes-agent-self-evolution
- **许可**: MIT
- **定位**: 离线进化优化工具，不是在线运行时组件
- **成本**: ~$2-10 每次优化运行（纯 API 调用）
- **无需 GPU**

### 4.2 GEPA：Genetic-Pareto Prompt Evolution

GEPA 是一个来自 ICLR 2026 Oral 论文的算法（MIT 授权），核心思路：

```
读取当前 Skill/Prompt/Tool → 生成评估数据集
        │
        ▼
   GEPA 优化器 ◄── 执行轨迹
        │         ▲
        ▼         │
   候选变体 ──► 评估
        │
   约束门控（测试、大小限制、benchmark）
        │
        ▼
   最佳变体 ──► PR against hermes-agent
```

**GEPA 的核心创新**：它不仅检测"失败了"，还会**读取执行轨迹来理解"为什么失败"**，然后提出针对性的改进。这类似于遗传算法中的变异，但变异是基于 LLM 的反思推理而非随机。

### 4.3 评估数据源

```bash
# 使用合成数据（从当前 Skill 生成测试场景）
python -m evolution.skills.evolve_skill \
    --skill github-code-review \
    --iterations 10 \
    --eval-source synthetic

# 使用真实 session 历史（来自 Claude Code、Copilot 和 Hermes）
python -m evolution.skills.evolve_skill \
    --skill github-code-review \
    --iterations 10 \
    --eval-source sessiondb
```

### 4.4 约束门控机制

每个进化的变体必须通过：

| 约束 | 要求 |
|------|------|
| 完整测试套件 | `pytest tests/ -q` 100% 通过 |
| 大小限制 | Skills ≤15KB，Tool 描述 ≤500 字符 |
| 缓存兼容性 | 不能导致 session 中途变化 |
| 语义保留 | 不能偏离原始目的 |
| PR 审查 | 所有变更通过人工审查，**永远不直接提交** |

### 4.5 各阶段进展状态

| 阶段 | 目标 | 引擎 | 状态 |
|------|------|------|------|
| Phase 1 | Skill 文件（SKILL.md） | DSPy + GEPA | ✅ 已实现 |
| Phase 2 | Tool 描述 | DSPy + GEPA | 🔲 计划中 |
| Phase 3 | System Prompt 段落 | DSPy + GEPA | 🔲 计划中 |
| Phase 4 | Tool 实现代码 | Darwinian Evolver | 🔲 计划中 |
| Phase 5 | 持续改进循环 | 自动化管道 | 🔲 计划中 |

**关键判断**：目前只有 Phase 1 完成。这意味着 Self-Evolution 在当前阶段主要是一个**Skill 优化工具**，而非一个完整的自进化系统。Phase 4 使用的 Darwinian Evolver 来自 Imbue AI，采用 AGPL v3 许可（仅作为外部 CLI 调用）。

---

## 5. 源码级分析

### 5.1 skill_manager_tool.py 核心实现

**文件位置**: `tools/skill_manager_tool.py`  
**规模**: 795 行, 28.5 KB  
**来源**: GitHub Raw（2026-04-22 验证）

关键实现细节：

```python
# 常量
MAX_NAME_LENGTH = 64
MAX_DESCRIPTION_LENGTH = 1024
MAX_SKILL_CONTENT_CHARS = 100_000   # ~36k tokens at 2.75 chars/token
MAX_SKILL_FILE_BYTES = 1_048_576    # 1 MiB per supporting file
VALID_NAME_RE = re.compile(r'^[a-z0-9][a-z0-9._-]*$')
ALLOWED_SUBDIRS = {"references", "templates", "scripts", "assets"}
```

**安全设计亮点**：

1. **Agent 创建的 Skill 与 Hub 安装的 Skill 接受相同安全扫描**：
   ```python
   from tools.skills_guard import scan_skill, should_allow_install, format_scan_report
   ```

2. **三级安全判定**：
   - `allowed = True`：通过
   - `allowed = False`：阻止并报告
   - `allowed = None`（"ask" 判定）：对 Agent 创建的 Skill，同样阻止

3. **原子写入**：使用 tempfile + os.replace() 确保写入原子性

4. **路径安全**：使用 `tools/path_security` 的 `has_traversal_component` 和 `validate_within_dir` 防止路径遍历

5. **外部目录只读**：通过 `skills.external_dirs` 配置的外部 Skill 目录对 Agent 是只读的，Agent 只能修改 `~/.hermes/skills/` 下的 Skill

### 5.2 Agent Loop 中 Skill 创建触发逻辑

基于 `run_agent.py`（~10,700 行）的源码片段和架构文档：

```python
# run_agent.py 中检查 skill 工具可用性
has_skills_tools = any(name in self.valid_tool_names 
                       for name in ['skills_list', 'skill_view', 'skill_manage'])
```

**技术事实**：`skill_manage` 是一个注册在 `tools/registry.py` 中的标准工具。Agent Loop 本身**不包含显式的 Skill 创建触发逻辑**——触发完全由 LLM 基于 system prompt 中的行为指令自主决策。

这意味着：
- **触发的可靠性取决于 LLM 的指令遵循能力**
- 强模型（Claude Opus、GPT-5）会更可靠地遵循 Skill 创建提示
- 弱模型可能忽略这些提示

### 5.3 System Prompt 中的 Skill 创建指令

基于 Prompt Assembly 文档，skill 相关的 system prompt 层级：

**Layer 2: Tool-aware behavior guidance** 中包含：
> *"You have persistent memory across sessions. Save durable facts using the memory tool..."*

**Layer 7: Skills index** 中包含：
> *"Before replying, scan the skills below. If one clearly matches your task, load it with skill_view(name) and follow its instructions."*

具体的 Skill 创建提示文本（从 BetterStack 和 blakecrosley.com 交叉验证）嵌入在 system prompt 的 tool-aware guidance 部分，指导 Agent：
- 完成复杂任务后考虑创建 Skill
- 发现错误后修正并保存为 Skill
- 被用户纠正后将正确方法保存为 Skill

### 5.4 关键源码文件映射

| 文件 | 职责 | 规模 |
|------|------|------|
| `run_agent.py` | Agent Loop，核心对话循环 | ~10,700 行 |
| `tools/skill_manager_tool.py` | skill_manage 工具实现 | 795 行 |
| `agent/prompt_builder.py` | System Prompt 组装 | 未公开行数 |
| `agent/skill_commands.py` | Skill 斜杠命令 | 未公开行数 |
| `agent/memory_manager.py` | 记忆管理编排 | 未公开行数 |
| `tools/skills_guard.py` | Skill 安全扫描 | 未公开行数 |
| `hermes_state.py` | SQLite 状态数据库 + FTS5 | 未公开行数 |
| `hermes_cli/skills_hub.py` | /skills 斜杠命令 | 未公开行数 |
| `hermes_cli/skills_config.py` | Skill 启用/禁用配置 | 未公开行数 |

---

## 6. 与 OpenClaw 的深度对比

### 6.1 Skill 生命周期对比

| 维度 | Hermes Agent | OpenClaw |
|------|-------------|---------|
| **创建方式** | Agent 自动创建 + 手动编写 + Hub 安装 | 手动编写 + ClawHub 市场安装 |
| **自动创建** | ✅ 核心特性，LLM 驱动 | ❌ 不支持自动创建 |
| **自我改进** | ✅ patch/edit 精细更新 | ❌ 手动维护 |
| **发现方式** | Progressive Disclosure（L0/L1/L2） | 类似（description → SKILL.md → references） |
| **使用方式** | 斜杠命令 + 自然对话 | 斜杠命令 + 自然对话 |
| **分享方式** | Skills Hub（多源：GitHub, skills.sh, well-known） | ClawHub 市场 |
| **格式标准** | agentskills.io 开放标准 | 自有格式（类似） |
| **存储位置** | `~/.hermes/skills/` | `~/.openclaw/skills/` |
| **外部目录** | ✅ `skills.external_dirs` | ✅ 类似机制 |

### 6.2 记忆架构对比

| 维度 | Hermes Agent | OpenClaw |
|------|-------------|---------|
| **持久记忆** | MEMORY.md (2,200 chars) + USER.md (1,375 chars) | MEMORY.md（类似） |
| **Session 搜索** | SQLite FTS5 + LLM 摘要 | lossless-claw（DAG 压缩 + 搜索） |
| **用户建模** | Honcho dialectic + 7 个其他插件 | 无专门用户建模 |
| **容量管理** | 严格字符限制 + 自动合并 | 类似 |
| **冻结快照** | ✅ Session 开始冻结，不中途修改 | ✅ 类似模式 |
| **外部提供商** | 8 个插件（Honcho, Mem0, OpenViking 等） | 无内置插件系统 |

### 6.3 安全模型对比

| 维度 | Hermes Agent | OpenClaw |
|------|-------------|---------|
| **Skill 来源** | 本地 Agent 生成 + Hub 安装 | 社区市场（ClawHub）+ 手动 |
| **安全扫描** | 所有 Skill（包括 Agent 生成的）都经过安全扫描 | 依赖市场审核 |
| **信任等级** | builtin > official > trusted > community | 类似分层 |
| **供应链风险** | 低（本地生成为主） | 较高（DEV.to 报告：ClawHub 824 个恶意包，约 20%） |
| **CVE 记录** | 0 个（截至 2026-04-22） | 未详细统计 |

> **DEV.to 评测原文**：*"ClawHub's community marketplace was found to contain approximately 824 malicious packages in an April 2026 audit, roughly 20% of the catalog. Hermes has zero agent-specific CVEs to date."*
> 
> **注意**：此数据来源于 DEV.to 社区评测（jangwook_kim），需要独立验证。这是一个重要但可能有偏见的数据点。

### 6.4 各自的优势和劣势

**Hermes Agent 优势**：
1. ✅ 真正的自动 Skill 创建——Agent 从经验中学习
2. ✅ 闭环学习：创建 → 使用 → 改进 → 积累
3. ✅ 安全模型更强：本地生成减少供应链风险
4. ✅ 丰富的记忆插件生态（8 个提供商）
5. ✅ Periodic Nudge 机制驱动主动学习
6. ✅ Self-Evolution 离线优化框架

**Hermes Agent 劣势**：
1. ❌ 仍在 v0.x，API 稳定性无保证
2. ❌ 无社区 Skill 市场（只有 118 个内置 Skill）
3. ❌ 自动创建的质量取决于 LLM 能力
4. ❌ 跨领域泛化有限——Skill 是领域特定的
5. ❌ 高端模型使用成本高（Claude Opus 4.6 ~$131/天重度使用）

**OpenClaw 优势**：
1. ✅ 更成熟稳定（345,000+ Stars，生态更广）
2. ✅ 24+ 消息平台集成
3. ✅ 13,000+ 社区 Skill 市场
4. ✅ 更广泛的社区和生态

**OpenClaw 劣势**：
1. ❌ 不支持自动 Skill 创建
2. ❌ 无用户建模系统
3. ❌ 市场 Skill 的安全审核挑战
4. ❌ 无自进化机制

---

## 7. 实测数据和社区反馈

### 7.1 官方 Benchmark 数据

来源：DEV.to 评测（交叉引用官方宣称）

| 指标 | 数据 | 来源 |
|------|------|------|
| 累积 20+ 自创建 Skill 后，研究任务完成速度 | 提升 40% | Nous Research 官方 benchmark（经 DEV.to 引用） |
| 10,000+ Skill 文档检索延迟 | <10ms | DEV.to 评测 |
| Agent 特定 CVE | 0 | DEV.to 评测（截至 2026-04-22） |
| GitHub Stars（7 周内） | 95,600 | DEV.to 评测 |
| 内置 Skill 数量（v0.10.0） | 118 个 | DEV.to 评测 |
| 内置工具数量 | 47 个（19 个 toolset） | 官方架构文档 |
| 支持的消息平台 | 18 个 | 官方架构文档 |
| 测试套件 | 3,000+ 测试 | 官方架构文档 |
| GitHub Issues | ~2,200 | GitHub 页面（2026-04-22） |
| Pull Requests | ~4,000 | GitHub 页面（2026-04-22） |

### 7.2 社区评分

DEV.to 评分（jangwook_kim，10 分制）：

| 维度 | 得分 |
|------|------|
| Learning Loop | 9.5 |
| Memory System | 9.0 |
| Developer Experience | 8.0 |
| Ecosystem | 7.5 |
| Stability | 6.5 |
| **综合** | **8.1** |

### 7.3 社区反馈关键观点

**积极评价**：
- "真正的 compounding improvement"——使用越久效果越好
- SQLite 方案"故意无聊但极其实用"——避免了向量数据库的冷启动问题
- 本地 Skill 生成避免供应链攻击
- 支持 200+ LLM 提供商，无锁定

**批评/顾虑**：
- v0.x 稳定性不足——API 在次版本之间可能 breaking
- 无社区市场意味着初始 Skill 库较薄
- 前沿模型成本高（Claude Opus 4.6 重度使用 ~$131/天）
- 自我改进是领域特定的，跨任务泛化有限
- 短期试用无法体现核心价值——需要持续使用

### 7.4 成本参考数据

| 使用模式 | 模型 | 预估月费 |
|----------|------|---------|
| 轻度（1-2 小时/天） | Qwen3 / DeepSeek | $15-30 |
| 中度（4-6 小时/天） | Claude Sonnet 4.6 | $60-120 |
| 重度（8+ 小时/天） | Claude Sonnet 4.6 | $150-300 |
| VPS 托管 | 任意 | +$5-10 |

来源：DEV.to 评测

---

## 8. 对我们的启示和可借鉴方向

### 8.1 核心理念可移植清单

| 理念 | 可借鉴性 | 实现难度 | 优先级建议 |
|------|---------|---------|-----------|
| **自动 Skill 创建** | ⭐⭐⭐⭐⭐ 核心差异化 | 中等（主要是 prompt engineering） | 🔴 高 |
| **Periodic Nudge** | ⭐⭐⭐⭐ 驱动主动学习 | 低（ephemeral prompt injection） | 🔴 高 |
| **Frozen Snapshot** | ⭐⭐⭐⭐ 节省 token 成本 | 低（OpenClaw 可能已有类似设计） | 🟡 中 |
| **Progressive Disclosure** | ⭐⭐⭐⭐ token 效率 | 低 | 🟡 中 |
| **程序性记忆概念** | ⭐⭐⭐⭐⭐ 哲学基础 | N/A（概念层面） | 🔴 高 |
| **Honcho 用户建模** | ⭐⭐⭐ 差异化 | 高（需要集成外部系统） | 🟢 低 |
| **Self-Evolution (GEPA)** | ⭐⭐⭐ 长期价值 | 高 | 🟢 低 |
| **安全扫描** | ⭐⭐⭐⭐ 基础设施 | 中 | 🟡 中 |

### 8.2 具体实现方案建议

#### 方案 A：OpenClaw 自动 Skill 创建（最高优先级）

**核心思路**：在 OpenClaw 的 system prompt 中添加 Skill 创建的行为指导，让 Agent 在完成复杂任务后自动创建 Skill。

**实现步骤**：

1. **System Prompt 增强**：在 SOUL.md 或 system prompt 中添加类似指导：
   ```
   After completing a task that involved 5+ tool calls, or when you discovered
   a non-trivial workflow, consider saving it as a reusable skill using the
   skill creation tool. Skills are your procedural memory.
   ```

2. **提供 Skill 创建工具**：实现类似 `skill_manage` 的工具，支持 create/patch/edit/delete

3. **Periodic Nudge**：每隔 N 个 turn，在 API 调用中临时注入提醒

4. **安全扫描**：对 Agent 创建的 Skill 进行安全扫描

**关键设计决策**：
- 与 Hermes 相同，**不需要**硬编码触发逻辑——完全依赖 LLM 的判断
- 使用 atomic write 确保文件安全
- 对 Agent 创建的 Skill 与用户安装的 Skill 使用相同安全标准

#### 方案 B：Periodic Nudge 机制（高优先级）

**实现**：在 Agent Loop 中添加 turn 计数器，当达到阈值（建议 10-15 turn）时，在下一次 API 调用的 user message 中注入：

```
[System Nudge] You've completed several tasks in this session. Consider:
1. Is there anything worth saving to persistent memory?
2. Did you discover a reusable workflow that should become a skill?
3. Do any existing skills need updating based on what you learned?
```

**关键点**：作为 ephemeral layer 注入，不修改 system prompt，不影响缓存。

#### 方案 C：Progressive Disclosure 优化（中优先级）

OpenClaw 可能已有类似设计。核心是确保 Skill 索引在 system prompt 中只占 ~3K tokens，完整内容按需加载。

### 8.3 风险评估

| 风险 | 概率 | 影响 | 缓解 |
|------|------|------|------|
| LLM 创建的 Skill 质量不稳定 | 高 | 中 | 要求使用强模型进行 Skill 创建；提供 Skill 模板 |
| Agent 过度创建低质量 Skill | 中 | 低 | 设置 Skill 数量上限；用户确认机制 |
| 安全扫描遗漏 | 低 | 高 | 多层安全检查；Agent 创建的 Skill 默认权限受限 |
| Token 成本增加 | 中 | 中 | Frozen Snapshot + Progressive Disclosure |

### 8.4 最终判断

Hermes Agent 的自动 Skill 创建机制是一个**优雅但简单**的设计：

1. 它**不是**复杂的机器学习管道，而是巧妙的 **prompt engineering + 工具设计**
2. 核心创新是**给 LLM 一个 "skill_manage" 工具和清晰的行为指导**——让 LLM 自己决定何时、如何创建 Skill
3. **Periodic Nudge** 是确保 Agent 不忘记学习的关键催化剂
4. **安全扫描** 和 **原子写入** 是必要的工程保障
5. **Self-Evolution (GEPA)** 是更长远的愿景，目前只完成了 Phase 1

**对 OpenClaw 的最大启示**：自动 Skill 创建的门槛没有想象的那么高。核心不在于算法创新，而在于 **系统设计的完整性**——prompt 指导 + 工具 API + 安全防护 + 缓存友好 + 渐进加载，这些模块协同工作形成闭环。

---

## 参考来源

1. [Hermes Agent Skills System 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/skills) — 官方文档，2026-04-22 访问
2. [Hermes Agent Persistent Memory 文档](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory) — 官方文档
3. [Creating Skills 开发者指南](https://hermes-agent.nousresearch.com/docs/developer-guide/creating-skills) — 官方文档
4. [Architecture 文档](https://hermes-agent.nousresearch.com/docs/developer-guide/architecture) — 官方文档
5. [Agent Loop Internals](https://hermes-agent.nousresearch.com/docs/developer-guide/agent-loop) — 官方文档
6. [Prompt Assembly](https://hermes-agent.nousresearch.com/docs/developer-guide/prompt-assembly) — 官方文档
7. [Memory Providers](https://hermes-agent.nousresearch.com/docs/user-guide/features/memory-providers) — 官方文档
8. [GitHub 仓库主页](https://github.com/NousResearch/hermes-agent) — 2,200 Issues, 4,000 PRs（2026-04-22）
9. [skill_manager_tool.py 源码](https://github.com/NousResearch/hermes-agent/blob/main/tools/skill_manager_tool.py) — 795 行, 28.5 KB
10. [hermes-agent-self-evolution 仓库](https://github.com/NousResearch/hermes-agent-self-evolution) — GEPA + DSPy
11. [DEV.to 评测: Hermes Agent Review](https://dev.to/jangwook_kim_e31e7291ad98/hermes-agent-review-self-improving-open-source-ai-agent-3kk3) — jangwook_kim, 评分 8.1/10
12. [LushBinary 开发者指南](https://lushbinary.com/blog/hermes-agent-developer-guide-setup-skills-self-improving-ai/) — 2026-04-03
13. [BetterStack 实测指南](https://betterstack.com/community/guides/ai/hermes-agent/) — 2026-04-20
14. [blakecrosley.com Hermes v0.10 参考](https://blakecrosley.com/guides/hermes) — 2026-04-15

---

*本报告基于 2026-04-22 的公开信息编写。AI Agent 领域发展迅速，部分信息可能在数周内过时。*
