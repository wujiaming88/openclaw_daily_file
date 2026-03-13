# OpenClaw v2026.3.12 Fast Mode 实现深度研究报告

> 研究员：黄山 (wairesearch)
> 日期：2026-03-13
> 版本：OpenClaw 2026.3.12 (6472949)
> 来源：https://github.com/openclaw/openclaw/releases/tag/v2026.3.12

---

## 执行摘要

Fast Mode 是 OpenClaw v2026.3.12 引入的**会话级低延迟模式**。通过统一的 `/fast` 指令，针对不同 Provider 自动注入低延迟优化参数。当前原生支持 OpenAI（GPT-5.4 系列）和 Anthropic（Claude 系列）两个 Provider。

核心设计采用 **Wrapper 洋葱模型**——在模型流式调用链上动态包裹 payload 修改层，不侵入核心传输逻辑，实现了良好的解耦与可扩展性。

---

## 一、架构原理

### 1.1 整体流程

```
用户请求
  → resolveFastModeState()         // 解析 fast mode 状态（session > config > default）
  → createXxxFastModeWrapper()     // 包裹 streamFn（Provider 特定）
  → onPayload callback             // 拦截并修改 API payload
  → Provider API
```

### 1.2 核心源码位置

| 文件 | 内容 |
|------|------|
| `src/agents/fast-mode.ts` | 状态解析：resolveFastModeState、resolveFastModeParam |
| `src/agents/pi-embedded-runner/anthropic-stream-wrappers.ts` | Anthropic Fast Mode Wrapper |
| `src/agents/pi-embedded-runner/openai-stream-wrappers.ts` | OpenAI Fast Mode Wrapper |
| 主配置管线（Agent streamFn 组装区域） | Wrapper 注册与组装顺序 |

> 注：实际发布为编译后的 JS bundle（`dist/config-CmS8VEM4.js`），以上为源码推断路径。

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

`normalizeFastMode()` 接受多种输入格式：

| 输入 | 归一化结果 |
|------|-----------|
| `true`, `"on"`, `"yes"`, `"1"`, `"enable"`, `"enabled"`, `"fast"` | `true` |
| `false`, `"off"`, `"no"`, `"0"`, `"disable"`, `"disabled"`, `"normal"` | `false` |
| 其他 | `undefined`（忽略） |

---

## 三、触发入口

Fast Mode 有 4 个触发入口，最终都汇入同一个状态解析逻辑：

### 3.1 `/fast` 命令

```
/fast          → 显示当前状态
/fast status   → 显示当前状态
/fast on       → 启用，写入 sessionEntry.fastMode = true，持久化
/fast off      → 禁用，写入 sessionEntry.fastMode = false，持久化
```

处理函数 `handleFastCommand`：
- 权限检查：仅授权发送者可操作
- 状态查询时显示来源（session / config / default）
- 切换时写入 `sessionEntry.fastMode` 并调用 `persistSessionEntry` 持久化

### 3.2 内联指令

用户在消息体中包含 `@fast on` 或 `@fast off`：

```typescript
function extractFastDirective(body) {
    const extracted = extractLevelDirective(body, ["fast"], normalizeFastMode);
    return {
        cleaned: extracted.cleaned,      // 移除指令后的消息文本
        fastMode: extracted.level,       // true | false | undefined
        hasDirective: extracted.hasDirective
    };
}
```

内联指令在消息预处理阶段提取，指令文本从消息中移除后传递给模型。

### 3.3 Config 默认值

```json5
{
  agents: {
    defaults: {
      models: {
        "openai/gpt-5.4": {
          params: { fastMode: true }
        }
      }
    }
  }
}
```

通过 `resolveConfiguredFastModeRaw` 从 config 中读取：

```typescript
function resolveConfiguredFastModeRaw(params) {
    const modelKey = `${params.provider}/${params.model}`;
    const modelConfig = params.cfg?.agents?.defaults?.models?.[modelKey];
    return modelConfig?.params?.fastMode ?? modelConfig?.params?.fast_mode;
}
```

### 3.4 Control UI / TUI

通过 UI 面板切换 session 的 fast mode，最终写入 `sessionEntry.fastMode`。

---

## 四、OpenAI Fast Mode 实现

### 4.1 Wrapper 创建

```typescript
function createOpenAIFastModeWrapper(baseStreamFn) {
    const underlying = baseStreamFn ?? streamSimple;
    return (model, context, options) => {
        // Guard: 仅限 OpenAI Responses API / Codex Responses API
        if (model.api !== "openai-responses" &&
            model.api !== "openai-codex-responses" ||
            model.provider !== "openai" &&
            model.provider !== "openai-codex")
            return underlying(model, context, options);

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

### 4.2 Payload 修改

```typescript
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
    else if (existingText && typeof existingText === "object")
        if (existingText.verbosity === undefined)
            existingText.verbosity = "low";

    // 3. 优先服务层级（仅限直连 api.openai.com）
    if (params.model.provider === "openai" &&
        params.payloadObj.service_tier === undefined &&
        isOpenAIPublicApiBaseUrl(params.model.baseUrl))
        params.payloadObj.service_tier = "priority";
}

