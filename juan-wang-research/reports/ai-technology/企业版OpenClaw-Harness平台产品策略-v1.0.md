# 企业版 OpenClaw：基于 Harness Engineering 的 Agent 运行平台产品策略

> **核心主张**：Dify/Coze 让你"搭 Agent"，LangChain 让你"写 Agent"，企业版 OpenClaw 让你的 Agent **可靠地运行在生产环境**。

---

## 第一章：为什么是 Harness Engineering

### 1.1 行业背景

2025-2026 年，AI Agent 行业正在经历一个关键转折：

```
2023: "Agent 能不能工作？"          → 证明可行性
2024: "Agent 怎么用起来？"          → 框架和平台涌现
2025: "Agent 为什么不稳定？"        → 发现 Harness 才是关键
2026: "谁能让 Agent 可靠地跑起来？"  → Harness 平台的机会
```

OpenAI 在 2026 年 2 月发布了"Harness Engineering"概念——用 Codex 团队 5 个月写出 100 万行零手写代码的经验，揭示了一个核心洞见：

> **Agent 不是难点，Harness 才是。**

Agent = 模型 + Harness。模型的能力在快速趋同（GPT-5、Claude Opus、Gemini Ultra 差距越来越小），真正拉开差距的是 **Harness——Agent 运行的环境、约束、记忆、工具和护栏**。

### 1.2 Harness Engineering 的六大组件

| 组件 | 解决什么问题 | 类比 |
|------|------------|------|
| **工具集成层** | Agent 能操作什么 | 手和脚 |
| **记忆与状态** | Agent 记住什么 | 大脑长期记忆 |
| **上下文工程** | Agent 看到什么 | 视野和注意力 |
| **规划与分解** | Agent 如何协作 | 团队分工 |
| **验证与护栏** | Agent 不能做什么 | 安全网和围栏 |
| **模块化扩展** | Agent 如何获得新能力 | 能力市场 |

### 1.3 为什么企业版 OpenClaw 天然适合做这件事

OpenClaw 不是一个聊天机器人框架——它已经是一个**完整的 Agent Harness 运行时**。Harness Engineering 文献中描述的每一个组件，OpenClaw 都有成熟实现：

| Harness 组件 | OpenClaw 已有实现 | 成熟度 |
|-------------|-----------------|-------|
| 工具集成层 | Tool Policy + Exec + Sandbox + Safe Bins + Browser + MCP | ⭐⭐⭐⭐⭐ |
| 记忆与状态 | MEMORY.md + LCM + Memory Search + Session Store | ⭐⭐⭐⭐⭐ |
| 上下文工程 | Workspace Context + Skills 渐进加载 + Compaction | ⭐⭐⭐⭐⭐ |
| 规划与分解 | Sub-agents + ACP + Cron + Hooks | ⭐⭐⭐⭐ |
| 验证与护栏 | Sandbox + Exec Approvals + Tool Policy + Safe Bins | ⭐⭐⭐⭐⭐ |
| 模块化扩展 | Skills (ClawHub) + Plugins + Channel Plugins | ⭐⭐⭐⭐⭐ |

**关键优势**：不需要从零构建，而是把已有的能力**产品化、可视化、多租户化**。

---

## 第二章：市场定位与竞争分析

### 2.1 竞争格局

```
                    高治理 / 高控制
                         │
    GitHub Agent         │     企业版 OpenClaw
    Control Plane        │     (Harness Platform)
    (.github/agents)     │
                         │     AWS Bedrock AgentCore
                         │
低灵活 ─────────────────┼───────────────── 高灵活
                         │
  Dify / Coze / Lindy    │   LangChain / CrewAI
  (No-Code 拖拽)          │   (Code-First 框架)
                         │
                    低治理 / 低控制
```

**右上象限（高治理 + 高灵活）几乎是空的——这就是机会。**

### 2.2 竞品对比

