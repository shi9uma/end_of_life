#!/bin/bash

# base config
src_dir=/e/Documents/markdown/02_md
dst_root_dir=/e/project/14_end_of_life/backups
dst_dir=$dst_root_dir/blogs

# args
if [ $# -ge 1 ]; then
    src_dir=$1
fi
if [ $# -ge 2 ]; then
    dst_dir=$2
fi

# rel path
script_path=$(cd "$(dirname "$0")" && pwd)
end_of_life_py_path=$script_path/../end_of_life.py

# exec
python $end_of_life_py_path \
-i $src_dir \
-o $dst_dir \
-r \
-k $dst_root_dir/key \
-s $dst_root_dir/salt \
enc