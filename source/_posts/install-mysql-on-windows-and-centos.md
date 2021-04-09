---
title: Windows 以及 CentOS 下的 MySQL 安装
date: 2018-01-21 11:22:03
tags:
    - SQL
    - MySQL
categories: Development and Deployment
---

在不同系统下安装配置 MySQL 的过程中遇到不少问题，特此记录。

<!-- more -->

## Windows 下配置免安装版 MySQL 5.7

1. 于 [MySQL Community Server][mysql-community-server] 下载页面下载 zip 版本并解压，比如解压到 `D:\\MySQL` 目录下
1. 于 `MySQL` 根目录添加配置文件 `my.ini`：
   {% codeblock my.ini lang:ini %}
   [mysqld]
   port = 3677
   basedir = "D:\\MySQL"
   datadir = "D:\\MySQL\\data"
   sql_mode = NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

   max_connections = 200
   character-set-server = utf8
   default-storage-engine = INNODB
   explicit_defaults_for_timestamp = true

   # innodb_buffer_pool_size = 128M
   # join_buffer_size = 128M
   # sort_buffer_size = 2M
   # read_rnd_buffer_size = 2M

   [mysqladmin]
   user = "root"
   port = 3677
   {% endcodeblock %}
1. 初始化 MySQL 数据库：
   {% codeblock lang:dos %}
   "D:\MySQL\bin\mysqld.exe" --defaults-file="D:\\MySQL\\my.ini" --initialize-insecure --console
   {% endcodeblock %}
1. 此时已有无密码账户 `root`，更改密码：
   {% codeblock lang:dos %}
   "D:\MySQL\bin\mysqld.exe" --defaults-file="D:\\MySQL\\my.ini" --console
   {% endcodeblock %}
1. 另开终端，输入 `mysql -uroot -P 3677 -p` 直接回车，
   并键入（`<password>` 为密码）：
   {% codeblock lang:sql %}
   update mysql.user set authentication_string=password('<password>') where user='root';
   flush privileges;
   quit;
   {% endcodeblock %}
   在 MySQL 8 版本中更加便捷：
   {% codeblock lang:sql %}
   ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';
   {% endcodeblock %}
1. 安装 MySQL 服务。在 **`D:\MySQL\bin`** 目录下以管理员身份键入 `mysqld --install`

### 参考

- [如何修改MySQL5.7.18的密码][csdn-72356334]
- [解决Windows安装解压版MySQL出现服务正在启动-服务无法启动的问题][csdn-49951577]
- [Running/Starting MySQL without installation on Windows][stackoverflow-42045494]
- [5.7 Upgrade and Resolving ERROR 1130 Host ‘localhost’ is Not Allowed to Connect][chriscalender-1130]

---------------------------

## CentOS 系统部署 MySQL 5.7

1. 添加 MySQL 的 Yum 仓库：[Download MySQL Yum Repository][mysql-yum-repo]。
   {% codeblock lang:bash %}
   wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
   rpm -ivh mysql57-community-release-el7-11.noarch.rpm
   yum install mysql-server
   {% endcodeblock %}
1. 启动 MySQL 服务：
   {% codeblock lang:bash %}
   systemctl start mysqld
   systemctl status mysqld
   {% endcodeblock %}
1. 更改 root 用户密码：
   {% codeblock lang:bash %}
   mysqladmin -uroot password -p
   <password>
   {% endcodeblock %}
1. 允许远程访问：
   {% codeblock lang:sql %}
   % mysql -uroot -p
   grant all privileges on *.* to 'root'@'%' identified by '<password>';
   flush privileges;
   {% endcodeblock %}

### 配置文件

```ini /etc/my.cnf
[mysqld]
port = 3677

max_connections = 200
character-set-server = UTF8MB4
default-storage-engine = INNODB
explicit_defaults_for_timestamp = true

[mysqladmin]
user = "root"
port = 3677
```

### 问题

#### rpm 无法添加仓库

如果不是全新安装，需要手动删除之前用 rpm 安装的 mysql 相关的包

#### 服务无法启动

重设 MySQL 数据目录的权限：

```sh
chmod -R 777 /var/lib/mysql
```

### 参考

- [centos7 mysql数据库安装和配置][cnblogs-4680083]
- [CentOS 7 下开启Mysql-5.7.19远程访问][csdn-76381632]
- [CentOS7 64位下MySQL5.7安装与配置（YUM）][linuxidc-135288]
- [RPM命令详解（安装、升级、卸载）][csdn-rpm]
- [Configuring A Fresh Install Of MySQL On CentOS: Start Service, Set Password, Set Runlevels][linuxacademy-config-fresh-install-mysql]


[mysql-community-server]: https://dev.mysql.com/downloads/mysql
[csdn-49951577]: http://blog.csdn.net/u013067166/article/details/49951577
[csdn-72356334]: http://blog.csdn.net/xy_cy/article/details/72356334
[stackoverflow-42045494]: https://stackoverflow.com/questions/42045494/running-starting-mysql-without-installation-on-windows
[chriscalender-1130]: https://www.chriscalender.com/tag/error-1130-hy000-host-localhost-is-not-allowed-to-connect-to-this-mysql-server
[linuxidc-135288]: http://www.linuxidc.com/Linux/2016-09/135288.htm
[cnblogs-4680083]: https://www.cnblogs.com/starof/p/4680083.html
[csdn-rpm]: http://blog.csdn.net/samxx8/article/details/46739005
[mysql-yum-repo]: https://dev.mysql.com/downloads/repo/yum
[csdn-76381632]: http://blog.csdn.net/u010758410/article/details/76381632
[linuxacademy-config-fresh-install-mysql]: https://linuxacademy.com/blog/linux/configuring-a-fresh-install-of-mysql-on-centos-start-service-set-password-set-runlevels