| 维度 | Dify / Coze | LangChain / CrewAI | GitHub Agent CP | AWS Bedrock AgentCore | **企业版 OpenClaw** |
|------|------------|-------------------|----------------|----------------------|-------------------|
| **定位** | 低代码搭建器 | 代码框架 | Coding Agent 治理 | 云厂商 Agent 基础设施 | **通用 Harness 平台** |
| **上下文管理** | 基础（固定 prompt） | DIY | .md 文件指令 | 无特殊机制 | **7 文件体系 + LCM 无损压缩** |
| **记忆系统** | 简单 KV | DIY | 无 | 无 | **5 层记忆 + 混合搜索 + 自动冲刷** |
| **安全护栏** | 基础 | DIY | 审计日志 + push rule | IAM 权限 | **5 层纵深防御** |
| **多 Agent** | 简单工作流 | 支持 | 单 Agent | 支持 | **嵌套编排 + ACP + Cron** |
| **多渠道** | API 为主 | 无 | GitHub 内 | 无 | **10+ 渠道原生支持** |
| **模型锁定** | 多模型 | 多模型 | GitHub Models | AWS 模型 | **Provider 无关** |
| **技能市场** | 插件市场 | 无 | 无 | 无 | **ClawHub + 7 层优先级** |
| **部署方式** | SaaS / 自托管 | 自托管 | SaaS | SaaS | **本地 / VPS / 混合** |

### 2.3 差异化定位

一句话定位：

> **企业版 OpenClaw = Agent 的 Kubernetes**

类比关系：

| 类比 | 容器世界 | Agent 世界 |
|------|---------|-----------|
| 搭建器 | WordPress | Dify / Coze |
| 代码框架 | Express.js | LangChain / CrewAI |
| **运行平台** | **Kubernetes** | **企业版 OpenClaw** |

Kubernetes 不教你写应用，它让应用**可靠地运行**——编排、扩缩容、健康检查、权限、网络策略。
企业版 OpenClaw 不教你写 Agent，它让 Agent **可靠地运行**——上下文管理、记忆、护栏、编排、渠道路由。

---

## 第三章：五大产品模块

### 3.1 模块总览

