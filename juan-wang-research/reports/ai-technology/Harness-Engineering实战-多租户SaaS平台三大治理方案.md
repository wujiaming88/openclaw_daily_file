# Harness Engineering 实战：多租户 SaaS 平台三大治理方案

> 基于 Harness Engineering 方法论，解决 OpenClaw 多租户 SaaS 平台的三个核心问题：
> 插件准入、权限管控、版本验证。

---

## 核心思路：用机械约束替代人肉检查

Harness Engineering 的第一原则：**不要指望人不犯错，要让环境不允许犯错。**

| 传统做法 | Harness Engineering 做法 |
|---------|------------------------|
| 写文档告诉三方团队"请测试后再提交插件" | CI Pipeline 自动拦截不合规插件 |
| 写 Wiki 告诉用户"不要删除这个文件" | 文件系统只读挂载 + tool policy 禁止删除 |
| 手动测试新版本，感觉没问题就推 | 自动化验证套件 + 灰度发布 + 自动回滚 |

---

## 问题一：插件准入——三方插件无准入检验

### 1.1 现状分析

你们的插件来自三方团队（飞书 OAPI、DingTalk、omni-shield、memory-lancedb-ultra、wecom 等），当前流程：

```
三方开发 → 丢给你们 → 直接集成 → 用户环境里跑
```

**风险**：
- 插件 tool schema 不兼容某些模型（你刚遇到的 doubao `args` type 数组问题）
- 插件注册了过多工具，超出 token 预算
- 插件引入安全漏洞（未经审计的 exec、fs 操作）
- 插件版本更新后与现有 OpenClaw 版本不兼容

### 1.2 Harness 方案：三层准入门禁

```
三方提交插件
    │
    ▼
┌─────────────────────────────────────────────┐
│  Layer 1: 静态分析门禁（CI 自动化，0 人工）     │
│                                              │
│  ✓ JSON Schema 验证（tool definitions 合规）  │
│  ✓ 安全扫描（无 eval、无 fs 越界、无 env 泄露）  │
│  ✓ Token 预算检查（工具数量 × 平均 schema 大小）│
│  ✓ 模型兼容性检查（schema 降级测试）            │
└─────────────────┬───────────────────────────┘
                  │ 通过
                  ▼
┌─────────────────────────────────────────────┐
│  Layer 2: 运行时验证（沙箱环境，0 人工）        │
│                                              │
│  ✓ 隔离 Gateway 加载插件，不崩溃               │
│  ✓ 向每个目标模型发一轮对话，工具调用不报错       │
│  ✓ 插件注册的工具数量 ≤ 配额                   │
│  ✓ 内存/CPU 使用在阈值内                      │
└─────────────────┬───────────────────────────┘
                  │ 通过
                  ▼
┌─────────────────────────────────────────────┐
│  Layer 3: 灰度验证（内部租户，人工观察）        │
│                                              │
│  ✓ 内部测试租户先跑 24h                       │
│  ✓ 监控错误率、响应时间                        │
│  ✓ 无异常 → 推全量                            │
└─────────────────────────────────────────────┘
```

### 1.3 Layer 1 实现：静态分析脚本

