---
title: Matlab 数值计算之函数插值
date: 2018-07-08 23:19:15
tags:
    - Matlab
    - Interpolation
categories: Applied Mathematics
mathjax: true
---


微积分中对于连续或可导函数的研究虽有各路方法各显神通，但对于一个实际问题，若仅给出离散的数据点，通常首先要做的工作是根据这些离散点拟合出便于研究的连续函数。这类问题通常称作「数据拟合」，而其中的特殊情形便是函数插值。

<!-- more -->

多项式拟合插值中最「直接」的算法，就是对于 $n+1$ 个给定的数据点对 $(x_i, y_i), i=0,1,\ldots,n$，假设 $n$ 次多项式 $p_n(x)=\sum\limits_{i=0}^n a_ix^i$ 过所有的数据点，即 $p_n(x_i) = y_i$，即：

$$
    \underbrace{
    \begin{pmatrix}
        1 & x_0^1 & x_0^2 & \cdots & x_0^{n-1} & x_0^n \\
        1 & x_1^1 & x_1^2 & \cdots & x_1^{n-1} & x_1^n \\
        1 & x_2^1 & x_2^2 & \cdots & x_2^{n-1} & x_2^n \\
        \vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
        1 & x_{n-1}^1 & x_{n-1}^2 & \cdots & x_{n-1}^{n-1} & x_{n-1}^n \\
        1 & x_n^1 & x_n^2 & \cdots & x_n^{n-1} & x_n^n
    \end{pmatrix}
    }_{\boldsymbol{V}}
    \underbrace{
    \begin{pmatrix}
        a_0 \vphantom{x_0^{n-1}} \\
        a_1 \vphantom{x_1^{n-1}} \\
        a_2 \vphantom{x_2^{n-1}} \\
        \vdots \vphantom{\ddots \vdots} \\
        a_{n-1} \vphantom{x_{n-1}^{n-1}} \\
        a_{n} \vphantom{x_n^{n-1}}
    \end{pmatrix}
    }_{\boldsymbol{a}}
    =
    \underbrace{
    \begin{pmatrix}
        y_0 \vphantom{x_0^{n-1}} \\
        y_1 \vphantom{x_1^{n-1}} \\
        y_2 \vphantom{x_2^{n-1}} \\
        \vdots \vphantom{\ddots \vdots} \\
        y_{n-1} \vphantom{x_{n-1}^{n-1}} \\
        y_{n} \vphantom{x_n^{n-1}}
    \end{pmatrix}
    }_{\boldsymbol{y}}
$$

显然 $\boldsymbol{V}$ 为 Vandermonde 矩阵。关于 Vandermonde 行列式的计算，这里列出两种计算方法。

