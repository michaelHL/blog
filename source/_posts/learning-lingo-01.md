---
title: Lingo 学习（一）
date: 2018-07-14 16:15:51
tags:
    - Lingo
    - Programming
    - Linear Algebra
categories: Mathematical Modeling
mathjax: true
---

## 环境搭建

- Lingo 17.0 (Windows 10 x64)
- Notepad++ 7.4.2 x86
  - NppExec
  - Visimulator
  - [语法高亮及代码补全][lingo-notepad++]

<!-- more -->

## Lingo 界面速览

### 文件类型

| 扩展名 | 文件类型                                | 扩展名 | 文件类型           |
| :--:   | :---                                    | :--:   | :---               |
| .lg4 | Windows 下模型文件，支持字体、格式、OLE | .lng | 纯文本格式模型文件 |
| .ldt | 数据文件                                | .ltf | 命令脚本文件       |
| .ltx | Lindo 语法的模型文件                    | .lgr | 报告文件           |

### Lingo 菜单

| 中文             | 英文     | 中文         | 英文             |
| :--:             | :--:     | :--:         | :--:             |
| 求解结果         | Solution | 灵敏性分析   | Range            |
| 生成模型展开形式 | Generate | 生成图形     | Picture          |
| 调试             | Debug    | 模型统计资料 | Model Statistics |
| 查看             | Look     |              |                  |

### 求解器状态窗口信息

- 变量数量 (Variables)
- 约束变量 (Constraints)
- 非零系数数量 (Nonzeroes)
- 内存使用量 (Generator Memory Used)
- 已运行时间 (Elapsed Runtime)
- 求解器状态 (Solver Status)
  - 模型类型 (Model Class)：线性规划 (LP)、二次规划 (QP)、整数线性规划 (ILP)、整数二次规划 (IQP)、纯整数线性规划 (PILP)、纯整数二次规划 (PIQP)、非线性规划 (NLP)、混合整数规划 (MIP)、整数非线性工 (INLP)、纯整数非线性规划 (PINLP)、混合整数非线性规划 (MINLP)
  - 当前解的状态 (State)：全局最优解 (Global Optimum)、局部最优解 (Local Optimum)、可行解 (Feasible)、不可行解 (Infeasible)、无界 (Unbounded)、中断 (Interrupted)、未确定 (Undetermined)
  - 当前解的目标函数值 (Objective)
  - 当前约束不满足的总量 (Infeasibility)
  - 迭代次数 (Iterations)
  - 扩展求解器状态 (Extended Solver Status)：特殊算法类型 (Solver Type)、可行解的最佳目标函数值 (Best Obj)、目标函数值的界限 (Obj Bound)、特殊求解程序运行步数 (Steps)、有效步数 (Active)

## Lingo 语言速览

### 逻辑运算符

| 运算符  | 作用                     | 运算符  | 作用                       | 运算符 | 作用                       |
| :--:    | :--                      | :--:    | :--                        | :--:   | :--                        |
| #EQ#  | 两操作数相等时为真       | #NE#  | 两操作数不等时为真         | #GT# | 左边（严格）大于右边时为真 |
| #GE#  | 左边大于或等于右边时为真 | #LT#  | 左边（严格）小于右边时为真 | #LE# | 左边小于或等于右边时为真   |
| #NOT# | 取反                     | #AND# | 逻辑与                     | #OR# | 逻辑或                     |

注：#AND# 和 #OR# 优先级较低，但高于 <=、=、>=。

### 数学函数

| 函数名 | 解释 | 函数名 | 解释 | 函数名 | 解释 |
| :-- | :-- | :-- | :-- | :-- | :-- |
| @abs(x) | 绝对值 | @acos(x) | 反余弦 | @acosh(x) | 反双曲余弦 |
| @asin(x) | 反正弦 | @asinh(x) | 反双曲正弦 | @atan(x) | 反正切 |
| @atan2(x, y) | $\arctan (y/x)$ | @atanh(x) | 反双曲正切 | @cos(x) | 余弦 |
| @cosh(x) | 双曲余弦 | @exp(x) | $e^x$ | @floor(x) | 向 0 取整 |
| @int(x) | 向负无穷取整 | @integral(proc, x, xl, xu, y) | 辛普森数值积分 | @lgm(x) | Gamma 函数自然对数 |
| @log(x) | 自然对数 | @log10(x) | 10 为底对数 | @logb(x, b) | b 为底对数 |
| @mod(x, y) | 取模 | @pi() | 圆周率 | @pow(x, y) | $x^y$ |
| @round(x, n) | 最近四舍五入 | @rounddown(x, n) | 向零四舍五入 | @roundup(x, n) | 远离零四舍五入 |
| @sign(x) | 符号函数 | @sin(x) | 正弦 | @sinh(x) | 双曲正弦 |
| @smax(x1, x2, ..., xn) | 最大值 | @smin(x1, x2, ..., xn) | 最小值 | @sqr(x) | 平方 |
| @sqrt(x) | 开方 | @tan(x) | 正切 | @tanh(x) | 双曲正切 |

