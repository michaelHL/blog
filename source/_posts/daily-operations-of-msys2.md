---
title: MSYS2 的日常操作
date: 2017-11-07 18:48:36
tags:
    - MSYS2
    - Linux
    - Windows
    - ConEmu
categories: Handy Utilities
---

在自己的 Windows 10 系统上使用 [MSYS2][msys2] 已经有段时间了，Windows 上的类 \*nix 工作环境简直不要太完美，办事效率杠杠的（如果没事少折腾的话）。为啥不用 Cygwin？因为很卡很慢，连 DUANG 的特效也拯救不了它，而且它的 POSIX 权限问题会把文件系统弄的一团糟。下面开始记录从刚开始的小白逐渐成为现在熟练使用的 ~~大牛~~ 大白的辛酸历程...

<!-- more -->

## MSYS2 安装与配置

这里主要参考 [MSYS2开发环境搭建][csdn-48601775]。

1. 下载 MSYS2 installer，建议安装路径不要包含空格（个人装在了 `D:\MSYS2` 下）
1. 安装完毕后，开始菜单中生成的三个快捷方式为：
   {% codeblock lang:bash %}
   MSYS2 MinGW 32-bit - D:\MSYS2\msys2_shell.cmd -mingw32
   MSYS2 MinGW 64-bit - D:\MSYS2\msys2_shell.cmd -mingw64
   MSYS2 MSYS         - D:\MSYS2\msys2_shell.cmd -msys
   {% endcodeblock %}
1. 修改软件源，修改 `/etc/pacman.d/` 目录下的三个文件，换上清华的 repo，`.msys`，`.mingw32`，`.mingw64` 分别对应 MSYS2 里的三套系统，分别在三个文件最上方填写（注意对应）：
   {% codeblock lang:bash %}
   Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch
   Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686
   Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64
   {% endcodeblock %}
1. 任选一个（`mingw32.exe`，`mingw64.exe`，`msys2.exe`）进入 MSYS2 的终端，更新系统：
   {% codeblock lang:bash %}
   pacman -Syu
   {% endcodeblock %}
   提示需退出后更新, 强行关闭后重进, 再重复上述命令即可。
   更新其他包:
   {% codeblock lang:bash %}
   pacman -Su
   {% endcodeblock %}
1. 安装开发工具链：
   {% codeblock lang:bash %}
   pacman -S base-devel
   pacman -S gcc
   pacman -S mingw-w64-x86_64-toolchain
   pacman -S mingw-w64-i686-toolchain
   pacman -S mingw64/mingw-w64-x86_64-clang
   pacman -S mingw32/mingw-w64-i686-clang
   {% endcodeblock %}
1. 添加环境变量 `PATH`。由于个人 `PATH` 中存有 `Perl` 的开发工具路径，所以考虑将 MSYS2 的路径置于其后：
   {% codeblock lang:bash %}
   ...
   \Strawberry\perl\bin
   \Strawberry\perl\site\bin
   \MSYS2\usr\bin
   \MSYS2\mingw64\bin
   \Strawberry\c\bin
   ...
   {% endcodeblock %}

## 个性化设置

### 自动挂载文件

```plain /etc/fstab
# For a description of the file format, see the Users Guide
# http://cygwin.com/cygwin-ug-net/using.html#mount-table
# DO NOT REMOVE NEXT LINE. It remove cygdrive prefix from path
none / cygdrive binary,posix=0,noacl,user 0 0
C:\Users\xxx\Desktop /desktop
D:\MSYS2\home\xxx\Notes /notes
F:\WorkingDirectory\Work\__current /current
```

### 配置文件

于个人 `home` 目录中，个性化各种配置：

