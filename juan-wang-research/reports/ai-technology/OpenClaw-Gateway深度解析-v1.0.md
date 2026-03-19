# OpenClaw Gateway 深度解析

> **研究员**: 黄山 (wairesearch)  
> **版本**: v1.0  
> **日期**: 2026-03-19  
> **信息来源**: OpenClaw 官方文档 (2026.3.13, commit 61d171a)

---

## 目录

1. [概述与定位](#1-概述与定位)
2. [整体架构](#2-整体架构)
3. [WebSocket 协议](#3-websocket-协议)
4. [鉴权体系](#4-鉴权体系)
5. [设备配对与信任模型](#5-设备配对与信任模型)
6. [网络模型与远程访问](#6-网络模型与远程访问)
7. [安全架构](#7-安全架构)
8. [沙箱隔离](#8-沙箱隔离)
9. [会话管理](#9-会话管理)
10. [Agent 循环与执行引擎](#10-agent-循环与执行引擎)
11. [HTTP API 层](#11-http-api-层)
12. [自动化系统](#12-自动化系统)
13. [配置体系](#13-配置体系)
14. [密钥管理](#14-密钥管理)
15. [Channel 接入层](#15-channel-接入层)
16. [多 Agent 路由](#16-多-agent-路由)
17. [健康检查与运维](#17-健康检查与运维)
18. [威胁模型](#18-威胁模型)
19. [关键设计决策分析](#19-关键设计决策分析)
20. [附录：核心配置参考](#附录核心配置参考)

---

## 1. 概述与定位

### 1.1 Gateway 是什么

OpenClaw Gateway 是整个 OpenClaw 平台的**核心控制面**——一个长驻运行的 Node.js 进程，承担以下职责：

| 职责 | 说明 |
|------|------|
| **消息路由** | 连接所有 messaging surface（WhatsApp、Telegram、Discord、Slack、Signal、飞书等） |
| **协议网关** | 对外提供统一的 WebSocket + HTTP 复用端口 |
| **Agent 调度** | 管理 Agent 生命周期、会话、工具调用 |
| **安全边界** | 鉴权、配对、沙箱、工具策略的统一执行点 |
| **状态持有者** | 会话 transcript、cron job、配置的单一 source of truth |

### 1.2 核心设计哲学

```
"一个 Gateway，一个控制面，所有路由和策略的唯一执行者"
```

关键不变量（Invariants）：

- **每台主机一个 Gateway**（推荐）：它是唯一允许持有 WhatsApp Web session 的进程
- **Handshake 强制**：任何 WS 连接的第一帧必须是 `connect`，否则硬断开
- **事件不重放**：客户端断连后需主动刷新状态
- **优雅关闭**：关闭前发出 `shutdown` 事件

### 1.3 技术栈

- **运行时**: Node.js v22+
- **传输层**: WebSocket (text frames, JSON payload)
- **HTTP**: 同端口复用（WS + HTTP）
- **Schema**: TypeBox 定义协议 → 生成 JSON Schema → 生成 Swift models
- **默认端口**: 18789
- **默认绑定**: loopback (127.0.0.1)

---

## 2. 整体架构

### 2.1 组件拓扑

```
┌─────────────────────────────────────────────────────────────────┐
│                     外部消息面 (Messaging Surfaces)               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐│
│  │ WhatsApp │ │ Telegram │ │ Discord  │ │  Slack   │ │ 飞书   ││
│  │ (Baileys)│ │ (grammY) │ │          │ │          │ │ (SDK)  ││
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └───┬────┘│
└───────┼────────────┼────────────┼────────────┼────────────┼─────┘
        │            │            │            │            │
        ▼            ▼            ▼            ▼            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Gateway (核心进程)                           │
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐            │
│  │  WS Server  │  │ HTTP Server │  │ Channel Mgr  │            │
│  │  (控制面)    │  │ (API层)     │  │ (消息路由)    │            │
│  └──────┬──────┘  └──────┬──────┘  └──────┬───────┘            │
│         │                │                │                      │
│  ┌──────┴──────────────────────────────────┴───────┐            │
│  │              核心引擎层                           │            │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐        │            │
│  │  │ Session  │ │  Agent   │ │  Tool    │        │            │
│  │  │ Manager  │ │  Runner  │ │  Policy  │        │            │
│  │  └──────────┘ └──────────┘ └──────────┘        │            │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐        │            │
│  │  │  Cron    │ │  Hooks   │ │ Sandbox  │        │            │
│  │  │ Scheduler│ │  Engine  │ │ Manager  │        │            │
│  │  └──────────┘ └──────────┘ └──────────┘        │            │
│  └─────────────────────────────────────────────────┘            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
    ┌──────────────┐ ┌──────────┐ ┌──────────────┐
    │ Operator     │ │  Node    │ │  Canvas      │
    │ (CLI/UI/Mac) │ │(iOS/Mac) │ │  (HTML/JS)   │
    └──────────────┘ └──────────┘ └──────────────┘
```

### 2.2 端口复用架构

Gateway 在**单一端口** (默认 18789) 上同时承载：

| 服务 | 路径/协议 | 用途 |
|------|-----------|------|
| WebSocket 控制面 | `ws://host:18789` | 客户端 RPC + 事件推送 |
| OpenAI Chat API | `/v1/chat/completions` | OpenAI 兼容接口（默认关闭） |
| OpenResponses API | `/v1/responses` | OpenResponses 兼容接口（默认关闭） |
| Tools Invoke API | `/tools/invoke` | 直接工具调用（始终启用） |
| Channel API | `/api/channels/*` | Channel 特定端点 |
| Control UI | `/` (SPA) | Web 管理界面 |
| Canvas Host | `/__openclaw__/canvas/` | Agent 可编辑的 HTML/JS |
| A2UI Host | `/__openclaw__/a2ui/` | A2UI 渲染 |

### 2.3 连接生命周期

```
Client                          Gateway
  │                               │
  │   ← connect.challenge         │  (Gateway 发送 nonce)
  │                               │
  │   → req:connect               │  (Client 发送身份 + 签名)
  │     {role, scopes, device,    │
  │      auth, caps}              │
  │                               │
  │   ← res: hello-ok             │  (返回快照: presence, health,
  │     {protocol, policy,        │   stateVersion, uptimeMs)
  │      deviceToken?}            │
  │                               │
  │   ← event:presence            │  (推送在线状态)
  │   ← event:tick                │  (心跳 tick)
  │                               │
  │   → req:agent                 │  (发起 agent 运行)
  │   ← res:agent (accepted)     │  (立即返回 runId)
  │   ← event:agent (streaming)  │  (流式推送结果)
  │   ← res:agent (final)        │  (最终完成)
```

---

## 3. WebSocket 协议

### 3.1 协议版本

当前协议版本: **PROTOCOL_VERSION = 3**

- 定义位置: `src/gateway/protocol/schema.ts` (TypeBox schemas)
- 客户端在 `connect` 时发送 `minProtocol` + `maxProtocol`
- 版本不匹配则 Gateway 拒绝连接
- Schema 链: TypeBox → JSON Schema → Swift Models

### 3.2 帧格式

三种帧类型：

```typescript
// 请求帧
{ type: "req", id: string, method: string, params: object }

// 响应帧
{ type: "res", id: string, ok: boolean, payload?: object, error?: object }

// 事件帧
{ type: "event", event: string, payload: object, seq?: number, stateVersion?: number }
```

**幂等性要求**：所有副作用方法（`send`、`agent`）必须携带幂等键，Gateway 维护短期去重缓存。

### 3.3 角色与权限

#### Operator 角色（控制面客户端）

| Scope | 说明 |
|-------|------|
| `operator.read` | 读取状态、健康信息 |
| `operator.write` | 发送消息、触发 agent |
| `operator.admin` | 持久化配置变更（`/config set`） |
| `operator.approvals` | 解决 exec 审批请求 |
| `operator.pairing` | 管理设备配对 |

#### Node 角色（能力节点）

Node 在连接时声明：
- **caps**: 高级能力类别（camera, canvas, screen, location, voice）
- **commands**: 命令白名单（camera.snap, canvas.navigate 等）
- **permissions**: 细粒度开关（camera.capture: true/false）

Gateway 将这些视为**声明**，并在服务端强制执行白名单。

### 3.4 核心事件类型

| 事件 | 触发场景 |
|------|----------|
| `connect.challenge` | 连接前的 nonce 挑战 |
| `agent` | Agent 运行状态推送 |
| `chat` | 聊天消息更新 |
| `presence` | 在线状态变更 |
| `tick` | 心跳 tick（默认 15s） |
| `health` | 健康状态变更 |
| `heartbeat` | Heartbeat 运行事件 |
| `shutdown` | Gateway 关闭通知 |
| `exec.approval.requested` | Exec 审批请求 |

### 3.5 Agent 运行的两阶段响应

1. **立即确认**: `res:agent` → `{ runId, status: "accepted" }`
2. **最终结果**: `res:agent` → `{ runId, status: "ok"|"error", summary }`

两个阶段之间通过 `event:agent` 流式推送 assistant/tool 事件。

---

## 4. 鉴权体系

### 4.1 鉴权模式

Gateway 鉴权是**默认强制**的。未配置 token/password 时，Gateway 拒绝 WebSocket 连接（fail-closed）。

| 模式 | 配置 | 说明 |
|------|------|------|
| **Token** | `gateway.auth.mode: "token"` | Bearer token 认证（推荐） |
| **Password** | `gateway.auth.mode: "password"` | 密码认证 |
| **Trusted Proxy** | `gateway.auth.mode: "trusted-proxy"` | 委托给反向代理（Pomerium/Caddy/nginx） |
| **Tailscale Serve** | `gateway.auth.allowTailscale: true` | 信任 Tailscale 身份头 |

### 4.2 Token 认证流程

```
Client → Gateway:
  connect.params.auth.token = "your-token"

验证逻辑:
  if (gateway.auth.token 已配置) {
    token !== config.token → 关闭连接
  }
  
  if (OPENCLAW_GATEWAY_TOKEN 环境变量已设置) {
    token !== env.token → 关闭连接
  }
```

### 4.3 凭证优先级

**本地模式**:
1. `OPENCLAW_GATEWAY_TOKEN` (环境变量)
2. `gateway.auth.token` (配置)
3. `gateway.remote.token` (远程回退，仅当 auth.token 未设置)

**远程模式**:
1. `gateway.remote.token`
2. `OPENCLAW_GATEWAY_TOKEN`
3. `gateway.auth.token`

### 4.4 认证失败处理

错误响应包含诊断信息：
- `error.details.code`: 错误码（如 `AUTH_TOKEN_MISMATCH`）
- `error.details.canRetryWithDeviceToken`: 是否可用设备令牌重试
- `error.details.recommendedNextStep`: 建议的恢复操作

### 4.5 API Key 轮转

部分 provider 支持在 rate limit 时自动切换 key：

优先级：
1. `OPENCLAW_LIVE_<PROVIDER>_KEY` (单个覆盖)
2. `<PROVIDER>_API_KEYS` (多 key)
3. `<PROVIDER>_API_KEY` (单 key)
4. `<PROVIDER>_API_KEY_*` (通配)

仅在 rate-limit 错误（429 等）时尝试下一个 key。

### 4.6 Trusted Proxy 认证

适用于运行在 identity-aware proxy（Pomerium/Caddy/nginx+OAuth）后面的场景：

```json5
{
  gateway: {
    trustedProxies: ["10.0.0.1", "172.17.0.1"],
    auth: {
      mode: "trusted-proxy",
      trustedProxy: {
        userHeader: "x-forwarded-user",
        requiredHeaders: ["x-forwarded-proto", "x-forwarded-host"],
        allowUsers: ["admin@company.org"],
      },
    },
  },
}
```

工作原理：
1. 反向代理完成用户认证（OAuth/OIDC/SAML）
2. 代理添加认证用户身份头
3. OpenClaw 验证请求来自受信代理 IP
4. 从配置的头中提取用户身份

---

## 5. 设备配对与信任模型

### 5.1 设备身份

所有 WS 客户端（operator + node）在 `connect` 时必须包含设备身份：

```json
{
  "device": {
    "id": "device_fingerprint",        // 基于密钥对指纹的稳定设备ID
    "publicKey": "...",                 // 公钥
    "signature": "...",                 // 对 challenge nonce 的签名
    "signedAt": 1737264000000,          // 签名时间戳
    "nonce": "..."                      // 服务端提供的 nonce
  }
}
```

### 5.2 签名版本

| 版本 | 绑定内容 |
|------|----------|
| **v2** | device/client/role/scopes/token/nonce |
| **v3** (推荐) | v2 + platform + deviceFamily |

v3 在重连时会检查元数据是否匹配已配对的记录。

### 5.3 配对流程

```
1. 新设备 ID 连接 → Gateway 发送配对挑战
2. 本地连接（loopback/同主机 tailnet）→ 自动批准
3. 非本地连接 → 需要显式批准
4. 批准后 → Gateway 签发设备令牌 (deviceToken)
5. 后续连接使用 deviceToken 快速认证
```

### 5.4 设备令牌管理

- `device.token.rotate`: 轮转设备令牌（需 `operator.pairing` scope）
- `device.token.revoke`: 撤销设备令牌

### 5.5 Control UI 的例外

Control UI 仅在以下模式下可跳过设备身份：
- `gateway.controlUi.allowInsecureAuth=true` (仅 localhost HTTP 兼容)
- `gateway.controlUi.dangerouslyDisableDeviceAuth=true` (紧急模式，严重安全降级)

---

## 6. 网络模型与远程访问

### 6.1 绑定模式

| `gateway.bind` | 说明 | 安全要求 |
|-----------------|------|----------|
| `loopback` (默认) | 仅本地访问 | 最安全 |
| `lan` | 局域网可访问 | 必须配置 auth token |
| `tailnet` | Tailscale 网络 | 必须配置 auth token |
| `custom` | 自定义绑定 | 必须配置 auth token |

**核心规则**：非 loopback 绑定**必须**设置认证 token/password，否则 Gateway 拒绝启动。

### 6.2 远程访问方案

| 方案 | 优先级 | 说明 |
|------|--------|------|
| **Tailscale Serve** | ⭐推荐 | Gateway 保持 loopback，Tailscale 处理接入 |
| **SSH 隧道** | 备选 | `ssh -N -L 18789:127.0.0.1:18789 user@host` |
| **LAN 绑定** | 最后手段 | 需防火墙 + auth token |

### 6.3 TLS 支持

- WS 连接支持 TLS (`wss://`)
- 客户端可选择 pin Gateway 证书指纹
- 配置: `gateway.tls` + `gateway.remote.tlsFingerprint`
- 明文 `ws://` 默认仅限 loopback

### 6.4 mDNS/Bonjour 发现

Gateway 通过 mDNS (`_openclaw-gw._tcp`) 广播存在：

| 模式 | 广播内容 |
|------|----------|
| `minimal` (默认) | role, gatewayPort, transport |
| `full` | + cliPath, sshPort, displayName, lanHost |
| `off` | 禁用 mDNS |

⚠️ Full 模式会暴露文件系统路径和 SSH 信息。

### 6.5 Canvas Host 网络

Canvas 由 Gateway HTTP 服务器在**同端口**提供：
- `/__openclaw__/canvas/` (agent 可编辑的 HTML/CSS/JS)
- `/__openclaw__/a2ui/` (A2UI)

当 auth 已配置且 bind 非 loopback 时，这些路由受 Gateway auth 保护。

---

## 7. 安全架构

### 7.1 信任模型：个人助手模型

```
⚠️ 核心假设：每个 Gateway 实例 = 一个受信操作者边界
```

| 设计目标 | 说明 |
|----------|------|
| ✅ 支持 | 单用户/个人助手模型，一个信任边界 |
| ❌ 不支持 | 多个不信任用户共享同一 Gateway 的敌对多租户隔离 |

**如果需要多用户隔离**：每个信任边界运行独立的 Gateway + 独立的 OS 用户/主机。

### 7.2 安全层级（三层防御）

```
┌─────────────────────────────────────────────┐
│  第1层: 身份控制 (Identity First)            │
│  - DM 配对/白名单                            │
│  - Group 白名单 + @mention 门控              │
│  - 谁能跟 bot 说话？                         │
├─────────────────────────────────────────────┤
│  第2层: 范围控制 (Scope Next)                │
│  - 工具策略 (allow/deny)                     │
│  - 沙箱隔离                                  │
│  - Exec 审批                                 │
│  - bot 能做什么？                             │
├─────────────────────────────────────────────┤
│  第3层: 模型韧性 (Model Last)                │
│  - 假设模型可被操纵                           │
│  - 设计使操纵的影响范围有限                    │
│  - 使用最新、最强的指令遵循模型                │
└─────────────────────────────────────────────┘
```

### 7.3 信任边界矩阵

```
┌─────────────────────────────────────────────────────────────┐
│                 不信任区 (UNTRUSTED ZONE)                     │
│  WhatsApp │ Telegram │ Discord │ Slack │ 飞书 │ ...          │
└──────────────────────┬──────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  信任边界 1: Channel 接入                                     │
│  • 设备配对 / DM policy / allowFrom                          │
│  • Token/Password/Tailscale auth                             │
└──────────────────────┬──────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  信任边界 2: 会话隔离                                         │
│  • Session key = agent:channel:peer                          │
│  • 每 agent 工具策略                                         │
│  • Transcript 日志                                           │
└──────────────────────┬──────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  信任边界 3: 工具执行                                         │
│  • Docker 沙箱 / 主机 exec-approvals                         │
│  • Node 远程执行                                             │
│  • SSRF 防护 (DNS pinning + IP blocking)                     │
└─────────────────────────────────────────────────────────────┘
```

### 7.4 DM 接入策略

| dmPolicy | 行为 |
|----------|------|
| `pairing` (默认) | 未知发送者收到配对码，需审批 |
| `allowlist` | 仅白名单用户可通信 |
| `open` | 允许所有 DM（需 allowFrom 含 `"*"`） |
| `disabled` | 禁用 DM |

### 7.5 安全审计

```bash
openclaw security audit          # 常规检查
openclaw security audit --deep   # 深度检查（含 Gateway 探测）
openclaw security audit --fix    # 自动修复
```

审计涵盖：
- 入站访问（DM/Group 策略）
- 工具爆炸半径（elevated + open rooms）
- 网络暴露（bind/auth 配置）
- 浏览器控制暴露
- 磁盘权限
- 插件安全
- 策略漂移检测

### 7.6 关键安全配置

```json5
// 安全基线配置
{
  gateway: {
    mode: "local",
    bind: "loopback",
    auth: { mode: "token", token: "replace-with-long-random-token" },
  },
  session: { dmScope: "per-channel-peer" },
  tools: {
    profile: "messaging",
    deny: ["group:automation", "group:runtime", "group:fs",
           "sessions_spawn", "sessions_send"],
    fs: { workspaceOnly: true },
    exec: { security: "deny", ask: "always" },
    elevated: { enabled: false },
  },
  channels: {
    whatsapp: {
      dmPolicy: "pairing",
      groups: { "*": { requireMention: true } },
    },
  },
}
```

---

## 8. 沙箱隔离

### 8.1 沙箱模式

| `sandbox.mode` | 行为 |
|-----------------|------|
| `off` | 无沙箱，工具在主机执行 |
| `non-main` | 仅非 main 会话沙箱化 |
| `all` | 所有会话沙箱化 |

### 8.2 沙箱范围

| `sandbox.scope` | 行为 |
|------------------|------|
| `session` (默认) | 每会话一个容器 |
| `agent` | 每 agent 一个容器 |
| `shared` | 所有沙箱会话共享一个容器 |

### 8.3 工作区访问

| `workspaceAccess` | 行为 |
|---------------------|------|
| `none` (默认) | 工具使用沙箱工作区（`~/.openclaw/sandboxes`） |
| `ro` | Agent 工作区以只读挂载到 `/agent` |
| `rw` | Agent 工作区以读写挂载到 `/workspace` |

### 8.4 架构图

```
┌─────────────────────────────────────────┐
│              Gateway (主机)              │
│  ┌──────────────────────────────────┐   │
│  │         Agent Runner             │   │
│  └──────────┬───────────────────────┘   │
│             │                            │
│    ┌────────┼────────┐                   │
│    ▼        ▼        ▼                   │
│ ┌──────┐ ┌──────┐ ┌──────┐             │
│ │Session│ │Session│ │Session│ ← Docker   │
│ │  A   │ │  B   │ │  C   │   容器      │
│ │(沙箱)│ │(沙箱)│ │(主机)│             │
│ └──────┘ └──────┘ └──────┘             │
│                                          │
│  Elevated exec → 直接在主机执行           │
│  (绕过沙箱)                              │
└──────────────────────────────────────────┘
```

### 8.5 安全默认值

- 默认 `docker.network: "none"` (无网络)
- `network: "host"` 被阻止
- `network: "container:<id>"` 默认被阻止（命名空间加入风险）
- 容器内文件系统隔离
- 自定义 bind mounts 支持（受限制）

### 8.6 沙箱浏览器

独立的沙箱浏览器容器，带有：
- 专用 Docker 网络 (`openclaw-sandbox-browser`)
- 密码保护的 noVNC 观察端口
- CDP 源地址限制
- 保守的 Chromium 启动参数

---

## 9. 会话管理

### 9.1 会话键模型

```
agent:<agentId>:<mainKey>              ← DM 主会话
agent:<agentId>:<channel>:<peer>       ← 按发送者隔离
agent:<agentId>:<channel>:<group>      ← 群组会话
```

### 9.2 DM 隔离模式

| `session.dmScope` | 行为 | 推荐场景 |
|--------------------|------|----------|
| `main` (默认) | 所有 DM 共享主会话 | 单用户 |
| `per-peer` | 按发送者隔离 | 多用户 |
| `per-channel-peer` | 按 channel+发送者隔离 | 多用户多渠道 |
| `per-account-channel-peer` | 按 account+channel+发送者隔离 | 多账号多渠道 |

### 9.3 身份链接

`session.identityLinks` 可将同一个人在不同渠道的身份合并到同一会话：

```json5
{
  session: {
    identityLinks: [
      {
        canonical: "telegram:12345",
        aliases: ["whatsapp:+15551234567", "discord:user#1234"],
      },
    ],
  },
}
```

### 9.4 状态持久化

- 会话存储: `~/.openclaw/agents/<agentId>/sessions/sessions.json`
- 对话记录: `~/.openclaw/agents/<agentId>/sessions/<SessionId>.jsonl`
- Telegram topic: `<SessionId>-topic-<threadId>.jsonl`

### 9.5 维护策略

```json5
{
  session: {
    maintenance: {
      mode: "enforce",        // warn | enforce
      pruneAfter: "30d",      // 清理超过30天的会话
      maxEntries: 500,        // 最大会话数
      rotateBytes: "10mb",    // sessions.json 轮转阈值
      maxDiskBytes: "1gb",    // 磁盘预算上限
    },
  },
}
```

---

## 10. Agent 循环与执行引擎

### 10.1 完整生命周期

```
消息到达
  │
  ▼
① 入站处理
  │  - Channel adapter 接收
  │  - DM/Group 策略检查
  │  - 配对/白名单验证
  │
  ▼
② 会话路由
  │  - 解析 sessionKey
  │  - 加载/创建会话
  │  - 命令队列序列化
  │
  ▼
③ Agent 运行准备
  │  - 工作区解析 (可能是沙箱)
  │  - Skills 加载/注入
  │  - Bootstrap 文件注入
  │  - 系统提示词组装
  │
  ▼
④ 模型推理 (pi-agent-core)
  │  - 模型 + auth profile 解析
  │  - 流式推理
  │  - Tool calls 判断
  │
  ▼
⑤ 工具执行
  │  - 工具策略检查 (allow/deny)
  │  - 沙箱/主机路由
  │  - Exec 审批 (如需)
  │  - 结果收集
  │
  ▼ (可能循环 ④⑤)
  │
⑥ 回复整形
  │  - NO_REPLY 过滤
  │  - 消息工具去重
  │  - 流式分块输出
  │
  ▼
⑦ 持久化
  │  - Transcript 写入
  │  - 会话状态更新
  │  - 自动压缩 (如需)
  │
  ▼
⑧ 出站投递
     - Channel adapter 发送
     - 分块/格式化
```

### 10.2 队列与并发

- 每会话键串行执行（session lane）
- 可选全局 lane 限制
- 防止 tool/session 竞态
- Channel 可选队列模式: collect/steer/followup

### 10.3 超时控制

| 配置 | 默认值 | 说明 |
|------|--------|------|
| `agents.defaults.timeoutSeconds` | 600s | Agent 运行总超时 |
| `agent.wait` | 30s | 等待调用超时（不停止 agent） |

### 10.4 Hook 系统

**内部 Hook (Gateway hooks)**:
- `agent:bootstrap`: Bootstrap 文件注入前
- `command:new/reset/stop`: 命令事件
- `gateway:startup`: Gateway 启动后
- `message:received/sent`: 消息收发

**插件 Hook (Plugin hooks)**:
- `before_model_resolve`: 模型解析前
- `before_prompt_build`: 提示词构建前
- `before_tool_call / after_tool_call`: 工具调用前后
- `tool_result_persist`: 工具结果持久化前
- `before_compaction / after_compaction`: 压缩前后

### 10.5 压缩机制

当上下文超过限制时触发自动压缩：
- 发出 `compaction` 流事件
- 可能触发重试
- 重试时重置内存缓冲区避免重复输出

---

## 11. HTTP API 层

### 11.1 OpenAI Chat Completions

```
POST /v1/chat/completions
Authorization: Bearer <gateway-token>
```

- 默认**关闭**，需手动启用
- 同 Gateway agent 运行的完整代码路径
- 通过 `model: "openclaw:<agentId>"` 选择 agent
- 支持 SSE 流式响应
- 默认无状态，通过 `user` 字段可实现有状态会话

### 11.2 OpenResponses API

```
POST /v1/responses
Authorization: Bearer <gateway-token>
```

- 默认**关闭**
- 支持 item-based 输入
- 支持 client tool definitions
- 支持 function_call_output 回传

### 11.3 Tools Invoke API

```
POST /tools/invoke
Authorization: Bearer <gateway-token>
```

- **始终启用**
- 直接调用单个工具（不经过 agent 循环）
- 受 Gateway auth + 工具策略双重限制
- 默认硬拒绝: `sessions_spawn`, `sessions_send`, `gateway`, `whatsapp_login`

### 11.4 安全边界

⚠️ 所有 HTTP API 端点的认证都是**全操作者级别**访问：

> 有效的 Gateway token/password = 完全的操作者凭证。没有单独的 per-user 工具边界。

---

## 12. 自动化系统

### 12.1 Heartbeat（心跳）

定期 agent 运行，让模型自主检查是否有需要关注的事项：

```json5
{
  agents: {
    defaults: {
      heartbeat: {
        every: "30m",           // 间隔（0m 禁用）
        target: "last",         // 投递目标
        lightContext: true,      // 仅注入 HEARTBEAT.md
        activeHours: {           // 活跃时段
          start: "08:00",
          end: "24:00",
        },
      },
    },
  },
}
```

响应契约：
- 无事 → `HEARTBEAT_OK`（自动过滤，不投递）
- 有事 → 直接输出告警内容

### 12.2 Cron（计划任务）

Gateway 内置调度器，支持：

| 调度类型 | 说明 |
|----------|------|
| `at` | 一次性定时任务 |
| `every` | 固定间隔 |
| `cron` | 5/6 字段 cron 表达式 |

执行模式：

| 模式 | 说明 |
|------|------|
| `main` | 在主会话中作为 system event 执行 |
| `isolated` | 独立 cron session，专用 agent turn |

投递模式：
- `announce`: 结果发送到目标 channel
- `webhook`: HTTP POST 到外部 URL
- `none`: 仅内部执行

### 12.3 Hooks（事件钩子）

基于事件的自动化系统：

```
目录发现: workspace hooks → managed hooks → bundled hooks
                 ↓
            HOOK.md 解析
                 ↓
            资格检查 (bins, env, config, os)
                 ↓
            Handler 注册
                 ↓
            事件触发执行
```

内置 Hook:
- **session-memory**: `/new` 时保存会话到记忆文件
- **bootstrap-extra-files**: 注入额外 bootstrap 文件
- **command-logger**: 命令审计日志
- **boot-md**: Gateway 启动时执行 BOOT.md

### 12.4 Webhooks

HTTP webhook 端点，让外部系统触发 Gateway 工作：

```json5
{
  hooks: {
    enabled: true,
    token: "shared-secret",
    path: "/hooks",
    mappings: [{
      match: { path: "gmail" },
      action: "agent",
      agentId: "main",
      deliver: true,
    }],
  },
}
```

---

## 13. 配置体系

### 13.1 配置格式

- **文件**: `~/.openclaw/openclaw.json` (JSON5 格式，支持注释)
- **严格验证**: 未知键或非法值会导致 Gateway 拒绝启动
- **唯一例外**: 根级 `$schema` 键

### 13.2 配置方式

| 方式 | 命令 |
|------|------|
| 交互向导 | `openclaw onboard` / `openclaw configure` |
| CLI 单行 | `openclaw config set/get/unset` |
| Control UI | Web 界面表单编辑 |
| 直接编辑 | 编辑 `openclaw.json`，自动热重载 |
| RPC | `config.apply` (全量) / `config.patch` (增量) |

### 13.3 热重载

| 模式 | 行为 |
|------|------|
| `hybrid` (默认) | 安全变更热应用，需重启的自动重启 |
| `hot` | 仅热应用安全变更，需重启时仅警告 |
| `restart` | 任何变更都重启 |
| `off` | 禁用文件监视 |

热应用 vs 需重启：

| 类别 | 示例字段 | 需重启? |
|------|----------|---------|
| Channels | `channels.*` | ❌ |
| Agent & models | `agent`, `agents`, `models` | ❌ |
| Automation | `hooks`, `cron`, `heartbeat` | ❌ |
| Sessions | `session`, `messages` | ❌ |
| Tools & media | `tools`, `browser`, `skills` | ❌ |
| **Gateway server** | `gateway.*` (port, bind, auth, TLS) | ✅ |
| **Infrastructure** | `discovery`, `canvasHost`, `plugins` | ✅ |

### 13.4 配置拆分

支持 `$include` 将大配置拆分为多文件：

```json5
{
  gateway: { port: 18789 },
  agents: { $include: "./agents.json5" },
  broadcast: {
    $include: ["./clients/a.json5", "./clients/b.json5"],
  },
}
```

- 支持嵌套 include（最多 10 层）
- 相对路径基于包含文件解析
- 数组 include 按顺序深度合并（后者覆盖前者）

### 13.5 环境变量

读取顺序：
1. 父进程环境变量
2. 当前目录 `.env`
3. `~/.openclaw/.env`

支持配置内引用: `${VAR_NAME}` 语法

### 13.6 RPC 写入限流

`config.apply` / `config.patch` / `update.run` 限制为 **3次/60秒** per `deviceId+clientIp`。

---

## 14. 密钥管理

### 14.1 SecretRef 契约

所有支持的凭证字段可使用 SecretRef 对象替代明文：

```json5
// 环境变量源
{ source: "env", provider: "default", id: "OPENAI_API_KEY" }

// 文件源 (JSON pointer)
{ source: "file", provider: "filemain", id: "/providers/openai/apiKey" }

// 外部命令源
{ source: "exec", provider: "vault", id: "providers/openai/apiKey" }
```

### 14.2 运行时模型

```
启动时 SecretRef 解析
         │
         ▼
  内存快照 (atomic swap)
         │
   ┌─────┼─────┐
   ▼     ▼     ▼
  成功   失败   重载
  │      │      │
  ▼      ▼      ▼
 使用   启动中止  保持上次
 快照   (fail-fast) 已知好快照
```

关键行为：
- 解析是**急切的**（启动时），不是请求路径上的懒加载
- 重载使用原子交换：全部成功或保持旧快照
- 运行时请求仅从内存快照读取
- 仅验证**有效活跃**的 surface（禁用的 channel 不阻塞启动）

### 14.3 Exec Provider 集成

支持与外部密钥管理工具集成：

| 工具 | 支持状态 |
|------|----------|
| **1Password CLI** | ✅ (`op read` 命令) |
| **HashiCorp Vault** | ✅ (`vault kv get` 命令) |
| **sops** | ✅ (解密命令) |
| 自定义脚本 | ✅ (遵循 JSON 请求/响应协议) |

### 14.4 凭证存储位置

| 凭证 | 路径 |
|------|------|
| WhatsApp creds | `~/.openclaw/credentials/whatsapp/<accountId>/creds.json` |
| Telegram token | 配置/环境变量 |
| Model auth profiles | `~/.openclaw/agents/<agentId>/agent/auth-profiles.json` |
| 文件密钥 (可选) | `~/.openclaw/secrets.json` |
| 配对白名单 | `~/.openclaw/credentials/<channel>-allowFrom.json` |

### 14.5 安全审计

```bash
openclaw secrets audit --check    # 检查明文暴露
openclaw secrets configure        # 交互式 SecretRef 配置
openclaw secrets reload           # 重新加载密钥
```

---

## 15. Channel 接入层

### 15.1 支持的 Channel

| Channel | 协议/SDK | 特性 |
|---------|----------|------|
| WhatsApp | Baileys (Web) | 完整支持 |
| Telegram | grammY | 流式卡片输出 |
| Discord | discord.js | Guild/Thread 支持 |
| Slack | Bolt | Channel/Thread 支持 |
| Signal | signal-cli | 端到端加密 |
| iMessage | BlueBubbles | macOS 限定 |
| 飞书/Lark | Feishu SDK | WebSocket 长连接 |
| Google Chat | API | Service Account 认证 |
| MS Teams | Bot Framework | |
| Mattermost | Plugin | |
| IRC | Plugin | |
| Matrix | Plugin | |
| LINE | Plugin | |
| Nostr | Plugin | |

### 15.2 Channel 通用配置模式

所有 Channel 共享相同的 DM 策略模式：

```json5
{
  channels: {
    <channel>: {
      enabled: true,
      dmPolicy: "pairing",    // pairing | allowlist | open | disabled
      allowFrom: ["id1"],     // DM 白名单
      groupPolicy: "open",    // open | allowlist | disabled
      groupAllowFrom: [],     // Group 白名单
      groups: {
        "*": { requireMention: true },  // 默认需要 @mention
      },
    },
  },
}
```

### 15.3 飞书特殊支持

- **连接模式**: WebSocket 长连接（无需公网 webhook URL）
- **流式输出**: 交互式卡片流式回复
- **块级流式**: `blockStreaming: true`
- **多账号**: 支持 `accounts` 多 Bot 配置
- **Lark 国际版**: `domain: "lark"`

---

## 16. 多 Agent 路由

### 16.1 Agent 列表

```json5
{
  agents: {
    list: [
      { id: "home", default: true, workspace: "~/.openclaw/workspace-home" },
      { id: "work", workspace: "~/.openclaw/workspace-work" },
      { id: "public", workspace: "~/.openclaw/workspace-public" },
    ],
  },
}
```

### 16.2 Bindings 路由规则

```json5
{
  bindings: [
    {
      agentId: "home",
      match: {
        channel: "whatsapp",
        peer: { kind: "direct", id: "+15551234567" },
      },
    },
    {
      agentId: "work",
      match: {
        channel: "feishu",
        peer: { kind: "group", id: "oc_xxx" },
      },
    },
  ],
}
```

路由字段：
- `match.channel`: 渠道名称
- `match.peer.kind`: `"direct"` 或 `"group"`
- `match.peer.id`: 用户/群组 ID
- `match.accountId`: 多账号路由

### 16.3 Per-Agent 安全配置

每个 Agent 可独立配置沙箱和工具策略：

| 场景 | 沙箱 | 工具 |
|------|------|------|
| 个人 Agent | off | 全部 |
| 家庭/工作 Agent | all + ro | 仅 read |
| 公共 Agent | all + none | 仅 messaging |

---

## 17. 健康检查与运维

### 17.1 健康检查命令

```bash
# 本地状态摘要
openclaw status

# 全量本地诊断（安全可分享）
openclaw status --all

# 含 Gateway 探测的深度诊断
openclaw status --deep

# Gateway 健康快照（JSON）
openclaw health --json

# Channel 连通性探测
openclaw channels status --probe

# 安全审计
openclaw security audit --deep

# 自动修复
openclaw doctor --fix
```

### 17.2 服务管理

```bash
# 安装为系统服务
openclaw gateway install

# 状态查看
openclaw gateway status
openclaw gateway status --deep --json

# 重启/停止
openclaw gateway restart
openclaw gateway stop

# 日志跟踪
openclaw logs --follow
```

### 17.3 服务监管

| 平台 | 机制 |
|------|------|
| macOS | launchd (`ai.openclaw.gateway`) |
| Linux | systemd user service |
| Linux (系统级) | systemd system service |

### 17.4 常见故障签名

| 签名 | 可能原因 |
|------|----------|
| `refusing to bind gateway ... without auth` | 非 loopback 绑定但未配置认证 |
| `another gateway instance is already listening` | 端口冲突 |
| `Gateway start blocked: set gateway.mode=local` | 配置为远程模式 |
| `unauthorized` during connect | 客户端认证不匹配 |

---

## 18. 威胁模型

### 18.1 框架

OpenClaw 采用 **MITRE ATLAS** (Adversarial Threat Landscape for AI Systems) 框架进行威胁建模。

### 18.2 关键威胁类别

| 类别 | 风险等级 | 主要威胁 |
|------|----------|----------|
| **Prompt 注入** | 高 | 通过消息/附件/网页操纵模型行为 |
| **工具滥用** | 高 | 被操纵的模型执行危险的 exec/file/network 操作 |
| **跨租户泄露** | 中 | 共享 Gateway 下不同用户间的上下文泄露 |
| **凭证暴露** | 中 | 配置/日志/transcript 中的明文密钥 |
| **网络暴露** | 高 | Gateway 端口公网暴露 |
| **浏览器控制** | 中 | 通过 browser tool 访问已登录的账号 |

### 18.3 非设计漏洞

以下模式在 OpenClaw 信任模型中**不被视为漏洞**：
- 仅 prompt 注入链（无策略/auth/沙箱绕过）
- 假设敌对多租户场景的报告
- 将 `sessionKey` 作为 auth token 的 IDOR 报告
- 仅 localhost 的 HSTS 发现
- Operator 读路径访问（如 `sessions.list`）

---

## 19. 关键设计决策分析

### 19.1 为什么选择单进程单端口？

| 优势 | 说明 |
|------|------|
| **运维简单** | 一个进程管理所有状态 |
| **一致性** | 会话/配置/路由在同一个内存空间 |
| **端口复用** | WS + HTTP 共享端口，无需多端口管理 |
| **状态一致** | 避免多进程间的状态同步问题 |

| 劣势 | 说明 |
|------|------|
| **单点故障** | Gateway 挂掉全部不可用 |
| **水平扩展** | 不支持原生的多 Gateway 负载均衡 |
| **内存上限** | 所有会话在同一进程内存 |

### 19.2 为什么采用个人助手信任模型？

核心权衡：**安全性 vs 易用性**

选择个人助手模型意味着：
- ✅ 不需要复杂的 per-request 鉴权
- ✅ Operator 获得完整控制权
- ✅ 工具执行链路简化
- ❌ 不能在同一 Gateway 上运行不信任用户
- ❌ 多租户 SaaS 需要额外架构

### 19.3 为什么 WebSocket 而非 REST？

| 维度 | WebSocket | REST |
|------|-----------|------|
| 实时推送 | 原生支持 | 需要轮询/SSE |
| Agent 流式 | 天然适合 | 需要额外协议 |
| 连接管理 | 状态化 | 无状态 |
| 双向通信 | 原生 | 需要 webhook |
| 设备配对 | 连接级认证 | 请求级认证 |

### 19.4 为什么文件系统作为状态存储？

| 维度 | 文件系统 | 数据库 |
|------|----------|--------|
| 运维成本 | 零 | 需要额外运维 |
| 部署复杂度 | 低 | 高 |
| 备份 | 文件复制 | dump/restore |
| 性能 | 单用户足够 | 多用户更好 |
| 适用场景 | 个人助手 | 多租户 SaaS |

---

## 附录：核心配置参考

### Gateway 核心

```json5
{
  gateway: {
    port: 18789,                    // 端口
    bind: "loopback",              // 绑定模式
    mode: "local",                 // local | remote
    auth: {
      mode: "token",               // token | password | trusted-proxy
      token: "...",                // Gateway token
      rateLimit: {},               // 认证失败限流
      allowTailscale: true,        // Tailscale Serve 认证
    },
    reload: {
      mode: "hybrid",             // hot | restart | hybrid | off
      debounceMs: 300,
    },
    http: {
      endpoints: {
        chatCompletions: { enabled: false },
        responses: { enabled: false },
      },
    },
    tls: {},                       // TLS 配置
    trustedProxies: [],            // 可信代理 IP
    push: { apns: {} },           // iOS 推送
  },
}
```

### Agent 配置

```json5
{
  agents: {
    defaults: {
      workspace: "~/.openclaw/workspace",
      model: { primary: "anthropic/claude-sonnet-4-5" },
      heartbeat: { every: "30m" },
      sandbox: { mode: "off" },
      timeoutSeconds: 600,
      userTimezone: "Asia/Shanghai",
    },
    list: [
      {
        id: "main",
        default: true,
        workspace: "~/.openclaw/workspace",
        tools: {},
        sandbox: {},
        heartbeat: {},
      },
    ],
  },
}
```

### 工具策略

```json5
{
  tools: {
    profile: "full",              // messaging | minimal | full
    allow: [],                     // 额外允许
    deny: [],                      // 额外禁止
    exec: {
      security: "allowlist",      // deny | allowlist | full
      ask: "on-miss",             // off | on-miss | always
      host: "sandbox",            // sandbox | gateway
    },
    elevated: { enabled: false },  // 主机 exec 逃逸口
    fs: { workspaceOnly: false },  // 文件系统限制
  },
}
```

### 会话配置

```json5
{
  session: {
    dmScope: "per-channel-peer",
    mainKey: "main",
    threadBindings: { enabled: true },
    reset: {
      mode: "daily",
      atHour: 4,
      idleMinutes: 120,
    },
    maintenance: {
      mode: "enforce",
      pruneAfter: "30d",
      maxEntries: 500,
    },
  },
}
```

---

## 参考来源

1. OpenClaw 官方文档 - Gateway Architecture (`/concepts/architecture.md`)
2. OpenClaw 官方文档 - Gateway Protocol (`/gateway/protocol.md`)
3. OpenClaw 官方文档 - Authentication (`/gateway/authentication.md`)
4. OpenClaw 官方文档 - Security (`/gateway/security/index.md`)
5. OpenClaw 官方文档 - Sandboxing (`/gateway/sandboxing.md`)
6. OpenClaw 官方文档 - Configuration (`/gateway/configuration.md`)
7. OpenClaw 官方文档 - Secrets Management (`/gateway/secrets.md`)
8. OpenClaw 官方文档 - Agent Loop (`/concepts/agent-loop.md`)
9. OpenClaw 官方文档 - Session Management (`/concepts/session.md`)
10. OpenClaw 官方文档 - Heartbeat (`/gateway/heartbeat.md`)
11. OpenClaw 官方文档 - Cron Jobs (`/automation/cron-jobs.md`)
12. OpenClaw 官方文档 - Hooks (`/automation/hooks.md`)
13. OpenClaw 官方文档 - Network Model (`/gateway/network-model.md`)
14. OpenClaw 官方文档 - Remote Access (`/gateway/remote.md`)
15. OpenClaw 官方文档 - Health Checks (`/gateway/health.md`)
16. OpenClaw 官方文档 - Bridge Protocol (`/gateway/bridge-protocol.md`)
17. OpenClaw 官方文档 - OpenAI HTTP API (`/gateway/openai-http-api.md`)
18. OpenClaw 官方文档 - OpenResponses API (`/gateway/openresponses-http-api.md`)
19. OpenClaw 官方文档 - Tools Invoke API (`/gateway/tools-invoke-http-api.md`)
20. OpenClaw 官方文档 - Trusted Proxy Auth (`/gateway/trusted-proxy-auth.md`)
21. OpenClaw 官方文档 - Feishu Channel (`/channels/feishu.md`)
22. OpenClaw 官方文档 - Threat Model Atlas (`/security/THREAT-MODEL-ATLAS.md`)
23. OpenClaw 版本: 2026.3.13 (commit 61d171a)