```
┌─────────────────────────────────────────────────────────────┐
│                    企业版 OpenClaw Harness 平台                │
├─────────────┬──────────┬──────────┬──────────┬──────────────┤
│  🏗️ Agent    │ 🧠 Memory │ 🛡️ Guard- │ 🎯 Orches-│ 🧩 Skill     │
│  Workspace  │ & Context│ rails    │ tration  │ Marketplace  │
│  上下文工程   │ 记忆管理  │ 安全护栏   │ 编排调度   │ 能力市场      │
├─────────────┴──────────┴──────────┴──────────┴──────────────┤
│              🔌 Multi-Channel Hub（多渠道接入）                 │
│     飞书 │ 钉钉 │ 企微 │ Telegram │ Slack │ Discord │ …      │
├─────────────────────────────────────────────────────────────┤
│              🤖 Multi-Model Engine（多模型引擎）                │
│   OpenAI │ Anthropic │ Google │ 智谱 │ MiniMax │ 私有部署 │ …   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 模块 1：Agent Workspace（上下文工程）

**解决的问题**：Agent 为什么答得不好？因为它的上下文是乱的。

**产品能力**：

| 能力 | 说明 | 技术基础 |
|------|------|---------|
| **Workspace 模板** | 按行业/场景提供预设模板（客服、研发、运维、销售） | AGENTS.md + SOUL.md + USER.md 多文件体系 |
| **上下文预算仪表盘** | 可视化展示每个 Agent 的上下文窗口占用情况 | `/context list` + bootstrapMaxChars 限制 |
| **渐进式知识加载** | 技能描述轻量注入（~97字符/skill），完整指令按需获取 | Skills 系统 + `read SKILL.md` 按需加载 |
| **多文件人格定义** | 指令、人格、用户画像、工具配置彻底分离 | 7 个 Workspace 文件各司其职 |
| **Project Context 编辑器** | 在线编辑 Agent 的 Workspace 文件 | Workspace 文件热更新 |

**客户价值表达**：

> *"你的 Agent 回答不准确，不是模型的问题——是 Agent 的'大脑环境'没管好。我们帮每个 Agent 建立结构化的工作空间，让它像一个有桌面、有文件柜、有操作手册的员工一样工作。"*

**Workspace 文件体系**（客户可配置）：

```
每个 Agent 的 Workspace/
├── AGENTS.md    ← 操作手册：Agent 的职责、流程、规则
├── SOUL.md      ← 人格定义：语调、边界、行为准则
├── IDENTITY.md  ← 身份信息：姓名、角色
├── USER.md      ← 用户画像：偏好、背景
├── TOOLS.md     ← 环境笔记：本地工具、API 配置
├── MEMORY.md    ← 长期记忆：策划的持久知识
├── HEARTBEAT.md ← 心跳任务：周期性检查清单
└── BOOTSTRAP.md ← 启动仪式：首次运行初始化
```

**与竞品对比**：

| 能力 | Dify | Coze | **企业版 OpenClaw** |
|------|------|------|-------------------|
| Agent 指令 | 单一 System Prompt | 单一 System Prompt | **7 个分离文件，各有加载规则** |
| 上下文可见性 | 无 | 基础 | **完整预算仪表盘** |
| 知识加载 | 全量灌入 | 全量灌入 | **渐进式按需加载** |
| 人格分离 | 不支持 | 不支持 | **独立 SOUL.md** |

---

### 3.3 模块 2：Memory & Context（记忆管理）

**解决的问题**：Agent 每次对话都从零开始，没有"经验"。

**产品能力**：

| 能力 | 说明 | 技术基础 |
|------|------|---------|
| **持久化记忆** | Agent 跨会话记住关键信息 | MEMORY.md + memory/YYYY-MM-DD.md |
| **语义检索** | 自然语言搜索历史记忆 | memory_search（向量 + BM25 混合搜索） |
| **自动记忆冲刷** | 上下文接近满时自动保存关键信息 | Pre-compaction memory flush |
| **无损上下文压缩** | 长对话压缩但不丢失，随时可回溯精确细节 | LCM（摘要 DAG + 原文索引） |
| **时间衰减排序** | 新记忆自然排名更高（半衰期 30 天） | Temporal Decay 指数衰减 |
| **记忆去重** | 避免返回语义近似的重复记忆 | MMR（Maximal Marginal Relevance） |

**五层记忆架构**：

```
┌─────────────────────────────────────────────┐
│     Layer 1: 工作记忆（Working Memory）        │
│     当前对话上下文窗口内的内容                    │
│     生命周期：当前对话                           │
├─────────────────────────────────────────────┤
│     Layer 2: 会话记忆（Session Memory）         │
│     Session Store + Transcript（树状日志）       │
│     生命周期：会话存续期                          │
├─────────────────────────────────────────────┤
│     Layer 3: 持久记忆（Persistent Memory）      │
│     MEMORY.md + memory/YYYY-MM-DD.md          │
│     生命周期：永久（手动策划 + 自动冲刷）          │
├─────────────────────────────────────────────┤
│     Layer 4: 语义检索（Semantic Retrieval）      │
│     向量索引 + BM25 关键词 + 时间衰减 + MMR       │
│     生命周期：永久 + 按需召回                     │
├─────────────────────────────────────────────┤
│     Layer 5: 无损压缩（LCM）                    │
│     摘要 DAG + 原文索引，lcm_grep/expand 回溯    │
│     生命周期：永久 + 随时可恢复精确上下文           │
└─────────────────────────────────────────────┘
```

**客户价值表达**：

> *"你的客服 Agent 记不住用户上周说过什么？我们的五层记忆系统让 Agent 像一个有经验的老员工——记得住重要的事，忘得掉不重要的事，需要时随时回忆细节。"*

**核心创新：自动记忆冲刷**

这是竞品都没有的能力：

```
对话进行中 → 上下文接近满 → 触发 soft threshold →
静默 Agent turn（用户无感知）→ 自动写入 memory/YYYY-MM-DD.md →
NO_REPLY（不产生输出）→ 执行压缩 → 新的干净上下文继续工作
```

| 方案 | Anthropic (claude-progress.txt) | Dify (RAG) | **企业版 OpenClaw** |
|------|-------------------------------|-----------|-------------------|
| 跨会话记忆 | 手动写文件 | 知识库检索 | **自动冲刷 + 语义搜索** |
| 检索方式 | 全量读取 | 向量搜索 | **混合搜索（向量+BM25+时间衰减）** |
| 压缩 | 有损摘要 | 无 | **LCM 无损（摘要+原文索引）** |
| 上下文满处理 | Agent 自己决定 | 截断 | **自动冲刷后干净继续** |

---

### 3.4 模块 3：Guardrails（安全护栏）

**解决的问题**：企业不敢用 Agent——怕它做错事、泄露数据、越权操作。

**产品能力**：

| 能力 | 说明 | 技术基础 |
|------|------|---------|
| **分层工具策略** | 声明式定义 Agent 可用的工具 | Tool Policy（allow / deny / elevated） |
| **命令审批** | 关键操作需人类确认后执行 | Exec Approvals（allow-once / allow-always / deny） |
| **沙箱隔离** | Agent 在独立 Docker 容器中执行 | Sandbox（mode: off/non-main/all，scope: session/agent/shared） |
| **安全命令白名单** | 系统命令级别的参数控制 | Safe Bins（jq/grep/sort 等，flag 白名单+黑名单） |
| **接入控制** | 谁可以和 Agent 对话 | DM Policy（pairing/allowlist/open/disabled） |
| **审计追踪** | 每一步操作可回溯 | Session Transcript + 审计日志 |

**五层纵深防御模型**：

```
Layer 1: Tool Policy（声明式）
    │ "这个 Agent 只能用 read、write、web_search"
    │ allow: ["read", "write", "web_search"]
    │ deny: ["exec", "browser", "message"]
    ▼
