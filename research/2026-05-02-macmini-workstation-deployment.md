# Mac Mini M4 全能个人工作站部署方案

> 研究时间：2026-05-02 | 研究员：黄山（wairesearch）
> 硬件配置：Mac Mini M4 / 16GB / 256GB SSD

---

## 执行摘要

Mac Mini M4（16GB/256GB）**完全可以胜任 AI 开发工作站**。内置 256GB 放系统和核心程序绑绑有余，数据和项目通过外接存储扩展即可。推荐架构：**Tailscale 组网 + OpenClaw Gateway 本地部署 + Claude Code/Codex 本地 CLI + Hermes 可选部署**，外接 1-2TB Thunderbolt NVMe SSD 作为数据盘。总预算约 ¥800-1500（外置存储+UPS）。

---

## 1. 各组件定位与协同关系

### 1.1 组件定位

| 组件 | 定位 | 安装方式 | 资源占用 |
|------|------|---------|---------|
| **OpenClaw** | AI Agent 编排平台（Gateway + 多 Agent 系统） | `npm i -g openclaw` | 内存 ~200-500MB，CPU 低 |
| **Hermes** | NousResearch 的自我进化 Agent 框架（学习型） | `git clone` + Python venv | 内存 ~300-600MB，CPU 低 |
| **Claude Code** | Anthropic CLI 编码 Agent | `npm i -g @anthropic-ai/claude-code` 或 `curl -fsSL https://claude.ai/install.sh \| bash` | 按需启动，内存 ~200MB |
| **Codex** | OpenAI CLI 编码 Agent（Rust 构建） | `npm i -g @openai/codex` 或 `brew install --cask codex` | 按需启动，内存 ~150MB |

### 1.2 各组件详细说明

#### OpenClaw — 中枢大脑
- **角色**：本地 Gateway 作为所有 AI 能力的统一入口
- **功能**：多 Agent 编排、技能系统、消息路由、工具调用
- **协议**：通过 ACP（Agent Client Protocol）集成外部编码 Agent
- **关键能力**：`openclaw gateway start` 启动后，可通过 Telegram/WebChat 等渠道控制

#### Hermes — 自我进化的 AI 助手
- **开发者**：NousResearch
- **核心差异**：**学习循环** — 从使用中创建技能、在使用中精炼技能、跨会话构建用户模型
- **定位**：不是 OpenClaw 的组件，而是**竞品/互补品**
- **与 OpenClaw 关系**：
  - 可以共存，各管各的场景
  - Hermes 擅长：个人对话式助手、长期记忆、自我改进
  - OpenClaw 擅长：多 Agent 编排、工具生态、消息平台集成
- **安装要求**：Python 3.11+、需要 64K+ token 上下文的模型
- **建议**：**可选部署**，如果已有 OpenClaw 生态运转良好，Hermes 可以作为实验性补充

#### Claude Code — Anthropic 的编码 Agent
- **特点**：终端内运行，能读/写/执行代码，深度理解项目上下文
- **集成**：通过 OpenClaw ACP 协议可被编排调用
  ```
  npx acpx@latest claude "refactor the auth module"
  ```
- **计费**：需要 Anthropic API key 或 Claude Pro/Max 订阅

#### Codex — OpenAI 的编码 Agent
- **特点**：Rust 构建，轻量快速，开源
- **集成**：同样通过 ACP 协议集成
  ```
  npx acpx@latest codex "fix the failing tests"
  ```
- **计费**：ChatGPT Plus/Pro 订阅包含，或 OpenAI API key

### 1.3 协同架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Mac Mini M4 工作站                         │
│                                                             │
│  ┌─────────────────────────────────────────────┐            │
│  │         OpenClaw Gateway (中枢)              │            │
│  │  - Agent 编排引擎                            │            │
│  │  - 技能系统 (Skills)                         │            │
│  │  - 消息路由 (Telegram/WebChat)               │            │
│  │  - ACP 协议桥接                              │            │
│  └──────┬──────────┬──────────┬────────────────┘            │
│         │          │          │                             │
│    ┌────▼────┐ ┌───▼────┐ ┌──▼───────┐  ┌──────────────┐  │
│    │Claude   │ │ Codex  │ │ Hermes   │  │  本地工具     │  │
│    │Code     │ │ CLI    │ │ Agent    │  │  (git/npm/    │  │
│    │(ACP)    │ │(ACP)   │ │(独立)    │  │   docker等)   │  │
│    └─────────┘ └────────┘ └──────────┘  └──────────────┘  │
│                                                             │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    Tailscale VPN
                           │
              ┌────────────┼────────────┐
              │            │            │
         ┌────▼───┐  ┌────▼───┐  ┌────▼───┐
         │ 手机   │  │ 笔记本 │  │ 云服务 │
         │Telegram│  │ SSH    │  │  器    │
         └────────┘  └────────┘  └────────┘
```

### 1.4 ACP 集成模式

OpenClaw 通过 ACP（Agent Client Protocol）统一管理 Claude Code 和 Codex：

```yaml
# OpenClaw 配置示例
agents:
  acp:
    codex:
      runtime: acp
      command: "codex"
    claude:
      runtime: acp
      command: "claude"
