# 长时 Cron 执行规范的工具层优化（L1–L4）

> 变更对象：Workshop 技能 `cron-run-reliability`（7 份研究周报共用的唯一执行规范）。
> 变更性质：**纯规则条款就地扩写，不新增执行器、不改调度、不改代码。**
> 变更集：**2 个文件**（`SKILL.md`、`references/helper-contract.md`），其余 9 个文件逐字节未变。

---

## 一、要解决什么问题（第一性原理）

现行流程的**原子单位是"一整篇文档在一次模型回合内产出"**，而运行环境存在四条硬边界：

| 边界 | 实测值 | 撞上的后果 |
|---|---|---|
| 单回合输出上限 | ~4096 token | `stopReason=length`，输出半截 |
| 单次读取上限 | 2000 行 / 50KB | 静默截断，读进来即残本 |
| 单次运行墙钟 | 预算 7200s（有效任务实测 208–211 分钟） | 中途被掐 |
| 会话回合独占 | 异步完成事件需抢占回合 | `ActiveTurnClaimError` → 原生运行 `error`（2026-09-18 生图事故） |

由此得设计律：**原子单位必须 ≤ 最小硬边界，且"完成"必须是磁盘上的事实，而非上下文里的承诺。**

原有规则（"小步落盘"）方向正确，但它是**纪律**（靠模型自觉），不是**不变量**（工具契约保证）。本次把四项杠杆写进唯一权威规范。

---

## 二、四项改动

| 编号 | 杠杆 | 落地条款 | 作用 |
|---|---|---|---|
| **L1** | 换写原语 | §1 正文落盘条 | 写入一律"定位追加"（首块 `write` 建骨架 + 尾部锚点，其后 `edit`/`apply_patch` 续写）；**对已有内容的文件禁用 `write` 覆盖**。整文件重写被掐断即全丢（零字节落盘），定位追加只丢当前一块 → 损失从 100% 降到 1/N |
| **L2** | 完成即可声明 | §3 等待条 | 每个可独立完成的研究单元除载荷分片外另写 1 字节标记 `<RUN_DIR>/units/<单元名>.done`（**先载荷、后标记**）；等待可下沉到单元粒度；**续跑按集合差集执行**（期望标记集 − 已存在标记集 = 待做集） |
| **L3** | 读写窗口约束 | §1 同条 | 写入有界（约 4000 字符；文章编辑阶段 ≤3,500 字符）+ `read` 单次 2000 行/50KB 上限；**产出路径不让同一执行者"先读完全部输入、再一次性写大文件"**，长文按章节分派、父级拼装 |
| **L4** | 按"是否吃回合"选工具 | §1 一等工具条（+§5 指向通例） | 父级需等待的环节优先用阻塞型调用（`exec`/helper `wait`，进程存在并返回，不占回合）；提交后需唤醒回合的异步工具（生图类）一律交能让出的专用子会话；同步降级路径优先于再赌异步唤醒 |

---

## 三、实施方式

`SKILL.md` 属 **Workshop 技能**（`Source: openclaw-workshop`），**不能直接改文件**，须走"提案 → 应用"：

- 技能本次运行未被加载 → `prepare_patch`/`patch` 被拒（符合 `workshop-skill-edit` 第 1 节所述），改走 `propose-update`（完整正文提案）。
- 支持文件（7 参考 + 3 脚本）随提案整包提交，应用后逐文件比对哈希。

三轮提案（均 `scan: clean`，均经**正文 SHA 核验**，非按"已应用"回执采信）：

| 轮次 | 提案 ID | 应用时刻 (UTC) | 内容 |
|---|---|---|---|
| 1 | `cron-run-reliability-20260930-4b01457b33` | 02:22:35 | L1/L2/L3/L4 四处落地 |
| 2 | `cron-run-reliability-20260930-1200de02b9` | 02:26:18 | 复核修正：L3 限定为产出路径（不缩减终审）；L2 与生产者 `.done` 语义分离 |
| 3 | `cron-run-reliability-20260930-bd64dd88d4` | 02:29:39 | 复核修正：L2 单元标记命名隔离（独立子目录，不与发布契约重名）；helper 契约对齐 |

---

## 四、核验证据

### 4.1 改动前后 SHA256

