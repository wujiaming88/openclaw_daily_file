# 基于 OpenClaw 的 SaaS 平台自动化验证方案

> **版本**: v1.0  
> **日期**: 2026-03-18  
> **作者**: 黄山 (wairesearch)  
> **状态**: 方案设计阶段

---

## 目录

1. [背景与目标](#1-背景与目标)
2. [整体架构](#2-整体架构)
3. [核心设计原则](#3-核心设计原则)
4. [系统组成](#4-系统组成)
5. [验证维度与用例设计](#5-验证维度与用例设计)
6. [技术实现详解](#6-技术实现详解)
7. [触发机制](#7-触发机制)
8. [报告与通知](#8-报告与通知)
9. [实施路径](#9-实施路径)
10. [风险与应对](#10-风险与应对)
11. [附录](#11-附录)

---

## 1. 背景与目标

### 1.1 背景

基于 OpenClaw 搭建的 SaaS 平台，面向多用户提供 AI Agent 服务，用户通过飞书 Channel 与平台交互。平台持续迭代演进，每次发布都存在引入回归问题的风险。

### 1.2 目标

搭建一套**自动化验证系统**，在每次发布后能够：

- ✅ 自动验证平台核心功能可用性
- ✅ 验证飞书通道端到端连通性
- ✅ 验证 LLM 调用链路正常
- ✅ 验证多租户数据隔离
- ✅ 生成结构化验证报告
- ✅ 将验证结果推送到飞书群

### 1.3 约束条件

| 约束 | 说明 |
|------|------|
| 用户入口 | 飞书 Channel |
| 核心功能 | 多租户 Agent 管理、技能市场、AI 对话 |
| 发布流程 | CI/CD |
| 触发方式 | 手动触发（优先），后续可扩展为自动触发 |
| 验证层面 | 功能层 + 集成层 |

---

## 2. 整体架构

### 2.1 架构总览

```
┌─────────────────────────────────────────────────────────────────┐
│                          触发层                                  │
│                                                                  │
│   ┌────────────┐   ┌────────────┐   ┌────────────┐             │
│   │ CLI 手动   │   │ CI/CD      │   │ 飞书消息   │             │
│   │ 触发       │   │ Webhook    │   │ 触发       │             │
│   └─────┬──────┘   └─────┬──────┘   └─────┬──────┘             │
│         └────────────────┼────────────────┘                     │
└──────────────────────────┼──────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                    验证编排层 (qa-orchestrator)                    │
│                                                                   │
│   ┌─────────────────────────────────────────────────────────┐    │
│   │  1. 加载测试套件 (test-suites.yaml)                      │    │
│   │  2. 解析环境变量 → 注入测试参数                           │    │
│   │  3. 按 priority 排序                                     │    │
│   │  4. 顺序执行各验证套件                                    │    │
│   │  5. 收集结果 → 生成报告                                   │    │
│   │  6. 推送飞书 → 回调 CI/CD                                │    │
│   └─────────────────────────────────────────────────────────┘    │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                       验证执行层                                  │
│                                                                   │
│   ┌──────────────────────┐   ┌──────────────────────┐           │
│   │   API 验证器          │   │   飞书 E2E 验证器     │           │
│   │                       │   │                       │           │
│   │  • HTTP 请求          │   │  • 飞书发消息          │           │
│   │  • 状态码检查          │   │  • 等待回复            │           │
│   │  • 响应体断言          │   │  • 内容匹配            │           │
│   │  • 延迟测量            │   │  • 超时检测            │           │
│   └──────────────────────┘   └──────────────────────┘           │
│                                                                   │
│   ┌──────────────────────┐   ┌──────────────────────┐           │
│   │   健康检查器          │   │   数据隔离验证器       │           │
│   │                       │   │                       │           │
│   │  • Gateway 状态       │   │  • 跨租户访问测试      │           │
│   │  • Channel 连通       │   │  • 权限边界验证        │           │
│   │  • LLM Provider 可达  │   │  • 数据泄漏检测        │           │
│   └──────────────────────┘   └──────────────────────┘           │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                       报告与通知层                                 │
│                                                                   │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│   │ Markdown      │  │ JSON         │  │ 飞书群通知    │          │
│   │ 验证报告      │  │ 机器可读      │  │ 实时推送      │          │
│   └──────────────┘  └──────────────┘  └──────────────┘          │
└──────────────────────────────────────────────────────────────────┘
```

### 2.2 核心思路：验证者与被测者分离

```
┌──────────────────────┐          ┌──────────────────────┐
│   验证者 OpenClaw     │          │   被测 SaaS 平台      │
│   (独立实例)          │          │   (生产/预发环境)      │
│                       │          │                       │
│   qa-orchestrator ────┼── API ──→│   REST API            │
│                       │          │                       │
│   feishu-tester ──────┼── 飞书 ─→│   飞书 Bot            │
│                       │          │                       │
│   health-checker ─────┼── HTTP ─→│   健康端点             │
└──────────────────────┘          └──────────────────────┘
```

**为什么分离？**

- 避免"自己测自己"的循环依赖
- 被测平台故障不影响验证系统
- 验证者可同时测试多个环境（staging / production）

---

## 3. 核心设计原则

| 原则 | 说明 |
|------|------|
| **独立性** | 验证系统与被测系统完全隔离部署 |
| **可声明** | 测试用例以 YAML 声明，非硬编码 |
| **可扩展** | 新增验证场景只需添加 YAML 配置 |
| **快速反馈** | 验证过程实时通报进展，不闷头执行 |
| **容错兜底** | 所有步骤设超时，单个失败不阻塞全局 |
| **可追溯** | 每次验证生成唯一报告，支持历史对比 |

---

## 4. 系统组成

### 4.1 Agent 角色设计

| Agent ID | 角色 | 职责 |
|----------|------|------|
| `qa-orchestrator` | 验证编排器 | 加载用例、编排执行、收集结果、生成报告 |
| `feishu-tester` | 飞书 E2E 测试器 | 模拟用户通过飞书与 SaaS Bot 交互 |
| `api-tester` | API 测试器 | 直接调用 SaaS 平台 REST API 验证功能 |
| `health-checker` | 健康检查器 | 验证基础设施健康（Gateway、Channel、LLM） |

> **注意**: 初期可以只用 `qa-orchestrator` 一个 Agent 完成所有验证。随着用例增多，再拆分为多 Agent 并行执行。

### 4.2 目录结构

```
~/.openclaw/workspace-qa/                    ← 验证者工作空间
├── SOUL.md                                  ← qa-orchestrator 人格定义
├── AGENTS.md                                ← Agent 角色定义
├── MEMORY.md                                ← 验证历史记录
│
├── config/                                  ← 配置
│   ├── environments.yaml                    ← 环境配置（staging/prod URL 等）
│   └── test-suites.yaml                     ← 测试用例声明
│
├── scripts/                                 ← 验证脚本
│   ├── api-verify.sh                        ← API 验证辅助脚本
│   ├── feishu-e2e.sh                        ← 飞书 E2E 辅助脚本
│   └── report-gen.sh                        ← 报告生成脚本
│
├── test-assets/                             ← 测试素材
│   ├── sample-image.png                     ← 图片消息测试用
│   ├── sample-file.pdf                      ← 文件消息测试用
│   └── test-prompts.txt                     ← 标准测试 prompt
│
├── reports/                                 ← 历史报告归档
│   ├── 2026-03-18-1400/
│   │   ├── report.md
│   │   └── summary.json
│   └── 2026-03-19-0900/
│       ├── report.md
│       └── summary.json
│
└── hooks/                                   ← 自定义 hooks
    └── verify-trigger/                      ← 飞书消息触发验证
        ├── HOOK.md
        └── handler.ts
```

### 4.3 环境配置

```yaml
# config/environments.yaml

environments:
  staging:
    name: "预发布环境"
    api_base: "https://staging-api.your-saas.com"
    feishu_bot_id: "cli_staging_xxx"
    feishu_test_group: "oc_staging_test"
    health_endpoint: "https://staging-api.your-saas.com/health"

  production:
    name: "生产环境"
    api_base: "https://api.your-saas.com"
    feishu_bot_id: "cli_prod_xxx"
    feishu_test_group: "oc_prod_test"
    health_endpoint: "https://api.your-saas.com/health"

# 默认验证环境
default_env: staging

# 公共配置
global:
  timeout_default: 30s        # 默认超时
  timeout_llm: 60s            # LLM 相关超时（模型推理较慢）
  retry_count: 2              # 失败重试次数
  cleanup_after_test: true    # 测试后清理测试数据
```

---

## 5. 验证维度与用例设计

### 5.1 验证矩阵

```
                    ┌──────────────────────────────────────┐
                    │            验证维度                    │
                    ├──────────┬───────────┬────────────────┤
                    │ 功能层    │ 集成层    │ 数据层          │
    ┌───────────────┼──────────┼───────────┼────────────────┤
    │ Agent 管理    │ CRUD     │ 飞书创建  │ 租户隔离        │
    │ 对话功能      │ 回复质量 │ E2E对话   │ 会话隔离        │
    │ 技能市场      │ 安装/卸载│ 技能调用  │ 技能权限        │
    │ 用户管理      │ 注册/登录│ 飞书授权  │ 用户数据隔离    │
    │ LLM 链路      │ 调用成功 │ 多模型切换│ Token 计费      │
    └───────────────┴──────────┴───────────┴────────────────┘
```

### 5.2 测试套件定义

```yaml
# config/test-suites.yaml

# ============================================================
# 全局配置
# ============================================================
config:
  version: "1.0"
  description: "SaaS 平台自动化验证用例"

# ============================================================
# 测试套件
# ============================================================
suites:

  # ----------------------------------------------------------
  # Suite 1: 基础健康检查 (P0 - 最先执行)
  # ----------------------------------------------------------
  - name: "基础健康检查"
    id: suite-health
    priority: P0
    description: "验证平台基础设施可用性"
    tests:

      - id: health-001
        name: "API 服务存活"
        type: api
        critical: true        # critical=true 失败则终止后续套件
        steps:
          - action: http_request
            method: GET
            url: "{{health_endpoint}}"
            expect:
              status: 200
              body_contains: ["ok", "healthy"]
            timeout: 10s

      - id: health-002
        name: "Gateway 状态"
        type: api
        critical: true
        steps:
          - action: http_request
            method: GET
            url: "{{api_base}}/gateway/status"
            headers:
              Authorization: "Bearer {{admin_token}}"
            expect:
              status: 200
              json_path:
                "$.status": "running"
                "$.channels.feishu.connected": true
            timeout: 10s

      - id: health-003
        name: "LLM Provider 可达"
        type: api
        steps:
          - action: http_request
            method: POST
            url: "{{api_base}}/llm/ping"
            headers:
              Authorization: "Bearer {{admin_token}}"
            expect:
              status: 200
              json_path:
                "$.providers[*].status": "available"
            timeout: 15s

  # ----------------------------------------------------------
  # Suite 2: 飞书通道连通 (P0)
  # ----------------------------------------------------------
  - name: "飞书通道连通"
    id: suite-feishu
    priority: P0
    description: "验证飞书 Channel 端到端通信"
    depends_on: suite-health
    tests:

      - id: feishu-001
        name: "文本消息收发"
        type: e2e
        critical: true
        steps:
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message: "[QA-VERIFY] ping {{run_id}}"
          - action: feishu_wait_reply
            timeout: 30s
            expect:
              reply_received: true
              # 只要收到回复就算通过，不限定内容
          - action: record
            metrics:
              - name: "reply_latency"
                value: "{{actual_reply_time}}"

      - id: feishu-002
        name: "图片消息处理"
        type: e2e
        steps:
          - action: feishu_send_image
            target: "{{feishu_bot_id}}"
            image: "test-assets/sample-image.png"
            caption: "[QA-VERIFY] 请描述这张图片"
          - action: feishu_wait_reply
            timeout: 60s
            expect:
              reply_received: true
              reply_min_length: 10   # 回复至少10字，说明图片被处理了

      - id: feishu-003
        name: "长文本消息"
        type: e2e
        steps:
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message_file: "test-assets/long-text-prompt.txt"
          - action: feishu_wait_reply
            timeout: 60s
            expect:
              reply_received: true

  # ----------------------------------------------------------
  # Suite 3: Agent 管理功能 (P0)
  # ----------------------------------------------------------
  - name: "Agent 管理功能"
    id: suite-agent-crud
    priority: P0
    description: "验证 Agent 的创建、查询、更新、删除"
    depends_on: suite-health
    tests:

      - id: agent-001
        name: "创建 Agent"
        type: api
        steps:
          - action: http_request
            method: POST
            url: "{{api_base}}/agents"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            body:
              name: "qa-test-agent-{{run_id}}"
              description: "自动化验证临时 Agent"
              model: "default"
            expect:
              status: [200, 201]
              json_path:
                "$.id": "{{save_as:created_agent_id}}"
                "$.name": "qa-test-agent-{{run_id}}"
            timeout: 15s

      - id: agent-002
        name: "查询 Agent"
        type: api
        depends_on: agent-001
        steps:
          - action: http_request
            method: GET
            url: "{{api_base}}/agents/{{created_agent_id}}"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            expect:
              status: 200
              json_path:
                "$.id": "{{created_agent_id}}"
                "$.name": "qa-test-agent-{{run_id}}"
            timeout: 10s

      - id: agent-003
        name: "更新 Agent"
        type: api
        depends_on: agent-001
        steps:
          - action: http_request
            method: PUT
            url: "{{api_base}}/agents/{{created_agent_id}}"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            body:
              description: "已更新-{{run_id}}"
            expect:
              status: 200
              json_path:
                "$.description": "已更新-{{run_id}}"
            timeout: 10s

      - id: agent-004
        name: "删除 Agent"
        type: api
        depends_on: agent-003
        cleanup: true
        steps:
          - action: http_request
            method: DELETE
            url: "{{api_base}}/agents/{{created_agent_id}}"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            expect:
              status: [200, 204]
            timeout: 10s

      - id: agent-005
        name: "确认删除生效"
        type: api
        depends_on: agent-004
        steps:
          - action: http_request
            method: GET
            url: "{{api_base}}/agents/{{created_agent_id}}"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            expect:
              status: [404, 410]
            timeout: 10s

  # ----------------------------------------------------------
  # Suite 4: AI 对话功能 (P0)
  # ----------------------------------------------------------
  - name: "AI 对话功能"
    id: suite-conversation
    priority: P0
    description: "验证 AI 对话质量和响应能力"
    depends_on: suite-health
    tests:

      - id: conv-001
        name: "基础对话能力"
        type: e2e
        steps:
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message: "[QA-VERIFY] 请只回复四个字：验证成功了"
          - action: feishu_wait_reply
            timeout: 30s
            expect:
              reply_contains: "验证成功"

      - id: conv-002
        name: "上下文连续性"
        type: e2e
        steps:
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message: "[QA-VERIFY] 请记住这个数字：42"
          - action: feishu_wait_reply
            timeout: 30s
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message: "我刚才让你记住的数字是什么？"
          - action: feishu_wait_reply
            timeout: 30s
            expect:
              reply_contains: "42"

      - id: conv-003
        name: "会话重置"
        type: e2e
        steps:
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message: "/new"
          - action: feishu_wait_reply
            timeout: 15s
            expect:
              reply_received: true

  # ----------------------------------------------------------
  # Suite 5: 多租户隔离 (P1)
  # ----------------------------------------------------------
  - name: "多租户隔离"
    id: suite-tenant-isolation
    priority: P1
    description: "验证租户间数据隔离"
    depends_on: suite-health
    tests:

      - id: tenant-001
        name: "租户 A 创建 Agent"
        type: api
        steps:
          - action: http_request
            method: POST
            url: "{{api_base}}/agents"
            headers:
              Authorization: "Bearer {{tenant_a_token}}"
            body:
              name: "tenant-a-secret-{{run_id}}"
            expect:
              status: [200, 201]
              json_path:
                "$.id": "{{save_as:tenant_a_agent_id}}"

      - id: tenant-002
        name: "租户 B 无法看到租户 A 的 Agent"
        type: api
        depends_on: tenant-001
        steps:
          - action: http_request
            method: GET
            url: "{{api_base}}/agents"
            headers:
              Authorization: "Bearer {{tenant_b_token}}"
            expect:
              status: 200
              body_not_contains: ["tenant-a-secret-{{run_id}}"]

      - id: tenant-003
        name: "租户 B 无法直接访问租户 A 的 Agent"
        type: api
        depends_on: tenant-001
        steps:
          - action: http_request
            method: GET
            url: "{{api_base}}/agents/{{tenant_a_agent_id}}"
            headers:
              Authorization: "Bearer {{tenant_b_token}}"
            expect:
              status: [403, 404]

      - id: tenant-004
        name: "清理租户 A 测试数据"
        type: api
        depends_on: tenant-002
        cleanup: true
        steps:
          - action: http_request
            method: DELETE
            url: "{{api_base}}/agents/{{tenant_a_agent_id}}"
            headers:
              Authorization: "Bearer {{tenant_a_token}}"
            expect:
              status: [200, 204]

  # ----------------------------------------------------------
  # Suite 6: 技能市场 (P1)
  # ----------------------------------------------------------
  - name: "技能市场功能"
    id: suite-skills
    priority: P1
    description: "验证技能的浏览、安装、调用"
    depends_on: suite-health
    tests:

      - id: skill-001
        name: "技能列表可访问"
        type: api
        steps:
          - action: http_request
            method: GET
            url: "{{api_base}}/skills"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            expect:
              status: 200
              json_path:
                "$.skills": "{{is_array}}"
                "$.skills.length()": "{{greater_than:0}}"

      - id: skill-002
        name: "技能安装"
        type: api
        steps:
          - action: http_request
            method: POST
            url: "{{api_base}}/skills/install"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            body:
              skill_id: "{{test_skill_id}}"
            expect:
              status: [200, 201]

      - id: skill-003
        name: "技能在对话中可调用"
        type: e2e
        depends_on: skill-002
        steps:
          - action: feishu_send
            target: "{{feishu_bot_id}}"
            message: "[QA-VERIFY] 查一下今天北京的天气"
          - action: feishu_wait_reply
            timeout: 60s
            expect:
              reply_received: true
              reply_min_length: 20   # 有实质内容的回复

  # ----------------------------------------------------------
  # Suite 7: LLM 调用链路 (P1)
  # ----------------------------------------------------------
  - name: "LLM 调用链路"
    id: suite-llm
    priority: P1
    description: "验证多模型切换与调用"
    depends_on: suite-health
    tests:

      - id: llm-001
        name: "默认模型可用"
        type: api
        steps:
          - action: http_request
            method: POST
            url: "{{api_base}}/chat/completions"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            body:
              messages:
                - role: user
                  content: "回复OK"
            expect:
              status: 200
              json_path:
                "$.choices[0].message.content": "{{not_empty}}"
            timeout: 30s

      - id: llm-002
        name: "模型切换"
        type: api
        steps:
          - action: http_request
            method: POST
            url: "{{api_base}}/chat/completions"
            headers:
              Authorization: "Bearer {{test_user_token}}"
            body:
              model: "{{alternative_model}}"
              messages:
                - role: user
                  content: "回复OK"
            expect:
              status: 200
              json_path:
                "$.choices[0].message.content": "{{not_empty}}"
            timeout: 30s
```


## 6. 技术实现详解

### 6.1 验证者 OpenClaw 实例配置

#### 6.1.1 openclaw.json（验证者实例）

```jsonc
{
  // 验证者使用独立的飞书 App 作为"测试用户"
  "channels": {
    "feishu": {
      "enabled": true,
      "accounts": {
        "qa-tester": {
          "appId": "cli_qa_tester_xxx",
          "appSecret": "xxx",
          "botName": "QA 自动验证"
        }
      }
    }
  },

  // Agent 配置
  "agents": {
    "list": [
      {
        "id": "qa-orchestrator",
        "workspace": "~/.openclaw/workspace-qa",
        "model": "anthropic/claude-sonnet-4-20250514"
      }
    ]
  },

  // Cron 配置
  "cron": {
    "enabled": true,
    "sessionRetention": "7d"    // 保留7天验证记录
  },

  // Hooks 配置
  "hooks": {
    "internal": {
      "enabled": true,
      "entries": {
        "command-logger": { "enabled": true }
      }
    }
  }
}
```

#### 6.1.2 qa-orchestrator SOUL.md

```markdown
# QA Orchestrator — 自动化验证编排器

## 身份

你是 SaaS 平台的自动化验证编排器。你的唯一职责是按照测试套件定义，
系统化地验证平台功能可用性，并生成结构化报告。

## 工作流程

收到"开始验证"指令时：

1. **初始化**
   - 生成唯一 run_id (格式: verify-YYYYMMDD-HHMM)
   - 读取 config/environments.yaml 确定目标环境
   - 读取 config/test-suites.yaml 加载用例

2. **执行验证**
   - 按 priority 排序：P0 → P1 → P2
   - 同 priority 内按 depends_on 拓扑排序
   - critical=true 的用例失败时，跳过依赖它的后续套件
   - 每个用例执行后立即记录结果

3. **进度通报**
   - 每完成一个套件，汇报进度
   - 格式："✅ 基础健康检查 通过 (3/3)" 或 "❌ 飞书通道连通 失败 (2/3)"

4. **生成报告**
   - 写入 reports/<run_id>/report.md
   - 写入 reports/<run_id>/summary.json
   - 推送摘要到飞书群

## 验证执行规范

### API 验证
使用 exec 工具执行 curl 命令：
- 始终带 -w '\n%{http_code}\n%{time_total}' 获取状态码和耗时
- 始终带 -s --max-time <timeout> 设置超时
- 解析响应 JSON 做断言

### 飞书 E2E 验证
使用 message 工具发送消息到被测 Bot：
- 发送后通过轮询或 hook 等待回复
- 记录发送时间和收到回复时间
- 比对回复内容

### 结果记录格式
每个用例记录：
- test_id, name, status (pass/fail/skip/error)
- start_time, end_time, duration_ms
- error_message (失败时)
- response_snapshot (失败时保存响应)

## 输出规范

严格按照报告模板输出，不要自由发挥。
```

### 6.2 API 验证实现

qa-orchestrator 使用 `exec` 工具调用 curl 执行 API 验证：

```bash
#!/bin/bash
# scripts/api-verify.sh
# 用法: api-verify.sh <method> <url> <token> [body_json] [timeout]

METHOD=$1
URL=$2
TOKEN=$3
BODY=$4
TIMEOUT=${5:-30}

RESPONSE=$(curl -s \
  -X "$METHOD" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  ${BODY:+-d "$BODY"} \
  --max-time "$TIMEOUT" \
  -w '\n---HTTP_CODE:%{http_code}---\n---TIME_TOTAL:%{time_total}---' \
  "$URL" 2>&1)

echo "$RESPONSE"
```

Agent 调用示例：

```
exec: bash scripts/api-verify.sh GET "https://staging-api.your-saas.com/health" "" "" 10
```

解析返回的 HTTP 状态码和响应体，做断言判定。

### 6.3 飞书 E2E 验证实现

#### 方案 A：消息工具直接验证（推荐）

```
验证流程：

1. qa-orchestrator 使用 message 工具发送消息到被测 Bot 所在的测试群
2. 被测 Bot 处理并回复
3. qa-orchestrator 通过 message hook 监听回复
4. 对比回复内容，判定通过/失败
```

实现要点：

```jsonc
// 1. 验证者发送消息到测试群（被测 Bot 也在此群中）
// 使用 message 工具：
{
  "action": "send",
  "channel": "feishu",
  "target": "oc_test_group_id",
  "message": "[QA-VERIFY-abc123] ping"
}

// 2. 通过自定义 Hook 监听指定群的消息
// hooks/verify-listener/handler.ts
// 监听 message:received 事件，过滤 [QA-VERIFY-xxx] 标记的回复

// 3. 写入结果文件供 orchestrator 读取
// /tmp/qa-verify/abc123-reply.json
```

#### 方案 B：独立测试脚本验证

如果飞书 E2E 复杂度高，可使用独立脚本通过飞书 API 直接发送/接收：

```bash
#!/bin/bash
# scripts/feishu-e2e.sh

FEISHU_APP_ID="cli_qa_xxx"
FEISHU_APP_SECRET="xxx"
TARGET_CHAT_ID="oc_test_group"
TEST_MESSAGE="[QA-VERIFY-$(date +%s)] ping"
TIMEOUT=30

# 1. 获取 tenant_access_token
TOKEN=$(curl -s -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d "{\"app_id\":\"$FEISHU_APP_ID\",\"app_secret\":\"$FEISHU_APP_SECRET\"}" \
  | jq -r '.tenant_access_token')

# 2. 发送消息
MSG_RESULT=$(curl -s -X POST "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=chat_id" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"receive_id\": \"$TARGET_CHAT_ID\",
    \"msg_type\": \"text\",
    \"content\": \"{\\\"text\\\":\\\"$TEST_MESSAGE\\\"}\"
  }")

echo "SENT: $TEST_MESSAGE"
echo "RESULT: $MSG_RESULT"

# 3. 轮询等待回复（简化版）
# 实际实现需更完善的消息监听机制
```

### 6.4 自定义 Hook：飞书回复监听器

```typescript
// hooks/verify-listener/handler.ts

import { writeFileSync, mkdirSync } from 'fs';
import { join } from 'path';

const QA_VERIFY_PREFIX = '[QA-VERIFY-';
const RESULT_DIR = '/tmp/qa-verify';

const handler = async (event: any) => {
  // 只处理收到的消息
  if (event.type !== 'message' || event.action !== 'received') return;

  const content = event.context.content || '';
  const from = event.context.from || '';

  // 检查是否是被测 Bot 的回复（在测试群中，来自被测 Bot）
  // 通过消息上下文判断是否是对 QA-VERIFY 消息的回复
  
  // 简化逻辑：记录所有测试群中的非验证者消息
  if (event.context.metadata?.conversationId === 'oc_test_group') {
    // 不是验证者自己发的消息
    if (!content.includes(QA_VERIFY_PREFIX)) {
      mkdirSync(RESULT_DIR, { recursive: true });
      
      const result = {
        timestamp: Date.now(),
        from,
        content,
        conversationId: event.context.metadata?.conversationId,
        messageId: event.context.messageId,
      };
      
      // 写入结果文件
      const filename = `reply-${Date.now()}.json`;
      writeFileSync(join(RESULT_DIR, filename), JSON.stringify(result, null, 2));
    }
  }
};

export default handler;
```

对应的 HOOK.md：

```markdown
---
name: verify-listener
description: "监听飞书测试群回复，记录 E2E 验证结果"
metadata:
  openclaw:
    emoji: "🔍"
    events: ["message:received"]
---

# Verify Listener

监听飞书测试群中被测 Bot 的回复，写入 /tmp/qa-verify/ 供 qa-orchestrator 读取。
```

### 6.5 报告生成

#### 6.5.1 Markdown 报告模板

```markdown
# 🔍 SaaS 平台验证报告

**Run ID**: {{run_id}}
**执行时间**: {{start_time}} — {{end_time}}
**目标环境**: {{environment}}
**触发方式**: {{trigger_method}}
**总耗时**: {{total_duration}}

---

## 📊 验证总览

| 指标 | 值 |
|------|-----|
| 测试套件 | {{suite_count}} |
| 总用例数 | {{total_tests}} |
| ✅ 通过 | {{passed}} |
| ❌ 失败 | {{failed}} |
| ⏭️ 跳过 | {{skipped}} |
| ⚠️ 错误 | {{errored}} |
| **通过率** | **{{pass_rate}}%** |

### 结果分布

```text
P0 Critical:  ████████░░  80% (4/5)
P1 High:      ██████████  100% (6/6)
```

---

## ❌ 失败用例详情

{{#each failed_tests}}
### {{this.id}}: {{this.name}}

- **套件**: {{this.suite_name}}
- **优先级**: {{this.priority}}
- **耗时**: {{this.duration}}
- **错误类型**: {{this.error_type}}
- **错误详情**:
  ```
  {{this.error_message}}
  ```
- **期望**: {{this.expected}}
- **实际**: {{this.actual}}
- **建议**: {{this.suggestion}}

{{/each}}

---

## ✅ 通过套件

{{#each passed_suites}}
- **{{this.name}}** — {{this.passed}}/{{this.total}} 通过 ({{this.duration}})
{{/each}}

---

## ⏱️ 性能指标

| 指标 | 值 | 基线 | 状态 |
|------|-----|------|------|
| API 平均响应 | {{api_avg_ms}}ms | <500ms | {{api_status}} |
| 飞书消息延迟 | {{feishu_avg_ms}}ms | <5000ms | {{feishu_status}} |
| LLM 首 token | {{llm_ttft_ms}}ms | <3000ms | {{llm_status}} |

---

## 📝 验证日志

<details>
<summary>展开完整执行日志</summary>

{{execution_log}}

</details>

---

*报告由 qa-orchestrator 自动生成 | {{generated_at}}*
```

#### 6.5.2 JSON 机器可读格式

```jsonc
// reports/<run_id>/summary.json
{
  "run_id": "verify-20260318-1400",
  "environment": "staging",
  "trigger": "manual",
  "started_at": "2026-03-18T14:00:00Z",
  "ended_at": "2026-03-18T14:03:42Z",
  "duration_ms": 222000,
  "result": "FAIL",             // PASS | FAIL | ERROR
  "stats": {
    "suites": 7,
    "total": 24,
    "passed": 21,
    "failed": 2,
    "skipped": 1,
    "errored": 0,
    "pass_rate": 87.5
  },
  "suites": [
    {
      "id": "suite-health",
      "name": "基础健康检查",
      "priority": "P0",
      "result": "PASS",
      "tests": [
        {
          "id": "health-001",
          "name": "API 服务存活",
          "result": "PASS",
          "duration_ms": 230,
          "metrics": { "http_status": 200, "response_time_ms": 230 }
        }
        // ...
      ]
    }
    // ...
  ],
  "failures": [
    {
      "test_id": "feishu-002",
      "suite": "飞书通道连通",
      "name": "图片消息处理",
      "error": "Timeout: 60s 内未收到回复",
      "severity": "P0"
    }
  ],
  "performance": {
    "api_avg_ms": 340,
    "feishu_reply_avg_ms": 4200,
    "llm_ttft_avg_ms": 1800
  }
}
```

---

## 7. 触发机制

### 7.1 手动 CLI 触发（首选）

```bash
# 方式1：直接运行预设的 cron job
openclaw cron run <verify-job-id>

# 方式2：一次性指令
openclaw cron add \
  --name "手动验证-$(date +%Y%m%d%H%M)" \
  --at "now" \
  --session isolated \
  --agent qa-orchestrator \
  --message "开始验证。环境: staging。生成完整报告。" \
  --announce \
  --channel feishu \
  --to "oc_qa_report_group" \
  --delete-after-run
```

### 7.2 预设 Cron Job（手动触发）

```bash
# 创建一个"永不自动执行"的job，需要时手动 run
openclaw cron add \
  --name "SaaS全量验证" \
  --at "2099-12-31T23:59:59Z" \
  --session isolated \
  --agent qa-orchestrator \
  --message "执行全量验证。读取 config/test-suites.yaml，按 priority 顺序执行。每完成一个套件实时汇报。最终生成报告写入 reports/ 目录并推送飞书。" \
  --announce \
  --channel feishu \
  --to "oc_qa_report_group" \
  --delete-after-run false

# 需要验证时
openclaw cron run <job-id>
```

### 7.3 CI/CD Webhook 触发

```yaml
# .github/workflows/deploy-and-verify.yml

name: Deploy and Verify

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: ./deploy.sh staging

      - name: Wait for service ready
        run: |
          for i in {1..30}; do
            curl -sf https://staging-api.your-saas.com/health && break
            sleep 10
          done

      - name: Trigger verification
        run: |
          ssh -i ${{ secrets.QA_SSH_KEY }} qa@qa-server \
            "openclaw cron run ${{ secrets.VERIFY_JOB_ID }}"

      - name: Wait for verification result
        run: |
          # 轮询验证结果（最多等5分钟）
          for i in {1..30}; do
            RESULT=$(ssh -i ${{ secrets.QA_SSH_KEY }} qa@qa-server \
              "cat ~/.openclaw/workspace-qa/reports/latest/summary.json 2>/dev/null | jq -r '.result'")
            if [ "$RESULT" = "PASS" ]; then
              echo "✅ Verification passed"
              exit 0
            elif [ "$RESULT" = "FAIL" ]; then
              echo "❌ Verification failed"
              ssh -i ${{ secrets.QA_SSH_KEY }} qa@qa-server \
                "cat ~/.openclaw/workspace-qa/reports/latest/report.md"
              exit 1
            fi
            sleep 10
          done
          echo "⏰ Verification timeout"
          exit 1
```

### 7.4 飞书消息触发

在 qa-orchestrator 的 SOUL.md 中配置，当收到"开始验证"消息时启动验证流程：

```
用户在飞书群发 "@QA验证Bot 开始验证"
  → qa-orchestrator 收到消息
  → 识别"开始验证"指令
  → 读取用例、执行验证
  → 实时回复进度
  → 最终推送报告
```

---

## 8. 报告与通知

### 8.1 飞书群实时通知

验证过程中，qa-orchestrator 通过飞书实时汇报：

```
🔄 [验证启动] Run ID: verify-20260318-1400
   环境: staging | 套件: 7 | 用例: 24

✅ [1/7] 基础健康检查 — 通过 (3/3) — 2.1s
✅ [2/7] 飞书通道连通 — 通过 (3/3) — 45.2s
❌ [3/7] Agent 管理功能 — 失败 (4/5) — 12.8s
   └ agent-003 更新Agent: 期望200，实际500
✅ [4/7] AI 对话功能 — 通过 (3/3) — 38.5s
✅ [5/7] 多租户隔离 — 通过 (4/4) — 8.3s
✅ [6/7] 技能市场功能 — 通过 (3/3) — 22.1s
✅ [7/7] LLM 调用链路 — 通过 (2/2) — 15.4s

📊 [验证完成] 通过率: 95.8% (23/24)
   ❌ 失败: agent-003 (Agent更新接口500)
   📄 报告: reports/verify-20260318-1400/report.md
```

### 8.2 报告归档

```bash
reports/
├── latest -> verify-20260318-1400/    # 软链接指向最新报告
├── verify-20260318-1400/
│   ├── report.md                       # 人类可读报告
│   └── summary.json                    # 机器可读结果
├── verify-20260317-0900/
└── verify-20260316-1530/
```

### 8.3 历史趋势（可选扩展）

```
通过率趋势 (最近7天):
03-12  ████████████████████  100%
03-13  ████████████████░░░░   80%  ← deploy #231
03-14  ████████████████████  100%  ← hotfix #232
03-15  ████████████████████  100%
03-16  ██████████████████░░   90%  ← deploy #235
03-17  ████████████████████  100%  ← hotfix #236
03-18  ███████████████████░   95%  ← deploy #238 ← current
```

---

## 9. 实施路径

### Phase 1：基础框架搭建（2-3天）

**目标**: 能手动触发并执行最简单的验证

| 任务 | 内容 | 产出 |
|------|------|------|
| 1.1 | 部署验证者 OpenClaw 实例 | 独立运行的 OpenClaw |
| 1.2 | 配置 qa-orchestrator Agent | SOUL.md + 工作空间 |
| 1.3 | 编写 health-check 测试套件 | 3 个 API 健康检查用例 |
| 1.4 | 实现 API 验证脚本 | api-verify.sh |
| 1.5 | 配置 cron job（手动触发） | 可执行的验证 job |
| 1.6 | 实现基础报告生成 | report.md 模板 |

**验收标准**: `openclaw cron run <id>` → 3个健康检查执行 → 生成报告

### Phase 2：飞书 E2E 验证（3-4天）

**目标**: 验证飞书通道端到端可用性

| 任务 | 内容 | 产出 |
|------|------|------|
| 2.1 | 创建飞书测试 App（验证者身份） | 独立的飞书 Bot |
| 2.2 | 建立飞书测试群 | 验证者 Bot + 被测 Bot 同群 |
| 2.3 | 实现飞书消息发送验证 | feishu-001 ~ 003 |
| 2.4 | 实现回复监听 Hook | verify-listener hook |
| 2.5 | 实现对话功能验证 | conv-001 ~ 003 |

**验收标准**: 验证者发消息 → 被测 Bot 回复 → 验证内容匹配 → 报告记录

### Phase 3：功能层全覆盖（3-5天）

**目标**: 覆盖所有 P0/P1 功能验证

| 任务 | 内容 | 产出 |
|------|------|------|
| 3.1 | Agent CRUD 验证用例 | agent-001 ~ 005 |
| 3.2 | 多租户隔离验证 | tenant-001 ~ 004 |
| 3.3 | 技能市场验证 | skill-001 ~ 003 |
| 3.4 | LLM 链路验证 | llm-001 ~ 002 |
| 3.5 | 测试数据清理机制 | cleanup 逻辑 |

**验收标准**: 24个用例全量执行 → 报告覆盖所有维度

### Phase 4：集成与通知（1-2天）

**目标**: CI/CD 集成 + 飞书实时通知

| 任务 | 内容 | 产出 |
|------|------|------|
| 4.1 | CI/CD pipeline 集成 | GitHub Actions workflow |
| 4.2 | 飞书群实时进度通知 | 实时消息推送 |
| 4.3 | 报告归档与 latest 软链接 | 历史报告管理 |
| 4.4 | 失败告警机制 | P0 失败即时通知 |

**验收标准**: git push → 自动部署 → 自动验证 → 飞书群收到报告

### Phase 5：持续优化（持续）

| 方向 | 内容 |
|------|------|
| 用例扩展 | 根据线上问题补充回归用例 |
| 性能基线 | 建立性能指标基线，检测劣化 |
| 历史趋势 | 通过率趋势图，发现系统性问题 |
| 并行执行 | 无依赖套件并行执行，缩短验证时间 |

---

## 10. 风险与应对

### 10.1 技术风险

| 风险 | 影响 | 概率 | 应对策略 |
|------|------|------|----------|
| 飞书 E2E 回复监听不可靠 | 验证误判 | 中 | 方案 B 兜底：直接调用飞书 API；设置合理超时 |
| 验证者实例故障 | 无法验证 | 低 | 健康监控 + 自动重启；验证者本身也做健康检查 |
| 测试数据残留 | 数据污染 | 中 | 每个用例带 cleanup 步骤；run_id 标记便于清理 |
| LLM 回复不确定性 | 内容断言不稳 | 高 | 模糊匹配而非精确匹配；只验证"有回复"而非"回复正确" |
| 飞书 API 限流 | 验证失败 | 中 | 用例间加间隔；批量操作合并；重试机制 |

### 10.2 流程风险

| 风险 | 应对策略 |
|------|----------|
| 验证耗时过长阻塞发布 | 设置总超时（5分钟）；P0 失败立即报告，不等全部完成 |
| 误报导致信任度下降 | 严格区分 critical / non-critical；误报率监控 |
| 用例维护成本 | YAML 声明式、低维护；与产品迭代同步更新用例 |

### 10.3 关键设计决策

| 决策点 | 选择 | 理由 |
|--------|------|------|
| 验证者与被测者是否分离 | **分离** | 避免循环依赖，故障隔离 |
| 用例定义方式 | **YAML 声明式** | 低维护成本，非开发人员也能添加 |
| 飞书 E2E 实现方式 | **消息工具 + Hook 优先** | 原生 OpenClaw 能力，最简方案 |
| 报告格式 | **Markdown + JSON 双格式** | 人和机器都能消费 |
| 触发方式 | **手动优先，CI/CD 可选** | 按需求渐进增强 |

---

## 11. 附录

### 11.1 飞书测试 App 创建清单

- [ ] 在飞书开放平台创建新应用（QA 自动验证）
- [ ] 配置 Bot 能力
- [ ] 申请 `im:message:send_as_bot` 等权限
- [ ] 启用 WebSocket 长连接
- [ ] 添加事件订阅 `im.message.receive_v1`
- [ ] 发布应用
- [ ] 将 Bot 加入测试群
- [ ] 在验证者 OpenClaw 中配置飞书 Channel

### 11.2 环境准备清单

- [ ] 准备独立服务器/容器部署验证者 OpenClaw
- [ ] 安装 OpenClaw 最新版
- [ ] 配置 openclaw.json
- [ ] 创建 qa-orchestrator workspace
- [ ] 编写 SOUL.md / AGENTS.md / MEMORY.md
- [ ] 准备测试用户 Token（各租户）
- [ ] 配置 SSH 密钥（CI/CD 触发用）

### 11.3 测试用户 Token 管理

```yaml
# 建议使用环境变量管理，不要硬编码
# ~/.openclaw/workspace-qa/.env

SAAS_ADMIN_TOKEN=xxx
SAAS_TEST_USER_TOKEN=xxx
SAAS_TENANT_A_TOKEN=xxx
SAAS_TENANT_B_TOKEN=xxx
```

### 11.4 相关 OpenClaw 文档参考

| 文档 | 路径 |
|------|------|
| 飞书 Channel 配置 | /docs/channels/feishu.md |
| Cron Jobs | /docs/automation/cron-jobs.md |
| Hooks | /docs/automation/hooks.md |
| Agent 配置 | /docs/gateway/configuration |
| 多 Agent 设置 | /docs/agents/ |

---

> **下一步**: 确认方案后，可立即进入 Phase 1 实施。需要我细化哪个部分的实现代码？
