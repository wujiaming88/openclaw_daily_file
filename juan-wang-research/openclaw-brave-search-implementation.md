# OpenClaw内置Brave搜索实现与技能扩展研究报告

## 一、OpenClaw内置Brave搜索的实现机制

### 1. 核心架构与文件结构
OpenClaw的Web搜索功能主要实现于以下核心文件：
- `/usr/lib/node_modules/openclaw/src/src/agents/tools/web-search.ts` - 主要实现文件
- `/usr/lib/node_modules/openclaw/src/src/config/types.tools.ts` - 配置类型定义
- `/usr/lib/node_modules/openclaw/src/src/config/config.web-search-provider.test.ts` - 测试文件

### 2. 核心实现原理

#### 2.1 多搜索提供商支持
OpenClaw内置支持5种搜索提供商：
```typescript
const SEARCH_PROVIDERS = ["brave", "perplexity", "grok", "gemini", "kimi"] as const;
```

#### 2.2 搜索工具创建流程
```typescript
export function createWebSearchTool(options?: {
  config?: OpenClawConfig;
  sandboxed?: boolean;
}): AnyAgentTool | null {
  // 1. 解析配置
  const search = resolveSearchConfig(options?.config);
  
  // 2. 检查是否启用
  if (!resolveSearchEnabled({ search, sandboxed: options?.sandboxed })) {
    return null;
  }
  
  // 3. 确定搜索提供商
  const provider = resolveSearchProvider(search);
  
  // 4. 创建工具定义
  return {
    label: "Web Search",
    name: "web_search",
    description: provider-specific description,
    parameters: createWebSearchSchema(provider),
    execute: async (_toolCallId, args) => {
      // 5. 执行搜索逻辑
      const apiKey = resolve appropriate API key based on provider
      const result = await runWebSearch({
        query,
        count,
        apiKey,
        timeoutSeconds,
        cacheTtlMs,
        provider,
        // 其他参数...
      });
      return jsonResult(result);
    },
  };
}
```

#### 2.3 Brave搜索具体实现
```typescript
async function runWebSearch(params: {
  query: string;
  count: number;
  apiKey: string;
  timeoutSeconds: number;
  cacheTtlMs: number;
  provider: (typeof SEARCH_PROVIDERS)[number];
  // 其他参数...
}): Promise<Record<string, unknown>> {
  if (params.provider === "brave") {
    const url = new URL(BRAVE_SEARCH_ENDPOINT);
    url.searchParams.set("q", params.query);
    url.searchParams.set("count", String(params.count));
    // 设置其他参数...
    
    return withTrustedWebSearchEndpoint(
      {
        url: url.toString(),
        timeoutSeconds: params.timeoutSeconds,
        init: {
          method: "GET",
          headers: {
            Accept: "application/json",
            "X-Subscription-Token": params.apiKey,
          },
        },
      },
      async (res) => {
        // 处理响应并返回结果
        const data = (await res.json()) as BraveSearchResponse;
        const results = Array.isArray(data.web?.results) ? (data.web?.results ?? []) : [];
        return results.map((entry) => {
          return {
            title: entry.title ?? "",
            url: entry.url ?? "",
            description: entry.description ?? "",
            published: entry.age || undefined,
            siteName: resolveSiteName(url) || undefined,
          };
        });
      },
    );
  }
  // 其他提供商的实现...
}
```

### 3. 配置与初始化流程

#### 3.1 配置结构定义
```typescript
export type ToolsConfig = {
  web?: {
    search?: {
      enabled?: boolean;
      provider?: "brave" | "perplexity" | "grok" | "gemini" | "kimi";
      apiKey?: string;
      maxResults?: number;
      timeoutSeconds?: number;
      cacheTtlMinutes?: number;
      brave?: {
        // Brave特定配置
      };
      // 其他提供商特定配置...
    };
    fetch?: {
      // Web Fetch配置
    };
  };
  // 其他工具配置...
};
```

#### 3.2 配置加载与解析
```typescript
function resolveSearchConfig(cfg?: OpenClawConfig): WebSearchConfig {
  const search = cfg?.tools?.web?.search;
  if (!search || typeof search !== "object") {
    return undefined;
  }
  return search as WebSearchConfig;
}

function resolveSearchProvider(search?: WebSearchConfig): (typeof SEARCH_PROVIDERS)[number] {
  // 1. 优先使用配置中指定的提供商
  const raw = search?.provider?.trim().toLowerCase();
  if (raw && SEARCH_PROVIDERS.includes(raw as any)) {
    return raw as (typeof SEARCH_PROVIDERS)[number];
  }
  
  // 2. 自动检测可用的API密钥
  if (resolveSearchApiKey(search)) {
    return "brave";
  }
  // 检测其他提供商的API密钥...
  
  // 3. 默认使用Brave
  return "brave";
}
```

## 二、内置其他技能的配置与改造方法

### 1. 技能开发的核心概念

#### 1.1 技能的基本结构
```typescript
export interface AnyAgentTool {
  label: string;
  name: string;
  description: string;
  parameters: Type.Object<any>;
  execute: (toolCallId: string, args: Record<string, unknown>) => Promise<JsonResult>;
}
```

#### 1.2 技能的执行流程
1. **工具注册** - 技能通过`createWebSearchTool`等函数创建并注册
2. **参数验证** - 使用TypeBox定义的schema验证输入参数
3. **执行逻辑** - 执行具体的业务逻辑
4. **结果返回** - 返回JSON格式的结果

### 2. 开发新技能的步骤

