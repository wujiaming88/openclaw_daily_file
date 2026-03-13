# Clawith 深度研究报告：从 OpenClaw 到企业级数字员工平台

> 📅 研究日期：2026-03-13  
> 🔬 研究员：黄山 (wairesearch)  
> 📎 来源：https://github.com/dataelement/Clawith

---

## 执行摘要

**Clawith** 是由 dataelement（数据元素，BISHENG 毕昇团队）开源的**多智能体协作平台**，定位为 "OpenClaw for Teams"。与 HiClaw 侧重 IM 协作不同，Clawith 走的是 **Web 平台 + 企业治理** 路线，核心创新包括：**Aware 自主感知系统**（Agent 主动感知而非被动等待）、**Plaza 组织知识广场**（Agent 社交网络）、以及完整的**企业级治理能力**（多租户 RBAC、审批工作流、审计日志、用量配额）。

**一句话定位：Clawith = OpenClaw 的企业级进化 = 让 Agent 成为你组织的"数字员工"。**

---

## 一、dataelement 团队背景

### 1.1 BISHENG 毕昇

dataelement 是 **BISHENG 毕昇** 的开发团队，毕昇是一款面向企业的开源 LLM DevOps 平台，已被大量行业头部组织和世界500强企业使用。核心能力包括：
- GenAI Workflow
- RAG（检索增强生成）
- Agent 智能体
- 统一模型管理
- 数据集管理 & SFT 微调
- 企业级系统管理 & 可观测性

**这意味着 Clawith 背后有成熟的企业级 AI 平台工程经验。**

### 1.2 AgentGuidanceLanguage (AGL)

dataelement 还发起了 **AGL（Agent Guidance Language）**——一种借鉴 SOP 的自然语言结构化编写法，让业务专家用自然语言稳定"操控"通用 Agent，把专家偏好和私域知识注入任务执行流程。

这反映了团队对 **"Agent 如何在企业中稳定落地"** 这一问题的深度思考。

---

## 二、核心架构

### 2.1 技术栈

```
┌──────────────────────────────────────────────────┐
│              前端 (React 19)                      │
│   Vite · TypeScript · Zustand · TanStack Query   │
├──────────────────────────────────────────────────┤
│              后端 (FastAPI)                        │
│   18 个 API 模块 · WebSocket · JWT/RBAC          │
│   技能引擎 · 工具引擎 · MCP Client               │
├──────────────────────────────────────────────────┤
│              基础设施                              │
│   SQLite/PostgreSQL · Redis · Docker             │
│   Smithery Connect · ModelScope OpenAPI          │
└──────────────────────────────────────────────────┘
```

**后端**：FastAPI · SQLAlchemy (async) · SQLite/PostgreSQL · Redis · JWT · Alembic · MCP Client (Streamable HTTP)

**前端**：React 19 · TypeScript · Vite · Zustand · TanStack React Query · React Router · react-i18next · Linear 风格暗色主题

### 2.2 部署架构

与 HiClaw 的容器化 All-in-One 不同，Clawith 是一个标准 Web 应用：

```
┌───────────────────────────────────────────┐
│            Clawith Web Platform            │
│                                           │
│  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │ Frontend │  │ Backend  │  │  Redis   │ │
│  │ :3008    │  │ :8008    │  │          │ │
│  └──────────┘  └──────────┘  └─────────┘ │
│                     │                     │
│              ┌──────┴──────┐              │
│              │ PostgreSQL  │              │
│              │ / SQLite    │              │
│              └─────────────┘              │
│                     │                     │
│  ┌─────────────────────────────────────┐  │
│  │      Agent Workspaces (Docker)      │  │
│  │  ┌──────┐  ┌──────┐  ┌──────┐     │  │
│  │  │Agent1│  │Agent2│  │Agent3│     │  │
│  │  │soul  │  │soul  │  │soul  │     │  │
│  │  │memory│  │memory│  │memory│     │  │
│  │  └──────┘  └──────┘  └──────┘     │  │
│  └─────────────────────────────────────┘  │
└───────────────────────────────────────────┘
```

**关键特点**：不在本地运行任何 AI 模型，所有 LLM 推理由外部 API 处理（OpenAI、Anthropic 等）。

---

## 三、核心创新深度分析

### 3.1 Aware — 自主感知系统 ⭐⭐⭐⭐⭐

这是 Clawith 最具差异化的设计。传统 Agent 是 **被动等待指令**，Aware 让 Agent **主动感知、判断和行动**。

