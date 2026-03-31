#!/usr/bin/env bash
#
# memory-lancedb-ultra 侵入式性能埋点脚本
#
# 用法:
#   bash instrument.sh <plugin-dir>        # 注入埋点
#   bash instrument.sh <plugin-dir> --restore  # 还原
#   bash instrument.sh <plugin-dir> --status   # 查看状态
#
# 示例:
#   bash instrument.sh /path/to/memory-lancedb-ultra
#   bash instrument.sh /path/to/memory-lancedb-ultra --restore
#
# 埋点后的指标输出:
#   /tmp/openclaw/memory-perf-metrics.jsonl  (每次调用追加一行 JSON)
#
# 指标字段:
#   event: "recall" | "capture" | "embed" | "search" | "store"
#   total_ms, strip_ms, embed_ms, search_ms, format_ms
#   recall_count, injected_chars, memory_db_size
#   session_key, timestamp
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PLUGIN_DIR="${1:?用法: bash instrument.sh <plugin-dir> [--restore|--status]}"
ACTION="${2:-inject}"
BACKUP_MARKER="${PLUGIN_DIR}/.perf-instrumented"
METRICS_FILE="/tmp/openclaw/memory-perf-metrics.jsonl"

# ============================================================================
# 工具函数
# ============================================================================

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_step()  { echo -e "${CYAN}[STEP]${NC} $*"; }

check_plugin_dir() {
  if [[ ! -f "${PLUGIN_DIR}/index.ts" ]]; then
    log_error "找不到 ${PLUGIN_DIR}/index.ts，请确认插件目录正确"
    exit 1
  fi
  if [[ ! -f "${PLUGIN_DIR}/src/embeddings/embedder.ts" ]]; then
    log_error "找不到 embedder.ts，目录结构不符合预期"
    exit 1
  fi
}

# ============================================================================
# 还原
# ============================================================================

do_restore() {
  if [[ ! -f "${BACKUP_MARKER}" ]]; then
    log_warn "未检测到埋点标记，可能未曾注入"
    exit 0
  fi

  log_step "还原 index.ts"
  if [[ -f "${PLUGIN_DIR}/index.ts.bak" ]]; then
    mv "${PLUGIN_DIR}/index.ts.bak" "${PLUGIN_DIR}/index.ts"
  fi

  log_step "还原 embedder.ts"
  if [[ -f "${PLUGIN_DIR}/src/embeddings/embedder.ts.bak" ]]; then
    mv "${PLUGIN_DIR}/src/embeddings/embedder.ts.bak" "${PLUGIN_DIR}/src/embeddings/embedder.ts"
  fi

  log_step "删除埋点模块"
  rm -f "${PLUGIN_DIR}/src/perf-metrics.ts"

  rm -f "${BACKUP_MARKER}"
  log_info "✅ 已还原所有文件到原始状态"
}

# ============================================================================
# 状态检查
# ============================================================================

do_status() {
  if [[ -f "${BACKUP_MARKER}" ]]; then
    local ts
    ts=$(cat "${BACKUP_MARKER}")
    log_info "🔧 已注入埋点 (时间: ${ts})"
    
    if [[ -f "${METRICS_FILE}" ]]; then
      local lines
      lines=$(wc -l < "${METRICS_FILE}" 2>/dev/null || echo 0)
      log_info "📊 已收集 ${lines} 条指标 → ${METRICS_FILE}"
      
      if [[ ${lines} -gt 0 ]]; then
        echo ""
        echo "最近 5 条:"
        tail -5 "${METRICS_FILE}" | python3 -m json.tool 2>/dev/null || tail -5 "${METRICS_FILE}"
      fi
    else
      log_warn "尚无指标数据"
    fi
  else
    log_info "未注入埋点"
  fi
}

# ============================================================================
# 注入: 创建 perf-metrics.ts 模块
# ============================================================================

