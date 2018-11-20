---
title: 《统计学习方法》笔记一
date: 2018-06-29 11:58:58
categories: Machine Learning
tags:
    - Python
    - Statistics
    - Matrix
    - Linear Algebra
mathjax: true
---

李航《统计学习方法》一书第 12 页关于简单的多项式曲线拟合有如下结论：

{% note %}
具体地，求以下经验风险最小化：
$$
L(\omega) = \frac 12 \sum_{i=1}^N \left(f(x_i, \omega) - y_i\right)^2
\tag{1.18} \label{1.18}
$$
... <br>
这是一个简单的最优化问题。将模型与训练数据代入式 $\eqref{1.18}$ 中，有
$$
L(\omega) = \frac 12 \sum_{i=1}^N \left(\sum_{j=0}^M \omega_j x_i^j-y_i\right)^2
$$
对 $\omega_j$ 求偏导数并令其为 $0$，可得
$$
\omega_j = \frac{\sum\limits_{i=1}^N x_i^j y_i}{\sum\limits_{i=1}^N x_i^{j+1}}, \quad j = 0,1,2,\ldots M
\tag{*} \label{*}
$$
{% endnote %}

<!-- more -->

但通过简单求导，似乎事实并不那么简单。这里为计算 $\partial L/\partial \omega_j$，将原求和式下标换作 $k$，以免混淆出错。

$$
    \frac{\partial L}{\partial \omega_j}
    = \sum_{i=1}^N \left(\sum_{j=0}^M \omega_j x_i^j - y_i\right) x_i^j
    = \sum_{k=0}^M \left(\sum_{i=1}^N x_i^{k+j}\right)\omega_k
      - \sum_{i=1}^N y_i x_i^j
    \tag{1}
    \label{1}
$$

故对于 $j = 0, 1, 2\ldots M$，令 $\partial L/\partial \omega_j = 0$，可得如下 $M$ 元方程组：

$$
    \begin{cases}
        \omega_0 \sum\limits_{i=1}^N x_i^0 +
        \omega_1 \sum\limits_{i=1}^N x_i^1 + \cdots +
        \omega_M \sum\limits_{i=1}^N x_i^M = \sum\limits_{i=1}^N y_i & \\
        \omega_0 \sum\limits_{i=1}^N x_i^1 +
        \omega_1 \sum\limits_{i=1}^N x_i^2 + \cdots +
        \omega_M \sum\limits_{i=1}^N x_i^{M+1} = \sum\limits_{i=1}^N x_i y_i & \\
        \hfil   \vdots  \hfil & \\
        \omega_0 \sum\limits_{i=1}^N x_i^M +
        \omega_1 \sum\limits_{i=1}^N x_i^{M+1} + \cdots +
        \omega_M \sum\limits_{i=1}^N x_i^{2M} = \sum\limits_{i=1}^N x_i^M y_i &
    \end{cases}
$$

写为矩阵形式：

$$
    \underbrace{
    \begin{pmatrix}
        \sum\limits_{i=1}^N x_i^0 & \cdots & \sum\limits_{i=1}^N x_i^1 & \sum\limits_{i=1}^N x_i^M \\
        \sum\limits_{i=1}^N x_i^1 & \cdots & \sum\limits_{i=1}^N x_i^2 & \sum\limits_{i=1}^N x_i^{M+1} \\
        \vdots & \vdots & \ddots & \vdots \\
        \sum\limits_{i=1}^N x_i^M & \cdots & \sum\limits_{i=1}^N x_i^{M+1} & \sum\limits_{i=1}^N x_i^{2M}
    \end{pmatrix}
    }_{\boldsymbol{A}}
    \underbrace{
    \begin{pmatrix}
        \omega_0 \vphantom{\sum\limits_{i=1}^{N}x_i^{M+1}} \\
        \omega_1 \vphantom{\sum\limits_{i=1}^{N}x_i^{M+1}} \\
        \vdots \vphantom{\ddots}\\
        \omega_M \vphantom{\sum\limits_{i=1}^{N}x_i^{M+1}}
    \end{pmatrix}
    }_{\boldsymbol{\omega}}
    =
    \underbrace{
    \begin{pmatrix}
        \sum\limits_{i=1}^N y_i \vphantom{\sum\limits_{i=1}^{N}x_i^{M+1}}\\
        \sum\limits_{i=1}^N x_i y_i \vphantom{\sum\limits_{i=1}^{N}x_i^{M+1}}\\
        \vdots \vphantom{\ddots}\\
        \sum\limits_{i=1}^N x_i^M y_i \vphantom{\sum\limits_{i=1}^{N}x_i^{M+1}}\\
    \end{pmatrix}
    }_{\boldsymbol{B}}
$$

注意到 $\boldsymbol{A}, \boldsymbol{B}$ 均可写为两个矩阵相乘的形式：

