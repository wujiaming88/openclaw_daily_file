# 可在线阅读快照：长时 Cron 执行规范工具层优化（L1–L4）

变更日期：2026-09-30 ｜ 变更对象：Workshop 技能 `cron-run-reliability`
变更集：**2 个文件**（`SKILL.md`、`references/helper-contract.md`）

## 文件对照表（按阅读顺序）

| 编号 | 文件 | 说明 |
|---|---|---|
| 00 | `README.md` | 本导航 |
| 01 | `01-SKILL-改后.md` | 执行规范主文件（**改后全文**，L1–L4 已就位） |
| 02 | `02-helper-contract-改后.md` | 机械契约（**改后全文**，等待标记口径已对齐） |
| 03 | `03-SKILL-改前.md` | 主文件改前全文（对照用） |
| 04 | `04-helper-contract-改前.md` | 契约改前全文（对照用） |
| 05 | `05-diff-SKILL.md` | 主文件 unified diff（3 个 hunk） |
| 06 | `06-diff-helper-contract.md` | 契约 unified diff（1 个 hunk） |

## 四项改动的主责映射

| 编号 | 杠杆 | 落点（01 文件内） |
|---|---|---|
| L1 | 定位追加，禁止整文件覆盖 | §1「正文、front matter…分块落盘」条 |
| L2 | 单元完成标记 + 续跑集合差集 | §3「唯一等待命令」条 |
| L3 | 读写窗口约束（产出路径） | §1 同上条 |
| L4 | 按是否吃回合选工具 | §1「一等工具」条；§5 配图条指向通例 |

## 回滚路径

改前全量备份：`shared/artifacts/tool-layer-opt-20260930-101826/`
（`skill-full/cron-run-reliability/` 全目录 + 10 份 Prompt + 改前 cron 快照 + SHA256 台账）。
正式回滚宜走 Workshop 提案并做正文 SHA 核验，不直接覆盖技能目录。

## 核验状态

正文 SHA 核验通过；调度零漂移（改前/改后 cron 快照逐字节相同）；回归测试 3/3 通过。
**静态规则已就位 ≠ 效果已验证**：最近检验点 2026-10-01 06:00。
