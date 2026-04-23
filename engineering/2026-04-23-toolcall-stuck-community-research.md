# Tool Call Stuck 问题 — 社区方案与行业实践研究

> 研究时间：2026-04-23 | 研究员：黄山 (wairesearch)
> 补充研究，配合 `2026-04-23-toolcall-stuck-solution-proposal.md` 阅读

---

## 执行摘要

Tool call stuck（工具调用卡死）是 AI Agent 领域的**普遍问题**，几乎所有主流框架都遇到过。社区的解决方案可归纳为五种模式：**超时熔断、错误回传 LLM、重试策略、状态机过期、备用路径降级**。我们提出的方案 A（Supervisor）和方案 B（Conversation State Guard）分别对应了其中的超时熔断和状态机过期模式，设计方向与行业一致。但社区实践中还有一些值得借鉴的思路，特别是 **LangGraph 的 RetryPolicy 声明式机制**、**Dify 的可视化 fail-branch** 和 **Anthropic 的 `is_error` 协议**。

---

## 1. OpenAI Assistants API：内建超时过期机制

### 机制描述

OpenAI Assistants API 是唯一在**平台层面**内建了 tool call stuck 防护的 API：

- Run 进入 `requires_action` 状态后，若 **10 分钟内**未提交 tool outputs，Run 自动过期为 `expired` 状态
- 开发者可以通过轮询 `run.status` 检测，或使用 streaming 实时感知状态变化
- 也可主动调用 `cancel_run` 提前终止，但 cancel 状态本身可能卡在 `cancelling` 数分钟

### 社区反馈

