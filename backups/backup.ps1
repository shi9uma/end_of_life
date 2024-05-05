# base path configs
$src_dir = "E:/Documents/markdown/02_md"
$dst_root_dir = "E:/project/03_end_of_life/backups"
$dst_dir = "$dst_root_dir/blogs"

# args
if ($args.Count -ge 1) {
    $src_dir = $args[0]
}
if ($args.Count -ge 2) {
    $dst_dir = $args[1]
}

# before backup list
$initialFiles = Get-ChildItem -Path $dst_dir -Recurse -File | Select-Object -ExpandProperty FullName

# rel path
$script_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
$end_of_life_py_path = Join-Path $script_path "../end_of_life.py"

# exec
& python $end_of_life_py_path `
-i $src_dir `
-o $dst_dir `
-r `
-k "$dst_root_dir/key" `
-s "$dst_root_dir/salt" `
enc

# check new file
$currentFiles = Get-ChildItem -Path $dst_dir -Recurse -File | Select-Object -ExpandProperty FullName
$newFiles = $currentFiles | Where-Object { $_ -notin $initialFiles }
if ($newFiles) {
    Write-Host "New files added:"
    $newFiles | ForEach-Object { Write-Host $_.Replace("$dst_root_dir/", "") -ForegroundColor Green }
}

# push time check
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$backupTimePath = "$dst_root_dir/backup_time"
if (Test-Path $backupTimePath) {
    $lastBackupTime = Get-Content $backupTimePath
    $lastBackupDateTime = [DateTime]::ParseExact($lastBackupTime, "yyyy-MM-dd HH:mm:ss", $null)
    $elapsedDays = (New-TimeSpan -Start $lastBackupDateTime -End $currentTime).Days
    if ($elapsedDays -gt 30) {
        Write-Host "Warning: It has been over 30 days since the last push!" -ForegroundColor Red
    }
} else {
    Write-Host "Creating initial backup time stamp file." -ForegroundColor Green
    Set-Content -Path $backupTimePath -Value $currentTime
}

Write-Host "Backup process completed." -ForegroundColor Green
