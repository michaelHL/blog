---
title: Java 核心技术学习笔记一
date: 2020-08-11 21:04:49
tags:
    - Java
categories: Development
---

## 语法解析

> Unicode 转义序列会在解析代码之前得到处理。例如，`"\u0022+\u0022"` 并不是一个由引号（U+0022）包围加号构成的字符串。实际上，`\u0022` 会在解析之前转换为 `"`，这回得到 `""+""`，也就是一个空串。

<!-- more -->

下面是利用简单的 Python 脚本对 Java 代码进行「转换」：

```Python
def str_to_utf16(s, filt=None):
    """
    字符串转 Java 风格 16 进制编码
    """

    filt = filt if filt is not None else set('{}')
    return ''.join([c if c in filt else char_to_utf16_expr(c) for c in s])


def char_to_utf16_expr(s):
    """
    单个字符转 UTF-16-BE 编码（Java 风格，即 \uhhhh）
    """

    utf16 = ''
    utf16_arr = list(bytes(s, 'utf-16-be'))

    for i in range(len(utf16_arr) // 2):
        utf16 += r'\u' + ''.join(map('%02x'.__mod__, utf16_arr[2 * i:2 * (i + 1)]))

    return utf16


if __name__ == "__main__":
    s = """public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Fuck Java!😑");
        System.out.println("Meet Python😀!!!");
        System.out.println("");
        System.out.println("The Zen of Python, by Tim Peters");
        System.out.println("Beautiful is better than ugly.");
        System.out.println("Explicit is better than implicit.");
        System.out.println("Simple is better than complex.");
        System.out.println("Complex is better than complicated.");
        System.out.println("Flat is better than nested.");
        System.out.println("Sparse is better than dense.");
        System.out.println("Readability counts.");
        System.out.println("Special cases aren't special enough to break the rules.");
        System.out.println("Although practicality beats purity.");
        System.out.println("Errors should never pass silently.");
        System.out.println("Unless explicitly silenced.");
        System.out.println("In the face of ambiguity, refuse the temptation to guess.");
        System.out.println("There should be one-- and preferably only one --obvious way to do it.");
        System.out.println("Although that way may not be obvious at first unless you're Dutch.");
        System.out.println("Now is better than never.");
        System.out.println("Although never is often better than *right* now.");
        System.out.println("If the implementation is hard to explain, it's a bad idea.");
        System.out.println("If the implementation is easy to explain, it may be a good idea.");
        System.out.println("Namespaces are one honking great idea -- let's do more of those!");
    }
}"""
    print(str_to_utf16(s, '\n'))
```

输出如下：

