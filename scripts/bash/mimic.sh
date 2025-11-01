#!/bin/bash

# 风格模拟脚本 - 模拟专栏作者的教学风格

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ACTION="$1"        # list | activate | deactivate | status
AUTHOR_ID="$2"     # 作者ID或名称

PERSONAS_DIR="$PROJECT_ROOT/reference-courses/personas"
MANIFEST_FILE="$PERSONAS_DIR/manifest.json"
ACTIVE_PERSONA_DIR="$PROJECT_ROOT/.courseify"
ACTIVE_PERSONA_FILE="$ACTIVE_PERSONA_DIR/active-persona.yaml"

# 确保配置目录存在
mkdir -p "$ACTIVE_PERSONA_DIR"

# 检查personas目录是否存在
if [[ ! -d "$PERSONAS_DIR" ]]; then
    echo '{"status":"error","message":"未找到personas目录,请先添加作者配置","action":"setup_needed"}'
    exit 1
fi

case "$ACTION" in
  list)
    # 列出所有可用的作者persona
    if [[ ! -f "$MANIFEST_FILE" ]]; then
        echo '{"status":"error","message":"未找到manifest.json,请先扫描专栏"}'
        exit 1
    fi

    # 读取manifest并返回
    PERSONAS_JSON=$(cat "$MANIFEST_FILE")

    echo "{\"status\":\"success\",\"action\":\"list\",\"data\":$PERSONAS_JSON}"
    ;;

  activate)
    # 激活某个作者的风格
    if [[ -z "$AUTHOR_ID" ]]; then
        echo '{"status":"error","message":"请指定作者ID或名称"}'
        exit 1
    fi

    # 查找匹配的persona
    PERSONA_FILE=""

    # 先尝试精确匹配ID
    if [[ -f "$PERSONAS_DIR/$AUTHOR_ID.yaml" ]]; then
        PERSONA_FILE="$PERSONAS_DIR/$AUTHOR_ID.yaml"
    else
        # 尝试从manifest中查找
        if command -v jq &> /dev/null && [[ -f "$MANIFEST_FILE" ]]; then
            # 通过ID查找
            CONFIG_FILE=$(jq -r ".personas[] | select(.id == \"$AUTHOR_ID\") | .config_file" "$MANIFEST_FILE")
            if [[ "$CONFIG_FILE" != "null" && -n "$CONFIG_FILE" ]]; then
                PERSONA_FILE="$PERSONAS_DIR/$CONFIG_FILE"
            else
                # 通过名称查找(不区分大小写)
                CONFIG_FILE=$(jq -r ".personas[] | select(.name | ascii_downcase | contains(\"$(echo $AUTHOR_ID | tr '[:upper:]' '[:lower:]')\")) | .config_file" "$MANIFEST_FILE" | head -1)
                if [[ "$CONFIG_FILE" != "null" && -n "$CONFIG_FILE" ]]; then
                    PERSONA_FILE="$PERSONAS_DIR/$CONFIG_FILE"
                fi
            fi
        fi
    fi

    if [[ -z "$PERSONA_FILE" || ! -f "$PERSONA_FILE" ]]; then
        echo "{\"status\":\"error\",\"message\":\"未找到作者: $AUTHOR_ID\",\"suggestion\":\"使用 /mimic list 查看可用作者\"}"
        exit 1
    fi

    # 复制persona配置到激活文件
    cp "$PERSONA_FILE" "$ACTIVE_PERSONA_FILE"

    # 返回成功信息和persona内容
    cat <<EOF
{
  "status": "success",
  "action": "activate",
  "persona_file": "$ACTIVE_PERSONA_FILE",
  "message": "已激活作者风格,请AI加载并解析配置"
}
EOF
    ;;

  deactivate)
    # 退出风格模拟
    if [[ -f "$ACTIVE_PERSONA_FILE" ]]; then
        rm "$ACTIVE_PERSONA_FILE"
        echo '{"status":"success","action":"deactivate","message":"已退出风格模拟"}'
    else
        echo '{"status":"info","action":"deactivate","message":"当前未激活任何风格"}'
    fi
    ;;

  status)
    # 查看当前激活的风格
    if [[ -f "$ACTIVE_PERSONA_FILE" ]]; then
        echo "{\"status\":\"success\",\"action\":\"status\",\"active\":true,\"persona_file\":\"$ACTIVE_PERSONA_FILE\"}"
    else
        echo '{"status":"success","action":"status","active":false,"message":"当前未激活任何风格"}'
    fi
    ;;

  *)
    # 显示使用帮助
    cat <<EOF
{
  "status":"error",
  "message":"未知操作: $ACTION",
  "usage": {
    "list": "/mimic list - 列出所有可用作者",
    "activate": "/mimic activate <作者名> - 激活某个作者的风格",
    "deactivate": "/mimic deactivate - 退出风格模拟",
    "status": "/mimic status - 查看当前激活的风格"
  }
}
EOF
    exit 1
    ;;
esac
