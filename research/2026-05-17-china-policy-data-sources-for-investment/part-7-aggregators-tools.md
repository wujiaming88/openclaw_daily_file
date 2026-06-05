# Part 7：聚合平台与开源工具（工程加速器）

> 自己从源头爬可以保证一手与可控，但工作量极大。下列工具可作为**胶水层**，把官方源打包成 Python/Java 友好格式，**免费 + 开源**为主。

## 7.1 开源数据聚合库（首选）

| 工具 | 网址 | 覆盖 | 特点 | 评级 |
|------|------|------|------|------|
| **AKShare** | https://akshare.akfamily.xyz | A 股、港股、美股、宏观、期货、债券、行业 | 纯 Python，免费，覆盖最广。封装了统计局/海关/央行/沪深港交易所/中证指数等几乎所有公开源 | ⭐⭐⭐⭐⭐（投资数据工程的瑞士军刀）|
| **Tushare Pro** | https://tushare.pro | A 股全市场、宏观、行业 | 部分免费 + 积分制，需注册。数据质量稳定，金融机构常用 | ⭐⭐⭐⭐⭐ |
| **BaoStock** | http://baostock.com | A 股历史日线/分钟、财报 | 免登录，免费，稳定 | ⭐⭐⭐⭐ |
| **Efinance** | https://github.com/Micro-sheep/efinance | 东方财富数据封装 | 实时行情/资金流 | ⭐⭐⭐⭐ |
| **adata** | https://github.com/1nchaos/adata | A 股/可转债/ETF | 多源容错 | ⭐⭐⭐ |
| **mootdx** | https://github.com/mootdx/mootdx | 通达信本地行情 | 离线日线，速度快 | ⭐⭐⭐ |
| **rqalpha + tquant**（饶迟）| 第三方 | 量化框架 + 数据 | 偏研究 | ⭐⭐⭐ |

## 7.2 财经新闻与研报聚合

| 平台 | 网址 | 特点 |
|------|------|------|
| **东方财富网** | https://www.eastmoney.com | A/H 公告、研报、龙虎榜、北向资金，**事实上的"国内 Bloomberg 替身"** |
| **新浪财经** | https://finance.sina.com.cn | 行情接口稳定（如 `https://hq.sinajs.cn/list=sh600000`） |
| **同花顺** | https://www.10jqka.com.cn | 概念板块分类完善 |
| **雪球** | https://xueqiu.com | 港美股行情、社区情绪 |
| **财新** | https://www.caixin.com | 深度报道 + 财新 PMI |
| **第一财经/上证报/证券时报** | https://www.yicai.com / http://www.cnstock.com | 官方权威媒体 |
| **格隆汇** | https://www.gelonghui.com | 港股研究 |

## 7.3 港股工具

| 工具 | 网址/库 | 特点 |
|------|---------|------|
| **futuQuant** / Futu OpenAPI | https://www.futunn.com/OpenAPI | 富途量化接口，港美股专精 |
| **Tiger OpenAPI** | https://www.itiger.com/openapi | 老虎量化接口 |
| **AAStocks** | http://www.aastocks.com | 港股第三方行情 |
| **HKEX 直连数据 OMD** | https://www.hkex.com.hk/Services/Connectivity | 付费实时数据，机构使用 |

## 7.4 推荐技术栈

```
应用层：研究分析 / 因子构建 / 风险监控
   ↑
ETL 层（自研）：清洗、对齐、版本化、回填修订
   ↑
数据采集层：
   ├─ 高优先级：AKShare + Tushare（覆盖 80% 需求，1-2 天上线）
   ├─ 增量补漏：自写爬虫（巨潮 / HKEXnews / 政府网搜索）
   └─ 高频替代：东财/同花顺/新浪财经接口（注意法律合规与频率）
   ↑
存储层：
   ├─ 时序数据 → ClickHouse / TimescaleDB
   ├─ 文档（公告/政策 PDF）→ MinIO + ElasticSearch（中文分词）
   └─ 元数据（源版本、修订）→ PostgreSQL
```

## 7.5 工程关键原则

1. **Source of truth 仍是官方**：聚合库可能有数据延迟或字段缺失，关键决策点必须回查官方原文。
2. **修订追踪**：统计局/财政部经常修订历史数据。每次抓取保留 `data_version` + `crawl_time`。
3. **PDF 政策文档全文检索**：用 ElasticSearch + ik 分词器建立政策语料库，关键词订阅。
4. **异常监控**：每个源建立"心跳"作业（每日尝试拿一条数据），失败即报警，避免静默漏数。
5. **法律合规**：商业使用需关注《数据安全法》《个人信息保护法》《网络安全法》，部分交易所数据规定不得二次商业分发。
6. **频率控制**：政府网站建议 ≤1 QPS；交易所 ≤2 QPS；HKEXnews ≤0.5 QPS。