| 来源 | 关键内容 |
|------|---------|
| [OpenAI Forum: Assistant runs can only last for 10 minutes](https://community.openai.com/t/assistant-runs-can-only-last-for-10-minutes/557536) (2023-12) | 社区发现 10 分钟硬限制，对复杂多步工具调用不够 |
| [OpenAI Forum: Cancelling a run wait until expired](https://community.openai.com/t/assistant-api-cancelling-a-run-wait-until-expired-for-several-minutes/544100) (2023-12) | `cancelling` → `expired` 转换可能要等 10+ 分钟 |
| [OpenAI Forum: Run status stucks](https://community.openai.com/t/assistant-api-run-status-stucks/893324) (2024-08) | 提交 tool outputs 后 run 仍然卡在 `requires_action`，需手动重建 |
| [OpenAI Forum: Expire Time for Run Object](https://community.openai.com/t/expire-time-for-run-object-in-openai-assistant-api/588135) (2024-01) | 社区请求可配置超时时间 |

### 优劣分析

| 优点 | 缺点 |
|------|------|
| 平台级保障，开发者零配置 | 10 分钟硬编码，不可配置 |
| 状态机语义清晰（`requires_action` → `expired`） | cancel 操作本身不可靠，可能长时间卡住 |
| 自动释放资源 | 过期后无法恢复，只能重新创建 Run |

### 与我们方案的对比

OpenAI 的方案本质是**方案 B（Conversation State Guard）的平台级实现**——在协议层设置状态过期。但它不可配置、不可恢复，这正是方案 A（Supervisor）的价值所在。

---

## 2. LangChain / LangGraph：多层错误处理体系

### 机制描述

LangChain/LangGraph 提供了**三层防御**：

#### 层级 1：Tool 级 — `handle_tool_error`
```python
@tool(handle_tool_error=True)
def my_tool(query: str) -> str:
    """Tool that might fail."""
    result = risky_api_call(query)
    return result
```
- 当 `handle_tool_error=True` 时，异常被捕获并转为 `ToolMessage` 回传 LLM
- LLM 看到错误后可以自主决定重试或换策略
- 也可传入自定义函数 `handle_tool_error=my_handler`

#### 层级 2：Agent 级 — `max_execution_time`
```python
agent = initialize_agent(
    tools, llm,
    agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
    max_execution_time=60,  # 秒
    max_iterations=10
)
```
- 整个 Agent 执行的全局超时
- 超时后优雅停止，返回已有结果

#### 层级 3：Graph 级 — `RetryPolicy`（LangGraph）
```python
from langgraph.types import RetryPolicy

builder.add_node(
    "tool_node",
    tool_function,
    retry_policy=RetryPolicy(
        max_attempts=3,
        initial_interval=1.0,
        backoff_factor=2.0,
        retry_on=(TimeoutError, ConnectionError)
    )
)
```
- **声明式**重试策略，绑定到 Graph 节点
- 支持指数退避、错误类型过滤
- 重试耗尽后可通过条件边（conditional edge）路由到备用路径

### 社区反馈

| 来源 | 关键内容 |
|------|---------|
| [DEV.to: Handling Errors in LangGraph with Retry Policies](https://dev.to/aiengineering/a-beginners-guide-to-handling-errors-in-langgraph-with-retry-policies-h22) (2025-12) | LangGraph 将失败视为图生命周期的一等公民 |
| [MLPlus: LangGraph Error Handling](https://machinelearningplus.com/gen-ai/langgraph-error-handling-retries-fallback-strategies/) (2026-03) | 实战指南：try/except + RetryPolicy + fallback 三板斧 |
| [LangChain Forum: Flow after retries exhausted](https://forum.langchain.com/t/the-best-way-in-langgraph-to-control-flow-after-retries-exhausted/1574) (2025-09) | 社区讨论重试耗尽后的降级路由 |
| [GitHub: LangGraph #4927 step_timeout 问题](https://github.com/langchain-ai/langgraph/issues/4927) (2025-06) | `step_timeout` 设置引发 bug，说明超时机制仍在完善中 |

### 优劣分析

| 优点 | 缺点 |
|------|------|
| 多层防御，可细粒度控制 | 配置复杂度高 |
| `RetryPolicy` 声明式，与业务逻辑解耦 | `step_timeout` 实现有 bug（issue #4927） |
| 错误回传 LLM，利用 LLM 自修复能力 | LLM 自修复不可靠，可能重复同样错误 |
| 可通过条件边实现 fallback 路径 | 需要开发者自行设计 fallback 逻辑 |

### 💡 值得借鉴的思路

**LangGraph 的 `RetryPolicy` 声明式机制**非常优雅——在方案 A（Supervisor）中，可以考虑允许用户为每个 tool 声明独立的超时和重试策略，而不是全局统一配置。

---

## 3. AutoGen (Microsoft)：超时 + 取消令牌

### 机制描述

AutoGen 0.4+ 引入了 `CancellationToken` 模式：

```python
# 配置级别
llm_config = {
    "timeout": 120,        # LLM 调用超时
    "max_retries": 3,      # 自动重试次数
    "api_rate_limit": 10   # 速率限制
}
```

- 每个 tool 执行都接收 `CancellationToken`，可被外部取消
- MCP 工具默认 **5 秒超时**（社区反映太短，见 issue #6202）
- Agent 间通信有独立的超时机制

### 社区反馈

| 来源 | 关键内容 |
|------|---------|
| [GitHub: AutoGen #5272](https://github.com/microsoft/autogen/issues/5272) (2025-01) | 请求改进 tool error handling 文档 |
| [GitHub: AutoGen #6202](https://github.com/microsoft/autogen/issues/6202) (2025-04) | MCP 工具 5 秒默认超时太短，导致图片生成等长任务失败 |
| [GitHub: AutoGen #4994](https://github.com/microsoft/autogen/issues/4994) (2025-01) | WebSurfer Agent 超时错误，缺乏优雅降级 |

### 优劣分析

| 优点 | 缺点 |
|------|------|
| `CancellationToken` 模式优雅，支持协作式取消 | 默认超时偏保守（5s） |
| 配置简单，timeout/retries 一目了然 | 缺乏 stuck 状态的自动检测和恢复 |
| 多 Agent 场景下有 Agent 间超时 | 工具超时 ≠ tool call stuck（只解决了执行层面） |

### 💡 值得借鉴的思路

**CancellationToken 模式**——允许外部主动取消正在执行的 tool，而不仅是被动等待超时。这可以作为方案 A Supervisor 的增强：不仅设超时，还暴露取消接口。

---

## 4. Anthropic Claude API：`is_error` 协议

### 机制描述

Anthropic 在 Messages API 的 tool use 流程中定义了 **`is_error` 字段**：

```json
{
  "role": "user",
  "content": [
    {
      "type": "tool_result",
      "tool_use_id": "toolu_01A09q90qw90lq917835lqs136",
      "content": "Tool execution timed out after 30 seconds",
      "is_error": true
    }
  ]
}
```

- 当 tool 执行失败时，客户端返回 `is_error: true` 的 `tool_result`
- Claude 收到错误后可以自主决定：重试、换工具、或直接回复用户
- **关键设计**：即使 tool 失败，对话也不会 stuck——因为总是返回一个 tool_result

### 核心洞察

Anthropic 的方案从协议层面消灭了 "没有 tool_result" 的可能性：

```
正常流程：tool_use → 执行成功 → tool_result
失败流程：tool_use → 执行失败 → tool_result(is_error=true)
stuck 流程：tool_use → ???           ← Anthropic 要求客户端自行保证不发生
```

**这正是我们方案 B（Conversation State Guard）的思路**——在协议层确保每个 tool_use 都有对应的 tool_result。区别在于 Anthropic 把责任放在客户端 SDK，而方案 B 把责任放在 OpenClaw 框架层。

### 优劣分析

| 优点 | 缺点 |
|------|------|
| 协议简洁，语义清晰 | 依赖客户端正确实现 |
| LLM 可基于错误信息自修复 | 如果客户端崩溃，仍然可能 stuck |
| 不需要框架层干预 | 没有服务端超时保护 |

---

## 5. Dify：可视化错误处理 + Fail Branch

### 机制描述

Dify v0.14.0 引入了**节点级错误处理**，这是低代码平台中最完善的方案之一：

**四种错误处理策略：**

1. **Default（默认）**：节点失败 → 抛出错误 → 整个 workflow 停止
2. **Fail Branch（失败分支）**：节点失败 → 路由到备用路径 → workflow 继续
3. **Retry（重试）**：节点失败 → 按配置重试（可设重试次数和间隔）→ 重试耗尽后走 Fail Branch 或停止
4. **Default Value（默认值）**：节点失败 → 使用预设默认值 → 继续执行

**Tool Node 特有功能：**
- 主工具失败时可自动切换到备用工具
- HTTP Node 支持针对 404/500/timeout 的差异化处理

### 来源

| 来源 | 关键内容 |
|------|---------|
| [Dify Blog: Boost AI Workflow Resilience with Error Handling](https://dify.ai/blog/boost-ai-workflow-resilience-with-error-handling) (2024-12) | v0.14.0 发布，引入 fail branch |
| [Dify Docs: Predefined Error Handling Logic](https://legacy-docs.dify.ai/guides/workflow/error-handling/predefined-error-handling-logic) (2025-01) | 四种策略的官方文档 |

### 优劣分析

| 优点 | 缺点 |
|------|------|
| 可视化配置，非开发者也能用 | 仅限 workflow 模式，chat 模式不适用 |
| 四种策略覆盖全面 | 低代码平台，灵活性受限 |
| Fail Branch 是强大的降级机制 | 对 "tool call 本身无响应" 的场景覆盖不足 |
| 备用工具切换是亮点 | 需要预先配置备用方案 |

### 💡 值得借鉴的思路

**Default Value 策略**——当 tool 超时时，不仅可以报错，还可以返回一个预设的默认值让流程继续。这可以作为方案 A Supervisor 的增强选项：`onTimeout: "error" | "default_value" | "skip"`。

---

## 6. Semantic Kernel (Microsoft)：Kernel Filter + Auto Function Calling

### 机制描述

Semantic Kernel 通过 **Kernel Filter** 模式处理 function call 可靠性：

```csharp
// 注册 Function Invocation Filter
kernel.FunctionInvocationFilters.Add(new RetryFilter(maxRetries: 3));

// Auto Function Calling 配置
var settings = new OpenAIPromptExecutionSettings {
    FunctionChoiceBehavior = FunctionChoiceBehavior.Auto(
        autoInvoke: true,
        options: new FunctionChoiceBehaviorOptions {
            MaximumAutoInvokeAttempts = 5
        }
    )
};
```

- **Kernel Filter**：AOP 模式，在 function 执行前后插入横切逻辑（超时、重试、日志）
- **Auto Invoke**：内建自动调用次数限制，防止无限循环
- **CancellationToken**：与 AutoGen 类似，支持协作式取消

### 优劣分析

| 优点 | 缺点 |
|------|------|
| AOP 模式，不侵入业务逻辑 | C# 生态为主，Python/JS 支持弱 |
| `MaximumAutoInvokeAttempts` 防无限循环 | 缺乏专门的 stuck 检测 |
| Filter 可组合、可复用 | 文档不如 LangChain 丰富 |

---

## 7. MemGPT / Letta：持久化状态 + 心跳机制

### 机制描述

MemGPT/Letta 的核心特色是**有状态 Agent**，其 tool call 管理思路不同：

- Agent 状态持久化到数据库，即使进程崩溃也可恢复
- 使用 **heartbeat 机制**：Agent 定期发送心跳，如果 tool 执行期间心跳停止，系统判定卡死
- Tool 执行有 step-level 的超时控制
- 失败的 tool call 记录在 Agent memory 中，下次可以避免重复错误

### 💡 值得借鉴的思路

**持久化 + 心跳**——这是经典的分布式系统活性检测方案。对于 OpenClaw 这样的长运行 Agent，可以在方案 A Supervisor 中加入心跳检测：tool 执行期间定期报告进度，超过阈值无心跳则判定 stuck。

---

## 8. 分布式系统经典模式在 Agent 场景的应用

### Circuit Breaker（熔断器）

```
状态机：CLOSED → OPEN → HALF_OPEN → CLOSED
```

- **CLOSED**：正常调用 tool
- **OPEN**：连续 N 次失败后熔断，直接返回错误不再调用
- **HALF_OPEN**：冷却期后试探性调用一次

**Agent 适用场景**：某个外部 API（如搜索引擎）频繁超时时，熔断避免 Agent 反复尝试。LangChain 社区已有人实现了 tool-level circuit breaker。

### Saga Pattern（补偿事务）

- 多步 tool 调用中，如果步骤 3 失败，需要回滚步骤 1 和 2 的副作用
- Agent 场景：发送了邮件（步骤 1）→ 创建日历事件（步骤 2）→ 更新数据库失败（步骤 3）→ 需要撤销邮件和日历

**Agent 适用场景**：有副作用的多步 tool 编排。目前没有框架内建此机制，但 LangGraph 的 checkpoint 机制可部分实现。

### Bulkhead（隔舱）

- 为不同 tool 分配独立的资源池（线程/连接数/内存）
- 一个 tool 的问题不会影响其他 tool

**Agent 适用场景**：避免一个慢 tool 耗尽所有连接，导致其他 tool 也超时。

### Dead Letter Queue（死信队列）

- 反复失败的 tool call 放入死信队列，人工审查或异步重试
- **Agent 适用场景**：非实时场景（如批量数据处理），失败的 tool call 不立即报错而是排队等待

---

## 9. 对比总表

| 框架/API | 超时机制 | 重试策略 | 错误回传LLM | 状态过期 | 备用路径 | Stuck 专项检测 |
|----------|---------|---------|------------|---------|---------|--------------|
| **OpenAI Assistants** | ✅ 10min 硬限 | ❌ | ❌ | ✅ `expired` | ❌ | ✅ 平台级 |
| **LangChain/LangGraph** | ✅ `max_execution_time` | ✅ `RetryPolicy` | ✅ `handle_tool_error` | ❌ | ✅ 条件边 | ❌ |
| **AutoGen** | ✅ 可配置 | ✅ `max_retries` | ⚠️ 基础 | ❌ | ❌ | ❌ |
| **Anthropic Claude** | ❌ 客户端自行实现 | ❌ 客户端自行实现 | ✅ `is_error` | ❌ | ❌ | ❌ |
| **Dify** | ✅ 节点级 | ✅ 可配置 | ⚠️ 间接 | ❌ | ✅ Fail Branch | ❌ |
| **Semantic Kernel** | ✅ CancellationToken | ✅ Filter | ⚠️ 基础 | ❌ | ❌ | ❌ |
| **MemGPT/Letta** | ✅ Step-level | ⚠️ 基础 | ✅ 写入 memory | ❌ | ❌ | ✅ 心跳 |
| **我们方案 A (Supervisor)** | ✅ 可配置 | ✅ 可配置 | ✅ 注入 error result | ❌ | ❌ | ✅ 主动监控 |
| **我们方案 B (Guard)** | ❌ | ❌ | ✅ 注入 error result | ✅ 协议层 | ❌ | ✅ 状态检测 |

---

## 10. 社区方案中我们遗漏的好思路

### 思路 1：声明式 Per-Tool 策略（来自 LangGraph）

当前方案 A 倾向于全局 Supervisor 配置。建议增加 **per-tool 声明式策略**：

```yaml
tools:
  web_search:
    timeout: 30s
    retries: 2
    on_timeout: error_result
  exec:
    timeout: 300s
    retries: 0
    on_timeout: error_result
  read:
    timeout: 10s
    retries: 1
    on_timeout: default_value
    default_value: "File read timed out"
```

### 思路 2：Default Value 模式（来自 Dify）

超时不一定要报错。对于非关键 tool，可以返回一个默认值让对话继续：

```
tool call (web_search) → 超时 30s → 返回 "搜索暂不可用，基于已有知识回答"
```

### 思路 3：Circuit Breaker（来自分布式系统）

当某个 tool 连续多次超时时，自动熔断，避免后续调用浪费时间：

```
web_search 连续 3 次超时 → 熔断 5 分钟 → 期间直接返回 "搜索服务暂不可用"
```

### 思路 4：心跳/进度报告（来自 MemGPT）

对于长时间 tool（如 exec 执行编译），增加心跳机制：

```
exec(make build) → 每 10s 报告进度 → 30s 无心跳 → 判定 stuck
```

### 思路 5：CancellationToken / 协作式取消（来自 AutoGen/Semantic Kernel）

不仅被动超时，还主动取消：用户可以中途取消正在执行的 tool，Supervisor 立即注入 error result。

---

## 11. 综合建议

基于社区研究，建议将方案 A 和方案 B **合并为一个分层防御体系**：

```
Layer 1: Tool 级 — Per-tool timeout + retry + default value（类似 LangGraph RetryPolicy）
Layer 2: Conversation 级 — State Guard 检测孤儿 tool_use（方案 B）
Layer 3: System 级 — Supervisor 全局监控 + 心跳 + Circuit Breaker（方案 A 增强版）
```

这与行业趋势一致：**没有任何一个框架只用一种机制**，都是多层防御。OpenClaw 作为框架层，比 SDK 层（Anthropic）和应用层（Dify）有更大的优势来实现全面防护。

---

## 参考来源索引

1. OpenAI Community Forum - [Assistant runs 10 minute limit](https://community.openai.com/t/assistant-runs-can-only-last-for-10-minutes/557536) (2023-12)
2. OpenAI Community Forum - [Cancelling a run stuck](https://community.openai.com/t/assistant-api-cancelling-a-run-wait-until-expired-for-several-minutes/544100) (2023-12)
3. OpenAI Community Forum - [Run status stucks](https://community.openai.com/t/assistant-api-run-status-stucks/893324) (2024-08)
4. OpenAI Community Forum - [Expire time for run object](https://community.openai.com/t/expire-time-for-run-object-in-openai-assistant-api/588135) (2024-01)
5. DEV.to - [Handling Errors in LangGraph with Retry Policies](https://dev.to/aiengineering/a-beginners-guide-to-handling-errors-in-langgraph-with-retry-policies-h22) (2025-12)
6. MLPlus - [LangGraph Error Handling: Retries & Fallback Strategies](https://machinelearningplus.com/gen-ai/langgraph-error-handling-retries-fallback-strategies/) (2026-03)
7. LangChain Forum - [Flow after retries exhausted](https://forum.langchain.com/t/the-best-way-in-langgraph-to-control-flow-after-retries-exhausted/1574) (2025-09)
8. GitHub LangGraph - [step_timeout issue #4927](https://github.com/langchain-ai/langgraph/issues/4927) (2025-06)
9. GitHub AutoGen - [Tool error handling docs #5272](https://github.com/microsoft/autogen/issues/5272) (2025-01)
10. GitHub AutoGen - [MCP tool 5s timeout #6202](https://github.com/microsoft/autogen/issues/6202) (2025-04)
11. GitHub AutoGen - [WebSurfer timeout #4994](https://github.com/microsoft/autogen/issues/4994) (2025-01)
12. Anthropic Docs - [Implement tool use: is_error](https://platform.claude.com/docs/en/agents-and-tools/tool-use/implement-tool-use) (2026-03)
13. Dify Blog - [Boost AI Workflow Resilience with Error Handling](https://dify.ai/blog/boost-ai-workflow-resilience-with-error-handling) (2024-12)
14. Dify Docs - [Predefined Error Handling Logic](https://legacy-docs.dify.ai/guides/workflow/error-handling/predefined-error-handling-logic) (2025-01)
15. LangChain Docs - [Agent timeout](https://langchain-cn.readthedocs.io/en/latest/modules/agents/agent_executors/examples/max_time_limit.html)
16. LangChain Forum - [Tool exceptions with return_direct](https://forum.langchain.com/t/handling-exceptions-in-tool-with-return-direct-true/2425) (2025-12)
