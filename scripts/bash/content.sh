#!/usr/bin/env bash
# 创作章节内容 - 分课时生成模式

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
OUTLINES_DIR="$PROJECT_DIR/outlines"
PROGRESS_FILE="$PROJECT_DIR/.courseify/content-progress.json"

# 确保章节目录存在
ensure_dir "$CHAPTERS_DIR"

# 解析命令行参数
CHAPTER=""
LESSON=""
FROM_CHAPTER=""
FROM_LESSON=""
RETRY_CHAPTER=""
RETRY_LESSON=""
CONTINUE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --chapter)
            CHAPTER="$2"
            shift 2
            ;;
        --lesson)
            LESSON="$2"
            shift 2
            ;;
        --from-chapter)
            FROM_CHAPTER="$2"
            shift 2
            ;;
        --from-lesson)
            FROM_LESSON="$2"
            shift 2
            ;;
        --retry-chapter)
            RETRY_CHAPTER="$2"
            shift 2
            ;;
        --retry-lesson)
            RETRY_LESSON="$2"
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
structure_content=$(cat "$STRUCTURE_FILE")

# 获取总章节数
total_chapters=$(echo "$structure_content" | jq -r '.chapters | length')

# 读取大纲文件
outline_files=()
outline_data="{}"
if [ -d "$OUTLINES_DIR" ]; then
    for file in "$OUTLINES_DIR"/chapter-*.md; do
        if [ -f "$file" ]; then
            chapter_num=$(basename "$file" | sed 's/chapter-//;s/\.md$//' | sed 's/^0*//')
            outline_files+=("$file")
            content=$(read_file_as_json "$file")
            outline_data=$(echo "$outline_data" | jq --arg num "$chapter_num" --arg content "$content" '. + {($num): $content}')
        fi
    done
fi

# 读取或初始化进度文件
if [ -f "$PROGRESS_FILE" ]; then
    progress_content=$(cat "$PROGRESS_FILE")
    completed_items=$(echo "$progress_content" | jq -r '.completed | map("\(.chapter):\(.lesson)") | join(",")')
    current_chapter=$(echo "$progress_content" | jq -r '.current_chapter')
    current_lesson=$(echo "$progress_content" | jq -r '.current_lesson')
    failed_items=$(echo "$progress_content" | jq -r '.failed | map("\(.chapter):\(.lesson)") | join(",")')
else
    completed_items=""
    current_chapter=1
    current_lesson=1
    failed_items=""
    # 创建初始进度文件
    cat > "$PROGRESS_FILE" <<EOF
{
  "total_chapters": $total_chapters,
  "completed": [],
  "current_chapter": 1,
  "current_lesson": 1,
  "failed": [],
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
fi

# 处理特定章节/课时生成
if [ -n "$CHAPTER" ]; then
    current_chapter=$CHAPTER
    if [ -n "$LESSON" ]; then
        current_lesson=$LESSON
    else
        current_lesson=1
    fi
elif [ -n "$FROM_CHAPTER" ]; then
    current_chapter=$FROM_CHAPTER
    if [ -n "$FROM_LESSON" ]; then
        current_lesson=$FROM_LESSON
    else
        current_lesson=1
    fi
elif [ -n "$RETRY_CHAPTER" ]; then
    current_chapter=$RETRY_CHAPTER
    if [ -n "$RETRY_LESSON" ]; then
        current_lesson=$RETRY_LESSON
    else
        current_lesson=1
    fi
elif [ "$CONTINUE" = true ]; then
    # 使用进度文件中的当前位置
    current_chapter=$current_chapter
    current_lesson=$current_lesson
fi

# 输出给 AI 的 JSON
output_json "{
  \"status\": \"success\",
  \"action\": \"generate_content\",
  \"project_name\": \"$PROJECT_NAME\",
  \"chapters_dir\": \"$CHAPTERS_DIR\",
  \"outlines_dir\": \"$OUTLINES_DIR\",
  \"total_chapters\": $total_chapters,
  \"completed_items\": \"$completed_items\",
  \"current_chapter\": $current_chapter,
  \"current_lesson\": $current_lesson,
  \"failed_items\": \"$failed_items\",
  \"spec\": $spec_content,
  \"structure\": $structure_content,
  \"outlines\": $outline_data,
  \"progress_file\": \"$PROGRESS_FILE\",
  \"message\": \"AI 应逐章逐课时生成内容,每课时保存到独立文件\"
}"
