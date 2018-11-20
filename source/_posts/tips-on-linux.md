---
title: Linux 技巧拾零
date: 2017-10-12 12:43:04
tags:
    - Linux
categories: Tips and Tricks
---

记录 Linux 下遇到的问题、技巧与备忘。

<!-- more -->

1. 令 Tab 补全对忽略大小写  
   所有用户：`/etc/inputrc`  
   当前用户：`~/.inputrc`  
   输入内容：`set completion-ignore-case on`
1. `history` 不显示连续、重复、特定的命令、加上时间戳  
   于 `/etc/bashrc`（或 `~/.bashrc`）中添加
   {% codeblock lang:bash %}
   HISTTIMEFORMAT='%F %T '
   HISTCONTROL=erasedups
   HISTIGNORE="ls:pwd:cd:clear:vim:fg:bg:jobs:top"
   {% endcodeblock %}
   将 `HISTCONTROL` 设成 `ignoredups` 仅忽略连续的重复命令,
   而 `erasedups` 清除整个历史中重复条目.
1. 常用终端快捷键

   | 快捷键   | 用途               | 快捷键   | 用途                   |
   | :---     | :---               | :---     | :---                   |
   | `Ctrl-A` | 移动到行首         | `Esc-F`  | 移动到后面一个单词     |
   | `Ctrl-E` | 移动到行末         | `Ctrl-K` | 删除到行末             |
   | `Ctrl-B` | 移动到前面一个字母 | `Ctrl-U` | 删除到行首             |
   | `Ctrl-F` | 移动到后面一个字母 | `Ctrl-T` | 交换光标位置前两个字符 |
   | `Ctrl-B` | 移动到前面一个单词 | `Esc-T`  | 交换光标位置前两个单词 |
1. SSH 登录服务器缓慢解决方案：
   - 关闭 DNS 反向解析：`vim /etc/ssh/sshd_config`，设定其中 `UseDNS=no`，重启服务 `service sshd restart`
   - 服务端禁用 `GSSAPIAuthentication`：同样在 `/etc/ssh/sshd_config` 中设定 `GSSAPIAuthentication no`
1. SSH 登录欢迎界面设置文件：`/etc/motd`
1. SSH Log 日志文件：
   - Redhat，Fedora Core: `/var/log/secure`
   - Mandrake，FreeBSD，OpenBSD，Debian: `/var/log/auth.log`
   - SUSE: `/var/log/messages`
1. 系统内建函数 `time` **功能有限** （`real` 时间是指挂钟时间，也就是命令开始执行到结束的时间。这个短时间包括其他进程所占用的时间片，   和进程被阻塞时所花费的时间。`user` 时间是指进程花费在用户模式中的CPU时间，   这是唯一真正用于执行进程所花费的时间，其他进程和花费阻塞状态中的时间没有计算在内。`sys` 时间是指花费在内核模式中的 CPU 时间，代表在内核中执系统调用所花费的时间，这也是真正由进程使用的 CPU 时间）  
   REHL 与 Debian 中的 `man time` 是不同的。比如输出带管道命令的运行时间：`\time -f '%es' bash -c './test.py | sort > /dev/null'`，其中 `time` 前面的 `\` 消除 `alias` 对命令的影响（相当于执行 `/usr/bin/time`），在这里由于 `time` 是内建命令（与 `/usr/bin/time` 冲突）
1. `screen` 玩法：
   - `-ls` -- 列出当前用户分享的 screen
   - `-dmS session` -- 新建一个 session（`-d` 表示不立即附着）
   - `-r` -- （对于本机登录的自己）恢复离线的 screen 作业
   - `-x` -- （对于别处登录的相同的账号）恢复作业，实现同账号分享

   以下操作处于 `screen` 中：

   - `<C-a> d` -- 从 `screen` 中脱离（注：直接 `<C-d>` 会关闭这个 `screen` ！）
   - `<C-a> s` -- 冻结屏幕
   - `<C-a> q` -- 恢复冻结的屏幕
   - `<C-a> :multiuser on` -- 开始多用户模式
   - `<C-a> :acladd USER` -- 多用户模式中允许用户 `USER` 访问

   要实现不同账号分享，首先在 `root` 权限下执行：
   {% codeblock lang:bash %}
   chmod u+s $(which screen)
   chmod 755 /var/run/screen
   rm -fr /var/run/screen/*
   {% endcodeblock %}
   再开启多用户模式，添加用户访问权限，其它用户通过命令 `screen -x usera/shared` 即可。  
   另，出现 `cannot open terminal` 时可用 `script /dev/null`
1. Zsh 中的 `nohup` 与 Bash 有所不同：关闭 shell 后仍然会停止后台任务。
   解决方案：
   - `nohup <command> & disown`
   - `<command> &!`
   - `setopt NO_HUP`
1. 获得指定用户登录 Shell 路径：`getent passwd $LOGNAME | cut -d: -f7`
1. 配置静态 DNS (Ubuntu)：修改 `/etc/network/interfaces`：
   {% codeblock %}
   dns-nameservers 223.5.5.5 223.6.6.6
   {% endcodeblock %}
   重启 `networking`：`sudo /etc/init.d/networking restart`
1. docker 命令免 `sudo`：
   {% codeblock lang:bash %}
   sudo groupadd docker
   sudo gpasswd -a ${USER} docker
   sudo service docker restart
   {% endcodeblock %}
1. 命令 `lsb_release` 提示 `No LSB modules are available.`：
   {% codeblock lang:bash %}
   sudo apt install lsb-core
   {% endcodeblock %}
1. 开启 swap （交换）分区：
   1. 创建用于交换分区的文件
      {% codeblock lang:bash %}
      dd if=/dev/zero of=/mnt/swap bs=block_size count=number_of_block
      {% endcodeblock %}
      注：`block_size`，`number_of_block` 大小可以自定义，比如 `bs=1M`，`count=1024`，代表设置 1G 大小 swap 分区
   2. 设置交换分区文件
      {% codeblock lang:bash %}
      mkswap /mnt/swap
      {% endcodeblock %}
   3. 立即启用交换分区文件
      {% codeblock lang:bash /etc/fstab %}
      swapon /mnt/swap
      {% endcodeblock %}
      如果在 `/etc/rc.local` 中有 `swapoff -a` 需要修改为 `swapon -a`
   4. 设置开机时启用 `swap` 分区：
      {% codeblock %}
      /mnt/swap swap swap defaults 0 0
      {% endcodeblock %}
      注：`/mnt/swap` 路径可以修改，可以根据创建的 `swap` 文件具体路径来配置，设置后可以执行 `free -m` 命令查看效果。  
   参考：[针对阿里云及腾讯云等默认不开启swap分区解决办法](http://www.jiankang37.com/archives/69)
1. 利用 `svn` 从远程仓库下载部分目录:
   - GitHub：`svn export https://github.com/<username>/<repo>/trunk/<subdir>`
   - 码云：`svn export svn://git.oschina.net/<username>/<repo>/trunk/<subdir>`
   - 码市：`svn export svn+ssh://svn@svn.coding.net/<username>/<repo>/trunk/<subdir>`

   其中 GitHub 已默认开启 svn； 码云及码市需要手动开启。如要获取额外的版本信息，将 `export` 改为 `checkout`
