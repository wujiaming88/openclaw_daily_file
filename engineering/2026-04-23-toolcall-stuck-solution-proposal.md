# Tool Call 无 Tool Result 导致 Session Stuck：解决方案提案

> **作者**：小帅（Team Commander）  
> **日期**：2026-04-23  
> **状态**：Proposal  
> **优先级**：P0（影响所有用户的核心可靠性问题）

---

## 1. 问题定义

### 1.1 现象

Session 在 LLM 发出 `tool_call` 后永久卡死，无法接收新消息，用户只能手动 `/kill` 或 `/reset`。

### 1.2 协议约束

LLM 对话协议有一个**不可违反的约束**：

```
每个 tool_call 必须有且仅有一个对应的 tool_result。
缺少 tool_result 时，对话状态非法，LLM 无法继续推理。
```

这意味着：一旦 tool_result 丢失，session **在协议层面就已经进入了不可恢复状态**（除非外部介入修复）。

### 1.3 丢失 tool_result 的 5 种根因

| # | 根因 | 触发条件 | 当前是否有防护 |
|---|------|---------|-------------|
| R1 | 工具进程崩溃/被 OOM kill | 大文件处理、内存不足、段错误 | ❌ 无 |
| R2 | 工具执行永不返回 | 网络请求挂起、死循环、外部 API 无响应 | ❌ 无 |
| R3 | Gateway 在工具执行期间重启 | 手动重启、崩溃恢复、OOM | ❌ 无 |
| R4 | Sandbox 超时但结果未回传 | 沙箱杀进程后 Gateway 未收到通知 | ❌ 无 |
| R5 | 工具调用格式错误导致 executor 静默失败 | LLM 生成非法参数、JSON 解析失败 | 部分（有参数校验，但不覆盖所有情况） |

### 1.4 影响面评估

- **影响范围**：所有使用工具的 session（即 99%+ 的实际使用场景）
- **用户体验**：session 卡死后只能手动干预，新消息被丢弃或排队
- **数据风险**：工具可能已执行成功（如文件写入、API 调用），但 session 不知道结果，可能导致重复执行
- **连锁反应**：父 session 等待子 session 的 tool result → 父子同时卡死

---

## 2. 解决目标

### 2.1 核心不变量

> **每个 tool_call 在有限时间内必定收到一个 tool_result（真实的或合成的）。**

只要这个不变量成立，tool call 导致的 stuck **在数学上不可能发生**。

### 2.2 验收标准

| # | 标准 | 优先级 |
|---|------|--------|
| A1 | 任何工具执行失败/超时后，session 能在 `timeout + 30s` 内自动恢复 | P0 |
| A2 | Gateway 重启后，所有中断的 tool call 能自动恢复 | P0 |
| A3 | 合成的 tool_result 包含足够信息让 LLM 自主决策下一步 | P0 |
| A4 | 不影响正常工具执行的性能（< 5ms 额外开销） | P1 |
| A5 | 支持按工具类型配置不同的超时和重试策略 | P1 |
| A6 | 提供可观测性（metrics/logs），便于排查和调优 | P2 |

---

## 3. 方案 A：Tool Execution Supervisor（主动预防型）

### 3.1 核心思路

在**工具执行层**包一层 Supervisor，每个工具调用都在受控环境中执行，Supervisor **保证一定返回结果**。

```
当前：
  Gateway → ToolExecutor.run(call) → [可能永不返回]

方案 A：
  Gateway → ToolSupervisor.run(call) → [保证返回]
                 │
                 ├── 启动子进程/Promise 执行工具
                 ├── 启动超时计时器
                 ├── 监听进程退出信号
                 │
                 ├── 正常完成 → 返回真实 result
                 ├── 超时 → kill 进程 → 返回合成 error result
                 ├── 进程崩溃 → 捕获 → 返回合成 error result
                 └── 异常 → catch → 返回合成 error result
```

### 3.2 架构设计