```

使用时，OpenClaw 的 Agent 可以通过 `sessions_spawn` 将编码任务委托给 Claude Code 或 Codex：
```
sessions_spawn → runtime: "acp", agentId: "codex", task: "fix the tests"
```

---

## 2. 硬件适配性评估

### 2.1 Mac Mini M4 基础配置

| 规格 | 数值 | 评估 |
|------|------|------|
| CPU | 10核（4性能+6能效） | ✅ 充足，AI Agent 主要是 I/O 密集型 |
| 内存 | 16GB 统一内存 | ⚠️ 够用但偏紧，需注意内存管理 |
| 存储 | 256GB SSD（系统盘）+ 外接扩展 | ✅ 内置放系统，外接放数据 |
| 带宽 | 120GB/s 内存带宽 | ✅ 远超需求 |
| 功耗 | 空闲 ~5W，满载 ~155W | ✅ 极低功耗，适合 24/7 |
| 噪音 | 5 dBA 空闲 | ✅ 几乎无声 |
| 散热 | 被动+主动混合 | ✅ AI Agent 负载下不会有散热问题 |

### 2.2 内存预算（16GB）

| 组件 | 预估内存占用 | 备注 |
|------|-------------|------|
| macOS 系统 | ~4-5 GB | Sequoia 基础占用 |
| OpenClaw Gateway | ~300-500 MB | Node.js 进程 |
| Claude Code（活跃时） | ~200-300 MB | 按需启动 |
| Codex（活跃时） | ~150-200 MB | Rust 编写，较轻 |
| Hermes（活跃时） | ~400-600 MB | Python + 依赖 |
| Tailscale | ~50 MB | 极轻 |
| 其他系统服务 | ~1-2 GB | Spotlight、mDNS 等 |
| **总计（全部活跃）** | **~7-9 GB** | ✅ 16GB 可以覆盖 |
| 余量给 swap/缓存 | ~7-9 GB | 足够弹性空间 |

**结论**：16GB 内存 **够用**。这些 Agent 都是通过 API 调用远程 LLM，本地不跑模型推理，主要消耗是 Node.js/Python 进程内存。即使全部同时运行，也不会超过 10GB。

### 2.3 存储规划（内置 256GB + 外接扩展）

**内置 256GB 用途分析**：

| 用途 | 预估占用 | 备注 |
|------|---------|------|
| macOS 系统 | ~30-40 GB | 含系统更新缓存 |
| Xcode CLT | ~5-7 GB | 编译工具 |
| Homebrew + 包 | ~5-10 GB | 日常开发工具 |
| Node.js + npm 全局包 | ~2-3 GB | OpenClaw/Claude Code/Codex |
| Python + Hermes 运行时 | ~3-5 GB | venv + 依赖 |
| 系统预留空间 | ~50 GB | swap/临时/更新缓存 |
| **总计** | **~95-115 GB** | |
| **剩余可用** | **~140-160 GB** | ✅ 充裕 |

**结论**：内置 256GB 放系统 + 核心程序**绑绑有余**，甚至还能放少量活跃项目代码。数据增长部分全部走外接。

### 2.4 外接存储推荐方案

#### 方案对比

| 方案 | 速度 | 价格（约） | 容量 | 适合场景 | 推荐度 |
|------|------|-----------|------|---------|--------|
| **① Thunderbolt 4 NVMe 盒 + SSD** | 3000 MB/s | ¥800-1100 | 1-2TB | 开发主力盘，高速读写 | ⭐⭐⭐⭐⭐ |
| **② USB 3.2 Gen2 NVMe 盒 + SSD** | 1000 MB/s | ¥500-700 | 1-2TB | 性价比数据盘 | ⭐⭐⭐⭐ |
| **③ Satechi Mac Mini Stand Hub** | 1000 MB/s | ¥300-500（不含 SSD） | 最大 4TB | 美观一体，额外 USB-A 口 | ⭐⭐⭐⭐ |
| **④ NAS（如群晖 DS224+）** | 100-200 MB/s（网络） | ¥2000-3000 | 8-32TB | 大容量存储/备份/媒体 | ⭐⭐⭐ |
| **⑤ USB 移动硬盘（HDD）** | 100-150 MB/s | ¥300-500 | 2-4TB | 纯备份用途 | ⭐⭐ |

#### 🏆 最终推荐：方案 ② + 方案 ⑤ 组合

**主数据盘**：USB 3.2 Gen2 NVMe 硬盘盒 + WD SN770 1TB
- 价格：~¥600-700
- 理由：1000MB/s 对 AI Agent 工作负载完全够用（主要是文本文件读写，不是视频剪辑），价格只有 TB4 方案的一半
- 推荐品牌：ORICO / 绿联 USB 3.2 Gen2 盒 + WD SN770 / 三星 980

**备份盘**：USB 3.0 移动硬盘 2TB
- 价格：~¥400
- 用于 Time Machine 增量备份
- 推荐：西数 Elements / 希捷 Expansion

**NAS 什么时候需要？**
- 当前阶段：**不需要**。OPC 单人场景，外接 SSD 完全够用
- 未来考虑：当你有多台设备需要共享存储、或需要 >4TB 数据存储时再上 NAS
- NAS 对 AI Agent 场景的网络延迟（100-200MB/s 上限）反而是瓶颈

#### 存储分层架构

```
┌── 内置 256GB SSD (系统盘) ─────────────────────────┐
│                                                    │
│  /System, /Applications       ← macOS + 应用      │
│  /opt/homebrew                ← Homebrew 工具链    │
│  ~/.openclaw                  ← OpenClaw 配置+数据 │
│  ~/.config                    ← 各类配置文件       │
│  ~/ (小型活跃项目)             ← 可选放几个        │
│  [预留 ~100-140GB 自由空间]    ← swap/缓存/弹性    │
│                                                    │
└────────────────────────────────────────────────────┘

