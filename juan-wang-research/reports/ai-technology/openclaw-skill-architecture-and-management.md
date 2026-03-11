# OpenClaw Skill 模块架构、机制与管理深度研究报告

> 研究日期：2026-03-11
> 研究员：黄山 (wairesearch)
> 数据来源：OpenClaw 官方文档、AgentSkills 规范、ClawHub、DigitalOcean 开发者指南

---

## 执行摘要

OpenClaw 的 Skill 系统是其核心扩展机制，采用**纯 Markdown 文件**作为 Skill 定义，遵循开放的 [AgentSkills](https://agentskills.io) 规范。Skill 的本质是**教 Agent 如何使用工具的指令集**——不是工具本身，而是工具的"使用说明书"。

整个系统围绕一个简洁的设计理念：**一个 SKILL.md 文件就是一个能力**。OpenClaw 通过三层优先级加载、YAML frontmatter 门控、会话快照缓存和按需读取策略，实现了高效且灵活的 Skill 管理。

ClawHub 注册中心已有超过 **2,857 个公开 Skills**，AgentSkills 规范已被 **Claude Code、Cursor、Gemini CLI、GitHub Copilot、VS Code** 等 20+ 个 Agent 平台采纳。

---

## 一、Skill 是什么

### 1.1 本质定义

Skill 是一个包含 `SKILL.md` 文件的目录，**为 LLM 提供执行特定任务的指令和上下文**。

```
skills/weather/
├── SKILL.md              ← 核心：YAML frontmatter + Markdown 指令
├── references/           ← 可选：参考资料
│   └── api-docs.md
└── scripts/              ← 可选：辅助脚本
    └── fetch-data.sh
```

**关键区分**：
- **Skill ≠ 工具（Tool）**：工具是 OpenClaw 内置的函数接口（如 `read`、`exec`、`web_search`）；Skill 是教 Agent **如何使用这些工具** 的指令
- **Skill ≠ 插件（Plugin）**：插件是运行时代码（JS/TS），可以注册新工具、新渠道、新 Context Engine；Skill 是纯 Markdown
- **Skill = Playbook/SOP**：类似于标准操作手册，指导 Agent 在特定场景下的行为

### 1.2 SKILL.md 结构

```markdown
---
name: weather
description: "Get weather via wttr.in. Use when user asks about weather."
homepage: https://wttr.in/:help
metadata: { "openclaw": { "emoji": "🌤️", "requires": { "bins": ["curl"] } } }
---

# Weather Skill

## When to Use
✅ "What's the weather?"
✅ "Temperature in Tokyo"

## When NOT to Use
❌ Historical weather data
❌ Severe weather alerts

## Instructions
1. Use `exec` tool to run curl command...
2. Parse the output...
3. Format the response...
```

**YAML Frontmatter 字段**：

| 字段 | 必需 | 说明 |
|------|------|------|
| `name` | ✅ | Skill 标识名 |
| `description` | ✅ | 简短描述（出现在系统提示词的 Skills 列表中） |
| `homepage` | ❌ | 外部文档链接 |
| `metadata` | ❌ | 门控条件、安装信息、表情符号等 |
| `user-invocable` | ❌ | 是否作为用户斜杠命令（默认 true） |
| `disable-model-invocation` | ❌ | 是否从模型提示词中排除（默认 false） |
| `command-dispatch` | ❌ | 设为 `tool` 时斜杠命令直接调度工具 |
| `command-tool` | ❌ | 工具调度时要调用的工具名称 |

### 1.3 AgentSkills 开放规范

OpenClaw 的 Skill 格式兼容 [AgentSkills 规范](https://agentskills.io)，该规范已被广泛采纳：

| 平台 | 状态 |
|------|------|
| Claude Code | ✅ 支持 |
| Cursor | ✅ 支持 |
| Gemini CLI | ✅ 支持 |
| GitHub Copilot | ✅ 支持 |
| VS Code | ✅ 支持 |
| OpenAI Codex | ✅ 支持 |
| JetBrains Junie | ✅ 支持 |
| OpenHands | ✅ 支持 |
| Spring AI | ✅ 支持 |
| Databricks | ✅ 支持 |
| ...20+ 平台 | ✅ |

**意义**：同一个 SKILL.md 文件可以跨平台复用，不锁定在 OpenClaw 生态中。

---

## 二、Skill 加载架构

### 2.1 三层优先级机制

```
优先级（高 → 低）：

┌─────────────────────────────────┐
│ 1. 工作区 Skills                 │  <workspace>/skills/
│    （每个 Agent 独有）            │  最高优先级，覆盖一切
├─────────────────────────────────┤
│ 2. 托管/本地 Skills              │  ~/.openclaw/skills/
│    （所有 Agent 共享）            │  clawhub install 默认安装位置
├─────────────────────────────────┤
│ 3. 内置 Skills                   │  npm 包自带
│    （OpenClaw 发行版）            │  最低优先级
├─────────────────────────────────┤
│ 4. 额外目录                      │  skills.load.extraDirs 配置
│    （最低优先级）                 │  共享文件夹
└─────────────────────────────────┘
```

**名称冲突时**：高优先级覆盖低优先级。例如工作区中的 `weather` Skill 会覆盖内置的 `weather`。

**当前数量**（本实例）：
- 内置 Skills：52 个
- 托管 Skills：19 个

### 2.2 多 Agent 场景下的 Skill 隔离

```
~/.openclaw/
├── skills/                        ← 共享（所有 Agent 可见）
│   ├── tavily-search/
│   └── xlsx/
├── workspace/skills/              ← main Agent 独有
│   └── custom-coding/
├── workspace-wairesearch/skills/  ← wairesearch 独有
│   └── arxiv-watcher/
└── workspace-waicode/skills/      ← waicode 独有
    └── code-review/
```

**插件发布的 Skills**：插件可在 `openclaw.plugin.json` 中声明 `skills` 目录，插件启用时自动加载。

### 2.3 门控机制（加载时过滤）

Skill 不是无条件加载的。OpenClaw 在启动时根据 `metadata.openclaw.requires` 过滤：

```markdown
metadata: {
  "openclaw": {
    "requires": {
      "bins": ["uv"],           ← PATH 中必须存在的二进制文件
      "anyBins": ["brew", "apt"], ← 至少存在一个
      "env": ["GEMINI_API_KEY"],  ← 环境变量或配置中必须存在
      "config": ["browser.enabled"] ← openclaw.json 中的配置必须为真
    },
    "os": ["darwin", "linux"],     ← 操作系统限制
    "always": true,                ← 跳过所有门控，始终加载
    "primaryEnv": "GEMINI_API_KEY" ← 关联的主环境变量
  }
}
```

**门控流程**：

```
Skill 发现
    ↓
检查 metadata.openclaw.os → 不匹配当前OS → ❌ 跳过
    ↓
检查 requires.bins → 二进制不存在 → ❌ 跳过
    ↓
检查 requires.env → 环境变量缺失 → ❌ 跳过
    ↓
检查 requires.config → 配置未启用 → ❌ 跳过
    ↓
检查 skills.entries.<key>.enabled → false → ❌ 禁用
    ↓
检查 skills.allowBundled 白名单 → 不在列表中 → ❌ 跳过（仅内置）
    ↓
✅ Skill 有资格加载
```

### 2.4 会话快照（性能优化）

```
会话开始
    ↓
快照有资格的 Skills 列表  ← 一次性计算
    ↓
后续轮次重用快照          ← 不重复过滤
    ↓
Skills 文件变更 → 监视器检测 → 刷新快照  ← 热重载
    ↓
下一轮次获取新列表
```

**配置**：
```json5
{
  skills: {
    load: {
      watch: true,          // 监视 Skills 文件夹变更
      watchDebounceMs: 250  // 防抖 250ms
    }
  }
}
```

---

## 三、Skill 调用机制

### 3.1 两阶段调用：列表注入 + 按需读取

OpenClaw 的 Skill 调用采用**惰性加载**策略，分两个阶段：

```
阶段 1：系统提示词注入 Skills 列表
┌──────────────────────────────────────────────┐
│  <available_skills>                           │
│    <skill>                                    │
│      <name>weather</name>                     │
│      <description>Get weather...</description>│
│      <location>/path/to/SKILL.md</location>   │
│    </skill>                                    │
│    <skill>...</skill>                          │
│  </available_skills>                           │
└──────────────────────────────────────────────┘
      ↓
  模型看到列表，但**不读取** SKILL.md 内容
      ↓
  用户发送消息："What's the weather in Tokyo?"
      ↓
阶段 2：模型按需读取
  模型判断 weather Skill 适用
      ↓
  模型调用 read 工具读取 SKILL.md
      ↓
  获取完整指令 → 按指令执行任务
```

**为什么这样设计？**
- **节省 Token**：只有 Skills 列表（元数据）始终在上下文中，完整指令按需加载
- **选择精准**：模型根据 `description` 判断何时使用，不会加载无关指令
- **扩展性好**：即使有数百个 Skills，系统提示词开销线性且可控

### 3.2 Token 开销计算

**基础开销**（有 ≥1 个 Skill 时）：195 字符
**每个 Skill**：97 字符 + name + description + location 的 XML 转义长度

```
total_chars = 195 + Σ(97 + len(name) + len(description) + len(location))
```

**估算**：每个 Skill 约 **24+ token**（粗略 ~4 字符/token）

以本实例为例（52 内置 + 19 托管 ≈ 71 个 Skills）：
```
~195 + 71 × (~97 + ~80) ≈ 12,767 字符 ≈ ~3,192 token
```

### 3.3 斜杠命令调用

Skill 可以作为**用户斜杠命令**使用：

```
用户输入: /weather Tokyo

      ↓ OpenClaw 识别为 Skill 命令
      ↓
检查 user-invocable: true（默认）
      ↓
检查 command-dispatch
  ├── 未设置 → 将命令作为消息发送给模型，模型读取 SKILL.md 并执行
  └── tool → 直接调度到 command-tool 指定的工具（绕过模型）
```

**工具直接调度**（`command-dispatch: tool`）：
```markdown
---
name: quick-status
command-dispatch: tool
command-tool: session_status
---
```
调用方式：`/quick-status` → 直接调用 `session_status` 工具，不经过模型。

### 3.4 模型自主调用流程

```
┌─────────────────────────────────────────────────┐
│ 用户消息: "Help me create a presentation"        │
└──────────────────────┬──────────────────────────┘
                       ↓
┌──────────────────────────────────────────────────┐
│ 模型扫描 <available_skills> 列表                  │
│ 找到匹配: pptx Skill                             │
│ 描述: "Use when .pptx file is involved..."       │
└──────────────────────┬───────────────────────────┘
                       ↓
┌──────────────────────────────────────────────────┐
│ 模型调用 read 工具:                               │
│ read("~/.openclaw/skills/pptx/SKILL.md")         │
└──────────────────────┬───────────────────────────┘
                       ↓
┌──────────────────────────────────────────────────┐
│ 获取完整指令 → 按指令执行:                         │
│ 1. 安装 python-pptx                              │
│ 2. 读取参考模板                                    │
│ 3. 生成 Python 脚本                               │
│ 4. 执行创建 .pptx 文件                            │
└──────────────────────────────────────────────────┘
```

### 3.5 Skill 指令中的路径引用

Skill 可以引用自身目录中的文件：

```markdown
# In SKILL.md

Read the API reference at `{baseDir}/references/api-docs.md` before proceeding.
Run the setup script: `exec {baseDir}/scripts/setup.sh`
```

`{baseDir}` 在运行时被替换为 Skill 文件夹的绝对路径。

---

## 四、Skill 管理生态

### 4.1 ClawHub — 公共注册中心

| 功能 | 说明 |
|------|------|
| **浏览** | https://clawhub.com，公开查看所有 Skills |
| **搜索** | 向量搜索（语义匹配），非纯关键词 |
| **安装** | `clawhub install <slug>` |
| **更新** | `clawhub update --all` |
| **发布** | `clawhub publish <path>` |
| **同步** | `clawhub sync --all`（扫描+发布） |
| **版本** | 语义化版本 + 标签（latest） |
| **评价** | 星标和评论 |

**规模**：2,857+ 公开 Skills（截至 2026-03）

### 4.2 CLI 管理命令

```bash
# 搜索
clawhub search "calendar management"

# 安装
clawhub install my-skill-pack
clawhub install my-skill-pack --version 2.0.0

# 更新
clawhub update --all
clawhub update my-skill --force

# 列表（已安装）
clawhub list

# 发布
clawhub publish ./my-skill --slug my-skill --name "My Skill" --version 1.0.0

# 同步（批量扫描+发布）
clawhub sync --all --dry-run
clawhub sync --all --bump minor

# 认证
clawhub login
clawhub whoami
```

### 4.3 配置管理

```json5
// ~/.openclaw/openclaw.json
{
  skills: {
    // 仅允许这些内置 Skills（其他内置 Skills 被屏蔽）
    allowBundled: ["weather", "github", "coding-agent"],
    
    load: {
      extraDirs: ["~/shared-skills"],  // 额外扫描目录
      watch: true,                      // 文件变更监视
      watchDebounceMs: 250
    },
    
    install: {
      preferBrew: true,
      nodeManager: "npm"  // npm | pnpm | yarn | bun
    },
    
    entries: {
      "nano-banana-pro": {
        enabled: true,
        apiKey: "GEMINI_KEY_HERE",
        env: { GEMINI_API_KEY: "GEMINI_KEY_HERE" },
        config: { endpoint: "https://example.com", model: "nano-pro" }
      },
      "risky-skill": { enabled: false }  // 禁用特定 Skill
    }
  }
}
```

### 4.4 安装器规格

Skill 可以声明自己的依赖安装方式：

```markdown
metadata: {
  "openclaw": {
    "install": [
      { "id": "brew", "kind": "brew", "formula": "ffmpeg", "bins": ["ffmpeg"] },
      { "id": "node", "kind": "node", "package": "sharp" },
      { "id": "go", "kind": "go", "module": "github.com/..." },
      { "id": "uv", "kind": "uv", "package": "summarize" },
      { "id": "download", "kind": "download", 
        "url": "https://...", "archive": "tar.gz", "targetDir": "~/.openclaw/tools/mytool" }
    ]
  }
}
```

---

## 五、Skill 在系统提示词中的位置

### 5.1 系统提示词结构

```
┌─────────────────────────────────────────┐
│ Tooling（工具列表 + Schema）             │ ← 工具的函数签名
├─────────────────────────────────────────┤
│ Safety（安全防护）                       │
├─────────────────────────────────────────┤
│ Skills（可用 Skills 列表）               │ ← 仅元数据！
│   <available_skills>                     │
│     <skill>name + desc + location</skill>│
│   </available_skills>                    │
├─────────────────────────────────────────┤
│ Workspace / Docs / Runtime              │
├─────────────────────────────────────────┤
│ Project Context（注入的工作区文件）       │
│   AGENTS.md / SOUL.md / USER.md etc.    │
└─────────────────────────────────────────┘
```

**关键点**：Skills 列表在系统提示词中，**SKILL.md 全文不在系统提示词中**。模型需要时主动 `read`。

### 5.2 子 Agent 的 Skill 可见性

| 场景 | Skills 列表 | 说明 |
|------|------------|------|
| 主 Agent（full mode） | ✅ 完整列表 | 所有有资格的 Skills |
| 子 Agent（minimal mode） | ❌ 不注入 | 系统提示词为 minimal，省略 Skills 部分 |

⚠️ **子 Agent 默认看不到 Skills 列表**，这是设计决策——子 Agent 应该专注于特定任务。

---

## 六、Skill 与 Plugin、Tool 的关系

### 6.1 三者对比

| 维度 | Skill | Plugin | Tool |
|------|-------|--------|------|
| **本质** | Markdown 指令 | 运行时代码（JS/TS） | 函数接口 |
| **作用** | 教 Agent **怎么做** | 扩展系统**能做什么** | Agent **能调用什么** |
| **格式** | SKILL.md（纯文本） | JS/TS 模块 + manifest | 内置/Plugin 注册 |
| **安装** | 复制文件夹即可 | `openclaw plugins install` | 内置或 Plugin 注册 |
| **安全** | 指令层面（提示注入风险） | 代码层面（完全信任） | 框架控制（allow/deny） |
| **跨平台** | ✅ AgentSkills 规范 | ❌ OpenClaw 专用 | ❌ OpenClaw 专用 |
| **注册中心** | ClawHub | npm | - |

### 6.2 协作关系

```
Plugin 注册新 Tool
    ↓
Skill 教 Agent 如何使用 Tool
    ↓
Agent 读取 Skill → 调用 Tool → 完成任务
```

**示例**：
- `diffs` Plugin 注册了 `diffs` 工具 → `diffs` Skill 教 Agent 何时以及如何使用该工具
- `voice-call` Plugin 注册了 `voice_call` 工具 → `voice-call` Skill 提供使用指南

### 6.3 Plugin 发布的 Skills

Plugin 可以在 manifest 中声明自带的 Skills：

```json
{
  "id": "diffs",
  "skills": ["skills/diffs"]
}
```

Plugin 启用时，其 Skills 自动加载到系统中。

---

## 七、Skill 安全模型

### 7.1 威胁面

| 风险 | 说明 | 缓解措施 |
|------|------|---------|
| **提示注入** | 恶意 SKILL.md 中嵌入危险指令 | 审查源码、使用沙箱 |
| **环境泄露** | Skill 要求注入敏感环境变量 | 检查 requires.env |
| **任意执行** | 指令中包含恶意命令 | 沙箱隔离 + 工具 deny 列表 |
| **过度权限** | Skill 指示 Agent 执行超出需要的操作 | 工具策略限制 |

### 7.2 安全最佳实践

1. **审查第三方 Skills** — 安装前阅读 SKILL.md 全文
2. **使用沙箱** — 不受信任的 Skills 在沙箱中运行
3. **最小权限** — 通过 `tools.deny` 限制 Agent 可用工具
4. **白名单内置** — `skills.allowBundled` 只启用需要的内置 Skills
5. **安全扫描** — 使用 ClawDex 等工具扫描 Skills
6. **隔离环境变量** — `skills.entries.<key>.env` 仅在 Agent 运行期间注入

---

## 八、Skill 创建指南

### 8.1 最小可用 Skill

```bash
mkdir -p ~/.openclaw/workspace/skills/my-skill
```

```markdown
---
name: my-skill
description: "Do X when user asks about Y."
---

# My Skill

## When to Use
✅ User asks about Y

## Instructions
1. Use `web_search` to find information about Y
2. Summarize the results
3. Present to user in structured format
```

### 8.2 进阶 Skill（带门控和引用）

```markdown
---
name: advanced-skill
description: "Complex workflow with API integration."
metadata: {
  "openclaw": {
    "emoji": "🔧",
    "requires": {
      "bins": ["python3"],
      "env": ["MY_API_KEY"]
    },
    "primaryEnv": "MY_API_KEY",
    "install": [
      { "id": "brew", "kind": "brew", "formula": "python3" }
    ]
  }
}
---

# Advanced Skill

Read the API reference at `{baseDir}/references/api-spec.md` first.

## Step 1: Setup
Run `{baseDir}/scripts/setup.sh` to initialize.

## Step 2: Execute
Use the `exec` tool to run:
```
python3 {baseDir}/scripts/main.py --key $MY_API_KEY
```

## Step 3: Process Output
Parse the JSON output and format as markdown table.
```

### 8.3 测试

```bash
# 本地测试
openclaw agent --message "use my new skill"

# 发布到 ClawHub
clawhub publish ./skills/my-skill --slug my-skill --name "My Skill" --version 1.0.0
```

---

## 九、架构亮点与局限

### 亮点

1. **纯 Markdown = 零门槛**：任何人都可以创建 Skill，不需要编程
2. **AgentSkills 跨平台规范**：一次编写，Cursor/Claude Code/Gemini CLI 等通用
3. **惰性加载 = Token 高效**：列表占位极小，完整指令按需读取
4. **三层优先级 = 灵活覆盖**：从内置到工作区层层可覆盖
5. **门控机制 = 智能过滤**：二进制、环境变量、配置、操作系统多维门控
6. **ClawHub 生态**：2,857+ 公开 Skills，语义搜索，版本管理
7. **热重载**：Skills 文件变更自动检测，无需重启

### 局限

1. **提示注入风险**：Skill 本质是注入到模型上下文的文本，恶意 Skill 可能操纵 Agent
2. **子 Agent 不可见**：子 Agent 的 minimal 模式不注入 Skills 列表
3. **模型依赖判断**：Skill 选择完全靠模型理解 description，可能出错
4. **沙箱兼容性**：二进制门控在宿主机检查，但沙箱内可能缺少依赖
5. **缺乏细粒度权限**：无法限制特定 Skill 只能调用特定工具
6. **无运行时验证**：Skill 指令的正确性完全依赖 LLM 的执行能力

---

## 十、与其他框架对比

| 维度 | OpenClaw Skills | LangChain Tools | CrewAI Tools | Claude MCP |
|------|----------------|-----------------|--------------|------------|
| **定义格式** | Markdown | Python 代码 | Python 代码 | JSON Schema + 代码 |
| **跨平台** | ✅ AgentSkills | ❌ | ❌ | ⚠️ 部分 |
| **注册中心** | ClawHub (2857+) | LangChain Hub | 无 | MCP Hub |
| **安装方式** | 复制文件 | pip install | pip install | npm/pip |
| **门控机制** | 多维过滤 | 无 | 无 | 无 |
| **惰性加载** | ✅ | ❌ 全量加载 | ❌ 全量加载 | ❌ |
| **创建门槛** | 极低（Markdown） | 中等（Python） | 中等（Python） | 较高（JSON+代码） |

---

## 附录一：Skill 调用控制手段

OpenClaw 提供**多层控制手段**来精确管理 Skill 的调用：

### A1.1 加载层控制（Skill 能不能被看到）

**直接禁用**：
```json5
{
  skills: {
    entries: {
      "risky-skill": { enabled: false }  // 彻底禁用，即使已安装
    }
  }
}
```

**内置白名单**（只允许指定的内置 Skills，其他全部屏蔽）：
```json5
{
  skills: {
    allowBundled: ["weather", "github", "coding-agent"]
  }
}
```

**门控条件**（不满足条件自动跳过）：
```yaml
metadata: {
  "openclaw": {
    "requires": {
      "bins": ["ffmpeg"],          # 缺二进制 → 不加载
      "env": ["GEMINI_API_KEY"],   # 缺环境变量 → 不加载
      "config": ["browser.enabled"] # 配置未启用 → 不加载
    },
    "os": ["darwin"]               # 非 macOS → 不加载
  }
}
```

### A1.2 可见性控制（模型/用户能不能调用）

**禁止模型自主调用**（仅保留用户斜杠命令）：
```yaml
---
name: dangerous-skill
disable-model-invocation: true   # 模型看不到，不会自动选用
user-invocable: true             # 但用户可以 /dangerous-skill 手动触发
---
```

**禁止用户斜杠命令**（仅模型自动选择）：
```yaml
---
name: internal-skill
user-invocable: false            # 用户不能 /internal-skill
disable-model-invocation: false  # 模型仍可自动选择
---
```

**两个都禁 = 彻底隐身**：
```yaml
disable-model-invocation: true
user-invocable: false
# 这个 Skill 存在但谁也调不到（效果等同于 enabled: false）
```

### A1.3 调用方式控制

**工具直接调度**（绕过模型判断）：
```yaml
---
name: quick-status
command-dispatch: tool       # 斜杠命令直接调度工具
command-tool: session_status # 目标工具
command-arg-mode: raw        # 原始参数转发
---
```
用户输入 `/quick-status` → 直接调用 `session_status`，不经过 LLM。

### A1.4 工具层控制（Skill 中用到的工具能不能执行）

**全局工具 allow/deny**：
```json5
{
  tools: {
    deny: ["exec", "browser"]  // 所有 Skill 都无法让 Agent 执行命令或浏览器
  }
}
```

**按 Agent 工具限制**：
```json5
{
  agents: {
    list: [{
      id: "restricted",
      tools: {
        allow: ["read", "web_search"],
        deny: ["exec", "write", "edit"]
      }
    }]
  }
}
```

即使 Skill 指令写了"请用 exec 执行命令"，Agent 也调不到被 deny 的工具。

**子 Agent 工具策略**：
```json5
{
  tools: {
    subagents: {
      tools: { deny: ["browser", "gateway"] }
    }
  }
}
```

### A1.5 凭证层控制

**按 Skill 注入/不注入 API Key**：
```json5
{
  skills: {
    entries: {
      "nano-banana-pro": {
        enabled: true,
        apiKey: "GEMINI_KEY"  // 只有这个 Skill 运行时注入
      },
      "another-skill": {
        enabled: true
        // 不给 apiKey → 门控检查失败 → 自动跳过
      }
    }
  }
}
```

### A1.6 控制手段速查表

| 层级 | 手段 | 效果 |
|------|------|------|
| **加载层** | `enabled: false` | 彻底不加载 |
| **加载层** | `allowBundled` | 内置白名单 |
| **加载层** | `requires.*` 门控 | 条件不满足自动跳过 |
| **可见性** | `disable-model-invocation` | 模型看不到 |
| **可见性** | `user-invocable: false` | 用户不能斜杠调用 |
| **调用方式** | `command-dispatch: tool` | 绕过模型直接调工具 |
| **工具层** | `tools.deny` | Skill 指令中的工具被拦截 |
| **凭证层** | 不配置 `apiKey`/`env` | 缺凭证被门控 |
| **沙箱层** | `sandbox.mode: "all"` | Skill 在隔离容器中执行 |

---

## 附录二：Skill 全部配置项参考

### A2.1 openclaw.json 中的 `skills` 配置

```json5
{
  skills: {
    // ═══════════════ 加载控制 ═══════════════
    
    // 内置 Skills 白名单（仅影响内置，不影响托管/工作区）
    allowBundled: ["weather", "github", "coding-agent"],
    
    load: {
      extraDirs: ["~/shared-skills"],    // 额外扫描目录（最低优先级）
      watch: true,                        // 文件变更监视（默认: true）
      watchDebounceMs: 250,               // 防抖时间 ms（默认: 250）
    },
    
    // ═══════════════ 安装行为 ═══════════════
    
    install: {
      preferBrew: true,                   // 优先 brew（默认: true）
      nodeManager: "npm",                 // npm | pnpm | yarn | bun（默认: npm）
    },
    
    // ═══════════════ 单 Skill 配置 ═══════════════
    
    entries: {
      "<skillKey>": {
        enabled: true,                    // 启用/禁用（默认: true）
        apiKey: "KEY_HERE",               // 主 API Key（明文或 SecretRef）
        env: {                            // 环境变量注入（仅未设置时注入）
          MY_VAR: "value"
        },
        config: {                         // 自定义配置容器
          endpoint: "https://...",
          model: "xxx"
        }
      }
    }
  }
}
```

### A2.2 SKILL.md Frontmatter 全部字段

```yaml
---
# ═══════════════ 必填 ═══════════════
name: my-skill                  # Skill 标识名
description: "Do X when Y."    # 描述（注入系统提示词）

# ═══════════════ 显示 ═══════════════
homepage: https://example.com   # 外部文档 URL

# ═══════════════ 调用控制 ═══════════════
user-invocable: true            # 作为用户斜杠命令（默认: true）
disable-model-invocation: false # 从模型提示词排除（默认: false）
command-dispatch: tool          # "tool" = 斜杠命令直接调工具
command-tool: session_status    # 直接调度的目标工具
command-arg-mode: raw           # 参数模式（默认: raw）

# ═══════════════ 门控和元数据 ═══════════════
# 注意：metadata 必须是单行 JSON
metadata: {
  "openclaw": {
    "always": true,                           # 跳过所有门控
    "emoji": "🌤️",                            # macOS UI 表情
    "homepage": "https://...",                 # 文档 URL
    "os": ["darwin", "linux", "win32"],        # 操作系统限制
    "skillKey": "custom-key",                  # 自定义 entries 键名
    "primaryEnv": "MY_API_KEY",                # 主环境变量
    "requires": {
      "bins": ["ffmpeg"],                      # 全部必须在 PATH 中
      "anyBins": ["brew", "apt"],              # 至少一个在 PATH 中
      "env": ["MY_API_KEY"],                   # 必须存在或配置提供
      "config": ["browser.enabled"]            # 配置路径必须为真
    },
    "install": [
      { "id": "brew", "kind": "brew", "formula": "ffmpeg", "bins": ["ffmpeg"],
        "label": "Install via Homebrew", "os": ["darwin"] },
      { "id": "node", "kind": "node", "package": "sharp" },
      { "id": "go", "kind": "go", "module": "github.com/example/tool" },
      { "id": "uv", "kind": "uv", "package": "summarize" },
      { "id": "download", "kind": "download", "url": "https://...",
        "archive": "tar.gz", "stripComponents": 1,
        "targetDir": "~/.openclaw/tools/mytool" }
    ]
  }
}
---
```

### A2.3 配置速查表

**openclaw.json `skills.*` 字段**：

| 配置路径 | 类型 | 默认值 | 说明 |
|---------|------|--------|------|
| `skills.allowBundled` | `string[]` | 无（全部允许） | 内置 Skills 白名单 |
| `skills.load.extraDirs` | `string[]` | `[]` | 额外扫描目录 |
| `skills.load.watch` | `boolean` | `true` | 文件变更监视 |
| `skills.load.watchDebounceMs` | `number` | `250` | 监视防抖(ms) |
| `skills.install.preferBrew` | `boolean` | `true` | 优先 brew 安装 |
| `skills.install.nodeManager` | `string` | `"npm"` | Node 包管理器 |
| `skills.entries.<key>.enabled` | `boolean` | `true` | 启用/禁用 |
| `skills.entries.<key>.apiKey` | `string\|SecretRef` | - | 主 API Key |
| `skills.entries.<key>.env` | `object` | `{}` | 环境变量注入 |
| `skills.entries.<key>.config` | `object` | `{}` | 自定义配置 |

**SKILL.md Frontmatter 字段**：

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `name` | `string` | **必填** | Skill 标识 |
| `description` | `string` | **必填** | 提示词中的描述 |
| `homepage` | `string` | - | 文档链接 |
| `user-invocable` | `boolean` | `true` | 用户可斜杠调用 |
| `disable-model-invocation` | `boolean` | `false` | 模型不可自动调用 |
| `command-dispatch` | `string` | - | `"tool"` = 直接调度 |
| `command-tool` | `string` | - | 工具调度目标 |
| `command-arg-mode` | `string` | `"raw"` | 参数转发模式 |
| `metadata.openclaw.always` | `boolean` | `false` | 跳过门控 |
| `metadata.openclaw.emoji` | `string` | - | 表情符号 |
| `metadata.openclaw.os` | `string[]` | - | 操作系统限制 |
| `metadata.openclaw.skillKey` | `string` | - | 自定义配置键名 |
| `metadata.openclaw.primaryEnv` | `string` | - | 主环境变量名 |
| `metadata.openclaw.requires.bins` | `string[]` | - | 必需二进制 |
| `metadata.openclaw.requires.anyBins` | `string[]` | - | 任一二进制 |
| `metadata.openclaw.requires.env` | `string[]` | - | 必需环境变量 |
| `metadata.openclaw.requires.config` | `string[]` | - | 必需配置项 |
| `metadata.openclaw.install` | `object[]` | - | 安装器规格 |

---

## 参考来源

1. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/skills.md` — Skills 核心文档
2. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/creating-skills.md` — 创建 Skills 指南
3. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/skills-config.md` — Skills 配置参考
4. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/clawhub.md` — ClawHub 指南
5. `/usr/lib/node_modules/openclaw/docs/zh-CN/tools/plugin.md` — 插件系统（含 Skills 关系）
6. `/usr/lib/node_modules/openclaw/docs/zh-CN/concepts/system-prompt.md` — 系统提示词构建
7. `/usr/lib/node_modules/openclaw/docs/zh-CN/platforms/mac/skills.md` — macOS Skills UI
8. [AgentSkills 规范](https://agentskills.io) — 开放 Skills 标准
9. [ClawHub](https://clawhub.com) — 公共 Skills 注册中心
10. [DigitalOcean OpenClaw Skills 指南](https://www.digitalocean.com/resources/articles/what-are-openclaw-skills) — 第三方开发者指南