create_metrics_module() {
  log_step "创建 perf-metrics.ts 指标收集模块"

  cat > "${PLUGIN_DIR}/src/perf-metrics.ts" << 'METRICS_EOF'
/**
 * memory-lancedb-ultra 性能指标收集器
 * 
 * 自动生成 — 请勿手动编辑
 * 还原命令: bash instrument.sh <plugin-dir> --restore
 */

import fs from "node:fs/promises";
import path from "node:path";

const METRICS_DIR = "/tmp/openclaw";
const METRICS_FILE = path.join(METRICS_DIR, "memory-perf-metrics.jsonl");

// 高精度计时器
export function startTimer(): () => number {
  const start = process.hrtime.bigint();
  return () => Number(process.hrtime.bigint() - start) / 1e6; // → ms
}

// 全局计数器（进程生命周期内累积）
const counters = {
  embedCalls: 0,
  embedTotalMs: 0,
  searchCalls: 0,
  searchTotalMs: 0,
  storeCalls: 0,
  storeTotalMs: 0,
  recallCalls: 0,
  recallTotalMs: 0,
  captureCalls: 0,
  captureTotalMs: 0,
};

export function incrCounter(key: keyof typeof counters, value: number = 1): void {
  counters[key] += value;
}

export function getCounters(): typeof counters {
  return { ...counters };
}

// 写入指标（追加 JSONL）
export async function writeMetric(metric: Record<string, unknown>): Promise<void> {
  try {
    await fs.mkdir(METRICS_DIR, { recursive: true });

    const entry = {
      ...metric,
      _ts: new Date().toISOString(),
      _epoch_ms: Date.now(),
      _counters: getCounters(),
    };

    await fs.appendFile(METRICS_FILE, JSON.stringify(entry) + "\n", "utf8");
  } catch {
    // 指标写入失败不应影响业务
  }
}

// 便捷函数：记录 recall 指标
export async function recordRecallMetrics(data: {
  sessionKey?: string;
  stripMs: number;
  embedMs: number;
  searchMs: number;
  formatMs: number;
  totalMs: number;
  recallCount: number;
  injectedChars: number;
  memoryDbSize?: number;
  promptLength: number;
  cleanedPromptLength: number;
}): Promise<void> {
  incrCounter("recallCalls");
  incrCounter("recallTotalMs", data.totalMs);
  await writeMetric({ event: "recall", ...data });
}

// 便捷函数：记录 capture 指标
export async function recordCaptureMetrics(data: {
  sessionKey?: string;
  extractMs: number;
  filterMs: number;
  embedMs: number;
  dedupeMs: number;
  storeMs: number;
  totalMs: number;
  messagesScanned: number;
  textsExtracted: number;
  textsFiltered: number;
  stored: number;
  duplicatesSkipped: number;
}): Promise<void> {
  incrCounter("captureCalls");
  incrCounter("captureTotalMs", data.totalMs);
  await writeMetric({ event: "capture", ...data });
}

// 便捷函数：记录 embed 指标
export async function recordEmbedMetrics(data: {
  provider: string;
  inputChars: number;
  latencyMs: number;
  chunked: boolean;
  chunkCount?: number;
  retries: number;
  success: boolean;
  error?: string;
}): Promise<void> {
  incrCounter("embedCalls");
  incrCounter("embedTotalMs", data.latencyMs);
  await writeMetric({ event: "embed", ...data });
}

// 便捷函数：记录 search 指标
export async function recordSearchMetrics(data: {
  queryChars: number;
  limit: number;
  minScore: number;
  resultCount: number;
  latencyMs: number;
  topScore?: number;
  avgScore?: number;
}): Promise<void> {
  incrCounter("searchCalls");
  incrCounter("searchTotalMs", data.latencyMs);
  await writeMetric({ event: "search", ...data });
}

// 便捷函数：记录 store 指标
export async function recordStoreMetrics(data: {
  textChars: number;
  category: string;
  latencyMs: number;
  isDuplicate: boolean;
}): Promise<void> {
  incrCounter("storeCalls");
  incrCounter("storeTotalMs", data.latencyMs);
  await writeMetric({ event: "store", ...data });
}
METRICS_EOF
}

# ============================================================================
# 注入: 修补 index.ts
# ============================================================================

