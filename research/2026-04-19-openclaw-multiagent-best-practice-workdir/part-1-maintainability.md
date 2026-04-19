# Part 1 — 可维护性（Maintainability）最佳实践

> **核心矛盾**：老板团队已有 6 个 agent（1 统帅 + 5 五岳 + clawdoctor）、60+ skills、多个共享文件、每 agent 独立 workspace。文件结构清晰但**缺少机械化保障**——人手维护容易飘散。

---

## 1. Agent 身份与人设管理（AGENTS / SOUL / IDENTITY / USER / HEARTBEAT）

### 官方分层依据（来自 `docs/concepts/system-prompt.md`、`agent-workspace.md`、`soul.md`）

OpenClaw 在每次 agent turn 都会把以下 bootstrap 文件注入 **Project Context**：
`AGENTS.md` · `SOUL.md` · `TOOLS.md` · `IDENTITY.md` · `USER.md` · `HEARTBEAT.md` · `BOOTSTRAP.md`（仅新建）· `MEMORY.md`。
子 agent（`promptMode=minimal`）**只注入 AGENTS.md + TOOLS.md**，其它一律过滤掉。

| 文件 | 唯一职责 | 反面例子（老板现状里有的坑） |
|------|---------|---------------------------|
| `AGENTS.md` | 操作指令：角色、职责、工作流、铁律 | wairesearch/AGENTS.md 目前几乎空壳（只有 5 行），**关键工作流写在 SOUL.md 里** |
| `SOUL.md` | **只写人设、语气、风格、边界** | 老板把"大任务协议"、"搜索策略"、"卷王模式"全塞进 SOUL.md（上千字）→ 人设噪声压缩、每 turn 注入浪费 token |
| `IDENTITY.md` | 名字、theme、emoji、avatar（4 个字段） | 放描述性文字是错用——这是 `agents set-identity` 读的结构化文件 |
| `USER.md` | 谁是用户、怎么称呼、沟通偏好 | 保持 ≤ 10 行 |
| `TOOLS.md` | 本机/本 workspace 的工具备忘（hosts、camera 别名、API 配额）| 不控制工具可用性，只是 cheat sheet |
| `HEARTBEAT.md` | 心跳任务清单（如果启用 heartbeat）| 不用就删，每 turn 都注入要省 token |
| `BOOTSTRAP.md` | **一次性**首启仪式，做完删除 | 老板现在所有 workspace 都留着，浪费 20KB 上下文 |

> 引用：`docs/concepts/system-prompt.md` 明确说 `bootstrapMaxChars` 默认 20000，`bootstrapTotalMaxChars` 默认 150000，越界会截断。`docs/concepts/soul.md` 原文："Short beats long. Sharp beats vague. Do **not** turn it into a life story, a changelog, a security policy dump."

### 问题诊断（老板团队）

1. **SOUL.md 胀库**——wairesearch 的 SOUL 有 ≈ 4000 字，含"大任务协议"、"卷王小组模式"、"搜索策略"、"规则"。这些都是**工作流**，应放 AGENTS.md；SOUL 里只留"研究员风格、语气、思维体系"。
2. **AGENTS.md 空壳**——几乎所有五岳的 AGENTS.md 只有 5-10 行"职责"，导致 Claude 每次都要从 SOUL 里反推规则。
3. **BOOTSTRAP.md 没删**——每次 turn 都注入一次首启仪式，30 天后还在烧 token。
4. **IDENTITY.md 当小作文写**——老板的 wairesearch/IDENTITY.md 有 1 段描述，但 `agents set-identity --from-identity` 只读 name/theme/emoji/avatar 这 4 个字段。多余内容白占 context。

### 最佳实践