Layer 2: Exec Approvals（运行时门控）
    │ "即使允许 exec，这条命令需要人类批准"
    │ security: allowlist → 未批准命令阻断
    ▼
Layer 3: Sandbox（环境隔离）
    │ "Agent 的所有操作在 Docker 容器内执行"
    │ workspaceAccess: ro → 只能读不能写宿主文件
    │ network: none → 默认无出站网络
    ▼
Layer 4: Safe Bins（命令参数级）
    │ "即使允许 grep，也不能用 --include 读任意文件"
    │ 每个命令有独立的 allowedValueFlags / deniedFlags
    ▼
Layer 5: Pairing & DM Policy（接入层）
    │ "谁可以和 Agent 说话？"
    │ pairing: 新用户需要审批码
    │ allowlist: 只允许白名单内用户
    └── open: 公开访问（需明确配置 "*"）
```

**客户价值表达**：

> *"Agent 能做什么、不能做什么，全部白纸黑字。不是'告诉 Agent 别做'（prompt 约束），而是'从系统层面让它做不了'（机械执行）。出了任何事，每一步操作都有审计日志可追溯。"*

**关键区分：Prompt 约束 vs 机械执行**

```
❌ Prompt 约束（Dify/Coze 的做法）:
   System Prompt: "你不能删除用户数据"
   → Agent 可能被 prompt injection 绕过
   → 没有强制执行机制

✅ 机械执行（企业版 OpenClaw 的做法）:
   Tool Policy: deny: ["exec"]
   → 工具层面根本不提供 exec
   → 无论 prompt 怎么写，Agent 物理上无法执行命令
