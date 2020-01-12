---
title: Windows 问题与技巧
date: 2018-01-24 20:39:34
tags:
    - Windows
categories: Tips and Tricks
---

记录 Windows {% fa windows fw %} 下遇到的问题、技巧与备忘。

<!-- more -->

1. JetBrains 的 Vim 插件配置文件放在 `~/.ideavimrc`
1. MS Access 自动切换输入法修复方法： Options -> Client Settings -> Datasheet IME control
1. 关闭恼人的 `Connected User Experiences and Telemetry` 服务：
    1. 打开计划任务程序，定位到 Microsoft - Windows - Application Experience，禁用 Microsoft Compatibility Appraiser
    1. 打开服务，禁用 Connected User Experiences and Telemetry
    1. 打开组策略，依次定位 Computer Configuration -  Administrative Templates - Windows Components - Data Collection and Preview Builds - Allow Telemetry，设为 Disabled
1. 卸载 OneDrive：
   1. 不让 OneDrive 弹出： `Win-X-A` - `taskkill /f /im OneDrive.exe`
   2. `%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall`（注意系统位）
1. Mobaxterm 中设置 Cygwin 的源：
    - `apt-cyg -m http://mirrors.neusoft.edu.cn/cygwin/ install/remove. ...`
    - `apt-cyg -m http://mirrors.ustc.edu.cn/cygwin/ install/remove ...`
    - `apt-cyg -m http://mirrors.aliyun.com/cygwin/ install/remove ...`
    - `apt-cyg -m http://mirrors.163.com/cygwin/ install/remove ...`
1. MobaXterm 中的 Cygwin 如有命令出错，有可能是版本过低
1. MobaXterm 中如果无法安装包（一般出现校验值错误的情况），可手动下载 `setup.ini`，注意版本为 `x86`
1. Sublime Text 插件 SFTP 注册码：（在 `Settings-User` 中加入）
   {% codeblock lang:json %}
   {
       "email":"Rimke@163.com",
       "product_key":"e83eda-38644b-43c828-e3669b-cd8a85",
   }
   {% endcodeblock %}
1. Sublime Text 插件 AStyleFormatter 报错：安装 Microsoft Visual C++ 2010 SP1 Redistributable Package (x64)
1. Sublime Text 主题插件 Boxy 深度定制：
    - `Boxy` 侧边栏背景色：`Sidebar Tree Defaults - "sidebar_tree"`
    - `Boxy` 侧边栏分隔：`"class": sidebar_container"，"layer0.tint"`