┌── 外接 1TB NVMe SSD (数据盘) ─────────────────────┐
│                                                    │
│  /Volumes/WorkStation/                             │
│  ├── Projects/        ← 所有项目代码仓库           │
│  ├── Data/            ← Agent 产出数据、研究报告   │
│  ├── Hermes/          ← Hermes Agent 工作目录     │
│  ├── Cache/           ← npm cache / pip cache     │
│  ├── Logs/            ← 归档日志                  │
│  └── Models/          ← 本地模型缓存（如需要）     │
│                                                    │
└────────────────────────────────────────────────────┘

┌── 外接 2TB HDD (备份盘) ─────────────────────────┐
│                                                    │
│  Time Machine 自动增量备份                          │
│  （覆盖内置 SSD + 外接数据盘的关键目录）            │
│                                                    │
└────────────────────────────────────────────────────┘
```

#### 外接 SSD 的 macOS 配置要点

```bash
# 1. 格式化为 APFS（性能最佳）
diskutil apfs createContainer /dev/diskX
diskutil apfs addVolume diskXs1 APFS "WorkStation"

# 2. 设置开机自动挂载（默认 macOS 会自动挂载，但确认一下）
# 外接 USB/TB 设备在 macOS 下默认自动挂载，无需额外配置

# 3. 创建符号链接，让常用路径指向外接盘
ln -s /Volumes/WorkStation/Projects ~/Projects
ln -s /Volumes/WorkStation/Data ~/Data

# 4. 迁移 npm/pip 缓存到外接盘
npm config set cache /Volumes/WorkStation/Cache/npm
pip config set global.cache-dir /Volumes/WorkStation/Cache/pip

# 5. 防止外接盘休眠（重要！）
sudo pmset -a disksleep 0

# 6. 挂载监控（cron 检测外接盘是否在线）
*/5 * * * * [ ! -d /Volumes/WorkStation ] && \
  curl -s "https://api.telegram.org/bot<TOKEN>/sendMessage?chat_id=<CHAT>&text=⚠️ 外接SSD 掉线!"
```

### 2.5 长期运行可靠性

Mac Mini M4 作为 24/7 服务器的表现：
- **散热**：AI Agent 工作负载主要是网络 I/O + 轻量计算，CPU 使用率通常 < 20%，散热无压力
- **SSD 寿命**：Apple 的 SSD 控制器质量优秀，日常 Agent 写入量不大
- **已知问题**：macOS 不是专为服务器设计，偶尔强制更新会导致重启（后面解决）
- **社区验证**：大量 homelab 用户验证 Mac Mini 可稳定运行数月/数年

---

## 3. 网络方案

> ⚠️ **关键约束**：Mac Mini 位于中国大陆，但核心依赖（Anthropic API、OpenAI API、GitHub、Tailscale DERP）均在海外。必须具备**稳定的全球网络出口 + 多重冗余**，否则整套方案不可用。

### 3.1 全球网络出口（核心需求）

#### 依赖服务清单

| 依赖服务 | 位置 | 重要性 | 无代理可用性 |
|---------|------|--------|------------|
| Anthropic API (api.anthropic.com) | 美国 | ⭐⭐⭐⭐⭐ | ❌ 不可用 |
| OpenAI API (api.openai.com) | 美国 | ⭐⭐⭐⭐⭐ | ❌ 不可用 |
| GitHub (github.com/raw/api) | 美国 | ⭐⭐⭐⭐⭐ | ⚠️ 极慢/不稳 |
| npm registry (registry.npmjs.org) | 全球 CDN | ⭐⭐⭐⭐ | ⚠️ 时快时慢 |
| Tailscale DERP | 全球 | ⭐⭐⭐⭐ | ⚠️ 部分可连 |
| Brave/Serper/Tavily 搜索 API | 美国 | ⭐⭐⭐⭐ | ❌ 不可用 |
| Docker Hub | 美国 | ⭐⭐⭐ | ⚠️ 受限 |
| Homebrew bottles | 全球 CDN | ⭐⭐⭐ | ⚠️ 可用国内镜像 |

**结论**：没有全球网络出口 = 工作站废了。这是比 SSD、UPS 更优先的基础设施。

#### 多重冗余网络方案

##### 架构：三层降级 + 自动切换

```
┌─────────────────────────────────────────────────────────────┐
│                    网络出口架构（三层冗余）                    │
│                                                             │
│  ┌─────────────────────────────────────────────┐            │
│  │    Layer 1: 主力通道（透明代理客户端）        │            │
│  │    TUN 模式 → 全局流量接管                   │            │
│  │    分流规则：国内直连 / 海外走代理            │            │
│  └──────────────────┬──────────────────────────┘            │
│                     │ 故障检测（每 30s 探测）                │
│                     ▼                                       │
│  ┌─────────────────────────────────────────────┐            │
│  │    Layer 2: 备用通道（不同协议/供应商）       │            │
│  │    独立节点 + 独立协议 + 独立供应商           │            │
│  └──────────────────┬──────────────────────────┘            │
│                     │ 故障检测                              │
│                     ▼                                       │
│  ┌─────────────────────────────────────────────┐            │
│  │    Layer 3: 应急通道（Cloudflare WARP/备用）  │            │
│  │    最后兜底，确保基本连通性                   │            │
│  └─────────────────────────────────────────────┘            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

