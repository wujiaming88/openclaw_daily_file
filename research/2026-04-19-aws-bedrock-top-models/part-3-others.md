# Part 3: Amazon Nova / Meta Llama 4 / DeepSeek / Mistral / Google Gemma

**数据来源**：
1. AWS Blog: Llama 4 models from Meta now available in Amazon Bedrock serverless (2025-04-29)
2. AWS Blog: Amazon Nova Premier launch (2025-04-30)
3. Amazon Nova Premier Technical Report (assets.amazon.science)
4. AWS Blog: Migrate from Amazon Nova 1 to Amazon Nova 2 on Amazon Bedrock (2026-04)
5. Artificial Analysis: DeepSeek V3.2 providers comparison
6. wring.co AWS Bedrock Models guide (2026-03-08)
7. tokenmix.ai Bedrock pricing (2026-04)

## 🧠 Amazon Nova 家族

### Nova Premier (v1, 2025-04-30 发布)

- **Bedrock Model ID**：`amazon.nova-premier-v1:0`
- **区域**：us-east-1, us-east-2, us-west-2
- **输入模态**：Text + Image + Video
- **上下文窗口**：1M tokens（根据 wring.co；技术报告证实支持长上下文）
- **定价（wring.co 2026-03）**：
  - Input $2.00 / 1M tokens
  - Output $15.00 / 1M tokens（注：tokenmix 显示 output 更高，以 Bedrock 控制台为准）
- **Benchmark（Amazon 官方技术报告）**：
  - MMLU: **87.4%**（thenextweb/WinBuzzer/aiwiki 交叉验证，winbuzzer 报 87.1%）
  - MMMU（多模态）: **87.4%**
  - SimpleQA: **86.3%**
  - IFEval: **91.5%**
  - Math500: **82.0%**
  - HumanEval+: **80.5%**（WinBuzzer 指出在代码上仍落后 Gemini 2.5 Pro）

### 核心定位
Amazon 官方定位为：**"most capable model for complex tasks and teacher for model distillation"**。即：
1. 最复杂任务（企业推理、Agent、多模态）
2. **蒸馏老师模型**：用 Nova Premier 教 Nova Pro/Lite 生成专属小模型（配合 Amazon Bedrock Custom Model Import/Distillation）

### Nova 2 家族（2026 Q1/Q2 迭代）

根据 AWS Blog "Migrate from Amazon Nova 1 to Amazon Nova 2 on Amazon Bedrock"（2026-04）：
- **Nova 2 Lite 超越 Nova Premier**：在多步问题求解上**比 Premier 强**，同时**便宜 7 倍，推理快 5 倍**
- **Bedrock Model ID**：`amazon.nova-2-lite-v1:0`
- **区域**：几乎全球（24+ 区域）
- **输入**：Text + Image + Video；**输出**：Text

⚠️ **黑马提醒**：Nova 2 Lite 是官方推荐的 Premier 继任者。Premier 作为老师模型仍有价值，但**新项目应首选 Nova 2 Lite**。

### Nova 家族其他成员

| 模型 | Input / Output $/1M | 上下文 | 模态 | 定位 |
|------|---------------------|--------|------|------|
| Nova Micro | **$0.035 / $0.14** | 128K | Text | Bedrock 最便宜（路由/分类首选） |
| Nova Lite | $0.06 / $0.24 | 300K | Text+Image+Video | 文档/OCR/视频摘要 |
| Nova Pro | $0.80 / $3.20 | 300K | Text+Image+Video | Agent / RAG 主力 |
| Nova Premier | $2.00 / $15.00 | 1M | Text+Image+Video | 硬任务 + 蒸馏老师 |
| **Nova 2 Lite** ⭐ | 未公开（比 Premier 便宜 7x） | 未公开 | Text+Image+Video | **新一代替代** |

---

## 🦙 Meta Llama 4 家族（Bedrock serverless，2025-04-29 上架）

### Llama 4 Maverick 17B Instruct

- **Bedrock Model ID**：`us.meta.llama4-maverick-17b-instruct-v1:0`（cross-region）或 `meta.llama4-maverick-17b-instruct-v1:0`
- **架构**：MoE，128 experts，17B active / 400B total 参数
- **上下文窗口**：**1M tokens**（AWS 官方）
- **区域**：us-east-1 (N. Virginia) + us-west-2 (Oregon)，通过 cross-region 可达 us-east-2
- **定价**：$0.20 / $0.80 per 1M tokens（wring.co 2026-03）
- **模态**：原生多模态（Text + Image + Video），early fusion
- **语言**：12 种文本语言（中文未列出！英/法/德/印地/意/葡/西/泰/阿/印尼/菲/越）
- **⚠️ 踩坑**（GitHub sst/opencode #2589, 2025-09）：**on-demand throughput 不支持**，需要申请 Provisioned Throughput 或走 cross-region profile（`us.` 前缀）

### Llama 4 Scout 17B

- **Bedrock Model ID**：`meta.llama4-scout-17b-16e-instruct-v1:0` / `us.meta.llama4-scout-...`
- **架构**：MoE，16 experts，17B active / 109B total 参数
- **上下文窗口**：**Bedrock 支持 3.5M tokens**（AWS 官方原话：currently supports a 3.5 million token context window，未来会扩展）
  - Meta 官方架构理论上支持 10M，Bedrock 当前限制 3.5M
