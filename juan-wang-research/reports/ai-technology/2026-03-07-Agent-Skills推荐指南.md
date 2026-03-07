# 500+ Agent Skills 免费下载！Anthropic、Google、Vercel 官方都在用的"外挂"，让你的 AI 助手原地起飞！

> **警告**: 阅读本文后，你的 AI 助手可能会变得比你还聪明。

---

## 你还在用"裸奔"的 AI？

想象一下，你买了一台顶配电脑，却只用来打字。

这就是大多数人使用 AI 的现状。

Claude、ChatGPT、Gemini 这些大模型本身能力很强，但面对专业领域的工作流时，它们就像没有说明书的新员工——不知道怎么下手。

**Agent Skills 就是那个说明书。**

---

## 什么是 Agent Skills？

简单说，**Skills 是 AI 的"技能包"**。

| 没有 Skills | 有 Skills |
|-------------|-----------|
| AI: "我不知道怎么操作 Figma" | AI: "根据设计规范，我帮你..." |
| AI: "Terraform 语法我可能写错" | AI: "按 HashiCorp 最佳实践..." |
| AI: "Stripe 集成我不熟悉" | AI: "按官方最佳实践配置..." |

**一个 Skill 包含**：
- 📋 标准操作流程
- 💻 代码模板
- 📖 领域约定
- ✅ 验证逻辑

---

## 这个仓库有多牛？

**549+ Skills**，而且不是随便生成的垃圾内容。

看看这些官方出品：

| 公司 | Skills 数量 |
|------|-------------|
| Anthropic (Claude 官方) | 16+ |
| Google Labs / Gemini | 15+ |
| Vercel | 10+ |
| Stripe | 2 |
| Cloudflare | 8+ |
| HashiCorp | 3 |
| Sentry | 多个 |
| Microsoft | 多个 |

**仓库地址**: https://github.com/VoltAgent/awesome-agent-skills

兼容：Claude Code、Codex、Gemini CLI、Cursor、Copilot、Windsurf...

---

## 🏆 精选推荐：10 个必装 Skills

### 1. 🔥 Claude 官方：MCP Builder

**谁该装**: 想让 AI 连接外部 API、数据库的人

**一句话**: 教你的 AI 创建自己的工具！

```
github.com/anthropics/skills/tree/main/skills/mcp-builder
```

### 2. 🎨 Claude 官方：Web Artifacts Builder

**谁该装**: 前端开发者、需要快速原型的人

**一句话**: 用 React + Tailwind 构建 Claude Artifacts

```
github.com/anthropics/skills/tree/main/skills/web-artifacts-builder
```

### 3. 💳 Stripe 官方：Best Practices

**谁该装**: 做支付集成的开发者

**一句话**: 按官方规范集成 Stripe，少踩坑

```
github.com/stripe/ai/tree/main/skills/stripe-best-practices
```

### 4. ☁️ Vercel：Next.js Best Practices

**谁该装**: Next.js 开发者

**一句话**: 官方推荐的模式和最佳实践

```
github.com/vercel-labs/next-skills/tree/main/skills/next-best-practices
```

### 5. 🌐 Cloudflare：Agents SDK

**谁该装**: 想在 Cloudflare 上构建 AI Agent 的人

**一句话**: 有状态、有调度、有 MCP，Agent 开发全栈方案

```
github.com/cloudflare/skills/tree/main/skills/agents-sdk
```

### 6. 🏗️ HashiCorp：Terraform Code Generation

**谁该装**: DevOps、云基础设施工程师

**一句话**: 自动生成符合规范的 Terraform 代码

```
github.com/hashicorp/agent-skills/tree/main/terraform/code-generation
```

### 7. 🔥 Firecrawl：Web Scraping

**谁该装**: 需要抓取网页数据的人

**一句话**: AI 时代的爬虫神器

```
github.com/firecrawl/cli/tree/main/skills/firecrawl-cli
```

### 8. 📱 Expo：App Deployment

**谁该装**: React Native / Expo 开发者

**一句话**: 部署 Expo 应用到生产环境

