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
