# OpenClaw v2026.3.12 Fast Mode 实现深度研究报告

> 研究员：黄山 (wairesearch)
> 日期：2026-03-13（卷王小组 v2 更新）
> 版本：OpenClaw 2026.3.12 (6472949)
> 来源：https://github.com/openclaw/openclaw/releases/tag/v2026.3.12

---

## 执行摘要

Fast Mode 是 OpenClaw v2026.3.12 引入的**会话级低延迟模式**。通过统一的 `/fast` 指令，针对不同 Provider 自动注入低延迟优化参数。当前原生支持 OpenAI（GPT-5.4 系列）和 Anthropic（Claude 系列）两个 Provider。

核心设计采用 **Wrapper 洋葱模型**——在模型流式调用链上动态包裹 payload 修改层，不侵入核心传输逻辑，实现了良好的解耦与可扩展性。Fast Mode 的状态通过 Gateway 的 `sessions.patch` API 持久化，并在 Chat 命令、TUI、Control UI、ACP 四个入口统一暴露。

---

## 一、架构原理

### 1.1 整体流程

```
用户请求（/fast on | @fast on | Config | UI toggle）
  │
  ▼
resolveFastModeState()           ← 三层优先级：session > config > default
  │
  ▼
Agent streamFn 组装管线
  │
  ├── createAnthropicFastModeWrapper()  ← Anthropic: 注入 service_tier
  └── createOpenAIFastModeWrapper()     ← OpenAI: 注入 reasoning + text + service_tier
  │
  ▼
onPayload callback               ← 拦截并修改 API payload（发送前最后一步）
  │
  ▼
Provider API（api.openai.com / api.anthropic.com）
```

### 1.2 核心源码位置

| 编译产物 | 源码推断路径 | 内容 |
|----------|-------------|------|
| `dist/config-CmS8VEM4.js:94837` | `src/agents/fast-mode.ts` | 状态解析核心：`resolveFastModeState`、`resolveFastModeParam`、`normalizeFastMode` |
| `dist/config-CmS8VEM4.js:94995` | `src/agents/pi-embedded-runner/anthropic-stream-wrappers.ts` | Anthropic Fast Mode Wrapper |
| `dist/config-CmS8VEM4.js:95230` | `src/agents/pi-embedded-runner/openai-stream-wrappers.ts` | OpenAI Fast Mode Wrapper |
| `dist/config-CmS8VEM4.js:95600` | Agent streamFn 组装管线 | Wrapper 注册与组装顺序 |
| `dist/config-CmS8VEM4.js:115520` | 命令处理 | `/fast` 命令 handler |
| `dist/config-CmS8VEM4.js:103938` | 指令提取 | `extractFastDirective` 内联指令解析 |
| `dist/tui-jMugLuCa.js:2113` | TUI 快速命令 | TUI `/fast` 处理 |
| `dist/acp-cli-Bi0YMmBx.js:1090` | ACP Bridge | ACP session config 中的 fast mode 选项 |
| `dist/control-ui/assets/sessions-ecOOkBHE.js:138` | Control UI Sessions | UI 中的 fast mode 下拉切换 |
| `dist/plugin-sdk/agents/fast-mode.d.ts` | 类型定义 | 公开 API 类型 |

---

## 二、状态解析机制

### 2.1 三层优先级

Fast Mode 状态通过 `resolveFastModeState()` 函数解析，遵循严格的三层优先级：

```typescript
type FastModeState = {
    enabled: boolean;
    source: "session" | "config" | "default";
};

function resolveFastModeState(params): FastModeState {
    // 1️⃣ 最高优先级: Session 级覆盖（用户通过 /fast on 设置）
    const sessionOverride = normalizeFastMode(params.sessionEntry?.fastMode);
    if (sessionOverride !== undefined)
        return { enabled: sessionOverride, source: "session" };

    // 2️⃣ 中优先级: Config 级配置
    const configured = normalizeFastMode(resolveConfiguredFastModeRaw(params));
    if (configured !== undefined)
        return { enabled: configured, source: "config" };

    // 3️⃣ 默认: 关闭
    return { enabled: false, source: "default" };
}
```

### 2.2 值归一化

`normalizeFastMode()` 接受多种输入格式并统一转换为 `boolean | undefined`：

