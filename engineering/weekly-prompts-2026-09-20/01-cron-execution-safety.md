# 定时研究任务执行入口

> 本文件是现有 Cron 的兼容入口，不再维护另一套执行规则。适用于研究周报/报告类 isolated Cron；普通备份、提醒和单命令任务不套用。

## 必须读取的已应用规范

执行主题 Prompt 前，完整读取并执行：

`/root/.openclaw/agents/main/agent/workshop-skills/cron-run-reliability/SKILL.md`

周报/研究报告还须完整读取同一技能的专项参考：

`/root/.openclaw/agents/main/agent/workshop-skills/cron-run-reliability/references/weekly-publication.md`

该技能是唯一执行规范：主文件负责工具边界、运行身份、阶段状态、完成标记、等待、恢复与终态；周报专项负责文章交接、配图及发布顺序，不再另设执行技能。二者已通过 Skill Workshop 应用；若必需文件不可读取，报告阻塞，不从历史对话或旧 Prompt 拼回另一套流程。本文和主题 Prompt 的“统一规范第1—7节”均指主文件；其中第4—6节明确路由到周报专项同名章节。冻结前格式预检及全部发布动作只引用周报专项，不在兼容入口或主题 Prompt 复制 CLI 参数、顺序或新分支。

- 固定机械助手的接口与证据边界：`/root/.openclaw/agents/main/agent/workshop-skills/cron-run-reliability/references/helper-contract.md`。
- 研究对象、时间窗、覆盖与深度目标、预算和路径：当前任务对应的主题 Prompt。
- 数据、来源、逐主张研究准出和必要阻断：`/root/.openclaw/agents/main/agent/workshop-skills/industry-research-evidence/SKILL.md`，不从旧主题阈值另建硬闸。
- 研究母稿至读者稿的内容交接：`/root/.openclaw/workspace/shared/prompts/_weekly-report2article-handoff.md`。
- 文章编辑与长文双向保真：`/root/.openclaw/workspace/skills/report2article/SKILL.md`。

## 既有任务接入

主题 Prompt 保留业务输入与交付参数，不自行重述等待、补派或发布分支。将同一执行规范主文件及周报专项路径传入研究、补缺和编辑子任务；正文分块、完整取证与信息保真标准不变。研究冻结后的文章低延迟编排、独立盲提取、分离写域、章节进度和最终全文核验统一读取 `_weekly-report2article-handoff.md`；资源不足时保持盲提取的输入隔离并串行执行，不扩容既有并发，不新增模型路由或超时设定。

互不依赖的已获准读取/检查可在同一工具轮次发出，依赖其结果的写入后置；等待阶段只核简洁进度与变化，最终验收仍完整读取必要输入。不得为提速引入临时脚本、长 shell 链或运行时未白名单的工具名。

所有阶段均按统一规范核对当前运行文件和质量证据，不能把 `.done`、调度器状态或最后一次工具结果当作整期完成证明。业务终态与调度器原生状态分开记录。

本次接入不新增执行器、调度任务或自动恢复服务，不修改全局并发、LCM、模型超时、主机配置或历史任务状态。

## 已知运行时陷阱

### isolated Cron 父级直接调用 `image_generate` 会把本次原生运行打成失败

证据（2026-09-18 全球AI+产业周报，run `20260918T110500+0800-404cbbf8`）：父级在 11:18:57 直接调用 `image_generate`，工具立即返回后台任务 id；但本 Cron 的 `toolsAllow` 不含 `sessions_yield`，父级无法让出回合声明，于是继续持有该会话直到 12:29。生图完成时，完成事件需要在该会话上起一个回合，撞上仍在活动的回合 → `ActiveTurnClaimError: Session ... already has an active turn claim` → 原生运行 `error` / `agent run aborted | OPENCLAW_DIRECT_ABORT`，而当时业务产物已基本完成。

对照实验：把同一张图交给一个专用子会话提交（子会话有 `sessions_yield`），提交后自动让出回合；完成事件在空闲的子会话上正常唤醒，无任何冲突。

因此：**配图必须由专用配图子会话提交生成，父级不得在本回合直接调用 `image_generate`**；父级在需要图片时自行核验并搬运文件。子会话的唤醒回合是只读的（无 write/exec），完成标记与文件搬运一律由父级落盘。

**不要为了等图给 Cron 父级放开 `sessions_yield`**：已实测让出会立即结束本次运行（会话在让出后立刻返回 `end_turn`），父级会在报告完成前收工。第3节对 isolated Cron 禁用 `sessions_yield` 的约束保持不变。

父级取图做法：在构建/发布阶段用一次 `ls /root/.openclaw/media/tool-image-generation/`（按本次 `filename` 前缀匹配）或读取配图子会话的 final 取得绝对路径，核验存在、非空、与本期内容相关后再复制到 `<RUN_DIR>` 与博客目标路径。取不到就按规范第5节降级用已授权 Stable Image Ultra，**绝不回头由父级直调 `image_generate`**。
