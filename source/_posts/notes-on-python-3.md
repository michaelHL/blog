---
title: Python 3 拾零
date: 2018-01-23 11:29:14
tags:
    - Python
categories: Memos
---

Python 3.x 笔记。

<!-- more -->

1. 编码声明。`python` 文件前两行的注释若能被正则匹配到 `coding[=:]\s*([-\w.]+)`，则括号中的内容即被认为是文档编码声明。一般花哨的形式有（GNU Emacs）：
   {% codeblock lang:python %}
   # -*- coding: <encoding-name> -*-
   {% endcodeblock %}
   或 (Bram Moolenaar’s VIM):
   {% codeblock lang:python %}
   # vim:fileencoding=<encoding-name>
   {% endcodeblock %}
   文档搜索关键字：`Encoding declarations`
1. 正则模块函数 `re.match` 仅从字符串开头开始匹配
1. Jupyter Notebook 分享代码 [http://nbviewer.ipython.org](http://nbviewer.ipython.org)
1. 上述网站可渲染 Github 仓库 / Gist 的 .ipynb 文件，但如果文件改动，需在网址后加
   `?flush_cache=true` 强制刷新
1. 推荐 Python 安装包国内镜像网站: [http://mirrors.sohu.com/python](http://mirrors.sohu.com/python)
1. Jupyter Notebook 更改 MathJax 字体方法：
   [https://stackoverflow.com/a/44290246/4154610](https://stackoverflow.com/a/44290246/4154610)
1. [计算 `datatime` 加上特定月数后的日期](https://stackoverflow.com/a/15155212/4154610)：
   {% codeblock lang:python %}
   from datetime import datetime
   from dateutil.relativedelta import relativedelta

   date_after_month = datetime.today()+ relativedelta(months=1)
   print('Today: ',datetime.today().strftime('%d/%m/%Y'))
   print('After Month:', date_after_month.strftime('%d/%m/%Y'))
   {% endcodeblock %}
1. 代码语法高亮显示工具 [Pygments](http://pygments.org)： `pip install pygments`，命令为 `pygmentize`
1. Pycharm 自带的代码格式工具风格不同于 `autopep8`，`yapf` 等，在遇到单行长代码（如公式）时，在运算符前面回行，可保证一定的美观度（`#` 表示第 79 列）：
   {% codeblock lang:python %}
   # Before:
   eq1 = (n0 * (1 / alpha + ln(beta)) - summation(ln(t[i]), (i, 0, n0 - 1)) + beta ** alpha * (summation(t[i] ** (-alpha) * ln(t[i]), (i, 0, n0 - 1)) - ln(alpha) * summation(t[i] ** (-alpha), (i, 0, n0 - 1)))).replace(t, ts)
   eq2 = (n0 - beta ** alpha * summation(t[i] ** (-alpha), (i, 0, n0 - 1))).replace(t, ts)

   # After:
   eq1 = (n0 * (1 / alpha + ln(beta))                                         #
          - summation(ln(t[i]), (i, 0, n0 - 1)) + beta ** alpha               #
          * (summation(t[i] ** (-alpha) * ln(t[i]), (i, 0, n0 - 1))           #
             - ln(alpha) * summation(t[i] ** (-alpha),                        #
                                     (i, 0, n0 - 1)))).replace(t, ts)         #
   eq2 = (n0 - beta ** alpha                                                  #
          * summation(t[i] ** (-alpha), (i, 0, n0 - 1))).replace(t, ts)       #
   {% endcodeblock %}
1. Python 时光机 --- [Python-Future](http://python-future.org/compatible_idioms.html)
1. 利用 `json` 库将 Python 对象转为 Json 对象时，所有键都会被转化为字符串，所以如果对字典对象进行转换，可能出现 `x != loads(dump(x))` 的情形
1. 如利用 `Conda` 作为包管理器，当包越来越多时可能出现同时用 Pip 和 Conda 装过的同名包，而这种情况处理起来也比较棘手（如果随意删除安装其中的包可能导致各种依赖关系问题）。所以建议用 Conda 新建环境时候先用 Conda 安装大部分包，再用 Pip 安装没有被 Conda 仓库收录的包。如科学计算方面，可先利用 Conda 安装 `nb-conda-kernels`，此操作会自动安装 Jupyter、IPython 等科学计算环境，再利用 Pip 安装其它包即可
1. Python 二进制包合集 [Unofficial Windows Binaries for Python Extension Packages](https://www.lfd.uci.edu/~gohlke/pythonlibs)
1. Visual Studio Code（VSCode）中新建 Jupyter 文档显示 No Kernel 时，如果 Python 环境为 Anaconda / Miniconda，通常由于 Sqlite3 问题，可以在 [SQLite Download Page](https://www.sqlite.org/download.html) 下载 `sqlite3.dll` 复制到 Python 环境中的 `DLLs` 目录下，如 `D:\Miniconda\envs\py37\DLLs`
1. 利用 `xlrd` 库的 `open_workbook` 函数打开 Excel 文件后，如需关闭此文件，需显式调用 `<opened_workbook>.release_resources()` 进行释放