| 落地动作 | 命令/路径 |
|---------|----------|
| **拆分五岳 SOUL/AGENTS**：把"工作流、规则、铁律"从 SOUL 搬到 AGENTS；SOUL 压到 ≤ 1000 字，只留语气和思维 | `workspace-<agent>/SOUL.md` & `AGENTS.md` |
| **删除完成后的 BOOTSTRAP.md** | `rm ~/.openclaw/workspace-*/BOOTSTRAP.md` |
| **IDENTITY.md 严格四段式** | `name:`/`theme:`/`emoji:`/`avatar:` 只这 4 行 |
| **workspace git 仓库化** | 每个 workspace 独立 `git init`，主库在 `openclaw_daily_file`（已存在），人设改动走 PR |
| **MEMORY.md 体检**：定期 `wc -w`，>2000 字要压缩 | `for w in workspace-*; do wc -w $w/MEMORY.md; done` |
| **监控注入预算** | `/context list` 或 `/context detail` 在主 agent 里检查每个 bootstrap 文件占了多少 token |

### 共享 vs 独立定义的权衡

- **共享定义**：统帅+五岳都放 Telegram 直聊、都要 `session_status`/`memory_search`/`web_search_plus` —— 放 `agents.defaults` 配置里（见 `docs/gateway/configuration-reference.md`）
- **独立定义**：`SOUL`/`AGENTS` 绝不共享，因为这是五岳人格区分的唯一载体
- **灰色地带**：`TOOLS.md`（搜索策略、provider 限额）——现在每个 agent 都抄一份，**建议**抽成 `~/.agents/skills/team-search-strategy/SKILL.md`，agent 显式读取，避免漂移

---

## 2. 记忆系统架构

### OpenClaw 的记忆三层（来自 `docs/concepts/memory.md`）

```
┌────────────────────────────────────────────────────────────────────────┐
│ 层 1：MEMORY.md（长期）   每次 DM session 注入，持久事实+偏好+决策       │
│ 层 2：memory/YYYY-MM-DD.md（短期）  今天+昨天自动注入，日志型             │
│ 层 3：memory_search / memory_get（按需语义检索）不走 bootstrap           │
│ 层 4：DREAMS.md（可选）  dreaming 审查面（人工 review）                  │
│ 层 5：memory-wiki（可选插件）结构化 claims+evidence 知识库                │
└────────────────────────────────────────────────────────────────────────┘
```

关键设计：**模型只记得写进文件的东西**，没有隐藏 state。Dreaming 在 `0 3 * * *` 跑 light→REM→deep 三阶段，deep 写 MEMORY.md（需要 recall≥3、uniqueQueries≥3、score≥0.8）。

### 问题诊断

1. **五岳记忆完全隔离**——每个 workspace 一套 MEMORY.md，五岳之间的集体知识（比如"web-search-plus 路由策略"、"老板的真实偏好"）无法共享。
2. **MEMORY.md 没启用 dreaming**——当前 memory 只有手工 `write` 进去，没有评分、去重、合并。几个月后必然野蛮生长。
3. **lossless-claw 长对话压缩**——老板已有 SKILL 但缺乏使用规范。

### 最佳实践

| 方案 | 适用场景 | 配置 |
|------|---------|------|
| **团队共享知识库**：用 `agents.defaults.memorySearch.qmd.extraCollections` 让五岳能搜统帅的 transcripts | 需要跨 agent 搜索会议记录 | 见 `docs/concepts/multi-agent.md#cross-agent-qmd-memory-search` |
| **开启 dreaming 自动促化**：统帅先开，观察 7 天再推广 | MEMORY.md 质量提升 | `plugins.entries.memory-core.config.dreaming.enabled: true` |
| **共享 wiki 作为团队长期脑**：用 `memory-wiki` 插件 + `wiki-maintainer` skill（老板已装）| 结构化、带来源、可追溯 | `openclaw wiki init` → 五岳用 `wiki_search`/`wiki_apply` |
| **lossless-claw 规范**：仅在单轮 agent run 超长时用（>100 messages），不要跨会话乱搜 | 压缩长对话取回关键事实 | 已经有 SKILL.md，老板的 wairesearch SOUL 里已说明 `lcm_grep` / `lcm_expand_query` 用法 |

### 同步 vs 隔离策略（推荐三层）

1. **完全隔离**：每个 agent 的 `memory/YYYY-MM-DD.md` 日志 —— 保留专业性
2. **只读共享**：`shared/knowledge/` 目录放团队事实（决策、客户偏好）——五岳通过 `read` 访问
3. **结构化共享**：memory-wiki vault 放在 `~/.openclaw/wiki/`（bridge mode 映射到五岳），claims 带 provenance

