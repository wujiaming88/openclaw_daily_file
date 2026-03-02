# OpenClaw 通道系统架构

## 来源
- URL: https://docs.openclaw.ai/channels
- 获取时间: 2026-03-01 14:38

## 核心架构

### 1. 通道设计原则
- OpenClaw可以在你已使用的任何聊天应用上与你对话
- 每个通道通过Gateway连接
- 文本支持无处不在；媒体和反应因通道而异

### 2. 支持的通道

#### 主流平台
- **WhatsApp** - 最受欢迎；使用Baileys，需要QR配对
- **Telegram** - 通过grammY的Bot API；支持群组
- **Discord** - Discord Bot API + Gateway；支持服务器、频道和DMs
- **Slack** - Bolt SDK；工作区应用
- **Google Chat** - 通过HTTP webhook的Google Chat API应用
- **Signal** - signal-cli；注重隐私

#### 扩展平台
- **BlueBubbles** - **iMessage推荐**；使用BlueBubbles macOS服务器REST API，具有完整功能支持（编辑、取消发送、效果、反应、群组管理）
- **iMessage (legacy)** - 通过imsg CLI的传统macOS集成（已弃用，新设置使用BlueBubbles）
- **Microsoft Teams** - Bot Framework；企业支持
- **Feishu** - 通过WebSocket的Feishu/Lark bot（插件，单独安装）
- **Mattermost** - Bot API + WebSocket；频道、群组、DMs（插件，单独安装）
- **Synology Chat** - 通过传出+传入webhooks的Synology NAS Chat（插件，单独安装）
- **LINE** - LINE Messaging API bot（插件，单独安装）
- **Nextcloud Talk** - 通过Nextcloud Talk的自托管聊天（插件，单独安装）
- **Matrix** - Matrix协议（插件，单独安装）
- **Nostr** - 通过NIP-04的去中心化DMs（插件，单独安装）
- **Tlon** - 基于Urbit的消息传递者（插件，单独安装）
- **Twitch** - 通过IRC连接的Twitch聊天（插件，单独安装）
- **Zalo** - Zalo Bot API；越南流行的消息传递者（插件，单独安装）
- **Zalo Personal** - 通过QR登录的Zalo个人账户（插件，单独安装）
- **WebChat** - 通过WebSocket的Gateway WebChat UI
- **IRC** - 经典IRC服务器；具有配对/allowlist控制的频道+DMs

### 3. 通道特点

#### 并发运行
- 通道可以同时运行
- 配置多个，OpenClaw将按聊天路由

#### 快速设置
- **最快设置**通常是**Telegram**（简单的bot token）
- WhatsApp需要QR配对并在磁盘上存储更多状态

#### 群组行为
- 群组行为因通道而异
- 查看群组规则：[Groups](/channels)

#### 安全性
- DM配对和allowlists为了安全而强制执行
- 查看安全性：[Security](/gateway/security)

#### 故障排除
- 通道故障排除：[Channel troubleshooting](/channels/troubleshooting)

### 4. 架构模式

#### 插件化设计
- 主流通道内置
- 扩展通道作为插件单独安装
- 统一的接口抽象

#### 标准化消息格式
- 所有通道消息标准化为统一格式
- 支持文本、媒体、反应等

#### 路由机制
- 按聊天路由
- 支持多通道并发
- 智能路由到正确的代理

### 5. 技术实现

#### 通道连接方式
- **Bot API**: Telegram、Discord、Slack、Google Chat、Signal、Microsoft Teams、Zalo
- **REST API**: BlueBubbles、Synology Chat
- **WebSocket**: Feishu、Mattermost、WebChat
- **CLI**: iMessage (legacy)
- **IRC**: IRC、Twitch
- **Protocol**: Matrix、Nostr
- **Plugin**: LINE、Nextcloud Talk、Tlon、Zalo Personal

#### 状态管理
- WhatsApp在磁盘上存储更多状态
- 其他通道轻量级状态管理

## 参考资料
- Groups: https://docs.openclaw.ai/channels/groups
- Security: https://docs.openclaw.ai/gateway/security
- Channel troubleshooting: https://docs.openclaw.ai/channels/troubleshooting
- Model Providers: https://docs.openclaw.ai/providers/models
