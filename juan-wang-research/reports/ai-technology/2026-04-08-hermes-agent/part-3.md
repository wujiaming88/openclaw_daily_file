# Part 3：部署与运行时

## 六种终端后端

Hermes Agent 的杀手级特性之一是灵活的终端后端系统：

| 后端 | 描述 | 适用场景 | 成本 |
|------|------|----------|------|
| **Local** | 本机执行（默认） | 开发、可信任务 | 免费 |
| **Docker** | 隔离容器 | 安全、可复现 | 免费 |
| **SSH** | 远程服务器 | 沙箱、隔离 Agent 和自身代码 | VPS 费用 |
| **Singularity** | HPC 容器 | 集群计算、无 root | 免费 |
| **Modal** | 无服务器云执行 | 弹性伸缩、按需计费 | 按用量 |
| **Daytona** | 云沙箱工作区 | 持久远程开发环境 | 按用量 |

### 无服务器持久化（Serverless Persistence）

Modal 和 Daytona 提供"休眠唤醒"模式：
- Agent 空闲时环境自动休眠 → 几乎零成本
- 收到消息时自动唤醒 → 恢复工作状态
- **核心价值**：$5 VPS 的价格获得弹性计算能力

### 容器安全加固
- 只读根文件系统（Docker）
- 所有 Linux capabilities 被 drop
- 禁止特权提升
- PID 限制（256 进程）
- 完全命名空间隔离

## 14+ 平台消息网关

### 平台能力矩阵

| 平台 | 语音 | 图片 | 文件 | 线程 | 反应 | 打字中 | 流式 |
|------|------|------|------|------|------|--------|------|
| Telegram | ✅ | ✅ | ✅ | ✅ | — | ✅ | ✅ |
| Discord | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Slack | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| WhatsApp | — | ✅ | ✅ | — | — | ✅ | ✅ |
| Signal | — | ✅ | ✅ | — | — | ✅ | ✅ |
| Matrix | ✅ | ✅ | ✅ | ✅ | — | ✅ | ✅ |
| 飞书/Lark | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 企业微信 | ✅ | ✅ | ✅ | — | — | ✅ | ✅ |
| 钉钉 | — | — | — | — | — | ✅ | ✅ |
| Email | — | ✅ | ✅ | ✅ | — | — | — |
| SMS | — | — | — | — | — | — | — |
| Home Assistant | — | — | — | — | — | — | — |

### 网关架构
- 单一后台进程连接所有平台
- 每个聊天有独立的会话存储
- 统一路由到 AIAgent 处理
- 内置 Cron 调度器（每 60 秒 tick）

### 安全模型
- 默认拒绝所有未知用户
- 白名单模式：`TELEGRAM_ALLOWED_USERS=123456789`
- DM 配对模式：一次性配对码，1小时过期，密码学随机
- 后台会话：`/background` 启动异步任务，结果自动推送

## 多模型支持

| 供应商 | 说明 |
|--------|------|
| Nous Portal | Nous Research 官方端点 |
| OpenRouter | 200+ 模型 |
| OpenAI | GPT 系列 |
| Anthropic | Claude 系列 |
| z.ai/GLM | GLM 系列 |
| Kimi/Moonshot | Kimi 系列 |
| MiniMax | MiniMax |
| 自定义端点 | 任意 OpenAI 兼容 API |

- 切换命令：`hermes model` 或 `/model provider:model`
- 无代码改动，无锁定
- 支持 18+ 供应商，包含 OAuth、凭证池、别名解析

## 安装极简

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```
- 支持 Linux、macOS、WSL2
- 安装器自动处理 Python、Node.js、依赖
- 除 git 外无前置要求
