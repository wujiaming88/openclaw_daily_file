# Mac mini 远程个人 Agent 主机 · 落地 Runbook

> 目标：家里 Mac mini 常驻为「个人 Agent 大脑」，iPhone 与公司 MacBook 做客户端。
> 硬约束：**公司 MacBook 禁止安装 Tailscale 等任何客户端/VPN/CLI，只能开浏览器访问 HTTPS URL。**
> 决策已定：**自购域名**，主线走 Cloudflare Tunnel + Access。

- 日期：2026-10-17
- 产出：小帅（泰山执行失败后接管）
- 状态：可执行 Runbook，未实测项已逐处标注「需实测确认」

---

## 0. 最终架构（已按「有域名」收敛）

```
                    ┌──────────────────────────────┐
 iPhone             │   Telegram  ← 主力（聊天/指令） │
 （个人设备，可装）   │   iOS App / Safari（可选）    │
                    └──────────────────────────────┘
 公司 MacBook
 （零安装，纯浏览器）  ── https://agent.域名  ← OpenClaw Control UI
                      ── https://code.域名   ← code-server（浏览器版 VS Code）
                      ── https://shell.域名  ← ttyd（网页终端）
                            │  Cloudflare Access（SSO 登录，免费 Zero Trust 额度）
                            │  Cloudflare Tunnel（出站，不开放任何入站端口）
                            ▼
                    ┌──────────────────────────────┐
                    │       家里 Mac mini（常驻）     │
                    │  OpenClaw Gateway (127.0.0.1) │
                    │  code-server (127.0.0.1:8080) │
                    │  ttyd (127.0.0.1:7681)        │
                    │  tmux / 仓库 / Claude Code     │
                    └──────────────────────────────┘
```

**要点**

1. 三个服务全部只绑定 `127.0.0.1`（loopback），对外唯一的门是 Cloudflare Tunnel——**不暴露 SSH 22、不暴露任何公网端口**。
2. iPhone 的「跟 Agent 对话」用 **Telegram**（你现在就在用），无需装任何 VPN。iOS App 是可选增强，不是必需。
3. 公司 MacBook 打开浏览器即得完整 VS Code + 终端 + Agent 控制台，**零安装、绕开 MDM**。

---

## 1. 前置检查清单

| # | 检查项 | 命令 / 操作 | 期望 |
|---|--------|------------|------|
| 1 | Mac mini 系统版本 | `sw_vers` | macOS 13 Ventura 及以上（14 Sonoma 更稳） |
| 2 | 芯片架构 | `uname -m` | `arm64`（M 系）或 `x86_64`（Intel），决定 Homebrew 路径 |
| 3 | Homebrew | `brew --version` | 已装；未装则 `brew --prefix` 记下路径 |
| 4 | 域名 | 注册商后台 | 已购买，且**把 NS 托管到 Cloudflare**（关键，分支 A 必需） |
| 5 | Cloudflare 账号 | 登录 dash.cloudflare.com | 已注册；Zero Trust 免费额度：≤50 用户免费 |
| 6 | mini 有稳定网络/电源 | — | 常驻不断电不断网 |

> Cloudflare Zero Trust（Access）免费额度：**50 个用户以内免费**，个人使用完全足够。

**Homebrew 路径速记（全文用 `<BREW>` 代指）**

```bash
brew --prefix
# Apple Silicon 通常输出 /opt/homebrew
# Intel 通常输出 /usr/local
```

---

## 2. 分支选择

| 分支 | 适用 | 优点 | 缺点 |
|---|---|---|---|
| **A（主线，推荐）** Cloudflare Tunnel + Access | 已托管域名到 CF | 零安装、SSO、免开端口、自动 HTTPS | 国内访问 CF 线路偶有波动 |
| **B（备选）** 国内 VPS + frp + Caddy | 嫌 CF 慢 / 要国内低延迟 | 国内直连快 | 要养 VPS、要自己管鉴权与证书 |

> 先做分支 A 验证链路，跑通后再决定要不要叠加分支 B。两分支共享第 3~6 章的基础加固与常驻保障。

---

## 3. mini 侧基础加固（两分支共用）

### 3.1 开启远程登录（仅密钥，禁密码）