##### 方案对比

| 方案 | 协议 | 抗干扰 | 速度 | 稳定性 | 适合角色 |
|------|------|--------|------|--------|----------|
| **机场订阅（多节点）** | 多协议混合 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 主力 Layer 1 |
| **自建节点（VPS）** | 自选协议 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 备用 Layer 2 |
| **Cloudflare WARP** | WireGuard | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 应急 Layer 3 |
| **路由器级透明代理** | 多协议 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 进阶方案 |

##### 🏆 推荐组合：三层冗余

**Layer 1 — 主力通道：代理客户端 + 优质机场订阅**
- 客户端推荐：**Clash Verge Rev** 或 **Surge**（macOS 原生，稳定性最佳）
- 开启 **TUN 模式**（虚拟网卡接管全部流量，包括终端/Node.js/Python）
- 配置分流规则：
  - 国内域名/IP → 直连
  - api.anthropic.com, api.openai.com, github.com 等 → 代理
  - 未匹配 → 代理（默认走代理更安全）
- 选择至少 2-3 个不同地区的节点做负载均衡/故障转移
- 月费：~¥20-50/月

**Layer 2 — 备用通道：自建 VPS 节点**
- 在海外 VPS 上自建代理服务（推荐：Bandwagon / RackNerd / DMIT）
- 协议推荐：**Reality**（伪装性最强）或 **Hysteria2**（速度最快）
- 独立于 Layer 1 的供应商，确保一个挂了另一个不受影响
- 月费：~$3-5/月（VPS 费用）
- 配置为代理客户端的备用节点组

**Layer 3 — 应急兜底：Cloudflare WARP**
- 安装 WARP 客户端：`brew install cloudflare-warp`
- 免费使用，速度一般但胜在稳定
- 当 Layer 1 + Layer 2 都不可用时自动切换
- 注意：WARP 不能保证解锁所有被墙服务，但 API 调用通常可行

##### 自动切换机制

```bash
# /usr/local/bin/network-watchdog.sh
#!/bin/bash
# 每 30 秒探测核心服务可达性，不通则切换

TEST_URLS=(
  "https://api.anthropic.com"
  "https://api.openai.com/v1/models"
  "https://github.com"
)

check_connectivity() {
  for url in "${TEST_URLS[@]}"; do
    if curl -sf --connect-timeout 5 --max-time 10 "$url" > /dev/null 2>&1; then
      return 0
    fi
  done
  return 1
}

# 检测当前通道是否可用
if ! check_connectivity; then
  # 通知 + 切换逻辑
  # 方案 A：代理客户端内置自动切换（Clash/Surge 原生支持 fallback 节点组）
  # 方案 B：脚本触发切换
  osascript -e 'display notification "网络通道切换中..." with title "⚠️ Network"'
  
  # 通过 Telegram 告警（走备用通道）
  curl -s "https://api.telegram.org/bot<TOKEN>/sendMessage" \
    -d "chat_id=<CHAT>&text=⚠️ Mac Mini 主力网络通道异常，已自动切换备用"
fi
```

##### Clash/Surge 分流规则示例

```yaml
# proxy-groups（Clash 格式）
proxy-groups:
  - name: "🚀 全球出口"
    type: fallback           # 自动故障转移！
    proxies:
      - "🇯🇵 主力-日本"
      - "🇺🇸 主力-美国"
      - "🇸🇬 备用-新加坡"
      - "🛡️ 自建-Reality"
      - "☁️ WARP"
    url: "https://www.gstatic.com/generate_204"
    interval: 30             # 每 30 秒检测

  - name: "🤖 AI Services"
    type: fallback
    proxies:
      - "🇺🇸 主力-美国"      # AI API 优先美国节点（最低延迟）
      - "🇯🇵 主力-日本"
      - "🛡️ 自建-Reality"
    url: "https://api.anthropic.com"
    interval: 30

# rules（关键分流规则）
rules:
  # AI 服务 → 专用美国节点
  - DOMAIN-SUFFIX,anthropic.com,🤖 AI Services
  - DOMAIN-SUFFIX,openai.com,🤖 AI Services
  - DOMAIN-SUFFIX,googleapis.com,🤖 AI Services
  
  # 开发工具 → 全球出口
  - DOMAIN-SUFFIX,github.com,🚀 全球出口
  - DOMAIN-SUFFIX,githubusercontent.com,🚀 全球出口
  - DOMAIN-SUFFIX,npmjs.org,🚀 全球出口
  - DOMAIN-SUFFIX,tailscale.com,🚀 全球出口
  
  # 搜索 API → 全球出口
  - DOMAIN-SUFFIX,brave.com,🚀 全球出口
  - DOMAIN-SUFFIX,serper.dev,🚀 全球出口
  - DOMAIN-SUFFIX,tavily.com,🚀 全球出口
  
  # 国内直连
  - GEOIP,CN,DIRECT
  - MATCH,🚀 全球出口        # 默认走代理
```

##### 启动顺序（关键！）

```
启动优先级（launchd 依赖顺序）：

1. 代理客户端启动 + TUN 模式生效     ← 最先！
2. Tailscale 连接                   ← 依赖网络通道
3. OpenClaw Gateway 启动            ← 依赖 API 可达
4. 其他服务
```

launchd 依赖配置：
```xml
<!-- com.openclaw.gateway.plist 中添加 -->
<key>KeepAlive</key>
<dict>
    <key>NetworkState</key>
    <true/>  <!-- 网络可用时才启动 -->
</dict>
```