```
┌─────────────────────────────────────────────────────┐
│                    Gateway                           │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │            Tool Supervisor                    │   │
│  │                                               │   │
│  │  ┌─────────────┐  ┌──────────────────────┐   │   │
│  │  │ Timeout Mgr  │  │  Tool Config Registry │   │   │
│  │  │              │  │                       │   │   │
│  │  │ exec: 600s   │  │  exec: {timeout: 600, │   │   │
│  │  │ read: 30s    │  │    retry: false,      │   │   │
│  │  │ web_*: 120s  │  │    killSignal: TERM}  │   │   │
│  │  │ default: 300s│  │  read: {timeout: 30,  │   │   │
│  │  └─────────────┘  │    retry: true}        │   │   │
│  │                    └──────────────────────┘   │   │
│  │                                               │   │
│  │  execute(toolCall):                           │   │
│  │    1. 注册到 pending map                       │   │
│  │    2. 启动执行 + 启动超时计时器                   │   │
│  │    3. race(执行完成, 超时到期, 进程崩溃)           │   │
│  │    4. 清理 pending map                         │   │
│  │    5. 返回 result（真实 or 合成）                 │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

### 3.3 伪代码实现

```javascript
class ToolSupervisor {
  constructor(config) {
    this.config = config;         // 工具超时配置
    this.pending = new Map();     // 正在执行的工具调用
    this.metrics = new Metrics(); // 可观测性
  }

  async execute(session, toolCall) {
    const toolConfig = this.config.getToolConfig(toolCall.name);
    const timeout = toolConfig.timeout ?? 300_000; // 默认 300s
    const startTime = Date.now();

    // 1. 注册 pending
    this.pending.set(toolCall.id, {
      sessionId: session.id,
      toolName: toolCall.name,
      startedAt: startTime,
      timeout
    });

    try {
      // 2. 带超时执行
      const result = await Promise.race([
        this._executeToolCall(session, toolCall),
        this._createTimeout(toolCall, timeout)
      ]);

      // 3. 记录指标
      this.metrics.recordSuccess(toolCall.name, Date.now() - startTime);
      return result;

    } catch (error) {
      // 4. 任何异常 → 合成 error result
      this.metrics.recordFailure(toolCall.name, error.type);

      // 可选重试（仅幂等工具）
      if (toolConfig.retry && error.type === 'timeout' && !this._hasRetried(toolCall)) {
        return this._retryOnce(session, toolCall);
      }

      return this._synthesizeErrorResult(toolCall, error);

    } finally {
      // 5. 清理 pending
      this.pending.delete(toolCall.id);
    }
  }

  _createTimeout(toolCall, timeoutMs) {
    return new Promise((_, reject) => {
      setTimeout(() => {
        reject({
          type: 'timeout',
          message: `Tool "${toolCall.name}" exceeded ${timeoutMs/1000}s timeout`,
          toolCallId: toolCall.id
        });
      }, timeoutMs);
    });
  }

