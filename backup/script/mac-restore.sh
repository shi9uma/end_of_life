#!/usr/bin/env zsh

# Base path configurations
root_dir="$HOME/repo/project/03_end_of_life"
end_of_life_py_path="$root_dir/end_of_life.py"

src_root_dir="$root_dir/backups/blogs"
dst_root_dir="$HOME/repo/markdown"

restore_main() {
    src_dir=$1
    dst_dir=$2
    # Execute Python script
    python3 \
        "$end_of_life_py_path" \
        -i "$src_dir" \
        -o "$dst_dir" \
        -r \
        -k "$root_dir/backups/key" \
        -s "$root_dir/backups/salt" \
        dec
}

restore_main "$src_root_dir" "$dst_root_dir"