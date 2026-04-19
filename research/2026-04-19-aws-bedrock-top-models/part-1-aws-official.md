# Part 1: AWS Bedrock 官方模型清单（截至 2026-04-19）

**数据来源**：
- AWS Bedrock 官方文档 https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html
- AWS News Blog Claude Opus 4.7 发布公告（2026-04-17）

## Bedrock 当前上架的文本/多模态 LLM（Chat/Completion 类）

### Anthropic Claude 家族

| 模型 | Model ID | 输入 | 输出 | 区域 |
|------|----------|------|------|------|
| **Claude Opus 4.7** ⭐ 最新 | `us.anthropic.claude-opus-4-7`（cross-region profile） | Text + Image | Text | us-east-1, ap-northeast-1, eu-west-1, eu-north-1 |
| Claude Opus 4.6 | `anthropic.claude-opus-4-6-v1` | Text + Image | Text | 全球 30+ 区域（含 af/ap/eu/me/sa/us） |
| Claude Opus 4.5 | `anthropic.claude-opus-4-5-20251101-v1:0` | Text + Image | Text | 全球 30+ 区域 |
| Claude Opus 4.1 | `anthropic.claude-opus-4-1-20250805-v1:0` | Text + Image | Text | us-east-1/2, us-west-2 |
| Claude Sonnet 4.6 | `anthropic.claude-sonnet-4-6` | Text + Image | Text | 全球 30+ 区域 |
| Claude Sonnet 4.5 | `anthropic.claude-sonnet-4-5-20250929-v1:0` | Text + Image | Text | 全球 30+ 区域（含 us-gov） |
| Claude Sonnet 4 | `anthropic.claude-sonnet-4-20250514-v1:0` | Text + Image | Text | 全球 20+ 区域 |
| Claude Haiku 4.5 | `anthropic.claude-haiku-4-5-20251001-v1:0` | Text + Image | Text | 全球 30+ 区域 |
| Claude 3.5 Haiku | `anthropic.claude-3-5-haiku-20241022-v1:0` | Text | Text | us-east-1/2, us-west-2 |
| Claude 3 Haiku | `anthropic.claude-3-haiku-20240307-v1:0` | Text + Image | Text | 15+ 区域（含 us-gov） |

### Amazon Nova 家族

| 模型 | Model ID | 输入 | 输出 | 区域 |
|------|----------|------|------|------|
| **Nova Premier** ⭐ | `amazon.nova-premier-v1:0` | Text + Image + Video | Text | us-east-1/2, us-west-2 |
| Nova Pro | `amazon.nova-pro-v1:0` | Text + Image + Video | Text | 全球 30+ 区域（含 us-gov） |
| Nova 2 Lite | `amazon.nova-2-lite-v1:0` | Text + Image + Video | Text | 全球 24+ 区域 |
| Nova Lite | `amazon.nova-lite-v1:0` | Text + Image + Video | Text | 全球 30+ 区域（含 us-gov） |
| Nova Micro | `amazon.nova-micro-v1:0` | Text | Text | 全球 24+ 区域（含 us-gov） |
| Nova 2 Sonic | `amazon.nova-2-sonic-v1:0` | Speech | Speech + Text | ap-northeast-1, eu-north-1, us-east-1, us-west-2 |
| Nova Sonic | `amazon.nova-sonic-v1:0` | Speech | Speech + Text | ap-northeast-1, eu-north-1, us-east-1 |
| Nova Canvas | `amazon.nova-canvas-v1:0` | Text + Image | Image | ap-northeast-1, eu-west-1, us-east-1 |
| Nova Reel v1/v1.1 | `amazon.nova-reel-v1:0` / `v1:1` | Text + Image | Video | us-east-1 (+v1: ap-ne-1, eu-west-1) |
| Nova Multimodal Embeddings | `amazon.nova-2-multimodal-embeddings-v1:0` | Text/Image/Audio/Video | Embedding | us-east-1 |

### DeepSeek

| 模型 | Model ID | 输入 | 输出 | 区域 |
|------|----------|------|------|------|
| **DeepSeek V3.2** ⭐ | `deepseek.v3.2` | Text | Text | us-east-1/2, us-west-2, ap-ne-1, ap-south-1, ap-se-2/3, eu-north-1, eu-west-2, sa-east-1 |
| DeepSeek-V3.1 | `deepseek.v3-v1:0` | Text | Text | 8 区域 |
| DeepSeek-R1 | `deepseek.r1-v1:0` | Text | Text | us-east-1/2, us-west-2 |

