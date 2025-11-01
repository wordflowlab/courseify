#!/usr/bin/env bash
# 导出到多平台

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
EXPORTS_DIR="$PROJECT_DIR/exports"

# 确保导出目录存在
ensure_dir "$EXPORTS_DIR"
ensure_dir "$EXPORTS_DIR/notion"
ensure_dir "$EXPORTS_DIR/feishu"
ensure_dir "$EXPORTS_DIR/netease"

# 读取配置
spec_content=$(cat "$SPEC_FILE")

# 检查可导出的内容
has_outline=false
has_chapters=false
has_exercises=false
has_scripts=false

[ -f "$PROJECT_DIR/outline.md" ] && has_outline=true
[ -d "$PROJECT_DIR/chapters" ] && [ "$(find "$PROJECT_DIR/chapters" -type f -name "*.md" | wc -l)" -gt 0 ] && has_chapters=true
[ -d "$PROJECT_DIR/exercises" ] && [ "$(find "$PROJECT_DIR/exercises" -type f | wc -l)" -gt 0 ] && has_exercises=true
[ -d "$PROJECT_DIR/scripts_output" ] && [ "$(find "$PROJECT_DIR/scripts_output" -type f | wc -l)" -gt 0 ] && has_scripts=true

output_json "{
  \"status\": \"success\",
  \"action\": \"export\",
  \"project_name\": \"$PROJECT_NAME\",
  \"exports_dir\": \"$EXPORTS_DIR\",
  \"spec\": $spec_content,
  \"exportable_content\": {
    \"outline\": $has_outline,
    \"chapters\": $has_chapters,
    \"exercises\": $has_exercises,
    \"scripts\": $has_scripts
  },
  \"message\": \"AI 应引导用户选择导出平台和格式\"
}"
