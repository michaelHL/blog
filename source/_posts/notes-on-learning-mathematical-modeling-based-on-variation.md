---
title: 数学建模笔记 —— 对变化进行建模
date: 2018-07-03 21:09:16
tags:
    - Difference
    - Matlab
categories: Mathematical Modeling
mathjax: true
---

## 离散流行病模型

考虑这样一个社区，有三类人群：易感者、已感者和移出者。我们对流行病模型作出如下假设：

- 没有人进出该社区，且社区不和外界接触，即社区内的总人数保持不变
- 每个人都是易感者 $S$、已感者 $I$、移出者 $R$。也就是说每个人都能感染这种流感，当前已经染上这种流感的人能够传播流感，已经得过这种流感的人不会再得此病
- 一开始，每人要么是已感者，要么是易感者
- 这种流感的平均持续时间为 $1/c$ 周，在此期间此人被认为是已感者且能传播流感
- 模型时间周期按周计

<!-- more -->

用差分方程描述这个动力系统模型，首先假设定义如下：

- $S(n)$：$n$ 个周期后易感者人数
- $I(n)$：$n$ 个周期后已感者人数
- $R(n)$：$n$ 个周期后移出者人数

从模型假设出发，既然流感平均持续 $1/c$ 周，也就是说每 $1/c$ 周的时间就有 $1$ 人成为移出者，从该系统移出。因计量周期为周，所以也可理解成每周移出 $c \times 100 \%$ 的已感者。所以建立关于移出者的方程

$$
    R(n+1) = R(n) + c I(n)
    \tag{R}
    \label{R}
$$

对于已感者人数 $I(n)$ 的变化，显然来自两个方面：其一来自新的一批被传染的易感者，其二由前所述，每周都会从系统移出已感者。细化这个过程，易感者由于接触已感者而患病，若引入**传播系数** $a$，则新的一批被感染得病的人数为 $a S(n) I(n)$，二者乘积的形式表明了其之间的相互作用。得到已感者差分方程

$$
    I(n+1) = I(n) - c I(n) + a S(n) I(n)
    \tag{I}
    \label{I}
$$

最后关于易感者的关系就很容易了，由于系统人数保持不变，已感者被移出后不会再患病，即不会转化为易感者；移出者的变化仅来源于已感者，故和易感者无直接联系。所以仅建立易感者与已感者之间的关系即可。

$$
    S(n+1) = S(n) - a S(n) I(n)
    \tag{S}
    \label{S}
$$

给定初始条件，假设社区共有 $1000$ 人，移出率 $c=0.60$，一开始（第 $0$ 周）便有 $5$ 人患病，第 $1$ 周有 $9$ 人患病，即 $I(0) = 5$，$S(0) = 995$，$R(0) = 0$，$I(1) = 9$，由式 $\eqref{I}$ 即可解得 $a \approx 0.001407$。
故由以上方程组及初值构成的动力系统（SIR 模型）可进行迭代求解，并通过图形观察趋势。Matlab 代码如下：

```matlab epidemic_model.m
N = 1000;
I0 = 5;
I1 = 9;
shiftout = 0.6;
iters = 25;
res = epidemic(N, I0, I1, shiftout, iters);

tbl = cell2table(num2cell(res), 'VariableNames', {'Rn', 'In', 'Sn'});
writetable(tbl, 'epidemic.csv');

p = plot(0:iters-1, res, 'LineWidth', 1.1, 'MarkerSize', 4.5);
p(1).Marker = '*';
p(2).Marker = 'x';
p(3).Marker = '^';

set(gca, ...
    'FontName', 'Euclid', ...
    'FontWeight', 'Bold', ...
    'FontSize', 9, ...
    'box', 'off', ...
    'color', 'none');
title('\bf Dynamic System of SIR Model', ...
      'FontSize', 11, ...
      'Interpreter', 'latex');
legend(gca, ...
       {'$R(n)$', '$I(n)$', '$S(n)$'}, ...
       'FontSize', 8, ...
       'Interpreter', 'latex', 'Location', 'best');
set(gcf, ...
    'units', 'points', ...
    'position', [350, 200, 320, 180]);
saveas(gcf, 'epidemic.svg');

function res = epidemic(N, I0, I1, shiftout, iters)
    % 返回由 R(n), I(n), S(n) 构成的数组

    res = zeros(iters, 3);
    a = (I1 - (1-shiftout) * I0) / (I0 * (N - I0));
    res(1, :) = [0 I0 N-I0];
    for k = 2:iters
        res(k, 1) = res(k-1, 1) + shiftout * res(k-1, 2);
        res(k, 2) = (1-shiftout) * res(k-1, 2) + a * res(k-1, 2) * res(k-1, 3);
        res(k, 3) = res(k-1, 3) - a * res(k-1, 2) * res(k-1, 3);
    end
end
```

生成的 $R(n), I(n), S(n)$ 表格如下：

