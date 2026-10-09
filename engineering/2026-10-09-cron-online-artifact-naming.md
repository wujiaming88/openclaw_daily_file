# 2026-10-09 · 周报运行目录「线上核验件」命名与留档口径统一

> 变更类型：Workshop 技能规则就地扩写（不新增任务、不改调度、不改研究准出）
> 技能：`cron-run-reliability`（Source: `openclaw-workshop`）
> 目标文件：`agents/main/agent/workshop-skills/cron-run-reliability/references/weekly-publication.md` §6 第 9 步

---

## 一、触发与问题

2026-10-09 全球AI+产业周报运行后出现「缺失文件」告警。核查发现是**跨期目录清单对比谬误**，不是真的缺件：

- 10-02 期运行目录里留了线上核验件 `online-article.html`、`online-header.png`；
- 10-09 期没留（是否留档此前无规则）；
- 事后检查拿**上一期的文件集合**去核对本期运行目录，于是把「本期合法未留档」判成「缺件」。

根因：**线上核验件的命名与是否落盘，此前没有任何规则文件定义**。实测各期命名也不统一（`online-cover.png` / `online-header.png` 混用，见 `weekly-agent-infra` 各期 `publication-audit.md`）。

## 二、改动内容（唯一权威处，就地扩写）

在 `weekly-publication.md` §6「固定发布顺序」第 9 步末就地追加一条（未新增小节、未复制到别的文件）：

> **线上核验件命名与留档（唯一口径）**：整页比对所需的线上副本固定放在运行目录：线上正文 `online-article.html`、线上头图 `online-image.png`（不再按各期封面/头图名另起 `online-cover.png`/`online-header.png` 等别名），整页差异存为同目录 `html-diff.txt`。三件只在本次确实下载或比对时产生，属可选核验证据，**不进入运行合同或主题 Prompt 的必交产物清单**，文件检查也不得把它们当期望文件——跨期运行目录的文件集合本就不同，不得以上一期的目录清单核对本期。

要点：① 命名固定（正文 / 头图 / 差异三件）；② 明确为**可选证据**，进必交清单会把「可选」变成「缺失即告警」，故显式排除；③ 显式禁止用上一期目录清单核对本期——这才是本次告警的直接病因。

## 三、改动前后 SHA256

| 文件 | 改前 SHA256 | 改后 SHA256 |
|---|---|---|
| `references/weekly-publication.md` | `ccae30735c9cda4a95ce4bfa4f8afff43d4a85539fe77fef864830bb98ab8213` | `0d7523a7e7abf51c7c96fb6ef512f9e12cb27f4da173773a0a2cc9b0c7c94fb1` |
| `SKILL.md` | `f2883810d1e74493e5b9446e8eb3ebb4b0b7536964290e5d034bbbff0a9324cc` | 未改动（同上） |

改动量：`weekly-publication.md` 54→55 行（+1 行 / +618 字节，12782→13400 B）。`SKILL.md` 逐字节未动。

## 四、unified diff（唯一一处）

```diff
--- references/weekly-publication.md（改前）
+++ references/weekly-publication.md（改后）
@@ -45,6 +45,7 @@
 9. 正文与头图分别运行 `.../reliable_cron.py check-http ...`。……耗尽后不重复push。
    - 需要整页比对时，直接运行 `diff -u <本次已验收构建HTML> <下载的线上HTML>` ……无法确认当前版本则保留未验证状态。
+   - **线上核验件命名与留档（唯一口径）**：整页比对所需的线上副本固定放在运行目录：线上正文 `online-article.html`、线上头图 `online-image.png`（不再按各期封面/头图名另起 `online-cover.png`/`online-header.png` 等别名），整页差异存为同目录 `html-diff.txt`。三件只在本次确实下载或比对时产生，属可选核验证据，**不进入运行合同或主题 Prompt 的必交产物清单**，文件检查也不得把它们当期望文件——跨期运行目录的文件集合本就不同，不得以上一期的目录清单核对本期。
 10. 汇总内容准出、文章、构建、双仓Git、正文/头图和投递证据，按主文件第7节、下节及主题Prompt形成真实结论。……
```

单一 hunk，无其他改动。因改动仅一行且 diff 已全量内联，未另打包 zip（zip 在内置预览不可读，且此处无额外待复核信息）。

## 五、生效路径核验（按正文 SHA，不看回执）

- 提案：`cron-run-reliability-20261009-8c0283da22`（kind=update，status=pending → applied）
- 提案正文 ↔ 生效文件（标题行起同段切片）SHA256：`864fb9bc…` == `864fb9bc…` ✅
- `diff -rq <改前整目录备份> <技能目录>`：仅列出 `references/weekly-publication.md` 一个文件 ✅
- `openclaw skills info cron-run-reliability --agent main` → `✓ Ready`，Source `openclaw-workshop`
- 改前基线已与上次已知版本核对一致（无第三方写入者），无冲突需报告
- 改前整目录备份：`/root/.openclaw/backups/skill-cron-run-reliability.before-20261009-0801/`

## 六、仓库回灌（skills 仓库）

- 目标：`/root/.openclaw/workspace/project/skills`（PUBLIC，既定「原样全量发布」，2026-09-18 决定）
- 先 `git fetch`：检出与 `origin/main` 同为 `30afccc`，无落后
- 逐文件判方向（内容为准，非字节大小）：仓库侧 `SKILL.md`、`references/research-contract.md`、`references/weekly-publication.md` 三件均**落后**于 Workshop（仓库版分别等于 Workshop 的旧版 / `.bak-20261002` 副本），方向统一 **Workshop → 仓库**；`scripts/` 三件逐字节一致，未动
- 同步后仓库副本测试：`test_reliable_cron.py` 20 项 OK、`test_reliable_cron_regressions.py` 3 项 OK
- 提交：`ee6083f`（3 files changed, 5 insertions(+), 2 deletions(-)），已 `push origin main`
- 线上核验：helper `check-git` → `GIT_OK` / `synced:true` / localHead == remoteHead == `ee6083f`；`gh api` 下载线上文件核对——`weekly-publication.md` SHA == `0d7523a7…`、含新增短语「线上核验件命名与留档」；`SKILL.md` SHA == `f2883810…`
- 未提交：Workshop 目录内的 `references/research-contract.md.bak-20261002-001611` 属本地备份产物，不属技能内容，未进仓库

## 七、敏感信息扫描（资料库/PUBLIC，推送前执行）

- 从本机调度器现场取已知投递收件人 ID，连同凭据前缀一并扫描待公开目录
- 命中 2 处，均为领域术语，非凭据：`references/design-boundary.md` 的 `sk-c`（来自技能目录名 `openclaw-task-cleanup`）；`scripts/reliable_cron.py` 的 `parsed.password`（URL 解析字段名）
- 扫描同时覆盖归档内容（zip 内部），本次未新增 zip，无此项
- 收件人 ID 零命中

## 八、未做 / 未验证

- **效果未验证**：静态规则已生效，不等于下次自然运行已验证效果。按 [weekly-report-rule-change](../README.md) 的产出核对方式，须在**下一次周报自然运行（2026-10-10 起各主题按排期）**后首检：`sha256sum` 规则文件确认未被后台维护任务回滚；枚举本期运行目录，确认命名统一为 `online-article.html` / `online-image.png` / `html-diff.txt` 且未再出现「按上一期清单击本期」的缺失告警。
- 未回溯修正历史各期运行目录里既有的 `online-cover.png` / `online-header.png` 命名（历史证据保留原样，不回改）。
