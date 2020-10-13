---
title: MacOS 安装 Homebrew
date: 2020-09-01 21:50:29
tags:
    - MacOS
    - Homebrew
catagories: Research
---

{% centerquote %}
The Missing Package Manager for macOS (or Linux) — Homebrew
{% endcenterquote %}

作为一名业余的 Mac User，怎能不会熟练使用 Homebrew？但国内访问官方 Homebrew 速度过慢，需通过更改 Homebrew 安装源为国内源解决，以下操作主要借鉴[成功解决macos 安装homebrew速度慢][jianshu-c7c7aa34e579]。

<!-- more -->

## 下载 Homebrew 安装脚本

目前官方已经不推荐利用 Ruby 脚本的方式去安装 Homebrew 了，首先通过科技手段直接下载 [install.sh][install.sh]。

## 修改 Homebrew 源

将脚本 `install.sh` 中的

```bash
BREW_REPO="https://github.com/Homebrew/brew"
```

改为

```bash
BREW_REPO="https://mirrors.ustc.edu.cn/brew.git"
```

## 执行安装脚本

```bash
chmod +x install.sh
./install.sh
```

脚本会停在

```
==> Tapping homebrew/core
Cloning into ‘/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core’
```

此时关闭当前进程，从国内源拉取 `homebrew-core`：

```bash
git clone git://mirrors.ustc.edu.cn/homebrew-core.git/ /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core --depth=1
```

## 将 `brew` 切换到国内镜像源

```bash
# 步骤一
cd "$(brew --repo)"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
brew update
```

<br>

**ENJOY!**



[jianshu-c7c7aa34e579]: https://www.jianshu.com/p/c7c7aa34e579
[install.sh]: https://raw.githubusercontent.com/Homebrew/install/master/install.sh