```typescript
function normalizeFastMode(raw) {
    if (typeof raw === "boolean") return raw;
    if (!raw) return undefined;
    const key = raw.toLowerCase();
    // false 组
    if (["off","false","no","0","disable","disabled","normal"].includes(key))
        return false;
    // true 组
    if (["on","true","yes","1","enable","enabled","fast"].includes(key))
        return true;
    // 无法识别 → undefined（忽略）
    return undefined;
}
```

### 2.3 Config 默认值读取

```typescript
function resolveConfiguredFastModeRaw(params) {
    const modelKey = `${params.provider}/${params.model}`;
    const modelConfig = params.cfg?.agents?.defaults?.models?.[modelKey];
    return modelConfig?.params?.fastMode ?? modelConfig?.params?.fast_mode;
}
```

支持 `camelCase` 和 `snake_case` 两种写法。

---

## 三、触发入口（完整分析）

### 3.1 入口一：`/fast` 命令（Chat Surface）

```
/fast          → 显示当前状态（含来源标注）
/fast status   → 显示当前状态
/fast on       → 启用并持久化
/fast off      → 禁用并持久化
```

**完整处理流程：**

```typescript
const handleFastCommand = async (params, allowTextCommands) => {
    // 1. 命令匹配
    if (normalized !== "/fast" && !normalized.startsWith("/fast ")) return null;

    // 2. 权限检查
    if (!params.command.isAuthorizedSender) {
        logVerbose(`Ignoring /fast from unauthorized sender`);
        return { shouldContinue: false };
    }

    // 3. 状态查询
    if (!rawMode || rawMode === "status") {
        const state = resolveFastModeState({ ... });
        const suffix = state.source === "config" ? " (config)"
                     : state.source === "default" ? " (default)" : "";
        return { reply: { text: `⚙️ Current fast mode: ${state.enabled ? "on" : "off"}${suffix}.` }};
    }

    // 4. 值解析
    const nextMode = normalizeFastMode(rawMode);
    if (nextMode === undefined)
        return { reply: { text: "⚙️ Usage: /fast status|on|off" }};

    // 5. 写入 Session Entry 并持久化
    params.sessionEntry.fastMode = nextMode;
    await persistSessionEntry(params);

    return { reply: { text: `⚙️ Fast mode ${nextMode ? "enabled" : "disabled"}.` }};
};
```

**关键点：** 状态查询时会标注来源（session / config / default），方便用户理解当前生效的配置来自哪里。

### 3.2 入口二：内联指令（消息体中的 `@fast`）

用户在消息体中内嵌 `/fast on` 或 `/fast off`，无需单独发送命令。

**指令提取机制：**

```typescript
// 通用指令匹配器
const matchLevelDirective = (body, names) => {
    const namePattern = names.map(escapeRegExp).join("|");
    // 匹配模式：空白或行首 + / + 指令名 + 可选参数
    const match = body.match(new RegExp(`(?:^|\\s)\\/(?:${namePattern})(?=$|\\s|:)`, "i"));
    if (!match) return null;

    // 提取参数（冒号或空格分隔）
    // 例如: "/fast on" 或 "/fast:on"
    let i = match.index + match[0].length;
    // 跳过空白
    while (i < body.length && /\s/.test(body[i])) i++;
    // 跳过冒号
    if (body[i] === ":") { i++; while (i < body.length && /\s/.test(body[i])) i++; }
    // 提取参数值（仅 [A-Za-z-] 字符）
    const argStart = i;
    while (i < body.length && /[A-Za-z-]/.test(body[i])) i++;
    const rawLevel = i > argStart ? body.slice(argStart, i) : undefined;

    return { start, end: i, rawLevel };
};

// Fast Mode 特定提取器
function extractFastDirective(body) {
    const extracted = extractLevelDirective(body, ["fast"], normalizeFastMode);
    return {
        cleaned: extracted.cleaned,     // 移除指令后的消息文本
        fastMode: extracted.level,      // true | false | undefined
        rawLevel: extracted.rawLevel,   // 原始参数字符串
        hasDirective: extracted.hasDirective
    };
}
```

**指令系统共享架构：** Fast Mode 的内联指令提取与 Thinking、Verbose、Elevated、Reasoning 等指令共享同一套 `extractLevelDirective` 机制，区别仅在于注册的指令名和归一化函数：

