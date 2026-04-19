# Part 5 — 老板团队落地：诊断 · 路线图 · 反模式 · 配置样本

---

## 1. 老板团队当前诊断（基于本次调研）

### 已做对的（继承保留）

- ✅ **统帅-专家模式**：main agent 做编排，五岳做执行 —— 符合 Anthropic research system 架构
- ✅ **专家间不直接通信**：通过 `shared/` 文件 —— 规避 AutoGen echo chamber 反模式
- ✅ **workspace 独立**：每个 agent 一个 workspace + agentDir —— OpenClaw 推荐配置
- ✅ **铁律清单**（永不递归、必须 yield、无状态、单向通信、状态同步）—— 是 2026 年 multi-agent 的正确姿势
- ✅ **资料库进 git**（openclaw_daily_file）—— workspace 备份最佳实践
- ✅ **SOUL.md 有明确"大任务协议"** —— 对应 Cognition "share full trace" 的变体

### 需要改进的（本报告建议的高杠杆动作）

| 维度 | 现状 | 问题 | 目标 |
|------|------|------|------|
| 模型分层 | 全 Opus 4.7 | 月成本过高（≈$4K）| Opus 主+核心 / Sonnet 次要 / Haiku 诊断，省 23%+ |
| Skill allowlist | 全部 60+ 对每个 agent 开放 | 每 turn prompt 注入 3KB | 按角色 allowlist，注入降 80% |
| SOUL/AGENTS 边界 | SOUL 塞工作流（4000+字）| cache 命中率低 + token 浪费 | SOUL ≤1000字，工作流搬到 AGENTS |
| runTimeoutSeconds | 默认 0（不超时）| subagent 卡死无保护 | 按任务类型设 300-1800s |
| Tool 权限分层 | 全 agent 可 exec | Prompt 注入风险 | 除 main/waicode 外 deny exec |
| 搜索降级链 | TOOLS.md 提到但未系统化 | 限速可能全团队瘫痪 | 每 AGENTS.md 写明降级链 |
| failureAlert | 未配 | 失败无感知 | 配置 failureDestination |
| cron 批处理 | 未使用 | 每日复盘要手动做 | Haiku + isolated 定时跑 |
| dreaming | 未开启 | MEMORY.md 野蛮增长 | 主 agent 先试 7 天 |
| cache boundary 保护 | MEMORY.md 常改 | prompt cache 命中率低 | MEMORY.md 批量改（cron 夜间 rebuild）|

---

## 2. 三个月优化路线图

### 📅 第 1 月：**基础加固**（重要性：必须做）

**Week 1（快速止血）**
- [ ] 设 `agents.defaults.subagents.runTimeoutSeconds: 900`
- [ ] 设 `cron.failureDestination: { channel: telegram, to: <boss> }`
- [ ] 所有 workspace 的 `BOOTSTRAP.md` 删除（已完成首启）
- [ ] `IDENTITY.md` 只保留 name/theme/emoji/avatar 四行

**Week 2（模型分层）**
- [ ] product / growth 降到 Sonnet 4.6
- [ ] clawdoctor 降到 Haiku 4.6
- [ ] `agents.defaults.subagents.model: sonnet`（子 agent 默认 Sonnet）
- [ ] 观察一周质量变化，回滚不达标的

**Week 3（权限与安全）**
- [ ] wairesearch / bizstrategy / product / growth 加 `tools.deny: ["exec", "apply_patch"]`
- [ ] 只有 main + waicode 可 exec（main yolo / waicode ask=on）
- [ ] 每 AGENTS.md 加"搜索降级链"和"安全铁律"段

**Week 4（可观察性）**
- [ ] `openclaw sessions --all-agents --json` 跑一遍摸底
- [ ] `openclaw cron add gw-heartbeat` 每 5 分钟健康检查（Haiku）
- [ ] 周日晚 20:00 统帅跑自动复盘 cron（读 sessions list）
- [ ] 建立 `shared/incidents/` 目录记录失败

**月末验收**：
- 月度推理成本下降 ≥ 20%
- 零次 subagent 无限卡死
- 复盘节奏开始自动化

