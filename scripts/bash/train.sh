#!/bin/bash

# Persona 训练脚本 - 从专栏中自动提取作者教学风格

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ACTION="$1"        # 专栏名 | --scan-all | 空(交互)

COLUMNS_DIR="$PROJECT_ROOT/reference-courses"
PERSONAS_DIR="$COLUMNS_DIR/personas"
MANIFEST_FILE="$PERSONAS_DIR/manifest.json"

# 确保 personas 目录存在
mkdir -p "$PERSONAS_DIR"

# 检查是否有专栏数据
if [[ ! -d "$COLUMNS_DIR" ]] || [[ -z "$(ls -A "$COLUMNS_DIR" 2>/dev/null | grep -v personas | grep -v index.json | grep -v README.md)" ]]; then
    cat <<EOF
{
  "status": "error",
  "action": "no_columns",
  "message": "未找到专栏数据",
  "suggestion": "请先将专栏资料复制到 reference-courses/ 目录",
  "help": {
    "step1": "cp -r ~/Downloads/专栏/* reference-courses/",
    "step2": "bash scripts/bash/scan-references.sh",
    "step3": "bash scripts/bash/train.sh"
  }
}
EOF
    exit 1
fi

# 读取索引文件,获取所有专栏
if [[ ! -f "$COLUMNS_DIR/index.json" ]]; then
    cat <<EOF
{
  "status": "error",
  "action": "no_index",
  "message": "未找到专栏索引文件",
  "suggestion": "请先运行扫描脚本生成索引",
  "command": "bash scripts/bash/scan-references.sh"
}
EOF
    exit 1
fi

