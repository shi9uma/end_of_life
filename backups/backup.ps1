# base path config
$src_dir = "E:\Documents\markdown\02_md"
$dst_root_dir = "E:\project\14_end_of_life\backups"
$dst_dir = "$dst_root_dir\blogs"

# args
if ($args.Count -ge 1) {
    $src_dir = $args[0]
}
if ($args.Count -ge 2) {
    $dst_dir = $args[1]
}

# rel path
$script_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
$end_of_life_py_path = Join-Path $script_path "..\end_of_life.py"

# exec
& python $end_of_life_py_path `
-i $src_dir `
-o $dst_dir `
-r `
-k "$dst_root_dir\key" `
-s "$dst_root_dir\salt" `
enc