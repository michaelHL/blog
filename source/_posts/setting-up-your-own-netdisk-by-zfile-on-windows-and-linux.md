---
title: 使用 ZFile 搭建自己的文件分享站（Linux & Windows）
date: 2021-02-28 11:21:10
tags:
    - ZFile
    - FTP
    - Fuse
    - NetDisk
    - FileZilla
categories: Handy Utilities
---

网盘目录程序各式各样，这里分享一个页面简洁大方的在线网盘项目 [Z-File][zfile-project]。

> 此项目是一个在线文件目录的程序，支持各种对象存储和本地存储，使用定位是个人放常用工具下载，或做公共的文件库。不会向多账户方向开发。
> 前端基于 [h5ai][h5ai-project] 的原有功能使用 Vue 重新开发了一遍。后端采用 SpringBoot，数据库采用内嵌数据库。

为适应不同场景下需求，分别在 Linux 以及 Windows 中进行测试。

## 准备工作

### FTP 服务器

Windows 自带的的 Internet Information Services (IIS) 搭建 FTP 服务器会出现中文文件名乱码、认证错误等问题，于是转向开源的 [FileZilla Server][filezilla-server-download] 搭建 FTP 服务器。

## Linux 部署 ZFile

### 安装依赖

```bash
# CentOS系统
yum install -y java-1.8.0-openjdk unzip

# Debian/Ubuntu系统
apt update
apt install -y openjdk-8-jre-headless unzip
```

### 下载项目

```bash
wget -P https://c.jun6.net/ZFILE/zfile-release.war
mkdir zfile && unzip zfile-release.war -d zfile
chmod +x zfile/bin/*.sh
```

### 常用命令

```bash
 ~/zfile/bin/start.sh       # 启动项目
 ~/zfile/bin/stop.sh        # 停止项目
 ~/zfile/bin/restart.sh     # 重启项目
```

### 后台配置

运行 `start.sh` 启动程序，进入网页端 `http://<ip:port>` 设置后台管理账密（前端端口在 `zfile/WEB-INF/classes/application.xml` 中配置，默认为 8080），后台管理界面网址为：`http://<ip:port>/#/admin`。通过「驱动器列表」页面新增驱动器并进行必要配置，即可在前端显示目录内容。

### 挂载 FTP 驱动器

默认情况下挂载的 FTP 驱动器在前端下载协议为 `ftp://` ，部分客户端浏览器不支持 ftp 协议下载，且 ftp 协议下载链接会暴露用户名密码，故 Zfile 提供「加速域名」的方式，即事先实现以 HTTP 方式访问 FTP 目录，用户通过 HTTP 进行下载从而隐藏敏感信息。而实际情况中 FTP 服务器可能无法搭建 HTTP 服务，故考虑将远程 FTP 挂载到本地目录，在 Zfile 管理界面新增本地存储的方式进行展示。

下面利用 curlftpfs 挂载 FTP 服务器：

```bash
# 在线安装
yum install -y epel-release
yum install -y curlftpfs
# 离线安装
# yum install --downloadonly curlftpfs --downloaddir=.

# 挂载 FTP 目录
mkdir -p $MOUNTPOINT
curlftpfs $IP:$PORT $MOUNTPOINT -o user=$USERNAME:$PASSWORD,utf8
# 取消挂载
fusermount -u $MOUNTPOINT
```

## Windows 部署 ZFile

```bat
java -Dfile.encoding=utf-8 -jar -Dserver.port=8080 .\zfile-release.jar
# 如需要修改配置文件, 可去 Github 复制一份配置文件, 放到 jar 文件同路径即可.
```

### 挂载 FTP 驱动器

与 Linux 下同理，相应需安装 [Rclone][rclone-project] 及 [WinFsp][winfsp-project]，配置过程不再赘述。


[zfile-project]: https://github.com/zhaojun1998/zfile
[h5ai-project]: https://larsjung.de/h5ai
[filezilla-server-download]: https://filezilla-project.org/download.php?type=server
[rclone-project]: https://github.com/rclone/rclone
[winfsp-project]: https://github.com/billziss-gh/winfsp