| 文件 | 改前 | 改后 | 行数 | 字节 |
|---|---|---|---|---|
| `SKILL.md` | `dcb43573…7d50` | `016787d8…49fd` | 97 → 97 | 20235 → 22391 |
| `references/helper-contract.md` | `ffee8807…89d7` | `5a1ec711…419f` | 44 → 44 | 4117 → 4172 |

diff 规模：`SKILL.md` 3 个 hunk，`helper-contract.md` 1 个 hunk；**全部为就地扩写，行数均持平**。

### 4.2 生效核验（按正文 SHA，非回执）

提案正文与生效文件各取"标题行到结尾"同一段切片比对 SHA256，三轮**全部相同**；末轮 `142d987fcea2fbd3bdbfd5f129bbff90`。

### 4.3 调度零漂移（机器证明）

`openclaw cron list --json` 改前/改后快照**逐字节相同**（`sha256 a2bc4aab…1d9b`，16 个任务）；去除运行时易变字段后逐字段递归比对一致，任务名单一致。

> 证据包中的快照副本已**脱敏**：投递收件人标识替换为 `<redacted>`（同长度替换，脱敏后两份副本仍逐字节相同）；原始未脱敏快照仅存于本地备份目录，不入公开仓库。零漂移结论以原始快照 SHA256 为准（见包内 `evidence/cron-drift-proof.txt`）。

### 4.4 影响面隔离

- 7 份主题 Prompt、共享规范 `_cron-execution-safety.md`、交接协议 `_weekly-report2article-handoff.md`：**10 份文件全部逐字节未变**。
- 7 份 Prompt 首行已声明"**统一执行规范（唯一执行来源）…本 Prompt 不维护第二套执行规则**"并全部引用 workshop 绝对路径 → **改动经引用链对 7 个周报生效，无需改 Prompt**；向 Prompt 重复抄写规则反而违反规范自身"重复即漂移源"的约束，故改动面收敛为 0。
- `weekly-ops-contract` 只读具名路径（report/blog/INDEX/done），**不扫描 RUN_DIR 任意文件** → 新增 `units/` 子目录不干扰发布检查。

### 4.5 回归测试

`scripts/test_reliable_cron_regressions.py`：**3/3 通过**（2.637s）。助手脚本未修改。

---

## 五、未验证项（规则已就位 ≠ 效果已验证）

- 静态规则已生效，**下期自然运行尚未发生**。最近检验点：**2026-10-01（周四）06:00** 全球 AI Agent 基础设施研究周报。
- L1/L2/L3 的效果只能在真实长文研究/编辑任务中观察；L4 的效果需等下一次周报配图环节。
- 本轮未做生产实跑验证，**不声称提速或降错已达成**。

### 产出核对清单（下期按此逐条查）

- [ ] 研究子任务是否产出 `<RUN_DIR>/units/*.done` 单元标记，且**先载荷后标记**。
- [ ] 等待阶段是否出现"按单元标记枚举"的 `wait` 调用（而非只等一个组级 `.done`）。
- [ ] 是否出现"对已有文件整文件 `write` 覆盖"的违规（应无）。
- [ ] 中断恢复时是否按集合差集补做，而非重建目录/重算窗口。
- [ ] 配图环节父级是否**未**直接调用 `image_generate`，且无 `ActiveTurnClaimError`。

---

## 六、未做的动作（需另行授权）

1. ~~**技能仓库副本回灌未做**~~ —— **已授权并完成（2026-09-30 14:5x）**，见下节「七」。
2. 未改动 `reliable_cron.py` 及任何调度配置、超时、模型路由、工具白名单。
3. 未新增定时任务（16 → 16）。

---

## 七、技能仓库副本回灌（2026-09-30）

**目标仓库**：`wujiaming88/skills`（PUBLIC，git@github.com:wujiaming88/skills.git），检出 `/root/.openclaw/workspace/project/skills`。

### 方向判定（逐文件，不整体覆盖）

先 `git fetch origin`，确认检出与 `origin/main` 同为 `3d81177`（未落后），再逐文件读内容判定。
差异 6 个文件，**方向均为 Workshop → 仓库**，无任何“仓库领先”文件：