### 落地动作

```bash
# 1. 统帅开启 dreaming，先小规模试验
openclaw configure  # 进入 memory-core 配置
# 改 plugins.entries.memory-core.config.dreaming.enabled = true

# 2. 建立团队共享知识目录
mkdir -p ~/.openclaw/shared/knowledge
echo "# 团队共享事实（只读，由统帅维护）" > ~/.openclaw/shared/knowledge/README.md

# 3. MEMORY.md 体检（放进 cron）
openclaw cron add memory-health --schedule "0 9 * * 1" \
  --command "for w in ~/.openclaw/workspace-*; do echo \$w: \$(wc -w < \$w/MEMORY.md) words; done"

# 4. wiki-maintainer 规范化
openclaw skills install wiki-maintainer  # 已装
# 每周一次让 waicode 清理 wiki
```

---

## 3. Skill 与 Tool 治理

### 现状（老板 60+ skills）

从 `<available_skills>` 看，老板有：
- **OpenClaw 原生**：obsidian-vault-maintainer / wiki-maintainer / lossless-claw / gh-issues / healthcheck / node-connect / skill-creator / taskflow / taskflow-inbox-triage / tmux / video-frames / weather
- **工作流**：agent-browser / agent-commons / agent-team-orchestration / canvas-design / cctv-news-fetcher / crawl4ai-skill / doc-coauthoring / docx / nova-canvas / pdf / pptx / project-cerebro / prompt-engineering-expert / security-best-practices / stable-image-ultra / tavily / todoist / web-search-plus / xai-search / xlsx
- **飞书生态**：30+ lark-* skills

### OpenClaw Skill 加载层级（`docs/tools/skills.md`）

precedence（高→低）：
```
<workspace>/skills → <workspace>/.agents/skills → ~/.agents/skills 
  → ~/.openclaw/skills → bundled → skills.load.extraDirs
```

**关键洞察**：同名 skill 按 precedence 择高而用，**不会合并**。

### 问题诊断

1. **每个 agent 看 60+ skills 就浪费 prompt**——`<available_skills>` 块每次都注入，Opus 下一次对话要耗 ≈ 3000 tokens
2. **五岳都装了同一个 web-search-plus 但每个 workspace 又有一份**——冗余维护
3. **没有 allowlist 控制**——wairesearch 不需要 docx/pptx/xlsx，但现在都能看到

### 最佳实践（高杠杆）

| 动作 | 配置位置 | 收益 |
|------|---------|------|
| **启用 agent skill allowlist** | `agents.list[].skills: [...]` | 每个 agent 只看必需 skills，prompt 瘦身 60%+ |
| **统一共享 skills 根** | 所有团队级 skill 放 `~/.openclaw/skills/`（已有） | 一次更新，五岳全部生效 |
| **专属 skills 放 workspace** | `workspace-wairesearch/skills/`：研究员专属 prompts 模板 | 高 precedence，不影响其它 agent |
| **用 skill-creator 做 audit** | 老板已装 | 定期跑一次："这个 skill 还有人用吗？" |

### 推荐 allowlist 矩阵（落地给老板）

```json5
// ~/.openclaw/openclaw.json
{
  agents: {
    defaults: {
      // 所有 agent 共享的最小集
      skills: ["lossless-claw", "web-search-plus", "agent-commons", "healthcheck"]
    },
    list: [
      {
        id: "main",  // 统帅：需要编排 + 所有能力
        skills: ["*"]  // 或留空表示不限
      },
      {
        id: "wairesearch",
        skills: ["web-search-plus", "tavily", "xai-search", "crawl4ai-skill",
                 "lossless-claw", "agent-commons", "wiki-maintainer",
                 "obsidian-vault-maintainer", "prompt-engineering-expert"]
      },
      {
        id: "waicode",
        skills: ["github", "gh-issues", "skill-creator", "security-best-practices",
                 "taskflow", "lossless-claw", "tmux", "healthcheck"]
      },
      {
        id: "bizstrategy",
        skills: ["web-search-plus", "tavily", "xai-search",
                 "docx", "pdf", "pptx", "xlsx", "doc-coauthoring",
                 "lossless-claw"]
      },
      {
        id: "product",
        skills: ["web-search-plus", "canvas-design", "nova-canvas", "stable-image-ultra",
                 "doc-coauthoring", "prompt-engineering-expert", "lossless-claw"]
      },
      {
        id: "growth",
        skills: ["web-search-plus", "tavily", "todoist", "doc-coauthoring",
                 "cctv-news-fetcher", "lossless-claw"]
      }
    ]
  }
}
```

