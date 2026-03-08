# Telegram 多Bot群组协作配置研究

> **研究问题**: 如何配置多个Telegram Bot在一个群组中互相对话

---

## 核心发现

### ⚠️ Telegram Bot的固有限制

**Telegram Bot不能直接"互相对话"**

| 限制 | 说明 |
|------|------|
| **Privacy Mode** | Bot默认只能看到@自己的消息 |
| **Bot-to-Bot静默** | Bot发送的消息**不会**触发其他Bot |
| **无主动监听** | Bot无法"听到"其他Bot的消息 |

这是Telegram的设计限制，**不是OpenClaw的问题**。

---

## 解决方案

### 方案一：用户触发模式（推荐）

**原理**：用户@特定Bot来触发对话，协调在OpenClaw内部完成

```
┌─────────────────────────────────────────────────────────────┐
│                    Telegram 群组                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   用户: @main_bot 帮我开发一个登录功能                        │
│                      │                                      │
│                      ▼                                      │
│   main_bot: 好的，我派发给专家处理...                         │
│                      │                                      │
│            [OpenClaw内部协调]                                │
│            main → wairesearch → waicode → waiqa             │
│                      │                                      │
│                      ▼                                      │
│   main_bot: 已完成！结果如下...                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**配置步骤**：

1. **创建群组并添加所有Bot**

2. **配置群组权限**（在BotFather中）：
   ```
   /setprivacy - 设置为 Disable（关闭隐私模式）
   /setjoingroups - 设置为 Enable（允许加入群组）
   ```

3. **配置OpenClaw**：
```json5
{
  channels: {
    telegram: {
      enabled: true,
      groupPolicy: "open",
      groups: {
        "-100你的群组ID": {
          requireMention: true,  // 需要@才能触发
          allowFrom: ["*"]       // 允许所有人
        }
      },
      accounts: {
        default: { botToken: "main_bot_token" },
        waicode: { botToken: "waicode_bot_token" },
        waidesign: { botToken: "waidesign_bot_token" },
        wairesearch: { botToken: "wairesearch_bot_token" },
        waiqa: { botToken: "waiqa_bot_token" }
      }
    }
  },
  
  // 绑定：群组消息 → main agent
  bindings: [
    {
      agentId: "main",
      match: {
        channel: "telegram",
        accountId: "default",
        peer: { kind: "group", id: "-100你的群组ID" }
      }
    }
  ]
}
```

**优点**：
- 简单可靠
- 所有协调在OpenClaw内部完成
- 用户只需要@一个Bot

**缺点**：
- 用户看不到专家Bot的对话
- 不是真正的"Bot互相对话"

---

### 方案二：用户中转模式

**原理**：用户@不同的Bot来"传递"对话

```
┌─────────────────────────────────────────────────────────────┐
│                    Telegram 群组                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   用户: @main_bot 派发任务给waicode                           │
│   main_bot: 已派发任务TASK-001给waicode                       │
│                                                             │
│   用户: @waicode_bot 你收到任务了吗？                         │
│   waicode_bot: 收到了，正在开发...                           │
│                                                             │
│   用户: @waicode_bot 完成了吗？                               │
│   waicode_bot: 完成了！结果在shared/artifacts/               │
│                                                             │
│   用户: @waiqa_bot 请测试TASK-001                             │
│   waiqa_bot: 测试中...                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**配置**：
```json5
{
  bindings: [
    // 每个Bot绑定到对应的Agent
    {
      agentId: "main",
      match: { channel: "telegram", accountId: "default" }
    },
    {
      agentId: "waicode",
      match: { channel: "telegram", accountId: "waicode" }
    },
    {
      agentId: "waidesign",
      match: { channel: "telegram", accountId: "waidesign" }
    },
    {
      agentId: "wairesearch",
      match: { channel: "telegram", accountId: "wairesearch" }
    },
    {
      agentId: "waiqa",
      match: { channel: "telegram", accountId: "waiqa" }
    }
  ]
}
```

**优点**：
- 用户可以看到每个Bot的响应
- 更透明

**缺点**：
- 需要用户手动"传递"
- 不是真正的Bot互相对话

---

### 方案三：禁用Privacy Mode + 回复模式

**原理**：禁用Privacy Mode让Bot看到所有消息，通过"回复"来触发链式对话

