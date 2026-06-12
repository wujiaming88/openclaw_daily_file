# AI Agent 沙箱（Sandbox）技术体系全景研究

> 深度技术研究报告 · 面向技术决策者
> 撰写：黄山（System Architect & Technology Researcher）
> 日期：2026-06-12
> 数据截止：2026 年 6 月

---

## 1. 执行摘要

**一句话定位**：沙箱是 Agentic AI 落地的"安全地基"——大模型生成的代码与工具调用本质上是**不可信输出**，必须在隔离环境中执行，否则一次 prompt injection（提示注入）就足以泄露 SSH 私钥、删除主目录或向攻击者服务器"打电话回家"。沙箱把 Agent 的"意图信任"问题转化为"边界强制"问题：你不再赌 Agent 不作恶，而是赌它**越界时会被内核挡住**。

**当前技术格局（2026）可概括为两条主线**：

1. **本地 Coding Agent（Codex CLI / Claude Code / OpenClaw）** 走"OS 原语轻量隔离"路线：不起容器，直接用 **macOS Seatbelt（sandbox-exec）+ Linux Landlock/seccomp/bubblewrap + 网络代理白名单**，把开销压到接近零，配合 **approval（人机审批）模型** 平衡自治与安全。核心矛盾是"减少审批疲劳"与"边界正确性"。

2. **云端 Agent 沙箱即服务（E2B / Daytona / Modal / Cloudflare / Northflank）** 走"轻量级虚拟化"路线：以 **Firecracker microVM** 或 **gVisor 用户态内核** 为隔离边界，主打 **~150ms 冷启动 + 硬件级/内核级多租户隔离 + 弹性扩容**。核心矛盾是"安全强度（独立内核）"与"冷启动延迟/密度"。

**赢家研判**：在云端，**Firecracker microVM（独立内核 + KVM 硬件隔离）已成为"不可信代码多租户执行"的事实标准**（E2B、Northflank、Fly、AWS Lambda/Fargate 底座均采用），gVisor（Google/Modal/Daytona 部分）作为"接近容器速度、强于容器隔离"的折中并存。在本地，**OS 原生沙箱 + 代理网络白名单 + approval** 成为 2025-2026 三大 Coding Agent 的趋同设计。WASM/WASI 则在**工具/MCP 调用粒度的细粒度隔离**上崭露头角（Wassette），是 MCP 时代值得押注的方向。

**给决策者的一句话**：选型先回答"我跑的是**我自己的**代码还是**任意租户的不可信代码**"——前者用 OS 原语沙箱够了，后者必须上 microVM（独立内核），容器（共享内核）在多租户不可信场景下是**已知不充分**的。

---

## 2. 演进史：从 chroot 到 Agent 原生沙箱

隔离技术的演进是一部"边界不断下沉、开销不断压缩"的历史，AI Agent 只是把这条曲线推到了新的工作点。

**第一代：进程级隔离（1979–2008）**
- `chroot`（1979）：只改文件系统根，不隔离进程/网络/用户，**从来不是安全边界**（root 可逃逸）。
- FreeBSD Jails（2000）、Solaris Zones（2004）：第一批"OS 级容器"，引入资源与进程视图隔离。
- Linux 在 2002–2008 陆续合入 **namespaces**（mount/PID/net/user/...）与 **cgroups**，为容器奠基。

**第二代：容器化（2013–2017）**
- Docker（2013）把 namespaces + cgroups + 镜像分发包装成开发者体验革命。
- 关键认知：**容器共享宿主内核**。容器隔离 = 内核里的访问控制，一旦内核有漏洞（脏牛 Dirty COW、各种 CVE），就可能**容器逃逸**到宿主。对"运行自己的代码"足够，对"运行任意不可信代码"不够。

**第三代：轻量级虚拟化 / 用户态内核（2017–2020）**
- **gVisor**（Google，2018 开源）：用 Go 写了个**用户态内核 Sentry**，拦截容器系统调用并在用户态重新实现，宿主内核暴露面大幅缩小。"像内核一样面对工作负载，像普通用户进程一样面对宿主内核"。
- **Firecracker**（AWS，2018 开源）：用 Rust 写的极简 VMM，基于 KVM，**每个 microVM 独立 guest 内核**，启动 ~125ms、内存开销 <5MiB，单机可跑数千个。AWS Lambda / Fargate 的底座。
- **Kata Containers**（2017）：OCI 兼容的"看起来像容器、实则每个 Pod 一个轻量 VM"。

**第四代：Agent 原生沙箱即服务（2023–2026）**
- **E2B**（2023）把 Firecracker microVM 包装成"给 AI Agent 的 SDK"，~150ms 冷启动，按需创建/销毁，瞄准"LLM 生成代码的一次性执行环境"。
- **Daytona**（2025 转型）、**Modal**（gVisor）、**Cloudflare Sandbox SDK**（2025）、**Northflank**（Firecracker/Kata/gVisor 多后端）相继入场。
- 同期，本地 Coding Agent 走另一条路：**OpenAI Codex CLI**（2025）与 **Anthropic Claude Code**（2025）不依赖容器，直接用 OS 原生沙箱 + 网络代理，2025 年底 Anthropic 把它开源为 **sandbox-runtime（srt）**。

