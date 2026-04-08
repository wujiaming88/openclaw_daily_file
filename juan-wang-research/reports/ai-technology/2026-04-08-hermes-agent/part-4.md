# Part 4：生态系统与社区

## 自进化系统（hermes-agent-self-evolution）

这是 Hermes Agent 最前沿的研究项目——用进化算法自动优化 Agent 自身：

### 技术架构
```
读取当前 skill/prompt/tool → 生成评估数据集
                                    ↓
                              GEPA 优化器 ← 执行轨迹
                                    ↓
                              候选变体 → 评估
                                    ↓
                              约束门控（测试、大小限制、基准）
                                    ↓
                              最佳变体 → PR 到 hermes-agent
```

### 核心技术
- **DSPy + GEPA**（遗传-帕累托提示词进化）：读取执行轨迹理解失败原因，提出针对性改进
- **ICLR 2026 Oral**：学术认可的研究成果
- **成本**：~$2-10 每次优化运行，无需 GPU

### 进化阶段

| 阶段 | 目标 | 引擎 | 状态 |
|------|------|------|------|
| Phase 1 | SKILL.md 文件 | DSPy + GEPA | ✅ 已实现 |
| Phase 2 | 工具描述 | DSPy + GEPA | 🔲 计划中 |
| Phase 3 | 系统提示词 | DSPy + GEPA | 🔲 计划中 |
| Phase 4 | 工具实现代码 | Darwinian Evolver | 🔲 计划中 |
| Phase 5 | 持续改进循环 | 自动化流水线 | 🔲 计划中 |

### 安全约束
- 必须通过 100% 测试套件
- 技能文件 ≤15KB
- 不允许中途改变缓存
- 语义保持一致
- 所有变更通过人工审查 PR

## agentskills.io 开放标准

Hermes Agent 是 agentskills.io 标准的核心推动者之一。该标准现已被广泛采纳：

| 兼容产品 | 说明 |
|----------|------|
| Hermes Agent | 核心实现 |
| OpenClaw | 同源兼容 |
| GitHub Copilot (VS Code/CLI) | 原生支持 |
| OpenAI Codex | 原生支持 |
| Claude Code | Anthropic 推出的标准 |

标准特点：
- 简单的文件夹结构（SKILL.md + references/ + scripts/）
- 渐进式加载减少 token 消耗
- 跨 Agent 可移植

## awesome-hermes-agent 社区生态

截至 2026-04-03：
- **核心仓库**：23,000+ stars
- **最新版本**：v0.6.0 (v2026.3.30)

### 社区项目亮点

| 项目 | 星数 | 描述 | 成熟度 |
|------|------|------|--------|
| hermes-workspace | 500+ | Web 工作区（聊天/终端/技能管理/Inspector） | production |
| mission-control | 3,700+ | 多 Agent 编排仪表盘 | production |
| wondelai/skills | 380+ | 跨平台技能库 | beta |
| litprog-skill | 75+ | 文学编程技能 | beta |
| hermes-plugins | — | 目标管理/Agent 间桥接/模型选择/成本控制 | beta |
| hermes-skill-factory | — | 自动从工作流生成技能 | beta |
| hermes-life-os | — | 个人生活 OS Agent | experimental |
| Wizards-of-the-Ghosts | — | RPG 主题开发技能包 | experimental |

### 官方衍生项目

| 项目 | 说明 |
|------|------|
| autonovel | 自主长篇小说写作（10万+ 字） |
| hermes-paperclip-adapter | Paperclip 公司集成 |
| tinker-atropos | RL 训练基础设施 |

## RL 训练集成

Hermes Agent 内置完整的 RL 训练环境框架：
- 与 Atropos 集成
- 批量轨迹生成
- 轨迹压缩用于训练下一代 tool-calling 模型
- ShareGPT 格式输出
- 多种工具调用解析器