```

**企业安全审计清单**（内置）：

| 检查项 | 级别 | 说明 |
|-------|------|------|
| Gateway 绑定公网无认证 | 🔴 Critical | 必须设置 auth token |
| 状态目录全局可写 | 🔴 Critical | 修复文件权限 |
| 配置文件全局可读 | 🔴 Critical | 可能泄露 API key |
| 开放群组启用了 elevated/runtime | 🔴 Critical | 收缩权限 |
| Control UI 跳过设备认证 | 🟡 High | 启用 device auth |
| Hooks token 过短 | 🟡 Warn | 增加 token 长度 |
| 日志未脱敏 | 🟡 Warn | 启用 redact |
| 沙箱配置模式关闭 | 🟡 Warn | 启用沙箱 |

---

### 3.5 模块 4：Orchestration（编排调度）

**解决的问题**：复杂任务一个 Agent 搞不定，需要分工协作。

**产品能力**：

| 能力 | 说明 | 技术基础 |
|------|------|---------|
| **子代理** | 后台并行执行任务，完成后自动汇报 | sessions_spawn + announce |
| **ACP 集成** | 对接 Claude Code / Codex / Gemini CLI 等外部 Agent | ACP runtime（acpx 后端） |
| **定时任务** | 精确调度 + 会话隔离 + 多种交付模式 | Cron 系统（at/every/cron 三种调度） |
| **事件驱动** | 消息到达、命令触发、Gateway 启动自动响应 | Hooks 系统 |
| **嵌套编排** | 协调者 → 编排者 → 执行者三层架构 | maxSpawnDepth: 2 |
| **心跳监控** | 周期性检查 + 无事则静 + 有事则报 | Heartbeat 系统 |
| **跨会话通信** | Agent 之间互发消息 | sessions_send + sessions_history |

**编排架构**：

```
┌─── 协调者 Agent (main) ─────────────────────────┐
│                                                  │
│  ┌── Sub-agent 1 ──┐  ┌── Sub-agent 2 ──┐      │
│  │ 研究 Agent       │  │ 编码 Agent       │      │
│  │ (wairesearch)   │  │ (waicode)        │      │
│  └─────────────────┘  └─────────────────┘      │
│                                                  │
│  ┌── ACP Session ──┐  ┌── Cron Job ──────┐     │
│  │ Claude Code     │  │ 每日报告生成       │     │
│  │ (thread-bound)  │  │ (isolated session)│     │
│  └─────────────────┘  └─────────────────┘      │
│                                                  │
│  ┌── Hook ─────────┐  ┌── Heartbeat ────┐      │
│  │ 新消息触发分析    │  │ 每 30 分钟检查    │      │
│  │ (event-driven)  │  │ (periodic check) │      │
│  └─────────────────┘  └─────────────────┘      │
└──────────────────────────────────────────────────┘
```

**客户价值表达**：

> *"一个 Agent 不够用？我们支持 Agent 团队协作——研究员 Agent 负责查资料，编码 Agent 负责写代码，QA Agent 负责测试，协调者 Agent 负责分工和汇总。自动分工、自动汇报、自动监控。"*

**定时任务系统特性**：

| 能力 | 说明 |
|------|------|
| 三种调度 | `at`（一次性）、`every`（固定间隔）、`cron`（5/6 字段表达式 + 时区） |
| 会话隔离 | 每次执行创建独立会话 `cron:<jobId>:run:<uuid>` |
| 交付模式 | announce（推送到频道）、webhook（HTTP POST）、none（仅内部） |
| 错误恢复 | 瞬态错误自动重试（指数退避 30s→1m→5m→15m→60m）、永久错误自动禁用 |
| 启动补执行 | Gateway 重启后自动执行遗漏的到期任务 |
| 会话清理 | 执行会话 24h 后自动清理（可配置） |

---

### 3.6 模块 5：Skill Marketplace（能力市场）

**解决的问题**：Agent 需要新能力时，要重新开发吗？

**产品能力**：

| 能力 | 说明 | 技术基础 |
|------|------|---------|
| **公开技能商店** | 浏览、搜索、一键安装社区技能 | ClawHub Registry |
| **企业私有技能库** | 企业内部共享技能，不公开 | Workspace Skills + extraDirs |
| **依赖门控** | 缺少依赖的技能自动不加载 | requires.bins / env / config |
| **热加载** | 安装即生效，无需重启 Gateway | Skills Watcher |
| **7 层加载优先级** | 精确控制哪个技能版本生效 | 加载优先级体系 |
| **Per-Agent 过滤** | 不同 Agent 看到不同技能 | config.skills.filter |

**技能加载优先级**（从高到低）：

```
7. Workspace skills (workspace/skills)          ← 最高：项目定制
6. Project agent skills (workspace/.agents/skills)
5. Personal agent skills (~/.agents/skills)
4. Managed skills (~/.openclaw/skills)           ← ClawHub 安装目录
3. Bundled skills (npm 包自带)
2. Plugin skill dirs
1. extraDirs (config 指定)                       ← 最低：额外目录
```

**门控过滤**（自动检测环境）：

```yaml
# 技能元数据示例
metadata:
  openclaw:
    requires:
      bins: ["uv"]               # PATH 中必须有 uv 命令
      env: ["GEMINI_API_KEY"]    # 必须设置 Gemini API key
      config: ["browser.enabled"] # 必须启用浏览器功能
    os: ["darwin", "linux"]       # 仅 macOS 和 Linux