  _synthesizeErrorResult(toolCall, error) {
    return {
      role: 'tool',
      tool_call_id: toolCall.id,
      content: [
        `⚠️ TOOL EXECUTION FAILED`,
        `Tool: ${toolCall.name}`,
        `Error: ${error.message}`,
        `Type: ${error.type}`,
        ``,
        `The tool did not return a result. Possible causes:`,
        `- The operation timed out`,
        `- The process crashed unexpectedly`,
        `- A system restart interrupted execution`,
        ``,
        `Suggested actions:`,
        `1. Inform the user about the failure`,
        `2. Retry with different parameters if appropriate`,
        `3. Use an alternative approach`
      ].join('\n'),
      is_error: true
    };
  }
}
```

### 3.4 优势

| 优势 | 说明 |
|------|------|
| **主动预防** | 在工具执行层就保证返回，不依赖事后检测 |
| **延迟最小** | stuck 时间 = 配置的超时时间，不多一秒 |
| **语义清晰** | 调用方（Gateway）不需要关心超时逻辑，Supervisor 全包 |
| **可配置** | 每个工具独立配置超时、重试、kill 信号 |
| **可观测** | 集中式 metrics 采集点 |

### 3.5 劣势

| 劣势 | 说明 | 缓解方案 |
|------|------|---------|
| **改动集中在工具执行热路径** | 每次工具调用都经过 Supervisor | 确保开销 < 5ms（仅 Map 操作 + 计时器） |
| **不覆盖 Gateway 重启场景** | Supervisor 是内存态，Gateway 重启后 pending 丢失 | 需要配合启动恢复扫描（见混合方案） |
| **超时配置需调优** | 太短误杀正常长任务，太长恢复慢 | 提供合理默认值 + 按工具可配 |
| **重试的幂等性判断** | 哪些工具可安全重试需要标注 | 工具注册时声明 `idempotent: true/false` |
| **kill 不一定干净** | 子进程可能有僵尸进程 | SIGTERM → 等待 5s → SIGKILL 两阶段 kill |

### 3.6 改动影响面

| 模块 | 改动程度 | 说明 |
|------|---------|------|
| **ToolExecutor / tool dispatch** | 🔴 中等 | 核心改动点：在现有执行逻辑外包 Supervisor |
| **工具配置系统** | 🟡 小 | 新增 timeout/retry/idempotent 配置字段 |
| **Session 对话管理** | 🟢 无 | 不需要改动，Supervisor 返回的合成 result 格式与真实 result 一致 |
| **LLM 调用层** | 🟢 无 | 无感知 |
| **插件系统** | 🟡 小 | 插件工具也经过 Supervisor，需确认兼容性 |
| **现有工具** | 🟢 无 | 不需要修改任何现有工具代码 |

---

## 4. 方案 B：Conversation State Guard（协议层防御型）

### 4.1 核心思路

不在工具执行层做改动，而是在**对话协议层**加一个 Guard：在每次需要调用 LLM 之前、session 加载时、session 恢复时，**校验对话状态的合法性**，发现孤立的 tool_call 就自动注入合成 result。

```
当前：
  对话历史 → 直接发给 LLM
            （如果最后是孤立 tool_call → LLM 收到非法输入 → 报错/卡死）

方案 B：
  对话历史 → ConversationGuard.validate() → 修复后发给 LLM
                    │
                    ├── 检查每个 tool_call 是否有匹配的 tool_result
                    ├── 孤立的 → 注入合成 error result
                    ├── 记录修复日志
                    └── 返回合法的对话历史
```

### 4.2 架构设计

```
┌─────────────────────────────────────────────────────────┐
│                      Gateway                             │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │              Conversation State Guard               │ │
│  │                                                     │ │
│  │  触发点 1: 每次调用 LLM 前                            │ │
│  │    → validate(messages) → fix orphans → send to LLM │ │
│  │                                                     │ │
│  │  触发点 2: Session 加载/恢复时                         │ │
│  │    → validate(transcript) → fix orphans → ready     │ │
│  │                                                     │ │
│  │  触发点 3: Gateway 启动时全量扫描                      │ │
│  │    → for each session: validate → fix → mark clean  │ │
│  │                                                     │ │
│  │  触发点 4: 定时巡检（可选，每 60s）                     │ │
│  │    → scan active sessions → detect orphans → fix    │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### 4.3 伪代码实现

