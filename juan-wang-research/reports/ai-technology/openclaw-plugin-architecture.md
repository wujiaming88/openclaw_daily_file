# OpenClaw Plugin 架构与原理研究报告

> 研究员: 黄山 (wairesearch) | 日期: 2026-03-10

## 执行摘要

OpenClaw 的 Plugin 架构是一个**进程内（in-process）、TypeScript 原生**的扩展系统。插件通过 jiti（TypeScript 即时编译器）在 Gateway 运行时加载，可以注册 Agent 工具、消息渠道、CLI 命令、HTTP 路由、后台服务、生命周期钩子、上下文引擎和模型提供商认证。整个系统遵循**声明式 Manifest + 运行时注册**的双层设计，在安全性和灵活性之间取得平衡。

---

## 1. 架构全景

```
┌────────────────────────────────────────────────────────────┐
│                     Gateway Process                         │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Plugin Discovery Engine                 │   │
│  │                                                      │   │
│  │  1. plugins.load.paths (配置路径)                    │   │
│  │  2. <workspace>/.openclaw/extensions/               │   │
│  │  3. ~/.openclaw/extensions/                         │   │
│  │  4. <openclaw>/extensions/ (内置)                   │   │
│  │                                                      │   │
│  │  优先级: 先匹配的 ID 胜出                           │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                    │
│                         ▼                                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │            Plugin Registry & Loader (jiti)           │  │
│  │                                                      │  │
│  │  openclaw.plugin.json → 验证 configSchema            │  │
│  │  plugin.ts/js         → jiti 加载执行                │  │
│  └──────────────────────┬──────────────────────────────┘  │
│                         │                                    │
│               ┌─────────┼─────────┐                         │
│               ▼         ▼         ▼                         │
│  ┌──────────────┐ ┌──────────┐ ┌──────────────────┐       │
│  │ OpenClawPlugin│ │  Plugin  │ │   Plugin Hooks   │       │
│  │   Api        │ │  Config  │ │   (24 lifecycle)  │       │
│  │              │ │  Schema  │ │                    │       │
│  │ .registerTool│ │ (JSON)   │ │ before_model_resolve│      │
│  │ .registerChannel│         │ │ before_prompt_build │      │
│  │ .registerHook│ │          │ │ before/after_tool   │      │
│  │ .registerCli │ │          │ │ session_start/end   │      │
│  │ .registerProvider│        │ │ gateway_start/stop  │      │
│  │ .registerService│         │ │ subagent_*          │      │
│  │ .registerCommand│         │ │ message_*           │      │
│  │ .registerHttpRoute│       │ │ compaction_*        │      │
│  │ .registerContextEngine│   │ │ ...                 │      │
│  │ .on()        │ │          │ │                    │       │
│  └──────────────┘ └──────────┘ └──────────────────┘       │
└────────────────────────────────────────────────────────────┘
```

---

## 2. Plugin 的组成结构

### 2.1 文件结构

```
my-plugin/
├── openclaw.plugin.json    ← 必须！声明式 Manifest
├── package.json            ← npm 依赖（可选）
├── src/
│   └── plugin.ts           ← 主入口（导出注册函数）
├── skills/                 ← 插件附带的 Skills（可选）
│   └── my-skill/
│       └── SKILL.md
└── README.md
```

### 2.2 Manifest（`openclaw.plugin.json`）

这是 Plugin 的**声明式元数据**，OpenClaw 在不执行代码的情况下用它验证配置。

```json
{
  "id": "my-plugin",
  "name": "My Plugin",
  "description": "A demo plugin for OpenClaw",
  "version": "1.0.0",
  "kind": "memory",
  "channels": ["mychannel"],
  "providers": ["myprovider"],
  "skills": ["skills/my-skill"],
  "configSchema": {
    "type": "object",
    "additionalProperties": false,
    "properties": {
      "apiKey": { "type": "string" },
      "enabled": { "type": "boolean", "default": true }
    }
  },
  "uiHints": {
    "apiKey": { "label": "API Key", "sensitive": true },
    "enabled": { "label": "启用插件" }
  }
}
```

**必填字段**：`id`、`configSchema`（即使为空也必须有）

