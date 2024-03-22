#!/bin/bash

# 显示字符集
showCharSet() {
    echo "string.ascii_letters => abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    echo "string.digits => 0123456789"
    echo
}

# 生成随机字符串函数
func() {
    local length="$1"
    local seed="$2"
    local charSet="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-#."
    
    # 如果长度未指定，默认为15
    if [ -z "$length" ]; then
        length=15
    fi
    
    # 如果种子未指定，使用当前时间戳
    if [ -z "$seed" ]; then
        seed=$(date +%s)
    fi
    
    # 设置随机种子
    RANDOM=$seed
    
    local result=""
    local charSetLength=${#charSet}
    for (( i=0; i<$length; i++ )); do
        local rand=$(( RANDOM % charSetLength ))
        result="${result}${charSet:$rand:1}"
    done
    
    echo "$result"
}

# 主执行逻辑
if [ "$1" == "show" ]; then
    showCharSet
else
    length=${1:-32} # 如果未指定长度，默认为32
    seed=$2
    func "$length" "$seed"
fi
