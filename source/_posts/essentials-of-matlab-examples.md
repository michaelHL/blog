---
title: Matlab 程序设计示例
date: 2018-07-07 14:38:59
categories: Development and Deployment
tags:
    - Matlab
mathjax: true
---

记录 Matlab 经典、有趣的程序例子。

<!-- more -->

### 三位数

将 $1\sim 9$ 这 $9$ 个数字组成 $3$ 个三位数，要求第 $2$ 个三位数是第 $1$ 个三位数的 $2$ 倍，要求第 $3$ 个三位数是第 $1$ 个三位数的 $3$ 倍，找出所有可行方案。  
笔者的思路很简单，首先初始化一个 $1 \times 10$ 数组代表数码 $0 \sim 9$ 出现的次数，把试验的数组拼接成字符，再一个萝卜一个萝卜地填坑，如果坑 $1$ 至坑 $9$ 全部被填满则符合题意；比如 $123123123$ 填坑的结果就是
$[0\ 1\ 1\ 1\ 0\ 0\ 0\ 0\ 0\ 0]$，“坑”没有被填满，不符题意。
{% fold 代码 %}
{% codeblock lang:matlab %}
count = 0;
for m = 123:329
    digs = zeros(1, 10);
    nums = m * (1:3);
    allc = strrep(num2str(nums), ' ', '');
    for k = 1:9
        digs(allc(k)-'0'+1) = 1;
    end
    if sum(digs(2:end)) == 9
        count = count + 1;
        fprintf('第 %d 组解: %s\n', count, mat2str(nums));
    end
end

% 第 1 组解: [192 384 576]
% 第 2 组解: [219 438 657]
% 第 3 组解: [273 546 819]
% 第 4 组解: [327 654 981]
{% endcodeblock %}
{% endfold %}

当然《MATLAB 数值计算实战》作者的代码更加赏心悦目：

{% codeblock lang:matlab %}
count = 0;
for m = 123:329
    s = num2str(m * [1;2;3]) - '0';
    if isequal(sort(s(:)).', 1:9)
        count = count + 1;
        fprintf('第 %d 组解: %s\n', count, mat2str(m * (1:3)));
    end
end
{% endcodeblock %}
首先其转化为字符的过程中使用了列向量而行向量，于是 `s` 为 $3 \times 3$ 的数组，而笔者则需要把重心放在字符串的处理上，相当伤脑筋。后面直接将 `s` 拉直、转置为 $1 \times 9$ 的字符数组进行排序，与 $1:9$ 进行对比即可，一气呵成。

### 杨辉三角

对于给定行数，美观输出杨辉三角，需要事先确定好每个数字所占宽度，这里将宽度设定为所有数字中最大数的字符个数的两倍（$2d$）。其次需要控制好三角形左边的空格长度。

{% fold 代码 %}
```matlab
function pasc_triangle(N)
    m = fix(log10(nchoosek(N-1, ceil((N-1)/2))))+1;
    d = ceil((m+3)/2);
    x = 1;
    fprintf([blanks(d*(N-1)), '%-', int2str(2*d), 'd\n'], x);
    for k=2:N
        fprintf(blanks(d*(N-k)));
        x = [0, x]+[x, 0];
        fprintf(['%-', int2str(2*d), 'd'], x);
        % fprintf('%-*d', [repmat(2*d, 1, length(x)); x]);
        fprintf('\n');
    end
end
```
{% endfold %}

### 约瑟夫环

设有 $n$ 个人围成一圈，从位置 $s\ (1 \leqslant s \leqslant n)$ 上的人从 $1$ 开始报数，数到 $m$ 的人即出列。下一个人即原来第 $m+1$ 位置上的人又从 $1$ 报数，报到第 $m$ 个人出列。重复此过程直至所有人全部出列位置。

首先需要理解一个简单的公式。
{% note %}
$n$ 个有序点围成的圆圈中第 $x$ 个元素按照序号增大的方向移动 $k$ 步后所在的位置为
$$
    (x+k-1) \ \text{mod} \ n + 1 \tag{J} \label{J}
$$
{% endnote %}

于是以下两种方法均可实现算法。

```matlab
function seq = joseph1(n, s, m)
    seq = [];
    seat = ones(1, n);
    s = s - 1;
    while any(seat)
        for k = 1:m
            s = 1 + mod(s, n);
            while ~seat(s)
                s = 1 + mod(s, n);
            end
        end
        seat(s) = 0;
        seq = [seq, s];
    end
end

function seq = joseph2(n, s, m)
    seq = zeros(1, n);
    seat = 1:n;
    s = s - 1;
    for k = n:-1:1
        s = mod(s + m - 1, k);
        seq(n - k + 1) = seat(s + 1);
        seat(s + 1) = [];
    end
end
```

第一种方法思路很简单：总体不变，因为每轮会有人出局，所以设置“落座”记号，有人为 $1$ 无人为 $0$。每轮需要有 $m$ 次“有效的”移动，即移动到下一个座位上必须有人，否则继续移动。  
第二种代码就比较简洁了，程序中的 $s$ 时始终表示下一轮第一个人前面的位置，所以公式 $\eqref{J}$ 需要减去 $1$。每轮结束移除已出列的数字，直至数组为空为止。

### 连续数字出现次数

对于一个行向量 $[0\ 0\ 0\ 1\ 1\ 1\ 0\ 1\ 1\ 0\ 0\ 1\ 1\ 1\ 0\ 0\ 0\ 1]$，统计连续 $1$ 出现的位置以及次数。

考虑其一阶差分：$[0\ 0\ 1\ 0\ 0\ -1\ 1\ 0\ -1\ 0\ 1\ 0\ 0\ -1\ 0\ 0\ 1]$，可观察到原向量中开始出现 $1$ 的位置在差分后的向量中也为 $1$，并结束于 $-1$ 之前。但考虑到首末问题，应该在原向量首尾各添加 $0$ 以保证正确性。代码如下：

```matlab
x = [0 0 0 1 1 1 0 1 1 0 0 1 1 1 0 0 0 1];
dx = diff([0 x 0]);
res = [find(dx==1); find(dx==-1) - find(dx==1)]

% res =
%     4     8    12    18
%     3     2     3     1
```

