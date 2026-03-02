# 卷王小组研究报告

**研究团队**：卷王小组  
**仓库地址**：https://github.com/wujiaming88/openclaw_daily_file  
**本地目录**：/root/.openclaw/workspace/project/openclaw_daily_file/juan-wang-research

---

## 快速导航

- [📊 周报](#周报) - 每周行业动态汇总
- [📰 日报](#日报) - 每日重大事件分析
- [🤖 AI技术研究](#ai技术研究) - AI技术分析与评测
- [⚔️ 军事情报](#军事情报) - 军事冲突与战略分析
- [📈 GitHub趋势](#github趋势) - 热门项目与技术趋势
- [📰 新闻汇总](#新闻汇总) - 多源新闻与深度解读

---

## 目录结构

```
juan-wang-research/
├── README.md                    # 仓库说明（本文件）
├── reports/                     # 所有研究报告
│   ├── weekly/                 # 周报类研究
│   ├── daily/                  # 日报类研究
│   ├── ai-technology/           # AI技术研究
│   ├── military-intelligence/     # 军事情报研究
│   ├── github-trending/         # GitHub趋势分析
│   └── news-summary/           # 新闻汇总分析
└── archive/                    # 历史归档（按年份）
    └── 2026/                # 2026年归档
```

---

## 报告分类

### 周报

**📊 用途**：汇总一周内的行业动态、技术突破、市场分析

**文件命名**：`YYYY-WW-主题.md`  
**示例**：`2026-09-全球AI科技资讯周报.md`  
**频率**：每周一次

**最新报告**：
- [2026-03-02-全球AI科技资讯周报.md](reports/ai-technology/2026-03-02-全球AI科技资讯周报.md)

### 日报

**📰 用途**：当日重大事件、突发事件、深度分析

**文件命名**：`YYYY-MM-DD-主题.md`  
**示例**：`2026-03-01-美军对伊朗军事行动.md`  
**频率**：每日或按需

**最新报告**：
- [2026-03-01-美军对伊朗军事行动.md](reports/military-intelligence/2026-03-01-美军对伊朗军事行动.md)

### AI技术研究

**🤖 用途**：AI技术分析、模型评测、趋势预测

**文件命名**：`YYYY-MM-DD-技术名称.md`  
**频率**：按需

**最新报告**：
- [2026-03-01-OpenClaw架构分析.md](reports/ai-technology/2026-03-01-OpenClaw架构分析.md)
- [2026-03-01-OpenClaw架构博客.md](reports/ai-technology/2026-03-01-OpenClaw架构博客.md)
- [2026-03-01-OpenClaw架构设计.md](reports/ai-technology/2026-03-01-OpenClaw架构设计.md)
- [2026-03-01-OpenClaw架构设计最终版.md](reports/ai-technology/2026-03-01-OpenClaw架构设计最终版.md)
- [2026-03-01-GitHub概览.md](reports/ai-technology/2026-03-01-GitHub概览.md)
- [2026-03-01-Agent运行时分析.md](reports/ai-technology/2026-03-01-Agent运行时分析.md)
- [2026-03-01-Gateway配置分析.md](reports/ai-technology/2026-03-01-Gateway配置分析.md)
- [2026-03-01-通道架构分析.md](reports/ai-technology/2026-03-01-通道架构分析.md)

### 军事情报

**⚔️ 用途**：军事冲突分析、地缘政治评估、战略分析

**文件命名**：`YYYY-MM-DD-事件名称.md`  
**频率**：按需

**最新报告**：
[查看所有军事情报报告](reports/military-intelligence/)

### GitHub趋势

**📈 用途**：GitHub热门项目分析、技术趋势洞察

**文件命名**：`YYYY-WW-GitHub-Trending.md` 或 `trending_YYYY-MM-DD.md`  
**频率**：每周一次

**最新报告**：
[查看所有GitHub趋势报告](reports/github-trending/)

### 新闻汇总

**📰 用途**：多源新闻汇总、交叉验证、深度解读

**文件命名**：`YYYY-MM-DD-新闻类型.md`  
**频率**：每日或按需

**最新报告**：
[查看所有新闻汇总报告](reports/news-summary/)

---

## 研究原则

卷王小组遵循以下工作原则：

### 态度
- **专业**：使用专业术语和数据支撑
- **严谨**：信息来源可靠，论证严密
- **细致**：关注细节，追求全面

### 输出要求
- **对阅读者友好**：结构清晰，易于理解
- **专业性强**：论据充分，引用准确
- **结构清晰**：层次分明，逻辑连贯
- **论据充分**：数据支撑，事实为基
- **引用准确**：来源明确，可追溯
- **语言精炼**：表达专业，避免冗余
- **逻辑严密**：分析深入，推理合理
- **结论可靠**：建议可行，价值判断准确

---

## 信息时效性检查

所有研究报告必须严格检查信息时效性：

1. **严格检查时效性**：用户指定时间范围时，必须筛选符合该范围的信息
2. **标注发布时间**：每条信息都应标注明确的发布时间
3. **排除过时信息**：超出指定时间范围的信息应明确排除
4. **验证信息新鲜度**：核实标榜"最新"、"突发"信息的发布时间
5. **区分历史背景**：背景信息应明确标注
6. **时间范围优先级**：用户指定的时间范围 > 信息本身的"最新"标签

---

## Git工作流

### 提交规范

```bash
# 添加文件
git add reports/ai-technology/2026-03-02-技术名称.md

# 提交（使用有意义的提交信息）
git commit -m "添加AI技术研究报告 - 2026-03-02"

# 推送到远端
git push
```

### 提交信息规范

- **添加报告**：`添加[类型]报告 - YYYY-MM-DD`
- **更新报告**：`更新[类型]报告 - YYYY-MM-DD`
- **重构结构**：`重构目录结构：[说明]`

### 分支策略

- **main**：主分支，存放已发布的报告
- **draft**：草稿分支，存放未完成的研究

---

## 统计信息

- **总报告数**：17篇
- **AI技术研究**：9篇
- **军事情报**：1篇
- **GitHub趋势**：3篇
- **新闻汇总**：2篇
- **周报**：1篇
- **日报**：1篇

---

## 联系方式

- **研究团队**：卷王小组
- **仓库地址**：https://github.com/wujiaming88/openclaw_daily_file
- **本地目录**：/root/.openclaw/workspace/project/openclaw_daily_file/juan-wang-research

---

**最后更新**：2026年3月2日  
**版本**：v3.0  
**维护者**：卷王小组