```
┌─────────────────────────────────────────────────────────────┐
│                    Telegram 群组                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   用户: 开发一个登录功能                                      │
│   main_bot: [回复用户] 好的，我派发给waicode                  │
│                                                             │
│   [main内部调用 sessions_spawn 派发给waicode]                │
│                                                             │
│   waicode完成后:                                             │
│   main_bot: [回复之前的消息] waicode已完成，结果...           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**配置**：
```json5
{
  channels: {
    telegram: {
      groups: {
        "-100你的群组ID": {
          requireMention: false,  // 不需要@也能触发
          groupPolicy: "open"
        }
      }
    }
  }
}
```

**在BotFather中**：
```
/setprivacy - 选择你的Bot - 选择 Disable
```

**注意**：禁用Privacy Mode后，Bot会收到群组中的**所有消息**，需要过滤处理。

---

### 方案四：真正的Bot互相对话（复杂）

**原理**：使用中间服务转发Bot消息

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   Telegram群组                                               │
│       │                                                     │
│       ▼                                                     │
│   Bot A 发送消息                                             │
│       │                                                     │
│       ▼                                                     │
│   [中间服务] 捕获Bot A的消息                                  │
│       │                                                     │
│       ▼                                                     │
│   重新发送为"用户消息"（通过Telegram API）                    │
│       │                                                     │
│       ▼                                                     │
│   Bot B 收到消息并响应                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**这需要**：
1. 一个中间服务监听所有Bot的Webhook
2. 将Bot消息转换为"用户消息"格式
3. 使用Telegram Client API（非Bot API）

**复杂度很高，不推荐**。

---

## 推荐方案

### 对于你的场景：方案一（用户触发模式）

```
┌─────────────────────────────────────────────────────────────┐
│                    推荐架构                                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Telegram群组（用户视角）                                   │
│   └── 只需要@main_bot                                       │
│                                                             │
│   OpenClaw内部（实际协作）                                   │
│   main (Coordinator)                                        │
│   ├── waicode (Developer)                                   │
│   ├── waidesign (Designer)                                  │
│   ├── wairesearch (Researcher)                              │
│   └── waiqa (QA)                                            │
│                                                             │
│   协作方式：sessions_spawn + 共享文件                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**原因**：
1. 简单可靠
2. 符合Telegram的设计限制
3. 用户体验好（只需要@一个Bot）
4. 协作在OpenClaw内部完成，更高效

---

## 配置步骤

### 步骤1：创建Telegram群组

1. 创建一个新群组
2. 添加所有Bot（main_bot, waicode_bot等）
3. 获取群组ID：
   - 转发一条群组消息给 @userinfobot
   - 或查看 `openclaw logs --follow`

### 步骤2：配置BotFather（每个Bot）

```
/setprivacy → 选择Bot → Disable
/setjoingroups → 选择Bot → Enable
```

### 步骤3：配置OpenClaw

```json5
{
  channels: {
    telegram: {
      enabled: true,
      groupPolicy: "open",
      groups: {
        "-100你的群组ID": {
          requireMention: true,  // 或 false 禁用@
          allowFrom: ["*"]
        }
      },
      accounts: {
        default: { botToken: "main_bot_token" },
        waicode: { botToken: "waicode_bot_token" },
        waidesign: { botToken: "waidesign_bot_token" },
        wairesearch: { botToken: "wairesearch_bot_token" },
        waiqa: { botToken: "waiqa_bot_token" }
      }
    }
  },
  
  bindings: [
    {
      agentId: "main",
      match: {
        channel: "telegram",
        peer: { kind: "group", id: "-100你的群组ID" }
      }
    }
  ]
}
```

### 步骤4：重启Gateway

```bash
openclaw gateway restart
```

---

## 使用示例

```
用户: @main_bot 帮我开发一个用户登录功能

main_bot: 收到任务！正在分解...

main_bot: 
📋 任务分解：
1. 研究：wairesearch 调研最佳实践
2. 设计：waidesign 设计方案
3. 开发：waicode 实现
4. 测试：waiqa 验证

正在派发给专家团队...

main_bot: 
✅ 任务完成！

📦 产出：
- 设计文档：...
- 代码实现：...
- 测试报告：...

详见：shared/artifacts/TASK-001/
```

---

## 总结

| 方案 | Bot互相对话 | 实现难度 | 推荐度 |
|------|------------|----------|--------|
| 用户触发 | ❌ | 简单 | ⭐⭐⭐⭐⭐ |
| 用户中转 | 部分 | 简单 | ⭐⭐⭐ |
| 禁用Privacy | 部分 | 中等 | ⭐⭐⭐ |
| 中间服务 | ✅ | 复杂 | ⭐ |

**结论**：Telegram的设计限制了Bot之间的直接对话。最佳实践是在OpenClaw内部完成协作，Telegram只作为用户交互界面。

---

**报告编号**: 2026-03-08-Telegram多Bot配置研究  
**研究团队**: 卷王小组  
**生成时间**: 2026年3月8日
