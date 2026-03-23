# OpenClaw v2026.3.22 版本深度分析报告

> **版本**: v1.0  
> **日期**: 2026-03-23  
> **作者**: 黄山 (wairesearch) · 卷王小组  
> **对比基线**: v2026.3.13  

---

## 目录

1. [版本概览](#1-版本概览)
2. [Breaking Changes 影响分析](#2-breaking-changes-影响分析)
3. [重点特性深度分析](#3-重点特性深度分析)
   - 3.1 anthropic-vertex 原生 Provider
   - 3.2 飞书插件四项更新
   - 3.3 Plugin SDK 架构重构
   - 3.4 模型生态更新
4. [安全加固](#4-安全加固)
5. [性能优化](#5-性能优化)
6. [对 SaaS 平台的影响评估](#6-对-saas-平台的影响评估)
7. [升级风险与迁移路径](#7-升级风险与迁移路径)
8. [行动建议](#8-行动建议)

---

## 1. 版本概览

### 发布统计

| 维度 | 数量 |
|------|------|
| Breaking Changes | 14 项 |
| 新特性 (Changes) | 50+ 项 |
| Bug 修复 (Fixes) | 20+ 项 |
| 涉及 PR | 80+ 个 |
| 贡献者 | 30+ 人 |

### 版本定位

这是一个**架构级大版本**，主要方向：
1. **Plugin SDK 现代化**：完成从 `openclaw/extension-api` 到 `openclaw/plugin-sdk/*` 的迁移
2. **Provider 生态扩展**：新增 anthropic-vertex、Chutes、Exa、Tavily、Firecrawl 等原生 provider/搜索工具
3. **安全加固**：Exec 沙箱、Webhook 认证、设备配对等多维度加固
4. **飞书增强**：互动卡片、ACP 会话绑定、Reasoning 流式输出

---

## 2. Breaking Changes 影响分析

### 2.1 高影响（需要立即处理）

#### Plugin SDK 重构

| 变更 | 详情 |
|------|------|
| **旧接口** | `openclaw/extension-api`、`openclaw/plugin-sdk/compat` |
| **新接口** | `openclaw/plugin-sdk/<subpath>` （100+ 细粒度子路径） |
| **移除时间** | 当前版本已弃用 + 运行时警告，下个大版本完全移除 |

**迁移要点**（来自官方迁移文档）：

```typescript
// ❌ 旧：大而全的单入口
import { createChannelReplyPipeline, createPluginRuntimeStore } from "openclaw/plugin-sdk/compat";
import { runEmbeddedPiAgent } from "openclaw/extension-api";

// ✅ 新：细粒度子路径
import { createChannelReplyPipeline } from "openclaw/plugin-sdk/channel-reply-pipeline";
import { createPluginRuntimeStore } from "openclaw/plugin-sdk/runtime-store";
// Host 侧操作改用注入的 runtime
const result = await api.runtime.agent.runEmbeddedPiAgent({ sessionId, prompt });
```

**对你的影响**：
- `openclaw-weixin` 插件当前使用 `import { ... } from "openclaw/plugin-sdk"` 和 `import type { ... } from "openclaw/plugin-sdk"` — **需要检查是否走了 compat 路径**
- 飞书插件（`@larksuite/openclaw-lark`）由官方维护，应该已经迁移

**临时抑制警告**：
```bash
OPENCLAW_SUPPRESS_PLUGIN_SDK_COMPAT_WARNING=1 openclaw gateway run
OPENCLAW_SUPPRESS_EXTENSION_API_WARNING=1 openclaw gateway run
```

#### 消息发现 API 变更

| 旧接口 | 新接口 |
|--------|--------|
| `listActions()` / `getCapabilities()` / `getToolSchema()` | `describeMessageTool(...)` |

自定义插件如果实现了消息工具发现，必须迁移到 `describeMessageTool()`。`openclaw-weixin` 的 `channel.ts` 中未直接实现这些方法（使用框架默认），**影响较低**。

#### 遗留环境变量移除

| 已移除 | 替代 |
|--------|------|
| `CLAWDBOT_*` | `OPENCLAW_*` |
| `MOLTBOT_*` | `OPENCLAW_*` |

**检查点**：CI/CD 流水线、systemd service 文件、docker-compose、.env 文件

#### 遗留状态目录移除

| 已移除 | 替代 |
|--------|------|
| `~/.moltbot` 自动检测/迁移 | 必须使用 `~/.openclaw` 或显式设置 `OPENCLAW_STATE_DIR` |

### 2.2 中影响（需要评估）

#### Chrome 扩展移除

已移除的配置项：
- `driver: "extension"`
- `browser.relayBindHost`

迁移方式：

```bash
openclaw doctor --fix  # 自动迁移到 existing-session / user
```

Docker、无头浏览器、沙箱、远程浏览器流程不受影响（继续使用 raw CDP）。

#### Exec 环境沙箱加强

新增屏蔽的环境变量：

| 被屏蔽 | 原因 |
|--------|------|
| `MAVEN_OPTS` | JVM 注入攻击 |
| `SBT_OPTS` | JVM 注入攻击 |
| `GRADLE_OPTS` | JVM 注入攻击 |
| `ANT_OPTS` | JVM 注入攻击 |
| `GLIBC_TUNABLES` | glibc 可调参数利用 |
| `DOTNET_ADDITIONAL_DEPS` | .NET 依赖劫持 |

`GRADLE_USER_HOME` 改为 override-only（用户配置的 Gradle home 仍然传递）。

**对你的影响**：如果 SaaS 平台有 Java/JVM 构建任务通过 OpenClaw 执行，需要注意这些环境变量不再传递。

#### 图片生成标准化

| 旧方式 | 新方式 |
|--------|--------|
| `nano-banana-pro` 技能包 | `agents.defaults.imageGenerationModel.primary: "google/gemini-3-pro-image-preview"` |

### 2.3 低影响（了解即可）

| 变更 | 说明 |
|------|------|
| `openclaw plugins install` 优先走 ClawHub | npm 作为 fallback |
| Discord 命令部署改为 Carbon reconcile | 减少重启时的 slash command 抖动 |
| `time` 命令在 exec allowlist 中透明化 | 已批准的 `time xxx` 绑定内部命令 |
| Voice-call webhook 预认证限制 | 64KB/5s body budget + per-IP 并发限制 |
| Matrix 插件完全重写 | 基于 matrix-js-sdk |

---

## 3. 重点特性深度分析

### 3.1 anthropic-vertex 原生 Provider 🔥

**这是对你 SaaS 平台影响最大的更新。**

#### 背景

PR #43356 由 Red Hat 的 @sallyom 提交，复用 pi-ai 的 Anthropic client 注入接口，新增 OpenClaw 侧的 provider 发现、认证、模型目录和测试。

#### 架构

**之前（需要 LiteLLM 中间层）：**

```
OpenClaw → LiteLLM Proxy → Vertex AI → Claude
               ↑ cache_control 可能丢失
```

**现在（原生直连）：**

```
OpenClaw → @anthropic-ai/vertex-sdk → Vertex AI → Claude
               ↑ SDK 原生支持 cache_control
```

#### 配置方式

**环境变量**：
```bash
# GCP 认证（Application Default Credentials）
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
# 或使用 gcloud auth application-default login

# GCP 项目和区域
export GOOGLE_CLOUD_PROJECT="your-gcp-project-id"
export GOOGLE_CLOUD_LOCATION="us-central1"  # 或 europe-west1 等
```

**openclaw.json 配置**：
**方式一：直接设置主模型**

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic-vertex/claude-sonnet-4-5"
      }
    }
  }
}
```

**方式二：Provider 级别配置**

```json
{
  "models": {
    "providers": {
      "anthropic-vertex": {
        "api": "anthropic-messages",
        "models": []
      }
    }
  }
}
```

**支持的模型**（内置目录）：
- `anthropic-vertex/claude-opus-4-5`
- `anthropic-vertex/claude-sonnet-4-5`
- `anthropic-vertex/claude-haiku-3-5`
- 更多 Claude 系列模型（带 Vertex 版本后缀如 `@20250929`）

#### 对 Prompt Caching 问题的影响

这是**关键突破**：

| 维度 | 之前（LiteLLM） | 现在（原生 anthropic-vertex） |
|------|-----------------|------------------------------|
| `resolveCacheRetention()` | 不认识 custom provider → 不注入 `cache_control` | 使用 `anthropic-messages` API → SDK 正确注入 |
| 缓存标记透传 | LiteLLM 需要额外配置 `cache_control_injection_points` | 原生 @anthropic-ai/vertex-sdk 直接支持 |
| Vertex AI 缓存模型 | 需要手动管理 `cachedContent` | SDK 自动处理前缀匹配缓存 |
| 网络跳数 | OpenClaw → LiteLLM → Vertex AI（2跳） | OpenClaw → Vertex AI（1跳） |
| 延迟 | 额外 50-200ms | 直连 |

**预期效果**：
- `resolveCacheRetention()` 能正确识别 `anthropic-vertex` 并注入 `cache_control`
- system prompt 静态部分的缓存命中率预计恢复到 **50-70%**（仍受动态段影响）
- 配合之前分析的方案二/三（拆分静态/动态 block），可达 **85-90%+**

#### 注意事项

1. **依赖是可选的**：`@anthropic-ai/vertex-sdk` 不在 OpenClaw 的 `package.json` 中，标记为 external。Bun 和 esbuild 跳过编译时解析。运行时按需 `require()`。
2. **认证方式**：使用 GCP Application Default Credentials (ADC)，和 `google-vertex`（Gemini）相同的认证机制
3. **模型 ID 格式**：支持 Vertex 特有的版本后缀（如 `claude-sonnet-4-5@20250929`）

### 3.2 飞书插件四项更新

#### 3.2.1 互动审批卡片 + 快捷操作 (#47873)

**流程：**

```
用户在飞书中看到互动卡片
  → 点击按钮
  → 触发审批/操作流程
  → 保留 callback user + conversation context
  → 路由到正确的 Agent 执行
```

**新增能力**：
- 结构化互动审批卡片（approval cards）
- 快捷操作启动器（quick-action launcher）
- 回调时保留用户身份和会话上下文
- 保留 legacy 卡片操作的向后兼容

**代码变更**：
- 新增 `feishu: add structured card actions and interactive approval flows`
- 新增 `feishu: hold inflight card dedup until completion`（卡片去重）
- 新增 `feishu: restore fire-and-forget bot menu handling`（菜单处理）

#### 3.2.2 ACP/子 Agent 会话绑定 (#46819)

**这是飞书最大的架构增强。**

**流程：**

```
飞书用户 → DM / 话题会话
  → resolveSessionBinding()
  → 绑定到 ACP 或子 Agent 会话
  → Agent 执行完成
  → 结果投递回原始飞书会话
```

**新增能力**：

| 功能 | 说明 |
|------|------|
| DM ACP 绑定 | 在私聊中启动 ACP 会话，绑定到当前用户 |
| 话题 ACP 绑定 | 在群聊话题中启动 ACP 会话，绑定到当前话题 |
| 子 Agent 会话绑定 | 子 Agent 的会话绑定到当前会话 |
| Sender-scoped 绑定 | 按发送者隔离的会话绑定（多用户场景） |
| User-ID 绑定恢复 | 从绑定中恢复用户 ID 关联 |
| 完成结果投递 | ACP/子 Agent 完成后结果投递回原始飞书会话 |

**代码提交链**（从 PR 历史追踪）：
1. `feat(feishu): add ACP session support`
2. `fix(feishu): preserve sender-scoped ACP rebinding`
3. `fix(feishu): recover sender scope from bound ACP sessions`
4. `fix(feishu): support DM ACP binding placement`
5. `feat(feishu): add current-conversation session binding`
6. `fix(feishu): avoid DM parent binding fallback`
7. `fix(feishu): require canonical topic sender ids`
8. `fix(feishu): honor sender-scoped ACP bindings`
9. `fix(feishu): allow user-id ACP DM bindings`
10. `fix(feishu): recover user-id ACP DM bindings`

**对 SaaS 平台的价值**：支持在飞书中直接运行 Codex / Claude Code 等 ACP Agent，结果回到飞书会话。

#### 3.2.3 Reasoning 流式输出到卡片 (#46029)

**流程：**

```
/reasoning stream → 开启思维链流式输出
  → Agent 思考中...
  → onReasoningStream → 卡片实时更新 blockquote
  → 思考完成
  → onReasoningEnd → 正式回复替换卡片
```

**实现方式**：
- 新增 `onReasoningStream` 和 `onReasoningEnd` 回调
- Thinking tokens 渲染为 Markdown blockquote 格式
- 与 Telegram 的 reasoning lane 行为对齐

**使用方式**：在飞书中发送 `/reasoning stream` 开启。

#### 3.2.4 身份感知卡片头部和脚注 (#29938)

- 回复和主动发送的卡片带有 Agent 身份标识
- 头部和脚注通过共享 outbound identity 路径渲染
- 用于多 Agent 场景下区分不同 Agent 的回复

#### 飞书附加修复

| 修复 | PR |
|------|-----|
| 早期 event 级去重（防止重复回复） | #43762 |
| 媒体支持和能力文档加固 | #47968 |
| 保留非 ASCII 文件名 | #33912 |

### 3.3 Plugin SDK 架构重构

#### 架构变化全景

**之前：**

```
Plugin → openclaw/plugin-sdk         （大入口，300+ exports）
Plugin → openclaw/extension-api      （host 侧直接访问）
```

**现在：**

```
Plugin → openclaw/plugin-sdk/<subpath>  （100+ 细粒度模块）
Plugin → api.runtime.*                  （注入的 runtime 对象）
```

#### 核心子路径分类

| 类别 | 子路径 | 用途 |
|------|--------|------|
| **入口** | `plugin-sdk/plugin-entry` | `definePluginEntry` |
| **Channel** | `plugin-sdk/core` | Channel 定义和构建 |
| | `plugin-sdk/channel-reply-pipeline` | 回复 + typing |
| | `plugin-sdk/channel-pairing` | DM 配对 |
| | `plugin-sdk/channel-policy` | 群组/DM 策略 |
| | `plugin-sdk/channel-actions` | 按钮/卡片 Schema |
| **Provider** | `plugin-sdk/provider-auth` | API Key 认证 |
| | `plugin-sdk/provider-models` | 模型规范化 |
| | `plugin-sdk/provider-catalog` | 目录类型 |
| **认证** | `plugin-sdk/command-auth` | 命令权限 |
| | `plugin-sdk/allow-from` | 白名单 |
| | `plugin-sdk/webhook-ingress` | Webhook 请求 |
| **运行时** | `plugin-sdk/runtime-store` | 持久化存储 |
| | `plugin-sdk/keyed-async-queue` | 有序异步队列 |
| **测试** | `plugin-sdk/testing` | 测试工具和 mock |

#### 注册 API（register()）

| 方法 | 注册内容 |
|------|---------|
| `api.registerProvider(...)` | LLM Provider |
| `api.registerChannel(...)` | 消息频道 |
| `api.registerTool(tool)` | Agent 工具 |
| `api.registerCommand(def)` | 自定义命令 |
| `api.registerHook(events, handler)` | 事件钩子 |
| `api.registerHttpRoute(params)` | HTTP 端点 |
| `api.registerGatewayMethod(name, handler)` | Gateway RPC |
| `api.registerCli(registrar)` | CLI 子命令 |
| `api.registerService(service)` | 后台服务 |
| `api.registerWebSearchProvider(...)` | 搜索引擎 |
| `api.registerContextEngine(id, factory)` | 上下文引擎 |
| `api.registerMemoryPromptSection(builder)` | Memory Prompt 段 |

### 3.4 模型生态更新

#### 新增/更新模型

| Provider | 模型 | 说明 |
|----------|------|------|
| **OpenAI** | `gpt-5.4` | 新默认模型 |
| | `gpt-5.4-mini` | 轻量版 |
| | `gpt-5.4-nano` | 超轻量版 |
| | `openai-codex/gpt-5.4` | Codex 默认 |
| **MiniMax** | `MiniMax-M2.7` | 新默认（替代 M2.5） |
| | `MiniMax-M2.7-highspeed` | Fast 模式 |
| | 补全 M2 / M2.1 系列 | 对齐 Pi SDK |
| **Anthropic** | `anthropic-vertex/*` | Vertex AI 直连 |
| **小米** | `MiMo V2 Pro`、`MiMo V2 Omni` | 新增 |
| **xAI** | Grok 目录同步 | 对齐 Pi |
| **GLM** | 4.5/4.6 系列 | 对齐 Pi |
| **Mistral** | 定价更新 | 不再显示零成本 |
| **GitHub Copilot** | 动态模型 ID | 无需代码更新即可支持新模型 |

#### 新增搜索引擎（内置插件）

| 搜索引擎 | 类型 | 工具名 |
|----------|------|--------|
| **Exa** | 神经搜索 | `exa_search` |
| **Tavily** | AI 优化搜索 | `tavily_search`、`tavily_extract` |
| **Firecrawl** | 网页抓取 | `firecrawl_search`、`firecrawl_scrape` |

---

## 4. 安全加固

### 4.1 高优先级修复

| 修复 | 影响 | CVE/PR |
|------|------|--------|
| **Windows file:// 远程路径** | 阻止通过 `file://` URL 和 UNC 路径触发 SMB 凭证泄露 | 感谢 @RacerZ-fighting |
| **Bonjour/DNS-SD 发现** | 未解析的服务端点不再影响路由或 SSH 目标选择 | 感谢 @nexrin |
| **iOS 设备配对** | Setup code 绑定到目标 node profile，拒绝越权角色请求 | 感谢 @tdjackey |
| **Nostr DM** | 解密前强制 DM 策略，添加预加密速率和大小守卫 | 感谢 @kuranikaran |
| **Synology Chat** | 回复投递绑定到稳定的 user_id，不再使用可变 username | 感谢 @nexrin |

### 4.2 Exec 环境沙箱

新增屏蔽的环境变量类别：
- **JVM 注入**：`MAVEN_OPTS`, `SBT_OPTS`, `GRADLE_OPTS`, `ANT_OPTS`
- **系统利用**：`GLIBC_TUNABLES`
- **依赖劫持**：`DOTNET_ADDITIONAL_DEPS`

### 4.3 Marketplace 安全

- 拒绝 manifest 中扩展安装范围到仓库之外的条目
- 屏蔽外部 git/GitHub 源、HTTP 归档、绝对路径

### 4.4 Webhook 安全

Voice-call webhook：
- 缺少 provider 签名头 → 拒绝请求（在读取 body 前）
- 预认证 body budget：64KB / 5s（之前 1MB / 30s）
- 每源 IP 并发限制

---

## 5. 性能优化

### 5.1 Gateway 冷启动优化

| 对比 | 说明 |
|------|------|
| **之前** | 每次启动重编译 bundled extension TypeScript → 几十秒甚至更久 |
| **现在** | 从编译后的 `dist/extensions` 加载 → 秒级启动 |

PR #47560，影响所有 WhatsApp-class 频道。

### 5.2 首消息可靠性

| 对比 | 说明 |
|------|------|
| **之前** | 启动后第一条消息 → `Unknown model: openai-codex/gpt-5.4` |
| **现在** | 启动时预热主模型 + 重试一次 provider runtime miss |

### 5.3 CLI 启动优化

- Channel add 和 root help 路径懒加载
- `openclaw configure` 不再阻塞等待频道插件加载
- 减少 RSS 内存占用

### 5.4 Agent 超时

| 对比 | 说明 |
|------|------|
| **之前** | 默认 600s → ACP 长任务频繁超时 |
| **现在** | 默认 48h → 长时间运行的 ACP 和 Agent 会话不再超时 |

---

## 6. 对 SaaS 平台的影响评估

### 6.1 直接影响（必须处理）

| 项目 | 影响 | 优先级 |
|------|------|--------|
| Plugin SDK 迁移 | `openclaw-weixin` 和自定义插件需检查导入路径 | 🔴 高 |
| 环境变量检查 | CI/CD 中是否使用 `CLAWDBOT_*` / `MOLTBOT_*` | 🔴 高 |
| `openclaw doctor --fix` | 浏览器配置迁移 | 🟡 中 |
| Exec 环境变量 | JVM 构建任务是否受影响 | 🟡 中 |

### 6.2 架构机遇（建议采用）

| 机遇 | 收益 | 优先级 |
|------|------|--------|
| **anthropic-vertex 原生 Provider** | 去掉 LiteLLM 中间层，修复缓存问题，降低延迟 | 🔴 极高 |
| 飞书 ACP 会话绑定 | 在飞书中直接运行 Codex/Claude Code | 🟡 中 |
| 飞书互动卡片 | 审批流程、快捷操作 | 🟡 中 |
| 内置搜索引擎 | 减少外部依赖 | 🟢 低 |

### 6.3 风险评估

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|---------|
| Plugin SDK 不兼容 | 中 | 高 | 先 dry-run doctor，检查 compat 警告 |
| Exec 沙箱影响构建 | 低 | 中 | 检查 JVM/Gradle 环境变量使用 |
| anthropic-vertex 首次使用问题 | 中 | 中 | 保留 LiteLLM 作为 fallback |
| 飞书插件版本不匹配 | 低 | 高 | 同步升级 OpenClaw + 飞书插件 |

---

## 7. 升级风险与迁移路径

### 7.1 升级前检查清单

```bash
# 1. 检查环境变量
env | grep -E "CLAWDBOT|MOLTBOT"
# 如有结果 → 替换为 OPENCLAW_*

# 2. 检查状态目录
ls -la ~/.moltbot 2>/dev/null
# 如存在 → 迁移到 ~/.openclaw

# 3. 检查 openclaw-weixin 导入
grep -r "extension-api\|plugin-sdk/compat" ~/.openclaw/extensions/openclaw-weixin/
# 如有结果 → 需要更新插件

# 4. 检查浏览器配置
grep -r "driver.*extension\|relayBindHost" ~/.openclaw/openclaw.json
# 如有结果 → 升级后需 openclaw doctor --fix
```

### 7.2 升级步骤

```bash
# Phase 1: 备份
bash scripts/upgrade-openclaw.sh --dry-run

# Phase 2: 升级
bash scripts/upgrade-openclaw.sh

# Phase 3: 后置检查
openclaw doctor --fix          # 迁移浏览器配置等
openclaw status --all          # 全面诊断

# Phase 4: 验证
# - 飞书消息收发
# - 微信消息收发
# - Agent 执行
# - ACP 会话
```

### 7.3 回滚方案

升级脚本已内置回滚：
- 自动备份所有配置、workspace、extensions、credentials
- 失败时自动回滚到之前版本
- 手动回滚：`npm install -g openclaw@2026.3.13`

---

## 8. 行动建议

### 立即行动（Day 1）

1. ✅ 用升级脚本执行升级（`bash scripts/upgrade-openclaw.sh`）
2. ✅ 运行 `openclaw doctor --fix`
3. ✅ 检查 Gateway 日志中的 `plugin-sdk/compat` 弃用警告

### 本周行动（Week 1）

4. 🔥 **配置 anthropic-vertex Provider 并测试**
   - 设置 GCP ADC 认证
   - 配置 `anthropic-vertex/claude-opus-4-5` 或 `claude-sonnet-4-5`
   - 对比 LiteLLM 路径的缓存命中率
5. ✅ 更新 `openclaw-weixin` 插件到最新版
6. ✅ 测试飞书互动卡片和 ACP 会话绑定

### 中期行动（Week 2-3）

7. 评估 LiteLLM 去留：
   - 如果 anthropic-vertex 原生 Provider 的缓存命中率满足要求 → 逐步淘汰 LiteLLM 中间层
   - 如果仍需 LiteLLM → 配合之前的方案二/三进一步优化
8. 更新 CI/CD 流水线中的环境变量（`CLAWDBOT_*` → `OPENCLAW_*`）
9. 评估飞书 Reasoning 流式输出对用户体验的提升

### 长期（Month 1+）

10. 将 `openclaw-weixin` 插件迁移到新 Plugin SDK 子路径导入
11. 利用新的内置搜索引擎（Exa/Tavily/Firecrawl）优化 Agent 搜索能力
12. 探索飞书互动卡片在 SaaS 平台中的审批流程应用

---

## 参考来源

| 来源 | URL |
|------|-----|
| Release Notes | https://github.com/openclaw/openclaw/releases/tag/v2026.3.22 |
| Plugin SDK 迁移指南 | https://docs.openclaw.ai/plugins/sdk-migration |
| Plugin SDK 概览 | https://docs.openclaw.ai/plugins/sdk-overview |
| anthropic-vertex Issue | https://github.com/openclaw/openclaw/issues/17277 |
| anthropic-vertex PR | https://github.com/openclaw/openclaw/pull/43356 |
| 飞书互动卡片 PR | https://github.com/openclaw/openclaw/pull/47873 |
| 飞书 ACP 绑定 PR | https://github.com/openclaw/openclaw/pull/46819 |
| 飞书 Reasoning 流式 PR | https://github.com/openclaw/openclaw/pull/46029 |

---

> **文档结束**  
> 卷王小组 · wairesearch · 2026-03-23