| 文件 | repo 哈希 → workshop 哈希 | 仓库落后原因 |
|---|---|---|
| `SKILL.md` | `c41b2766` → `016787d8` | 缺 L1–L4、§5 权威声明、阶段占位核对、forbidden 处理 |
| `references/config-audit.md` | `01cf369b` → `5751f72e` | 缺“取数入口”整节与 `automations edit --tools` 警告 |
| `references/common-failure-playbook.md` | `c36978d6` → `ea3823fe` | 缺“失败告警”与错误文本分两支 |
| `references/design-boundary.md` | `4a2b47ad` → `3aa5d22f` | 缺 `blog-article-publish` 条目 |
| `references/weekly-publication.md` | `b61d8dba` → `ccae3073` | 未去重（仓库版仍内含重复全文，Workshop 已改为路由主文件 §5） |
| `references/helper-contract.md` | `ffee8807` → `5a1ec711` | 等待标记口径对齐（本次改动） |

其余 5 文件（`research-contract.md`、`weekly-ops-contract.md`、`scripts/`×3）逐字节相同，未改。
无 `.clawhub/origin.json` 等来源元数据，无压缩包。

### 核验

- 同步后 11/11 文件 SHA256 逐一相同；`diff -rq` 无差异。
- 回归测试：同步**前**基线 OK、同步**后** 3/3 通过。
- 敏感信息扫描（凭据前缀 + 本机收件人字面量）：目录 **0 命中**；技能目录内无 zip，无归档内容扫描项。
- 提交 `30afccc`；`check-git` = `GIT_OK` / `synced: true`。
- **线上内容核验用 `gh api .../contents/`**（按规程不用 `raw.githubusercontent.com`）：6 个关键词全部在线命中，4 个文件的线上字节数与本地一致（22391 / 4172 / 12782 / 11577）。

### 注意

后台技能维护任务（`skill-collection-review-*`，按周运行）会**直接改写 Workshop 目录而不走提案流程**，因此“本次已一致”不代表以后仍一致；下次同步前必须重跑 `diff -rq`。

---

## 八、回滚

改前全量备份：`shared/artifacts/tool-layer-opt-20260930-101826/`
（含 `skill-full/cron-run-reliability/` 全目录、10 份 Prompt、改前 cron 快照、SHA256 台账）。

回滚 = 把备份的 `SKILL.md` 与 `references/helper-contract.md` 覆盖回
`~/.openclaw/agents/main/agent/workshop-skills/cron-run-reliability/`。
**注意**：该目录是 Workshop 技能，直接覆盖会绕过提案流程；正式回滚宜走 Workshop 提案并同样做正文 SHA 核验。

---

## 九、首检结果（2026-10-01 06:00 全球 AI Agent 基础设施周报）

- 运行 `fdf1d555-eefd-429e-a8f2-1180766da7f6`：06:00:00 起、07:05:29 完（预算 120 min，提前约 55 min），终态 `SUCCESS_WITH_WARNINGS`，投递成功（`delivered: true`）。
- 规则版本核对：`SKILL.md` `016787d8…49fd`、`helper-contract.md` `5a1ec711…419f`，与本文档第四节一致 → **改动未被回滚**。

| 清单项 | 结果 | 证据 |
|---|---|---|
| L2 `units/<单元名>.done` 单元标记（先载荷后标记） | **未落地** | run 目录内无 `units/`；`find -type d -name units` 全域命中 0 |
| 按单元标记枚举的 `wait` | **未出现** | 同上；等待仍只等组级 `line-X.done` |
| 整文件 `write` 覆盖违规 | 未逐条核验 | 未发现丢片、零字节产物或分片重写 |
| 断点续跑按集合差集 | 行为上达成 | A 线中断后接管者只补 `line-A-part-07..10`，未重做 part-01..06 |
| 配图经专用子会话、无 `ActiveTurnClaimError` | 通过 | `TASK-1001-IMG-头图`（子会话）06:18:12→06:19:31；父级仅 `ls` + `cp` |

- **与上一期（2026-09-24）对比**：上期文章两片首轮零/半落盘（`article-second-pass.md` 零落盘，父级被迫按实际状态手写 traceability）；本期两片完整落盘（`article-baseline.md` 39,659 B、`article-second-pass.md` 106,830 B、`article-traceability.md` 10,051 B），未再出现“零落盘”。
- **同类中断仍发生**：本期 A 线 `LLM request failed: network connection error`，与上期 B 线同类，属网络层错误，非规则可控。差别在代价：本期仅补 4 片（约 4 分钟），零丢失；上期需补缺者合并并重建 `.done`。
- **L2 未落地的原因（判定）**：L2 规则只写在技能内，而每次运行的产物清单来自主题 Prompt 的 `## Expected artifacts`（仅列 `line-X.done`）。2026-09-30 决定“不动 7 份 Prompt、只靠引用链生效”，导致该条规则未进入执行路径。
- **结论**：L1/L3/L4 在本次运行中可观察到；**L2 未生效**，须先把单元标记写进执行路径（主题 Prompt 产物清单 + 运行合同模板）才具备可验证性。