**可选字段**：

| 字段 | 作用 |
|------|------|
| `kind` | 插件类别（`memory`、`context-engine`），用于独占 slot 选择 |
| `channels` | 注册的消息渠道 ID |
| `providers` | 注册的模型提供商 ID |
| `skills` | 附带的 Skill 目录（相对路径） |
| `uiHints` | 配置字段的 UI 渲染提示（标签、占位符、是否敏感） |

### 2.3 Plugin 模块导出格式

支持两种导出方式：

**方式一：函数式（推荐）**
```ts
export default function (api: OpenClawPluginApi) {
  api.registerTool({ ... });
  api.registerHook("gateway_start", async () => { ... });
}
```

**方式二：对象式**
```ts
export default {
  id: "my-plugin",
  name: "My Plugin",
  configSchema: { ... },
  register(api: OpenClawPluginApi) {
    api.registerTool({ ... });
  }
};
```

---

## 3. OpenClawPluginApi 完整接口

这是插件与 OpenClaw 交互的唯一入口：

```typescript
type OpenClawPluginApi = {
  // ─── 元信息 ───
  id: string;
  name: string;
  version?: string;
  config: OpenClawConfig;          // 当前全局配置
  pluginConfig?: Record<string, unknown>;  // 插件自己的配置
  runtime: PluginRuntime;           // 运行时助手
  logger: PluginLogger;             // 日志

  // ─── 注册 API（9 种扩展点） ───
  registerTool(tool, opts?);        // 注册 Agent 工具
  registerChannel(registration);     // 注册消息渠道
  registerProvider(provider);        // 注册模型提供商认证
  registerHook(events, handler, opts?); // 注册传统钩子
  registerCli(registrar, opts?);     // 注册 CLI 命令
  registerService(service);          // 注册后台服务
  registerCommand(command);          // 注册自动回复命令（绕过 LLM）
  registerHttpRoute(params);         // 注册 HTTP 路由
  registerContextEngine(id, factory); // 注册上下文引擎

  // ─── 类型化生命周期钩子 ───
  on<K>(hookName: K, handler, opts?);  // 24 种生命周期事件

  // ─── 工具方法 ───
  resolvePath(input: string): string;  // 路径解析
};
```

---

## 4. 九大扩展点详解

### 4.1 Agent 工具 (`registerTool`)

让 LLM 在推理过程中调用自定义函数。

```typescript
import { Type } from "@sinclair/typebox";

export default function (api) {
  // 必选工具（始终可用）
  api.registerTool({
    name: "weather_query",
    description: "查询指定城市天气",
    parameters: Type.Object({
      city: Type.String({ description: "城市名称" }),
      unit: Type.Optional(Type.Enum({ celsius: "celsius", fahrenheit: "fahrenheit" })),
    }),
    async execute(_id, params) {
      const data = await fetchWeather(params.city, params.unit);
      return {
        content: [{ type: "text", text: JSON.stringify(data) }]
      };
    },
  });

  // 可选工具（需要用户在 tools.allow 中显式启用）
  api.registerTool(
    {
      name: "deploy_staging",
      description: "部署到 staging 环境",
      parameters: Type.Object({
        branch: Type.String(),
      }),
      async execute(_id, params) {
        const result = await deploy(params.branch);
        return { content: [{ type: "text", text: result }] };
      },
    },
    { optional: true }
  );
}
```

**工具上下文**（运行时自动注入）：

```typescript
type OpenClawPluginToolContext = {
  config?: OpenClawConfig;
  workspaceDir?: string;
  agentId?: string;
  sessionKey?: string;
  sessionId?: string;
  sandboxed?: boolean;
  requesterSenderId?: string;
  senderIsOwner?: boolean;
};
```

可以用工厂模式根据上下文动态生成工具：

```typescript
api.registerTool((ctx: OpenClawPluginToolContext) => {
  if (!ctx.senderIsOwner) return null; // 非 owner 不显示此工具
  return {
    name: "admin_tool",
    description: "管理员专用工具",
    parameters: { type: "object", properties: {} },
    async execute() {
      return { content: [{ type: "text", text: "admin action done" }] };
    },
  };
});
```