```bash
#!/bin/bash
# plugin-gate.sh — 插件准入静态检查
# 用法: ./plugin-gate.sh /path/to/plugin-dir

PLUGIN_DIR="$1"
ERRORS=0

echo "=== 插件准入检查: $(basename $PLUGIN_DIR) ==="

# 1. 检查 tool schema 兼容性（核心：拦截 type 数组语法）
echo "[1/5] Schema 兼容性检查..."
if grep -r '"type"\s*:\s*\[' "$PLUGIN_DIR" --include="*.js" --include="*.ts" --include="*.json" | grep -v node_modules; then
    echo "  ❌ 发现 type 数组语法（如 \"type\": [\"string\", \"null\"]）"
    echo "     → 不兼容 Ark/豆包等国产模型"
    echo "     → 修复：改为单一类型 + nullable/optional 标记"
    ERRORS=$((ERRORS + 1))
else
    echo "  ✅ 无 type 数组语法"
fi

# 2. 检查工具数量
echo "[2/5] 工具数量检查..."
TOOL_COUNT=$(grep -r 'registerTool\|name:.*tool\|"name"' "$PLUGIN_DIR" --include="*.js" --include="*.ts" | grep -v node_modules | wc -l)
if [ "$TOOL_COUNT" -gt 20 ]; then
    echo "  ❌ 注册工具数: $TOOL_COUNT（超过 20 个限额）"
    echo "     → 工具过多会消耗 token 预算，影响上下文质量"
    ERRORS=$((ERRORS + 1))
else
    echo "  ✅ 工具数: $TOOL_COUNT"
fi

# 3. 安全扫描
echo "[3/5] 安全扫描..."
DANGEROUS_PATTERNS=(
    'child_process'
    'eval('
    'Function('
    'process\.env'
    'fs\.writeFileSync.*\/etc'
    'fs\.unlinkSync'
    'require.*child_process'
)
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if grep -r "$pattern" "$PLUGIN_DIR" --include="*.js" --include="*.ts" | grep -v node_modules | head -1 > /dev/null 2>&1; then
        echo "  ⚠️  发现敏感模式: $pattern"
        # 不一定是错误，但标记 review
    fi
done
echo "  ✅ 安全扫描完成"

# 4. 依赖检查
echo "[4/5] 依赖检查..."
if [ -f "$PLUGIN_DIR/package.json" ]; then
    DEP_COUNT=$(cat "$PLUGIN_DIR/package.json" | grep -c '"dependencies"' || echo 0)
    echo "  ✅ package.json 存在"
else
    echo "  ⚠️  无 package.json"
fi

# 5. 版本兼容声明
echo "[5/5] 版本兼容声明..."
if grep -r 'openclaw\|peerDependencies' "$PLUGIN_DIR/package.json" 2>/dev/null | grep -q 'openclaw'; then
    echo "  ✅ 声明了 OpenClaw 版本兼容范围"
else
    echo "  ⚠️  未声明 OpenClaw 版本兼容范围（建议添加 peerDependencies）"
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "❌ 准入失败: $ERRORS 个阻断问题"
    exit 1
else
    echo "✅ 静态检查通过"
    exit 0
fi
```

### 1.4 Layer 2 实现：运行时兼容性矩阵测试

```bash
#!/bin/bash
# plugin-runtime-test.sh — 插件运行时兼容性测试
# 在隔离环境中加载插件，向每个目标模型发送测试消息

PLUGIN_DIR="$1"
TEST_MODELS=(
    "ark/doubao-seed-2-0-mini-260215"
    "anthropic/claude-haiku-3-5"
    "openai/gpt-4o-mini"
    # 添加你平台支持的所有模型
)

OPENCLAW_TEST_DIR=$(mktemp -d)
echo "=== 运行时兼容性测试 ==="
echo "测试目录: $OPENCLAW_TEST_DIR"

# 1. 创建最小配置
cat > "$OPENCLAW_TEST_DIR/openclaw.json" << 'EOF'
{
  "gateway": { "auth": { "mode": "token", "token": "test-token" } },
  "plugins": { "allow": ["$PLUGIN_DIR"] },
  "agents": { "defaults": { "model": { "primary": "MODEL_PLACEHOLDER" } } }
}
EOF

# 2. 对每个模型测试工具注册
for model in "${TEST_MODELS[@]}"; do
    echo ""
    echo "--- 测试模型: $model ---"
    
    # 替换模型配置
    sed "s|MODEL_PLACEHOLDER|$model|g" "$OPENCLAW_TEST_DIR/openclaw.json" > "$OPENCLAW_TEST_DIR/openclaw-test.json"
    
    # 运行单轮测试（agent 模式，不启动 gateway）
    RESULT=$(OPENCLAW_CONFIG_PATH="$OPENCLAW_TEST_DIR/openclaw-test.json" \
        openclaw agent --prompt "你好，请列出你可以使用的工具" \
        --timeout 30 2>&1)
    
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "  ✅ $model 兼容"
    else
        # 检查是否是 schema 兼容问题
        if echo "$RESULT" | grep -q "decoding guidance\|Invalid.*type\|list of types"; then
            echo "  ❌ $model Schema 不兼容"
            echo "     错误: $(echo "$RESULT" | grep -o 'Invalid.*types[^"]*')"
        else
            echo "  ⚠️  $model 测试失败（非 schema 问题）"
            echo "     错误: $(echo "$RESULT" | tail -1)"
        fi
    fi
done

# 清理
rm -rf "$OPENCLAW_TEST_DIR"
```