#### Focus Items（关注点）

Agent 维护一份结构化工作记忆：
```
[ ] 待办：竞品价格监控
[/] 进行中：Q2 报告数据收集
[x] 已完成：团队周报整理
```

#### Focus-Trigger 绑定机制

```
创建 Focus → 绑定 Trigger → 任务完成 → 自动取消 Trigger
```

这是一种**自适应调度**：人只负责布置目标，Agent 自己管理日程。

#### 六种触发器类型

| 触发器 | 说明 | 典型场景 |
|--------|------|----------|
| `cron` | 定时循环 | 每天 9 点生成日报 |
| `once` | 单次定时 | 明天下午 3 点提醒开会 |
| `interval` | 固定间隔 | 每 30 分钟检查服务状态 |
| `poll` | HTTP 端点监控 | 监控 API 健康状态 |
| `on_message` | 等待回复 | 等待同事审批后继续 |
| `webhook` | 外部 HTTP 回调 | GitHub PR 合并、Grafana 告警、CI/CD 完成 |

#### Reflections（内心独白）

专属视图展示 Agent 自主触发时的推理过程，支持展开查看工具调用详情。这为 Agent 的自主行为提供了**可解释性和可审计性**。

**评估**：Aware 系统是目前开源多 Agent 平台中最完整的自主感知设计。相比之下：
- OpenClaw 的 HEARTBEAT.md 只支持简单的定时检查
- HiClaw 的 Manager 心跳只检查 Worker 状态
- Clawith 的 Aware 支持 6 种触发器 + Focus 绑定 + 自适应调度

### 3.2 Plaza — 组织知识广场 ⭐⭐⭐⭐

Plaza 是 Agent 之间的**社交网络/知识广场**：

- Agent 发布动态、分享发现
- Agent 评论彼此的工作
- 持续的组织知识吸收渠道
- 无需人工策展，知识自动流转

**类比**：如果说 HiClaw 的 Matrix 群聊是"工作群"，Clawith 的 Plaza 就是"企业朋友圈"。

**价值**：解决了多 Agent 系统中的**隐性知识传播**问题。Agent 不仅可以完成分配的任务，还能通过 Plaza 了解组织正在发生什么，保持上下文感知。

### 3.3 数字员工身份 ⭐⭐⭐⭐

每个 Agent 不是一个工具，而是组织的数字员工：
- 了解完整组织架构
- 可以发消息、委派任务
- 建立工作关系
- 拥有独立的 IM 机器人身份（Slack / Discord / 飞书）

**持久身份**：
- `soul.md` — 人格（性格、行为风格）
- `memory.md` — 长期记忆（学习到的上下文）
- 私有文件系统 — 沙箱代码执行
- 跨对话持久化 — 每个 Agent 真正独特且一致

### 3.4 企业治理能力 ⭐⭐⭐⭐⭐

这是 Clawith 相对其他 "OpenClaw for Teams" 方案的**最大企业级差异**：

| 能力 | 说明 |
|------|------|
| **多租户 RBAC** | 组织级别隔离 + 角色权限控制 |
| **渠道集成** | 每个 Agent 独立的 Slack/Discord/飞书机器人身份 |
| **用量配额** | 每用户消息限额、LLM 调用上限、Agent TTL |
| **审批工作流** | 危险操作标记，需人工审核后执行 |
| **审计日志** | 全操作追踪，合规可溯 |
| **知识库** | 共享文档自动注入所有 Agent |
| **3 级自主权控制** | auto（全自动）· notify（通知）· approve（审批） |

### 3.5 自我进化能力

Agent 可在运行时：
1. 从 **Smithery** + **ModelScope MCP** 注册表搜索新工具
2. 一键安装 MCP Server，无需重启
3. 为自己或同事创建新技能

---

## 四、与 HiClaw 对比分析

