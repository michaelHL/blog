---
title: 第 n 名用户
date: 2018-07-08 22:56:14
categories: Algorithms
tags:
    - Java
    - C-Sharp
mathjax: true
---

{% note info %}
<a href="https://www.codewars.com/kata/t-dot-t-t-number-6-nth-user/train/csharp">T.T.T.#6: nth user</a><br>
A product to do market research, n users to participate in the activities.
They give each user a number. The first user number is 1,
second users numbered 2, and so on... But no digits 4 and 9 in user's numbers,
that is to say the number of 3rd users is 3,
the number of 4th users is 5...the number of 8th users is 10... like this:
{% codeblock  %}
user   1st 2nd 3rd 4th 5th 6th 7th 8th 9th 10th ........ nth
number  1   2   3   5   6   7   8  10   11  12  ........ ??
{% endcodeblock  %}
Please calculate, how much is the number of the nth user?
{% endnote %}

简言之，从 $1$ 开始，将不含 $4$ 和 $9$ 的正整数依次写下来，求第 $n$ 个数。

<!-- more -->

### 简单的尝试

暴力穷举，从 $1$ 开始逐个验证是否含有数码 $4$ 和 $9$ 即可。原题仅支持 Javascript 及 C# 代码提交，所以写段 C# ：

```cs
using System;

public class Kata {
    private static Boolean CheckValidNumber(int n) {
        for (; n != 0; n /= 10)
            if (n % 10 == 4 || n % 10 == 9)
                return false;
        return true;
    }

    public static string UserNumber(int n) {
        int t = 1, tmp = 1;
        while (t++ <= n) {
            while (true)
                if (CheckValidNumber(tmp++))
                    break;
        }
        return (tmp - 1).ToString();
    }
}
```

不出所料超时：`Process was terminated. It took longer than 12000ms to complete`。

### 巧用进制

观察符合题意的数字：

```plain 列表 I
      1   2   3   5   6   7   8
 10  11  12  13  15  16  17  18
 20  21  22  23  25  26  27  28
 30  31  32  33  35  36  37  38
 50  51  52  53  55  56  57  58
 60  61  62  63  65  66  67  68
 70  71  72  73  75  76  77  78
 80  81  82  83  85  86  87  88
100 101 102 103 105 106 107 108
...
```

很容易发现每个数的个位顺序均为 $0, 1, 2, 3, 5, 6, 7, 8$, 第一行除外。如果将这个序列映射到容易处理的序列如自然数序列、其它进制数序列，则可将问题化归至简单问题上，联想到八进制的逢八进一，把上述列表按照「八进制」的规则重排：

```plain 列表 II
      1   2   3   4   5   6   7
 10  11  12  13  14  15  16  17
 20  21  22  23  24  25  26  27
 30  31  32  33  34  35  36  37
 40  41  42  43  44  45  46  47
 50  51  52  53  54  55  56  57
 60  61  62  63  64  65  66  67
 70  71  72  73  74  75  76  77
 80  81  82  83  84  85  86  87
 90  91  92  93  94  95  96  97
...
```

建立了一个一一映射 $\mathrm{II} \mapsto \mathrm{I}$。于是对于题目中的第 $n_{(10)}$ 个的数字，可先将其转为八进制后表示的数字 $n_{(8)}$，在列表 II 中定位这个数，再到列表 I 转换即可。西莎普代码实现：

```cs
private static string UserNumber(int n) {
    char[] tb = {'0', '1', '2', '3', '5', '6', '7', '8'};
    var n8 = Convert.ToString(n, 8).ToCharArray();
    for (int i = 0; i < n8.Length; i++)
        n8[i] = tb[n8[i] - '0'];
    return String.Concat(n8);
}
```

测试：

```plain
1       : 1
2       : 2
5       : 6
10      : 12
1000    : 1860
5000    : 11710
99999   : 303238
1000000 : 3751100
9999999 : 57113188
```

### 拓展 -- 包含一系列数字

> 序列 $\{c_n\}$ 由正整数中去除含有数字 $a_1, a_2, \ldots, a_k \ (k < 9, a_i \neq 0)$ 的数组成，确定其第 $N$ 项。

由于去除了 $k$ 个数码，所以这个序列中的数字由 $10 - k$ 个数码组成，这些剩下的数码记为 $ b_1, b_2, \ldots, b_{10-k} $。同样的思路，将 $0, 1, \ldots, 9-k$ 分别对应至 $b_1, b_2, \ldots, b_{10-k}$，之后将 $N$ 转为 $10 - k$ 进制数，利用这层映射关系得到原数。附上 Java 代码:

```java
public static String generalUserNumber(int n, int[] a) {
    int base = 10 - a.length;
    int[] tmp = new int[10];
    char[] b = new char[base];
    for (int t : a) tmp[t] = -1;
    for (int i = 0, j = 0; i < 10; i++) {
        if (tmp[i] != -1) {
            b[j] = (char) (i + '0');
            j++;
        }
    }
    char[] nb = Integer.toString(n, base).toCharArray();
    for (int i = 0; i < nb.length; i++)
        nb[i] = b[nb[i] - '0'];
    return String.valueOf(nb);
}
```

测试：

```plain
10   [1, 3, 5, 7, 9]          : 40
20   [2, 4, 6, 8]             : 53
30   [8, 4, 6, 9, 2, 7]       : 153
2048 [9, 8, 7, 6, 5, 4, 3, 2] : 100000000000
```