\begin{array}{cccc|cccc}
    \hline
    \text{week} & R(n)       & I(n)       & S(n)       & \text{week} & R(n)       & I(n)      & S(n)  \\
    \hline
    {0}  & {0}        & {5}        & {995}      & {12} & {812.3671} & {78.9598} & {108.6731}  \\
    {1}  & {3}        & {9}        & {988}      & {13} & {859.7430} & {43.6574} & {96.5996} \\
    {2}  & {8.4000}   & {16.1114}  & {975.4886} & {14} & {885.9374} & {23.3968} & {90.6657} \\
    {3}  & {18.0668}  & {28.5581}  & {953.3751} & {15} & {899.9755} & {12.3435} & {87.6810} \\
    {4}  & {35.2017}  & {49.7321}  & {915.0662} & {16} & {907.3816} & {6.4602}  & {86.1582} \\
    {5}  & {65.0409}  & {83.9244}  & {851.0347} & {17} & {911.2577} & {3.3672}  & {85.3750} \\
    {6}  & {115.3955} & {134.0638} & {750.5407} & {18} & {913.2781} & {1.7514}  & {84.9705} \\
    {7}  & {195.8338} & {195.2018} & {608.9644} & {19} & {914.3289} & {0.9099}  & {84.7612} \\
    {8}  & {312.9549} & {245.3364} & {441.7087} & {20} & {914.8749} & {0.4725}  & {84.6526} \\
    {9}  & {460.1567} & {250.6110} & {289.2323} & {21} & {915.1584} & {0.2453}  & {84.5964} \\
    {10} & {610.5233} & {202.2331} & {187.2436} & {22} & {915.3055} & {0.1273}  & {84.5672} \\
    {11} & {731.8632} & {134.1732} & {133.9636} & {23} & {915.3819} & {0.0661}  & {84.5520} \\
    \hline
\end{array}

SIR 模型动力系统曲线如下：

<img src="/img/epidemic.svg" width="50%">

> 注：尽管设置了 `set(gca, 'color', 'none')`，但 Matlab (R2016b) 导出的 SVG 格式图形仍然会有背景色，且图形标题位置不易调整。故干脆用 [Inkscape][ink] 对图形进行细加工。

从图形可以看出，给定移出率（$60\%$）以及模型初值下，这种流感流行的高峰处于第 $9$ 周左右，已感人数为 $250.6$，在第 $17$ 周后略小于 $85$ 人未染上这种流感。

### 敏感性分析

下面考察模型对于参数及初始条件的敏感性。分别基于以下初值条件进行实验：

\begin{array}{c|cccc}
      & N    & c   & I(0) & I(1)  \\
    \hline
    \text{I}   & 1000 & 3/5 & 5 & 15   \\
    \text{II}  & 1000 & 1   & 5 & 15  \\
    \text{III} & 1000 & 1/4 & 5 & 15  \\
    \text{IV}  & 4000 & 1/4 & 5 & 35
\end{array}

实验过程中发现会某些时间周期会出现人数为负或者超过总社区人数的情况，故在函数 `epidemic` 中对其加以限定，使其在正常范围内变化。注意这里不能简单地处理为 $\max\{\min\{x, N\}, 0\}$，否则可能导致三者加和不为 $N$ 的情况出现。

```matlab
res(k, 1) = min(res(k-1, 1) + shiftout * res(k-1, 2), N);
res(k, 3) = max(min(res(k-1, 3) - a * res(k-1, 2) * res(k-1, 3), N), 0);
res(k, 2) = max(min((1-shiftout) * res(k-1, 2) + ...
                    a * res(k-1, 2) * res(k-1, 3), ...
                    N - res(k, 1) - res(k, 2)), 0);
```

对比结果如下：

<img src="/img/epidemic-2x2.svg" width="80%">

四种情形最终的收敛情况相同，即易感者逐渐降至为 $0$，即全军覆没无一幸免；已感者呈现先增后降的趋势；移出者逐渐累积，直至流行病完全治愈。具体来看，移出率越高，说明该流行病越容易被治愈，所以感染人数峰值越低，流行病退潮时间越早；$I(1) - I(0)$ 越大，即传播系数越高，流感传播速度更快，短时期内感染人数上升速率更大，退潮时间也越长。

考察社区总人数是否对模型敏感性有影响，针对 $c=1$, $I(0)=5$, $I(1)=10$, $N=500$, $1000$, $5000$, $10000$ 四种情况作出变化曲线：

<img src="/img/epidemic-2x2-by-n.svg" width="80%">

显然，在其他因素相同的情况下，随社区总人数增加，SIR 模型曲线整体“向右移动”，也就是说感染人数到达峰值所需时间增长，且相应的退潮时间也越长。由于当 $I(1) - I(0)$ 不变的情况下，随总人数增加，可以看成传播系数 $a$ 降低，所以整个模型的变化会放缓。


[ink]: https://inkscape.org