**演进的底层逻辑**：边界从"文件系统视图"→"内核命名空间"→"用户态内核/独立 guest 内核"→"硬件信任根（SEV/TDX）"层层下沉；同时启动开销从"秒级 VM"被压到"百毫秒 microVM"乃至"零开销 OS 原语"。AI Agent 的特殊性在于：**它需要频繁、短时、大规模地创建一次性执行环境**，于是"冷启动时间"从一个边缘指标跃升为**头等设计约束**。

---

## 3. 底层技术体系详解

沙箱的本质是"在某一层架设强制边界"。下面按隔离边界所处的层次，从浅到深拆解七类技术原理。

### 3.1 OS 级隔离原语（进程层边界）

这是最轻量的一类：不虚拟化、不起容器，直接用内核特性约束一个进程及其子进程树。

**seccomp-bpf（Secure Computing with BPF）**
- 原理：给进程挂一段 BPF 程序，对每个 syscall 做过滤，返回 allow/deny/trap/errno。一旦设置不可撤销，且被子进程继承。
- 用途：缩小内核攻击面——内核 ~400 个 syscall，多数沙箱只放行几十个。Docker 默认 seccomp profile 屏蔽约 44 个危险 syscall。
- 局限：只能按 syscall 号+参数粗粒度判断，无法理解"只允许访问某文件"这类语义。

**Linux namespaces**
- 六类：mount / PID / network / user / IPC / UTS。各自隔离一种全局资源视图。
- **user namespace** 是关键：让进程在容器内是 root、在宿主是普通 uid，是"无 root 容器"（rootless）与 bubblewrap 的基础。但 user namespace 本身历史上是大量提权 CVE 的来源，部分发行版（Ubuntu）默认用 AppArmor 限制非特权 user namespace 创建——这正是 Codex 在 Ubuntu 上需要加载 `bwrap-userns-restrict` profile 的原因。

**cgroups（control groups）**
- 资源维度隔离：CPU、内存、PID 数、IO、网络带宽配额。对 Agent 沙箱意义在于**防资源耗尽型 DoS**（无限 fork、内存炸弹、死循环挖矿）。隔离"能用多少"，而非"能访问什么"。

**Landlock LSM（Linux 5.13+）**
- 原理：**非特权进程**可自我施加的、基于能力（capability-based）的文件系统访问控制。进程声明"我只需要对这些目录读/写"，内核此后强制执行，且不可放宽。
- 相对 seccomp 的优势：seccomp 只能拦 syscall 号，无法表达"允许打开 /workspace 但拒绝 /etc"；Landlock 直接在**文件路径粒度**做访问控制，补上 seccomp 的语义短板。
- 这是 Codex Linux 沙箱的核心：**Landlock 管文件系统 + seccomp 管 syscall（含网络）**。

**AppArmor / SELinux（MAC，强制访问控制）**
- 管理员预定义 profile/policy，给进程贴标签限制权限。AppArmor 路径导向、易写；SELinux 标签导向、严密但复杂。多为发行版/容器运行时的纵深防御层，而非 Agent 自助式沙箱的主力。

**macOS Seatbelt（sandbox-exec）**
- 原理：苹果基于 TrustedBSD MAC 框架的沙箱，用 Scheme 风格的 `.sb` profile 描述"默认拒绝 + 显式放行"，通过 `/usr/bin/sandbox-exec -p <profile>` 启动受限子进程。
- **现状反讽**：苹果官方标 `sandbox-exec` 为 deprecated，但整个生态（Codex、Claude Code、Anthropic srt）仍重度依赖它，因为 App Sandbox 需要静态 entitlements，不适合动态 Agent 场景。
- **已知坑**：(1) 自定义 Seatbelt policy 极易写错，曾有 AI Agent 沙箱因 profile 疏漏未挡住 `~/Library` 与家目录 dotfiles；(2) 网络控制"全有或全无"，无法按域名细粒度过滤——这正是 Codex/Claude Code 要在 Seatbelt 之外再叠本地代理做网络白名单的原因；(3) homebrew 等装依赖操作在 Mac 沙箱里很难顺畅运行。

> **洞察**：OS 原语的根本局限是"工作在 syscall 层"——它理解文件、socket、进程，但**不理解"只允许 HTTPS 到 api.openai.com"这类应用语义**。所以所有本地 Agent 沙箱都是"OS 原语管文件/进程 + 用户态代理管网络"的混合架构。这是 syscall 抽象层级决定的必然。

### 3.2 容器（Docker/OCI）与其对 Agent 的不足

