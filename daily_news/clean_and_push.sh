#!/bin/bash
"""
清理中间文件并推送最终报告
"""

echo "🧹 清理中间文件..."

# 删除JSON中间文件
rm -f *.json

# 删除临时文件
rm -f *.tmp *.log *.bak

# 清理编辑器文件
rm -f *.swp *.swo *~

# 清理Python缓存
rm -rf __pycache__/

echo "✅ 中间文件已清理"

echo "📤 推送最终报告..."

git add *.md
git commit -m "Update news broadcast report"
git push
echo "✅ 最终报告已推送"

echo "🎉 操作完成！"