##### 国内加速（减少代理流量消耗）

```bash
# npm 淘宝镜像（国内包不走代理）
npm config set registry https://registry.npmmirror.com

# Homebrew 清华镜像
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# pip 清华镜像
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Docker 镜像加速（如需要）
# daemon.json → registry-mirrors
```

### 3.2 设备互联方案（远程访问）

#### 方案对比

| 维度 | Tailscale | Cloudflare Tunnel | frp | ZeroTier |
|------|-----------|-------------------|-----|----------|
| **易用性** | ⭐⭐⭐⭐⭐ 零配置 | ⭐⭐⭐⭐ 需域名 | ⭐⭐ 需自建中继 | ⭐⭐⭐ |
| **速度** | 直连 P2P，10-80ms | 15-45ms（CDN 边缘） | 取决于中继服务器 | P2P，类似 Tailscale |
| **安全性** | ⭐⭐⭐⭐⭐ WireGuard 加密 | ⭐⭐⭐⭐ CF 代理 | ⭐⭐⭐ 需自行配置 | ⭐⭐⭐⭐ |
| **免费额度** | 100 设备 | 免费无限 tunnel | 免费（自建） | 25 设备 |
| **国内可用性** | ⚠️ DERP 可能受干扰 | ⚠️ 需代理辅助 | ✅ 自建可控 | ⚠️ 类似 Tailscale |
| **维护成本** | 几乎零 | 低 | 高（需维护中继） | 低 |

#### 推荐：Tailscale（走代理通道）+ Cloudflare Tunnel（备用）

**Tailscale 在国内的注意事项**：
- DERP 中继可能被干扰，但 Tailscale 支持通过代理连接
- 配置 `HTTP_PROXY` 环境变量让 Tailscale 走代理通道
- 一旦 P2P 直连建立，后续流量不经 DERP（低延迟）

```bash
# Tailscale 走代理（确保 DERP 握手成功）
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
sudo tailscale up
```

**Cloudflare Tunnel 作为公网访问备用**：
- 当 Tailscale 不可用时，通过域名直接访问
- 需要代理辅助建立 tunnel 连接

### 3.3 完整网络架构图

```
┌─────────────────────────────────────────────────────────────────┐
│                    Mac Mini M4 网络架构                           │
│                                                                 │
│  ┌───────────────────────────────────────────────────┐          │
│  │          代理客户端（TUN 全局接管）                 │          │
│  │                                                   │          │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐          │          │
│  │  │ Layer 1 │  │ Layer 2 │  │ Layer 3 │          │          │
│  │  │ 机场节点│→ │ 自建VPS │→ │  WARP   │          │          │
│  │  │(fallback)│  │(fallback)│  │(fallback)│          │          │
│  │  └─────────┘  └─────────┘  └─────────┘          │          │
│  │         ↕ 自动故障转移（30s 探测）                 │          │
│  └───────────────────────┬───────────────────────────┘          │
│                          │                                      │
│  ┌───────────────────────┼───────────────────────────┐          │
│  │                       │                           │          │
│  │  OpenClaw ─── API ────┤──→ Anthropic/OpenAI       │          │
│  │  Tailscale ── DERP ───┤──→ 设备互联               │          │
│  │  Git ──── push/pull ──┤──→ GitHub                 │          │
│  │  npm ──── install ────┤──→ registry               │          │
│  │                       │                           │          │
│  └───────────────────────────────────────────────────┘          │
│                                                                 │
│  ┌─── Tailscale 虚拟网络 (100.x.x.x) ───────────────┐          │
│  │                                                    │          │
│  │  Mac Mini        手机            笔记本            │          │
│  │  100.64.0.1     100.64.0.2      100.64.0.3       │          │
│  │  ├── OC :18789   Telegram        SSH/WebChat      │          │
│  │  └── SSH :22                                      │          │
│  │                                                    │          │
│  └────────────────────────────────────────────────────┘          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.4 从手机/其他设备访问的体验

| 访问方式 | 体验 | 说明 |
|---------|------|------|
| Telegram → OpenClaw | ⭐⭐⭐⭐⭐ | 最佳体验，随时随地对话（Telegram 本身需代理或已有通道） |
| Tailscale + SSH | ⭐⭐⭐⭐ | 终端操作，需 Tailscale App |
| Tailscale + WebChat | ⭐⭐⭐⭐ | 浏览器访问 `http://100.64.0.1:18789` |
| Cloudflare Tunnel | ⭐⭐⭐ | 公网域名，但需额外鉴权 |

### 3.5 网络故障应对矩阵

| 故障场景 | 影响 | 自动应对 | 恢复时间 |
|---------|------|---------|----------|
| Layer 1 主力节点宕机 | 无感知 | fallback 自动切换到同组其他节点 | <30s |
| Layer 1 全部不可用 | API 短暂中断 | 自动降级到 Layer 2 自建节点 | <60s |
| Layer 1+2 都不可用 | 性能降级 | 自动降级到 Layer 3 WARP | <60s |
| 全部通道不可用 | 海外服务不可达 | Telegram 告警 + 等待恢复 | 人工介入 |
| 家庭宽带断线 | 完全离线 | UPS 保活 + 来电自启 + Tailscale 自动重连 | 宽带恢复后自动 |
| 代理客户端崩溃 | 流量中断 | launchd KeepAlive 自动重启 | <10s |

---

## 4. 部署架构设计

### 4.1 推荐系统架构

