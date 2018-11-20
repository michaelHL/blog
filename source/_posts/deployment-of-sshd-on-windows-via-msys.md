---
title: Windows 下利用 MSYS2 搭建 sshd 服务器
date: 2017-11-30 15:10:41
tags:
    - MSYS2
    - Windows
    - Server
    - SSH
    - Autossh
categories: Development and Deployment
---

若能在远程中非图形界面下访问到自己的 Windows 服务器，比如像 Linux 那样通过 SSH 连接便能进行日常操作，那确实是很方便的。然而 Windows 鸡肋的 cmd 足以毁坏每天的心情，所以 Windows 下装配一个 \*nix 系统也是必要的。下面记录 Windows 中利用 MSYS2 **清真** 搭建 sshd 服务的全过程。

<!-- more -->

### 配置 sshd 服务

脚本：[sshd_msys.sh][sshd-msys]，注意其中的 `tmp_pass` 可作为登录密码。

1. 64 位的 MSYS2 下，以管理员身份登录 **MinGW64**
1. 可能需要手动创建一些文件
   {% codeblock lang:bash %}
   # mkpasswd > /etc/passwd
   touch /var/log/lastlog
   {% endcodeblock %}
1. 为灵活切换 `MSYS` / `MINGW64` / `MINGW32` 环境，将 `/etc/ssh/sshd_config` 文件中的 `PermitUserEnvironment` 置为 `yes`，并新建文件 `~/.ssh/environment` 并在其中添加 `MSYSTEM=MINGW64`
1. `net start/stop sshd` 可启用 / 停止 `sshd` 服务
   （此服务在系统的 `Services` 中的服务名为 `sshd`，登录账号应为 `.\sshd_server`）

如此一来就可以进行本地 SSH 登录了，如要进行远程 SSH 访问本机，需作反向代理。

### 配置反向代理 ssh 服务

MSYS2 默认的源中没有 `autossh`，所以需自行编译: [repo][autossh-additional-pkgs-repo]。在 **MSYS**  中一通操作：

```bash
git clone https://github.com/mati865/MSYS2-additional-packages.git
cd MSYS2-additional-packages/autossh
makepkg
pacman -U autossh*.pkg.tar.xz
```

如安装顺利，则二进制文件为 `/usr/bin/autossh`。安装系统服务：

```bash
# ssh-keygen -t 'rsa'
ssh-copy-id user@domain
cygrunsrv -R autossh_12345
cygrunsrv -I autossh_12345 -d "MSYS2 Reverse Tunnel - xxxx" -p \
          /usr/bin/autossh.exe -a "-M 0 -o ExitOnForwardFailure=yes -o \
          ServerAliveInterval=30 -o ServerAliveCountMax=3 \
          -o ExitOnForwardFailure=yes \
          -NR 12345:localhost:22 user@domain -i ~/.ssh/id_rsa" \
          -y tcpip -u ".\${USER}" -w "${PASSWD}"
cygrunsrv -S autossh_12345
```

那么就在系统中注册了名为 `autossh_xxxx` 的服务，其中 `${USER}`，`${PASSWD}` 分别为系统用户名和密码，启动 / 停止服务同上述 `sshd` 服务。

`cygrunsrv` 参数解释：

- `-I` 或 `--install`：安装服务
- `-d`：显示名
- `-p`：程序路径
- `-a`：参数
- `-y`：服务依赖，服务名可直接在 `services.msc`查询
- `-t`：服务启动类型（auto | manual）

另外，Windows 下查询已开启服务可用 `net start`。

### 笔记本无法开机启动解决方案

在笔记本执行上述操作可能仍无法开机启动 sshd 服务，这时可以利用任务计划曲线救国：

1. 上述操作执行到 `cygrunsrv -I xxx` 为止，即完成创建系统服务
1. 新建文件 `reverse-tunnel.sh`：
   {% codeblock lang:bash reverse-tunnel.sh %}
   #!/usr/bin/bash
   cygrunsrv -S autossh_12345
   {% endcodeblock %}
1. 在任务计划中添加新任务，触发器设为「成功联网后」，[示例][task-schedule-reverse-sshd-tunnel]。

### 注意

开始试验时经常出现重启后无法连接的情况，就上述例子而言，开机后打开日志 `/var/log/autossh_12345.log` 会显示：

```
Error: remote port forwarding failed for listen port 12345
```

详情见 [SSH remote port forwarding failed][se-595323]。经过几十次的重启，处理方案如下：

- 一旦计算机休眠或待机，服务将不可用，所以应关闭「自动待机」
- `autossh` 服务中的启动需加上 `-o ExitOnForwardFailure=yes`
- 如果重启时间过短，而且重启之前没有关闭 `autossh` 服务，那么开机的时候很可能无法启动这个服务，虽具体原因不是很懂，  但猜测是远程那端在本地计算机重启的时候，二者之前建立的隧道是被占用状态。所以为根除此问题，关机前务必停止 `autossh` 服务，这里可以对关机、重启命令进行包装：
  {% codeblock lang:bash %}
  alias poweroff='(shutdown -s -t 0 &); (net stop autossh_xxxx &);'
  alias reboot='(shutdown -r -t 0 &); (net stop autossh_xxxx &);'
  {% endcodeblock %}
  而且该命令需要在管理员权限下执行，或者在远程执行
- 不要试图更改服务中的登录选项，仅本机账密才能行的通
- 可能需要设置失败后重启服务

### 参考

- [Configure sshd on MSYS2 and run it as a Windows service][gist-00ee]
- [Autossh Windows][autossh-windows]
- [Windows Task Scheduler: Trigger an Event When Internet Connects/Disconnects][task-schedule-trigger-tcp-ip]

[gist-00ee]: https://gist.github.com/samhocevar/00eec26d9e9988d080ac
[autossh-additional-pkgs-repo]: https://github.com/mati865/MSYS2-additional-packages
[autossh-windows]: https://support.chartio.com/docs/data-sources/autossh-windows
[sshd-msys]: /src/sshd_msys.sh
[task-schedule-reverse-sshd-tunnel]: /src/reverse-tunnel-sshd.xml
[se-595323]: https://serverfault.com/questions/595323/ssh-remote-port-forwarding-failed
[task-schedule-trigger-tcp-ip]: https://www.groovypost.com/howto/automatically-run-script-on-internet-connect-network-connection-drop
