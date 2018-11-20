---
title: Ubuntu 中安装最新版本 Clang
date: 2018-03-11 10:29:09
tags:
    - Linux
    - Ubuntu
    - Clang
categories: Operation and Maintenance
---

Ubuntu 16.04 中利用 `sudo apt-get install clang` 安装 Clang 的版本为 3.8，这个版本对现在来说确实已经很久远了，有必要升级成比较新的版本。这里几乎照搬此篇文章：[How to install latest clang (5.0) on Ubuntu 16.04 (xenial) / WSL][kowalczyk-ubuntu-clang]。

<!-- more -->

首先添加仓库：

{% codeblock lang:bash %}
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main"
{% endcodeblock %}

具体地址参考 [LLVM Debian/Ubuntu nightly packages][apt-llvm]。

直接通过 `apt-get` 安装即可：

{% codeblock lang:bash %}
sudo apt-get update
sudo apt-get install -y clang-5.0
{% endcodeblock %}

**多版本共存问题**

{% codeblock lang:bash %}
update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100
update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-5.0 1000
update-alternatives --install /usr/bin/clang++ clang /usr/bin/clang-3.8 100
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 100
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-5.0 1000
update-alternatives --config clang
update-alternatives --config clang++
{% endcodeblock %}

代码格式化工具 `clang-format` 同理。

**Vim C / C++ 代码格式化插件**

{% note info %}
<a href="https://github.com/rhysd/vim-clang-format">vim-clang-format</a><br>
Vim plugin for clang-format, a formatter for C, C++, Obj-C, Java, JavaScript, TypeScript and ProtoBuf.
{% endnote %}

该插件可以直接在 `.vimrc` 中设置代码风格，示例如下：

{% codeblock lang:vim .vimrc %}
Plugin 'rhysd/vim-clang-format'
autocmd FileType c,cpp,java nnoremap <silent> == :ClangFormat<CR>
let g:clang_format#detect_style_file = 1
{% endcodeblock %}


[kowalczyk-ubuntu-clang]: https://blog.kowalczyk.info/article/k/how-to-install-latest-clang-5.0-on-ubuntu-16.04-xenial-wsl.html
[apt-llvm]: https://apt.llvm.org