**预估效果**：每 agent 看到的 skill 从 60+ 降到 8-12 个，system prompt 注入从 ≈ 3 KB 降到 ≈ 500 B，单 turn 省 **2.5K tokens ≈ $0.04（Opus）**，一天 100 turns = $4/天节省，一个月 $120。

### TOOLS.md 活文档

`TOOLS.md` 不控制工具可用性，只是注释层。建议做法：

```bash
# 每个 workspace 的 TOOLS.md 都 include 一份团队级模板
# 方式 1：用 git submodule
# 方式 2：用 cron 定时 sync
openclaw cron add tools-sync --schedule "0 * * * *" \
  --command "cp ~/.openclaw/shared/TOOLS-template.md workspace-*/TOOLS.md"
```

---

## 4. 配置与权限治理（Per-agent model / thinking / toolsAllow / 工作区隔离）

### 官方能力（`docs/concepts/multi-agent.md` + `docs/tools/multi-agent-sandbox-tools.md`）

每个 agent 可以有：
- `model`（默认继承 `agents.defaults.model`）
- `workspace`（独立）
- `agentDir`（独立，**绝不共享**，auth+sessions 会冲突）
- `sandbox: { mode: "off"|"on"|"all", scope: "agent"|"shared" }`
- `tools: { allow: [...], deny: [...] }`——deny wins
- `subagents: { allowAgents, model, thinking, runTimeoutSeconds, requireAgentId, archiveAfterMinutes }`
- `groupChat: { mentionPatterns }`
- `skills: [...]`（allowlist）

### 问题诊断

- 老板现在所有五岳都 `claude-opus-4.6`，**没有分层**。research 用 Opus 合理，但 growth 写社媒文案/待办整理不需要 Opus。
- `tools.allow/deny` 没设——理论上五岳都能执行 `exec`，如果被 prompt 注入可以写破坏主机。
- `agentDir` 分开（每个 agent 一个）——已经对了。

### 最佳实践

```json5
{
  agents: {
    defaults: {
      model: "claude-sonnet-4-6",   // 底线降到 Sonnet
      thinking: "medium",
      subagents: {
        maxConcurrent: 4,           // 从默认 8 收紧到 4，避免把 Bedrock 打爆
        maxSpawnDepth: 2,           // 允许统帅→五岳→子研究员，但就两层
        runTimeoutSeconds: 900,     // 默认 15 分钟
        archiveAfterMinutes: 120,
        requireAgentId: true        // 强制必须显式指定 agentId
      }
    },
    list: [
      { id: "main", model: "claude-opus-4-6", thinking: "high" },
      { id: "wairesearch", model: "claude-opus-4-6", thinking: "medium" },   // 研究要 Opus
      { id: "waicode", model: "claude-opus-4-6", thinking: "medium" },       // 代码要 Opus
      { id: "bizstrategy", model: "claude-opus-4-6", thinking: "medium" },
      { id: "product", model: "claude-sonnet-4-6", thinking: "low" },        // 设计/文案 Sonnet 够
      { id: "growth", model: "claude-sonnet-4-6", thinking: "low" },         // 增长监测 Sonnet
      { id: "clawdoctor", model: "claude-haiku-4-6", thinking: "off",        // 诊断工具用 Haiku 就行
        tools: { deny: ["write", "edit", "apply_patch"] }  // 只读型
      }
    ]
  }
}
```

**估算月成本节省**：Opus → Sonnet 约 **1/5 价格**（Opus $15/$75 vs Sonnet $3/$15 per MTok），product/growth 迁到 Sonnet 后，每月这两个 agent 的推理费下降 80%。