- 比如与 `mintty` 相关的配置：
  {% fold .minttyrc %}
  {% codeblock lang:ini .minttyrc %}
  BoldAsFont=no
  BoldAsColour=yes
  BoldColour=255,255,128
  Font=SauceCodePro NF
  FontIsBold=no
  FontHeight=10
  RowSpacing=1
  ShowHiddenFonts=yes
  CursorColour=255,255,0
  Transparency=high
  Locale=en_US
  Charset=UTF-8
  BellType=0
  CursorType=block
  CursorBlinks=no
  Term=xterm
  Columns=135
  Rows=35
  CtrlShiftShortcuts=no
  Scrollbar=none
  ClicksTargetApp=yes
  ForegroundColour=223,223,223
  {% endcodeblock %}
  {% endfold %}
- 比如常用的 [`.bashrc`][bashrc-config]：
  {% fold .bashrc %}
  {% codeblock .bashrc lang:bash %}
  # To the extent possible under law, the author(s) have dedicated all
  # copyright and related and neighboring rights to this software to the
  # public domain worldwide. This software is distributed without any warranty.
  # You should have received a copy of the CC0 Public Domain Dedication along
  # with this software.
  # If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

  # ~/.bashrc: executed by bash(1) for interactive shells.

  # The copy in your home directory (~/.bashrc) is yours, please
  # feel free to customise it to create a shell
  # environment to your liking.  If you feel a change
  # would be benifitial to all, please feel free to send
  # a patch to the msys2 mailing list.

  # User dependent .bashrc file

  # If not running interactively, don't do anything
  [[ "$-" != *i* ]] && return

  # Shell Options
  #
  # See man bash for more options...
  #
  # Don't wait for job termination notification
  # set -o notify
  #
  # Don't use ^D to exit
  # set -o ignoreeof
  #
  # Use case-insensitive filename globbing
  # shopt -s nocaseglob
  #
  # Make bash append rather than overwrite the history on disk
  # shopt -s histappend
  #
  # When changing directory small typos can be ignored by bash
  # for example, cd /vr/lgo/apaache would find /var/log/apache
  # shopt -s cdspell

  # Completion options
  #
  # These completion tuning parameters change the default behavior of bash_completion:
  #
  # Define to access remotely checked-out files over passwordless ssh for CVS
  # COMP_CVS_REMOTE=1
  #
  # Define to avoid stripping description in --option=description of './configure --help'
  # COMP_CONFIGURE_HINTS=1
  #
  # Define to avoid flattening internal contents of tar files
  # COMP_TAR_INTERNAL_PATHS=1
  #
  # Uncomment to turn on programmable completion enhancements.
  # Any completions you add in ~/.bash_completion are sourced last.
  # [[ -f /etc/bash_completion ]] && . /etc/bash_completion

  # History Options
  #
  # Don't put duplicate lines in the history.
  # export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
  #
  # Ignore some controlling instructions
  # HISTIGNORE is a colon-delimited list of patterns which should be excluded.
  # The '&' is a special pattern which suppresses duplicate entries.
  # export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
  # export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
  #
  # Whenever displaying the prompt, write the previous line to disk
  # export PROMPT_COMMAND="history -a"

  # Aliases
  #
  # Some people use a different file for aliases
  # if [ -f "${HOME}/.bash_aliases" ]; then
  #   source "${HOME}/.bash_aliases"
  # fi
  #
  # Some example alias instructions
  # If these are enabled they will be used instead of any instructions
  # they may mask.  For example, alias rm='rm -i' will mask the rm
  # application.  To override the alias instruction use a \ before, ie
  # \rm will call the real rm not the alias.
  #
  # Interactive operation...
  # alias rm='rm -i'
  # alias cp='cp -i'
  # alias mv='mv -i'
  #
  # Default to human readable figures
  alias df='df -h'
  alias du='du -h'
  #
  # Misc :)
  alias less='less -r'                          # raw control characters
  alias whence='type -a'                        # where, of a sort
  alias grep='grep --color'                     # show differences in colour
  alias egrep='egrep --color=auto'              # show differences in colour
  alias fgrep='fgrep --color=auto'              # show differences in colour
  #
  # Some shortcuts for different directory listings
  alias ls='ls -hF --color=tty'                 # classify files in colour
  alias dir='ls --color=auto --format=vertical'
  alias vdir='ls --color=auto --format=long'
  alias ll='ls -l'                              # long list
  alias la='ls -A'                              # all but . and ..
  alias l='ls -CF'                              #
  alias hexopull='cd ~/Hexo && git fetch --all && git reset --hard origin/master && git pull'
  alias hexopush='cd ~/Hexo && hexo clean && hexo g -d && git add -A && git commit -m "update" && git push origin master'
  alias algpull='cd ~/alg && git fetch --all && git reset --hard origin/master && git pull'
  alias algpush='cd ~/alg && hexo clean && hexo g -d && git add -A && git commit -m "update" && git push origin master'
  alias hexodebug='hexo clean && hexo g && hexo s --debug'

  # Umask
  #
  # /etc/profile sets 022, removing write perms to group + others.
  # Set a more restrictive umask: i.e. no exec perms for others:
  # umask 027
  # Paranoid: neither group nor others have any perms:
  # umask 077

  # Functions
  #
  # Some people use a different file for functions
  # if [ -f "${HOME}/.bash_functions" ]; then
  #   source "${HOME}/.bash_functions"
  # fi
  #
  # Some example functions:
  #
  # a) function settitle
  # settitle ()
  # {
  #   echo -ne "\e]2;$@\a\e]1;$@\a";
  # }
  #
  # b) function cd_func
  # This function defines a 'cd' replacement function capable of keeping,
  # displaying and accessing history of visited directories, up to 10 entries.
  # To use it, uncomment it, source this file and try 'cd --'.
  # acd_func 1.0.5, 10-nov-2004
  # Petar Marinov, http:/geocities.com/h2428, this is public domain
  # cd_func ()
  # {
  #   local x2 the_new_dir adir index
  #   local -i cnt
  #
  #   if [[ $1 ==  "--" ]]; then
  #     dirs -v
  #     return 0
  #   fi
  #
  #   the_new_dir=$1
  #   [[ -z $1 ]] && the_new_dir=$HOME
  #
  #   if [[ ${the_new_dir:0:1} == '-' ]]; then
  #     #
  #     # Extract dir N from dirs
  #     index=${the_new_dir:1}
  #     [[ -z $index ]] && index=1
  #     adir=$(dirs +$index)
  #     [[ -z $adir ]] && return 1
  #     the_new_dir=$adir
  #   fi
  #
  #   #
  #   # '~' has to be substituted by ${HOME}
  #   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
  #
  #   #
  #   # Now change to the new dir and add to the top of the stack
  #   pushd "${the_new_dir}" > /dev/null
  #   [[ $? -ne 0 ]] && return 1
  #   the_new_dir=$(pwd)
  #
  #   #
  #   # Trim down everything beyond 11th entry
  #   popd -n +11 2>/dev/null 1>/dev/null
  #
  #   #
  #   # Remove any other occurence of this dir, skipping the top of the stack
  #   for ((cnt=1; cnt <= 10; cnt++)); do
  #     x2=$(dirs +${cnt} 2>/dev/null)
  #     [[ $? -ne 0 ]] && return 0
  #     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
  #     if [[ "${x2}" == "${the_new_dir}" ]]; then
  #       popd -n +$cnt 2>/dev/null 1>/dev/null
  #       cnt=cnt-1
  #     fi
  #   done
  #
  #   return 0
  # }
  #
  # alias cd=cd_func

  alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
  alias e=explorer
  alias giturl='curl -i https://git.io -F'
  alias poweroff='(shutdown -s -t 0 &); (net stop autossh_5679 &);'
  alias reboot='(shutdown -r -t 0 &); (net stop autossh_5679 &);'
  # alias uptime='net stats server | grep -P -o "[\d/]+.*M$" --color=never'
  alias lcd='/e/UtilityPrograms/_exe/TurnOffLCD.exe'
  # alias pb='~/App/pastebinit/pastebinit -b http://paste.ubuntu.com'
  # alias pb='~/App/pastebinit/pastebinit -b http://paste.ubuntu.org.cn'
  alias wolfram='winpty /e/Mathematica/11.1/wolfram'
  alias loginpc='cygrunsrv -S autossh_5679'
  alias viz='vim `which z`'
  alias memopull='cd ~/memos && git fetch --all && git reset --hard origin/master && git pull'
  alias memopush='cd ~/memos && hexo clean && hexo g -d && git add -A && git commit -m "update" && git push origin master'

  HISTTIMEFORMAT='%F %T '
  HISTCONTROL=erasedups
  HISTIGNORE="ls:pwd:cd:clear:vim:fg:bg:jobs:top:htop"

  export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
  export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
  export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
  export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
  export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
  export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
  export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

  # export http_proxy="http://192.168.1.102:1888/"
  # export https_proxy="https://192.168.1.102:1888/"
  # export ftp_proxy="ftp://192.168.1.102:1888/"

  # export PS1="[\[\e[01;33m\]foo\[\e[37;40m\]@\[\e[34;40m\]PHANTOM \[\e[37;40m\]\t \[\e[34;40m\]\W\[\e[0m\]]$ "
  export PS1="[ \[\e[37;40m\]\t \[\e[34;40m\]\W\[\e[0m\] ]$ "
  export GTAGSLIBPATH=$GTAGSLIBPATH:/usr/include/
  export HISTFILESIZE=50000
  export HISTSIZE=50000

  export PATH=$PATH:~/App/bin
  export PATH=$PATH:/e/Nodejs
  export PATH=$PATH:/c/Users/Liang/AppData/Roaming/npm
  export PATH=$PATH:/e/MySQL/bin
  export PATH=$PATH:/d/Java/jdk-10/bin
  export PATH=$PATH:/f/WorkingDirectory/Bin
  export PATH=$PATH:/e/TexLive/2018/bin/win32
  export PATH=$PATH:/e/R/bin/x64
  export PATH=$PATH:/f/WorkingDirectory/Bin
  export PATH=$PATH:/c/Users/Liang/AppData/Roaming/local/bin

  # STACK_ROOT=/f/HaskellStack
  {% endcodeblock %}
  {% endfold %}