patch_index_ts() {
  log_step "修补 index.ts — 注入 recall/capture/search/store 埋点"

  cp "${PLUGIN_DIR}/index.ts" "${PLUGIN_DIR}/index.ts.bak"

  local FILE="${PLUGIN_DIR}/index.ts"

  # ---- 1. 在文件顶部 import 区添加 perf-metrics 导入 ----
  # 找到最后一个 import 行之后插入
  python3 << PYEOF
import re

with open("${FILE}", "r") as f:
    content = f.read()

# ===== 1. 添加 import =====
perf_import = '''import {
  startTimer,
  recordRecallMetrics,
  recordCaptureMetrics,
  recordSearchMetrics,
  recordStoreMetrics,
} from "./src/perf-metrics.js";
'''

# 在最后一个顶层 import 之后插入
# 找 "from" 结尾的 import 语句群的末尾
last_import_match = None
for m in re.finditer(r'^import .+from .+;$', content, re.MULTILINE):
    last_import_match = m

if last_import_match:
    insert_pos = last_import_match.end()
    content = content[:insert_pos] + "\n" + perf_import + content[insert_pos:]
else:
    content = perf_import + "\n" + content

# ===== 2. 修补 before_agent_start (Auto-Recall) =====
# 定位: api.on("before_agent_start", async (event, ctx) => {
#   if (!event.prompt || event.prompt.length < 5) { return; }
#   try {
#     const query = stripSystemMessage(event.prompt);

old_recall_block = '''      api.on("before_agent_start", async (event, ctx) => {
        if (!event.prompt || event.prompt.length < 5) {
          return;
        }

        try {
          const query = stripSystemMessage(event.prompt);
          const vector = await embeddings.embed(query);
          const results = await db.search(vector, 20, 0.3);'''

new_recall_block = '''      api.on("before_agent_start", async (event, ctx) => {
        if (!event.prompt || event.prompt.length < 5) {
          return;
        }

        try {
          const _perfTotal = startTimer();
          const _perfStrip = startTimer();
          const query = stripSystemMessage(event.prompt);
          const _stripMs = _perfStrip();

          const _perfEmbed = startTimer();
          const vector = await embeddings.embed(query);
          const _embedMs = _perfEmbed();

          const _perfSearch = startTimer();
          const results = await db.search(vector, 20, 0.3);
          const _searchMs = _perfSearch();'''

if old_recall_block in content:
    content = content.replace(old_recall_block, new_recall_block, 1)
    print("  ✅ Patched before_agent_start (entry)")
else:
    print("  ⚠️  未找到 before_agent_start 入口块，尝试宽松匹配...")

# 修补 recall 的返回点：在 return { prependContext: ... } 之前插入指标记录
old_recall_return = '''          return {
            prependContext: formatRelevantMemoriesContext(
              results.map((r) => ({ category: r.entry.category, text: r.entry.text })),
            ),
          };'''

new_recall_return = '''          const _perfFormat = startTimer();
          const _formattedContext = formatRelevantMemoriesContext(
            results.map((r) => ({ category: r.entry.category, text: r.entry.text })),
          );
          const _formatMs = _perfFormat();
          const _totalMs = _perfTotal();

          recordRecallMetrics({
            sessionKey: ctx.sessionKey,
            stripMs: _stripMs,
            embedMs: _embedMs,
            searchMs: _searchMs,
            formatMs: _formatMs,
            totalMs: _totalMs,
            recallCount: results.length,
            injectedChars: _formattedContext.length,
            promptLength: event.prompt.length,
            cleanedPromptLength: query.length,
          }).catch(() => {});

          return {
            prependContext: _formattedContext,
          };'''

if old_recall_return in content:
    content = content.replace(old_recall_return, new_recall_return, 1)
    print("  ✅ Patched before_agent_start (return)")
else:
    print("  ⚠️  未找到 recall return 块")

# 修补 recall 的空结果返回点
old_recall_empty = '''          if (results.length === 0) {
            return;
          }

          api.logger.info'''

new_recall_empty = '''          if (results.length === 0) {
            const _totalMs = _perfTotal();
            recordRecallMetrics({
              sessionKey: ctx.sessionKey,
              stripMs: _stripMs,
              embedMs: _embedMs,
              searchMs: _searchMs,
              formatMs: 0,
              totalMs: _totalMs,
              recallCount: 0,
              injectedChars: 0,
              promptLength: event.prompt.length,
              cleanedPromptLength: query.length,
            }).catch(() => {});
            return;
          }

          api.logger.info'''

if old_recall_empty in content:
    content = content.replace(old_recall_empty, new_recall_empty, 1)
    print("  ✅ Patched before_agent_start (empty result)")
else:
    print("  ⚠️  未找到 recall empty-result 块")


# ===== 3. 修补 agent_end (Auto-Capture) =====
old_capture_entry = '''      api.on("agent_end", async (event) => {
        if (!event.success || !event.messages || event.messages.length === 0) {
          return;
        }

        const messages = event.messages.slice(-20);

        try {'''

new_capture_entry = '''      api.on("agent_end", async (event) => {
        if (!event.success || !event.messages || event.messages.length === 0) {
          return;
        }

        const messages = event.messages.slice(-20);

        try {
          const _captureTotal = startTimer();
          const _captureExtract = startTimer();'''

if old_capture_entry in content:
    content = content.replace(old_capture_entry, new_capture_entry, 1)
    print("  ✅ Patched agent_end (entry)")
else:
    print("  ⚠️  未找到 agent_end 入口块")

# 修补 capture 的存储循环前
old_capture_loop = '''          const toCapture = sanitizedTexts.filter((text) => shouldCapture(text));
          if (toCapture.length === 0) {
            return;
          }

          // Store each capturable piece (limit to 3 per conversation)
          let stored = 0;'''

new_capture_loop = '''          const toCapture = sanitizedTexts.filter((text) => shouldCapture(text));
          const _extractMs = _captureExtract();

          if (toCapture.length === 0) {
            const _captureTotalMs = _captureTotal();
            recordCaptureMetrics({
              extractMs: _extractMs, filterMs: 0, embedMs: 0, dedupeMs: 0, storeMs: 0,
              totalMs: _captureTotalMs,
              messagesScanned: messages.length,
              textsExtracted: sanitizedTexts.length,
              textsFiltered: 0, stored: 0, duplicatesSkipped: 0,
            }).catch(() => {});
            return;
          }

          const _captureEmbed = startTimer();
          let _dedupeMs = 0;
          let _storeMs = 0;
          let _duplicatesSkipped = 0;

          // Store each capturable piece (limit to 3 per conversation)
          let stored = 0;'''

if old_capture_loop in content:
    content = content.replace(old_capture_loop, new_capture_loop, 1)
    print("  ✅ Patched agent_end (loop preamble)")
else:
    print("  ⚠️  未找到 capture loop 块")

# 修补 capture 的去重检查
old_capture_dedup = '''            // Check for duplicates (high similarity threshold)
            const existing = await db.search(vector, 1, 0.95);
            if (existing.length > 0) {
              continue;
            }

            await db.store({'''

new_capture_dedup = '''            // Check for duplicates (high similarity threshold)
            const _dedupeTimer = startTimer();
            const existing = await db.search(vector, 1, 0.95);
            _dedupeMs += _dedupeTimer();
            if (existing.length > 0) {
              _duplicatesSkipped++;
              continue;
            }

            const _storeTimer = startTimer();
            await db.store({'''

if old_capture_dedup in content:
    content = content.replace(old_capture_dedup, new_capture_dedup, 1)
    print("  ✅ Patched agent_end (dedup + store)")
else:
    print("  ⚠️  未找到 capture dedup 块")

# 修补 store 之后（闭合括号后加计时）
old_capture_store_end = '''            await db.store({
              text: textWithCreatedAt,
              vector,
              importance: 0.7,
              category,
              createdAt,
            });
            stored++;'''

new_capture_store_end = '''            await db.store({
              text: textWithCreatedAt,
              vector,
              importance: 0.7,
              category,
              createdAt,
            });
            _storeMs += _storeTimer();
            stored++;'''

if old_capture_store_end in content:
    content = content.replace(old_capture_store_end, new_capture_store_end, 1)
    print("  ✅ Patched agent_end (store timer)")
else:
    print("  ⚠️  未找到 capture store-end 块")

# 修补 capture 完成后的日志
old_capture_done = '''          if (stored > 0) {
            api.logger.info'''

new_capture_done = '''          const _embedMs = _captureEmbed();
          const _captureTotalMs = _captureTotal();
          recordCaptureMetrics({
            extractMs: _extractMs,
            filterMs: 0,
            embedMs: _embedMs,
            dedupeMs: _dedupeMs,
            storeMs: _storeMs,
            totalMs: _captureTotalMs,
            messagesScanned: messages.length,
            textsExtracted: sanitizedTexts.length,
            textsFiltered: toCapture.length,
            stored,
            duplicatesSkipped: _duplicatesSkipped,
          }).catch(() => {});

          if (stored > 0) {
            api.logger.info'''

if old_capture_done in content:
    content = content.replace(old_capture_done, new_capture_done, 1)
    print("  ✅ Patched agent_end (completion metrics)")
else:
    print("  ⚠️  未找到 capture done 块")

# ===== 4. 修补 MemoryDB.search() =====
old_search = '''  async search(vector: number[], limit = 20, minScore = 0.5): Promise<MemorySearchResult[]> {
    await this.ensureInitialized();

    const results = await this.table!.vectorSearch(vector).limit(limit).toArray();'''

new_search = '''  async search(vector: number[], limit = 20, minScore = 0.5): Promise<MemorySearchResult[]> {
    await this.ensureInitialized();

    const _searchTimer = startTimer();
    const results = await this.table!.vectorSearch(vector).limit(limit).toArray();'''

if old_search in content:
    content = content.replace(old_search, new_search, 1)
    print("  ✅ Patched MemoryDB.search (entry)")
else:
    print("  ⚠️  未找到 MemoryDB.search 块")

# search 返回前记录
old_search_return = '''    return mapped.filter((r) => r.score >= minScore);
  }

  private assertValidId'''

new_search_return = '''    const _filtered = mapped.filter((r) => r.score >= minScore);
    const _searchMs = _searchTimer();
    const _scores = _filtered.map(r => r.score);
    recordSearchMetrics({
      queryChars: 0,
      limit,
      minScore,
      resultCount: _filtered.length,
      latencyMs: _searchMs,
      topScore: _scores.length > 0 ? Math.max(..._scores) : undefined,
      avgScore: _scores.length > 0 ? _scores.reduce((a,b) => a+b, 0) / _scores.length : undefined,
    }).catch(() => {});
    return _filtered;
  }

  private assertValidId'''

if old_search_return in content:
    content = content.replace(old_search_return, new_search_return, 1)
    print("  ✅ Patched MemoryDB.search (return)")
else:
    print("  ⚠️  未找到 MemoryDB.search return 块")

# ===== 5. 修补 MemoryDB.store() =====
old_store = '''  async store(entry: Omit<MemoryEntry, "id"> & { createdAt?: number }): Promise<MemoryEntry> {
    await this.ensureInitialized();

    const createdAt = entry.createdAt ?? Date.now();
    const fullEntry: MemoryEntry = {
      ...entry,
      id: randomUUID(),
      createdAt,
    };

    await this.table!.add([fullEntry]);
    
    this.refreshIndex().catch(err => 
      console.warn("Background index refresh failed:", err)
    );

    return fullEntry;
  }'''

new_store = '''  async store(entry: Omit<MemoryEntry, "id"> & { createdAt?: number }): Promise<MemoryEntry> {
    await this.ensureInitialized();

    const _stTimer = startTimer();
    const createdAt = entry.createdAt ?? Date.now();
    const fullEntry: MemoryEntry = {
      ...entry,
      id: randomUUID(),
      createdAt,
    };

    await this.table!.add([fullEntry]);
    
    this.refreshIndex().catch(err => 
      console.warn("Background index refresh failed:", err)
    );

    const _stMs = _stTimer();
    recordStoreMetrics({
      textChars: (entry.text ?? "").length,
      category: entry.category ?? "other",
      latencyMs: _stMs,
      isDuplicate: false,
    }).catch(() => {});

    return fullEntry;
  }'''

if old_store in content:
    content = content.replace(old_store, new_store, 1)
    print("  ✅ Patched MemoryDB.store")
else:
    print("  ⚠️  未找到 MemoryDB.store 块")


with open("${FILE}", "w") as f:
    f.write(content)

print("  📝 index.ts 修补完成")
PYEOF
}