- **定价**：$0.17 / $0.17 per 1M tokens（wring.co 2026-03，**input = output 定价非常友好**）
- **区域**：us-east-1, us-west-2
- **模态**：多模态

### Llama 4 综合评价
- **上下文王**：Scout 3.5M 是 Bedrock 上**最大上下文**，50x Claude，3.5x Opus 4.7
- **价格屠夫**：$0.17/$0.17 的 Scout 几乎跟 Nova Micro 同级别但更智能
- **多模态**：Maverick 视觉理解强
- **适合**：超长文档、巨型 codebase 分析、图像 grounding
- **不适合**：需要极致推理精度（落后 Claude Opus）、中文场景（官方只保证 12 语言未含中文）、按需 pay-as-you-go（on-demand 限制）

---

## 🔬 DeepSeek 家族

### DeepSeek V3.2（2026-Q1 Bedrock 新上架）

- **Bedrock Model ID**：`deepseek.v3.2`
- **区域**：us-east-1, us-east-2, us-west-2, ap-northeast-1, ap-south-1, ap-southeast-2, ap-southeast-3, eu-north-1, eu-west-2, sa-east-1（**广泛区域**）
- **上下文**：128K（Bedrock，deepinfra.com 2026-04 报告："restricted 128k context window"），原生 163K（OpenRouter/其他 provider）
- **定价参考**（多 provider 综合，Bedrock 具体定价以控制台为准）：
  - 最低价 provider GMI: $0.23 blended/1M
  - Bedrock：约 3.1x Novita（deepinfra.com 报告），推算 ~$0.7~1.0 blended
- **能力**：chat + reasoning 一体（V3.2 架构合并了 V3 和 R1）
- **Benchmark**：**2025 IMO 金牌、IOI 金牌**（dev.to 2026-04）

### DeepSeek-R1

- **Bedrock Model ID**：`deepseek.r1-v1:0`
- **区域**：us-east-1, us-east-2, us-west-2
- **定位**：纯推理（Chain-of-Thought），数学/逻辑/奥赛级别
- **适合**：科研、复杂推理任务
- **不适合**：低延迟对话

### DeepSeek-V3.1

- **Bedrock Model ID**：`deepseek.v3-v1:0`
- **区域**：8 区域（比 V3.2 少）
- **已被 V3.2 替代，新项目建议直接上 V3.2**

### DeepSeek ⚠️ Bedrock 踩坑
1. Bedrock 未支持 DeepSeek JSON Mode（deepinfra.com 指出"lack of native JSON mode support"）
2. Bedrock 价格是 Novita 的 3.1x，如果不需要 AWS 生态绑定，自托管或第三方 provider 更划算
3. 上下文被砍到 128K（原生 163K）

---

## 🌬️ Mistral AI（Bedrock）

### Mistral Large 2

- **Bedrock Model ID**：`mistral.mistral-large-2407-v1:0`
- **上下文**：128K
- **区域**：us-east-1, us-west-2, eu-west-3（需验证最新）
- **定价**：约 $2 / $6 per 1M（2024 数据，2026 可能下调，以 AWS 为准）
- **定位**：欧洲合规场景首选（法语/欧洲数据驻留）

### Pixtral Large

- **Bedrock Model ID**：`mistral.pixtral-large-2502-v1:0`
- **模态**：Text + Image
- **定位**：欧洲多模态首选
- **数据未公开细节**，建议参考 Mistral 官方博客

---

## 🌟 Google Gemma 3（Bedrock 新上架，开源权重）

| 模型 | Model ID | 参数 | 输入 |
|------|----------|------|------|
| Gemma 3 27B IT | `google.gemma-3-27b-it` | 27B | Text+Image |
| Gemma 3 12B IT | `google.gemma-3-12b-it` | 12B | Text+Image |
| Gemma 3 4B IT | `google.gemma-3-4b-it` | 4B | Text+Image |

- **区域**：ap-ne-1, ap-south-1, ap-se-2, eu-south-1, eu-west-1/2, sa-east-1, us-east-1/2, us-west-2
- **定位**：开源权重 + 多模态，替代 Llama 中档型号
- **优点**：Google 官方训练，Gemini 家族同源技术，多模态良好
- **⚠️ 注意**：Gemini 2.5/3 Pro **不在 Bedrock**，只有 Gemma 开源线

---

## 🧩 其他值得提的

### Cohere Command R+ / R
- **Bedrock Model ID**：`cohere.command-r-plus-v1:0` / `cohere.command-r-v1:0`
- **定位**：RAG、工具使用的高性价比选手，结合 Embed v4（多模态 embeddings）+ Rerank 3.5 形成 Bedrock 最强 RAG 栈

### AI21 Labs Jamba 1.5 Large
- **Model ID**：`ai21.jamba-1-5-large-v1:0`（仅 us-east-1）
- **定位**：256K 上下文，SSM + Transformer 混合，吞吐快
- **适合**：吞吐敏感的长文档 pipeline

### OpenAI GPT/o 系列
- **结论**：**Bedrock 仍未上架 OpenAI 模型**（2026-04 官方文档无记录）
- 如需 GPT-5.4 / o 系列，需走 Azure OpenAI 或 OpenAI 直连
- **影响**：Bedrock 缺 GPT，但 Claude Opus 4.7 在多数 benchmark 上与 GPT-5.4 旗鼓相当或领先