### 1.5 集成到 CI/CD

```yaml
# .github/workflows/plugin-gate.yml
name: Plugin Admission Gate

on:
  pull_request:
    paths: ['plugins/**']

jobs:
  static-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Static Analysis
        run: ./scripts/plugin-gate.sh plugins/${{ github.event.pull_request.title }}
      
  runtime-check:
    needs: static-check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install OpenClaw
        run: npm install -g openclaw@${{ env.OPENCLAW_VERSION }}
      - name: Runtime Compatibility
        run: ./scripts/plugin-runtime-test.sh plugins/${{ github.event.pull_request.title }}
        env:
          ARK_API_KEY: ${{ secrets.ARK_API_KEY }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

---

## 问题二：权限管控——用户实例 root 运行，误操作致不可用

### 2.1 现状分析

```
用户创建 OpenClaw 实例
    → 实例以 root 运行
    → 用户（非技术）对话中触发 exec
    → Agent 执行了 rm、chmod、apt 等命令
    → 实例不可用
```

**OpenClaw 的安全模型前提**：假设每个 Gateway 只有一个受信操作者。在你的 SaaS 场景中，用户既是"操作者"又是"不受信的终端用户"——这是冲突的。

### 2.2 Harness 方案：四层防护体系

核心思路：**不是限制用户的行为，而是限制 Agent 能做什么。**

```
用户发消息
    │
    ▼
