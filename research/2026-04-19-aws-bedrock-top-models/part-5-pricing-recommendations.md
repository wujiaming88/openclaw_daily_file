# Part 5: 定价、区域、推荐矩阵、风险清单

**数据来源**：
1. tokenmix.ai AWS Bedrock Pricing 2026 (2026-04-10)
2. wring.co AWS Bedrock Models Guide (2026-03-08)
3. AWS 官方定价页 https://aws.amazon.com/bedrock/pricing/
4. 各模型 AWS 公告博客

## 💰 Bedrock 顶级模型定价总表（on-demand，us-east-1）

| 模型 | Input $/1M | Output $/1M | Prompt Caching | 上下文 | 备注 |
|------|------------|-------------|----------------|--------|------|
| **Claude Opus 4.7** | ~$15 | ~$75 | Cache read $0.60 / write $7.50 | 1M | 以 Bedrock 控制台为准 |
| **Claude Opus 4.5** | ~$5 | ~$25 | 支持 | 200K | 官方称 Opus 级别 1/3 成本 |
| Claude Opus 4.1 | $15 | $75 | 支持 | 200K | 旧价区 |
| Claude Sonnet 4.5 | $3 | $15 | 支持 | 200K | 性价比主力 |
| Claude Sonnet 4 | $3 | $15 | 支持 | 200K | |
| Claude Haiku 4.5 | $0.80 | $4 | 支持 | 200K | |
| Claude 3.5 Haiku | $0.80 | $4 | 支持 | 200K | |
| Claude 3 Haiku | $0.25 | $1.25 | 支持 | 200K | |
| Amazon Nova Premier | $2 | $15 (wring) | 支持 | 1M | output 较贵 |
| Amazon Nova Pro | $0.80 | $3.20 | - | 300K | |
| Amazon Nova Lite | $0.06 | $0.24 | - | 300K | |
| Amazon Nova Micro | **$0.035** | **$0.14** | - | 128K | Bedrock 最便宜 |
| Amazon Nova 2 Lite | 未公开（比 Premier 便宜 7x）| - | - | 未公开 | 新一代替代 |
| Llama 4 Scout | **$0.17** | **$0.17** | - | 3.5M | 上下文冠军 |
| Llama 4 Maverick | $0.20 | $0.80 | - | 1M | MoE 多模态 |
| Llama 3.3 70B | $0.72 | $0.72 | - | 128K | 开源主力 |
| Llama 3.1 405B | $2.13 | $2.13 | - | 128K | 最大 dense |
| DeepSeek V3.2 | ~$0.70 blended | - | - | 128K | Bedrock 比其他 provider 贵 3.1x |
| Mistral Large 2 | ~$2 | ~$6 | - | 128K | 欧洲合规 |
| Cohere Command R+ | $3 | $15 | - | 128K | RAG |

## ⚠️ Bedrock 定价陷阱（tokenmix.ai 实测）

1. **企业客户 Claude 在 Bedrock 上平均比直连贵 20-35%**（tokenmix 实测，企业多数没意识到）
2. **Cross-region inference 加价 +10%**：跨区域调用虽方便但有 surcharge
3. **Provisioned Throughput** 小规模反而更贵：除非稳态高流量，否则坚持 on-demand
4. **Batch 优惠 50%**：异步/夜间任务必用 batch，等于半价
5. **Output token 是主要成本**：所有模型 output 都比 input 贵 3-5x，精简 prompt 降本不如精简 response
6. **Prompt Caching 能省 80-90%**：Claude 家族系统 prompt 重复率高的场景必开（cache read $0.60 vs 重发 $3，90% off）

## 🌍 区域分层

### Tier 1: 全球 30+ 区域（生产部署友好）
- Claude Opus 4.5 / 4.6 / Sonnet 4.5 / 4.6 / Haiku 4.5
- Amazon Nova Lite / Pro / Micro / Nova 2 Lite

### Tier 2: us-east + eu + ap 少数区域
- **Claude Opus 4.7**（us-east-1, eu-west-1, eu-north-1, ap-northeast-1 仅 4 个）
- Nova Premier（us-east-1/2, us-west-2）
- Llama 4 Scout / Maverick（us-east-1, us-west-2）

### Tier 3: 仅 us-east
- AI21 Jamba 1.5 系列
- Luma Ray v2

### GovCloud 支持（稀缺）
- Claude Sonnet 4.5 ⭐（唯一顶级 Claude 支持 us-gov-west-1 + us-gov-east-1）
- Claude 3 Haiku
- Nova Pro / Lite / Micro
- Llama 3 / 3.1 家族

## 🎯 场景 → 模型推荐矩阵

### ⚡ 代码 / SWE Agent
**首选**：`us.anthropic.claude-opus-4-7`（SWE-bench Verified 87.6% 天花板）
**次选**：`global.anthropic.claude-opus-4-5-20251101-v1:0`（1/3 价，AgentCore 深度集成）
**性价比**：`anthropic.claude-sonnet-4-5-20250929-v1:0`（规模化部署）
**开源线**：`us.meta.llama4-maverick-17b-instruct-v1:0`

### 🤖 Agent / Tool Use / 长任务
**首选**：`global.anthropic.claude-opus-4-5-20251101-v1:0` + Bedrock AgentCore
- Tool Search + Tool Examples + Effort 参数原生
- 8 小时会话 + 持久记忆
**次选**：Claude Opus 4.7（Adaptive thinking + 1M 上下文）

### 📄 长文档 / 超大 codebase 分析
**首选**：`meta.llama4-scout-17b-16e-instruct-v1:0`（3.5M 上下文，Bedrock 最大）
**次选**：Claude Opus 4.7（1M 原生，推理质量更高）
**辅选**：Nova Premier（1M + 多模态 video 理解）

