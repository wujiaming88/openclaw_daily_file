# 研究报告：Paperclip AI 开源项目深度调研

**调研时间**: 2026-03-09  
**研究员**: 黄山 (wairesearch)  
**项目**: github.com/paperclipai/paperclip

---

## 执行摘要

Paperclip 是一个开源的 **AI Agent 编排平台**，专注于构建"零人工公司"（Zero-Human Companies）。该概念在 2026 年初已从理论走向实践——有人用 AI Agent 实现了 $10万+ 收入，有人用 15 个 Agent 组成的"委员会"每周节省 20 小时。

Paperclip 定位为 **AI 公司的操作系统**，提供组织架构、目标管理、预算控制、审计日志、治理机制。项目采用 Node.js + React + PostgreSQL 技术栈，MIT 协议，已获得 **4,300+ GitHub Stars**，正在快速崛起。

**核心洞察**：瓶颈从来不是 Agent 的智能，而是**组织基础设施**。

---

## 一、项目概览

| 属性 | 详情 |
|------|------|
| **项目名称** | Paperclip |
| **GitHub** | github.com/paperclipai/paperclip |
| **Stars** | 4,300+ (增长中) |
| **技术栈** | Node.js + Express + React + PostgreSQL (PGlite) |
| **协议** | MIT |
| **官网** | paperclip.ing |
| **定位** | AI Agent 公司控制平面 |

### 项目结构

```
paperclip/
├── server/              # Express REST API 和编排服务
├── ui/                  # React + Vite 管理面板
├── packages/
│   ├── db/              # Drizzle ORM schema, migrations
│   └── shared/          # 共享类型、常量、验证器
├── doc/                 # 产品和开发文档
└── AGENTS.md            # 贡献者指南
```

---

## 二、核心功能详解

### 2.1 组织架构 (Org Chart)

- 创建层级式 AI 团队：CEO、CTO、工程师、设计师、营销等
- 每个 Agent 有明确汇报关系、职位、职责描述
- 支持任意 Agent 运行时

**支持的 Agent 类型**：
- OpenClaw
- Claude
- Codex
- Cursor
- Bash
- HTTP Webhook
- 任何可接收心跳的 Agent

### 2.2 目标对齐 (Goal Alignment)

```
公司使命 → 项目目标 → Agent 目标 → 任务
```

任务携带完整的目标溯源，Agent 始终知道"为什么"，而不仅是"做什么"。

### 2.3 心跳调度 (Heartbeats)

- 定时唤醒 Agent 检查工作、执行任务
- 支持多种触发：定时调度、任务分配、@提及
- 委托自动沿组织层级传递

**示例**：
| Agent | 频率 | 任务 |
|-------|------|------|
| 内容写作 | 每4小时 | 写博客、社交媒体 |
| SEO 分析师 | 每8小时 | 关键词研究、排名追踪 |
| 社交经理 | 每12小时 | 排程帖子、互动回复 |

### 2.4 成本控制 (Cost Control)

- 每个 Agent 设置月度预算
- 80% 发出警告，100% 自动暂停
- 多维度追踪：Agent、任务、项目、目标

**关键能力**：防止 API 费用失控。AI Agent 可能在数小时内烧掉数千美元。

### 2.5 治理机制 (Governance)

- 你是董事会：审批招聘、审核战略、暂停/终止 Agent
- 审批门控：Agent 无法未经批准雇佣新 Agent
- 配置变更版本管理，支持回滚
- 不可变审计日志

### 2.6 多公司支持

- 单实例运行数十个相互隔离的公司
- 完整数据隔离和审计日志
- 一个控制面板管理整个投资组合

### 2.7 工单系统 (Ticket System)

- 任务即工单，明确负责人、状态、讨论线程
- 完整工具调用追踪
- 不可变审计日志

---

## 三、技术架构

### 3.1 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                   Paperclip Server                       │
│         (Node.js + Express + PostgreSQL)               │
├─────────────────────────────────────────────────────────┤
│  • 任务编排引擎    • 心跳调度器    • 成本追踪          │
│  • 审计日志       • 多公司隔离     • API 网关          │
│  • Agent 适配器   • 预算执行器     • 审批门控          │
├─────────────────────────────────────────────────────────┤
│                      React UI                           │
│        (Dashboard / Org Chart / Tickets)               │
└─────────────────────────────────────────────────────────┘
        │              │              │
        ▼              ▼              ▼
   ┌─────────┐   ┌─────────┐   ┌─────────┐
   │ OpenClaw│   │ Claude  │   │ Codex   │
   │ Agent   │   │ Agent   │   │ Agent   │
   └─────────┘   └─────────┘   └─────────┘
```

### 3.2 核心技术特性

| 特性 | 说明 |
|------|------|
| **原子执行** | 任务检出和预算 enforcement 原子化，避免重复和超支 |
| **持久化状态** | Agent 跨心跳保持任务上下文 |
| **运行时技能注入** | Agent 可在运行时学习工作流和项目上下文 |
| **目标感知执行** | 任务携带完整目标祖先链 |
| **可移植模板** | 导出/导入组织和 Agent（自动清理 secrets） |
| **公司隔离** | 所有实体按公司作用域隔离 |

### 3.3 部署方式

```bash
# 方式一：一键启动
npx paperclipai onboard --yes

