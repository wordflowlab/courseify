#!/usr/bin/env bash
# 生成练习题

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)
STRUCTURE_FILE=$(check_structure_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
EXERCISES_DIR="$PROJECT_DIR/exercises"

# 确保练习题目录存在
ensure_dir "$EXERCISES_DIR"

# 读取配置
spec_content=$(cat "$SPEC_FILE")
structure_content=$(cat "$STRUCTURE_FILE")

output_json "{
  \"status\": \"success\",
  \"action\": \"create_exercises\",
  \"project_name\": \"$PROJECT_NAME\",
  \"exercises_dir\": \"$EXERCISES_DIR\",
  \"spec\": $spec_content,
  \"structure\": $structure_content,
  \"message\": \"AI 应引导用户为每章生成练习题\"
}"