# ============================================================================
# 注入: 修补 embedder.ts
# ============================================================================

patch_embedder_ts() {
  log_step "修补 embedder.ts — 注入 embedding 调用埋点"

  cp "${PLUGIN_DIR}/src/embeddings/embedder.ts" "${PLUGIN_DIR}/src/embeddings/embedder.ts.bak"

  local FILE="${PLUGIN_DIR}/src/embeddings/embedder.ts"

  python3 << PYEOF
with open("${FILE}", "r") as f:
    content = f.read()

# 1. 添加 import
perf_import = 'import { startTimer, recordEmbedMetrics } from "../perf-metrics.js";\n'

# 在第一个 import 之前插入
if "import {" in content and "perf-metrics" not in content:
    content = perf_import + content
    print("  ✅ Added perf-metrics import")

# 2. 修补 embed() 主入口
old_embed = '''  async embed(text: string): Promise<number[]> {
    if (this.chunker) {
      return await this.embedWithChunking(text);
    } else {
      return await this.embedWithRetry(text);
    }
  }'''

new_embed = '''  async embed(text: string): Promise<number[]> {
    const _timer = startTimer();
    let _retries = 0;
    let _chunked = false;
    let _chunkCount = 1;
    let _result: number[];
    let _error: string | undefined;
    let _success = true;

    try {
      if (this.chunker) {
        _chunked = true;
        _result = await this.embedWithChunking(text);
      } else {
        _result = await this.embedWithRetry(text);
      }
      return _result;
    } catch (err) {
      _success = false;
      _error = err instanceof Error ? err.message : String(err);
      throw err;
    } finally {
      const _latencyMs = _timer();
      recordEmbedMetrics({
        provider: this.provider.name,
        inputChars: text.length,
        latencyMs: _latencyMs,
        chunked: _chunked,
        chunkCount: _chunkCount,
        retries: _retries,
        success: _success,
        error: _error,
      }).catch(() => {});
    }
  }'''

if old_embed in content:
    content = content.replace(old_embed, new_embed, 1)
    print("  ✅ Patched Embedder.embed()")
else:
    print("  ⚠️  未找到 Embedder.embed() 块")

with open("${FILE}", "w") as f:
    f.write(content)

print("  📝 embedder.ts 修补完成")
PYEOF
}