容器 = namespaces（视图隔离）+ cgroups（资源隔离）+ 联合文件系统（镜像分层）+ seccomp/AppArmor/capabilities（纵深防御）。对“跑自己的代码”是业界默认答案，但对 Agent “跑任意不可信代码”有两个结构性问题：

1. **共享内核 = 共享攻击面**。所有容器调用同一个宿主内核，内核 ~400 个 syscall 任一个有提权漏洞（历史上 Dirty COW、各类 run* 逃逸）都可能导致**容器逃逸**。多租户场景下，一个租户逃逸即影响同宿主所有租户。Daytona/Cloudflare 默认的容器方案都明确承认这一点。
2. **默认配置并不安全**。`--privileged`、挂载 docker.sock、共享 namespace 等都是常见“一脚踩穿边界”。Agent 生成的代码可能主动去探这些。

结论：容器是**运维隔离工具**，不是**安全边界工具**。这是 E2B/Northflank 坚持上 microVM、而不是“加固的 Docker”的根本理由。但容器胜在启动快、生态熟——所以 Daytona 用容器换 sub-90ms 冷启动，是一个明确的“速度换隔离强度”权衡。

### 3.3 轻量级虚拟化 / microVM

**Firecracker（AWS，Rust，2018）**
- 架构：基于 KVM 的极简 VMM，只实现跑 microVM 所需的最小设备模型（virtio-net/block、串口、键盘控制器），抓掉 QEMU 的几十万行设备仿真代码。每个 microVM 有**独立 guest 内核**。
- 指标：启动 ~125ms，内存开销 <5MiB/VM，单机可起数千个、每秒创建约 150 个。AWS Lambda/Fargate 底座。
- 隔离边界：**VM 边界 + KVM 硬件辅助**。宿主内核只暴露 KVM 接口给 guest，远小于整个 syscall 表面。jailer 组件再用 cgroups/namespaces/seccomp 把 Firecracker 进程本身也关起来做纵深防御。
- 局限：仍面临微架构侧信道（arXiv 2311.15999 发现 Medusa/Spectre-PHT 变种在推荐缓解后仍可能影响 Firecracker VM）。依赖 KVM，需裸机/嵌套虚拟化支持。

**gVisor（Google，Go，2018）**
- 架构：用户态应用内核。核心组件 **Sentry**（拦截并在用户态重实现 syscall）+ **Gofer**（代理文件系统访问）。`runsc` 是 drop-in 的 OCI 运行时，可直接接 Docker/K8s。
- 拦截机制：现代 **systrap** 平台用 seccomp 的 `SECCOMP_RET_TRAP`，让内核向触发线程发 SIGSYS，交由 gVisor 处理（早期 ptrace 平台性能差）。
- 隔离逻辑：“像内核一样面对工作负载，像普通进程一样面对宿主内核”。应用的 syscall 打不到真内核，只能打到 Sentry；Sentry 自身只用极少数受限 syscall 与宿主交互。
- 权衡：安全优于容器（不共享真内核 syscall 表面），但**系统调用密集型负载性能损耗明显**（每次 syscall 多一道用户态转发）；gVisor 官方指出“应用在用户态做的工作越多，拦截开销占比越低”。Modal、Daytona（部分）、Google Cloud Run 采用。

**Kata Containers / Cloud Hypervisor**
- Kata：OCI 兼容，“看起来是容器、实则每 Pod 一个轻量 VM”，兼顾 K8s 生态与 VM 级隔离。Northflank 多后端之一。
- Cloud Hypervisor：同样基于 KVM 的 Rust VMM，定位与 Firecracker 近似但功能更全（热拔插、更多设备）。

> **洞察（microVM vs gVisor）**：两者都是“比容器强、比传统 VM 轻”，但机制不同：Firecracker 用**独立 guest 内核 + 硬件虚拟化**换隔离，代价是需 KVM、有 ~125ms 启动；gVisor 用**用户态重写内核**换隔离，代价是 syscall 性能损耗与“兼容性问题”（部分 syscall 未完全实现）。选型上：要**极致隔离 + 任意内核行为**选 microVM；要**兼容 K8s/容器生态 + 可接受损耗**选 gVisor。

### 3.4 WASM 沙箱（语言运行时边界）

- 原理：WebAssembly 是为"在不信任环境跑不信任代码"生的字节码格式。模块跑在**线性内存沙箱**里，默认**无任何宿主能力**（不能访文件、不能联网）。
- **WASI + 能力安全模型**：宿主显式授予能力（如 `wasmtime --dir=/tmp`），模块只能访问被授资源。经典演示：未授 `/tmp` 时，`/tmp/../sample_text` 路径逿逃被拒（Operation not permitted）。
- **为何适合工具调用隔离**：单个工具/MCP server 是天然的"最小能力单元"。用 WASM 包一个工具，可做到"只能访问它声明要的那个 API"，启动快（微秒级）、跨平台、嵌入宿进程无需 VM。**Wassette**（基于 Wasmtime、Rust，2025）就是把 MCP server 编译为 WASM 组件做细粒度隔离的尝试。
- 局限：生态成熟度低；WASI 约束（线程、异步 IO、syscall 受限）；Node 自带 WASI **明确声明不足以跑不信任代码**（只有 Wasmtime/Wasmer 为强沙箱设计）；过度授能与运行时 CVE 是主要风险。

