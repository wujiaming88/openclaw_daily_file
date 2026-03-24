# OpenClaw apply_patch 工具深度研究报告

> **版本**: v1.0
> **日期**: 2026-03-24
> **作者**: 黄山 (wairesearch) · 卷王小组
> **研究范围**: apply_patch 原理、实现、场景、价值、最佳实践

---

## 目录

1. [概述：apply_patch 是什么](#1-概述apply_patch-是什么)
2. [起源：从 Codex 到 OpenClaw](#2-起源从-codex-到-openclaw)
3. [补丁语法详解](#3-补丁语法详解)
4. [实现原理：源码级解析](#4-实现原理源码级解析)
5. [与其他文件操作工具对比](#5-与其他文件操作工具对比)
6. [使用场景](#6-使用场景)
7. [核心价值](#7-核心价值)
8. [配置与安全](#8-配置与安全)
9. [最佳实践](#9-最佳实践)
10. [局限性与注意事项](#10-局限性与注意事项)

---

## 1. 概述：apply_patch 是什么

### 1.1 一句话定义

`apply_patch` 是 OpenClaw 的一个**实验性文件编辑工具**，使用结构化的补丁格式在**单次工具调用**中完成**多文件、多位置的批量修改**。

### 1.2 核心定位

```
传统 edit 工具：一次调用 → 一个文件 → 一处修改
apply_patch：   一次调用 → 多个文件 → 多处修改 + 创建 + 删除 + 重命名
```

### 1.3 关键特征

| 特征 | 说明 |
|------|------|
| **批量操作** | 单次调用修改多个文件 |
| **原子性** | 所有 hunk 在一次调用中全部应用 |
| **结构化格式** | 专用的补丁 DSL，而非自由文本 |
| **实验性** | 默认禁用，需显式启用 |
| **模型限制** | 仅支持 OpenAI 系列模型（含 Codex） |

---

## 2. 起源：从 Codex 到 OpenClaw

### 2.1 OpenAI Codex 的 apply_patch

`apply_patch` 最初由 **OpenAI Codex** 项目设计，是 Codex CLI 的核心文件编辑机制。

**设计背景：**

传统 AI 编码工具在修改文件时面临两个核心问题：

1. **精确匹配问题**：`edit` 工具要求精确匹配 `oldText`，模型容易因空格、缩进、引号等细微差异而匹配失败
2. **多文件效率问题**：修改 5 个文件需要 5 次工具调用，每次都要等模型生成→调用→返回结果→再生成

OpenAI 团队为 GPT-5/Codex 模型系列设计了 `apply_patch` 格式，核心目标是：

- **减少工具调用次数**：一次调用完成所有修改
- **容错性更强**：上下文匹配机制比精确字符串匹配更鲁棒
- **结构化可解析**：比自由文本 diff 更容易安全解析
- **模型原生支持**：OpenAI 模型在训练中已理解此格式

### 2.2 OpenClaw 的移植

OpenClaw 将 Codex 的 `apply_patch` 格式作为 `exec` 工具的子工具移植进来。移植时增加了：

- **工作空间安全边界**：`workspaceOnly` 路径限制
- **沙箱支持**：可在 Docker 沙箱中执行
- **模型白名单**：`allowModels` 按模型限制使用
- **路径别名防护**：防止符号链接逃逸

---

## 3. 补丁语法详解

### 3.1 总体结构

```
*** Begin Patch
[一个或多个文件操作]
*** End Patch
```

这是一个高层信封（envelope）格式：以 `*** Begin Patch` 开始，`*** End Patch` 结束，中间包含文件操作序列。

### 3.2 三种文件操作

#### 操作一：Add File（创建新文件）

```
*** Add File: path/to/new-file.txt
+第一行内容
+第二行内容
+第三行内容
```

- 每行内容必须以 `+` 前缀
- 路径相对于工作区根目录
- 自动创建不存在的中间目录

#### 操作二：Delete File（删除文件）

```
*** Delete File: path/to/obsolete.txt
```

- 仅声明路径，后面不跟任何内容
- 直接删除目标文件

#### 操作三：Update File（修改现有文件）

```
*** Update File: src/app.ts
@@
 上下文行（不变）
-要删除的旧行
+要添加的新行
 上下文行（不变）
```

Update 是最复杂的操作，支持：

**a) 多段修改（Multi-hunk）：**

```
*** Update File: src/app.ts
@@ class UserService
 constructor() {
-  this.timeout = 3000
+  this.timeout = 5000
 }
@@ async fetchUser()
-  const res = await fetch(url)
+  const res = await fetch(url, { timeout: this.timeout })
```

**b) 文件重命名（Move）：**

```
*** Update File: src/old-name.ts
*** Move to: src/new-name.ts
@@
-old content
+new content
```

**c) 文件末尾插入：**

```
*** Update File: src/config.ts
*** End of File
+// 新增的末尾内容
+export default config
```

### 3.3 行前缀含义

| 前缀 | 含义 |
|------|------|
| `空格` | 上下文行（不变，用于定位） |
| `-` | 要删除的行 |
| `+` | 要添加的行 |

### 3.4 @@ 操作符：上下文跳转

`@@` 后可跟可选的**上下文标头**，用于跳转到文件中的特定位置：

```
@@ class BaseClass          ← 跳到 BaseClass 类
@@ def method():            ← 跳到 method 方法
@@                          ← 从当前位置继续
```

**上下文规则：**

1. 默认在每个修改点前后显示 3 行上下文
2. 如果 3 行上下文不足以唯一定位，使用 `@@` 指定所属的类或函数
3. 如果类或函数中有重复代码，可嵌套多个 `@@`：
   ```
   @@ class BaseClass
   @@ def method():
   [3行上下文]
   -old
   +new
   ```

### 3.5 完整语法（BNF）

```
Patch     := Begin { FileOp } End
Begin     := "*** Begin Patch" NEWLINE
End       := "*** End Patch" NEWLINE
FileOp    := AddFile | DeleteFile | UpdateFile
AddFile   := "*** Add File: " path NEWLINE { "+" line NEWLINE }
DeleteFile:= "*** Delete File: " path NEWLINE
UpdateFile:= "*** Update File: " path NEWLINE [ MoveTo ] { Hunk }
MoveTo    := "*** Move to: " newPath NEWLINE
Hunk      := "@@" [ header ] NEWLINE { HunkLine } [ "*** End of File" NEWLINE ]
HunkLine  := (" " | "-" | "+") text NEWLINE
```

### 3.6 综合示例

```
*** Begin Patch
*** Add File: src/utils/logger.ts
+import winston from 'winston'
+
+export const logger = winston.createLogger({
+  level: 'info',
+  format: winston.format.json(),
+})
*** Update File: src/app.ts
@@ import
-import { log } from './old-logger'
+import { logger } from './utils/logger'
@@ class App
@@ handleRequest()
-    log('request received')
+    logger.info('request received', { timestamp: Date.now() })
*** Update File: src/config.ts
*** Move to: src/config/index.ts
@@
-export const PORT = 3000
+export const PORT = parseInt(process.env.PORT || '3000', 10)
*** Delete File: src/old-logger.ts
*** End Patch
```

这个补丁在一次调用中完成了：
1. 创建新文件 `logger.ts`
2. 修改 `app.ts` 的两处导入和调用
3. 将 `config.ts` 重命名并修改内容
4. 删除旧文件 `old-logger.ts`

---

## 4. 实现原理：源码级解析

### 4.1 整体处理流程

```
用户/模型调用 apply_patch(input)
        │
        ↓
┌─ parsePatchText(input) ──────────┐
│  1. 验证边界标记                    │
│  2. 逐 hunk 解析                   │
│  3. 返回 { hunks[], patch }        │
└──────────────────────────────────┘
        │
        ↓ 遍历每个 hunk
        │
    ┌───┼────────────────────────┐
    │   │                        │
  Add?  Delete?              Update?
    │     │                      │
    ↓     ↓                      ↓
 写文件  删文件         ┌─ applyUpdateHunk() ─┐
                       │ 1. 读取原文件          │
                       │ 2. computeReplacements │
                       │ 3. applyReplacements   │
                       │ 4. 写回文件            │
                       └───────────────────────┘
        │
        ↓
  返回摘要 (A/M/D 列表)
```

### 4.2 解析器：parsePatchText

```javascript
function parsePatchText(input) {
  // 1. 验证边界标记 (*** Begin Patch / *** End Patch)
  const validated = checkPatchBoundariesLenient(lines);

  // 2. 宽松模式：容忍外层 <<EOF 包裹
  //    (模型有时会输出 heredoc 包裹的补丁)

  // 3. 逐个解析 hunk
  while (remaining.length > 0) {
    const { hunk, consumed } = parseOneHunk(remaining, lineNumber);
    hunks.push(hunk);
  }

  return { hunks, patch };
}
```

**关键设计：宽松边界检查**

解析器支持模型输出中常见的 `<<EOF` 包裹：

```
<<EOF
*** Begin Patch
*** Update File: ...
*** End Patch
EOF
```

这个容错设计让工具对模型输出更鲁棒。

### 4.3 核心算法：seekSequence（模糊匹配）

这是 `apply_patch` 最精妙的部分——**四级渐进匹配算法**：

```javascript
function seekSequence(lines, pattern, start, eof) {
  // 第 1 级：精确匹配
  for (let i = start; i <= maxStart; i++)
    if (linesMatch(lines, pattern, i, v => v)) return i;

  // 第 2 级：忽略行尾空白
  for (let i = start; i <= maxStart; i++)
    if (linesMatch(lines, pattern, i, v => v.trimEnd())) return i;

  // 第 3 级：忽略首尾空白
  for (let i = start; i <= maxStart; i++)
    if (linesMatch(lines, pattern, i, v => v.trim())) return i;

  // 第 4 级：标准化标点符号
  for (let i = start; i <= maxStart; i++)
    if (linesMatch(lines, pattern, i, v => normalizePunctuation(v.trim()))) return i;

  return null;
}
```

**四级匹配策略：**

| 级别 | 策略 | 容错范围 |
|------|------|---------|
| Level 1 | 精确匹配 | 无容错 |
| Level 2 | 忽略行尾空白 | 行尾空格/Tab 差异 |
| Level 3 | 忽略首尾空白 | 缩进差异 |
| Level 4 | 标准化标点符号 | Unicode 标点差异 |

**标点标准化映射（normalizePunctuation）：**

| 原始字符 | 标准化为 | 场景 |
|---------|---------|------|
| `‐ ‑ ‒ – — ― −` | `-` | 各种破折号/连字号 |
| `' ' ‚ ‛` | `'` | 各种单引号 |
| `" " „ ‟` | `"` | 各种双引号 |
| `\u00A0` 等 12 种空白字符 | 普通空格 | 各种 Unicode 空格 |

**为什么需要这种设计？**

AI 模型生成的代码经常出现：
- 使用中文引号 `""` 代替英文引号 `""`
- 使用 em-dash `—` 代替普通连字号 `-`
- 因 tokenizer 差异产生行尾空白
- 因上下文窗口限制导致缩进偏移

四级渐进匹配让 `apply_patch` 即使在模型输出不完美的情况下也能成功应用补丁。

### 4.4 替换算法：applyReplacements

```javascript
function applyReplacements(lines, replacements) {
  const result = [...lines];
  // 关键：从后往前应用，避免索引偏移
  for (const [startIndex, oldLen, newLines] of [...replacements].toReversed()) {
    // 先删除旧行
    for (let i = 0; i < oldLen; i++)
      if (startIndex < result.length) result.splice(startIndex, 1);
    // 再插入新行
    for (let i = 0; i < newLines.length; i++)
      result.splice(startIndex + i, 0, newLines[i]);
  }
  return result;
}
```

**从后往前应用**：`replacements` 按起始位置排序后反转，确保前面的替换不会影响后面替换的索引位置。这是经典的 patch 应用策略。

### 4.5 路径安全：resolvePatchPath

```javascript
async function resolvePatchPath(filePath, options, aliasPolicy) {
  // 沙箱模式：通过沙箱桥接器解析路径
  if (options.sandbox) {
    const resolved = options.sandbox.bridge.resolvePath({ filePath, cwd });
    if (options.workspaceOnly !== false)
      await assertSandboxPath({ filePath: resolved.hostPath, ... });
    return { resolved: resolved.hostPath, display: resolved.relativePath };
  }

  // 非沙箱模式：workspaceOnly 检查
  const resolved = options.workspaceOnly !== false
    ? (await assertSandboxPath({ filePath, cwd, root: cwd, ... })).resolved
    : resolvePathFromInput(filePath, cwd);

  return { resolved, display: toDisplayPath(resolved, cwd) };
}
```

安全机制：
1. **workspaceOnly**（默认 true）：限制路径在工作区内
2. **符号链接防护**：`PATH_ALIAS_POLICIES.strict` 防止通过符号链接逃逸
3. **沙箱集成**：沙箱模式下通过 bridge 解析路径

### 4.6 文件操作抽象

```javascript
function resolvePatchFileOps(options) {
  if (options.sandbox) {
    // 沙箱模式：通过 bridge 操作
    return {
      readFile: (path) => bridge.readFile({ filePath: path }),
      writeFile: (path, content) => bridge.writeFile({ filePath: path, content }),
      remove: (path) => bridge.remove({ filePath: path }),
    };
  }
  // 非沙箱模式：直接文件系统操作
  return {
    readFile: (path) => fs.readFile(path, 'utf8'),
    writeFile: (path, content) => fs.writeFile(path, content, 'utf8'),
    remove: (path) => fs.unlink(path),
  };
}
```

通过文件操作抽象层，`apply_patch` 在沙箱和非沙箱环境中使用相同的核心逻辑。

---

## 5. 与其他文件操作工具对比

### 5.1 OpenClaw 文件操作工具一览

| 工具 | 操作粒度 | 多文件 | 匹配方式 | 模型限制 | 默认状态 |
|------|---------|--------|---------|---------|---------|
| `read` | 读取文件内容 | ❌ | — | 无 | 启用 |
| `write` | 整文件写入 | ❌ | — | 无 | 启用 |
| `edit` | 单文件精确替换 | ❌ | 精确字符串匹配 | 无 | 启用 |
| `apply_patch` | 多文件结构化补丁 | ✅ | 四级渐进匹配 | OpenAI 限定 | **禁用** |
| `exec` | Shell 命令 | ✅ | — | 无 | 启用 |

### 5.2 edit vs apply_patch 详细对比

| 维度 | edit | apply_patch |
|------|------|-------------|
| **调用次数** | 每次修改一处 | 一次修改多处 |
| **匹配机制** | `oldText` 精确字符串匹配 | 四级渐进匹配（精确→去空白→去缩进→标准化标点） |
| **多文件** | 不支持 | 支持 |
| **创建文件** | 不支持（用 write） | ✅ `*** Add File:` |
| **删除文件** | 不支持（用 exec rm） | ✅ `*** Delete File:` |
| **重命名文件** | 不支持 | ✅ `*** Move to:` |
| **模型要求** | 任何模型 | 仅 OpenAI 系列 |
| **失败模式** | `oldText` 不匹配则报错 | 上下文找不到则报错 |
| **Token 开销** | 每次调用有 overhead | 多操作共享一次 overhead |
| **上下文消耗** | 小（per-edit） | 中（整个 patch 作为单参数） |
| **回滚** | 无 | 无（但操作更明确） |

### 5.3 什么时候用哪个

```
修改一个文件的一行？     → edit
修改一个文件的多处？     → edit 多次 或 apply_patch
修改多个文件？          → apply_patch ✅
创建 + 修改 + 删除组合？ → apply_patch ✅
非 OpenAI 模型？       → edit（别无选择）
需要最大鲁棒性？        → apply_patch（渐进匹配）
简单替换且确信匹配？     → edit（更轻量）
```

---

## 6. 使用场景

### 6.1 场景一：重构跨文件导入路径

**问题**：将 `utils/helpers.ts` 重命名为 `utils/string-helpers.ts`，所有引用它的文件都需要更新。

```
*** Begin Patch
*** Update File: utils/helpers.ts
*** Move to: utils/string-helpers.ts
@@
 // String utility functions
*** Update File: src/app.ts
@@
-import { capitalize } from '../utils/helpers'
+import { capitalize } from '../utils/string-helpers'
*** Update File: src/components/Header.tsx
@@
-import { truncate } from '../../utils/helpers'
+import { truncate } from '../../utils/string-helpers'
*** Update File: tests/helpers.test.ts
@@
-import { capitalize, truncate } from '../utils/helpers'
+import { capitalize, truncate } from '../utils/string-helpers'
*** End Patch
```

**价值**：4 个文件的修改 + 1 个重命名，一次调用完成。

### 6.2 场景二：新增功能（创建 + 修改 + 配置）

**问题**：新增一个 API endpoint，需要创建路由文件、修改路由注册、更新配置。

```
*** Begin Patch
*** Add File: src/routes/health.ts
+import { Router } from 'express'
+
+const router = Router()
+
+router.get('/health', (req, res) => {
+  res.json({ status: 'ok', timestamp: Date.now() })
+})
+
+export default router
*** Update File: src/routes/index.ts
@@ import
+import healthRouter from './health'
@@ app.use
 app.use('/api/users', userRouter)
+app.use('/api', healthRouter)
*** Update File: src/config.ts
@@ endpoints
 endpoints: {
   users: '/api/users',
+  health: '/api/health',
 }
*** End Patch
```

### 6.3 场景三：批量修复 lint 错误

**问题**：ESLint 报告多个文件有未使用的变量。

```
*** Begin Patch
*** Update File: src/utils/cache.ts
@@
-import { Redis, RedisOptions, Cluster } from 'ioredis'
+import { Redis, RedisOptions } from 'ioredis'
*** Update File: src/services/auth.ts
@@
-import { User, Session, Token, Refresh } from '../models'
+import { User, Session, Token } from '../models'
*** Update File: src/controllers/api.ts
@@
-const { data, error, metadata } = await fetchResult()
+const { data, error } = await fetchResult()
*** End Patch
```

### 6.4 场景四：框架迁移（大范围改动）

**问题**：从 CommonJS 迁移到 ES Modules。

```
*** Begin Patch
*** Update File: package.json
@@
-  "type": "commonjs",
+  "type": "module",
*** Update File: src/index.ts
@@
-const express = require('express')
-const cors = require('cors')
+import express from 'express'
+import cors from 'cors'
@@
-module.exports = app
+export default app
*** Update File: src/utils/db.ts
@@
-const mongoose = require('mongoose')
+import mongoose from 'mongoose'
@@
-module.exports = { connect, disconnect }
+export { connect, disconnect }
*** Delete File: .babelrc
*** End Patch
```

---

## 7. 核心价值

### 7.1 效率价值：减少工具调用轮次

```
传统方式（edit × N）：

Model → edit(file1) → Result → Model → edit(file2) → Result → Model → edit(file3) → Result
  ↑        1 轮                    2 轮                    3 轮

apply_patch 方式：

Model → apply_patch(patch) → Result
          1 轮（完成所有修改）
```

**量化影响：**

| 场景 | edit 调用次数 | apply_patch 调用次数 | 节省轮次 |
|------|-------------|---------------------|---------|
| 修改 3 个文件各 1 处 | 3 | 1 | 67% |
| 修改 1 个文件 5 处 | 5 | 1 | 80% |
| 创建 2 文件 + 修改 3 文件 + 删除 1 文件 | 6+（需 write + edit + exec） | 1 | 83%+ |

每减少一轮工具调用意味着：
- **省 Token**：减少模型思考"下一步做什么"的开销
- **省时间**：减少 API 往返延迟
- **省成本**：减少 LLM API 计费

### 7.2 鲁棒性价值：渐进匹配容错

`edit` 工具最常见的失败：

```
edit(oldText: "const foo = 1;", newText: "const foo = 2;")
→ 错误：oldText 未找到
→ 实际文件中是 "const foo = 1 ;"（多了个空格）
```

`apply_patch` 的四级渐进匹配可以处理：

| 差异类型 | edit 能匹配？ | apply_patch 能匹配？ |
|---------|-------------|---------------------|
| 行尾多余空格 | ❌ | ✅ Level 2 |
| 缩进不一致（2空格 vs 4空格） | ❌ | ✅ Level 3 |
| 中文引号 `""` vs 英文 `""` | ❌ | ✅ Level 4 |
| Unicode 破折号 `—` vs ASCII `-` | ❌ | ✅ Level 4 |
| 全角空格 `　` vs 半角空格 | ❌ | ✅ Level 4 |

这对中文开发环境尤其重要——模型经常在中英文标点之间混淆。

### 7.3 表达力价值：统一的文件操作语义

一次 `apply_patch` 调用可以表达：

| 操作 | 传统方式 | apply_patch 语法 |
|------|---------|-----------------|
| 创建文件 | `write(path, content)` | `*** Add File: path` |
| 修改文件 | `edit(path, old, new)` | `*** Update File: path` |
| 删除文件 | `exec("rm path")` | `*** Delete File: path` |
| 重命名文件 | `exec("mv old new")` | `*** Move to: newPath` |

**单一工具 = 统一审计、统一回滚点、统一权限控制。**

### 7.4 认知价值：可读的变更描述

补丁格式本身就是一份清晰的**变更清单**：

```
*** Begin Patch
*** Add File: src/utils/logger.ts        ← 创建了什么
*** Update File: src/app.ts              ← 修改了什么
*** Delete File: src/old-logger.ts       ← 删除了什么
*** End Patch
```

人类可以一眼看出这次操作的范围和影响，便于代码审查。

---

## 8. 配置与安全

### 8.1 启用配置

```json5
{
  "tools": {
    "exec": {
      "applyPatch": {
        "enabled": true,                    // 必须显式启用
        "workspaceOnly": true,              // 限制路径在工作区内（默认 true）
        "allowModels": ["gpt-5.2"]          // 可选：按模型白名单限制
      }
    }
  }
}
```

### 8.2 启用条件（全部需满足）

| 条件 | 说明 |
|------|------|
| `applyPatch.enabled = true` | 显式启用 |
| 模型提供者为 OpenAI 或 OpenAI-Codex | `isOpenAIProvider()` 检查 |
| 模型在 `allowModels` 白名单中（如配置了白名单） | `isApplyPatchAllowedForModel()` 检查 |
| 沙箱环境中 `allowWorkspaceWrites = true` | 沙箱写权限 |

### 8.3 工具策略关系

```
apply_patch 是 exec 的子工具
  ↓
allow: ["exec"] → 隐式允许 apply_patch
deny: ["apply_patch"] → 显式禁止 apply_patch（deny 优先）
```

工具分组：

```
group:fs = read, write, edit, apply_patch
```

所以 `allow: ["group:fs"]` 也会包含 `apply_patch`。

### 8.4 安全层级

| 层级 | 机制 | 说明 |
|------|------|------|
| **1. 工具策略** | `tools.allow / tools.deny` | 控制工具是否可用 |
| **2. 启用开关** | `applyPatch.enabled` | 默认禁用 |
| **3. 模型限制** | `isOpenAIProvider` | 仅 OpenAI 系列模型 |
| **4. 模型白名单** | `allowModels` | 可选的模型级限制 |
| **5. 路径边界** | `workspaceOnly` | 限制在工作区内 |
| **6. 符号链接防护** | `PATH_ALIAS_POLICIES` | 防止路径逃逸 |
| **7. 沙箱隔离** | Docker sandbox | 可选的容器级隔离 |

### 8.5 安全建议

```json5
// 推荐的安全配置
{
  "tools": {
    "exec": {
      "applyPatch": {
        "enabled": true,
        "workspaceOnly": true,       // 绝不改为 false
        "allowModels": ["gpt-5.2"]   // 限制到特定模型
      }
    }
  }
}
```

⚠️ **永远不要设置 `workspaceOnly: false`**，除非你明确知道自己在做什么。这会允许 `apply_patch` 写入工作区外的任意路径。

---

## 9. 最佳实践

### 9.1 何时启用 apply_patch

| 条件 | 建议 |
|------|------|
| 使用 OpenAI GPT-5.x / Codex 模型 | ✅ 启用 |
| 频繁做多文件重构 | ✅ 启用 |
| 使用非 OpenAI 模型（Claude、Gemini 等） | ❌ 无法启用（不支持） |
| 安全敏感环境 | ⚠️ 启用但限制 `allowModels` |

### 9.2 配置最佳实践

**1. 始终保持 workspaceOnly: true**

```json5
{ "applyPatch": { "enabled": true, "workspaceOnly": true } }
```

**2. 使用 allowModels 限制模型范围**

```json5
// 仅允许特定模型使用 apply_patch
{ "applyPatch": { "enabled": true, "allowModels": ["gpt-5.2", "gpt-5.2-codex-max"] } }
```

**3. 结合沙箱使用**

```json5
{
  "agents": {
    "defaults": {
      "sandbox": {
        "enabled": true,
        "mode": "all",
        "workspaceAccess": "rw"   // 需要 rw 才能使用 apply_patch
      }
    }
  }
}
```

### 9.3 使用模式最佳实践

**1. 上下文充足原则**

好的补丁包含足够的上下文行来唯一定位修改位置：

```
✅ 好的补丁（3 行上下文）：
@@
 import express from 'express'
 import cors from 'cors'
-import helmet from 'helmet'
+import helmet from 'helmet-next'
 
 const app = express()

❌ 差的补丁（无上下文）：
@@
-import helmet from 'helmet'
+import helmet from 'helmet-next'
```

**2. 使用 @@ 标头消除歧义**

当文件中有重复模式时：

```
✅ 指定上下文范围：
@@ class UserController
@@ async updateProfile()
-  await user.save()
+  await user.save({ validateBeforeSave: true })

❌ 模糊的修改：
@@
-  await user.save()
+  await user.save({ validateBeforeSave: true })
```

**3. 单次 apply_patch 不要太大**

| 补丁大小 | 建议 |
|---------|------|
| 1-5 个文件，每文件 1-3 处修改 | ✅ 理想 |
| 5-10 个文件 | ⚠️ 可接受，注意可读性 |
| 10+ 个文件 | ❌ 拆分为多次调用 |

**4. 先 read 后 patch**

在应用补丁前先读取目标文件，确保上下文准确：

```
步骤 1: read(src/app.ts)   ← 查看当前内容
步骤 2: apply_patch(...)    ← 基于实际内容编写补丁
```

### 9.4 错误处理

| 错误消息 | 原因 | 解决方式 |
|---------|------|---------|
| `Failed to find expected lines in file.ts` | 上下文匹配失败（四级都没匹配上） | 先 `read` 文件，使用实际内容 |
| `Failed to find context 'xxx' in file.ts` | `@@` 标头指定的上下文不存在 | 检查类/函数名是否正确 |
| `No files were modified` | 补丁为空或格式错误 | 检查 `*** Begin/End Patch` 标记 |
| `The first line must be '*** Begin Patch'` | 缺少开始标记 | 确保首行是 `*** Begin Patch` |
| Path security error | 路径逃逸了工作区 | 使用相对路径，不要用 `../` 跳出 |

---

## 10. 局限性与注意事项

### 10.1 模型限制

**当前仅支持 OpenAI 系列模型**，包括：
- OpenAI（`openai` provider）
- OpenAI Codex（`openai-codex` provider）

Claude、Gemini、通义千问等模型**不支持** `apply_patch`。

**原因**：`apply_patch` 格式是 OpenAI 专有设计，其他模型在训练数据中没有见过该格式，无法可靠生成。

### 10.2 实验性状态

- 默认**禁用**，表明团队认为功能尚未完全稳定
- 配置在 `tools.exec.applyPatch` 下（exec 的子工具），而非顶级工具
- 未来可能会有格式变更

### 10.3 无原子回滚

如果补丁中有 5 个文件操作，前 3 个成功后第 4 个失败，**前 3 个修改不会自动回滚**。

建议：
- 在版本控制环境中使用（可用 `git checkout` 回滚）
- 在沙箱中使用（沙箱可丢弃）

### 10.4 二进制文件不支持

`apply_patch` 仅支持文本文件。二进制文件（图片、编译产物等）无法通过补丁修改。

### 10.5 大文件性能

对于非常大的文件（数千行），`seekSequence` 的四级匹配可能有性能开销（每级都做线性扫描）。但对于日常代码文件（几百行），性能影响可忽略。

### 10.6 与 edit 的选择建议

| 条件 | 推荐工具 |
|------|---------|
| 使用 OpenAI 模型 + 多文件修改 | `apply_patch` |
| 使用 OpenAI 模型 + 单处简单修改 | `edit`（更轻量） |
| 使用非 OpenAI 模型 | `edit`（唯一选择） |
| 需要创建/删除/重命名文件组合 | `apply_patch` |
| 安全高度敏感 + 最小权限 | `edit`（更受限的操作范围） |

---

## 参考来源

| 来源 | URL/路径 |
|------|---------|
| OpenClaw 官方文档（英文） | https://docs.openclaw.ai/tools/apply-patch |
| OpenClaw 官方文档（中文） | https://docs.openclaw.ai/zh-CN/tools/apply-patch |
| OpenClaw exec 工具文档 | /usr/lib/node_modules/openclaw/docs/tools/exec.md |
| OpenClaw 配置参考 | /usr/lib/node_modules/openclaw/docs/gateway/configuration-reference.md |
| OpenClaw 安全文档 | /usr/lib/node_modules/openclaw/docs/gateway/security/index.md |
| OpenClaw 源码（apply_patch 实现） | /usr/lib/node_modules/openclaw/dist/reply-Bm8VrLQh.js |
| OpenAI Codex apply_patch 规范 | https://github.com/openai/codex/blob/main/codex-rs/apply-patch/apply_patch_tool_instructions.md |
| OpenAI Codex Prompting Guide | https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide |

---

> **文档结束**
> 卷王小组 · wairesearch · 2026-03-24