# ============================================================================
# 注入: 创建分析脚本
# ============================================================================

create_analysis_script() {
  log_step "创建指标分析脚本 → ${PLUGIN_DIR}/analyze-perf.sh"

  cat > "${PLUGIN_DIR}/analyze-perf.sh" << 'ANALYSIS_EOF'
#!/usr/bin/env bash
#
# 分析 memory-lancedb-ultra 性能指标
# 用法: bash analyze-perf.sh [metrics-file]
#

METRICS="${1:-/tmp/openclaw/memory-perf-metrics.jsonl}"

if [[ ! -f "${METRICS}" ]]; then
  echo "❌ 找不到指标文件: ${METRICS}"
  echo "   请先运行一些对话产生数据"
  exit 1
fi

TOTAL=$(wc -l < "${METRICS}")
echo "=========================================="
echo "  memory-lancedb-ultra 性能分析报告"
echo "=========================================="
echo ""
echo "📊 总指标条数: ${TOTAL}"
echo ""

python3 << 'PYEOF'
import json
import sys
import statistics

metrics_file = sys.argv[1] if len(sys.argv) > 1 else "/tmp/openclaw/memory-perf-metrics.jsonl"

events = {"recall": [], "capture": [], "embed": [], "search": [], "store": []}

with open(metrics_file) as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            entry = json.loads(line)
            event_type = entry.get("event", "unknown")
            if event_type in events:
                events[event_type].append(entry)
        except json.JSONDecodeError:
            continue

def pct(data, p):
    if not data:
        return 0
    s = sorted(data)
    idx = int(len(s) * p / 100)
    return s[min(idx, len(s)-1)]

def fmt(ms):
    if ms < 1:
        return f"{ms:.2f}ms"
    elif ms < 1000:
        return f"{ms:.0f}ms"
    else:
        return f"{ms/1000:.1f}s"

# ---- Recall 分析 ----
recalls = events["recall"]
if recalls:
    totals = [r["totalMs"] for r in recalls if "totalMs" in r]
    strips = [r["stripMs"] for r in recalls if "stripMs" in r]
    embeds = [r["embedMs"] for r in recalls if "embedMs" in r]
    searches = [r["searchMs"] for r in recalls if "searchMs" in r]
    formats = [r["formatMs"] for r in recalls if "formatMs" in r]
    counts = [r["recallCount"] for r in recalls if "recallCount" in r]
    chars = [r["injectedChars"] for r in recalls if "injectedChars" in r]

    print("─── Auto-Recall 性能 ───")
    print(f"  调用次数:     {len(recalls)}")
    print(f"  总延迟:       P50={fmt(pct(totals,50))}  P95={fmt(pct(totals,95))}  P99={fmt(pct(totals,99))}  avg={fmt(statistics.mean(totals) if totals else 0)}")
    print(f"  ├─ 清洗:      P50={fmt(pct(strips,50))}  avg={fmt(statistics.mean(strips) if strips else 0)}")
    print(f"  ├─ Embedding:  P50={fmt(pct(embeds,50))}  avg={fmt(statistics.mean(embeds) if embeds else 0)}")
    print(f"  ├─ 搜索:      P50={fmt(pct(searches,50))}  avg={fmt(statistics.mean(searches) if searches else 0)}")
    print(f"  └─ 格式化:    P50={fmt(pct(formats,50))}  avg={fmt(statistics.mean(formats) if formats else 0)}")
    print(f"  召回条数:     avg={statistics.mean(counts):.1f}  max={max(counts) if counts else 0}")
    print(f"  注入字符:     avg={statistics.mean(chars):.0f}  max={max(chars) if chars else 0}  (~{statistics.mean(chars)/4:.0f} tokens)")
    print()

# ---- Capture 分析 ----
captures = events["capture"]
if captures:
    totals = [r["totalMs"] for r in captures if "totalMs" in r]
    stored = [r["stored"] for r in captures if "stored" in r]
    dupes = [r["duplicatesSkipped"] for r in captures if "duplicatesSkipped" in r]
    scanned = [r["messagesScanned"] for r in captures if "messagesScanned" in r]

    print("─── Auto-Capture 性能 ───")
    print(f"  调用次数:     {len(captures)}")
    print(f"  总延迟:       P50={fmt(pct(totals,50))}  P95={fmt(pct(totals,95))}  avg={fmt(statistics.mean(totals) if totals else 0)}")
    print(f"  存储条数:     avg={statistics.mean(stored):.1f}  total={sum(stored)}")
    print(f"  去重跳过:     avg={statistics.mean(dupes):.1f}  total={sum(dupes)}")
    print(f"  消息扫描:     avg={statistics.mean(scanned):.1f}")
    if sum(stored) + sum(dupes) > 0:
        waste_rate = sum(dupes) / (sum(stored) + sum(dupes)) * 100
        print(f"  去重率:       {waste_rate:.1f}%")
    print()

# ---- Embedding 分析 ----
embeds_data = events["embed"]
if embeds_data:
    lats = [r["latencyMs"] for r in embeds_data if "latencyMs" in r]
    chars_in = [r["inputChars"] for r in embeds_data if "inputChars" in r]
    providers = {}
    for r in embeds_data:
        p = r.get("provider", "unknown")
        if p not in providers:
            providers[p] = []
        providers[p].append(r.get("latencyMs", 0))
    
    successes = sum(1 for r in embeds_data if r.get("success"))
    failures = len(embeds_data) - successes

    print("─── Embedding API 性能 ───")
    print(f"  总调用:       {len(embeds_data)}  (成功={successes}, 失败={failures})")
    print(f"  延迟:         P50={fmt(pct(lats,50))}  P95={fmt(pct(lats,95))}  avg={fmt(statistics.mean(lats) if lats else 0)}")
    print(f"  输入字符:     avg={statistics.mean(chars_in):.0f}  max={max(chars_in) if chars_in else 0}")
    for p, p_lats in providers.items():
        print(f"  Provider [{p}]: calls={len(p_lats)}  avg={fmt(statistics.mean(p_lats))}")
    print()

# ---- Search 分析 ----
search_data = events["search"]
if search_data:
    lats = [r["latencyMs"] for r in search_data if "latencyMs" in r]
    counts = [r["resultCount"] for r in search_data if "resultCount" in r]
    top_scores = [r["topScore"] for r in search_data if r.get("topScore") is not None]

    print("─── LanceDB Search 性能 ───")
    print(f"  总调用:       {len(search_data)}")
    print(f"  延迟:         P50={fmt(pct(lats,50))}  P95={fmt(pct(lats,95))}  avg={fmt(statistics.mean(lats) if lats else 0)}")
    print(f"  结果数:       avg={statistics.mean(counts):.1f}  max={max(counts) if counts else 0}")
    if top_scores:
        print(f"  最高相似度:   avg={statistics.mean(top_scores):.2f}  max={max(top_scores):.2f}")
    print()

# ---- Store 分析 ----
store_data = events["store"]
if store_data:
    lats = [r["latencyMs"] for r in store_data if "latencyMs" in r]
    print("─── LanceDB Store 性能 ───")
    print(f"  总调用:       {len(store_data)}")
    print(f"  延迟:         P50={fmt(pct(lats,50))}  P95={fmt(pct(lats,95))}  avg={fmt(statistics.mean(lats) if lats else 0)}")
    print()

# ---- 综合评估 ----
if recalls:
    avg_recall = statistics.mean([r["totalMs"] for r in recalls if "totalMs" in r])
    avg_inject = statistics.mean(chars) / 4 if chars else 0  # 估算 tokens
    
    print("═══ 综合影响评估 ═══")
    print(f"  TTFT 增量 (预估):        +{fmt(avg_recall)}  (Auto-Recall 阻塞首 token)")
    print(f"  每对话注入 tokens (预估): ~{avg_inject:.0f} tokens")
    
    if avg_inject > 0:
        # Opus: $15/M input, Sonnet: $3/M input
        opus_cost = avg_inject / 1_000_000 * 15
        sonnet_cost = avg_inject / 1_000_000 * 3
        print(f"  LLM 增量成本/对话:       Opus ~${opus_cost:.5f}  Sonnet ~${sonnet_cost:.6f}")
    
    embed_calls_per_conv = len(embeds_data) / max(len(recalls), 1)
    print(f"  Embedding 调用/对话:      ~{embed_calls_per_conv:.1f}")
    
    if embeds_data:
        avg_embed_lat = statistics.mean([r["latencyMs"] for r in embeds_data if "latencyMs" in r])
        print(f"  Embedding 延迟/调用:      ~{fmt(avg_embed_lat)}")
    
    print()
    
    # 评级
    if avg_recall < 300:
        grade = "🟢 良好 — 对用户体验影响小"
    elif avg_recall < 600:
        grade = "🟡 可接受 — 但高频场景需注意"
    elif avg_recall < 1000:
        grade = "🟠 需优化 — 用户可感知延迟"
    else:
        grade = "🔴 严重 — 建议禁用 Auto-Recall 或优化"
    
    print(f"  综合评级: {grade}")
    print()

if not any(events.values()):
    print("⚠️  暂无指标数据，请先进行一些对话")
PYEOF
}
ANALYSIS_EOF

  chmod +x "${PLUGIN_DIR}/analyze-perf.sh"
}