```javascript
class ConversationStateGuard {
  /**
   * 校验对话历史，修复孤立的 tool_call
   * @returns 修复后的合法对话历史
   */
  validate(messages) {
    const toolCallIds = new Set();
    const toolResultIds = new Set();
    const orphanedCalls = [];

    // 1. 收集所有 tool_call 和 tool_result 的 ID
    for (const msg of messages) {
      if (msg.role === 'assistant' && msg.tool_calls) {
        for (const tc of msg.tool_calls) {
          toolCallIds.add(tc.id);
        }
      }
      if (msg.role === 'tool') {
        toolResultIds.add(msg.tool_call_id);
      }
    }

    // 2. 找出孤立的 tool_call（有 call 无 result）
    for (const callId of toolCallIds) {
      if (!toolResultIds.has(callId)) {
        orphanedCalls.push(callId);
      }
    }

    // 3. 如果没有孤立的，原样返回
    if (orphanedCalls.length === 0) {
      return { messages, fixed: false, orphanCount: 0 };
    }

    // 4. 注入合成 result 修复
    const fixedMessages = [...messages];
    for (const callId of orphanedCalls) {
      // 找到对应的 tool_call 信息
      const callInfo = this._findToolCall(messages, callId);

      // 在对话历史中正确位置插入合成 result
      const insertIndex = this._findInsertPosition(fixedMessages, callId);
      fixedMessages.splice(insertIndex, 0, {
        role: 'tool',
        tool_call_id: callId,
        content: this._buildRecoveryMessage(callInfo),
        is_error: true,
        _synthetic: true,  // 标记为合成的，便于审计
        _recovered_at: new Date().toISOString()
      });

      logger.warn(`[ConversationGuard] Fixed orphaned tool_call: ${callId} (${callInfo?.name})`);
    }

    return {
      messages: fixedMessages,
      fixed: true,
      orphanCount: orphanedCalls.length
    };
  }

  /**
   * Gateway 启动时全量扫描
   */
  async onGatewayStart(sessions) {
    let totalFixed = 0;
    for (const session of sessions) {
      const transcript = await session.loadTranscript();
      const { messages, fixed, orphanCount } = this.validate(transcript);
      if (fixed) {
        await session.updateTranscript(messages);
        totalFixed += orphanCount;
        logger.info(`[ConversationGuard] Session ${session.id}: fixed ${orphanCount} orphaned tool_calls`);
      }
    }
    logger.info(`[ConversationGuard] Startup scan complete: fixed ${totalFixed} orphaned tool_calls`);
  }

  _buildRecoveryMessage(callInfo) {
    return [
      `⚠️ TOOL RESULT RECOVERED`,
      `Tool: ${callInfo?.name ?? 'unknown'}`,
      `Status: No result was received (execution may have been interrupted)`,
      ``,
      `This tool call did not produce a result, likely due to:`,
      `- A system restart during execution`,
      `- The tool process crashing`,
      `- A timeout that was not properly handled`,
      ``,
      `Please decide how to proceed:`,
      `1. Retry the operation if it's safe to do so`,
      `2. Inform the user about the interruption`,
      `3. Continue with an alternative approach`
    ].join('\n');
  }
}

// === 集成点 ===

// 触发点 1: LLM 调用前
async function callLLM(session, messages) {
  const guard = new ConversationStateGuard();
  const { messages: validMessages, fixed } = guard.validate(messages);
  if (fixed) {
    await session.persistFix(validMessages); // 持久化修复
  }
  return await llm.chat(validMessages);
}

