#!/usr/bin/env zsh

# Base path configurations
dst_root_dir="/project/end_of_life/backups"

# Before backup list
initialFiles=$(find "$dst_dir" -type f)

# Relative path
script_path=$(dirname "${BASH_SOURCE[0]}")
end_of_life_py_path="$script_path/../end_of_life.py"

backup_main() {
    src_dir=$1
    dst_dir=$2
    # Execute Python script
    python \
        "$end_of_life_py_path" \
        -i "$src_dir" \
        -o "$dst_dir" \
        -r \
        -k "$dst_root_dir/key" \
        -s "$dst_root_dir/salt" \
        enc
}

# Args
if [ $# -ge 1 ]; then
    declare -A dir_list=(
        ["/Documents/markdown/02_md"]="$dst_root_dir/blogs"
        ["/Users/username/.ssh"]="$dst_root_dir/ssh"
    )
    for src_dir in "${!dir_list[@]}"; do
        dst_dir="${dir_list[$src_dir]}"
        backup_main "$src_dir" "$dst_dir"
    done
elif [ $# -eq 2 ]; then
    src_dir=$1
    dst_dir=$2
    backup_main "$src_dir" "$dst_dir"
else
    echo "Usage: backup.sh [src_dir] [dst_dir]" >&2
    exit 1
fi

# Check new file
currentFiles=$(find "$dst_dir" -type f)
newFiles=$(echo "$currentFiles" | grep -v -F -f <(echo "$initialFiles"))
if [ -n "$newFiles" ]; then
    echo "New files added:"
    echo "$newFiles" | sed "s|$dst_root_dir/||" | xargs -I {} echo {} -e "\033[0;32m"
fi

# Push time check
currentTime=$(date "+%Y-%m-%d %H:%M:%S")
backupTimePath="$dst_root_dir/backup_time"
if [ -f "$backupTimePath" ]; then
    lastBackupTime=$(cat "$backupTimePath")
    lastBackupDateTime=$(date -d "$lastBackupTime" +%s)
    currentDateTime=$(date -d "$currentTime" +%s)
    elapsedDays=$(( ($currentDateTime - $lastBackupDateTime) / 86400 ))
    if [ $elapsedDays -gt 30 ]; then
        echo -e "\033[0;31mWarning: It has been over 30 days since the last push!"
    fi
else
    echo "Creating initial backup time stamp file." -e "\033[0;32m"
    echo "$currentTime" > "$backupTimePath"
fi

echo "Backup process completed." -e "\033[0;32m"