# ============================================================================
# 注入: 创建快速验证脚本
# ============================================================================

create_smoke_test() {
  log_step "创建快速验证脚本 → ${PLUGIN_DIR}/smoke-test.sh"

  cat > "${PLUGIN_DIR}/smoke-test.sh" << 'SMOKE_EOF'
#!/usr/bin/env bash
#
# 快速验证埋点是否生效
#

METRICS="/tmp/openclaw/memory-perf-metrics.jsonl"

echo "🔍 检查埋点状态..."

# 记录当前行数
BEFORE=0
if [[ -f "${METRICS}" ]]; then
  BEFORE=$(wc -l < "${METRICS}")
fi

echo "   当前指标条数: ${BEFORE}"
echo ""
echo "📋 接下来请："
echo "   1. 向 Agent 发送一条消息（任意内容）"
echo "   2. 等待 Agent 回复完成"
echo "   3. 回到这里按 Enter"
echo ""
read -rp "按 Enter 继续检查..."

AFTER=0
if [[ -f "${METRICS}" ]]; then
  AFTER=$(wc -l < "${METRICS}")
fi

NEW=$((AFTER - BEFORE))

if [[ ${NEW} -gt 0 ]]; then
  echo ""
  echo "✅ 成功！新增 ${NEW} 条指标"
  echo ""
  echo "最新指标:"
  tail -${NEW} "${METRICS}" | python3 -c "
import sys, json
for line in sys.stdin:
    d = json.loads(line)
    event = d.get('event', '?')
    ts = d.get('_ts', '?')
    if event == 'recall':
        print(f'  📥 Recall: total={d.get(\"totalMs\",0):.0f}ms embed={d.get(\"embedMs\",0):.0f}ms search={d.get(\"searchMs\",0):.0f}ms count={d.get(\"recallCount\",0)}')
    elif event == 'capture':
        print(f'  📤 Capture: total={d.get(\"totalMs\",0):.0f}ms stored={d.get(\"stored\",0)} dupes={d.get(\"duplicatesSkipped\",0)}')
    elif event == 'embed':
        print(f'  🧮 Embed: {d.get(\"latencyMs\",0):.0f}ms provider={d.get(\"provider\",\"?\")} chars={d.get(\"inputChars\",0)} ok={d.get(\"success\",\"?\")}')
    elif event == 'search':
        print(f'  🔍 Search: {d.get(\"latencyMs\",0):.0f}ms results={d.get(\"resultCount\",0)} top={d.get(\"topScore\",0):.2f}')
    elif event == 'store':
        print(f'  💾 Store: {d.get(\"latencyMs\",0):.0f}ms chars={d.get(\"textChars\",0)} cat={d.get(\"category\",\"?\")}')
    else:
        print(f'  ❓ {event}: {json.dumps(d, ensure_ascii=False)[:120]}')
" 2>/dev/null || tail -${NEW} "${METRICS}"
else
  echo ""
  echo "⚠️  未检测到新指标"
  echo "   可能原因："
  echo "   - Gateway 需要重启以加载修改后的插件"
  echo "   - 插件未启用 (检查 openclaw.json)"
  echo "   - TypeScript 需要重新编译"
fi
SMOKE_EOF

  chmod +x "${PLUGIN_DIR}/smoke-test.sh"
}

