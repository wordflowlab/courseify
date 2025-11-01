#!/usr/bin/env bash
# 内容质量评估

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)

# 读取配置
spec_content=$(cat "$SPEC_FILE")

# 检查是否有大纲
OUTLINE_FILE="$PROJECT_DIR/outline.md"
has_outline=false
outline_content=""
if [ -f "$OUTLINE_FILE" ]; then
    has_outline=true
    outline_content=$(read_file_as_json "$OUTLINE_FILE")
fi

# 检查是否有章节内容
CHAPTERS_DIR="$PROJECT_DIR/chapters"
has_chapters=false
chapters_count=0
if [ -d "$CHAPTERS_DIR" ]; then
    chapters_count=$(find "$CHAPTERS_DIR" -type f -name "*.md" | wc -l | tr -d ' ')
    if [ "$chapters_count" -gt 0 ]; then
        has_chapters=true
    fi
fi

output_json "{
  \"status\": \"success\",
  \"action\": \"review\",
  \"project_name\": \"$PROJECT_NAME\",
  \"spec\": $spec_content,
  \"has_outline\": $has_outline,
  \"outline_content\": \"$outline_content\",
  \"has_chapters\": $has_chapters,
  \"chapters_count\": $chapters_count,
  \"message\": \"AI 应对课程内容进行质量评估\"
}"
