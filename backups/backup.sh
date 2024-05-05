#!/bin/bash

# Base path configs
src_dir="/e/Documents/markdown/02_md"
dst_root_dir="/e/project/03_end_of_life/backups"
dst_dir="$dst_root_dir/blogs"

# Args
if [ $# -ge 1 ]; then
    src_dir=$1
fi
if [ $# -ge 2 ]; then
    dst_dir=$2
fi

# Before backup list
initial_files=$(find $dst_dir -type f)

# Rel path
script_path=$(dirname "$0")
end_of_life_py_path="$script_path/../end_of_life.py"

# Exec
python $end_of_life_py_path \
-i "$src_dir" \
-o "$dst_dir" \
-r \
-k "$dst_root_dir/key" \
-s "$dst_root_dir/salt" \
enc

# check new file
current_files=$(find $dst_dir -type f)
new_files=$(comm -13 <(echo "$initial_files") <(echo "$current_files"))
if [ -n "$new_files" ]; then
    echo "New files added:"
    echo "$new_files" | sed "s|$dst_root_dir/||g" | awk '{print $0}' | GREP_COLOR='01;32' grep --color=always "^"
fi

# push time check
current_time=$(date "+%Y-%m-%d %H:%M:%S")
backup_time_path="$dst_root_dir/backup_time"
if [ -f "$backup_time_path" ]; then
    last_backup_time=$(cat "$backup_time_path")
    last_backup_datetime=$(date -d "$last_backup_time" +%s)
    current_datetime=$(date -d "$current_time" +%s)
    elapsed_days=$(( ($current_datetime - $last_backup_datetime) / 86400 ))
    if [ $elapsed_days -gt 30 ]; then
        echo -e "\033[0;31mWarning: It has been over 30 days since the last push!\033[0m"
    fi
else
    echo -e "\033[0;32mCreating initial backup time stamp file.\033[0m"
    echo "$current_time" > "$backup_time_path"
fi

echo -e "\033[0;32mBackup process completed.\033[0m"