### 概率函数

| 函数名                 | 解释                 | 函数名        | 解释                           | 函数名             | 解释                             |
| :--                    | :--                  | :--           | :--                            | :--                | :--                              |
| @norminv(p, mu, sigma) | 正态分布下分位数     | @normsinv(p)  | 标准正态分布分位数             | @pbn(p, n, x)      | 二项分布 CDF 值                  |
| @pcx(n, x)             | 卡方分布 CDF 值      | @peb(a, x)    | 允许无穷排队的 Erlang 繁忙概率 | @pel(a, x)         | 不允许无穷排队的 Erlang 繁忙概率 |
| @pfd(n, d, x)          | F 分布 CDF 值        | @pfs(a, x, c) | Poisson 服务系统期望值         | @phg(pop, g, n, x) | 超几何分布概率值                 |
| @ppl(a, x)             | 泊松分布线性损失函数 | @pps(a, x)    | 泊松分布 CDF 值                | @psl(x)            | 单位正态线性损失函数             |
| @psn(x)                | 标准正态分布 CDF 值  | @ptd(n, x)    | t 分布 CDF 值                  | @qrand(seed)       | (0, 1) 间随机数                  |

### 变量界定函数

| 函数名                 | 解释                | 函数名        | 解释               | 函数名                     | 解释             |
| :--                    | :--                 | :--           | :--                | :--                        | :--              |
| @bin(variable) | 限制变量取 0 或 1 | @bnd(lower, variable, upper) | 限制 $L\leqslant x \leqslant U$ | @free(variable) | 取消变量限制，可取任意实数 |
| @gin(variable) | 限制为整数 | @priority(variable, priority) | 设置优先级| @semic(lower, variable, upper) | 或者为 0，或者在区间 (lower, upper) |

### 集合操作函数

- @for(s: e)
- @max(s: e)
- @prod(s: e)
- @size(s)
- @insert(s, idx)
- @sum(s: e)
- @min(s: e)
- @in(s, e)
- @index(s: e)
- @wrap(idx, limit)



----------------------------------

## 一些经典问题

### 运输问题

假设 Wireless Widget有 6 个供货仓库，货物分别发往 8 个供销商。每个仓库有一定的库存量，现要制定出最小化运输成本，使得运输方案达到每个供销商需求的运输方案。

<!-- more -->

已知信息如下：

| 仓库 | 库存 | 供销商 | 需求 |
| :--: | :--: |  :--:  | :--: |
|   1  |  60  |   1    |  35  |
|   2  |  55  |   2    |  37  |
|   3  |  51  |   3    |  22  |
|   4  |  43  |   4    |  32  |
|   5  |  41  |   5    |  41  |
|   6  |  52  |   6    |  32  |
|      |      |   7    |  43  |
|      |      |   8    |  38  |

每个仓库（WH1 ~ WH6）到每个供销商的单位运费表如下：

|          | V1   | V2   | V3   | V4   | V5   | V6   | V7   | V8   |
| :--:     | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
| **WH1**  | 6    | 2    | 6    | 7    | 4    | 2    | 5    | 9    |
| **WH2**  | 4    | 9    | 5    | 3    | 8    | 5    | 8    | 2    |
| **WH3**  | 5    | 2    | 1    | 9    | 7    | 4    | 3    | 3    |
| **WH4**  | 7    | 6    | 7    | 3    | 9    | 2    | 7    | 1    |
| **WH5**  | 2    | 3    | 9    | 5    | 7    | 2    | 6    | 5    |
| **WH6**  | 5    | 5    | 2    | 2    | 8    | 1    | 4    | 3    |

对问题建模，记 $\text{volume}_{ij}$ 为第 $i$ 个仓库到第 $j$ 个供销商的货运量，$\text{cost}_{ij}$ 表示第 $i$ 个仓库到第 $j$ 个供销商的单位货物运价，$\text{capacity}_i$ 表示第 $i$ 个仓库的最大供货量，$\text{demand}_j$ 表示第 $j$ 个供销商的订货量。

目标函数是令总运输费用最少。约束条件：

- 各仓库的出货量不超过其库存
- 各供销商收到的货物总量等于订货数
- 决策变量 $\text{cost}_{ij}$ 非负。

数学表达为：

$$
\begin{array}{cl}
    \min & z = \sum\limits_{i=1}^6 \sum\limits_{j=1}^8 \text{cost}_{ij}\ \text{volume}_{ij} \\
    \text{s.t.} & \begin{cases}
        \sum\limits_{j=1}^8 \text{volume}_{ij} \leqslant \text{capacity}_i, & i = 1,2,\ldots,6 \\
        \sum\limits_{i=1}^6 \text{volume}_{ij} = \text{demand}_j, & j = 1,2,\ldots,8 \\
        \text{volume}_{ij} \geqslant 0, & i=1,2,\ldots,6, \ j=1,2,\ldots,8 \\
    \end{cases}