- 比如 Git 需要代理:
  {% fold .gitconfig %}
  {% codeblock .gitconfig lang:ini %}
  [user]
      name = michaelHL
      email = lbgnmic@gmail.com
  [github]
      user = michaelHL
  [http]
      proxy = socks5://127.0.0.1:1888
  {% endcodeblock %}
  {% endfold %}
- 比如忽略大小写的 `.inputrc`：
  {% fold .inputrc %}
  {% codeblock .inputrc lang:bash %}
  # To the extent possible under law, the author(s) have dedicated all 
  # copyright and related and neighboring rights to this software to the 
  # public domain worldwide. This software is distributed without any warranty. 
  # You should have received a copy of the CC0 Public Domain Dedication along 
  # with this software. 
  # If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

  # ~/.inputrc: readline initialization file.

  # The copy in your home directory (~/.inputrc) is yours, please
  # feel free to customise it to create a shell
  # environment to your liking.  If you feel a change
  # would be benifitial to all, please feel free to send
  # a patch to the msys2 mailing list.

  # the following line is actually
  # equivalent to "\C-?": delete-char
  # "\e[3~": delete-char

  # VT
  # "\e[1~": beginning-of-line
  # "\e[4~": end-of-line

  # kvt
  # "\e[H": beginning-of-line
  # "\e[F": end-of-line

  # rxvt and konsole (i.e. the KDE-app...)
  # "\e[7~": beginning-of-line
  # "\e[8~": end-of-line

  # VT220
  # "\eOH": beginning-of-line
  # "\eOF": end-of-line

  # Allow 8-bit input/output
  # set meta-flag on
  # set convert-meta off
  # set input-meta on
  # set output-meta on
  #$if Bash
    # Don't ring bell on completion
    set bell-style none

    # or, don't beep at me - show me
    #set bell-style visible

    # Show all instead of beeping first
    set show-all-if-ambiguous off

    # Filename completion/expansion
    set completion-ignore-case on
    #set show-all-if-ambiguous on

    # Expand homedir name
    #set expand-tilde on

    # Append "/" to all dirnames
    #set mark-directories on
    #set mark-symlinked-directories on

    # visible-stats
    # Append a mark according to the file type in a listing
    set visible-stats off
    set mark-directories on

    # Match all files
    #set match-hidden-files on

    # 'Magic Space'
    # Insert a space character then performs
    # a history expansion in the line
    #Space: magic-space
  #$endif

  # MSYSTEM is emacs based
  $if mode=emacs
    # Common to Console & RXVT
    "\C-?": backward-kill-line         # Ctrl-BackSpace
    "\e[2~": paste-from-clipboard      # "Ins. Key"
    "\e[5~": beginning-of-history      # Page up
    "\e[6~": end-of-history            # Page down

    $if term=msys # RXVT
      "\e[7~": beginning-of-line      # Home Key
      "\e[8~": end-of-line            # End Key
      "\e[11~": display-shell-version # F1
      "\e[15~": re-read-init-file     # F5
      "\e[12~": "Function Key 2"
      "\e[13~": "Function Key 3"
      "\e[14~": "Function Key 4"
      "\e[17~": "Function Key 6"
      "\e[18~": "Function Key 7"
      "\e[19~": "Function Key 8"
      "\e[20~": "Function Key 9"
      "\e[21~": "Function Key 10"
    $else
    # Eh, normal Console is not really cygwin anymore, is it? Using 'else' instead. -mstormo
    # $if term=cygwin # Console
      "\e[1~": beginning-of-line      # Home Key
      "\e[4~": end-of-line            # End Key
      "\e[3~": delete-char      # Delete Key
      "\e\e[C": forward-word      # Alt-Right
      "\e\e[D": backward-word      # Alt-Left
      "\e[1;5C": forward-word   # ctrl + right
      "\e[1;5D": backward-word  # ctrl + left 
      "\e[17~": "Function Key 6"
      "\e[18~": "Function Key 7"
      "\e[19~": "Function Key 8"
      "\e[20~": "Function Key 9"
      "\e[21~": "Function Key 10"
      "\e[23~": "Function Key 11"
    $endif
  $endif
  {% endcodeblock %}
  {% endfold %}