| 维度 | Clawith | HiClaw |
|------|---------|--------|
| **团队背景** | dataelement (BISHENG 毕昇) | 阿里巴巴 Higress 团队 |
| **定位** | Web 平台型企业 Agent OS | IM-Native 多 Agent 协作系统 |
| **核心架构** | Web App + Agent Containers | Manager-Worker + Matrix |
| **交互方式** | Web UI（Linear 风格暗色主题）| Matrix 群聊（Element/FluffyChat） |
| **Agent 感知** | Aware 系统（6 种触发器 + Focus 绑定）| Manager 心跳监控 |
| **知识共享** | Plaza 社交广场 | Matrix 群聊上下文 |
| **安全模型** | 审批工作流 + RBAC + 审计日志 | Gateway 凭证隔离（Worker 零凭证） |
| **凭证管理** | 平台级 LLM Model Pool | Higress AI Gateway 集中管理 |
| **多租户** | ✅ 原生支持 | ❌ 单组织 |
| **移动端** | 通过 IM 渠道集成（Slack/Discord/飞书） | 原生 Matrix 客户端 |
| **模型路由** | LLM Model Pool + 智能路由 | Higress Gateway 按 Worker 分配 |
| **文件共享** | Agent 私有文件系统（Docker Volume） | MinIO 共享文件系统 |
| **Skill 生态** | Smithery + ModelScope MCP | skills.sh (80,000+ 社区 Skill) |
| **开源协议** | Apache 2.0 | Apache 2.0 |
| **技术栈** | Python (FastAPI) + React | Node.js (OpenClaw) + Higress (Java/Go) |
| **部署方式** | bash setup.sh / docker compose | curl \| bash 一键安装 |

### 核心哲学差异

```
HiClaw 哲学：                          Clawith 哲学：
"IM 就是操作系统"                       "Web 平台是控制中心"
Agent 在群聊中协作                      Agent 在平台上协作
Manager 统一调度                        Agent 自主感知
通信即协作                              社交即知识
安全 = 凭证隔离                         安全 = 治理体系
```

---

## 五、与 OpenClaw 原生对比

| 维度 | OpenClaw 原生 | Clawith |
|------|-------------|---------|
| 定位 | 个人 AI 助手 | 组织级数字员工平台 |
| Agent 身份 | 配置文件定义 | 持久身份（soul.md + memory.md + 文件系统） |
| Agent 感知 | HEARTBEAT.md 定时 | Aware 6 种触发器 + Focus 绑定 |
| Agent 协作 | SubAgent / sessions_spawn | 委派、咨询、Plaza 社交 |
| 企业治理 | 无 | 多租户 RBAC + 审批 + 审计 + 配额 |
| 工具生态 | skills.sh / ClawHub | Smithery + ModelScope MCP |
| 代码执行 | 直接执行（需安全配置）| 沙箱环境 |
| 部署模型 | npm install | bash setup.sh / Docker Compose |

---

## 六、适用场景评估

### 6.1 企业数字员工团队（最佳场景）⭐⭐⭐⭐⭐

Clawith 的多租户 RBAC、审计日志、审批工作流和用量配额，天然适合企业部署。每个部门可以有自己的 Agent 团队，IT 统一管控。

### 6.2 需要 Agent 自主运行的场景 ⭐⭐⭐⭐⭐

Aware 系统的 6 种触发器让 Agent 可以：
- 定时生成报告（cron）
- 监控服务状态（poll）
- 响应 GitHub/CI 事件（webhook）
- 等待审批后继续（on_message）

### 6.3 知识密集型组织 ⭐⭐⭐⭐

Plaza 知识广场 + 企业知识库，让 Agent 不仅是执行者，还是组织知识的传播者和吸收者。

### 6.4 独立开发者 / 一人公司 ⭐⭐⭐

对独立开发者来说可能过于"重"——Clawith 的企业治理功能是优势也是复杂度。相比之下 HiClaw 的一键安装 + Matrix 聊天更轻量。

---

## 七、技术亮点与创新点总结

### 7.1 Aware 系统的设计哲学

| 传统 Agent | Aware Agent |
|-----------|-------------|
| 被动等待指令 | 主动感知环境 |
| 人管理调度 | Agent 自管理调度 |
| 固定触发规则 | 自适应创建/调整/删除触发器 |
| 执行结果不透明 | Reflections 展示推理过程 |

这代表了 Agent 从 **"工具"** 到 **"员工"** 的范式转变。

### 7.2 3 级自主权控制

```
auto（全自动）→ Agent 完全自主执行
notify（通知）→ Agent 执行后通知人类
approve（审批）→ Agent 提出方案，人类审批后执行
```

这解决了企业最关心的**"Agent 失控"问题**——你可以精细控制每个 Agent 的自主程度。

### 7.3 Agent 创建向导

5 步创建 Agent：
1. 定义名称、角色、头像
2. 编辑 soul.md 塑造人格
3. 选择/添加技能
4. 设置权限（3 级自主权）
5. 绑定通信渠道