\end{array}
$$

相应的 Lingo 程序代码：

```matlab
model:
    sets:
        warehouses/wh1..wh6/:capacity;
        vendors/vd1..vd8/:demand;
        crosstab(warehouses, vendors): volume, cost;
    endsets

    data:
       capacity = 60 55 51 43 41 52;
       demand = 35 37 22 32 41 32 43 38;
       cost = 6 2 6 7 4 2 5 9
              4 9 5 3 8 5 8 2
              5 2 1 9 7 4 3 3
              7 6 7 3 9 2 7 1
              2 3 9 5 7 2 6 5
              5 5 2 2 8 1 4 3;
    enddata

    min = @sum(crosstab(i, j): volume(i, j) * cost(i, j));
    @for(warehouses(i):
        @sum(vendors(j): volume(i, j)) <= capacity(i));
    @for(vendors(j):
        @sum(warehouses(i): volume(i, j)) = demand(j));
end
```

其中 `SET` 过程大大简化了程序代码，也提升了程序的可读性，否则对于每个变量都需要进行硬编码。其语法 为 `<集合名称>[集合元素][:<集合属性>]`。当然 `SET` 中的前两个关于库存和供销商的描述可以拆分为

```matlab
sets:
    warehouses:capacity;
    vendors:demand;
    ...
endsets

data:
    warehouses = wh1..wh6;
    demand = vd1..vd8;
enddata
```

当然笔者更青睐紧凑的方式。`crosstab` 表示由 `warehouses` 和 `demand` 构成的派生集，即包含了 6 × 8 = 48 个变量。在目标函数及约束条件语句中，由于目标函数的操作数完全来自 `crosstab`，所以可省略部分语句：`min = @sum(crosstab: volume * cost);`。

程序经过 17 次迭代后得出的目标函数值为 664.0000，最优运输方案如下表。

|          | V1   | V2   | V3   | V4   | V5   | V6   | V7   | V8   | 合计 | 库存 |
| :--:     | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: |
| **WH1**  | 0    | 19   | 0    | 0    | 41   | 0    | 0    | 0    | 60   | 60   |
| **WH2**  | 1    | 0    | 0    | 32   | 0    | 0    | 0    | 0    | 33   | 55   |
| **WH3**  | 0    | 11   | 0    | 0    | 0    | 0    | 40   | 0    | 51   | 51   |
| **WH4**  | 0    | 0    | 0    | 0    | 0    | 5    | 0    | 38   | 43   | 43   |
| **WH5**  | 34   | 7    | 0    | 0    | 0    | 0    | 0    | 0    | 41   | 41   |
| **WH6**  | 0    | 0    | 22   | 0    | 0    | 27   | 3    | 0    | 52   | 52   |
| **合计** | 35   | 37   | 22   | 32   | 41   | 32   | 43   | 38   |      |      |
| **需求** | 35   | 37   | 22   | 32   | 41   | 32   | 43   | 38   |      |      |

-----------------------------------

### 值班问题

某项工作一周 7 天都需有人上班，周一至周日所需的最少人数分别为 20、16、13、16、19、14 和 12。要求员工一周连续工作 5 天接着休息 2 天。给出人员安排，使每周所需人数最少。

若安排得当，记周一至周日分别安排 $X(i)$ 人上班。那么周一上班的人必然周五、周六休息，以此类推。令总上班人数为 $Z$，那么上周周二、周三的人仍在休息中，所以有 $X(1) = Z-X(1)-X(2)$，同样可以得到其他 6 个等式。概括之就是
$$X(i) = Z-X(i+1)-X(i+2), \ i=1,2,\ldots, 7$$
当然，$X(8)$ 相当于 $X(1)$，$X(9)$ 相当于 $X(2)$。所以需要特殊的函数对其进行转化，`wrap` 函数正合此意。除了此函数，由此 [公式][essentials-of-matlab-examples] 也可。代码如下：

```matlab
model:
    sets:
        days/mon..sun/: r, x;
    endsets

    data:
        r = 20 16 13 16 19 14 12;
    enddata

    min = z;
    z = @sum(days: x);
    n = @size(days);
    @for(days(i): z-x(@wrap(i+1,n))-x(@wrap(i+2,n)) >= r(i));
    ! @for(days(i): z-x(1+@mod(i,n))-x(1+@mod(i+1,n)) >= r(i));
end
```

程序得出的最优解为：8、2、0、6、3、3、0。这说明每周最少需要 22 名员工，周一安排 8 人开始上班，或者说这 8 人休周六和周日，周一工作，其余类推。周二安排 2 人，等等。待轮休稳定后即可满足每天所需要的最少上班员工数。