┌─────────────────────────────────────┐
│  Layer 1: Tool Policy（工具策略）     │  ← 决定 Agent 能用什么工具
│  deny: [exec, process, elevated]     │
│  allow: [read, web_search, message]  │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Layer 2: Sandbox（沙箱隔离）        │  ← Agent 执行被隔离在容器中
│  mode: all, workspace: ro            │
│  network: none                       │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Layer 3: Exec Approval（执行审批）   │  ← 高风险操作需用户确认
│  ask: always                         │
│  elevated: deny                      │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│  Layer 4: OS-Level（操作系统层）      │  ← 即使前三层全被绕过
│  非 root 用户 + 文件系统保护          │
└─────────────────────────────────────┘
```

### 2.3 Layer 1：租户级 Tool Policy 模板

根据用户类型，预设三档 Tool Policy：

```json5
// === 安全模板：非技术用户（默认）===
{
  tools: {
    // 白名单模式：只允许列出的工具
    allow: [
      "read",           // 读文件（安全）
      "web_search",     // 搜索（安全）
      "web_fetch",      // 获取网页（安全）
      "message",        // 发消息（安全）
      "tts",            // 语音（安全）
      "memory_search",  // 记忆搜索（安全）
      "memory_get"      // 记忆读取（安全）
    ],
    // 显式禁止危险工具
    deny: [
      "exec",           // ← 这就是用户"误操作"的根源
      "process",        // 后台进程管理
      "write",          // 写文件（可能破坏配置）
      "edit",           // 编辑文件（可能破坏配置）
      "browser",        // 浏览器控制
      "canvas",         // Canvas 渲染
      "group:elevated", // 提权操作
      "group:runtime",  // 运行时操作
      "group:nodes"     // 节点操作
    ],
    exec: {
      elevated: { enabled: false }  // 彻底禁止提权
    }
  }
}
```

```json5
// === 标准模板：技术用户 ===
{
  tools: {
    allow: [
      "read", "write", "edit",        // 文件操作
      "exec",                          // 命令执行（受限）
      "process",                       // 进程管理
      "web_search", "web_fetch",       // 搜索
      "message", "tts",               // 通讯
      "memory_search", "memory_get",   // 记忆
      "sessions_spawn", "sessions_list" // 子 Agent
    ],
    exec: {
      ask: "always",                   // 每次执行都要确认
      elevated: { enabled: false },    // 禁止提权
      security: "allowlist",           // 只允许安全命令
      safeBins: [                      // 安全命令白名单
        "ls", "cat", "grep", "find", "head", "tail",
        "wc", "sort", "uniq", "jq", "curl"
      ]
    }
  }
}
```

```json5
// === 高级模板：开发者用户 ===
{
  tools: {
    // 不设 deny，走默认
    exec: {
      ask: "on-miss",                 // 不在白名单的才问
      elevated: { enabled: false },   // 仍然禁止提权
      safeBins: [
        "ls", "cat", "grep", "find", "head", "tail",
        "wc", "sort", "uniq", "jq", "curl",
        "git", "npm", "node", "python3", "pip"
      ]
    }
  },
  sandbox: {
    mode: "all",                      // 全部 session 沙箱化
    workspace: "rw",                  // 可读写工作区
    network: "bridge"                 // 允许网络
  }
}
```

### 2.4 Layer 2：Docker 沙箱强制启用

```json5
// 每个租户实例的 openclaw.json
{
  sandbox: {
    enabled: true,
    mode: "all",              // 所有 session 都在沙箱中
    scope: "session",         // 每个 session 独立容器
    workspace: "rw",          // 工作区可读写
    network: "none",          // 默认禁止网络
    image: "your-saas/openclaw-sandbox:latest",  // 自定义镜像
    docker: {
      binds: [
        // 只挂载必要目录，只读
        "/data/tenants/${TENANT_ID}/workspace:/workspace:rw",
        "/data/shared/skills:/skills:ro"
      ]
    }
  }
}
```

### 2.5 Layer 4：OS 级保护

```bash
#!/bin/bash
# provision-tenant.sh — 租户实例创建脚本
# 每个租户一个独立 Linux 用户 + 隔离目录

TENANT_ID="$1"

# 1. 创建非 root 用户
useradd -m -s /bin/bash "oc-${TENANT_ID}"

# 2. 创建隔离目录结构
TENANT_HOME="/data/tenants/${TENANT_ID}"
mkdir -p "${TENANT_HOME}"/{config,workspace,credentials,logs,state}

# 3. 设置权限（非 root 运行）
chown -R "oc-${TENANT_ID}:oc-${TENANT_ID}" "${TENANT_HOME}"
chmod 700 "${TENANT_HOME}/credentials"
chmod 755 "${TENANT_HOME}/workspace"

# 4. 保护关键文件（即使 Agent 有 write 权限也改不了）
# openclaw.json 由平台管理，租户只读
cp /data/templates/tenant-config.json "${TENANT_HOME}/config/openclaw.json"
chown root:root "${TENANT_HOME}/config/openclaw.json"
chmod 444 "${TENANT_HOME}/config/openclaw.json"  # 只读

# 5. 生成 systemd service（以租户用户身份运行）
cat > "/etc/systemd/system/openclaw-${TENANT_ID}.service" << EOF
[Unit]
Description=OpenClaw Gateway for tenant ${TENANT_ID}
After=network.target

[Service]
Type=simple
User=oc-${TENANT_ID}
Group=oc-${TENANT_ID}
WorkingDirectory=${TENANT_HOME}/workspace
Environment=OPENCLAW_CONFIG_PATH=${TENANT_HOME}/config/openclaw.json
Environment=OPENCLAW_STATE_DIR=${TENANT_HOME}/state
ExecStart=/usr/local/bin/openclaw gateway --port ${TENANT_PORT}
Restart=on-failure
RestartSec=5

# 系统级安全限制
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=${TENANT_HOME}
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# 6. 启动
systemctl daemon-reload
systemctl enable "openclaw-${TENANT_ID}"
systemctl start "openclaw-${TENANT_ID}"

