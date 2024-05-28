#!/usr/bin/env zsh

# Base path configurations
script_path=$(dirname "$0")
end_of_life_py_path="$script_path/../../end_of_life.py"

src_root_dir="$HOME/repo/markdown"
dst_root_dir="$script_path/../blogs"

backup_main() {
    src_dir=$1
    dst_dir=$2
    # Execute Python script
    python3 \
        "$end_of_life_py_path" \
        -i "$src_dir" \
        -o "$dst_dir" \
        -r \
        -k "$script_path/../key" \
        -s "$script_path/../salt" \
        enc
}

backup_main "$src_root_dir" "$dst_root_dir"