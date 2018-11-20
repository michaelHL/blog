---
title: Matlab 程序设计之编程技巧
date: 2018-07-07 14:37:06
tags:
    - Matlab
categories: Tips and Tricks
mathjax: true
---

记录学习 Matlab 中的技巧。

<!-- more -->

### fprintf 技巧

Matlab 中的运算均基于向量，甚至连输出函数 `fprintf` 也不例外。
对于一个实际问题：

{% note info %}
$3$ 对情侣参加婚礼，$3$ 个新郎为 $A$、$B$、$C$，$3$ 个新娘为 $X$、$Y$、$Z$。有人不知道谁和谁结婚，于是询问 $6$ 位新人中的 $3$ 位，$3$ 人回答道：$A$ 和 $X$ 结婚；$X$ 和 $C$ 结婚；$C$ 和 $Z$ 结婚。但 $3$ 人说的全是假话。
{% endnote %}

为判明事实真相，穷举即可：

```matlab
for A='X':'Z' for B='X':'Z' for C='X':'Z'
    if A ~= 'X' && C ~= 'X' && C ~= 'Z' && A ~= B && B ~= C && C ~= A
        fprintf('新郎 %c 将和新娘 %c 结婚\n', ['A', 'B', 'C'; A, B, C]);
    end
end; end; end

% 新郎 A 将和新娘 Z 结婚
% 新郎 B 将和新娘 X 结婚
% 新郎 C 将和新娘 Y 结婚
```

注意到一条语句便可产生 $3$ 条输出，说明应以向量的角度思考看待问题。

### 灵活的输入输出

验证算术平均数 $A_n=\frac 1n \sum a$、几何平均数 $G_n=\prod a^{1/n}$、调和平均数 $H_n=n/(\sum 1/a)$、平方平均数 $Q_n=\sqrt{1/n \sum a^2}$ 的大小关系为 $H_n \leqslant G_n \leqslant A_n \leqslant Q_n$。代码如下：

```matlab
[A, G, H, Q] = averages(1, 2, 3, 4, 5, 6, 7, 8);
T = averages([1;2;3], [2;4;5], [6;4;7], [9;7;4], [8;3;5]);
disp([A G H Q]);
disp(T);

function varargout = averages(varargin)
    n = nargin;
    [An, Gn, Hn, Qn] = deal(0, 1, 0, 0);
    for k=1:n
        ak = varargin{k};
        if any(ak) <= 0, error('输入参数必须为正数.'), end;
        An = An + ak;
        Gn = Gn .* ak;
        Hn = Hn + 1 ./ ak;
        Qn = Qn + ak .^ 2;
    end
    A = An / n;
    G = Gn .^ (1/n);
    H = n ./ Hn;
    Q = sqrt(Qn/n);

    if nargout == 1
        varargout{1} = table(...
            A, G, H, Q, 'VariableNames', ...
            {'Arithmetic', 'Geometric', 'Harmonic', 'Square'} ...
        );
    else
        [varargout{1:4}] = deal(A, G, H, Q);
    end
end

%    4.5000    3.7644    2.9435    5.0498

%    Arithmetic    Geometric    Harmonic    Square
%    __________    _________    ________    ______
%    5.2           3.8664       2.6277      6.0992
%      4           3.6768       3.3871      4.3359
%    4.8           4.6179       4.4397        4.98
```

这段代码有很多地方可圈可点。首先通过 `varargin`、`varargout` 说明函数 `averages` 是「变长度」输入输出函数，也就是说如果调用该函数的时候可以针对不同的输入、输出表现出不同的结果，如代码中的判断语句，针对 `nargout` 实现了分别赋值给四个输出参数、输出表格的不同表现形式；在初始化参数时运用 `deal` 实现了「多重赋值」；在处理每个 `varargin(k)` 时将其视为数组，并进行必要的判断。