function resolveFastModeReasoningEffort(modelId) {
    if (modelId.trim().toLowerCase().startsWith("gpt-5")) return "low";
    return "low";  // 所有模型统一 "low"
}
```

### 4.3 注入参数总结

| 参数 | 值 | 条件 | 效果 |
|------|-----|------|------|
| `reasoning.effort` | `"low"` | payload 未指定 reasoning | 减少推理步骤，加快响应 |
| `text.verbosity` | `"low"` | payload 未指定 verbosity | 减少输出冗余度 |
| `service_tier` | `"priority"` | 直连 api.openai.com 且未指定 | OpenAI Priority Tier 优先调度 |

### 4.4 Guard 条件

| 条件 | 说明 |
|------|------|
| `model.api` 必须是 `openai-responses` 或 `openai-codex-responses` | 不对 Chat Completions API 生效 |
| `model.provider` 必须是 `openai` 或 `openai-codex` | 不影响 OpenRouter 等代理 |
| `service_tier` 仅在 `isOpenAIPublicApiBaseUrl` 时注入 | 不影响自定义端点 |
| 所有参数都有 `=== undefined` 守卫 | 用户显式设置的参数不会被覆盖 |

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

| Fast Mode 状态 | `service_tier` 值 | 效果 |
|----------------|-------------------|------|
| on | `"auto"` | 允许使用 Priority Tier（如果账户有容量） |
| off | `"standard_only"` | 仅使用标准层 |

### 5.3 Guard 条件

| 条件 | 说明 |
|------|------|
| `model.api === "anthropic-messages"` | 仅限 Anthropic Messages API |
| `model.provider === "anthropic"` | 不影响 Bedrock 等代理 |
| `isAnthropicPublicApiBaseUrl(model.baseUrl)` | 仅限直连 api.anthropic.com |
| `!isAnthropicOAuthApiKey(options?.apiKey)` | OAuth 认证（sk-ant-oat-*）排除 |

### 5.4 重要限制

- **API-key only**：Anthropic OAuth 认证不支持 fast mode tier 注入
- **直连 only**：通过代理/网关路由的请求不注入 `service_tier`
- **无保证**：`service_tier: "auto"` 在没有 Priority Tier 容量的账户上仍降级为 standard
- Anthropic 在响应的 `usage.service_tier` 中返回实际使用的层级

---

## 六、Wrapper 组装管线

在 Agent streamFn 构建管线中，各 Wrapper 的组装顺序：

```
基础 streamFn (streamSimple)
  │
  ├── Moonshot Thinking Wrapper          (条件：Moonshot 兼容 Provider)
  ├── Anthropic Tool Payload Wrapper     (条件：需要兼容性转换)
  ├── OpenRouter Wrapper                 (条件：provider === "openrouter")
  ├── Kilocode Wrapper                   (条件：provider === "kilocode")
  ├── Bedrock NoCache Wrapper            (条件：非 Anthropic Bedrock 模型)
  ├── Z.AI Tool Stream Wrapper           (条件：provider === "zai")
  ├── Google Thinking Wrapper            (条件：Google 模型)
  │
  ├── 🔥 Anthropic Fast Mode Wrapper     (条件：fastMode 配置 + anthropic provider)
  ├── 🔥 OpenAI Fast Mode Wrapper        (条件：fastMode 开启 + openai provider)
  │
  ├── OpenAI Service Tier Wrapper        (条件：显式 serviceTier 参数)
  ├── OpenAI Responses Context Mgmt      (条件：store/compaction 配置)
  └── Parallel Tool Calls Wrapper        (条件：parallel_tool_calls 参数)