### 3.5 浏览器内沙箱

- **WebContainers（StackBlitz）**：把 Node.js 环境编译为 WASM，在浏览器 tab 内运行。含**虚拟化 TCP 网络栈**（映射到 ServiceWorker API）。隔离边界是**浏览器同源沙箱 + WASM 线性内存**——代码跑不出 tab，零服务器侧风险。适合 AI 生成前端项目即时预览（bolt.new）。
- **Pyodide**：CPython 编译为 WASM，在浏览器/Worker 跑 Python，是轻量“数据分析 Agent”的代码解释器选项。
- 价值：零后端成本、零服务器冷启动、天然多租户。局限：受 WASM 生态限制，原生二进制兼容有限。

### 3.6 网络隔离与出口控制

这是 Agent 沙箱最被低估但最关键的一环。**文件隔离防不住数据外汄，必须配网络隔离**：即使代码读不到 SSH 私钥，只要能任意联网就能把已读到的东西发出去；反之，能联网但读不到敏感文件也少了一半风险。Anthropic 明确表述：“有效沙箱需要文件系统与网络隔离两者同时具备。”

主流机制：
- **代理白名单（egress proxy allowlist）**：Claude Code/srt 的做法——沙箱内部 network namespace 被整个移除，所有流量必须走宿主上运行的代理（Linux 走 Unix domain socket，macOS 走 localhost 特定端口）；HTTP/HTTPS 走 HTTP 代理、其他 TCP 走 SOCKS5，代理按域名 allowlist/denylist 放行，拒绝返回 CONNECT 403。
- **DNS 控制**：限制可解析的域名，防止 DNS 隧道外汄。
- **已知绕过**（Claude Code 文档自述）：domain fronting（域名前置）、Unix socket 提权、Linux 嵌套沙箱较弱。这说明代理白名单是“提高门槛”而非“绝对边界”。

### 3.7 文件系统隔离

- **overlayfs / 写时复制（CoW）**：基镜像只读，沙箱写入落到上层，销毁时丢弃。microVM/容器沙箱普遍采用，是“一次性环境”的技术基础。
- **只读挂载 + 写路径白名单**：Codex 把 writable_roots 以外都只读，且特地把工作区内的 `.git` 目录抑为只读（防 Agent 损坏版本历史）。srt 的写采用“allow-only”（默认全拒，显式放行），读采用“deny-then-allow”（默认全放，可先拒广区再重放子路径）。
- **路径规范化防逿逃**：Codex 在 macOS 上对 writable root 做 `canonicalize`（如 /var vs /private/var），避免符号链接/别名绕过。

---

### 3.8 七类技术权衡对比表

| 技术 | 隔离边界 | 隔离强度 | 启动/开销 | 多租户不信任 | 典型使用者 |
|---|---|---|---|---|---|
| seccomp-bpf | syscall 过滤 | 低（单独） | ~0 | 否（需叠加） | Docker 默认、Codex Linux |
| namespaces+cgroups | 内核视图/资源 | 低-中 | ~0 | 否 | 所有容器 |
| Landlock | 文件路径能力 | 中（补 seccomp） | ~0 | 否 | Codex Linux |
| macOS Seatbelt | 进程（MAC） | 中（易写错） | ~0 | 否 | Codex/Claude Code/srt macOS |
| Docker 容器 | 共享内核 | 中（有逃逸史） | 毫秒-秒 | **不推荐** | Daytona/Cloudflare 默认 |
| gVisor | 用户态内核 | 高 | ~百毫秒 | 是 | Modal/Google Cloud Run |
| Firecracker microVM | 独立内核+KVM | **最高（非 TEE）** | ~125-200ms | **是** | E2B/AWS Lambda/Northflank |
| WASM/WASI | 语言运行时 | 中-高（能力） | 微秒 | 是（进程内） | Wassette/Fastly |
| 浏览器内(WASM) | 同源+线性内存 | 高（对宿主） | 秒级首加载 | 是 | WebContainers/Pyodide |
| TEE (SEV/TDX) | 硬件加密内存 | **最高（含宿主）** | VM 级 | 是（含云厂商） | 机密计算场景 |

> “隔离强度”纵轴的本质是**取决于共享什么**：共享进程地址空间（无）< 共享内核（容器）< 共享虚拟化层（gVisor/microVM）< 共享物理 CPU 但加密内存（TEE）。共享越少，隔离越强，代价越高。

---

## 4. 主流 Agent 沙箱方案横评

