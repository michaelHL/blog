---
title: CentOS 服务器部署 Hexo 博客并利用 Webhook 自动更新
date: 2017-07-16 23:01:23
tags:
    - Hexo
    - Nginx
    - Server
    - Webhook
categories: Development and Deployment
mathjax: true
---

{% cq %}
<a href="https://hexo.io">Hexo, A fast, simple & powerful blog framework.</a>
{% endcq %}

<!-- more -->

## 本地部署 Hexo

### 安装

根据 Hexo 官网的介绍，首先要安装 `Git` 以及 `Nodejs`，CentOS 系统下直接 `yum` 安装即可：

```bash
yum install git
yum install nodejs
```

两个工具都装好之后，必要时设置 `npm` 的源：

```bash
npm config set proxy https://domain:port
npm config set registry http://registry.npm.taobao.org/
```

利用 `npm` 安装 `hexo`：

```bash
npm install hexo-cli -g
```

注意 `npm` 安装的包在 `~/.npm` 目录下（所以是用户级别的）。

### 配置

初始化 Hexo:

```bash
mkdir ~/Hexo
cd ~/Hexo
hexo init
npm install
```

`Hexo` 文件夹下的 `_config.yml` 为站点配置文件，比如

```yaml _config.yml
# Site
title:
subtitle:
description:
author:
language:
timezone:
```

### 服务器

这里摘自 Hexo 官网的介绍。安装 `hexo-server` 包：

```bash
npm install hexo-server --save
```

那么输入

```bash
hexo server
```

网站就会在 `http://localhost:4000` 下启动，并且 Hexo 会监视文件变动并更新，如需改变端口或遇到 `EADDRINUSE` 错误，加上 `-p` 参数并指定端口：

```bash
hexo server -p 5000
```

### 生成器

利用 `hexo generate` 或者 `hexo g` 即可生成静态文件，生成的文件目录为 `~/Hexo/public`。

## 同步到代码托管平台

安装 [hexo-deployer-git][hexo-deployer-git]：

```bash
npm install hexo-deployer-git --save
```

在前述 `_config.yml` 文件中，找到 `deploy` 项，配置为：

```yaml _config.yml
deploy:
  type: git
  repo:
    github: git@github.com:xxx/blog.git
    coding: git@git.coding.net:xxx/blog.git
  branch: master
```

 {% fa warning fw %} 这里将 Github 上的仓库命名为 `blog`，与后文中本地仓库名相同。

直接利用 `hexo deploy` 或 `hexo d` 直接 push 到 Github 上。生成静态文件与同步可以合为一步（两者作用相同）：

```bash
hexo g -d
hexo d -g
```

详细配置过程见[官方文档][hexo-deployment]。

## 配置 Nginx

添加 [Nginx][nginx] 的 repo 并安装：

```bash
rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum info nginx
yum install nginx
```

`Nginx` 二进制文件所在目录为 `/usr/sbin/nginx`，配置目录为 `/etc/nginx/`。由于 `/etc/nginx/nginx.conf` 文件中包含

```
include /etc/nginx/conf.d/*.conf;
```

所以仅需在 `/etc/nginx/conf.d/` 下新建 `hexo.conf` 文件，配置网站信息即可：

```nginx hexo.conf
server {
  listen 80;
  server_name domain.com;
  root /var/www/blog;
  index  index.html index.htm;
}
```

- 启动Nginx服务：`service nginx start`
- 重载Nginx服务：`service nginx reload`

这里的 `root` 即为网站所在目录，大量的教程中将 `/var/www/` 设成网站所在目录，估计是约定俗成吧。那么这里就有权限问题了，刚入坑的我还并不是很了解 Linux 的权限机制，所以干脆决定在普通用户下生成静态文件，并同步至 Github，再利用系统用户利用 Webhook 从 Github 更新网站目录。

## 配置 Webhook