### 4.2 消息渠道 (`registerChannel`)

注册一个新的聊天平台适配器。

```typescript
export default function (api) {
  api.registerChannel({
    plugin: {
      id: "wechat",
      meta: {
        id: "wechat",
        label: "WeChat",
        selectionLabel: "WeChat (企业微信)",
        docsPath: "/channels/wechat",
        blurb: "企业微信消息通道",
        aliases: ["wecom"],
      },
      capabilities: {
        chatTypes: ["direct", "group"],
      },
      config: {
        listAccountIds: (cfg) =>
          Object.keys(cfg.channels?.wechat?.accounts ?? {}),
        resolveAccount: (cfg, accountId) =>
          cfg.channels?.wechat?.accounts?.[accountId ?? "default"] ?? { accountId },
      },
      outbound: {
        deliveryMode: "direct",
        sendText: async ({ text, to, cfg }) => {
          // 调用企业微信 API 发送消息
          await wechatApi.sendMessage(to, text);
          return { ok: true };
        },
      },
      gateway: {
        startAccount: async (ctx) => {
          // 启动 WebSocket 连接或轮询
          ctx.setStatus?.({ running: true, lastStartAt: Date.now() });
        },
        stopAccount: async (ctx) => {
          ctx.setStatus?.({ running: false, lastStopAt: Date.now() });
        },
      },
    },
  });
}
```

### 4.3 生命周期钩子 (`on`)

24 种类型化事件，覆盖 Agent 运行全生命周期：

```typescript
export default function (api) {
  // 在 Prompt 构建前注入上下文
  api.on("before_prompt_build", (event, ctx) => {
    return {
      prependSystemContext: "回答必须符合公司代码规范。",
      appendSystemContext: `当前 Agent: ${ctx.agentId}`,
    };
  }, { priority: 10 });

  // 在模型选择前动态切换模型
  api.on("before_model_resolve", (event, ctx) => {
    if (event.prompt.includes("紧急")) {
      return { modelOverride: "anthropic/claude-opus-4-6" };
    }
  });

  // 工具调用前拦截
  api.on("before_tool_call", (event, ctx) => {
    if (event.toolName === "exec" && !ctx.senderIsOwner) {
      return { block: true, blockReason: "非管理员不可执行命令" };
    }
  });

  // 消息发送前审查
  api.on("message_sending", (event, ctx) => {
    if (event.content.includes("机密")) {
      return { cancel: true };
    }
  });
}
```

**全部 24 种钩子**：

| 阶段 | 钩子名 | 可修改 |
|------|--------|--------|
| 模型选择 | `before_model_resolve` | model/provider override |
| Prompt 构建 | `before_prompt_build` | system prompt 注入 |
| Agent 启动 | `before_agent_start` | （兼容旧版） |
| LLM 调用 | `llm_input` / `llm_output` | 只读观测 |
| Agent 结束 | `agent_end` | 只读 |
| 压缩 | `before_compaction` / `after_compaction` | 只读 |
| 重置 | `before_reset` | 只读 |
| 消息 | `message_received` / `message_sending` / `message_sent` | 可修改/取消 |
| 工具 | `before_tool_call` / `after_tool_call` | 可拦截/修改参数 |
| 持久化 | `tool_result_persist` / `before_message_write` | 可修改/阻止 |
| Session | `session_start` / `session_end` | 只读 |
| Sub-agent | `subagent_spawning` / `subagent_spawned` / `subagent_ended` / `subagent_delivery_target` | 部分可修改 |
| Gateway | `gateway_start` / `gateway_stop` | 只读 |

### 4.4 自动回复命令 (`registerCommand`)

注册不经过 LLM 的快捷命令：

```typescript
api.registerCommand({
  name: "ping",
  description: "检查插件状态",
  acceptsArgs: false,
  requireAuth: false,
  handler: (ctx) => ({
    text: `Pong! Channel: ${ctx.channel}, Sender: ${ctx.senderId}`
  }),
});
```

### 4.5 HTTP 路由 (`registerHttpRoute`)

给 Gateway 添加 HTTP 端点：

