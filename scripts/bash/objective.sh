#!/usr/bin/env bash
# 设定学习目标

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 检查前置条件
SPEC_FILE=$(check_spec_exists)

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)
OBJECTIVE_FILE="$PROJECT_DIR/objective.json"

# 读取 spec 配置
spec_content=$(cat "$SPEC_FILE")

# 如果已有目标文件
if [ -f "$OBJECTIVE_FILE" ]; then
    existing_objective=$(cat "$OBJECTIVE_FILE")
    output_json "{
      \"status\": \"success\",
      \"action\": \"update\",
      \"project_name\": \"$PROJECT_NAME\",
      \"objective_file\": \"$OBJECTIVE_FILE\",
      \"spec\": $spec_content,
      \"existing_objective\": $existing_objective,
      \"message\": \"找到现有学习目标，AI 可引导用户更新\"
    }"
else
    # 创建初始模板
    cat > "$OBJECTIVE_FILE" <<EOF
{
  "knowledge": [],
  "skills": [],
  "outcomes": []
}
EOF

    output_json "{
      \"status\": \"success\",
      \"action\": \"create\",
      \"project_name\": \"$PROJECT_NAME\",
      \"objective_file\": \"$OBJECTIVE_FILE\",
      \"spec\": $spec_content,
      \"message\": \"已创建学习目标模板，AI 应引导用户填写\",
      \"guidance\": {
        \"knowledge\": \"学员将学到的知识点列表\",
        \"skills\": \"学员将掌握的技能列表\",
        \"outcomes\": \"学完后能够做到的具体成果\"
      }
    }"
fi