// 触发点 2: Session 恢复时
async function resumeSession(sessionId) {
  const session = await loadSession(sessionId);
  const guard = new ConversationStateGuard();
  const { messages, fixed } = guard.validate(session.transcript);
  if (fixed) {
    session.transcript = messages;
    await session.persist();
  }
  return session;
}
```

### 4.4 优势

| 优势 | 说明 |
|------|------|
| **覆盖所有场景** | 不管 tool_result 是怎么丢的，Guard 都能检测和修复 |
| **改动面极小** | 只需在 2-3 个点插入 validate 调用，不改动工具执行逻辑 |
| **向后兼容** | 不影响任何现有工具、插件、LLM 调用 |
| **自愈能力** | Gateway 重启后自动修复，无需额外的启动恢复逻辑 |
| **零运行时开销（正常情况）** | 正常情况下 validate 只是一次 O(n) 扫描，无孤立时直接返回 |

### 4.5 劣势

| 劣势 | 说明 | 缓解方案 |
|------|------|---------|
| **被动恢复** | 不能主动检测 stuck，必须等到下一个触发点 | 加定时巡检触发点（每 60s） |
| **stuck 期间 session 仍不可用** | 工具挂起期间，session 还是卡着 | 依赖外部超时（LLM API timeout 等）或用户 `/kill` |
| **不解决工具挂起本身** | 只修复"结果丢失"，不处理"还在等结果" | 需配合工具级超时 |
| **对话历史可能很长** | 大对话的 validate 扫描有开销 | O(n) 复杂度可接受；或只扫描最后 N 条 |
| **合成 result 的位置插入** | 需要准确找到插入点，否则对话顺序混乱 | 在 tool_call 所在的 assistant 消息之后立即插入 |

### 4.6 改动影响面

| 模块 | 改动程度 | 说明 |
|------|---------|------|
| **LLM 调用入口** | 🟡 小 | 在调用 LLM 前插入一行 validate |
| **Session 加载/恢复** | 🟡 小 | 在加载后插入一行 validate |
| **Gateway 启动流程** | 🟡 小 | 新增启动扫描步骤 |
| **ToolExecutor** | 🟢 无 | 完全不改动 |
| **工具配置** | 🟢 无 | 完全不改动 |
| **插件系统** | 🟢 无 | 完全不改动 |
| **对话持久化** | 🟡 小 | 修复后需要重新持久化 transcript |

---

## 5. 方案对比

### 5.1 全维度对比

| 维度 | 方案 A（Supervisor） | 方案 B（Guard） |
|------|---------------------|----------------|
| **防御策略** | 主动预防（不让 stuck 发生） | 被动修复（发生后修复） |
| **覆盖 R1（进程崩溃）** | ✅ 直接捕获 | ✅ 下次触发时修复 |
| **覆盖 R2（永不返回）** | ✅ 超时 kill | ⚠️ 需配合外部超时 |
| **覆盖 R3（Gateway 重启）** | ❌ 内存态丢失 | ✅ 启动扫描修复 |
| **覆盖 R4（Sandbox 超时）** | ✅ Supervisor 超时兜底 | ✅ 下次触发时修复 |
| **覆盖 R5（静默失败）** | ✅ catch 兜底 | ✅ 下次触发时修复 |
| **恢复延迟** | 快（= 配置的超时） | 慢（等下一个触发点） |
| **代码改动量** | 中（工具执行热路径） | 小（2-3 个插入点） |
| **风险** | 中（改热路径可能引入新 bug） | 低（只读检查 + 追加修复） |
| **运行时开销** | 每次工具调用 +Map 操作 +Timer | 每次 LLM 调用 +O(n) 扫描 |
| **可配置性** | 高（按工具配置超时/重试） | 低（统一行为） |
| **可观测性** | 高（集中式 metrics） | 中（修复日志） |

### 5.2 风险矩阵

| 风险 | 方案 A | 方案 B |
|------|--------|--------|
| 引入新的 stuck | 中（Supervisor 自身可能有 bug） | 低（只做追加，不改执行流） |
| 误杀正常长任务 | 中（超时配置不当） | 无（不做超时） |
| 数据丢失 | 低（合成 result 有明确标记） | 低（同上） |
| 性能退化 | 低（Map + Timer 开销极小） | 低（O(n) 扫描） |
| 兼容性问题 | 中（需测试所有工具类型） | 低（不改工具执行） |

---

## 6. 推荐方案：A + B 混合（分层防御）

### 6.1 为什么需要混合？

**方案 A 和方案 B 解决的是不同层面的问题**：

- 方案 A 解决"工具执行过程中的超时和崩溃"（**预防**）
- 方案 B 解决"无论什么原因导致的 tool_result 丢失"（**兜底**）

单独用任何一个都有盲区：
- 只有 A：Gateway 重启场景不覆盖
- 只有 B：工具挂起期间 session 仍然不可用

混合使用 = **两层安全网，任何一层失效，另一层兜底**。

### 6.2 混合架构

```
┌─────────────────────────────────────────────────────┐
│                    Session Turn                      │
│                                                      │
│  User Message                                        │
│       │                                              │
│       ▼                                              │
│  ┌─────────────────────────────────────────────┐    │
│  │ Layer 2: Conversation State Guard (方案 B)   │    │
│  │   校验对话状态 → 修复孤立 tool_call            │    │
│  └─────────────────────────┬───────────────────┘    │
│                            ▼                         │
│  ┌─────────────────────────────────────────────┐    │
│  │           LLM Inference                      │    │
│  │   → 生成 tool_call                           │    │
│  └─────────────────────────┬───────────────────┘    │
│                            ▼                         │
│  ┌─────────────────────────────────────────────┐    │
│  │ Layer 1: Tool Supervisor (方案 A)             │    │
│  │   执行工具 → 超时保护 → 保证返回 result          │    │
│  └─────────────────────────┬───────────────────┘    │
│                            ▼                         │
│  Tool Result → 继续对话                               │
│                                                      │
│  ═══════════════════════════════════════════════     │
│  Layer 0: Gateway 启动扫描 (方案 B 的一部分)           │
│    → 扫描所有 session → 修复中断的 tool_call           │
└─────────────────────────────────────────────────────┘
```

### 6.3 分阶段实施

考虑到风险和收益，建议分三个阶段：

#### Phase 1（1-2 周）：方案 B 先行 — 低风险高覆盖

**改动内容**：
1. 实现 `ConversationStateGuard.validate()`
2. 在 LLM 调用前插入校验
3. 在 Session 加载/恢复时插入校验
4. 在 Gateway 启动时全量扫描

**收益**：覆盖所有 5 种根因的"事后恢复"，改动最小，风险最低。

**测试要点**：
- 手动构造孤立 tool_call 的 transcript → 验证自动修复
- 模拟 Gateway 重启 → 验证启动扫描
- 大对话历史（10k+ messages）→ 验证性能

#### Phase 2（2-4 周）：方案 A 补充 — 主动预防

**改动内容**：
1. 实现 `ToolSupervisor`
2. 集成到工具执行路径
3. 按工具类型配置超时
4. 添加 metrics 采集

**收益**：主动预防 stuck，将恢复时间从"等下一个触发点"缩短到"配置的超时时间"。

**测试要点**：
- 模拟工具超时 → 验证 Supervisor 超时 kill + 合成 result
- 模拟工具崩溃 → 验证异常捕获
- 长时间运行工具（如大文件处理）→ 验证不被误杀
- 压测：100 并发工具调用 → 验证性能

#### Phase 3（可选增强）：高级特性

| 特性 | 说明 | 优先级 |
|------|------|--------|
| 心跳机制 | 长任务定期报告 "alive"，区分"在跑"和"卡了" | P2 |
| 熔断器 | 连续失败 N 次 → 临时禁用该工具 | P2 |
| 幂等重试 | 标记为幂等的工具自动重试一次 | P2 |
| 定时巡检 | 每 60s 主动扫描 active session | P2 |
| 指标看板 | 工具成功率/延迟/超时率可视化 | P3 |

### 6.4 混合方案改动总影响面

| 模块 | Phase 1 | Phase 2 | 总影响 |
|------|---------|---------|--------|
| LLM 调用入口 | 🟡 +1行 validate | 🟢 无 | 🟡 小 |
| Session 加载 | 🟡 +1行 validate | 🟢 无 | 🟡 小 |
| Gateway 启动 | 🟡 +扫描逻辑 | 🟢 无 | 🟡 小 |
| ToolExecutor | 🟢 无 | 🔴 包 Supervisor | 🔴 中 |
| 工具配置 | 🟢 无 | 🟡 +timeout 字段 | 🟡 小 |
| 对话持久化 | 🟡 修复后重存 | 🟢 无 | 🟡 小 |
| 插件系统 | 🟢 无 | 🟡 需兼容测试 | 🟡 小 |
| 新增代码量 | ~200 行 | ~400 行 | ~600 行 |

---

## 7. 边界场景处理

### 7.1 并行 tool_call

LLM 可能一次发出多个 tool_call，部分成功部分失败：

```
assistant: tool_call[A], tool_call[B], tool_call[C]
tool_result[A]: 成功
tool_result[B]: ??? (丢失)
tool_result[C]: 成功
```

**处理方式**：Guard 只为丢失的 B 注入合成 result，A 和 C 保留真实结果。LLM 能看到哪些成功了哪些失败了，自行决策。

### 7.2 工具已执行成功但 result 丢失

最棘手的场景：工具实际上成功执行了（比如文件已写入、API 已调用），但 result 没返回。

**处理方式**：合成 result 中明确标注"执行状态未知"，让 LLM 告知用户并建议验证：

```
⚠️ Tool "write" did not return a result.
The operation MAY have completed successfully.
Please verify the expected outcome before retrying,
as retrying may cause duplicate side effects.
```

### 7.3 合成 result 后 LLM 无限重试

LLM 收到错误 result 后可能立即重试同一个工具调用，如果问题未解决会形成重试循环。

**处理方式**：
- Supervisor（方案 A）记录重试次数，超过 `maxRetries` 后返回最终错误
- 可选：熔断器机制，同一工具连续失败 3 次 → 告诉 LLM "该工具暂时不可用"

### 7.4 合成 result 的持久化

合成的 result 必须持久化到 transcript，否则下次加载又会重新合成。

**处理方式**：修复后立即写盘，合成 result 带 `_synthetic: true` 标记便于审计和统计。

---

## 8. 可观测性设计

### 8.1 日志

```
[WARN] [ConversationGuard] Session main: Fixed 1 orphaned tool_call(s)
  - call_id=call_abc123, tool=exec, reason=no_matching_result