```
\u0070\u0075\u0062\u006c\u0069\u0063\u0020\u0063\u006c\u0061\u0073\u0073\u0020\u0048\u0065\u006c\u006c\u006f\u0057\u006f\u0072\u006c\u0064\u0020\u007b
\u0020\u0020\u0020\u0020\u0070\u0075\u0062\u006c\u0069\u0063\u0020\u0073\u0074\u0061\u0074\u0069\u0063\u0020\u0076\u006f\u0069\u0064\u0020\u006d\u0061\u0069\u006e\u0028\u0053\u0074\u0072\u0069\u006e\u0067\u005b\u005d\u0020\u0061\u0072\u0067\u0073\u0029\u0020\u007b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0046\u0075\u0063\u006b\u0020\u004a\u0061\u0076\u0061\u0021\ud83d\ude11\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u004d\u0065\u0065\u0074\u0020\u0050\u0079\u0074\u0068\u006f\u006e\ud83d\ude00\u0021\u0021\u0021\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0054\u0068\u0065\u0020\u005a\u0065\u006e\u0020\u006f\u0066\u0020\u0050\u0079\u0074\u0068\u006f\u006e\u002c\u0020\u0062\u0079\u0020\u0054\u0069\u006d\u0020\u0050\u0065\u0074\u0065\u0072\u0073\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0042\u0065\u0061\u0075\u0074\u0069\u0066\u0075\u006c\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u0075\u0067\u006c\u0079\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0045\u0078\u0070\u006c\u0069\u0063\u0069\u0074\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u0069\u006d\u0070\u006c\u0069\u0063\u0069\u0074\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0053\u0069\u006d\u0070\u006c\u0065\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u0063\u006f\u006d\u0070\u006c\u0065\u0078\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0043\u006f\u006d\u0070\u006c\u0065\u0078\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u0063\u006f\u006d\u0070\u006c\u0069\u0063\u0061\u0074\u0065\u0064\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0046\u006c\u0061\u0074\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u006e\u0065\u0073\u0074\u0065\u0064\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0053\u0070\u0061\u0072\u0073\u0065\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u0064\u0065\u006e\u0073\u0065\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0052\u0065\u0061\u0064\u0061\u0062\u0069\u006c\u0069\u0074\u0079\u0020\u0063\u006f\u0075\u006e\u0074\u0073\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0053\u0070\u0065\u0063\u0069\u0061\u006c\u0020\u0063\u0061\u0073\u0065\u0073\u0020\u0061\u0072\u0065\u006e\u0027\u0074\u0020\u0073\u0070\u0065\u0063\u0069\u0061\u006c\u0020\u0065\u006e\u006f\u0075\u0067\u0068\u0020\u0074\u006f\u0020\u0062\u0072\u0065\u0061\u006b\u0020\u0074\u0068\u0065\u0020\u0072\u0075\u006c\u0065\u0073\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0041\u006c\u0074\u0068\u006f\u0075\u0067\u0068\u0020\u0070\u0072\u0061\u0063\u0074\u0069\u0063\u0061\u006c\u0069\u0074\u0079\u0020\u0062\u0065\u0061\u0074\u0073\u0020\u0070\u0075\u0072\u0069\u0074\u0079\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0045\u0072\u0072\u006f\u0072\u0073\u0020\u0073\u0068\u006f\u0075\u006c\u0064\u0020\u006e\u0065\u0076\u0065\u0072\u0020\u0070\u0061\u0073\u0073\u0020\u0073\u0069\u006c\u0065\u006e\u0074\u006c\u0079\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0055\u006e\u006c\u0065\u0073\u0073\u0020\u0065\u0078\u0070\u006c\u0069\u0063\u0069\u0074\u006c\u0079\u0020\u0073\u0069\u006c\u0065\u006e\u0063\u0065\u0064\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0049\u006e\u0020\u0074\u0068\u0065\u0020\u0066\u0061\u0063\u0065\u0020\u006f\u0066\u0020\u0061\u006d\u0062\u0069\u0067\u0075\u0069\u0074\u0079\u002c\u0020\u0072\u0065\u0066\u0075\u0073\u0065\u0020\u0074\u0068\u0065\u0020\u0074\u0065\u006d\u0070\u0074\u0061\u0074\u0069\u006f\u006e\u0020\u0074\u006f\u0020\u0067\u0075\u0065\u0073\u0073\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0054\u0068\u0065\u0072\u0065\u0020\u0073\u0068\u006f\u0075\u006c\u0064\u0020\u0062\u0065\u0020\u006f\u006e\u0065\u002d\u002d\u0020\u0061\u006e\u0064\u0020\u0070\u0072\u0065\u0066\u0065\u0072\u0061\u0062\u006c\u0079\u0020\u006f\u006e\u006c\u0079\u0020\u006f\u006e\u0065\u0020\u002d\u002d\u006f\u0062\u0076\u0069\u006f\u0075\u0073\u0020\u0077\u0061\u0079\u0020\u0074\u006f\u0020\u0064\u006f\u0020\u0069\u0074\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0041\u006c\u0074\u0068\u006f\u0075\u0067\u0068\u0020\u0074\u0068\u0061\u0074\u0020\u0077\u0061\u0079\u0020\u006d\u0061\u0079\u0020\u006e\u006f\u0074\u0020\u0062\u0065\u0020\u006f\u0062\u0076\u0069\u006f\u0075\u0073\u0020\u0061\u0074\u0020\u0066\u0069\u0072\u0073\u0074\u0020\u0075\u006e\u006c\u0065\u0073\u0073\u0020\u0079\u006f\u0075\u0027\u0072\u0065\u0020\u0044\u0075\u0074\u0063\u0068\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u004e\u006f\u0077\u0020\u0069\u0073\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u006e\u0065\u0076\u0065\u0072\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0041\u006c\u0074\u0068\u006f\u0075\u0067\u0068\u0020\u006e\u0065\u0076\u0065\u0072\u0020\u0069\u0073\u0020\u006f\u0066\u0074\u0065\u006e\u0020\u0062\u0065\u0074\u0074\u0065\u0072\u0020\u0074\u0068\u0061\u006e\u0020\u002a\u0072\u0069\u0067\u0068\u0074\u002a\u0020\u006e\u006f\u0077\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0049\u0066\u0020\u0074\u0068\u0065\u0020\u0069\u006d\u0070\u006c\u0065\u006d\u0065\u006e\u0074\u0061\u0074\u0069\u006f\u006e\u0020\u0069\u0073\u0020\u0068\u0061\u0072\u0064\u0020\u0074\u006f\u0020\u0065\u0078\u0070\u006c\u0061\u0069\u006e\u002c\u0020\u0069\u0074\u0027\u0073\u0020\u0061\u0020\u0062\u0061\u0064\u0020\u0069\u0064\u0065\u0061\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u0049\u0066\u0020\u0074\u0068\u0065\u0020\u0069\u006d\u0070\u006c\u0065\u006d\u0065\u006e\u0074\u0061\u0074\u0069\u006f\u006e\u0020\u0069\u0073\u0020\u0065\u0061\u0073\u0079\u0020\u0074\u006f\u0020\u0065\u0078\u0070\u006c\u0061\u0069\u006e\u002c\u0020\u0069\u0074\u0020\u006d\u0061\u0079\u0020\u0062\u0065\u0020\u0061\u0020\u0067\u006f\u006f\u0064\u0020\u0069\u0064\u0065\u0061\u002e\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0020\u0053\u0079\u0073\u0074\u0065\u006d\u002e\u006f\u0075\u0074\u002e\u0070\u0072\u0069\u006e\u0074\u006c\u006e\u0028\u0022\u004e\u0061\u006d\u0065\u0073\u0070\u0061\u0063\u0065\u0073\u0020\u0061\u0072\u0065\u0020\u006f\u006e\u0065\u0020\u0068\u006f\u006e\u006b\u0069\u006e\u0067\u0020\u0067\u0072\u0065\u0061\u0074\u0020\u0069\u0064\u0065\u0061\u0020\u002d\u002d\u0020\u006c\u0065\u0074\u0027\u0073\u0020\u0064\u006f\u0020\u006d\u006f\u0072\u0065\u0020\u006f\u0066\u0020\u0074\u0068\u006f\u0073\u0065\u0021\u0022\u0029\u003b
\u0020\u0020\u0020\u0020\u007d
\u007d
```

