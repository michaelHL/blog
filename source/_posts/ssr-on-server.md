---
title: SSR 服务器搭建
date: 2018-06-21 20:48:01
tags: SSR
categories: Development
---


> 原文链接:  
> [『原创』CentOS/Debian/Ubuntu ShadowsocksR 单/多端口 一键管理脚本][ssr]  
> [CentOS/Debian/Ubuntu系统 TCP-BBR 一键安装脚本][bbr]

[ssr]: https://doub.bid/ss-jc42
[bbr]: https://doub.bid/wlzy-22

<!-- more -->

### 安装、配置 SSR

#### 系统要求

** CentOS 6+ / Debian 6+ / Ubuntu 14.04+ **

#### 脚本特点

- 支持 限制 端口限速
- 支持 限制 端口设备数
- 支持 显示 当前连接IP
- 支持 显示 SS/SSR连接+二维码
- 支持 切换管理 单/多端口
- 支持 一键安装 BBR
- 支持 一键安装 锐速
- 支持 一键安装 LotServer
- 支持 一键封禁 垃圾邮件(SMAP)/BT/PT

#### 安装步骤

```
wget -N --no-check-certificate https://raw.githubusercontent.com/michaelHL/Notes/master/2017/11/src/ssr.sh && chmod +x ssr.sh && bash ssr.sh
```

#### 文件位置

- 安装目录: `/usr/local/shadowsocksr`
- 配置文件: `/etc/shadowsocksr/user-config.json`

#### 其他说明

`ShadowsocksR` 安装后，自动设置为系统服务，所以支持使用服务来启动 / 停止等操作，同时支持开机启动。

- 启动 `ShadowsocksR`: `/etc/init.d/ssr start`
- 停止 `ShadowsocksR`: `/etc/init.d/ssr stop`
- 重启 `ShadowsocksR`: `/etc/init.d/ssr restart`
- 查看 `ShadowsocksR` 状态: `/etc/init.d/ssr status`

`ShadowsocksR` 默认支持 UDP 转发，服务端无需任何设置

#### 注意事项

- 如果协议是 `origin`，那么混淆也必须是 `plain`
- 若使用了 `chacha20` 系列加密方式，运行脚本选择选项 4 安装 `libsodium` 支持库即可

### 安装 `TCP-BBR`

```
wget -N --no-check-certificate https://raw.githubusercontent.com/michaelHL/Notes/master/2017/11/src/bbr.sh && chmod +x bbr.sh && bash bbr.sh
```

重启后，验证一下是否成功安装最新内核并开启 `TCP-BBR`，输入以下命令:

```
uname -r
sysctl net.ipv4.tcp_available_congestion_control
# 返回值一般为
# net.ipv4.tcp_available_congestion_control = bbr cubic reno
# ————————————
sysctl net.ipv4.tcp_congestion_control
# 返回值一般为
# net.ipv4.tcp_congestion_control = bbr
# ————————————
sysctl net.core.default_qdisc
# 返回值一般为
# net.core.default_qdisc = fq
# ————————————
lsmod | grep bbr
# 返回值有 tcp_bbr 模块即说明bbr已启动
```