### 📅 第 2 月：**结构化提升**

**Week 5-6（SOUL/AGENTS 重构）**
- [ ] wairesearch：SOUL 瘦身到 ≤1000 字（只留语气/思维），其余搬 AGENTS
- [ ] 五岳都做同样的重构（团队共识先达成再动）
- [ ] 工作流模板抽出来：`~/.openclaw/shared/workflows/` 存"大任务协议"、"卷王模式"等
- [ ] 把这个目录做成 skill：`~/.agents/skills/team-workflows/SKILL.md`

**Week 7（Skill 治理）**
- [ ] 按本报告矩阵配 `agents.list[].skills` allowlist
- [ ] 用 skill-creator 跑一次 audit：哪些 skill 还没用过
- [ ] 老板亲自过一遍 60+ skill 列表，淘汰"看着好但实际不用"的

**Week 8（上下文效率）**
- [ ] 统帅 AGENTS.md 新增："spawn 前必写 shared/context/TASK-XXX.md"
- [ ] 设计任务模板（上文 Part 3 的 prompt 模板）
- [ ] 监控 cache hit rate（看 session_status 卡片）

**月末验收**：
- SOUL.md 平均长度 ≤ 1200 字
- 每个 agent 看到的 skill 数 ≤ 15
- prompt cache hit rate ≥ 30%

### 📅 第 3 月：**智能化与演进**

**Week 9-10（记忆系统升级）**
- [ ] 统帅开启 dreaming（`plugins.entries.memory-core.config.dreaming.enabled: true`）
- [ ] 观察 DREAMS.md 的 deep 促化质量，满意后推广到五岳
- [ ] 建立团队共享 wiki：`openclaw wiki init` + `wiki-maintainer` skill 每周维护

**Week 11（流水线自动化）**
- [ ] 把常见研究模式做成 cron + sub-agent 组合模板
  - 例：每日科技简报（cron @ 07:00 → spawn wairesearch → announce telegram）
  - 例：每周团队复盘（cron @ 周日20:00 → spawn main → 合成报告）
- [ ] Gmail PubSub hook 集成（如老板用 gmail）

**Week 12（演化与优化）**
- [ ] 写 `shared/postmortem.md`：三个月哪些假设对了、哪些错了
- [ ] 评估是否需要增加 agent 或合并 agent
- [ ] 上 Bedrock fallback chain（us-west-2 / us-east-1 / 直连）

**月末验收**：
- MEMORY.md 自动促化跑稳
- 至少 3 个 cron 流水线 production 化
- 团队月成本较现状下降 30%+，质量不降

---

## 3. 反模式清单（踩坑汇总）

### 编排反模式

1. **同一任务并行拆成多个子 agent**（Cognition 反对）
   - ❌ "waicode 写前端 + waicode 另一个 session 写后端" → 风格假设冲突
   - ✅ 统帅串行："先 spawn waicode 写后端 → yield → 读结果 → spawn waicode 写前端（带后端 API）"

2. **不传 trace 给子 agent**
   - ❌ `sessions_spawn task="调研 React 18"` 什么背景都不给
   - ✅ `task="参考 shared/context/TASK-042.md 的前情，调研 React 18 的 Suspense，补 boundary 对性能影响"`

3. **轮询等 subagent 完成**
   - ❌ `while: sessions_list()` → 浪费 token，限速
   - ✅ `sessions_yield()` 等 push

### 配置反模式

4. **多 agent 共享 agentDir**（文档明确警告）
   - ❌ 两个 agent 用同一个 `agentDir` → auth 冲突
   - ✅ 每个 agent 独立 `~/.openclaw/agents/<id>/agent`

5. **MEMORY.md 无限膨胀**
   - ❌ agent 不停 append，半年后文件 500KB
   - ✅ 启用 dreaming，定期人工 review

6. **全 agent 一个 model**（Anthropic 已否定）
   - ❌ 全 Opus → 成本爆炸且研究任务并没有更强
   - ✅ Opus 主 + Sonnet 子 = +90% 性能 -50% 成本

