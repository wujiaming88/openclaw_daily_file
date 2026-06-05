# Part 2：金融监管（A 股 + 港股核心信息源）

## 2.1 中国证监会 CSRC

| 栏目 | 网址 | 信息类型 | 更新 | 评级 |
|------|------|----------|------|------|
| 政策法规 | http://www.csrc.gov.cn/csrc/c100028/common_list.shtml | 部门规章、规范性文件、问答 | 不定期 | ⭐⭐⭐⭐⭐ |
| 新闻发布会 | http://www.csrc.gov.cn/csrc/c100029/common_list.shtml | 周度发言、监管动向 | 周（一般周五） | ⭐⭐⭐⭐⭐ |
| 行政处罚 | http://www.csrc.gov.cn/csrc/c101928/common_list.shtml | 个股/中介机构处罚 | 不定期 | ⭐⭐⭐⭐ |
| IPO 审核 | https://kcb.sse.com.cn / http://reportdocs.static.szse.cn / http://www.csrc.gov.cn/csrc/c100214/common_list.shtml | 主板/创业板/科创板/北交所 IPO 进度 | 周 | ⭐⭐⭐⭐⭐ |
| 再融资/并购重组 | http://www.csrc.gov.cn/csrc/c100217 | 再融资批文、重组反馈 | 不定期 | ⭐⭐⭐⭐ |

**爬取要点**：CSRC 列表页是 ASP.NET 的标准结构，`common_list.shtml` 配合 `pageNum` 翻页；详情页带 `<div id="content">`。反爬难度 1-2/5，加 UA 即可。

## 2.2 沪深北交易所（A 股市场公告与披露）

| 数据源 | 网址 | 内容 | 获取方式 | 评级 |
|--------|------|------|----------|------|
| **巨潮资讯（深交所旗下）** | https://www.cninfo.com.cn | 全市场上市公司公告（最权威全集） | 公开 POST API：`http://www.cninfo.com.cn/new/hisAnnouncement/query`，返回 JSON | ⭐⭐⭐⭐⭐ |
| **上交所披露** | http://www.sse.com.cn/disclosure/listedinfo/announcement/ | 沪市公告、问询函、监管措施 | JSON API：`http://query.sse.com.cn/security/stock/queryCompanyBulletin.do` | ⭐⭐⭐⭐⭐ |
| **深交所披露** | https://www.szse.cn/disclosure/listed/notice/index.html | 深市公告 | JSON API：`http://www.szse.cn/api/disc/announcement/annList` | ⭐⭐⭐⭐⭐ |
| **北交所** | https://www.bse.cn | 北交所上市公司公告 | JSON API：`https://www.bse.cn/disclosure/list/...` | ⭐⭐⭐⭐ |
| **沪深交易所发行上市审核** | http://kcb.sse.com.cn / https://listing.szse.cn | 科创板/创业板 IPO 受理→注册全流程 | 静态页 + JSON | ⭐⭐⭐⭐⭐ |

**关键 API 示例（巨潮）**：
```
POST http://www.cninfo.com.cn/new/hisAnnouncement/query
Form: stock=, tabName=fulltext, pageSize=30, pageNum=1, 
      column=szse, category=category_ndbg_szsh;, plate=, seDate=2026-01-01~2026-05-17
返回：JSON 包含 announcement[] 列表，每项含 announcementId、PDF 路径
```
PDF 下载：`http://static.cninfo.com.cn/finalpage/{date}/{announcementId}.PDF`

## 2.3 港交所 HKEX & 港交所披露易（港股核心）

| 数据源 | 网址 | 内容 | 获取方式 | 评级 |
|--------|------|------|----------|------|
| **披露易 HKEXnews** | https://www.hkexnews.hk/index_c.htm | 港股上市公司全部公告（IPO 招股、年报、自愿/受规公告） | 高级搜索 POST：`https://www3.hkexnews.hk/listedco/listconews/advancedsearch/search_active_main_c.aspx`；当日列表也提供 RSS-like JSON | ⭐⭐⭐⭐⭐ |
| **HKEX 主站** | https://www.hkex.com.hk | 市场数据、产品规则、市场公告、规则修订 | 大量 JSON 端点（如 `https://www1.hkex.com.hk/hkexwidget/data/...`） | ⭐⭐⭐⭐⭐ |
| **HKEX 北向南向资金** | https://sc.hkex.com.hk/TuniS/www.hkex.com.hk/Mutual-Market/Stock-Connect/Statistics | 沪深港通持股数据（每日 T+1） | JSON 文件每日下载（CSV/XLS） | ⭐⭐⭐⭐⭐ |
| **港股通持股查询 CCASS** | https://di.hkex.com.hk | 中央结算系统持股明细（看南向 + 北向托管行席位） | HTML 表格爬取（POST 表单参数） | ⭐⭐⭐⭐⭐ |
| **HKEX 衍生品成交持仓** | https://www.hkex.com.hk/Market-Data/Statistics/Consolidated-Reports | 期权/期货持仓/PCR | 日报 PDF + CSV | ⭐⭐⭐⭐ |

