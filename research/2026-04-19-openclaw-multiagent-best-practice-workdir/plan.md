# 研究计划 — OpenClaw 多 Agent 团队最佳实践

## 研究目标
为老板"五岳+统帅"团队产出决策级别的《可维护性/执行效率/执行稳定性》三维提升指南。

## 关键文档地图（已勘探）
OpenClaw 2026.4.12 docs 目录：
- `docs/concepts/multi-agent.md` ✅ 读完 — multi-agent 路由、bindings、per-agent sandbox
- `docs/tools/subagents.md` ✅ 读完 — sessions_spawn、depth、announce、auto-archive、thread binding
- `docs/concepts/session-tool.md` ✅ 读完 — sessions_* 工具套件、sessions_yield、visibility
- `docs/cli/agents.md` ✅ 读完 — agents add/bind/set-identity
- `docs/cli/memory.md` ✅ 读完 — memory index/search/promote/dreaming
- 待读：
  - `docs/concepts/system-prompt.md` — AGENTS/SOUL/IDENTITY 注入机制
  - `docs/concepts/agent-workspace.md` — workspace 结构
  - `docs/concepts/session.md` — session 生命周期
  - `docs/concepts/memory.md` — 记忆架构
  - `docs/cli/cron.md` + `docs/automation/cron-jobs.md` — cron 批处理
  - `docs/cli/approvals.md` — /approve 机制
  - `docs/cli/hooks.md` — hooks
  - `docs/tools/skills.md` + `docs/tools/skills-config.md` — skill 治理
  - `docs/tools/multi-agent-sandbox-tools.md` — 沙箱 + tools allow/deny
  - `docs/gateway/security/*` — 安全边界
  - `docs/plugins/memory-wiki.md` + obsidian-vault-maintainer/wiki-maintainer skills
  - `docs/automation/tasks.md` — background tasks
  - `qa/scenarios/subagent-*.md` — 官方 QA 场景（黄金样例）
  - README / CHANGELOG — 最新特性
- 老板现场环境：
  - `~/.openclaw/workspace-wairesearch/` — 已有模板
  - `~/.openclaw/workspace/project/openclaw_daily_file` — 本报告目标仓库

## 子课题拆分（5 part + final report）

| Part | 主题 | 预估搜索次数 | 依赖 |
|------|------|------|------|
| part-1 | 可维护性：身份、记忆、skill、配置、可观察性 | 2（内部 docs 为主） | 多 docs 读取 |
| part-2 | 执行效率：任务编排、上下文、模型、工具、缓存 | 2（内部 docs + Anthropic 博客） | Anthropic multi-agent 博客 |
| part-3 | 执行稳定性：错误处理、审核、push 通知、外部依赖、安全 | 2（docs + gateway security） | 安全、failureAlert |
| part-4 | 第三方对比：Cognition《Don't Build Multi-Agents》、LangGraph/AutoGen/CrewAI 的经验教训 | 3-4 次 web 搜索 | web_search |
| part-5 | 落地：老板团队现状诊断 + 3 月路线图 + 反模式 + 配置示例 | 0 搜索（综合前文） | 前四部分 |
| report | 汇总：TL;DR + 矩阵 + 三大章节 + 演进路线图 + 数据源清单 | 0 搜索 | 所有 part |

## 搜索策略
每个子课题先用 docs 打底，再用 web 补充外部经验：
- Anthropic 官方 multi-agent 实践（2024 "How we built our multi-agent research system"）
- Cognition 博客 "Don't Build Multi-Agents" 核心观点
- LangGraph vs AutoGen vs CrewAI 对比（2025/2026）
- OpenClaw GitHub issues / Twitter 踩坑

## 执行原则（遵循 SOUL.md 大任务协议）
1. 写完 plan.md（本文件）立即开始 part-1
2. **每个 part 写入独立文件后再开始下一个**（不要在内存中积累）
3. 每 part ≤ 2500 字，聚焦"现状→问题→最佳实践→落地动作"
4. 最终 report.md 从文件读取各 part 合成
5. 关键发现立即在文件顶部给出 TL;DR

## 质量自检对照
- [ ] OpenClaw docs 通读 ≥ 15 篇关键章节
- [ ] 每个子主题都有"落地动作"（命令/配置/路径）
- [ ] 覆盖 ≥ 3 个第三方框架经验（Cognition + Anthropic + LangGraph/CrewAI）
- [ ] 反模式章节 ≥ 8 条
- [ ] 3 个月路线图 ≤ 3 个优先级动作/月
- [ ] 30+ 独立来源引用

---
*起草时间：2026-04-19 Asia/Shanghai*
