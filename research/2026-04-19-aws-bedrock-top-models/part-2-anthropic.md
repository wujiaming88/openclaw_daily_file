# Part 2: Anthropic Claude 家族深度剖析（Bedrock 视角）

**数据来源**：
1. AWS News Blog: Introducing Claude Opus 4.7 in Amazon Bedrock (2026-04-17)
2. AWS ML Blog: Claude Opus 4.5 now in Amazon Bedrock (2025-11-24)
3. Anthropic 官方 Claude Opus 4.7 发布页 (2026-04-16)
4. Vellum AI / llm-stats.com / thenextweb benchmark 分析 (2026-04)
5. tokenmix.ai Bedrock 定价 (2026-04)

## 📊 Claude 4.x 家族总览

| 模型 | 发布 | SWE-bench Verified | GPQA Diamond | 上下文 | 输入 $/1M | 输出 $/1M | Bedrock Model ID |
|------|------|---------------------|--------------|--------|-----------|-----------|------------------|
| **Opus 4.7** ⭐最新 | 2026-04-16 | **87.6%** | **94.2%** | **1M tokens** | $15 (估) | $75 (估) | `us.anthropic.claude-opus-4-7` |
| Opus 4.6 | 2026-02 左右 | 80.8% | ~93% | 200K | $15 | $75 | `anthropic.claude-opus-4-6-v1` |
| Opus 4.5 | 2025-11-24 | 80.9% | ~92% | 200K | $5 (新，见下) | $25 (新) | `global.anthropic.claude-opus-4-5-20251101-v1:0` |
| Opus 4.1 | 2025-08-05 | 74.5% | ~90% | 200K | $15 | $75 | `anthropic.claude-opus-4-1-20250805-v1:0` |
| Sonnet 4.6 | 2026-Q1 | ~77% | ~90% | 200K | $3 | $15 | `anthropic.claude-sonnet-4-6` |
| Sonnet 4.5 | 2025-09-29 | 77.2% | ~88% | 200K | $3 | $15 | `anthropic.claude-sonnet-4-5-20250929-v1:0` |
| Sonnet 4 | 2025-05-14 | 72% | ~86% | 200K | $3 | $15 | `anthropic.claude-sonnet-4-20250514-v1:0` |
| Haiku 4.5 | 2025-10-01 | ~70% | ~82% | 200K | $0.80 | $4 | `anthropic.claude-haiku-4-5-20251001-v1:0` |

> **价格注解**：Anthropic 宣称 **Opus 4.5 达到 Opus-level 表现 1/3 成本**（AWS Blog 原话），意味着 Opus 4.5 是降价线。Opus 4.6/4.7 回到 $15/$75 高价区间。上述定价以 tokenmix.ai 汇总 + AWS 官方博客表述为主，老板下单前请以 Bedrock 控制台实时定价页为准。

## 🏆 Claude Opus 4.7 — 目前 Bedrock 最强 LLM

**上架时间**：2026-04-16 发布，2026-04-17 AWS 同步上架
**Bedrock Model ID**：`us.anthropic.claude-opus-4-7`（cross-region inference profile）
**可用区域**：US East (N. Virginia)、Asia Pacific (Tokyo)、Europe (Ireland)、Europe (Stockholm)

### 核心能力
- **Agentic coding 全面碾压**：SWE-bench Pro **64.3%**、SWE-bench Verified **87.6%**、Terminal-Bench 2.0 **69.4%**（均来自 AWS 官方博客）
- **科学推理**：GPQA Diamond **94.2%**（thenextweb、buildfastwithai 多源验证）
- **Finance Agent v1.1**：**64.4%**（SOTA）
- **长上下文**：**1M tokens** 原生支持，长程推理自验证
- **视觉升级**：支持 3.75 MP 高分辨率图像（前代 3 倍），对图表/密集文档/UI 截图识别显著提升
- **Adaptive thinking**：动态分配 thinking token budget（Bedrock 独家集成）
- **Bedrock 新推理引擎**：全新调度/伸缩逻辑，稳态流量优先；账户级 10,000 RPM 起步，可申请更高

### vs GPT-5.4 / Gemini 3.1 Pro
| 维度 | Opus 4.7 | GPT-5.4 Pro | Gemini 3.1 Pro |
|------|----------|-------------|-----------------|
| SWE-bench Verified | **87.6%** | 约 84% | 约 82% |
| GPQA Diamond | 94.2% | 94.4% | 94.3% |
| 代码 Agent | **领先** | 强 | 中 |
| 价格 | $15/$75 | 更贵 | $2.5/$10 |