**反爬注意**：HKEX 主站对 `/eng/csm/` 等返回 403，但 `www3.hkexnews.hk` 的搜索接口稳定可用。CCASS 反爬较强，建议使用 Selenium / Playwright + 速率限制（>5s/请求）。

## 2.4 香港证监会 SFC

| 数据源 | 网址 | 内容 | 评级 |
|--------|------|------|------|
| **SFC 主站** | https://www.sfc.hk | 监管政策、咨询文件、执法行动 | ⭐⭐⭐⭐ |
| **SFC News & Announcements** | https://apps.sfc.hk/edistributionWeb/gateway/EN/news-and-announcements/ | 处罚决定、市场禁入、合规通函 | ⭐⭐⭐⭐ |
| **SFC 持牌人/机构查询** | https://apps.sfc.hk/publicregWeb/ | 持牌资管、券商 | ⭐⭐⭐ |
| **SFC 沽空报告** | https://www.sfc.hk/en/Regulatory-functions/Market-conduct/Reportable-short-position | 周度沽空数据 | ⭐⭐⭐⭐ |

## 2.5 国家金融监督管理总局 NFRA（原银保监会）

> 2023 年党和国家机构改革：原银保监会（CBIRC）+ 央行部分职能 → 新设国家金融监督管理总局，原 cbirc.gov.cn 已废弃。

| 数据源 | 网址 | 内容 | 评级 |
|--------|------|------|------|
| **NFRA 主站** | https://www.nfra.gov.cn | 银行/保险/信托监管政策、行政处罚 | ⭐⭐⭐⭐ |
| 行政处罚 | https://www.nfra.gov.cn/cn/view/pages/ItemList.html?itemPId=923&itemId=4113 | 银行/保险机构处罚（影响金融板块预期） | ⭐⭐⭐⭐ |

## 2.6 央行 PBoC

| 栏目 | 网址 | 内容 | 评级 |
|------|------|------|------|
| 公开市场操作 | http://www.pbc.gov.cn/zhengcehuobisi/125207/125213/125440/125838/125885/index.html | 每日逆回购/MLF 操作 | ⭐⭐⭐⭐⭐ |
| 货币政策报告 | http://www.pbc.gov.cn/zhengcehuobisi/125207/125227/125957/index.html | 季度货币政策执行报告 | ⭐⭐⭐⭐⭐ |
| 金融统计数据 | http://www.pbc.gov.cn/diaochatongjisi/116219/index.html | M0/M1/M2、社融、信贷月报 | 月（一般 11-15 日） | ⭐⭐⭐⭐⭐ |
| LPR | https://www.pbc.gov.cn/zhengcehuobisi/125207/125213/125440/125838/3876551/index.html | 月度 LPR | 月（20 日） | ⭐⭐⭐⭐⭐ |

## 2.7 国家外汇管理局 SAFE

| 数据 | 网址 | 内容 | 评级 |
|------|------|------|------|
| 国际收支平衡表 | https://www.safe.gov.cn | 季度 BoP | ⭐⭐⭐⭐ |
| 外汇储备 | https://www.safe.gov.cn/safe/wjcb/index.html | 月度 | ⭐⭐⭐⭐ |
| 银行结售汇/代客涉外收付款 | https://www.safe.gov.cn/safe/whsj/index.html | 月度（资本流动信号） | ⭐⭐⭐⭐⭐ |
| QFII / RQFII / QDII 额度 | https://www.safe.gov.cn/safe/2020/0428/15976.html | 不定期更新 | ⭐⭐⭐⭐ |

## 2.8 行业自律组织

| 数据源 | 网址 | 内容 | 评级 |
|--------|------|------|------|
| **中国证券业协会 SAC** | http://www.sac.net.cn | 券商分类评级、从业人员 | ⭐⭐⭐ |
| **中国证券投资基金业协会 AMAC** | https://www.amac.org.cn | 公私募登记备案、规模数据 | ⭐⭐⭐⭐⭐（看私募/公募存量动向） |
| **中证登 CSDC** | http://www.chinaclear.cn | 投资者数量、持仓结构、新增开户数 | 周/月 | ⭐⭐⭐⭐⭐ |
