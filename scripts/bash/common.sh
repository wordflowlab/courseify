#!/usr/bin/env bash
# Courseify 通用函数库

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 查找 courseify 项目根目录（向上查找 .courseify/config.json）
get_current_project() {
    local current_dir="$PWD"

    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/.courseify/config.json" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir=$(dirname "$current_dir")
    done

    # 如果没找到，返回当前目录
    echo "$PWD"
    return 0
}

# 获取项目名称
get_project_name() {
    local project_dir=$(get_current_project)
    basename "$project_dir"
}

# 检查 spec.json 是否存在
check_spec_exists() {
    local project_dir=$(get_current_project)
    local spec_file="$project_dir/spec.json"

    if [ ! -f "$spec_file" ]; then
        output_json "{
            \"status\": \"error\",
            \"message\": \"未找到 spec.json。请先运行 /spec 命令定义课程规格。\"
        }"
        exit 1
    fi

    echo "$spec_file"
}

# 检查 objective.json 是否存在
check_objective_exists() {
    local project_dir=$(get_current_project)
    local objective_file="$project_dir/objective.json"

    if [ ! -f "$objective_file" ]; then
        output_json "{
            \"status\": \"error\",
            \"message\": \"未找到 objective.json。请先运行 /objective 命令设定学习目标。\"
        }"
        exit 1
    fi

    echo "$objective_file"
}

# 检查 structure.json 是否存在
check_structure_exists() {
    local project_dir=$(get_current_project)
    local structure_file="$project_dir/structure.json"

    if [ ! -f "$structure_file" ]; then
        output_json "{
            \"status\": \"error\",
            \"message\": \"未找到 structure.json。请先运行 /structure 命令设计课程结构。\"
        }"
        exit 1
    fi

    echo "$structure_file"
}

# 输出 JSON 格式结果（转义特殊字符）
output_json() {
    echo "$1"
}

# 转义 JSON 字符串中的特殊字符
escape_json() {
    local string="$1"
    # 转义反斜杠
    string="${string//\\/\\\\}"
    # 转义双引号
    string="${string//\"/\\\"}"
    # 转义换行符
    string="${string//$'\n'/\\n}"
    # 转义制表符
    string="${string//$'\t'/\\t}"
    # 转义回车符
    string="${string//$'\r'/\\r}"
    echo "$string"
}

# 读取文件内容并转义为 JSON 字符串
read_file_as_json() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        local content=$(cat "$file_path")
        escape_json "$content"
    else
        echo ""
    fi
}

# 统计字数（中文字符数）
count_words() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        # 统计中文字符数
        local count=$(grep -v '^#' "$file_path" | grep -v '^$' | \
                     sed 's/[a-zA-Z0-9[:space:][:punct:]]//g' | \
                     awk '{for(i=1;i<=length($0);i++) count++} END {print count+0}')
        echo "$count"
    else
        echo "0"
    fi
}

# 统计文件行数（排除空行和注释）
count_file_lines() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        grep -v '^#' "$file_path" | grep -v '^$' | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# 获取文件最后修改时间
get_file_mtime() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file_path"
        else
            # Linux
            stat -c "%y" "$file_path" | cut -d'.' -f1
        fi
    else
        echo ""
    fi
}

# 获取当前时间戳 (ISO 8601)
get_current_timestamp() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# 检查文件是否存在
file_exists() {
    [ -f "$1" ]
}

# 确保目录存在
ensure_dir() {
    mkdir -p "$1"
}

# 错误处理
error_exit() {
    local message="$1"
    output_json "{
        \"status\": \"error\",
        \"message\": \"$(escape_json "$message")\"
    }"
    exit 1
}

# 成功输出
success_output() {
    local message="$1"
    local data="$2"

    if [ -n "$data" ]; then
        output_json "{
            \"status\": \"success\",
            \"message\": \"$(escape_json "$message")\",
            $data
        }"
    else
        output_json "{
            \"status\": \"success\",
            \"message\": \"$(escape_json "$message")\"
        }"
    fi
}