----------------------------------

### 投资的收益和风险

市场上有 $n$ 种资产 $S_i (i=1,2,\ldots,n)$ 供投资者选择，某公司有数额为 $M$ 的一笔资金用于一个时期的投资。公司财务分析人员对这 $n$ 种资产进行了评估，估算出在这一时期内购买 $S_i$ 的平均收益率为 $r_i$，并预测出购买 $S_i$ 的风险损失率为 $q_i$。考虑到投资越分散，总的风险越小，公司决定当用这笔资金购买若干种资产时，总体风险可用所投资的 $S_i$ 中最大的一个风险来度量。购买 $S_i$ 要付交易费，费率为 $p_i$，并且当购买额不超过给定值 $u_i$ 时，交易费按购买 $u_i$ 计算（不买当然无须付费）。另外，假定同期银行存款利率是 $r_0$, 且既无交易费又无风险（$r_0=5\%$）。

{% fold 数据表 %}
<table>
  <tr>
    <th style="text-align: center;">$E_i$</th>
    <th style="text-align: center;">$r_i$(%)</th>
    <th style="text-align: center;">$q_i$(%)</th>
    <th style="text-align: center;">$p_i$(%)</th>
    <th style="text-align: center;">$u_i$(元)</th>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S1</strong></td>
    <td style="text-align: center;">9.6</td>
    <td style="text-align: center;">42.0</td>
    <td style="text-align: center;">2.1</td>
    <td style="text-align: center;">181</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S2</strong></td>
    <td style="text-align: center;">18.5</td>
    <td style="text-align: center;">54.0</td>
    <td style="text-align: center;">3.2</td>
    <td style="text-align: center;">407</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S3</strong></td>
    <td style="text-align: center;">49.4</td>
    <td style="text-align: center;">60.0</td>
    <td style="text-align: center;">6.0</td>
    <td style="text-align: center;">428</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S4</strong></td>
    <td style="text-align: center;">23.9</td>
    <td style="text-align: center;">42.0</td>
    <td style="text-align: center;">1.5</td>
    <td style="text-align: center;">549</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S5</strong></td>
    <td style="text-align: center;">8.1</td>
    <td style="text-align: center;">1.2</td>
    <td style="text-align: center;">7.6</td>
    <td style="text-align: center;">270</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S6</strong></td>
    <td style="text-align: center;">14.0</td>
    <td style="text-align: center;">39.0</td>
    <td style="text-align: center;">3.4</td>
    <td style="text-align: center;">397</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S7</strong></td>
    <td style="text-align: center;">40.7</td>
    <td style="text-align: center;">68.0</td>
    <td style="text-align: center;">5.6</td>
    <td style="text-align: center;">178</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S8</strong></td>
    <td style="text-align: center;">31.2</td>
    <td style="text-align: center;">33.4</td>
    <td style="text-align: center;">3.1</td>
    <td style="text-align: center;">220</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S9</strong></td>
    <td style="text-align: center;">33.6</td>
    <td style="text-align: center;">53.3</td>
    <td style="text-align: center;">2.7</td>
    <td style="text-align: center;">475</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S10</strong></td>
    <td style="text-align: center;">36.8</td>
    <td style="text-align: center;">40.0</td>
    <td style="text-align: center;">2.9</td>
    <td style="text-align: center;">248</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S11</strong></td>
    <td style="text-align: center;">11.8</td>
    <td style="text-align: center;">31.0</td>
    <td style="text-align: center;">5.1</td>
    <td style="text-align: center;">195</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S12</strong></td>
    <td style="text-align: center;">9.0</td>
    <td style="text-align: center;">5.5</td>
    <td style="text-align: center;">5.7</td>
    <td style="text-align: center;">320</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S13</strong></td>
    <td style="text-align: center;">35.0</td>
    <td style="text-align: center;">46.0</td>
    <td style="text-align: center;">2.7</td>
    <td style="text-align: center;">267</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S14</strong></td>
    <td style="text-align: center;">9.4</td>
    <td style="text-align: center;">5.3</td>
    <td style="text-align: center;">4.5</td>
    <td style="text-align: center;">328</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>S15</strong></td>
    <td style="text-align: center;">15.0</td>
    <td style="text-align: center;">23.0</td>
    <td style="text-align: center;">7.6</td>
    <td style="text-align: center;">131</td>
  </tr>
</table>
{% endfold %}

要使净收益尽可能大，总体风险尽可能小，这是一个多目标的规划模型：

$$
    \begin{gather*}
        \max \ Q(x) = r_0 x_0 + \sum_{i=1}^n r_ix_i - \sum_{i=1}^n p_iy_i,
            \ i=1,2,\ldots,n \\
        \min \ F(x) = \max\limits_{1\leqslant i\leqslant n}\{q_ix_i\}
    \end{gather*}
$$

