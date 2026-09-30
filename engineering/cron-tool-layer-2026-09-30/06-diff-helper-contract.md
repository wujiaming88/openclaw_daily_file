--- /root/.openclaw/workspace/shared/artifacts/tool-layer-opt-20260930-101826/skill/references/helper-contract.md	2026-09-15 11:24:19.620709473 +0800
+++ /root/.openclaw/agents/main/agent/workshop-skills/cron-run-reliability/references/helper-contract.md	2026-09-30 10:29:39.440008648 +0800
@@ -6,7 +6,7 @@
 
 `python3 <技能绝对目录>/scripts/reliable_cron.py wait --file /absolute/run/completed.marker --timeout 600 --interval 30 --min-bytes 1`
 
-- 多文件重复--file；每条命令--min-bytes仅一次。仅等待阶段完成标记，正文/账本另外check-files。
+- 多文件重复--file；每条命令--min-bytes仅一次。仅等待完成标记（阶段级或单元级），载荷正文/账本本身不混进wait、另用check-files核验。
 - 每个路径须存在、为普通非符号链接文件并达到阈值。
 - 兼容--glob；每个匹配须通过，空匹配失败。glob不能证明预期数量，精确清单用重复--file。
 - 超时输出单行JSON `status: "WAIT_TIMEOUT"`、`ok: false`、exit0；它是检查点，后续只按主文件第3节。
