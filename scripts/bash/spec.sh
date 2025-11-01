#!/usr/bin/env bash
# 定义/更新课程规格

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 获取项目路径
PROJECT_DIR=$(get_current_project)
PROJECT_NAME=$(get_project_name)

SPEC_FILE="$PROJECT_DIR/spec.json"
CONFIG_FILE="$PROJECT_DIR/.courseify/config.json"

# 读取 config.json 中的 defaultField (如果存在)
DEFAULT_FIELD=""
if [ -f "$CONFIG_FILE" ]; then
    DEFAULT_FIELD=$(grep -o '"defaultField"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | \
                   sed 's/"defaultField"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')
fi

# 如果已有配置，读取现有配置
if [ -f "$SPEC_FILE" ]; then
    existing_config=$(cat "$SPEC_FILE")
    output_json "{
      \"status\": \"success\",
      \"action\": \"update\",
      \"project_name\": \"$PROJECT_NAME\",
      \"project_path\": \"$PROJECT_DIR\",
      \"spec_file\": \"$SPEC_FILE\",
      \"existing_config\": $existing_config,
      \"message\": \"找到现有配置，AI 可引导用户更新\"
    }"
else
    # 创建初始配置模板
    cat > "$SPEC_FILE" <<EOF
{
  "course_name": "$PROJECT_NAME",
  "field": "$DEFAULT_FIELD",
  "level": "",
  "duration": "",
  "audience": "",
  "format": "",
  "platforms": [],
  "language": "",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

    output_json "{
      \"status\": \"success\",
      \"action\": \"create\",
      \"project_name\": \"$PROJECT_NAME\",
      \"project_path\": \"$PROJECT_DIR\",
      \"spec_file\": \"$SPEC_FILE\",
      \"default_field\": \"$DEFAULT_FIELD\",
      \"message\": \"已创建配置模板，AI 应引导用户填写\",
      \"required_fields\": [
        \"field (领域): 编程开发/设计创意/商业管理/语言学习等\",
        \"level (难度): 入门/进阶/高级\",
        \"duration (时长): 如 '10小时' 或 '30课时'\",
        \"audience (受众): 学生/职场新人/职场老手/专业人士等\",
        \"format (格式): video/text/audio/mixed\",
        \"platforms (平台): 网易云课堂/腾讯课堂/B站/Notion/飞书等\",
        \"language (语言): 中文/英文/双语\"
      ]
    }"
fi
