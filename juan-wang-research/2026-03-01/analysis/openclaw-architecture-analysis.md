# OpenClaw架构设计分析

## 分析时间
- 2026-03-01 14:38
- 分析师: deepseek-v3-2

## 1. 整体架构概述

### 1.1 架构层次
OpenClaw采用**三层架构设计**：

```
┌─────────────────────────────────────┐
│     通道层 (Channels)           │
│  WhatsApp/Telegram/Discord/...    │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│     Gateway层 (控制平面)        │
│  路由/配置/会话管理         │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│     Agent层 (运行时)           │
│  工作区区/技能/工具           │
└─────────────────────────────────────┘
```

### 1.2 核心设计原则
1. **本地优先**: Gateway和Agent都在本地运行
2. **插件化**: 通道和技能都是可插拔的
3. **事件驱动**: 基于WebSocket和事件流
4. **多租户**: 支持多用户、多代理隔离
5. **安全性**: DM配对、严格验证、配置审计

## 2. Gateway架构分析

### 2.1 核心职责
Gateway是OpenClaw的**控制平面**，负责：

#### 2.1.1 路由与转发
- 多路复用端口（默认18789）
- WebSocket控制/RPC
- HTTP APIs（OpenAI兼容、Responses、工具调用）
- 控制UI和hooks

#### 2.1.2 会话管理
- 会话生命周期管理
- 会话作用域控制（main/per-peer/per-channel-peer）
- 线程绑定
- 会话重置策略

#### 2.1.3 配置管理
- JSON5配置文件（~/.openclaw/openclaw.json）
- 热重载支持（off/hot/restart/hybrid）
- 严格验证（schema强制）
- 配置文件监控

#### 2.1.4 通道管理
- 多通道并发支持
- 通道适配器标准化
- DM和群组策略
- 消息路由

#### 2.1.5 安全与认证
- Token/Password认证
- DM配对机制
- Allowlist控制
- 配置审计

### 2.2 Gateway运行时模型
- **单一进程**: 始终运行的进程
- **事件循环**: 处理连接、消息、事件
- **状态管理**: presence、health、stateVersion
- **协议**: WebSocket + HTTP混合

### 2.3 配置架构亮点

#### 2.3.1 模块化配置
```json5
{
  agents: { ... },      // 代理配置
  channels: { ... },    // 通道配置
  gateway: { ... },     // Gateway配置
  cron: { ... },       // 定时任务
  tools: { ... },      // 工具配置
  session: { ... },     // 会话配置
}
```

#### 2.3.2 严格验证
- Schema强制
- 类型检查
- 值验证
- 启动前验证

#### 2.3.3 热重载策略
- **off**: 无重载
- **hot**: 仅热安全更改
- **restart**: 重启必需更改
- **hybrid**: 安全时热应用，必要时重启

## 3. Agent Runtime架构分析

### 3.1 核心设计

#### 3.1.1 单一工作区
- 单一代理工作区作为唯一工作目录（cwd）
- 工作区文件自动注入到上下文
- 支持沙箱模式（非主会话可覆盖）

#### 3.1.2 Bootstrap文件系统
```
workspace/
├── AGENTS.md        # 操作指令+memory
├── SOUL.md         # 人格、边界、语气
├── TOOLS.md        # 工具注释
├── BOOTSTRAP.md    # 首次运行仪式（完成后删除）
├── IDENTITY.md      # 代理名称/氛围/emoji
└── USER.md         # 用户档案+首选地址
```

**注入机制**:
- 新会话第一轮自动注入
- 空白文件跳过
- 大文件修剪截断
- 缺失文件注入标记

#### 3.1.3 技能系统

**三层加载优先级**（名称冲突时工作区优先）:
1. **Bundled**: 随安装附带
2. **Managed/local**: ~/.openclaw/skills
3. **Workspace**: <workspace>/skills

**技能控制**:
- 通过配置/环境门控
- SKILL.md定义使用方法
- 依赖管理

### 3.2 会话模型

#### 3.2.1 会话存储
- JSONL格式：~/.openclaw/agents/<agentId>/sessions/<SessionId>.jsonl
- 稳定会话ID
- 不读取Legacy Pi/Tau会话

#### 3.2.2 流式传输与引导

**队列模式**:
- **steer**: 实时注入到当前运行
- **followup/collect**: 保持到当前轮结束

**块流式传输**:
- 完成后立即发送助手块
- 可配置边界（text_end/message_end）
- 智能分块（800-1200字符）
- 合并控制减少垃圾信息

### 3.3 pi-mono集成
- 重用pi-mono代码库（模型/工具）
- 会话管理、发现、工具连接是OpenClaw拥有
- 无pi-coding代理运行时
- 不读取~/.pi/agent设置

