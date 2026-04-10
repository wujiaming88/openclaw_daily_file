# Part 5：工程实践与设计哲学

## "Less Scaffolding, More Model" —— 核心设计哲学

Claude Code 的哲学与许多 Agent 框架截然相反：

### 没有什么
- **没有** 意图分类器
- **没有** 任务路由器
- **没有** RAG/Embedding 管道
- **没有** DAG 编排器
- **没有** 规划/执行分离

### 本质是一个 while 循环
```python
while claude_response.has_tool_call:
    result = execute_tool(tool_call)
    claude_response = send_to_claude(result)
return claude_response.text
```

### 为什么这么简单？
1. **更少组件 = 更少失败模式**
2. **模型推理优于手写启发式**
3. **无刚性管道约束**
4. **调试简单——容易理解发生了什么**

> "The harness is the hard part. Everyone assumes the model is the competitive advantage. And it is — until you try to make it do things reliably for more than five minutes."

---

## 搜索策略演进

早期 Claude Code 版本曾使用 **Voyage embeddings 做语义代码搜索（RAG）**。Anthropic 内部 benchmark 后切换到 **grep-based（ripgrep）agentic search**：

| 方案 | 优势 | 劣势 |
|------|------|------|
| RAG/Embedding | 语义理解好 | 需要索引同步、外部 embedding provider 安全风险 |
| ripgrep (agentic search) | 简单、无索引、安全 | 可能消耗更多 token |

**"Search, Don't Index"** —— 用延迟和 token 换取简单和安全。

---

## 8 个核心工具（极简主义）

| 工具 | 用途 | Token 成本 |
|------|------|-----------|
| **Bash** | Shell 命令（万能适配器） | 低+可变 |
| **Read** | 读文件（最多 2000 行） | 高（大文件） |
| **Edit** | diff-based 修改文件 | 中 |
| **Write** | 创建/覆写文件 | 中 |
| **Grep** | ripgrep 搜索内容 | 低 |
| **Glob** | 按模式查找文件 | 低 |
| **Task** | 生成子 Agent | 高（新上下文） |
| **TodoWrite** | 追踪任务进度 | 低 |

> Bash 是 Claude 的瑞士军刀——git、npm、docker、curl... 任何 CLI 工具都通过它调用。

---

## 遥测与指标

泄露源码揭示了两个独特的遥测信号：

### 挫败感指标（Frustration Metric）
- 追踪用户**骂人频率**作为 UX 信号
- 用户在骂工具 = 某个地方出了问题
- 这是**先行指标**而非滞后指标

### "Continue" 计数器
- 追踪用户输入 "continue" 的频率
- 这是 Agent **卡顿**的代理指标——Agent 失去动力，人类不得不推它一下
- 标准分析无法捕获这类 failure mode

---

## 108 个 Feature Flag

- 通过 Bun compile-time dead code elimination 管理
- 生产包中不存在未发布功能的代码
- 已知隐藏模块：**KAIROS**、**VOICE_MODE**、**DAEMON**
- **Undercover Mode**：防止内部代号出现在 git commit 或输出中
  - 讽刺的是，在泄露源码中被发现——防泄漏系统本身被泄漏

---

## 子 Agent 架构约束

- **深度限制：depth=1** —— 子 Agent 不能再生成子 Agent
- 只有摘要返回给主 Agent
- 防止无限递归
- 保持架构扁平可预测

---

## Session 持久化

- **存储格式**：JSONL（`~/.claude/projects/`）
- **文件快照**：修改前自动快照（checkpoint）
- **回退**：`/undo` 回退到快照
- **分叉**：`claude --resume` 从历史点分叉新会话
- **每条消息、工具调用、结果**全部持久化

---

## 成本优化策略

| 策略 | 说明 |
|------|------|
| 子 Agent 用 Haiku | 探索/搜索任务用便宜模型 |
| 动态模型切换 | `/model opus\|sonnet\|haiku` 按需切换 |
| MCP 工具搜索 | 只加载实际使用的工具 schema |
| 三层压缩 | MicroCompact 零 API 成本 |
| Skills 按需加载 | 不使用的技能不消耗 token |
