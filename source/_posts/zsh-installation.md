---
title: 安装 Zsh
date: 2017-08-17 11:02:03
tags:
    - Shell
    - Zsh
    - Linux
categories: Operation and Maintenance
---

 {% fa warning fw %} 试验场所有 CentOS(本地 + 远程)，Ubuntu 14.04+，~~MSYS2~~（比较卡,
应该是 mintty 的原因, 不打算继续折腾）。

### 安装 Zsh

{% codeblock lang:bash %}
yum install zsh
chsh -s /usr/bin/zsh
{% endcodeblock %}

### 安装 Oh-My-Zsh

官方 [repo][oh-my-zsh-repo]

{% codeblock lang:bash %}
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
{% endcodeblock %}

或

{% codeblock lang:bash %}
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
{% endcodeblock %}

详情请见 oh-my-zsh 的 [wiki][oh-my-zsh-wiki]。

<!-- more -->

### 主题

- Powerlevel9k：[repo][powerlevel9k-repo]
  {% codeblock lang:bash %}
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  {% endcodeblock %}
- 自带主题：[Themes][oh-my-zsh-themes]
- 额外主题：[External themes][oh-my-zsh-external-themes]

### 配置 zshrc

见 [`.zshrc`][zshrc] (针对 `powerlevel9k` 主题)

---

秀一发:

![](/img/zsh-on-xshell.png)

**注** 其中所用字体为 `Sauce Code Pro Nerd Font Complete Mono Windows Compatible`，官方 [repo][nerdfonts-repo]

### 常见问题

- 不能更新，提示
  `error: Cannot pull with rebase: You have unstaged changes.`
  {% codeblock lang:bash %}
  cd $ZSH && git stash && cd -
  upgrade_oh_my_zsh
  {% endcodeblock %}


[oh-my-zsh-repo]: https://github.com/robbyrussell/oh-my-zsh
[oh-my-zsh-wiki]: https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH
[oh-my-zsh-themes]: https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
[oh-my-zsh-external-themes]: https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes
[powerlevel9k-repo]: https://github.com/bhilburn/powerlevel9k
[nerdfonts-repo]: https://github.com/buzzkillhardball/nerdfonts
[zshrc]: /src/zshrc