1. Potplayer 遇到「单声道」的情况，将声音 - 环绕置 0 即可
1. 任务栏透明: [StartIsBack](http://www.zdfans.com/5573.html)
1. win 7 下一些控件、动态链接库无法注册问题的终极解决办法（**不推荐**）:
   激活并登陆 `Administrator` 账户（一定必须为该名称，   即使为管理员账户也不能行使此账户的一些职权）
1. 清除各种显卡右键菜单：
    - Nvidia：
      - 清除：`regsvr32 /u nvcpl.dll`
      - 显示：`regsvr32 nvcpl.dll`
    - Intel：
      - 清除：`regsvr32 /u igfxsrvc.dll`
      - 显示：`regsvr32 igfxsrvc.dll`
    - Ati：
      - 清除：`regsvr32 /u atiacmxx.dll`
      - 显示：`regsvr32 atiacmxx.dll`
    - Intel集成：
      - 清除：`regsvr32 /u igfxpph.dll`
      - 显示：`regsvr32 igfxpph.dll`
1. 修复 vbs 默认打开方式：`cmd /c cscript/h:wscript`
1. 无法附着到任务栏：
   {% codeblock lang:dos %}
   cmd /k reg add "HKEY_CLASSES_ROOT\lnkfile" /v IsShortcut /f
   cmd /k reg add "HKEY_CLASSES_ROOT\piffile" /v IsShortcut /f
   cmd /k taskkill /f /im explorer.exe & explorer.exe
   {% endcodeblock %}
1. 启动项文件夹：`shell:Startup`
1. Cygwin 中 Mintty 快捷方式：`mintty.exe -i /Cygwin-Terminal.ico -`
1. npm 路径：`C:\Users\xxx\AppData\Roaming\npm`
1. tlmgr 更换 repository：
   {% codeblock lang:bash %}
   tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet
   tlmgr option repository http://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet
   {% endcodeblock %}
   CLI 下更新：
   {% codeblock lang:bash %}
   tlmgr update --self --repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/
   tlmgr update --all --repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/
   {% endcodeblock %}
1. Sublime Text 插件 SublimeREPL 出现
   `OSError: [WinError 6] The handle is invalid` 解决方案：
   {% codeblock Data/Packages/SublimeREPL/repls/subprocess_repl.py lang:python %}
   def is_alive(self):
       return True
   {% endcodeblock %}
1. Sublime Text 开启 Debug 模式：`sublime.log_commands(True)`
1. 华丽的提示符：添加环境变量 `PROMPT`，比如 `[ $e[35;40mNasty-Newbie$e[0m $b $e[1;33;40m$d $t$e[0m $b $e[1;31m$p$e[0m ]$_$e[1;33mλ$e[0m `，显示成：
   {% codeblock %}
   [ Nasty-Newbie | Sun 09/09/2018 21:52:58.55 | C:\Users\Heller ]
   λ 
   {% endcodeblock %}
1. `MSYS2` 中自动挂载文件：`/etc/fstab`，比如：
   {% codeblock %}
   # For a description of the file format, see the Users Guide
   # http://cygwin.com/cygwin-ug-net/using.html#mount-table

   # DO NOT REMOVE NEXT LINE. It remove cygdrive prefix from path
   none / cygdrive binary,posix=0,noacl,user 0 0
   C:\Users\Michael\Desktop /desktop
   D:\MSYS2\home\Michael\Notes /notes
   F:\WorkingDirectory\Work\__current /current
   {% endcodeblock %}
1. Chrome 浏览器在高分屏幕下的快捷方式：
   {% codeblock %}
   "\chrome.exe" /high-dpi-support=1 /force-device-scale-factor=1
   {% endcodeblock %}
1. 为 [SourceForge](https://sourceforge.net) 加速：
   [http://sourceforge.mirrorservice.org](http://sourceforge.mirrorservice.org)
1. Sublime Text 插件 LaTeXTools 关于 PDF 阅读器 SumaptraPDF 反向搜索的设置：
   {% codeblock lang:dos %}
   sumatrapdf.exe -inverse-search "\"C:\Program Files\Sublime Text 3\sublime_text.exe\" \"%f:%l\""
   {% endcodeblock %}
   关于公式不能预览的问题：手动从 [Ghostscript 官网](https://ghostscript.com)
   安装，并将环境路径添加至 `TexLive` 路径前面; 添加 ImageMagick 的环境路径
1. Mathtype 的官方安装包名为 `InstallMTW6.9b.exe`
1. Avast 杀毒软件的安装需要取消勾选 `Real Site`（中文名可能为 `DNS` 相关），否则网速奇慢！顺便，防火墙也别装了，简直神坑！
1. Avast 添加排除目录（添加信任）：`Settings` - `Components` - `File Shield` && `Behavior Shield` - `Customize` - `Exclusions`，否则某些程序会无端卡死（比如赖以生存的 `ConEmu`）
1. 用 UltraISO 刻录的 Windows 10 系统 U 盘无法创建分区（提示为 MBR / GPT
   分区）解决方案：删除 U 盘中文件夹 `efi/` 以及文件 `bootmgr.efi`
1. TeamViewer(TV) 提示

   > The screen cannot be captured at the moment.
   > This is probably due to fast user switching or a disconnected/minimized
   > Remote Desktop session.

   且场景为：被连接的机器为笔记本，盒上盖子，已打开 tv 服务。
   解决方案：
   - 打开笔记本盖子
   - 或将一根 HDMI 线连接至显示器
1. Sublime Text 插件 Anaconda 显示类似如下错误且伴有切换至 `python` 文件卡顿：
   {% codeblock %}
   <Anaconda.anaconda_lib.workers.local_worker.LocalWorker object at 0x000001EA4B464FD0> initial check failed because:
   connection to localhost:51568 timed out after 0.2s. tried to connect 7 times during 2 seconds
   check that there is Python process executing the anaconda jsonserver.py script running in your system. If there is, check that you can connect to your localhost writing the following script in your Sublime Text 3 console:
   import socket; socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect(("localhost", 51568))
   {% endcodeblock %}
   场景：MSYS2 环境变量 `/usr/bin`，`/mingw64/bin`；Anaconda 没有加入环境变量。
   解决方案：将 `"python_interpreter": "/path/to/python_exe"` 加入**用户配置文件** `Preferences.sublime-settings`
1. Xshell 5 中 `Shift-Tab` 效果却为切换标签处理办法：设置一次针对 `Shift-Tab` 的快捷键，再取消设置这个快捷键
1. Word 里面用 Mathtype 编辑的公式用默认的方法导出 PDF 文件时出现各类显示问题：改用 [doPDF](http://www.dopdf.com)
1. Sublime Text 插件 Clang Format 令其对全文件格式化： [Format whole file if nothing selected](https://github.com/rosshemsley/SublimeClangFormat/pull/10/commits/ea22686f40009104935a0378b7c4fd387121c8a1)
1. Sublime Text 插件 LaTeXTools 中公式渲染/预览不全解决方案：
   配置文件中为 `preview_math_template_preamble` 添加 `\usepackage[margin=2cm]{geometry}`
1. Windows 批处理在后台运行程序：`start /b xxx`，输出会在当前窗口（当然可以通过 `>nul 2>&1` 抑制输出），但是可以进行其他操作（有点类似于 *nix 中的 `&`）。或者 `start /min "" program params`，会在最小化的新窗口中运行程序，同时控制权交给当前终端
1. Potplayer 关闭左上角的进度显示：基本 -> 消息 -> 取消勾选「在屏幕上显示播放信息」
1. 自动锁屏可在屏幕保护程序中进行设置，即便是空的锁屏样式
1. MSYS2 中安装 `watch`：`pacman -S procps-ng`
1. GNU 工具源码镜像：[http://mirrors.ustc.edu.cn/gnu](http://mirrors.ustc.edu.cn/gnu)
1. Ghost 系统桌面出现顽固图标注册表：
   {% codeblock %}
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace
   {% endcodeblock %}
1. 列出所有 Windows 服务状态: `sc queryex type= service state= all | find /i "NATION"`
1. 删除 Outlook 所有账户。Outlook 删除到最后一个账户不给删除了，解决方案如下：
   1. Close Outlook.
   2. Run Windows Control Panel.
   3. Open the "Mail（Microsoft Outlook 2016）" applet and click the "Show Profiles..." button.
   4. Remove the existing "Outlook" profile.
   5. Add a new profile, name it "Outlook" and create a new account as needed.
1. Clion 中遇到输入时结果显现两次处理方案：`C-S-a`，输入 `registry`，取消勾选 `run.processes.with.pty`
   （参考 [User input appears twice in output window in CLion under MinGW](https://youtrack.jetbrains.com/issue/CPP-2580)）
1. Windows 10 彻底禁用自动更新方案：
   1. `services.msc` 中设置 `Windows Update` 服务为禁用，并在 `Recovery` 中设置为不恢复
   1. `gpedit.msc` 中: `Computer Configuration` - `Administrative Templates` -
      `Windows Components` - `Windows Update` - `Specify intranet ...`，启用此策略，并将 3 个服务器地址设为 `127.0.0.1`
1. 解决 Microsoft Word 打开时自动切换输入法问题: 选项 - 高级 - 编辑选项 -
   取消勾选「输入法控制处于活动状态」
1. Word 2016 中设置正文分栏而脚注不分栏：脚注区右键菜单 - 便笺选项 - 列 - 1 列。
   **注：** Word 2003 及之前版本如此设置无效
1. 安装完 Mathtype 后 PowerPoint 2016 打开报错「无法加载 ...ppam 加载项」，所以干脆不用，在 Windows 10 (1709) 注册表中的位置为  
   {% codeblock %}
   Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\16.0\PowerPoint\AddIns\MathType AddIn (PowerPoint 2016)
   {% endcodeblock %}
   删除即可
1. 右键打开方式中程序列表所在注册表路径：
   {% codeblock %}
   HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts
   {% endcodeblock %}
1. Microsoft Word 中设置边框时要记得重新应用边框，否则应用无效
1. 往 Microsoft Word 里面插入矢量图时建议使用 `.wmf` 类型文件，`.emf` 文件在另存为 PDF 文件时可能导致图片严重失真
1. Windows 下给快捷方式指派的快捷键有明显延迟解决方案：[slow windows desktop keyboard shortcuts](https://superuser.com/questions/426947/slow-windows-desktop-keyboard-shortcuts)
1. 修改 Windows 用户名：
   1. 以其它管理员用户 B 身份登录系统，并注销需要改名的用户 A（如果这个用户已经登录的话）。如仅有一个用户，可考虑新建管理员账户，或开启默认被禁止的 Administrator 账户（计算机管理 - 系统工具 - 本地用户和组 - 用户 - Administrator - 取消勾选账户已禁用）
   1. 直接修改用户 A 的用户目录名（「运行」输入 `..`，将文件夹 A 改名为 C）
   1. 找到注册表项
      ```
      HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\<User SID>\
      ```
      并将其改为 `C:\Users\C`。  
      「注」如何定位到 `<User SID>`：每个 `<User SID>` 的子键 `ProfileImagePath` 即为此用户的 `Profile` 目录，找到用户目录为 A 的键即可
   1. 「运行」中键入 `netplwiz`，双击用户 A 将用户名修改为 C，重启
1. NVIDIA 显卡搭载部分显示器屏幕发白 / 虚，可通过自定义 NVIDIA 色彩设定：
   - Desktop Color Depth: `Highest (32-bit)`
   - Output Color Depth: `8 bpc`
   - Output Color format: `YCbCr444`
   - Output dynamic range: `Limited`
1. 更改右键菜单相对于鼠标点击处的位置：运行中键入
   ```
   shell:::{80F3F1D5-FECA-45F3-BC32-752C152E456E}
   ```
   在弹出对话框 `Tablet PC Settings` 中切换用手习惯 `Handedness`
