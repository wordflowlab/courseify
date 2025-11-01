#!/bin/bash

# 专栏扫描脚本 - 生成索引和元信息
# 扫描 reference-courses/ 目录下的所有专栏,生成索引文件

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REF_DIR="$PROJECT_ROOT/reference-courses"
INDEX_FILE="$REF_DIR/index.json"

# 检查参考课程目录是否存在
if [[ ! -d "$REF_DIR" ]]; then
    echo '{"status":"error","message":"参考课程目录不存在"}'
    exit 1
fi

# 初始化索引数组
courses_json="[]"

# 遍历所有专栏目录
for course_dir in "$REF_DIR"/*; do
    if [[ -d "$course_dir" ]]; then
        course_name=$(basename "$course_dir")

        # 跳过隐藏文件和 index.json
        [[ "$course_name" == .* ]] && continue
        [[ "$course_name" == "index.json" ]] && continue

        # 统计 Markdown 文件数量
        md_count=$(find "$course_dir" -maxdepth 1 -name "*.md" -type f | wc -l | tr -d ' ')

        # 提取第一个文件的标题作为描述
        first_md=$(find "$course_dir" -maxdepth 1 -name "*.md" -type f | sort | head -1)
        description=""
        if [[ -f "$first_md" ]]; then
            description=$(head -1 "$first_md" | sed 's/^# //' | sed 's/^[0-9]* //')
        fi

        # 智能识别领域
        field="其他"
        case "$course_name" in
            *Flutter*|*MySQL*|*JVM*|*Kubernetes*|*ElasticSearch*|*Spring*|*Rust*)
                field="编程开发" ;;
            *AI*|*数据*)
                field="数据分析" ;;
            *管理*|*产品*)
                field="商业管理" ;;
            *设计*|*DDD*|*领域驱动*)
                field="软件工程" ;;
            *法律*|*财富*|*短视频*)
                field="软技能" ;;
            *Linux*|*性能*)
                field="职业技能" ;;
        esac

        # 智能识别难度
        level="进阶"
        if [[ "$course_name" == *"实战"* ]] || [[ "$course_name" == *"深入"* ]]; then
            level="高级"
        elif [[ "$course_name" == *"入门"* ]] || [[ "$course_name" == *"基础"* ]]; then
            level="入门"
        fi

        # 生成 meta.json
        meta_file="$course_dir/meta.json"
        cat > "$meta_file" <<EOF
{
  "name": "$course_name",
  "field": "$field",
  "level": "$level",
  "chapter_count": $md_count,
  "description": "$description",
  "keywords": [],
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

        # 添加到索引
        course_entry=$(cat <<EOF
{
  "name": "$course_name",
  "field": "$field",
  "level": "$level",
  "chapter_count": $md_count,
  "description": "$description",
  "path": "$course_name"
}
EOF
)

        # 使用 jq 添加到数组(如果安装了 jq)
        if command -v jq &> /dev/null; then
            courses_json=$(echo "$courses_json" | jq ". += [$course_entry]")
        else
            # 手动构建 JSON
            if [[ "$courses_json" == "[]" ]]; then
                courses_json="[$course_entry]"
            else
                courses_json="${courses_json%]}, $course_entry]"
            fi
        fi
    fi
done

# 写入索引文件
cat > "$INDEX_FILE" <<EOF
{
  "version": "1.0.0",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "total_courses": $(echo "$courses_json" | jq 'length' 2>/dev/null || echo 0),
  "courses": $courses_json
}
EOF

# 返回成功信息
echo "{\"status\":\"success\",\"message\":\"已扫描并生成 $md_count 个专栏的索引\",\"index_file\":\"$INDEX_FILE\"}"