| 指令 | 注册名 | 归一化函数 |
|------|--------|-----------|
| `/fast on` | `["fast"]` | `normalizeFastMode` |
| `/think high` | `["thinking", "think", "t"]` | `normalizeThinkLevel` |
| `/verbose on` | `["verbose", "v"]` | `normalizeVerboseLevel` |
| `/elevated on` | `["elevated", "elev"]` | `normalizeElevatedLevel` |
| `/reasoning on` | `["reasoning", "reason"]` | `normalizeReasoningLevel` |

**消息流中的处理顺序：**

```
原始消息
  → extractThinkDirective()     // 提取 /think 指令
  → extractVerboseDirective()   // 提取 /verbose 指令
  → extractFastDirective()      // 提取 /fast 指令 ← 这里
  → extractElevatedDirective()  // 提取 /elevated 指令
  → extractReasoningDirective() // 提取 /reasoning 指令
  → cleaned 消息文本传递给模型
```

内联指令从消息中移除后，cleaned 文本才传递给模型，模型不会看到 `/fast on`。

### 3.3 入口三：Config 默认值

```json5
{
  agents: {
    defaults: {
      models: {
        "openai/gpt-5.4": {
          params: { fastMode: true }
        },
        "anthropic/claude-sonnet-4-5": {
          params: { fastMode: true }
        }
      }
    }
  }
}
```

Config 级配置在 `resolveFastModeState` 中作为第二优先级读取。Session 覆盖会赢过 Config。

### 3.4 入口四：TUI（Terminal UI）

```typescript
// dist/tui-jMugLuCa.js
case "fast":
    if (!args || args === "status") {
        chatLog.addSystem(`fast mode: ${state.sessionInfo.fastMode ? "on" : "off"}`);
        break;
    }
    if (args !== "on" && args !== "off") {
        chatLog.addSystem("usage: /fast <status|on|off>");
        break;
    }
    // 通过 Gateway API 持久化
    const result = await client.patchSession({
        key: state.currentSessionKey,
        fastMode: args === "on"
    });
    chatLog.addSystem(`fast mode ${args === "on" ? "enabled" : "disabled"}`);
    applySessionInfoFromPatch(result);
    await refreshSessionInfo();
    break;
```

TUI 通过 `client.patchSession()` 调用 Gateway 的 `sessions.patch` API 持久化 fast mode 状态。

**TUI 状态同步机制：**
```typescript
// Session 信息更新回调
if (entry?.fastMode !== undefined) next.fastMode = entry.fastMode;
// 在 footer 状态栏显示
const fast = sessionInfo.fastMode === true;
// fast 为 true 时，footer 显示 "Fast: on"
```

### 3.5 入口五：ACP（Agent Communication Protocol）

ACP Bridge 将 fast mode 暴露为可配置的 session-level 选项：

```typescript
// dist/acp-cli-Bi0YMmBx.js
buildSelectConfigOption({
    id: ACP_FAST_MODE_CONFIG_ID,
    name: "Fast mode",
    description: "Controls whether OpenAI sessions use the Gateway fast-mode profile.",
    currentValue: row.fastMode ? "on" : "off",
    values: ["off", "on"]
}),

// 配置变更处理
case ACP_FAST_MODE_CONFIG_ID: return {
    patch: { fastMode: value === "on" },
    overrides: { fastMode: value === "on" }
};
```

ACP 客户端（如 Codex、Claude Code）可以通过 ACP 协议修改 session 的 fast mode 状态。

### 3.6 入口六：Control UI（Web Dashboard）

```javascript
// dist/control-ui/assets/sessions-ecOOkBHE.js
// 显示：三态下拉（on / off / 空=继承默认）
const k = e.fastMode === true ? "on" : e.fastMode === false ? "off" : "";

// 修改：调用 sessions.patch API
@change=${t => {
    const b = t.target.value;
    l(e.key, { fastMode: b === "" ? null : b === "on" });
}}
```

Control UI 支持三种状态：
- `on` → `fastMode: true`
- `off` → `fastMode: false`
- 空（清除覆盖） → `fastMode: null`（回退到 config/default）

**状态持久化统一路径：**

```
所有入口 → sessions.patch API → sessionEntry.fastMode → 持久化到 session store
```