- 比如 Vim 配置文件 [`.vimrc`][vimrc-config]

### 编译 Vim

```bash
pacman -S ncurses-devel libcrypt-devel
./configure --with-features=huge \
            --enable-luainterp=yes \
            --enable-perlinterp=yes \
            --enable-pythoninterp=yes \
            --enable-python3interp=yes \
            --with-lua-prefix=/usr/local \
            --enable-fontset=yes \
            --enable-cscope=yes \
            --enable-multibyte \
            --disable-gui \
            --enable-fail-if-missing \
            --prefix=/usr/local \
            --with-compiledby='Professional operations'
```

这里提醒自己下，折腾有度，比如尝试在 MSYS2 中编译 [ycm][youcompleteme]
十几次未遂这种行为是不可取的。

### 替换默认终端

将自带的 [Mintty][mintty] 换成 Windows 下很棒的终端模拟器：[ConEmu][conemu]。

1. 设置为默认的系统终端程序，替换掉残废的 cmd：`Settings` - `Integration` -
   `Default term - Force ConEmu as default terminal for console applications`
1. 如果希望「劫持」某些程序调试时使用的终端程序（比如 VS 在调试时会唤起系统默认的 cmd），在下面的输入框中填入 `explorer.exe|devenv.exe`
1. 对于 MSYS2 的集成：
   1. 新建 Task：`set MSYSTEM=MINGW64 & "/path/to/MSYS-connector -cur_console:n"`
   1. Connector 网址：[cygwin-connector][connector]，不同版本的设置如下：
      - Cygwin：`conemu-cyg-32.exe` and `conemu-cyg-64.exe`
      - MSYS 1.0：`conemu-msys-32.exe`
      - MSYS 2.0：`conemu-msys2-32.exe` and `conemu-msys2-64.exe`

      复制到 `sh.exe` 同目录下即可