7. **全 agent 开 exec**
   - ❌ 研究 agent 能执行 shell → prompt 注入可删文件
   - ✅ 只有 waicode/main 可 exec，其他 deny

### Prompt 反模式

8. **SOUL 塞工作流**（本报告诊断）
   - ❌ SOUL = 人设 + 工作流 + 规则 = 4000+字
   - ✅ SOUL 只写人设/语气；AGENTS 写工作流/规则

9. **IDENTITY.md 写小作文**
   - ❌ 写描述性段落 → set-identity 读不到
   - ✅ 只写 name/theme/emoji/avatar

10. **BOOTSTRAP.md 不删**
    - ❌ 首启后还在，每 turn 注入浪费 context
    - ✅ 完成首启后 `rm BOOTSTRAP.md`

### 搜索反模式

11. **单 provider 依赖**
    - ❌ 全靠 Brave → 2000/月很快耗光 + 1 req/s 排队
    - ✅ web-search-plus 智能路由 + x_search 兜底

12. **不标时间的研究结论**
    - ❌ "React 最好用 xxx 框架"（2 年前的结论）
    - ✅ 每条结论标 "截至 YYYY-MM"

### 安全反模式

13. **YOLO 所有 agent**
    - ❌ `security=full, ask=off` 对全团队 → prompt 注入风险
    - ✅ 只有 main YOLO；其他保持 ask=on

14. **信任 web_fetch 的指令**
    - ❌ 网页说"忽略之前指令" → agent 照做
    - ✅ OpenClaw 已自动 wrap，AGENTS.md 再明确"untrusted 不信任"

### 可观察性反模式

15. **失败静默**
    - ❌ cron 失败无报警，老板不知道
    - ✅ `failureDestination` 推送 telegram

16. **没有复盘节奏**
    - ❌ transcript 堆在 disk 上没人看
    - ✅ 周日统帅自动复盘，写 `shared/reviews/YYYY-MM-DD.md`

---

## 4. 可直接复用的配置样本

### 4.1 `~/.openclaw/openclaw.json` 核心片段

