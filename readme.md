# End of Life

「Call Life As Natality，Noticing，Accompanying，Death」—— CLANNAD

人生即是：到来、相遇、**陪伴**、离开；我无法控制到来、相遇以及离开，但是我仍可以选择尽可能地与 **你** 相伴

本仓库启发于：[potatoqualitee/eol-dr](https://github.com/potatoqualitee/eol-dr.git)，我想尽可能简单地在这个世界上留下一些痕迹

如果你也有想要留下一些什么给在意的人，可以参考当前这个简单的项目：仍然在这个世界上时几乎不可能会被公开，但是当你离开以后，ta 可以找到一些你曾经存在的痕迹

## usage

1.   需要 openssl 和 md5sum 支持
2.   clone/fork 这个项目，`chmod +x ./eol.sh`，执行 `./eol.sh init` 自动初始化
3.   在 `plain` 目录下创建想写的东西，任何文本文件皆可（想放视频、音频或者什么乱七八糟的也可以，如果你能忍受上传同步到 repo 很麻烦的话），这里以 `test.txt` 为例
4.   写完内容后，输入 `./eol.sh enc xxxx`，这里 `xxxx` 为密钥，将在 `encrypt` 目录下生成 `test_txt.enc` 文件，该目录下的文件都将会被同步到 repo（如果你打算同步的话）
5.   如果你（在别处）想要解密，先 clone，然后输入 `./eol.sh dec xxxx`，即可在 `decrypt` 目录下生成解密的文件 `test.txt`
6.   如果你要写新东西，输入 `./eol.sh copy` 指令将 `decrypt` 下的 `test.txt` 复制到 `plain` 下再写，写完记得重新 enc
7.   如果你担心会被破译，修改 `./eol.sh` 里的 `iterations=10000` 项，越大越难、越大耗时越久
8.   **记住你的密钥，丢了就是真的丢了**；如果你在尝试爆破自己的密钥时发现命令行没报错（以为是成功解密），但是解密出的内容仍然是乱码，这是 `aes-256-cbc` 算法导致的"偶然"
9.   **不要写太简单的密码**，你可以执行 `./create_password.sh --length 32 --key key` 来分别指定 length 和 seed 创建一个高强度密码

## todo

1.   要写入的清单参考
2.   如何实现特定日期、离开多久后自动公布给特定的人以主密钥
3.   我是如何存储这些内容的
4.   多密钥支持
5.   多平台？支持

## tmp

1.   `./eol.sh dec $(cat tmp)`
2.   `./eol.sh copy`
3.   `./eol.sh enc $(cat tmp)`