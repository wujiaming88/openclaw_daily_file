# Part 2：核心架构与技术特性

## 整体架构

Hermes Agent 采用三层架构：

```
入口层：CLI / Gateway / ACP / Batch Runner
    ↓
核心层：AIAgent（run_agent.py，~9,200 行）
  ├── Prompt Builder — 系统提示词组装
  ├── Provider Resolution — 多供应商路由（18+ 供应商）
  └── Tool Dispatch — 工具注册表 + 调度
    ↓
存储层：SQLite + FTS5 全文搜索
后端层：6 种终端后端 + 5 种浏览器后端 + MCP
```

### 三种 API 模式

| 模式 | 适用 | 客户端 |
|------|------|--------|
| chat_completions | OpenAI 兼容端点 | openai.OpenAI |
| codex_responses | OpenAI Codex/Responses API | Responses 格式 |
| anthropic_messages | 原生 Anthropic API | anthropic.Anthropic |

## 自学习循环（Learning Loop）

Hermes Agent 最核心的差异化特性是**闭环学习循环**：

### 1. 自主技能创建
- 完成复杂任务（5+ 工具调用）后，自动总结为可复用技能
- 遇到错误并找到解决路径时，保存为技能
- 用户纠正 Agent 方法时，记录正确方式

### 2. 技能使用中自我改进
- 使用技能时发现更好方法 → 自动更新 SKILL.md
- 渐进式技能优化

### 3. 记忆周期性自省
- Agent 定期被"nudge"来持久化重要知识
- 不依赖用户主动要求，Agent 自主判断什么值得记住

### 4. 跨会话搜索
- FTS5 全文搜索历史对话
- LLM 摘要辅助回忆

### 5. 用户建模
- 集成 Honcho 辩证用户建模
- 跨会话逐步深化对用户的理解

## 记忆系统（三层结构）

| 层级 | 机制 | 容量 | 特点 |
|------|------|------|------|
| L1: 工作记忆 | 对话上下文 | 模型上下文窗口 | 自动压缩 |
| L2: 持久记忆 | MEMORY.md + USER.md | ~1,300 tokens | Agent 自管理，有字符上限 |
| L3: 历史搜索 | SQLite FTS5 | 无限 | 按需搜索 + LLM 摘要 |

### 外部记忆提供者
内置 8 个插件：Honcho、OpenViking、Mem0、Hindsight、Holographic、RetainDB、ByteRover、Supermemory

## 技能系统

### 渐进式加载
```
Level 0: skills_list() → 名称+描述列表 (~3k tokens)
Level 1: skill_view(name) → 完整内容
Level 2: skill_view(name, path) → 特定参考文件
```

### 条件激活
- `fallback_for_toolsets` — 主工具不可用时自动显示
- `requires_toolsets` — 依赖工具可用时才显示

### 技能来源
- 内置技能（bundled）
- Skills Hub（agentskills.io）
- Agent 自创建（procedural memory）
- 外部目录（共享技能库）

## 上下文压缩

### 触发条件
- 预检压缩：超过 50% 上下文窗口
- Gateway 自动压缩：超过 85%

### 压缩过程
1. 先刷新记忆到磁盘（防数据丢失）
2. 中间对话轮次被 LLM 摘要
3. 保留最后 N 条消息不动（默认 20）
4. 工具调用/结果对始终保持完整
5. 生成新的会话谱系 ID

## Agent 循环（核心循环）

每轮推理遵循：
1. 追加用户消息到历史
2. 构建/复用缓存的系统提示词
3. 检查是否需要预检压缩
4. 构建 API 消息格式
5. 注入临时提示层（预算警告等）
6. 可中断的 API 调用
7. 解析响应 → 有工具调用则执行后回到步骤 5
8. 文本响应 → 持久化会话 → 刷新记忆 → 返回

### 迭代预算
- 默认 90 次迭代
- 70% 时开始"谨慎"提示
- 90% 时"立即完成"警告
- 100% 强制停止并返回摘要
- 父子 Agent 共享预算