```
github.com/expo/skills/tree/main/plugins/expo-deployment
```

### 9. 🎥 Remotion：Programmatic Video

**谁该装**: 需要程序化生成视频的人

**一句话**: 用 React 代码生成视频！

```
github.com/remotion-dev/skills/tree/main/skills/remotion
```

### 10. 📊 Typefully：Social Media

**谁该装**: 内容创作者、运营人员

**一句话**: AI 帮你写社交媒体内容并发布

```
github.com/typefully/agent-skills/tree/main/skills/typefully
```

---

## 📦 按场景分类推荐

### 开发者必备

| Skill | 用途 | 来源 |
|-------|------|------|
| GitHub Workflow | PR、代码审查、分支策略 | CallStack |
| React Best Practices | React 最佳实践 | Vercel |
| React Native Performance | RN 性能优化 | CallStack |
| Webapp Testing | Playwright 测试 | Anthropic |

### 云服务用户

| Skill | 用途 | 来源 |
|-------|------|------|
| Cloudflare Workers | 部署 Workers、KV、R2 | Cloudflare |
| Netlify Functions | Serverless 函数 | Netlify |
| Neon Postgres | Serverless PG 最佳实践 | Neon |
| Supabase Postgres | PG 最佳实践 | Supabase |

### 企业应用

| Skill | 用途 | 来源 |
|-------|------|------|
| Google Workspace CLI | 管理 Gmail、Drive、Calendar | Google |
| ClickHouse | 数据分析最佳实践 | ClickHouse |
| Sanity CMS | 内容管理最佳实践 | Sanity |
| Better Auth | 认证集成最佳实践 | Better Auth |

### 创意与内容

| Skill | 用途 | 来源 |
|-------|------|------|
| Algorithmic Art | 生成艺术 | Anthropic |
| Canvas Design | 视觉设计 | Anthropic |
| Theme Factory | 主题生成 | Anthropic |
| Internal Comms | 报告、Newsletter | Anthropic |

---

## ⚠️ 安全警告

**重要**: Skills 可以包含代码，可能有安全风险。

安装前务必：
1. 检查 Skill 来源是否可信
2. 阅读 SKILL.md 和相关代码
3. 使用安全扫描工具：
   - [Snyk Skill Security Scanner](https://github.com/snyk/agent-scan)
   - [Agent Trust Hub](https://ai.gendigital.com/agent-trust-hub)

---

## 🚀 如何使用？

### Claude Code 用户

```bash
# 方法1: 直接复制到 skills 目录
cp -r /path/to/skill ~/.claude/skills/

# 方法2: 在项目中使用
# 创建 .claude/skills/ 目录，放入 Skill 文件夹
```

### Gemini CLI 用户

```bash
# 参考 Gemini CLI 文档配置 Skills 路径
```

### Cursor / Copilot 用户

参考各自工具的 Skills 配置文档。

---

## 💡 最佳实践

根据 SkillsBench 研究发现：

| 建议 | 原因 |
|------|------|
| **聚焦优于全面** | 2-3 个模块的 Skill 效果最好 |
| **使用官方 Skills** | 大厂出品的 Skills 质量更有保障 |
| **不要贪多** | 太多 Skills 会干扰 AI 判断 |
| **定期更新** | Skills 会持续改进 |

---

## 📈 数据说话

这个仓库有多受欢迎？

- ⭐ GitHub Star 数持续增长
- 🤝 40+ 官方团队贡献
- 📦 549+ Skills 可用
- 🔄 持续更新维护

---

## 🎯 总结

| 你 | Agent Skills |
|----|---------------|
| 想让 AI 更聪明 | ✅ 装官方 Skills |
| 想少踩坑 | ✅ 用最佳实践 Skills |
| 想提高效率 | ✅ 选聚焦型 Skills |
| 想省钱 | ✅ 小模型 + Skills = 大模型效果 |

**仓库地址**: https://github.com/VoltAgent/awesome-agent-skills

**记得给个 Star ⭐**

---

> 📝 本文由卷王小组研究整理  
> 🔗 来源: [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)  
> 📅 发布时间: 2026年3月7日