### Meta Llama（Bedrock 官方已上架版本）

| 模型 | Model ID | 输入 | 输出 | 区域 |
|------|----------|------|------|------|
| Llama 3.3 70B Instruct | `meta.llama3-3-70b-instruct-v1:0` | Text | Text | （继续） |
| Llama 3.2 90B Instruct | `meta.llama3-2-90b-instruct-v1:0` | Text + Image | Text | us-east-1/2, us-west-2 |
| Llama 3.2 11B Instruct | `meta.llama3-2-11b-instruct-v1:0` | Text + Image | Text | us-east-1/2, us-west-2 |
| Llama 3.1 405B Instruct | `meta.llama3-1-405b-instruct-v1:0` | Text | Text | us-west-2, us-east-2 |
| Llama 3.1 70B/8B | `meta.llama3-1-70b-...` / `8b` | Text | Text | us-east-1/2, us-west-2 |
| Llama 3 70B/8B | `meta.llama3-...` | Text | Text | 6+ 区域（含 us-gov） |

**注**：Llama 4（Scout/Maverick）详见 Part 3 Llama 专章（Bedrock 官方文档表格在本次抓取中未显示 Llama 4 条目，但 AWS 博客和第三方资料显示已上架 `meta.llama4-maverick-17b-instruct-v1:0` 和 `meta.llama4-scout-17b-16e-instruct-v1:0`，需进一步验证区域）。

### Mistral AI

| 模型 | Model ID | 输入 | 输出 | 注 |
|------|----------|------|------|-----|
| Mistral Large 2 | `mistral.mistral-large-2407-v1:0` | Text | Text | 见 Part 3 |
| Pixtral Large | `mistral.pixtral-large-2502-v1:0` | Text + Image | Text | 多模态（需验证） |
| Mistral Small | `mistral.mistral-small-...` | Text | Text | |

### Google Gemma 3（Bedrock 新上架）

| 模型 | Model ID | 输入 | 输出 | 区域 |
|------|----------|------|------|------|
| Gemma 3 27B PT | `google.gemma-3-27b-it` | Text + Image | Text | 10 区域 |
| Gemma 3 12B IT | `google.gemma-3-12b-it` | Text + Image | Text | 10 区域 |
| Gemma 3 4B IT | `google.gemma-3-4b-it` | Text + Image | Text | 10 区域 |

### AI21 Labs

| 模型 | Model ID | 备注 |
|------|----------|------|
| Jamba 1.5 Large | `ai21.jamba-1-5-large-v1:0` | 仅 us-east-1 |
| Jamba 1.5 Mini | `ai21.jamba-1-5-mini-v1:0` | 仅 us-east-1 |

### Cohere（主要是 embed / rerank，Chat 主力 R+/R）

| 模型 | Model ID |
|------|----------|
| Command R+ | `cohere.command-r-plus-v1:0` |
| Command R | `cohere.command-r-v1:0` |
| Embed v4（多模态） | `cohere.embed-v4:0` |
| Rerank 3.5 | `cohere.rerank-v3-5:0` |

### 其它

- **Luma AI Ray v2** (`luma.ray-v2:0`)：视频生成，us-west-2
- **Amazon Titan**：Text/Embeddings 老系列，仍在服役

## 关键观察

1. **Claude 4.x 全线上架**：Opus 4.1 → 4.5 → 4.6 → 4.7，Sonnet 4 → 4.5 → 4.6，Haiku 4.5
2. **Claude Opus 4.7** 2026-04-16 刚发布，4天前 Bedrock 同步上架
3. **OpenAI GPT/o 系列**：Bedrock 官方文档未列出（仍然是 Azure 独家 + OpenAI 自营）
4. **全球跨区域推理 profile**：Claude Opus 4.7 用 `us.anthropic.claude-opus-4-7`（US cross-region）；未来会有全球 profile
5. **多模态深度**：Nova Premier 是 Bedrock 唯一支持 Text+Image+Video 输入的超大 LLM（文本输出）
6. **Nova 2** 已开始迭代：Nova 2 Lite / Sonic / Multimodal Embeddings 是 2026 新品