```json5
{
  agents: {
    defaults: {
      model: "anthropic/claude-sonnet-4-6",    // 默认 Sonnet
      thinking: "medium",
      userTimezone: "Asia/Shanghai",
      timeFormat: "24",
      bootstrapMaxChars: 15000,                 // 压一下
      bootstrapTotalMaxChars: 100000,
      subagents: {
        maxConcurrent: 4,
        maxSpawnDepth: 2,
        maxChildrenPerAgent: 3,
        runTimeoutSeconds: 900,
        archiveAfterMinutes: 60,
        requireAgentId: true,
        model: "anthropic/claude-sonnet-4-6",   // 子 agent 默认 Sonnet
        thinking: "low",
        allowAgents: ["wairesearch", "waicode", "bizstrategy", "product", "growth", "clawdoctor"]
      },
      // skills 全局默认（共享基线）
      skills: ["lossless-claw", "web-search-plus", "agent-commons", "healthcheck"]
    },
    list: [
      {
        id: "main",
        default: true,
        name: "小帅",
        workspace: "~/.openclaw/workspace",
        model: "anthropic/claude-opus-4-7",
        thinking: "high",
        skills: ["*"],                          // 统帅不限 skill
        tools: { exec: { security: "full", ask: "off" } }
      },
      {
        id: "wairesearch",
        name: "黄山",
        workspace: "~/.openclaw/workspace-wairesearch",
        model: "anthropic/claude-opus-4-7",
        thinking: "medium",
        skills: ["web-search-plus", "tavily", "xai-search", "crawl4ai-skill",
                 "lossless-claw", "agent-commons", "wiki-maintainer",
                 "obsidian-vault-maintainer", "prompt-engineering-expert"],
        tools: { deny: ["exec", "apply_patch"] }
      },
      {
        id: "waicode",
        name: "泰山",
        workspace: "~/.openclaw/workspace-waicode",
        model: "anthropic/claude-opus-4-7",
        thinking: "medium",
        skills: ["github", "gh-issues", "skill-creator", "security-best-practices",
                 "taskflow", "lossless-claw", "tmux", "healthcheck"],
        tools: { exec: { security: "restricted", ask: "on" } }
      },
      {
        id: "bizstrategy",
        name: "华山",
        workspace: "~/.openclaw/workspace-bizstrategy",
        model: "anthropic/claude-opus-4-7",
        thinking: "medium",
        skills: ["web-search-plus", "tavily", "xai-search",
                 "docx", "pdf", "pptx", "xlsx", "doc-coauthoring", "lossless-claw"],
        tools: { deny: ["exec", "apply_patch"] }
      },
      {
        id: "product",
        name: "天山",
        workspace: "~/.openclaw/workspace-product",
        model: "anthropic/claude-sonnet-4-6",
        thinking: "low",
        skills: ["web-search-plus", "canvas-design", "nova-canvas", "stable-image-ultra",
                 "doc-coauthoring", "prompt-engineering-expert", "lossless-claw"],
        tools: { deny: ["exec"] }
      },
      {
        id: "growth",
        name: "衡山",
        workspace: "~/.openclaw/workspace-growth",
        model: "anthropic/claude-sonnet-4-6",
        thinking: "off",
        skills: ["web-search-plus", "tavily", "todoist", "doc-coauthoring",
                 "cctv-news-fetcher", "lossless-claw"],
        tools: { deny: ["exec", "apply_patch", "browser"] }
      },
      {
        id: "clawdoctor",
        name: "Doctor",
        workspace: "~/.openclaw/workspace-clawdoctor",
        model: "anthropic/claude-haiku-4-6",
        thinking: "off",
        skills: ["healthcheck", "lossless-claw"],
        tools: {
          allow: ["read", "exec", "process"],
          deny: ["write", "edit", "apply_patch"]
        }
      }
    ]
  },

  // 搜索/工具全局
  tools: {
    agentToAgent: { enabled: false },            // 保持 false，强制单向
    exec: {
      security: "restricted",
      ask: "on",
      askFallback: "restricted",
      host: "gateway"
    }
  },

  // cron 失败报警
  cron: {
    enabled: true,
    retry: { maxAttempts: 3, backoffSeconds: 60 },
    failureDestination: {
      channel: "telegram",
      to: "<boss-chat-id>"
    }
  },

  // 记忆（试 dreaming）
  plugins: {
    entries: {
      "memory-core": {
        config: {
          dreaming: {
            enabled: true,
            frequency: "0 3 * * *"
          }
        }
      }
    }
  }
}
```

### 4.2 Cron 样本（老板拿来即用）

```bash
# 1. 网关心跳（Haiku，每 5 分钟，月成本 <$1）
openclaw cron add gw-heartbeat \
  --cron "*/5 * * * *" \
  --session isolated \
  --message "跑 openclaw gateway status，如果非 active 则 announce 'GATEWAY DOWN'" \
  --light-context --tools exec \
  --model "anthropic/claude-haiku-4-6" \
  --announce --channel telegram --to "<boss>"

# 2. 每日科技简报（早上 7 点，Opus）
openclaw cron add daily-tech-brief \
  --cron "0 7 * * *" --tz "Asia/Shanghai" \
  --session isolated \
  --agent wairesearch \
  --message "调研昨晚全球 AI/科技领域要闻 TOP 5，写入 shared/briefs/$(date +%F).md，200 字以内 summary 直接回复" \
  --model "anthropic/claude-opus-4-7" \
  --thinking "medium" \
  --announce --channel telegram --to "<boss>"

# 3. 周日复盘（20:00）
openclaw cron add weekly-review \
  --cron "0 20 * * 0" --tz "Asia/Shanghai" \
  --session isolated \
  --agent main \
  --message "复盘本周：跑 openclaw sessions --all-agents --active 10080 --json，找失败/超时/重试的子 agent，写出 top 5 问题 + 改进建议，存 shared/reviews/$(date +%F).md" \
  --model "anthropic/claude-sonnet-4-6" \
  --announce --channel telegram --to "<boss>"

# 4. MEMORY.md 体检（每周一 9:00）
openclaw cron add memory-health \
  --cron "0 9 * * 1" --tz "Asia/Shanghai" \
  --session isolated \
  --agent clawdoctor \
  --message "检查所有 workspace 的 MEMORY.md 大小（wc -w），超过 2000 字的列出，写到 shared/health/memory-$(date +%F).md" \
  --light-context --tools exec,read,write \
  --model "anthropic/claude-haiku-4-6" \
  --announce --channel telegram --to "<boss>"
```