```
Mac Mini M4 (macOS Sequoia)
│
├── 系统层
│   ├── Tailscale (组网)         ← brew install tailscale
│   ├── caffeinate (防休眠)      ← 系统自带
│   └── pmset (电源管理)         ← 系统自带
│
├── 运行时层
│   ├── Node.js 22 LTS           ← brew install node@22
│   ├── Python 3.11+             ← brew install python@3.11
│   ├── Rust (Codex 依赖)        ← 已预编译，无需手动装
│   └── Git                      ← brew install git
│
├── 应用层
│   ├── OpenClaw Gateway          ← npm i -g openclaw
│   │   ├── Agent: main (协调者)
│   │   ├── Agent: waicode (编码)
│   │   ├── Agent: wairesearch (研究)
│   │   └── ACP Bridge → Claude Code / Codex
│   ├── Claude Code               ← npm i -g @anthropic-ai/claude-code
│   ├── Codex CLI                 ← npm i -g @openai/codex
│   └── Hermes Agent (可选)       ← git clone + setup-hermes.sh
│
├── 进程管理层
│   └── launchd (macOS 原生)      ← 推荐，非 pm2
│       ├── com.openclaw.gateway.plist
│       ├── com.tailscale.daemon.plist (自动)
│       └── com.hermes.agent.plist (可选)
│
└── 存储层
    ├── 内置 256GB: 系统 + 核心程序
    └── 外置 1TB NVMe: 项目 + 数据 + 日志
```

### 4.2 安装流程（完整可执行）

```bash
# ===== 阶段 1: 基础环境 =====

# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装基础工具
brew install node@22 python@3.11 git

# 安装 Tailscale
brew install tailscale
# 登录（会打开浏览器）
sudo tailscale up

# ===== 阶段 2: OpenClaw =====

# 安装 OpenClaw
npm i -g openclaw

# 初始化配置（交互式）
openclaw onboard

# 安装为 launchd 服务
openclaw gateway install
openclaw gateway start

# 验证
openclaw gateway status

# ===== 阶段 3: 编码 Agent =====

# Claude Code
npm i -g @anthropic-ai/claude-code
# 首次运行验证
claude --version

# Codex
npm i -g @openai/codex
# 首次运行验证
codex --version

# 安装 ACPX（OpenClaw 与编码 Agent 的桥接器）
npm i -g acpx@latest

# ===== 阶段 4: Hermes (可选) =====

# 克隆并安装
cd /Volumes/WorkStation/Hermes/  # 外置数据盘
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
./setup-hermes.sh

# ===== 阶段 5: 外接存储配置 =====

# 外接 SSD 连接后自动挂载（macOS 默认行为）
# 创建项目目录结构
mkdir -p /Volumes/WorkStation/{Projects,Data,Logs,Cache,Models,Hermes}

# 创建符号链接
ln -s /Volumes/WorkStation/Projects ~/Projects
ln -s /Volumes/WorkStation/Data ~/Data

# 缓存迁移到外接盘
npm config set cache /Volumes/WorkStation/Cache/npm
pip config set global.cache-dir /Volumes/WorkStation/Cache/pip

# 防止外接磁盘休眠
sudo pmset -a disksleep 0
```

### 4.3 进程管理方案：launchd（推荐）

**为什么选 launchd 而不是 pm2？**
- launchd 是 macOS 原生，零额外依赖
- 系统级守护，比 pm2 更底层更可靠
- 自动重启、崩溃恢复、日志管理全内置
- `openclaw gateway install` 已经自动创建 launchd plist

**OpenClaw Gateway 的 launchd 配置**（`openclaw gateway install` 自动生成）：
```xml
<!-- ~/Library/LaunchAgents/com.openclaw.gateway.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.openclaw.gateway</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/node</string>
        <string>/opt/homebrew/bin/openclaw</string>
        <string>gateway</string>
        <string>start</string>
        <string>--foreground</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/openclaw-gateway.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/openclaw-gateway.err</string>
</dict>
</plist>
```

**Hermes 的 launchd 配置**（手动创建）：
```xml
<!-- ~/Library/LaunchAgents/com.hermes.agent.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hermes.agent</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Volumes/WorkStation/Hermes/hermes-agent/venv/bin/hermes</string>
        <string>serve</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>/Volumes/WorkStation/Hermes/hermes-agent</string>
</dict>
</plist>
```

### 4.4 日志管理

```bash
# OpenClaw 日志位置
~/Library/Logs/openclaw/

# 日志轮转（cron）
# 每周清理超过 30 天的日志
0 3 * * 0 find ~/Library/Logs/openclaw -mtime +30 -delete

# Hermes 日志
/Volumes/ExternalSSD/Data/hermes-logs/
```

### 4.5 备份策略

```
备份优先级：
1. OpenClaw 配置 (~/.openclaw/)           ← 最重要
2. API Keys 和环境变量                     ← 关键
3. 项目代码 (~/Projects/)                  ← Git 已有远程备份
4. Hermes 学习数据 (~/.hermes/)           ← 不可重建

备份方案：
- Time Machine → 外置 SSD 分一个分区（或第二块 SSD）
- 关键配置 → 加密后推 GitHub Private Repo
- 或：rsync 到 NAS / 云存储（每日增量）
```

---

## 5. 长期稳态运行保障

### 5.1 防休眠配置

