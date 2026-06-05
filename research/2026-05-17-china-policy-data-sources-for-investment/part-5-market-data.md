# Part 5：市场与交易数据（A 股 + 港股）

## 5.1 沪深交易所行情/交易数据

| 数据 | 入口 | 频率 | 获取方式 | 评级 |
|------|------|------|----------|------|
| **沪市行情** | http://www.sse.com.cn | 实时分钟/日 K | JSON API：`http://yunhq.sse.com.cn:32041/v1/sh1/...` | ⭐⭐⭐⭐⭐ |
| **深市行情** | https://www.szse.cn | 实时分钟/日 K | `http://www.szse.cn/api/market/...` | ⭐⭐⭐⭐⭐ |
| **沪深龙虎榜** | http://www.sse.com.cn/disclosure/diclosure/public/ / http://www.szse.cn/disclosure/supervision/inquire/index.html | 日 | JSON | ⭐⭐⭐⭐⭐（资金流向）|
| **大宗交易** | 同上披露栏目 | 日 | JSON | ⭐⭐⭐⭐ |
| **融资融券** | http://www.sse.com.cn/market/othersdata/margin/ / http://www.szse.cn/disclosure/margin/ | 日 | JSON | ⭐⭐⭐⭐⭐ |
| **沪深港通持股** | http://www.sse.com.cn/market/sgt/ / http://www.szse.cn/szhk/hkbussiness/ | T+1 | JSON | ⭐⭐⭐⭐⭐ |
| **指数成分** | http://www.csindex.com.cn | 季调 | Excel/CSV | ⭐⭐⭐⭐⭐ |
| **新股申购日历** | 上交所/深交所发行栏目 + 巨潮 | 实时 | JSON | ⭐⭐⭐⭐ |

**典型 API 模式**：
```
GET http://yunhq.sse.com.cn:32041/v1/sh1/snap/600000?select=name,last,chg_rate,volume
返回 JSON：{ "code": 0, "data": [["浦发银行",7.31,...]] }
```

## 5.2 港股市场数据

| 数据 | 入口 | 频率 | 评级 |
|------|------|------|------|
| **港股实时行情** | https://www.hkex.com.hk / 第三方（同花顺/雪球/东方财富）| 实时（HKEX 直接 15 分钟延迟）| ⭐⭐⭐⭐⭐ |
| **港股通成交活跃股** | https://www.hkex.com.hk/Mutual-Market/Stock-Connect | 日 | ⭐⭐⭐⭐⭐ |
| **南向资金每日净流入** | https://sc.hkex.com.hk/TuniS/.../Statistics/Statistics-on-Aggregate-Trade-Value | 日 | ⭐⭐⭐⭐⭐ |
| **CCASS 持股查询** | https://di.hkex.com.hk | 日（披露日 T+1）| ⭐⭐⭐⭐⭐ |
| **港股沽空数据** | https://www.hkex.com.hk/Mutual-Market/Stock-Connect/Statistics/Short-Selling | 日 | ⭐⭐⭐⭐ |
| **新股招股书 / 全球发售** | https://www.hkexnews.hk/listedco/listconews/SEHK/ | 实时 | ⭐⭐⭐⭐⭐ |
| **HKEX 衍生品成交持仓 OI** | https://www.hkex.com.hk/Market-Data/Statistics/Consolidated-Reports | 日 PDF | ⭐⭐⭐⭐ |

## 5.3 指数公司

| 公司 | 网址 | 内容 | 评级 |
|------|------|------|------|
| **中证指数** | https://www.csindex.com.cn | A 股核心指数（沪深 300/中证 500/中证 1000）成分、权重、PE/PB、风格 | ⭐⭐⭐⭐⭐ |
| **国证指数** | http://www.cnindex.com.cn | 深市国证系列 | ⭐⭐⭐⭐ |
| **恒生指数公司** | https://www.hsi.com.hk | 恒指、国企指数、科技指数、行业指数成分 | ⭐⭐⭐⭐⭐ |
| **MSCI / FTSE / S&P** | 各官网 | 中国 A 股纳入因子 | ⭐⭐⭐ |

中证指数官网提供日度估值表 Excel 下载：`https://www.csindex.com.cn/-/csindex/static/uploads/indices/detail/files/zh_CN/000300closeweight.xls`，可定时自动下载。

## 5.4 投资者结构与资金面

| 数据 | 入口 | 频率 | 评级 |
|------|------|------|------|
| **A 股新增开户** | http://www.chinaclear.cn | 周/月 | ⭐⭐⭐⭐⭐ |
| **公募基金规模/份额** | https://www.amac.org.cn | 月 | ⭐⭐⭐⭐⭐ |
| **私募管理人/产品备案** | https://www.amac.org.cn | 月 | ⭐⭐⭐⭐ |
| **ETF 份额变化** | 沪深交易所 / 各基金公司 | 日 | ⭐⭐⭐⭐⭐ |
| **保险资金运用** | NFRA + 银保监保险业披露 | 季 | ⭐⭐⭐⭐ |
| **社保/养老金/年金** | 财政部、人社部 | 季/年 | ⭐⭐⭐ |
| **QFII/RQFII 持股** | 通过上市公司前十大股东披露反推 | 季 | ⭐⭐⭐⭐ |

## 5.5 上市公司基本面（财报+预告）

| 数据 | 入口 | 频率 | 评级 |
|------|------|------|------|
| **定期报告** | 巨潮 / 沪深交易所披露 | 季报、年报 | ⭐⭐⭐⭐⭐ |
| **业绩预告** | 巨潮 | 季 | ⭐⭐⭐⭐⭐ |
| **股东减持** | 巨潮 + 交易所 | 实时 | ⭐⭐⭐⭐ |
| **股权激励/限制性股票** | 巨潮 | 实时 | ⭐⭐⭐⭐ |
| **回购** | 巨潮 | 实时 | ⭐⭐⭐⭐⭐ |
| **港股财报** | HKEXnews | 季/半年/年 | ⭐⭐⭐⭐⭐ |