`sessions.patch` 是 Gateway 的 write 级操作，需要 `operator.write` 或 `operator.admin` scope。

---

## 四、OpenAI Fast Mode 实现

### 4.1 Wrapper 创建

```typescript
function createOpenAIFastModeWrapper(baseStreamFn) {
    const underlying = baseStreamFn ?? streamSimple;
    return (model, context, options) => {
        // Guard: 仅限 OpenAI Responses API 和 Codex Responses API
        if (model.api !== "openai-responses" &&
            model.api !== "openai-codex-responses" ||
            model.provider !== "openai" &&
            model.provider !== "openai-codex")
            return underlying(model, context, options);  // 直接透传

        const originalOnPayload = options?.onPayload;
        return underlying(model, context, {
            ...options,
            onPayload: (payload) => {
                if (payload && typeof payload === "object")
                    applyOpenAIFastModePayloadOverrides({
                        payloadObj: payload,
                        model
                    });
                return originalOnPayload?.(payload, model);
            }
        });
    };
}
```

### 4.2 Payload 修改（完整逻辑）

```typescript
function resolveFastModeReasoningEffort(modelId) {
    // 当前所有模型统一 "low"
    if (modelId.trim().toLowerCase().startsWith("gpt-5")) return "low";
    return "low";
}

function applyOpenAIFastModePayloadOverrides(params) {
    // 1. 降低推理深度（仅当 payload 未指定时）
    if (params.payloadObj.reasoning === undefined)
        params.payloadObj.reasoning = {
            effort: resolveFastModeReasoningEffort(params.model.id)
        };

    // 2. 降低文本冗余度（仅当 payload 未指定时）
    const existingText = params.payloadObj.text;
    if (existingText === undefined)
        params.payloadObj.text = { verbosity: "low" };
    else if (existingText && typeof existingText === "object" && !Array.isArray(existingText)) {
        const textObj = existingText;
        if (textObj.verbosity === undefined)
            textObj.verbosity = "low";
    }

    // 3. 优先服务层级（仅限直连 api.openai.com）
    if (params.model.provider === "openai" &&
        params.payloadObj.service_tier === undefined &&
        isOpenAIPublicApiBaseUrl(params.model.baseUrl))
        params.payloadObj.service_tier = "priority";
}
```

### 4.3 注入参数总结

| 参数 | 值 | 注入条件 | OpenAI API 含义 |
|------|-----|---------|----------------|
| `reasoning.effort` | `"low"` | payload 未指定 reasoning | 减少推理步骤，加快响应 |
| `text.verbosity` | `"low"` | payload 未指定 text 或未指定 verbosity | 减少输出冗余度 |
| `service_tier` | `"priority"` | 直连 api.openai.com 且 payload 未指定 | OpenAI Priority Tier 优先调度 |

### 4.4 Guard 条件详解

| 条件 | 代码 | 说明 |
|------|------|------|
| API 类型 | `model.api === "openai-responses"` 或 `"openai-codex-responses"` | 不对 Chat Completions API 生效 |
| Provider | `model.provider === "openai"` 或 `"openai-codex"` | 不影响 OpenRouter 等代理 Provider |
| Base URL | `isOpenAIPublicApiBaseUrl(model.baseUrl)` | `service_tier` 仅限直连 api.openai.com |
| 不覆盖原则 | 所有参数都有 `=== undefined` 守卫 | 用户显式设置的参数绝不被覆盖 |

### 4.5 与 Service Tier Wrapper 的关系

OpenAI Fast Mode Wrapper 和独立的 Service Tier Wrapper 是**两个不同的 wrapper**：

```
Fast Mode Wrapper → 当 fast mode 开启时自动设置 service_tier = "priority"
Service Tier Wrapper → 当用户在 params 中显式配置 serviceTier 时注入
```

组装顺序：Fast Mode 在前，Service Tier 在后。由于 `=== undefined` 守卫，Fast Mode 设置的 `service_tier` 不会被后续 wrapper 覆盖（除非用户显式配置了 `params.serviceTier`）。

---

## 五、Anthropic Fast Mode 实现

### 5.1 Wrapper 创建