1. 启动时的相关设定（`Settings` - `Startup` - `Environment）`：
   {% codeblock lang:bat %}
   set PATH=%ConEmuBaseDir%\Scripts;%PATH%
   chcp utf-8
   set LANG=en_US.utf-8
   {% endcodeblock %}
1. 当前的配置文件 [conemu.xml][conemu-config]

 {% fa warning fw %}新版本的 ConEmu 已经自带了适配各种系统下的 `connector`，所以在 Task 里面关于 `connector` 的路径直接填写其程序名即可。（见 [cygwin/msys terminal connector][conemu-official-connector]）

#### 题外话 - Sublime Text 调用 ConEmu

对于一般程序，在设置中的 `Integration` - `Default term` - `List of ...`
中添加程序，ConEmu 将被自动唤起以替代 cmd，但添加 Sublime Text 的 `sublime_text.exe` 并没有反应，只能曲线救国，比如 C 类型文件的编译配置文件 `C.sublime-build`：

{% codeblock C.sublime-build lang:json %}
{
    // "shell_cmd": "gcc -std=c11 -Wall -s \"${file}\" -o \"${file_path}/${file_base_name}\" && \"${file_path}/${file_base_name}\"",
    "shell_cmd": "/path/to/conemu /single -run cmd /c -cur_console:n \"gcc -std=c11 -Wall -s ${file} -o ${file_path}/${file_base_name} && ${file_path}/${file_base_name} & pause \"",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "working_dir": "${file_path}",
    "selector": "source.c"
}
{% endcodeblock %}