### 4.1 OpenAI Codex（Codex CLI / Codex cloud）

**隔离架构**：Codex 不起容器，采用**平台原生强制**，所有子进程继承边界（git、包管理器、测试运行器皆受限）：
- **macOS**：Seatbelt，通过 `sandbox-exec -p <profile>` 启动，根据 `--sandbox` 模式生成 profile。源码中 `spawn_command_under_seatbelt` 硬编码 `/usr/bin/sandbox-exec`，注入 `CODEX_SANDBOX=seatbelt` 环境变量；writable roots 中的 `.git` 被特地抑为只读。禁网时直接不加网络权限（Seatbelt 默认拒绝）。
- **Linux**：默认 **bwrap（bubblewrap）+ seccomp**；文件系统用 **Landlock**。CLI 通过 `arg0_dispatch_or_else` 判断是否以 `codex-linux-sandbox` 别名被调用；所有命令走 `process_exec_tool_call` 根据 `SandboxType` 路由。**默认即沙箱（opt-out 而非 opt-in）**。缺 `bwrap` 时回退到内置 helper（需非特权 user namespace）。
- **Windows**：PowerShell 用原生 Windows sandbox，WSL2 复用 Linux 实现。

**权限/approval 模型**（沙箱与审批是两个正交控制）：
- sandbox_mode：`read-only` / `workspace-write`（默认，可读、工作区可写、跑本地常规命令）/ `danger-full-access`。
- approval_policy：`untrusted` / `on-request`（默认，越界才问）/ `never`。
- 低摩擦预设：`--sandbox workspace-write --ask-for-approval on-request`。超出边界时触发“升级流”（检测退出码/stderr 判断是否沙箱拒绝 → 请求审批 → 放宽策略重试）。
- 2026 新增 `approvals_reviewer: auto_review`，可把审批交给一个 reviewer agent 而非人。
- writable_roots / rules：可扩展可写目录、按命令前缀 allow/prompt/forbid。

**网络/文件策略**：workspace-write 默认禁网，越界需审批。文件限在 workspace + writable_roots。
**隔离边界**：进程级（OS 原语）。**冷启动**：近乎零（无 VM/容器）。**开源**：Codex CLI 是开源 Rust（codex-rs）。**适用**：本地 Coding Agent。Codex cloud 则是云端隔离 VM（每任务独立环境）。

> **洞察**：Codex 是“本地 OS 沙箱”的教科书实现：默认即沙箱、跨三平台原生、沙箱与审批解耦。但它继承了 Seatbelt 的先天短板（网络全有或全无）——这也是为何它用“禁网 + 越界审批”而非“细粒度域名白名单”的原因。

### 4.2 Claude Code（Anthropic）

**演进**：Claude Code 默认是**基于权限的模型**（默认只读，改动/跑命令前问，只自动放行 echo/cat 等安全命令）。但“不停点接受”导致审批疲劳。2025 年底推出 **沙箱化 bash 工具**，内部数据显示**安全地减少 84% 的权限提示**。

**隔离架构**（与 Codex 趋同但网络更强）：基于 OS 原语——**Linux bubblewrap + macOS Seatbelt**，覆盖 Claude 直接操作及其派生的任何脚本/子进程。两道边界：
- **文件系统隔离**：只能读写工作目录，越界写在 syscall 层报 `Operation not permitted`。
- **网络隔离**：仅允许通过 unix domain socket 连到沙箱外代理，代理按域名 allowlist 放行并处理新域名的用户确认。企业可定制代理规则。

**开源：sandbox-runtime（srt）** —— `@anthropic-ai/sandbox-runtime`，Beta 研究预览，独立 CLI+库，可沙箱任意进程/agent/本地 MCP server/bash。secure-by-default：进程以最小权限启动，需要哪里才“捣洞”。
- 文件：写是 allow-only（默认全拒），读是 deny-then-allow（allowRead 优于 denyRead，与写相反）。
- 网络：allow-only，空 allowlist = 无网。Linux 移除 network namespace，流量走 bind-mount 进沙箱的 Unix socket 代理；macOS 走 localhost 特定端口。HTTP 走 HTTP 代理、其他 TCP 走 SOCKS5。
- macOS 还能接入系统沙箱违规日志实时告警。

**沙箱环境选项分层**（按 threat model 选）：内置沙箱 bash（低隔离、无需容器） → sandbox runtime（覆盖整个 Claude Code 进程含 MCP/hooks） → dev container/Docker → 专用 VM（跑不可信仓库） → Claude Code on the web（Anthropic 托管的完整 OS）。

**已知局限**（文档/第三方分析自述）：/sandbox 是 opt-in（不开就是裸 bash）；`sandbox.denyRead` 不拦 Claude 的 Read 工具（需另设 Read deny 规则）；domain fronting、Unix socket 提权、Linux 嵌套沙箱较弱；与 Docker/Watchman 不兼容。