这里仅考虑模型的一种简化情形：投资者承受风险的程度不同，故给定风险一个界限 $a$，使得所有风险率均小于此值，即 $q_ix_i \leqslant Ma (i=1,2,\ldots,n)$。所以目标函数中最小化风险的要求转化为其中一个约束条件。

约束条件为：

$$
    \begin{cases}
        \displaystyle \sum_{i=1}^nx_i + \sum_{i=1}^n p_iy_i = M, & i=1,2,\cdots,n\\
        \displaystyle x_i \geqslant 0, & i=1,2,\cdots,n\\
        \displaystyle y_i = \begin{cases}
            x_i, &x_i>u_i\\
            u_i, &0<x_i\leqslant u_i\\
            0, &x_i=0
        \end{cases}, & i=1,2,\cdots, n
    \end{cases}
$$

由于约束条件中含有分段函数，这时可引入 0 - 1 变量将模型转化为混合整数线性规划模型，但也可以利用 Lingo 中的 `@if` 函数来构造条件，但模型为非线性规划模型。

{% fold "混合整数线性规划模型 Lingo 程序" %}
{% codeblock lang:matlab %}
model:
    sets:
        S/1..15/:x,y,r,p,q,u,z1,z2,z3,b1,b2,b3;
    endsets

    data:
        M=4000;
        bili=0.05;
        r0=5;
        r=9.6 18.5 49.4 23.9 8.1 14 40.7 31.2 33.6 36.8 11.8 9 35 9.4 15;
        q=42 54 60 42 1.2 39 68 33.4 53.3 40 31 5.5 46 5.3 23;
        p=2.1 3.2 6 1.5 7.6 3.4 5.6 3.1 2.7 2.9 5.1 5.7 2.7 4.5 7.6;
        u=181 407 428 549 270 397 178 220 475 248 195 320 267 328 131;
    enddata

    max=r0*x0/100+@Sum(S:r*x/100)-@Sum(S:p*y/100);
    @For(S:q*x/100<M*bili);
    x0+@Sum(S:x)+@Sum(S:p*y/100)=M;

    @For(S:y=z1+z2+z3);
    @For(S:b1+b2+b3=1);
    @For(S:u-x<2*M*(1-b1)); @For(S:x-M<2*M*(1-b1));
    @For(S:-x<2*M*(1-b2)); @For(S:x-u<2*M*(1-b2));
    @For(S:-x<2*M*(1-b3)); @For(S:x<2*M*(1-b3));

    @For(S:-2*M*b1<z1); @For(S:z1<2*M*b1);
    @For(S:x-2*M*(1-b1)<z1); @For(S:z1<x+2*M*(1-b1));
    @For(S:-2*M*b2<z2); @For(S:z2<2*M*b2);
    @For(S:u-2*M*(1-b2)<z2); @For(S:z2<u+2*M*(1-b2));
    @For(S:z3=0);

    @For(S:@Bin(b1));
    @For(S:@Bin(b2));
    @For(S:@Bin(b3));
end
{% endcodeblock %}
{% endfold %}