```typescript
function createAnthropicFastModeWrapper(baseStreamFn, enabled) {
    const underlying = baseStreamFn ?? streamSimple;
    const serviceTier = resolveAnthropicFastServiceTier(enabled);

    return (model, context, options) => {
        // Guard: 4 个条件全部满足才注入
        if (model.api !== "anthropic-messages" ||
            model.provider !== "anthropic" ||
            !isAnthropicPublicApiBaseUrl(model.baseUrl) ||
            isAnthropicOAuthApiKey(options?.apiKey))
            return underlying(model, context, options);

        const originalOnPayload = options?.onPayload;
        return underlying(model, context, {
            ...options,
            onPayload: (payload) => {
                if (payload && typeof payload === "object") {
                    const payloadObj = payload;
                    if (payloadObj.service_tier === undefined)
                        payloadObj.service_tier = serviceTier;
                }
                return originalOnPayload?.(payload, model);
            }
        });
    };
}
```

### 5.2 Service Tier 映射

```typescript
function resolveAnthropicFastServiceTier(enabled) {
    return enabled ? "auto" : "standard_only";
}
```

| Fast Mode 状态 | `service_tier` 值 | Anthropic API 含义 |
|----------------|-------------------|-------------------|
| on | `"auto"` | 允许使用 Priority Tier（如果账户有容量） |
| off | `"standard_only"` | 强制仅使用标准层 |

### 5.3 Guard 条件详解

| 条件 | 代码 | 说明 |
|------|------|------|
| API 类型 | `model.api === "anthropic-messages"` | 仅限 Anthropic Messages API |
| Provider | `model.provider === "anthropic"` | 不影响 Bedrock 等通过 Anthropic 模型的代理 |
| Base URL | `isAnthropicPublicApiBaseUrl(model.baseUrl)` | 仅限直连 api.anthropic.com |
| 认证类型 | `!isAnthropicOAuthApiKey(options?.apiKey)` | OAuth 认证（sk-ant-oat-* 开头的 key）被排除 |

### 5.4 OAuth 排除逻辑

```typescript
function isAnthropicOAuthApiKey(apiKey) {
    return typeof apiKey === "string" && apiKey.includes("sk-ant-oat");
}
```

这确保了通过 Anthropic 的 OAuth/setup-token 认证路径不受 fast mode 影响，因为 OAuth 认证不支持 `service_tier` 头。

### 5.5 重要限制

- **API-key only**：Anthropic OAuth 认证不支持 fast mode tier 注入
- **直连 only**：通过代理/网关路由的请求不注入 `service_tier`
- **无保证**：`service_tier: "auto"` 在没有 Priority Tier 容量的账户上仍降级为 standard
- Anthropic 在响应的 `usage.service_tier` 中返回实际使用的层级

### 5.6 OpenAI vs Anthropic 对比

| 维度 | OpenAI Fast Mode | Anthropic Fast Mode |
|------|-----------------|-------------------|
| 注入参数数 | 3 个 | 1 个 |
| reasoning | `effort: "low"` | 无 |
| text verbosity | `verbosity: "low"` | 无 |
| service_tier | `"priority"` | `"auto"` / `"standard_only"` |
| OAuth 支持 | N/A | ❌ 排除 |
| API 限制 | Responses API only | Messages API only |
| 代理支持 | ❌ 仅直连 | ❌ 仅直连 |

---

## 六、Wrapper 组装管线（完整顺序）

在 Agent streamFn 构建管线中（源码约第 95600-95660 行），各 Wrapper 按以下顺序组装：

```
基础 streamFn (streamSimple)
  │
  ├── 1. Moonshot Thinking Wrapper          ← 条件：Moonshot 兼容 Provider
  ├── 2. Anthropic Tool Payload Wrapper     ← 条件：需要工具 payload 兼容性转换
  ├── 3. OpenRouter Wrapper                 ← 条件：provider === "openrouter"
  ├── 4. OpenRouter System Cache Wrapper    ← 条件：provider === "openrouter"
  ├── 5. Kilocode Wrapper                   ← 条件：provider === "kilocode"
  ├── 6. Bedrock NoCache Wrapper            ← 条件：非 Anthropic Bedrock 模型
  ├── 7. Z.AI Tool Stream Wrapper           ← 条件：provider === "zai"
  ├── 8. Google Thinking Wrapper            ← 条件：Google 模型
  │
  ├── 9.  🔥 Anthropic Fast Mode Wrapper    ← 条件：Anthropic fast mode 配置
  ├── 10. 🔥 OpenAI Fast Mode Wrapper       ← 条件：OpenAI fast mode 开启
  │
  ├── 11. OpenAI Service Tier Wrapper       ← 条件：显式 serviceTier 参数
  ├── 12. OpenAI Responses Context Mgmt     ← 条件：store/compaction 配置
  └── 13. Parallel Tool Calls Wrapper       ← 条件：parallel_tool_calls 参数
```

