# Part 1：OpenAI —— "Harness Engineering: Leveraging Codex in an Agent-First World"

> 作者：Ryan Lopopolo | 发布：2026-02-11 | 来源：openai.com/index/harness-engineering

## 核心实验

OpenAI 用 5 个月时间做了一个极端实验：**0 行手写代码**，完全用 Codex 构建并发布一个内部 beta 产品。

### 关键数据
- 从空仓库开始（2025 年 8 月第一个 commit）
- 5 个月后：**~100 万行代码**
- ~1,500 个 PR 被 merge
- 3 名工程师 → 后扩展到 7 人
- 平均 **3.5 PR/工程师/天**（随团队扩大吞吐还在增加）
- 产品有数百内部用户，包括日活跃用户
- 估计节省 **10 倍**时间

## 核心理念

> **"Humans steer. Agents execute."**（人类掌舵，Agent 执行）

工程师的工作不再是写代码，而是：
1. **设计环境**（Design environments）
2. **指定意图**（Specify intent）
3. **构建反馈循环**（Build feedback loops）

## 关键发现

### 1. 环境 > 指令

> "早期进展慢于预期，不是因为 Codex 无能，而是因为环境欠缺规范。"

失败的修复从来不是"更努力地提示"，而是问：**"缺什么能力？怎么让它对 Agent 可读且可执行？"**

### 2. AGENTS.md 是目录，不是百科全书

一个巨大的 AGENTS.md 文件会失败：
- 上下文是稀缺资源 → 巨文件挤掉任务和代码
- 一切都"重要" = 什么都不重要
- 立刻过时 → 变成陈旧规则的坟场
- 无法机械验证

**正确做法**：~100 行的 AGENTS.md 作为**导航地图**，指向 `docs/` 目录下的深层文档。

### 3. 渐进式披露（Progressive Disclosure）

```
AGENTS.md (地图, ~100行)
    ↓ 指向
docs/
├── design/          ← 设计文档（已验证/未验证标记）
├── architecture/    ← 架构图（领域+包分层）
├── quality/         ← 质量评分（按领域/层）
├── plans/           ← 执行计划（进度+决策日志）
│   ├── active/
│   ├── completed/
│   └── tech-debt/
└── core-beliefs/    ← Agent-first 运营原则
```

CI 和 linter 自动验证文档的时效性和交叉链接。一个"文档园丁 Agent"定期扫描过时文档并提交修复 PR。

### 4. 仓库 = Agent 的全部世界

> "从 Agent 视角看，不在 context 中的东西等于不存在。"

Slack 讨论、Google Doc、脑中的决策 → 如果不在仓库里，Agent 不知道。

**实践**：持续把更多上下文推入仓库。一切版本化。

### 5. 约束是乘数，不是限制

在纯 Agent 生成的代码库中，严格架构约束是**早期必需品**而非奢侈品：

```
每个业务域 → 固定层级：
Types → Config → Repo → Service → Runtime → UI
                    ↓
               只能向前依赖
```

- 自定义 linter 强制执行（linter 也是 Codex 生成的）
- linter 的错误信息 = Agent 的修复指令
- **"在人类优先工作流中这些规则可能显得迂腐。对 Agent 来说，它们是乘数。"**

### 6. 自动审查 + "AI Slop" 清理

初期：团队每周五花 20% 时间清理"AI 垃圾"。不可持续。

解决方案：
- 编码"黄金原则"到仓库
- 定期 Codex 后台任务扫描偏差 → 开 PR 修复
- **"像垃圾回收一样。技术债务像高利贷——小额持续偿还好过一次性大清理。"**

### 7. 端到端自主

仓库最终达到了**一次提示完成完整功能**：
1. 验证当前代码状态
2. 复现 bug
3. 录制失败视频
4. 实现修复
5. 验证修复 → 录制成功视频
6. 开 PR → 响应反馈 → 处理构建失败
7. 仅在需要判断时升级到人类
8. 合并

### 8. 技术选型偏好

- 偏好"无聊技术"：可组合、API 稳定、训练集中有丰富表示
- 有时自己重写简单功能而非引入外部库（更可控、100% 测试覆盖）
- 示例：自己实现 map-with-concurrency 而非用 p-limit（集成 OpenTelemetry）
