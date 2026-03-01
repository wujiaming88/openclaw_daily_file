# OpenClaw架构设计研究报告

**研究团队**: 卷王小组
**研究时间**: 2026-03-01
**任务**: OpenClaw架构设计深度研究

---

## 执行摘要

OpenClaw是一个本地优先的个人AI助手系统，采用**三层插件化架构**设计。本研究深入分析了其Gateway控制平面、Agent运行时、通道系统、配置管理和安全机制，揭示了其模块化、事件驱动、多租户隔离的核心设计理念。

---

## 目录

1. [整体架构概述](#1-整体架构概述)
2. [Gateway架构](#2-gateway架构)
3. [Agent Runtime架构](#3-agent-runtime架构)
4. [通道系统架构](#4-通道系统架构)
5. [配置管理系统](#5-配置管理系统)
6. [安全架构](#6-安全架构)
7. [技术栈与部署](#7-技术栈与部署)
8. [架构优势](#8-架构优势)
9. [设计模式总结](#9-设计模式总结)
10. [未来改进方向](#10-未来改进方向)

---

## 1. 整体架构概述

### 1.1 三层架构设计

OpenClaw采用清晰的三层架构：

```
┌─────────────────────────────────────┐
│     通道层 (Channels)            │
│  WhatsApp/Telegram/Discord/...     │
│  - 消息适配器                  │
│  - 标准化格式                  │
└──────────────┬──────────────────┘
               │ WebSocket/HTTP
┌──────────────▼──────────────────┐
│     Gateway层 (控制平面)          │
│  - 路由与转发                   │
│  - 会话管理                     │
│  - 配置管理                     │
│  - 安全认证                     │
└──────────────┬──────────────────┘
               │ RPC
┌──────────────▼──────────────────┐
│     Agent层 (运行时)             │
│  - 工作区管理                   │
│  - 技能系统                     │
│  - 工具调用                     │
│  - 上下文注入                   │
└─────────────────────────────────────┘
```

### 1.2 核心设计原则

| 原则 | 描述 | 体现 |
|--------|------|------|
| **本地优先** | Gateway和Agent都在本地运行，数据本地化 | 单一进程、本地工作区 |
| **插件化** | 通道和技能都是可插拔的 | 通道适配器、技能加载器 |
| **事件驱动** | 基于WebSocket和事件流 | Gateway协议、Agent事件 |
| **多租户** | 支持多用户、多代理隔离 | 会话作用域、工作区隔离 |
| **安全性** | DM配对、严格验证、配置审计 | 不信任入站输入、Schema强制 |

---

## 2. Gateway架构

### 2.1 核心职责

Gateway是OpenClaw的**控制平面**，负责系统的协调和管理。

#### 2.1.1 路由与转发
- **单一多路复用端口**（默认18789）
- 支持：
  - WebSocket控制/RPC
  - HTTP APIs（OpenAI兼容、Responses、工具调用）
  - 控制UI和hooks
- **默认绑定模式**: `loopback`
- **认证必需**: token/password

#### 2.1.2 会话管理
- 会话生命周期管理
- 会话作用域控制（main/per-peer/per-channel-peer）
- 线程绑定
- 会话重置策略

#### 2.1.3 配置管理
- **配置文件**: `~/.openclaw/openclaw.json`
- **格式**: JSON5（支持注释和尾随逗号）
- **热重载模式**: off/hot/restart/hybrid
- **配置文件监控**: 自动检测更改并应用

#### 2.1.4 通道管理
- 多通道并发支持
- 通道适配器标准化
- DM和群组策略
- 消息路由

#### 2.1.5 安全与认证
- Token/Password认证
- DM配对机制（pairing/allowlist/open/disabled）
- Allowlist控制
- 配置审计（doctor命令）

### 2.2 Gateway运行时模型

```
┌─────────────────────────────────────┐
│  Gateway进程（始终运行）           │
├─────────────────────────────────────┤
│  ┌───────────────────────────┐   │
│  │ 事件循环                 │   │
│  │ - connect               │   │
│  │ - agent/chat/presence  │   │
│  │ - tick/health/heartbeat │   │
│  └───────────────────────────┘   │
├─────────────────────────────────────┤
│  ┌───────────────────────────┐   │
│  │ 状态管理                 │   │
│  │ - presence              │   │
│  │ - health               │   │
│  │ - stateVersion         │   │
│  │ - uptimeMs             │   │
│  └───────────────────────────┘   │
└─────────────────────────────────────┘
```

**关键特性**:
- 单一始终运行的进程
- 事件循环处理连接、消息、事件
- 状态快照（presence、health、stateVersion、uptimeMs）
- 协议：WebSocket + HTTP混合

### 2.3 协议设计

#### 2.3.1 Gateway协议
- **第一帧**: 必须是`connect`
- **响应**: `hello-ok`快照（presence、health、stateVersion、uptimeMs）
- **请求**: `req(method, params)` → `res(ok/payload|error)`
- **常见事件**: connect.challenge、agent、chat、presence、tick、health、heartbeat、shutdown

#### 2.3.2 Agent运行流程
```
1. Client发送run请求
2. Gateway返回accepted（立即ack）
3. Agent开始执行
4. 流式传输agent事件
5. Agent完成
6. Gateway返回ok/error（最终响应）
```

---

## 3. Agent Runtime架构

### 3.1 核心设计

#### 3.1.1 单一工作区
- **工作区路径**: `agents.defaults.workspace`
- 作为代理的唯一工作目录（cwd）
- 支持沙箱模式（非主会话可覆盖）

#### 3.1.2 Bootstrap文件系统

OpenClaw在工作区中期望这些用户可编辑文件：

| 文件 | 用途 | 注入时机 |
|------|------|---------|
| **AGENTS.md** | 操作指令+"memory" | 每次会话 |
| **SOUL.md** | 人格、边界、语气 | 每次会话 |
| **TOOLS.md** | 用户维护的工具注释 | 每次会话 |
| **BOOTSTRAP.md** | 一次性首次运行仪式 | 仅新工作区 |
| **IDENTITY.md** | 代理名称/氛围/emoji | 每次会话 |
| **USER.md** | 用户档案+首选地址 | 每次会话 |

**注入机制**:
- 新会话第一轮自动注入
- 空白文件跳过
- 大文件修剪截断（带标记以保持提示精简）
- 缺失文件注入"missing file"标记

#### 3.1.3 技能系统

**三层加载优先级**（名称冲突时工作区优先）:
1. **Bundled**: 随安装附带
2. **Managed/local**: `~/.openclaw/skills`
3. **Workspace**: `<workspace>/skills`

**技能控制**:
- 通过配置/环境门控
- SKILL.md定义使用方法
- 依赖管理

### 3.2 会话模型

#### 3.2.1 会话存储
- **格式**: JSONL
- **路径**: `~/.openclaw/agents/<agentId>/sessions/<SessionId>.jsonl`
- **会话ID**: 稳定，由OpenClaw选择
- **不读取**: Legacy Pi/Tau会话文件夹

#### 3.2.2 流式传输与引导

**队列模式**:
- **steer**: 实时注入到当前运行（每次工具调用后检查）
- **followup/collect**: 保持到当前轮结束，然后开始新轮次

**块流式传输**:
- **默认关闭**（`agents.defaults.blockStreamingDefault: "off"`）
- **边界控制**: `agents.defaults.blockStreamingBreak`（`text_end` vs `message_end`）
- **分块控制**: `agents.defaults.blockStreamingChunk`（默认800-1200字符）
- **合并控制**: `agents.defaults.blockStreamingCoalesce`（减少单行垃圾信息）

**行为**:
- 块流式传输在完成后立即发送完成的助手块
- 优先段落分隔符，然后换行，最后是句子
- 非Telegram通道需要显式`*.blockStreaming: true`

### 3.3 pi-mono集成
- **重用**: pi-mono代码库的部分（模型/工具）
- **OpenClaw拥有**: 会话管理、发现、工具连接
- **不使用**: pi-coding代理运行时、~/.pi/agent设置

### 3.4 模型引用解析
- 模型引用在**第一个**`/`上分割
- 使用`provider/model`格式配置模型
- 如果模型ID本身包含`/`（OpenRouter风格），包含提供者前缀
- 如果省略提供者，视为别名或**默认提供者**的模型

---

## 4. 通道系统架构

### 4.1 通道分类

#### 4.1.1 主流平台（内置）
- WhatsApp (Baileys) - 最受欢迎，QR配对
- Telegram (grammY) - Bot API，支持群组
- Discord (discord.js) - Bot API + Gateway，支持服务器/频道/DMs
- Slack (Bolt) - Workspace应用
- Google Chat (Chat API) - HTTP webhook
- Signal (signal-cli) - 注重隐私

#### 4.1.2 扩展平台（插件）
- BlueBubbles - iMessage推荐，REST API，完整功能支持
- Microsoft Teams - Bot Framework，企业支持
- Feishu/Lark - WebSocket，插件安装
- Mattermost - Bot API + WebSocket，插件安装
- Synology Chat - webhooks，NAS集成
- LINE - Messaging API，插件安装
- Nextcloud Talk - Nextcloud，自托管
- Matrix - Matrix protocol，插件安装
- Nostr - NIP-04，去中心化DMs
- Tlon - Urbit，插件安装
- Twitch - IRC连接，插件安装
- Zalo/Zalo Personal - Bot API，越南流行，插件安装
- WebChat - WebSocket，Gateway UI
- IRC - Classic IRC服务器

### 4.2 通道架构模式

#### 4.2.1 插件化设计
- 主流通道内置
- 扩展通道作为插件
- 统一接口抽象

#### 4.2.2 标准化消息格式
- 所有通道消息标准化为统一格式
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
- **DM策略**: pairing/allowlist/open/disabled
- **群组策略**: 提及门控
- **Allowlist控制**: 细粒度权限

#### 4.3.3 状态管理
- WhatsApp在磁盘存储更多状态
- 其他通道轻量级状态管理

---

## 5. 配置管理系统

### 5.1 配置架构

#### 5.1.1 配置文件
- **位置**: `~/.openclaw/openclaw.json`
- **格式**: JSON5（支持注释和尾随逗号）
- **行为**: 文件缺失时使用安全默认值

#### 5.1.2 配置编辑方式
- **交互式向导**: `openclaw onboard` / `openclaw configure`
- **CLI命令**: `openclaw config get/set/unset`
- **控制UI**: http://127.0.0.1:18789的Config标签
- **直接编辑**: 编辑openclaw.json，自动热重载

### 5.2 严格验证

#### 5.2.1 验证规则
- OpenClaw只接受完全匹配架构的配置
- 未知键、格式错误类型或无效值导致Gateway**拒绝启动**
- 根级别的唯一例外是`$schema`（字符串）

#### 5.2.2 验证失败处理
- Gateway不启动
- 只有诊断命令工作
- `openclaw doctor`显示确切问题
- `openclaw doctor --fix`应用修复

### 5.3 核心配置模块

#### 5.3.1 模块化设计
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

#### 5.3.2 关键配置项
- **agents**: workspace、model、sandbox、heartbeat
- **channels**: enabled、botToken、dmPolicy、allowFrom
- **gateway**: port、bind、auth、reload.mode
- **cron**: enabled、maxConcurrentRuns、sessionRetention
- **session**: dmScope、threadBindings、reset

---

## 6. 安全架构

### 6.1 安全设计原则

#### 6.1.1 不信任入站输入
- 入站DM被视为不受信任的输入
- Gateway协议客户端在Gateway不可用时快速失败
- 无效/非连接的第一帧被拒绝并关闭

#### 6.1.2 DM配对机制
- **pairing**（默认）: 未知发送者获得一次性配对代码
- **allowlist**: 仅allowFrom中的发送者
- **open**: 允许所有入站DMs（需要`allowFrom: ["*"]`）
- **disabled**: 忽略所有DMs

#### 6.1.3 群组安全
- 默认要求提及
- 支持原生@-提及和文本模式
- per-channel allowlist

#### 6.1.4 配置安全
- 严格验证（schema强制）
- 配置审计（doctor命令）
- 安全指南和故障排除

### 6.2 安全保证

| 保证 | 描述 |
|------|------|
| **快速失败** | Gateway不可用时客户端快速失败 |
| **拒绝无效帧** | 无效/非连接的第一帧被拒绝 |
| **优雅关闭** | 关闭前发出shutdown事件 |
| **本地优先** | 数据本地化，无云依赖 |

---

## 7. 技术栈与部署

### 7.1 技术栈

| 层级 | 技术 |
|------|------|
| **运行时** | Node ≥22 |
| **语言** | TypeScript |
| **包管理器** | npm、pnpm、bun |
| **核心依赖** | pi-mono（模型/工具） |
| **WhatsApp** | Baileys |
| **Telegram** | grammY |
| **Discord** | discord.js |
| **Slack** | Bolt |

### 7.2 部署选项

#### 7.2.1 macOS
- **服务**: launchd用户服务
- **标签**: `ai.openclaw.gateway`或`ai.openclaw.<profile>`
- **命令**: `openclaw gateway install`

#### 7.2.2 Linux
- **用户服务**: systemd user
- **系统服务**: systemd system（多用户/始终主机）
- **持久化**: `sudo loginctl enable-linger <user>`

#### 7.2.3 多实例
- 支持在同一主机上运行多个Gateway
- 每个实例需要唯一的端口、配置路径、状态目录、工作区

---

## 8. 架构优势

### 8.1 设计优势

| 优势 | 描述 |
|------|------|
| **灵活性** | 插件化设计，易于扩展新通道和技能 |
| **安全性** | 本地优先，严格验证，不信任入站输入 |
| **性能** | 事件驱动，流式传输，高效并发 |
| **可维护性** | 模块化配置，清晰分层，易于理解 |
| **多租户** | 支持多用户、多代理隔离 |
| **可观测性** | 日志、健康检查、诊断工具 |
| **本地优先** | 数据本地化，无云依赖，隐私保护 |

### 8.2 技术亮点

1. **单一多路复用端口**: WebSocket + HTTP混合，统一入口
2. **事件驱动架构**: 实时响应，低延迟
3. **插件化扩展**: 通道和技能都是可插拔的
4. **严格配置验证**: Schema强制，防止错误配置
5. **智能路由**: peer匹配 > parentPeer > guildId > accountId
6. **流式传输**: 块流式传输，实时反馈
7. **沙箱支持**: 隔离执行，增强安全性

---

##