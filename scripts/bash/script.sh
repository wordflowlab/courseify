#!/usr/bin/env bash
# 生成视频脚本

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
SCRIPTS_DIR="$PROJECT_DIR/scripts_output"

# 确保脚本目录存在
ensure_dir "$SCRIPTS_DIR"

# 读取配置
spec_content=$(cat "$SPEC_FILE")

# 检查是否有章节内容
CHAPTERS_DIR="$PROJECT_DIR/chapters"
has_chapters=false
if [ -d "$CHAPTERS_DIR" ]; then
    has_chapters=true
fi

output_json "{
  \"status\": \"success\",
  \"action\": \"create_scripts\",
  \"project_name\": \"$PROJECT_NAME\",
  \"scripts_dir\": \"$SCRIPTS_DIR\",
  \"spec\": $spec_content,
  \"has_chapters\": $has_chapters,
  \"message\": \"AI 应引导用户生成视频录制脚本\"
}"
