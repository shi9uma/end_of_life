# my blogs backups

万一有一天我真的开不了机了呢，主密钥是 1 级密码

1.   基础逻辑是：

     1.   加密：`encrypt -i E:/Documents/markdown/02_md -o E:/project/03_end_of_life/backups/blogs -r -k E:/project/03_end_of_life/backups/key -s E:/project/03_end_of_life/backups/salt enc`
     2.   解密：`encrypt -i E:/project/03_end_of_life/backups/blogs -o E:/tmp/tmp -r -k E:/project/03_end_of_life/backups/key -s E:/project/03_end_of_life/backups/salt dec`

2.   快速脚本

     1.   `E:/project/03_end_of_life/backups/backup.ps1`
     2.   `/e/project/03_end_of_life/backups/backup.sh`

     修改 `src_dir` 和 `dst_dir` 项为想要备份的文件夹


如果出现了提示超过 30 天没备份，那就删掉 backup_time，备份一下生成新的 backup_time，然后 push 一下