#### 2.1 步骤1：创建技能实现文件
在`/usr/lib/node_modules/openclaw/src/src/agents/tools/`目录下创建新的技能文件，例如`my-skill.ts`

#### 2.2 步骤2：实现技能逻辑
```typescript
import { Type } from "@sinclair/typebox";
import type { OpenClawConfig } from "../../config/config.js";
import type { AnyAgentTool } from "./common.js";
import { jsonResult, readNumberParam, readStringArrayParam, readStringParam } from "./common.js";

export function createMySkillTool(options?: {
  config?: OpenClawConfig;
}): AnyAgentTool | null {
  return {
    label: "My Skill",
    name: "my_skill",
    description: "This is my custom skill description.",
    parameters: Type.Object({
      input: Type.String({ description: "Input parameter for my skill." }),
      option: Type.Optional(Type.Boolean({ description: "Optional boolean parameter." })),
    }),
    execute: async (_toolCallId, args) => {
      const input = readStringParam(args, "input", { required: true });
      const option = args.option as boolean ?? false;
      
      // 执行你的业务逻辑
      const result = {
        input: input,
        option: option,
        message: "Skill executed successfully!",
        timestamp: new Date().toISOString(),
      };
      
      return jsonResult(result);
    },
  };
}
```

#### 2.3 步骤3：注册技能
在适当的位置注册你的技能，例如在`/usr/lib/node_modules/openclaw/src/src/agents/openclaw-tools.ts`中：

```typescript
import { createMySkillTool } from "./tools/my-skill.js";

// 在agent初始化时注册技能
const mySkillTool = createMySkillTool({ config });
if (mySkillTool) {
  agent.tools.push(mySkillTool);
}
```

#### 2.4 步骤4：配置技能
在`/usr/lib/node_modules/openclaw/src/src/config/types.tools.ts`中添加配置类型定义：

```typescript
export type ToolsConfig = {
  // 现有配置...
  mySkill?: {
    enabled?: boolean;
    // 其他配置参数...
  };
};
```

### 3. 技能扩展的高级技巧

#### 3.1 配置驱动的技能
```typescript
export function createConfigurableSkillTool(options?: {
  config?: OpenClawConfig;
}): AnyAgentTool | null {
  const skillConfig = options?.config?.tools?.mySkill;
  
  // 根据配置决定是否启用技能
  if (skillConfig?.enabled === false) {
    return null;
  }
  
  return {
    label: "Configurable Skill",
    name: "configurable_skill",
    description: "This skill can be configured via config file.",
    parameters: Type.Object({
      // 参数定义...
    }),
    execute: async (_toolCallId, args) => {
      // 使用配置中的参数
      const apiKey = skillConfig?.apiKey;
      const timeout = skillConfig?.timeoutSeconds ?? 30;
      
      // 执行逻辑...
      
      return jsonResult(result);
    },
  };
}
```

#### 3.2 缓存机制实现
```typescript
import { CacheEntry, DEFAULT_CACHE_TTL_MINUTES, readCache, writeCache } from "./web-shared.js";

const SKILL_CACHE = new Map<string, CacheEntry<Record<string, unknown>>>();

async function runCachedSkill(params: {
  input: string;
  cacheTtlMs: number;
}): Promise<Record<string, unknown>> {
  const cacheKey = `my-skill:${params.input}`;
  const cached = readCache(SKILL_CACHE, cacheKey);
  
  if (cached) {
    return { ...cached.value, cached: true };
  }
  
  // 执行实际的技能逻辑
  const result = {
    input: params.input,
    result: "Skill executed result",
    timestamp: new Date().toISOString(),
  };
  
  // 缓存结果
  writeCache(SKILL_CACHE, cacheKey, result, params.cacheTtlMs);
  
  return result;
}
```

#### 3.3 错误处理与日志
```typescript
import { logVerbose } from "../../globals.js";

async function runSkillWithErrorHandling(params: {
  input: string;
}): Promise<Record<string, unknown>> {
  try {
    logVerbose(`Executing my skill with input: ${params.input}`);
    
    // 执行技能逻辑
    const result = await runSkillLogic(params.input);
    
    logVerbose(`Skill executed successfully for input: ${params.input}`);
    return result;
  } catch (error) {
    logVerbose(`Skill execution failed for input: ${params.input}, error: ${error}`);
    
    // 返回错误结果
    return {
      error: "skill_execution_failed",
      message: `Failed to execute skill: ${error.message}`,
      input: params.input,
    };
  }
}
```

## 三、总结与建议

### 1. OpenClaw内置Brave搜索的实现特点
- **多提供商支持**：内置支持5种主流搜索提供商
- **配置驱动**：通过配置文件灵活切换搜索提供商
- **缓存机制**：实现了搜索结果缓存，提高性能
- **参数验证**：使用TypeBox进行严格的参数验证
- **错误处理**：完善的错误处理和日志记录

### 2. 开发新技能的最佳实践
- **模块化设计**：将技能实现为独立的模块
- **配置驱动**：支持通过配置文件自定义技能行为
- **缓存优化**：对于重复请求使用缓存机制
- **错误处理**：完善的错误处理和日志记录
- **测试覆盖**：编写全面的单元测试

### 3. 未来改进建议
- **插件化架构**：将技能实现为可插拔的插件
- **市场集成**：建立技能市场，方便用户分享和安装技能
- **性能监控**：添加技能性能监控和分析功能
- **权限控制**：为不同技能添加细粒度的权限控制

通过以上研究，我们深入了解了OpenClaw内置Brave搜索的实现机制，并掌握了开发和扩展新技能的方法。这些知识将帮助我们更好地定制和扩展OpenClaw的功能，满足不同用户的需求.