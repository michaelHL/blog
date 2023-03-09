---
title: 部署 RStudio Server
date: 2018-02-03 21:18:51
tags:
    - R
    - RStudio
    - Server
categories: Development
---

在 Ubuntu 16.04.3 下部署 RStudio Server {% fa registered fw %}。

RStudio 是一款优秀的 R 语言集成开发软件，官方免费提供社区版 RStudio Server，默认支持多用户登录。

<!-- more -->

首先安装 R 的最新版本（参考 [UBUNTU PACKAGES FOR R][cran-ubuntu-pkgs]）:

```bash
sudo apt-get remove r-base-core
echo 'deb https://mirrors.ustc.edu.cn/CRAN/bin/linux/ubuntu xenial/' | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt-get update
sudo apt-get install r-base r-base-dev
```

下载安装 RStudio Server（参考官方[下载页面][download-server]）：

```bash
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.1.419-amd64.deb
sudo gdebi rstudio-server-1.1.419-amd64.deb
```

完成之后可进行 `rstudio-server {status|start|stop|restart|}` 等操作。

进一步，可对 RStudio Server 进行深度配置：

```ini /etc/rstudio/rserver.conf
www-port=9999
server-app-armor-enabled=0
```

Nginx 配置：

```nginx nginx.conf
http {

  map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
  }

  server {
    listen 80;

    location / {
      proxy_pass http://localhost:9999;
      proxy_redirect http://localhost:9999/ $scheme://$host/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_read_timeout 20d;
    }
  }
}
```


[cran-ubuntu-pkgs]: https://cran.rstudio.com/bin/linux/ubuntu/README.html
[download-server]: https://www.rstudio.com/products/rstudio/download-server