{% fold "非线性规划模型 Lingo 程序" %}
{% codeblock lang:matlab %}
model:
    sets:
        assets/1..15/: x, y, r, q, p, u;
    endsets
    data:
        M = 4000;
        r0 = 5;
        a = 0.05;
        r =  9.6 18.5 49.4 23.9  8.1
            14.0 40.7 31.2 33.6 36.8
            11.8  9.0 35.0  9.4 15.0;
        q = 42  54   60   42 1.2
            39  68 33.4 53.3  40
            31 5.5   46  5.3  23;
        p = 2.1 3.2 6.0 1.5 7.6
            3.4 5.6 3.1 2.7 2.9
            5.1 5.7 2.7 4.5 7.6;
        u = 181 407 428 549 270
            397 178 220 475 248
            195 320 267 328 131;
    enddata

    max=(x0*r0+@sum(assets: r*x-p*y))/100;
    @for(assets: y=@if(x #le# u, @if(x #eq# 0, 0, u), x));
    @for(assets: q*x/100<=M*a);
    x0+@sum(assets: x)+@sum(assets: p*y/100)=M;
end
{% endcodeblock %}
{% endfold %}

程序输出结果如下：

| Variable | Value    | Variable | Value    | Variable | Value    | Variable | Value    |
| :---:    | :---:    | :---:    | :---:    | :---:    | :---:    | :---:    | :---:    |
| **X0**   | 0        | **X4**   | 476.1905 | **X8**   | 598.8024 | **X12**  | 0        |
| **S1**   | 0        | **X5**   | 0        | **X9**   | 375.2345 | **X13**  | 434.7826 |
| **X2**   | 370.3704 | **X6**   | 479.8182 | **X10**  | 500      | **X14**  | 0        |
| **X3**   | 333.3333 | **X7**   | 294.1176 | **X11**  | 0        | **X15**  | 0        |

在此种投资组合下，收益 1045.604 元。

#### 分段函数处理方法
上述关于混合整数线性规划模型的 Lingo 程序中引入不少中间决策变量，这里对其展开讨论，下面内容节选自余胜威《MATLAB 数学建模经典案例实战》。（部分改动）

{% note info %}
设有限区间的有界分段函数：

$$
    y = f(x) = \begin{cases}
            \varphi_1(x), & x\in(a_1, b_1) & \\
            \varphi_2(x), & x\in(a_2, b_2) & \\
            \hfil \cdots \\
            \varphi_n(x), & x\in(a_n, b_n) & \\
        \end{cases}, \quad
        a_1 < b_1 \leqslant a_2 < b_2 \leqslant \cdots \leqslant a_n < b_n
$$

等价为：

$$
    \begin{cases}
        y = y_1 + y_2 + \cdots y_n \\
        \delta_1 + \delta_2 + \cdots + \delta_n = 1, \delta_i \in \{0,1\} \\
        x - a_i \geqslant -(1-\delta_i)L_x \\
        x - b_i \leqslant (1-\delta_i)U_x \\
        -\delta_i L_{y1} \leqslant y_i \leqslant \delta_i U_{y1} \\
        -(1-\delta_i) L_{y2} \leqslant y_i-\varphi_i(x)
        \leqslant (1-\delta_i) U_{y2}
    \end{cases}
$$
{% endnote %}

其中 $\delta_i$ 表明 $x$ 所处区间，通过上述约束条件中的第 3、4 式保证。具体而言，给定 $i\in\{1,\ldots,n\}$，若 $x \in (a_i, b_i)$，必然有 $x-a_i \geqslant 0$ 以及 $x-b_i \leqslant 0$；对其他区间而言，有 $x-a_i \geqslant -L$，以及 $x-b_i \leqslant U$，其中 $U, L > 0$ 分别为 $x$ 支撑集的上限和下限的绝对值。引入 0 - 1 变量 $\delta_i$（类似于概率论中示性函数），对于任何区间，整合上述不等式，即为 3、4 式。注意到给定的 $x$ 仅会落入一个区间，故 $\sum \delta_i = 1$（2 式）。对于 $y_i$，讨论类似。当然为简单起见，可将所有界限以它们的最大值代替。

乍看求解模型被复杂化，但把可能为非线性规划的问题转为了混合整数线性规划问题，加快求解收敛速度。

-----------------------------

### 计划排序模型

完成某产品的装配过程需要 11 项任务（用 A ~ K 表示），每项任务所花费的时间如下：

<table>
  <tr>
    <td><strong>任务</strong></td>
    <td><strong>A</strong></td>
    <td><strong>B</strong></td>
    <td><strong>C</strong></td>
    <td><strong>D</strong></td>
    <td><strong>E</strong></td>
    <td><strong>F</strong></td>
  </tr>
  <tr>
    <td><strong>时间</strong></td>
    <td>45</td>
    <td>11</td>
    <td>9</td>
    <td>50</td>
    <td>15</td>
    <td>12</td>
  </tr>
  <tr>
    <td><strong>任务</strong></td>
    <td><strong>G</strong></td>
    <td><strong>H</strong></td>
    <td><strong>I</strong></td>
    <td><strong>J</strong></td>
    <td><strong>K</strong></td>
    <td></td>
  </tr>
  <tr>
    <td><strong>时间</strong></td>
    <td>12</td>
    <td>12</td>
    <td>12</td>
    <td>8</td>
    <td>9</td>
    <td></td>
  </tr>
</table>

各项任务之间存在先后顺序如下图所示。装配流水线有四个顺序工作站，对于有先后次序的任务，只能在流水线上向后传（如任务 B 和 C 的次序为先 B 后 C，如果安排 B 给第 3 站做，则 C 要么由 B 自己完成，要么传给第 4 站来做，而不能交往 1 或 2 号站），每项任务必须只能分配至一个工作站来做。合理分配生产计划，使整个装配周期最短。

<img src="/img/task_priority.svg" width="50%">

记 $x_{ik}$ 表示将任务 $i\ (i=A,B,\ldots,K)$ 分配给工作站 $k\ (k=1,2,3,4)$ 的情况，1 表示分配，0 表示不分配，$t_i$ 表示完成各项任务所需时间。则目标函数为 $\min\ T = \max\limits_{1\leqslant k \leqslant 4} \sum\limits_{i=1}^{11} t_ix_{ik}$。由每项任务只能分配给一个工作站来做，故对所有任务 $i$ 有：$\sum\limits_{k=1}^4 x_{ik}=1$。对于任务间的优先级，考虑任务 $i$ 先于任务 $j$，则可行的任务安排表 (11 × 4) 有：

\begin{array}{ccccc}
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i & 1 &   &   &   \\
    j & 1 &   &   &   \\
    \Delta  & 0 & 0 & 0 & 0 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i & 1 &   &   &   \\
    j &   & 1 &   &   \\
    \Delta  & -1 & 1 & 0 & 0 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i & 1 &   &   &   \\
    j &   &   & 1 &   \\
    \Delta  & -1 & 0 & 1 & 0 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i & 1 &   &   &   \\
    j &   &   &   & 1 \\
    \Delta  & -1 & 0 & 0 & 1 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i &   & 1 &   &   \\
    j &   & 1 &   &   \\
    \Delta  & 0 & 0 & 0 & 0 \\
    \hline
\end{array} \\[15pt]
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i &   & 1 &   &   \\
    j &   &   & 1 &   \\
    \Delta  & 0 & -1 & 1 & 0 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i &   & 1 &   &   \\
    j &   &   &   & 1 \\
    \Delta  & 0 & -1 & 0 & 1 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i &   &   & 1 &   \\
    j &   &   & 1 &   \\
    \Delta  & 0 & 0 & 0 & 0 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i &   &   & 1 &   \\
    j &   &   &   & 1 \\
    \Delta  & 0 & 0 & -1 & 1 \\
    \hline
\end{array}
&
\begin{array}{ccccc}
    \hline
      & 1 & 2 & 3 & 4 \\
    \hline
    i &   &   &   & 1  \\
    j &   &   &   & 1 \\
    \Delta  & 0 & 0 & 0 & 0 \\
    \hline
\end{array}
\end{array}

其中最后一行为任务 $j$ 的分配数与任务 $i$ 的分配数之差。对每个工作站引入权重 $f_k = k$，可发现上述所有情况均满足 $\sum\limits_{i=k}^4 f_k\Delta_k \geqslant 0$，通过进一步试验可归纳任何一种「任务 $j$ 优先于任务 $i$」的分配方案均不满足上述等式。
于是对所有 $i$ 优先于 $j$：$\sum\limits_{k=1}^4 k(x_{jk}-x_{ik}) \geqslant 0$。

至此，该模型是一个非线性规划，但可进一步转为线性规划。增加约束条件：$\sum\limits_{i=1}^{11}t_ix_{ik} \leqslant Z$，目标函数变为 $\min \ Z$。两种模型的迭代次数分别为 147 (MILP)、590 (PINLP)。

{% fold '计划排序模型 Lingo 程序' %}
```matlab
model:
    sets:
        task/A..K/:t;
        prio(task, task)/A,B B,C C,F C,G D,E E,H E,I F,J G,J H,J I,J J,K/;
        station/1..4/;
        txs(task, station):x;
    endsets

    data:
        t = 45 11 9 50 15 12 12 12 12 8 9;
    enddata

    ! 注释行为非线性规划方案;
    ! min=@max(station(k): @sum(task(i): t(i)*x(i, k))); ;
    min=Z;
    @for(station(k): @sum(task(i): t(i)*x(i, k))<=Z);
    @for(task(i): @sum(station(j): x(i, j)) = 1);
    @for(prio(i, j): @sum(station(k): k*(x(j, k)-x(i, k)))>=0);
    @for(txs: @bin(x));
end
```
{% endfold %}

----------------------------------

### 配对模型

将 8 个职员安排到 4 个办公室，每室两人。同事两两之间的相容程度如下（数字越小代表相容越好）

$$
\begin{array}{c|cccccccc}
    \hline
        & S_1 & S_2 & S_3 & S_4 & S_5 & S_6 & S_7 & S_8 \\
    \hline
    S_1 & -   & 9   & 3   & 4   & 2   & 1   & 5   & 6   \\
    S_2 & -   & -   & 1   & 7   & 3   & 5   & 2   & 1   \\
    S_3 & -   & -   & -   & 4   & 4   & 2   & 9   & 2   \\
    S_4 & -   & -   & -   & -   & 1   & 5   & 5   & 2   \\
    S_5 & -   & -   & -   & -   & -   & 8   & 7   & 6   \\
    S_6 & -   & -   & -   & -   & -   & -   & 2   & 3   \\
    S_7 & -   & -   & -   & -   & -   & -   & -   & 4   \\
    S_8 & -   & -   & -   & -   & -   & -   & -   & -   \\
    \hline
\end{array}
$$

安排配对方案，使组合的总相容程度最好。

引入决策矩阵 $X$，元素 $X_{ij} \in \{0, 1\}$，每人组合一次，说明对于每个职员 $i$，必有 $\sum\limits_{j=i \ \text{or}\ k=i}X_{jk} = 1$，所以模型为：

$$
    \begin{array}{cl}
        \min & \sum\limits_{i<j} C_{ij} X_{ij} \\
        \text{s.t.} & \begin{cases}
            \sum\limits_{j=i \ \text{or}\ k=i}X_{jk} = 1, & i=1,2,\ldots,8 \\
            X_{ij} = 0 \ \text{or} \ 1, & i<j
        \end{cases}
    \end{array}
$$

{% fold '配对模型 Lingo 程序' %}
```matlab
model:
    sets:
        people/1..8/;
        links(people, people) | &2 #gt# &1: tol, x;
    endsets

    data:
        tol = 9 3 4 2 1 5 6
                1 7 3 5 2 1
                  4 4 2 9 2
                    1 5 5 2
                      8 7 6
                        2 3
                          4;
    enddata

    @for(people(i): @sum(links(j, k) | j #eq# i #or# k #eq# i: x(j, k)) = 1);
    @for(links: @bin(x));
    min = @sum(links: x*tol);
end
```
{% endfold %}

--------------------------

### 下料问题

钢管原材料每根长 19m，现需要 A、B、C、D 四种钢管部件，长度分别为 4m、5m、6m、8m，数量分别为 50、10、20、15 根，不同的下料方式不超过 3 种，安排下料方式使得所需钢管原材料最少。

一般化问题，假设用到 $k$ 种下料方式，用 $x_i\ (i=1,2,\ldots,k)$ 表示第 $i$ 种下料方式所切割的原料钢管数量，非负整数 $n_{ij}$ 表示第 $i$ 种下料方法得到部件 $j\ (j=1,2,\ldots,m)$ 的数量，$b_j$ 表示第 $j$ 种部件的需求量。$L$ 表示钢管材料的长度，$l_j$ 表示部件长度，则下料方式应满足：1) 切割出的部件总长度不超过 $L$；2) 余料严格小于 $\min \{l_j\}$。故建立优化模型：

