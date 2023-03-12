---
title: gawk 重定向源码研究
date: 2022-03-30 00:20:04
tags:
    - Gawk
    - Source Code
categories: Research
---

`gawk5.1.1` 源码的 `awk.h` 文件定义了 `redirect` 这个「重定向」结构体，里面有个 `redirect_flags` 标记枚举，有这几个值：

{% codeblock lang:c %}
    RED_NONE    = 0,
    RED_FILE    = 1,
    RED_PIPE    = 2,
    RED_READ    = 4,
    RED_WRITE   = 8,
    RED_APPEND  = 16,
    RED_USED    = 64,   /* closed temporarily to reuse fd */
{% endcodeblock %}

后面主要关注 `RED_FILE`、`RED_WRITE`、`RED_USED` 这 3 个 flag。

<!-- more -->

awk 可开启 Lint 执行，会输出一些类似 DEBUG 的警告提示或错误提示：`l--lint=invalid`。当进程所用到的 `fd` 超过 `ulimit` 的时候，标准错误会输出：
```
warning: reached system limit for open files: starting to multiplex file descriptors
```
源文件 io.c:1208-1210：
```
if (do_lint && ! warned) {
    warned = true;
    lintwarn(_("reached system limit for open files: starting to multiplex file descriptors"));
}
```
这个与 awk info 里面所述一致，然后 Lint 会报
```
warning: unnecessary mixing of `>' and `>>' for file
```
这个警告提示，说明 awk 内部已经把 `>` 换成了 `>>` 在执行，在执行层面上来看符合猜想，具体代码参考 `io.c:819-826`：
```c
case redirect_output:
    outflag = (RED_FILE|RED_WRITE);
    tflag |= outflag;
    if (redirtype == redirect_output)
        what = ">";
    else
        what = ">>";
```
至于 awk 如何判断这个文件是新打开的还是已有的文件，参考 `gawkapi.c:1334-1423` 的 `api_get_file` 函数。

最重要的就是解释如何「复用」数量有限的文件描述符（`fd`），主要逻辑集中在 `io.c` 的 `redirect_string` 以及 `close_one` 函数。`close_one` 函数较为容易理解（`io.c:1200-1235`），根据注释：临时关闭并打开文件进而复用文件描述符，具体逻辑为定位到「`fd` 使用热度链表」中最不常用的那个 `fd` 开始，依次往常用的 `fd` 遍历，如果能关闭则关闭之（当然像标准输入、标准输出及标准错误这三个 `fd` 是不能关闭的）。回到调用 `close_one` 函数的 `redirect_string` 函数（`io.c:1070-1073`）后 931 行的 while 循环继续执行：
```c
while (rp->output.fp == NULL && rp->iop == NULL) {
    if (! new_rp && (rp->flag & RED_EOF) != 0) {
        save_rp = NULL;
        return rp;
    }
    mode = NULL;
    errno = 0;
    switch (redirtype) {
    case redirect_output:
        mode = binmode("w");
        if ((rp->flag & RED_USED) != 0)
            mode = (rp->mode[1] == 'b') ? "ab" : "a";
        break;
    case redirect_append:
        ...
    case redirect_pipe:
        ...
```
由于使用 `print >` 进行重定向，所以上述 `switch(redirtype)` 会走 `redirect_output` 分支，并重新使文件描述符与文件绑定（io.c:1026-1029）：
```c
if (mode != NULL) {
    errno = 0;
    rp->output.mode = mode;
    fd = (extfd >= 0) ? extfd : devopen(str, mode);
```

---

以上解释了 awk 如何在有限的系统 `ulimit -n` 设定下 `print >` 的表现如同 `>>` 且能正常处理文本。

## 附录

`awk --lint=invalid` 标准错误信息（节选）：

```
awk: cmd. line:1: (FILENAME=seq.txt FNR=97) warning: reached system limit for open files: starting to multiplex file descriptors
awk: cmd. line:1: (FILENAME=seq.txt FNR=1001) warning: unnecessary mixing of `>' and `>>' for file `output/0.txt'
awk: cmd. line:1: (FILENAME=seq.txt FNR=1002) warning: unnecessary mixing of `>' and `>>' for file `output/1.txt'
awk: cmd. line:1: (FILENAME=seq.txt FNR=1003) warning: unnecessary mixing of `>' and `>>' for file `output/2.txt'
......
awk: (FILENAME=seq.txt FNR=100000) warning: no explicit close of file `output/2.txt' provided
awk: (FILENAME=seq.txt FNR=100000) warning: no explicit close of file `output/1.txt' provided
awk: (FILENAME=seq.txt FNR=100000) warning: no explicit close of file `output/0.txt' provided
```