```typescript
api.registerHttpRoute({
  path: "/webhook/github",
  auth: "plugin",       // 自行验证签名
  match: "exact",
  handler: async (req, res) => {
    const body = await collectBody(req);
    const sig = req.headers["x-hub-signature-256"];
    if (!verifyGithubSignature(body, sig)) {
      res.statusCode = 401;
      res.end("Unauthorized");
      return true;
    }
    await processWebhook(JSON.parse(body));
    res.statusCode = 200;
    res.end("ok");
    return true;
  },
});
```

### 4.6 后台服务 (`registerService`)

长期运行的后台任务：

```typescript
api.registerService({
  id: "health-monitor",
  start: async (ctx) => {
    ctx.logger.info("Health monitor started");
    setInterval(() => checkHealth(ctx.config), 60000);
  },
  stop: async (ctx) => {
    ctx.logger.info("Health monitor stopped");
  },
});
```

### 4.7 CLI 命令 (`registerCli`)

扩展 `openclaw` CLI：

```typescript
api.registerCli(({ program, config, logger }) => {
  program
    .command("myplug status")
    .description("Show my plugin status")
    .action(() => {
      logger.info("Plugin is running");
    });
}, { commands: ["myplug"] });
```

### 4.8 模型提供商认证 (`registerProvider`)

```typescript
api.registerProvider({
  id: "deepseek",
  label: "DeepSeek",
  auth: [{
    id: "api_key",
    label: "API Key",
    kind: "api_key",
    run: async (ctx) => {
      const key = await ctx.prompter.text("Enter DeepSeek API Key:");
      return {
        profiles: [{
          profileId: "deepseek:default",
          credential: { type: "api_key", provider: "deepseek", key },
        }],
        defaultModel: "deepseek/deepseek-chat",
      };
    },
  }],
});
```

### 4.9 上下文引擎 (`registerContextEngine`)

替换默认的上下文管理策略：

```typescript
api.registerContextEngine("smart-context", () => ({
  info: { id: "smart-context", name: "Smart Context Engine", ownsCompaction: true },
  async ingest(params) {
    // 自定义上下文摄入逻辑
    return { ingested: true };
  },
  async assemble({ messages }) {
    // 智能筛选重要消息
    const filtered = messages.filter(isImportant);
    return { messages: filtered, estimatedTokens: countTokens(filtered) };
  },
  async compact(params) {
    // 自定义压缩策略
    return { ok: true, compacted: true };
  },
}));
```

---

## 5. Plugin Runtime（运行时助手）

插件通过 `api.runtime` 访问核心运行时能力：

```typescript
type PluginRuntime = {
  version: string;                // OpenClaw 版本

  config: {
    loadConfig();                 // 加载配置
    writeConfigFile();            // 写入配置
  };

  system: {
    enqueueSystemEvent();         // 入队系统事件
    requestHeartbeatNow();        // 触发心跳
    runCommandWithTimeout();      // 执行命令（带超时）
    formatNativeDependencyHint(); // 原生依赖提示
  };

  media: {
    loadWebMedia();               // 加载网络媒体
    detectMime();                 // 检测 MIME 类型
    resizeToJpeg();               // 图片压缩
    getImageMetadata();           // 图片元数据
  };

  tts: {
    textToSpeechTelephony();      // 电话级 TTS
  };

  stt: {
    transcribeAudioFile();        // 语音转文字
  };

  subagent: {
    run(params);                  // 启动 sub-agent run
    waitForRun(params);           // 等待 run 完成
    getSessionMessages(params);   // 获取 session 消息
    deleteSession(params);        // 删除 session
  };

  events: {
    onAgentEvent();               // 监听 agent 事件
    onSessionTranscriptUpdate();  // 监听 transcript 更新
  };

  logging: {
    shouldLogVerbose();           // 是否详细日志
    getChildLogger(bindings);     // 创建子 logger
  };

  channel: { ... };              // 渠道相关运行时
};
```

---

## 6. 插件发现与加载机制

### 6.1 发现顺序（优先级从高到低）

