---
title: ssh / autossh / Xshell 端口转发及内网穿透
date: 2017-11-01 17:23:48
tags:
    - Server
    - SSH
    - Autossh
    - Xshell
categories: Operation and Maintenance
---

没有公网 IP？内网服务器成笼中凤凰？果断穿透一波！手头上有三台机器，记号如下：

| 记号 | 位置          | 地址      | 账户  |
| :--: | :--:          | :--:      | :--:  |
| A    | 位于公网      | a.site    | usera |
| B    | 位于 NAT 之后 | localhost | userb |
| C    | 位于 NAT 之后 | localhost | userc |

<!-- more -->

## autossh 实现内网穿透

首先介绍比较稳定的 `autossh`。

### 操作

1. 在机器 A 上：
   - **设置 `sshd` 设置文件 `/etc/ssh/sshd_config`：`GatewayPorts yes`**
   - `sudo systemctl restart sshd`
1. 在机器 B 上：
   创建 SSH 密钥，上传至 A：
   {% codeblock lang:bash %}
   ssh-keygen -t 'rsa'
   ssh-copy-id usera@a.site
   {% endcodeblock %}
1. - 如果仅作测试，直接键入命令
     {% codeblock lang:bash %}
     autossh -M 6777 -NR 6766:localhost:22 usera@a.site -i /path/to/id_rsa
     {% endcodeblock %}
     即可，但该命令会在前端等待。如果需要不间断运行地置于后台，
     可使用 `nohup` 命令：
     {% codeblock lang:bash %}
     nohup autossh -M 6777 -NR 6766:localhost:22 usera@a.site -i /path/to/id_rsa >/dev/null 2>&1 &
     {% endcodeblock %}
     {% fa warning fw%} **注** 其中的 `-M xxxx` 表示守护进程，也就是如果监测到 6766 端口的进程挂掉之后，又会重新开启 `autossh` （所以可能导致 `kill` 不完进程），如果改为 `-M 0` 则表示没有守护进程。
   - 如果希望作为系统服务并开机启动，需进行如下操作：
     1. 编辑文件 `/etc/systemd/system/autossh.service`，
        {% codeblock autossh.service lang:ini %}
        [Unit]
        Description=autossh ssh
        After=network-online.target

        [Service]
        Environment="AUTOSSH_GATETIME=0"
        ExecStart=/usr/bin/autossh -M 0 -o "ExitOnForwardFailure=yes" -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NR 6766:localhost:22 usera@a.site -i /path/to/id_rsa

        [Install]
        WantedBy=multi-user.target
        {% endcodeblock %}
     1. 一通令之生效的操作：
        ```bash
        sudo systemctl daemon-reload
        sudo systemctl enable autossh
        sudo systemctl start autossh
        sudo systemctl status autossh
        ```

    {% fa warning fw%} **注**
    - `*.service` 文件中需要写绝对路径
    - `systemctl enable` 表示设置服务为自动启动

### 开耍

- A 连 B：`ssh -p 6766 userb@localhost`
- C 连 B：`ssh -p 6766 userb@a.site`
- 反向连接时指定动态端口转发（机器 C）：`ssh -p 6766 -qngfNTD 7677 userb@a.site`

### 问题

- 报错：
  {% codeblock lang:bash %}
  /usr/bin/ssh-copy-id: ERROR: failed to open ID file '/home/ismail/.pub': No such file
  {% endcodeblock %}
  解决方案：不带参数地生成秘钥 `ssh-keygen`
- 防止超时断开：
  - 在 B 和 C 的`/etc/ssh/ssh_config`后面加上: `ServerAliveInterval 60`
  - 在 A 机的`/etc/ssh/sshd_config`后面加上： `ClientAliveInterval 60`
- 少数情况下，问题会出在 ssh 的认证上，可能需要下列操作：
  - 修改文件 `/etc/ssh/ssh_config`:
    {% codeblock lang:bash %}
    GSSAPIAuthentication no
    GSSAPIDelegateCredentials no
    StrictHostKeyChecking no
    {% endcodeblock %}