### 3.4 模型引用解析
- 在**第一个**`/`上分割
- 使用`provider/model`格式
- 支持OpenRouter风格（provider/model包含/）
- 省略提供者时使用默认提供者

## 4. 通道系统架构分析

### 4.1 通道分类

#### 4.1.1 主流平台（内置）
- WhatsApp (Baileys)
- Telegram (grammY)
- Discord (discord.js)
- Slack (Bolt)
- Google Chat (Chat API)
- Signal (signal-cli)

#### 4.1.2 扩展平台（插件）
- BlueBubbles (iMessage推荐)
- Microsoft Teams (Bot Framework)
- Feishu/Lark (WebSocket)
- Mattermost (Bot API + WebSocket)
- Synology Chat (webhooks)
- LINE (Messaging API)
- Nextcloud Talk (Nextcloud)
- Matrix (Matrix protocol)
- Nostr (NIP-04)
- Tlon (Urbit)
- Twitch (IRC)
- Zalo/Zalo Personal (Bot API)
- WebChat (WebSocket)
- IRC (Classic)

### 4.2 通道架构模式

#### 4.2.1 插件化设计
- 主流通道内置
- 扩展通道作为插件
- 统一接口抽象

#### 4.2.2 标准化消息格式
- 所有通道消息标准化
- 支持文本、媒体、反应
- 统一的路由接口

#### 4.2.3 连接方式多样性
- **Bot API**: Telegram、Discord、Slack、Google Chat、Signal、Microsoft Teams、Zalo
- **REST API**: BlueBubbles、Synology Chat
- **WebSocket**: Feishu、Mattermost、WebChat
- **CLI**: iMessage (legacy)
- **IRC**: IRC、Twitch
- **Protocol**: Matrix、Nostr
- **Plugin**: LINE、Nextcloud Talk、Tlon、Zalo Personal

### 4.3 通道特性

#### 4.3.1 并发支持
- 多通道同时运行
- 按聊天智能路由

#### 4.3.2 安全机制
- DM配对（pairing/allowlist/open/disabled）
- 群组提及门控
- Allowlist控制

#### 4.3.3 状态管理
- WhatsApp在磁盘存储更多状态
- 其他通道轻量级状态

## 5. 核心架构发现

### 5.1 设计亮点

#### 5.1.1 本地优先架构
- Gateway和Agent都在本地运行
- 数据本地化
- 无云依赖

#### 5.1.2 插件化扩展
- 通道插件化
- 技能插件化
- 易于扩展新功能

#### 5.1.3 事件驱动
- WebSocket事件流
- 代理事件
- 通道事件

#### 5.1.4 多租户隔离
- 会话作用域
- 工作区隔离
- 沙箱支持

#### 5.1.5 安全设计
- DM配对
- 严格验证
- 配置审计
- 不信任入站输入

### 5.2 技术栈总结

#### 5.2.1 运行时
- Node ≥22
- TypeScript
- pnpm/npm/bun

#### 5.2.2 核心依赖
- pi-mono（模型/工具）
- Baileys (WhatsApp)
- grammY (Telegram)
- discord.js (Discord)
- Bolt (Slack)

#### 5.2.3 部署
- macOS: launchd
- Linux: systemd user/system
- 支持多实例

### 5.3 架构优势

1. **灵活性**: 插件化设计，易于扩展
2. **安全性**: 本地优先，严格验证
3. **性能**: 事件驱动，流式传输
4. **可维护性**: 模块化配置，清晰分层
5. **多租户**: 支持多用户、多代理
6. **可观测性**: 日志、健康检查、诊断

## 6. 潜在改进方向

### 6.1 架构层面
1. **微服务化**: Gateway可拆分为多个微服务
2. **分布式部署**: 支持多节点Gateway集群
3. **状态同步**: 跨节点状态同步机制

### 6.2 功能层面
1. **更多通道**: 持续添加新平台支持
2. **技能生态**: 更丰富的技能库
3. **UI增强**: 更强大的控制UI

### 6.3 性能层面
1. **缓存优化**: 更智能的缓存策略
2. **并发优化**: 更高效的并发处理
3. **资源管理**: 更精细的资源控制

## 7. 总结

OpenClaw采用了**三层插件化架构**，以Gateway为控制平面，Agent为运行时，通过事件驱动的WebSocket协议连接多通道。其核心优势在于本地优先、插件化扩展、多租户隔离和严格的安全设计。架构清晰、模块化程度高，易于理解和扩展。

**关键设计模式**:
- 插件模式（通道、技能）
- 事件驱动模式
- 工作区模式
- 沙箱模式
- 配置驱动模式