```
1. plugins.load.paths    → 配置文件指定的路径
2. <workspace>/.openclaw/extensions/  → 工作区扩展
3. ~/.openclaw/extensions/            → 全局扩展
4. <openclaw>/extensions/             → 内置扩展（大多默认禁用）
```

同 ID 先匹配的胜出。

### 6.2 安全检查

OpenClaw 在发现阶段执行多重安全检查：

```
✓ 入口文件不能通过符号链接/路径遍历逃出插件根目录
✓ 插件根目录不能是 world-writable
✓ 非内置插件的路径 ownership 必须是当前用户或 root
✓ npm install 使用 --ignore-scripts（不执行生命周期脚本）
```

### 6.3 配置验证流程

```
发现阶段                    加载阶段
    │                          │
    ▼                          ▼
读取 openclaw.plugin.json    jiti 加载 plugin.ts
    │                          │
    ▼                          ▼
验证 configSchema            执行 register(api)
（不执行代码）               注册各种扩展点
    │                          │
    ▼                          ▼
配置校验通过 → 允许加载      扩展点就绪
```

---

## 7. 独占 Slot 机制

某些类别只允许一个插件激活：

```json5
{
  plugins: {
    slots: {
      memory: "memory-core",       // 或 "memory-lancedb" 或 "none"
      contextEngine: "legacy",     // 或自定义引擎 ID
    }
  }
}
```

如果多个插件声明同一个 `kind`，只有被 slot 选中的那个会加载。

---

## 8. 完整 Plugin 示例

### 示例一：GitHub Webhook 工具插件

```
github-webhook/
├── openclaw.plugin.json
└── src/
    └── index.ts
```

**`openclaw.plugin.json`**：

```json
{
  "id": "github-webhook",
  "name": "GitHub Webhook",
  "description": "Receive GitHub webhooks and expose PR info as agent tool",
  "configSchema": {
    "type": "object",
    "additionalProperties": false,
    "properties": {
      "webhookSecret": { "type": "string" },
      "defaultRepo": { "type": "string" }
    }
  },
  "uiHints": {
    "webhookSecret": { "label": "Webhook Secret", "sensitive": true },
    "defaultRepo": { "label": "默认仓库", "placeholder": "owner/repo" }
  }
}
```

**`src/index.ts`**：

```typescript
import { Type } from "@sinclair/typebox";
import crypto from "node:crypto";

// 内存中缓存最近的 webhook 事件
const recentEvents: Array<{ type: string; payload: unknown; receivedAt: number }> = [];

export default function register(api) {
  const config = api.pluginConfig as { webhookSecret?: string; defaultRepo?: string };
  const logger = api.logger;

  // ── 1. 注册 Agent 工具 ──
  api.registerTool({
    name: "github_events",
    description: "获取最近收到的 GitHub webhook 事件",
    parameters: Type.Object({
      eventType: Type.Optional(Type.String({ description: "过滤事件类型 (push/pull_request/issues)" })),
      limit: Type.Optional(Type.Number({ description: "返回数量", default: 5 })),
    }),
    async execute(_id, params) {
      let events = [...recentEvents];
      if (params.eventType) {
        events = events.filter(e => e.type === params.eventType);
      }
      events = events.slice(0, params.limit ?? 5);
      return {
        content: [{ type: "text", text: JSON.stringify(events, null, 2) }],
      };
    },
  });

  // ── 2. 注册 HTTP Webhook 端点 ──
  api.registerHttpRoute({
    path: "/webhook/github",
    auth: "plugin",
    match: "exact",
    handler: async (req, res) => {
      const chunks: Buffer[] = [];
      for await (const chunk of req) chunks.push(chunk as Buffer);
      const body = Buffer.concat(chunks).toString();

      // 验证签名
      if (config.webhookSecret) {
        const sig = req.headers["x-hub-signature-256"] as string;
        const expected = "sha256=" + crypto
          .createHmac("sha256", config.webhookSecret)
          .update(body)
          .digest("hex");
        if (sig !== expected) {
          res.statusCode = 401;
          res.end("Invalid signature");
          return true;
        }
      }

      const eventType = req.headers["x-github-event"] as string;
      const payload = JSON.parse(body);

      recentEvents.unshift({ type: eventType, payload, receivedAt: Date.now() });
      if (recentEvents.length > 100) recentEvents.length = 100;

      logger.info(`Received GitHub event: ${eventType}`);
      res.statusCode = 200;
      res.end("ok");
      return true;
    },
  });

  // ── 3. 注册 /ghstatus 命令（绕过 LLM） ──
  api.registerCommand({
    name: "ghstatus",
    description: "显示 GitHub webhook 事件统计",
    handler: () => ({
      text: `📊 GitHub Webhook Stats:\n` +
        `- 缓存事件数: ${recentEvents.length}\n` +
        `- 最近事件: ${recentEvents[0]?.type ?? "none"}\n` +
        `- 默认仓库: ${config.defaultRepo ?? "未配置"}`,
    }),
  });

  // ── 4. 注册生命周期钩子 ──
  api.on("gateway_start", (event) => {
    logger.info(`GitHub Webhook plugin ready on port ${event.port}`);
  });
}
```