```

→ 缺少任何依赖的技能**自动过滤**，不会出现在 Agent 的技能列表中。

**客户价值表达**：

> *"Agent 需要查天气？装个 skill。需要读 PDF？装个 skill。需要搜索 X/Twitter？装个 skill。3 秒搞定，即装即用。企业还可以建自己的私有技能库，团队内部共享。"*

---

## 第四章：多渠道 + 多模型——底层差异化

### 4.1 多渠道原生支持

企业不只用一个 IM 工具。企业版 OpenClaw 原生支持 10+ 渠道：

| 渠道 | 支持方式 | 特殊能力 |
|------|---------|---------|
| **飞书 (Feishu/Lark)** | WebSocket Bot | 交互式卡片、审批流、话题隔离 |
| **钉钉 (DingTalk)** | 消息推送 | 异步模式、文件解析（Word/PDF） |
| **企业微信 (WeCom)** | 自研插件 | 多账号管理、QR 扫码登录 |
| **Telegram** | Bot API | 论坛话题绑定、Markdown 渲染 |
| **Discord** | Bot | 线程绑定、ACP 会话 |
| **Slack** | App | 频道路由、工作区隔离 |
| **WhatsApp** | Web API | 语音转文字、媒体处理 |
| **Signal** | 协议支持 | 端到端加密 |
| **WebChat** | 内置 | 嵌入网页、控制台 UI |
| **自定义** | Plugin SDK | 任何 IM/API 可接入 |

**关键能力**：一个 Agent 可以同时在多个渠道工作，共享记忆和上下文。

### 4.2 多模型 Provider 无关

不锁定任何一家模型厂商：

```json5
{
  agents: {
    defaults: {
      model: {
        primary: "anthropic/claude-opus-4-6",      // 主模型
        fallbacks: ["openai/gpt-5", "zai/glm-5"]  // 兜底
      }
    }
  }
}
```

**模型配置优先级**（从高到低）：

```
① /model 会话覆盖（用户在聊天中切换）
② channels.modelByChannel（按频道/群组指定）
③ agents.list[].model（per-agent 配置）
④ agents.defaults.model.primary（全局默认）
⑤ agents.defaults.model.fallbacks（兜底列表）
```

**支持的模型厂商**：OpenAI、Anthropic、Google（Vertex AI + AI Studio）、智谱 (Z.AI)、MiniMax、DeepSeek、Ollama（本地）、OpenRouter（聚合）、Amazon Bedrock、Azure OpenAI、自定义 Provider。

---

## 第五章：多租户架构——SaaS 化的关键

### 5.1 架构选择

OpenClaw Gateway 的认证模型是"全有或全无"——一个 Gateway 内所有用户都是 operator 权限。因此多租户需要：

**推荐方案：每租户独立 Gateway**

```
┌───────────────────────────────────────┐
│            SaaS API Layer              │
│   (认证、计费、租户路由、配置管理)        │
├───────────┬───────────┬───────────────┤
│ Gateway A │ Gateway B │ Gateway C     │
│ 租户 1    │ 租户 2    │ 租户 3        │
│ 端口 19001│ 端口 19002│ 端口 19003    │
│ 独立配置   │ 独立配置   │ 独立配置      │
│ 独立凭证   │ 独立凭证   │ 独立凭证      │
└───────────┴───────────┴───────────────┘
```

**优势**：
- 完全隔离：租户之间零数据泄露风险
- 独立配置：每个租户可以有不同的模型、渠道、技能
- 独立升级：可以灰度升级单个租户
- 故障隔离：一个租户的问题不影响其他租户

### 5.2 SaaS API Layer 职责

| 职责 | 说明 |
|------|------|
| **租户管理** | 注册、配置、计费 |
| **Gateway 生命周期** | 创建、启动、停止、重启、销毁 |
| **配置分发** | 将租户配置渲染为 openclaw.json，分发到对应 Gateway |
| **认证代理** | trusted-proxy 模式，SaaS 层做认证后转发到 Gateway |
| **健康监控** | 监控所有 Gateway 状态，自动重启异常实例 |
| **用量采集** | 收集 token 用量、API 调用、存储用量，用于计费 |
| **日志聚合** | 统一收集所有 Gateway 日志 |

---

## 第六章：落地路径

### 6.1 分阶段交付

```
Phase 1（MVP，4-6 周）
├── Workspace 模块：模板 + 编辑器 + 上下文可视化
├── Guardrails 模块：Tool Policy + Exec Approvals + Pairing
├── Memory 模块：MEMORY.md + memory_search + 自动冲刷
└── 目标：解决"Agent 不好用"和"企业不敢用"

Phase 2（增长，4-6 周）
├── Orchestration 模块：Sub-agents + Cron + Hooks
├── Skill Marketplace：ClawHub 集成 + 企业私有库
├── 多渠道：飞书 + 钉钉 + 企微全面支持
└── 目标：解决"复杂任务"和"能力扩展"