### Authorized Senders / 安全边界

- 每个 channel account 都应设 `dmPolicy: "allowlist"` 或 `"pairing"`
- `tools.agentToAgent.enabled` 默认 false，**要开也要走 allowlist**
- `tools.exec.ask / tools.exec.security` 受保护，config 层改不了，必须通过 `openclaw configure` 交互

---

## 5. 可观察性（失败复盘的基础设施）

### 可用命令（`docs/cli/sessions.md`、`docs/cli/logs.md`）

```bash
# 查看团队整体状态
openclaw sessions --all-agents              # 所有 agent 的 session 列表
openclaw sessions --all-agents --active 30  # 近 30 分钟活跃
openclaw sessions --all-agents --json | jq  # 机读格式

# 单 session 深查
openclaw sessions --store <path>
/status    # 当前 session 卡片（内嵌 slash）
/context list    # 看 bootstrap 注入占比

# subagent 追踪
/subagents list              # 当前 session 的子
/subagents info <id>         # 拿 transcript 路径
/subagents log <id> 500 tools
/subagents kill <id>         # 停某个
/subagents kill all          # 全停

# 日志
openclaw logs --tail 200
openclaw logs --level error --since 1h
openclaw status              # 整体健康
openclaw health              # 扩展 health check
openclaw doctor              # 环境诊断（老板有 clawdoctor 专职 agent）
```

### 老板团队现状

1. **没有每周复盘节奏**——失败的 sessions 仍在 disk 上但没人看
2. **子 agent 超时很难发现**——除非主 agent 记得 `subagents log`
3. **cron 跑失败没报警**

### 最佳实践（给统帅）

| 节奏 | 动作 | 工具 |
|------|------|------|
| **每 turn** | 主 agent 跑 `session_status` 看 token 用量是否异常 | session_status |
| **每日** | 统帅看 `openclaw sessions --all-agents --active 1440 --json` 找 timeout | sessions |
| **每周** | clawdoctor 跑 `openclaw doctor` + 检查 MEMORY.md 膨胀 | cron 定时 |
| **每月** | 清理 archived subagents（超过 30 天）| `openclaw sessions cleanup --enforce` |

### 失败复盘 checklist

当一个 subagent 失败：
1. `/subagents info <id>` → 拿 transcript 路径
2. `cat <transcript-path>` → 读末尾 50 行找 error
3. 检查是否：timeout（看 stats 行 runtime vs runTimeoutSeconds）、tool deny（看 deny list）、context overflow（bootstrapTotalMaxChars 触发）、provider 错（看 `models.json` 状态）
4. 把教训写进 `shared/incidents/YYYY-MM-DD-<题目>.md`
5. 如果是系统性问题，改 `AGENTS.md` 添加预防规则

### 落地动作

```bash
# 1. 启用 failureAlert（见 Part 3）
# 2. 每周日跑复盘 cron
openclaw cron add weekly-review --schedule "0 20 * * 0" \
  --agent main --mode session \
  --message "复盘本周：跑 openclaw sessions --all-agents --json，找出失败和超时的 subagent，给我 top 5 问题清单"

# 3. transcripts 归档
# 自动 archiveAfterMinutes 已在 agents.defaults.subagents 里设了
```

---

## 📌 Part 1 小结（可维护性）

**Top 3 立即做**：
1. **AGENTS/SOUL 拆分整顿** —— wairesearch/SOUL.md 瘦身 70%，工作流搬到 AGENTS.md（立省每 turn 1K+ tokens 注入）
2. **agent skill allowlist** —— 按角色限制 skills，每个 agent 从 60+ 降到 8-12 个（每月省 ≈ $120）
3. **模型分层** —— product/growth/clawdoctor 从 Opus 降级，推理成本降 80%

**Top 3 下一步**：
4. 启用 dreaming（先 main 试验）
5. 建立团队共享 wiki vault（memory-wiki 插件）
6. clawdoctor 周度健康巡检 cron

---
*产出人：黄山 | 日期：2026-04-19*