**使用此插件**：

```bash
# 安装（本地开发）
openclaw plugins install ./github-webhook

# 配置
openclaw config set plugins.entries.github-webhook.config.webhookSecret "your-secret"
openclaw config set plugins.entries.github-webhook.config.defaultRepo "myorg/myrepo"

# 重启 Gateway
openclaw gateway restart

# 使用
# 1. GitHub 设置 webhook 指向 https://your-gateway/webhook/github
# 2. Agent 可以调用 github_events 工具
# 3. 用户可以发送 /ghstatus 查看统计
```

### 示例二：消息审计插件

一个纯观测型插件，记录所有消息和工具调用：

```
audit-logger/
├── openclaw.plugin.json
└── src/
    └── index.ts
```

**`openclaw.plugin.json`**：

```json
{
  "id": "audit-logger",
  "name": "Audit Logger",
  "description": "记录所有 Agent 交互到本地日志",
  "configSchema": {
    "type": "object",
    "additionalProperties": false,
    "properties": {
      "logDir": { "type": "string", "default": "/var/log/openclaw-audit" },
      "logToolCalls": { "type": "boolean", "default": true },
      "logMessages": { "type": "boolean", "default": true }
    }
  }
}
```

**`src/index.ts`**：

```typescript
import fs from "node:fs/promises";
import path from "node:path";

export default function register(api) {
  const config = api.pluginConfig as {
    logDir?: string;
    logToolCalls?: boolean;
    logMessages?: boolean;
  };
  const logDir = config.logDir ?? "/var/log/openclaw-audit";

  async function appendLog(category: string, data: unknown) {
    await fs.mkdir(logDir, { recursive: true });
    const file = path.join(logDir, `${category}.jsonl`);
    const line = JSON.stringify({ timestamp: new Date().toISOString(), ...data as object });
    await fs.appendFile(file, line + "\n");
  }

  // 记录所有收到的消息
  if (config.logMessages !== false) {
    api.on("message_received", async (event, ctx) => {
      await appendLog("messages", {
        direction: "inbound",
        from: event.from,
        channel: ctx.channelId,
        content: event.content.slice(0, 500),
      });
    });

    api.on("message_sent", async (event, ctx) => {
      await appendLog("messages", {
        direction: "outbound",
        to: event.to,
        channel: ctx.channelId,
        success: event.success,
        content: event.content.slice(0, 500),
      });
    });
  }

  // 记录所有工具调用
  if (config.logToolCalls !== false) {
    api.on("before_tool_call", async (event, ctx) => {
      await appendLog("tools", {
        phase: "before",
        tool: event.toolName,
        agent: ctx.agentId,
        session: ctx.sessionKey,
        params: event.params,
      });
    });

    api.on("after_tool_call", async (event, ctx) => {
      await appendLog("tools", {
        phase: "after",
        tool: event.toolName,
        agent: ctx.agentId,
        durationMs: event.durationMs,
        error: event.error,
      });
    });
  }

  api.registerCommand({
    name: "audit",
    description: "查看审计日志摘要",
    handler: async () => {
      try {
        const files = await fs.readdir(logDir);
        const stats = await Promise.all(
          files.map(async (f) => {
            const s = await fs.stat(path.join(logDir, f));
            return `${f}: ${(s.size / 1024).toFixed(1)}KB`;
          })
        );
        return { text: `📋 审计日志:\n${stats.join("\n")}` };
      } catch {
        return { text: "审计日志目录为空" };
      }
    },
  });
}
```