# 函数: 分析单个专栏
analyze_column() {
    local COLUMN_PATH="$1"
    local COLUMN_NAME="$2"

    # 读取专栏目录下的所有 MD 文件
    local MD_FILES=($(find "$COLUMN_PATH" -maxdepth 1 -name "*.md" -type f | sort))

    if [[ ${#MD_FILES[@]} -eq 0 ]]; then
        echo '{"status":"error","message":"未找到章节文件"}' >&2
        return 1
    fi

    # 提取章节列表 (文件名)
    local CHAPTERS=()
    for file in "${MD_FILES[@]}"; do
        CHAPTERS+=("$(basename "$file")")
    done

    # 采样读取 3-5 个章节内容 (第1章、中间章、最后章)
    local TOTAL=${#MD_FILES[@]}
    local SAMPLE_INDICES=()

    # 第1章
    SAMPLE_INDICES+=(0)

    # 中间章 (2-3个)
    if [[ $TOTAL -gt 10 ]]; then
        SAMPLE_INDICES+=($((TOTAL / 3)))
        SAMPLE_INDICES+=($((TOTAL / 2)))
        SAMPLE_INDICES+=($((TOTAL * 2 / 3)))
    elif [[ $TOTAL -gt 5 ]]; then
        SAMPLE_INDICES+=($((TOTAL / 2)))
    fi

    # 最后章
    if [[ $TOTAL -gt 1 ]]; then
        SAMPLE_INDICES+=($((TOTAL - 1)))
    fi

    # 读取采样章节内容
    local SAMPLE_CONTENT=""
    for idx in "${SAMPLE_INDICES[@]}"; do
        local file="${MD_FILES[$idx]}"
        local filename=$(basename "$file")
        local content=$(head -n 200 "$file")  # 每个章节最多读 200 行

        SAMPLE_CONTENT+="【章节: $filename】\n"
        SAMPLE_CONTENT+="$content\n"
        SAMPLE_CONTENT+="\n---\n\n"
    done

    # 从 index.json 中读取专栏信息
    local COLUMN_INFO=$(jq -r ".courses[] | select(.name == \"$COLUMN_NAME\")" "$COLUMNS_DIR/index.json")

    if [[ -z "$COLUMN_INFO" || "$COLUMN_INFO" == "null" ]]; then
        echo '{"status":"error","message":"未在索引中找到该专栏"}' >&2
        return 1
    fi

    local FIELD=$(echo "$COLUMN_INFO" | jq -r '.field')
    local LEVEL=$(echo "$COLUMN_INFO" | jq -r '.level')
    local CHAPTER_COUNT=$(echo "$COLUMN_INFO" | jq -r '.chapter_count')

    # 返回分析数据给 AI
    cat <<EOF
{
  "status": "success",
  "action": "analyze",
  "column": {
    "name": "$COLUMN_NAME",
    "field": "$FIELD",
    "level": "$LEVEL",
    "chapter_count": $CHAPTER_COUNT,
    "path": "$COLUMN_PATH"
  },
  "analysis_data": {
    "total_chapters": ${#MD_FILES[@]},
    "chapter_files": $(printf '%s\n' "${CHAPTERS[@]}" | jq -R . | jq -s .),
    "sample_count": ${#SAMPLE_INDICES[@]},
    "sample_content": $(echo -e "$SAMPLE_CONTENT" | jq -R -s .)
  },
  "instruction": "AI 请分析以上数据,生成 persona.yaml 配置"
}
EOF
}

# 函数: 保存 persona 配置
save_persona() {
    local PERSONA_ID="$1"
    local PERSONA_FILE="$2"

    if [[ -f "$PERSONAS_DIR/$PERSONA_FILE" ]]; then
        echo "{\"status\":\"success\",\"action\":\"saved\",\"file\":\"$PERSONAS_DIR/$PERSONA_FILE\",\"note\":\"已覆盖现有文件\"}"
    else
        echo "{\"status\":\"success\",\"action\":\"saved\",\"file\":\"$PERSONAS_DIR/$PERSONA_FILE\"}"
    fi
}

# 主逻辑
case "$ACTION" in
  --scan-all)
    # 批量扫描所有专栏
    COURSES=$(jq -r '.courses[].name' "$COLUMNS_DIR/index.json")
    COURSE_COUNT=$(echo "$COURSES" | wc -l | tr -d ' ')

    cat <<EOF
{
  "status": "success",
  "action": "scan_all",
  "total_courses": $COURSE_COUNT,
  "courses": $(echo "$COURSES" | jq -R . | jq -s .),
  "instruction": "AI 请逐个分析这些专栏,为每个生成 persona"
}
EOF
    ;;

  "")
    # 交互式向导
    COURSES=$(jq -r '.courses[] | "\(.name)|\(.field)|\(.level)|\(.chapter_count)"' "$COLUMNS_DIR/index.json")
    COURSE_COUNT=$(echo "$COURSES" | wc -l | tr -d ' ')

    cat <<EOF
{
  "status": "success",
  "action": "interactive",
  "total_courses": $COURSE_COUNT,
  "courses": $(echo "$COURSES" | while IFS='|' read -r name field level count; do
    echo "{\"name\":\"$name\",\"field\":\"$field\",\"level\":\"$level\",\"chapter_count\":$count}"
  done | jq -s .),
  "instruction": "AI 请引导用户选择要训练的专栏"
}
EOF
    ;;

  *)
    # 训练指定专栏
    COLUMN_NAME="$ACTION"

    # 查找专栏路径
    COLUMN_INFO=$(jq -r ".courses[] | select(.name == \"$COLUMN_NAME\") | .path" "$COLUMNS_DIR/index.json")

    if [[ -z "$COLUMN_INFO" || "$COLUMN_INFO" == "null" ]]; then
        cat <<EOF
{
  "status": "error",
  "action": "not_found",
  "message": "未找到专栏: $COLUMN_NAME",
  "suggestion": "使用 /train 查看所有可用专栏"
}
EOF
        exit 1
    fi

    COLUMN_PATH="$PROJECT_ROOT/$COLUMN_INFO"

    # 分析专栏
    analyze_column "$COLUMN_PATH" "$COLUMN_NAME"
    ;;
esac