Phase 3（企业级，持续）
├── 多租户 SaaS 架构
├── 管理控制台（Web UI）
├── 审计报表 + 合规
├── SSO / RBAC
└── 目标：大企业可采购
```

### 6.2 目标客户优先级

| 优先级 | 客户类型 | 痛点 | 切入模块 |
|-------|---------|------|---------|
| **P0** | 已用 Dify/Coze 但不满意 | Agent 不稳定、上下文乱、记不住 | Memory + Workspace |
| **P1** | 已用 LangChain 但治理累 | 自己搭护栏太复杂 | Guardrails + Workspace |
| **P2** | 想用 Agent 但不敢用 | 安全顾虑、合规要求 | Guardrails + 审计 |
| **P3** | 多渠道多 Agent 需求 | IM 碎片化、协作复杂 | Multi-Channel + Orchestration |

### 6.3 定价思路（参考）

| 层级 | 目标客户 | 核心能力 | 参考价格 |
|------|---------|---------|---------|
| **Starter** | 小团队 | Workspace + Memory + 2 渠道 | ¥999/月 |
| **Professional** | 中型企业 | + Guardrails + Orchestration + 全渠道 | ¥4,999/月 |
| **Enterprise** | 大企业 | + 多租户 + SSO/RBAC + 审计 + SLA | 面议 |

（仅参考框架，具体定价需要市场验证）

---

## 第七章：技术基础评估

### 7.1 OpenClaw 已具备的能力 vs 需要新建的能力

| 能力 | 状态 | 工作量 |
|------|------|--------|
| 7 文件 Workspace 体系 | ✅ 已有 | 需要 Web 编辑器 |
| 5 层记忆架构 | ✅ 已有 | 需要可视化面板 |
| 5 层安全护栏 | ✅ 已有 | 需要配置 UI |
| 多 Agent 编排 | ✅ 已有 | 需要编排可视化 |
| Cron 定时任务 | ✅ 已有 | 需要任务管理 UI |
| Skills 系统 | ✅ 已有 | 需要企业私有库管理 |
| 10+ 渠道支持 | ✅ 已有 | 飞书/钉钉已验证 |
| 多模型支持 | ✅ 已有 | 无需额外开发 |
| 多租户隔离 | 🟡 架构就绪 | 需要 SaaS API Layer |
| Web 管理控制台 | 🟡 Control UI 基础 | 需要企业级重构 |
| SSO / RBAC | 🔴 未有 | 需要新建 |
| 计费系统 | 🔴 未有 | 需要新建 |
| 审计报表 | 🟡 日志已有 | 需要报表 UI |

### 7.2 核心优势

1. **底层能力已完备**：不是从零开始，是从 80% 开始
2. **Harness 叙事新颖**：市场上还没有人用 Harness Engineering 做产品定位
3. **多渠道是壁垒**：中国企业需要飞书 + 钉钉 + 企微，竞品大多只支持 API
4. **Provider 无关是卖点**：不锁模型厂商，企业可以随时换
5. **开源社区背书**：OpenClaw 开源社区活跃，降低客户信任门槛

---

## 附录：核心术语对照表

| 英文术语 | 中文翻译 | 在企业版中的对应 |
|---------|---------|---------------|
| Harness | 线束 / 运行环境 | 企业版 OpenClaw 平台 |
| Agent Workspace | Agent 工作空间 | Workspace 模块 |
| Context Engineering | 上下文工程 | Workspace + Skills 渐进加载 |
| Guardrails | 安全护栏 | Guardrails 模块 |
| Lossless Context Management | 无损上下文管理 | LCM 系统 |
| Pre-compaction Memory Flush | 压缩前记忆冲刷 | Memory 模块自动冲刷 |
| Tool Policy | 工具策略 | Guardrails 声明式规则 |
| Exec Approvals | 命令审批 | Guardrails 运行时门控 |
| Safe Bins | 安全命令 | Guardrails 命令白名单 |
| Skills | 技能 | Skill Marketplace |
| ClawHub | 技能注册表 | 公开技能商店 |
| Sub-agents | 子代理 | Orchestration 模块 |
| ACP (Agent Collaboration Protocol) | Agent 协作协议 | 外部 Agent 集成 |
| Heartbeat | 心跳 | 周期性健康检查 |
| Cron | 定时任务 | Orchestration 定时调度 |

---

*文档由 wairesearch (黄山) 生成 | 2026-03-26 | v1.0*
*基于 Harness Engineering 深度分析报告 v1.1 + OpenClaw 源码研究 + 市场竞品分析*
