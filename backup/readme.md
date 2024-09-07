# my blogs backups

万一有一天我真的开不了机了呢，主密钥是 1 级密码，salt 是 2 级

1.   基础逻辑是：

     1.   加密：`encrypt -i d:/document/markdown/02-md -o d:/project/03-end-of-life/backup/blog -r -k d:/project/03-end-of-life/backups/key -s d:/project/03-end-of-life/backup/salt enc`
     2.   解密：`encrypt -i d:/project/03-end-of-life/backup/blog -o e:/tmp/tmp -r -k d:/project/03-end-of-life/backups/key -s d:/project/03-end-of-life/backup/salt dec`

2.   快速脚本

     1.   `d:/project/03-end-of-life/backup/script/windows-backup.ps1`
     2.   `/d/project/03-end-of-life/backup/script/unix-backup.sh`

     修改 `src_dir` 和 `dst_dir` 项为想要备份的文件夹


如果出现了提示超过 30 天没备份，那就删掉 backup_time，备份一下生成新的 backup_time，然后 push 一下