echo "✅ 租户 ${TENANT_ID} 实例已创建"
echo "   用户: oc-${TENANT_ID}"
echo "   端口: ${TENANT_PORT}"
echo "   工作区: ${TENANT_HOME}/workspace"
```

### 2.6 误操作防护矩阵

| 误操作场景 | 无防护时 | 加防护后 |
|-----------|---------|---------|
| 用户说"帮我清理磁盘" → Agent 执行 `rm -rf /` | 系统崩溃 | Tool Policy 禁止 exec / safeBins 不含 rm / 沙箱隔离 |
| 用户说"修改配置" → Agent 编辑 openclaw.json | 配置损坏，Gateway 无法启动 | 配置文件 root 只读（chmod 444） |
| 用户说"安装个插件" → Agent 执行 npm install | 引入恶意包 | exec deny + 沙箱无网络 |
| 用户说"看看密码" → Agent 读取 credentials | 凭证泄露 | credentials 目录 700 权限 + 工作区隔离 |
| Agent 自主行为：尝试修改 system prompt | 行为异变 | AGENTS.md/SOUL.md 由平台管理，只读 |

---

## 问题三：版本验证——无法在推送前验证 OpenClaw 新版本

### 3.1 现状分析

```
OpenClaw 发布新版本
    → 你不知道是否兼容你的插件、配置、模型
    → 要么不升级（落后），要么硬升（可能出问题）
    → 出了问题用户先发现
```

### 3.2 Harness 方案：三阶段验证管线

```
新版本发布
    │
    ▼
┌─────────────────────────────────────────────┐
│  Stage 1: 自动化兼容性测试（CI，无人值守）     │
│                                              │
│  ① 配置兼容性：openclaw doctor --fix --dry-run│
│  ② 启动测试：Gateway 能否正常启动              │
│  ③ 插件加载：所有插件能否正常注册               │
│  ④ 模型连通：每个模型能否正常对话               │
│  ⑤ 工具调用：核心工具 schema 兼容              │
│  ⑥ 渠道连通：飞书/钉钉/微信能否收发消息        │
└─────────────────┬───────────────────────────┘
                  │ 全部通过
                  ▼
┌─────────────────────────────────────────────┐
│  Stage 2: 金丝雀部署（内部租户，24h 观察）     │
│                                              │
│  ① 升级 1 个内部测试租户                      │
│  ② 监控：错误率、响应时间、token 用量          │
│  ③ 24h 无异常 → 进入 Stage 3                 │
│  ④ 有异常 → 自动回滚 + 告警                   │
└─────────────────┬───────────────────────────┘
                  │ 24h 无异常
                  ▼
┌─────────────────────────────────────────────┐
│  Stage 3: 灰度推送（分批升级用户租户）         │
│                                              │
│  ① 10% 租户升级 → 观察 4h                    │
│  ② 50% 租户升级 → 观察 4h                    │
│  ③ 100% 租户升级                              │
│  每阶段：错误率 > 阈值自动暂停                 │
└─────────────────────────────────────────────┘
```

### 3.3 Stage 1 实现：自动化验证套件

```bash
#!/bin/bash
# version-validate.sh — OpenClaw 新版本自动化验证
# 用法: ./version-validate.sh 2026.3.28

TARGET_VERSION="$1"
TEST_DIR=$(mktemp -d)
RESULTS_FILE="${TEST_DIR}/results.json"
PASS=0
FAIL=0

echo "=========================================="
echo "OpenClaw 版本验证: v${TARGET_VERSION}"
echo "=========================================="

# ---- 准备测试环境 ----
echo ""
echo "📦 安装测试版本..."
npm install -g "openclaw@${TARGET_VERSION}" --prefix "${TEST_DIR}" 2>&1
TEST_OPENCLAW="${TEST_DIR}/bin/openclaw"