---

## 9. Package Packs（多插件包）

一个 npm 包可以包含多个插件：

```json
{
  "name": "@myorg/openclaw-tools",
  "openclaw": {
    "extensions": [
      "./src/safety-guard.ts",
      "./src/custom-tools.ts"
    ]
  }
}
```

每个 entry 会成为独立插件，ID 为 `@myorg/openclaw-tools/safety-guard`。

---

## 10. 安全模型

### 10.1 信任层级

```
┌───────────────────────────────────────┐
│ Level 1: plugins.allow / plugins.deny │  ← 白/黑名单
├───────────────────────────────────────┤
│ Level 2: Manifest 验证               │  ← 配置校验不执行代码
├───────────────────────────────────────┤
│ Level 3: 文件系统安全检查            │  ← 路径遍历/权限检查
├───────────────────────────────────────┤
│ Level 4: npm --ignore-scripts        │  ← 依赖安装不执行脚本
├───────────────────────────────────────┤
│ Level 5: Prompt 注入防护             │  ← hooks.allowPromptInjection
└───────────────────────────────────────┘
```

### 10.2 Prompt 注入控制

运营者可以按插件禁用 prompt 修改能力：

```json5
{
  plugins: {
    entries: {
      "untrusted-plugin": {
        enabled: true,
        hooks: {
          allowPromptInjection: false  // 阻止修改 system prompt
        }
      }
    }
  }
}
```

---

## 11. 关键设计原则

| 原则 | 实现 |
|------|------|
| **声明与执行分离** | Manifest 用于配置验证（不执行代码），register() 用于运行时注册 |
| **进程内执行** | 插件与 Gateway 同进程，零 IPC 开销 |
| **TypeScript 原生** | jiti 即时编译，开发者直接写 .ts，无需构建步骤 |
| **最小权限** | 工具默认 optional，白名单控制，prompt 注入可禁用 |
| **独占 Slot** | Memory 和 ContextEngine 同时只有一个活跃 |
| **SDK + Runtime 双层** | SDK 是编译时类型，Runtime 是运行时能力，插件不能直接 import 核心源码 |

---

## 12. 总结

OpenClaw Plugin 架构的本质是一个**声明式 Manifest + 运行时注册 API** 的双层系统：

```
openclaw.plugin.json (静态声明)
    │
    │  配置验证、发现、安全检查
    │  不执行代码
    │
    ▼
register(api) (动态注册)
    │
    │  9 种扩展点 + 24 种生命周期钩子
    │  进程内执行，零 IPC
    │
    ▼
Gateway Runtime
    │
    │  工具 → LLM 调用
    │  渠道 → 消息收发
    │  钩子 → 生命周期事件
    │  命令 → 快捷回复
    │
    ▼
用户交互
```

这个设计在**安全性**（声明式验证、白名单、路径检查）和**灵活性**（9 种扩展点、24 种钩子、运行时动态注册）之间取得了出色的平衡。

---

## 参考来源

1. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/tools/plugin.md`
2. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/plugins/agent-tools.md`
3. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/plugins/manifest.md`
4. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/cli/plugins.md`
5. OpenClaw 文档 — `/usr/lib/node_modules/openclaw/docs/refactor/plugin-sdk.md`
6. 源码类型定义 — `dist/plugin-sdk/plugins/types.d.ts` (OpenClawPluginApi 完整接口)
7. 源码类型定义 — `dist/plugin-sdk/plugins/runtime/types.d.ts` (PluginRuntime)
8. 源码类型定义 — `dist/plugin-sdk/plugins/runtime/types-core.d.ts` (PluginRuntimeCore)
9. 实际插件实现 — `extensions/twitch/src/plugin.ts` (Twitch 频道插件)
10. 插件 Manifest 示例 — `extensions/llm-task/openclaw.plugin.json`
