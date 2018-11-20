---
title: 编译 YouCompleteMe
date: 2018-01-29 16:46:34
tags:
    - Vim
    - YCM
categories: Operation and Maintenance
---

由 [Valloric][valloric-person] 开发的 Vim 插件 [YouCompleteMe][ycm-repo] 可以算上是最难安装的 Vim 插件了，折腾记录如下。

<!-- more -->

## CentOS 7.3

### 更新 GCC

CentOS 7.3 自带的 GCC 版本只有 4.8.5，Ubuntu 16.04 的 GCC 版本已经到了 5.4.0。所以如果是 CentOS 系统，第一步一定要更新 GCC 版本，否则后续过程寸步难行。具体过程从略。

### 编译 YCM

根据官方的 [安装指南][ycm-official-installation]，有如下操作步骤：

```bash
cd ~/.vim/bundle/
git clone https://github.com/Valloric/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
mkdir -p ~/ycm_temp/
cd ~/ycm_temp/
wget http://releases.llvm.org/4.0.1/clang+llvm-4.0.1-x86_64-linux-gnu-debian8.tar.xz
tar -xvf clang+llvm-4.0.1-x86_64-linux-gnu-debian8.tar.xz
mkdir -p ~/ycm_build
cd ~/ycm_build
cmake -G "Unix Makefiles" \
      -DPATH_TO_LLVM_ROOT=~/ycm_temp/clang+llvm-4.0.1-x86_64-linux-gnu-debian8 \
      -DPYTHON_INCLUDE_DIR=/usr/include/python3.4m \
      -DPYTHON_LIBRARY=/usr/lib64/libpython3.so \
      -DUSE_PYTHON2=OFF \
. ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core
```

这里仅用 `Python 3.x` 版本，所以使用 `-DUSE_PYTHON2=OFF` 选项。

### C 语言家族支持

在家目录中新建文件 [.ycm_extra_conf.py][ycm_extra_conf]。

### vimrc 配置

```vim .vimrc
Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_server_python_interpreter = '/usr/bin/python3'
set completeopt=longest,menu
let g:ycm_semantic_triggers = {
\ 'c' : ['->', '.', ' ', '(', '[', '&'],
\ 'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
\ 'perl' : ['->', '::', ' '],
\ 'php' : ['->', '::', '.'],
\ 'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
\ 'ruby' : ['.', '::'],
\ 'lua' : ['.', ':']
\ }
```

## Ubuntu 16.04

由于 Python 库路径与 CentOS 系统有所不同，`cmake` 部分有少许变动。

```bash
cd ~/.vim/bundle/
git clone https://github.com/Valloric/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
mkdir -p ~/ycm_temp/
cd ~/ycm_temp/
wget http://releases.llvm.org/5.0.1/clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
tar -xvf clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
mkdir -p ~/ycm_build
cd ~/ycm_build
cmake -G "Unix Makefiles" \
      -DPATH_TO_LLVM_ROOT=~/ycm_temp/clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-16.04 \
      -DPYTHON_INCLUDE_DIR=/usr/include/python3.5m \
      -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m.so \
      -DUSE_PYTHON2=OFF \
      . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core```

--------------------------------------------------------------------

## Windows

Windows 下编译比较烦琐，各工具需单独下载。

### 原料

- [Clang for Windows (64-bit)][clang-windows]
- [Python][python]
- [CMake][cmake]
- [Visual Studio][vs]
- MinGW GCC（测试用 MSYS2 系统里面的 MinGW64 替代）

测试时各版本如下：

| Entries       | Version    |
| :----:        | :----:     |
| Clang         | 4.0.1 x64  |
| Python        | 2.7.10 x64 |
| CMake         | 3.9.0 x64  |
| Visual Studio | 2017       |
| MinGW GCC     | 7.1.0      |
| Git           | -          |

### 编译

为防止环境变量 `PATH` 干扰，暂时删除在 `PATH` 中 MSYS2 的两个路径（`/mingw64/bin`，`/usr/bin` 包含 `clang`，`cmake` 和 `python`），加入刚才安装的 Cmake 路径（Python，Clang 的路径并不需要）。下面一套动作即可完成编译：

