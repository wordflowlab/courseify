#!/bin/bash

# 智能推荐脚本 - 根据当前课程规格推荐参考专栏

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/common.sh"

# 读取课程规格
SPEC_FILE="$PROJECT_ROOT/spec.json"
if [[ ! -f "$SPEC_FILE" ]]; then
    echo '{"status":"error","message":"请先运行 /spec 定义课程规格"}'
    exit 1
fi

# 读取参考课程索引
INDEX_FILE="$PROJECT_ROOT/reference-courses/index.json"
if [[ ! -f "$INDEX_FILE" ]]; then
    echo '{"status":"info","message":"未找到参考课程库,请先添加专栏并运行扫描脚本","action":"scan_needed"}'
    exit 0
fi

# 读取当前课程的领域和主题
CURRENT_FIELD=$(jq -r '.field // "未知"' "$SPEC_FILE")
CURRENT_NAME=$(jq -r '.course_name // "未命名课程"' "$SPEC_FILE")
CURRENT_LEVEL=$(jq -r '.level // "进阶"' "$SPEC_FILE")

# 输出推荐信息(JSON格式,供AI解析)
cat <<EOF
{
  "status": "success",
  "action": "recommend",
  "current_course": {
    "name": "$CURRENT_NAME",
    "field": "$CURRENT_FIELD",
    "level": "$CURRENT_LEVEL"
  },
  "index_file": "$INDEX_FILE",
  "message": "已找到参考课程库,请AI分析并推荐Top 3相似课程"
}
EOF