# ---- Test 1: 版本确认 ----
echo ""
echo "--- Test 1/8: 版本确认 ---"
INSTALLED_VERSION=$($TEST_OPENCLAW --version 2>/dev/null | grep -oP '[\d.]+')
if [[ "$INSTALLED_VERSION" == *"$TARGET_VERSION"* ]]; then
    echo "  ✅ 版本: $INSTALLED_VERSION"
    PASS=$((PASS + 1))
else
    echo "  ❌ 版本不匹配: 期望 $TARGET_VERSION, 实际 $INSTALLED_VERSION"
    FAIL=$((FAIL + 1))
fi

# ---- Test 2: 配置兼容性 ----
echo ""
echo "--- Test 2/8: 配置兼容性 ---"
# 用你的生产配置模板测试
cp /data/templates/tenant-config.json "${TEST_DIR}/openclaw.json"
DOCTOR_OUTPUT=$(OPENCLAW_CONFIG_PATH="${TEST_DIR}/openclaw.json" \
    $TEST_OPENCLAW doctor 2>&1)

if echo "$DOCTOR_OUTPUT" | grep -q "error\|fatal\|breaking"; then
    echo "  ❌ 配置不兼容"
    echo "  $DOCTOR_OUTPUT" | grep -i "error\|breaking" | head -5
    FAIL=$((FAIL + 1))
else
    echo "  ✅ 配置兼容"
    PASS=$((PASS + 1))
fi

# ---- Test 3: Gateway 启动 ----
echo ""
echo "--- Test 3/8: Gateway 启动 ---"
OPENCLAW_CONFIG_PATH="${TEST_DIR}/openclaw.json" \
    timeout 15 $TEST_OPENCLAW gateway --port 19999 &
GW_PID=$!
sleep 10

if kill -0 $GW_PID 2>/dev/null; then
    echo "  ✅ Gateway 启动成功 (PID: $GW_PID)"
    PASS=$((PASS + 1))
else
    echo "  ❌ Gateway 启动失败"
    FAIL=$((FAIL + 1))
fi
kill $GW_PID 2>/dev/null
wait $GW_PID 2>/dev/null

# ---- Test 4: 插件加载 ----
echo ""
echo "--- Test 4/8: 插件加载 ---"
PLUGIN_ERRORS=$(OPENCLAW_CONFIG_PATH="${TEST_DIR}/openclaw.json" \
    timeout 15 $TEST_OPENCLAW gateway --port 19998 2>&1 | grep -i "plugin.*error\|plugin.*fail\|plugin.*crash")

if [ -z "$PLUGIN_ERRORS" ]; then
    echo "  ✅ 所有插件加载正常"
    PASS=$((PASS + 1))
else
    echo "  ❌ 插件加载异常:"
    echo "  $PLUGIN_ERRORS"
    FAIL=$((FAIL + 1))
fi

# ---- Test 5: 模型连通性 ----
echo ""
echo "--- Test 5/8: 模型连通性 ---"
MODELS=("ark/doubao-seed-2-0-mini-260215" "anthropic/claude-haiku-3-5")
for model in "${MODELS[@]}"; do
    RESULT=$(OPENCLAW_CONFIG_PATH="${TEST_DIR}/openclaw.json" \
        $TEST_OPENCLAW agent --model "$model" --prompt "回复OK" --timeout 30 2>&1)
    
    if echo "$RESULT" | grep -qi "ok\|好的\|收到"; then
        echo "  ✅ $model 连通"
    elif echo "$RESULT" | grep -qi "400\|decoding\|schema\|type"; then
        echo "  ❌ $model Schema 不兼容"
        FAIL=$((FAIL + 1))
        continue
    else
        echo "  ⚠️  $model 响应异常（可能是 API 限制）"
    fi
    PASS=$((PASS + 1))
done

# ---- Test 6: 核心工具调用 ----
echo ""
echo "--- Test 6/8: 核心工具调用 ---"
TOOL_TEST=$(OPENCLAW_CONFIG_PATH="${TEST_DIR}/openclaw.json" \
    $TEST_OPENCLAW agent --prompt "请使用 read 工具读取 /etc/hostname 的内容" \
    --timeout 30 2>&1)