$$
\begin{array}{cl}
    {\min} & z = \sum\limits_{i=1}^k x_i \\
    \text{s.t.} & \begin{cases}
        \sum\limits_{i=1}^k n_{ij}x_i \geqslant b_j, & j=1,2,\ldots,m \\
        L - \min\{n_{ij}\} < \sum\limits_{j=1}^m n_{ij}l_j \leqslant L, & i=1,2,\ldots,k \\
        x_{i}, n_{ij} \in \mathbb{N}, & i=1,2,\ldots,k; \ j=1,2,\ldots,m
    \end{cases}
\end{array}
$$

在此问题中 $k=3, m=4$。

{% fold '下料问题 Lingo 程序' %}
```matlab
model:
    sets:
        ! craft(1~k): 工艺, 即切割方式 ;
        ! material(1~m): 不同部件数量 ;
        ! links: 每种切割方式下不同部件数量 ;
        craft/1..3/: x;
        material/1..4/: m, b;
        links(craft, material): n;
    endsets

    data:
        m = 4 5 6 8;
        b = 50 10 20 15;
        L = 19;
    enddata

    min = @sum(craft: x);
    @for(material(j): @sum(craft(i): n(i, j)*x(i))>=b(j));
    @for(craft(i): @sum(material(j): n(i, j)*m(j))<=L);
    @for(craft(i): @sum(material(j): n(i, j)*m(j))>=16);
    @for(craft: @gin(x));
    @for(links: @gin(n));
end
```
{% endfold %}

