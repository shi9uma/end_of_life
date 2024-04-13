# my blogs backups

万一有一天我真的开不了机了呢，主密钥是 1 级密码

1.   `encrypt -i E:/Documents/markdown/02_md -o E:/project/14_end_of_life/backups/blogs -r -k E:/project/14_end_of_life/backups/key -s E:/project/14_end_of_life/backups/salt enc`
2.   `E:/project/14_end_of_life/backups/backup.ps1`
3.   `/e/project/14_end_of_life/backups/backup.sh`

如果出现了提示超过 30 天没备份，那就删掉 backup_time，备份一下生成新的 backup_time，然后 push 一下