**隔离边界**：进程级。**冷启动**：近乎零。**开源**：srt 开源，Claude Code 本体闭源。

### 4.3 OpenClaw（开源 Agent 框架）

（本节基于本地安装的 OpenClaw 文档与 CLI，客观评估。）

**信任模型（最关键的设计选择）**：OpenClaw 明确自定位为**个人助理信任模型**：每个 gateway 一个受信任操作者边界。文档直言：OpenClaw **不是**面向多个敗意用户共享一个 agent 的敌对多租户安全边界。这与 E2B/Modal 这类 SaaS 多租户沙箱是根本不同的定位——OpenClaw 解决的是“受信任操作者的 Agent 不要误伤宿主”，而非“隔离互不信任的租户”。

**沙箱后端（agents.defaults.sandbox.backend）**：
- **Docker**：默认容器沙箱（openclaw-sandbox 镜像），按 session/agent 范围创建。
- **SSH**：把执行放到远程主机，远程工作区为准，`sandbox recreate` 删除并从本地重播。
- **OpenShell（remote）**：插件化远程沙箱，可配 mode/policy/from。
- `openclaw sandbox explain` 可检查生效的沙箱模式/范围/工作区访问/工具策略/elevated 门控。

**执行隔离与 approval 体系**：
- exec 在 gateway/node 上默认允许无提示执行（security=full、ask=off），这是为受信任单操作者场景的有意 UX 默认，可收紧。
- **exec 审批（allowlist + ask）是“操作者意图护栏”，明确声明不是敌对多租户隔离**。文档警告：审批不建模所有运行时/解释器加载路径——强边界请用沙箱与主机隔离。
- `openclaw security audit` 可检测 gateway auth 暴露、浏览器控制暴露、审批过宽、文件权限等 footgun。

**隔离边界**：容器（Docker）或远程主机（SSH/OpenShell）。**冷启动**：容器级（复用运行时）。**开源**：是。**适用**：个人/团队受信任边界内的多 Agent 助理。

> **洞察**：OpenClaw 与 Codex/Claude Code 设计哲学不同：后两者把“不信任 LLM 输出”作为威胁模型核心，用 OS 原语默认硬挡；OpenClaw 把“受信任操作者”作为前提，沙箱是可选加固。对跑不可信代码场景，应显式启用 Docker 后端 + 收紧 exec 审批。

### 4.4 Google ADK（Agent Development Kit）

**定位**：ADK 是开源多 Agent 框架（与 Agentspace/CES 同源），沙箱能力主要通过两条路径提供：
- **BuiltInCodeExecutor**：让 agent 写 Python 并在“安全隔离沙箱”执行，输出回填答案。
- **Vertex AI Agent Engine Code Execution**（2026 preview）：托管托服务，提供安全沙箱跑 LLM 生成代码，可直接 SDK 调用或作为工具集成到 ADK。另有 **Agent Runtime Code Execution tool**（低延迟，不需部署到 Agent Runtime 即可用，但需先创建沙箱环境）、**GKE Code Executor**（自托管在 GKE 上）。
- 能向沙箱馈送 flat files 而不经 LLM context window。

**隔离边界**：云端托管容器/沙箱（具体底层未完全公开，推测为 GCP 上的 gVisor/容器体系，与 Cloud Run 一脉相承，**未公开确认**）。**多租户**：依托 GCP。**开源**：ADK 框架开源，沙箱后端为托管服务。**适用**：企业级多 Agent + Vertex AI 生态。

> 注：ADK 的沙箱实现细节是本报告中**最不透明**的（Google 未公开底层隔离原语细节），仅能从“Vertex 托管、与 Cloud Run/Agent Engine 同源”推断。这与 Codex/srt 完全开源可查源码形成鲜明对比。

### 4.5 沙箱即服务（SaaS）玩家

**E2B**：最纯粹的“Agent 专用沙箱”。每个沙箱一个 **Firecracker microVM**（独立内核、硬件级隔离），冷启动 ~150-200ms，运行时动态定义。开源（E2B OSS 可自托管）。宣称 88% 财富 100 已注册。Pro 并发约 1100（可加购）。**适用**：不可信代码多租户执行的事实标准。

**Daytona**：2025 年初从开发环境转型 AI 沙箱。主打 **sub-90ms 冷启动**，但默认用 **Docker 容器（共享内核，隔离弱于 microVM）**，部分采用 gVisor。持久化工作区。**权衡**：速度换隔离强度。

**Modal**：上 serverless 计算平台，沙箱用 **gVisor** 隔离，可扩到 50,000-100,000+ 并发，原生 GPU。SOC 2 Type 2、HIPAA（企业）。是“沙箱+推理+训练”完整平台的一部分。

**Cloudflare Sandbox SDK**：基于 Cloudflare Containers（330+ 城市边缘），TypeScript API 从 Workers 起隔离 Linux 容器，集成 Workers AI/Durable Objects/R2。**适用**：边缘、与 Workers 生态紧耦合的 Agent。

