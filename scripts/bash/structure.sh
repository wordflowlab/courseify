#!/usr/bin/env bash
# 设计课程结构

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)
OBJECTIVE_FILE=$(check_objective_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
STRUCTURE_FILE="$PROJECT_DIR/structure.json"

# 读取配置
spec_content=$(cat "$SPEC_FILE")
objective_content=$(cat "$OBJECTIVE_FILE")

# 如果已有结构文件
if [ -f "$STRUCTURE_FILE" ]; then
    existing_structure=$(cat "$STRUCTURE_FILE")
    output_json "{
      \"status\": \"success\",
      \"action\": \"update\",
      \"project_name\": \"$PROJECT_NAME\",
      \"structure_file\": \"$STRUCTURE_FILE\",
      \"spec\": $spec_content,
      \"objective\": $objective_content,
      \"existing_structure\": $existing_structure,
      \"message\": \"找到现有课程结构，AI 可引导用户更新\"
    }"
else
    # 创建初始模板
    cat > "$STRUCTURE_FILE" <<EOF
{
  "total_duration": "",
  "chapters": []
}
EOF

    output_json "{
      \"status\": \"success\",
      \"action\": \"create\",
      \"project_name\": \"$PROJECT_NAME\",
      \"structure_file\": \"$STRUCTURE_FILE\",
      \"spec\": $spec_content,
      \"objective\": $objective_content,
      \"message\": \"已创建课程结构模板，AI 应引导用户设计章节和课时\",
      \"guidance\": {
        \"total_duration\": \"课程总时长(如 '10小时' 或 '30课时')\",
        \"chapters\": \"章节列表，每章包含: chapter_number, title, duration, lessons[]\"
      }
    }"
fi