```bash
# 开启 SSH 远程登录
sudo systemsetup -setremotelogin on

# 写一个 drop-in 配置（macOS Ventura+ 支持 /etc/ssh/sshd_config.d/*，需实测确认）
sudo mkdir -p /etc/ssh/sshd_config.d
sudo tee /etc/ssh/sshd_config.d/90-hardening.conf >/dev/null <<'EOF'
PasswordAuthentication no
PermitRootLogin no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
EOF

# 若系统不支持 drop-in，直接编辑 /etc/ssh/sshd_config，追加同样四行并确保
# 主配置里没有 `Include /etc/ssh/sshd_config.d/*` 冲突（需实测确认）
```

**验证**：`sudo sshd -t`（无输出即语法正确）；从另一台机器 `ssh user@mini-ip` 应被要求用密钥而非密码。

> 密钥注入：在客户端 `ssh-keygen -t ed25519`，`ssh-copy-id user@mini-ip`。**SSH 只允许走内网/Tailscale，绝不允许映射到公网。**

### 3.2 FileVault 全盘加密

```bash
sudo fdesetup enable
# 之后 sudo fdesetup status 应显示 FileVault is On.
```

### 3.3 macOS 应用防火墙

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
# stealth 模式可选（会拒绝 ICMP 探测，可能影响 Wake-on-LAN，按需开启）
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
```

**验证**：`sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate` 输出 `Firewall is enabled.`

### 3.4 关闭不必要的共享服务

系统设置 → 通用 → 共享：除「远程登录」外全部关闭（屏幕共享、文件共享、媒体共享等）。

---

## 4. 常驻保障（两分支共用）

### 4.1 能源设置（永不休眠 + 断电自启 + 网络唤醒）

```bash
# 永不休眠（sleep 0）、硬盘不休眠、断电后自动重启、网络唤醒
sudo pmset -a sleep 0 disksleep 0 womp 1 autorestart 1
# 关闭 Power Nap（避免后台唤醒干扰）
sudo pmset -a powernap 0
```

**验证**：`pmset -g custom` 检查 `sleep 0`、`autorestart 1`、`womp 1`。

图形界面等价：系统设置 → 电池/节能 → 「防止自动睡眠」勾选 + 「断电后自动重新启动」勾选 + 「唤醒以供网络访问」勾选。

### 4.2 自动登录（断电重启后无人值守）

系统设置 → 用户与群组 → 登录选项 → 自动登录 → 选你的用户。

> 自动登录会带来本机物理安全风险（能摸到机器就能用）。家里环境可接受；介意的话可改用 FileVault + 手动登录，但断电重启后服务不会自动起。**二选一，权衡清楚。**

### 4.3 可选：caffeinate 保活

launchd plist 的 `KeepAlive` 通常已够，无需额外 `caffeinate`。若个别服务被系统睡眠打断，再单独用：

```bash
caffeinate -dimsu &
# -d 防显示器休眠 -i 防系统空闲休眠 -m 防磁盘休眠 -s 接电源时防睡 -u 声明用户活动
```

---

## 5. OpenClaw 侧配置（两分支共用骨架，鉴权随分支微调）

### 5.1 安装

```bash
# 按官方文档安装 openclaw 到 mini（以 docs 最新安装说明为准）
openclaw --version
```

### 5.2 基础配置（loopback + 端口）

```bash
openclaw config set gateway.bind loopback
# 默认端口 18789，如改端口：
# openclaw config set gateway.port 18789
```

### 5.3 分支 A 的鉴权（Cloudflare Access → trusted-proxy）

> 配置项已对照本机官方文档 `gateway/cloudflare-access.md` 核实。**不要凭记忆改键名。**

编辑配置文件（`openclaw config` 或直接编辑 `~/.openclaw/openclaw.json5`）：

```json5
{
  gateway: {
    bind: "loopback",
    publicOrigin: "https://agent.你的域名",
    trustedProxies: ["127.0.0.1", "::1"],
    auth: {
      mode: "trusted-proxy",
      trustedProxy: {
        userHeader: "cf-access-authenticated-user-email",
        requiredHeaders: ["cf-access-jwt-assertion"],
        allowLoopback: true,
      },
    },
  },
}
```

**验证**：`openclaw gateway restart` 后 `openclaw status` 无报错；`lsof -nP -iTCP:18789 -sTCP:LISTEN` 应只见 `127.0.0.1:18789`，绝无 `0.0.0.0:18789`。

### 5.4 分支 B 的鉴权（Caddy basic_auth 在前 → gateway 用 password 或 token）

分支 B 由 Caddy 统一做 basic_auth，OpenClaw 侧可保持 password 模式：

```json5
{
  gateway: {
    bind: "loopback",
    publicOrigin: "https://agent.你的域名",
    auth: { mode: "password", password: "强密码-或用环境变量注入" },
  },
}
```

> 建议密码走环境变量，不落盘：`OPENCLAW_GATEWAY_PASSWORD`（见 `gateway/tailscale.md`）。

### 5.5 Control UI 子路径与跨域（可选）

- 若把 Control UI 放在子路径（`/agent/`），用 `gateway.controlUi.basePath`；子域名场景（`agent.域名`）**无需设置**。
- 跨域访问时用 `gateway.controlUi.allowedOrigins` 白名单；Cloudflare 同源/私有部署一般不需要。**这两项键名已核实，语义以 `docs/gateway/config-gateway.md` 为准。**

---

## 6. 分支 A：Cloudflare Tunnel + Access（主线）

### A1. 域名托管到 Cloudflare

注册商后台把 NS 改为 Cloudflare 分配的两条 NS 记录，等 `dash.cloudflare.com` 显示域名状态为 **Active**。

**验证**：`dig agent.你的域名 +short` 之后能解析（先随便加一条 A 记录测试）。

### A2. mini 安装 cloudflared

```bash
brew install cloudflared
cloudflared --version
```

### A3. 登录并创建隧道

```bash
cloudflared tunnel login          # 弹浏览器，选你的域名，确认授权
cloudflared tunnel create mini-agent   # 创建，输出 TUNNEL_ID，并生成 ~/.cloudflared/<TUNNEL_ID>.json
```

**验证**：`ls ~/.cloudflared/` 看到 `cert.pem` 与 `<TUNNEL_ID>.json`。

### A4. 写隧道配置

```bash
TUNNEL_ID=$(cloudflared tunnel list --output json | ... )  # 取你刚创建的 ID
tee ~/.cloudflared/config.yml >/dev/null <<EOF
tunnel: ${TUNNEL_ID}
credentials-file: /Users/你的用户名/.cloudflared/${TUNNEL_ID}.json
ingress:
  - hostname: agent.你的域名
    service: http://localhost:18789
  - hostname: code.你的域名
    service: http://localhost:8080
  - hostname: shell.你的域名
    service: http://localhost:7681
  - service: http_status:404
EOF
```

> 占位符「你的用户名」务必用 `whoami` 的真实值，不能用 `~`（launchd 不展开 `~`）。

### A5. 路由 DNS

```bash
cloudflared tunnel route dns mini-agent agent.你的域名
cloudflared tunnel route dns mini-agent code.你的域名
cloudflared tunnel route dns mini-agent shell.你的域名
```

**验证**：Cloudflare DNS 面板出现三条 `CNAME` 指向 `<TUNNEL_ID>.cfargotunnel.com`。

### A6. 先前台跑通一次

```bash
cloudflared tunnel run mini-agent
```

**验证**：无报错；`curl -sS -o /dev/null -w '%{http_code}\n' https://agent.你的域名/`（Cloudflare 未加 Access 前，默认允许，应返回 200 或 OpenClaw 的鉴权响应）。

### A7. 配 Cloudflare Access（Zero Trust）

1. dash.cloudflare.com → Zero Trust → Access → Applications → Add an application → **Self-hosted**。
2. 分别建三个应用：`agent.你的域名`、`code.你的域名`、`shell.你的域名`（或用一个 `*.你的域名` 通配应用，需实测确认通配是否覆盖多子域）。
3. 每个应用加 Policy：`Allow` → Include → Emails → 填你自己的邮箱（或 Google/GitHub 登录）。
4. 保存后，Access 会向通过认证的请求注入两个头：
   - `cf-access-authenticated-user-email`
   - `cf-access-jwt-assertion`

**验证**：浏览器打开 `https://agent.你的域名/`，应先出现 Cloudflare Access 登录页，登录后才到 OpenClaw。

### A8. 让 OpenClaw 信任 Access 头（对照 5.3）

```bash
openclaw config set gateway.auth.mode trusted-proxy
# 其余 trustedProxy / userHeader / requiredHeaders / allowLoopback 按 5.3 的 JSON5 写入配置
openclaw gateway restart
```

**验证**：重新走一次 Access 登录，能进入 Control UI；`curl`（不带 Access 头）直连 loopback 应被拒（403/401）。

> 安全边界说明：`trusted-proxy` 只做「头存在性」检查，不验 JWT 签名。真正的门是「loopback 只对 cloudflared 开放」+「Cloudflare Access」。**不要**在同一台 mini 上跑不可信本地代码。

### A9. cloudflared 开机自启（LaunchAgent）

手写 plist（比 `cloudflared service install` 更可控）：

```bash
mkdir -p ~/Library/LaunchAgents
tee ~/Library/LaunchAgents/com.user.cloudflared.plist >/dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.user.cloudflared</string>
  <key>ProgramArguments</key>
  <array>
    <string>/opt/homebrew/bin/cloudflared</string>
    <string>tunnel</string>
    <string>--config</string>
    <string>/Users/你的用户名/.cloudflared/config.yml</string>
    <string>run</string>
    <string>mini-agent</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>StandardOutPath</key><string>/tmp/cloudflared.log</string>
  <key>StandardErrorPath</key><string>/tmp/cloudflared.log</string>
</dict>
</plist>
EOF
launchctl load ~/Library/LaunchAgents/com.user.cloudflared.plist
```

> 路径 `/opt/homebrew/bin/cloudflared` 用 `which cloudflared` 的实际值替换（Intel 为 `/usr/local/bin/cloudflared`）。

**验证**：`launchctl list | grep cloudflared` 有 PID；`tail /tmp/cloudflared.log` 无 fatal。

### A10. 装 code-server + ttyd（见第 8 章），然后回到 A7 把两个子域也纳入 Access

---

## 7. 分支 B：国内 VPS + frp + Caddy（备选）

### B1. VPS 准备（2C2G 足够，阿里云/腾讯云轻量 ~¥10/月）

- 系统选 Ubuntu 22.04 LTS。
- 安全组：放行 **22（SSH，可限来源 IP）、80、443**；**7000（frp）可只对 mini 的出口 IP 放行，或改高端口+token 兜底**。
- DNS：把 `agent.域名`、`code.域名`、`shell.域名` 三条 A 记录都指向 VPS 公网 IP。

**验证**：`dig +short agent.你的域名` 返回 VPS IP。

### B2. VPS 装 frps + Caddy

```bash
# frp（以官方最新 release 为准，https://github.com/fatedier/frp/releases）
wget https://github.com/fatedier/frp/releases/download/v0.61.0/frp_0.61.0_linux_amd64.tar.gz
tar xzf frp_0.61.0_linux_amd64.tar.gz && sudo cp frp_0.61.0_linux_amd64/frps /usr/local/bin/

sudo apt update && sudo apt install -y caddy
```

> frp 版本号以官网当前 release 为准，示例 `v0.61.0` 可能过时（需实测确认）。

### B3. frps 配置

```bash
sudo tee /etc/frps.toml >/dev/null <<'EOF'
bindPort = 7000
auth.method = "token"
auth.token = "生成一段足够长的随机串"
EOF
sudo tee /etc/systemd/system/frps.service >/dev/null <<'EOF'
[Unit]
Description=frp server
After=network.target

[Service]
ExecStart=/usr/local/bin/frps -c /etc/frps.toml
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload && sudo systemctl enable --now frps
```

**验证**：`systemctl status frps` 显示 active；`ss -lntp | grep 7000` 监听中。

### B4. Caddy 配置（自动 HTTPS + basic_auth）

```bash
# 生成密码哈希
caddy hash-password --plaintext '你的强密码'
```

```bash
sudo tee /etc/caddy/Caddyfile >/dev/null <<'EOF'
(common) {
    encode gzip
    basic_auth {
        你的用户名 上面生成的bcrypt哈希
    }
}

agent.你的域名 {
    import common
    reverse_proxy 127.0.0.1:18789
}
code.你的域名 {
    import common
    reverse_proxy 127.0.0.1:8080
}
shell.你的域名 {
    import common
    reverse_proxy 127.0.0.1:7681
}
EOF
sudo systemctl reload caddy
```

> `basic_auth` 是 Caddy 2.8+ 的写法，老版本叫 `basicauth`，以 `caddy version` 为准（需实测确认）。

**验证**：`curl -sS -o /dev/null -w '%{http_code}\n' https://agent.你的域名/` 返回 401（未带 basic auth）或 200（带了）。

### B5. mini 装 frpc

```bash
brew install frpc   # 或从 frp release 下载对应 Darwin 包（需实测确认 brew formula 名）
```

### B6. frpc 配置

```bash
tee ~/.frpc.toml >/dev/null <<'EOF'
serverAddr = "VPS公网IP"
serverPort = 7000
auth.method = "token"
auth.token = "与frps一致"

[[proxies]]
name = "agent"
type = "http"
localIP = "127.0.0.1"
localPort = 18789
customDomains = ["agent.你的域名"]

[[proxies]]
name = "code"
type = "http"
localIP = "127.0.0.1"
localPort = 8080
customDomains = ["code.你的域名"]

[[proxies]]
name = "shell"
type = "http"
localIP = "127.0.0.1"
localPort = 7681
customDomains = ["shell.你的域名"]
EOF
```

### B7. frpc 开机自启（LaunchAgent）

仿照 A9 的 plist，把 `ProgramArguments` 换成：

```xml
<array>
  <string>/opt/homebrew/bin/frpc</string>
  <string>-c</string>
  <string>/Users/你的用户名/.frpc.toml</string>
</array>
```

**验证**：`launchctl list | grep frpc`；浏览器开 `https://code.你的域名/` 先过 basic_auth 再进 code-server。

---

## 8. code-server 与 ttyd（两分支共用）

### 8.1 code-server

```bash
brew install code-server
mkdir -p ~/.config/code-server
tee ~/.config/code-server/config.yaml >/dev/null <<'EOF'
bind-addr: 127.0.0.1:8080
auth: none
cert: false
EOF
```

> 安全姿势：code-server **只绑 127.0.0.1**，鉴权完全交给 Cloudflare Access / Caddy basic_auth，因此 `auth: none`。若想纵深防御，改 `auth: password` + `hashed-password`（用 argon2 生成，见 code-server 官方文档；`hashed-password` 键名需实测确认）。

**验证**：`curl -sS http://127.0.0.1:8080/` 在 mini 本机有响应，外网直连 8080 不通（`nc -zv 公网IP 8080` 失败）。

### 8.2 code-server 开机自启

仿照 A9 plist，`ProgramArguments`：

```xml
<array>
  <string>/opt/homebrew/bin/code-server</string>
  <string>--config</string>
  <string>/Users/你的用户名/.config/code-server/config.yaml</string>
</array>
```

### 8.3 ttyd

```bash
brew install ttyd
# 只绑 127.0.0.1，登录 shell，-W 可写
ttyd -i 127.0.0.1 -p 7681 -W bash -l
```

**验证**：`curl -sS http://127.0.0.1:7681/` 返回 ttyd 页面骨架。

### 8.4 ttyd 开机自启

仿照 A9 plist，`ProgramArguments`：

```xml
<array>
  <string>/opt/homebrew/bin/ttyd</string>
  <string>-i</string><string>127.0.0.1</string>
  <string>-p</string><string>7681</string>
  <string>-W</string>
  <string>bash</string>
  <string>-l</string>
</array>
```

> 三个 LaunchAgent 的 Label 分别为 `com.user.cloudflared` / `com.user.code-server` / `com.user.ttyd`（分支 B 把 cloudflared 换成 frpc）。全部 `KeepAlive=true`、`RunAtLoad=true`。

---

## 9. 端到端验证清单

| 场景 | 操作 | 期望 |
|---|---|---|
| 公司 MacBook 浏览器 | 开 `https://agent.域名/` | Access 登录页 → Control UI |
| 公司 MacBook 写代码 | 开 `https://code.域名/` | Access → 完整 VS Code，能建文件、开终端 |
| 公司 MacBook 敲命令 | 开 `https://shell.域名/` | Access → 网页终端，能 `tmux` |
| iPhone | Telegram 发指令 | Agent 正常响应（走 mini 的 Telegram Bot） |
| 端口边界 | `lsof -nP -iTCP:18789 -sTCP:LISTEN` | 只见 `127.0.0.1`，绝无 `0.0.0.0` |
| 公网扫描 | 外部 `nc -zv mini公网出口 22/8080/7681` | 全不通 |
| 断电自愈 | 拔电重启 | 自动登录后三服务 + 隧道全部自动拉起 |

---

## 10. 故障排查表

| 现象 | 可能原因 | 处理 |
|---|---|---|
| 502 Bad Gateway | 后端服务没起 / loopback 端口错 | `launchctl list` 查三个服务；`curl 127.0.0.1:端口` 本地探活 |
| Access 登录后仍进不去 OpenClaw | 头没被信任 / 配置没生效 | 核对 5.3 的 `userHeader`/`requiredHeaders`/`allowLoopback`；`openclaw gateway restart`；看网关日志 |
| `curl https://agent.域名` 超时 | DNS 未生效 / 隧道没起 | `cloudflared tunnel list`；`dig` 查 CNAME；`tail /tmp/cloudflared.log` |
| ttyd 连上即断 | WebSocket 被中间层截断 | 确认 cloudflared / Caddy 未禁用 websocket（两者默认支持）；ttyd 用最新版 |
| 证书续期失败（分支 B） | 80 端口被占 / 域名解析错 | `systemctl status caddy`；确认 80/443 放行、A 记录指向 VPS |
| mini 掉线 | 睡眠 / 断电没自启 | 核对 4.1 `pmset`；确认自动登录已开；查 `/tmp/*.log` |
| CF 国内慢 | 线路波动 | 叠加分支 B（国内 VPS）做双通道，或换优选 IP（进阶） |

---

## 11. 回滚方案

```bash
# 停并卸载 launchd 服务
launchctl unload ~/Library/LaunchAgents/com.user.cloudflared.plist
launchctl unload ~/Library/LaunchAgents/com.user.code-server.plist
launchctl unload ~/Library/LaunchAgents/com.user.ttyd.plist
rm -f ~/Library/LaunchAgents/com.user.{cloudflared,code-server,ttyd}.plist

# 卸载组件
brew uninstall cloudflared code-server ttyd   # 分支 B：frpc

# 删除隧道（分支 A）
cloudflared tunnel delete mini-agent

# 分支 B VPS 侧
sudo systemctl disable --now frps caddy
sudo apt remove -y frps caddy

# 恢复能源设置
sudo pmset -a sleep 1 disksleep 10 womp 0 autorestart 0

# 关闭远程登录
sudo systemsetup -setremotelogin off
```

---

## 12. 安全底线（必须遵守）

1. **绝不暴露 SSH 22 到公网**；SSH 仅密钥、仅内网/Tailscale。
2. **绝不裸奔 code-server/ttyd**：必须藏在 Cloudflare Access 或 Caddy basic_auth 之后，且自身只绑 127.0.0.1。
3. **不用 Tailscale Funnel 裸奔**：若用 Funnel，必须配密码（`gateway.auth.mode: password`）。
4. **Access 策略最小化**：只允许你自己的邮箱/身份提供方，不要用「任何人可访问」。
5. **Token 轮换**：定期换 OpenClaw gateway token、frp token、Cloudflare tunnel 凭据（`cloudflared tunnel token` 可重新导出）。
6. **失败登录告警**：Cloudflare Access 有访问日志，定期看一眼异常登录；Caddy 开 access log 排查。
7. **本机可信**：`trusted-proxy` 不验 JWT 签名，不要在 mini 上跑不可信代码。

---

## 13. 需实测确认清单

1. `/etc/ssh/sshd_config.d/*` drop-in 是否被 macOS 当前版本加载。
2. Cloudflare Access 的 `*.你的域名` 通配应用是否覆盖多个子域（否则建三个独立应用）。
3. `cloudflared service install` 在 macOS 的 plist 路径与配置目录（本 runbook 用自写 LaunchAgent 规避）。
4. frp 当前 release 版本号与 TOML 配置键名（0.52+ 为 TOML）。
5. Caddy `basic_auth` vs `basicauth`（取决于 Caddy 版本 ≥2.8）。
6. code-server `hashed-password` 键名与 `auth: none` 行为（当前版本）。
7. `brew install frpc` 是否存在该 formula，否则用 frp 官方 Darwin 包。
8. 分支 A 与分支 B 同时运行时的端口/DNS 冲突（建议二选一，不并存）。

---

## 14. 参考文档（本机官方 docs）

- `gateway/cloudflare-access.md` — Cloudflare Tunnel + Access + trusted-proxy
- `gateway/tailscale.md` — Tailscale Serve/Funnel 与鉴权模式
- `gateway/stable-https-url.md` — Serve 落地步骤与排障
- `gateway/remote.md` — 远程访问拓扑总览
- `gateway/portals.md` — 应用预览私网 ingress（本方案用子域，不涉及）
- `web/control-ui/connect-and-pair.md` — 浏览器/客户端连接与配对
- `platforms/mac/remote.md` — macOS App 远程控制模式
- `platforms/ios.md` — iOS App 连接（可选增强）

---

---

## 附录 A：在 mini 上使用 Codex（编程 Agent）

> 目标：让 mini 上的 Codex 成为你的「远程编程分身」——你从 Telegram 或公司浏览器下指令，Codex 在 mini 上改代码、跑测试。
> 前置：mini 上 OpenClaw 已按第 5 章装好。两条路线可并存。

### A.1 两条路线

| 路线 | 形态 | 你的入口 | 适合 |
|---|---|---|---|
| **甲：OpenClaw 原生 Codex harness（推荐）** | OpenClaw 直接驱动 Codex app-server | Telegram 发 `/codex ...` 或直接对话 | 异步派活、手机下指令 |
| **乙：纯 Codex CLI + tmux + ttyd** | 原生 Codex TUI 常驻 tmux | 公司浏览器开 `https://shell.域名/` | 想要原生交互手感 |

### A.2 路线甲：OpenClaw 原生 Codex harness

```bash
# 1) 安装官方 codex 插件
openclaw plugins install @openclaw/codex

# 2) 用 OpenAI 账号登录（OAuth）
openclaw models auth login --provider openai
```

**启用插件并指定 OpenAI 模型**（`~/.openclaw/openclaw.json5`）：

```json5
{
  plugins: {
    allow: ["codex"],
    entries: { codex: { enabled: true } },
  },
  agents: {
    defaults: { model: "openai/gpt-6-astra" },  // 以你账号实际可用模型为准
  },
}
```

> 若配置用了 `plugins.allow` 白名单，务必把 `codex` 加进去。
> 改完配置后，已有会话需 `/new` 或 `/reset` 才生效。

**验证**：

```text
/status      → 应显示 Runtime: OpenAI Codex
/codex status
/codex models
/codex binding
```

命令行侧核对托管 app-server：

```bash
openclaw doctor --lint --only codex/managed-app-server --json
```

**从手机 / 公司浏览器指挥**（在 Telegram 或 Control UI 聊天里发）：

| 想做的事 | 命令 |
|---|---|
| 把当前对话绑到某个 Codex 线程 | `/codex bind [thread-id] [--cwd 路径] [--model 模型]` |
| 恢复已有线程 | `/codex resume <thread-id>` |
| 列出线程 | `/codex threads [过滤]` |
| 换模型 / 快模式 / 权限 | `/codex model <模型>`、`/codex fast`、`/codex permissions [default\|yolo\|status]` |
| 停止 / 中途纠偏 | `/codex stop`、`/codex steer <文字>` |
| 解绑 | `/codex detach`（别名 `/codex unbind`） |

> `/codex` 子命令随版本变化，空发 `/codex` 看当前帮助为准。

### A.3 路线乙：Codex CLI + tmux + ttyd

```bash
# 1) 安装 Codex CLI（以 OpenAI 官方安装方式为准，npm 示例）
npm i -g @openai/codex
codex --version

# 2) 登录
codex login

# 3) 常驻 tmux 会话（掉线不丢）
tmux new -As codex

# 4) 在 tmux 里跑
codex
```

公司浏览器开 `https://shell.域名/` → 自动进 ttyd → `tmux attach -t codex` → 就是完整的 Codex TUI。

> 也可让 ttyd 启动即 attach：`ttyd -i 127.0.0.1 -p 7681 -W tmux new -As codex`

### A.4 衔接与注意

1. **鉴权分离**：Codex 走 OpenAI 账号（OAuth）或 API key，与 OpenClaw 的 gateway 鉴权是两回事。
2. **managed app-server**：OpenClaw 默认随插件管 `@openai/codex 0.160.0`；若你另装 Codex 桌面/CLI 版本，需 ≥ `0.149.0`（低版本会告警）。
3. **安全**：`yolo`（自动执行）模式慎用，默认用 `default` 权限，重要操作走审批。
4. **共存**：路线甲适合异步派活，路线乙适合盯屏调试；与 code-server（你自己写）共享同一份代码。
5. **需实测确认**：`openclaw plugins install @openclaw/codex` 与你装的 OpenClaw 版本是否兼容；`/codex` 具体子命令以版本输出为准。

---

> 本 runbook 覆盖两条分支、加固、常驻、验证、排障、回滚与安全底线。先落分支 A，跑通后再按需叠加分支 B。Codex 集成见附录 A。
