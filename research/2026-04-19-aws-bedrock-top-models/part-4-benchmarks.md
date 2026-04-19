# Part 4: Benchmark 横向对比 + 第三方榜单

**数据来源**：
1. LMSys Chatbot Arena（截至 2026-04-06）
2. AWS 官方 Claude Opus 4.7 博客 benchmark
3. Vellum AI / llm-stats.com / thenextweb Opus 4.7 分析
4. Amazon Nova Premier 技术报告
5. Artificial Analysis DeepSeek V3.2 provider 对比
6. aidevdayindia LMSys 4月快照

## 🏆 LMSys Chatbot Arena Elo（2026-04-06 快照）

| 排名 | 模型 | Arena Elo | Bedrock 是否可用 |
|------|------|-----------|-------------------|
| #1 | **Claude Opus 4.6 Thinking** | **1504** | ✅ `anthropic.claude-opus-4-6-v1` |
| #2 | （可能 Mythos Preview / Opus 4.7 待录入） | 1500+ 预估 | 部分（Opus 4.7） |
| #3 | Gemini 3.1 Pro Preview | 1493 | ❌ Bedrock 没 Gemini Pro |
| #4 | Grok 4.20 Beta1 | 1491 | ❌ xAI 未上架 Bedrock |
| #5 | GPT-5.4 High | 1484 | ❌ OpenAI 未上架 Bedrock |

**编程专项榜（LMSys Coding Arena）**：
- **Claude Opus 4.6** 1549 Elo（领先者）
- GPT-5.4 次之
- 换句话说，**Bedrock 通过 Claude Opus 4.6/4.7 占据全球编程模型 #1**

> 来源：aidevdayindia.org 2026-04-06 快照，openlm.ai chatbot-arena，arena.ai/leaderboard

## 🎯 Opus 4.7 vs 竞品（多 benchmark 交叉）

| Benchmark | Opus 4.7 | Opus 4.6 | Opus 4.5 | GPT-5.4 Pro | Gemini 3.1 Pro | Nova Premier |
|-----------|----------|----------|----------|-------------|-----------------|--------------|
| SWE-bench Verified | **87.6%** | 80.8% | 80.9% | ~84% | ~82% | 未公开 |
| SWE-bench Pro | **64.3%** | 未公开 | 未公开 | 未公开 | 未公开 | 未公开 |
| GPQA Diamond | **94.2%** | ~93% | ~92% | **94.4%** | **94.3%** | 未公开 |
| Terminal-Bench 2.0 | **69.4%** | 未公开 | 未公开 | 未公开 | 未公开 | 未公开 |
| Finance Agent v1.1 | **64.4%** (SOTA) | 未公开 | 未公开 | 未公开 | 未公开 | 未公开 |
| MMLU | 未公开 | 未公开 | 未公开 | 未公开 | 未公开 | **87.4%** |
| MMMU（多模态） | 未公开 | 未公开 | 80.7% | 未公开 | 未公开 | **87.4%** |
| HumanEval+ | 未公开 | 未公开 | 未公开 | 未公开 | 未公开 | 80.5% |

**来源**：
- Opus 4.7 所有分数：AWS 官方博客 2026-04-17（转引 Anthropic 数据）
- Opus 4.5 SWE-bench Verified + MMMU：AWS ML Blog 2025-11-24
- Nova Premier：Amazon 官方技术报告 PDF（assets.amazon.science）+ WinBuzzer 交叉验证

## 📉 Claude Opus 内部进化

AWS 博客明言：**"Opus 4.7 extends Opus 4.6's lead in agentic coding"**，说明 4.7 对 4.6 是增量升级，尤其：
- long-horizon autonomy（长时自主性）
- systems engineering
- complex code reasoning

## 🧪 DeepSeek V3.2 在 Bedrock 的性能数据
（Artificial Analysis provider 对比）

| 维度 | Bedrock 表现 | 最佳 Provider |
|------|--------------|---------------|
| 输出速度 (t/s) | mid-pack | Azure 209 / GVertex 206 / Fireworks 185 |
| 首字延迟 | 中等 | GVertex 0.83s |
| 价格（每 1M blended） | **Bedrock 3.1x Novita** | GMI $0.23 |
| 上下文 | **Bedrock 限 128K** | DeepSeek 原生 163K |
| JSON Mode | ❌ Bedrock 不支持 | 多 provider 支持 |

**结论**：DeepSeek 在 Bedrock 上是**可用但非最优**的选择，仅当客户必须绑定 AWS 生态时考虑。

## ⚡ 速度/延迟参考（Bedrock 上估计）

| 模型 | 输出速度（tok/s 估） | 首字延迟（s 估） | 来源 |
|------|----------------------|-------------------|------|
| Claude Haiku 4.5 | 150-200 | ~0.5 | Anthropic 公开 |
| Claude Sonnet 4.5 | 80-120 | ~1.0 | 社区 |
| Claude Opus 4.7 | 50-80（带 thinking 更慢） | ~1.5 | 新推理引擎宣称优化 |
| Nova Micro | 200+ | ~0.4 | AWS |
| Nova Pro | 100-150 | ~0.7 | AWS |
| Llama 4 Scout | 150-200 | ~0.8 | 社区 |
| DeepSeek V3.2 (Bedrock) | ~50 | 中 | Artificial Analysis |

> ⚠️ 以上为**参考估计**，实际取决于区域、并发、prompt 长度、是否启用 adaptive thinking。生产前务必跑自己的基准。

## 🎖️ 综合评价矩阵（黄山主观打分，5 分制）

| 模型 | 推理 | 代码 | 多模态 | 长上下文 | Agent | 成本 | 区域广度 | 总分 |
|------|------|------|--------|----------|-------|------|----------|------|
| **Claude Opus 4.7** | 5 | 5 | 4 | 5 (1M) | 5 | 1 (贵) | 2 (4 区域) | 27 |
| Claude Opus 4.5 | 5 | 4 | 4 | 3 | 5 | 3 | 5 | 29 |
| Claude Sonnet 4.5 | 4 | 4 | 4 | 3 | 5 | 4 | 5 | 29 |
| Claude Haiku 4.5 | 3 | 3 | 3 | 3 | 4 | 5 | 5 | 26 |
| Nova Premier | 4 | 3 | 5 | 5 (1M) | 4 | 4 | 3 | 28 |
| **Nova 2 Lite** | 4 | 3 | 5 | 4 | 4 | **5** | 5 | 30 |
| Nova Pro | 3 | 3 | 5 | 4 | 4 | 5 | 5 | 29 |
| Llama 4 Scout | 3 | 3 | 4 | **5 (3.5M)** | 3 | 5 | 3 | 26 |
| Llama 4 Maverick | 4 | 3 | 4 | 5 (1M) | 4 | 4 | 3 | 27 |
| DeepSeek V3.2 | 5 | 4 | 2 | 3 | 4 | 3 | 4 | 25 |
| DeepSeek-R1 | 5 | 3 | 1 | 2 | 2 | 4 | 3 | 20 |
| Gemma 3 27B | 3 | 3 | 4 | 3 | 3 | 4 | 4 | 24 |

> 打分说明：Nova 2 Lite 得 30 分并非说它"最强"，而是综合性价比 + 广度最优。纯推理/代码 Opus 4.7 仍是天花板，只是贵 + 区域窄。
