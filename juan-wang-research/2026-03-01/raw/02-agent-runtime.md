# OpenClaw Agent Runtime 架构

## 来源
- URL: https://docs.openclaw.ai/concepts/agent
- 获取时间: 2026-03-01 14:37

## 核心架构

### 1. 运行时基础
- OpenClaw运行单个嵌入式代理运行时，派生自**pi-mono**
- 工作区（Workspace）是必需的，作为代理的唯一工作目录（cwd）

### 2. 工作区结构

#### 必需文件（自动注入）
- **AGENTS.md** - 操作指令+"memory"
- **SOUL.md** - 人格、边界、语气
- **TOOLS.md** - 用户维护的工具注释
- **BOOTSTRAP.md** - 一次性首次运行仪式（完成后删除）
- **IDENTITY.md** - 代理名称/氛围/emoji
- **USER.md** - 用户档案+首选地址

#### 文件注入机制
- 新会话的第一轮，OpenClaw将这些文件内容直接注入到代理上下文中
- 空白文件被跳过
- 大文件被修剪和截断（带标记以保持提示精简）
- 缺失文件注入单个"missing file"标记行
- BOOTSTRAP.md仅在新工作区创建（无其他引导文件存在时）

### 3. 技能系统

#### 技能加载优先级（名称冲突时工作区优先）
1. **Bundled**（随安装附带）
2. **Managed/local**: `~/.openclaw/skills`
3. **Workspace**: `<workspace>/skills`

#### 技能控制
- 可以通过配置/环境进行门控
- SKILL.md定义技能的使用方法

### 4. 内置工具
- 核心工具（read/exec/edit/write和相关系统工具）始终可用
- 受工具策略约束
- `apply_patch`是可选的，由`tools.exec.applyPatch`门控
- TOOLS.md不控制哪些工具存在，只是指导你希望如何使用它们

### 5. 会话管理

#### 会话存储
- 会话记录存储为JSONL：`~/.openclaw/agents/<agentId>/sessions/<SessionId>.jsonl`
- 会话ID是稳定的，由OpenClaw选择
- 不读取Legacy Pi/Tau会话文件夹

#### 流式传输中的引导（Steering）
- **队列模式为`steer`时**：入站消息注入到当前运行中
- 队列在**每次工具调用后**检查
- 如果存在排队消息，跳过当前助手消息的剩余工具调用
- 然后在下一个助手响应之前注入排队的用户消息

#### 队列模式
- **steer**: 实时注入
- **followup**或**collect**: 保持入站消息直到当前轮结束，然后开始新的代理轮次

### 6. 块流式传输（Block Streaming）

#### 配置选项
- **默认关闭**（`agents.defaults.blockStreamingDefault: "off"`）
- **边界控制**: `agents.defaults.blockStreamingBreak`（`text_end` vs `message_end`）
- **分块控制**: `agents.defaults.blockStreamingChunk`（默认800-1200字符）
- **合并控制**: `agents.defaults.blockStreamingCoalesce`（减少单行垃圾信息）

#### 行为
- 块流式传输在完成后立即发送完成的助手块
- 优先段落分隔符，然后换行，最后是句子
- 非Telegram通道需要显式`*.blockStreaming: true`来启用块回复

### 7. 模型引用解析

#### 解析规则
- 模型引用在**第一个**`/`上分割
- 使用`provider/model`格式配置模型
- 如果模型ID本身包含`/`（OpenRouter风格），包含提供者前缀
- 如果省略提供者，OpenClaw将输入视为别名或**默认提供者**的模型

### 8. pi-mono集成

#### 集成方式
- OpenClaw重用pi-mono代码库的部分（模型/工具）
- **会话管理、发现和工具连接是OpenClaw拥有的**
- 无pi-coding代理运行时
- 不读取`~/.pi/agent`或`<workspace>/.pi`设置

### 9. 最小配置

#### 必需配置项
- `agents.defaults.workspace`
- `channels.whatsapp.allowFrom`（强烈推荐）

## 架构特点

### 1. 单一工作区
- 单一代理工作区作为唯一工作目录
- 支持沙箱模式（非主会话可以覆盖）

### 2. 文件驱动配置
- 通过工作区文件定义代理行为
- 自动注入机制简化配置
- 支持自定义模板

### 3. 灵活的技能系统
- 三层加载优先级
- 支持技能门控
- 易于扩展

### 4. 实时引导
- 支持流式传输中的实时引导
- 多种队列模式适应不同场景

### 5. 模型抽象
- 统一的模型引用格式
- 支持多提供者
- 灵活的别名系统

## 参考资料
- Agent Workspace: https://docs.openclaw.ai/concepts/agent-workspace
- Gateway Configuration: https://docs.openclaw.ai/gateway/configuration
- Queue: https://docs.openclaw.ai/concepts/queue
- Streaming: https://docs.openclaw.ai/concepts/streaming