```bash
# 方法 1：系统设置
# System Settings → Energy → 关闭所有休眠选项
# "Prevent automatic sleeping when the display is off" → ON

# 方法 2：命令行永久设置
sudo pmset -a displaysleep 0    # 显示器不休眠（无外接显示器时无影响）
sudo pmset -a sleep 0           # 系统不休眠
sudo pmset -a disksleep 0       # 磁盘不休眠
sudo pmset -a powernap 0        # 关闭 Power Nap

# 方法 3：caffeinate（作为额外保险）
# 加入 launchd 开机自启
caffeinate -s &
```

### 5.2 macOS 自动更新策略

```bash
# 禁用自动下载和安装更新
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool false

# 保留安全更新检查（手动决定何时安装）
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# 策略：每月手动检查一次，选择周末低峰期更新
```

### 5.3 电源管理

| 措施 | 说明 | 推荐 |
|------|------|------|
| UPS 不间断电源 | 防止意外断电 | ⭐ 推荐购入小型 UPS（~¥200-400） |
| 来电自动开机 | 断电恢复后自动启动 | ✅ 必须开启 |
| 断电通知 | UPS 触发时通知 | 可选 |

```bash
# 设置来电自动开机（关键！）
sudo pmset -a autorestart 1

# 在 System Settings → General → Startup & Shutdown 中
# 开启 "Start up automatically after a power failure"
```

### 5.4 监控和告警

```bash
# 方案 1: 简单 cron 健康检查 + Telegram 通知
# 每 5 分钟检查 OpenClaw Gateway 是否存活
*/5 * * * * curl -sf http://localhost:3080/health || \
  curl -s "https://api.telegram.org/bot<TOKEN>/sendMessage?chat_id=<CHAT>&text=⚠️ OpenClaw Gateway down!"

# 方案 2: uptime-kuma（轻量监控面板）
# brew install --cask docker（如果需要）
# docker run -d -p 3001:3001 louislam/uptime-kuma

# 方案 3（推荐最简方案）: 利用 OpenClaw 自身
# 配置 healthcheck skill，定时自检并通过 Telegram 报告
openclaw gateway status  # 内置状态检查
```

### 5.5 定期维护清单

| 频率 | 任务 | 命令/操作 |
|------|------|----------|
| 每日（自动） | 健康检查 | cron + curl |
| 每周（自动） | 日志清理 | `find ... -mtime +30 -delete` |
| 每月（手动） | 系统更新评估 | 检查 macOS 更新，非紧急不装 |
| 每月（手动） | 依赖更新 | `npm update -g` |
| 每季度 | 备份验证 | 确认备份可恢复 |
| 每季度 | 存储空间检查 | `df -h` |

---

## 6. OPC 能力矩阵

### 6.1 这套架构能覆盖的 OPC 场景

| 场景 | 能力 | 实现方式 |
|------|------|---------|
| 🔧 **代码开发** | ⭐⭐⭐⭐⭐ | Claude Code + Codex + OpenClaw 多 Agent 编排 |
| 🔬 **研究调研** | ⭐⭐⭐⭐⭐ | OpenClaw research Agent + web 搜索技能 |
| ✍️ **内容创作** | ⭐⭐⭐⭐ | OpenClaw 写作 Agent + 多模型切换 |
| 🤖 **自动化工作流** | ⭐⭐⭐⭐⭐ | OpenClaw Skills + cron + launchd |
| 📋 **项目管理** | ⭐⭐⭐⭐ | OpenClaw + GitHub Issues + Lark 集成 |
| 💬 **客户沟通** | ⭐⭐⭐ | Telegram Bot 对外接口 |
| 📊 **数据分析** | ⭐⭐⭐⭐ | Python 脚本 + Agent 辅助分析 |
| 🎨 **设计** | ⭐⭐⭐ | AI 图片生成 Skills（通过 API） |

### 6.2 多 Agent 协作编码能力

```
用户 (via Telegram/WebChat)
    │
    ▼
OpenClaw Main Agent (协调者)
    │
    ├── "调研这个技术方案" → wairesearch Agent
    ├── "写这个功能" → sessions_spawn → Claude Code (ACP)
    ├── "修这个 bug" → sessions_spawn → Codex (ACP)
    └── "重构这个模块" → sessions_spawn → Claude Code (ACP)
         │
         └── 多个 coding agent 可并发执行不同任务
```

### 6.3 与云服务器方案对比

| 维度 | Mac Mini 本地方案 | 云服务器方案 |
|------|------------------|-------------|
| **延迟** | ⭐⭐⭐⭐⭐ 本地零延迟 | ⭐⭐⭐ 网络延迟 |
| **成本** | ⭐⭐⭐⭐⭐ 一次性投入，无月费 | ⭐⭐ 持续月费 |
| **可靠性** | ⭐⭐⭐ 依赖家庭网络和电力 | ⭐⭐⭐⭐⭐ 数据中心级 |
| **公网访问** | ⭐⭐⭐ 需穿透方案 | ⭐⭐⭐⭐⭐ 原生公网 |
| **数据隐私** | ⭐⭐⭐⭐⭐ 数据不离本地 | ⭐⭐⭐ 存在泄露风险 |
| **扩展性** | ⭐⭐ 硬件固定 | ⭐⭐⭐⭐⭐ 随时扩容 |
| **维护** | ⭐⭐⭐ 需自行维护 | ⭐⭐⭐⭐ 云商代管基础设施 |
| **性能** | ⭐⭐⭐⭐ M4 性能优秀 | ⭐⭐⭐ 同价位性能较低 |

