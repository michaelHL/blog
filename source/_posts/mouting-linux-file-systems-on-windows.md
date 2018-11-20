---
title: Windows 挂载 Linux 文件系统
date: 2018-02-02 13:35:06
tags:
    - SSH
    - Windows
    - Linux
    - FileSystem
categories: Handy Utilities
---

推荐在 Windows 下利用 SSH 挂载远程 Linux 文件系统及目录的工具：[WinSshFS][win-sshfs-repo]。

虽然可以利用各类 SFTP 软件与服务器间互传文件，但操作感始终没有直接双击打开「我的电脑」里面的盘符来的方便。那么基于 [Dokany][dokany-repo] 开发的 WinSshFS 就能完美满足这个需求。配置比较简单：

1. 安装 Dokany 库
1. 下载 / 安装 WinSshFS

<!-- more -->

配置完后远程目录的操作基本与本地磁盘相同了，下为 MSYS2 中 `df` 显示的结果：

```
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
D:/MSYS2        391G   48G  344G  13% /
C:              100G   25G   75G  25% /c
E:              441G  198G  244G  45% /e
M:               40G   23G   19G  55% /m
N:              976G  815G  212G  80% /n
O:              3.6T  413G  3.4T  11% /o
```

------------------------------------------------------------------------

仅需注意的是这二者并不是同一作者开发，后者的更新相比于前者有一定迟滞性，所以 Dokany 库不宜下载最新版，具体推荐版本见 WinSshFS 的[发行界面][win-sshfs-release]。当前稳定运行的版本为：

- Dokany: 1.0.5.1000
- WinSshFS: 1.6.0.14

[win-sshfs-repo]: https://github.com/Foreveryone-cz/win-sshfs
[dokany-repo]: https://github.com/dokan-dev/dokany
[win-sshfs-release]: https://github.com/Foreveryone-cz/win-sshfs/releases