上述代码在 Intellij Idea 中新建 Java 文件  `HelloWorld.java` 可正常编译运行。当然，除非是出于安全考虑（但还原成可读版代码并无难度），实际情况中不会有人写这样的代码。仅需关注该「特性」但可能导致一个陷阱：

{% blockquote %}
{% codeblock lang:Java %}
// \u00A0 is a newline
{% endcodeblock %}
会产生一个语法错误，程序会将 <code>\u00A0</code> 替换为一个换行符。总之，<code>\u</code> 在 Java 程序解析前进行转换。
{% endblockquote %}

## UTF-16 字符编码

### 基本概念

* 代码单元（Code Unit）：最小的数位组合，可以表示用于处理或交换的编码文本的单位。在 Unicode 标准中，UTF-8 编码格式采用 8 位编码单元，UTF-16 编码格式采用 16 位编码单元，UTF-32 编码格式采用 32 位编码单元
* BMP 字符（BMP Character）：位于 BMP（Basic Multilingual Plane，多语种基本面）代码点的 Unicode 编码字符
* BMP 代码点（BMP Code Point）：在 U+0000 到 U+FFFF 范围内的 Unicode 代码点
* 补充字符（Supplementary Character）：位于补充代码点的 Unicode 编码字符
* 补充代码点（Supplementary Code Point）：在 U+10000 到 U+10FFFF 范围内的 Unicode 代码点
* 高代理项代码点（High-Surrogate Code Point）：在 U+D800 到 U+DBFF 范围内的 Unicode 代码点
* 低代理项代码点（Low-Surrogate Code Point）：在 U+DC00 到 U+DFFF 范围内的 Unicode 代码点
* 代理项对（Surrogate Pair）：由两个 16 位代码单元组成，其中第一个是高代理项代码单元，第二个是低代理项代码单元

### 编码转换算法

