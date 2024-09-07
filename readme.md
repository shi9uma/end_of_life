# End of Life

「Call Life As Natality，Noticing，Accompanying，Death」—— CLANNAD

人生即是：到来、相遇、陪伴、离开

## ez mode

1.   需要 openssl 和 md5sum 支持
2.   clone/fork 这个项目，`chmod +x ./end_of_life.sh`，执行 `./end_of_life.sh init` 自动初始化
3.   在 `plain` 目录下创建想写的东西，任何文本文件皆可（想放视频、音频或者什么乱七八糟的也可以，如果能忍受同步到 repo 很麻烦的话），这里以 `test.txt` 为例
4.   写完内容后，输入 `./end_of_life.sh enc xxxx`，这里 `xxxx` 为密钥，将在 `encrypt` 目录下生成 `test_txt.enc` 文件，该目录下的文件都将会被同步到 repo（如果打算同步的话）
5.   如果（在别处）想要解密，先 clone，然后输入 `./end_of_life.sh dec xxxx`，即可在 `decrypt` 目录下生成解密的文件 `test.txt`
6.   如果要写新东西，输入 `./end_of_life.sh copy` 指令将 `decrypt` 下的 `test.txt` 复制到 `plain` 下再写，写完记得重新 enc
7.   如果担心会被破译，修改 `./end_of_life.sh` 里的 `iterations=10000` 项，越大越难、越大耗时越久
8.   **记住密钥，丢了就是真的丢了**；如果在尝试爆破自己的密钥时发现命令行没报错（以为是成功解密），但是解密出的内容仍然是乱码，这是 `aes-256-cbc` 算法导致的
9.   **不要写太简单的密码**，你可以执行 `./create_password.sh --length 32 --key key` 来分别指定 length 和 seed 创建一个高强度密码

## full support

使用 python 重新实现了一遍这些功能，需要 `pip install cryptography argparse`

1.   `python ./end_of_life.py -h` 查看帮助
2.   默认使用 prompt 输入 key，也可以手动指定：`-k path/to/keyfile`
3.   `salt` 盐文件和输入的 key 与 uuid 有关，指定 `-s` 选项后需要提供一个盐路径，如果不存在会自动生成
4.   指定 `-d` 会在加密后提示是否删除源文件
5.   示例
     1.   **注意，操作之前，如果不主动指定 output，会自动覆盖掉解密后的同名文件，如果密码错了该文件会丢失**
     2.   对单个文件进行加密：`python ./end_of_life.py -i plain/end_of_life.md -s salt enc`
     3.   对单个文件进行解密：`python ./end_of_life.py -i plain/end_of_life.md.enc -s salt dec`
     4.   对目录下文件进行加密，并递归处理：`python ./end_of_life.py -i path/to/enc_dir -r -s salt enc`
     5.   对目录下文件进行解密，并递归处理：`python ./end_of_life.py -i path/to/enc_dir -r -s salt dec`

## todo

1.   要写入的清单参考
2.   如何实现特定日期、离开多久后自动公布给特定的人以主密钥
3.   我是如何存储这些内容的
4.   多密钥支持
5.   多平台？支持

## tmp

1.   `./end_of_life.sh dec $(cat backups/key)`
2.   `./end_of_life.sh copy`
3.   `./end_of_life.sh enc $(cat backups/key)`
4.   python
     1.   `end_of_life -i file --key ~/.end_of_life_key --salt ~/.end_of_life_salt enc`
     2.   `end_of_life -d file.enc --key ~/.end_of_life_key --salt ~/.end_of_life_salt dec`

## refer

1.   本仓库启发于：[potatoqualitee/eol-dr](https://github.com/potatoqualitee/eol-dr.git)