if echo "$TOOL_TEST" | grep -q "tool\|read\|result"; then
    echo "  ✅ 工具调用正常"
    PASS=$((PASS + 1))
else
    echo "  ⚠️  工具调用测试未确认"
fi

# ---- Test 7: Breaking Changes 检查 ----
echo ""
echo "--- Test 7/8: Breaking Changes 影响评估 ---"
RELEASE_NOTES=$(curl -s "https://api.github.com/repos/openclaw/openclaw/releases/tags/v${TARGET_VERSION}" | \
    python3 -c "import sys,json; print(json.load(sys.stdin).get('body',''))" 2>/dev/null)

BREAKING_COUNT=$(echo "$RELEASE_NOTES" | grep -ci "breaking")
if [ "$BREAKING_COUNT" -gt 0 ]; then
    echo "  ⚠️  发现 $BREAKING_COUNT 个 Breaking Changes，需人工评审:"
    echo "$RELEASE_NOTES" | grep -i -A2 "breaking" | head -10
else
    echo "  ✅ 无 Breaking Changes"
fi
PASS=$((PASS + 1))

# ---- Test 8: 性能基线 ----
echo ""
echo "--- Test 8/8: 响应时间基线 ---"
START_TIME=$(date +%s%N)
OPENCLAW_CONFIG_PATH="${TEST_DIR}/openclaw.json" \
    $TEST_OPENCLAW agent --prompt "你好" --timeout 30 2>&1 > /dev/null
END_TIME=$(date +%s%N)
LATENCY_MS=$(( (END_TIME - START_TIME) / 1000000 ))

if [ "$LATENCY_MS" -lt 30000 ]; then
    echo "  ✅ 响应时间: ${LATENCY_MS}ms"
    PASS=$((PASS + 1))
else
    echo "  ⚠️  响应时间偏高: ${LATENCY_MS}ms"
fi

# ---- 汇总 ----
echo ""
echo "=========================================="
TOTAL=$((PASS + FAIL))
echo "结果: ${PASS}/${TOTAL} 通过, ${FAIL} 失败"

if [ "$FAIL" -eq 0 ]; then
    echo "✅ 版本 v${TARGET_VERSION} 验证通过，可进入灰度阶段"
    exit 0
else
    echo "❌ 版本 v${TARGET_VERSION} 验证未通过，不建议升级"
    exit 1
fi

# 清理
rm -rf "$TEST_DIR"
```

### 3.4 Stage 2 & 3 实现：灰度升级编排

```bash
#!/bin/bash
# canary-upgrade.sh — 灰度升级编排
# 用法: ./canary-upgrade.sh 2026.3.28

TARGET_VERSION="$1"
TENANT_LIST="/data/config/tenants.txt"
ERROR_THRESHOLD=5  # 错误率阈值 (%)

echo "=== 灰度升级: v${TARGET_VERSION} ==="

# 阶段 1: 内部测试租户
echo ""
echo "--- Phase 1: 内部测试租户 ---"
INTERNAL_TENANTS=$(grep "^internal:" "$TENANT_LIST" | cut -d: -f2)
for tenant in $INTERNAL_TENANTS; do
    upgrade_tenant "$tenant" "$TARGET_VERSION"
done
echo "等待 24h 观察..."
sleep 86400  # 实际中用 cron job 替代
ERROR_RATE=$(get_error_rate "$INTERNAL_TENANTS" 24h)
if [ "$ERROR_RATE" -gt "$ERROR_THRESHOLD" ]; then
    echo "❌ 内部租户错误率 ${ERROR_RATE}% > ${ERROR_THRESHOLD}%"
    rollback_tenants "$INTERNAL_TENANTS"
    exit 1
fi

# 阶段 2: 10% 用户租户
echo ""
echo "--- Phase 2: 10% 用户租户 ---"
BATCH_1=$(grep "^user:" "$TENANT_LIST" | cut -d: -f2 | shuf | head -n $(( $(wc -l < "$TENANT_LIST") / 10 )))
for tenant in $BATCH_1; do
    upgrade_tenant "$tenant" "$TARGET_VERSION"