[WARN] [ToolSupervisor] Tool "web_fetch" timed out after 120s
  - session=main, call_id=call_def456
  - action=synthesize_error_result
[INFO] [ToolSupervisor] Tool "read" completed in 45ms
[ERROR] [ToolSupervisor] Tool "exec" process crashed (signal=SIGKILL)
  - session=agent:waicode, call_id=call_ghi789
```

### 8.2 指标（Metrics）

| 指标 | 类型 | 说明 |
|------|------|------|
| `tool.execution.duration` | histogram | 工具执行耗时（按工具名分桶） |
| `tool.execution.timeout` | counter | 超时次数（按工具名） |
| `tool.execution.crash` | counter | 崩溃次数（按工具名） |
| `tool.execution.success_rate` | gauge | 成功率（按工具名） |
| `guard.orphan_fixed` | counter | Guard 修复的孤立 tool_call 数 |
| `guard.startup_scan_fixed` | counter | 启动扫描修复数 |

---

## 9. 总结

| 维度 | 结论 |
|------|------|
| **根本原因** | LLM 协议要求 tool_call↔tool_result 一一对应，但 OpenClaw 没有机制保证这个不变量 |
| **解法本质** | 在协议层保证不变量：每个 tool_call 在有限时间内必得到 result |
| **推荐方案** | A + B 混合：Supervisor（主动预防）+ Guard（被动兜底），分层防御 |
| **实施策略** | Phase 1 先上 Guard（低风险），Phase 2 补 Supervisor（高收益） |
| **改动量** | ~600 行核心代码，主要新增，极少修改现有逻辑 |
| **预期效果** | tool call stuck 从"不可恢复"变为"自动恢复"，恢复时间 ≤ 配置的超时值 |

---

*本方案基于 OpenClaw 2026.4.12 版本分析。具体实现需参考 Gateway 源码确认集成点。*