以 `root` 用户登录，创建两个文件：
- `sync.sh`：用于从 Github 上 pull 数据，即更新本地网站目录，注意加上执行权限
  {% codeblock sync.sh lang:bash %}
  #!/bin/bash
  echo -e "\033[32m [AUTO SYNC] sync hexo start \033[0m"
  cd /var/www/blog
  echo -e "\033[32m [AUTO SYNC] git pull...  \033[0m"
  git fetch --all
  git reset --hard origin/master
  git pull
  echo -e "\033[32m [AUTO SYNC] sync hexo finish \033[0m"
  {% endcodeblock %}
- `hexo-server.js`：接受 Github 的 post 信息后执行 `sync.sh`
  {% codeblock hexo-server.js lang:javascript %}
  var http = require('http')
  var exec = require('child_process').exec
  var createHandler = require('github-webhook-handler')
  var handler = createHandler({ path: '/webhook', secret: '******' })

  http.createServer(function (req, res) {
    handler(req, res, function (err) {
      res.statusCode = 404
      res.end('no such location')
    })
  }).listen(7777)

  handler.on('error', function (err) {
    console.error('Error:', err.message)
  })

  handler.on('push', function (event) {
    console.log('Received a push event for %s to %s',
      event.payload.repository.name,
      event.payload.ref)
    exec('/root/Scripts/sync.sh', function(err, stdout, stderr){
      if(err) {
        console.log('sync server err: ' + stderr)
      } else {
        console.log(stdout)
      }
    })
  })

  handler.on('issues', function (event) {
    console.log('Received an issue event for %s action=%s: #%d %s',
      event.payload.repository.name,
      event.payload.action,
      event.payload.issue.number,
      event.payload.issue.title)
  })
  {% endcodeblock %}

注意 `hexo-server.js` 中的 `sync.sh` 填写的是绝对路径。  
安装 `github-webhook-handler` 以及 `forever`：

```bash
npm install github-webhook-handler
npm install forever -g
```

在 Github 的仓库设置的 Webhooks 选项中，`Payload URL` 填写为：

```
http://domain.com:7777/webhook
```

这里的端口7777与上面 `hexo-server.js` 中设定的端口是一致的，`Content type` 选择 `application/json`，秘钥 `Secret` 自行设置，与上述 `js` 文件中 `******` 相同。触发事件选择仅 `push` 的时候即可。之前生成静态文件并更新至 Github 时发现 Webhooks 设置页面最下方的记录中，总出现

```bash
We couldn’t deliver this payload: Service Timeout
```

的提示，当然外网访问的博客也没有更新，说明是 Github 与阿里云服务器的沟通出了问题。结合之前部署 RStudio 服务器的经历，想起阿里云服务器配备了安全组，所以在阿里云服务器安全组规则设置页面中开放 7777 端口，这样才能正常访问。这里不知道是否可用 Nginx 来做中转，以后再折腾。  
利用之前安装的 `forever` 运行 `js` 脚本：{% codeblock hexo-server.js %}
forever start hexo-server.js
{% endcodeblock %}
当然如果要停止这个脚本: `forever stop ***.js`.

于是，写完博客，`hexo g -d` 同步到 Github 仓库，就万事大吉了：Github 接受到这样的一个 `push` 请求之后向服务器特定端口发送了一个 HTTP POST，服务器接受到这个POST后自动执行 `sync.sh`，也就是到定位本地仓库/网页目录，从 Github 上拉取最新的网页文件。

## 更新历史

- 2017-07-17 {% fa plane fw %} 修改了部分主题样式，添加部分插件，注意利用 `npm` 安装插件必须加上 `--save` 选项！
    - [{% fa font-awesome fw %}font-awesome][font-awesome] 图标：`hexo-tag-fontawesome`
    - 字数统计插件 `hexo-wordcount`，不过最新版的NexT主题已经内置该功能
    - RSS插件 `hexo-generator-feed`
    - 本地搜索服务 `hexo-generator-searchdb`
    - SEO优化 `hexo-generator-sitemap`，`hexo-generator-baidu-sitemap`
