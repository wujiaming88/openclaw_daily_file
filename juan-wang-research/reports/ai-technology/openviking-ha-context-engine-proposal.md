# OpenClaw + OpenViking 高可用上下文引擎技术方案

> **版本**: v1.0 | **日期**: 2026-03-10 | **作者**: wairesearch  
> **状态**: 提案 (Proposal)

---

## 目录

1. [执行摘要](#1-执行摘要)
2. [OpenClaw Context Engine 接口详解](#2-openclaw-context-engine-接口详解)
3. [OpenViking 架构深度分析](#3-openviking-架构深度分析)
4. [高可用架构设计](#4-高可用架构设计)
5. [集成方案设计](#5-集成方案设计)
6. [实施路线图](#6-实施路线图)
7. [风险评估与缓解](#7-风险评估与缓解)
8. [附录](#8-附录)

---

## 1. 执行摘要

本方案通过 OpenClaw 的 **pluggable Context Engine** 机制与 **OpenViking** 上下文数据库深度集成，实现：

- **统一上下文管理**：Memory/Resource/Skill 通过文件系统范式统一组织
- **三级按需加载**：L0/L1/L2 层级控制 token 消耗，降低 83-96% 输入 token 成本
- **高可用存储**：通过 S3/NFS 后端 + 多实例部署，消除单点故障
- **多 Agent 共享**：5 个 Agent（main/waicode/waidesign/wairesearch/waiqa）共享同一上下文数据库
- **自动故障转移**：主从复制 + 健康检查 + 自动切换

### 目标架构总览

```
┌──────────────────────────────────────────────────────────────────┐
│                         OpenClaw Gateway                          │
│                                                                    │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐ │
│  │  main    │ │ waicode  │ │waidesign │ │wairesearch│ │ waiqa  │ │
│  │  Agent   │ │  Agent   │ │  Agent   │ │  Agent   │ │ Agent  │ │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └───┬────┘ │
│       │             │            │             │            │      │
│  ┌────▼─────────────▼────────────▼─────────────▼────────────▼──┐  │
│  │          OpenViking Context Engine Plugin                    │  │
│  │  (implements ContextEngine interface: ingest/assemble/compact)│  │
│  └──────────────────────┬──────────────────────────────────────┘  │
│                          │                                         │
│  ┌──────────────────────▼──────────────────────────────────────┐  │
│  │          OpenViking Memory Slot Plugin                       │  │
│  │  (memory_recall / memory_store / memory_forget tools)        │  │
│  └──────────────────────┬──────────────────────────────────────┘  │
└──────────────────────────┼─────────────────────────────────────────┘
                           │ HTTP API (:1933)
              ┌────────────▼────────────┐
              │    Load Balancer / VIP   │
              └─────┬──────────┬────────┘
                    │          │
          ┌─────────▼──┐  ┌───▼──────────┐
          │ OpenViking │  │  OpenViking   │
          │  Primary   │  │   Standby     │
          │  Instance  │  │   Instance    │
          └─────┬──────┘  └──────┬────────┘
                │                │
          ┌─────▼────────────────▼────────┐
          │     Shared Storage Layer       │
          │  (S3 / NFS / Distributed FS)   │
          │  ┌─────────┐  ┌────────────┐  │
          │  │  AGFS   │  │Vector Index│  │
          │  │ Content  │  │  (Dense +  │  │
          │  │ Storage  │  │  Sparse)   │  │
          │  └─────────┘  └────────────┘  │
          └────────────────────────────────┘
```

---

## 2. OpenClaw Context Engine 接口详解

### 2.1 接口概述

OpenClaw 通过 `plugins.slots.contextEngine` 配置项选择活跃的 Context Engine。默认使用内置的 `legacy` 引擎。自定义引擎通过插件注册：

```typescript
api.registerContextEngine("openviking", () => new OpenVikingContextEngine(config));
```

### 2.2 ContextEngine 接口定义

源码位置：`/usr/lib/node_modules/openclaw/dist/plugin-sdk/context-engine/types.d.ts`

```typescript
interface ContextEngine {
  /** 引擎元信息 */
  readonly info: ContextEngineInfo;

  /** 初始化引擎状态，可导入历史上下文 */
  bootstrap?(params: {
    sessionId: string;
    sessionFile: string;
  }): Promise<BootstrapResult>;

  /** 写入单条消息到引擎存储 */
  ingest(params: {
    sessionId: string;
    message: AgentMessage;
    isHeartbeat?: boolean;
  }): Promise<IngestResult>;

  /** 批量写入一个完整 turn */
  ingestBatch?(params: {
    sessionId: string;
    messages: AgentMessage[];
    isHeartbeat?: boolean;
  }): Promise<IngestBatchResult>;

  /** Turn 完成后的生命周期处理（持久化、后台压缩等） */
  afterTurn?(params: {
    sessionId: string;
    sessionFile: string;
    messages: AgentMessage[];
    prePromptMessageCount: number;
    autoCompactionSummary?: string;
    isHeartbeat?: boolean;
    tokenBudget?: number;
    runtimeContext?: ContextEngineRuntimeContext;
  }): Promise<void>;

  /** 在 token 预算内组装模型上下文 */
  assemble(params: {
    sessionId: string;
    messages: AgentMessage[];
    tokenBudget?: number;
  }): Promise<AssembleResult>;

  /** 压缩上下文以减少 token 使用 */
  compact(params: {
    sessionId: string;
    sessionFile: string;
    tokenBudget?: number;
    force?: boolean;
    currentTokenCount?: number;
    compactionTarget?: "budget" | "threshold";
    customInstructions?: string;
    runtimeContext?: ContextEngineRuntimeContext;
  }): Promise<CompactResult>;

  /** 为子代理准备上下文状态 */
  prepareSubagentSpawn?(params: {
    parentSessionKey: string;
    childSessionKey: string;
    ttlMs?: number;
  }): Promise<SubagentSpawnPreparation | undefined>;

  /** 子代理生命周期结束通知 */
  onSubagentEnded?(params: {
    childSessionKey: string;
    reason: SubagentEndReason;
  }): Promise<void>;

  /** 释放资源 */
  dispose?(): Promise<void>;
}
```

### 2.3 核心方法详解

#### `ingest()` — 消息写入

| 参数 | 类型 | 说明 |
|------|------|------|
| `sessionId` | string | 会话 ID |
| `message` | AgentMessage | 单条消息（user/assistant/tool） |
| `isHeartbeat` | boolean? | 是否心跳消息 |

返回 `IngestResult { ingested: boolean }` — 是否成功写入（去重时可返回 false）。

**设计要点**：
- Legacy 引擎的 `ingest` 是 no-op（SessionManager 自行处理持久化）
- 自定义引擎应将消息转发到 OpenViking 的 Session API

#### `assemble()` — 上下文组装

| 参数 | 类型 | 说明 |
|------|------|------|
| `sessionId` | string | 会话 ID |
| `messages` | AgentMessage[] | 当前所有消息 |
| `tokenBudget` | number? | Token 预算上限 |

返回：
```typescript
type AssembleResult = {
  messages: AgentMessage[];        // 排序后的模型上下文消息
  estimatedTokens: number;         // 估算总 token 数
  systemPromptAddition?: string;   // 注入到系统提示的额外内容
};
```

**设计要点**：
- 这是集成 L0/L1/L2 三级加载的关键入口
- 可通过 `systemPromptAddition` 注入 OpenViking 检索到的记忆

#### `compact()` — 上下文压缩

| 参数 | 类型 | 说明 |
|------|------|------|
| `sessionId` | string | 会话 ID |
| `sessionFile` | string | 会话 JSONL 文件路径 |
| `tokenBudget` | number? | 目标 token 预算 |
| `force` | boolean? | 是否强制压缩 |
| `currentTokenCount` | number? | 当前 token 数 |
| `compactionTarget` | string? | 压缩目标模式 |

返回：
```typescript
type CompactResult = {
  ok: boolean;
  compacted: boolean;
  reason?: string;
  result?: {
    summary?: string;
    firstKeptEntryId?: string;
    tokensBefore: number;
    tokensAfter?: number;
    details?: unknown;
  };
};
```

**设计要点**：
- 当 `info.ownsCompaction = true` 时，引擎完全接管压缩生命周期
- OpenViking 的 Session Compressor 天然适配此接口

### 2.4 注册机制

```typescript
// registry.d.ts
type ContextEngineFactory = () => ContextEngine | Promise<ContextEngine>;

function registerContextEngine(id: string, factory: ContextEngineFactory): void;
function resolveContextEngine(config?: OpenClawConfig): Promise<ContextEngine>;
```

配置激活：
```json
{
  "plugins": {
    "slots": {
      "contextEngine": "openviking-context"
    }
  }
}
```

### 2.5 插件清单 (openclaw.plugin.json)

```json
{
  "id": "openviking-context",
  "kind": "context-engine",
  "name": "OpenViking Context Engine",
  "description": "Three-tier context assembly with OpenViking backend",
  "configSchema": {
    "type": "object",
    "additionalProperties": false,
    "properties": {
      "mode": {
        "type": "string",
        "enum": ["local", "remote"],
        "default": "remote"
      },
      "baseUrl": {
        "type": "string",
        "default": "http://localhost:1933"
      },
      "apiKey": {
        "type": "string"
      },
      "l1TokenBudget": {
        "type": "number",
        "default": 2000
      },
      "autoCompact": {
        "type": "boolean",
        "default": true
      }
    }
  }
}
```

---

## 3. OpenViking 架构深度分析

### 3.1 系统架构

```
┌────────────────────────────────────────────────────────┐
│                   OpenViking Server (:1933)              │
│                                                          │
│  ┌────────────┐  ┌──────────────┐  ┌────────────────┐  │
│  │  Retrieve   │  │   Session    │  │     Parse      │  │
│  │  Module     │  │   Module     │  │     Module     │  │
│  │            │  │              │  │                │  │
│  │ • Intent   │  │ • Add msg    │  │ • Doc parsing  │  │
│  │   Analysis │  │ • Commit     │  │ • L0/L1/L2     │  │
│  │ • Hierarch.│  │ • Extract    │  │ • Tree build   │  │
│  │   Retrieval│  │   memories   │  │                │  │
│  │ • Rerank   │  │ • Compress   │  │                │  │
│  └─────┬──────┘  └──────┬───────┘  └───────┬────────┘  │
│        │                │                   │            │
│  ┌─────▼─────────────────▼───────────────────▼────────┐  │
│  │                  Storage Layer                      │  │
│  │  ┌──────────────────┐  ┌─────────────────────────┐ │  │
│  │  │      AGFS        │  │     Vector Index         │ │  │
│  │  │  (File Content)  │  │  (URI + Vector + Meta)   │ │  │
│  │  │                  │  │                           │ │  │
│  │  │ Backends:        │  │ Backends:                 │ │  │
│  │  │  • localfs       │  │  • local                  │ │  │
│  │  │  • s3fs          │  │  • http                   │ │  │
│  │  │  • memory        │  │  • volcengine VikingDB    │ │  │
│  │  └──────────────────┘  └─────────────────────────┘ │  │
│  └─────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

### 3.2 L0/L1/L2 三级上下文加载机制

这是 OpenViking 的核心创新，对比传统 RAG 的扁平存储有显著优势：

| 层级 | 名称 | 文件 | Token 限制 | 用途 |
|------|------|------|-----------|------|
| **L0** | Abstract | `.abstract.md` | ~100 tokens | 向量检索 + 快速过滤 |
| **L1** | Overview | `.overview.md` | ~2k tokens | 重排序 + 内容导航 |
| **L2** | Detail | 原始文件 | 无限制 | 完整内容，按需加载 |

**加载策略**：
```
Query → L0 向量匹配 → L1 语义重排 → L2 按需读取
                  ↓              ↓            ↓
             ~100 tok       ~2k tok      完整内容
```

**目录结构示例**：
```
viking://user/memories/
├── .abstract.md          # L0: "用户偏好：中文沟通，TypeScript 开发"
├── .overview.md          # L1: 详细偏好列表 + 子目录导航
├── preferences/
│   ├── .abstract.md
│   ├── .overview.md
│   └── coding-style.md   # L2: 完整编码风格文档
└── decisions/
    ├── .abstract.md
    ├── .overview.md
    └── arch-2026-01.md    # L2: 2026年1月架构决策
```

### 3.3 文件系统范式

OpenViking 用 `viking://` URI 统一管理三种上下文类型：

| URI Scheme | 上下文类型 | 说明 |
|------------|-----------|------|
| `viking://user/` | 用户记忆 | 偏好、历史、决策 |
| `viking://agent/` | Agent 记忆 | 技能、工作区、指令 |
| `viking://resources/` | 资源 | 文档、代码、知识库 |

### 3.4 HTTP API 接口 (端口 1933)

**核心 API 端点**：

| 类别 | Method | Path | 说明 |
|------|--------|------|------|
| **系统** | GET | `/health` | 健康检查（无需认证） |
| **系统** | GET | `/api/v1/system/status` | 系统状态 |
| **文件系统** | GET | `/api/v1/fs/ls` | 目录列表 |
| **文件系统** | GET | `/api/v1/fs/tree` | 目录树 |
| **文件系统** | DELETE | `/api/v1/fs` | 删除资源 |
| **内容** | GET | `/api/v1/content/read` | 读取完整内容 (L2) |
| **内容** | GET | `/api/v1/content/abstract` | 读取摘要 (L0) |
| **内容** | GET | `/api/v1/content/overview` | 读取概览 (L1) |
| **检索** | POST | `/api/v1/search/find` | 语义搜索 |
| **会话** | POST | `/api/v1/sessions` | 创建会话 |
| **会话** | POST | `/api/v1/sessions/:id/messages` | 添加消息 |
| **会话** | POST | `/api/v1/sessions/:id/extract` | 提取记忆 |
| **资源** | POST | `/api/v1/resources` | 导入资源 |
| **导出** | POST | `/api/v1/pack/export` | 导出 .ovpack |
| **导入** | POST | `/api/v1/pack/import` | 导入 .ovpack |

**认证**：
- Header: `X-API-Key: your-key` 或 `Authorization: Bearer your-key`
- `/health` 端点不需要认证

**响应格式**：
```json
{
  "status": "ok",
  "result": { ... },
  "time": 0.123
}
```

### 3.5 现有 Memory 插件分析

现有 `memory-openviking` 插件实现了 **Memory Slot**（`kind: "memory"`），注册了三个工具：

| 工具 | 功能 |
|------|------|
| `memory_recall` | 语义搜索记忆，同时检索 user/agent 两个 scope |
| `memory_store` | 创建临时 session → 添加消息 → 提取记忆 → 清理 |
| `memory_forget` | 按 URI 或搜索匹配删除记忆 |

**关键特性**：
- 支持 `local` 和 `remote` 两种模式
- Local 模式自动启动 OpenViking Python 进程
- Auto-recall：在 `before_prompt_build` hook 中自动检索相关记忆
- Auto-capture：在 `after_compaction` hook 中自动提取新记忆

---

## 4. 高可用架构设计

### 4.1 HA 架构总览

```
                    ┌─────────────────────┐
                    │   OpenClaw Gateway   │
                    │ (Context Engine +    │
                    │  Memory Plugin)      │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │  HAProxy / Nginx LB   │
                    │  (Health Check :1933)  │
                    │  ┌────────────────┐   │
                    │  │ Active Probing │   │
                    │  │ GET /health    │   │
                    │  │ interval: 5s   │   │
                    │  └────────────────┘   │
                    └──────┬──────────┬─────┘
                           │          │
              ┌────────────▼──┐  ┌────▼───────────┐
              │  OpenViking   │  │   OpenViking    │
              │  Instance A   │  │   Instance B    │
              │  (Primary)    │  │   (Standby)     │
              │  :1933        │  │   :1933         │
              └───────┬───────┘  └────────┬────────┘
                      │                   │
              ┌───────▼───────────────────▼────────┐
              │         Shared Storage Layer         │
              │                                      │
              │  Option A: S3-Compatible Storage     │
              │  ┌─────────┐    ┌────────────────┐  │
              │  │  MinIO   │    │ AWS S3 / R2 /  │  │
              │  │ (on-prem)│    │ Volcengine TOS │  │
              │  └─────────┘    └────────────────┘  │
              │                                      │
              │  Option B: NFS Shared Mount          │
              │  ┌─────────────────────────────┐    │
              │  │  NFS Server (RAID + Backup)  │    │
              │  └─────────────────────────────┘    │
              │                                      │
              │  Vector Index: Volcengine VikingDB   │
              │  (Managed service, built-in HA)      │
              └──────────────────────────────────────┘
```

### 4.2 存储层 HA 方案

#### 方案 A：S3 后端（推荐生产环境）

OpenViking 的 AGFS 原生支持 `s3fs` 后端：

```json
{
  "storage": {
    "workspace": "s3://openviking-context/workspace",
    "backend": "s3fs",
    "s3": {
      "bucket": "openviking-context",
      "endpoint": "https://tos-s-sgp.volces.com",
      "access_key": "...",
      "secret_key": "...",
      "region": "ap-southeast-1"
    }
  }
}
```

**优势**：
- 99.999999999% (11个9) 持久性
- 多实例可同时读写（通过对象锁定保证一致性）
- 无需自建存储基础设施
- 跨区域复制能力

**注意事项**：
- S3 延迟高于本地文件系统（~50-200ms vs ~1ms）
- 需要考虑 list 操作的最终一致性
- 建议搭配本地缓存层

#### 方案 B：NFS 共享挂载

```json
{
  "storage": {
    "workspace": "/mnt/nfs/openviking_workspace",
    "backend": "localfs"
  }
}
```

**优势**：
- 延迟低（~2-5ms）
- POSIX 兼容，与 localfs 后端无缝对接
- 运维熟悉度高

**注意事项**：
- NFS 本身是单点（需要额外 HA 方案如 DRBD + Pacemaker）
- 文件锁性能问题
- 大规模并发写入需要调优

#### 方案 C：混合方案（推荐）

```
AGFS Content → S3 (持久化、跨实例共享)
Vector Index → Volcengine VikingDB (托管服务、内建 HA)
Hot Cache    → Local SSD (减少 S3 延迟)
```

### 4.3 多实例部署方案

```
┌─────────────────────────────────────────────────────┐
│                 Deployment Topology                   │
│                                                       │
│  ┌──────────────────┐    ┌──────────────────┐        │
│  │   Node 1 (SGP)   │    │   Node 2 (SGP)   │        │
│  │                   │    │                   │        │
│  │  OpenClaw GW      │    │  OpenViking       │        │
│  │  OpenViking (A)   │    │  Instance (B)     │        │
│  │  [Primary]        │    │  [Standby]        │        │
│  │                   │    │                   │        │
│  │  Local Cache:     │    │  Local Cache:     │        │
│  │  /tmp/ov-cache    │    │  /tmp/ov-cache    │        │
│  └────────┬──────────┘    └────────┬──────────┘        │
│           │                        │                    │
│           └────────┬───────────────┘                    │
│                    │                                    │
│           ┌────────▼────────┐                           │
│           │   S3 Storage    │                           │
│           │ (VolcEngine TOS)│                           │
│           └─────────────────┘                           │
└─────────────────────────────────────────────────────────┘
```

### 4.4 故障转移策略

#### 健康检查

```nginx
# HAProxy 配置示例
backend openviking_backend
    option httpchk GET /health
    http-check expect status 200

    server ov-primary 10.0.1.10:1933 check inter 5s fall 3 rise 2
    server ov-standby 10.0.1.11:1933 check inter 5s fall 3 rise 2 backup
```

#### 故障转移流程

```
                    Primary 健康检查失败
                           │
                    ┌──────▼──────┐
                    │ 连续 3 次失败  │
                    │ (15 秒窗口)   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │ LB 自动切换   │
                    │ 到 Standby   │
                    └──────┬──────┘
                           │
              ┌────────────▼────────────┐
              │ Standby 变为 Active      │
              │ • 连接共享存储 (已就绪)   │
              │ • 加载向量索引 (已同步)   │
              │ • 服务恢复时间 < 5s       │
              └──────────────────────────┘
```

### 4.5 增量备份与全量重建

#### 增量备份策略

```bash
#!/bin/bash
# cron: 每小时执行增量备份
# S3 后端自带版本控制，额外备份到冷存储

BACKUP_BUCKET="s3://openviking-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 1. 导出 ovpack（OpenViking 原生导出格式）
curl -X POST http://localhost:1933/api/v1/pack/export \
  -H "X-API-Key: ${OV_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"scope": "all"}' \
  -o "/tmp/backup_${TIMESTAMP}.ovpack"

# 2. 上传到备份存储
aws s3 cp "/tmp/backup_${TIMESTAMP}.ovpack" \
  "${BACKUP_BUCKET}/incremental/${TIMESTAMP}.ovpack"

# 3. 保留最近 72 小时的增量备份
aws s3 ls "${BACKUP_BUCKET}/incremental/" | \
  awk '{print $4}' | head -n -72 | \
  xargs -I {} aws s3 rm "${BACKUP_BUCKET}/incremental/{}"
```

#### 全量重建流程

```bash
#!/bin/bash
# 从备份恢复 OpenViking 实例

# 1. 启动空 OpenViking 实例
openviking-server &
sleep 5

# 2. 导入最新备份
LATEST_BACKUP=$(aws s3 ls s3://openviking-backup/incremental/ | tail -1 | awk '{print $4}')
aws s3 cp "s3://openviking-backup/incremental/${LATEST_BACKUP}" /tmp/restore.ovpack

curl -X POST http://localhost:1933/api/v1/pack/import \
  -H "X-API-Key: ${OV_API_KEY}" \
  -F "file=@/tmp/restore.ovpack"

# 3. 等待语义处理完成
curl -X POST http://localhost:1933/api/v1/system/wait \
  -H "X-API-Key: ${OV_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"timeout": 300}'

echo "Restore complete"
```

---

## 5. 集成方案设计

### 5.1 双层集成架构

我们采用 **Context Engine + Memory Slot** 双层集成：

```
┌─────────────────────────────────────────────────┐
│                OpenClaw Agent Runtime              │
│                                                    │
│  每次 Agent Run:                                   │
│  1. assemble() ← Context Engine 组装上下文         │
│     ├─ 注入 L1 概览作为 systemPromptAddition       │
│     ├─ 基于 token budget 智能裁剪历史消息          │
│     └─ 附加相关记忆摘要                            │
│                                                    │
│  2. ingest() ← 每条消息写入 OpenViking Session     │
│                                                    │
│  3. afterTurn() ← Turn 完成后触发                   │
│     ├─ 持久化 canonical context                    │
│     └─ 触发后台压缩决策                            │
│                                                    │
│  4. compact() ← Token 超预算或 /compact 触发       │
│     ├─ 委托 OpenViking Session Compressor          │
│     ├─ 压缩历史 → 生成 L0/L1 归档                 │
│     └─ 提取长期记忆写入 memory store               │
│                                                    │
│  独立工具调用:                                      │
│  • memory_recall → 显式语义搜索                     │
│  • memory_store → 显式存储记忆                      │
│  • memory_forget → 删除记忆                         │
└─────────────────────────────────────────────────────┘
```

### 5.2 Context Engine 插件实现

```typescript
// openviking-context-engine/index.ts
import type {
  OpenClawPluginApi,
  OpenClawPluginDefinition,
} from "openclaw/plugin-sdk";
import type {
  ContextEngine,
  ContextEngineInfo,
  AssembleResult,
  CompactResult,
  IngestResult,
  IngestBatchResult,
  BootstrapResult,
} from "openclaw/plugin-sdk/context-engine";
import type { AgentMessage } from "@mariozechner/pi-agent-core";

// ─── Configuration ─────────────────────────────────────
interface OpenVikingContextConfig {
  mode: "local" | "remote";
  baseUrl: string;
  apiKey?: string;
  agentId?: string;
  /** L1 token budget for assemble() systemPromptAddition */
  l1TokenBudget: number;
  /** Whether to auto-compact via OpenViking */
  autoCompact: boolean;
  /** Threshold ratio to trigger compaction (e.g., 0.85 = 85% of budget) */
  compactThreshold: number;
  /** Max memories to inject per assemble */
  maxMemoryInjection: number;
}

// ─── HTTP Client (simplified) ─────────────────────────
class OVClient {
  constructor(
    private baseUrl: string,
    private apiKey?: string,
    private agentId?: string,
  ) {}

  private async request<T>(path: string, init?: RequestInit): Promise<T> {
    const headers = new Headers(init?.headers ?? {});
    if (this.apiKey) headers.set("X-API-Key", this.apiKey);
    if (this.agentId) headers.set("X-OpenViking-Agent", this.agentId);
    if (init?.body) headers.set("Content-Type", "application/json");

    const res = await fetch(`${this.baseUrl}${path}`, { ...init, headers });
    const payload = await res.json() as { status?: string; result?: T };
    if (!res.ok || payload.status === "error") {
      throw new Error(`OpenViking error: HTTP ${res.status}`);
    }
    return (payload.result ?? payload) as T;
  }

  async health(): Promise<void> {
    await this.request("/health");
  }

  async createSession(): Promise<string> {
    const r = await this.request<{ session_id: string }>("/api/v1/sessions", {
      method: "POST", body: JSON.stringify({}),
    });
    return r.session_id;
  }

  async addMessage(sessionId: string, role: string, content: string): Promise<void> {
    await this.request(`/api/v1/sessions/${sessionId}/messages`, {
      method: "POST", body: JSON.stringify({ role, content }),
    });
  }

  async extractMemories(sessionId: string): Promise<unknown[]> {
    return this.request(`/api/v1/sessions/${sessionId}/extract`, {
      method: "POST", body: JSON.stringify({}),
    });
  }

  async find(query: string, targetUri: string, limit: number): Promise<{
    memories?: Array<{ uri: string; abstract?: string; score?: number; level?: number }>;
  }> {
    return this.request("/api/v1/search/find", {
      method: "POST",
      body: JSON.stringify({ query, target_uri: targetUri, limit }),
    });
  }

  async overview(uri: string): Promise<string> {
    return this.request(`/api/v1/content/overview?uri=${encodeURIComponent(uri)}`);
  }

  async abstract(uri: string): Promise<string> {
    return this.request(`/api/v1/content/abstract?uri=${encodeURIComponent(uri)}`);
  }

  async deleteSession(sessionId: string): Promise<void> {
    await this.request(`/api/v1/sessions/${sessionId}`, { method: "DELETE" });
  }
}

// ─── Context Engine Implementation ────────────────────
class OpenVikingContextEngine implements ContextEngine {
  readonly info: ContextEngineInfo = {
    id: "openviking-context",
    name: "OpenViking Context Engine",
    version: "1.0.0",
    ownsCompaction: true, // 引擎接管压缩生命周期
  };

  private client: OVClient;
  private sessionMap = new Map<string, string>(); // openclawSessionId → ovSessionId
  private cfg: OpenVikingContextConfig;

  constructor(config: OpenVikingContextConfig) {
    this.cfg = config;
    this.client = new OVClient(config.baseUrl, config.apiKey, config.agentId);
  }

  // ── bootstrap: 初始化 OpenViking session ──
  async bootstrap(params: {
    sessionId: string;
    sessionFile: string;
  }): Promise<BootstrapResult> {
    try {
      const ovSessionId = await this.client.createSession();
      this.sessionMap.set(params.sessionId, ovSessionId);
      return { bootstrapped: true, importedMessages: 0 };
    } catch (err) {
      return { bootstrapped: false, reason: String(err) };
    }
  }

  // ── ingest: 写入消息到 OpenViking session ──
  async ingest(params: {
    sessionId: string;
    message: AgentMessage;
    isHeartbeat?: boolean;
  }): Promise<IngestResult> {
    if (params.isHeartbeat) return { ingested: false };

    const ovSessionId = await this.ensureOVSession(params.sessionId);
    const role = this.mapRole(params.message);
    const content = this.extractContent(params.message);

    if (!content) return { ingested: false };

    await this.client.addMessage(ovSessionId, role, content);
    return { ingested: true };
  }

  // ── ingestBatch: 批量写入 ──
  async ingestBatch(params: {
    sessionId: string;
    messages: AgentMessage[];
    isHeartbeat?: boolean;
  }): Promise<IngestBatchResult> {
    if (params.isHeartbeat) return { ingestedCount: 0 };

    let count = 0;
    for (const msg of params.messages) {
      const result = await this.ingest({
        sessionId: params.sessionId,
        message: msg,
        isHeartbeat: false,
      });
      if (result.ingested) count++;
    }
    return { ingestedCount: count };
  }

  // ── assemble: 核心 — 三级加载组装上下文 ──
  async assemble(params: {
    sessionId: string;
    messages: AgentMessage[];
    tokenBudget?: number;
  }): Promise<AssembleResult> {
    const budget = params.tokenBudget ?? 128000;
    const reservedForMemory = Math.min(this.cfg.l1TokenBudget, budget * 0.15);

    // 1. 提取最新用户消息作为检索 query
    const query = this.extractLatestUserQuery(params.messages);
    let memoryAddition = "";

    if (query) {
      // 2. L0 级检索：快速语义匹配
      const results = await this.client.find(
        query,
        "viking://user/memories",
        this.cfg.maxMemoryInjection * 3,
      );

      if (results.memories && results.memories.length > 0) {
        // 3. 取 top-N，用 L1 概览丰富上下文
        const topMemories = results.memories
          .filter(m => m.level === 2)
          .slice(0, this.cfg.maxMemoryInjection);

        const memoryTexts: string[] = [];
        let tokenUsed = 0;

        for (const mem of topMemories) {
          const text = mem.abstract ?? "";
          const estimatedTokens = text.length / 4;
          if (tokenUsed + estimatedTokens > reservedForMemory) break;
          memoryTexts.push(`- ${text}`);
          tokenUsed += estimatedTokens;
        }

        if (memoryTexts.length > 0) {
          memoryAddition = [
            "\n## Recalled Memories (OpenViking)",
            ...memoryTexts,
          ].join("\n");
        }
      }
    }

    // 4. 裁剪消息列表到 token budget
    const messagesForContext = this.trimMessages(
      params.messages,
      budget - reservedForMemory,
    );

    return {
      messages: messagesForContext,
      estimatedTokens: this.estimateTokens(messagesForContext) +
        (memoryAddition.length / 4),
      systemPromptAddition: memoryAddition || undefined,
    };
  }

  // ── afterTurn: Turn 完成后的后台处理 ──
  async afterTurn(params: {
    sessionId: string;
    sessionFile: string;
    messages: AgentMessage[];
    prePromptMessageCount: number;
    tokenBudget?: number;
  }): Promise<void> {
    // 评估是否需要后台压缩
    if (!this.cfg.autoCompact) return;

    const budget = params.tokenBudget ?? 128000;
    const currentTokens = this.estimateTokens(params.messages);
    const threshold = budget * this.cfg.compactThreshold;

    if (currentTokens > threshold) {
      // 异步触发压缩，不阻塞当前 turn
      this.compact({
        sessionId: params.sessionId,
        sessionFile: params.sessionFile,
        tokenBudget: budget,
      }).catch(() => { /* logged internally */ });
    }
  }

  // ── compact: 委托 OpenViking 压缩 + 提取记忆 ──
  async compact(params: {
    sessionId: string;
    sessionFile: string;
    tokenBudget?: number;
    force?: boolean;
  }): Promise<CompactResult> {
    const ovSessionId = this.sessionMap.get(params.sessionId);
    if (!ovSessionId) {
      return { ok: false, compacted: false, reason: "No OpenViking session" };
    }

    try {
      // 1. 触发记忆提取
      const extracted = await this.client.extractMemories(ovSessionId);

      // 2. 创建新 session（压缩后的干净 session）
      const newOvSession = await this.client.createSession();

      // 3. 迁移 session 映射
      const oldSession = ovSessionId;
      this.sessionMap.set(params.sessionId, newOvSession);

      // 4. 清理旧 session
      await this.client.deleteSession(oldSession).catch(() => {});

      return {
        ok: true,
        compacted: true,
        result: {
          summary: `Extracted ${extracted.length} memories, session rotated`,
          tokensBefore: params.tokenBudget ?? 0,
          tokensAfter: 0,
          details: { extractedCount: extracted.length },
        },
      };
    } catch (err) {
      return {
        ok: false,
        compacted: false,
        reason: String(err),
      };
    }
  }

  // ── prepareSubagentSpawn: 子代理上下文准备 ──
  async prepareSubagentSpawn(params: {
    parentSessionKey: string;
    childSessionKey: string;
    ttlMs?: number;
  }) {
    // 为子代理创建独立 OpenViking session
    // 但共享同一个 user/agent memory space
    const childOvSession = await this.client.createSession();
    this.sessionMap.set(params.childSessionKey, childOvSession);

    return {
      rollback: async () => {
        this.sessionMap.delete(params.childSessionKey);
        await this.client.deleteSession(childOvSession).catch(() => {});
      },
    };
  }

  // ── onSubagentEnded: 子代理结束 ──
  async onSubagentEnded(params: { childSessionKey: string }) {
    const ovSession = this.sessionMap.get(params.childSessionKey);
    if (ovSession) {
      // 提取子代理产生的记忆到共享空间
      await this.client.extractMemories(ovSession).catch(() => {});
      await this.client.deleteSession(ovSession).catch(() => {});
      this.sessionMap.delete(params.childSessionKey);
    }
  }

  // ── dispose ──
  async dispose(): Promise<void> {
    for (const [key, ovSession] of this.sessionMap) {
      await this.client.deleteSession(ovSession).catch(() => {});
    }
    this.sessionMap.clear();
  }

  // ── Private helpers ──

  private async ensureOVSession(sessionId: string): Promise<string> {
    let ovSession = this.sessionMap.get(sessionId);
    if (!ovSession) {
      ovSession = await this.client.createSession();
      this.sessionMap.set(sessionId, ovSession);
    }
    return ovSession;
  }

  private mapRole(msg: AgentMessage): string {
    const role = (msg as { role?: string }).role;
    if (role === "assistant") return "assistant";
    if (role === "tool") return "tool";
    return "user";
  }

  private extractContent(msg: AgentMessage): string {
    const content = (msg as { content?: unknown }).content;
    if (typeof content === "string") return content;
    if (Array.isArray(content)) {
      return content
        .map((c: { text?: string; type?: string }) =>
          c.type === "text" ? c.text ?? "" : "")
        .join("\n");
    }
    return "";
  }

  private extractLatestUserQuery(messages: AgentMessage[]): string | null {
    for (let i = messages.length - 1; i >= 0; i--) {
      const msg = messages[i] as { role?: string };
      if (msg.role === "user") {
        return this.extractContent(messages[i] as AgentMessage);
      }
    }
    return null;
  }

  private trimMessages(
    messages: AgentMessage[],
    tokenBudget: number,
  ): AgentMessage[] {
    // 简单策略：保留最新消息直到 budget 用完
    const result: AgentMessage[] = [];
    let tokens = 0;

    for (let i = messages.length - 1; i >= 0; i--) {
      const content = this.extractContent(messages[i] as AgentMessage);
      const msgTokens = content.length / 4;
      if (tokens + msgTokens > tokenBudget && result.length > 0) break;
      result.unshift(messages[i]!);
      tokens += msgTokens;
    }
    return result;
  }

  private estimateTokens(messages: AgentMessage[]): number {
    return messages.reduce((sum, msg) => {
      return sum + this.extractContent(msg).length / 4;
    }, 0);
  }
}

// ─── Plugin Definition ─────────────────────────────────
const plugin: OpenClawPluginDefinition = {
  id: "openviking-context",
  name: "OpenViking Context Engine",
  description: "Three-tier context assembly powered by OpenViking",
  kind: "context-engine",

  register(api: OpenClawPluginApi) {
    const config = api.pluginConfig as OpenVikingContextConfig;

    const defaults: OpenVikingContextConfig = {
      mode: "remote",
      baseUrl: "http://localhost:1933",
      l1TokenBudget: 2000,
      autoCompact: true,
      compactThreshold: 0.85,
      maxMemoryInjection: 10,
      ...config,
    };

    api.registerContextEngine(
      "openviking-context",
      () => new OpenVikingContextEngine(defaults),
    );

    api.logger.info(
      `openviking-context: registered (mode=${defaults.mode}, baseUrl=${defaults.baseUrl})`,
    );
  },
};

export default plugin;
```

### 5.3 多 Agent 共享上下文方案

```
┌──────────────────────────────────────────────────────────────────┐
│                     OpenViking URI Namespace                       │
│                                                                    │
│  viking://user/{userId}/                                          │
│  ├── memories/           ← 所有 Agent 共享的用户记忆              │
│  │   ├── preferences/    ← 用户偏好                               │
│  │   ├── decisions/      ← 架构/产品决策                           │
│  │   └── context/        ← 项目上下文                              │
│  │                                                                 │
│  viking://agent/{agentHash}/                                      │
│  ├── memories/           ← Agent 专属记忆                          │
│  │   ├── main/           ← Coordinator 的任务协调记忆              │
│  │   ├── waicode/        ← 编码经验、bug 模式                     │
│  │   ├── waidesign/      ← 设计规范、UI 模式                      │
│  │   ├── wairesearch/    ← 研究结论、技术选型                     │
│  │   └── waiqa/          ← 测试策略、质量标准                     │
│  ├── skills/             ← Agent 技能定义                          │
│  ├── instructions/       ← Agent 工作指令                          │
│  └── workspaces/         ← 工作区上下文                            │
│                                                                    │
│  viking://resources/                                              │
│  ├── codebase/           ← 代码库知识                              │
│  ├── docs/               ← 技术文档                                │
│  └── designs/            ← 设计文档                                │
└──────────────────────────────────────────────────────────────────┘
```

**Agent ID 隔离方案**：

每个 Agent 连接 OpenViking 时使用不同的 `X-OpenViking-Agent` header：

```typescript
// OpenClaw 配置 - 每个 agent 独立的 pluginConfig 覆盖
// ~/.openclaw/openclaw.json
{
  "agents": {
    "main": {
      "plugins": {
        "entries": {
          "openviking-context": {
            "config": { "agentId": "main" }
          }
        }
      }
    },
    "waicode": {
      "plugins": {
        "entries": {
          "openviking-context": {
            "config": { "agentId": "waicode" }
          }
        }
      }
    }
    // ... 其他 agent 类似
  }
}
```

**跨 Agent 记忆共享机制**：

```
Agent 写入流程:
  waicode ingest("found a bug pattern in auth module")
    → OpenViking Session → Extract → viking://agent/{hash}/memories/waicode/

Agent 读取流程 (assemble):
  main assemble() 
    → find("auth module") 
    → 搜索 viking://user/memories + viking://agent/memories
    → 返回所有 Agent 的相关记忆（包括 waicode 发现的 bug 模式）
```

### 5.4 配置示例

#### 完整 OpenClaw 配置

```json5
// ~/.openclaw/openclaw.json
{
  "plugins": {
    "enabled": true,
    "slots": {
      "memory": "memory-openviking",        // Memory 工具层
      "contextEngine": "openviking-context"  // Context Engine 层
    },
    "entries": {
      // Layer 1: Memory Plugin (工具 + auto-recall/capture)
      "memory-openviking": {
        "config": {
          "mode": "remote",
          "baseUrl": "http://openviking-lb:1933",
          "apiKey": "${OPENVIKING_API_KEY}",
          "autoRecall": true,
          "autoCapture": true,
          "recallLimit": 15,
          "recallScoreThreshold": 0.3,
          "targetUri": "viking://user/memories"
        }
      },
      // Layer 2: Context Engine (assemble/compact 生命周期)
      "openviking-context": {
        "config": {
          "mode": "remote",
          "baseUrl": "http://openviking-lb:1933",
          "apiKey": "${OPENVIKING_API_KEY}",
          "l1TokenBudget": 2000,
          "autoCompact": true,
          "compactThreshold": 0.85,
          "maxMemoryInjection": 10
        }
      }
    }
  }
}
```

#### OpenViking Server 配置（HA 模式）

```json5
// ~/.openviking/ov.conf
{
  "storage": {
    // 使用 S3 后端实现共享存储
    "workspace": "s3://openviking-prod/workspace",
    "backend": "s3fs",
    "s3": {
      "bucket": "openviking-prod",
      "endpoint": "https://tos-s-sgp.volces.com",
      "access_key": "${S3_ACCESS_KEY}",
      "secret_key": "${S3_SECRET_KEY}",
      "region": "ap-southeast-1"
    }
  },
  "log": {
    "level": "INFO",
    "output": "file"
  },
  "embedding": {
    "dense": {
      "api_base": "https://ark.cn-beijing.volces.com/api/v3",
      "api_key": "${VLM_API_KEY}",
      "provider": "volcengine",
      "dimension": 1024,
      "model": "doubao-embedding-vision-250615"
    },
    "max_concurrent": 10
  },
  "vlm": {
    "api_base": "https://ark.cn-beijing.volces.com/api/v3",
    "api_key": "${VLM_API_KEY}",
    "provider": "volcengine",
    "model": "doubao-seed-2-0-pro-260215",
    "max_concurrent": 100
  },
  // 向量索引使用托管服务
  "vector": {
    "backend": "volcengine",
    "config": {
      "endpoint": "https://vikingdb.volces.com",
      "api_key": "${VIKINGDB_API_KEY}"
    }
  },
  // 认证
  "auth": {
    "api_key": "${OPENVIKING_API_KEY}"
  },
  // 服务器配置
  "server": {
    "host": "0.0.0.0",
    "port": 1933,
    "workers": 4
  }
}
```

#### HAProxy 负载均衡配置

```haproxy
# /etc/haproxy/haproxy.cfg
global
    log stdout format raw local0
    maxconn 4096

defaults
    log     global
    mode    http
    option  httplog
    timeout connect 5s
    timeout client  120s
    timeout server  120s

frontend openviking_front
    bind *:1933
    default_backend openviking_back

backend openviking_back
    option httpchk GET /health
    http-check expect status 200

    # 主实例（优先路由）
    server ov-primary 10.0.1.10:1933 check inter 5s fall 3 rise 2
    # 备用实例
    server ov-standby 10.0.1.11:1933 check inter 5s fall 3 rise 2 backup

    # 可选：多活模式（需要共享存储 + 写锁）
    # server ov-node1 10.0.1.10:1933 check inter 5s
    # server ov-node2 10.0.1.11:1933 check inter 5s
```

---

## 6. 实施路线图

### Phase 1: 基础集成（2-3 周）

**目标**：部署 OpenViking + 接入现有 Memory 插件

| 任务 | 工作量 | 说明 |
|------|--------|------|
| 部署 OpenViking Server | 2d | 单实例 + localfs 后端 |
| 配置 VLM + Embedding | 1d | Volcengine Doubao 模型接入 |
| 安装 memory-openviking 插件 | 1d | 使用 setup-helper 自动化安装 |
| 配置 5 个 Agent 的 memory 插件 | 1d | remote 模式统一指向服务器 |
| 导入现有知识库 | 2d | 文档、代码库导入到 resources |
| 验证 + 调优 | 3d | 测试 recall/capture 效果 |

**前置依赖**：
- Volcengine API Key（VLM + Embedding）
- 服务器资源（4 vCPU, 8GB RAM 起步）

**风险**：
- VLM API 延迟影响 auto-recall 体验 → 缓解：设置 5s 超时
- Embedding 维度与模型不匹配 → 缓解：测试环境先验证

**交付物**：
- 运行中的 OpenViking 单实例
- 5 个 Agent 均可 recall/store 记忆

### Phase 2: 自定义 Context Engine 开发（3-4 周）

**目标**：实现 OpenViking Context Engine 插件

| 任务 | 工作量 | 说明 |
|------|--------|------|
| 插件骨架搭建 | 2d | openclaw.plugin.json + TypeScript 结构 |
| ingest() 实现 | 2d | 消息转发到 OpenViking Session |
| assemble() 实现 | 5d | L0/L1 三级加载 + token budget 管理 |
| compact() 实现 | 3d | 委托 OpenViking Session Compressor |
| afterTurn() 实现 | 2d | 后台压缩决策逻辑 |
| prepareSubagentSpawn() | 2d | 子代理 session 管理 |
| 单元测试 + 集成测试 | 3d | Mock + 真实环境测试 |
| 与 Memory 插件协调测试 | 2d | 双层集成验证 |

**前置依赖**：
- Phase 1 完成
- 对 OpenClaw 插件 SDK 的熟悉

**风险**：
- assemble() 中 OpenViking find 延迟加到每次 run → 缓解：本地缓存 + 预取
- Context Engine 与 Memory Plugin 竞争写入 → 缓解：明确分工，CE 管 session 生命周期，Memory 管显式工具

**交付物**：
- `openviking-context` 插件可用
- 通过 `plugins.slots.contextEngine` 激活
- assemble 自动注入相关记忆

### Phase 3: HA 存储层改造（2-3 周）

**目标**：将单实例本地存储迁移到共享 HA 存储

| 任务 | 工作量 | 说明 |
|------|--------|------|
| S3 存储后端配置 | 2d | MinIO 或 TOS 配置 + 测试 |
| 数据迁移 | 2d | localfs → S3 迁移脚本 |
| Vector Index 迁移 | 2d | local → VikingDB 托管服务 |
| 性能基准测试 | 2d | S3 延迟 vs localfs 对比 |
| 本地缓存层实现 | 3d | 热数据 SSD 缓存 |
| 备份策略实施 | 2d | ovpack 定时导出 + S3 版本控制 |

**前置依赖**：
- Phase 2 完成
- S3 兼容存储服务可用
- Volcengine VikingDB（可选）

**风险**：
- S3 延迟影响检索性能 → 缓解：L0/L1 本地缓存 + 预热
- 迁移过程数据一致性 → 缓解：维护窗口 + 双写验证

**交付物**：
- 存储层完全在 S3 上运行
- 向量索引使用托管服务
- 自动备份机制就绪

### Phase 4: 多实例 + 自动故障转移（2-3 周）

**目标**：部署双实例 + 负载均衡 + 自动故障转移

| 任务 | 工作量 | 说明 |
|------|--------|------|
| 第二实例部署 | 1d | 相同配置部署 Standby |
| HAProxy 配置 | 1d | 健康检查 + 故障转移规则 |
| Context Engine 客户端重试 | 2d | 连接池 + 自动重试 + 回退 |
| 故障模拟测试 | 3d | kill primary → 验证切换 |
| 监控告警 | 2d | Prometheus + Grafana Dashboard |
| 全流程灾难恢复演练 | 2d | 全量重建演练 |
| 文档编写 | 2d | 运维手册 + 故障处理流程 |

**前置依赖**：
- Phase 3 完成
- 第二台服务器资源
- 监控基础设施

**风险**：
- 双实例写冲突 → 缓解：写入仅路由到 Primary，Standby 只读
- 故障切换时 in-flight 请求丢失 → 缓解：客户端重试 + 幂等设计

**交付物**：
- 双实例 Active-Standby 部署
- < 15s 自动故障转移
- 监控大盘 + 告警
- 运维文档

### 时间线总览

```
Week 1-3    ▓▓▓░░░░░░░░░░░  Phase 1: 基础集成
Week 4-7    ░░░▓▓▓▓░░░░░░░  Phase 2: Context Engine 开发
Week 8-10   ░░░░░░░▓▓▓░░░░  Phase 3: HA 存储层改造
Week 11-13  ░░░░░░░░░░▓▓▓░  Phase 4: 多实例 + 故障转移
Week 14     ░░░░░░░░░░░░░▓  验收 + 优化

总工期估算: 12-14 周（约 3.5 个月）
```

---

## 7. 风险评估与缓解

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|----------|
| OpenViking API 延迟过高影响 assemble | 中 | 高 | 本地缓存 L0/L1 + 5s 超时 + 降级到 legacy |
| Context Engine 与 Memory Plugin 冲突 | 低 | 中 | 明确分工 + 集成测试覆盖 |
| S3 存储最终一致性导致读取脏数据 | 低 | 中 | 强一致性读取策略 + 缓存验证 |
| OpenViking 版本升级 breaking changes | 中 | 中 | 锁定版本 + 升级测试环境 |
| VLM/Embedding API 限流 | 中 | 低 | 令牌桶限流 + 队列化 |
| 多 Agent 并发写入冲突 | 低 | 低 | 写入是 append-only + 不同 scope 隔离 |
| 灾难恢复时 ovpack 恢复耗时过长 | 低 | 高 | 定期演练 + 增量备份缩小恢复时间窗口 |

### 降级策略

```typescript
// Context Engine 内建降级逻辑
class OpenVikingContextEngine implements ContextEngine {
  private fallbackToLegacy = false;

  async assemble(params: AssembleParams): Promise<AssembleResult> {
    if (this.fallbackToLegacy) {
      // 降级：直接返回消息，不做 OpenViking 检索
      return {
        messages: params.messages,
        estimatedTokens: this.estimateTokens(params.messages),
      };
    }

    try {
      return await this.assembleWithOpenViking(params);
    } catch (err) {
      this.logger.warn(`OpenViking assemble failed, falling back: ${err}`);
      this.fallbackToLegacy = true;

      // 60 秒后尝试恢复
      setTimeout(() => {
        this.fallbackToLegacy = false;
      }, 60_000);

      return {
        messages: params.messages,
        estimatedTokens: this.estimateTokens(params.messages),
      };
    }
  }
}
```

---

## 8. 附录

### A. OpenViking HTTP API 快速参考

```bash
# 健康检查
curl http://localhost:1933/health

# 系统状态
curl http://localhost:1933/api/v1/system/status -H "X-API-Key: xxx"

# 目录列表
curl "http://localhost:1933/api/v1/fs/ls?uri=viking://user/memories/"

# 语义搜索
curl -X POST http://localhost:1933/api/v1/search/find \
  -H "Content-Type: application/json" \
  -d '{"query": "TypeScript best practices", "target_uri": "viking://user/memories", "limit": 10}'

# 创建会话
curl -X POST http://localhost:1933/api/v1/sessions \
  -H "Content-Type: application/json" -d '{}'

# 添加消息
curl -X POST http://localhost:1933/api/v1/sessions/{id}/messages \
  -H "Content-Type: application/json" \
  -d '{"role": "user", "content": "Hello world"}'

# 提取记忆
curl -X POST http://localhost:1933/api/v1/sessions/{id}/extract \
  -H "Content-Type: application/json" -d '{}'

# 导出备份
curl -X POST http://localhost:1933/api/v1/pack/export \
  -H "Content-Type: application/json" -d '{"scope": "all"}' -o backup.ovpack

# 导入恢复
curl -X POST http://localhost:1933/api/v1/pack/import -F "file=@backup.ovpack"
```

### B. OpenClaw Plugin SDK 关键类型引用

```typescript
// Context Engine 注册
api.registerContextEngine(id: string, factory: ContextEngineFactory): void;

// 可用 Plugin Hooks
type PluginHookName =
  | "before_model_resolve"
  | "before_prompt_build"
  | "before_agent_start"
  | "llm_input" | "llm_output"
  | "agent_end"
  | "before_compaction" | "after_compaction"
  | "before_reset"
  | "message_received" | "message_sending" | "message_sent"
  | "before_tool_call" | "after_tool_call"
  | "session_start" | "session_end"
  | "subagent_spawning" | "subagent_spawned" | "subagent_ended"
  | "gateway_start" | "gateway_stop";

// Plugin Slots
"plugins.slots.memory"        // Memory 插件选择
"plugins.slots.contextEngine" // Context Engine 选择 (default: "legacy")
```

### C. 性能基准参考

基于 OpenViking 官方 LoCoMo10 评测（1,540 个案例）：

| 方案 | 任务完成率 | 输入 Token |
|------|-----------|-----------|
| OpenClaw (memory-core) | 35.65% | 24,611,530 |
| OpenClaw + LanceDB | 44.55% | 51,574,530 |
| **OpenClaw + OpenViking (-memory-core)** | **52.08%** | **4,264,396** |
| **OpenClaw + OpenViking (+memory-core)** | **51.23%** | **2,099,622** |

**结论**：OpenViking 集成后，任务完成率提升 43-49%，Token 消耗降低 83-96%。

---

*文档结束。如有疑问请联系 wairesearch。*