**组装代码：**

```typescript
// 9. Anthropic Fast Mode
const anthropicFastMode = resolveAnthropicFastMode(merged);
if (anthropicFastMode !== undefined) {
    log.debug(`applying Anthropic fast mode=${anthropicFastMode} for ${provider}/${modelId}`);
    agent.streamFn = createAnthropicFastModeWrapper(agent.streamFn, anthropicFastMode);
}

// 10. OpenAI Fast Mode
if (resolveOpenAIFastMode(merged)) {
    log.debug(`applying OpenAI fast mode for ${provider}/${modelId}`);
    agent.streamFn = createOpenAIFastModeWrapper(agent.streamFn);
}

// 11. OpenAI Service Tier（独立于 Fast Mode）
const openAIServiceTier = resolveOpenAIServiceTier(merged);
if (openAIServiceTier) {
    log.debug(`applying OpenAI service_tier=${openAIServiceTier} for ${provider}/${modelId}`);
    agent.streamFn = createOpenAIServiceTierWrapper(agent.streamFn, openAIServiceTier);
}
```

**关键顺序关系：**
- Fast Mode Wrapper（#9, #10）先于 Service Tier Wrapper（#11）
- 都有 `=== undefined` 守卫，不会冲突
- Anthropic Fast Mode 在组装时即传入 `enabled` 参数（来自 extraParams），而 OpenAI Fast Mode 不传参（内部硬编码逻辑）

---

## 七、Session 持久化机制

### 7.1 数据流

```
用户操作 → /fast on
  │
  ▼
handleFastCommand() / TUI / Control UI / ACP
  │
  ▼
sessionEntry.fastMode = true
  │
  ▼
persistSessionEntry() 或 sessions.patch API
  │
  ▼
Session Store（磁盘持久化）
  │
  ▼
下次请求时 resolveFastModeState() 读取 sessionEntry.fastMode
```

### 7.2 Session Schema

```typescript
// Session Entry 中的 fastMode 字段定义
{
    fastMode: Type.Optional(Type.Union([Type.Boolean(), Type.Null()]))
    // true → 开启
    // false → 关闭
    // null / undefined → 未设置（使用 config/default）
}
```

### 7.3 跨界面同步

当 fast mode 通过 TUI 修改时：
```typescript
const result = await client.patchSession({ key: sessionKey, fastMode: args === "on" });
applySessionInfoFromPatch(result);  // 更新本地状态
await refreshSessionInfo();          // 重新加载 session 信息
```

当通过 Control UI 修改时：
```javascript
// Control UI 通过 WebSocket 调用 sessions.patch
await e.client.request("sessions.patch", { key: sessionKey, fastMode: value === "on" });
```

所有修改路径最终调用同一个 Gateway API：`sessions.patch`。

### 7.4 Session Info 在 /status 中的展示

```typescript
// 状态卡片中的 Fast Mode 显示
const fastMode = args.resolvedFast ?? args.sessionEntry?.fastMode ?? false;
// 格式化为状态行
fastMode ? "Fast: on" : null  // 仅在开启时显示
```

---

## 八、消息处理中的 Fast Mode 完整生命周期

从用户发送一条包含 `/fast on` 的消息，到 fast mode 生效的完整链路：

