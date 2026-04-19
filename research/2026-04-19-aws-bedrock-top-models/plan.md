# AWS Bedrock 顶级 LLM 调研计划

**任务**：为老板提供 Bedrock 上最强 LLM 的决策级清单
**截止日期**：2026-04-19
**产出人**：黄山（卷王小组）

## 子课题拆分

### Part 1: AWS 官方 Bedrock 模型清单（最新）
- 官方 supported models 页
- 定价页
- 2026 Q1/Q2 What's New 公告
- **产出**：part-1-aws-official.md

### Part 2: Anthropic Claude 家族
- Claude Opus 4 / Sonnet 4 / Haiku 4（若有）
- Claude 3.7 / 3.5 系列（仍主流）
- Bedrock Model ID、上下文、定价、benchmark
- **产出**：part-2-anthropic.md

### Part 3: Amazon Nova 家族 + Meta Llama 4 + Mistral + DeepSeek
- Nova Premier / Pro / Lite / Micro
- Llama 4 (Scout/Maverick/Behemoth) in Bedrock
- Mistral Large 2 / Pixtral
- DeepSeek-R1/V3（若 Bedrock 上架）
- **产出**：part-3-others.md

### Part 4: Benchmark 横向对比 + 第三方榜单
- LMSys Arena
- Artificial Analysis
- SEAL Leaderboard
- SWE-Bench / GPQA / MMLU 数据
- **产出**：part-4-benchmarks.md

### Part 5: 定价、区域、风险、推荐矩阵
- 各模型 input/output 定价对比
- 区域可用性（us-east-1 / us-west-2 / 全球推理）
- 配额、region 限制、价格陷阱
- 按场景的推荐矩阵
- **产出**：part-5-pricing-recommendations.md

### Final: 汇总报告
- 整合为 report.md
- 更新 INDEX.md
- git push
