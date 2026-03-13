# OpenClaw-RL 深度论文研究报告：通过对话训练任何 Agent

> 📅 研究日期：2026-03-13  
> 🔬 研究员：黄山 (wairesearch)  
> 📎 论文：[arXiv:2603.10165](https://arxiv.org/abs/2603.10165)  
> 📎 代码：[Gen-Verse/OpenClaw-RL](https://github.com/Gen-Verse/OpenClaw-RL)  
> 📎 作者：Yinjie Wang, Xuyang Chen, Xiaolong Jin, Mengdi Wang, Ling Yang

---

## 执行摘要

**OpenClaw-RL** 是一个统一的强化学习框架，核心洞察极其简洁：

> **每次 Agent 交互都会产生一个"下一状态信号"（next-state signal）——用户回复、工具输出、终端状态变化——但没有任何现有系统将其作为实时在线学习来源。**

OpenClaw-RL 将这些被浪费的信号回收为两种学习源：
1. **评价信号（Evaluative）** → 通过 PRM Judge 转换为标量奖励（Binary RL）
2. **指导信号（Directive）** → 通过 **后见之明引导的在策略蒸馏（OPD）** 转换为 token 级别的方向性监督

**一句话总结：Agent 越用越好——通过正常使用就能自动优化，无需人工标注数据。**

论文发布于 2026-03-10，发布当天登顶 HuggingFace Daily Papers #1。

---

## 一、问题定义：两种被浪费的信号

### 1.1 现状：Agent 正在丢弃最有价值的数据

每个已部署的 AI Agent 都在产生它所需的改进数据——然后丢弃它。

当 Agent 执行动作 $a_t$ 后，它收到下一状态信号 $s_{t+1}$：
- 用户回复（"不对，你应该先检查文件"）
- 工具执行结果（exit code, stdout/stderr）
- GUI 状态变化（截图差异）
- 测试结果（pass/fail）

现有系统只把 $s_{t+1}$ 当作下一轮的上下文，**完全忽略了它对 $a_t$ 的隐式评价**。

### 1.2 浪费 1：评价信号（Evaluative Signals）

下一状态信号隐式评分了前一个动作：

| 场景 | 下一状态信号 | 隐含评价 |
|------|------------|---------|
| 用户重新提问 | re-query | 不满意 ❌ |
| 测试通过 | pass | 成功 ✅ |
| 错误追踪 | error trace | 失败 ❌ |
| 用户说"好的" | positive reply | 满意 ✅ |

**PRM（过程奖励模型）** 之前几乎只在数学推理中使用（有可验证的标准答案）。OpenClaw-RL 将其扩展到所有交互类型。

### 1.3 浪费 2：指导信号（Directive Signals）

比评价更丰富——下一状态信号经常包含**"应该怎么做"的信息**：

- 用户说 "你应该先检查文件再编辑" → 不仅说了"错了"，还说了**哪些 token 应该不同以及如何不同**
- SWE 错误追踪 → 通常暗示了具体的修正方向

当前的 RLVR 方法用标量奖励，**无法将这种信息转换为方向性的策略梯度**。

---

## 二、核心方法：两种互补的学习范式

### 2.1 Binary RL — 从评价信号中学习

```
动作 a_t → 下一状态 s_{t+1} → PRM Judge → r ∈ {+1, -1, 0} → PPO 训练
```

**PRM Judge 构造**：
- 给定 response $a_t$ 和 next state $s_{t+1}$，Judge 模型评估 $a_t$ 的质量
- 运行 $m$ 次独立查询，取多数投票 $r_{final} = MajorityVote(r_1, ..., r_m)$
- 对个人 Agent：判断用户的下一条回复是否表达了满意/不满
- 对通用 Agent：判断环境反馈是否表明朝任务目标取得了进展

**训练目标**：标准 PPO 风格的 clipped surrogate loss，$\epsilon=0.2$, $\epsilon_{high}=0.28$, $\beta_{KL}=0.02$。

**特点**：覆盖面广（所有评分轮次都参与训练），但信号粗糙（每个样本只有 1 个标量）。

### 2.2 OPD（Hindsight-Guided On-Policy Distillation）— 从指导信号中学习 ⭐⭐⭐⭐⭐

**这是论文最核心的创新。**

> 核心洞察：如果我们用从 $s_{t+1}$ 中提取的文本 hint 增强原始 prompt，**同一模型**会产生不同的 token 分布——一个"知道"正确答案应该是什么的分布。两个分布之间的 per-token gap 就是方向性优势。

**四步流程**：

#### Step 1: 后见之明提示提取

```
Judge(a_t, s_{t+1}) → {score ∈ {+1, -1}, hint ∈ Text}
```

关键设计：**不直接使用 $s_{t+1}$ 作为 hint**。原始的下一状态信号往往嘈杂、冗长或包含无关信息。Judge 模型将 $s_{t+1}$ 蒸馏为简洁、可操作的指令（通常 1-3 句话）。

#### Step 2: Hint 选择和质量过滤

- 从正面投票中选择最长（最有信息量）的 hint
- 如果没有有效 hint → **直接丢弃样本**
- 这是刻意的：OPD 用样本数量换取信号质量

#### Step 3: 增强教师构造

```
s_enhanced = s_t ⊕ "[user's hint]\n{hint}"
```

这个增强 prompt 就好像用户**事先**就告诉了 Agent 正确答案。

#### Step 4: Token 级别优势计算

```
A_t = log π_teacher(a_t | s_enhanced) - log π_θ(a_t | s_t)
```

- $A_t > 0$：教师（知道 hint）认为这个 token 概率应该更高 → 学生应该加强
- $A_t < 0$：教师认为这个 token 不太合适 → 学生应该削弱

**与标量优势的本质区别**：在同一个 response 中，有些 token 被强化，有些被抑制。这是**真正的 per-token 方向性引导**。

### 2.3 组合方法 — Binary RL + OPD

两种方法互补而非竞争：

| 维度 | Binary RL | OPD | 组合 |
|------|----------|-----|------|
| 信号类型 | 评价性（好/坏） | 方向性 | 评价 + 方向 |
| 优势 | 序列级标量 | Token 级方向性 | 混合 |
| 密度 | 所有评分轮次 | 仅有 hint 的轮次 | 所有评分轮次 |
| 反馈类型 | 用户/环境 | 显式纠正 | 隐式 + 显式 |
| 信号丰富度 | 每样本 1 个标量 | 每 token 1 个值 | 每 token 1 个值 |

组合优势公式：
$$A_t = w_{binary} \cdot r_{final} + w_{opd} \cdot (\log \pi_{teacher}(a_t | s_{enhanced}) - \log \pi_\theta(a_t | s_t))$$

---

## 三、系统架构：四组件完全解耦的异步流水线

### 3.1 架构总览

```
Policy Serving  →  Environment  →  Reward Judging  →  Policy Training
  (SGLang)         (HTTP/API)      (SGLang/API)       (Megatron)

四个组件完全异步运行，互不阻塞：
- 模型在服务下一个用户请求
- PRM 在评判上一个回复
- Trainer 在应用梯度更新
——没有任何一个在等待另一个
```

### 3.2 个人 Agent 的 Session 感知

环境就是用户的设备，通过机密 API 连接 RL 服务器。每个 API 请求分为两类：

| 类型 | 说明 | 是否训练 |
|------|------|---------|
| **Main-line turn** | Agent 的主要回复和工具执行结果 | ✅ 产生训练样本 |
| **Side turn** | 辅助查询、内存整理、环境转换 | ❌ 转发但不训练 |

### 3.3 支持的场景矩阵

| 场景 | 环境 | 下一状态信号 | 时间跨度 |
|------|------|------------|---------|
| OpenClaw（个人） | 个人设备 | 用户回复 / 工具调用结果 | 长 |
| Terminal | Shell 执行沙箱 | stdout/stderr, exit code | 长 |
| GUI | 屏幕状态 + 可访问性树 | 视觉状态差异、任务进度 | 长 |
| SWE | 代码仓库 + 测试套件 | 测试结果、diff、lint 输出 | 长 |
| Tool-call | API/函数执行 | 返回值、错误追踪 | 中 |

### 3.4 可扩展性

- **个人 Agent**：单用户设备，稀疏、基于会话的交互流
- **通用 Agent**：云服务托管数百个并行环境（Terminal 128个、GUI/SWE 64个、Tool-call 32个）

---

## 四、实验结果

### 4.1 个人 Agent：学生和老师场景

**设置**：用 LLM 模拟场景
- **学生**：用 OpenClaw 做作业，不想被发现在用 AI
- **老师**：用 OpenClaw 批改作业，希望评语具体且友善
- 基础模型：Qwen3-4B

**结果**（基线分数 0.17）：

| 方法 | 更新 8 步 | 更新 16 步 |
|------|----------|----------|
| Binary RL | 0.25 | 0.23 |
| OPD | 0.25 | **0.72** |
| **Combined** | **0.76** | **0.81** |

**关键发现**：
- Binary RL 单独只提供边际改进
- OPD 初期改进慢（因为训练样本稀疏），但后期爆发
- **组合方法大幅超越两者** → 证明互补性
- 学生场景：仅 36 次问题解答交互后，Agent 学会避免明显的 AI 风格表达
- 老师场景：仅 24 次批改交互后，Agent 学会写更友善、更详细的反馈

### 4.2 通用 Agent：跨场景 RL

| 场景 | 模型 | 集成奖励 | 仅结果奖励 |
|------|------|---------|----------|
| Tool-call | Qwen3-4B-SFT | **0.30** | 0.17 |
| GUI | Qwen3VL-8B-Thinking | **0.33** | 0.31 |

**关键发现**：集成过程奖励（PRM）+ 结果奖励显著优于仅结果奖励。特别是 tool-call 场景提升近一倍。

---

## 五、技术创新点评估

### 5.1 创新性评级

| 创新点 | 评级 | 评价 |
|--------|------|------|
| Next-state signal 作为在线学习源 | ⭐⭐⭐⭐⭐ | 观察简洁但深刻，将被丢弃的数据变为训练信号 |
| OPD（后见之明引导蒸馏） | ⭐⭐⭐⭐⭐ | 最核心创新，token 级方向性监督比标量奖励丰富得多 |
| 四组件异步架构 | ⭐⭐⭐⭐ | 工程上优雅，实现零中断服务 |
| 统一多场景 RL | ⭐⭐⭐⭐ | 首次在同一框架中支持个人对话+Terminal+GUI+SWE+Tool-call |
| Binary + OPD 组合 | ⭐⭐⭐⭐ | 实验充分证明互补性 |

### 5.2 与现有方法的本质区别

```
RLHF：标量偏好信号 → 粗糙
DPO：需要成对偏好数据 → 离线
标准蒸馏：需要独立的更强教师模型 → 额外成本
后见之明重标注（HER/STaR/HIR）：在固定数据集上操作 → 离线

OpenClaw-RL OPD：
- 从实时下一状态信号中提取文本 hint（后见之明重标注）
- 模型作为自己在 hint 增强上下文下的教师（自蒸馏）
- 产生 token 级方向性优势监督
- 无需预收集数据、无需外部教师、无需成对偏好
```

### 5.3 OPD 的设计精妙之处

1. **不直接用 $s_{t+1}$ 作为 hint**：原始信号噪声大，用 Judge 蒸馏成 1-3 句简洁指令
2. **严格的质量过滤**：只有 hint > 10 字符且 Judge 打正分的样本才进入训练
3. **样本量换信号质量**：与 Binary RL 互补——Binary RL 提供广泛覆盖（粗信号），OPD 提供精确校正（少样本但高分辨率）
4. **自教师**：不需要更强的模型，同一模型在增强上下文下就是教师

---

## 六、对我们的启示

### 6.1 直接相关的应用价值

我们当前运行的 OpenClaw 多 Agent 系统，**每天都在产生大量被浪费的 next-state signal**：

| 我们的场景 | 被浪费的信号 | 潜在价值 |
|-----------|------------|---------|
| 用户纠正 Agent 回复 | 用户重新提问、修改指令 | 个性化偏好学习 |
| 代码执行结果 | 编译错误、测试结果 | 代码能力提升 |
| 搜索结果质量 | 用户是否继续追问 | 搜索策略优化 |
| 任务完成度 | 用户确认/否定 | 任务理解能力 |

### 6.2 短期可行动项

1. **关注 LoRA 训练支持**（已于 3/12 发布）——使用消费级 GPU 即可微调
2. **Track 1 最适合我们**：个人 Agent 的在线优化，无需大规模基础设施
3. **推荐 Combined 方法**：实验证明组合效果最佳

### 6.3 中期展望

- OpenClaw-RL 路线图中的 **"Beyond the policy: extend learning to skills and memory"** 意味着未来不仅训练模型参数，还训练 Skills 和 Memory 文件
- 这将把 Agent 的个性化从"模型层面"扩展到"知识层面"

### 6.4 局限和注意事项

| 局限 | 说明 |
|------|------|
| 硬件需求高 | 默认 8×GPU，LoRA 降低了门槛但仍需关注 |
| 需要自托管模型 | 不适用于 API-only 的模型（如 Claude、GPT-4） |
| 实验主要在 Qwen3 上 | 其他模型的效果有待验证 |
| 模拟实验为主 | 真实用户场景的长期效果有待观察 |
| 个人 Agent 交互稀疏 | 单用户的训练信号量有限，收敛可能较慢 |

---

## 七、论文在学术脉络中的位置

```
RL for LLMs 演进：
RLHF (2017) → DPO (2023) → GRPO/DeepSeek-R1 (2024-2025)
                                        ↓
                              批量离线训练
                                        ↓
              OpenClaw-RL (2026): 实时在线训练 ← 范式转变

Agentic RL 演进：
ReAct/Toolformer (2023) → SWE-agent (2024) → DigiRL/WebRL (2024)
         ↓                      ↓                    ↓
    单一场景，离线           单一场景，RL        单一场景，RL
                                        ↓
              OpenClaw-RL (2026): 统一多场景在线 RL ← 首次统一

PRM 演进：
Math-Shepherd (2024) → GenPRM (2025) → RLAnything (2026)
         ↓                    ↓                ↓
    数学推理               通用推理        多场景 Agent
                                        ↓
              OpenClaw-RL: 实时 PRM 从 next-state signal ← 在线化
```

---

## 八、参考来源

1. **论文**：[OpenClaw-RL: Train Any Agent Simply by Talking](https://arxiv.org/abs/2603.10165) (arXiv:2603.10165, 2026-03-10)
2. **代码**：[Gen-Verse/OpenClaw-RL](https://github.com/Gen-Verse/OpenClaw-RL)
3. **HuggingFace Papers**：[papers/2603.10165](https://huggingface.co/papers/2603.10165)
4. **alphaXiv**：[overview/2603.10165](https://www.alphaxiv.org/overview/2603.10165)
5. **基础框架**：[THUDM/slime](https://github.com/THUDM/slime) — 异步 RL 训练框架
6. **相关工作**：RLAnything [wang2026], ReasonFlux [yang2025], SuperCorrect [yang2025]

---

*报告完成于 2026-03-13 12:38 UTC*
