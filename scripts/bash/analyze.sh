#!/bin/bash

# 专栏结构分析脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 获取参数 - 专栏名称
COURSE_NAME="$1"

if [[ -z "$COURSE_NAME" ]]; then
    echo '{"status":"error","message":"请指定专栏名称,例如: /analyze Flutter核心技术与实战"}'
    exit 1
fi

# 检查专栏目录是否存在
COURSE_DIR="$PROJECT_ROOT/reference-courses/$COURSE_NAME"
if [[ ! -d "$COURSE_DIR" ]]; then
    echo "{\"status\":\"error\",\"message\":\"未找到专栏: $COURSE_NAME\"}"
    exit 1
fi

# 读取专栏元信息
META_FILE="$COURSE_DIR/meta.json"
if [[ ! -f "$META_FILE" ]]; then
    echo "{\"status\":\"error\",\"message\":\"专栏元信息缺失,请运行扫描脚本\"}"
    exit 1
fi

# 统计章节信息
TOTAL_CHAPTERS=$(find "$COURSE_DIR" -maxdepth 1 -name "*.md" -type f | wc -l | tr -d ' ')

# 读取所有章节标题
CHAPTERS_JSON="[]"
while IFS= read -r md_file; do
    # 提取序号和标题
    filename=$(basename "$md_file")
    title=$(head -1 "$md_file" | sed 's/^# //')

    # 提取序号(如果有)
    number=""
    if [[ "$filename" =~ ^([0-9]+) ]]; then
        number="${BASH_REMATCH[1]}"
    fi

    # 构建章节对象
    chapter_obj=$(cat <<EOF
{
  "number": "$number",
  "title": "$title",
  "filename": "$filename"
}
EOF
)

    # 添加到数组
    if command -v jq &> /dev/null; then
        CHAPTERS_JSON=$(echo "$CHAPTERS_JSON" | jq ". += [$chapter_obj]")
    fi
done < <(find "$COURSE_DIR" -maxdepth 1 -name "*.md" -type f | sort)

# 读取元信息
FIELD=$(jq -r '.field' "$META_FILE")
LEVEL=$(jq -r '.level' "$META_FILE")
DESCRIPTION=$(jq -r '.description' "$META_FILE")

# 返回分析数据
cat <<EOF
{
  "status": "success",
  "action": "analyze",
  "course": {
    "name": "$COURSE_NAME",
    "field": "$FIELD",
    "level": "$LEVEL",
    "description": "$DESCRIPTION",
    "total_chapters": $TOTAL_CHAPTERS,
    "course_dir": "$COURSE_DIR"
  },
  "chapters": $CHAPTERS_JSON,
  "message": "请AI分析章节结构并生成可视化报告"
}
EOF