--------------------------

## 问题

- 如果发现程序的输出被缓冲：可尝试利用工具 `winpty`
- `git clone` 时出现字符相关的奇怪问题：使用 **MSYS** 而不是 MinGW64 或者 MinGW32
- 2018-02-09 {% fa warning fw %} ncurses 版本升级为 `ncurses-6.1.20180127-1-x86_64`
  后 ConEmu 终端会出现各种光标问题，可通过回退版本至 [`ncurses-6.0.20170708-2-x86_64`][ncurses-20170708] 来解决：
  {% codeblock lang:bash %}
  pacman -R ncurses-devel
  pacman -U ncurses-6.0.20170708-2-x86_64.pkg.tar.xz --force
  {% endcodeblock %}
- 2018-02-10 {% fa warning fw %} 如果集成在 VSCode 中的 MSYS2
  也出现上述情况, 可考虑直接使用 `connector`：
  {% codeblock settings.json lang:json %}
  {
      "terminal.integrated.shell.windows": "E:/UtilityPrograms/ConEmu/ConEmu/conemu-msys2-64.exe",
  }
  {% endcodeblock %}
  或者如果仅需为清屏设置快捷键：
  {% codeblock keybindings.json lang:json %}
  {
      "key": "ctrl+l",
      "command": "workbench.action.terminal.clear",
      "when": "terminalFocus"
  }
  {% endcodeblock %}


[msys2]: http://www.msys2.org
[csdn-48601775]: http://blog.csdn.net/callinglove/article/details/48601775
[youcompleteme]: https://github.com/Valloric/YouCompleteMe
[mintty]: https://mintty.github.io
[conemu]: https://conemu.github.io
[vimrc-config]: /src/vimrc
[bashrc-config]: /src/bashrc
[conemu-config]: /src/conemu.xml
[connector]: https://github.com/Maximus5/cygwin-connector
[ncurses-20170708]: https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/x86_64/ncurses-6.0.20170708-2-x86_64.pkg.tar.xz
[conemu-official-connector]: https://conemu.github.io/en/CygwinMsysConnector.html#cygwinmsys-terminal-connector