**结论**：Mac Mini 本地方案在 **成本、隐私、性能** 上胜出；云方案在 **可靠性、公网访问** 上胜出。对 OPC 来说，**本地 + Tailscale 是更优选择**——省钱、数据自主、性能好，可靠性通过 UPS 和自动恢复来弥补。

---

## 7. 最终推荐方案

### 7.1 明确建议

**推荐配置：Mac Mini M4 + 外置 1TB NVMe + Tailscale + OpenClaw + Claude Code + Codex**

Hermes **暂不部署**（原因：与 OpenClaw 功能重叠度高，16GB 内存下优先保障核心组件稳定运行，等 OpenClaw 生态跑稳后再评估是否需要 Hermes 的学习能力）。

### 7.2 分阶段实施路径

#### 第一阶段：基础设施（Day 1，~2小时）
```
1. 外置 SSD 连接并格式化为 APFS
2. 安装 Homebrew、Node.js 22、Python 3.11、Git
3. 配置防休眠 + 来电自启
4. 安装并配置 Tailscale
5. 验证从手机/笔记本可通过 Tailscale 访问
```

#### 第二阶段：核心平台（Day 1-2，~3小时）
```
1. 安装 OpenClaw：npm i -g openclaw
2. 运行 openclaw onboard 完成初始配置
3. openclaw gateway install + start
4. 配置 Telegram Bot 连接
5. 验证通过 Telegram 可与 Agent 对话
```

#### 第三阶段：编码能力（Day 2，~1小时）
```
1. 安装 Claude Code：npm i -g @anthropic-ai/claude-code
2. 安装 Codex：npm i -g @openai/codex
3. 安装 ACPX：npm i -g acpx@latest
4. 配置 API Keys（Anthropic + OpenAI）
5. 测试 ACP 集成：npx acpx codex "hello world"
```

#### 第四阶段：加固（Day 3，~2小时）
```
1. 禁用 macOS 自动更新
2. 配置日志轮转 cron
3. 设置健康检查 + Telegram 告警
4. 配置备份方案
5. 写一份 runbook（故障恢复手册）
```

#### 第五阶段：优化（Week 2+，持续）
```
1. 根据使用情况调整 Agent 配置
2. 开发自定义 Skills
3. 评估是否需要 Hermes
4. 评估是否需要 Cloudflare Tunnel 公网暴露
```

### 7.3 预算估算

| 项目 | 价格（人民币） | 必要性 |
|------|---------------|--------|
| USB 3.2 Gen2 NVMe 硬盘盒 + 1TB SSD | ~¥600-700 | ⭐⭐⭐⭐⭐ 必须（数据盘） |
| USB 3.0 移动硬盘 2TB | ~¥400 | ⭐⭐⭐⭐ 推荐（备份盘） |
| 小型 UPS（如 APC BK650M2） | ~¥300-500 | ⭐⭐⭐⭐ 强烈推荐 |
| Tailscale | 免费 | - |
| Cloudflare Tunnel | 免费 | - |
| Claude API / Anthropic 订阅 | ~$20/月 | 按需 |
| OpenAI API / ChatGPT Plus | ~$20/月 | 按需 |
| **硬件总计** | **¥1300-1600** | |
| **月度 API 费用** | **~$20-40/月** | 取决于使用量 |

### 7.4 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 停电 | 服务中断 | UPS + 来电自启 |
| macOS 强制更新 | 重启中断 | 禁用自动更新 |
| 外置 SSD 断连 | 数据不可用 | 固定连接 + 挂载监控 |
| 网络断线 | 远程不可访问 | Tailscale 自动重连 + 本地任务继续执行 |
| 16GB 内存不够 | OOM | 监控内存，限制并发 Agent 数 |
| 内置 256GB 满 | 系统卡顿 | 数据全走外接盘 + 定期清理缓存 |
| 外接 SSD 掉线 | 项目不可用 | 挂载监控 + Telegram 告警 + 固定连接不拔插 |

### 7.5 最终架构一句话总结

> **Mac Mini M4（256GB 系统盘 + 1TB 外接数据盘 + 2TB 备份盘） + Tailscale 组网 + OpenClaw Gateway（launchd 守护） + Claude Code & Codex（ACP 集成） = 7×24 OPC 全能工作站，硬件总投入 ~¥1500，月度 API 费 ~$30。**

---

## 参考来源

1. OpenClaw Gateway 官方文档：https://docs.openclaw.ai/cli/gateway
2. OpenClaw ACP Agents 文档：https://docs.openclaw.ai/tools/acp-agents
3. ACPX GitHub：https://github.com/openclaw/acpx
4. Hermes Agent GitHub：https://github.com/NousResearch/hermes-agent
5. Hermes 安装文档：https://hermes-agent.nousresearch.com/docs/getting-started/installation
6. Claude Code npm：https://www.npmjs.com/package/@anthropic-ai/claude-code
7. Claude Code 官方文档：https://code.claude.com/docs/en/setup
8. OpenAI Codex CLI：https://github.com/openai/codex
9. Codex 官方文档：https://developers.openai.com/codex/cli
10. Mac Mini M4 Home Server 评测：https://hostbor.com/mac-mini-m4-home-server/
11. Tailscale vs Cloudflare Tunnel 对比：https://onidel.com/blog/tailscale-cloudflare-nginx-vps-2025
12. macOS 禁用自动更新：https://www.roundfleet.com/tutorial/2025-07-07-disable-automatic-os-updates-macos

---

*报告完成于 2026-05-02 09:21 CST*
