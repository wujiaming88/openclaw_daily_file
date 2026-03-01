const axios = require('axios');
const cheerio = require('cheerio');

// 配置BytePlus API
const BYTEPLUS_API_KEY = 'df96708f-6ca1-4897-9bb2-468eb8773c80';
const BYTEPLUS_API_URL = 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

// 新闻源配置
const NEWS_SOURCES = [
  { name: 'BBC科技', url: 'https://www.bbc.com/news/technology' },
  { name: 'CNET', url: 'https://www.cnet.com/' },
  { name: 'TechCrunch', url: 'https://techcrunch.com/' },
  { name: 'The Verge', url: 'https://www.theverge.com/' },
  { name: 'Wired', url: 'https://www.wired.com/' },
  { name: 'ZDNet', url: 'https://www.zdnet.com/' },
  { name: 'Ars Technica', url: 'https://arstechnica.com/' },
  { name: 'Engadget', url: 'https://www.engadget.com/' },
  { name: 'PCMag', url: 'https://www.pcmag.com/' },
  { name: 'Tom\'s Hardware', url: 'https://www.tomshardware.com/' },
];

// 抓取新闻
async function fetchNews(source) {
  try {
    const response = await axios.get(source.url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
      }
    });
    
    const $ = cheerio.load(response.data);
    const articles = [];
    
    // 通用选择器 - 适配大多数科技新闻网站
    $('article, .post, .story, .item').each((i, el) => {
      let title = $(el).find('h2, h3, h4').first().text().trim();
      let link = $(el).find('a').first().attr('href');
      
      if (title && link) {
        // 处理相对链接
        if (!link.startsWith('http')) {
          link = new URL(link, source.url).href;
        }
        articles.push({ title, link });
      }
    });
    
    // 如果没有找到足够的文章，尝试更通用的选择器
    if (articles.length === 0) {
      $('h2, h3, h4').each((i, el) => {
        const title = $(el).text().trim();
        const link = $(el).parent('a').attr('href') || $(el).closest('a').attr('href');
        if (title && link) {
          const fullLink = link.startsWith('http') ? link : `${source.url}${link}`;
          articles.push({ title, link: fullLink });
        }
      });
    }
    
    return { source: source.name, articles: [...new Map(articles.map(item => [item.link, item])).values()].slice(0, 5) };
  } catch (error) {
    console.error(`抓取${source.name}新闻失败:`, error.message);
    return { source: source.name, articles: [] };
  }
}

// 生成摘要
async function generateSummary(newsData) {
  try {
    const prompt = `请对以下来自不同新闻源的科技新闻进行综合摘要，突出重点信息和不同来源的观点差异：

${newsData.map(item => `【${item.source}】
${item.articles.map(article => `- ${article.title}`).join('\n')}`).join('\n\n')}

要求：
1. 摘要简洁明了，不超过300字
2. 突出科技领域的重要进展和突破
3. 指出不同来源报道的侧重点差异
4. 使用中文撰写`;

    const response = await axios.post('https://ark.cn-beijing.volces.com/api/v3/chat/completions', {
      model: 'byteplus-plan/ark-code-latest',
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.7,
    }, {
      headers: {
        'Authorization': `Bearer df96708f-6ca1-4897-9bb2-468eb8773c80`,
        'Content-Type': 'application/json'
      }
    });

    return response.data.choices[0].message.content;
  } catch (error) {
    console.error('生成摘要失败:', error.message);
    // 模拟摘要生成
    const mockSummary = `今日科技领域主要动态：

1. ${newsData[0]?.articles[0]?.title || '暂无有效新闻'}
2. ${newsData[1]?.articles[0]?.title || '暂无有效新闻'}
3. ${newsData[2]?.articles[0]?.title || '暂无有效新闻'}

由于API调用失败，以上为新闻标题直接汇总。`;
    return mockSummary;
  }
}

// 主函数
async function main() {
  console.log('开始抓取多源科技新闻...');
  
  // 并行抓取所有新闻源
  const newsPromises = NEWS_SOURCES.map(source => fetchNews(source));
  const newsData = await Promise.all(newsPromises);
  
  // 过滤空结果
  const validNewsData = newsData.filter(item => item.articles.length > 0);
  
  if (validNewsData.length === 0) {
    console.log('未能抓取到任何新闻数据');
    return;
  }
  
  console.log('成功抓取到来自', validNewsData.length, '个新闻源的新闻');
  
  // 生成摘要
  const summary = await generateSummary(validNewsData);
  
  console.log('\n=== 多源科技新闻摘要 ===');
  console.log(summary);
  console.log('======================');
  
  // 保存到文件
  const fs = require('fs');
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `news-summary-${timestamp}.txt`;
  fs.writeFileSync(filename, summary);
  console.log(`摘要已保存到文件: ${filename}`);
  
  // 推送到远端仓库
  try {
    const { execSync } = require('child_process');
    execSync('cd /root/.openclaw/workspace/multi-source-news-summary && git add *.txt && git commit -m "Update daily news summary" && git push', { stdio: 'ignore' });
    console.log('摘要已推送到远端仓库');
  } catch (error) {
    console.error('推送远端仓库失败:', error.message);
  }
}

// 执行主函数
main().catch(console.error);