# ============================================================================
# 主流程
# ============================================================================

main() {
  check_plugin_dir

  case "${ACTION}" in
    --restore|restore)
      do_restore
      return
      ;;
    --status|status)
      do_status
      return
      ;;
    inject|--inject)
      ;;
    *)
      log_error "未知操作: ${ACTION}"
      echo "用法: bash instrument.sh <plugin-dir> [--restore|--status]"
      exit 1
      ;;
  esac

  # 检查是否已注入
  if [[ -f "${BACKUP_MARKER}" ]]; then
    log_warn "已存在埋点，先还原再重新注入"
    do_restore
  fi

  echo ""
  echo "=========================================="
  echo "  memory-lancedb-ultra 性能埋点注入"
  echo "=========================================="
  echo "  插件目录: ${PLUGIN_DIR}"
  echo "  指标输出: ${METRICS_FILE}"
  echo "=========================================="
  echo ""

  # Step 1: 创建指标收集模块
  create_metrics_module

  # Step 2: 修补 index.ts
  patch_index_ts

  # Step 3: 修补 embedder.ts
  patch_embedder_ts

  # Step 4: 创建分析脚本
  create_analysis_script

  # Step 5: 创建验证脚本
  create_smoke_test

  # 标记已注入
  date -u +"%Y-%m-%dT%H:%M:%SZ" > "${BACKUP_MARKER}"

  echo ""
  echo "=========================================="
  log_info "✅ 埋点注入完成！"
  echo "=========================================="
  echo ""
  echo "  接下来："
  echo ""
  echo "  1. 重新编译（如果需要）:"
  echo "     cd ${PLUGIN_DIR} && npm run build"
  echo ""
  echo "  2. 重启 Gateway 加载修改:"
  echo "     openclaw gateway restart"
  echo ""
  echo "  3. 验证埋点生效:"
  echo "     bash ${PLUGIN_DIR}/smoke-test.sh"
  echo ""
  echo "  4. 正常使用一段时间后，分析结果:"
  echo "     bash ${PLUGIN_DIR}/analyze-perf.sh"
  echo ""
  echo "  5. 完成后还原:"
  echo "     bash $0 ${PLUGIN_DIR} --restore"
  echo ""
}

main