**Northflank**：多后端（**Firecracker/Kata/gVisor** 可选），BYOC（自带云 AWS/GCP/Azure/Oracle/裸机/本地），SOC 2 Type 2，无强制时长限制。**适用**：合规/自控云场景。

**其他**：Devin/Cognition（每任务完整沙箱 VM，“在自己的沙箱而非你的”）；Cursor 3.4 cloud agents、OpenAI Codex cloud（都是独立 VM、可排队 5-20 ticket 并行）；Replit Agent（云端托管环境）；Morph Sandbox（VM/Infinibranch，快照+分支、~250ms、适并行探索）；Koyeb（ephemeral serverless 容器）；Blaxel（永久沙箱）；CodeSandbox SDK、Fly.io Sprites。LangChain/LangGraph 本身不提供沙箱，而是集成 E2B/Modal/Daytona 作为代码执行工具。

### 4.6 横评对比矩阵

| 方案 | 隔离层级 | 冷启动 | 网络策略 | 开源/闭源 | 多租户不信任 | 适用场景 |
|---|---|---|---|---|---|---|
| Codex CLI | 进程(Seatbelt/Landlock+seccomp) | ~0 | 禁网+越界审批 | 开源(Rust) | 否 | 本地Coding |
| Codex cloud | 独立VM | VM级 | 可配 | 闭源 | 是 | 云端并行 |
| Claude Code(srt) | 进程(bwrap/Seatbelt) | ~0 | 代理域名白名单 | srt开源 | 否 | 本地Coding |
| OpenClaw | 容器/SSH/OpenShell | 容器级 | 随后端 | 开源 | 否(个人助理) | 受信任多Agent |
| Google ADK | 托管容器/沙箱 | 未公开 | GCP管理 | 框架开源 | 是(依GCP) | 企业Vertex |
| E2B | Firecracker microVM | ~150ms | 可配 | 开源 | 是 | 不可信代码SaaS |
| Daytona | Docker(部分gVisor) | <90ms | 可配 | 部分开源 | 中(容器) | 持久化快启动 |
| Modal | gVisor | 快 | 可配 | 闭源 | 是 | 大规模+GPU |
| Cloudflare | 容器(边缘) | 快 | Workers集成 | SDK开源 | 中 | 边缘Agent |
| Northflank | FC/Kata/gVisor | 可配 | 可配 | 闭源 | 是 | BYOC/合规 |
| Devin | 完整VM | VM级 | 可配 | 闭源 | 是 | 自主软件工程 |

---

## 5. 关键权衡与设计模式

**5.1 安全 vs 延迟（冷启动是头等指标）**。Agent 需频繁创建一次性环境，冷启动决定“用户问一句要等多久”。谱系：OS 原语(~0) < WASM(微秒) < 容器(毫秒) < gVisor(~百毫秒) < Firecracker(~125-200ms) < 传统 VM(秒)。隔离越强往往启动越慢。应对：**预热池 + 快照/分支**（Morph Infinibranch、Firecracker snapshot 恢复）把有效冷启动压到几十毫秒。

**5.2 本地 vs 云端**。本地（Codex/Claude Code/OpenClaw）低延迟、贴近文件、零额外基设，但隔离受限于 OS 原语且共享个人机器；云端（E2B/Modal/Daytona/Devin）强隔离、可并行扩展，但有往返延迟与成本。

**5.3 approval 人机协同**。沙箱定技术边界，approval 决定何时停下询问。核心矛盾是**审批疲劳**。趋势是“扩大沙箱边界+减少审批”（Anthropic 84%、Codex 默认沙箱）以及 **auto_review（代理人审批代理人）** 新范式。

**5.4 核心设计模式总结**：(1) **默认隔离（opt-out）** 优于“记得开”（Codex 的画龙点睛）；(2) **文件+网络双隔离缺一不可**；(3) **沙箱与审批解耦**（技术边界 vs 策略决策）；(4) **一次性 + CoW 文件系统**（用完即弃）；(5) **代理仲介网络**来补 OS 原语的语义短板。

---

## 6. 现状研判（2025-2026）

**谁是赢家？**
- **云端不可信代码多租户执行：Firecracker microVM 是事实标准**。理由：独立 guest 内核 = 真正的隔离边界，~125ms 启动 + <5MiB 开销让“虚拟机级隔离”第一次与“容器级密度”可兼得。E2B、Northflank、AWS Lambda/Fargate 都用它。这是为什么“Firecracker microVM 成为主流方向”的底层逻辑：它是唯一同时满足“强隔离 + 低启动 + 高密度”三角的成熟方案。
- **gVisor 是重要折中项**：不需 KVM/裸机、兼容容器生态、隔离强于容器，Modal/Google/部分 Daytona 采用。代价是 syscall 密集型负载性能损耗与兼容性。
- **本地 Coding Agent：OS 原生沙箱 + 代理白名单 + approval 三件套趋同**。Codex、Claude Code 独立收敛到几乎一样的架构（Seatbelt+Landlock/bwrap+seccomp+代理），这种跨公司收敛本身就是“这是正确路线”的最强信号。