# 方式二：手动
git clone https://github.com/paperclipai/paperclip.git
cd paperclip
pnpm install
pnpm dev
# API: http://localhost:3100
# UI: 同上
```

**技术要求**：Node.js 20+, pnpm 9.15+

**数据库**：开发环境使用嵌入式 PGlite，无需配置；生产环境可连接外部 PostgreSQL

---

## 四、市场现状与行业案例

### 4.1 零人工公司正在兴起

**Felix - $10万 AI Agent**
- 由 Nat Eliason 构建，使用 OpenClaw
- 目标 $100万 ARR
- 负责内容创作、研究、业务开发

**Aaron Sneed 的 15 Agent 委员会**
- Business Insider 2026年2月报道
- 15 个自定义 GPT 组成
- 每周节省 20+ 小时

### 4.2 行业评价

| 来源 | 评价 |
|------|------|
| Flowtivity | "瓶颈从来不是 Agent 智能，而是组织基础设施" |
| TopAIProduct | "不是聊天框架，而是自动驾驶公司的操作系统" |
| Daily.dev | "Trending: 4.3k+ stars 的编排平台" |
| VibeSparking | "给 AI Agent 一个公司，而不是更好的提示词" |

### 4.3 典型应用场景

| 场景 | Agent 数量 | 职能 |
|------|-----------|------|
| 内容营销公司 | 8 | 内容、SEO、社交、广告、分析 |
| 加密货币交易台 | 12 | 分析、执行、风险、合规 |
| 电商运营 | 10 | Listing、客服、库存、广告 |
| YouTube 工厂 | 6 | 脚本、剪辑、缩略图、排程 |
| 软件开发 agency | 9 | PM、工程师、QA、DevOps |

---

## 五、竞品对比

### 5.1 产品定位对比

| 维度 | Paperclip | OpenClaw | Claude Code | LangChain |
|------|-----------|----------|-------------|-----------|
| **定位** | AI 公司 OS | 通用 Agent | 编程助手 | Agent 框架 |
| **核心** | 组织、治理、预算 | 任务执行 | 代码编辑 | 工具链 |
| **Agent 数量** | 多 | 单/多 | 单 | 多 |
| **适用** | 自动化公司 | 灵活任务 | 开发工作流 | 特定场景 |
| **开源** | ✅ MIT | ✅ | ❌ | ✅ |

### 5.2 Paperclip vs 传统工具

| 维度 | 不用 Paperclip | 用 Paperclip |
|------|---------------|--------------|
| **多 Agent 管理** | 20个标签页，无法追踪 | 工单系统，状态清晰 |
| **上下文** | 手动收集各种提示 | 目标溯源，上下文自动流 |
| **Agent 配置** | 文件夹混乱 | Org Chart + 治理 |
| **成本** | 可能失控 | 预算控制 + 自动暂停 |
| **周期性任务** | 手动触发 | 心跳调度自动化 |

---

## 六、优势与不足

### ✅ 优势

1. **完整企业治理** — 董事会审批、预算控制、审计日志
2. **多公司隔离** — 单实例运行多个独立业务
3. **灵活 Agent 集成** — 兼容任何可接收心跳的 Agent
4. **目标溯源** — 任务关联使命，上下文清晰
5. **自托管** — 100% 开源，数据自主
6. **部署简单** — 单进程 + 嵌入式数据库
7. **治理安全** — 审批门控、配置回滚

### ⚠️ 不足

1. **学习曲线** — 需要理解公司运营模型
2. **生态早期** — 社区规模待增长
3. **非可视化** — 无拖拽式工作流编排
4. **移动端** — 响应式，非原生 App
5. **复杂度** — 对单个 Agent 用户可能过重

---

## 七、结论与建议

### 7.1 核心结论

1. **零人工公司是真实趋势**，不是概念实验
2. **瓶颈是编排，不是 Agent 能力** — 这正是 Paperclip 解决的问题
3. **与 OpenClaw 是互补关系** — Paperclip 负责"管理公司"，OpenClaw 负责"执行任务"
4. **治理和成本控制是关键** — 缺少这些，AI Agent 无法规模化

### 7.2 适用人群

| 适合 | 不适合 |
|------|--------|
| ✅ 运营多个 AI Agent 需要协调 | ❌ 单个 AI Agent 用户 |
| ✅ 想构建"自动驾驶"商业流程 | ❌ 需要复杂可视化工作流 |
| ✅ 需要多公司数据隔离 | ❌ 不想理解公司运营模型 |
| ✅ 关注成本控制和审计 | |

### 7.3 建议行动

1. **试用**：`npx paperclipai onboard --yes`
2. **集成**：将 OpenClaw 作为 Paperclip 的执行层 Agent
3. **关注**：ClipMart 模板市场和插件系统
4. **学习**：从 1 个 Agent 开始，逐步扩展

---

## 八、参考来源

1. https://github.com/paperclipai/paperclip
2. https://paperclip.ing/docs
3. https://paperclip.ing
4. https://flowtivity.ai/blog/zero-human-company-paperclip-ai-agent-orchestration/
5. https://topaiproduct.com/2026/03/06/paperclip-ai-wants-to-run-your-entire-company-with-zero-humans-and-its-open-source/
6. https://www.vibesparking.com/en/blog/ai/agent-orchestration/2026-03-05-paperclip-open-source-orchestration-zero-human-companies/
7. https://github.com/paperclipai/paperclip/blob/master/AGENTS.md