{% fold "Vandermonde 行列式计算方法" %}
{% note %}
$n$ 阶 Vandermonde 行列式
$$
V_n = \begin{vmatrix}
  1 & x_1 & x_1^2 & \cdots & x_1^{n-2} & x_1^{n-1} \\
  1 & x_2 & x_2^2 & \cdots & x_2^{n-2} & x_2^{n-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
  1 & x_n & x_n^2 & \cdots & x_n^{n-2} & x_n^{n-1}
\end{vmatrix}
$$
的值为
$$
V_n = \prod_{1 \mathop \leqslant i \mathop < j \mathop \leqslant n} \left({x_j - x_i}\right)
$$
{% endnote %}

以下证明过程摘自 <a href="https://proofwiki.org/wiki/Vandermonde_Determinant">Vandermonde Determinant</a>。

<p><strong>方法一</strong></p>

从 $V_n$ 第二行开始，以后每行减去第一行，由初等变换得到的行列式值不变：

\begin{align*}
V_n &= \begin{vmatrix}
  1 & x_1 & x_1^2 & \cdots & x_1^{n-2} & x_1^{n-1} \\
  1 & x_2 & x_2^2 & \cdots & x_2^{n-2} & x_2^{n-1} \\
  1 & x_3 & x_3^2 & \cdots & x_3^{n-2} & x_3^{n-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
  1 & x_{n-1} & x_{n-1}^2 & \cdots & x_{n-1}^{n-2} & x_{n-1}^{n-1} \\
  1 & x_n & x_n^2 & \cdots & x_n^{n-2} & x_n^{n-1}
\end{vmatrix} \\
&= \begin{vmatrix}
  1 & x_1 & x_1^2 & \cdots & x_1^{n-2} & x_1^{n-1} \\
  0 & x_2 - x_1 & x_2^2 - x_1^2 & \cdots & x_2^{n-2} - x_1^{n-2} & x_2^{n-1} - x_1^{n-1} \\
  0 & x_3 - x_1 & x_3^2 - x_1^2 & \cdots & x_3^{n-2} - x_1^{n-2} & x_3^{n-1} - x_1^{n-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
  0 & x_{n-1} - x_1 & x_{n-1}^2 - x_1^2 & \cdots & x_{n-1}^{n-2} - x_1^{n-2} & x_{n-1}^{n-1} - x_1^{n-1} \\
  0 & x_n - x_1 & x_n^2 - x_1^2 & \cdots & x_n^{n-2} - x_1^{n-2} & x_n^{n-1} - x_1^{n-1}
\end{vmatrix} \\
&= \begin{vmatrix}
  1 & 0 & 0 & \cdots & 0 & 0 \\
  0 & x_2 - x_1 & \left({x_2 - x_1}\right) x_2 & \cdots & \left({x_2 - x_1}\right) x_2^{n-3} & \left({x_2 - x_1}\right) x_2^{n-2} \\
  0 & x_3 - x_1 & \left({x_3 - x_1}\right) x_3 & \cdots & \left({x_3 - x_1}\right) x_3^{n-3} & \left({x_3 - x_1}\right) x_3^{n-2} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
  0 & x_{n-1} - x_1 & \left({x_{n-1} - x_1}\right) x_{n-1} & \cdots & \left({x_{n-1} - x_1}\right) x_{n-1}^{n-3} & \left({x_{n-1} - x_1}\right) x_{n-1}^{n-2} \\
  0 & x_n - x_1 & \left({x_n - x_1}\right) x_n & \cdots & \left({x_n - x_1}\right) x_n^{n-3} & \left({x_n - x_1}\right) x_n^{n-2}
\end{vmatrix} \\
&= \prod_{k \mathop = 2}^n \left({x_k - x_1}\right) \begin{vmatrix}
  1 & 0 & 0 & \cdots & 0 & 0 \\
  0 & 1 & x_2 & \cdots & x_2^{n-3} & x_2^{n-2} \\
  0 & 1 & x_3 & \cdots & x_3^{n-3} & x_3^{n-2} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
  0 & 1 & x_{n-1} & \cdots & x_{n-1}^{n-3} & x_{n-1}^{n-2} \\
  0 & 1 & x_n & \cdots & x_n^{n-3} & x_n^{n-2}
\end{vmatrix} \\
&= \prod_{k \mathop = 2}^n \left({x_k - x_1}\right) V_{n-1}
\end{align*}

以此类推，

$$
V_n = \prod_{k \mathop = 2}^n \left({x_k - x_1}\right)
    \prod_{k \mathop = 3}^n \left({x_k - x_2}\right) V_{n-2}
= \cdots
= \prod_{1 \mathop \leqslant i \mathop < j \mathop \leqslant n} \left({x_j - x_i}\right)
= \prod_{1 \mathop \leqslant i \mathop < j \mathop \leqslant n} \left({x_j - x_i}\right)
$$

<hr>

<p><strong>方法二</strong></p>

将行列式中 $V_n$ 中的所有 $x_n$ 替换为未知量 $x$，则 $V_n$ 可视为关于 $x$ 的 $n-1$ 次多项式，记为 $P(x)$，并按最后一行展开：

\begin{align*}
P \left({x}\right)
&= \begin{vmatrix}
  1 & x_1 & x_1^2 & \cdots & x_1^{n-2} & x_1^{n-1} \\
  1 & x_2 & x_2^2 & \cdots & x_2^{n-2} & x_2^{n-1} \\
  1 & x_3 & x_3^2 & \cdots & x_3^{n-2} & x_3^{n-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
  1 & x_{n-1} & x_{n-1}^2 & \cdots & x_{n-1}^{n-2} & x_{n-1}^{n-1} \\
  1 & x & x^2 & \cdots & x^{n-2} & x^{n-1}
\end{vmatrix} \\
&= \begin{vmatrix}
  x_1 & x_1^2 & \cdots & x_1^{n-2} & x_1^{n-1} \\
  x_2 & x_2^2 & \cdots & x_2^{n-2} & x_2^{n-1} \\
  x_3 & x_3^2 & \cdots & x_3^{n-2} & x_3^{n-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
  x_{n-1} & x_{n-1}^2 & \cdots & x_{n-1}^{n-2} & x_{n-1}^{n-1}
\end{vmatrix} \ \  + \ \ \begin{vmatrix}
  1 & x_1^2 & \cdots & x_1^{n-2} & x_1^{n-1} \\
  1 & x_2^2 & \cdots & x_2^{n-2} & x_2^{n-1} \\
  1 & x_3^2 & \cdots & x_3^{n-2} & x_3^{n-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
  1 & x_{n-1}^2 & \cdots & x_{n-1}^{n-2} & x_{n-1}^{n-1}
\end{vmatrix}x \\
& \mathrel{\phantom{=}}
+ \ \ \cdots \ \ + \ \
\begin{vmatrix}
  1 & x_1 & x_1^2 & \cdots & x_1^{n-2} \\
  1 & x_2 & x_2^2 & \cdots & x_2^{n-2} \\
  1 & x_3 & x_3^2 & \cdots & x_3^{n-2} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
  1 & x_{n-1} & x_{n-1}^2 & \cdots & x_{n-1}^{n-2}
\end{vmatrix}x^{n-1}
\end{align*}

显然 $P(x_1) = P(x_2) = \cdots = P(x_{n-1}) = 0$，由多项式分解定理可知

$$
    P(x) = V_{n-1} \prod_{i=1}^{n-1} (x-x_i)
$$

将 $x$ 替换成 $x_n$，由递推可得：

$$
    V_n = \prod_{1 \leqslant i < n} (x_n - x_i) V_{n-1}
        = \prod_{1 \leqslant i < n} (x_n - x_i)
          \prod_{1 \leqslant i < n-1} (x_{n-1} - x_i) V_{n-2}
        = \cdots
        = \prod_{1 \leqslant i < j \leqslant n} (x_j - x_i)
$$

<hr>

{% endfold %}

但是解这个线性方程组是很不明智的，如果数据点较近，$\boldsymbol{V}$ 会接近奇异矩阵。而拉格朗日插值法则不需要硬着头皮解方程。

## 拉格朗日插值

$n$ 次 Lagrange 插值多项式系数 $l_0(x), l_1(x), \ldots, l_n(x)$ 定义为
$l_i(x_j)= \begin{cases} 1, & i=j \\ 0, & i\neq j \\ \end{cases}$，则多项式可表示为

$$
    P(x) = y_0 l_0(x) + y_1l_1(x) + \cdots + y_nl_n(x) = \sum_{i=0}^n y_il_i(x)
$$

注意这里的每个 $l_i(x)$ 均为 $n$ 次多项式，且由定义可知 $l_i(x)$ 有 $n$ 个根

$$
    x_0, x_1, x_2, \ldots, x_{i-1}, x_{i+1}, \ldots, x_n
$$

所以 $l_i(x)$ 可表示成 $l_i(x) = C_i \prod\limits_{j\neq i} (x - x_j)$，进一步由 $l_i(x)$ 定义，

$$
    1 = l_i(x_i) = C_i \prod_{j\neq i} (x_i - x_j)
    \ \Rightarrow \ C_i = \frac{1}{\prod\limits_{j\neq i} (x_i - x_j)}
    \ \Rightarrow \ l_i(x) = \frac{\prod\limits_{j\neq i}(x - x_j)}
                                  {\prod\limits_{j\neq i}(x_i - x_j)}
$$

所以 Lagrange 插值多项式为

$$
    p(x) = \sum_{i=0}^n y_i \frac{\prod\limits_{j\neq i}(x - x_j)}
                             {\prod\limits_{j\neq i}(x_i - x_j)}
         = \sum_{i=0}^n y_i \frac{(x-x_0)(x-x_1)\cdots (x-x_{i-1})(x-x_{i+1})\cdots (x-x_n)}
                                 {(x_i-x_0)(x_i-x_1)\cdots (x_i-x_{i-1})(x_i-x_{i+1})\cdots (x_i-x_n)}
$$

从形式上看，Lagrange 插值法是容易实现的，但如果加入新的数据点，则需要重新计算多项式系数，即算法随着数据点的增多不能复用以前的计算结果。

{% fold "拉格朗日插值 Matlab 程序代码" %}
```matlab
function [f, f0] = interp_lagrange(x, y, x0, prec)
    if nargin <= 3, prec = 4;

    if length(x) == length(y), n = length(x) - 1;
    else error('Incompatible dimension of x and y !!');
    end

    syms t;
    f = 0;

    for k = 1:n
        xs = [x(1:k-1) x(k+1:n)];
        f = f + y(k) * prod((t-xs)./(x(k)-xs));
    end

    f = vpa(f, prec);
    if nargin > 2, f0 = vpa(subs(f, t, x0), prec); end;
end
```
{% endfold %}


## 艾特肯插值

首先，由点 $(x_0, y_0)$ 到 $(x_j, y_j), j=1,2,\ldots,n$ 可以确定 $n$ 组一次多项式，即穿过两点的直线；第二步，根据 $$，进一步生成 $n-1$ 组二次多项式。次过程共重复 $n$ 次，最终得到一个 $n$ 次多项式。

具体而言，由点 $(x_0, y_0)$ 及 $(x_1, y_1)$ 得到的一次多项式为

$$
    p_{01}(x) = \frac{x-x_1}{x_0-x_1}y_0 - \frac{x-x_0}{x_1-x_0}y_1
              = \frac{1}{x_1-x_0} \begin{vmatrix}
                  y_0 & x_0 - x \\
                  y_1 & x_1 - x
                \end{vmatrix}
$$

类比之，由 $x_0$ 及 $x_j$ 确定的一次多项式表示为

$$
    p_{0j}(x) = \frac{1}{x_j-x_0} \begin{vmatrix}
                    y_0 & x_0 - x \\
                    y_j & x_j - x
                \end{vmatrix}, \quad j = 1,2,\ldots,n
$$

进一步，由点 $(x_0, y_0), (x_1, y_1), (x_j, y_j)$ 确定的二次多项式为

$$
    p_{01j}(x) = \frac{1}{x_j - x_1} \begin{vmatrix}
                     p_{01}(x) & x_1 - x \\
                     p_{0j}(x) & x_j - x
                 \end{vmatrix}, \quad j=2,3,\ldots,n
$$

一般而言，对于 $k+2$ 个数据点 $(x_0, y_0), (x_1, y_1), \ldots, (x_k, y_k)$ 及 $(x_j, y_j)$，$k+1$ 次插值多项式为

$$
    p_{012\cdots kj}(x) = \frac{1}{x_j - x_k}
        \begin{vmatrix}
            p_{012\cdots k}(x) & x_k - x \\
            p_{012\cdots (k-1)}(x) & x_j - x
        \end{vmatrix} \quad j=k+1,\ldots, n
$$

整个计算过程如下表

$$
\begin{array}{cccccc|c}
    \hline
    x_j &   y_j &   p_{0j}  &   p_{01j} &   p_{012j}    &   p_{0123j}   &   x_j-x \\
    \hline
    x_0 &   y_0 &           &           &               &               &   x_0-x \\
    x_1 &   y_1 &   p_{01}  &           &               &               &   x_1-x \\
    x_2 &   y_2 &   p_{02}  &   p_{012} &               &               &   x_2-x \\
    x_3 &   y_3 &   p_{03}  &   p_{013} &   p_{0123}    &               &   x_3-x \\
    x_4 &   y_4 &   p_{04}  &   p_{014} &   p_{0124}    &   p_{01234}   &   x_4-x \\
    \cdots      &   \cdots  &   \cdots  &   \cdots      &   \cdots      &   \cdots  &   \cdots \\
    x_n &   y_n &   p_{0n}  &   p_{01n} &   p_{012n}    &   p_{0123n}   &   x_n-x \\
    \hline
\end{array}
$$

{% fold "艾特肯插值 Matlab 程序代码" %}
```matlab
function [f, f0] = interp_aitken(x, y, x0, prec)
    if nargin <= 3, prec = 4;
    if length(x) == length(y), n = length(x) - 1;
    else error('Incompatible dimension of x and y !!');
    end

    syms t;
    f = 0;
    lastp = y;
    xs = x - t;

    for k = 1:n
        for j = k+1:n+1
            curp(j) = (lastp(k)*xs(j) - lastp(j)*xs(k)) / (xs(j)-xs(k));
        end
        lastp = curp;
    end

    f = vpa(simplify(lastp(end)), prec);
    if nargin > 2, f0 = vpa(subs(f, t, x0), prec); end;
end
```
{% endfold %}

