#!/bin/bash

# 设置颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

iterations=10000

# 检查并初始化项目结构
init() {
    for dir in encrypt decrypt plain; do
        if [ ! -d "$dir" ]; then
            mkdir "$dir"
            echo -e "${GREEN}创建了目录 $dir${NC}"
        fi
    done
    echo -e "${GREEN}项目初始化完成，在 plain 目录下写些什么，执行后续命令后会自动加密到 encrypt 文件夹中${NC}"
}

# 加密文件
enc() {
    if [ -z "$1" ]; then
        echo -e "${RED}请输入密钥${NC}"
        exit 1
    fi
    if [ ! -d "plain" ] || [ ! -d "encrypt" ]; then
        echo -e "${RED}缺少必要的目录，请先执行 init${NC}"
        exit 1
    fi
    password=$1
    for file in plain/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            enc_filename=$(echo "$filename" | tr '.' '_' ).enc
            openssl enc -aes-256-cbc -salt -iter $iterations -in "$file" -out "encrypt/$enc_filename" -pass pass:$password
            echo -e "${GREEN}已加密: $filename -> $enc_filename${NC}"
        fi
    done
    echo "是否删除 decrypt 和 plain 文件夹下的文件? (输入 y 确认，输入其他或仅回车则否)"
    read -r confirm
    if [ "$confirm" = "y" ]; then
        rm -f decrypt/* plain/*
        echo -e "${GREEN}已删除 decrypt 和 plain 下的文件${NC}"
    fi
}

# 解密文件
dec() {
    if [ -z "$1" ]; then
        echo -e "${RED}请输入密钥${NC}"
        exit 1
    fi
    if [ ! -d "decrypt" ] || [ ! -d "encrypt" ]; then
        echo -e "${RED}缺少必要的目录，请先执行 init${NC}"
        exit 1
    fi
    local password="$1"
    for file in encrypt/*; do
        if [ -f "$file" ]; then
            local base_filename=$(basename "$file" .enc)
            local dec_filename=$(echo "$base_filename" | tr '_' '.')

            if [ -f "decrypt/$dec_filename" ] && [ -f "plain/$dec_filename" ]; then
                local decrypt_hash=$(md5sum "decrypt/$dec_filename" | cut -d ' ' -f 1)
                local plain_hash=$(md5sum "plain/$dec_filename" | cut -d ' ' -f 1)
                if [ "$decrypt_hash" == "$plain_hash" ]; then
                    echo -e "${GREEN}文件 $dec_filename 已存在且 hash 相同，跳过解密${NC}"
                    continue
                fi
            fi

            # 解密前不检查文件是否已存在
            openssl enc -aes-256-cbc -d -iter $iterations -in "$file" -out "decrypt/$dec_filename" -pass pass:$password 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}已解密: $base_filename -> $dec_filename${NC}"
            else
                echo -e "${RED}文件 $base_filename 解密失败，可能是密钥错误${NC}"
                # 移除解密失败的文件
                rm -f "decrypt/$dec_filename"
            fi
        fi
    done
}

# 复制文件
copy() {
    if [ ! -d "decrypt" ] || [ ! -d "plain" ]; then
        echo -e "${RED}缺少必要的目录，请先执行 init${NC}"
        exit 1
    fi
    for file in decrypt/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            if [ -f "plain/$filename" ]; then
                decrypt_hash=$(md5sum "$file" | cut -d ' ' -f 1)
                plain_hash=$(md5sum "plain/$filename" | cut -d ' ' -f 1)
                if [ "$decrypt_hash" == "$plain_hash" ]; then
                    echo -e "${GREEN}文件 $filename 在 plain 目录下已存在且 hash 相同，跳过复制${NC}"
                else
                    echo -e "${RED}文件 $filename 在 plain 目录下已存在但内容不同。是否覆盖？(输入 y 确认，输入其他或仅回车则否)${NC}"
                    read -r confirm
                    if [ "$confirm" = "y" ]; then
                        cp "$file" "plain/$filename"
                        echo -e "${GREEN}已覆盖: $filename${NC}"
                    else
                        echo -e "${RED}未覆盖: $filename${NC}"
                    fi
                fi
            else
                cp "$file" "plain/"
                echo -e "${GREEN}已复制: $filename${NC}"
            fi
        fi
    done
}


# 主逻辑
case $1 in
    init)
        init
        ;;
    enc)
        enc "$2"
        ;;
    dec)
        dec "$2"
        ;;
    copy)
        copy
        ;;
    *)
        echo -e "${RED}可用命令: init, enc <密钥>, dec <密钥>, copy${NC}"
        exit 1
        ;;
esac