```cmd
git clone http://github.com/Valloric/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
mkdir build
cd build
cmake -G "Visual Studio 15 Win64" ^
      -DPATH_TO_LLVM_ROOT=D:/LLVM ^
      -DPYTHON_INCLUDE_DIR=D:/Python/Python27/include ^
      -DPYTHON_LIBRARY=D:/Python/Python27/libs/python27.lib ^
      . ../third_party/ycmd/cpp
cmake --build . --target ycm_core --config Release
```

这里明确指明了 LLVM 的目录以及 Python 的库，当然如果要在 Python 3.x 下编译，需将 `cmake` 部分改为：

```bash
cmake -G "Visual Studio 15 Win64" ^
      -DPATH_TO_LLVM_ROOT=D:/LLVM ^
      -DPYTHON_INCLUDE_DIR=D:/Python/Python36/include ^
      -DPYTHON_LIBRARY=D:/Python/Python36/libs/python36.lib ^
      -DUSE_PYTHON2=OFF . ../third_party/ycmd/cpp
```

上述的 Python，LLVM，Visual Studio，CMake 的版本会直接影响编译结果，从多次编译的结果上看，LLVM 的版本宜 3.9+，且 Python 和 LLVM 的位数需匹配，而且 Python 2.7.11，Python 2.7.13 版本即便编译成功，在后续的使用中仍会出问题。

### 测试

编译好之后，在 VSCode 中使用 [you-complete-me](https://github.com/richard1122/vscode-youcompleteme) 插件尝试，有少许小问题（不提示系统库函数，但按下 `.` 之后才有提示。对引入的系统头文件警告等），总体不影响使用，而且支持跳转、peek。

附上 VSCode 中的配置：

```json
"ycmd.path": "E:\\YouCompleteMe\\third_party\\ycmd",
"ycmd.confirm_extra_conf": true,
"ycmd.global_extra_config": "F:\\WorkingDirectory\\Configuration\\common\\_ycm_extra_conf.py",
"ycmd.python": "D:\\Python\\Python27\\python.exe",
```

以及 YCM 所需的 [_ycm_extra_conf.py][_ycm_extra_conf]。

原料里面的各工具的版本试了又试，`Python 2.7.10` + `LLVM Clang 4.0.1` 是最佳组合。

### 致谢

- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
- [LLVM](https://clang.llvm.org/)
- [GCC](https://gcc.gnu.org/)
- [centos6.5升级gcc到4.9](http://blog.techbeta.me/2015/10/linux-centos6-5-upgrade-gcc/)
- [CentOS 6.5 升级 GCC 4.9.3](http://www.cnblogs.com/wanghaiyang1930/p/5608531.html)
- [Linux下GLIBCXX和GLIBC版本低造成的编译错误的解决方案](http://blog.csdn.net/officercat/article/details/39519265)
- [Centos7安装vim8.0 + YouCompleteMe](http://blog.csdn.net/nzyalj/article/details/75331822)
  - 该博主利用 `devtoolset` 来更新 GCC 版本，不过在测试中无效
- [打造VIM利器](http://www.jianshu.com/p/e9cb158f7048)

--------------------------------------------------------

## 问题

- 不能对 Anaconda 中的包进行补全。应重新编译 YCM，编译时与 Anaconda 相关的路径不应出现在 `PATH` 中，且 `.vimrc` 中应注释掉关于 `g:ycm_server_python_interpreter` 的行。参考 [YouCompleteMe does not work with Anaconda Python][ycm-issue-1241]。

[valloric-person]: https://github.com/Valloric
[ycm-repo]: https://github.com/Valloric/YouCompleteMe
[ycm-official-installation]: https://github.com/Valloric/YouCompleteMe#installation
[ycm_extra_conf]: /src/.ycm_extra_conf.py
[clang-windows]: http://releases.llvm.org/4.0.1/LLVM-4.0.1-win64.exe
[python]: https://www.python.org/download
[cmake]: https://cmake.org/download
[vs]: https://www.visualstudio.com
[_ycm_extra_conf]: /src/_ycm_extra_conf.py
[ycm-issue-1241]: https://github.com/Valloric/YouCompleteMe/issues/1241#issuecomment-335051278