```
0x10000 is subtracted from the code point (U), leaving a 20-bit number (U') in the hex number range 0x00000–0xFFFFF. Note for these purposes, U is defined to be no greater than 0x10FFFF.
The high ten bits (in the range 0x000–0x3FF) are added to 0xD800 to give the first 16-bit code unit or high surrogate (W1), which will be in the range 0xD800–0xDBFF.
The low ten bits (also in the range 0x000–0x3FF) are added to 0xDC00 to give the second 16-bit code unit or low surrogate (W2), which will be in the range 0xDC00–0xDFFF.
Illustrated visually, the distribution of U' between W1 and W2 looks like:[13]

U' = yyyyyyyyyyxxxxxxxxxx  // U - 0x10000
W1 = 110110yyyyyyyyyy      // 0xD800 + yyyyyyyyyy
W2 = 110111xxxxxxxxxx      // 0xDC00 + xxxxxxxxxx
The high surrogate and low surrogate are also known as "leading" and "trailing" surrogates, respectively, analogous to the leading and trailing bytes of UTF-8.
```

### Java 中的 UTF-16 编码

> 在 Java 中，`char` 类型描述了 UTF-16 编码中的**一个**代码单元。

一个代码单元用 16 位 / 2 字节 / 4 个 16 进制数表示，UTF-16 编码表示的字符由一个或一对代码单元表示。用一对代码单元表示的码点范围从 U+10000 到 U+10FFFF，高位代理项码点范围从 U+D800 到 U+DBFF，低代理项码点范围从 U+DC00 到 U+DFFF。

<br>

下面列举几个常用的代码单元 / 字符遍历相关的操作：

| 作用            | 代码                                                                                       |
| :--             | :--                                                                                        |
| 代码单元数量    | {% codeblock lang:Java %}String greeting = "Hello!😁";
int codeUnitCount = greeting.length(); // 8.
{% endcodeblock %} |
| 第 n 个代码单元 | {% codeblock lang:Java %}// n 的取值范围从 0 到 s.length() - 1
char nthChar = greeting.charAt(n);
{% endcodeblock %} |
| 码点数量        | {% codeblock lang:Java %}int cpCount = greeting.codePointCount(0, greeting.length()); // 7
{% endcodeblock %} |
| 第 i 个码点     | {% codeblock lang:Java %}// i 的取值范围从 0 到 cpCount - 1
int index = greeting.offsetByCodePoints(0, i);
int cp = greeting.codePointAt(index);
{% endcodeblock %} |
| 顺序遍历每个代码单元 | {% codeblock lang:Java %}int cp = greeting.codePointAt(index);
index += Character.isSupplementaryCodePoint(cp) ? 2 : 1;
{% endcodeblock %} |
| 逆序遍历每个代码单元 | {% codeblock lang:Java %}index--;
if (Character.isLowSurrogate(greeting.charAt(index)))
    index--;
{% endcodeblock %} |
| 字符串转为码点数组 | {% codeblock lang:Java %}int[] codePoints = greeting.codePoints().toArray();
{% endcodeblock %} |
| 码点数组转为字符串 | {% codeblock lang:Java %}String str = new String(codePoints, 0, codePoints.length);
{% endcodeblock %} |

完整测试代码：

{% codeblock lang:Java Test.java %}
public class Test {
    public static void main(String[] args) {
        String greeting = "Hello😁😁";

        // traverse through a string
        System.out.println("Iteration:");
        int index = 0;
        while (index < greeting.length()) {
            int cp = greeting.codePointAt(index);
            System.out.printf("%2d | %d -> %s\n", index, cp, new String(Character.toChars(cp)));
            index += Character.isSupplementaryCodePoint(cp) ? 2 : 1;
        }

        // traverse inversely
        System.out.println("Reverse:");
        index = greeting.length();
        while (index > 0) {
            index--;
            if (Character.isLowSurrogate(greeting.charAt(index)))
                index--;
            int cp = greeting.codePointAt(index);
            System.out.printf("%2d | %d -> %s\n", index, cp, new String(Character.toChars(cp)));
        }

        int[] codePoints = greeting.codePoints().toArray();
        System.out.println(new String(codePoints, 0, codePoints.length));
    }
}

/*
Iteration:
 0 | 72 -> H
 1 | 101 -> e
 2 | 108 -> l
 3 | 108 -> l
 4 | 111 -> o
 5 | 128513 -> 😁
 7 | 128513 -> 😁
Reverse:
 7 | 128513 -> 😁
 5 | 128513 -> 😁
 4 | 111 -> o
 3 | 108 -> l
 2 | 108 -> l
 1 | 101 -> e
 0 | 72 -> H
Hello😁😁
*/
{% endcodeblock %}