- 棘手问题 `ssh_exchange_identification: read: Connection reset by peer` 解决方案：
  1. 删除已有 `autossh` 连接，重启服务
  1. 若问题仍在，尝试在机器 A 上新开 SSH 端口，方法有两种：
     在 `/etc/ssh/sshd_config` 中添加 `Port xxxxx`；或 <code>sudo \`which sshd\` -ddd -p xxxxx</code>。修改机器 B 中相关的服务参数并且重启服务


## ssh 端口转发

除了利用 `autossh` 作为反向代理工具，强大的 `ssh` 自身就可以实现正向代理以及反向代理。下面摘自 [SSH隧道与端口转发内网穿透](http://blog.csdn.net/zhanlanmg/article/details/47946753).

- `-L port:host:hostport`：将本地机（客户机）的某个端口转发到远端指定机器的指定端口。  本地机器上分配了一个 `socket` 侦听 `port` 端口，一旦这个端口上有了连接，该连接就经过安全通道转发出去，  同时远程主机和 `host` 的 `hostport` 端口建立连接。可以在配置文件中指定端口的转发。只有 `root` 才能转发特权端口。IPv6 地址用另一种格式说明：`port/host/hostport`
- `-R port:host:hostport `：将远程主机（服务器）的某个端口转发到本地端指定机器的指定端口。  远程主机上分配了一个 `socket` 侦听 `port` 端口，  一旦这个端口上有了连接，该连接就经过安全通道转向出去，同时本地主机和 `host` 的 `hostport` 端口建立连接。可以在配置文件中指定端口的转发。只有用 `root` 登录远程主机才能转发特权端口。IPv6 地址用另一种格式说明：`port/host/hostport`
- `-D port`：指定一个本地机器「动态的」应用程序端口转发。  本地机器上分配了一个 `socket` 侦听 `port` 端口，一旦这个端口上有了连接，该连接就经过安全通道转发出去，  根据应用程序的协议可以判断出远程主机将和哪里连接。目前支持 `SOCKS4` 协议，将充当 `SOCKS4` 服务器。  只有 `root` 才能转发特权端口。可以在配置文件中指定动态端口的转发
- `-p`：指定登录端口
- `-f`：后台认证用户 / 密码，通常和 `-N` 连用，不用登录到远程主机
- `-N`：不执行远程命令
- `-q`：进入安静模式
- `-C`：压缩数据传输
- `-g`：在 `-L/-R/-D` 参数中，允许远程主机连接到建立的转发的端口，如果不加这个参数，只允许本地主机建立连接

常用的 SSH 隧道操作：

- 正向代理：`ssh -C -f -N -L listen_port:DST_Host:DST_port user@Tunnel_Host`
- 反向代理：`ssh -C -f -N -R listen_port:DST_Host:DST_port user@Tunnel_Host`
- 动态转发：`ssh -C -f -N -D listen_port user@Tunnel_Host`

为保持长时间连接，同 `autossh` 的参数，`ssh` 可附加的参数有： `-o TCPKeepAlive=yes`，`-o ServerAliveInterval=30`, `-o ServerAliveCountMax=3` 等。

## Xshell 隧道转发

设想这样一个场景：本地机器 C 已经可以通过具有公网 IP 的 A 连接到服务器 B 的 SSH 服务，也就是说存在这样的一条隧道：`C - A(10001) - B(22)`。而在服务器 B 上运行着其它程序（比如网站），端口号为 5000，如果希望在本地 C 上直接访问到 B 的网站，自然下面这种思路：「建立从 `B(5000) - A(<web-port>)` 的隧道，C 通过 `http://A:<web-port>` 进行访问」。如此一来，又需要做一个「穿透」，把 B 的 5000 端口反向代理出去。但能否存在一种方式，在不额外给 A 增加服务端口的情况下，令 C 直接访问到 B 呢？
客户端软件 Xshell 的隧道转发功能正好派上用场。Xshell 的设置中自带端口转发技能（或称「隧道」，听起来比较 ~~装逼~~ 高大上）：`Sessions` - `Properties` - `Connection` - `SSH` - `Tunneling`。上述情形，仅需在连接 `C - A(10001) - B(22)` 中添加正向代理：

```
Type             : Local(Outgoing)
Source Host      : localhost
Listening Port   : <web-port>
Destination Host : localhost
Destination Port : 5000
```

保存会话属性并连接后，会在本地开启 `<web-port>` 端口，在本地机器 C 中浏览 `http://localhost:<web-port>` 即可访问到 B 中运行的网站了。

## 参考

- [**AutoSSH reverse tunnel service config for systemd**](https://gist.github.com/ntrepid8/0af12c012dd2567c800799d86eb44f90)
- [使用SSH反向隧道进行内网穿透](http://arondight.me/2016/02/17/%E4%BD%BF%E7%94%A8SSH%E5%8F%8D%E5%90%91%E9%9A%A7%E9%81%93%E8%BF%9B%E8%A1%8C%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F)
- [SSH端口转发：实现反向SSH隧道内网穿透](http://www.huangwenchao.com.cn/2016/10/ssh-reverse-tunnel.html)