```
用户消息: "帮我写个函数 /fast on"
  │
  ▼ [1] 指令提取阶段
  extractThinkDirective()   → 无匹配
  extractVerboseDirective() → 无匹配
  extractFastDirective()    → 匹配！提取 fastMode=true
  │                           cleaned="帮我写个函数"
  ▼
  [2] 指令应用阶段
  directives.fastMode = true
  directives.hasFastDirective = true
  │
  ▼ [3] 状态合并
  effectiveFastMode = directives.fastMode    // session 覆盖
       ?? currentFastMode                     // 当前 session 状态
       ?? fastModeState.enabled               // config/default
  │
  ▼ [4] Session 持久化
  if (hasFastDirective && fastMode !== undefined)
      sessionEntry.fastMode = directives.fastMode;  // 写入 session
  │
  ▼ [5] 确认消息
  parts.push(formatDirectiveAck("Fast mode enabled."));
  │
  ▼ [6] 系统事件
  if (fastModeChanged)
      enqueueSystemEvent("Fast mode enabled.", {
          contextKey: "fast:on"
      });
  │
  ▼ [7] 模型调用
  Agent streamFn 管线中的 Fast Mode Wrapper 根据 session 状态注入参数
  cleaned 消息 "帮我写个函数" 发送给模型
```

---

## 九、其他模型适配 Fast Mode 指南

### 9.1 场景分类

| 场景 | 需要做什么 | 复杂度 |
|------|-----------|--------|
| 兼容 OpenAI Responses API 的模型（通过 `openai/*` 路由） | 无需改代码，配置 `params.fastMode` | ⭐ |
| 兼容 Anthropic Messages API 的模型（通过 `anthropic/*` 路由） | 无需改代码，配置 `params.fastMode` | ⭐ |
| 新 Provider 有自己的快速 API | 新增 Provider 特定 Wrapper | ⭐⭐⭐ |
| 本地模型（Ollama、vLLM） | 参数调优模拟 | ⭐⭐ |

### 9.2 方案 A：无需改代码（配置即可）

```json5
{
  agents: {
    defaults: {
      models: {
        "openai/your-model-id": { params: { fastMode: true } },
        "anthropic/your-model-id": { params: { fastMode: true } }
      }
    }
  }
}
```

### 9.3 方案 B：新增 Provider Wrapper（需改代码）

#### 步骤 1：创建 Provider 特定的 Wrapper

```typescript
function createNewProviderFastModeWrapper(baseStreamFn, enabled) {
    const underlying = baseStreamFn ?? streamSimple;
    return (model, context, options) => {
        // Guard: 仅对目标 provider 生效
        if (model.provider !== "new-provider" || model.api !== "target-api")
            return underlying(model, context, options);

        const originalOnPayload = options?.onPayload;
        return underlying(model, context, {
            ...options,
            onPayload: (payload) => {
                if (payload && typeof payload === "object") {
                    const payloadObj = payload;
                    // 注入 Provider 特定参数（遵循 === undefined 守卫原则）
                    if (payloadObj.some_param === undefined)
                        payloadObj.some_param = "fast_value";
                }
                return originalOnPayload?.(payload, model);
            }
        });
    };
}
```

#### 步骤 2：注册到组装管线

```typescript
// 在 Google Thinking Wrapper (#8) 之后、OpenAI Service Tier Wrapper (#11) 之前
const newFastMode = resolveNewProviderFastMode(merged);
if (newFastMode !== undefined) {
    log.debug(`applying NewProvider fast mode=${newFastMode}`);
    agent.streamFn = createNewProviderFastModeWrapper(agent.streamFn, newFastMode);
}
```

#### 步骤 3：自动复用的基础设施

| 基础设施 | 说明 | 是否需要修改 |
|----------|------|-------------|
| `/fast on/off` 命令 | 写入 `sessionEntry.fastMode` | ❌ 自动可用 |
| `@fast on` 内联指令 | `extractFastDirective` 解析 | ❌ 自动可用 |
| Config 配置 | `params.fastMode` 读取 | ❌ 自动可用 |
| `resolveFastModeState()` | 三层优先级解析 | ❌ 自动可用 |
| Control UI 下拉 | session 面板 | ❌ 自动可用 |
| TUI `/fast` 命令 | Terminal UI | ❌ 自动可用 |
| ACP Bridge | ACP 客户端 | ❌ 自动可用 |
| `/status` 显示 | 状态卡片 | ❌ 自动可用 |

**核心结论：新增 Provider 支持只需实现 Wrapper + 注册，所有状态管理和 UI 入口自动继承。**

#### 步骤 4：设计守则

1. **始终使用 `=== undefined` 守卫**——不覆盖用户显式设置的参数
2. **限制注入范围**——仅在直连公共 API 时注入，代理/网关路由跳过
3. **Guard 条件要严格**——至少检查 `model.api`、`model.provider`、`model.baseUrl`
4. **认证类型检查**——如有特殊认证路径（如 Anthropic OAuth），要排除

