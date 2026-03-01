# OpenClaw Gateway 配置架构

## 来源
- URL: https://docs.openclaw.ai/gateway/configuration
- 获取时间: 2026-03-01 14:37

## 核心配置架构

### 1. 配置文件
- **位置**: `~/.openclaw/openclaw.json`
- **格式**: JSON5（支持注释和尾随逗号）
- **行为**: 文件缺失时使用安全默认值

### 2. 配置编辑方式

#### 交互式向导
```bash
openclaw onboard       # 完整设置向导
openclaw configure     # 配置向导
```

#### CLI命令
```bash
openclaw config get agents.defaults.workspace
openclaw config set agents.defaults.heartbeat.every "2h"
openclaw config unset tools.web.search.apiKey
```

#### 控制UI
- 访问 `http://127.0.0.1:18789`
- 使用**Config**标签页
- 从配置架构渲染表单
- 提供**Raw JSON**编辑器作为转义

#### 直接编辑
- 直接编辑`~/.openclaw/openclaw.json`
- Gateway监控文件并自动应用更改
- 支持热重载

### 3. 严格验证

#### 验证规则
- OpenClaw只接受完全匹配架构的配置
- 未知键、格式错误类型或无效值导致Gateway**拒绝启动**
- 根级别的唯一例外是`$schema`（字符串）

#### 验证失败处理
- Gateway不启动
- 只有诊断命令工作（`openclaw doctor`、`openclaw logs`、`openclaw health`、`openclaw status`）
- 运行`openclaw doctor`查看确切问题
- 运行`openclaw doctor --fix`（或`--yes`）应用修复

### 4. 核心配置模块

#### 通道配置
- 每个通道在`channels.<provider>`下有自己的配置部分
- 支持的通道：WhatsApp、Telegram、Discord、Slack、Signal、iMessage、Google Chat、Mattermost、MS Teams

#### DM策略
```json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "123:abc",
      dmPolicy: "pairing",   // pairing | allowlist | open | disabled
      allowFrom: ["tg:123"], // 仅用于allowlist/open
    },
  },
}
```

#### 模型配置
```json5
{
  agents: {
    defaults: {
      model: {
        primary: "anthropic/claude-sonnet-4-5",
        fallbacks: ["openai/gpt-5.2"],
      },
      models: {
        "anthropic/claude-sonnet-4-5": { alias: "Sonnet" },
        "openai/gpt-5.2": { alias: "GPT" },
      },
    },
  },
}
```

#### 会话配置
```json5
{
  session: {
    dmScope: "per-channel-peer",  // 推荐用于多用户
    threadBindings: {
      enabled: true,
      idleHours: 24,
      maxAgeHours: 0,
    },
    reset: {
      mode: "daily",
      atHour: 4,
      idleMinutes: 120,
    },
  },
}
```

#### 沙箱配置
```json5
{
  agents: {
    defaults: {
      sandbox: {
        mode: "non-main",  // off | non-main | all
        scope: "agent",    // session | agent | shared
      },
    },
  },
}
```

#### 心跳配置
```json5
{
  agents: {
    defaults: {
      heartbeat: {
        every: "30m",
        target: "last",
      },
    },
  },
}
```

#### Cron配置
```json5
{
  cron: {
    enabled: true,
    maxConcurrentRuns: 2,
    sessionRetention: "24h",
    runLog: {
      maxBytes: "2mb",
      keepLines: 2000,
    },
  },
}
```

### 5. 配置特点

#### 模块化设计
- 每个功能模块有独立的配置部分
- 清晰的层次结构
- 易于理解和维护

#### 灵活的访问控制
- 多种DM策略（pairing/allowlist/open/disabled）
- 群组提及门控
- 细粒度权限控制

#### 多租户支持
- 会话作用域控制
- 线程绑定
- 每账户/通道/peer隔离

#### 自动化支持
- Cron任务
- 心跳检查
- Hooks
- 定时重置

#### 安全性
- 严格验证
- 配置架构强制
- 诊断和修复工具

## 参考资料
- Configuration Reference: https://docs.openclaw.ai/gateway/configuration-reference
- Configuration Examples: https://docs.openclaw.ai/gateway/configuration-examples
- Models: https://docs.openclaw.ai/concepts/models
- Model Failover: https://docs.openclaw.ai/concepts/model-failover
- Session Management: https://docs.openclaw.ai/concepts/session
- Sandboxing: https://docs.openclaw.ai/gateway/sandboxing
- Heartbeat: https://docs.openclaw.ai/gateway/heartbeat
- Cron Jobs: https://docs.openclaw.ai/automation/cron-jobs
