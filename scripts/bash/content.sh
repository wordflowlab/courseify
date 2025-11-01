#!/usr/bin/env bash
# 创作章节内容

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)
STRUCTURE_FILE=$(check_structure_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
CHAPTERS_DIR="$PROJECT_DIR/chapters"

# 确保章节目录存在
ensure_dir "$CHAPTERS_DIR"

# 读取配置
spec_content=$(cat "$SPEC_FILE")
structure_content=$(cat "$STRUCTURE_FILE")

# 检查大纲文件
OUTLINE_FILE="$PROJECT_DIR/outline.md"
outline_exists=false
outline_content=""
if [ -f "$OUTLINE_FILE" ]; then
    outline_exists=true
    outline_content=$(read_file_as_json "$OUTLINE_FILE")
fi

output_json "{
  \"status\": \"success\",
  \"action\": \"create_content\",
  \"project_name\": \"$PROJECT_NAME\",
  \"chapters_dir\": \"$CHAPTERS_DIR\",
  \"spec\": $spec_content,
  \"structure\": $structure_content,
  \"outline_exists\": $outline_exists,
  \"outline_content\": \"$outline_content\",
  \"message\": \"AI 应引导用户逐章创作内容\"
}"