done
echo "等待 4h 观察..."
sleep 14400
ERROR_RATE=$(get_error_rate "$BATCH_1" 4h)
if [ "$ERROR_RATE" -gt "$ERROR_THRESHOLD" ]; then
    echo "❌ 10% 批次错误率 ${ERROR_RATE}% > ${ERROR_THRESHOLD}%，暂停升级"
    rollback_tenants "$BATCH_1"
    exit 1
fi

# 阶段 3: 全量
echo ""
echo "--- Phase 3: 全量升级 ---"
REMAINING=$(grep "^user:" "$TENANT_LIST" | cut -d: -f2 | grep -v -F "$BATCH_1")
for tenant in $REMAINING; do
    upgrade_tenant "$tenant" "$TARGET_VERSION"
done
echo "✅ 全量升级完成: v${TARGET_VERSION}"

# ---- 辅助函数 ----
upgrade_tenant() {
    local tenant_id="$1" version="$2"
    
    # 备份当前版本
    cp "/data/tenants/${tenant_id}/version" "/data/tenants/${tenant_id}/version.bak"
    
    # 升级
    systemctl stop "openclaw-${tenant_id}"
    echo "$version" > "/data/tenants/${tenant_id}/version"
    systemctl start "openclaw-${tenant_id}"
    
    # 等待健康检查
    sleep 5
    if ! systemctl is-active "openclaw-${tenant_id}" > /dev/null; then
        echo "  ⚠️  租户 ${tenant_id} 启动失败，自动回滚"
        rollback_tenant "$tenant_id"
    fi
}

rollback_tenant() {
    local tenant_id="$1"
    cp "/data/tenants/${tenant_id}/version.bak" "/data/tenants/${tenant_id}/version"
    systemctl restart "openclaw-${tenant_id}"
}
```

### 3.5 版本验证应该检查什么？完整检查清单

| 检查项 | 方法 | 阻断级别 |
|--------|------|---------|
| 配置 schema 兼容 | `openclaw doctor` | 🔴 阻断 |
| Gateway 启动 | 启动 + 健康检查 | 🔴 阻断 |
| 所有插件加载 | 启动日志扫描 | 🔴 阻断 |
| 目标模型连通 | 单轮对话测试 | 🔴 阻断 |
| 工具 schema 兼容 | 每模型工具调用 | 🔴 阻断 |
| 渠道收发消息 | 发送+接收测试 | 🟡 警告 |
| Breaking Changes | Release notes 解析 | 🟡 人工评审 |
| 响应时间基线 | 对比上版本 | 🟡 警告 |
| 内存/CPU 使用 | 24h 监控 | 🟡 警告 |
| Session 持久化 | 重启后 session 恢复 | 🔴 阻断 |
| 配置热重载 | 修改 config 后自动生效 | 🟡 警告 |

---

## 总结：三个问题的 Harness Engineering 对照

| 问题 | 传统做法 | Harness Engineering 做法 | 核心原则 |
|------|---------|------------------------|---------|
| 插件无准入 | 人工 review、口头约定 | CI 自动拦截（静态分析 + 运行时沙箱测试 + 模型兼容矩阵） | **机械不变量**：不能通过 CI 的就不能上线 |
| root 权限误操作 | 写文档"请不要删除文件" | Tool Policy + Sandbox + 只读配置 + 非 root 运行 | **最小权限**：Agent 只能做被允许的事 |
| 版本无法验证 | 手动测试、凭感觉 | 自动化验证套件 + 金丝雀部署 + 灰度推送 + 自动回滚 | **渐进式信任**：从 0 用户到 100% 分阶段验证 |

**记住 Harness Engineering 的核心**：

> "Agent isn't broken. Your harness is."
> 
> 不是用户在犯错，也不是插件团队在犯错，也不是新版本有问题——
> 是你的 Harness（运行环境）没有约束住这些行为。

---

*文档由 wairesearch (黄山) 研究整理 | 2026-03-30*
*基于 OpenClaw 源码分析 + Harness Engineering 方法论*