---

## 十、L2 沉淀到技能（2026-10-01 13:38，已应用）

按 10-01 首检结论（L2 未进执行路径）修正写法：**不改 7 份主题 Prompt**，把 L2 从「外加一个新产物」改写为「**已声明分片产物的派生属性**」，登记处唯一为第2节运行合同。

### 改动

| 项 | 值 |
|---|---|
| 文件 | `cron-run-reliability/SKILL.md`（Workshop 技能，走提案） |
| 提案 | `cron-run-reliability-20261001-21d4cd1d0e`（`revisionHash 5205f845…73fdd`，`appliedAt 2026-10-01T05:38:51Z`） |
| 改动面 | §3 等待条内 1 处就地改写；`diff -u` 仅 1 hunk |
| 行数 | 97 → 97（**持平**） |
| 字节 | 22,739 → 23,051（+312） |
| SHA256 | `815c01333aa1eec03a088d478780242e1745b04f57729af3138f985cfe8676b3` → `f2883810d1e74493e5b9446e8eb3ebb4b0b7536964290e5d034bbbff0a9324cc` |
| 主题 Prompt | **0 份改动** |
| 代码/调度/模型/超时 | 0 |

新规则要点：单元标记 = 每个已声明分片产物的派生属性（`<RUN_DIR>/units/<分片basename>.done`，先载荷后标记）；不依赖各主题分片颗粒度、不需各主题另列产物名；**登记处唯一是第2节运行合同**；续跑按集合差集；不替代组级 `.done` 交回信号，也不得代替父级质量验收；**漏写标记不构成阻塞**（改按分片体积与内容验收）。

### 核验

- 正文 SHA：提案正文切片与生效文件切片同为 `47abb2c1097ec760b4e3b4765b48f281b47a0bbe224455259e2889807bf0a7c1`（**按正文核验，不按“已应用”回执**）。
- 生效全文 SHA = 提交前用脚本预算的 `f2883810…24cc`，逐字节一致。
- 旧串已消失；新增「派生属性」「登记处唯一是第2节的运行合同」「漏写标记不构成阻塞」均在位。
- `diff -rq <改前整目录备份> <技能目录>` → **仅 `SKILL.md` 一行**，`references/`、`scripts/` 逐字节未动。
- 回归测试 `scripts/test_reliable_cron_regressions.py`：**3/3 OK**（5.949s）。
- `openclaw skills info cron-run-reliability --agent main` → `✓ Ready`，`Source: openclaw-workshop`。
- 调度零漂移：改前/改后 `openclaw cron list --json` **逐字节相同**（`sha256 0c29ce7a…`），16 个任务不变。
- 跨文件查同名/相反表述：`units` 在技能与 `shared/prompts`、`shared/scripts` 全域无第二处引用；各主题 Prompt 只声明分片与组级 `.done`，与新条不冲突。

### 未署名宿主机改动（同一文件、同日两次）

在本次改动的准备过程中，发现该文件被 **OpenClaw 之外的写入者**（宿主机编辑器或直接 CLI）改动两次，均未留 `audit_events` 痕迹：

| 时刻 | inode | 字节 | 内容 |
|---|---|---|---|
| 13:24:59 | 1069949 | 22,700 | ＋「单元标记是产物，须同时出现在本次运行的产物清单里（主题Prompt的 `## Expected artifacts` 或第2节合同）」 |
| 13:35:04 | 1069950 | 22,739 | 同句收窄为「（第2节运行合同的 `## Expected artifacts`；主题Prompt 的固有产物清单按其原文）」 |

两次都是整文件替换（新 inode、`birth == mtime`）。本次提案即以 13:35 版（`815c0133…`）为基线，改写后该句已被完全替换。两次改动均已存档：`shared/artifacts/skill-edit-guard-20261001/`（含 `EVIDENCE.md` 与 as-of-1326 全目录备份）。

### 未生效观察点

规则已生效 ≠ 效果已验证。最近检验点：**2026-10-08（周四）06:00** 全球 AI Agent 基础设施研究周报。届时按首检清单复查 `units/*.done` 是否出现、`wait` 是否按单元枚举。