### 9.4 各 Provider 适配参数参考

| Provider | 建议注入的参数 | 备注 |
|----------|---------------|------|
| **Google Gemini** | `generationConfig.thinkingConfig.thinkingBudget` 降低 | Google 无 service_tier 概念 |
| **DeepSeek** | 降低 `reasoning_effort` / 关闭 deep thinking | DeepSeek R1 支持 thinking 控制 |
| **AWS Bedrock (Anthropic)** | `inferenceConfig` 调优 | 注意：当前代码已排除 Bedrock Anthropic 模型的 fast mode |
| **OpenRouter** | 透传底层 Provider 的 fast mode 参数 | 取决于 OpenRouter 是否暴露优先通道 |
| **Ollama / vLLM** | 降低 `num_predict` / 调整 `temperature` | 纯本地推理，无 tier 概念 |
| **Moonshot / Kimi** | 降低 thinking budget 或切换非 thinking 模式 | 需配合 Moonshot Thinking Wrapper |

---

## 十、设计评价

### 10.1 优势

| 方面 | 评价 | 说明 |
|------|------|------|
| **Wrapper 洋葱模型** | ✅ 优秀 | 解耦、可组合、不侵入核心流式传输逻辑 |
| **三层状态优先级** | ✅ 清晰 | session > config > default，语义明确 |
| **Guard 条件** | ✅ 严谨 | 只在直连公共 API 时注入，避免代理场景意外 |
| **Provider 隔离** | ✅ 各 Provider 独立 wrapper，互不干扰 |
| **不覆盖原则** | ✅ 所有注入有 `=== undefined` 守卫 |
| **统一入口** | ✅ 6 个入口汇入同一状态逻辑 |
| **指令共享架构** | ✅ 与 think/verbose/elevated/reasoning 共享 extractLevelDirective |
| **Session 持久化** | ✅ 通过 sessions.patch API 统一持久化，跨界面一致 |

### 10.2 不足与改进建议

| 方面 | 现状 | 建议 |
|------|------|------|
| **可扩展性** | 新 Provider 需手动添加 wrapper + 注册 | 抽象 `ProviderFastModeAdapter` 接口，让 Provider Plugin 自行声明 fast mode 参数映射 |
| **参数固定** | OpenAI `reasoning.effort` 硬编码为 `"low"` | 引入 fast mode 级别（fast/faster/fastest），映射不同参数组合 |
| **反馈不足** | 用户无法知道 fast mode 是否真正命中了 priority tier | 在响应中展示实际 service_tier（Anthropic 已返回，OpenAI 需确认） |
| **文档分散** | 各 Provider 的 fast mode 行为分散在各自文档中 | 增加统一的 fast mode 对比文档 |
| **ACP 描述不准确** | ACP Bridge 描述写 "OpenAI sessions" | 应改为 "OpenAI and Anthropic sessions" |
| **Bedrock 不支持** | Bedrock Anthropic 模型被排除 | 考虑为 Bedrock 添加独立的 fast mode 支持 |

---

## 十一、参考来源

1. OpenClaw v2026.3.12 Release Notes — https://github.com/openclaw/openclaw/releases/tag/v2026.3.12
2. 本地源码分析 — `/usr/lib/node_modules/openclaw/dist/config-CmS8VEM4.js`（行 94837-95660, 103863-103950, 115520-115560）
3. TUI 实现 — `/usr/lib/node_modules/openclaw/dist/tui-jMugLuCa.js`（行 2100-2140, 2790-2800）
4. ACP Bridge — `/usr/lib/node_modules/openclaw/dist/acp-cli-Bi0YMmBx.js`（行 1090-1110, 1628-1650）
5. Control UI — `/usr/lib/node_modules/openclaw/dist/control-ui/assets/sessions-ecOOkBHE.js`（行 138, 175）
6. 类型定义 — `/usr/lib/node_modules/openclaw/dist/plugin-sdk/agents/fast-mode.d.ts`
7. 官方文档 — `docs/providers/openai.md`（OpenAI fast mode 章节）
8. 官方文档 — `docs/providers/anthropic.md`（Fast mode 章节）