求解结果如下：

<table>
  <tr>
    <td style="text-align: center;" rowspan="2"><strong>下料方式</strong></td>
    <td style="text-align: center;" colspan="4"><strong>部件长度<br></strong></td>
    <td style="text-align: center;" rowspan="2"><strong>余料长度</strong></td>
    <td style="text-align: center;" rowspan="2"><strong>切割根数</strong></td>
  </tr>
  <tr>
    <td style="text-align: center;">4m</td>
    <td style="text-align: center;">5m</td>
    <td style="text-align: center;">6m</td>
    <td style="text-align: center;">8m</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>方式一</strong></td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">2</td>
    <td style="text-align: center;">3</td>
    <td style="text-align: center;">8</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>方式二</strong></td>
    <td style="text-align: center;">2</td>
    <td style="text-align: center;">1</td>
    <td style="text-align: center;">1</td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">10</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>方式三</strong></td>
    <td style="text-align: center;">3</td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">1</td>
    <td style="text-align: center;">0</td>
    <td style="text-align: center;">1</td>
    <td style="text-align: center;">10</td>
  </tr>
  <tr>
    <td style="text-align: center;"><strong>合计</strong></td>
    <td style="text-align: center;">50</td>
    <td style="text-align: center;">10</td>
    <td style="text-align: center;">20</td>
    <td style="text-align: center;">16</td>
    <td style="text-align: center;">34m</td>
    <td style="text-align: center;">28</td>
  </tr>
</table>

注意到上述切割方案余料总长 34m，且多出一根 8m 长的部件。



[lingo-notepad++]: http://bbs.pinggu.org/thread-3875796-1-1.html
[essentials-of-matlab-examples]: /essentials-of-matlab-examples#mjx-eqn-J
