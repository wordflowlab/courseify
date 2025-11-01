#!/usr/bin/env bash
# 生成课程大纲(支持三种模式)

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)
OBJECTIVE_FILE=$(check_objective_exists)
STRUCTURE_FILE=$(check_structure_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
OUTLINE_FILE="$PROJECT_DIR/outline.md"
MODE_FILE="$PROJECT_DIR/.courseify/creation_mode"

# 解析命令行参数
MODE="coach"
while [[ $# -gt 0 ]]; do
    case $1 in
        --mode)
            MODE="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# 读取配置
spec_content=$(cat "$SPEC_FILE")
objective_content=$(cat "$OBJECTIVE_FILE")
structure_content=$(cat "$STRUCTURE_FILE")

# 保存创作模式
echo "$MODE" > "$MODE_FILE"

# 如果已有大纲文件
if [ -f "$OUTLINE_FILE" ]; then
    output_json "{
      \"status\": \"success\",
      \"action\": \"review\",
      \"project_name\": \"$PROJECT_NAME\",
      \"outline_file\": \"$OUTLINE_FILE\",
      \"mode\": \"$MODE\",
      \"spec\": $spec_content,
      \"objective\": $objective_content,
      \"structure\": $structure_content,
      \"message\": \"找到现有大纲，AI 可引导用户修改或审阅\"
    }"
else
    # 创建初始模板
    cat > "$OUTLINE_FILE" <<EOF
# $PROJECT_NAME - 课程大纲

> 创作模式: $MODE

## 课程概述

## 章节大纲

EOF

    output_json "{
      \"status\": \"success\",
      \"action\": \"create\",
      \"project_name\": \"$PROJECT_NAME\",
      \"outline_file\": \"$OUTLINE_FILE\",
      \"mode\": \"$MODE\",
      \"spec\": $spec_content,
      \"objective\": $objective_content,
      \"structure\": $structure_content,
      \"message\": \"已创建大纲模板，AI 应根据模式($MODE)引导用户创作\"
    }"
fi