### 4.3 Shared 文件夹结构（推荐）

```
~/.openclaw/shared/
├── README.md                      # 目录导航
├── context/                       # 统帅派发子任务前写入
│   └── TASK-<id>.md               # 背景 + 决策 + 约束
├── artifacts/                     # 子 agent 产出
│   └── TASK-<id>/
│       ├── plan.md
│       ├── part-N.md
│       └── report.md
├── status/                        # 各 agent 实时状态
│   ├── wairesearch/current.md
│   ├── waicode/current.md
│   └── ...
├── knowledge/                     # 只读团队事实
│   ├── team-principles.md
│   ├── client-profiles.md
│   └── tool-inventory.md
├── briefs/                        # cron 日报
│   └── YYYY-MM-DD.md
├── reviews/                       # 周度复盘
│   └── YYYY-MM-DD.md
├── incidents/                     # 失败复盘
│   └── YYYY-MM-DD-<topic>.md
└── health/                        # 健康巡检
    └── *.md
```

### 4.4 统帅 AGENTS.md 核心片段（参考模板）

```markdown
# Agent: main（小帅）

Role: 团队统帅，负责任务分解、派发、审核、合成。

## 铁律
1. **永不递归**：不 spawn 同名 agent 自己
2. **必须 yield**：spawn 后立即 sessions_yield，不轮询
3. **专家无状态**：派发必须显式传 context（shared/context/TASK-XXX.md）
4. **单向通信**：不开 agentToAgent，专家间通过 shared/ 异步同步
5. **状态同步**：从 shared/status/*/current.md 读各 agent 状态

## 派发工作流
1. 判断是否需要 sub-agent（简单任务自己做）
2. 如需派发：
   a. 生成 TASK-ID：TASK-<YYYYMMDD-HHMM>
   b. 写 shared/context/TASK-ID.md（背景、决策、约束、产出规范、质量门）
   c. sessions_spawn with agentId + task="参考 shared/context/TASK-ID.md 完成任务"
   d. 设 runTimeoutSeconds（按任务类型，参考表）
3. sessions_yield 等 announce
4. 下一 turn 收到 announce：
   a. 读 announce Status（runtime 信号）
   b. Status=success：读 shared/artifacts/TASK-ID/report.md，审核
   c. Status=timeout/error：读 transcript 判断是否可重试
5. 审核三层：
   - 结构：文件是否存在、schema 是否满足
   - 内容：来源、数据、逻辑
   - 不合格：/subagents steer 或重新 spawn

## 降级链
- 搜索：web-search-plus → web_search → x_search
- 模型：Opus → Sonnet → Haiku
- 区域：Bedrock us-west-2 → us-east-1 → 直连 Anthropic

## 模型分工（speed × cost × quality 甜区）
- 自己（编排）：Opus 4.7, thinking=high
- wairesearch/waicode/bizstrategy（核心专业）：Opus 4.7
- product/growth：Sonnet 4.6
- clawdoctor：Haiku 4.6
- sub-agents 子研究员：Sonnet 4.6
```

---

## 📌 Part 5 小结

- **3 个月路线图**分三段：加固（省钱、防卡死）→ 重构（SOUL/AGENTS/Skills）→ 智能化（dreaming/cron 流水线）
- **16 条反模式清单**覆盖编排/配置/prompt/搜索/安全/可观察性
- **配置样本**可直接复制到 `~/.openclaw/openclaw.json`
- 核心原则：**规避**（反模式）+ **杠杆**（高 ROI 动作）+ **演进**（渐进式）

---
*产出人：黄山 | 日期：2026-04-19*
