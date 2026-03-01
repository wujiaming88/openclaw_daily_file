# OpenClaw GitHub 仓库概览

## 来源
- URL: https://github.com/openclaw/openclaw
- 获取时间: 2026-03-01 14:37

## 核心信息

### 项目描述
OpenClaw是一个在个人设备上运行的个人AI助手，可以在你已使用的频道上回答问题（WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams、WebChat），以及扩展频道如BlueBubbles、Matrix、Zalo和Zalo Personal。它可以在macOS/iOS/Android上说话和收听，并可以渲染你控制的实时Canvas。

### 核心特性

#### 1. 多通道支持
- **主流消息平台**: WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams
- **扩展平台**: BlueBubbles、Matrix、Zalo、Zalo Personal、WebChat
- **移动端支持**: macOS/iOS/Android（语音唤醒、Talk Mode、Canvas）

#### 2. Gateway架构
- Gateway是控制平面，产品是助手
- 单个多路复用端口用于：
  - WebSocket控制/RPC
  - HTTP APIs（OpenAI兼容、Responses、工具调用）
  - 控制UI和hooks
- 默认绑定模式: `loopback`
- 认证是必需的（token/password）

#### 3. 安全设计
- 入站DM被视为不受信任的输入
- 默认DM配对策略（dmPolicy="pairing"）
- 公共入站DM需要显式选择加入
- 提供安全指南和配置审计

#### 4. 多代理路由
- 将入站频道/账户/peers路由到隔离的代理（工作区+每代理会话）
- 支持多租户隔离

#### 5. 技能系统
- 向导驱动的设置
- 捆绑/管理/工作区技能
- 技能加载、依赖管理、生命周期

#### 6. 会话模型
- 主会话用于直接聊天
- 群组隔离
- 激活模式
- 队列模式
- 回复机制

#### 7. 媒体管道
- 图像/音频/视频
- 转录hooks
- 大小限制
- 临时文件生命周期

#### 8. 配置管理
- 配置热重载
- 多种重载模式（off/hot/restart/hybrid）
- 配置文件监控

### 技术栈
- **运行时**: Node ≥22
- **包管理器**: npm、pnpm、bun
- **语言**: TypeScript
- **构建**: pnpm build

### 部署选项
- **macOS**: launchd用户服务
- **Linux**: systemd用户服务或系统服务
- **多实例**: 支持在同一主机上运行多个Gateway

### 运行时模型
- 一个始终运行的进程用于路由、控制平面和频道连接
- 单个多路复用端口
- 支持远程访问（Tailscale/VPN或SSH隧道）

## 架构亮点

### 1. 本地优先
- Gateway是本地控制平面
- 单用户、本地优先的助手体验
- 数据本地化

### 2. 插件化架构
- 每个频道是独立的适配器
- 标准化消息格式
- 易于扩展新频道

### 3. RPC模式
- Pi代理运行时使用RPC模式
- 工具流式传输
- 块流式传输

### 4. 事件驱动
- Gateway协议基于事件
- 支持连接挑战、代理、聊天、存在、tick、健康、心跳、关闭等事件

## 参考资料
- 官方文档: https://docs.openclaw.ai
- GitHub仓库: https://github.com/openclaw/openclaw
- Discord社区: https://discord.gg/clawd