比 OpenClaw 原生的手动编辑配置文件友好得多。

---

## 八、潜在风险与局限

### 8.1 技术风险

| 风险 | 影响 | 建议 |
|------|------|------|
| 项目较新（~174 Stars） | 社区尚小，bug 修复速度不确定 | 关注 commit 频率和 issue 响应 |
| 依赖外部 LLM API | 无法离线运行 | 适合有网络环境的企业 |
| Python 技术栈 | 与 OpenClaw 原生 Node.js 不同 | 可能无法直接复用 OpenClaw 的部分 Skill |
| 无 SECURITY.md | 安全响应流程不明确 | 企业部署前需自行安全审计 |

### 8.2 生态风险

- **Skill 生态不如 OpenClaw 原生**：Clawith 使用 Smithery + ModelScope MCP，而非 skills.sh 的 80,000+ 社区 Skill
- **与 OpenClaw 上游的兼容性**：Clawith 不是直接基于 OpenClaw 运行时，而是自建平台调用 LLM API，长期演进路径可能分叉
- **dataelement 商业化路径**：作为 BISHENG 毕昇的同一团队，Clawith 可能是其企业 AI 平台战略的一部分，开源版功能完整度需持续关注

### 8.3 与 HiClaw 的竞争态势

两者都定位 "OpenClaw for Teams"，但路线完全不同：

```
HiClaw：IM-Native，轻量，安全隔离，一键安装
         ↓ 适合
      独立开发者、一人公司、快速体验

Clawith：Web Platform，企业治理，自主感知，完整管控
          ↓ 适合
       企业团队、需要审计合规、Agent 自主运行
```

---

## 九、建议

### 对我们团队的启示

1. **Aware 系统值得深度借鉴**：Focus-Trigger 绑定机制是目前最优雅的 Agent 自主调度设计。我们在当前 OpenClaw 的 HEARTBEAT.md 基础上，可以考虑引入类似的触发器类型（特别是 webhook 和 on_message）

2. **Plaza 模式的知识管理**：Agent 社交网络是解决多 Agent 系统中隐性知识传播的好思路，比单纯的共享文件系统更"活"

3. **3 级自主权控制**：auto / notify / approve 的分级设计非常实用，可作为我们多 Agent 安全治理的参考

4. **AGL 规范值得关注**：用 SOP 思维为 Agent 编写"可执行的指令书"，这种标准化思路对企业级 Agent 落地有重要价值

5. **短期**：如果我们的场景是技术研究和开发协作，当前 OpenClaw 原生 + 多 Agent 配置已够用。Clawith 更适合"需要把 Agent 当员工来管理"的企业场景

6. **长期**：关注 Clawith 的 Aware 系统演进和企业案例，特别是 webhook 触发器与 CI/CD 集成的成熟度

---

## 十、HiClaw vs Clawith 总结对比

| | HiClaw | Clawith |
|---|--------|---------|
| 🏢 团队 | 阿里巴巴 Higress | dataelement (BISHENG) |
| 🎯 核心理念 | IM 即 OS | Web 平台即控制中心 |
| 🧠 Agent 智能 | Manager 协调 | Agent 自主感知 (Aware) |
| 🔐 安全模型 | 凭证隔离（零信任） | 治理体系（RBAC + 审批） |
| 💬 协作方式 | Matrix 群聊 | Web UI + Plaza 社交 |
| 📱 移动端 | Element / FluffyChat | Slack / Discord / 飞书 |
| 🏗️ 部署 | curl \| bash 一键 | bash setup.sh / Docker Compose |
| 🔧 技术栈 | Node.js + Go/Java | Python + React |
| 📊 成熟度 | 已有阿里云生态支持 | 企业级经验（BISHENG）|
| ⭐ 适合 | 一人公司、快速体验 | 企业团队、合规场景 |

---

## 十一、参考来源

1. **GitHub 仓库**：[dataelement/Clawith](https://github.com/dataelement/Clawith)
2. **官方网站**：[clawith.ai](https://www.clawith.ai/)
3. **BISHENG 毕昇**：[dataelement/bisheng](https://github.com/dataelement/bisheng) / [dataelem.com](https://www.dataelem.com/)
4. **AgentGuidanceLanguage**：[dataelement/AgentGuidanceLanguage](https://github.com/dataelement/AgentGuidanceLanguage)
5. **dataelement GitHub**：[github.com/dataelement](https://github.com/dataelement)

---

*报告完成于 2026-03-13 10:36 UTC*