**为什么容器在衰落（作为不可信边界）？** 共享内核是原罪。Daytona 用容器换冷启动，但它自己也提供 gVisor 选项，且第三方评测都明确指出“容器共享内核，逃逸影响同宿主所有沙箱”。

**一个清醒的认识**：没有银弹。Firecracker 仍面临微架构侧信道（arXiv 研究 Medusa/Spectre 变种）；Seatbelt policy 易写错；srt 自述 domain fronting/Unix socket 提权可绕过。沙箱是概率降低扈变损失，不是绝对保证。

---

## 7. 未来趋势

**7.1 Confidential Computing / 硬件隔离（SEV-SNP / TDX / GPU TEE）**
现有沙箱（含 microVM）都默认信任宿主内核与云厂商。机密计算把边界推到**硬件信任根**：AMD SEV-SNP / Intel TDX 用 CPU 加密内存，连宿主 OS / hypervisor / 云运维都看不到 guest 明文，并提供硬件结构 attestation。NVIDIA H100 GPU TEE 可与 CPU TEE 组合做机密 AI（Phala 等）。Confidential Computing Consortium 2026 成员超 50。对 Agent 的意义：当你跑的代码/数据连云厂商都不能信时（金融/医疗敏感），TEE 是下一道边界。局限：仍面临微架构侧信道与性能开销，且物理机仍多租户共享。

**7.2 MCP 时代的工具隔离**
MCP（Model Context Protocol）让 Agent 接入大量第三方工具/server，每个都是一个潜在不可信代码路径。趋势是**沙箱下沉到单工具粒度**：Anthropic srt 明确支持沙箱本地 MCP server；Wassette 把 MCP server 编译为 WASM 组件跑。WASM/WASI 的能力安全模型在这里最契合“最小权限 + 微秒启动 + 嵌入宿进程”。

**7.3 Agent 原生沙箱标准化**
当前每家自建一套（Codex 一套、srt 一套、E2B SDK 一套）。srt 开源、E2B OSS、Cloudflare/Daytona SDK 都在推动“可复用沙箱抽象”。可预见会出现类似 OCI / MCP 的“Agent 沙箱接口标准”（统一描述文件/网络/资源策略）。

**7.4 其他**：冷启动继续压缩（snapshot/fork 比冷启快一个数量级）；GPU 沙箱（Modal/Spheron）成为 AI 负载刚需；“分支式沙箱”支持多 Agent 并行探索同一状态（Morph）。

---

## 8. 附录：数据来源清单

**一手官方文档/源码**：
- OpenAI Codex Sandboxing 官方文档 developers.openai.com/codex/concepts/sandboxing；llms-full.txt；agent-approvals-security
- Anthropic sandbox-runtime GitHub (github.com/anthropic-experimental/sandbox-runtime)；Claude Code 文档 code.claude.com/docs/en/sandboxing 与 sandbox-environments；Anthropic Engineering 博客 claude-code-sandboxing
- OpenClaw 本地文档：docs/gateway/security/index.md、docs/cli/sandbox.md（本地安装 v2026.6.1）
- Google ADK：adk.dev/integrations/code-exec-agent-runtime、Vertex AI Agent Engine Code Execution 公告、developers.googleblog.com ADK
- Firecracker：aws.amazon.com/blogs/opensource firecracker、firecracker-microvm.github.io、GitHub、arXiv 2311.15999（微架构安全）
- gVisor：gvisor.dev/docs/architecture_guide（security/performance/platforms/intro）、security-basics 博客
- Wasmtime security 文档、WASI capability 模型（chikuwa.it）、Wassette（rawkode.academy）、eunomia.dev WASI 现状
- StackBlitz WebContainers 官方博客
- Cloudflare Sandbox SDK 文档与 GitHub

**二手分析/评测**：pierce.dev 《A deep dive on agent sandboxes》（Codex 源码级剖析）、Northflank 系列对比（E2B vs Modal/Daytona、best sandbox runners）、Modal 博客、Daytona/E2B 官网、Koyeb/Blaxel/Spheron/morphllm/zenml 对比、codex.danielvaughan.com、Confidential Computing（Phala/stealthcloud/GCP）。

**数据可信度标注**：Codex/Claude Code/srt/Firecracker/gVisor/WASM 技术机制为官方一手源，可信度高；E2B ~150ms、Firecracker ~125ms、Daytona <90ms 等冷启动数据多为厂商自报/二手评测，存在营销成分，已标注来源；ADK 底层隔离原语**未公开**，为推断；GitHub Stars 未逐一核实实时数值，故未在文中给出具体 Star 数以免编造。

*—— 报告完 ——*