> 结论（thenextweb 2026-04-17）：**Opus 4.7 在 SWE-bench 和 agentic reasoning 上领先 GPT-5.4 和 Gemini 3.1 Pro**。GPT 在 OpenAI 自营 + Azure；在 AWS Bedrock 生态，Opus 4.7 = 天花板。

### ⚠️ Opus 4.7 风险提示
1. **区域极窄**：刚发布 4 天只有 4 个区域（us-east-1 / eu-west-1 / eu-north-1 / ap-northeast-1）
2. **价格高**：$15/$75 是 Sonnet 4.5 的 5x，批量推理前务必评估 ROI
3. **Prompt 迁移成本**：官方说"may require prompting changes and harness tweaks"，从 Opus 4.6 升级非零成本
4. **还没正式进入 cross-region global profile**：目前是 US profile，跨洲调用请走 ap/eu 区域
5. **Adaptive thinking / effort 参数仍在 beta**：`effort-2025-11-24`、`tool-search-tool-2025-10-19`、`tool-examples-2025-10-29` 等 beta header

## 🥈 Claude Opus 4.5 — 性价比之选

**上架时间**：2025-11-24
**Bedrock Model ID**：`global.anthropic.claude-opus-4-5-20251101-v1:0`（全球 profile 可用）

### 亮点（来自 AWS ML Blog 官方）
- SWE-bench Verified **80.9%**
- MMMU **80.7%**（Anthropic 最强视觉模型）
- **Opus 级别表现、1/3 成本**（官方原话）
- 首发 **Tool Search Tool**（`defer_loading: True`）—— 数百工具库按需加载，节省数万 token
- 首发 **Tool Use Examples**（复杂 schema 准确率提升）
- **Effort 参数**（low/medium/high）动态控制思考 token
- 与 **Bedrock AgentCore** 深度集成：持久记忆、Tool Gateway、IAM、8 小时长任务

### 适合场景
- 成本敏感但需要 Opus 级推理
- 多工具 Agent（Tool Search 尤其强）
- 长任务 AgentCore 部署（最长 8 小时会话隔离）
- Office 自动化（PPT / Excel / Word 高质量产出）

### 不适合
- 极端长文档（1M 上下文请上 Opus 4.7）
- 最新代码 benchmark 冲刺（Opus 4.6/4.7 更强）

## 🥉 Claude Sonnet 4.5 — 主力军

**Bedrock Model ID**：`anthropic.claude-sonnet-4-5-20250929-v1:0`
**区域**：全球 30+ 区域，含 us-gov-west-1 / us-gov-east-1（联邦客户友好）

### 亮点
- SWE-bench Verified **77.2%**
- 上下文 200K
- 定价 $3/$15（Opus 4.5 的 60% 价，Opus 4.7 的 1/5）
- **政府云支持**：是 Bedrock 上唯一同时支持商业云+GovCloud 的顶级 Claude
- 快速迭代、大批量用户场景首选

### 适合
- 高频生产 Agent（RAG / Copilot / 客服）
- 代码助手 scaled 部署
- 政府/合规客户

## 🏅 Claude Haiku 4.5 — 小模型冠军

**Bedrock Model ID**：`anthropic.claude-haiku-4-5-20251001-v1:0`
**区域**：全球 30+ 区域

### 亮点
- SWE-bench 仍可达 ~70%（小模型罕见）
- 上下文 200K
- 定价 $0.80/$4（Opus 4.5 的 16%）
- 适合子 Agent、免费层产品、高 QPS 分类路由
- 视觉能力保留（图像输入）

## 选型决策逻辑

```
需求 → 推荐
───────────────────────────────
最强代码/Agent/1M长文档 → Opus 4.7（贵、区域窄，但天花板）
性价比顶级推理+多工具 → Opus 4.5（global profile、AgentCore 深度集成）
规模化生产 Agent       → Sonnet 4.5（全球+GovCloud）
子 Agent / 路由 / 免费层 → Haiku 4.5
纯分类/提取/便宜        → Claude 3 Haiku 或 Nova Micro
```

## Claude 家族黑马预警

- **Claude Opus 4.6** 在 Bedrock 上看起来被跳过，但实际 Model ID `anthropic.claude-opus-4-6-v1` 已列出，用于过渡期；生产不建议锁 4.6，直接用 4.5 或 4.7
- **Vellum AI 爆料**（2026-04）：**Claude "Mythos Preview"**（下一代 Opus）内部数据：SWE-bench Pro 77.8%、Terminal-Bench 82%、GPQA 94.6%。如果上架 Bedrock 将全面超越 Opus 4.7。老板在签 PT 合约前可等 Q3。
