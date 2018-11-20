---
title: Matlab 程序设计之作图
date: 2018-07-06 20:42:34
tags:
    - Matlab
categories: Memos
mathjax: true
---

Matlab 画图质量随着版本号迭代有着显著提升，而且入门较简单。

<!-- more -->

比如这个「奥运五环」：

```matlab
a = 2;
r = 1.2;
hold on;
theta = linspace(0, 2 * pi).';
X = [-a, 0, a, a / 2, -a / 2];
Y = [0, 0, 0, -sqrt(2) / 2 * a, -sqrt(2) / 2 * a];
plot([X, X(1)], [Y, Y(1)], '.--', 'markersize', 20);
circles = plot((X + Y * 1i) + r * exp(theta * 1i), 'linewidth', 5);
% circles = plot(X+r*cos(theta), Y+r*sin(theta), 'linewidth', 5);
set(circles, {'color'}, num2cell('bkrgy')');
axis off equal;
hold off;
saveas(gcf, 'olympic-rings.svg');
```

<img src="/img/olympic-rings.svg" width="45%">

其中利用极坐标画圆有点意思，由于 `plot` 函数能直接对复数的实数 - 虚数对进行绘图，所以通过
$$
    x+r\cos\theta + \mathrm{i}\, (y+r\sin\theta)
    = r e^{\mathrm i\, \theta} + (x + \mathrm i\, y)
$$
也能绘制出圆形。另外批量对线条改变颜色的代码参考了 [Explicitly specifying line colors when plotting a matrix](https://ww2.mathworks.cn/matlabcentral/answers/19815-explicitly-specifying-line-colors-when-plotting-a-matrix)。

------------------------------------

交互图形的制作也十分方便。对于定积分 $\displaystyle I = \int_0^{\frac 12} \frac{1}{1+x^3}\, \mathrm dx$ 考察其被积函数以及其 $5$ 阶 Taylor 展开函数的图形。

```matlab
syms x;
f = 1 / (1 + x ^ 3);
I1 = int(f, 0, 1/2);
ft = taylor(f, 'order', 6);
I2 = int(ft, 0, 1/2);
fpl = fplot([f, ft], [0, 1/2]);
set(gca, 'fontname', 'Euclid', 'fontweight', 'bold');
set(fpl, 'linewidth', 1.2, {'linestyle'}, {'-'; '--'}, 'color', 'k');
legend({['$$f=', latex(f), '$$'], ['$$f_{\rm Taylor}=', latex(ft), '$$']}, ...
       'interpreter', 'latex', 'fontsize', 11);
gtext({['$$\int_0^{\frac 12}', latex(f), '\, \mathrm dx=', latex(I1), ...
        '\approx', latex(vpa(I1, 4)), '$$'], ...
       ['$$\int_0^{\frac 12}\left(', latex(ft), '\right)\, \mathrm dx=', ...
        latex(I2), '\approx', latex(vpa(I2, 4)), '$$']}, ...
      'interpreter', 'latex', 'fontsize', 11);
box off;
```

<img src="/img/integrate(1+x3).svg" width="45%">

