#!/usr/bin/env bash
# 生成课程大纲 - 分章生成模式

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
OUTLINES_DIR="$PROJECT_DIR/outlines"
PROGRESS_FILE="$PROJECT_DIR/.courseify/outline-progress.json"

# 确保 outlines 目录存在
ensure_dir "$OUTLINES_DIR"

# 解析命令行参数
CHAPTER=""
FROM_CHAPTER=""
RETRY_CHAPTER=""
CONTINUE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --chapter)
            CHAPTER="$2"
            shift 2
            ;;
        --from)
            FROM_CHAPTER="$2"
            shift 2
            ;;
        --retry)
            RETRY_CHAPTER="$2"
            shift 2
            ;;
        --continue)
            CONTINUE=true
            shift
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

# 获取总章节数
total_chapters=$(echo "$structure_content" | jq -r '.chapters | length')

# 读取或初始化进度文件
if [ -f "$PROGRESS_FILE" ]; then
    progress_content=$(cat "$PROGRESS_FILE")
    completed_chapters=$(echo "$progress_content" | jq -r '.completed | join(",")')
    current_chapter=$(echo "$progress_content" | jq -r '.current')
    failed_chapters=$(echo "$progress_content" | jq -r '.failed | join(",")')
else
    completed_chapters=""
    current_chapter=1
    failed_chapters=""
    # 创建初始进度文件
    cat > "$PROGRESS_FILE" <<EOF
{
  "total_chapters": $total_chapters,
  "completed": [],
  "current": 1,
  "failed": [],
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
fi

# 处理特定章节生成
if [ -n "$CHAPTER" ]; then
    current_chapter=$CHAPTER
elif [ -n "$FROM_CHAPTER" ]; then
    current_chapter=$FROM_CHAPTER
elif [ -n "$RETRY_CHAPTER" ]; then
    current_chapter=$RETRY_CHAPTER
elif [ "$CONTINUE" = true ]; then
    # 使用进度文件中的当前章节
    current_chapter=$current_chapter
fi

# 输出给 AI 的 JSON
output_json "{
  \"status\": \"success\",
  \"action\": \"generate_outline\",
  \"project_name\": \"$PROJECT_NAME\",
  \"outlines_dir\": \"$OUTLINES_DIR\",
  \"total_chapters\": $total_chapters,
  \"completed_chapters\": \"$completed_chapters\",
  \"current_chapter\": $current_chapter,
  \"failed_chapters\": \"$failed_chapters\",
  \"spec\": $spec_content,
  \"objective\": $objective_content,
  \"structure\": $structure_content,
  \"progress_file\": \"$PROGRESS_FILE\",
  \"message\": \"AI 应逐章生成大纲,每章保存到独立文件\"
}"