```

**关键顺序关系**：Fast Mode Wrapper 先于 Service Tier Wrapper。两者都有 `=== undefined` 守卫，Fast Mode 设置的 `service_tier` 不会被后续 Wrapper 覆盖（除非用户显式指定了 `serviceTier` 参数）。

---

## 七、其他模型适配 Fast Mode 指南

### 7.1 场景分类

| 场景 | 需要做什么 |
|------|-----------|
| **兼容 OpenAI Responses API 的模型**（通过 `openai/*` provider 路由） | 无需改代码，直接配置 `params.fastMode: true` |
| **新 Provider 有自己的快速 API**（如 Google Priority Tier、DeepSeek 加速模式） | 需新增 Provider 特定的 Wrapper |
| **本地模型**（Ollama、vLLM） | 可通过参数调优模拟，但无 service tier 概念 |

### 7.2 无需改代码：利用现有 Config Params

如果模型通过 OpenAI 兼容的 Responses API 调用：

```json5
{
  agents: {
    defaults: {
      models: {
        "openai/your-custom-model": {
          params: { fastMode: true }
        }
      }
    }
  }
}
```

### 7.3 需要改代码：新增 Provider Wrapper

#### 步骤 1：创建 Provider 特定的 Wrapper

```typescript
// 参照 createAnthropicFastModeWrapper / createOpenAIFastModeWrapper 模式
function createNewProviderFastModeWrapper(
    baseStreamFn: StreamFn,
    enabled: boolean
): StreamFn {
    const underlying = baseStreamFn ?? streamSimple;
    return (model, context, options) => {
        // Guard: 只对目标 provider 生效
        if (model.provider !== "new-provider" || model.api !== "target-api")
            return underlying(model, context, options);

        const originalOnPayload = options?.onPayload;
        return underlying(model, context, {
            ...options,
            onPayload: (payload) => {
                if (payload && typeof payload === "object") {
                    const payloadObj = payload as Record<string, unknown>;
                    // 注入 Provider 特定的快速模式参数
                    // ...
                }
                return originalOnPayload?.(payload, model);
            }
        });
    };
}
```

#### 步骤 2：在组装管线中注册

```typescript
// 在 Google Thinking Wrapper 之后、OpenAI Service Tier Wrapper 之前
const newProviderFastMode = resolveNewProviderFastMode(merged);
if (newProviderFastMode !== undefined) {
    log.debug(`applying NewProvider fast mode=${newProviderFastMode}`);
    agent.streamFn = createNewProviderFastModeWrapper(
        agent.streamFn,
        newProviderFastMode
    );
}
```

#### 步骤 3：复用现有基础设施

以下不需要重新实现，已自动可用：

| 基础设施 | 说明 |
|----------|------|
| `/fast on/off` 命令 | 写入 `sessionEntry.fastMode` |
| `@fast on` 内联指令 | `extractFastDirective` 解析 |
| Config 配置 | `params.fastMode` 读取 |
| `resolveFastModeState()` | 三层优先级解析 |
| Control UI / TUI 面板 | session 级切换 |

#### 步骤 4：注意事项

1. **始终使用 `=== undefined` 守卫**——不覆盖用户显式设置的参数
2. **限制注入范围**——仅在直连公共 API 时注入，代理/网关路由跳过
3. **Guard 条件要严格**——检查 `model.api`、`model.provider`、`model.baseUrl`

### 7.4 各 Provider 适配参数参考

| Provider | 建议注入的参数 | 备注 |
|----------|---------------|------|
| **Google Gemini** | `generationConfig.responseModalities` 限制 / `thinkingConfig.thinkingBudget` 降低 | Google 无 service_tier 概念，需通过参数间接控制 |
| **DeepSeek** | 关闭或降低 `reasoning_effort` / 限制 `max_tokens` | DeepSeek R1 有 thinking 控制能力 |
| **AWS Bedrock** | `inferenceConfig` 调优 | AWS 无 priority tier，只能通过推理参数优化 |
| **OpenRouter** | 透传底层 Provider 的 fast mode 参数 / 自定义 header | 取决于 OpenRouter 是否暴露快速通道 |
| **Ollama / vLLM** | 降低 `num_predict` / 调整 `temperature` / `top_k` | 纯本地推理，无 tier 概念，参数调优效果有限 |

---

## 八、设计评价

### 8.1 优势

| 方面 | 评价 |
|------|------|
| **Wrapper 洋葱模型** | ✅ 优秀。解耦、可组合、不侵入核心流式传输逻辑 |
| **三层状态优先级** | ✅ 清晰。session > config > default，语义明确 |
| **Guard 条件** | ✅ 严谨。只在直连公共 API 时注入，避免代理场景下的意外行为 |
| **Provider 隔离** | ✅ 各 Provider 独立 wrapper，互不干扰 |
| **不覆盖原则** | ✅ 所有参数注入都有 `=== undefined` 守卫，尊重用户显式配置 |
| **统一入口** | ✅ `/fast` 命令、内联指令、Config、UI 四个入口汇入同一状态逻辑 |

### 8.2 不足与改进建议

| 方面 | 现状 | 建议 |
|------|------|------|
| **可扩展性** | 新 Provider 需手动添加 wrapper + 注册到管线 | 抽象 `ProviderFastModeAdapter` 接口，让 Provider Plugin 自行声明 fast mode 参数映射 |
| **参数固定** | OpenAI 的 `reasoning.effort` 硬编码为 `"low"`，无法调级 | 引入 fast mode 级别（如 fast/faster/fastest），映射不同参数组合 |
| **反馈不足** | 用户无法知道 fast mode 是否真正命中了 priority tier | 在 `/status` 或响应中展示实际使用的 service_tier |
| **文档** | 各 Provider 的 fast mode 行为分散在各自文档中 | 增加统一的 fast mode 对比文档 |

---

## 九、参考来源

1. OpenClaw v2026.3.12 Release Notes — https://github.com/openclaw/openclaw/releases/tag/v2026.3.12
2. 本地源码分析 — `/usr/lib/node_modules/openclaw/dist/config-CmS8VEM4.js`
3. 类型定义 — `/usr/lib/node_modules/openclaw/dist/plugin-sdk/agents/fast-mode.d.ts`
4. 官方文档 — `docs/providers/openai.md` (OpenAI fast mode 章节)
5. 官方文档 — `docs/providers/anthropic.md` (Fast mode 章节)
