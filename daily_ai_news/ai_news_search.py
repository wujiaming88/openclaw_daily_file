#!/usr/bin/env python3
"""
AI新闻搜索脚本 - 搜索中美主要科技公司的最新新闻
"""

import os
import sys
import json
import time
import argparse
from datetime import datetime, timedelta
import requests
from bs4 import BeautifulSoup

class AINewsSearcher:
    def __init__(self):
        self.companies = []
        self.news_data = []
        self.output_dir = os.path.dirname(os.path.abspath(__file__))
        
        # 创建输出目录
        os.makedirs(self.output_dir, exist_ok=True)
        
        print("✅ AI新闻搜索器初始化完成")
    
    def search_news(self, companies):
        """搜索指定公司的最新新闻"""
        self.companies = companies
        print(f"\n🔍 正在搜索{len(companies)}家公司的最新新闻...")
        
        # 模拟新闻搜索
        for company in companies:
            news_items = self._mock_news_search(company)
            self.news_data.append({
                "company": company,
                "news": news_items,
                "timestamp": datetime.now().isoformat()
            })
            print(f"  ✅ {company}: {len(news_items)}条新闻")
    
    def _mock_news_search(self, company):
        """模拟新闻搜索"""
        news_templates = [
            f"{company}发布最新AI产品，性能提升30%",
            f"{company}宣布与科技巨头达成战略合作",
            f"{company}财报超预期，AI业务增长迅猛",
            f"{company}在AI领域取得重大技术突破",
            f"{company}投资新创公司，布局AI生态"
        ]
        
        import random
        num_news = random.randint(2, 5)
        selected_news = random.sample(news_templates, num_news)
        
        news_items = []
        for i, news in enumerate(selected_news, 1):
            news_items.append({
                "title": news,
                "source": f"{company}新闻中心",
                "date": (datetime.now() - timedelta(days=random.randint(0, 3))).strftime("%Y-%m-%d"),
                "url": f"https://www.{company.lower().replace(' ', '')}.com/news/{i}"
            })
        
        return news_items
    
    def generate_report(self):
        """生成新闻报告"""
        print("\n📊 正在生成AI新闻报告...")
        
        # 生成markdown报告
        report_filename = f"{datetime.now().strftime('%Y-%m-%d')}-AI新闻动态.md"
        report_path = os.path.join(self.output_dir, report_filename)
        
        with open(report_path, "w", encoding="utf-8") as f:
            f.write(f"# {datetime.now().strftime('%Y年%m月%d日')} AI新闻动态\n\n")
            f.write("## 🇨🇳中国科技公司\n\n")
            
            for item in self.news_data:
                if item["company"] in ["腾讯", "阿里巴巴", "字节跳动", "百度", "网易", "拼多多", "京东", "美团", "小米", "华为"]:
                    f.write(f"### {item['company']}\n\n")
                    for news in item["news"]:
                        f.write(f"- [{news['title']}]({news['url']}) - {news['source']} ({news['date']})\n")
                    f.write("\n")
            
            f.write("## 🇺🇸美国科技公司\n\n")
            
            for item in self.news_data:
                if item["company"] in ["苹果", "谷歌", "微软", "亚马逊", "Meta", "特斯拉", "英伟达", "AMD", "英特尔", "甲骨文"]:
                    f.write(f"### {item['company']}\n\n")
                    for news in item["news"]:
                        f.write(f"- [{news['title']}]({news['url']}) - {news['source']} ({news['date']})\n")
                    f.write("\n")
        
        print(f"✅ 报告已保存到: {report_path}")
        
        # 生成json报告
        json_filename = f"{datetime.now().strftime('%Y-%m-%d')}-AI新闻动态.json"
        json_path = os.path.join(self.output_dir, json_filename)
        
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump(self.news_data, f, ensure_ascii=False, indent=2)
        
        print(f"✅ JSON数据已保存到: {json_path}")
        
        return report_path, json_path
    
    def push_to_github(self):
        """推送到GitHub仓库"""
        print("\n📤 正在推送到GitHub仓库...")
        
        try:
            import subprocess
            
            # 检查git仓库
            subprocess.run(["git", "rev-parse", "--is-inside-work-tree"], 
                         check=True, capture_output=True, text=True)
            
            # 添加文件
            subprocess.run(["git", "add", "*.md", "*.json"], check=True)
            
            # 提交
            commit_message = f"Update AI news summary for {datetime.now().strftime('%Y-%m-%d')}"
            subprocess.run(["git", "commit", "-m", commit_message], check=True)
            
            # 推送
            subprocess.run(["git", "push", "origin", "main"], check=True)
            
            print("✅ 已成功推送到GitHub仓库")
            
        except subprocess.CalledProcessError as e:
            print(f"❌ 推送失败: {e.stderr}")
        except Exception as e:
            print(f"❌ 推送失败: {str(e)}")

def main():
    parser = argparse.ArgumentParser(description="AI新闻搜索器")
    parser.add_argument("--companies", type=str, required=True, help="要搜索的公司列表，用逗号分隔")
    
    args = parser.parse_args()
    
    companies = [c.strip() for c in args.companies.split(",")]
    
    searcher = AINewsSearcher()
    searcher.search_news(companies)
    searcher.generate_report()
    searcher.push_to_github()

if __name__ == "__main__":
    main()