$$
    \boldsymbol{A}=
    \begin{pmatrix}
        1 & 1 & 1 & \cdots & 1 \vphantom{x_1^M} \\
        x_1 & x_2 & x_3 & \cdots & x_M \vphantom{x_2^M} \\
        x_1^2 & x_2^2 & x_3^2 & \cdots & x_M^2 \vphantom{x_3^M} \\
        \vdots & \vdots & \vdots & \ddots & \vdots \\
        x_1^M & x_2^M & x_3^M & \cdots & x_M^M \vphantom{x_M^M}
    \end{pmatrix}
    \begin{pmatrix}
        1 & x_1 & x_1^2 & \cdots & x_1^M \\
        1 & x_2 & x_2^2 & \cdots & x_2^M \\
        1 & x_3 & x_3^2 & \cdots & x_3^M \\
        \vdots & \vdots & \vdots & \ddots & \vdots \\
        1 & x_M & x_M^2 & \cdots & x_M^M \\
    \end{pmatrix}
    \triangleq \boldsymbol{V} \boldsymbol{V}', \quad
    \boldsymbol{B} = \boldsymbol{V} \boldsymbol{Y}
$$
其中 $\boldsymbol{Y}$ 为输出向量。于是多项式参数矩阵应由下式给出：

$$
    \boldsymbol{\omega} =
    (\boldsymbol{V}\boldsymbol{V'})^{-1}\boldsymbol{V}\boldsymbol{Y}
    \tag{**}
    \label{**}
$$

该式与 $\eqref{*}$ 有一定出入，且不易进一步化简，其中涉及 Vandermonde 矩阵逆，可参考

- [Proof Wiki - Inverse of Vandermonde Matrix][inverse-of-vandermonde-matrix]
- [Proof of Vandermonde Matrix Inverse Formula][mse-698254]
- [Inverse of the Vandermonde and Vandermonde confluent matrices][inverse-of-the-vandermonde-and-vandermonde-confluent-matrices]

于是针对原书中结论 $\eqref{*}$ 以及逐步推导的结果 $\eqref{**}$ 进行数值试验。
给定 $\boldsymbol{X}, \boldsymbol{Y}$，分别利用两种方法得到 $\boldsymbol{\omega}$ 的结果，并代回
$\eqref{1}$ 中，这里利用 Python 的科学计算包进行试验。

{% codeblock lang:python polyfit.py %}
import numpy as np
import numpy.random as nr

np.set_printoptions(precision=4, suppress=True)


def equj(xs, ys, omegas, j):
    n = len(xs)
    m = len(omegas)
    return np.sum([np.sum(omegas[k] * xs[i-1] ** (k+j) for k in range(m))
                   - xs[i-1] ** j * ys[i-1] for i in range(1, n+1)])


def omegaj1(xs, ys, j):
    # 方法一
    return np.sum(xs ** j * ys) / np.sum(xs ** (j+1))


def omegaj2(xs, ys, m):
    # 方法二
    v = np.matrix(np.column_stack([xs ** i for i in range(m)]).T)
    y = np.matrix(v) * np.matrix(ys).T
    return np.linalg.solve(v * v.T, y)


ns = [4, 4, 6, 8, 10, 10, 10]
ms = [3, 4, 5, 7, 6, 7, 8]

for n0, m0 in zip(ns, ms):
    xs0 = np.linspace(.1, 1, n0)
    ys0 = nr.uniform(1, 10, size=n0)
    omegas_sol1 = [omegaj1(xs0, ys0, j) for j in range(m0+1)]
    omegas_sol2 = omegaj2(xs0, ys0, m0)
    res1 = np.array([equj(xs0, ys0, omegas_sol1, j) for j in range(m0+1)])
    res2 = np.array([equj(xs0, ys0, omegas_sol2, j) for j in range(m0+1)])

    print(f'x: {xs0}')
    print(f'y: {ys0}')
    print(f'N: {n0}, M: {m0}')
    print('res1:', res1)
    print('res2:', res2)
    print()
{% endcodeblock %}

结论整合如下：

$$
\begin{array}{c|l}
    \hline
    {(N, M)} & {(4, 3)} \\
    {\boldsymbol{X}} & {\begin{array}{llll} {0.1} & {0.4} & {0.7} & {1.0} \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{llll} {6.4086} & {2.5888} & {1.1871} & {3.0044} \end{array}} \\
    {\text{res}_1} & {\begin{array}{llll} {26.8738} & {20.8370}  & {17.5522} & {15.6374} \end{array}} \\
    {\text{res}_2} & {\begin{array}{llll} 0  &  0  &  0  &  {-0.0065} \end{array}} \\
    \hline
    {(N, M)} & {(4, 4)} \\
    {\boldsymbol{X}} & {\begin{array}{llll} 0.1 & 0.4 & 0.7 & 1.0 \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{llll} {6.0025} & {7.9131} & {4.7549} & {4.6187} \end{array}} \\
    {\text{res}_1} & {\begin{array}{lllll} {58.2611} & {44.2894} & {38.6435} & {35.4777} & {33.4895} \end{array}} \\
    {\text{res}_2} & {\begin{array}{lllll} 0  &  0  &  0  &  0 & 0 \end{array}} \\
    \hline
    {(N, M)} & {(6, 5)} \\
    {\boldsymbol{X}} & {\begin{array}{llllll} {0.10} & {0.28} & {0.46} & {0.64} & {0.82} & {1.00} \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{llllll} {4.0511} & {7.6577} & {2.0744} & {4.0110}  & {3.2187} & {7.4847} \end{array}} \\
    {\text{res}_1} & {\begin{array}{llllll} {94.1633} & {70.4719} & {59.2198} & {52.4345} & {47.9117} & {44.7218} \end{array}} \\
    {\text{res}_2} & {\begin{array}{llllll} 0  &  0  &  0  &  0 & 0 & {-0.0040}\end{array}} \\
    \hline
    {(N, M)} & {(8, 7)} \\
    {\boldsymbol{X}} & {\begin{array}{llllllll} {0.1000} & {0.2286} & {0.3571} & {0.4857} & {0.6143} & {0.7429} & {0.8714} & {1.0000} \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{llllllll} {7.5006} & {8.4878} & {6.9965} & {8.8697} & {3.8661} & {3.0010}  & {6.0474} & {9.7587} \end{array}} \\
    {\text{res}_1} & {\begin{array}{llll} {193.4017} & {148.1521} & {125.1272} & {110.7083} \\ {100.7469} &  {93.4678} &  {87.9480}  &  {83.6494} \end{array}} \\
    {\text{res}_2} & {\begin{array}{llllllll} 0  &  0  &  0  &  0 & 0 & 0 & 0 & {-0.0001} \end{array}} \\
    \hline
    {(N, M)} & {(10, 6)} \\
    {\boldsymbol{X}} & {\begin{array}{llllllllll} {0.1} & {0.2} & {0.3} & {0.4} & {0.5} & {0.6} & {0.7} & {0.8} & {0.9} & {1.0} \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{lllll} {8.4519} & {2.8615} & {8.2275} & {5.5887} & {6.4139} \\ {4.8329} & {2.3945} & {9.5324} & {1.5159} & {4.8203} \end{array}} \\
    {\text{res}_1} & {\begin{array}{lllllll} {158.5266} & {117.4165}  & {96.8007} &  {84.1716} &  {75.5419} &  {69.2490}  &  {64.4573} \end{array}} \\
    {\text{res}_2} & {\begin{array}{llllllllll} 0  &  0  &  0  &  0 & 0 & 0 & 0 & {-0.0001} \end{array}} \\
    \hline
    {(N, M)} & {(10, 7)} \\
    {\boldsymbol{X}} & {\begin{array}{llllllllll} {0.1} & {0.2} & {0.3} & {0.4} & {0.5} & {0.6} & {0.7} & {0.8} & {0.9} & {1.0} \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{lllll} {2.9699} & {8.8436} & {6.0365} & {8.7695} & {4.6556} \\ {8.6279} & {1.5868} & {7.5356} & {2.1053} & {5.5741} \end{array}} \\
    {\text{res}_1} & {\begin{array}{llll} {176.0512} & {131.4928} & {109.7501} &  {96.1845} \\ {86.7478} & {79.7768} & {74.4193} & {70.1824} \end{array}} \\
    {\text{res}_2} & {\begin{array}{llllllllll} 0  &  0  &  0  &  0 & 0 & 0 & 0 & {-0.0001} \end{array}} \\
    \hline
    {(N, M)} & {(10, 8)} \\
    {\boldsymbol{X}} & {\begin{array}{llllllllll} {0.1} & {0.2} & {0.3} & {0.4} & {0.5} & {0.6} & {0.7} & {0.8} & {0.9} & {1.0} \end{array}} \\
    {\boldsymbol{Y}} & {\begin{array}{lllll} {1.9506} & {5.4975} & {7.7366} & {3.4942} & {4.6710} \\ {9.2793} & {9.7969} & {2.0273} & {3.1859} & {3.0251} \end{array}} \\
    {\text{res}_1} & {\begin{array}{lllll} {158.7535} & {117.7695} &  {98.8822} &  {87.3893} &  {79.4357} \\ {73.5334} & {68.9573} & {65.3023} & {62.3207} & \end{array}} \\
    {\text{res}_2} & {\begin{array}{llllllll} 0  &  0  &  0  &  0 & 0 & 0 & 0 & 0 \end{array}} \\
    \hline
\end{array}
$$

方法一得出的 $\boldsymbol{\omega}$ 代回方程的结果不为零，说明原书结论有误。


[mse-698254]: https://math.stackexchange.com/questions/698254/proof-of-vandermonde-matrix-inverse-formula
[inverse-of-vandermonde-matrix]: https://proofwiki.org/wiki/Inverse_of_Vandermonde_Matrix
[inverse-of-the-vandermonde-and-vandermonde-confluent-matrices]: http://naturalspublishing.com/files/published/18raq6j7bs84z4.pdf