- 2017-07-18 {% fa plane fw %} 发现外网访问服务器速度实在过慢，老实投靠 Github, Coding 进行双线部署，并更新博客为二级域名，在解析上下了点功夫。加之 Coding 可以强制 https 访问，遂抛弃 Github 部署
- 2017-12-03 {% fa magic fw %} 增加 [$Mathjax$][mathjax] 支持。参考: [搭建一个支持LaTEX的hexo博客][csdn-50123231]。然而这里出现了一些意外状况，比如公式的分式的中横线显示偏低，这是不能接受的，首先将主题配置文件中 `mathjax` 设置为：
  {% codeblock lang:yaml %}
  mathjax:
    enable: true
    per_page: true
    cdn: //cdn.bootcss.com/mathjax/2.7.2/latest.js?config=TeX-MML-AM_CHTML
  {% endcodeblock %}
  这末尾的 `config=...` 极其重要，就是被这玩意儿折腾良久。关键在于公式的渲染方式，在这儿应选 `Common HTML` 而不是坑爹的 `HTML-CSS`。
  再折腾下文件 `themes/next/layout/_third-party/mathjax.swig`：
  {% codeblock lang:javascript mathjax.swig %}
  MathJax.Hub.Config({
    showProcessingMessages: false,
    messageStyle: "none",
    tex2jax: {
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      displayMath: [ ['$$', '$$'], ["\\[", "\\]"] ],
      processEscapes: true,
      skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
    },
    TeX: {
      equationNumbers: {
        autoNumber: 'AMS'
      },
      extensions: ["AMSmath.js", "AMSsymbols.js", "autobold.js"]
    }
  });
  {% endcodeblock %}
  最后，对于 IE 浏览器兼容方面出现问题的解决方案：
  {% codeblock lang:html mathjax.swig %}
  <script type="text/javascript" src="https://cdn.bootcss.com/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML"></script>
  <!-- <script type="text/javascript" src="{{ theme.mathjax.cdn }}"></script> -->
  {% endcodeblock %}
- 2017-12-03 {% fa street-view fw %} 再再次更换阵地 -- 把博客迁移至 [码云][gitee] （感觉访问速度更快些）
- 2017-12-03 {% fa smile-o fw %} 再再再次更换阵地 -- 又回到码市的怀抱，因为码云不支持自定义域名，做跳转又不清真，我只想好好写个博客 ToT
- 2017-12-03 {% fa plane fw %} 实现多端博客同步。这里采用比较暴力但高效的办法：在远程新建两个仓库，  一个私有仓库用户存储源文件（原始 Markdown 文件，各类魔改过的文件等，  将整个本地的 Hexo 目录作为本地仓库），一个公有仓库（用于展示网页）。那么这两个命令就可以手动同步了：
  {% codeblock lang:bash %}
  alias hexopull='git fetch --all && git reset --hard origin/master && git pull'
  alias hexopush='hexo clean && hexo g -d && git add -A && git commit -m "update" && git push origin master'
  {% endcodeblock %}
- 2017-12-31 {% fa plane fw %} 更换 markdown 渲染引擎。
  {% codeblock lang:bash %}
  npm uninstall hexo-renderer-marked --save
  npm install hexo-renderer-pandoc --save
  {% endcodeblock %}
- 2018-07-17 {% fa plane fw %} 添加脚注插件 `hexo-footnotes`

[hexo-deployer-git]: https://github.com/hexojs/hexo-deployer-git
[hexo-deployment]: https://hexo.io/zh-cn/docs/deployment.html
[nginx]: https://nginx.org
[font-awesome]: http://fontawesome.io
[fufuheqiu]: http://blog.fufuheqiu.com
[monsterlin]: https://monsterlin.github.io
[2wildkids-hexo-math]: http://2wildkids.com/2016/10/06/如何处理Hexo和MathJax的兼容问题
[mathjax]: https://www.mathjax.org
[csdn-50123231]: http://blog.csdn.net/Emptyset110/article/details/50123231
[gitee]: https://gitee.com