### 👁️ 多模态（图像/视频/文档理解）
**视频输入**：Amazon Nova Premier / Nova Pro / Nova 2 Lite（Bedrock 原生 video 输入仅 Amazon 家）
**图像 + 推理**：Claude Opus 4.7（3.75MP 高分辨率）
**多模态 embedding**：Nova 2 Multimodal Embeddings / Cohere Embed v4

### 💸 极致降本（高 QPS 路由/分类/提取）
**冠军**：`amazon.nova-micro-v1:0`（$0.035/$0.14，128K 上下文）
**次选**：Llama 3.2 1B/3B（$0.10/$0.10）
**代码/结构化**：`anthropic.claude-haiku-4-5-20251001-v1:0`（$0.80/$4）

### 🧮 科研 / 数学 / 奥赛推理
**首选**：`deepseek.r1-v1:0`（强推理 CoT）
**次选**：`deepseek.v3.2`（IMO/IOI 金牌）
**精度要求高**：Claude Opus 4.7（GPQA 94.2%）

### 🏛️ 政府/合规（GovCloud）
**唯一选择**：`anthropic.claude-sonnet-4-5-20250929-v1:0`（us-gov-west-1 / us-gov-east-1）
**辅选**：Nova Pro / Lite / Micro、Claude 3 Haiku、Llama 3 家族

### 🇪🇺 欧洲数据驻留 / 多语言
**首选**：Mistral Large 2（`mistral.mistral-large-2407-v1:0`）
**次选**：Claude 家族（eu-west-1, eu-central-1）
**多模态欧洲合规**：Pixtral Large

### 🗂️ RAG 栈
**最强组合**：Claude Sonnet 4.5（生成）+ Cohere Embed v4（embedding）+ Cohere Rerank 3.5（重排）
**Nova 生态**：Nova Pro（生成）+ Amazon Titan Text Embeddings V2 / Nova Multimodal Embeddings

### 🎓 蒸馏/微调老师模型
**首选**：Nova Premier（官方定位：teacher model + Bedrock Distillation 支持）

## 🚨 关键风险 & 注意事项

### 1. OpenAI GPT/o 系列**不在 Bedrock**
- 如果老板要用 GPT-5.4、o5，需要 Azure OpenAI 或 OpenAI 直连
- **好消息**：Claude Opus 4.7 在代码/Agent 上实测领先 GPT-5.4（thenextweb 2026-04-17）

### 2. Opus 4.7 区域极窄
- 仅 4 个区域（us-east-1, eu-west-1, eu-north-1, ap-northeast-1）
- 全球业务请用 Opus 4.5/4.6 或 Sonnet 4.5（30+ 区域）

### 3. Llama 4 按需吞吐限制
- `meta.llama4-maverick-17b-instruct-v1:0` **on-demand 不支持**，必须 Provisioned Throughput 或 `us.` 前缀 cross-region profile
- 来源：GitHub sst/opencode #2589（2025-09 社区报告）

### 4. DeepSeek on Bedrock 价格不划算
- 比 Novita、GMI 等第三方贵 3.1x
- 上下文被砍到 128K（原生 163K）
- 无 JSON Mode
- **仅当必须 AWS 生态**时才用 Bedrock DeepSeek

### 5. Bedrock vs 直连 Anthropic
- Claude 在 Bedrock 平均贵 20-35%（tokenmix.ai 2026-04）
- **换来**：IAM 细粒度权限、VPC、KMS、CloudTrail 审计、SigV4 认证、合规证书
- 判断标准：**企业合规 > 成本差 → Bedrock；纯技术探索 → 直连**

### 6. Nova Premier 已"被子模型反超"
- Nova 2 Lite 在多步推理上超过 Premier，**7x 便宜、5x 更快**
- 新项目应首选 Nova 2 Lite，Premier 保留作为蒸馏老师

### 7. Cross-region inference 加价
- `us.` / `eu.` / `apac.` profile 前缀 +10% 费用
- 好处：高可用 + 容量自动调度
- 建议：稳态生产绑区域；峰值/不确定流量用 cross-region

### 8. 配额（RPM / TPM）
- Opus 4.7 新账户：**10,000 RPM / 区域 / 账户**（AWS 博客明示）
- 老模型默认较低，需 AWS Support 工单申请
- **生产上线前务必提前提配额**，周级前导

### 9. Bedrock 新推理引擎（Opus 4.7 专用）
- 动态调度 + 优先稳态流量
- 高峰期请求**排队**而不是拒绝（对业务更友好）
- 但也意味着首次调用 cold start 可能更慢

### 10. 蒸馏/定制的闭环
- Bedrock Custom Model Import 支持 Llama / Mistral 权重导入
- Nova Premier → Nova Pro/Lite 蒸馏是 AWS 官方推荐路径
- **战略建议**：核心业务用 Opus 4.5 生成高质量轨迹 → 蒸馏到 Sonnet 4.5 生产（降 5x 成本）

## 💡 黑马 & 前瞻

1. **Nova 2 Lite** — 官方证实超越 Premier，是 2026 Q2 最大性价比机会
2. **Claude "Mythos Preview"** — Vellum 爆料下一代 Opus，SWE-bench Pro 77.8%（碾压 4.7 的 64.3%），预计 2026 Q3 上架
3. **Llama 4 Scout 3.5M 上下文** — 大 codebase 分析、企业知识库一次性加载场景的黑马
4. **DeepSeek V3.2 on Bedrock** — 贵但稳，给科研/推理场景一个 AWS 生态备选
5. **Bedrock Distillation 闭环** — Nova Premier 做老师 + 定制小模型蒸馏，是降本 90% 的工程捷径