1. CentOS7.3 (REHL 7) 为 GDB 工具安装必要包 `debuginfo`。  
   对简单的一段程序进行调试，却提示缺少包，需要通过 `debuginfo-install` 去安装 `glibc-2.17-...`，但无法直接安装 `debuginfo-install`，发现此工具在 `yum-utils` 中，所以首先安装 `yum-utils`
   {% codeblock lang:bash %}
   yum install yum-utils
   {% endcodeblock %}
   然后需要在 `/etc/yum/repos.d` 下新建 `CentOS-Debuginfo.repo` 文件:
   {% codeblock /etc/yum/repos.d/CentOS-Debuginfo.repo lang:ini %}
   #Debug Info
   [debuginfo]
   name=CentOS-$releasever - DebugInfo
   baseurl=http://debuginfo.centos.org/$releasever/$basearch
   gpgcheck=0
   enabled=1
   {% endcodeblock %}
   保存即可
1. U 盘安装 CentOS 7.3  
   1. Windows 下用 UltraISO 将系统刻入 U 盘
   2. 改 BIOS 启动引导项为 U 盘，进入的第一个界面中将光标移至 `Install ...`，按下 `Tab`，修改命令为
      {% codeblock lang:bash %}
      vmlinuz initrd=initrd.img linux dd quiet
      {% endcodeblock %}
   3. 上面的命令只是查询 U 盘的设备号，比如此次安装时显示出 U 盘的设备号为 `sdb4`，按下 `Ctrl-Alt-Del` 强制重启，在下次的重启选项中键入
      {% codeblock lang:bash %}
      vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sdb4 quiet
      {% endcodeblock %}
1. 源码编译 `Git`：
   {% codeblock lang:bash %}
   wget 'https://github.com/git/git/archive/v2.17.0-rc0.tar.gz'
   tar -xzvf v2.17.0-rc0.tar.gz
   cd git-2.17.0-rc0
   make configure
   ./configure --prefix=/usr/local/git-2.17
   sudo make install -j4
   {% endcodeblock %}
   {% fa warning fw %} 注：Git 源文件中的 Makefile 默认不提供 `uninstall` 选项，   安装时务必慎重选取安装路径。  
   参考: [How To Install Git on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-centos-7)
1. Ubuntu 报错 `sudo: unable to resolve host`：
   {% codeblock lang:plain /etc/hosts %}
   127.0.0.1       localhost  abcdefg
   {% endcodeblock %}
   其中第三列为主机名
1. 安装 Node.js 后报错：`/usr/bin/env: ‘node’: No such file or directory` 解决方案：
   {% codeblock lang:bash %}
   ln -s /usr/bin/nodejs /usr/bin/node
   {% endcodeblock %}
1. SSH 登录出现错误提示 `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`，一般是因为认证密钥过期，解决方案：
   - 根据提示删除 `~/.ssh/known_hosts` 中相应的行
   - `ssh-keygen -R "you server hostname or ip"`
